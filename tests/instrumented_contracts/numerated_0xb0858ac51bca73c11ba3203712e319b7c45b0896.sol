1 pragma solidity ^0.8.0;
2 
3 /**
4  * @dev Interface of the ERC165 standard, as defined in the
5  * https://eips.ethereum.org/EIPS/eip-165[EIP].
6  *
7  * Implementers can declare support of contract interfaces, which can then be
8  * queried by others ({ERC165Checker}).
9  *
10  * For an implementation, see {ERC165}.
11  */
12 interface IERC165 {
13     /**
14      * @dev Returns true if this contract implements the interface defined by
15      * `interfaceId`. See the corresponding
16      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
17      * to learn more about how these ids are created.
18      *
19      * This function call must use less than 30 000 gas.
20      */
21     function supportsInterface(bytes4 interfaceId) external view returns (bool);
22 }
23 
24 
25 /**
26  * @dev Required interface of an ERC721 compliant contract.
27  */
28 interface IERC721 is IERC165 {
29     /**
30      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
31      */
32     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
33 
34     /**
35      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
36      */
37     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
38 
39     /**
40      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
41      */
42     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
43 
44     /**
45      * @dev Returns the number of tokens in ``owner``'s account.
46      */
47     function balanceOf(address owner) external view returns (uint256 balance);
48 
49     /**
50      * @dev Returns the owner of the `tokenId` token.
51      *
52      * Requirements:
53      *
54      * - `tokenId` must exist.
55      */
56     function ownerOf(uint256 tokenId) external view returns (address owner);
57 
58     /**
59      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
60      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
61      *
62      * Requirements:
63      *
64      * - `from` cannot be the zero address.
65      * - `to` cannot be the zero address.
66      * - `tokenId` token must exist and be owned by `from`.
67      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
68      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
69      *
70      * Emits a {Transfer} event.
71      */
72     function safeTransferFrom(
73         address from,
74         address to,
75         uint256 tokenId
76     ) external;
77 
78     /**
79      * @dev Transfers `tokenId` token from `from` to `to`.
80      *
81      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
82      *
83      * Requirements:
84      *
85      * - `from` cannot be the zero address.
86      * - `to` cannot be the zero address.
87      * - `tokenId` token must be owned by `from`.
88      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(
93         address from,
94         address to,
95         uint256 tokenId
96     ) external;
97 
98     /**
99      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
100      * The approval is cleared when the token is transferred.
101      *
102      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
103      *
104      * Requirements:
105      *
106      * - The caller must own the token or be an approved operator.
107      * - `tokenId` must exist.
108      *
109      * Emits an {Approval} event.
110      */
111     function approve(address to, uint256 tokenId) external;
112 
113     /**
114      * @dev Returns the account approved for `tokenId` token.
115      *
116      * Requirements:
117      *
118      * - `tokenId` must exist.
119      */
120     function getApproved(uint256 tokenId) external view returns (address operator);
121 
122     /**
123      * @dev Approve or remove `operator` as an operator for the caller.
124      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
125      *
126      * Requirements:
127      *
128      * - The `operator` cannot be the caller.
129      *
130      * Emits an {ApprovalForAll} event.
131      */
132     function setApprovalForAll(address operator, bool _approved) external;
133 
134     /**
135      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
136      *
137      * See {setApprovalForAll}
138      */
139     function isApprovedForAll(address owner, address operator) external view returns (bool);
140 
141     /**
142      * @dev Safely transfers `tokenId` token from `from` to `to`.
143      *
144      * Requirements:
145      *
146      * - `from` cannot be the zero address.
147      * - `to` cannot be the zero address.
148      * - `tokenId` token must exist and be owned by `from`.
149      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
150      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
151      *
152      * Emits a {Transfer} event.
153      */
154     function safeTransferFrom(
155         address from,
156         address to,
157         uint256 tokenId,
158         bytes calldata data
159     ) external;
160 }
161 
162 
163 
164 /**
165  * @dev String operations.
166  */
167 library Strings {
168 
169     /**
170      * @dev Custom toString function
171      */
172     function toString(uint256 _i) internal pure returns (string memory) {
173 
174         if (_i == 0) {
175             return "0";
176         }
177         uint j = _i;
178         uint len;
179         while (j != 0) {
180             len++;
181             j /= 10;
182         }
183         bytes memory bstr = new bytes(len);
184         uint k = len;
185         while (_i != 0) {
186             k = k-1;
187             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
188             bytes1 b1 = bytes1(temp);
189             bstr[k] = b1;
190             _i /= 10;
191         }
192         return string(bstr);
193     }
194 
195 }
196 
197 
198 /*
199  * @dev Provides information about the current execution context, including the
200  * sender of the transaction and its data. While these are generally available
201  * via msg.sender and msg.data, they should not be accessed in such a direct
202  * manner, since when dealing with meta-transactions the account sending and
203  * paying for execution may not be the actual sender (as far as an application
204  * is concerned).
205  *
206  * This contract is only required for intermediate, library-like contracts.
207  */
208 abstract contract Context {
209     function _msgSender() internal view virtual returns (address) {
210         return msg.sender;
211     }
212 
213     function _msgData() internal view virtual returns (bytes calldata) {
214         return msg.data;
215     }
216 }
217 
218 
219 /**
220  * @dev Contract module which provides a basic access control mechanism, where
221  * there is an account (an owner) that can be granted exclusive access to
222  * specific functions.
223  *
224  * By default, the owner account will be the one that deploys the contract. This
225  * can later be changed with {transferOwnership}.
226  *
227  * This module is used through inheritance. It will make available the modifier
228  * `onlyOwner`, which can be applied to your functions to restrict their use to
229  * the owner.
230  */
231 abstract contract Ownable is Context {
232     address private _owner;
233 
234     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
235 
236     /**
237      * @dev Initializes the contract setting the deployer as the initial owner.
238      */
239     constructor() {
240         _setOwner(_msgSender());
241     }
242 
243     /**
244      * @dev Returns the address of the current owner.
245      */
246     function owner() public view virtual returns (address) {
247         return _owner;
248     }
249 
250     /**
251      * @dev Throws if called by any account other than the owner.
252      */
253     modifier onlyOwner() {
254         require(owner() == _msgSender(), "Ownable: caller is not the owner");
255         _;
256     }
257 
258     /**
259      * @dev Leaves the contract without owner. It will not be possible to call
260      * `onlyOwner` functions anymore. Can only be called by the current owner.
261      *
262      * NOTE: Renouncing ownership will leave the contract without an owner,
263      * thereby removing any functionality that is only available to the owner.
264      */
265     function renounceOwnership() public virtual onlyOwner {
266         _setOwner(address(0));
267     }
268 
269     /**
270      * @dev Transfers ownership of the contract to a new account (`newOwner`).
271      * Can only be called by the current owner.
272      */
273     function transferOwnership(address newOwner) public virtual onlyOwner {
274         require(newOwner != address(0), "Ownable: new owner is the zero address");
275         _setOwner(newOwner);
276     }
277 
278     function _setOwner(address newOwner) private {
279         address oldOwner = _owner;
280         _owner = newOwner;
281         emit OwnershipTransferred(oldOwner, newOwner);
282     }
283 }
284 
285 
286 /**
287  * @dev Contract module that helps prevent reentrant calls to a function.
288  *
289  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
290  * available, which can be applied to functions to make sure there are no nested
291  * (reentrant) calls to them.
292  *
293  * Note that because there is a single `nonReentrant` guard, functions marked as
294  * `nonReentrant` may not call one another. This can be worked around by making
295  * those functions `private`, and then adding `external` `nonReentrant` entry
296  * points to them.
297  *
298  * TIP: If you would like to learn more about reentrancy and alternative ways
299  * to protect against it, check out our blog post
300  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
301  */
302 abstract contract ReentrancyGuard {
303     // Booleans are more expensive than uint256 or any type that takes up a full
304     // word because each write operation emits an extra SLOAD to first read the
305     // slot's contents, replace the bits taken up by the boolean, and then write
306     // back. This is the compiler's defense against contract upgrades and
307     // pointer aliasing, and it cannot be disabled.
308 
309     // The values being non-zero value makes deployment a bit more expensive,
310     // but in exchange the refund on every call to nonReentrant will be lower in
311     // amount. Since refunds are capped to a percentage of the total
312     // transaction's gas, it is best to keep them low in cases like this one, to
313     // increase the likelihood of the full refund coming into effect.
314     uint256 private constant _NOT_ENTERED = 1;
315     uint256 private constant _ENTERED = 2;
316 
317     uint256 private _status;
318 
319     constructor() {
320         _status = _NOT_ENTERED;
321     }
322 
323     /**
324      * @dev Prevents a contract from calling itself, directly or indirectly.
325      * Calling a `nonReentrant` function from another `nonReentrant`
326      * function is not supported. It is possible to prevent this from happening
327      * by making the `nonReentrant` function external, and make it call a
328      * `private` function that does the actual work.
329      */
330     modifier nonReentrant() {
331         // On the first call to nonReentrant, _notEntered will be true
332         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
333 
334         // Any calls to nonReentrant after this point will fail
335         _status = _ENTERED;
336 
337         _;
338 
339         // By storing the original value once again, a refund is triggered (see
340         // https://eips.ethereum.org/EIPS/eip-2200)
341         _status = _NOT_ENTERED;
342     }
343 }
344 
345 
346 
347 /**
348  * @title ERC721 token receiver interface
349  * @dev Interface for any contract that wants to support safeTransfers
350  * from ERC721 asset contracts.
351  */
352 interface IERC721Receiver {
353     /**
354      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
355      * by `operator` from `from`, this function is called.
356      *
357      * It must return its Solidity selector to confirm the token transfer.
358      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
359      *
360      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
361      */
362     function onERC721Received(
363         address operator,
364         address from,
365         uint256 tokenId,
366         bytes calldata data
367     ) external returns (bytes4);
368 }
369 
370 
371 /**
372  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
373  * @dev See https://eips.ethereum.org/EIPS/eip-721
374  */
375 interface IERC721Metadata is IERC721 {
376     /**
377      * @dev Returns the token collection name.
378      */
379     function name() external view returns (string memory);
380 
381     /**
382      * @dev Returns the token collection symbol.
383      */
384     function symbol() external view returns (string memory);
385 
386     /**
387      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
388      */
389     function tokenURI(uint256 tokenId) external view returns (string memory);
390 }
391 
392 
393 /**
394  * @dev Collection of functions related to the address type
395  */
396 library Address {
397     /**
398      * @dev Returns true if `account` is a contract.
399      *
400      * [IMPORTANT]
401      * ====
402      * It is unsafe to assume that an address for which this function returns
403      * false is an externally-owned account (EOA) and not a contract.
404      *
405      * Among others, `isContract` will return false for the following
406      * types of addresses:
407      *
408      *  - an externally-owned account
409      *  - a contract in construction
410      *  - an address where a contract will be created
411      *  - an address where a contract lived, but was destroyed
412      * ====
413      */
414     function isContract(address account) internal view returns (bool) {
415         // This method relies on extcodesize, which returns 0 for contracts in
416         // construction, since the code is only stored at the end of the
417         // constructor execution.
418 
419         uint256 size;
420         assembly {
421             size := extcodesize(account)
422         }
423         return size > 0;
424     }
425 
426     /**
427      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
428      * `recipient`, forwarding all available gas and reverting on errors.
429      *
430      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
431      * of certain opcodes, possibly making contracts go over the 2300 gas limit
432      * imposed by `transfer`, making them unable to receive funds via
433      * `transfer`. {sendValue} removes this limitation.
434      *
435      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
436      *
437      * IMPORTANT: because control is transferred to `recipient`, care must be
438      * taken to not create reentrancy vulnerabilities. Consider using
439      * {ReentrancyGuard} or the
440      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
441      */
442     function sendValue(address payable recipient, uint256 amount) internal {
443         require(address(this).balance >= amount, "Address: insufficient balance");
444 
445         (bool success, ) = recipient.call{value: amount}("");
446         require(success, "Address: unable to send value, recipient may have reverted");
447     }
448 
449     /**
450      * @dev Performs a Solidity function call using a low level `call`. A
451      * plain `call` is an unsafe replacement for a function call: use this
452      * function instead.
453      *
454      * If `target` reverts with a revert reason, it is bubbled up by this
455      * function (like regular Solidity function calls).
456      *
457      * Returns the raw returned data. To convert to the expected return value,
458      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
459      *
460      * Requirements:
461      *
462      * - `target` must be a contract.
463      * - calling `target` with `data` must not revert.
464      *
465      * _Available since v3.1._
466      */
467     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
468         return functionCall(target, data, "Address: low-level call failed");
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
473      * `errorMessage` as a fallback revert reason when `target` reverts.
474      *
475      * _Available since v3.1._
476      */
477     function functionCall(
478         address target,
479         bytes memory data,
480         string memory errorMessage
481     ) internal returns (bytes memory) {
482         return functionCallWithValue(target, data, 0, errorMessage);
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
487      * but also transferring `value` wei to `target`.
488      *
489      * Requirements:
490      *
491      * - the calling contract must have an ETH balance of at least `value`.
492      * - the called Solidity function must be `payable`.
493      *
494      * _Available since v3.1._
495      */
496     function functionCallWithValue(
497         address target,
498         bytes memory data,
499         uint256 value
500     ) internal returns (bytes memory) {
501         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
502     }
503 
504     /**
505      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
506      * with `errorMessage` as a fallback revert reason when `target` reverts.
507      *
508      * _Available since v3.1._
509      */
510     function functionCallWithValue(
511         address target,
512         bytes memory data,
513         uint256 value,
514         string memory errorMessage
515     ) internal returns (bytes memory) {
516         require(address(this).balance >= value, "Address: insufficient balance for call");
517         require(isContract(target), "Address: call to non-contract");
518 
519         (bool success, bytes memory returndata) = target.call{value: value}(data);
520         return _verifyCallResult(success, returndata, errorMessage);
521     }
522 
523     /**
524      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
525      * but performing a static call.
526      *
527      * _Available since v3.3._
528      */
529     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
530         return functionStaticCall(target, data, "Address: low-level static call failed");
531     }
532 
533     /**
534      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
535      * but performing a static call.
536      *
537      * _Available since v3.3._
538      */
539     function functionStaticCall(
540         address target,
541         bytes memory data,
542         string memory errorMessage
543     ) internal view returns (bytes memory) {
544         require(isContract(target), "Address: static call to non-contract");
545 
546         (bool success, bytes memory returndata) = target.staticcall(data);
547         return _verifyCallResult(success, returndata, errorMessage);
548     }
549 
550     /**
551      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
552      * but performing a delegate call.
553      *
554      * _Available since v3.4._
555      */
556     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
557         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
558     }
559 
560     /**
561      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
562      * but performing a delegate call.
563      *
564      * _Available since v3.4._
565      */
566     function functionDelegateCall(
567         address target,
568         bytes memory data,
569         string memory errorMessage
570     ) internal returns (bytes memory) {
571         require(isContract(target), "Address: delegate call to non-contract");
572 
573         (bool success, bytes memory returndata) = target.delegatecall(data);
574         return _verifyCallResult(success, returndata, errorMessage);
575     }
576 
577     function _verifyCallResult(
578         bool success,
579         bytes memory returndata,
580         string memory errorMessage
581     ) private pure returns (bytes memory) {
582         if (success) {
583             return returndata;
584         } else {
585             // Look for revert reason and bubble it up if present
586             if (returndata.length > 0) {
587                 // The easiest way to bubble the revert reason is using memory via assembly
588 
589                 assembly {
590                     let returndata_size := mload(returndata)
591                     revert(add(32, returndata), returndata_size)
592                 }
593             } else {
594                 revert(errorMessage);
595             }
596         }
597     }
598 }
599 
600 // File: @openzeppelin/contracts/math/SafeMath.sol
601 
602 /**
603  * @dev Wrappers over Solidity's arithmetic operations with added overflow
604  * checks.
605  *
606  * Arithmetic operations in Solidity wrap on overflow. This can easily result
607  * in bugs, because programmers usually assume that an overflow raises an
608  * error, which is the standard behavior in high level programming languages.
609  * `SafeMath` restores this intuition by reverting the transaction when an
610  * operation overflows.
611  *
612  * Using this library instead of the unchecked operations eliminates an entire
613  * class of bugs, so it's recommended to use it always.
614  */
615 library SafeMath {
616     /**
617      * @dev Returns the addition of two unsigned integers, with an overflow flag.
618      *
619      * _Available since v3.4._
620      */
621     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
622         uint256 c = a + b;
623         if (c < a) return (false, 0);
624         return (true, c);
625     }
626 
627     /**
628      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
629      *
630      * _Available since v3.4._
631      */
632     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
633         if (b > a) return (false, 0);
634         return (true, a - b);
635     }
636 
637     /**
638      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
639      *
640      * _Available since v3.4._
641      */
642     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
643         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
644         // benefit is lost if 'b' is also tested.
645         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
646         if (a == 0) return (true, 0);
647         uint256 c = a * b;
648         if (c / a != b) return (false, 0);
649         return (true, c);
650     }
651 
652     /**
653      * @dev Returns the division of two unsigned integers, with a division by zero flag.
654      *
655      * _Available since v3.4._
656      */
657     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
658         if (b == 0) return (false, 0);
659         return (true, a / b);
660     }
661 
662     /**
663      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
664      *
665      * _Available since v3.4._
666      */
667     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
668         if (b == 0) return (false, 0);
669         return (true, a % b);
670     }
671 
672     /**
673      * @dev Returns the addition of two unsigned integers, reverting on
674      * overflow.
675      *
676      * Counterpart to Solidity's `+` operator.
677      *
678      * Requirements:
679      *
680      * - Addition cannot overflow.
681      */
682     function add(uint256 a, uint256 b) internal pure returns (uint256) {
683         uint256 c = a + b;
684         require(c >= a, "SafeMath: addition overflow");
685         return c;
686     }
687 
688     /**
689      * @dev Returns the subtraction of two unsigned integers, reverting on
690      * overflow (when the result is negative).
691      *
692      * Counterpart to Solidity's `-` operator.
693      *
694      * Requirements:
695      *
696      * - Subtraction cannot overflow.
697      */
698     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
699         require(b <= a, "SafeMath: subtraction overflow");
700         return a - b;
701     }
702 
703     /**
704      * @dev Returns the multiplication of two unsigned integers, reverting on
705      * overflow.
706      *
707      * Counterpart to Solidity's `*` operator.
708      *
709      * Requirements:
710      *
711      * - Multiplication cannot overflow.
712      */
713     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
714         if (a == 0) return 0;
715         uint256 c = a * b;
716         require(c / a == b, "SafeMath: multiplication overflow");
717         return c;
718     }
719 
720     /**
721      * @dev Returns the integer division of two unsigned integers, reverting on
722      * division by zero. The result is rounded towards zero.
723      *
724      * Counterpart to Solidity's `/` operator. Note: this function uses a
725      * `revert` opcode (which leaves remaining gas untouched) while Solidity
726      * uses an invalid opcode to revert (consuming all remaining gas).
727      *
728      * Requirements:
729      *
730      * - The divisor cannot be zero.
731      */
732     function div(uint256 a, uint256 b) internal pure returns (uint256) {
733         require(b > 0, "SafeMath: division by zero");
734         return a / b;
735     }
736 
737     /**
738      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
739      * reverting when dividing by zero.
740      *
741      * Counterpart to Solidity's `%` operator. This function uses a `revert`
742      * opcode (which leaves remaining gas untouched) while Solidity uses an
743      * invalid opcode to revert (consuming all remaining gas).
744      *
745      * Requirements:
746      *
747      * - The divisor cannot be zero.
748      */
749     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
750         require(b > 0, "SafeMath: modulo by zero");
751         return a % b;
752     }
753 
754     /**
755      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
756      * overflow (when the result is negative).
757      *
758      * CAUTION: This function is deprecated because it requires allocating memory for the error
759      * message unnecessarily. For custom revert reasons use {trySub}.
760      *
761      * Counterpart to Solidity's `-` operator.
762      *
763      * Requirements:
764      *
765      * - Subtraction cannot overflow.
766      */
767     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
768         require(b <= a, errorMessage);
769         return a - b;
770     }
771 
772     /**
773      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
774      * division by zero. The result is rounded towards zero.
775      *
776      * CAUTION: This function is deprecated because it requires allocating memory for the error
777      * message unnecessarily. For custom revert reasons use {tryDiv}.
778      *
779      * Counterpart to Solidity's `/` operator. Note: this function uses a
780      * `revert` opcode (which leaves remaining gas untouched) while Solidity
781      * uses an invalid opcode to revert (consuming all remaining gas).
782      *
783      * Requirements:
784      *
785      * - The divisor cannot be zero.
786      */
787     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
788         require(b > 0, errorMessage);
789         return a / b;
790     }
791 
792     /**
793      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
794      * reverting with custom message when dividing by zero.
795      *
796      * CAUTION: This function is deprecated because it requires allocating memory for the error
797      * message unnecessarily. For custom revert reasons use {tryMod}.
798      *
799      * Counterpart to Solidity's `%` operator. This function uses a `revert`
800      * opcode (which leaves remaining gas untouched) while Solidity uses an
801      * invalid opcode to revert (consuming all remaining gas).
802      *
803      * Requirements:
804      *
805      * - The divisor cannot be zero.
806      */
807     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
808         require(b > 0, errorMessage);
809         return a % b;
810     }
811 }
812 
813 /**
814  * @dev Implementation of the {IERC165} interface.
815  *
816  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
817  * for the additional interface id that will be supported. For example:
818  *
819  * ```solidity
820  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
821  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
822  * }
823  * ```
824  *
825  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
826  */
827 abstract contract ERC165 is IERC165 {
828     /**
829      * @dev See {IERC165-supportsInterface}.
830      */
831     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
832         return interfaceId == type(IERC165).interfaceId;
833     }
834 }
835 
836 
837 /**
838  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
839  * the Metadata extension, but not including the Enumerable extension, which is available separately as
840  * {ERC721Enumerable}.
841  */
842 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
843     using Address for address;
844     using Strings for uint256;
845 
846     // Token name
847     string private _name;
848 
849     // Token symbol
850     string private _symbol;
851 
852     // Mapping from token ID to owner address
853     mapping(uint256 => address) private _owners;
854 
855     // Mapping owner address to token count
856     mapping(address => uint256) private _balances;
857 
858     // Mapping from token ID to approved address
859     mapping(uint256 => address) private _tokenApprovals;
860 
861     // Mapping from owner to operator approvals
862     mapping(address => mapping(address => bool)) private _operatorApprovals;
863 
864     /**
865      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
866      */
867     constructor(string memory name_, string memory symbol_) {
868         _name = name_;
869         _symbol = symbol_;
870     }
871 
872     /**
873      * @dev See {IERC165-supportsInterface}.
874      */
875     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
876         return
877             interfaceId == type(IERC721).interfaceId ||
878             interfaceId == type(IERC721Metadata).interfaceId ||
879             super.supportsInterface(interfaceId);
880     }
881 
882     /**
883      * @dev See {IERC721-balanceOf}.
884      */
885     function balanceOf(address owner) public view virtual override returns (uint256) {
886         require(owner != address(0), "ERC721: balance query for the zero address");
887         return _balances[owner];
888     }
889 
890     /**
891      * @dev See {IERC721-ownerOf}.
892      */
893     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
894         address owner = _owners[tokenId];
895         require(owner != address(0), "ERC721: owner query for nonexistent token");
896         return owner;
897     }
898 
899     /**
900      * @dev See {IERC721Metadata-name}.
901      */
902     function name() public view virtual override returns (string memory) {
903         return _name;
904     }
905 
906     /**
907      * @dev See {IERC721Metadata-symbol}.
908      */
909     function symbol() public view virtual override returns (string memory) {
910         return _symbol;
911     }
912 
913     /**
914      * @dev See {IERC721Metadata-tokenURI}.
915      */
916     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
917         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
918 
919         string memory baseURI = _baseURI();
920         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
921     }
922 
923     /**
924      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
925      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
926      * by default, can be overriden in child contracts.
927      */
928     function _baseURI() internal view virtual returns (string memory) {
929         return "";
930     }
931 
932     /**
933      * @dev See {IERC721-approve}.
934      */
935     function approve(address to, uint256 tokenId) public virtual override {
936         address owner = ERC721.ownerOf(tokenId);
937         require(to != owner, "ERC721: approval to current owner");
938 
939         require(
940             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
941             "ERC721: approve caller is not owner nor approved for all"
942         );
943 
944         _approve(to, tokenId);
945     }
946 
947     /**
948      * @dev See {IERC721-getApproved}.
949      */
950     function getApproved(uint256 tokenId) public view virtual override returns (address) {
951         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
952 
953         return _tokenApprovals[tokenId];
954     }
955 
956     /**
957      * @dev See {IERC721-setApprovalForAll}.
958      */
959     function setApprovalForAll(address operator, bool approved) public virtual override {
960         require(operator != _msgSender(), "ERC721: approve to caller");
961 
962         _operatorApprovals[_msgSender()][operator] = approved;
963         emit ApprovalForAll(_msgSender(), operator, approved);
964     }
965 
966     /**
967      * @dev See {IERC721-isApprovedForAll}.
968      */
969     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
970         return _operatorApprovals[owner][operator];
971     }
972 
973     /**
974      * @dev See {IERC721-transferFrom}.
975      */
976     function transferFrom(
977         address from,
978         address to,
979         uint256 tokenId
980     ) public virtual override {
981         //solhint-disable-next-line max-line-length
982         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
983 
984         _transfer(from, to, tokenId);
985     }
986 
987     /**
988      * @dev See {IERC721-safeTransferFrom}.
989      */
990     function safeTransferFrom(
991         address from,
992         address to,
993         uint256 tokenId
994     ) public virtual override {
995         safeTransferFrom(from, to, tokenId, "");
996     }
997 
998     /**
999      * @dev See {IERC721-safeTransferFrom}.
1000      */
1001     function safeTransferFrom(
1002         address from,
1003         address to,
1004         uint256 tokenId,
1005         bytes memory _data
1006     ) public virtual override {
1007         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1008         _safeTransfer(from, to, tokenId, _data);
1009     }
1010 
1011     /**
1012      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1013      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1014      *
1015      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1016      *
1017      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1018      * implement alternative mechanisms to perform token transfer, such as signature-based.
1019      *
1020      * Requirements:
1021      *
1022      * - `from` cannot be the zero address.
1023      * - `to` cannot be the zero address.
1024      * - `tokenId` token must exist and be owned by `from`.
1025      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1026      *
1027      * Emits a {Transfer} event.
1028      */
1029     function _safeTransfer(
1030         address from,
1031         address to,
1032         uint256 tokenId,
1033         bytes memory _data
1034     ) internal virtual {
1035         _transfer(from, to, tokenId);
1036         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1037     }
1038 
1039     /**
1040      * @dev Returns whether `tokenId` exists.
1041      *
1042      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1043      *
1044      * Tokens start existing when they are minted (`_mint`),
1045      * and stop existing when they are burned (`_burn`).
1046      */
1047     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1048         return _owners[tokenId] != address(0);
1049     }
1050 
1051     /**
1052      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1053      *
1054      * Requirements:
1055      *
1056      * - `tokenId` must exist.
1057      */
1058     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1059         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1060         address owner = ERC721.ownerOf(tokenId);
1061         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1062     }
1063 
1064     /**
1065      * @dev Safely mints `tokenId` and transfers it to `to`.
1066      *
1067      * Requirements:
1068      *
1069      * - `tokenId` must not exist.
1070      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1071      *
1072      * Emits a {Transfer} event.
1073      */
1074     function _safeMint(address to, uint256 tokenId) internal virtual {
1075         _safeMint(to, tokenId, "");
1076     }
1077 
1078     /**
1079      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1080      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1081      */
1082     function _safeMint(
1083         address to,
1084         uint256 tokenId,
1085         bytes memory _data
1086     ) internal virtual {
1087         _mint(to, tokenId);
1088         require(
1089             _checkOnERC721Received(address(0), to, tokenId, _data),
1090             "ERC721: transfer to non ERC721Receiver implementer"
1091         );
1092     }
1093 
1094     /**
1095      * @dev Mints `tokenId` and transfers it to `to`.
1096      *
1097      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1098      *
1099      * Requirements:
1100      *
1101      * - `tokenId` must not exist.
1102      * - `to` cannot be the zero address.
1103      *
1104      * Emits a {Transfer} event.
1105      */
1106     function _mint(address to, uint256 tokenId) internal virtual {
1107         require(to != address(0), "ERC721: mint to the zero address");
1108         require(!_exists(tokenId), "ERC721: token already minted");
1109 
1110         _beforeTokenTransfer(address(0), to, tokenId);
1111 
1112         _balances[to] += 1;
1113         _owners[tokenId] = to;
1114 
1115         emit Transfer(address(0), to, tokenId);
1116     }
1117 
1118     /**
1119      * @dev Destroys `tokenId`.
1120      * The approval is cleared when the token is burned.
1121      *
1122      * Requirements:
1123      *
1124      * - `tokenId` must exist.
1125      *
1126      * Emits a {Transfer} event.
1127      */
1128     function _burn(uint256 tokenId) internal virtual {
1129         address owner = ERC721.ownerOf(tokenId);
1130 
1131         _beforeTokenTransfer(owner, address(0), tokenId);
1132 
1133         // Clear approvals
1134         _approve(address(0), tokenId);
1135 
1136         _balances[owner] -= 1;
1137         delete _owners[tokenId];
1138 
1139         emit Transfer(owner, address(0), tokenId);
1140     }
1141 
1142     /**
1143      * @dev Transfers `tokenId` from `from` to `to`.
1144      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1145      *
1146      * Requirements:
1147      *
1148      * - `to` cannot be the zero address.
1149      * - `tokenId` token must be owned by `from`.
1150      *
1151      * Emits a {Transfer} event.
1152      */
1153     function _transfer(
1154         address from,
1155         address to,
1156         uint256 tokenId
1157     ) internal virtual {
1158         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1159         require(to != address(0), "ERC721: transfer to the zero address");
1160 
1161         _beforeTokenTransfer(from, to, tokenId);
1162 
1163         // Clear approvals from the previous owner
1164         _approve(address(0), tokenId);
1165 
1166         _balances[from] -= 1;
1167         _balances[to] += 1;
1168         _owners[tokenId] = to;
1169 
1170         emit Transfer(from, to, tokenId);
1171     }
1172 
1173     /**
1174      * @dev Approve `to` to operate on `tokenId`
1175      *
1176      * Emits a {Approval} event.
1177      */
1178     function _approve(address to, uint256 tokenId) internal virtual {
1179         _tokenApprovals[tokenId] = to;
1180         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1181     }
1182 
1183     /**
1184      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1185      * The call is not executed if the target address is not a contract.
1186      *
1187      * @param from address representing the previous owner of the given token ID
1188      * @param to target address that will receive the tokens
1189      * @param tokenId uint256 ID of the token to be transferred
1190      * @param _data bytes optional data to send along with the call
1191      * @return bool whether the call correctly returned the expected magic value
1192      */
1193     function _checkOnERC721Received(
1194         address from,
1195         address to,
1196         uint256 tokenId,
1197         bytes memory _data
1198     ) private returns (bool) {
1199         if (to.isContract()) {
1200             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1201                 return retval == IERC721Receiver(to).onERC721Received.selector;
1202             } catch (bytes memory reason) {
1203                 if (reason.length == 0) {
1204                     revert("ERC721: transfer to non ERC721Receiver implementer");
1205                 } else {
1206                     assembly {
1207                         revert(add(32, reason), mload(reason))
1208                     }
1209                 }
1210             }
1211         } else {
1212             return true;
1213         }
1214     }
1215 
1216     /**
1217      * @dev Hook that is called before any token transfer. This includes minting
1218      * and burning.
1219      *
1220      * Calling conditions:
1221      *
1222      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1223      * transferred to `to`.
1224      * - When `from` is zero, `tokenId` will be minted for `to`.
1225      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1226      * - `from` and `to` are never both zero.
1227      *
1228      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1229      */
1230     function _beforeTokenTransfer(
1231         address from,
1232         address to,
1233         uint256 tokenId
1234     ) internal virtual {}
1235 }
1236 
1237 
1238 
1239 /**
1240  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1241  * @dev See https://eips.ethereum.org/EIPS/eip-721
1242  */
1243 interface IERC721Enumerable is IERC721 {
1244     /**
1245      * @dev Returns the total amount of tokens stored by the contract.
1246      */
1247     function totalSupply() external view returns (uint256);
1248 
1249     /**
1250      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1251      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1252      */
1253     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1254 
1255     /**
1256      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1257      * Use along with {totalSupply} to enumerate all tokens.
1258      */
1259     function tokenByIndex(uint256 index) external view returns (uint256);
1260 }
1261 
1262 
1263 /**
1264  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1265  * enumerability of all the token ids in the contract as well as all token ids owned by each
1266  * account.
1267  */
1268 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1269     // Mapping from owner to list of owned token IDs
1270     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1271 
1272     // Mapping from token ID to index of the owner tokens list
1273     mapping(uint256 => uint256) private _ownedTokensIndex;
1274 
1275     // Array with all token ids, used for enumeration
1276     uint256[] private _allTokens;
1277 
1278     // Mapping from token id to position in the allTokens array
1279     mapping(uint256 => uint256) private _allTokensIndex;
1280 
1281     /**
1282      * @dev See {IERC165-supportsInterface}.
1283      */
1284     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1285         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1286     }
1287 
1288     /**
1289      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1290      */
1291     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1292         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1293         return _ownedTokens[owner][index];
1294     }
1295 
1296     /**
1297      * @dev See {IERC721Enumerable-totalSupply}.
1298      */
1299     function totalSupply() public view virtual override returns (uint256) {
1300         return _allTokens.length;
1301     }
1302 
1303     /**
1304      * @dev See {IERC721Enumerable-tokenByIndex}.
1305      */
1306     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1307         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1308         return _allTokens[index];
1309     }
1310 
1311     /**
1312      * @dev Hook that is called before any token transfer. This includes minting
1313      * and burning.
1314      *
1315      * Calling conditions:
1316      *
1317      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1318      * transferred to `to`.
1319      * - When `from` is zero, `tokenId` will be minted for `to`.
1320      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1321      * - `from` cannot be the zero address.
1322      * - `to` cannot be the zero address.
1323      *
1324      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1325      */
1326     function _beforeTokenTransfer(
1327         address from,
1328         address to,
1329         uint256 tokenId
1330     ) internal virtual override {
1331         super._beforeTokenTransfer(from, to, tokenId);
1332 
1333         if (from == address(0)) {
1334             _addTokenToAllTokensEnumeration(tokenId);
1335         } else if (from != to) {
1336             _removeTokenFromOwnerEnumeration(from, tokenId);
1337         }
1338         if (to == address(0)) {
1339             _removeTokenFromAllTokensEnumeration(tokenId);
1340         } else if (to != from) {
1341             _addTokenToOwnerEnumeration(to, tokenId);
1342         }
1343     }
1344 
1345     /**
1346      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1347      * @param to address representing the new owner of the given token ID
1348      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1349      */
1350     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1351         uint256 length = ERC721.balanceOf(to);
1352         _ownedTokens[to][length] = tokenId;
1353         _ownedTokensIndex[tokenId] = length;
1354     }
1355 
1356     /**
1357      * @dev Private function to add a token to this extension's token tracking data structures.
1358      * @param tokenId uint256 ID of the token to be added to the tokens list
1359      */
1360     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1361         _allTokensIndex[tokenId] = _allTokens.length;
1362         _allTokens.push(tokenId);
1363     }
1364 
1365     /**
1366      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1367      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1368      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1369      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1370      * @param from address representing the previous owner of the given token ID
1371      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1372      */
1373     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1374         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1375         // then delete the last slot (swap and pop).
1376 
1377         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1378         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1379 
1380         // When the token to delete is the last token, the swap operation is unnecessary
1381         if (tokenIndex != lastTokenIndex) {
1382             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1383 
1384             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1385             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1386         }
1387 
1388         // This also deletes the contents at the last position of the array
1389         delete _ownedTokensIndex[tokenId];
1390         delete _ownedTokens[from][lastTokenIndex];
1391     }
1392 
1393     /**
1394      * @dev Private function to remove a token from this extension's token tracking data structures.
1395      * This has O(1) time complexity, but alters the order of the _allTokens array.
1396      * @param tokenId uint256 ID of the token to be removed from the tokens list
1397      */
1398     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1399         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1400         // then delete the last slot (swap and pop).
1401 
1402         uint256 lastTokenIndex = _allTokens.length - 1;
1403         uint256 tokenIndex = _allTokensIndex[tokenId];
1404 
1405         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1406         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1407         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1408         uint256 lastTokenId = _allTokens[lastTokenIndex];
1409 
1410         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1411         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1412 
1413         // This also deletes the contents at the last position of the array
1414         delete _allTokensIndex[tokenId];
1415         _allTokens.pop();
1416     }
1417 }
1418 
1419 
1420 contract Dragos is ERC721Enumerable, ReentrancyGuard, Ownable {
1421     using SafeMath for uint256;
1422     using Strings for uint256;
1423 
1424     bool public saleActive;
1425     bool public whitelistIsActive;
1426     bool public revealActive;
1427     string public prerevealURI;
1428     address payable mintData;
1429 
1430     address payoutWallet1;
1431     address payoutWallet2;
1432 
1433     uint256 mintPrice = 150000000000000000; // 0.15 ETH
1434     uint256 whitelistMintPrice = 100000000000000000; // 0.1 ETH
1435     uint256 creationTime;
1436     uint256 public MAX_TOKEN_SUPPLY = 6000;
1437     uint256 maxWhitelistMints = 3;
1438     uint256 maxMintsPerTxn = 5;
1439     uint256 maxSpecialDragons = 15;
1440     uint256 specialDragonsMinted;
1441     uint256 bytPayoutPercentage;
1442 
1443     bytes32[] _whitelistRootHash;
1444 
1445     mapping(address => uint256) public numberOfWhitelistMints;
1446     mapping(uint256 => uint256) public tokenIdToSpecialDragon;
1447 
1448     mapping(uint256 => string) private _dragosNameByTokenId;
1449     mapping(uint256 => uint256) private _dragosBirthdayByTokenId;
1450 
1451     function setSale() external onlyOwner
1452     {
1453         saleActive = !saleActive;
1454     }
1455 
1456     function setWhitelistSale() external onlyOwner
1457     {
1458         whitelistIsActive = !whitelistIsActive;
1459     }
1460 
1461     function setRevealActive() external onlyOwner
1462     {
1463         revealActive = !revealActive;
1464     }
1465 
1466     function setPrerevealURI(string memory prerevealURI_) external onlyOwner {
1467         prerevealURI = prerevealURI_;
1468     }
1469 
1470     function addToWhitelistRootHash(bytes32 _hash) public onlyOwner{
1471         _whitelistRootHash.push(_hash);
1472     }
1473 
1474     function hasMinted(uint256 tokenId) external view returns (bool)
1475     {
1476         return _exists(tokenId);
1477     }
1478 
1479     function getCreationTime() external view returns (uint256)
1480     {
1481         return creationTime;
1482     }
1483 
1484     function getLegendary(uint256 tokenId) external view returns (uint256)
1485     {
1486         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1487         return tokenIdToSpecialDragon[tokenId];
1488     }
1489 
1490     function getName(uint256 tokenId) public view returns (string memory) {
1491         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1492 
1493         if (bytes(_dragosNameByTokenId[tokenId]).length > 0) {
1494             return _dragosNameByTokenId[tokenId];
1495         } else {
1496             return string(abi.encodePacked("Dragos #", toString(tokenId)));
1497         }
1498 
1499     }
1500 
1501     function getBackground(uint256 tokenId) public view returns (string memory) {
1502         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1503         string memory output;
1504         
1505         Dragos dataContract = Dragos(mintData);
1506         output = dataContract.getBackground(tokenId);
1507 
1508         return output;
1509     }
1510     
1511     function getFaction(uint256 tokenId) public view returns (string memory) {
1512         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1513         string memory output;
1514         
1515         Dragos dataContract = Dragos(mintData);
1516         output = dataContract.getFaction(tokenId);
1517 
1518         return output;
1519     }
1520     
1521     function getWings(uint256 tokenId) public view returns (string memory) {
1522         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1523         string memory output;
1524         
1525         Dragos dataContract = Dragos(mintData);
1526         output = dataContract.getWings(tokenId);
1527 
1528         return output;
1529     }
1530 
1531     function getWingTips(uint256 tokenId) public view returns (string memory) {
1532         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1533         string memory output;
1534         
1535         Dragos dataContract = Dragos(mintData);
1536         output = dataContract.getWingTips(tokenId);
1537 
1538         return output;
1539     }
1540     
1541     function getClothes(uint256 tokenId) public view returns (string memory) {
1542         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1543         string memory output;
1544         
1545         Dragos dataContract = Dragos(mintData);
1546         output = dataContract.getClothes(tokenId);
1547 
1548         return output;
1549     }
1550 
1551     function getNecklace(uint256 tokenId) public view returns (string memory) {
1552         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1553         string memory output;
1554         
1555         Dragos dataContract = Dragos(mintData);
1556         output = dataContract.getNecklace(tokenId);
1557 
1558         return output;
1559     }
1560     
1561     function getMouth(uint256 tokenId) public view returns (string memory) {
1562         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1563         string memory output;
1564         
1565         Dragos dataContract = Dragos(mintData);
1566         output = dataContract.getMouth(tokenId);
1567 
1568         return output;
1569     }
1570     
1571     function getEyes(uint256 tokenId) public view returns (string memory) {
1572         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1573         string memory output;
1574         
1575         Dragos dataContract = Dragos(mintData);
1576         output = dataContract.getEyes(tokenId);
1577 
1578         return output;
1579     }
1580     
1581     function getHat(uint256 tokenId) public view returns (string memory) {
1582         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1583         string memory output;
1584 
1585         Dragos dataContract = Dragos(mintData);
1586         output = dataContract.getHat(tokenId);
1587 
1588         return output;
1589     }
1590 
1591     function getBirthday(uint256 tokenId) public view returns (uint256) {
1592         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1593 
1594         return _dragosBirthdayByTokenId[tokenId];
1595     }
1596 
1597     function setBirthday(uint256 tokenId) internal {
1598         uint256 epoch = 1643673600 + 14 days; // Feb. 1, 2022 00:00:00 UTC + 14 days = Feb. 15
1599         uint256 daysToBday = uint256(keccak256(abi.encodePacked(toString(block.timestamp), toString(tokenId)))) % 91;
1600         uint256 birthday = epoch + (daysToBday * 1 days);
1601 
1602         _dragosBirthdayByTokenId[tokenId] = birthday;
1603     }
1604 
1605     function getStats(uint256 statIndex, uint256 tokenId) public view returns (string memory statName, uint256 statValue) {
1606         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1607 
1608         Dragos dataContract = Dragos(mintData);
1609         (statName, statValue) = dataContract.getStats(statIndex, tokenId);
1610 
1611         return (statName, statValue);
1612     }
1613 
1614     function tokenURI(uint256 tokenId) override public view returns (string memory) {
1615         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1616         if(revealActive)
1617         {
1618             string memory output;
1619 
1620             Dragos dataContract = Dragos(mintData);
1621             output = dataContract.tokenURI(tokenId);
1622 
1623             return output;
1624         }
1625         else
1626         {
1627             return prerevealURI;
1628         }
1629     }
1630 
1631     function validateName(string memory str) internal pure returns (bool){
1632 		bytes memory b = bytes(str);
1633 		if(b.length < 1) return false;
1634 		if(b.length > 25) return false; // Cannot be longer than 25 characters
1635 		if(b[0] == 0x20) return false; // Leading space
1636 		if (b[b.length - 1] == 0x20) return false; // Trailing space
1637 
1638 		bytes1 lastChar = b[0];
1639 
1640 		for(uint i; i<b.length; i++){
1641 			bytes1 char = b[i];
1642 
1643 			if (char == 0x20 && lastChar == 0x20) return false; // Cannot contain continous spaces
1644 
1645 			if(
1646 				!(char >= 0x30 && char <= 0x39) && //9-0
1647 				!(char >= 0x41 && char <= 0x5A) && //A-Z
1648 				!(char >= 0x61 && char <= 0x7A) && //a-z
1649 				!(char == 0x20) //space
1650 			)
1651 				return false;
1652 
1653 			lastChar = char;
1654 		}
1655 
1656 		return true;
1657 	}
1658 
1659     function whitelistValidated(address wallet, uint256 index, bytes32[] memory proof, bytes32[] memory _rootHash) internal pure returns (bool) {
1660         uint256 amount = 1;
1661 
1662         // Compute the merkle root
1663         bytes32 node = keccak256(abi.encodePacked(index, wallet, amount));
1664         uint256 path = index;
1665         for (uint16 i = 0; i < proof.length; i++) {
1666             if ((path & 0x01) == 1) {
1667                 node = keccak256(abi.encodePacked(proof[i], node));
1668             } else {
1669                 node = keccak256(abi.encodePacked(node, proof[i]));
1670             }
1671             path /= 2;
1672         }
1673 
1674         // Check the merkle proof against the root hash array
1675         for(uint i = 0; i < _rootHash.length; i++)
1676         {
1677             if (node == _rootHash[i])
1678             {
1679                 return true;
1680             }
1681         }
1682 
1683         return false;
1684     }
1685 
1686     function mint(uint256 amount, string[] memory names) public nonReentrant payable{
1687         require(saleActive, "Public mint is currently closed");
1688         require(amount <= maxMintsPerTxn, "Purchase exceeds max mints per transaction");
1689         require(totalSupply().add(amount) <= MAX_TOKEN_SUPPLY, "Purchase would exceed max supply");
1690         require(msg.value == amount.mul(mintPrice), "Incorrect payment amount");
1691         uint256 tokenId = totalSupply();
1692 
1693         for(uint256 i = 0; i < amount; i++)
1694         {
1695             if (bytes(names[i]).length > 0) {
1696                 require(validateName(names[i]), "Name is invalid");
1697                 _dragosNameByTokenId[tokenId + i] = names[i];
1698             }
1699             
1700             setBirthday(tokenId + i);
1701 
1702             if(isDragonSpecial(tokenId + i))
1703             {
1704                 specialDragonsMinted++;
1705                 tokenIdToSpecialDragon[tokenId + i] = specialDragonsMinted;
1706             }
1707             
1708             _safeMint(_msgSender(), tokenId + i);
1709         }
1710     }
1711 
1712     function whitelistMint(uint256 amount, uint256 spotInWhitelist, bytes32[] memory proof, string[] memory names) public nonReentrant payable{
1713         require(whitelistIsActive, "Whitelist mint is currently closed");
1714         require(totalSupply().add(amount) <= MAX_TOKEN_SUPPLY, "Purchase would exceed max supply");
1715         require(whitelistValidated(_msgSender(), spotInWhitelist, proof, _whitelistRootHash), "You're not on the giveaway list");
1716         require(numberOfWhitelistMints[_msgSender()].add(amount) <= maxWhitelistMints, "You do not have that many whitelist mints");
1717         require(msg.value == amount.mul(whitelistMintPrice), "Incorrect payment amount");
1718 
1719         uint256 tokenId = totalSupply();
1720 
1721         for(uint256 i = 0; i < amount; i++)
1722         {
1723             if (bytes(names[i]).length > 0) {
1724                 require(validateName(names[i]), "Name is invalid");
1725                 _dragosNameByTokenId[tokenId + i] = names[i];
1726             }
1727             
1728             setBirthday(tokenId + i);
1729 
1730             if(isDragonSpecial(tokenId + i))
1731             {
1732                 specialDragonsMinted++;
1733                 tokenIdToSpecialDragon[tokenId + i] = specialDragonsMinted;
1734             }
1735             
1736             _safeMint(_msgSender(), tokenId + i);
1737         }
1738 
1739         numberOfWhitelistMints[_msgSender()] += amount;
1740     }
1741 
1742     function isDragonSpecial(uint256 tokenId) internal view returns(bool)
1743     {
1744         uint256 rand = uint256(keccak256(abi.encodePacked(toString(tokenId), toString(creationTime))));
1745         if(rand % 1000 > 996)
1746         {
1747             return true;
1748         }
1749 
1750         //In the case that there are enough special dragons left that all remaining tokens should be special return true
1751         if(totalSupply() + maxSpecialDragons - specialDragonsMinted == MAX_TOKEN_SUPPLY)
1752         {
1753             return true;
1754         }
1755 
1756         return false;
1757     }
1758 
1759     function setWalletOne(address _walletAddress) external onlyOwner {
1760         payoutWallet1 = _walletAddress;
1761     }
1762 
1763     function setWalletTwo(address _walletAddress) external onlyOwner {
1764         payoutWallet2 = _walletAddress;
1765     }
1766 
1767     function setMintContract(address payable contractAddress) public onlyOwner {
1768         mintData = contractAddress;
1769     }
1770 
1771     function withdraw() external onlyOwner {
1772         require(payoutWallet1 != address(0), "wallet 1 not set");
1773         require(payoutWallet2 != address(0), "wallet 2 not set");
1774         uint256 balance = address(this).balance;
1775         uint256 walletBalance = balance.mul(100 - bytPayoutPercentage).div(100);
1776         payable(payoutWallet1).transfer(walletBalance);
1777         payable(payoutWallet2).transfer(balance.sub(walletBalance));
1778     }
1779     
1780     constructor() ERC721("Dragos", "DRAGOS") Ownable() {
1781         creationTime = block.timestamp;
1782         payoutWallet1 = 0x8d3Aad1100c67ecCef8426151DC8C4b659012a6F; // dragos payout wallet
1783         payoutWallet2 = 0xFd182CAc22329a58375bf5f93B2C33E83c881540; // byt payout wallet
1784         bytPayoutPercentage = 9;
1785         prerevealURI = "https://dragos.mypinata.cloud/ipfs/QmZdZhygDZTsG6KC71zk9XMohScmFKZryFpeGZ939oLzX9";
1786         addToWhitelistRootHash(0xd963e460e626c03996dd9aa0626ad93a829b3eaaedb764402193e10981172518);
1787         mintData = payable(0x77591D3868D657B31b788C430E9C2A9194768790); 
1788     }
1789 
1790     fallback() external payable {}
1791 
1792     function toString(uint256 value) internal pure returns (string memory) {
1793     // Inspired by OraclizeAPI's implementation - MIT license
1794     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1795 
1796         if (value == 0) {
1797             return "0";
1798         }
1799         uint256 temp = value;
1800         uint256 digits;
1801         while (temp != 0) {
1802             digits++;
1803             temp /= 10;
1804         }
1805         bytes memory buffer = new bytes(digits);
1806         while (value != 0) {
1807             digits -= 1;
1808             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1809             value /= 10;
1810         }
1811         return string(buffer);
1812     }
1813 }