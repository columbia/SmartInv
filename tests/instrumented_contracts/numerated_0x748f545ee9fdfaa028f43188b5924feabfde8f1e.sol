1 /**⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
2 
3           _____                    _____                    _____                                   
4          /\    \                  /\    \                  /\    \                                  
5         /::\    \                /::\    \                /::\    \                                 
6        /::::\    \              /::::\    \              /::::\    \                                
7       /::::::\    \            /::::::\    \            /::::::\    \                               
8      /:::/\:::\    \          /:::/\:::\    \          /:::/\:::\    \                              
9     /:::/  \:::\    \        /:::/__\:::\    \        /:::/  \:::\    \                             
10    /:::/    \:::\    \      /::::\   \:::\    \      /:::/    \:::\    \                            
11   /:::/    / \:::\    \    /::::::\   \:::\    \    /:::/    / \:::\    \                           
12  /:::/    /   \:::\ ___\  /:::/\:::\   \:::\    \  /:::/    /   \:::\ ___\                          
13 /:::/____/     \:::|    |/:::/  \:::\   \:::\____\/:::/____/     \:::|    |                         
14 \:::\    \     /:::|____|\::/    \:::\  /:::/    /\:::\    \     /:::|____|                         
15  \:::\    \   /:::/    /  \/____/ \:::\/:::/    /  \:::\    \   /:::/    /                          
16   \:::\    \ /:::/    /            \::::::/    /    \:::\    \ /:::/    /                           
17    \:::\    /:::/    /              \::::/    /      \:::\    /:::/    /                            
18     \:::\  /:::/    /               /:::/    /        \:::\  /:::/    /                             
19      \:::\/:::/    /               /:::/    /          \:::\/:::/    /                              
20       \::::::/    /               /:::/    /            \::::::/    /                               
21        \::::/    /               /:::/    /              \::::/    /                                
22         \::/____/                \::/    /                \::/____/                                 
23          ~~                       \/____/                  ~~                                       
24                                                                                                     
25           _____                   _______                   _____                    _____          
26          /\    \                 /::\    \                 /\    \                  /\    \         
27         /::\    \               /::::\    \               /::\    \                /::\    \        
28        /::::\    \             /::::::\    \             /::::\    \              /::::\    \       
29       /::::::\    \           /::::::::\    \           /::::::\    \            /::::::\    \      
30      /:::/\:::\    \         /:::/~~\:::\    \         /:::/\:::\    \          /:::/\:::\    \     
31     /:::/  \:::\    \       /:::/    \:::\    \       /:::/  \:::\    \        /:::/__\:::\    \    
32    /:::/    \:::\    \     /:::/    / \:::\    \     /:::/    \:::\    \       \:::\   \:::\    \   
33   /:::/    / \:::\    \   /:::/____/   \:::\____\   /:::/    / \:::\    \    ___\:::\   \:::\    \  
34  /:::/    /   \:::\ ___\ |:::|    |     |:::|    | /:::/    /   \:::\ ___\  /\   \:::\   \:::\    \ 
35 /:::/____/  ___\:::|    ||:::|____|     |:::|    |/:::/____/     \:::|    |/::\   \:::\   \:::\____\
36 \:::\    \ /\  /:::|____| \:::\    \   /:::/    / \:::\    \     /:::|____|\:::\   \:::\   \::/    /
37  \:::\    /::\ \::/    /   \:::\    \ /:::/    /   \:::\    \   /:::/    /  \:::\   \:::\   \/____/ 
38   \:::\   \:::\ \/____/     \:::\    /:::/    /     \:::\    \ /:::/    /    \:::\   \:::\    \     
39    \:::\   \:::\____\        \:::\__/:::/    /       \:::\    /:::/    /      \:::\   \:::\____\    
40     \:::\  /:::/    /         \::::::::/    /         \:::\  /:::/    /        \:::\  /:::/    /    
41      \:::\/:::/    /           \::::::/    /           \:::\/:::/    /          \:::\/:::/    /     
42       \::::::/    /             \::::/    /             \::::::/    /            \::::::/    /      
43        \::::/    /               \::/____/               \::::/    /              \::::/    /       
44         \::/____/                 ~~                      \::/____/                \::/    /        
45                                                            ~~                       \/____/         
46                                                                                                     
47 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
48  */
49 // SPDX-License-Identifier: MIT
50 //Developer Info:
51 
52 
53 
54 // File: @openzeppelin/contracts/utils/Strings.sol
55 
56 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
57 
58 pragma solidity ^0.8.0;
59 
60 /**
61  * @dev String operations.
62  */
63 library Strings {
64     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
65 
66     /**
67      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
68      */
69     function toString(uint256 value) internal pure returns (string memory) {
70         // Inspired by OraclizeAPI's implementation - MIT licence
71         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
72 
73         if (value == 0) {
74             return "0";
75         }
76         uint256 temp = value;
77         uint256 digits;
78         while (temp != 0) {
79             digits++;
80             temp /= 10;
81         }
82         bytes memory buffer = new bytes(digits);
83         while (value != 0) {
84             digits -= 1;
85             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
86             value /= 10;
87         }
88         return string(buffer);
89     }
90 
91     /**
92      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
93      */
94     function toHexString(uint256 value) internal pure returns (string memory) {
95         if (value == 0) {
96             return "0x00";
97         }
98         uint256 temp = value;
99         uint256 length = 0;
100         while (temp != 0) {
101             length++;
102             temp >>= 8;
103         }
104         return toHexString(value, length);
105     }
106 
107     /**
108      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
109      */
110     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
111         bytes memory buffer = new bytes(2 * length + 2);
112         buffer[0] = "0";
113         buffer[1] = "x";
114         for (uint256 i = 2 * length + 1; i > 1; --i) {
115             buffer[i] = _HEX_SYMBOLS[value & 0xf];
116             value >>= 4;
117         }
118         require(value == 0, "Strings: hex length insufficient");
119         return string(buffer);
120     }
121 }
122 
123 // File: @openzeppelin/contracts/utils/Context.sol
124 
125 
126 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
127 
128 pragma solidity ^0.8.0;
129 
130 /**
131  * @dev Provides information about the current execution context, including the
132  * sender of the transaction and its data. While these are generally available
133  * via msg.sender and msg.data, they should not be accessed in such a direct
134  * manner, since when dealing with meta-transactions the account sending and
135  * paying for execution may not be the actual sender (as far as an application
136  * is concerned).
137  *
138  * This contract is only required for intermediate, library-like contracts.
139  */
140 abstract contract Context {
141     function _msgSender() internal view virtual returns (address) {
142         return msg.sender;
143     }
144 
145     function _msgData() internal view virtual returns (bytes calldata) {
146         return msg.data;
147     }
148 }
149 
150 // File: @openzeppelin/contracts/utils/Address.sol
151 
152 
153 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
154 
155 pragma solidity ^0.8.1;
156 
157 /**
158  * @dev Collection of functions related to the address type
159  */
160 library Address {
161     /**
162      * @dev Returns true if `account` is a contract.
163      *
164      * [IMPORTANT]
165      * ====
166      * It is unsafe to assume that an address for which this function returns
167      * false is an externally-owned account (EOA) and not a contract.
168      *
169      * Among others, `isContract` will return false for the following
170      * types of addresses:
171      *
172      *  - an externally-owned account
173      *  - a contract in construction
174      *  - an address where a contract will be created
175      *  - an address where a contract lived, but was destroyed
176      * ====
177      *
178      * [IMPORTANT]
179      * ====
180      * You shouldn't rely on `isContract` to protect against flash loan attacks!
181      *
182      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
183      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
184      * constructor.
185      * ====
186      */
187     function isContract(address account) internal view returns (bool) {
188         // This method relies on extcodesize/address.code.length, which returns 0
189         // for contracts in construction, since the code is only stored at the end
190         // of the constructor execution.
191 
192         return account.code.length > 0;
193     }
194 
195     /**
196      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
197      * `recipient`, forwarding all available gas and reverting on errors.
198      *
199      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
200      * of certain opcodes, possibly making contracts go over the 2300 gas limit
201      * imposed by `transfer`, making them unable to receive funds via
202      * `transfer`. {sendValue} removes this limitation.
203      *
204      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
205      *
206      * IMPORTANT: because control is transferred to `recipient`, care must be
207      * taken to not create reentrancy vulnerabilities. Consider using
208      * {ReentrancyGuard} or the
209      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
210      */
211     function sendValue(address payable recipient, uint256 amount) internal {
212         require(address(this).balance >= amount, "Address: insufficient balance");
213 
214         (bool success, ) = recipient.call{value: amount}("");
215         require(success, "Address: unable to send value, recipient may have reverted");
216     }
217 
218     /**
219      * @dev Performs a Solidity function call using a low level `call`. A
220      * plain `call` is an unsafe replacement for a function call: use this
221      * function instead.
222      *
223      * If `target` reverts with a revert reason, it is bubbled up by this
224      * function (like regular Solidity function calls).
225      *
226      * Returns the raw returned data. To convert to the expected return value,
227      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
228      *
229      * Requirements:
230      *
231      * - `target` must be a contract.
232      * - calling `target` with `data` must not revert.
233      *
234      * _Available since v3.1._
235      */
236     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
237         return functionCall(target, data, "Address: low-level call failed");
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
242      * `errorMessage` as a fallback revert reason when `target` reverts.
243      *
244      * _Available since v3.1._
245      */
246     function functionCall(
247         address target,
248         bytes memory data,
249         string memory errorMessage
250     ) internal returns (bytes memory) {
251         return functionCallWithValue(target, data, 0, errorMessage);
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
256      * but also transferring `value` wei to `target`.
257      *
258      * Requirements:
259      *
260      * - the calling contract must have an ETH balance of at least `value`.
261      * - the called Solidity function must be `payable`.
262      *
263      * _Available since v3.1._
264      */
265     function functionCallWithValue(
266         address target,
267         bytes memory data,
268         uint256 value
269     ) internal returns (bytes memory) {
270         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
271     }
272 
273     /**
274      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
275      * with `errorMessage` as a fallback revert reason when `target` reverts.
276      *
277      * _Available since v3.1._
278      */
279     function functionCallWithValue(
280         address target,
281         bytes memory data,
282         uint256 value,
283         string memory errorMessage
284     ) internal returns (bytes memory) {
285         require(address(this).balance >= value, "Address: insufficient balance for call");
286         require(isContract(target), "Address: call to non-contract");
287 
288         (bool success, bytes memory returndata) = target.call{value: value}(data);
289         return verifyCallResult(success, returndata, errorMessage);
290     }
291 
292     /**
293      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
294      * but performing a static call.
295      *
296      * _Available since v3.3._
297      */
298     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
299         return functionStaticCall(target, data, "Address: low-level static call failed");
300     }
301 
302     /**
303      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
304      * but performing a static call.
305      *
306      * _Available since v3.3._
307      */
308     function functionStaticCall(
309         address target,
310         bytes memory data,
311         string memory errorMessage
312     ) internal view returns (bytes memory) {
313         require(isContract(target), "Address: static call to non-contract");
314 
315         (bool success, bytes memory returndata) = target.staticcall(data);
316         return verifyCallResult(success, returndata, errorMessage);
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
321      * but performing a delegate call.
322      *
323      * _Available since v3.4._
324      */
325     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
326         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
331      * but performing a delegate call.
332      *
333      * _Available since v3.4._
334      */
335     function functionDelegateCall(
336         address target,
337         bytes memory data,
338         string memory errorMessage
339     ) internal returns (bytes memory) {
340         require(isContract(target), "Address: delegate call to non-contract");
341 
342         (bool success, bytes memory returndata) = target.delegatecall(data);
343         return verifyCallResult(success, returndata, errorMessage);
344     }
345 
346     /**
347      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
348      * revert reason using the provided one.
349      *
350      * _Available since v4.3._
351      */
352     function verifyCallResult(
353         bool success,
354         bytes memory returndata,
355         string memory errorMessage
356     ) internal pure returns (bytes memory) {
357         if (success) {
358             return returndata;
359         } else {
360             // Look for revert reason and bubble it up if present
361             if (returndata.length > 0) {
362                 // The easiest way to bubble the revert reason is using memory via assembly
363 
364                 assembly {
365                     let returndata_size := mload(returndata)
366                     revert(add(32, returndata), returndata_size)
367                 }
368             } else {
369                 revert(errorMessage);
370             }
371         }
372     }
373 }
374 
375 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
376 
377 
378 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
379 
380 pragma solidity ^0.8.0;
381 
382 /**
383  * @title ERC721 token receiver interface
384  * @dev Interface for any contract that wants to support safeTransfers
385  * from ERC721 asset contracts.
386  */
387 interface IERC721Receiver {
388     /**
389      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
390      * by `operator` from `from`, this function is called.
391      *
392      * It must return its Solidity selector to confirm the token transfer.
393      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
394      *
395      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
396      */
397     function onERC721Received(
398         address operator,
399         address from,
400         uint256 tokenId,
401         bytes calldata data
402     ) external returns (bytes4);
403 }
404 
405 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
406 
407 
408 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
409 
410 pragma solidity ^0.8.0;
411 
412 /**
413  * @dev Interface of the ERC165 standard, as defined in the
414  * https://eips.ethereum.org/EIPS/eip-165[EIP].
415  *
416  * Implementers can declare support of contract interfaces, which can then be
417  * queried by others ({ERC165Checker}).
418  *
419  * For an implementation, see {ERC165}.
420  */
421 interface IERC165 {
422     /**
423      * @dev Returns true if this contract implements the interface defined by
424      * `interfaceId`. See the corresponding
425      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
426      * to learn more about how these ids are created.
427      *
428      * This function call must use less than 30 000 gas.
429      */
430     function supportsInterface(bytes4 interfaceId) external view returns (bool);
431 }
432 
433 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
434 
435 
436 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
437 
438 pragma solidity ^0.8.0;
439 
440 
441 /**
442  * @dev Implementation of the {IERC165} interface.
443  *
444  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
445  * for the additional interface id that will be supported. For example:
446  *
447  * ```solidity
448  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
449  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
450  * }
451  * ```
452  *
453  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
454  */
455 abstract contract ERC165 is IERC165 {
456     /**
457      * @dev See {IERC165-supportsInterface}.
458      */
459     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
460         return interfaceId == type(IERC165).interfaceId;
461     }
462 }
463 
464 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
465 
466 
467 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
468 
469 pragma solidity ^0.8.0;
470 
471 
472 /**
473  * @dev Required interface of an ERC721 compliant contract.
474  */
475 interface IERC721 is IERC165 {
476     /**
477      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
478      */
479     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
480 
481     /**
482      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
483      */
484     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
485 
486     /**
487      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
488      */
489     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
490 
491     /**
492      * @dev Returns the number of tokens in ``owner``'s account.
493      */
494     function balanceOf(address owner) external view returns (uint256 balance);
495 
496     /**
497      * @dev Returns the owner of the `tokenId` token.
498      *
499      * Requirements:
500      *
501      * - `tokenId` must exist.
502      */
503     function ownerOf(uint256 tokenId) external view returns (address owner);
504 
505     /**
506      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
507      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
508      *
509      * Requirements:
510      *
511      * - `from` cannot be the zero address.
512      * - `to` cannot be the zero address.
513      * - `tokenId` token must exist and be owned by `from`.
514      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
515      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
516      *
517      * Emits a {Transfer} event.
518      */
519     function safeTransferFrom(
520         address from,
521         address to,
522         uint256 tokenId
523     ) external;
524 
525     /**
526      * @dev Transfers `tokenId` token from `from` to `to`.
527      *
528      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
529      *
530      * Requirements:
531      *
532      * - `from` cannot be the zero address.
533      * - `to` cannot be the zero address.
534      * - `tokenId` token must be owned by `from`.
535      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
536      *
537      * Emits a {Transfer} event.
538      */
539     function transferFrom(
540         address from,
541         address to,
542         uint256 tokenId
543     ) external;
544 
545     /**
546      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
547      * The approval is cleared when the token is transferred.
548      *
549      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
550      *
551      * Requirements:
552      *
553      * - The caller must own the token or be an approved operator.
554      * - `tokenId` must exist.
555      *
556      * Emits an {Approval} event.
557      */
558     function approve(address to, uint256 tokenId) external;
559 
560     /**
561      * @dev Returns the account approved for `tokenId` token.
562      *
563      * Requirements:
564      *
565      * - `tokenId` must exist.
566      */
567     function getApproved(uint256 tokenId) external view returns (address operator);
568 
569     /**
570      * @dev Approve or remove `operator` as an operator for the caller.
571      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
572      *
573      * Requirements:
574      *
575      * - The `operator` cannot be the caller.
576      *
577      * Emits an {ApprovalForAll} event.
578      */
579     function setApprovalForAll(address operator, bool _approved) external;
580 
581     /**
582      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
583      *
584      * See {setApprovalForAll}
585      */
586     function isApprovedForAll(address owner, address operator) external view returns (bool);
587 
588     /**
589      * @dev Safely transfers `tokenId` token from `from` to `to`.
590      *
591      * Requirements:
592      *
593      * - `from` cannot be the zero address.
594      * - `to` cannot be the zero address.
595      * - `tokenId` token must exist and be owned by `from`.
596      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
597      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
598      *
599      * Emits a {Transfer} event.
600      */
601     function safeTransferFrom(
602         address from,
603         address to,
604         uint256 tokenId,
605         bytes calldata data
606     ) external;
607 }
608 
609 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
610 
611 
612 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
613 
614 pragma solidity ^0.8.0;
615 
616 
617 /**
618  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
619  * @dev See https://eips.ethereum.org/EIPS/eip-721
620  */
621 interface IERC721Metadata is IERC721 {
622     /**
623      * @dev Returns the token collection name.
624      */
625     function name() external view returns (string memory);
626 
627     /**
628      * @dev Returns the token collection symbol.
629      */
630     function symbol() external view returns (string memory);
631 
632     /**
633      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
634      */
635     function tokenURI(uint256 tokenId) external view returns (string memory);
636 }
637 
638 // File: contracts/new.sol
639 
640 
641 
642 
643 pragma solidity ^0.8.4;
644 
645 
646 
647 
648 
649 
650 
651 
652 error ApprovalCallerNotOwnerNorApproved();
653 error ApprovalQueryForNonexistentToken();
654 error ApproveToCaller();
655 error ApprovalToCurrentOwner();
656 error BalanceQueryForZeroAddress();
657 error MintToZeroAddress();
658 error MintZeroQuantity();
659 error OwnerQueryForNonexistentToken();
660 error TransferCallerNotOwnerNorApproved();
661 error TransferFromIncorrectOwner();
662 error TransferToNonERC721ReceiverImplementer();
663 error TransferToZeroAddress();
664 error URIQueryForNonexistentToken();
665 
666 /**
667  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
668  * the Metadata extension. Built to optimize for lower gas during batch mints.
669  *
670  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
671  *
672  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
673  *
674  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
675  */
676 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
677     using Address for address;
678     using Strings for uint256;
679 
680     // Compiler will pack this into a single 256bit word.
681     struct TokenOwnership {
682         // The address of the owner.
683         address addr;
684         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
685         uint64 startTimestamp;
686         // Whether the token has been burned.
687         bool burned;
688     }
689 
690     // Compiler will pack this into a single 256bit word.
691     struct AddressData {
692         // Realistically, 2**64-1 is more than enough.
693         uint64 balance;
694         // Keeps track of mint count with minimal overhead for tokenomics.
695         uint64 numberMinted;
696         // Keeps track of burn count with minimal overhead for tokenomics.
697         uint64 numberBurned;
698         // For miscellaneous variable(s) pertaining to the address
699         // (e.g. number of whitelist mint slots used).
700         // If there are multiple variables, please pack them into a uint64.
701         uint64 aux;
702     }
703 
704     // The tokenId of the next token to be minted.
705     uint256 internal _currentIndex;
706 
707     // The number of tokens burned.
708     uint256 internal _burnCounter;
709 
710     // Token name
711     string private _name;
712 
713     // Token symbol
714     string private _symbol;
715 
716     // Mapping from token ID to ownership details
717     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
718     mapping(uint256 => TokenOwnership) internal _ownerships;
719 
720     // Mapping owner address to address data
721     mapping(address => AddressData) private _addressData;
722 
723     // Mapping from token ID to approved address
724     mapping(uint256 => address) private _tokenApprovals;
725 
726     // Mapping from owner to operator approvals
727     mapping(address => mapping(address => bool)) private _operatorApprovals;
728 
729     constructor(string memory name_, string memory symbol_) {
730         _name = name_;
731         _symbol = symbol_;
732         _currentIndex = _startTokenId();
733     }
734 
735     /**
736      * To change the starting tokenId, please override this function.
737      */
738     function _startTokenId() internal view virtual returns (uint256) {
739         return 0;
740     }
741 
742     /**
743      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
744      */
745     function totalSupply() public view returns (uint256) {
746         // Counter underflow is impossible as _burnCounter cannot be incremented
747         // more than _currentIndex - _startTokenId() times
748         unchecked {
749             return _currentIndex - _burnCounter - _startTokenId();
750         }
751     }
752 
753     /**
754      * Returns the total amount of tokens minted in the contract.
755      */
756     function _totalMinted() internal view returns (uint256) {
757         // Counter underflow is impossible as _currentIndex does not decrement,
758         // and it is initialized to _startTokenId()
759         unchecked {
760             return _currentIndex - _startTokenId();
761         }
762     }
763 
764     /**
765      * @dev See {IERC165-supportsInterface}.
766      */
767     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
768         return
769             interfaceId == type(IERC721).interfaceId ||
770             interfaceId == type(IERC721Metadata).interfaceId ||
771             super.supportsInterface(interfaceId);
772     }
773 
774     /**
775      * @dev See {IERC721-balanceOf}.
776      */
777     function balanceOf(address owner) public view override returns (uint256) {
778         if (owner == address(0)) revert BalanceQueryForZeroAddress();
779         return uint256(_addressData[owner].balance);
780     }
781 
782     /**
783      * Returns the number of tokens minted by `owner`.
784      */
785     function _numberMinted(address owner) internal view returns (uint256) {
786         return uint256(_addressData[owner].numberMinted);
787     }
788 
789     /**
790      * Returns the number of tokens burned by or on behalf of `owner`.
791      */
792     function _numberBurned(address owner) internal view returns (uint256) {
793         return uint256(_addressData[owner].numberBurned);
794     }
795 
796     /**
797      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
798      */
799     function _getAux(address owner) internal view returns (uint64) {
800         return _addressData[owner].aux;
801     }
802 
803     /**
804      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
805      * If there are multiple variables, please pack them into a uint64.
806      */
807     function _setAux(address owner, uint64 aux) internal {
808         _addressData[owner].aux = aux;
809     }
810 
811     /**
812      * Gas spent here starts off proportional to the maximum mint batch size.
813      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
814      */
815     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
816         uint256 curr = tokenId;
817 
818         unchecked {
819             if (_startTokenId() <= curr && curr < _currentIndex) {
820                 TokenOwnership memory ownership = _ownerships[curr];
821                 if (!ownership.burned) {
822                     if (ownership.addr != address(0)) {
823                         return ownership;
824                     }
825                     // Invariant:
826                     // There will always be an ownership that has an address and is not burned
827                     // before an ownership that does not have an address and is not burned.
828                     // Hence, curr will not underflow.
829                     while (true) {
830                         curr--;
831                         ownership = _ownerships[curr];
832                         if (ownership.addr != address(0)) {
833                             return ownership;
834                         }
835                     }
836                 }
837             }
838         }
839         revert OwnerQueryForNonexistentToken();
840     }
841 
842     /**
843      * @dev See {IERC721-ownerOf}.
844      */
845     function ownerOf(uint256 tokenId) public view override returns (address) {
846         return _ownershipOf(tokenId).addr;
847     }
848 
849     /**
850      * @dev See {IERC721Metadata-name}.
851      */
852     function name() public view virtual override returns (string memory) {
853         return _name;
854     }
855 
856     /**
857      * @dev See {IERC721Metadata-symbol}.
858      */
859     function symbol() public view virtual override returns (string memory) {
860         return _symbol;
861     }
862 
863     /**
864      * @dev See {IERC721Metadata-tokenURI}.
865      */
866     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
867         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
868 
869         string memory baseURI = _baseURI();
870         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
871     }
872 
873     /**
874      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
875      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
876      * by default, can be overriden in child contracts.
877      */
878     function _baseURI() internal view virtual returns (string memory) {
879         return '';
880     }
881 
882     /**
883      * @dev See {IERC721-approve}.
884      */
885     function approve(address to, uint256 tokenId) public override {
886         address owner = ERC721A.ownerOf(tokenId);
887         if (to == owner) revert ApprovalToCurrentOwner();
888 
889         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
890             revert ApprovalCallerNotOwnerNorApproved();
891         }
892 
893         _approve(to, tokenId, owner);
894     }
895 
896     /**
897      * @dev See {IERC721-getApproved}.
898      */
899     function getApproved(uint256 tokenId) public view override returns (address) {
900         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
901 
902         return _tokenApprovals[tokenId];
903     }
904 
905     /**
906      * @dev See {IERC721-setApprovalForAll}.
907      */
908     function setApprovalForAll(address operator, bool approved) public virtual override {
909         if (operator == _msgSender()) revert ApproveToCaller();
910 
911         _operatorApprovals[_msgSender()][operator] = approved;
912         emit ApprovalForAll(_msgSender(), operator, approved);
913     }
914 
915     /**
916      * @dev See {IERC721-isApprovedForAll}.
917      */
918     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
919         return _operatorApprovals[owner][operator];
920     }
921 
922     /**
923      * @dev See {IERC721-transferFrom}.
924      */
925     function transferFrom(
926         address from,
927         address to,
928         uint256 tokenId
929     ) public virtual override {
930         _transfer(from, to, tokenId);
931     }
932 
933     /**
934      * @dev See {IERC721-safeTransferFrom}.
935      */
936     function safeTransferFrom(
937         address from,
938         address to,
939         uint256 tokenId
940     ) public virtual override {
941         safeTransferFrom(from, to, tokenId, '');
942     }
943 
944     /**
945      * @dev See {IERC721-safeTransferFrom}.
946      */
947     function safeTransferFrom(
948         address from,
949         address to,
950         uint256 tokenId,
951         bytes memory _data
952     ) public virtual override {
953         _transfer(from, to, tokenId);
954         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
955             revert TransferToNonERC721ReceiverImplementer();
956         }
957     }
958 
959     /**
960      * @dev Returns whether `tokenId` exists.
961      *
962      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
963      *
964      * Tokens start existing when they are minted (`_mint`),
965      */
966     function _exists(uint256 tokenId) internal view returns (bool) {
967         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
968             !_ownerships[tokenId].burned;
969     }
970 
971     function _safeMint(address to, uint256 quantity) internal {
972         _safeMint(to, quantity, '');
973     }
974 
975     /**
976      * @dev Safely mints `quantity` tokens and transfers them to `to`.
977      *
978      * Requirements:
979      *
980      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
981      * - `quantity` must be greater than 0.
982      *
983      * Emits a {Transfer} event.
984      */
985     function _safeMint(
986         address to,
987         uint256 quantity,
988         bytes memory _data
989     ) internal {
990         _mint(to, quantity, _data, true);
991     }
992 
993     /**
994      * @dev Mints `quantity` tokens and transfers them to `to`.
995      *
996      * Requirements:
997      *
998      * - `to` cannot be the zero address.
999      * - `quantity` must be greater than 0.
1000      *
1001      * Emits a {Transfer} event.
1002      */
1003     function _mint(
1004         address to,
1005         uint256 quantity,
1006         bytes memory _data,
1007         bool safe
1008     ) internal {
1009         uint256 startTokenId = _currentIndex;
1010         if (to == address(0)) revert MintToZeroAddress();
1011         if (quantity == 0) revert MintZeroQuantity();
1012 
1013         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1014 
1015         // Overflows are incredibly unrealistic.
1016         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1017         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1018         unchecked {
1019             _addressData[to].balance += uint64(quantity);
1020             _addressData[to].numberMinted += uint64(quantity);
1021 
1022             _ownerships[startTokenId].addr = to;
1023             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1024 
1025             uint256 updatedIndex = startTokenId;
1026             uint256 end = updatedIndex + quantity;
1027 
1028             if (safe && to.isContract()) {
1029                 do {
1030                     emit Transfer(address(0), to, updatedIndex);
1031                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1032                         revert TransferToNonERC721ReceiverImplementer();
1033                     }
1034                 } while (updatedIndex != end);
1035                 // Reentrancy protection
1036                 if (_currentIndex != startTokenId) revert();
1037             } else {
1038                 do {
1039                     emit Transfer(address(0), to, updatedIndex++);
1040                 } while (updatedIndex != end);
1041             }
1042             _currentIndex = updatedIndex;
1043         }
1044         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1045     }
1046 
1047     /**
1048      * @dev Transfers `tokenId` from `from` to `to`.
1049      *
1050      * Requirements:
1051      *
1052      * - `to` cannot be the zero address.
1053      * - `tokenId` token must be owned by `from`.
1054      *
1055      * Emits a {Transfer} event.
1056      */
1057     function _transfer(
1058         address from,
1059         address to,
1060         uint256 tokenId
1061     ) private {
1062         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1063 
1064         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1065 
1066         bool isApprovedOrOwner = (_msgSender() == from ||
1067             isApprovedForAll(from, _msgSender()) ||
1068             getApproved(tokenId) == _msgSender());
1069 
1070         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1071         if (to == address(0)) revert TransferToZeroAddress();
1072 
1073         _beforeTokenTransfers(from, to, tokenId, 1);
1074 
1075         // Clear approvals from the previous owner
1076         _approve(address(0), tokenId, from);
1077 
1078         // Underflow of the sender's balance is impossible because we check for
1079         // ownership above and the recipient's balance can't realistically overflow.
1080         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1081         unchecked {
1082             _addressData[from].balance -= 1;
1083             _addressData[to].balance += 1;
1084 
1085             TokenOwnership storage currSlot = _ownerships[tokenId];
1086             currSlot.addr = to;
1087             currSlot.startTimestamp = uint64(block.timestamp);
1088 
1089             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1090             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1091             uint256 nextTokenId = tokenId + 1;
1092             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1093             if (nextSlot.addr == address(0)) {
1094                 // This will suffice for checking _exists(nextTokenId),
1095                 // as a burned slot cannot contain the zero address.
1096                 if (nextTokenId != _currentIndex) {
1097                     nextSlot.addr = from;
1098                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1099                 }
1100             }
1101         }
1102 
1103         emit Transfer(from, to, tokenId);
1104         _afterTokenTransfers(from, to, tokenId, 1);
1105     }
1106 
1107     /**
1108      * @dev This is equivalent to _burn(tokenId, false)
1109      */
1110     function _burn(uint256 tokenId) internal virtual {
1111         _burn(tokenId, false);
1112     }
1113 
1114     /**
1115      * @dev Destroys `tokenId`.
1116      * The approval is cleared when the token is burned.
1117      *
1118      * Requirements:
1119      *
1120      * - `tokenId` must exist.
1121      *
1122      * Emits a {Transfer} event.
1123      */
1124     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1125         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1126 
1127         address from = prevOwnership.addr;
1128 
1129         if (approvalCheck) {
1130             bool isApprovedOrOwner = (_msgSender() == from ||
1131                 isApprovedForAll(from, _msgSender()) ||
1132                 getApproved(tokenId) == _msgSender());
1133 
1134             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1135         }
1136 
1137         _beforeTokenTransfers(from, address(0), tokenId, 1);
1138 
1139         // Clear approvals from the previous owner
1140         _approve(address(0), tokenId, from);
1141 
1142         // Underflow of the sender's balance is impossible because we check for
1143         // ownership above and the recipient's balance can't realistically overflow.
1144         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1145         unchecked {
1146             AddressData storage addressData = _addressData[from];
1147             addressData.balance -= 1;
1148             addressData.numberBurned += 1;
1149 
1150             // Keep track of who burned the token, and the timestamp of burning.
1151             TokenOwnership storage currSlot = _ownerships[tokenId];
1152             currSlot.addr = from;
1153             currSlot.startTimestamp = uint64(block.timestamp);
1154             currSlot.burned = true;
1155 
1156             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1157             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1158             uint256 nextTokenId = tokenId + 1;
1159             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1160             if (nextSlot.addr == address(0)) {
1161                 // This will suffice for checking _exists(nextTokenId),
1162                 // as a burned slot cannot contain the zero address.
1163                 if (nextTokenId != _currentIndex) {
1164                     nextSlot.addr = from;
1165                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1166                 }
1167             }
1168         }
1169 
1170         emit Transfer(from, address(0), tokenId);
1171         _afterTokenTransfers(from, address(0), tokenId, 1);
1172 
1173         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1174         unchecked {
1175             _burnCounter++;
1176         }
1177     }
1178 
1179     /**
1180      * @dev Approve `to` to operate on `tokenId`
1181      *
1182      * Emits a {Approval} event.
1183      */
1184     function _approve(
1185         address to,
1186         uint256 tokenId,
1187         address owner
1188     ) private {
1189         _tokenApprovals[tokenId] = to;
1190         emit Approval(owner, to, tokenId);
1191     }
1192 
1193     /**
1194      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1195      *
1196      * @param from address representing the previous owner of the given token ID
1197      * @param to target address that will receive the tokens
1198      * @param tokenId uint256 ID of the token to be transferred
1199      * @param _data bytes optional data to send along with the call
1200      * @return bool whether the call correctly returned the expected magic value
1201      */
1202     function _checkContractOnERC721Received(
1203         address from,
1204         address to,
1205         uint256 tokenId,
1206         bytes memory _data
1207     ) private returns (bool) {
1208         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1209             return retval == IERC721Receiver(to).onERC721Received.selector;
1210         } catch (bytes memory reason) {
1211             if (reason.length == 0) {
1212                 revert TransferToNonERC721ReceiverImplementer();
1213             } else {
1214                 assembly {
1215                     revert(add(32, reason), mload(reason))
1216                 }
1217             }
1218         }
1219     }
1220 
1221     /**
1222      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1223      * And also called before burning one token.
1224      *
1225      * startTokenId - the first token id to be transferred
1226      * quantity - the amount to be transferred
1227      *
1228      * Calling conditions:
1229      *
1230      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1231      * transferred to `to`.
1232      * - When `from` is zero, `tokenId` will be minted for `to`.
1233      * - When `to` is zero, `tokenId` will be burned by `from`.
1234      * - `from` and `to` are never both zero.
1235      */
1236     function _beforeTokenTransfers(
1237         address from,
1238         address to,
1239         uint256 startTokenId,
1240         uint256 quantity
1241     ) internal virtual {}
1242 
1243     /**
1244      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1245      * minting.
1246      * And also called after one token has been burned.
1247      *
1248      * startTokenId - the first token id to be transferred
1249      * quantity - the amount to be transferred
1250      *
1251      * Calling conditions:
1252      *
1253      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1254      * transferred to `to`.
1255      * - When `from` is zero, `tokenId` has been minted for `to`.
1256      * - When `to` is zero, `tokenId` has been burned by `from`.
1257      * - `from` and `to` are never both zero.
1258      */
1259     function _afterTokenTransfers(
1260         address from,
1261         address to,
1262         uint256 startTokenId,
1263         uint256 quantity
1264     ) internal virtual {}
1265 }
1266 
1267 abstract contract Ownable is Context {
1268     address private _owner;
1269 
1270     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1271 
1272     /**
1273      * @dev Initializes the contract setting the deployer as the initial owner.
1274      */
1275     constructor() {
1276         _transferOwnership(_msgSender());
1277     }
1278 
1279     /**
1280      * @dev Returns the address of the current owner.
1281      */
1282     function owner() public view virtual returns (address) {
1283         return _owner;
1284     }
1285 
1286     /**
1287      * @dev Throws if called by any account other than the owner.
1288      */
1289     modifier onlyOwner() {
1290         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1291         _;
1292     }
1293 
1294     /**
1295      * @dev Leaves the contract without owner. It will not be possible to call
1296      * `onlyOwner` functions anymore. Can only be called by the current owner.
1297      *
1298      * NOTE: Renouncing ownership will leave the contract without an owner,
1299      * thereby removing any functionality that is only available to the owner.
1300      */
1301     function renounceOwnership() public virtual onlyOwner {
1302         _transferOwnership(address(0));
1303     }
1304 
1305     /**
1306      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1307      * Can only be called by the current owner.
1308      */
1309     function transferOwnership(address newOwner) public virtual onlyOwner {
1310         require(newOwner != address(0), "Ownable: new owner is the zero address");
1311         _transferOwnership(newOwner);
1312     }
1313 
1314     /**
1315      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1316      * Internal function without access restriction.
1317      */
1318     function _transferOwnership(address newOwner) internal virtual {
1319         address oldOwner = _owner;
1320         _owner = newOwner;
1321         emit OwnershipTransferred(oldOwner, newOwner);
1322     }
1323 }
1324 pragma solidity ^0.8.13;
1325 
1326 interface IOperatorFilterRegistry {
1327     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1328     function register(address registrant) external;
1329     function registerAndSubscribe(address registrant, address subscription) external;
1330     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1331     function updateOperator(address registrant, address operator, bool filtered) external;
1332     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1333     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1334     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1335     function subscribe(address registrant, address registrantToSubscribe) external;
1336     function unsubscribe(address registrant, bool copyExistingEntries) external;
1337     function subscriptionOf(address addr) external returns (address registrant);
1338     function subscribers(address registrant) external returns (address[] memory);
1339     function subscriberAt(address registrant, uint256 index) external returns (address);
1340     function copyEntriesOf(address registrant, address registrantToCopy) external;
1341     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1342     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1343     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1344     function filteredOperators(address addr) external returns (address[] memory);
1345     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1346     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1347     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1348     function isRegistered(address addr) external returns (bool);
1349     function codeHashOf(address addr) external returns (bytes32);
1350 }
1351 pragma solidity ^0.8.13;
1352 
1353 
1354 
1355 abstract contract OperatorFilterer {
1356     error OperatorNotAllowed(address operator);
1357 
1358     IOperatorFilterRegistry constant operatorFilterRegistry =
1359         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1360 
1361     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1362         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1363         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1364         // order for the modifier to filter addresses.
1365         if (address(operatorFilterRegistry).code.length > 0) {
1366             if (subscribe) {
1367                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1368             } else {
1369                 if (subscriptionOrRegistrantToCopy != address(0)) {
1370                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1371                 } else {
1372                     operatorFilterRegistry.register(address(this));
1373                 }
1374             }
1375         }
1376     }
1377 
1378     modifier onlyAllowedOperator(address from) virtual {
1379         // Check registry code length to facilitate testing in environments without a deployed registry.
1380         if (address(operatorFilterRegistry).code.length > 0) {
1381             // Allow spending tokens from addresses with balance
1382             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1383             // from an EOA.
1384             if (from == msg.sender) {
1385                 _;
1386                 return;
1387             }
1388             if (
1389                 !(
1390                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1391                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1392                 )
1393             ) {
1394                 revert OperatorNotAllowed(msg.sender);
1395             }
1396         }
1397         _;
1398     }
1399 }
1400 pragma solidity ^0.8.13;
1401 
1402 
1403 
1404 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1405     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1406 
1407     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1408 }
1409     pragma solidity ^0.8.7;
1410     
1411     contract DadGods is ERC721A, DefaultOperatorFilterer , Ownable {
1412     using Strings for uint256;
1413 
1414 
1415   string private uriPrefix ;
1416   string private uriSuffix = ".json";
1417   string public hiddenURL;
1418 
1419   
1420   
1421 
1422   uint256 public cost = 0.002 ether;
1423  
1424   
1425 
1426   uint16 public maxSupply = 8888;
1427   uint8 public maxMintAmountPerTx = 1;
1428     uint8 public maxFreeMintAmountPerWallet = 1;
1429                                                              
1430  
1431   bool public paused = true;
1432   bool public reveal =false;
1433 
1434    mapping (address => uint8) public NFTPerPublicAddress;
1435 
1436  
1437   
1438   
1439  
1440   
1441 
1442   constructor() ERC721A("Dad Gods", "DGODS") {
1443   }
1444 
1445 
1446   
1447  
1448   function mint(uint8 _mintAmount) external payable  {
1449      uint16 totalSupply = uint16(totalSupply());
1450      uint8 nft = NFTPerPublicAddress[msg.sender];
1451     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1452     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1453     require(msg.sender == tx.origin , "No Bots Allowed");
1454 
1455     require(!paused, "The contract is paused!");
1456     
1457       if(nft >= maxFreeMintAmountPerWallet)
1458     {
1459     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1460     }
1461     else {
1462          uint8 costAmount = _mintAmount + nft;
1463         if(costAmount > maxFreeMintAmountPerWallet)
1464        {
1465         costAmount = costAmount - maxFreeMintAmountPerWallet;
1466         require(msg.value >= cost * costAmount, "Insufficient funds!");
1467        }
1468        
1469          
1470     }
1471     
1472 
1473 
1474     _safeMint(msg.sender , _mintAmount);
1475 
1476     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1477      
1478      delete totalSupply;
1479      delete _mintAmount;
1480   }
1481   
1482   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1483      uint16 totalSupply = uint16(totalSupply());
1484     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1485      _safeMint(_receiver , _mintAmount);
1486      delete _mintAmount;
1487      delete _receiver;
1488      delete totalSupply;
1489   }
1490 
1491   function  Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1492      uint16 totalSupply = uint16(totalSupply());
1493      uint totalAmount =   _amountPerAddress * addresses.length;
1494     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
1495      for (uint256 i = 0; i < addresses.length; i++) {
1496             _safeMint(addresses[i], _amountPerAddress);
1497         }
1498 
1499      delete _amountPerAddress;
1500      delete totalSupply;
1501   }
1502 
1503  
1504 
1505   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1506       maxSupply = _maxSupply;
1507   }
1508 
1509 
1510 
1511    
1512   function tokenURI(uint256 _tokenId)
1513     public
1514     view
1515     virtual
1516     override
1517     returns (string memory)
1518   {
1519     require(
1520       _exists(_tokenId),
1521       "ERC721Metadata: URI query for nonexistent token"
1522     );
1523     
1524   
1525 if ( reveal == false)
1526 {
1527     return hiddenURL;
1528 }
1529     
1530 
1531     string memory currentBaseURI = _baseURI();
1532     return bytes(currentBaseURI).length > 0
1533         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1534         : "";
1535   }
1536  
1537  
1538 
1539 
1540  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1541     maxFreeMintAmountPerWallet = _limit;
1542    delete _limit;
1543 
1544 }
1545 
1546     
1547   
1548 
1549   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1550     uriPrefix = _uriPrefix;
1551   }
1552    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1553     hiddenURL = _uriPrefix;
1554   }
1555 
1556 
1557   function setPaused() external onlyOwner {
1558     paused = !paused;
1559    
1560   }
1561 
1562   function setCost(uint _cost) external onlyOwner{
1563       cost = _cost;
1564 
1565   }
1566 
1567  function setRevealed() external onlyOwner{
1568      reveal = !reveal;
1569  }
1570 
1571   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1572       maxMintAmountPerTx = _maxtx;
1573 
1574   }
1575 
1576  
1577 
1578   function withdraw() external onlyOwner {
1579   uint _balance = address(this).balance;
1580      payable(msg.sender).transfer(_balance ); 
1581        
1582   }
1583 
1584 
1585   function _baseURI() internal view  override returns (string memory) {
1586     return uriPrefix;
1587   }
1588 
1589     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1590         super.transferFrom(from, to, tokenId);
1591     }
1592 
1593     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1594         super.safeTransferFrom(from, to, tokenId);
1595     }
1596 
1597     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1598         public
1599         override
1600         onlyAllowedOperator(from)
1601     {
1602         super.safeTransferFrom(from, to, tokenId, data);
1603     }
1604 }