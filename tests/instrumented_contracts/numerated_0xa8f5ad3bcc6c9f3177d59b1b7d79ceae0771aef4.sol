1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 // CAUTION
7 // This version of SafeMath should only be used with Solidity 0.8 or later,
8 // because it relies on the compiler's built in overflow checks.
9 
10 /**
11  * @dev Wrappers over Solidity's arithmetic operations.
12  *
13  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
14  * now has built in overflow checking.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, with an overflow flag.
19      *
20      * _Available since v3.4._
21      */
22     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
23         unchecked {
24             uint256 c = a + b;
25             if (c < a) return (false, 0);
26             return (true, c);
27         }
28     }
29 
30     /**
31      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
32      *
33      * _Available since v3.4._
34      */
35     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
36         unchecked {
37             if (b > a) return (false, 0);
38             return (true, a - b);
39         }
40     }
41 
42     /**
43      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
44      *
45      * _Available since v3.4._
46      */
47     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         unchecked {
49             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
50             // benefit is lost if 'b' is also tested.
51             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
52             if (a == 0) return (true, 0);
53             uint256 c = a * b;
54             if (c / a != b) return (false, 0);
55             return (true, c);
56         }
57     }
58 
59     /**
60      * @dev Returns the division of two unsigned integers, with a division by zero flag.
61      *
62      * _Available since v3.4._
63      */
64     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
65         unchecked {
66             if (b == 0) return (false, 0);
67             return (true, a / b);
68         }
69     }
70 
71     /**
72      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
73      *
74      * _Available since v3.4._
75      */
76     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
77         unchecked {
78             if (b == 0) return (false, 0);
79             return (true, a % b);
80         }
81     }
82 
83     /**
84      * @dev Returns the addition of two unsigned integers, reverting on
85      * overflow.
86      *
87      * Counterpart to Solidity's `+` operator.
88      *
89      * Requirements:
90      *
91      * - Addition cannot overflow.
92      */
93     function add(uint256 a, uint256 b) internal pure returns (uint256) {
94         return a + b;
95     }
96 
97     /**
98      * @dev Returns the subtraction of two unsigned integers, reverting on
99      * overflow (when the result is negative).
100      *
101      * Counterpart to Solidity's `-` operator.
102      *
103      * Requirements:
104      *
105      * - Subtraction cannot overflow.
106      */
107     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
108         return a - b;
109     }
110 
111     /**
112      * @dev Returns the multiplication of two unsigned integers, reverting on
113      * overflow.
114      *
115      * Counterpart to Solidity's `*` operator.
116      *
117      * Requirements:
118      *
119      * - Multiplication cannot overflow.
120      */
121     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
122         return a * b;
123     }
124 
125     /**
126      * @dev Returns the integer division of two unsigned integers, reverting on
127      * division by zero. The result is rounded towards zero.
128      *
129      * Counterpart to Solidity's `/` operator.
130      *
131      * Requirements:
132      *
133      * - The divisor cannot be zero.
134      */
135     function div(uint256 a, uint256 b) internal pure returns (uint256) {
136         return a / b;
137     }
138 
139     /**
140      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
141      * reverting when dividing by zero.
142      *
143      * Counterpart to Solidity's `%` operator. This function uses a `revert`
144      * opcode (which leaves remaining gas untouched) while Solidity uses an
145      * invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      *
149      * - The divisor cannot be zero.
150      */
151     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
152         return a % b;
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
157      * overflow (when the result is negative).
158      *
159      * CAUTION: This function is deprecated because it requires allocating memory for the error
160      * message unnecessarily. For custom revert reasons use {trySub}.
161      *
162      * Counterpart to Solidity's `-` operator.
163      *
164      * Requirements:
165      *
166      * - Subtraction cannot overflow.
167      */
168     function sub(
169         uint256 a,
170         uint256 b,
171         string memory errorMessage
172     ) internal pure returns (uint256) {
173         unchecked {
174             require(b <= a, errorMessage);
175             return a - b;
176         }
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
181      * division by zero. The result is rounded towards zero.
182      *
183      * Counterpart to Solidity's `/` operator. Note: this function uses a
184      * `revert` opcode (which leaves remaining gas untouched) while Solidity
185      * uses an invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function div(
192         uint256 a,
193         uint256 b,
194         string memory errorMessage
195     ) internal pure returns (uint256) {
196         unchecked {
197             require(b > 0, errorMessage);
198             return a / b;
199         }
200     }
201 
202     /**
203      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
204      * reverting with custom message when dividing by zero.
205      *
206      * CAUTION: This function is deprecated because it requires allocating memory for the error
207      * message unnecessarily. For custom revert reasons use {tryMod}.
208      *
209      * Counterpart to Solidity's `%` operator. This function uses a `revert`
210      * opcode (which leaves remaining gas untouched) while Solidity uses an
211      * invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function mod(
218         uint256 a,
219         uint256 b,
220         string memory errorMessage
221     ) internal pure returns (uint256) {
222         unchecked {
223             require(b > 0, errorMessage);
224             return a % b;
225         }
226     }
227 }
228 
229 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @dev Provides information about the current execution context, including the
235  * sender of the transaction and its data. While these are generally available
236  * via msg.sender and msg.data, they should not be accessed in such a direct
237  * manner, since when dealing with meta-transactions the account sending and
238  * paying for execution may not be the actual sender (as far as an application
239  * is concerned).
240  *
241  * This contract is only required for intermediate, library-like contracts.
242  */
243 abstract contract Context {
244     function _msgSender() internal view virtual returns (address) {
245         return msg.sender;
246     }
247 
248     function _msgData() internal view virtual returns (bytes calldata) {
249         return msg.data;
250     }
251 }
252 
253 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
254 
255 pragma solidity ^0.8.0;
256 
257 /**
258  * @dev Contract module which provides a basic access control mechanism, where
259  * there is an account (an owner) that can be granted exclusive access to
260  * specific functions.
261  *
262  * By default, the owner account will be the one that deploys the contract. This
263  * can later be changed with {transferOwnership}.
264  *
265  * This module is used through inheritance. It will make available the modifier
266  * `onlyOwner`, which can be applied to your functions to restrict their use to
267  * the owner.
268  */
269 abstract contract Ownable is Context {
270     address private _owner;
271 
272     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
273 
274     /**
275      * @dev Initializes the contract setting the deployer as the initial owner.
276      */
277     constructor() {
278         _transferOwnership(_msgSender());
279     }
280 
281     /**
282      * @dev Throws if called by any account other than the owner.
283      */
284     modifier onlyOwner() {
285         _checkOwner();
286         _;
287     }
288 
289     /**
290      * @dev Returns the address of the current owner.
291      */
292     function owner() public view virtual returns (address) {
293         return _owner;
294     }
295 
296     /**
297      * @dev Throws if the sender is not the owner.
298      */
299     function _checkOwner() internal view virtual {
300         require(owner() == _msgSender(), "Ownable: caller is not the owner");
301     }
302 
303     /**
304      * @dev Leaves the contract without owner. It will not be possible to call
305      * `onlyOwner` functions anymore. Can only be called by the current owner.
306      *
307      * NOTE: Renouncing ownership will leave the contract without an owner,
308      * thereby removing any functionality that is only available to the owner.
309      */
310     function renounceOwnership() public virtual onlyOwner {
311         _transferOwnership(address(0));
312     }
313 
314     /**
315      * @dev Transfers ownership of the contract to a new account (`newOwner`).
316      * Can only be called by the current owner.
317      */
318     function transferOwnership(address newOwner) public virtual onlyOwner {
319         require(newOwner != address(0), "Ownable: new owner is the zero address");
320         _transferOwnership(newOwner);
321     }
322 
323     /**
324      * @dev Transfers ownership of the contract to a new account (`newOwner`).
325      * Internal function without access restriction.
326      */
327     function _transferOwnership(address newOwner) internal virtual {
328         address oldOwner = _owner;
329         _owner = newOwner;
330         emit OwnershipTransferred(oldOwner, newOwner);
331     }
332 }
333 
334 pragma solidity ^0.8.0;
335 
336 /**
337  * @dev Collection of functions related to the address type
338  */
339 library Address {
340     /**
341      * @dev Returns true if `account` is a contract.
342      *
343      * [IMPORTANT]
344      * ====
345      * It is unsafe to assume that an address for which this function returns
346      * false is an externally-owned account (EOA) and not a contract.
347      *
348      * Among others, `isContract` will return false for the following
349      * types of addresses:
350      *
351      *  - an externally-owned account
352      *  - a contract in construction
353      *  - an address where a contract will be created
354      *  - an address where a contract lived, but was destroyed
355      * ====
356      */
357     function isContract(address account) internal view returns (bool) {
358         // This method relies on extcodesize, which returns 0 for contracts in
359         // construction, since the code is only stored at the end of the
360         // constructor execution.
361 
362         uint256 size;
363         assembly {
364             size := extcodesize(account)
365         }
366         return size > 0;
367     }
368 
369     /**
370      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
371      * `recipient`, forwarding all available gas and reverting on errors.
372      *
373      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
374      * of certain opcodes, possibly making contracts go over the 2300 gas limit
375      * imposed by `transfer`, making them unable to receive funds via
376      * `transfer`. {sendValue} removes this limitation.
377      *
378      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
379      *
380      * IMPORTANT: because control is transferred to `recipient`, care must be
381      * taken to not create reentrancy vulnerabilities. Consider using
382      * {ReentrancyGuard} or the
383      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
384      */
385     function sendValue(address payable recipient, uint256 amount) internal {
386         require(address(this).balance >= amount, "Address: insufficient balance");
387 
388         (bool success, ) = recipient.call{value: amount}("");
389         require(success, "Address: unable to send value, recipient may have reverted");
390     }
391 
392     /**
393      * @dev Performs a Solidity function call using a low level `call`. A
394      * plain `call` is an unsafe replacement for a function call: use this
395      * function instead.
396      *
397      * If `target` reverts with a revert reason, it is bubbled up by this
398      * function (like regular Solidity function calls).
399      *
400      * Returns the raw returned data. To convert to the expected return value,
401      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
402      *
403      * Requirements:
404      *
405      * - `target` must be a contract.
406      * - calling `target` with `data` must not revert.
407      *
408      * _Available since v3.1._
409      */
410     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
411         return functionCall(target, data, "Address: low-level call failed");
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
416      * `errorMessage` as a fallback revert reason when `target` reverts.
417      *
418      * _Available since v3.1._
419      */
420     function functionCall(
421         address target,
422         bytes memory data,
423         string memory errorMessage
424     ) internal returns (bytes memory) {
425         return functionCallWithValue(target, data, 0, errorMessage);
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
430      * but also transferring `value` wei to `target`.
431      *
432      * Requirements:
433      *
434      * - the calling contract must have an ETH balance of at least `value`.
435      * - the called Solidity function must be `payable`.
436      *
437      * _Available since v3.1._
438      */
439     function functionCallWithValue(
440         address target,
441         bytes memory data,
442         uint256 value
443     ) internal returns (bytes memory) {
444         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
449      * with `errorMessage` as a fallback revert reason when `target` reverts.
450      *
451      * _Available since v3.1._
452      */
453     function functionCallWithValue(
454         address target,
455         bytes memory data,
456         uint256 value,
457         string memory errorMessage
458     ) internal returns (bytes memory) {
459         require(address(this).balance >= value, "Address: insufficient balance for call");
460         require(isContract(target), "Address: call to non-contract");
461 
462         (bool success, bytes memory returndata) = target.call{value: value}(data);
463         return _verifyCallResult(success, returndata, errorMessage);
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
468      * but performing a static call.
469      *
470      * _Available since v3.3._
471      */
472     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
473         return functionStaticCall(target, data, "Address: low-level static call failed");
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
478      * but performing a static call.
479      *
480      * _Available since v3.3._
481      */
482     function functionStaticCall(
483         address target,
484         bytes memory data,
485         string memory errorMessage
486     ) internal view returns (bytes memory) {
487         require(isContract(target), "Address: static call to non-contract");
488 
489         (bool success, bytes memory returndata) = target.staticcall(data);
490         return _verifyCallResult(success, returndata, errorMessage);
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
495      * but performing a delegate call.
496      *
497      * _Available since v3.4._
498      */
499     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
500         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
505      * but performing a delegate call.
506      *
507      * _Available since v3.4._
508      */
509     function functionDelegateCall(
510         address target,
511         bytes memory data,
512         string memory errorMessage
513     ) internal returns (bytes memory) {
514         require(isContract(target), "Address: delegate call to non-contract");
515 
516         (bool success, bytes memory returndata) = target.delegatecall(data);
517         return _verifyCallResult(success, returndata, errorMessage);
518     }
519 
520     function _verifyCallResult(
521         bool success,
522         bytes memory returndata,
523         string memory errorMessage
524     ) private pure returns (bytes memory) {
525         if (success) {
526             return returndata;
527         } else {
528             // Look for revert reason and bubble it up if present
529             if (returndata.length > 0) {
530                 // The easiest way to bubble the revert reason is using memory via assembly
531 
532                 assembly {
533                     let returndata_size := mload(returndata)
534                     revert(add(32, returndata), returndata_size)
535                 }
536             } else {
537                 revert(errorMessage);
538             }
539         }
540     }
541 }
542 
543 
544 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
545 
546 pragma solidity ^0.8.0;
547 
548 /**
549  * @dev Contract module that helps prevent reentrant calls to a function.
550  *
551  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
552  * available, which can be applied to functions to make sure there are no nested
553  * (reentrant) calls to them.
554  *
555  * Note that because there is a single `nonReentrant` guard, functions marked as
556  * `nonReentrant` may not call one another. This can be worked around by making
557  * those functions `private`, and then adding `external` `nonReentrant` entry
558  * points to them.
559  *
560  * TIP: If you would like to learn more about reentrancy and alternative ways
561  * to protect against it, check out our blog post
562  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
563  */
564 abstract contract ReentrancyGuard {
565     // Booleans are more expensive than uint256 or any type that takes up a full
566     // word because each write operation emits an extra SLOAD to first read the
567     // slot's contents, replace the bits taken up by the boolean, and then write
568     // back. This is the compiler's defense against contract upgrades and
569     // pointer aliasing, and it cannot be disabled.
570 
571     // The values being non-zero value makes deployment a bit more expensive,
572     // but in exchange the refund on every call to nonReentrant will be lower in
573     // amount. Since refunds are capped to a percentage of the total
574     // transaction's gas, it is best to keep them low in cases like this one, to
575     // increase the likelihood of the full refund coming into effect.
576     uint256 private constant _NOT_ENTERED = 1;
577     uint256 private constant _ENTERED = 2;
578 
579     uint256 private _status;
580 
581     constructor() {
582         _status = _NOT_ENTERED;
583     }
584 
585     /**
586      * @dev Prevents a contract from calling itself, directly or indirectly.
587      * Calling a `nonReentrant` function from another `nonReentrant`
588      * function is not supported. It is possible to prevent this from happening
589      * by making the `nonReentrant` function external, and making it call a
590      * `private` function that does the actual work.
591      */
592     modifier nonReentrant() {
593         _nonReentrantBefore();
594         _;
595         _nonReentrantAfter();
596     }
597 
598     function _nonReentrantBefore() private {
599         // On the first call to nonReentrant, _notEntered will be true
600         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
601 
602         // Any calls to nonReentrant after this point will fail
603         _status = _ENTERED;
604     }
605 
606     function _nonReentrantAfter() private {
607         // By storing the original value once again, a refund is triggered (see
608         // https://eips.ethereum.org/EIPS/eip-2200)
609         _status = _NOT_ENTERED;
610     }
611 }
612 
613 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
614 
615 pragma solidity ^0.8.0;
616 
617 /**
618  * @dev Interface of the ERC165 standard, as defined in the
619  * https://eips.ethereum.org/EIPS/eip-165[EIP].
620  *
621  * Implementers can declare support of contract interfaces, which can then be
622  * queried by others ({ERC165Checker}).
623  *
624  * For an implementation, see {ERC165}.
625  */
626 interface IERC165 {
627     /**
628      * @dev Returns true if this contract implements the interface defined by
629      * `interfaceId`. See the corresponding
630      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
631      * to learn more about how these ids are created.
632      *
633      * This function call must use less than 30 000 gas.
634      */
635     function supportsInterface(bytes4 interfaceId) external view returns (bool);
636 }
637 
638 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
639 
640 pragma solidity ^0.8.0;
641 
642 
643 /**
644  * @dev Required interface of an ERC721 compliant contract.
645  */
646 interface IERC721 is IERC165 {
647     /**
648      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
649      */
650     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
651 
652     /**
653      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
654      */
655     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
656 
657     /**
658      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
659      */
660     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
661 
662     /**
663      * @dev Returns the number of tokens in ``owner``'s account.
664      */
665     function balanceOf(address owner) external view returns (uint256 balance);
666 
667     /**
668      * @dev Returns the owner of the `tokenId` token.
669      *
670      * Requirements:
671      *
672      * - `tokenId` must exist.
673      */
674     function ownerOf(uint256 tokenId) external view returns (address owner);
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
695 
696     /**
697      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
698      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
699      *
700      * Requirements:
701      *
702      * - `from` cannot be the zero address.
703      * - `to` cannot be the zero address.
704      * - `tokenId` token must exist and be owned by `from`.
705      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
706      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
707      *
708      * Emits a {Transfer} event.
709      */
710     function safeTransferFrom(
711         address from,
712         address to,
713         uint256 tokenId
714     ) external;
715 
716     /**
717      * @dev Transfers `tokenId` token from `from` to `to`.
718      *
719      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
720      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
721      * understand this adds an external call which potentially creates a reentrancy vulnerability.
722      *
723      * Requirements:
724      *
725      * - `from` cannot be the zero address.
726      * - `to` cannot be the zero address.
727      * - `tokenId` token must be owned by `from`.
728      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
729      *
730      * Emits a {Transfer} event.
731      */
732     function transferFrom(
733         address from,
734         address to,
735         uint256 tokenId
736     ) external;
737 
738     /**
739      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
740      * The approval is cleared when the token is transferred.
741      *
742      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
743      *
744      * Requirements:
745      *
746      * - The caller must own the token or be an approved operator.
747      * - `tokenId` must exist.
748      *
749      * Emits an {Approval} event.
750      */
751     function approve(address to, uint256 tokenId) external;
752 
753     /**
754      * @dev Approve or remove `operator` as an operator for the caller.
755      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
756      *
757      * Requirements:
758      *
759      * - The `operator` cannot be the caller.
760      *
761      * Emits an {ApprovalForAll} event.
762      */
763     function setApprovalForAll(address operator, bool _approved) external;
764 
765     /**
766      * @dev Returns the account approved for `tokenId` token.
767      *
768      * Requirements:
769      *
770      * - `tokenId` must exist.
771      */
772     function getApproved(uint256 tokenId) external view returns (address operator);
773 
774     /**
775      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
776      *
777      * See {setApprovalForAll}
778      */
779     function isApprovedForAll(address owner, address operator) external view returns (bool);
780 }
781 
782 pragma solidity ^0.8.0;
783 
784 contract SwapCore is ReentrancyGuard, Ownable {
785     IERC721 public xborg;
786 
787     using SafeMath for uint256;
788 
789     uint256 public MaxMintPerTX = 5;
790     uint256 public NFT_PRICE = 0.1 ether;
791     uint256 public saleStage = 0; //0 = Not Active, 1 = Xborg Holder Round, 2 = WL Round, 3 = Public Round
792     uint256 private publicSaleKey;
793     uint256 public StartMintIndex = 1086;
794     uint256 public CurrentMintIndex = 0;
795     uint256 public MaxMintIndex = 300;
796     uint256 public EndMintIndex = 1385;
797     address private constant WithDrawWallet1 = 0x592d4aE36dB7D196E0caD2c3083431B392f95e78;
798     address private constant WithDrawWallet2 = 0xC0c464514d6397b7b529A3650697Fd5967b5A892;
799     address public Mint_Wallet = 0xa7c99c679D9f5666Df45cc2350c119586dA0091F;
800 
801     event Withdraw(uint256 amount);
802     event TransferValue(uint256 amount);
803 
804     constructor(IERC721 _xborg, uint256 _key){
805         xborg = _xborg;
806         CurrentMintIndex = StartMintIndex;
807         publicSaleKey = _key;
808     }
809 
810     modifier callerIsUser() {
811         require(tx.origin == msg.sender, "The caller is another contract");
812         _;
813     }
814 
815     function AtomicMint(uint256 _Quantity, uint256 _WL, uint256 _CallerPublicSaleKey) external payable callerIsUser {
816         uint256 TotalPrice = NFT_PRICE.mul(_Quantity);
817         require(publicSaleKey == _CallerPublicSaleKey, "Called with incorrect public sale key");
818         require(xborg.balanceOf(Mint_Wallet) >= _Quantity, "Sale is not ready at the moment");       
819         require(saleStage > 0, "Sale is not active at the moment");
820         if(saleStage == 1) {
821             require(_WL <= saleStage, "You're not XBORG holder");
822         }  
823         else if(saleStage == 2) {
824             require(_WL <= saleStage, "You're not in WhiteList");
825         }
826 
827         require(CurrentMintIndex + _Quantity <= EndMintIndex, "Supply over the mint supply limit");
828         require(_Quantity <= MaxMintPerTX,"Mint exceed the limit per TX");
829         require(TotalPrice <= msg.value, "Ether value sent is not correct");
830         for (uint256 i = 0; i < _Quantity; i++) {
831             xborg.transferFrom(Mint_Wallet, msg.sender, CurrentMintIndex);
832             CurrentMintIndex++;
833         }
834     }
835     
836     function checkWalletBalance() external view returns (uint256 walletBalance) {
837         walletBalance = xborg.balanceOf(Mint_Wallet);
838         return walletBalance;
839     }
840 
841     function _withdraw(uint256 _amount) internal {
842         uint256 TotalAmount = _amount;
843         uint256 amount1 = TotalAmount.mul(50).div(100);
844         uint256 amount2 = TotalAmount.mul(50).div(100);
845 
846         payable(WithDrawWallet1).transfer(amount1);
847         payable(WithDrawWallet2).transfer(amount2);
848 
849         emit TransferValue(TotalAmount);
850     }
851 
852     function withdrawAll() external onlyOwner {
853         uint256 TotalBalance = address(this).balance;
854         _withdraw(TotalBalance);
855     }
856 
857     function withdraw(uint256 _amount) external onlyOwner {
858         _withdraw(_amount);
859     }
860 
861     function setMaxperTX(uint256 _MaxMintPerTX) external onlyOwner {
862         MaxMintPerTX = _MaxMintPerTX;
863     }
864 
865     function setMintPrice(uint256 _MintPrice) external onlyOwner {
866         NFT_PRICE = _MintPrice;
867     }
868 
869     function setMintIndex(uint256 _Index) external onlyOwner {
870         CurrentMintIndex = _Index;
871     }
872 
873     function setEndMintIndex(uint256 _Index) external onlyOwner {
874         EndMintIndex = _Index;
875     }
876 
877     function setMaxMintIndex(uint256 _Index) external onlyOwner {
878         MaxMintIndex = _Index;
879     }
880 
881     function setStartMintIndex(uint256 _Index) external onlyOwner {
882         StartMintIndex = _Index;
883     }
884 
885     function setSaleStage(uint256 _SaleStage) external onlyOwner {
886         saleStage = _SaleStage;
887         if(saleStage == 1) {
888             NFT_PRICE = 0.1 ether;
889             EndMintIndex = 1385;
890             MaxMintIndex = 300;
891         }  
892         else if(saleStage == 2) {
893             NFT_PRICE = 0.13 ether;
894             EndMintIndex = 2200;
895             MaxMintIndex = 1115;
896         }
897         else {
898             NFT_PRICE = 0.15 ether;
899             EndMintIndex = 2200;
900             MaxMintIndex = 1115;
901         }  
902     }
903 
904     function setPublicSaleKey(uint256 _PublicSaleKey) external onlyOwner {
905         publicSaleKey = _PublicSaleKey;
906     }
907 }