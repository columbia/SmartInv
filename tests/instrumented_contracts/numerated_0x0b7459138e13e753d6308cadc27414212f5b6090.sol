1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
3 /**
4 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
5 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
6 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMW0olodxdoc:lOKNNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
7 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0,...........',;cOWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
8 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNo..............'lKMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
9 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKdl:................cKMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
10 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNko:,''''''........'oXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
11 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXKOxl;;;,,,'',o0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
12 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXKx:,;;;;,'cO00KWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
13 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNKko:,'.........''..,:d0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
14 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNOo;......................'oKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
15 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXOo;............'..............,oONMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
16 MMMMMMMMMMMMMMMMMMMMMMMMMMMMXxc,...............'.................:xXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
17 MMMMMMMMMMMMMMMMMMMMMMMMMMMK:......................................;dXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
18 MMMMMMMMMMMMMMMMMMMMMMMMMMK:.........................................,xNMMMMMMMMMMMMMMMMMMMMMMMMMMMM
19 MMMMMMMMMMMMMMMMMMMMMMMMMXl............................................c0WMMMMMMMMMMMMMMMMMMMMMMMMMM
20 MMMMMMMMMMMMMMMMMMMMMMMMMO,.............................................;OWMMMMMMMMMMMMMMMMMMMMMMMMM
21 MMMMMMMMMMMMMMMMMMMMMMMMWd...............................................;KMMMMMMMMMMMMMMMMMMMMMMMMM
22 MMMMMMMMMMMMMMMMMMMMMMMMNl..................Pump My Bags  ................dWMMMMMMMMMMMMMMMMMMMMMMMM
23 MMMMMMMMMMMMMMMMMMMMMMMMWo................................................dWMMMMMMMMMMMMMMMMMMMMMMMM
24 MMMMMMMMMMMMMMMMMMMMMMMMWx'..............................................oXMMMMMMMMMMMMMMMMMMMMMMMMM
25 MMMMMMMMMMMMMMMMMMMMMMMMM0;.............................................lXMMMMMMMMMMMMMMMMMMMMMMMMMM
26 MMMMMMMMMMMMMMMMMMMMMMMMMNo............................................,kMMMMMMMMMMMMMMMMMMMMMMMMMMM
27 MMMMMMMMMMMMMMMMMMMMMMMMMMO,...........................................:KMMMMMMMMMMMMMMMMMMMMMMMMMMM
28 MMMMMMMMMMMMMMMMMMMMMMMMMM0;...........................................cXMMMMMMMMMMMMMMMMMMMMMMMMMMM
29 MMMMMMMMMMMMMMMMMMMMMMMMMMX:...........................................dWMMMMMMMMMMMMMMMMMMMMMMMMMMM
30 MMMMMMMMMMMMMMMMMMMMMMMMMMWd..........................................lXMMMMMMMMMMMMMMMMMMMMMMMMMMMM
31 MMMMMMMMMMMMMMMMMMMMMMMMMMMXo.......................................'dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
32 MMMMMMMMMMMMMMMMMMMMMMMMMMMMXc....................................'cOWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
33 MMMMMMMMMMMMMMMMMMMMMMMMMMMMW0:.................................:d0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
34 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNOxollooodddxxdddoolc:;'.......;o0NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
35 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNXKOkxxk0NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
36 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
37 
38 */
39 pragma solidity ^0.8.0;
40 
41 /**
42  * @dev Interface of the ERC165 standard, as defined in the
43  * https://eips.ethereum.org/EIPS/eip-165[EIP].
44  *
45  * Implementers can declare support of contract interfaces, which can then be
46  * queried by others ({ERC165Checker}).
47  *
48  * For an implementation, see {ERC165}.
49  */
50 interface IERC165 {
51     /**
52      * @dev Returns true if this contract implements the interface defined by
53      * `interfaceId`. See the corresponding
54      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
55      * to learn more about how these ids are created.
56      *
57      * This function call must use less than 30 000 gas.
58      */
59     function supportsInterface(bytes4 interfaceId) external view returns (bool);
60 }
61 
62 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
63 
64 pragma solidity ^0.8.0;
65 
66 /**
67  * @dev Required interface of an ERC721 compliant contract.
68  */
69 interface IERC721 is IERC165 {
70     /**
71      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
72      */
73     event Transfer(
74         address indexed from,
75         address indexed to,
76         uint256 indexed tokenId
77     );
78 
79     /**
80      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
81      */
82     event Approval(
83         address indexed owner,
84         address indexed approved,
85         uint256 indexed tokenId
86     );
87 
88     /**
89      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
90      */
91     event ApprovalForAll(
92         address indexed owner,
93         address indexed operator,
94         bool approved
95     );
96 
97     /**
98      * @dev Returns the number of tokens in ``owner``'s account.
99      */
100     function balanceOf(address owner) external view returns (uint256 balance);
101 
102     /**
103      * @dev Returns the owner of the `tokenId` token.
104      *
105      * Requirements:
106      *
107      * - `tokenId` must exist.
108      */
109     function ownerOf(uint256 tokenId) external view returns (address owner);
110 
111     /**
112      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
113      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
114      *
115      * Requirements:
116      *
117      * - `from` cannot be the zero address.
118      * - `to` cannot be the zero address.
119      * - `tokenId` token must exist and be owned by `from`.
120      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
121      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
122      *
123      * Emits a {Transfer} event.
124      */
125     function safeTransferFrom(
126         address from,
127         address to,
128         uint256 tokenId
129     ) external;
130 
131     /**
132      * @dev Transfers `tokenId` token from `from` to `to`.
133      *
134      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
135      *
136      * Requirements:
137      *
138      * - `from` cannot be the zero address.
139      * - `to` cannot be the zero address.
140      * - `tokenId` token must be owned by `from`.
141      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
142      *
143      * Emits a {Transfer} event.
144      */
145     function transferFrom(
146         address from,
147         address to,
148         uint256 tokenId
149     ) external;
150 
151     /**
152      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
153      * The approval is cleared when the token is transferred.
154      *
155      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
156      *
157      * Requirements:
158      *
159      * - The caller must own the token or be an approved operator.
160      * - `tokenId` must exist.
161      *
162      * Emits an {Approval} event.
163      */
164     function approve(address to, uint256 tokenId) external;
165 
166     /**
167      * @dev Returns the account approved for `tokenId` token.
168      *
169      * Requirements:
170      *
171      * - `tokenId` must exist.
172      */
173     function getApproved(uint256 tokenId)
174         external
175         view
176         returns (address operator);
177 
178     /**
179      * @dev Approve or remove `operator` as an operator for the caller.
180      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
181      *
182      * Requirements:
183      *
184      * - The `operator` cannot be the caller.
185      *
186      * Emits an {ApprovalForAll} event.
187      */
188     function setApprovalForAll(address operator, bool _approved) external;
189 
190     /**
191      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
192      *
193      * See {setApprovalForAll}
194      */
195     function isApprovedForAll(address owner, address operator)
196         external
197         view
198         returns (bool);
199 
200     /**
201      * @dev Safely transfers `tokenId` token from `from` to `to`.
202      *
203      * Requirements:
204      *
205      * - `from` cannot be the zero address.
206      * - `to` cannot be the zero address.
207      * - `tokenId` token must exist and be owned by `from`.
208      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
209      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
210      *
211      * Emits a {Transfer} event.
212      */
213     function safeTransferFrom(
214         address from,
215         address to,
216         uint256 tokenId,
217         bytes calldata data
218     ) external;
219 }
220 
221 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
222 
223 pragma solidity ^0.8.0;
224 
225 /**
226  * @title ERC721 token receiver interface
227  * @dev Interface for any contract that wants to support safeTransfers
228  * from ERC721 asset contracts.
229  */
230 interface IERC721Receiver {
231     /**
232      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
233      * by `operator` from `from`, this function is called.
234      *
235      * It must return its Solidity selector to confirm the token transfer.
236      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
237      *
238      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
239      */
240     function onERC721Received(
241         address operator,
242         address from,
243         uint256 tokenId,
244         bytes calldata data
245     ) external returns (bytes4);
246 }
247 
248 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
249 
250 pragma solidity ^0.8.0;
251 
252 /**
253  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
254  * @dev See https://eips.ethereum.org/EIPS/eip-721
255  */
256 interface IERC721Metadata is IERC721 {
257     /**
258      * @dev Returns the token collection name.
259      */
260     function name() external view returns (string memory);
261 
262     /**
263      * @dev Returns the token collection symbol.
264      */
265     function symbol() external view returns (string memory);
266 
267     /**
268      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
269      */
270     function tokenURI(uint256 tokenId) external view returns (string memory);
271 }
272 
273 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
274 
275 pragma solidity ^0.8.0;
276 
277 /**
278  * @dev Implementation of the {IERC165} interface.
279  *
280  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
281  * for the additional interface id that will be supported. For example:
282  *
283  * ```solidity
284  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
285  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
286  * }
287  * ```
288  *
289  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
290  */
291 abstract contract ERC165 is IERC165 {
292     /**
293      * @dev See {IERC165-supportsInterface}.
294      */
295     function supportsInterface(bytes4 interfaceId)
296         public
297         view
298         virtual
299         override
300         returns (bool)
301     {
302         return interfaceId == type(IERC165).interfaceId;
303     }
304 }
305 
306 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
307 
308 pragma solidity ^0.8.0;
309 
310 /**
311  * @dev Collection of functions related to the address type
312  */
313 library Address {
314     /**
315      * @dev Returns true if `account` is a contract.
316      *
317      * [IMPORTANT]
318      * ====
319      * It is unsafe to assume that an address for which this function returns
320      * false is an externally-owned account (EOA) and not a contract.
321      *
322      * Among others, `isContract` will return false for the following
323      * types of addresses:
324      *
325      *  - an externally-owned account
326      *  - a contract in construction
327      *  - an address where a contract will be created
328      *  - an address where a contract lived, but was destroyed
329      * ====
330      */
331     function isContract(address account) internal view returns (bool) {
332         // This method relies on extcodesize, which returns 0 for contracts in
333         // construction, since the code is only stored at the end of the
334         // constructor execution.
335 
336         uint256 size;
337         assembly {
338             size := extcodesize(account)
339         }
340         return size > 0;
341     }
342 
343     /**
344      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
345      * `recipient`, forwarding all available gas and reverting on errors.
346      *
347      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
348      * of certain opcodes, possibly making contracts go over the 2300 gas limit
349      * imposed by `transfer`, making them unable to receive funds via
350      * `transfer`. {sendValue} removes this limitation.
351      *
352      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
353      *
354      * IMPORTANT: because control is transferred to `recipient`, care must be
355      * taken to not create reentrancy vulnerabilities. Consider using
356      * {ReentrancyGuard} or the
357      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
358      */
359     function sendValue(address payable recipient, uint256 amount) internal {
360         require(
361             address(this).balance >= amount,
362             "Address: insufficient balance"
363         );
364 
365         (bool success, ) = recipient.call{value: amount}("");
366         require(
367             success,
368             "Address: unable to send value, recipient may have reverted"
369         );
370     }
371 
372     /**
373      * @dev Performs a Solidity function call using a low level `call`. A
374      * plain `call` is an unsafe replacement for a function call: use this
375      * function instead.
376      *
377      * If `target` reverts with a revert reason, it is bubbled up by this
378      * function (like regular Solidity function calls).
379      *
380      * Returns the raw returned data. To convert to the expected return value,
381      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
382      *
383      * Requirements:
384      *
385      * - `target` must be a contract.
386      * - calling `target` with `data` must not revert.
387      *
388      * _Available since v3.1._
389      */
390     function functionCall(address target, bytes memory data)
391         internal
392         returns (bytes memory)
393     {
394         return functionCall(target, data, "Address: low-level call failed");
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
399      * `errorMessage` as a fallback revert reason when `target` reverts.
400      *
401      * _Available since v3.1._
402      */
403     function functionCall(
404         address target,
405         bytes memory data,
406         string memory errorMessage
407     ) internal returns (bytes memory) {
408         return functionCallWithValue(target, data, 0, errorMessage);
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
413      * but also transferring `value` wei to `target`.
414      *
415      * Requirements:
416      *
417      * - the calling contract must have an ETH balance of at least `value`.
418      * - the called Solidity function must be `payable`.
419      *
420      * _Available since v3.1._
421      */
422     function functionCallWithValue(
423         address target,
424         bytes memory data,
425         uint256 value
426     ) internal returns (bytes memory) {
427         return
428             functionCallWithValue(
429                 target,
430                 data,
431                 value,
432                 "Address: low-level call with value failed"
433             );
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
438      * with `errorMessage` as a fallback revert reason when `target` reverts.
439      *
440      * _Available since v3.1._
441      */
442     function functionCallWithValue(
443         address target,
444         bytes memory data,
445         uint256 value,
446         string memory errorMessage
447     ) internal returns (bytes memory) {
448         require(
449             address(this).balance >= value,
450             "Address: insufficient balance for call"
451         );
452         require(isContract(target), "Address: call to non-contract");
453 
454         (bool success, bytes memory returndata) = target.call{value: value}(
455             data
456         );
457         return verifyCallResult(success, returndata, errorMessage);
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
462      * but performing a static call.
463      *
464      * _Available since v3.3._
465      */
466     function functionStaticCall(address target, bytes memory data)
467         internal
468         view
469         returns (bytes memory)
470     {
471         return
472             functionStaticCall(
473                 target,
474                 data,
475                 "Address: low-level static call failed"
476             );
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
481      * but performing a static call.
482      *
483      * _Available since v3.3._
484      */
485     function functionStaticCall(
486         address target,
487         bytes memory data,
488         string memory errorMessage
489     ) internal view returns (bytes memory) {
490         require(isContract(target), "Address: static call to non-contract");
491 
492         (bool success, bytes memory returndata) = target.staticcall(data);
493         return verifyCallResult(success, returndata, errorMessage);
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
498      * but performing a delegate call.
499      *
500      * _Available since v3.4._
501      */
502     function functionDelegateCall(address target, bytes memory data)
503         internal
504         returns (bytes memory)
505     {
506         return
507             functionDelegateCall(
508                 target,
509                 data,
510                 "Address: low-level delegate call failed"
511             );
512     }
513 
514     /**
515      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
516      * but performing a delegate call.
517      *
518      * _Available since v3.4._
519      */
520     function functionDelegateCall(
521         address target,
522         bytes memory data,
523         string memory errorMessage
524     ) internal returns (bytes memory) {
525         require(isContract(target), "Address: delegate call to non-contract");
526 
527         (bool success, bytes memory returndata) = target.delegatecall(data);
528         return verifyCallResult(success, returndata, errorMessage);
529     }
530 
531     /**
532      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
533      * revert reason using the provided one.
534      *
535      * _Available since v4.3._
536      */
537     function verifyCallResult(
538         bool success,
539         bytes memory returndata,
540         string memory errorMessage
541     ) internal pure returns (bytes memory) {
542         if (success) {
543             return returndata;
544         } else {
545             // Look for revert reason and bubble it up if present
546             if (returndata.length > 0) {
547                 // The easiest way to bubble the revert reason is using memory via assembly
548 
549                 assembly {
550                     let returndata_size := mload(returndata)
551                     revert(add(32, returndata), returndata_size)
552                 }
553             } else {
554                 revert(errorMessage);
555             }
556         }
557     }
558 }
559 
560 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
561 
562 pragma solidity ^0.8.0;
563 
564 /**
565  * @dev Provides information about the current execution context, including the
566  * sender of the transaction and its data. While these are generally available
567  * via msg.sender and msg.data, they should not be accessed in such a direct
568  * manner, since when dealing with meta-transactions the account sending and
569  * paying for execution may not be the actual sender (as far as an application
570  * is concerned).
571  *
572  * This contract is only required for intermediate, library-like contracts.
573  */
574 abstract contract Context {
575     function _msgSender() internal view virtual returns (address) {
576         return msg.sender;
577     }
578 
579     function _msgData() internal view virtual returns (bytes calldata) {
580         return msg.data;
581     }
582 }
583 
584 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
585 
586 pragma solidity ^0.8.0;
587 
588 /**
589  * @dev String operations.
590  */
591 library Strings {
592     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
593 
594     /**
595      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
596      */
597     function toString(uint256 value) internal pure returns (string memory) {
598         // Inspired by OraclizeAPI's implementation - MIT licence
599         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
600 
601         if (value == 0) {
602             return "0";
603         }
604         uint256 temp = value;
605         uint256 digits;
606         while (temp != 0) {
607             digits++;
608             temp /= 10;
609         }
610         bytes memory buffer = new bytes(digits);
611         while (value != 0) {
612             digits -= 1;
613             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
614             value /= 10;
615         }
616         return string(buffer);
617     }
618 
619     /**
620      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
621      */
622     function toHexString(uint256 value) internal pure returns (string memory) {
623         if (value == 0) {
624             return "0x00";
625         }
626         uint256 temp = value;
627         uint256 length = 0;
628         while (temp != 0) {
629             length++;
630             temp >>= 8;
631         }
632         return toHexString(value, length);
633     }
634 
635     /**
636      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
637      */
638     function toHexString(uint256 value, uint256 length)
639         internal
640         pure
641         returns (string memory)
642     {
643         bytes memory buffer = new bytes(2 * length + 2);
644         buffer[0] = "0";
645         buffer[1] = "x";
646         for (uint256 i = 2 * length + 1; i > 1; --i) {
647             buffer[i] = _HEX_SYMBOLS[value & 0xf];
648             value >>= 4;
649         }
650         require(value == 0, "Strings: hex length insufficient");
651         return string(buffer);
652     }
653 }
654 
655 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
656 
657 pragma solidity ^0.8.0;
658 
659 /**
660  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
661  * @dev See https://eips.ethereum.org/EIPS/eip-721
662  */
663 interface IERC721Enumerable is IERC721 {
664     /**
665      * @dev Returns the total amount of tokens stored by the contract.
666      */
667     function totalSupply() external view returns (uint256);
668 
669     /**
670      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
671      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
672      */
673     function tokenOfOwnerByIndex(address owner, uint256 index)
674         external
675         view
676         returns (uint256 tokenId);
677 
678     /**
679      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
680      * Use along with {totalSupply} to enumerate all tokens.
681      */
682     function tokenByIndex(uint256 index) external view returns (uint256);
683 }
684 
685 pragma solidity ^0.8.0;
686 
687 /**
688  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
689  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
690  *
691  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
692  *
693  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
694  *
695  * Does not support burning tokens to address(0).
696  */
697 contract ERC721A is
698   Context,
699   ERC165,
700   IERC721,
701   IERC721Metadata,
702   IERC721Enumerable
703 {
704   using Address for address;
705   using Strings for uint256;
706 
707   struct TokenOwnership {
708     address addr;
709     uint64 startTimestamp;
710   }
711 
712   struct AddressData {
713     uint128 balance;
714     uint128 numberMinted;
715   }
716 
717   uint256 private currentIndex = 0;
718 
719   uint256 internal immutable collectionSize;
720   uint256 internal immutable maxBatchSize;
721 
722   // Token name
723   string private _name;
724 
725   // Token symbol
726   string private _symbol;
727 
728   // Mapping from token ID to ownership details
729   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
730   mapping(uint256 => TokenOwnership) private _ownerships;
731 
732   // Mapping owner address to address data
733   mapping(address => AddressData) private _addressData;
734 
735   // Mapping from token ID to approved address
736   mapping(uint256 => address) private _tokenApprovals;
737 
738   // Mapping from owner to operator approvals
739   mapping(address => mapping(address => bool)) private _operatorApprovals;
740 
741   /**
742    * @dev
743    * `maxBatchSize` refers to how much a minter can mint at a time.
744    * `collectionSize_` refers to how many tokens are in the collection.
745    */
746   constructor(
747     string memory name_,
748     string memory symbol_,
749     uint256 maxBatchSize_,
750     uint256 collectionSize_
751   ) {
752     require(
753       collectionSize_ > 0,
754       "ERC721A: collection must have a nonzero supply"
755     );
756     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
757     _name = name_;
758     _symbol = symbol_;
759     maxBatchSize = maxBatchSize_;
760     collectionSize = collectionSize_;
761   }
762 
763   /**
764    * @dev See {IERC721Enumerable-totalSupply}.
765    */
766   function totalSupply() public view override returns (uint256) {
767     return currentIndex;
768   }
769 
770   /**
771    * @dev See {IERC721Enumerable-tokenByIndex}.
772    */
773   function tokenByIndex(uint256 index) public view override returns (uint256) {
774     require(index < totalSupply(), "ERC721A: global index out of bounds");
775     return index;
776   }
777 
778   /**
779    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
780    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
781    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
782    */
783   function tokenOfOwnerByIndex(address owner, uint256 index)
784     public
785     view
786     override
787     returns (uint256)
788   {
789     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
790     uint256 numMintedSoFar = totalSupply();
791     uint256 tokenIdsIdx = 0;
792     address currOwnershipAddr = address(0);
793     for (uint256 i = 0; i < numMintedSoFar; i++) {
794       TokenOwnership memory ownership = _ownerships[i];
795       if (ownership.addr != address(0)) {
796         currOwnershipAddr = ownership.addr;
797       }
798       if (currOwnershipAddr == owner) {
799         if (tokenIdsIdx == index) {
800           return i;
801         }
802         tokenIdsIdx++;
803       }
804     }
805     revert("ERC721A: unable to get token of owner by index");
806   }
807 
808   /**
809    * @dev See {IERC165-supportsInterface}.
810    */
811   function supportsInterface(bytes4 interfaceId)
812     public
813     view
814     virtual
815     override(ERC165, IERC165)
816     returns (bool)
817   {
818     return
819       interfaceId == type(IERC721).interfaceId ||
820       interfaceId == type(IERC721Metadata).interfaceId ||
821       interfaceId == type(IERC721Enumerable).interfaceId ||
822       super.supportsInterface(interfaceId);
823   }
824 
825   /**
826    * @dev See {IERC721-balanceOf}.
827    */
828   function balanceOf(address owner) public view override returns (uint256) {
829     require(owner != address(0), "ERC721A: balance query for the zero address");
830     return uint256(_addressData[owner].balance);
831   }
832 
833   function _numberMinted(address owner) internal view returns (uint256) {
834     require(
835       owner != address(0),
836       "ERC721A: number minted query for the zero address"
837     );
838     return uint256(_addressData[owner].numberMinted);
839   }
840 
841   function ownershipOf(uint256 tokenId)
842     internal
843     view
844     returns (TokenOwnership memory)
845   {
846     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
847 
848     uint256 lowestTokenToCheck;
849     if (tokenId >= maxBatchSize) {
850       lowestTokenToCheck = tokenId - maxBatchSize + 1;
851     }
852 
853     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
854       TokenOwnership memory ownership = _ownerships[curr];
855       if (ownership.addr != address(0)) {
856         return ownership;
857       }
858     }
859 
860     revert("ERC721A: unable to determine the owner of token");
861   }
862 
863   /**
864    * @dev See {IERC721-ownerOf}.
865    */
866   function ownerOf(uint256 tokenId) public view override returns (address) {
867     return ownershipOf(tokenId).addr;
868   }
869 
870   /**
871    * @dev See {IERC721Metadata-name}.
872    */
873   function name() public view virtual override returns (string memory) {
874     return _name;
875   }
876 
877   /**
878    * @dev See {IERC721Metadata-symbol}.
879    */
880   function symbol() public view virtual override returns (string memory) {
881     return _symbol;
882   }
883 
884   /**
885    * @dev See {IERC721Metadata-tokenURI}.
886    */
887   function tokenURI(uint256 tokenId)
888     public
889     view
890     virtual
891     override
892     returns (string memory)
893   {
894     require(
895       _exists(tokenId),
896       "ERC721Metadata: URI query for nonexistent token"
897     );
898 
899     string memory baseURI = _baseURI();
900     return
901       bytes(baseURI).length > 0
902         ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
903         : "";
904   }
905 
906   /**
907    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
908    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
909    * by default, can be overriden in child contracts.
910    */
911   function _baseURI() internal view virtual returns (string memory) {
912     return "";
913   }
914 
915   /**
916    * @dev See {IERC721-approve}.
917    */
918   function approve(address to, uint256 tokenId) public override {
919     address owner = ERC721A.ownerOf(tokenId);
920     require(to != owner, "ERC721A: approval to current owner");
921 
922     require(
923       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
924       "ERC721A: approve caller is not owner nor approved for all"
925     );
926 
927     _approve(to, tokenId, owner);
928   }
929 
930   /**
931    * @dev See {IERC721-getApproved}.
932    */
933   function getApproved(uint256 tokenId) public view override returns (address) {
934     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
935 
936     return _tokenApprovals[tokenId];
937   }
938 
939   /**
940    * @dev See {IERC721-setApprovalForAll}.
941    */
942   function setApprovalForAll(address operator, bool approved) public override {
943     require(operator != _msgSender(), "ERC721A: approve to caller");
944 
945     _operatorApprovals[_msgSender()][operator] = approved;
946     emit ApprovalForAll(_msgSender(), operator, approved);
947   }
948 
949   /**
950    * @dev See {IERC721-isApprovedForAll}.
951    */
952   function isApprovedForAll(address owner, address operator)
953     public
954     view
955     virtual
956     override
957     returns (bool)
958   {
959     return _operatorApprovals[owner][operator];
960   }
961 
962   /**
963    * @dev See {IERC721-transferFrom}.
964    */
965   function transferFrom(
966     address from,
967     address to,
968     uint256 tokenId
969   ) public override {
970     _transfer(from, to, tokenId);
971   }
972 
973   /**
974    * @dev See {IERC721-safeTransferFrom}.
975    */
976   function safeTransferFrom(
977     address from,
978     address to,
979     uint256 tokenId
980   ) public override {
981     safeTransferFrom(from, to, tokenId, "");
982   }
983 
984   /**
985    * @dev See {IERC721-safeTransferFrom}.
986    */
987   function safeTransferFrom(
988     address from,
989     address to,
990     uint256 tokenId,
991     bytes memory _data
992   ) public override {
993     _transfer(from, to, tokenId);
994     require(
995       _checkOnERC721Received(from, to, tokenId, _data),
996       "ERC721A: transfer to non ERC721Receiver implementer"
997     );
998   }
999 
1000   /**
1001    * @dev Returns whether `tokenId` exists.
1002    *
1003    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1004    *
1005    * Tokens start existing when they are minted (`_mint`),
1006    */
1007   function _exists(uint256 tokenId) internal view returns (bool) {
1008     return tokenId < currentIndex;
1009   }
1010 
1011   function _safeMint(address to, uint256 quantity) internal {
1012     _safeMint(to, quantity, "");
1013   }
1014 
1015   /**
1016    * @dev Mints `quantity` tokens and transfers them to `to`.
1017    *
1018    * Requirements:
1019    *
1020    * - there must be `quantity` tokens remaining unminted in the total collection.
1021    * - `to` cannot be the zero address.
1022    * - `quantity` cannot be larger than the max batch size.
1023    *
1024    * Emits a {Transfer} event.
1025    */
1026   function _safeMint(
1027     address to,
1028     uint256 quantity,
1029     bytes memory _data
1030   ) internal {
1031     uint256 startTokenId = currentIndex;
1032     require(to != address(0), "ERC721A: mint to the zero address");
1033     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1034     require(!_exists(startTokenId), "ERC721A: token already minted");
1035     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1036 
1037     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1038 
1039     AddressData memory addressData = _addressData[to];
1040     _addressData[to] = AddressData(
1041       addressData.balance + uint128(quantity),
1042       addressData.numberMinted + uint128(quantity)
1043     );
1044     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1045 
1046     uint256 updatedIndex = startTokenId;
1047 
1048     for (uint256 i = 0; i < quantity; i++) {
1049       emit Transfer(address(0), to, updatedIndex);
1050       require(
1051         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1052         "ERC721A: transfer to non ERC721Receiver implementer"
1053       );
1054       updatedIndex++;
1055     }
1056 
1057     currentIndex = updatedIndex;
1058     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1059   }
1060 
1061   /**
1062    * @dev Transfers `tokenId` from `from` to `to`.
1063    *
1064    * Requirements:
1065    *
1066    * - `to` cannot be the zero address.
1067    * - `tokenId` token must be owned by `from`.
1068    *
1069    * Emits a {Transfer} event.
1070    */
1071   function _transfer(
1072     address from,
1073     address to,
1074     uint256 tokenId
1075   ) private {
1076     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1077 
1078     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1079       getApproved(tokenId) == _msgSender() ||
1080       isApprovedForAll(prevOwnership.addr, _msgSender()));
1081 
1082     require(
1083       isApprovedOrOwner,
1084       "ERC721A: transfer caller is not owner nor approved"
1085     );
1086 
1087     require(
1088       prevOwnership.addr == from,
1089       "ERC721A: transfer from incorrect owner"
1090     );
1091     require(to != address(0), "ERC721A: transfer to the zero address");
1092 
1093     _beforeTokenTransfers(from, to, tokenId, 1);
1094 
1095     // Clear approvals from the previous owner
1096     _approve(address(0), tokenId, prevOwnership.addr);
1097 
1098     _addressData[from].balance -= 1;
1099     _addressData[to].balance += 1;
1100     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1101 
1102     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1103     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1104     uint256 nextTokenId = tokenId + 1;
1105     if (_ownerships[nextTokenId].addr == address(0)) {
1106       if (_exists(nextTokenId)) {
1107         _ownerships[nextTokenId] = TokenOwnership(
1108           prevOwnership.addr,
1109           prevOwnership.startTimestamp
1110         );
1111       }
1112     }
1113 
1114     emit Transfer(from, to, tokenId);
1115     _afterTokenTransfers(from, to, tokenId, 1);
1116   }
1117 
1118   /**
1119    * @dev Approve `to` to operate on `tokenId`
1120    *
1121    * Emits a {Approval} event.
1122    */
1123   function _approve(
1124     address to,
1125     uint256 tokenId,
1126     address owner
1127   ) private {
1128     _tokenApprovals[tokenId] = to;
1129     emit Approval(owner, to, tokenId);
1130   }
1131 
1132   uint256 public nextOwnerToExplicitlySet = 0;
1133 
1134   /**
1135    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1136    */
1137   function _setOwnersExplicit(uint256 quantity) internal {
1138     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1139     require(quantity > 0, "quantity must be nonzero");
1140     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1141     if (endIndex > collectionSize - 1) {
1142       endIndex = collectionSize - 1;
1143     }
1144     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1145     require(_exists(endIndex), "not enough minted yet for this cleanup");
1146     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1147       if (_ownerships[i].addr == address(0)) {
1148         TokenOwnership memory ownership = ownershipOf(i);
1149         _ownerships[i] = TokenOwnership(
1150           ownership.addr,
1151           ownership.startTimestamp
1152         );
1153       }
1154     }
1155     nextOwnerToExplicitlySet = endIndex + 1;
1156   }
1157 
1158   /**
1159    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1160    * The call is not executed if the target address is not a contract.
1161    *
1162    * @param from address representing the previous owner of the given token ID
1163    * @param to target address that will receive the tokens
1164    * @param tokenId uint256 ID of the token to be transferred
1165    * @param _data bytes optional data to send along with the call
1166    * @return bool whether the call correctly returned the expected magic value
1167    */
1168   function _checkOnERC721Received(
1169     address from,
1170     address to,
1171     uint256 tokenId,
1172     bytes memory _data
1173   ) private returns (bool) {
1174     if (to.isContract()) {
1175       try
1176         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1177       returns (bytes4 retval) {
1178         return retval == IERC721Receiver(to).onERC721Received.selector;
1179       } catch (bytes memory reason) {
1180         if (reason.length == 0) {
1181           revert("ERC721A: transfer to non ERC721Receiver implementer");
1182         } else {
1183           assembly {
1184             revert(add(32, reason), mload(reason))
1185           }
1186         }
1187       }
1188     } else {
1189       return true;
1190     }
1191   }
1192 
1193   /**
1194    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1195    *
1196    * startTokenId - the first token id to be transferred
1197    * quantity - the amount to be transferred
1198    *
1199    * Calling conditions:
1200    *
1201    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1202    * transferred to `to`.
1203    * - When `from` is zero, `tokenId` will be minted for `to`.
1204    */
1205   function _beforeTokenTransfers(
1206     address from,
1207     address to,
1208     uint256 startTokenId,
1209     uint256 quantity
1210   ) internal virtual {}
1211 
1212   /**
1213    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1214    * minting.
1215    *
1216    * startTokenId - the first token id to be transferred
1217    * quantity - the amount to be transferred
1218    *
1219    * Calling conditions:
1220    *
1221    * - when `from` and `to` are both non-zero.
1222    * - `from` and `to` are never both zero.
1223    */
1224   function _afterTokenTransfers(
1225     address from,
1226     address to,
1227     uint256 startTokenId,
1228     uint256 quantity
1229   ) internal virtual {}
1230 }
1231 
1232 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1233 
1234 pragma solidity ^0.8.0;
1235 
1236 /**
1237  * @dev Contract module which provides a basic access control mechanism, where
1238  * there is an account (an owner) that can be granted exclusive access to
1239  * specific functions.
1240  *
1241  * By default, the owner account will be the one that deploys the contract. This
1242  * can later be changed with {transferOwnership}.
1243  *
1244  * This module is used through inheritance. It will make available the modifier
1245  * `onlyOwner`, which can be applied to your functions to restrict their use to
1246  * the owner.
1247  */
1248 abstract contract Ownable is Context {
1249     address private _owner;
1250 
1251     event OwnershipTransferred(
1252         address indexed previousOwner,
1253         address indexed newOwner
1254     );
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
1274         require(owner() == _msgSender(), "You are not the owner");
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
1294         require(
1295             newOwner != address(0),
1296             "Ownable: new owner is the zero address"
1297         );
1298         _transferOwnership(newOwner);
1299     }
1300 
1301     /**
1302      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1303      * Internal function without access restriction.
1304      */
1305     function _transferOwnership(address newOwner) internal virtual {
1306         address oldOwner = _owner;
1307         _owner = newOwner;
1308         emit OwnershipTransferred(oldOwner, newOwner);
1309     }
1310 }
1311 
1312 pragma solidity ^0.8.0;
1313 
1314 contract PumpMyBags is ERC721A, Ownable {
1315     uint256 public NFT_PRICE = 0.001 ether;
1316     uint256 public MAX_SUPPLY = 3000;
1317     uint256 public FREE_MAX_SUPPLY = 300;
1318     uint256 public OwnerMint = 5;
1319     uint256 public constant MAX_PER_TX_FREE = 5;
1320     uint256 public MAX_MINTS = 10;
1321     string public baseURI = "";
1322     string public baseExtension = ".json";
1323      bool public paused = true;   
1324     
1325     constructor() ERC721A("Pump My Bags", "PMBAG", MAX_MINTS, MAX_SUPPLY) { 
1326         
1327     }
1328     
1329 
1330     function mint(uint256 numTokens) public payable {
1331         require(!paused, "Paused");
1332         require(numTokens > 0 && numTokens <= MAX_MINTS);
1333         require(totalSupply() + numTokens <= MAX_SUPPLY);
1334         if (FREE_MAX_SUPPLY >= totalSupply() + numTokens) {
1335             require(MAX_PER_TX_FREE >= numTokens, "Excess max per free tx");
1336         } else {
1337             require(MAX_MINTS >= numTokens, "Excess max per paid tx");
1338             require(msg.value >= numTokens * NFT_PRICE, "Invalid funds provided");
1339         }
1340         _safeMint(msg.sender, numTokens);
1341     }
1342     function Ownermint(uint256 numTokens) public onlyOwner{
1343         require(totalSupply() + numTokens <= OwnerMint);
1344         _safeMint(msg.sender, numTokens);
1345     }
1346 
1347     function pause(bool _state) public onlyOwner {
1348         paused = _state;
1349     }
1350     function setBaseURI(string memory newBaseURI) public onlyOwner {
1351         baseURI = newBaseURI;
1352     }
1353     function tokenURI(uint256 _tokenId)
1354         public
1355         view
1356         override
1357         returns (string memory)
1358     {
1359         require(_exists(_tokenId), "That token doesn't exist");
1360         return
1361             bytes(baseURI).length > 0
1362                 ? string(
1363                     abi.encodePacked(
1364                         baseURI,
1365                         Strings.toString(_tokenId),
1366                         baseExtension
1367                     )
1368                 )
1369                 : "";
1370     }
1371 
1372 
1373     function setPrice(uint256 newPrice) public onlyOwner {
1374         NFT_PRICE = newPrice;
1375     }
1376     function setMaxFreeMints(uint256 newFreeMax) public onlyOwner {
1377         FREE_MAX_SUPPLY = newFreeMax;
1378     }
1379 
1380     function _baseURI() internal view virtual override returns (string memory) {
1381         return baseURI;
1382     }
1383 
1384     function withdraw() public onlyOwner {
1385         require(payable(msg.sender).send(address(this).balance));
1386     }
1387 }