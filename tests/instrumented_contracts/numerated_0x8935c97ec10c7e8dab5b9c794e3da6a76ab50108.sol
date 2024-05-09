1 // SPDX-License-Identifier: MIT
2 //
3 
4 
5 /////////// █     █░ ▄▄▄▄     ██████  ▄████▄  
6 ///////////▓█░ █ ░█░▓█████▄ ▒██    ▒ ▒██▀ ▀█  
7 ///////////▒█░ █ ░█ ▒██▒ ▄██░ ▓██▄   ▒▓█    ▄ 
8 ///////////░█░ █ ░█ ▒██░█▀    ▒   ██▒▒▓▓▄ ▄██▒
9 ///////////░░██▒██▓ ░▓█  ▀█▓▒██████▒▒▒ ▓███▀ ░
10 ///////////░ ▓░▒ ▒  ░▒▓███▀▒▒ ▒▓▒ ▒ ░░ ░▒ ▒  ░
11 ///////////  ▒ ░ ░  ▒░▒   ░ ░ ░▒  ░ ░  ░  ▒   
12 ///////////  ░   ░   ░    ░ ░  ░  ░  ░        
13 ///////////    ░     ░            ░  ░ ░      
14 ///////////               ░          ░   
15 //................................................................................
16 //.............................                     ..............................
17 //.......................                                 ........................
18 //..................          ..,(%@@@@@@@@@@@@@@&(,..         ...................
19 //...............        ./%@@@@@@@@@@@@@@@@@@@@@@@@@@@@&(.        ...............
20 //............       ./@@@% ,.%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(.      .............
21 //..........      .#@@@@@# ,,,,./&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%,      ..........
22 //........     ./@@@@@@@% ,.  ,,,,*#@@@@****/%@@@@@@@@@@@@@@@@@@@@@(.     ........
23 //......     ./@@@@@@@@@% ,.*,. .,,,,,,,,.,,,,./@@@&..&@@@@@@@@@@@@@@(.    .......
24 //.....     ,@@@@@@@@@@@% ..,,. .,............ /@%*@@@@@@@@@@@@@@@@@@@@*     .....
25 //....    .#@@@@@@@@@@@@% ,.......,**////////*..//(((((/&@@@@@@@@@@@@@@@%.    ....
26 //...    .&@@@@@@@@@@@@@% ,,,,. .**//*      */,/#%#,..#&%*.(%&@@@@@@@@@@@@.    ...
27 //..    .%@@@@@@@@@@@@@/.,,,,. .,**//*      */(*/#.,.  %@,//.,*&@@@@@@@@@@&.    ..
28 //.     (@@@@@@@@@@@%,.,,,,... .,*///*    ,*//(*/#,,.  %@,(@@@@@@@@@@@@@@@@#.   ..
29 //.    ,@@@@@@@@@**..,,,,,..,. .**///*      */(**#,,.  %@,(@@@@@@@@@@@@@@@@@,    .
30 //.    (@@@@@@@@@.......,,,... .**////      *//*/%..  .%@,#@@@@@@@@@@@@@@@@@#    .
31 //     %@@@@@@@(. .,,,,,,....  .,**///*....*//(,*&%((/(/(.(@@@@@@@@@@@@@@@@@&     
32 //     #@@@@@@@(. .........   .,***/////******,..,  . ,.,*.(@@@@@@@@@@@@@@@@&     
33 //     (@@@@@@@@@&,          ,***************/**///,      /&//@@@@@@@@@@@@@@#     
34 //     ,@@@@@@@@@@/.....     ,,**,..,***********/////// (&&@//@@@@@@@@@@@@@@,     
35 //      (@@@@@@@@@@@%,...     ,**, ,(*.,,,******//////**#&&#/#@@@@@@@@@@@@@#.     
36 //      .%@@@@@@@@@@@@&%(  ... .**,,(#,...         ./ / (.*,/@@@@@@@@@@@@@&.      
37 //       .&@@@@@@@@@@@@@@@@@@.   .,,,**,******,,..%%%&*&@@@@@@@@@@@@@@@@@@.       
38 //        .#@@@@@@@@@@&((/ *,, ,*.          ., /@@@@@@@@@@@@@@@@@@@@@@@@%.        
39 //          *@@@@@@/. ,(***......           //**#@%*/@@*,*%@@@@@@@@@@@@*          
40 //           .(@@&, **. ............       #..,*/#&%*,(&&@*#@@@@@@@@@#.           
41 //             ./  /*  ...... ...............*//#&@&(/.(&,#@@@@@@@@(.             
42 //               .,. ....... ..          .(,/##((##&#.,%@*(@@@@%,                
43 //                     ......  .  /(..,&.& /,*/*,.,*%(. (%&/(#.                   
44 //                        ...   . .,/#,%*& /,*(####(*.#@,*.                       
45 //                                         (,*%&&%(,..                            
46                                                                                
47 
48 //created by @ZombieBitsNFT 2022
49 
50 // File: @openzeppelin/contracts/utils/Address.sol
51 
52 
53 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
54 
55 pragma solidity ^0.8.1;
56 
57 /**
58  * @dev Collection of functions related to the address type
59  */
60 library Address {
61     /**
62      * @dev Returns true if `account` is a contract.
63      *
64      * [IMPORTANT]
65      * ====
66      * It is unsafe to assume that an address for which this function returns
67      * false is an externally-owned account (EOA) and not a contract.
68      *
69      * Among others, `isContract` will return false for the following
70      * types of addresses:
71      *
72      *  - an externally-owned account
73      *  - a contract in construction
74      *  - an address where a contract will be created
75      *  - an address where a contract lived, but was destroyed
76      * ====
77      *
78      * [IMPORTANT]
79      * ====
80      * You shouldn't rely on `isContract` to protect against flash loan attacks!
81      *
82      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
83      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
84      * constructor.
85      * ====
86      */
87     function isContract(address account) internal view returns (bool) {
88         // This method relies on extcodesize/address.code.length, which returns 0
89         // for contracts in construction, since the code is only stored at the end
90         // of the constructor execution.
91 
92         return account.code.length > 0;
93     }
94 
95     /**
96      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
97      * `recipient`, forwarding all available gas and reverting on errors.
98      *
99      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
100      * of certain opcodes, possibly making contracts go over the 2300 gas limit
101      * imposed by `transfer`, making them unable to receive funds via
102      * `transfer`. {sendValue} removes this limitation.
103      *
104      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
105      *
106      * IMPORTANT: because control is transferred to `recipient`, care must be
107      * taken to not create reentrancy vulnerabilities. Consider using
108      * {ReentrancyGuard} or the
109      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
110      */
111     function sendValue(address payable recipient, uint256 amount) internal {
112         require(address(this).balance >= amount, "Address: insufficient balance");
113 
114         (bool success, ) = recipient.call{value: amount}("");
115         require(success, "Address: unable to send value, recipient may have reverted");
116     }
117 
118     /**
119      * @dev Performs a Solidity function call using a low level `call`. A
120      * plain `call` is an unsafe replacement for a function call: use this
121      * function instead.
122      *
123      * If `target` reverts with a revert reason, it is bubbled up by this
124      * function (like regular Solidity function calls).
125      *
126      * Returns the raw returned data. To convert to the expected return value,
127      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
128      *
129      * Requirements:
130      *
131      * - `target` must be a contract.
132      * - calling `target` with `data` must not revert.
133      *
134      * _Available since v3.1._
135      */
136     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
137         return functionCall(target, data, "Address: low-level call failed");
138     }
139 
140     /**
141      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
142      * `errorMessage` as a fallback revert reason when `target` reverts.
143      *
144      * _Available since v3.1._
145      */
146     function functionCall(
147         address target,
148         bytes memory data,
149         string memory errorMessage
150     ) internal returns (bytes memory) {
151         return functionCallWithValue(target, data, 0, errorMessage);
152     }
153 
154     /**
155      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
156      * but also transferring `value` wei to `target`.
157      *
158      * Requirements:
159      *
160      * - the calling contract must have an ETH balance of at least `value`.
161      * - the called Solidity function must be `payable`.
162      *
163      * _Available since v3.1._
164      */
165     function functionCallWithValue(
166         address target,
167         bytes memory data,
168         uint256 value
169     ) internal returns (bytes memory) {
170         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
175      * with `errorMessage` as a fallback revert reason when `target` reverts.
176      *
177      * _Available since v3.1._
178      */
179     function functionCallWithValue(
180         address target,
181         bytes memory data,
182         uint256 value,
183         string memory errorMessage
184     ) internal returns (bytes memory) {
185         require(address(this).balance >= value, "Address: insufficient balance for call");
186         require(isContract(target), "Address: call to non-contract");
187 
188         (bool success, bytes memory returndata) = target.call{value: value}(data);
189         return verifyCallResult(success, returndata, errorMessage);
190     }
191 
192     /**
193      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
194      * but performing a static call.
195      *
196      * _Available since v3.3._
197      */
198     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
199         return functionStaticCall(target, data, "Address: low-level static call failed");
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
204      * but performing a static call.
205      *
206      * _Available since v3.3._
207      */
208     function functionStaticCall(
209         address target,
210         bytes memory data,
211         string memory errorMessage
212     ) internal view returns (bytes memory) {
213         require(isContract(target), "Address: static call to non-contract");
214 
215         (bool success, bytes memory returndata) = target.staticcall(data);
216         return verifyCallResult(success, returndata, errorMessage);
217     }
218 
219     /**
220      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
221      * but performing a delegate call.
222      *
223      * _Available since v3.4._
224      */
225     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
226         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
231      * but performing a delegate call.
232      *
233      * _Available since v3.4._
234      */
235     function functionDelegateCall(
236         address target,
237         bytes memory data,
238         string memory errorMessage
239     ) internal returns (bytes memory) {
240         require(isContract(target), "Address: delegate call to non-contract");
241 
242         (bool success, bytes memory returndata) = target.delegatecall(data);
243         return verifyCallResult(success, returndata, errorMessage);
244     }
245 
246     /**
247      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
248      * revert reason using the provided one.
249      *
250      * _Available since v4.3._
251      */
252     function verifyCallResult(
253         bool success,
254         bytes memory returndata,
255         string memory errorMessage
256     ) internal pure returns (bytes memory) {
257         if (success) {
258             return returndata;
259         } else {
260             // Look for revert reason and bubble it up if present
261             if (returndata.length > 0) {
262                 // The easiest way to bubble the revert reason is using memory via assembly
263 
264                 assembly {
265                     let returndata_size := mload(returndata)
266                     revert(add(32, returndata), returndata_size)
267                 }
268             } else {
269                 revert(errorMessage);
270             }
271         }
272     }
273 }
274 
275 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
276 
277 
278 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
279 
280 pragma solidity ^0.8.0;
281 
282 /**
283  * @title ERC721 token receiver interface
284  * @dev Interface for any contract that wants to support safeTransfers
285  * from ERC721 asset contracts.
286  */
287 interface IERC721Receiver {
288     /**
289      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
290      * by `operator` from `from`, this function is called.
291      *
292      * It must return its Solidity selector to confirm the token transfer.
293      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
294      *
295      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
296      */
297     function onERC721Received(
298         address operator,
299         address from,
300         uint256 tokenId,
301         bytes calldata data
302     ) external returns (bytes4);
303 }
304 
305 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
306 
307 
308 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
309 
310 pragma solidity ^0.8.0;
311 
312 /**
313  * @dev Interface of the ERC165 standard, as defined in the
314  * https://eips.ethereum.org/EIPS/eip-165[EIP].
315  *
316  * Implementers can declare support of contract interfaces, which can then be
317  * queried by others ({ERC165Checker}).
318  *
319  * For an implementation, see {ERC165}.
320  */
321 interface IERC165 {
322     /**
323      * @dev Returns true if this contract implements the interface defined by
324      * `interfaceId`. See the corresponding
325      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
326      * to learn more about how these ids are created.
327      *
328      * This function call must use less than 30 000 gas.
329      */
330     function supportsInterface(bytes4 interfaceId) external view returns (bool);
331 }
332 
333 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
334 
335 
336 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
337 
338 pragma solidity ^0.8.0;
339 
340 
341 /**
342  * @dev Implementation of the {IERC165} interface.
343  *
344  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
345  * for the additional interface id that will be supported. For example:
346  *
347  * ```solidity
348  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
349  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
350  * }
351  * ```
352  *
353  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
354  */
355 abstract contract ERC165 is IERC165 {
356     /**
357      * @dev See {IERC165-supportsInterface}.
358      */
359     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
360         return interfaceId == type(IERC165).interfaceId;
361     }
362 }
363 
364 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
365 
366 
367 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
368 
369 pragma solidity ^0.8.0;
370 
371 
372 /**
373  * @dev Required interface of an ERC721 compliant contract.
374  */
375 interface IERC721 is IERC165 {
376     /**
377      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
378      */
379     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
380 
381     /**
382      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
383      */
384     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
385 
386     /**
387      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
388      */
389     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
390 
391     /**
392      * @dev Returns the number of tokens in ``owner``'s account.
393      */
394     function balanceOf(address owner) external view returns (uint256 balance);
395 
396     /**
397      * @dev Returns the owner of the `tokenId` token.
398      *
399      * Requirements:
400      *
401      * - `tokenId` must exist.
402      */
403     function ownerOf(uint256 tokenId) external view returns (address owner);
404 
405     /**
406      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
407      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
408      *
409      * Requirements:
410      *
411      * - `from` cannot be the zero address.
412      * - `to` cannot be the zero address.
413      * - `tokenId` token must exist and be owned by `from`.
414      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
415      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
416      *
417      * Emits a {Transfer} event.
418      */
419     function safeTransferFrom(
420         address from,
421         address to,
422         uint256 tokenId
423     ) external;
424 
425     /**
426      * @dev Transfers `tokenId` token from `from` to `to`.
427      *
428      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
429      *
430      * Requirements:
431      *
432      * - `from` cannot be the zero address.
433      * - `to` cannot be the zero address.
434      * - `tokenId` token must be owned by `from`.
435      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
436      *
437      * Emits a {Transfer} event.
438      */
439     function transferFrom(
440         address from,
441         address to,
442         uint256 tokenId
443     ) external;
444 
445     /**
446      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
447      * The approval is cleared when the token is transferred.
448      *
449      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
450      *
451      * Requirements:
452      *
453      * - The caller must own the token or be an approved operator.
454      * - `tokenId` must exist.
455      *
456      * Emits an {Approval} event.
457      */
458     function approve(address to, uint256 tokenId) external;
459 
460     /**
461      * @dev Returns the account approved for `tokenId` token.
462      *
463      * Requirements:
464      *
465      * - `tokenId` must exist.
466      */
467     function getApproved(uint256 tokenId) external view returns (address operator);
468 
469     /**
470      * @dev Approve or remove `operator` as an operator for the caller.
471      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
472      *
473      * Requirements:
474      *
475      * - The `operator` cannot be the caller.
476      *
477      * Emits an {ApprovalForAll} event.
478      */
479     function setApprovalForAll(address operator, bool _approved) external;
480 
481     /**
482      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
483      *
484      * See {setApprovalForAll}
485      */
486     function isApprovedForAll(address owner, address operator) external view returns (bool);
487 
488     /**
489      * @dev Safely transfers `tokenId` token from `from` to `to`.
490      *
491      * Requirements:
492      *
493      * - `from` cannot be the zero address.
494      * - `to` cannot be the zero address.
495      * - `tokenId` token must exist and be owned by `from`.
496      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
497      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
498      *
499      * Emits a {Transfer} event.
500      */
501     function safeTransferFrom(
502         address from,
503         address to,
504         uint256 tokenId,
505         bytes calldata data
506     ) external;
507 }
508 
509 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
510 
511 
512 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
513 
514 pragma solidity ^0.8.0;
515 
516 
517 /**
518  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
519  * @dev See https://eips.ethereum.org/EIPS/eip-721
520  */
521 interface IERC721Enumerable is IERC721 {
522     /**
523      * @dev Returns the total amount of tokens stored by the contract.
524      */
525     function totalSupply() external view returns (uint256);
526 
527     /**
528      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
529      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
530      */
531     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
532 
533     /**
534      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
535      * Use along with {totalSupply} to enumerate all tokens.
536      */
537     function tokenByIndex(uint256 index) external view returns (uint256);
538 }
539 
540 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
541 
542 
543 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
544 
545 pragma solidity ^0.8.0;
546 
547 
548 /**
549  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
550  * @dev See https://eips.ethereum.org/EIPS/eip-721
551  */
552 interface IERC721Metadata is IERC721 {
553     /**
554      * @dev Returns the token collection name.
555      */
556     function name() external view returns (string memory);
557 
558     /**
559      * @dev Returns the token collection symbol.
560      */
561     function symbol() external view returns (string memory);
562 
563     /**
564      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
565      */
566     function tokenURI(uint256 tokenId) external view returns (string memory);
567 }
568 
569 // File: @openzeppelin/contracts/utils/Strings.sol
570 
571 
572 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
573 
574 pragma solidity ^0.8.0;
575 
576 /**
577  * @dev String operations.
578  */
579 library Strings {
580     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
581 
582     /**
583      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
584      */
585     function toString(uint256 value) internal pure returns (string memory) {
586         // Inspired by OraclizeAPI's implementation - MIT licence
587         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
588 
589         if (value == 0) {
590             return "0";
591         }
592         uint256 temp = value;
593         uint256 digits;
594         while (temp != 0) {
595             digits++;
596             temp /= 10;
597         }
598         bytes memory buffer = new bytes(digits);
599         while (value != 0) {
600             digits -= 1;
601             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
602             value /= 10;
603         }
604         return string(buffer);
605     }
606 
607     /**
608      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
609      */
610     function toHexString(uint256 value) internal pure returns (string memory) {
611         if (value == 0) {
612             return "0x00";
613         }
614         uint256 temp = value;
615         uint256 length = 0;
616         while (temp != 0) {
617             length++;
618             temp >>= 8;
619         }
620         return toHexString(value, length);
621     }
622 
623     /**
624      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
625      */
626     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
627         bytes memory buffer = new bytes(2 * length + 2);
628         buffer[0] = "0";
629         buffer[1] = "x";
630         for (uint256 i = 2 * length + 1; i > 1; --i) {
631             buffer[i] = _HEX_SYMBOLS[value & 0xf];
632             value >>= 4;
633         }
634         require(value == 0, "Strings: hex length insufficient");
635         return string(buffer);
636     }
637 }
638 
639 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
640 
641 
642 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
643 
644 pragma solidity ^0.8.0;
645 
646 /**
647  * @dev These functions deal with verification of Merkle Trees proofs.
648  *
649  * The proofs can be generated using the JavaScript library
650  * https://github.com/miguelmota/merkletreejs[merkletreejs].
651  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
652  *
653  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
654  */
655 library MerkleProof {
656     /**
657      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
658      * defined by `root`. For this, a `proof` must be provided, containing
659      * sibling hashes on the branch from the leaf to the root of the tree. Each
660      * pair of leaves and each pair of pre-images are assumed to be sorted.
661      */
662     function verify(
663         bytes32[] memory proof,
664         bytes32 root,
665         bytes32 leaf
666     ) internal pure returns (bool) {
667         return processProof(proof, leaf) == root;
668     }
669 
670     /**
671      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
672      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
673      * hash matches the root of the tree. When processing the proof, the pairs
674      * of leafs & pre-images are assumed to be sorted.
675      *
676      * _Available since v4.4._
677      */
678     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
679         bytes32 computedHash = leaf;
680         for (uint256 i = 0; i < proof.length; i++) {
681             bytes32 proofElement = proof[i];
682             if (computedHash <= proofElement) {
683                 // Hash(current computed hash + current element of the proof)
684                 computedHash = _efficientHash(computedHash, proofElement);
685             } else {
686                 // Hash(current element of the proof + current computed hash)
687                 computedHash = _efficientHash(proofElement, computedHash);
688             }
689         }
690         return computedHash;
691     }
692 
693     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
694         assembly {
695             mstore(0x00, a)
696             mstore(0x20, b)
697             value := keccak256(0x00, 0x40)
698         }
699     }
700 }
701 
702 // File: @openzeppelin/contracts/utils/Context.sol
703 
704 
705 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
706 
707 pragma solidity ^0.8.0;
708 
709 /**
710  * @dev Provides information about the current execution context, including the
711  * sender of the transaction and its data. While these are generally available
712  * via msg.sender and msg.data, they should not be accessed in such a direct
713  * manner, since when dealing with meta-transactions the account sending and
714  * paying for execution may not be the actual sender (as far as an application
715  * is concerned).
716  *
717  * This contract is only required for intermediate, library-like contracts.
718  */
719 abstract contract Context {
720     function _msgSender() internal view virtual returns (address) {
721         return msg.sender;
722     }
723 
724     function _msgData() internal view virtual returns (bytes calldata) {
725         return msg.data;
726     }
727 }
728 
729 // File: @openzeppelin/contracts/access/Ownable.sol
730 
731 
732 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
733 
734 pragma solidity ^0.8.0;
735 
736 
737 /**
738  * @dev Contract module which provides a basic access control mechanism, where
739  * there is an account (an owner) that can be granted exclusive access to
740  * specific functions.
741  *
742  * By default, the owner account will be the one that deploys the contract. This
743  * can later be changed with {transferOwnership}.
744  *
745  * This module is used through inheritance. It will make available the modifier
746  * `onlyOwner`, which can be applied to your functions to restrict their use to
747  * the owner.
748  */
749 abstract contract Ownable is Context {
750     address private _owner;
751 
752     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
753 
754     /**
755      * @dev Initializes the contract setting the deployer as the initial owner.
756      */
757     constructor() {
758         _transferOwnership(_msgSender());
759     }
760 
761     /**
762      * @dev Returns the address of the current owner.
763      */
764     function owner() public view virtual returns (address) {
765         return _owner;
766     }
767 
768     /**
769      * @dev Throws if called by any account other than the owner.
770      */
771     modifier onlyOwner() {
772         require(owner() == _msgSender(), "Ownable: caller is not the owner");
773         _;
774     }
775 
776     /**
777      * @dev Leaves the contract without owner. It will not be possible to call
778      * `onlyOwner` functions anymore. Can only be called by the current owner.
779      *
780      * NOTE: Renouncing ownership will leave the contract without an owner,
781      * thereby removing any functionality that is only available to the owner.
782      */
783     function renounceOwnership() public virtual onlyOwner {
784         _transferOwnership(address(0));
785     }
786 
787     /**
788      * @dev Transfers ownership of the contract to a new account (`newOwner`).
789      * Can only be called by the current owner.
790      */
791     function transferOwnership(address newOwner) public virtual onlyOwner {
792         require(newOwner != address(0), "Ownable: new owner is the zero address");
793         _transferOwnership(newOwner);
794     }
795 
796     /**
797      * @dev Transfers ownership of the contract to a new account (`newOwner`).
798      * Internal function without access restriction.
799      */
800     function _transferOwnership(address newOwner) internal virtual {
801         address oldOwner = _owner;
802         _owner = newOwner;
803         emit OwnershipTransferred(oldOwner, newOwner);
804     }
805 }
806 
807 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
808 
809 
810 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
811 
812 pragma solidity ^0.8.0;
813 
814 /**
815  * @dev Contract module that helps prevent reentrant calls to a function.
816  *
817  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
818  * available, which can be applied to functions to make sure there are no nested
819  * (reentrant) calls to them.
820  *
821  * Note that because there is a single `nonReentrant` guard, functions marked as
822  * `nonReentrant` may not call one another. This can be worked around by making
823  * those functions `private`, and then adding `external` `nonReentrant` entry
824  * points to them.
825  *
826  * TIP: If you would like to learn more about reentrancy and alternative ways
827  * to protect against it, check out our blog post
828  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
829  */
830 abstract contract ReentrancyGuard {
831     // Booleans are more expensive than uint256 or any type that takes up a full
832     // word because each write operation emits an extra SLOAD to first read the
833     // slot's contents, replace the bits taken up by the boolean, and then write
834     // back. This is the compiler's defense against contract upgrades and
835     // pointer aliasing, and it cannot be disabled.
836 
837     // The values being non-zero value makes deployment a bit more expensive,
838     // but in exchange the refund on every call to nonReentrant will be lower in
839     // amount. Since refunds are capped to a percentage of the total
840     // transaction's gas, it is best to keep them low in cases like this one, to
841     // increase the likelihood of the full refund coming into effect.
842     uint256 private constant _NOT_ENTERED = 1;
843     uint256 private constant _ENTERED = 2;
844 
845     uint256 private _status;
846 
847     constructor() {
848         _status = _NOT_ENTERED;
849     }
850 
851     /**
852      * @dev Prevents a contract from calling itself, directly or indirectly.
853      * Calling a `nonReentrant` function from another `nonReentrant`
854      * function is not supported. It is possible to prevent this from happening
855      * by making the `nonReentrant` function external, and making it call a
856      * `private` function that does the actual work.
857      */
858     modifier nonReentrant() {
859         // On the first call to nonReentrant, _notEntered will be true
860         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
861 
862         // Any calls to nonReentrant after this point will fail
863         _status = _ENTERED;
864 
865         _;
866 
867         // By storing the original value once again, a refund is triggered (see
868         // https://eips.ethereum.org/EIPS/eip-2200)
869         _status = _NOT_ENTERED;
870     }
871 }
872 
873 
874 pragma solidity ^0.8.0;
875 
876 
877 /**ERC721A import
878  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
879  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
880  *
881  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
882  *
883  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
884  *
885  * Does not support burning tokens to address(0).
886  */
887 contract ERC721A is
888   Context,
889   ERC165,
890   IERC721,
891   IERC721Metadata,
892   IERC721Enumerable
893 {
894   using Address for address;
895   using Strings for uint256;
896 
897   struct TokenOwnership {
898     address addr;
899     uint64 startTimestamp;
900   }
901 
902   struct AddressData {
903     uint128 balance;
904     uint128 numberMinted;
905   }
906 
907   uint256 private currentIndex = 0;
908 
909   uint256 internal immutable collectionSize;
910   uint256 internal immutable maxBatchSize;
911 
912   // Token name
913   string private _name;
914 
915   // Token symbol
916   string private _symbol;
917 
918   // Mapping from token ID to ownership details
919   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
920   mapping(uint256 => TokenOwnership) private _ownerships;
921 
922   // Mapping owner address to address data
923   mapping(address => AddressData) private _addressData;
924 
925   // Mapping from token ID to approved address
926   mapping(uint256 => address) private _tokenApprovals;
927 
928   // Mapping from owner to operator approvals
929   mapping(address => mapping(address => bool)) private _operatorApprovals;
930 
931   /**
932    * @dev
933    * `maxBatchSize` refers to how much a minter can mint at a time.
934    * `collectionSize_` refers to how many tokens are in the collection.
935    */
936   constructor(
937     string memory name_,
938     string memory symbol_,
939     uint256 maxBatchSize_,
940     uint256 collectionSize_
941   ) {
942     require(
943       collectionSize_ > 0,
944       "ERC721A: collection must have a nonzero supply"
945     );
946     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
947     _name = name_;
948     _symbol = symbol_;
949     maxBatchSize = maxBatchSize_;
950     collectionSize = collectionSize_;
951   }
952 
953   /**
954    * @dev See {IERC721Enumerable-totalSupply}.
955    */
956   function totalSupply() public view override returns (uint256) {
957     return currentIndex;
958   }
959 
960   /**
961    * @dev See {IERC721Enumerable-tokenByIndex}.
962    */
963   function tokenByIndex(uint256 index) public view override returns (uint256) {
964     require(index < totalSupply(), "ERC721A: global index out of bounds");
965     return index;
966   }
967 
968   /**
969    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
970    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
971    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
972    */
973   function tokenOfOwnerByIndex(address owner, uint256 index)
974     public
975     view
976     override
977     returns (uint256)
978   {
979     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
980     uint256 numMintedSoFar = totalSupply();
981     uint256 tokenIdsIdx = 0;
982     address currOwnershipAddr = address(0);
983     for (uint256 i = 0; i < numMintedSoFar; i++) {
984       TokenOwnership memory ownership = _ownerships[i];
985       if (ownership.addr != address(0)) {
986         currOwnershipAddr = ownership.addr;
987       }
988       if (currOwnershipAddr == owner) {
989         if (tokenIdsIdx == index) {
990           return i;
991         }
992         tokenIdsIdx++;
993       }
994     }
995     revert("ERC721A: unable to get token of owner by index");
996   }
997 
998   /**
999    * @dev See {IERC165-supportsInterface}.
1000    */
1001   function supportsInterface(bytes4 interfaceId)
1002     public
1003     view
1004     virtual
1005     override(ERC165, IERC165)
1006     returns (bool)
1007   {
1008     return
1009       interfaceId == type(IERC721).interfaceId ||
1010       interfaceId == type(IERC721Metadata).interfaceId ||
1011       interfaceId == type(IERC721Enumerable).interfaceId ||
1012       super.supportsInterface(interfaceId);
1013   }
1014 
1015   /**
1016    * @dev See {IERC721-balanceOf}.
1017    */
1018   function balanceOf(address owner) public view override returns (uint256) {
1019     require(owner != address(0), "ERC721A: balance query for the zero address");
1020     return uint256(_addressData[owner].balance);
1021   }
1022 
1023   function _numberMinted(address owner) internal view returns (uint256) {
1024     require(
1025       owner != address(0),
1026       "ERC721A: number minted query for the zero address"
1027     );
1028     return uint256(_addressData[owner].numberMinted);
1029   }
1030 
1031   function ownershipOf(uint256 tokenId)
1032     internal
1033     view
1034     returns (TokenOwnership memory)
1035   {
1036     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1037 
1038     uint256 lowestTokenToCheck;
1039     if (tokenId >= maxBatchSize) {
1040       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1041     }
1042 
1043     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1044       TokenOwnership memory ownership = _ownerships[curr];
1045       if (ownership.addr != address(0)) {
1046         return ownership;
1047       }
1048     }
1049 
1050     revert("ERC721A: unable to determine the owner of token");
1051   }
1052 
1053   /**
1054    * @dev See {IERC721-ownerOf}.
1055    */
1056   function ownerOf(uint256 tokenId) public view override returns (address) {
1057     return ownershipOf(tokenId).addr;
1058   }
1059 
1060   /**
1061    * @dev See {IERC721Metadata-name}.
1062    */
1063   function name() public view virtual override returns (string memory) {
1064     return _name;
1065   }
1066 
1067   /**
1068    * @dev See {IERC721Metadata-symbol}.
1069    */
1070   function symbol() public view virtual override returns (string memory) {
1071     return _symbol;
1072   }
1073 
1074   /**
1075    * @dev See {IERC721Metadata-tokenURI}.
1076    */
1077   function tokenURI(uint256 tokenId)
1078     public
1079     view
1080     virtual
1081     override
1082     returns (string memory)
1083   {
1084     require(
1085       _exists(tokenId),
1086       "ERC721Metadata: URI query for nonexistent token"
1087     );
1088 
1089     string memory baseURI = _baseURI();
1090     return
1091       bytes(baseURI).length > 0
1092         ? string(abi.encodePacked(baseURI, tokenId.toString(),".json"))
1093         : "";
1094   }
1095 
1096   /**
1097    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1098    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1099    * by default, can be overriden in child contracts.
1100    */
1101   function _baseURI() internal view virtual returns (string memory) {
1102     return "";
1103   }
1104 
1105   /**
1106    * @dev See {IERC721-approve}.
1107    */
1108   function approve(address to, uint256 tokenId) public override {
1109     address owner = ERC721A.ownerOf(tokenId);
1110     require(to != owner, "ERC721A: approval to current owner");
1111 
1112     require(
1113       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1114       "ERC721A: approve caller is not owner nor approved for all"
1115     );
1116 
1117     _approve(to, tokenId, owner);
1118   }
1119 
1120   /**
1121    * @dev See {IERC721-getApproved}.
1122    */
1123   function getApproved(uint256 tokenId) public view override returns (address) {
1124     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1125 
1126     return _tokenApprovals[tokenId];
1127   }
1128 
1129   /**
1130    * @dev See {IERC721-setApprovalForAll}.
1131    */
1132   function setApprovalForAll(address operator, bool approved) public override {
1133     require(operator != _msgSender(), "ERC721A: approve to caller");
1134 
1135     _operatorApprovals[_msgSender()][operator] = approved;
1136     emit ApprovalForAll(_msgSender(), operator, approved);
1137   }
1138 
1139   /**
1140    * @dev See {IERC721-isApprovedForAll}.
1141    */
1142   function isApprovedForAll(address owner, address operator)
1143     public
1144     view
1145     virtual
1146     override
1147     returns (bool)
1148   {
1149     return _operatorApprovals[owner][operator];
1150   }
1151 
1152   /**
1153    * @dev See {IERC721-transferFrom}.
1154    */
1155   function transferFrom(
1156     address from,
1157     address to,
1158     uint256 tokenId
1159   ) public override {
1160     _transfer(from, to, tokenId);
1161   }
1162 
1163   /**
1164    * @dev See {IERC721-safeTransferFrom}.
1165    */
1166   function safeTransferFrom(
1167     address from,
1168     address to,
1169     uint256 tokenId
1170   ) public override {
1171     safeTransferFrom(from, to, tokenId, "");
1172   }
1173 
1174   /**
1175    * @dev See {IERC721-safeTransferFrom}.
1176    */
1177   function safeTransferFrom(
1178     address from,
1179     address to,
1180     uint256 tokenId,
1181     bytes memory _data
1182   ) public override {
1183     _transfer(from, to, tokenId);
1184     require(
1185       _checkOnERC721Received(from, to, tokenId, _data),
1186       "ERC721A: transfer to non ERC721Receiver implementer"
1187     );
1188   }
1189 
1190   /**
1191    * @dev Returns whether `tokenId` exists.
1192    *
1193    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1194    *
1195    * Tokens start existing when they are minted (`_mint`),
1196    */
1197   function _exists(uint256 tokenId) internal view returns (bool) {
1198     return tokenId < currentIndex;
1199   }
1200 
1201   function _safeMint(address to, uint256 quantity) internal {
1202     _safeMint(to, quantity, "");
1203   }
1204 
1205   /**
1206    * @dev Mints `quantity` tokens and transfers them to `to`.
1207    *
1208    * Requirements:
1209    *
1210    * - there must be `quantity` tokens remaining unminted in the total collection.
1211    * - `to` cannot be the zero address.
1212    * - `quantity` cannot be larger than the max batch size.
1213    *
1214    * Emits a {Transfer} event.
1215    */
1216   function _safeMint(
1217     address to,
1218     uint256 quantity,
1219     bytes memory _data
1220   ) internal {
1221     uint256 startTokenId = currentIndex;
1222     require(to != address(0), "ERC721A: mint to the zero address");
1223     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1224     require(!_exists(startTokenId), "ERC721A: token already minted");
1225     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1226 
1227     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1228 
1229     AddressData memory addressData = _addressData[to];
1230     _addressData[to] = AddressData(
1231       addressData.balance + uint128(quantity),
1232       addressData.numberMinted + uint128(quantity)
1233     );
1234     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1235 
1236     uint256 updatedIndex = startTokenId;
1237 
1238     for (uint256 i = 0; i < quantity; i++) {
1239       emit Transfer(address(0), to, updatedIndex);
1240       require(
1241         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1242         "ERC721A: transfer to non ERC721Receiver implementer"
1243       );
1244       updatedIndex++;
1245     }
1246 
1247     currentIndex = updatedIndex;
1248     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1249   }
1250 
1251   /**
1252    * @dev Transfers `tokenId` from `from` to `to`.
1253    *
1254    * Requirements:
1255    *
1256    * - `to` cannot be the zero address.
1257    * - `tokenId` token must be owned by `from`.
1258    *
1259    * Emits a {Transfer} event.
1260    */
1261   function _transfer(
1262     address from,
1263     address to,
1264     uint256 tokenId
1265   ) private {
1266     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1267 
1268     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1269       getApproved(tokenId) == _msgSender() ||
1270       isApprovedForAll(prevOwnership.addr, _msgSender()));
1271 
1272     require(
1273       isApprovedOrOwner,
1274       "ERC721A: transfer caller is not owner nor approved"
1275     );
1276 
1277     require(
1278       prevOwnership.addr == from,
1279       "ERC721A: transfer from incorrect owner"
1280     );
1281     require(to != address(0), "ERC721A: transfer to the zero address");
1282 
1283     _beforeTokenTransfers(from, to, tokenId, 1);
1284 
1285     // Clear approvals from the previous owner
1286     _approve(address(0), tokenId, prevOwnership.addr);
1287 
1288     _addressData[from].balance -= 1;
1289     _addressData[to].balance += 1;
1290     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1291 
1292     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1293     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1294     uint256 nextTokenId = tokenId + 1;
1295     if (_ownerships[nextTokenId].addr == address(0)) {
1296       if (_exists(nextTokenId)) {
1297         _ownerships[nextTokenId] = TokenOwnership(
1298           prevOwnership.addr,
1299           prevOwnership.startTimestamp
1300         );
1301       }
1302     }
1303 
1304     emit Transfer(from, to, tokenId);
1305     _afterTokenTransfers(from, to, tokenId, 1);
1306   }
1307 
1308   /**
1309    * @dev Approve `to` to operate on `tokenId`
1310    *
1311    * Emits a {Approval} event.
1312    */
1313   function _approve(
1314     address to,
1315     uint256 tokenId,
1316     address owner
1317   ) private {
1318     _tokenApprovals[tokenId] = to;
1319     emit Approval(owner, to, tokenId);
1320   }
1321 
1322   uint256 public nextOwnerToExplicitlySet = 0;
1323 
1324   /**
1325    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1326    */
1327   function _setOwnersExplicit(uint256 quantity) internal {
1328     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1329     require(quantity > 0, "quantity must be nonzero");
1330     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1331     if (endIndex > collectionSize - 1) {
1332       endIndex = collectionSize - 1;
1333     }
1334     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1335     require(_exists(endIndex), "not enough minted yet for this cleanup");
1336     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1337       if (_ownerships[i].addr == address(0)) {
1338         TokenOwnership memory ownership = ownershipOf(i);
1339         _ownerships[i] = TokenOwnership(
1340           ownership.addr,
1341           ownership.startTimestamp
1342         );
1343       }
1344     }
1345     nextOwnerToExplicitlySet = endIndex + 1;
1346   }
1347 
1348   /**
1349    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1350    * The call is not executed if the target address is not a contract.
1351    *
1352    * @param from address representing the previous owner of the given token ID
1353    * @param to target address that will receive the tokens
1354    * @param tokenId uint256 ID of the token to be transferred
1355    * @param _data bytes optional data to send along with the call
1356    * @return bool whether the call correctly returned the expected magic value
1357    */
1358   function _checkOnERC721Received(
1359     address from,
1360     address to,
1361     uint256 tokenId,
1362     bytes memory _data
1363   ) private returns (bool) {
1364     if (to.isContract()) {
1365       try
1366         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1367       returns (bytes4 retval) {
1368         return retval == IERC721Receiver(to).onERC721Received.selector;
1369       } catch (bytes memory reason) {
1370         if (reason.length == 0) {
1371           revert("ERC721A: transfer to non ERC721Receiver implementer");
1372         } else {
1373           assembly {
1374             revert(add(32, reason), mload(reason))
1375           }
1376         }
1377       }
1378     } else {
1379       return true;
1380     }
1381   }
1382 
1383   /**
1384    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1385    *
1386    * startTokenId - the first token id to be transferred
1387    * quantity - the amount to be transferred
1388    *
1389    * Calling conditions:
1390    *
1391    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1392    * transferred to `to`.
1393    * - When `from` is zero, `tokenId` will be minted for `to`.
1394    */
1395   function _beforeTokenTransfers(
1396     address from,
1397     address to,
1398     uint256 startTokenId,
1399     uint256 quantity
1400   ) internal virtual {}
1401 
1402   /**
1403    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1404    * minting.
1405    *
1406    * startTokenId - the first token id to be transferred
1407    * quantity - the amount to be transferred
1408    *
1409    * Calling conditions:
1410    *
1411    * - when `from` and `to` are both non-zero.
1412    * - `from` and `to` are never both zero.
1413    */
1414   function _afterTokenTransfers(
1415     address from,
1416     address to,
1417     uint256 startTokenId,
1418     uint256 quantity
1419   ) internal virtual {}
1420 }
1421 
1422 /////////// █     █░ ▄▄▄▄     ██████  ▄████▄  
1423 ///////////▓█░ █ ░█░▓█████▄ ▒██    ▒ ▒██▀ ▀█  
1424 ///////////▒█░ █ ░█ ▒██▒ ▄██░ ▓██▄   ▒▓█    ▄ 
1425 ///////////░█░ █ ░█ ▒██░█▀    ▒   ██▒▒▓▓▄ ▄██▒
1426 ///////////░░██▒██▓ ░▓█  ▀█▓▒██████▒▒▒ ▓███▀ ░
1427 ///////////░ ▓░▒ ▒  ░▒▓███▀▒▒ ▒▓▒ ▒ ░░ ░▒ ▒  ░
1428 ///////////  ▒ ░ ░  ▒░▒   ░ ░ ░▒  ░ ░  ░  ▒   
1429 ///////////  ░   ░   ░    ░ ░  ░  ░  ░        
1430 ///////////    ░     ░            ░  ░ ░      
1431 ///////////               ░          ░   
1432 
1433 
1434 library OpenSeaGasFreeListing {
1435     /**
1436     @notice Returns whether the operator is an OpenSea proxy for the owner, thus
1437     allowing it to list without the token owner paying gas.
1438     @dev ERC{721,1155}.isApprovedForAll should be overriden to also check if
1439     this function returns true.
1440      */
1441     function isApprovedForAll(address owner, address operator) internal view returns (bool) {
1442         ProxyRegistry registry;
1443         assembly {
1444             switch chainid()
1445             case 1 {
1446                 // mainnet
1447                 registry := 0xa5409ec958c83c3f309868babaca7c86dcb077c1
1448             }
1449             case 4 {
1450                 // rinkeby
1451                 registry := 0xf57b2c51ded3a29e6891aba85459d600256cf317
1452             }
1453         }
1454 
1455         return address(registry) != address(0) && (address(registry.proxies(owner)) == operator);
1456     }
1457 }
1458 
1459 contract OwnableDelegateProxy {}
1460 
1461 contract ProxyRegistry {
1462     mapping(address => OwnableDelegateProxy) public proxies;
1463 }
1464 
1465 
1466 contract WBSC is Ownable, ERC721A, ReentrancyGuard {
1467 
1468     using Address for address;
1469     using Strings for uint256;
1470 
1471     //allows for 152 tokens to be minted for team reserves to use as needed/planned 
1472     uint256 public MAX_TEAM_RESERVES_PRESALE = 152;
1473     //sets immutable value for total collection of 4444 
1474     uint256 public immutable MAX_TOKENS;
1475     //sets value for total of 800 OG tokens
1476     uint256 public MAX_OG = 800;
1477     //sets value for total of 2400 WL tokens
1478     uint256 public MAX_WL = 2400;
1479     //sets value for total of 1092 PUBLIC1 tokens
1480     uint256 public MAX_PUBLIC1 = 1092;
1481     //limits the number of tokens during OG presale per address
1482     uint256 public MAX_OG_TOKENS_PER_ADDRESS = 4;
1483     //limits the number of tokens during presale per address
1484     uint256 public MAX_WL_TOKENS_PER_ADDRESS = 2;
1485     //limits the number of tokens during pubic 1 sale per address
1486     uint256 public MAX_PUBLIC1_TOKENS_PER_ADDRESS = 4;
1487     //limits the number of tokens during pubic 2 sale per address
1488     uint256 public MAX_PUBLIC2_TOKENS_PER_ADDRESS = 10;
1489     //OG presale token price
1490     uint256 public OG_TOKEN_PRICE = 0.04 ether;
1491     //OG presale token price
1492     uint256 public WL_TOKEN_PRICE = 0.05 ether;
1493     //public token price
1494     uint256 public TOKEN_PRICE = 0.06 ether;
1495     //max mints per tx during the public mint
1496     uint256 public MAX_MINTS_PER_TX = 50;
1497 
1498     bool public OGsale = false;
1499     bool public WLsale = false;
1500     bool public Public1Sale = false;
1501     bool public Public2Sale = false;
1502     string public WBSCprovenance;
1503 
1504         // OG merkle root
1505     bytes32 public OGmerkleroot;
1506 
1507         // whitelist merkle root
1508     bytes32 public WLmerkleroot;
1509 
1510         // public merkle root
1511     bytes32 public Public1merkleroot;
1512 
1513     //tracks number a user has minted during OG sale
1514     mapping (address => uint) public OGNumMinted;
1515 
1516     //tracks number a user has minted during WL sale
1517     mapping (address => uint) public WLNumMinted;
1518 
1519     //tracks number a user has minted during Public1 sale
1520     mapping (address => uint) public Public1NumMinted;
1521 
1522     //tracks number a user has minted during Public2 sale
1523     mapping (address => uint) public Public2NumMinted;
1524 
1525     constructor(
1526     uint256 maxBatchSize_,
1527     uint256 collectionSize_,
1528     uint256 maxTOKENS_
1529   ) ERC721A("wulf boy social club","WBSC", maxBatchSize_,collectionSize_) {
1530     MAX_MINTS_PER_TX = maxBatchSize_;
1531     MAX_TOKENS = maxTOKENS_;
1532     require(
1533         maxTOKENS_ <= collectionSize_,
1534         "larger collection size needed"
1535     );   
1536   }
1537 
1538   modifier callerIsUser() {
1539     require(tx.origin == msg.sender, "The caller is another contract");
1540     _;
1541   }
1542 
1543 //minting function for the OG sale
1544     function OGsaleMint(uint256 quantity, bytes32[] calldata OGsaleMerkleProof) external payable callerIsUser nonReentrant {
1545         require(OGsale, "OG sale is not live");
1546         require(quantity <= MAX_OG, "minting this many would exceed supply for OG");
1547         MAX_OG -= quantity;
1548         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1549         require(MerkleProof.verify(OGsaleMerkleProof, OGmerkleroot, leaf), "Invalid proof.");
1550         _checkOGPreMintRequirements(quantity);
1551         _safeMint(msg.sender, quantity);
1552     }
1553 
1554     function _checkOGPreMintRequirements(uint256 quantity) internal {
1555         require(quantity > 0 && quantity <= MAX_OG_TOKENS_PER_ADDRESS, "invalid quantity: zero or greater than mint allowance");
1556         require(totalSupply() + quantity <= MAX_TOKENS);
1557         require(msg.value == OG_TOKEN_PRICE * quantity, "wrong amount of ether sent");
1558         OGNumMinted[msg.sender] = OGNumMinted[msg.sender] + quantity;
1559         require(OGNumMinted[msg.sender] <= MAX_OG_TOKENS_PER_ADDRESS, "Cannot mint more than your allotment in this phase");
1560     }
1561 
1562 //minting function for the WL sale
1563     function WLsaleMint(uint256 quantity, bytes32[] calldata WLsaleMerkleProof) external payable callerIsUser nonReentrant {
1564         require(WLsale, "WL sale is not live");
1565         require(quantity <= MAX_WL, "minting this many would exceed supply for WL");
1566         MAX_WL -= quantity;
1567         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1568         require(MerkleProof.verify(WLsaleMerkleProof, WLmerkleroot, leaf), "Invalid proof.");
1569         _checkWLPreMintRequirements(quantity);
1570         _safeMint(msg.sender, quantity);
1571     }
1572 
1573     function _checkWLPreMintRequirements(uint256 quantity) internal {
1574         require(quantity > 0 && quantity <= MAX_WL_TOKENS_PER_ADDRESS, "invalid quantity: zero or greater than mint allowance");
1575         require(totalSupply() + quantity <= MAX_TOKENS);
1576         require(msg.value == WL_TOKEN_PRICE * quantity, "wrong amount of ether sent");
1577         WLNumMinted[msg.sender] = WLNumMinted[msg.sender] + quantity;
1578         require(WLNumMinted[msg.sender] <= MAX_WL_TOKENS_PER_ADDRESS, "Cannot mint more than your allotment in this phase");
1579     }
1580 
1581 //minting function for the Public1 raffle sale
1582     function Public1saleMint(uint256 quantity, bytes32[] calldata Public1saleMerkleProof) external payable callerIsUser nonReentrant {
1583         require(Public1Sale, "Public1 sale is not live");
1584         require(quantity <= MAX_PUBLIC1, "minting this many would exceed supply for Public1");
1585         MAX_PUBLIC1 -= quantity;
1586         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1587         require(MerkleProof.verify(Public1saleMerkleProof, Public1merkleroot, leaf), "Invalid proof.");
1588         _checkPublic1MintRequirements(quantity);
1589         _safeMint(msg.sender, quantity);
1590     }
1591 
1592     function _checkPublic1MintRequirements(uint256 quantity) internal {
1593         require(quantity > 0 && quantity <= MAX_PUBLIC1_TOKENS_PER_ADDRESS, "invalid quantity: zero or greater than mint allowance");
1594         require(totalSupply() + quantity <= MAX_TOKENS);
1595         require(msg.value == TOKEN_PRICE * quantity, "wrong amount of ether sent");
1596         Public1NumMinted[msg.sender] = Public1NumMinted[msg.sender] + quantity;
1597         require(Public1NumMinted[msg.sender] <= MAX_PUBLIC1_TOKENS_PER_ADDRESS, "Cannot mint more than your allotment in this phase");
1598     }
1599 
1600 
1601 //public2 mint function
1602     function mint(uint256 quantity) external payable callerIsUser nonReentrant {
1603         require(Public2Sale, "public sale 2 is not live");
1604         require(totalSupply() + quantity <= MAX_TOKENS, "invalid quantity: would exceed max supply");
1605         _checkMintRequirements(quantity);
1606         _safeMint(msg.sender, quantity);
1607     }
1608 
1609     function _checkMintRequirements(uint256 quantity) internal {
1610         require(quantity > 0 && quantity <= MAX_PUBLIC2_TOKENS_PER_ADDRESS, "invalid quantity: zero or greater than mint allowance");
1611         require(quantity > 0 && quantity <= MAX_MINTS_PER_TX, "invalid quantity: zero or greater than mint allowance");
1612         require(msg.value == TOKEN_PRICE * quantity, "wrong amount of ether sent");
1613         Public2NumMinted[msg.sender] = Public2NumMinted[msg.sender] + quantity;
1614         require(Public2NumMinted[msg.sender] <= MAX_PUBLIC2_TOKENS_PER_ADDRESS, "Cannot mint more than your allotment in this phase");
1615 
1616     }
1617 //admin minting function for team tokens
1618     function teamReservesPreSaleMint(uint256 quantity) public onlyOwner {
1619         require(quantity <= MAX_TEAM_RESERVES_PRESALE, "Can't reserve more than set amount" );
1620         MAX_TEAM_RESERVES_PRESALE -= quantity;
1621         require(totalSupply() + quantity <= MAX_TOKENS, "invalid quantity: would exceed max supply");
1622         _safeMint(msg.sender, quantity);
1623     }
1624 
1625     function toggleOGsale() public onlyOwner {
1626         OGsale = !OGsale;
1627     }
1628 
1629     function toggleWLsale() public onlyOwner {
1630         WLsale = !WLsale;
1631     }
1632 
1633     function togglePublic1Sale() public onlyOwner {
1634         Public1Sale = !Public1Sale;
1635     }
1636 
1637     function togglePublic2Sale() public onlyOwner {
1638         Public2Sale = !Public2Sale;
1639     }
1640 
1641     function numberMinted(address owner) public view returns (uint256) {
1642     return _numberMinted(owner);
1643   }
1644 
1645     function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1646     _setOwnersExplicit(quantity);
1647   }
1648 
1649     // // metadata URI
1650     string private _baseTokenURI;
1651 
1652     function _baseURI() internal view virtual override returns (string memory) {
1653     return _baseTokenURI;
1654   }
1655 
1656     function setBaseURI(string calldata baseURI) external onlyOwner {
1657     _baseTokenURI = baseURI;
1658   } 
1659 
1660     function setOGmerkleroot(bytes32 newOGmerkle) public onlyOwner {
1661     OGmerkleroot = newOGmerkle;
1662     }
1663 
1664     function setWLmerkleroot(bytes32 newWLmerkle) public onlyOwner {
1665     WLmerkleroot = newWLmerkle;
1666     }
1667 
1668     function setPublic1merkleroot(bytes32 newPublic1merkle) public onlyOwner {
1669     Public1merkleroot = newPublic1merkle;
1670     }
1671 
1672     function setMAX_OG_TOKENS_PER_ADDRESS(uint256 _MAX_OG_TOKENS_PER_ADDRESS) public onlyOwner() {
1673     MAX_OG_TOKENS_PER_ADDRESS = _MAX_OG_TOKENS_PER_ADDRESS;
1674     }
1675 
1676     function setMAX_WL_TOKENS_PER_ADDRESS(uint256 _MAX_WL_TOKENS_PER_ADDRESS) public onlyOwner() {
1677     MAX_WL_TOKENS_PER_ADDRESS = _MAX_WL_TOKENS_PER_ADDRESS;
1678     }
1679 
1680     function setMAX_PUBLIC1_TOKENS_PER_ADDRESS(uint256 _MAX_PUBLIC1_TOKENS_PER_ADDRESS) public onlyOwner() {
1681     MAX_PUBLIC1_TOKENS_PER_ADDRESS = _MAX_PUBLIC1_TOKENS_PER_ADDRESS;
1682     }
1683 
1684     function setMAX_PUBLIC2_TOKENS_PER_ADDRESS(uint256 _MAX_PUBLIC2_TOKENS_PER_ADDRESS) public onlyOwner() {
1685     MAX_PUBLIC2_TOKENS_PER_ADDRESS = _MAX_PUBLIC2_TOKENS_PER_ADDRESS;
1686     }
1687 
1688     function setMAX_MINTS_PER_TX(uint256 _MAX_MINTS_PER_TX) public onlyOwner() {
1689     MAX_MINTS_PER_TX = _MAX_MINTS_PER_TX;
1690     }
1691 
1692     function setOG_TOKEN_PRICE(uint256 _OG_TOKEN_PRICE) public onlyOwner() {
1693     OG_TOKEN_PRICE = _OG_TOKEN_PRICE;
1694     }
1695 
1696     function setWL_TOKEN_PRICE(uint256 _WL_TOKEN_PRICE) public onlyOwner() {
1697     WL_TOKEN_PRICE = _WL_TOKEN_PRICE;
1698     }
1699 
1700     function setTOKEN_PRICE(uint256 _TOKEN_PRICE) public onlyOwner() {
1701     TOKEN_PRICE = _TOKEN_PRICE;
1702     }
1703 
1704     function setProvenanceHash(string memory provenanceHash) external onlyOwner {
1705         WBSCprovenance = provenanceHash;
1706     }
1707 
1708     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1709         return OpenSeaGasFreeListing.isApprovedForAll(owner, operator) || super.isApprovedForAll(owner, operator);
1710     }
1711 
1712     function getOwnershipData(uint256 tokenId)
1713     external
1714     view
1715     returns (TokenOwnership memory)
1716   {
1717     return ownershipOf(tokenId);
1718   }
1719 
1720   function withdrawMoney() external onlyOwner nonReentrant {
1721     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1722     require(success, "Transfer failed.");
1723   }
1724 
1725 }