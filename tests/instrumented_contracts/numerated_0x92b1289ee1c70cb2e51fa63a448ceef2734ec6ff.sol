1 // File: contracts/INuclearAcidVault.sol
2 
3 
4 
5 pragma solidity 0.8.7;
6 
7 interface INuclearAcidVault {
8   function balanceOf(address account, uint256 id) external view returns (uint256 balance);
9   function burnPotionForAddress(uint256 typeId, address burnTokenAddress) external;
10 }
11 // File: contracts/IFreshApesToken.sol
12 
13 
14 
15 pragma solidity 0.8.7;
16 
17 interface IFreshApesToken {
18   function balanceOf(address owner) external view returns (uint256 balance);
19   function ownerOf(uint256 tokenId) external view returns (address owner);
20   function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
21   function totalSupply() external view returns (uint256);
22   function walletOfOwner(address owner) external view returns (uint256[] memory tokenIds);
23 }
24 
25 
26 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
27 
28 
29 
30 pragma solidity ^0.8.0;
31 
32 // CAUTION
33 // This version of SafeMath should only be used with Solidity 0.8 or later,
34 // because it relies on the compiler's built in overflow checks.
35 
36 /**
37  * @dev Wrappers over Solidity's arithmetic operations.
38  *
39  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
40  * now has built in overflow checking.
41  */
42 library SafeMath {
43     /**
44      * @dev Returns the addition of two unsigned integers, with an overflow flag.
45      *
46      * _Available since v3.4._
47      */
48     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
49         unchecked {
50             uint256 c = a + b;
51             if (c < a) return (false, 0);
52             return (true, c);
53         }
54     }
55 
56     /**
57      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
58      *
59      * _Available since v3.4._
60      */
61     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
62         unchecked {
63             if (b > a) return (false, 0);
64             return (true, a - b);
65         }
66     }
67 
68     /**
69      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
70      *
71      * _Available since v3.4._
72      */
73     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
74         unchecked {
75             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
76             // benefit is lost if 'b' is also tested.
77             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
78             if (a == 0) return (true, 0);
79             uint256 c = a * b;
80             if (c / a != b) return (false, 0);
81             return (true, c);
82         }
83     }
84 
85     /**
86      * @dev Returns the division of two unsigned integers, with a division by zero flag.
87      *
88      * _Available since v3.4._
89      */
90     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
91         unchecked {
92             if (b == 0) return (false, 0);
93             return (true, a / b);
94         }
95     }
96 
97     /**
98      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
99      *
100      * _Available since v3.4._
101      */
102     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
103         unchecked {
104             if (b == 0) return (false, 0);
105             return (true, a % b);
106         }
107     }
108 
109     /**
110      * @dev Returns the addition of two unsigned integers, reverting on
111      * overflow.
112      *
113      * Counterpart to Solidity's `+` operator.
114      *
115      * Requirements:
116      *
117      * - Addition cannot overflow.
118      */
119     function add(uint256 a, uint256 b) internal pure returns (uint256) {
120         return a + b;
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      *
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134         return a - b;
135     }
136 
137     /**
138      * @dev Returns the multiplication of two unsigned integers, reverting on
139      * overflow.
140      *
141      * Counterpart to Solidity's `*` operator.
142      *
143      * Requirements:
144      *
145      * - Multiplication cannot overflow.
146      */
147     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
148         return a * b;
149     }
150 
151     /**
152      * @dev Returns the integer division of two unsigned integers, reverting on
153      * division by zero. The result is rounded towards zero.
154      *
155      * Counterpart to Solidity's `/` operator.
156      *
157      * Requirements:
158      *
159      * - The divisor cannot be zero.
160      */
161     function div(uint256 a, uint256 b) internal pure returns (uint256) {
162         return a / b;
163     }
164 
165     /**
166      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
167      * reverting when dividing by zero.
168      *
169      * Counterpart to Solidity's `%` operator. This function uses a `revert`
170      * opcode (which leaves remaining gas untouched) while Solidity uses an
171      * invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      *
175      * - The divisor cannot be zero.
176      */
177     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
178         return a % b;
179     }
180 
181     /**
182      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
183      * overflow (when the result is negative).
184      *
185      * CAUTION: This function is deprecated because it requires allocating memory for the error
186      * message unnecessarily. For custom revert reasons use {trySub}.
187      *
188      * Counterpart to Solidity's `-` operator.
189      *
190      * Requirements:
191      *
192      * - Subtraction cannot overflow.
193      */
194     function sub(
195         uint256 a,
196         uint256 b,
197         string memory errorMessage
198     ) internal pure returns (uint256) {
199         unchecked {
200             require(b <= a, errorMessage);
201             return a - b;
202         }
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
207      * division by zero. The result is rounded towards zero.
208      *
209      * Counterpart to Solidity's `/` operator. Note: this function uses a
210      * `revert` opcode (which leaves remaining gas untouched) while Solidity
211      * uses an invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function div(
218         uint256 a,
219         uint256 b,
220         string memory errorMessage
221     ) internal pure returns (uint256) {
222         unchecked {
223             require(b > 0, errorMessage);
224             return a / b;
225         }
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230      * reverting with custom message when dividing by zero.
231      *
232      * CAUTION: This function is deprecated because it requires allocating memory for the error
233      * message unnecessarily. For custom revert reasons use {tryMod}.
234      *
235      * Counterpart to Solidity's `%` operator. This function uses a `revert`
236      * opcode (which leaves remaining gas untouched) while Solidity uses an
237      * invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function mod(
244         uint256 a,
245         uint256 b,
246         string memory errorMessage
247     ) internal pure returns (uint256) {
248         unchecked {
249             require(b > 0, errorMessage);
250             return a % b;
251         }
252     }
253 }
254 
255 // File: @openzeppelin/contracts/utils/Strings.sol
256 
257 
258 
259 pragma solidity ^0.8.0;
260 
261 /**
262  * @dev String operations.
263  */
264 library Strings {
265     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
266 
267     /**
268      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
269      */
270     function toString(uint256 value) internal pure returns (string memory) {
271         // Inspired by OraclizeAPI's implementation - MIT licence
272         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
273 
274         if (value == 0) {
275             return "0";
276         }
277         uint256 temp = value;
278         uint256 digits;
279         while (temp != 0) {
280             digits++;
281             temp /= 10;
282         }
283         bytes memory buffer = new bytes(digits);
284         while (value != 0) {
285             digits -= 1;
286             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
287             value /= 10;
288         }
289         return string(buffer);
290     }
291 
292     /**
293      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
294      */
295     function toHexString(uint256 value) internal pure returns (string memory) {
296         if (value == 0) {
297             return "0x00";
298         }
299         uint256 temp = value;
300         uint256 length = 0;
301         while (temp != 0) {
302             length++;
303             temp >>= 8;
304         }
305         return toHexString(value, length);
306     }
307 
308     /**
309      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
310      */
311     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
312         bytes memory buffer = new bytes(2 * length + 2);
313         buffer[0] = "0";
314         buffer[1] = "x";
315         for (uint256 i = 2 * length + 1; i > 1; --i) {
316             buffer[i] = _HEX_SYMBOLS[value & 0xf];
317             value >>= 4;
318         }
319         require(value == 0, "Strings: hex length insufficient");
320         return string(buffer);
321     }
322 }
323 
324 // File: @openzeppelin/contracts/utils/Context.sol
325 
326 
327 
328 pragma solidity ^0.8.0;
329 
330 /**
331  * @dev Provides information about the current execution context, including the
332  * sender of the transaction and its data. While these are generally available
333  * via msg.sender and msg.data, they should not be accessed in such a direct
334  * manner, since when dealing with meta-transactions the account sending and
335  * paying for execution may not be the actual sender (as far as an application
336  * is concerned).
337  *
338  * This contract is only required for intermediate, library-like contracts.
339  */
340 abstract contract Context {
341     function _msgSender() internal view virtual returns (address) {
342         return msg.sender;
343     }
344 
345     function _msgData() internal view virtual returns (bytes calldata) {
346         return msg.data;
347     }
348 }
349 
350 // File: @openzeppelin/contracts/access/Ownable.sol
351 
352 
353 
354 pragma solidity ^0.8.0;
355 
356 
357 /**
358  * @dev Contract module which provides a basic access control mechanism, where
359  * there is an account (an owner) that can be granted exclusive access to
360  * specific functions.
361  *
362  * By default, the owner account will be the one that deploys the contract. This
363  * can later be changed with {transferOwnership}.
364  *
365  * This module is used through inheritance. It will make available the modifier
366  * `onlyOwner`, which can be applied to your functions to restrict their use to
367  * the owner.
368  */
369 abstract contract Ownable is Context {
370     address private _owner;
371 
372     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
373 
374     /**
375      * @dev Initializes the contract setting the deployer as the initial owner.
376      */
377     constructor() {
378         _setOwner(_msgSender());
379     }
380 
381     /**
382      * @dev Returns the address of the current owner.
383      */
384     function owner() public view virtual returns (address) {
385         return _owner;
386     }
387 
388     /**
389      * @dev Throws if called by any account other than the owner.
390      */
391     modifier onlyOwner() {
392         require(owner() == _msgSender(), "Ownable: caller is not the owner");
393         _;
394     }
395 
396     /**
397      * @dev Leaves the contract without owner. It will not be possible to call
398      * `onlyOwner` functions anymore. Can only be called by the current owner.
399      *
400      * NOTE: Renouncing ownership will leave the contract without an owner,
401      * thereby removing any functionality that is only available to the owner.
402      */
403     function renounceOwnership() public virtual onlyOwner {
404         _setOwner(address(0));
405     }
406 
407     /**
408      * @dev Transfers ownership of the contract to a new account (`newOwner`).
409      * Can only be called by the current owner.
410      */
411     function transferOwnership(address newOwner) public virtual onlyOwner {
412         require(newOwner != address(0), "Ownable: new owner is the zero address");
413         _setOwner(newOwner);
414     }
415 
416     function _setOwner(address newOwner) private {
417         address oldOwner = _owner;
418         _owner = newOwner;
419         emit OwnershipTransferred(oldOwner, newOwner);
420     }
421 }
422 
423 // File: @openzeppelin/contracts/utils/Address.sol
424 
425 
426 
427 pragma solidity ^0.8.0;
428 
429 /**
430  * @dev Collection of functions related to the address type
431  */
432 library Address {
433     /**
434      * @dev Returns true if `account` is a contract.
435      *
436      * [IMPORTANT]
437      * ====
438      * It is unsafe to assume that an address for which this function returns
439      * false is an externally-owned account (EOA) and not a contract.
440      *
441      * Among others, `isContract` will return false for the following
442      * types of addresses:
443      *
444      *  - an externally-owned account
445      *  - a contract in construction
446      *  - an address where a contract will be created
447      *  - an address where a contract lived, but was destroyed
448      * ====
449      */
450     function isContract(address account) internal view returns (bool) {
451         // This method relies on extcodesize, which returns 0 for contracts in
452         // construction, since the code is only stored at the end of the
453         // constructor execution.
454 
455         uint256 size;
456         assembly {
457             size := extcodesize(account)
458         }
459         return size > 0;
460     }
461 
462     /**
463      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
464      * `recipient`, forwarding all available gas and reverting on errors.
465      *
466      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
467      * of certain opcodes, possibly making contracts go over the 2300 gas limit
468      * imposed by `transfer`, making them unable to receive funds via
469      * `transfer`. {sendValue} removes this limitation.
470      *
471      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
472      *
473      * IMPORTANT: because control is transferred to `recipient`, care must be
474      * taken to not create reentrancy vulnerabilities. Consider using
475      * {ReentrancyGuard} or the
476      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
477      */
478     function sendValue(address payable recipient, uint256 amount) internal {
479         require(address(this).balance >= amount, "Address: insufficient balance");
480 
481         (bool success, ) = recipient.call{value: amount}("");
482         require(success, "Address: unable to send value, recipient may have reverted");
483     }
484 
485     /**
486      * @dev Performs a Solidity function call using a low level `call`. A
487      * plain `call` is an unsafe replacement for a function call: use this
488      * function instead.
489      *
490      * If `target` reverts with a revert reason, it is bubbled up by this
491      * function (like regular Solidity function calls).
492      *
493      * Returns the raw returned data. To convert to the expected return value,
494      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
495      *
496      * Requirements:
497      *
498      * - `target` must be a contract.
499      * - calling `target` with `data` must not revert.
500      *
501      * _Available since v3.1._
502      */
503     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
504         return functionCall(target, data, "Address: low-level call failed");
505     }
506 
507     /**
508      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
509      * `errorMessage` as a fallback revert reason when `target` reverts.
510      *
511      * _Available since v3.1._
512      */
513     function functionCall(
514         address target,
515         bytes memory data,
516         string memory errorMessage
517     ) internal returns (bytes memory) {
518         return functionCallWithValue(target, data, 0, errorMessage);
519     }
520 
521     /**
522      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
523      * but also transferring `value` wei to `target`.
524      *
525      * Requirements:
526      *
527      * - the calling contract must have an ETH balance of at least `value`.
528      * - the called Solidity function must be `payable`.
529      *
530      * _Available since v3.1._
531      */
532     function functionCallWithValue(
533         address target,
534         bytes memory data,
535         uint256 value
536     ) internal returns (bytes memory) {
537         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
542      * with `errorMessage` as a fallback revert reason when `target` reverts.
543      *
544      * _Available since v3.1._
545      */
546     function functionCallWithValue(
547         address target,
548         bytes memory data,
549         uint256 value,
550         string memory errorMessage
551     ) internal returns (bytes memory) {
552         require(address(this).balance >= value, "Address: insufficient balance for call");
553         require(isContract(target), "Address: call to non-contract");
554 
555         (bool success, bytes memory returndata) = target.call{value: value}(data);
556         return verifyCallResult(success, returndata, errorMessage);
557     }
558 
559     /**
560      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
561      * but performing a static call.
562      *
563      * _Available since v3.3._
564      */
565     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
566         return functionStaticCall(target, data, "Address: low-level static call failed");
567     }
568 
569     /**
570      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
571      * but performing a static call.
572      *
573      * _Available since v3.3._
574      */
575     function functionStaticCall(
576         address target,
577         bytes memory data,
578         string memory errorMessage
579     ) internal view returns (bytes memory) {
580         require(isContract(target), "Address: static call to non-contract");
581 
582         (bool success, bytes memory returndata) = target.staticcall(data);
583         return verifyCallResult(success, returndata, errorMessage);
584     }
585 
586     /**
587      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
588      * but performing a delegate call.
589      *
590      * _Available since v3.4._
591      */
592     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
593         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
594     }
595 
596     /**
597      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
598      * but performing a delegate call.
599      *
600      * _Available since v3.4._
601      */
602     function functionDelegateCall(
603         address target,
604         bytes memory data,
605         string memory errorMessage
606     ) internal returns (bytes memory) {
607         require(isContract(target), "Address: delegate call to non-contract");
608 
609         (bool success, bytes memory returndata) = target.delegatecall(data);
610         return verifyCallResult(success, returndata, errorMessage);
611     }
612 
613     /**
614      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
615      * revert reason using the provided one.
616      *
617      * _Available since v4.3._
618      */
619     function verifyCallResult(
620         bool success,
621         bytes memory returndata,
622         string memory errorMessage
623     ) internal pure returns (bytes memory) {
624         if (success) {
625             return returndata;
626         } else {
627             // Look for revert reason and bubble it up if present
628             if (returndata.length > 0) {
629                 // The easiest way to bubble the revert reason is using memory via assembly
630 
631                 assembly {
632                     let returndata_size := mload(returndata)
633                     revert(add(32, returndata), returndata_size)
634                 }
635             } else {
636                 revert(errorMessage);
637             }
638         }
639     }
640 }
641 
642 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
643 
644 
645 
646 pragma solidity ^0.8.0;
647 
648 /**
649  * @title ERC721 token receiver interface
650  * @dev Interface for any contract that wants to support safeTransfers
651  * from ERC721 asset contracts.
652  */
653 interface IERC721Receiver {
654     /**
655      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
656      * by `operator` from `from`, this function is called.
657      *
658      * It must return its Solidity selector to confirm the token transfer.
659      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
660      *
661      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
662      */
663     function onERC721Received(
664         address operator,
665         address from,
666         uint256 tokenId,
667         bytes calldata data
668     ) external returns (bytes4);
669 }
670 
671 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
672 
673 
674 
675 pragma solidity ^0.8.0;
676 
677 /**
678  * @dev Interface of the ERC165 standard, as defined in the
679  * https://eips.ethereum.org/EIPS/eip-165[EIP].
680  *
681  * Implementers can declare support of contract interfaces, which can then be
682  * queried by others ({ERC165Checker}).
683  *
684  * For an implementation, see {ERC165}.
685  */
686 interface IERC165 {
687     /**
688      * @dev Returns true if this contract implements the interface defined by
689      * `interfaceId`. See the corresponding
690      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
691      * to learn more about how these ids are created.
692      *
693      * This function call must use less than 30 000 gas.
694      */
695     function supportsInterface(bytes4 interfaceId) external view returns (bool);
696 }
697 
698 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
699 
700 
701 
702 pragma solidity ^0.8.0;
703 
704 
705 /**
706  * @dev Implementation of the {IERC165} interface.
707  *
708  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
709  * for the additional interface id that will be supported. For example:
710  *
711  * ```solidity
712  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
713  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
714  * }
715  * ```
716  *
717  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
718  */
719 abstract contract ERC165 is IERC165 {
720     /**
721      * @dev See {IERC165-supportsInterface}.
722      */
723     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
724         return interfaceId == type(IERC165).interfaceId;
725     }
726 }
727 
728 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
729 
730 
731 
732 pragma solidity ^0.8.0;
733 
734 
735 /**
736  * @dev Required interface of an ERC721 compliant contract.
737  */
738 interface IERC721 is IERC165 {
739     /**
740      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
741      */
742     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
743 
744     /**
745      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
746      */
747     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
748 
749     /**
750      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
751      */
752     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
753 
754     /**
755      * @dev Returns the number of tokens in ``owner``'s account.
756      */
757     function balanceOf(address owner) external view returns (uint256 balance);
758 
759     /**
760      * @dev Returns the owner of the `tokenId` token.
761      *
762      * Requirements:
763      *
764      * - `tokenId` must exist.
765      */
766     function ownerOf(uint256 tokenId) external view returns (address owner);
767 
768     /**
769      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
770      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
771      *
772      * Requirements:
773      *
774      * - `from` cannot be the zero address.
775      * - `to` cannot be the zero address.
776      * - `tokenId` token must exist and be owned by `from`.
777      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
778      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
779      *
780      * Emits a {Transfer} event.
781      */
782     function safeTransferFrom(
783         address from,
784         address to,
785         uint256 tokenId
786     ) external;
787 
788     /**
789      * @dev Transfers `tokenId` token from `from` to `to`.
790      *
791      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
792      *
793      * Requirements:
794      *
795      * - `from` cannot be the zero address.
796      * - `to` cannot be the zero address.
797      * - `tokenId` token must be owned by `from`.
798      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
799      *
800      * Emits a {Transfer} event.
801      */
802     function transferFrom(
803         address from,
804         address to,
805         uint256 tokenId
806     ) external;
807 
808     /**
809      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
810      * The approval is cleared when the token is transferred.
811      *
812      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
813      *
814      * Requirements:
815      *
816      * - The caller must own the token or be an approved operator.
817      * - `tokenId` must exist.
818      *
819      * Emits an {Approval} event.
820      */
821     function approve(address to, uint256 tokenId) external;
822 
823     /**
824      * @dev Returns the account approved for `tokenId` token.
825      *
826      * Requirements:
827      *
828      * - `tokenId` must exist.
829      */
830     function getApproved(uint256 tokenId) external view returns (address operator);
831 
832     /**
833      * @dev Approve or remove `operator` as an operator for the caller.
834      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
835      *
836      * Requirements:
837      *
838      * - The `operator` cannot be the caller.
839      *
840      * Emits an {ApprovalForAll} event.
841      */
842     function setApprovalForAll(address operator, bool _approved) external;
843 
844     /**
845      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
846      *
847      * See {setApprovalForAll}
848      */
849     function isApprovedForAll(address owner, address operator) external view returns (bool);
850 
851     /**
852      * @dev Safely transfers `tokenId` token from `from` to `to`.
853      *
854      * Requirements:
855      *
856      * - `from` cannot be the zero address.
857      * - `to` cannot be the zero address.
858      * - `tokenId` token must exist and be owned by `from`.
859      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
860      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
861      *
862      * Emits a {Transfer} event.
863      */
864     function safeTransferFrom(
865         address from,
866         address to,
867         uint256 tokenId,
868         bytes calldata data
869     ) external;
870 }
871 
872 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
873 
874 
875 
876 pragma solidity ^0.8.0;
877 
878 
879 /**
880  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
881  * @dev See https://eips.ethereum.org/EIPS/eip-721
882  */
883 interface IERC721Enumerable is IERC721 {
884     /**
885      * @dev Returns the total amount of tokens stored by the contract.
886      */
887     function totalSupply() external view returns (uint256);
888 
889     /**
890      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
891      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
892      */
893     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
894 
895     /**
896      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
897      * Use along with {totalSupply} to enumerate all tokens.
898      */
899     function tokenByIndex(uint256 index) external view returns (uint256);
900 }
901 
902 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
903 
904 
905 
906 pragma solidity ^0.8.0;
907 
908 
909 /**
910  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
911  * @dev See https://eips.ethereum.org/EIPS/eip-721
912  */
913 interface IERC721Metadata is IERC721 {
914     /**
915      * @dev Returns the token collection name.
916      */
917     function name() external view returns (string memory);
918 
919     /**
920      * @dev Returns the token collection symbol.
921      */
922     function symbol() external view returns (string memory);
923 
924     /**
925      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
926      */
927     function tokenURI(uint256 tokenId) external view returns (string memory);
928 }
929 
930 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
931 
932 
933 
934 pragma solidity ^0.8.0;
935 
936 
937 
938 
939 
940 
941 
942 
943 /**
944  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
945  * the Metadata extension, but not including the Enumerable extension, which is available separately as
946  * {ERC721Enumerable}.
947  */
948 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
949     using Address for address;
950     using Strings for uint256;
951 
952     // Token name
953     string private _name;
954 
955     // Token symbol
956     string private _symbol;
957 
958     // Mapping from token ID to owner address
959     mapping(uint256 => address) private _owners;
960 
961     // Mapping owner address to token count
962     mapping(address => uint256) private _balances;
963 
964     // Mapping from token ID to approved address
965     mapping(uint256 => address) private _tokenApprovals;
966 
967     // Mapping from owner to operator approvals
968     mapping(address => mapping(address => bool)) private _operatorApprovals;
969 
970     /**
971      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
972      */
973     constructor(string memory name_, string memory symbol_) {
974         _name = name_;
975         _symbol = symbol_;
976     }
977 
978     /**
979      * @dev See {IERC165-supportsInterface}.
980      */
981     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
982         return
983             interfaceId == type(IERC721).interfaceId ||
984             interfaceId == type(IERC721Metadata).interfaceId ||
985             super.supportsInterface(interfaceId);
986     }
987 
988     /**
989      * @dev See {IERC721-balanceOf}.
990      */
991     function balanceOf(address owner) public view virtual override returns (uint256) {
992         require(owner != address(0), "ERC721: balance query for the zero address");
993         return _balances[owner];
994     }
995 
996     /**
997      * @dev See {IERC721-ownerOf}.
998      */
999     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1000         address owner = _owners[tokenId];
1001         require(owner != address(0), "ERC721: owner query for nonexistent token");
1002         return owner;
1003     }
1004 
1005     /**
1006      * @dev See {IERC721Metadata-name}.
1007      */
1008     function name() public view virtual override returns (string memory) {
1009         return _name;
1010     }
1011 
1012     /**
1013      * @dev See {IERC721Metadata-symbol}.
1014      */
1015     function symbol() public view virtual override returns (string memory) {
1016         return _symbol;
1017     }
1018 
1019     /**
1020      * @dev See {IERC721Metadata-tokenURI}.
1021      */
1022     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1023         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1024 
1025         string memory baseURI = _baseURI();
1026         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1027     }
1028 
1029     /**
1030      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1031      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1032      * by default, can be overriden in child contracts.
1033      */
1034     function _baseURI() internal view virtual returns (string memory) {
1035         return "";
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-approve}.
1040      */
1041     function approve(address to, uint256 tokenId) public virtual override {
1042         address owner = ERC721.ownerOf(tokenId);
1043         require(to != owner, "ERC721: approval to current owner");
1044 
1045         require(
1046             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1047             "ERC721: approve caller is not owner nor approved for all"
1048         );
1049 
1050         _approve(to, tokenId);
1051     }
1052 
1053     /**
1054      * @dev See {IERC721-getApproved}.
1055      */
1056     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1057         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1058 
1059         return _tokenApprovals[tokenId];
1060     }
1061 
1062     /**
1063      * @dev See {IERC721-setApprovalForAll}.
1064      */
1065     function setApprovalForAll(address operator, bool approved) public virtual override {
1066         require(operator != _msgSender(), "ERC721: approve to caller");
1067 
1068         _operatorApprovals[_msgSender()][operator] = approved;
1069         emit ApprovalForAll(_msgSender(), operator, approved);
1070     }
1071 
1072     /**
1073      * @dev See {IERC721-isApprovedForAll}.
1074      */
1075     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1076         return _operatorApprovals[owner][operator];
1077     }
1078 
1079     /**
1080      * @dev See {IERC721-transferFrom}.
1081      */
1082     function transferFrom(
1083         address from,
1084         address to,
1085         uint256 tokenId
1086     ) public virtual override {
1087         //solhint-disable-next-line max-line-length
1088         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1089 
1090         _transfer(from, to, tokenId);
1091     }
1092 
1093     /**
1094      * @dev See {IERC721-safeTransferFrom}.
1095      */
1096     function safeTransferFrom(
1097         address from,
1098         address to,
1099         uint256 tokenId
1100     ) public virtual override {
1101         safeTransferFrom(from, to, tokenId, "");
1102     }
1103 
1104     /**
1105      * @dev See {IERC721-safeTransferFrom}.
1106      */
1107     function safeTransferFrom(
1108         address from,
1109         address to,
1110         uint256 tokenId,
1111         bytes memory _data
1112     ) public virtual override {
1113         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1114         _safeTransfer(from, to, tokenId, _data);
1115     }
1116 
1117     /**
1118      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1119      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1120      *
1121      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1122      *
1123      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1124      * implement alternative mechanisms to perform token transfer, such as signature-based.
1125      *
1126      * Requirements:
1127      *
1128      * - `from` cannot be the zero address.
1129      * - `to` cannot be the zero address.
1130      * - `tokenId` token must exist and be owned by `from`.
1131      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1132      *
1133      * Emits a {Transfer} event.
1134      */
1135     function _safeTransfer(
1136         address from,
1137         address to,
1138         uint256 tokenId,
1139         bytes memory _data
1140     ) internal virtual {
1141         _transfer(from, to, tokenId);
1142         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1143     }
1144 
1145     /**
1146      * @dev Returns whether `tokenId` exists.
1147      *
1148      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1149      *
1150      * Tokens start existing when they are minted (`_mint`),
1151      * and stop existing when they are burned (`_burn`).
1152      */
1153     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1154         return _owners[tokenId] != address(0);
1155     }
1156 
1157     /**
1158      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1159      *
1160      * Requirements:
1161      *
1162      * - `tokenId` must exist.
1163      */
1164     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1165         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1166         address owner = ERC721.ownerOf(tokenId);
1167         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1168     }
1169 
1170     /**
1171      * @dev Safely mints `tokenId` and transfers it to `to`.
1172      *
1173      * Requirements:
1174      *
1175      * - `tokenId` must not exist.
1176      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1177      *
1178      * Emits a {Transfer} event.
1179      */
1180     function _safeMint(address to, uint256 tokenId) internal virtual {
1181         _safeMint(to, tokenId, "");
1182     }
1183 
1184     /**
1185      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1186      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1187      */
1188     function _safeMint(
1189         address to,
1190         uint256 tokenId,
1191         bytes memory _data
1192     ) internal virtual {
1193         _mint(to, tokenId);
1194         require(
1195             _checkOnERC721Received(address(0), to, tokenId, _data),
1196             "ERC721: transfer to non ERC721Receiver implementer"
1197         );
1198     }
1199 
1200     /**
1201      * @dev Mints `tokenId` and transfers it to `to`.
1202      *
1203      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1204      *
1205      * Requirements:
1206      *
1207      * - `tokenId` must not exist.
1208      * - `to` cannot be the zero address.
1209      *
1210      * Emits a {Transfer} event.
1211      */
1212     function _mint(address to, uint256 tokenId) internal virtual {
1213         require(to != address(0), "ERC721: mint to the zero address");
1214         require(!_exists(tokenId), "ERC721: token already minted");
1215 
1216         _beforeTokenTransfer(address(0), to, tokenId);
1217 
1218         _balances[to] += 1;
1219         _owners[tokenId] = to;
1220 
1221         emit Transfer(address(0), to, tokenId);
1222     }
1223 
1224     /**
1225      * @dev Destroys `tokenId`.
1226      * The approval is cleared when the token is burned.
1227      *
1228      * Requirements:
1229      *
1230      * - `tokenId` must exist.
1231      *
1232      * Emits a {Transfer} event.
1233      */
1234     function _burn(uint256 tokenId) internal virtual {
1235         address owner = ERC721.ownerOf(tokenId);
1236 
1237         _beforeTokenTransfer(owner, address(0), tokenId);
1238 
1239         // Clear approvals
1240         _approve(address(0), tokenId);
1241 
1242         _balances[owner] -= 1;
1243         delete _owners[tokenId];
1244 
1245         emit Transfer(owner, address(0), tokenId);
1246     }
1247 
1248     /**
1249      * @dev Transfers `tokenId` from `from` to `to`.
1250      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1251      *
1252      * Requirements:
1253      *
1254      * - `to` cannot be the zero address.
1255      * - `tokenId` token must be owned by `from`.
1256      *
1257      * Emits a {Transfer} event.
1258      */
1259     function _transfer(
1260         address from,
1261         address to,
1262         uint256 tokenId
1263     ) internal virtual {
1264         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1265         require(to != address(0), "ERC721: transfer to the zero address");
1266 
1267         _beforeTokenTransfer(from, to, tokenId);
1268 
1269         // Clear approvals from the previous owner
1270         _approve(address(0), tokenId);
1271 
1272         _balances[from] -= 1;
1273         _balances[to] += 1;
1274         _owners[tokenId] = to;
1275 
1276         emit Transfer(from, to, tokenId);
1277     }
1278 
1279     /**
1280      * @dev Approve `to` to operate on `tokenId`
1281      *
1282      * Emits a {Approval} event.
1283      */
1284     function _approve(address to, uint256 tokenId) internal virtual {
1285         _tokenApprovals[tokenId] = to;
1286         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1287     }
1288 
1289     /**
1290      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1291      * The call is not executed if the target address is not a contract.
1292      *
1293      * @param from address representing the previous owner of the given token ID
1294      * @param to target address that will receive the tokens
1295      * @param tokenId uint256 ID of the token to be transferred
1296      * @param _data bytes optional data to send along with the call
1297      * @return bool whether the call correctly returned the expected magic value
1298      */
1299     function _checkOnERC721Received(
1300         address from,
1301         address to,
1302         uint256 tokenId,
1303         bytes memory _data
1304     ) private returns (bool) {
1305         if (to.isContract()) {
1306             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1307                 return retval == IERC721Receiver.onERC721Received.selector;
1308             } catch (bytes memory reason) {
1309                 if (reason.length == 0) {
1310                     revert("ERC721: transfer to non ERC721Receiver implementer");
1311                 } else {
1312                     assembly {
1313                         revert(add(32, reason), mload(reason))
1314                     }
1315                 }
1316             }
1317         } else {
1318             return true;
1319         }
1320     }
1321 
1322     /**
1323      * @dev Hook that is called before any token transfer. This includes minting
1324      * and burning.
1325      *
1326      * Calling conditions:
1327      *
1328      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1329      * transferred to `to`.
1330      * - When `from` is zero, `tokenId` will be minted for `to`.
1331      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1332      * - `from` and `to` are never both zero.
1333      *
1334      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1335      */
1336     function _beforeTokenTransfer(
1337         address from,
1338         address to,
1339         uint256 tokenId
1340     ) internal virtual {}
1341 }
1342 
1343 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1344 
1345 
1346 
1347 pragma solidity ^0.8.0;
1348 
1349 
1350 
1351 /**
1352  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1353  * enumerability of all the token ids in the contract as well as all token ids owned by each
1354  * account.
1355  */
1356 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1357     // Mapping from owner to list of owned token IDs
1358     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1359 
1360     // Mapping from token ID to index of the owner tokens list
1361     mapping(uint256 => uint256) private _ownedTokensIndex;
1362 
1363     // Array with all token ids, used for enumeration
1364     uint256[] private _allTokens;
1365 
1366     // Mapping from token id to position in the allTokens array
1367     mapping(uint256 => uint256) private _allTokensIndex;
1368 
1369     /**
1370      * @dev See {IERC165-supportsInterface}.
1371      */
1372     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1373         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1374     }
1375 
1376     /**
1377      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1378      */
1379     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1380         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1381         return _ownedTokens[owner][index];
1382     }
1383 
1384     /**
1385      * @dev See {IERC721Enumerable-totalSupply}.
1386      */
1387     function totalSupply() public view virtual override returns (uint256) {
1388         return _allTokens.length;
1389     }
1390 
1391     /**
1392      * @dev See {IERC721Enumerable-tokenByIndex}.
1393      */
1394     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1395         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1396         return _allTokens[index];
1397     }
1398 
1399     /**
1400      * @dev Hook that is called before any token transfer. This includes minting
1401      * and burning.
1402      *
1403      * Calling conditions:
1404      *
1405      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1406      * transferred to `to`.
1407      * - When `from` is zero, `tokenId` will be minted for `to`.
1408      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1409      * - `from` cannot be the zero address.
1410      * - `to` cannot be the zero address.
1411      *
1412      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1413      */
1414     function _beforeTokenTransfer(
1415         address from,
1416         address to,
1417         uint256 tokenId
1418     ) internal virtual override {
1419         super._beforeTokenTransfer(from, to, tokenId);
1420 
1421         if (from == address(0)) {
1422             _addTokenToAllTokensEnumeration(tokenId);
1423         } else if (from != to) {
1424             _removeTokenFromOwnerEnumeration(from, tokenId);
1425         }
1426         if (to == address(0)) {
1427             _removeTokenFromAllTokensEnumeration(tokenId);
1428         } else if (to != from) {
1429             _addTokenToOwnerEnumeration(to, tokenId);
1430         }
1431     }
1432 
1433     /**
1434      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1435      * @param to address representing the new owner of the given token ID
1436      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1437      */
1438     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1439         uint256 length = ERC721.balanceOf(to);
1440         _ownedTokens[to][length] = tokenId;
1441         _ownedTokensIndex[tokenId] = length;
1442     }
1443 
1444     /**
1445      * @dev Private function to add a token to this extension's token tracking data structures.
1446      * @param tokenId uint256 ID of the token to be added to the tokens list
1447      */
1448     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1449         _allTokensIndex[tokenId] = _allTokens.length;
1450         _allTokens.push(tokenId);
1451     }
1452 
1453     /**
1454      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1455      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1456      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1457      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1458      * @param from address representing the previous owner of the given token ID
1459      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1460      */
1461     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1462         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1463         // then delete the last slot (swap and pop).
1464 
1465         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1466         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1467 
1468         // When the token to delete is the last token, the swap operation is unnecessary
1469         if (tokenIndex != lastTokenIndex) {
1470             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1471 
1472             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1473             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1474         }
1475 
1476         // This also deletes the contents at the last position of the array
1477         delete _ownedTokensIndex[tokenId];
1478         delete _ownedTokens[from][lastTokenIndex];
1479     }
1480 
1481     /**
1482      * @dev Private function to remove a token from this extension's token tracking data structures.
1483      * This has O(1) time complexity, but alters the order of the _allTokens array.
1484      * @param tokenId uint256 ID of the token to be removed from the tokens list
1485      */
1486     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1487         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1488         // then delete the last slot (swap and pop).
1489 
1490         uint256 lastTokenIndex = _allTokens.length - 1;
1491         uint256 tokenIndex = _allTokensIndex[tokenId];
1492 
1493         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1494         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1495         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1496         uint256 lastTokenId = _allTokens[lastTokenIndex];
1497 
1498         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1499         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1500 
1501         // This also deletes the contents at the last position of the array
1502         delete _allTokensIndex[tokenId];
1503         _allTokens.pop();
1504     }
1505 }
1506 
1507 // File: contracts/AcidApes.sol
1508 
1509 
1510 
1511 pragma solidity 0.8.7;
1512 
1513 
1514 
1515 
1516 
1517 
1518 
1519 contract AcidApes is ERC721Enumerable, Ownable {
1520     
1521     using SafeMath for uint256;
1522     
1523     string public baseTokenURI; 
1524 
1525     uint256 public constant RESERVED_FOR_FA = 777;
1526     uint256 public constant SUPER_ACID_POTION_TYPE_ID = 1;
1527     uint256 public max_acid_beasts = 10;
1528     uint256 public price = 0.02 ether;
1529     uint256 public saleState = 0;  // 0 = paused, 1 = live
1530     uint256 public max_apes = 4000;
1531     uint256 public purchase_limit = 10;
1532     uint256 public nonreserved_minted_tokens = 0;
1533     uint256 public next_acid_beast_token_id = 4000; //new
1534 
1535     bool public holderMintActive = true; //TODO - take it out
1536     
1537     mapping (bytes32 => bool) private giveAwayMap;
1538 
1539     // withdraw address
1540     address public a1 = 0xA24237b3702A7E98878a71d0C018511AcA61E1a1;
1541 
1542     //FA contract address
1543     address public fa_contract = 0xbEe93b0DbCBa090A5d73cbDCf4a9f8559472f46D;
1544 
1545     //NAV contract address
1546     address public nav_contract = 0x8D403915886AE151e8c73cfe99e322a85A94670b;
1547 
1548     mapping (uint256 => uint256) public superAcidBeastById; //new
1549     
1550     //constructor takes in baseTokenURI, keccak256 hash list 
1551     constructor(string memory _baseTokenURI, bytes32[] memory _giveawayList ) ERC721("TestAcidApes","TACID") {
1552         setBaseURI(_baseTokenURI);
1553 
1554         for(uint256 i; i < _giveawayList.length; i++){
1555             giveAwayMap[_giveawayList[i]] = true;
1556         }
1557 
1558     }
1559 
1560     //function for claiming giveaways
1561     function claimGiveaway(string memory _claimPassword) public {
1562         bytes32 hash = keccak256(abi.encodePacked(_claimPassword));
1563         require( giveAwayMap[hash] != false, "Claim ID is not valid");
1564         uint256 mintedTokens = nonreserved_minted_tokens;
1565         require((nonreserved_minted_tokens + 1) <= (max_apes - RESERVED_FOR_FA), "Requested mints exceed remaining supply");
1566         giveAwayMap[hash] = false;
1567         nonreserved_minted_tokens = nonreserved_minted_tokens + 1;
1568         _safeMint( msg.sender, mintedTokens + RESERVED_FOR_FA);
1569     }
1570    
1571 
1572     //free mint for FA holders
1573     function holderMint(uint256 _tokenId, uint256 _potionType) public {
1574 
1575         uint256 _tokenIdToMint = _tokenId;
1576 
1577         if (_potionType == SUPER_ACID_POTION_TYPE_ID)
1578         {
1579             require( msg.sender  == ownerOf(_tokenIdToMint), "You must own the corresponding Acid Ape to mint this token");
1580             require( next_acid_beast_token_id < (max_acid_beasts + max_apes), "Max Acid Beasts have been minted"); 
1581             require( superAcidBeastById[_tokenIdToMint] == 0, "Ape has already consumed an acid barrel" );
1582             superAcidBeastById[_tokenIdToMint] = 1;
1583             _tokenIdToMint = next_acid_beast_token_id;
1584             next_acid_beast_token_id = next_acid_beast_token_id + 1;
1585         }
1586         else{
1587             //TODO look this over
1588             require( holderMintActive,          "Fresh Apes owner grant period has ended" );
1589             require(msg.sender == ownerOfFreshApes(_tokenId), "You must own the corresponding Fresh Ape to mint this token");
1590             require(_tokenIdToMint < RESERVED_FOR_FA, "Token ID exceeds Fresh Apes supply");
1591             require(!_exists(_tokenIdToMint),         "Ape has already consumed acid vial");
1592         }
1593 
1594         require( balanceOfNAVOwner(msg.sender,_potionType) > 0, "You must own at least one consumable of this type");
1595 
1596          burnPotion( _potionType, msg.sender);
1597 
1598         _safeMint(msg.sender, _tokenIdToMint);
1599     }
1600 
1601     //mint all available claims for FA holders
1602     function holderMintAll() public {
1603      
1604         uint256[] memory ownedTokens = walletOfFAOwner(msg.sender);
1605 
1606         for(uint256 i; i < ownedTokens.length; i++)
1607         {
1608             uint256 _curToken = ownedTokens[i];
1609             //token exist in Acid Apes? If yes, continue. If no, then call holderMint
1610             if( _exists(_curToken) )
1611             {
1612                 continue;
1613             }
1614             else
1615             {     
1616                 holderMint(_curToken, 0);
1617             }
1618         }
1619     }
1620 
1621     //mint all available claims for FA holders
1622     function holderMintList(uint256[] memory _tokens) public {
1623         
1624         for(uint256 i; i < _tokens.length; i++)
1625         {
1626             uint256 _curToken = _tokens[i];
1627             if( _exists(_curToken) )
1628             {
1629                 continue;
1630             }
1631             else
1632             {     
1633                 holderMint(_curToken,0);
1634             }
1635 
1636         }
1637     }
1638     
1639     //mint function
1640     function mintApes(uint256 num) public payable{
1641         uint256 mintedTokens = nonreserved_minted_tokens;
1642         require( saleState > 0,             "Main sale is not active" );
1643         require( num <= purchase_limit,     "Requested mints exceed maximum" );
1644         require((nonreserved_minted_tokens + num) <= (max_apes - RESERVED_FOR_FA), "Requested mints exceed remaining supply");
1645         require( msg.value >= price * num,  "Ether sent is insufficient" );
1646 
1647         nonreserved_minted_tokens = nonreserved_minted_tokens + num;
1648         for(uint256 i; i < num; i++){
1649             _safeMint( msg.sender, mintedTokens + i + RESERVED_FOR_FA );
1650         }
1651     }
1652 
1653     function walletOfFAOwner(address _owner) public view returns (uint256[] memory) {
1654         IFreshApesToken freshApes = IFreshApesToken(fa_contract);
1655         return freshApes.walletOfOwner(_owner);
1656     }
1657 
1658     function ownerOfFreshApes(uint256 _tokenId) public view returns (address) {
1659         IFreshApesToken freshApes = IFreshApesToken(fa_contract);
1660         return freshApes.ownerOf(_tokenId);
1661     }
1662 
1663     function balanceOfFreshApesOwner(address _owner) public view returns (uint256) {
1664         IFreshApesToken freshApes = IFreshApesToken(fa_contract);
1665         return freshApes.balanceOf(_owner);
1666     }
1667 
1668     function balanceOfNAVOwner(address _owner, uint256 _id) public view returns (uint256) {
1669         INuclearAcidVault nav = INuclearAcidVault(nav_contract);
1670         return nav.balanceOf(_owner,_id);
1671     }
1672 
1673     function burnPotion(uint256 _typeId, address _burnTokenAddress) private {
1674         INuclearAcidVault nav = INuclearAcidVault(nav_contract);
1675         nav.burnPotionForAddress(_typeId, _burnTokenAddress);
1676     }
1677 
1678     //views
1679     
1680     //override so openzeppelin tokenURI() can utilize the baseTokenURI we set
1681     function _baseURI() internal view virtual override returns (string memory) {
1682         return baseTokenURI;
1683     }
1684     
1685     function walletOfOwner(address _owner) public view returns(uint256[] memory) {
1686         uint256 tokenCount = balanceOf(_owner);
1687 
1688         uint256[] memory tokensId = new uint256[](tokenCount);
1689         for(uint256 i; i < tokenCount; i++){
1690             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1691         }
1692         return tokensId;
1693     }
1694 
1695 
1696     function exists(uint256 _tokenId) public view returns (bool) {
1697         return _exists(_tokenId);
1698     }
1699     
1700     //setters
1701     
1702     //if eth moons, price may have to be adjusted
1703     function setPrice(uint256 _newPrice) public onlyOwner() {
1704         price = _newPrice;
1705     }
1706     
1707     function setMaxApes(uint256 _newMax) public onlyOwner{
1708         max_apes = _newMax;
1709     }
1710 
1711    function setNextAcidBeastTokenId(uint256 _newTokenId) public onlyOwner{
1712         next_acid_beast_token_id = _newTokenId;
1713     }
1714 
1715    function setMaxAcidBeasts(uint256 _newMax) public onlyOwner{
1716         max_acid_beasts = _newMax;
1717     }    
1718 
1719     function setPurchaseLimit(uint256 _newLimit) public onlyOwner{
1720         purchase_limit = _newLimit;
1721     }
1722 
1723     function setHolderMintActive(bool _isActive) public onlyOwner {
1724         holderMintActive = _isActive;
1725     }
1726 
1727     // 0 = paused, 1 = live 
1728     function setSaleState(uint256 _saleState) public onlyOwner {
1729         saleState = _saleState;
1730     }
1731     
1732     function setBaseURI(string memory baseURI) public onlyOwner {
1733         baseTokenURI = baseURI;
1734     }
1735     
1736     function setWithdrawAddress(address _a) public onlyOwner {
1737         a1 = _a;
1738     }
1739 
1740     function setFAContractAddress(address _a) public onlyOwner {
1741         fa_contract = _a;
1742     }
1743 
1744     function setNAVContractAddress(address _a) public onlyOwner {
1745         nav_contract = _a;
1746     }
1747 
1748     function setNonReservedMintedTokens(uint256 _reservedTokens) public onlyOwner {
1749         nonreserved_minted_tokens = _reservedTokens;
1750     }
1751     
1752     //creator utils
1753     //add keccak256 hashes
1754     function addToGiveawayList(bytes32[] memory _giveawayList) public onlyOwner {
1755         for(uint256 i; i < _giveawayList.length; i++){
1756             giveAwayMap[_giveawayList[i]] = true;
1757         }
1758     }
1759 
1760     function devMint(uint256[] memory _tokens, address _to) public onlyOwner {
1761 
1762         //require( !holderMintActive, "Fresh Apes owner grant period is still active" );
1763 
1764         for(uint256 i; i < _tokens.length; i++)
1765         {
1766             uint256 _curToken = _tokens[i];
1767             if( _exists(_curToken) )
1768             {
1769                 continue;
1770             }
1771             else
1772             {     
1773                 _safeMint(_to, _curToken);
1774             }
1775 
1776         }
1777 
1778     }
1779 
1780     function giveAway(address _to, uint256 _count) external onlyOwner() {
1781         uint256 mintedTokens = nonreserved_minted_tokens;
1782         require((nonreserved_minted_tokens + _count) <= (max_apes - RESERVED_FOR_FA), "Requested mints exceed remaining supply");
1783         //update minted token count
1784         nonreserved_minted_tokens = nonreserved_minted_tokens + _count;       
1785         for(uint256 i; i < _count; i++){
1786             _safeMint( _to, mintedTokens + i + RESERVED_FOR_FA);
1787         }
1788     }
1789     
1790     function withdrawBalance() public payable onlyOwner {
1791         uint256 _payment = address(this).balance;
1792         
1793         (bool success, ) = payable(a1).call{value: _payment}("");
1794         require(success, "Transfer failed to a1.");
1795 
1796     }
1797     
1798     
1799 }