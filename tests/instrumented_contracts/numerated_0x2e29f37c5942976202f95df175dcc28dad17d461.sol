1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Address.sol
4 
5 
6 /*
7    _____  .___        ________                                                                            .___    ________                                             
8   /  _  \ |   |       \______ \  __ __  ____    ____   ____  ____   ____   ______      _____    ____    __| _/    \______ \____________     ____   ____   ____   ______
9  /  /_\  \|   |        |    |  \|  |  \/    \  / ___\_/ __ \/  _ \ /    \ /  ___/      \__  \  /    \  / __ |      |    |  \_  __ \__  \   / ___\ /  _ \ /    \ /  ___/
10 /    |    \   |        |    `   \  |  /   |  \/ /_/  >  ___(  <_> )   |  \\___ \        / __ \|   |  \/ /_/ |      |    `   \  | \// __ \_/ /_/  >  <_> )   |  \\___ \ 
11 \____|__  /___|       /_______  /____/|___|  /\___  / \___  >____/|___|  /____  >      (____  /___|  /\____ |     /_______  /__|  (____  /\___  / \____/|___|  /____  >
12         \/                    \/           \//_____/      \/           \/     \/            \/     \/      \/             \/           \//_____/             \/     \/ 
13                                                                                                                                                                        
14                                                                                                                                                                        
15                                                                                                                                                                        
16                                                                                                                                                                        
17                                                                                                                                                                        
18                                                                                                                                                                        
19                                                          ________                            .__                                                                       
20                                                         /  _____/  ____   ____   ____   _____|__| ______                                                               
21                                                        /   \  ____/ __ \ /    \_/ __ \ /  ___/  |/  ___/                                                               
22                                                        \    \_\  \  ___/|   |  \  ___/ \___ \|  |\___ \                                                                
23                                                         \______  /\___  >___|  /\___  >____  >__/____  >                                                               
24                                                                \/     \/     \/     \/     \/        \/                                                             
25 
26 */
27 
28 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
29 
30 pragma solidity ^0.8.1;
31 
32 /**
33  * @dev Collection of functions related to the address type
34  */
35 library Address {
36     /**
37      * @dev Returns true if `account` is a contract.
38      *
39      * [IMPORTANT]
40      * ====
41      * It is unsafe to assume that an address for which this function returns
42      * false is an externally-owned account (EOA) and not a contract.
43      *
44      * Among others, `isContract` will return false for the following
45      * types of addresses:
46      *
47      *  - an externally-owned account
48      *  - a contract in construction
49      *  - an address where a contract will be created
50      *  - an address where a contract lived, but was destroyed
51      * ====
52      *
53      * [IMPORTANT]
54      * ====
55      * You shouldn't rely on `isContract` to protect against flash loan attacks!
56      *
57      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
58      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
59      * constructor.
60      * ====
61      */
62     function isContract(address account) internal view returns (bool) {
63         // This method relies on extcodesize/address.code.length, which returns 0
64         // for contracts in construction, since the code is only stored at the end
65         // of the constructor execution.
66 
67         return account.code.length > 0;
68     }
69 
70     /**
71      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
72      * `recipient`, forwarding all available gas and reverting on errors.
73      *
74      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
75      * of certain opcodes, possibly making contracts go over the 2300 gas limit
76      * imposed by `transfer`, making them unable to receive funds via
77      * `transfer`. {sendValue} removes this limitation.
78      *
79      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
80      *
81      * IMPORTANT: because control is transferred to `recipient`, care must be
82      * taken to not create reentrancy vulnerabilities. Consider using
83      * {ReentrancyGuard} or the
84      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
85      */
86     function sendValue(address payable recipient, uint256 amount) internal {
87         require(address(this).balance >= amount, "Address: insufficient balance");
88 
89         (bool success, ) = recipient.call{value: amount}("");
90         require(success, "Address: unable to send value, recipient may have reverted");
91     }
92 
93     /**
94      * @dev Performs a Solidity function call using a low level `call`. A
95      * plain `call` is an unsafe replacement for a function call: use this
96      * function instead.
97      *
98      * If `target` reverts with a revert reason, it is bubbled up by this
99      * function (like regular Solidity function calls).
100      *
101      * Returns the raw returned data. To convert to the expected return value,
102      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
103      *
104      * Requirements:
105      *
106      * - `target` must be a contract.
107      * - calling `target` with `data` must not revert.
108      *
109      * _Available since v3.1._
110      */
111     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
112         return functionCall(target, data, "Address: low-level call failed");
113     }
114 
115     /**
116      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
117      * `errorMessage` as a fallback revert reason when `target` reverts.
118      *
119      * _Available since v3.1._
120      */
121     function functionCall(
122         address target,
123         bytes memory data,
124         string memory errorMessage
125     ) internal returns (bytes memory) {
126         return functionCallWithValue(target, data, 0, errorMessage);
127     }
128 
129     /**
130      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
131      * but also transferring `value` wei to `target`.
132      *
133      * Requirements:
134      *
135      * - the calling contract must have an ETH balance of at least `value`.
136      * - the called Solidity function must be `payable`.
137      *
138      * _Available since v3.1._
139      */
140     function functionCallWithValue(
141         address target,
142         bytes memory data,
143         uint256 value
144     ) internal returns (bytes memory) {
145         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
146     }
147 
148     /**
149      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
150      * with `errorMessage` as a fallback revert reason when `target` reverts.
151      *
152      * _Available since v3.1._
153      */
154     function functionCallWithValue(
155         address target,
156         bytes memory data,
157         uint256 value,
158         string memory errorMessage
159     ) internal returns (bytes memory) {
160         require(address(this).balance >= value, "Address: insufficient balance for call");
161         require(isContract(target), "Address: call to non-contract");
162 
163         (bool success, bytes memory returndata) = target.call{value: value}(data);
164         return verifyCallResult(success, returndata, errorMessage);
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
169      * but performing a static call.
170      *
171      * _Available since v3.3._
172      */
173     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
174         return functionStaticCall(target, data, "Address: low-level static call failed");
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
179      * but performing a static call.
180      *
181      * _Available since v3.3._
182      */
183     function functionStaticCall(
184         address target,
185         bytes memory data,
186         string memory errorMessage
187     ) internal view returns (bytes memory) {
188         require(isContract(target), "Address: static call to non-contract");
189 
190         (bool success, bytes memory returndata) = target.staticcall(data);
191         return verifyCallResult(success, returndata, errorMessage);
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
196      * but performing a delegate call.
197      *
198      * _Available since v3.4._
199      */
200     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
201         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
202     }
203 
204     /**
205      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
206      * but performing a delegate call.
207      *
208      * _Available since v3.4._
209      */
210     function functionDelegateCall(
211         address target,
212         bytes memory data,
213         string memory errorMessage
214     ) internal returns (bytes memory) {
215         require(isContract(target), "Address: delegate call to non-contract");
216 
217         (bool success, bytes memory returndata) = target.delegatecall(data);
218         return verifyCallResult(success, returndata, errorMessage);
219     }
220 
221     /**
222      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
223      * revert reason using the provided one.
224      *
225      * _Available since v4.3._
226      */
227     function verifyCallResult(
228         bool success,
229         bytes memory returndata,
230         string memory errorMessage
231     ) internal pure returns (bytes memory) {
232         if (success) {
233             return returndata;
234         } else {
235             // Look for revert reason and bubble it up if present
236             if (returndata.length > 0) {
237                 // The easiest way to bubble the revert reason is using memory via assembly
238 
239                 assembly {
240                     let returndata_size := mload(returndata)
241                     revert(add(32, returndata), returndata_size)
242                 }
243             } else {
244                 revert(errorMessage);
245             }
246         }
247     }
248 }
249 
250 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
251 
252 
253 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
254 
255 pragma solidity ^0.8.0;
256 
257 /**
258  * @title ERC721 token receiver interface
259  * @dev Interface for any contract that wants to support safeTransfers
260  * from ERC721 asset contracts.
261  */
262 interface IERC721Receiver {
263     /**
264      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
265      * by `operator` from `from`, this function is called.
266      *
267      * It must return its Solidity selector to confirm the token transfer.
268      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
269      *
270      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
271      */
272     function onERC721Received(
273         address operator,
274         address from,
275         uint256 tokenId,
276         bytes calldata data
277     ) external returns (bytes4);
278 }
279 
280 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
281 
282 
283 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
284 
285 pragma solidity ^0.8.0;
286 
287 /**
288  * @dev Interface of the ERC165 standard, as defined in the
289  * https://eips.ethereum.org/EIPS/eip-165[EIP].
290  *
291  * Implementers can declare support of contract interfaces, which can then be
292  * queried by others ({ERC165Checker}).
293  *
294  * For an implementation, see {ERC165}.
295  */
296 interface IERC165 {
297     /**
298      * @dev Returns true if this contract implements the interface defined by
299      * `interfaceId`. See the corresponding
300      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
301      * to learn more about how these ids are created.
302      *
303      * This function call must use less than 30 000 gas.
304      */
305     function supportsInterface(bytes4 interfaceId) external view returns (bool);
306 }
307 
308 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
309 
310 
311 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
312 
313 pragma solidity ^0.8.0;
314 
315 
316 /**
317  * @dev Implementation of the {IERC165} interface.
318  *
319  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
320  * for the additional interface id that will be supported. For example:
321  *
322  * ```solidity
323  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
324  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
325  * }
326  * ```
327  *
328  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
329  */
330 abstract contract ERC165 is IERC165 {
331     /**
332      * @dev See {IERC165-supportsInterface}.
333      */
334     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
335         return interfaceId == type(IERC165).interfaceId;
336     }
337 }
338 
339 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
340 
341 
342 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
343 
344 pragma solidity ^0.8.0;
345 
346 
347 /**
348  * @dev Required interface of an ERC721 compliant contract.
349  */
350 interface IERC721 is IERC165 {
351     /**
352      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
353      */
354     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
355 
356     /**
357      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
358      */
359     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
360 
361     /**
362      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
363      */
364     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
365 
366     /**
367      * @dev Returns the number of tokens in ``owner``'s account.
368      */
369     function balanceOf(address owner) external view returns (uint256 balance);
370 
371     /**
372      * @dev Returns the owner of the `tokenId` token.
373      *
374      * Requirements:
375      *
376      * - `tokenId` must exist.
377      */
378     function ownerOf(uint256 tokenId) external view returns (address owner);
379 
380     /**
381      * @dev Safely transfers `tokenId` token from `from` to `to`.
382      *
383      * Requirements:
384      *
385      * - `from` cannot be the zero address.
386      * - `to` cannot be the zero address.
387      * - `tokenId` token must exist and be owned by `from`.
388      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
389      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
390      *
391      * Emits a {Transfer} event.
392      */
393     function safeTransferFrom(
394         address from,
395         address to,
396         uint256 tokenId,
397         bytes calldata data
398     ) external;
399 
400     /**
401      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
402      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
403      *
404      * Requirements:
405      *
406      * - `from` cannot be the zero address.
407      * - `to` cannot be the zero address.
408      * - `tokenId` token must exist and be owned by `from`.
409      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
410      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
411      *
412      * Emits a {Transfer} event.
413      */
414     function safeTransferFrom(
415         address from,
416         address to,
417         uint256 tokenId
418     ) external;
419 
420     /**
421      * @dev Transfers `tokenId` token from `from` to `to`.
422      *
423      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
424      *
425      * Requirements:
426      *
427      * - `from` cannot be the zero address.
428      * - `to` cannot be the zero address.
429      * - `tokenId` token must be owned by `from`.
430      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
431      *
432      * Emits a {Transfer} event.
433      */
434     function transferFrom(
435         address from,
436         address to,
437         uint256 tokenId
438     ) external;
439 
440     /**
441      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
442      * The approval is cleared when the token is transferred.
443      *
444      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
445      *
446      * Requirements:
447      *
448      * - The caller must own the token or be an approved operator.
449      * - `tokenId` must exist.
450      *
451      * Emits an {Approval} event.
452      */
453     function approve(address to, uint256 tokenId) external;
454 
455     /**
456      * @dev Approve or remove `operator` as an operator for the caller.
457      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
458      *
459      * Requirements:
460      *
461      * - The `operator` cannot be the caller.
462      *
463      * Emits an {ApprovalForAll} event.
464      */
465     function setApprovalForAll(address operator, bool _approved) external;
466 
467     /**
468      * @dev Returns the account approved for `tokenId` token.
469      *
470      * Requirements:
471      *
472      * - `tokenId` must exist.
473      */
474     function getApproved(uint256 tokenId) external view returns (address operator);
475 
476     /**
477      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
478      *
479      * See {setApprovalForAll}
480      */
481     function isApprovedForAll(address owner, address operator) external view returns (bool);
482 }
483 
484 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
485 
486 
487 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
488 
489 pragma solidity ^0.8.0;
490 
491 
492 /**
493  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
494  * @dev See https://eips.ethereum.org/EIPS/eip-721
495  */
496 interface IERC721Enumerable is IERC721 {
497     /**
498      * @dev Returns the total amount of tokens stored by the contract.
499      */
500     function totalSupply() external view returns (uint256);
501 
502     /**
503      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
504      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
505      */
506     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
507 
508     /**
509      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
510      * Use along with {totalSupply} to enumerate all tokens.
511      */
512     function tokenByIndex(uint256 index) external view returns (uint256);
513 }
514 
515 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
516 
517 
518 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
519 
520 pragma solidity ^0.8.0;
521 
522 
523 /**
524  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
525  * @dev See https://eips.ethereum.org/EIPS/eip-721
526  */
527 interface IERC721Metadata is IERC721 {
528     /**
529      * @dev Returns the token collection name.
530      */
531     function name() external view returns (string memory);
532 
533     /**
534      * @dev Returns the token collection symbol.
535      */
536     function symbol() external view returns (string memory);
537 
538     /**
539      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
540      */
541     function tokenURI(uint256 tokenId) external view returns (string memory);
542 }
543 
544 // File: @openzeppelin/contracts/utils/Strings.sol
545 
546 
547 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
548 
549 pragma solidity ^0.8.0;
550 
551 /**
552  * @dev String operations.
553  */
554 library Strings {
555     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
556 
557     /**
558      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
559      */
560     function toString(uint256 value) internal pure returns (string memory) {
561         // Inspired by OraclizeAPI's implementation - MIT licence
562         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
563 
564         if (value == 0) {
565             return "0";
566         }
567         uint256 temp = value;
568         uint256 digits;
569         while (temp != 0) {
570             digits++;
571             temp /= 10;
572         }
573         bytes memory buffer = new bytes(digits);
574         while (value != 0) {
575             digits -= 1;
576             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
577             value /= 10;
578         }
579         return string(buffer);
580     }
581 
582     /**
583      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
584      */
585     function toHexString(uint256 value) internal pure returns (string memory) {
586         if (value == 0) {
587             return "0x00";
588         }
589         uint256 temp = value;
590         uint256 length = 0;
591         while (temp != 0) {
592             length++;
593             temp >>= 8;
594         }
595         return toHexString(value, length);
596     }
597 
598     /**
599      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
600      */
601     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
602         bytes memory buffer = new bytes(2 * length + 2);
603         buffer[0] = "0";
604         buffer[1] = "x";
605         for (uint256 i = 2 * length + 1; i > 1; --i) {
606             buffer[i] = _HEX_SYMBOLS[value & 0xf];
607             value >>= 4;
608         }
609         require(value == 0, "Strings: hex length insufficient");
610         return string(buffer);
611     }
612 }
613 
614 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
615 
616 
617 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
618 
619 pragma solidity ^0.8.0;
620 
621 
622 /**
623  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
624  *
625  * These functions can be used to verify that a message was signed by the holder
626  * of the private keys of a given address.
627  */
628 library ECDSA {
629     enum RecoverError {
630         NoError,
631         InvalidSignature,
632         InvalidSignatureLength,
633         InvalidSignatureS,
634         InvalidSignatureV
635     }
636 
637     function _throwError(RecoverError error) private pure {
638         if (error == RecoverError.NoError) {
639             return; // no error: do nothing
640         } else if (error == RecoverError.InvalidSignature) {
641             revert("ECDSA: invalid signature");
642         } else if (error == RecoverError.InvalidSignatureLength) {
643             revert("ECDSA: invalid signature length");
644         } else if (error == RecoverError.InvalidSignatureS) {
645             revert("ECDSA: invalid signature 's' value");
646         } else if (error == RecoverError.InvalidSignatureV) {
647             revert("ECDSA: invalid signature 'v' value");
648         }
649     }
650 
651     /**
652      * @dev Returns the address that signed a hashed message (`hash`) with
653      * `signature` or error string. This address can then be used for verification purposes.
654      *
655      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
656      * this function rejects them by requiring the `s` value to be in the lower
657      * half order, and the `v` value to be either 27 or 28.
658      *
659      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
660      * verification to be secure: it is possible to craft signatures that
661      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
662      * this is by receiving a hash of the original message (which may otherwise
663      * be too long), and then calling {toEthSignedMessageHash} on it.
664      *
665      * Documentation for signature generation:
666      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
667      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
668      *
669      * _Available since v4.3._
670      */
671     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
672         // Check the signature length
673         // - case 65: r,s,v signature (standard)
674         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
675         if (signature.length == 65) {
676             bytes32 r;
677             bytes32 s;
678             uint8 v;
679             // ecrecover takes the signature parameters, and the only way to get them
680             // currently is to use assembly.
681             assembly {
682                 r := mload(add(signature, 0x20))
683                 s := mload(add(signature, 0x40))
684                 v := byte(0, mload(add(signature, 0x60)))
685             }
686             return tryRecover(hash, v, r, s);
687         } else if (signature.length == 64) {
688             bytes32 r;
689             bytes32 vs;
690             // ecrecover takes the signature parameters, and the only way to get them
691             // currently is to use assembly.
692             assembly {
693                 r := mload(add(signature, 0x20))
694                 vs := mload(add(signature, 0x40))
695             }
696             return tryRecover(hash, r, vs);
697         } else {
698             return (address(0), RecoverError.InvalidSignatureLength);
699         }
700     }
701 
702     /**
703      * @dev Returns the address that signed a hashed message (`hash`) with
704      * `signature`. This address can then be used for verification purposes.
705      *
706      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
707      * this function rejects them by requiring the `s` value to be in the lower
708      * half order, and the `v` value to be either 27 or 28.
709      *
710      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
711      * verification to be secure: it is possible to craft signatures that
712      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
713      * this is by receiving a hash of the original message (which may otherwise
714      * be too long), and then calling {toEthSignedMessageHash} on it.
715      */
716     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
717         (address recovered, RecoverError error) = tryRecover(hash, signature);
718         _throwError(error);
719         return recovered;
720     }
721 
722     /**
723      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
724      *
725      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
726      *
727      * _Available since v4.3._
728      */
729     function tryRecover(
730         bytes32 hash,
731         bytes32 r,
732         bytes32 vs
733     ) internal pure returns (address, RecoverError) {
734         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
735         uint8 v = uint8((uint256(vs) >> 255) + 27);
736         return tryRecover(hash, v, r, s);
737     }
738 
739     /**
740      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
741      *
742      * _Available since v4.2._
743      */
744     function recover(
745         bytes32 hash,
746         bytes32 r,
747         bytes32 vs
748     ) internal pure returns (address) {
749         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
750         _throwError(error);
751         return recovered;
752     }
753 
754     /**
755      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
756      * `r` and `s` signature fields separately.
757      *
758      * _Available since v4.3._
759      */
760     function tryRecover(
761         bytes32 hash,
762         uint8 v,
763         bytes32 r,
764         bytes32 s
765     ) internal pure returns (address, RecoverError) {
766         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
767         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
768         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
769         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
770         //
771         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
772         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
773         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
774         // these malleable signatures as well.
775         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
776             return (address(0), RecoverError.InvalidSignatureS);
777         }
778         if (v != 27 && v != 28) {
779             return (address(0), RecoverError.InvalidSignatureV);
780         }
781 
782         // If the signature is valid (and not malleable), return the signer address
783         address signer = ecrecover(hash, v, r, s);
784         if (signer == address(0)) {
785             return (address(0), RecoverError.InvalidSignature);
786         }
787 
788         return (signer, RecoverError.NoError);
789     }
790 
791     /**
792      * @dev Overload of {ECDSA-recover} that receives the `v`,
793      * `r` and `s` signature fields separately.
794      */
795     function recover(
796         bytes32 hash,
797         uint8 v,
798         bytes32 r,
799         bytes32 s
800     ) internal pure returns (address) {
801         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
802         _throwError(error);
803         return recovered;
804     }
805 
806     /**
807      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
808      * produces hash corresponding to the one signed with the
809      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
810      * JSON-RPC method as part of EIP-191.
811      *
812      * See {recover}.
813      */
814     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
815         // 32 is the length in bytes of hash,
816         // enforced by the type signature above
817         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
818     }
819 
820     /**
821      * @dev Returns an Ethereum Signed Message, created from `s`. This
822      * produces hash corresponding to the one signed with the
823      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
824      * JSON-RPC method as part of EIP-191.
825      *
826      * See {recover}.
827      */
828     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
829         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
830     }
831 
832     /**
833      * @dev Returns an Ethereum Signed Typed Data, created from a
834      * `domainSeparator` and a `structHash`. This produces hash corresponding
835      * to the one signed with the
836      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
837      * JSON-RPC method as part of EIP-712.
838      *
839      * See {recover}.
840      */
841     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
842         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
843     }
844 }
845 
846 // File: @openzeppelin/contracts/utils/Context.sol
847 
848 
849 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
850 
851 pragma solidity ^0.8.0;
852 
853 /**
854  * @dev Provides information about the current execution context, including the
855  * sender of the transaction and its data. While these are generally available
856  * via msg.sender and msg.data, they should not be accessed in such a direct
857  * manner, since when dealing with meta-transactions the account sending and
858  * paying for execution may not be the actual sender (as far as an application
859  * is concerned).
860  *
861  * This contract is only required for intermediate, library-like contracts.
862  */
863 abstract contract Context {
864     function _msgSender() internal view virtual returns (address) {
865         return msg.sender;
866     }
867 
868     function _msgData() internal view virtual returns (bytes calldata) {
869         return msg.data;
870     }
871 }
872 
873 // File: contracts/ERC721A.sol
874 
875 
876 // Creator: Chiru Labs
877 
878 pragma solidity ^0.8.4;
879 
880 
881 
882 
883 
884 
885 
886 
887 
888 error ApprovalCallerNotOwnerNorApproved();
889 error ApprovalQueryForNonexistentToken();
890 error ApproveToCaller();
891 error ApprovalToCurrentOwner();
892 error BalanceQueryForZeroAddress();
893 error MintToZeroAddress();
894 error MintZeroQuantity();
895 error OwnerQueryForNonexistentToken();
896 error TransferCallerNotOwnerNorApproved();
897 error TransferFromIncorrectOwner();
898 error TransferToNonERC721ReceiverImplementer();
899 error TransferToZeroAddress();
900 error URIQueryForNonexistentToken();
901 
902 /**
903  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
904  * the Metadata extension. Built to optimize for lower gas during batch mints.
905  *
906  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
907  *
908  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
909  *
910  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
911  */
912 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
913     using Address for address;
914     using Strings for uint256;
915 
916     // Compiler will pack this into a single 256bit word.
917     struct TokenOwnership {
918         // The address of the owner.
919         address addr;
920         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
921         uint64 startTimestamp;
922         // Whether the token has been burned.
923         bool burned;
924     }
925 
926     // Compiler will pack this into a single 256bit word.
927     struct AddressData {
928         // Realistically, 2**64-1 is more than enough.
929         uint64 balance;
930         // Keeps track of mint count with minimal overhead for tokenomics.
931         uint64 numberMinted;
932         // Keeps track of burn count with minimal overhead for tokenomics.
933         uint64 numberBurned;
934         // For miscellaneous variable(s) pertaining to the address
935         // (e.g. number of whitelist mint slots used).
936         // If there are multiple variables, please pack them into a uint64.
937         uint64 aux;
938     }
939 
940     // The tokenId of the next token to be minted.
941     uint256 internal _currentIndex;
942 
943     // The number of tokens burned.
944     uint256 internal _burnCounter;
945 
946     // Token name
947     string private _name;
948 
949     // Token symbol
950     string private _symbol;
951 
952     // Mapping from token ID to ownership details
953     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
954     mapping(uint256 => TokenOwnership) internal _ownerships;
955 
956     // Mapping owner address to address data
957     mapping(address => AddressData) private _addressData;
958 
959     // Mapping from token ID to approved address
960     mapping(uint256 => address) private _tokenApprovals;
961 
962     // Mapping from owner to operator approvals
963     mapping(address => mapping(address => bool)) private _operatorApprovals;
964 
965     constructor(string memory name_, string memory symbol_) {
966         _name = name_;
967         _symbol = symbol_;
968         _currentIndex = _startTokenId();
969     }
970 
971     /**
972      * To change the starting tokenId, please override this function.
973      */
974     function _startTokenId() internal view virtual returns (uint256) {
975         return 0;
976     }
977 
978     /**
979      * @dev See {IERC721Enumerable-totalSupply}.
980      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
981      */
982     function totalSupply() public view returns (uint256) {
983         // Counter underflow is impossible as _burnCounter cannot be incremented
984         // more than _currentIndex - _startTokenId() times
985         unchecked {
986             return _currentIndex - _burnCounter - _startTokenId();
987         }
988     }
989 
990     /**
991      * Returns the total amount of tokens minted in the contract.
992      */
993     function _totalMinted() internal view returns (uint256) {
994         // Counter underflow is impossible as _currentIndex does not decrement,
995         // and it is initialized to _startTokenId()
996         unchecked {
997             return _currentIndex - _startTokenId();
998         }
999     }
1000 
1001     /**
1002      * @dev See {IERC165-supportsInterface}.
1003      */
1004     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1005         return
1006             interfaceId == type(IERC721).interfaceId ||
1007             interfaceId == type(IERC721Metadata).interfaceId ||
1008             super.supportsInterface(interfaceId);
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-balanceOf}.
1013      */
1014     function balanceOf(address owner) public view override returns (uint256) {
1015         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1016         return uint256(_addressData[owner].balance);
1017     }
1018 
1019     /**
1020      * Returns the number of tokens minted by `owner`.
1021      */
1022     function _numberMinted(address owner) internal view returns (uint256) {
1023         return uint256(_addressData[owner].numberMinted);
1024     }
1025 
1026     /**
1027      * Returns the number of tokens burned by or on behalf of `owner`.
1028      */
1029     function _numberBurned(address owner) internal view returns (uint256) {
1030         return uint256(_addressData[owner].numberBurned);
1031     }
1032 
1033     /**
1034      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1035      */
1036     function _getAux(address owner) internal view returns (uint64) {
1037         return _addressData[owner].aux;
1038     }
1039 
1040     /**
1041      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1042      * If there are multiple variables, please pack them into a uint64.
1043      */
1044     function _setAux(address owner, uint64 aux) internal {
1045         _addressData[owner].aux = aux;
1046     }
1047 
1048     /**
1049      * Gas spent here starts off proportional to the maximum mint batch size.
1050      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1051      */
1052     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1053         uint256 curr = tokenId;
1054 
1055         unchecked {
1056             if (_startTokenId() <= curr && curr < _currentIndex) {
1057                 TokenOwnership memory ownership = _ownerships[curr];
1058                 if (!ownership.burned) {
1059                     if (ownership.addr != address(0)) {
1060                         return ownership;
1061                     }
1062                     // Invariant:
1063                     // There will always be an ownership that has an address and is not burned
1064                     // before an ownership that does not have an address and is not burned.
1065                     // Hence, curr will not underflow.
1066                     while (true) {
1067                         curr--;
1068                         ownership = _ownerships[curr];
1069                         if (ownership.addr != address(0)) {
1070                             return ownership;
1071                         }
1072                     }
1073                 }
1074             }
1075         }
1076         revert OwnerQueryForNonexistentToken();
1077     }
1078 
1079     /**
1080      * @dev See {IERC721-ownerOf}.
1081      */
1082     function ownerOf(uint256 tokenId) public view override returns (address) {
1083         return _ownershipOf(tokenId).addr;
1084     }
1085 
1086     /**
1087      * @dev See {IERC721Metadata-name}.
1088      */
1089     function name() public view virtual override returns (string memory) {
1090         return _name;
1091     }
1092 
1093     /**
1094      * @dev See {IERC721Metadata-symbol}.
1095      */
1096     function symbol() public view virtual override returns (string memory) {
1097         return _symbol;
1098     }
1099 
1100     /**
1101      * @dev See {IERC721Metadata-tokenURI}.
1102      */
1103     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1104         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1105 
1106         string memory baseURI = _baseURI();
1107         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1108     }
1109 
1110     /**
1111      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1112      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1113      * by default, can be overriden in child contracts.
1114      */
1115     function _baseURI() internal view virtual returns (string memory) {
1116         return '';
1117     }
1118 
1119     /**
1120      * @dev See {IERC721-approve}.
1121      */
1122     function approve(address to, uint256 tokenId) public override {
1123         address owner = ERC721A.ownerOf(tokenId);
1124         if (to == owner) revert ApprovalToCurrentOwner();
1125 
1126         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1127             revert ApprovalCallerNotOwnerNorApproved();
1128         }
1129 
1130         _approve(to, tokenId, owner);
1131     }
1132 
1133     /**
1134      * @dev See {IERC721-getApproved}.
1135      */
1136     function getApproved(uint256 tokenId) public view override returns (address) {
1137         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1138 
1139         return _tokenApprovals[tokenId];
1140     }
1141 
1142     /**
1143      * @dev See {IERC721-setApprovalForAll}.
1144      */
1145     function setApprovalForAll(address operator, bool approved) public virtual override {
1146         if (operator == _msgSender()) revert ApproveToCaller();
1147 
1148         _operatorApprovals[_msgSender()][operator] = approved;
1149         emit ApprovalForAll(_msgSender(), operator, approved);
1150     }
1151 
1152     /**
1153      * @dev See {IERC721-isApprovedForAll}.
1154      */
1155     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1156         return _operatorApprovals[owner][operator];
1157     }
1158 
1159     /**
1160      * @dev See {IERC721-transferFrom}.
1161      */
1162     function transferFrom(
1163         address from,
1164         address to,
1165         uint256 tokenId
1166     ) public virtual override {
1167         _transfer(from, to, tokenId);
1168     }
1169 
1170     /**
1171      * @dev See {IERC721-safeTransferFrom}.
1172      */
1173     function safeTransferFrom(
1174         address from,
1175         address to,
1176         uint256 tokenId
1177     ) public virtual override {
1178         safeTransferFrom(from, to, tokenId, '');
1179     }
1180 
1181     /**
1182      * @dev See {IERC721-safeTransferFrom}.
1183      */
1184     function safeTransferFrom(
1185         address from,
1186         address to,
1187         uint256 tokenId,
1188         bytes memory _data
1189     ) public virtual override {
1190         _transfer(from, to, tokenId);
1191         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1192             revert TransferToNonERC721ReceiverImplementer();
1193         }
1194     }
1195 
1196     /**
1197      * @dev Returns whether `tokenId` exists.
1198      *
1199      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1200      *
1201      * Tokens start existing when they are minted (`_mint`),
1202      */
1203     function _exists(uint256 tokenId) internal view returns (bool) {
1204         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1205             !_ownerships[tokenId].burned;
1206     }
1207 
1208     function _safeMint(address to, uint256 quantity) internal {
1209         _safeMint(to, quantity, '');
1210     }
1211 
1212     /**
1213      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1214      *
1215      * Requirements:
1216      *
1217      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1218      * - `quantity` must be greater than 0.
1219      *
1220      * Emits a {Transfer} event.
1221      */
1222     function _safeMint(
1223         address to,
1224         uint256 quantity,
1225         bytes memory _data
1226     ) internal {
1227         _mint(to, quantity, _data, true);
1228     }
1229 
1230     /**
1231      * @dev Mints `quantity` tokens and transfers them to `to`.
1232      *
1233      * Requirements:
1234      *
1235      * - `to` cannot be the zero address.
1236      * - `quantity` must be greater than 0.
1237      *
1238      * Emits a {Transfer} event.
1239      */
1240     function _mint(
1241         address to,
1242         uint256 quantity,
1243         bytes memory _data,
1244         bool safe
1245     ) internal {
1246         uint256 startTokenId = _currentIndex;
1247         if (to == address(0)) revert MintToZeroAddress();
1248         if (quantity == 0) revert MintZeroQuantity();
1249 
1250         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1251 
1252         // Overflows are incredibly unrealistic.
1253         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1254         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1255         unchecked {
1256             _addressData[to].balance += uint64(quantity);
1257             _addressData[to].numberMinted += uint64(quantity);
1258 
1259             _ownerships[startTokenId].addr = to;
1260             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1261 
1262             uint256 updatedIndex = startTokenId;
1263             uint256 end = updatedIndex + quantity;
1264 
1265             if (safe && to.isContract()) {
1266                 do {
1267                     emit Transfer(address(0), to, updatedIndex);
1268                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1269                         revert TransferToNonERC721ReceiverImplementer();
1270                     }
1271                 } while (updatedIndex != end);
1272                 // Reentrancy protection
1273                 if (_currentIndex != startTokenId) revert();
1274             } else {
1275                 do {
1276                     emit Transfer(address(0), to, updatedIndex++);
1277                 } while (updatedIndex != end);
1278             }
1279             _currentIndex = updatedIndex;
1280         }
1281         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1282     }
1283 
1284     /**
1285      * @dev Transfers `tokenId` from `from` to `to`.
1286      *
1287      * Requirements:
1288      *
1289      * - `to` cannot be the zero address.
1290      * - `tokenId` token must be owned by `from`.
1291      *
1292      * Emits a {Transfer} event.
1293      */
1294     function _transfer(
1295         address from,
1296         address to,
1297         uint256 tokenId
1298     ) private {
1299         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1300 
1301         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1302 
1303         bool isApprovedOrOwner = (_msgSender() == from ||
1304             isApprovedForAll(from, _msgSender()) ||
1305             getApproved(tokenId) == _msgSender());
1306 
1307         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1308         if (to == address(0)) revert TransferToZeroAddress();
1309 
1310         _beforeTokenTransfers(from, to, tokenId, 1);
1311 
1312         // Clear approvals from the previous owner
1313         _approve(address(0), tokenId, from);
1314 
1315         // Underflow of the sender's balance is impossible because we check for
1316         // ownership above and the recipient's balance can't realistically overflow.
1317         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1318         unchecked {
1319             _addressData[from].balance -= 1;
1320             _addressData[to].balance += 1;
1321 
1322             TokenOwnership storage currSlot = _ownerships[tokenId];
1323             currSlot.addr = to;
1324             currSlot.startTimestamp = uint64(block.timestamp);
1325 
1326             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1327             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1328             uint256 nextTokenId = tokenId + 1;
1329             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1330             if (nextSlot.addr == address(0)) {
1331                 // This will suffice for checking _exists(nextTokenId),
1332                 // as a burned slot cannot contain the zero address.
1333                 if (nextTokenId != _currentIndex) {
1334                     nextSlot.addr = from;
1335                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1336                 }
1337             }
1338         }
1339 
1340         emit Transfer(from, to, tokenId);
1341         _afterTokenTransfers(from, to, tokenId, 1);
1342     }
1343 
1344     /**
1345      * @dev This is equivalent to _burn(tokenId, false)
1346      */
1347     function _burn(uint256 tokenId) internal virtual {
1348         _burn(tokenId, false);
1349     }
1350 
1351     /**
1352      * @dev Destroys `tokenId`.
1353      * The approval is cleared when the token is burned.
1354      *
1355      * Requirements:
1356      *
1357      * - `tokenId` must exist.
1358      *
1359      * Emits a {Transfer} event.
1360      */
1361     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1362         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1363 
1364         address from = prevOwnership.addr;
1365 
1366         if (approvalCheck) {
1367             bool isApprovedOrOwner = (_msgSender() == from ||
1368                 isApprovedForAll(from, _msgSender()) ||
1369                 getApproved(tokenId) == _msgSender());
1370 
1371             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1372         }
1373 
1374         _beforeTokenTransfers(from, address(0), tokenId, 1);
1375 
1376         // Clear approvals from the previous owner
1377         _approve(address(0), tokenId, from);
1378 
1379         // Underflow of the sender's balance is impossible because we check for
1380         // ownership above and the recipient's balance can't realistically overflow.
1381         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1382         unchecked {
1383             AddressData storage addressData = _addressData[from];
1384             addressData.balance -= 1;
1385             addressData.numberBurned += 1;
1386 
1387             // Keep track of who burned the token, and the timestamp of burning.
1388             TokenOwnership storage currSlot = _ownerships[tokenId];
1389             currSlot.addr = from;
1390             currSlot.startTimestamp = uint64(block.timestamp);
1391             currSlot.burned = true;
1392 
1393             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1394             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1395             uint256 nextTokenId = tokenId + 1;
1396             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1397             if (nextSlot.addr == address(0)) {
1398                 // This will suffice for checking _exists(nextTokenId),
1399                 // as a burned slot cannot contain the zero address.
1400                 if (nextTokenId != _currentIndex) {
1401                     nextSlot.addr = from;
1402                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1403                 }
1404             }
1405         }
1406 
1407         emit Transfer(from, address(0), tokenId);
1408         _afterTokenTransfers(from, address(0), tokenId, 1);
1409 
1410         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1411         unchecked {
1412             _burnCounter++;
1413         }
1414     }
1415 
1416     /**
1417      * @dev Approve `to` to operate on `tokenId`
1418      *
1419      * Emits a {Approval} event.
1420      */
1421     function _approve(
1422         address to,
1423         uint256 tokenId,
1424         address owner
1425     ) private {
1426         _tokenApprovals[tokenId] = to;
1427         emit Approval(owner, to, tokenId);
1428     }
1429 
1430     /**
1431      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1432      *
1433      * @param from address representing the previous owner of the given token ID
1434      * @param to target address that will receive the tokens
1435      * @param tokenId uint256 ID of the token to be transferred
1436      * @param _data bytes optional data to send along with the call
1437      * @return bool whether the call correctly returned the expected magic value
1438      */
1439     function _checkContractOnERC721Received(
1440         address from,
1441         address to,
1442         uint256 tokenId,
1443         bytes memory _data
1444     ) private returns (bool) {
1445         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1446             return retval == IERC721Receiver(to).onERC721Received.selector;
1447         } catch (bytes memory reason) {
1448             if (reason.length == 0) {
1449                 revert TransferToNonERC721ReceiverImplementer();
1450             } else {
1451                 assembly {
1452                     revert(add(32, reason), mload(reason))
1453                 }
1454             }
1455         }
1456     }
1457 
1458     /**
1459      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1460      * And also called before burning one token.
1461      *
1462      * startTokenId - the first token id to be transferred
1463      * quantity - the amount to be transferred
1464      *
1465      * Calling conditions:
1466      *
1467      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1468      * transferred to `to`.
1469      * - When `from` is zero, `tokenId` will be minted for `to`.
1470      * - When `to` is zero, `tokenId` will be burned by `from`.
1471      * - `from` and `to` are never both zero.
1472      */
1473     function _beforeTokenTransfers(
1474         address from,
1475         address to,
1476         uint256 startTokenId,
1477         uint256 quantity
1478     ) internal virtual {}
1479 
1480     /**
1481      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1482      * minting.
1483      * And also called after one token has been burned.
1484      *
1485      * startTokenId - the first token id to be transferred
1486      * quantity - the amount to be transferred
1487      *
1488      * Calling conditions:
1489      *
1490      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1491      * transferred to `to`.
1492      * - When `from` is zero, `tokenId` has been minted for `to`.
1493      * - When `to` is zero, `tokenId` has been burned by `from`.
1494      * - `from` and `to` are never both zero.
1495      */
1496     function _afterTokenTransfers(
1497         address from,
1498         address to,
1499         uint256 startTokenId,
1500         uint256 quantity
1501     ) internal virtual {}
1502 }
1503 // File: @openzeppelin/contracts/access/Ownable.sol
1504 
1505 
1506 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1507 
1508 pragma solidity ^0.8.0;
1509 
1510 
1511 /**
1512  * @dev Contract module which provides a basic access control mechanism, where
1513  * there is an account (an owner) that can be granted exclusive access to
1514  * specific functions.
1515  *
1516  * By default, the owner account will be the one that deploys the contract. This
1517  * can later be changed with {transferOwnership}.
1518  *
1519  * This module is used through inheritance. It will make available the modifier
1520  * `onlyOwner`, which can be applied to your functions to restrict their use to
1521  * the owner.
1522  */
1523 abstract contract Ownable is Context {
1524     address private _owner;
1525 
1526     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1527 
1528     /**
1529      * @dev Initializes the contract setting the deployer as the initial owner.
1530      */
1531     constructor() {
1532         _transferOwnership(_msgSender());
1533     }
1534 
1535     /**
1536      * @dev Returns the address of the current owner.
1537      */
1538     function owner() public view virtual returns (address) {
1539         return _owner;
1540     }
1541 
1542     /**
1543      * @dev Throws if called by any account other than the owner.
1544      */
1545     modifier onlyOwner() {
1546         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1547         _;
1548     }
1549 
1550     /**
1551      * @dev Leaves the contract without owner. It will not be possible to call
1552      * `onlyOwner` functions anymore. Can only be called by the current owner.
1553      *
1554      * NOTE: Renouncing ownership will leave the contract without an owner,
1555      * thereby removing any functionality that is only available to the owner.
1556      */
1557     function renounceOwnership() public virtual onlyOwner {
1558         _transferOwnership(address(0));
1559     }
1560 
1561     /**
1562      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1563      * Can only be called by the current owner.
1564      */
1565     function transferOwnership(address newOwner) public virtual onlyOwner {
1566         require(newOwner != address(0), "Ownable: new owner is the zero address");
1567         _transferOwnership(newOwner);
1568     }
1569 
1570     /**
1571      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1572      * Internal function without access restriction.
1573      */
1574     function _transferOwnership(address newOwner) internal virtual {
1575         address oldOwner = _owner;
1576         _owner = newOwner;
1577         emit OwnershipTransferred(oldOwner, newOwner);
1578     }
1579 }
1580 
1581 // File: contracts/cybergoblin.sol
1582 
1583 
1584 pragma solidity ^0.8.9;
1585 
1586 
1587 
1588 
1589 /*
1590    _____  .___        ________                                                                            .___    ________                                             
1591   /  _  \ |   |       \______ \  __ __  ____    ____   ____  ____   ____   ______      _____    ____    __| _/    \______ \____________     ____   ____   ____   ______
1592  /  /_\  \|   |        |    |  \|  |  \/    \  / ___\_/ __ \/  _ \ /    \ /  ___/      \__  \  /    \  / __ |      |    |  \_  __ \__  \   / ___\ /  _ \ /    \ /  ___/
1593 /    |    \   |        |    `   \  |  /   |  \/ /_/  >  ___(  <_> )   |  \\___ \        / __ \|   |  \/ /_/ |      |    `   \  | \// __ \_/ /_/  >  <_> )   |  \\___ \ 
1594 \____|__  /___|       /_______  /____/|___|  /\___  / \___  >____/|___|  /____  >      (____  /___|  /\____ |     /_______  /__|  (____  /\___  / \____/|___|  /____  >
1595         \/                    \/           \//_____/      \/           \/     \/            \/     \/      \/             \/           \//_____/             \/     \/ 
1596                                                                                                                                                                        
1597                                                                                                                                                                        
1598                                                                                                                                                                        
1599                                                                                                                                                                        
1600                                                                                                                                                                        
1601                                                                                                                                                                        
1602                                                          ________                            .__                                                                       
1603                                                         /  _____/  ____   ____   ____   _____|__| ______                                                               
1604                                                        /   \  ____/ __ \ /    \_/ __ \ /  ___/  |/  ___/                                                               
1605                                                        \    \_\  \  ___/|   |  \  ___/ \___ \|  |\___ \                                                                
1606                                                         \______  /\___  >___|  /\___  >____  >__/____  >                                                               
1607                                                                \/     \/     \/     \/     \/        \/                                                             
1608 
1609 */
1610 contract AIDND is ERC721A, Ownable {
1611     using ECDSA for bytes32;
1612     using Strings for uint256;
1613 
1614     address private constant TEAM_ADDRESS = 0x12187110f2bD7d8956A76473F347FeCCfd139988;
1615 
1616     uint256 public constant TOTAL_MAX_SUPPLY = 984;
1617     uint256 public constant MAX_FREE_MINT_PER_WALLET = 1; 
1618     uint256 public constant MAX_PUBLIC_MINT_PER_WALLET = 10;
1619     uint256 public constant TEAM_CLAIM_AMOUNT = 10;
1620     
1621 
1622     bool public publicSaleActive;
1623     bool public freeMintActive;
1624     bool public claimed = false;
1625     uint256 public total_free_mints = 0;
1626     uint256 public freeMintCount;
1627     uint256 public token_price = 0.05 ether;
1628 
1629     mapping(address => uint256) public freeMintClaimed;
1630 
1631     string private _baseTokenURI;
1632 
1633 
1634     constructor(string memory baseURI) ERC721A("AI Dungeons and Dragons Genesis", "AIDND") {
1635         _baseTokenURI = baseURI;
1636     }
1637 
1638     modifier callerIsUser() {
1639         require(tx.origin == msg.sender, "The caller is another contract");
1640         _;
1641     }
1642 
1643     modifier underMaxSupply(uint256 _quantity) {
1644         require(
1645             _totalMinted() + _quantity <= TOTAL_MAX_SUPPLY,
1646             "Purchase would exceed max supply"
1647         );
1648 
1649         _;
1650     }
1651 
1652     modifier validateFreeMintStatus() {
1653         require(freeMintActive, "free claim is not active");
1654         require(freeMintCount + 1 <= total_free_mints, "Purchase would exceed max supply of free mints");
1655         require(freeMintClaimed[msg.sender] == 0, "wallet has already free minted");
1656         
1657         _;
1658     }
1659 
1660     modifier validatePublicStatus(uint256 _quantity) {
1661         require(publicSaleActive, "public sale is not active");
1662         require(msg.value >= token_price * _quantity, "Need to send more ETH.");
1663         require(
1664             _numberMinted(msg.sender) + _quantity - freeMintClaimed[msg.sender] <= MAX_PUBLIC_MINT_PER_WALLET,
1665             "This purchase would exceed maximum allocation for public mints for this wallet"
1666         );
1667 
1668         _;
1669     }
1670 
1671     function freeMint() 
1672         external 
1673         callerIsUser 
1674         validateFreeMintStatus
1675         underMaxSupply(1)
1676     {
1677         freeMintClaimed[msg.sender] = 1;
1678         freeMintCount++;
1679 
1680         _mint(msg.sender, 1, "", false);
1681     }
1682 
1683     function mint(uint256 _quantity)
1684         external
1685         payable
1686         callerIsUser
1687         validatePublicStatus(_quantity)
1688         underMaxSupply(_quantity)
1689     {
1690         _mint(msg.sender, _quantity, "", false);
1691     }
1692 
1693     function _baseURI() internal view virtual override returns (string memory) {
1694         return _baseTokenURI;
1695     }
1696 
1697     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1698         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1699 
1700         string memory baseURI = _baseURI();
1701         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
1702     }
1703 
1704     function numberMinted(address owner) public view returns (uint256) {
1705         return _numberMinted(owner);
1706     }
1707 
1708     function ownerMint(uint256 _numberToMint)
1709         external
1710         onlyOwner
1711         underMaxSupply(_numberToMint)
1712     {
1713         _mint(msg.sender, _numberToMint, "", false);
1714     }
1715 
1716       function teamClaim() external onlyOwner {
1717         require(!claimed, "Team already claimed");
1718         // claim
1719         _safeMint(TEAM_ADDRESS, TEAM_CLAIM_AMOUNT);
1720         claimed = true;
1721   }
1722 
1723     function ownerMintToAddress(address _recipient, uint256 _numberToMint)
1724         external
1725         onlyOwner
1726         underMaxSupply(_numberToMint)
1727     {
1728         _mint(_recipient, _numberToMint, "", false);
1729     }
1730 
1731     function setFreeMintCount(uint256 _count) external onlyOwner {
1732         freeMintCount = _count;
1733     }
1734 
1735     function setTotalFreeMintNum(uint256 _num) external onlyOwner {
1736         total_free_mints = _num;
1737     }
1738 
1739     function setTokenPrice(uint256 newPrice) external onlyOwner {
1740         require(newPrice >= 0, "Token price must be greater than zero");
1741         token_price = newPrice;
1742     }
1743 
1744     function setBaseURI(string calldata baseURI) external onlyOwner {
1745         _baseTokenURI = baseURI;
1746     }
1747 
1748     function withdrawFunds() external onlyOwner {
1749         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1750         require(success, "Transfer failed.");
1751     }
1752 
1753     function withdrawFundsToAddress(address _address, uint256 amount) external onlyOwner {
1754         (bool success, ) =_address.call{value: amount}("");
1755         require(success, "Transfer failed.");
1756     }
1757     
1758     function flipFreeMintActive() external onlyOwner {
1759         freeMintActive = !freeMintActive;
1760     }
1761 
1762     function flipPublicSaleActive() external onlyOwner {
1763         publicSaleActive = !publicSaleActive;
1764     }
1765 
1766 }