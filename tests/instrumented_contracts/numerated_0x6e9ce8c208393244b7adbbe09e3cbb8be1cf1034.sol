1 /**
2  *Submitted for verification at Etherscan.io on 2021-07-25
3  */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-07-22
7  */
8 
9 // File: @openzeppelin/contracts/utils/Context.sol
10 
11 pragma solidity >=0.6.0 <0.8.0;
12 
13 /*
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with GSN meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address payable) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes memory) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 
34 // File: @openzeppelin/contracts/introspection/IERC165.sol
35 
36 pragma solidity >=0.6.0 <0.8.0;
37 
38 /**
39  * @dev Interface of the ERC165 standard, as defined in the
40  * https://eips.ethereum.org/EIPS/eip-165[EIP].
41  *
42  * Implementers can declare support of contract interfaces, which can then be
43  * queried by others ({ERC165Checker}).
44  *
45  * For an implementation, see {ERC165}.
46  */
47 interface IERC165 {
48     /**
49      * @dev Returns true if this contract implements the interface defined by
50      * `interfaceId`. See the corresponding
51      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
52      * to learn more about how these ids are created.
53      *
54      * This function call must use less than 30 000 gas.
55      */
56     function supportsInterface(bytes4 interfaceId) external view returns (bool);
57 }
58 
59 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
60 
61 pragma solidity >=0.6.2 <0.8.0;
62 
63 /**
64  * @dev Required interface of an ERC721 compliant contract.
65  */
66 interface IERC721 is IERC165 {
67     /**
68      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
69      */
70     event Transfer(
71         address indexed from,
72         address indexed to,
73         uint256 indexed tokenId
74     );
75 
76     /**
77      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
78      */
79     event Approval(
80         address indexed owner,
81         address indexed approved,
82         uint256 indexed tokenId
83     );
84 
85     /**
86      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
87      */
88     event ApprovalForAll(
89         address indexed owner,
90         address indexed operator,
91         bool approved
92     );
93 
94     /**
95      * @dev Returns the number of tokens in ``owner``'s account.
96      */
97     function balanceOf(address owner) external view returns (uint256 balance);
98 
99     /**
100      * @dev Returns the owner of the `tokenId` token.
101      *
102      * Requirements:
103      *
104      * - `tokenId` must exist.
105      */
106     function ownerOf(uint256 tokenId) external view returns (address owner);
107 
108     /**
109      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
110      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
111      *
112      * Requirements:
113      *
114      * - `from` cannot be the zero address.
115      * - `to` cannot be the zero address.
116      * - `tokenId` token must exist and be owned by `from`.
117      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
118      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
119      *
120      * Emits a {Transfer} event.
121      */
122     function safeTransferFrom(
123         address from,
124         address to,
125         uint256 tokenId
126     ) external;
127 
128     /**
129      * @dev Transfers `tokenId` token from `from` to `to`.
130      *
131      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
132      *
133      * Requirements:
134      *
135      * - `from` cannot be the zero address.
136      * - `to` cannot be the zero address.
137      * - `tokenId` token must be owned by `from`.
138      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
139      *
140      * Emits a {Transfer} event.
141      */
142     function transferFrom(
143         address from,
144         address to,
145         uint256 tokenId
146     ) external;
147 
148     /**
149      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
150      * The approval is cleared when the token is transferred.
151      *
152      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
153      *
154      * Requirements:
155      *
156      * - The caller must own the token or be an approved operator.
157      * - `tokenId` must exist.
158      *
159      * Emits an {Approval} event.
160      */
161     function approve(address to, uint256 tokenId) external;
162 
163     /**
164      * @dev Returns the account approved for `tokenId` token.
165      *
166      * Requirements:
167      *
168      * - `tokenId` must exist.
169      */
170     function getApproved(uint256 tokenId)
171         external
172         view
173         returns (address operator);
174 
175     /**
176      * @dev Approve or remove `operator` as an operator for the caller.
177      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
178      *
179      * Requirements:
180      *
181      * - The `operator` cannot be the caller.
182      *
183      * Emits an {ApprovalForAll} event.
184      */
185     function setApprovalForAll(address operator, bool _approved) external;
186 
187     /**
188      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
189      *
190      * See {setApprovalForAll}
191      */
192     function isApprovedForAll(address owner, address operator)
193         external
194         view
195         returns (bool);
196 
197     /**
198      * @dev Safely transfers `tokenId` token from `from` to `to`.
199      *
200      * Requirements:
201      *
202      * - `from` cannot be the zero address.
203      * - `to` cannot be the zero address.
204      * - `tokenId` token must exist and be owned by `from`.
205      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
206      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
207      *
208      * Emits a {Transfer} event.
209      */
210     function safeTransferFrom(
211         address from,
212         address to,
213         uint256 tokenId,
214         bytes calldata data
215     ) external;
216 }
217 
218 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
219 
220 pragma solidity >=0.6.2 <0.8.0;
221 
222 /**
223  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
224  * @dev See https://eips.ethereum.org/EIPS/eip-721
225  */
226 interface IERC721Metadata is IERC721 {
227     /**
228      * @dev Returns the token collection name.
229      */
230     function name() external view returns (string memory);
231 
232     /**
233      * @dev Returns the token collection symbol.
234      */
235     function symbol() external view returns (string memory);
236 
237     /**
238      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
239      */
240     function tokenURI(uint256 tokenId) external view returns (string memory);
241 }
242 
243 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
244 
245 pragma solidity >=0.6.2 <0.8.0;
246 
247 /**
248  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
249  * @dev See https://eips.ethereum.org/EIPS/eip-721
250  */
251 interface IERC721Enumerable is IERC721 {
252     /**
253      * @dev Returns the total amount of tokens stored by the contract.
254      */
255     function totalSupply() external view returns (uint256);
256 
257     /**
258      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
259      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
260      */
261     function tokenOfOwnerByIndex(address owner, uint256 index)
262         external
263         view
264         returns (uint256 tokenId);
265 
266     /**
267      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
268      * Use along with {totalSupply} to enumerate all tokens.
269      */
270     function tokenByIndex(uint256 index) external view returns (uint256);
271 }
272 
273 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
274 
275 pragma solidity >=0.6.0 <0.8.0;
276 
277 /**
278  * @title ERC721 token receiver interface
279  * @dev Interface for any contract that wants to support safeTransfers
280  * from ERC721 asset contracts.
281  */
282 interface IERC721Receiver {
283     /**
284      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
285      * by `operator` from `from`, this function is called.
286      *
287      * It must return its Solidity selector to confirm the token transfer.
288      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
289      *
290      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
291      */
292     function onERC721Received(
293         address operator,
294         address from,
295         uint256 tokenId,
296         bytes calldata data
297     ) external returns (bytes4);
298 }
299 
300 // File: @openzeppelin/contracts/introspection/ERC165.sol
301 
302 pragma solidity >=0.6.0 <0.8.0;
303 
304 /**
305  * @dev Implementation of the {IERC165} interface.
306  *
307  * Contracts may inherit from this and call {_registerInterface} to declare
308  * their support of an interface.
309  */
310 abstract contract ERC165 is IERC165 {
311     /*
312      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
313      */
314     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
315 
316     /**
317      * @dev Mapping of interface ids to whether or not it's supported.
318      */
319     mapping(bytes4 => bool) private _supportedInterfaces;
320 
321     constructor() internal {
322         // Derived contracts need only register support for their own interfaces,
323         // we register support for ERC165 itself here
324         _registerInterface(_INTERFACE_ID_ERC165);
325     }
326 
327     /**
328      * @dev See {IERC165-supportsInterface}.
329      *
330      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
331      */
332     function supportsInterface(bytes4 interfaceId)
333         public
334         view
335         virtual
336         override
337         returns (bool)
338     {
339         return _supportedInterfaces[interfaceId];
340     }
341 
342     /**
343      * @dev Registers the contract as an implementer of the interface defined by
344      * `interfaceId`. Support of the actual ERC165 interface is automatic and
345      * registering its interface id is not required.
346      *
347      * See {IERC165-supportsInterface}.
348      *
349      * Requirements:
350      *
351      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
352      */
353     function _registerInterface(bytes4 interfaceId) internal virtual {
354         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
355         _supportedInterfaces[interfaceId] = true;
356     }
357 }
358 
359 // File: @openzeppelin/contracts/math/SafeMath.sol
360 
361 pragma solidity >=0.6.0 <0.8.0;
362 
363 /**
364  * @dev Wrappers over Solidity's arithmetic operations with added overflow
365  * checks.
366  *
367  * Arithmetic operations in Solidity wrap on overflow. This can easily result
368  * in bugs, because programmers usually assume that an overflow raises an
369  * error, which is the standard behavior in high level programming languages.
370  * `SafeMath` restores this intuition by reverting the transaction when an
371  * operation overflows.
372  *
373  * Using this library instead of the unchecked operations eliminates an entire
374  * class of bugs, so it's recommended to use it always.
375  */
376 library SafeMath {
377     /**
378      * @dev Returns the addition of two unsigned integers, with an overflow flag.
379      *
380      * _Available since v3.4._
381      */
382     function tryAdd(uint256 a, uint256 b)
383         internal
384         pure
385         returns (bool, uint256)
386     {
387         uint256 c = a + b;
388         if (c < a) return (false, 0);
389         return (true, c);
390     }
391 
392     /**
393      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
394      *
395      * _Available since v3.4._
396      */
397     function trySub(uint256 a, uint256 b)
398         internal
399         pure
400         returns (bool, uint256)
401     {
402         if (b > a) return (false, 0);
403         return (true, a - b);
404     }
405 
406     /**
407      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
408      *
409      * _Available since v3.4._
410      */
411     function tryMul(uint256 a, uint256 b)
412         internal
413         pure
414         returns (bool, uint256)
415     {
416         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
417         // benefit is lost if 'b' is also tested.
418         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
419         if (a == 0) return (true, 0);
420         uint256 c = a * b;
421         if (c / a != b) return (false, 0);
422         return (true, c);
423     }
424 
425     /**
426      * @dev Returns the division of two unsigned integers, with a division by zero flag.
427      *
428      * _Available since v3.4._
429      */
430     function tryDiv(uint256 a, uint256 b)
431         internal
432         pure
433         returns (bool, uint256)
434     {
435         if (b == 0) return (false, 0);
436         return (true, a / b);
437     }
438 
439     /**
440      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
441      *
442      * _Available since v3.4._
443      */
444     function tryMod(uint256 a, uint256 b)
445         internal
446         pure
447         returns (bool, uint256)
448     {
449         if (b == 0) return (false, 0);
450         return (true, a % b);
451     }
452 
453     /**
454      * @dev Returns the addition of two unsigned integers, reverting on
455      * overflow.
456      *
457      * Counterpart to Solidity's `+` operator.
458      *
459      * Requirements:
460      *
461      * - Addition cannot overflow.
462      */
463     function add(uint256 a, uint256 b) internal pure returns (uint256) {
464         uint256 c = a + b;
465         require(c >= a, "SafeMath: addition overflow");
466         return c;
467     }
468 
469     /**
470      * @dev Returns the subtraction of two unsigned integers, reverting on
471      * overflow (when the result is negative).
472      *
473      * Counterpart to Solidity's `-` operator.
474      *
475      * Requirements:
476      *
477      * - Subtraction cannot overflow.
478      */
479     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
480         require(b <= a, "SafeMath: subtraction overflow");
481         return a - b;
482     }
483 
484     /**
485      * @dev Returns the multiplication of two unsigned integers, reverting on
486      * overflow.
487      *
488      * Counterpart to Solidity's `*` operator.
489      *
490      * Requirements:
491      *
492      * - Multiplication cannot overflow.
493      */
494     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
495         if (a == 0) return 0;
496         uint256 c = a * b;
497         require(c / a == b, "SafeMath: multiplication overflow");
498         return c;
499     }
500 
501     /**
502      * @dev Returns the integer division of two unsigned integers, reverting on
503      * division by zero. The result is rounded towards zero.
504      *
505      * Counterpart to Solidity's `/` operator. Note: this function uses a
506      * `revert` opcode (which leaves remaining gas untouched) while Solidity
507      * uses an invalid opcode to revert (consuming all remaining gas).
508      *
509      * Requirements:
510      *
511      * - The divisor cannot be zero.
512      */
513     function div(uint256 a, uint256 b) internal pure returns (uint256) {
514         require(b > 0, "SafeMath: division by zero");
515         return a / b;
516     }
517 
518     /**
519      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
520      * reverting when dividing by zero.
521      *
522      * Counterpart to Solidity's `%` operator. This function uses a `revert`
523      * opcode (which leaves remaining gas untouched) while Solidity uses an
524      * invalid opcode to revert (consuming all remaining gas).
525      *
526      * Requirements:
527      *
528      * - The divisor cannot be zero.
529      */
530     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
531         require(b > 0, "SafeMath: modulo by zero");
532         return a % b;
533     }
534 
535     /**
536      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
537      * overflow (when the result is negative).
538      *
539      * CAUTION: This function is deprecated because it requires allocating memory for the error
540      * message unnecessarily. For custom revert reasons use {trySub}.
541      *
542      * Counterpart to Solidity's `-` operator.
543      *
544      * Requirements:
545      *
546      * - Subtraction cannot overflow.
547      */
548     function sub(
549         uint256 a,
550         uint256 b,
551         string memory errorMessage
552     ) internal pure returns (uint256) {
553         require(b <= a, errorMessage);
554         return a - b;
555     }
556 
557     /**
558      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
559      * division by zero. The result is rounded towards zero.
560      *
561      * CAUTION: This function is deprecated because it requires allocating memory for the error
562      * message unnecessarily. For custom revert reasons use {tryDiv}.
563      *
564      * Counterpart to Solidity's `/` operator. Note: this function uses a
565      * `revert` opcode (which leaves remaining gas untouched) while Solidity
566      * uses an invalid opcode to revert (consuming all remaining gas).
567      *
568      * Requirements:
569      *
570      * - The divisor cannot be zero.
571      */
572     function div(
573         uint256 a,
574         uint256 b,
575         string memory errorMessage
576     ) internal pure returns (uint256) {
577         require(b > 0, errorMessage);
578         return a / b;
579     }
580 
581     /**
582      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
583      * reverting with custom message when dividing by zero.
584      *
585      * CAUTION: This function is deprecated because it requires allocating memory for the error
586      * message unnecessarily. For custom revert reasons use {tryMod}.
587      *
588      * Counterpart to Solidity's `%` operator. This function uses a `revert`
589      * opcode (which leaves remaining gas untouched) while Solidity uses an
590      * invalid opcode to revert (consuming all remaining gas).
591      *
592      * Requirements:
593      *
594      * - The divisor cannot be zero.
595      */
596     function mod(
597         uint256 a,
598         uint256 b,
599         string memory errorMessage
600     ) internal pure returns (uint256) {
601         require(b > 0, errorMessage);
602         return a % b;
603     }
604 }
605 
606 // File: @openzeppelin/contracts/utils/Address.sol
607 
608 pragma solidity >=0.6.2 <0.8.0;
609 
610 /**
611  * @dev Collection of functions related to the address type
612  */
613 library Address {
614     /**
615      * @dev Returns true if `account` is a contract.
616      *
617      * [IMPORTANT]
618      * ====
619      * It is unsafe to assume that an address for which this function returns
620      * false is an externally-owned account (EOA) and not a contract.
621      *
622      * Among others, `isContract` will return false for the following
623      * types of addresses:
624      *
625      *  - an externally-owned account
626      *  - a contract in construction
627      *  - an address where a contract will be created
628      *  - an address where a contract lived, but was destroyed
629      * ====
630      */
631     function isContract(address account) internal view returns (bool) {
632         // This method relies on extcodesize, which returns 0 for contracts in
633         // construction, since the code is only stored at the end of the
634         // constructor execution.
635 
636         uint256 size;
637         // solhint-disable-next-line no-inline-assembly
638         assembly {
639             size := extcodesize(account)
640         }
641         return size > 0;
642     }
643 
644     /**
645      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
646      * `recipient`, forwarding all available gas and reverting on errors.
647      *
648      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
649      * of certain opcodes, possibly making contracts go over the 2300 gas limit
650      * imposed by `transfer`, making them unable to receive funds via
651      * `transfer`. {sendValue} removes this limitation.
652      *
653      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
654      *
655      * IMPORTANT: because control is transferred to `recipient`, care must be
656      * taken to not create reentrancy vulnerabilities. Consider using
657      * {ReentrancyGuard} or the
658      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
659      */
660     function sendValue(address payable recipient, uint256 amount) internal {
661         require(
662             address(this).balance >= amount,
663             "Address: insufficient balance"
664         );
665 
666         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
667         (bool success, ) = recipient.call{value: amount}("");
668         require(
669             success,
670             "Address: unable to send value, recipient may have reverted"
671         );
672     }
673 
674     /**
675      * @dev Performs a Solidity function call using a low level `call`. A
676      * plain`call` is an unsafe replacement for a function call: use this
677      * function instead.
678      *
679      * If `target` reverts with a revert reason, it is bubbled up by this
680      * function (like regular Solidity function calls).
681      *
682      * Returns the raw returned data. To convert to the expected return value,
683      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
684      *
685      * Requirements:
686      *
687      * - `target` must be a contract.
688      * - calling `target` with `data` must not revert.
689      *
690      * _Available since v3.1._
691      */
692     function functionCall(address target, bytes memory data)
693         internal
694         returns (bytes memory)
695     {
696         return functionCall(target, data, "Address: low-level call failed");
697     }
698 
699     /**
700      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
701      * `errorMessage` as a fallback revert reason when `target` reverts.
702      *
703      * _Available since v3.1._
704      */
705     function functionCall(
706         address target,
707         bytes memory data,
708         string memory errorMessage
709     ) internal returns (bytes memory) {
710         return functionCallWithValue(target, data, 0, errorMessage);
711     }
712 
713     /**
714      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
715      * but also transferring `value` wei to `target`.
716      *
717      * Requirements:
718      *
719      * - the calling contract must have an ETH balance of at least `value`.
720      * - the called Solidity function must be `payable`.
721      *
722      * _Available since v3.1._
723      */
724     function functionCallWithValue(
725         address target,
726         bytes memory data,
727         uint256 value
728     ) internal returns (bytes memory) {
729         return
730             functionCallWithValue(
731                 target,
732                 data,
733                 value,
734                 "Address: low-level call with value failed"
735             );
736     }
737 
738     /**
739      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
740      * with `errorMessage` as a fallback revert reason when `target` reverts.
741      *
742      * _Available since v3.1._
743      */
744     function functionCallWithValue(
745         address target,
746         bytes memory data,
747         uint256 value,
748         string memory errorMessage
749     ) internal returns (bytes memory) {
750         require(
751             address(this).balance >= value,
752             "Address: insufficient balance for call"
753         );
754         require(isContract(target), "Address: call to non-contract");
755 
756         // solhint-disable-next-line avoid-low-level-calls
757         (bool success, bytes memory returndata) = target.call{value: value}(
758             data
759         );
760         return _verifyCallResult(success, returndata, errorMessage);
761     }
762 
763     /**
764      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
765      * but performing a static call.
766      *
767      * _Available since v3.3._
768      */
769     function functionStaticCall(address target, bytes memory data)
770         internal
771         view
772         returns (bytes memory)
773     {
774         return
775             functionStaticCall(
776                 target,
777                 data,
778                 "Address: low-level static call failed"
779             );
780     }
781 
782     /**
783      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
784      * but performing a static call.
785      *
786      * _Available since v3.3._
787      */
788     function functionStaticCall(
789         address target,
790         bytes memory data,
791         string memory errorMessage
792     ) internal view returns (bytes memory) {
793         require(isContract(target), "Address: static call to non-contract");
794 
795         // solhint-disable-next-line avoid-low-level-calls
796         (bool success, bytes memory returndata) = target.staticcall(data);
797         return _verifyCallResult(success, returndata, errorMessage);
798     }
799 
800     /**
801      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
802      * but performing a delegate call.
803      *
804      * _Available since v3.4._
805      */
806     function functionDelegateCall(address target, bytes memory data)
807         internal
808         returns (bytes memory)
809     {
810         return
811             functionDelegateCall(
812                 target,
813                 data,
814                 "Address: low-level delegate call failed"
815             );
816     }
817 
818     /**
819      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
820      * but performing a delegate call.
821      *
822      * _Available since v3.4._
823      */
824     function functionDelegateCall(
825         address target,
826         bytes memory data,
827         string memory errorMessage
828     ) internal returns (bytes memory) {
829         require(isContract(target), "Address: delegate call to non-contract");
830 
831         // solhint-disable-next-line avoid-low-level-calls
832         (bool success, bytes memory returndata) = target.delegatecall(data);
833         return _verifyCallResult(success, returndata, errorMessage);
834     }
835 
836     function _verifyCallResult(
837         bool success,
838         bytes memory returndata,
839         string memory errorMessage
840     ) private pure returns (bytes memory) {
841         if (success) {
842             return returndata;
843         } else {
844             // Look for revert reason and bubble it up if present
845             if (returndata.length > 0) {
846                 // The easiest way to bubble the revert reason is using memory via assembly
847 
848                 // solhint-disable-next-line no-inline-assembly
849                 assembly {
850                     let returndata_size := mload(returndata)
851                     revert(add(32, returndata), returndata_size)
852                 }
853             } else {
854                 revert(errorMessage);
855             }
856         }
857     }
858 }
859 
860 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
861 
862 pragma solidity >=0.6.0 <0.8.0;
863 
864 /**
865  * @dev Library for managing
866  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
867  * types.
868  *
869  * Sets have the following properties:
870  *
871  * - Elements are added, removed, and checked for existence in constant time
872  * (O(1)).
873  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
874  *
875  * ```
876  * contract Example {
877  *     // Add the library methods
878  *     using EnumerableSet for EnumerableSet.AddressSet;
879  *
880  *     // Declare a set state variable
881  *     EnumerableSet.AddressSet private mySet;
882  * }
883  * ```
884  *
885  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
886  * and `uint256` (`UintSet`) are supported.
887  */
888 library EnumerableSet {
889     // To implement this library for multiple types with as little code
890     // repetition as possible, we write it in terms of a generic Set type with
891     // bytes32 values.
892     // The Set implementation uses private functions, and user-facing
893     // implementations (such as AddressSet) are just wrappers around the
894     // underlying Set.
895     // This means that we can only create new EnumerableSets for types that fit
896     // in bytes32.
897 
898     struct Set {
899         // Storage of set values
900         bytes32[] _values;
901         // Position of the value in the `values` array, plus 1 because index 0
902         // means a value is not in the set.
903         mapping(bytes32 => uint256) _indexes;
904     }
905 
906     /**
907      * @dev Add a value to a set. O(1).
908      *
909      * Returns true if the value was added to the set, that is if it was not
910      * already present.
911      */
912     function _add(Set storage set, bytes32 value) private returns (bool) {
913         if (!_contains(set, value)) {
914             set._values.push(value);
915             // The value is stored at length-1, but we add 1 to all indexes
916             // and use 0 as a sentinel value
917             set._indexes[value] = set._values.length;
918             return true;
919         } else {
920             return false;
921         }
922     }
923 
924     /**
925      * @dev Removes a value from a set. O(1).
926      *
927      * Returns true if the value was removed from the set, that is if it was
928      * present.
929      */
930     function _remove(Set storage set, bytes32 value) private returns (bool) {
931         // We read and store the value's index to prevent multiple reads from the same storage slot
932         uint256 valueIndex = set._indexes[value];
933 
934         if (valueIndex != 0) {
935             // Equivalent to contains(set, value)
936             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
937             // the array, and then remove the last element (sometimes called as 'swap and pop').
938             // This modifies the order of the array, as noted in {at}.
939 
940             uint256 toDeleteIndex = valueIndex - 1;
941             uint256 lastIndex = set._values.length - 1;
942 
943             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
944             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
945 
946             bytes32 lastvalue = set._values[lastIndex];
947 
948             // Move the last value to the index where the value to delete is
949             set._values[toDeleteIndex] = lastvalue;
950             // Update the index for the moved value
951             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
952 
953             // Delete the slot where the moved value was stored
954             set._values.pop();
955 
956             // Delete the index for the deleted slot
957             delete set._indexes[value];
958 
959             return true;
960         } else {
961             return false;
962         }
963     }
964 
965     /**
966      * @dev Returns true if the value is in the set. O(1).
967      */
968     function _contains(Set storage set, bytes32 value)
969         private
970         view
971         returns (bool)
972     {
973         return set._indexes[value] != 0;
974     }
975 
976     /**
977      * @dev Returns the number of values on the set. O(1).
978      */
979     function _length(Set storage set) private view returns (uint256) {
980         return set._values.length;
981     }
982 
983     /**
984      * @dev Returns the value stored at position `index` in the set. O(1).
985      *
986      * Note that there are no guarantees on the ordering of values inside the
987      * array, and it may change when more values are added or removed.
988      *
989      * Requirements:
990      *
991      * - `index` must be strictly less than {length}.
992      */
993     function _at(Set storage set, uint256 index)
994         private
995         view
996         returns (bytes32)
997     {
998         require(
999             set._values.length > index,
1000             "EnumerableSet: index out of bounds"
1001         );
1002         return set._values[index];
1003     }
1004 
1005     // Bytes32Set
1006 
1007     struct Bytes32Set {
1008         Set _inner;
1009     }
1010 
1011     /**
1012      * @dev Add a value to a set. O(1).
1013      *
1014      * Returns true if the value was added to the set, that is if it was not
1015      * already present.
1016      */
1017     function add(Bytes32Set storage set, bytes32 value)
1018         internal
1019         returns (bool)
1020     {
1021         return _add(set._inner, value);
1022     }
1023 
1024     /**
1025      * @dev Removes a value from a set. O(1).
1026      *
1027      * Returns true if the value was removed from the set, that is if it was
1028      * present.
1029      */
1030     function remove(Bytes32Set storage set, bytes32 value)
1031         internal
1032         returns (bool)
1033     {
1034         return _remove(set._inner, value);
1035     }
1036 
1037     /**
1038      * @dev Returns true if the value is in the set. O(1).
1039      */
1040     function contains(Bytes32Set storage set, bytes32 value)
1041         internal
1042         view
1043         returns (bool)
1044     {
1045         return _contains(set._inner, value);
1046     }
1047 
1048     /**
1049      * @dev Returns the number of values in the set. O(1).
1050      */
1051     function length(Bytes32Set storage set) internal view returns (uint256) {
1052         return _length(set._inner);
1053     }
1054 
1055     /**
1056      * @dev Returns the value stored at position `index` in the set. O(1).
1057      *
1058      * Note that there are no guarantees on the ordering of values inside the
1059      * array, and it may change when more values are added or removed.
1060      *
1061      * Requirements:
1062      *
1063      * - `index` must be strictly less than {length}.
1064      */
1065     function at(Bytes32Set storage set, uint256 index)
1066         internal
1067         view
1068         returns (bytes32)
1069     {
1070         return _at(set._inner, index);
1071     }
1072 
1073     // AddressSet
1074 
1075     struct AddressSet {
1076         Set _inner;
1077     }
1078 
1079     /**
1080      * @dev Add a value to a set. O(1).
1081      *
1082      * Returns true if the value was added to the set, that is if it was not
1083      * already present.
1084      */
1085     function add(AddressSet storage set, address value)
1086         internal
1087         returns (bool)
1088     {
1089         return _add(set._inner, bytes32(uint256(uint160(value))));
1090     }
1091 
1092     /**
1093      * @dev Removes a value from a set. O(1).
1094      *
1095      * Returns true if the value was removed from the set, that is if it was
1096      * present.
1097      */
1098     function remove(AddressSet storage set, address value)
1099         internal
1100         returns (bool)
1101     {
1102         return _remove(set._inner, bytes32(uint256(uint160(value))));
1103     }
1104 
1105     /**
1106      * @dev Returns true if the value is in the set. O(1).
1107      */
1108     function contains(AddressSet storage set, address value)
1109         internal
1110         view
1111         returns (bool)
1112     {
1113         return _contains(set._inner, bytes32(uint256(uint160(value))));
1114     }
1115 
1116     /**
1117      * @dev Returns the number of values in the set. O(1).
1118      */
1119     function length(AddressSet storage set) internal view returns (uint256) {
1120         return _length(set._inner);
1121     }
1122 
1123     /**
1124      * @dev Returns the value stored at position `index` in the set. O(1).
1125      *
1126      * Note that there are no guarantees on the ordering of values inside the
1127      * array, and it may change when more values are added or removed.
1128      *
1129      * Requirements:
1130      *
1131      * - `index` must be strictly less than {length}.
1132      */
1133     function at(AddressSet storage set, uint256 index)
1134         internal
1135         view
1136         returns (address)
1137     {
1138         return address(uint160(uint256(_at(set._inner, index))));
1139     }
1140 
1141     // UintSet
1142 
1143     struct UintSet {
1144         Set _inner;
1145     }
1146 
1147     /**
1148      * @dev Add a value to a set. O(1).
1149      *
1150      * Returns true if the value was added to the set, that is if it was not
1151      * already present.
1152      */
1153     function add(UintSet storage set, uint256 value) internal returns (bool) {
1154         return _add(set._inner, bytes32(value));
1155     }
1156 
1157     /**
1158      * @dev Removes a value from a set. O(1).
1159      *
1160      * Returns true if the value was removed from the set, that is if it was
1161      * present.
1162      */
1163     function remove(UintSet storage set, uint256 value)
1164         internal
1165         returns (bool)
1166     {
1167         return _remove(set._inner, bytes32(value));
1168     }
1169 
1170     /**
1171      * @dev Returns true if the value is in the set. O(1).
1172      */
1173     function contains(UintSet storage set, uint256 value)
1174         internal
1175         view
1176         returns (bool)
1177     {
1178         return _contains(set._inner, bytes32(value));
1179     }
1180 
1181     /**
1182      * @dev Returns the number of values on the set. O(1).
1183      */
1184     function length(UintSet storage set) internal view returns (uint256) {
1185         return _length(set._inner);
1186     }
1187 
1188     /**
1189      * @dev Returns the value stored at position `index` in the set. O(1).
1190      *
1191      * Note that there are no guarantees on the ordering of values inside the
1192      * array, and it may change when more values are added or removed.
1193      *
1194      * Requirements:
1195      *
1196      * - `index` must be strictly less than {length}.
1197      */
1198     function at(UintSet storage set, uint256 index)
1199         internal
1200         view
1201         returns (uint256)
1202     {
1203         return uint256(_at(set._inner, index));
1204     }
1205 }
1206 
1207 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1208 
1209 pragma solidity >=0.6.0 <0.8.0;
1210 
1211 /**
1212  * @dev Library for managing an enumerable variant of Solidity's
1213  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1214  * type.
1215  *
1216  * Maps have the following properties:
1217  *
1218  * - Entries are added, removed, and checked for existence in constant time
1219  * (O(1)).
1220  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1221  *
1222  * ```
1223  * contract Example {
1224  *     // Add the library methods
1225  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1226  *
1227  *     // Declare a set state variable
1228  *     EnumerableMap.UintToAddressMap private myMap;
1229  * }
1230  * ```
1231  *
1232  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1233  * supported.
1234  */
1235 library EnumerableMap {
1236     // To implement this library for multiple types with as little code
1237     // repetition as possible, we write it in terms of a generic Map type with
1238     // bytes32 keys and values.
1239     // The Map implementation uses private functions, and user-facing
1240     // implementations (such as Uint256ToAddressMap) are just wrappers around
1241     // the underlying Map.
1242     // This means that we can only create new EnumerableMaps for types that fit
1243     // in bytes32.
1244 
1245     struct MapEntry {
1246         bytes32 _key;
1247         bytes32 _value;
1248     }
1249 
1250     struct Map {
1251         // Storage of map keys and values
1252         MapEntry[] _entries;
1253         // Position of the entry defined by a key in the `entries` array, plus 1
1254         // because index 0 means a key is not in the map.
1255         mapping(bytes32 => uint256) _indexes;
1256     }
1257 
1258     /**
1259      * @dev Adds a key-value pair to a map, or updates the value for an existing
1260      * key. O(1).
1261      *
1262      * Returns true if the key was added to the map, that is if it was not
1263      * already present.
1264      */
1265     function _set(
1266         Map storage map,
1267         bytes32 key,
1268         bytes32 value
1269     ) private returns (bool) {
1270         // We read and store the key's index to prevent multiple reads from the same storage slot
1271         uint256 keyIndex = map._indexes[key];
1272 
1273         if (keyIndex == 0) {
1274             // Equivalent to !contains(map, key)
1275             map._entries.push(MapEntry({_key: key, _value: value}));
1276             // The entry is stored at length-1, but we add 1 to all indexes
1277             // and use 0 as a sentinel value
1278             map._indexes[key] = map._entries.length;
1279             return true;
1280         } else {
1281             map._entries[keyIndex - 1]._value = value;
1282             return false;
1283         }
1284     }
1285 
1286     /**
1287      * @dev Removes a key-value pair from a map. O(1).
1288      *
1289      * Returns true if the key was removed from the map, that is if it was present.
1290      */
1291     function _remove(Map storage map, bytes32 key) private returns (bool) {
1292         // We read and store the key's index to prevent multiple reads from the same storage slot
1293         uint256 keyIndex = map._indexes[key];
1294 
1295         if (keyIndex != 0) {
1296             // Equivalent to contains(map, key)
1297             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1298             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1299             // This modifies the order of the array, as noted in {at}.
1300 
1301             uint256 toDeleteIndex = keyIndex - 1;
1302             uint256 lastIndex = map._entries.length - 1;
1303 
1304             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1305             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1306 
1307             MapEntry storage lastEntry = map._entries[lastIndex];
1308 
1309             // Move the last entry to the index where the entry to delete is
1310             map._entries[toDeleteIndex] = lastEntry;
1311             // Update the index for the moved entry
1312             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1313 
1314             // Delete the slot where the moved entry was stored
1315             map._entries.pop();
1316 
1317             // Delete the index for the deleted slot
1318             delete map._indexes[key];
1319 
1320             return true;
1321         } else {
1322             return false;
1323         }
1324     }
1325 
1326     /**
1327      * @dev Returns true if the key is in the map. O(1).
1328      */
1329     function _contains(Map storage map, bytes32 key)
1330         private
1331         view
1332         returns (bool)
1333     {
1334         return map._indexes[key] != 0;
1335     }
1336 
1337     /**
1338      * @dev Returns the number of key-value pairs in the map. O(1).
1339      */
1340     function _length(Map storage map) private view returns (uint256) {
1341         return map._entries.length;
1342     }
1343 
1344     /**
1345      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1346      *
1347      * Note that there are no guarantees on the ordering of entries inside the
1348      * array, and it may change when more entries are added or removed.
1349      *
1350      * Requirements:
1351      *
1352      * - `index` must be strictly less than {length}.
1353      */
1354     function _at(Map storage map, uint256 index)
1355         private
1356         view
1357         returns (bytes32, bytes32)
1358     {
1359         require(
1360             map._entries.length > index,
1361             "EnumerableMap: index out of bounds"
1362         );
1363 
1364         MapEntry storage entry = map._entries[index];
1365         return (entry._key, entry._value);
1366     }
1367 
1368     /**
1369      * @dev Tries to returns the value associated with `key`.  O(1).
1370      * Does not revert if `key` is not in the map.
1371      */
1372     function _tryGet(Map storage map, bytes32 key)
1373         private
1374         view
1375         returns (bool, bytes32)
1376     {
1377         uint256 keyIndex = map._indexes[key];
1378         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1379         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1380     }
1381 
1382     /**
1383      * @dev Returns the value associated with `key`.  O(1).
1384      *
1385      * Requirements:
1386      *
1387      * - `key` must be in the map.
1388      */
1389     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1390         uint256 keyIndex = map._indexes[key];
1391         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1392         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1393     }
1394 
1395     /**
1396      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1397      *
1398      * CAUTION: This function is deprecated because it requires allocating memory for the error
1399      * message unnecessarily. For custom revert reasons use {_tryGet}.
1400      */
1401     function _get(
1402         Map storage map,
1403         bytes32 key,
1404         string memory errorMessage
1405     ) private view returns (bytes32) {
1406         uint256 keyIndex = map._indexes[key];
1407         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1408         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1409     }
1410 
1411     // UintToAddressMap
1412 
1413     struct UintToAddressMap {
1414         Map _inner;
1415     }
1416 
1417     /**
1418      * @dev Adds a key-value pair to a map, or updates the value for an existing
1419      * key. O(1).
1420      *
1421      * Returns true if the key was added to the map, that is if it was not
1422      * already present.
1423      */
1424     function set(
1425         UintToAddressMap storage map,
1426         uint256 key,
1427         address value
1428     ) internal returns (bool) {
1429         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1430     }
1431 
1432     /**
1433      * @dev Removes a value from a set. O(1).
1434      *
1435      * Returns true if the key was removed from the map, that is if it was present.
1436      */
1437     function remove(UintToAddressMap storage map, uint256 key)
1438         internal
1439         returns (bool)
1440     {
1441         return _remove(map._inner, bytes32(key));
1442     }
1443 
1444     /**
1445      * @dev Returns true if the key is in the map. O(1).
1446      */
1447     function contains(UintToAddressMap storage map, uint256 key)
1448         internal
1449         view
1450         returns (bool)
1451     {
1452         return _contains(map._inner, bytes32(key));
1453     }
1454 
1455     /**
1456      * @dev Returns the number of elements in the map. O(1).
1457      */
1458     function length(UintToAddressMap storage map)
1459         internal
1460         view
1461         returns (uint256)
1462     {
1463         return _length(map._inner);
1464     }
1465 
1466     /**
1467      * @dev Returns the element stored at position `index` in the set. O(1).
1468      * Note that there are no guarantees on the ordering of values inside the
1469      * array, and it may change when more values are added or removed.
1470      *
1471      * Requirements:
1472      *
1473      * - `index` must be strictly less than {length}.
1474      */
1475     function at(UintToAddressMap storage map, uint256 index)
1476         internal
1477         view
1478         returns (uint256, address)
1479     {
1480         (bytes32 key, bytes32 value) = _at(map._inner, index);
1481         return (uint256(key), address(uint160(uint256(value))));
1482     }
1483 
1484     /**
1485      * @dev Tries to returns the value associated with `key`.  O(1).
1486      * Does not revert if `key` is not in the map.
1487      *
1488      * _Available since v3.4._
1489      */
1490     function tryGet(UintToAddressMap storage map, uint256 key)
1491         internal
1492         view
1493         returns (bool, address)
1494     {
1495         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1496         return (success, address(uint160(uint256(value))));
1497     }
1498 
1499     /**
1500      * @dev Returns the value associated with `key`.  O(1).
1501      *
1502      * Requirements:
1503      *
1504      * - `key` must be in the map.
1505      */
1506     function get(UintToAddressMap storage map, uint256 key)
1507         internal
1508         view
1509         returns (address)
1510     {
1511         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1512     }
1513 
1514     /**
1515      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1516      *
1517      * CAUTION: This function is deprecated because it requires allocating memory for the error
1518      * message unnecessarily. For custom revert reasons use {tryGet}.
1519      */
1520     function get(
1521         UintToAddressMap storage map,
1522         uint256 key,
1523         string memory errorMessage
1524     ) internal view returns (address) {
1525         return
1526             address(
1527                 uint160(uint256(_get(map._inner, bytes32(key), errorMessage)))
1528             );
1529     }
1530 }
1531 
1532 // File: @openzeppelin/contracts/utils/Strings.sol
1533 
1534 pragma solidity >=0.6.0 <0.8.0;
1535 
1536 /**
1537  * @dev String operations.
1538  */
1539 library Strings {
1540     /**
1541      * @dev Converts a `uint256` to its ASCII `string` representation.
1542      */
1543     function toString(uint256 value) internal pure returns (string memory) {
1544         // Inspired by OraclizeAPI's implementation - MIT licence
1545         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1546 
1547         if (value == 0) {
1548             return "0";
1549         }
1550         uint256 temp = value;
1551         uint256 digits;
1552         while (temp != 0) {
1553             digits++;
1554             temp /= 10;
1555         }
1556         bytes memory buffer = new bytes(digits);
1557         uint256 index = digits - 1;
1558         temp = value;
1559         while (temp != 0) {
1560             buffer[index--] = bytes1(uint8(48 + (temp % 10)));
1561             temp /= 10;
1562         }
1563         return string(buffer);
1564     }
1565 }
1566 
1567 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1568 
1569 pragma solidity >=0.6.0 <0.8.0;
1570 
1571 /**
1572  * @title ERC721 Non-Fungible Token Standard basic implementation
1573  * @dev see https://eips.ethereum.org/EIPS/eip-721
1574  */
1575 
1576 contract ERC721 is
1577     Context,
1578     ERC165,
1579     IERC721,
1580     IERC721Metadata,
1581     IERC721Enumerable
1582 {
1583     using SafeMath for uint256;
1584     using Address for address;
1585     using EnumerableSet for EnumerableSet.UintSet;
1586     using EnumerableMap for EnumerableMap.UintToAddressMap;
1587     using Strings for uint256;
1588 
1589     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1590     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1591     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1592 
1593     // Mapping from holder address to their (enumerable) set of owned tokens
1594     mapping(address => EnumerableSet.UintSet) private _holderTokens;
1595 
1596     // Enumerable mapping from token ids to their owners
1597     EnumerableMap.UintToAddressMap private _tokenOwners;
1598 
1599     // Mapping from token ID to approved address
1600     mapping(uint256 => address) private _tokenApprovals;
1601 
1602     // Mapping from owner to operator approvals
1603     mapping(address => mapping(address => bool)) private _operatorApprovals;
1604 
1605     // Token name
1606     string private _name;
1607 
1608     // Token symbol
1609     string private _symbol;
1610 
1611     // Optional mapping for token URIs
1612     mapping(uint256 => string) private _tokenURIs;
1613 
1614     // Base URI
1615     string private _baseURI;
1616 
1617     /*
1618      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1619      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1620      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1621      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1622      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1623      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1624      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1625      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1626      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1627      *
1628      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1629      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1630      */
1631     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1632 
1633     /*
1634      *     bytes4(keccak256('name()')) == 0x06fdde03
1635      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1636      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1637      *
1638      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1639      */
1640     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1641 
1642     /*
1643      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1644      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1645      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1646      *
1647      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1648      */
1649     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1650 
1651     /**
1652      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1653      */
1654     constructor(string memory name_, string memory symbol_) public {
1655         _name = name_;
1656         _symbol = symbol_;
1657 
1658         // register the supported interfaces to conform to ERC721 via ERC165
1659         _registerInterface(_INTERFACE_ID_ERC721);
1660         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1661         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1662     }
1663 
1664     /**
1665      * @dev See {IERC721-balanceOf}.
1666      */
1667     function balanceOf(address owner)
1668         public
1669         view
1670         virtual
1671         override
1672         returns (uint256)
1673     {
1674         require(
1675             owner != address(0),
1676             "ERC721: balance query for the zero address"
1677         );
1678         return _holderTokens[owner].length();
1679     }
1680 
1681     /**
1682      * @dev See {IERC721-ownerOf}.
1683      */
1684     function ownerOf(uint256 tokenId)
1685         public
1686         view
1687         virtual
1688         override
1689         returns (address)
1690     {
1691         return
1692             _tokenOwners.get(
1693                 tokenId,
1694                 "ERC721: owner query for nonexistent token"
1695             );
1696     }
1697 
1698     /**
1699      * @dev See {IERC721Metadata-name}.
1700      */
1701     function name() public view virtual override returns (string memory) {
1702         return _name;
1703     }
1704 
1705     /**
1706      * @dev See {IERC721Metadata-symbol}.
1707      */
1708     function symbol() public view virtual override returns (string memory) {
1709         return _symbol;
1710     }
1711 
1712     /**
1713      * @dev See {IERC721Metadata-tokenURI}.
1714      */
1715     function tokenURI(uint256 tokenId)
1716         public
1717         view
1718         virtual
1719         override
1720         returns (string memory)
1721     {
1722         require(
1723             _exists(tokenId),
1724             "ERC721Metadata: URI query for nonexistent token"
1725         );
1726 
1727         string memory _tokenURI = _tokenURIs[tokenId];
1728         string memory base = baseURI();
1729 
1730         // If there is no base URI, return the token URI.
1731         if (bytes(base).length == 0) {
1732             return _tokenURI;
1733         }
1734         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1735         if (bytes(_tokenURI).length > 0) {
1736             return string(abi.encodePacked(base, _tokenURI));
1737         }
1738         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1739         return string(abi.encodePacked(base, tokenId.toString()));
1740     }
1741 
1742     /**
1743      * @dev Returns the base URI set via {_setBaseURI}. This will be
1744      * automatically added as a prefix in {tokenURI} to each token's URI, or
1745      * to the token ID if no specific URI is set for that token ID.
1746      */
1747     function baseURI() public view virtual returns (string memory) {
1748         return _baseURI;
1749     }
1750 
1751     /**
1752      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1753      */
1754     function tokenOfOwnerByIndex(address owner, uint256 index)
1755         public
1756         view
1757         virtual
1758         override
1759         returns (uint256)
1760     {
1761         return _holderTokens[owner].at(index);
1762     }
1763 
1764     /**
1765      * @dev See {IERC721Enumerable-totalSupply}.
1766      */
1767     function totalSupply() public view virtual override returns (uint256) {
1768         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1769         return _tokenOwners.length();
1770     }
1771 
1772     /**
1773      * @dev See {IERC721Enumerable-tokenByIndex}.
1774      */
1775     function tokenByIndex(uint256 index)
1776         public
1777         view
1778         virtual
1779         override
1780         returns (uint256)
1781     {
1782         (uint256 tokenId, ) = _tokenOwners.at(index);
1783         return tokenId;
1784     }
1785 
1786     /**
1787      * @dev See {IERC721-approve}.
1788      */
1789     function approve(address to, uint256 tokenId) public virtual override {
1790         address owner = ERC721.ownerOf(tokenId);
1791         require(to != owner, "ERC721: approval to current owner");
1792 
1793         require(
1794             _msgSender() == owner ||
1795                 ERC721.isApprovedForAll(owner, _msgSender()),
1796             "ERC721: approve caller is not owner nor approved for all"
1797         );
1798 
1799         _approve(to, tokenId);
1800     }
1801 
1802     /**
1803      * @dev See {IERC721-getApproved}.
1804      */
1805     function getApproved(uint256 tokenId)
1806         public
1807         view
1808         virtual
1809         override
1810         returns (address)
1811     {
1812         require(
1813             _exists(tokenId),
1814             "ERC721: approved query for nonexistent token"
1815         );
1816 
1817         return _tokenApprovals[tokenId];
1818     }
1819 
1820     /**
1821      * @dev See {IERC721-setApprovalForAll}.
1822      */
1823     function setApprovalForAll(address operator, bool approved)
1824         public
1825         virtual
1826         override
1827     {
1828         require(operator != _msgSender(), "ERC721: approve to caller");
1829 
1830         _operatorApprovals[_msgSender()][operator] = approved;
1831         emit ApprovalForAll(_msgSender(), operator, approved);
1832     }
1833 
1834     /**
1835      * @dev See {IERC721-isApprovedForAll}.
1836      */
1837     function isApprovedForAll(address owner, address operator)
1838         public
1839         view
1840         virtual
1841         override
1842         returns (bool)
1843     {
1844         return _operatorApprovals[owner][operator];
1845     }
1846 
1847     /**
1848      * @dev See {IERC721-transferFrom}.
1849      */
1850     function transferFrom(
1851         address from,
1852         address to,
1853         uint256 tokenId
1854     ) public virtual override {
1855         //solhint-disable-next-line max-line-length
1856         require(
1857             _isApprovedOrOwner(_msgSender(), tokenId),
1858             "ERC721: transfer caller is not owner nor approved"
1859         );
1860 
1861         _transfer(from, to, tokenId);
1862     }
1863 
1864     /**
1865      * @dev See {IERC721-safeTransferFrom}.
1866      */
1867     function safeTransferFrom(
1868         address from,
1869         address to,
1870         uint256 tokenId
1871     ) public virtual override {
1872         safeTransferFrom(from, to, tokenId, "");
1873     }
1874 
1875     /**
1876      * @dev See {IERC721-safeTransferFrom}.
1877      */
1878     function safeTransferFrom(
1879         address from,
1880         address to,
1881         uint256 tokenId,
1882         bytes memory _data
1883     ) public virtual override {
1884         require(
1885             _isApprovedOrOwner(_msgSender(), tokenId),
1886             "ERC721: transfer caller is not owner nor approved"
1887         );
1888         _safeTransfer(from, to, tokenId, _data);
1889     }
1890 
1891     /**
1892      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1893      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1894      *
1895      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1896      *
1897      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1898      * implement alternative mechanisms to perform token transfer, such as signature-based.
1899      *
1900      * Requirements:
1901      *
1902      * - `from` cannot be the zero address.
1903      * - `to` cannot be the zero address.
1904      * - `tokenId` token must exist and be owned by `from`.
1905      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1906      *
1907      * Emits a {Transfer} event.
1908      */
1909     function _safeTransfer(
1910         address from,
1911         address to,
1912         uint256 tokenId,
1913         bytes memory _data
1914     ) internal virtual {
1915         _transfer(from, to, tokenId);
1916         require(
1917             _checkOnERC721Received(from, to, tokenId, _data),
1918             "ERC721: transfer to non ERC721Receiver implementer"
1919         );
1920     }
1921 
1922     /**
1923      * @dev Returns whether `tokenId` exists.
1924      *
1925      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1926      *
1927      * Tokens start existing when they are minted (`_mint`),
1928      * and stop existing when they are burned (`_burn`).
1929      */
1930     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1931         return _tokenOwners.contains(tokenId);
1932     }
1933 
1934     /**
1935      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1936      *
1937      * Requirements:
1938      *
1939      * - `tokenId` must exist.
1940      */
1941     function _isApprovedOrOwner(address spender, uint256 tokenId)
1942         internal
1943         view
1944         virtual
1945         returns (bool)
1946     {
1947         require(
1948             _exists(tokenId),
1949             "ERC721: operator query for nonexistent token"
1950         );
1951         address owner = ERC721.ownerOf(tokenId);
1952         return (spender == owner ||
1953             getApproved(tokenId) == spender ||
1954             ERC721.isApprovedForAll(owner, spender));
1955     }
1956 
1957     /**
1958      * @dev Safely mints `tokenId` and transfers it to `to`.
1959      *
1960      * Requirements:
1961      d*
1962      * - `tokenId` must not exist.
1963      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1964      *
1965      * Emits a {Transfer} event.
1966      */
1967     function _safeMint(address to, uint256 tokenId) internal virtual {
1968         _safeMint(to, tokenId, "");
1969     }
1970 
1971     /**
1972      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1973      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1974      */
1975     function _safeMint(
1976         address to,
1977         uint256 tokenId,
1978         bytes memory _data
1979     ) internal virtual {
1980         _mint(to, tokenId);
1981         require(
1982             _checkOnERC721Received(address(0), to, tokenId, _data),
1983             "ERC721: transfer to non ERC721Receiver implementer"
1984         );
1985     }
1986 
1987     /**
1988      * @dev Mints `tokenId` and transfers it to `to`.
1989      *
1990      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1991      *
1992      * Requirements:
1993      *
1994      * - `tokenId` must not exist.
1995      * - `to` cannot be the zero address.
1996      *
1997      * Emits a {Transfer} event.
1998      */
1999     function _mint(address to, uint256 tokenId) internal virtual {
2000         require(to != address(0), "ERC721: mint to the zero address");
2001         require(!_exists(tokenId), "ERC721: token already minted");
2002 
2003         _beforeTokenTransfer(address(0), to, tokenId);
2004 
2005         _holderTokens[to].add(tokenId);
2006 
2007         _tokenOwners.set(tokenId, to);
2008 
2009         emit Transfer(address(0), to, tokenId);
2010     }
2011 
2012     /**
2013      * @dev Destroys `tokenId`.
2014      * The approval is cleared when the token is burned.
2015      *
2016      * Requirements:
2017      *
2018      * - `tokenId` must exist.
2019      *
2020      * Emits a {Transfer} event.
2021      */
2022     function _burn(uint256 tokenId) internal virtual {
2023         address owner = ERC721.ownerOf(tokenId); // internal owner
2024 
2025         _beforeTokenTransfer(owner, address(0), tokenId);
2026 
2027         // Clear approvals
2028         _approve(address(0), tokenId);
2029 
2030         // Clear metadata (if any)
2031         if (bytes(_tokenURIs[tokenId]).length != 0) {
2032             delete _tokenURIs[tokenId];
2033         }
2034 
2035         _holderTokens[owner].remove(tokenId);
2036 
2037         _tokenOwners.remove(tokenId);
2038 
2039         emit Transfer(owner, address(0), tokenId);
2040     }
2041 
2042     /**
2043      * @dev Transfers `tokenId` from `from` to `to`.
2044      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2045      *
2046      * Requirements:
2047      *
2048      * - `to` cannot be the zero address.
2049      * - `tokenId` token must be owned by `from`.
2050      *
2051      * Emits a {Transfer} event.
2052      */
2053     function _transfer(
2054         address from,
2055         address to,
2056         uint256 tokenId
2057     ) internal virtual {
2058         require(
2059             ERC721.ownerOf(tokenId) == from,
2060             "ERC721: transfer of token that is not own"
2061         ); // internal owner
2062         require(to != address(0), "ERC721: transfer to the zero address");
2063 
2064         _beforeTokenTransfer(from, to, tokenId);
2065 
2066         // Clear approvals from the previous owner
2067         _approve(address(0), tokenId);
2068 
2069         _holderTokens[from].remove(tokenId);
2070         _holderTokens[to].add(tokenId);
2071 
2072         _tokenOwners.set(tokenId, to);
2073 
2074         emit Transfer(from, to, tokenId);
2075     }
2076 
2077     /**
2078      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
2079      *
2080      * Requirements:
2081      *
2082      * - `tokenId` must exist.
2083      */
2084     function _setTokenURI(uint256 tokenId, string memory _tokenURI)
2085         internal
2086         virtual
2087     {
2088         require(
2089             _exists(tokenId),
2090             "ERC721Metadata: URI set of nonexistent token"
2091         );
2092         _tokenURIs[tokenId] = _tokenURI;
2093     }
2094 
2095     /**
2096      * @dev Internal function to set the base URI for all token IDs. It is
2097      * automatically added as a prefix to the value returned in {tokenURI},
2098      * or to the token ID if {tokenURI} is empty.
2099      */
2100     function _setBaseURI(string memory baseURI_) internal virtual {
2101         _baseURI = baseURI_;
2102     }
2103 
2104     /**
2105      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2106      * The call is not executed if the target address is not a contract.
2107      *
2108      * @param from address representing the previous owner of the given token ID
2109      * @param to target address that will receive the tokens
2110      * @param tokenId uint256 ID of the token to be transferred
2111      * @param _data bytes optional data to send along with the call
2112      * @return bool whether the call correctly returned the expected magic value
2113      */
2114     function _checkOnERC721Received(
2115         address from,
2116         address to,
2117         uint256 tokenId,
2118         bytes memory _data
2119     ) private returns (bool) {
2120         if (!to.isContract()) {
2121             return true;
2122         }
2123         bytes memory returndata = to.functionCall(
2124             abi.encodeWithSelector(
2125                 IERC721Receiver(to).onERC721Received.selector,
2126                 _msgSender(),
2127                 from,
2128                 tokenId,
2129                 _data
2130             ),
2131             "ERC721: transfer to non ERC721Receiver implementer"
2132         );
2133         bytes4 retval = abi.decode(returndata, (bytes4));
2134         return (retval == _ERC721_RECEIVED);
2135     }
2136 
2137     /**
2138      * @dev Approve `to` to operate on `tokenId`
2139      *
2140      * Emits an {Approval} event.
2141      */
2142     function _approve(address to, uint256 tokenId) internal virtual {
2143         _tokenApprovals[tokenId] = to;
2144         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
2145     }
2146 
2147     /**
2148      * @dev Hook that is called before any token transfer. This includes minting
2149      * and burning.
2150      *
2151      * Calling conditions:
2152      *
2153      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2154      * transferred to `to`.
2155      * - When `from` is zero, `tokenId` will be minted for `to`.
2156      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2157      * - `from` cannot be the zero address.
2158      * - `to` cannot be the zero address.
2159      *
2160      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2161      */
2162     function _beforeTokenTransfer(
2163         address from,
2164         address to,
2165         uint256 tokenId
2166     ) internal virtual {}
2167 }
2168 
2169 // File: @openzeppelin/contracts/access/Ownable.sol
2170 
2171 pragma solidity >=0.6.0 <0.8.0;
2172 
2173 /**
2174  * @dev Contract module which provides a basic access control mechanism, where
2175  * there is an account (an owner) that can be granted exclusive access to
2176  * specific functions.
2177  *
2178  * By default, the owner account will be the one that deploys the contract. This
2179  * can later be changed with {transferOwnership}.
2180  *
2181  * This module is used through inheritance. It will make available the modifier
2182  * `onlyOwner`, which can be applied to your functions to restrict their use to
2183  * the owner.
2184  */
2185 abstract contract Ownable is Context {
2186     address private _owner;
2187 
2188     event OwnershipTransferred(
2189         address indexed previousOwner,
2190         address indexed newOwner
2191     );
2192 
2193     /**
2194      * @dev Initializes the contract setting the deployer as the initial owner.
2195      */
2196     constructor() internal {
2197         address msgSender = _msgSender();
2198         _owner = msgSender;
2199         emit OwnershipTransferred(address(0), msgSender);
2200     }
2201 
2202     /**
2203      * @dev Returns the address of the current owner.
2204      */
2205     function owner() public view virtual returns (address) {
2206         return _owner;
2207     }
2208 
2209     /**
2210      * @dev Throws if called by any account other than the owner.
2211      */
2212     modifier onlyOwner() {
2213         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2214         _;
2215     }
2216 
2217     /**
2218      * @dev Leaves the contract without owner. It will not be possible to call
2219      * `onlyOwner` functions anymore. Can only be called by the current owner.
2220      *
2221      * NOTE: Renouncing ownership will leave the contract without an owner,
2222      * thereby removing any functionality that is only available to the owner.
2223      */
2224     function renounceOwnership() public virtual onlyOwner {
2225         emit OwnershipTransferred(_owner, address(0));
2226         _owner = address(0);
2227     }
2228 
2229     /**
2230      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2231      * Can only be called by the current owner.
2232      */
2233     function transferOwnership(address newOwner) public virtual onlyOwner {
2234         require(
2235             newOwner != address(0),
2236             "Ownable: new owner is the zero address"
2237         );
2238         emit OwnershipTransferred(_owner, newOwner);
2239         _owner = newOwner;
2240     }
2241 }
2242 
2243 // Contract based on https://docs.openzeppelin.com/contracts/3.x/erc721
2244 // SPDX-License-Identifier: MIT
2245 pragma solidity >=0.7.6;
2246 
2247 contract CryptoTuners is ERC721, Ownable {
2248     using SafeMath for uint256;
2249 
2250     string public TUNER_PROVENANCE = "";
2251 
2252     uint256 public constant MAX_CARS = 5000; //5000 max cars(tokens)
2253 
2254     uint256 public constant MAX_CARS_PER_PURCHASE = 20; //20 cars per tx
2255 
2256     uint256 private price = 30000000000000000; // 0.03 Eth
2257 
2258     bool public isSaleActive = false;
2259 
2260     constructor() ERC721("CryptoTuners", "CAR") {}
2261 
2262     function setProvenanceHash(string memory _provenanceHash) public onlyOwner {
2263         TUNER_PROVENANCE = _provenanceHash;
2264     }
2265 
2266     //reserve tokens for the team, this will be in the region on 50
2267     function reserveTokens(address _to, uint256 _reserveAmount)
2268         public
2269         onlyOwner
2270     {
2271         uint256 supply = totalSupply();
2272         for (uint256 i = 0; i < _reserveAmount; i++) {
2273             _safeMint(_to, supply + i);
2274         }
2275     }
2276 
2277     //mint function
2278     function mint(uint256 _count) public payable {
2279         uint256 totalSupply = totalSupply();
2280 
2281         require(isSaleActive, "Sale is not active");
2282         require(
2283             _count > 0 && _count < MAX_CARS_PER_PURCHASE + 1,
2284             "Exceeds maximum cars you can purchase in a single transaction"
2285         );
2286         require(
2287             totalSupply + _count < MAX_CARS + 1,
2288             "Exceeds maximum cars available for purchase"
2289         );
2290         require(
2291             msg.value >= price.mul(_count),
2292             "Ether value sent is incorrect"
2293         );
2294 
2295         for (uint256 i = 0; i < _count; i++) {
2296             _safeMint(msg.sender, totalSupply + i);
2297         }
2298     }
2299 
2300     //set URI for metadata
2301     function setBaseURI(string memory _baseURI) public onlyOwner {
2302         _setBaseURI(_baseURI);
2303     }
2304 
2305     function flipSaleStatus() public onlyOwner {
2306         isSaleActive = !isSaleActive;
2307     }
2308 
2309     function setPrice(uint256 _newPrice) public onlyOwner {
2310         price = _newPrice;
2311     }
2312 
2313     function getPrice() public view returns (uint256) {
2314         return price;
2315     }
2316 
2317     function withdraw() public onlyOwner {
2318         uint256 balance = address(this).balance;
2319         msg.sender.transfer(balance);
2320     }
2321 
2322     function tokensByOwner(address _owner)
2323         external
2324         view
2325         returns (uint256[] memory)
2326     {
2327         uint256 tokenCount = balanceOf(_owner);
2328         if (tokenCount == 0) {
2329             return new uint256[](0);
2330         } else {
2331             uint256[] memory result = new uint256[](tokenCount);
2332             uint256 index;
2333             for (index = 0; index < tokenCount; index++) {
2334                 result[index] = tokenOfOwnerByIndex(_owner, index);
2335             }
2336             return result;
2337         }
2338     }
2339 }