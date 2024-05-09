1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.7.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/introspection/IERC165.sol
29 
30 /**
31  * @dev Interface of the ERC165 standard, as defined in the
32  * https://eips.ethereum.org/EIPS/eip-165[EIP].
33  *
34  * Implementers can declare support of contract interfaces, which can then be
35  * queried by others ({ERC165Checker}).
36  *
37  * For an implementation, see {ERC165}.
38  */
39 interface IERC165 {
40     /**
41      * @dev Returns true if this contract implements the interface defined by
42      * `interfaceId`. See the corresponding
43      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
44      * to learn more about how these ids are created.
45      *
46      * This function call must use less than 30 000 gas.
47      */
48     function supportsInterface(bytes4 interfaceId) external view returns (bool);
49 }
50 
51 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
52 
53 /**
54  * @dev Required interface of an ERC721 compliant contract.
55  */
56 interface IERC721 is IERC165 {
57     /**
58      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
59      */
60     event Transfer(
61         address indexed from,
62         address indexed to,
63         uint256 indexed tokenId
64     );
65 
66     /**
67      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
68      */
69     event Approval(
70         address indexed owner,
71         address indexed approved,
72         uint256 indexed tokenId
73     );
74 
75     /**
76      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
77      */
78     event ApprovalForAll(
79         address indexed owner,
80         address indexed operator,
81         bool approved
82     );
83 
84     /**
85      * @dev Returns the number of tokens in ``owner``'s account.
86      */
87     function balanceOf(address owner) external view returns (uint256 balance);
88 
89     /**
90      * @dev Returns the owner of the `tokenId` token.
91      *
92      * Requirements:
93      *
94      * - `tokenId` must exist.
95      */
96     function ownerOf(uint256 tokenId) external view returns (address owner);
97 
98     /**
99      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
100      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
101      *
102      * Requirements:
103      *
104      * - `from` cannot be the zero address.
105      * - `to` cannot be the zero address.
106      * - `tokenId` token must exist and be owned by `from`.
107      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
108      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
109      *
110      * Emits a {Transfer} event.
111      */
112     function safeTransferFrom(
113         address from,
114         address to,
115         uint256 tokenId
116     ) external;
117 
118     /**
119      * @dev Transfers `tokenId` token from `from` to `to`.
120      *
121      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
122      *
123      * Requirements:
124      *
125      * - `from` cannot be the zero address.
126      * - `to` cannot be the zero address.
127      * - `tokenId` token must be owned by `from`.
128      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
129      *
130      * Emits a {Transfer} event.
131      */
132     function transferFrom(
133         address from,
134         address to,
135         uint256 tokenId
136     ) external;
137 
138     /**
139      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
140      * The approval is cleared when the token is transferred.
141      *
142      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
143      *
144      * Requirements:
145      *
146      * - The caller must own the token or be an approved operator.
147      * - `tokenId` must exist.
148      *
149      * Emits an {Approval} event.
150      */
151     function approve(address to, uint256 tokenId) external;
152 
153     /**
154      * @dev Returns the account approved for `tokenId` token.
155      *
156      * Requirements:
157      *
158      * - `tokenId` must exist.
159      */
160     function getApproved(uint256 tokenId)
161         external
162         view
163         returns (address operator);
164 
165     /**
166      * @dev Approve or remove `operator` as an operator for the caller.
167      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
168      *
169      * Requirements:
170      *
171      * - The `operator` cannot be the caller.
172      *
173      * Emits an {ApprovalForAll} event.
174      */
175     function setApprovalForAll(address operator, bool _approved) external;
176 
177     /**
178      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
179      *
180      * See {setApprovalForAll}
181      */
182     function isApprovedForAll(address owner, address operator)
183         external
184         view
185         returns (bool);
186 
187     /**
188      * @dev Safely transfers `tokenId` token from `from` to `to`.
189      *
190      * Requirements:
191      *
192      * - `from` cannot be the zero address.
193      * - `to` cannot be the zero address.
194      * - `tokenId` token must exist and be owned by `from`.
195      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
196      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
197      *
198      * Emits a {Transfer} event.
199      */
200     function safeTransferFrom(
201         address from,
202         address to,
203         uint256 tokenId,
204         bytes calldata data
205     ) external;
206 }
207 
208 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
209 
210 /**
211  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
212  * @dev See https://eips.ethereum.org/EIPS/eip-721
213  */
214 interface IERC721Metadata is IERC721 {
215     /**
216      * @dev Returns the token collection name.
217      */
218     function name() external view returns (string memory);
219 
220     /**
221      * @dev Returns the token collection symbol.
222      */
223     function symbol() external view returns (string memory);
224 
225     /**
226      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
227      */
228     function tokenURI(uint256 tokenId) external view returns (string memory);
229 }
230 
231 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
232 
233 /**
234  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
235  * @dev See https://eips.ethereum.org/EIPS/eip-721
236  */
237 interface IERC721Enumerable is IERC721 {
238     /**
239      * @dev Returns the total amount of tokens stored by the contract.
240      */
241     function totalSupply() external view returns (uint256);
242 
243     /**
244      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
245      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
246      */
247     function tokenOfOwnerByIndex(address owner, uint256 index)
248         external
249         view
250         returns (uint256 tokenId);
251 
252     /**
253      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
254      * Use along with {totalSupply} to enumerate all tokens.
255      */
256     function tokenByIndex(uint256 index) external view returns (uint256);
257 }
258 
259 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
260 
261 /**
262  * @title ERC721 token receiver interface
263  * @dev Interface for any contract that wants to support safeTransfers
264  * from ERC721 asset contracts.
265  */
266 interface IERC721Receiver {
267     /**
268      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
269      * by `operator` from `from`, this function is called.
270      *
271      * It must return its Solidity selector to confirm the token transfer.
272      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
273      *
274      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
275      */
276     function onERC721Received(
277         address operator,
278         address from,
279         uint256 tokenId,
280         bytes calldata data
281     ) external returns (bytes4);
282 }
283 
284 // File: @openzeppelin/contracts/introspection/ERC165.sol
285 
286 /**
287  * @dev Implementation of the {IERC165} interface.
288  *
289  * Contracts may inherit from this and call {_registerInterface} to declare
290  * their support of an interface.
291  */
292 abstract contract ERC165 is IERC165 {
293     /*
294      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
295      */
296     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
297 
298     /**
299      * @dev Mapping of interface ids to whether or not it's supported.
300      */
301     mapping(bytes4 => bool) private _supportedInterfaces;
302 
303     constructor() {
304         // Derived contracts need only register support for their own interfaces,
305         // we register support for ERC165 itself here
306         _registerInterface(_INTERFACE_ID_ERC165);
307     }
308 
309     /**
310      * @dev See {IERC165-supportsInterface}.
311      *
312      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
313      */
314     function supportsInterface(bytes4 interfaceId)
315         public
316         view
317         virtual
318         override
319         returns (bool)
320     {
321         return _supportedInterfaces[interfaceId];
322     }
323 
324     /**
325      * @dev Registers the contract as an implementer of the interface defined by
326      * `interfaceId`. Support of the actual ERC165 interface is automatic and
327      * registering its interface id is not required.
328      *
329      * See {IERC165-supportsInterface}.
330      *
331      * Requirements:
332      *
333      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
334      */
335     function _registerInterface(bytes4 interfaceId) internal virtual {
336         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
337         _supportedInterfaces[interfaceId] = true;
338     }
339 }
340 
341 // File: @openzeppelin/contracts/math/SafeMath.sol
342 
343 /**
344  * @dev Wrappers over Solidity's arithmetic operations with added overflow
345  * checks.
346  *
347  * Arithmetic operations in Solidity wrap on overflow. This can easily result
348  * in bugs, because programmers usually assume that an overflow raises an
349  * error, which is the standard behavior in high level programming languages.
350  * `SafeMath` restores this intuition by reverting the transaction when an
351  * operation overflows.
352  *
353  * Using this library instead of the unchecked operations eliminates an entire
354  * class of bugs, so it's recommended to use it always.
355  */
356 library SafeMath {
357     /**
358      * @dev Returns the addition of two unsigned integers, with an overflow flag.
359      *
360      * _Available since v3.4._
361      */
362     function tryAdd(uint256 a, uint256 b)
363         internal
364         pure
365         returns (bool, uint256)
366     {
367         uint256 c = a + b;
368         if (c < a) return (false, 0);
369         return (true, c);
370     }
371 
372     /**
373      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
374      *
375      * _Available since v3.4._
376      */
377     function trySub(uint256 a, uint256 b)
378         internal
379         pure
380         returns (bool, uint256)
381     {
382         if (b > a) return (false, 0);
383         return (true, a - b);
384     }
385 
386     /**
387      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
388      *
389      * _Available since v3.4._
390      */
391     function tryMul(uint256 a, uint256 b)
392         internal
393         pure
394         returns (bool, uint256)
395     {
396         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
397         // benefit is lost if 'b' is also tested.
398         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
399         if (a == 0) return (true, 0);
400         uint256 c = a * b;
401         if (c / a != b) return (false, 0);
402         return (true, c);
403     }
404 
405     /**
406      * @dev Returns the division of two unsigned integers, with a division by zero flag.
407      *
408      * _Available since v3.4._
409      */
410     function tryDiv(uint256 a, uint256 b)
411         internal
412         pure
413         returns (bool, uint256)
414     {
415         if (b == 0) return (false, 0);
416         return (true, a / b);
417     }
418 
419     /**
420      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
421      *
422      * _Available since v3.4._
423      */
424     function tryMod(uint256 a, uint256 b)
425         internal
426         pure
427         returns (bool, uint256)
428     {
429         if (b == 0) return (false, 0);
430         return (true, a % b);
431     }
432 
433     /**
434      * @dev Returns the addition of two unsigned integers, reverting on
435      * overflow.
436      *
437      * Counterpart to Solidity's `+` operator.
438      *
439      * Requirements:
440      *
441      * - Addition cannot overflow.
442      */
443     function add(uint256 a, uint256 b) internal pure returns (uint256) {
444         uint256 c = a + b;
445         require(c >= a, "SafeMath: addition overflow");
446         return c;
447     }
448 
449     /**
450      * @dev Returns the subtraction of two unsigned integers, reverting on
451      * overflow (when the result is negative).
452      *
453      * Counterpart to Solidity's `-` operator.
454      *
455      * Requirements:
456      *
457      * - Subtraction cannot overflow.
458      */
459     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
460         require(b <= a, "SafeMath: subtraction overflow");
461         return a - b;
462     }
463 
464     /**
465      * @dev Returns the multiplication of two unsigned integers, reverting on
466      * overflow.
467      *
468      * Counterpart to Solidity's `*` operator.
469      *
470      * Requirements:
471      *
472      * - Multiplication cannot overflow.
473      */
474     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
475         if (a == 0) return 0;
476         uint256 c = a * b;
477         require(c / a == b, "SafeMath: multiplication overflow");
478         return c;
479     }
480 
481     /**
482      * @dev Returns the integer division of two unsigned integers, reverting on
483      * division by zero. The result is rounded towards zero.
484      *
485      * Counterpart to Solidity's `/` operator. Note: this function uses a
486      * `revert` opcode (which leaves remaining gas untouched) while Solidity
487      * uses an invalid opcode to revert (consuming all remaining gas).
488      *
489      * Requirements:
490      *
491      * - The divisor cannot be zero.
492      */
493     function div(uint256 a, uint256 b) internal pure returns (uint256) {
494         require(b > 0, "SafeMath: division by zero");
495         return a / b;
496     }
497 
498     /**
499      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
500      * reverting when dividing by zero.
501      *
502      * Counterpart to Solidity's `%` operator. This function uses a `revert`
503      * opcode (which leaves remaining gas untouched) while Solidity uses an
504      * invalid opcode to revert (consuming all remaining gas).
505      *
506      * Requirements:
507      *
508      * - The divisor cannot be zero.
509      */
510     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
511         require(b > 0, "SafeMath: modulo by zero");
512         return a % b;
513     }
514 
515     /**
516      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
517      * overflow (when the result is negative).
518      *
519      * CAUTION: This function is deprecated because it requires allocating memory for the error
520      * message unnecessarily. For custom revert reasons use {trySub}.
521      *
522      * Counterpart to Solidity's `-` operator.
523      *
524      * Requirements:
525      *
526      * - Subtraction cannot overflow.
527      */
528     function sub(
529         uint256 a,
530         uint256 b,
531         string memory errorMessage
532     ) internal pure returns (uint256) {
533         require(b <= a, errorMessage);
534         return a - b;
535     }
536 
537     /**
538      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
539      * division by zero. The result is rounded towards zero.
540      *
541      * CAUTION: This function is deprecated because it requires allocating memory for the error
542      * message unnecessarily. For custom revert reasons use {tryDiv}.
543      *
544      * Counterpart to Solidity's `/` operator. Note: this function uses a
545      * `revert` opcode (which leaves remaining gas untouched) while Solidity
546      * uses an invalid opcode to revert (consuming all remaining gas).
547      *
548      * Requirements:
549      *
550      * - The divisor cannot be zero.
551      */
552     function div(
553         uint256 a,
554         uint256 b,
555         string memory errorMessage
556     ) internal pure returns (uint256) {
557         require(b > 0, errorMessage);
558         return a / b;
559     }
560 
561     /**
562      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
563      * reverting with custom message when dividing by zero.
564      *
565      * CAUTION: This function is deprecated because it requires allocating memory for the error
566      * message unnecessarily. For custom revert reasons use {tryMod}.
567      *
568      * Counterpart to Solidity's `%` operator. This function uses a `revert`
569      * opcode (which leaves remaining gas untouched) while Solidity uses an
570      * invalid opcode to revert (consuming all remaining gas).
571      *
572      * Requirements:
573      *
574      * - The divisor cannot be zero.
575      */
576     function mod(
577         uint256 a,
578         uint256 b,
579         string memory errorMessage
580     ) internal pure returns (uint256) {
581         require(b > 0, errorMessage);
582         return a % b;
583     }
584 }
585 
586 // File: @openzeppelin/contracts/utils/Address.sol
587 
588 /**
589  * @dev Collection of functions related to the address type
590  */
591 library Address {
592     /**
593      * @dev Returns true if `account` is a contract.
594      *
595      * [IMPORTANT]
596      * ====
597      * It is unsafe to assume that an address for which this function returns
598      * false is an externally-owned account (EOA) and not a contract.
599      *
600      * Among others, `isContract` will return false for the following
601      * types of addresses:
602      *
603      *  - an externally-owned account
604      *  - a contract in construction
605      *  - an address where a contract will be created
606      *  - an address where a contract lived, but was destroyed
607      * ====
608      */
609     function isContract(address account) internal view returns (bool) {
610         // This method relies on extcodesize, which returns 0 for contracts in
611         // construction, since the code is only stored at the end of the
612         // constructor execution.
613 
614         uint256 size;
615         // solhint-disable-next-line no-inline-assembly
616         assembly {
617             size := extcodesize(account)
618         }
619         return size > 0;
620     }
621 
622     /**
623      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
624      * `recipient`, forwarding all available gas and reverting on errors.
625      *
626      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
627      * of certain opcodes, possibly making contracts go over the 2300 gas limit
628      * imposed by `transfer`, making them unable to receive funds via
629      * `transfer`. {sendValue} removes this limitation.
630      *
631      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
632      *
633      * IMPORTANT: because control is transferred to `recipient`, care must be
634      * taken to not create reentrancy vulnerabilities. Consider using
635      * {ReentrancyGuard} or the
636      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
637      */
638     function sendValue(address payable recipient, uint256 amount) internal {
639         require(
640             address(this).balance >= amount,
641             "Address: insufficient balance"
642         );
643 
644         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
645         (bool success, ) = recipient.call{value: amount}("");
646         require(
647             success,
648             "Address: unable to send value, recipient may have reverted"
649         );
650     }
651 
652     /**
653      * @dev Performs a Solidity function call using a low level `call`. A
654      * plain`call` is an unsafe replacement for a function call: use this
655      * function instead.
656      *
657      * If `target` reverts with a revert reason, it is bubbled up by this
658      * function (like regular Solidity function calls).
659      *
660      * Returns the raw returned data. To convert to the expected return value,
661      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
662      *
663      * Requirements:
664      *
665      * - `target` must be a contract.
666      * - calling `target` with `data` must not revert.
667      *
668      * _Available since v3.1._
669      */
670     function functionCall(address target, bytes memory data)
671         internal
672         returns (bytes memory)
673     {
674         return functionCall(target, data, "Address: low-level call failed");
675     }
676 
677     /**
678      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
679      * `errorMessage` as a fallback revert reason when `target` reverts.
680      *
681      * _Available since v3.1._
682      */
683     function functionCall(
684         address target,
685         bytes memory data,
686         string memory errorMessage
687     ) internal returns (bytes memory) {
688         return functionCallWithValue(target, data, 0, errorMessage);
689     }
690 
691     /**
692      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
693      * but also transferring `value` wei to `target`.
694      *
695      * Requirements:
696      *
697      * - the calling contract must have an ETH balance of at least `value`.
698      * - the called Solidity function must be `payable`.
699      *
700      * _Available since v3.1._
701      */
702     function functionCallWithValue(
703         address target,
704         bytes memory data,
705         uint256 value
706     ) internal returns (bytes memory) {
707         return
708             functionCallWithValue(
709                 target,
710                 data,
711                 value,
712                 "Address: low-level call with value failed"
713             );
714     }
715 
716     /**
717      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
718      * with `errorMessage` as a fallback revert reason when `target` reverts.
719      *
720      * _Available since v3.1._
721      */
722     function functionCallWithValue(
723         address target,
724         bytes memory data,
725         uint256 value,
726         string memory errorMessage
727     ) internal returns (bytes memory) {
728         require(
729             address(this).balance >= value,
730             "Address: insufficient balance for call"
731         );
732         require(isContract(target), "Address: call to non-contract");
733 
734         // solhint-disable-next-line avoid-low-level-calls
735         (bool success, bytes memory returndata) = target.call{value: value}(
736             data
737         );
738         return _verifyCallResult(success, returndata, errorMessage);
739     }
740 
741     /**
742      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
743      * but performing a static call.
744      *
745      * _Available since v3.3._
746      */
747     function functionStaticCall(address target, bytes memory data)
748         internal
749         view
750         returns (bytes memory)
751     {
752         return
753             functionStaticCall(
754                 target,
755                 data,
756                 "Address: low-level static call failed"
757             );
758     }
759 
760     /**
761      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
762      * but performing a static call.
763      *
764      * _Available since v3.3._
765      */
766     function functionStaticCall(
767         address target,
768         bytes memory data,
769         string memory errorMessage
770     ) internal view returns (bytes memory) {
771         require(isContract(target), "Address: static call to non-contract");
772 
773         // solhint-disable-next-line avoid-low-level-calls
774         (bool success, bytes memory returndata) = target.staticcall(data);
775         return _verifyCallResult(success, returndata, errorMessage);
776     }
777 
778     /**
779      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
780      * but performing a delegate call.
781      *
782      * _Available since v3.4._
783      */
784     function functionDelegateCall(address target, bytes memory data)
785         internal
786         returns (bytes memory)
787     {
788         return
789             functionDelegateCall(
790                 target,
791                 data,
792                 "Address: low-level delegate call failed"
793             );
794     }
795 
796     /**
797      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
798      * but performing a delegate call.
799      *
800      * _Available since v3.4._
801      */
802     function functionDelegateCall(
803         address target,
804         bytes memory data,
805         string memory errorMessage
806     ) internal returns (bytes memory) {
807         require(isContract(target), "Address: delegate call to non-contract");
808 
809         // solhint-disable-next-line avoid-low-level-calls
810         (bool success, bytes memory returndata) = target.delegatecall(data);
811         return _verifyCallResult(success, returndata, errorMessage);
812     }
813 
814     function _verifyCallResult(
815         bool success,
816         bytes memory returndata,
817         string memory errorMessage
818     ) private pure returns (bytes memory) {
819         if (success) {
820             return returndata;
821         } else {
822             // Look for revert reason and bubble it up if present
823             if (returndata.length > 0) {
824                 // The easiest way to bubble the revert reason is using memory via assembly
825 
826                 // solhint-disable-next-line no-inline-assembly
827                 assembly {
828                     let returndata_size := mload(returndata)
829                     revert(add(32, returndata), returndata_size)
830                 }
831             } else {
832                 revert(errorMessage);
833             }
834         }
835     }
836 }
837 
838 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
839 
840 /**
841  * @dev Library for managing
842  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
843  * types.
844  *
845  * Sets have the following properties:
846  *
847  * - Elements are added, removed, and checked for existence in constant time
848  * (O(1)).
849  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
850  *
851  * ```
852  * contract Example {
853  *     // Add the library methods
854  *     using EnumerableSet for EnumerableSet.AddressSet;
855  *
856  *     // Declare a set state variable
857  *     EnumerableSet.AddressSet private mySet;
858  * }
859  * ```
860  *
861  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
862  * and `uint256` (`UintSet`) are supported.
863  */
864 library EnumerableSet {
865     // To implement this library for multiple types with as little code
866     // repetition as possible, we write it in terms of a generic Set type with
867     // bytes32 values.
868     // The Set implementation uses private functions, and user-facing
869     // implementations (such as AddressSet) are just wrappers around the
870     // underlying Set.
871     // This means that we can only create new EnumerableSets for types that fit
872     // in bytes32.
873 
874     struct Set {
875         // Storage of set values
876         bytes32[] _values;
877         // Position of the value in the `values` array, plus 1 because index 0
878         // means a value is not in the set.
879         mapping(bytes32 => uint256) _indexes;
880     }
881 
882     /**
883      * @dev Add a value to a set. O(1).
884      *
885      * Returns true if the value was added to the set, that is if it was not
886      * already present.
887      */
888     function _add(Set storage set, bytes32 value) private returns (bool) {
889         if (!_contains(set, value)) {
890             set._values.push(value);
891             // The value is stored at length-1, but we add 1 to all indexes
892             // and use 0 as a sentinel value
893             set._indexes[value] = set._values.length;
894             return true;
895         } else {
896             return false;
897         }
898     }
899 
900     /**
901      * @dev Removes a value from a set. O(1).
902      *
903      * Returns true if the value was removed from the set, that is if it was
904      * present.
905      */
906     function _remove(Set storage set, bytes32 value) private returns (bool) {
907         // We read and store the value's index to prevent multiple reads from the same storage slot
908         uint256 valueIndex = set._indexes[value];
909 
910         if (valueIndex != 0) {
911             // Equivalent to contains(set, value)
912             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
913             // the array, and then remove the last element (sometimes called as 'swap and pop').
914             // This modifies the order of the array, as noted in {at}.
915 
916             uint256 toDeleteIndex = valueIndex - 1;
917             uint256 lastIndex = set._values.length - 1;
918 
919             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
920             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
921 
922             bytes32 lastvalue = set._values[lastIndex];
923 
924             // Move the last value to the index where the value to delete is
925             set._values[toDeleteIndex] = lastvalue;
926             // Update the index for the moved value
927             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
928 
929             // Delete the slot where the moved value was stored
930             set._values.pop();
931 
932             // Delete the index for the deleted slot
933             delete set._indexes[value];
934 
935             return true;
936         } else {
937             return false;
938         }
939     }
940 
941     /**
942      * @dev Returns true if the value is in the set. O(1).
943      */
944     function _contains(Set storage set, bytes32 value)
945         private
946         view
947         returns (bool)
948     {
949         return set._indexes[value] != 0;
950     }
951 
952     /**
953      * @dev Returns the number of values on the set. O(1).
954      */
955     function _length(Set storage set) private view returns (uint256) {
956         return set._values.length;
957     }
958 
959     /**
960      * @dev Returns the value stored at position `index` in the set. O(1).
961      *
962      * Note that there are no guarantees on the ordering of values inside the
963      * array, and it may change when more values are added or removed.
964      *
965      * Requirements:
966      *
967      * - `index` must be strictly less than {length}.
968      */
969     function _at(Set storage set, uint256 index)
970         private
971         view
972         returns (bytes32)
973     {
974         require(
975             set._values.length > index,
976             "EnumerableSet: index out of bounds"
977         );
978         return set._values[index];
979     }
980 
981     // Bytes32Set
982 
983     struct Bytes32Set {
984         Set _inner;
985     }
986 
987     /**
988      * @dev Add a value to a set. O(1).
989      *
990      * Returns true if the value was added to the set, that is if it was not
991      * already present.
992      */
993     function add(Bytes32Set storage set, bytes32 value)
994         internal
995         returns (bool)
996     {
997         return _add(set._inner, value);
998     }
999 
1000     /**
1001      * @dev Removes a value from a set. O(1).
1002      *
1003      * Returns true if the value was removed from the set, that is if it was
1004      * present.
1005      */
1006     function remove(Bytes32Set storage set, bytes32 value)
1007         internal
1008         returns (bool)
1009     {
1010         return _remove(set._inner, value);
1011     }
1012 
1013     /**
1014      * @dev Returns true if the value is in the set. O(1).
1015      */
1016     function contains(Bytes32Set storage set, bytes32 value)
1017         internal
1018         view
1019         returns (bool)
1020     {
1021         return _contains(set._inner, value);
1022     }
1023 
1024     /**
1025      * @dev Returns the number of values in the set. O(1).
1026      */
1027     function length(Bytes32Set storage set) internal view returns (uint256) {
1028         return _length(set._inner);
1029     }
1030 
1031     /**
1032      * @dev Returns the value stored at position `index` in the set. O(1).
1033      *
1034      * Note that there are no guarantees on the ordering of values inside the
1035      * array, and it may change when more values are added or removed.
1036      *
1037      * Requirements:
1038      *
1039      * - `index` must be strictly less than {length}.
1040      */
1041     function at(Bytes32Set storage set, uint256 index)
1042         internal
1043         view
1044         returns (bytes32)
1045     {
1046         return _at(set._inner, index);
1047     }
1048 
1049     // AddressSet
1050 
1051     struct AddressSet {
1052         Set _inner;
1053     }
1054 
1055     /**
1056      * @dev Add a value to a set. O(1).
1057      *
1058      * Returns true if the value was added to the set, that is if it was not
1059      * already present.
1060      */
1061     function add(AddressSet storage set, address value)
1062         internal
1063         returns (bool)
1064     {
1065         return _add(set._inner, bytes32(uint256(uint160(value))));
1066     }
1067 
1068     /**
1069      * @dev Removes a value from a set. O(1).
1070      *
1071      * Returns true if the value was removed from the set, that is if it was
1072      * present.
1073      */
1074     function remove(AddressSet storage set, address value)
1075         internal
1076         returns (bool)
1077     {
1078         return _remove(set._inner, bytes32(uint256(uint160(value))));
1079     }
1080 
1081     /**
1082      * @dev Returns true if the value is in the set. O(1).
1083      */
1084     function contains(AddressSet storage set, address value)
1085         internal
1086         view
1087         returns (bool)
1088     {
1089         return _contains(set._inner, bytes32(uint256(uint160(value))));
1090     }
1091 
1092     /**
1093      * @dev Returns the number of values in the set. O(1).
1094      */
1095     function length(AddressSet storage set) internal view returns (uint256) {
1096         return _length(set._inner);
1097     }
1098 
1099     /**
1100      * @dev Returns the value stored at position `index` in the set. O(1).
1101      *
1102      * Note that there are no guarantees on the ordering of values inside the
1103      * array, and it may change when more values are added or removed.
1104      *
1105      * Requirements:
1106      *
1107      * - `index` must be strictly less than {length}.
1108      */
1109     function at(AddressSet storage set, uint256 index)
1110         internal
1111         view
1112         returns (address)
1113     {
1114         return address(uint160(uint256(_at(set._inner, index))));
1115     }
1116 
1117     // UintSet
1118 
1119     struct UintSet {
1120         Set _inner;
1121     }
1122 
1123     /**
1124      * @dev Add a value to a set. O(1).
1125      *
1126      * Returns true if the value was added to the set, that is if it was not
1127      * already present.
1128      */
1129     function add(UintSet storage set, uint256 value) internal returns (bool) {
1130         return _add(set._inner, bytes32(value));
1131     }
1132 
1133     /**
1134      * @dev Removes a value from a set. O(1).
1135      *
1136      * Returns true if the value was removed from the set, that is if it was
1137      * present.
1138      */
1139     function remove(UintSet storage set, uint256 value)
1140         internal
1141         returns (bool)
1142     {
1143         return _remove(set._inner, bytes32(value));
1144     }
1145 
1146     /**
1147      * @dev Returns true if the value is in the set. O(1).
1148      */
1149     function contains(UintSet storage set, uint256 value)
1150         internal
1151         view
1152         returns (bool)
1153     {
1154         return _contains(set._inner, bytes32(value));
1155     }
1156 
1157     /**
1158      * @dev Returns the number of values on the set. O(1).
1159      */
1160     function length(UintSet storage set) internal view returns (uint256) {
1161         return _length(set._inner);
1162     }
1163 
1164     /**
1165      * @dev Returns the value stored at position `index` in the set. O(1).
1166      *
1167      * Note that there are no guarantees on the ordering of values inside the
1168      * array, and it may change when more values are added or removed.
1169      *
1170      * Requirements:
1171      *
1172      * - `index` must be strictly less than {length}.
1173      */
1174     function at(UintSet storage set, uint256 index)
1175         internal
1176         view
1177         returns (uint256)
1178     {
1179         return uint256(_at(set._inner, index));
1180     }
1181 }
1182 
1183 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1184 
1185 /**
1186  * @dev Library for managing an enumerable variant of Solidity's
1187  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1188  * type.
1189  *
1190  * Maps have the following properties:
1191  *
1192  * - Entries are added, removed, and checked for existence in constant time
1193  * (O(1)).
1194  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1195  *
1196  * ```
1197  * contract Example {
1198  *     // Add the library methods
1199  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1200  *
1201  *     // Declare a set state variable
1202  *     EnumerableMap.UintToAddressMap private myMap;
1203  * }
1204  * ```
1205  *
1206  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1207  * supported.
1208  */
1209 library EnumerableMap {
1210     // To implement this library for multiple types with as little code
1211     // repetition as possible, we write it in terms of a generic Map type with
1212     // bytes32 keys and values.
1213     // The Map implementation uses private functions, and user-facing
1214     // implementations (such as Uint256ToAddressMap) are just wrappers around
1215     // the underlying Map.
1216     // This means that we can only create new EnumerableMaps for types that fit
1217     // in bytes32.
1218 
1219     struct MapEntry {
1220         bytes32 _key;
1221         bytes32 _value;
1222     }
1223 
1224     struct Map {
1225         // Storage of map keys and values
1226         MapEntry[] _entries;
1227         // Position of the entry defined by a key in the `entries` array, plus 1
1228         // because index 0 means a key is not in the map.
1229         mapping(bytes32 => uint256) _indexes;
1230     }
1231 
1232     /**
1233      * @dev Adds a key-value pair to a map, or updates the value for an existing
1234      * key. O(1).
1235      *
1236      * Returns true if the key was added to the map, that is if it was not
1237      * already present.
1238      */
1239     function _set(
1240         Map storage map,
1241         bytes32 key,
1242         bytes32 value
1243     ) private returns (bool) {
1244         // We read and store the key's index to prevent multiple reads from the same storage slot
1245         uint256 keyIndex = map._indexes[key];
1246 
1247         if (keyIndex == 0) {
1248             // Equivalent to !contains(map, key)
1249             map._entries.push(MapEntry({_key: key, _value: value}));
1250             // The entry is stored at length-1, but we add 1 to all indexes
1251             // and use 0 as a sentinel value
1252             map._indexes[key] = map._entries.length;
1253             return true;
1254         } else {
1255             map._entries[keyIndex - 1]._value = value;
1256             return false;
1257         }
1258     }
1259 
1260     /**
1261      * @dev Removes a key-value pair from a map. O(1).
1262      *
1263      * Returns true if the key was removed from the map, that is if it was present.
1264      */
1265     function _remove(Map storage map, bytes32 key) private returns (bool) {
1266         // We read and store the key's index to prevent multiple reads from the same storage slot
1267         uint256 keyIndex = map._indexes[key];
1268 
1269         if (keyIndex != 0) {
1270             // Equivalent to contains(map, key)
1271             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1272             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1273             // This modifies the order of the array, as noted in {at}.
1274 
1275             uint256 toDeleteIndex = keyIndex - 1;
1276             uint256 lastIndex = map._entries.length - 1;
1277 
1278             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1279             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1280 
1281             MapEntry storage lastEntry = map._entries[lastIndex];
1282 
1283             // Move the last entry to the index where the entry to delete is
1284             map._entries[toDeleteIndex] = lastEntry;
1285             // Update the index for the moved entry
1286             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1287 
1288             // Delete the slot where the moved entry was stored
1289             map._entries.pop();
1290 
1291             // Delete the index for the deleted slot
1292             delete map._indexes[key];
1293 
1294             return true;
1295         } else {
1296             return false;
1297         }
1298     }
1299 
1300     /**
1301      * @dev Returns true if the key is in the map. O(1).
1302      */
1303     function _contains(Map storage map, bytes32 key)
1304         private
1305         view
1306         returns (bool)
1307     {
1308         return map._indexes[key] != 0;
1309     }
1310 
1311     /**
1312      * @dev Returns the number of key-value pairs in the map. O(1).
1313      */
1314     function _length(Map storage map) private view returns (uint256) {
1315         return map._entries.length;
1316     }
1317 
1318     /**
1319      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1320      *
1321      * Note that there are no guarantees on the ordering of entries inside the
1322      * array, and it may change when more entries are added or removed.
1323      *
1324      * Requirements:
1325      *
1326      * - `index` must be strictly less than {length}.
1327      */
1328     function _at(Map storage map, uint256 index)
1329         private
1330         view
1331         returns (bytes32, bytes32)
1332     {
1333         require(
1334             map._entries.length > index,
1335             "EnumerableMap: index out of bounds"
1336         );
1337 
1338         MapEntry storage entry = map._entries[index];
1339         return (entry._key, entry._value);
1340     }
1341 
1342     /**
1343      * @dev Tries to returns the value associated with `key`.  O(1).
1344      * Does not revert if `key` is not in the map.
1345      */
1346     function _tryGet(Map storage map, bytes32 key)
1347         private
1348         view
1349         returns (bool, bytes32)
1350     {
1351         uint256 keyIndex = map._indexes[key];
1352         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1353         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1354     }
1355 
1356     /**
1357      * @dev Returns the value associated with `key`.  O(1).
1358      *
1359      * Requirements:
1360      *
1361      * - `key` must be in the map.
1362      */
1363     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1364         uint256 keyIndex = map._indexes[key];
1365         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1366         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1367     }
1368 
1369     /**
1370      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1371      *
1372      * CAUTION: This function is deprecated because it requires allocating memory for the error
1373      * message unnecessarily. For custom revert reasons use {_tryGet}.
1374      */
1375     function _get(
1376         Map storage map,
1377         bytes32 key,
1378         string memory errorMessage
1379     ) private view returns (bytes32) {
1380         uint256 keyIndex = map._indexes[key];
1381         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1382         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1383     }
1384 
1385     // UintToAddressMap
1386 
1387     struct UintToAddressMap {
1388         Map _inner;
1389     }
1390 
1391     /**
1392      * @dev Adds a key-value pair to a map, or updates the value for an existing
1393      * key. O(1).
1394      *
1395      * Returns true if the key was added to the map, that is if it was not
1396      * already present.
1397      */
1398     function set(
1399         UintToAddressMap storage map,
1400         uint256 key,
1401         address value
1402     ) internal returns (bool) {
1403         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1404     }
1405 
1406     /**
1407      * @dev Removes a value from a set. O(1).
1408      *
1409      * Returns true if the key was removed from the map, that is if it was present.
1410      */
1411     function remove(UintToAddressMap storage map, uint256 key)
1412         internal
1413         returns (bool)
1414     {
1415         return _remove(map._inner, bytes32(key));
1416     }
1417 
1418     /**
1419      * @dev Returns true if the key is in the map. O(1).
1420      */
1421     function contains(UintToAddressMap storage map, uint256 key)
1422         internal
1423         view
1424         returns (bool)
1425     {
1426         return _contains(map._inner, bytes32(key));
1427     }
1428 
1429     /**
1430      * @dev Returns the number of elements in the map. O(1).
1431      */
1432     function length(UintToAddressMap storage map)
1433         internal
1434         view
1435         returns (uint256)
1436     {
1437         return _length(map._inner);
1438     }
1439 
1440     /**
1441      * @dev Returns the element stored at position `index` in the set. O(1).
1442      * Note that there are no guarantees on the ordering of values inside the
1443      * array, and it may change when more values are added or removed.
1444      *
1445      * Requirements:
1446      *
1447      * - `index` must be strictly less than {length}.
1448      */
1449     function at(UintToAddressMap storage map, uint256 index)
1450         internal
1451         view
1452         returns (uint256, address)
1453     {
1454         (bytes32 key, bytes32 value) = _at(map._inner, index);
1455         return (uint256(key), address(uint160(uint256(value))));
1456     }
1457 
1458     /**
1459      * @dev Tries to returns the value associated with `key`.  O(1).
1460      * Does not revert if `key` is not in the map.
1461      *
1462      * _Available since v3.4._
1463      */
1464     function tryGet(UintToAddressMap storage map, uint256 key)
1465         internal
1466         view
1467         returns (bool, address)
1468     {
1469         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1470         return (success, address(uint160(uint256(value))));
1471     }
1472 
1473     /**
1474      * @dev Returns the value associated with `key`.  O(1).
1475      *
1476      * Requirements:
1477      *
1478      * - `key` must be in the map.
1479      */
1480     function get(UintToAddressMap storage map, uint256 key)
1481         internal
1482         view
1483         returns (address)
1484     {
1485         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1486     }
1487 
1488     /**
1489      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1490      *
1491      * CAUTION: This function is deprecated because it requires allocating memory for the error
1492      * message unnecessarily. For custom revert reasons use {tryGet}.
1493      */
1494     function get(
1495         UintToAddressMap storage map,
1496         uint256 key,
1497         string memory errorMessage
1498     ) internal view returns (address) {
1499         return
1500             address(
1501                 uint160(uint256(_get(map._inner, bytes32(key), errorMessage)))
1502             );
1503     }
1504 }
1505 
1506 // File: @openzeppelin/contracts/utils/Strings.sol
1507 
1508 /**
1509  * @dev String operations.
1510  */
1511 library Strings {
1512     /**
1513      * @dev Converts a `uint256` to its ASCII `string` representation.
1514      */
1515     function toString(uint256 value) internal pure returns (string memory) {
1516         // Inspired by OraclizeAPI's implementation - MIT licence
1517         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1518 
1519         if (value == 0) {
1520             return "0";
1521         }
1522         uint256 temp = value;
1523         uint256 digits;
1524         while (temp != 0) {
1525             digits++;
1526             temp /= 10;
1527         }
1528         bytes memory buffer = new bytes(digits);
1529         uint256 index = digits - 1;
1530         temp = value;
1531         while (temp != 0) {
1532             buffer[index--] = bytes1(uint8(48 + (temp % 10)));
1533             temp /= 10;
1534         }
1535         return string(buffer);
1536     }
1537 }
1538 
1539 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1540 
1541 /**
1542  * @title ERC721 Non-Fungible Token Standard basic implementation
1543  * @dev see https://eips.ethereum.org/EIPS/eip-721
1544  */
1545 contract ERC721 is
1546     Context,
1547     ERC165,
1548     IERC721,
1549     IERC721Metadata,
1550     IERC721Enumerable
1551 {
1552     using SafeMath for uint256;
1553     using Address for address;
1554     using EnumerableSet for EnumerableSet.UintSet;
1555     using EnumerableMap for EnumerableMap.UintToAddressMap;
1556     using Strings for uint256;
1557 
1558     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1559     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1560     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1561 
1562     // Mapping from holder address to their (enumerable) set of owned tokens
1563     mapping(address => EnumerableSet.UintSet) private _holderTokens;
1564 
1565     // Enumerable mapping from token ids to their owners
1566     EnumerableMap.UintToAddressMap private _tokenOwners;
1567 
1568     // Mapping from token ID to approved address
1569     mapping(uint256 => address) private _tokenApprovals;
1570 
1571     // Mapping from owner to operator approvals
1572     mapping(address => mapping(address => bool)) private _operatorApprovals;
1573 
1574     // Token name
1575     string private _name;
1576 
1577     // Token symbol
1578     string private _symbol;
1579 
1580     // Optional mapping for token URIs
1581     mapping(uint256 => string) private _tokenURIs;
1582 
1583     // Base URI
1584     string private _baseURI;
1585 
1586     /*
1587      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1588      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1589      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1590      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1591      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1592      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1593      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1594      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1595      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1596      *
1597      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1598      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1599      */
1600     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1601 
1602     /*
1603      *     bytes4(keccak256('name()')) == 0x06fdde03
1604      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1605      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1606      *
1607      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1608      */
1609     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1610 
1611     /*
1612      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1613      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1614      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1615      *
1616      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1617      */
1618     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1619 
1620     /**
1621      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1622      */
1623     constructor(string memory name_, string memory symbol_) {
1624         _name = name_;
1625         _symbol = symbol_;
1626 
1627         // register the supported interfaces to conform to ERC721 via ERC165
1628         _registerInterface(_INTERFACE_ID_ERC721);
1629         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1630         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1631     }
1632 
1633     /**
1634      * @dev See {IERC721-balanceOf}.
1635      */
1636     function balanceOf(address owner)
1637         public
1638         view
1639         virtual
1640         override
1641         returns (uint256)
1642     {
1643         require(
1644             owner != address(0),
1645             "ERC721: balance query for the zero address"
1646         );
1647         return _holderTokens[owner].length();
1648     }
1649 
1650     /**
1651      * @dev See {IERC721-ownerOf}.
1652      */
1653     function ownerOf(uint256 tokenId)
1654         public
1655         view
1656         virtual
1657         override
1658         returns (address)
1659     {
1660         return
1661             _tokenOwners.get(
1662                 tokenId,
1663                 "ERC721: owner query for nonexistent token"
1664             );
1665     }
1666 
1667     /**
1668      * @dev See {IERC721Metadata-name}.
1669      */
1670     function name() public view virtual override returns (string memory) {
1671         return _name;
1672     }
1673 
1674     /**
1675      * @dev See {IERC721Metadata-symbol}.
1676      */
1677     function symbol() public view virtual override returns (string memory) {
1678         return _symbol;
1679     }
1680 
1681     /**
1682      * @dev See {IERC721Metadata-tokenURI}.
1683      */
1684     function tokenURI(uint256 tokenId)
1685         public
1686         view
1687         virtual
1688         override
1689         returns (string memory)
1690     {
1691         require(
1692             _exists(tokenId),
1693             "ERC721Metadata: URI query for nonexistent token"
1694         );
1695 
1696         string memory _tokenURI = _tokenURIs[tokenId];
1697         string memory base = baseURI();
1698 
1699         // If there is no base URI, return the token URI.
1700         if (bytes(base).length == 0) {
1701             return _tokenURI;
1702         }
1703         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1704         if (bytes(_tokenURI).length > 0) {
1705             return string(abi.encodePacked(base, _tokenURI));
1706         }
1707         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1708         return string(abi.encodePacked(base, tokenId.toString()));
1709     }
1710 
1711     /**
1712      * @dev Returns the base URI set via {_setBaseURI}. This will be
1713      * automatically added as a prefix in {tokenURI} to each token's URI, or
1714      * to the token ID if no specific URI is set for that token ID.
1715      */
1716     function baseURI() public view virtual returns (string memory) {
1717         return _baseURI;
1718     }
1719 
1720     /**
1721      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1722      */
1723     function tokenOfOwnerByIndex(address owner, uint256 index)
1724         public
1725         view
1726         virtual
1727         override
1728         returns (uint256)
1729     {
1730         return _holderTokens[owner].at(index);
1731     }
1732 
1733     /**
1734      * @dev See {IERC721Enumerable-totalSupply}.
1735      */
1736     function totalSupply() public view virtual override returns (uint256) {
1737         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1738         return _tokenOwners.length();
1739     }
1740 
1741     /**
1742      * @dev See {IERC721Enumerable-tokenByIndex}.
1743      */
1744     function tokenByIndex(uint256 index)
1745         public
1746         view
1747         virtual
1748         override
1749         returns (uint256)
1750     {
1751         (uint256 tokenId, ) = _tokenOwners.at(index);
1752         return tokenId;
1753     }
1754 
1755     /**
1756      * @dev See {IERC721-approve}.
1757      */
1758     function approve(address to, uint256 tokenId) public virtual override {
1759         address owner = ERC721.ownerOf(tokenId);
1760         require(to != owner, "ERC721: approval to current owner");
1761 
1762         require(
1763             _msgSender() == owner ||
1764                 ERC721.isApprovedForAll(owner, _msgSender()),
1765             "ERC721: approve caller is not owner nor approved for all"
1766         );
1767 
1768         _approve(to, tokenId);
1769     }
1770 
1771     /**
1772      * @dev See {IERC721-getApproved}.
1773      */
1774     function getApproved(uint256 tokenId)
1775         public
1776         view
1777         virtual
1778         override
1779         returns (address)
1780     {
1781         require(
1782             _exists(tokenId),
1783             "ERC721: approved query for nonexistent token"
1784         );
1785 
1786         return _tokenApprovals[tokenId];
1787     }
1788 
1789     /**
1790      * @dev See {IERC721-setApprovalForAll}.
1791      */
1792     function setApprovalForAll(address operator, bool approved)
1793         public
1794         virtual
1795         override
1796     {
1797         require(operator != _msgSender(), "ERC721: approve to caller");
1798 
1799         _operatorApprovals[_msgSender()][operator] = approved;
1800         emit ApprovalForAll(_msgSender(), operator, approved);
1801     }
1802 
1803     /**
1804      * @dev See {IERC721-isApprovedForAll}.
1805      */
1806     function isApprovedForAll(address owner, address operator)
1807         public
1808         view
1809         virtual
1810         override
1811         returns (bool)
1812     {
1813         return _operatorApprovals[owner][operator];
1814     }
1815 
1816     /**
1817      * @dev See {IERC721-transferFrom}.
1818      */
1819     function transferFrom(
1820         address from,
1821         address to,
1822         uint256 tokenId
1823     ) public virtual override {
1824         //solhint-disable-next-line max-line-length
1825         require(
1826             _isApprovedOrOwner(_msgSender(), tokenId),
1827             "ERC721: transfer caller is not owner nor approved"
1828         );
1829 
1830         _transfer(from, to, tokenId);
1831     }
1832 
1833     /**
1834      * @dev See {IERC721-safeTransferFrom}.
1835      */
1836     function safeTransferFrom(
1837         address from,
1838         address to,
1839         uint256 tokenId
1840     ) public virtual override {
1841         safeTransferFrom(from, to, tokenId, "");
1842     }
1843 
1844     /**
1845      * @dev See {IERC721-safeTransferFrom}.
1846      */
1847     function safeTransferFrom(
1848         address from,
1849         address to,
1850         uint256 tokenId,
1851         bytes memory _data
1852     ) public virtual override {
1853         require(
1854             _isApprovedOrOwner(_msgSender(), tokenId),
1855             "ERC721: transfer caller is not owner nor approved"
1856         );
1857         _safeTransfer(from, to, tokenId, _data);
1858     }
1859 
1860     /**
1861      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1862      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1863      *
1864      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1865      *
1866      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1867      * implement alternative mechanisms to perform token transfer, such as signature-based.
1868      *
1869      * Requirements:
1870      *
1871      * - `from` cannot be the zero address.
1872      * - `to` cannot be the zero address.
1873      * - `tokenId` token must exist and be owned by `from`.
1874      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1875      *
1876      * Emits a {Transfer} event.
1877      */
1878     function _safeTransfer(
1879         address from,
1880         address to,
1881         uint256 tokenId,
1882         bytes memory _data
1883     ) internal virtual {
1884         _transfer(from, to, tokenId);
1885         require(
1886             _checkOnERC721Received(from, to, tokenId, _data),
1887             "ERC721: transfer to non ERC721Receiver implementer"
1888         );
1889     }
1890 
1891     /**
1892      * @dev Returns whether `tokenId` exists.
1893      *
1894      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1895      *
1896      * Tokens start existing when they are minted (`_mint`),
1897      * and stop existing when they are burned (`_burn`).
1898      */
1899     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1900         return _tokenOwners.contains(tokenId);
1901     }
1902 
1903     /**
1904      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1905      *
1906      * Requirements:
1907      *
1908      * - `tokenId` must exist.
1909      */
1910     function _isApprovedOrOwner(address spender, uint256 tokenId)
1911         internal
1912         view
1913         virtual
1914         returns (bool)
1915     {
1916         require(
1917             _exists(tokenId),
1918             "ERC721: operator query for nonexistent token"
1919         );
1920         address owner = ERC721.ownerOf(tokenId);
1921         return (spender == owner ||
1922             getApproved(tokenId) == spender ||
1923             ERC721.isApprovedForAll(owner, spender));
1924     }
1925 
1926     /**
1927      * @dev Safely mints `tokenId` and transfers it to `to`.
1928      *
1929      * Requirements:
1930      d*
1931      * - `tokenId` must not exist.
1932      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1933      *
1934      * Emits a {Transfer} event.
1935      */
1936     function _safeMint(address to, uint256 tokenId) internal virtual {
1937         _safeMint(to, tokenId, "");
1938     }
1939 
1940     /**
1941      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1942      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1943      */
1944     function _safeMint(
1945         address to,
1946         uint256 tokenId,
1947         bytes memory _data
1948     ) internal virtual {
1949         _mint(to, tokenId);
1950         require(
1951             _checkOnERC721Received(address(0), to, tokenId, _data),
1952             "ERC721: transfer to non ERC721Receiver implementer"
1953         );
1954     }
1955 
1956     /**
1957      * @dev Mints `tokenId` and transfers it to `to`.
1958      *
1959      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1960      *
1961      * Requirements:
1962      *
1963      * - `tokenId` must not exist.
1964      * - `to` cannot be the zero address.
1965      *
1966      * Emits a {Transfer} event.
1967      */
1968     function _mint(address to, uint256 tokenId) internal virtual {
1969         require(to != address(0), "ERC721: mint to the zero address");
1970         require(!_exists(tokenId), "ERC721: token already minted");
1971 
1972         _beforeTokenTransfer(address(0), to, tokenId);
1973 
1974         _holderTokens[to].add(tokenId);
1975 
1976         _tokenOwners.set(tokenId, to);
1977 
1978         emit Transfer(address(0), to, tokenId);
1979     }
1980 
1981     /**
1982      * @dev Destroys `tokenId`.
1983      * The approval is cleared when the token is burned.
1984      *
1985      * Requirements:
1986      *
1987      * - `tokenId` must exist.
1988      *
1989      * Emits a {Transfer} event.
1990      */
1991     function _burn(uint256 tokenId) internal virtual {
1992         address owner = ERC721.ownerOf(tokenId); // internal owner
1993 
1994         _beforeTokenTransfer(owner, address(0), tokenId);
1995 
1996         // Clear approvals
1997         _approve(address(0), tokenId);
1998 
1999         // Clear metadata (if any)
2000         if (bytes(_tokenURIs[tokenId]).length != 0) {
2001             delete _tokenURIs[tokenId];
2002         }
2003 
2004         _holderTokens[owner].remove(tokenId);
2005 
2006         _tokenOwners.remove(tokenId);
2007 
2008         emit Transfer(owner, address(0), tokenId);
2009     }
2010 
2011     /**
2012      * @dev Transfers `tokenId` from `from` to `to`.
2013      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2014      *
2015      * Requirements:
2016      *
2017      * - `to` cannot be the zero address.
2018      * - `tokenId` token must be owned by `from`.
2019      *
2020      * Emits a {Transfer} event.
2021      */
2022     function _transfer(
2023         address from,
2024         address to,
2025         uint256 tokenId
2026     ) internal virtual {
2027         require(
2028             ERC721.ownerOf(tokenId) == from,
2029             "ERC721: transfer of token that is not own"
2030         ); // internal owner
2031         require(to != address(0), "ERC721: transfer to the zero address");
2032 
2033         _beforeTokenTransfer(from, to, tokenId);
2034 
2035         // Clear approvals from the previous owner
2036         _approve(address(0), tokenId);
2037 
2038         _holderTokens[from].remove(tokenId);
2039         _holderTokens[to].add(tokenId);
2040 
2041         _tokenOwners.set(tokenId, to);
2042 
2043         emit Transfer(from, to, tokenId);
2044     }
2045 
2046     /**
2047      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
2048      *
2049      * Requirements:
2050      *
2051      * - `tokenId` must exist.
2052      */
2053     function _setTokenURI(uint256 tokenId, string memory _tokenURI)
2054         internal
2055         virtual
2056     {
2057         require(
2058             _exists(tokenId),
2059             "ERC721Metadata: URI set of nonexistent token"
2060         );
2061         _tokenURIs[tokenId] = _tokenURI;
2062     }
2063 
2064     /**
2065      * @dev Internal function to set the base URI for all token IDs. It is
2066      * automatically added as a prefix to the value returned in {tokenURI},
2067      * or to the token ID if {tokenURI} is empty.
2068      */
2069     function _setBaseURI(string memory baseURI_) internal virtual {
2070         _baseURI = baseURI_;
2071     }
2072 
2073     /**
2074      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2075      * The call is not executed if the target address is not a contract.
2076      *
2077      * @param from address representing the previous owner of the given token ID
2078      * @param to target address that will receive the tokens
2079      * @param tokenId uint256 ID of the token to be transferred
2080      * @param _data bytes optional data to send along with the call
2081      * @return bool whether the call correctly returned the expected magic value
2082      */
2083     function _checkOnERC721Received(
2084         address from,
2085         address to,
2086         uint256 tokenId,
2087         bytes memory _data
2088     ) private returns (bool) {
2089         if (!to.isContract()) {
2090             return true;
2091         }
2092         bytes memory returndata = to.functionCall(
2093             abi.encodeWithSelector(
2094                 IERC721Receiver(to).onERC721Received.selector,
2095                 _msgSender(),
2096                 from,
2097                 tokenId,
2098                 _data
2099             ),
2100             "ERC721: transfer to non ERC721Receiver implementer"
2101         );
2102         bytes4 retval = abi.decode(returndata, (bytes4));
2103         return (retval == _ERC721_RECEIVED);
2104     }
2105 
2106     /**
2107      * @dev Approve `to` to operate on `tokenId`
2108      *
2109      * Emits an {Approval} event.
2110      */
2111     function _approve(address to, uint256 tokenId) internal virtual {
2112         _tokenApprovals[tokenId] = to;
2113         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
2114     }
2115 
2116     /**
2117      * @dev Hook that is called before any token transfer. This includes minting
2118      * and burning.
2119      *
2120      * Calling conditions:
2121      *
2122      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2123      * transferred to `to`.
2124      * - When `from` is zero, `tokenId` will be minted for `to`.
2125      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2126      * - `from` cannot be the zero address.
2127      * - `to` cannot be the zero address.
2128      *
2129      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2130      */
2131     function _beforeTokenTransfer(
2132         address from,
2133         address to,
2134         uint256 tokenId
2135     ) internal virtual {}
2136 }
2137 
2138 // File: @openzeppelin/contracts/access/Ownable.sol
2139 
2140 /**
2141  * @dev Contract module which provides a basic access control mechanism, where
2142  * there is an account (an owner) that can be granted exclusive access to
2143  * specific functions.
2144  *
2145  * By default, the owner account will be the one that deploys the contract. This
2146  * can later be changed with {transferOwnership}.
2147  *
2148  * This module is used through inheritance. It will make available the modifier
2149  * `onlyOwner`, which can be applied to your functions to restrict their use to
2150  * the owner.
2151  */
2152 abstract contract Ownable is Context {
2153     address private _owner;
2154 
2155     event OwnershipTransferred(
2156         address indexed previousOwner,
2157         address indexed newOwner
2158     );
2159 
2160     /**
2161      * @dev Initializes the contract setting the deployer as the initial owner.
2162      */
2163     constructor() {
2164         address msgSender = _msgSender();
2165         _owner = msgSender;
2166         emit OwnershipTransferred(address(0), msgSender);
2167     }
2168 
2169     /**
2170      * @dev Returns the address of the current owner.
2171      */
2172     function owner() public view virtual returns (address) {
2173         return _owner;
2174     }
2175 
2176     /**
2177      * @dev Throws if called by any account other than the owner.
2178      */
2179     modifier onlyOwner() {
2180         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2181         _;
2182     }
2183 
2184     /**
2185      * @dev Leaves the contract without owner. It will not be possible to call
2186      * `onlyOwner` functions anymore. Can only be called by the current owner.
2187      *
2188      * NOTE: Renouncing ownership will leave the contract without an owner,
2189      * thereby removing any functionality that is only available to the owner.
2190      */
2191     function renounceOwnership() public virtual onlyOwner {
2192         emit OwnershipTransferred(_owner, address(0));
2193         _owner = address(0);
2194     }
2195 
2196     /**
2197      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2198      * Can only be called by the current owner.
2199      */
2200     function transferOwnership(address newOwner) public virtual onlyOwner {
2201         require(
2202             newOwner != address(0),
2203             "Ownable: new owner is the zero address"
2204         );
2205         emit OwnershipTransferred(_owner, newOwner);
2206         _owner = newOwner;
2207     }
2208 }
2209 
2210 // File: ERC721Minter.sol
2211 
2212 /**
2213  * @title ERC721Minter
2214  * @dev This Contract is used to interact with ERC721 Contract
2215  */
2216 contract ERC721Minter is ERC721, Ownable {
2217     address private _mediaContract;
2218 
2219     address private _adminAddress;
2220     address private _communityAddress;
2221 
2222     uint16 private _adminCommission;
2223     uint16 private _communityCommission;
2224 
2225     mapping(address => uint256[]) private _tokenHolderToIDs;
2226 
2227     modifier onlyMediaCaller() {
2228         require(
2229             msg.sender == _mediaContract,
2230             "ERC721Minter: Unauthorised Access!"
2231         );
2232         _;
2233     }
2234 
2235     constructor() ERC721("Bones Club", "BC") Ownable() {
2236         _setBaseURI(
2237             "https://gateway.pinata.cloud/ipfs/QmRffRDrw6WR5STUFbG3GRffs1CwvzHzSmyboRbrfcbhQ2/"
2238         );
2239     }
2240 
2241     function doesTokenExist(uint256 _tokenID) external view returns (bool) {
2242         return _exists(_tokenID);
2243     }
2244 
2245     function setAdminAddress(address adminAddress_) external onlyOwner {
2246         require(
2247             adminAddress_ != address(0),
2248             "ERC721Minter: Invalid Admin Address!"
2249         );
2250         _adminAddress = adminAddress_;
2251     }
2252 
2253     function setCommunityAddress(address communityAddress_) external onlyOwner {
2254         require(
2255             communityAddress_ != address(0),
2256             "ERC721Minter: Invalid Community Address!"
2257         );
2258         _communityAddress = communityAddress_;
2259     }
2260 
2261     function setAdminCommission(uint16 adminCommission_) external {
2262         require(
2263             msg.sender == _adminAddress,
2264             "ERC721Minter: Unauthorised Access!"
2265         );
2266         _adminCommission = adminCommission_;
2267     }
2268 
2269     function setCommunityCommission(uint16 communityCommission_) external {
2270         require(
2271             msg.sender == _communityAddress,
2272             "ERC721Minter: Unauthorised Access!"
2273         );
2274         _communityCommission = communityCommission_;
2275     }
2276 
2277     function getTokensByOwner(address _owner)
2278         external
2279         view
2280         returns (uint256[] memory)
2281     {
2282         return _tokenHolderToIDs[_owner];
2283     }
2284 
2285     /**
2286      * @notice This method is used to configure Media Contract address
2287      * @dev Should only be called by contract owner
2288      * @param mediaContract_ Address of the Media Contract
2289      */
2290     function configureMedia(address mediaContract_) external onlyOwner {
2291         require(
2292             _mediaContract == address(0),
2293             "ERC721Minter: Media Already Configured!"
2294         );
2295         require(
2296             mediaContract_ != address(0),
2297             "ERC721Minter: Invalid Media Contract Address!"
2298         );
2299         _mediaContract = mediaContract_;
2300     }
2301 
2302     /**
2303      * @notice This method is used to mint a token
2304      * @param _tokenID ID of the token to mint
2305      * @param _owner Address of the token owner
2306      */
2307     function mintToken(uint256 _tokenID, address _owner)
2308         external
2309         onlyMediaCaller
2310     {
2311         _safeMint(_owner, _tokenID);
2312         _tokenHolderToIDs[_owner].push(_tokenID);
2313     }
2314 }
2315 
2316 // File: Interfaces/IMedia.sol
2317 
2318 /**
2319  * @title Interface to Create Media Contract
2320  * @dev Inherit this interface to create a Media Contract
2321  */
2322 interface IMedia {
2323     // Event to be emitted when Contract Ownership is transferred
2324     event OwnershipTransfer(address _from, address _to);
2325 
2326     /**
2327      * @notice This method is used to transfer ownership from msg.sender to _newOwner
2328      * @dev Should only be called by Contract Owner
2329      *      Must emit OwnershipTransfer event
2330      * @param _newOwner Address of the new owner
2331      */
2332     function transferOwnership(address _newOwner) external;
2333 
2334     /**
2335      * @notice This method is used to get price of Tokens
2336      * @return Price of the token in we
2337      */
2338     function getTokenPrice() external view returns (uint256);
2339 
2340     /**
2341      * @notice This method is used to set price of Tokens
2342      * @dev This method accepts price in Wei
2343      *      Should only be called by either of the admins
2344      * @param tokenPrice_ Price of tokens in Wei
2345      */
2346     function setTokenPrice(uint256 tokenPrice_) external;
2347 
2348     /**
2349      * @notice This method is used to mint new tokens,
2350      * the range will be from 1 - 30
2351      * @dev Should accept payment set by the admin
2352      */
2353     function mintToken(uint256 _tokensToMint) external payable;
2354 
2355     /**
2356      * @notice This method is used by admin to mint it's reserved 30 token's,
2357      * the range will be from 31 - 9498
2358      * @dev Should only called by admin
2359      */
2360     function mintAdminTokens() external;
2361 
2362     /**
2363      * @notice This method is used by admin to mint it's reserved token's
2364      * for whitelisted user's, range will be from 9499 - 10000
2365      * @dev Should only called by admin
2366      */
2367     function mintWhiteListTokens(address _to) external;
2368 
2369     /**
2370      * @notice This will returns the admin address
2371      */
2372     function getAdminAddress() external view returns (address);
2373 }
2374 
2375 // File: Media.sol
2376 
2377 /**
2378  * @title Media Contract
2379  * @dev This is the Main contract through which the system interacts with Market and ERC721Minter contracts
2380  */
2381 contract Media is IMedia {
2382     using SafeMath for uint256;
2383 
2384     address private _owner;
2385     address private _ERC721Address;
2386     address private _adminAddress;
2387 
2388     uint256 private _tokenPrice;
2389 
2390     uint256 constant MAX_TOKENS = 10000;
2391     uint256 private nonce;
2392     uint256[MAX_TOKENS] private indices;
2393 
2394     uint256 private numberOfUserTokensMinted;
2395     bool private _isAdminTokenMinted;
2396     uint256 private numberOfWhitelistTokenStart = 9499;
2397 
2398     constructor(address _ERC721) {
2399         require(_ERC721 != address(0), "Media: Invalid ERC721Minter Address!");
2400 
2401         _ERC721Address = _ERC721;
2402         _owner = msg.sender;
2403         _adminAddress = msg.sender;
2404     }
2405 
2406     modifier onlyOwner() {
2407         require(msg.sender == _owner, "Media: Unauthorised Access!");
2408         _;
2409     }
2410 
2411     modifier isTokenAvailable() {
2412         require(
2413             MAX_TOKENS != ERC721Minter(_ERC721Address).totalSupply(),
2414             "Media: No Tokens To Buy!"
2415         );
2416         _;
2417     }
2418 
2419     fallback() external {}
2420 
2421     receive() external payable {}
2422 
2423     function getTokensByOwner(address owner_)
2424         external
2425         view
2426         returns (uint256[] memory)
2427     {
2428         return ERC721Minter(_ERC721Address).getTokensByOwner(owner_);
2429     }
2430 
2431     function getTokenDetails() public view returns (uint256, uint256) {
2432         return (
2433             MAX_TOKENS - ERC721Minter(_ERC721Address).totalSupply(),
2434             MAX_TOKENS
2435         );
2436     }
2437 
2438     function randomIndex(uint256 _startLimit, uint256 _endLimit)
2439         private
2440         returns (uint256)
2441     {
2442         uint256 totalSize;
2443         totalSize = _endLimit.sub(numberOfUserTokensMinted);
2444         totalSize = totalSize.sub(_startLimit);
2445 
2446         uint256 index = uint256(
2447             keccak256(
2448                 abi.encodePacked(
2449                     nonce,
2450                     msg.sender,
2451                     block.difficulty,
2452                     block.timestamp
2453                 )
2454             )
2455         ).mod(totalSize);
2456         uint256 value = 0;
2457         if (indices[index] != 0) {
2458             value = indices[index];
2459         } else {
2460             value = index;
2461         }
2462 
2463         if (indices[totalSize - 1] == 0) {
2464             indices[index] = totalSize - 1;
2465         } else {
2466             indices[index] = indices[totalSize - 1];
2467         }
2468         nonce++;
2469         return value.add(1).add(_startLimit);
2470     }
2471 
2472     /**
2473      * @dev See { IMedia }
2474      */
2475     function transferOwnership(address _newOwner) external override onlyOwner {
2476         require(_newOwner != address(0), "Media: Invalid New Owner Address!");
2477         emit OwnershipTransfer(_owner, _newOwner);
2478         _owner = _newOwner;
2479         _adminAddress = _newOwner;
2480     }
2481 
2482     /**
2483      * @dev See { IMedia }
2484      */
2485     function getTokenPrice() external view override returns (uint256) {
2486         return _tokenPrice;
2487     }
2488 
2489     /**
2490      * @dev See { IMedia }
2491      */
2492     function setTokenPrice(uint256 tokenPrice_) external override onlyOwner {
2493         require(tokenPrice_ > 0, "Media: Price Cannot Be Zero!");
2494         _tokenPrice = tokenPrice_;
2495     }
2496 
2497     /**
2498      * @notice Mints one or more random tokens
2499      * @dev See { IMedia }
2500      */
2501     function mintToken(uint256 _tokensToMint)
2502         external
2503         payable
2504         override
2505         isTokenAvailable
2506     {
2507         require(_tokensToMint > 0, "Media: Cannot mint zero token!");
2508         require(_tokensToMint <= 10, "Media: Cannot mint more than 10 tokens!");
2509         require(
2510             numberOfUserTokensMinted < (9498 - 30),
2511             "Media: No tokens to mint!"
2512         );
2513         require(
2514             msg.value == (_tokensToMint * _tokenPrice),
2515             "Media: Wrong Amount Transferred!"
2516         );
2517         uint256 _tokenID;
2518 
2519         uint8 index = 0;
2520         while (index < _tokensToMint) {
2521             _tokenID = randomIndex(30, 9498);
2522             if (!ERC721Minter(_ERC721Address).doesTokenExist(_tokenID)) {
2523                 ERC721Minter(_ERC721Address).mintToken(_tokenID, msg.sender);
2524                 numberOfUserTokensMinted++;
2525                 index++;
2526             }
2527         }
2528         payable(_adminAddress).transfer(msg.value);
2529     }
2530 
2531     /**
2532      * @notice Mints 30 tokens to Admin address
2533      * @dev See { IMedia }
2534      */
2535     function mintAdminTokens() external override onlyOwner isTokenAvailable {
2536         require(!_isAdminTokenMinted, "Media: No tokens to mint!");
2537         for (uint8 index = 1; index <= 30; index++) {
2538             ERC721Minter(_ERC721Address).mintToken(index, msg.sender);
2539         }
2540         _isAdminTokenMinted = true;
2541     }
2542 
2543     /**
2544      * @notice Admin mints and transfer token to the whitelisted address
2545      * @dev See { IMedia }
2546      */
2547 
2548     function mintWhiteListTokens(address _to)
2549         external
2550         override
2551         onlyOwner
2552         isTokenAvailable
2553     {
2554         require(
2555             10000 >= numberOfWhitelistTokenStart,
2556             "Media: No tokens to mint!"
2557         );
2558 
2559         ERC721Minter(_ERC721Address).mintToken(
2560             numberOfWhitelistTokenStart,
2561             _to
2562         );
2563         numberOfWhitelistTokenStart++;
2564     }
2565 
2566     /**@notice Returns the address of the admin
2567      * @dev See { IMedia }
2568      */
2569     function getAdminAddress() external view override returns (address) {
2570         return _adminAddress;
2571     }
2572 }