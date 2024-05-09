1 /*
2  * Crypto stamp Bridge Head
3  * Core element of the Crypto Stamp Bridge, an off-chain service connects the
4  * bridge heads on both sides to form the actual bridge system. Deposited
5  * tokens are actually owned by a separate token holder contract, but
6  * pull-based deposits are enacted via this bridge head contract as well.
7  *
8  * Developed by Capacity Blockchain Solutions GmbH <capacity.at>
9  * for Österreichische Post AG <post.at>
10  *
11  * Any usage of or interaction with this set of contracts is subject to the
12  * Terms & Conditions available at https://crypto.post.at/
13  */
14 
15 // SPDX-License-Identifier: UNLICENSED
16 
17 pragma solidity ^0.8.0;
18 
19 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
20 
21 /**
22  * @dev Interface of the ERC20 standard as defined in the EIP.
23  */
24 interface IERC20 {
25     /**
26      * @dev Returns the amount of tokens in existence.
27      */
28     function totalSupply() external view returns (uint256);
29 
30     /**
31      * @dev Returns the amount of tokens owned by `account`.
32      */
33     function balanceOf(address account) external view returns (uint256);
34 
35     /**
36      * @dev Moves `amount` tokens from the caller's account to `recipient`.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * Emits a {Transfer} event.
41      */
42     function transfer(address recipient, uint256 amount) external returns (bool);
43 
44     /**
45      * @dev Returns the remaining number of tokens that `spender` will be
46      * allowed to spend on behalf of `owner` through {transferFrom}. This is
47      * zero by default.
48      *
49      * This value changes when {approve} or {transferFrom} are called.
50      */
51     function allowance(address owner, address spender) external view returns (uint256);
52 
53     /**
54      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * IMPORTANT: Beware that changing an allowance with this method brings the risk
59      * that someone may use both the old and the new allowance by unfortunate
60      * transaction ordering. One possible solution to mitigate this race
61      * condition is to first reduce the spender's allowance to 0 and set the
62      * desired value afterwards:
63      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
64      *
65      * Emits an {Approval} event.
66      */
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Moves `amount` tokens from `sender` to `recipient` using the
71      * allowance mechanism. `amount` is then deducted from the caller's
72      * allowance.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * Emits a {Transfer} event.
77      */
78     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Emitted when `value` tokens are moved from one account (`from`) to
82      * another (`to`).
83      *
84      * Note that `value` may be zero.
85      */
86     event Transfer(address indexed from, address indexed to, uint256 value);
87 
88     /**
89      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
90      * a call to {approve}. `value` is the new allowance.
91      */
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
96 
97 /**
98  * @dev Interface of the ERC165 standard, as defined in the
99  * https://eips.ethereum.org/EIPS/eip-165[EIP].
100  *
101  * Implementers can declare support of contract interfaces, which can then be
102  * queried by others ({ERC165Checker}).
103  *
104  * For an implementation, see {ERC165}.
105  */
106 interface IERC165 {
107     /**
108      * @dev Returns true if this contract implements the interface defined by
109      * `interfaceId`. See the corresponding
110      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
111      * to learn more about how these ids are created.
112      *
113      * This function call must use less than 30 000 gas.
114      */
115     function supportsInterface(bytes4 interfaceId) external view returns (bool);
116 }
117 
118 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
119 
120 /**
121  * @dev Required interface of an ERC721 compliant contract.
122  */
123 interface IERC721 is IERC165 {
124     /**
125      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
126      */
127     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
128 
129     /**
130      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
131      */
132     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
133 
134     /**
135      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
136      */
137     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
138 
139     /**
140      * @dev Returns the number of tokens in ``owner``'s account.
141      */
142     function balanceOf(address owner) external view returns (uint256 balance);
143 
144     /**
145      * @dev Returns the owner of the `tokenId` token.
146      *
147      * Requirements:
148      *
149      * - `tokenId` must exist.
150      */
151     function ownerOf(uint256 tokenId) external view returns (address owner);
152 
153     /**
154      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
155      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
156      *
157      * Requirements:
158      *
159      * - `from` cannot be the zero address.
160      * - `to` cannot be the zero address.
161      * - `tokenId` token must exist and be owned by `from`.
162      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
163      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
164      *
165      * Emits a {Transfer} event.
166      */
167     function safeTransferFrom(address from, address to, uint256 tokenId) external;
168 
169     /**
170      * @dev Transfers `tokenId` token from `from` to `to`.
171      *
172      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
173      *
174      * Requirements:
175      *
176      * - `from` cannot be the zero address.
177      * - `to` cannot be the zero address.
178      * - `tokenId` token must be owned by `from`.
179      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
180      *
181      * Emits a {Transfer} event.
182      */
183     function transferFrom(address from, address to, uint256 tokenId) external;
184 
185     /**
186      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
187      * The approval is cleared when the token is transferred.
188      *
189      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
190      *
191      * Requirements:
192      *
193      * - The caller must own the token or be an approved operator.
194      * - `tokenId` must exist.
195      *
196      * Emits an {Approval} event.
197      */
198     function approve(address to, uint256 tokenId) external;
199 
200     /**
201      * @dev Returns the account approved for `tokenId` token.
202      *
203      * Requirements:
204      *
205      * - `tokenId` must exist.
206      */
207     function getApproved(uint256 tokenId) external view returns (address operator);
208 
209     /**
210      * @dev Approve or remove `operator` as an operator for the caller.
211      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
212      *
213      * Requirements:
214      *
215      * - The `operator` cannot be the caller.
216      *
217      * Emits an {ApprovalForAll} event.
218      */
219     function setApprovalForAll(address operator, bool _approved) external;
220 
221     /**
222      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
223      *
224      * See {setApprovalForAll}
225      */
226     function isApprovedForAll(address owner, address operator) external view returns (bool);
227 
228     /**
229       * @dev Safely transfers `tokenId` token from `from` to `to`.
230       *
231       * Requirements:
232       *
233       * - `from` cannot be the zero address.
234       * - `to` cannot be the zero address.
235       * - `tokenId` token must exist and be owned by `from`.
236       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
237       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
238       *
239       * Emits a {Transfer} event.
240       */
241     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
242 }
243 
244 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
245 
246 /**
247  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
248  * @dev See https://eips.ethereum.org/EIPS/eip-721
249  */
250 interface IERC721Metadata is IERC721 {
251 
252     /**
253      * @dev Returns the token collection name.
254      */
255     function name() external view returns (string memory);
256 
257     /**
258      * @dev Returns the token collection symbol.
259      */
260     function symbol() external view returns (string memory);
261 
262     /**
263      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
264      */
265     function tokenURI(uint256 tokenId) external view returns (string memory);
266 }
267 
268 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
269 
270 /**
271  * @dev Required interface of an ERC1155 compliant contract, as defined in the
272  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
273  *
274  * _Available since v3.1._
275  */
276 interface IERC1155 is IERC165 {
277     /**
278      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
279      */
280     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
281 
282     /**
283      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
284      * transfers.
285      */
286     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
287 
288     /**
289      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
290      * `approved`.
291      */
292     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
293 
294     /**
295      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
296      *
297      * If an {URI} event was emitted for `id`, the standard
298      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
299      * returned by {IERC1155MetadataURI-uri}.
300      */
301     event URI(string value, uint256 indexed id);
302 
303     /**
304      * @dev Returns the amount of tokens of token type `id` owned by `account`.
305      *
306      * Requirements:
307      *
308      * - `account` cannot be the zero address.
309      */
310     function balanceOf(address account, uint256 id) external view returns (uint256);
311 
312     /**
313      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
314      *
315      * Requirements:
316      *
317      * - `accounts` and `ids` must have the same length.
318      */
319     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
320 
321     /**
322      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
323      *
324      * Emits an {ApprovalForAll} event.
325      *
326      * Requirements:
327      *
328      * - `operator` cannot be the caller.
329      */
330     function setApprovalForAll(address operator, bool approved) external;
331 
332     /**
333      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
334      *
335      * See {setApprovalForAll}.
336      */
337     function isApprovedForAll(address account, address operator) external view returns (bool);
338 
339     /**
340      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
341      *
342      * Emits a {TransferSingle} event.
343      *
344      * Requirements:
345      *
346      * - `to` cannot be the zero address.
347      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
348      * - `from` must have a balance of tokens of type `id` of at least `amount`.
349      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
350      * acceptance magic value.
351      */
352     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
353 
354     /**
355      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
356      *
357      * Emits a {TransferBatch} event.
358      *
359      * Requirements:
360      *
361      * - `ids` and `amounts` must have the same length.
362      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
363      * acceptance magic value.
364      */
365     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
366 }
367 
368 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
369 
370 /**
371  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
372  *
373  * These functions can be used to verify that a message was signed by the holder
374  * of the private keys of a given address.
375  */
376 library ECDSA {
377     /**
378      * @dev Returns the address that signed a hashed message (`hash`) with
379      * `signature`. This address can then be used for verification purposes.
380      *
381      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
382      * this function rejects them by requiring the `s` value to be in the lower
383      * half order, and the `v` value to be either 27 or 28.
384      *
385      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
386      * verification to be secure: it is possible to craft signatures that
387      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
388      * this is by receiving a hash of the original message (which may otherwise
389      * be too long), and then calling {toEthSignedMessageHash} on it.
390      */
391     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
392         // Check the signature length
393         if (signature.length != 65) {
394             revert("ECDSA: invalid signature length");
395         }
396 
397         // Divide the signature in r, s and v variables
398         bytes32 r;
399         bytes32 s;
400         uint8 v;
401 
402         // ecrecover takes the signature parameters, and the only way to get them
403         // currently is to use assembly.
404         // solhint-disable-next-line no-inline-assembly
405         assembly {
406             r := mload(add(signature, 0x20))
407             s := mload(add(signature, 0x40))
408             v := byte(0, mload(add(signature, 0x60)))
409         }
410 
411         return recover(hash, v, r, s);
412     }
413 
414     /**
415      * @dev Overload of {ECDSA-recover} that receives the `v`,
416      * `r` and `s` signature fields separately.
417      */
418     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
419         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
420         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
421         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
422         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
423         //
424         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
425         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
426         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
427         // these malleable signatures as well.
428         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
429         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
430 
431         // If the signature is valid (and not malleable), return the signer address
432         address signer = ecrecover(hash, v, r, s);
433         require(signer != address(0), "ECDSA: invalid signature");
434 
435         return signer;
436     }
437 
438     /**
439      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
440      * produces hash corresponding to the one signed with the
441      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
442      * JSON-RPC method as part of EIP-191.
443      *
444      * See {recover}.
445      */
446     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
447         // 32 is the length in bytes of hash,
448         // enforced by the type signature above
449         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
450     }
451 
452     /**
453      * @dev Returns an Ethereum Signed Typed Data, created from a
454      * `domainSeparator` and a `structHash`. This produces hash corresponding
455      * to the one signed with the
456      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
457      * JSON-RPC method as part of EIP-712.
458      *
459      * See {recover}.
460      */
461     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
462         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
463     }
464 }
465 
466 // File: @openzeppelin/contracts/utils/Address.sol
467 
468 /**
469  * @dev Collection of functions related to the address type
470  */
471 library Address {
472     /**
473      * @dev Returns true if `account` is a contract.
474      *
475      * [IMPORTANT]
476      * ====
477      * It is unsafe to assume that an address for which this function returns
478      * false is an externally-owned account (EOA) and not a contract.
479      *
480      * Among others, `isContract` will return false for the following
481      * types of addresses:
482      *
483      *  - an externally-owned account
484      *  - a contract in construction
485      *  - an address where a contract will be created
486      *  - an address where a contract lived, but was destroyed
487      * ====
488      */
489     function isContract(address account) internal view returns (bool) {
490         // This method relies on extcodesize, which returns 0 for contracts in
491         // construction, since the code is only stored at the end of the
492         // constructor execution.
493 
494         uint256 size;
495         // solhint-disable-next-line no-inline-assembly
496         assembly { size := extcodesize(account) }
497         return size > 0;
498     }
499 
500     /**
501      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
502      * `recipient`, forwarding all available gas and reverting on errors.
503      *
504      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
505      * of certain opcodes, possibly making contracts go over the 2300 gas limit
506      * imposed by `transfer`, making them unable to receive funds via
507      * `transfer`. {sendValue} removes this limitation.
508      *
509      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
510      *
511      * IMPORTANT: because control is transferred to `recipient`, care must be
512      * taken to not create reentrancy vulnerabilities. Consider using
513      * {ReentrancyGuard} or the
514      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
515      */
516     function sendValue(address payable recipient, uint256 amount) internal {
517         require(address(this).balance >= amount, "Address: insufficient balance");
518 
519         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
520         (bool success, ) = recipient.call{ value: amount }("");
521         require(success, "Address: unable to send value, recipient may have reverted");
522     }
523 
524     /**
525      * @dev Performs a Solidity function call using a low level `call`. A
526      * plain`call` is an unsafe replacement for a function call: use this
527      * function instead.
528      *
529      * If `target` reverts with a revert reason, it is bubbled up by this
530      * function (like regular Solidity function calls).
531      *
532      * Returns the raw returned data. To convert to the expected return value,
533      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
534      *
535      * Requirements:
536      *
537      * - `target` must be a contract.
538      * - calling `target` with `data` must not revert.
539      *
540      * _Available since v3.1._
541      */
542     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
543       return functionCall(target, data, "Address: low-level call failed");
544     }
545 
546     /**
547      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
548      * `errorMessage` as a fallback revert reason when `target` reverts.
549      *
550      * _Available since v3.1._
551      */
552     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
553         return functionCallWithValue(target, data, 0, errorMessage);
554     }
555 
556     /**
557      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
558      * but also transferring `value` wei to `target`.
559      *
560      * Requirements:
561      *
562      * - the calling contract must have an ETH balance of at least `value`.
563      * - the called Solidity function must be `payable`.
564      *
565      * _Available since v3.1._
566      */
567     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
568         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
569     }
570 
571     /**
572      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
573      * with `errorMessage` as a fallback revert reason when `target` reverts.
574      *
575      * _Available since v3.1._
576      */
577     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
578         require(address(this).balance >= value, "Address: insufficient balance for call");
579         require(isContract(target), "Address: call to non-contract");
580 
581         // solhint-disable-next-line avoid-low-level-calls
582         (bool success, bytes memory returndata) = target.call{ value: value }(data);
583         return _verifyCallResult(success, returndata, errorMessage);
584     }
585 
586     /**
587      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
588      * but performing a static call.
589      *
590      * _Available since v3.3._
591      */
592     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
593         return functionStaticCall(target, data, "Address: low-level static call failed");
594     }
595 
596     /**
597      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
598      * but performing a static call.
599      *
600      * _Available since v3.3._
601      */
602     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
603         require(isContract(target), "Address: static call to non-contract");
604 
605         // solhint-disable-next-line avoid-low-level-calls
606         (bool success, bytes memory returndata) = target.staticcall(data);
607         return _verifyCallResult(success, returndata, errorMessage);
608     }
609 
610     /**
611      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
612      * but performing a delegate call.
613      *
614      * _Available since v3.4._
615      */
616     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
617         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
618     }
619 
620     /**
621      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
622      * but performing a delegate call.
623      *
624      * _Available since v3.4._
625      */
626     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
627         require(isContract(target), "Address: delegate call to non-contract");
628 
629         // solhint-disable-next-line avoid-low-level-calls
630         (bool success, bytes memory returndata) = target.delegatecall(data);
631         return _verifyCallResult(success, returndata, errorMessage);
632     }
633 
634     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
635         if (success) {
636             return returndata;
637         } else {
638             // Look for revert reason and bubble it up if present
639             if (returndata.length > 0) {
640                 // The easiest way to bubble the revert reason is using memory via assembly
641 
642                 // solhint-disable-next-line no-inline-assembly
643                 assembly {
644                     let returndata_size := mload(returndata)
645                     revert(add(32, returndata), returndata_size)
646                 }
647             } else {
648                 revert(errorMessage);
649             }
650         }
651     }
652 }
653 
654 // File: @openzeppelin/contracts/proxy/Clones.sol
655 
656 /**
657  * @dev https://eips.ethereum.org/EIPS/eip-1167[EIP 1167] is a standard for
658  * deploying minimal proxy contracts, also known as "clones".
659  *
660  * > To simply and cheaply clone contract functionality in an immutable way, this standard specifies
661  * > a minimal bytecode implementation that delegates all calls to a known, fixed address.
662  *
663  * The library includes functions to deploy a proxy using either `create` (traditional deployment) or `create2`
664  * (salted deterministic deployment). It also includes functions to predict the addresses of clones deployed using the
665  * deterministic method.
666  *
667  * _Available since v3.4._
668  */
669 library Clones {
670     /**
671      * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
672      *
673      * This function uses the create opcode, which should never revert.
674      */
675     function clone(address implementation) internal returns (address instance) {
676         // solhint-disable-next-line no-inline-assembly
677         assembly {
678             let ptr := mload(0x40)
679             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
680             mstore(add(ptr, 0x14), shl(0x60, implementation))
681             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
682             instance := create(0, ptr, 0x37)
683         }
684         require(instance != address(0), "ERC1167: create failed");
685     }
686 
687     /**
688      * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
689      *
690      * This function uses the create2 opcode and a `salt` to deterministically deploy
691      * the clone. Using the same `implementation` and `salt` multiple time will revert, since
692      * the clones cannot be deployed twice at the same address.
693      */
694     function cloneDeterministic(address implementation, bytes32 salt) internal returns (address instance) {
695         // solhint-disable-next-line no-inline-assembly
696         assembly {
697             let ptr := mload(0x40)
698             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
699             mstore(add(ptr, 0x14), shl(0x60, implementation))
700             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
701             instance := create2(0, ptr, 0x37, salt)
702         }
703         require(instance != address(0), "ERC1167: create2 failed");
704     }
705 
706     /**
707      * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
708      */
709     function predictDeterministicAddress(address implementation, bytes32 salt, address deployer) internal pure returns (address predicted) {
710         // solhint-disable-next-line no-inline-assembly
711         assembly {
712             let ptr := mload(0x40)
713             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
714             mstore(add(ptr, 0x14), shl(0x60, implementation))
715             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf3ff00000000000000000000000000000000)
716             mstore(add(ptr, 0x38), shl(0x60, deployer))
717             mstore(add(ptr, 0x4c), salt)
718             mstore(add(ptr, 0x6c), keccak256(ptr, 0x37))
719             predicted := keccak256(add(ptr, 0x37), 0x55)
720         }
721     }
722 
723     /**
724      * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
725      */
726     function predictDeterministicAddress(address implementation, bytes32 salt) internal view returns (address predicted) {
727         return predictDeterministicAddress(implementation, salt, address(this));
728     }
729 }
730 
731 // File: contracts/ENSReverseRegistrarI.sol
732 
733 /*
734  * Interfaces for ENS Reverse Registrar
735  * See https://github.com/ensdomains/ens/blob/master/contracts/ReverseRegistrar.sol for full impl
736  * Also see https://github.com/wealdtech/wealdtech-solidity/blob/master/contracts/ens/ENSReverseRegister.sol
737  *
738  * Use this as follows (registryAddress is the address of the ENS registry to use):
739  * -----
740  * // This hex value is caclulated by namehash('addr.reverse')
741  * bytes32 public constant ENS_ADDR_REVERSE_NODE = 0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2;
742  * function registerReverseENS(address registryAddress, string memory calldata) external {
743  *     require(registryAddress != address(0), "need a valid registry");
744  *     address reverseRegistrarAddress = ENSRegistryOwnerI(registryAddress).owner(ENS_ADDR_REVERSE_NODE)
745  *     require(reverseRegistrarAddress != address(0), "need a valid reverse registrar");
746  *     ENSReverseRegistrarI(reverseRegistrarAddress).setName(name);
747  * }
748  * -----
749  * or
750  * -----
751  * function registerReverseENS(address reverseRegistrarAddress, string memory calldata) external {
752  *    require(reverseRegistrarAddress != address(0), "need a valid reverse registrar");
753  *     ENSReverseRegistrarI(reverseRegistrarAddress).setName(name);
754  * }
755  * -----
756  * ENS deployments can be found at https://docs.ens.domains/ens-deployments
757  * E.g. Etherscan can be used to look up that owner on those contracts.
758  * namehash.hash("addr.reverse") == "0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2"
759  * Ropsten: ens.owner(namehash.hash("addr.reverse")) == "0x6F628b68b30Dc3c17f345c9dbBb1E483c2b7aE5c"
760  * Mainnet: ens.owner(namehash.hash("addr.reverse")) == "0x084b1c3C81545d370f3634392De611CaaBFf8148"
761  */
762 
763 interface ENSRegistryOwnerI {
764     function owner(bytes32 node) external view returns (address);
765 }
766 
767 interface ENSReverseRegistrarI {
768     event NameChanged(bytes32 indexed node, string name);
769     /**
770      * @dev Sets the `name()` record for the reverse ENS record associated with
771      * the calling account.
772      * @param name The name to set for this address.
773      * @return The ENS node hash of the reverse record.
774      */
775     function setName(string calldata name) external returns (bytes32);
776 }
777 
778 // File: contracts/BridgeDataI.sol
779 
780 /*
781  * Interface for data storage of the bridge.
782  */
783 
784 interface BridgeDataI {
785 
786     event AddressChanged(string name, address previousAddress, address newAddress);
787     event ConnectedChainChanged(string previousConnectedChainName, string newConnectedChainName);
788     event TokenURIBaseChanged(string previousTokenURIBase, string newTokenURIBase);
789     event TokenSunsetAnnounced(uint256 indexed timestamp);
790 
791     /**
792      * @dev The name of the chain connected to / on the other side of this bridge head.
793      */
794     function connectedChainName() external view returns (string memory);
795 
796     /**
797      * @dev The name of our own chain, used in token URIs handed to deployed tokens.
798      */
799     function ownChainName() external view returns (string memory);
800 
801     /**
802      * @dev The base of ALL token URIs, e.g. https://example.com/
803      */
804     function tokenURIBase() external view returns (string memory);
805 
806     /**
807      * @dev The sunset timestamp for all deployed tokens.
808      * If 0, no sunset is in place. Otherwise, if older than block timestamp,
809      * all transfers of the tokens are frozen.
810      */
811     function tokenSunsetTimestamp() external view returns (uint256);
812 
813     /**
814      * @dev Set a token sunset timestamp.
815      */
816     function setTokenSunsetTimestamp(uint256 _timestamp) external;
817 
818     /**
819      * @dev Set an address for a name.
820      */
821     function setAddress(string memory name, address newAddress) external;
822 
823     /**
824      * @dev Get an address for a name.
825      */
826     function getAddress(string memory name) external view returns (address);
827 }
828 
829 // File: contracts/BridgeHeadI.sol
830 
831 /*
832  * Interface for a Bridge Head.
833  */
834 
835 
836 interface BridgeHeadI {
837 
838     /**
839      * @dev Emitted when an ERC721 token is deposited to the bridge.
840      */
841     event TokenDepositedERC721(address indexed tokenAddress, uint256 indexed tokenId, address indexed otherChainRecipient);
842 
843     /**
844      * @dev Emitted when one or more ERC1155 tokens are deposited to the bridge.
845      */
846     event TokenDepositedERC1155Batch(address indexed tokenAddress, uint256[] tokenIds, uint256[] amounts, address indexed otherChainRecipient);
847 
848     /**
849      * @dev Emitted when an ERC721 token is exited from the bridge.
850      */
851     event TokenExitedERC721(address indexed tokenAddress, uint256 indexed tokenId, address indexed recipient);
852 
853     /**
854      * @dev Emitted when one or more ERC1155 tokens are exited from the bridge.
855      */
856     event TokenExitedERC1155Batch(address indexed tokenAddress, uint256[] tokenIds, uint256[] amounts, address indexed recipient);
857 
858     /**
859      * @dev Emitted when a new bridged token is deployed.
860      */
861     event BridgedTokenDeployed(address indexed ownAddress, address indexed foreignAddress);
862 
863     /**
864      * @dev The address of the bridge data contract storing all addresses and chain info for this bridge
865      */
866     function bridgeData() external view returns (BridgeDataI);
867 
868     /**
869      * @dev The bridge controller address
870      */
871     function bridgeControl() external view returns (address);
872 
873     /**
874      * @dev The token holder contract connected to this bridge head
875      */
876     function tokenHolder() external view returns (TokenHolderI);
877 
878     /**
879      * @dev The name of the chain connected to / on the other side of this bridge head.
880      */
881     function connectedChainName() external view returns (string memory);
882 
883     /**
884      * @dev The name of our own chain, used in token URIs handed to deployed tokens.
885      */
886     function ownChainName() external view returns (string memory);
887 
888     /**
889      * @dev The minimum amount of (valid) signatures that need to be present in `processExitData()`.
890      */
891     function minSignatures() external view returns (uint256);
892 
893     /**
894      * @dev True if deposits are possible at this time.
895      */
896     function depositEnabled() external view returns (bool);
897 
898     /**
899      * @dev True if exits are possible at this time.
900      */
901     function exitEnabled() external view returns (bool);
902 
903     /**
904      * @dev Called by token holder when a ERC721 token has been deposited and
905      * needs to be moved to the other side of the bridge.
906      */
907     function tokenDepositedERC721(address tokenAddress, uint256 tokenId, address otherChainRecipient) external;
908 
909     /**
910      * @dev Called by token holder when a ERC1155 token has been deposited and
911      * needs to be moved to the other side of the bridge. If it was no batch
912      * deposit, still this function is called with with only the one items in
913      * the batch.
914      */
915     function tokenDepositedERC1155Batch(address tokenAddress, uint256[] calldata tokenIds, uint256[] calldata amounts, address otherChainRecipient) external;
916 
917     /**
918      * @dev Called by people/contracts who want to move an ERC721 token to the
919      * other side of the bridge. Needs to be called by the current token owner.
920      */
921     function depositERC721(address tokenAddress, uint256 tokenId, address otherChainRecipient) external;
922 
923     /**
924      * @dev Called by people/contracts who want to move an ERC1155 token to the
925      * other side of the bridge. When only a single token ID is desposited,
926      * called with only one entry in the arrays. Needs to be called by the
927      * current token owner.
928      */
929     function depositERC1155Batch(address tokenAddress, uint256[] calldata tokenIds, uint256[] calldata amounts, address otherChainRecipient) external;
930 
931     /**
932      * @dev Process an exit message. Can be called by anyone, but requires data
933      * with valid signatures from a minimum of `minSignatures()` of allowed
934      * signer addresses and an exit nonce for the respective signer that has
935      * not been used yet. Also, all signers need to be ordered with ascending
936      * addresses for the call to succeed.
937      * The ABI-encoded payload is for a call on the bridge head contract.
938      * The signature is over the contract address, the chain ID, the exit
939      * nonce, and the payload.
940      */
941     function processExitData(bytes memory _payload, uint256 _expirationTimestamp, bytes[] memory _signatures, uint256[] memory _exitNonces) external;
942 
943     /**
944      * @dev Return a predicted token address given the prototype name as listed
945      * in bridge data ("ERC721Prototype" or "ERC1155Prototype") and foreign
946      * token address.
947      */
948     function predictTokenAddress(string memory _prototypeName, address _foreignAddress) external view returns (address);
949 
950     /**
951      * @dev Exit an ERC721 token from the bridge to a recipient. Can be owned
952      * by either the token holder or an address that is treated as an
953      * equivalent holder for the bride. If not existing, can be minted if
954      * allowed, or even a token deployed based in a given foreign address and
955      * symbol. If properties data is set, will send that to the token contract
956      * to set properties for the token.
957      */
958     function exitERC721(address _tokenAddress, uint256 _tokenId, address _recipient, address _foreignAddress, bool _allowMinting, string calldata _symbol, bytes calldata _propertiesData) external;
959 
960     /**
961      * @dev Exit an already existing ERC721 token from the bridge to a
962      * recipient, owned currently by the bridge in some form.
963      */
964     function exitERC721Existing(address _tokenAddress, uint256 _tokenId, address _recipient) external;
965 
966     /**
967      * @dev Exit ERC1155 token(s) from the bridge to a recipient. The token
968      * source can be the token holder, an equivalent, or a Collection. Only
969      * tokens owned by one source can be existed in one transaction. If the
970      * source is the zero address, tokens will be minted.
971      */
972     function exitERC1155Batch(address _tokenAddress, uint256[] memory _tokenIds, uint256[] memory _amounts, address _recipient, address _foreignAddress, address _tokenSource) external;
973 
974     /**
975      * @dev Exit an already existing ERC1155 token from the bridge to a
976      * recipient, owned currently by the token holder.
977      */
978     function exitERC1155BatchFromHolder(address _tokenAddress, uint256[] memory _tokenIds, uint256[] memory _amounts, address _recipient) external;
979 
980     /**
981      * @dev Forward calls to external contracts. Can only be called by owner.
982      * Given a contract address and an already-encoded payload (with a function call etc.),
983      * we call that contract with this payload, e.g. to trigger actions in the name of the token holder.
984      */
985     function callAsHolder(address payable _remoteAddress, bytes calldata _callPayload) external payable;
986 
987 }
988 
989 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
990 
991 /**
992  * @title ERC721 token receiver interface
993  * @dev Interface for any contract that wants to support safeTransfers
994  * from ERC721 asset contracts.
995  */
996 interface IERC721Receiver {
997     /**
998      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
999      * by `operator` from `from`, this function is called.
1000      *
1001      * It must return its Solidity selector to confirm the token transfer.
1002      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1003      *
1004      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1005      */
1006     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1007 }
1008 
1009 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
1010 
1011 /**
1012  * _Available since v3.1._
1013  */
1014 interface IERC1155Receiver is IERC165 {
1015 
1016     /**
1017         @dev Handles the receipt of a single ERC1155 token type. This function is
1018         called at the end of a `safeTransferFrom` after the balance has been updated.
1019         To accept the transfer, this must return
1020         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
1021         (i.e. 0xf23a6e61, or its own function selector).
1022         @param operator The address which initiated the transfer (i.e. msg.sender)
1023         @param from The address which previously owned the token
1024         @param id The ID of the token being transferred
1025         @param value The amount of tokens being transferred
1026         @param data Additional data with no specified format
1027         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
1028     */
1029     function onERC1155Received(
1030         address operator,
1031         address from,
1032         uint256 id,
1033         uint256 value,
1034         bytes calldata data
1035     )
1036         external
1037         returns(bytes4);
1038 
1039     /**
1040         @dev Handles the receipt of a multiple ERC1155 token types. This function
1041         is called at the end of a `safeBatchTransferFrom` after the balances have
1042         been updated. To accept the transfer(s), this must return
1043         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1044         (i.e. 0xbc197c81, or its own function selector).
1045         @param operator The address which initiated the batch transfer (i.e. msg.sender)
1046         @param from The address which previously owned the token
1047         @param ids An array containing ids of each token being transferred (order and length must match values array)
1048         @param values An array containing amounts of each token being transferred (order and length must match ids array)
1049         @param data Additional data with no specified format
1050         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1051     */
1052     function onERC1155BatchReceived(
1053         address operator,
1054         address from,
1055         uint256[] calldata ids,
1056         uint256[] calldata values,
1057         bytes calldata data
1058     )
1059         external
1060         returns(bytes4);
1061 }
1062 
1063 // File: contracts/TokenHolderI.sol
1064 
1065 /*
1066  * Interface for a Token Holder.
1067  */
1068 
1069 
1070 interface TokenHolderI is IERC165, IERC721Receiver, IERC1155Receiver {
1071 
1072     /**
1073      * @dev The address of the bridge data contract storing all addresses and chain info for this bridge
1074      */
1075     function bridgeData() external view returns (BridgeDataI);
1076 
1077     /**
1078      * @dev The bridge head contract connected to this token holder
1079      */
1080     function bridgeHead() external view returns (BridgeHeadI);
1081 
1082     /**
1083      * @dev Forward calls to external contracts. Can only be called by owner.
1084      * Given a contract address and an already-encoded payload (with a function call etc.),
1085      * we call that contract with this payload, e.g. to trigger actions in the name of the bridge.
1086      */
1087     function externalCall(address payable _remoteAddress, bytes calldata _callPayload) external payable;
1088 
1089     /**
1090      * @dev Transfer ERC721 tokens out of the holder contract.
1091      */
1092     function safeTransferERC721(address _tokenAddress, uint256 _tokenId, address _to) external;
1093 
1094     /**
1095      * @dev Transfer ERC1155 tokens out of the holder contract.
1096      */
1097     function safeTransferERC1155Batch(address _tokenAddress, uint256[] memory _tokenIds, uint256[] memory _amounts, address _to) external;
1098 
1099 }
1100 
1101 // File: contracts/ERC721ExistsI.sol
1102 
1103 /*
1104  * Interface for an ERC721 compliant contract with an exists() function.
1105  */
1106 
1107 
1108 /**
1109  * @dev ERC721 compliant contract with an exists() function.
1110  */
1111 interface ERC721ExistsI is IERC721 {
1112 
1113     // Returns whether the specified token exists
1114     function exists(uint256 tokenId) external view returns (bool);
1115 
1116 }
1117 
1118 // File: contracts/ERC721MintableI.sol
1119 
1120 /*
1121  * Interfaces for mintable ERC721 compliant contracts.
1122  */
1123 
1124 
1125 /**
1126  * @dev ERC721 compliant contract with a safeMint() function.
1127  */
1128 interface ERC721MintableI is IERC721 {
1129 
1130     /**
1131      * @dev Function to safely mint a new token.
1132      * Reverts if the given token ID already exists.
1133      * If the target address is a contract, it must implement `onERC721Received`,
1134      * which is called upon a safe transfer, and return the magic value
1135      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1136      * the transfer is reverted.
1137      * @param to The address that will own the minted token
1138      * @param tokenId uint256 ID of the token to be minted
1139      */
1140     function safeMint(address to, uint256 tokenId) external;
1141 
1142 }
1143 
1144 /**
1145  * @dev ERC721 compliant contract with a safeMintWithData() function.
1146  */
1147 interface ERC721DataMintableI is IERC721 {
1148 
1149     /**
1150      * @dev Function to safely mint a new token with data.
1151      * Reverts if the given token ID already exists.
1152      * If the target address is a contract, it must implement `onERC721Received`,
1153      * which is called upon a safe transfer, and return the magic value
1154      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1155      * the transfer is reverted.
1156      * @param to The address that will own the minted token
1157      * @param tokenId uint256 ID of the token to be minted
1158      * @param propdata bytes data to be used for token proerties
1159      */
1160     function safeMintWithData(address to, uint256 tokenId, bytes memory propdata) external;
1161 
1162 }
1163 
1164 /**
1165  * @dev ERC721 compliant contract with a setPropertiesFromData() function.
1166  */
1167 interface ERC721SettablePropertiesI is IERC721 {
1168 
1169     /**
1170      * @dev Function to set properties from data for a token.
1171      * Reverts if the given token ID does not exist.
1172      * @param tokenId uint256 ID of the token to be set properties for
1173      * @param propdata bytes data to be used for token proerties
1174      */
1175     function setPropertiesFromData(uint256 tokenId, bytes memory propdata) external;
1176 
1177 }
1178 
1179 // File: contracts/CollectionsI.sol
1180 
1181 /*
1182  * Interface for the Collections factory.
1183  */
1184 
1185 
1186 /**
1187  * @dev Outward-facing interface of a Collections contract.
1188  */
1189 interface CollectionsI is IERC721 {
1190 
1191     /**
1192      * @dev Emitted when a new collection is created.
1193      */
1194     event NewCollection(address indexed owner, address collectionAddress);
1195 
1196     /**
1197      * @dev Emitted when a collection is destroyed.
1198      */
1199     event KilledCollection(address indexed owner, address collectionAddress);
1200 
1201     /**
1202      * @dev Creates a new Collection. For calling from other contracts,
1203      * returns the address of the new Collection.
1204      */
1205     function create(address _notificationContract,
1206                     string calldata _ensName,
1207                     string calldata _ensSubdomainName,
1208                     address _ensSubdomainRegistrarAddress,
1209                     address _ensReverseRegistrarAddress)
1210     external payable
1211     returns (address);
1212 
1213     /**
1214      * @dev Create a collection for a different owner. Only callable by a
1215      * create controller role. For calling from other contracts, returns the
1216      * address of the new Collection.
1217      */
1218     function createFor(address payable _newOwner,
1219                        address _notificationContract,
1220                        string calldata _ensName,
1221                        string calldata _ensSubdomainName,
1222                        address _ensSubdomainRegistrarAddress,
1223                        address _ensReverseRegistrarAddress)
1224     external payable
1225     returns (address);
1226 
1227     /**
1228      * @dev Removes (burns) an empty Collection. Only the Collection contract itself can call this.
1229      */
1230     function burn(uint256 tokenId) external;
1231 
1232     /**
1233      * @dev Returns if a Collection NFT exists for the specified `tokenId`.
1234      */
1235     function exists(uint256 tokenId) external view returns (bool);
1236 
1237     /**
1238      * @dev Returns whether the given spender can transfer a given `collectionAddr`.
1239      */
1240     function isApprovedOrOwnerOnCollection(address spender, address collectionAddr) external view returns (bool);
1241 
1242     /**
1243      * @dev Returns the Collection address for a token ID.
1244      */
1245     function collectionAddress(uint256 tokenId) external view returns (address);
1246 
1247     /**
1248      * @dev Returns the token ID for a Collection address.
1249      */
1250     function tokenIdForCollection(address collectionAddr) external view returns (uint256);
1251 
1252     /**
1253      * @dev Returns true if a Collection exists at this address, false if not.
1254      */
1255     function collectionExists(address collectionAddr) external view returns (bool);
1256 
1257     /**
1258      * @dev Returns the owner of the Collection with the given address.
1259      */
1260     function collectionOwner(address collectionAddr) external view returns (address);
1261 
1262     /**
1263      * @dev Returns a Collection address owned by `owner` at a given `index` of
1264      * its Collections list. Mirrors `tokenOfOwnerByIndex` in ERC721Enumerable.
1265      */
1266     function collectionOfOwnerByIndex(address owner, uint256 index) external view returns (address);
1267 
1268 }
1269 
1270 // File: contracts/CollectionI.sol
1271 
1272 /*
1273  * Interface for a single Collection, which is a very lightweight contract that can be the owner of ERC721 tokens.
1274  */
1275 
1276 
1277 
1278 
1279 
1280 interface CollectionI is IERC165, IERC721Receiver, IERC1155Receiver  {
1281 
1282     /**
1283      * @dev Emitted when the notification conmtract is changed.
1284      */
1285     event NotificationContractTransferred(address indexed previousNotificationContract, address indexed newNotificationContract);
1286 
1287     /**
1288      * @dev Emitted when an asset is added to the collection.
1289      */
1290     event AssetAdded(address tokenAddress, uint256 tokenId);
1291 
1292     /**
1293      * @dev Emitted when an asset is removed to the collection.
1294      */
1295     event AssetRemoved(address tokenAddress, uint256 tokenId);
1296 
1297     /**
1298      * @dev Emitted when the Collection is destroyed.
1299      */
1300     event CollectionDestroyed(address operator);
1301 
1302     /**
1303      * @dev True is this is the prototype, false if this is an active
1304      * (clone/proxy) collection contract.
1305      */
1306     function isPrototype() external view returns (bool);
1307 
1308     /**
1309      * @dev The linked Collections factory (the ERC721 contract).
1310      */
1311     function collections() external view returns (CollectionsI);
1312 
1313     /**
1314      * @dev The linked notification contract (e.g. achievements).
1315      */
1316     function notificationContract() external view returns (address);
1317 
1318     /**
1319      * @dev Initializes a new Collection. Needs to be called by the Collections
1320      * factory.
1321      */
1322     function initialRegister(address _notificationContract,
1323                              string calldata _ensName,
1324                              string calldata _ensSubdomainName,
1325                              address _ensSubdomainRegistrarAddress,
1326                              address _ensReverseRegistrarAddress)
1327     external;
1328 
1329     /**
1330      * @dev Switch the notification contract to a different address. Set to the
1331      * zero address to disable notifications. Can only be called by owner.
1332      */
1333     function transferNotificationContract(address _newNotificationContract) external;
1334 
1335     /**
1336      * @dev Get collection owner from ERC 721 parent (Collections factory).
1337      */
1338     function ownerAddress() external view returns (address);
1339 
1340     /**
1341      * @dev Determine if the Collection owns a specific asset.
1342      */
1343     function ownsAsset(address _tokenAddress, uint256 _tokenId) external view returns(bool);
1344 
1345     /**
1346      * @dev Get count of owned assets.
1347      */
1348     function ownedAssetsCount() external view returns (uint256);
1349 
1350     /**
1351      * @dev Make sure ownership of a certain asset is recorded correctly (added
1352      * if the collection owns it or removed if it doesn't).
1353      */
1354     function syncAssetOwnership(address _tokenAddress, uint256 _tokenId) external;
1355 
1356     /**
1357      * @dev Transfer an owned asset to a new owner (for ERC1155, a single item
1358      * of that asset).
1359      */
1360     function safeTransferTo(address _tokenAddress, uint256 _tokenId, address _to) external;
1361 
1362     /**
1363      * @dev Transfer a certain amount of an owned asset to a new owner (for
1364      * ERC721, _value is ignored).
1365      */
1366     function safeTransferTo(address _tokenAddress, uint256 _tokenId, address _to, uint256 _value) external;
1367 
1368     /**
1369      * @dev Destroy and burn an empty Collection. Can only be called by owner
1370      * and only on empty collections.
1371      */
1372     function destroy() external;
1373 
1374     /**
1375      * @dev Forward calls to external contracts. Can only be called by owner.
1376      * Given a contract address and an already-encoded payload (with a function
1377      * call etc.), we call that contract with this payload, e.g. to trigger
1378      * actions in the name of the collection.
1379      */
1380     function externalCall(address payable _remoteAddress, bytes calldata _callPayload) external payable;
1381 
1382     /**
1383      * @dev Register ENS name. Can only be called by owner.
1384      */
1385     function registerENS(string calldata _name, address _registrarAddress) external;
1386 
1387     /**
1388      * @dev Register Reverse ENS name. Can only be called by owner.
1389      */
1390     function registerReverseENS(address _reverseRegistrarAddress, string calldata _name) external;
1391 }
1392 
1393 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1394 
1395 
1396 
1397 /**
1398  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1399  * @dev See https://eips.ethereum.org/EIPS/eip-721
1400  */
1401 interface IERC721Enumerable is IERC721 {
1402 
1403     /**
1404      * @dev Returns the total amount of tokens stored by the contract.
1405      */
1406     function totalSupply() external view returns (uint256);
1407 
1408     /**
1409      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1410      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1411      */
1412     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1413 
1414     /**
1415      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1416      * Use along with {totalSupply} to enumerate all tokens.
1417      */
1418     function tokenByIndex(uint256 index) external view returns (uint256);
1419 }
1420 
1421 // File: contracts/BridgedERC721I.sol
1422 
1423 /*
1424  * Interface for a Bridged ERC721 token.
1425  */
1426 
1427 
1428 
1429 
1430 
1431 
1432 interface BridgedERC721I is IERC721Metadata, IERC721Enumerable, ERC721ExistsI, ERC721MintableI {
1433 
1434     event SignedTransfer(address operator, address indexed from, address indexed to, uint256 indexed tokenId, uint256 signedTransferNonce);
1435 
1436     /**
1437      * @dev True if this is the prototype, false if this is an active (clone/proxy) token contract.
1438      */
1439     function isPrototype() external view returns (bool);
1440 
1441     /**
1442      * @dev The address of the bridge data contract storing all addresses and chain info for this bridge
1443      */
1444     function bridgeData() external view returns (BridgeDataI);
1445 
1446     /**
1447      * @dev Do initial registration of a clone. Should be called in the same
1448      * transaction as the actual cloning. Can only be called once.
1449      */
1450     function initialRegister(address _bridgeDataAddress,
1451                              string memory _symbol, string memory _name,
1452                              string memory _orginalChainName, address _originalChainAddress) external;
1453 
1454     /**
1455      * @dev The base of the tokenURI
1456      */
1457     function baseURI() external view returns (string memory);
1458 
1459     /**
1460      * @dev The name of the original chain this token is bridged from.
1461      */
1462     function originalChainName() external view returns (string memory);
1463 
1464     /**
1465      * @dev The address of this token on the original chain this is bridged from.
1466      */
1467     function originalChainAddress() external view returns (address);
1468 
1469     /**
1470      * @dev True if transfers are possible at this time.
1471      */
1472     function transferEnabled() external view returns (bool);
1473 
1474     /**
1475      * @dev The signed transfer nonce for an account.
1476      */
1477     function signedTransferNonce(address account) external view returns (uint256);
1478 
1479     /**
1480      * @dev Outward-facing function for signed transfer: assembles the expected data and then calls the internal function to do the rest.
1481      * Can called by anyone knowing about the right signature, but can only transfer to the given specific target.
1482      */
1483     function signedTransfer(uint256 tokenId, address to, bytes memory signature) external;
1484 
1485     /**
1486      * @dev Outward-facing function for operator-driven signed transfer: assembles the expected data and then calls the internal function to do the rest.
1487      * Can transfer to any target, but only be called by the trusted operator contained in the signature.
1488      */
1489     function signedTransferWithOperator(uint256 tokenId, address to, bytes memory signature) external;
1490 
1491 }
1492 
1493 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
1494 
1495 
1496 /**
1497  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
1498  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
1499  *
1500  * _Available since v3.1._
1501  */
1502 interface IERC1155MetadataURI is IERC1155 {
1503     /**
1504      * @dev Returns the URI for token type `id`.
1505      *
1506      * If the `\{id\}` substring is present in the URI, it must be replaced by
1507      * clients with the actual token type ID.
1508      */
1509     function uri(uint256 id) external view returns (string memory);
1510 }
1511 
1512 // File: contracts/ERC1155MintableI.sol
1513 
1514 /*
1515  * Interfaces for mintable ERC721 compliant contracts.
1516  */
1517 
1518 
1519 /**
1520  * @dev ERC1155 compliant contract with mint() and mintBatch() functions.
1521  */
1522 interface ERC1155MintableI is IERC1155 {
1523 
1524     /**
1525      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
1526      *
1527      * Emits a {TransferSingle} event.
1528      *
1529      * Requirements:
1530      *
1531      * - `account` cannot be the zero address.
1532      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1533      * acceptance magic value.
1534      */
1535     function mint(address account, uint256 id, uint256 amount) external;
1536 
1537     /**
1538      * @dev Batched version of {_mint}.
1539      *
1540      * Requirements:
1541      *
1542      * - `ids` and `amounts` must have the same length.
1543      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1544      * acceptance magic value.
1545      */
1546     function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts) external;
1547 
1548 }
1549 
1550 // File: contracts/BridgedERC1155I.sol
1551 
1552 /*
1553  * Interface for a Bridged ERC721 token.
1554  */
1555 
1556 
1557 
1558 
1559 interface BridgedERC1155I is IERC1155MetadataURI, ERC1155MintableI {
1560 
1561     event SignedBatchTransfer(address operator, address indexed from, address indexed to, uint256[] ids, uint256[] amounts, uint256 signedTransferNonce);
1562 
1563     /**
1564      * @dev True if this is the prototype, false if this is an active (clone/proxy) token contract.
1565      */
1566     function isPrototype() external view returns (bool);
1567 
1568     /**
1569      * @dev The address of the bridge data contract storing all addresses and chain info for this bridge
1570      */
1571     function bridgeData() external view returns (BridgeDataI);
1572 
1573     /**
1574      * @dev Do initial registration of a clone. Should be called in the same
1575      * transaction as the actual cloning. Can only be called once.
1576      */
1577     function initialRegister(address _bridgeDataAddress, string memory _orginalChainName, address _originalChainAddress) external;
1578 
1579     /**
1580      * @dev The name of the original chain this token is bridged from.
1581      */
1582     function originalChainName() external view returns (string memory);
1583 
1584     /**
1585      * @dev The address of this token on the original chain this is bridged from.
1586      */
1587     function originalChainAddress() external view returns (address);
1588 
1589     /**
1590      * @dev The signed transfer nonce for an account.
1591      */
1592     function signedTransferNonce(address account) external view returns (uint256);
1593 
1594     /**
1595      * @dev True if transfers are possible at this time.
1596      */
1597     function transferEnabled() external view returns (bool);
1598 
1599     /**
1600      * @dev Outward-facing function for signed transfer: assembles the expected data and then calls the internal function to do the rest.
1601      * Can called by anyone knowing about the right signature, but can only transfer to the given specific target.
1602      */
1603     function signedBatchTransfer(address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory signature) external;
1604 
1605     /**
1606      * @dev Outward-facing function for operator-driven signed transfer: assembles the expected data and then calls the internal function to do the rest.
1607      * Can transfer to any target, but only be called by the trusted operator contained in the signature.
1608      */
1609     function signedBatchTransferWithOperator(address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory signature) external;
1610 
1611 }
1612 
1613 // File: contracts/BridgeHead.sol
1614 
1615 /*
1616  * Implements the Bridge Head on one side of the Crypto stamp bridge.
1617  * The Bridge API interacts with this contract by listening to events and
1618  * issuing relevant calls to functions on the Bridge Head the other side (which
1619  * is another copy of this contract), as well as handing out or executing
1620  * signed messages to be processed by this contract in response to events on
1621  * that other Bridge Head.
1622  */
1623 
1624 
1625 
1626 
1627 
1628 
1629 
1630 
1631 
1632 
1633 
1634 
1635 
1636 
1637 
1638 
1639 contract BridgeHead is BridgeHeadI {
1640     using Address for address;
1641 
1642     BridgeDataI public override bridgeData;
1643 
1644     uint256 public depositSunsetTimestamp;
1645 
1646     // Marks contracts that are treated as if they were token holder contracts, i.e. any tokens they own are treated as deposited.
1647     // Note: all those addresses need to give approval for all tokens of affected contracts to this bridge head.
1648     mapping(address => bool) public tokenHolderEquivalent;
1649 
1650     uint256 public override minSignatures;
1651 
1652     // Marks if an address belongs to an allowed signer for exits.
1653     mapping(address => bool) public allowedSigner;
1654 
1655     // Marks if an exit nonce for a specific signer address has been used.
1656     // As we can give out exit messages to different users, we cannot guarantee an order but need to prevent replay.
1657     mapping(address => mapping(uint256 => bool)) public exitNonceUsed;
1658 
1659     event BridgeDataChanged(address indexed previousBridgeData, address indexed newBridgeData);
1660     event MinSignaturesSet(uint256 minSignatures);
1661     event DepositSunsetAnnounced(uint256 timestamp);
1662     event AllowedSignerSet(address indexed signerAddress, bool enabled);
1663     event TokenHolderEquivalentSet(address indexed holderAddress, bool enabled);
1664 
1665     constructor(address _bridgeDataAddress, uint256 _minSignatures)
1666     {
1667         bridgeData = BridgeDataI(_bridgeDataAddress);
1668         require(address(bridgeData) != address(0x0), "You need to provide an actual bridge data contract.");
1669         minSignatures = _minSignatures;
1670         require(minSignatures > 0, "At least one signature has to be required.");
1671     }
1672 
1673     modifier onlyBridgeControl()
1674     {
1675         require(msg.sender == bridgeData.getAddress("bridgeControl"), "bridgeControl key required for this function.");
1676         _;
1677     }
1678 
1679     modifier onlySelfOrBC()
1680     {
1681         require(msg.sender == address(this) || msg.sender == bridgeData.getAddress("bridgeControl"),
1682                 "Signed exit data or bridgeControl key required.");
1683         _;
1684     }
1685 
1686     modifier onlyTokenAssignmentControl() {
1687         require(msg.sender == bridgeData.getAddress("tokenAssignmentControl"), "tokenAssignmentControl key required for this function.");
1688         _;
1689     }
1690 
1691     modifier onlyTokenHolder() {
1692         require(msg.sender == bridgeData.getAddress("tokenHolder"), "Only token holder can call this function.");
1693         _;
1694     }
1695 
1696     modifier requireDepositEnabled() {
1697         require(depositEnabled() == true, "This call only works when deposits are enabled.");
1698         _;
1699     }
1700 
1701     modifier requireExitEnabled() {
1702         require(exitEnabled() == true, "This call only works when exits are enabled.");
1703         _;
1704     }
1705 
1706     /*** Enable adjusting variables after deployment ***/
1707 
1708     function setBridgeData(BridgeDataI _newBridgeData)
1709     external
1710     onlyBridgeControl
1711     {
1712         require(address(_newBridgeData) != address(0x0), "You need to provide an actual bridge data contract.");
1713         emit BridgeDataChanged(address(bridgeData), address(_newBridgeData));
1714         bridgeData = _newBridgeData;
1715     }
1716 
1717     function setMinSignatures(uint256 _newMinSignatures)
1718     public
1719     onlyBridgeControl
1720     {
1721         require(_newMinSignatures > 0, "At least one signature has to be required.");
1722         minSignatures = _newMinSignatures;
1723         emit MinSignaturesSet(minSignatures);
1724     }
1725 
1726     function setDepositSunsetTimestamp(uint256 _timestamp)
1727     public
1728     onlyBridgeControl
1729     {
1730         depositSunsetTimestamp = _timestamp;
1731         emit DepositSunsetAnnounced(_timestamp);
1732     }
1733 
1734     function setTokenSunsetTimestamp(uint256 _timestamp)
1735     public
1736     onlyBridgeControl
1737     {
1738         bridgeData.setTokenSunsetTimestamp(_timestamp);
1739     }
1740 
1741     function setAllSunsetTimestamps(uint256 _timestamp)
1742     public
1743     onlyBridgeControl
1744     {
1745         setDepositSunsetTimestamp(_timestamp);
1746         bridgeData.setTokenSunsetTimestamp(_timestamp);
1747     }
1748 
1749     function setAllowedSigners(address[] memory _signerAddresses, bool _enabled)
1750     public
1751     onlyBridgeControl
1752     {
1753         uint256 addrcount = _signerAddresses.length;
1754         for (uint256 i = 0; i < addrcount; i++) {
1755             allowedSigner[_signerAddresses[i]] = _enabled;
1756             emit AllowedSignerSet(_signerAddresses[i], _enabled);
1757         }
1758     }
1759 
1760     function setTokenHolderEquivalent(address[] memory _holderAddresses, bool _enabled)
1761     public
1762     onlyBridgeControl
1763     {
1764         uint256 addrcount = _holderAddresses.length;
1765         for (uint256 i = 0; i < addrcount; i++) {
1766             tokenHolderEquivalent[_holderAddresses[i]] = _enabled;
1767             emit TokenHolderEquivalentSet(_holderAddresses[i], _enabled);
1768         }
1769     }
1770 
1771     function bridgeControl()
1772     public view override
1773     returns (address) {
1774         return bridgeData.getAddress("bridgeControl");
1775     }
1776 
1777     function tokenHolder()
1778     public view override
1779     returns (TokenHolderI) {
1780         return TokenHolderI(bridgeData.getAddress("tokenHolder"));
1781     }
1782 
1783     function connectedChainName()
1784     public view override
1785     returns (string memory) {
1786         return bridgeData.connectedChainName();
1787     }
1788 
1789     function ownChainName()
1790     public view override
1791     returns (string memory) {
1792         return bridgeData.ownChainName();
1793     }
1794 
1795     // Return true if deposits are possible.
1796     // This can have additional conditions to just the sunset variable, e.g. actually having a token holder set.
1797     function depositEnabled()
1798     public view override
1799     returns (bool)
1800     {
1801         // solhint-disable-next-line not-rely-on-time
1802         return (bridgeData.getAddress("tokenHolder") != address(0x0)) && (depositSunsetTimestamp == 0 || depositSunsetTimestamp > block.timestamp);
1803     }
1804 
1805     // Return true if exits are possible.
1806     // This can have additional conditions, e.g. actually having a token holder set.
1807     function exitEnabled()
1808     public view override
1809     returns (bool)
1810     {
1811         return minSignatures > 0 && bridgeData.getAddress("tokenHolder") != address(0x0);
1812     }
1813 
1814     /*** deposit functionality ***/
1815 
1816     // ERC721 token has been deposited, signal the bridge.
1817     function tokenDepositedERC721(address _tokenAddress, uint256 _tokenId, address _otherChainRecipient)
1818     external override
1819     onlyTokenHolder
1820     requireDepositEnabled
1821     {
1822         emit TokenDepositedERC721(_tokenAddress, _tokenId, _otherChainRecipient);
1823     }
1824 
1825     // ERC1155 tokens have been deposited, signal the bridge.
1826     function tokenDepositedERC1155Batch(address _tokenAddress, uint256[] calldata _tokenIds, uint256[] calldata _amounts, address _otherChainRecipient)
1827     external override
1828     onlyTokenHolder
1829     requireDepositEnabled
1830     {
1831         emit TokenDepositedERC1155Batch(_tokenAddress, _tokenIds, _amounts, _otherChainRecipient);
1832     }
1833 
1834     // Move an ERC721 token to the other side of the bridge, where _otherChainRecipient will receive it.
1835     function depositERC721(address _tokenAddress, uint256 _tokenId, address _otherChainRecipient)
1836     external override
1837     requireDepositEnabled
1838     {
1839         IERC721(_tokenAddress).safeTransferFrom(msg.sender, bridgeData.getAddress("tokenHolder"), _tokenId, abi.encode(_otherChainRecipient));
1840     }
1841 
1842     // Move ERC1155 tokens to the other side of the bridge.
1843     function depositERC1155Batch(address _tokenAddress, uint256[] calldata _tokenIds, uint256[] calldata _amounts, address _otherChainRecipient)
1844     external override
1845     requireDepositEnabled
1846     {
1847         IERC1155(_tokenAddress).safeBatchTransferFrom(msg.sender, bridgeData.getAddress("tokenHolder"), _tokenIds, _amounts, abi.encode(_otherChainRecipient));
1848     }
1849 
1850     /*** exit functionality ***/
1851 
1852     function processExitData(bytes memory _payload, uint256 _expirationTimestamp, bytes[] memory _signatures, uint256[] memory _exitNonces)
1853     external override
1854     requireExitEnabled
1855     {
1856         require(_payload.length >= 4, "Payload is too short.");
1857         // solhint-disable-next-line not-rely-on-time
1858         require(_expirationTimestamp > block.timestamp, "Message is expired.");
1859         uint256 sigCount = _signatures.length;
1860         require(sigCount == _exitNonces.length, "Both input arrays need to be the same length.");
1861         require(sigCount >= minSignatures, "Need to have enough signatures.");
1862         // Check signatures.
1863         address lastCheckedAddr;
1864         for (uint256 i = 0; i < sigCount; i++) {
1865             require(_signatures[i].length == 65, "Signature has wrong length.");
1866             bytes32 data = keccak256(abi.encodePacked(address(this), block.chainid, _exitNonces[i], _expirationTimestamp, _payload));
1867             bytes32 hash = ECDSA.toEthSignedMessageHash(data);
1868             address signer = ECDSA.recover(hash, _signatures[i]);
1869             require(allowedSigner[signer], "Signature does not match allowed signer.");
1870             // Check that no signer is listed multiple times by requiring ascending order.
1871             require(uint160(lastCheckedAddr) < uint160(signer), "Signers need ascending order and no repeats.");
1872             lastCheckedAddr = signer;
1873             // Check nonce.
1874             require(exitNonceUsed[signer][_exitNonces[i]] == false, "Unable to replay exit message.");
1875             exitNonceUsed[signer][_exitNonces[i]] = true;
1876         }
1877         // Execute the payload.
1878         address(this).functionCall(_payload);
1879     }
1880 
1881     function predictTokenAddress(string memory _prototypeName, address _foreignAddress)
1882     public view override
1883     returns (address)
1884     {
1885         bytes32 cloneSalt = bytes32(uint256(uint160(_foreignAddress)));
1886         address prototypeAddress = bridgeData.getAddress(_prototypeName);
1887         return Clones.predictDeterministicAddress(prototypeAddress, cloneSalt);
1888     }
1889 
1890     function exitERC721(address _tokenAddress, uint256 _tokenId, address _recipient, address _foreignAddress, bool _allowMinting, string memory _symbol, bytes memory _propertiesData)
1891     public override
1892     onlySelfOrBC
1893     requireExitEnabled
1894     {
1895         require(_tokenAddress != address(0) || _foreignAddress != address(0), "Either foreign or native token address needs to be given.");
1896         if (_tokenAddress == address(0)) {
1897             // No chain-native token address given, predict and potentially deploy it.
1898             require(_allowMinting, "Minting needed for new token.");
1899             bytes32 cloneSalt = bytes32(uint256(uint160(_foreignAddress)));
1900             address prototypeERC721Address = bridgeData.getAddress("ERC721Prototype");
1901             _tokenAddress = Clones.predictDeterministicAddress(prototypeERC721Address, cloneSalt);
1902             if (!_tokenAddress.isContract()) {
1903                 // Deploy clone and do initial registration of that contract.
1904                 address newInstance = Clones.cloneDeterministic(prototypeERC721Address, cloneSalt);
1905                 require(newInstance == _tokenAddress, "Error deploying new token.");
1906                 BridgedERC721I(_tokenAddress).initialRegister(
1907                     address(bridgeData), _symbol,
1908                     string(abi.encodePacked("Bridged ", _symbol, " (from ", connectedChainName(), ")")),
1909                     connectedChainName(), _foreignAddress);
1910                 emit BridgedTokenDeployed(_tokenAddress, _foreignAddress);
1911             }
1912         }
1913         // Instantiate the token contract.
1914         IERC721 token = IERC721(_tokenAddress);
1915         if (_allowMinting && !ERC721ExistsI(_tokenAddress).exists(_tokenId)) {
1916             // NFT doesn't exist, mint directly to recipient - if we have data, mint with that.
1917             if (_propertiesData.length > 0) {
1918                 ERC721DataMintableI(_tokenAddress).safeMintWithData(_recipient, _tokenId, _propertiesData);
1919             }
1920             else {
1921                 ERC721MintableI(_tokenAddress).safeMint(_recipient, _tokenId);
1922             }
1923         }
1924         else {
1925             // The NFT should exist and the bridge should hold it, so hand it to the recipient.
1926             // Note that .exists() is not in the ERC721 standard, so we can't test with that
1927             // for generic tokens, but .ownerOf() should throw in that case.
1928             address currentOwner = token.ownerOf(_tokenId);
1929             // Set properties if needed.
1930             if (_propertiesData.length > 0) {
1931                 ERC721SettablePropertiesI(_tokenAddress).setPropertiesFromData(_tokenId, _propertiesData);
1932             }
1933             // Now, do the safe transfer (should be the last state change to prevent re-entrancy).
1934             if (currentOwner == bridgeData.getAddress("tokenHolder")) {
1935                 tokenHolder().safeTransferERC721(_tokenAddress, _tokenId, _recipient);
1936             }
1937             else if (tokenHolderEquivalent[currentOwner] == true) {
1938                 token.safeTransferFrom(currentOwner, _recipient, _tokenId);
1939             }
1940             else if (currentOwner.isContract() &&
1941                      (IERC165(currentOwner).supportsInterface(type(CollectionI).interfaceId) ||
1942                       ERC721ExistsI(bridgeData.getAddress("Collections")).exists(uint256(uint160(currentOwner)))) &&
1943                      CollectionI(currentOwner).ownerAddress() == address(tokenHolder())) {
1944                 // It's a contract and either supports the Collection interface
1945                 // or is a token registered in Collections, so it is a Collection,
1946                 // and it is owned by the holder.
1947                 // The latter condition is there because the original Collections
1948                 // contract on Ethereum Layer 1 does not register its own
1949                 // interface via ERC165.
1950                 // And then, we need to assemble the payload and use callAsHolder
1951                 // as the current owner of the Collection needs to call the
1952                 // safeTransferTo function.
1953                 // NOTE: abi.encodeWithSelector(CollectionI.safeTransferTo.selector, ...)
1954                 // would be nicer but has issues with overloading, see
1955                 // https://github.com/ethereum/solidity/issues/3556
1956                 callAsHolder(payable(currentOwner), abi.encodeWithSignature("safeTransferTo(address,uint256,address)", _tokenAddress, _tokenId, _recipient));
1957             }
1958             else {
1959                 revert("Bridge has no access to this token.");
1960             }
1961         }
1962         // If we get here, the exit has been performed successfully.
1963         emit TokenExitedERC721(_tokenAddress, _tokenId, _recipient);
1964     }
1965 
1966     function exitERC721Existing(address _tokenAddress, uint256 _tokenId, address _recipient)
1967     external override
1968     {
1969         exitERC721(_tokenAddress, _tokenId, _recipient, address(0), false, "", "");
1970     }
1971 
1972     function exitERC1155Batch(address _tokenAddress, uint256[] memory _tokenIds, uint256[] memory _amounts, address _recipient, address _foreignAddress, address _tokenSource)
1973     public override
1974     onlySelfOrBC
1975     requireExitEnabled
1976     {
1977         require(_tokenAddress != address(0) || _foreignAddress != address(0), "Either foreign or native token address needs to be given.");
1978         if (_tokenAddress == address(0)) {
1979             // No chain-native token address given, predict and potentially deploy it.
1980             require(_tokenSource == address(0), "Minting source needed for new token.");
1981             bytes32 cloneSalt = bytes32(uint256(uint160(_foreignAddress)));
1982             address prototypeERC1155Address = bridgeData.getAddress("ERC1155Prototype");
1983             _tokenAddress = Clones.predictDeterministicAddress(prototypeERC1155Address, cloneSalt);
1984             if (!_tokenAddress.isContract()) {
1985                 address newInstance = Clones.cloneDeterministic(prototypeERC1155Address, cloneSalt);
1986                 require(newInstance == _tokenAddress, "Error deploying new token.");
1987                 BridgedERC1155I(_tokenAddress).initialRegister(address(bridgeData), connectedChainName(), _foreignAddress);
1988                 emit BridgedTokenDeployed(_tokenAddress, _foreignAddress);
1989             }
1990         }
1991         // According to the token source, determine where to get the token(s) from.
1992         // Actual transfer will fail if source doesn't have enough tokens.
1993         // Note that safe transfer should be the last state change to prevent re-entrancy.
1994         if (_tokenSource == address(0)) {
1995             // NFT doesn't exist, mint directly to recipient.
1996             ERC1155MintableI(_tokenAddress).mintBatch(_recipient, _tokenIds, _amounts);
1997         }
1998         else if (_tokenSource == bridgeData.getAddress("tokenHolder")) {
1999             tokenHolder().safeTransferERC1155Batch(_tokenAddress, _tokenIds, _amounts, _recipient);
2000         }
2001         else if (tokenHolderEquivalent[_tokenSource] == true) {
2002             IERC1155(_tokenAddress).safeBatchTransferFrom(_tokenSource, _recipient, _tokenIds, _amounts, "");
2003         }
2004         else if (_tokenSource.isContract() &&
2005                  (IERC165(_tokenSource).supportsInterface(type(CollectionI).interfaceId) ||
2006                  ERC721ExistsI(bridgeData.getAddress("Collections")).exists(uint256(uint160(_tokenSource)))) &&
2007                  CollectionI(_tokenSource).ownerAddress() == address(tokenHolder())) {
2008             // It's a contract and either supports the Collection interface
2009             // or is a token registered in Collections, so it is a Collection,
2010             // and it is owned by the holder.
2011             // The latter condition is there because the original Collections
2012             // contract on Ethereum Layer 1 does not register its own
2013             // interface via ERC165.
2014             // And then, we need to assemble the payload and use callAsHolder
2015             // as the current owner of the Collection needs to call the
2016             // safeTransferTo function.
2017             // NOTE: abi.encodeWithSelector(CollectionI.safeTransferTo.selector, ...)
2018             // would be nicer but has issues with overloading, see
2019             // https://github.com/ethereum/solidity/issues/3556
2020             uint256 batchcount = _tokenIds.length;
2021             require(batchcount == _amounts.length, "Both token IDs and amounts need to be the same length.");
2022             for (uint256 i = 0; i < batchcount; i++) {
2023                 callAsHolder(payable(_tokenSource), abi.encodeWithSignature("safeTransferTo(address,uint256,address,uint256)", _tokenAddress, _tokenIds[i], _recipient, _amounts[i]));
2024             }
2025         }
2026         else {
2027             revert("Bridge has no access to this token.");
2028         }
2029         // If we get here, the exit has been performed successfully.
2030         emit TokenExitedERC1155Batch(_tokenAddress, _tokenIds, _amounts, _recipient);
2031     }
2032 
2033     function exitERC1155BatchFromHolder(address _tokenAddress, uint256[] memory _tokenIds, uint256[] memory _amounts, address _recipient)
2034     external override
2035     {
2036         exitERC1155Batch(_tokenAddress, _tokenIds, _amounts, _recipient, address(0), bridgeData.getAddress("tokenHolder"));
2037     }
2038 
2039     /*** Forward calls to external contracts ***/
2040 
2041     // Given a contract address and an already-encoded payload (with a function call etc.),
2042     // we call that contract with this payload, e.g. to trigger actions in the name of the token holder.
2043     function callAsHolder(address payable _remoteAddress, bytes memory _callPayload)
2044     public override payable
2045     onlySelfOrBC
2046     {
2047         tokenHolder().externalCall(_remoteAddress, _callPayload);
2048     }
2049 
2050     /*** Enable reverse ENS registration ***/
2051 
2052     // Call this with the address of the reverse registrar for the respective network and the ENS name to register.
2053     // The reverse registrar can be found as the owner of 'addr.reverse' in the ENS system.
2054     // For Mainnet, the address needed is 0x9062c0a6dbd6108336bcbe4593a3d1ce05512069
2055     function registerReverseENS(address _reverseRegistrarAddress, string calldata _name)
2056     external
2057     onlyTokenAssignmentControl
2058     {
2059         require(_reverseRegistrarAddress != address(0), "need a valid reverse registrar");
2060         ENSReverseRegistrarI(_reverseRegistrarAddress).setName(_name);
2061     }
2062 
2063     /*** Make sure currency or NFT doesn't get stranded in this contract ***/
2064 
2065     // If this contract gets a balance in some ERC20 contract after it's finished, then we can rescue it.
2066     function rescueToken(address _foreignToken, address _to)
2067     external
2068     onlyTokenAssignmentControl
2069     {
2070         IERC20 erc20Token = IERC20(_foreignToken);
2071         erc20Token.transfer(_to, erc20Token.balanceOf(address(this)));
2072     }
2073 
2074     // If this contract gets a balance in some ERC721 contract after it's finished, then we can rescue it.
2075     function approveNFTrescue(IERC721 _foreignNFT, address _to)
2076     external
2077     onlyTokenAssignmentControl
2078     {
2079         _foreignNFT.setApprovalForAll(_to, true);
2080     }
2081 
2082 }