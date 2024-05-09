1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 // File: @openzeppelin/contracts/utils/Context.sol
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         this;
24         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts/introspection/IERC165.sol
30 
31 /**
32  * @dev Interface of the ERC165 standard, as defined in the
33  * https://eips.ethereum.org/EIPS/eip-165[EIP].
34  *
35  * Implementers can declare support of contract interfaces, which can then be
36  * queried by others ({ERC165Checker}).
37  *
38  * For an implementation, see {ERC165}.
39  */
40 interface IERC165 {
41     /**
42      * @dev Returns true if this contract implements the interface defined by
43      * `interfaceId`. See the corresponding
44      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
45      * to learn more about how these ids are created.
46      *
47      * This function call must use less than 30 000 gas.
48      */
49     function supportsInterface(bytes4 interfaceId) external view returns (bool);
50 }
51 
52 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
53 
54 /**
55  * @dev Required interface of an ERC721 compliant contract.
56  */
57 interface IERC721 is IERC165 {
58     /**
59      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
60      */
61     event Transfer(
62         address indexed from,
63         address indexed to,
64         uint256 indexed tokenId
65     );
66 
67     /**
68      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
69      */
70     event Approval(
71         address indexed owner,
72         address indexed approved,
73         uint256 indexed tokenId
74     );
75 
76     /**
77      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
78      */
79     event ApprovalForAll(
80         address indexed owner,
81         address indexed operator,
82         bool approved
83     );
84 
85     /**
86      * @dev Returns the number of tokens in ``owner``'s account.
87      */
88     function balanceOf(address owner) external view returns (uint256 balance);
89 
90     /**
91      * @dev Returns the owner of the `tokenId` token.
92      *
93      * Requirements:
94      *
95      * - `tokenId` must exist.
96      */
97     function ownerOf(uint256 tokenId) external view returns (address owner);
98 
99     /**
100      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
101      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
102      *
103      * Requirements:
104      *
105      * - `from` cannot be the zero address.
106      * - `to` cannot be the zero address.
107      * - `tokenId` token must exist and be owned by `from`.
108      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
109      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
110      *
111      * Emits a {Transfer} event.
112      */
113     function safeTransferFrom(
114         address from,
115         address to,
116         uint256 tokenId
117     ) external;
118 
119     /**
120      * @dev Transfers `tokenId` token from `from` to `to`.
121      *
122      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
123      *
124      * Requirements:
125      *
126      * - `from` cannot be the zero address.
127      * - `to` cannot be the zero address.
128      * - `tokenId` token must be owned by `from`.
129      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
130      *
131      * Emits a {Transfer} event.
132      */
133     function transferFrom(
134         address from,
135         address to,
136         uint256 tokenId
137     ) external;
138 
139     /**
140      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
141      * The approval is cleared when the token is transferred.
142      *
143      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
144      *
145      * Requirements:
146      *
147      * - The caller must own the token or be an approved operator.
148      * - `tokenId` must exist.
149      *
150      * Emits an {Approval} event.
151      */
152     function approve(address to, uint256 tokenId) external;
153 
154     /**
155      * @dev Returns the account approved for `tokenId` token.
156      *
157      * Requirements:
158      *
159      * - `tokenId` must exist.
160      */
161     function getApproved(uint256 tokenId)
162         external
163         view
164         returns (address operator);
165 
166     /**
167      * @dev Approve or remove `operator` as an operator for the caller.
168      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
169      *
170      * Requirements:
171      *
172      * - The `operator` cannot be the caller.
173      *
174      * Emits an {ApprovalForAll} event.
175      */
176     function setApprovalForAll(address operator, bool _approved) external;
177 
178     /**
179      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
180      *
181      * See {setApprovalForAll}
182      */
183     function isApprovedForAll(address owner, address operator)
184         external
185         view
186         returns (bool);
187 
188     /**
189      * @dev Safely transfers `tokenId` token from `from` to `to`.
190      *
191      * Requirements:
192      *
193      * - `from` cannot be the zero address.
194      * - `to` cannot be the zero address.
195      * - `tokenId` token must exist and be owned by `from`.
196      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
197      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
198      *
199      * Emits a {Transfer} event.
200      */
201     function safeTransferFrom(
202         address from,
203         address to,
204         uint256 tokenId,
205         bytes calldata data
206     ) external;
207 }
208 
209 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
210 
211 /**
212  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
213  * @dev See https://eips.ethereum.org/EIPS/eip-721
214  */
215 interface IERC721Metadata is IERC721 {
216     /**
217      * @dev Returns the token collection name.
218      */
219     function name() external view returns (string memory);
220 
221     /**
222      * @dev Returns the token collection symbol.
223      */
224     function symbol() external view returns (string memory);
225 
226     /**
227      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
228      */
229     function tokenURI(uint256 tokenId) external view returns (string memory);
230 }
231 
232 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
233 
234 /**
235  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
236  * @dev See https://eips.ethereum.org/EIPS/eip-721
237  */
238 interface IERC721Enumerable is IERC721 {
239     /**
240      * @dev Returns the total amount of tokens stored by the contract.
241      */
242     function totalSupply() external view returns (uint256);
243 
244     /**
245      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
246      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
247      */
248     function tokenOfOwnerByIndex(address owner, uint256 index)
249         external
250         view
251         returns (uint256 tokenId);
252 
253     /**
254      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
255      * Use along with {totalSupply} to enumerate all tokens.
256      */
257     function tokenByIndex(uint256 index) external view returns (uint256);
258 }
259 
260 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
261 
262 /**
263  * @title ERC721 token receiver interface
264  * @dev Interface for any contract that wants to support safeTransfers
265  * from ERC721 asset contracts.
266  */
267 interface IERC721Receiver {
268     /**
269      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
270      * by `operator` from `from`, this function is called.
271      *
272      * It must return its Solidity selector to confirm the token transfer.
273      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
274      *
275      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
276      */
277     function onERC721Received(
278         address operator,
279         address from,
280         uint256 tokenId,
281         bytes calldata data
282     ) external returns (bytes4);
283 }
284 
285 // File: @openzeppelin/contracts/introspection/ERC165.sol
286 
287 /**
288  * @dev Implementation of the {IERC165} interface.
289  *
290  * Contracts may inherit from this and call {_registerInterface} to declare
291  * their support of an interface.
292  */
293 abstract contract ERC165 is IERC165 {
294     /*
295      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
296      */
297     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
298 
299     /**
300      * @dev Mapping of interface ids to whether or not it's supported.
301      */
302     mapping(bytes4 => bool) private _supportedInterfaces;
303 
304     constructor() {
305         // Derived contracts need only register support for their own interfaces,
306         // we register support for ERC165 itself here
307         _registerInterface(_INTERFACE_ID_ERC165);
308     }
309 
310     /**
311      * @dev See {IERC165-supportsInterface}.
312      *
313      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
314      */
315     function supportsInterface(bytes4 interfaceId)
316         public
317         view
318         virtual
319         override
320         returns (bool)
321     {
322         return _supportedInterfaces[interfaceId];
323     }
324 
325     /**
326      * @dev Registers the contract as an implementer of the interface defined by
327      * `interfaceId`. Support of the actual ERC165 interface is automatic and
328      * registering its interface id is not required.
329      *
330      * See {IERC165-supportsInterface}.
331      *
332      * Requirements:
333      *
334      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
335      */
336     function _registerInterface(bytes4 interfaceId) internal virtual {
337         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
338         _supportedInterfaces[interfaceId] = true;
339     }
340 }
341 
342 // File: @openzeppelin/contracts/math/SafeMath.sol
343 
344 /**
345  * @dev Wrappers over Solidity's arithmetic operations with added overflow
346  * checks.
347  *
348  * Arithmetic operations in Solidity wrap on overflow. This can easily result
349  * in bugs, because programmers usually assume that an overflow raises an
350  * error, which is the standard behavior in high level programming languages.
351  * `SafeMath` restores this intuition by reverting the transaction when an
352  * operation overflows.
353  *
354  * Using this library instead of the unchecked operations eliminates an entire
355  * class of bugs, so it's recommended to use it always.
356  */
357 library SafeMath {
358     /**
359      * @dev Returns the addition of two unsigned integers, with an overflow flag.
360      *
361      * _Available since v3.4._
362      */
363     function tryAdd(uint256 a, uint256 b)
364         internal
365         pure
366         returns (bool, uint256)
367     {
368         uint256 c = a + b;
369         if (c < a) return (false, 0);
370         return (true, c);
371     }
372 
373     /**
374      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
375      *
376      * _Available since v3.4._
377      */
378     function trySub(uint256 a, uint256 b)
379         internal
380         pure
381         returns (bool, uint256)
382     {
383         if (b > a) return (false, 0);
384         return (true, a - b);
385     }
386 
387     /**
388      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
389      *
390      * _Available since v3.4._
391      */
392     function tryMul(uint256 a, uint256 b)
393         internal
394         pure
395         returns (bool, uint256)
396     {
397         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
398         // benefit is lost if 'b' is also tested.
399         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
400         if (a == 0) return (true, 0);
401         uint256 c = a * b;
402         if (c / a != b) return (false, 0);
403         return (true, c);
404     }
405 
406     /**
407      * @dev Returns the division of two unsigned integers, with a division by zero flag.
408      *
409      * _Available since v3.4._
410      */
411     function tryDiv(uint256 a, uint256 b)
412         internal
413         pure
414         returns (bool, uint256)
415     {
416         if (b == 0) return (false, 0);
417         return (true, a / b);
418     }
419 
420     /**
421      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
422      *
423      * _Available since v3.4._
424      */
425     function tryMod(uint256 a, uint256 b)
426         internal
427         pure
428         returns (bool, uint256)
429     {
430         if (b == 0) return (false, 0);
431         return (true, a % b);
432     }
433 
434     /**
435      * @dev Returns the addition of two unsigned integers, reverting on
436      * overflow.
437      *
438      * Counterpart to Solidity's `+` operator.
439      *
440      * Requirements:
441      *
442      * - Addition cannot overflow.
443      */
444     function add(uint256 a, uint256 b) internal pure returns (uint256) {
445         uint256 c = a + b;
446         require(c >= a, "SafeMath: addition overflow");
447         return c;
448     }
449 
450     /**
451      * @dev Returns the subtraction of two unsigned integers, reverting on
452      * overflow (when the result is negative).
453      *
454      * Counterpart to Solidity's `-` operator.
455      *
456      * Requirements:
457      *
458      * - Subtraction cannot overflow.
459      */
460     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
461         require(b <= a, "SafeMath: subtraction overflow");
462         return a - b;
463     }
464 
465     /**
466      * @dev Returns the multiplication of two unsigned integers, reverting on
467      * overflow.
468      *
469      * Counterpart to Solidity's `*` operator.
470      *
471      * Requirements:
472      *
473      * - Multiplication cannot overflow.
474      */
475     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
476         if (a == 0) return 0;
477         uint256 c = a * b;
478         require(c / a == b, "SafeMath: multiplication overflow");
479         return c;
480     }
481 
482     /**
483      * @dev Returns the integer division of two unsigned integers, reverting on
484      * division by zero. The result is rounded towards zero.
485      *
486      * Counterpart to Solidity's `/` operator. Note: this function uses a
487      * `revert` opcode (which leaves remaining gas untouched) while Solidity
488      * uses an invalid opcode to revert (consuming all remaining gas).
489      *
490      * Requirements:
491      *
492      * - The divisor cannot be zero.
493      */
494     function div(uint256 a, uint256 b) internal pure returns (uint256) {
495         require(b > 0, "SafeMath: division by zero");
496         return a / b;
497     }
498 
499     /**
500      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
501      * reverting when dividing by zero.
502      *
503      * Counterpart to Solidity's `%` operator. This function uses a `revert`
504      * opcode (which leaves remaining gas untouched) while Solidity uses an
505      * invalid opcode to revert (consuming all remaining gas).
506      *
507      * Requirements:
508      *
509      * - The divisor cannot be zero.
510      */
511     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
512         require(b > 0, "SafeMath: modulo by zero");
513         return a % b;
514     }
515 
516     /**
517      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
518      * overflow (when the result is negative).
519      *
520      * CAUTION: This function is deprecated because it requires allocating memory for the error
521      * message unnecessarily. For custom revert reasons use {trySub}.
522      *
523      * Counterpart to Solidity's `-` operator.
524      *
525      * Requirements:
526      *
527      * - Subtraction cannot overflow.
528      */
529     function sub(
530         uint256 a,
531         uint256 b,
532         string memory errorMessage
533     ) internal pure returns (uint256) {
534         require(b <= a, errorMessage);
535         return a - b;
536     }
537 
538     /**
539      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
540      * division by zero. The result is rounded towards zero.
541      *
542      * CAUTION: This function is deprecated because it requires allocating memory for the error
543      * message unnecessarily. For custom revert reasons use {tryDiv}.
544      *
545      * Counterpart to Solidity's `/` operator. Note: this function uses a
546      * `revert` opcode (which leaves remaining gas untouched) while Solidity
547      * uses an invalid opcode to revert (consuming all remaining gas).
548      *
549      * Requirements:
550      *
551      * - The divisor cannot be zero.
552      */
553     function div(
554         uint256 a,
555         uint256 b,
556         string memory errorMessage
557     ) internal pure returns (uint256) {
558         require(b > 0, errorMessage);
559         return a / b;
560     }
561 
562     /**
563      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
564      * reverting with custom message when dividing by zero.
565      *
566      * CAUTION: This function is deprecated because it requires allocating memory for the error
567      * message unnecessarily. For custom revert reasons use {tryMod}.
568      *
569      * Counterpart to Solidity's `%` operator. This function uses a `revert`
570      * opcode (which leaves remaining gas untouched) while Solidity uses an
571      * invalid opcode to revert (consuming all remaining gas).
572      *
573      * Requirements:
574      *
575      * - The divisor cannot be zero.
576      */
577     function mod(
578         uint256 a,
579         uint256 b,
580         string memory errorMessage
581     ) internal pure returns (uint256) {
582         require(b > 0, errorMessage);
583         return a % b;
584     }
585 }
586 
587 // File: @openzeppelin/contracts/utils/Address.sol
588 
589 /**
590  * @dev Collection of functions related to the address type
591  */
592 library Address {
593     /**
594      * @dev Returns true if `account` is a contract.
595      *
596      * [IMPORTANT]
597      * ====
598      * It is unsafe to assume that an address for which this function returns
599      * false is an externally-owned account (EOA) and not a contract.
600      *
601      * Among others, `isContract` will return false for the following
602      * types of addresses:
603      *
604      *  - an externally-owned account
605      *  - a contract in construction
606      *  - an address where a contract will be created
607      *  - an address where a contract lived, but was destroyed
608      * ====
609      */
610     function isContract(address account) internal view returns (bool) {
611         // This method relies on extcodesize, which returns 0 for contracts in
612         // construction, since the code is only stored at the end of the
613         // constructor execution.
614 
615         uint256 size;
616         // solhint-disable-next-line no-inline-assembly
617         assembly {
618             size := extcodesize(account)
619         }
620         return size > 0;
621     }
622 
623     /**
624      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
625      * `recipient`, forwarding all available gas and reverting on errors.
626      *
627      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
628      * of certain opcodes, possibly making contracts go over the 2300 gas limit
629      * imposed by `transfer`, making them unable to receive funds via
630      * `transfer`. {sendValue} removes this limitation.
631      *
632      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
633      *
634      * IMPORTANT: because control is transferred to `recipient`, care must be
635      * taken to not create reentrancy vulnerabilities. Consider using
636      * {ReentrancyGuard} or the
637      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
638      */
639     function sendValue(address payable recipient, uint256 amount) internal {
640         require(
641             address(this).balance >= amount,
642             "Address: insufficient balance"
643         );
644 
645         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
646         (bool success, ) = recipient.call{value: amount}("");
647         require(
648             success,
649             "Address: unable to send value, recipient may have reverted"
650         );
651     }
652 
653     /**
654      * @dev Performs a Solidity function call using a low level `call`. A
655      * plain`call` is an unsafe replacement for a function call: use this
656      * function instead.
657      *
658      * If `target` reverts with a revert reason, it is bubbled up by this
659      * function (like regular Solidity function calls).
660      *
661      * Returns the raw returned data. To convert to the expected return value,
662      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
663      *
664      * Requirements:
665      *
666      * - `target` must be a contract.
667      * - calling `target` with `data` must not revert.
668      *
669      * _Available since v3.1._
670      */
671     function functionCall(address target, bytes memory data)
672         internal
673         returns (bytes memory)
674     {
675         return functionCall(target, data, "Address: low-level call failed");
676     }
677 
678     /**
679      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
680      * `errorMessage` as a fallback revert reason when `target` reverts.
681      *
682      * _Available since v3.1._
683      */
684     function functionCall(
685         address target,
686         bytes memory data,
687         string memory errorMessage
688     ) internal returns (bytes memory) {
689         return functionCallWithValue(target, data, 0, errorMessage);
690     }
691 
692     /**
693      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
694      * but also transferring `value` wei to `target`.
695      *
696      * Requirements:
697      *
698      * - the calling contract must have an ETH balance of at least `value`.
699      * - the called Solidity function must be `payable`.
700      *
701      * _Available since v3.1._
702      */
703     function functionCallWithValue(
704         address target,
705         bytes memory data,
706         uint256 value
707     ) internal returns (bytes memory) {
708         return
709             functionCallWithValue(
710                 target,
711                 data,
712                 value,
713                 "Address: low-level call with value failed"
714             );
715     }
716 
717     /**
718      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
719      * with `errorMessage` as a fallback revert reason when `target` reverts.
720      *
721      * _Available since v3.1._
722      */
723     function functionCallWithValue(
724         address target,
725         bytes memory data,
726         uint256 value,
727         string memory errorMessage
728     ) internal returns (bytes memory) {
729         require(
730             address(this).balance >= value,
731             "Address: insufficient balance for call"
732         );
733         require(isContract(target), "Address: call to non-contract");
734 
735         // solhint-disable-next-line avoid-low-level-calls
736         (bool success, bytes memory returndata) = target.call{value: value}(
737             data
738         );
739         return _verifyCallResult(success, returndata, errorMessage);
740     }
741 
742     /**
743      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
744      * but performing a static call.
745      *
746      * _Available since v3.3._
747      */
748     function functionStaticCall(address target, bytes memory data)
749         internal
750         view
751         returns (bytes memory)
752     {
753         return
754             functionStaticCall(
755                 target,
756                 data,
757                 "Address: low-level static call failed"
758             );
759     }
760 
761     /**
762      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
763      * but performing a static call.
764      *
765      * _Available since v3.3._
766      */
767     function functionStaticCall(
768         address target,
769         bytes memory data,
770         string memory errorMessage
771     ) internal view returns (bytes memory) {
772         require(isContract(target), "Address: static call to non-contract");
773 
774         // solhint-disable-next-line avoid-low-level-calls
775         (bool success, bytes memory returndata) = target.staticcall(data);
776         return _verifyCallResult(success, returndata, errorMessage);
777     }
778 
779     /**
780      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
781      * but performing a delegate call.
782      *
783      * _Available since v3.4._
784      */
785     function functionDelegateCall(address target, bytes memory data)
786         internal
787         returns (bytes memory)
788     {
789         return
790             functionDelegateCall(
791                 target,
792                 data,
793                 "Address: low-level delegate call failed"
794             );
795     }
796 
797     /**
798      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
799      * but performing a delegate call.
800      *
801      * _Available since v3.4._
802      */
803     function functionDelegateCall(
804         address target,
805         bytes memory data,
806         string memory errorMessage
807     ) internal returns (bytes memory) {
808         require(isContract(target), "Address: delegate call to non-contract");
809 
810         // solhint-disable-next-line avoid-low-level-calls
811         (bool success, bytes memory returndata) = target.delegatecall(data);
812         return _verifyCallResult(success, returndata, errorMessage);
813     }
814 
815     function _verifyCallResult(
816         bool success,
817         bytes memory returndata,
818         string memory errorMessage
819     ) private pure returns (bytes memory) {
820         if (success) {
821             return returndata;
822         } else {
823             // Look for revert reason and bubble it up if present
824             if (returndata.length > 0) {
825                 // The easiest way to bubble the revert reason is using memory via assembly
826 
827                 // solhint-disable-next-line no-inline-assembly
828                 assembly {
829                     let returndata_size := mload(returndata)
830                     revert(add(32, returndata), returndata_size)
831                 }
832             } else {
833                 revert(errorMessage);
834             }
835         }
836     }
837 }
838 
839 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
840 
841 /**
842  * @dev Library for managing
843  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
844  * types.
845  *
846  * Sets have the following properties:
847  *
848  * - Elements are added, removed, and checked for existence in constant time
849  * (O(1)).
850  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
851  *
852  * ```
853  * contract Example {
854  *     // Add the library methods
855  *     using EnumerableSet for EnumerableSet.AddressSet;
856  *
857  *     // Declare a set state variable
858  *     EnumerableSet.AddressSet private mySet;
859  * }
860  * ```
861  *
862  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
863  * and `uint256` (`UintSet`) are supported.
864  */
865 library EnumerableSet {
866     // To implement this library for multiple types with as little code
867     // repetition as possible, we write it in terms of a generic Set type with
868     // bytes32 values.
869     // The Set implementation uses private functions, and user-facing
870     // implementations (such as AddressSet) are just wrappers around the
871     // underlying Set.
872     // This means that we can only create new EnumerableSets for types that fit
873     // in bytes32.
874 
875     struct Set {
876         // Storage of set values
877         bytes32[] _values;
878         // Position of the value in the `values` array, plus 1 because index 0
879         // means a value is not in the set.
880         mapping(bytes32 => uint256) _indexes;
881     }
882 
883     /**
884      * @dev Add a value to a set. O(1).
885      *
886      * Returns true if the value was added to the set, that is if it was not
887      * already present.
888      */
889     function _add(Set storage set, bytes32 value) private returns (bool) {
890         if (!_contains(set, value)) {
891             set._values.push(value);
892             // The value is stored at length-1, but we add 1 to all indexes
893             // and use 0 as a sentinel value
894             set._indexes[value] = set._values.length;
895             return true;
896         } else {
897             return false;
898         }
899     }
900 
901     /**
902      * @dev Removes a value from a set. O(1).
903      *
904      * Returns true if the value was removed from the set, that is if it was
905      * present.
906      */
907     function _remove(Set storage set, bytes32 value) private returns (bool) {
908         // We read and store the value's index to prevent multiple reads from the same storage slot
909         uint256 valueIndex = set._indexes[value];
910 
911         if (valueIndex != 0) {
912             // Equivalent to contains(set, value)
913             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
914             // the array, and then remove the last element (sometimes called as 'swap and pop').
915             // This modifies the order of the array, as noted in {at}.
916 
917             uint256 toDeleteIndex = valueIndex - 1;
918             uint256 lastIndex = set._values.length - 1;
919 
920             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
921             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
922 
923             bytes32 lastvalue = set._values[lastIndex];
924 
925             // Move the last value to the index where the value to delete is
926             set._values[toDeleteIndex] = lastvalue;
927             // Update the index for the moved value
928             set._indexes[lastvalue] = toDeleteIndex + 1;
929             // All indexes are 1-based
930 
931             // Delete the slot where the moved value was stored
932             set._values.pop();
933 
934             // Delete the index for the deleted slot
935             delete set._indexes[value];
936 
937             return true;
938         } else {
939             return false;
940         }
941     }
942 
943     /**
944      * @dev Returns true if the value is in the set. O(1).
945      */
946     function _contains(Set storage set, bytes32 value)
947         private
948         view
949         returns (bool)
950     {
951         return set._indexes[value] != 0;
952     }
953 
954     /**
955      * @dev Returns the number of values on the set. O(1).
956      */
957     function _length(Set storage set) private view returns (uint256) {
958         return set._values.length;
959     }
960 
961     /**
962      * @dev Returns the value stored at position `index` in the set. O(1).
963      *
964      * Note that there are no guarantees on the ordering of values inside the
965      * array, and it may change when more values are added or removed.
966      *
967      * Requirements:
968      *
969      * - `index` must be strictly less than {length}.
970      */
971     function _at(Set storage set, uint256 index)
972         private
973         view
974         returns (bytes32)
975     {
976         require(
977             set._values.length > index,
978             "EnumerableSet: index out of bounds"
979         );
980         return set._values[index];
981     }
982 
983     // Bytes32Set
984 
985     struct Bytes32Set {
986         Set _inner;
987     }
988 
989     /**
990      * @dev Add a value to a set. O(1).
991      *
992      * Returns true if the value was added to the set, that is if it was not
993      * already present.
994      */
995     function add(Bytes32Set storage set, bytes32 value)
996         internal
997         returns (bool)
998     {
999         return _add(set._inner, value);
1000     }
1001 
1002     /**
1003      * @dev Removes a value from a set. O(1).
1004      *
1005      * Returns true if the value was removed from the set, that is if it was
1006      * present.
1007      */
1008     function remove(Bytes32Set storage set, bytes32 value)
1009         internal
1010         returns (bool)
1011     {
1012         return _remove(set._inner, value);
1013     }
1014 
1015     /**
1016      * @dev Returns true if the value is in the set. O(1).
1017      */
1018     function contains(Bytes32Set storage set, bytes32 value)
1019         internal
1020         view
1021         returns (bool)
1022     {
1023         return _contains(set._inner, value);
1024     }
1025 
1026     /**
1027      * @dev Returns the number of values in the set. O(1).
1028      */
1029     function length(Bytes32Set storage set) internal view returns (uint256) {
1030         return _length(set._inner);
1031     }
1032 
1033     /**
1034      * @dev Returns the value stored at position `index` in the set. O(1).
1035      *
1036      * Note that there are no guarantees on the ordering of values inside the
1037      * array, and it may change when more values are added or removed.
1038      *
1039      * Requirements:
1040      *
1041      * - `index` must be strictly less than {length}.
1042      */
1043     function at(Bytes32Set storage set, uint256 index)
1044         internal
1045         view
1046         returns (bytes32)
1047     {
1048         return _at(set._inner, index);
1049     }
1050 
1051     // AddressSet
1052 
1053     struct AddressSet {
1054         Set _inner;
1055     }
1056 
1057     /**
1058      * @dev Add a value to a set. O(1).
1059      *
1060      * Returns true if the value was added to the set, that is if it was not
1061      * already present.
1062      */
1063     function add(AddressSet storage set, address value)
1064         internal
1065         returns (bool)
1066     {
1067         return _add(set._inner, bytes32(uint256(uint160(value))));
1068     }
1069 
1070     /**
1071      * @dev Removes a value from a set. O(1).
1072      *
1073      * Returns true if the value was removed from the set, that is if it was
1074      * present.
1075      */
1076     function remove(AddressSet storage set, address value)
1077         internal
1078         returns (bool)
1079     {
1080         return _remove(set._inner, bytes32(uint256(uint160(value))));
1081     }
1082 
1083     /**
1084      * @dev Returns true if the value is in the set. O(1).
1085      */
1086     function contains(AddressSet storage set, address value)
1087         internal
1088         view
1089         returns (bool)
1090     {
1091         return _contains(set._inner, bytes32(uint256(uint160(value))));
1092     }
1093 
1094     /**
1095      * @dev Returns the number of values in the set. O(1).
1096      */
1097     function length(AddressSet storage set) internal view returns (uint256) {
1098         return _length(set._inner);
1099     }
1100 
1101     /**
1102      * @dev Returns the value stored at position `index` in the set. O(1).
1103      *
1104      * Note that there are no guarantees on the ordering of values inside the
1105      * array, and it may change when more values are added or removed.
1106      *
1107      * Requirements:
1108      *
1109      * - `index` must be strictly less than {length}.
1110      */
1111     function at(AddressSet storage set, uint256 index)
1112         internal
1113         view
1114         returns (address)
1115     {
1116         return address(uint160(uint256(_at(set._inner, index))));
1117     }
1118 
1119     // UintSet
1120 
1121     struct UintSet {
1122         Set _inner;
1123     }
1124 
1125     /**
1126      * @dev Add a value to a set. O(1).
1127      *
1128      * Returns true if the value was added to the set, that is if it was not
1129      * already present.
1130      */
1131     function add(UintSet storage set, uint256 value) internal returns (bool) {
1132         return _add(set._inner, bytes32(value));
1133     }
1134 
1135     /**
1136      * @dev Removes a value from a set. O(1).
1137      *
1138      * Returns true if the value was removed from the set, that is if it was
1139      * present.
1140      */
1141     function remove(UintSet storage set, uint256 value)
1142         internal
1143         returns (bool)
1144     {
1145         return _remove(set._inner, bytes32(value));
1146     }
1147 
1148     /**
1149      * @dev Returns true if the value is in the set. O(1).
1150      */
1151     function contains(UintSet storage set, uint256 value)
1152         internal
1153         view
1154         returns (bool)
1155     {
1156         return _contains(set._inner, bytes32(value));
1157     }
1158 
1159     /**
1160      * @dev Returns the number of values on the set. O(1).
1161      */
1162     function length(UintSet storage set) internal view returns (uint256) {
1163         return _length(set._inner);
1164     }
1165 
1166     /**
1167      * @dev Returns the value stored at position `index` in the set. O(1).
1168      *
1169      * Note that there are no guarantees on the ordering of values inside the
1170      * array, and it may change when more values are added or removed.
1171      *
1172      * Requirements:
1173      *
1174      * - `index` must be strictly less than {length}.
1175      */
1176     function at(UintSet storage set, uint256 index)
1177         internal
1178         view
1179         returns (uint256)
1180     {
1181         return uint256(_at(set._inner, index));
1182     }
1183 }
1184 
1185 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1186 
1187 /**
1188  * @dev Library for managing an enumerable variant of Solidity's
1189  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1190  * type.
1191  *
1192  * Maps have the following properties:
1193  *
1194  * - Entries are added, removed, and checked for existence in constant time
1195  * (O(1)).
1196  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1197  *
1198  * ```
1199  * contract Example {
1200  *     // Add the library methods
1201  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1202  *
1203  *     // Declare a set state variable
1204  *     EnumerableMap.UintToAddressMap private myMap;
1205  * }
1206  * ```
1207  *
1208  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1209  * supported.
1210  */
1211 library EnumerableMap {
1212     // To implement this library for multiple types with as little code
1213     // repetition as possible, we write it in terms of a generic Map type with
1214     // bytes32 keys and values.
1215     // The Map implementation uses private functions, and user-facing
1216     // implementations (such as Uint256ToAddressMap) are just wrappers around
1217     // the underlying Map.
1218     // This means that we can only create new EnumerableMaps for types that fit
1219     // in bytes32.
1220 
1221     struct MapEntry {
1222         bytes32 _key;
1223         bytes32 _value;
1224     }
1225 
1226     struct Map {
1227         // Storage of map keys and values
1228         MapEntry[] _entries;
1229         // Position of the entry defined by a key in the `entries` array, plus 1
1230         // because index 0 means a key is not in the map.
1231         mapping(bytes32 => uint256) _indexes;
1232     }
1233 
1234     /**
1235      * @dev Adds a key-value pair to a map, or updates the value for an existing
1236      * key. O(1).
1237      *
1238      * Returns true if the key was added to the map, that is if it was not
1239      * already present.
1240      */
1241     function _set(
1242         Map storage map,
1243         bytes32 key,
1244         bytes32 value
1245     ) private returns (bool) {
1246         // We read and store the key's index to prevent multiple reads from the same storage slot
1247         uint256 keyIndex = map._indexes[key];
1248 
1249         if (keyIndex == 0) {
1250             // Equivalent to !contains(map, key)
1251             map._entries.push(MapEntry({_key: key, _value: value}));
1252             // The entry is stored at length-1, but we add 1 to all indexes
1253             // and use 0 as a sentinel value
1254             map._indexes[key] = map._entries.length;
1255             return true;
1256         } else {
1257             map._entries[keyIndex - 1]._value = value;
1258             return false;
1259         }
1260     }
1261 
1262     /**
1263      * @dev Removes a key-value pair from a map. O(1).
1264      *
1265      * Returns true if the key was removed from the map, that is if it was present.
1266      */
1267     function _remove(Map storage map, bytes32 key) private returns (bool) {
1268         // We read and store the key's index to prevent multiple reads from the same storage slot
1269         uint256 keyIndex = map._indexes[key];
1270 
1271         if (keyIndex != 0) {
1272             // Equivalent to contains(map, key)
1273             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1274             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1275             // This modifies the order of the array, as noted in {at}.
1276 
1277             uint256 toDeleteIndex = keyIndex - 1;
1278             uint256 lastIndex = map._entries.length - 1;
1279 
1280             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1281             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1282 
1283             MapEntry storage lastEntry = map._entries[lastIndex];
1284 
1285             // Move the last entry to the index where the entry to delete is
1286             map._entries[toDeleteIndex] = lastEntry;
1287             // Update the index for the moved entry
1288             map._indexes[lastEntry._key] = toDeleteIndex + 1;
1289             // All indexes are 1-based
1290 
1291             // Delete the slot where the moved entry was stored
1292             map._entries.pop();
1293 
1294             // Delete the index for the deleted slot
1295             delete map._indexes[key];
1296 
1297             return true;
1298         } else {
1299             return false;
1300         }
1301     }
1302 
1303     /**
1304      * @dev Returns true if the key is in the map. O(1).
1305      */
1306     function _contains(Map storage map, bytes32 key)
1307         private
1308         view
1309         returns (bool)
1310     {
1311         return map._indexes[key] != 0;
1312     }
1313 
1314     /**
1315      * @dev Returns the number of key-value pairs in the map. O(1).
1316      */
1317     function _length(Map storage map) private view returns (uint256) {
1318         return map._entries.length;
1319     }
1320 
1321     /**
1322      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1323      *
1324      * Note that there are no guarantees on the ordering of entries inside the
1325      * array, and it may change when more entries are added or removed.
1326      *
1327      * Requirements:
1328      *
1329      * - `index` must be strictly less than {length}.
1330      */
1331     function _at(Map storage map, uint256 index)
1332         private
1333         view
1334         returns (bytes32, bytes32)
1335     {
1336         require(
1337             map._entries.length > index,
1338             "EnumerableMap: index out of bounds"
1339         );
1340 
1341         MapEntry storage entry = map._entries[index];
1342         return (entry._key, entry._value);
1343     }
1344 
1345     /**
1346      * @dev Tries to returns the value associated with `key`.  O(1).
1347      * Does not revert if `key` is not in the map.
1348      */
1349     function _tryGet(Map storage map, bytes32 key)
1350         private
1351         view
1352         returns (bool, bytes32)
1353     {
1354         uint256 keyIndex = map._indexes[key];
1355         if (keyIndex == 0) return (false, 0);
1356         // Equivalent to contains(map, key)
1357         return (true, map._entries[keyIndex - 1]._value);
1358         // All indexes are 1-based
1359     }
1360 
1361     /**
1362      * @dev Returns the value associated with `key`.  O(1).
1363      *
1364      * Requirements:
1365      *
1366      * - `key` must be in the map.
1367      */
1368     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1369         uint256 keyIndex = map._indexes[key];
1370         require(keyIndex != 0, "EnumerableMap: nonexistent key");
1371         // Equivalent to contains(map, key)
1372         return map._entries[keyIndex - 1]._value;
1373         // All indexes are 1-based
1374     }
1375 
1376     /**
1377      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1378      *
1379      * CAUTION: This function is deprecated because it requires allocating memory for the error
1380      * message unnecessarily. For custom revert reasons use {_tryGet}.
1381      */
1382     function _get(
1383         Map storage map,
1384         bytes32 key,
1385         string memory errorMessage
1386     ) private view returns (bytes32) {
1387         uint256 keyIndex = map._indexes[key];
1388         require(keyIndex != 0, errorMessage);
1389         // Equivalent to contains(map, key)
1390         return map._entries[keyIndex - 1]._value;
1391         // All indexes are 1-based
1392     }
1393 
1394     // UintToAddressMap
1395 
1396     struct UintToAddressMap {
1397         Map _inner;
1398     }
1399 
1400     /**
1401      * @dev Adds a key-value pair to a map, or updates the value for an existing
1402      * key. O(1).
1403      *
1404      * Returns true if the key was added to the map, that is if it was not
1405      * already present.
1406      */
1407     function set(
1408         UintToAddressMap storage map,
1409         uint256 key,
1410         address value
1411     ) internal returns (bool) {
1412         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1413     }
1414 
1415     /**
1416      * @dev Removes a value from a set. O(1).
1417      *
1418      * Returns true if the key was removed from the map, that is if it was present.
1419      */
1420     function remove(UintToAddressMap storage map, uint256 key)
1421         internal
1422         returns (bool)
1423     {
1424         return _remove(map._inner, bytes32(key));
1425     }
1426 
1427     /**
1428      * @dev Returns true if the key is in the map. O(1).
1429      */
1430     function contains(UintToAddressMap storage map, uint256 key)
1431         internal
1432         view
1433         returns (bool)
1434     {
1435         return _contains(map._inner, bytes32(key));
1436     }
1437 
1438     /**
1439      * @dev Returns the number of elements in the map. O(1).
1440      */
1441     function length(UintToAddressMap storage map)
1442         internal
1443         view
1444         returns (uint256)
1445     {
1446         return _length(map._inner);
1447     }
1448 
1449     /**
1450      * @dev Returns the element stored at position `index` in the set. O(1).
1451      * Note that there are no guarantees on the ordering of values inside the
1452      * array, and it may change when more values are added or removed.
1453      *
1454      * Requirements:
1455      *
1456      * - `index` must be strictly less than {length}.
1457      */
1458     function at(UintToAddressMap storage map, uint256 index)
1459         internal
1460         view
1461         returns (uint256, address)
1462     {
1463         (bytes32 key, bytes32 value) = _at(map._inner, index);
1464         return (uint256(key), address(uint160(uint256(value))));
1465     }
1466 
1467     /**
1468      * @dev Tries to returns the value associated with `key`.  O(1).
1469      * Does not revert if `key` is not in the map.
1470      *
1471      * _Available since v3.4._
1472      */
1473     function tryGet(UintToAddressMap storage map, uint256 key)
1474         internal
1475         view
1476         returns (bool, address)
1477     {
1478         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1479         return (success, address(uint160(uint256(value))));
1480     }
1481 
1482     /**
1483      * @dev Returns the value associated with `key`.  O(1).
1484      *
1485      * Requirements:
1486      *
1487      * - `key` must be in the map.
1488      */
1489     function get(UintToAddressMap storage map, uint256 key)
1490         internal
1491         view
1492         returns (address)
1493     {
1494         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1495     }
1496 
1497     /**
1498      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1499      *
1500      * CAUTION: This function is deprecated because it requires allocating memory for the error
1501      * message unnecessarily. For custom revert reasons use {tryGet}.
1502      */
1503     function get(
1504         UintToAddressMap storage map,
1505         uint256 key,
1506         string memory errorMessage
1507     ) internal view returns (address) {
1508         return
1509             address(
1510                 uint160(uint256(_get(map._inner, bytes32(key), errorMessage)))
1511             );
1512     }
1513 }
1514 
1515 // File: @openzeppelin/contracts/utils/Strings.sol
1516 
1517 /**
1518  * @dev String operations.
1519  */
1520 library Strings {
1521     /**
1522      * @dev Converts a `uint256` to its ASCII `string` representation.
1523      */
1524     function toString(uint256 value) internal pure returns (string memory) {
1525         // Inspired by OraclizeAPI's implementation - MIT licence
1526         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1527 
1528         if (value == 0) {
1529             return "0";
1530         }
1531         uint256 temp = value;
1532         uint256 digits;
1533         while (temp != 0) {
1534             digits++;
1535             temp /= 10;
1536         }
1537         bytes memory buffer = new bytes(digits);
1538         while (value != 0) {
1539             digits -= 1;
1540             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1541             value /= 10;
1542         }
1543         return string(buffer);
1544     }
1545 }
1546 
1547 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1548 
1549 /**
1550  * @title ERC721 Non-Fungible Token Standard basic implementation
1551  * @dev see https://eips.ethereum.org/EIPS/eip-721
1552  */
1553 contract ERC721 is
1554     Context,
1555     ERC165,
1556     IERC721,
1557     IERC721Metadata,
1558     IERC721Enumerable
1559 {
1560     using SafeMath for uint256;
1561     using Address for address;
1562     using EnumerableSet for EnumerableSet.UintSet;
1563     using EnumerableMap for EnumerableMap.UintToAddressMap;
1564     using Strings for uint256;
1565 
1566     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1567     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1568     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1569 
1570     // Mapping from holder address to their (enumerable) set of owned tokens
1571     mapping(address => EnumerableSet.UintSet) private _holderTokens;
1572 
1573     // Enumerable mapping from token ids to their owners
1574     EnumerableMap.UintToAddressMap private _tokenOwners;
1575 
1576     // Mapping from token ID to approved address
1577     mapping(uint256 => address) private _tokenApprovals;
1578 
1579     // Mapping from owner to operator approvals
1580     mapping(address => mapping(address => bool)) private _operatorApprovals;
1581 
1582     // Token name
1583     string private _name;
1584 
1585     // Token symbol
1586     string private _symbol;
1587 
1588     // Optional mapping for token URIs
1589     mapping(uint256 => string) private _tokenURIs;
1590 
1591     // Base URI
1592     string private _baseURI;
1593 
1594     /*
1595      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1596      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1597      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1598      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1599      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1600      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1601      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1602      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1603      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1604      *
1605      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1606      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1607      */
1608     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1609 
1610     /*
1611      *     bytes4(keccak256('name()')) == 0x06fdde03
1612      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1613      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1614      *
1615      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1616      */
1617     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1618 
1619     /*
1620      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1621      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1622      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1623      *
1624      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1625      */
1626     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1627 
1628     /**
1629      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1630      */
1631     constructor(string memory name_, string memory symbol_) {
1632         _name = name_;
1633         _symbol = symbol_;
1634 
1635         // register the supported interfaces to conform to ERC721 via ERC165
1636         _registerInterface(_INTERFACE_ID_ERC721);
1637         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1638         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1639     }
1640 
1641     /**
1642      * @dev See {IERC721-balanceOf}.
1643      */
1644     function balanceOf(address owner)
1645         public
1646         view
1647         virtual
1648         override
1649         returns (uint256)
1650     {
1651         require(
1652             owner != address(0),
1653             "ERC721: balance query for the zero address"
1654         );
1655         return _holderTokens[owner].length();
1656     }
1657 
1658     /**
1659      * @dev See {IERC721-ownerOf}.
1660      */
1661     function ownerOf(uint256 tokenId)
1662         public
1663         view
1664         virtual
1665         override
1666         returns (address)
1667     {
1668         return
1669             _tokenOwners.get(
1670                 tokenId,
1671                 "ERC721: owner query for nonexistent token"
1672             );
1673     }
1674 
1675     /**
1676      * @dev See {IERC721Metadata-name}.
1677      */
1678     function name() public view virtual override returns (string memory) {
1679         return _name;
1680     }
1681 
1682     /**
1683      * @dev See {IERC721Metadata-symbol}.
1684      */
1685     function symbol() public view virtual override returns (string memory) {
1686         return _symbol;
1687     }
1688 
1689     /**
1690      * @dev See {IERC721Metadata-tokenURI}.
1691      */
1692     function tokenURI(uint256 tokenId)
1693         public
1694         view
1695         virtual
1696         override
1697         returns (string memory)
1698     {
1699         require(
1700             _exists(tokenId),
1701             "ERC721Metadata: URI query for nonexistent token"
1702         );
1703 
1704         string memory _tokenURI = _tokenURIs[tokenId];
1705         string memory base = baseURI();
1706 
1707         // If there is no base URI, return the token URI.
1708         if (bytes(base).length == 0) {
1709             return _tokenURI;
1710         }
1711         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1712         if (bytes(_tokenURI).length > 0) {
1713             return string(abi.encodePacked(base, _tokenURI));
1714         }
1715         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1716         return string(abi.encodePacked(base, tokenId.toString()));
1717     }
1718 
1719     /**
1720      * @dev Returns the base URI set via {_setBaseURI}. This will be
1721      * automatically added as a prefix in {tokenURI} to each token's URI, or
1722      * to the token ID if no specific URI is set for that token ID.
1723      */
1724     function baseURI() public view virtual returns (string memory) {
1725         return _baseURI;
1726     }
1727 
1728     /**
1729      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1730      */
1731     function tokenOfOwnerByIndex(address owner, uint256 index)
1732         public
1733         view
1734         virtual
1735         override
1736         returns (uint256)
1737     {
1738         return _holderTokens[owner].at(index);
1739     }
1740 
1741     /**
1742      * @dev See {IERC721Enumerable-totalSupply}.
1743      */
1744     function totalSupply() public view virtual override returns (uint256) {
1745         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1746         return _tokenOwners.length();
1747     }
1748 
1749     /**
1750      * @dev See {IERC721Enumerable-tokenByIndex}.
1751      */
1752     function tokenByIndex(uint256 index)
1753         public
1754         view
1755         virtual
1756         override
1757         returns (uint256)
1758     {
1759         (uint256 tokenId, ) = _tokenOwners.at(index);
1760         return tokenId;
1761     }
1762 
1763     /**
1764      * @dev See {IERC721-approve}.
1765      */
1766     function approve(address to, uint256 tokenId) public virtual override {
1767         address owner = ERC721.ownerOf(tokenId);
1768         require(to != owner, "ERC721: approval to current owner");
1769 
1770         require(
1771             _msgSender() == owner ||
1772                 ERC721.isApprovedForAll(owner, _msgSender()),
1773             "ERC721: approve caller is not owner nor approved for all"
1774         );
1775 
1776         _approve(to, tokenId);
1777     }
1778 
1779     /**
1780      * @dev See {IERC721-getApproved}.
1781      */
1782     function getApproved(uint256 tokenId)
1783         public
1784         view
1785         virtual
1786         override
1787         returns (address)
1788     {
1789         require(
1790             _exists(tokenId),
1791             "ERC721: approved query for nonexistent token"
1792         );
1793 
1794         return _tokenApprovals[tokenId];
1795     }
1796 
1797     /**
1798      * @dev See {IERC721-setApprovalForAll}.
1799      */
1800     function setApprovalForAll(address operator, bool approved)
1801         public
1802         virtual
1803         override
1804     {
1805         require(operator != _msgSender(), "ERC721: approve to caller");
1806 
1807         _operatorApprovals[_msgSender()][operator] = approved;
1808         emit ApprovalForAll(_msgSender(), operator, approved);
1809     }
1810 
1811     /**
1812      * @dev See {IERC721-isApprovedForAll}.
1813      */
1814     function isApprovedForAll(address owner, address operator)
1815         public
1816         view
1817         virtual
1818         override
1819         returns (bool)
1820     {
1821         return _operatorApprovals[owner][operator];
1822     }
1823 
1824     /**
1825      * @dev See {IERC721-transferFrom}.
1826      */
1827     function transferFrom(
1828         address from,
1829         address to,
1830         uint256 tokenId
1831     ) public virtual override {
1832         //solhint-disable-next-line max-line-length
1833         require(
1834             _isApprovedOrOwner(_msgSender(), tokenId),
1835             "ERC721: transfer caller is not owner nor approved"
1836         );
1837 
1838         _transfer(from, to, tokenId);
1839     }
1840 
1841     /**
1842      * @dev See {IERC721-safeTransferFrom}.
1843      */
1844     function safeTransferFrom(
1845         address from,
1846         address to,
1847         uint256 tokenId
1848     ) public virtual override {
1849         safeTransferFrom(from, to, tokenId, "");
1850     }
1851 
1852     /**
1853      * @dev See {IERC721-safeTransferFrom}.
1854      */
1855     function safeTransferFrom(
1856         address from,
1857         address to,
1858         uint256 tokenId,
1859         bytes memory _data
1860     ) public virtual override {
1861         require(
1862             _isApprovedOrOwner(_msgSender(), tokenId),
1863             "ERC721: transfer caller is not owner nor approved"
1864         );
1865         _safeTransfer(from, to, tokenId, _data);
1866     }
1867 
1868     /**
1869      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1870      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1871      *
1872      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1873      *
1874      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1875      * implement alternative mechanisms to perform token transfer, such as signature-based.
1876      *
1877      * Requirements:
1878      *
1879      * - `from` cannot be the zero address.
1880      * - `to` cannot be the zero address.
1881      * - `tokenId` token must exist and be owned by `from`.
1882      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1883      *
1884      * Emits a {Transfer} event.
1885      */
1886     function _safeTransfer(
1887         address from,
1888         address to,
1889         uint256 tokenId,
1890         bytes memory _data
1891     ) internal virtual {
1892         _transfer(from, to, tokenId);
1893         require(
1894             _checkOnERC721Received(from, to, tokenId, _data),
1895             "ERC721: transfer to non ERC721Receiver implementer"
1896         );
1897     }
1898 
1899     /**
1900      * @dev Returns whether `tokenId` exists.
1901      *
1902      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1903      *
1904      * Tokens start existing when they are minted (`_mint`),
1905      * and stop existing when they are burned (`_burn`).
1906      */
1907     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1908         return _tokenOwners.contains(tokenId);
1909     }
1910 
1911     /**
1912      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1913      *
1914      * Requirements:
1915      *
1916      * - `tokenId` must exist.
1917      */
1918     function _isApprovedOrOwner(address spender, uint256 tokenId)
1919         internal
1920         view
1921         virtual
1922         returns (bool)
1923     {
1924         require(
1925             _exists(tokenId),
1926             "ERC721: operator query for nonexistent token"
1927         );
1928         address owner = ERC721.ownerOf(tokenId);
1929         return (spender == owner ||
1930             getApproved(tokenId) == spender ||
1931             ERC721.isApprovedForAll(owner, spender));
1932     }
1933 
1934     /**
1935      * @dev Safely mints `tokenId` and transfers it to `to`.
1936      *
1937      * Requirements:
1938      d*
1939      * - `tokenId` must not exist.
1940      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1941      *
1942      * Emits a {Transfer} event.
1943      */
1944     function _safeMint(address to, uint256 tokenId) internal virtual {
1945         _safeMint(to, tokenId, "");
1946     }
1947 
1948     /**
1949      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1950      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1951      */
1952     function _safeMint(
1953         address to,
1954         uint256 tokenId,
1955         bytes memory _data
1956     ) internal virtual {
1957         _mint(to, tokenId);
1958         require(
1959             _checkOnERC721Received(address(0), to, tokenId, _data),
1960             "ERC721: transfer to non ERC721Receiver implementer"
1961         );
1962     }
1963 
1964     /**
1965      * @dev Mints `tokenId` and transfers it to `to`.
1966      *
1967      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1968      *
1969      * Requirements:
1970      *
1971      * - `tokenId` must not exist.
1972      * - `to` cannot be the zero address.
1973      *
1974      * Emits a {Transfer} event.
1975      */
1976     function _mint(address to, uint256 tokenId) internal virtual {
1977         require(to != address(0), "ERC721: mint to the zero address");
1978         require(!_exists(tokenId), "ERC721: token already minted");
1979 
1980         _beforeTokenTransfer(address(0), to, tokenId);
1981 
1982         _holderTokens[to].add(tokenId);
1983 
1984         _tokenOwners.set(tokenId, to);
1985 
1986         emit Transfer(address(0), to, tokenId);
1987     }
1988 
1989     /**
1990      * @dev Destroys `tokenId`.
1991      * The approval is cleared when the token is burned.
1992      *
1993      * Requirements:
1994      *
1995      * - `tokenId` must exist.
1996      *
1997      * Emits a {Transfer} event.
1998      */
1999     function _burn(uint256 tokenId) internal virtual {
2000         address owner = ERC721.ownerOf(tokenId);
2001         // internal owner
2002 
2003         _beforeTokenTransfer(owner, address(0), tokenId);
2004 
2005         // Clear approvals
2006         _approve(address(0), tokenId);
2007 
2008         // Clear metadata (if any)
2009         if (bytes(_tokenURIs[tokenId]).length != 0) {
2010             delete _tokenURIs[tokenId];
2011         }
2012 
2013         _holderTokens[owner].remove(tokenId);
2014 
2015         _tokenOwners.remove(tokenId);
2016 
2017         emit Transfer(owner, address(0), tokenId);
2018     }
2019 
2020     /**
2021      * @dev Transfers `tokenId` from `from` to `to`.
2022      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2023      *
2024      * Requirements:
2025      *
2026      * - `to` cannot be the zero address.
2027      * - `tokenId` token must be owned by `from`.
2028      *
2029      * Emits a {Transfer} event.
2030      */
2031     function _transfer(
2032         address from,
2033         address to,
2034         uint256 tokenId
2035     ) internal virtual {
2036         require(
2037             ERC721.ownerOf(tokenId) == from,
2038             "ERC721: transfer of token that is not own"
2039         );
2040         // internal owner
2041         require(to != address(0), "ERC721: transfer to the zero address");
2042 
2043         _beforeTokenTransfer(from, to, tokenId);
2044 
2045         // Clear approvals from the previous owner
2046         _approve(address(0), tokenId);
2047 
2048         _holderTokens[from].remove(tokenId);
2049         _holderTokens[to].add(tokenId);
2050 
2051         _tokenOwners.set(tokenId, to);
2052 
2053         emit Transfer(from, to, tokenId);
2054     }
2055 
2056     /**
2057      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
2058      *
2059      * Requirements:
2060      *
2061      * - `tokenId` must exist.
2062      */
2063     function _setTokenURI(uint256 tokenId, string memory _tokenURI)
2064         internal
2065         virtual
2066     {
2067         require(
2068             _exists(tokenId),
2069             "ERC721Metadata: URI set of nonexistent token"
2070         );
2071         _tokenURIs[tokenId] = _tokenURI;
2072     }
2073 
2074     /**
2075      * @dev Internal function to set the base URI for all token IDs. It is
2076      * automatically added as a prefix to the value returned in {tokenURI},
2077      * or to the token ID if {tokenURI} is empty.
2078      */
2079     function _setBaseURI(string memory baseURI_) internal virtual {
2080         _baseURI = baseURI_;
2081     }
2082 
2083     /**
2084      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2085      * The call is not executed if the target address is not a contract.
2086      *
2087      * @param from address representing the previous owner of the given token ID
2088      * @param to target address that will receive the tokens
2089      * @param tokenId uint256 ID of the token to be transferred
2090      * @param _data bytes optional data to send along with the call
2091      * @return bool whether the call correctly returned the expected magic value
2092      */
2093     function _checkOnERC721Received(
2094         address from,
2095         address to,
2096         uint256 tokenId,
2097         bytes memory _data
2098     ) private returns (bool) {
2099         if (!to.isContract()) {
2100             return true;
2101         }
2102         bytes memory returndata = to.functionCall(
2103             abi.encodeWithSelector(
2104                 IERC721Receiver(to).onERC721Received.selector,
2105                 _msgSender(),
2106                 from,
2107                 tokenId,
2108                 _data
2109             ),
2110             "ERC721: transfer to non ERC721Receiver implementer"
2111         );
2112         bytes4 retval = abi.decode(returndata, (bytes4));
2113         return (retval == _ERC721_RECEIVED);
2114     }
2115 
2116     /**
2117      * @dev Approve `to` to operate on `tokenId`
2118      *
2119      * Emits an {Approval} event.
2120      */
2121     function _approve(address to, uint256 tokenId) internal virtual {
2122         _tokenApprovals[tokenId] = to;
2123         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2124         // internal owner
2125     }
2126 
2127     /**
2128      * @dev Hook that is called before any token transfer. This includes minting
2129      * and burning.
2130      *
2131      * Calling conditions:
2132      *
2133      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2134      * transferred to `to`.
2135      * - When `from` is zero, `tokenId` will be minted for `to`.
2136      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2137      * - `from` cannot be the zero address.
2138      * - `to` cannot be the zero address.
2139      *
2140      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2141      */
2142     function _beforeTokenTransfer(
2143         address from,
2144         address to,
2145         uint256 tokenId
2146     ) internal virtual {}
2147 }
2148 
2149 // File: @openzeppelin/contracts/access/Ownable.sol
2150 
2151 /**
2152  * @dev Contract module which provides a basic access control mechanism, where
2153  * there is an account (an owner) that can be granted exclusive access to
2154  * specific functions.
2155  *
2156  * By default, the owner account will be the one that deploys the contract. This
2157  * can later be changed with {transferOwnership}.
2158  *
2159  * This module is used through inheritance. It will make available the modifier
2160  * `onlyOwner`, which can be applied to your functions to restrict their use to
2161  * the owner.
2162  */
2163 abstract contract Ownable is Context {
2164     address private _owner;
2165 
2166     event OwnershipTransferred(
2167         address indexed previousOwner,
2168         address indexed newOwner
2169     );
2170 
2171     /**
2172      * @dev Initializes the contract setting the deployer as the initial owner.
2173      */
2174     constructor() {
2175         address msgSender = _msgSender();
2176         _owner = msgSender;
2177         emit OwnershipTransferred(address(0), msgSender);
2178     }
2179 
2180     /**
2181      * @dev Returns the address of the current owner.
2182      */
2183     function owner() public view virtual returns (address) {
2184         return _owner;
2185     }
2186 
2187     /**
2188      * @dev Throws if called by any account other than the owner.
2189      */
2190     modifier onlyOwner() {
2191         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2192         _;
2193     }
2194 
2195     /**
2196      * @dev Leaves the contract without owner. It will not be possible to call
2197      * `onlyOwner` functions anymore. Can only be called by the current owner.
2198      *
2199      * NOTE: Renouncing ownership will leave the contract without an owner,
2200      * thereby removing any functionality that is only available to the owner.
2201      */
2202     function renounceOwnership() public virtual onlyOwner {
2203         emit OwnershipTransferred(_owner, address(0));
2204         _owner = address(0);
2205     }
2206 
2207     /**
2208      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2209      * Can only be called by the current owner.
2210      */
2211     function transferOwnership(address newOwner) public virtual onlyOwner {
2212         require(
2213             newOwner != address(0),
2214             "Ownable: new owner is the zero address"
2215         );
2216         emit OwnershipTransferred(_owner, newOwner);
2217         _owner = newOwner;
2218     }
2219 }
2220 
2221 // File: contracts/Lacedameon.sol
2222 
2223 /**
2224  * @title Lacedameon contract
2225  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
2226  */
2227 contract Lacedameon is ERC721, Ownable {
2228     using SafeMath for uint256;
2229     using Strings for uint256;
2230 
2231     uint256 public startingIndexBlock;
2232     uint256 public startingIndex;
2233     uint256 public privateMintPrice = 0.075 ether;
2234     uint256 public publicMintPrice = 0.08 ether;
2235     uint256 public maxToMint = 5;
2236     uint256 public MAX_MINT_WHITELIST = 5;
2237     uint256 public MAX_ELEMENTS = 1000;
2238     uint256 public REVEAL_TIMESTAMP;
2239 
2240     bool public revealed = false;
2241 
2242     string public notRevealedUri = "";
2243 
2244     string public PROVENANCE_HASH = "";
2245     bool public saleIsActive = false;
2246     bool public privateSaleIsActive = true;
2247 
2248     struct Whitelist {
2249         address addr;
2250         uint256 claimAmount;
2251         uint256 hasMinted;
2252     }
2253 
2254     mapping(address => Whitelist) public whitelist;
2255     mapping(address => Whitelist) public winnerlist;
2256 
2257     address[] whitelistAddr;
2258     address[] winnerlistAddr;
2259 
2260     constructor(
2261         string memory _name,
2262         string memory _symbol,
2263         string memory _initBaseURI,
2264         string memory _initNotRevealedUri
2265     ) ERC721(_name, _symbol) {
2266         REVEAL_TIMESTAMP = block.timestamp;
2267         _setBaseURI(_initBaseURI);
2268         setNotRevealedURI(_initNotRevealedUri);
2269     }
2270 
2271     /**
2272      * Get the array of token for owner.
2273      */
2274     function tokensOfOwner(address _owner)
2275         external
2276         view
2277         returns (uint256[] memory)
2278     {
2279         uint256 tokenCount = balanceOf(_owner);
2280         if (tokenCount == 0) {
2281             return new uint256[](0);
2282         } else {
2283             uint256[] memory result = new uint256[](tokenCount);
2284             for (uint256 index; index < tokenCount; index++) {
2285                 result[index] = tokenOfOwnerByIndex(_owner, index);
2286             }
2287             return result;
2288         }
2289     }
2290 
2291     /**
2292      * Check if certain token id is exists.
2293      */
2294     function exists(uint256 _tokenId) public view returns (bool) {
2295         return _exists(_tokenId);
2296     }
2297 
2298     /**
2299      * Set presell price to mint
2300      */
2301     function setPrivateMintPrice(uint256 _price) external onlyOwner {
2302         privateMintPrice = _price;
2303     }
2304 
2305     /**
2306      * Set publicsell price to mint
2307      */
2308     function setPublicMintPrice(uint256 _price) external onlyOwner {
2309         publicMintPrice = _price;
2310     }
2311 
2312     /**
2313      * Set maximum count to mint per once.
2314      */
2315     function setMaxToMint(uint256 _maxValue) external onlyOwner {
2316         maxToMint = _maxValue;
2317     }
2318 
2319     /**
2320      * reserve by owner
2321      */
2322 
2323     function reserve(uint256 _count) public onlyOwner {
2324         uint256 total = totalSupply();
2325         require(total + _count <= MAX_ELEMENTS, "Exceeded");
2326         for (uint256 i = 0; i < _count; i++) {
2327             _safeMint(msg.sender, total + i);
2328         }
2329     }
2330 
2331     /**
2332      * Set reveal timestamp when finished the sale.
2333      */
2334     function setRevealTimestamp(uint256 _revealTimeStamp) external onlyOwner {
2335         REVEAL_TIMESTAMP = _revealTimeStamp;
2336     }
2337 
2338     /*
2339      * Set provenance once it's calculated
2340      */
2341     function setProvenanceHash(string memory _provenanceHash)
2342         external
2343         onlyOwner
2344     {
2345         PROVENANCE_HASH = _provenanceHash;
2346     }
2347 
2348     function setBaseURI(string memory baseURI) external onlyOwner {
2349         _setBaseURI(baseURI);
2350     }
2351 
2352     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2353         notRevealedUri = _notRevealedURI;
2354     }
2355 
2356     //only owner
2357     function reveal() public onlyOwner {
2358         revealed = true;
2359     }
2360 
2361     function tokenURI(uint256 tokenId)
2362         public
2363         view
2364         virtual
2365         override
2366         returns (string memory)
2367     {
2368         require(
2369             _exists(tokenId),
2370             "ERC721Metadata: URI query for nonexistent token"
2371         );
2372         require(tokenId < totalSupply(), "URI query for nonexistent token");
2373         if (revealed == false) {
2374             return notRevealedUri;
2375         }
2376         string memory base = baseURI();
2377         return string(abi.encodePacked(base, "/", tokenId.toString(), ".json"));
2378     }
2379 
2380     /*
2381      * Pause sale if active, make active if paused
2382      */
2383 
2384     function flipSaleState() public onlyOwner {
2385         saleIsActive = !saleIsActive;
2386     }
2387 
2388     function flipPrivateSaleState() public onlyOwner {
2389         privateSaleIsActive = !privateSaleIsActive;
2390     }
2391 
2392     /**
2393      * Mints tokens
2394      */
2395     function mint(uint256 _count) public payable {
2396         uint256 total = totalSupply();
2397         require(saleIsActive, "Sale must be active to mint");
2398         require((total + _count) <= MAX_ELEMENTS, "Max limit");
2399 
2400         if (privateSaleIsActive) {
2401             require(
2402                 (privateMintPrice * _count) <= msg.value,
2403                 "Value below price"
2404             );
2405             require(_count <= MAX_MINT_WHITELIST, "Above max tx count");
2406             require(isWhitelisted(msg.sender), "Is not whitelisted");
2407             require(
2408                 whitelist[msg.sender].hasMinted.add(_count) <=
2409                     MAX_MINT_WHITELIST,
2410                 "Can only mint 5 while whitelisted"
2411             );
2412             whitelist[msg.sender].hasMinted = whitelist[msg.sender]
2413                 .hasMinted
2414                 .add(_count);
2415         } else {
2416             if (isWhitelisted(msg.sender)) {
2417                 require((balanceOf(msg.sender) - whitelist[msg.sender].hasMinted + _count) <= maxToMint, "Can only mint 5 tokens");
2418             } else {
2419                 require((balanceOf(msg.sender) + _count) <= maxToMint, "Can only mint 5 tokens");
2420             }
2421             require(
2422                 (publicMintPrice * _count) <= msg.value,
2423                 "Value below price"
2424             );
2425         }
2426 
2427         for (uint256 i = 0; i < _count; i++) {
2428             uint256 mintIndex = totalSupply() + 1;
2429             if (totalSupply() < MAX_ELEMENTS) {
2430                 _safeMint(msg.sender, mintIndex);
2431             }
2432         }
2433 
2434         // If we haven't set the starting index and this is either
2435         // 1) the last saleable token or
2436         // 2) the first token to be sold after the end of pre-sale, set the starting index block
2437         if (
2438             startingIndexBlock == 0 &&
2439             (totalSupply() == MAX_ELEMENTS ||
2440                 block.timestamp >= REVEAL_TIMESTAMP)
2441         ) {
2442             startingIndexBlock = block.number;
2443         }
2444     }
2445 
2446     function freeMint(uint256 _count) public {
2447         uint256 total = totalSupply();
2448         require(isWinnerlisted(msg.sender), "Is not winnerlisted");
2449         require(saleIsActive, "Sale must be active to mint");
2450         require((total + _count) <= MAX_ELEMENTS, "Exceeds max supply");
2451         require(
2452             winnerlist[msg.sender].claimAmount > 0,
2453             "You have no amount to claim"
2454         );
2455         require(
2456             _count <= winnerlist[msg.sender].claimAmount,
2457             "You claim amount exceeded"
2458         );
2459 
2460         for (uint256 i = 0; i < _count; i++) {
2461             uint256 mintIndex = totalSupply() + 1;
2462             if (totalSupply() < MAX_ELEMENTS) {
2463                 _safeMint(msg.sender, mintIndex);
2464             }
2465         }
2466 
2467         winnerlist[msg.sender].claimAmount =
2468             winnerlist[msg.sender].claimAmount -
2469             _count;
2470 
2471         // If we haven't set the starting index and this is either
2472         // 1) the last saleable token or
2473         // 2) the first token to be sold after the end of pre-sale, set the starting index block
2474         if (
2475             startingIndexBlock == 0 &&
2476             (totalSupply() == MAX_ELEMENTS ||
2477                 block.timestamp >= REVEAL_TIMESTAMP)
2478         ) {
2479             startingIndexBlock = block.number;
2480         }
2481     }
2482 
2483     /**
2484      * Set the starting index for the collection
2485      */
2486     function setStartingIndex() external onlyOwner {
2487         require(startingIndex == 0, "Starting index is already set");
2488         require(startingIndexBlock != 0, "Starting index block must be set");
2489 
2490         startingIndex = uint256(blockhash(startingIndexBlock)) % MAX_ELEMENTS;
2491         // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
2492         if ((block.number - startingIndexBlock) > 255) {
2493             startingIndex = uint256(blockhash(block.number - 1)) % MAX_ELEMENTS;
2494         }
2495         // Prevent default sequence
2496         if (startingIndex == 0) {
2497             startingIndex = startingIndex + 1;
2498         }
2499     }
2500 
2501     function setWhitelistAddr(address[] memory addrs) public onlyOwner {
2502         whitelistAddr = addrs;
2503         for (uint256 i = 0; i < whitelistAddr.length; i++) {
2504             addAddressToWhitelist(whitelistAddr[i]);
2505         }
2506     }
2507 
2508     /**
2509      * Set the starting index block for the collection, essentially unblocking
2510      * setting starting index
2511      */
2512     function emergencySetStartingIndexBlock() external onlyOwner {
2513         require(startingIndex == 0, "Starting index is already set");
2514 
2515         startingIndexBlock = block.number;
2516     }
2517 
2518     function withdraw() public onlyOwner {
2519         uint256 balance = address(this).balance;
2520         (bool success, ) = msg.sender.call{value: balance}("");
2521         require(success);
2522     }
2523 
2524     function partialWithdraw(uint256 _amount, address payable _to)
2525         external
2526         onlyOwner
2527     {
2528         require(_amount > 0, "Withdraw must be greater than 0");
2529         require(_amount <= address(this).balance, "Amount too high");
2530         (bool success, ) = _to.call{value: _amount}("");
2531         require(success);
2532     }
2533 
2534     function addAddressToWhitelist(address addr)
2535         public
2536         onlyOwner
2537         returns (bool success)
2538     {
2539         require(!isWhitelisted(addr), "Already whitelisted");
2540         whitelist[addr].addr = addr;
2541         success = true;
2542     }
2543 
2544     function isWhitelisted(address addr)
2545         public
2546         view
2547         returns (bool isWhiteListed)
2548     {
2549         return whitelist[addr].addr == addr;
2550     }
2551 
2552     function addAddressToWinnerlist(address addr, uint256 claimAmount)
2553         public
2554         onlyOwner
2555         returns (bool success)
2556     {
2557         require(!isWinnerlisted(addr), "Already winnerlisted");
2558         winnerlist[addr].addr = addr;
2559         winnerlist[addr].claimAmount = claimAmount;
2560         winnerlist[addr].hasMinted = 0;
2561         success = true;
2562     }
2563 
2564     function isWinnerlisted(address addr)
2565         public
2566         view
2567         returns (bool isWinnerListed)
2568     {
2569         return winnerlist[addr].addr == addr;
2570     }
2571 }