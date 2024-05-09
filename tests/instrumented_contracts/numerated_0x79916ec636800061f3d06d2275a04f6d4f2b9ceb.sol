1 /**
2                                                                                         
3                           ██████  ██████████████████  ██████                            
4                         ██░░░░░░██░░░░░░░░░░░░░░░░░░██░░░░░░██                          
5                         ██░░░░██░░░░░░░░░░░░░░░░░░░░░░██░░░░██                          
6                           ████░░░░░░░░░░░░░░░░░░░░░░░░░░████                            
7                             ██░░░░░░  ██░░░░░░██  ░░░░░░██                              
8                             ██░░░░░░████      ████░░░░░░░░██                            
9                           ██░░░░░░      ▒▒  ▒▒      ░░░░░░██                            
10                         ██░░░░░░░░        ▒▒        ░░░░░░░░██                          
11                         ██░░░░░░░░    ██  ██  ██    ░░░░░░░░██                          
12                         ██░░░░░░░░░░    ██████    ░░░░░░░░░░██                          
13                         ██░░░░░░████              ░░░░░░░░░░██                          
14                           ██░░██░░░░██░░░░░░░░░░░░░░░░░░████                            
15                             ██░░░░░░██░░░░░░░░░░░░██████                                
16                           ██░░░░░░░░██████████████░░░░████████                          
17                         ██░░░░░░░░██░░          ░░░░░░░░██░░░░██                        
18                         ██░░░░░░██    ▒▒▒▒  ▒▒▒▒  ░░░░░░░░██░░░░██                      
19                           ██████░░  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒  ░░░░░░██░░░░██                      
20                             ██░░░░    ▒▒▒▒▒▒▒▒▒▒    ░░░░░░██░░██                        
21                             ██░░░░      ▒▒▒▒▒▒      ░░░░░░████                          
22                             ██░░░░░░      ▒▒      ░░░░░░████                            
23                               ██░░░░░░          ░░░░░░██                                
24                                 ██░░░░░░░░░░░░░░░░░░██                                  
25                                 ██░░░░░░░░██░░░░░░░░██                                  
26                             ████████░░░░░░██░░░░░░████████                              
27                           ██░░░░░░░░░░░░░░██░░░░░░░░░░░░░░██                            
28                           ██░░░░░░░░░░░░░░██░░░░░░░░░░░░░░██                            
29                           ████████████████  ████████████████                            
30                                                                                         
31 
32  */
33 // SPDX-License-Identifier: MIT
34 //Developer Info:
35 
36 
37 
38 // File: @openzeppelin/contracts/utils/Strings.sol
39 
40 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
41 
42 pragma solidity ^0.8.0;
43 
44 /**
45  * @dev String operations.
46  */
47 library Strings {
48     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
49 
50     /**
51      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
52      */
53     function toString(uint256 value) internal pure returns (string memory) {
54         // Inspired by OraclizeAPI's implementation - MIT licence
55         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
56 
57         if (value == 0) {
58             return "0";
59         }
60         uint256 temp = value;
61         uint256 digits;
62         while (temp != 0) {
63             digits++;
64             temp /= 10;
65         }
66         bytes memory buffer = new bytes(digits);
67         while (value != 0) {
68             digits -= 1;
69             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
70             value /= 10;
71         }
72         return string(buffer);
73     }
74 
75     /**
76      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
77      */
78     function toHexString(uint256 value) internal pure returns (string memory) {
79         if (value == 0) {
80             return "0x00";
81         }
82         uint256 temp = value;
83         uint256 length = 0;
84         while (temp != 0) {
85             length++;
86             temp >>= 8;
87         }
88         return toHexString(value, length);
89     }
90 
91     /**
92      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
93      */
94     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
95         bytes memory buffer = new bytes(2 * length + 2);
96         buffer[0] = "0";
97         buffer[1] = "x";
98         for (uint256 i = 2 * length + 1; i > 1; --i) {
99             buffer[i] = _HEX_SYMBOLS[value & 0xf];
100             value >>= 4;
101         }
102         require(value == 0, "Strings: hex length insufficient");
103         return string(buffer);
104     }
105 }
106 
107 // File: @openzeppelin/contracts/utils/Context.sol
108 
109 
110 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
111 
112 pragma solidity ^0.8.0;
113 
114 /**
115  * @dev Provides information about the current execution context, including the
116  * sender of the transaction and its data. While these are generally available
117  * via msg.sender and msg.data, they should not be accessed in such a direct
118  * manner, since when dealing with meta-transactions the account sending and
119  * paying for execution may not be the actual sender (as far as an application
120  * is concerned).
121  *
122  * This contract is only required for intermediate, library-like contracts.
123  */
124 abstract contract Context {
125     function _msgSender() internal view virtual returns (address) {
126         return msg.sender;
127     }
128 
129     function _msgData() internal view virtual returns (bytes calldata) {
130         return msg.data;
131     }
132 }
133 
134 // File: @openzeppelin/contracts/utils/Address.sol
135 
136 
137 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
138 
139 pragma solidity ^0.8.1;
140 
141 /**
142  * @dev Collection of functions related to the address type
143  */
144 library Address {
145     /**
146      * @dev Returns true if `account` is a contract.
147      *
148      * [IMPORTANT]
149      * ====
150      * It is unsafe to assume that an address for which this function returns
151      * false is an externally-owned account (EOA) and not a contract.
152      *
153      * Among others, `isContract` will return false for the following
154      * types of addresses:
155      *
156      *  - an externally-owned account
157      *  - a contract in construction
158      *  - an address where a contract will be created
159      *  - an address where a contract lived, but was destroyed
160      * ====
161      *
162      * [IMPORTANT]
163      * ====
164      * You shouldn't rely on `isContract` to protect against flash loan attacks!
165      *
166      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
167      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
168      * constructor.
169      * ====
170      */
171     function isContract(address account) internal view returns (bool) {
172         // This method relies on extcodesize/address.code.length, which returns 0
173         // for contracts in construction, since the code is only stored at the end
174         // of the constructor execution.
175 
176         return account.code.length > 0;
177     }
178 
179     /**
180      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
181      * `recipient`, forwarding all available gas and reverting on errors.
182      *
183      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
184      * of certain opcodes, possibly making contracts go over the 2300 gas limit
185      * imposed by `transfer`, making them unable to receive funds via
186      * `transfer`. {sendValue} removes this limitation.
187      *
188      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
189      *
190      * IMPORTANT: because control is transferred to `recipient`, care must be
191      * taken to not create reentrancy vulnerabilities. Consider using
192      * {ReentrancyGuard} or the
193      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
194      */
195     function sendValue(address payable recipient, uint256 amount) internal {
196         require(address(this).balance >= amount, "Address: insufficient balance");
197 
198         (bool success, ) = recipient.call{value: amount}("");
199         require(success, "Address: unable to send value, recipient may have reverted");
200     }
201 
202     /**
203      * @dev Performs a Solidity function call using a low level `call`. A
204      * plain `call` is an unsafe replacement for a function call: use this
205      * function instead.
206      *
207      * If `target` reverts with a revert reason, it is bubbled up by this
208      * function (like regular Solidity function calls).
209      *
210      * Returns the raw returned data. To convert to the expected return value,
211      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
212      *
213      * Requirements:
214      *
215      * - `target` must be a contract.
216      * - calling `target` with `data` must not revert.
217      *
218      * _Available since v3.1._
219      */
220     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
221         return functionCall(target, data, "Address: low-level call failed");
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
226      * `errorMessage` as a fallback revert reason when `target` reverts.
227      *
228      * _Available since v3.1._
229      */
230     function functionCall(
231         address target,
232         bytes memory data,
233         string memory errorMessage
234     ) internal returns (bytes memory) {
235         return functionCallWithValue(target, data, 0, errorMessage);
236     }
237 
238     /**
239      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
240      * but also transferring `value` wei to `target`.
241      *
242      * Requirements:
243      *
244      * - the calling contract must have an ETH balance of at least `value`.
245      * - the called Solidity function must be `payable`.
246      *
247      * _Available since v3.1._
248      */
249     function functionCallWithValue(
250         address target,
251         bytes memory data,
252         uint256 value
253     ) internal returns (bytes memory) {
254         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
259      * with `errorMessage` as a fallback revert reason when `target` reverts.
260      *
261      * _Available since v3.1._
262      */
263     function functionCallWithValue(
264         address target,
265         bytes memory data,
266         uint256 value,
267         string memory errorMessage
268     ) internal returns (bytes memory) {
269         require(address(this).balance >= value, "Address: insufficient balance for call");
270         require(isContract(target), "Address: call to non-contract");
271 
272         (bool success, bytes memory returndata) = target.call{value: value}(data);
273         return verifyCallResult(success, returndata, errorMessage);
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
278      * but performing a static call.
279      *
280      * _Available since v3.3._
281      */
282     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
283         return functionStaticCall(target, data, "Address: low-level static call failed");
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
288      * but performing a static call.
289      *
290      * _Available since v3.3._
291      */
292     function functionStaticCall(
293         address target,
294         bytes memory data,
295         string memory errorMessage
296     ) internal view returns (bytes memory) {
297         require(isContract(target), "Address: static call to non-contract");
298 
299         (bool success, bytes memory returndata) = target.staticcall(data);
300         return verifyCallResult(success, returndata, errorMessage);
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
305      * but performing a delegate call.
306      *
307      * _Available since v3.4._
308      */
309     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
310         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
315      * but performing a delegate call.
316      *
317      * _Available since v3.4._
318      */
319     function functionDelegateCall(
320         address target,
321         bytes memory data,
322         string memory errorMessage
323     ) internal returns (bytes memory) {
324         require(isContract(target), "Address: delegate call to non-contract");
325 
326         (bool success, bytes memory returndata) = target.delegatecall(data);
327         return verifyCallResult(success, returndata, errorMessage);
328     }
329 
330     /**
331      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
332      * revert reason using the provided one.
333      *
334      * _Available since v4.3._
335      */
336     function verifyCallResult(
337         bool success,
338         bytes memory returndata,
339         string memory errorMessage
340     ) internal pure returns (bytes memory) {
341         if (success) {
342             return returndata;
343         } else {
344             // Look for revert reason and bubble it up if present
345             if (returndata.length > 0) {
346                 // The easiest way to bubble the revert reason is using memory via assembly
347 
348                 assembly {
349                     let returndata_size := mload(returndata)
350                     revert(add(32, returndata), returndata_size)
351                 }
352             } else {
353                 revert(errorMessage);
354             }
355         }
356     }
357 }
358 
359 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
360 
361 
362 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
363 
364 pragma solidity ^0.8.0;
365 
366 /**
367  * @title ERC721 token receiver interface
368  * @dev Interface for any contract that wants to support safeTransfers
369  * from ERC721 asset contracts.
370  */
371 interface IERC721Receiver {
372     /**
373      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
374      * by `operator` from `from`, this function is called.
375      *
376      * It must return its Solidity selector to confirm the token transfer.
377      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
378      *
379      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
380      */
381     function onERC721Received(
382         address operator,
383         address from,
384         uint256 tokenId,
385         bytes calldata data
386     ) external returns (bytes4);
387 }
388 
389 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
390 
391 
392 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
393 
394 pragma solidity ^0.8.0;
395 
396 /**
397  * @dev Interface of the ERC165 standard, as defined in the
398  * https://eips.ethereum.org/EIPS/eip-165[EIP].
399  *
400  * Implementers can declare support of contract interfaces, which can then be
401  * queried by others ({ERC165Checker}).
402  *
403  * For an implementation, see {ERC165}.
404  */
405 interface IERC165 {
406     /**
407      * @dev Returns true if this contract implements the interface defined by
408      * `interfaceId`. See the corresponding
409      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
410      * to learn more about how these ids are created.
411      *
412      * This function call must use less than 30 000 gas.
413      */
414     function supportsInterface(bytes4 interfaceId) external view returns (bool);
415 }
416 
417 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
418 
419 
420 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
421 
422 pragma solidity ^0.8.0;
423 
424 
425 /**
426  * @dev Implementation of the {IERC165} interface.
427  *
428  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
429  * for the additional interface id that will be supported. For example:
430  *
431  * ```solidity
432  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
433  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
434  * }
435  * ```
436  *
437  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
438  */
439 abstract contract ERC165 is IERC165 {
440     /**
441      * @dev See {IERC165-supportsInterface}.
442      */
443     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
444         return interfaceId == type(IERC165).interfaceId;
445     }
446 }
447 
448 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
449 
450 
451 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
452 
453 pragma solidity ^0.8.0;
454 
455 
456 /**
457  * @dev Required interface of an ERC721 compliant contract.
458  */
459 interface IERC721 is IERC165 {
460     /**
461      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
462      */
463     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
464 
465     /**
466      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
467      */
468     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
469 
470     /**
471      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
472      */
473     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
474 
475     /**
476      * @dev Returns the number of tokens in ``owner``'s account.
477      */
478     function balanceOf(address owner) external view returns (uint256 balance);
479 
480     /**
481      * @dev Returns the owner of the `tokenId` token.
482      *
483      * Requirements:
484      *
485      * - `tokenId` must exist.
486      */
487     function ownerOf(uint256 tokenId) external view returns (address owner);
488 
489     /**
490      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
491      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
492      *
493      * Requirements:
494      *
495      * - `from` cannot be the zero address.
496      * - `to` cannot be the zero address.
497      * - `tokenId` token must exist and be owned by `from`.
498      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
499      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
500      *
501      * Emits a {Transfer} event.
502      */
503     function safeTransferFrom(
504         address from,
505         address to,
506         uint256 tokenId
507     ) external;
508 
509     /**
510      * @dev Transfers `tokenId` token from `from` to `to`.
511      *
512      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
513      *
514      * Requirements:
515      *
516      * - `from` cannot be the zero address.
517      * - `to` cannot be the zero address.
518      * - `tokenId` token must be owned by `from`.
519      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
520      *
521      * Emits a {Transfer} event.
522      */
523     function transferFrom(
524         address from,
525         address to,
526         uint256 tokenId
527     ) external;
528 
529     /**
530      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
531      * The approval is cleared when the token is transferred.
532      *
533      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
534      *
535      * Requirements:
536      *
537      * - The caller must own the token or be an approved operator.
538      * - `tokenId` must exist.
539      *
540      * Emits an {Approval} event.
541      */
542     function approve(address to, uint256 tokenId) external;
543 
544     /**
545      * @dev Returns the account approved for `tokenId` token.
546      *
547      * Requirements:
548      *
549      * - `tokenId` must exist.
550      */
551     function getApproved(uint256 tokenId) external view returns (address operator);
552 
553     /**
554      * @dev Approve or remove `operator` as an operator for the caller.
555      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
556      *
557      * Requirements:
558      *
559      * - The `operator` cannot be the caller.
560      *
561      * Emits an {ApprovalForAll} event.
562      */
563     function setApprovalForAll(address operator, bool _approved) external;
564 
565     /**
566      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
567      *
568      * See {setApprovalForAll}
569      */
570     function isApprovedForAll(address owner, address operator) external view returns (bool);
571 
572     /**
573      * @dev Safely transfers `tokenId` token from `from` to `to`.
574      *
575      * Requirements:
576      *
577      * - `from` cannot be the zero address.
578      * - `to` cannot be the zero address.
579      * - `tokenId` token must exist and be owned by `from`.
580      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
581      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
582      *
583      * Emits a {Transfer} event.
584      */
585     function safeTransferFrom(
586         address from,
587         address to,
588         uint256 tokenId,
589         bytes calldata data
590     ) external;
591 }
592 
593 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
594 
595 
596 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
597 
598 pragma solidity ^0.8.0;
599 
600 
601 /**
602  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
603  * @dev See https://eips.ethereum.org/EIPS/eip-721
604  */
605 interface IERC721Metadata is IERC721 {
606     /**
607      * @dev Returns the token collection name.
608      */
609     function name() external view returns (string memory);
610 
611     /**
612      * @dev Returns the token collection symbol.
613      */
614     function symbol() external view returns (string memory);
615 
616     /**
617      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
618      */
619     function tokenURI(uint256 tokenId) external view returns (string memory);
620 }
621 
622 // File: contracts/new.sol
623 
624 
625 
626 
627 pragma solidity ^0.8.4;
628 
629 
630 
631 
632 
633 
634 
635 
636 error ApprovalCallerNotOwnerNorApproved();
637 error ApprovalQueryForNonexistentToken();
638 error ApproveToCaller();
639 error ApprovalToCurrentOwner();
640 error BalanceQueryForZeroAddress();
641 error MintToZeroAddress();
642 error MintZeroQuantity();
643 error OwnerQueryForNonexistentToken();
644 error TransferCallerNotOwnerNorApproved();
645 error TransferFromIncorrectOwner();
646 error TransferToNonERC721ReceiverImplementer();
647 error TransferToZeroAddress();
648 error URIQueryForNonexistentToken();
649 
650 /**
651  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
652  * the Metadata extension. Built to optimize for lower gas during batch mints.
653  *
654  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
655  *
656  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
657  *
658  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
659  */
660 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
661     using Address for address;
662     using Strings for uint256;
663 
664     // Compiler will pack this into a single 256bit word.
665     struct TokenOwnership {
666         // The address of the owner.
667         address addr;
668         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
669         uint64 startTimestamp;
670         // Whether the token has been burned.
671         bool burned;
672     }
673 
674     // Compiler will pack this into a single 256bit word.
675     struct AddressData {
676         // Realistically, 2**64-1 is more than enough.
677         uint64 balance;
678         // Keeps track of mint count with minimal overhead for tokenomics.
679         uint64 numberMinted;
680         // Keeps track of burn count with minimal overhead for tokenomics.
681         uint64 numberBurned;
682         // For miscellaneous variable(s) pertaining to the address
683         // (e.g. number of whitelist mint slots used).
684         // If there are multiple variables, please pack them into a uint64.
685         uint64 aux;
686     }
687 
688     // The tokenId of the next token to be minted.
689     uint256 internal _currentIndex;
690 
691     // The number of tokens burned.
692     uint256 internal _burnCounter;
693 
694     // Token name
695     string private _name;
696 
697     // Token symbol
698     string private _symbol;
699 
700     // Mapping from token ID to ownership details
701     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
702     mapping(uint256 => TokenOwnership) internal _ownerships;
703 
704     // Mapping owner address to address data
705     mapping(address => AddressData) private _addressData;
706 
707     // Mapping from token ID to approved address
708     mapping(uint256 => address) private _tokenApprovals;
709 
710     // Mapping from owner to operator approvals
711     mapping(address => mapping(address => bool)) private _operatorApprovals;
712 
713     constructor(string memory name_, string memory symbol_) {
714         _name = name_;
715         _symbol = symbol_;
716         _currentIndex = _startTokenId();
717     }
718 
719     /**
720      * To change the starting tokenId, please override this function.
721      */
722     function _startTokenId() internal view virtual returns (uint256) {
723         return 0;
724     }
725 
726     /**
727      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
728      */
729     function totalSupply() public view returns (uint256) {
730         // Counter underflow is impossible as _burnCounter cannot be incremented
731         // more than _currentIndex - _startTokenId() times
732         unchecked {
733             return _currentIndex - _burnCounter - _startTokenId();
734         }
735     }
736 
737     /**
738      * Returns the total amount of tokens minted in the contract.
739      */
740     function _totalMinted() internal view returns (uint256) {
741         // Counter underflow is impossible as _currentIndex does not decrement,
742         // and it is initialized to _startTokenId()
743         unchecked {
744             return _currentIndex - _startTokenId();
745         }
746     }
747 
748     /**
749      * @dev See {IERC165-supportsInterface}.
750      */
751     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
752         return
753             interfaceId == type(IERC721).interfaceId ||
754             interfaceId == type(IERC721Metadata).interfaceId ||
755             super.supportsInterface(interfaceId);
756     }
757 
758     /**
759      * @dev See {IERC721-balanceOf}.
760      */
761     function balanceOf(address owner) public view override returns (uint256) {
762         if (owner == address(0)) revert BalanceQueryForZeroAddress();
763         return uint256(_addressData[owner].balance);
764     }
765 
766     /**
767      * Returns the number of tokens minted by `owner`.
768      */
769     function _numberMinted(address owner) internal view returns (uint256) {
770         return uint256(_addressData[owner].numberMinted);
771     }
772 
773     /**
774      * Returns the number of tokens burned by or on behalf of `owner`.
775      */
776     function _numberBurned(address owner) internal view returns (uint256) {
777         return uint256(_addressData[owner].numberBurned);
778     }
779 
780     /**
781      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
782      */
783     function _getAux(address owner) internal view returns (uint64) {
784         return _addressData[owner].aux;
785     }
786 
787     /**
788      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
789      * If there are multiple variables, please pack them into a uint64.
790      */
791     function _setAux(address owner, uint64 aux) internal {
792         _addressData[owner].aux = aux;
793     }
794 
795     /**
796      * Gas spent here starts off proportional to the maximum mint batch size.
797      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
798      */
799     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
800         uint256 curr = tokenId;
801 
802         unchecked {
803             if (_startTokenId() <= curr && curr < _currentIndex) {
804                 TokenOwnership memory ownership = _ownerships[curr];
805                 if (!ownership.burned) {
806                     if (ownership.addr != address(0)) {
807                         return ownership;
808                     }
809                     // Invariant:
810                     // There will always be an ownership that has an address and is not burned
811                     // before an ownership that does not have an address and is not burned.
812                     // Hence, curr will not underflow.
813                     while (true) {
814                         curr--;
815                         ownership = _ownerships[curr];
816                         if (ownership.addr != address(0)) {
817                             return ownership;
818                         }
819                     }
820                 }
821             }
822         }
823         revert OwnerQueryForNonexistentToken();
824     }
825 
826     /**
827      * @dev See {IERC721-ownerOf}.
828      */
829     function ownerOf(uint256 tokenId) public view override returns (address) {
830         return _ownershipOf(tokenId).addr;
831     }
832 
833     /**
834      * @dev See {IERC721Metadata-name}.
835      */
836     function name() public view virtual override returns (string memory) {
837         return _name;
838     }
839 
840     /**
841      * @dev See {IERC721Metadata-symbol}.
842      */
843     function symbol() public view virtual override returns (string memory) {
844         return _symbol;
845     }
846 
847     /**
848      * @dev See {IERC721Metadata-tokenURI}.
849      */
850     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
851         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
852 
853         string memory baseURI = _baseURI();
854         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
855     }
856 
857     /**
858      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
859      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
860      * by default, can be overriden in child contracts.
861      */
862     function _baseURI() internal view virtual returns (string memory) {
863         return '';
864     }
865 
866     /**
867      * @dev See {IERC721-approve}.
868      */
869     function approve(address to, uint256 tokenId) public override {
870         address owner = ERC721A.ownerOf(tokenId);
871         if (to == owner) revert ApprovalToCurrentOwner();
872 
873         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
874             revert ApprovalCallerNotOwnerNorApproved();
875         }
876 
877         _approve(to, tokenId, owner);
878     }
879 
880     /**
881      * @dev See {IERC721-getApproved}.
882      */
883     function getApproved(uint256 tokenId) public view override returns (address) {
884         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
885 
886         return _tokenApprovals[tokenId];
887     }
888 
889     /**
890      * @dev See {IERC721-setApprovalForAll}.
891      */
892     function setApprovalForAll(address operator, bool approved) public virtual override {
893         if (operator == _msgSender()) revert ApproveToCaller();
894 
895         _operatorApprovals[_msgSender()][operator] = approved;
896         emit ApprovalForAll(_msgSender(), operator, approved);
897     }
898 
899     /**
900      * @dev See {IERC721-isApprovedForAll}.
901      */
902     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
903         return _operatorApprovals[owner][operator];
904     }
905 
906     /**
907      * @dev See {IERC721-transferFrom}.
908      */
909     function transferFrom(
910         address from,
911         address to,
912         uint256 tokenId
913     ) public virtual override {
914         _transfer(from, to, tokenId);
915     }
916 
917     /**
918      * @dev See {IERC721-safeTransferFrom}.
919      */
920     function safeTransferFrom(
921         address from,
922         address to,
923         uint256 tokenId
924     ) public virtual override {
925         safeTransferFrom(from, to, tokenId, '');
926     }
927 
928     /**
929      * @dev See {IERC721-safeTransferFrom}.
930      */
931     function safeTransferFrom(
932         address from,
933         address to,
934         uint256 tokenId,
935         bytes memory _data
936     ) public virtual override {
937         _transfer(from, to, tokenId);
938         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
939             revert TransferToNonERC721ReceiverImplementer();
940         }
941     }
942 
943     /**
944      * @dev Returns whether `tokenId` exists.
945      *
946      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
947      *
948      * Tokens start existing when they are minted (`_mint`),
949      */
950     function _exists(uint256 tokenId) internal view returns (bool) {
951         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
952             !_ownerships[tokenId].burned;
953     }
954 
955     function _safeMint(address to, uint256 quantity) internal {
956         _safeMint(to, quantity, '');
957     }
958 
959     /**
960      * @dev Safely mints `quantity` tokens and transfers them to `to`.
961      *
962      * Requirements:
963      *
964      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
965      * - `quantity` must be greater than 0.
966      *
967      * Emits a {Transfer} event.
968      */
969     function _safeMint(
970         address to,
971         uint256 quantity,
972         bytes memory _data
973     ) internal {
974         _mint(to, quantity, _data, true);
975     }
976 
977     /**
978      * @dev Mints `quantity` tokens and transfers them to `to`.
979      *
980      * Requirements:
981      *
982      * - `to` cannot be the zero address.
983      * - `quantity` must be greater than 0.
984      *
985      * Emits a {Transfer} event.
986      */
987     function _mint(
988         address to,
989         uint256 quantity,
990         bytes memory _data,
991         bool safe
992     ) internal {
993         uint256 startTokenId = _currentIndex;
994         if (to == address(0)) revert MintToZeroAddress();
995         if (quantity == 0) revert MintZeroQuantity();
996 
997         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
998 
999         // Overflows are incredibly unrealistic.
1000         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1001         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1002         unchecked {
1003             _addressData[to].balance += uint64(quantity);
1004             _addressData[to].numberMinted += uint64(quantity);
1005 
1006             _ownerships[startTokenId].addr = to;
1007             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1008 
1009             uint256 updatedIndex = startTokenId;
1010             uint256 end = updatedIndex + quantity;
1011 
1012             if (safe && to.isContract()) {
1013                 do {
1014                     emit Transfer(address(0), to, updatedIndex);
1015                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1016                         revert TransferToNonERC721ReceiverImplementer();
1017                     }
1018                 } while (updatedIndex != end);
1019                 // Reentrancy protection
1020                 if (_currentIndex != startTokenId) revert();
1021             } else {
1022                 do {
1023                     emit Transfer(address(0), to, updatedIndex++);
1024                 } while (updatedIndex != end);
1025             }
1026             _currentIndex = updatedIndex;
1027         }
1028         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1029     }
1030 
1031     /**
1032      * @dev Transfers `tokenId` from `from` to `to`.
1033      *
1034      * Requirements:
1035      *
1036      * - `to` cannot be the zero address.
1037      * - `tokenId` token must be owned by `from`.
1038      *
1039      * Emits a {Transfer} event.
1040      */
1041     function _transfer(
1042         address from,
1043         address to,
1044         uint256 tokenId
1045     ) private {
1046         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1047 
1048         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1049 
1050         bool isApprovedOrOwner = (_msgSender() == from ||
1051             isApprovedForAll(from, _msgSender()) ||
1052             getApproved(tokenId) == _msgSender());
1053 
1054         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1055         if (to == address(0)) revert TransferToZeroAddress();
1056 
1057         _beforeTokenTransfers(from, to, tokenId, 1);
1058 
1059         // Clear approvals from the previous owner
1060         _approve(address(0), tokenId, from);
1061 
1062         // Underflow of the sender's balance is impossible because we check for
1063         // ownership above and the recipient's balance can't realistically overflow.
1064         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1065         unchecked {
1066             _addressData[from].balance -= 1;
1067             _addressData[to].balance += 1;
1068 
1069             TokenOwnership storage currSlot = _ownerships[tokenId];
1070             currSlot.addr = to;
1071             currSlot.startTimestamp = uint64(block.timestamp);
1072 
1073             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1074             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1075             uint256 nextTokenId = tokenId + 1;
1076             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1077             if (nextSlot.addr == address(0)) {
1078                 // This will suffice for checking _exists(nextTokenId),
1079                 // as a burned slot cannot contain the zero address.
1080                 if (nextTokenId != _currentIndex) {
1081                     nextSlot.addr = from;
1082                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1083                 }
1084             }
1085         }
1086 
1087         emit Transfer(from, to, tokenId);
1088         _afterTokenTransfers(from, to, tokenId, 1);
1089     }
1090 
1091     /**
1092      * @dev This is equivalent to _burn(tokenId, false)
1093      */
1094     function _burn(uint256 tokenId) internal virtual {
1095         _burn(tokenId, false);
1096     }
1097 
1098     /**
1099      * @dev Destroys `tokenId`.
1100      * The approval is cleared when the token is burned.
1101      *
1102      * Requirements:
1103      *
1104      * - `tokenId` must exist.
1105      *
1106      * Emits a {Transfer} event.
1107      */
1108     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1109         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1110 
1111         address from = prevOwnership.addr;
1112 
1113         if (approvalCheck) {
1114             bool isApprovedOrOwner = (_msgSender() == from ||
1115                 isApprovedForAll(from, _msgSender()) ||
1116                 getApproved(tokenId) == _msgSender());
1117 
1118             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1119         }
1120 
1121         _beforeTokenTransfers(from, address(0), tokenId, 1);
1122 
1123         // Clear approvals from the previous owner
1124         _approve(address(0), tokenId, from);
1125 
1126         // Underflow of the sender's balance is impossible because we check for
1127         // ownership above and the recipient's balance can't realistically overflow.
1128         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1129         unchecked {
1130             AddressData storage addressData = _addressData[from];
1131             addressData.balance -= 1;
1132             addressData.numberBurned += 1;
1133 
1134             // Keep track of who burned the token, and the timestamp of burning.
1135             TokenOwnership storage currSlot = _ownerships[tokenId];
1136             currSlot.addr = from;
1137             currSlot.startTimestamp = uint64(block.timestamp);
1138             currSlot.burned = true;
1139 
1140             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1141             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1142             uint256 nextTokenId = tokenId + 1;
1143             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1144             if (nextSlot.addr == address(0)) {
1145                 // This will suffice for checking _exists(nextTokenId),
1146                 // as a burned slot cannot contain the zero address.
1147                 if (nextTokenId != _currentIndex) {
1148                     nextSlot.addr = from;
1149                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1150                 }
1151             }
1152         }
1153 
1154         emit Transfer(from, address(0), tokenId);
1155         _afterTokenTransfers(from, address(0), tokenId, 1);
1156 
1157         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1158         unchecked {
1159             _burnCounter++;
1160         }
1161     }
1162 
1163     /**
1164      * @dev Approve `to` to operate on `tokenId`
1165      *
1166      * Emits a {Approval} event.
1167      */
1168     function _approve(
1169         address to,
1170         uint256 tokenId,
1171         address owner
1172     ) private {
1173         _tokenApprovals[tokenId] = to;
1174         emit Approval(owner, to, tokenId);
1175     }
1176 
1177     /**
1178      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1179      *
1180      * @param from address representing the previous owner of the given token ID
1181      * @param to target address that will receive the tokens
1182      * @param tokenId uint256 ID of the token to be transferred
1183      * @param _data bytes optional data to send along with the call
1184      * @return bool whether the call correctly returned the expected magic value
1185      */
1186     function _checkContractOnERC721Received(
1187         address from,
1188         address to,
1189         uint256 tokenId,
1190         bytes memory _data
1191     ) private returns (bool) {
1192         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1193             return retval == IERC721Receiver(to).onERC721Received.selector;
1194         } catch (bytes memory reason) {
1195             if (reason.length == 0) {
1196                 revert TransferToNonERC721ReceiverImplementer();
1197             } else {
1198                 assembly {
1199                     revert(add(32, reason), mload(reason))
1200                 }
1201             }
1202         }
1203     }
1204 
1205     /**
1206      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1207      * And also called before burning one token.
1208      *
1209      * startTokenId - the first token id to be transferred
1210      * quantity - the amount to be transferred
1211      *
1212      * Calling conditions:
1213      *
1214      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1215      * transferred to `to`.
1216      * - When `from` is zero, `tokenId` will be minted for `to`.
1217      * - When `to` is zero, `tokenId` will be burned by `from`.
1218      * - `from` and `to` are never both zero.
1219      */
1220     function _beforeTokenTransfers(
1221         address from,
1222         address to,
1223         uint256 startTokenId,
1224         uint256 quantity
1225     ) internal virtual {}
1226 
1227     /**
1228      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1229      * minting.
1230      * And also called after one token has been burned.
1231      *
1232      * startTokenId - the first token id to be transferred
1233      * quantity - the amount to be transferred
1234      *
1235      * Calling conditions:
1236      *
1237      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1238      * transferred to `to`.
1239      * - When `from` is zero, `tokenId` has been minted for `to`.
1240      * - When `to` is zero, `tokenId` has been burned by `from`.
1241      * - `from` and `to` are never both zero.
1242      */
1243     function _afterTokenTransfers(
1244         address from,
1245         address to,
1246         uint256 startTokenId,
1247         uint256 quantity
1248     ) internal virtual {}
1249 }
1250 
1251 abstract contract Ownable is Context {
1252     address private _owner;
1253 
1254     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1255 
1256     /**
1257      * @dev Initializes the contract setting the deployer as the initial owner.
1258      */
1259     constructor() {
1260         _transferOwnership(_msgSender());
1261     }
1262 
1263     /**
1264      * @dev Returns the address of the current owner.
1265      */
1266     function owner() public view virtual returns (address) {
1267         return _owner;
1268     }
1269 
1270     /**
1271      * @dev Throws if called by any account other than the owner.
1272      */
1273     modifier onlyOwner() {
1274         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1275         _;
1276     }
1277 
1278     /**
1279      * @dev Leaves the contract without owner. It will not be possible to call
1280      * `onlyOwner` functions anymore. Can only be called by the current owner.
1281      *
1282      * NOTE: Renouncing ownership will leave the contract without an owner,
1283      * thereby removing any functionality that is only available to the owner.
1284      */
1285     function renounceOwnership() public virtual onlyOwner {
1286         _transferOwnership(address(0));
1287     }
1288 
1289     /**
1290      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1291      * Can only be called by the current owner.
1292      */
1293     function transferOwnership(address newOwner) public virtual onlyOwner {
1294         require(newOwner != address(0), "Ownable: new owner is the zero address");
1295         _transferOwnership(newOwner);
1296     }
1297 
1298     /**
1299      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1300      * Internal function without access restriction.
1301      */
1302     function _transferOwnership(address newOwner) internal virtual {
1303         address oldOwner = _owner;
1304         _owner = newOwner;
1305         emit OwnershipTransferred(oldOwner, newOwner);
1306     }
1307 }
1308 pragma solidity ^0.8.13;
1309 
1310 interface IOperatorFilterRegistry {
1311     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1312     function register(address registrant) external;
1313     function registerAndSubscribe(address registrant, address subscription) external;
1314     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1315     function updateOperator(address registrant, address operator, bool filtered) external;
1316     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1317     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1318     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1319     function subscribe(address registrant, address registrantToSubscribe) external;
1320     function unsubscribe(address registrant, bool copyExistingEntries) external;
1321     function subscriptionOf(address addr) external returns (address registrant);
1322     function subscribers(address registrant) external returns (address[] memory);
1323     function subscriberAt(address registrant, uint256 index) external returns (address);
1324     function copyEntriesOf(address registrant, address registrantToCopy) external;
1325     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1326     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1327     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1328     function filteredOperators(address addr) external returns (address[] memory);
1329     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1330     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1331     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1332     function isRegistered(address addr) external returns (bool);
1333     function codeHashOf(address addr) external returns (bytes32);
1334 }
1335 pragma solidity ^0.8.13;
1336 
1337 
1338 
1339 abstract contract OperatorFilterer {
1340     error OperatorNotAllowed(address operator);
1341 
1342     IOperatorFilterRegistry constant operatorFilterRegistry =
1343         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1344 
1345     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1346         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1347         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1348         // order for the modifier to filter addresses.
1349         if (address(operatorFilterRegistry).code.length > 0) {
1350             if (subscribe) {
1351                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1352             } else {
1353                 if (subscriptionOrRegistrantToCopy != address(0)) {
1354                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1355                 } else {
1356                     operatorFilterRegistry.register(address(this));
1357                 }
1358             }
1359         }
1360     }
1361 
1362     modifier onlyAllowedOperator(address from) virtual {
1363         // Check registry code length to facilitate testing in environments without a deployed registry.
1364         if (address(operatorFilterRegistry).code.length > 0) {
1365             // Allow spending tokens from addresses with balance
1366             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1367             // from an EOA.
1368             if (from == msg.sender) {
1369                 _;
1370                 return;
1371             }
1372             if (
1373                 !(
1374                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1375                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1376                 )
1377             ) {
1378                 revert OperatorNotAllowed(msg.sender);
1379             }
1380         }
1381         _;
1382     }
1383 }
1384 pragma solidity ^0.8.13;
1385 
1386 
1387 
1388 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1389     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1390 
1391     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1392 }
1393     pragma solidity ^0.8.7;
1394     
1395     contract MyFriendInTheForest is ERC721A, DefaultOperatorFilterer , Ownable {
1396     using Strings for uint256;
1397 
1398 
1399   string private uriPrefix ;
1400   string private uriSuffix = ".json";
1401   string public hiddenURL;
1402 
1403   
1404   
1405 
1406   uint256 public cost = 0.1 ether;
1407  
1408   
1409 
1410   uint16 public maxSupply = 10000;
1411   uint8 public maxMintAmountPerTx = 1;
1412     uint8 public maxFreeMintAmountPerWallet = 0;
1413                                                              
1414  
1415   bool public paused = true;
1416   bool public reveal =false;
1417 
1418    mapping (address => uint8) public NFTPerPublicAddress;
1419 
1420  
1421   
1422   
1423  
1424   
1425 
1426   constructor() ERC721A("My Friend In The Forest", "MFITF") {
1427   }
1428 
1429 
1430   
1431  
1432   function mint(uint8 _mintAmount) external payable  {
1433      uint16 totalSupply = uint16(totalSupply());
1434      uint8 nft = NFTPerPublicAddress[msg.sender];
1435     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1436     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1437 
1438     require(!paused, "The contract is paused!");
1439     
1440       if(nft >= maxFreeMintAmountPerWallet)
1441     {
1442     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1443     }
1444     else {
1445          uint8 costAmount = _mintAmount + nft;
1446         if(costAmount > maxFreeMintAmountPerWallet)
1447        {
1448         costAmount = costAmount - maxFreeMintAmountPerWallet;
1449         require(msg.value >= cost * costAmount, "Insufficient funds!");
1450        }
1451        
1452          
1453     }
1454     
1455 
1456 
1457     _safeMint(msg.sender , _mintAmount);
1458 
1459     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1460      
1461      delete totalSupply;
1462      delete _mintAmount;
1463   }
1464   
1465   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1466      uint16 totalSupply = uint16(totalSupply());
1467     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1468      _safeMint(_receiver , _mintAmount);
1469      delete _mintAmount;
1470      delete _receiver;
1471      delete totalSupply;
1472   }
1473 
1474   function  Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1475      uint16 totalSupply = uint16(totalSupply());
1476      uint totalAmount =   _amountPerAddress * addresses.length;
1477     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
1478      for (uint256 i = 0; i < addresses.length; i++) {
1479             _safeMint(addresses[i], _amountPerAddress);
1480         }
1481 
1482      delete _amountPerAddress;
1483      delete totalSupply;
1484   }
1485 
1486  
1487 
1488   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1489       maxSupply = _maxSupply;
1490   }
1491 
1492 
1493 
1494    
1495   function tokenURI(uint256 _tokenId)
1496     public
1497     view
1498     virtual
1499     override
1500     returns (string memory)
1501   {
1502     require(
1503       _exists(_tokenId),
1504       "ERC721Metadata: URI query for nonexistent token"
1505     );
1506     
1507   
1508 if ( reveal == false)
1509 {
1510     return hiddenURL;
1511 }
1512     
1513 
1514     string memory currentBaseURI = _baseURI();
1515     return bytes(currentBaseURI).length > 0
1516         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1517         : "";
1518   }
1519  
1520  
1521 
1522 
1523  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1524     maxFreeMintAmountPerWallet = _limit;
1525    delete _limit;
1526 
1527 }
1528 
1529     
1530   
1531 
1532   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1533     uriPrefix = _uriPrefix;
1534   }
1535    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1536     hiddenURL = _uriPrefix;
1537   }
1538 
1539 
1540   function setPaused() external onlyOwner {
1541     paused = !paused;
1542    
1543   }
1544 
1545   function setCost(uint _cost) external onlyOwner{
1546       cost = _cost;
1547 
1548   }
1549 
1550  function setRevealed() external onlyOwner{
1551      reveal = !reveal;
1552  }
1553 
1554   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1555       maxMintAmountPerTx = _maxtx;
1556 
1557   }
1558 
1559  
1560 
1561   function withdraw() external onlyOwner {
1562   uint _balance = address(this).balance;
1563      payable(msg.sender).transfer(_balance ); 
1564        
1565   }
1566 
1567 
1568   function _baseURI() internal view  override returns (string memory) {
1569     return uriPrefix;
1570   }
1571 
1572     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1573         super.transferFrom(from, to, tokenId);
1574     }
1575 
1576     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1577         super.safeTransferFrom(from, to, tokenId);
1578     }
1579 
1580     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1581         public
1582         override
1583         onlyAllowedOperator(from)
1584     {
1585         super.safeTransferFrom(from, to, tokenId, data);
1586     }
1587 }