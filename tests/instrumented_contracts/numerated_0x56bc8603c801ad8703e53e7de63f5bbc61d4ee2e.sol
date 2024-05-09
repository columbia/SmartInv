1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.0 <0.8.0;
3 
4 /**
5  * The Golden Voyager Party ERC721 Implementation
6  */
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 /**
30  * @dev Required interface of an ERC721 compliant contract.
31  */
32 interface IERC721 is IERC165 {
33     /**
34      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
35      */
36     event Transfer(
37         address indexed from,
38         address indexed to,
39         uint256 indexed tokenId
40     );
41 
42     /**
43      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
44      */
45     event Approval(
46         address indexed owner,
47         address indexed approved,
48         uint256 indexed tokenId
49     );
50 
51     /**
52      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
53      */
54     event ApprovalForAll(
55         address indexed owner,
56         address indexed operator,
57         bool approved
58     );
59 
60     /**
61      * @dev Returns the number of tokens in ``owner``'s account.
62      */
63     function balanceOf(address owner) external view returns (uint256 balance);
64 
65     /**
66      * @dev Returns the owner of the `tokenId` token.
67      *
68      * Requirements:
69      *
70      * - `tokenId` must exist.
71      */
72     function ownerOf(uint256 tokenId) external view returns (address owner);
73 
74     /**
75      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
76      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
77      *
78      * Requirements:
79      *
80      * - `from` cannot be the zero address.
81      * - `to` cannot be the zero address.
82      * - `tokenId` token must exist and be owned by `from`.
83      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
84      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
85      *
86      * Emits a {Transfer} event.
87      */
88     function safeTransferFrom(
89         address from,
90         address to,
91         uint256 tokenId
92     ) external;
93 
94     /**
95      * @dev Transfers `tokenId` token from `from` to `to`.
96      *
97      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
98      *
99      * Requirements:
100      *
101      * - `from` cannot be the zero address.
102      * - `to` cannot be the zero address.
103      * - `tokenId` token must be owned by `from`.
104      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
105      *
106      * Emits a {Transfer} event.
107      */
108     function transferFrom(
109         address from,
110         address to,
111         uint256 tokenId
112     ) external;
113 
114     /**
115      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
116      * The approval is cleared when the token is transferred.
117      *
118      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
119      *
120      * Requirements:
121      *
122      * - The caller must own the token or be an approved operator.
123      * - `tokenId` must exist.
124      *
125      * Emits an {Approval} event.
126      */
127     function approve(address to, uint256 tokenId) external;
128 
129     /**
130      * @dev Returns the account approved for `tokenId` token.
131      *
132      * Requirements:
133      *
134      * - `tokenId` must exist.
135      */
136     function getApproved(uint256 tokenId)
137         external
138         view
139         returns (address operator);
140 
141     /**
142      * @dev Approve or remove `operator` as an operator for the caller.
143      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
144      *
145      * Requirements:
146      *
147      * - The `operator` cannot be the caller.
148      *
149      * Emits an {ApprovalForAll} event.
150      */
151     function setApprovalForAll(address operator, bool _approved) external;
152 
153     /**
154      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
155      *
156      * See {setApprovalForAll}
157      */
158     function isApprovedForAll(address owner, address operator)
159         external
160         view
161         returns (bool);
162 
163     /**
164      * @dev Safely transfers `tokenId` token from `from` to `to`.
165      *
166      * Requirements:
167      *
168      * - `from` cannot be the zero address.
169      * - `to` cannot be the zero address.
170      * - `tokenId` token must exist and be owned by `from`.
171      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
172      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
173      *
174      * Emits a {Transfer} event.
175      */
176     function safeTransferFrom(
177         address from,
178         address to,
179         uint256 tokenId,
180         bytes calldata data
181     ) external;
182 }
183 
184 /**
185  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
186  * @dev See https://eips.ethereum.org/EIPS/eip-721
187  */
188 interface IERC721Metadata is IERC721 {
189     /**
190      * @dev Returns the token collection name.
191      */
192     function name() external view returns (string memory);
193 
194     /**
195      * @dev Returns the token collection symbol.
196      */
197     function symbol() external view returns (string memory);
198 
199     /**
200      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
201      */
202     function tokenURI(uint256 tokenId) external view returns (string memory);
203 }
204 
205 /**
206  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
207  * @dev See https://eips.ethereum.org/EIPS/eip-721
208  */
209 interface IERC721Enumerable is IERC721 {
210     /**
211      * @dev Returns the total amount of tokens stored by the contract.
212      */
213     function totalSupply() external view returns (uint256);
214 
215     /**
216      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
217      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
218      */
219     function tokenOfOwnerByIndex(address owner, uint256 index)
220         external
221         view
222         returns (uint256 tokenId);
223 
224     /**
225      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
226      * Use along with {totalSupply} to enumerate all tokens.
227      */
228     function tokenByIndex(uint256 index) external view returns (uint256);
229 }
230 
231 interface IERC721Receiver {
232     /**
233      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
234      * by `operator` from `from`, this function is called.
235      *
236      * It must return its Solidity selector to confirm the token transfer.
237      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
238      *
239      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
240      */
241     function onERC721Received(
242         address operator,
243         address from,
244         uint256 tokenId,
245         bytes calldata data
246     ) external returns (bytes4);
247 }
248 
249 /**
250  * @dev Implementation of the {IERC165} interface.
251  *
252  * Contracts may inherit from this and call {_registerInterface} to declare
253  * their support of an interface.
254  */
255 abstract contract ERC165 is IERC165 {
256     /*
257      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
258      */
259     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
260 
261     /**
262      * @dev Mapping of interface ids to whether or not it's supported.
263      */
264     mapping(bytes4 => bool) private _supportedInterfaces;
265 
266     constructor() internal {
267         // Derived contracts need only register support for their own interfaces,
268         // we register support for ERC165 itself here
269         _registerInterface(_INTERFACE_ID_ERC165);
270     }
271 
272     /**
273      * @dev See {IERC165-supportsInterface}.
274      *
275      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
276      */
277     function supportsInterface(bytes4 interfaceId)
278         public
279         view
280         virtual
281         override
282         returns (bool)
283     {
284         return _supportedInterfaces[interfaceId];
285     }
286 
287     /**
288      * @dev Registers the contract as an implementer of the interface defined by
289      * `interfaceId`. Support of the actual ERC165 interface is automatic and
290      * registering its interface id is not required.
291      *
292      * See {IERC165-supportsInterface}.
293      *
294      * Requirements:
295      *
296      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
297      */
298     function _registerInterface(bytes4 interfaceId) internal virtual {
299         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
300         _supportedInterfaces[interfaceId] = true;
301     }
302 }
303 
304 /**
305  * @dev Wrappers over Solidity's arithmetic operations with added overflow
306  * checks.
307  *
308  * Arithmetic operations in Solidity wrap on overflow. This can easily result
309  * in bugs, because programmers usually assume that an overflow raises an
310  * error, which is the standard behavior in high level programming languages.
311  * `SafeMath` restores this intuition by reverting the transaction when an
312  * operation overflows.
313  *
314  * Using this library instead of the unchecked operations eliminates an entire
315  * class of bugs, so it's recommended to use it always.
316  */
317 library SafeMath {
318     /**
319      * @dev Returns the addition of two unsigned integers, with an overflow flag.
320      *
321      * _Available since v3.4._
322      */
323     function tryAdd(uint256 a, uint256 b)
324         internal
325         pure
326         returns (bool, uint256)
327     {
328         uint256 c = a + b;
329         if (c < a) return (false, 0);
330         return (true, c);
331     }
332 
333     /**
334      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
335      *
336      * _Available since v3.4._
337      */
338     function trySub(uint256 a, uint256 b)
339         internal
340         pure
341         returns (bool, uint256)
342     {
343         if (b > a) return (false, 0);
344         return (true, a - b);
345     }
346 
347     /**
348      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
349      *
350      * _Available since v3.4._
351      */
352     function tryMul(uint256 a, uint256 b)
353         internal
354         pure
355         returns (bool, uint256)
356     {
357         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
358         // benefit is lost if 'b' is also tested.
359         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
360         if (a == 0) return (true, 0);
361         uint256 c = a * b;
362         if (c / a != b) return (false, 0);
363         return (true, c);
364     }
365 
366     /**
367      * @dev Returns the division of two unsigned integers, with a division by zero flag.
368      *
369      * _Available since v3.4._
370      */
371     function tryDiv(uint256 a, uint256 b)
372         internal
373         pure
374         returns (bool, uint256)
375     {
376         if (b == 0) return (false, 0);
377         return (true, a / b);
378     }
379 
380     /**
381      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
382      *
383      * _Available since v3.4._
384      */
385     function tryMod(uint256 a, uint256 b)
386         internal
387         pure
388         returns (bool, uint256)
389     {
390         if (b == 0) return (false, 0);
391         return (true, a % b);
392     }
393 
394     /**
395      * @dev Returns the addition of two unsigned integers, reverting on
396      * overflow.
397      *
398      * Counterpart to Solidity's `+` operator.
399      *
400      * Requirements:
401      *
402      * - Addition cannot overflow.
403      */
404     function add(uint256 a, uint256 b) internal pure returns (uint256) {
405         uint256 c = a + b;
406         require(c >= a, "SafeMath: addition overflow");
407         return c;
408     }
409 
410     /**
411      * @dev Returns the subtraction of two unsigned integers, reverting on
412      * overflow (when the result is negative).
413      *
414      * Counterpart to Solidity's `-` operator.
415      *
416      * Requirements:
417      *
418      * - Subtraction cannot overflow.
419      */
420     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
421         require(b <= a, "SafeMath: subtraction overflow");
422         return a - b;
423     }
424 
425     /**
426      * @dev Returns the multiplication of two unsigned integers, reverting on
427      * overflow.
428      *
429      * Counterpart to Solidity's `*` operator.
430      *
431      * Requirements:
432      *
433      * - Multiplication cannot overflow.
434      */
435     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
436         if (a == 0) return 0;
437         uint256 c = a * b;
438         require(c / a == b, "SafeMath: multiplication overflow");
439         return c;
440     }
441 
442     /**
443      * @dev Returns the integer division of two unsigned integers, reverting on
444      * division by zero. The result is rounded towards zero.
445      *
446      * Counterpart to Solidity's `/` operator. Note: this function uses a
447      * `revert` opcode (which leaves remaining gas untouched) while Solidity
448      * uses an invalid opcode to revert (consuming all remaining gas).
449      *
450      * Requirements:
451      *
452      * - The divisor cannot be zero.
453      */
454     function div(uint256 a, uint256 b) internal pure returns (uint256) {
455         require(b > 0, "SafeMath: division by zero");
456         return a / b;
457     }
458 
459     /**
460      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
461      * reverting when dividing by zero.
462      *
463      * Counterpart to Solidity's `%` operator. This function uses a `revert`
464      * opcode (which leaves remaining gas untouched) while Solidity uses an
465      * invalid opcode to revert (consuming all remaining gas).
466      *
467      * Requirements:
468      *
469      * - The divisor cannot be zero.
470      */
471     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
472         require(b > 0, "SafeMath: modulo by zero");
473         return a % b;
474     }
475 
476     /**
477      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
478      * overflow (when the result is negative).
479      *
480      * CAUTION: This function is deprecated because it requires allocating memory for the error
481      * message unnecessarily. For custom revert reasons use {trySub}.
482      *
483      * Counterpart to Solidity's `-` operator.
484      *
485      * Requirements:
486      *
487      * - Subtraction cannot overflow.
488      */
489     function sub(
490         uint256 a,
491         uint256 b,
492         string memory errorMessage
493     ) internal pure returns (uint256) {
494         require(b <= a, errorMessage);
495         return a - b;
496     }
497 
498     /**
499      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
500      * division by zero. The result is rounded towards zero.
501      *
502      * CAUTION: This function is deprecated because it requires allocating memory for the error
503      * message unnecessarily. For custom revert reasons use {tryDiv}.
504      *
505      * Counterpart to Solidity's `/` operator. Note: this function uses a
506      * `revert` opcode (which leaves remaining gas untouched) while Solidity
507      * uses an invalid opcode to revert (consuming all remaining gas).
508      *
509      * Requirements:
510      *
511      * - The divisor cannot be zero.
512      */
513     function div(
514         uint256 a,
515         uint256 b,
516         string memory errorMessage
517     ) internal pure returns (uint256) {
518         require(b > 0, errorMessage);
519         return a / b;
520     }
521 
522     /**
523      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
524      * reverting with custom message when dividing by zero.
525      *
526      * CAUTION: This function is deprecated because it requires allocating memory for the error
527      * message unnecessarily. For custom revert reasons use {tryMod}.
528      *
529      * Counterpart to Solidity's `%` operator. This function uses a `revert`
530      * opcode (which leaves remaining gas untouched) while Solidity uses an
531      * invalid opcode to revert (consuming all remaining gas).
532      *
533      * Requirements:
534      *
535      * - The divisor cannot be zero.
536      */
537     function mod(
538         uint256 a,
539         uint256 b,
540         string memory errorMessage
541     ) internal pure returns (uint256) {
542         require(b > 0, errorMessage);
543         return a % b;
544     }
545 }
546 
547 /**
548  * @dev Collection of functions related to the address type
549  */
550 library Address {
551     /**
552      * @dev Returns true if `account` is a contract.
553      *
554      * [IMPORTANT]
555      * ====
556      * It is unsafe to assume that an address for which this function returns
557      * false is an externally-owned account (EOA) and not a contract.
558      *
559      * Among others, `isContract` will return false for the following
560      * types of addresses:
561      *
562      *  - an externally-owned account
563      *  - a contract in construction
564      *  - an address where a contract will be created
565      *  - an address where a contract lived, but was destroyed
566      * ====
567      */
568     function isContract(address account) internal view returns (bool) {
569         // This method relies on extcodesize, which returns 0 for contracts in
570         // construction, since the code is only stored at the end of the
571         // constructor execution.
572 
573         uint256 size;
574         // solhint-disable-next-line no-inline-assembly
575         assembly {
576             size := extcodesize(account)
577         }
578         return size > 0;
579     }
580 
581     /**
582      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
583      * `recipient`, forwarding all available gas and reverting on errors.
584      *
585      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
586      * of certain opcodes, possibly making contracts go over the 2300 gas limit
587      * imposed by `transfer`, making them unable to receive funds via
588      * `transfer`. {sendValue} removes this limitation.
589      *
590      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
591      *
592      * IMPORTANT: because control is transferred to `recipient`, care must be
593      * taken to not create reentrancy vulnerabilities. Consider using
594      * {ReentrancyGuard} or the
595      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
596      */
597     function sendValue(address payable recipient, uint256 amount) internal {
598         require(
599             address(this).balance >= amount,
600             "Address: insufficient balance"
601         );
602 
603         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
604         (bool success, ) = recipient.call{value: amount}("");
605         require(
606             success,
607             "Address: unable to send value, recipient may have reverted"
608         );
609     }
610 
611     /**
612      * @dev Performs a Solidity function call using a low level `call`. A
613      * plain`call` is an unsafe replacement for a function call: use this
614      * function instead.
615      *
616      * If `target` reverts with a revert reason, it is bubbled up by this
617      * function (like regular Solidity function calls).
618      *
619      * Returns the raw returned data. To convert to the expected return value,
620      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
621      *
622      * Requirements:
623      *
624      * - `target` must be a contract.
625      * - calling `target` with `data` must not revert.
626      *
627      * _Available since v3.1._
628      */
629     function functionCall(address target, bytes memory data)
630         internal
631         returns (bytes memory)
632     {
633         return functionCall(target, data, "Address: low-level call failed");
634     }
635 
636     /**
637      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
638      * `errorMessage` as a fallback revert reason when `target` reverts.
639      *
640      * _Available since v3.1._
641      */
642     function functionCall(
643         address target,
644         bytes memory data,
645         string memory errorMessage
646     ) internal returns (bytes memory) {
647         return functionCallWithValue(target, data, 0, errorMessage);
648     }
649 
650     /**
651      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
652      * but also transferring `value` wei to `target`.
653      *
654      * Requirements:
655      *
656      * - the calling contract must have an ETH balance of at least `value`.
657      * - the called Solidity function must be `payable`.
658      *
659      * _Available since v3.1._
660      */
661     function functionCallWithValue(
662         address target,
663         bytes memory data,
664         uint256 value
665     ) internal returns (bytes memory) {
666         return
667             functionCallWithValue(
668                 target,
669                 data,
670                 value,
671                 "Address: low-level call with value failed"
672             );
673     }
674 
675     /**
676      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
677      * with `errorMessage` as a fallback revert reason when `target` reverts.
678      *
679      * _Available since v3.1._
680      */
681     function functionCallWithValue(
682         address target,
683         bytes memory data,
684         uint256 value,
685         string memory errorMessage
686     ) internal returns (bytes memory) {
687         require(
688             address(this).balance >= value,
689             "Address: insufficient balance for call"
690         );
691         require(isContract(target), "Address: call to non-contract");
692 
693         // solhint-disable-next-line avoid-low-level-calls
694         (bool success, bytes memory returndata) = target.call{value: value}(
695             data
696         );
697         return _verifyCallResult(success, returndata, errorMessage);
698     }
699 
700     /**
701      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
702      * but performing a static call.
703      *
704      * _Available since v3.3._
705      */
706     function functionStaticCall(address target, bytes memory data)
707         internal
708         view
709         returns (bytes memory)
710     {
711         return
712             functionStaticCall(
713                 target,
714                 data,
715                 "Address: low-level static call failed"
716             );
717     }
718 
719     /**
720      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
721      * but performing a static call.
722      *
723      * _Available since v3.3._
724      */
725     function functionStaticCall(
726         address target,
727         bytes memory data,
728         string memory errorMessage
729     ) internal view returns (bytes memory) {
730         require(isContract(target), "Address: static call to non-contract");
731 
732         // solhint-disable-next-line avoid-low-level-calls
733         (bool success, bytes memory returndata) = target.staticcall(data);
734         return _verifyCallResult(success, returndata, errorMessage);
735     }
736 
737     /**
738      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
739      * but performing a delegate call.
740      *
741      * _Available since v3.4._
742      */
743     function functionDelegateCall(address target, bytes memory data)
744         internal
745         returns (bytes memory)
746     {
747         return
748             functionDelegateCall(
749                 target,
750                 data,
751                 "Address: low-level delegate call failed"
752             );
753     }
754 
755     /**
756      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
757      * but performing a delegate call.
758      *
759      * _Available since v3.4._
760      */
761     function functionDelegateCall(
762         address target,
763         bytes memory data,
764         string memory errorMessage
765     ) internal returns (bytes memory) {
766         require(isContract(target), "Address: delegate call to non-contract");
767 
768         // solhint-disable-next-line avoid-low-level-calls
769         (bool success, bytes memory returndata) = target.delegatecall(data);
770         return _verifyCallResult(success, returndata, errorMessage);
771     }
772 
773     function _verifyCallResult(
774         bool success,
775         bytes memory returndata,
776         string memory errorMessage
777     ) private pure returns (bytes memory) {
778         if (success) {
779             return returndata;
780         } else {
781             // Look for revert reason and bubble it up if present
782             if (returndata.length > 0) {
783                 // The easiest way to bubble the revert reason is using memory via assembly
784 
785                 // solhint-disable-next-line no-inline-assembly
786                 assembly {
787                     let returndata_size := mload(returndata)
788                     revert(add(32, returndata), returndata_size)
789                 }
790             } else {
791                 revert(errorMessage);
792             }
793         }
794     }
795 }
796 
797 /**
798  * @dev Library for managing
799  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
800  * types.
801  *
802  * Sets have the following properties:
803  *
804  * - Elements are added, removed, and checked for existence in constant time
805  * (O(1)).
806  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
807  *
808  * ```
809  * contract Example {
810  *     // Add the library methods
811  *     using EnumerableSet for EnumerableSet.AddressSet;
812  *
813  *     // Declare a set state variable
814  *     EnumerableSet.AddressSet private mySet;
815  * }
816  * ```
817  *
818  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
819  * and `uint256` (`UintSet`) are supported.
820  */
821 library EnumerableSet {
822     // To implement this library for multiple types with as little code
823     // repetition as possible, we write it in terms of a generic Set type with
824     // bytes32 values.
825     // The Set implementation uses private functions, and user-facing
826     // implementations (such as AddressSet) are just wrappers around the
827     // underlying Set.
828     // This means that we can only create new EnumerableSets for types that fit
829     // in bytes32.
830 
831     struct Set {
832         // Storage of set values
833         bytes32[] _values;
834         // Position of the value in the `values` array, plus 1 because index 0
835         // means a value is not in the set.
836         mapping(bytes32 => uint256) _indexes;
837     }
838 
839     /**
840      * @dev Add a value to a set. O(1).
841      *
842      * Returns true if the value was added to the set, that is if it was not
843      * already present.
844      */
845     function _add(Set storage set, bytes32 value) private returns (bool) {
846         if (!_contains(set, value)) {
847             set._values.push(value);
848             // The value is stored at length-1, but we add 1 to all indexes
849             // and use 0 as a sentinel value
850             set._indexes[value] = set._values.length;
851             return true;
852         } else {
853             return false;
854         }
855     }
856 
857     /**
858      * @dev Removes a value from a set. O(1).
859      *
860      * Returns true if the value was removed from the set, that is if it was
861      * present.
862      */
863     function _remove(Set storage set, bytes32 value) private returns (bool) {
864         // We read and store the value's index to prevent multiple reads from the same storage slot
865         uint256 valueIndex = set._indexes[value];
866 
867         if (valueIndex != 0) {
868             // Equivalent to contains(set, value)
869             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
870             // the array, and then remove the last element (sometimes called as 'swap and pop').
871             // This modifies the order of the array, as noted in {at}.
872 
873             uint256 toDeleteIndex = valueIndex - 1;
874             uint256 lastIndex = set._values.length - 1;
875 
876             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
877             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
878 
879             bytes32 lastvalue = set._values[lastIndex];
880 
881             // Move the last value to the index where the value to delete is
882             set._values[toDeleteIndex] = lastvalue;
883             // Update the index for the moved value
884             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
885 
886             // Delete the slot where the moved value was stored
887             set._values.pop();
888 
889             // Delete the index for the deleted slot
890             delete set._indexes[value];
891 
892             return true;
893         } else {
894             return false;
895         }
896     }
897 
898     /**
899      * @dev Returns true if the value is in the set. O(1).
900      */
901     function _contains(Set storage set, bytes32 value)
902         private
903         view
904         returns (bool)
905     {
906         return set._indexes[value] != 0;
907     }
908 
909     /**
910      * @dev Returns the number of values on the set. O(1).
911      */
912     function _length(Set storage set) private view returns (uint256) {
913         return set._values.length;
914     }
915 
916     /**
917      * @dev Returns the value stored at position `index` in the set. O(1).
918      *
919      * Note that there are no guarantees on the ordering of values inside the
920      * array, and it may change when more values are added or removed.
921      *
922      * Requirements:
923      *
924      * - `index` must be strictly less than {length}.
925      */
926     function _at(Set storage set, uint256 index)
927         private
928         view
929         returns (bytes32)
930     {
931         require(
932             set._values.length > index,
933             "EnumerableSet: index out of bounds"
934         );
935         return set._values[index];
936     }
937 
938     // Bytes32Set
939 
940     struct Bytes32Set {
941         Set _inner;
942     }
943 
944     /**
945      * @dev Add a value to a set. O(1).
946      *
947      * Returns true if the value was added to the set, that is if it was not
948      * already present.
949      */
950     function add(Bytes32Set storage set, bytes32 value)
951         internal
952         returns (bool)
953     {
954         return _add(set._inner, value);
955     }
956 
957     /**
958      * @dev Removes a value from a set. O(1).
959      *
960      * Returns true if the value was removed from the set, that is if it was
961      * present.
962      */
963     function remove(Bytes32Set storage set, bytes32 value)
964         internal
965         returns (bool)
966     {
967         return _remove(set._inner, value);
968     }
969 
970     /**
971      * @dev Returns true if the value is in the set. O(1).
972      */
973     function contains(Bytes32Set storage set, bytes32 value)
974         internal
975         view
976         returns (bool)
977     {
978         return _contains(set._inner, value);
979     }
980 
981     /**
982      * @dev Returns the number of values in the set. O(1).
983      */
984     function length(Bytes32Set storage set) internal view returns (uint256) {
985         return _length(set._inner);
986     }
987 
988     /**
989      * @dev Returns the value stored at position `index` in the set. O(1).
990      *
991      * Note that there are no guarantees on the ordering of values inside the
992      * array, and it may change when more values are added or removed.
993      *
994      * Requirements:
995      *
996      * - `index` must be strictly less than {length}.
997      */
998     function at(Bytes32Set storage set, uint256 index)
999         internal
1000         view
1001         returns (bytes32)
1002     {
1003         return _at(set._inner, index);
1004     }
1005 
1006     // AddressSet
1007 
1008     struct AddressSet {
1009         Set _inner;
1010     }
1011 
1012     /**
1013      * @dev Add a value to a set. O(1).
1014      *
1015      * Returns true if the value was added to the set, that is if it was not
1016      * already present.
1017      */
1018     function add(AddressSet storage set, address value)
1019         internal
1020         returns (bool)
1021     {
1022         return _add(set._inner, bytes32(uint256(uint160(value))));
1023     }
1024 
1025     /**
1026      * @dev Removes a value from a set. O(1).
1027      *
1028      * Returns true if the value was removed from the set, that is if it was
1029      * present.
1030      */
1031     function remove(AddressSet storage set, address value)
1032         internal
1033         returns (bool)
1034     {
1035         return _remove(set._inner, bytes32(uint256(uint160(value))));
1036     }
1037 
1038     /**
1039      * @dev Returns true if the value is in the set. O(1).
1040      */
1041     function contains(AddressSet storage set, address value)
1042         internal
1043         view
1044         returns (bool)
1045     {
1046         return _contains(set._inner, bytes32(uint256(uint160(value))));
1047     }
1048 
1049     /**
1050      * @dev Returns the number of values in the set. O(1).
1051      */
1052     function length(AddressSet storage set) internal view returns (uint256) {
1053         return _length(set._inner);
1054     }
1055 
1056     /**
1057      * @dev Returns the value stored at position `index` in the set. O(1).
1058      *
1059      * Note that there are no guarantees on the ordering of values inside the
1060      * array, and it may change when more values are added or removed.
1061      *
1062      * Requirements:
1063      *
1064      * - `index` must be strictly less than {length}.
1065      */
1066     function at(AddressSet storage set, uint256 index)
1067         internal
1068         view
1069         returns (address)
1070     {
1071         return address(uint160(uint256(_at(set._inner, index))));
1072     }
1073 
1074     // UintSet
1075 
1076     struct UintSet {
1077         Set _inner;
1078     }
1079 
1080     /**
1081      * @dev Add a value to a set. O(1).
1082      *
1083      * Returns true if the value was added to the set, that is if it was not
1084      * already present.
1085      */
1086     function add(UintSet storage set, uint256 value) internal returns (bool) {
1087         return _add(set._inner, bytes32(value));
1088     }
1089 
1090     /**
1091      * @dev Removes a value from a set. O(1).
1092      *
1093      * Returns true if the value was removed from the set, that is if it was
1094      * present.
1095      */
1096     function remove(UintSet storage set, uint256 value)
1097         internal
1098         returns (bool)
1099     {
1100         return _remove(set._inner, bytes32(value));
1101     }
1102 
1103     /**
1104      * @dev Returns true if the value is in the set. O(1).
1105      */
1106     function contains(UintSet storage set, uint256 value)
1107         internal
1108         view
1109         returns (bool)
1110     {
1111         return _contains(set._inner, bytes32(value));
1112     }
1113 
1114     /**
1115      * @dev Returns the number of values on the set. O(1).
1116      */
1117     function length(UintSet storage set) internal view returns (uint256) {
1118         return _length(set._inner);
1119     }
1120 
1121     /**
1122      * @dev Returns the value stored at position `index` in the set. O(1).
1123      *
1124      * Note that there are no guarantees on the ordering of values inside the
1125      * array, and it may change when more values are added or removed.
1126      *
1127      * Requirements:
1128      *
1129      * - `index` must be strictly less than {length}.
1130      */
1131     function at(UintSet storage set, uint256 index)
1132         internal
1133         view
1134         returns (uint256)
1135     {
1136         return uint256(_at(set._inner, index));
1137     }
1138 }
1139 
1140 /**
1141  * @dev Library for managing an enumerable variant of Solidity's
1142  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1143  * type.
1144  *
1145  * Maps have the following properties:
1146  *
1147  * - Entries are added, removed, and checked for existence in constant time
1148  * (O(1)).
1149  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1150  *
1151  * ```
1152  * contract Example {
1153  *     // Add the library methods
1154  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1155  *
1156  *     // Declare a set state variable
1157  *     EnumerableMap.UintToAddressMap private myMap;
1158  * }
1159  * ```
1160  *
1161  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1162  * supported.
1163  */
1164 library EnumerableMap {
1165     // To implement this library for multiple types with as little code
1166     // repetition as possible, we write it in terms of a generic Map type with
1167     // bytes32 keys and values.
1168     // The Map implementation uses private functions, and user-facing
1169     // implementations (such as Uint256ToAddressMap) are just wrappers around
1170     // the underlying Map.
1171     // This means that we can only create new EnumerableMaps for types that fit
1172     // in bytes32.
1173 
1174     struct MapEntry {
1175         bytes32 _key;
1176         bytes32 _value;
1177     }
1178 
1179     struct Map {
1180         // Storage of map keys and values
1181         MapEntry[] _entries;
1182         // Position of the entry defined by a key in the `entries` array, plus 1
1183         // because index 0 means a key is not in the map.
1184         mapping(bytes32 => uint256) _indexes;
1185     }
1186 
1187     /**
1188      * @dev Adds a key-value pair to a map, or updates the value for an existing
1189      * key. O(1).
1190      *
1191      * Returns true if the key was added to the map, that is if it was not
1192      * already present.
1193      */
1194     function _set(
1195         Map storage map,
1196         bytes32 key,
1197         bytes32 value
1198     ) private returns (bool) {
1199         // We read and store the key's index to prevent multiple reads from the same storage slot
1200         uint256 keyIndex = map._indexes[key];
1201 
1202         if (keyIndex == 0) {
1203             // Equivalent to !contains(map, key)
1204             map._entries.push(MapEntry({_key: key, _value: value}));
1205             // The entry is stored at length-1, but we add 1 to all indexes
1206             // and use 0 as a sentinel value
1207             map._indexes[key] = map._entries.length;
1208             return true;
1209         } else {
1210             map._entries[keyIndex - 1]._value = value;
1211             return false;
1212         }
1213     }
1214 
1215     /**
1216      * @dev Removes a key-value pair from a map. O(1).
1217      *
1218      * Returns true if the key was removed from the map, that is if it was present.
1219      */
1220     function _remove(Map storage map, bytes32 key) private returns (bool) {
1221         // We read and store the key's index to prevent multiple reads from the same storage slot
1222         uint256 keyIndex = map._indexes[key];
1223 
1224         if (keyIndex != 0) {
1225             // Equivalent to contains(map, key)
1226             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1227             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1228             // This modifies the order of the array, as noted in {at}.
1229 
1230             uint256 toDeleteIndex = keyIndex - 1;
1231             uint256 lastIndex = map._entries.length - 1;
1232 
1233             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1234             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1235 
1236             MapEntry storage lastEntry = map._entries[lastIndex];
1237 
1238             // Move the last entry to the index where the entry to delete is
1239             map._entries[toDeleteIndex] = lastEntry;
1240             // Update the index for the moved entry
1241             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1242 
1243             // Delete the slot where the moved entry was stored
1244             map._entries.pop();
1245 
1246             // Delete the index for the deleted slot
1247             delete map._indexes[key];
1248 
1249             return true;
1250         } else {
1251             return false;
1252         }
1253     }
1254 
1255     /**
1256      * @dev Returns true if the key is in the map. O(1).
1257      */
1258     function _contains(Map storage map, bytes32 key)
1259         private
1260         view
1261         returns (bool)
1262     {
1263         return map._indexes[key] != 0;
1264     }
1265 
1266     /**
1267      * @dev Returns the number of key-value pairs in the map. O(1).
1268      */
1269     function _length(Map storage map) private view returns (uint256) {
1270         return map._entries.length;
1271     }
1272 
1273     /**
1274      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1275      *
1276      * Note that there are no guarantees on the ordering of entries inside the
1277      * array, and it may change when more entries are added or removed.
1278      *
1279      * Requirements:
1280      *
1281      * - `index` must be strictly less than {length}.
1282      */
1283     function _at(Map storage map, uint256 index)
1284         private
1285         view
1286         returns (bytes32, bytes32)
1287     {
1288         require(
1289             map._entries.length > index,
1290             "EnumerableMap: index out of bounds"
1291         );
1292 
1293         MapEntry storage entry = map._entries[index];
1294         return (entry._key, entry._value);
1295     }
1296 
1297     /**
1298      * @dev Tries to returns the value associated with `key`.  O(1).
1299      * Does not revert if `key` is not in the map.
1300      */
1301     function _tryGet(Map storage map, bytes32 key)
1302         private
1303         view
1304         returns (bool, bytes32)
1305     {
1306         uint256 keyIndex = map._indexes[key];
1307         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1308         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1309     }
1310 
1311     /**
1312      * @dev Returns the value associated with `key`.  O(1).
1313      *
1314      * Requirements:
1315      *
1316      * - `key` must be in the map.
1317      */
1318     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1319         uint256 keyIndex = map._indexes[key];
1320         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1321         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1322     }
1323 
1324     /**
1325      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1326      *
1327      * CAUTION: This function is deprecated because it requires allocating memory for the error
1328      * message unnecessarily. For custom revert reasons use {_tryGet}.
1329      */
1330     function _get(
1331         Map storage map,
1332         bytes32 key,
1333         string memory errorMessage
1334     ) private view returns (bytes32) {
1335         uint256 keyIndex = map._indexes[key];
1336         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1337         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1338     }
1339 
1340     // UintToAddressMap
1341 
1342     struct UintToAddressMap {
1343         Map _inner;
1344     }
1345 
1346     /**
1347      * @dev Adds a key-value pair to a map, or updates the value for an existing
1348      * key. O(1).
1349      *
1350      * Returns true if the key was added to the map, that is if it was not
1351      * already present.
1352      */
1353     function set(
1354         UintToAddressMap storage map,
1355         uint256 key,
1356         address value
1357     ) internal returns (bool) {
1358         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1359     }
1360 
1361     /**
1362      * @dev Removes a value from a set. O(1).
1363      *
1364      * Returns true if the key was removed from the map, that is if it was present.
1365      */
1366     function remove(UintToAddressMap storage map, uint256 key)
1367         internal
1368         returns (bool)
1369     {
1370         return _remove(map._inner, bytes32(key));
1371     }
1372 
1373     /**
1374      * @dev Returns true if the key is in the map. O(1).
1375      */
1376     function contains(UintToAddressMap storage map, uint256 key)
1377         internal
1378         view
1379         returns (bool)
1380     {
1381         return _contains(map._inner, bytes32(key));
1382     }
1383 
1384     /**
1385      * @dev Returns the number of elements in the map. O(1).
1386      */
1387     function length(UintToAddressMap storage map)
1388         internal
1389         view
1390         returns (uint256)
1391     {
1392         return _length(map._inner);
1393     }
1394 
1395     /**
1396      * @dev Returns the element stored at position `index` in the set. O(1).
1397      * Note that there are no guarantees on the ordering of values inside the
1398      * array, and it may change when more values are added or removed.
1399      *
1400      * Requirements:
1401      *
1402      * - `index` must be strictly less than {length}.
1403      */
1404     function at(UintToAddressMap storage map, uint256 index)
1405         internal
1406         view
1407         returns (uint256, address)
1408     {
1409         (bytes32 key, bytes32 value) = _at(map._inner, index);
1410         return (uint256(key), address(uint160(uint256(value))));
1411     }
1412 
1413     /**
1414      * @dev Tries to returns the value associated with `key`.  O(1).
1415      * Does not revert if `key` is not in the map.
1416      *
1417      * _Available since v3.4._
1418      */
1419     function tryGet(UintToAddressMap storage map, uint256 key)
1420         internal
1421         view
1422         returns (bool, address)
1423     {
1424         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1425         return (success, address(uint160(uint256(value))));
1426     }
1427 
1428     /**
1429      * @dev Returns the value associated with `key`.  O(1).
1430      *
1431      * Requirements:
1432      *
1433      * - `key` must be in the map.
1434      */
1435     function get(UintToAddressMap storage map, uint256 key)
1436         internal
1437         view
1438         returns (address)
1439     {
1440         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1441     }
1442 
1443     /**
1444      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1445      *
1446      * CAUTION: This function is deprecated because it requires allocating memory for the error
1447      * message unnecessarily. For custom revert reasons use {tryGet}.
1448      */
1449     function get(
1450         UintToAddressMap storage map,
1451         uint256 key,
1452         string memory errorMessage
1453     ) internal view returns (address) {
1454         return
1455             address(
1456                 uint160(uint256(_get(map._inner, bytes32(key), errorMessage)))
1457             );
1458     }
1459 }
1460 
1461 /**
1462  * @dev String operations.
1463  */
1464 library Strings {
1465     /**
1466      * @dev Converts a `uint256` to its ASCII `string` representation.
1467      */
1468     function toString(uint256 value) internal pure returns (string memory) {
1469         // Inspired by OraclizeAPI's implementation - MIT licence
1470         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1471 
1472         if (value == 0) {
1473             return "0";
1474         }
1475         uint256 temp = value;
1476         uint256 digits;
1477         while (temp != 0) {
1478             digits++;
1479             temp /= 10;
1480         }
1481         bytes memory buffer = new bytes(digits);
1482         uint256 index = digits - 1;
1483         temp = value;
1484         while (temp != 0) {
1485             buffer[index--] = bytes1(uint8(48 + (temp % 10)));
1486             temp /= 10;
1487         }
1488         return string(buffer);
1489     }
1490 }
1491 
1492 /*
1493  * @dev Provides information about the current execution context, including the
1494  * sender of the transaction and its data. While these are generally available
1495  * via msg.sender and msg.data, they should not be accessed in such a direct
1496  * manner, since when dealing with GSN meta-transactions the account sending and
1497  * paying for execution may not be the actual sender (as far as an application
1498  * is concerned).
1499  *
1500  * This contract is only required for intermediate, library-like contracts.
1501  */
1502 abstract contract Context {
1503     function _msgSender() internal view virtual returns (address payable) {
1504         return msg.sender;
1505     }
1506 
1507     function _msgData() internal view virtual returns (bytes memory) {
1508         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1509         return msg.data;
1510     }
1511 }
1512 
1513 /**
1514  * @dev Contract module which provides a basic access control mechanism, where
1515  * there is an account (an owner) that can be granted exclusive access to
1516  * specific functions.
1517  *
1518  * By default, the owner account will be the one that deploys the contract. This
1519  * can later be changed with {transferOwnership}.
1520  *
1521  * This module is used through inheritance. It will make available the modifier
1522  * `onlyOwner`, which can be applied to your functions to restrict their use to
1523  * the owner.
1524  */
1525 abstract contract Ownable is Context {
1526     address payable private _owner;
1527 
1528     event OwnershipTransferred(
1529         address indexed previousOwner,
1530         address indexed newOwner
1531     );
1532 
1533     /**
1534      * @dev Initializes the contract setting the deployer as the initial owner.
1535      */
1536     constructor() internal {
1537         address payable msgSender = _msgSender();
1538         _owner = msgSender;
1539         emit OwnershipTransferred(address(0), msgSender);
1540     }
1541 
1542     /**
1543      * @dev Returns the address of the current owner.
1544      */
1545     function owner() public view virtual returns (address payable) {
1546         return _owner;
1547     }
1548 
1549     /**
1550      * @dev Throws if called by any account other than the owner.
1551      */
1552     modifier onlyOwner() {
1553         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1554         _;
1555     }
1556 
1557     /**
1558      * @dev Leaves the contract without owner. It will not be possible to call
1559      * `onlyOwner` functions anymore. Can only be called by the current owner.
1560      *
1561      * NOTE: Renouncing ownership will leave the contract without an owner,
1562      * thereby removing any functionality that is only available to the owner.
1563      */
1564     function renounceOwnership() public virtual onlyOwner {
1565         emit OwnershipTransferred(_owner, address(0));
1566         _owner = address(0);
1567     }
1568 
1569     /**
1570      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1571      * Can only be called by the current owner.
1572      */
1573     function transferOwnership(address payable newOwner)
1574         public
1575         virtual
1576         onlyOwner
1577     {
1578         require(
1579             newOwner != address(0),
1580             "Ownable: new owner is the zero address"
1581         );
1582         emit OwnershipTransferred(_owner, newOwner);
1583         _owner = newOwner;
1584     }
1585 }
1586 
1587 contract GoldenVoyagerParty is
1588     Ownable,
1589     ERC165,
1590     IERC721,
1591     IERC721Metadata,
1592     IERC721Enumerable
1593 {
1594     using SafeMath for uint256;
1595     using Strings for uint256;
1596     using Address for address;
1597     using EnumerableSet for EnumerableSet.UintSet;
1598     using EnumerableMap for EnumerableMap.UintToAddressMap;
1599 
1600     event Mint(address indexed to, uint256 tokenId, bytes32 hash);
1601 
1602     bool private _isPaused = true;
1603     uint256 MAX_VOYAGERS = 9000;
1604     uint256 MAX_VOYAGERS_MINT = 15;
1605     uint256 VOYAGER_PRICE = 80000000000000000; // 0.08 ETH
1606     uint256 _reservedVoyagers = 100;
1607 
1608     mapping(uint256 => bytes32) private _tokenIdHash;
1609 
1610     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1611     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1612     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1613 
1614     // Mapping from holder address to their (enumerable) set of owned tokens
1615     mapping(address => EnumerableSet.UintSet) private _holderTokens;
1616 
1617     // Enumerable mapping from token ids to their owners
1618     EnumerableMap.UintToAddressMap private _tokenOwners;
1619 
1620     // Mapping from token ID to approved address
1621     mapping(uint256 => address) private _tokenApprovals;
1622 
1623     // Mapping from owner to operator approvals
1624     mapping(address => mapping(address => bool)) private _operatorApprovals;
1625 
1626     // Token name
1627     string private _name;
1628 
1629     // Token symbol
1630     string private _symbol;
1631 
1632     // Optional mapping for token URIs
1633     mapping(uint256 => string) private _tokenURIs;
1634 
1635     // Base URI
1636     string private _baseURI;
1637 
1638     /*
1639      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1640      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1641      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1642      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1643      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1644      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1645      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1646      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1647      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1648      *
1649      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1650      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1651      */
1652     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1653 
1654     /*
1655      *     bytes4(keccak256('name()')) == 0x06fdde03
1656      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1657      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1658      *
1659      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1660      */
1661     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1662 
1663     /*
1664      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1665      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1666      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1667      *
1668      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1669      */
1670     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1671 
1672     /**
1673      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1674      */
1675     constructor(
1676         string memory name_,
1677         string memory symbol_,
1678         string memory uri_,
1679         uint256 hardCap_
1680     ) public {
1681         _name = name_;
1682         _symbol = symbol_;
1683         _baseURI = uri_;
1684         MAX_VOYAGERS = hardCap_;
1685         // register the supported interfaces to conform to ERC721 via ERC165
1686         _registerInterface(_INTERFACE_ID_ERC721);
1687         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1688         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1689     }
1690 
1691     function _mintOne(address _to, uint256 _tokenId) internal {
1692         bytes32 hash = keccak256(
1693             abi.encodePacked(_tokenId, block.difficulty, block.number, _to)
1694         );
1695         _tokenIdHash[_tokenId] = hash;
1696 
1697         _safeMint(_to, _tokenId);
1698 
1699         emit Mint(_to, _tokenId, hash);
1700     }
1701 
1702     function mint(address _to) public payable {
1703         require(!_isPaused, "mint is paused");
1704         require(_to != address(0), "mint to the zero address");
1705         uint256 _totalSupply = totalSupply();
1706         require(_totalSupply < MAX_VOYAGERS, "mint would exceed totalSupply");
1707         require(VOYAGER_PRICE <= msg.value, "wrong amount sent");
1708         uint256 _tokenId = _totalSupply + 1;
1709         _mintOne(_to, _tokenId);
1710     }
1711 
1712     function mintMany(address _to, uint256 _amount) public payable {
1713         require(!_isPaused, "mint is paused");
1714         require(VOYAGER_PRICE * _amount <= msg.value, "wrong amount sent");
1715         require(_amount <= MAX_VOYAGERS_MINT, "max 15 Voyagers per mint");
1716         require(_to != address(0), "mint to the zero address");
1717         uint256 _totalSupply = totalSupply();
1718         require(
1719             (_totalSupply + _amount) <= MAX_VOYAGERS,
1720             "mint would exceed totalSupply"
1721         );
1722         _mintMany(_to, _amount);
1723     }
1724 
1725     function _mintMany(address _to, uint256 _amount) internal {
1726         uint256 _totalSupply = totalSupply();
1727         for (uint256 i = 0; i < _amount; i++) {
1728             uint256 _tokenId = _totalSupply + 1 + i;
1729             _mintOne(_to, _tokenId);
1730         }
1731     }
1732 
1733     function burn(uint256 _tokenId) public {
1734         address owner = GoldenVoyagerParty.ownerOf(_tokenId);
1735         require(msg.sender == owner, "only owner allowed to burn");
1736         _burn(_tokenId);
1737     }
1738 
1739     function withdraw(uint256 value) public onlyOwner {
1740         address payable _owner = owner();
1741         _owner.transfer(value);
1742     }
1743 
1744     function setPaused(bool isPaused) public onlyOwner {
1745         _isPaused = isPaused;
1746     }
1747 
1748     function mintReservedVoyagers(address _to, uint256 _amount)
1749         public
1750         onlyOwner
1751     {
1752         uint256 _totalSupply = totalSupply();
1753         require(
1754             _amount <= _reservedVoyagers,
1755             "reserved token mint exceeds limit"
1756         );
1757         require(
1758             (_totalSupply + _amount) <= MAX_VOYAGERS,
1759             "mint exceeds totalSupply"
1760         );
1761         _reservedVoyagers = _reservedVoyagers - _amount;
1762         _mintMany(_to, _amount);
1763     }
1764 
1765     function getTokensByOwner(address _owner)
1766         public
1767         view
1768         returns (uint256[] memory)
1769     {
1770         uint256 tokenCount = balanceOf(_owner);
1771         uint256[] memory tokenIds = new uint256[](tokenCount);
1772         for (uint256 i; i < tokenCount; i++) {
1773             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1774         }
1775 
1776         return tokenIds;
1777     }
1778 
1779     /**
1780      * @dev See {IERC721-balanceOf}.
1781      */
1782     function balanceOf(address owner) public view override returns (uint256) {
1783         require(owner != address(0), "balance query for the zero address");
1784         return _holderTokens[owner].length();
1785     }
1786 
1787     /**
1788      * @dev See {IERC721-ownerOf}.
1789      */
1790     function ownerOf(uint256 tokenId) public view override returns (address) {
1791         return _tokenOwners.get(tokenId, "owner query for nonexistent token");
1792     }
1793 
1794     /**
1795      * @dev See {IERC721Metadata-name}.
1796      */
1797     function name() public view virtual override returns (string memory) {
1798         return _name;
1799     }
1800 
1801     /**
1802      * @dev See {IERC721Metadata-symbol}.
1803      */
1804     function symbol() public view virtual override returns (string memory) {
1805         return _symbol;
1806     }
1807 
1808     /**
1809      * @dev See {IERC721Metadata-tokenURI}.
1810      */
1811     function tokenURI(uint256 tokenId)
1812         public
1813         view
1814         virtual
1815         override
1816         returns (string memory)
1817     {
1818         require(_exists(tokenId), "URI query for nonexistent token");
1819 
1820         string memory _tokenURI = _tokenURIs[tokenId];
1821         string memory base = baseURI();
1822 
1823         // If there is no base URI, return the token URI.
1824         if (bytes(base).length == 0) {
1825             return _tokenURI;
1826         }
1827         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1828         if (bytes(_tokenURI).length > 0) {
1829             return string(abi.encodePacked(base, _tokenURI));
1830         }
1831         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1832         return string(abi.encodePacked(base, tokenId.toString()));
1833     }
1834 
1835     /**
1836      * @dev Returns the base URI set via {_setBaseURI}. This will be
1837      * automatically added as a prefix in {tokenURI} to each token's URI, or
1838      * to the token ID if no specific URI is set for that token ID.
1839      */
1840     function baseURI() public view returns (string memory) {
1841         return _baseURI;
1842     }
1843 
1844     /**
1845      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1846      */
1847     function tokenOfOwnerByIndex(address owner, uint256 index)
1848         public
1849         view
1850         virtual
1851         override
1852         returns (uint256)
1853     {
1854         return _holderTokens[owner].at(index);
1855     }
1856 
1857     /**
1858      * @dev See {IERC721Enumerable-totalSupply}.
1859      */
1860     function totalSupply() public view override returns (uint256) {
1861         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1862         return _tokenOwners.length();
1863     }
1864 
1865     /**
1866      * @dev See {IERC721Enumerable-tokenByIndex}.
1867      */
1868     function tokenByIndex(uint256 index)
1869         public
1870         view
1871         virtual
1872         override
1873         returns (uint256)
1874     {
1875         (uint256 tokenId, ) = _tokenOwners.at(index);
1876         return tokenId;
1877     }
1878 
1879     /**
1880      * @dev See {IERC721-approve}.
1881      */
1882     function approve(address to, uint256 tokenId) public override {
1883         address owner = GoldenVoyagerParty.ownerOf(tokenId);
1884         require(to != owner, "approval to current owner");
1885         address sender = _msgSender();
1886         require(
1887             sender == owner ||
1888                 GoldenVoyagerParty.isApprovedForAll(owner, sender),
1889             "approve caller is not owner nor approved for all"
1890         );
1891 
1892         _approve(to, tokenId);
1893     }
1894 
1895     /**
1896      * @dev See {IERC721-getApproved}.
1897      */
1898     function getApproved(uint256 tokenId)
1899         public
1900         view
1901         override
1902         returns (address)
1903     {
1904         require(_exists(tokenId), "approved query for nonexistent token");
1905 
1906         return _tokenApprovals[tokenId];
1907     }
1908 
1909     /**
1910      * @dev See {IERC721-setApprovalForAll}.
1911      */
1912     function setApprovalForAll(address operator, bool approved)
1913         public
1914         override
1915     {
1916         address sender = _msgSender();
1917         require(operator != sender, "approve to caller");
1918 
1919         _operatorApprovals[sender][operator] = approved;
1920         emit ApprovalForAll(sender, operator, approved);
1921     }
1922 
1923     /**
1924      * @dev See {IERC721-isApprovedForAll}.
1925      */
1926     function isApprovedForAll(address owner, address operator)
1927         public
1928         view
1929         override
1930         returns (bool)
1931     {
1932         return _operatorApprovals[owner][operator];
1933     }
1934 
1935     /**
1936      * @dev See {IERC721-transferFrom}.
1937      */
1938     function transferFrom(
1939         address from,
1940         address to,
1941         uint256 tokenId
1942     ) public override {
1943         //solhint-disable-next-line max-line-length
1944         address sender = _msgSender();
1945         require(
1946             _isApprovedOrOwner(sender, tokenId),
1947             "transfer caller is not owner nor approved"
1948         );
1949 
1950         _transfer(from, to, tokenId);
1951     }
1952 
1953     /**
1954      * @dev See {IERC721-safeTransferFrom}.
1955      */
1956     function safeTransferFrom(
1957         address from,
1958         address to,
1959         uint256 tokenId
1960     ) public override {
1961         safeTransferFrom(from, to, tokenId, "");
1962     }
1963 
1964     /**
1965      * @dev See {IERC721-safeTransferFrom}.
1966      */
1967     function safeTransferFrom(
1968         address from,
1969         address to,
1970         uint256 tokenId,
1971         bytes memory _data
1972     ) public override {
1973         address sender = _msgSender();
1974 
1975         require(
1976             _isApprovedOrOwner(sender, tokenId),
1977             "transfer caller is not owner nor approved"
1978         );
1979         _safeTransfer(from, to, tokenId, _data);
1980     }
1981 
1982     /**
1983      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1984      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1985      *
1986      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1987      *
1988      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1989      * implement alternative mechanisms to perform token transfer, such as signature-based.
1990      *
1991      * Requirements:
1992      *
1993      * - `from` cannot be the zero address.
1994      * - `to` cannot be the zero address.
1995      * - `tokenId` token must exist and be owned by `from`.
1996      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1997      *
1998      * Emits a {Transfer} event.
1999      */
2000     function _safeTransfer(
2001         address from,
2002         address to,
2003         uint256 tokenId,
2004         bytes memory _data
2005     ) internal virtual {
2006         _transfer(from, to, tokenId);
2007         require(
2008             _checkOnERC721Received(from, to, tokenId, _data),
2009             "transfer to non ERC721Receiver implementer"
2010         );
2011     }
2012 
2013     /**
2014      * @dev Returns whether `tokenId` exists.
2015      *
2016      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2017      *
2018      * Tokens start existing when they are minted (`_mint`),
2019      * and stop existing when they are burned (`_burn`).
2020      */
2021     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2022         return _tokenOwners.contains(tokenId);
2023     }
2024 
2025     /**
2026      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2027      *
2028      * Requirements:
2029      *
2030      * - `tokenId` must exist.
2031      */
2032     function _isApprovedOrOwner(address spender, uint256 tokenId)
2033         internal
2034         view
2035         virtual
2036         returns (bool)
2037     {
2038         require(_exists(tokenId), "operator query for nonexistent token");
2039         address owner = GoldenVoyagerParty.ownerOf(tokenId);
2040         return (spender == owner ||
2041             getApproved(tokenId) == spender ||
2042             GoldenVoyagerParty.isApprovedForAll(owner, spender));
2043     }
2044 
2045     /**
2046      * @dev Destroys `tokenId`.
2047      * The approval is cleared when the token is burned.
2048      *
2049      * Requirements:
2050      *
2051      * - `tokenId` must exist.
2052      *
2053      * Emits a {Transfer} event.
2054      */
2055     function _burn(uint256 tokenId) internal virtual {
2056         address owner = GoldenVoyagerParty.ownerOf(tokenId); // internal owner
2057 
2058         // Clear approvals
2059         _approve(address(0), tokenId);
2060 
2061         // Clear metadata (if any)
2062         if (bytes(_tokenURIs[tokenId]).length != 0) {
2063             delete _tokenURIs[tokenId];
2064         }
2065 
2066         _holderTokens[owner].remove(tokenId);
2067 
2068         _tokenOwners.remove(tokenId);
2069 
2070         emit Transfer(owner, address(0), tokenId);
2071     }
2072 
2073     /**
2074      * @dev Safely mints `tokenId` and transfers it to `to`.
2075      *
2076      * Requirements:
2077      d*
2078      * - `tokenId` must not exist.
2079      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2080      *
2081      * Emits a {Transfer} event.
2082      */
2083     function _safeMint(address to, uint256 tokenId) internal virtual {
2084         _safeMint(to, tokenId, "");
2085     }
2086 
2087     /**
2088      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2089      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2090      */
2091     function _safeMint(
2092         address to,
2093         uint256 tokenId,
2094         bytes memory _data
2095     ) internal virtual {
2096         require(
2097             _checkOnERC721Received(address(0), to, tokenId, _data),
2098             "transfer to non ERC721Receiver implementer"
2099         );
2100         _mint(to, tokenId);
2101     }
2102 
2103     /**
2104      * @dev Mints `tokenId` and transfers it to `to`.
2105      *
2106      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2107      *
2108      * Requirements:
2109      *
2110      * - `tokenId` must not exist.
2111      * - `to` cannot be the zero address.
2112      *
2113      * Emits a {Transfer} event.
2114      */
2115     function _mint(address to, uint256 tokenId) internal virtual {
2116         require(!_exists(tokenId), "token already minted");
2117         _holderTokens[to].add(tokenId);
2118         _tokenOwners.set(tokenId, to);
2119         emit Transfer(address(0), to, tokenId);
2120     }
2121 
2122     /**
2123      * @dev Transfers `tokenId` from `from` to `to`.
2124      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2125      *
2126      * Requirements:
2127      *
2128      * - `to` cannot be the zero address.
2129      * - `tokenId` token must be owned by `from`.
2130      *
2131      * Emits a {Transfer} event.
2132      */
2133     function _transfer(
2134         address from,
2135         address to,
2136         uint256 tokenId
2137     ) internal virtual {
2138         require(
2139             GoldenVoyagerParty.ownerOf(tokenId) == from,
2140             "transfer of token that is not own"
2141         ); // internal owner
2142         require(to != address(0), "transfer to the zero address");
2143 
2144         // Clear approvals from the previous owner
2145         _approve(address(0), tokenId);
2146 
2147         _holderTokens[from].remove(tokenId);
2148         _holderTokens[to].add(tokenId);
2149 
2150         _tokenOwners.set(tokenId, to);
2151 
2152         emit Transfer(from, to, tokenId);
2153     }
2154 
2155     /**
2156      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
2157      *
2158      * Requirements:
2159      *
2160      * - `tokenId` must exist.
2161      */
2162     function setTokenURI(uint256 tokenId, string memory _tokenURI)
2163         public
2164         onlyOwner
2165     {
2166         require(_exists(tokenId), "URI set of nonexistent token");
2167         _tokenURIs[tokenId] = _tokenURI;
2168     }
2169 
2170     /**
2171      * @dev Internal function to set the base URI for all token IDs. It is
2172      * automatically added as a prefix to the value returned in {tokenURI},
2173      * or to the token ID if {tokenURI} is empty.
2174      */
2175     function setBaseURI(string memory baseURI_) public onlyOwner {
2176         _baseURI = baseURI_;
2177     }
2178 
2179     /**
2180      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2181      * The call is not executed if the target address is not a contract.
2182      *
2183      * @param from address representing the previous owner of the given token ID
2184      * @param to target address that will receive the tokens
2185      * @param tokenId uint256 ID of the token to be transferred
2186      * @param _data bytes optional data to send along with the call
2187      * @return bool whether the call correctly returned the expected magic value
2188      */
2189     function _checkOnERC721Received(
2190         address from,
2191         address to,
2192         uint256 tokenId,
2193         bytes memory _data
2194     ) private returns (bool) {
2195         if (!to.isContract()) {
2196             return true;
2197         }
2198         bytes memory returndata = to.functionCall(
2199             abi.encodeWithSelector(
2200                 IERC721Receiver(to).onERC721Received.selector,
2201                 _msgSender(),
2202                 from,
2203                 tokenId,
2204                 _data
2205             ),
2206             "transfer to non ERC721Receiver implementer"
2207         );
2208         bytes4 retval = abi.decode(returndata, (bytes4));
2209         return (retval == _ERC721_RECEIVED);
2210     }
2211 
2212     /**
2213      * @dev Approve `to` to operate on `tokenId`
2214      *
2215      * Emits an {Approval} event.
2216      */
2217     function _approve(address to, uint256 tokenId) internal virtual {
2218         _tokenApprovals[tokenId] = to;
2219         emit Approval(GoldenVoyagerParty.ownerOf(tokenId), to, tokenId); // internal owner
2220     }
2221 }