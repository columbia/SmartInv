1 //PPPPPPPPPPPPPPPPP                       MMMMMMMM               MMMMMMMMDDDDDDDDDDDDD             OOOOOOOOO          OOOOOOOOO     DDDDDDDDDDDDD           SSSSSSSSSSSSSSS 
2 //P::::::::::::::::P                      M:::::::M             M:::::::MD::::::::::::DDD        OO:::::::::OO      OO:::::::::OO   D::::::::::::DDD      SS:::::::::::::::S
3 //P::::::PPPPPP:::::P                     M::::::::M           M::::::::MD:::::::::::::::DD    OO:::::::::::::OO  OO:::::::::::::OO D:::::::::::::::DD   S:::::SSSSSS::::::S
4 //PP:::::P     P:::::P                    M:::::::::M         M:::::::::MDDD:::::DDDDD:::::D  O:::::::OOO:::::::OO:::::::OOO:::::::ODDD:::::DDDDD:::::D  S:::::S     SSSSSSS
5 //P::::P     P:::::Pxxxxxxx      xxxxxxxM::::::::::M       M::::::::::M  D:::::D    D:::::D O::::::O   O::::::OO::::::O   O::::::O  D:::::D    D:::::D S:::::S            
6 //P::::P     P:::::P x:::::x    x:::::x M:::::::::::M     M:::::::::::M  D:::::D     D:::::DO:::::O     O:::::OO:::::O     O:::::O  D:::::D     D:::::DS:::::S            
7 //P::::PPPPPP:::::P   x:::::x  x:::::x  M:::::::M::::M   M::::M:::::::M  D:::::D     D:::::DO:::::O     O:::::OO:::::O     O:::::O  D:::::D     D:::::D S::::SSSS         
8 //P:::::::::::::PP     x:::::xx:::::x   M::::::M M::::M M::::M M::::::M  D:::::D     D:::::DO:::::O     O:::::OO:::::O     O:::::O  D:::::D     D:::::D  SS::::::SSSSS    
9 //P::::PPPPPPPPP        x::::::::::x    M::::::M  M::::M::::M  M::::::M  D:::::D     D:::::DO:::::O     O:::::OO:::::O     O:::::O  D:::::D     D:::::D    SSS::::::::SS  
10 //P::::P                 x::::::::x     M::::::M   M:::::::M   M::::::M  D:::::D     D:::::DO:::::O     O:::::OO:::::O     O:::::O  D:::::D     D:::::D       SSSSSS::::S 
11 //P::::P                 x::::::::x     M::::::M    M:::::M    M::::::M  D:::::D     D:::::DO:::::O     O:::::OO:::::O     O:::::O  D:::::D     D:::::D            S:::::S
12 //P::::P                x::::::::::x    M::::::M     MMMMM     M::::::M  D:::::D    D:::::D O::::::O   O::::::OO::::::O   O::::::O  D:::::D    D:::::D             S:::::S
13 //PP::::::PP             x:::::xx:::::x   M::::::M               M::::::MDDD:::::DDDDD:::::D  O:::::::OOO:::::::OO:::::::OOO:::::::ODDD:::::DDDDD:::::D  SSSSSSS     S:::::S
14 //P::::::::P            x:::::x  x:::::x  M::::::M               M::::::MD:::::::::::::::DD    OO:::::::::::::OO  OO:::::::::::::OO D:::::::::::::::DD   S::::::SSSSSS:::::S
15 //P::::::::P           x:::::x    x:::::x M::::::M               M::::::MD::::::::::::DDD        OO:::::::::OO      OO:::::::::OO   D::::::::::::DDD     S:::::::::::::::SS 
16 //PPPPPPPPPP          xxxxxxx      xxxxxxxMMMMMMMM               MMMMMMMMDDDDDDDDDDDDD             OOOOOOOOO          OOOOOOOOO     DDDDDDDDDDDDD         SSSSSSSSSSSSSSS   
17                                                                                                                                                                           
18                                                                                                                                                                           
19 
20 
21 
22 //5,555 Pixel Mutant Doods taking over the earth.  Each NFT acts as a ticket to an amazing adventure.
23 //First 555 FREE - Paid After
24 //If minting from contract enter 0 for the amount and then the number you want free(max 10)
25 //Once free is minted out you enter the cost and the number wanted
26 
27 // SPDX-License-Identifier: MIT
28 // File: @openzeppelin/contracts/utils/Strings.sol
29 
30 
31 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
32 //
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev String operations.
37  */
38 library Strings {
39     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
43      */
44     function toString(uint256 value) internal pure returns (string memory) {
45         // Inspired by OraclizeAPI's implementation - MIT licence
46         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
47 
48         if (value == 0) {
49             return "0";
50         }
51         uint256 temp = value;
52         uint256 digits;
53         while (temp != 0) {
54             digits++;
55             temp /= 10;
56         }
57         bytes memory buffer = new bytes(digits);
58         while (value != 0) {
59             digits -= 1;
60             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
61             value /= 10;
62         }
63         return string(buffer);
64     }
65 
66     /**
67      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
68      */
69     function toHexString(uint256 value) internal pure returns (string memory) {
70         if (value == 0) {
71             return "0x00";
72         }
73         uint256 temp = value;
74         uint256 length = 0;
75         while (temp != 0) {
76             length++;
77             temp >>= 8;
78         }
79         return toHexString(value, length);
80     }
81 
82     /**
83      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
84      */
85     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
86         bytes memory buffer = new bytes(2 * length + 2);
87         buffer[0] = "0";
88         buffer[1] = "x";
89         for (uint256 i = 2 * length + 1; i > 1; --i) {
90             buffer[i] = _HEX_SYMBOLS[value & 0xf];
91             value >>= 4;
92         }
93         require(value == 0, "Strings: hex length insufficient");
94         return string(buffer);
95     }
96 }
97 
98 // File: @openzeppelin/contracts/utils/Address.sol
99 
100 
101 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 /**
106  * @dev Collection of functions related to the address type
107  */
108 library Address {
109     /**
110      * @dev Returns true if `account` is a contract.
111      *
112      * [IMPORTANT]
113      * ====
114      * It is unsafe to assume that an address for which this function returns
115      * false is an externally-owned account (EOA) and not a contract.
116      *
117      * Among others, `isContract` will return false for the following
118      * types of addresses:
119      *
120      *  - an externally-owned account
121      *  - a contract in construction
122      *  - an address where a contract will be created
123      *  - an address where a contract lived, but was destroyed
124      * ====
125      */
126     function isContract(address account) internal view returns (bool) {
127         // This method relies on extcodesize, which returns 0 for contracts in
128         // construction, since the code is only stored at the end of the
129         // constructor execution.
130 
131         uint256 size;
132         assembly {
133             size := extcodesize(account)
134         }
135         return size > 0;
136     }
137 
138     /**
139      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
140      * `recipient`, forwarding all available gas and reverting on errors.
141      *
142      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
143      * of certain opcodes, possibly making contracts go over the 2300 gas limit
144      * imposed by `transfer`, making them unable to receive funds via
145      * `transfer`. {sendValue} removes this limitation.
146      *
147      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
148      *
149      * IMPORTANT: because control is transferred to `recipient`, care must be
150      * taken to not create reentrancy vulnerabilities. Consider using
151      * {ReentrancyGuard} or the
152      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
153      */
154     function sendValue(address payable recipient, uint256 amount) internal {
155         require(address(this).balance >= amount, "Address: insufficient balance");
156 
157         (bool success, ) = recipient.call{value: amount}("");
158         require(success, "Address: unable to send value, recipient may have reverted");
159     }
160 
161     /**
162      * @dev Performs a Solidity function call using a low level `call`. A
163      * plain `call` is an unsafe replacement for a function call: use this
164      * function instead.
165      *
166      * If `target` reverts with a revert reason, it is bubbled up by this
167      * function (like regular Solidity function calls).
168      *
169      * Returns the raw returned data. To convert to the expected return value,
170      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
171      *
172      * Requirements:
173      *
174      * - `target` must be a contract.
175      * - calling `target` with `data` must not revert.
176      *
177      * _Available since v3.1._
178      */
179     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
180         return functionCall(target, data, "Address: low-level call failed");
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
185      * `errorMessage` as a fallback revert reason when `target` reverts.
186      *
187      * _Available since v3.1._
188      */
189     function functionCall(
190         address target,
191         bytes memory data,
192         string memory errorMessage
193     ) internal returns (bytes memory) {
194         return functionCallWithValue(target, data, 0, errorMessage);
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
199      * but also transferring `value` wei to `target`.
200      *
201      * Requirements:
202      *
203      * - the calling contract must have an ETH balance of at least `value`.
204      * - the called Solidity function must be `payable`.
205      *
206      * _Available since v3.1._
207      */
208     function functionCallWithValue(
209         address target,
210         bytes memory data,
211         uint256 value
212     ) internal returns (bytes memory) {
213         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
218      * with `errorMessage` as a fallback revert reason when `target` reverts.
219      *
220      * _Available since v3.1._
221      */
222     function functionCallWithValue(
223         address target,
224         bytes memory data,
225         uint256 value,
226         string memory errorMessage
227     ) internal returns (bytes memory) {
228         require(address(this).balance >= value, "Address: insufficient balance for call");
229         require(isContract(target), "Address: call to non-contract");
230 
231         (bool success, bytes memory returndata) = target.call{value: value}(data);
232         return verifyCallResult(success, returndata, errorMessage);
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
237      * but performing a static call.
238      *
239      * _Available since v3.3._
240      */
241     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
242         return functionStaticCall(target, data, "Address: low-level static call failed");
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
247      * but performing a static call.
248      *
249      * _Available since v3.3._
250      */
251     function functionStaticCall(
252         address target,
253         bytes memory data,
254         string memory errorMessage
255     ) internal view returns (bytes memory) {
256         require(isContract(target), "Address: static call to non-contract");
257 
258         (bool success, bytes memory returndata) = target.staticcall(data);
259         return verifyCallResult(success, returndata, errorMessage);
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
264      * but performing a delegate call.
265      *
266      * _Available since v3.4._
267      */
268     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
269         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
274      * but performing a delegate call.
275      *
276      * _Available since v3.4._
277      */
278     function functionDelegateCall(
279         address target,
280         bytes memory data,
281         string memory errorMessage
282     ) internal returns (bytes memory) {
283         require(isContract(target), "Address: delegate call to non-contract");
284 
285         (bool success, bytes memory returndata) = target.delegatecall(data);
286         return verifyCallResult(success, returndata, errorMessage);
287     }
288 
289     /**
290      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
291      * revert reason using the provided one.
292      *
293      * _Available since v4.3._
294      */
295     function verifyCallResult(
296         bool success,
297         bytes memory returndata,
298         string memory errorMessage
299     ) internal pure returns (bytes memory) {
300         if (success) {
301             return returndata;
302         } else {
303             // Look for revert reason and bubble it up if present
304             if (returndata.length > 0) {
305                 // The easiest way to bubble the revert reason is using memory via assembly
306 
307                 assembly {
308                     let returndata_size := mload(returndata)
309                     revert(add(32, returndata), returndata_size)
310                 }
311             } else {
312                 revert(errorMessage);
313             }
314         }
315     }
316 }
317 
318 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
319 
320 
321 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
322 
323 pragma solidity ^0.8.0;
324 
325 /**
326  * @title ERC721 token receiver interface
327  * @dev Interface for any contract that wants to support safeTransfers
328  * from ERC721 asset contracts.
329  */
330 interface IERC721Receiver {
331     /**
332      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
333      * by `operator` from `from`, this function is called.
334      *
335      * It must return its Solidity selector to confirm the token transfer.
336      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
337      *
338      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
339      */
340     function onERC721Received(
341         address operator,
342         address from,
343         uint256 tokenId,
344         bytes calldata data
345     ) external returns (bytes4);
346 }
347 
348 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
349 
350 
351 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
352 
353 pragma solidity ^0.8.0;
354 
355 /**
356  * @dev Interface of the ERC165 standard, as defined in the
357  * https://eips.ethereum.org/EIPS/eip-165[EIP].
358  *
359  * Implementers can declare support of contract interfaces, which can then be
360  * queried by others ({ERC165Checker}).
361  *
362  * For an implementation, see {ERC165}.
363  */
364 interface IERC165 {
365     /**
366      * @dev Returns true if this contract implements the interface defined by
367      * `interfaceId`. See the corresponding
368      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
369      * to learn more about how these ids are created.
370      *
371      * This function call must use less than 30 000 gas.
372      */
373     function supportsInterface(bytes4 interfaceId) external view returns (bool);
374 }
375 
376 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
377 
378 
379 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
380 
381 pragma solidity ^0.8.0;
382 
383 
384 /**
385  * @dev Implementation of the {IERC165} interface.
386  *
387  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
388  * for the additional interface id that will be supported. For example:
389  *
390  * ```solidity
391  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
392  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
393  * }
394  * ```
395  *
396  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
397  */
398 abstract contract ERC165 is IERC165 {
399     /**
400      * @dev See {IERC165-supportsInterface}.
401      */
402     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
403         return interfaceId == type(IERC165).interfaceId;
404     }
405 }
406 
407 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
408 
409 
410 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
411 
412 pragma solidity ^0.8.0;
413 
414 
415 /**
416  * @dev Required interface of an ERC721 compliant contract.
417  */
418 interface IERC721 is IERC165 {
419     /**
420      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
421      */
422     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
423 
424     /**
425      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
426      */
427     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
428 
429     /**
430      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
431      */
432     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
433 
434     /**
435      * @dev Returns the number of tokens in ``owner``'s account.
436      */
437     function balanceOf(address owner) external view returns (uint256 balance);
438 
439     /**
440      * @dev Returns the owner of the `tokenId` token.
441      *
442      * Requirements:
443      *
444      * - `tokenId` must exist.
445      */
446     function ownerOf(uint256 tokenId) external view returns (address owner);
447 
448     /**
449      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
450      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
451      *
452      * Requirements:
453      *
454      * - `from` cannot be the zero address.
455      * - `to` cannot be the zero address.
456      * - `tokenId` token must exist and be owned by `from`.
457      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
458      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
459      *
460      * Emits a {Transfer} event.
461      */
462     function safeTransferFrom(
463         address from,
464         address to,
465         uint256 tokenId
466     ) external;
467 
468     /**
469      * @dev Transfers `tokenId` token from `from` to `to`.
470      *
471      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
472      *
473      * Requirements:
474      *
475      * - `from` cannot be the zero address.
476      * - `to` cannot be the zero address.
477      * - `tokenId` token must be owned by `from`.
478      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
479      *
480      * Emits a {Transfer} event.
481      */
482     function transferFrom(
483         address from,
484         address to,
485         uint256 tokenId
486     ) external;
487 
488     /**
489      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
490      * The approval is cleared when the token is transferred.
491      *
492      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
493      *
494      * Requirements:
495      *
496      * - The caller must own the token or be an approved operator.
497      * - `tokenId` must exist.
498      *
499      * Emits an {Approval} event.
500      */
501     function approve(address to, uint256 tokenId) external;
502 
503     /**
504      * @dev Returns the account approved for `tokenId` token.
505      *
506      * Requirements:
507      *
508      * - `tokenId` must exist.
509      */
510     function getApproved(uint256 tokenId) external view returns (address operator);
511 
512     /**
513      * @dev Approve or remove `operator` as an operator for the caller.
514      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
515      *
516      * Requirements:
517      *
518      * - The `operator` cannot be the caller.
519      *
520      * Emits an {ApprovalForAll} event.
521      */
522     function setApprovalForAll(address operator, bool _approved) external;
523 
524     /**
525      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
526      *
527      * See {setApprovalForAll}
528      */
529     function isApprovedForAll(address owner, address operator) external view returns (bool);
530 
531     /**
532      * @dev Safely transfers `tokenId` token from `from` to `to`.
533      *
534      * Requirements:
535      *
536      * - `from` cannot be the zero address.
537      * - `to` cannot be the zero address.
538      * - `tokenId` token must exist and be owned by `from`.
539      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
540      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
541      *
542      * Emits a {Transfer} event.
543      */
544     function safeTransferFrom(
545         address from,
546         address to,
547         uint256 tokenId,
548         bytes calldata data
549     ) external;
550 }
551 
552 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
553 
554 
555 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
556 
557 pragma solidity ^0.8.0;
558 
559 
560 /**
561  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
562  * @dev See https://eips.ethereum.org/EIPS/eip-721
563  */
564 interface IERC721Metadata is IERC721 {
565     /**
566      * @dev Returns the token collection name.
567      */
568     function name() external view returns (string memory);
569 
570     /**
571      * @dev Returns the token collection symbol.
572      */
573     function symbol() external view returns (string memory);
574 
575     /**
576      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
577      */
578     function tokenURI(uint256 tokenId) external view returns (string memory);
579 }
580 
581 // File: @openzeppelin/contracts/utils/Context.sol
582 
583 
584 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
585 
586 pragma solidity ^0.8.0;
587 
588 /**
589  * @dev Provides information about the current execution context, including the
590  * sender of the transaction and its data. While these are generally available
591  * via msg.sender and msg.data, they should not be accessed in such a direct
592  * manner, since when dealing with meta-transactions the account sending and
593  * paying for execution may not be the actual sender (as far as an application
594  * is concerned).
595  *
596  * This contract is only required for intermediate, library-like contracts.
597  */
598 abstract contract Context {
599     function _msgSender() internal view virtual returns (address) {
600         return msg.sender;
601     }
602 
603     function _msgData() internal view virtual returns (bytes calldata) {
604         return msg.data;
605     }
606 }
607 
608 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
609 
610 
611 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
612 
613 pragma solidity ^0.8.0;
614 
615 
616 
617 
618 
619 
620 
621 
622 /**
623  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
624  * the Metadata extension, but not including the Enumerable extension, which is available separately as
625  * {ERC721Enumerable}.
626  */
627 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
628     using Address for address;
629     using Strings for uint256;
630 
631     // Token name
632     string private _name;
633 
634     // Token symbol
635     string private _symbol;
636 
637     // Mapping from token ID to owner address
638     mapping(uint256 => address) private _owners;
639 
640     // Mapping owner address to token count
641     mapping(address => uint256) private _balances;
642 
643     // Mapping from token ID to approved address
644     mapping(uint256 => address) private _tokenApprovals;
645 
646     // Mapping from owner to operator approvals
647     mapping(address => mapping(address => bool)) private _operatorApprovals;
648 
649     /**
650      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
651      */
652     constructor(string memory name_, string memory symbol_) {
653         _name = name_;
654         _symbol = symbol_;
655     }
656 
657     /**
658      * @dev See {IERC165-supportsInterface}.
659      */
660     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
661         return
662             interfaceId == type(IERC721).interfaceId ||
663             interfaceId == type(IERC721Metadata).interfaceId ||
664             super.supportsInterface(interfaceId);
665     }
666 
667     /**
668      * @dev See {IERC721-balanceOf}.
669      */
670     function balanceOf(address owner) public view virtual override returns (uint256) {
671         require(owner != address(0), "ERC721: balance query for the zero address");
672         return _balances[owner];
673     }
674 
675     /**
676      * @dev See {IERC721-ownerOf}.
677      */
678     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
679         address owner = _owners[tokenId];
680         require(owner != address(0), "ERC721: owner query for nonexistent token");
681         return owner;
682     }
683 
684     /**
685      * @dev See {IERC721Metadata-name}.
686      */
687     function name() public view virtual override returns (string memory) {
688         return _name;
689     }
690 
691     /**
692      * @dev See {IERC721Metadata-symbol}.
693      */
694     function symbol() public view virtual override returns (string memory) {
695         return _symbol;
696     }
697 
698     /**
699      * @dev See {IERC721Metadata-tokenURI}.
700      */
701     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
702         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
703 
704         string memory baseURI = _baseURI();
705         
706         //return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
707           return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
708     }
709 
710     /**
711      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
712      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
713      * by default, can be overriden in child contracts.
714      */
715     function _baseURI() internal view virtual returns (string memory) {
716         return "";
717     }
718 
719     /**
720      * @dev See {IERC721-approve}.
721      */
722     function approve(address to, uint256 tokenId) public virtual override {
723         address owner = ERC721.ownerOf(tokenId);
724         require(to != owner, "ERC721: approval to current owner");
725 
726         require(
727             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
728             "ERC721: approve caller is not owner nor approved for all"
729         );
730 
731         _approve(to, tokenId);
732     }
733 
734     /**
735      * @dev See {IERC721-getApproved}.
736      */
737     function getApproved(uint256 tokenId) public view virtual override returns (address) {
738         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
739 
740         return _tokenApprovals[tokenId];
741     }
742 
743     /**
744      * @dev See {IERC721-setApprovalForAll}.
745      */
746     function setApprovalForAll(address operator, bool approved) public virtual override {
747         _setApprovalForAll(_msgSender(), operator, approved);
748     }
749 
750     /**
751      * @dev See {IERC721-isApprovedForAll}.
752      */
753     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
754         return _operatorApprovals[owner][operator];
755     }
756 
757     /**
758      * @dev See {IERC721-transferFrom}.
759      */
760     function transferFrom(
761         address from,
762         address to,
763         uint256 tokenId
764     ) public virtual override {
765         //solhint-disable-next-line max-line-length
766         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
767 
768         _transfer(from, to, tokenId);
769     }
770 
771     /**
772      * @dev See {IERC721-safeTransferFrom}.
773      */
774     function safeTransferFrom(
775         address from,
776         address to,
777         uint256 tokenId
778     ) public virtual override {
779         safeTransferFrom(from, to, tokenId, "");
780     }
781 
782     /**
783      * @dev See {IERC721-safeTransferFrom}.
784      */
785     function safeTransferFrom(
786         address from,
787         address to,
788         uint256 tokenId,
789         bytes memory _data
790     ) public virtual override {
791         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
792         _safeTransfer(from, to, tokenId, _data);
793     }
794 
795     /**
796      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
797      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
798      *
799      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
800      *
801      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
802      * implement alternative mechanisms to perform token transfer, such as signature-based.
803      *
804      * Requirements:
805      *
806      * - `from` cannot be the zero address.
807      * - `to` cannot be the zero address.
808      * - `tokenId` token must exist and be owned by `from`.
809      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
810      *
811      * Emits a {Transfer} event.
812      */
813     function _safeTransfer(
814         address from,
815         address to,
816         uint256 tokenId,
817         bytes memory _data
818     ) internal virtual {
819         _transfer(from, to, tokenId);
820         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
821     }
822 
823     /**
824      * @dev Returns whether `tokenId` exists.
825      *
826      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
827      *
828      * Tokens start existing when they are minted (`_mint`),
829      * and stop existing when they are burned (`_burn`).
830      */
831     function _exists(uint256 tokenId) internal view virtual returns (bool) {
832         return _owners[tokenId] != address(0);
833     }
834 
835     /**
836      * @dev Returns whether `spender` is allowed to manage `tokenId`.
837      *
838      * Requirements:
839      *
840      * - `tokenId` must exist.
841      */
842     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
843         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
844         address owner = ERC721.ownerOf(tokenId);
845         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
846     }
847 
848     /**
849      * @dev Safely mints `tokenId` and transfers it to `to`.
850      *
851      * Requirements:
852      *
853      * - `tokenId` must not exist.
854      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
855      *
856      * Emits a {Transfer} event.
857      */
858     function _safeMint(address to, uint256 tokenId) internal virtual {
859         _safeMint(to, tokenId, "");
860     }
861 
862     /**
863      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
864      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
865      */
866     function _safeMint(
867         address to,
868         uint256 tokenId,
869         bytes memory _data
870     ) internal virtual {
871         _mint(to, tokenId);
872         require(
873             _checkOnERC721Received(address(0), to, tokenId, _data),
874             "ERC721: transfer to non ERC721Receiver implementer"
875         );
876     }
877 
878     /**
879      * @dev Mints `tokenId` and transfers it to `to`.
880      *
881      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
882      *
883      * Requirements:
884      *
885      * - `tokenId` must not exist.
886      * - `to` cannot be the zero address.
887      *
888      * Emits a {Transfer} event.
889      */
890     function _mint(address to, uint256 tokenId) internal virtual {
891         require(to != address(0), "ERC721: mint to the zero address");
892         require(!_exists(tokenId), "ERC721: token already minted");
893 
894         _beforeTokenTransfer(address(0), to, tokenId);
895 
896         _balances[to] += 1;
897         _owners[tokenId] = to;
898 
899         emit Transfer(address(0), to, tokenId);
900     }
901 
902     /**
903      * @dev Destroys `tokenId`.
904      * The approval is cleared when the token is burned.
905      *
906      * Requirements:
907      *
908      * - `tokenId` must exist.
909      *
910      * Emits a {Transfer} event.
911      */
912     function _burn(uint256 tokenId) internal virtual {
913         address owner = ERC721.ownerOf(tokenId);
914 
915         _beforeTokenTransfer(owner, address(0), tokenId);
916 
917         // Clear approvals
918         _approve(address(0), tokenId);
919 
920         _balances[owner] -= 1;
921         delete _owners[tokenId];
922 
923         emit Transfer(owner, address(0), tokenId);
924     }
925 
926     /**
927      * @dev Transfers `tokenId` from `from` to `to`.
928      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
929      *
930      * Requirements:
931      *
932      * - `to` cannot be the zero address.
933      * - `tokenId` token must be owned by `from`.
934      *
935      * Emits a {Transfer} event.
936      */
937     function _transfer(
938         address from,
939         address to,
940         uint256 tokenId
941     ) internal virtual {
942         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
943         require(to != address(0), "ERC721: transfer to the zero address");
944 
945         _beforeTokenTransfer(from, to, tokenId);
946 
947         // Clear approvals from the previous owner
948         _approve(address(0), tokenId);
949 
950         _balances[from] -= 1;
951         _balances[to] += 1;
952         _owners[tokenId] = to;
953 
954         emit Transfer(from, to, tokenId);
955     }
956 
957     /**
958      * @dev Approve `to` to operate on `tokenId`
959      *
960      * Emits a {Approval} event.
961      */
962     function _approve(address to, uint256 tokenId) internal virtual {
963         _tokenApprovals[tokenId] = to;
964         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
965     }
966 
967     /**
968      * @dev Approve `operator` to operate on all of `owner` tokens
969      *
970      * Emits a {ApprovalForAll} event.
971      */
972     function _setApprovalForAll(
973         address owner,
974         address operator,
975         bool approved
976     ) internal virtual {
977         require(owner != operator, "ERC721: approve to caller");
978         _operatorApprovals[owner][operator] = approved;
979         emit ApprovalForAll(owner, operator, approved);
980     }
981 
982     /**
983      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
984      * The call is not executed if the target address is not a contract.
985      *
986      * @param from address representing the previous owner of the given token ID
987      * @param to target address that will receive the tokens
988      * @param tokenId uint256 ID of the token to be transferred
989      * @param _data bytes optional data to send along with the call
990      * @return bool whether the call correctly returned the expected magic value
991      */
992     function _checkOnERC721Received(
993         address from,
994         address to,
995         uint256 tokenId,
996         bytes memory _data
997     ) private returns (bool) {
998         if (to.isContract()) {
999             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1000                 return retval == IERC721Receiver.onERC721Received.selector;
1001             } catch (bytes memory reason) {
1002                 if (reason.length == 0) {
1003                     revert("ERC721: transfer to non ERC721Receiver implementer");
1004                 } else {
1005                     assembly {
1006                         revert(add(32, reason), mload(reason))
1007                     }
1008                 }
1009             }
1010         } else {
1011             return true;
1012         }
1013     }
1014 
1015     /**
1016      * @dev Hook that is called before any token transfer. This includes minting
1017      * and burning.
1018      *
1019      * Calling conditions:
1020      *
1021      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1022      * transferred to `to`.
1023      * - When `from` is zero, `tokenId` will be minted for `to`.
1024      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1025      * - `from` and `to` are never both zero.
1026      *
1027      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1028      */
1029     function _beforeTokenTransfer(
1030         address from,
1031         address to,
1032         uint256 tokenId
1033     ) internal virtual {}
1034 }
1035 
1036 // File: @openzeppelin/contracts/access/Ownable.sol
1037 
1038 
1039 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1040 
1041 pragma solidity ^0.8.0;
1042 
1043 
1044 /**
1045  * @dev Contract module which provides a basic access control mechanism, where
1046  * there is an account (an owner) that can be granted exclusive access to
1047  * specific functions.
1048  *
1049  * By default, the owner account will be the one that deploys the contract. This
1050  * can later be changed with {transferOwnership}.
1051  *
1052  * This module is used through inheritance. It will make available the modifier
1053  * `onlyOwner`, which can be applied to your functions to restrict their use to
1054  * the owner.
1055  */
1056 abstract contract Ownable is Context {
1057     address private _owner;
1058 
1059     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1060 
1061     /**
1062      * @dev Initializes the contract setting the deployer as the initial owner.
1063      */
1064     constructor() {
1065         _transferOwnership(_msgSender());
1066     }
1067 
1068     /**
1069      * @dev Returns the address of the current owner.
1070      */
1071     function owner() public view virtual returns (address) {
1072         return _owner;
1073     }
1074 
1075     /**
1076      * @dev Throws if called by any account other than the owner.
1077      */
1078     modifier onlyOwner() {
1079         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1080         _;
1081     }
1082 
1083     /**
1084      * @dev Leaves the contract without owner. It will not be possible to call
1085      * `onlyOwner` functions anymore. Can only be called by the current owner.
1086      *
1087      * NOTE: Renouncing ownership will leave the contract without an owner,
1088      * thereby removing any functionality that is only available to the owner.
1089      */
1090     function renounceOwnership() public virtual onlyOwner {
1091         _transferOwnership(address(0));
1092     }
1093 
1094     /**
1095      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1096      * Can only be called by the current owner.
1097      */
1098     function transferOwnership(address newOwner) public virtual onlyOwner {
1099         require(newOwner != address(0), "Ownable: new owner is the zero address");
1100         _transferOwnership(newOwner);
1101     }
1102 
1103     /**
1104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1105      * Internal function without access restriction.
1106      */
1107     function _transferOwnership(address newOwner) internal virtual {
1108         address oldOwner = _owner;
1109         _owner = newOwner;
1110         emit OwnershipTransferred(oldOwner, newOwner);
1111     }
1112 }
1113 
1114 // File: contracts/main.sol
1115 
1116 
1117 pragma solidity ^0.8.0;
1118 
1119 
1120 
1121 contract pxMDoods is ERC721, Ownable {
1122   bool public paused = true;
1123   bool public isPaidMint = true;
1124   string private _baseTokenURI;
1125   uint256 public totalSupply = 0;
1126   uint256 public price = 0.015 ether;
1127   uint256 public maxSupply = 5555;
1128   uint256 public maxFreeMints = 555;
1129   mapping(address => uint256) private freeWallets;
1130 
1131   constructor(string memory baseURI)
1132     ERC721("Pixel Mutated Doods", "pxMDoods")
1133   {
1134     setBaseURI(baseURI);
1135   }
1136 
1137   function mint(uint256 num) public payable {
1138     uint256 supply = totalSupply;
1139 
1140     require(!paused, "MINTING PAUSED");
1141     require(totalSupply + num <= maxSupply, "EXCEEDS MAX SUPPLY");
1142 
1143     if (totalSupply + num > maxFreeMints && isPaidMint) {
1144       require(num < 31, "MAX PER TRANSACTION IS 30");
1145       require(msg.value >= price * num, "NOT ENOUGH ETH");
1146     } else {
1147       require(
1148         freeWallets[msg.sender] + num < 11,
1149         "MAX FREE MINTS PER WALLET IS 10"
1150       );
1151 
1152       freeWallets[msg.sender] += num;
1153     }
1154 
1155     totalSupply += num;
1156 
1157     for (uint256 i; i < num; i++) {
1158       _mint(msg.sender, supply + i);
1159     }
1160   }
1161 
1162   function _baseURI() internal view virtual override returns (string memory) {
1163     return _baseTokenURI;
1164   }
1165 
1166   function setBaseURI(string memory baseUri) public onlyOwner {
1167     _baseTokenURI = baseUri;
1168   }
1169 //price should be set ie 10000000000000000
1170   function setPrice(uint256 newPrice) public onlyOwner {
1171     price = newPrice;
1172   }
1173 
1174   function setMaxSupply(uint256 newMaxSupply) public onlyOwner {
1175     maxSupply = newMaxSupply;
1176   }
1177 
1178   function setMaxFreeMints(uint256 newMaxFreeMints) public onlyOwner {
1179     maxFreeMints = newMaxFreeMints;
1180   }
1181 
1182   function pause(bool state) public onlyOwner {
1183     paused = state;
1184   }
1185 
1186   function paidMint(bool state) public onlyOwner {
1187     isPaidMint = state;
1188   }
1189 
1190   function withdrawAll() public onlyOwner {
1191     require(
1192       payable(owner()).send(address(this).balance),
1193       "WITHDRAW UNSUCCESSFUL"
1194     );
1195   }
1196 }