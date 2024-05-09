1 /**
2 
3 ╱╱╭╮╱╱╱╱╱╭╮╱╱╱╱╱╱╱╱╱╱╱╭╮╭╮╱╱╱╱╱╭╮
4 ╱╱┃┃╱╱╱╱╭╯╰╮╱╱╱╱╱╱╱╱╱╭╯╰┫┃╱╱╱╱╱┃┃
5 ╭━╯┣━━┳━╋╮╭╋━━┳╮╭┳━━┳┻╮╭┫╰━┳┳━╮┃┃╭╮╭╮╭┳╮╱╭┳━━━╮
6 ┃╭╮┃╭╮┃╭╮┫┃┃╭╮┃╰╯┃┃━┫╭┫┃┃╭╮┣┫╭╮┫╰╯╯╰╋╋┫┃╱┃┣━━┃┃
7 ┃╰╯┃╰╯┃┃┃┃╰┫╰╯┣╮╭┫┃━┫┃┃╰┫┃┃┃┃┃┃┃╭╮┳┳╋╋┫╰━╯┃┃━━┫
8 ╰━━┻━━┻╯╰┻━┻━━╯╰╯╰━━┻╯╰━┻╯╰┻┻╯╰┻╯╰┻┻╯╰┻━╮╭┻━━━╯
9 ╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╭━╯┃
10 ╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╰━━╯
11 
12 ██████╗░░█████╗░███╗░░██╗████████╗░█████╗░██╗░░░██╗███████╗██████╗░████████╗██╗░░██╗██╗███╗░░██╗██╗░░██╗░░░██╗░░██╗██╗░░░██╗███████╗
13 ██╔══██╗██╔══██╗████╗░██║╚══██╔══╝██╔══██╗██║░░░██║██╔════╝██╔══██╗╚══██╔══╝██║░░██║██║████╗░██║██║░██╔╝░░░╚██╗██╔╝╚██╗░██╔╝╚════██║
14 ██║░░██║██║░░██║██╔██╗██║░░░██║░░░██║░░██║╚██╗░██╔╝█████╗░░██████╔╝░░░██║░░░███████║██║██╔██╗██║█████═╝░░░░░╚███╔╝░░╚████╔╝░░░███╔═╝
15 ██║░░██║██║░░██║██║╚████║░░░██║░░░██║░░██║░╚████╔╝░██╔══╝░░██╔══██╗░░░██║░░░██╔══██║██║██║╚████║██╔═██╗░░░░░██╔██╗░░░╚██╔╝░░██╔══╝░░
16 ██████╔╝╚█████╔╝██║░╚███║░░░██║░░░╚█████╔╝░░╚██╔╝░░███████╗██║░░██║░░░██║░░░██║░░██║██║██║░╚███║██║░╚██╗██╗██╔╝╚██╗░░░██║░░░███████╗
17 ╚═════╝░░╚════╝░╚═╝░░╚══╝░░░╚═╝░░░░╚════╝░░░░╚═╝░░░╚══════╝╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝╚═╝╚═╝░░╚══╝╚═╝░░╚═╝╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝
18 
19 █▀▄ █▀█ █▄░█ ▀█▀ █▀█ █░█ █▀▀ █▀█ ▀█▀ █░█ █ █▄░█ █▄▀ ░ ▀▄▀ █▄█ ▀█
20 █▄▀ █▄█ █░▀█ ░█░ █▄█ ▀▄▀ ██▄ █▀▄ ░█░ █▀█ █ █░▀█ █░█ ▄ █░█ ░█░ █▄
21  */
22 // SPDX-License-Identifier: MIT
23 //Developer Info: 
24 
25 
26 
27 // File: @openzeppelin/contracts/utils/Strings.sol
28 
29 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev String operations.
35  */
36 library Strings {
37     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
41      */
42     function toString(uint256 value) internal pure returns (string memory) {
43         // Inspired by OraclizeAPI's implementation - MIT licence
44         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
45 
46         if (value == 0) {
47             return "0";
48         }
49         uint256 temp = value;
50         uint256 digits;
51         while (temp != 0) {
52             digits++;
53             temp /= 10;
54         }
55         bytes memory buffer = new bytes(digits);
56         while (value != 0) {
57             digits -= 1;
58             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
59             value /= 10;
60         }
61         return string(buffer);
62     }
63 
64     /**
65      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
66      */
67     function toHexString(uint256 value) internal pure returns (string memory) {
68         if (value == 0) {
69             return "0x00";
70         }
71         uint256 temp = value;
72         uint256 length = 0;
73         while (temp != 0) {
74             length++;
75             temp >>= 8;
76         }
77         return toHexString(value, length);
78     }
79 
80     /**
81      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
82      */
83     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
84         bytes memory buffer = new bytes(2 * length + 2);
85         buffer[0] = "0";
86         buffer[1] = "x";
87         for (uint256 i = 2 * length + 1; i > 1; --i) {
88             buffer[i] = _HEX_SYMBOLS[value & 0xf];
89             value >>= 4;
90         }
91         require(value == 0, "Strings: hex length insufficient");
92         return string(buffer);
93     }
94 }
95 
96 // File: @openzeppelin/contracts/utils/Context.sol
97 
98 
99 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
100 
101 pragma solidity ^0.8.0;
102 
103 /**
104  * @dev Provides information about the current execution context, including the
105  * sender of the transaction and its data. While these are generally available
106  * via msg.sender and msg.data, they should not be accessed in such a direct
107  * manner, since when dealing with meta-transactions the account sending and
108  * paying for execution may not be the actual sender (as far as an application
109  * is concerned).
110  *
111  * This contract is only required for intermediate, library-like contracts.
112  */
113 abstract contract Context {
114     function _msgSender() internal view virtual returns (address) {
115         return msg.sender;
116     }
117 
118     function _msgData() internal view virtual returns (bytes calldata) {
119         return msg.data;
120     }
121 }
122 
123 // File: @openzeppelin/contracts/utils/Address.sol
124 
125 
126 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
127 
128 pragma solidity ^0.8.1;
129 
130 /**
131  * @dev Collection of functions related to the address type
132  */
133 library Address {
134     /**
135      * @dev Returns true if `account` is a contract.
136      *
137      * [IMPORTANT]
138      * ====
139      * It is unsafe to assume that an address for which this function returns
140      * false is an externally-owned account (EOA) and not a contract.
141      *
142      * Among others, `isContract` will return false for the following
143      * types of addresses:
144      *
145      *  - an externally-owned account
146      *  - a contract in construction
147      *  - an address where a contract will be created
148      *  - an address where a contract lived, but was destroyed
149      * ====
150      *
151      * [IMPORTANT]
152      * ====
153      * You shouldn't rely on `isContract` to protect against flash loan attacks!
154      *
155      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
156      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
157      * constructor.
158      * ====
159      */
160     function isContract(address account) internal view returns (bool) {
161         // This method relies on extcodesize/address.code.length, which returns 0
162         // for contracts in construction, since the code is only stored at the end
163         // of the constructor execution.
164 
165         return account.code.length > 0;
166     }
167 
168     /**
169      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
170      * `recipient`, forwarding all available gas and reverting on errors.
171      *
172      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
173      * of certain opcodes, possibly making contracts go over the 2300 gas limit
174      * imposed by `transfer`, making them unable to receive funds via
175      * `transfer`. {sendValue} removes this limitation.
176      *
177      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
178      *
179      * IMPORTANT: because control is transferred to `recipient`, care must be
180      * taken to not create reentrancy vulnerabilities. Consider using
181      * {ReentrancyGuard} or the
182      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
183      */
184     function sendValue(address payable recipient, uint256 amount) internal {
185         require(address(this).balance >= amount, "Address: insufficient balance");
186 
187         (bool success, ) = recipient.call{value: amount}("");
188         require(success, "Address: unable to send value, recipient may have reverted");
189     }
190 
191     /**
192      * @dev Performs a Solidity function call using a low level `call`. A
193      * plain `call` is an unsafe replacement for a function call: use this
194      * function instead.
195      *
196      * If `target` reverts with a revert reason, it is bubbled up by this
197      * function (like regular Solidity function calls).
198      *
199      * Returns the raw returned data. To convert to the expected return value,
200      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
201      *
202      * Requirements:
203      *
204      * - `target` must be a contract.
205      * - calling `target` with `data` must not revert.
206      *
207      * _Available since v3.1._
208      */
209     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
210         return functionCall(target, data, "Address: low-level call failed");
211     }
212 
213     /**
214      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
215      * `errorMessage` as a fallback revert reason when `target` reverts.
216      *
217      * _Available since v3.1._
218      */
219     function functionCall(
220         address target,
221         bytes memory data,
222         string memory errorMessage
223     ) internal returns (bytes memory) {
224         return functionCallWithValue(target, data, 0, errorMessage);
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
229      * but also transferring `value` wei to `target`.
230      *
231      * Requirements:
232      *
233      * - the calling contract must have an ETH balance of at least `value`.
234      * - the called Solidity function must be `payable`.
235      *
236      * _Available since v3.1._
237      */
238     function functionCallWithValue(
239         address target,
240         bytes memory data,
241         uint256 value
242     ) internal returns (bytes memory) {
243         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
244     }
245 
246     /**
247      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
248      * with `errorMessage` as a fallback revert reason when `target` reverts.
249      *
250      * _Available since v3.1._
251      */
252     function functionCallWithValue(
253         address target,
254         bytes memory data,
255         uint256 value,
256         string memory errorMessage
257     ) internal returns (bytes memory) {
258         require(address(this).balance >= value, "Address: insufficient balance for call");
259         require(isContract(target), "Address: call to non-contract");
260 
261         (bool success, bytes memory returndata) = target.call{value: value}(data);
262         return verifyCallResult(success, returndata, errorMessage);
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
267      * but performing a static call.
268      *
269      * _Available since v3.3._
270      */
271     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
272         return functionStaticCall(target, data, "Address: low-level static call failed");
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
277      * but performing a static call.
278      *
279      * _Available since v3.3._
280      */
281     function functionStaticCall(
282         address target,
283         bytes memory data,
284         string memory errorMessage
285     ) internal view returns (bytes memory) {
286         require(isContract(target), "Address: static call to non-contract");
287 
288         (bool success, bytes memory returndata) = target.staticcall(data);
289         return verifyCallResult(success, returndata, errorMessage);
290     }
291 
292     /**
293      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
294      * but performing a delegate call.
295      *
296      * _Available since v3.4._
297      */
298     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
299         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
300     }
301 
302     /**
303      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
304      * but performing a delegate call.
305      *
306      * _Available since v3.4._
307      */
308     function functionDelegateCall(
309         address target,
310         bytes memory data,
311         string memory errorMessage
312     ) internal returns (bytes memory) {
313         require(isContract(target), "Address: delegate call to non-contract");
314 
315         (bool success, bytes memory returndata) = target.delegatecall(data);
316         return verifyCallResult(success, returndata, errorMessage);
317     }
318 
319     /**
320      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
321      * revert reason using the provided one.
322      *
323      * _Available since v4.3._
324      */
325     function verifyCallResult(
326         bool success,
327         bytes memory returndata,
328         string memory errorMessage
329     ) internal pure returns (bytes memory) {
330         if (success) {
331             return returndata;
332         } else {
333             // Look for revert reason and bubble it up if present
334             if (returndata.length > 0) {
335                 // The easiest way to bubble the revert reason is using memory via assembly
336 
337                 assembly {
338                     let returndata_size := mload(returndata)
339                     revert(add(32, returndata), returndata_size)
340                 }
341             } else {
342                 revert(errorMessage);
343             }
344         }
345     }
346 }
347 
348 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
349 
350 
351 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
352 
353 pragma solidity ^0.8.0;
354 
355 /**
356  * @title ERC721 token receiver interface
357  * @dev Interface for any contract that wants to support safeTransfers
358  * from ERC721 asset contracts.
359  */
360 interface IERC721Receiver {
361     /**
362      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
363      * by `operator` from `from`, this function is called.
364      *
365      * It must return its Solidity selector to confirm the token transfer.
366      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
367      *
368      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
369      */
370     function onERC721Received(
371         address operator,
372         address from,
373         uint256 tokenId,
374         bytes calldata data
375     ) external returns (bytes4);
376 }
377 
378 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
379 
380 
381 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
382 
383 pragma solidity ^0.8.0;
384 
385 /**
386  * @dev Interface of the ERC165 standard, as defined in the
387  * https://eips.ethereum.org/EIPS/eip-165[EIP].
388  *
389  * Implementers can declare support of contract interfaces, which can then be
390  * queried by others ({ERC165Checker}).
391  *
392  * For an implementation, see {ERC165}.
393  */
394 interface IERC165 {
395     /**
396      * @dev Returns true if this contract implements the interface defined by
397      * `interfaceId`. See the corresponding
398      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
399      * to learn more about how these ids are created.
400      *
401      * This function call must use less than 30 000 gas.
402      */
403     function supportsInterface(bytes4 interfaceId) external view returns (bool);
404 }
405 
406 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
407 
408 
409 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
410 
411 pragma solidity ^0.8.0;
412 
413 
414 /**
415  * @dev Implementation of the {IERC165} interface.
416  *
417  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
418  * for the additional interface id that will be supported. For example:
419  *
420  * ```solidity
421  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
422  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
423  * }
424  * ```
425  *
426  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
427  */
428 abstract contract ERC165 is IERC165 {
429     /**
430      * @dev See {IERC165-supportsInterface}.
431      */
432     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
433         return interfaceId == type(IERC165).interfaceId;
434     }
435 }
436 
437 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
438 
439 
440 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
441 
442 pragma solidity ^0.8.0;
443 
444 
445 /**
446  * @dev Required interface of an ERC721 compliant contract.
447  */
448 interface IERC721 is IERC165 {
449     /**
450      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
451      */
452     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
453 
454     /**
455      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
456      */
457     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
458 
459     /**
460      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
461      */
462     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
463 
464     /**
465      * @dev Returns the number of tokens in ``owner``'s account.
466      */
467     function balanceOf(address owner) external view returns (uint256 balance);
468 
469     /**
470      * @dev Returns the owner of the `tokenId` token.
471      *
472      * Requirements:
473      *
474      * - `tokenId` must exist.
475      */
476     function ownerOf(uint256 tokenId) external view returns (address owner);
477 
478     /**
479      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
480      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
481      *
482      * Requirements:
483      *
484      * - `from` cannot be the zero address.
485      * - `to` cannot be the zero address.
486      * - `tokenId` token must exist and be owned by `from`.
487      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
488      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
489      *
490      * Emits a {Transfer} event.
491      */
492     function safeTransferFrom(
493         address from,
494         address to,
495         uint256 tokenId
496     ) external;
497 
498     /**
499      * @dev Transfers `tokenId` token from `from` to `to`.
500      *
501      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
502      *
503      * Requirements:
504      *
505      * - `from` cannot be the zero address.
506      * - `to` cannot be the zero address.
507      * - `tokenId` token must be owned by `from`.
508      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
509      *
510      * Emits a {Transfer} event.
511      */
512     function transferFrom(
513         address from,
514         address to,
515         uint256 tokenId
516     ) external;
517 
518     /**
519      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
520      * The approval is cleared when the token is transferred.
521      *
522      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
523      *
524      * Requirements:
525      *
526      * - The caller must own the token or be an approved operator.
527      * - `tokenId` must exist.
528      *
529      * Emits an {Approval} event.
530      */
531     function approve(address to, uint256 tokenId) external;
532 
533     /**
534      * @dev Returns the account approved for `tokenId` token.
535      *
536      * Requirements:
537      *
538      * - `tokenId` must exist.
539      */
540     function getApproved(uint256 tokenId) external view returns (address operator);
541 
542     /**
543      * @dev Approve or remove `operator` as an operator for the caller.
544      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
545      *
546      * Requirements:
547      *
548      * - The `operator` cannot be the caller.
549      *
550      * Emits an {ApprovalForAll} event.
551      */
552     function setApprovalForAll(address operator, bool _approved) external;
553 
554     /**
555      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
556      *
557      * See {setApprovalForAll}
558      */
559     function isApprovedForAll(address owner, address operator) external view returns (bool);
560 
561     /**
562      * @dev Safely transfers `tokenId` token from `from` to `to`.
563      *
564      * Requirements:
565      *
566      * - `from` cannot be the zero address.
567      * - `to` cannot be the zero address.
568      * - `tokenId` token must exist and be owned by `from`.
569      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
570      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
571      *
572      * Emits a {Transfer} event.
573      */
574     function safeTransferFrom(
575         address from,
576         address to,
577         uint256 tokenId,
578         bytes calldata data
579     ) external;
580 }
581 
582 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
583 
584 
585 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
586 
587 pragma solidity ^0.8.0;
588 
589 
590 /**
591  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
592  * @dev See https://eips.ethereum.org/EIPS/eip-721
593  */
594 interface IERC721Metadata is IERC721 {
595     /**
596      * @dev Returns the token collection name.
597      */
598     function name() external view returns (string memory);
599 
600     /**
601      * @dev Returns the token collection symbol.
602      */
603     function symbol() external view returns (string memory);
604 
605     /**
606      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
607      */
608     function tokenURI(uint256 tokenId) external view returns (string memory);
609 }
610 
611 // File: contracts/new.sol
612 
613 
614 
615 
616 pragma solidity ^0.8.4;
617 
618 
619 
620 
621 
622 
623 
624 
625 error ApprovalCallerNotOwnerNorApproved();
626 error ApprovalQueryForNonexistentToken();
627 error ApproveToCaller();
628 error ApprovalToCurrentOwner();
629 error BalanceQueryForZeroAddress();
630 error MintToZeroAddress();
631 error MintZeroQuantity();
632 error OwnerQueryForNonexistentToken();
633 error TransferCallerNotOwnerNorApproved();
634 error TransferFromIncorrectOwner();
635 error TransferToNonERC721ReceiverImplementer();
636 error TransferToZeroAddress();
637 error URIQueryForNonexistentToken();
638 
639 /**
640  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
641  * the Metadata extension. Built to optimize for lower gas during batch mints.
642  *
643  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
644  *
645  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
646  *
647  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
648  */
649 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
650     using Address for address;
651     using Strings for uint256;
652 
653     // Compiler will pack this into a single 256bit word.
654     struct TokenOwnership {
655         // The address of the owner.
656         address addr;
657         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
658         uint64 startTimestamp;
659         // Whether the token has been burned.
660         bool burned;
661     }
662 
663     // Compiler will pack this into a single 256bit word.
664     struct AddressData {
665         // Realistically, 2**64-1 is more than enough.
666         uint64 balance;
667         // Keeps track of mint count with minimal overhead for tokenomics.
668         uint64 numberMinted;
669         // Keeps track of burn count with minimal overhead for tokenomics.
670         uint64 numberBurned;
671         // For miscellaneous variable(s) pertaining to the address
672         // (e.g. number of whitelist mint slots used).
673         // If there are multiple variables, please pack them into a uint64.
674         uint64 aux;
675     }
676 
677     // The tokenId of the next token to be minted.
678     uint256 internal _currentIndex;
679 
680     // The number of tokens burned.
681     uint256 internal _burnCounter;
682 
683     // Token name
684     string private _name;
685 
686     // Token symbol
687     string private _symbol;
688 
689     // Mapping from token ID to ownership details
690     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
691     mapping(uint256 => TokenOwnership) internal _ownerships;
692 
693     // Mapping owner address to address data
694     mapping(address => AddressData) private _addressData;
695 
696     // Mapping from token ID to approved address
697     mapping(uint256 => address) private _tokenApprovals;
698 
699     // Mapping from owner to operator approvals
700     mapping(address => mapping(address => bool)) private _operatorApprovals;
701 
702     constructor(string memory name_, string memory symbol_) {
703         _name = name_;
704         _symbol = symbol_;
705         _currentIndex = _startTokenId();
706     }
707 
708     /**
709      * To change the starting tokenId, please override this function.
710      */
711     function _startTokenId() internal view virtual returns (uint256) {
712         return 0;
713     }
714 
715     /**
716      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
717      */
718     function totalSupply() public view returns (uint256) {
719         // Counter underflow is impossible as _burnCounter cannot be incremented
720         // more than _currentIndex - _startTokenId() times
721         unchecked {
722             return _currentIndex - _burnCounter - _startTokenId();
723         }
724     }
725 
726     /**
727      * Returns the total amount of tokens minted in the contract.
728      */
729     function _totalMinted() internal view returns (uint256) {
730         // Counter underflow is impossible as _currentIndex does not decrement,
731         // and it is initialized to _startTokenId()
732         unchecked {
733             return _currentIndex - _startTokenId();
734         }
735     }
736 
737     /**
738      * @dev See {IERC165-supportsInterface}.
739      */
740     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
741         return
742             interfaceId == type(IERC721).interfaceId ||
743             interfaceId == type(IERC721Metadata).interfaceId ||
744             super.supportsInterface(interfaceId);
745     }
746 
747     /**
748      * @dev See {IERC721-balanceOf}.
749      */
750     function balanceOf(address owner) public view override returns (uint256) {
751         if (owner == address(0)) revert BalanceQueryForZeroAddress();
752         return uint256(_addressData[owner].balance);
753     }
754 
755     /**
756      * Returns the number of tokens minted by `owner`.
757      */
758     function _numberMinted(address owner) internal view returns (uint256) {
759         return uint256(_addressData[owner].numberMinted);
760     }
761 
762     /**
763      * Returns the number of tokens burned by or on behalf of `owner`.
764      */
765     function _numberBurned(address owner) internal view returns (uint256) {
766         return uint256(_addressData[owner].numberBurned);
767     }
768 
769     /**
770      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
771      */
772     function _getAux(address owner) internal view returns (uint64) {
773         return _addressData[owner].aux;
774     }
775 
776     /**
777      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
778      * If there are multiple variables, please pack them into a uint64.
779      */
780     function _setAux(address owner, uint64 aux) internal {
781         _addressData[owner].aux = aux;
782     }
783 
784     /**
785      * Gas spent here starts off proportional to the maximum mint batch size.
786      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
787      */
788     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
789         uint256 curr = tokenId;
790 
791         unchecked {
792             if (_startTokenId() <= curr && curr < _currentIndex) {
793                 TokenOwnership memory ownership = _ownerships[curr];
794                 if (!ownership.burned) {
795                     if (ownership.addr != address(0)) {
796                         return ownership;
797                     }
798                     // Invariant:
799                     // There will always be an ownership that has an address and is not burned
800                     // before an ownership that does not have an address and is not burned.
801                     // Hence, curr will not underflow.
802                     while (true) {
803                         curr--;
804                         ownership = _ownerships[curr];
805                         if (ownership.addr != address(0)) {
806                             return ownership;
807                         }
808                     }
809                 }
810             }
811         }
812         revert OwnerQueryForNonexistentToken();
813     }
814 
815     /**
816      * @dev See {IERC721-ownerOf}.
817      */
818     function ownerOf(uint256 tokenId) public view override returns (address) {
819         return _ownershipOf(tokenId).addr;
820     }
821 
822     /**
823      * @dev See {IERC721Metadata-name}.
824      */
825     function name() public view virtual override returns (string memory) {
826         return _name;
827     }
828 
829     /**
830      * @dev See {IERC721Metadata-symbol}.
831      */
832     function symbol() public view virtual override returns (string memory) {
833         return _symbol;
834     }
835 
836     /**
837      * @dev See {IERC721Metadata-tokenURI}.
838      */
839     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
840         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
841 
842         string memory baseURI = _baseURI();
843         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
844     }
845 
846     /**
847      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
848      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
849      * by default, can be overriden in child contracts.
850      */
851     function _baseURI() internal view virtual returns (string memory) {
852         return '';
853     }
854 
855     /**
856      * @dev See {IERC721-approve}.
857      */
858     function approve(address to, uint256 tokenId) public override {
859         address owner = ERC721A.ownerOf(tokenId);
860         if (to == owner) revert ApprovalToCurrentOwner();
861 
862         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
863             revert ApprovalCallerNotOwnerNorApproved();
864         }
865 
866         _approve(to, tokenId, owner);
867     }
868 
869     /**
870      * @dev See {IERC721-getApproved}.
871      */
872     function getApproved(uint256 tokenId) public view override returns (address) {
873         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
874 
875         return _tokenApprovals[tokenId];
876     }
877 
878     /**
879      * @dev See {IERC721-setApprovalForAll}.
880      */
881     function setApprovalForAll(address operator, bool approved) public virtual override {
882         if (operator == _msgSender()) revert ApproveToCaller();
883 
884         _operatorApprovals[_msgSender()][operator] = approved;
885         emit ApprovalForAll(_msgSender(), operator, approved);
886     }
887 
888     /**
889      * @dev See {IERC721-isApprovedForAll}.
890      */
891     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
892         return _operatorApprovals[owner][operator];
893     }
894 
895     /**
896      * @dev See {IERC721-transferFrom}.
897      */
898     function transferFrom(
899         address from,
900         address to,
901         uint256 tokenId
902     ) public virtual override {
903         _transfer(from, to, tokenId);
904     }
905 
906     /**
907      * @dev See {IERC721-safeTransferFrom}.
908      */
909     function safeTransferFrom(
910         address from,
911         address to,
912         uint256 tokenId
913     ) public virtual override {
914         safeTransferFrom(from, to, tokenId, '');
915     }
916 
917     /**
918      * @dev See {IERC721-safeTransferFrom}.
919      */
920     function safeTransferFrom(
921         address from,
922         address to,
923         uint256 tokenId,
924         bytes memory _data
925     ) public virtual override {
926         _transfer(from, to, tokenId);
927         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
928             revert TransferToNonERC721ReceiverImplementer();
929         }
930     }
931 
932     /**
933      * @dev Returns whether `tokenId` exists.
934      *
935      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
936      *
937      * Tokens start existing when they are minted (`_mint`),
938      */
939     function _exists(uint256 tokenId) internal view returns (bool) {
940         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
941             !_ownerships[tokenId].burned;
942     }
943 
944     function _safeMint(address to, uint256 quantity) internal {
945         _safeMint(to, quantity, '');
946     }
947 
948     /**
949      * @dev Safely mints `quantity` tokens and transfers them to `to`.
950      *
951      * Requirements:
952      *
953      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
954      * - `quantity` must be greater than 0.
955      *
956      * Emits a {Transfer} event.
957      */
958     function _safeMint(
959         address to,
960         uint256 quantity,
961         bytes memory _data
962     ) internal {
963         _mint(to, quantity, _data, true);
964     }
965 
966     /**
967      * @dev Mints `quantity` tokens and transfers them to `to`.
968      *
969      * Requirements:
970      *
971      * - `to` cannot be the zero address.
972      * - `quantity` must be greater than 0.
973      *
974      * Emits a {Transfer} event.
975      */
976     function _mint(
977         address to,
978         uint256 quantity,
979         bytes memory _data,
980         bool safe
981     ) internal {
982         uint256 startTokenId = _currentIndex;
983         if (to == address(0)) revert MintToZeroAddress();
984         if (quantity == 0) revert MintZeroQuantity();
985 
986         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
987 
988         // Overflows are incredibly unrealistic.
989         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
990         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
991         unchecked {
992             _addressData[to].balance += uint64(quantity);
993             _addressData[to].numberMinted += uint64(quantity);
994 
995             _ownerships[startTokenId].addr = to;
996             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
997 
998             uint256 updatedIndex = startTokenId;
999             uint256 end = updatedIndex + quantity;
1000 
1001             if (safe && to.isContract()) {
1002                 do {
1003                     emit Transfer(address(0), to, updatedIndex);
1004                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1005                         revert TransferToNonERC721ReceiverImplementer();
1006                     }
1007                 } while (updatedIndex != end);
1008                 // Reentrancy protection
1009                 if (_currentIndex != startTokenId) revert();
1010             } else {
1011                 do {
1012                     emit Transfer(address(0), to, updatedIndex++);
1013                 } while (updatedIndex != end);
1014             }
1015             _currentIndex = updatedIndex;
1016         }
1017         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1018     }
1019 
1020     /**
1021      * @dev Transfers `tokenId` from `from` to `to`.
1022      *
1023      * Requirements:
1024      *
1025      * - `to` cannot be the zero address.
1026      * - `tokenId` token must be owned by `from`.
1027      *
1028      * Emits a {Transfer} event.
1029      */
1030     function _transfer(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) private {
1035         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1036 
1037         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1038 
1039         bool isApprovedOrOwner = (_msgSender() == from ||
1040             isApprovedForAll(from, _msgSender()) ||
1041             getApproved(tokenId) == _msgSender());
1042 
1043         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1044         if (to == address(0)) revert TransferToZeroAddress();
1045 
1046         _beforeTokenTransfers(from, to, tokenId, 1);
1047 
1048         // Clear approvals from the previous owner
1049         _approve(address(0), tokenId, from);
1050 
1051         // Underflow of the sender's balance is impossible because we check for
1052         // ownership above and the recipient's balance can't realistically overflow.
1053         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1054         unchecked {
1055             _addressData[from].balance -= 1;
1056             _addressData[to].balance += 1;
1057 
1058             TokenOwnership storage currSlot = _ownerships[tokenId];
1059             currSlot.addr = to;
1060             currSlot.startTimestamp = uint64(block.timestamp);
1061 
1062             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1063             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1064             uint256 nextTokenId = tokenId + 1;
1065             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1066             if (nextSlot.addr == address(0)) {
1067                 // This will suffice for checking _exists(nextTokenId),
1068                 // as a burned slot cannot contain the zero address.
1069                 if (nextTokenId != _currentIndex) {
1070                     nextSlot.addr = from;
1071                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1072                 }
1073             }
1074         }
1075 
1076         emit Transfer(from, to, tokenId);
1077         _afterTokenTransfers(from, to, tokenId, 1);
1078     }
1079 
1080     /**
1081      * @dev This is equivalent to _burn(tokenId, false)
1082      */
1083     function _burn(uint256 tokenId) internal virtual {
1084         _burn(tokenId, false);
1085     }
1086 
1087     /**
1088      * @dev Destroys `tokenId`.
1089      * The approval is cleared when the token is burned.
1090      *
1091      * Requirements:
1092      *
1093      * - `tokenId` must exist.
1094      *
1095      * Emits a {Transfer} event.
1096      */
1097     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1098         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1099 
1100         address from = prevOwnership.addr;
1101 
1102         if (approvalCheck) {
1103             bool isApprovedOrOwner = (_msgSender() == from ||
1104                 isApprovedForAll(from, _msgSender()) ||
1105                 getApproved(tokenId) == _msgSender());
1106 
1107             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1108         }
1109 
1110         _beforeTokenTransfers(from, address(0), tokenId, 1);
1111 
1112         // Clear approvals from the previous owner
1113         _approve(address(0), tokenId, from);
1114 
1115         // Underflow of the sender's balance is impossible because we check for
1116         // ownership above and the recipient's balance can't realistically overflow.
1117         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1118         unchecked {
1119             AddressData storage addressData = _addressData[from];
1120             addressData.balance -= 1;
1121             addressData.numberBurned += 1;
1122 
1123             // Keep track of who burned the token, and the timestamp of burning.
1124             TokenOwnership storage currSlot = _ownerships[tokenId];
1125             currSlot.addr = from;
1126             currSlot.startTimestamp = uint64(block.timestamp);
1127             currSlot.burned = true;
1128 
1129             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1130             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1131             uint256 nextTokenId = tokenId + 1;
1132             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1133             if (nextSlot.addr == address(0)) {
1134                 // This will suffice for checking _exists(nextTokenId),
1135                 // as a burned slot cannot contain the zero address.
1136                 if (nextTokenId != _currentIndex) {
1137                     nextSlot.addr = from;
1138                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1139                 }
1140             }
1141         }
1142 
1143         emit Transfer(from, address(0), tokenId);
1144         _afterTokenTransfers(from, address(0), tokenId, 1);
1145 
1146         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1147         unchecked {
1148             _burnCounter++;
1149         }
1150     }
1151 
1152     /**
1153      * @dev Approve `to` to operate on `tokenId`
1154      *
1155      * Emits a {Approval} event.
1156      */
1157     function _approve(
1158         address to,
1159         uint256 tokenId,
1160         address owner
1161     ) private {
1162         _tokenApprovals[tokenId] = to;
1163         emit Approval(owner, to, tokenId);
1164     }
1165 
1166     /**
1167      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1168      *
1169      * @param from address representing the previous owner of the given token ID
1170      * @param to target address that will receive the tokens
1171      * @param tokenId uint256 ID of the token to be transferred
1172      * @param _data bytes optional data to send along with the call
1173      * @return bool whether the call correctly returned the expected magic value
1174      */
1175     function _checkContractOnERC721Received(
1176         address from,
1177         address to,
1178         uint256 tokenId,
1179         bytes memory _data
1180     ) private returns (bool) {
1181         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1182             return retval == IERC721Receiver(to).onERC721Received.selector;
1183         } catch (bytes memory reason) {
1184             if (reason.length == 0) {
1185                 revert TransferToNonERC721ReceiverImplementer();
1186             } else {
1187                 assembly {
1188                     revert(add(32, reason), mload(reason))
1189                 }
1190             }
1191         }
1192     }
1193 
1194     /**
1195      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1196      * And also called before burning one token.
1197      *
1198      * startTokenId - the first token id to be transferred
1199      * quantity - the amount to be transferred
1200      *
1201      * Calling conditions:
1202      *
1203      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1204      * transferred to `to`.
1205      * - When `from` is zero, `tokenId` will be minted for `to`.
1206      * - When `to` is zero, `tokenId` will be burned by `from`.
1207      * - `from` and `to` are never both zero.
1208      */
1209     function _beforeTokenTransfers(
1210         address from,
1211         address to,
1212         uint256 startTokenId,
1213         uint256 quantity
1214     ) internal virtual {}
1215 
1216     /**
1217      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1218      * minting.
1219      * And also called after one token has been burned.
1220      *
1221      * startTokenId - the first token id to be transferred
1222      * quantity - the amount to be transferred
1223      *
1224      * Calling conditions:
1225      *
1226      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1227      * transferred to `to`.
1228      * - When `from` is zero, `tokenId` has been minted for `to`.
1229      * - When `to` is zero, `tokenId` has been burned by `from`.
1230      * - `from` and `to` are never both zero.
1231      */
1232     function _afterTokenTransfers(
1233         address from,
1234         address to,
1235         uint256 startTokenId,
1236         uint256 quantity
1237     ) internal virtual {}
1238 }
1239 
1240 abstract contract Ownable is Context {
1241     address private _owner;
1242 
1243     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1244 
1245     /**
1246      * @dev Initializes the contract setting the deployer as the initial owner.
1247      */
1248     constructor() {
1249         _transferOwnership(_msgSender());
1250     }
1251 
1252     /**
1253      * @dev Returns the address of the current owner.
1254      */
1255     function owner() public view virtual returns (address) {
1256         return _owner;
1257     }
1258 
1259     /**
1260      * @dev Throws if called by any account other than the owner.
1261      */
1262     modifier onlyOwner() {
1263         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1264         _;
1265     }
1266 
1267     /**
1268      * @dev Leaves the contract without owner. It will not be possible to call
1269      * `onlyOwner` functions anymore. Can only be called by the current owner.
1270      *
1271      * NOTE: Renouncing ownership will leave the contract without an owner,
1272      * thereby removing any functionality that is only available to the owner.
1273      */
1274     function renounceOwnership() public virtual onlyOwner {
1275         _transferOwnership(address(0));
1276     }
1277 
1278     /**
1279      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1280      * Can only be called by the current owner.
1281      */
1282     function transferOwnership(address newOwner) public virtual onlyOwner {
1283         require(newOwner != address(0), "Ownable: new owner is the zero address");
1284         _transferOwnership(newOwner);
1285     }
1286 
1287     /**
1288      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1289      * Internal function without access restriction.
1290      */
1291     function _transferOwnership(address newOwner) internal virtual {
1292         address oldOwner = _owner;
1293         _owner = newOwner;
1294         emit OwnershipTransferred(oldOwner, newOwner);
1295     }
1296 }
1297 pragma solidity ^0.8.13;
1298 
1299 interface IOperatorFilterRegistry {
1300     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1301     function register(address registrant) external;
1302     function registerAndSubscribe(address registrant, address subscription) external;
1303     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1304     function updateOperator(address registrant, address operator, bool filtered) external;
1305     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1306     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1307     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1308     function subscribe(address registrant, address registrantToSubscribe) external;
1309     function unsubscribe(address registrant, bool copyExistingEntries) external;
1310     function subscriptionOf(address addr) external returns (address registrant);
1311     function subscribers(address registrant) external returns (address[] memory);
1312     function subscriberAt(address registrant, uint256 index) external returns (address);
1313     function copyEntriesOf(address registrant, address registrantToCopy) external;
1314     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1315     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1316     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1317     function filteredOperators(address addr) external returns (address[] memory);
1318     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1319     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1320     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1321     function isRegistered(address addr) external returns (bool);
1322     function codeHashOf(address addr) external returns (bytes32);
1323 }
1324 pragma solidity ^0.8.13;
1325 
1326 
1327 
1328 abstract contract OperatorFilterer {
1329     error OperatorNotAllowed(address operator);
1330 
1331     IOperatorFilterRegistry constant operatorFilterRegistry =
1332         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1333 
1334     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1335         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1336         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1337         // order for the modifier to filter addresses.
1338         if (address(operatorFilterRegistry).code.length > 0) {
1339             if (subscribe) {
1340                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1341             } else {
1342                 if (subscriptionOrRegistrantToCopy != address(0)) {
1343                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1344                 } else {
1345                     operatorFilterRegistry.register(address(this));
1346                 }
1347             }
1348         }
1349     }
1350 
1351     modifier onlyAllowedOperator(address from) virtual {
1352         // Check registry code length to facilitate testing in environments without a deployed registry.
1353         if (address(operatorFilterRegistry).code.length > 0) {
1354             // Allow spending tokens from addresses with balance
1355             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1356             // from an EOA.
1357             if (from == msg.sender) {
1358                 _;
1359                 return;
1360             }
1361             if (
1362                 !(
1363                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1364                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1365                 )
1366             ) {
1367                 revert OperatorNotAllowed(msg.sender);
1368             }
1369         }
1370         _;
1371     }
1372 }
1373 pragma solidity ^0.8.13;
1374 
1375 
1376 
1377 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1378     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1379 
1380     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1381 }
1382     pragma solidity ^0.8.7;
1383     
1384     contract DONTOVERTHINKxyz is ERC721A, DefaultOperatorFilterer , Ownable {
1385     using Strings for uint256;
1386 
1387 
1388   string private uriPrefix ;
1389   string private uriSuffix = ".json";
1390   string public hiddenURL;
1391 
1392   
1393   
1394 
1395   uint256 public cost = 0.003 ether;
1396  
1397   
1398 
1399   uint16 public maxSupply = 1337;
1400   uint8 public maxMintAmountPerTx = 1;
1401     uint8 public maxFreeMintAmountPerWallet = 1;
1402                                                              
1403  
1404   bool public paused = true;
1405   bool public reveal =false;
1406 
1407    mapping (address => uint8) public NFTPerPublicAddress;
1408 
1409  
1410   
1411   
1412  
1413   
1414 
1415   constructor() ERC721A("DONTOVERTHINK", "XYZ") {
1416   }
1417 
1418 
1419   
1420  
1421   function mint(uint8 _mintAmount) external payable  {
1422      uint16 totalSupply = uint16(totalSupply());
1423      uint8 nft = NFTPerPublicAddress[msg.sender];
1424     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1425     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1426 
1427     require(!paused, "The contract is paused!");
1428     
1429       if(nft >= maxFreeMintAmountPerWallet)
1430     {
1431     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1432     }
1433     else {
1434          uint8 costAmount = _mintAmount + nft;
1435         if(costAmount > maxFreeMintAmountPerWallet)
1436        {
1437         costAmount = costAmount - maxFreeMintAmountPerWallet;
1438         require(msg.value >= cost * costAmount, "Insufficient funds!");
1439        }
1440        
1441          
1442     }
1443     
1444 
1445 
1446     _safeMint(msg.sender , _mintAmount);
1447 
1448     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1449      
1450      delete totalSupply;
1451      delete _mintAmount;
1452   }
1453   
1454   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1455      uint16 totalSupply = uint16(totalSupply());
1456     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1457      _safeMint(_receiver , _mintAmount);
1458      delete _mintAmount;
1459      delete _receiver;
1460      delete totalSupply;
1461   }
1462 
1463   function  Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1464      uint16 totalSupply = uint16(totalSupply());
1465      uint totalAmount =   _amountPerAddress * addresses.length;
1466     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
1467      for (uint256 i = 0; i < addresses.length; i++) {
1468             _safeMint(addresses[i], _amountPerAddress);
1469         }
1470 
1471      delete _amountPerAddress;
1472      delete totalSupply;
1473   }
1474 
1475  
1476 
1477   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1478       maxSupply = _maxSupply;
1479   }
1480 
1481 
1482 
1483    
1484   function tokenURI(uint256 _tokenId)
1485     public
1486     view
1487     virtual
1488     override
1489     returns (string memory)
1490   {
1491     require(
1492       _exists(_tokenId),
1493       "ERC721Metadata: URI query for nonexistent token"
1494     );
1495     
1496   
1497 if ( reveal == false)
1498 {
1499     return hiddenURL;
1500 }
1501     
1502 
1503     string memory currentBaseURI = _baseURI();
1504     return bytes(currentBaseURI).length > 0
1505         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1506         : "";
1507   }
1508  
1509  
1510 
1511 
1512  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1513     maxFreeMintAmountPerWallet = _limit;
1514    delete _limit;
1515 
1516 }
1517 
1518     
1519   
1520 
1521   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1522     uriPrefix = _uriPrefix;
1523   }
1524    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1525     hiddenURL = _uriPrefix;
1526   }
1527 
1528 
1529   function setPaused() external onlyOwner {
1530     paused = !paused;
1531    
1532   }
1533 
1534   function setCost(uint _cost) external onlyOwner{
1535       cost = _cost;
1536 
1537   }
1538 
1539  function setRevealed() external onlyOwner{
1540      reveal = !reveal;
1541  }
1542 
1543   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1544       maxMintAmountPerTx = _maxtx;
1545 
1546   }
1547 
1548  
1549 
1550   function withdraw() external onlyOwner {
1551   uint _balance = address(this).balance;
1552      payable(msg.sender).transfer(_balance ); 
1553        
1554   }
1555 
1556 
1557   function _baseURI() internal view  override returns (string memory) {
1558     return uriPrefix;
1559   }
1560 
1561     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1562         super.transferFrom(from, to, tokenId);
1563     }
1564 
1565     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1566         super.safeTransferFrom(from, to, tokenId);
1567     }
1568 
1569     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1570         public
1571         override
1572         onlyAllowedOperator(from)
1573     {
1574         super.safeTransferFrom(from, to, tokenId, data);
1575     }
1576 }