1 //Need help creating your nft collection? 
2 //Contact thrasher66099@gmail.com
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 
28 /**
29  * @dev Required interface of an ERC721 compliant contract.
30  */
31 interface IERC721 is IERC165 {
32     /**
33      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
34      */
35     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
36 
37     /**
38      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
39      */
40     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
41 
42     /**
43      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
44      */
45     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
46 
47     /**
48      * @dev Returns the number of tokens in ``owner``'s account.
49      */
50     function balanceOf(address owner) external view returns (uint256 balance);
51 
52     /**
53      * @dev Returns the owner of the `tokenId` token.
54      *
55      * Requirements:
56      *
57      * - `tokenId` must exist.
58      */
59     function ownerOf(uint256 tokenId) external view returns (address owner);
60 
61     /**
62      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
63      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
64      *
65      * Requirements:
66      *
67      * - `from` cannot be the zero address.
68      * - `to` cannot be the zero address.
69      * - `tokenId` token must exist and be owned by `from`.
70      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
71      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
72      *
73      * Emits a {Transfer} event.
74      */
75     function safeTransferFrom(
76         address from,
77         address to,
78         uint256 tokenId
79     ) external;
80 
81     /**
82      * @dev Transfers `tokenId` token from `from` to `to`.
83      *
84      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
85      *
86      * Requirements:
87      *
88      * - `from` cannot be the zero address.
89      * - `to` cannot be the zero address.
90      * - `tokenId` token must be owned by `from`.
91      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transferFrom(
96         address from,
97         address to,
98         uint256 tokenId
99     ) external;
100 
101     /**
102      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
103      * The approval is cleared when the token is transferred.
104      *
105      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
106      *
107      * Requirements:
108      *
109      * - The caller must own the token or be an approved operator.
110      * - `tokenId` must exist.
111      *
112      * Emits an {Approval} event.
113      */
114     function approve(address to, uint256 tokenId) external;
115 
116     /**
117      * @dev Returns the account approved for `tokenId` token.
118      *
119      * Requirements:
120      *
121      * - `tokenId` must exist.
122      */
123     function getApproved(uint256 tokenId) external view returns (address operator);
124 
125     /**
126      * @dev Approve or remove `operator` as an operator for the caller.
127      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
128      *
129      * Requirements:
130      *
131      * - The `operator` cannot be the caller.
132      *
133      * Emits an {ApprovalForAll} event.
134      */
135     function setApprovalForAll(address operator, bool _approved) external;
136 
137     /**
138      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
139      *
140      * See {setApprovalForAll}
141      */
142     function isApprovedForAll(address owner, address operator) external view returns (bool);
143 
144     /**
145      * @dev Safely transfers `tokenId` token from `from` to `to`.
146      *
147      * Requirements:
148      *
149      * - `from` cannot be the zero address.
150      * - `to` cannot be the zero address.
151      * - `tokenId` token must exist and be owned by `from`.
152      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
153      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
154      *
155      * Emits a {Transfer} event.
156      */
157     function safeTransferFrom(
158         address from,
159         address to,
160         uint256 tokenId,
161         bytes calldata data
162     ) external;
163 }
164 
165 
166 
167 /**
168  * @dev String operations.
169  */
170 library Strings {
171 
172     /**
173      * @dev Custom toString function
174      */
175     function toString(uint256 _i) internal pure returns (string memory) {
176 
177         if (_i == 0) {
178             return "0";
179         }
180         uint j = _i;
181         uint len;
182         while (j != 0) {
183             len++;
184             j /= 10;
185         }
186         bytes memory bstr = new bytes(len);
187         uint k = len;
188         while (_i != 0) {
189             k = k-1;
190             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
191             bytes1 b1 = bytes1(temp);
192             bstr[k] = b1;
193             _i /= 10;
194         }
195         return string(bstr);
196     }
197 
198 }
199 
200 
201 /*
202  * @dev Provides information about the current execution context, including the
203  * sender of the transaction and its data. While these are generally available
204  * via msg.sender and msg.data, they should not be accessed in such a direct
205  * manner, since when dealing with meta-transactions the account sending and
206  * paying for execution may not be the actual sender (as far as an application
207  * is concerned).
208  *
209  * This contract is only required for intermediate, library-like contracts.
210  */
211 abstract contract Context {
212     function _msgSender() internal view virtual returns (address) {
213         return msg.sender;
214     }
215 
216     function _msgData() internal view virtual returns (bytes calldata) {
217         return msg.data;
218     }
219 }
220 
221 
222 /**
223  * @dev Contract module which provides a basic access control mechanism, where
224  * there is an account (an owner) that can be granted exclusive access to
225  * specific functions.
226  *
227  * By default, the owner account will be the one that deploys the contract. This
228  * can later be changed with {transferOwnership}.
229  *
230  * This module is used through inheritance. It will make available the modifier
231  * `onlyOwner`, which can be applied to your functions to restrict their use to
232  * the owner.
233  */
234 abstract contract Ownable is Context {
235     address private _owner;
236 
237     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
238 
239     /**
240      * @dev Initializes the contract setting the deployer as the initial owner.
241      */
242     constructor() {
243         _setOwner(_msgSender());
244     }
245 
246     /**
247      * @dev Returns the address of the current owner.
248      */
249     function owner() public view virtual returns (address) {
250         return _owner;
251     }
252 
253     /**
254      * @dev Throws if called by any account other than the owner.
255      */
256     modifier onlyOwner() {
257         require(owner() == _msgSender(), "Ownable: caller is not the owner");
258         _;
259     }
260 
261     /**
262      * @dev Leaves the contract without owner. It will not be possible to call
263      * `onlyOwner` functions anymore. Can only be called by the current owner.
264      *
265      * NOTE: Renouncing ownership will leave the contract without an owner,
266      * thereby removing any functionality that is only available to the owner.
267      */
268     function renounceOwnership() public virtual onlyOwner {
269         _setOwner(address(0));
270     }
271 
272     /**
273      * @dev Transfers ownership of the contract to a new account (`newOwner`).
274      * Can only be called by the current owner.
275      */
276     function transferOwnership(address newOwner) public virtual onlyOwner {
277         require(newOwner != address(0), "Ownable: new owner is the zero address");
278         _setOwner(newOwner);
279     }
280 
281     function _setOwner(address newOwner) private {
282         address oldOwner = _owner;
283         _owner = newOwner;
284         emit OwnershipTransferred(oldOwner, newOwner);
285     }
286 }
287 
288 
289 /**
290  * @dev Contract module that helps prevent reentrant calls to a function.
291  *
292  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
293  * available, which can be applied to functions to make sure there are no nested
294  * (reentrant) calls to them.
295  *
296  * Note that because there is a single `nonReentrant` guard, functions marked as
297  * `nonReentrant` may not call one another. This can be worked around by making
298  * those functions `private`, and then adding `external` `nonReentrant` entry
299  * points to them.
300  *
301  * TIP: If you would like to learn more about reentrancy and alternative ways
302  * to protect against it, check out our blog post
303  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
304  */
305 abstract contract ReentrancyGuard {
306     // Booleans are more expensive than uint256 or any type that takes up a full
307     // word because each write operation emits an extra SLOAD to first read the
308     // slot's contents, replace the bits taken up by the boolean, and then write
309     // back. This is the compiler's defense against contract upgrades and
310     // pointer aliasing, and it cannot be disabled.
311 
312     // The values being non-zero value makes deployment a bit more expensive,
313     // but in exchange the refund on every call to nonReentrant will be lower in
314     // amount. Since refunds are capped to a percentage of the total
315     // transaction's gas, it is best to keep them low in cases like this one, to
316     // increase the likelihood of the full refund coming into effect.
317     uint256 private constant _NOT_ENTERED = 1;
318     uint256 private constant _ENTERED = 2;
319 
320     uint256 private _status;
321 
322     constructor() {
323         _status = _NOT_ENTERED;
324     }
325 
326     /**
327      * @dev Prevents a contract from calling itself, directly or indirectly.
328      * Calling a `nonReentrant` function from another `nonReentrant`
329      * function is not supported. It is possible to prevent this from happening
330      * by making the `nonReentrant` function external, and make it call a
331      * `private` function that does the actual work.
332      */
333     modifier nonReentrant() {
334         // On the first call to nonReentrant, _notEntered will be true
335         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
336 
337         // Any calls to nonReentrant after this point will fail
338         _status = _ENTERED;
339 
340         _;
341 
342         // By storing the original value once again, a refund is triggered (see
343         // https://eips.ethereum.org/EIPS/eip-2200)
344         _status = _NOT_ENTERED;
345     }
346 }
347 
348 
349 
350 /**
351  * @title ERC721 token receiver interface
352  * @dev Interface for any contract that wants to support safeTransfers
353  * from ERC721 asset contracts.
354  */
355 interface IERC721Receiver {
356     /**
357      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
358      * by `operator` from `from`, this function is called.
359      *
360      * It must return its Solidity selector to confirm the token transfer.
361      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
362      *
363      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
364      */
365     function onERC721Received(
366         address operator,
367         address from,
368         uint256 tokenId,
369         bytes calldata data
370     ) external returns (bytes4);
371 }
372 
373 
374 /**
375  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
376  * @dev See https://eips.ethereum.org/EIPS/eip-721
377  */
378 interface IERC721Metadata is IERC721 {
379     /**
380      * @dev Returns the token collection name.
381      */
382     function name() external view returns (string memory);
383 
384     /**
385      * @dev Returns the token collection symbol.
386      */
387     function symbol() external view returns (string memory);
388 
389     /**
390      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
391      */
392     function tokenURI(uint256 tokenId) external view returns (string memory);
393 }
394 
395 
396 /**
397  * @dev Collection of functions related to the address type
398  */
399 library Address {
400     /**
401      * @dev Returns true if `account` is a contract.
402      *
403      * [IMPORTANT]
404      * ====
405      * It is unsafe to assume that an address for which this function returns
406      * false is an externally-owned account (EOA) and not a contract.
407      *
408      * Among others, `isContract` will return false for the following
409      * types of addresses:
410      *
411      *  - an externally-owned account
412      *  - a contract in construction
413      *  - an address where a contract will be created
414      *  - an address where a contract lived, but was destroyed
415      * ====
416      */
417     function isContract(address account) internal view returns (bool) {
418         // This method relies on extcodesize, which returns 0 for contracts in
419         // construction, since the code is only stored at the end of the
420         // constructor execution.
421 
422         uint256 size;
423         assembly {
424             size := extcodesize(account)
425         }
426         return size > 0;
427     }
428 
429     /**
430      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
431      * `recipient`, forwarding all available gas and reverting on errors.
432      *
433      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
434      * of certain opcodes, possibly making contracts go over the 2300 gas limit
435      * imposed by `transfer`, making them unable to receive funds via
436      * `transfer`. {sendValue} removes this limitation.
437      *
438      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
439      *
440      * IMPORTANT: because control is transferred to `recipient`, care must be
441      * taken to not create reentrancy vulnerabilities. Consider using
442      * {ReentrancyGuard} or the
443      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
444      */
445     function sendValue(address payable recipient, uint256 amount) internal {
446         require(address(this).balance >= amount, "Address: insufficient balance");
447 
448         (bool success, ) = recipient.call{value: amount}("");
449         require(success, "Address: unable to send value, recipient may have reverted");
450     }
451 
452     /**
453      * @dev Performs a Solidity function call using a low level `call`. A
454      * plain `call` is an unsafe replacement for a function call: use this
455      * function instead.
456      *
457      * If `target` reverts with a revert reason, it is bubbled up by this
458      * function (like regular Solidity function calls).
459      *
460      * Returns the raw returned data. To convert to the expected return value,
461      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
462      *
463      * Requirements:
464      *
465      * - `target` must be a contract.
466      * - calling `target` with `data` must not revert.
467      *
468      * _Available since v3.1._
469      */
470     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
471         return functionCall(target, data, "Address: low-level call failed");
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
476      * `errorMessage` as a fallback revert reason when `target` reverts.
477      *
478      * _Available since v3.1._
479      */
480     function functionCall(
481         address target,
482         bytes memory data,
483         string memory errorMessage
484     ) internal returns (bytes memory) {
485         return functionCallWithValue(target, data, 0, errorMessage);
486     }
487 
488     /**
489      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
490      * but also transferring `value` wei to `target`.
491      *
492      * Requirements:
493      *
494      * - the calling contract must have an ETH balance of at least `value`.
495      * - the called Solidity function must be `payable`.
496      *
497      * _Available since v3.1._
498      */
499     function functionCallWithValue(
500         address target,
501         bytes memory data,
502         uint256 value
503     ) internal returns (bytes memory) {
504         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
505     }
506 
507     /**
508      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
509      * with `errorMessage` as a fallback revert reason when `target` reverts.
510      *
511      * _Available since v3.1._
512      */
513     function functionCallWithValue(
514         address target,
515         bytes memory data,
516         uint256 value,
517         string memory errorMessage
518     ) internal returns (bytes memory) {
519         require(address(this).balance >= value, "Address: insufficient balance for call");
520         require(isContract(target), "Address: call to non-contract");
521 
522         (bool success, bytes memory returndata) = target.call{value: value}(data);
523         return _verifyCallResult(success, returndata, errorMessage);
524     }
525 
526     /**
527      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
528      * but performing a static call.
529      *
530      * _Available since v3.3._
531      */
532     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
533         return functionStaticCall(target, data, "Address: low-level static call failed");
534     }
535 
536     /**
537      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
538      * but performing a static call.
539      *
540      * _Available since v3.3._
541      */
542     function functionStaticCall(
543         address target,
544         bytes memory data,
545         string memory errorMessage
546     ) internal view returns (bytes memory) {
547         require(isContract(target), "Address: static call to non-contract");
548 
549         (bool success, bytes memory returndata) = target.staticcall(data);
550         return _verifyCallResult(success, returndata, errorMessage);
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
555      * but performing a delegate call.
556      *
557      * _Available since v3.4._
558      */
559     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
560         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
561     }
562 
563     /**
564      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
565      * but performing a delegate call.
566      *
567      * _Available since v3.4._
568      */
569     function functionDelegateCall(
570         address target,
571         bytes memory data,
572         string memory errorMessage
573     ) internal returns (bytes memory) {
574         require(isContract(target), "Address: delegate call to non-contract");
575 
576         (bool success, bytes memory returndata) = target.delegatecall(data);
577         return _verifyCallResult(success, returndata, errorMessage);
578     }
579 
580     function _verifyCallResult(
581         bool success,
582         bytes memory returndata,
583         string memory errorMessage
584     ) private pure returns (bytes memory) {
585         if (success) {
586             return returndata;
587         } else {
588             // Look for revert reason and bubble it up if present
589             if (returndata.length > 0) {
590                 // The easiest way to bubble the revert reason is using memory via assembly
591 
592                 assembly {
593                     let returndata_size := mload(returndata)
594                     revert(add(32, returndata), returndata_size)
595                 }
596             } else {
597                 revert(errorMessage);
598             }
599         }
600     }
601 }
602 
603 // File: @openzeppelin/contracts/math/SafeMath.sol
604 
605 /**
606  * @dev Wrappers over Solidity's arithmetic operations with added overflow
607  * checks.
608  *
609  * Arithmetic operations in Solidity wrap on overflow. This can easily result
610  * in bugs, because programmers usually assume that an overflow raises an
611  * error, which is the standard behavior in high level programming languages.
612  * `SafeMath` restores this intuition by reverting the transaction when an
613  * operation overflows.
614  *
615  * Using this library instead of the unchecked operations eliminates an entire
616  * class of bugs, so it's recommended to use it always.
617  */
618 library SafeMath {
619     /**
620      * @dev Returns the addition of two unsigned integers, with an overflow flag.
621      *
622      * _Available since v3.4._
623      */
624     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
625         uint256 c = a + b;
626         if (c < a) return (false, 0);
627         return (true, c);
628     }
629 
630     /**
631      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
632      *
633      * _Available since v3.4._
634      */
635     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
636         if (b > a) return (false, 0);
637         return (true, a - b);
638     }
639 
640     /**
641      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
642      *
643      * _Available since v3.4._
644      */
645     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
646         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
647         // benefit is lost if 'b' is also tested.
648         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
649         if (a == 0) return (true, 0);
650         uint256 c = a * b;
651         if (c / a != b) return (false, 0);
652         return (true, c);
653     }
654 
655     /**
656      * @dev Returns the division of two unsigned integers, with a division by zero flag.
657      *
658      * _Available since v3.4._
659      */
660     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
661         if (b == 0) return (false, 0);
662         return (true, a / b);
663     }
664 
665     /**
666      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
667      *
668      * _Available since v3.4._
669      */
670     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
671         if (b == 0) return (false, 0);
672         return (true, a % b);
673     }
674 
675     /**
676      * @dev Returns the addition of two unsigned integers, reverting on
677      * overflow.
678      *
679      * Counterpart to Solidity's `+` operator.
680      *
681      * Requirements:
682      *
683      * - Addition cannot overflow.
684      */
685     function add(uint256 a, uint256 b) internal pure returns (uint256) {
686         uint256 c = a + b;
687         require(c >= a, "SafeMath: addition overflow");
688         return c;
689     }
690 
691     /**
692      * @dev Returns the subtraction of two unsigned integers, reverting on
693      * overflow (when the result is negative).
694      *
695      * Counterpart to Solidity's `-` operator.
696      *
697      * Requirements:
698      *
699      * - Subtraction cannot overflow.
700      */
701     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
702         require(b <= a, "SafeMath: subtraction overflow");
703         return a - b;
704     }
705 
706     /**
707      * @dev Returns the multiplication of two unsigned integers, reverting on
708      * overflow.
709      *
710      * Counterpart to Solidity's `*` operator.
711      *
712      * Requirements:
713      *
714      * - Multiplication cannot overflow.
715      */
716     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
717         if (a == 0) return 0;
718         uint256 c = a * b;
719         require(c / a == b, "SafeMath: multiplication overflow");
720         return c;
721     }
722 
723     /**
724      * @dev Returns the integer division of two unsigned integers, reverting on
725      * division by zero. The result is rounded towards zero.
726      *
727      * Counterpart to Solidity's `/` operator. Note: this function uses a
728      * `revert` opcode (which leaves remaining gas untouched) while Solidity
729      * uses an invalid opcode to revert (consuming all remaining gas).
730      *
731      * Requirements:
732      *
733      * - The divisor cannot be zero.
734      */
735     function div(uint256 a, uint256 b) internal pure returns (uint256) {
736         require(b > 0, "SafeMath: division by zero");
737         return a / b;
738     }
739 
740     /**
741      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
742      * reverting when dividing by zero.
743      *
744      * Counterpart to Solidity's `%` operator. This function uses a `revert`
745      * opcode (which leaves remaining gas untouched) while Solidity uses an
746      * invalid opcode to revert (consuming all remaining gas).
747      *
748      * Requirements:
749      *
750      * - The divisor cannot be zero.
751      */
752     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
753         require(b > 0, "SafeMath: modulo by zero");
754         return a % b;
755     }
756 
757     /**
758      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
759      * overflow (when the result is negative).
760      *
761      * CAUTION: This function is deprecated because it requires allocating memory for the error
762      * message unnecessarily. For custom revert reasons use {trySub}.
763      *
764      * Counterpart to Solidity's `-` operator.
765      *
766      * Requirements:
767      *
768      * - Subtraction cannot overflow.
769      */
770     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
771         require(b <= a, errorMessage);
772         return a - b;
773     }
774 
775     /**
776      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
777      * division by zero. The result is rounded towards zero.
778      *
779      * CAUTION: This function is deprecated because it requires allocating memory for the error
780      * message unnecessarily. For custom revert reasons use {tryDiv}.
781      *
782      * Counterpart to Solidity's `/` operator. Note: this function uses a
783      * `revert` opcode (which leaves remaining gas untouched) while Solidity
784      * uses an invalid opcode to revert (consuming all remaining gas).
785      *
786      * Requirements:
787      *
788      * - The divisor cannot be zero.
789      */
790     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
791         require(b > 0, errorMessage);
792         return a / b;
793     }
794 
795     /**
796      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
797      * reverting with custom message when dividing by zero.
798      *
799      * CAUTION: This function is deprecated because it requires allocating memory for the error
800      * message unnecessarily. For custom revert reasons use {tryMod}.
801      *
802      * Counterpart to Solidity's `%` operator. This function uses a `revert`
803      * opcode (which leaves remaining gas untouched) while Solidity uses an
804      * invalid opcode to revert (consuming all remaining gas).
805      *
806      * Requirements:
807      *
808      * - The divisor cannot be zero.
809      */
810     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
811         require(b > 0, errorMessage);
812         return a % b;
813     }
814 }
815 
816 /**
817  * @dev Implementation of the {IERC165} interface.
818  *
819  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
820  * for the additional interface id that will be supported. For example:
821  *
822  * ```solidity
823  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
824  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
825  * }
826  * ```
827  *
828  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
829  */
830 abstract contract ERC165 is IERC165 {
831     /**
832      * @dev See {IERC165-supportsInterface}.
833      */
834     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
835         return interfaceId == type(IERC165).interfaceId;
836     }
837 }
838 
839 
840 /**
841  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
842  * the Metadata extension, but not including the Enumerable extension, which is available separately as
843  * {ERC721Enumerable}.
844  */
845 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
846     using Address for address;
847     using Strings for uint256;
848 
849     // Token name
850     string private _name;
851 
852     // Token symbol
853     string private _symbol;
854 
855     // Mapping from token ID to owner address
856     mapping(uint256 => address) private _owners;
857 
858     // Mapping owner address to token count
859     mapping(address => uint256) private _balances;
860 
861     // Mapping from token ID to approved address
862     mapping(uint256 => address) private _tokenApprovals;
863 
864     // Mapping from owner to operator approvals
865     mapping(address => mapping(address => bool)) private _operatorApprovals;
866 
867     /**
868      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
869      */
870     constructor(string memory name_, string memory symbol_) {
871         _name = name_;
872         _symbol = symbol_;
873     }
874 
875     /**
876      * @dev See {IERC165-supportsInterface}.
877      */
878     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
879         return
880             interfaceId == type(IERC721).interfaceId ||
881             interfaceId == type(IERC721Metadata).interfaceId ||
882             super.supportsInterface(interfaceId);
883     }
884 
885     /**
886      * @dev See {IERC721-balanceOf}.
887      */
888     function balanceOf(address owner) public view virtual override returns (uint256) {
889         require(owner != address(0), "ERC721: balance query for the zero address");
890         return _balances[owner];
891     }
892 
893     /**
894      * @dev See {IERC721-ownerOf}.
895      */
896     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
897         address owner = _owners[tokenId];
898         require(owner != address(0), "ERC721: owner query for nonexistent token");
899         return owner;
900     }
901 
902     /**
903      * @dev See {IERC721Metadata-name}.
904      */
905     function name() public view virtual override returns (string memory) {
906         return _name;
907     }
908 
909     /**
910      * @dev See {IERC721Metadata-symbol}.
911      */
912     function symbol() public view virtual override returns (string memory) {
913         return _symbol;
914     }
915 
916     /**
917      * @dev See {IERC721Metadata-tokenURI}.
918      */
919     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
920         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
921 
922         string memory baseURI = _baseURI();
923         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
924     }
925 
926     /**
927      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
928      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
929      * by default, can be overriden in child contracts.
930      */
931     function _baseURI() internal view virtual returns (string memory) {
932         return "";
933     }
934 
935     /**
936      * @dev See {IERC721-approve}.
937      */
938     function approve(address to, uint256 tokenId) public virtual override {
939         address owner = ERC721.ownerOf(tokenId);
940         require(to != owner, "ERC721: approval to current owner");
941 
942         require(
943             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
944             "ERC721: approve caller is not owner nor approved for all"
945         );
946 
947         _approve(to, tokenId);
948     }
949 
950     /**
951      * @dev See {IERC721-getApproved}.
952      */
953     function getApproved(uint256 tokenId) public view virtual override returns (address) {
954         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
955 
956         return _tokenApprovals[tokenId];
957     }
958 
959     /**
960      * @dev See {IERC721-setApprovalForAll}.
961      */
962     function setApprovalForAll(address operator, bool approved) public virtual override {
963         require(operator != _msgSender(), "ERC721: approve to caller");
964 
965         _operatorApprovals[_msgSender()][operator] = approved;
966         emit ApprovalForAll(_msgSender(), operator, approved);
967     }
968 
969     /**
970      * @dev See {IERC721-isApprovedForAll}.
971      */
972     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
973         return _operatorApprovals[owner][operator];
974     }
975 
976     /**
977      * @dev See {IERC721-transferFrom}.
978      */
979     function transferFrom(
980         address from,
981         address to,
982         uint256 tokenId
983     ) public virtual override {
984         //solhint-disable-next-line max-line-length
985         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
986 
987         _transfer(from, to, tokenId);
988     }
989 
990     /**
991      * @dev See {IERC721-safeTransferFrom}.
992      */
993     function safeTransferFrom(
994         address from,
995         address to,
996         uint256 tokenId
997     ) public virtual override {
998         safeTransferFrom(from, to, tokenId, "");
999     }
1000 
1001     /**
1002      * @dev See {IERC721-safeTransferFrom}.
1003      */
1004     function safeTransferFrom(
1005         address from,
1006         address to,
1007         uint256 tokenId,
1008         bytes memory _data
1009     ) public virtual override {
1010         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1011         _safeTransfer(from, to, tokenId, _data);
1012     }
1013 
1014     /**
1015      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1016      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1017      *
1018      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1019      *
1020      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1021      * implement alternative mechanisms to perform token transfer, such as signature-based.
1022      *
1023      * Requirements:
1024      *
1025      * - `from` cannot be the zero address.
1026      * - `to` cannot be the zero address.
1027      * - `tokenId` token must exist and be owned by `from`.
1028      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1029      *
1030      * Emits a {Transfer} event.
1031      */
1032     function _safeTransfer(
1033         address from,
1034         address to,
1035         uint256 tokenId,
1036         bytes memory _data
1037     ) internal virtual {
1038         _transfer(from, to, tokenId);
1039         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1040     }
1041 
1042     /**
1043      * @dev Returns whether `tokenId` exists.
1044      *
1045      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1046      *
1047      * Tokens start existing when they are minted (`_mint`),
1048      * and stop existing when they are burned (`_burn`).
1049      */
1050     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1051         return _owners[tokenId] != address(0);
1052     }
1053 
1054     /**
1055      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1056      *
1057      * Requirements:
1058      *
1059      * - `tokenId` must exist.
1060      */
1061     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1062         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1063         address owner = ERC721.ownerOf(tokenId);
1064         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1065     }
1066 
1067     /**
1068      * @dev Safely mints `tokenId` and transfers it to `to`.
1069      *
1070      * Requirements:
1071      *
1072      * - `tokenId` must not exist.
1073      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1074      *
1075      * Emits a {Transfer} event.
1076      */
1077     function _safeMint(address to, uint256 tokenId) internal virtual {
1078         _safeMint(to, tokenId, "");
1079     }
1080 
1081     /**
1082      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1083      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1084      */
1085     function _safeMint(
1086         address to,
1087         uint256 tokenId,
1088         bytes memory _data
1089     ) internal virtual {
1090         _mint(to, tokenId);
1091         require(
1092             _checkOnERC721Received(address(0), to, tokenId, _data),
1093             "ERC721: transfer to non ERC721Receiver implementer"
1094         );
1095     }
1096 
1097     /**
1098      * @dev Mints `tokenId` and transfers it to `to`.
1099      *
1100      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1101      *
1102      * Requirements:
1103      *
1104      * - `tokenId` must not exist.
1105      * - `to` cannot be the zero address.
1106      *
1107      * Emits a {Transfer} event.
1108      */
1109     function _mint(address to, uint256 tokenId) internal virtual {
1110         require(to != address(0), "ERC721: mint to the zero address");
1111         require(!_exists(tokenId), "ERC721: token already minted");
1112 
1113         _beforeTokenTransfer(address(0), to, tokenId);
1114 
1115         _balances[to] += 1;
1116         _owners[tokenId] = to;
1117 
1118         emit Transfer(address(0), to, tokenId);
1119     }
1120 
1121     /**
1122      * @dev Destroys `tokenId`.
1123      * The approval is cleared when the token is burned.
1124      *
1125      * Requirements:
1126      *
1127      * - `tokenId` must exist.
1128      *
1129      * Emits a {Transfer} event.
1130      */
1131     function _burn(uint256 tokenId) internal virtual {
1132         address owner = ERC721.ownerOf(tokenId);
1133 
1134         _beforeTokenTransfer(owner, address(0), tokenId);
1135 
1136         // Clear approvals
1137         _approve(address(0), tokenId);
1138 
1139         _balances[owner] -= 1;
1140         delete _owners[tokenId];
1141 
1142         emit Transfer(owner, address(0), tokenId);
1143     }
1144 
1145     /**
1146      * @dev Transfers `tokenId` from `from` to `to`.
1147      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1148      *
1149      * Requirements:
1150      *
1151      * - `to` cannot be the zero address.
1152      * - `tokenId` token must be owned by `from`.
1153      *
1154      * Emits a {Transfer} event.
1155      */
1156     function _transfer(
1157         address from,
1158         address to,
1159         uint256 tokenId
1160     ) internal virtual {
1161         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1162         require(to != address(0), "ERC721: transfer to the zero address");
1163 
1164         _beforeTokenTransfer(from, to, tokenId);
1165 
1166         // Clear approvals from the previous owner
1167         _approve(address(0), tokenId);
1168 
1169         _balances[from] -= 1;
1170         _balances[to] += 1;
1171         _owners[tokenId] = to;
1172 
1173         emit Transfer(from, to, tokenId);
1174     }
1175 
1176     /**
1177      * @dev Approve `to` to operate on `tokenId`
1178      *
1179      * Emits a {Approval} event.
1180      */
1181     function _approve(address to, uint256 tokenId) internal virtual {
1182         _tokenApprovals[tokenId] = to;
1183         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1184     }
1185 
1186     /**
1187      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1188      * The call is not executed if the target address is not a contract.
1189      *
1190      * @param from address representing the previous owner of the given token ID
1191      * @param to target address that will receive the tokens
1192      * @param tokenId uint256 ID of the token to be transferred
1193      * @param _data bytes optional data to send along with the call
1194      * @return bool whether the call correctly returned the expected magic value
1195      */
1196     function _checkOnERC721Received(
1197         address from,
1198         address to,
1199         uint256 tokenId,
1200         bytes memory _data
1201     ) private returns (bool) {
1202         if (to.isContract()) {
1203             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1204                 return retval == IERC721Receiver(to).onERC721Received.selector;
1205             } catch (bytes memory reason) {
1206                 if (reason.length == 0) {
1207                     revert("ERC721: transfer to non ERC721Receiver implementer");
1208                 } else {
1209                     assembly {
1210                         revert(add(32, reason), mload(reason))
1211                     }
1212                 }
1213             }
1214         } else {
1215             return true;
1216         }
1217     }
1218 
1219     /**
1220      * @dev Hook that is called before any token transfer. This includes minting
1221      * and burning.
1222      *
1223      * Calling conditions:
1224      *
1225      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1226      * transferred to `to`.
1227      * - When `from` is zero, `tokenId` will be minted for `to`.
1228      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1229      * - `from` and `to` are never both zero.
1230      *
1231      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1232      */
1233     function _beforeTokenTransfer(
1234         address from,
1235         address to,
1236         uint256 tokenId
1237     ) internal virtual {}
1238 }
1239 
1240 
1241 
1242 /**
1243  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1244  * @dev See https://eips.ethereum.org/EIPS/eip-721
1245  */
1246 interface IERC721Enumerable is IERC721 {
1247     /**
1248      * @dev Returns the total amount of tokens stored by the contract.
1249      */
1250     function totalSupply() external view returns (uint256);
1251 
1252     /**
1253      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1254      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1255      */
1256     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1257 
1258     /**
1259      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1260      * Use along with {totalSupply} to enumerate all tokens.
1261      */
1262     function tokenByIndex(uint256 index) external view returns (uint256);
1263 }
1264 
1265 
1266 /**
1267  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1268  * enumerability of all the token ids in the contract as well as all token ids owned by each
1269  * account.
1270  */
1271 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1272     // Mapping from owner to list of owned token IDs
1273     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1274 
1275     // Mapping from token ID to index of the owner tokens list
1276     mapping(uint256 => uint256) private _ownedTokensIndex;
1277 
1278     // Array with all token ids, used for enumeration
1279     uint256[] private _allTokens;
1280 
1281     // Mapping from token id to position in the allTokens array
1282     mapping(uint256 => uint256) private _allTokensIndex;
1283 
1284     /**
1285      * @dev See {IERC165-supportsInterface}.
1286      */
1287     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1288         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1289     }
1290 
1291     /**
1292      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1293      */
1294     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1295         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1296         return _ownedTokens[owner][index];
1297     }
1298 
1299     /**
1300      * @dev See {IERC721Enumerable-totalSupply}.
1301      */
1302     function totalSupply() public view virtual override returns (uint256) {
1303         return _allTokens.length;
1304     }
1305 
1306     /**
1307      * @dev See {IERC721Enumerable-tokenByIndex}.
1308      */
1309     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1310         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1311         return _allTokens[index];
1312     }
1313 
1314     /**
1315      * @dev Hook that is called before any token transfer. This includes minting
1316      * and burning.
1317      *
1318      * Calling conditions:
1319      *
1320      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1321      * transferred to `to`.
1322      * - When `from` is zero, `tokenId` will be minted for `to`.
1323      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1324      * - `from` cannot be the zero address.
1325      * - `to` cannot be the zero address.
1326      *
1327      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1328      */
1329     function _beforeTokenTransfer(
1330         address from,
1331         address to,
1332         uint256 tokenId
1333     ) internal virtual override {
1334         super._beforeTokenTransfer(from, to, tokenId);
1335 
1336         if (from == address(0)) {
1337             _addTokenToAllTokensEnumeration(tokenId);
1338         } else if (from != to) {
1339             _removeTokenFromOwnerEnumeration(from, tokenId);
1340         }
1341         if (to == address(0)) {
1342             _removeTokenFromAllTokensEnumeration(tokenId);
1343         } else if (to != from) {
1344             _addTokenToOwnerEnumeration(to, tokenId);
1345         }
1346     }
1347 
1348     /**
1349      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1350      * @param to address representing the new owner of the given token ID
1351      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1352      */
1353     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1354         uint256 length = ERC721.balanceOf(to);
1355         _ownedTokens[to][length] = tokenId;
1356         _ownedTokensIndex[tokenId] = length;
1357     }
1358 
1359     /**
1360      * @dev Private function to add a token to this extension's token tracking data structures.
1361      * @param tokenId uint256 ID of the token to be added to the tokens list
1362      */
1363     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1364         _allTokensIndex[tokenId] = _allTokens.length;
1365         _allTokens.push(tokenId);
1366     }
1367 
1368     /**
1369      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1370      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1371      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1372      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1373      * @param from address representing the previous owner of the given token ID
1374      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1375      */
1376     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1377         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1378         // then delete the last slot (swap and pop).
1379 
1380         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1381         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1382 
1383         // When the token to delete is the last token, the swap operation is unnecessary
1384         if (tokenIndex != lastTokenIndex) {
1385             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1386 
1387             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1388             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1389         }
1390 
1391         // This also deletes the contents at the last position of the array
1392         delete _ownedTokensIndex[tokenId];
1393         delete _ownedTokens[from][lastTokenIndex];
1394     }
1395 
1396     /**
1397      * @dev Private function to remove a token from this extension's token tracking data structures.
1398      * This has O(1) time complexity, but alters the order of the _allTokens array.
1399      * @param tokenId uint256 ID of the token to be removed from the tokens list
1400      */
1401     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1402         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1403         // then delete the last slot (swap and pop).
1404 
1405         uint256 lastTokenIndex = _allTokens.length - 1;
1406         uint256 tokenIndex = _allTokensIndex[tokenId];
1407 
1408         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1409         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1410         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1411         uint256 lastTokenId = _allTokens[lastTokenIndex];
1412 
1413         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1414         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1415 
1416         // This also deletes the contents at the last position of the array
1417         delete _allTokensIndex[tokenId];
1418         _allTokens.pop();
1419     }
1420 }
1421 
1422 
1423 contract BabyDragos is ERC721Enumerable, ReentrancyGuard, Ownable {
1424     using SafeMath for uint256;
1425     using Strings for uint256;
1426 
1427     bool public claimActive;
1428     address payable mintData;
1429 
1430     address payoutWallet1;
1431     address payoutWallet2;
1432 
1433     BabyDragos dragosContract;
1434 
1435     uint256 creationTime;
1436     uint256 public MAX_TOKEN_SUPPLY = 6000;
1437     uint256 maxClaimsPerTxn = 5;
1438     uint256 bytPayoutPercentage;
1439 
1440     uint256[] babyChunks;
1441 
1442     mapping(uint256 => string) private _babyDragosNameByTokenId;
1443     mapping(uint256 => uint256) private _dragosBirthdayByTokenId;
1444     mapping(uint256 => uint256) public _tokenClaimedByDragosId;
1445 
1446     function setClaim() external onlyOwner
1447     {
1448         claimActive = !claimActive;
1449     }
1450 
1451     function setDragosContract(address payable _address) external onlyOwner {
1452         dragosContract = BabyDragos(_address);
1453     }
1454 
1455     function hasMinted(uint256 tokenId) external view returns (bool)
1456     {
1457         return _exists(tokenId);
1458     }
1459 
1460     function getCreationTime() external view returns (uint256)
1461     {
1462         return creationTime;
1463     }
1464 
1465     function getName(uint256 tokenId) public view returns (string memory) {
1466         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1467 
1468         if (bytes(_babyDragosNameByTokenId[tokenId]).length > 0) {
1469             return _babyDragosNameByTokenId[tokenId];
1470         } else {
1471             return string(abi.encodePacked("Baby Dragos #", toString(tokenId)));
1472         }
1473 
1474     }
1475 
1476     function getBackground(uint256 tokenId) public view returns (string memory) {
1477         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1478         string memory output;
1479         
1480         BabyDragos dataContract = BabyDragos(mintData);
1481         output = dataContract.getBackground(tokenId);
1482 
1483         return output;
1484     }
1485     
1486     function getFaction(uint256 tokenId) public view returns (string memory) {
1487         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1488         string memory output;
1489         
1490         BabyDragos dataContract = BabyDragos(mintData);
1491         output = dataContract.getFaction(tokenId);
1492 
1493         return output;
1494     }
1495     
1496     function getWings(uint256 tokenId) public view returns (string memory) {
1497         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1498         string memory output;
1499         
1500         BabyDragos dataContract = BabyDragos(mintData);
1501         output = dataContract.getWings(tokenId);
1502 
1503         return output;
1504     }
1505 
1506     function getWingTips(uint256 tokenId) public view returns (string memory) {
1507         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1508         string memory output;
1509         
1510         BabyDragos dataContract = BabyDragos(mintData);
1511         output = dataContract.getWingTips(tokenId);
1512 
1513         return output;
1514     }
1515     
1516     function getClothes(uint256 tokenId) public view returns (string memory) {
1517         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1518         string memory output;
1519         
1520         BabyDragos dataContract = BabyDragos(mintData);
1521         output = dataContract.getClothes(tokenId);
1522 
1523         return output;
1524     }
1525 
1526     function getNecklace(uint256 tokenId) public view returns (string memory) {
1527         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1528         string memory output;
1529         
1530         BabyDragos dataContract = BabyDragos(mintData);
1531         output = dataContract.getNecklace(tokenId);
1532 
1533         return output;
1534     }
1535     
1536     function getMouth(uint256 tokenId) public view returns (string memory) {
1537         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1538         string memory output;
1539         
1540         BabyDragos dataContract = BabyDragos(mintData);
1541         output = dataContract.getMouth(tokenId);
1542 
1543         return output;
1544     }
1545     
1546     function getEyes(uint256 tokenId) public view returns (string memory) {
1547         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1548         string memory output;
1549         
1550         BabyDragos dataContract = BabyDragos(mintData);
1551         output = dataContract.getEyes(tokenId);
1552 
1553         return output;
1554     }
1555     
1556     function getHat(uint256 tokenId) public view returns (string memory) {
1557         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1558         string memory output;
1559 
1560         BabyDragos dataContract = BabyDragos(mintData);
1561         output = dataContract.getHat(tokenId);
1562 
1563         return output;
1564     }
1565 
1566     function getBirthday(uint256 tokenId) public view returns (uint256) {
1567         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1568 
1569         uint256 output;
1570 
1571         BabyDragos dataContract = BabyDragos(mintData);
1572         output = dataContract.getBirthday(tokenId);
1573 
1574         return output;
1575     }
1576 
1577     function getStats(uint256 statIndex, uint256 tokenId) public view returns (string memory statName, uint256 statValue) {
1578         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1579 
1580         BabyDragos dataContract = BabyDragos(mintData);
1581         (statName, statValue) = dataContract.getStats(statIndex, tokenId);
1582 
1583         return (statName, statValue);
1584     }
1585 
1586     function setBabyChunk(uint256 currentChunkFinalTokenId) external onlyOwner 
1587     {
1588         if(babyChunks.length > 0)
1589         {
1590             require(currentChunkFinalTokenId > babyChunks[babyChunks.length -1], "Final Id too small");
1591         }
1592         require(currentChunkFinalTokenId <= dragosContract.totalSupply(), "Larger than dragos supply");
1593         babyChunks.push(currentChunkFinalTokenId);
1594     }
1595 
1596     function getBabyChunkLength() external view returns(uint256)
1597     {
1598         require(msg.sender == mintData, "Permission Denied");
1599         return babyChunks.length;
1600     }
1601 
1602     function getBabyChunk(uint256 index) external view returns(uint256){
1603         require(msg.sender == mintData, "Permission Denied");
1604         return babyChunks[index];
1605     }
1606 
1607     function changeBabyChunk(uint256 index, uint256 _value) external onlyOwner {
1608         require(index < babyChunks.length, "Index too large");
1609         if(index < (babyChunks.length - 1))
1610         {
1611             require(_value < babyChunks[index + 1], "Value larger than next chunk");
1612         }
1613         if(index > 0)
1614         {
1615             require(_value > babyChunks[index - 1], "Value smaller than previous chunk");
1616         }
1617 
1618         babyChunks[index] = _value;
1619     }
1620 
1621     function tokenURI(uint256 tokenId) override public view returns (string memory) {
1622         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1623             string memory output;
1624 
1625             BabyDragos dataContract = BabyDragos(mintData);
1626             output = dataContract.tokenURI(tokenId);
1627 
1628             return output;
1629     }
1630 
1631     function changeName(uint256 tokenId, string memory _name) external {
1632         require(ownerOf(tokenId) == _msgSender(), "You dont own that baby");
1633         require(validateName(_name), "Name is invalid");
1634         _babyDragosNameByTokenId[tokenId] = _name;
1635     }
1636 
1637     function validateName(string memory str) internal pure returns (bool){
1638 		bytes memory b = bytes(str);
1639 		if(b.length < 1) return false;
1640 		if(b.length > 25) return false; // Cannot be longer than 25 characters
1641 		if(b[0] == 0x20) return false; // Leading space
1642 		if (b[b.length - 1] == 0x20) return false; // Trailing space
1643 
1644 		bytes1 lastChar = b[0];
1645 
1646 		for(uint i; i<b.length; i++){
1647 			bytes1 char = b[i];
1648 
1649 			if (char == 0x20 && lastChar == 0x20) return false; // Cannot contain continous spaces
1650 
1651 			if(
1652 				!(char >= 0x30 && char <= 0x39) && //9-0
1653 				!(char >= 0x41 && char <= 0x5A) && //A-Z
1654 				!(char >= 0x61 && char <= 0x7A) && //a-z
1655 				!(char == 0x20) //space
1656 			)
1657 				return false;
1658 
1659 			lastChar = char;
1660 		}
1661 
1662 		return true;
1663 	}
1664 
1665 
1666     function mint(uint256[] memory dragosIds, string[] memory names) public nonReentrant {
1667         require(dragosIds.length <= maxClaimsPerTxn, "You can only claim 5 at a time");
1668         require(claimActive, "Claiming babies is not active yet");
1669         
1670         uint256 tokenId = totalSupply() + 1; //First token will have ID 1 instead of 0 for mint mapping checks
1671         uint256 time = block.timestamp;
1672 
1673         for(uint256 i = 0; i < dragosIds.length; i++)
1674         {
1675             require(dragosContract.getBirthday(dragosIds[i]) < time, "Baby has not been born yet");
1676             require(_tokenClaimedByDragosId[dragosIds[i]] == 0, "Dragos has already claimed");
1677 
1678             if (bytes(names[i]).length > 0) {
1679                 require(validateName(names[i]), "Name is invalid");
1680                 _babyDragosNameByTokenId[tokenId + i] = names[i];
1681             }
1682 
1683             _tokenClaimedByDragosId[dragosIds[i]] = tokenId + i;
1684             _safeMint(_msgSender(), tokenId + i);
1685         }
1686     }
1687 
1688     function setWalletOne(address _walletAddress) external onlyOwner {
1689         payoutWallet1 = _walletAddress;
1690     }
1691 
1692     function setWalletTwo(address _walletAddress) external onlyOwner {
1693         payoutWallet2 = _walletAddress;
1694     }
1695 
1696     function setMintContract(address payable contractAddress) public onlyOwner {
1697         mintData = contractAddress;
1698     }
1699 
1700     function withdraw() external onlyOwner {
1701         require(payoutWallet1 != address(0), "wallet 1 not set");
1702         require(payoutWallet2 != address(0), "wallet 2 not set");
1703         uint256 balance = address(this).balance;
1704         uint256 walletBalance = balance.mul(100 - bytPayoutPercentage).div(100);
1705         payable(payoutWallet1).transfer(walletBalance);
1706         payable(payoutWallet2).transfer(balance.sub(walletBalance));
1707     }
1708     
1709     constructor() ERC721("Baby Dragos", "BDRAGOS") Ownable() {
1710         creationTime = block.timestamp;
1711         payoutWallet1 = 0x8d3Aad1100c67ecCef8426151DC8C4b659012a6F; // dragos payout wallet
1712         payoutWallet2 = 0xFd182CAc22329a58375bf5f93B2C33E83c881540; // byt payout wallet
1713         bytPayoutPercentage = 9;
1714         mintData = payable(0x787CC682fcC85375edF7e88E289030d375e15B9A); 
1715         dragosContract = BabyDragos(payable(0xB0858AC51bca73c11BA3203712E319b7C45b0896));
1716     }
1717 
1718     fallback() external payable {}
1719 
1720     function toString(uint256 value) internal pure returns (string memory) {
1721     // Inspired by OraclizeAPI's implementation - MIT license
1722     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1723 
1724         if (value == 0) {
1725             return "0";
1726         }
1727         uint256 temp = value;
1728         uint256 digits;
1729         while (temp != 0) {
1730             digits++;
1731             temp /= 10;
1732         }
1733         bytes memory buffer = new bytes(digits);
1734         while (value != 0) {
1735             digits -= 1;
1736             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1737             value /= 10;
1738         }
1739         return string(buffer);
1740     }
1741 }