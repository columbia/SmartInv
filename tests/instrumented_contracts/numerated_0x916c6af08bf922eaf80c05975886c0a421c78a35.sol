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
559 /**
560  * @dev Interface of the ERC20 standard as defined in the EIP.
561  */
562 interface IERC20 {
563     /**
564      * @dev Returns the amount of tokens in existence.
565      */
566     function totalSupply() external view returns (uint256);
567 
568     /**
569      * @dev Returns the amount of tokens owned by `account`.
570      */
571     function balanceOf(address account) external view returns (uint256);
572 
573     /**
574      * @dev Moves `amount` tokens from the caller's account to `recipient`.
575      *
576      * Returns a boolean value indicating whether the operation succeeded.
577      *
578      * Emits a {Transfer} event.
579      */
580     function transfer(address recipient, uint256 amount) external returns (bool);
581 
582     /**
583      * @dev Returns the remaining number of tokens that `spender` will be
584      * allowed to spend on behalf of `owner` through {transferFrom}. This is
585      * zero by default.
586      *
587      * This value changes when {approve} or {transferFrom} are called.
588      */
589     function allowance(address owner, address spender) external view returns (uint256);
590 
591     /**
592      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
593      *
594      * Returns a boolean value indicating whether the operation succeeded.
595      *
596      * IMPORTANT: Beware that changing an allowance with this method brings the risk
597      * that someone may use both the old and the new allowance by unfortunate
598      * transaction ordering. One possible solution to mitigate this race
599      * condition is to first reduce the spender's allowance to 0 and set the
600      * desired value afterwards:
601      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
602      *
603      * Emits an {Approval} event.
604      */
605     function approve(address spender, uint256 amount) external returns (bool);
606 
607     /**
608      * @dev Moves `amount` tokens from `sender` to `recipient` using the
609      * allowance mechanism. `amount` is then deducted from the caller's
610      * allowance.
611      *
612      * Returns a boolean value indicating whether the operation succeeded.
613      *
614      * Emits a {Transfer} event.
615      */
616     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
617 
618     /**
619      * @dev Emitted when `value` tokens are moved from one account (`from`) to
620      * another (`to`).
621      *
622      * Note that `value` may be zero.
623      */
624     event Transfer(address indexed from, address indexed to, uint256 value);
625 
626     /**
627      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
628      * a call to {approve}. `value` is the new allowance.
629      */
630     event Approval(address indexed owner, address indexed spender, uint256 value);
631 }
632 
633 
634 /**
635  * @dev Required interface of an ERC721 compliant contract.
636  */
637 interface IERC721 is IERC165 {
638     /**
639      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
640      */
641     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
642 
643     /**
644      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
645      */
646     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
647 
648     /**
649      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
650      */
651     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
652 
653     /**
654      * @dev Returns the number of tokens in ``owner``'s account.
655      */
656     function balanceOf(address owner) external view returns (uint256 balance);
657 
658     /**
659      * @dev Returns the owner of the `tokenId` token.
660      *
661      * Requirements:
662      *
663      * - `tokenId` must exist.
664      */
665     function ownerOf(uint256 tokenId) external view returns (address owner);
666 
667     /**
668      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
669      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
670      *
671      * Requirements:
672      *
673      * - `from` cannot be the zero address.
674      * - `to` cannot be the zero address.
675      * - `tokenId` token must exist and be owned by `from`.
676      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
677      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
678      *
679      * Emits a {Transfer} event.
680      */
681     function safeTransferFrom(
682         address from,
683         address to,
684         uint256 tokenId
685     ) external;
686 
687     /**
688      * @dev Transfers `tokenId` token from `from` to `to`.
689      *
690      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
691      *
692      * Requirements:
693      *
694      * - `from` cannot be the zero address.
695      * - `to` cannot be the zero address.
696      * - `tokenId` token must be owned by `from`.
697      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
698      *
699      * Emits a {Transfer} event.
700      */
701     function transferFrom(
702         address from,
703         address to,
704         uint256 tokenId
705     ) external;
706 
707     /**
708      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
709      * The approval is cleared when the token is transferred.
710      *
711      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
712      *
713      * Requirements:
714      *
715      * - The caller must own the token or be an approved operator.
716      * - `tokenId` must exist.
717      *
718      * Emits an {Approval} event.
719      */
720     function approve(address to, uint256 tokenId) external;
721 
722     /**
723      * @dev Returns the account approved for `tokenId` token.
724      *
725      * Requirements:
726      *
727      * - `tokenId` must exist.
728      */
729     function getApproved(uint256 tokenId) external view returns (address operator);
730 
731     /**
732      * @dev Approve or remove `operator` as an operator for the caller.
733      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
734      *
735      * Requirements:
736      *
737      * - The `operator` cannot be the caller.
738      *
739      * Emits an {ApprovalForAll} event.
740      */
741     function setApprovalForAll(address operator, bool _approved) external;
742 
743     /**
744      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
745      *
746      * See {setApprovalForAll}
747      */
748     function isApprovedForAll(address owner, address operator) external view returns (bool);
749 
750     /**
751      * @dev Safely transfers `tokenId` token from `from` to `to`.
752      *
753      * Requirements:
754      *
755      * - `from` cannot be the zero address.
756      * - `to` cannot be the zero address.
757      * - `tokenId` token must exist and be owned by `from`.
758      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
759      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
760      *
761      * Emits a {Transfer} event.
762      */
763     function safeTransferFrom(
764         address from,
765         address to,
766         uint256 tokenId,
767         bytes calldata data
768     ) external;
769 }
770 
771 
772 /**
773  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
774  * @dev See https://eips.ethereum.org/EIPS/eip-721
775  */
776 interface IERC721Enumerable is IERC721 {
777     /**
778      * @dev Returns the total amount of tokens stored by the contract.
779      */
780     function totalSupply() external view returns (uint256);
781 
782     /**
783      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
784      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
785      */
786     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
787 
788     /**
789      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
790      * Use along with {totalSupply} to enumerate all tokens.
791      */
792     function tokenByIndex(uint256 index) external view returns (uint256);
793 }
794 
795 
796 /**
797  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
798  * @dev See https://eips.ethereum.org/EIPS/eip-721
799  */
800 interface IERC721Metadata is IERC721 {
801     /**
802      * @dev Returns the token collection name.
803      */
804     function name() external view returns (string memory);
805 
806     /**
807      * @dev Returns the token collection symbol.
808      */
809     function symbol() external view returns (string memory);
810 
811     /**
812      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
813      */
814     function tokenURI(uint256 tokenId) external view returns (string memory);
815 }
816 
817 
818 /**
819  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
820  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
821  *
822  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
823  *
824  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
825  *
826  * Does not support burning tokens to address(0).
827  */
828 contract ERC721A is
829   Context,
830   ERC165,
831   IERC721,
832   IERC721Metadata,
833   IERC721Enumerable
834 {
835   using Address for address;
836   using Strings for uint256;
837 
838   struct TokenOwnership {
839     address addr;
840     uint64 startTimestamp;
841   }
842 
843   struct AddressData {
844     uint128 balance;
845     uint128 numberMinted;
846   }
847 
848   uint256 private currentIndex = 0;
849 
850   uint256 internal immutable collectionSize;
851   uint256 internal immutable maxBatchSize;
852 
853   // Token name
854   string private _name;
855 
856   // Token symbol
857   string private _symbol;
858 
859   // Mapping from token ID to ownership details
860   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
861   mapping(uint256 => TokenOwnership) private _ownerships;
862 
863   // Mapping owner address to address data
864   mapping(address => AddressData) private _addressData;
865 
866   // Mapping from token ID to approved address
867   mapping(uint256 => address) private _tokenApprovals;
868 
869   // Mapping from owner to operator approvals
870   mapping(address => mapping(address => bool)) private _operatorApprovals;
871 
872   /**
873    * @dev
874    * `maxBatchSize` refers to how much a minter can mint at a time.
875    * `collectionSize_` refers to how many tokens are in the collection.
876    */
877   constructor(
878     string memory name_,
879     string memory symbol_,
880     uint256 maxBatchSize_,
881     uint256 collectionSize_
882   ) {
883     require(
884       collectionSize_ > 0,
885       "ERC721A: collection must have a nonzero supply"
886     );
887     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
888     _name = name_;
889     _symbol = symbol_;
890     maxBatchSize = maxBatchSize_;
891     collectionSize = collectionSize_;
892   }
893 
894   /**
895    * @dev See {IERC721Enumerable-totalSupply}.
896    */
897   function totalSupply() public view override returns (uint256) {
898     return currentIndex;
899   }
900 
901   /**
902    * @dev See {IERC721Enumerable-tokenByIndex}.
903    */
904   function tokenByIndex(uint256 index) public view override returns (uint256) {
905     require(index < totalSupply(), "ERC721A: global index out of bounds");
906     return index;
907   }
908 
909   /**
910    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
911    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
912    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
913    */
914   function tokenOfOwnerByIndex(address owner, uint256 index)
915     public
916     view
917     override
918     returns (uint256)
919   {
920     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
921     uint256 numMintedSoFar = totalSupply();
922     uint256 tokenIdsIdx = 0;
923     address currOwnershipAddr = address(0);
924     for (uint256 i = 0; i < numMintedSoFar; i++) {
925       TokenOwnership memory ownership = _ownerships[i];
926       if (ownership.addr != address(0)) {
927         currOwnershipAddr = ownership.addr;
928       }
929       if (currOwnershipAddr == owner) {
930         if (tokenIdsIdx == index) {
931           return i;
932         }
933         tokenIdsIdx++;
934       }
935     }
936     revert("ERC721A: unable to get token of owner by index");
937   }
938 
939   /**
940    * @dev See {IERC165-supportsInterface}.
941    */
942   function supportsInterface(bytes4 interfaceId)
943     public
944     view
945     virtual
946     override(ERC165, IERC165)
947     returns (bool)
948   {
949     return
950       interfaceId == type(IERC721).interfaceId ||
951       interfaceId == type(IERC721Metadata).interfaceId ||
952       interfaceId == type(IERC721Enumerable).interfaceId ||
953       super.supportsInterface(interfaceId);
954   }
955 
956   /**
957    * @dev See {IERC721-balanceOf}.
958    */
959   function balanceOf(address owner) public view override returns (uint256) {
960     require(owner != address(0), "ERC721A: balance query for the zero address");
961     return uint256(_addressData[owner].balance);
962   }
963 
964   function _numberMinted(address owner) internal view returns (uint256) {
965     require(
966       owner != address(0),
967       "ERC721A: number minted query for the zero address"
968     );
969     return uint256(_addressData[owner].numberMinted);
970   }
971 
972   function ownershipOf(uint256 tokenId)
973     internal
974     view
975     returns (TokenOwnership memory)
976   {
977     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
978 
979     uint256 lowestTokenToCheck;
980     if (tokenId >= maxBatchSize) {
981       lowestTokenToCheck = tokenId - maxBatchSize + 1;
982     }
983 
984     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
985       TokenOwnership memory ownership = _ownerships[curr];
986       if (ownership.addr != address(0)) {
987         return ownership;
988       }
989     }
990 
991     revert("ERC721A: unable to determine the owner of token");
992   }
993 
994   /**
995    * @dev See {IERC721-ownerOf}.
996    */
997   function ownerOf(uint256 tokenId) public view override returns (address) {
998     return ownershipOf(tokenId).addr;
999   }
1000 
1001   /**
1002    * @dev See {IERC721Metadata-name}.
1003    */
1004   function name() public view virtual override returns (string memory) {
1005     return _name;
1006   }
1007 
1008   /**
1009    * @dev See {IERC721Metadata-symbol}.
1010    */
1011   function symbol() public view virtual override returns (string memory) {
1012     return _symbol;
1013   }
1014 
1015   /**
1016    * @dev See {IERC721Metadata-tokenURI}.
1017    */
1018   function tokenURI(uint256 tokenId)
1019     public
1020     view
1021     virtual
1022     override
1023     returns (string memory)
1024   {
1025     require(
1026       _exists(tokenId),
1027       "ERC721Metadata: URI query for nonexistent token"
1028     );
1029 
1030     string memory baseURI = _baseURI();
1031     return
1032       bytes(baseURI).length > 0
1033         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1034         : "";
1035   }
1036 
1037   /**
1038    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1039    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1040    * by default, can be overriden in child contracts.
1041    */
1042   function _baseURI() internal view virtual returns (string memory) {
1043     return "";
1044   }
1045 
1046   /**
1047    * @dev See {IERC721-approve}.
1048    */
1049   function approve(address to, uint256 tokenId) public override {
1050     address owner = ERC721A.ownerOf(tokenId);
1051     require(to != owner, "ERC721A: approval to current owner");
1052 
1053     require(
1054       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1055       "ERC721A: approve caller is not owner nor approved for all"
1056     );
1057 
1058     _approve(to, tokenId, owner);
1059   }
1060 
1061   /**
1062    * @dev See {IERC721-getApproved}.
1063    */
1064   function getApproved(uint256 tokenId) public view override returns (address) {
1065     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1066 
1067     return _tokenApprovals[tokenId];
1068   }
1069 
1070   /**
1071    * @dev See {IERC721-setApprovalForAll}.
1072    */
1073   function setApprovalForAll(address operator, bool approved) public override {
1074     require(operator != _msgSender(), "ERC721A: approve to caller");
1075 
1076     _operatorApprovals[_msgSender()][operator] = approved;
1077     emit ApprovalForAll(_msgSender(), operator, approved);
1078   }
1079 
1080   /**
1081    * @dev See {IERC721-isApprovedForAll}.
1082    */
1083   function isApprovedForAll(address owner, address operator)
1084     public
1085     view
1086     virtual
1087     override
1088     returns (bool)
1089   {
1090     return _operatorApprovals[owner][operator];
1091   }
1092 
1093   /**
1094    * @dev See {IERC721-transferFrom}.
1095    */
1096   function transferFrom(
1097     address from,
1098     address to,
1099     uint256 tokenId
1100   ) public override {
1101     _transfer(from, to, tokenId);
1102   }
1103 
1104   /**
1105    * @dev See {IERC721-safeTransferFrom}.
1106    */
1107   function safeTransferFrom(
1108     address from,
1109     address to,
1110     uint256 tokenId
1111   ) public override {
1112     safeTransferFrom(from, to, tokenId, "");
1113   }
1114 
1115   /**
1116    * @dev See {IERC721-safeTransferFrom}.
1117    */
1118   function safeTransferFrom(
1119     address from,
1120     address to,
1121     uint256 tokenId,
1122     bytes memory _data
1123   ) public override {
1124     _transfer(from, to, tokenId);
1125     require(
1126       _checkOnERC721Received(from, to, tokenId, _data),
1127       "ERC721A: transfer to non ERC721Receiver implementer"
1128     );
1129   }
1130 
1131   /**
1132    * @dev Returns whether `tokenId` exists.
1133    *
1134    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1135    *
1136    * Tokens start existing when they are minted (`_mint`),
1137    */
1138   function _exists(uint256 tokenId) internal view returns (bool) {
1139     return tokenId < currentIndex;
1140   }
1141 
1142   function _safeMint(address to, uint256 quantity) internal {
1143     _safeMint(to, quantity, "");
1144   }
1145 
1146   /**
1147    * @dev Mints `quantity` tokens and transfers them to `to`.
1148    *
1149    * Requirements:
1150    *
1151    * - there must be `quantity` tokens remaining unminted in the total collection.
1152    * - `to` cannot be the zero address.
1153    * - `quantity` cannot be larger than the max batch size.
1154    *
1155    * Emits a {Transfer} event.
1156    */
1157   function _safeMint(
1158     address to,
1159     uint256 quantity,
1160     bytes memory _data
1161   ) internal {
1162     uint256 startTokenId = currentIndex;
1163     require(to != address(0), "ERC721A: mint to the zero address");
1164     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1165     require(!_exists(startTokenId), "ERC721A: token already minted");
1166     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1167 
1168     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1169 
1170     AddressData memory addressData = _addressData[to];
1171     _addressData[to] = AddressData(
1172       addressData.balance + uint128(quantity),
1173       addressData.numberMinted + uint128(quantity)
1174     );
1175     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1176 
1177     uint256 updatedIndex = startTokenId;
1178 
1179     for (uint256 i = 0; i < quantity; i++) {
1180       emit Transfer(address(0), to, updatedIndex);
1181       require(
1182         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1183         "ERC721A: transfer to non ERC721Receiver implementer"
1184       );
1185       updatedIndex++;
1186     }
1187 
1188     currentIndex = updatedIndex;
1189     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1190   }
1191 
1192   /**
1193    * @dev Transfers `tokenId` from `from` to `to`.
1194    *
1195    * Requirements:
1196    *
1197    * - `to` cannot be the zero address.
1198    * - `tokenId` token must be owned by `from`.
1199    *
1200    * Emits a {Transfer} event.
1201    */
1202   function _transfer(
1203     address from,
1204     address to,
1205     uint256 tokenId
1206   ) private {
1207     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1208 
1209     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1210       getApproved(tokenId) == _msgSender() ||
1211       isApprovedForAll(prevOwnership.addr, _msgSender()));
1212 
1213     require(
1214       isApprovedOrOwner,
1215       "ERC721A: transfer caller is not owner nor approved"
1216     );
1217 
1218     require(
1219       prevOwnership.addr == from,
1220       "ERC721A: transfer from incorrect owner"
1221     );
1222     require(to != address(0), "ERC721A: transfer to the zero address");
1223 
1224     _beforeTokenTransfers(from, to, tokenId, 1);
1225 
1226     // Clear approvals from the previous owner
1227     _approve(address(0), tokenId, prevOwnership.addr);
1228 
1229     _addressData[from].balance -= 1;
1230     _addressData[to].balance += 1;
1231     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1232 
1233     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1234     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1235     uint256 nextTokenId = tokenId + 1;
1236     if (_ownerships[nextTokenId].addr == address(0)) {
1237       if (_exists(nextTokenId)) {
1238         _ownerships[nextTokenId] = TokenOwnership(
1239           prevOwnership.addr,
1240           prevOwnership.startTimestamp
1241         );
1242       }
1243     }
1244 
1245     emit Transfer(from, to, tokenId);
1246     _afterTokenTransfers(from, to, tokenId, 1);
1247   }
1248 
1249   /**
1250    * @dev Approve `to` to operate on `tokenId`
1251    *
1252    * Emits a {Approval} event.
1253    */
1254   function _approve(
1255     address to,
1256     uint256 tokenId,
1257     address owner
1258   ) private {
1259     _tokenApprovals[tokenId] = to;
1260     emit Approval(owner, to, tokenId);
1261   }
1262 
1263   uint256 public nextOwnerToExplicitlySet = 0;
1264 
1265   /**
1266    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1267    */
1268   function _setOwnersExplicit(uint256 quantity) internal {
1269     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1270     require(quantity > 0, "quantity must be nonzero");
1271     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1272     if (endIndex > collectionSize - 1) {
1273       endIndex = collectionSize - 1;
1274     }
1275     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1276     require(_exists(endIndex), "not enough minted yet for this cleanup");
1277     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1278       if (_ownerships[i].addr == address(0)) {
1279         TokenOwnership memory ownership = ownershipOf(i);
1280         _ownerships[i] = TokenOwnership(
1281           ownership.addr,
1282           ownership.startTimestamp
1283         );
1284       }
1285     }
1286     nextOwnerToExplicitlySet = endIndex + 1;
1287   }
1288 
1289   /**
1290    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1291    * The call is not executed if the target address is not a contract.
1292    *
1293    * @param from address representing the previous owner of the given token ID
1294    * @param to target address that will receive the tokens
1295    * @param tokenId uint256 ID of the token to be transferred
1296    * @param _data bytes optional data to send along with the call
1297    * @return bool whether the call correctly returned the expected magic value
1298    */
1299   function _checkOnERC721Received(
1300     address from,
1301     address to,
1302     uint256 tokenId,
1303     bytes memory _data
1304   ) private returns (bool) {
1305     if (to.isContract()) {
1306       try
1307         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1308       returns (bytes4 retval) {
1309         return retval == IERC721Receiver(to).onERC721Received.selector;
1310       } catch (bytes memory reason) {
1311         if (reason.length == 0) {
1312           revert("ERC721A: transfer to non ERC721Receiver implementer");
1313         } else {
1314           assembly {
1315             revert(add(32, reason), mload(reason))
1316           }
1317         }
1318       }
1319     } else {
1320       return true;
1321     }
1322   }
1323 
1324   /**
1325    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1326    *
1327    * startTokenId - the first token id to be transferred
1328    * quantity - the amount to be transferred
1329    *
1330    * Calling conditions:
1331    *
1332    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1333    * transferred to `to`.
1334    * - When `from` is zero, `tokenId` will be minted for `to`.
1335    */
1336   function _beforeTokenTransfers(
1337     address from,
1338     address to,
1339     uint256 startTokenId,
1340     uint256 quantity
1341   ) internal virtual {}
1342 
1343   /**
1344    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1345    * minting.
1346    *
1347    * startTokenId - the first token id to be transferred
1348    * quantity - the amount to be transferred
1349    *
1350    * Calling conditions:
1351    *
1352    * - when `from` and `to` are both non-zero.
1353    * - `from` and `to` are never both zero.
1354    */
1355   function _afterTokenTransfers(
1356     address from,
1357     address to,
1358     uint256 startTokenId,
1359     uint256 quantity
1360   ) internal virtual {}
1361 }
1362 
1363 contract SteadyStackTitans is Ownable, ERC721A, ReentrancyGuard {
1364   using SafeMath for uint256;
1365   using Strings for uint256;
1366 
1367   uint256 public immutable maxPerAddressDuringMint;
1368   uint256 public immutable amountForDevs;
1369   uint256 public immutable amountForSaleAndDev;
1370 
1371   uint256 public maxWhitelistMints;
1372   uint256 public maxPublicMintsPerTxn;
1373 
1374   address payoutWallet1;
1375 
1376   uint256 public saleStartTime;
1377   uint256 public whitelistStartTime;
1378   uint256 public whitelistGroupWindow;
1379   uint256 public minimumWhitelistAllocation;
1380 
1381   uint256 public publicSaleCost;
1382   uint256 public whitelistSaleCost;
1383 
1384   SteadyStackTitans tokenURILogic;
1385   SteadyStackTitans upgradeLogic;
1386 
1387   //Using an array of mappings to track whitelist mints for wallets
1388   mapping(address => uint256) public whitelistMints;
1389 
1390   //Mapping to track NFTs that have gone through an upgrade
1391   mapping(uint256 => bool) public upgradedNFTs;
1392   
1393   bytes32[] _whitelistRootHash;
1394 
1395   constructor(
1396     uint256 maxBatchSize_,
1397     uint256 collectionSize_,
1398     uint256 amountForAuctionAndDev_,
1399     uint256 amountForDevs_
1400   ) ERC721A("Steady Stack Titans", "SSTITN", maxBatchSize_, collectionSize_) {
1401     maxPerAddressDuringMint = maxBatchSize_;
1402     amountForSaleAndDev = amountForAuctionAndDev_;
1403     amountForDevs = amountForDevs_;
1404     require(
1405       amountForAuctionAndDev_ <= collectionSize_,
1406       "larger collection size needed"
1407     );
1408     publicSaleCost = 0.1 ether;
1409     whitelistSaleCost = 0.08 ether;
1410     maxPublicMintsPerTxn = 4;
1411     whitelistGroupWindow = 3 hours;
1412   }
1413 
1414   function addToWhitelistRootHash(bytes32 _hash) public onlyOwner{
1415         _whitelistRootHash.push(_hash);
1416   }
1417 
1418   function clearWhitelist() external onlyOwner{
1419     delete _whitelistRootHash;
1420   }
1421 
1422   function updatePayoutWallet(address newPayoutWallet) external onlyOwner{
1423     payoutWallet1 = newPayoutWallet;
1424   }
1425 
1426   function setWhitelistStartTime(uint256 _time) external onlyOwner {
1427     whitelistStartTime = _time;
1428   }
1429 
1430   function setSaleStartTime(uint256 _time) external onlyOwner {
1431     saleStartTime = _time;
1432   }
1433 
1434   function setWhitelistSaleCost(uint256 _cost) public onlyOwner{
1435     whitelistSaleCost = _cost;
1436   }
1437 
1438   function setPublicSaleCost(uint256 _cost) external onlyOwner {
1439     publicSaleCost = _cost;
1440   }
1441 
1442    // Merkle leaf validator function for storing whitelists off chain saving massive gas
1443   function whitelistValidated(address wallet, uint256 index, uint256 amount, bytes32[] memory proof) internal view returns (bool) {
1444 
1445         // Compute the merkle root
1446         bytes32 node = keccak256(abi.encodePacked(index, wallet, amount));
1447         uint256 path = index;
1448         for (uint16 i = 0; i < proof.length; i++) {
1449             if ((path & 0x01) == 1) {
1450                 node = keccak256(abi.encodePacked(proof[i], node));
1451             } else {
1452                 node = keccak256(abi.encodePacked(node, proof[i]));
1453             }
1454             path /= 2;
1455         }
1456 
1457         // Check the merkle proof against the root hash array
1458         for(uint i = 0; i < _whitelistRootHash.length; i++)
1459         {
1460             if (node == _whitelistRootHash[i])
1461             {
1462                 return true;
1463             }
1464         }
1465 
1466         return false;
1467     }
1468 
1469   function publicMint(uint256 quantity) external payable {
1470     require(saleStartTime != 0 && block.timestamp >= saleStartTime, "sale has not started yet");
1471     require(totalSupply() + quantity <= amountForSaleAndDev, "not enough remaining reserved for auction to support desired mint amount");
1472     require(quantity <= maxPublicMintsPerTxn, "Can't mint that many in a single transaction");
1473 
1474     uint256 totalCost = publicSaleCost * quantity;
1475     _safeMint(_msgSender(), quantity);
1476     refundIfOver(totalCost);
1477   }
1478 
1479   function whitelistMint(uint256 quantity, uint256 spotInWhitelist, uint256 maxMints, bytes32[] memory proof) external payable {
1480     require(whitelistValidated(_msgSender(), spotInWhitelist, maxMints, proof), "You're not on the whitelist");
1481     require(whitelistStartTime != 0 && block.timestamp >= whitelistStartTime, "The sale has not started yet");
1482     require(totalSupply() + quantity <= amountForSaleAndDev, "not enough remaining reserved for auction to support desired mint amount");
1483     require(whitelistMints[_msgSender()] + quantity <= maxMints, "Not enough whitelist mints available");
1484 
1485     whitelistMints[_msgSender()] += quantity;
1486 
1487     _safeMint(_msgSender(), quantity);
1488     refundIfOver(whitelistSaleCost * quantity);
1489   }
1490 
1491   //Contract calls upgrade logic to setup an preconfiguration needed before setting the mapping to true
1492   function upgradeNFT(uint256 tokenId) public {
1493     require(upgradedNFTs[tokenId] == false, "Token already upgraded");
1494     upgradeLogic.upgradeNFT(tokenId);
1495   }
1496 
1497   function setMaxPublicMints(uint256 _max) onlyOwner external {
1498     maxPublicMintsPerTxn = _max;
1499   }
1500 
1501   //After the upgrade logic sets any necessary preconfiguration it sets the value to true for the input tokenId
1502   function setNFTUpgraded(uint256 tokenId) external {
1503     require(msg.sender == address(upgradeLogic), "Only the upgrade logic can set an upgrade");
1504     upgradedNFTs[tokenId] = true;
1505   }
1506 
1507   function setTokenURILogic(address newContract) onlyOwner external{
1508     tokenURILogic = SteadyStackTitans(newContract);
1509   }
1510 
1511   function setUpgradeLogic(address newContract) onlyOwner external{
1512     upgradeLogic = SteadyStackTitans(newContract);
1513   }
1514 
1515   function refundIfOver(uint256 price) private {
1516     require(msg.value >= price, "Need to send more ETH.");
1517     if (msg.value > price) {
1518       payable(_msgSender()).transfer(msg.value - price);
1519     }
1520   }
1521 
1522   function getCurrentCost() public view returns (uint256) {
1523     if(saleStartTime != 0 && block.timestamp >= saleStartTime) {
1524       return publicSaleCost;
1525     }
1526     else {
1527       return whitelistSaleCost;
1528     }
1529   }
1530 
1531   // For marketing etc.
1532   function devMint(uint256 quantity, address _To) external onlyOwner {
1533     require(totalSupply() + quantity <= amountForDevs, "too many already minted before dev mint");
1534     require(quantity % maxBatchSize == 0, "can only mint a multiple of the maxBatchSize");
1535     uint256 numChunks = quantity / maxBatchSize;
1536     for (uint256 i = 0; i < numChunks; i++) {
1537       _safeMint(_To, maxBatchSize);
1538     }
1539   }
1540 
1541   // metadata URI
1542   string private _baseTokenURI;
1543 
1544   function _baseURI() internal view virtual override returns (string memory) {
1545     return _baseTokenURI;
1546   }
1547 
1548   function setBaseURI(string calldata baseURI) external onlyOwner {
1549     _baseTokenURI = baseURI;
1550   }
1551 
1552   //New logic created for token upgrades. Until that point standard tokenURI logic works.
1553   function tokenURI(uint256 tokenId) override public view returns (string memory)
1554   {
1555     require(
1556       _exists(tokenId),
1557       "ERC721Metadata: URI query for nonexistent token"
1558     );
1559     if(tokenURILogic != SteadyStackTitans(address(0)))
1560     {
1561       return tokenURILogic.tokenURI(tokenId);
1562     }
1563     else
1564     {
1565       string memory baseURI = _baseURI();
1566       return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1567     }
1568   }
1569 
1570   // Standard withdraw function that only executes when both wallets are set
1571   function withdraw() external onlyOwner {
1572         require(payoutWallet1 != address(0), "wallet 1 not set");
1573         uint256 balance = address(this).balance;
1574         payable(payoutWallet1).transfer(balance);
1575   }
1576 
1577   function ERC20Withdraw(address tokenAddress) external onlyOwner {
1578         IERC20 targetToken = IERC20(tokenAddress);
1579         uint256 balance = targetToken.balanceOf(address(this));
1580         require(balance > 0, "Nothing to withdraw");
1581         require(payoutWallet1 != address(0), "Wallet not set");
1582 
1583         targetToken.transferFrom(address(this), payoutWallet1, balance);
1584   }
1585 
1586   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1587     _setOwnersExplicit(quantity);
1588   }
1589 
1590   function numberMinted(address owner) public view returns (uint256) {
1591     return _numberMinted(owner);
1592   }
1593 
1594   function getOwnershipData(uint256 tokenId)
1595     external
1596     view
1597     returns (TokenOwnership memory)
1598   {
1599     return ownershipOf(tokenId);
1600   }
1601 }