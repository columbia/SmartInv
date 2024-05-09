1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.0 <0.8.0;
3 
4 /**
5  * Gen Art ERC721 Membership Token
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
1461 /*
1462  * @dev Provides information about the current execution context, including the
1463  * sender of the transaction and its data. While these are generally available
1464  * via msg.sender and msg.data, they should not be accessed in such a direct
1465  * manner, since when dealing with GSN meta-transactions the account sending and
1466  * paying for execution may not be the actual sender (as far as an application
1467  * is concerned).
1468  *
1469  * This contract is only required for intermediate, library-like contracts.
1470  */
1471 abstract contract Context {
1472     function _msgSender() internal view virtual returns (address payable) {
1473         return msg.sender;
1474     }
1475 
1476     function _msgData() internal view virtual returns (bytes memory) {
1477         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1478         return msg.data;
1479     }
1480 }
1481 
1482 /**
1483  * @dev Contract module which provides a basic access control mechanism, where
1484  * there is an account (an owner) that can be granted exclusive access to
1485  * specific functions.
1486  *
1487  * By default, the owner account will be the one that deploys the contract. This
1488  * can later be changed with {transferOwnership}.
1489  *
1490  * This module is used through inheritance. It will make available the modifier
1491  * `onlyOwner`, which can be applied to your functions to restrict their use to
1492  * the owner.
1493  */
1494 abstract contract Ownable is Context {
1495     address payable private _owner;
1496 
1497     event OwnershipTransferred(
1498         address indexed previousOwner,
1499         address indexed newOwner
1500     );
1501 
1502     /**
1503      * @dev Initializes the contract setting the deployer as the initial owner.
1504      */
1505     constructor() internal {
1506         address payable msgSender = _msgSender();
1507         _owner = msgSender;
1508         emit OwnershipTransferred(address(0), msgSender);
1509     }
1510 
1511     /**
1512      * @dev Returns the address of the current owner.
1513      */
1514     function owner() public view virtual returns (address payable) {
1515         return _owner;
1516     }
1517 
1518     /**
1519      * @dev Throws if called by any account other than the owner.
1520      */
1521     modifier onlyOwner() {
1522         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1523         _;
1524     }
1525 
1526     /**
1527      * @dev Leaves the contract without owner. It will not be possible to call
1528      * `onlyOwner` functions anymore. Can only be called by the current owner.
1529      *
1530      * NOTE: Renouncing ownership will leave the contract without an owner,
1531      * thereby removing any functionality that is only available to the owner.
1532      */
1533     function renounceOwnership() public virtual onlyOwner {
1534         emit OwnershipTransferred(_owner, address(0));
1535         _owner = address(0);
1536     }
1537 
1538     /**
1539      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1540      * Can only be called by the current owner.
1541      */
1542     function transferOwnership(address payable newOwner)
1543         public
1544         virtual
1545         onlyOwner
1546     {
1547         require(
1548             newOwner != address(0),
1549             "Ownable: new owner is the zero address"
1550         );
1551         emit OwnershipTransferred(_owner, newOwner);
1552         _owner = newOwner;
1553     }
1554 }
1555 
1556 /**
1557  * @title ERC721 Non-Fungible Token Standard basic implementation
1558  * @dev see https://eips.ethereum.org/EIPS/eip-721
1559  */
1560 contract GenArt is
1561     Ownable,
1562     ERC165,
1563     IERC721,
1564     IERC721Metadata,
1565     IERC721Enumerable
1566 {
1567     using SafeMath for uint256;
1568     using Address for address;
1569     using EnumerableSet for EnumerableSet.UintSet;
1570     using EnumerableMap for EnumerableMap.UintToAddressMap;
1571 
1572     event Mint(address indexed to, uint256 tokenId, bool isGold);
1573 
1574     uint256 MAX_MEMBERS = 5000;
1575     uint256 MAX_MEMBERS_GOLD = 100;
1576     uint256 MEMBERSHIP_PRICE = 100000000000000000; // 0.1 ETH
1577     uint256 MEMBERSHIP_GOLD_PRICE = 500000000000000000; // 0.5 ETH
1578 
1579     bool private _paused = true;
1580     uint256 _reservedTokens = 20;
1581     uint256 _reservedTokensGold = 5;
1582 
1583     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1584     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1585     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1586 
1587     string private _uri_standard;
1588     string private _uri_gold;
1589     // Mapping from holder address to their (enumerable) set of owned tokens
1590     mapping(address => EnumerableSet.UintSet) private _holderTokens;
1591     mapping(uint256 => bool) private _goldTokens;
1592 
1593     // Enumerable mapping from token ids to their owners
1594     EnumerableMap.UintToAddressMap private _tokenOwners;
1595     EnumerableMap.UintToAddressMap private _goldOwners;
1596 
1597     // Mapping from token ID to approved address
1598     mapping(uint256 => address) private _tokenApprovals;
1599 
1600     // Mapping from owner to operator approvals
1601     mapping(address => mapping(address => bool)) private _operatorApprovals;
1602 
1603     // Token name
1604     string private _name;
1605 
1606     // Token symbol
1607     string private _symbol;
1608 
1609     // Optional mapping for token URIs
1610     mapping(uint256 => string) private _tokenURIs;
1611 
1612     // Base URI
1613     string private _baseURI;
1614 
1615     /*
1616      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1617      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1618      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1619      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1620      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1621      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1622      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1623      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1624      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1625      *
1626      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1627      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1628      */
1629     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1630 
1631     /*
1632      *     bytes4(keccak256('name()')) == 0x06fdde03
1633      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1634      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1635      *
1636      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1637      */
1638     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1639 
1640     /*
1641      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1642      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1643      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1644      *
1645      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1646      */
1647     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1648 
1649     /**
1650      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1651      */
1652     constructor(
1653         string memory name_,
1654         string memory symbol_,
1655         string memory uri_standard_,
1656         string memory uri_gold_,
1657         uint256 max_members_
1658     ) public {
1659         _name = name_;
1660         _symbol = symbol_;
1661         _uri_standard = uri_standard_;
1662         _uri_gold = uri_gold_;
1663         MAX_MEMBERS = max_members_;
1664         // register the supported interfaces to conform to ERC721 via ERC165
1665         _registerInterface(_INTERFACE_ID_ERC721);
1666         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1667         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1668     }
1669 
1670     function mint(address _to) public payable {
1671         require(!_paused, "minting is paused");
1672         require(msg.value >= MEMBERSHIP_PRICE, "wrong amount sent");
1673         uint256 _totalSupplyGold = totalGoldOwners();
1674         uint256 _totalSupply = totalSupply() - _totalSupplyGold;
1675         require(_totalSupply < MAX_MEMBERS, "mint would exceed totalSupply");
1676         uint256 _tokenId = _totalSupply + 1;
1677         _safeMint(_to, _tokenId);
1678         emit Mint(_to, _tokenId, false);
1679     }
1680 
1681     function mintMany(address _to, uint256 amount) public payable {
1682         require(!_paused, "minting is paused");
1683         require(msg.value >= (MEMBERSHIP_PRICE * amount), "wrong amount sent");
1684         _mintMany(_to, amount);
1685     }
1686 
1687     function mintGold(address _to) public payable {
1688         require(!_paused, "minting is paused");
1689         require(msg.value >= MEMBERSHIP_GOLD_PRICE, "wrong amount sent");
1690         _mintGold(_to);
1691     }
1692 
1693     function _mintGold(address _to) internal virtual {
1694         uint256 _totalSupply = totalGoldOwners();
1695         uint256 _tokenId = MAX_MEMBERS + _totalSupply + 1;
1696         require(
1697             _tokenId <= MAX_MEMBERS + MAX_MEMBERS_GOLD,
1698             "mint would exceed totalSupply"
1699         );
1700         _goldOwners.set(_tokenId, _to);
1701         _safeMint(_to, _tokenId);
1702         emit Mint(_to, _tokenId, true);
1703     }
1704 
1705     function _mintMany(address _to, uint256 _amount) internal {
1706         require(_to != address(0), "mint to the zero address");
1707         uint256 _totalSupplyGold = totalGoldOwners();
1708         uint256 _totalSupply = totalSupply() - _totalSupplyGold;
1709         require(
1710             (_totalSupply + _amount) <= MAX_MEMBERS,
1711             "mint would exceed totalSupply"
1712         );
1713         for (uint256 i = 0; i < _amount; i++) {
1714             uint256 _tokenId = _totalSupply + 1 + i;
1715             _safeMint(_to, _tokenId);
1716             emit Mint(_to, _tokenId, false);
1717         }
1718     }
1719 
1720     function withdraw(uint256 value) public onlyOwner {
1721         address payable _owner = owner();
1722         _owner.transfer(value);
1723     }
1724 
1725     function setPaused(bool _isPaused) public onlyOwner {
1726         _paused = _isPaused;
1727     }
1728 
1729     function setUriStandard(string memory _uri) public onlyOwner {
1730         _uri_standard = _uri;
1731     }
1732 
1733     function setUriGold(string memory _uri) public onlyOwner {
1734         _uri_gold = _uri;
1735     }
1736 
1737     function mintReservedGold(address _to) public onlyOwner {
1738         uint256 _totalSupply = totalGoldOwners();
1739         require(
1740             _totalSupply < MAX_MEMBERS_GOLD,
1741             "mint exceeds Gold totalSupply"
1742         );
1743         _mintGold(_to);
1744         _reservedTokensGold = _reservedTokensGold - 1;
1745     }
1746 
1747     function mintReserved(address _to, uint256 _amount) public onlyOwner {
1748         require(
1749             _amount <= _reservedTokens,
1750             "reserved token mint exceeds limit"
1751         );
1752         uint256 _totalSupply = totalSupply();
1753         require(
1754             (_totalSupply + _amount) <= MAX_MEMBERS,
1755             "mint exceeds totalSupply"
1756         );
1757         _mintMany(_to, _amount);
1758         _reservedTokens = _reservedTokens - _amount;
1759     }
1760 
1761     function totalGoldOwners() public view returns (uint256) {
1762         return _goldOwners.length();
1763     }
1764 
1765     function isGoldToken(uint256 _tokenId) public view returns (bool) {
1766         return int256(_tokenId) - int256(MAX_MEMBERS) > 0;
1767     }
1768 
1769     function getTokensByOwner(address _owner)
1770         public
1771         view
1772         returns (uint256[] memory)
1773     {
1774         uint256 tokenCount = balanceOf(_owner);
1775         uint256[] memory tokenIds = new uint256[](tokenCount);
1776         for (uint256 i; i < tokenCount; i++) {
1777             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1778         }
1779 
1780         return tokenIds;
1781     }
1782 
1783     /**
1784      * @dev See {IERC721-balanceOf}.
1785      */
1786     function balanceOf(address owner) public view override returns (uint256) {
1787         require(owner != address(0), "balance query for the zero address");
1788         return _holderTokens[owner].length();
1789     }
1790 
1791     /**
1792      * @dev See {IERC721-ownerOf}.
1793      */
1794     function ownerOf(uint256 tokenId) public view override returns (address) {
1795         return _tokenOwners.get(tokenId, "owner query for nonexistent token");
1796     }
1797 
1798     /**
1799      * @dev See {IERC721Metadata-name}.
1800      */
1801     function name() public view virtual override returns (string memory) {
1802         return _name;
1803     }
1804 
1805     /**
1806      * @dev See {IERC721Metadata-symbol}.
1807      */
1808     function symbol() public view virtual override returns (string memory) {
1809         return _symbol;
1810     }
1811 
1812     /**
1813      * @dev See {IERC721Metadata-tokenURI}.
1814      */
1815     function tokenURI(uint256 tokenId)
1816         public
1817         view
1818         virtual
1819         override
1820         returns (string memory)
1821     {
1822         require(_exists(tokenId), "URI query for nonexistent token");
1823         bool isGold = isGoldToken(tokenId);
1824 
1825         if (isGold) {
1826             return _uri_gold;
1827         }
1828 
1829         return _uri_standard;
1830     }
1831 
1832     /**
1833      * @dev Returns the base URI set via {_setBaseURI}. This will be
1834      * automatically added as a prefix in {tokenURI} to each token's URI, or
1835      * to the token ID if no specific URI is set for that token ID.
1836      */
1837     function baseURI() public view returns (string memory) {
1838         return _baseURI;
1839     }
1840 
1841     /**
1842      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1843      */
1844     function tokenOfOwnerByIndex(address owner, uint256 index)
1845         public
1846         view
1847         virtual
1848         override
1849         returns (uint256)
1850     {
1851         return _holderTokens[owner].at(index);
1852     }
1853 
1854     /**
1855      * @dev See {IERC721Enumerable-totalSupply}.
1856      */
1857     function totalSupply() public view override returns (uint256) {
1858         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1859         return _tokenOwners.length();
1860     }
1861 
1862     /**
1863      * @dev See {IERC721Enumerable-tokenByIndex}.
1864      */
1865     function tokenByIndex(uint256 index)
1866         public
1867         view
1868         virtual
1869         override
1870         returns (uint256)
1871     {
1872         (uint256 tokenId, ) = _tokenOwners.at(index);
1873         return tokenId;
1874     }
1875 
1876     /**
1877      * @dev See {IERC721-approve}.
1878      */
1879     function approve(address to, uint256 tokenId) public override {
1880         address owner = GenArt.ownerOf(tokenId);
1881         require(to != owner, "approval to current owner");
1882         address sender = _msgSender();
1883         require(
1884             sender == owner || GenArt.isApprovedForAll(owner, sender),
1885             "approve caller is not owner nor approved for all"
1886         );
1887 
1888         _approve(to, tokenId);
1889     }
1890 
1891     /**
1892      * @dev See {IERC721-getApproved}.
1893      */
1894     function getApproved(uint256 tokenId)
1895         public
1896         view
1897         override
1898         returns (address)
1899     {
1900         require(_exists(tokenId), "approved query for nonexistent token");
1901 
1902         return _tokenApprovals[tokenId];
1903     }
1904 
1905     /**
1906      * @dev See {IERC721-setApprovalForAll}.
1907      */
1908     function setApprovalForAll(address operator, bool approved)
1909         public
1910         override
1911     {
1912         address sender = _msgSender();
1913         require(operator != sender, "approve to caller");
1914 
1915         _operatorApprovals[sender][operator] = approved;
1916         emit ApprovalForAll(sender, operator, approved);
1917     }
1918 
1919     /**
1920      * @dev See {IERC721-isApprovedForAll}.
1921      */
1922     function isApprovedForAll(address owner, address operator)
1923         public
1924         view
1925         override
1926         returns (bool)
1927     {
1928         return _operatorApprovals[owner][operator];
1929     }
1930 
1931     /**
1932      * @dev See {IERC721-transferFrom}.
1933      */
1934     function transferFrom(
1935         address from,
1936         address to,
1937         uint256 tokenId
1938     ) public override {
1939         //solhint-disable-next-line max-line-length
1940         address sender = _msgSender();
1941         require(
1942             _isApprovedOrOwner(sender, tokenId),
1943             "transfer caller is not owner nor approved"
1944         );
1945 
1946         _transfer(from, to, tokenId);
1947     }
1948 
1949     /**
1950      * @dev See {IERC721-safeTransferFrom}.
1951      */
1952     function safeTransferFrom(
1953         address from,
1954         address to,
1955         uint256 tokenId
1956     ) public override {
1957         safeTransferFrom(from, to, tokenId, "");
1958     }
1959 
1960     /**
1961      * @dev See {IERC721-safeTransferFrom}.
1962      */
1963     function safeTransferFrom(
1964         address from,
1965         address to,
1966         uint256 tokenId,
1967         bytes memory _data
1968     ) public override {
1969         address sender = _msgSender();
1970 
1971         require(
1972             _isApprovedOrOwner(sender, tokenId),
1973             "transfer caller is not owner nor approved"
1974         );
1975         _safeTransfer(from, to, tokenId, _data);
1976     }
1977 
1978     /**
1979      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1980      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1981      *
1982      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1983      *
1984      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1985      * implement alternative mechanisms to perform token transfer, such as signature-based.
1986      *
1987      * Requirements:
1988      *
1989      * - `from` cannot be the zero address.
1990      * - `to` cannot be the zero address.
1991      * - `tokenId` token must exist and be owned by `from`.
1992      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1993      *
1994      * Emits a {Transfer} event.
1995      */
1996     function _safeTransfer(
1997         address from,
1998         address to,
1999         uint256 tokenId,
2000         bytes memory _data
2001     ) internal virtual {
2002         _transfer(from, to, tokenId);
2003         require(
2004             _checkOnERC721Received(from, to, tokenId, _data),
2005             "transfer to non ERC721Receiver implementer"
2006         );
2007     }
2008 
2009     /**
2010      * @dev Returns whether `tokenId` exists.
2011      *
2012      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2013      *
2014      * Tokens start existing when they are minted (`_mint`),
2015      * and stop existing when they are burned (`_burn`).
2016      */
2017     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2018         return _tokenOwners.contains(tokenId);
2019     }
2020 
2021     /**
2022      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2023      *
2024      * Requirements:
2025      *
2026      * - `tokenId` must exist.
2027      */
2028     function _isApprovedOrOwner(address spender, uint256 tokenId)
2029         internal
2030         view
2031         virtual
2032         returns (bool)
2033     {
2034         require(_exists(tokenId), "operator query for nonexistent token");
2035         address owner = GenArt.ownerOf(tokenId);
2036         return (spender == owner ||
2037             getApproved(tokenId) == spender ||
2038             GenArt.isApprovedForAll(owner, spender));
2039     }
2040 
2041     /**
2042      * @dev Safely mints `tokenId` and transfers it to `to`.
2043      *
2044      * Requirements:
2045      d*
2046      * - `tokenId` must not exist.
2047      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2048      *
2049      * Emits a {Transfer} event.
2050      */
2051     function _safeMint(address to, uint256 tokenId) internal virtual {
2052         _safeMint(to, tokenId, "");
2053     }
2054 
2055     /**
2056      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2057      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2058      */
2059     function _safeMint(
2060         address to,
2061         uint256 tokenId,
2062         bytes memory _data
2063     ) internal virtual {
2064         require(
2065             _checkOnERC721Received(address(0), to, tokenId, _data),
2066             "transfer to non ERC721Receiver implementer"
2067         );
2068         _mint(to, tokenId);
2069     }
2070 
2071     /**
2072      * @dev Mints `tokenId` and transfers it to `to`.
2073      *
2074      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2075      *
2076      * Requirements:
2077      *
2078      * - `tokenId` must not exist.
2079      * - `to` cannot be the zero address.
2080      *
2081      * Emits a {Transfer} event.
2082      */
2083     function _mint(address to, uint256 tokenId) internal virtual {
2084         require(!_exists(tokenId), "token already minted");
2085         _holderTokens[to].add(tokenId);
2086         _tokenOwners.set(tokenId, to);
2087         emit Transfer(address(0), to, tokenId);
2088     }
2089 
2090     /**
2091      * @dev Transfers `tokenId` from `from` to `to`.
2092      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2093      *
2094      * Requirements:
2095      *
2096      * - `to` cannot be the zero address.
2097      * - `tokenId` token must be owned by `from`.
2098      *
2099      * Emits a {Transfer} event.
2100      */
2101     function _transfer(
2102         address from,
2103         address to,
2104         uint256 tokenId
2105     ) internal virtual {
2106         require(
2107             GenArt.ownerOf(tokenId) == from,
2108             "transfer of token that is not own"
2109         ); // internal owner
2110         require(to != address(0), "transfer to the zero address");
2111 
2112         // Clear approvals from the previous owner
2113         _approve(address(0), tokenId);
2114 
2115         _holderTokens[from].remove(tokenId);
2116         _holderTokens[to].add(tokenId);
2117 
2118         _tokenOwners.set(tokenId, to);
2119 
2120         emit Transfer(from, to, tokenId);
2121     }
2122 
2123     /**
2124      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
2125      *
2126      * Requirements:
2127      *
2128      * - `tokenId` must exist.
2129      */
2130     function setTokenURI(uint256 tokenId, string memory _tokenURI)
2131         public
2132         onlyOwner
2133     {
2134         require(_exists(tokenId), "URI set of nonexistent token");
2135         _tokenURIs[tokenId] = _tokenURI;
2136     }
2137 
2138     /**
2139      * @dev Internal function to set the base URI for all token IDs. It is
2140      * automatically added as a prefix to the value returned in {tokenURI},
2141      * or to the token ID if {tokenURI} is empty.
2142      */
2143     function setBaseURI(string memory baseURI_) public onlyOwner {
2144         _baseURI = baseURI_;
2145     }
2146 
2147     /**
2148      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2149      * The call is not executed if the target address is not a contract.
2150      *
2151      * @param from address representing the previous owner of the given token ID
2152      * @param to target address that will receive the tokens
2153      * @param tokenId uint256 ID of the token to be transferred
2154      * @param _data bytes optional data to send along with the call
2155      * @return bool whether the call correctly returned the expected magic value
2156      */
2157     function _checkOnERC721Received(
2158         address from,
2159         address to,
2160         uint256 tokenId,
2161         bytes memory _data
2162     ) private returns (bool) {
2163         if (!to.isContract()) {
2164             return true;
2165         }
2166         bytes memory returndata = to.functionCall(
2167             abi.encodeWithSelector(
2168                 IERC721Receiver(to).onERC721Received.selector,
2169                 _msgSender(),
2170                 from,
2171                 tokenId,
2172                 _data
2173             ),
2174             "transfer to non ERC721Receiver implementer"
2175         );
2176         bytes4 retval = abi.decode(returndata, (bytes4));
2177         return (retval == _ERC721_RECEIVED);
2178     }
2179 
2180     /**
2181      * @dev Approve `to` to operate on `tokenId`
2182      *
2183      * Emits an {Approval} event.
2184      */
2185     function _approve(address to, uint256 tokenId) internal virtual {
2186         _tokenApprovals[tokenId] = to;
2187         emit Approval(GenArt.ownerOf(tokenId), to, tokenId); // internal owner
2188     }
2189 }