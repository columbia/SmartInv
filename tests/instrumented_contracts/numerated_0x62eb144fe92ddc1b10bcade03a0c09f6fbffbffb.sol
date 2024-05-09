1 // Sources flattened with hardhat v2.8.2 https://hardhat.org
2 // SPDX-License-Identifier: MIT
3 
4 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes calldata) {
27         return msg.data;
28     }
29 }
30 
31 
32 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
33 
34 
35 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev Contract module which provides a basic access control mechanism, where
41  * there is an account (an owner) that can be granted exclusive access to
42  * specific functions.
43  *
44  * By default, the owner account will be the one that deploys the contract. This
45  * can later be changed with {transferOwnership}.
46  *
47  * This module is used through inheritance. It will make available the modifier
48  * `onlyOwner`, which can be applied to your functions to restrict their use to
49  * the owner.
50  */
51 abstract contract Ownable is Context {
52     address private _owner;
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56     /**
57      * @dev Initializes the contract setting the deployer as the initial owner.
58      */
59     constructor() {
60         _transferOwnership(_msgSender());
61     }
62 
63     /**
64      * @dev Returns the address of the current owner.
65      */
66     function owner() public view virtual returns (address) {
67         return _owner;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(owner() == _msgSender(), "Ownable: caller is not the owner");
75         _;
76     }
77 
78     /**
79      * @dev Leaves the contract without owner. It will not be possible to call
80      * `onlyOwner` functions anymore. Can only be called by the current owner.
81      *
82      * NOTE: Renouncing ownership will leave the contract without an owner,
83      * thereby removing any functionality that is only available to the owner.
84      */
85     function renounceOwnership() public virtual onlyOwner {
86         _transferOwnership(address(0));
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public virtual onlyOwner {
94         require(newOwner != address(0), "Ownable: new owner is the zero address");
95         _transferOwnership(newOwner);
96     }
97 
98     /**
99      * @dev Transfers ownership of the contract to a new account (`newOwner`).
100      * Internal function without access restriction.
101      */
102     function _transferOwnership(address newOwner) internal virtual {
103         address oldOwner = _owner;
104         _owner = newOwner;
105         emit OwnershipTransferred(oldOwner, newOwner);
106     }
107 }
108 
109 
110 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.4.2
111 
112 
113 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
114 
115 pragma solidity ^0.8.0;
116 
117 /**
118  * @dev Contract module that helps prevent reentrant calls to a function.
119  *
120  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
121  * available, which can be applied to functions to make sure there are no nested
122  * (reentrant) calls to them.
123  *
124  * Note that because there is a single `nonReentrant` guard, functions marked as
125  * `nonReentrant` may not call one another. This can be worked around by making
126  * those functions `private`, and then adding `external` `nonReentrant` entry
127  * points to them.
128  *
129  * TIP: If you would like to learn more about reentrancy and alternative ways
130  * to protect against it, check out our blog post
131  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
132  */
133 abstract contract ReentrancyGuard {
134     // Booleans are more expensive than uint256 or any type that takes up a full
135     // word because each write operation emits an extra SLOAD to first read the
136     // slot's contents, replace the bits taken up by the boolean, and then write
137     // back. This is the compiler's defense against contract upgrades and
138     // pointer aliasing, and it cannot be disabled.
139 
140     // The values being non-zero value makes deployment a bit more expensive,
141     // but in exchange the refund on every call to nonReentrant will be lower in
142     // amount. Since refunds are capped to a percentage of the total
143     // transaction's gas, it is best to keep them low in cases like this one, to
144     // increase the likelihood of the full refund coming into effect.
145     uint256 private constant _NOT_ENTERED = 1;
146     uint256 private constant _ENTERED = 2;
147 
148     uint256 private _status;
149 
150     constructor() {
151         _status = _NOT_ENTERED;
152     }
153 
154     /**
155      * @dev Prevents a contract from calling itself, directly or indirectly.
156      * Calling a `nonReentrant` function from another `nonReentrant`
157      * function is not supported. It is possible to prevent this from happening
158      * by making the `nonReentrant` function external, and making it call a
159      * `private` function that does the actual work.
160      */
161     modifier nonReentrant() {
162         // On the first call to nonReentrant, _notEntered will be true
163         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
164 
165         // Any calls to nonReentrant after this point will fail
166         _status = _ENTERED;
167 
168         _;
169 
170         // By storing the original value once again, a refund is triggered (see
171         // https://eips.ethereum.org/EIPS/eip-2200)
172         _status = _NOT_ENTERED;
173     }
174 }
175 
176 
177 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
178 
179 
180 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
181 
182 pragma solidity ^0.8.0;
183 
184 /**
185  * @dev Interface of the ERC165 standard, as defined in the
186  * https://eips.ethereum.org/EIPS/eip-165[EIP].
187  *
188  * Implementers can declare support of contract interfaces, which can then be
189  * queried by others ({ERC165Checker}).
190  *
191  * For an implementation, see {ERC165}.
192  */
193 interface IERC165 {
194     /**
195      * @dev Returns true if this contract implements the interface defined by
196      * `interfaceId`. See the corresponding
197      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
198      * to learn more about how these ids are created.
199      *
200      * This function call must use less than 30 000 gas.
201      */
202     function supportsInterface(bytes4 interfaceId) external view returns (bool);
203 }
204 
205 
206 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
207 
208 
209 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
210 
211 pragma solidity ^0.8.0;
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
350 
351 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
352 
353 
354 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
355 
356 pragma solidity ^0.8.0;
357 
358 /**
359  * @title ERC721 token receiver interface
360  * @dev Interface for any contract that wants to support safeTransfers
361  * from ERC721 asset contracts.
362  */
363 interface IERC721Receiver {
364     /**
365      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
366      * by `operator` from `from`, this function is called.
367      *
368      * It must return its Solidity selector to confirm the token transfer.
369      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
370      *
371      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
372      */
373     function onERC721Received(
374         address operator,
375         address from,
376         uint256 tokenId,
377         bytes calldata data
378     ) external returns (bytes4);
379 }
380 
381 
382 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
383 
384 
385 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
386 
387 pragma solidity ^0.8.0;
388 
389 /**
390  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
391  * @dev See https://eips.ethereum.org/EIPS/eip-721
392  */
393 interface IERC721Metadata is IERC721 {
394     /**
395      * @dev Returns the token collection name.
396      */
397     function name() external view returns (string memory);
398 
399     /**
400      * @dev Returns the token collection symbol.
401      */
402     function symbol() external view returns (string memory);
403 
404     /**
405      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
406      */
407     function tokenURI(uint256 tokenId) external view returns (string memory);
408 }
409 
410 
411 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.2
412 
413 
414 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
415 
416 pragma solidity ^0.8.0;
417 
418 /**
419  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
420  * @dev See https://eips.ethereum.org/EIPS/eip-721
421  */
422 interface IERC721Enumerable is IERC721 {
423     /**
424      * @dev Returns the total amount of tokens stored by the contract.
425      */
426     function totalSupply() external view returns (uint256);
427 
428     /**
429      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
430      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
431      */
432     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
433 
434     /**
435      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
436      * Use along with {totalSupply} to enumerate all tokens.
437      */
438     function tokenByIndex(uint256 index) external view returns (uint256);
439 }
440 
441 
442 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
443 
444 
445 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
446 
447 pragma solidity ^0.8.0;
448 
449 /**
450  * @dev Collection of functions related to the address type
451  */
452 library Address {
453     /**
454      * @dev Returns true if `account` is a contract.
455      *
456      * [IMPORTANT]
457      * ====
458      * It is unsafe to assume that an address for which this function returns
459      * false is an externally-owned account (EOA) and not a contract.
460      *
461      * Among others, `isContract` will return false for the following
462      * types of addresses:
463      *
464      *  - an externally-owned account
465      *  - a contract in construction
466      *  - an address where a contract will be created
467      *  - an address where a contract lived, but was destroyed
468      * ====
469      */
470     function isContract(address account) internal view returns (bool) {
471         // This method relies on extcodesize, which returns 0 for contracts in
472         // construction, since the code is only stored at the end of the
473         // constructor execution.
474 
475         uint256 size;
476         assembly {
477             size := extcodesize(account)
478         }
479         return size > 0;
480     }
481 
482     /**
483      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
484      * `recipient`, forwarding all available gas and reverting on errors.
485      *
486      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
487      * of certain opcodes, possibly making contracts go over the 2300 gas limit
488      * imposed by `transfer`, making them unable to receive funds via
489      * `transfer`. {sendValue} removes this limitation.
490      *
491      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
492      *
493      * IMPORTANT: because control is transferred to `recipient`, care must be
494      * taken to not create reentrancy vulnerabilities. Consider using
495      * {ReentrancyGuard} or the
496      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
497      */
498     function sendValue(address payable recipient, uint256 amount) internal {
499         require(address(this).balance >= amount, "Address: insufficient balance");
500 
501         (bool success, ) = recipient.call{value: amount}("");
502         require(success, "Address: unable to send value, recipient may have reverted");
503     }
504 
505     /**
506      * @dev Performs a Solidity function call using a low level `call`. A
507      * plain `call` is an unsafe replacement for a function call: use this
508      * function instead.
509      *
510      * If `target` reverts with a revert reason, it is bubbled up by this
511      * function (like regular Solidity function calls).
512      *
513      * Returns the raw returned data. To convert to the expected return value,
514      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
515      *
516      * Requirements:
517      *
518      * - `target` must be a contract.
519      * - calling `target` with `data` must not revert.
520      *
521      * _Available since v3.1._
522      */
523     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
524         return functionCall(target, data, "Address: low-level call failed");
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
529      * `errorMessage` as a fallback revert reason when `target` reverts.
530      *
531      * _Available since v3.1._
532      */
533     function functionCall(
534         address target,
535         bytes memory data,
536         string memory errorMessage
537     ) internal returns (bytes memory) {
538         return functionCallWithValue(target, data, 0, errorMessage);
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
543      * but also transferring `value` wei to `target`.
544      *
545      * Requirements:
546      *
547      * - the calling contract must have an ETH balance of at least `value`.
548      * - the called Solidity function must be `payable`.
549      *
550      * _Available since v3.1._
551      */
552     function functionCallWithValue(
553         address target,
554         bytes memory data,
555         uint256 value
556     ) internal returns (bytes memory) {
557         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
558     }
559 
560     /**
561      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
562      * with `errorMessage` as a fallback revert reason when `target` reverts.
563      *
564      * _Available since v3.1._
565      */
566     function functionCallWithValue(
567         address target,
568         bytes memory data,
569         uint256 value,
570         string memory errorMessage
571     ) internal returns (bytes memory) {
572         require(address(this).balance >= value, "Address: insufficient balance for call");
573         require(isContract(target), "Address: call to non-contract");
574 
575         (bool success, bytes memory returndata) = target.call{value: value}(data);
576         return verifyCallResult(success, returndata, errorMessage);
577     }
578 
579     /**
580      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
581      * but performing a static call.
582      *
583      * _Available since v3.3._
584      */
585     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
586         return functionStaticCall(target, data, "Address: low-level static call failed");
587     }
588 
589     /**
590      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
591      * but performing a static call.
592      *
593      * _Available since v3.3._
594      */
595     function functionStaticCall(
596         address target,
597         bytes memory data,
598         string memory errorMessage
599     ) internal view returns (bytes memory) {
600         require(isContract(target), "Address: static call to non-contract");
601 
602         (bool success, bytes memory returndata) = target.staticcall(data);
603         return verifyCallResult(success, returndata, errorMessage);
604     }
605 
606     /**
607      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
608      * but performing a delegate call.
609      *
610      * _Available since v3.4._
611      */
612     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
613         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
614     }
615 
616     /**
617      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
618      * but performing a delegate call.
619      *
620      * _Available since v3.4._
621      */
622     function functionDelegateCall(
623         address target,
624         bytes memory data,
625         string memory errorMessage
626     ) internal returns (bytes memory) {
627         require(isContract(target), "Address: delegate call to non-contract");
628 
629         (bool success, bytes memory returndata) = target.delegatecall(data);
630         return verifyCallResult(success, returndata, errorMessage);
631     }
632 
633     /**
634      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
635      * revert reason using the provided one.
636      *
637      * _Available since v4.3._
638      */
639     function verifyCallResult(
640         bool success,
641         bytes memory returndata,
642         string memory errorMessage
643     ) internal pure returns (bytes memory) {
644         if (success) {
645             return returndata;
646         } else {
647             // Look for revert reason and bubble it up if present
648             if (returndata.length > 0) {
649                 // The easiest way to bubble the revert reason is using memory via assembly
650 
651                 assembly {
652                     let returndata_size := mload(returndata)
653                     revert(add(32, returndata), returndata_size)
654                 }
655             } else {
656                 revert(errorMessage);
657             }
658         }
659     }
660 }
661 
662 
663 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
664 
665 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
666 
667 pragma solidity ^0.8.0;
668 
669 /**
670  * @dev String operations.
671  */
672 library Strings {
673     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
674 
675     /**
676      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
677      */
678     function toString(uint256 value) internal pure returns (string memory) {
679         // Inspired by OraclizeAPI's implementation - MIT licence
680         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
681 
682         if (value == 0) {
683             return "0";
684         }
685         uint256 temp = value;
686         uint256 digits;
687         while (temp != 0) {
688             digits++;
689             temp /= 10;
690         }
691         bytes memory buffer = new bytes(digits);
692         while (value != 0) {
693             digits -= 1;
694             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
695             value /= 10;
696         }
697         return string(buffer);
698     }
699 
700     /**
701      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
702      */
703     function toHexString(uint256 value) internal pure returns (string memory) {
704         if (value == 0) {
705             return "0x00";
706         }
707         uint256 temp = value;
708         uint256 length = 0;
709         while (temp != 0) {
710             length++;
711             temp >>= 8;
712         }
713         return toHexString(value, length);
714     }
715 
716     /**
717      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
718      */
719     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
720         bytes memory buffer = new bytes(2 * length + 2);
721         buffer[0] = "0";
722         buffer[1] = "x";
723         for (uint256 i = 2 * length + 1; i > 1; --i) {
724             buffer[i] = _HEX_SYMBOLS[value & 0xf];
725             value >>= 4;
726         }
727         require(value == 0, "Strings: hex length insufficient");
728         return string(buffer);
729     }
730 }
731 
732 
733 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
734 
735 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
736 
737 pragma solidity ^0.8.0;
738 
739 /**
740  * @dev Implementation of the {IERC165} interface.
741  *
742  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
743  * for the additional interface id that will be supported. For example:
744  *
745  * ```solidity
746  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
747  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
748  * }
749  * ```
750  *
751  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
752  */
753 abstract contract ERC165 is IERC165 {
754     /**
755      * @dev See {IERC165-supportsInterface}.
756      */
757     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
758         return interfaceId == type(IERC165).interfaceId;
759     }
760 }
761 
762 
763 // File contracts/ERC721A.sol
764 
765 // Creator: Chiru Labs
766 
767 pragma solidity ^0.8.4;
768 
769 
770 
771 
772 
773 
774 
775 
776 error ApprovalCallerNotOwnerNorApproved();
777 error ApprovalQueryForNonexistentToken();
778 error ApproveToCaller();
779 error ApprovalToCurrentOwner();
780 error BalanceQueryForZeroAddress();
781 error MintedQueryForZeroAddress();
782 error BurnedQueryForZeroAddress();
783 error AuxQueryForZeroAddress();
784 error MintToZeroAddress();
785 error MintZeroQuantity();
786 error OwnerIndexOutOfBounds();
787 error OwnerQueryForNonexistentToken();
788 error TokenIndexOutOfBounds();
789 error TransferCallerNotOwnerNorApproved();
790 error TransferFromIncorrectOwner();
791 error TransferToNonERC721ReceiverImplementer();
792 error TransferToZeroAddress();
793 error URIQueryForNonexistentToken();
794 
795 /**
796  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
797  * the Metadata extension. Built to optimize for lower gas during batch mints.
798  *
799  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
800  *
801  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
802  *
803  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
804  */
805 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
806     using Address for address;
807     using Strings for uint256;
808 
809     // Compiler will pack this into a single 256bit word.
810     struct TokenOwnership {
811         // The address of the owner.
812         address addr;
813         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
814         uint64 startTimestamp;
815         // Whether the token has been burned.
816         bool burned;
817     }
818 
819     // Compiler will pack this into a single 256bit word.
820     struct AddressData {
821         // Realistically, 2**64-1 is more than enough.
822         uint64 balance;
823         // Keeps track of mint count with minimal overhead for tokenomics.
824         uint64 numberMinted;
825         // Keeps track of burn count with minimal overhead for tokenomics.
826         uint64 numberBurned;
827         // For miscellaneous variable(s) pertaining to the address
828         // (e.g. number of whitelist mint slots used). 
829         // If there are multiple variables, please pack them into a uint64.
830         uint64 aux;
831     }
832 
833     // The tokenId of the next token to be minted.
834     uint256 internal _currentIndex;
835 
836     // The number of tokens burned.
837     uint256 internal _burnCounter;
838 
839     // Token name
840     string private _name;
841 
842     // Token symbol
843     string private _symbol;
844 
845     // Mapping from token ID to ownership details
846     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
847     mapping(uint256 => TokenOwnership) internal _ownerships;
848 
849     // Mapping owner address to address data
850     mapping(address => AddressData) private _addressData;
851 
852     // Mapping from token ID to approved address
853     mapping(uint256 => address) private _tokenApprovals;
854 
855     // Mapping from owner to operator approvals
856     mapping(address => mapping(address => bool)) private _operatorApprovals;
857 
858     constructor(string memory name_, string memory symbol_) {
859         _name = name_;
860         _symbol = symbol_;
861     }
862 
863     /**
864      * @dev See {IERC721Enumerable-totalSupply}.
865      */
866     function totalSupply() public view returns (uint256) {
867         // Counter underflow is impossible as _burnCounter cannot be incremented
868         // more than _currentIndex times
869         unchecked {
870             return _currentIndex - _burnCounter;    
871         }
872     }
873 
874     /**
875      * @dev See {IERC165-supportsInterface}.
876      */
877     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
878         return
879             interfaceId == type(IERC721).interfaceId ||
880             interfaceId == type(IERC721Metadata).interfaceId ||
881             super.supportsInterface(interfaceId);
882     }
883 
884     /**
885      * @dev See {IERC721-balanceOf}.
886      */
887     function balanceOf(address owner) public view override returns (uint256) {
888         if (owner == address(0)) revert BalanceQueryForZeroAddress();
889         return uint256(_addressData[owner].balance);
890     }
891 
892     /**
893      * Returns the number of tokens minted by `owner`.
894      */
895     function _numberMinted(address owner) internal view returns (uint256) {
896         if (owner == address(0)) revert MintedQueryForZeroAddress();
897         return uint256(_addressData[owner].numberMinted);
898     }
899 
900     /**
901      * Returns the number of tokens burned by or on behalf of `owner`.
902      */
903     function _numberBurned(address owner) internal view returns (uint256) {
904         if (owner == address(0)) revert BurnedQueryForZeroAddress();
905         return uint256(_addressData[owner].numberBurned);
906     }
907 
908     /**
909      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
910      */
911     function _getAux(address owner) internal view returns (uint64) {
912         if (owner == address(0)) revert AuxQueryForZeroAddress();
913         return _addressData[owner].aux;
914     }
915 
916     /**
917      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
918      * If there are multiple variables, please pack them into a uint64.
919      */
920     function _setAux(address owner, uint64 aux) internal {
921         if (owner == address(0)) revert AuxQueryForZeroAddress();
922         _addressData[owner].aux = aux;
923     }
924 
925     /**
926      * Gas spent here starts off proportional to the maximum mint batch size.
927      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
928      */
929     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
930         uint256 curr = tokenId;
931 
932         unchecked {
933             if (curr < _currentIndex) {
934                 TokenOwnership memory ownership = _ownerships[curr];
935                 if (!ownership.burned) {
936                     if (ownership.addr != address(0)) {
937                         return ownership;
938                     }
939                     // Invariant: 
940                     // There will always be an ownership that has an address and is not burned 
941                     // before an ownership that does not have an address and is not burned.
942                     // Hence, curr will not underflow.
943                     while (true) {
944                         curr--;
945                         ownership = _ownerships[curr];
946                         if (ownership.addr != address(0)) {
947                             return ownership;
948                         }
949                     }
950                 }
951             }
952         }
953         revert OwnerQueryForNonexistentToken();
954     }
955 
956     /**
957      * @dev See {IERC721-ownerOf}.
958      */
959     function ownerOf(uint256 tokenId) public view override returns (address) {
960         return ownershipOf(tokenId).addr;
961     }
962 
963     /**
964      * @dev See {IERC721Metadata-name}.
965      */
966     function name() public view virtual override returns (string memory) {
967         return _name;
968     }
969 
970     /**
971      * @dev See {IERC721Metadata-symbol}.
972      */
973     function symbol() public view virtual override returns (string memory) {
974         return _symbol;
975     }
976 
977     /**
978      * @dev See {IERC721Metadata-tokenURI}.
979      */
980     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
981         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
982 
983         string memory baseURI = _baseURI();
984         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
985     }
986 
987     /**
988      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
989      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
990      * by default, can be overriden in child contracts.
991      */
992     function _baseURI() internal view virtual returns (string memory) {
993         return '';
994     }
995 
996     /**
997      * @dev See {IERC721-approve}.
998      */
999     function approve(address to, uint256 tokenId) public override {
1000         address owner = ERC721A.ownerOf(tokenId);
1001         if (to == owner) revert ApprovalToCurrentOwner();
1002 
1003         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1004             revert ApprovalCallerNotOwnerNorApproved();
1005         }
1006 
1007         _approve(to, tokenId, owner);
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-getApproved}.
1012      */
1013     function getApproved(uint256 tokenId) public view override returns (address) {
1014         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1015 
1016         return _tokenApprovals[tokenId];
1017     }
1018 
1019     /**
1020      * @dev See {IERC721-setApprovalForAll}.
1021      */
1022     function setApprovalForAll(address operator, bool approved) public override {
1023         if (operator == _msgSender()) revert ApproveToCaller();
1024 
1025         _operatorApprovals[_msgSender()][operator] = approved;
1026         emit ApprovalForAll(_msgSender(), operator, approved);
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-isApprovedForAll}.
1031      */
1032     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1033         return _operatorApprovals[owner][operator];
1034     }
1035 
1036     /**
1037      * @dev See {IERC721-transferFrom}.
1038      */
1039     function transferFrom(
1040         address from,
1041         address to,
1042         uint256 tokenId
1043     ) public virtual override {
1044         _transfer(from, to, tokenId);
1045     }
1046 
1047     /**
1048      * @dev See {IERC721-safeTransferFrom}.
1049      */
1050     function safeTransferFrom(
1051         address from,
1052         address to,
1053         uint256 tokenId
1054     ) public virtual override {
1055         safeTransferFrom(from, to, tokenId, '');
1056     }
1057 
1058     /**
1059      * @dev See {IERC721-safeTransferFrom}.
1060      */
1061     function safeTransferFrom(
1062         address from,
1063         address to,
1064         uint256 tokenId,
1065         bytes memory _data
1066     ) public virtual override {
1067         _transfer(from, to, tokenId);
1068         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1069             revert TransferToNonERC721ReceiverImplementer();
1070         }
1071     }
1072 
1073     /**
1074      * @dev Returns whether `tokenId` exists.
1075      *
1076      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1077      *
1078      * Tokens start existing when they are minted (`_mint`),
1079      */
1080     function _exists(uint256 tokenId) internal view returns (bool) {
1081         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1082     }
1083 
1084     function _safeMint(address to, uint256 quantity) internal {
1085         _safeMint(to, quantity, '');
1086     }
1087 
1088     /**
1089      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1090      *
1091      * Requirements:
1092      *
1093      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1094      * - `quantity` must be greater than 0.
1095      *
1096      * Emits a {Transfer} event.
1097      */
1098     function _safeMint(
1099         address to,
1100         uint256 quantity,
1101         bytes memory _data
1102     ) internal {
1103         _mint(to, quantity, _data, true);
1104     }
1105 
1106     /**
1107      * @dev Mints `quantity` tokens and transfers them to `to`.
1108      *
1109      * Requirements:
1110      *
1111      * - `to` cannot be the zero address.
1112      * - `quantity` must be greater than 0.
1113      *
1114      * Emits a {Transfer} event.
1115      */
1116     function _mint(
1117         address to,
1118         uint256 quantity,
1119         bytes memory _data,
1120         bool safe
1121     ) internal {
1122         uint256 startTokenId = _currentIndex;
1123         if (to == address(0)) revert MintToZeroAddress();
1124         if (quantity == 0) revert MintZeroQuantity();
1125 
1126         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1127 
1128         // Overflows are incredibly unrealistic.
1129         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1130         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1131         unchecked {
1132             _addressData[to].balance += uint64(quantity);
1133             _addressData[to].numberMinted += uint64(quantity);
1134 
1135             _ownerships[startTokenId].addr = to;
1136             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1137 
1138             uint256 updatedIndex = startTokenId;
1139 
1140             for (uint256 i; i < quantity; i++) {
1141                 emit Transfer(address(0), to, updatedIndex);
1142                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1143                     revert TransferToNonERC721ReceiverImplementer();
1144                 }
1145                 updatedIndex++;
1146             }
1147 
1148             _currentIndex = updatedIndex;
1149         }
1150         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1151     }
1152 
1153     /**
1154      * @dev Transfers `tokenId` from `from` to `to`.
1155      *
1156      * Requirements:
1157      *
1158      * - `to` cannot be the zero address.
1159      * - `tokenId` token must be owned by `from`.
1160      *
1161      * Emits a {Transfer} event.
1162      */
1163     function _transfer(
1164         address from,
1165         address to,
1166         uint256 tokenId
1167     ) private {
1168         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1169 
1170         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1171             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1172             getApproved(tokenId) == _msgSender());
1173 
1174         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1175         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1176         if (to == address(0)) revert TransferToZeroAddress();
1177 
1178         _beforeTokenTransfers(from, to, tokenId, 1);
1179 
1180         // Clear approvals from the previous owner
1181         _approve(address(0), tokenId, prevOwnership.addr);
1182 
1183         // Underflow of the sender's balance is impossible because we check for
1184         // ownership above and the recipient's balance can't realistically overflow.
1185         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1186         unchecked {
1187             _addressData[from].balance -= 1;
1188             _addressData[to].balance += 1;
1189 
1190             _ownerships[tokenId].addr = to;
1191             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1192 
1193             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1194             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1195             uint256 nextTokenId = tokenId + 1;
1196             if (_ownerships[nextTokenId].addr == address(0)) {
1197                 // This will suffice for checking _exists(nextTokenId),
1198                 // as a burned slot cannot contain the zero address.
1199                 if (nextTokenId < _currentIndex) {
1200                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1201                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1202                 }
1203             }
1204         }
1205 
1206         emit Transfer(from, to, tokenId);
1207         _afterTokenTransfers(from, to, tokenId, 1);
1208     }
1209 
1210     /**
1211      * @dev Destroys `tokenId`.
1212      * The approval is cleared when the token is burned.
1213      *
1214      * Requirements:
1215      *
1216      * - `tokenId` must exist.
1217      *
1218      * Emits a {Transfer} event.
1219      */
1220     function _burn(uint256 tokenId) internal virtual {
1221         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1222 
1223         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1224 
1225         // Clear approvals from the previous owner
1226         _approve(address(0), tokenId, prevOwnership.addr);
1227 
1228         // Underflow of the sender's balance is impossible because we check for
1229         // ownership above and the recipient's balance can't realistically overflow.
1230         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1231         unchecked {
1232             _addressData[prevOwnership.addr].balance -= 1;
1233             _addressData[prevOwnership.addr].numberBurned += 1;
1234 
1235             // Keep track of who burned the token, and the timestamp of burning.
1236             _ownerships[tokenId].addr = prevOwnership.addr;
1237             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1238             _ownerships[tokenId].burned = true;
1239 
1240             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1241             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1242             uint256 nextTokenId = tokenId + 1;
1243             if (_ownerships[nextTokenId].addr == address(0)) {
1244                 // This will suffice for checking _exists(nextTokenId),
1245                 // as a burned slot cannot contain the zero address.
1246                 if (nextTokenId < _currentIndex) {
1247                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1248                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1249                 }
1250             }
1251         }
1252 
1253         emit Transfer(prevOwnership.addr, address(0), tokenId);
1254         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1255 
1256         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1257         unchecked { 
1258             _burnCounter++;
1259         }
1260     }
1261 
1262     /**
1263      * @dev Approve `to` to operate on `tokenId`
1264      *
1265      * Emits a {Approval} event.
1266      */
1267     function _approve(
1268         address to,
1269         uint256 tokenId,
1270         address owner
1271     ) private {
1272         _tokenApprovals[tokenId] = to;
1273         emit Approval(owner, to, tokenId);
1274     }
1275 
1276     /**
1277      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1278      * The call is not executed if the target address is not a contract.
1279      *
1280      * @param from address representing the previous owner of the given token ID
1281      * @param to target address that will receive the tokens
1282      * @param tokenId uint256 ID of the token to be transferred
1283      * @param _data bytes optional data to send along with the call
1284      * @return bool whether the call correctly returned the expected magic value
1285      */
1286     function _checkOnERC721Received(
1287         address from,
1288         address to,
1289         uint256 tokenId,
1290         bytes memory _data
1291     ) private returns (bool) {
1292         if (to.isContract()) {
1293             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1294                 return retval == IERC721Receiver(to).onERC721Received.selector;
1295             } catch (bytes memory reason) {
1296                 if (reason.length == 0) {
1297                     revert TransferToNonERC721ReceiverImplementer();
1298                 } else {
1299                     assembly {
1300                         revert(add(32, reason), mload(reason))
1301                     }
1302                 }
1303             }
1304         } else {
1305             return true;
1306         }
1307     }
1308 
1309     /**
1310      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1311      * And also called before burning one token.
1312      *
1313      * startTokenId - the first token id to be transferred
1314      * quantity - the amount to be transferred
1315      *
1316      * Calling conditions:
1317      *
1318      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1319      * transferred to `to`.
1320      * - When `from` is zero, `tokenId` will be minted for `to`.
1321      * - When `to` is zero, `tokenId` will be burned by `from`.
1322      * - `from` and `to` are never both zero.
1323      */
1324     function _beforeTokenTransfers(
1325         address from,
1326         address to,
1327         uint256 startTokenId,
1328         uint256 quantity
1329     ) internal virtual {}
1330 
1331     /**
1332      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1333      * minting.
1334      * And also called after one token has been burned.
1335      *
1336      * startTokenId - the first token id to be transferred
1337      * quantity - the amount to be transferred
1338      *
1339      * Calling conditions:
1340      *
1341      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1342      * transferred to `to`.
1343      * - When `from` is zero, `tokenId` has been minted for `to`.
1344      * - When `to` is zero, `tokenId` has been burned by `from`.
1345      * - `from` and `to` are never both zero.
1346      */
1347     function _afterTokenTransfers(
1348         address from,
1349         address to,
1350         uint256 startTokenId,
1351         uint256 quantity
1352     ) internal virtual {}
1353 }
1354 
1355 
1356 // File contracts/MerkleProof.sol
1357 
1358 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
1359 
1360 pragma solidity ^0.8.0;
1361 
1362 /**
1363  * @dev These functions deal with verification of Merkle Trees proofs.
1364  *
1365  * The proofs can be generated using the JavaScript library
1366  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1367  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1368  *
1369  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1370  */
1371 library MerkleProof {
1372     /**
1373      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1374      * defined by `root`. For this, a `proof` must be provided, containing
1375      * sibling hashes on the branch from the leaf to the root of the tree. Each
1376      * pair of leaves and each pair of pre-images are assumed to be sorted.
1377      */
1378     function verify(
1379         bytes32[] memory proof,
1380         bytes32 root,
1381         bytes32 leaf
1382     ) internal pure returns (bool) {
1383         return processProof(proof, leaf) == root;
1384     }
1385 
1386     /**
1387      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1388      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1389      * hash matches the root of the tree. When processing the proof, the pairs
1390      * of leafs & pre-images are assumed to be sorted.
1391      *
1392      * _Available since v4.4._
1393      */
1394     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1395         bytes32 computedHash = leaf;
1396         for (uint256 i = 0; i < proof.length; i++) {
1397             bytes32 proofElement = proof[i];
1398             if (computedHash <= proofElement) {
1399                 // Hash(current computed hash + current element of the proof)
1400                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1401             } else {
1402                 // Hash(current element of the proof + current computed hash)
1403                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1404             }
1405         }
1406         return computedHash;
1407     }
1408 }
1409 
1410 
1411 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.4.2
1412 
1413 
1414 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
1415 
1416 pragma solidity ^0.8.0;
1417 
1418 // CAUTION
1419 // This version of SafeMath should only be used with Solidity 0.8 or later,
1420 // because it relies on the compiler's built in overflow checks.
1421 
1422 /**
1423  * @dev Wrappers over Solidity's arithmetic operations.
1424  *
1425  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1426  * now has built in overflow checking.
1427  */
1428 library SafeMath {
1429     /**
1430      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1431      *
1432      * _Available since v3.4._
1433      */
1434     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1435         unchecked {
1436             uint256 c = a + b;
1437             if (c < a) return (false, 0);
1438             return (true, c);
1439         }
1440     }
1441 
1442     /**
1443      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1444      *
1445      * _Available since v3.4._
1446      */
1447     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1448         unchecked {
1449             if (b > a) return (false, 0);
1450             return (true, a - b);
1451         }
1452     }
1453 
1454     /**
1455      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1456      *
1457      * _Available since v3.4._
1458      */
1459     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1460         unchecked {
1461             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1462             // benefit is lost if 'b' is also tested.
1463             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1464             if (a == 0) return (true, 0);
1465             uint256 c = a * b;
1466             if (c / a != b) return (false, 0);
1467             return (true, c);
1468         }
1469     }
1470 
1471     /**
1472      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1473      *
1474      * _Available since v3.4._
1475      */
1476     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1477         unchecked {
1478             if (b == 0) return (false, 0);
1479             return (true, a / b);
1480         }
1481     }
1482 
1483     /**
1484      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1485      *
1486      * _Available since v3.4._
1487      */
1488     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1489         unchecked {
1490             if (b == 0) return (false, 0);
1491             return (true, a % b);
1492         }
1493     }
1494 
1495     /**
1496      * @dev Returns the addition of two unsigned integers, reverting on
1497      * overflow.
1498      *
1499      * Counterpart to Solidity's `+` operator.
1500      *
1501      * Requirements:
1502      *
1503      * - Addition cannot overflow.
1504      */
1505     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1506         return a + b;
1507     }
1508 
1509     /**
1510      * @dev Returns the subtraction of two unsigned integers, reverting on
1511      * overflow (when the result is negative).
1512      *
1513      * Counterpart to Solidity's `-` operator.
1514      *
1515      * Requirements:
1516      *
1517      * - Subtraction cannot overflow.
1518      */
1519     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1520         return a - b;
1521     }
1522 
1523     /**
1524      * @dev Returns the multiplication of two unsigned integers, reverting on
1525      * overflow.
1526      *
1527      * Counterpart to Solidity's `*` operator.
1528      *
1529      * Requirements:
1530      *
1531      * - Multiplication cannot overflow.
1532      */
1533     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1534         return a * b;
1535     }
1536 
1537     /**
1538      * @dev Returns the integer division of two unsigned integers, reverting on
1539      * division by zero. The result is rounded towards zero.
1540      *
1541      * Counterpart to Solidity's `/` operator.
1542      *
1543      * Requirements:
1544      *
1545      * - The divisor cannot be zero.
1546      */
1547     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1548         return a / b;
1549     }
1550 
1551     /**
1552      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1553      * reverting when dividing by zero.
1554      *
1555      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1556      * opcode (which leaves remaining gas untouched) while Solidity uses an
1557      * invalid opcode to revert (consuming all remaining gas).
1558      *
1559      * Requirements:
1560      *
1561      * - The divisor cannot be zero.
1562      */
1563     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1564         return a % b;
1565     }
1566 
1567     /**
1568      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1569      * overflow (when the result is negative).
1570      *
1571      * CAUTION: This function is deprecated because it requires allocating memory for the error
1572      * message unnecessarily. For custom revert reasons use {trySub}.
1573      *
1574      * Counterpart to Solidity's `-` operator.
1575      *
1576      * Requirements:
1577      *
1578      * - Subtraction cannot overflow.
1579      */
1580     function sub(
1581         uint256 a,
1582         uint256 b,
1583         string memory errorMessage
1584     ) internal pure returns (uint256) {
1585         unchecked {
1586             require(b <= a, errorMessage);
1587             return a - b;
1588         }
1589     }
1590 
1591     /**
1592      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1593      * division by zero. The result is rounded towards zero.
1594      *
1595      * Counterpart to Solidity's `/` operator. Note: this function uses a
1596      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1597      * uses an invalid opcode to revert (consuming all remaining gas).
1598      *
1599      * Requirements:
1600      *
1601      * - The divisor cannot be zero.
1602      */
1603     function div(
1604         uint256 a,
1605         uint256 b,
1606         string memory errorMessage
1607     ) internal pure returns (uint256) {
1608         unchecked {
1609             require(b > 0, errorMessage);
1610             return a / b;
1611         }
1612     }
1613 
1614     /**
1615      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1616      * reverting with custom message when dividing by zero.
1617      *
1618      * CAUTION: This function is deprecated because it requires allocating memory for the error
1619      * message unnecessarily. For custom revert reasons use {tryMod}.
1620      *
1621      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1622      * opcode (which leaves remaining gas untouched) while Solidity uses an
1623      * invalid opcode to revert (consuming all remaining gas).
1624      *
1625      * Requirements:
1626      *
1627      * - The divisor cannot be zero.
1628      */
1629     function mod(
1630         uint256 a,
1631         uint256 b,
1632         string memory errorMessage
1633     ) internal pure returns (uint256) {
1634         unchecked {
1635             require(b > 0, errorMessage);
1636             return a % b;
1637         }
1638     }
1639 }
1640 
1641 
1642 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.4.2
1643 
1644 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1645 
1646 pragma solidity ^0.8.0;
1647 
1648 
1649 
1650 
1651 
1652 
1653 
1654 /**
1655  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1656  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1657  * {ERC721Enumerable}.
1658  */
1659 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1660     using Address for address;
1661     using Strings for uint256;
1662 
1663     // Token name
1664     string private _name;
1665 
1666     // Token symbol
1667     string private _symbol;
1668 
1669     // Mapping from token ID to owner address
1670     mapping(uint256 => address) private _owners;
1671 
1672     // Mapping owner address to token count
1673     mapping(address => uint256) private _balances;
1674 
1675     // Mapping from token ID to approved address
1676     mapping(uint256 => address) private _tokenApprovals;
1677 
1678     // Mapping from owner to operator approvals
1679     mapping(address => mapping(address => bool)) private _operatorApprovals;
1680 
1681     /**
1682      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1683      */
1684     constructor(string memory name_, string memory symbol_) {
1685         _name = name_;
1686         _symbol = symbol_;
1687     }
1688 
1689     /**
1690      * @dev See {IERC165-supportsInterface}.
1691      */
1692     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1693         return
1694             interfaceId == type(IERC721).interfaceId ||
1695             interfaceId == type(IERC721Metadata).interfaceId ||
1696             super.supportsInterface(interfaceId);
1697     }
1698 
1699     /**
1700      * @dev See {IERC721-balanceOf}.
1701      */
1702     function balanceOf(address owner) public view virtual override returns (uint256) {
1703         require(owner != address(0), "ERC721: balance query for the zero address");
1704         return _balances[owner];
1705     }
1706 
1707     /**
1708      * @dev See {IERC721-ownerOf}.
1709      */
1710     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1711         address owner = _owners[tokenId];
1712         require(owner != address(0), "ERC721: owner query for nonexistent token");
1713         return owner;
1714     }
1715 
1716     /**
1717      * @dev See {IERC721Metadata-name}.
1718      */
1719     function name() public view virtual override returns (string memory) {
1720         return _name;
1721     }
1722 
1723     /**
1724      * @dev See {IERC721Metadata-symbol}.
1725      */
1726     function symbol() public view virtual override returns (string memory) {
1727         return _symbol;
1728     }
1729 
1730     /**
1731      * @dev See {IERC721Metadata-tokenURI}.
1732      */
1733     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1734         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1735 
1736         string memory baseURI = _baseURI();
1737         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1738     }
1739 
1740     /**
1741      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1742      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1743      * by default, can be overriden in child contracts.
1744      */
1745     function _baseURI() internal view virtual returns (string memory) {
1746         return "";
1747     }
1748 
1749     /**
1750      * @dev See {IERC721-approve}.
1751      */
1752     function approve(address to, uint256 tokenId) public virtual override {
1753         address owner = ERC721.ownerOf(tokenId);
1754         require(to != owner, "ERC721: approval to current owner");
1755 
1756         require(
1757             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1758             "ERC721: approve caller is not owner nor approved for all"
1759         );
1760 
1761         _approve(to, tokenId);
1762     }
1763 
1764     /**
1765      * @dev See {IERC721-getApproved}.
1766      */
1767     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1768         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1769 
1770         return _tokenApprovals[tokenId];
1771     }
1772 
1773     /**
1774      * @dev See {IERC721-setApprovalForAll}.
1775      */
1776     function setApprovalForAll(address operator, bool approved) public virtual override {
1777         _setApprovalForAll(_msgSender(), operator, approved);
1778     }
1779 
1780     /**
1781      * @dev See {IERC721-isApprovedForAll}.
1782      */
1783     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1784         return _operatorApprovals[owner][operator];
1785     }
1786 
1787     /**
1788      * @dev See {IERC721-transferFrom}.
1789      */
1790     function transferFrom(
1791         address from,
1792         address to,
1793         uint256 tokenId
1794     ) public virtual override {
1795         //solhint-disable-next-line max-line-length
1796         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1797 
1798         _transfer(from, to, tokenId);
1799     }
1800 
1801     /**
1802      * @dev See {IERC721-safeTransferFrom}.
1803      */
1804     function safeTransferFrom(
1805         address from,
1806         address to,
1807         uint256 tokenId
1808     ) public virtual override {
1809         safeTransferFrom(from, to, tokenId, "");
1810     }
1811 
1812     /**
1813      * @dev See {IERC721-safeTransferFrom}.
1814      */
1815     function safeTransferFrom(
1816         address from,
1817         address to,
1818         uint256 tokenId,
1819         bytes memory _data
1820     ) public virtual override {
1821         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1822         _safeTransfer(from, to, tokenId, _data);
1823     }
1824 
1825     /**
1826      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1827      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1828      *
1829      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1830      *
1831      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1832      * implement alternative mechanisms to perform token transfer, such as signature-based.
1833      *
1834      * Requirements:
1835      *
1836      * - `from` cannot be the zero address.
1837      * - `to` cannot be the zero address.
1838      * - `tokenId` token must exist and be owned by `from`.
1839      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1840      *
1841      * Emits a {Transfer} event.
1842      */
1843     function _safeTransfer(
1844         address from,
1845         address to,
1846         uint256 tokenId,
1847         bytes memory _data
1848     ) internal virtual {
1849         _transfer(from, to, tokenId);
1850         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1851     }
1852 
1853     /**
1854      * @dev Returns whether `tokenId` exists.
1855      *
1856      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1857      *
1858      * Tokens start existing when they are minted (`_mint`),
1859      * and stop existing when they are burned (`_burn`).
1860      */
1861     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1862         return _owners[tokenId] != address(0);
1863     }
1864 
1865     /**
1866      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1867      *
1868      * Requirements:
1869      *
1870      * - `tokenId` must exist.
1871      */
1872     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1873         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1874         address owner = ERC721.ownerOf(tokenId);
1875         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1876     }
1877 
1878     /**
1879      * @dev Safely mints `tokenId` and transfers it to `to`.
1880      *
1881      * Requirements:
1882      *
1883      * - `tokenId` must not exist.
1884      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1885      *
1886      * Emits a {Transfer} event.
1887      */
1888     function _safeMint(address to, uint256 tokenId) internal virtual {
1889         _safeMint(to, tokenId, "");
1890     }
1891 
1892     /**
1893      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1894      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1895      */
1896     function _safeMint(
1897         address to,
1898         uint256 tokenId,
1899         bytes memory _data
1900     ) internal virtual {
1901         _mint(to, tokenId);
1902         require(
1903             _checkOnERC721Received(address(0), to, tokenId, _data),
1904             "ERC721: transfer to non ERC721Receiver implementer"
1905         );
1906     }
1907 
1908     /**
1909      * @dev Mints `tokenId` and transfers it to `to`.
1910      *
1911      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1912      *
1913      * Requirements:
1914      *
1915      * - `tokenId` must not exist.
1916      * - `to` cannot be the zero address.
1917      *
1918      * Emits a {Transfer} event.
1919      */
1920     function _mint(address to, uint256 tokenId) internal virtual {
1921         require(to != address(0), "ERC721: mint to the zero address");
1922         require(!_exists(tokenId), "ERC721: token already minted");
1923 
1924         _beforeTokenTransfer(address(0), to, tokenId);
1925 
1926         _balances[to] += 1;
1927         _owners[tokenId] = to;
1928 
1929         emit Transfer(address(0), to, tokenId);
1930     }
1931 
1932     /**
1933      * @dev Destroys `tokenId`.
1934      * The approval is cleared when the token is burned.
1935      *
1936      * Requirements:
1937      *
1938      * - `tokenId` must exist.
1939      *
1940      * Emits a {Transfer} event.
1941      */
1942     function _burn(uint256 tokenId) internal virtual {
1943         address owner = ERC721.ownerOf(tokenId);
1944 
1945         _beforeTokenTransfer(owner, address(0), tokenId);
1946 
1947         // Clear approvals
1948         _approve(address(0), tokenId);
1949 
1950         _balances[owner] -= 1;
1951         delete _owners[tokenId];
1952 
1953         emit Transfer(owner, address(0), tokenId);
1954     }
1955 
1956     /**
1957      * @dev Transfers `tokenId` from `from` to `to`.
1958      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1959      *
1960      * Requirements:
1961      *
1962      * - `to` cannot be the zero address.
1963      * - `tokenId` token must be owned by `from`.
1964      *
1965      * Emits a {Transfer} event.
1966      */
1967     function _transfer(
1968         address from,
1969         address to,
1970         uint256 tokenId
1971     ) internal virtual {
1972         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1973         require(to != address(0), "ERC721: transfer to the zero address");
1974 
1975         _beforeTokenTransfer(from, to, tokenId);
1976 
1977         // Clear approvals from the previous owner
1978         _approve(address(0), tokenId);
1979 
1980         _balances[from] -= 1;
1981         _balances[to] += 1;
1982         _owners[tokenId] = to;
1983 
1984         emit Transfer(from, to, tokenId);
1985     }
1986 
1987     /**
1988      * @dev Approve `to` to operate on `tokenId`
1989      *
1990      * Emits a {Approval} event.
1991      */
1992     function _approve(address to, uint256 tokenId) internal virtual {
1993         _tokenApprovals[tokenId] = to;
1994         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1995     }
1996 
1997     /**
1998      * @dev Approve `operator` to operate on all of `owner` tokens
1999      *
2000      * Emits a {ApprovalForAll} event.
2001      */
2002     function _setApprovalForAll(
2003         address owner,
2004         address operator,
2005         bool approved
2006     ) internal virtual {
2007         require(owner != operator, "ERC721: approve to caller");
2008         _operatorApprovals[owner][operator] = approved;
2009         emit ApprovalForAll(owner, operator, approved);
2010     }
2011 
2012     /**
2013      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2014      * The call is not executed if the target address is not a contract.
2015      *
2016      * @param from address representing the previous owner of the given token ID
2017      * @param to target address that will receive the tokens
2018      * @param tokenId uint256 ID of the token to be transferred
2019      * @param _data bytes optional data to send along with the call
2020      * @return bool whether the call correctly returned the expected magic value
2021      */
2022     function _checkOnERC721Received(
2023         address from,
2024         address to,
2025         uint256 tokenId,
2026         bytes memory _data
2027     ) private returns (bool) {
2028         if (to.isContract()) {
2029             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2030                 return retval == IERC721Receiver.onERC721Received.selector;
2031             } catch (bytes memory reason) {
2032                 if (reason.length == 0) {
2033                     revert("ERC721: transfer to non ERC721Receiver implementer");
2034                 } else {
2035                     assembly {
2036                         revert(add(32, reason), mload(reason))
2037                     }
2038                 }
2039             }
2040         } else {
2041             return true;
2042         }
2043     }
2044 
2045     /**
2046      * @dev Hook that is called before any token transfer. This includes minting
2047      * and burning.
2048      *
2049      * Calling conditions:
2050      *
2051      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2052      * transferred to `to`.
2053      * - When `from` is zero, `tokenId` will be minted for `to`.
2054      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2055      * - `from` and `to` are never both zero.
2056      *
2057      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2058      */
2059     function _beforeTokenTransfer(
2060         address from,
2061         address to,
2062         uint256 tokenId
2063     ) internal virtual {}
2064 }
2065 
2066 
2067 // File contracts/ADW.sol
2068 
2069 
2070 pragma solidity ^0.8.0;
2071 
2072 
2073 
2074 
2075 
2076 
2077 contract ADW is Ownable, ERC721A, ReentrancyGuard {
2078     using SafeMath for uint256;
2079 
2080     uint256 public immutable maxPerAddressDuringMint;
2081     uint256 public immutable MAX_AMOUNT;
2082     bytes32 public merkleRoot;
2083 
2084     mapping(address => uint8) public mintedWhitelist;
2085     mapping(address => bool) public mintedSharedToken;
2086 
2087     uint256 public constant NFTPrice = 0.088 ether;
2088 
2089     bool public saleIsActive = false;
2090     bool public isWhitelistActive = false;
2091     bool public isSharedHolderSaleActive = false;
2092 
2093     uint8 public availableTokensPerWhitelist = 2;
2094 
2095     address public SAN_WALLET = 0x503FB544782414D47b913a47a44d8385152fB8f2;
2096     address devWallet = 0x38c0245C7C67576d1E73f3A11c6af76fE8d11dEA;
2097     address potOfGold = 0xCE811655776fcADC3d341B63090fd78a92F915A1;
2098     address artWallet = 0x1779B02A06DbFD6Aaead120136F1AB34eCc8f27D;
2099     address mktWallet = 0xC4f574cDB4cE0a7d80191A7f18c95D18e42bd2dC;
2100     address musicWallet = 0x823291ecb3f4258122035b9E642599D7cf6e15f1;
2101     address jeremyWallet = 0xDDD10aa3F06cc45a2b8d9F91FA74EDeb72aB8f8A;
2102     address copyWallet = 0x101d40C4A9242Bebb07Bb0F34deDa6F2b764450B;
2103 
2104     constructor(
2105         bytes32 merkleRoot_
2106     ) ERC721A("AdWorld Season 1", "ADW01") {
2107         MAX_AMOUNT = 3333;
2108         maxPerAddressDuringMint = 10;
2109         merkleRoot = merkleRoot_;
2110     }
2111 
2112     function mintSan() public onlyOwner {
2113         require(!_exists(0), "Token #0 has already been minted.");
2114         _safeMint(SAN_WALLET, 1);
2115     }
2116 
2117     function mintReserveTokens(uint256 numberOfTokens) public onlyOwner {
2118         require(_exists(0), "Mint San's token first");
2119         _safeMint(msg.sender, numberOfTokens);
2120         require(totalSupply() <= MAX_AMOUNT, "Limit reached");
2121 
2122     }
2123 
2124     function whitelistMint(
2125         bytes32[] calldata _merkleProof,
2126         uint8 numberOfTokens
2127     ) external payable {
2128         require(isWhitelistActive, "Whitelist is not active");
2129         require(
2130             NFTPrice.mul(numberOfTokens) <= msg.value,
2131             "Ether value sent is not correct"
2132         );
2133 
2134         uint8 mintedSoFar = mintedWhitelist[msg.sender] + numberOfTokens;
2135         require(mintedSoFar <= availableTokensPerWhitelist, "You can't mint that many");
2136 
2137         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2138         require(
2139             MerkleProof.verify(_merkleProof, merkleRoot, leaf) == true,
2140             "Incorrect Merkle Proof"
2141         );
2142 
2143         mintedWhitelist[msg.sender] = mintedSoFar;
2144 
2145         _safeMint(msg.sender, numberOfTokens);
2146         
2147         require(totalSupply() <= MAX_AMOUNT, "Limit reached");
2148     }
2149 
2150     function mintNFTAsSharedOwner() public payable {
2151         require(isSharedHolderSaleActive, "Sale must be active to mint a samskara");
2152         require(NFTPrice <= msg.value, "Ether value sent is not correct");
2153         require(
2154             isSharedOwner(msg.sender),
2155             "This wallet does not contain the right NFTs."
2156         );
2157 
2158         require(mintedSharedToken[msg.sender] == false, "You can't mint that many");
2159         mintedSharedToken[msg.sender] = true;
2160 
2161         _safeMint(msg.sender, 1);
2162 
2163         require(totalSupply() <= MAX_AMOUNT, "Limit reached");
2164     }
2165 
2166     function mintNFT(uint256 numberOfTokens) public payable {
2167         require(saleIsActive, "Sale must be active to mint a samskara");
2168         require(
2169             numberOfTokens <= maxPerAddressDuringMint,
2170             "You can't mint that many at once"
2171         );
2172         require(
2173             NFTPrice.mul(numberOfTokens) <= msg.value,
2174             "Ether value sent is not correct"
2175         );
2176 
2177         _safeMint(msg.sender, numberOfTokens);
2178 
2179         require(totalSupply() <= MAX_AMOUNT, "Limit reached");
2180     }
2181 
2182     function flipSaleState() public onlyOwner {
2183         require(_exists(0), "Mint San's token first");
2184         saleIsActive = !saleIsActive;
2185     }
2186     function flipWhitelistState() public onlyOwner {
2187         require(_exists(0), "Mint San's token first");
2188         isWhitelistActive = !isWhitelistActive;
2189     }
2190     function flipSharedHolderState() public onlyOwner {
2191         require(_exists(0), "Mint San's token first");
2192         isSharedHolderSaleActive = !isSharedHolderSaleActive;
2193     }
2194 
2195     function isSharedOwner(address addr) public view returns (bool) {
2196         address milady = 0x5Af0D9827E0c53E4799BB226655A1de152A425a5;
2197         address creature = 0xc92cedDfb8dd984A89fb494c376f9A48b999aAFc;
2198         address corruptions = 0x5BDf397bB2912859Dbd8011F320a222f79A28d2E;
2199         address azuki = 0xED5AF388653567Af2F388E6224dC7C4b3241C544;
2200         address arpeggi = 0xD614E3b775B94794ea16a7843F31a56c36EDCb09;
2201         address tubby = 0xCa7cA7BcC765F77339bE2d648BA53ce9c8a262bD;
2202         address pixelmon = 0x32973908FaeE0Bf825A343000fE412ebE56F802A;
2203         address seals = 0x364C828eE171616a39897688A831c2499aD972ec;
2204         return
2205             ERC721(milady).balanceOf(addr) > 0 ||
2206             ERC721(creature).balanceOf(addr) > 0 ||
2207             ERC721(corruptions).balanceOf(addr) > 0 ||
2208             ERC721(azuki).balanceOf(addr) > 0 ||
2209             ERC721(arpeggi).balanceOf(addr) > 0 ||
2210             ERC721(milady).balanceOf(addr) > 0 ||
2211             ERC721(tubby).balanceOf(addr) > 0 || 
2212             ERC721(pixelmon).balanceOf(addr) > 0 || 
2213             ERC721(seals).balanceOf(addr) > 0;
2214     }
2215 
2216     // // metadata URI
2217     string private _baseTokenURI;
2218 
2219     function _baseURI() internal view virtual override returns (string memory) {
2220         return _baseTokenURI;
2221     }
2222 
2223     function setBaseURI(string calldata baseURI) external onlyOwner {
2224         _baseTokenURI = baseURI;
2225     }
2226 
2227     function setMerkleRoot(bytes32 merkleRoot_) external onlyOwner {
2228         merkleRoot = merkleRoot_;
2229     }
2230 
2231     function withdrawMoney() external onlyOwner nonReentrant {
2232         (bool success, ) = msg.sender.call{value: address(this).balance}("");
2233         require(success, "Transfer failed.");
2234     }
2235 
2236     function numberMinted(address owner) public view returns (uint256) {
2237         return _numberMinted(owner);
2238     }
2239 
2240     function getOwnershipData(uint256 tokenId)
2241         external
2242         view
2243         returns (TokenOwnership memory)
2244     {
2245         return ownershipOf(tokenId);
2246     }
2247 
2248     function withdrawAll() public payable onlyOwner {
2249         uint256 gold = (address(this).balance * 10000) / 100000; 
2250         uint256 san = (address(this).balance * 17000) / 100000; 
2251         uint256 dev = (address(this).balance * 16640) / 100000; 
2252         uint256 art = (address(this).balance * 14400) / 100000; 
2253         uint256 music = (address(this).balance * 11400) / 100000; 
2254         uint256 jer = (address(this).balance *  8000) / 100000; 
2255         uint256 copy = (address(this).balance *  2500) / 100000; 
2256         uint256 mktAndTreasury = (address(this).balance * 20060) / 100000; 
2257         
2258         // 10000 + 17000 + 16640 + 14400 + 11400 + 8000 + 2500 + 20060
2259 
2260         require(payable(potOfGold).send(gold));
2261         require(payable(SAN_WALLET).send(san));
2262         require(payable(devWallet).send(dev));
2263         require(payable(artWallet).send(art));
2264         require(payable(musicWallet).send(music));
2265         require(payable(jeremyWallet).send(jer));
2266         require(payable(copyWallet).send(copy));
2267         require(payable(mktWallet).send(mktAndTreasury));
2268     }
2269 }