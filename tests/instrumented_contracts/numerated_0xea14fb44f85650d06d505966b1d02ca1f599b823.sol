1 // Created by Byt, Inc. https://byt.io
2 // SPDX-License-Identifier: MIT
3 
4 pragma solidity ^0.8.17;
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 /**
27  * @dev Interface of the ERC20 standard as defined in the EIP.
28  */
29 interface IERC20 {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51      * allowed to spend on behalf of `owner` through {transferFrom}. This is
52      * zero by default.
53      *
54      * This value changes when {approve} or {transferFrom} are called.
55      */
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Emitted when `value` tokens are moved from one account (`from`) to
87      * another (`to`).
88      *
89      * Note that `value` may be zero.
90      */
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     /**
94      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
95      * a call to {approve}. `value` is the new allowance.
96      */
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 /**
101  * @dev Contract module which provides a basic access control mechanism, where
102  * there is an account (an owner) that can be granted exclusive access to
103  * specific functions.
104  *
105  * By default, the owner account will be the one that deploys the contract. This
106  * can later be changed with {transferOwnership}.
107  *
108  * This module is used through inheritance. It will make available the modifier
109  * `onlyOwner`, which can be applied to your functions to restrict their use to
110  * the owner.
111  */
112 abstract contract Ownable is Context {
113     address private _owner;
114 
115     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
116 
117     /**
118      * @dev Initializes the contract setting the deployer as the initial owner.
119      */
120     constructor() {
121         _setOwner(_msgSender());
122     }
123 
124     /**
125      * @dev Returns the address of the current owner.
126      */
127     function owner() public view virtual returns (address) {
128         return _owner;
129     }
130 
131     /**
132      * @dev Throws if called by any account other than the owner.
133      */
134     modifier onlyOwner() {
135         require(owner() == _msgSender(), "Ownable: caller is not the owner");
136         _;
137     }
138 
139     /**
140      * @dev Leaves the contract without owner. It will not be possible to call
141      * `onlyOwner` functions anymore. Can only be called by the current owner.
142      *
143      * NOTE: Renouncing ownership will leave the contract without an owner,
144      * thereby removing any functionality that is only available to the owner.
145      */
146     function renounceOwnership() public virtual onlyOwner {
147         _setOwner(address(0));
148     }
149 
150     /**
151      * @dev Transfers ownership of the contract to a new account (`newOwner`).
152      * Can only be called by the current owner.
153      */
154     function transferOwnership(address newOwner) public virtual onlyOwner {
155         require(newOwner != address(0), "Ownable: new owner is the zero address");
156         _setOwner(newOwner);
157     }
158 
159     function _setOwner(address newOwner) private {
160         address oldOwner = _owner;
161         _owner = newOwner;
162         emit OwnershipTransferred(oldOwner, newOwner);
163     }
164 }
165 
166 /**
167  * @dev Collection of functions related to the address type
168  */
169 library Address {
170     /**
171      * @dev Returns true if `account` is a contract.
172      *
173      * [IMPORTANT]
174      * ====
175      * It is unsafe to assume that an address for which this function returns
176      * false is an externally-owned account (EOA) and not a contract.
177      *
178      * Among others, `isContract` will return false for the following
179      * types of addresses:
180      *
181      *  - an externally-owned account
182      *  - a contract in construction
183      *  - an address where a contract will be created
184      *  - an address where a contract lived, but was destroyed
185      * ====
186      */
187     function isContract(address account) internal view returns (bool) {
188         // This method relies on extcodesize, which returns 0 for contracts in
189         // construction, since the code is only stored at the end of the
190         // constructor execution.
191 
192         uint256 size;
193         assembly {
194             size := extcodesize(account)
195         }
196         return size > 0;
197     }
198 
199     /**
200      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
201      * `recipient`, forwarding all available gas and reverting on errors.
202      *
203      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
204      * of certain opcodes, possibly making contracts go over the 2300 gas limit
205      * imposed by `transfer`, making them unable to receive funds via
206      * `transfer`. {sendValue} removes this limitation.
207      *
208      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
209      *
210      * IMPORTANT: because control is transferred to `recipient`, care must be
211      * taken to not create reentrancy vulnerabilities. Consider using
212      * {ReentrancyGuard} or the
213      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
214      */
215     function sendValue(address payable recipient, uint256 amount) internal {
216         require(address(this).balance >= amount, "Address: insufficient balance");
217 
218         (bool success, ) = recipient.call{value: amount}("");
219         require(success, "Address: unable to send value, recipient may have reverted");
220     }
221 
222     /**
223      * @dev Performs a Solidity function call using a low level `call`. A
224      * plain `call` is an unsafe replacement for a function call: use this
225      * function instead.
226      *
227      * If `target` reverts with a revert reason, it is bubbled up by this
228      * function (like regular Solidity function calls).
229      *
230      * Returns the raw returned data. To convert to the expected return value,
231      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
232      *
233      * Requirements:
234      *
235      * - `target` must be a contract.
236      * - calling `target` with `data` must not revert.
237      *
238      * _Available since v3.1._
239      */
240     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
241         return functionCall(target, data, "Address: low-level call failed");
242     }
243 
244     /**
245      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
246      * `errorMessage` as a fallback revert reason when `target` reverts.
247      *
248      * _Available since v3.1._
249      */
250     function functionCall(
251         address target,
252         bytes memory data,
253         string memory errorMessage
254     ) internal returns (bytes memory) {
255         return functionCallWithValue(target, data, 0, errorMessage);
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
260      * but also transferring `value` wei to `target`.
261      *
262      * Requirements:
263      *
264      * - the calling contract must have an ETH balance of at least `value`.
265      * - the called Solidity function must be `payable`.
266      *
267      * _Available since v3.1._
268      */
269     function functionCallWithValue(
270         address target,
271         bytes memory data,
272         uint256 value
273     ) internal returns (bytes memory) {
274         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
275     }
276 
277     /**
278      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
279      * with `errorMessage` as a fallback revert reason when `target` reverts.
280      *
281      * _Available since v3.1._
282      */
283     function functionCallWithValue(
284         address target,
285         bytes memory data,
286         uint256 value,
287         string memory errorMessage
288     ) internal returns (bytes memory) {
289         require(address(this).balance >= value, "Address: insufficient balance for call");
290         require(isContract(target), "Address: call to non-contract");
291 
292         (bool success, bytes memory returndata) = target.call{value: value}(data);
293         return _verifyCallResult(success, returndata, errorMessage);
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
298      * but performing a static call.
299      *
300      * _Available since v3.3._
301      */
302     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
303         return functionStaticCall(target, data, "Address: low-level static call failed");
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
308      * but performing a static call.
309      *
310      * _Available since v3.3._
311      */
312     function functionStaticCall(
313         address target,
314         bytes memory data,
315         string memory errorMessage
316     ) internal view returns (bytes memory) {
317         require(isContract(target), "Address: static call to non-contract");
318 
319         (bool success, bytes memory returndata) = target.staticcall(data);
320         return _verifyCallResult(success, returndata, errorMessage);
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
325      * but performing a delegate call.
326      *
327      * _Available since v3.4._
328      */
329     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
330         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
335      * but performing a delegate call.
336      *
337      * _Available since v3.4._
338      */
339     function functionDelegateCall(
340         address target,
341         bytes memory data,
342         string memory errorMessage
343     ) internal returns (bytes memory) {
344         require(isContract(target), "Address: delegate call to non-contract");
345 
346         (bool success, bytes memory returndata) = target.delegatecall(data);
347         return _verifyCallResult(success, returndata, errorMessage);
348     }
349 
350     function _verifyCallResult(
351         bool success,
352         bytes memory returndata,
353         string memory errorMessage
354     ) private pure returns (bytes memory) {
355         if (success) {
356             return returndata;
357         } else {
358             // Look for revert reason and bubble it up if present
359             if (returndata.length > 0) {
360                 // The easiest way to bubble the revert reason is using memory via assembly
361 
362                 assembly {
363                     let returndata_size := mload(returndata)
364                     revert(add(32, returndata), returndata_size)
365                 }
366             } else {
367                 revert(errorMessage);
368             }
369         }
370     }
371 }
372 
373 /**
374  * @dev String operations.
375  */
376 library Strings {
377     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
378 
379     /**
380      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
381      */
382     function toString(uint256 value) internal pure returns (string memory) {
383         // Inspired by OraclizeAPI's implementation - MIT licence
384         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
385 
386         if (value == 0) {
387             return "0";
388         }
389         uint256 temp = value;
390         uint256 digits;
391         while (temp != 0) {
392             digits++;
393             temp /= 10;
394         }
395         bytes memory buffer = new bytes(digits);
396         while (value != 0) {
397             digits -= 1;
398             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
399             value /= 10;
400         }
401         return string(buffer);
402     }
403 
404     /**
405      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
406      */
407     function toHexString(uint256 value) internal pure returns (string memory) {
408         if (value == 0) {
409             return "0x00";
410         }
411         uint256 temp = value;
412         uint256 length = 0;
413         while (temp != 0) {
414             length++;
415             temp >>= 8;
416         }
417         return toHexString(value, length);
418     }
419 
420     /**
421      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
422      */
423     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
424         bytes memory buffer = new bytes(2 * length + 2);
425         buffer[0] = "0";
426         buffer[1] = "x";
427         for (uint256 i = 2 * length + 1; i > 1; --i) {
428             buffer[i] = _HEX_SYMBOLS[value & 0xf];
429             value >>= 4;
430         }
431         require(value == 0, "Strings: hex length insufficient");
432         return string(buffer);
433     }
434 }
435 
436 /**
437  * @dev Wrappers over Solidity's arithmetic operations with added overflow
438  * checks.
439  *
440  * Arithmetic operations in Solidity wrap on overflow. This can easily result
441  * in bugs, because programmers usually assume that an overflow raises an
442  * error, which is the standard behavior in high level programming languages.
443  * `SafeMath` restores this intuition by reverting the transaction when an
444  * operation overflows.
445  *
446  * Using this library instead of the unchecked operations eliminates an entire
447  * class of bugs, so it's recommended to use it always.
448  *
449  *
450  * @dev original library functions truncated to only needed functions reducing
451  * deployed bytecode.
452  */
453 library SafeMath {
454 
455     /**
456      * @dev Returns the subtraction of two unsigned integers, reverting on
457      * overflow (when the result is negative).
458      *
459      * Counterpart to Solidity's `-` operator.
460      *
461      * Requirements:
462      *
463      * - Subtraction cannot overflow.
464      */
465     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
466         require(b <= a, "SafeMath: subtraction overflow");
467         return a - b;
468     }
469 
470     /**
471      * @dev Returns the multiplication of two unsigned integers, reverting on
472      * overflow.
473      *
474      * Counterpart to Solidity's `*` operator.
475      *
476      * Requirements:
477      *
478      * - Multiplication cannot overflow.
479      */
480     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
481         if (a == 0) return 0;
482         uint256 c = a * b;
483         require(c / a == b, "SafeMath: multiplication overflow");
484         return c;
485     }
486 
487     /**
488      * @dev Returns the integer division of two unsigned integers, reverting on
489      * division by zero. The result is rounded towards zero.
490      *
491      * Counterpart to Solidity's `/` operator. Note: this function uses a
492      * `revert` opcode (which leaves remaining gas untouched) while Solidity
493      * uses an invalid opcode to revert (consuming all remaining gas).
494      *
495      * Requirements:
496      *
497      * - The divisor cannot be zero.
498      */
499     function div(uint256 a, uint256 b) internal pure returns (uint256) {
500         require(b > 0, "SafeMath: division by zero");
501         return a / b;
502     }
503 }
504 
505 /**
506  * @dev Contract module that helps prevent reentrant calls to a function.
507  *
508  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
509  * available, which can be applied to functions to make sure there are no nested
510  * (reentrant) calls to them.
511  *
512  * Note that because there is a single `nonReentrant` guard, functions marked as
513  * `nonReentrant` may not call one another. This can be worked around by making
514  * those functions `private`, and then adding `external` `nonReentrant` entry
515  * points to them.
516  *
517  * TIP: If you would like to learn more about reentrancy and alternative ways
518  * to protect against it, check out our blog post
519  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
520  */
521 abstract contract ReentrancyGuard {
522     // Booleans are more expensive than uint256 or any type that takes up a full
523     // word because each write operation emits an extra SLOAD to first read the
524     // slot's contents, replace the bits taken up by the boolean, and then write
525     // back. This is the compiler's defense against contract upgrades and
526     // pointer aliasing, and it cannot be disabled.
527 
528     // The values being non-zero value makes deployment a bit more expensive,
529     // but in exchange the refund on every call to nonReentrant will be lower in
530     // amount. Since refunds are capped to a percentage of the total
531     // transaction's gas, it is best to keep them low in cases like this one, to
532     // increase the likelihood of the full refund coming into effect.
533     uint256 private constant _NOT_ENTERED = 1;
534     uint256 private constant _ENTERED = 2;
535 
536     uint256 private _status;
537 
538     constructor() {
539         _status = _NOT_ENTERED;
540     }
541 
542     /**
543      * @dev Prevents a contract from calling itself, directly or indirectly.
544      * Calling a `nonReentrant` function from another `nonReentrant`
545      * function is not supported. It is possible to prevent this from happening
546      * by making the `nonReentrant` function external, and make it call a
547      * `private` function that does the actual work.
548      */
549     modifier nonReentrant() {
550         // On the first call to nonReentrant, _notEntered will be true
551         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
552 
553         // Any calls to nonReentrant after this point will fail
554         _status = _ENTERED;
555 
556         _;
557 
558         // By storing the original value once again, a refund is triggered (see
559         // https://eips.ethereum.org/EIPS/eip-2200)
560         _status = _NOT_ENTERED;
561     }
562 }
563 
564 
565 /**
566  * @dev Interface of the ERC165 standard, as defined in the
567  * https://eips.ethereum.org/EIPS/eip-165[EIP].
568  *
569  * Implementers can declare support of contract interfaces, which can then be
570  * queried by others ({ERC165Checker}).
571  *
572  * For an implementation, see {ERC165}.
573  */
574 interface IERC165 {
575     /**
576      * @dev Returns true if this contract implements the interface defined by
577      * `interfaceId`. See the corresponding
578      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
579      * to learn more about how these ids are created.
580      *
581      * This function call must use less than 30 000 gas.
582      */
583     function supportsInterface(bytes4 interfaceId) external view returns (bool);
584 }
585 
586 
587 /**
588  * @dev Implementation of the {IERC165} interface.
589  *
590  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
591  * for the additional interface id that will be supported. For example:
592  *
593  * ```solidity
594  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
595  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
596  * }
597  * ```
598  *
599  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
600  */
601 abstract contract ERC165 is IERC165 {
602     /**
603      * @dev See {IERC165-supportsInterface}.
604      */
605     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
606         return interfaceId == type(IERC165).interfaceId;
607     }
608 }
609 
610 
611 /**
612  * @title ERC721 token receiver interface
613  * @dev Interface for any contract that wants to support safeTransfers
614  * from ERC721 asset contracts.
615  */
616 interface IERC721Receiver {
617     /**
618      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
619      * by `operator` from `from`, this function is called.
620      *
621      * It must return its Solidity selector to confirm the token transfer.
622      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
623      *
624      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
625      */
626     function onERC721Received(
627         address operator,
628         address from,
629         uint256 tokenId,
630         bytes calldata data
631     ) external returns (bytes4);
632 }
633 
634 
635 /**
636  * @dev Required interface of an ERC721 compliant contract.
637  */
638 interface IERC721 is IERC165 {
639     /**
640      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
641      */
642     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
643 
644     /**
645      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
646      */
647     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
648 
649     /**
650      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
651      */
652     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
653 
654     /**
655      * @dev Returns the number of tokens in ``owner``'s account.
656      */
657     function balanceOf(address owner) external view returns (uint256 balance);
658 
659     /**
660      * @dev Returns the owner of the `tokenId` token.
661      *
662      * Requirements:
663      *
664      * - `tokenId` must exist.
665      */
666     function ownerOf(uint256 tokenId) external view returns (address owner);
667 
668     /**
669      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
670      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
671      *
672      * Requirements:
673      *
674      * - `from` cannot be the zero address.
675      * - `to` cannot be the zero address.
676      * - `tokenId` token must exist and be owned by `from`.
677      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
678      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
679      *
680      * Emits a {Transfer} event.
681      */
682     function safeTransferFrom(
683         address from,
684         address to,
685         uint256 tokenId
686     ) external;
687 
688     /**
689      * @dev Transfers `tokenId` token from `from` to `to`.
690      *
691      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
692      *
693      * Requirements:
694      *
695      * - `from` cannot be the zero address.
696      * - `to` cannot be the zero address.
697      * - `tokenId` token must be owned by `from`.
698      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
699      *
700      * Emits a {Transfer} event.
701      */
702     function transferFrom(
703         address from,
704         address to,
705         uint256 tokenId
706     ) external;
707 
708     /**
709      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
710      * The approval is cleared when the token is transferred.
711      *
712      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
713      *
714      * Requirements:
715      *
716      * - The caller must own the token or be an approved operator.
717      * - `tokenId` must exist.
718      *
719      * Emits an {Approval} event.
720      */
721     function approve(address to, uint256 tokenId) external;
722 
723     /**
724      * @dev Returns the account approved for `tokenId` token.
725      *
726      * Requirements:
727      *
728      * - `tokenId` must exist.
729      */
730     function getApproved(uint256 tokenId) external view returns (address operator);
731 
732     /**
733      * @dev Approve or remove `operator` as an operator for the caller.
734      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
735      *
736      * Requirements:
737      *
738      * - The `operator` cannot be the caller.
739      *
740      * Emits an {ApprovalForAll} event.
741      */
742     function setApprovalForAll(address operator, bool _approved) external;
743 
744     /**
745      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
746      *
747      * See {setApprovalForAll}
748      */
749     function isApprovedForAll(address owner, address operator) external view returns (bool);
750 
751     /**
752      * @dev Safely transfers `tokenId` token from `from` to `to`.
753      *
754      * Requirements:
755      *
756      * - `from` cannot be the zero address.
757      * - `to` cannot be the zero address.
758      * - `tokenId` token must exist and be owned by `from`.
759      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
760      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
761      *
762      * Emits a {Transfer} event.
763      */
764     function safeTransferFrom(
765         address from,
766         address to,
767         uint256 tokenId,
768         bytes calldata data
769     ) external;
770 }
771 
772 
773 /**
774  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
775  * @dev See https://eips.ethereum.org/EIPS/eip-721
776  */
777 interface IERC721Enumerable is IERC721 {
778     /**
779      * @dev Returns the total amount of tokens stored by the contract.
780      */
781     function totalSupply() external view returns (uint256);
782 
783     /**
784      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
785      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
786      */
787     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
788 
789     /**
790      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
791      * Use along with {totalSupply} to enumerate all tokens.
792      */
793     function tokenByIndex(uint256 index) external view returns (uint256);
794 }
795 
796 
797 /**
798  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
799  * @dev See https://eips.ethereum.org/EIPS/eip-721
800  */
801 interface IERC721Metadata is IERC721 {
802     /**
803      * @dev Returns the token collection name.
804      */
805     function name() external view returns (string memory);
806 
807     /**
808      * @dev Returns the token collection symbol.
809      */
810     function symbol() external view returns (string memory);
811 
812     /**
813      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
814      */
815     function tokenURI(uint256 tokenId) external view returns (string memory);
816 }
817 
818 
819 /**
820  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
821  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
822  *
823  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
824  *
825  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
826  *
827  * Does not support burning tokens to address(0).
828  */
829 contract ERC721A is
830   Context,
831   ERC165,
832   IERC721,
833   IERC721Metadata,
834   IERC721Enumerable
835 {
836   using Address for address;
837   using Strings for uint256;
838 
839   struct TokenOwnership {
840     address addr;
841     uint64 startTimestamp;
842   }
843 
844   struct AddressData {
845     uint128 balance;
846     uint128 numberMinted;
847   }
848 
849   uint256 private currentIndex = 0;
850 
851   uint256 internal immutable collectionSize;
852   uint256 internal immutable maxBatchSize;
853 
854   // Token name
855   string private _name;
856 
857   // Token symbol
858   string private _symbol;
859 
860   // Mapping from token ID to ownership details
861   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
862   mapping(uint256 => TokenOwnership) private _ownerships;
863 
864   // Mapping owner address to address data
865   mapping(address => AddressData) private _addressData;
866 
867   // Mapping from token ID to approved address
868   mapping(uint256 => address) private _tokenApprovals;
869 
870   // Mapping from owner to operator approvals
871   mapping(address => mapping(address => bool)) private _operatorApprovals;
872 
873   /**
874    * @dev
875    * `maxBatchSize` refers to how much a minter can mint at a time.
876    * `collectionSize_` refers to how many tokens are in the collection.
877    */
878   constructor(
879     string memory name_,
880     string memory symbol_,
881     uint256 maxBatchSize_,
882     uint256 collectionSize_
883   ) {
884     require(
885       collectionSize_ > 0,
886       "ERC721A: collection must have a nonzero supply"
887     );
888     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
889     _name = name_;
890     _symbol = symbol_;
891     maxBatchSize = maxBatchSize_;
892     collectionSize = collectionSize_;
893   }
894 
895   /**
896    * @dev See {IERC721Enumerable-totalSupply}.
897    */
898   function totalSupply() public view override returns (uint256) {
899     return currentIndex;
900   }
901 
902   /**
903    * @dev See {IERC721Enumerable-tokenByIndex}.
904    */
905   function tokenByIndex(uint256 index) public view override returns (uint256) {
906     require(index < totalSupply(), "ERC721A: global index out of bounds");
907     return index;
908   }
909 
910   /**
911    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
912    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
913    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
914    */
915   function tokenOfOwnerByIndex(address owner, uint256 index)
916     public
917     view
918     override
919     returns (uint256)
920   {
921     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
922     uint256 numMintedSoFar = totalSupply();
923     uint256 tokenIdsIdx = 0;
924     address currOwnershipAddr = address(0);
925     for (uint256 i = 0; i < numMintedSoFar; i++) {
926       TokenOwnership memory ownership = _ownerships[i];
927       if (ownership.addr != address(0)) {
928         currOwnershipAddr = ownership.addr;
929       }
930       if (currOwnershipAddr == owner) {
931         if (tokenIdsIdx == index) {
932           return i;
933         }
934         tokenIdsIdx++;
935       }
936     }
937     revert("ERC721A: unable to get token of owner by index");
938   }
939 
940   /**
941    * @dev See {IERC165-supportsInterface}.
942    */
943   function supportsInterface(bytes4 interfaceId)
944     public
945     view
946     virtual
947     override(ERC165, IERC165)
948     returns (bool)
949   {
950     return
951       interfaceId == type(IERC721).interfaceId ||
952       interfaceId == type(IERC721Metadata).interfaceId ||
953       interfaceId == type(IERC721Enumerable).interfaceId ||
954       super.supportsInterface(interfaceId);
955   }
956 
957   /**
958    * @dev See {IERC721-balanceOf}.
959    */
960   function balanceOf(address owner) public view override returns (uint256) {
961     require(owner != address(0), "ERC721A: balance query for the zero address");
962     return uint256(_addressData[owner].balance);
963   }
964 
965   function _numberMinted(address owner) internal view returns (uint256) {
966     require(
967       owner != address(0),
968       "ERC721A: number minted query for the zero address"
969     );
970     return uint256(_addressData[owner].numberMinted);
971   }
972 
973   function ownershipOf(uint256 tokenId)
974     internal
975     view
976     returns (TokenOwnership memory)
977   {
978     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
979 
980     uint256 lowestTokenToCheck;
981     if (tokenId >= maxBatchSize) {
982       lowestTokenToCheck = tokenId - maxBatchSize + 1;
983     }
984 
985     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
986       TokenOwnership memory ownership = _ownerships[curr];
987       if (ownership.addr != address(0)) {
988         return ownership;
989       }
990     }
991 
992     revert("ERC721A: unable to determine the owner of token");
993   }
994 
995   /**
996    * @dev See {IERC721-ownerOf}.
997    */
998   function ownerOf(uint256 tokenId) public view override returns (address) {
999     return ownershipOf(tokenId).addr;
1000   }
1001 
1002   /**
1003    * @dev See {IERC721Metadata-name}.
1004    */
1005   function name() public view virtual override returns (string memory) {
1006     return _name;
1007   }
1008 
1009   /**
1010    * @dev See {IERC721Metadata-symbol}.
1011    */
1012   function symbol() public view virtual override returns (string memory) {
1013     return _symbol;
1014   }
1015 
1016   /**
1017    * @dev See {IERC721Metadata-tokenURI}.
1018    */
1019   function tokenURI(uint256 tokenId)
1020     public
1021     view
1022     virtual
1023     override
1024     returns (string memory)
1025   {
1026     require(
1027       _exists(tokenId),
1028       "ERC721Metadata: URI query for nonexistent token"
1029     );
1030 
1031     string memory baseURI = _baseURI();
1032     return
1033       bytes(baseURI).length > 0
1034         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1035         : "";
1036   }
1037 
1038   /**
1039    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1040    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1041    * by default, can be overriden in child contracts.
1042    */
1043   function _baseURI() internal view virtual returns (string memory) {
1044     return "";
1045   }
1046 
1047   /**
1048    * @dev See {IERC721-approve}.
1049    */
1050   function approve(address to, uint256 tokenId) public virtual override {
1051     address owner = ERC721A.ownerOf(tokenId);
1052     require(to != owner, "ERC721A: approval to current owner");
1053 
1054     require(
1055       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1056       "ERC721A: approve caller is not owner nor approved for all"
1057     );
1058 
1059     _approve(to, tokenId, owner);
1060   }
1061 
1062   /**
1063    * @dev See {IERC721-getApproved}.
1064    */
1065   function getApproved(uint256 tokenId) public view override returns (address) {
1066     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1067 
1068     return _tokenApprovals[tokenId];
1069   }
1070 
1071   /**
1072    * @dev See {IERC721-setApprovalForAll}.
1073    */
1074   function setApprovalForAll(address operator, bool approved) public virtual override {
1075     require(operator != _msgSender(), "ERC721A: approve to caller");
1076 
1077     _operatorApprovals[_msgSender()][operator] = approved;
1078     emit ApprovalForAll(_msgSender(), operator, approved);
1079   }
1080 
1081   /**
1082    * @dev See {IERC721-isApprovedForAll}.
1083    */
1084   function isApprovedForAll(address owner, address operator)
1085     public
1086     view
1087     virtual
1088     override
1089     returns (bool)
1090   {
1091     return _operatorApprovals[owner][operator];
1092   }
1093 
1094   /**
1095    * @dev See {IERC721-transferFrom}.
1096    */
1097   function transferFrom(
1098     address from,
1099     address to,
1100     uint256 tokenId
1101   ) public virtual override {
1102     _transfer(from, to, tokenId);
1103   }
1104 
1105   /**
1106    * @dev See {IERC721-safeTransferFrom}.
1107    */
1108   function safeTransferFrom(
1109     address from,
1110     address to,
1111     uint256 tokenId
1112   ) public virtual override {
1113     safeTransferFrom(from, to, tokenId, "");
1114   }
1115 
1116   /**
1117    * @dev See {IERC721-safeTransferFrom}.
1118    */
1119   function safeTransferFrom(
1120     address from,
1121     address to,
1122     uint256 tokenId,
1123     bytes memory _data
1124   ) public virtual override {
1125     _transfer(from, to, tokenId);
1126     require(
1127       _checkOnERC721Received(from, to, tokenId, _data),
1128       "ERC721A: transfer to non ERC721Receiver implementer"
1129     );
1130   }
1131 
1132   /**
1133    * @dev Returns whether `tokenId` exists.
1134    *
1135    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1136    *
1137    * Tokens start existing when they are minted (`_mint`),
1138    */
1139   function _exists(uint256 tokenId) internal view returns (bool) {
1140     return tokenId < currentIndex;
1141   }
1142 
1143   function _safeMint(address to, uint256 quantity) internal {
1144     _safeMint(to, quantity, "");
1145   }
1146 
1147   /**
1148    * @dev Mints `quantity` tokens and transfers them to `to`.
1149    *
1150    * Requirements:
1151    *
1152    * - there must be `quantity` tokens remaining unminted in the total collection.
1153    * - `to` cannot be the zero address.
1154    * - `quantity` cannot be larger than the max batch size.
1155    *
1156    * Emits a {Transfer} event.
1157    */
1158   function _safeMint(
1159     address to,
1160     uint256 quantity,
1161     bytes memory _data
1162   ) internal {
1163     uint256 startTokenId = currentIndex;
1164     require(to != address(0), "ERC721A: mint to the zero address");
1165     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1166     require(!_exists(startTokenId), "ERC721A: token already minted");
1167     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1168 
1169     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1170 
1171     AddressData memory addressData = _addressData[to];
1172     _addressData[to] = AddressData(
1173       addressData.balance + uint128(quantity),
1174       addressData.numberMinted + uint128(quantity)
1175     );
1176     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1177 
1178     uint256 updatedIndex = startTokenId;
1179 
1180     for (uint256 i = 0; i < quantity; i++) {
1181       emit Transfer(address(0), to, updatedIndex);
1182       require(
1183         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1184         "ERC721A: transfer to non ERC721Receiver implementer"
1185       );
1186       updatedIndex++;
1187     }
1188 
1189     currentIndex = updatedIndex;
1190     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1191   }
1192 
1193   /**
1194    * @dev Transfers `tokenId` from `from` to `to`. 
1195    *
1196    * Requirements:
1197    *
1198    * - `to` cannot be the zero address.
1199    * - `tokenId` token must be owned by `from`.
1200    *
1201    * Emits a {Transfer} event.
1202    */
1203   function _transfer(
1204     address from,
1205     address to,
1206     uint256 tokenId
1207   ) private {
1208     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1209 
1210     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1211       getApproved(tokenId) == _msgSender() ||
1212       isApprovedForAll(prevOwnership.addr, _msgSender()));
1213 
1214     require(
1215       isApprovedOrOwner,
1216       "ERC721A: transfer caller is not owner nor approved"
1217     );
1218 
1219     require(
1220       prevOwnership.addr == from,
1221       "ERC721A: transfer from incorrect owner"
1222     );
1223     require(to != address(0), "ERC721A: transfer to the zero address");
1224 
1225     _beforeTokenTransfers(from, to, tokenId, 1);
1226 
1227     // Clear approvals from the previous owner
1228     _approve(address(0), tokenId, prevOwnership.addr);
1229 
1230     _addressData[from].balance -= 1;
1231     _addressData[to].balance += 1;
1232     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1233 
1234     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1235     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1236     uint256 nextTokenId = tokenId + 1;
1237     if (_ownerships[nextTokenId].addr == address(0)) {
1238       if (_exists(nextTokenId)) {
1239         _ownerships[nextTokenId] = TokenOwnership(
1240           prevOwnership.addr,
1241           prevOwnership.startTimestamp
1242         );
1243       }
1244     }
1245 
1246     emit Transfer(from, to, tokenId);
1247     _afterTokenTransfers(from, to, tokenId, 1);
1248   }
1249 
1250   /**
1251    * @dev Approve `to` to operate on `tokenId`
1252    *
1253    * Emits a {Approval} event.
1254    */
1255   function _approve(
1256     address to,
1257     uint256 tokenId,
1258     address owner
1259   ) private {
1260     _tokenApprovals[tokenId] = to;
1261     emit Approval(owner, to, tokenId);
1262   }
1263 
1264   uint256 public nextOwnerToExplicitlySet = 0;
1265 
1266   /**
1267    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1268    */
1269   function _setOwnersExplicit(uint256 quantity) internal {
1270     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1271     require(quantity > 0, "quantity must be nonzero");
1272     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1273     if (endIndex > collectionSize - 1) {
1274       endIndex = collectionSize - 1;
1275     }
1276     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1277     require(_exists(endIndex), "not enough minted yet for this cleanup");
1278     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1279       if (_ownerships[i].addr == address(0)) {
1280         TokenOwnership memory ownership = ownershipOf(i);
1281         _ownerships[i] = TokenOwnership(
1282           ownership.addr,
1283           ownership.startTimestamp
1284         );
1285       }
1286     }
1287     nextOwnerToExplicitlySet = endIndex + 1;
1288   }
1289 
1290   /**
1291    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1292    * The call is not executed if the target address is not a contract.
1293    *
1294    * @param from address representing the previous owner of the given token ID
1295    * @param to target address that will receive the tokens
1296    * @param tokenId uint256 ID of the token to be transferred
1297    * @param _data bytes optional data to send along with the call
1298    * @return bool whether the call correctly returned the expected magic value
1299    */
1300   function _checkOnERC721Received(
1301     address from,
1302     address to,
1303     uint256 tokenId,
1304     bytes memory _data
1305   ) private returns (bool) {
1306     if (to.isContract()) {
1307       try
1308         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1309       returns (bytes4 retval) {
1310         return retval == IERC721Receiver(to).onERC721Received.selector;
1311       } catch (bytes memory reason) {
1312         if (reason.length == 0) {
1313           revert("ERC721A: transfer to non ERC721Receiver implementer");
1314         } else {
1315           assembly {
1316             revert(add(32, reason), mload(reason))
1317           }
1318         }
1319       }
1320     } else {
1321       return true;
1322     }
1323   }
1324 
1325   /**
1326    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1327    *
1328    * startTokenId - the first token id to be transferred
1329    * quantity - the amount to be transferred
1330    *
1331    * Calling conditions:
1332    *
1333    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1334    * transferred to `to`.
1335    * - When `from` is zero, `tokenId` will be minted for `to`.
1336    */
1337   function _beforeTokenTransfers(
1338     address from,
1339     address to,
1340     uint256 startTokenId,
1341     uint256 quantity
1342   ) internal virtual {}
1343 
1344   /**
1345    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1346    * minting.
1347    *
1348    * startTokenId - the first token id to be transferred
1349    * quantity - the amount to be transferred
1350    *
1351    * Calling conditions:
1352    *
1353    * - when `from` and `to` are both non-zero.
1354    * - `from` and `to` are never both zero.
1355    */
1356   function _afterTokenTransfers(
1357     address from,
1358     address to,
1359     uint256 startTokenId,
1360     uint256 quantity
1361   ) internal virtual {}
1362 }
1363 
1364 interface IOperatorFilterRegistry {
1365     /**
1366      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
1367      *         true if supplied registrant address is not registered.
1368      */
1369     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1370 
1371     /**
1372      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
1373      */
1374     function register(address registrant) external;
1375 
1376     /**
1377      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
1378      */
1379     function registerAndSubscribe(address registrant, address subscription) external;
1380 
1381     /**
1382      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
1383      *         address without subscribing.
1384      */
1385     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1386 
1387     /**
1388      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
1389      *         Note that this does not remove any filtered addresses or codeHashes.
1390      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
1391      */
1392     function unregister(address addr) external;
1393 
1394     /**
1395      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
1396      */
1397     function updateOperator(address registrant, address operator, bool filtered) external;
1398 
1399     /**
1400      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
1401      */
1402     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1403 
1404     /**
1405      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
1406      */
1407     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1408 
1409     /**
1410      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
1411      */
1412     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1413 
1414     /**
1415      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
1416      *         subscription if present.
1417      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
1418      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
1419      *         used.
1420      */
1421     function subscribe(address registrant, address registrantToSubscribe) external;
1422 
1423     /**
1424      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
1425      */
1426     function unsubscribe(address registrant, bool copyExistingEntries) external;
1427 
1428     /**
1429      * @notice Get the subscription address of a given registrant, if any.
1430      */
1431     function subscriptionOf(address addr) external returns (address registrant);
1432 
1433     /**
1434      * @notice Get the set of addresses subscribed to a given registrant.
1435      *         Note that order is not guaranteed as updates are made.
1436      */
1437     function subscribers(address registrant) external returns (address[] memory);
1438 
1439     /**
1440      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
1441      *         Note that order is not guaranteed as updates are made.
1442      */
1443     function subscriberAt(address registrant, uint256 index) external returns (address);
1444 
1445     /**
1446      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
1447      */
1448     function copyEntriesOf(address registrant, address registrantToCopy) external;
1449 
1450     /**
1451      * @notice Returns true if operator is filtered by a given address or its subscription.
1452      */
1453     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1454 
1455     /**
1456      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
1457      */
1458     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1459 
1460     /**
1461      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
1462      */
1463     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1464 
1465     /**
1466      * @notice Returns a list of filtered operators for a given address or its subscription.
1467      */
1468     function filteredOperators(address addr) external returns (address[] memory);
1469 
1470     /**
1471      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
1472      *         Note that order is not guaranteed as updates are made.
1473      */
1474     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1475 
1476     /**
1477      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
1478      *         its subscription.
1479      *         Note that order is not guaranteed as updates are made.
1480      */
1481     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1482 
1483     /**
1484      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
1485      *         its subscription.
1486      *         Note that order is not guaranteed as updates are made.
1487      */
1488     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1489 
1490     /**
1491      * @notice Returns true if an address has registered
1492      */
1493     function isRegistered(address addr) external returns (bool);
1494 
1495     /**
1496      * @dev Convenience method to compute the code hash of an arbitrary contract
1497      */
1498     function codeHashOf(address addr) external returns (bytes32);
1499 }
1500 
1501 /**
1502  * @title  OperatorFilterer
1503  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1504  *         registrant's entries in the OperatorFilterRegistry.
1505  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1506  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1507  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1508  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
1509  *         administration methods on the contract itself to interact with the registry otherwise the subscription
1510  *         will be locked to the options set during construction.
1511  */
1512 
1513 abstract contract OperatorFilterer {
1514     /// @dev Emitted when an operator is not allowed.
1515     error OperatorNotAllowed(address operator);
1516 
1517     IOperatorFilterRegistry public iOperatorFilterRegistry;
1518 
1519     /// @dev The constructor that is called when the contract is being deployed.
1520     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1521         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1522         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1523         // order for the modifier to filter addresses.
1524         if (address(iOperatorFilterRegistry).code.length > 0) {
1525             if (subscribe) {
1526                 iOperatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1527             } else {
1528                 if (subscriptionOrRegistrantToCopy != address(0)) {
1529                     iOperatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1530                 } else {
1531                     iOperatorFilterRegistry.register(address(this));
1532                 }
1533             }
1534         }
1535     }
1536 
1537     /**
1538      * @dev A helper function to check if an operator is allowed.
1539      */
1540     modifier onlyAllowedOperator(address from) virtual {
1541         // Allow spending tokens from addresses with balance
1542         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1543         // from an EOA.
1544         if (from != msg.sender) {
1545             _checkFilterOperator(msg.sender);
1546         }
1547         _;
1548     }
1549 
1550     /**
1551      * @dev A helper function to check if an operator approval is allowed.
1552      */
1553     modifier onlyAllowedOperatorApproval(address operator) virtual {
1554         _checkFilterOperator(operator);
1555         _;
1556     }
1557 
1558     /**
1559      * @dev A helper function to check if an operator is allowed.
1560      */
1561     function _checkFilterOperator(address operator) internal view virtual {
1562         // Check registry code length to facilitate testing in environments without a deployed registry.
1563         if (address(iOperatorFilterRegistry).code.length > 0) {
1564             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
1565             // may specify their own OperatorFilterRegistry implementations, which may behave differently
1566             if (!iOperatorFilterRegistry.isOperatorAllowed(address(this), operator)) {
1567                 revert OperatorNotAllowed(operator);
1568             }
1569         }
1570     }
1571 }
1572 
1573 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
1574 /**
1575  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1576  *
1577  * These functions can be used to verify that a message was signed by the holder
1578  * of the private keys of a given address.
1579  */
1580 library ECDSA {
1581   using Strings for uint256;
1582     enum RecoverError {
1583         NoError,
1584         InvalidSignature,
1585         InvalidSignatureLength,
1586         InvalidSignatureS,
1587         InvalidSignatureV // Deprecated in v4.8
1588     }
1589 
1590     function _throwError(RecoverError error) private pure {
1591         if (error == RecoverError.NoError) {
1592             return; // no error: do nothing
1593         } else if (error == RecoverError.InvalidSignature) {
1594             revert("ECDSA: invalid signature");
1595         } else if (error == RecoverError.InvalidSignatureLength) {
1596             revert("ECDSA: invalid signature length");
1597         } else if (error == RecoverError.InvalidSignatureS) {
1598             revert("ECDSA: invalid signature 's' value");
1599         }
1600     }
1601 
1602     /**
1603      * @dev Returns the address that signed a hashed message (`hash`) with
1604      * `signature` or error string. This address can then be used for verification purposes.
1605      *
1606      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1607      * this function rejects them by requiring the `s` value to be in the lower
1608      * half order, and the `v` value to be either 27 or 28.
1609      *
1610      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1611      * verification to be secure: it is possible to craft signatures that
1612      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1613      * this is by receiving a hash of the original message (which may otherwise
1614      * be too long), and then calling {toEthSignedMessageHash} on it.
1615      *
1616      * Documentation for signature generation:
1617      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1618      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1619      *
1620      * _Available since v4.3._
1621      */
1622     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1623         if (signature.length == 65) {
1624             bytes32 r;
1625             bytes32 s;
1626             uint8 v;
1627             // ecrecover takes the signature parameters, and the only way to get them
1628             // currently is to use assembly.
1629             /// @solidity memory-safe-assembly
1630             assembly {
1631                 r := mload(add(signature, 0x20))
1632                 s := mload(add(signature, 0x40))
1633                 v := byte(0, mload(add(signature, 0x60)))
1634             }
1635             return tryRecover(hash, v, r, s);
1636         } else {
1637             return (address(0), RecoverError.InvalidSignatureLength);
1638         }
1639     }
1640 
1641     /**
1642      * @dev Returns the address that signed a hashed message (`hash`) with
1643      * `signature`. This address can then be used for verification purposes.
1644      *
1645      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1646      * this function rejects them by requiring the `s` value to be in the lower
1647      * half order, and the `v` value to be either 27 or 28.
1648      *
1649      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1650      * verification to be secure: it is possible to craft signatures that
1651      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1652      * this is by receiving a hash of the original message (which may otherwise
1653      * be too long), and then calling {toEthSignedMessageHash} on it.
1654      */
1655     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1656         (address recovered, RecoverError error) = tryRecover(hash, signature);
1657         _throwError(error);
1658         return recovered;
1659     }
1660 
1661     /**
1662      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1663      *
1664      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1665      *
1666      * _Available since v4.3._
1667      */
1668     function tryRecover(bytes32 hash, bytes32 r, bytes32 vs) internal pure returns (address, RecoverError) {
1669         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1670         uint8 v = uint8((uint256(vs) >> 255) + 27);
1671         return tryRecover(hash, v, r, s);
1672     }
1673 
1674     /**
1675      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1676      *
1677      * _Available since v4.2._
1678      */
1679     function recover(bytes32 hash, bytes32 r, bytes32 vs) internal pure returns (address) {
1680         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1681         _throwError(error);
1682         return recovered;
1683     }
1684 
1685     /**
1686      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1687      * `r` and `s` signature fields separately.
1688      *
1689      * _Available since v4.3._
1690      */
1691     function tryRecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address, RecoverError) {
1692         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1693         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1694         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1695         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1696         //
1697         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1698         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1699         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1700         // these malleable signatures as well.
1701         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1702             return (address(0), RecoverError.InvalidSignatureS);
1703         }
1704 
1705         // If the signature is valid (and not malleable), return the signer address
1706         address signer = ecrecover(hash, v, r, s);
1707         if (signer == address(0)) {
1708             return (address(0), RecoverError.InvalidSignature);
1709         }
1710 
1711         return (signer, RecoverError.NoError);
1712     }
1713 
1714     /**
1715      * @dev Overload of {ECDSA-recover} that receives the `v`,
1716      * `r` and `s` signature fields separately.
1717      */
1718     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
1719         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1720         _throwError(error);
1721         return recovered;
1722     }
1723 
1724     /**
1725      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1726      * produces hash corresponding to the one signed with the
1727      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1728      * JSON-RPC method as part of EIP-191.
1729      *
1730      * See {recover}.
1731      */
1732     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32 message) {
1733         // 32 is the length in bytes of hash,
1734         // enforced by the type signature above
1735         /// @solidity memory-safe-assembly
1736         assembly {
1737             mstore(0x00, "\x19Ethereum Signed Message:\n32")
1738             mstore(0x1c, hash)
1739             message := keccak256(0x00, 0x3c)
1740         }
1741     }
1742 
1743     /**
1744      * @dev Returns an Ethereum Signed Message, created from `s`. This
1745      * produces hash corresponding to the one signed with the
1746      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1747      * JSON-RPC method as part of EIP-191.
1748      *
1749      * See {recover}.
1750      */
1751     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1752         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1753     }
1754 
1755     /**
1756      * @dev Returns an Ethereum Signed Typed Data, created from a
1757      * `domainSeparator` and a `structHash`. This produces hash corresponding
1758      * to the one signed with the
1759      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1760      * JSON-RPC method as part of EIP-712.
1761      *
1762      * See {recover}.
1763      */
1764     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32 data) {
1765         /// @solidity memory-safe-assembly
1766         assembly {
1767             let ptr := mload(0x40)
1768             mstore(ptr, "\x19\x01")
1769             mstore(add(ptr, 0x02), domainSeparator)
1770             mstore(add(ptr, 0x22), structHash)
1771             data := keccak256(ptr, 0x42)
1772         }
1773     }
1774 
1775     /**
1776      * @dev Returns an Ethereum Signed Data with intended validator, created from a
1777      * `validator` and `data` according to the version 0 of EIP-191.
1778      *
1779      * See {recover}.
1780      */
1781     function toDataWithIntendedValidatorHash(address validator, bytes memory data) internal pure returns (bytes32) {
1782         return keccak256(abi.encodePacked("\x19\x00", validator, data));
1783     }
1784 }
1785 
1786 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC1271.sol)
1787 
1788 /**
1789  * @dev Interface of the ERC1271 standard signature validation method for
1790  * contracts as defined in https://eips.ethereum.org/EIPS/eip-1271[ERC-1271].
1791  *
1792  * _Available since v4.1._
1793  */
1794 interface IERC1271 {
1795     /**
1796      * @dev Should return whether the signature provided is valid for the provided data
1797      * @param hash      Hash of the data to be signed
1798      * @param signature Signature byte array associated with _data
1799      */
1800     function isValidSignature(bytes32 hash, bytes memory signature) external view returns (bytes4 magicValue);
1801 }
1802 
1803 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/SignatureChecker.sol)
1804 /**
1805  * @dev Signature verification helper that can be used instead of `ECDSA.recover` to seamlessly support both ECDSA
1806  * signatures from externally owned accounts (EOAs) as well as ERC1271 signatures from smart contract wallets like
1807  * Argent and Gnosis Safe.
1808  *
1809  * _Available since v4.1._
1810  */
1811 library SignatureChecker {
1812     /**
1813      * @dev Checks if a signature is valid for a given signer and data hash. If the signer is a smart contract, the
1814      * signature is validated against that smart contract using ERC1271, otherwise it's validated using `ECDSA.recover`.
1815      *
1816      * NOTE: Unlike ECDSA signatures, contract signatures are revocable, and the outcome of this function can thus
1817      * change through time. It could return true at block N and false at block N+1 (or the opposite).
1818      */
1819     function isValidSignatureNow(address signer, bytes32 hash, bytes memory signature) internal view returns (bool) {
1820         (address recovered, ECDSA.RecoverError error) = ECDSA.tryRecover(hash, signature);
1821         return
1822             (error == ECDSA.RecoverError.NoError && recovered == signer) ||
1823             isValidERC1271SignatureNow(signer, hash, signature);
1824     }
1825 
1826     /**
1827      * @dev Checks if a signature is valid for a given signer and data hash. The signature is validated
1828      * against the signer smart contract using ERC1271.
1829      *
1830      * NOTE: Unlike ECDSA signatures, contract signatures are revocable, and the outcome of this function can thus
1831      * change through time. It could return true at block N and false at block N+1 (or the opposite).
1832      */
1833     function isValidERC1271SignatureNow(
1834         address signer,
1835         bytes32 hash,
1836         bytes memory signature
1837     ) internal view returns (bool) {
1838         (bool success, bytes memory result) = signer.staticcall(
1839             abi.encodeWithSelector(IERC1271.isValidSignature.selector, hash, signature)
1840         );
1841         return (success &&
1842             result.length >= 32 &&
1843             abi.decode(result, (bytes32)) == bytes32(IERC1271.isValidSignature.selector));
1844     }
1845 }
1846 
1847 contract SSLegends is Ownable, ERC721A, ReentrancyGuard, OperatorFilterer {
1848   using ECDSA for bytes32;
1849   using SafeMath for uint256;
1850 
1851   event OperatorFilterRegistryAddressUpdated(address newRegistry);
1852 
1853   address public signer;
1854 
1855   uint256 public immutable maxPerAddressDuringMint;
1856   uint256 public immutable amountForWhitelistAndPublic;
1857 
1858   uint256 public maxWhitelistMints;
1859   uint256 public maxPublicMintsPerTxn;
1860 
1861   address payoutWallet1;
1862   address payoutWallet2;
1863   address rerollPayoutWallet;
1864 
1865   uint256 secondaryPartyFee;
1866 
1867   uint256 public saleStartTime;
1868   uint256 public whitelistStartTime;
1869   uint256 public goldlistStartTime;
1870 
1871 
1872   uint256 public publicSaleCost;
1873   uint256 public whitelistSaleCost;
1874 
1875   bytes32[] _whitelistRootHash;
1876 
1877   //Using a mapping to track whitelist mints for wallets
1878   mapping(address => uint256) public whitelistMints;
1879   //Using a mapping to track goldlist mints for wallets
1880   mapping(address => uint256) public goldlistMints;
1881   //Using a mapping for nonces to validate signatures
1882   mapping(address => uint256) public addressNonce;
1883   //Mapping to tell if a token was whitelist minted
1884   mapping(uint256 => bool) public isTokenWhitelistMinted;
1885 
1886   event TokenReRoll(
1887     uint256 indexed allotmentId
1888   );
1889 
1890   event GoldlistMint(
1891     uint256[] allotmentIds,
1892     uint256[] tokenIds
1893   );
1894 
1895   event WhitelistMint(
1896     uint256 startingTokenId,
1897     uint256 quantity
1898   );
1899 
1900   constructor(
1901     uint256 maxBatchSize_,
1902     uint256 collectionSize_,
1903     uint256 amountForWhitelistAndPublic_,
1904     address ioperatorFilterRegistry_,
1905     address subscriptionOrRegistrantToCopy
1906   ) ERC721A("Steady Stack Legends", "SSL", maxBatchSize_, collectionSize_) OperatorFilterer(subscriptionOrRegistrantToCopy, true) {
1907     maxPerAddressDuringMint = maxBatchSize_;
1908     amountForWhitelistAndPublic = amountForWhitelistAndPublic_;
1909     require(
1910       amountForWhitelistAndPublic_ <= collectionSize_,
1911       "larger collection size needed"
1912     );
1913     publicSaleCost = 0.6 ether;
1914     whitelistSaleCost = 0.5 ether;
1915     maxWhitelistMints = 1;
1916     maxPublicMintsPerTxn = 1;
1917     secondaryPartyFee = 20;
1918     payoutWallet1 = address(0xA571c6075Ea2DF601909E914E36198528CE610E3);
1919     payoutWallet2 = address(0xaF62166f50b13Db316C6111Da92E4c694a75EBbd);
1920     rerollPayoutWallet = address(0x735553423d83572ccd809c587a72d147852DcEB3);
1921 
1922     iOperatorFilterRegistry = IOperatorFilterRegistry(ioperatorFilterRegistry_);
1923     if (subscriptionOrRegistrantToCopy != address(0)) {
1924       iOperatorFilterRegistry.registerAndCopyEntries(
1925         address(this),
1926         subscriptionOrRegistrantToCopy
1927       );
1928     } else {
1929       iOperatorFilterRegistry.register(address(this));
1930     }
1931   }
1932 
1933   function setIOperatorFilterRegistry(address _iOperatorFilterRegistry) external onlyOwner {
1934     iOperatorFilterRegistry = IOperatorFilterRegistry(_iOperatorFilterRegistry);
1935     emit OperatorFilterRegistryAddressUpdated(_iOperatorFilterRegistry);
1936   }
1937 
1938   function updatePayoutWallet(address _newPayoutWallet, bool firstWallet) external onlyOwner{
1939     if(firstWallet){
1940       payoutWallet1 = _newPayoutWallet;
1941     }
1942     else{
1943       payoutWallet2 = _newPayoutWallet;
1944     }
1945   }
1946 
1947   function updateRerollPayoutWallet(address _newRerollPayoutWallet) external onlyOwner{
1948       rerollPayoutWallet = _newRerollPayoutWallet;
1949   }
1950 
1951   function addToWhitelistRootHash(bytes32 _hash) public onlyOwner{
1952         _whitelistRootHash.push(_hash);
1953   }
1954 
1955   function clearWhitelist() external onlyOwner{
1956     delete _whitelistRootHash;
1957   }
1958 
1959   function setWhitelistStartTime(uint256 _time) external onlyOwner {
1960     whitelistStartTime = _time;
1961     goldlistStartTime = _time;
1962   }
1963 
1964   function setGoldlistStartTimeExplicit(uint256 _time) external onlyOwner{
1965     goldlistStartTime = _time;
1966   }
1967 
1968   function setSaleStartTime(uint256 _time) external onlyOwner {
1969     saleStartTime = _time;
1970   }
1971 
1972   function setWhitelistSaleCost(uint256 _cost) public onlyOwner{
1973     whitelistSaleCost = _cost;
1974   }
1975 
1976   function setPublicSaleCost(uint256 _cost) external onlyOwner {
1977     publicSaleCost = _cost;
1978   }
1979 
1980   function getMintedTokenIds(uint256 startingIndex, uint256 quantity) internal pure returns (uint256[] memory) {
1981       // Create an array with the specified length
1982       uint256[] memory tokenIds = new uint256[](quantity);
1983 
1984       // Iterate through the loop to populate the array
1985       for (uint256 i = 0; i < quantity; i++) {
1986           tokenIds[i] = startingIndex + i;
1987       }
1988 
1989       return tokenIds;
1990   }
1991 
1992   function reRoll(uint256 allotmentId, uint256 reRollCost, uint256 nonce, bytes calldata signature) external payable {
1993     require(verifyRerollSignature(msg.sender, allotmentId, reRollCost, nonce, signature), "invalid re-roll data");
1994     require(addressNonce[msg.sender] == nonce, "incorrect nonce");
1995     refundIfOver(reRollCost);
1996     addressNonce[msg.sender] = addressNonce[msg.sender] + 1;
1997     payable(rerollPayoutWallet).transfer(reRollCost);
1998     emit TokenReRoll(allotmentId);
1999   }
2000 
2001   function publicMint(uint256 quantity) external payable {
2002     require(saleStartTime != 0 && block.timestamp >= saleStartTime, "sale has not started yet");
2003     require(totalSupply() + quantity <= amountForWhitelistAndPublic, "not enough remaining to support desired mint amount");
2004     require(quantity < maxPublicMintsPerTxn, "Can't mint that many in a single transaction");
2005 
2006     uint256 totalCost = publicSaleCost * quantity;
2007     _safeMint(_msgSender(), quantity);
2008     refundIfOver(totalCost);
2009   }
2010 
2011   function goldlistMint(uint256[] calldata allotmentIds, uint256 nonce, bytes calldata signature) external {
2012     uint256 quantity = allotmentIds.length;
2013 
2014     require(verifyMintSignature(msg.sender, allotmentIds, nonce, signature), "Invalid signature");
2015     require(addressNonce[msg.sender] == nonce, "incorrect nonce");
2016     require(goldlistStartTime != 0 && block.timestamp >= goldlistStartTime, "The sale has not started yet");
2017 
2018     uint256[] memory tokenIds = getMintedTokenIds(totalSupply(), quantity);
2019 
2020     _safeMint(_msgSender(), quantity);
2021 
2022     goldlistMints[_msgSender()] += quantity;
2023     addressNonce[msg.sender] = addressNonce[msg.sender] + 1;
2024     emit GoldlistMint(allotmentIds, tokenIds);
2025   }
2026 
2027   function whitelistMint(uint256 quantity, uint256 spotInWhitelist, uint256 maxMints, bytes32[] memory proof) external payable {
2028     require(whitelistValidated(_msgSender(), spotInWhitelist, maxMints, proof), "You're not on the whitelist");
2029     require(whitelistStartTime != 0 && block.timestamp >= whitelistStartTime, "The sale has not started yet");
2030     require(totalSupply() + quantity <= amountForWhitelistAndPublic, "not enough remaining reserved for whitelist to support desired mint amount");
2031     require(whitelistMints[_msgSender()] + quantity <= maxWhitelistMints, "This address already whitelist minted");
2032 
2033     uint256 premintIndex = totalSupply();
2034     isTokenWhitelistMinted[premintIndex] = true;
2035 
2036     whitelistMints[_msgSender()] += quantity;
2037 
2038     _safeMint(_msgSender(), quantity);
2039     refundIfOver(whitelistSaleCost * quantity);
2040     emit WhitelistMint(premintIndex, quantity);
2041   }
2042 
2043   function refundIfOver(uint256 price) private {
2044     require(msg.value >= price, "Need to send more ETH.");
2045     if (msg.value > price) {
2046       payable(_msgSender()).transfer(msg.value - price);
2047     }
2048   }
2049 
2050   function getCurrentCost() public view returns (uint256) {
2051     if(saleStartTime != 0 && block.timestamp >= saleStartTime) {
2052       return publicSaleCost;
2053     }
2054     else {
2055       return whitelistSaleCost;
2056     }
2057   }
2058 
2059   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2060       super.setApprovalForAll(operator, approved);
2061   }
2062 
2063   function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
2064       super.approve(operator, tokenId);
2065   }
2066 
2067   function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2068       super.transferFrom(from, to, tokenId);
2069   }
2070 
2071   function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2072       super.safeTransferFrom(from, to, tokenId);
2073   }
2074 
2075   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2076       public
2077       override
2078       onlyAllowedOperator(from)
2079   {
2080       super.safeTransferFrom(from, to, tokenId, data);
2081   }
2082 
2083   function emergencyMint(uint256 quantity, address _To) external onlyOwner {
2084     require(totalSupply() + quantity <= collectionSize, "too many already minted");
2085     _safeMint(_To, quantity);
2086   }
2087 
2088   function setSigner(address signer_) external onlyOwner {
2089       require(signer_ != address(0), "Signer cannot be the zero address");
2090       signer = signer_;
2091   }
2092 
2093   function verifyRerollSignature(address walletAddress, uint256 allotmentId, uint256 reRollCost, uint256 nonce, bytes calldata signature) internal view returns (bool) {
2094         require(signer != address(0), "Signer not set");
2095         bytes32 hash = keccak256(abi.encodePacked(walletAddress, allotmentId, reRollCost, nonce));
2096         bytes32 signedHash = hash.toEthSignedMessageHash();
2097 
2098         return SignatureChecker.isValidSignatureNow(signer, signedHash, signature);
2099   }
2100 
2101   function verifyMintSignature(address walletAddress, uint256[] calldata allotmentIds, uint256 nonce, bytes calldata signature) internal view returns (bool) {
2102         require(signer != address(0), "Signer not set");
2103         bytes32 hash = keccak256(abi.encodePacked(walletAddress, allotmentIds, nonce));
2104         bytes32 signedHash = hash.toEthSignedMessageHash();
2105 
2106         return SignatureChecker.isValidSignatureNow(signer, signedHash, signature);
2107   }
2108 
2109    // Merkle leaf validator function for storing whitelists off chain saving massive gas
2110   function whitelistValidated(address wallet, uint256 index, uint256 amount, bytes32[] memory proof) internal view returns (bool) {
2111 
2112         // Compute the merkle root
2113         bytes32 node = keccak256(abi.encodePacked(index, wallet, amount));
2114         uint256 path = index;
2115         for (uint16 i = 0; i < proof.length; i++) {
2116             if ((path & 0x01) == 1) {
2117                 node = keccak256(abi.encodePacked(proof[i], node));
2118             } else {
2119                 node = keccak256(abi.encodePacked(node, proof[i]));
2120             }
2121             path /= 2;
2122         }
2123 
2124         // Check the merkle proof against the root hash array
2125         for(uint i = 0; i < _whitelistRootHash.length; i++)
2126         {
2127             if (node == _whitelistRootHash[i])
2128             {
2129                 return true;
2130             }
2131         }
2132 
2133         return false;
2134     }
2135 
2136   // metadata URI
2137   string private _baseTokenURI;
2138 
2139   function _baseURI() internal view virtual override returns (string memory) {
2140     return _baseTokenURI;
2141   }
2142 
2143   function setBaseURI(string calldata baseURI) external onlyOwner {
2144     _baseTokenURI = baseURI;
2145   }
2146 
2147   /*
2148     * @dev Withdraw all ether from this contract and send to prespecified 
2149     * wallets (Callable by anyone)
2150   */
2151   function withdraw() external {
2152       uint256 balance = address(this).balance;
2153       uint256 walletBalance = balance.mul(secondaryPartyFee).div(100);
2154       payable(payoutWallet1).transfer(walletBalance);
2155       payable(payoutWallet2).transfer(balance.sub(walletBalance));
2156   }
2157 
2158   /**
2159     * @dev Withdraw all erc20 of the signature argument address from this contract and send to prespecified 
2160     * wallets (Callable by anyone)
2161   */
2162   function withdrawERC20(address _token) external {
2163       IERC20 targetToken = IERC20(_token);
2164       uint256 balance = targetToken.balanceOf(address(this));
2165       uint256 walletBalance = balance.mul(secondaryPartyFee).div(100);
2166       require(balance > 0, "Nothing to withdraw");
2167 
2168       targetToken.transferFrom(address(this), payoutWallet1, walletBalance);
2169       targetToken.transferFrom(address(this), payoutWallet2, balance.sub(walletBalance));
2170   }
2171 
2172   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
2173     _setOwnersExplicit(quantity);
2174   }
2175 
2176   function numberMinted(address owner) public view returns (uint256) {
2177     return _numberMinted(owner);
2178   }
2179 
2180   function getOwnershipData(uint256 tokenId)
2181     external
2182     view
2183     returns (TokenOwnership memory)
2184   {
2185     return ownershipOf(tokenId);
2186   }
2187 }