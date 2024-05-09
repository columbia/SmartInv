1 /**
2  *Submitted for verification at Etherscan.io on 2021-07-20
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-07-16
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.0;
12 
13 /*
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes calldata) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Interface of the ERC165 standard, as defined in the
37  * https://eips.ethereum.org/EIPS/eip-165[EIP].
38  *
39  * Implementers can declare support of contract interfaces, which can then be
40  * queried by others ({ERC165Checker}).
41  *
42  * For an implementation, see {ERC165}.
43  */
44 interface IERC165 {
45     /**
46      * @dev Returns true if this contract implements the interface defined by
47      * `interfaceId`. See the corresponding
48      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
49      * to learn more about how these ids are created.
50      *
51      * This function call must use less than 30 000 gas.
52      */
53     function supportsInterface(bytes4 interfaceId) external view returns (bool);
54 }
55 
56 pragma solidity ^0.8.0;
57 
58 
59 /**
60  * @dev Required interface of an ERC721 compliant contract.
61  */
62 interface IERC721 is IERC165 {
63     /**
64      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
65      */
66     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
67 
68     /**
69      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
70      */
71     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
72 
73     /**
74      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
75      */
76     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
77 
78     /**
79      * @dev Returns the number of tokens in ``owner``'s account.
80      */
81     function balanceOf(address owner) external view returns (uint256 balance);
82 
83     /**
84      * @dev Returns the owner of the `tokenId` token.
85      *
86      * Requirements:
87      *
88      * - `tokenId` must exist.
89      */
90     function ownerOf(uint256 tokenId) external view returns (address owner);
91 
92     /**
93      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
94      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
95      *
96      * Requirements:
97      *
98      * - `from` cannot be the zero address.
99      * - `to` cannot be the zero address.
100      * - `tokenId` token must exist and be owned by `from`.
101      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
102      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
103      *
104      * Emits a {Transfer} event.
105      */
106     function safeTransferFrom(address from, address to, uint256 tokenId) external;
107 
108     /**
109      * @dev Transfers `tokenId` token from `from` to `to`.
110      *
111      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
112      *
113      * Requirements:
114      *
115      * - `from` cannot be the zero address.
116      * - `to` cannot be the zero address.
117      * - `tokenId` token must be owned by `from`.
118      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
119      *
120      * Emits a {Transfer} event.
121      */
122     function transferFrom(address from, address to, uint256 tokenId) external;
123 
124     /**
125      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
126      * The approval is cleared when the token is transferred.
127      *
128      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
129      *
130      * Requirements:
131      *
132      * - The caller must own the token or be an approved operator.
133      * - `tokenId` must exist.
134      *
135      * Emits an {Approval} event.
136      */
137     function approve(address to, uint256 tokenId) external;
138 
139     /**
140      * @dev Returns the account approved for `tokenId` token.
141      *
142      * Requirements:
143      *
144      * - `tokenId` must exist.
145      */
146     function getApproved(uint256 tokenId) external view returns (address operator);
147 
148     /**
149      * @dev Approve or remove `operator` as an operator for the caller.
150      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
151      *
152      * Requirements:
153      *
154      * - The `operator` cannot be the caller.
155      *
156      * Emits an {ApprovalForAll} event.
157      */
158     function setApprovalForAll(address operator, bool _approved) external;
159 
160     /**
161      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
162      *
163      * See {setApprovalForAll}
164      */
165     function isApprovedForAll(address owner, address operator) external view returns (bool);
166 
167     /**
168       * @dev Safely transfers `tokenId` token from `from` to `to`.
169       *
170       * Requirements:
171       *
172       * - `from` cannot be the zero address.
173       * - `to` cannot be the zero address.
174       * - `tokenId` token must exist and be owned by `from`.
175       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
176       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
177       *
178       * Emits a {Transfer} event.
179       */
180     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
181 }
182 
183 pragma solidity ^0.8.0;
184 
185 
186 /**
187  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
188  * @dev See https://eips.ethereum.org/EIPS/eip-721
189  */
190 interface IERC721Metadata is IERC721 {
191 
192     /**
193      * @dev Returns the token collection name.
194      */
195     function name() external view returns (string memory);
196 
197     /**
198      * @dev Returns the token collection symbol.
199      */
200     function symbol() external view returns (string memory);
201 
202     /**
203      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
204      */
205     function tokenURI(uint256 tokenId) external view returns (string memory);
206 }
207 
208 pragma solidity ^0.8.0;
209 
210 
211 /**
212  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
213  * @dev See https://eips.ethereum.org/EIPS/eip-721
214  */
215 interface IERC721Enumerable is IERC721 {
216 
217     /**
218      * @dev Returns the total amount of tokens stored by the contract.
219      */
220     function totalSupply() external view returns (uint256);
221 
222     /**
223      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
224      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
225      */
226     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
227 
228     /**
229      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
230      * Use along with {totalSupply} to enumerate all tokens.
231      */
232     function tokenByIndex(uint256 index) external view returns (uint256);
233 }
234 
235 pragma solidity ^0.8.0;
236 
237 /**
238  * @title ERC721 token receiver interface
239  * @dev Interface for any contract that wants to support safeTransfers
240  * from ERC721 asset contracts.
241  */
242 interface IERC721Receiver {
243     /**
244      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
245      * by `operator` from `from`, this function is called.
246      *
247      * It must return its Solidity selector to confirm the token transfer.
248      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
249      *
250      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
251      */
252     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
253 }
254 
255 pragma solidity ^0.8.0;
256 
257 
258 /**
259  * @dev Implementation of the {IERC165} interface.
260  *
261  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
262  * for the additional interface id that will be supported. For example:
263  *
264  * ```solidity
265  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
266  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
267  * }
268  * ```
269  *
270  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
271  */
272 abstract contract ERC165 is IERC165 {
273     /**
274      * @dev See {IERC165-supportsInterface}.
275      */
276     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
277         return interfaceId == type(IERC165).interfaceId;
278     }
279 }
280 
281 pragma solidity ^0.8.0;
282 
283 /**
284  * @dev Collection of functions related to the address type
285  */
286 library Address {
287     /**
288      * @dev Returns true if `account` is a contract.
289      *
290      * [IMPORTANT]
291      * ====
292      * It is unsafe to assume that an address for which this function returns
293      * false is an externally-owned account (EOA) and not a contract.
294      *
295      * Among others, `isContract` will return false for the following
296      * types of addresses:
297      *
298      *  - an externally-owned account
299      *  - a contract in construction
300      *  - an address where a contract will be created
301      *  - an address where a contract lived, but was destroyed
302      * ====
303      */
304     function isContract(address account) internal view returns (bool) {
305         // This method relies on extcodesize, which returns 0 for contracts in
306         // construction, since the code is only stored at the end of the
307         // constructor execution.
308 
309         uint256 size;
310         // solhint-disable-next-line no-inline-assembly
311         assembly { size := extcodesize(account) }
312         return size > 0;
313     }
314 
315     /**
316      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
317      * `recipient`, forwarding all available gas and reverting on errors.
318      *
319      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
320      * of certain opcodes, possibly making contracts go over the 2300 gas limit
321      * imposed by `transfer`, making them unable to receive funds via
322      * `transfer`. {sendValue} removes this limitation.
323      *
324      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
325      *
326      * IMPORTANT: because control is transferred to `recipient`, care must be
327      * taken to not create reentrancy vulnerabilities. Consider using
328      * {ReentrancyGuard} or the
329      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
330      */
331     function sendValue(address payable recipient, uint256 amount) internal {
332         require(address(this).balance >= amount, "Address: insufficient balance");
333 
334         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
335         (bool success, ) = recipient.call{ value: amount }("");
336         require(success, "Address: unable to send value, recipient may have reverted");
337     }
338 
339     /**
340      * @dev Performs a Solidity function call using a low level `call`. A
341      * plain`call` is an unsafe replacement for a function call: use this
342      * function instead.
343      *
344      * If `target` reverts with a revert reason, it is bubbled up by this
345      * function (like regular Solidity function calls).
346      *
347      * Returns the raw returned data. To convert to the expected return value,
348      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
349      *
350      * Requirements:
351      *
352      * - `target` must be a contract.
353      * - calling `target` with `data` must not revert.
354      *
355      * _Available since v3.1._
356      */
357     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
358       return functionCall(target, data, "Address: low-level call failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
363      * `errorMessage` as a fallback revert reason when `target` reverts.
364      *
365      * _Available since v3.1._
366      */
367     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
368         return functionCallWithValue(target, data, 0, errorMessage);
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
373      * but also transferring `value` wei to `target`.
374      *
375      * Requirements:
376      *
377      * - the calling contract must have an ETH balance of at least `value`.
378      * - the called Solidity function must be `payable`.
379      *
380      * _Available since v3.1._
381      */
382     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
383         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
388      * with `errorMessage` as a fallback revert reason when `target` reverts.
389      *
390      * _Available since v3.1._
391      */
392     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
393         require(address(this).balance >= value, "Address: insufficient balance for call");
394         require(isContract(target), "Address: call to non-contract");
395 
396         // solhint-disable-next-line avoid-low-level-calls
397         (bool success, bytes memory returndata) = target.call{ value: value }(data);
398         return _verifyCallResult(success, returndata, errorMessage);
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
403      * but performing a static call.
404      *
405      * _Available since v3.3._
406      */
407     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
408         return functionStaticCall(target, data, "Address: low-level static call failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
413      * but performing a static call.
414      *
415      * _Available since v3.3._
416      */
417     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
418         require(isContract(target), "Address: static call to non-contract");
419 
420         // solhint-disable-next-line avoid-low-level-calls
421         (bool success, bytes memory returndata) = target.staticcall(data);
422         return _verifyCallResult(success, returndata, errorMessage);
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
427      * but performing a delegate call.
428      *
429      * _Available since v3.4._
430      */
431     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
432         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
437      * but performing a delegate call.
438      *
439      * _Available since v3.4._
440      */
441     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
442         require(isContract(target), "Address: delegate call to non-contract");
443 
444         // solhint-disable-next-line avoid-low-level-calls
445         (bool success, bytes memory returndata) = target.delegatecall(data);
446         return _verifyCallResult(success, returndata, errorMessage);
447     }
448 
449     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
450         if (success) {
451             return returndata;
452         } else {
453             // Look for revert reason and bubble it up if present
454             if (returndata.length > 0) {
455                 // The easiest way to bubble the revert reason is using memory via assembly
456 
457                 // solhint-disable-next-line no-inline-assembly
458                 assembly {
459                     let returndata_size := mload(returndata)
460                     revert(add(32, returndata), returndata_size)
461                 }
462             } else {
463                 revert(errorMessage);
464             }
465         }
466     }
467 }
468 
469 
470 pragma solidity ^0.8.0;
471 
472 /**
473  * @dev Contract module which provides a basic access control mechanism, where
474  * there is an account (an owner) that can be granted exclusive access to
475  * specific functions.
476  *
477  * By default, the owner account will be the one that deploys the contract. This
478  * can later be changed with {transferOwnership}.
479  *
480  * This module is used through inheritance. It will make available the modifier
481  * `onlyOwner`, which can be applied to your functions to restrict their use to
482  * the owner.
483  */
484 abstract contract Ownable is Context {
485     address private _owner;
486 
487     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
488 
489     /**
490      * @dev Initializes the contract setting the deployer as the initial owner.
491      */
492     constructor () {
493         address msgSender = _msgSender();
494         _owner = msgSender;
495         emit OwnershipTransferred(address(0), msgSender);
496     }
497 
498     /**
499      * @dev Returns the address of the current owner.
500      */
501     function owner() public view virtual returns (address) {
502         return _owner;
503     }
504 
505     /**
506      * @dev Throws if called by any account other than the owner.
507      */
508     modifier onlyOwner() {
509         require(owner() == _msgSender(), "Ownable: caller is not the owner");
510         _;
511     }
512 
513     /**
514      * @dev Leaves the contract without owner. It will not be possible to call
515      * `onlyOwner` functions anymore. Can only be called by the current owner.
516      *
517      * NOTE: Renouncing ownership will leave the contract without an owner,
518      * thereby removing any functionality that is only available to the owner.
519      */
520     function renounceOwnership() public virtual onlyOwner {
521         emit OwnershipTransferred(_owner, address(0));
522         _owner = address(0);
523     }
524 
525     /**
526      * @dev Transfers ownership of the contract to a new account (`newOwner`).
527      * Can only be called by the current owner.
528      */
529     function transferOwnership(address newOwner) public virtual onlyOwner {
530         require(newOwner != address(0), "Ownable: new owner is the zero address");
531         emit OwnershipTransferred(_owner, newOwner);
532         _owner = newOwner;
533     }
534 }
535 
536 pragma solidity ^0.8.0;
537 
538 /**
539  * @dev Contract module that helps prevent reentrant calls to a function.
540  *
541  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
542  * available, which can be applied to functions to make sure there are no nested
543  * (reentrant) calls to them.
544  *
545  * Note that because there is a single `nonReentrant` guard, functions marked as
546  * `nonReentrant` may not call one another. This can be worked around by making
547  * those functions `private`, and then adding `external` `nonReentrant` entry
548  * points to them.
549  *
550  * TIP: If you would like to learn more about reentrancy and alternative ways
551  * to protect against it, check out our blog post
552  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
553  */
554 abstract contract ReentrancyGuard {
555     // Booleans are more expensive than uint256 or any type that takes up a full
556     // word because each write operation emits an extra SLOAD to first read the
557     // slot's contents, replace the bits taken up by the boolean, and then write
558     // back. This is the compiler's defense against contract upgrades and
559     // pointer aliasing, and it cannot be disabled.
560 
561     // The values being non-zero value makes deployment a bit more expensive,
562     // but in exchange the refund on every call to nonReentrant will be lower in
563     // amount. Since refunds are capped to a percentage of the total
564     // transaction's gas, it is best to keep them low in cases like this one, to
565     // increase the likelihood of the full refund coming into effect.
566     uint256 private constant _NOT_ENTERED = 1;
567     uint256 private constant _ENTERED = 2;
568 
569     uint256 private _status;
570 
571     constructor () {
572         _status = _NOT_ENTERED;
573     }
574 
575     /**
576      * @dev Prevents a contract from calling itself, directly or indirectly.
577      * Calling a `nonReentrant` function from another `nonReentrant`
578      * function is not supported. It is possible to prevent this from happening
579      * by making the `nonReentrant` function external, and make it call a
580      * `private` function that does the actual work.
581      */
582     modifier nonReentrant() {
583         // On the first call to nonReentrant, _notEntered will be true
584         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
585 
586         // Any calls to nonReentrant after this point will fail
587         _status = _ENTERED;
588 
589         _;
590 
591         // By storing the original value once again, a refund is triggered (see
592         // https://eips.ethereum.org/EIPS/eip-2200)
593         _status = _NOT_ENTERED;
594     }
595 }
596 
597 pragma solidity ^0.8.0;
598 
599 /**
600  * @title Counters
601  * @author Matt Condon (@shrugs)
602  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
603  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
604  *
605  * Include with `using Counters for Counters.Counter;`
606  */
607 library Counters {
608     struct Counter {
609         // This variable should never be directly accessed by users of the library: interactions must be restricted to
610         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
611         // this feature: see https://github.com/ethereum/solidity/issues/4637
612         uint256 _value; // default: 0
613     }
614 
615     function current(Counter storage counter) internal view returns (uint256) {
616         return counter._value;
617     }
618 
619     function increment(Counter storage counter) internal {
620         unchecked {
621             counter._value += 1;
622         }
623     }
624 
625     function decrement(Counter storage counter) internal {
626         uint256 value = counter._value;
627         require(value > 0, "Counter: decrement overflow");
628         unchecked {
629             counter._value = value - 1;
630         }
631     }
632 }
633 
634 pragma solidity ^0.8.0;
635 
636 /**
637  * @dev String operations.
638  */
639 library Strings {
640     bytes16 private constant alphabet = "0123456789abcdef";
641 
642     /**
643      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
644      */
645     function toString(uint256 value) internal pure returns (string memory) {
646         // Inspired by OraclizeAPI's implementation - MIT licence
647         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
648 
649         if (value == 0) {
650             return "0";
651         }
652         uint256 temp = value;
653         uint256 digits;
654         while (temp != 0) {
655             digits++;
656             temp /= 10;
657         }
658         bytes memory buffer = new bytes(digits);
659         while (value != 0) {
660             digits -= 1;
661             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
662             value /= 10;
663         }
664         return string(buffer);
665     }
666 
667     /**
668      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
669      */
670     function toHexString(uint256 value) internal pure returns (string memory) {
671         if (value == 0) {
672             return "0x00";
673         }
674         uint256 temp = value;
675         uint256 length = 0;
676         while (temp != 0) {
677             length++;
678             temp >>= 8;
679         }
680         return toHexString(value, length);
681     }
682 
683     /**
684      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
685      */
686     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
687         bytes memory buffer = new bytes(2 * length + 2);
688         buffer[0] = "0";
689         buffer[1] = "x";
690         for (uint256 i = 2 * length + 1; i > 1; --i) {
691             buffer[i] = alphabet[value & 0xf];
692             value >>= 4;
693         }
694         require(value == 0, "Strings: hex length insufficient");
695         return string(buffer);
696     }
697 
698 }
699 
700 
701 pragma solidity ^0.8.0;
702 
703 /**
704  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
705  * the Metadata extension, but not including the Enumerable extension, which is available separately as
706  * {ERC721Enumerable}.
707  */
708 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
709     using Address for address;
710     using Strings for uint256;
711 
712     // Token name
713     string private _name;
714 
715     // Token symbol
716     string private _symbol;
717 
718     // Mapping from token ID to owner address
719     mapping (uint256 => address) private _owners;
720 
721     // Mapping owner address to token count
722     mapping (address => uint256) private _balances;
723 
724     // Mapping from token ID to approved address
725     mapping (uint256 => address) private _tokenApprovals;
726 
727     // Mapping from owner to operator approvals
728     mapping (address => mapping (address => bool)) private _operatorApprovals;
729 
730     /**
731      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
732      */
733     constructor (string memory name_, string memory symbol_) {
734         _name = name_;
735         _symbol = symbol_;
736     }
737 
738     /**
739      * @dev See {IERC165-supportsInterface}.
740      */
741     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
742         return interfaceId == type(IERC721).interfaceId
743             || interfaceId == type(IERC721Metadata).interfaceId
744             || super.supportsInterface(interfaceId);
745     }
746 
747     /**
748      * @dev See {IERC721-balanceOf}.
749      */
750     function balanceOf(address owner) public view virtual override returns (uint256) {
751         require(owner != address(0), "ERC721: balance query for the zero address");
752         return _balances[owner];
753     }
754 
755     /**
756      * @dev See {IERC721-ownerOf}.
757      */
758     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
759         address owner = _owners[tokenId];
760         require(owner != address(0), "ERC721: owner query for nonexistent token");
761         return owner;
762     }
763 
764     /**
765      * @dev See {IERC721Metadata-name}.
766      */
767     function name() public view virtual override returns (string memory) {
768         return _name;
769     }
770 
771     /**
772      * @dev See {IERC721Metadata-symbol}.
773      */
774     function symbol() public view virtual override returns (string memory) {
775         return _symbol;
776     }
777 
778     /**
779      * @dev See {IERC721Metadata-tokenURI}.
780      */
781     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
782         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
783 
784         string memory baseURI = _baseURI();
785         return bytes(baseURI).length > 0
786             ? string(abi.encodePacked(baseURI, tokenId.toString()))
787             : '';
788     }
789 
790     /**
791      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
792      * in child contracts.
793      */
794     function _baseURI() internal view virtual returns (string memory) {
795         return "";
796     }
797 
798     /**
799      * @dev See {IERC721-approve}.
800      */
801     function approve(address to, uint256 tokenId) public virtual override {
802         address owner = ERC721.ownerOf(tokenId);
803         require(to != owner, "ERC721: approval to current owner");
804 
805         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
806             "ERC721: approve caller is not owner nor approved for all"
807         );
808 
809         _approve(to, tokenId);
810     }
811 
812     /**
813      * @dev See {IERC721-getApproved}.
814      */
815     function getApproved(uint256 tokenId) public view virtual override returns (address) {
816         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
817 
818         return _tokenApprovals[tokenId];
819     }
820 
821     /**
822      * @dev See {IERC721-setApprovalForAll}.
823      */
824     function setApprovalForAll(address operator, bool approved) public virtual override {
825         require(operator != _msgSender(), "ERC721: approve to caller");
826 
827         _operatorApprovals[_msgSender()][operator] = approved;
828         emit ApprovalForAll(_msgSender(), operator, approved);
829     }
830 
831     /**
832      * @dev See {IERC721-isApprovedForAll}.
833      */
834     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
835         return _operatorApprovals[owner][operator];
836     }
837 
838     /**
839      * @dev See {IERC721-transferFrom}.
840      */
841     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
842         //solhint-disable-next-line max-line-length
843         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
844 
845         _transfer(from, to, tokenId);
846     }
847 
848     /**
849      * @dev See {IERC721-safeTransferFrom}.
850      */
851     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
852         safeTransferFrom(from, to, tokenId, "");
853     }
854 
855     /**
856      * @dev See {IERC721-safeTransferFrom}.
857      */
858     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
859         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
860         _safeTransfer(from, to, tokenId, _data);
861     }
862 
863     /**
864      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
865      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
866      *
867      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
868      *
869      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
870      * implement alternative mechanisms to perform token transfer, such as signature-based.
871      *
872      * Requirements:
873      *
874      * - `from` cannot be the zero address.
875      * - `to` cannot be the zero address.
876      * - `tokenId` token must exist and be owned by `from`.
877      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
878      *
879      * Emits a {Transfer} event.
880      */
881     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
882         _transfer(from, to, tokenId);
883         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
884     }
885 
886     /**
887      * @dev Returns whether `tokenId` exists.
888      *
889      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
890      *
891      * Tokens start existing when they are minted (`_mint`),
892      * and stop existing when they are burned (`_burn`).
893      */
894     function _exists(uint256 tokenId) internal view virtual returns (bool) {
895         return _owners[tokenId] != address(0);
896     }
897 
898     /**
899      * @dev Returns whether `spender` is allowed to manage `tokenId`.
900      *
901      * Requirements:
902      *
903      * - `tokenId` must exist.
904      */
905     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
906         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
907         address owner = ERC721.ownerOf(tokenId);
908         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
909     }
910 
911     /**
912      * @dev Safely mints `tokenId` and transfers it to `to`.
913      *
914      * Requirements:
915      *
916      * - `tokenId` must not exist.
917      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
918      *
919      * Emits a {Transfer} event.
920      */
921     function _safeMint(address to, uint256 tokenId) internal virtual {
922         _safeMint(to, tokenId, "");
923     }
924 
925     /**
926      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
927      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
928      */
929     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
930         _mint(to, tokenId);
931         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
932     }
933 
934     /**
935      * @dev Mints `tokenId` and transfers it to `to`.
936      *
937      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
938      *
939      * Requirements:
940      *
941      * - `tokenId` must not exist.
942      * - `to` cannot be the zero address.
943      *
944      * Emits a {Transfer} event.
945      */
946     function _mint(address to, uint256 tokenId) internal virtual {
947         require(to != address(0), "ERC721: mint to the zero address");
948         require(!_exists(tokenId), "ERC721: token already minted");
949 
950         _beforeTokenTransfer(address(0), to, tokenId);
951 
952         _balances[to] += 1;
953         _owners[tokenId] = to;
954 
955         emit Transfer(address(0), to, tokenId);
956     }
957 
958     /**
959      * @dev Destroys `tokenId`.
960      * The approval is cleared when the token is burned.
961      *
962      * Requirements:
963      *
964      * - `tokenId` must exist.
965      *
966      * Emits a {Transfer} event.
967      */
968     function _burn(uint256 tokenId) internal virtual {
969         address owner = ERC721.ownerOf(tokenId);
970 
971         _beforeTokenTransfer(owner, address(0), tokenId);
972 
973         // Clear approvals
974         _approve(address(0), tokenId);
975 
976         _balances[owner] -= 1;
977         delete _owners[tokenId];
978 
979         emit Transfer(owner, address(0), tokenId);
980     }
981 
982     /**
983      * @dev Transfers `tokenId` from `from` to `to`.
984      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
985      *
986      * Requirements:
987      *
988      * - `to` cannot be the zero address.
989      * - `tokenId` token must be owned by `from`.
990      *
991      * Emits a {Transfer} event.
992      */
993     function _transfer(address from, address to, uint256 tokenId) internal virtual {
994         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
995         require(to != address(0), "ERC721: transfer to the zero address");
996 
997         _beforeTokenTransfer(from, to, tokenId);
998 
999         // Clear approvals from the previous owner
1000         _approve(address(0), tokenId);
1001 
1002         _balances[from] -= 1;
1003         _balances[to] += 1;
1004         _owners[tokenId] = to;
1005 
1006         emit Transfer(from, to, tokenId);
1007     }
1008 
1009     /**
1010      * @dev Approve `to` to operate on `tokenId`
1011      *
1012      * Emits a {Approval} event.
1013      */
1014     function _approve(address to, uint256 tokenId) internal virtual {
1015         _tokenApprovals[tokenId] = to;
1016         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1017     }
1018 
1019     /**
1020      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1021      * The call is not executed if the target address is not a contract.
1022      *
1023      * @param from address representing the previous owner of the given token ID
1024      * @param to target address that will receive the tokens
1025      * @param tokenId uint256 ID of the token to be transferred
1026      * @param _data bytes optional data to send along with the call
1027      * @return bool whether the call correctly returned the expected magic value
1028      */
1029     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1030         private returns (bool)
1031     {
1032         if (to.isContract()) {
1033             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1034                 return retval == IERC721Receiver(to).onERC721Received.selector;
1035             } catch (bytes memory reason) {
1036                 if (reason.length == 0) {
1037                     revert("ERC721: transfer to non ERC721Receiver implementer");
1038                 } else {
1039                     // solhint-disable-next-line no-inline-assembly
1040                     assembly {
1041                         revert(add(32, reason), mload(reason))
1042                     }
1043                 }
1044             }
1045         } else {
1046             return true;
1047         }
1048     }
1049     /**
1050      * @dev Hook that is called before any token transfer. This includes minting
1051      * and burning.
1052      *
1053      * Calling conditions:
1054      *
1055      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1056      * transferred to `to`.
1057      * - When `from` is zero, `tokenId` will be minted for `to`.
1058      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1059      * - `from` cannot be the zero address.
1060      * - `to` cannot be the zero address.
1061      *
1062      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1063      */
1064     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1065 }
1066 // <3
1067 
1068 pragma solidity ^0.8.0;
1069 
1070 /**
1071  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1072  * enumerability of all the token ids in the contract as well as all token ids owned by each
1073  * account.
1074  */
1075 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1076     // Mapping from owner to list of owned token IDs
1077     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1078 
1079     // Mapping from token ID to index of the owner tokens list
1080     mapping(uint256 => uint256) private _ownedTokensIndex;
1081 
1082     // Array with all token ids, used for enumeration
1083     uint256[] private _allTokens;
1084 
1085     // Mapping from token id to position in the allTokens array
1086     mapping(uint256 => uint256) private _allTokensIndex;
1087 
1088     /**
1089      * @dev See {IERC165-supportsInterface}.
1090      */
1091     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1092         return interfaceId == type(IERC721Enumerable).interfaceId
1093             || super.supportsInterface(interfaceId);
1094     }
1095 
1096     /**
1097      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1098      */
1099     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1100         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1101         return _ownedTokens[owner][index];
1102     }
1103 
1104     /**
1105      * @dev See {IERC721Enumerable-totalSupply}.
1106      */
1107     function totalSupply() public view virtual override returns (uint256) {
1108         return _allTokens.length;
1109     }
1110 
1111     /**
1112      * @dev See {IERC721Enumerable-tokenByIndex}.
1113      */
1114     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1115         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1116         return _allTokens[index];
1117     }
1118 
1119     /**
1120      * @dev Hook that is called before any token transfer. This includes minting
1121      * and burning.
1122      *
1123      * Calling conditions:
1124      *
1125      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1126      * transferred to `to`.
1127      * - When `from` is zero, `tokenId` will be minted for `to`.
1128      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1129      * - `from` cannot be the zero address.
1130      * - `to` cannot be the zero address.
1131      *
1132      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1133      */
1134     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1135         super._beforeTokenTransfer(from, to, tokenId);
1136 
1137         if (from == address(0)) {
1138             _addTokenToAllTokensEnumeration(tokenId);
1139         } else if (from != to) {
1140             _removeTokenFromOwnerEnumeration(from, tokenId);
1141         }
1142         if (to == address(0)) {
1143             _removeTokenFromAllTokensEnumeration(tokenId);
1144         } else if (to != from) {
1145             _addTokenToOwnerEnumeration(to, tokenId);
1146         }
1147     }
1148 
1149     /**
1150      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1151      * @param to address representing the new owner of the given token ID
1152      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1153      */
1154     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1155         uint256 length = ERC721.balanceOf(to);
1156         _ownedTokens[to][length] = tokenId;
1157         _ownedTokensIndex[tokenId] = length;
1158     }
1159 
1160     /**
1161      * @dev Private function to add a token to this extension's token tracking data structures.
1162      * @param tokenId uint256 ID of the token to be added to the tokens list
1163      */
1164     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1165         _allTokensIndex[tokenId] = _allTokens.length;
1166         _allTokens.push(tokenId);
1167     }
1168 
1169     /**
1170      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1171      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1172      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1173      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1174      * @param from address representing the previous owner of the given token ID
1175      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1176      */
1177     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1178         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1179         // then delete the last slot (swap and pop).
1180 
1181         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1182         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1183 
1184         // When the token to delete is the last token, the swap operation is unnecessary
1185         if (tokenIndex != lastTokenIndex) {
1186             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1187 
1188             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1189             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1190         }
1191 
1192         // This also deletes the contents at the last position of the array
1193         delete _ownedTokensIndex[tokenId];
1194         delete _ownedTokens[from][lastTokenIndex];
1195     }
1196 
1197     /**
1198      * @dev Private function to remove a token from this extension's token tracking data structures.
1199      * This has O(1) time complexity, but alters the order of the _allTokens array.
1200      * @param tokenId uint256 ID of the token to be removed from the tokens list
1201      */
1202     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1203         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1204         // then delete the last slot (swap and pop).
1205 
1206         uint256 lastTokenIndex = _allTokens.length - 1;
1207         uint256 tokenIndex = _allTokensIndex[tokenId];
1208 
1209         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1210         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1211         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1212         uint256 lastTokenId = _allTokens[lastTokenIndex];
1213 
1214         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1215         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1216 
1217         // This also deletes the contents at the last position of the array
1218         delete _allTokensIndex[tokenId];
1219         _allTokens.pop();
1220     }
1221 }
1222 
1223 
1224 
1225 
1226 
1227 
1228 
1229 
1230 // WELCOME TO COVIDPUNKS! It has been our utmost pleasure learning about NFT development with this project. 
1231 // Hopefully pandemic-themed content will be out of sight and mind soon, but until then... don't forget to wear a mask. :-) 
1232 //   -Waddle, Waggle, and Liu
1233 
1234 
1235 pragma solidity ^0.8.0;
1236 
1237 contract COVIDPunks is Ownable, ERC721Enumerable, ReentrancyGuard {
1238   using Counters for Counters.Counter;
1239   using Strings for uint256;
1240 
1241   string public imageHash;
1242 
1243   bool public isSaleOn = false;
1244 
1245   bool public saleHasBeenStarted = false;
1246 
1247   uint256 public constant MAX_MINTABLE_AT_ONCE = 20;
1248 
1249   uint256 private _price = 0.03 ether; // 30000000000000000
1250   
1251   string public punkcontractURI;
1252   
1253   constructor() ERC721("COVIDPunks", "PUNK-19") {}
1254 
1255   // for wd
1256   address oaf = 0x15776c1F16C3B766A8a4af06DdB83dAD1512C9E9;
1257   address quack = 0xD9Eb7Ddd1d5f9081BA745dcf0e56B39788b91f94;
1258 
1259   uint256[10000] private _availableTokens;
1260   uint256 private _numAvailableTokens = 10000;
1261   uint256 private _numFreeRollsGiven = 0;
1262 
1263   mapping(address => uint256) public freeRollPunks;
1264 
1265   uint256 private _lastTokenIdMintedInInitialSet = 10000;
1266 
1267   function numTotalPunks() public view virtual returns (uint256) {
1268     return 10000;
1269   }
1270 
1271   function freeRollMint() public nonReentrant() {
1272     require(freeRollPunks[msg.sender] > 0, "You don't have any free rolls!");
1273     uint256 toMint = freeRollPunks[msg.sender];
1274     freeRollPunks[msg.sender] = 0;
1275     uint256 remaining = numTotalPunks() - totalSupply();
1276     if (toMint > remaining) {
1277       toMint = remaining;
1278     }
1279     _mint(toMint);
1280   }
1281 
1282   function getNumFreeRollPunks(address owner) public view returns (uint256) {
1283     return freeRollPunks[owner];
1284   }
1285 
1286   function mint(uint256 _numToMint) public payable nonReentrant() {
1287     require(isSaleOn, "Sale hasn't started.");
1288     uint256 totalSupply = totalSupply();
1289     require(
1290       totalSupply + _numToMint <= numTotalPunks(),
1291       "There aren't this many punks left."
1292     );
1293     uint256 costForMintingPunks = _price * _numToMint;
1294     require(
1295       msg.value >= costForMintingPunks,
1296       "Too little sent, please send more eth."
1297     );
1298     if (msg.value > costForMintingPunks) {
1299       payable(msg.sender).transfer(msg.value - costForMintingPunks);
1300     }
1301 
1302     _mint(_numToMint);
1303   }
1304 
1305   // internal minting function
1306   function _mint(uint256 _numToMint) internal {
1307     require(_numToMint <= MAX_MINTABLE_AT_ONCE, "Minting too many at once.");
1308 
1309     uint256 updatedNumAvailableTokens = _numAvailableTokens;
1310     for (uint256 i = 0; i < _numToMint; i++) {
1311       uint256 newTokenId = useRandomAvailableToken(_numToMint, i);
1312       _safeMint(msg.sender, newTokenId);
1313       updatedNumAvailableTokens--;
1314     }
1315     _numAvailableTokens = updatedNumAvailableTokens;
1316   }
1317 
1318   function useRandomAvailableToken(uint256 _numToFetch, uint256 _i)
1319     internal
1320     returns (uint256)
1321   {
1322     uint256 randomNum =
1323       uint256(
1324         keccak256(
1325           abi.encode(
1326             msg.sender,
1327             tx.gasprice,
1328             block.number,
1329             block.timestamp,
1330             blockhash(block.number - 1),
1331             _numToFetch,
1332             _i
1333           )
1334         )
1335       );
1336     uint256 randomIndex = randomNum % _numAvailableTokens;
1337     return useAvailableTokenAtIndex(randomIndex);
1338   }
1339 
1340   function useAvailableTokenAtIndex(uint256 indexToUse)
1341     internal
1342     returns (uint256)
1343   {
1344     uint256 valAtIndex = _availableTokens[indexToUse];
1345     uint256 result;
1346     if (valAtIndex == 0) {
1347       // This means the index itself is still an available token
1348       result = indexToUse;
1349     } else {
1350       // This means the index itself is not an available token, but the val at that index is.
1351       result = valAtIndex;
1352     }
1353 
1354     uint256 lastIndex = _numAvailableTokens - 1;
1355     if (indexToUse != lastIndex) {
1356       // Replace the value at indexToUse, now that it's been used.
1357       // Replace it with the data from the last index in the array, since we are going to decrease the array size afterwards.
1358       uint256 lastValInArray = _availableTokens[lastIndex];
1359       if (lastValInArray == 0) {
1360         // This means the index itself is still an available token
1361         _availableTokens[indexToUse] = lastIndex;
1362       } else {
1363         // This means the index itself is not an available token, but the val at that index is.
1364         _availableTokens[indexToUse] = lastValInArray;
1365       }
1366     }
1367 
1368     _numAvailableTokens--;
1369     return result;
1370   }
1371 
1372   function getPrice() public view returns (uint256){
1373     return _price;
1374   }
1375 
1376   function contractURI() public view returns (string memory){
1377     return punkcontractURI;
1378   }
1379 
1380 
1381   function getCostForMintingPunks(uint256 _numToMint)
1382     public
1383     view
1384     returns (uint256)
1385   {
1386     require(
1387       totalSupply() + _numToMint <= numTotalPunks(),
1388       "There are not this many punks left."
1389     );
1390     require(
1391       _numToMint <= MAX_MINTABLE_AT_ONCE,
1392       "You cannot mint that many punks."
1393     );
1394     return _numToMint * _price;  
1395   }
1396 
1397   function getPunksBelongingToOwner(address _owner)
1398     external
1399     view
1400     returns (uint256[] memory)
1401   {
1402     uint256 numPunks = balanceOf(_owner);
1403     if (numPunks == 0) {
1404       return new uint256[](0);
1405     } else {
1406       uint256[] memory result = new uint256[](numPunks);
1407       for (uint256 i = 0; i < numPunks; i++) {
1408         result[i] = tokenOfOwnerByIndex(_owner, i);
1409       }
1410       return result;
1411     }
1412   }
1413 
1414   /*
1415    * Dev stuff.
1416    */
1417 
1418   // metadata URI
1419   string private _baseTokenURI;
1420 
1421   function _baseURI() internal view virtual override returns (string memory) {
1422     return _baseTokenURI;
1423   }
1424 
1425   function tokenURI(uint256 _tokenId)
1426     public
1427     view
1428     override
1429     returns (string memory)
1430   {
1431     string memory base = _baseURI();
1432     string memory _tokenURI = Strings.toString(_tokenId);
1433     string memory ending = ".json";
1434 
1435     // If there is no base URI, return the token URI.
1436     if (bytes(base).length == 0) {
1437       return _tokenURI;
1438     }
1439 
1440     return string(abi.encodePacked(base, _tokenURI, ending));
1441   }
1442   
1443 
1444   /*
1445    * Owner stuff
1446    */
1447 
1448     // In case of catastrophic ETH movement
1449 
1450   function setPrice(uint256 _newPrice) public onlyOwner() {
1451     _price = _newPrice;
1452   }
1453 
1454   function startSale() public onlyOwner {
1455     isSaleOn = true;
1456     saleHasBeenStarted = true;
1457   }
1458 
1459   function endSale() public onlyOwner {
1460     isSaleOn = false;
1461   }
1462 
1463   function giveFreeRoll(address receiver, uint256 numRolls) public onlyOwner {
1464     // max number of free mints we can give to the community for promotions/marketing
1465     require(_numFreeRollsGiven < 200, "Already given max number of free rolls");
1466     require(freeRollPunks[receiver] + numRolls < 21, "Cannot exceed 20 unused free rolls!");
1467     uint256 freeRolls = freeRollPunks[receiver];
1468     freeRollPunks[receiver] = freeRolls + numRolls;
1469     _numFreeRollsGiven = _numFreeRollsGiven + numRolls;
1470   }
1471 
1472 
1473   // URIs
1474   function setBaseURI(string memory baseURI) external onlyOwner {
1475     _baseTokenURI = baseURI;
1476   }
1477 
1478   function setContractURI(string memory _contractURI) external onlyOwner {
1479     punkcontractURI = _contractURI;
1480   }
1481   
1482     function setImageHash(string memory _imageHash) external onlyOwner {
1483     imageHash = _imageHash;
1484   }
1485 
1486     function withdrawTeam() public onlyOwner {
1487     //uint256 _each = address(this).balance / 4;
1488     // uint256 _sixp = .06;
1489     uint256 _balance = address(this).balance;
1490     uint256 _oaf = _balance / 100 * 6;
1491     uint256 _quack = _balance - _oaf;
1492     require(payable(oaf).send(_oaf));
1493     require(payable(quack).send(_quack));
1494   }
1495   
1496     function withdrawFailsafe() public onlyOwner {
1497     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1498     require(success, "Transfer failed.");
1499   }
1500 
1501   function _beforeTokenTransfer(
1502     address from,
1503     address to,
1504     uint256 tokenId
1505   ) internal virtual override(ERC721Enumerable) {
1506     super._beforeTokenTransfer(from, to, tokenId);
1507   }
1508 
1509   function supportsInterface(bytes4 interfaceId)
1510     public
1511     view
1512     virtual
1513     override(ERC721Enumerable)
1514     returns (bool)
1515   {
1516     return super.supportsInterface(interfaceId);
1517   }
1518 }