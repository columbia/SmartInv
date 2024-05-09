1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Contract module which provides a basic access control mechanism, where
27  * there is an account (an owner) that can be granted exclusive access to
28  * specific functions.
29  *
30  * By default, the owner account will be the one that deploys the contract. This
31  * can later be changed with {transferOwnership}.
32  *
33  * This module is used through inheritance. It will make available the modifier
34  * `onlyOwner`, which can be applied to your functions to restrict their use to
35  * the owner.
36  */
37 abstract contract Ownable is Context {
38     address private _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * @dev Initializes the contract setting the deployer as the initial owner.
44      */
45     constructor() {
46         _setOwner(_msgSender());
47     }
48 
49     /**
50      * @dev Returns the address of the current owner.
51      */
52     function owner() public view virtual returns (address) {
53         return _owner;
54     }
55 
56     /**
57      * @dev Throws if called by any account other than the owner.
58      */
59     modifier onlyOwner() {
60         require(owner() == _msgSender(), "Ownable: caller is not the owner");
61         _;
62     }
63 
64     /**
65      * @dev Leaves the contract without owner. It will not be possible to call
66      * `onlyOwner` functions anymore. Can only be called by the current owner.
67      *
68      * NOTE: Renouncing ownership will leave the contract without an owner,
69      * thereby removing any functionality that is only available to the owner.
70      */
71     function renounceOwnership() public virtual onlyOwner {
72         _setOwner(address(0));
73     }
74 
75     /**
76      * @dev Transfers ownership of the contract to a new account (`newOwner`).
77      * Can only be called by the current owner.
78      */
79     function transferOwnership(address newOwner) public virtual onlyOwner {
80         require(newOwner != address(0), "Ownable: new owner is the zero address");
81         _setOwner(newOwner);
82     }
83 
84     function _setOwner(address newOwner) private {
85         address oldOwner = _owner;
86         _owner = newOwner;
87         emit OwnershipTransferred(oldOwner, newOwner);
88     }
89 }
90 
91 /**
92  * @dev Collection of functions related to the address type
93  */
94 library Address {
95     /**
96      * @dev Returns true if `account` is a contract.
97      *
98      * [IMPORTANT]
99      * ====
100      * It is unsafe to assume that an address for which this function returns
101      * false is an externally-owned account (EOA) and not a contract.
102      *
103      * Among others, `isContract` will return false for the following
104      * types of addresses:
105      *
106      *  - an externally-owned account
107      *  - a contract in construction
108      *  - an address where a contract will be created
109      *  - an address where a contract lived, but was destroyed
110      * ====
111      */
112     function isContract(address account) internal view returns (bool) {
113         // This method relies on extcodesize, which returns 0 for contracts in
114         // construction, since the code is only stored at the end of the
115         // constructor execution.
116 
117         uint256 size;
118         assembly {
119             size := extcodesize(account)
120         }
121         return size > 0;
122     }
123 
124     /**
125      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
126      * `recipient`, forwarding all available gas and reverting on errors.
127      *
128      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
129      * of certain opcodes, possibly making contracts go over the 2300 gas limit
130      * imposed by `transfer`, making them unable to receive funds via
131      * `transfer`. {sendValue} removes this limitation.
132      *
133      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
134      *
135      * IMPORTANT: because control is transferred to `recipient`, care must be
136      * taken to not create reentrancy vulnerabilities. Consider using
137      * {ReentrancyGuard} or the
138      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
139      */
140     function sendValue(address payable recipient, uint256 amount) internal {
141         require(address(this).balance >= amount, "Address: insufficient balance");
142 
143         (bool success, ) = recipient.call{value: amount}("");
144         require(success, "Address: unable to send value, recipient may have reverted");
145     }
146 
147     /**
148      * @dev Performs a Solidity function call using a low level `call`. A
149      * plain `call` is an unsafe replacement for a function call: use this
150      * function instead.
151      *
152      * If `target` reverts with a revert reason, it is bubbled up by this
153      * function (like regular Solidity function calls).
154      *
155      * Returns the raw returned data. To convert to the expected return value,
156      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
157      *
158      * Requirements:
159      *
160      * - `target` must be a contract.
161      * - calling `target` with `data` must not revert.
162      *
163      * _Available since v3.1._
164      */
165     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
166         return functionCall(target, data, "Address: low-level call failed");
167     }
168 
169     /**
170      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
171      * `errorMessage` as a fallback revert reason when `target` reverts.
172      *
173      * _Available since v3.1._
174      */
175     function functionCall(
176         address target,
177         bytes memory data,
178         string memory errorMessage
179     ) internal returns (bytes memory) {
180         return functionCallWithValue(target, data, 0, errorMessage);
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
185      * but also transferring `value` wei to `target`.
186      *
187      * Requirements:
188      *
189      * - the calling contract must have an ETH balance of at least `value`.
190      * - the called Solidity function must be `payable`.
191      *
192      * _Available since v3.1._
193      */
194     function functionCallWithValue(
195         address target,
196         bytes memory data,
197         uint256 value
198     ) internal returns (bytes memory) {
199         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
204      * with `errorMessage` as a fallback revert reason when `target` reverts.
205      *
206      * _Available since v3.1._
207      */
208     function functionCallWithValue(
209         address target,
210         bytes memory data,
211         uint256 value,
212         string memory errorMessage
213     ) internal returns (bytes memory) {
214         require(address(this).balance >= value, "Address: insufficient balance for call");
215         require(isContract(target), "Address: call to non-contract");
216 
217         (bool success, bytes memory returndata) = target.call{value: value}(data);
218         return _verifyCallResult(success, returndata, errorMessage);
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
223      * but performing a static call.
224      *
225      * _Available since v3.3._
226      */
227     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
228         return functionStaticCall(target, data, "Address: low-level static call failed");
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
233      * but performing a static call.
234      *
235      * _Available since v3.3._
236      */
237     function functionStaticCall(
238         address target,
239         bytes memory data,
240         string memory errorMessage
241     ) internal view returns (bytes memory) {
242         require(isContract(target), "Address: static call to non-contract");
243 
244         (bool success, bytes memory returndata) = target.staticcall(data);
245         return _verifyCallResult(success, returndata, errorMessage);
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
250      * but performing a delegate call.
251      *
252      * _Available since v3.4._
253      */
254     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
255         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
260      * but performing a delegate call.
261      *
262      * _Available since v3.4._
263      */
264     function functionDelegateCall(
265         address target,
266         bytes memory data,
267         string memory errorMessage
268     ) internal returns (bytes memory) {
269         require(isContract(target), "Address: delegate call to non-contract");
270 
271         (bool success, bytes memory returndata) = target.delegatecall(data);
272         return _verifyCallResult(success, returndata, errorMessage);
273     }
274 
275     function _verifyCallResult(
276         bool success,
277         bytes memory returndata,
278         string memory errorMessage
279     ) private pure returns (bytes memory) {
280         if (success) {
281             return returndata;
282         } else {
283             // Look for revert reason and bubble it up if present
284             if (returndata.length > 0) {
285                 // The easiest way to bubble the revert reason is using memory via assembly
286 
287                 assembly {
288                     let returndata_size := mload(returndata)
289                     revert(add(32, returndata), returndata_size)
290                 }
291             } else {
292                 revert(errorMessage);
293             }
294         }
295     }
296 }
297 
298 /**
299  * @dev String operations.
300  */
301 library Strings {
302     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
303 
304     /**
305      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
306      */
307     function toString(uint256 value) internal pure returns (string memory) {
308         // Inspired by OraclizeAPI's implementation - MIT licence
309         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
310 
311         if (value == 0) {
312             return "0";
313         }
314         uint256 temp = value;
315         uint256 digits;
316         while (temp != 0) {
317             digits++;
318             temp /= 10;
319         }
320         bytes memory buffer = new bytes(digits);
321         while (value != 0) {
322             digits -= 1;
323             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
324             value /= 10;
325         }
326         return string(buffer);
327     }
328 
329     /**
330      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
331      */
332     function toHexString(uint256 value) internal pure returns (string memory) {
333         if (value == 0) {
334             return "0x00";
335         }
336         uint256 temp = value;
337         uint256 length = 0;
338         while (temp != 0) {
339             length++;
340             temp >>= 8;
341         }
342         return toHexString(value, length);
343     }
344 
345     /**
346      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
347      */
348     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
349         bytes memory buffer = new bytes(2 * length + 2);
350         buffer[0] = "0";
351         buffer[1] = "x";
352         for (uint256 i = 2 * length + 1; i > 1; --i) {
353             buffer[i] = _HEX_SYMBOLS[value & 0xf];
354             value >>= 4;
355         }
356         require(value == 0, "Strings: hex length insufficient");
357         return string(buffer);
358     }
359 }
360 
361 /**
362  * @dev Wrappers over Solidity's arithmetic operations with added overflow
363  * checks.
364  *
365  * Arithmetic operations in Solidity wrap on overflow. This can easily result
366  * in bugs, because programmers usually assume that an overflow raises an
367  * error, which is the standard behavior in high level programming languages.
368  * `SafeMath` restores this intuition by reverting the transaction when an
369  * operation overflows.
370  *
371  * Using this library instead of the unchecked operations eliminates an entire
372  * class of bugs, so it's recommended to use it always.
373  *
374  *
375  * @dev original library functions truncated to only needed functions reducing
376  * deployed bytecode.
377  */
378 library SafeMath {
379 
380     /**
381      * @dev Returns the subtraction of two unsigned integers, reverting on
382      * overflow (when the result is negative).
383      *
384      * Counterpart to Solidity's `-` operator.
385      *
386      * Requirements:
387      *
388      * - Subtraction cannot overflow.
389      */
390     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
391         require(b <= a, "SafeMath: subtraction overflow");
392         return a - b;
393     }
394 
395     /**
396      * @dev Returns the multiplication of two unsigned integers, reverting on
397      * overflow.
398      *
399      * Counterpart to Solidity's `*` operator.
400      *
401      * Requirements:
402      *
403      * - Multiplication cannot overflow.
404      */
405     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
406         if (a == 0) return 0;
407         uint256 c = a * b;
408         require(c / a == b, "SafeMath: multiplication overflow");
409         return c;
410     }
411 
412     /**
413      * @dev Returns the integer division of two unsigned integers, reverting on
414      * division by zero. The result is rounded towards zero.
415      *
416      * Counterpart to Solidity's `/` operator. Note: this function uses a
417      * `revert` opcode (which leaves remaining gas untouched) while Solidity
418      * uses an invalid opcode to revert (consuming all remaining gas).
419      *
420      * Requirements:
421      *
422      * - The divisor cannot be zero.
423      */
424     function div(uint256 a, uint256 b) internal pure returns (uint256) {
425         require(b > 0, "SafeMath: division by zero");
426         return a / b;
427     }
428 }
429 
430 /**
431  * @dev Contract module that helps prevent reentrant calls to a function.
432  *
433  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
434  * available, which can be applied to functions to make sure there are no nested
435  * (reentrant) calls to them.
436  *
437  * Note that because there is a single `nonReentrant` guard, functions marked as
438  * `nonReentrant` may not call one another. This can be worked around by making
439  * those functions `private`, and then adding `external` `nonReentrant` entry
440  * points to them.
441  *
442  * TIP: If you would like to learn more about reentrancy and alternative ways
443  * to protect against it, check out our blog post
444  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
445  */
446 abstract contract ReentrancyGuard {
447     // Booleans are more expensive than uint256 or any type that takes up a full
448     // word because each write operation emits an extra SLOAD to first read the
449     // slot's contents, replace the bits taken up by the boolean, and then write
450     // back. This is the compiler's defense against contract upgrades and
451     // pointer aliasing, and it cannot be disabled.
452 
453     // The values being non-zero value makes deployment a bit more expensive,
454     // but in exchange the refund on every call to nonReentrant will be lower in
455     // amount. Since refunds are capped to a percentage of the total
456     // transaction's gas, it is best to keep them low in cases like this one, to
457     // increase the likelihood of the full refund coming into effect.
458     uint256 private constant _NOT_ENTERED = 1;
459     uint256 private constant _ENTERED = 2;
460 
461     uint256 private _status;
462 
463     constructor() {
464         _status = _NOT_ENTERED;
465     }
466 
467     /**
468      * @dev Prevents a contract from calling itself, directly or indirectly.
469      * Calling a `nonReentrant` function from another `nonReentrant`
470      * function is not supported. It is possible to prevent this from happening
471      * by making the `nonReentrant` function external, and make it call a
472      * `private` function that does the actual work.
473      */
474     modifier nonReentrant() {
475         // On the first call to nonReentrant, _notEntered will be true
476         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
477 
478         // Any calls to nonReentrant after this point will fail
479         _status = _ENTERED;
480 
481         _;
482 
483         // By storing the original value once again, a refund is triggered (see
484         // https://eips.ethereum.org/EIPS/eip-2200)
485         _status = _NOT_ENTERED;
486     }
487 }
488 
489 
490 /**
491  * @dev Interface of the ERC165 standard, as defined in the
492  * https://eips.ethereum.org/EIPS/eip-165[EIP].
493  *
494  * Implementers can declare support of contract interfaces, which can then be
495  * queried by others ({ERC165Checker}).
496  *
497  * For an implementation, see {ERC165}.
498  */
499 interface IERC165 {
500     /**
501      * @dev Returns true if this contract implements the interface defined by
502      * `interfaceId`. See the corresponding
503      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
504      * to learn more about how these ids are created.
505      *
506      * This function call must use less than 30 000 gas.
507      */
508     function supportsInterface(bytes4 interfaceId) external view returns (bool);
509 }
510 
511 
512 /**
513  * @dev Implementation of the {IERC165} interface.
514  *
515  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
516  * for the additional interface id that will be supported. For example:
517  *
518  * ```solidity
519  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
520  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
521  * }
522  * ```
523  *
524  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
525  */
526 abstract contract ERC165 is IERC165 {
527     /**
528      * @dev See {IERC165-supportsInterface}.
529      */
530     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
531         return interfaceId == type(IERC165).interfaceId;
532     }
533 }
534 
535 
536 /**
537  * @title ERC721 token receiver interface
538  * @dev Interface for any contract that wants to support safeTransfers
539  * from ERC721 asset contracts.
540  */
541 interface IERC721Receiver {
542     /**
543      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
544      * by `operator` from `from`, this function is called.
545      *
546      * It must return its Solidity selector to confirm the token transfer.
547      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
548      *
549      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
550      */
551     function onERC721Received(
552         address operator,
553         address from,
554         uint256 tokenId,
555         bytes calldata data
556     ) external returns (bytes4);
557 }
558 
559 
560 /**
561  * @dev Required interface of an ERC721 compliant contract.
562  */
563 interface IERC721 is IERC165 {
564     /**
565      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
566      */
567     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
568 
569     /**
570      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
571      */
572     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
573 
574     /**
575      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
576      */
577     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
578 
579     /**
580      * @dev Returns the number of tokens in ``owner``'s account.
581      */
582     function balanceOf(address owner) external view returns (uint256 balance);
583 
584     /**
585      * @dev Returns the owner of the `tokenId` token.
586      *
587      * Requirements:
588      *
589      * - `tokenId` must exist.
590      */
591     function ownerOf(uint256 tokenId) external view returns (address owner);
592 
593     /**
594      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
595      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
596      *
597      * Requirements:
598      *
599      * - `from` cannot be the zero address.
600      * - `to` cannot be the zero address.
601      * - `tokenId` token must exist and be owned by `from`.
602      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
603      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
604      *
605      * Emits a {Transfer} event.
606      */
607     function safeTransferFrom(
608         address from,
609         address to,
610         uint256 tokenId
611     ) external;
612 
613     /**
614      * @dev Transfers `tokenId` token from `from` to `to`.
615      *
616      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
617      *
618      * Requirements:
619      *
620      * - `from` cannot be the zero address.
621      * - `to` cannot be the zero address.
622      * - `tokenId` token must be owned by `from`.
623      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
624      *
625      * Emits a {Transfer} event.
626      */
627     function transferFrom(
628         address from,
629         address to,
630         uint256 tokenId
631     ) external;
632 
633     /**
634      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
635      * The approval is cleared when the token is transferred.
636      *
637      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
638      *
639      * Requirements:
640      *
641      * - The caller must own the token or be an approved operator.
642      * - `tokenId` must exist.
643      *
644      * Emits an {Approval} event.
645      */
646     function approve(address to, uint256 tokenId) external;
647 
648     /**
649      * @dev Returns the account approved for `tokenId` token.
650      *
651      * Requirements:
652      *
653      * - `tokenId` must exist.
654      */
655     function getApproved(uint256 tokenId) external view returns (address operator);
656 
657     /**
658      * @dev Approve or remove `operator` as an operator for the caller.
659      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
660      *
661      * Requirements:
662      *
663      * - The `operator` cannot be the caller.
664      *
665      * Emits an {ApprovalForAll} event.
666      */
667     function setApprovalForAll(address operator, bool _approved) external;
668 
669     /**
670      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
671      *
672      * See {setApprovalForAll}
673      */
674     function isApprovedForAll(address owner, address operator) external view returns (bool);
675 
676     /**
677      * @dev Safely transfers `tokenId` token from `from` to `to`.
678      *
679      * Requirements:
680      *
681      * - `from` cannot be the zero address.
682      * - `to` cannot be the zero address.
683      * - `tokenId` token must exist and be owned by `from`.
684      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
685      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
686      *
687      * Emits a {Transfer} event.
688      */
689     function safeTransferFrom(
690         address from,
691         address to,
692         uint256 tokenId,
693         bytes calldata data
694     ) external;
695 }
696 
697 
698 /**
699  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
700  * @dev See https://eips.ethereum.org/EIPS/eip-721
701  */
702 interface IERC721Enumerable is IERC721 {
703     /**
704      * @dev Returns the total amount of tokens stored by the contract.
705      */
706     function totalSupply() external view returns (uint256);
707 
708     /**
709      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
710      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
711      */
712     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
713 
714     /**
715      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
716      * Use along with {totalSupply} to enumerate all tokens.
717      */
718     function tokenByIndex(uint256 index) external view returns (uint256);
719 }
720 
721 
722 /**
723  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
724  * @dev See https://eips.ethereum.org/EIPS/eip-721
725  */
726 interface IERC721Metadata is IERC721 {
727     /**
728      * @dev Returns the token collection name.
729      */
730     function name() external view returns (string memory);
731 
732     /**
733      * @dev Returns the token collection symbol.
734      */
735     function symbol() external view returns (string memory);
736 
737     /**
738      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
739      */
740     function tokenURI(uint256 tokenId) external view returns (string memory);
741 }
742 
743 
744 /**
745  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
746  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
747  *
748  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
749  *
750  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
751  *
752  * Does not support burning tokens to address(0).
753  */
754 contract ERC721A is
755   Context,
756   ERC165,
757   IERC721,
758   IERC721Metadata,
759   IERC721Enumerable
760 {
761   using Address for address;
762   using Strings for uint256;
763 
764   struct TokenOwnership {
765     address addr;
766     uint64 startTimestamp;
767   }
768 
769   struct AddressData {
770     uint128 balance;
771     uint128 numberMinted;
772   }
773 
774   uint256 private currentIndex = 0;
775 
776   uint256 internal immutable collectionSize;
777   uint256 internal immutable maxBatchSize;
778 
779   // Token name
780   string private _name;
781 
782   // Token symbol
783   string private _symbol;
784 
785   // Mapping from token ID to ownership details
786   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
787   mapping(uint256 => TokenOwnership) private _ownerships;
788 
789   // Mapping owner address to address data
790   mapping(address => AddressData) private _addressData;
791 
792   // Mapping from token ID to approved address
793   mapping(uint256 => address) private _tokenApprovals;
794 
795   // Mapping from owner to operator approvals
796   mapping(address => mapping(address => bool)) private _operatorApprovals;
797 
798   /**
799    * @dev
800    * `maxBatchSize` refers to how much a minter can mint at a time.
801    * `collectionSize_` refers to how many tokens are in the collection.
802    */
803   constructor(
804     string memory name_,
805     string memory symbol_,
806     uint256 maxBatchSize_,
807     uint256 collectionSize_
808   ) {
809     require(
810       collectionSize_ > 0,
811       "ERC721A: collection must have a nonzero supply"
812     );
813     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
814     _name = name_;
815     _symbol = symbol_;
816     maxBatchSize = maxBatchSize_;
817     collectionSize = collectionSize_;
818   }
819 
820   /**
821    * @dev See {IERC721Enumerable-totalSupply}.
822    */
823   function totalSupply() public view override returns (uint256) {
824     return currentIndex;
825   }
826 
827   /**
828    * @dev See {IERC721Enumerable-tokenByIndex}.
829    */
830   function tokenByIndex(uint256 index) public view override returns (uint256) {
831     require(index < totalSupply(), "ERC721A: global index out of bounds");
832     return index;
833   }
834 
835   /**
836    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
837    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
838    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
839    */
840   function tokenOfOwnerByIndex(address owner, uint256 index)
841     public
842     view
843     override
844     returns (uint256)
845   {
846     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
847     uint256 numMintedSoFar = totalSupply();
848     uint256 tokenIdsIdx = 0;
849     address currOwnershipAddr = address(0);
850     for (uint256 i = 0; i < numMintedSoFar; i++) {
851       TokenOwnership memory ownership = _ownerships[i];
852       if (ownership.addr != address(0)) {
853         currOwnershipAddr = ownership.addr;
854       }
855       if (currOwnershipAddr == owner) {
856         if (tokenIdsIdx == index) {
857           return i;
858         }
859         tokenIdsIdx++;
860       }
861     }
862     revert("ERC721A: unable to get token of owner by index");
863   }
864 
865   /**
866    * @dev See {IERC165-supportsInterface}.
867    */
868   function supportsInterface(bytes4 interfaceId)
869     public
870     view
871     virtual
872     override(ERC165, IERC165)
873     returns (bool)
874   {
875     return
876       interfaceId == type(IERC721).interfaceId ||
877       interfaceId == type(IERC721Metadata).interfaceId ||
878       interfaceId == type(IERC721Enumerable).interfaceId ||
879       super.supportsInterface(interfaceId);
880   }
881 
882   /**
883    * @dev See {IERC721-balanceOf}.
884    */
885   function balanceOf(address owner) public view override returns (uint256) {
886     require(owner != address(0), "ERC721A: balance query for the zero address");
887     return uint256(_addressData[owner].balance);
888   }
889 
890   function _numberMinted(address owner) internal view returns (uint256) {
891     require(
892       owner != address(0),
893       "ERC721A: number minted query for the zero address"
894     );
895     return uint256(_addressData[owner].numberMinted);
896   }
897 
898   function ownershipOf(uint256 tokenId)
899     internal
900     view
901     returns (TokenOwnership memory)
902   {
903     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
904 
905     uint256 lowestTokenToCheck;
906     if (tokenId >= maxBatchSize) {
907       lowestTokenToCheck = tokenId - maxBatchSize + 1;
908     }
909 
910     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
911       TokenOwnership memory ownership = _ownerships[curr];
912       if (ownership.addr != address(0)) {
913         return ownership;
914       }
915     }
916 
917     revert("ERC721A: unable to determine the owner of token");
918   }
919 
920   /**
921    * @dev See {IERC721-ownerOf}.
922    */
923   function ownerOf(uint256 tokenId) public view override returns (address) {
924     return ownershipOf(tokenId).addr;
925   }
926 
927   /**
928    * @dev See {IERC721Metadata-name}.
929    */
930   function name() public view virtual override returns (string memory) {
931     return _name;
932   }
933 
934   /**
935    * @dev See {IERC721Metadata-symbol}.
936    */
937   function symbol() public view virtual override returns (string memory) {
938     return _symbol;
939   }
940 
941   /**
942    * @dev See {IERC721Metadata-tokenURI}.
943    */
944   function tokenURI(uint256 tokenId)
945     public
946     view
947     virtual
948     override
949     returns (string memory)
950   {
951     require(
952       _exists(tokenId),
953       "ERC721Metadata: URI query for nonexistent token"
954     );
955 
956     string memory baseURI = _baseURI();
957     return
958       bytes(baseURI).length > 0
959         ? string(abi.encodePacked(baseURI, tokenId.toString()))
960         : "";
961   }
962 
963   /**
964    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
965    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
966    * by default, can be overriden in child contracts.
967    */
968   function _baseURI() internal view virtual returns (string memory) {
969     return "";
970   }
971 
972   /**
973    * @dev See {IERC721-approve}.
974    */
975   function approve(address to, uint256 tokenId) public override {
976     address owner = ERC721A.ownerOf(tokenId);
977     require(to != owner, "ERC721A: approval to current owner");
978 
979     require(
980       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
981       "ERC721A: approve caller is not owner nor approved for all"
982     );
983 
984     _approve(to, tokenId, owner);
985   }
986 
987   /**
988    * @dev See {IERC721-getApproved}.
989    */
990   function getApproved(uint256 tokenId) public view override returns (address) {
991     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
992 
993     return _tokenApprovals[tokenId];
994   }
995 
996   /**
997    * @dev See {IERC721-setApprovalForAll}.
998    */
999   function setApprovalForAll(address operator, bool approved) public override {
1000     require(operator != _msgSender(), "ERC721A: approve to caller");
1001 
1002     _operatorApprovals[_msgSender()][operator] = approved;
1003     emit ApprovalForAll(_msgSender(), operator, approved);
1004   }
1005 
1006   /**
1007    * @dev See {IERC721-isApprovedForAll}.
1008    */
1009   function isApprovedForAll(address owner, address operator)
1010     public
1011     view
1012     virtual
1013     override
1014     returns (bool)
1015   {
1016     return _operatorApprovals[owner][operator];
1017   }
1018 
1019   /**
1020    * @dev See {IERC721-transferFrom}.
1021    */
1022   function transferFrom(
1023     address from,
1024     address to,
1025     uint256 tokenId
1026   ) public override {
1027     _transfer(from, to, tokenId);
1028   }
1029 
1030   /**
1031    * @dev See {IERC721-safeTransferFrom}.
1032    */
1033   function safeTransferFrom(
1034     address from,
1035     address to,
1036     uint256 tokenId
1037   ) public override {
1038     safeTransferFrom(from, to, tokenId, "");
1039   }
1040 
1041   /**
1042    * @dev See {IERC721-safeTransferFrom}.
1043    */
1044   function safeTransferFrom(
1045     address from,
1046     address to,
1047     uint256 tokenId,
1048     bytes memory _data
1049   ) public override {
1050     _transfer(from, to, tokenId);
1051     require(
1052       _checkOnERC721Received(from, to, tokenId, _data),
1053       "ERC721A: transfer to non ERC721Receiver implementer"
1054     );
1055   }
1056 
1057   /**
1058    * @dev Returns whether `tokenId` exists.
1059    *
1060    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1061    *
1062    * Tokens start existing when they are minted (`_mint`),
1063    */
1064   function _exists(uint256 tokenId) internal view returns (bool) {
1065     return tokenId < currentIndex;
1066   }
1067 
1068   function _safeMint(address to, uint256 quantity) internal {
1069     _safeMint(to, quantity, "");
1070   }
1071 
1072   /**
1073    * @dev Mints `quantity` tokens and transfers them to `to`.
1074    *
1075    * Requirements:
1076    *
1077    * - there must be `quantity` tokens remaining unminted in the total collection.
1078    * - `to` cannot be the zero address.
1079    * - `quantity` cannot be larger than the max batch size.
1080    *
1081    * Emits a {Transfer} event.
1082    */
1083   function _safeMint(
1084     address to,
1085     uint256 quantity,
1086     bytes memory _data
1087   ) internal {
1088     uint256 startTokenId = currentIndex;
1089     require(to != address(0), "ERC721A: mint to the zero address");
1090     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1091     require(!_exists(startTokenId), "ERC721A: token already minted");
1092     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1093 
1094     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1095 
1096     AddressData memory addressData = _addressData[to];
1097     _addressData[to] = AddressData(
1098       addressData.balance + uint128(quantity),
1099       addressData.numberMinted + uint128(quantity)
1100     );
1101     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1102 
1103     uint256 updatedIndex = startTokenId;
1104 
1105     for (uint256 i = 0; i < quantity; i++) {
1106       emit Transfer(address(0), to, updatedIndex);
1107       require(
1108         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1109         "ERC721A: transfer to non ERC721Receiver implementer"
1110       );
1111       updatedIndex++;
1112     }
1113 
1114     currentIndex = updatedIndex;
1115     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1116   }
1117 
1118   /**
1119    * @dev Transfers `tokenId` from `from` to `to`.
1120    *
1121    * Requirements:
1122    *
1123    * - `to` cannot be the zero address.
1124    * - `tokenId` token must be owned by `from`.
1125    *
1126    * Emits a {Transfer} event.
1127    */
1128   function _transfer(
1129     address from,
1130     address to,
1131     uint256 tokenId
1132   ) private {
1133     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1134 
1135     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1136       getApproved(tokenId) == _msgSender() ||
1137       isApprovedForAll(prevOwnership.addr, _msgSender()));
1138 
1139     require(
1140       isApprovedOrOwner,
1141       "ERC721A: transfer caller is not owner nor approved"
1142     );
1143 
1144     require(
1145       prevOwnership.addr == from,
1146       "ERC721A: transfer from incorrect owner"
1147     );
1148     require(to != address(0), "ERC721A: transfer to the zero address");
1149 
1150     _beforeTokenTransfers(from, to, tokenId, 1);
1151 
1152     // Clear approvals from the previous owner
1153     _approve(address(0), tokenId, prevOwnership.addr);
1154 
1155     _addressData[from].balance -= 1;
1156     _addressData[to].balance += 1;
1157     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1158 
1159     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1160     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1161     uint256 nextTokenId = tokenId + 1;
1162     if (_ownerships[nextTokenId].addr == address(0)) {
1163       if (_exists(nextTokenId)) {
1164         _ownerships[nextTokenId] = TokenOwnership(
1165           prevOwnership.addr,
1166           prevOwnership.startTimestamp
1167         );
1168       }
1169     }
1170 
1171     emit Transfer(from, to, tokenId);
1172     _afterTokenTransfers(from, to, tokenId, 1);
1173   }
1174 
1175   /**
1176    * @dev Approve `to` to operate on `tokenId`
1177    *
1178    * Emits a {Approval} event.
1179    */
1180   function _approve(
1181     address to,
1182     uint256 tokenId,
1183     address owner
1184   ) private {
1185     _tokenApprovals[tokenId] = to;
1186     emit Approval(owner, to, tokenId);
1187   }
1188 
1189   uint256 public nextOwnerToExplicitlySet = 0;
1190 
1191   /**
1192    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1193    */
1194   function _setOwnersExplicit(uint256 quantity) internal {
1195     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1196     require(quantity > 0, "quantity must be nonzero");
1197     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1198     if (endIndex > collectionSize - 1) {
1199       endIndex = collectionSize - 1;
1200     }
1201     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1202     require(_exists(endIndex), "not enough minted yet for this cleanup");
1203     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1204       if (_ownerships[i].addr == address(0)) {
1205         TokenOwnership memory ownership = ownershipOf(i);
1206         _ownerships[i] = TokenOwnership(
1207           ownership.addr,
1208           ownership.startTimestamp
1209         );
1210       }
1211     }
1212     nextOwnerToExplicitlySet = endIndex + 1;
1213   }
1214 
1215   /**
1216    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1217    * The call is not executed if the target address is not a contract.
1218    *
1219    * @param from address representing the previous owner of the given token ID
1220    * @param to target address that will receive the tokens
1221    * @param tokenId uint256 ID of the token to be transferred
1222    * @param _data bytes optional data to send along with the call
1223    * @return bool whether the call correctly returned the expected magic value
1224    */
1225   function _checkOnERC721Received(
1226     address from,
1227     address to,
1228     uint256 tokenId,
1229     bytes memory _data
1230   ) private returns (bool) {
1231     if (to.isContract()) {
1232       try
1233         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1234       returns (bytes4 retval) {
1235         return retval == IERC721Receiver(to).onERC721Received.selector;
1236       } catch (bytes memory reason) {
1237         if (reason.length == 0) {
1238           revert("ERC721A: transfer to non ERC721Receiver implementer");
1239         } else {
1240           assembly {
1241             revert(add(32, reason), mload(reason))
1242           }
1243         }
1244       }
1245     } else {
1246       return true;
1247     }
1248   }
1249 
1250   /**
1251    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1252    *
1253    * startTokenId - the first token id to be transferred
1254    * quantity - the amount to be transferred
1255    *
1256    * Calling conditions:
1257    *
1258    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1259    * transferred to `to`.
1260    * - When `from` is zero, `tokenId` will be minted for `to`.
1261    */
1262   function _beforeTokenTransfers(
1263     address from,
1264     address to,
1265     uint256 startTokenId,
1266     uint256 quantity
1267   ) internal virtual {}
1268 
1269   /**
1270    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1271    * minting.
1272    *
1273    * startTokenId - the first token id to be transferred
1274    * quantity - the amount to be transferred
1275    *
1276    * Calling conditions:
1277    *
1278    * - when `from` and `to` are both non-zero.
1279    * - `from` and `to` are never both zero.
1280    */
1281   function _afterTokenTransfers(
1282     address from,
1283     address to,
1284     uint256 startTokenId,
1285     uint256 quantity
1286   ) internal virtual {}
1287 }
1288 
1289 contract MechGame is Ownable, ERC721A, ReentrancyGuard {
1290   using SafeMath for uint256;
1291 
1292   uint256 public immutable maxPerAddressDuringMint;
1293   uint256 public immutable amountForDevs;
1294   uint256 public immutable amountForSaleAndDev;
1295 
1296   uint256 public maxWhitelistMints;
1297   uint256 public maxPublicMintsPerTxn;
1298 
1299   address payoutWallet1;
1300   address payoutWallet2;
1301 
1302   uint256 bytPayoutPercentage;
1303 
1304   uint256 public saleStartTime;
1305   uint256 public whitelistStartTime;
1306   uint256 public goldlistStartTime;
1307 
1308 
1309   uint256 public publicSaleCost;
1310   uint256 public whitelistSaleCost;
1311 
1312   //Using an array of mappings to track whitelist mints for wallets
1313   mapping(address => uint256) public whitelistMints;
1314   //Using an array of mappings to track goldlist mints for wallets
1315   mapping(address => uint256) public goldlistMints;
1316   
1317   bytes32[] _whitelistRootHash;
1318   bytes32[] _goldlistRootHash;
1319 
1320   constructor(
1321     uint256 maxBatchSize_,
1322     uint256 collectionSize_,
1323     uint256 amountForAuctionAndDev_,
1324     uint256 amountForDevs_
1325   ) ERC721A("Mech Game", "MECH", maxBatchSize_, collectionSize_) {
1326     maxPerAddressDuringMint = maxBatchSize_;
1327     amountForSaleAndDev = amountForAuctionAndDev_;
1328     amountForDevs = amountForDevs_;
1329     require(
1330       amountForAuctionAndDev_ <= collectionSize_,
1331       "larger collection size needed"
1332     );
1333     publicSaleCost = 0.28 ether;
1334     whitelistSaleCost = 0.25 ether;
1335     bytPayoutPercentage = 10;
1336     maxWhitelistMints = 10;
1337     maxPublicMintsPerTxn = 10;
1338     payoutWallet1 = address(0x0d362FDeBFAF0F2da880AeADfBCa410CD160E4dc); // mech.game payout wallet
1339     payoutWallet2 = address(0x02dF807d510ce365D4bB454851Af2d159c3f9D1c ); // byt payout wallet
1340   }
1341 
1342   function addToWhitelistRootHash(bytes32 _hash) public onlyOwner{
1343         _whitelistRootHash.push(_hash);
1344     }
1345 
1346   function addToGoldlistRootHash(bytes32 _hash) public onlyOwner{
1347       _goldlistRootHash.push(_hash);
1348   }
1349 
1350   function clearWhitelist() external onlyOwner{
1351     delete _whitelistRootHash;
1352   }
1353 
1354   function clearGoldlist() external onlyOwner{
1355     delete _goldlistRootHash;
1356   }
1357 
1358   function updatePayoutWallet(bool bytWallet, address _newPayoutWallet) external onlyOwner{
1359     if(bytWallet)
1360     {
1361       payoutWallet2 = _newPayoutWallet;
1362     }
1363     else{
1364       payoutWallet1 = _newPayoutWallet;
1365     }
1366   }
1367 
1368   function setWhitelistStartTime(uint256 _time) external onlyOwner {
1369     whitelistStartTime = _time;
1370     goldlistStartTime = _time;
1371   }
1372 
1373   function setGoldlistStartTimeExplicit(uint256 _time) external onlyOwner{
1374     goldlistStartTime = _time;
1375   }
1376 
1377   function setSaleStartTime(uint256 _time) external onlyOwner {
1378     saleStartTime = _time;
1379   }
1380 
1381   function setWhitelistSaleCost(uint256 _cost) public onlyOwner{
1382     whitelistSaleCost = _cost;
1383   }
1384 
1385   function setPublicSaleCost(uint256 _cost) external onlyOwner {
1386     publicSaleCost = _cost;
1387   }
1388 
1389    // Merkle leaf validator function for storing whitelists off chain saving massive gas
1390   function whitelistValidated(address wallet, uint256 index, bytes32[] memory proof) internal view returns (bool) {
1391         uint256 amount = 1;
1392 
1393         // Compute the merkle root
1394         bytes32 node = keccak256(abi.encodePacked(index, wallet, amount));
1395         uint256 path = index;
1396         for (uint16 i = 0; i < proof.length; i++) {
1397             if ((path & 0x01) == 1) {
1398                 node = keccak256(abi.encodePacked(proof[i], node));
1399             } else {
1400                 node = keccak256(abi.encodePacked(node, proof[i]));
1401             }
1402             path /= 2;
1403         }
1404 
1405         // Check the merkle proof against the root hash array
1406         for(uint i = 0; i < _whitelistRootHash.length; i++)
1407         {
1408             if (node == _whitelistRootHash[i])
1409             {
1410                 return true;
1411             }
1412         }
1413 
1414         return false;
1415     }
1416 
1417     // Merkle leaf validator function for storing goldlists off chain saving massive gas
1418   function goldlistValidated(address wallet, uint256 quantity, uint256 index, bytes32[] memory proof) internal view returns (bool) {
1419         // Compute the merkle root
1420         bytes32 node = keccak256(abi.encodePacked(index, wallet, quantity));
1421         uint256 path = index;
1422         for (uint16 i = 0; i < proof.length; i++) {
1423             if ((path & 0x01) == 1) {
1424                 node = keccak256(abi.encodePacked(proof[i], node));
1425             } else {
1426                 node = keccak256(abi.encodePacked(node, proof[i]));
1427             }
1428             path /= 2;
1429         }
1430 
1431         // Check the merkle proof against the root hash array
1432         for(uint i = 0; i < _goldlistRootHash.length; i++)
1433         {
1434             if (node == _goldlistRootHash[i])
1435             {
1436                 return true;
1437             }
1438         }
1439 
1440         return false;
1441     }
1442 
1443   function publicMint(uint256 quantity) external payable {
1444     require(saleStartTime != 0 && block.timestamp >= saleStartTime, "sale has not started yet");
1445     require(totalSupply() + quantity <= amountForSaleAndDev, "not enough remaining reserved for auction to support desired mint amount");
1446     require(quantity < maxPublicMintsPerTxn, "Can't mint that many in a single transaction");
1447 
1448     uint256 totalCost = publicSaleCost * quantity;
1449     _safeMint(_msgSender(), quantity);
1450     refundIfOver(totalCost);
1451   }
1452 
1453   function goldlistMint(uint256 quantity, uint256 spotInWhitelist, bytes32[] memory proof) external {
1454     require(goldlistValidated(_msgSender(), quantity, spotInWhitelist, proof), "You're not on the goldlist");
1455     require(whitelistStartTime != 0 && block.timestamp >= whitelistStartTime, "The sale has not started yet");
1456     require(totalSupply() + quantity <= amountForSaleAndDev, "not enough remaining reserved for auction to support desired mint amount");
1457     require(goldlistMints[_msgSender()] == 0, "This address already goldlist minted");
1458 
1459     goldlistMints[_msgSender()] == 1;
1460 
1461     _safeMint(_msgSender(), quantity);
1462   }
1463 
1464   function whitelistMint(uint256 quantity, uint256 spotInWhitelist, bytes32[] memory proof) external payable {
1465     require(whitelistValidated(_msgSender(), spotInWhitelist, proof), "You're not on the whitelist");
1466     require(whitelistStartTime != 0 && block.timestamp >= whitelistStartTime, "The sale has not started yet");
1467     require(totalSupply() + quantity <= amountForSaleAndDev, "not enough remaining reserved for auction to support desired mint amount");
1468     require(whitelistMints[_msgSender()] + quantity <= maxWhitelistMints, "Too many whitelist mints during this round");
1469 
1470     whitelistMints[_msgSender()] += quantity;
1471 
1472     _safeMint(_msgSender(), quantity);
1473     refundIfOver(whitelistSaleCost * quantity);
1474   }
1475 
1476   function mintTo(address to, uint _count) external payable {
1477      require(whitelistStartTime != 0 && block.timestamp >= whitelistStartTime, "The sale has not started yet");
1478      // Fiat Restriction
1479      require(msg.sender == address(0xdAb1a1854214684acE522439684a145E62505233), "This function can be called by the Fiat onramp address only.");
1480      require(totalSupply() + _count <= amountForSaleAndDev, "not enough remaining reserved for auction to support desired fiat mint amount");
1481 
1482      uint256 cost = getCurrentCost();
1483      
1484      _safeMint(to, _count);
1485      refundIfOver(cost * _count);
1486  }
1487 
1488   function refundIfOver(uint256 price) private {
1489     require(msg.value >= price, "Need to send more ETH.");
1490     if (msg.value > price) {
1491       payable(_msgSender()).transfer(msg.value - price);
1492     }
1493   }
1494 
1495   function getCurrentCost() public view returns (uint256) {
1496     if(saleStartTime != 0 && block.timestamp >= saleStartTime) {
1497       return publicSaleCost;
1498     }
1499     else {
1500       return whitelistSaleCost;
1501     }
1502   }
1503 
1504   // For marketing etc.
1505   function devMint(uint256 quantity, address _To) external onlyOwner {
1506     require(totalSupply() + quantity <= amountForDevs, "too many already minted before dev mint");
1507     require(quantity % maxBatchSize == 0, "can only mint a multiple of the maxBatchSize");
1508     uint256 numChunks = quantity / maxBatchSize;
1509     for (uint256 i = 0; i < numChunks; i++) {
1510       _safeMint(_To, maxBatchSize);
1511     }
1512   }
1513 
1514   // metadata URI
1515   string private _baseTokenURI;
1516 
1517   function _baseURI() internal view virtual override returns (string memory) {
1518     return _baseTokenURI;
1519   }
1520 
1521   function setBaseURI(string calldata baseURI) external onlyOwner {
1522     _baseTokenURI = baseURI;
1523   }
1524 
1525   // Standard withdraw function that only executes when both wallets are set
1526   function withdraw() external onlyOwner {
1527         require(payoutWallet1 != address(0), "wallet 1 not set");
1528         require(payoutWallet2 != address(0), "wallet 2 not set");
1529         uint256 balance = address(this).balance;
1530         uint256 walletBalance = balance.mul(100 - bytPayoutPercentage).div(100);
1531         payable(payoutWallet1).transfer(walletBalance);
1532         payable(payoutWallet2).transfer(balance.sub(walletBalance));
1533     }
1534 
1535   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1536     _setOwnersExplicit(quantity);
1537   }
1538 
1539   function numberMinted(address owner) public view returns (uint256) {
1540     return _numberMinted(owner);
1541   }
1542 
1543   function getOwnershipData(uint256 tokenId)
1544     external
1545     view
1546     returns (TokenOwnership memory)
1547   {
1548     return ownershipOf(tokenId);
1549   }
1550 }