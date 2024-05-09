1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 //Written by blockchainguy.net
4 library SafeMath {
5     /**
6      * @dev Returns the addition of two unsigned integers, with an overflow flag.
7      *
8      * _Available since v3.4._
9      */
10     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
11         unchecked {
12             uint256 c = a + b;
13             if (c < a) return (false, 0);
14             return (true, c);
15         }
16     }
17 
18     /**
19      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
20      *
21      * _Available since v3.4._
22      */
23     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         unchecked {
25             if (b > a) return (false, 0);
26             return (true, a - b);
27         }
28     }
29 
30     /**
31      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
32      *
33      * _Available since v3.4._
34      */
35     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
36         unchecked {
37             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
38             // benefit is lost if 'b' is also tested.
39             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
40             if (a == 0) return (true, 0);
41             uint256 c = a * b;
42             if (c / a != b) return (false, 0);
43             return (true, c);
44         }
45     }
46 
47     /**
48      * @dev Returns the division of two unsigned integers, with a division by zero flag.
49      *
50      * _Available since v3.4._
51      */
52     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
53         unchecked {
54             if (b == 0) return (false, 0);
55             return (true, a / b);
56         }
57     }
58 
59     /**
60      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
61      *
62      * _Available since v3.4._
63      */
64     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
65         unchecked {
66             if (b == 0) return (false, 0);
67             return (true, a % b);
68         }
69     }
70 
71     /**
72      * @dev Returns the addition of two unsigned integers, reverting on
73      * overflow.
74      *
75      * Counterpart to Solidity's `+` operator.
76      *
77      * Requirements:
78      *
79      * - Addition cannot overflow.
80      */
81     function add(uint256 a, uint256 b) internal pure returns (uint256) {
82         return a + b;
83     }
84 
85     /**
86      * @dev Returns the subtraction of two unsigned integers, reverting on
87      * overflow (when the result is negative).
88      *
89      * Counterpart to Solidity's `-` operator.
90      *
91      * Requirements:
92      *
93      * - Subtraction cannot overflow.
94      */
95     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a - b;
97     }
98 
99     /**
100      * @dev Returns the multiplication of two unsigned integers, reverting on
101      * overflow.
102      *
103      * Counterpart to Solidity's `*` operator.
104      *
105      * Requirements:
106      *
107      * - Multiplication cannot overflow.
108      */
109     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a * b;
111     }
112 
113     /**
114      * @dev Returns the integer division of two unsigned integers, reverting on
115      * division by zero. The result is rounded towards zero.
116      *
117      * Counterpart to Solidity's `/` operator.
118      *
119      * Requirements:
120      *
121      * - The divisor cannot be zero.
122      */
123     function div(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a / b;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * reverting when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return a % b;
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
145      * overflow (when the result is negative).
146      *
147      * CAUTION: This function is deprecated because it requires allocating memory for the error
148      * message unnecessarily. For custom revert reasons use {trySub}.
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      *
154      * - Subtraction cannot overflow.
155      */
156     function sub(
157         uint256 a,
158         uint256 b,
159         string memory errorMessage
160     ) internal pure returns (uint256) {
161         unchecked {
162             require(b <= a, errorMessage);
163             return a - b;
164         }
165     }
166 
167     /**
168      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
169      * division by zero. The result is rounded towards zero.
170      *
171      * Counterpart to Solidity's `/` operator. Note: this function uses a
172      * `revert` opcode (which leaves remaining gas untouched) while Solidity
173      * uses an invalid opcode to revert (consuming all remaining gas).
174      *
175      * Requirements:
176      *
177      * - The divisor cannot be zero.
178      */
179     function div(
180         uint256 a,
181         uint256 b,
182         string memory errorMessage
183     ) internal pure returns (uint256) {
184         unchecked {
185             require(b > 0, errorMessage);
186             return a / b;
187         }
188     }
189 
190     /**
191      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
192      * reverting with custom message when dividing by zero.
193      *
194      * CAUTION: This function is deprecated because it requires allocating memory for the error
195      * message unnecessarily. For custom revert reasons use {tryMod}.
196      *
197      * Counterpart to Solidity's `%` operator. This function uses a `revert`
198      * opcode (which leaves remaining gas untouched) while Solidity uses an
199      * invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function mod(
206         uint256 a,
207         uint256 b,
208         string memory errorMessage
209     ) internal pure returns (uint256) {
210         unchecked {
211             require(b > 0, errorMessage);
212             return a % b;
213         }
214     }
215 }
216 library Strings {
217     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
218 
219     /**
220      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
221      */
222     function toString(uint256 value) internal pure returns (string memory) {
223         // Inspired by OraclizeAPI's implementation - MIT licence
224         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
225 
226         if (value == 0) {
227             return "0";
228         }
229         uint256 temp = value;
230         uint256 digits;
231         while (temp != 0) {
232             digits++;
233             temp /= 10;
234         }
235         bytes memory buffer = new bytes(digits);
236         while (value != 0) {
237             digits -= 1;
238             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
239             value /= 10;
240         }
241         return string(buffer);
242     }
243 
244     /**
245      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
246      */
247     function toHexString(uint256 value) internal pure returns (string memory) {
248         if (value == 0) {
249             return "0x00";
250         }
251         uint256 temp = value;
252         uint256 length = 0;
253         while (temp != 0) {
254             length++;
255             temp >>= 8;
256         }
257         return toHexString(value, length);
258     }
259 
260     /**
261      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
262      */
263     function toHexString(uint256 value, uint256 length)
264         internal
265         pure
266         returns (string memory)
267     {
268         bytes memory buffer = new bytes(2 * length + 2);
269         buffer[0] = "0";
270         buffer[1] = "x";
271         for (uint256 i = 2 * length + 1; i > 1; --i) {
272             buffer[i] = _HEX_SYMBOLS[value & 0xf];
273             value >>= 4;
274         }
275         require(value == 0, "Strings: hex length insufficient");
276         return string(buffer);
277     }
278 }
279 
280 interface IERC165 {
281     /**
282      * @dev Returns true if this contract implements the interface defined by
283      * `interfaceId`. See the corresponding
284      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
285      * to learn more about how these ids are created.
286      *
287      * This function call must use less than 30 000 gas.
288      */
289     function supportsInterface(bytes4 interfaceId) external view returns (bool);
290 }
291 interface IERC721 is IERC165 {
292     /**
293      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
294      */
295     event Transfer(
296         address indexed from,
297         address indexed to,
298         uint256 indexed tokenId
299     );
300 
301     /**
302      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
303      */
304     event Approval(
305         address indexed owner,
306         address indexed approved,
307         uint256 indexed tokenId
308     );
309 
310     /**
311      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
312      */
313     event ApprovalForAll(
314         address indexed owner,
315         address indexed operator,
316         bool approved
317     );
318 
319     /**
320      * @dev Returns the number of tokens in ``owner``'s account.
321      */
322     function balanceOf(address owner) external view returns (uint256 balance);
323 
324     /**
325      * @dev Returns the owner of the `tokenId` token.
326      *
327      * Requirements:
328      *
329      * - `tokenId` must exist.
330      */
331     function ownerOf(uint256 tokenId) external view returns (address owner);
332 
333     /**
334      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
335      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
336      *
337      * Requirements:
338      *
339      * - `from` cannot be the zero address.
340      * - `to` cannot be the zero address.
341      * - `tokenId` token must exist and be owned by `from`.
342      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
343      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
344      *
345      * Emits a {Transfer} event.
346      */
347     function safeTransferFrom(
348         address from,
349         address to,
350         uint256 tokenId
351     ) external;
352 
353     /**
354      * @dev Transfers `tokenId` token from `from` to `to`.
355      *
356      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
357      *
358      * Requirements:
359      *
360      * - `from` cannot be the zero address.
361      * - `to` cannot be the zero address.
362      * - `tokenId` token must be owned by `from`.
363      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
364      *
365      * Emits a {Transfer} event.
366      */
367     function transferFrom(
368         address from,
369         address to,
370         uint256 tokenId
371     ) external;
372 
373     /**
374      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
375      * The approval is cleared when the token is transferred.
376      *
377      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
378      *
379      * Requirements:
380      *
381      * - The caller must own the token or be an approved operator.
382      * - `tokenId` must exist.
383      *
384      * Emits an {Approval} event.
385      */
386     function approve(address to, uint256 tokenId) external;
387 
388     /**
389      * @dev Returns the account approved for `tokenId` token.
390      *
391      * Requirements:
392      *
393      * - `tokenId` must exist.
394      */
395     function getApproved(uint256 tokenId)
396         external
397         view
398         returns (address operator);
399 
400     /**
401      * @dev Approve or remove `operator` as an operator for the caller.
402      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
403      *
404      * Requirements:
405      *
406      * - The `operator` cannot be the caller.
407      *
408      * Emits an {ApprovalForAll} event.
409      */
410     function setApprovalForAll(address operator, bool _approved) external;
411 
412     /**
413      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
414      *
415      * See {setApprovalForAll}
416      */
417     function isApprovedForAll(address owner, address operator)
418         external
419         view
420         returns (bool);
421 
422     /**
423      * @dev Safely transfers `tokenId` token from `from` to `to`.
424      *
425      * Requirements:
426      *
427      * - `from` cannot be the zero address.
428      * - `to` cannot be the zero address.
429      * - `tokenId` token must exist and be owned by `from`.
430      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
431      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
432      *
433      * Emits a {Transfer} event.
434      */
435     function safeTransferFrom(
436         address from,
437         address to,
438         uint256 tokenId,
439         bytes calldata data
440     ) external;
441 }
442 interface IERC721Enumerable is IERC721 {
443     /**
444      * @dev Returns the total amount of tokens stored by the contract.
445      */
446     function totalSupply() external view returns (uint256);
447 
448     /**
449      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
450      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
451      */
452     function tokenOfOwnerByIndex(address owner, uint256 index)
453         external
454         view
455         returns (uint256 tokenId);
456 
457     /**
458      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
459      * Use along with {totalSupply} to enumerate all tokens.
460      */
461     function tokenByIndex(uint256 index) external view returns (uint256);
462 }
463 interface IERC721Metadata is IERC721 {
464     /**
465      * @dev Returns the token collection name.
466      */
467     function name() external view returns (string memory);
468 
469     /**
470      * @dev Returns the token collection symbol.
471      */
472     function symbol() external view returns (string memory);
473 
474     /**
475      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
476      */
477     function tokenURI(uint256 tokenId) external view returns (string memory);
478 }
479 interface IERC721Receiver {
480     /**
481      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
482      * by `operator` from `from`, this function is called.
483      *
484      * It must return its Solidity selector to confirm the token transfer.
485      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
486      *
487      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
488      */
489     function onERC721Received(
490         address operator,
491         address from,
492         uint256 tokenId,
493         bytes calldata data
494     ) external returns (bytes4);
495 }
496 library Address {
497     /**
498      * @dev Returns true if `account` is a contract.
499      *
500      * [IMPORTANT]
501      * ====
502      * It is unsafe to assume that an address for which this function returns
503      * false is an externally-owned account (EOA) and not a contract.
504      *
505      * Among others, `isContract` will return false for the following
506      * types of addresses:
507      *
508      *  - an externally-owned account
509      *  - a contract in construction
510      *  - an address where a contract will be created
511      *  - an address where a contract lived, but was destroyed
512      * ====
513      */
514     function isContract(address account) internal view returns (bool) {
515         // This method relies on extcodesize, which returns 0 for contracts in
516         // construction, since the code is only stored at the end of the
517         // constructor execution.
518 
519         uint256 size;
520         assembly {
521             size := extcodesize(account)
522         }
523         return size > 0;
524     }
525 
526     /**
527      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
528      * `recipient`, forwarding all available gas and reverting on errors.
529      *
530      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
531      * of certain opcodes, possibly making contracts go over the 2300 gas limit
532      * imposed by `transfer`, making them unable to receive funds via
533      * `transfer`. {sendValue} removes this limitation.
534      *
535      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
536      *
537      * IMPORTANT: because control is transferred to `recipient`, care must be
538      * taken to not create reentrancy vulnerabilities. Consider using
539      * {ReentrancyGuard} or the
540      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
541      */
542     function sendValue(address payable recipient, uint256 amount) internal {
543         require(
544             address(this).balance >= amount,
545             "Address: insufficient balance"
546         );
547 
548         (bool success, ) = recipient.call{value: amount}("");
549         require(
550             success,
551             "Address: unable to send value, recipient may have reverted"
552         );
553     }
554 
555     /**
556      * @dev Performs a Solidity function call using a low level `call`. A
557      * plain `call` is an unsafe replacement for a function call: use this
558      * function instead.
559      *
560      * If `target` reverts with a revert reason, it is bubbled up by this
561      * function (like regular Solidity function calls).
562      *
563      * Returns the raw returned data. To convert to the expected return value,
564      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
565      *
566      * Requirements:
567      *
568      * - `target` must be a contract.
569      * - calling `target` with `data` must not revert.
570      *
571      * _Available since v3.1._
572      */
573     function functionCall(address target, bytes memory data)
574         internal
575         returns (bytes memory)
576     {
577         return functionCall(target, data, "Address: low-level call failed");
578     }
579 
580     /**
581      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
582      * `errorMessage` as a fallback revert reason when `target` reverts.
583      *
584      * _Available since v3.1._
585      */
586     function functionCall(
587         address target,
588         bytes memory data,
589         string memory errorMessage
590     ) internal returns (bytes memory) {
591         return functionCallWithValue(target, data, 0, errorMessage);
592     }
593 
594     /**
595      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
596      * but also transferring `value` wei to `target`.
597      *
598      * Requirements:
599      *
600      * - the calling contract must have an ETH balance of at least `value`.
601      * - the called Solidity function must be `payable`.
602      *
603      * _Available since v3.1._
604      */
605     function functionCallWithValue(
606         address target,
607         bytes memory data,
608         uint256 value
609     ) internal returns (bytes memory) {
610         return
611             functionCallWithValue(
612                 target,
613                 data,
614                 value,
615                 "Address: low-level call with value failed"
616             );
617     }
618 
619     /**
620      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
621      * with `errorMessage` as a fallback revert reason when `target` reverts.
622      *
623      * _Available since v3.1._
624      */
625     function functionCallWithValue(
626         address target,
627         bytes memory data,
628         uint256 value,
629         string memory errorMessage
630     ) internal returns (bytes memory) {
631         require(
632             address(this).balance >= value,
633             "Address: insufficient balance for call"
634         );
635         require(isContract(target), "Address: call to non-contract");
636 
637         (bool success, bytes memory returndata) = target.call{value: value}(
638             data
639         );
640         return verifyCallResult(success, returndata, errorMessage);
641     }
642 
643     /**
644      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
645      * but performing a static call.
646      *
647      * _Available since v3.3._
648      */
649     function functionStaticCall(address target, bytes memory data)
650         internal
651         view
652         returns (bytes memory)
653     {
654         return
655             functionStaticCall(
656                 target,
657                 data,
658                 "Address: low-level static call failed"
659             );
660     }
661 
662     /**
663      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
664      * but performing a static call.
665      *
666      * _Available since v3.3._
667      */
668     function functionStaticCall(
669         address target,
670         bytes memory data,
671         string memory errorMessage
672     ) internal view returns (bytes memory) {
673         require(isContract(target), "Address: static call to non-contract");
674 
675         (bool success, bytes memory returndata) = target.staticcall(data);
676         return verifyCallResult(success, returndata, errorMessage);
677     }
678 
679     /**
680      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
681      * but performing a delegate call.
682      *
683      * _Available since v3.4._
684      */
685     function functionDelegateCall(address target, bytes memory data)
686         internal
687         returns (bytes memory)
688     {
689         return
690             functionDelegateCall(
691                 target,
692                 data,
693                 "Address: low-level delegate call failed"
694             );
695     }
696 
697     /**
698      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
699      * but performing a delegate call.
700      *
701      * _Available since v3.4._
702      */
703     function functionDelegateCall(
704         address target,
705         bytes memory data,
706         string memory errorMessage
707     ) internal returns (bytes memory) {
708         require(isContract(target), "Address: delegate call to non-contract");
709 
710         (bool success, bytes memory returndata) = target.delegatecall(data);
711         return verifyCallResult(success, returndata, errorMessage);
712     }
713 
714     /**
715      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
716      * revert reason using the provided one.
717      *
718      * _Available since v4.3._
719      */
720     function verifyCallResult(
721         bool success,
722         bytes memory returndata,
723         string memory errorMessage
724     ) internal pure returns (bytes memory) {
725         if (success) {
726             return returndata;
727         } else {
728             // Look for revert reason and bubble it up if present
729             if (returndata.length > 0) {
730                 // The easiest way to bubble the revert reason is using memory via assembly
731 
732                 assembly {
733                     let returndata_size := mload(returndata)
734                     revert(add(32, returndata), returndata_size)
735                 }
736             } else {
737                 revert(errorMessage);
738             }
739         }
740     }
741 }
742 abstract contract ContextMixin {
743     function msgSender() internal view returns (address payable sender) {
744         if (msg.sender == address(this)) {
745             bytes memory array = msg.data;
746             uint256 index = msg.data.length;
747             assembly {
748                 // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
749                 sender := and(
750                     mload(add(array, index)),
751                     0xffffffffffffffffffffffffffffffffffffffff
752                 )
753             }
754         } else {
755             sender = payable(msg.sender);
756         }
757         return sender;
758     }
759 }
760 abstract contract Context {
761     function _msgSender() internal view virtual returns (address) {
762         return msg.sender;
763     }
764 
765     function _msgData() internal view virtual returns (bytes calldata) {
766         return msg.data;
767     }
768 }
769 abstract contract Ownable is Context {
770     address private _owner;
771 
772     event OwnershipTransferred(
773         address indexed previousOwner,
774         address indexed newOwner
775     );
776 
777     /**
778      * @dev Initializes the contract setting the deployer as the initial owner.
779      */
780     constructor() {
781         _setOwner(_msgSender());
782     }
783 
784     /**
785      * @dev Returns the address of the current owner.
786      */
787     function owner() public view virtual returns (address) {
788         return _owner;
789     }
790 
791     /**
792      * @dev Throws if called by any account other than the owner.
793      */
794     modifier onlyOwner() {
795         require(owner() == _msgSender(), "Ownable: caller is not the owner");
796         _;
797     }
798 
799     /**
800      * @dev Leaves the contract without owner. It will not be possible to call
801      * `onlyOwner` functions anymore. Can only be called by the current owner.
802      *
803      * NOTE: Renouncing ownership will leave the contract without an owner,
804      * thereby removing any functionality that is only available to the owner.
805      */
806     function renounceOwnership() public virtual onlyOwner {
807         _setOwner(address(0));
808     }
809 
810     /**
811      * @dev Transfers ownership of the contract to a new account (`newOwner`).
812      * Can only be called by the current owner.
813      */
814     function transferOwnership(address newOwner) public virtual onlyOwner {
815         require(
816             newOwner != address(0),
817             "Ownable: new owner is the zero address"
818         );
819         _setOwner(newOwner);
820     }
821 
822     function _setOwner(address newOwner) private {
823         address oldOwner = _owner;
824         _owner = newOwner;
825         emit OwnershipTransferred(oldOwner, newOwner);
826     }
827 }
828 abstract contract ERC165 is IERC165 {
829     /**
830      * @dev See {IERC165-supportsInterface}.
831      */
832     function supportsInterface(bytes4 interfaceId)
833         public
834         view
835         virtual
836         override
837         returns (bool)
838     {
839         return interfaceId == type(IERC165).interfaceId;
840     }
841 }
842 
843 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
844     using Address for address;
845     using Strings for uint256;
846 
847     // Token name
848     string private _name;
849 
850     // Token symbol
851     string private _symbol;
852 
853     // Mapping from token ID to owner address
854     mapping(uint256 => address) private _owners;
855 
856     // Mapping owner address to token count
857     mapping(address => uint256) private _balances;
858 
859     // Mapping from token ID to approved address
860     mapping(uint256 => address) private _tokenApprovals;
861 
862     // Mapping from owner to operator approvals
863     mapping(address => mapping(address => bool)) private _operatorApprovals;
864 
865     /**
866      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
867      */
868     constructor(string memory name_, string memory symbol_) {
869         _name = name_;
870         _symbol = symbol_;
871     }
872 
873     /**
874      * @dev See {IERC165-supportsInterface}.
875      */
876     function supportsInterface(bytes4 interfaceId)
877         public
878         view
879         virtual
880         override(ERC165, IERC165)
881         returns (bool)
882     {
883         return
884             interfaceId == type(IERC721).interfaceId ||
885             interfaceId == type(IERC721Metadata).interfaceId ||
886             super.supportsInterface(interfaceId);
887     }
888 
889     /**
890      * @dev See {IERC721-balanceOf}.
891      */
892     function balanceOf(address owner)
893         public
894         view
895         virtual
896         override
897         returns (uint256)
898     {
899         require(
900             owner != address(0),
901             "ERC721: balance query for the zero address"
902         );
903         return _balances[owner];
904     }
905 
906     /**
907      * @dev See {IERC721-ownerOf}.
908      */
909     function ownerOf(uint256 tokenId)
910         public
911         view
912         virtual
913         override
914         returns (address)
915     {
916         address owner = _owners[tokenId];
917         require(
918             owner != address(0),
919             "ERC721: owner query for nonexistent token"
920         );
921         return owner;
922     }
923 
924     /**
925      * @dev See {IERC721Metadata-name}.
926      */
927     function name() public view virtual override returns (string memory) {
928         return _name;
929     }
930 
931     /**
932      * @dev See {IERC721Metadata-symbol}.
933      */
934     function symbol() public view virtual override returns (string memory) {
935         return _symbol;
936     }
937 
938     /**
939      * @dev See {IERC721Metadata-tokenURI}.
940      */
941     function tokenURI(uint256 tokenId)
942         public
943         view
944         virtual
945         override
946         returns (string memory)
947     {
948         require(
949             _exists(tokenId),
950             "ERC721Metadata: URI query for nonexistent token"
951         );
952 
953         string memory baseURI = _baseURI();
954         return
955             bytes(baseURI).length > 0
956                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
957                 : "";
958     }
959 
960     /**
961      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
962      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
963      * by default, can be overriden in child contracts.
964      */
965     function _baseURI() internal view virtual returns (string memory) {
966         return "";
967     }
968 
969     /**
970      * @dev See {IERC721-approve}.
971      */
972     function approve(address to, uint256 tokenId) public virtual override {
973         address owner = ERC721.ownerOf(tokenId);
974         require(to != owner, "ERC721: approval to current owner");
975 
976         require(
977             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
978             "ERC721: approve caller is not owner nor approved for all"
979         );
980 
981         _approve(to, tokenId);
982     }
983 
984     /**
985      * @dev See {IERC721-getApproved}.
986      */
987     function getApproved(uint256 tokenId)
988         public
989         view
990         virtual
991         override
992         returns (address)
993     {
994         require(
995             _exists(tokenId),
996             "ERC721: approved query for nonexistent token"
997         );
998 
999         return _tokenApprovals[tokenId];
1000     }
1001 
1002     /**
1003      * @dev See {IERC721-setApprovalForAll}.
1004      */
1005     function setApprovalForAll(address operator, bool approved)
1006         public
1007         virtual
1008         override
1009     {
1010         require(operator != _msgSender(), "ERC721: approve to caller");
1011 
1012         _operatorApprovals[_msgSender()][operator] = approved;
1013         emit ApprovalForAll(_msgSender(), operator, approved);
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-isApprovedForAll}.
1018      */
1019     function isApprovedForAll(address owner, address operator)
1020         public
1021         view
1022         virtual
1023         override
1024         returns (bool)
1025     {
1026         return _operatorApprovals[owner][operator];
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-transferFrom}.
1031      */
1032     function transferFrom(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) public virtual override {
1037         //solhint-disable-next-line max-line-length
1038         require(
1039             _isApprovedOrOwner(_msgSender(), tokenId),
1040             "ERC721: transfer caller is not owner nor approved"
1041         );
1042 
1043         _transfer(from, to, tokenId);
1044     }
1045 
1046     /**
1047      * @dev See {IERC721-safeTransferFrom}.
1048      */
1049     function safeTransferFrom(
1050         address from,
1051         address to,
1052         uint256 tokenId
1053     ) public virtual override {
1054         safeTransferFrom(from, to, tokenId, "");
1055     }
1056 
1057     /**
1058      * @dev See {IERC721-safeTransferFrom}.
1059      */
1060     function safeTransferFrom(
1061         address from,
1062         address to,
1063         uint256 tokenId,
1064         bytes memory _data
1065     ) public virtual override {
1066         require(
1067             _isApprovedOrOwner(_msgSender(), tokenId),
1068             "ERC721: transfer caller is not owner nor approved"
1069         );
1070         _safeTransfer(from, to, tokenId, _data);
1071     }
1072 
1073     /**
1074      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1075      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1076      *
1077      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1078      *
1079      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1080      * implement alternative mechanisms to perform token transfer, such as signature-based.
1081      *
1082      * Requirements:
1083      *
1084      * - `from` cannot be the zero address.
1085      * - `to` cannot be the zero address.
1086      * - `tokenId` token must exist and be owned by `from`.
1087      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1088      *
1089      * Emits a {Transfer} event.
1090      */
1091     function _safeTransfer(
1092         address from,
1093         address to,
1094         uint256 tokenId,
1095         bytes memory _data
1096     ) internal virtual {
1097         _transfer(from, to, tokenId);
1098         require(
1099             _checkOnERC721Received(from, to, tokenId, _data),
1100             "ERC721: transfer to non ERC721Receiver implementer"
1101         );
1102     }
1103 
1104     /**
1105      * @dev Returns whether `tokenId` exists.
1106      *
1107      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1108      *
1109      * Tokens start existing when they are minted (`_mint`),
1110      * and stop existing when they are burned (`_burn`).
1111      */
1112     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1113         return _owners[tokenId] != address(0);
1114     }
1115 
1116     /**
1117      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1118      *
1119      * Requirements:
1120      *
1121      * - `tokenId` must exist.
1122      */
1123     function _isApprovedOrOwner(address spender, uint256 tokenId)
1124         internal
1125         view
1126         virtual
1127         returns (bool)
1128     {
1129         require(
1130             _exists(tokenId),
1131             "ERC721: operator query for nonexistent token"
1132         );
1133         address owner = ERC721.ownerOf(tokenId);
1134         return (spender == owner ||
1135             getApproved(tokenId) == spender ||
1136             isApprovedForAll(owner, spender));
1137     }
1138 
1139     /**
1140      * @dev Safely mints `tokenId` and transfers it to `to`.
1141      *
1142      * Requirements:
1143      *
1144      * - `tokenId` must not exist.
1145      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1146      *
1147      * Emits a {Transfer} event.
1148      */
1149     function _safeMint(address to, uint256 tokenId) internal virtual {
1150         _safeMint(to, tokenId, "");
1151     }
1152 
1153     /**
1154      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1155      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1156      */
1157     function _safeMint(
1158         address to,
1159         uint256 tokenId,
1160         bytes memory _data
1161     ) internal virtual {
1162         _mint(to, tokenId);
1163         require(
1164             _checkOnERC721Received(address(0), to, tokenId, _data),
1165             "ERC721: transfer to non ERC721Receiver implementer"
1166         );
1167     }
1168 
1169     /**
1170      * @dev Mints `tokenId` and transfers it to `to`.
1171      *
1172      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1173      *
1174      * Requirements:
1175      *
1176      * - `tokenId` must not exist.
1177      * - `to` cannot be the zero address.
1178      *
1179      * Emits a {Transfer} event.
1180      */
1181     function _mint(address to, uint256 tokenId) internal virtual {
1182         require(to != address(0), "ERC721: mint to the zero address");
1183         require(!_exists(tokenId), "ERC721: token already minted");
1184 
1185         _beforeTokenTransfer(address(0), to, tokenId);
1186 
1187         _balances[to] += 1;
1188         _owners[tokenId] = to;
1189 
1190         emit Transfer(address(0), to, tokenId);
1191     }
1192 
1193     /**
1194      * @dev Destroys `tokenId`.
1195      * The approval is cleared when the token is burned.
1196      *
1197      * Requirements:
1198      *
1199      * - `tokenId` must exist.
1200      *
1201      * Emits a {Transfer} event.
1202      */
1203     function _burn(uint256 tokenId) internal virtual {
1204         address owner = ERC721.ownerOf(tokenId);
1205 
1206         _beforeTokenTransfer(owner, address(0), tokenId);
1207 
1208         // Clear approvals
1209         _approve(address(0), tokenId);
1210 
1211         _balances[owner] -= 1;
1212         delete _owners[tokenId];
1213 
1214         emit Transfer(owner, address(0), tokenId);
1215     }
1216 
1217     /**
1218      * @dev Transfers `tokenId` from `from` to `to`.
1219      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1220      *
1221      * Requirements:
1222      *
1223      * - `to` cannot be the zero address.
1224      * - `tokenId` token must be owned by `from`.
1225      *
1226      * Emits a {Transfer} event.
1227      */
1228     function _transfer(
1229         address from,
1230         address to,
1231         uint256 tokenId
1232     ) internal virtual {
1233         require(
1234             ERC721.ownerOf(tokenId) == from,
1235             "ERC721: transfer of token that is not own"
1236         );
1237         require(to != address(0), "ERC721: transfer to the zero address");
1238 
1239         _beforeTokenTransfer(from, to, tokenId);
1240 
1241         // Clear approvals from the previous owner
1242         _approve(address(0), tokenId);
1243 
1244         _balances[from] -= 1;
1245         _balances[to] += 1;
1246         _owners[tokenId] = to;
1247 
1248         emit Transfer(from, to, tokenId);
1249     }
1250 
1251     /**
1252      * @dev Approve `to` to operate on `tokenId`
1253      *
1254      * Emits a {Approval} event.
1255      */
1256     function _approve(address to, uint256 tokenId) internal virtual {
1257         _tokenApprovals[tokenId] = to;
1258         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1259     }
1260 
1261     /**
1262      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1263      * The call is not executed if the target address is not a contract.
1264      *
1265      * @param from address representing the previous owner of the given token ID
1266      * @param to target address that will receive the tokens
1267      * @param tokenId uint256 ID of the token to be transferred
1268      * @param _data bytes optional data to send along with the call
1269      * @return bool whether the call correctly returned the expected magic value
1270      */
1271     function _checkOnERC721Received(
1272         address from,
1273         address to,
1274         uint256 tokenId,
1275         bytes memory _data
1276     ) private returns (bool) {
1277         if (to.isContract()) {
1278             try
1279                 IERC721Receiver(to).onERC721Received(
1280                     _msgSender(),
1281                     from,
1282                     tokenId,
1283                     _data
1284                 )
1285             returns (bytes4 retval) {
1286                 return retval == IERC721Receiver.onERC721Received.selector;
1287             } catch (bytes memory reason) {
1288                 if (reason.length == 0) {
1289                     revert(
1290                         "ERC721: transfer to non ERC721Receiver implementer"
1291                     );
1292                 } else {
1293                     assembly {
1294                         revert(add(32, reason), mload(reason))
1295                     }
1296                 }
1297             }
1298         } else {
1299             return true;
1300         }
1301     }
1302 
1303     /**
1304      * @dev Hook that is called before any token transfer. This includes minting
1305      * and burning.
1306      *
1307      * Calling conditions:
1308      *
1309      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1310      * transferred to `to`.
1311      * - When `from` is zero, `tokenId` will be minted for `to`.
1312      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1313      * - `from` and `to` are never both zero.
1314      *
1315      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1316      */
1317     function _beforeTokenTransfer(
1318         address from,
1319         address to,
1320         uint256 tokenId
1321     ) internal virtual {}
1322 }
1323 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1324     // Mapping from owner to list of owned token IDs
1325     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1326 
1327     // Mapping from token ID to index of the owner tokens list
1328     mapping(uint256 => uint256) private _ownedTokensIndex;
1329 
1330     // Array with all token ids, used for enumeration
1331     uint256[] private _allTokens;
1332 
1333     // Mapping from token id to position in the allTokens array
1334     mapping(uint256 => uint256) private _allTokensIndex;
1335 
1336     /**
1337      * @dev See {IERC165-supportsInterface}.
1338      */
1339     function supportsInterface(bytes4 interfaceId)
1340         public
1341         view
1342         virtual
1343         override(IERC165, ERC721)
1344         returns (bool)
1345     {
1346         return
1347             interfaceId == type(IERC721Enumerable).interfaceId ||
1348             super.supportsInterface(interfaceId);
1349     }
1350 
1351     /**
1352      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1353      */
1354     function tokenOfOwnerByIndex(address owner, uint256 index)
1355         public
1356         view
1357         virtual
1358         override
1359         returns (uint256)
1360     {
1361         require(
1362             index < ERC721.balanceOf(owner),
1363             "ERC721Enumerable: owner index out of bounds"
1364         );
1365         return _ownedTokens[owner][index];
1366     }
1367 
1368     /**
1369      * @dev See {IERC721Enumerable-totalSupply}.
1370      */
1371     function totalSupply() public view virtual override returns (uint256) {
1372         return _allTokens.length;
1373     }
1374 
1375     /**
1376      * @dev See {IERC721Enumerable-tokenByIndex}.
1377      */
1378     function tokenByIndex(uint256 index)
1379         public
1380         view
1381         virtual
1382         override
1383         returns (uint256)
1384     {
1385         require(
1386             index < ERC721Enumerable.totalSupply(),
1387             "ERC721Enumerable: global index out of bounds"
1388         );
1389         return _allTokens[index];
1390     }
1391 
1392     /**
1393      * @dev Hook that is called before any token transfer. This includes minting
1394      * and burning.
1395      *
1396      * Calling conditions:
1397      *
1398      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1399      * transferred to `to`.
1400      * - When `from` is zero, `tokenId` will be minted for `to`.
1401      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1402      * - `from` cannot be the zero address.
1403      * - `to` cannot be the zero address.
1404      *
1405      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1406      */
1407     function _beforeTokenTransfer(
1408         address from,
1409         address to,
1410         uint256 tokenId
1411     ) internal virtual override {
1412         super._beforeTokenTransfer(from, to, tokenId);
1413 
1414         if (from == address(0)) {
1415             _addTokenToAllTokensEnumeration(tokenId);
1416         } else if (from != to) {
1417             _removeTokenFromOwnerEnumeration(from, tokenId);
1418         }
1419         if (to == address(0)) {
1420             _removeTokenFromAllTokensEnumeration(tokenId);
1421         } else if (to != from) {
1422             _addTokenToOwnerEnumeration(to, tokenId);
1423         }
1424     }
1425 
1426     /**
1427      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1428      * @param to address representing the new owner of the given token ID
1429      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1430      */
1431     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1432         uint256 length = ERC721.balanceOf(to);
1433         _ownedTokens[to][length] = tokenId;
1434         _ownedTokensIndex[tokenId] = length;
1435     }
1436 
1437     /**
1438      * @dev Private function to add a token to this extension's token tracking data structures.
1439      * @param tokenId uint256 ID of the token to be added to the tokens list
1440      */
1441     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1442         _allTokensIndex[tokenId] = _allTokens.length;
1443         _allTokens.push(tokenId);
1444     }
1445 
1446     /**
1447      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1448      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1449      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1450      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1451      * @param from address representing the previous owner of the given token ID
1452      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1453      */
1454     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1455         private
1456     {
1457         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1458         // then delete the last slot (swap and pop).
1459 
1460         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1461         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1462 
1463         // When the token to delete is the last token, the swap operation is unnecessary
1464         if (tokenIndex != lastTokenIndex) {
1465             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1466 
1467             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1468             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1469         }
1470 
1471         // This also deletes the contents at the last position of the array
1472         delete _ownedTokensIndex[tokenId];
1473         delete _ownedTokens[from][lastTokenIndex];
1474     }
1475 
1476     /**
1477      * @dev Private function to remove a token from this extension's token tracking data structures.
1478      * This has O(1) time complexity, but alters the order of the _allTokens array.
1479      * @param tokenId uint256 ID of the token to be removed from the tokens list
1480      */
1481     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1482         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1483         // then delete the last slot (swap and pop).
1484 
1485         uint256 lastTokenIndex = _allTokens.length - 1;
1486         uint256 tokenIndex = _allTokensIndex[tokenId];
1487 
1488         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1489         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1490         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1491         uint256 lastTokenId = _allTokens[lastTokenIndex];
1492 
1493         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1494         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1495 
1496         // This also deletes the contents at the last position of the array
1497         delete _allTokensIndex[tokenId];
1498         _allTokens.pop();
1499     }
1500 }
1501 contract Initializable {
1502     bool inited = false;
1503 
1504     modifier initializer() {
1505         require(!inited, "already inited");
1506         _;
1507         inited = true;
1508     }
1509 }
1510 contract Migrations {
1511   address public owner;
1512   uint public last_completed_migration;
1513 
1514   constructor() {
1515     owner = msg.sender;
1516   }
1517 
1518   modifier restricted() {
1519     if (msg.sender == owner) _;
1520   }
1521 
1522   function setCompleted(uint completed) public restricted {
1523     last_completed_migration = completed;
1524   }
1525 
1526   function upgrade(address new_address) public restricted {
1527     Migrations upgraded = Migrations(new_address);
1528     upgraded.setCompleted(last_completed_migration);
1529   }
1530 }
1531 contract EIP712Base is Initializable {
1532     struct EIP712Domain {
1533         string name;
1534         string version;
1535         address verifyingContract;
1536         bytes32 salt;
1537     }
1538 
1539     string public constant ERC712_VERSION = "1";
1540 
1541     bytes32 internal constant EIP712_DOMAIN_TYPEHASH =
1542         keccak256(
1543             bytes(
1544                 "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
1545             )
1546         );
1547     bytes32 internal domainSeperator;
1548 
1549     // supposed to be called once while initializing.
1550     // one of the contracts that inherits this contract follows proxy pattern
1551     // so it is not possible to do this in a constructor
1552     function _initializeEIP712(string memory name) internal initializer {
1553         _setDomainSeperator(name);
1554     }
1555 
1556     function _setDomainSeperator(string memory name) internal {
1557         domainSeperator = keccak256(
1558             abi.encode(
1559                 EIP712_DOMAIN_TYPEHASH,
1560                 keccak256(bytes(name)),
1561                 keccak256(bytes(ERC712_VERSION)),
1562                 address(this),
1563                 bytes32(getChainId())
1564             )
1565         );
1566     }
1567 
1568     function getDomainSeperator() public view returns (bytes32) {
1569         return domainSeperator;
1570     }
1571 
1572     function getChainId() public view returns (uint256) {
1573         uint256 id;
1574         assembly {
1575             id := chainid()
1576         }
1577         return id;
1578     }
1579 
1580     /**
1581      * Accept message hash and returns hash message in EIP712 compatible form
1582      * So that it can be used to recover signer from signature signed using EIP712 formatted data
1583      * https://eips.ethereum.org/EIPS/eip-712
1584      * "\\x19" makes the encoding deterministic
1585      * "\\x01" is the version byte to make it compatible to EIP-191
1586      */
1587     function toTypedMessageHash(bytes32 messageHash)
1588         internal
1589         view
1590         returns (bytes32)
1591     {
1592         return
1593             keccak256(
1594                 abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
1595             );
1596     }
1597 }
1598 contract NativeMetaTransaction is EIP712Base {
1599     using SafeMath for uint256;
1600     bytes32 private constant META_TRANSACTION_TYPEHASH =
1601         keccak256(
1602             bytes(
1603                 "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
1604             )
1605         );
1606     event MetaTransactionExecuted(
1607         address userAddress,
1608         address payable relayerAddress,
1609         bytes functionSignature
1610     );
1611     mapping(address => uint256) nonces;
1612 
1613     /*
1614      * Meta transaction structure.
1615      * No point of including value field here as if user is doing value transfer then he has the funds to pay for gas
1616      * He should call the desired function directly in that case.
1617      */
1618     struct MetaTransaction {
1619         uint256 nonce;
1620         address from;
1621         bytes functionSignature;
1622     }
1623 
1624     function executeMetaTransaction(
1625         address userAddress,
1626         bytes memory functionSignature,
1627         bytes32 sigR,
1628         bytes32 sigS,
1629         uint8 sigV
1630     ) public payable returns (bytes memory) {
1631         MetaTransaction memory metaTx = MetaTransaction({
1632             nonce: nonces[userAddress],
1633             from: userAddress,
1634             functionSignature: functionSignature
1635         });
1636 
1637         require(
1638             verify(userAddress, metaTx, sigR, sigS, sigV),
1639             "Signer and signature do not match"
1640         );
1641 
1642         // increase nonce for user (to avoid re-use)
1643         nonces[userAddress] = nonces[userAddress].add(1);
1644 
1645         emit MetaTransactionExecuted(
1646             userAddress,
1647             payable(msg.sender),
1648             functionSignature
1649         );
1650 
1651         // Append userAddress and relayer address at the end to extract it from calling context
1652         (bool success, bytes memory returnData) = address(this).call(
1653             abi.encodePacked(functionSignature, userAddress)
1654         );
1655         require(success, "Function call not successful");
1656 
1657         return returnData;
1658     }
1659 
1660     function hashMetaTransaction(MetaTransaction memory metaTx)
1661         internal
1662         pure
1663         returns (bytes32)
1664     {
1665         return
1666             keccak256(
1667                 abi.encode(
1668                     META_TRANSACTION_TYPEHASH,
1669                     metaTx.nonce,
1670                     metaTx.from,
1671                     keccak256(metaTx.functionSignature)
1672                 )
1673             );
1674     }
1675 
1676     function getNonce(address user) public view returns (uint256 nonce) {
1677         nonce = nonces[user];
1678     }
1679 
1680     function verify(
1681         address signer,
1682         MetaTransaction memory metaTx,
1683         bytes32 sigR,
1684         bytes32 sigS,
1685         uint8 sigV
1686     ) internal view returns (bool) {
1687         require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
1688         return
1689             signer ==
1690             ecrecover(
1691                 toTypedMessageHash(hashMetaTransaction(metaTx)),
1692                 sigV,
1693                 sigR,
1694                 sigS
1695             );
1696     }
1697 }
1698 
1699 
1700 contract Alienoids is
1701     ContextMixin,
1702     ERC721Enumerable,
1703     NativeMetaTransaction,
1704     Ownable
1705 {
1706     using SafeMath for uint256;
1707 
1708     uint256 public _currentTokenId = 0;
1709 
1710     uint256 MAX_SUPPLY =  9900;
1711     string public baseTokenURI;
1712     
1713     uint256 public presale_Startdate;
1714     uint256 public presale_Enddate;
1715     bool public end_presale = false;
1716     
1717     uint256 public NFT_price = 0.05 ether; 
1718 
1719     uint256 public startTime = block.timestamp;
1720     string _name = "Alienoids";
1721     string _symbol = "AL";
1722     
1723   address[] public whitelistedAddresses;
1724     
1725 
1726 
1727     constructor() ERC721(_name, _symbol) {
1728         // baseTokenURI = _uri;
1729         _initializeEIP712(_name);
1730     }
1731     
1732     function set_start_time(uint256 time) external onlyOwner{
1733         startTime = time;
1734     }
1735     function set_presale_dates(uint256 start, uint256 end) external onlyOwner{
1736         presale_Startdate = start;
1737         presale_Enddate = end;
1738     }
1739     function end_presale_manually() external onlyOwner{
1740         end_presale = true;
1741     }
1742     /**
1743      * @dev Mints a token to an address with a tokenURI.
1744      * @param _to address of the future owner of the token
1745      */
1746     function mintTo(address _to) public onlyOwner {
1747         require(_currentTokenId < MAX_SUPPLY, "Max Supply Reached");
1748         uint256 newTokenId = _getNextTokenId();
1749         _mint(_to, newTokenId);
1750         _incrementTokenId();
1751     }
1752     
1753     function mintPresale() external payable{
1754         require(block.timestamp > presale_Startdate, "Presale have not started yet.");
1755         require(block.timestamp < presale_Enddate, "Presale Ended.");
1756         require(_currentTokenId < MAX_SUPPLY, "Max Supply Reached");
1757         require(end_presale == false,"Presale Ended");
1758         require(isWhitelisted(_msgSender()) , "You are not Whitelisted.");
1759         require(msg.value == NFT_price, "Sent Amount Not Enough");
1760 
1761         _mint(msg.sender, _getNextTokenId());
1762         _incrementTokenId();
1763     }
1764     
1765     function mintManyPresale(uint256 num, address _to) external payable{
1766         require(block.timestamp > presale_Startdate, "Presale have not started yet.");
1767         require(block.timestamp < presale_Enddate, "Presale Ended.");
1768         require(_currentTokenId < MAX_SUPPLY, "Max Supply Reached");
1769         require(end_presale == false,"Presale Ended");
1770         require(isWhitelisted(_msgSender()) , "You are not Whitelisted.");
1771         require(num <= 20, "Max 20 Allowed.");
1772         require(msg.value == NFT_price.mul(num), "Sent Amount Not Enough");
1773         
1774         for(uint256 i=0; i<num; i++){
1775             _mint(_to,  _getNextTokenId());
1776             _incrementTokenId();
1777         }
1778     }
1779     
1780     function mintMany(uint256 num, address _to) public onlyOwner {
1781         require(_currentTokenId + num < MAX_SUPPLY, "Max Supply Reached");
1782         require(num <= 20, "Max 20 Allowed.");
1783         for(uint256 i=0; i<num; i++){
1784 
1785             _mint(_to, _getNextTokenId());
1786             _incrementTokenId();
1787         }
1788     }
1789     
1790 
1791     function buy() public payable {
1792         require(block.timestamp >= startTime, "It's not time yet");
1793         require(msg.value == NFT_price, "Sent Amount Not Enough");
1794         require(_currentTokenId < MAX_SUPPLY, "Max Supply Reached");
1795     
1796 
1797             _mint(msg.sender, _getNextTokenId());
1798             _incrementTokenId();
1799     }
1800     
1801     function buyMany(uint256 num, address _to) public payable {
1802         require(block.timestamp >= startTime, "It's not time yet");
1803         require(msg.value == NFT_price.mul(num), "Sent Amount Wrong");
1804         require(_currentTokenId + num < MAX_SUPPLY, "Max Supply Reached");
1805         
1806         require(num <= 20, "Max 20 Allowed.");
1807         for(uint256 i=0; i<num; i++){
1808 
1809             _mint(_to, _getNextTokenId());
1810             _incrementTokenId();
1811         }
1812     }
1813   function isWhitelisted(address _user) public view returns (bool) {
1814     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1815       if (whitelistedAddresses[i] == _user) {
1816           return true;
1817       }
1818     }
1819     return false;
1820   }
1821   
1822   function whitelistUsers(address[] calldata _users) public onlyOwner {
1823     delete whitelistedAddresses;
1824     whitelistedAddresses = _users;
1825   }
1826   
1827   function isPresaleActive() external view returns (bool){
1828 
1829       if(block.timestamp > presale_Startdate && block.timestamp < presale_Enddate && end_presale == false ){
1830           return true;
1831       }else{
1832           return false;
1833       }
1834   }
1835   
1836   function withdraw() external onlyOwner {
1837         payable(owner()).transfer(address(this).balance);
1838     }
1839 
1840     /**
1841      * @dev calculates the next token ID based on value of _currentTokenId
1842      * @return uint256 for the next token ID
1843      */
1844     function _getNextTokenId() private view returns (uint256) {
1845         return _currentTokenId.add(1);
1846     }
1847 
1848     function _incrementTokenId() private {
1849         require(_currentTokenId < MAX_SUPPLY);
1850 
1851         _currentTokenId++;
1852     }
1853 
1854     function setBaseUri(string memory _uri) external onlyOwner {
1855         baseTokenURI = _uri;
1856     }
1857 
1858     function tokenURI(uint256 _tokenId)
1859         public
1860         view
1861         override
1862         returns (string memory)
1863     {
1864         return
1865             string(abi.encodePacked(baseTokenURI, Strings.toString(_tokenId)));
1866     }
1867 
1868     /**
1869      * This is used instead of msg.sender as transactions won't be sent by the original token owner, but by OpenSea.
1870      */
1871     function _msgSender() internal view override returns (address sender) {
1872         return ContextMixin.msgSender();
1873     }
1874     function increaseMaxSupply(uint256 temp) external onlyOwner {
1875         MAX_SUPPLY = MAX_SUPPLY + temp;
1876     }
1877 }