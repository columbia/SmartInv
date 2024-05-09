1 /**
2 
3  /$$$$$$$                      /$$                                       /$$           /$$$$$$$$ /$$$$$$$$ /$$   /$$
4 | $$__  $$                    | $$                                      | $$          | $$_____/|__  $$__/| $$  / $$
5 | $$  \ $$  /$$$$$$  /$$$$$$$ | $$   /$$  /$$$$$$  /$$   /$$  /$$$$$$  /$$$$$$        | $$         | $$   |  $$/ $$/
6 | $$$$$$$  |____  $$| $$__  $$| $$  /$$/ /$$__  $$| $$  | $$ /$$__  $$|_  $$_/        | $$$$$      | $$    \  $$$$/ 
7 | $$__  $$  /$$$$$$$| $$  \ $$| $$$$$$/ | $$  \__/| $$  | $$| $$  \ $$  | $$          | $$__/      | $$     >$$  $$ 
8 | $$  \ $$ /$$__  $$| $$  | $$| $$_  $$ | $$      | $$  | $$| $$  | $$  | $$ /$$      | $$         | $$    /$$/\  $$
9 | $$$$$$$/|  $$$$$$$| $$  | $$| $$ \  $$| $$      |  $$$$$$/| $$$$$$$/  |  $$$$/      | $$         | $$   | $$  \ $$
10 |_______/  \_______/|__/  |__/|__/  \__/|__/       \______/ | $$____/    \___/        |__/         |__/   |__/  |__/
11                                                             | $$                                                    
12                                                             | $$                                                    
13                                                             |__/                                                    
14  /$$     /$$                  /$$         /$$            /$$$$$$  /$$           /$$                                 
15 |  $$   /$$/                 | $$        | $$           /$$__  $$| $$          | $$                                 
16  \  $$ /$$//$$$$$$   /$$$$$$$| $$$$$$$  /$$$$$$        | $$  \__/| $$ /$$   /$$| $$$$$$$                            
17   \  $$$$/|____  $$ /$$_____/| $$__  $$|_  $$_/        | $$      | $$| $$  | $$| $$__  $$                           
18    \  $$/  /$$$$$$$| $$      | $$  \ $$  | $$          | $$      | $$| $$  | $$| $$  \ $$                           
19     | $$  /$$__  $$| $$      | $$  | $$  | $$ /$$      | $$    $$| $$| $$  | $$| $$  | $$                           
20     | $$ |  $$$$$$$|  $$$$$$$| $$  | $$  |  $$$$/      |  $$$$$$/| $$|  $$$$$$/| $$$$$$$/                           
21     |__/  \_______/ \_______/|__/  |__/   \___/         \______/ |__/ \______/ |_______/                            
22                                                                                                                     
23                                                                                                                     
24                                                                                                                     
25 
26  */
27 // SPDX-License-Identifier: MIT
28 //Developer Info:
29 
30 
31 
32 // File: @openzeppelin/contracts/utils/Strings.sol
33 
34 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev String operations.
40  */
41 library Strings {
42     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
43 
44     /**
45      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
46      */
47     function toString(uint256 value) internal pure returns (string memory) {
48         // Inspired by OraclizeAPI's implementation - MIT licence
49         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
50 
51         if (value == 0) {
52             return "0";
53         }
54         uint256 temp = value;
55         uint256 digits;
56         while (temp != 0) {
57             digits++;
58             temp /= 10;
59         }
60         bytes memory buffer = new bytes(digits);
61         while (value != 0) {
62             digits -= 1;
63             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
64             value /= 10;
65         }
66         return string(buffer);
67     }
68 
69     /**
70      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
71      */
72     function toHexString(uint256 value) internal pure returns (string memory) {
73         if (value == 0) {
74             return "0x00";
75         }
76         uint256 temp = value;
77         uint256 length = 0;
78         while (temp != 0) {
79             length++;
80             temp >>= 8;
81         }
82         return toHexString(value, length);
83     }
84 
85     /**
86      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
87      */
88     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
89         bytes memory buffer = new bytes(2 * length + 2);
90         buffer[0] = "0";
91         buffer[1] = "x";
92         for (uint256 i = 2 * length + 1; i > 1; --i) {
93             buffer[i] = _HEX_SYMBOLS[value & 0xf];
94             value >>= 4;
95         }
96         require(value == 0, "Strings: hex length insufficient");
97         return string(buffer);
98     }
99 }
100 
101 // File: @openzeppelin/contracts/utils/Context.sol
102 
103 
104 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
105 
106 pragma solidity ^0.8.0;
107 
108 /**
109  * @dev Provides information about the current execution context, including the
110  * sender of the transaction and its data. While these are generally available
111  * via msg.sender and msg.data, they should not be accessed in such a direct
112  * manner, since when dealing with meta-transactions the account sending and
113  * paying for execution may not be the actual sender (as far as an application
114  * is concerned).
115  *
116  * This contract is only required for intermediate, library-like contracts.
117  */
118 abstract contract Context {
119     function _msgSender() internal view virtual returns (address) {
120         return msg.sender;
121     }
122 
123     function _msgData() internal view virtual returns (bytes calldata) {
124         return msg.data;
125     }
126 }
127 
128 // File: @openzeppelin/contracts/utils/Address.sol
129 
130 
131 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
132 
133 pragma solidity ^0.8.1;
134 
135 /**
136  * @dev Collection of functions related to the address type
137  */
138 library Address {
139     /**
140      * @dev Returns true if `account` is a contract.
141      *
142      * [IMPORTANT]
143      * ====
144      * It is unsafe to assume that an address for which this function returns
145      * false is an externally-owned account (EOA) and not a contract.
146      *
147      * Among others, `isContract` will return false for the following
148      * types of addresses:
149      *
150      *  - an externally-owned account
151      *  - a contract in construction
152      *  - an address where a contract will be created
153      *  - an address where a contract lived, but was destroyed
154      * ====
155      *
156      * [IMPORTANT]
157      * ====
158      * You shouldn't rely on `isContract` to protect against flash loan attacks!
159      *
160      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
161      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
162      * constructor.
163      * ====
164      */
165     function isContract(address account) internal view returns (bool) {
166         // This method relies on extcodesize/address.code.length, which returns 0
167         // for contracts in construction, since the code is only stored at the end
168         // of the constructor execution.
169 
170         return account.code.length > 0;
171     }
172 
173     /**
174      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
175      * `recipient`, forwarding all available gas and reverting on errors.
176      *
177      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
178      * of certain opcodes, possibly making contracts go over the 2300 gas limit
179      * imposed by `transfer`, making them unable to receive funds via
180      * `transfer`. {sendValue} removes this limitation.
181      *
182      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
183      *
184      * IMPORTANT: because control is transferred to `recipient`, care must be
185      * taken to not create reentrancy vulnerabilities. Consider using
186      * {ReentrancyGuard} or the
187      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
188      */
189     function sendValue(address payable recipient, uint256 amount) internal {
190         require(address(this).balance >= amount, "Address: insufficient balance");
191 
192         (bool success, ) = recipient.call{value: amount}("");
193         require(success, "Address: unable to send value, recipient may have reverted");
194     }
195 
196     /**
197      * @dev Performs a Solidity function call using a low level `call`. A
198      * plain `call` is an unsafe replacement for a function call: use this
199      * function instead.
200      *
201      * If `target` reverts with a revert reason, it is bubbled up by this
202      * function (like regular Solidity function calls).
203      *
204      * Returns the raw returned data. To convert to the expected return value,
205      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
206      *
207      * Requirements:
208      *
209      * - `target` must be a contract.
210      * - calling `target` with `data` must not revert.
211      *
212      * _Available since v3.1._
213      */
214     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
215         return functionCall(target, data, "Address: low-level call failed");
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
220      * `errorMessage` as a fallback revert reason when `target` reverts.
221      *
222      * _Available since v3.1._
223      */
224     function functionCall(
225         address target,
226         bytes memory data,
227         string memory errorMessage
228     ) internal returns (bytes memory) {
229         return functionCallWithValue(target, data, 0, errorMessage);
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
234      * but also transferring `value` wei to `target`.
235      *
236      * Requirements:
237      *
238      * - the calling contract must have an ETH balance of at least `value`.
239      * - the called Solidity function must be `payable`.
240      *
241      * _Available since v3.1._
242      */
243     function functionCallWithValue(
244         address target,
245         bytes memory data,
246         uint256 value
247     ) internal returns (bytes memory) {
248         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
253      * with `errorMessage` as a fallback revert reason when `target` reverts.
254      *
255      * _Available since v3.1._
256      */
257     function functionCallWithValue(
258         address target,
259         bytes memory data,
260         uint256 value,
261         string memory errorMessage
262     ) internal returns (bytes memory) {
263         require(address(this).balance >= value, "Address: insufficient balance for call");
264         require(isContract(target), "Address: call to non-contract");
265 
266         (bool success, bytes memory returndata) = target.call{value: value}(data);
267         return verifyCallResult(success, returndata, errorMessage);
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
272      * but performing a static call.
273      *
274      * _Available since v3.3._
275      */
276     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
277         return functionStaticCall(target, data, "Address: low-level static call failed");
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
282      * but performing a static call.
283      *
284      * _Available since v3.3._
285      */
286     function functionStaticCall(
287         address target,
288         bytes memory data,
289         string memory errorMessage
290     ) internal view returns (bytes memory) {
291         require(isContract(target), "Address: static call to non-contract");
292 
293         (bool success, bytes memory returndata) = target.staticcall(data);
294         return verifyCallResult(success, returndata, errorMessage);
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
299      * but performing a delegate call.
300      *
301      * _Available since v3.4._
302      */
303     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
304         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
309      * but performing a delegate call.
310      *
311      * _Available since v3.4._
312      */
313     function functionDelegateCall(
314         address target,
315         bytes memory data,
316         string memory errorMessage
317     ) internal returns (bytes memory) {
318         require(isContract(target), "Address: delegate call to non-contract");
319 
320         (bool success, bytes memory returndata) = target.delegatecall(data);
321         return verifyCallResult(success, returndata, errorMessage);
322     }
323 
324     /**
325      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
326      * revert reason using the provided one.
327      *
328      * _Available since v4.3._
329      */
330     function verifyCallResult(
331         bool success,
332         bytes memory returndata,
333         string memory errorMessage
334     ) internal pure returns (bytes memory) {
335         if (success) {
336             return returndata;
337         } else {
338             // Look for revert reason and bubble it up if present
339             if (returndata.length > 0) {
340                 // The easiest way to bubble the revert reason is using memory via assembly
341 
342                 assembly {
343                     let returndata_size := mload(returndata)
344                     revert(add(32, returndata), returndata_size)
345                 }
346             } else {
347                 revert(errorMessage);
348             }
349         }
350     }
351 }
352 
353 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
354 
355 
356 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
357 
358 pragma solidity ^0.8.0;
359 
360 /**
361  * @title ERC721 token receiver interface
362  * @dev Interface for any contract that wants to support safeTransfers
363  * from ERC721 asset contracts.
364  */
365 interface IERC721Receiver {
366     /**
367      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
368      * by `operator` from `from`, this function is called.
369      *
370      * It must return its Solidity selector to confirm the token transfer.
371      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
372      *
373      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
374      */
375     function onERC721Received(
376         address operator,
377         address from,
378         uint256 tokenId,
379         bytes calldata data
380     ) external returns (bytes4);
381 }
382 
383 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
384 
385 
386 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
387 
388 pragma solidity ^0.8.0;
389 
390 /**
391  * @dev Interface of the ERC165 standard, as defined in the
392  * https://eips.ethereum.org/EIPS/eip-165[EIP].
393  *
394  * Implementers can declare support of contract interfaces, which can then be
395  * queried by others ({ERC165Checker}).
396  *
397  * For an implementation, see {ERC165}.
398  */
399 interface IERC165 {
400     /**
401      * @dev Returns true if this contract implements the interface defined by
402      * `interfaceId`. See the corresponding
403      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
404      * to learn more about how these ids are created.
405      *
406      * This function call must use less than 30 000 gas.
407      */
408     function supportsInterface(bytes4 interfaceId) external view returns (bool);
409 }
410 
411 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
412 
413 
414 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
415 
416 pragma solidity ^0.8.0;
417 
418 
419 /**
420  * @dev Implementation of the {IERC165} interface.
421  *
422  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
423  * for the additional interface id that will be supported. For example:
424  *
425  * ```solidity
426  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
427  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
428  * }
429  * ```
430  *
431  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
432  */
433 abstract contract ERC165 is IERC165 {
434     /**
435      * @dev See {IERC165-supportsInterface}.
436      */
437     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
438         return interfaceId == type(IERC165).interfaceId;
439     }
440 }
441 
442 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
443 
444 
445 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
446 
447 pragma solidity ^0.8.0;
448 
449 
450 /**
451  * @dev Required interface of an ERC721 compliant contract.
452  */
453 interface IERC721 is IERC165 {
454     /**
455      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
456      */
457     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
458 
459     /**
460      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
461      */
462     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
463 
464     /**
465      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
466      */
467     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
468 
469     /**
470      * @dev Returns the number of tokens in ``owner``'s account.
471      */
472     function balanceOf(address owner) external view returns (uint256 balance);
473 
474     /**
475      * @dev Returns the owner of the `tokenId` token.
476      *
477      * Requirements:
478      *
479      * - `tokenId` must exist.
480      */
481     function ownerOf(uint256 tokenId) external view returns (address owner);
482 
483     /**
484      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
485      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
486      *
487      * Requirements:
488      *
489      * - `from` cannot be the zero address.
490      * - `to` cannot be the zero address.
491      * - `tokenId` token must exist and be owned by `from`.
492      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
493      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
494      *
495      * Emits a {Transfer} event.
496      */
497     function safeTransferFrom(
498         address from,
499         address to,
500         uint256 tokenId
501     ) external;
502 
503     /**
504      * @dev Transfers `tokenId` token from `from` to `to`.
505      *
506      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
507      *
508      * Requirements:
509      *
510      * - `from` cannot be the zero address.
511      * - `to` cannot be the zero address.
512      * - `tokenId` token must be owned by `from`.
513      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
514      *
515      * Emits a {Transfer} event.
516      */
517     function transferFrom(
518         address from,
519         address to,
520         uint256 tokenId
521     ) external;
522 
523     /**
524      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
525      * The approval is cleared when the token is transferred.
526      *
527      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
528      *
529      * Requirements:
530      *
531      * - The caller must own the token or be an approved operator.
532      * - `tokenId` must exist.
533      *
534      * Emits an {Approval} event.
535      */
536     function approve(address to, uint256 tokenId) external;
537 
538     /**
539      * @dev Returns the account approved for `tokenId` token.
540      *
541      * Requirements:
542      *
543      * - `tokenId` must exist.
544      */
545     function getApproved(uint256 tokenId) external view returns (address operator);
546 
547     /**
548      * @dev Approve or remove `operator` as an operator for the caller.
549      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
550      *
551      * Requirements:
552      *
553      * - The `operator` cannot be the caller.
554      *
555      * Emits an {ApprovalForAll} event.
556      */
557     function setApprovalForAll(address operator, bool _approved) external;
558 
559     /**
560      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
561      *
562      * See {setApprovalForAll}
563      */
564     function isApprovedForAll(address owner, address operator) external view returns (bool);
565 
566     /**
567      * @dev Safely transfers `tokenId` token from `from` to `to`.
568      *
569      * Requirements:
570      *
571      * - `from` cannot be the zero address.
572      * - `to` cannot be the zero address.
573      * - `tokenId` token must exist and be owned by `from`.
574      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
575      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
576      *
577      * Emits a {Transfer} event.
578      */
579     function safeTransferFrom(
580         address from,
581         address to,
582         uint256 tokenId,
583         bytes calldata data
584     ) external;
585 }
586 
587 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
588 
589 
590 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
591 
592 pragma solidity ^0.8.0;
593 
594 
595 /**
596  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
597  * @dev See https://eips.ethereum.org/EIPS/eip-721
598  */
599 interface IERC721Metadata is IERC721 {
600     /**
601      * @dev Returns the token collection name.
602      */
603     function name() external view returns (string memory);
604 
605     /**
606      * @dev Returns the token collection symbol.
607      */
608     function symbol() external view returns (string memory);
609 
610     /**
611      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
612      */
613     function tokenURI(uint256 tokenId) external view returns (string memory);
614 }
615 
616 // File: contracts/new.sol
617 
618 
619 
620 
621 pragma solidity ^0.8.4;
622 
623 
624 
625 
626 
627 
628 
629 
630 error ApprovalCallerNotOwnerNorApproved();
631 error ApprovalQueryForNonexistentToken();
632 error ApproveToCaller();
633 error ApprovalToCurrentOwner();
634 error BalanceQueryForZeroAddress();
635 error MintToZeroAddress();
636 error MintZeroQuantity();
637 error OwnerQueryForNonexistentToken();
638 error TransferCallerNotOwnerNorApproved();
639 error TransferFromIncorrectOwner();
640 error TransferToNonERC721ReceiverImplementer();
641 error TransferToZeroAddress();
642 error URIQueryForNonexistentToken();
643 
644 /**
645  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
646  * the Metadata extension. Built to optimize for lower gas during batch mints.
647  *
648  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
649  *
650  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
651  *
652  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
653  */
654 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
655     using Address for address;
656     using Strings for uint256;
657 
658     // Compiler will pack this into a single 256bit word.
659     struct TokenOwnership {
660         // The address of the owner.
661         address addr;
662         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
663         uint64 startTimestamp;
664         // Whether the token has been burned.
665         bool burned;
666     }
667 
668     // Compiler will pack this into a single 256bit word.
669     struct AddressData {
670         // Realistically, 2**64-1 is more than enough.
671         uint64 balance;
672         // Keeps track of mint count with minimal overhead for tokenomics.
673         uint64 numberMinted;
674         // Keeps track of burn count with minimal overhead for tokenomics.
675         uint64 numberBurned;
676         // For miscellaneous variable(s) pertaining to the address
677         // (e.g. number of whitelist mint slots used).
678         // If there are multiple variables, please pack them into a uint64.
679         uint64 aux;
680     }
681 
682     // The tokenId of the next token to be minted.
683     uint256 internal _currentIndex;
684 
685     // The number of tokens burned.
686     uint256 internal _burnCounter;
687 
688     // Token name
689     string private _name;
690 
691     // Token symbol
692     string private _symbol;
693 
694     // Mapping from token ID to ownership details
695     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
696     mapping(uint256 => TokenOwnership) internal _ownerships;
697 
698     // Mapping owner address to address data
699     mapping(address => AddressData) private _addressData;
700 
701     // Mapping from token ID to approved address
702     mapping(uint256 => address) private _tokenApprovals;
703 
704     // Mapping from owner to operator approvals
705     mapping(address => mapping(address => bool)) private _operatorApprovals;
706 
707     constructor(string memory name_, string memory symbol_) {
708         _name = name_;
709         _symbol = symbol_;
710         _currentIndex = _startTokenId();
711     }
712 
713     /**
714      * To change the starting tokenId, please override this function.
715      */
716     function _startTokenId() internal view virtual returns (uint256) {
717         return 0;
718     }
719 
720     /**
721      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
722      */
723     function totalSupply() public view returns (uint256) {
724         // Counter underflow is impossible as _burnCounter cannot be incremented
725         // more than _currentIndex - _startTokenId() times
726         unchecked {
727             return _currentIndex - _burnCounter - _startTokenId();
728         }
729     }
730 
731     /**
732      * Returns the total amount of tokens minted in the contract.
733      */
734     function _totalMinted() internal view returns (uint256) {
735         // Counter underflow is impossible as _currentIndex does not decrement,
736         // and it is initialized to _startTokenId()
737         unchecked {
738             return _currentIndex - _startTokenId();
739         }
740     }
741 
742     /**
743      * @dev See {IERC165-supportsInterface}.
744      */
745     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
746         return
747             interfaceId == type(IERC721).interfaceId ||
748             interfaceId == type(IERC721Metadata).interfaceId ||
749             super.supportsInterface(interfaceId);
750     }
751 
752     /**
753      * @dev See {IERC721-balanceOf}.
754      */
755     function balanceOf(address owner) public view override returns (uint256) {
756         if (owner == address(0)) revert BalanceQueryForZeroAddress();
757         return uint256(_addressData[owner].balance);
758     }
759 
760     /**
761      * Returns the number of tokens minted by `owner`.
762      */
763     function _numberMinted(address owner) internal view returns (uint256) {
764         return uint256(_addressData[owner].numberMinted);
765     }
766 
767     /**
768      * Returns the number of tokens burned by or on behalf of `owner`.
769      */
770     function _numberBurned(address owner) internal view returns (uint256) {
771         return uint256(_addressData[owner].numberBurned);
772     }
773 
774     /**
775      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
776      */
777     function _getAux(address owner) internal view returns (uint64) {
778         return _addressData[owner].aux;
779     }
780 
781     /**
782      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
783      * If there are multiple variables, please pack them into a uint64.
784      */
785     function _setAux(address owner, uint64 aux) internal {
786         _addressData[owner].aux = aux;
787     }
788 
789     /**
790      * Gas spent here starts off proportional to the maximum mint batch size.
791      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
792      */
793     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
794         uint256 curr = tokenId;
795 
796         unchecked {
797             if (_startTokenId() <= curr && curr < _currentIndex) {
798                 TokenOwnership memory ownership = _ownerships[curr];
799                 if (!ownership.burned) {
800                     if (ownership.addr != address(0)) {
801                         return ownership;
802                     }
803                     // Invariant:
804                     // There will always be an ownership that has an address and is not burned
805                     // before an ownership that does not have an address and is not burned.
806                     // Hence, curr will not underflow.
807                     while (true) {
808                         curr--;
809                         ownership = _ownerships[curr];
810                         if (ownership.addr != address(0)) {
811                             return ownership;
812                         }
813                     }
814                 }
815             }
816         }
817         revert OwnerQueryForNonexistentToken();
818     }
819 
820     /**
821      * @dev See {IERC721-ownerOf}.
822      */
823     function ownerOf(uint256 tokenId) public view override returns (address) {
824         return _ownershipOf(tokenId).addr;
825     }
826 
827     /**
828      * @dev See {IERC721Metadata-name}.
829      */
830     function name() public view virtual override returns (string memory) {
831         return _name;
832     }
833 
834     /**
835      * @dev See {IERC721Metadata-symbol}.
836      */
837     function symbol() public view virtual override returns (string memory) {
838         return _symbol;
839     }
840 
841     /**
842      * @dev See {IERC721Metadata-tokenURI}.
843      */
844     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
845         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
846 
847         string memory baseURI = _baseURI();
848         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
849     }
850 
851     /**
852      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
853      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
854      * by default, can be overriden in child contracts.
855      */
856     function _baseURI() internal view virtual returns (string memory) {
857         return '';
858     }
859 
860     /**
861      * @dev See {IERC721-approve}.
862      */
863     function approve(address to, uint256 tokenId) public override {
864         address owner = ERC721A.ownerOf(tokenId);
865         if (to == owner) revert ApprovalToCurrentOwner();
866 
867         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
868             revert ApprovalCallerNotOwnerNorApproved();
869         }
870 
871         _approve(to, tokenId, owner);
872     }
873 
874     /**
875      * @dev See {IERC721-getApproved}.
876      */
877     function getApproved(uint256 tokenId) public view override returns (address) {
878         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
879 
880         return _tokenApprovals[tokenId];
881     }
882 
883     /**
884      * @dev See {IERC721-setApprovalForAll}.
885      */
886     function setApprovalForAll(address operator, bool approved) public virtual override {
887         if (operator == _msgSender()) revert ApproveToCaller();
888 
889         _operatorApprovals[_msgSender()][operator] = approved;
890         emit ApprovalForAll(_msgSender(), operator, approved);
891     }
892 
893     /**
894      * @dev See {IERC721-isApprovedForAll}.
895      */
896     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
897         return _operatorApprovals[owner][operator];
898     }
899 
900     /**
901      * @dev See {IERC721-transferFrom}.
902      */
903     function transferFrom(
904         address from,
905         address to,
906         uint256 tokenId
907     ) public virtual override {
908         _transfer(from, to, tokenId);
909     }
910 
911     /**
912      * @dev See {IERC721-safeTransferFrom}.
913      */
914     function safeTransferFrom(
915         address from,
916         address to,
917         uint256 tokenId
918     ) public virtual override {
919         safeTransferFrom(from, to, tokenId, '');
920     }
921 
922     /**
923      * @dev See {IERC721-safeTransferFrom}.
924      */
925     function safeTransferFrom(
926         address from,
927         address to,
928         uint256 tokenId,
929         bytes memory _data
930     ) public virtual override {
931         _transfer(from, to, tokenId);
932         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
933             revert TransferToNonERC721ReceiverImplementer();
934         }
935     }
936 
937     /**
938      * @dev Returns whether `tokenId` exists.
939      *
940      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
941      *
942      * Tokens start existing when they are minted (`_mint`),
943      */
944     function _exists(uint256 tokenId) internal view returns (bool) {
945         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
946             !_ownerships[tokenId].burned;
947     }
948 
949     function _safeMint(address to, uint256 quantity) internal {
950         _safeMint(to, quantity, '');
951     }
952 
953     /**
954      * @dev Safely mints `quantity` tokens and transfers them to `to`.
955      *
956      * Requirements:
957      *
958      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
959      * - `quantity` must be greater than 0.
960      *
961      * Emits a {Transfer} event.
962      */
963     function _safeMint(
964         address to,
965         uint256 quantity,
966         bytes memory _data
967     ) internal {
968         _mint(to, quantity, _data, true);
969     }
970 
971     /**
972      * @dev Mints `quantity` tokens and transfers them to `to`.
973      *
974      * Requirements:
975      *
976      * - `to` cannot be the zero address.
977      * - `quantity` must be greater than 0.
978      *
979      * Emits a {Transfer} event.
980      */
981     function _mint(
982         address to,
983         uint256 quantity,
984         bytes memory _data,
985         bool safe
986     ) internal {
987         uint256 startTokenId = _currentIndex;
988         if (to == address(0)) revert MintToZeroAddress();
989         if (quantity == 0) revert MintZeroQuantity();
990 
991         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
992 
993         // Overflows are incredibly unrealistic.
994         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
995         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
996         unchecked {
997             _addressData[to].balance += uint64(quantity);
998             _addressData[to].numberMinted += uint64(quantity);
999 
1000             _ownerships[startTokenId].addr = to;
1001             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1002 
1003             uint256 updatedIndex = startTokenId;
1004             uint256 end = updatedIndex + quantity;
1005 
1006             if (safe && to.isContract()) {
1007                 do {
1008                     emit Transfer(address(0), to, updatedIndex);
1009                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1010                         revert TransferToNonERC721ReceiverImplementer();
1011                     }
1012                 } while (updatedIndex != end);
1013                 // Reentrancy protection
1014                 if (_currentIndex != startTokenId) revert();
1015             } else {
1016                 do {
1017                     emit Transfer(address(0), to, updatedIndex++);
1018                 } while (updatedIndex != end);
1019             }
1020             _currentIndex = updatedIndex;
1021         }
1022         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1023     }
1024 
1025     /**
1026      * @dev Transfers `tokenId` from `from` to `to`.
1027      *
1028      * Requirements:
1029      *
1030      * - `to` cannot be the zero address.
1031      * - `tokenId` token must be owned by `from`.
1032      *
1033      * Emits a {Transfer} event.
1034      */
1035     function _transfer(
1036         address from,
1037         address to,
1038         uint256 tokenId
1039     ) private {
1040         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1041 
1042         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1043 
1044         bool isApprovedOrOwner = (_msgSender() == from ||
1045             isApprovedForAll(from, _msgSender()) ||
1046             getApproved(tokenId) == _msgSender());
1047 
1048         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1049         if (to == address(0)) revert TransferToZeroAddress();
1050 
1051         _beforeTokenTransfers(from, to, tokenId, 1);
1052 
1053         // Clear approvals from the previous owner
1054         _approve(address(0), tokenId, from);
1055 
1056         // Underflow of the sender's balance is impossible because we check for
1057         // ownership above and the recipient's balance can't realistically overflow.
1058         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1059         unchecked {
1060             _addressData[from].balance -= 1;
1061             _addressData[to].balance += 1;
1062 
1063             TokenOwnership storage currSlot = _ownerships[tokenId];
1064             currSlot.addr = to;
1065             currSlot.startTimestamp = uint64(block.timestamp);
1066 
1067             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1068             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1069             uint256 nextTokenId = tokenId + 1;
1070             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1071             if (nextSlot.addr == address(0)) {
1072                 // This will suffice for checking _exists(nextTokenId),
1073                 // as a burned slot cannot contain the zero address.
1074                 if (nextTokenId != _currentIndex) {
1075                     nextSlot.addr = from;
1076                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1077                 }
1078             }
1079         }
1080 
1081         emit Transfer(from, to, tokenId);
1082         _afterTokenTransfers(from, to, tokenId, 1);
1083     }
1084 
1085     /**
1086      * @dev This is equivalent to _burn(tokenId, false)
1087      */
1088     function _burn(uint256 tokenId) internal virtual {
1089         _burn(tokenId, false);
1090     }
1091 
1092     /**
1093      * @dev Destroys `tokenId`.
1094      * The approval is cleared when the token is burned.
1095      *
1096      * Requirements:
1097      *
1098      * - `tokenId` must exist.
1099      *
1100      * Emits a {Transfer} event.
1101      */
1102     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1103         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1104 
1105         address from = prevOwnership.addr;
1106 
1107         if (approvalCheck) {
1108             bool isApprovedOrOwner = (_msgSender() == from ||
1109                 isApprovedForAll(from, _msgSender()) ||
1110                 getApproved(tokenId) == _msgSender());
1111 
1112             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1113         }
1114 
1115         _beforeTokenTransfers(from, address(0), tokenId, 1);
1116 
1117         // Clear approvals from the previous owner
1118         _approve(address(0), tokenId, from);
1119 
1120         // Underflow of the sender's balance is impossible because we check for
1121         // ownership above and the recipient's balance can't realistically overflow.
1122         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1123         unchecked {
1124             AddressData storage addressData = _addressData[from];
1125             addressData.balance -= 1;
1126             addressData.numberBurned += 1;
1127 
1128             // Keep track of who burned the token, and the timestamp of burning.
1129             TokenOwnership storage currSlot = _ownerships[tokenId];
1130             currSlot.addr = from;
1131             currSlot.startTimestamp = uint64(block.timestamp);
1132             currSlot.burned = true;
1133 
1134             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1135             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1136             uint256 nextTokenId = tokenId + 1;
1137             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1138             if (nextSlot.addr == address(0)) {
1139                 // This will suffice for checking _exists(nextTokenId),
1140                 // as a burned slot cannot contain the zero address.
1141                 if (nextTokenId != _currentIndex) {
1142                     nextSlot.addr = from;
1143                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1144                 }
1145             }
1146         }
1147 
1148         emit Transfer(from, address(0), tokenId);
1149         _afterTokenTransfers(from, address(0), tokenId, 1);
1150 
1151         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1152         unchecked {
1153             _burnCounter++;
1154         }
1155     }
1156 
1157     /**
1158      * @dev Approve `to` to operate on `tokenId`
1159      *
1160      * Emits a {Approval} event.
1161      */
1162     function _approve(
1163         address to,
1164         uint256 tokenId,
1165         address owner
1166     ) private {
1167         _tokenApprovals[tokenId] = to;
1168         emit Approval(owner, to, tokenId);
1169     }
1170 
1171     /**
1172      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1173      *
1174      * @param from address representing the previous owner of the given token ID
1175      * @param to target address that will receive the tokens
1176      * @param tokenId uint256 ID of the token to be transferred
1177      * @param _data bytes optional data to send along with the call
1178      * @return bool whether the call correctly returned the expected magic value
1179      */
1180     function _checkContractOnERC721Received(
1181         address from,
1182         address to,
1183         uint256 tokenId,
1184         bytes memory _data
1185     ) private returns (bool) {
1186         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1187             return retval == IERC721Receiver(to).onERC721Received.selector;
1188         } catch (bytes memory reason) {
1189             if (reason.length == 0) {
1190                 revert TransferToNonERC721ReceiverImplementer();
1191             } else {
1192                 assembly {
1193                     revert(add(32, reason), mload(reason))
1194                 }
1195             }
1196         }
1197     }
1198 
1199     /**
1200      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1201      * And also called before burning one token.
1202      *
1203      * startTokenId - the first token id to be transferred
1204      * quantity - the amount to be transferred
1205      *
1206      * Calling conditions:
1207      *
1208      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1209      * transferred to `to`.
1210      * - When `from` is zero, `tokenId` will be minted for `to`.
1211      * - When `to` is zero, `tokenId` will be burned by `from`.
1212      * - `from` and `to` are never both zero.
1213      */
1214     function _beforeTokenTransfers(
1215         address from,
1216         address to,
1217         uint256 startTokenId,
1218         uint256 quantity
1219     ) internal virtual {}
1220 
1221     /**
1222      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1223      * minting.
1224      * And also called after one token has been burned.
1225      *
1226      * startTokenId - the first token id to be transferred
1227      * quantity - the amount to be transferred
1228      *
1229      * Calling conditions:
1230      *
1231      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1232      * transferred to `to`.
1233      * - When `from` is zero, `tokenId` has been minted for `to`.
1234      * - When `to` is zero, `tokenId` has been burned by `from`.
1235      * - `from` and `to` are never both zero.
1236      */
1237     function _afterTokenTransfers(
1238         address from,
1239         address to,
1240         uint256 startTokenId,
1241         uint256 quantity
1242     ) internal virtual {}
1243 }
1244 
1245 abstract contract Ownable is Context {
1246     address private _owner;
1247 
1248     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1249 
1250     /**
1251      * @dev Initializes the contract setting the deployer as the initial owner.
1252      */
1253     constructor() {
1254         _transferOwnership(_msgSender());
1255     }
1256 
1257     /**
1258      * @dev Returns the address of the current owner.
1259      */
1260     function owner() public view virtual returns (address) {
1261         return _owner;
1262     }
1263 
1264     /**
1265      * @dev Throws if called by any account other than the owner.
1266      */
1267     modifier onlyOwner() {
1268         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1269         _;
1270     }
1271 
1272     /**
1273      * @dev Leaves the contract without owner. It will not be possible to call
1274      * `onlyOwner` functions anymore. Can only be called by the current owner.
1275      *
1276      * NOTE: Renouncing ownership will leave the contract without an owner,
1277      * thereby removing any functionality that is only available to the owner.
1278      */
1279     function renounceOwnership() public virtual onlyOwner {
1280         _transferOwnership(address(0));
1281     }
1282 
1283     /**
1284      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1285      * Can only be called by the current owner.
1286      */
1287     function transferOwnership(address newOwner) public virtual onlyOwner {
1288         require(newOwner != address(0), "Ownable: new owner is the zero address");
1289         _transferOwnership(newOwner);
1290     }
1291 
1292     /**
1293      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1294      * Internal function without access restriction.
1295      */
1296     function _transferOwnership(address newOwner) internal virtual {
1297         address oldOwner = _owner;
1298         _owner = newOwner;
1299         emit OwnershipTransferred(oldOwner, newOwner);
1300     }
1301 }
1302     pragma solidity ^0.8.7;
1303     
1304     contract BankruptFTXYachtClub is ERC721A, Ownable {
1305     using Strings for uint256;
1306 
1307 
1308   string private uriPrefix ;
1309   string private uriSuffix = ".json";
1310   string public hiddenURL;
1311 
1312   
1313   
1314 
1315   uint256 public cost = 0.0025 ether;
1316  
1317   
1318 
1319   uint16 public maxSupply = 6969;
1320   uint8 public maxMintAmountPerTx = 21;
1321     uint8 public maxFreeMintAmountPerWallet = 1;
1322                                                              
1323  
1324   bool public paused = true;
1325   bool public reveal =false;
1326 
1327    mapping (address => uint8) public NFTPerPublicAddress;
1328 
1329  
1330   
1331   
1332  
1333   
1334 
1335   constructor() ERC721A("Bankrupt FTX Yacht Club", "BFTX") {
1336   }
1337 
1338 
1339   
1340  
1341   function mint(uint8 _mintAmount) external payable  {
1342      uint16 totalSupply = uint16(totalSupply());
1343      uint8 nft = NFTPerPublicAddress[msg.sender];
1344     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1345     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1346 
1347     require(!paused, "The contract is paused!");
1348     
1349       if(nft >= maxFreeMintAmountPerWallet)
1350     {
1351     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1352     }
1353     else {
1354          uint8 costAmount = _mintAmount + nft;
1355         if(costAmount > maxFreeMintAmountPerWallet)
1356        {
1357         costAmount = costAmount - maxFreeMintAmountPerWallet;
1358         require(msg.value >= cost * costAmount, "Insufficient funds!");
1359        }
1360        
1361          
1362     }
1363     
1364 
1365 
1366     _safeMint(msg.sender , _mintAmount);
1367 
1368     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1369      
1370      delete totalSupply;
1371      delete _mintAmount;
1372   }
1373   
1374   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1375      uint16 totalSupply = uint16(totalSupply());
1376     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1377      _safeMint(_receiver , _mintAmount);
1378      delete _mintAmount;
1379      delete _receiver;
1380      delete totalSupply;
1381   }
1382 
1383   function  Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1384      uint16 totalSupply = uint16(totalSupply());
1385      uint totalAmount =   _amountPerAddress * addresses.length;
1386     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
1387      for (uint256 i = 0; i < addresses.length; i++) {
1388             _safeMint(addresses[i], _amountPerAddress);
1389         }
1390 
1391      delete _amountPerAddress;
1392      delete totalSupply;
1393   }
1394 
1395  
1396 
1397   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1398       maxSupply = _maxSupply;
1399   }
1400 
1401 
1402 
1403    
1404   function tokenURI(uint256 _tokenId)
1405     public
1406     view
1407     virtual
1408     override
1409     returns (string memory)
1410   {
1411     require(
1412       _exists(_tokenId),
1413       "ERC721Metadata: URI query for nonexistent token"
1414     );
1415     
1416   
1417 if ( reveal == false)
1418 {
1419     return hiddenURL;
1420 }
1421     
1422 
1423     string memory currentBaseURI = _baseURI();
1424     return bytes(currentBaseURI).length > 0
1425         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1426         : "";
1427   }
1428  
1429  
1430 
1431 
1432  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1433     maxFreeMintAmountPerWallet = _limit;
1434    delete _limit;
1435 
1436 }
1437 
1438     
1439   
1440 
1441   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1442     uriPrefix = _uriPrefix;
1443   }
1444    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1445     hiddenURL = _uriPrefix;
1446   }
1447 
1448 
1449   function setPaused() external onlyOwner {
1450     paused = !paused;
1451    
1452   }
1453 
1454   function setCost(uint _cost) external onlyOwner{
1455       cost = _cost;
1456 
1457   }
1458 
1459  function setRevealed() external onlyOwner{
1460      reveal = !reveal;
1461  }
1462 
1463   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1464       maxMintAmountPerTx = _maxtx;
1465 
1466   }
1467 
1468  
1469 
1470   function withdraw() external onlyOwner {
1471   uint _balance = address(this).balance;
1472      payable(msg.sender).transfer(_balance ); 
1473        
1474   }
1475 
1476 
1477   function _baseURI() internal view  override returns (string memory) {
1478     return uriPrefix;
1479   }
1480 }