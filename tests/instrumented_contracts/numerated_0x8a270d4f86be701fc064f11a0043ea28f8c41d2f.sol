1 /*
2 
3 ▄▄▄█████▓ ██ ▄█▀▓██   ██▓ ▒█████      ███▄    █   ▄████  ██░ ██ ▄▄▄█████▓ ███▄ ▄███▓ ██▀███  ▓█████   ██████ 
4 ▓  ██▒ ▓▒ ██▄█▒  ▒██  ██▒▒██▒  ██▒    ██ ▀█   █  ██▒ ▀█▒▓██░ ██▒▓  ██▒ ▓▒▓██▒▀█▀ ██▒▓██ ▒ ██▒▓█   ▀ ▒██    ▒ 
5 ▒ ▓██░ ▒░▓███▄░   ▒██ ██░▒██░  ██▒   ▓██  ▀█ ██▒▒██░▄▄▄░▒██▀▀██░▒ ▓██░ ▒░▓██    ▓██░▓██ ░▄█ ▒▒███   ░ ▓██▄   
6 ░ ▓██▓ ░ ▓██ █▄   ░ ▐██▓░▒██   ██░   ▓██▒  ▐▌██▒░▓█  ██▓░▓█ ░██ ░ ▓██▓ ░ ▒██    ▒██ ▒██▀▀█▄  ▒▓█  ▄   ▒   ██▒
7   ▒██▒ ░ ▒██▒ █▄  ░ ██▒▓░░ ████▓▒░   ▒██░   ▓██░░▒▓███▀▒░▓█▒░██▓  ▒██▒ ░ ▒██▒   ░██▒░██▓ ▒██▒░▒████▒▒██████▒▒
8   ▒ ░░   ▒ ▒▒ ▓▒   ██▒▒▒ ░ ▒░▒░▒░    ░ ▒░   ▒ ▒  ░▒   ▒  ▒ ░░▒░▒  ▒ ░░   ░ ▒░   ░  ░░ ▒▓ ░▒▓░░░ ▒░ ░▒ ▒▓▒ ▒ ░
9     ░    ░ ░▒ ▒░ ▓██ ░▒░   ░ ▒ ▒░    ░ ░░   ░ ▒░  ░   ░  ▒ ░▒░ ░    ░    ░  ░      ░  ░▒ ░ ▒░ ░ ░  ░░ ░▒  ░ ░
10   ░      ░ ░░ ░  ▒ ▒ ░░  ░ ░ ░ ▒        ░   ░ ░ ░ ░   ░  ░  ░░ ░  ░      ░      ░     ░░   ░    ░   ░  ░  ░  
11          ░  ░    ░ ░         ░ ░              ░       ░  ░  ░  ░                ░      ░        ░  ░      ░  
12                  ░ ░                                                                                         
13 /**
14 
15 // SPDX-License-Identifier: MIT
16 
17 // File: @openzeppelin/contracts/utils/Strings.sol
18 
19 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
20 
21 pragma solidity ^0.8.0;
22 
23 /**
24  * @dev String operations.
25  */
26 library Strings {
27     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
28 
29     /**
30      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
31      */
32     function toString(uint256 value) internal pure returns (string memory) {
33         // Inspired by OraclizeAPI's implementation - MIT licence
34         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
35 
36         if (value == 0) {
37             return "0";
38         }
39         uint256 temp = value;
40         uint256 digits;
41         while (temp != 0) {
42             digits++;
43             temp /= 10;
44         }
45         bytes memory buffer = new bytes(digits);
46         while (value != 0) {
47             digits -= 1;
48             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
49             value /= 10;
50         }
51         return string(buffer);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
56      */
57     function toHexString(uint256 value) internal pure returns (string memory) {
58         if (value == 0) {
59             return "0x00";
60         }
61         uint256 temp = value;
62         uint256 length = 0;
63         while (temp != 0) {
64             length++;
65             temp >>= 8;
66         }
67         return toHexString(value, length);
68     }
69 
70     /**
71      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
72      */
73     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
74         bytes memory buffer = new bytes(2 * length + 2);
75         buffer[0] = "0";
76         buffer[1] = "x";
77         for (uint256 i = 2 * length + 1; i > 1; --i) {
78             buffer[i] = _HEX_SYMBOLS[value & 0xf];
79             value >>= 4;
80         }
81         require(value == 0, "Strings: hex length insufficient");
82         return string(buffer);
83     }
84 }
85 
86 // File: @openzeppelin/contracts/utils/Context.sol
87 
88 
89 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev Provides information about the current execution context, including the
95  * sender of the transaction and its data. While these are generally available
96  * via msg.sender and msg.data, they should not be accessed in such a direct
97  * manner, since when dealing with meta-transactions the account sending and
98  * paying for execution may not be the actual sender (as far as an application
99  * is concerned).
100  *
101  * This contract is only required for intermediate, library-like contracts.
102  */
103 abstract contract Context {
104     function _msgSender() internal view virtual returns (address) {
105         return msg.sender;
106     }
107 
108     function _msgData() internal view virtual returns (bytes calldata) {
109         return msg.data;
110     }
111 }
112 
113 // File: @openzeppelin/contracts/utils/Address.sol
114 
115 
116 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
117 
118 pragma solidity ^0.8.1;
119 
120 /**
121  * @dev Collection of functions related to the address type
122  */
123 library Address {
124     /**
125      * @dev Returns true if `account` is a contract.
126      *
127      * [IMPORTANT]
128      * ====
129      * It is unsafe to assume that an address for which this function returns
130      * false is an externally-owned account (EOA) and not a contract.
131      *
132      * Among others, `isContract` will return false for the following
133      * types of addresses:
134      *
135      *  - an externally-owned account
136      *  - a contract in construction
137      *  - an address where a contract will be created
138      *  - an address where a contract lived, but was destroyed
139      * ====
140      *
141      * [IMPORTANT]
142      * ====
143      * You shouldn't rely on `isContract` to protect against flash loan attacks!
144      *
145      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
146      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
147      * constructor.
148      * ====
149      */
150     function isContract(address account) internal view returns (bool) {
151         // This method relies on extcodesize/address.code.length, which returns 0
152         // for contracts in construction, since the code is only stored at the end
153         // of the constructor execution.
154 
155         return account.code.length > 0;
156     }
157 
158     /**
159      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
160      * `recipient`, forwarding all available gas and reverting on errors.
161      *
162      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
163      * of certain opcodes, possibly making contracts go over the 2300 gas limit
164      * imposed by `transfer`, making them unable to receive funds via
165      * `transfer`. {sendValue} removes this limitation.
166      *
167      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
168      *
169      * IMPORTANT: because control is transferred to `recipient`, care must be
170      * taken to not create reentrancy vulnerabilities. Consider using
171      * {ReentrancyGuard} or the
172      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
173      */
174     function sendValue(address payable recipient, uint256 amount) internal {
175         require(address(this).balance >= amount, "Address: insufficient balance");
176 
177         (bool success, ) = recipient.call{value: amount}("");
178         require(success, "Address: unable to send value, recipient may have reverted");
179     }
180 
181     /**
182      * @dev Performs a Solidity function call using a low level `call`. A
183      * plain `call` is an unsafe replacement for a function call: use this
184      * function instead.
185      *
186      * If `target` reverts with a revert reason, it is bubbled up by this
187      * function (like regular Solidity function calls).
188      *
189      * Returns the raw returned data. To convert to the expected return value,
190      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
191      *
192      * Requirements:
193      *
194      * - `target` must be a contract.
195      * - calling `target` with `data` must not revert.
196      *
197      * _Available since v3.1._
198      */
199     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
200         return functionCall(target, data, "Address: low-level call failed");
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
205      * `errorMessage` as a fallback revert reason when `target` reverts.
206      *
207      * _Available since v3.1._
208      */
209     function functionCall(
210         address target,
211         bytes memory data,
212         string memory errorMessage
213     ) internal returns (bytes memory) {
214         return functionCallWithValue(target, data, 0, errorMessage);
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
219      * but also transferring `value` wei to `target`.
220      *
221      * Requirements:
222      *
223      * - the calling contract must have an ETH balance of at least `value`.
224      * - the called Solidity function must be `payable`.
225      *
226      * _Available since v3.1._
227      */
228     function functionCallWithValue(
229         address target,
230         bytes memory data,
231         uint256 value
232     ) internal returns (bytes memory) {
233         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
238      * with `errorMessage` as a fallback revert reason when `target` reverts.
239      *
240      * _Available since v3.1._
241      */
242     function functionCallWithValue(
243         address target,
244         bytes memory data,
245         uint256 value,
246         string memory errorMessage
247     ) internal returns (bytes memory) {
248         require(address(this).balance >= value, "Address: insufficient balance for call");
249         require(isContract(target), "Address: call to non-contract");
250 
251         (bool success, bytes memory returndata) = target.call{value: value}(data);
252         return verifyCallResult(success, returndata, errorMessage);
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
257      * but performing a static call.
258      *
259      * _Available since v3.3._
260      */
261     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
262         return functionStaticCall(target, data, "Address: low-level static call failed");
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
267      * but performing a static call.
268      *
269      * _Available since v3.3._
270      */
271     function functionStaticCall(
272         address target,
273         bytes memory data,
274         string memory errorMessage
275     ) internal view returns (bytes memory) {
276         require(isContract(target), "Address: static call to non-contract");
277 
278         (bool success, bytes memory returndata) = target.staticcall(data);
279         return verifyCallResult(success, returndata, errorMessage);
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
284      * but performing a delegate call.
285      *
286      * _Available since v3.4._
287      */
288     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
289         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
290     }
291 
292     /**
293      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
294      * but performing a delegate call.
295      *
296      * _Available since v3.4._
297      */
298     function functionDelegateCall(
299         address target,
300         bytes memory data,
301         string memory errorMessage
302     ) internal returns (bytes memory) {
303         require(isContract(target), "Address: delegate call to non-contract");
304 
305         (bool success, bytes memory returndata) = target.delegatecall(data);
306         return verifyCallResult(success, returndata, errorMessage);
307     }
308 
309     /**
310      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
311      * revert reason using the provided one.
312      *
313      * _Available since v4.3._
314      */
315     function verifyCallResult(
316         bool success,
317         bytes memory returndata,
318         string memory errorMessage
319     ) internal pure returns (bytes memory) {
320         if (success) {
321             return returndata;
322         } else {
323             // Look for revert reason and bubble it up if present
324             if (returndata.length > 0) {
325                 // The easiest way to bubble the revert reason is using memory via assembly
326 
327                 assembly {
328                     let returndata_size := mload(returndata)
329                     revert(add(32, returndata), returndata_size)
330                 }
331             } else {
332                 revert(errorMessage);
333             }
334         }
335     }
336 }
337 
338 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
339 
340 
341 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
342 
343 pragma solidity ^0.8.0;
344 
345 /**
346  * @title ERC721 token receiver interface
347  * @dev Interface for any contract that wants to support safeTransfers
348  * from ERC721 asset contracts.
349  */
350 interface IERC721Receiver {
351     /**
352      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
353      * by `operator` from `from`, this function is called.
354      *
355      * It must return its Solidity selector to confirm the token transfer.
356      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
357      *
358      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
359      */
360     function onERC721Received(
361         address operator,
362         address from,
363         uint256 tokenId,
364         bytes calldata data
365     ) external returns (bytes4);
366 }
367 
368 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
369 
370 
371 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
372 
373 pragma solidity ^0.8.0;
374 
375 /**
376  * @dev Interface of the ERC165 standard, as defined in the
377  * https://eips.ethereum.org/EIPS/eip-165[EIP].
378  *
379  * Implementers can declare support of contract interfaces, which can then be
380  * queried by others ({ERC165Checker}).
381  *
382  * For an implementation, see {ERC165}.
383  */
384 interface IERC165 {
385     /**
386      * @dev Returns true if this contract implements the interface defined by
387      * `interfaceId`. See the corresponding
388      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
389      * to learn more about how these ids are created.
390      *
391      * This function call must use less than 30 000 gas.
392      */
393     function supportsInterface(bytes4 interfaceId) external view returns (bool);
394 }
395 
396 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
397 
398 
399 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
400 
401 pragma solidity ^0.8.0;
402 
403 
404 /**
405  * @dev Implementation of the {IERC165} interface.
406  *
407  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
408  * for the additional interface id that will be supported. For example:
409  *
410  * ```solidity
411  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
412  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
413  * }
414  * ```
415  *
416  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
417  */
418 abstract contract ERC165 is IERC165 {
419     /**
420      * @dev See {IERC165-supportsInterface}.
421      */
422     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
423         return interfaceId == type(IERC165).interfaceId;
424     }
425 }
426 
427 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
428 
429 
430 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
431 
432 pragma solidity ^0.8.0;
433 
434 
435 /**
436  * @dev Required interface of an ERC721 compliant contract.
437  */
438 interface IERC721 is IERC165 {
439     /**
440      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
441      */
442     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
443 
444     /**
445      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
446      */
447     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
448 
449     /**
450      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
451      */
452     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
453 
454     /**
455      * @dev Returns the number of tokens in ``owner``'s account.
456      */
457     function balanceOf(address owner) external view returns (uint256 balance);
458 
459     /**
460      * @dev Returns the owner of the `tokenId` token.
461      *
462      * Requirements:
463      *
464      * - `tokenId` must exist.
465      */
466     function ownerOf(uint256 tokenId) external view returns (address owner);
467 
468     /**
469      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
470      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
471      *
472      * Requirements:
473      *
474      * - `from` cannot be the zero address.
475      * - `to` cannot be the zero address.
476      * - `tokenId` token must exist and be owned by `from`.
477      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
478      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
479      *
480      * Emits a {Transfer} event.
481      */
482     function safeTransferFrom(
483         address from,
484         address to,
485         uint256 tokenId
486     ) external;
487 
488     /**
489      * @dev Transfers `tokenId` token from `from` to `to`.
490      *
491      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
492      *
493      * Requirements:
494      *
495      * - `from` cannot be the zero address.
496      * - `to` cannot be the zero address.
497      * - `tokenId` token must be owned by `from`.
498      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
499      *
500      * Emits a {Transfer} event.
501      */
502     function transferFrom(
503         address from,
504         address to,
505         uint256 tokenId
506     ) external;
507 
508     /**
509      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
510      * The approval is cleared when the token is transferred.
511      *
512      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
513      *
514      * Requirements:
515      *
516      * - The caller must own the token or be an approved operator.
517      * - `tokenId` must exist.
518      *
519      * Emits an {Approval} event.
520      */
521     function approve(address to, uint256 tokenId) external;
522 
523     /**
524      * @dev Returns the account approved for `tokenId` token.
525      *
526      * Requirements:
527      *
528      * - `tokenId` must exist.
529      */
530     function getApproved(uint256 tokenId) external view returns (address operator);
531 
532     /**
533      * @dev Approve or remove `operator` as an operator for the caller.
534      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
535      *
536      * Requirements:
537      *
538      * - The `operator` cannot be the caller.
539      *
540      * Emits an {ApprovalForAll} event.
541      */
542     function setApprovalForAll(address operator, bool _approved) external;
543 
544     /**
545      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
546      *
547      * See {setApprovalForAll}
548      */
549     function isApprovedForAll(address owner, address operator) external view returns (bool);
550 
551     /**
552      * @dev Safely transfers `tokenId` token from `from` to `to`.
553      *
554      * Requirements:
555      *
556      * - `from` cannot be the zero address.
557      * - `to` cannot be the zero address.
558      * - `tokenId` token must exist and be owned by `from`.
559      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
560      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
561      *
562      * Emits a {Transfer} event.
563      */
564     function safeTransferFrom(
565         address from,
566         address to,
567         uint256 tokenId,
568         bytes calldata data
569     ) external;
570 }
571 
572 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
573 
574 
575 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
576 
577 pragma solidity ^0.8.0;
578 
579 
580 /**
581  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
582  * @dev See https://eips.ethereum.org/EIPS/eip-721
583  */
584 interface IERC721Metadata is IERC721 {
585     /**
586      * @dev Returns the token collection name.
587      */
588     function name() external view returns (string memory);
589 
590     /**
591      * @dev Returns the token collection symbol.
592      */
593     function symbol() external view returns (string memory);
594 
595     /**
596      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
597      */
598     function tokenURI(uint256 tokenId) external view returns (string memory);
599 }
600 
601 // File: contracts/new.sol
602 
603 
604 
605 
606 pragma solidity ^0.8.4;
607 
608 
609 
610 
611 
612 
613 
614 
615 error ApprovalCallerNotOwnerNorApproved();
616 error ApprovalQueryForNonexistentToken();
617 error ApproveToCaller();
618 error ApprovalToCurrentOwner();
619 error BalanceQueryForZeroAddress();
620 error MintToZeroAddress();
621 error MintZeroQuantity();
622 error OwnerQueryForNonexistentToken();
623 error TransferCallerNotOwnerNorApproved();
624 error TransferFromIncorrectOwner();
625 error TransferToNonERC721ReceiverImplementer();
626 error TransferToZeroAddress();
627 error URIQueryForNonexistentToken();
628 
629 /**
630  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
631  * the Metadata extension. Built to optimize for lower gas during batch mints.
632  *
633  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
634  *
635  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
636  *
637  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
638  */
639 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
640     using Address for address;
641     using Strings for uint256;
642 
643     // Compiler will pack this into a single 256bit word.
644     struct TokenOwnership {
645         // The address of the owner.
646         address addr;
647         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
648         uint64 startTimestamp;
649         // Whether the token has been burned.
650         bool burned;
651     }
652 
653     // Compiler will pack this into a single 256bit word.
654     struct AddressData {
655         // Realistically, 2**64-1 is more than enough.
656         uint64 balance;
657         // Keeps track of mint count with minimal overhead for tokenomics.
658         uint64 numberMinted;
659         // Keeps track of burn count with minimal overhead for tokenomics.
660         uint64 numberBurned;
661         // For miscellaneous variable(s) pertaining to the address
662         // (e.g. number of whitelist mint slots used).
663         // If there are multiple variables, please pack them into a uint64.
664         uint64 aux;
665     }
666 
667     // The tokenId of the next token to be minted.
668     uint256 internal _currentIndex;
669 
670     // The number of tokens burned.
671     uint256 internal _burnCounter;
672 
673     // Token name
674     string private _name;
675 
676     // Token symbol
677     string private _symbol;
678 
679     // Mapping from token ID to ownership details
680     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
681     mapping(uint256 => TokenOwnership) internal _ownerships;
682 
683     // Mapping owner address to address data
684     mapping(address => AddressData) private _addressData;
685 
686     // Mapping from token ID to approved address
687     mapping(uint256 => address) private _tokenApprovals;
688 
689     // Mapping from owner to operator approvals
690     mapping(address => mapping(address => bool)) private _operatorApprovals;
691 
692     constructor(string memory name_, string memory symbol_) {
693         _name = name_;
694         _symbol = symbol_;
695         _currentIndex = _startTokenId();
696     }
697 
698     /**
699      * To change the starting tokenId, please override this function.
700      */
701     function _startTokenId() internal view virtual returns (uint256) {
702         return 0;
703     }
704 
705     /**
706      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
707      */
708     function totalSupply() public view returns (uint256) {
709         // Counter underflow is impossible as _burnCounter cannot be incremented
710         // more than _currentIndex - _startTokenId() times
711         unchecked {
712             return _currentIndex - _burnCounter - _startTokenId();
713         }
714     }
715 
716     /**
717      * Returns the total amount of tokens minted in the contract.
718      */
719     function _totalMinted() internal view returns (uint256) {
720         // Counter underflow is impossible as _currentIndex does not decrement,
721         // and it is initialized to _startTokenId()
722         unchecked {
723             return _currentIndex - _startTokenId();
724         }
725     }
726 
727     /**
728      * @dev See {IERC165-supportsInterface}.
729      */
730     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
731         return
732             interfaceId == type(IERC721).interfaceId ||
733             interfaceId == type(IERC721Metadata).interfaceId ||
734             super.supportsInterface(interfaceId);
735     }
736 
737     /**
738      * @dev See {IERC721-balanceOf}.
739      */
740     function balanceOf(address owner) public view override returns (uint256) {
741         if (owner == address(0)) revert BalanceQueryForZeroAddress();
742         return uint256(_addressData[owner].balance);
743     }
744 
745     /**
746      * Returns the number of tokens minted by `owner`.
747      */
748     function _numberMinted(address owner) internal view returns (uint256) {
749         return uint256(_addressData[owner].numberMinted);
750     }
751 
752     /**
753      * Returns the number of tokens burned by or on behalf of `owner`.
754      */
755     function _numberBurned(address owner) internal view returns (uint256) {
756         return uint256(_addressData[owner].numberBurned);
757     }
758 
759     /**
760      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
761      */
762     function _getAux(address owner) internal view returns (uint64) {
763         return _addressData[owner].aux;
764     }
765 
766     /**
767      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
768      * If there are multiple variables, please pack them into a uint64.
769      */
770     function _setAux(address owner, uint64 aux) internal {
771         _addressData[owner].aux = aux;
772     }
773 
774     /**
775      * Gas spent here starts off proportional to the maximum mint batch size.
776      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
777      */
778     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
779         uint256 curr = tokenId;
780 
781         unchecked {
782             if (_startTokenId() <= curr && curr < _currentIndex) {
783                 TokenOwnership memory ownership = _ownerships[curr];
784                 if (!ownership.burned) {
785                     if (ownership.addr != address(0)) {
786                         return ownership;
787                     }
788                     // Invariant:
789                     // There will always be an ownership that has an address and is not burned
790                     // before an ownership that does not have an address and is not burned.
791                     // Hence, curr will not underflow.
792                     while (true) {
793                         curr--;
794                         ownership = _ownerships[curr];
795                         if (ownership.addr != address(0)) {
796                             return ownership;
797                         }
798                     }
799                 }
800             }
801         }
802         revert OwnerQueryForNonexistentToken();
803     }
804 
805     /**
806      * @dev See {IERC721-ownerOf}.
807      */
808     function ownerOf(uint256 tokenId) public view override returns (address) {
809         return _ownershipOf(tokenId).addr;
810     }
811 
812     /**
813      * @dev See {IERC721Metadata-name}.
814      */
815     function name() public view virtual override returns (string memory) {
816         return _name;
817     }
818 
819     /**
820      * @dev See {IERC721Metadata-symbol}.
821      */
822     function symbol() public view virtual override returns (string memory) {
823         return _symbol;
824     }
825 
826     /**
827      * @dev See {IERC721Metadata-tokenURI}.
828      */
829     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
830         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
831 
832         string memory baseURI = _baseURI();
833         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
834     }
835 
836     /**
837      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
838      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
839      * by default, can be overriden in child contracts.
840      */
841     function _baseURI() internal view virtual returns (string memory) {
842         return '';
843     }
844 
845     /**
846      * @dev See {IERC721-approve}.
847      */
848     function approve(address to, uint256 tokenId) public override {
849         address owner = ERC721A.ownerOf(tokenId);
850         if (to == owner) revert ApprovalToCurrentOwner();
851 
852         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
853             revert ApprovalCallerNotOwnerNorApproved();
854         }
855 
856         _approve(to, tokenId, owner);
857     }
858 
859     /**
860      * @dev See {IERC721-getApproved}.
861      */
862     function getApproved(uint256 tokenId) public view override returns (address) {
863         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
864 
865         return _tokenApprovals[tokenId];
866     }
867 
868     /**
869      * @dev See {IERC721-setApprovalForAll}.
870      */
871     function setApprovalForAll(address operator, bool approved) public virtual override {
872         if (operator == _msgSender()) revert ApproveToCaller();
873 
874         _operatorApprovals[_msgSender()][operator] = approved;
875         emit ApprovalForAll(_msgSender(), operator, approved);
876     }
877 
878     /**
879      * @dev See {IERC721-isApprovedForAll}.
880      */
881     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
882         return _operatorApprovals[owner][operator];
883     }
884 
885     /**
886      * @dev See {IERC721-transferFrom}.
887      */
888     function transferFrom(
889         address from,
890         address to,
891         uint256 tokenId
892     ) public virtual override {
893         _transfer(from, to, tokenId);
894     }
895 
896     /**
897      * @dev See {IERC721-safeTransferFrom}.
898      */
899     function safeTransferFrom(
900         address from,
901         address to,
902         uint256 tokenId
903     ) public virtual override {
904         safeTransferFrom(from, to, tokenId, '');
905     }
906 
907     /**
908      * @dev See {IERC721-safeTransferFrom}.
909      */
910     function safeTransferFrom(
911         address from,
912         address to,
913         uint256 tokenId,
914         bytes memory _data
915     ) public virtual override {
916         _transfer(from, to, tokenId);
917         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
918             revert TransferToNonERC721ReceiverImplementer();
919         }
920     }
921 
922     /**
923      * @dev Returns whether `tokenId` exists.
924      *
925      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
926      *
927      * Tokens start existing when they are minted (`_mint`),
928      */
929     function _exists(uint256 tokenId) internal view returns (bool) {
930         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
931             !_ownerships[tokenId].burned;
932     }
933 
934     function _safeMint(address to, uint256 quantity) internal {
935         _safeMint(to, quantity, '');
936     }
937 
938     /**
939      * @dev Safely mints `quantity` tokens and transfers them to `to`.
940      *
941      * Requirements:
942      *
943      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
944      * - `quantity` must be greater than 0.
945      *
946      * Emits a {Transfer} event.
947      */
948     function _safeMint(
949         address to,
950         uint256 quantity,
951         bytes memory _data
952     ) internal {
953         _mint(to, quantity, _data, true);
954     }
955 
956     /**
957      * @dev Mints `quantity` tokens and transfers them to `to`.
958      *
959      * Requirements:
960      *
961      * - `to` cannot be the zero address.
962      * - `quantity` must be greater than 0.
963      *
964      * Emits a {Transfer} event.
965      */
966     function _mint(
967         address to,
968         uint256 quantity,
969         bytes memory _data,
970         bool safe
971     ) internal {
972         uint256 startTokenId = _currentIndex;
973         if (to == address(0)) revert MintToZeroAddress();
974         if (quantity == 0) revert MintZeroQuantity();
975 
976         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
977 
978         // Overflows are incredibly unrealistic.
979         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
980         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
981         unchecked {
982             _addressData[to].balance += uint64(quantity);
983             _addressData[to].numberMinted += uint64(quantity);
984 
985             _ownerships[startTokenId].addr = to;
986             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
987 
988             uint256 updatedIndex = startTokenId;
989             uint256 end = updatedIndex + quantity;
990 
991             if (safe && to.isContract()) {
992                 do {
993                     emit Transfer(address(0), to, updatedIndex);
994                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
995                         revert TransferToNonERC721ReceiverImplementer();
996                     }
997                 } while (updatedIndex != end);
998                 // Reentrancy protection
999                 if (_currentIndex != startTokenId) revert();
1000             } else {
1001                 do {
1002                     emit Transfer(address(0), to, updatedIndex++);
1003                 } while (updatedIndex != end);
1004             }
1005             _currentIndex = updatedIndex;
1006         }
1007         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1008     }
1009 
1010     /**
1011      * @dev Transfers `tokenId` from `from` to `to`.
1012      *
1013      * Requirements:
1014      *
1015      * - `to` cannot be the zero address.
1016      * - `tokenId` token must be owned by `from`.
1017      *
1018      * Emits a {Transfer} event.
1019      */
1020     function _transfer(
1021         address from,
1022         address to,
1023         uint256 tokenId
1024     ) private {
1025         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1026 
1027         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1028 
1029         bool isApprovedOrOwner = (_msgSender() == from ||
1030             isApprovedForAll(from, _msgSender()) ||
1031             getApproved(tokenId) == _msgSender());
1032 
1033         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1034         if (to == address(0)) revert TransferToZeroAddress();
1035 
1036         _beforeTokenTransfers(from, to, tokenId, 1);
1037 
1038         // Clear approvals from the previous owner
1039         _approve(address(0), tokenId, from);
1040 
1041         // Underflow of the sender's balance is impossible because we check for
1042         // ownership above and the recipient's balance can't realistically overflow.
1043         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1044         unchecked {
1045             _addressData[from].balance -= 1;
1046             _addressData[to].balance += 1;
1047 
1048             TokenOwnership storage currSlot = _ownerships[tokenId];
1049             currSlot.addr = to;
1050             currSlot.startTimestamp = uint64(block.timestamp);
1051 
1052             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1053             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1054             uint256 nextTokenId = tokenId + 1;
1055             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1056             if (nextSlot.addr == address(0)) {
1057                 // This will suffice for checking _exists(nextTokenId),
1058                 // as a burned slot cannot contain the zero address.
1059                 if (nextTokenId != _currentIndex) {
1060                     nextSlot.addr = from;
1061                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1062                 }
1063             }
1064         }
1065 
1066         emit Transfer(from, to, tokenId);
1067         _afterTokenTransfers(from, to, tokenId, 1);
1068     }
1069 
1070     /**
1071      * @dev This is equivalent to _burn(tokenId, false)
1072      */
1073     function _burn(uint256 tokenId) internal virtual {
1074         _burn(tokenId, false);
1075     }
1076 
1077     /**
1078      * @dev Destroys `tokenId`.
1079      * The approval is cleared when the token is burned.
1080      *
1081      * Requirements:
1082      *
1083      * - `tokenId` must exist.
1084      *
1085      * Emits a {Transfer} event.
1086      */
1087     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1088         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1089 
1090         address from = prevOwnership.addr;
1091 
1092         if (approvalCheck) {
1093             bool isApprovedOrOwner = (_msgSender() == from ||
1094                 isApprovedForAll(from, _msgSender()) ||
1095                 getApproved(tokenId) == _msgSender());
1096 
1097             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1098         }
1099 
1100         _beforeTokenTransfers(from, address(0), tokenId, 1);
1101 
1102         // Clear approvals from the previous owner
1103         _approve(address(0), tokenId, from);
1104 
1105         // Underflow of the sender's balance is impossible because we check for
1106         // ownership above and the recipient's balance can't realistically overflow.
1107         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1108         unchecked {
1109             AddressData storage addressData = _addressData[from];
1110             addressData.balance -= 1;
1111             addressData.numberBurned += 1;
1112 
1113             // Keep track of who burned the token, and the timestamp of burning.
1114             TokenOwnership storage currSlot = _ownerships[tokenId];
1115             currSlot.addr = from;
1116             currSlot.startTimestamp = uint64(block.timestamp);
1117             currSlot.burned = true;
1118 
1119             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1120             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1121             uint256 nextTokenId = tokenId + 1;
1122             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1123             if (nextSlot.addr == address(0)) {
1124                 // This will suffice for checking _exists(nextTokenId),
1125                 // as a burned slot cannot contain the zero address.
1126                 if (nextTokenId != _currentIndex) {
1127                     nextSlot.addr = from;
1128                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1129                 }
1130             }
1131         }
1132 
1133         emit Transfer(from, address(0), tokenId);
1134         _afterTokenTransfers(from, address(0), tokenId, 1);
1135 
1136         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1137         unchecked {
1138             _burnCounter++;
1139         }
1140     }
1141 
1142     /**
1143      * @dev Approve `to` to operate on `tokenId`
1144      *
1145      * Emits a {Approval} event.
1146      */
1147     function _approve(
1148         address to,
1149         uint256 tokenId,
1150         address owner
1151     ) private {
1152         _tokenApprovals[tokenId] = to;
1153         emit Approval(owner, to, tokenId);
1154     }
1155 
1156     /**
1157      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1158      *
1159      * @param from address representing the previous owner of the given token ID
1160      * @param to target address that will receive the tokens
1161      * @param tokenId uint256 ID of the token to be transferred
1162      * @param _data bytes optional data to send along with the call
1163      * @return bool whether the call correctly returned the expected magic value
1164      */
1165     function _checkContractOnERC721Received(
1166         address from,
1167         address to,
1168         uint256 tokenId,
1169         bytes memory _data
1170     ) private returns (bool) {
1171         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1172             return retval == IERC721Receiver(to).onERC721Received.selector;
1173         } catch (bytes memory reason) {
1174             if (reason.length == 0) {
1175                 revert TransferToNonERC721ReceiverImplementer();
1176             } else {
1177                 assembly {
1178                     revert(add(32, reason), mload(reason))
1179                 }
1180             }
1181         }
1182     }
1183 
1184     /**
1185      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1186      * And also called before burning one token.
1187      *
1188      * startTokenId - the first token id to be transferred
1189      * quantity - the amount to be transferred
1190      *
1191      * Calling conditions:
1192      *
1193      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1194      * transferred to `to`.
1195      * - When `from` is zero, `tokenId` will be minted for `to`.
1196      * - When `to` is zero, `tokenId` will be burned by `from`.
1197      * - `from` and `to` are never both zero.
1198      */
1199     function _beforeTokenTransfers(
1200         address from,
1201         address to,
1202         uint256 startTokenId,
1203         uint256 quantity
1204     ) internal virtual {}
1205 
1206     /**
1207      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1208      * minting.
1209      * And also called after one token has been burned.
1210      *
1211      * startTokenId - the first token id to be transferred
1212      * quantity - the amount to be transferred
1213      *
1214      * Calling conditions:
1215      *
1216      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1217      * transferred to `to`.
1218      * - When `from` is zero, `tokenId` has been minted for `to`.
1219      * - When `to` is zero, `tokenId` has been burned by `from`.
1220      * - `from` and `to` are never both zero.
1221      */
1222     function _afterTokenTransfers(
1223         address from,
1224         address to,
1225         uint256 startTokenId,
1226         uint256 quantity
1227     ) internal virtual {}
1228 }
1229 
1230 abstract contract Ownable is Context {
1231     address private _owner;
1232 
1233     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1234 
1235     /**
1236      * @dev Initializes the contract setting the deployer as the initial owner.
1237      */
1238     constructor() {
1239         _transferOwnership(_msgSender());
1240     }
1241 
1242     /**
1243      * @dev Returns the address of the current owner.
1244      */
1245     function owner() public view virtual returns (address) {
1246         return _owner;
1247     }
1248 
1249     /**
1250      * @dev Throws if called by any account other than the owner.
1251      */
1252     modifier onlyOwner() {
1253         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1254         _;
1255     }
1256 
1257     /**
1258      * @dev Leaves the contract without owner. It will not be possible to call
1259      * `onlyOwner` functions anymore. Can only be called by the current owner.
1260      *
1261      * NOTE: Renouncing ownership will leave the contract without an owner,
1262      * thereby removing any functionality that is only available to the owner.
1263      */
1264     function renounceOwnership() public virtual onlyOwner {
1265         _transferOwnership(address(0));
1266     }
1267 
1268     /**
1269      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1270      * Can only be called by the current owner.
1271      */
1272     function transferOwnership(address newOwner) public virtual onlyOwner {
1273         require(newOwner != address(0), "Ownable: new owner is the zero address");
1274         _transferOwnership(newOwner);
1275     }
1276 
1277     /**
1278      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1279      * Internal function without access restriction.
1280      */
1281     function _transferOwnership(address newOwner) internal virtual {
1282         address oldOwner = _owner;
1283         _owner = newOwner;
1284         emit OwnershipTransferred(oldOwner, newOwner);
1285     }
1286 }
1287     pragma solidity ^0.8.7;
1288     
1289     contract TKYONGHTMRES is ERC721A, Ownable {
1290     using Strings for uint256;
1291 
1292 
1293   string private uriPrefix ;
1294   string private uriSuffix = ".json";
1295   string public hiddenURL;
1296 
1297   
1298   
1299 
1300   uint256 public cost = 0.0025 ether;
1301   uint256 public whiteListCost = 0 ;
1302   
1303 
1304   uint16 public maxSupply = 6900;
1305   uint8 public maxMintAmountPerTx = 21;
1306     uint8 public maxFreeMintAmountPerWallet = 1;
1307                                                              
1308   bool public WLpaused = true;
1309   bool public paused = true;
1310   bool public reveal =false;
1311   mapping (address => uint8) public NFTPerWLAddress;
1312    mapping (address => uint8) public NFTPerPublicAddress;
1313   mapping (address => bool) public isWhitelisted;
1314  
1315   
1316   
1317  
1318   
1319 
1320   constructor() ERC721A("TKYONGHTMRES", "NGHTMRES") {
1321   }
1322 
1323   
1324  
1325   function mint(uint8 _mintAmount) external payable  {
1326      uint16 totalSupply = uint16(totalSupply());
1327      uint8 nft = NFTPerPublicAddress[msg.sender];
1328     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1329     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1330 
1331     require(!paused, "The contract is paused!");
1332     
1333       if(nft >= maxFreeMintAmountPerWallet)
1334     {
1335     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1336     }
1337     else {
1338          uint8 costAmount = _mintAmount + nft;
1339         if(costAmount > maxFreeMintAmountPerWallet)
1340        {
1341         costAmount = costAmount - maxFreeMintAmountPerWallet;
1342         require(msg.value >= cost * costAmount, "Insufficient funds!");
1343        }
1344        
1345          
1346     }
1347     
1348 
1349 
1350     _safeMint(msg.sender , _mintAmount);
1351 
1352     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1353      
1354      delete totalSupply;
1355      delete _mintAmount;
1356   }
1357   
1358   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1359      uint16 totalSupply = uint16(totalSupply());
1360     require(totalSupply + _mintAmount <= maxSupply, "Excedes max supply.");
1361      _safeMint(_receiver , _mintAmount);
1362      delete _mintAmount;
1363      delete _receiver;
1364      delete totalSupply;
1365   }
1366 
1367   function Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1368      uint16 totalSupply = uint16(totalSupply());
1369      uint totalAmount =   _amountPerAddress * addresses.length;
1370     require(totalSupply + totalAmount <= maxSupply, "Excedes max supply.");
1371      for (uint256 i = 0; i < addresses.length; i++) {
1372             _safeMint(addresses[i], _amountPerAddress);
1373         }
1374 
1375      delete _amountPerAddress;
1376      delete totalSupply;
1377   }
1378 
1379  
1380 
1381   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1382       maxSupply = _maxSupply;
1383   }
1384 
1385 
1386 
1387    
1388   function tokenURI(uint256 _tokenId)
1389     public
1390     view
1391     virtual
1392     override
1393     returns (string memory)
1394   {
1395     require(
1396       _exists(_tokenId),
1397       "ERC721Metadata: URI query for nonexistent token"
1398     );
1399     
1400   
1401 if ( reveal == false)
1402 {
1403     return hiddenURL;
1404 }
1405     
1406 
1407     string memory currentBaseURI = _baseURI();
1408     return bytes(currentBaseURI).length > 0
1409         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1410         : "";
1411   }
1412  
1413    function setWLPaused() external onlyOwner {
1414     WLpaused = !WLpaused;
1415   }
1416   function setWLCost(uint256 _cost) external onlyOwner {
1417     whiteListCost = _cost;
1418     delete _cost;
1419   }
1420 
1421 
1422 
1423  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1424     maxFreeMintAmountPerWallet = _limit;
1425    delete _limit;
1426 
1427 }
1428 
1429     
1430   function addToPresaleWhitelist(address[] calldata entries) external onlyOwner {
1431         for(uint8 i = 0; i < entries.length; i++) {
1432             isWhitelisted[entries[i]] = true;
1433         }   
1434     }
1435 
1436     function removeFromPresaleWhitelist(address[] calldata entries) external onlyOwner {
1437         for(uint8 i = 0; i < entries.length; i++) {
1438              isWhitelisted[entries[i]] = false;
1439         }
1440     }
1441 
1442 function whitelistMint(uint8 _mintAmount) external payable {
1443         
1444     
1445         uint8 nft = NFTPerWLAddress[msg.sender];
1446        require(isWhitelisted[msg.sender],  "You are not whitelisted");
1447 
1448        require (nft + _mintAmount <= maxMintAmountPerTx, "Exceeds max  limit  per address");
1449       
1450 
1451 
1452     require(!WLpaused, "Whitelist minting is over!");
1453          if(nft >= maxFreeMintAmountPerWallet)
1454     {
1455     require(msg.value >= whiteListCost * _mintAmount, "Insufficient funds!");
1456     }
1457     else {
1458          uint8 costAmount = _mintAmount + nft;
1459         if(costAmount > maxFreeMintAmountPerWallet)
1460        {
1461         costAmount = costAmount - maxFreeMintAmountPerWallet;
1462         require(msg.value >= whiteListCost * costAmount, "Insufficient funds!");
1463        }
1464        
1465          
1466     }
1467     
1468     
1469 
1470      _safeMint(msg.sender , _mintAmount);
1471       NFTPerWLAddress[msg.sender] =nft + _mintAmount;
1472      
1473       delete _mintAmount;
1474        delete nft;
1475     
1476     }
1477 
1478   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1479     uriPrefix = _uriPrefix;
1480   }
1481    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1482     hiddenURL = _uriPrefix;
1483   }
1484 
1485 
1486   function setPaused() external onlyOwner {
1487     paused = !paused;
1488     WLpaused = true;
1489   }
1490 
1491   function setCost(uint _cost) external onlyOwner{
1492       cost = _cost;
1493 
1494   }
1495 
1496  function setRevealed() external onlyOwner{
1497      reveal = !reveal;
1498  }
1499 
1500   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1501       maxMintAmountPerTx = _maxtx;
1502 
1503   }
1504 
1505  
1506 
1507   function withdraw() external onlyOwner {
1508   uint _balance = address(this).balance;
1509      payable(msg.sender).transfer(_balance ); 
1510        
1511   }
1512 
1513 
1514   function _baseURI() internal view  override returns (string memory) {
1515     return uriPrefix;
1516   }
1517 }