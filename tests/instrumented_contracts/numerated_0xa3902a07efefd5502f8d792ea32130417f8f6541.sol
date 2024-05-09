1 /**
2  *Submitted for verification at Etherscan.io on 2021-10-11
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.0;
7 //Developed by blockchainguy.net
8 library SafeMath {
9     /**
10      * @dev Returns the addition of two unsigned integers, with an overflow flag.
11      *
12      * _Available since v3.4._
13      */
14     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
15         unchecked {
16             uint256 c = a + b;
17             if (c < a) return (false, 0);
18             return (true, c);
19         }
20     }
21 
22     /**
23      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
24      *
25      * _Available since v3.4._
26      */
27     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
28         unchecked {
29             if (b > a) return (false, 0);
30             return (true, a - b);
31         }
32     }
33 
34     /**
35      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
36      *
37      * _Available since v3.4._
38      */
39     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         unchecked {
41             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
42             // benefit is lost if 'b' is also tested.
43             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
44             if (a == 0) return (true, 0);
45             uint256 c = a * b;
46             if (c / a != b) return (false, 0);
47             return (true, c);
48         }
49     }
50 
51     /**
52      * @dev Returns the division of two unsigned integers, with a division by zero flag.
53      *
54      * _Available since v3.4._
55      */
56     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
57         unchecked {
58             if (b == 0) return (false, 0);
59             return (true, a / b);
60         }
61     }
62 
63     /**
64      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
65      *
66      * _Available since v3.4._
67      */
68     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
69         unchecked {
70             if (b == 0) return (false, 0);
71             return (true, a % b);
72         }
73     }
74 
75     /**
76      * @dev Returns the addition of two unsigned integers, reverting on
77      * overflow.
78      *
79      * Counterpart to Solidity's `+` operator.
80      *
81      * Requirements:
82      *
83      * - Addition cannot overflow.
84      */
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         return a + b;
87     }
88 
89     /**
90      * @dev Returns the subtraction of two unsigned integers, reverting on
91      * overflow (when the result is negative).
92      *
93      * Counterpart to Solidity's `-` operator.
94      *
95      * Requirements:
96      *
97      * - Subtraction cannot overflow.
98      */
99     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100         return a - b;
101     }
102 
103     /**
104      * @dev Returns the multiplication of two unsigned integers, reverting on
105      * overflow.
106      *
107      * Counterpart to Solidity's `*` operator.
108      *
109      * Requirements:
110      *
111      * - Multiplication cannot overflow.
112      */
113     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
114         return a * b;
115     }
116 
117     /**
118      * @dev Returns the integer division of two unsigned integers, reverting on
119      * division by zero. The result is rounded towards zero.
120      *
121      * Counterpart to Solidity's `/` operator.
122      *
123      * Requirements:
124      *
125      * - The divisor cannot be zero.
126      */
127     function div(uint256 a, uint256 b) internal pure returns (uint256) {
128         return a / b;
129     }
130 
131     /**
132      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
133      * reverting when dividing by zero.
134      *
135      * Counterpart to Solidity's `%` operator. This function uses a `revert`
136      * opcode (which leaves remaining gas untouched) while Solidity uses an
137      * invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      *
141      * - The divisor cannot be zero.
142      */
143     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
144         return a % b;
145     }
146 
147     /**
148      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
149      * overflow (when the result is negative).
150      *
151      * CAUTION: This function is deprecated because it requires allocating memory for the error
152      * message unnecessarily. For custom revert reasons use {trySub}.
153      *
154      * Counterpart to Solidity's `-` operator.
155      *
156      * Requirements:
157      *
158      * - Subtraction cannot overflow.
159      */
160     function sub(
161         uint256 a,
162         uint256 b,
163         string memory errorMessage
164     ) internal pure returns (uint256) {
165         unchecked {
166             require(b <= a, errorMessage);
167             return a - b;
168         }
169     }
170 
171     /**
172      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
173      * division by zero. The result is rounded towards zero.
174      *
175      * Counterpart to Solidity's `/` operator. Note: this function uses a
176      * `revert` opcode (which leaves remaining gas untouched) while Solidity
177      * uses an invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      *
181      * - The divisor cannot be zero.
182      */
183     function div(
184         uint256 a,
185         uint256 b,
186         string memory errorMessage
187     ) internal pure returns (uint256) {
188         unchecked {
189             require(b > 0, errorMessage);
190             return a / b;
191         }
192     }
193 
194     /**
195      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
196      * reverting with custom message when dividing by zero.
197      *
198      * CAUTION: This function is deprecated because it requires allocating memory for the error
199      * message unnecessarily. For custom revert reasons use {tryMod}.
200      *
201      * Counterpart to Solidity's `%` operator. This function uses a `revert`
202      * opcode (which leaves remaining gas untouched) while Solidity uses an
203      * invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      *
207      * - The divisor cannot be zero.
208      */
209     function mod(
210         uint256 a,
211         uint256 b,
212         string memory errorMessage
213     ) internal pure returns (uint256) {
214         unchecked {
215             require(b > 0, errorMessage);
216             return a % b;
217         }
218     }
219 }
220 library Strings {
221     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
222 
223     /**
224      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
225      */
226     function toString(uint256 value) internal pure returns (string memory) {
227         // Inspired by OraclizeAPI's implementation - MIT licence
228         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
229 
230         if (value == 0) {
231             return "0";
232         }
233         uint256 temp = value;
234         uint256 digits;
235         while (temp != 0) {
236             digits++;
237             temp /= 10;
238         }
239         bytes memory buffer = new bytes(digits);
240         while (value != 0) {
241             digits -= 1;
242             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
243             value /= 10;
244         }
245         return string(buffer);
246     }
247 
248     /**
249      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
250      */
251     function toHexString(uint256 value) internal pure returns (string memory) {
252         if (value == 0) {
253             return "0x00";
254         }
255         uint256 temp = value;
256         uint256 length = 0;
257         while (temp != 0) {
258             length++;
259             temp >>= 8;
260         }
261         return toHexString(value, length);
262     }
263 
264     /**
265      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
266      */
267     function toHexString(uint256 value, uint256 length)
268         internal
269         pure
270         returns (string memory)
271     {
272         bytes memory buffer = new bytes(2 * length + 2);
273         buffer[0] = "0";
274         buffer[1] = "x";
275         for (uint256 i = 2 * length + 1; i > 1; --i) {
276             buffer[i] = _HEX_SYMBOLS[value & 0xf];
277             value >>= 4;
278         }
279         require(value == 0, "Strings: hex length insufficient");
280         return string(buffer);
281     }
282 }
283 
284 interface IERC165 {
285     /**
286      * @dev Returns true if this contract implements the interface defined by
287      * `interfaceId`. See the corresponding
288      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
289      * to learn more about how these ids are created.
290      *
291      * This function call must use less than 30 000 gas.
292      */
293     function supportsInterface(bytes4 interfaceId) external view returns (bool);
294 }
295 interface IERC721 is IERC165 {
296     /**
297      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
298      */
299     event Transfer(
300         address indexed from,
301         address indexed to,
302         uint256 indexed tokenId
303     );
304 
305     /**
306      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
307      */
308     event Approval(
309         address indexed owner,
310         address indexed approved,
311         uint256 indexed tokenId
312     );
313 
314     /**
315      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
316      */
317     event ApprovalForAll(
318         address indexed owner,
319         address indexed operator,
320         bool approved
321     );
322 
323     /**
324      * @dev Returns the number of tokens in ``owner``'s account.
325      */
326     function balanceOf(address owner) external view returns (uint256 balance);
327 
328     /**
329      * @dev Returns the owner of the `tokenId` token.
330      *
331      * Requirements:
332      *
333      * - `tokenId` must exist.
334      */
335     function ownerOf(uint256 tokenId) external view returns (address owner);
336 
337     /**
338      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
339      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
340      *
341      * Requirements:
342      *
343      * - `from` cannot be the zero address.
344      * - `to` cannot be the zero address.
345      * - `tokenId` token must exist and be owned by `from`.
346      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
347      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
348      *
349      * Emits a {Transfer} event.
350      */
351     function safeTransferFrom(
352         address from,
353         address to,
354         uint256 tokenId
355     ) external;
356 
357     /**
358      * @dev Transfers `tokenId` token from `from` to `to`.
359      *
360      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
361      *
362      * Requirements:
363      *
364      * - `from` cannot be the zero address.
365      * - `to` cannot be the zero address.
366      * - `tokenId` token must be owned by `from`.
367      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
368      *
369      * Emits a {Transfer} event.
370      */
371     function transferFrom(
372         address from,
373         address to,
374         uint256 tokenId
375     ) external;
376 
377     /**
378      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
379      * The approval is cleared when the token is transferred.
380      *
381      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
382      *
383      * Requirements:
384      *
385      * - The caller must own the token or be an approved operator.
386      * - `tokenId` must exist.
387      *
388      * Emits an {Approval} event.
389      */
390     function approve(address to, uint256 tokenId) external;
391 
392     /**
393      * @dev Returns the account approved for `tokenId` token.
394      *
395      * Requirements:
396      *
397      * - `tokenId` must exist.
398      */
399     function getApproved(uint256 tokenId)
400         external
401         view
402         returns (address operator);
403 
404     /**
405      * @dev Approve or remove `operator` as an operator for the caller.
406      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
407      *
408      * Requirements:
409      *
410      * - The `operator` cannot be the caller.
411      *
412      * Emits an {ApprovalForAll} event.
413      */
414     function setApprovalForAll(address operator, bool _approved) external;
415 
416     /**
417      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
418      *
419      * See {setApprovalForAll}
420      */
421     function isApprovedForAll(address owner, address operator)
422         external
423         view
424         returns (bool);
425 
426     /**
427      * @dev Safely transfers `tokenId` token from `from` to `to`.
428      *
429      * Requirements:
430      *
431      * - `from` cannot be the zero address.
432      * - `to` cannot be the zero address.
433      * - `tokenId` token must exist and be owned by `from`.
434      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
435      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
436      *
437      * Emits a {Transfer} event.
438      */
439     function safeTransferFrom(
440         address from,
441         address to,
442         uint256 tokenId,
443         bytes calldata data
444     ) external;
445 }
446 interface IERC721Enumerable is IERC721 {
447     /**
448      * @dev Returns the total amount of tokens stored by the contract.
449      */
450     function totalSupply() external view returns (uint256);
451 
452     /**
453      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
454      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
455      */
456     function tokenOfOwnerByIndex(address owner, uint256 index)
457         external
458         view
459         returns (uint256 tokenId);
460 
461     /**
462      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
463      * Use along with {totalSupply} to enumerate all tokens.
464      */
465     function tokenByIndex(uint256 index) external view returns (uint256);
466 }
467 interface IERC721Metadata is IERC721 {
468     /**
469      * @dev Returns the token collection name.
470      */
471     function name() external view returns (string memory);
472 
473     /**
474      * @dev Returns the token collection symbol.
475      */
476     function symbol() external view returns (string memory);
477 
478     /**
479      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
480      */
481     function tokenURI(uint256 tokenId) external view returns (string memory);
482 }
483 interface IERC721Receiver {
484     /**
485      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
486      * by `operator` from `from`, this function is called.
487      *
488      * It must return its Solidity selector to confirm the token transfer.
489      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
490      *
491      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
492      */
493     function onERC721Received(
494         address operator,
495         address from,
496         uint256 tokenId,
497         bytes calldata data
498     ) external returns (bytes4);
499 }
500 library Address {
501     /**
502      * @dev Returns true if `account` is a contract.
503      *
504      * [IMPORTANT]
505      * ====
506      * It is unsafe to assume that an address for which this function returns
507      * false is an externally-owned account (EOA) and not a contract.
508      *
509      * Among others, `isContract` will return false for the following
510      * types of addresses:
511      *
512      *  - an externally-owned account
513      *  - a contract in construction
514      *  - an address where a contract will be created
515      *  - an address where a contract lived, but was destroyed
516      * ====
517      */
518     function isContract(address account) internal view returns (bool) {
519         // This method relies on extcodesize, which returns 0 for contracts in
520         // construction, since the code is only stored at the end of the
521         // constructor execution.
522 
523         uint256 size;
524         assembly {
525             size := extcodesize(account)
526         }
527         return size > 0;
528     }
529 
530     /**
531      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
532      * `recipient`, forwarding all available gas and reverting on errors.
533      *
534      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
535      * of certain opcodes, possibly making contracts go over the 2300 gas limit
536      * imposed by `transfer`, making them unable to receive funds via
537      * `transfer`. {sendValue} removes this limitation.
538      *
539      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
540      *
541      * IMPORTANT: because control is transferred to `recipient`, care must be
542      * taken to not create reentrancy vulnerabilities. Consider using
543      * {ReentrancyGuard} or the
544      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
545      */
546     function sendValue(address payable recipient, uint256 amount) internal {
547         require(
548             address(this).balance >= amount,
549             "Address: insufficient balance"
550         );
551 
552         (bool success, ) = recipient.call{value: amount}("");
553         require(
554             success,
555             "Address: unable to send value, recipient may have reverted"
556         );
557     }
558 
559     /**
560      * @dev Performs a Solidity function call using a low level `call`. A
561      * plain `call` is an unsafe replacement for a function call: use this
562      * function instead.
563      *
564      * If `target` reverts with a revert reason, it is bubbled up by this
565      * function (like regular Solidity function calls).
566      *
567      * Returns the raw returned data. To convert to the expected return value,
568      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
569      *
570      * Requirements:
571      *
572      * - `target` must be a contract.
573      * - calling `target` with `data` must not revert.
574      *
575      * _Available since v3.1._
576      */
577     function functionCall(address target, bytes memory data)
578         internal
579         returns (bytes memory)
580     {
581         return functionCall(target, data, "Address: low-level call failed");
582     }
583 
584     /**
585      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
586      * `errorMessage` as a fallback revert reason when `target` reverts.
587      *
588      * _Available since v3.1._
589      */
590     function functionCall(
591         address target,
592         bytes memory data,
593         string memory errorMessage
594     ) internal returns (bytes memory) {
595         return functionCallWithValue(target, data, 0, errorMessage);
596     }
597 
598     /**
599      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
600      * but also transferring `value` wei to `target`.
601      *
602      * Requirements:
603      *
604      * - the calling contract must have an ETH balance of at least `value`.
605      * - the called Solidity function must be `payable`.
606      *
607      * _Available since v3.1._
608      */
609     function functionCallWithValue(
610         address target,
611         bytes memory data,
612         uint256 value
613     ) internal returns (bytes memory) {
614         return
615             functionCallWithValue(
616                 target,
617                 data,
618                 value,
619                 "Address: low-level call with value failed"
620             );
621     }
622 
623     /**
624      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
625      * with `errorMessage` as a fallback revert reason when `target` reverts.
626      *
627      * _Available since v3.1._
628      */
629     function functionCallWithValue(
630         address target,
631         bytes memory data,
632         uint256 value,
633         string memory errorMessage
634     ) internal returns (bytes memory) {
635         require(
636             address(this).balance >= value,
637             "Address: insufficient balance for call"
638         );
639         require(isContract(target), "Address: call to non-contract");
640 
641         (bool success, bytes memory returndata) = target.call{value: value}(
642             data
643         );
644         return verifyCallResult(success, returndata, errorMessage);
645     }
646 
647     /**
648      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
649      * but performing a static call.
650      *
651      * _Available since v3.3._
652      */
653     function functionStaticCall(address target, bytes memory data)
654         internal
655         view
656         returns (bytes memory)
657     {
658         return
659             functionStaticCall(
660                 target,
661                 data,
662                 "Address: low-level static call failed"
663             );
664     }
665 
666     /**
667      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
668      * but performing a static call.
669      *
670      * _Available since v3.3._
671      */
672     function functionStaticCall(
673         address target,
674         bytes memory data,
675         string memory errorMessage
676     ) internal view returns (bytes memory) {
677         require(isContract(target), "Address: static call to non-contract");
678 
679         (bool success, bytes memory returndata) = target.staticcall(data);
680         return verifyCallResult(success, returndata, errorMessage);
681     }
682 
683     /**
684      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
685      * but performing a delegate call.
686      *
687      * _Available since v3.4._
688      */
689     function functionDelegateCall(address target, bytes memory data)
690         internal
691         returns (bytes memory)
692     {
693         return
694             functionDelegateCall(
695                 target,
696                 data,
697                 "Address: low-level delegate call failed"
698             );
699     }
700 
701     /**
702      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
703      * but performing a delegate call.
704      *
705      * _Available since v3.4._
706      */
707     function functionDelegateCall(
708         address target,
709         bytes memory data,
710         string memory errorMessage
711     ) internal returns (bytes memory) {
712         require(isContract(target), "Address: delegate call to non-contract");
713 
714         (bool success, bytes memory returndata) = target.delegatecall(data);
715         return verifyCallResult(success, returndata, errorMessage);
716     }
717 
718     /**
719      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
720      * revert reason using the provided one.
721      *
722      * _Available since v4.3._
723      */
724     function verifyCallResult(
725         bool success,
726         bytes memory returndata,
727         string memory errorMessage
728     ) internal pure returns (bytes memory) {
729         if (success) {
730             return returndata;
731         } else {
732             // Look for revert reason and bubble it up if present
733             if (returndata.length > 0) {
734                 // The easiest way to bubble the revert reason is using memory via assembly
735 
736                 assembly {
737                     let returndata_size := mload(returndata)
738                     revert(add(32, returndata), returndata_size)
739                 }
740             } else {
741                 revert(errorMessage);
742             }
743         }
744     }
745 }
746 abstract contract ContextMixin {
747     function msgSender() internal view returns (address payable sender) {
748         if (msg.sender == address(this)) {
749             bytes memory array = msg.data;
750             uint256 index = msg.data.length;
751             assembly {
752                 // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
753                 sender := and(
754                     mload(add(array, index)),
755                     0xffffffffffffffffffffffffffffffffffffffff
756                 )
757             }
758         } else {
759             sender = payable(msg.sender);
760         }
761         return sender;
762     }
763 }
764 abstract contract Context {
765     function _msgSender() internal view virtual returns (address) {
766         return msg.sender;
767     }
768 
769     function _msgData() internal view virtual returns (bytes calldata) {
770         return msg.data;
771     }
772 }
773 abstract contract Ownable is Context {
774     address private _owner;
775 
776     event OwnershipTransferred(
777         address indexed previousOwner,
778         address indexed newOwner
779     );
780 
781     /**
782      * @dev Initializes the contract setting the deployer as the initial owner.
783      */
784     constructor() {
785         _setOwner(_msgSender());
786     }
787 
788     /**
789      * @dev Returns the address of the current owner.
790      */
791     function owner() public view virtual returns (address) {
792         return _owner;
793     }
794 
795     /**
796      * @dev Throws if called by any account other than the owner.
797      */
798     modifier onlyOwner() {
799         require(owner() == _msgSender(), "Ownable: caller is not the owner");
800         _;
801     }
802 
803     /**
804      * @dev Leaves the contract without owner. It will not be possible to call
805      * `onlyOwner` functions anymore. Can only be called by the current owner.
806      *
807      * NOTE: Renouncing ownership will leave the contract without an owner,
808      * thereby removing any functionality that is only available to the owner.
809      */
810     function renounceOwnership() public virtual onlyOwner {
811         _setOwner(address(0));
812     }
813 
814     /**
815      * @dev Transfers ownership of the contract to a new account (`newOwner`).
816      * Can only be called by the current owner.
817      */
818     function transferOwnership(address newOwner) public virtual onlyOwner {
819         require(
820             newOwner != address(0),
821             "Ownable: new owner is the zero address"
822         );
823         _setOwner(newOwner);
824     }
825 
826     function _setOwner(address newOwner) private {
827         address oldOwner = _owner;
828         _owner = newOwner;
829         emit OwnershipTransferred(oldOwner, newOwner);
830     }
831 }
832 abstract contract ERC165 is IERC165 {
833     /**
834      * @dev See {IERC165-supportsInterface}.
835      */
836     function supportsInterface(bytes4 interfaceId)
837         public
838         view
839         virtual
840         override
841         returns (bool)
842     {
843         return interfaceId == type(IERC165).interfaceId;
844     }
845 }
846 
847 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
848     using Address for address;
849     using Strings for uint256;
850 
851     // Token name
852     string private _name;
853 
854     // Token symbol
855     string private _symbol;
856 
857     // Mapping from token ID to owner address
858     mapping(uint256 => address) private _owners;
859 
860     // Mapping owner address to token count
861     mapping(address => uint256) private _balances;
862 
863     // Mapping from token ID to approved address
864     mapping(uint256 => address) private _tokenApprovals;
865 
866     // Mapping from owner to operator approvals
867     mapping(address => mapping(address => bool)) private _operatorApprovals;
868 
869     /**
870      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
871      */
872     constructor(string memory name_, string memory symbol_) {
873         _name = name_;
874         _symbol = symbol_;
875     }
876 
877     /**
878      * @dev See {IERC165-supportsInterface}.
879      */
880     function supportsInterface(bytes4 interfaceId)
881         public
882         view
883         virtual
884         override(ERC165, IERC165)
885         returns (bool)
886     {
887         return
888             interfaceId == type(IERC721).interfaceId ||
889             interfaceId == type(IERC721Metadata).interfaceId ||
890             super.supportsInterface(interfaceId);
891     }
892 
893     /**
894      * @dev See {IERC721-balanceOf}.
895      */
896     function balanceOf(address owner)
897         public
898         view
899         virtual
900         override
901         returns (uint256)
902     {
903         require(
904             owner != address(0),
905             "ERC721: balance query for the zero address"
906         );
907         return _balances[owner];
908     }
909 
910     /**
911      * @dev See {IERC721-ownerOf}.
912      */
913     function ownerOf(uint256 tokenId)
914         public
915         view
916         virtual
917         override
918         returns (address)
919     {
920         address owner = _owners[tokenId];
921         require(
922             owner != address(0),
923             "ERC721: owner query for nonexistent token"
924         );
925         return owner;
926     }
927 
928     /**
929      * @dev See {IERC721Metadata-name}.
930      */
931     function name() public view virtual override returns (string memory) {
932         return _name;
933     }
934 
935     /**
936      * @dev See {IERC721Metadata-symbol}.
937      */
938     function symbol() public view virtual override returns (string memory) {
939         return _symbol;
940     }
941 
942     /**
943      * @dev See {IERC721Metadata-tokenURI}.
944      */
945     function tokenURI(uint256 tokenId)
946         public
947         view
948         virtual
949         override
950         returns (string memory)
951     {
952         require(
953             _exists(tokenId),
954             "ERC721Metadata: URI query for nonexistent token"
955         );
956 
957         string memory baseURI = _baseURI();
958         return
959             bytes(baseURI).length > 0
960                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
961                 : "";
962     }
963 
964     /**
965      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
966      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
967      * by default, can be overriden in child contracts.
968      */
969     function _baseURI() internal view virtual returns (string memory) {
970         return "";
971     }
972 
973     /**
974      * @dev See {IERC721-approve}.
975      */
976     function approve(address to, uint256 tokenId) public virtual override {
977         address owner = ERC721.ownerOf(tokenId);
978         require(to != owner, "ERC721: approval to current owner");
979 
980         require(
981             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
982             "ERC721: approve caller is not owner nor approved for all"
983         );
984 
985         _approve(to, tokenId);
986     }
987 
988     /**
989      * @dev See {IERC721-getApproved}.
990      */
991     function getApproved(uint256 tokenId)
992         public
993         view
994         virtual
995         override
996         returns (address)
997     {
998         require(
999             _exists(tokenId),
1000             "ERC721: approved query for nonexistent token"
1001         );
1002 
1003         return _tokenApprovals[tokenId];
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-setApprovalForAll}.
1008      */
1009     function setApprovalForAll(address operator, bool approved)
1010         public
1011         virtual
1012         override
1013     {
1014         require(operator != _msgSender(), "ERC721: approve to caller");
1015 
1016         _operatorApprovals[_msgSender()][operator] = approved;
1017         emit ApprovalForAll(_msgSender(), operator, approved);
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-isApprovedForAll}.
1022      */
1023     function isApprovedForAll(address owner, address operator)
1024         public
1025         view
1026         virtual
1027         override
1028         returns (bool)
1029     {
1030         return _operatorApprovals[owner][operator];
1031     }
1032 
1033     /**
1034      * @dev See {IERC721-transferFrom}.
1035      */
1036     function transferFrom(
1037         address from,
1038         address to,
1039         uint256 tokenId
1040     ) public virtual override {
1041         //solhint-disable-next-line max-line-length
1042         require(
1043             _isApprovedOrOwner(_msgSender(), tokenId),
1044             "ERC721: transfer caller is not owner nor approved"
1045         );
1046 
1047         _transfer(from, to, tokenId);
1048     }
1049 
1050     /**
1051      * @dev See {IERC721-safeTransferFrom}.
1052      */
1053     function safeTransferFrom(
1054         address from,
1055         address to,
1056         uint256 tokenId
1057     ) public virtual override {
1058         safeTransferFrom(from, to, tokenId, "");
1059     }
1060 
1061     /**
1062      * @dev See {IERC721-safeTransferFrom}.
1063      */
1064     function safeTransferFrom(
1065         address from,
1066         address to,
1067         uint256 tokenId,
1068         bytes memory _data
1069     ) public virtual override {
1070         require(
1071             _isApprovedOrOwner(_msgSender(), tokenId),
1072             "ERC721: transfer caller is not owner nor approved"
1073         );
1074         _safeTransfer(from, to, tokenId, _data);
1075     }
1076 
1077     /**
1078      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1079      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1080      *
1081      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1082      *
1083      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1084      * implement alternative mechanisms to perform token transfer, such as signature-based.
1085      *
1086      * Requirements:
1087      *
1088      * - `from` cannot be the zero address.
1089      * - `to` cannot be the zero address.
1090      * - `tokenId` token must exist and be owned by `from`.
1091      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1092      *
1093      * Emits a {Transfer} event.
1094      */
1095     function _safeTransfer(
1096         address from,
1097         address to,
1098         uint256 tokenId,
1099         bytes memory _data
1100     ) internal virtual {
1101         _transfer(from, to, tokenId);
1102         require(
1103             _checkOnERC721Received(from, to, tokenId, _data),
1104             "ERC721: transfer to non ERC721Receiver implementer"
1105         );
1106     }
1107 
1108     /**
1109      * @dev Returns whether `tokenId` exists.
1110      *
1111      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1112      *
1113      * Tokens start existing when they are minted (`_mint`),
1114      * and stop existing when they are burned (`_burn`).
1115      */
1116     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1117         return _owners[tokenId] != address(0);
1118     }
1119 
1120     /**
1121      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1122      *
1123      * Requirements:
1124      *
1125      * - `tokenId` must exist.
1126      */
1127     function _isApprovedOrOwner(address spender, uint256 tokenId)
1128         internal
1129         view
1130         virtual
1131         returns (bool)
1132     {
1133         require(
1134             _exists(tokenId),
1135             "ERC721: operator query for nonexistent token"
1136         );
1137         address owner = ERC721.ownerOf(tokenId);
1138         return (spender == owner ||
1139             getApproved(tokenId) == spender ||
1140             isApprovedForAll(owner, spender));
1141     }
1142 
1143     /**
1144      * @dev Safely mints `tokenId` and transfers it to `to`.
1145      *
1146      * Requirements:
1147      *
1148      * - `tokenId` must not exist.
1149      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1150      *
1151      * Emits a {Transfer} event.
1152      */
1153     function _safeMint(address to, uint256 tokenId) internal virtual {
1154         _safeMint(to, tokenId, "");
1155     }
1156 
1157     /**
1158      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1159      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1160      */
1161     function _safeMint(
1162         address to,
1163         uint256 tokenId,
1164         bytes memory _data
1165     ) internal virtual {
1166         _mint(to, tokenId);
1167         require(
1168             _checkOnERC721Received(address(0), to, tokenId, _data),
1169             "ERC721: transfer to non ERC721Receiver implementer"
1170         );
1171     }
1172 
1173     /**
1174      * @dev Mints `tokenId` and transfers it to `to`.
1175      *
1176      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1177      *
1178      * Requirements:
1179      *
1180      * - `tokenId` must not exist.
1181      * - `to` cannot be the zero address.
1182      *
1183      * Emits a {Transfer} event.
1184      */
1185     function _mint(address to, uint256 tokenId) internal virtual {
1186         require(to != address(0), "ERC721: mint to the zero address");
1187         require(!_exists(tokenId), "ERC721: token already minted");
1188 
1189         _beforeTokenTransfer(address(0), to, tokenId);
1190 
1191         _balances[to] += 1;
1192         _owners[tokenId] = to;
1193 
1194         emit Transfer(address(0), to, tokenId);
1195     }
1196 
1197     /**
1198      * @dev Destroys `tokenId`.
1199      * The approval is cleared when the token is burned.
1200      *
1201      * Requirements:
1202      *
1203      * - `tokenId` must exist.
1204      *
1205      * Emits a {Transfer} event.
1206      */
1207     function _burn(uint256 tokenId) internal virtual {
1208         address owner = ERC721.ownerOf(tokenId);
1209 
1210         _beforeTokenTransfer(owner, address(0), tokenId);
1211 
1212         // Clear approvals
1213         _approve(address(0), tokenId);
1214 
1215         _balances[owner] -= 1;
1216         delete _owners[tokenId];
1217 
1218         emit Transfer(owner, address(0), tokenId);
1219     }
1220 
1221     /**
1222      * @dev Transfers `tokenId` from `from` to `to`.
1223      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1224      *
1225      * Requirements:
1226      *
1227      * - `to` cannot be the zero address.
1228      * - `tokenId` token must be owned by `from`.
1229      *
1230      * Emits a {Transfer} event.
1231      */
1232     function _transfer(
1233         address from,
1234         address to,
1235         uint256 tokenId
1236     ) internal virtual {
1237         require(
1238             ERC721.ownerOf(tokenId) == from,
1239             "ERC721: transfer of token that is not own"
1240         );
1241         require(to != address(0), "ERC721: transfer to the zero address");
1242 
1243         _beforeTokenTransfer(from, to, tokenId);
1244 
1245         // Clear approvals from the previous owner
1246         _approve(address(0), tokenId);
1247 
1248         _balances[from] -= 1;
1249         _balances[to] += 1;
1250         _owners[tokenId] = to;
1251 
1252         emit Transfer(from, to, tokenId);
1253     }
1254 
1255     /**
1256      * @dev Approve `to` to operate on `tokenId`
1257      *
1258      * Emits a {Approval} event.
1259      */
1260     function _approve(address to, uint256 tokenId) internal virtual {
1261         _tokenApprovals[tokenId] = to;
1262         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1263     }
1264 
1265     /**
1266      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1267      * The call is not executed if the target address is not a contract.
1268      *
1269      * @param from address representing the previous owner of the given token ID
1270      * @param to target address that will receive the tokens
1271      * @param tokenId uint256 ID of the token to be transferred
1272      * @param _data bytes optional data to send along with the call
1273      * @return bool whether the call correctly returned the expected magic value
1274      */
1275     function _checkOnERC721Received(
1276         address from,
1277         address to,
1278         uint256 tokenId,
1279         bytes memory _data
1280     ) private returns (bool) {
1281         if (to.isContract()) {
1282             try
1283                 IERC721Receiver(to).onERC721Received(
1284                     _msgSender(),
1285                     from,
1286                     tokenId,
1287                     _data
1288                 )
1289             returns (bytes4 retval) {
1290                 return retval == IERC721Receiver.onERC721Received.selector;
1291             } catch (bytes memory reason) {
1292                 if (reason.length == 0) {
1293                     revert(
1294                         "ERC721: transfer to non ERC721Receiver implementer"
1295                     );
1296                 } else {
1297                     assembly {
1298                         revert(add(32, reason), mload(reason))
1299                     }
1300                 }
1301             }
1302         } else {
1303             return true;
1304         }
1305     }
1306 
1307     /**
1308      * @dev Hook that is called before any token transfer. This includes minting
1309      * and burning.
1310      *
1311      * Calling conditions:
1312      *
1313      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1314      * transferred to `to`.
1315      * - When `from` is zero, `tokenId` will be minted for `to`.
1316      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1317      * - `from` and `to` are never both zero.
1318      *
1319      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1320      */
1321     function _beforeTokenTransfer(
1322         address from,
1323         address to,
1324         uint256 tokenId
1325     ) internal virtual {}
1326 }
1327 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1328     // Mapping from owner to list of owned token IDs
1329     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1330 
1331     // Mapping from token ID to index of the owner tokens list
1332     mapping(uint256 => uint256) private _ownedTokensIndex;
1333 
1334     // Array with all token ids, used for enumeration
1335     uint256[] private _allTokens;
1336 
1337     // Mapping from token id to position in the allTokens array
1338     mapping(uint256 => uint256) private _allTokensIndex;
1339 
1340     /**
1341      * @dev See {IERC165-supportsInterface}.
1342      */
1343     function supportsInterface(bytes4 interfaceId)
1344         public
1345         view
1346         virtual
1347         override(IERC165, ERC721)
1348         returns (bool)
1349     {
1350         return
1351             interfaceId == type(IERC721Enumerable).interfaceId ||
1352             super.supportsInterface(interfaceId);
1353     }
1354 
1355     /**
1356      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1357      */
1358     function tokenOfOwnerByIndex(address owner, uint256 index)
1359         public
1360         view
1361         virtual
1362         override
1363         returns (uint256)
1364     {
1365         require(
1366             index < ERC721.balanceOf(owner),
1367             "ERC721Enumerable: owner index out of bounds"
1368         );
1369         return _ownedTokens[owner][index];
1370     }
1371 
1372     /**
1373      * @dev See {IERC721Enumerable-totalSupply}.
1374      */
1375     function totalSupply() public view virtual override returns (uint256) {
1376         return _allTokens.length;
1377     }
1378 
1379     /**
1380      * @dev See {IERC721Enumerable-tokenByIndex}.
1381      */
1382     function tokenByIndex(uint256 index)
1383         public
1384         view
1385         virtual
1386         override
1387         returns (uint256)
1388     {
1389         require(
1390             index < ERC721Enumerable.totalSupply(),
1391             "ERC721Enumerable: global index out of bounds"
1392         );
1393         return _allTokens[index];
1394     }
1395 
1396     /**
1397      * @dev Hook that is called before any token transfer. This includes minting
1398      * and burning.
1399      *
1400      * Calling conditions:
1401      *
1402      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1403      * transferred to `to`.
1404      * - When `from` is zero, `tokenId` will be minted for `to`.
1405      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1406      * - `from` cannot be the zero address.
1407      * - `to` cannot be the zero address.
1408      *
1409      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1410      */
1411     function _beforeTokenTransfer(
1412         address from,
1413         address to,
1414         uint256 tokenId
1415     ) internal virtual override {
1416         super._beforeTokenTransfer(from, to, tokenId);
1417 
1418         if (from == address(0)) {
1419             _addTokenToAllTokensEnumeration(tokenId);
1420         } else if (from != to) {
1421             _removeTokenFromOwnerEnumeration(from, tokenId);
1422         }
1423         if (to == address(0)) {
1424             _removeTokenFromAllTokensEnumeration(tokenId);
1425         } else if (to != from) {
1426             _addTokenToOwnerEnumeration(to, tokenId);
1427         }
1428     }
1429 
1430     /**
1431      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1432      * @param to address representing the new owner of the given token ID
1433      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1434      */
1435     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1436         uint256 length = ERC721.balanceOf(to);
1437         _ownedTokens[to][length] = tokenId;
1438         _ownedTokensIndex[tokenId] = length;
1439     }
1440 
1441     /**
1442      * @dev Private function to add a token to this extension's token tracking data structures.
1443      * @param tokenId uint256 ID of the token to be added to the tokens list
1444      */
1445     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1446         _allTokensIndex[tokenId] = _allTokens.length;
1447         _allTokens.push(tokenId);
1448     }
1449 
1450     /**
1451      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1452      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1453      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1454      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1455      * @param from address representing the previous owner of the given token ID
1456      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1457      */
1458     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1459         private
1460     {
1461         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1462         // then delete the last slot (swap and pop).
1463 
1464         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1465         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1466 
1467         // When the token to delete is the last token, the swap operation is unnecessary
1468         if (tokenIndex != lastTokenIndex) {
1469             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1470 
1471             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1472             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1473         }
1474 
1475         // This also deletes the contents at the last position of the array
1476         delete _ownedTokensIndex[tokenId];
1477         delete _ownedTokens[from][lastTokenIndex];
1478     }
1479 
1480     /**
1481      * @dev Private function to remove a token from this extension's token tracking data structures.
1482      * This has O(1) time complexity, but alters the order of the _allTokens array.
1483      * @param tokenId uint256 ID of the token to be removed from the tokens list
1484      */
1485     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1486         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1487         // then delete the last slot (swap and pop).
1488 
1489         uint256 lastTokenIndex = _allTokens.length - 1;
1490         uint256 tokenIndex = _allTokensIndex[tokenId];
1491 
1492         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1493         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1494         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1495         uint256 lastTokenId = _allTokens[lastTokenIndex];
1496 
1497         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1498         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1499 
1500         // This also deletes the contents at the last position of the array
1501         delete _allTokensIndex[tokenId];
1502         _allTokens.pop();
1503     }
1504 }
1505 contract Initializable {
1506     bool inited = false;
1507 
1508     modifier initializer() {
1509         require(!inited, "already inited");
1510         _;
1511         inited = true;
1512     }
1513 }
1514 contract Migrations {
1515   address public owner;
1516   uint public last_completed_migration;
1517 
1518   constructor() {
1519     owner = msg.sender;
1520   }
1521 
1522   modifier restricted() {
1523     if (msg.sender == owner) _;
1524   }
1525 
1526   function setCompleted(uint completed) public restricted {
1527     last_completed_migration = completed;
1528   }
1529 
1530   function upgrade(address new_address) public restricted {
1531     Migrations upgraded = Migrations(new_address);
1532     upgraded.setCompleted(last_completed_migration);
1533   }
1534 }
1535 contract EIP712Base is Initializable {
1536     struct EIP712Domain {
1537         string name;
1538         string version;
1539         address verifyingContract;
1540         bytes32 salt;
1541     }
1542 
1543     string public constant ERC712_VERSION = "1";
1544 
1545     bytes32 internal constant EIP712_DOMAIN_TYPEHASH =
1546         keccak256(
1547             bytes(
1548                 "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
1549             )
1550         );
1551     bytes32 internal domainSeperator;
1552 
1553     // supposed to be called once while initializing.
1554     // one of the contracts that inherits this contract follows proxy pattern
1555     // so it is not possible to do this in a constructor
1556     function _initializeEIP712(string memory name) internal initializer {
1557         _setDomainSeperator(name);
1558     }
1559 
1560     function _setDomainSeperator(string memory name) internal {
1561         domainSeperator = keccak256(
1562             abi.encode(
1563                 EIP712_DOMAIN_TYPEHASH,
1564                 keccak256(bytes(name)),
1565                 keccak256(bytes(ERC712_VERSION)),
1566                 address(this),
1567                 bytes32(getChainId())
1568             )
1569         );
1570     }
1571 
1572     function getDomainSeperator() public view returns (bytes32) {
1573         return domainSeperator;
1574     }
1575 
1576     function getChainId() public view returns (uint256) {
1577         uint256 id;
1578         assembly {
1579             id := chainid()
1580         }
1581         return id;
1582     }
1583 
1584     /**
1585      * Accept message hash and returns hash message in EIP712 compatible form
1586      * So that it can be used to recover signer from signature signed using EIP712 formatted data
1587      * https://eips.ethereum.org/EIPS/eip-712
1588      * "\\x19" makes the encoding deterministic
1589      * "\\x01" is the version byte to make it compatible to EIP-191
1590      */
1591     function toTypedMessageHash(bytes32 messageHash)
1592         internal
1593         view
1594         returns (bytes32)
1595     {
1596         return
1597             keccak256(
1598                 abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
1599             );
1600     }
1601 }
1602 contract NativeMetaTransaction is EIP712Base {
1603     using SafeMath for uint256;
1604     bytes32 private constant META_TRANSACTION_TYPEHASH =
1605         keccak256(
1606             bytes(
1607                 "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
1608             )
1609         );
1610     event MetaTransactionExecuted(
1611         address userAddress,
1612         address payable relayerAddress,
1613         bytes functionSignature
1614     );
1615     mapping(address => uint256) nonces;
1616 
1617     /*
1618      * Meta transaction structure.
1619      * No point of including value field here as if user is doing value transfer then he has the funds to pay for gas
1620      * He should call the desired function directly in that case.
1621      */
1622     struct MetaTransaction {
1623         uint256 nonce;
1624         address from;
1625         bytes functionSignature;
1626     }
1627 
1628     function executeMetaTransaction(
1629         address userAddress,
1630         bytes memory functionSignature,
1631         bytes32 sigR,
1632         bytes32 sigS,
1633         uint8 sigV
1634     ) public payable returns (bytes memory) {
1635         MetaTransaction memory metaTx = MetaTransaction({
1636             nonce: nonces[userAddress],
1637             from: userAddress,
1638             functionSignature: functionSignature
1639         });
1640 
1641         require(
1642             verify(userAddress, metaTx, sigR, sigS, sigV),
1643             "Signer and signature do not match"
1644         );
1645 
1646         // increase nonce for user (to avoid re-use)
1647         nonces[userAddress] = nonces[userAddress].add(1);
1648 
1649         emit MetaTransactionExecuted(
1650             userAddress,
1651             payable(msg.sender),
1652             functionSignature
1653         );
1654 
1655         // Append userAddress and relayer address at the end to extract it from calling context
1656         (bool success, bytes memory returnData) = address(this).call(
1657             abi.encodePacked(functionSignature, userAddress)
1658         );
1659         require(success, "Function call not successful");
1660 
1661         return returnData;
1662     }
1663 
1664     function hashMetaTransaction(MetaTransaction memory metaTx)
1665         internal
1666         pure
1667         returns (bytes32)
1668     {
1669         return
1670             keccak256(
1671                 abi.encode(
1672                     META_TRANSACTION_TYPEHASH,
1673                     metaTx.nonce,
1674                     metaTx.from,
1675                     keccak256(metaTx.functionSignature)
1676                 )
1677             );
1678     }
1679 
1680     function getNonce(address user) public view returns (uint256 nonce) {
1681         nonce = nonces[user];
1682     }
1683 
1684     function verify(
1685         address signer,
1686         MetaTransaction memory metaTx,
1687         bytes32 sigR,
1688         bytes32 sigS,
1689         uint8 sigV
1690     ) internal view returns (bool) {
1691         require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
1692         return
1693             signer ==
1694             ecrecover(
1695                 toTypedMessageHash(hashMetaTransaction(metaTx)),
1696                 sigV,
1697                 sigR,
1698                 sigS
1699             );
1700     }
1701 }
1702 
1703 interface ISpaceBoy {
1704     function balanceOf(address owner) external view returns (uint256);
1705     function tokenOfOwnerByIndex(address owner, uint256 tokenIndex) external view returns (uint256);
1706 }
1707 
1708 
1709 contract SpaceAliens is
1710     ContextMixin,
1711     ERC721Enumerable,
1712     NativeMetaTransaction,
1713     Ownable
1714 {
1715     using SafeMath for uint256;
1716 
1717     uint256 public special = 4;
1718 
1719     bool public reveal_special_1 = false;
1720     bool public reveal_special_2 = false;
1721     bool public reveal_special_3 = false;
1722     bool public reveal_special_4 = false;
1723     bool public reveal_all = false;
1724 
1725     uint256 public _currentGroup1TokenId = special;
1726     uint256 public _currentGroup2TokenId = 1000;
1727 
1728     uint256 MAX_SUPPLY =  3000;
1729     uint256 Group1_MAX_SUPPLY =  1000;
1730     
1731     string public baseTokenURI = "https://gateway.pinata.cloud/ipfs/QmTA1TvKGRGfeYKYWM87Bs2CrBauNmXkNm11Hk2di1rew8/";
1732     string public waiting_special_url = "https://gateway.pinata.cloud/ipfs/QmeeVrEW44rvVhhzUTJkPEv95h5sMArYRm59qxP4yxSEQA";
1733     string public waiting_url = "https://gateway.pinata.cloud/ipfs/QmS6wFpvTh8mMV6tmatjssz5ysp7rqCJ52ahxdmrzWENS6";
1734    
1735     uint256 public Startdate = 1634174383; // Oct 15, 16:00:00 UTC - 1634313600
1736     uint256 public Enddate = 1634197253; // Oct 16, 16:00:00 UTC - 1634400000
1737 
1738     string _name = "SpaceAliensNFT";
1739     string _symbol = "SANFT";
1740     
1741     address SB_address = 0x672C1f1C978b8FD1E9AE18e25D0E55176824989c; // mainnet SB address 
1742     ISpaceBoy SpaceBoyContract = ISpaceBoy(SB_address);
1743     
1744     address[] public whitelistedAddresses;
1745     mapping(uint256 => uint256) public SB_claimed_token_list;
1746 
1747     constructor() ERC721(_name, _symbol) {
1748         _initializeEIP712(_name);
1749         mintSpecial(_msgSender());
1750     }
1751 
1752     function set_reveal_special_1(bool result) external onlyOwner{
1753         reveal_special_1 = result;
1754     }
1755     function set_reveal_special_2(bool result) external onlyOwner{
1756         reveal_special_2 = result;
1757     }
1758     function set_reveal_special_3(bool result) external onlyOwner{
1759         reveal_special_3 = result;
1760     }
1761     function set_reveal_special_4(bool result) external onlyOwner{
1762         reveal_special_4 = result;
1763     }
1764     function set_reveal_all(bool result) external onlyOwner{
1765         reveal_all = result;
1766     }
1767     
1768     function _checkSBTokenClaim(uint256 SB_balance) private view returns (uint256[] memory) {
1769         uint256[] memory SB_unclaim_token_list = new uint[](SB_balance);
1770         uint256 SB_unclaim_token_index = 0;
1771         uint256 SB_claimed_token_count = 0;
1772         
1773         
1774         for (uint i = 0; i < SB_balance; i++) {
1775           uint256 SB_tokenID = SpaceBoyContract.tokenOfOwnerByIndex(_msgSender(), i);
1776           if (SB_tokenID > 0 && SB_claimed_token_list[SB_tokenID] == 0) { // never claim before
1777               SB_unclaim_token_list[SB_unclaim_token_index] = SB_tokenID;
1778               SB_unclaim_token_index++;
1779           } else {
1780               SB_claimed_token_count ++;
1781           }
1782         }
1783         
1784         if(SB_claimed_token_count > 0) {
1785             return SB_unclaim_token_list = new uint[](0);
1786         } else {
1787             return SB_unclaim_token_list;
1788         }
1789     }
1790     
1791     function _setSBTokenClaim(uint256[] memory SB_unclaimed_token_list) private {
1792         for (uint i = 0; i < SB_unclaimed_token_list.length; i++) {
1793             SB_claimed_token_list[SB_unclaimed_token_list[i]] = 1;  
1794         }
1795     }
1796     
1797     function mintGroup1() public {
1798         require(block.timestamp > Startdate, "The claim have not started yet.");
1799         require(block.timestamp < Enddate, "The claim have Ended.");
1800         require(_currentGroup1TokenId + 1 < Group1_MAX_SUPPLY, "Max Supply Reached");
1801         require(balanceOf(_msgSender()) == 0, "You have already Claimed Nft.");
1802         
1803         //only owner of >= 7 spaceboys
1804         uint256 SB_balance = SpaceBoyContract.balanceOf(_msgSender());
1805         uint256 [] memory SB_unclaimed_token_list = _checkSBTokenClaim(SB_balance);
1806         require(SB_unclaimed_token_list.length >= 7, 'only owners of 7 or more spaceboys could mint!');
1807         
1808         _setSBTokenClaim(SB_unclaimed_token_list);
1809         _mint(_msgSender(), _getNextGroup1TokenId());
1810         _incrementGroup1TokenId();
1811     }
1812     
1813     function mintGroup2() external {
1814         require(block.timestamp > Startdate, "The claim have not started yet.");
1815         require(block.timestamp < Enddate, "The claim have Ended.");
1816         require(_currentGroup2TokenId + 1 < MAX_SUPPLY, "Max Supply Reached");
1817         require(balanceOf(_msgSender()) == 0, "You have already Claimed Nft.");
1818         
1819         //only owner of 3-6 spaceboys
1820         uint256 SB_balance = SpaceBoyContract.balanceOf(_msgSender());
1821         uint256 [] memory SB_unclaimed_token_list = _checkSBTokenClaim(SB_balance);
1822         require(SB_unclaimed_token_list.length >= 3, 'only owners of 3 - 6 spaceboys could mint!');
1823         require(SB_unclaimed_token_list.length < 7, 'only owners of 3 - 6 spaceboys could mint!');
1824         
1825         _setSBTokenClaim(SB_unclaimed_token_list);
1826         _mint(_msgSender(), _getNextGroup2TokenId());
1827         _incrementGroup2TokenId();
1828     }
1829     
1830     function mintGroup3() external {
1831         require(block.timestamp > Startdate, "The claim have not started yet.");
1832         require(block.timestamp < Enddate, "The claim have Ended.");
1833         require(_currentGroup2TokenId + 1 < MAX_SUPPLY, "Max Supply Reached");
1834         require(isWhitelisted(_msgSender()) , "You are not in this group.");
1835         require(balanceOf(_msgSender()) == 0, "You have already Claimed Nft.");
1836 
1837         _mint(_msgSender(), _getNextGroup2TokenId());
1838         _incrementGroup2TokenId();
1839     }
1840     
1841     ////////
1842     
1843     //Owner Mint Functions
1844     function mintSpecial(address _to) public onlyOwner {
1845         for(uint256 i=0; i<special; i++){
1846             _mint(_to, i+1);
1847         }
1848     }
1849     
1850     function mintManyGroup1(uint256 num, address _to) public onlyOwner {
1851         require(_currentGroup1TokenId + num < Group1_MAX_SUPPLY, "Max Supply Reached");
1852         require(num <= 20, "Max 20 Allowed.");
1853         
1854         for(uint256 i=0; i<num; i++){
1855             _mint(_to, _getNextGroup1TokenId());
1856             _incrementGroup1TokenId();
1857         }
1858     }
1859     
1860     function mintManyGroup2(uint256 num, address _to) public onlyOwner {
1861         require(_currentGroup2TokenId + num < MAX_SUPPLY, "Max Supply Reached");
1862         require(num <= 20, "Max 20 Allowed.");
1863         
1864         for(uint256 i=0; i<num; i++){
1865             _mint(_to, _getNextGroup2TokenId());
1866             _incrementGroup2TokenId();
1867         }
1868     }
1869     
1870     
1871   function isWhitelisted(address _user) public view returns (bool) {
1872     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1873       if (whitelistedAddresses[i] == _user) {
1874           return true;
1875       }
1876     }
1877     return false;
1878   }
1879   
1880   function whitelistUsers(address[] calldata _users) public onlyOwner {
1881     delete whitelistedAddresses;
1882     whitelistedAddresses = _users;
1883   }
1884   
1885   
1886   function withdraw() external onlyOwner {
1887         payable(owner()).transfer(address(this).balance);
1888     }
1889 
1890     function _getNextGroup1TokenId() private view returns (uint256) {
1891         return _currentGroup1TokenId.add(1);
1892     }
1893 
1894 
1895     function _incrementGroup1TokenId() private {
1896         require(_currentGroup1TokenId < Group1_MAX_SUPPLY);
1897 
1898         _currentGroup1TokenId++;
1899     }
1900     
1901     function _getNextGroup2TokenId() private view returns (uint256) {
1902         return _currentGroup2TokenId.add(1);
1903     }
1904 
1905     function _incrementGroup2TokenId() private {
1906         require(_currentGroup2TokenId < MAX_SUPPLY);
1907 
1908         _currentGroup2TokenId++;
1909     }
1910 
1911     function setBaseUri(string memory _uri) external onlyOwner {
1912         baseTokenURI = _uri;
1913     }
1914 
1915     function set_dates(uint256 start, uint256 end) external onlyOwner{
1916         Startdate = start;
1917         Enddate = end;
1918     }
1919 
1920     function tokenURI(uint256 _tokenId)
1921         public
1922         view
1923         override
1924         returns (string memory)
1925     {
1926         if (_tokenId == 1 && reveal_special_1 == false) {
1927             return waiting_special_url;
1928         }
1929         else if(_tokenId == 2 && reveal_special_2 == false) {
1930             return waiting_special_url;
1931         }
1932         else if(_tokenId == 3 && reveal_special_3 == false) {
1933             return waiting_special_url;
1934         }
1935         else if(_tokenId == 4 && reveal_special_4 == false) {
1936             return waiting_special_url;
1937         }
1938         else if(reveal_all == false) {
1939             return waiting_url;
1940         }
1941         
1942         return string(abi.encodePacked(baseTokenURI, Strings.toString(_tokenId), ".json"));
1943     }
1944 
1945     function _msgSender() internal view override returns (address sender) {
1946         return ContextMixin.msgSender();
1947     }
1948     function increaseMaxSupply(uint256 temp) external onlyOwner {
1949         MAX_SUPPLY = MAX_SUPPLY + temp;
1950     }
1951   
1952     
1953 }