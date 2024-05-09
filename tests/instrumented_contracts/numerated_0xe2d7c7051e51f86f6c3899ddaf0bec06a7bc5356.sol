1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-28
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-04-22
7  */
8 // File: @openzeppelin/contracts/utils/Context.sol
9 // SPDX-License-Identifier: MIT
10 pragma solidity >=0.6.0 <0.8.0;
11 
12 /*
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with GSN meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address payable) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes memory) {
28         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29         return msg.data;
30     }
31 }
32 // File: @openzeppelin/contracts/introspection/IERC165.sol
33 pragma solidity >=0.6.0 <0.8.0;
34 
35 /**
36  * @dev Interface of the ERC165 standard, as defined in the
37  * https://eips.ethereum.org/EIPS/eip-165[EIP].
38  *
39  * Implementers can declare support of contract interfaces, which can then be
40  * queried by others ({ERC165Checker}).
41  *
42  * For an implementation, see {ERC165}.
43  */
44 interface IERC165 {
45     /**
46      * @dev Returns true if this contract implements the interface defined by
47      * `interfaceId`. See the corresponding
48      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
49      * to learn more about how these ids are created.
50      *
51      * This function call must use less than 30 000 gas.
52      */
53     function supportsInterface(bytes4 interfaceId) external view returns (bool);
54 }
55 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
56 pragma solidity >=0.6.2 <0.8.0;
57 
58 /**
59  * @dev Required interface of an ERC721 compliant contract.
60  */
61 interface IERC721 is IERC165 {
62     /**
63      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
64      */
65     event Transfer(
66         address indexed from,
67         address indexed to,
68         uint256 indexed tokenId
69     );
70     /**
71      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
72      */
73     event Approval(
74         address indexed owner,
75         address indexed approved,
76         uint256 indexed tokenId
77     );
78     /**
79      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
80      */
81     event ApprovalForAll(
82         address indexed owner,
83         address indexed operator,
84         bool approved
85     );
86 
87     /**
88      * @dev Returns the number of tokens in ``owner``'s account.
89      */
90     function balanceOf(address owner) external view returns (uint256 balance);
91 
92     /**
93      * @dev Returns the owner of the `tokenId` token.
94      *
95      * Requirements:
96      *
97      * - `tokenId` must exist.
98      */
99     function ownerOf(uint256 tokenId) external view returns (address owner);
100 
101     /**
102      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
103      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
104      *
105      * Requirements:
106      *
107      * - `from` cannot be the zero address.
108      * - `to` cannot be the zero address.
109      * - `tokenId` token must exist and be owned by `from`.
110      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
111      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
112      *
113      * Emits a {Transfer} event.
114      */
115     function safeTransferFrom(
116         address from,
117         address to,
118         uint256 tokenId
119     ) external;
120 
121     /**
122      * @dev Transfers `tokenId` token from `from` to `to`.
123      *
124      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
125      *
126      * Requirements:
127      *
128      * - `from` cannot be the zero address.
129      * - `to` cannot be the zero address.
130      * - `tokenId` token must be owned by `from`.
131      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
132      *
133      * Emits a {Transfer} event.
134      */
135     function transferFrom(
136         address from,
137         address to,
138         uint256 tokenId
139     ) external;
140 
141     /**
142      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
143      * The approval is cleared when the token is transferred.
144      *
145      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
146      *
147      * Requirements:
148      *
149      * - The caller must own the token or be an approved operator.
150      * - `tokenId` must exist.
151      *
152      * Emits an {Approval} event.
153      */
154     function approve(address to, uint256 tokenId) external;
155 
156     /**
157      * @dev Returns the account approved for `tokenId` token.
158      *
159      * Requirements:
160      *
161      * - `tokenId` must exist.
162      */
163     function getApproved(uint256 tokenId)
164         external
165         view
166         returns (address operator);
167 
168     /**
169      * @dev Approve or remove `operator` as an operator for the caller.
170      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
171      *
172      * Requirements:
173      *
174      * - The `operator` cannot be the caller.
175      *
176      * Emits an {ApprovalForAll} event.
177      */
178     function setApprovalForAll(address operator, bool _approved) external;
179 
180     /**
181      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
182      *
183      * See {setApprovalForAll}
184      */
185     function isApprovedForAll(address owner, address operator)
186         external
187         view
188         returns (bool);
189 
190     /**
191      * @dev Safely transfers `tokenId` token from `from` to `to`.
192      *
193      * Requirements:
194      *
195      * - `from` cannot be the zero address.
196      * - `to` cannot be the zero address.
197      * - `tokenId` token must exist and be owned by `from`.
198      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
199      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
200      *
201      * Emits a {Transfer} event.
202      */
203     function safeTransferFrom(
204         address from,
205         address to,
206         uint256 tokenId,
207         bytes calldata data
208     ) external;
209 }
210 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
211 pragma solidity >=0.6.2 <0.8.0;
212 
213 /**
214  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
215  * @dev See https://eips.ethereum.org/EIPS/eip-721
216  */
217 interface IERC721Metadata is IERC721 {
218     /**
219      * @dev Returns the token collection name.
220      */
221     function name() external view returns (string memory);
222 
223     /**
224      * @dev Returns the token collection symbol.
225      */
226     function symbol() external view returns (string memory);
227 
228     /**
229      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
230      */
231     function tokenURI(uint256 tokenId) external view returns (string memory);
232 }
233 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
234 pragma solidity >=0.6.2 <0.8.0;
235 
236 /**
237  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
238  * @dev See https://eips.ethereum.org/EIPS/eip-721
239  */
240 interface IERC721Enumerable is IERC721 {
241     /**
242      * @dev Returns the total amount of tokens stored by the contract.
243      */
244     function totalSupply() external view returns (uint256);
245 
246     /**
247      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
248      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
249      */
250     function tokenOfOwnerByIndex(address owner, uint256 index)
251         external
252         view
253         returns (uint256 tokenId);
254 
255     /**
256      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
257      * Use along with {totalSupply} to enumerate all tokens.
258      */
259     function tokenByIndex(uint256 index) external view returns (uint256);
260 }
261 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
262 pragma solidity >=0.6.0 <0.8.0;
263 
264 /**
265  * @title ERC721 token receiver interface
266  * @dev Interface for any contract that wants to support safeTransfers
267  * from ERC721 asset contracts.
268  */
269 interface IERC721Receiver {
270     /**
271      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
272      * by `operator` from `from`, this function is called.
273      *
274      * It must return its Solidity selector to confirm the token transfer.
275      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
276      *
277      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
278      */
279     function onERC721Received(
280         address operator,
281         address from,
282         uint256 tokenId,
283         bytes calldata data
284     ) external returns (bytes4);
285 }
286 // File: @openzeppelin/contracts/introspection/ERC165.sol
287 pragma solidity >=0.6.0 <0.8.0;
288 
289 /**
290  * @dev Implementation of the {IERC165} interface.
291  *
292  * Contracts may inherit from this and call {_registerInterface} to declare
293  * their support of an interface.
294  */
295 abstract contract ERC165 is IERC165 {
296     /*
297      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
298      */
299     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
300     /**
301      * @dev Mapping of interface ids to whether or not it's supported.
302      */
303     mapping(bytes4 => bool) private _supportedInterfaces;
304 
305     constructor() internal {
306         // Derived contracts need only register support for their own interfaces,
307         // we register support for ERC165 itself here
308         _registerInterface(_INTERFACE_ID_ERC165);
309     }
310 
311     /**
312      * @dev See {IERC165-supportsInterface}.
313      *
314      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
315      */
316     function supportsInterface(bytes4 interfaceId)
317         public
318         view
319         virtual
320         override
321         returns (bool)
322     {
323         return _supportedInterfaces[interfaceId];
324     }
325 
326     /**
327      * @dev Registers the contract as an implementer of the interface defined by
328      * `interfaceId`. Support of the actual ERC165 interface is automatic and
329      * registering its interface id is not required.
330      *
331      * See {IERC165-supportsInterface}.
332      *
333      * Requirements:
334      *
335      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
336      */
337     function _registerInterface(bytes4 interfaceId) internal virtual {
338         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
339         _supportedInterfaces[interfaceId] = true;
340     }
341 }
342 // File: @openzeppelin/contracts/math/SafeMath.sol
343 pragma solidity >=0.6.0 <0.8.0;
344 
345 /**
346  * @dev Wrappers over Solidity's arithmetic operations with added overflow
347  * checks.
348  *
349  * Arithmetic operations in Solidity wrap on overflow. This can easily result
350  * in bugs, because programmers usually assume that an overflow raises an
351  * error, which is the standard behavior in high level programming languages.
352  * `SafeMath` restores this intuition by reverting the transaction when an
353  * operation overflows.
354  *
355  * Using this library instead of the unchecked operations eliminates an entire
356  * class of bugs, so it's recommended to use it always.
357  */
358 library SafeMath {
359     /**
360      * @dev Returns the addition of two unsigned integers, with an overflow flag.
361      *
362      * _Available since v3.4._
363      */
364     function tryAdd(uint256 a, uint256 b)
365         internal
366         pure
367         returns (bool, uint256)
368     {
369         uint256 c = a + b;
370         if (c < a) return (false, 0);
371         return (true, c);
372     }
373 
374     /**
375      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
376      *
377      * _Available since v3.4._
378      */
379     function trySub(uint256 a, uint256 b)
380         internal
381         pure
382         returns (bool, uint256)
383     {
384         if (b > a) return (false, 0);
385         return (true, a - b);
386     }
387 
388     /**
389      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
390      *
391      * _Available since v3.4._
392      */
393     function tryMul(uint256 a, uint256 b)
394         internal
395         pure
396         returns (bool, uint256)
397     {
398         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
399         // benefit is lost if 'b' is also tested.
400         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
401         if (a == 0) return (true, 0);
402         uint256 c = a * b;
403         if (c / a != b) return (false, 0);
404         return (true, c);
405     }
406 
407     /**
408      * @dev Returns the division of two unsigned integers, with a division by zero flag.
409      *
410      * _Available since v3.4._
411      */
412     function tryDiv(uint256 a, uint256 b)
413         internal
414         pure
415         returns (bool, uint256)
416     {
417         if (b == 0) return (false, 0);
418         return (true, a / b);
419     }
420 
421     /**
422      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
423      *
424      * _Available since v3.4._
425      */
426     function tryMod(uint256 a, uint256 b)
427         internal
428         pure
429         returns (bool, uint256)
430     {
431         if (b == 0) return (false, 0);
432         return (true, a % b);
433     }
434 
435     /**
436      * @dev Returns the addition of two unsigned integers, reverting on
437      * overflow.
438      *
439      * Counterpart to Solidity's `+` operator.
440      *
441      * Requirements:
442      *
443      * - Addition cannot overflow.
444      */
445     function add(uint256 a, uint256 b) internal pure returns (uint256) {
446         uint256 c = a + b;
447         require(c >= a, "SafeMath: addition overflow");
448         return c;
449     }
450 
451     /**
452      * @dev Returns the subtraction of two unsigned integers, reverting on
453      * overflow (when the result is negative).
454      *
455      * Counterpart to Solidity's `-` operator.
456      *
457      * Requirements:
458      *
459      * - Subtraction cannot overflow.
460      */
461     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
462         require(b <= a, "SafeMath: subtraction overflow");
463         return a - b;
464     }
465 
466     /**
467      * @dev Returns the multiplication of two unsigned integers, reverting on
468      * overflow.
469      *
470      * Counterpart to Solidity's `*` operator.
471      *
472      * Requirements:
473      *
474      * - Multiplication cannot overflow.
475      */
476     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
477         if (a == 0) return 0;
478         uint256 c = a * b;
479         require(c / a == b, "SafeMath: multiplication overflow");
480         return c;
481     }
482 
483     /**
484      * @dev Returns the integer division of two unsigned integers, reverting on
485      * division by zero. The result is rounded towards zero.
486      *
487      * Counterpart to Solidity's `/` operator. Note: this function uses a
488      * `revert` opcode (which leaves remaining gas untouched) while Solidity
489      * uses an invalid opcode to revert (consuming all remaining gas).
490      *
491      * Requirements:
492      *
493      * - The divisor cannot be zero.
494      */
495     function div(uint256 a, uint256 b) internal pure returns (uint256) {
496         require(b > 0, "SafeMath: division by zero");
497         return a / b;
498     }
499 
500     /**
501      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
502      * reverting when dividing by zero.
503      *
504      * Counterpart to Solidity's `%` operator. This function uses a `revert`
505      * opcode (which leaves remaining gas untouched) while Solidity uses an
506      * invalid opcode to revert (consuming all remaining gas).
507      *
508      * Requirements:
509      *
510      * - The divisor cannot be zero.
511      */
512     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
513         require(b > 0, "SafeMath: modulo by zero");
514         return a % b;
515     }
516 
517     /**
518      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
519      * overflow (when the result is negative).
520      *
521      * CAUTION: This function is deprecated because it requires allocating memory for the error
522      * message unnecessarily. For custom revert reasons use {trySub}.
523      *
524      * Counterpart to Solidity's `-` operator.
525      *
526      * Requirements:
527      *
528      * - Subtraction cannot overflow.
529      */
530     function sub(
531         uint256 a,
532         uint256 b,
533         string memory errorMessage
534     ) internal pure returns (uint256) {
535         require(b <= a, errorMessage);
536         return a - b;
537     }
538 
539     /**
540      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
541      * division by zero. The result is rounded towards zero.
542      *
543      * CAUTION: This function is deprecated because it requires allocating memory for the error
544      * message unnecessarily. For custom revert reasons use {tryDiv}.
545      *
546      * Counterpart to Solidity's `/` operator. Note: this function uses a
547      * `revert` opcode (which leaves remaining gas untouched) while Solidity
548      * uses an invalid opcode to revert (consuming all remaining gas).
549      *
550      * Requirements:
551      *
552      * - The divisor cannot be zero.
553      */
554     function div(
555         uint256 a,
556         uint256 b,
557         string memory errorMessage
558     ) internal pure returns (uint256) {
559         require(b > 0, errorMessage);
560         return a / b;
561     }
562 
563     /**
564      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
565      * reverting with custom message when dividing by zero.
566      *
567      * CAUTION: This function is deprecated because it requires allocating memory for the error
568      * message unnecessarily. For custom revert reasons use {tryMod}.
569      *
570      * Counterpart to Solidity's `%` operator. This function uses a `revert`
571      * opcode (which leaves remaining gas untouched) while Solidity uses an
572      * invalid opcode to revert (consuming all remaining gas).
573      *
574      * Requirements:
575      *
576      * - The divisor cannot be zero.
577      */
578     function mod(
579         uint256 a,
580         uint256 b,
581         string memory errorMessage
582     ) internal pure returns (uint256) {
583         require(b > 0, errorMessage);
584         return a % b;
585     }
586 }
587 // File: @openzeppelin/contracts/utils/Address.sol
588 pragma solidity >=0.6.2 <0.8.0;
589 
590 /**
591  * @dev Collection of functions related to the address type
592  */
593 library Address {
594     /**
595      * @dev Returns true if `account` is a contract.
596      *
597      * [IMPORTANT]
598      * ====
599      * It is unsafe to assume that an address for which this function returns
600      * false is an externally-owned account (EOA) and not a contract.
601      *
602      * Among others, `isContract` will return false for the following
603      * types of addresses:
604      *
605      *  - an externally-owned account
606      *  - a contract in construction
607      *  - an address where a contract will be created
608      *  - an address where a contract lived, but was destroyed
609      * ====
610      */
611     function isContract(address account) internal view returns (bool) {
612         // This method relies on extcodesize, which returns 0 for contracts in
613         // construction, since the code is only stored at the end of the
614         // constructor execution.
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
733         // solhint-disable-next-line avoid-low-level-calls
734         (bool success, bytes memory returndata) = target.call{value: value}(
735             data
736         );
737         return _verifyCallResult(success, returndata, errorMessage);
738     }
739 
740     /**
741      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
742      * but performing a static call.
743      *
744      * _Available since v3.3._
745      */
746     function functionStaticCall(address target, bytes memory data)
747         internal
748         view
749         returns (bytes memory)
750     {
751         return
752             functionStaticCall(
753                 target,
754                 data,
755                 "Address: low-level static call failed"
756             );
757     }
758 
759     /**
760      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
761      * but performing a static call.
762      *
763      * _Available since v3.3._
764      */
765     function functionStaticCall(
766         address target,
767         bytes memory data,
768         string memory errorMessage
769     ) internal view returns (bytes memory) {
770         require(isContract(target), "Address: static call to non-contract");
771         // solhint-disable-next-line avoid-low-level-calls
772         (bool success, bytes memory returndata) = target.staticcall(data);
773         return _verifyCallResult(success, returndata, errorMessage);
774     }
775 
776     /**
777      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
778      * but performing a delegate call.
779      *
780      * _Available since v3.4._
781      */
782     function functionDelegateCall(address target, bytes memory data)
783         internal
784         returns (bytes memory)
785     {
786         return
787             functionDelegateCall(
788                 target,
789                 data,
790                 "Address: low-level delegate call failed"
791             );
792     }
793 
794     /**
795      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
796      * but performing a delegate call.
797      *
798      * _Available since v3.4._
799      */
800     function functionDelegateCall(
801         address target,
802         bytes memory data,
803         string memory errorMessage
804     ) internal returns (bytes memory) {
805         require(isContract(target), "Address: delegate call to non-contract");
806         // solhint-disable-next-line avoid-low-level-calls
807         (bool success, bytes memory returndata) = target.delegatecall(data);
808         return _verifyCallResult(success, returndata, errorMessage);
809     }
810 
811     function _verifyCallResult(
812         bool success,
813         bytes memory returndata,
814         string memory errorMessage
815     ) private pure returns (bytes memory) {
816         if (success) {
817             return returndata;
818         } else {
819             // Look for revert reason and bubble it up if present
820             if (returndata.length > 0) {
821                 // The easiest way to bubble the revert reason is using memory via assembly
822                 // solhint-disable-next-line no-inline-assembly
823                 assembly {
824                     let returndata_size := mload(returndata)
825                     revert(add(32, returndata), returndata_size)
826                 }
827             } else {
828                 revert(errorMessage);
829             }
830         }
831     }
832 }
833 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
834 pragma solidity >=0.6.0 <0.8.0;
835 
836 /**
837  * @dev Library for managing
838  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
839  * types.
840  *
841  * Sets have the following properties:
842  *
843  * - Elements are added, removed, and checked for existence in constant time
844  * (O(1)).
845  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
846  *
847  * ```
848  * contract Example {
849  *     // Add the library methods
850  *     using EnumerableSet for EnumerableSet.AddressSet;
851  *
852  *     // Declare a set state variable
853  *     EnumerableSet.AddressSet private mySet;
854  * }
855  * ```
856  *
857  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
858  * and `uint256` (`UintSet`) are supported.
859  */
860 library EnumerableSet {
861     // To implement this library for multiple types with as little code
862     // repetition as possible, we write it in terms of a generic Set type with
863     // bytes32 values.
864     // The Set implementation uses private functions, and user-facing
865     // implementations (such as AddressSet) are just wrappers around the
866     // underlying Set.
867     // This means that we can only create new EnumerableSets for types that fit
868     // in bytes32.
869     struct Set {
870         // Storage of set values
871         bytes32[] _values;
872         // Position of the value in the `values` array, plus 1 because index 0
873         // means a value is not in the set.
874         mapping(bytes32 => uint256) _indexes;
875     }
876 
877     /**
878      * @dev Add a value to a set. O(1).
879      *
880      * Returns true if the value was added to the set, that is if it was not
881      * already present.
882      */
883     function _add(Set storage set, bytes32 value) private returns (bool) {
884         if (!_contains(set, value)) {
885             set._values.push(value);
886             // The value is stored at length-1, but we add 1 to all indexes
887             // and use 0 as a sentinel value
888             set._indexes[value] = set._values.length;
889             return true;
890         } else {
891             return false;
892         }
893     }
894 
895     /**
896      * @dev Removes a value from a set. O(1).
897      *
898      * Returns true if the value was removed from the set, that is if it was
899      * present.
900      */
901     function _remove(Set storage set, bytes32 value) private returns (bool) {
902         // We read and store the value's index to prevent multiple reads from the same storage slot
903         uint256 valueIndex = set._indexes[value];
904         if (valueIndex != 0) {
905             // Equivalent to contains(set, value)
906             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
907             // the array, and then remove the last element (sometimes called as 'swap and pop').
908             // This modifies the order of the array, as noted in {at}.
909             uint256 toDeleteIndex = valueIndex - 1;
910             uint256 lastIndex = set._values.length - 1;
911             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
912             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
913             bytes32 lastvalue = set._values[lastIndex];
914             // Move the last value to the index where the value to delete is
915             set._values[toDeleteIndex] = lastvalue;
916             // Update the index for the moved value
917             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
918             // Delete the slot where the moved value was stored
919             set._values.pop();
920             // Delete the index for the deleted slot
921             delete set._indexes[value];
922             return true;
923         } else {
924             return false;
925         }
926     }
927 
928     /**
929      * @dev Returns true if the value is in the set. O(1).
930      */
931     function _contains(Set storage set, bytes32 value)
932         private
933         view
934         returns (bool)
935     {
936         return set._indexes[value] != 0;
937     }
938 
939     /**
940      * @dev Returns the number of values on the set. O(1).
941      */
942     function _length(Set storage set) private view returns (uint256) {
943         return set._values.length;
944     }
945 
946     /**
947      * @dev Returns the value stored at position `index` in the set. O(1).
948      *
949      * Note that there are no guarantees on the ordering of values inside the
950      * array, and it may change when more values are added or removed.
951      *
952      * Requirements:
953      *
954      * - `index` must be strictly less than {length}.
955      */
956     function _at(Set storage set, uint256 index)
957         private
958         view
959         returns (bytes32)
960     {
961         require(
962             set._values.length > index,
963             "EnumerableSet: index out of bounds"
964         );
965         return set._values[index];
966     }
967 
968     // Bytes32Set
969     struct Bytes32Set {
970         Set _inner;
971     }
972 
973     /**
974      * @dev Add a value to a set. O(1).
975      *
976      * Returns true if the value was added to the set, that is if it was not
977      * already present.
978      */
979     function add(Bytes32Set storage set, bytes32 value)
980         internal
981         returns (bool)
982     {
983         return _add(set._inner, value);
984     }
985 
986     /**
987      * @dev Removes a value from a set. O(1).
988      *
989      * Returns true if the value was removed from the set, that is if it was
990      * present.
991      */
992     function remove(Bytes32Set storage set, bytes32 value)
993         internal
994         returns (bool)
995     {
996         return _remove(set._inner, value);
997     }
998 
999     /**
1000      * @dev Returns true if the value is in the set. O(1).
1001      */
1002     function contains(Bytes32Set storage set, bytes32 value)
1003         internal
1004         view
1005         returns (bool)
1006     {
1007         return _contains(set._inner, value);
1008     }
1009 
1010     /**
1011      * @dev Returns the number of values in the set. O(1).
1012      */
1013     function length(Bytes32Set storage set) internal view returns (uint256) {
1014         return _length(set._inner);
1015     }
1016 
1017     /**
1018      * @dev Returns the value stored at position `index` in the set. O(1).
1019      *
1020      * Note that there are no guarantees on the ordering of values inside the
1021      * array, and it may change when more values are added or removed.
1022      *
1023      * Requirements:
1024      *
1025      * - `index` must be strictly less than {length}.
1026      */
1027     function at(Bytes32Set storage set, uint256 index)
1028         internal
1029         view
1030         returns (bytes32)
1031     {
1032         return _at(set._inner, index);
1033     }
1034 
1035     // AddressSet
1036     struct AddressSet {
1037         Set _inner;
1038     }
1039 
1040     /**
1041      * @dev Add a value to a set. O(1).
1042      *
1043      * Returns true if the value was added to the set, that is if it was not
1044      * already present.
1045      */
1046     function add(AddressSet storage set, address value)
1047         internal
1048         returns (bool)
1049     {
1050         return _add(set._inner, bytes32(uint256(uint160(value))));
1051     }
1052 
1053     /**
1054      * @dev Removes a value from a set. O(1).
1055      *
1056      * Returns true if the value was removed from the set, that is if it was
1057      * present.
1058      */
1059     function remove(AddressSet storage set, address value)
1060         internal
1061         returns (bool)
1062     {
1063         return _remove(set._inner, bytes32(uint256(uint160(value))));
1064     }
1065 
1066     /**
1067      * @dev Returns true if the value is in the set. O(1).
1068      */
1069     function contains(AddressSet storage set, address value)
1070         internal
1071         view
1072         returns (bool)
1073     {
1074         return _contains(set._inner, bytes32(uint256(uint160(value))));
1075     }
1076 
1077     /**
1078      * @dev Returns the number of values in the set. O(1).
1079      */
1080     function length(AddressSet storage set) internal view returns (uint256) {
1081         return _length(set._inner);
1082     }
1083 
1084     /**
1085      * @dev Returns the value stored at position `index` in the set. O(1).
1086      *
1087      * Note that there are no guarantees on the ordering of values inside the
1088      * array, and it may change when more values are added or removed.
1089      *
1090      * Requirements:
1091      *
1092      * - `index` must be strictly less than {length}.
1093      */
1094     function at(AddressSet storage set, uint256 index)
1095         internal
1096         view
1097         returns (address)
1098     {
1099         return address(uint160(uint256(_at(set._inner, index))));
1100     }
1101 
1102     // UintSet
1103     struct UintSet {
1104         Set _inner;
1105     }
1106 
1107     /**
1108      * @dev Add a value to a set. O(1).
1109      *
1110      * Returns true if the value was added to the set, that is if it was not
1111      * already present.
1112      */
1113     function add(UintSet storage set, uint256 value) internal returns (bool) {
1114         return _add(set._inner, bytes32(value));
1115     }
1116 
1117     /**
1118      * @dev Removes a value from a set. O(1).
1119      *
1120      * Returns true if the value was removed from the set, that is if it was
1121      * present.
1122      */
1123     function remove(UintSet storage set, uint256 value)
1124         internal
1125         returns (bool)
1126     {
1127         return _remove(set._inner, bytes32(value));
1128     }
1129 
1130     /**
1131      * @dev Returns true if the value is in the set. O(1).
1132      */
1133     function contains(UintSet storage set, uint256 value)
1134         internal
1135         view
1136         returns (bool)
1137     {
1138         return _contains(set._inner, bytes32(value));
1139     }
1140 
1141     /**
1142      * @dev Returns the number of values on the set. O(1).
1143      */
1144     function length(UintSet storage set) internal view returns (uint256) {
1145         return _length(set._inner);
1146     }
1147 
1148     /**
1149      * @dev Returns the value stored at position `index` in the set. O(1).
1150      *
1151      * Note that there are no guarantees on the ordering of values inside the
1152      * array, and it may change when more values are added or removed.
1153      *
1154      * Requirements:
1155      *
1156      * - `index` must be strictly less than {length}.
1157      */
1158     function at(UintSet storage set, uint256 index)
1159         internal
1160         view
1161         returns (uint256)
1162     {
1163         return uint256(_at(set._inner, index));
1164     }
1165 }
1166 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1167 pragma solidity >=0.6.0 <0.8.0;
1168 
1169 /**
1170  * @dev Library for managing an enumerable variant of Solidity's
1171  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1172  * type.
1173  *
1174  * Maps have the following properties:
1175  *
1176  * - Entries are added, removed, and checked for existence in constant time
1177  * (O(1)).
1178  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1179  *
1180  * ```
1181  * contract Example {
1182  *     // Add the library methods
1183  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1184  *
1185  *     // Declare a set state variable
1186  *     EnumerableMap.UintToAddressMap private myMap;
1187  * }
1188  * ```
1189  *
1190  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1191  * supported.
1192  */
1193 library EnumerableMap {
1194     // To implement this library for multiple types with as little code
1195     // repetition as possible, we write it in terms of a generic Map type with
1196     // bytes32 keys and values.
1197     // The Map implementation uses private functions, and user-facing
1198     // implementations (such as Uint256ToAddressMap) are just wrappers around
1199     // the underlying Map.
1200     // This means that we can only create new EnumerableMaps for types that fit
1201     // in bytes32.
1202     struct MapEntry {
1203         bytes32 _key;
1204         bytes32 _value;
1205     }
1206     struct Map {
1207         // Storage of map keys and values
1208         MapEntry[] _entries;
1209         // Position of the entry defined by a key in the `entries` array, plus 1
1210         // because index 0 means a key is not in the map.
1211         mapping(bytes32 => uint256) _indexes;
1212     }
1213 
1214     /**
1215      * @dev Adds a key-value pair to a map, or updates the value for an existing
1216      * key. O(1).
1217      *
1218      * Returns true if the key was added to the map, that is if it was not
1219      * already present.
1220      */
1221     function _set(
1222         Map storage map,
1223         bytes32 key,
1224         bytes32 value
1225     ) private returns (bool) {
1226         // We read and store the key's index to prevent multiple reads from the same storage slot
1227         uint256 keyIndex = map._indexes[key];
1228         if (keyIndex == 0) {
1229             // Equivalent to !contains(map, key)
1230             map._entries.push(MapEntry({_key: key, _value: value}));
1231             // The entry is stored at length-1, but we add 1 to all indexes
1232             // and use 0 as a sentinel value
1233             map._indexes[key] = map._entries.length;
1234             return true;
1235         } else {
1236             map._entries[keyIndex - 1]._value = value;
1237             return false;
1238         }
1239     }
1240 
1241     /**
1242      * @dev Removes a key-value pair from a map. O(1).
1243      *
1244      * Returns true if the key was removed from the map, that is if it was present.
1245      */
1246     function _remove(Map storage map, bytes32 key) private returns (bool) {
1247         // We read and store the key's index to prevent multiple reads from the same storage slot
1248         uint256 keyIndex = map._indexes[key];
1249         if (keyIndex != 0) {
1250             // Equivalent to contains(map, key)
1251             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1252             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1253             // This modifies the order of the array, as noted in {at}.
1254             uint256 toDeleteIndex = keyIndex - 1;
1255             uint256 lastIndex = map._entries.length - 1;
1256             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1257             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1258             MapEntry storage lastEntry = map._entries[lastIndex];
1259             // Move the last entry to the index where the entry to delete is
1260             map._entries[toDeleteIndex] = lastEntry;
1261             // Update the index for the moved entry
1262             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1263             // Delete the slot where the moved entry was stored
1264             map._entries.pop();
1265             // Delete the index for the deleted slot
1266             delete map._indexes[key];
1267             return true;
1268         } else {
1269             return false;
1270         }
1271     }
1272 
1273     /**
1274      * @dev Returns true if the key is in the map. O(1).
1275      */
1276     function _contains(Map storage map, bytes32 key)
1277         private
1278         view
1279         returns (bool)
1280     {
1281         return map._indexes[key] != 0;
1282     }
1283 
1284     /**
1285      * @dev Returns the number of key-value pairs in the map. O(1).
1286      */
1287     function _length(Map storage map) private view returns (uint256) {
1288         return map._entries.length;
1289     }
1290 
1291     /**
1292      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1293      *
1294      * Note that there are no guarantees on the ordering of entries inside the
1295      * array, and it may change when more entries are added or removed.
1296      *
1297      * Requirements:
1298      *
1299      * - `index` must be strictly less than {length}.
1300      */
1301     function _at(Map storage map, uint256 index)
1302         private
1303         view
1304         returns (bytes32, bytes32)
1305     {
1306         require(
1307             map._entries.length > index,
1308             "EnumerableMap: index out of bounds"
1309         );
1310         MapEntry storage entry = map._entries[index];
1311         return (entry._key, entry._value);
1312     }
1313 
1314     /**
1315      * @dev Tries to returns the value associated with `key`.  O(1).
1316      * Does not revert if `key` is not in the map.
1317      */
1318     function _tryGet(Map storage map, bytes32 key)
1319         private
1320         view
1321         returns (bool, bytes32)
1322     {
1323         uint256 keyIndex = map._indexes[key];
1324         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1325         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1326     }
1327 
1328     /**
1329      * @dev Returns the value associated with `key`.  O(1).
1330      *
1331      * Requirements:
1332      *
1333      * - `key` must be in the map.
1334      */
1335     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1336         uint256 keyIndex = map._indexes[key];
1337         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1338         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1339     }
1340 
1341     /**
1342      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1343      *
1344      * CAUTION: This function is deprecated because it requires allocating memory for the error
1345      * message unnecessarily. For custom revert reasons use {_tryGet}.
1346      */
1347     function _get(
1348         Map storage map,
1349         bytes32 key,
1350         string memory errorMessage
1351     ) private view returns (bytes32) {
1352         uint256 keyIndex = map._indexes[key];
1353         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1354         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1355     }
1356 
1357     // UintToAddressMap
1358     struct UintToAddressMap {
1359         Map _inner;
1360     }
1361 
1362     /**
1363      * @dev Adds a key-value pair to a map, or updates the value for an existing
1364      * key. O(1).
1365      *
1366      * Returns true if the key was added to the map, that is if it was not
1367      * already present.
1368      */
1369     function set(
1370         UintToAddressMap storage map,
1371         uint256 key,
1372         address value
1373     ) internal returns (bool) {
1374         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1375     }
1376 
1377     /**
1378      * @dev Removes a value from a set. O(1).
1379      *
1380      * Returns true if the key was removed from the map, that is if it was present.
1381      */
1382     function remove(UintToAddressMap storage map, uint256 key)
1383         internal
1384         returns (bool)
1385     {
1386         return _remove(map._inner, bytes32(key));
1387     }
1388 
1389     /**
1390      * @dev Returns true if the key is in the map. O(1).
1391      */
1392     function contains(UintToAddressMap storage map, uint256 key)
1393         internal
1394         view
1395         returns (bool)
1396     {
1397         return _contains(map._inner, bytes32(key));
1398     }
1399 
1400     /**
1401      * @dev Returns the number of elements in the map. O(1).
1402      */
1403     function length(UintToAddressMap storage map)
1404         internal
1405         view
1406         returns (uint256)
1407     {
1408         return _length(map._inner);
1409     }
1410 
1411     /**
1412      * @dev Returns the element stored at position `index` in the set. O(1).
1413      * Note that there are no guarantees on the ordering of values inside the
1414      * array, and it may change when more values are added or removed.
1415      *
1416      * Requirements:
1417      *
1418      * - `index` must be strictly less than {length}.
1419      */
1420     function at(UintToAddressMap storage map, uint256 index)
1421         internal
1422         view
1423         returns (uint256, address)
1424     {
1425         (bytes32 key, bytes32 value) = _at(map._inner, index);
1426         return (uint256(key), address(uint160(uint256(value))));
1427     }
1428 
1429     /**
1430      * @dev Tries to returns the value associated with `key`.  O(1).
1431      * Does not revert if `key` is not in the map.
1432      *
1433      * _Available since v3.4._
1434      */
1435     function tryGet(UintToAddressMap storage map, uint256 key)
1436         internal
1437         view
1438         returns (bool, address)
1439     {
1440         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1441         return (success, address(uint160(uint256(value))));
1442     }
1443 
1444     /**
1445      * @dev Returns the value associated with `key`.  O(1).
1446      *
1447      * Requirements:
1448      *
1449      * - `key` must be in the map.
1450      */
1451     function get(UintToAddressMap storage map, uint256 key)
1452         internal
1453         view
1454         returns (address)
1455     {
1456         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1457     }
1458 
1459     /**
1460      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1461      *
1462      * CAUTION: This function is deprecated because it requires allocating memory for the error
1463      * message unnecessarily. For custom revert reasons use {tryGet}.
1464      */
1465     function get(
1466         UintToAddressMap storage map,
1467         uint256 key,
1468         string memory errorMessage
1469     ) internal view returns (address) {
1470         return
1471             address(
1472                 uint160(uint256(_get(map._inner, bytes32(key), errorMessage)))
1473             );
1474     }
1475 }
1476 // File: @openzeppelin/contracts/utils/Strings.sol
1477 pragma solidity >=0.6.0 <0.8.0;
1478 
1479 /**
1480  * @dev String operations.
1481  */
1482 library Strings {
1483     /**
1484      * @dev Converts a `uint256` to its ASCII `string` representation.
1485      */
1486     function toString(uint256 value) internal pure returns (string memory) {
1487         // Inspired by OraclizeAPI's implementation - MIT licence
1488         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1489         if (value == 0) {
1490             return "0";
1491         }
1492         uint256 temp = value;
1493         uint256 digits;
1494         while (temp != 0) {
1495             digits++;
1496             temp /= 10;
1497         }
1498         bytes memory buffer = new bytes(digits);
1499         uint256 index = digits - 1;
1500         temp = value;
1501         while (temp != 0) {
1502             buffer[index--] = bytes1(uint8(48 + (temp % 10)));
1503             temp /= 10;
1504         }
1505         return string(buffer);
1506     }
1507 }
1508 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1509 pragma solidity >=0.6.0 <0.8.0;
1510 
1511 /**
1512  * @title ERC721 Non-Fungible Token Standard basic implementation
1513  * @dev see https://eips.ethereum.org/EIPS/eip-721
1514  */
1515 contract ERC721 is
1516     Context,
1517     ERC165,
1518     IERC721,
1519     IERC721Metadata,
1520     IERC721Enumerable
1521 {
1522     using SafeMath for uint256;
1523     using Address for address;
1524     using EnumerableSet for EnumerableSet.UintSet;
1525     using EnumerableMap for EnumerableMap.UintToAddressMap;
1526     using Strings for uint256;
1527     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1528     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1529     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1530     // Mapping from holder address to their (enumerable) set of owned tokens
1531     mapping(address => EnumerableSet.UintSet) private _holderTokens;
1532     mapping(address => EnumerableSet.UintSet) private _vipHolders;
1533     mapping(address => EnumerableSet.UintSet) private _svipHolders;
1534     mapping(address => EnumerableSet.UintSet) private _commonHolders;
1535     // Mapping from token ID to token type
1536     //mapping (uint256 => string) private _tokenType;
1537     mapping(uint256 => uint256) private _tokenType;
1538     uint256 private _svipType = 0;
1539     uint256 private _vipType = 1;
1540     uint256 private _commonType = 2;
1541     // Enumerable mapping from token ids to their owners
1542     EnumerableMap.UintToAddressMap private _tokenOwners;
1543     // Mapping from token ID to approved address
1544     mapping(uint256 => address) private _tokenApprovals;
1545     // Mapping from owner to operator approvals
1546     mapping(address => mapping(address => bool)) private _operatorApprovals;
1547     // Token name
1548     string private _name;
1549     // Token symbol
1550     string private _symbol;
1551     // Optional mapping for token URIs
1552     mapping(uint256 => string) private _tokenURIs;
1553     // Base URI
1554     string private _baseURI;
1555 
1556     uint32 constant SVIP = 0;
1557     uint32 constant VIP = 1;
1558     uint32 constant COMMON = 2;
1559     /*
1560      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1561      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1562      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1563      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1564      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1565      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1566      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1567      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1568      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1569      *
1570      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1571      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1572      */
1573     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1574     /*
1575      *     bytes4(keccak256('name()')) == 0x06fdde03
1576      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1577      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1578      *
1579      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1580      */
1581     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1582     /*
1583      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1584      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1585      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1586      *
1587      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1588      */
1589     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1590 
1591     /**
1592      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1593      */
1594     constructor(string memory name_, string memory symbol_) public {
1595         _name = name_;
1596         _symbol = symbol_;
1597         // register the supported interfaces to conform to ERC721 via ERC165
1598         _registerInterface(_INTERFACE_ID_ERC721);
1599         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1600         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1601     }
1602 
1603     /**
1604      *     0  svip
1605      *     1  vip
1606      *     2  common(free)
1607      */
1608     function roleOfTokenId(uint256 tokenId)
1609         public
1610         view
1611         virtual
1612         returns (uint256)
1613     {
1614         require(_exists(tokenId), "nonexistent token");
1615         return _tokenType[tokenId];
1616     }
1617 
1618     /**
1619      * @dev See {IERC721-balanceOf}.
1620      */
1621     function balanceOf(address owner)
1622         public
1623         view
1624         virtual
1625         override
1626         returns (uint256)
1627     {
1628         require(
1629             owner != address(0),
1630             "ERC721: balance query for the zero address"
1631         );
1632         return _holderTokens[owner].length();
1633     }
1634 
1635     function svipBalanceOf(address owner)
1636         public
1637         view
1638         virtual
1639         returns (uint256)
1640     {
1641         require(
1642             owner != address(0),
1643             "ERC721: balance query for the zero address"
1644         );
1645         return _svipHolders[owner].length();
1646     }
1647 
1648     function vipBalanceOf(address owner) public view virtual returns (uint256) {
1649         require(
1650             owner != address(0),
1651             "ERC721: balance query for the zero address"
1652         );
1653         return _vipHolders[owner].length();
1654     }
1655 
1656     function commonBalanceOf(address owner)
1657         public
1658         view
1659         virtual
1660         returns (uint256)
1661     {
1662         require(
1663             owner != address(0),
1664             "ERC721: balance query for the zero address"
1665         );
1666         return _commonHolders[owner].length();
1667     }
1668 
1669     /**
1670      * @dev See {IERC721-ownerOf}.
1671      */
1672     function ownerOf(uint256 tokenId)
1673         public
1674         view
1675         virtual
1676         override
1677         returns (address)
1678     {
1679         return
1680             _tokenOwners.get(
1681                 tokenId,
1682                 "ERC721: owner query for nonexistent token"
1683             );
1684     }
1685 
1686     /**
1687      * @dev See {IERC721Metadata-name}.
1688      */
1689     function name() public view virtual override returns (string memory) {
1690         return _name;
1691     }
1692 
1693     /**
1694      * @dev See {IERC721Metadata-symbol}.
1695      */
1696     function symbol() public view virtual override returns (string memory) {
1697         return _symbol;
1698     }
1699 
1700     /**
1701      * @dev See {IERC721Metadata-tokenURI}.
1702      */
1703     function tokenURI(uint256 tokenId)
1704         public
1705         view
1706         virtual
1707         override
1708         returns (string memory)
1709     {
1710         require(
1711             _exists(tokenId),
1712             "ERC721Metadata: URI query for nonexistent token"
1713         );
1714         string memory _tokenURI = _tokenURIs[tokenId];
1715         string memory base = baseURI();
1716         // If there is no base URI, return the token URI.
1717         if (bytes(base).length == 0) {
1718             return _tokenURI;
1719         }
1720         // If both are set, return the token URI.
1721         if (bytes(_tokenURI).length > 0) {
1722             return string(_tokenURI);
1723         }
1724 
1725         // If there is a baseURI but no tokenURI, concatenate the tokenId to the baseURI.
1726         return string(abi.encodePacked(base, tokenId.toString()));
1727     }
1728 
1729     /**
1730      * @dev Returns the base URI set via {_setBaseURI}. This will be
1731      * automatically added as a prefix in {tokenURI} to each token's URI, or
1732      * to the token ID if no specific URI is set for that token ID.
1733      */
1734     function baseURI() public view virtual returns (string memory) {
1735         return _baseURI;
1736     }
1737 
1738     /**
1739      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1740      */
1741     function tokenOfOwnerByIndex(address owner, uint256 index)
1742         public
1743         view
1744         virtual
1745         override
1746         returns (uint256)
1747     {
1748         return _holderTokens[owner].at(index);
1749     }
1750 
1751     function svipTokenOfOwnerByIndex(address owner, uint256 index)
1752         public
1753         view
1754         returns (uint256)
1755     {
1756         return _svipHolders[owner].at(index);
1757     }
1758 
1759     function vipTokenOfOwnerByIndex(address owner, uint256 index)
1760         public
1761         view
1762         returns (uint256)
1763     {
1764         return _vipHolders[owner].at(index);
1765     }
1766 
1767     function commonTokenOfOwnerByIndex(address owner, uint256 index)
1768         public
1769         view
1770         returns (uint256)
1771     {
1772         return _commonHolders[owner].at(index);
1773     }
1774 
1775     /**
1776      * @dev See {IERC721Enumerable-totalSupply}.
1777      */
1778     function totalSupply() public view virtual override returns (uint256) {
1779         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1780         return _tokenOwners.length();
1781     }
1782 
1783     /**
1784      * @dev See {IERC721Enumerable-tokenByIndex}.
1785      */
1786     function tokenByIndex(uint256 index)
1787         public
1788         view
1789         virtual
1790         override
1791         returns (uint256)
1792     {
1793         (uint256 tokenId, ) = _tokenOwners.at(index);
1794         return tokenId;
1795     }
1796 
1797     /**
1798      * @dev See {IERC721-approve}.
1799      */
1800     function approve(address to, uint256 tokenId) public virtual override {
1801         address owner = ERC721.ownerOf(tokenId);
1802         require(to != owner, "ERC721: approval to current owner");
1803         require(
1804             _msgSender() == owner ||
1805                 ERC721.isApprovedForAll(owner, _msgSender()),
1806             "ERC721: approve caller is not owner nor approved for all"
1807         );
1808         _approve(to, tokenId);
1809     }
1810 
1811     /**
1812      * @dev See {IERC721-getApproved}.
1813      */
1814     function getApproved(uint256 tokenId)
1815         public
1816         view
1817         virtual
1818         override
1819         returns (address)
1820     {
1821         require(
1822             _exists(tokenId),
1823             "ERC721: approved query for nonexistent token"
1824         );
1825         return _tokenApprovals[tokenId];
1826     }
1827 
1828     /**
1829      * @dev See {IERC721-setApprovalForAll}.
1830      */
1831     function setApprovalForAll(address operator, bool approved)
1832         public
1833         virtual
1834         override
1835     {
1836         require(operator != _msgSender(), "ERC721: approve to caller");
1837         _operatorApprovals[_msgSender()][operator] = approved;
1838         emit ApprovalForAll(_msgSender(), operator, approved);
1839     }
1840 
1841     /**
1842      * @dev See {IERC721-isApprovedForAll}.
1843      */
1844     function isApprovedForAll(address owner, address operator)
1845         public
1846         view
1847         virtual
1848         override
1849         returns (bool)
1850     {
1851         return _operatorApprovals[owner][operator];
1852     }
1853 
1854     /**
1855      * @dev See {IERC721-transferFrom}.
1856      */
1857     function transferFrom(
1858         address from,
1859         address to,
1860         uint256 tokenId
1861     ) public virtual override {
1862         //solhint-disable-next-line max-line-length
1863         require(
1864             _isApprovedOrOwner(_msgSender(), tokenId),
1865             "ERC721: transfer caller is not owner nor approved"
1866         );
1867         _transfer(from, to, tokenId);
1868     }
1869 
1870     /**
1871      * @dev See {IERC721-safeTransferFrom}.
1872      */
1873     function safeTransferFrom(
1874         address from,
1875         address to,
1876         uint256 tokenId
1877     ) public virtual override {
1878         safeTransferFrom(from, to, tokenId, "");
1879     }
1880 
1881     /**
1882      * @dev See {IERC721-safeTransferFrom}.
1883      */
1884     function safeTransferFrom(
1885         address from,
1886         address to,
1887         uint256 tokenId,
1888         bytes memory _data
1889     ) public virtual override {
1890         require(
1891             _isApprovedOrOwner(_msgSender(), tokenId),
1892             "ERC721: transfer caller is not owner nor approved"
1893         );
1894         _safeTransfer(from, to, tokenId, _data);
1895     }
1896 
1897     /**
1898      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1899      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1900      *
1901      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1902      *
1903      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1904      * implement alternative mechanisms to perform token transfer, such as signature-based.
1905      *
1906      * Requirements:
1907      *
1908      * - `from` cannot be the zero address.
1909      * - `to` cannot be the zero address.
1910      * - `tokenId` token must exist and be owned by `from`.
1911      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1912      *
1913      * Emits a {Transfer} event.
1914      */
1915     function _safeTransfer(
1916         address from,
1917         address to,
1918         uint256 tokenId,
1919         bytes memory _data
1920     ) internal virtual {
1921         _transfer(from, to, tokenId);
1922         require(
1923             _checkOnERC721Received(from, to, tokenId, _data),
1924             "ERC721: transfer to non ERC721Receiver implementer"
1925         );
1926     }
1927 
1928     /**
1929      * @dev Returns whether `tokenId` exists.
1930      *
1931      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1932      *
1933      * Tokens start existing when they are minted (`_mint`),
1934      * and stop existing when they are burned (`_burn`).
1935      */
1936     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1937         return _tokenOwners.contains(tokenId);
1938     }
1939 
1940     /**
1941      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1942      *
1943      * Requirements:
1944      *
1945      * - `tokenId` must exist.
1946      */
1947     function _isApprovedOrOwner(address spender, uint256 tokenId)
1948         internal
1949         view
1950         virtual
1951         returns (bool)
1952     {
1953         require(
1954             _exists(tokenId),
1955             "ERC721: operator query for nonexistent token"
1956         );
1957         address owner = ERC721.ownerOf(tokenId);
1958         return (spender == owner ||
1959             getApproved(tokenId) == spender ||
1960             ERC721.isApprovedForAll(owner, spender));
1961     }
1962 
1963     /**
1964      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1965      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1966      */
1967     function _safeMint(
1968         address to,
1969         uint256 tokenId,
1970         bytes memory _data
1971     ) internal virtual {
1972         require(
1973             _checkOnERC721Received(address(0), to, tokenId, _data),
1974             "ERC721: transfer to non ERC721Receiver implementer"
1975         );
1976         _mint(to, tokenId, _data);
1977     }
1978 
1979     function isEqual(string memory a, string memory b)
1980         public
1981         pure
1982         returns (bool)
1983     {
1984         bytes memory aa = bytes(a);
1985         bytes memory bb = bytes(b);
1986         if (aa.length != bb.length) return false;
1987         for (uint256 i = 0; i < aa.length; i++) {
1988             if (aa[i] != bb[i]) return false;
1989         }
1990         return true;
1991     }
1992 
1993     function _mint(
1994         address to,
1995         uint256 tokenId,
1996         bytes memory _data
1997     ) internal virtual {
1998         require(to != address(0), "ERC721: mint to the zero address");
1999         require(!_exists(tokenId), "ERC721: token already minted");
2000         _beforeTokenTransfer(address(0), to, tokenId);
2001         _holderTokens[to].add(tokenId);
2002         _tokenOwners.set(tokenId, to);
2003         if (isEqual(string(_data), "svip")) {
2004             _tokenType[tokenId] = _svipType;
2005             _svipHolders[to].add(tokenId);
2006         } else if (isEqual(string(_data), "vip")) {
2007             _tokenType[tokenId] = _vipType;
2008             _vipHolders[to].add(tokenId);
2009         } else if (isEqual(string(_data), "common")) {
2010             _commonHolders[to].add(tokenId);
2011             _tokenType[tokenId] = _commonType;
2012         }
2013         emit Transfer(address(0), to, tokenId);
2014     }
2015 
2016     /**
2017      * @dev Destroys `tokenId`.
2018      * The approval is cleared when the token is burned.
2019      *
2020      * Requirements:
2021      *
2022      * - `tokenId` must exist.
2023      *
2024      * Emits a {Transfer} event.
2025      */
2026     function _burn(uint256 tokenId) internal virtual {
2027         address owner = ERC721.ownerOf(tokenId); // internal owner
2028         _beforeTokenTransfer(owner, address(0), tokenId);
2029         // Clear approvals
2030         _approve(address(0), tokenId);
2031         // Clear metadata (if any)
2032         if (bytes(_tokenURIs[tokenId]).length != 0) {
2033             delete _tokenURIs[tokenId];
2034         }
2035         _holderTokens[owner].remove(tokenId);
2036         _tokenOwners.remove(tokenId);
2037         //todo
2038         if (_tokenType[tokenId] == _svipType) {
2039             _svipHolders[owner].remove(tokenId);
2040         } else if (_tokenType[tokenId] == _vipType) {
2041             _vipHolders[owner].remove(tokenId);
2042         } else if (_tokenType[tokenId] == _commonType) {
2043             _commonHolders[owner].remove(tokenId);
2044         }
2045         emit Transfer(owner, address(0), tokenId);
2046     }
2047 
2048     /**
2049      * @dev Transfers `tokenId` from `from` to `to`.
2050      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2051      *
2052      * Requirements:
2053      *
2054      * - `to` cannot be the zero address.
2055      * - `tokenId` token must be owned by `from`.
2056      *
2057      * Emits a {Transfer} event.
2058      */
2059     function _transfer(
2060         address from,
2061         address to,
2062         uint256 tokenId
2063     ) internal virtual {
2064         require(
2065             ERC721.ownerOf(tokenId) == from,
2066             "ERC721: transfer of token that is not own"
2067         ); // internal owner
2068         require(to != address(0), "ERC721: transfer to the zero address");
2069         _beforeTokenTransfer(from, to, tokenId);
2070         // Clear approvals from the previous owner
2071         _approve(address(0), tokenId);
2072         _holderTokens[from].remove(tokenId);
2073         _holderTokens[to].add(tokenId);
2074         if (_tokenType[tokenId] == _svipType) {
2075             _svipHolders[from].remove(tokenId);
2076             _svipHolders[to].add(tokenId);
2077         } else if (_tokenType[tokenId] == _vipType) {
2078             _vipHolders[from].remove(tokenId);
2079             _vipHolders[to].add(tokenId);
2080         } else if (_tokenType[tokenId] == _commonType) {
2081             _commonHolders[from].remove(tokenId);
2082             _commonHolders[to].add(tokenId);
2083         }
2084         _tokenOwners.set(tokenId, to);
2085         emit Transfer(from, to, tokenId);
2086     }
2087 
2088     /**
2089      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
2090      *
2091      * Requirements:
2092      *
2093      * - `tokenId` must exist.
2094      */
2095     function _setTokenURI(uint256 tokenId, string memory _tokenURI)
2096         internal
2097         virtual
2098     {
2099         require(
2100             _exists(tokenId),
2101             "ERC721Metadata: URI set of nonexistent token"
2102         );
2103         _tokenURIs[tokenId] = _tokenURI;
2104     }
2105 
2106     /**
2107      * @dev Internal function to set the base URI for all token IDs. It is
2108      * automatically added as a prefix to the value returned in {tokenURI},
2109      * or to the token ID if {tokenURI} is empty.
2110      */
2111     function _setBaseURI(string memory baseURI_) internal virtual {
2112         _baseURI = baseURI_;
2113     }
2114 
2115     /**
2116      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2117      * The call is not executed if the target address is not a contract.
2118      *
2119      * @param from address representing the previous owner of the given token ID
2120      * @param to target address that will receive the tokens
2121      * @param tokenId uint256 ID of the token to be transferred
2122      * @param _data bytes optional data to send along with the call
2123      * @return bool whether the call correctly returned the expected magic value
2124      */
2125     function _checkOnERC721Received(
2126         address from,
2127         address to,
2128         uint256 tokenId,
2129         bytes memory _data
2130     ) private returns (bool) {
2131         if (!to.isContract()) {
2132             // is normal
2133             return true;
2134         }
2135         bytes memory returndata = to.functionCall(
2136             abi.encodeWithSelector(
2137                 IERC721Receiver(to).onERC721Received.selector,
2138                 _msgSender(),
2139                 from,
2140                 tokenId,
2141                 _data
2142             ),
2143             "ERC721: transfer to non ERC721Receiver implementer"
2144         );
2145         bytes4 retval = abi.decode(returndata, (bytes4));
2146         return (retval == _ERC721_RECEIVED);
2147     }
2148 
2149     /**
2150      * @dev Approve `to` to operate on `tokenId`
2151      *
2152      * Emits an {Approval} event.
2153      */
2154     function _approve(address to, uint256 tokenId) internal virtual {
2155         _tokenApprovals[tokenId] = to;
2156         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
2157     }
2158 
2159     /**
2160      * @dev Hook that is called before any token transfer. This includes minting
2161      * and burning.
2162      *
2163      * Calling conditions:
2164      *
2165      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2166      * transferred to `to`.
2167      * - When `from` is zero, `tokenId` will be minted for `to`.
2168      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2169      * - `from` cannot be the zero address.
2170      * - `to` cannot be the zero address.
2171      *
2172      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2173      */
2174     function _beforeTokenTransfer(
2175         address from,
2176         address to,
2177         uint256 tokenId
2178     ) internal virtual {}
2179 }
2180 // File: @openzeppelin/contracts/access/Ownable.sol
2181 pragma solidity >=0.6.0 <0.8.0;
2182 
2183 /**
2184  * @dev Contract module which provides a basic access control mechanism, where
2185  * there is an account (an owner) that can be granted exclusive access to
2186  * specific functions.
2187  *
2188  * By default, the owner account will be the one that deploys the contract. This
2189  * can later be changed with {transferOwnership}.
2190  *
2191  * This module is used through inheritance. It will make available the modifier
2192  * `onlyOwner`, which can be applied to your functions to restrict their use to
2193  * the owner.
2194  */
2195 abstract contract Ownable is Context {
2196     address private _owner;
2197     event OwnershipTransferred(
2198         address indexed previousOwner,
2199         address indexed newOwner
2200     );
2201 
2202     /**
2203      * @dev Initializes the contract setting the deployer as the initial owner.
2204      */
2205     constructor() internal {
2206         address msgSender = _msgSender();
2207         _owner = msgSender;
2208         emit OwnershipTransferred(address(0), msgSender);
2209     }
2210 
2211     /**
2212      * @dev Returns the address of the current owner.
2213      */
2214     function owner() public view virtual returns (address) {
2215         return _owner;
2216     }
2217 
2218     /**
2219      * @dev Throws if called by any account other than the owner.
2220      */
2221     modifier onlyOwner() {
2222         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2223         _;
2224     }
2225 
2226     /**
2227      * @dev Leaves the contract without owner. It will not be possible to call
2228      * `onlyOwner` functions anymore. Can only be called by the current owner.
2229      *
2230      * NOTE: Renouncing ownership will leave the contract without an owner,
2231      * thereby removing any functionality that is only available to the owner.
2232      */
2233     function renounceOwnership() public virtual onlyOwner {
2234         emit OwnershipTransferred(_owner, address(0));
2235         _owner = address(0);
2236     }
2237 
2238     /**
2239      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2240      * Can only be called by the current owner.
2241      */
2242     function transferOwnership(address newOwner) public virtual onlyOwner {
2243         require(
2244             newOwner != address(0),
2245             "Ownable: new owner is the zero address"
2246         );
2247         emit OwnershipTransferred(_owner, newOwner);
2248         _owner = newOwner;
2249     }
2250 }
2251 // File: contracts/wdms.sol
2252 pragma solidity ^0.7.0;
2253 
2254 /**
2255  * @title WDMS contract
2256  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
2257  */
2258 contract WDMS is ERC721, Ownable {
2259     using SafeMath for uint256;
2260     using EnumerableSet for EnumerableSet.UintSet;
2261     uint256 public constant wdmsPrice = 0; //free
2262     uint256 public constant singleMaxMint = 20;
2263     uint256 public MAX_WDMS;
2264     bool public saleIsActive = false;
2265     uint256 private SVIP_INIT_TOKENID = 0;
2266     uint256 private VIP_INIT_TOKENID = 1000;
2267     uint256 private COMMON_INIT_TOKENID = 2000;
2268 
2269     constructor(
2270         string memory name,
2271         string memory symbol,
2272         uint256 maxNftSupply
2273     ) ERC721(name, symbol) {
2274         MAX_WDMS = maxNftSupply;
2275     }
2276 
2277     function withdraw() public onlyOwner {
2278         uint256 balance = address(this).balance;
2279         msg.sender.transfer(balance);
2280     }
2281 
2282     function setTokenURI(uint256 tokenId, string memory tokenURI)
2283         public
2284         onlyOwner
2285     {
2286         _setTokenURI(tokenId, tokenURI);
2287     }
2288 
2289     function setBaseURI(string memory baseURI) public onlyOwner {
2290         _setBaseURI(baseURI);
2291     }
2292 
2293     function setMAX_WDMS(uint256 amount) public onlyOwner {
2294         MAX_WDMS = amount;
2295     }
2296 
2297     /*
2298      * Pause sale if active, make active if paused
2299      */
2300     function flipSaleState() public onlyOwner {
2301         saleIsActive = !saleIsActive;
2302     }
2303 
2304     /**
2305      * Mints tickets
2306      */
2307     function mintSvip(uint256 numberOfTokens) public onlyOwner {
2308         require(saleIsActive, "Sale must be active to mint wdms");
2309         require(
2310             numberOfTokens <= singleMaxMint,
2311             "Can only mint 20 tokens at a time"
2312         );
2313         require(
2314             totalSupply().add(numberOfTokens) <= MAX_WDMS,
2315             "Purchase would exceed max supply of wdms"
2316         );
2317         for (uint256 i = 0; i < numberOfTokens; i++) {
2318             if (totalSupply() < MAX_WDMS) {
2319                 _safeMint(msg.sender, SVIP_INIT_TOKENID, "svip");
2320             }
2321 
2322             SVIP_INIT_TOKENID++;
2323         }
2324     }
2325 
2326     function mintVip(uint256 numberOfTokens) public onlyOwner {
2327         require(saleIsActive, "Sale must be active to mint wdms");
2328         require(
2329             numberOfTokens <= singleMaxMint,
2330             "Can only mint 20 tokens at a time"
2331         );
2332         require(
2333             totalSupply().add(numberOfTokens) <= MAX_WDMS,
2334             "Purchase would exceed max supply of wdms"
2335         );
2336         for (uint256 i = 0; i < numberOfTokens; i++) {
2337             if (totalSupply() < MAX_WDMS) {
2338                 _safeMint(msg.sender, VIP_INIT_TOKENID, "vip");
2339             }
2340             VIP_INIT_TOKENID++;
2341         }
2342     }
2343 
2344     function mintCommon(uint256 numberOfTokens) public onlyOwner {
2345         require(saleIsActive, "Sale must be active to mint wdms");
2346         require(
2347             numberOfTokens <= singleMaxMint,
2348             "Can only mint 20 tokens at a time"
2349         );
2350         require(
2351             totalSupply().add(numberOfTokens) <= MAX_WDMS,
2352             "Purchase would exceed max supply of wdms"
2353         );
2354         for (uint256 i = 0; i < numberOfTokens; i++) {
2355             if (totalSupply() < MAX_WDMS) {
2356                 _safeMint(msg.sender, COMMON_INIT_TOKENID, "common");
2357             }
2358             COMMON_INIT_TOKENID++;
2359         }
2360     }
2361 }