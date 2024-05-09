1 // File: https://github.com/umi-digital/umi-multi-staking/blob/main/contracts/ERC20Interface.sol
2 
3 pragma solidity ^0.8.3;
4 
5 interface ERC20Interface {
6     function transfer(address _to, uint256 _value) external returns (bool);
7     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
8     function balanceOf(address _account) external view returns (uint256);
9     function totalSupply() external view returns (uint256);
10     function allowance(address tokenOwner, address spender) external view returns (uint remaining);
11     function approve(address spender, uint tokens) external returns (bool success);
12 
13     event Transfer(address indexed from, address indexed to, uint tokens);
14     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
15 }
16 // File: @openzeppelin/contracts/utils/Strings.sol
17 
18 
19 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
20 
21 pragma solidity ^0.8.0;
22 
23 /**
24  * @dev String operations.
25  */
26 library Strings {
27     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
28 
29     /**
30      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
31      */
32     function toString(uint256 value) internal pure returns (string memory) {
33         // Inspired by OraclizeAPI's implementation - MIT licence
34         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
35 
36         if (value == 0) {
37             return "0";
38         }
39         uint256 temp = value;
40         uint256 digits;
41         while (temp != 0) {
42             digits++;
43             temp /= 10;
44         }
45         bytes memory buffer = new bytes(digits);
46         while (value != 0) {
47             digits -= 1;
48             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
49             value /= 10;
50         }
51         return string(buffer);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
56      */
57     function toHexString(uint256 value) internal pure returns (string memory) {
58         if (value == 0) {
59             return "0x00";
60         }
61         uint256 temp = value;
62         uint256 length = 0;
63         while (temp != 0) {
64             length++;
65             temp >>= 8;
66         }
67         return toHexString(value, length);
68     }
69 
70     /**
71      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
72      */
73     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
74         bytes memory buffer = new bytes(2 * length + 2);
75         buffer[0] = "0";
76         buffer[1] = "x";
77         for (uint256 i = 2 * length + 1; i > 1; --i) {
78             buffer[i] = _HEX_SYMBOLS[value & 0xf];
79             value >>= 4;
80         }
81         require(value == 0, "Strings: hex length insufficient");
82         return string(buffer);
83     }
84 }
85 
86 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
87 
88 
89 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @title ERC721 token receiver interface
95  * @dev Interface for any contract that wants to support safeTransfers
96  * from ERC721 asset contracts.
97  */
98 interface IERC721Receiver {
99     /**
100      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
101      * by `operator` from `from`, this function is called.
102      *
103      * It must return its Solidity selector to confirm the token transfer.
104      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
105      *
106      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
107      */
108     function onERC721Received(
109         address operator,
110         address from,
111         uint256 tokenId,
112         bytes calldata data
113     ) external returns (bytes4);
114 }
115 
116 // File: @openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol
117 
118 
119 // OpenZeppelin Contracts v4.4.1 (token/ERC721/utils/ERC721Holder.sol)
120 
121 pragma solidity ^0.8.0;
122 
123 
124 /**
125  * @dev Implementation of the {IERC721Receiver} interface.
126  *
127  * Accepts all token transfers.
128  * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
129  */
130 contract ERC721Holder is IERC721Receiver {
131     /**
132      * @dev See {IERC721Receiver-onERC721Received}.
133      *
134      * Always returns `IERC721Receiver.onERC721Received.selector`.
135      */
136     function onERC721Received(
137         address,
138         address,
139         uint256,
140         bytes memory
141     ) public virtual override returns (bytes4) {
142         return this.onERC721Received.selector;
143     }
144 }
145 
146 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
147 
148 
149 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
150 
151 pragma solidity ^0.8.0;
152 
153 /**
154  * @dev Interface of the ERC165 standard, as defined in the
155  * https://eips.ethereum.org/EIPS/eip-165[EIP].
156  *
157  * Implementers can declare support of contract interfaces, which can then be
158  * queried by others ({ERC165Checker}).
159  *
160  * For an implementation, see {ERC165}.
161  */
162 interface IERC165 {
163     /**
164      * @dev Returns true if this contract implements the interface defined by
165      * `interfaceId`. See the corresponding
166      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
167      * to learn more about how these ids are created.
168      *
169      * This function call must use less than 30 000 gas.
170      */
171     function supportsInterface(bytes4 interfaceId) external view returns (bool);
172 }
173 
174 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
175 
176 
177 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 
182 /**
183  * @dev Implementation of the {IERC165} interface.
184  *
185  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
186  * for the additional interface id that will be supported. For example:
187  *
188  * ```solidity
189  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
190  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
191  * }
192  * ```
193  *
194  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
195  */
196 abstract contract ERC165 is IERC165 {
197     /**
198      * @dev See {IERC165-supportsInterface}.
199      */
200     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
201         return interfaceId == type(IERC165).interfaceId;
202     }
203 }
204 
205 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
206 
207 
208 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
209 
210 pragma solidity ^0.8.0;
211 
212 
213 /**
214  * @dev Required interface of an ERC721 compliant contract.
215  */
216 interface IERC721 is IERC165 {
217     /**
218      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
219      */
220     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
221 
222     /**
223      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
224      */
225     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
226 
227     /**
228      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
229      */
230     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
231 
232     /**
233      * @dev Returns the number of tokens in ``owner``'s account.
234      */
235     function balanceOf(address owner) external view returns (uint256 balance);
236 
237     /**
238      * @dev Returns the owner of the `tokenId` token.
239      *
240      * Requirements:
241      *
242      * - `tokenId` must exist.
243      */
244     function ownerOf(uint256 tokenId) external view returns (address owner);
245 
246     /**
247      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
248      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
249      *
250      * Requirements:
251      *
252      * - `from` cannot be the zero address.
253      * - `to` cannot be the zero address.
254      * - `tokenId` token must exist and be owned by `from`.
255      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
256      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
257      *
258      * Emits a {Transfer} event.
259      */
260     function safeTransferFrom(
261         address from,
262         address to,
263         uint256 tokenId
264     ) external;
265 
266     /**
267      * @dev Transfers `tokenId` token from `from` to `to`.
268      *
269      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
270      *
271      * Requirements:
272      *
273      * - `from` cannot be the zero address.
274      * - `to` cannot be the zero address.
275      * - `tokenId` token must be owned by `from`.
276      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
277      *
278      * Emits a {Transfer} event.
279      */
280     function transferFrom(
281         address from,
282         address to,
283         uint256 tokenId
284     ) external;
285 
286     /**
287      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
288      * The approval is cleared when the token is transferred.
289      *
290      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
291      *
292      * Requirements:
293      *
294      * - The caller must own the token or be an approved operator.
295      * - `tokenId` must exist.
296      *
297      * Emits an {Approval} event.
298      */
299     function approve(address to, uint256 tokenId) external;
300 
301     /**
302      * @dev Returns the account approved for `tokenId` token.
303      *
304      * Requirements:
305      *
306      * - `tokenId` must exist.
307      */
308     function getApproved(uint256 tokenId) external view returns (address operator);
309 
310     /**
311      * @dev Approve or remove `operator` as an operator for the caller.
312      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
313      *
314      * Requirements:
315      *
316      * - The `operator` cannot be the caller.
317      *
318      * Emits an {ApprovalForAll} event.
319      */
320     function setApprovalForAll(address operator, bool _approved) external;
321 
322     /**
323      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
324      *
325      * See {setApprovalForAll}
326      */
327     function isApprovedForAll(address owner, address operator) external view returns (bool);
328 
329     /**
330      * @dev Safely transfers `tokenId` token from `from` to `to`.
331      *
332      * Requirements:
333      *
334      * - `from` cannot be the zero address.
335      * - `to` cannot be the zero address.
336      * - `tokenId` token must exist and be owned by `from`.
337      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
338      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
339      *
340      * Emits a {Transfer} event.
341      */
342     function safeTransferFrom(
343         address from,
344         address to,
345         uint256 tokenId,
346         bytes calldata data
347     ) external;
348 }
349 
350 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
351 
352 
353 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
354 
355 pragma solidity ^0.8.0;
356 
357 
358 /**
359  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
360  * @dev See https://eips.ethereum.org/EIPS/eip-721
361  */
362 interface IERC721Metadata is IERC721 {
363     /**
364      * @dev Returns the token collection name.
365      */
366     function name() external view returns (string memory);
367 
368     /**
369      * @dev Returns the token collection symbol.
370      */
371     function symbol() external view returns (string memory);
372 
373     /**
374      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
375      */
376     function tokenURI(uint256 tokenId) external view returns (string memory);
377 }
378 
379 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
380 
381 
382 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
383 
384 pragma solidity ^0.8.0;
385 
386 /**
387  * @dev Contract module that helps prevent reentrant calls to a function.
388  *
389  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
390  * available, which can be applied to functions to make sure there are no nested
391  * (reentrant) calls to them.
392  *
393  * Note that because there is a single `nonReentrant` guard, functions marked as
394  * `nonReentrant` may not call one another. This can be worked around by making
395  * those functions `private`, and then adding `external` `nonReentrant` entry
396  * points to them.
397  *
398  * TIP: If you would like to learn more about reentrancy and alternative ways
399  * to protect against it, check out our blog post
400  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
401  */
402 abstract contract ReentrancyGuard {
403     // Booleans are more expensive than uint256 or any type that takes up a full
404     // word because each write operation emits an extra SLOAD to first read the
405     // slot's contents, replace the bits taken up by the boolean, and then write
406     // back. This is the compiler's defense against contract upgrades and
407     // pointer aliasing, and it cannot be disabled.
408 
409     // The values being non-zero value makes deployment a bit more expensive,
410     // but in exchange the refund on every call to nonReentrant will be lower in
411     // amount. Since refunds are capped to a percentage of the total
412     // transaction's gas, it is best to keep them low in cases like this one, to
413     // increase the likelihood of the full refund coming into effect.
414     uint256 private constant _NOT_ENTERED = 1;
415     uint256 private constant _ENTERED = 2;
416 
417     uint256 private _status;
418 
419     constructor() {
420         _status = _NOT_ENTERED;
421     }
422 
423     /**
424      * @dev Prevents a contract from calling itself, directly or indirectly.
425      * Calling a `nonReentrant` function from another `nonReentrant`
426      * function is not supported. It is possible to prevent this from happening
427      * by making the `nonReentrant` function external, and making it call a
428      * `private` function that does the actual work.
429      */
430     modifier nonReentrant() {
431         // On the first call to nonReentrant, _notEntered will be true
432         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
433 
434         // Any calls to nonReentrant after this point will fail
435         _status = _ENTERED;
436 
437         _;
438 
439         // By storing the original value once again, a refund is triggered (see
440         // https://eips.ethereum.org/EIPS/eip-2200)
441         _status = _NOT_ENTERED;
442     }
443 }
444 
445 // File: @openzeppelin/contracts/utils/Address.sol
446 
447 
448 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
449 
450 pragma solidity ^0.8.1;
451 
452 /**
453  * @dev Collection of functions related to the address type
454  */
455 library Address {
456     /**
457      * @dev Returns true if `account` is a contract.
458      *
459      * [IMPORTANT]
460      * ====
461      * It is unsafe to assume that an address for which this function returns
462      * false is an externally-owned account (EOA) and not a contract.
463      *
464      * Among others, `isContract` will return false for the following
465      * types of addresses:
466      *
467      *  - an externally-owned account
468      *  - a contract in construction
469      *  - an address where a contract will be created
470      *  - an address where a contract lived, but was destroyed
471      * ====
472      *
473      * [IMPORTANT]
474      * ====
475      * You shouldn't rely on `isContract` to protect against flash loan attacks!
476      *
477      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
478      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
479      * constructor.
480      * ====
481      */
482     function isContract(address account) internal view returns (bool) {
483         // This method relies on extcodesize/address.code.length, which returns 0
484         // for contracts in construction, since the code is only stored at the end
485         // of the constructor execution.
486 
487         return account.code.length > 0;
488     }
489 
490     /**
491      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
492      * `recipient`, forwarding all available gas and reverting on errors.
493      *
494      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
495      * of certain opcodes, possibly making contracts go over the 2300 gas limit
496      * imposed by `transfer`, making them unable to receive funds via
497      * `transfer`. {sendValue} removes this limitation.
498      *
499      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
500      *
501      * IMPORTANT: because control is transferred to `recipient`, care must be
502      * taken to not create reentrancy vulnerabilities. Consider using
503      * {ReentrancyGuard} or the
504      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
505      */
506     function sendValue(address payable recipient, uint256 amount) internal {
507         require(address(this).balance >= amount, "Address: insufficient balance");
508 
509         (bool success, ) = recipient.call{value: amount}("");
510         require(success, "Address: unable to send value, recipient may have reverted");
511     }
512 
513     /**
514      * @dev Performs a Solidity function call using a low level `call`. A
515      * plain `call` is an unsafe replacement for a function call: use this
516      * function instead.
517      *
518      * If `target` reverts with a revert reason, it is bubbled up by this
519      * function (like regular Solidity function calls).
520      *
521      * Returns the raw returned data. To convert to the expected return value,
522      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
523      *
524      * Requirements:
525      *
526      * - `target` must be a contract.
527      * - calling `target` with `data` must not revert.
528      *
529      * _Available since v3.1._
530      */
531     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
532         return functionCall(target, data, "Address: low-level call failed");
533     }
534 
535     /**
536      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
537      * `errorMessage` as a fallback revert reason when `target` reverts.
538      *
539      * _Available since v3.1._
540      */
541     function functionCall(
542         address target,
543         bytes memory data,
544         string memory errorMessage
545     ) internal returns (bytes memory) {
546         return functionCallWithValue(target, data, 0, errorMessage);
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
551      * but also transferring `value` wei to `target`.
552      *
553      * Requirements:
554      *
555      * - the calling contract must have an ETH balance of at least `value`.
556      * - the called Solidity function must be `payable`.
557      *
558      * _Available since v3.1._
559      */
560     function functionCallWithValue(
561         address target,
562         bytes memory data,
563         uint256 value
564     ) internal returns (bytes memory) {
565         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
566     }
567 
568     /**
569      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
570      * with `errorMessage` as a fallback revert reason when `target` reverts.
571      *
572      * _Available since v3.1._
573      */
574     function functionCallWithValue(
575         address target,
576         bytes memory data,
577         uint256 value,
578         string memory errorMessage
579     ) internal returns (bytes memory) {
580         require(address(this).balance >= value, "Address: insufficient balance for call");
581         require(isContract(target), "Address: call to non-contract");
582 
583         (bool success, bytes memory returndata) = target.call{value: value}(data);
584         return verifyCallResult(success, returndata, errorMessage);
585     }
586 
587     /**
588      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
589      * but performing a static call.
590      *
591      * _Available since v3.3._
592      */
593     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
594         return functionStaticCall(target, data, "Address: low-level static call failed");
595     }
596 
597     /**
598      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
599      * but performing a static call.
600      *
601      * _Available since v3.3._
602      */
603     function functionStaticCall(
604         address target,
605         bytes memory data,
606         string memory errorMessage
607     ) internal view returns (bytes memory) {
608         require(isContract(target), "Address: static call to non-contract");
609 
610         (bool success, bytes memory returndata) = target.staticcall(data);
611         return verifyCallResult(success, returndata, errorMessage);
612     }
613 
614     /**
615      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
616      * but performing a delegate call.
617      *
618      * _Available since v3.4._
619      */
620     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
621         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
622     }
623 
624     /**
625      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
626      * but performing a delegate call.
627      *
628      * _Available since v3.4._
629      */
630     function functionDelegateCall(
631         address target,
632         bytes memory data,
633         string memory errorMessage
634     ) internal returns (bytes memory) {
635         require(isContract(target), "Address: delegate call to non-contract");
636 
637         (bool success, bytes memory returndata) = target.delegatecall(data);
638         return verifyCallResult(success, returndata, errorMessage);
639     }
640 
641     /**
642      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
643      * revert reason using the provided one.
644      *
645      * _Available since v4.3._
646      */
647     function verifyCallResult(
648         bool success,
649         bytes memory returndata,
650         string memory errorMessage
651     ) internal pure returns (bytes memory) {
652         if (success) {
653             return returndata;
654         } else {
655             // Look for revert reason and bubble it up if present
656             if (returndata.length > 0) {
657                 // The easiest way to bubble the revert reason is using memory via assembly
658 
659                 assembly {
660                     let returndata_size := mload(returndata)
661                     revert(add(32, returndata), returndata_size)
662                 }
663             } else {
664                 revert(errorMessage);
665             }
666         }
667     }
668 }
669 
670 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
671 
672 
673 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
674 
675 pragma solidity ^0.8.0;
676 
677 // CAUTION
678 // This version of SafeMath should only be used with Solidity 0.8 or later,
679 // because it relies on the compiler's built in overflow checks.
680 
681 /**
682  * @dev Wrappers over Solidity's arithmetic operations.
683  *
684  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
685  * now has built in overflow checking.
686  */
687 library SafeMath {
688     /**
689      * @dev Returns the addition of two unsigned integers, with an overflow flag.
690      *
691      * _Available since v3.4._
692      */
693     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
694         unchecked {
695             uint256 c = a + b;
696             if (c < a) return (false, 0);
697             return (true, c);
698         }
699     }
700 
701     /**
702      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
703      *
704      * _Available since v3.4._
705      */
706     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
707         unchecked {
708             if (b > a) return (false, 0);
709             return (true, a - b);
710         }
711     }
712 
713     /**
714      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
715      *
716      * _Available since v3.4._
717      */
718     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
719         unchecked {
720             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
721             // benefit is lost if 'b' is also tested.
722             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
723             if (a == 0) return (true, 0);
724             uint256 c = a * b;
725             if (c / a != b) return (false, 0);
726             return (true, c);
727         }
728     }
729 
730     /**
731      * @dev Returns the division of two unsigned integers, with a division by zero flag.
732      *
733      * _Available since v3.4._
734      */
735     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
736         unchecked {
737             if (b == 0) return (false, 0);
738             return (true, a / b);
739         }
740     }
741 
742     /**
743      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
744      *
745      * _Available since v3.4._
746      */
747     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
748         unchecked {
749             if (b == 0) return (false, 0);
750             return (true, a % b);
751         }
752     }
753 
754     /**
755      * @dev Returns the addition of two unsigned integers, reverting on
756      * overflow.
757      *
758      * Counterpart to Solidity's `+` operator.
759      *
760      * Requirements:
761      *
762      * - Addition cannot overflow.
763      */
764     function add(uint256 a, uint256 b) internal pure returns (uint256) {
765         return a + b;
766     }
767 
768     /**
769      * @dev Returns the subtraction of two unsigned integers, reverting on
770      * overflow (when the result is negative).
771      *
772      * Counterpart to Solidity's `-` operator.
773      *
774      * Requirements:
775      *
776      * - Subtraction cannot overflow.
777      */
778     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
779         return a - b;
780     }
781 
782     /**
783      * @dev Returns the multiplication of two unsigned integers, reverting on
784      * overflow.
785      *
786      * Counterpart to Solidity's `*` operator.
787      *
788      * Requirements:
789      *
790      * - Multiplication cannot overflow.
791      */
792     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
793         return a * b;
794     }
795 
796     /**
797      * @dev Returns the integer division of two unsigned integers, reverting on
798      * division by zero. The result is rounded towards zero.
799      *
800      * Counterpart to Solidity's `/` operator.
801      *
802      * Requirements:
803      *
804      * - The divisor cannot be zero.
805      */
806     function div(uint256 a, uint256 b) internal pure returns (uint256) {
807         return a / b;
808     }
809 
810     /**
811      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
812      * reverting when dividing by zero.
813      *
814      * Counterpart to Solidity's `%` operator. This function uses a `revert`
815      * opcode (which leaves remaining gas untouched) while Solidity uses an
816      * invalid opcode to revert (consuming all remaining gas).
817      *
818      * Requirements:
819      *
820      * - The divisor cannot be zero.
821      */
822     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
823         return a % b;
824     }
825 
826     /**
827      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
828      * overflow (when the result is negative).
829      *
830      * CAUTION: This function is deprecated because it requires allocating memory for the error
831      * message unnecessarily. For custom revert reasons use {trySub}.
832      *
833      * Counterpart to Solidity's `-` operator.
834      *
835      * Requirements:
836      *
837      * - Subtraction cannot overflow.
838      */
839     function sub(
840         uint256 a,
841         uint256 b,
842         string memory errorMessage
843     ) internal pure returns (uint256) {
844         unchecked {
845             require(b <= a, errorMessage);
846             return a - b;
847         }
848     }
849 
850     /**
851      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
852      * division by zero. The result is rounded towards zero.
853      *
854      * Counterpart to Solidity's `/` operator. Note: this function uses a
855      * `revert` opcode (which leaves remaining gas untouched) while Solidity
856      * uses an invalid opcode to revert (consuming all remaining gas).
857      *
858      * Requirements:
859      *
860      * - The divisor cannot be zero.
861      */
862     function div(
863         uint256 a,
864         uint256 b,
865         string memory errorMessage
866     ) internal pure returns (uint256) {
867         unchecked {
868             require(b > 0, errorMessage);
869             return a / b;
870         }
871     }
872 
873     /**
874      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
875      * reverting with custom message when dividing by zero.
876      *
877      * CAUTION: This function is deprecated because it requires allocating memory for the error
878      * message unnecessarily. For custom revert reasons use {tryMod}.
879      *
880      * Counterpart to Solidity's `%` operator. This function uses a `revert`
881      * opcode (which leaves remaining gas untouched) while Solidity uses an
882      * invalid opcode to revert (consuming all remaining gas).
883      *
884      * Requirements:
885      *
886      * - The divisor cannot be zero.
887      */
888     function mod(
889         uint256 a,
890         uint256 b,
891         string memory errorMessage
892     ) internal pure returns (uint256) {
893         unchecked {
894             require(b > 0, errorMessage);
895             return a % b;
896         }
897     }
898 }
899 
900 // File: @openzeppelin/contracts/utils/Context.sol
901 
902 
903 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
904 
905 pragma solidity ^0.8.0;
906 
907 /**
908  * @dev Provides information about the current execution context, including the
909  * sender of the transaction and its data. While these are generally available
910  * via msg.sender and msg.data, they should not be accessed in such a direct
911  * manner, since when dealing with meta-transactions the account sending and
912  * paying for execution may not be the actual sender (as far as an application
913  * is concerned).
914  *
915  * This contract is only required for intermediate, library-like contracts.
916  */
917 abstract contract Context {
918     function _msgSender() internal view virtual returns (address) {
919         return msg.sender;
920     }
921 
922     function _msgData() internal view virtual returns (bytes calldata) {
923         return msg.data;
924     }
925 }
926 
927 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
928 
929 
930 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
931 
932 pragma solidity ^0.8.0;
933 
934 
935 
936 
937 
938 
939 
940 
941 /**
942  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
943  * the Metadata extension, but not including the Enumerable extension, which is available separately as
944  * {ERC721Enumerable}.
945  */
946 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
947     using Address for address;
948     using Strings for uint256;
949 
950     // Token name
951     string private _name;
952 
953     // Token symbol
954     string private _symbol;
955 
956     // Mapping from token ID to owner address
957     mapping(uint256 => address) private _owners;
958 
959     // Mapping owner address to token count
960     mapping(address => uint256) private _balances;
961 
962     // Mapping from token ID to approved address
963     mapping(uint256 => address) private _tokenApprovals;
964 
965     // Mapping from owner to operator approvals
966     mapping(address => mapping(address => bool)) private _operatorApprovals;
967 
968     /**
969      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
970      */
971     constructor(string memory name_, string memory symbol_) {
972         _name = name_;
973         _symbol = symbol_;
974     }
975 
976     /**
977      * @dev See {IERC165-supportsInterface}.
978      */
979     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
980         return
981             interfaceId == type(IERC721).interfaceId ||
982             interfaceId == type(IERC721Metadata).interfaceId ||
983             super.supportsInterface(interfaceId);
984     }
985 
986     /**
987      * @dev See {IERC721-balanceOf}.
988      */
989     function balanceOf(address owner) public view virtual override returns (uint256) {
990         require(owner != address(0), "ERC721: balance query for the zero address");
991         return _balances[owner];
992     }
993 
994     /**
995      * @dev See {IERC721-ownerOf}.
996      */
997     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
998         address owner = _owners[tokenId];
999         require(owner != address(0), "ERC721: owner query for nonexistent token");
1000         return owner;
1001     }
1002 
1003     /**
1004      * @dev See {IERC721Metadata-name}.
1005      */
1006     function name() public view virtual override returns (string memory) {
1007         return _name;
1008     }
1009 
1010     /**
1011      * @dev See {IERC721Metadata-symbol}.
1012      */
1013     function symbol() public view virtual override returns (string memory) {
1014         return _symbol;
1015     }
1016 
1017     /**
1018      * @dev See {IERC721Metadata-tokenURI}.
1019      */
1020     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1021         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1022 
1023         string memory baseURI = _baseURI();
1024         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1025     }
1026 
1027     /**
1028      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1029      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1030      * by default, can be overriden in child contracts.
1031      */
1032     function _baseURI() internal view virtual returns (string memory) {
1033         return "";
1034     }
1035 
1036     /**
1037      * @dev See {IERC721-approve}.
1038      */
1039     function approve(address to, uint256 tokenId) public virtual override {
1040         address owner = ERC721.ownerOf(tokenId);
1041         require(to != owner, "ERC721: approval to current owner");
1042 
1043         require(
1044             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1045             "ERC721: approve caller is not owner nor approved for all"
1046         );
1047 
1048         _approve(to, tokenId);
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-getApproved}.
1053      */
1054     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1055         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1056 
1057         return _tokenApprovals[tokenId];
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-setApprovalForAll}.
1062      */
1063     function setApprovalForAll(address operator, bool approved) public virtual override {
1064         _setApprovalForAll(_msgSender(), operator, approved);
1065     }
1066 
1067     /**
1068      * @dev See {IERC721-isApprovedForAll}.
1069      */
1070     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1071         return _operatorApprovals[owner][operator];
1072     }
1073 
1074     /**
1075      * @dev See {IERC721-transferFrom}.
1076      */
1077     function transferFrom(
1078         address from,
1079         address to,
1080         uint256 tokenId
1081     ) public virtual override {
1082         //solhint-disable-next-line max-line-length
1083         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1084 
1085         _transfer(from, to, tokenId);
1086     }
1087 
1088     /**
1089      * @dev See {IERC721-safeTransferFrom}.
1090      */
1091     function safeTransferFrom(
1092         address from,
1093         address to,
1094         uint256 tokenId
1095     ) public virtual override {
1096         safeTransferFrom(from, to, tokenId, "");
1097     }
1098 
1099     /**
1100      * @dev See {IERC721-safeTransferFrom}.
1101      */
1102     function safeTransferFrom(
1103         address from,
1104         address to,
1105         uint256 tokenId,
1106         bytes memory _data
1107     ) public virtual override {
1108         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1109         _safeTransfer(from, to, tokenId, _data);
1110     }
1111 
1112     /**
1113      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1114      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1115      *
1116      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1117      *
1118      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1119      * implement alternative mechanisms to perform token transfer, such as signature-based.
1120      *
1121      * Requirements:
1122      *
1123      * - `from` cannot be the zero address.
1124      * - `to` cannot be the zero address.
1125      * - `tokenId` token must exist and be owned by `from`.
1126      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1127      *
1128      * Emits a {Transfer} event.
1129      */
1130     function _safeTransfer(
1131         address from,
1132         address to,
1133         uint256 tokenId,
1134         bytes memory _data
1135     ) internal virtual {
1136         _transfer(from, to, tokenId);
1137         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1138     }
1139 
1140     /**
1141      * @dev Returns whether `tokenId` exists.
1142      *
1143      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1144      *
1145      * Tokens start existing when they are minted (`_mint`),
1146      * and stop existing when they are burned (`_burn`).
1147      */
1148     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1149         return _owners[tokenId] != address(0);
1150     }
1151 
1152     /**
1153      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1154      *
1155      * Requirements:
1156      *
1157      * - `tokenId` must exist.
1158      */
1159     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1160         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1161         address owner = ERC721.ownerOf(tokenId);
1162         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1163     }
1164 
1165     /**
1166      * @dev Safely mints `tokenId` and transfers it to `to`.
1167      *
1168      * Requirements:
1169      *
1170      * - `tokenId` must not exist.
1171      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1172      *
1173      * Emits a {Transfer} event.
1174      */
1175     function _safeMint(address to, uint256 tokenId) internal virtual {
1176         _safeMint(to, tokenId, "");
1177     }
1178 
1179     /**
1180      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1181      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1182      */
1183     function _safeMint(
1184         address to,
1185         uint256 tokenId,
1186         bytes memory _data
1187     ) internal virtual {
1188         _mint(to, tokenId);
1189         require(
1190             _checkOnERC721Received(address(0), to, tokenId, _data),
1191             "ERC721: transfer to non ERC721Receiver implementer"
1192         );
1193     }
1194 
1195     /**
1196      * @dev Mints `tokenId` and transfers it to `to`.
1197      *
1198      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1199      *
1200      * Requirements:
1201      *
1202      * - `tokenId` must not exist.
1203      * - `to` cannot be the zero address.
1204      *
1205      * Emits a {Transfer} event.
1206      */
1207     function _mint(address to, uint256 tokenId) internal virtual {
1208         require(to != address(0), "ERC721: mint to the zero address");
1209         require(!_exists(tokenId), "ERC721: token already minted");
1210 
1211         _beforeTokenTransfer(address(0), to, tokenId);
1212 
1213         _balances[to] += 1;
1214         _owners[tokenId] = to;
1215 
1216         emit Transfer(address(0), to, tokenId);
1217 
1218         _afterTokenTransfer(address(0), to, tokenId);
1219     }
1220 
1221     /**
1222      * @dev Destroys `tokenId`.
1223      * The approval is cleared when the token is burned.
1224      *
1225      * Requirements:
1226      *
1227      * - `tokenId` must exist.
1228      *
1229      * Emits a {Transfer} event.
1230      */
1231     function _burn(uint256 tokenId) internal virtual {
1232         address owner = ERC721.ownerOf(tokenId);
1233 
1234         _beforeTokenTransfer(owner, address(0), tokenId);
1235 
1236         // Clear approvals
1237         _approve(address(0), tokenId);
1238 
1239         _balances[owner] -= 1;
1240         delete _owners[tokenId];
1241 
1242         emit Transfer(owner, address(0), tokenId);
1243 
1244         _afterTokenTransfer(owner, address(0), tokenId);
1245     }
1246 
1247     /**
1248      * @dev Transfers `tokenId` from `from` to `to`.
1249      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1250      *
1251      * Requirements:
1252      *
1253      * - `to` cannot be the zero address.
1254      * - `tokenId` token must be owned by `from`.
1255      *
1256      * Emits a {Transfer} event.
1257      */
1258     function _transfer(
1259         address from,
1260         address to,
1261         uint256 tokenId
1262     ) internal virtual {
1263         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1264         require(to != address(0), "ERC721: transfer to the zero address");
1265 
1266         _beforeTokenTransfer(from, to, tokenId);
1267 
1268         // Clear approvals from the previous owner
1269         _approve(address(0), tokenId);
1270 
1271         _balances[from] -= 1;
1272         _balances[to] += 1;
1273         _owners[tokenId] = to;
1274 
1275         emit Transfer(from, to, tokenId);
1276 
1277         _afterTokenTransfer(from, to, tokenId);
1278     }
1279 
1280     /**
1281      * @dev Approve `to` to operate on `tokenId`
1282      *
1283      * Emits a {Approval} event.
1284      */
1285     function _approve(address to, uint256 tokenId) internal virtual {
1286         _tokenApprovals[tokenId] = to;
1287         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1288     }
1289 
1290     /**
1291      * @dev Approve `operator` to operate on all of `owner` tokens
1292      *
1293      * Emits a {ApprovalForAll} event.
1294      */
1295     function _setApprovalForAll(
1296         address owner,
1297         address operator,
1298         bool approved
1299     ) internal virtual {
1300         require(owner != operator, "ERC721: approve to caller");
1301         _operatorApprovals[owner][operator] = approved;
1302         emit ApprovalForAll(owner, operator, approved);
1303     }
1304 
1305     /**
1306      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1307      * The call is not executed if the target address is not a contract.
1308      *
1309      * @param from address representing the previous owner of the given token ID
1310      * @param to target address that will receive the tokens
1311      * @param tokenId uint256 ID of the token to be transferred
1312      * @param _data bytes optional data to send along with the call
1313      * @return bool whether the call correctly returned the expected magic value
1314      */
1315     function _checkOnERC721Received(
1316         address from,
1317         address to,
1318         uint256 tokenId,
1319         bytes memory _data
1320     ) private returns (bool) {
1321         if (to.isContract()) {
1322             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1323                 return retval == IERC721Receiver.onERC721Received.selector;
1324             } catch (bytes memory reason) {
1325                 if (reason.length == 0) {
1326                     revert("ERC721: transfer to non ERC721Receiver implementer");
1327                 } else {
1328                     assembly {
1329                         revert(add(32, reason), mload(reason))
1330                     }
1331                 }
1332             }
1333         } else {
1334             return true;
1335         }
1336     }
1337 
1338     /**
1339      * @dev Hook that is called before any token transfer. This includes minting
1340      * and burning.
1341      *
1342      * Calling conditions:
1343      *
1344      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1345      * transferred to `to`.
1346      * - When `from` is zero, `tokenId` will be minted for `to`.
1347      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1348      * - `from` and `to` are never both zero.
1349      *
1350      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1351      */
1352     function _beforeTokenTransfer(
1353         address from,
1354         address to,
1355         uint256 tokenId
1356     ) internal virtual {}
1357 
1358     /**
1359      * @dev Hook that is called after any transfer of tokens. This includes
1360      * minting and burning.
1361      *
1362      * Calling conditions:
1363      *
1364      * - when `from` and `to` are both non-zero.
1365      * - `from` and `to` are never both zero.
1366      *
1367      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1368      */
1369     function _afterTokenTransfer(
1370         address from,
1371         address to,
1372         uint256 tokenId
1373     ) internal virtual {}
1374 }
1375 
1376 // File: @openzeppelin/contracts/security/Pausable.sol
1377 
1378 
1379 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1380 
1381 pragma solidity ^0.8.0;
1382 
1383 
1384 /**
1385  * @dev Contract module which allows children to implement an emergency stop
1386  * mechanism that can be triggered by an authorized account.
1387  *
1388  * This module is used through inheritance. It will make available the
1389  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1390  * the functions of your contract. Note that they will not be pausable by
1391  * simply including this module, only once the modifiers are put in place.
1392  */
1393 abstract contract Pausable is Context {
1394     /**
1395      * @dev Emitted when the pause is triggered by `account`.
1396      */
1397     event Paused(address account);
1398 
1399     /**
1400      * @dev Emitted when the pause is lifted by `account`.
1401      */
1402     event Unpaused(address account);
1403 
1404     bool private _paused;
1405 
1406     /**
1407      * @dev Initializes the contract in unpaused state.
1408      */
1409     constructor() {
1410         _paused = false;
1411     }
1412 
1413     /**
1414      * @dev Returns true if the contract is paused, and false otherwise.
1415      */
1416     function paused() public view virtual returns (bool) {
1417         return _paused;
1418     }
1419 
1420     /**
1421      * @dev Modifier to make a function callable only when the contract is not paused.
1422      *
1423      * Requirements:
1424      *
1425      * - The contract must not be paused.
1426      */
1427     modifier whenNotPaused() {
1428         require(!paused(), "Pausable: paused");
1429         _;
1430     }
1431 
1432     /**
1433      * @dev Modifier to make a function callable only when the contract is paused.
1434      *
1435      * Requirements:
1436      *
1437      * - The contract must be paused.
1438      */
1439     modifier whenPaused() {
1440         require(paused(), "Pausable: not paused");
1441         _;
1442     }
1443 
1444     /**
1445      * @dev Triggers stopped state.
1446      *
1447      * Requirements:
1448      *
1449      * - The contract must not be paused.
1450      */
1451     function _pause() internal virtual whenNotPaused {
1452         _paused = true;
1453         emit Paused(_msgSender());
1454     }
1455 
1456     /**
1457      * @dev Returns to normal state.
1458      *
1459      * Requirements:
1460      *
1461      * - The contract must be paused.
1462      */
1463     function _unpause() internal virtual whenPaused {
1464         _paused = false;
1465         emit Unpaused(_msgSender());
1466     }
1467 }
1468 
1469 // File: @openzeppelin/contracts/access/Ownable.sol
1470 
1471 
1472 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1473 
1474 pragma solidity ^0.8.0;
1475 
1476 
1477 /**
1478  * @dev Contract module which provides a basic access control mechanism, where
1479  * there is an account (an owner) that can be granted exclusive access to
1480  * specific functions.
1481  *
1482  * By default, the owner account will be the one that deploys the contract. This
1483  * can later be changed with {transferOwnership}.
1484  *
1485  * This module is used through inheritance. It will make available the modifier
1486  * `onlyOwner`, which can be applied to your functions to restrict their use to
1487  * the owner.
1488  */
1489 abstract contract Ownable is Context {
1490     address private _owner;
1491 
1492     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1493 
1494     /**
1495      * @dev Initializes the contract setting the deployer as the initial owner.
1496      */
1497     constructor() {
1498         _transferOwnership(_msgSender());
1499     }
1500 
1501     /**
1502      * @dev Returns the address of the current owner.
1503      */
1504     function owner() public view virtual returns (address) {
1505         return _owner;
1506     }
1507 
1508     /**
1509      * @dev Throws if called by any account other than the owner.
1510      */
1511     modifier onlyOwner() {
1512         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1513         _;
1514     }
1515 
1516     /**
1517      * @dev Leaves the contract without owner. It will not be possible to call
1518      * `onlyOwner` functions anymore. Can only be called by the current owner.
1519      *
1520      * NOTE: Renouncing ownership will leave the contract without an owner,
1521      * thereby removing any functionality that is only available to the owner.
1522      */
1523     function renounceOwnership() public virtual onlyOwner {
1524         _transferOwnership(address(0));
1525     }
1526 
1527     /**
1528      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1529      * Can only be called by the current owner.
1530      */
1531     function transferOwnership(address newOwner) public virtual onlyOwner {
1532         require(newOwner != address(0), "Ownable: new owner is the zero address");
1533         _transferOwnership(newOwner);
1534     }
1535 
1536     /**
1537      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1538      * Internal function without access restriction.
1539      */
1540     function _transferOwnership(address newOwner) internal virtual {
1541         address oldOwner = _owner;
1542         _owner = newOwner;
1543         emit OwnershipTransferred(oldOwner, newOwner);
1544     }
1545 }
1546 
1547 // File: staking1.sol
1548 
1549 //SPDX-License-Identifier: Unlicense
1550 /*
1551 *Edited by LAx
1552 *erc721 staking ,for different periods of staking
1553 *differents rewards per token_id number
1554 *for each period different rewards will be accumulated
1555 *claiming rewards by token_id number
1556 *
1557 */
1558 
1559 
1560 pragma solidity ^0.8.3;
1561 
1562 
1563 
1564 
1565 
1566 
1567 
1568 
1569 
1570 
1571 /**
1572  * nft staking farm
1573  */
1574 contract NftStakingFarm is
1575     Context,
1576     Ownable,
1577     ReentrancyGuard,
1578     Pausable,
1579     ERC721Holder
1580 {
1581     using Address for address;
1582     using SafeMath for uint256;
1583   //  using Calculator for uint256;
1584 
1585     /**
1586      * Emitted when a user store farming rewards(ERC20 token).
1587      * @param sender User address.
1588      * @param amount Current store amount.
1589      * @param timestamp The time when store farming rewards.
1590      */
1591     event ContractFunded(
1592         address indexed sender,
1593         uint256 amount,
1594         uint256 timestamp
1595     );
1596 
1597         /**
1598      * Emitted when a user stakes tokens(ERC20 token).
1599      * @param sender User address.
1600      * @param balance Current user balance.
1601      * @param timestamp The time when stake tokens.
1602      */
1603     event Staked(address indexed sender, uint256 balance, uint256 timestamp);
1604 
1605     /**
1606      * Emitted when a new nft reward is set.
1607      * @param tokenId A new reward value.
1608      */
1609 
1610 
1611     event NftApySet(uint256 tokenId, uint8 reward, uint256 time );
1612 
1613     /**
1614      * Emitted when a user stakes nft token.
1615      * @param sender User address.
1616      * @param nftId The nft id.
1617      * @param timestamp The time when stake nft.
1618      */
1619     event NftStaked(
1620         address indexed sender,
1621         uint256 nftId,
1622         uint256 timestamp
1623     );
1624 
1625     /**
1626      * Emitted when a user unstake nft token.
1627      * @param sender User address.
1628      * @param nftId The nft id.
1629      * @param timestamp The time when unstake nft.
1630      */
1631     event NftUnstaked(
1632         address indexed sender,
1633         uint256 nftId,
1634         uint256 timestamp
1635     );
1636 
1637      /**
1638      * @dev Emitted when a user withdraw interest only.
1639      * @param sender User address.
1640      * @param interest The amount of interest.
1641      * @param claimTimestamp claim timestamp.
1642      */
1643     event Claimed(
1644         address indexed sender,
1645         uint256 interest,
1646         uint256 claimTimestamp
1647     );
1648 
1649     // input stake token
1650     ERC20Interface immutable public rewardToken;
1651     // nft token contract
1652     IERC721 immutable public nftContract;
1653 
1654     // ERC20 about
1655       // // The stake balances of users, to send founds later on
1656      mapping(address => uint256) private balances;
1657      // // The farming rewards of users(address => total amount)
1658    //  mapping(address => uint256) private funding;
1659 
1660     // // The total farming rewards for users
1661      uint256 private totalFunding;
1662 
1663     // ERC721 about
1664 
1665     // Store each nft apy(ntfId->apy)
1666     uint256 private nftApys;
1667     // token users reveived (user address->amount))
1668    mapping(address => uint256) public tokenReceived;
1669 
1670     // Store user's nft ids(user address -> NftSet)
1671     mapping(address => NftSet) userNftIds;
1672     // The total nft staked amount
1673     uint256 public totalNftStaked;
1674     // To store user's nft ids, it is more convenient to know if nft id of user exists
1675     struct NftSet {
1676         // user's nft id array
1677         uint256[] ids;        //
1678         uint256[] nftTimes;   //time startStaked
1679         uint256[] nftPeriodStaking;  //nft period of staking
1680         // nft id -> bool, if nft id exist
1681         mapping(uint256 => bool) isIn;
1682     }
1683 
1684     // other constants
1685     
1686        // reward by id - royal or cub
1687     mapping(uint256 => uint8) public nftdailyrewards; 
1688 
1689 //apy for different staking period, 400 is 4%
1690 mapping(uint256=>uint256) public APYS ;
1691 //periods in second 5min=300 sec
1692 mapping(uint256=>uint256) public periods ;
1693 
1694     constructor(address _tokenAddress, address _nftContract) {
1695         require(
1696             _tokenAddress.isContract() && _nftContract.isContract(),
1697             "must be contract address"
1698         );
1699         rewardToken = ERC20Interface(_tokenAddress);
1700         nftContract = IERC721(_nftContract);
1701         initRewards();
1702 
1703     }
1704 
1705     /**
1706      * Store farming rewards to UmiStakingFarm contract, in order to pay the user interest later.
1707      *
1708      * Note: _amount should be more than 0
1709      * @param _amount The amount to funding contract.
1710      */
1711     function fundingContract(uint256 _amount) external nonReentrant onlyOwner {
1712         require(_amount > 0, "fundingContract _amount should be more than 0");
1713         uint256 allowance = rewardToken.allowance(msg.sender, address(this));        
1714         require(allowance >= _amount, "Check the token allowance");
1715 
1716       //  funding[msg.sender] += _amount;
1717         // increase total funding
1718         totalFunding=totalFunding.add(_amount);
1719         require(
1720             rewardToken.transferFrom(msg.sender, address(this), _amount),
1721             "fundingContract transferFrom failed"
1722         );
1723         // send event
1724         emit ContractFunded(msg.sender, _amount, _now());
1725     }
1726 
1727          /**
1728      * Set apy of nft.
1729      *
1730      * Note: set rewards for each nft like for the royal
1731      */
1732     function setNftReward(uint256 id, uint8 reward) public onlyOwner {
1733         require(id > 0 && reward > 0, "nft and apy must > 0");
1734         nftdailyrewards[id] = reward;
1735         emit NftApySet(id, reward , _now() );
1736     }
1737 
1738        function setAPYS(uint _ApyId, uint256 _newValue) public onlyOwner{
1739         APYS[_ApyId]= _newValue ;
1740     }
1741 
1742        function setPeriod(uint _PeriodId, uint256 _newValue) public onlyOwner{
1743         periods[_PeriodId]= _newValue ;
1744     }
1745 
1746 
1747     /**
1748      * stake nft token to this contract.
1749      * Note: It calls another internal "_stakeNft" method. See its description.
1750      */
1751     function stakeNft(uint256 id, uint256 periodStaking
1752     ) external whenNotPaused nonReentrant {
1753        _stakeNft(msg.sender, address(this), id, periodStaking);
1754     }
1755 	
1756 
1757 	/**
1758      * Transfers `_value` tokens of token type `_id` from `_from` to `_to`.
1759      *
1760      * Note: when nft staked, apy will changed, should recalculate balance.
1761      * update nft balance, nft id, totalNftStaked.
1762      *
1763      * @param _from The address of the sender.
1764      * @param _to The address of the receiver.
1765      * @param _id The nft id.
1766      */
1767     function _stakeNft(
1768         address _from,
1769         address _to,
1770         uint256 _id,
1771         uint256 _periodStaking
1772     ) internal {
1773         //4 period staking
1774           require( _periodStaking  > 0  && _periodStaking <= 4, "Not right staking period");
1775         // modify user's nft id array
1776         setUserNftIds(_from, _id, _now(),_periodStaking  );
1777         totalNftStaked = totalNftStaked.add(1);
1778         
1779         // transfer nft token to this contract
1780         nftContract.safeTransferFrom(_from, _to, _id);
1781         // send event
1782         emit NftStaked(_from, _id,  _now());
1783     }
1784 
1785   
1786     /**
1787      * Unstake nft token from this contract.
1788      *
1789      * Note: It calls another internal "_unstakeNft" method. See its description.
1790      *
1791      * @param id The nft id.
1792      */
1793     function unstakeNft(
1794         uint256 id
1795     ) external whenNotPaused nonReentrant {
1796         _unstakeNft(id);
1797     }
1798 
1799     /**
1800      * Unstake nft token with sufficient balance.
1801      *
1802      * Note: when nft unstaked, apy will changed, should recalculate balance.
1803      * update nft balance, nft id and totalNftStaked.
1804      *
1805      * @param _id The nft id.
1806      */
1807     function _unstakeNft(
1808         uint256 _id
1809     ) internal {
1810         // recalculate balance of umi token
1811         recalculateBalance(msg.sender, _id);
1812 
1813      //   uint256 nftBalance = nftBalancesStacked[msg.sender];
1814         require(
1815              getUserNftIdsLength(msg.sender) > 0,
1816             "insufficient balance for unstake"
1817         );
1818         // reduce total nft amount
1819         totalNftStaked = totalNftStaked.sub(1);
1820   
1821             // remove nft id from array
1822         removeUserNftId(_id); 
1823 
1824         // transfer nft token from this contract
1825         nftContract.safeTransferFrom(
1826             address(this),
1827             msg.sender,
1828             _id
1829         );
1830         // //withdraw reward too
1831         require(
1832             rewardToken.transfer(msg.sender, balances[msg.sender]),
1833             "claim: transfer failed"
1834         );   
1835         tokenReceived[msg.sender] = tokenReceived[msg.sender].add(balances[msg.sender]);
1836         // send event
1837         emit NftUnstaked(msg.sender, _id, _now());
1838     }
1839 
1840 
1841     /**
1842     * Withdraws the interest only of user, and updates the stake date, balance and etc..
1843     */
1844     function claimRewardById(uint256 _id) external whenNotPaused nonReentrant {
1845        require( getUserNftIdsLength(msg.sender) >= 0 , "No Nts Stocked");
1846         require(totalFunding>0 , "No enough tokens");     
1847 
1848         // calculate total balance with interest
1849         recalculateBalance(msg.sender, _id);       
1850         //remove the beginning reward
1851         uint256 balance = balances[msg.sender];
1852         require(balance > 0, "balance should more than 0");
1853         uint256 claimTimestamp = _now();
1854         // transfer interest to user
1855         require(
1856             rewardToken.transfer(msg.sender, balance),
1857             "claim: transfer failed"
1858         );
1859         //amount of token recieved
1860          tokenReceived[msg.sender] = tokenReceived[msg.sender].add(balances[msg.sender]);
1861         balances[msg.sender]=0;
1862 
1863         // send claim event
1864         emit Claimed(msg.sender, balance, claimTimestamp);
1865     }
1866 
1867     /**
1868      * Recalculate user's balance.
1869      *
1870      * Note: when should recalculate
1871      * case 1: unstake nft
1872      * case 2: claim reward
1873      */
1874     function recalculateBalance(address _from, uint256 _id) internal {
1875 
1876         // calculate total balance with interest
1877         (uint256 totalWithInterest, uint256 timePassed) =
1878             calculateRewardsAndTimePassed(_from, _id);
1879         require(
1880             timePassed >= 0,
1881             "NFT and reward unlocked after lock time "
1882         );
1883         balances[_from] = balances[_from].add(totalWithInterest);
1884     }
1885 
1886   
1887 /*
1888 *  periodtype =1  -  45days lock 
1889 *  periodtype =2  -  30days
1890 *  periodtype =3  -15days
1891 *  periodtype =4  - 7days
1892 */
1893 
1894 //check if he can withdraw a token he didn't inserted
1895 
1896         function calculateRewardsAndTimePassed(address _user, uint256 _id)
1897         internal
1898         returns (uint256, uint256)
1899     {
1900    
1901         NftSet storage nftSet = userNftIds[_user];
1902         uint256[] storage ids = nftSet.ids;
1903         uint256[] storage stakingStartTime = nftSet.nftTimes;
1904         uint256[] storage stakingPeriod = nftSet.nftPeriodStaking;
1905 
1906          require(isNftIdExist(_user,_id),"nft is not staked");
1907          uint256 stakeDate ;
1908          uint256 periodtype;
1909 
1910         // find nftId index
1911         for (uint256 i = 0; i < ids.length; i++) {
1912             if (ids[i] == _id) {
1913               stakeDate  = stakingStartTime[i] ;
1914               periodtype  = stakingPeriod[i] ;     
1915               //reset time for getting reward
1916               stakingStartTime[i] = _now();
1917             }
1918         }
1919 
1920         //period of staking     
1921         uint256 period = periods[periodtype] ;
1922         uint256 timePassed = _now().sub(stakeDate);     
1923          if (timePassed < period) {
1924             // if timePassed less than one day, rewards will be 0
1925             return (0, timePassed);
1926         }
1927         //check if royal or normal cub
1928         uint reward = nftdailyrewards[_id]>0 ?  nftdailyrewards[_id] : 10 ;
1929         reward = reward*10**18 ;
1930         uint256 _days = timePassed.div(period);
1931         uint256 totalWithInterest = _days.mul(APYS[periodtype]).mul(reward).div(100);
1932 
1933         return (totalWithInterest, timePassed);    
1934     }
1935 
1936 
1937     /**
1938      * Get umi token balance by address.
1939      * @param addr The address of the account that needs to check the balance.
1940      * @return Return balance of umi token.
1941      */
1942     function getTokenBalance(address addr) public view returns (uint256) {
1943         return rewardToken.balanceOf(addr);
1944     }
1945 
1946     /**
1947      * Get umi token balance for contract.
1948      * @return Return balance of umi token.
1949      */
1950     function getStakingBalance() public view returns (uint256) {
1951         return rewardToken.balanceOf(address(this));
1952     }
1953 
1954 
1955     /**
1956      * Get nft balance by user address and nft id.
1957      *
1958      * @param user The address of user.
1959      */
1960     function getNftBalance(address user)
1961         public
1962         view
1963         returns (uint256)
1964     {
1965         return nftContract.balanceOf(user);
1966     }
1967 
1968     /**
1969      * Get user's nft ids array.
1970      * @param user The address of user.
1971      */
1972     function getUserNftIds(address user)
1973         public
1974         view
1975         returns (uint256[] memory,uint256[] memory, uint256[] memory)
1976     {
1977         return (userNftIds[user].ids, userNftIds[user].nftTimes , userNftIds[user].nftPeriodStaking);  //nft period ;
1978     }
1979 
1980             /**
1981      * Get length of user's nft id array.
1982      * @param user The address of user.
1983      */
1984     function getUserNftIdsLength(address user) public view returns (uint256) {
1985         return userNftIds[user].ids.length;
1986            }
1987 
1988 
1989 
1990     /**
1991      * Check if nft id exist.
1992      * @param user The address of user.
1993      * @param nftId The nft id of user.
1994      */
1995     function isNftIdExist(address user, uint256 nftId)
1996         public
1997         view
1998         returns (bool)
1999     {
2000         NftSet storage nftSet = userNftIds[user];
2001         mapping(uint256 => bool) storage isIn = nftSet.isIn;
2002         return isIn[nftId];
2003     }
2004 
2005     /**
2006      * Set user's nft id.
2007      *
2008      * Note: when nft id donot exist, the nft id will be added to ids array, and the idIn flag will be setted true;
2009      * otherwise do nothing.
2010      *
2011      * @param user The address of user.
2012      * @param nftId The nft id of user.
2013      */
2014     function setUserNftIds(address user, uint256 nftId, uint256 stakeTime ,  uint256 period) internal {
2015         NftSet storage nftSet = userNftIds[user];
2016         uint256[] storage ids = nftSet.ids;  
2017         uint256[] storage stakingStartTime = nftSet.nftTimes;
2018         uint256[] storage stakingPeriod = nftSet.nftPeriodStaking;      
2019 
2020 
2021         mapping(uint256 => bool) storage isIn = nftSet.isIn;
2022         if (!isIn[nftId]) {
2023             ids.push(nftId);
2024             stakingStartTime.push(stakeTime);
2025             stakingPeriod.push(period);
2026             isIn[nftId] = true;
2027         }
2028     }
2029 
2030     /**
2031      * Remove nft id of user.
2032      *
2033      * Note: when user's nft id amount=0, remove it from nft ids array, and set flag=false
2034      */
2035     function removeUserNftId(uint256 nftId) internal {
2036         NftSet storage nftSet = userNftIds[msg.sender];
2037         uint256[] storage ids = nftSet.ids;
2038         uint256[] storage stakingStartTime = nftSet.nftTimes;
2039         uint256[] storage stakingPeriod = nftSet.nftPeriodStaking;
2040 
2041         mapping(uint256 => bool) storage isIn = nftSet.isIn;
2042         require(ids.length > 0, "remove user nft ids, ids length must > 0");
2043 
2044         // find nftId index
2045         for (uint256 i = 0; i < ids.length; i++) {
2046             if (ids[i] == nftId) {
2047                 ids[i] = ids[ids.length - 1];
2048                 stakingStartTime[i] = stakingStartTime[ids.length - 1 ] ;
2049                 stakingPeriod[i] = stakingPeriod[ids.length - 1 ] ;
2050                 isIn[nftId] = false;
2051                 ids.pop();
2052                 stakingStartTime.pop();
2053                 stakingPeriod.pop();
2054 
2055 
2056             }
2057         }
2058     }
2059 
2060     /**
2061      * @return Returns current timestamp.
2062      */
2063     function _now() internal view returns (uint256) {		
2064             return block.timestamp;
2065     }
2066 
2067      function initRewards() internal onlyOwner {
2068         nftdailyrewards[2]=50;
2069         nftdailyrewards[60]=50;
2070         nftdailyrewards[249]=50;
2071         nftdailyrewards[350]=50;
2072         nftdailyrewards[366]=50;
2073         nftdailyrewards[556]=50;
2074         nftdailyrewards[577]=50;
2075         nftdailyrewards[584]=50;
2076         nftdailyrewards[618]=50;
2077         nftdailyrewards[731]=50;
2078         nftdailyrewards[793]=50;
2079         nftdailyrewards[969]=50;
2080         nftdailyrewards[1443]=50;
2081         nftdailyrewards[1669]=50;
2082         nftdailyrewards[1720]=50;
2083         nftdailyrewards[1858]=50;
2084         nftdailyrewards[1887]=50;
2085         nftdailyrewards[2100]=50;
2086         nftdailyrewards[2527]=50;
2087         nftdailyrewards[2881]=50;
2088         nftdailyrewards[3016]=50;
2089         nftdailyrewards[3323]=50;
2090         nftdailyrewards[3398]=50;
2091         nftdailyrewards[3412]=50;
2092         nftdailyrewards[3446]=50;
2093         nftdailyrewards[3492]=50;
2094         nftdailyrewards[3533]=50;
2095         nftdailyrewards[3552]=50;
2096         nftdailyrewards[3662]=50;
2097         nftdailyrewards[3687]=50;
2098         nftdailyrewards[3735]=50;
2099         nftdailyrewards[3864]=50;
2100         nftdailyrewards[3907]=50;
2101         nftdailyrewards[3925]=50;
2102         nftdailyrewards[3932]=50;
2103         nftdailyrewards[4017]=50;
2104         nftdailyrewards[4085]=50;
2105         nftdailyrewards[4130]=50;
2106         nftdailyrewards[4201]=50;
2107         nftdailyrewards[4404]=50;
2108 
2109     }
2110 
2111 }