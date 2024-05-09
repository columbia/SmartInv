1 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
2 /////////////////  Contract created by the Byt Launchpad team  https://byt.io  ////////////////////////////////
3 /////////////////                                                              ////////////////////////////////
4 /////////////////   /$$$$$$$  /$$     /$$ /$$$$$$$$  /$$$$$$  /$$$$$$          ////////////////////////////////
5 /////////////////  | $$__  $$|  $$   /$$/|__  $$__/ |_  $$_/ /$$__  $$         ////////////////////////////////
6 /////////////////  | $$  \ $$ \  $$ /$$/    | $$      | $$  | $$  \ $$         ////////////////////////////////
7 /////////////////  | $$$$$$$   \  $$$$/     | $$      | $$  | $$  | $$         ////////////////////////////////
8 /////////////////  | $$__  $$   \  $$/      | $$      | $$  | $$  | $$         ////////////////////////////////
9 /////////////////  | $$  \ $$    | $$       | $$      | $$  | $$  | $$         ////////////////////////////////
10 /////////////////  | $$$$$$$/    | $$       | $$ /$$ /$$$$$$|  $$$$$$/         ////////////////////////////////
11 /////////////////  |_______/     |__/       |__/|__/|______/ \______/          ////////////////////////////////
12 /////////////////                                                              ////////////////////////////////
13 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                  
14 
15 pragma solidity ^0.8.0;
16 
17 /*
18  * @dev Provides information about the current execution context, including the
19  * sender of the transaction and its data. While these are generally available
20  * via msg.sender and msg.data, they should not be accessed in such a direct
21  * manner, since when dealing with meta-transactions the account sending and
22  * paying for execution may not be the actual sender (as far as an application
23  * is concerned).
24  *
25  * This contract is only required for intermediate, library-like contracts.
26  */
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address) {
29         return msg.sender;
30     }
31 
32     function _msgData() internal view virtual returns (bytes calldata) {
33         return msg.data;
34     }
35 }
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _setOwner(_msgSender());
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view virtual returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         _setOwner(address(0));
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         _setOwner(newOwner);
94     }
95 
96     function _setOwner(address newOwner) private {
97         address oldOwner = _owner;
98         _owner = newOwner;
99         emit OwnershipTransferred(oldOwner, newOwner);
100     }
101 }
102 
103 /**
104  * @dev Collection of functions related to the address type
105  */
106 library Address {
107     /**
108      * @dev Returns true if `account` is a contract.
109      *
110      * [IMPORTANT]
111      * ====
112      * It is unsafe to assume that an address for which this function returns
113      * false is an externally-owned account (EOA) and not a contract.
114      *
115      * Among others, `isContract` will return false for the following
116      * types of addresses:
117      *
118      *  - an externally-owned account
119      *  - a contract in construction
120      *  - an address where a contract will be created
121      *  - an address where a contract lived, but was destroyed
122      * ====
123      */
124     function isContract(address account) internal view returns (bool) {
125         // This method relies on extcodesize, which returns 0 for contracts in
126         // construction, since the code is only stored at the end of the
127         // constructor execution.
128 
129         uint256 size;
130         assembly {
131             size := extcodesize(account)
132         }
133         return size > 0;
134     }
135 
136     /**
137      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
138      * `recipient`, forwarding all available gas and reverting on errors.
139      *
140      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
141      * of certain opcodes, possibly making contracts go over the 2300 gas limit
142      * imposed by `transfer`, making them unable to receive funds via
143      * `transfer`. {sendValue} removes this limitation.
144      *
145      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
146      *
147      * IMPORTANT: because control is transferred to `recipient`, care must be
148      * taken to not create reentrancy vulnerabilities. Consider using
149      * {ReentrancyGuard} or the
150      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
151      */
152     function sendValue(address payable recipient, uint256 amount) internal {
153         require(address(this).balance >= amount, "Address: insufficient balance");
154 
155         (bool success, ) = recipient.call{value: amount}("");
156         require(success, "Address: unable to send value, recipient may have reverted");
157     }
158 
159     /**
160      * @dev Performs a Solidity function call using a low level `call`. A
161      * plain `call` is an unsafe replacement for a function call: use this
162      * function instead.
163      *
164      * If `target` reverts with a revert reason, it is bubbled up by this
165      * function (like regular Solidity function calls).
166      *
167      * Returns the raw returned data. To convert to the expected return value,
168      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
169      *
170      * Requirements:
171      *
172      * - `target` must be a contract.
173      * - calling `target` with `data` must not revert.
174      *
175      * _Available since v3.1._
176      */
177     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
178         return functionCall(target, data, "Address: low-level call failed");
179     }
180 
181     /**
182      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
183      * `errorMessage` as a fallback revert reason when `target` reverts.
184      *
185      * _Available since v3.1._
186      */
187     function functionCall(
188         address target,
189         bytes memory data,
190         string memory errorMessage
191     ) internal returns (bytes memory) {
192         return functionCallWithValue(target, data, 0, errorMessage);
193     }
194 
195     /**
196      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
197      * but also transferring `value` wei to `target`.
198      *
199      * Requirements:
200      *
201      * - the calling contract must have an ETH balance of at least `value`.
202      * - the called Solidity function must be `payable`.
203      *
204      * _Available since v3.1._
205      */
206     function functionCallWithValue(
207         address target,
208         bytes memory data,
209         uint256 value
210     ) internal returns (bytes memory) {
211         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
212     }
213 
214     /**
215      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
216      * with `errorMessage` as a fallback revert reason when `target` reverts.
217      *
218      * _Available since v3.1._
219      */
220     function functionCallWithValue(
221         address target,
222         bytes memory data,
223         uint256 value,
224         string memory errorMessage
225     ) internal returns (bytes memory) {
226         require(address(this).balance >= value, "Address: insufficient balance for call");
227         require(isContract(target), "Address: call to non-contract");
228 
229         (bool success, bytes memory returndata) = target.call{value: value}(data);
230         return _verifyCallResult(success, returndata, errorMessage);
231     }
232 
233     /**
234      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
235      * but performing a static call.
236      *
237      * _Available since v3.3._
238      */
239     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
240         return functionStaticCall(target, data, "Address: low-level static call failed");
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
245      * but performing a static call.
246      *
247      * _Available since v3.3._
248      */
249     function functionStaticCall(
250         address target,
251         bytes memory data,
252         string memory errorMessage
253     ) internal view returns (bytes memory) {
254         require(isContract(target), "Address: static call to non-contract");
255 
256         (bool success, bytes memory returndata) = target.staticcall(data);
257         return _verifyCallResult(success, returndata, errorMessage);
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
262      * but performing a delegate call.
263      *
264      * _Available since v3.4._
265      */
266     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
267         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
272      * but performing a delegate call.
273      *
274      * _Available since v3.4._
275      */
276     function functionDelegateCall(
277         address target,
278         bytes memory data,
279         string memory errorMessage
280     ) internal returns (bytes memory) {
281         require(isContract(target), "Address: delegate call to non-contract");
282 
283         (bool success, bytes memory returndata) = target.delegatecall(data);
284         return _verifyCallResult(success, returndata, errorMessage);
285     }
286 
287     function _verifyCallResult(
288         bool success,
289         bytes memory returndata,
290         string memory errorMessage
291     ) private pure returns (bytes memory) {
292         if (success) {
293             return returndata;
294         } else {
295             // Look for revert reason and bubble it up if present
296             if (returndata.length > 0) {
297                 // The easiest way to bubble the revert reason is using memory via assembly
298 
299                 assembly {
300                     let returndata_size := mload(returndata)
301                     revert(add(32, returndata), returndata_size)
302                 }
303             } else {
304                 revert(errorMessage);
305             }
306         }
307     }
308 }
309 
310 /**
311  * @dev String operations.
312  */
313 library Strings {
314     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
315 
316     /**
317      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
318      */
319     function toString(uint256 value) internal pure returns (string memory) {
320         // Inspired by OraclizeAPI's implementation - MIT licence
321         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
322 
323         if (value == 0) {
324             return "0";
325         }
326         uint256 temp = value;
327         uint256 digits;
328         while (temp != 0) {
329             digits++;
330             temp /= 10;
331         }
332         bytes memory buffer = new bytes(digits);
333         while (value != 0) {
334             digits -= 1;
335             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
336             value /= 10;
337         }
338         return string(buffer);
339     }
340 
341     /**
342      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
343      */
344     function toHexString(uint256 value) internal pure returns (string memory) {
345         if (value == 0) {
346             return "0x00";
347         }
348         uint256 temp = value;
349         uint256 length = 0;
350         while (temp != 0) {
351             length++;
352             temp >>= 8;
353         }
354         return toHexString(value, length);
355     }
356 
357     /**
358      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
359      */
360     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
361         bytes memory buffer = new bytes(2 * length + 2);
362         buffer[0] = "0";
363         buffer[1] = "x";
364         for (uint256 i = 2 * length + 1; i > 1; --i) {
365             buffer[i] = _HEX_SYMBOLS[value & 0xf];
366             value >>= 4;
367         }
368         require(value == 0, "Strings: hex length insufficient");
369         return string(buffer);
370     }
371 }
372 
373 /**
374  * @dev Wrappers over Solidity's arithmetic operations with added overflow
375  * checks.
376  *
377  * Arithmetic operations in Solidity wrap on overflow. This can easily result
378  * in bugs, because programmers usually assume that an overflow raises an
379  * error, which is the standard behavior in high level programming languages.
380  * `SafeMath` restores this intuition by reverting the transaction when an
381  * operation overflows.
382  *
383  * Using this library instead of the unchecked operations eliminates an entire
384  * class of bugs, so it's recommended to use it always.
385  *
386  *
387  * @dev original library functions truncated to only needed functions reducing
388  * deployed bytecode.
389  */
390 library SafeMath {
391 
392     /**
393      * @dev Returns the subtraction of two unsigned integers, reverting on
394      * overflow (when the result is negative).
395      *
396      * Counterpart to Solidity's `-` operator.
397      *
398      * Requirements:
399      *
400      * - Subtraction cannot overflow.
401      */
402     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
403         require(b <= a, "SafeMath: subtraction overflow");
404         return a - b;
405     }
406 
407     /**
408      * @dev Returns the multiplication of two unsigned integers, reverting on
409      * overflow.
410      *
411      * Counterpart to Solidity's `*` operator.
412      *
413      * Requirements:
414      *
415      * - Multiplication cannot overflow.
416      */
417     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
418         if (a == 0) return 0;
419         uint256 c = a * b;
420         require(c / a == b, "SafeMath: multiplication overflow");
421         return c;
422     }
423 
424     /**
425      * @dev Returns the integer division of two unsigned integers, reverting on
426      * division by zero. The result is rounded towards zero.
427      *
428      * Counterpart to Solidity's `/` operator. Note: this function uses a
429      * `revert` opcode (which leaves remaining gas untouched) while Solidity
430      * uses an invalid opcode to revert (consuming all remaining gas).
431      *
432      * Requirements:
433      *
434      * - The divisor cannot be zero.
435      */
436     function div(uint256 a, uint256 b) internal pure returns (uint256) {
437         require(b > 0, "SafeMath: division by zero");
438         return a / b;
439     }
440 }
441 
442 /**
443  * @dev Contract module that helps prevent reentrant calls to a function.
444  *
445  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
446  * available, which can be applied to functions to make sure there are no nested
447  * (reentrant) calls to them.
448  *
449  * Note that because there is a single `nonReentrant` guard, functions marked as
450  * `nonReentrant` may not call one another. This can be worked around by making
451  * those functions `private`, and then adding `external` `nonReentrant` entry
452  * points to them.
453  *
454  * TIP: If you would like to learn more about reentrancy and alternative ways
455  * to protect against it, check out our blog post
456  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
457  */
458 abstract contract ReentrancyGuard {
459     // Booleans are more expensive than uint256 or any type that takes up a full
460     // word because each write operation emits an extra SLOAD to first read the
461     // slot's contents, replace the bits taken up by the boolean, and then write
462     // back. This is the compiler's defense against contract upgrades and
463     // pointer aliasing, and it cannot be disabled.
464 
465     // The values being non-zero value makes deployment a bit more expensive,
466     // but in exchange the refund on every call to nonReentrant will be lower in
467     // amount. Since refunds are capped to a percentage of the total
468     // transaction's gas, it is best to keep them low in cases like this one, to
469     // increase the likelihood of the full refund coming into effect.
470     uint256 private constant _NOT_ENTERED = 1;
471     uint256 private constant _ENTERED = 2;
472 
473     uint256 private _status;
474 
475     constructor() {
476         _status = _NOT_ENTERED;
477     }
478 
479     /**
480      * @dev Prevents a contract from calling itself, directly or indirectly.
481      * Calling a `nonReentrant` function from another `nonReentrant`
482      * function is not supported. It is possible to prevent this from happening
483      * by making the `nonReentrant` function external, and make it call a
484      * `private` function that does the actual work.
485      */
486     modifier nonReentrant() {
487         // On the first call to nonReentrant, _notEntered will be true
488         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
489 
490         // Any calls to nonReentrant after this point will fail
491         _status = _ENTERED;
492 
493         _;
494 
495         // By storing the original value once again, a refund is triggered (see
496         // https://eips.ethereum.org/EIPS/eip-2200)
497         _status = _NOT_ENTERED;
498     }
499 }
500 
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
523 
524 /**
525  * @dev Implementation of the {IERC165} interface.
526  *
527  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
528  * for the additional interface id that will be supported. For example:
529  *
530  * ```solidity
531  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
532  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
533  * }
534  * ```
535  *
536  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
537  */
538 abstract contract ERC165 is IERC165 {
539     /**
540      * @dev See {IERC165-supportsInterface}.
541      */
542     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
543         return interfaceId == type(IERC165).interfaceId;
544     }
545 }
546 
547 
548 /**
549  * @title ERC721 token receiver interface
550  * @dev Interface for any contract that wants to support safeTransfers
551  * from ERC721 asset contracts.
552  */
553 interface IERC721Receiver {
554     /**
555      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
556      * by `operator` from `from`, this function is called.
557      *
558      * It must return its Solidity selector to confirm the token transfer.
559      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
560      *
561      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
562      */
563     function onERC721Received(
564         address operator,
565         address from,
566         uint256 tokenId,
567         bytes calldata data
568     ) external returns (bytes4);
569 }
570 
571 
572 /**
573  * @dev Required interface of an ERC721 compliant contract.
574  */
575 interface IERC721 is IERC165 {
576     /**
577      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
578      */
579     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
580 
581     /**
582      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
583      */
584     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
585 
586     /**
587      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
588      */
589     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
590 
591     /**
592      * @dev Returns the number of tokens in ``owner``'s account.
593      */
594     function balanceOf(address owner) external view returns (uint256 balance);
595 
596     /**
597      * @dev Returns the owner of the `tokenId` token.
598      *
599      * Requirements:
600      *
601      * - `tokenId` must exist.
602      */
603     function ownerOf(uint256 tokenId) external view returns (address owner);
604 
605     /**
606      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
607      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
608      *
609      * Requirements:
610      *
611      * - `from` cannot be the zero address.
612      * - `to` cannot be the zero address.
613      * - `tokenId` token must exist and be owned by `from`.
614      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
615      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
616      *
617      * Emits a {Transfer} event.
618      */
619     function safeTransferFrom(
620         address from,
621         address to,
622         uint256 tokenId
623     ) external;
624 
625     /**
626      * @dev Transfers `tokenId` token from `from` to `to`.
627      *
628      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
629      *
630      * Requirements:
631      *
632      * - `from` cannot be the zero address.
633      * - `to` cannot be the zero address.
634      * - `tokenId` token must be owned by `from`.
635      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
636      *
637      * Emits a {Transfer} event.
638      */
639     function transferFrom(
640         address from,
641         address to,
642         uint256 tokenId
643     ) external;
644 
645     /**
646      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
647      * The approval is cleared when the token is transferred.
648      *
649      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
650      *
651      * Requirements:
652      *
653      * - The caller must own the token or be an approved operator.
654      * - `tokenId` must exist.
655      *
656      * Emits an {Approval} event.
657      */
658     function approve(address to, uint256 tokenId) external;
659 
660     /**
661      * @dev Returns the account approved for `tokenId` token.
662      *
663      * Requirements:
664      *
665      * - `tokenId` must exist.
666      */
667     function getApproved(uint256 tokenId) external view returns (address operator);
668 
669     /**
670      * @dev Approve or remove `operator` as an operator for the caller.
671      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
672      *
673      * Requirements:
674      *
675      * - The `operator` cannot be the caller.
676      *
677      * Emits an {ApprovalForAll} event.
678      */
679     function setApprovalForAll(address operator, bool _approved) external;
680 
681     /**
682      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
683      *
684      * See {setApprovalForAll}
685      */
686     function isApprovedForAll(address owner, address operator) external view returns (bool);
687 
688     /**
689      * @dev Safely transfers `tokenId` token from `from` to `to`.
690      *
691      * Requirements:
692      *
693      * - `from` cannot be the zero address.
694      * - `to` cannot be the zero address.
695      * - `tokenId` token must exist and be owned by `from`.
696      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
697      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
698      *
699      * Emits a {Transfer} event.
700      */
701     function safeTransferFrom(
702         address from,
703         address to,
704         uint256 tokenId,
705         bytes calldata data
706     ) external;
707 }
708 
709 
710 /**
711  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
712  * @dev See https://eips.ethereum.org/EIPS/eip-721
713  */
714 interface IERC721Enumerable is IERC721 {
715     /**
716      * @dev Returns the total amount of tokens stored by the contract.
717      */
718     function totalSupply() external view returns (uint256);
719 
720     /**
721      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
722      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
723      */
724     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
725 
726     /**
727      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
728      * Use along with {totalSupply} to enumerate all tokens.
729      */
730     function tokenByIndex(uint256 index) external view returns (uint256);
731 }
732 
733 
734 /**
735  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
736  * @dev See https://eips.ethereum.org/EIPS/eip-721
737  */
738 interface IERC721Metadata is IERC721 {
739     /**
740      * @dev Returns the token collection name.
741      */
742     function name() external view returns (string memory);
743 
744     /**
745      * @dev Returns the token collection symbol.
746      */
747     function symbol() external view returns (string memory);
748 
749     /**
750      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
751      */
752     function tokenURI(uint256 tokenId) external view returns (string memory);
753 }
754 
755 
756 /**
757  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
758  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
759  *
760  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
761  *
762  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
763  *
764  * Does not support burning tokens to address(0).
765  */
766 contract ERC721A is
767   Context,
768   ERC165,
769   IERC721,
770   IERC721Metadata,
771   IERC721Enumerable
772 {
773   using Address for address;
774   using Strings for uint256;
775 
776   struct TokenOwnership {
777     address addr;
778     uint64 startTimestamp;
779   }
780 
781   struct AddressData {
782     uint128 balance;
783     uint128 numberMinted;
784   }
785 
786   uint256 private currentIndex = 0;
787 
788   uint256 internal immutable collectionSize;
789   uint256 internal immutable maxBatchSize;
790 
791   // Token name
792   string private _name;
793 
794   // Token symbol
795   string private _symbol;
796 
797   // Mapping from token ID to ownership details
798   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
799   mapping(uint256 => TokenOwnership) private _ownerships;
800 
801   // Mapping owner address to address data
802   mapping(address => AddressData) private _addressData;
803 
804   // Mapping from token ID to approved address
805   mapping(uint256 => address) private _tokenApprovals;
806 
807   // Mapping from owner to operator approvals
808   mapping(address => mapping(address => bool)) private _operatorApprovals;
809 
810   /**
811    * @dev
812    * `maxBatchSize` refers to how much a minter can mint at a time.
813    * `collectionSize_` refers to how many tokens are in the collection.
814    */
815   constructor(
816     string memory name_,
817     string memory symbol_,
818     uint256 maxBatchSize_,
819     uint256 collectionSize_
820   ) {
821     require(
822       collectionSize_ > 0,
823       "ERC721A: collection must have a nonzero supply"
824     );
825     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
826     _name = name_;
827     _symbol = symbol_;
828     maxBatchSize = maxBatchSize_;
829     collectionSize = collectionSize_;
830   }
831 
832   /**
833    * @dev See {IERC721Enumerable-totalSupply}.
834    */
835   function totalSupply() public view override returns (uint256) {
836     return currentIndex;
837   }
838 
839   /**
840    * @dev See {IERC721Enumerable-tokenByIndex}.
841    */
842   function tokenByIndex(uint256 index) public view override returns (uint256) {
843     require(index < totalSupply(), "ERC721A: global index out of bounds");
844     return index;
845   }
846 
847   /**
848    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
849    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
850    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
851    */
852   function tokenOfOwnerByIndex(address owner, uint256 index)
853     public
854     view
855     override
856     returns (uint256)
857   {
858     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
859     uint256 numMintedSoFar = totalSupply();
860     uint256 tokenIdsIdx = 0;
861     address currOwnershipAddr = address(0);
862     for (uint256 i = 0; i < numMintedSoFar; i++) {
863       TokenOwnership memory ownership = _ownerships[i];
864       if (ownership.addr != address(0)) {
865         currOwnershipAddr = ownership.addr;
866       }
867       if (currOwnershipAddr == owner) {
868         if (tokenIdsIdx == index) {
869           return i;
870         }
871         tokenIdsIdx++;
872       }
873     }
874     revert("ERC721A: unable to get token of owner by index");
875   }
876 
877   /**
878    * @dev See {IERC165-supportsInterface}.
879    */
880   function supportsInterface(bytes4 interfaceId)
881     public
882     view
883     virtual
884     override(ERC165, IERC165)
885     returns (bool)
886   {
887     return
888       interfaceId == type(IERC721).interfaceId ||
889       interfaceId == type(IERC721Metadata).interfaceId ||
890       interfaceId == type(IERC721Enumerable).interfaceId ||
891       super.supportsInterface(interfaceId);
892   }
893 
894   /**
895    * @dev See {IERC721-balanceOf}.
896    */
897   function balanceOf(address owner) public view override returns (uint256) {
898     require(owner != address(0), "ERC721A: balance query for the zero address");
899     return uint256(_addressData[owner].balance);
900   }
901 
902   function _numberMinted(address owner) internal view returns (uint256) {
903     require(
904       owner != address(0),
905       "ERC721A: number minted query for the zero address"
906     );
907     return uint256(_addressData[owner].numberMinted);
908   }
909 
910   function ownershipOf(uint256 tokenId)
911     internal
912     view
913     returns (TokenOwnership memory)
914   {
915     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
916 
917     uint256 lowestTokenToCheck;
918     if (tokenId >= maxBatchSize) {
919       lowestTokenToCheck = tokenId - maxBatchSize + 1;
920     }
921 
922     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
923       TokenOwnership memory ownership = _ownerships[curr];
924       if (ownership.addr != address(0)) {
925         return ownership;
926       }
927     }
928 
929     revert("ERC721A: unable to determine the owner of token");
930   }
931 
932   /**
933    * @dev See {IERC721-ownerOf}.
934    */
935   function ownerOf(uint256 tokenId) public view override returns (address) {
936     return ownershipOf(tokenId).addr;
937   }
938 
939   /**
940    * @dev See {IERC721Metadata-name}.
941    */
942   function name() public view virtual override returns (string memory) {
943     return _name;
944   }
945 
946   /**
947    * @dev See {IERC721Metadata-symbol}.
948    */
949   function symbol() public view virtual override returns (string memory) {
950     return _symbol;
951   }
952 
953   /**
954    * @dev See {IERC721Metadata-tokenURI}.
955    */
956   function tokenURI(uint256 tokenId)
957     public
958     view
959     virtual
960     override
961     returns (string memory)
962   {
963     require(
964       _exists(tokenId),
965       "ERC721Metadata: URI query for nonexistent token"
966     );
967 
968     string memory baseURI = _baseURI();
969     return
970       bytes(baseURI).length > 0
971         ? string(abi.encodePacked(baseURI, tokenId.toString()))
972         : "";
973   }
974 
975   /**
976    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
977    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
978    * by default, can be overriden in child contracts.
979    */
980   function _baseURI() internal view virtual returns (string memory) {
981     return "";
982   }
983 
984   /**
985    * @dev See {IERC721-approve}.
986    */
987   function approve(address to, uint256 tokenId) public override {
988     address owner = ERC721A.ownerOf(tokenId);
989     require(to != owner, "ERC721A: approval to current owner");
990 
991     require(
992       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
993       "ERC721A: approve caller is not owner nor approved for all"
994     );
995 
996     _approve(to, tokenId, owner);
997   }
998 
999   /**
1000    * @dev See {IERC721-getApproved}.
1001    */
1002   function getApproved(uint256 tokenId) public view override returns (address) {
1003     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1004 
1005     return _tokenApprovals[tokenId];
1006   }
1007 
1008   /**
1009    * @dev See {IERC721-setApprovalForAll}.
1010    */
1011   function setApprovalForAll(address operator, bool approved) public override {
1012     require(operator != _msgSender(), "ERC721A: approve to caller");
1013 
1014     _operatorApprovals[_msgSender()][operator] = approved;
1015     emit ApprovalForAll(_msgSender(), operator, approved);
1016   }
1017 
1018   /**
1019    * @dev See {IERC721-isApprovedForAll}.
1020    */
1021   function isApprovedForAll(address owner, address operator)
1022     public
1023     view
1024     virtual
1025     override
1026     returns (bool)
1027   {
1028     return _operatorApprovals[owner][operator];
1029   }
1030 
1031   /**
1032    * @dev See {IERC721-transferFrom}.
1033    */
1034   function transferFrom(
1035     address from,
1036     address to,
1037     uint256 tokenId
1038   ) public override {
1039     _transfer(from, to, tokenId);
1040   }
1041 
1042   /**
1043    * @dev See {IERC721-safeTransferFrom}.
1044    */
1045   function safeTransferFrom(
1046     address from,
1047     address to,
1048     uint256 tokenId
1049   ) public override {
1050     safeTransferFrom(from, to, tokenId, "");
1051   }
1052 
1053   /**
1054    * @dev See {IERC721-safeTransferFrom}.
1055    */
1056   function safeTransferFrom(
1057     address from,
1058     address to,
1059     uint256 tokenId,
1060     bytes memory _data
1061   ) public override {
1062     _transfer(from, to, tokenId);
1063     require(
1064       _checkOnERC721Received(from, to, tokenId, _data),
1065       "ERC721A: transfer to non ERC721Receiver implementer"
1066     );
1067   }
1068 
1069   /**
1070    * @dev Returns whether `tokenId` exists.
1071    *
1072    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1073    *
1074    * Tokens start existing when they are minted (`_mint`),
1075    */
1076   function _exists(uint256 tokenId) internal view returns (bool) {
1077     return tokenId < currentIndex;
1078   }
1079 
1080   function _safeMint(address to, uint256 quantity) internal {
1081     _safeMint(to, quantity, "");
1082   }
1083 
1084   /**
1085    * @dev Mints `quantity` tokens and transfers them to `to`.
1086    *
1087    * Requirements:
1088    *
1089    * - there must be `quantity` tokens remaining unminted in the total collection.
1090    * - `to` cannot be the zero address.
1091    * - `quantity` cannot be larger than the max batch size.
1092    *
1093    * Emits a {Transfer} event.
1094    */
1095   function _safeMint(
1096     address to,
1097     uint256 quantity,
1098     bytes memory _data
1099   ) internal {
1100     uint256 startTokenId = currentIndex;
1101     require(to != address(0), "ERC721A: mint to the zero address");
1102     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1103     require(!_exists(startTokenId), "ERC721A: token already minted");
1104     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1105 
1106     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1107 
1108     AddressData memory addressData = _addressData[to];
1109     _addressData[to] = AddressData(
1110       addressData.balance + uint128(quantity),
1111       addressData.numberMinted + uint128(quantity)
1112     );
1113     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1114 
1115     uint256 updatedIndex = startTokenId;
1116 
1117     for (uint256 i = 0; i < quantity; i++) {
1118       emit Transfer(address(0), to, updatedIndex);
1119       require(
1120         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1121         "ERC721A: transfer to non ERC721Receiver implementer"
1122       );
1123       updatedIndex++;
1124     }
1125 
1126     currentIndex = updatedIndex;
1127     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1128   }
1129 
1130   /**
1131    * @dev Transfers `tokenId` from `from` to `to`.
1132    *
1133    * Requirements:
1134    *
1135    * - `to` cannot be the zero address.
1136    * - `tokenId` token must be owned by `from`.
1137    *
1138    * Emits a {Transfer} event.
1139    */
1140   function _transfer(
1141     address from,
1142     address to,
1143     uint256 tokenId
1144   ) private {
1145     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1146 
1147     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1148       getApproved(tokenId) == _msgSender() ||
1149       isApprovedForAll(prevOwnership.addr, _msgSender()));
1150 
1151     require(
1152       isApprovedOrOwner,
1153       "ERC721A: transfer caller is not owner nor approved"
1154     );
1155 
1156     require(
1157       prevOwnership.addr == from,
1158       "ERC721A: transfer from incorrect owner"
1159     );
1160     require(to != address(0), "ERC721A: transfer to the zero address");
1161 
1162     _beforeTokenTransfers(from, to, tokenId, 1);
1163 
1164     // Clear approvals from the previous owner
1165     _approve(address(0), tokenId, prevOwnership.addr);
1166 
1167     _addressData[from].balance -= 1;
1168     _addressData[to].balance += 1;
1169     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1170 
1171     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1172     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1173     uint256 nextTokenId = tokenId + 1;
1174     if (_ownerships[nextTokenId].addr == address(0)) {
1175       if (_exists(nextTokenId)) {
1176         _ownerships[nextTokenId] = TokenOwnership(
1177           prevOwnership.addr,
1178           prevOwnership.startTimestamp
1179         );
1180       }
1181     }
1182 
1183     emit Transfer(from, to, tokenId);
1184     _afterTokenTransfers(from, to, tokenId, 1);
1185   }
1186 
1187   /**
1188    * @dev Approve `to` to operate on `tokenId`
1189    *
1190    * Emits a {Approval} event.
1191    */
1192   function _approve(
1193     address to,
1194     uint256 tokenId,
1195     address owner
1196   ) private {
1197     _tokenApprovals[tokenId] = to;
1198     emit Approval(owner, to, tokenId);
1199   }
1200 
1201   uint256 public nextOwnerToExplicitlySet = 0;
1202 
1203   /**
1204    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1205    */
1206   function _setOwnersExplicit(uint256 quantity) internal {
1207     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1208     require(quantity > 0, "quantity must be nonzero");
1209     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1210     if (endIndex > collectionSize - 1) {
1211       endIndex = collectionSize - 1;
1212     }
1213     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1214     require(_exists(endIndex), "not enough minted yet for this cleanup");
1215     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1216       if (_ownerships[i].addr == address(0)) {
1217         TokenOwnership memory ownership = ownershipOf(i);
1218         _ownerships[i] = TokenOwnership(
1219           ownership.addr,
1220           ownership.startTimestamp
1221         );
1222       }
1223     }
1224     nextOwnerToExplicitlySet = endIndex + 1;
1225   }
1226 
1227   /**
1228    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1229    * The call is not executed if the target address is not a contract.
1230    *
1231    * @param from address representing the previous owner of the given token ID
1232    * @param to target address that will receive the tokens
1233    * @param tokenId uint256 ID of the token to be transferred
1234    * @param _data bytes optional data to send along with the call
1235    * @return bool whether the call correctly returned the expected magic value
1236    */
1237   function _checkOnERC721Received(
1238     address from,
1239     address to,
1240     uint256 tokenId,
1241     bytes memory _data
1242   ) private returns (bool) {
1243     if (to.isContract()) {
1244       try
1245         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1246       returns (bytes4 retval) {
1247         return retval == IERC721Receiver(to).onERC721Received.selector;
1248       } catch (bytes memory reason) {
1249         if (reason.length == 0) {
1250           revert("ERC721A: transfer to non ERC721Receiver implementer");
1251         } else {
1252           assembly {
1253             revert(add(32, reason), mload(reason))
1254           }
1255         }
1256       }
1257     } else {
1258       return true;
1259     }
1260   }
1261 
1262   /**
1263    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1264    *
1265    * startTokenId - the first token id to be transferred
1266    * quantity - the amount to be transferred
1267    *
1268    * Calling conditions:
1269    *
1270    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1271    * transferred to `to`.
1272    * - When `from` is zero, `tokenId` will be minted for `to`.
1273    */
1274   function _beforeTokenTransfers(
1275     address from,
1276     address to,
1277     uint256 startTokenId,
1278     uint256 quantity
1279   ) internal virtual {}
1280 
1281   /**
1282    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1283    * minting.
1284    *
1285    * startTokenId - the first token id to be transferred
1286    * quantity - the amount to be transferred
1287    *
1288    * Calling conditions:
1289    *
1290    * - when `from` and `to` are both non-zero.
1291    * - `from` and `to` are never both zero.
1292    */
1293   function _afterTokenTransfers(
1294     address from,
1295     address to,
1296     uint256 startTokenId,
1297     uint256 quantity
1298   ) internal virtual {}
1299 }
1300 
1301 
1302 contract CypherCollection is Ownable, ERC721A, ReentrancyGuard {
1303   using SafeMath for uint256;
1304 
1305   uint256 public immutable maxPerAddressDuringMint;
1306   uint256 public immutable amountForDevs;
1307   uint256 public immutable amountForSaleAndDev;
1308   uint256 public immutable amountCollectionPartOne;
1309 
1310   address payoutWallet1;
1311   address payoutWallet2;
1312 
1313   uint256 bytPayoutPercentage;
1314 
1315   uint256[2] public saleStartTime;
1316   uint256[2] public whitelistStartTime;
1317   uint256[2] public totalGiveawayMints;
1318   uint256 public maxPublicMints;
1319 
1320   uint256 public totalGiveawayMintsRedeemed;
1321 
1322   uint256 public publicSaleCost;
1323 
1324   //Using an array of mappings to track whitelist mints for wallets
1325   //since numberMinted() does not reset between part 1 and part 2
1326   mapping(address => uint256)[2] public whitelistMints;
1327 
1328   mapping(address => uint256) public whitelistFreeMints;
1329 
1330   bytes32[] _whitelistRootHash;
1331 
1332   constructor(
1333     uint256 maxBatchSize_,
1334     uint256 collectionSize_,
1335     uint256 amountForAuctionAndDev_,
1336     uint256 amountForDevs_,
1337     uint256 amountPartOne_
1338   ) ERC721A("Cypher Collection", "CYPH", maxBatchSize_, collectionSize_) {
1339     maxPerAddressDuringMint = maxBatchSize_;
1340     amountForSaleAndDev = amountForAuctionAndDev_;
1341     amountForDevs = amountForDevs_;
1342     amountCollectionPartOne = amountPartOne_;
1343     require(
1344       amountForAuctionAndDev_ <= collectionSize_,
1345       "larger collection size needed"
1346     );
1347     require(amountPartOne_ < collectionSize_, "Part one too large");
1348     publicSaleCost = 0.5 ether;
1349     bytPayoutPercentage = 9;
1350     maxPublicMints = 5;
1351     totalGiveawayMints[0] = 60;
1352     payoutWallet1 = address(0xe36d11e70AEe5e3908C8237590241dFc1A2efd05); // collider payout wallet
1353     payoutWallet2 = address(0x3Fe3EdB8552a7bb577E5b6f22150511cc76d0c21); // byt payout wallet
1354   }
1355 
1356   modifier callerIsUser() {
1357     require(tx.origin == msg.sender, "The caller is another contract");
1358     _;
1359   }
1360 
1361   function addToWhitelistRootHash(bytes32 _hash) public onlyOwner{
1362         _whitelistRootHash.push(_hash);
1363     }
1364 
1365   // Will be used after part 1 finishes to prepare new whitelist for part 2
1366   function clearWhitelist() external onlyOwner{
1367     delete _whitelistRootHash;
1368   }
1369 
1370   function setWhitelistStartTime(uint256 _index, uint256 _time) external onlyOwner {
1371     require(_index < whitelistStartTime.length, "Index out of bounds");
1372     whitelistStartTime[_index] = _time;
1373   }
1374 
1375   function setSaleSTartTime(uint256 _index, uint256 _time) external onlyOwner {
1376     require(_index < saleStartTime.length, "Index out of bounds");
1377     saleStartTime[_index] = _time;
1378   }
1379 
1380   function setPublicSaleCost(uint256 _cost) external onlyOwner {
1381     publicSaleCost = _cost;
1382   }
1383 
1384   function setPartTwoGiveawayMintsCount(uint256 _count) external onlyOwner {
1385     totalGiveawayMints[1] = _count;
1386   }
1387 
1388    // Merkle leaf validator function for storing whitelists off chain saving massive gas
1389   function whitelistValidated(address wallet, uint256 whitelistQuantity, uint256 index, uint256 freeMintQuantity, bytes32[] memory proof) internal view returns (bool) {
1390 
1391         // Compute the merkle root
1392         bytes32 node = keccak256(abi.encodePacked(index, wallet, whitelistQuantity, freeMintQuantity));
1393         uint256 path = index;
1394         for (uint16 i = 0; i < proof.length; i++) {
1395             if ((path & 0x01) == 1) {
1396                 node = keccak256(abi.encodePacked(proof[i], node));
1397             } else {
1398                 node = keccak256(abi.encodePacked(node, proof[i]));
1399             }
1400             path /= 2;
1401         }
1402 
1403         // Check the merkle proof against the root hash array
1404         for(uint i = 0; i < _whitelistRootHash.length; i++)
1405         {
1406             if (node == _whitelistRootHash[i])
1407             {
1408                 return true;
1409             }
1410         }
1411 
1412         return false;
1413     }
1414 
1415   function publicMint(uint256 quantity) external payable callerIsUser {
1416     require(saleStartTime[0] != 0 && block.timestamp >= saleStartTime[0], "Public sale has not started yet");
1417     require(quantity <= maxPublicMints, "Minting too many at once");
1418     if(totalSupply() + quantity > amountCollectionPartOne)
1419     {
1420       require(totalSupply() + quantity + totalGiveawayMints[0] + totalGiveawayMints[1] - totalGiveawayMintsRedeemed <= amountCollectionPartOne, "Not enough supply for that quantity");
1421       require(saleStartTime[1] != 0 && block.timestamp >= saleStartTime[1], "The second sale has not started yet");
1422       require(totalSupply() + quantity <= amountForSaleAndDev, "Not enough remaining reserved for auction to support desired mint amount");
1423     }
1424     else {
1425       require(totalSupply() + quantity + totalGiveawayMints[0] - totalGiveawayMintsRedeemed <= amountCollectionPartOne, "Not enough supply for that quantity");
1426     }
1427     require(numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint, "Cannot mint this many");
1428 
1429     _safeMint(msg.sender, quantity);
1430     refundIfOver(publicSaleCost * quantity);
1431   }
1432 
1433   function whitelistMint(uint256 quantity, uint256 whitelistQuantity, uint256 spotInWhitelist, uint256 freeMintAmount, bytes32[] memory proof) external payable callerIsUser {
1434     require(whitelistValidated(_msgSender(), whitelistQuantity, spotInWhitelist, freeMintAmount, proof), "You're not on the giveaway list");
1435 
1436     uint256 finalMintCount;
1437 
1438     if(whitelistStartTime[1] != 0 && block.timestamp >= whitelistStartTime[1])
1439     { //Part 2 mint
1440       //Make sure input quantity added to current supply and reserved mints doesn't go over max collection size
1441       require(totalSupply() + quantity + totalGiveawayMints[0] + totalGiveawayMints[1] - totalGiveawayMintsRedeemed <= amountForSaleAndDev, "Not enough remaining reserved for auction to support desired mint amount");
1442       require(whitelistMints[1][msg.sender] + quantity <= whitelistQuantity, "Too many whitelist mints during this round");
1443       if(quantity > 0)
1444       {
1445         finalMintCount += quantity;
1446         whitelistMints[1][msg.sender] += quantity;
1447       }
1448       //check to see if user has any free mints available and if they have already been claimed
1449       if(freeMintAmount > 0 && whitelistFreeMints[msg.sender] == 0)
1450       {
1451         finalMintCount += freeMintAmount;
1452         whitelistFreeMints[msg.sender] += freeMintAmount;
1453         totalGiveawayMintsRedeemed += freeMintAmount;
1454       }
1455     }
1456     else{ //Part 1 mint
1457       //Make sure input quantity added to current supply and reserved mints doesn't go over part one collection size
1458       require(totalSupply() + quantity + totalGiveawayMints[0] - totalGiveawayMintsRedeemed <= amountCollectionPartOne, "Not enough supply for that quantity");
1459       require(whitelistStartTime[0] != 0 && block.timestamp >= whitelistStartTime[0], "Whitelist sale not started");
1460       require(whitelistMints[0][msg.sender] + quantity <= whitelistQuantity, "Too many whitelist mints during this round");
1461       if(quantity > 0)
1462       {
1463         finalMintCount += quantity;
1464         whitelistMints[0][msg.sender] += quantity;
1465       }
1466       //check to see if user has any free mints available and if they have already been claimed
1467       if(freeMintAmount > 0 && whitelistFreeMints[msg.sender] == 0)
1468       {
1469         finalMintCount += freeMintAmount;
1470         whitelistFreeMints[msg.sender] += freeMintAmount;
1471         totalGiveawayMintsRedeemed += freeMintAmount;
1472       }
1473     }
1474 
1475     _safeMint(msg.sender, finalMintCount);
1476     refundIfOver(publicSaleCost * quantity);
1477   }
1478 
1479   function refundIfOver(uint256 price) private {
1480     require(msg.value >= price, "Need to send more ETH.");
1481     if (msg.value > price) {
1482       payable(msg.sender).transfer(msg.value - price);
1483     }
1484   }
1485 
1486   // For marketing etc.
1487   function devMint(uint256 quantity, address _To) external onlyOwner {
1488     require(totalSupply() + quantity <= amountForDevs, "too many already minted before dev mint");
1489     require(quantity % maxBatchSize == 0, "can only mint a multiple of the maxBatchSize");
1490     uint256 numChunks = quantity / maxBatchSize;
1491     for (uint256 i = 0; i < numChunks; i++) {
1492       _safeMint(_To, maxBatchSize);
1493     }
1494   }
1495 
1496   // metadata URI
1497   string private _baseTokenURI;
1498 
1499   function _baseURI() internal view virtual override returns (string memory) {
1500     return _baseTokenURI;
1501   }
1502 
1503   function setBaseURI(string calldata baseURI) external onlyOwner {
1504     _baseTokenURI = baseURI;
1505   }
1506 
1507   // Standard withdraw function that only executes when both wallets are set
1508   function withdraw() external onlyOwner {
1509         require(payoutWallet1 != address(0), "wallet 1 not set");
1510         require(payoutWallet2 != address(0), "wallet 2 not set");
1511         uint256 balance = address(this).balance;
1512         uint256 walletBalance = balance.mul(100 - bytPayoutPercentage).div(100);
1513         payable(payoutWallet1).transfer(walletBalance);
1514         payable(payoutWallet2).transfer(balance.sub(walletBalance));
1515     }
1516 
1517   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1518     _setOwnersExplicit(quantity);
1519   }
1520 
1521   function numberMinted(address owner) public view returns (uint256) {
1522     return _numberMinted(owner);
1523   }
1524 
1525   function getOwnershipData(uint256 tokenId)
1526     external
1527     view
1528     returns (TokenOwnership memory)
1529   {
1530     return ownershipOf(tokenId);
1531   }
1532 }