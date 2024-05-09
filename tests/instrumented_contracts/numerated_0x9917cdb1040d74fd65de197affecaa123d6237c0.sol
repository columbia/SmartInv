1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Contract module that helps prevent reentrant calls to a function.
11  *
12  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
13  * available, which can be applied to functions to make sure there are no nested
14  * (reentrant) calls to them.
15  *
16  * Note that because there is a single `nonReentrant` guard, functions marked as
17  * `nonReentrant` may not call one another. This can be worked around by making
18  * those functions `private`, and then adding `external` `nonReentrant` entry
19  * points to them.
20  *
21  * TIP: If you would like to learn more about reentrancy and alternative ways
22  * to protect against it, check out our blog post
23  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
24  */
25 abstract contract ReentrancyGuard {
26     // Booleans are more expensive than uint256 or any type that takes up a full
27     // word because each write operation emits an extra SLOAD to first read the
28     // slot's contents, replace the bits taken up by the boolean, and then write
29     // back. This is the compiler's defense against contract upgrades and
30     // pointer aliasing, and it cannot be disabled.
31 
32     // The values being non-zero value makes deployment a bit more expensive,
33     // but in exchange the refund on every call to nonReentrant will be lower in
34     // amount. Since refunds are capped to a percentage of the total
35     // transaction's gas, it is best to keep them low in cases like this one, to
36     // increase the likelihood of the full refund coming into effect.
37     uint256 private constant _NOT_ENTERED = 1;
38     uint256 private constant _ENTERED = 2;
39 
40     uint256 private _status;
41 
42     constructor() {
43         _status = _NOT_ENTERED;
44     }
45 
46     /**
47      * @dev Prevents a contract from calling itself, directly or indirectly.
48      * Calling a `nonReentrant` function from another `nonReentrant`
49      * function is not supported. It is possible to prevent this from happening
50      * by making the `nonReentrant` function external, and making it call a
51      * `private` function that does the actual work.
52      */
53     modifier nonReentrant() {
54         // On the first call to nonReentrant, _notEntered will be true
55         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
56 
57         // Any calls to nonReentrant after this point will fail
58         _status = _ENTERED;
59 
60         _;
61 
62         // By storing the original value once again, a refund is triggered (see
63         // https://eips.ethereum.org/EIPS/eip-2200)
64         _status = _NOT_ENTERED;
65     }
66 }
67 
68 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
69 
70 pragma solidity ^0.8.0;
71 
72 /**
73  * @dev String operations.
74  */
75 library Strings {
76     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
77 
78     /**
79      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
80      */
81     function toString(uint256 value) internal pure returns (string memory) {
82         // Inspired by OraclizeAPI's implementation - MIT licence
83         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
84 
85         if (value == 0) {
86             return "0";
87         }
88         uint256 temp = value;
89         uint256 digits;
90         while (temp != 0) {
91             digits++;
92             temp /= 10;
93         }
94         bytes memory buffer = new bytes(digits);
95         while (value != 0) {
96             digits -= 1;
97             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
98             value /= 10;
99         }
100         return string(buffer);
101     }
102 
103     /**
104      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
105      */
106     function toHexString(uint256 value) internal pure returns (string memory) {
107         if (value == 0) {
108             return "0x00";
109         }
110         uint256 temp = value;
111         uint256 length = 0;
112         while (temp != 0) {
113             length++;
114             temp >>= 8;
115         }
116         return toHexString(value, length);
117     }
118 
119     /**
120      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
121      */
122     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
123         bytes memory buffer = new bytes(2 * length + 2);
124         buffer[0] = "0";
125         buffer[1] = "x";
126         for (uint256 i = 2 * length + 1; i > 1; --i) {
127             buffer[i] = _HEX_SYMBOLS[value & 0xf];
128             value >>= 4;
129         }
130         require(value == 0, "Strings: hex length insufficient");
131         return string(buffer);
132     }
133 }
134 
135 // File: @openzeppelin/contracts/utils/Context.sol
136 
137 
138 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
139 
140 pragma solidity ^0.8.0;
141 
142 /**
143  * @dev Provides information about the current execution context, including the
144  * sender of the transaction and its data. While these are generally available
145  * via msg.sender and msg.data, they should not be accessed in such a direct
146  * manner, since when dealing with meta-transactions the account sending and
147  * paying for execution may not be the actual sender (as far as an application
148  * is concerned).
149  *
150  * This contract is only required for intermediate, library-like contracts.
151  */
152 abstract contract Context {
153     function _msgSender() internal view virtual returns (address) {
154         return msg.sender;
155     }
156 
157     function _msgData() internal view virtual returns (bytes calldata) {
158         return msg.data;
159     }
160 }
161 
162 // File: @openzeppelin/contracts/access/Ownable.sol
163 
164 
165 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
166 
167 pragma solidity ^0.8.0;
168 
169 
170 /**
171  * @dev Contract module which provides a basic access control mechanism, where
172  * there is an account (an owner) that can be granted exclusive access to
173  * specific functions.
174  *
175  * By default, the owner account will be the one that deploys the contract. This
176  * can later be changed with {transferOwnership}.
177  *
178  * This module is used through inheritance. It will make available the modifier
179  * `onlyOwner`, which can be applied to your functions to restrict their use to
180  * the owner.
181  */
182 abstract contract Ownable is Context {
183     address private _owner;
184 
185     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
186 
187     /**
188      * @dev Initializes the contract setting the deployer as the initial owner.
189      */
190     constructor() {
191         _transferOwnership(_msgSender());
192     }
193 
194     /**
195      * @dev Returns the address of the current owner.
196      */
197     function owner() public view virtual returns (address) {
198         return _owner;
199     }
200 
201     /**
202      * @dev Throws if called by any account other than the owner.
203      */
204     modifier onlyOwner() {
205         require(owner() == _msgSender(), "Ownable: caller is not the owner");
206         _;
207     }
208 
209     /**
210      * @dev Leaves the contract without owner. It will not be possible to call
211      * `onlyOwner` functions anymore. Can only be called by the current owner.
212      *
213      * NOTE: Renouncing ownership will leave the contract without an owner,
214      * thereby removing any functionality that is only available to the owner.
215      */
216     function renounceOwnership() public virtual onlyOwner {
217         _transferOwnership(address(0));
218     }
219 
220     /**
221      * @dev Transfers ownership of the contract to a new account (`newOwner`).
222      * Can only be called by the current owner.
223      */
224     function transferOwnership(address newOwner) public virtual onlyOwner {
225         require(newOwner != address(0), "Ownable: new owner is the zero address");
226         _transferOwnership(newOwner);
227     }
228 
229     /**
230      * @dev Transfers ownership of the contract to a new account (`newOwner`).
231      * Internal function without access restriction.
232      */
233     function _transferOwnership(address newOwner) internal virtual {
234         address oldOwner = _owner;
235         _owner = newOwner;
236         emit OwnershipTransferred(oldOwner, newOwner);
237     }
238 }
239 
240 // File: @openzeppelin/contracts/utils/Address.sol
241 
242 
243 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
244 
245 pragma solidity ^0.8.1;
246 
247 /**
248  * @dev Collection of functions related to the address type
249  */
250 library Address {
251     /**
252      * @dev Returns true if `account` is a contract.
253      *
254      * [IMPORTANT]
255      * ====
256      * It is unsafe to assume that an address for which this function returns
257      * false is an externally-owned account (EOA) and not a contract.
258      *
259      * Among others, `isContract` will return false for the following
260      * types of addresses:
261      *
262      *  - an externally-owned account
263      *  - a contract in construction
264      *  - an address where a contract will be created
265      *  - an address where a contract lived, but was destroyed
266      * ====
267      *
268      * [IMPORTANT]
269      * ====
270      * You shouldn't rely on `isContract` to protect against flash loan attacks!
271      *
272      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
273      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
274      * constructor.
275      * ====
276      */
277     function isContract(address account) internal view returns (bool) {
278         // This method relies on extcodesize/address.code.length, which returns 0
279         // for contracts in construction, since the code is only stored at the end
280         // of the constructor execution.
281 
282         return account.code.length > 0;
283     }
284 
285     /**
286      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
287      * `recipient`, forwarding all available gas and reverting on errors.
288      *
289      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
290      * of certain opcodes, possibly making contracts go over the 2300 gas limit
291      * imposed by `transfer`, making them unable to receive funds via
292      * `transfer`. {sendValue} removes this limitation.
293      *
294      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
295      *
296      * IMPORTANT: because control is transferred to `recipient`, care must be
297      * taken to not create reentrancy vulnerabilities. Consider using
298      * {ReentrancyGuard} or the
299      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
300      */
301     function sendValue(address payable recipient, uint256 amount) internal {
302         require(address(this).balance >= amount, "Address: insufficient balance");
303 
304         (bool success, ) = recipient.call{value: amount}("");
305         require(success, "Address: unable to send value, recipient may have reverted");
306     }
307 
308     /**
309      * @dev Performs a Solidity function call using a low level `call`. A
310      * plain `call` is an unsafe replacement for a function call: use this
311      * function instead.
312      *
313      * If `target` reverts with a revert reason, it is bubbled up by this
314      * function (like regular Solidity function calls).
315      *
316      * Returns the raw returned data. To convert to the expected return value,
317      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
318      *
319      * Requirements:
320      *
321      * - `target` must be a contract.
322      * - calling `target` with `data` must not revert.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
327         return functionCall(target, data, "Address: low-level call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
332      * `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(
337         address target,
338         bytes memory data,
339         string memory errorMessage
340     ) internal returns (bytes memory) {
341         return functionCallWithValue(target, data, 0, errorMessage);
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346      * but also transferring `value` wei to `target`.
347      *
348      * Requirements:
349      *
350      * - the calling contract must have an ETH balance of at least `value`.
351      * - the called Solidity function must be `payable`.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(
356         address target,
357         bytes memory data,
358         uint256 value
359     ) internal returns (bytes memory) {
360         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
365      * with `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(
370         address target,
371         bytes memory data,
372         uint256 value,
373         string memory errorMessage
374     ) internal returns (bytes memory) {
375         require(address(this).balance >= value, "Address: insufficient balance for call");
376         require(isContract(target), "Address: call to non-contract");
377 
378         (bool success, bytes memory returndata) = target.call{value: value}(data);
379         return verifyCallResult(success, returndata, errorMessage);
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
384      * but performing a static call.
385      *
386      * _Available since v3.3._
387      */
388     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
389         return functionStaticCall(target, data, "Address: low-level static call failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
394      * but performing a static call.
395      *
396      * _Available since v3.3._
397      */
398     function functionStaticCall(
399         address target,
400         bytes memory data,
401         string memory errorMessage
402     ) internal view returns (bytes memory) {
403         require(isContract(target), "Address: static call to non-contract");
404 
405         (bool success, bytes memory returndata) = target.staticcall(data);
406         return verifyCallResult(success, returndata, errorMessage);
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
411      * but performing a delegate call.
412      *
413      * _Available since v3.4._
414      */
415     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
416         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
421      * but performing a delegate call.
422      *
423      * _Available since v3.4._
424      */
425     function functionDelegateCall(
426         address target,
427         bytes memory data,
428         string memory errorMessage
429     ) internal returns (bytes memory) {
430         require(isContract(target), "Address: delegate call to non-contract");
431 
432         (bool success, bytes memory returndata) = target.delegatecall(data);
433         return verifyCallResult(success, returndata, errorMessage);
434     }
435 
436     /**
437      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
438      * revert reason using the provided one.
439      *
440      * _Available since v4.3._
441      */
442     function verifyCallResult(
443         bool success,
444         bytes memory returndata,
445         string memory errorMessage
446     ) internal pure returns (bytes memory) {
447         if (success) {
448             return returndata;
449         } else {
450             // Look for revert reason and bubble it up if present
451             if (returndata.length > 0) {
452                 // The easiest way to bubble the revert reason is using memory via assembly
453 
454                 assembly {
455                     let returndata_size := mload(returndata)
456                     revert(add(32, returndata), returndata_size)
457                 }
458             } else {
459                 revert(errorMessage);
460             }
461         }
462     }
463 }
464 
465 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
466 
467 
468 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
469 
470 pragma solidity ^0.8.0;
471 
472 /**
473  * @title ERC721 token receiver interface
474  * @dev Interface for any contract that wants to support safeTransfers
475  * from ERC721 asset contracts.
476  */
477 interface IERC721Receiver {
478     /**
479      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
480      * by `operator` from `from`, this function is called.
481      *
482      * It must return its Solidity selector to confirm the token transfer.
483      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
484      *
485      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
486      */
487     function onERC721Received(
488         address operator,
489         address from,
490         uint256 tokenId,
491         bytes calldata data
492     ) external returns (bytes4);
493 }
494 
495 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
496 
497 
498 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 /**
503  * @dev Interface of the ERC165 standard, as defined in the
504  * https://eips.ethereum.org/EIPS/eip-165[EIP].
505  *
506  * Implementers can declare support of contract interfaces, which can then be
507  * queried by others ({ERC165Checker}).
508  *
509  * For an implementation, see {ERC165}.
510  */
511 interface IERC165 {
512     /**
513      * @dev Returns true if this contract implements the interface defined by
514      * `interfaceId`. See the corresponding
515      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
516      * to learn more about how these ids are created.
517      *
518      * This function call must use less than 30 000 gas.
519      */
520     function supportsInterface(bytes4 interfaceId) external view returns (bool);
521 }
522 
523 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
524 
525 
526 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
527 
528 pragma solidity ^0.8.0;
529 
530 
531 /**
532  * @dev Implementation of the {IERC165} interface.
533  *
534  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
535  * for the additional interface id that will be supported. For example:
536  *
537  * ```solidity
538  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
539  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
540  * }
541  * ```
542  *
543  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
544  */
545 abstract contract ERC165 is IERC165 {
546     /**
547      * @dev See {IERC165-supportsInterface}.
548      */
549     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
550         return interfaceId == type(IERC165).interfaceId;
551     }
552 }
553 
554 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
555 
556 
557 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
558 
559 pragma solidity ^0.8.0;
560 
561 
562 /**
563  * @dev Required interface of an ERC721 compliant contract.
564  */
565 interface IERC721 is IERC165 {
566     /**
567      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
568      */
569     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
570 
571     /**
572      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
573      */
574     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
575 
576     /**
577      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
578      */
579     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
580 
581     /**
582      * @dev Returns the number of tokens in ``owner``'s account.
583      */
584     function balanceOf(address owner) external view returns (uint256 balance);
585 
586     /**
587      * @dev Returns the owner of the `tokenId` token.
588      *
589      * Requirements:
590      *
591      * - `tokenId` must exist.
592      */
593     function ownerOf(uint256 tokenId) external view returns (address owner);
594 
595     /**
596      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
597      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
598      *
599      * Requirements:
600      *
601      * - `from` cannot be the zero address.
602      * - `to` cannot be the zero address.
603      * - `tokenId` token must exist and be owned by `from`.
604      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
605      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
606      *
607      * Emits a {Transfer} event.
608      */
609     function safeTransferFrom(
610         address from,
611         address to,
612         uint256 tokenId
613     ) external;
614 
615     /**
616      * @dev Transfers `tokenId` token from `from` to `to`.
617      *
618      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
619      *
620      * Requirements:
621      *
622      * - `from` cannot be the zero address.
623      * - `to` cannot be the zero address.
624      * - `tokenId` token must be owned by `from`.
625      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
626      *
627      * Emits a {Transfer} event.
628      */
629     function transferFrom(
630         address from,
631         address to,
632         uint256 tokenId
633     ) external;
634 
635     /**
636      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
637      * The approval is cleared when the token is transferred.
638      *
639      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
640      *
641      * Requirements:
642      *
643      * - The caller must own the token or be an approved operator.
644      * - `tokenId` must exist.
645      *
646      * Emits an {Approval} event.
647      */
648     function approve(address to, uint256 tokenId) external;
649 
650     /**
651      * @dev Returns the account approved for `tokenId` token.
652      *
653      * Requirements:
654      *
655      * - `tokenId` must exist.
656      */
657     function getApproved(uint256 tokenId) external view returns (address operator);
658 
659     /**
660      * @dev Approve or remove `operator` as an operator for the caller.
661      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
662      *
663      * Requirements:
664      *
665      * - The `operator` cannot be the caller.
666      *
667      * Emits an {ApprovalForAll} event.
668      */
669     function setApprovalForAll(address operator, bool _approved) external;
670 
671     /**
672      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
673      *
674      * See {setApprovalForAll}
675      */
676     function isApprovedForAll(address owner, address operator) external view returns (bool);
677 
678     /**
679      * @dev Safely transfers `tokenId` token from `from` to `to`.
680      *
681      * Requirements:
682      *
683      * - `from` cannot be the zero address.
684      * - `to` cannot be the zero address.
685      * - `tokenId` token must exist and be owned by `from`.
686      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
687      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
688      *
689      * Emits a {Transfer} event.
690      */
691     function safeTransferFrom(
692         address from,
693         address to,
694         uint256 tokenId,
695         bytes calldata data
696     ) external;
697 }
698 
699 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
700 
701 
702 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
703 
704 pragma solidity ^0.8.0;
705 
706 
707 /**
708  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
709  * @dev See https://eips.ethereum.org/EIPS/eip-721
710  */
711 interface IERC721Enumerable is IERC721 {
712     /**
713      * @dev Returns the total amount of tokens stored by the contract.
714      */
715     function totalSupply() external view returns (uint256);
716 
717     /**
718      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
719      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
720      */
721     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
722 
723     /**
724      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
725      * Use along with {totalSupply} to enumerate all tokens.
726      */
727     function tokenByIndex(uint256 index) external view returns (uint256);
728 }
729 
730 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
731 
732 
733 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
734 
735 pragma solidity ^0.8.0;
736 
737 
738 /**
739  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
740  * @dev See https://eips.ethereum.org/EIPS/eip-721
741  */
742 interface IERC721Metadata is IERC721 {
743     /**
744      * @dev Returns the token collection name.
745      */
746     function name() external view returns (string memory);
747 
748     /**
749      * @dev Returns the token collection symbol.
750      */
751     function symbol() external view returns (string memory);
752 
753     /**
754      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
755      */
756     function tokenURI(uint256 tokenId) external view returns (string memory);
757 }
758 
759 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
760 
761 
762 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
763 
764 pragma solidity ^0.8.0;
765 
766 /**
767  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
768  * the Metadata extension, but not including the Enumerable extension, which is available separately as
769  * {ERC721Enumerable}.
770  */
771 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
772     using Address for address;
773     using Strings for uint256;
774 
775     // Token name
776     string private _name;
777 
778     // Token symbol
779     string private _symbol;
780 
781     // Mapping from token ID to owner address
782     mapping(uint256 => address) private _owners;
783 
784     // Mapping owner address to token count
785     mapping(address => uint256) private _balances;
786 
787     // Mapping from token ID to approved address
788     mapping(uint256 => address) private _tokenApprovals;
789 
790     // Mapping from owner to operator approvals
791     mapping(address => mapping(address => bool)) private _operatorApprovals;
792 
793     /**
794      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
795      */
796     constructor(string memory name_, string memory symbol_) {
797         _name = name_;
798         _symbol = symbol_;
799     }
800 
801     /**
802      * @dev See {IERC165-supportsInterface}.
803      */
804     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
805         return
806             interfaceId == type(IERC721).interfaceId ||
807             interfaceId == type(IERC721Metadata).interfaceId ||
808             super.supportsInterface(interfaceId);
809     }
810 
811     /**
812      * @dev See {IERC721-balanceOf}.
813      */
814     function balanceOf(address owner) public view virtual override returns (uint256) {
815         require(owner != address(0), "ERC721: balance query for the zero address");
816         return _balances[owner];
817     }
818 
819     /**
820      * @dev See {IERC721-ownerOf}.
821      */
822     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
823         address owner = _owners[tokenId];
824         require(owner != address(0), "ERC721: owner query for nonexistent token");
825         return owner;
826     }
827 
828     /**
829      * @dev See {IERC721Metadata-name}.
830      */
831     function name() public view virtual override returns (string memory) {
832         return _name;
833     }
834 
835     /**
836      * @dev See {IERC721Metadata-symbol}.
837      */
838     function symbol() public view virtual override returns (string memory) {
839         return _symbol;
840     }
841 
842     /**
843      * @dev See {IERC721Metadata-tokenURI}.
844      */
845     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
846         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
847 
848         string memory baseURI = _baseURI();
849         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
850     }
851 
852     /**
853      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
854      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
855      * by default, can be overriden in child contracts.
856      */
857     function _baseURI() internal view virtual returns (string memory) {
858         return "";
859     }
860 
861     /**
862      * @dev See {IERC721-approve}.
863      */
864     function approve(address to, uint256 tokenId) public virtual override {
865         address owner = ERC721.ownerOf(tokenId);
866         require(to != owner, "ERC721: approval to current owner");
867 
868         require(
869             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
870             "ERC721: approve caller is not owner nor approved for all"
871         );
872 
873         _approve(to, tokenId);
874     }
875 
876     /**
877      * @dev See {IERC721-getApproved}.
878      */
879     function getApproved(uint256 tokenId) public view virtual override returns (address) {
880         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
881 
882         return _tokenApprovals[tokenId];
883     }
884 
885     /**
886      * @dev See {IERC721-setApprovalForAll}.
887      */
888     function setApprovalForAll(address operator, bool approved) public virtual override {
889         _setApprovalForAll(_msgSender(), operator, approved);
890     }
891 
892     /**
893      * @dev See {IERC721-isApprovedForAll}.
894      */
895     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
896         return _operatorApprovals[owner][operator];
897     }
898 
899     /**
900      * @dev See {IERC721-transferFrom}.
901      */
902     function transferFrom(
903         address from,
904         address to,
905         uint256 tokenId
906     ) public virtual override {
907         //solhint-disable-next-line max-line-length
908         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
909 
910         _transfer(from, to, tokenId);
911     }
912 
913     /**
914      * @dev See {IERC721-safeTransferFrom}.
915      */
916     function safeTransferFrom(
917         address from,
918         address to,
919         uint256 tokenId
920     ) public virtual override {
921         safeTransferFrom(from, to, tokenId, "");
922     }
923 
924     /**
925      * @dev See {IERC721-safeTransferFrom}.
926      */
927     function safeTransferFrom(
928         address from,
929         address to,
930         uint256 tokenId,
931         bytes memory _data
932     ) public virtual override {
933         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
934         _safeTransfer(from, to, tokenId, _data);
935     }
936 
937     /**
938      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
939      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
940      *
941      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
942      *
943      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
944      * implement alternative mechanisms to perform token transfer, such as signature-based.
945      *
946      * Requirements:
947      *
948      * - `from` cannot be the zero address.
949      * - `to` cannot be the zero address.
950      * - `tokenId` token must exist and be owned by `from`.
951      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
952      *
953      * Emits a {Transfer} event.
954      */
955     function _safeTransfer(
956         address from,
957         address to,
958         uint256 tokenId,
959         bytes memory _data
960     ) internal virtual {
961         _transfer(from, to, tokenId);
962         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
963     }
964 
965     /**
966      * @dev Returns whether `tokenId` exists.
967      *
968      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
969      *
970      * Tokens start existing when they are minted (`_mint`),
971      * and stop existing when they are burned (`_burn`).
972      */
973     function _exists(uint256 tokenId) internal view virtual returns (bool) {
974         return _owners[tokenId] != address(0);
975     }
976 
977     /**
978      * @dev Returns whether `spender` is allowed to manage `tokenId`.
979      *
980      * Requirements:
981      *
982      * - `tokenId` must exist.
983      */
984     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
985         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
986         address owner = ERC721.ownerOf(tokenId);
987         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
988     }
989 
990     /**
991      * @dev Safely mints `tokenId` and transfers it to `to`.
992      *
993      * Requirements:
994      *
995      * - `tokenId` must not exist.
996      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
997      *
998      * Emits a {Transfer} event.
999      */
1000     function _safeMint(address to, uint256 tokenId) internal virtual {
1001         _safeMint(to, tokenId, "");
1002     }
1003 
1004     /**
1005      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1006      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1007      */
1008     function _safeMint(
1009         address to,
1010         uint256 tokenId,
1011         bytes memory _data
1012     ) internal virtual {
1013         _mint(to, tokenId);
1014         require(
1015             _checkOnERC721Received(address(0), to, tokenId, _data),
1016             "ERC721: transfer to non ERC721Receiver implementer"
1017         );
1018     }
1019 
1020     /**
1021      * @dev Mints `tokenId` and transfers it to `to`.
1022      *
1023      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1024      *
1025      * Requirements:
1026      *
1027      * - `tokenId` must not exist.
1028      * - `to` cannot be the zero address.
1029      *
1030      * Emits a {Transfer} event.
1031      */
1032     function _mint(address to, uint256 tokenId) internal virtual {
1033         require(to != address(0), "ERC721: mint to the zero address");
1034         require(!_exists(tokenId), "ERC721: token already minted");
1035 
1036         _beforeTokenTransfer(address(0), to, tokenId);
1037 
1038         _balances[to] += 1;
1039         _owners[tokenId] = to;
1040 
1041         emit Transfer(address(0), to, tokenId);
1042 
1043         _afterTokenTransfer(address(0), to, tokenId);
1044     }
1045 
1046     /**
1047      * @dev Destroys `tokenId`.
1048      * The approval is cleared when the token is burned.
1049      *
1050      * Requirements:
1051      *
1052      * - `tokenId` must exist.
1053      *
1054      * Emits a {Transfer} event.
1055      */
1056     function _burn(uint256 tokenId) internal virtual {
1057         address owner = ERC721.ownerOf(tokenId);
1058 
1059         _beforeTokenTransfer(owner, address(0), tokenId);
1060 
1061         // Clear approvals
1062         _approve(address(0), tokenId);
1063 
1064         _balances[owner] -= 1;
1065         delete _owners[tokenId];
1066 
1067         emit Transfer(owner, address(0), tokenId);
1068 
1069         _afterTokenTransfer(owner, address(0), tokenId);
1070     }
1071 
1072     /**
1073      * @dev Transfers `tokenId` from `from` to `to`.
1074      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1075      *
1076      * Requirements:
1077      *
1078      * - `to` cannot be the zero address.
1079      * - `tokenId` token must be owned by `from`.
1080      *
1081      * Emits a {Transfer} event.
1082      */
1083     function _transfer(
1084         address from,
1085         address to,
1086         uint256 tokenId
1087     ) internal virtual {
1088         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1089         require(to != address(0), "ERC721: transfer to the zero address");
1090 
1091         _beforeTokenTransfer(from, to, tokenId);
1092 
1093         // Clear approvals from the previous owner
1094         _approve(address(0), tokenId);
1095 
1096         _balances[from] -= 1;
1097         _balances[to] += 1;
1098         _owners[tokenId] = to;
1099 
1100         emit Transfer(from, to, tokenId);
1101 
1102         _afterTokenTransfer(from, to, tokenId);
1103     }
1104 
1105     /**
1106      * @dev Approve `to` to operate on `tokenId`
1107      *
1108      * Emits a {Approval} event.
1109      */
1110     function _approve(address to, uint256 tokenId) internal virtual {
1111         _tokenApprovals[tokenId] = to;
1112         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1113     }
1114 
1115     /**
1116      * @dev Approve `operator` to operate on all of `owner` tokens
1117      *
1118      * Emits a {ApprovalForAll} event.
1119      */
1120     function _setApprovalForAll(
1121         address owner,
1122         address operator,
1123         bool approved
1124     ) internal virtual {
1125         require(owner != operator, "ERC721: approve to caller");
1126         _operatorApprovals[owner][operator] = approved;
1127         emit ApprovalForAll(owner, operator, approved);
1128     }
1129 
1130     /**
1131      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1132      * The call is not executed if the target address is not a contract.
1133      *
1134      * @param from address representing the previous owner of the given token ID
1135      * @param to target address that will receive the tokens
1136      * @param tokenId uint256 ID of the token to be transferred
1137      * @param _data bytes optional data to send along with the call
1138      * @return bool whether the call correctly returned the expected magic value
1139      */
1140     function _checkOnERC721Received(
1141         address from,
1142         address to,
1143         uint256 tokenId,
1144         bytes memory _data
1145     ) private returns (bool) {
1146         if (to.isContract()) {
1147             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1148                 return retval == IERC721Receiver.onERC721Received.selector;
1149             } catch (bytes memory reason) {
1150                 if (reason.length == 0) {
1151                     revert("ERC721: transfer to non ERC721Receiver implementer");
1152                 } else {
1153                     assembly {
1154                         revert(add(32, reason), mload(reason))
1155                     }
1156                 }
1157             }
1158         } else {
1159             return true;
1160         }
1161     }
1162 
1163     /**
1164      * @dev Hook that is called before any token transfer. This includes minting
1165      * and burning.
1166      *
1167      * Calling conditions:
1168      *
1169      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1170      * transferred to `to`.
1171      * - When `from` is zero, `tokenId` will be minted for `to`.
1172      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1173      * - `from` and `to` are never both zero.
1174      *
1175      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1176      */
1177     function _beforeTokenTransfer(
1178         address from,
1179         address to,
1180         uint256 tokenId
1181     ) internal virtual {}
1182 
1183     /**
1184      * @dev Hook that is called after any transfer of tokens. This includes
1185      * minting and burning.
1186      *
1187      * Calling conditions:
1188      *
1189      * - when `from` and `to` are both non-zero.
1190      * - `from` and `to` are never both zero.
1191      *
1192      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1193      */
1194     function _afterTokenTransfer(
1195         address from,
1196         address to,
1197         uint256 tokenId
1198     ) internal virtual {}
1199 }
1200 
1201 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1202 
1203 
1204 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1205 
1206 pragma solidity ^0.8.0;
1207 
1208 
1209 
1210 /**
1211  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1212  * enumerability of all the token ids in the contract as well as all token ids owned by each
1213  * account.
1214  */
1215 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1216     // Mapping from owner to list of owned token IDs
1217     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1218 
1219     // Mapping from token ID to index of the owner tokens list
1220     mapping(uint256 => uint256) private _ownedTokensIndex;
1221 
1222     // Array with all token ids, used for enumeration
1223     uint256[] private _allTokens;
1224 
1225     // Mapping from token id to position in the allTokens array
1226     mapping(uint256 => uint256) private _allTokensIndex;
1227 
1228     /**
1229      * @dev See {IERC165-supportsInterface}.
1230      */
1231     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1232         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1233     }
1234 
1235     /**
1236      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1237      */
1238     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1239         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1240         return _ownedTokens[owner][index];
1241     }
1242 
1243     /**
1244      * @dev See {IERC721Enumerable-totalSupply}.
1245      */
1246     function totalSupply() public view virtual override returns (uint256) {
1247         return _allTokens.length;
1248     }
1249 
1250     /**
1251      * @dev See {IERC721Enumerable-tokenByIndex}.
1252      */
1253     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1254         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1255         return _allTokens[index];
1256     }
1257 
1258     /**
1259      * @dev Hook that is called before any token transfer. This includes minting
1260      * and burning.
1261      *
1262      * Calling conditions:
1263      *
1264      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1265      * transferred to `to`.
1266      * - When `from` is zero, `tokenId` will be minted for `to`.
1267      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1268      * - `from` cannot be the zero address.
1269      * - `to` cannot be the zero address.
1270      *
1271      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1272      */
1273     function _beforeTokenTransfer(
1274         address from,
1275         address to,
1276         uint256 tokenId
1277     ) internal virtual override {
1278         super._beforeTokenTransfer(from, to, tokenId);
1279 
1280         if (from == address(0)) {
1281             _addTokenToAllTokensEnumeration(tokenId);
1282         } else if (from != to) {
1283             _removeTokenFromOwnerEnumeration(from, tokenId);
1284         }
1285         if (to == address(0)) {
1286             _removeTokenFromAllTokensEnumeration(tokenId);
1287         } else if (to != from) {
1288             _addTokenToOwnerEnumeration(to, tokenId);
1289         }
1290     }
1291 
1292     /**
1293      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1294      * @param to address representing the new owner of the given token ID
1295      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1296      */
1297     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1298         uint256 length = ERC721.balanceOf(to);
1299         _ownedTokens[to][length] = tokenId;
1300         _ownedTokensIndex[tokenId] = length;
1301     }
1302 
1303     /**
1304      * @dev Private function to add a token to this extension's token tracking data structures.
1305      * @param tokenId uint256 ID of the token to be added to the tokens list
1306      */
1307     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1308         _allTokensIndex[tokenId] = _allTokens.length;
1309         _allTokens.push(tokenId);
1310     }
1311 
1312     /**
1313      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1314      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1315      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1316      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1317      * @param from address representing the previous owner of the given token ID
1318      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1319      */
1320     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1321         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1322         // then delete the last slot (swap and pop).
1323 
1324         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1325         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1326 
1327         // When the token to delete is the last token, the swap operation is unnecessary
1328         if (tokenIndex != lastTokenIndex) {
1329             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1330 
1331             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1332             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1333         }
1334 
1335         // This also deletes the contents at the last position of the array
1336         delete _ownedTokensIndex[tokenId];
1337         delete _ownedTokens[from][lastTokenIndex];
1338     }
1339 
1340     /**
1341      * @dev Private function to remove a token from this extension's token tracking data structures.
1342      * This has O(1) time complexity, but alters the order of the _allTokens array.
1343      * @param tokenId uint256 ID of the token to be removed from the tokens list
1344      */
1345     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1346         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1347         // then delete the last slot (swap and pop).
1348 
1349         uint256 lastTokenIndex = _allTokens.length - 1;
1350         uint256 tokenIndex = _allTokensIndex[tokenId];
1351 
1352         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1353         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1354         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1355         uint256 lastTokenId = _allTokens[lastTokenIndex];
1356 
1357         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1358         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1359 
1360         // This also deletes the contents at the last position of the array
1361         delete _allTokensIndex[tokenId];
1362         _allTokens.pop();
1363     }
1364 }
1365 
1366 /**
1367  * @dev Interface of an ERC721A compliant contract.
1368  */
1369 interface IERC721A is IERC721, IERC721Metadata {
1370     /**
1371      * The caller must own the token or be an approved operator.
1372      */
1373     error ApprovalCallerNotOwnerNorApproved();
1374 
1375     /**
1376      * The token does not exist.
1377      */
1378     error ApprovalQueryForNonexistentToken();
1379 
1380     /**
1381      * The caller cannot approve to their own address.
1382      */
1383     error ApproveToCaller();
1384 
1385     /**
1386      * The caller cannot approve to the current owner.
1387      */
1388     error ApprovalToCurrentOwner();
1389 
1390     /**
1391      * Cannot query the balance for the zero address.
1392      */
1393     error BalanceQueryForZeroAddress();
1394 
1395     /**
1396      * Cannot mint to the zero address.
1397      */
1398     error MintToZeroAddress();
1399 
1400     /**
1401      * The quantity of tokens minted must be more than zero.
1402      */
1403     error MintZeroQuantity();
1404 
1405     /**
1406      * The token does not exist.
1407      */
1408     error OwnerQueryForNonexistentToken();
1409 
1410     /**
1411      * The caller must own the token or be an approved operator.
1412      */
1413     error TransferCallerNotOwnerNorApproved();
1414 
1415     /**
1416      * The token must be owned by `from`.
1417      */
1418     error TransferFromIncorrectOwner();
1419 
1420     /**
1421      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
1422      */
1423     error TransferToNonERC721ReceiverImplementer();
1424 
1425     /**
1426      * Cannot transfer to the zero address.
1427      */
1428     error TransferToZeroAddress();
1429 
1430     /**
1431      * The token does not exist.
1432      */
1433     error URIQueryForNonexistentToken();
1434 
1435     // Compiler will pack this into a single 256bit word.
1436     struct TokenOwnership {
1437         // The address of the owner.
1438         address addr;
1439         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1440         uint64 startTimestamp;
1441         // Whether the token has been burned.
1442         bool burned;
1443     }
1444 
1445     // Compiler will pack this into a single 256bit word.
1446     struct AddressData {
1447         // Realistically, 2**64-1 is more than enough.
1448         uint64 balance;
1449         // Keeps track of mint count with minimal overhead for tokenomics.
1450         uint64 numberMinted;
1451         // Keeps track of burn count with minimal overhead for tokenomics.
1452         uint64 numberBurned;
1453         // For miscellaneous variable(s) pertaining to the address
1454         // (e.g. number of whitelist mint slots used).
1455         // If there are multiple variables, please pack them into a uint64.
1456         uint64 aux;
1457     }
1458 
1459     /**
1460      * @dev Returns the total amount of tokens stored by the contract.
1461      * 
1462      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
1463      */
1464     function totalSupply() external view returns (uint256);
1465 }
1466 
1467 /**
1468  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1469  * the Metadata extension. Built to optimize for lower gas during batch mints.
1470  *
1471  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1472  *
1473  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1474  *
1475  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1476  */
1477 contract ERC721A is Context, ERC165, IERC721A {
1478     using Address for address;
1479     using Strings for uint256;
1480 
1481     // The tokenId of the next token to be minted.
1482     uint256 internal _currentIndex;
1483 
1484     // The number of tokens burned.
1485     uint256 internal _burnCounter;
1486 
1487     // Token name
1488     string private _name;
1489 
1490     // Token symbol
1491     string private _symbol;
1492 
1493     // Mapping from token ID to ownership details
1494     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1495     mapping(uint256 => TokenOwnership) internal _ownerships;
1496 
1497     // Mapping owner address to address data
1498     mapping(address => AddressData) private _addressData;
1499 
1500     // Mapping from token ID to approved address
1501     mapping(uint256 => address) private _tokenApprovals;
1502 
1503     // Mapping from owner to operator approvals
1504     mapping(address => mapping(address => bool)) private _operatorApprovals;
1505 
1506     constructor(string memory name_, string memory symbol_) {
1507         _name = name_;
1508         _symbol = symbol_;
1509         _currentIndex = _startTokenId();
1510     }
1511 
1512     /**
1513      * To change the starting tokenId, please override this function.
1514      */
1515     function _startTokenId() internal view virtual returns (uint256) {
1516         return 0;
1517     }
1518 
1519     /**
1520      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1521      */
1522     function totalSupply() public view override returns (uint256) {
1523         // Counter underflow is impossible as _burnCounter cannot be incremented
1524         // more than _currentIndex - _startTokenId() times
1525         unchecked {
1526             return _currentIndex - _burnCounter - _startTokenId();
1527         }
1528     }
1529 
1530     /**
1531      * Returns the total amount of tokens minted in the contract.
1532      */
1533     function _totalMinted() internal view returns (uint256) {
1534         // Counter underflow is impossible as _currentIndex does not decrement,
1535         // and it is initialized to _startTokenId()
1536         unchecked {
1537             return _currentIndex - _startTokenId();
1538         }
1539     }
1540 
1541     /**
1542      * @dev See {IERC165-supportsInterface}.
1543      */
1544     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1545         return
1546             interfaceId == type(IERC721).interfaceId ||
1547             interfaceId == type(IERC721Metadata).interfaceId ||
1548             super.supportsInterface(interfaceId);
1549     }
1550 
1551     /**
1552      * @dev See {IERC721-balanceOf}.
1553      */
1554     function balanceOf(address owner) public view override returns (uint256) {
1555         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1556         return uint256(_addressData[owner].balance);
1557     }
1558 
1559     /**
1560      * Returns the number of tokens minted by `owner`.
1561      */
1562     function _numberMinted(address owner) internal view returns (uint256) {
1563         return uint256(_addressData[owner].numberMinted);
1564     }
1565 
1566     /**
1567      * Returns the number of tokens burned by or on behalf of `owner`.
1568      */
1569     function _numberBurned(address owner) internal view returns (uint256) {
1570         return uint256(_addressData[owner].numberBurned);
1571     }
1572 
1573     /**
1574      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1575      */
1576     function _getAux(address owner) internal view returns (uint64) {
1577         return _addressData[owner].aux;
1578     }
1579 
1580     /**
1581      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1582      * If there are multiple variables, please pack them into a uint64.
1583      */
1584     function _setAux(address owner, uint64 aux) internal {
1585         _addressData[owner].aux = aux;
1586     }
1587 
1588     /**
1589      * Gas spent here starts off proportional to the maximum mint batch size.
1590      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1591      */
1592     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1593         uint256 curr = tokenId;
1594 
1595         unchecked {
1596             if (_startTokenId() <= curr) if (curr < _currentIndex) {
1597                 TokenOwnership memory ownership = _ownerships[curr];
1598                 if (!ownership.burned) {
1599                     if (ownership.addr != address(0)) {
1600                         return ownership;
1601                     }
1602                     // Invariant:
1603                     // There will always be an ownership that has an address and is not burned
1604                     // before an ownership that does not have an address and is not burned.
1605                     // Hence, curr will not underflow.
1606                     while (true) {
1607                         curr--;
1608                         ownership = _ownerships[curr];
1609                         if (ownership.addr != address(0)) {
1610                             return ownership;
1611                         }
1612                     }
1613                 }
1614             }
1615         }
1616         revert OwnerQueryForNonexistentToken();
1617     }
1618 
1619     /**
1620      * @dev See {IERC721-ownerOf}.
1621      */
1622     function ownerOf(uint256 tokenId) public view override returns (address) {
1623         return _ownershipOf(tokenId).addr;
1624     }
1625 
1626     /**
1627      * @dev See {IERC721Metadata-name}.
1628      */
1629     function name() public view virtual override returns (string memory) {
1630         return _name;
1631     }
1632 
1633     /**
1634      * @dev See {IERC721Metadata-symbol}.
1635      */
1636     function symbol() public view virtual override returns (string memory) {
1637         return _symbol;
1638     }
1639 
1640     /**
1641      * @dev See {IERC721Metadata-tokenURI}.
1642      */
1643     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1644         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1645 
1646         string memory baseURI = _baseURI();
1647         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1648     }
1649 
1650     /**
1651      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1652      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1653      * by default, can be overriden in child contracts.
1654      */
1655     function _baseURI() internal view virtual returns (string memory) {
1656         return '';
1657     }
1658 
1659     /**
1660      * @dev See {IERC721-approve}.
1661      */
1662     function approve(address to, uint256 tokenId) public override {
1663         address owner = ERC721A.ownerOf(tokenId);
1664         if (to == owner) revert ApprovalToCurrentOwner();
1665 
1666         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1667             revert ApprovalCallerNotOwnerNorApproved();
1668         }
1669 
1670         _approve(to, tokenId, owner);
1671     }
1672 
1673     /**
1674      * @dev See {IERC721-getApproved}.
1675      */
1676     function getApproved(uint256 tokenId) public view override returns (address) {
1677         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1678 
1679         return _tokenApprovals[tokenId];
1680     }
1681 
1682     /**
1683      * @dev See {IERC721-setApprovalForAll}.
1684      */
1685     function setApprovalForAll(address operator, bool approved) public virtual override {
1686         if (operator == _msgSender()) revert ApproveToCaller();
1687 
1688         _operatorApprovals[_msgSender()][operator] = approved;
1689         emit ApprovalForAll(_msgSender(), operator, approved);
1690     }
1691 
1692     /**
1693      * @dev See {IERC721-isApprovedForAll}.
1694      */
1695     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1696         return _operatorApprovals[owner][operator];
1697     }
1698 
1699     /**
1700      * @dev See {IERC721-transferFrom}.
1701      */
1702     function transferFrom(
1703         address from,
1704         address to,
1705         uint256 tokenId
1706     ) public virtual override {
1707         _transfer(from, to, tokenId);
1708     }
1709 
1710     /**
1711      * @dev See {IERC721-safeTransferFrom}.
1712      */
1713     function safeTransferFrom(
1714         address from,
1715         address to,
1716         uint256 tokenId
1717     ) public virtual override {
1718         safeTransferFrom(from, to, tokenId, '');
1719     }
1720 
1721     /**
1722      * @dev See {IERC721-safeTransferFrom}.
1723      */
1724     function safeTransferFrom(
1725         address from,
1726         address to,
1727         uint256 tokenId,
1728         bytes memory _data
1729     ) public virtual override {
1730         _transfer(from, to, tokenId);
1731         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1732             revert TransferToNonERC721ReceiverImplementer();
1733         }
1734     }
1735 
1736     /**
1737      * @dev Returns whether `tokenId` exists.
1738      *
1739      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1740      *
1741      * Tokens start existing when they are minted (`_mint`),
1742      */
1743     function _exists(uint256 tokenId) internal view returns (bool) {
1744         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1745     }
1746 
1747     /**
1748      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1749      */
1750     function _safeMint(address to, uint256 quantity) internal {
1751         _safeMint(to, quantity, '');
1752     }
1753 
1754     /**
1755      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1756      *
1757      * Requirements:
1758      *
1759      * - If `to` refers to a smart contract, it must implement
1760      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1761      * - `quantity` must be greater than 0.
1762      *
1763      * Emits a {Transfer} event.
1764      */
1765     function _safeMint(
1766         address to,
1767         uint256 quantity,
1768         bytes memory _data
1769     ) internal {
1770         uint256 startTokenId = _currentIndex;
1771         if (to == address(0)) revert MintToZeroAddress();
1772         if (quantity == 0) revert MintZeroQuantity();
1773 
1774         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1775 
1776         // Overflows are incredibly unrealistic.
1777         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1778         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1779         unchecked {
1780             _addressData[to].balance += uint64(quantity);
1781             _addressData[to].numberMinted += uint64(quantity);
1782 
1783             _ownerships[startTokenId].addr = to;
1784             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1785 
1786             uint256 updatedIndex = startTokenId;
1787             uint256 end = updatedIndex + quantity;
1788 
1789             if (to.isContract()) {
1790                 do {
1791                     emit Transfer(address(0), to, updatedIndex);
1792                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1793                         revert TransferToNonERC721ReceiverImplementer();
1794                     }
1795                 } while (updatedIndex < end);
1796                 // Reentrancy protection
1797                 if (_currentIndex != startTokenId) revert();
1798             } else {
1799                 do {
1800                     emit Transfer(address(0), to, updatedIndex++);
1801                 } while (updatedIndex < end);
1802             }
1803             _currentIndex = updatedIndex;
1804         }
1805         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1806     }
1807 
1808     /**
1809      * @dev Mints `quantity` tokens and transfers them to `to`.
1810      *
1811      * Requirements:
1812      *
1813      * - `to` cannot be the zero address.
1814      * - `quantity` must be greater than 0.
1815      *
1816      * Emits a {Transfer} event.
1817      */
1818     function _mint(address to, uint256 quantity) internal {
1819         uint256 startTokenId = _currentIndex;
1820         if (to == address(0)) revert MintToZeroAddress();
1821         if (quantity == 0) revert MintZeroQuantity();
1822 
1823         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1824 
1825         // Overflows are incredibly unrealistic.
1826         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1827         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1828         unchecked {
1829             _addressData[to].balance += uint64(quantity);
1830             _addressData[to].numberMinted += uint64(quantity);
1831 
1832             _ownerships[startTokenId].addr = to;
1833             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1834 
1835             uint256 updatedIndex = startTokenId;
1836             uint256 end = updatedIndex + quantity;
1837 
1838             do {
1839                 emit Transfer(address(0), to, updatedIndex++);
1840             } while (updatedIndex < end);
1841 
1842             _currentIndex = updatedIndex;
1843         }
1844         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1845     }
1846 
1847     /**
1848      * @dev Transfers `tokenId` from `from` to `to`.
1849      *
1850      * Requirements:
1851      *
1852      * - `to` cannot be the zero address.
1853      * - `tokenId` token must be owned by `from`.
1854      *
1855      * Emits a {Transfer} event.
1856      */
1857     function _transfer(
1858         address from,
1859         address to,
1860         uint256 tokenId
1861     ) private {
1862         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1863 
1864         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1865 
1866         bool isApprovedOrOwner = (_msgSender() == from ||
1867             isApprovedForAll(from, _msgSender()) ||
1868             getApproved(tokenId) == _msgSender());
1869 
1870         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1871         if (to == address(0)) revert TransferToZeroAddress();
1872 
1873         _beforeTokenTransfers(from, to, tokenId, 1);
1874 
1875         // Clear approvals from the previous owner
1876         _approve(address(0), tokenId, from);
1877 
1878         // Underflow of the sender's balance is impossible because we check for
1879         // ownership above and the recipient's balance can't realistically overflow.
1880         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1881         unchecked {
1882             _addressData[from].balance -= 1;
1883             _addressData[to].balance += 1;
1884 
1885             TokenOwnership storage currSlot = _ownerships[tokenId];
1886             currSlot.addr = to;
1887             currSlot.startTimestamp = uint64(block.timestamp);
1888 
1889             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1890             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1891             uint256 nextTokenId = tokenId + 1;
1892             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1893             if (nextSlot.addr == address(0)) {
1894                 // This will suffice for checking _exists(nextTokenId),
1895                 // as a burned slot cannot contain the zero address.
1896                 if (nextTokenId != _currentIndex) {
1897                     nextSlot.addr = from;
1898                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1899                 }
1900             }
1901         }
1902 
1903         emit Transfer(from, to, tokenId);
1904         _afterTokenTransfers(from, to, tokenId, 1);
1905     }
1906 
1907     /**
1908      * @dev Equivalent to `_burn(tokenId, false)`.
1909      */
1910     function _burn(uint256 tokenId) internal virtual {
1911         _burn(tokenId, false);
1912     }
1913 
1914     /**
1915      * @dev Destroys `tokenId`.
1916      * The approval is cleared when the token is burned.
1917      *
1918      * Requirements:
1919      *
1920      * - `tokenId` must exist.
1921      *
1922      * Emits a {Transfer} event.
1923      */
1924     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1925         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1926 
1927         address from = prevOwnership.addr;
1928 
1929         if (approvalCheck) {
1930             bool isApprovedOrOwner = (_msgSender() == from ||
1931                 isApprovedForAll(from, _msgSender()) ||
1932                 getApproved(tokenId) == _msgSender());
1933 
1934             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1935         }
1936 
1937         _beforeTokenTransfers(from, address(0), tokenId, 1);
1938 
1939         // Clear approvals from the previous owner
1940         _approve(address(0), tokenId, from);
1941 
1942         // Underflow of the sender's balance is impossible because we check for
1943         // ownership above and the recipient's balance can't realistically overflow.
1944         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1945         unchecked {
1946             AddressData storage addressData = _addressData[from];
1947             addressData.balance -= 1;
1948             addressData.numberBurned += 1;
1949 
1950             // Keep track of who burned the token, and the timestamp of burning.
1951             TokenOwnership storage currSlot = _ownerships[tokenId];
1952             currSlot.addr = from;
1953             currSlot.startTimestamp = uint64(block.timestamp);
1954             currSlot.burned = true;
1955 
1956             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1957             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1958             uint256 nextTokenId = tokenId + 1;
1959             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1960             if (nextSlot.addr == address(0)) {
1961                 // This will suffice for checking _exists(nextTokenId),
1962                 // as a burned slot cannot contain the zero address.
1963                 if (nextTokenId != _currentIndex) {
1964                     nextSlot.addr = from;
1965                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1966                 }
1967             }
1968         }
1969 
1970         emit Transfer(from, address(0), tokenId);
1971         _afterTokenTransfers(from, address(0), tokenId, 1);
1972 
1973         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1974         unchecked {
1975             _burnCounter++;
1976         }
1977     }
1978 
1979     /**
1980      * @dev Approve `to` to operate on `tokenId`
1981      *
1982      * Emits a {Approval} event.
1983      */
1984     function _approve(
1985         address to,
1986         uint256 tokenId,
1987         address owner
1988     ) private {
1989         _tokenApprovals[tokenId] = to;
1990         emit Approval(owner, to, tokenId);
1991     }
1992 
1993     /**
1994      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1995      *
1996      * @param from address representing the previous owner of the given token ID
1997      * @param to target address that will receive the tokens
1998      * @param tokenId uint256 ID of the token to be transferred
1999      * @param _data bytes optional data to send along with the call
2000      * @return bool whether the call correctly returned the expected magic value
2001      */
2002     function _checkContractOnERC721Received(
2003         address from,
2004         address to,
2005         uint256 tokenId,
2006         bytes memory _data
2007     ) private returns (bool) {
2008         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2009             return retval == IERC721Receiver(to).onERC721Received.selector;
2010         } catch (bytes memory reason) {
2011             if (reason.length == 0) {
2012                 revert TransferToNonERC721ReceiverImplementer();
2013             } else {
2014                 assembly {
2015                     revert(add(32, reason), mload(reason))
2016                 }
2017             }
2018         }
2019     }
2020 
2021     /**
2022      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2023      * And also called before burning one token.
2024      *
2025      * startTokenId - the first token id to be transferred
2026      * quantity - the amount to be transferred
2027      *
2028      * Calling conditions:
2029      *
2030      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2031      * transferred to `to`.
2032      * - When `from` is zero, `tokenId` will be minted for `to`.
2033      * - When `to` is zero, `tokenId` will be burned by `from`.
2034      * - `from` and `to` are never both zero.
2035      */
2036     function _beforeTokenTransfers(
2037         address from,
2038         address to,
2039         uint256 startTokenId,
2040         uint256 quantity
2041     ) internal virtual {}
2042 
2043     /**
2044      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2045      * minting.
2046      * And also called after one token has been burned.
2047      *
2048      * startTokenId - the first token id to be transferred
2049      * quantity - the amount to be transferred
2050      *
2051      * Calling conditions:
2052      *
2053      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2054      * transferred to `to`.
2055      * - When `from` is zero, `tokenId` has been minted for `to`.
2056      * - When `to` is zero, `tokenId` has been burned by `from`.
2057      * - `from` and `to` are never both zero.
2058      */
2059     function _afterTokenTransfers(
2060         address from,
2061         address to,
2062         uint256 startTokenId,
2063         uint256 quantity
2064     ) internal virtual {}
2065 }
2066 
2067 
2068 contract AstroLandz is ERC721A, Ownable, ReentrancyGuard {
2069     using Strings for uint256;
2070 
2071     uint256 public maxTokensPerMint = 15;
2072     uint256 public presaleTokenPrice = 0.08 ether;
2073     uint256 public tokenPrice = 0.1 ether;
2074     string public tokenBaseURI = "ipfs:///";
2075 
2076     uint256 public teamTokensAmount = 500;
2077     uint256 public presaleTokensToBuyAmount = 1000;
2078     uint256 public tokensToBuyAmount = 10000 - teamTokensAmount - presaleTokensToBuyAmount;
2079     bool public hasSaleStarted = false;
2080     bool public hasPresaleStarted = false;
2081     bool public isBurnEnabled = false;
2082     //mapping(address => uint256) public publicSalePurchased;
2083 
2084     address public marketingWallet = 0x205B9FF43218dD51507969D0AE0b5B6386c2cb7a;
2085 
2086     constructor() ERC721A("AstroLandz", "ALZ") {
2087         _safeMint(marketingWallet, teamTokensAmount);
2088     }
2089 
2090     function _startTokenId() internal pure override(ERC721A) returns (uint256) {
2091         return 0;
2092     }
2093 
2094     function setTokenPrice(uint256 val) external onlyOwner {
2095         tokenPrice = val;
2096     }
2097 
2098     function setPresaleTokenPrice(uint256 val) external onlyOwner {
2099         presaleTokenPrice = val;
2100     }
2101 
2102     function setMaxTokensPerMint(uint256 val) external onlyOwner {
2103         maxTokensPerMint = val;
2104     }
2105 
2106     function startSale() external onlyOwner {
2107         hasSaleStarted = true;
2108     }
2109 
2110     function stopSale() external onlyOwner {
2111         hasSaleStarted = false;
2112     }
2113 
2114     function startPresale() external onlyOwner {
2115         hasPresaleStarted = true;
2116     }
2117 
2118     function stopPresale() external onlyOwner {
2119         hasPresaleStarted = false;
2120     }
2121 
2122     function enableBurn() external onlyOwner {
2123         isBurnEnabled = true;
2124     }
2125 
2126     function disableBurn() external onlyOwner {
2127         isBurnEnabled = false;
2128     }
2129 
2130     function mint(uint256 amount) external payable nonReentrant {
2131         require(hasSaleStarted || hasPresaleStarted, "Cannot mint before sale!");
2132         require(amount <= maxTokensPerMint, "Cannot mint more than the max tokens per mint");
2133 
2134         if (hasSaleStarted) {
2135             require(msg.value >= tokenPrice * amount, "Incorrect ETH");
2136             require(amount <= tokensToBuyAmount, "No more tokens left!");
2137             tokensToBuyAmount -= amount;
2138         } else {
2139             require(msg.value >= presaleTokenPrice * amount, "Incorrect ETH");
2140             require(amount <= presaleTokensToBuyAmount, "No more tokens left!");
2141             presaleTokensToBuyAmount -= amount;
2142         }
2143 
2144         _safeMint(msg.sender, amount);
2145     }
2146 
2147     function _baseURI() internal view override(ERC721A) returns (string memory) {
2148         return tokenBaseURI;
2149     }
2150    
2151     function setBaseURI(string calldata URI) external onlyOwner {
2152         tokenBaseURI = URI;
2153     }
2154 
2155     function withdraw() external onlyOwner {
2156         require(payable(msg.sender).send(address(this).balance));
2157     }
2158 
2159     function tokenURI(uint256 tokenId) public view override(ERC721A) returns (string memory) {
2160         return string(abi.encodePacked(super.tokenURI(tokenId), ".json"));
2161     }
2162 
2163     function burn(uint256 tokenId) external {
2164         require(isBurnEnabled, "Cannot burn token");
2165         super._burn(tokenId, true);
2166     }
2167 
2168     function getContractInfo() external view returns (
2169         bool _hasSaleStarted,
2170         bool _isBurnEnabled,
2171         uint256 _maxTokensPerMint,
2172         uint256 _tokenPrice,
2173         uint256 _presaleTokenPrice,
2174         uint256 _tokensToBuyAmount
2175     ) {
2176         _hasSaleStarted = hasSaleStarted;
2177         _isBurnEnabled = isBurnEnabled;
2178         _maxTokensPerMint = maxTokensPerMint;
2179         _tokenPrice = tokenPrice;
2180         _presaleTokenPrice = presaleTokensToBuyAmount;
2181         _tokensToBuyAmount = tokensToBuyAmount;
2182     }
2183 }