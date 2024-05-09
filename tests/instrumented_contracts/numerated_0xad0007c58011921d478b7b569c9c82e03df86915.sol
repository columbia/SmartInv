1 /**
2 
3 ░▐█▀▄─ █▀▀ █───█ ▄▀▄ █▀▀▄ █▀▀
4 ░▐█▀▀▄ █▀▀ █─█─█ █▀█ █▐█▀ █▀▀
5 ░▐█▄▄▀ ▀▀▀ ─▀─▀─ ▀─▀ ▀─▀▀ ▀▀▀
6 ▒▒▒▒██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▒▒▒▒
7 ▒▒████▄▒▒▒▄▄▄▄▄▄▄▒▒▒▄████▒▒
8 ▒▒▒▒▒▀▀▒▄█████████▄▒▀▀▒▒▒▒▒
9 ▒▒▒▒▒▒▒█████████████▒▒▒▒▒▒▒
10 ▒▒▒▒▒▒▒██▀▀▀███▀▀▀██▒▒▒▒▒▒▒
11 ▒▒▒▒▒▒▒██▒▒▒███▒▒▒██▒▒▒▒▒▒▒
12 ▒▒▒▒▒▒▒█████▀▄▀█████▒▒▒▒▒▒▒
13 ▒▒▒▒▒▒▒▒▒▒███████▒▒▒▒▒▒▒▒▒▒
14 ▒▒▒▒▄▄▄██▒▒█▀█▀█▒▒██▄▄▄▒▒▒▒
15 ▒▒▒▒▀▀██▒▒▒▒▒▒▒▒▒▒▒██▀▀▒▒▒▒
16 ▒▒▒▒▒▒▀▀▒▒▒▒▒▒▒▒▒▒▒▀▀▒▒▒▒▒▒
17 ░▐█▀█▄ ▄▀▄ █▄─█ ▄▀▀─ █▀▀ █▀▀▄
18 ░▐█▌▐█ █▀█ █─▀█ █─▀▌ █▀▀ █▐█▀
19 ░▐█▄█▀ ▀─▀ ▀──▀ ▀▀▀─ ▀▀▀ ▀─▀▀
20                                                                           
21                                   ██████████████                          
22                                 ██▓▓▓▓▓▓▓▓▓▓▓▓▓▓████                      
23                               ████▓▓▓▓▓▓░░░░▓▓▓▓░░██                      
24                             ██▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░██                    
25                             ██▓▓▓▓▓▓░░░░░░██░░░░██░░██                    
26                             ██▓▓██▓▓░░░░░░██░░░░██░░██                    
27                             ██▓▓██▓▓░░██░░░░░░░░░░░░░░██                  
28                               ██▓▓▓▓██░░░░░░░░░░░░░░░░░░██                
29                   ██████        ██▓▓██░░░░░░░░████░░░░░░██                
30                 ██▓▓▓▓▓▓██        ██░░████████░░░░██████                  
31               ██▓▓▓▓▓▓▓▓▓▓██      ████░░░░░░░░░░░░░░██                    
32               ██▓▓▓▓██▓▓▓▓██    ██▓▓▓▓██████████████                      
33               ██▓▓▓▓▓▓██████████▓▓▓▓▓▓▓▓▓▓██▓▓▓▓██                        
34                 ██▓▓▓▓▓▓▓▓▓▓██▓▓▓▓▓▓▓▓██▓▓▓▓██▓▓▓▓██                      
35                   ████████████▓▓▓▓▓▓▓▓▓▓██▓▓▓▓██▓▓▓▓██                    
36                             ██████████▓▓██░░░░░░██░░░░██                  
37                           ██░░░░░░░░░░██░░░░░░░░██░░░░██                  
38                           ██░░░░░░░░░░██░░░░░░██░░░░██                    
39                           ██████████████████████████                      
40                                                                           
41 
42 
43 █▀▄ █▀▀ ▄▀█ █▀▄   ▄▀█ █▀█ █▀▀   █▄█ ▄▀█ █▀▀ █░█ ▀█▀   █▀▀ █░░ █░█ █▄▄
44 █▄▀ ██▄ █▀█ █▄▀   █▀█ █▀▀ ██▄   ░█░ █▀█ █▄▄ █▀█ ░█░   █▄▄ █▄▄ █▄█ █▄█                                                                          
45 */
46 // SPDX-License-Identifier: MIT
47 //Developer Info:
48 
49 
50 
51 // File: @openzeppelin/contracts/utils/Strings.sol
52 
53 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
54 
55 pragma solidity ^0.8.0;
56 
57 /**
58  * @dev String operations.
59  */
60 library Strings {
61     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
62 
63     /**
64      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
65      */
66     function toString(uint256 value) internal pure returns (string memory) {
67         // Inspired by OraclizeAPI's implementation - MIT licence
68         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
69 
70         if (value == 0) {
71             return "0";
72         }
73         uint256 temp = value;
74         uint256 digits;
75         while (temp != 0) {
76             digits++;
77             temp /= 10;
78         }
79         bytes memory buffer = new bytes(digits);
80         while (value != 0) {
81             digits -= 1;
82             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
83             value /= 10;
84         }
85         return string(buffer);
86     }
87 
88     /**
89      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
90      */
91     function toHexString(uint256 value) internal pure returns (string memory) {
92         if (value == 0) {
93             return "0x00";
94         }
95         uint256 temp = value;
96         uint256 length = 0;
97         while (temp != 0) {
98             length++;
99             temp >>= 8;
100         }
101         return toHexString(value, length);
102     }
103 
104     /**
105      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
106      */
107     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
108         bytes memory buffer = new bytes(2 * length + 2);
109         buffer[0] = "0";
110         buffer[1] = "x";
111         for (uint256 i = 2 * length + 1; i > 1; --i) {
112             buffer[i] = _HEX_SYMBOLS[value & 0xf];
113             value >>= 4;
114         }
115         require(value == 0, "Strings: hex length insufficient");
116         return string(buffer);
117     }
118 }
119 
120 // File: @openzeppelin/contracts/utils/Context.sol
121 
122 
123 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
124 
125 pragma solidity ^0.8.0;
126 
127 /**
128  * @dev Provides information about the current execution context, including the
129  * sender of the transaction and its data. While these are generally available
130  * via msg.sender and msg.data, they should not be accessed in such a direct
131  * manner, since when dealing with meta-transactions the account sending and
132  * paying for execution may not be the actual sender (as far as an application
133  * is concerned).
134  *
135  * This contract is only required for intermediate, library-like contracts.
136  */
137 abstract contract Context {
138     function _msgSender() internal view virtual returns (address) {
139         return msg.sender;
140     }
141 
142     function _msgData() internal view virtual returns (bytes calldata) {
143         return msg.data;
144     }
145 }
146 
147 // File: @openzeppelin/contracts/utils/Address.sol
148 
149 
150 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
151 
152 pragma solidity ^0.8.1;
153 
154 /**
155  * @dev Collection of functions related to the address type
156  */
157 library Address {
158     /**
159      * @dev Returns true if `account` is a contract.
160      *
161      * [IMPORTANT]
162      * ====
163      * It is unsafe to assume that an address for which this function returns
164      * false is an externally-owned account (EOA) and not a contract.
165      *
166      * Among others, `isContract` will return false for the following
167      * types of addresses:
168      *
169      *  - an externally-owned account
170      *  - a contract in construction
171      *  - an address where a contract will be created
172      *  - an address where a contract lived, but was destroyed
173      * ====
174      *
175      * [IMPORTANT]
176      * ====
177      * You shouldn't rely on `isContract` to protect against flash loan attacks!
178      *
179      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
180      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
181      * constructor.
182      * ====
183      */
184     function isContract(address account) internal view returns (bool) {
185         // This method relies on extcodesize/address.code.length, which returns 0
186         // for contracts in construction, since the code is only stored at the end
187         // of the constructor execution.
188 
189         return account.code.length > 0;
190     }
191 
192     /**
193      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
194      * `recipient`, forwarding all available gas and reverting on errors.
195      *
196      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
197      * of certain opcodes, possibly making contracts go over the 2300 gas limit
198      * imposed by `transfer`, making them unable to receive funds via
199      * `transfer`. {sendValue} removes this limitation.
200      *
201      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
202      *
203      * IMPORTANT: because control is transferred to `recipient`, care must be
204      * taken to not create reentrancy vulnerabilities. Consider using
205      * {ReentrancyGuard} or the
206      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
207      */
208     function sendValue(address payable recipient, uint256 amount) internal {
209         require(address(this).balance >= amount, "Address: insufficient balance");
210 
211         (bool success, ) = recipient.call{value: amount}("");
212         require(success, "Address: unable to send value, recipient may have reverted");
213     }
214 
215     /**
216      * @dev Performs a Solidity function call using a low level `call`. A
217      * plain `call` is an unsafe replacement for a function call: use this
218      * function instead.
219      *
220      * If `target` reverts with a revert reason, it is bubbled up by this
221      * function (like regular Solidity function calls).
222      *
223      * Returns the raw returned data. To convert to the expected return value,
224      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
225      *
226      * Requirements:
227      *
228      * - `target` must be a contract.
229      * - calling `target` with `data` must not revert.
230      *
231      * _Available since v3.1._
232      */
233     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
234         return functionCall(target, data, "Address: low-level call failed");
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
239      * `errorMessage` as a fallback revert reason when `target` reverts.
240      *
241      * _Available since v3.1._
242      */
243     function functionCall(
244         address target,
245         bytes memory data,
246         string memory errorMessage
247     ) internal returns (bytes memory) {
248         return functionCallWithValue(target, data, 0, errorMessage);
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
253      * but also transferring `value` wei to `target`.
254      *
255      * Requirements:
256      *
257      * - the calling contract must have an ETH balance of at least `value`.
258      * - the called Solidity function must be `payable`.
259      *
260      * _Available since v3.1._
261      */
262     function functionCallWithValue(
263         address target,
264         bytes memory data,
265         uint256 value
266     ) internal returns (bytes memory) {
267         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
272      * with `errorMessage` as a fallback revert reason when `target` reverts.
273      *
274      * _Available since v3.1._
275      */
276     function functionCallWithValue(
277         address target,
278         bytes memory data,
279         uint256 value,
280         string memory errorMessage
281     ) internal returns (bytes memory) {
282         require(address(this).balance >= value, "Address: insufficient balance for call");
283         require(isContract(target), "Address: call to non-contract");
284 
285         (bool success, bytes memory returndata) = target.call{value: value}(data);
286         return verifyCallResult(success, returndata, errorMessage);
287     }
288 
289     /**
290      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
291      * but performing a static call.
292      *
293      * _Available since v3.3._
294      */
295     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
296         return functionStaticCall(target, data, "Address: low-level static call failed");
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
301      * but performing a static call.
302      *
303      * _Available since v3.3._
304      */
305     function functionStaticCall(
306         address target,
307         bytes memory data,
308         string memory errorMessage
309     ) internal view returns (bytes memory) {
310         require(isContract(target), "Address: static call to non-contract");
311 
312         (bool success, bytes memory returndata) = target.staticcall(data);
313         return verifyCallResult(success, returndata, errorMessage);
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
318      * but performing a delegate call.
319      *
320      * _Available since v3.4._
321      */
322     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
323         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
328      * but performing a delegate call.
329      *
330      * _Available since v3.4._
331      */
332     function functionDelegateCall(
333         address target,
334         bytes memory data,
335         string memory errorMessage
336     ) internal returns (bytes memory) {
337         require(isContract(target), "Address: delegate call to non-contract");
338 
339         (bool success, bytes memory returndata) = target.delegatecall(data);
340         return verifyCallResult(success, returndata, errorMessage);
341     }
342 
343     /**
344      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
345      * revert reason using the provided one.
346      *
347      * _Available since v4.3._
348      */
349     function verifyCallResult(
350         bool success,
351         bytes memory returndata,
352         string memory errorMessage
353     ) internal pure returns (bytes memory) {
354         if (success) {
355             return returndata;
356         } else {
357             // Look for revert reason and bubble it up if present
358             if (returndata.length > 0) {
359                 // The easiest way to bubble the revert reason is using memory via assembly
360 
361                 assembly {
362                     let returndata_size := mload(returndata)
363                     revert(add(32, returndata), returndata_size)
364                 }
365             } else {
366                 revert(errorMessage);
367             }
368         }
369     }
370 }
371 
372 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
373 
374 
375 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
376 
377 pragma solidity ^0.8.0;
378 
379 /**
380  * @title ERC721 token receiver interface
381  * @dev Interface for any contract that wants to support safeTransfers
382  * from ERC721 asset contracts.
383  */
384 interface IERC721Receiver {
385     /**
386      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
387      * by `operator` from `from`, this function is called.
388      *
389      * It must return its Solidity selector to confirm the token transfer.
390      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
391      *
392      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
393      */
394     function onERC721Received(
395         address operator,
396         address from,
397         uint256 tokenId,
398         bytes calldata data
399     ) external returns (bytes4);
400 }
401 
402 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
403 
404 
405 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
406 
407 pragma solidity ^0.8.0;
408 
409 /**
410  * @dev Interface of the ERC165 standard, as defined in the
411  * https://eips.ethereum.org/EIPS/eip-165[EIP].
412  *
413  * Implementers can declare support of contract interfaces, which can then be
414  * queried by others ({ERC165Checker}).
415  *
416  * For an implementation, see {ERC165}.
417  */
418 interface IERC165 {
419     /**
420      * @dev Returns true if this contract implements the interface defined by
421      * `interfaceId`. See the corresponding
422      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
423      * to learn more about how these ids are created.
424      *
425      * This function call must use less than 30 000 gas.
426      */
427     function supportsInterface(bytes4 interfaceId) external view returns (bool);
428 }
429 
430 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
431 
432 
433 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
434 
435 pragma solidity ^0.8.0;
436 
437 
438 /**
439  * @dev Implementation of the {IERC165} interface.
440  *
441  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
442  * for the additional interface id that will be supported. For example:
443  *
444  * ```solidity
445  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
446  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
447  * }
448  * ```
449  *
450  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
451  */
452 abstract contract ERC165 is IERC165 {
453     /**
454      * @dev See {IERC165-supportsInterface}.
455      */
456     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
457         return interfaceId == type(IERC165).interfaceId;
458     }
459 }
460 
461 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
462 
463 
464 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
465 
466 pragma solidity ^0.8.0;
467 
468 
469 /**
470  * @dev Required interface of an ERC721 compliant contract.
471  */
472 interface IERC721 is IERC165 {
473     /**
474      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
475      */
476     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
477 
478     /**
479      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
480      */
481     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
482 
483     /**
484      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
485      */
486     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
487 
488     /**
489      * @dev Returns the number of tokens in ``owner``'s account.
490      */
491     function balanceOf(address owner) external view returns (uint256 balance);
492 
493     /**
494      * @dev Returns the owner of the `tokenId` token.
495      *
496      * Requirements:
497      *
498      * - `tokenId` must exist.
499      */
500     function ownerOf(uint256 tokenId) external view returns (address owner);
501 
502     /**
503      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
504      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
505      *
506      * Requirements:
507      *
508      * - `from` cannot be the zero address.
509      * - `to` cannot be the zero address.
510      * - `tokenId` token must exist and be owned by `from`.
511      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
512      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
513      *
514      * Emits a {Transfer} event.
515      */
516     function safeTransferFrom(
517         address from,
518         address to,
519         uint256 tokenId
520     ) external;
521 
522     /**
523      * @dev Transfers `tokenId` token from `from` to `to`.
524      *
525      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
526      *
527      * Requirements:
528      *
529      * - `from` cannot be the zero address.
530      * - `to` cannot be the zero address.
531      * - `tokenId` token must be owned by `from`.
532      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
533      *
534      * Emits a {Transfer} event.
535      */
536     function transferFrom(
537         address from,
538         address to,
539         uint256 tokenId
540     ) external;
541 
542     /**
543      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
544      * The approval is cleared when the token is transferred.
545      *
546      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
547      *
548      * Requirements:
549      *
550      * - The caller must own the token or be an approved operator.
551      * - `tokenId` must exist.
552      *
553      * Emits an {Approval} event.
554      */
555     function approve(address to, uint256 tokenId) external;
556 
557     /**
558      * @dev Returns the account approved for `tokenId` token.
559      *
560      * Requirements:
561      *
562      * - `tokenId` must exist.
563      */
564     function getApproved(uint256 tokenId) external view returns (address operator);
565 
566     /**
567      * @dev Approve or remove `operator` as an operator for the caller.
568      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
569      *
570      * Requirements:
571      *
572      * - The `operator` cannot be the caller.
573      *
574      * Emits an {ApprovalForAll} event.
575      */
576     function setApprovalForAll(address operator, bool _approved) external;
577 
578     /**
579      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
580      *
581      * See {setApprovalForAll}
582      */
583     function isApprovedForAll(address owner, address operator) external view returns (bool);
584 
585     /**
586      * @dev Safely transfers `tokenId` token from `from` to `to`.
587      *
588      * Requirements:
589      *
590      * - `from` cannot be the zero address.
591      * - `to` cannot be the zero address.
592      * - `tokenId` token must exist and be owned by `from`.
593      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
594      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
595      *
596      * Emits a {Transfer} event.
597      */
598     function safeTransferFrom(
599         address from,
600         address to,
601         uint256 tokenId,
602         bytes calldata data
603     ) external;
604 }
605 
606 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
607 
608 
609 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
610 
611 pragma solidity ^0.8.0;
612 
613 
614 /**
615  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
616  * @dev See https://eips.ethereum.org/EIPS/eip-721
617  */
618 interface IERC721Metadata is IERC721 {
619     /**
620      * @dev Returns the token collection name.
621      */
622     function name() external view returns (string memory);
623 
624     /**
625      * @dev Returns the token collection symbol.
626      */
627     function symbol() external view returns (string memory);
628 
629     /**
630      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
631      */
632     function tokenURI(uint256 tokenId) external view returns (string memory);
633 }
634 
635 // File: contracts/new.sol
636 
637 
638 
639 
640 pragma solidity ^0.8.4;
641 
642 
643 
644 
645 
646 
647 
648 
649 error ApprovalCallerNotOwnerNorApproved();
650 error ApprovalQueryForNonexistentToken();
651 error ApproveToCaller();
652 error ApprovalToCurrentOwner();
653 error BalanceQueryForZeroAddress();
654 error MintToZeroAddress();
655 error MintZeroQuantity();
656 error OwnerQueryForNonexistentToken();
657 error TransferCallerNotOwnerNorApproved();
658 error TransferFromIncorrectOwner();
659 error TransferToNonERC721ReceiverImplementer();
660 error TransferToZeroAddress();
661 error URIQueryForNonexistentToken();
662 
663 /**
664  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
665  * the Metadata extension. Built to optimize for lower gas during batch mints.
666  *
667  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
668  *
669  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
670  *
671  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
672  */
673 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
674     using Address for address;
675     using Strings for uint256;
676 
677     // Compiler will pack this into a single 256bit word.
678     struct TokenOwnership {
679         // The address of the owner.
680         address addr;
681         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
682         uint64 startTimestamp;
683         // Whether the token has been burned.
684         bool burned;
685     }
686 
687     // Compiler will pack this into a single 256bit word.
688     struct AddressData {
689         // Realistically, 2**64-1 is more than enough.
690         uint64 balance;
691         // Keeps track of mint count with minimal overhead for tokenomics.
692         uint64 numberMinted;
693         // Keeps track of burn count with minimal overhead for tokenomics.
694         uint64 numberBurned;
695         // For miscellaneous variable(s) pertaining to the address
696         // (e.g. number of whitelist mint slots used).
697         // If there are multiple variables, please pack them into a uint64.
698         uint64 aux;
699     }
700 
701     // The tokenId of the next token to be minted.
702     uint256 internal _currentIndex;
703 
704     // The number of tokens burned.
705     uint256 internal _burnCounter;
706 
707     // Token name
708     string private _name;
709 
710     // Token symbol
711     string private _symbol;
712 
713     // Mapping from token ID to ownership details
714     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
715     mapping(uint256 => TokenOwnership) internal _ownerships;
716 
717     // Mapping owner address to address data
718     mapping(address => AddressData) private _addressData;
719 
720     // Mapping from token ID to approved address
721     mapping(uint256 => address) private _tokenApprovals;
722 
723     // Mapping from owner to operator approvals
724     mapping(address => mapping(address => bool)) private _operatorApprovals;
725 
726     constructor(string memory name_, string memory symbol_) {
727         _name = name_;
728         _symbol = symbol_;
729         _currentIndex = _startTokenId();
730     }
731 
732     /**
733      * To change the starting tokenId, please override this function.
734      */
735     function _startTokenId() internal view virtual returns (uint256) {
736         return 1;
737     }
738 
739     /**
740      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
741      */
742     function totalSupply() public view returns (uint256) {
743         // Counter underflow is impossible as _burnCounter cannot be incremented
744         // more than _currentIndex - _startTokenId() times
745         unchecked {
746             return _currentIndex - _burnCounter - _startTokenId();
747         }
748     }
749 
750     /**
751      * Returns the total amount of tokens minted in the contract.
752      */
753     function _totalMinted() internal view returns (uint256) {
754         // Counter underflow is impossible as _currentIndex does not decrement,
755         // and it is initialized to _startTokenId()
756         unchecked {
757             return _currentIndex - _startTokenId();
758         }
759     }
760 
761     /**
762      * @dev See {IERC165-supportsInterface}.
763      */
764     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
765         return
766             interfaceId == type(IERC721).interfaceId ||
767             interfaceId == type(IERC721Metadata).interfaceId ||
768             super.supportsInterface(interfaceId);
769     }
770 
771     /**
772      * @dev See {IERC721-balanceOf}.
773      */
774     function balanceOf(address owner) public view override returns (uint256) {
775         if (owner == address(0)) revert BalanceQueryForZeroAddress();
776         return uint256(_addressData[owner].balance);
777     }
778 
779     /**
780      * Returns the number of tokens minted by `owner`.
781      */
782     function _numberMinted(address owner) internal view returns (uint256) {
783         return uint256(_addressData[owner].numberMinted);
784     }
785 
786     /**
787      * Returns the number of tokens burned by or on behalf of `owner`.
788      */
789     function _numberBurned(address owner) internal view returns (uint256) {
790         return uint256(_addressData[owner].numberBurned);
791     }
792 
793     /**
794      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
795      */
796     function _getAux(address owner) internal view returns (uint64) {
797         return _addressData[owner].aux;
798     }
799 
800     /**
801      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
802      * If there are multiple variables, please pack them into a uint64.
803      */
804     function _setAux(address owner, uint64 aux) internal {
805         _addressData[owner].aux = aux;
806     }
807 
808     /**
809      * Gas spent here starts off proportional to the maximum mint batch size.
810      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
811      */
812     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
813         uint256 curr = tokenId;
814 
815         unchecked {
816             if (_startTokenId() <= curr && curr < _currentIndex) {
817                 TokenOwnership memory ownership = _ownerships[curr];
818                 if (!ownership.burned) {
819                     if (ownership.addr != address(0)) {
820                         return ownership;
821                     }
822                     // Invariant:
823                     // There will always be an ownership that has an address and is not burned
824                     // before an ownership that does not have an address and is not burned.
825                     // Hence, curr will not underflow.
826                     while (true) {
827                         curr--;
828                         ownership = _ownerships[curr];
829                         if (ownership.addr != address(0)) {
830                             return ownership;
831                         }
832                     }
833                 }
834             }
835         }
836         revert OwnerQueryForNonexistentToken();
837     }
838 
839     /**
840      * @dev See {IERC721-ownerOf}.
841      */
842     function ownerOf(uint256 tokenId) public view override returns (address) {
843         return _ownershipOf(tokenId).addr;
844     }
845 
846     /**
847      * @dev See {IERC721Metadata-name}.
848      */
849     function name() public view virtual override returns (string memory) {
850         return _name;
851     }
852 
853     /**
854      * @dev See {IERC721Metadata-symbol}.
855      */
856     function symbol() public view virtual override returns (string memory) {
857         return _symbol;
858     }
859 
860     /**
861      * @dev See {IERC721Metadata-tokenURI}.
862      */
863     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
864         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
865 
866         string memory baseURI = _baseURI();
867         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
868     }
869 
870     /**
871      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
872      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
873      * by default, can be overriden in child contracts.
874      */
875     function _baseURI() internal view virtual returns (string memory) {
876         return '';
877     }
878 
879     /**
880      * @dev See {IERC721-approve}.
881      */
882     function approve(address to, uint256 tokenId) public override {
883         address owner = ERC721A.ownerOf(tokenId);
884         if (to == owner) revert ApprovalToCurrentOwner();
885 
886         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
887             revert ApprovalCallerNotOwnerNorApproved();
888         }
889 
890         _approve(to, tokenId, owner);
891     }
892 
893     /**
894      * @dev See {IERC721-getApproved}.
895      */
896     function getApproved(uint256 tokenId) public view override returns (address) {
897         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
898 
899         return _tokenApprovals[tokenId];
900     }
901 
902     /**
903      * @dev See {IERC721-setApprovalForAll}.
904      */
905     function setApprovalForAll(address operator, bool approved) public virtual override {
906         if (operator == _msgSender()) revert ApproveToCaller();
907 
908         _operatorApprovals[_msgSender()][operator] = approved;
909         emit ApprovalForAll(_msgSender(), operator, approved);
910     }
911 
912     /**
913      * @dev See {IERC721-isApprovedForAll}.
914      */
915     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
916         return _operatorApprovals[owner][operator];
917     }
918 
919     /**
920      * @dev See {IERC721-transferFrom}.
921      */
922     function transferFrom(
923         address from,
924         address to,
925         uint256 tokenId
926     ) public virtual override {
927         _transfer(from, to, tokenId);
928     }
929 
930     /**
931      * @dev See {IERC721-safeTransferFrom}.
932      */
933     function safeTransferFrom(
934         address from,
935         address to,
936         uint256 tokenId
937     ) public virtual override {
938         safeTransferFrom(from, to, tokenId, '');
939     }
940 
941     /**
942      * @dev See {IERC721-safeTransferFrom}.
943      */
944     function safeTransferFrom(
945         address from,
946         address to,
947         uint256 tokenId,
948         bytes memory _data
949     ) public virtual override {
950         _transfer(from, to, tokenId);
951         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
952             revert TransferToNonERC721ReceiverImplementer();
953         }
954     }
955 
956     /**
957      * @dev Returns whether `tokenId` exists.
958      *
959      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
960      *
961      * Tokens start existing when they are minted (`_mint`),
962      */
963     function _exists(uint256 tokenId) internal view returns (bool) {
964         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
965             !_ownerships[tokenId].burned;
966     }
967 
968     function _safeMint(address to, uint256 quantity) internal {
969         _safeMint(to, quantity, '');
970     }
971 
972     /**
973      * @dev Safely mints `quantity` tokens and transfers them to `to`.
974      *
975      * Requirements:
976      *
977      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
978      * - `quantity` must be greater than 0.
979      *
980      * Emits a {Transfer} event.
981      */
982     function _safeMint(
983         address to,
984         uint256 quantity,
985         bytes memory _data
986     ) internal {
987         _mint(to, quantity, _data, true);
988     }
989 
990     /**
991      * @dev Mints `quantity` tokens and transfers them to `to`.
992      *
993      * Requirements:
994      *
995      * - `to` cannot be the zero address.
996      * - `quantity` must be greater than 0.
997      *
998      * Emits a {Transfer} event.
999      */
1000     function _mint(
1001         address to,
1002         uint256 quantity,
1003         bytes memory _data,
1004         bool safe
1005     ) internal {
1006         uint256 startTokenId = _currentIndex;
1007         if (to == address(0)) revert MintToZeroAddress();
1008         if (quantity == 0) revert MintZeroQuantity();
1009 
1010         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1011 
1012         // Overflows are incredibly unrealistic.
1013         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1014         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1015         unchecked {
1016             _addressData[to].balance += uint64(quantity);
1017             _addressData[to].numberMinted += uint64(quantity);
1018 
1019             _ownerships[startTokenId].addr = to;
1020             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1021 
1022             uint256 updatedIndex = startTokenId;
1023             uint256 end = updatedIndex + quantity;
1024 
1025             if (safe && to.isContract()) {
1026                 do {
1027                     emit Transfer(address(0), to, updatedIndex);
1028                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1029                         revert TransferToNonERC721ReceiverImplementer();
1030                     }
1031                 } while (updatedIndex != end);
1032                 // Reentrancy protection
1033                 if (_currentIndex != startTokenId) revert();
1034             } else {
1035                 do {
1036                     emit Transfer(address(0), to, updatedIndex++);
1037                 } while (updatedIndex != end);
1038             }
1039             _currentIndex = updatedIndex;
1040         }
1041         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1042     }
1043 
1044     /**
1045      * @dev Transfers `tokenId` from `from` to `to`.
1046      *
1047      * Requirements:
1048      *
1049      * - `to` cannot be the zero address.
1050      * - `tokenId` token must be owned by `from`.
1051      *
1052      * Emits a {Transfer} event.
1053      */
1054     function _transfer(
1055         address from,
1056         address to,
1057         uint256 tokenId
1058     ) private {
1059         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1060 
1061         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1062 
1063         bool isApprovedOrOwner = (_msgSender() == from ||
1064             isApprovedForAll(from, _msgSender()) ||
1065             getApproved(tokenId) == _msgSender());
1066 
1067         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1068         if (to == address(0)) revert TransferToZeroAddress();
1069 
1070         _beforeTokenTransfers(from, to, tokenId, 1);
1071 
1072         // Clear approvals from the previous owner
1073         _approve(address(0), tokenId, from);
1074 
1075         // Underflow of the sender's balance is impossible because we check for
1076         // ownership above and the recipient's balance can't realistically overflow.
1077         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1078         unchecked {
1079             _addressData[from].balance -= 1;
1080             _addressData[to].balance += 1;
1081 
1082             TokenOwnership storage currSlot = _ownerships[tokenId];
1083             currSlot.addr = to;
1084             currSlot.startTimestamp = uint64(block.timestamp);
1085 
1086             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1087             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1088             uint256 nextTokenId = tokenId + 1;
1089             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1090             if (nextSlot.addr == address(0)) {
1091                 // This will suffice for checking _exists(nextTokenId),
1092                 // as a burned slot cannot contain the zero address.
1093                 if (nextTokenId != _currentIndex) {
1094                     nextSlot.addr = from;
1095                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1096                 }
1097             }
1098         }
1099 
1100         emit Transfer(from, to, tokenId);
1101         _afterTokenTransfers(from, to, tokenId, 1);
1102     }
1103 
1104     /**
1105      * @dev This is equivalent to _burn(tokenId, false)
1106      */
1107     function _burn(uint256 tokenId) internal virtual {
1108         _burn(tokenId, false);
1109     }
1110 
1111     /**
1112      * @dev Destroys `tokenId`.
1113      * The approval is cleared when the token is burned.
1114      *
1115      * Requirements:
1116      *
1117      * - `tokenId` must exist.
1118      *
1119      * Emits a {Transfer} event.
1120      */
1121     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1122         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1123 
1124         address from = prevOwnership.addr;
1125 
1126         if (approvalCheck) {
1127             bool isApprovedOrOwner = (_msgSender() == from ||
1128                 isApprovedForAll(from, _msgSender()) ||
1129                 getApproved(tokenId) == _msgSender());
1130 
1131             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1132         }
1133 
1134         _beforeTokenTransfers(from, address(0), tokenId, 1);
1135 
1136         // Clear approvals from the previous owner
1137         _approve(address(0), tokenId, from);
1138 
1139         // Underflow of the sender's balance is impossible because we check for
1140         // ownership above and the recipient's balance can't realistically overflow.
1141         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1142         unchecked {
1143             AddressData storage addressData = _addressData[from];
1144             addressData.balance -= 1;
1145             addressData.numberBurned += 1;
1146 
1147             // Keep track of who burned the token, and the timestamp of burning.
1148             TokenOwnership storage currSlot = _ownerships[tokenId];
1149             currSlot.addr = from;
1150             currSlot.startTimestamp = uint64(block.timestamp);
1151             currSlot.burned = true;
1152 
1153             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1154             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1155             uint256 nextTokenId = tokenId + 1;
1156             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1157             if (nextSlot.addr == address(0)) {
1158                 // This will suffice for checking _exists(nextTokenId),
1159                 // as a burned slot cannot contain the zero address.
1160                 if (nextTokenId != _currentIndex) {
1161                     nextSlot.addr = from;
1162                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1163                 }
1164             }
1165         }
1166 
1167         emit Transfer(from, address(0), tokenId);
1168         _afterTokenTransfers(from, address(0), tokenId, 1);
1169 
1170         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1171         unchecked {
1172             _burnCounter++;
1173         }
1174     }
1175 
1176     /**
1177      * @dev Approve `to` to operate on `tokenId`
1178      *
1179      * Emits a {Approval} event.
1180      */
1181     function _approve(
1182         address to,
1183         uint256 tokenId,
1184         address owner
1185     ) private {
1186         _tokenApprovals[tokenId] = to;
1187         emit Approval(owner, to, tokenId);
1188     }
1189 
1190     /**
1191      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1192      *
1193      * @param from address representing the previous owner of the given token ID
1194      * @param to target address that will receive the tokens
1195      * @param tokenId uint256 ID of the token to be transferred
1196      * @param _data bytes optional data to send along with the call
1197      * @return bool whether the call correctly returned the expected magic value
1198      */
1199     function _checkContractOnERC721Received(
1200         address from,
1201         address to,
1202         uint256 tokenId,
1203         bytes memory _data
1204     ) private returns (bool) {
1205         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1206             return retval == IERC721Receiver(to).onERC721Received.selector;
1207         } catch (bytes memory reason) {
1208             if (reason.length == 0) {
1209                 revert TransferToNonERC721ReceiverImplementer();
1210             } else {
1211                 assembly {
1212                     revert(add(32, reason), mload(reason))
1213                 }
1214             }
1215         }
1216     }
1217 
1218     /**
1219      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1220      * And also called before burning one token.
1221      *
1222      * startTokenId - the first token id to be transferred
1223      * quantity - the amount to be transferred
1224      *
1225      * Calling conditions:
1226      *
1227      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1228      * transferred to `to`.
1229      * - When `from` is zero, `tokenId` will be minted for `to`.
1230      * - When `to` is zero, `tokenId` will be burned by `from`.
1231      * - `from` and `to` are never both zero.
1232      */
1233     function _beforeTokenTransfers(
1234         address from,
1235         address to,
1236         uint256 startTokenId,
1237         uint256 quantity
1238     ) internal virtual {}
1239 
1240     /**
1241      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1242      * minting.
1243      * And also called after one token has been burned.
1244      *
1245      * startTokenId - the first token id to be transferred
1246      * quantity - the amount to be transferred
1247      *
1248      * Calling conditions:
1249      *
1250      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1251      * transferred to `to`.
1252      * - When `from` is zero, `tokenId` has been minted for `to`.
1253      * - When `to` is zero, `tokenId` has been burned by `from`.
1254      * - `from` and `to` are never both zero.
1255      */
1256     function _afterTokenTransfers(
1257         address from,
1258         address to,
1259         uint256 startTokenId,
1260         uint256 quantity
1261     ) internal virtual {}
1262 }
1263 
1264 abstract contract Ownable is Context {
1265     address private _owner;
1266 
1267     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1268 
1269     /**
1270      * @dev Initializes the contract setting the deployer as the initial owner.
1271      */
1272     constructor() {
1273         _transferOwnership(_msgSender());
1274     }
1275 
1276     /**
1277      * @dev Returns the address of the current owner.
1278      */
1279     function owner() public view virtual returns (address) {
1280         return _owner;
1281     }
1282 
1283     /**
1284      * @dev Throws if called by any account other than the owner.
1285      */
1286     modifier onlyOwner() {
1287         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1288         _;
1289     }
1290 
1291     /**
1292      * @dev Leaves the contract without owner. It will not be possible to call
1293      * `onlyOwner` functions anymore. Can only be called by the current owner.
1294      *
1295      * NOTE: Renouncing ownership will leave the contract without an owner,
1296      * thereby removing any functionality that is only available to the owner.
1297      */
1298     function renounceOwnership() public virtual onlyOwner {
1299         _transferOwnership(address(0));
1300     }
1301 
1302     /**
1303      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1304      * Can only be called by the current owner.
1305      */
1306     function transferOwnership(address newOwner) public virtual onlyOwner {
1307         require(newOwner != address(0), "Ownable: new owner is the zero address");
1308         _transferOwnership(newOwner);
1309     }
1310 
1311     /**
1312      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1313      * Internal function without access restriction.
1314      */
1315     function _transferOwnership(address newOwner) internal virtual {
1316         address oldOwner = _owner;
1317         _owner = newOwner;
1318         emit OwnershipTransferred(oldOwner, newOwner);
1319     }
1320 }
1321     pragma solidity ^0.8.7;
1322     
1323     contract DeadApeYachtClub is ERC721A, Ownable {
1324     using Strings for uint256;
1325 
1326 
1327   string private uriPrefix ;
1328   string private uriSuffix = ".json";
1329   string public hiddenURL;
1330 
1331   
1332   
1333 
1334   uint256 public cost = 0.005 ether;
1335   uint256 public whiteListCost = 0 ;
1336   
1337 
1338   uint16 public maxSupply = 6666;
1339   uint8 public maxMintAmountPerTx = 2;
1340   uint8 public maxMintAmountPerWallet = 12;
1341     uint8 public maxWLMintAmountPerWallet = 2;
1342                                                              
1343   bool public WLpaused = true;
1344   bool public paused = true;
1345   bool public reveal =false;
1346   mapping (address => uint8) public NFTPerWLAddress;
1347    mapping (address => uint8) public NFTPerPublicAddress;
1348   mapping (address => bool) public isWhitelisted;
1349  
1350   
1351   
1352  
1353   
1354 
1355   constructor() ERC721A("Dead Ape Yacht Club", "DAYC") {
1356   }
1357 
1358  
1359   
1360 
1361   
1362  
1363   function Mint(uint8 _mintAmount) external payable  {
1364      uint16 totalSupply = uint16(totalSupply());
1365      uint8 nft = NFTPerPublicAddress[msg.sender];
1366     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1367     require(_mintAmount + nft <= maxMintAmountPerWallet, "Exceeds max per Wallet.");
1368     require(_mintAmount  <= maxMintAmountPerTx, "Exceeds max per Wallet.");
1369 
1370     require(!paused, "The contract is paused!");
1371     
1372   
1373     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1374     
1375 
1376     
1377 
1378 
1379     _safeMint(msg.sender , _mintAmount);
1380 
1381     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1382      
1383      delete totalSupply;
1384      delete _mintAmount;
1385   }
1386   
1387   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1388      uint16 totalSupply = uint16(totalSupply());
1389     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1390      _safeMint(_receiver , _mintAmount);
1391      delete _mintAmount;
1392      delete _receiver;
1393      delete totalSupply;
1394   }
1395 
1396   function  Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1397      uint16 totalSupply = uint16(totalSupply());
1398      uint totalAmount =   _amountPerAddress * addresses.length;
1399     require(totalSupply + totalAmount <= maxSupply, "Exceees max supply.");
1400      for (uint256 i = 0; i < addresses.length; i++) {
1401             _safeMint(addresses[i], _amountPerAddress);
1402         }
1403 
1404      delete _amountPerAddress;
1405      delete totalSupply;
1406   }
1407 
1408  
1409 
1410   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1411       maxSupply = _maxSupply;
1412   }
1413 
1414 
1415 
1416    
1417   function tokenURI(uint256 _tokenId)
1418     public
1419     view
1420     virtual
1421     override
1422     returns (string memory)
1423   {
1424     require(
1425       _exists(_tokenId),
1426       "ERC721Metadata: URI query for nonexistent token"
1427     );
1428     
1429   
1430 if ( reveal == false)
1431 {
1432     return hiddenURL;
1433 }
1434     
1435 
1436     string memory currentBaseURI = _baseURI();
1437     return bytes(currentBaseURI).length > 0
1438         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1439         : "";
1440   }
1441  
1442 
1443 
1444     
1445   function addToPresaleWhitelist(address[] calldata entries) external onlyOwner {
1446         for(uint8 i = 0; i < entries.length; i++) {
1447             isWhitelisted[entries[i]] = true;
1448         }   
1449     }
1450 
1451     function removeFromPresaleWhitelist(address[] calldata entries) external onlyOwner {
1452         for(uint8 i = 0; i < entries.length; i++) {
1453              isWhitelisted[entries[i]] = false;
1454         }
1455     }
1456 
1457 function whitelistMint(uint8 _mintAmount) external payable {
1458         
1459     
1460         uint8 nft = NFTPerWLAddress[msg.sender];
1461         uint16 totalSupply = uint16(totalSupply());
1462        require(isWhitelisted[msg.sender],  "You are not whitelisted");
1463        require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1464 
1465        require (nft + _mintAmount <= maxWLMintAmountPerWallet, "Exceeds max  limit  per address");
1466         require (_mintAmount <= maxMintAmountPerTx, "Exceeds max  limit  per tx");
1467       
1468 
1469 
1470    
1471     require(msg.value >= whiteListCost * _mintAmount, "Insufficient funds!");
1472     
1473    
1474 
1475      _safeMint(msg.sender , _mintAmount);
1476       NFTPerWLAddress[msg.sender] =nft + _mintAmount;
1477      
1478       delete _mintAmount;
1479        delete nft;
1480     
1481     }
1482 
1483   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1484     uriPrefix = _uriPrefix;
1485   }
1486    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1487     hiddenURL = _uriPrefix;
1488   }
1489 
1490 
1491   function setPaused() external onlyOwner {
1492     paused = !paused;
1493     WLpaused = true;
1494   }
1495 
1496   function setCost(uint _cost) external onlyOwner{
1497       cost = _cost;
1498 
1499   }
1500 
1501  function setRevealed() external onlyOwner{
1502      reveal = !reveal;
1503  }
1504 
1505   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1506       maxMintAmountPerTx = _maxtx;
1507 
1508   }
1509 
1510   
1511   function setMaxMintAmountPerWallet(uint8 _maxtx) external onlyOwner{
1512       maxMintAmountPerWallet = _maxtx;
1513 
1514   }
1515      function setWLPaused() external onlyOwner {
1516     WLpaused = !WLpaused;
1517   }
1518   function setWhiteListCost(uint256 _cost) external onlyOwner {
1519     whiteListCost = _cost;
1520     delete _cost;
1521   }
1522 
1523 
1524 
1525  function setWhiteListMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1526     maxWLMintAmountPerWallet = _limit;
1527    delete _limit;
1528 
1529 }
1530 
1531  
1532 
1533   function withdraw() external onlyOwner {
1534   uint _balance = address(this).balance;
1535      payable(msg.sender).transfer(_balance ); 
1536        
1537   }
1538 
1539 
1540   function _baseURI() internal view  override returns (string memory) {
1541     return uriPrefix;
1542   }
1543 }