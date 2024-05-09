1 // File: node_modules\@openzeppelin\contracts\utils\math\SafeMath.sol";
2 
3 pragma solidity ^0.8.0;
4 
5 // CAUTION
6 // This version of SafeMath should only be used with Solidity 0.8 or later,
7 // because it relies on the compiler's built in overflow checks.
8 
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations.
11  *
12  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
13  * now has built in overflow checking.
14  */
15 library SafeMath {
16     /**
17      * @dev Returns the addition of two unsigned integers, with an overflow flag.
18      *
19      * _Available since v3.4._
20      */
21     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
22         unchecked {
23             uint256 c = a + b;
24             if (c < a) return (false, 0);
25             return (true, c);
26         }
27     }
28 
29     /**
30      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
31      *
32      * _Available since v3.4._
33      */
34     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35         unchecked {
36             if (b > a) return (false, 0);
37             return (true, a - b);
38         }
39     }
40 
41     /**
42      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
43      *
44      * _Available since v3.4._
45      */
46     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
47         unchecked {
48             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49             // benefit is lost if 'b' is also tested.
50             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
51             if (a == 0) return (true, 0);
52             uint256 c = a * b;
53             if (c / a != b) return (false, 0);
54             return (true, c);
55         }
56     }
57 
58     /**
59      * @dev Returns the division of two unsigned integers, with a division by zero flag.
60      *
61      * _Available since v3.4._
62      */
63     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
64         unchecked {
65             if (b == 0) return (false, 0);
66             return (true, a / b);
67         }
68     }
69 
70     /**
71      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
72      *
73      * _Available since v3.4._
74      */
75     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
76         unchecked {
77             if (b == 0) return (false, 0);
78             return (true, a % b);
79         }
80     }
81 
82     /**
83      * @dev Returns the addition of two unsigned integers, reverting on
84      * overflow.
85      *
86      * Counterpart to Solidity's `+` operator.
87      *
88      * Requirements:
89      *
90      * - Addition cannot overflow.
91      */
92     function add(uint256 a, uint256 b) internal pure returns (uint256) {
93         return a + b;
94     }
95 
96     /**
97      * @dev Returns the subtraction of two unsigned integers, reverting on
98      * overflow (when the result is negative).
99      *
100      * Counterpart to Solidity's `-` operator.
101      *
102      * Requirements:
103      *
104      * - Subtraction cannot overflow.
105      */
106     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
107         return a - b;
108     }
109 
110     /**
111      * @dev Returns the multiplication of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `*` operator.
115      *
116      * Requirements:
117      *
118      * - Multiplication cannot overflow.
119      */
120     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
121         return a * b;
122     }
123 
124     /**
125      * @dev Returns the integer division of two unsigned integers, reverting on
126      * division by zero. The result is rounded towards zero.
127      *
128      * Counterpart to Solidity's `/` operator.
129      *
130      * Requirements:
131      *
132      * - The divisor cannot be zero.
133      */
134     function div(uint256 a, uint256 b) internal pure returns (uint256) {
135         return a / b;
136     }
137 
138     /**
139      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
140      * reverting when dividing by zero.
141      *
142      * Counterpart to Solidity's `%` operator. This function uses a `revert`
143      * opcode (which leaves remaining gas untouched) while Solidity uses an
144      * invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      *
148      * - The divisor cannot be zero.
149      */
150     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
151         return a % b;
152     }
153 
154     /**
155      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
156      * overflow (when the result is negative).
157      *
158      * CAUTION: This function is deprecated because it requires allocating memory for the error
159      * message unnecessarily. For custom revert reasons use {trySub}.
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      *
165      * - Subtraction cannot overflow.
166      */
167     function sub(
168         uint256 a,
169         uint256 b,
170         string memory errorMessage
171     ) internal pure returns (uint256) {
172         unchecked {
173             require(b <= a, errorMessage);
174             return a - b;
175         }
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
180      * division by zero. The result is rounded towards zero.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function div(
191         uint256 a,
192         uint256 b,
193         string memory errorMessage
194     ) internal pure returns (uint256) {
195         unchecked {
196             require(b > 0, errorMessage);
197             return a / b;
198         }
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * reverting with custom message when dividing by zero.
204      *
205      * CAUTION: This function is deprecated because it requires allocating memory for the error
206      * message unnecessarily. For custom revert reasons use {tryMod}.
207      *
208      * Counterpart to Solidity's `%` operator. This function uses a `revert`
209      * opcode (which leaves remaining gas untouched) while Solidity uses an
210      * invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function mod(
217         uint256 a,
218         uint256 b,
219         string memory errorMessage
220     ) internal pure returns (uint256) {
221         unchecked {
222             require(b > 0, errorMessage);
223             return a % b;
224         }
225     }
226 }
227 // File: node_modules\@openzeppelin\contracts\utils\Context.sol
228 
229 
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
253 // File: @openzeppelin\contracts\access\Ownable.sol
254 
255 
256 
257 pragma solidity ^0.8.0;
258 
259 
260 /**
261  * @dev Contract module which provides a basic access control mechanism, where
262  * there is an account (an owner) that can be granted exclusive access to
263  * specific functions.
264  *
265  * By default, the owner account will be the one that deploys the contract. This
266  * can later be changed with {transferOwnership}.
267  *
268  * This module is used through inheritance. It will make available the modifier
269  * `onlyOwner`, which can be applied to your functions to restrict their use to
270  * the owner.
271  */
272 abstract contract Ownable is Context {
273     address private _owner;
274 
275     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
276 
277     /**
278      * @dev Initializes the contract setting the deployer as the initial owner.
279      */
280     constructor() {
281         _setOwner(_msgSender());
282     }
283 
284     /**
285      * @dev Returns the address of the current owner.
286      */
287     function owner() public view virtual returns (address) {
288         return _owner;
289     }
290 
291     /**
292      * @dev Throws if called by any account other than the owner.
293      */
294     modifier onlyOwner() {
295         require(owner() == _msgSender(), "Ownable: caller is not the owner");
296         _;
297     }
298 
299     /**
300      * @dev Leaves the contract without owner. It will not be possible to call
301      * `onlyOwner` functions anymore. Can only be called by the current owner.
302      *
303      * NOTE: Renouncing ownership will leave the contract without an owner,
304      * thereby removing any functionality that is only available to the owner.
305      */
306     function renounceOwnership() public virtual onlyOwner {
307         _setOwner(address(0));
308     }
309 
310     /**
311      * @dev Transfers ownership of the contract to a new account (`newOwner`).
312      * Can only be called by the current owner.
313      */
314     function transferOwnership(address newOwner) public virtual onlyOwner {
315         require(newOwner != address(0), "Ownable: new owner is the zero address");
316         _setOwner(newOwner);
317     }
318 
319     function _setOwner(address newOwner) private {
320         address oldOwner = _owner;
321         _owner = newOwner;
322         emit OwnershipTransferred(oldOwner, newOwner);
323     }
324 }
325 
326 // File: node_modules\@openzeppelin\contracts\utils\introspection\IERC165.sol
327 
328 
329 
330 pragma solidity ^0.8.0;
331 
332 /**
333  * @dev Interface of the ERC165 standard, as defined in the
334  * https://eips.ethereum.org/EIPS/eip-165[EIP].
335  *
336  * Implementers can declare support of contract interfaces, which can then be
337  * queried by others ({ERC165Checker}).
338  *
339  * For an implementation, see {ERC165}.
340  */
341 interface IERC165 {
342     /**
343      * @dev Returns true if this contract implements the interface defined by
344      * `interfaceId`. See the corresponding
345      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
346      * to learn more about how these ids are created.
347      *
348      * This function call must use less than 30 000 gas.
349      */
350     function supportsInterface(bytes4 interfaceId) external view returns (bool);
351 }
352 
353 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721.sol
354 
355 
356 
357 pragma solidity ^0.8.0;
358 
359 
360 /**
361  * @dev Required interface of an ERC721 compliant contract.
362  */
363 interface IERC721 is IERC165 {
364     /**
365      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
366      */
367     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
368 
369     /**
370      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
371      */
372     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
373 
374     /**
375      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
376      */
377     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
378 
379     /**
380      * @dev Returns the number of tokens in ``owner``'s account.
381      */
382     function balanceOf(address owner) external view returns (uint256 balance);
383 
384     /**
385      * @dev Returns the owner of the `tokenId` token.
386      *
387      * Requirements:
388      *
389      * - `tokenId` must exist.
390      */
391     function ownerOf(uint256 tokenId) external view returns (address owner);
392 
393     /**
394      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
395      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
396      *
397      * Requirements:
398      *
399      * - `from` cannot be the zero address.
400      * - `to` cannot be the zero address.
401      * - `tokenId` token must exist and be owned by `from`.
402      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
403      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
404      *
405      * Emits a {Transfer} event.
406      */
407     function safeTransferFrom(
408         address from,
409         address to,
410         uint256 tokenId
411     ) external;
412 
413     /**
414      * @dev Transfers `tokenId` token from `from` to `to`.
415      *
416      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
417      *
418      * Requirements:
419      *
420      * - `from` cannot be the zero address.
421      * - `to` cannot be the zero address.
422      * - `tokenId` token must be owned by `from`.
423      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
424      *
425      * Emits a {Transfer} event.
426      */
427     function transferFrom(
428         address from,
429         address to,
430         uint256 tokenId
431     ) external;
432 
433     /**
434      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
435      * The approval is cleared when the token is transferred.
436      *
437      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
438      *
439      * Requirements:
440      *
441      * - The caller must own the token or be an approved operator.
442      * - `tokenId` must exist.
443      *
444      * Emits an {Approval} event.
445      */
446     function approve(address to, uint256 tokenId) external;
447 
448     /**
449      * @dev Returns the account approved for `tokenId` token.
450      *
451      * Requirements:
452      *
453      * - `tokenId` must exist.
454      */
455     function getApproved(uint256 tokenId) external view returns (address operator);
456 
457     /**
458      * @dev Approve or remove `operator` as an operator for the caller.
459      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
460      *
461      * Requirements:
462      *
463      * - The `operator` cannot be the caller.
464      *
465      * Emits an {ApprovalForAll} event.
466      */
467     function setApprovalForAll(address operator, bool _approved) external;
468 
469     /**
470      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
471      *
472      * See {setApprovalForAll}
473      */
474     function isApprovedForAll(address owner, address operator) external view returns (bool);
475 
476     /**
477      * @dev Safely transfers `tokenId` token from `from` to `to`.
478      *
479      * Requirements:
480      *
481      * - `from` cannot be the zero address.
482      * - `to` cannot be the zero address.
483      * - `tokenId` token must exist and be owned by `from`.
484      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
485      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
486      *
487      * Emits a {Transfer} event.
488      */
489     function safeTransferFrom(
490         address from,
491         address to,
492         uint256 tokenId,
493         bytes calldata data
494     ) external;
495 }
496 
497 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721Receiver.sol
498 
499 
500 
501 pragma solidity ^0.8.0;
502 
503 /**
504  * @title ERC721 token receiver interface
505  * @dev Interface for any contract that wants to support safeTransfers
506  * from ERC721 asset contracts.
507  */
508 interface IERC721Receiver {
509     /**
510      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
511      * by `operator` from `from`, this function is called.
512      *
513      * It must return its Solidity selector to confirm the token transfer.
514      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
515      *
516      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
517      */
518     function onERC721Received(
519         address operator,
520         address from,
521         uint256 tokenId,
522         bytes calldata data
523     ) external returns (bytes4);
524 }
525 
526 // File: node_modules\@openzeppelin\contracts\token\ERC721\extensions\IERC721Metadata.sol
527 
528 
529 
530 pragma solidity ^0.8.0;
531 
532 
533 /**
534  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
535  * @dev See https://eips.ethereum.org/EIPS/eip-721
536  */
537 interface IERC721Metadata is IERC721 {
538     /**
539      * @dev Returns the token collection name.
540      */
541     function name() external view returns (string memory);
542 
543     /**
544      * @dev Returns the token collection symbol.
545      */
546     function symbol() external view returns (string memory);
547 
548     /**
549      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
550      */
551     function tokenURI(uint256 tokenId) external view returns (string memory);
552 }
553 
554 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
555 
556 
557 
558 pragma solidity ^0.8.0;
559 
560 /**
561  * @dev Collection of functions related to the address type
562  */
563 library Address {
564     /**
565      * @dev Returns true if `account` is a contract.
566      *
567      * [IMPORTANT]
568      * ====
569      * It is unsafe to assume that an address for which this function returns
570      * false is an externally-owned account (EOA) and not a contract.
571      *
572      * Among others, `isContract` will return false for the following
573      * types of addresses:
574      *
575      *  - an externally-owned account
576      *  - a contract in construction
577      *  - an address where a contract will be created
578      *  - an address where a contract lived, but was destroyed
579      * ====
580      */
581     function isContract(address account) internal view returns (bool) {
582         // This method relies on extcodesize, which returns 0 for contracts in
583         // construction, since the code is only stored at the end of the
584         // constructor execution.
585 
586         uint256 size;
587         assembly {
588             size := extcodesize(account)
589         }
590         return size > 0;
591     }
592 
593     /**
594      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
595      * `recipient`, forwarding all available gas and reverting on errors.
596      *
597      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
598      * of certain opcodes, possibly making contracts go over the 2300 gas limit
599      * imposed by `transfer`, making them unable to receive funds via
600      * `transfer`. {sendValue} removes this limitation.
601      *
602      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
603      *
604      * IMPORTANT: because control is transferred to `recipient`, care must be
605      * taken to not create reentrancy vulnerabilities. Consider using
606      * {ReentrancyGuard} or the
607      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
608      */
609     function sendValue(address payable recipient, uint256 amount) internal {
610         require(address(this).balance >= amount, "Address: insufficient balance");
611 
612         (bool success, ) = recipient.call{value: amount}("");
613         require(success, "Address: unable to send value, recipient may have reverted");
614     }
615 
616     /**
617      * @dev Performs a Solidity function call using a low level `call`. A
618      * plain `call` is an unsafe replacement for a function call: use this
619      * function instead.
620      *
621      * If `target` reverts with a revert reason, it is bubbled up by this
622      * function (like regular Solidity function calls).
623      *
624      * Returns the raw returned data. To convert to the expected return value,
625      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
626      *
627      * Requirements:
628      *
629      * - `target` must be a contract.
630      * - calling `target` with `data` must not revert.
631      *
632      * _Available since v3.1._
633      */
634     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
635         return functionCall(target, data, "Address: low-level call failed");
636     }
637 
638     /**
639      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
640      * `errorMessage` as a fallback revert reason when `target` reverts.
641      *
642      * _Available since v3.1._
643      */
644     function functionCall(
645         address target,
646         bytes memory data,
647         string memory errorMessage
648     ) internal returns (bytes memory) {
649         return functionCallWithValue(target, data, 0, errorMessage);
650     }
651 
652     /**
653      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
654      * but also transferring `value` wei to `target`.
655      *
656      * Requirements:
657      *
658      * - the calling contract must have an ETH balance of at least `value`.
659      * - the called Solidity function must be `payable`.
660      *
661      * _Available since v3.1._
662      */
663     function functionCallWithValue(
664         address target,
665         bytes memory data,
666         uint256 value
667     ) internal returns (bytes memory) {
668         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
669     }
670 
671     /**
672      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
673      * with `errorMessage` as a fallback revert reason when `target` reverts.
674      *
675      * _Available since v3.1._
676      */
677     function functionCallWithValue(
678         address target,
679         bytes memory data,
680         uint256 value,
681         string memory errorMessage
682     ) internal returns (bytes memory) {
683         require(address(this).balance >= value, "Address: insufficient balance for call");
684         require(isContract(target), "Address: call to non-contract");
685 
686         (bool success, bytes memory returndata) = target.call{value: value}(data);
687         return verifyCallResult(success, returndata, errorMessage);
688     }
689 
690     /**
691      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
692      * but performing a static call.
693      *
694      * _Available since v3.3._
695      */
696     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
697         return functionStaticCall(target, data, "Address: low-level static call failed");
698     }
699 
700     /**
701      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
702      * but performing a static call.
703      *
704      * _Available since v3.3._
705      */
706     function functionStaticCall(
707         address target,
708         bytes memory data,
709         string memory errorMessage
710     ) internal view returns (bytes memory) {
711         require(isContract(target), "Address: static call to non-contract");
712 
713         (bool success, bytes memory returndata) = target.staticcall(data);
714         return verifyCallResult(success, returndata, errorMessage);
715     }
716 
717     /**
718      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
719      * but performing a delegate call.
720      *
721      * _Available since v3.4._
722      */
723     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
724         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
725     }
726 
727     /**
728      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
729      * but performing a delegate call.
730      *
731      * _Available since v3.4._
732      */
733     function functionDelegateCall(
734         address target,
735         bytes memory data,
736         string memory errorMessage
737     ) internal returns (bytes memory) {
738         require(isContract(target), "Address: delegate call to non-contract");
739 
740         (bool success, bytes memory returndata) = target.delegatecall(data);
741         return verifyCallResult(success, returndata, errorMessage);
742     }
743 
744     /**
745      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
746      * revert reason using the provided one.
747      *
748      * _Available since v4.3._
749      */
750     function verifyCallResult(
751         bool success,
752         bytes memory returndata,
753         string memory errorMessage
754     ) internal pure returns (bytes memory) {
755         if (success) {
756             return returndata;
757         } else {
758             // Look for revert reason and bubble it up if present
759             if (returndata.length > 0) {
760                 // The easiest way to bubble the revert reason is using memory via assembly
761 
762                 assembly {
763                     let returndata_size := mload(returndata)
764                     revert(add(32, returndata), returndata_size)
765                 }
766             } else {
767                 revert(errorMessage);
768             }
769         }
770     }
771 }
772 
773 // File: node_modules\@openzeppelin\contracts\utils\Strings.sol
774 
775 
776 
777 pragma solidity ^0.8.0;
778 
779 /**
780  * @dev String operations.
781  */
782 library Strings {
783     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
784 
785     /**
786      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
787      */
788     function toString(uint256 value) internal pure returns (string memory) {
789         // Inspired by OraclizeAPI's implementation - MIT licence
790         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
791 
792         if (value == 0) {
793             return "0";
794         }
795         uint256 temp = value;
796         uint256 digits;
797         while (temp != 0) {
798             digits++;
799             temp /= 10;
800         }
801         bytes memory buffer = new bytes(digits);
802         while (value != 0) {
803             digits -= 1;
804             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
805             value /= 10;
806         }
807         return string(buffer);
808     }
809 
810     /**
811      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
812      */
813     function toHexString(uint256 value) internal pure returns (string memory) {
814         if (value == 0) {
815             return "0x00";
816         }
817         uint256 temp = value;
818         uint256 length = 0;
819         while (temp != 0) {
820             length++;
821             temp >>= 8;
822         }
823         return toHexString(value, length);
824     }
825 
826     /**
827      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
828      */
829     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
830         bytes memory buffer = new bytes(2 * length + 2);
831         buffer[0] = "0";
832         buffer[1] = "x";
833         for (uint256 i = 2 * length + 1; i > 1; --i) {
834             buffer[i] = _HEX_SYMBOLS[value & 0xf];
835             value >>= 4;
836         }
837         require(value == 0, "Strings: hex length insufficient");
838         return string(buffer);
839     }
840 }
841 
842 // File: node_modules\@openzeppelin\contracts\utils\introspection\ERC165.sol
843 
844 
845 
846 pragma solidity ^0.8.0;
847 
848 
849 /**
850  * @dev Implementation of the {IERC165} interface.
851  *
852  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
853  * for the additional interface id that will be supported. For example:
854  *
855  * ```solidity
856  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
857  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
858  * }
859  * ```
860  *
861  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
862  */
863 abstract contract ERC165 is IERC165 {
864     /**
865      * @dev See {IERC165-supportsInterface}.
866      */
867     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
868         return interfaceId == type(IERC165).interfaceId;
869     }
870 }
871 
872 // File: node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol
873 
874 
875 
876 pragma solidity ^0.8.0;
877 
878 
879 
880 
881 
882 
883 
884 
885 /**
886  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
887  * the Metadata extension, but not including the Enumerable extension, which is available separately as
888  * {ERC721Enumerable}.
889  */
890 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
891     using Address for address;
892     using Strings for uint256;
893 
894     // Token name
895     string private _name;
896 
897     // Token symbol
898     string private _symbol;
899 
900     // Mapping from token ID to owner address
901     mapping(uint256 => address) private _owners;
902 
903     // Mapping owner address to token count
904     mapping(address => uint256) private _balances;
905 
906     // Mapping from token ID to approved address
907     mapping(uint256 => address) private _tokenApprovals;
908 
909     // Mapping from owner to operator approvals
910     mapping(address => mapping(address => bool)) private _operatorApprovals;
911 
912     /**
913      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
914      */
915     constructor(string memory name_, string memory symbol_) {
916         _name = name_;
917         _symbol = symbol_;
918     }
919 
920     /**
921      * @dev See {IERC165-supportsInterface}.
922      */
923     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
924         return
925             interfaceId == type(IERC721).interfaceId ||
926             interfaceId == type(IERC721Metadata).interfaceId ||
927             super.supportsInterface(interfaceId);
928     }
929 
930     /**
931      * @dev See {IERC721-balanceOf}.
932      */
933     function balanceOf(address owner) public view virtual override returns (uint256) {
934         require(owner != address(0), "ERC721: balance query for the zero address");
935         return _balances[owner];
936     }
937 
938     /**
939      * @dev See {IERC721-ownerOf}.
940      */
941     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
942         address owner = _owners[tokenId];
943         require(owner != address(0), "ERC721: owner query for nonexistent token");
944         return owner;
945     }
946 
947     /**
948      * @dev See {IERC721Metadata-name}.
949      */
950     function name() public view virtual override returns (string memory) {
951         return _name;
952     }
953 
954     /**
955      * @dev See {IERC721Metadata-symbol}.
956      */
957     function symbol() public view virtual override returns (string memory) {
958         return _symbol;
959     }
960 
961     /**
962      * @dev See {IERC721Metadata-tokenURI}.
963      */
964     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
965         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
966 
967         string memory baseURI = _baseURI();
968         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
969     }
970 
971     /**
972      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
973      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
974      * by default, can be overriden in child contracts.
975      */
976     function _baseURI() internal view virtual returns (string memory) {
977         return "";
978     }
979 
980     /**
981      * @dev See {IERC721-approve}.
982      */
983     function approve(address to, uint256 tokenId) public virtual override {
984         address owner = ERC721.ownerOf(tokenId);
985         require(to != owner, "ERC721: approval to current owner");
986 
987         require(
988             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
989             "ERC721: approve caller is not owner nor approved for all"
990         );
991 
992         _approve(to, tokenId);
993     }
994 
995     /**
996      * @dev See {IERC721-getApproved}.
997      */
998     function getApproved(uint256 tokenId) public view virtual override returns (address) {
999         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1000 
1001         return _tokenApprovals[tokenId];
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-setApprovalForAll}.
1006      */
1007     function setApprovalForAll(address operator, bool approved) public virtual override {
1008         require(operator != _msgSender(), "ERC721: approve to caller");
1009 
1010         _operatorApprovals[_msgSender()][operator] = approved;
1011         emit ApprovalForAll(_msgSender(), operator, approved);
1012     }
1013 
1014     /**
1015      * @dev See {IERC721-isApprovedForAll}.
1016      */
1017     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1018         return _operatorApprovals[owner][operator];
1019     }
1020 
1021     /**
1022      * @dev See {IERC721-transferFrom}.
1023      */
1024     function transferFrom(
1025         address from,
1026         address to,
1027         uint256 tokenId
1028     ) public virtual override {
1029         //solhint-disable-next-line max-line-length
1030         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1031 
1032         _transfer(from, to, tokenId);
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-safeTransferFrom}.
1037      */
1038     function safeTransferFrom(
1039         address from,
1040         address to,
1041         uint256 tokenId
1042     ) public virtual override {
1043         safeTransferFrom(from, to, tokenId, "");
1044     }
1045 
1046     /**
1047      * @dev See {IERC721-safeTransferFrom}.
1048      */
1049     function safeTransferFrom(
1050         address from,
1051         address to,
1052         uint256 tokenId,
1053         bytes memory _data
1054     ) public virtual override {
1055         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1056         _safeTransfer(from, to, tokenId, _data);
1057     }
1058 
1059     /**
1060      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1061      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1062      *
1063      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1064      *
1065      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1066      * implement alternative mechanisms to perform token transfer, such as signature-based.
1067      *
1068      * Requirements:
1069      *
1070      * - `from` cannot be the zero address.
1071      * - `to` cannot be the zero address.
1072      * - `tokenId` token must exist and be owned by `from`.
1073      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1074      *
1075      * Emits a {Transfer} event.
1076      */
1077     function _safeTransfer(
1078         address from,
1079         address to,
1080         uint256 tokenId,
1081         bytes memory _data
1082     ) internal virtual {
1083         _transfer(from, to, tokenId);
1084         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1085     }
1086 
1087     /**
1088      * @dev Returns whether `tokenId` exists.
1089      *
1090      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1091      *
1092      * Tokens start existing when they are minted (`_mint`),
1093      * and stop existing when they are burned (`_burn`).
1094      */
1095     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1096         return _owners[tokenId] != address(0);
1097     }
1098 
1099     /**
1100      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1101      *
1102      * Requirements:
1103      *
1104      * - `tokenId` must exist.
1105      */
1106     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1107         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1108         address owner = ERC721.ownerOf(tokenId);
1109         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1110     }
1111 
1112     /**
1113      * @dev Safely mints `tokenId` and transfers it to `to`.
1114      *
1115      * Requirements:
1116      *
1117      * - `tokenId` must not exist.
1118      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1119      *
1120      * Emits a {Transfer} event.
1121      */
1122     function _safeMint(address to, uint256 tokenId) internal virtual {
1123         _safeMint(to, tokenId, "");
1124     }
1125 
1126     /**
1127      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1128      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1129      */
1130     function _safeMint(
1131         address to,
1132         uint256 tokenId,
1133         bytes memory _data
1134     ) internal virtual {
1135         _mint(to, tokenId);
1136         require(
1137             _checkOnERC721Received(address(0), to, tokenId, _data),
1138             "ERC721: transfer to non ERC721Receiver implementer"
1139         );
1140     }
1141 
1142     /**
1143      * @dev Mints `tokenId` and transfers it to `to`.
1144      *
1145      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1146      *
1147      * Requirements:
1148      *
1149      * - `tokenId` must not exist.
1150      * - `to` cannot be the zero address.
1151      *
1152      * Emits a {Transfer} event.
1153      */
1154     function _mint(address to, uint256 tokenId) internal virtual {
1155         require(to != address(0), "ERC721: mint to the zero address");
1156         require(!_exists(tokenId), "ERC721: token already minted");
1157 
1158         _beforeTokenTransfer(address(0), to, tokenId);
1159 
1160         _balances[to] += 1;
1161         _owners[tokenId] = to;
1162 
1163         emit Transfer(address(0), to, tokenId);
1164     }
1165 
1166     /**
1167      * @dev Destroys `tokenId`.
1168      * The approval is cleared when the token is burned.
1169      *
1170      * Requirements:
1171      *
1172      * - `tokenId` must exist.
1173      *
1174      * Emits a {Transfer} event.
1175      */
1176     function _burn(uint256 tokenId) internal virtual {
1177         address owner = ERC721.ownerOf(tokenId);
1178 
1179         _beforeTokenTransfer(owner, address(0), tokenId);
1180 
1181         // Clear approvals
1182         _approve(address(0), tokenId);
1183 
1184         _balances[owner] -= 1;
1185         delete _owners[tokenId];
1186 
1187         emit Transfer(owner, address(0), tokenId);
1188     }
1189 
1190     /**
1191      * @dev Transfers `tokenId` from `from` to `to`.
1192      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1193      *
1194      * Requirements:
1195      *
1196      * - `to` cannot be the zero address.
1197      * - `tokenId` token must be owned by `from`.
1198      *
1199      * Emits a {Transfer} event.
1200      */
1201     function _transfer(
1202         address from,
1203         address to,
1204         uint256 tokenId
1205     ) internal virtual {
1206         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1207         require(to != address(0), "ERC721: transfer to the zero address");
1208 
1209         _beforeTokenTransfer(from, to, tokenId);
1210 
1211         // Clear approvals from the previous owner
1212         _approve(address(0), tokenId);
1213 
1214         _balances[from] -= 1;
1215         _balances[to] += 1;
1216         _owners[tokenId] = to;
1217 
1218         emit Transfer(from, to, tokenId);
1219     }
1220 
1221     /**
1222      * @dev Approve `to` to operate on `tokenId`
1223      *
1224      * Emits a {Approval} event.
1225      */
1226     function _approve(address to, uint256 tokenId) internal virtual {
1227         _tokenApprovals[tokenId] = to;
1228         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1229     }
1230 
1231     /**
1232      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1233      * The call is not executed if the target address is not a contract.
1234      *
1235      * @param from address representing the previous owner of the given token ID
1236      * @param to target address that will receive the tokens
1237      * @param tokenId uint256 ID of the token to be transferred
1238      * @param _data bytes optional data to send along with the call
1239      * @return bool whether the call correctly returned the expected magic value
1240      */
1241     function _checkOnERC721Received(
1242         address from,
1243         address to,
1244         uint256 tokenId,
1245         bytes memory _data
1246     ) private returns (bool) {
1247         if (to.isContract()) {
1248             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1249                 return retval == IERC721Receiver.onERC721Received.selector;
1250             } catch (bytes memory reason) {
1251                 if (reason.length == 0) {
1252                     revert("ERC721: transfer to non ERC721Receiver implementer");
1253                 } else {
1254                     assembly {
1255                         revert(add(32, reason), mload(reason))
1256                     }
1257                 }
1258             }
1259         } else {
1260             return true;
1261         }
1262     }
1263 
1264     /**
1265      * @dev Hook that is called before any token transfer. This includes minting
1266      * and burning.
1267      *
1268      * Calling conditions:
1269      *
1270      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1271      * transferred to `to`.
1272      * - When `from` is zero, `tokenId` will be minted for `to`.
1273      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1274      * - `from` and `to` are never both zero.
1275      *
1276      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1277      */
1278     function _beforeTokenTransfer(
1279         address from,
1280         address to,
1281         uint256 tokenId
1282     ) internal virtual {}
1283 }
1284 
1285 // File: node_modules\@openzeppelin\contracts\token\ERC721\extensions\IERC721Enumerable.sol
1286 
1287 
1288 
1289 pragma solidity ^0.8.0;
1290 
1291 
1292 /**
1293  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1294  * @dev See https://eips.ethereum.org/EIPS/eip-721
1295  */
1296 interface IERC721Enumerable is IERC721 {
1297     /**
1298      * @dev Returns the total amount of tokens stored by the contract.
1299      */
1300     function totalSupply() external view returns (uint256);
1301 
1302     /**
1303      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1304      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1305      */
1306     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1307 
1308     /**
1309      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1310      * Use along with {totalSupply} to enumerate all tokens.
1311      */
1312     function tokenByIndex(uint256 index) external view returns (uint256);
1313 }
1314 
1315 // File: @openzeppelin\contracts\token\ERC721\extensions\ERC721Enumerable.sol
1316 
1317 
1318 
1319 pragma solidity ^0.8.0;
1320 
1321 
1322 
1323 /**
1324  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1325  * enumerability of all the token ids in the contract as well as all token ids owned by each
1326  * account.
1327  */
1328 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1329     // Mapping from owner to list of owned token IDs
1330     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1331 
1332     // Mapping from token ID to index of the owner tokens list
1333     mapping(uint256 => uint256) private _ownedTokensIndex;
1334 
1335     // Array with all token ids, used for enumeration
1336     uint256[] private _allTokens;
1337 
1338     // Mapping from token id to position in the allTokens array
1339     mapping(uint256 => uint256) private _allTokensIndex;
1340 
1341     /**
1342      * @dev See {IERC165-supportsInterface}.
1343      */
1344     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1345         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1346     }
1347 
1348     /**
1349      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1350      */
1351     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1352         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1353         return _ownedTokens[owner][index];
1354     }
1355 
1356     /**
1357      * @dev See {IERC721Enumerable-totalSupply}.
1358      */
1359     function totalSupply() public view virtual override returns (uint256) {
1360         return _allTokens.length;
1361     }
1362 
1363     /**
1364      * @dev See {IERC721Enumerable-tokenByIndex}.
1365      */
1366     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1367         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1368         return _allTokens[index];
1369     }
1370 
1371     /**
1372      * @dev Hook that is called before any token transfer. This includes minting
1373      * and burning.
1374      *
1375      * Calling conditions:
1376      *
1377      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1378      * transferred to `to`.
1379      * - When `from` is zero, `tokenId` will be minted for `to`.
1380      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1381      * - `from` cannot be the zero address.
1382      * - `to` cannot be the zero address.
1383      *
1384      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1385      */
1386     function _beforeTokenTransfer(
1387         address from,
1388         address to,
1389         uint256 tokenId
1390     ) internal virtual override {
1391         super._beforeTokenTransfer(from, to, tokenId);
1392 
1393         if (from == address(0)) {
1394             _addTokenToAllTokensEnumeration(tokenId);
1395         } else if (from != to) {
1396             _removeTokenFromOwnerEnumeration(from, tokenId);
1397         }
1398         if (to == address(0)) {
1399             _removeTokenFromAllTokensEnumeration(tokenId);
1400         } else if (to != from) {
1401             _addTokenToOwnerEnumeration(to, tokenId);
1402         }
1403     }
1404 
1405     /**
1406      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1407      * @param to address representing the new owner of the given token ID
1408      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1409      */
1410     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1411         uint256 length = ERC721.balanceOf(to);
1412         _ownedTokens[to][length] = tokenId;
1413         _ownedTokensIndex[tokenId] = length;
1414     }
1415 
1416     /**
1417      * @dev Private function to add a token to this extension's token tracking data structures.
1418      * @param tokenId uint256 ID of the token to be added to the tokens list
1419      */
1420     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1421         _allTokensIndex[tokenId] = _allTokens.length;
1422         _allTokens.push(tokenId);
1423     }
1424 
1425     /**
1426      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1427      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1428      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1429      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1430      * @param from address representing the previous owner of the given token ID
1431      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1432      */
1433     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1434         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1435         // then delete the last slot (swap and pop).
1436 
1437         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1438         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1439 
1440         // When the token to delete is the last token, the swap operation is unnecessary
1441         if (tokenIndex != lastTokenIndex) {
1442             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1443 
1444             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1445             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1446         }
1447 
1448         // This also deletes the contents at the last position of the array
1449         delete _ownedTokensIndex[tokenId];
1450         delete _ownedTokens[from][lastTokenIndex];
1451     }
1452 
1453     /**
1454      * @dev Private function to remove a token from this extension's token tracking data structures.
1455      * This has O(1) time complexity, but alters the order of the _allTokens array.
1456      * @param tokenId uint256 ID of the token to be removed from the tokens list
1457      */
1458     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1459         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1460         // then delete the last slot (swap and pop).
1461 
1462         uint256 lastTokenIndex = _allTokens.length - 1;
1463         uint256 tokenIndex = _allTokensIndex[tokenId];
1464 
1465         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1466         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1467         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1468         uint256 lastTokenId = _allTokens[lastTokenIndex];
1469 
1470         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1471         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1472 
1473         // This also deletes the contents at the last position of the array
1474         delete _allTokensIndex[tokenId];
1475         _allTokens.pop();
1476     }
1477 }
1478 
1479 // File: contracts\SafeMathUint.sol
1480 
1481 
1482 
1483 pragma solidity ^0.8.0;
1484 /**
1485  * @title SafeMathUint
1486  * @dev Math operations with safety checks that revert on error
1487  */
1488 library SafeMathUint {
1489   function toInt256Safe(uint256 a) internal pure returns (int256) {
1490     int256 b = int256(a);
1491     require(b >= 0);
1492     return b;
1493   }
1494 }
1495 
1496 // File: contracts\TraitsofNobody.sol
1497 
1498 
1499 
1500 pragma solidity ^0.8.0;
1501 pragma experimental ABIEncoderV2;
1502 
1503 
1504 contract TraitsofNobody {
1505   struct Trait {
1506     string id;
1507     uint score;
1508   }
1509 
1510   uint constant internal maxRarityScore = 100;
1511   uint internal nonce = 3210;
1512   mapping (string => bool) public foundDNAs;
1513 
1514   Trait[][] internal traitTable;
1515   Trait[12]  internal xs;
1516   Trait[8]  internal head;
1517   Trait[12]  internal mask;
1518   Trait[9] internal lfeye;
1519   Trait[9] internal rteye;
1520   Trait[9]  internal mouth;
1521   Trait[4]  internal bg;
1522 
1523   constructor() {
1524     _setTraitTable();
1525   }
1526 
1527   function _getNobody(uint _salt) internal returns (string memory) {
1528     while (true) {
1529       string memory id = "";
1530       for (uint i=0; i<traitTable.length-1; i++) {
1531         Trait[] memory traitPool = traitTable[i];
1532         string memory traitId = _findTraits(traitPool, _salt);
1533         id = string(abi.encodePacked(id, traitId));
1534       }
1535       if (foundDNAs[id] == false) {
1536         foundDNAs[id] = true;
1537         Trait[] memory traitPool = traitTable[traitTable.length-1];
1538         string memory traitId = _findTraits(traitPool, _salt);
1539         id = string(abi.encodePacked(id, traitId));
1540         return id;
1541       }
1542 
1543     }
1544   }
1545 
1546   function _findTraits(Trait[] memory _traits, uint _salt) internal returns (string memory) {
1547     uint r = _random(_salt, maxRarityScore);
1548     string memory foundTrait;
1549     uint found;
1550     for (uint i=0; i<_traits.length; i++) {
1551       if (_traits[i].score <= r) {
1552         if (found == 0) {
1553           foundTrait = _traits[i].id;
1554           found = 1;
1555         }else{
1556           if (_random(_salt, 2) > 0) {
1557             foundTrait = _traits[i].id;
1558           }
1559         }
1560       }
1561     }
1562     return foundTrait;
1563   }
1564 
1565   function _setTraitTable() internal {
1566 
1567     rteye[0] = Trait("0", 0);
1568     rteye[1] = Trait("1", 20);
1569     rteye[2] = Trait("2", 40);
1570     rteye[3] = Trait("3", 50);
1571     rteye[4] = Trait("4", 60);
1572     rteye[5] = Trait("5", 70);
1573     rteye[6] = Trait("6", 80);
1574     rteye[7] = Trait("7", 90);
1575     rteye[8] = Trait("8", 95);
1576 
1577     head[0] = Trait("0", 0);
1578     head[1] = Trait("1", 15);
1579     head[2] = Trait("2", 25);
1580     head[3] = Trait("3", 35);
1581     head[4] = Trait("4", 40);
1582     head[5] = Trait("5", 50);
1583     head[6] = Trait("6", 75);
1584     head[7] = Trait("7", 90);
1585    
1586     mask[0] = Trait("0", 0);
1587     mask[1] = Trait("1", 10);
1588     mask[2] = Trait("2", 20);
1589     mask[3] = Trait("3", 30);
1590     mask[4] = Trait("4", 40);
1591     mask[5] = Trait("5", 50);
1592     mask[6] = Trait("6", 50);
1593     mask[7] = Trait("7", 50);
1594     mask[8] = Trait("8", 50);
1595     mask[9] = Trait("9", 50);
1596     mask[10] = Trait("a", 90);
1597     mask[11] = Trait("b", 95);
1598 
1599     xs[0] = Trait("0", 0);
1600     xs[1] = Trait("1", 5);
1601     xs[2] = Trait("2", 10);
1602     xs[3] = Trait("3", 25);
1603     xs[4] = Trait("4", 40);
1604     xs[5] = Trait("5", 50);
1605     xs[6] = Trait("6", 55);
1606     xs[7] = Trait("7", 60);
1607     xs[8] = Trait("8", 70);
1608     xs[9] = Trait("9", 80);
1609     xs[10] = Trait("a", 90);
1610     xs[11] = Trait("b", 95);
1611 
1612     mouth[0] = Trait("0", 0);
1613     mouth[1] = Trait("1", 20);
1614     mouth[2] = Trait("2", 40);
1615     mouth[3] = Trait("3", 50);
1616     mouth[4] = Trait("4", 60);
1617     mouth[5] = Trait("5", 70);
1618     mouth[6] = Trait("6", 80);
1619     mouth[7] = Trait("7", 90);
1620     mouth[8] = Trait("8", 95);
1621 
1622     lfeye[0] = Trait("0", 0);
1623     lfeye[1] = Trait("1", 10);
1624     lfeye[2] = Trait("2", 20);
1625     lfeye[3] = Trait("3", 30);
1626     lfeye[4] = Trait("4", 40);
1627     lfeye[5] = Trait("5", 50);
1628     lfeye[6] = Trait("6", 60);
1629     lfeye[7] = Trait("7", 80);
1630     lfeye[8] = Trait("8", 90);
1631 
1632     bg[0] = Trait("0", 0);
1633     bg[1] = Trait("1", 50);
1634     bg[2] = Trait("2", 75);
1635     bg[3] = Trait("3", 90);
1636 
1637     traitTable.push(rteye);
1638     traitTable.push(head);
1639     traitTable.push(mask);
1640     traitTable.push(xs);
1641     traitTable.push(mouth);
1642     traitTable.push(lfeye);
1643     traitTable.push(bg);
1644   }
1645 
1646 
1647   function _random(uint _salt, uint _limit) internal returns (uint) {
1648     uint r = (uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce, _salt)))) % _limit;
1649     nonce++;
1650     return r;
1651   }
1652 
1653 
1654   function _substring(string memory str, uint startIndex, uint endIndex) internal pure returns (string memory) {
1655     bytes memory strBytes = bytes(str);
1656     bytes memory result = new bytes(endIndex-startIndex);
1657     for(uint i = startIndex; i < endIndex; i++) {
1658         result[i-startIndex] = strBytes[i];
1659     }
1660     return string(result);
1661   }
1662 
1663 }
1664 
1665 // File: contracts\nobody.sol
1666 
1667 // SPDX-License-Identifier: UNLICENSED
1668 
1669 //             ¸ ..
1670 //           « *‡ ‰  ›
1671 //             ª ¨ ™
1672 //        _--- -- -- ---_ 
1673 //       /   ¸ ¸ ¸       \       ¸    
1674 //      ¦|  [  X ]  (  •}|¦      º±_
1675 //      ¦|            ¨¨¨|¦      ”\\ 
1676 //       \   =# # # #=   /                
1677 //        ¯--- -- -- ---¯ 
1678 //
1679 //      _.    _.           ¦|                      |¦
1680 //      _|\\  _|           ¦|                      |¦   _.   _. 
1681 //      _| \\ _|   //¨¸¨\  ¦|ˆˆ¸ˆ\   //¨¸¨\   /ˆ¸ˆˆ|¦   _|   _|
1682 //      _|  \\_|   \____/   \\___/   \____/   \____//   _|____|
1683 //                                                            |
1684 //                                                        _| _|
1685 
1686 pragma solidity ^0.8.0;
1687 
1688 interface theDudes
1689 {
1690     function ownerOf (uint256 tokenid) external view returns (address);
1691     function dudes (uint256 tokenid) external view returns (string memory);
1692     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1693 }
1694 
1695 contract Nobody is ERC721Enumerable, TraitsofNobody, Ownable {
1696   using SafeMath for uint256;
1697   using SafeMath for uint8;
1698   using SafeMathUint for uint256;
1699 
1700   uint public maxNobody = 3210;
1701   uint public maxNobodyPerPurchase = 10;
1702   uint256 public price = 30000000000000000; // 0.030 Ether
1703 
1704   bool public isSaleActive = false;
1705   bool public isClaimActive = false;
1706   string public baseURI;
1707   
1708   mapping(uint256 => bool) public claimedTokenIds; //the Dudes tokenId
1709   mapping (uint => string) public nobody;
1710 
1711   address public thedudesaddress = 0xB0cf7Da8dc482997525BE8488B9caD4F44315422; 
1712 
1713   theDudes thedudescontract = theDudes(thedudesaddress);  
1714     
1715   address public creator = 0x7ddD43C63aa73CDE4c5aa6b5De5D9681882D88f8; 
1716 
1717   constructor (uint _maxNobody, uint _maxNobodyPerPurchase ) ERC721("nobody", "nobody") {
1718     maxNobody = _maxNobody;
1719     maxNobodyPerPurchase = _maxNobodyPerPurchase;
1720     _mint(creator, 1, 385906);
1721   }
1722 
1723   function claimAll(address _owner) public {
1724     require(isClaimActive, "Claim is not active yet.");
1725     require(!allClaimed(_owner), "All your tokens are claimed.");
1726     int256[] memory tokenIds = claimableOf(_owner);
1727     for (uint256 i = 0; i < tokenIds.length; i++) {
1728       if (tokenIds[i] != -1) {
1729         claim(uint256(tokenIds[i]));
1730       }
1731     }
1732   }
1733 
1734   function claim(uint256 _tokenId) public {
1735     require(isClaimActive, "Claim is not active yet.");
1736     require(!claimedTokenIds[_tokenId], "This token is already minted.");
1737     require(thedudescontract.ownerOf(_tokenId) == msg.sender, "Not the owner of this dudes.");
1738     string memory thedudesdna = thedudescontract.dudes(_tokenId);
1739     claimedTokenIds[_tokenId] = true;
1740     _claim(msg.sender, thedudesdna);
1741   }
1742 
1743   function _claim(address _to, string memory thedudesdna) internal {
1744       uint256 mintIndex = totalSupply();
1745           if (totalSupply() < maxNobody) {
1746                 string memory nobodyid = string(abi.encodePacked(thedudesdna , _substring(thedudesdna,0,1)));
1747                 nobody[mintIndex] = nobodyid;
1748                 //foundDNAs[nobodyid] = true;
1749                 _safeMint(_to, mintIndex);
1750             }
1751   }
1752 
1753  function claimableOf(address _owner) public view returns (int256[] memory) {
1754     uint256[] memory tokenIds = thedudescontract.tokensOfOwner(_owner);
1755     int256[] memory claimableTokenIds = new int256[](tokenIds.length);
1756     uint256 index = 0;
1757     for (uint256 i = 0; i < tokenIds.length; i++) {
1758       uint256 tokenId = tokenIds[i];
1759       claimableTokenIds[i] = -1;
1760       if (thedudescontract.ownerOf(tokenId) == _owner) {
1761         if (!claimedTokenIds[tokenId]) {
1762           claimableTokenIds[index] = tokenId.toInt256Safe();
1763           index++;
1764         }
1765       }
1766     }
1767     return claimableTokenIds;
1768   }
1769 
1770   function allClaimed(address _owner) public view returns (bool) {
1771     int256[] memory tokenIds = claimableOf(_owner);
1772     bool allClaimed = true;
1773     for (uint256 i = 0; i < tokenIds.length; i++) {
1774       if (tokenIds[i] != -1) {
1775         allClaimed = false;
1776       }
1777     }
1778     return allClaimed;
1779   }
1780 
1781   function mint(uint256 _numNobody, uint _salt) public payable {
1782     require(isSaleActive, "Sale is not active!" );
1783     require(_numNobody > 0 && _numNobody <= maxNobodyPerPurchase, 'Max is 10 at a time');
1784     require(totalSupply().add(_numNobody) <= maxNobody, "Sorry too many nobody!");
1785     require(msg.value >= price.mul(_numNobody), "Ether value sent is not correct!");
1786 
1787     _mint(msg.sender, _numNobody, _salt);
1788   }
1789 
1790   function tokensOfOwner(address _owner) public view returns (uint256[] memory) {
1791     uint256 tokenCount = balanceOf(_owner);
1792     if (tokenCount == 0) {
1793       return new uint256[](0);
1794     } else {
1795       uint256[] memory result = new uint256[](tokenCount);
1796       uint256 index;
1797       for (index = 0; index < tokenCount; index++) {
1798         result[index] = tokenOfOwnerByIndex(_owner, index);
1799       }
1800       return result;
1801     }
1802   }
1803 
1804   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1805     require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1806     return string(abi.encodePacked(_baseURI(), "/", nobody[_tokenId]));
1807   }
1808   
1809   function _mint(address _to, uint256 _numNobody, uint _salt) internal {
1810     for (uint256 i = 0; i < _numNobody; i++) {
1811       uint256 mintIndex = totalSupply();
1812 
1813           if (totalSupply() < maxNobody) {
1814                 string memory nobodyid = _getNobody(_salt * i);
1815                 nobody[mintIndex] = nobodyid;
1816                 _safeMint(_to, mintIndex);
1817             }
1818     }
1819   }
1820 
1821   function _baseURI() internal view virtual override returns (string memory) {
1822     return baseURI;
1823   }
1824 
1825   //owner only
1826 
1827   function flipSaleState() public onlyOwner {
1828         isSaleActive = !isSaleActive;
1829   }
1830 
1831   function flipClaimState() public onlyOwner {
1832         isClaimActive = !isClaimActive;
1833   }
1834 
1835   function setPrice(uint256 _newPrice) public onlyOwner {
1836       price = _newPrice;
1837   }
1838   
1839   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1840       baseURI = _newBaseURI;
1841   }
1842 
1843   function withdraw() public onlyOwner {
1844       uint256 balance = address(this).balance;
1845       payable(msg.sender).transfer(balance);
1846   }
1847 
1848   function reserveNobody(uint256 _numNobody, uint256 _salt) public onlyOwner {        
1849         _mint(msg.sender, _numNobody, _salt);
1850   }
1851   
1852   function reservetheudes() public onlyOwner{
1853     for (uint256 i = 0; i < 512; i++) {
1854       string memory nobodyid = thedudescontract.dudes(i);
1855       if (foundDNAs[nobodyid] == false) {
1856           foundDNAs[nobodyid] = true;
1857         }
1858       }
1859   }
1860 
1861 
1862 }