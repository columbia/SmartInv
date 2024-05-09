1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-15
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // File: @openzeppelin/contracts/utils/Context.sol
8 
9 pragma solidity >=0.6.0 <0.8.0;
10 
11 /*
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with GSN meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address payable) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 // File: @openzeppelin/contracts/introspection/IERC165.sol
33 
34 pragma solidity >=0.6.0 <0.8.0;
35 
36 /**
37  * @dev Interface of the ERC165 standard, as defined in the
38  * https://eips.ethereum.org/EIPS/eip-165[EIP].
39  *
40  * Implementers can declare support of contract interfaces, which can then be
41  * queried by others ({ERC165Checker}).
42  *
43  * For an implementation, see {ERC165}.
44  */
45 interface IERC165 {
46     /**
47      * @dev Returns true if this contract implements the interface defined by
48      * `interfaceId`. See the corresponding
49      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
50      * to learn more about how these ids are created.
51      *
52      * This function call must use less than 30 000 gas.
53      */
54     function supportsInterface(bytes4 interfaceId) external view returns (bool);
55 }
56 
57 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
58 
59 pragma solidity >=0.6.2 <0.8.0;
60 
61 /**
62  * @dev Required interface of an ERC721 compliant contract.
63  */
64 interface IERC721 is IERC165 {
65     /**
66      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
67      */
68     event Transfer(
69         address indexed from,
70         address indexed to,
71         uint256 indexed tokenId
72     );
73 
74     /**
75      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
76      */
77     event Approval(
78         address indexed owner,
79         address indexed approved,
80         uint256 indexed tokenId
81     );
82 
83     /**
84      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
85      */
86     event ApprovalForAll(
87         address indexed owner,
88         address indexed operator,
89         bool approved
90     );
91 
92     /**
93      * @dev Returns the number of tokens in ``owner``'s account.
94      */
95     function balanceOf(address owner) external view returns (uint256 balance);
96 
97     /**
98      * @dev Returns the owner of the `tokenId` token.
99      *
100      * Requirements:
101      *
102      * - `tokenId` must exist.
103      */
104     function ownerOf(uint256 tokenId) external view returns (address owner);
105 
106     /**
107      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
108      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
109      *
110      * Requirements:
111      *
112      * - `from` cannot be the zero address.
113      * - `to` cannot be the zero address.
114      * - `tokenId` token must exist and be owned by `from`.
115      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
116      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
117      *
118      * Emits a {Transfer} event.
119      */
120     function safeTransferFrom(
121         address from,
122         address to,
123         uint256 tokenId
124     ) external;
125 
126     /**
127      * @dev Transfers `tokenId` token from `from` to `to`.
128      *
129      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
130      *
131      * Requirements:
132      *
133      * - `from` cannot be the zero address.
134      * - `to` cannot be the zero address.
135      * - `tokenId` token must be owned by `from`.
136      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
137      *
138      * Emits a {Transfer} event.
139      */
140     function transferFrom(
141         address from,
142         address to,
143         uint256 tokenId
144     ) external;
145 
146     /**
147      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
148      * The approval is cleared when the token is transferred.
149      *
150      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
151      *
152      * Requirements:
153      *
154      * - The caller must own the token or be an approved operator.
155      * - `tokenId` must exist.
156      *
157      * Emits an {Approval} event.
158      */
159     function approve(address to, uint256 tokenId) external;
160 
161     /**
162      * @dev Returns the account approved for `tokenId` token.
163      *
164      * Requirements:
165      *
166      * - `tokenId` must exist.
167      */
168     function getApproved(uint256 tokenId)
169         external
170         view
171         returns (address operator);
172 
173     /**
174      * @dev Approve or remove `operator` as an operator for the caller.
175      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
176      *
177      * Requirements:
178      *
179      * - The `operator` cannot be the caller.
180      *
181      * Emits an {ApprovalForAll} event.
182      */
183     function setApprovalForAll(address operator, bool _approved) external;
184 
185     /**
186      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
187      *
188      * See {setApprovalForAll}
189      */
190     function isApprovedForAll(address owner, address operator)
191         external
192         view
193         returns (bool);
194 
195     /**
196      * @dev Safely transfers `tokenId` token from `from` to `to`.
197      *
198      * Requirements:
199      *
200      * - `from` cannot be the zero address.
201      * - `to` cannot be the zero address.
202      * - `tokenId` token must exist and be owned by `from`.
203      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
204      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
205      *
206      * Emits a {Transfer} event.
207      */
208     function safeTransferFrom(
209         address from,
210         address to,
211         uint256 tokenId,
212         bytes calldata data
213     ) external;
214 }
215 
216 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
217 
218 pragma solidity >=0.6.2 <0.8.0;
219 
220 /**
221  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
222  * @dev See https://eips.ethereum.org/EIPS/eip-721
223  */
224 interface IERC721Metadata is IERC721 {
225     /**
226      * @dev Returns the token collection name.
227      */
228     function name() external view returns (string memory);
229 
230     /**
231      * @dev Returns the token collection symbol.
232      */
233     function symbol() external view returns (string memory);
234 
235     /**
236      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
237      */
238     function tokenURI(uint256 tokenId) external view returns (string memory);
239 }
240 
241 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
242 
243 pragma solidity >=0.6.2 <0.8.0;
244 
245 /**
246  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
247  * @dev See https://eips.ethereum.org/EIPS/eip-721
248  */
249 interface IERC721Enumerable is IERC721 {
250     /**
251      * @dev Returns the total amount of tokens stored by the contract.
252      */
253     function totalSupply() external view returns (uint256);
254 
255     /**
256      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
257      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
258      */
259     function tokenOfOwnerByIndex(address owner, uint256 index)
260         external
261         view
262         returns (uint256 tokenId);
263 
264     /**
265      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
266      * Use along with {totalSupply} to enumerate all tokens.
267      */
268     function tokenByIndex(uint256 index) external view returns (uint256);
269 }
270 
271 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
272 
273 pragma solidity >=0.6.0 <0.8.0;
274 
275 /**
276  * @title ERC721 token receiver interface
277  * @dev Interface for any contract that wants to support safeTransfers
278  * from ERC721 asset contracts.
279  */
280 interface IERC721Receiver {
281     /**
282      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
283      * by `operator` from `from`, this function is called.
284      *
285      * It must return its Solidity selector to confirm the token transfer.
286      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
287      *
288      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
289      */
290     function onERC721Received(
291         address operator,
292         address from,
293         uint256 tokenId,
294         bytes calldata data
295     ) external returns (bytes4);
296 }
297 
298 // File: @openzeppelin/contracts/introspection/ERC165.sol
299 
300 pragma solidity >=0.6.0 <0.8.0;
301 
302 /**
303  * @dev Implementation of the {IERC165} interface.
304  *
305  * Contracts may inherit from this and call {_registerInterface} to declare
306  * their support of an interface.
307  */
308 abstract contract ERC165 is IERC165 {
309     /*
310      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
311      */
312     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
313 
314     /**
315      * @dev Mapping of interface ids to whether or not it's supported.
316      */
317     mapping(bytes4 => bool) private _supportedInterfaces;
318 
319     constructor() {
320         // Derived contracts need only register support for their own interfaces,
321         // we register support for ERC165 itself here
322         _registerInterface(_INTERFACE_ID_ERC165);
323     }
324 
325     /**
326      * @dev See {IERC165-supportsInterface}.
327      *
328      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
329      */
330     function supportsInterface(bytes4 interfaceId)
331         public
332         view
333         virtual
334         override
335         returns (bool)
336     {
337         return _supportedInterfaces[interfaceId];
338     }
339 
340     /**
341      * @dev Registers the contract as an implementer of the interface defined by
342      * `interfaceId`. Support of the actual ERC165 interface is automatic and
343      * registering its interface id is not required.
344      *
345      * See {IERC165-supportsInterface}.
346      *
347      * Requirements:
348      *
349      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
350      */
351     function _registerInterface(bytes4 interfaceId) internal virtual {
352         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
353         _supportedInterfaces[interfaceId] = true;
354     }
355 }
356 
357 // File: @openzeppelin/contracts/math/SafeMath.sol
358 
359 pragma solidity >=0.6.0 <0.8.0;
360 
361 /**
362  * @dev Wrappers over Solidity's arithmetic operations with added overflow
363  * checks.
364  *
365  * Arithmetic operations in Solidity wrap on overflow. This can easily result
366  * in bugs, because programmers usually assume that an overflow raises an
367  * error, which is the standard behavior in high level programming languages.
368  * `SafeMath` restores this intuition by reverting the transaction when an
369  * operation overflows.
370  *
371  * Using this library instead of the unchecked operations eliminates an entire
372  * class of bugs, so it's recommended to use it always.
373  */
374 library SafeMath {
375     /**
376      * @dev Returns the addition of two unsigned integers, with an overflow flag.
377      *
378      * _Available since v3.4._
379      */
380     function tryAdd(uint256 a, uint256 b)
381         internal
382         pure
383         returns (bool, uint256)
384     {
385         uint256 c = a + b;
386         if (c < a) return (false, 0);
387         return (true, c);
388     }
389 
390     /**
391      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
392      *
393      * _Available since v3.4._
394      */
395     function trySub(uint256 a, uint256 b)
396         internal
397         pure
398         returns (bool, uint256)
399     {
400         if (b > a) return (false, 0);
401         return (true, a - b);
402     }
403 
404     /**
405      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
406      *
407      * _Available since v3.4._
408      */
409     function tryMul(uint256 a, uint256 b)
410         internal
411         pure
412         returns (bool, uint256)
413     {
414         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
415         // benefit is lost if 'b' is also tested.
416         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
417         if (a == 0) return (true, 0);
418         uint256 c = a * b;
419         if (c / a != b) return (false, 0);
420         return (true, c);
421     }
422 
423     /**
424      * @dev Returns the division of two unsigned integers, with a division by zero flag.
425      *
426      * _Available since v3.4._
427      */
428     function tryDiv(uint256 a, uint256 b)
429         internal
430         pure
431         returns (bool, uint256)
432     {
433         if (b == 0) return (false, 0);
434         return (true, a / b);
435     }
436 
437     /**
438      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
439      *
440      * _Available since v3.4._
441      */
442     function tryMod(uint256 a, uint256 b)
443         internal
444         pure
445         returns (bool, uint256)
446     {
447         if (b == 0) return (false, 0);
448         return (true, a % b);
449     }
450 
451     /**
452      * @dev Returns the addition of two unsigned integers, reverting on
453      * overflow.
454      *
455      * Counterpart to Solidity's `+` operator.
456      *
457      * Requirements:
458      *
459      * - Addition cannot overflow.
460      */
461     function add(uint256 a, uint256 b) internal pure returns (uint256) {
462         uint256 c = a + b;
463         require(c >= a, "SafeMath: addition overflow");
464         return c;
465     }
466 
467     /**
468      * @dev Returns the subtraction of two unsigned integers, reverting on
469      * overflow (when the result is negative).
470      *
471      * Counterpart to Solidity's `-` operator.
472      *
473      * Requirements:
474      *
475      * - Subtraction cannot overflow.
476      */
477     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
478         require(b <= a, "SafeMath: subtraction overflow");
479         return a - b;
480     }
481 
482     /**
483      * @dev Returns the multiplication of two unsigned integers, reverting on
484      * overflow.
485      *
486      * Counterpart to Solidity's `*` operator.
487      *
488      * Requirements:
489      *
490      * - Multiplication cannot overflow.
491      */
492     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
493         if (a == 0) return 0;
494         uint256 c = a * b;
495         require(c / a == b, "SafeMath: multiplication overflow");
496         return c;
497     }
498 
499     /**
500      * @dev Returns the integer division of two unsigned integers, reverting on
501      * division by zero. The result is rounded towards zero.
502      *
503      * Counterpart to Solidity's `/` operator. Note: this function uses a
504      * `revert` opcode (which leaves remaining gas untouched) while Solidity
505      * uses an invalid opcode to revert (consuming all remaining gas).
506      *
507      * Requirements:
508      *
509      * - The divisor cannot be zero.
510      */
511     function div(uint256 a, uint256 b) internal pure returns (uint256) {
512         require(b > 0, "SafeMath: division by zero");
513         return a / b;
514     }
515 
516     /**
517      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
518      * reverting when dividing by zero.
519      *
520      * Counterpart to Solidity's `%` operator. This function uses a `revert`
521      * opcode (which leaves remaining gas untouched) while Solidity uses an
522      * invalid opcode to revert (consuming all remaining gas).
523      *
524      * Requirements:
525      *
526      * - The divisor cannot be zero.
527      */
528     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
529         require(b > 0, "SafeMath: modulo by zero");
530         return a % b;
531     }
532 
533     /**
534      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
535      * overflow (when the result is negative).
536      *
537      * CAUTION: This function is deprecated because it requires allocating memory for the error
538      * message unnecessarily. For custom revert reasons use {trySub}.
539      *
540      * Counterpart to Solidity's `-` operator.
541      *
542      * Requirements:
543      *
544      * - Subtraction cannot overflow.
545      */
546     function sub(
547         uint256 a,
548         uint256 b,
549         string memory errorMessage
550     ) internal pure returns (uint256) {
551         require(b <= a, errorMessage);
552         return a - b;
553     }
554 
555     /**
556      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
557      * division by zero. The result is rounded towards zero.
558      *
559      * CAUTION: This function is deprecated because it requires allocating memory for the error
560      * message unnecessarily. For custom revert reasons use {tryDiv}.
561      *
562      * Counterpart to Solidity's `/` operator. Note: this function uses a
563      * `revert` opcode (which leaves remaining gas untouched) while Solidity
564      * uses an invalid opcode to revert (consuming all remaining gas).
565      *
566      * Requirements:
567      *
568      * - The divisor cannot be zero.
569      */
570     function div(
571         uint256 a,
572         uint256 b,
573         string memory errorMessage
574     ) internal pure returns (uint256) {
575         require(b > 0, errorMessage);
576         return a / b;
577     }
578 
579     /**
580      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
581      * reverting with custom message when dividing by zero.
582      *
583      * CAUTION: This function is deprecated because it requires allocating memory for the error
584      * message unnecessarily. For custom revert reasons use {tryMod}.
585      *
586      * Counterpart to Solidity's `%` operator. This function uses a `revert`
587      * opcode (which leaves remaining gas untouched) while Solidity uses an
588      * invalid opcode to revert (consuming all remaining gas).
589      *
590      * Requirements:
591      *
592      * - The divisor cannot be zero.
593      */
594     function mod(
595         uint256 a,
596         uint256 b,
597         string memory errorMessage
598     ) internal pure returns (uint256) {
599         require(b > 0, errorMessage);
600         return a % b;
601     }
602 }
603 
604 // File: @openzeppelin/contracts/utils/Address.sol
605 
606 pragma solidity >=0.6.2 <0.8.0;
607 
608 /**
609  * @dev Collection of functions related to the address type
610  */
611 library Address {
612     /**
613      * @dev Returns true if `account` is a contract.
614      *
615      * [IMPORTANT]
616      * ====
617      * It is unsafe to assume that an address for which this function returns
618      * false is an externally-owned account (EOA) and not a contract.
619      *
620      * Among others, `isContract` will return false for the following
621      * types of addresses:
622      *
623      *  - an externally-owned account
624      *  - a contract in construction
625      *  - an address where a contract will be created
626      *  - an address where a contract lived, but was destroyed
627      * ====
628      */
629     function isContract(address account) internal view returns (bool) {
630         // This method relies on extcodesize, which returns 0 for contracts in
631         // construction, since the code is only stored at the end of the
632         // constructor execution.
633 
634         uint256 size;
635         // solhint-disable-next-line no-inline-assembly
636         assembly {
637             size := extcodesize(account)
638         }
639         return size > 0;
640     }
641 
642     /**
643      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
644      * `recipient`, forwarding all available gas and reverting on errors.
645      *
646      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
647      * of certain opcodes, possibly making contracts go over the 2300 gas limit
648      * imposed by `transfer`, making them unable to receive funds via
649      * `transfer`. {sendValue} removes this limitation.
650      *
651      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
652      *
653      * IMPORTANT: because control is transferred to `recipient`, care must be
654      * taken to not create reentrancy vulnerabilities. Consider using
655      * {ReentrancyGuard} or the
656      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
657      */
658     function sendValue(address payable recipient, uint256 amount) internal {
659         require(
660             address(this).balance >= amount,
661             "Address: insufficient balance"
662         );
663 
664         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
665         (bool success, ) = recipient.call{value: amount}("");
666         require(
667             success,
668             "Address: unable to send value, recipient may have reverted"
669         );
670     }
671 
672     /**
673      * @dev Performs a Solidity function call using a low level `call`. A
674      * plain`call` is an unsafe replacement for a function call: use this
675      * function instead.
676      *
677      * If `target` reverts with a revert reason, it is bubbled up by this
678      * function (like regular Solidity function calls).
679      *
680      * Returns the raw returned data. To convert to the expected return value,
681      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
682      *
683      * Requirements:
684      *
685      * - `target` must be a contract.
686      * - calling `target` with `data` must not revert.
687      *
688      * _Available since v3.1._
689      */
690     function functionCall(address target, bytes memory data)
691         internal
692         returns (bytes memory)
693     {
694         return functionCall(target, data, "Address: low-level call failed");
695     }
696 
697     /**
698      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
699      * `errorMessage` as a fallback revert reason when `target` reverts.
700      *
701      * _Available since v3.1._
702      */
703     function functionCall(
704         address target,
705         bytes memory data,
706         string memory errorMessage
707     ) internal returns (bytes memory) {
708         return functionCallWithValue(target, data, 0, errorMessage);
709     }
710 
711     /**
712      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
713      * but also transferring `value` wei to `target`.
714      *
715      * Requirements:
716      *
717      * - the calling contract must have an ETH balance of at least `value`.
718      * - the called Solidity function must be `payable`.
719      *
720      * _Available since v3.1._
721      */
722     function functionCallWithValue(
723         address target,
724         bytes memory data,
725         uint256 value
726     ) internal returns (bytes memory) {
727         return
728             functionCallWithValue(
729                 target,
730                 data,
731                 value,
732                 "Address: low-level call with value failed"
733             );
734     }
735 
736     /**
737      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
738      * with `errorMessage` as a fallback revert reason when `target` reverts.
739      *
740      * _Available since v3.1._
741      */
742     function functionCallWithValue(
743         address target,
744         bytes memory data,
745         uint256 value,
746         string memory errorMessage
747     ) internal returns (bytes memory) {
748         require(
749             address(this).balance >= value,
750             "Address: insufficient balance for call"
751         );
752         require(isContract(target), "Address: call to non-contract");
753 
754         // solhint-disable-next-line avoid-low-level-calls
755         (bool success, bytes memory returndata) = target.call{value: value}(
756             data
757         );
758         return _verifyCallResult(success, returndata, errorMessage);
759     }
760 
761     /**
762      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
763      * but performing a static call.
764      *
765      * _Available since v3.3._
766      */
767     function functionStaticCall(address target, bytes memory data)
768         internal
769         view
770         returns (bytes memory)
771     {
772         return
773             functionStaticCall(
774                 target,
775                 data,
776                 "Address: low-level static call failed"
777             );
778     }
779 
780     /**
781      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
782      * but performing a static call.
783      *
784      * _Available since v3.3._
785      */
786     function functionStaticCall(
787         address target,
788         bytes memory data,
789         string memory errorMessage
790     ) internal view returns (bytes memory) {
791         require(isContract(target), "Address: static call to non-contract");
792 
793         // solhint-disable-next-line avoid-low-level-calls
794         (bool success, bytes memory returndata) = target.staticcall(data);
795         return _verifyCallResult(success, returndata, errorMessage);
796     }
797 
798     /**
799      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
800      * but performing a delegate call.
801      *
802      * _Available since v3.4._
803      */
804     function functionDelegateCall(address target, bytes memory data)
805         internal
806         returns (bytes memory)
807     {
808         return
809             functionDelegateCall(
810                 target,
811                 data,
812                 "Address: low-level delegate call failed"
813             );
814     }
815 
816     /**
817      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
818      * but performing a delegate call.
819      *
820      * _Available since v3.4._
821      */
822     function functionDelegateCall(
823         address target,
824         bytes memory data,
825         string memory errorMessage
826     ) internal returns (bytes memory) {
827         require(isContract(target), "Address: delegate call to non-contract");
828 
829         // solhint-disable-next-line avoid-low-level-calls
830         (bool success, bytes memory returndata) = target.delegatecall(data);
831         return _verifyCallResult(success, returndata, errorMessage);
832     }
833 
834     function _verifyCallResult(
835         bool success,
836         bytes memory returndata,
837         string memory errorMessage
838     ) private pure returns (bytes memory) {
839         if (success) {
840             return returndata;
841         } else {
842             // Look for revert reason and bubble it up if present
843             if (returndata.length > 0) {
844                 // The easiest way to bubble the revert reason is using memory via assembly
845 
846                 // solhint-disable-next-line no-inline-assembly
847                 assembly {
848                     let returndata_size := mload(returndata)
849                     revert(add(32, returndata), returndata_size)
850                 }
851             } else {
852                 revert(errorMessage);
853             }
854         }
855     }
856 }
857 
858 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
859 
860 pragma solidity >=0.6.0 <0.8.0;
861 
862 /**
863  * @dev Library for managing
864  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
865  * types.
866  *
867  * Sets have the following properties:
868  *
869  * - Elements are added, removed, and checked for existence in constant time
870  * (O(1)).
871  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
872  *
873  * ```
874  * contract Example {
875  *     // Add the library methods
876  *     using EnumerableSet for EnumerableSet.AddressSet;
877  *
878  *     // Declare a set state variable
879  *     EnumerableSet.AddressSet private mySet;
880  * }
881  * ```
882  *
883  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
884  * and `uint256` (`UintSet`) are supported.
885  */
886 library EnumerableSet {
887     // To implement this library for multiple types with as little code
888     // repetition as possible, we write it in terms of a generic Set type with
889     // bytes32 values.
890     // The Set implementation uses private functions, and user-facing
891     // implementations (such as AddressSet) are just wrappers around the
892     // underlying Set.
893     // This means that we can only create new EnumerableSets for types that fit
894     // in bytes32.
895 
896     struct Set {
897         // Storage of set values
898         bytes32[] _values;
899         // Position of the value in the `values` array, plus 1 because index 0
900         // means a value is not in the set.
901         mapping(bytes32 => uint256) _indexes;
902     }
903 
904     /**
905      * @dev Add a value to a set. O(1).
906      *
907      * Returns true if the value was added to the set, that is if it was not
908      * already present.
909      */
910     function _add(Set storage set, bytes32 value) private returns (bool) {
911         if (!_contains(set, value)) {
912             set._values.push(value);
913             // The value is stored at length-1, but we add 1 to all indexes
914             // and use 0 as a sentinel value
915             set._indexes[value] = set._values.length;
916             return true;
917         } else {
918             return false;
919         }
920     }
921 
922     /**
923      * @dev Removes a value from a set. O(1).
924      *
925      * Returns true if the value was removed from the set, that is if it was
926      * present.
927      */
928     function _remove(Set storage set, bytes32 value) private returns (bool) {
929         // We read and store the value's index to prevent multiple reads from the same storage slot
930         uint256 valueIndex = set._indexes[value];
931 
932         if (valueIndex != 0) {
933             // Equivalent to contains(set, value)
934             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
935             // the array, and then remove the last element (sometimes called as 'swap and pop').
936             // This modifies the order of the array, as noted in {at}.
937 
938             uint256 toDeleteIndex = valueIndex - 1;
939             uint256 lastIndex = set._values.length - 1;
940 
941             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
942             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
943 
944             bytes32 lastvalue = set._values[lastIndex];
945 
946             // Move the last value to the index where the value to delete is
947             set._values[toDeleteIndex] = lastvalue;
948             // Update the index for the moved value
949             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
950 
951             // Delete the slot where the moved value was stored
952             set._values.pop();
953 
954             // Delete the index for the deleted slot
955             delete set._indexes[value];
956 
957             return true;
958         } else {
959             return false;
960         }
961     }
962 
963     /**
964      * @dev Returns true if the value is in the set. O(1).
965      */
966     function _contains(Set storage set, bytes32 value)
967         private
968         view
969         returns (bool)
970     {
971         return set._indexes[value] != 0;
972     }
973 
974     /**
975      * @dev Returns the number of values on the set. O(1).
976      */
977     function _length(Set storage set) private view returns (uint256) {
978         return set._values.length;
979     }
980 
981     /**
982      * @dev Returns the value stored at position `index` in the set. O(1).
983      *
984      * Note that there are no guarantees on the ordering of values inside the
985      * array, and it may change when more values are added or removed.
986      *
987      * Requirements:
988      *
989      * - `index` must be strictly less than {length}.
990      */
991     function _at(Set storage set, uint256 index)
992         private
993         view
994         returns (bytes32)
995     {
996         require(
997             set._values.length > index,
998             "EnumerableSet: index out of bounds"
999         );
1000         return set._values[index];
1001     }
1002 
1003     // Bytes32Set
1004 
1005     struct Bytes32Set {
1006         Set _inner;
1007     }
1008 
1009     /**
1010      * @dev Add a value to a set. O(1).
1011      *
1012      * Returns true if the value was added to the set, that is if it was not
1013      * already present.
1014      */
1015     function add(Bytes32Set storage set, bytes32 value)
1016         internal
1017         returns (bool)
1018     {
1019         return _add(set._inner, value);
1020     }
1021 
1022     /**
1023      * @dev Removes a value from a set. O(1).
1024      *
1025      * Returns true if the value was removed from the set, that is if it was
1026      * present.
1027      */
1028     function remove(Bytes32Set storage set, bytes32 value)
1029         internal
1030         returns (bool)
1031     {
1032         return _remove(set._inner, value);
1033     }
1034 
1035     /**
1036      * @dev Returns true if the value is in the set. O(1).
1037      */
1038     function contains(Bytes32Set storage set, bytes32 value)
1039         internal
1040         view
1041         returns (bool)
1042     {
1043         return _contains(set._inner, value);
1044     }
1045 
1046     /**
1047      * @dev Returns the number of values in the set. O(1).
1048      */
1049     function length(Bytes32Set storage set) internal view returns (uint256) {
1050         return _length(set._inner);
1051     }
1052 
1053     /**
1054      * @dev Returns the value stored at position `index` in the set. O(1).
1055      *
1056      * Note that there are no guarantees on the ordering of values inside the
1057      * array, and it may change when more values are added or removed.
1058      *
1059      * Requirements:
1060      *
1061      * - `index` must be strictly less than {length}.
1062      */
1063     function at(Bytes32Set storage set, uint256 index)
1064         internal
1065         view
1066         returns (bytes32)
1067     {
1068         return _at(set._inner, index);
1069     }
1070 
1071     // AddressSet
1072 
1073     struct AddressSet {
1074         Set _inner;
1075     }
1076 
1077     /**
1078      * @dev Add a value to a set. O(1).
1079      *
1080      * Returns true if the value was added to the set, that is if it was not
1081      * already present.
1082      */
1083     function add(AddressSet storage set, address value)
1084         internal
1085         returns (bool)
1086     {
1087         return _add(set._inner, bytes32(uint256(uint160(value))));
1088     }
1089 
1090     /**
1091      * @dev Removes a value from a set. O(1).
1092      *
1093      * Returns true if the value was removed from the set, that is if it was
1094      * present.
1095      */
1096     function remove(AddressSet storage set, address value)
1097         internal
1098         returns (bool)
1099     {
1100         return _remove(set._inner, bytes32(uint256(uint160(value))));
1101     }
1102 
1103     /**
1104      * @dev Returns true if the value is in the set. O(1).
1105      */
1106     function contains(AddressSet storage set, address value)
1107         internal
1108         view
1109         returns (bool)
1110     {
1111         return _contains(set._inner, bytes32(uint256(uint160(value))));
1112     }
1113 
1114     /**
1115      * @dev Returns the number of values in the set. O(1).
1116      */
1117     function length(AddressSet storage set) internal view returns (uint256) {
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
1131     function at(AddressSet storage set, uint256 index)
1132         internal
1133         view
1134         returns (address)
1135     {
1136         return address(uint160(uint256(_at(set._inner, index))));
1137     }
1138 
1139     // UintSet
1140 
1141     struct UintSet {
1142         Set _inner;
1143     }
1144 
1145     /**
1146      * @dev Add a value to a set. O(1).
1147      *
1148      * Returns true if the value was added to the set, that is if it was not
1149      * already present.
1150      */
1151     function add(UintSet storage set, uint256 value) internal returns (bool) {
1152         return _add(set._inner, bytes32(value));
1153     }
1154 
1155     /**
1156      * @dev Removes a value from a set. O(1).
1157      *
1158      * Returns true if the value was removed from the set, that is if it was
1159      * present.
1160      */
1161     function remove(UintSet storage set, uint256 value)
1162         internal
1163         returns (bool)
1164     {
1165         return _remove(set._inner, bytes32(value));
1166     }
1167 
1168     /**
1169      * @dev Returns true if the value is in the set. O(1).
1170      */
1171     function contains(UintSet storage set, uint256 value)
1172         internal
1173         view
1174         returns (bool)
1175     {
1176         return _contains(set._inner, bytes32(value));
1177     }
1178 
1179     /**
1180      * @dev Returns the number of values on the set. O(1).
1181      */
1182     function length(UintSet storage set) internal view returns (uint256) {
1183         return _length(set._inner);
1184     }
1185 
1186     /**
1187      * @dev Returns the value stored at position `index` in the set. O(1).
1188      *
1189      * Note that there are no guarantees on the ordering of values inside the
1190      * array, and it may change when more values are added or removed.
1191      *
1192      * Requirements:
1193      *
1194      * - `index` must be strictly less than {length}.
1195      */
1196     function at(UintSet storage set, uint256 index)
1197         internal
1198         view
1199         returns (uint256)
1200     {
1201         return uint256(_at(set._inner, index));
1202     }
1203 }
1204 
1205 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1206 
1207 pragma solidity >=0.6.0 <0.8.0;
1208 
1209 /**
1210  * @dev Library for managing an enumerable variant of Solidity's
1211  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1212  * type.
1213  *
1214  * Maps have the following properties:
1215  *
1216  * - Entries are added, removed, and checked for existence in constant time
1217  * (O(1)).
1218  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1219  *
1220  * ```
1221  * contract Example {
1222  *     // Add the library methods
1223  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1224  *
1225  *     // Declare a set state variable
1226  *     EnumerableMap.UintToAddressMap private myMap;
1227  * }
1228  * ```
1229  *
1230  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1231  * supported.
1232  */
1233 library EnumerableMap {
1234     // To implement this library for multiple types with as little code
1235     // repetition as possible, we write it in terms of a generic Map type with
1236     // bytes32 keys and values.
1237     // The Map implementation uses private functions, and user-facing
1238     // implementations (such as Uint256ToAddressMap) are just wrappers around
1239     // the underlying Map.
1240     // This means that we can only create new EnumerableMaps for types that fit
1241     // in bytes32.
1242 
1243     struct MapEntry {
1244         bytes32 _key;
1245         bytes32 _value;
1246     }
1247 
1248     struct Map {
1249         // Storage of map keys and values
1250         MapEntry[] _entries;
1251         // Position of the entry defined by a key in the `entries` array, plus 1
1252         // because index 0 means a key is not in the map.
1253         mapping(bytes32 => uint256) _indexes;
1254     }
1255 
1256     /**
1257      * @dev Adds a key-value pair to a map, or updates the value for an existing
1258      * key. O(1).
1259      *
1260      * Returns true if the key was added to the map, that is if it was not
1261      * already present.
1262      */
1263     function _set(
1264         Map storage map,
1265         bytes32 key,
1266         bytes32 value
1267     ) private returns (bool) {
1268         // We read and store the key's index to prevent multiple reads from the same storage slot
1269         uint256 keyIndex = map._indexes[key];
1270 
1271         if (keyIndex == 0) {
1272             // Equivalent to !contains(map, key)
1273             map._entries.push(MapEntry({_key: key, _value: value}));
1274             // The entry is stored at length-1, but we add 1 to all indexes
1275             // and use 0 as a sentinel value
1276             map._indexes[key] = map._entries.length;
1277             return true;
1278         } else {
1279             map._entries[keyIndex - 1]._value = value;
1280             return false;
1281         }
1282     }
1283 
1284     /**
1285      * @dev Removes a key-value pair from a map. O(1).
1286      *
1287      * Returns true if the key was removed from the map, that is if it was present.
1288      */
1289     function _remove(Map storage map, bytes32 key) private returns (bool) {
1290         // We read and store the key's index to prevent multiple reads from the same storage slot
1291         uint256 keyIndex = map._indexes[key];
1292 
1293         if (keyIndex != 0) {
1294             // Equivalent to contains(map, key)
1295             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1296             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1297             // This modifies the order of the array, as noted in {at}.
1298 
1299             uint256 toDeleteIndex = keyIndex - 1;
1300             uint256 lastIndex = map._entries.length - 1;
1301 
1302             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1303             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1304 
1305             MapEntry storage lastEntry = map._entries[lastIndex];
1306 
1307             // Move the last entry to the index where the entry to delete is
1308             map._entries[toDeleteIndex] = lastEntry;
1309             // Update the index for the moved entry
1310             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1311 
1312             // Delete the slot where the moved entry was stored
1313             map._entries.pop();
1314 
1315             // Delete the index for the deleted slot
1316             delete map._indexes[key];
1317 
1318             return true;
1319         } else {
1320             return false;
1321         }
1322     }
1323 
1324     /**
1325      * @dev Returns true if the key is in the map. O(1).
1326      */
1327     function _contains(Map storage map, bytes32 key)
1328         private
1329         view
1330         returns (bool)
1331     {
1332         return map._indexes[key] != 0;
1333     }
1334 
1335     /**
1336      * @dev Returns the number of key-value pairs in the map. O(1).
1337      */
1338     function _length(Map storage map) private view returns (uint256) {
1339         return map._entries.length;
1340     }
1341 
1342     /**
1343      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1344      *
1345      * Note that there are no guarantees on the ordering of entries inside the
1346      * array, and it may change when more entries are added or removed.
1347      *
1348      * Requirements:
1349      *
1350      * - `index` must be strictly less than {length}.
1351      */
1352     function _at(Map storage map, uint256 index)
1353         private
1354         view
1355         returns (bytes32, bytes32)
1356     {
1357         require(
1358             map._entries.length > index,
1359             "EnumerableMap: index out of bounds"
1360         );
1361 
1362         MapEntry storage entry = map._entries[index];
1363         return (entry._key, entry._value);
1364     }
1365 
1366     /**
1367      * @dev Tries to returns the value associated with `key`.  O(1).
1368      * Does not revert if `key` is not in the map.
1369      */
1370     function _tryGet(Map storage map, bytes32 key)
1371         private
1372         view
1373         returns (bool, bytes32)
1374     {
1375         uint256 keyIndex = map._indexes[key];
1376         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1377         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1378     }
1379 
1380     /**
1381      * @dev Returns the value associated with `key`.  O(1).
1382      *
1383      * Requirements:
1384      *
1385      * - `key` must be in the map.
1386      */
1387     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1388         uint256 keyIndex = map._indexes[key];
1389         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1390         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1391     }
1392 
1393     /**
1394      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1395      *
1396      * CAUTION: This function is deprecated because it requires allocating memory for the error
1397      * message unnecessarily. For custom revert reasons use {_tryGet}.
1398      */
1399     function _get(
1400         Map storage map,
1401         bytes32 key,
1402         string memory errorMessage
1403     ) private view returns (bytes32) {
1404         uint256 keyIndex = map._indexes[key];
1405         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1406         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1407     }
1408 
1409     // UintToAddressMap
1410 
1411     struct UintToAddressMap {
1412         Map _inner;
1413     }
1414 
1415     /**
1416      * @dev Adds a key-value pair to a map, or updates the value for an existing
1417      * key. O(1).
1418      *
1419      * Returns true if the key was added to the map, that is if it was not
1420      * already present.
1421      */
1422     function set(
1423         UintToAddressMap storage map,
1424         uint256 key,
1425         address value
1426     ) internal returns (bool) {
1427         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1428     }
1429 
1430     /**
1431      * @dev Removes a value from a set. O(1).
1432      *
1433      * Returns true if the key was removed from the map, that is if it was present.
1434      */
1435     function remove(UintToAddressMap storage map, uint256 key)
1436         internal
1437         returns (bool)
1438     {
1439         return _remove(map._inner, bytes32(key));
1440     }
1441 
1442     /**
1443      * @dev Returns true if the key is in the map. O(1).
1444      */
1445     function contains(UintToAddressMap storage map, uint256 key)
1446         internal
1447         view
1448         returns (bool)
1449     {
1450         return _contains(map._inner, bytes32(key));
1451     }
1452 
1453     /**
1454      * @dev Returns the number of elements in the map. O(1).
1455      */
1456     function length(UintToAddressMap storage map)
1457         internal
1458         view
1459         returns (uint256)
1460     {
1461         return _length(map._inner);
1462     }
1463 
1464     /**
1465      * @dev Returns the element stored at position `index` in the set. O(1).
1466      * Note that there are no guarantees on the ordering of values inside the
1467      * array, and it may change when more values are added or removed.
1468      *
1469      * Requirements:
1470      *
1471      * - `index` must be strictly less than {length}.
1472      */
1473     function at(UintToAddressMap storage map, uint256 index)
1474         internal
1475         view
1476         returns (uint256, address)
1477     {
1478         (bytes32 key, bytes32 value) = _at(map._inner, index);
1479         return (uint256(key), address(uint160(uint256(value))));
1480     }
1481 
1482     /**
1483      * @dev Tries to returns the value associated with `key`.  O(1).
1484      * Does not revert if `key` is not in the map.
1485      *
1486      * _Available since v3.4._
1487      */
1488     function tryGet(UintToAddressMap storage map, uint256 key)
1489         internal
1490         view
1491         returns (bool, address)
1492     {
1493         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1494         return (success, address(uint160(uint256(value))));
1495     }
1496 
1497     /**
1498      * @dev Returns the value associated with `key`.  O(1).
1499      *
1500      * Requirements:
1501      *
1502      * - `key` must be in the map.
1503      */
1504     function get(UintToAddressMap storage map, uint256 key)
1505         internal
1506         view
1507         returns (address)
1508     {
1509         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1510     }
1511 
1512     /**
1513      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1514      *
1515      * CAUTION: This function is deprecated because it requires allocating memory for the error
1516      * message unnecessarily. For custom revert reasons use {tryGet}.
1517      */
1518     function get(
1519         UintToAddressMap storage map,
1520         uint256 key,
1521         string memory errorMessage
1522     ) internal view returns (address) {
1523         return
1524             address(
1525                 uint160(uint256(_get(map._inner, bytes32(key), errorMessage)))
1526             );
1527     }
1528 }
1529 
1530 // File: @openzeppelin/contracts/utils/Strings.sol
1531 
1532 pragma solidity >=0.6.0 <0.8.0;
1533 
1534 /**
1535  * @dev String operations.
1536  */
1537 library Strings {
1538     /**
1539      * @dev Converts a `uint256` to its ASCII `string` representation.
1540      */
1541     function toString(uint256 value) internal pure returns (string memory) {
1542         // Inspired by OraclizeAPI's implementation - MIT licence
1543         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1544 
1545         if (value == 0) {
1546             return "0";
1547         }
1548         uint256 temp = value;
1549         uint256 digits;
1550         while (temp != 0) {
1551             digits++;
1552             temp /= 10;
1553         }
1554         bytes memory buffer = new bytes(digits);
1555         uint256 index = digits - 1;
1556         temp = value;
1557         while (temp != 0) {
1558             buffer[index--] = bytes1(uint8(48 + (temp % 10)));
1559             temp /= 10;
1560         }
1561         return string(buffer);
1562     }
1563 }
1564 
1565 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1566 
1567 pragma solidity >=0.6.0 <0.8.0;
1568 
1569 /**
1570  * @title ERC721 Non-Fungible Token Standard basic implementation
1571  * @dev see https://eips.ethereum.org/EIPS/eip-721
1572  */
1573 
1574 contract ERC721 is
1575     Context,
1576     ERC165,
1577     IERC721,
1578     IERC721Metadata,
1579     IERC721Enumerable
1580 {
1581     using SafeMath for uint256;
1582     using Address for address;
1583     using EnumerableSet for EnumerableSet.UintSet;
1584     using EnumerableMap for EnumerableMap.UintToAddressMap;
1585     using Strings for uint256;
1586 
1587     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1588     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1589     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1590 
1591     // Mapping from holder address to their (enumerable) set of owned tokens
1592     mapping(address => EnumerableSet.UintSet) private _holderTokens;
1593 
1594     // Enumerable mapping from token ids to their owners
1595     EnumerableMap.UintToAddressMap private _tokenOwners;
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
1652     constructor(string memory name_, string memory symbol_) {
1653         _name = name_;
1654         _symbol = symbol_;
1655 
1656         // register the supported interfaces to conform to ERC721 via ERC165
1657         _registerInterface(_INTERFACE_ID_ERC721);
1658         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1659         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1660     }
1661 
1662     /**
1663      * @dev See {IERC721-balanceOf}.
1664      */
1665     function balanceOf(address owner)
1666         public
1667         view
1668         virtual
1669         override
1670         returns (uint256)
1671     {
1672         require(
1673             owner != address(0),
1674             "ERC721: balance query for the zero address"
1675         );
1676         return _holderTokens[owner].length();
1677     }
1678 
1679     /**
1680      * @dev See {IERC721-ownerOf}.
1681      */
1682     function ownerOf(uint256 tokenId)
1683         public
1684         view
1685         virtual
1686         override
1687         returns (address)
1688     {
1689         return
1690             _tokenOwners.get(
1691                 tokenId,
1692                 "ERC721: owner query for nonexistent token"
1693             );
1694     }
1695 
1696     /**
1697      * @dev See {IERC721Metadata-name}.
1698      */
1699     function name() public view virtual override returns (string memory) {
1700         return _name;
1701     }
1702 
1703     /**
1704      * @dev See {IERC721Metadata-symbol}.
1705      */
1706     function symbol() public view virtual override returns (string memory) {
1707         return _symbol;
1708     }
1709 
1710     /**
1711      * @dev See {IERC721Metadata-tokenURI}.
1712      */
1713     function tokenURI(uint256 tokenId)
1714         public
1715         view
1716         virtual
1717         override
1718         returns (string memory)
1719     {
1720         require(
1721             _exists(tokenId),
1722             "ERC721Metadata: URI query for nonexistent token"
1723         );
1724 
1725         string memory _tokenURI = _tokenURIs[tokenId];
1726         string memory base = baseURI();
1727 
1728         // If there is no base URI, return the token URI.
1729         if (bytes(base).length == 0) {
1730             return _tokenURI;
1731         }
1732         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1733         if (bytes(_tokenURI).length > 0) {
1734             return string(abi.encodePacked(base, _tokenURI));
1735         }
1736         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1737         return string(abi.encodePacked(base, tokenId.toString()));
1738     }
1739 
1740     /**
1741      * @dev Returns the base URI set via {_setBaseURI}. This will be
1742      * automatically added as a prefix in {tokenURI} to each token's URI, or
1743      * to the token ID if no specific URI is set for that token ID.
1744      */
1745     function baseURI() public view virtual returns (string memory) {
1746         return _baseURI;
1747     }
1748 
1749     /**
1750      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1751      */
1752     function tokenOfOwnerByIndex(address owner, uint256 index)
1753         public
1754         view
1755         virtual
1756         override
1757         returns (uint256)
1758     {
1759         return _holderTokens[owner].at(index);
1760     }
1761 
1762     /**
1763      * @dev See {IERC721Enumerable-totalSupply}.
1764      */
1765     function totalSupply() public view virtual override returns (uint256) {
1766         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1767         return _tokenOwners.length();
1768     }
1769 
1770     /**
1771      * @dev See {IERC721Enumerable-tokenByIndex}.
1772      */
1773     function tokenByIndex(uint256 index)
1774         public
1775         view
1776         virtual
1777         override
1778         returns (uint256)
1779     {
1780         (uint256 tokenId, ) = _tokenOwners.at(index);
1781         return tokenId;
1782     }
1783 
1784     /**
1785      * @dev See {IERC721-approve}.
1786      */
1787     function approve(address to, uint256 tokenId) public virtual override {
1788         address owner = ERC721.ownerOf(tokenId);
1789         require(to != owner, "ERC721: approval to current owner");
1790 
1791         require(
1792             _msgSender() == owner ||
1793                 ERC721.isApprovedForAll(owner, _msgSender()),
1794             "ERC721: approve caller is not owner nor approved for all"
1795         );
1796 
1797         _approve(to, tokenId);
1798     }
1799 
1800     /**
1801      * @dev See {IERC721-getApproved}.
1802      */
1803     function getApproved(uint256 tokenId)
1804         public
1805         view
1806         virtual
1807         override
1808         returns (address)
1809     {
1810         require(
1811             _exists(tokenId),
1812             "ERC721: approved query for nonexistent token"
1813         );
1814 
1815         return _tokenApprovals[tokenId];
1816     }
1817 
1818     /**
1819      * @dev See {IERC721-setApprovalForAll}.
1820      */
1821     function setApprovalForAll(address operator, bool approved)
1822         public
1823         virtual
1824         override
1825     {
1826         require(operator != _msgSender(), "ERC721: approve to caller");
1827 
1828         _operatorApprovals[_msgSender()][operator] = approved;
1829         emit ApprovalForAll(_msgSender(), operator, approved);
1830     }
1831 
1832     /**
1833      * @dev See {IERC721-isApprovedForAll}.
1834      */
1835     function isApprovedForAll(address owner, address operator)
1836         public
1837         view
1838         virtual
1839         override
1840         returns (bool)
1841     {
1842         return _operatorApprovals[owner][operator];
1843     }
1844 
1845     /**
1846      * @dev See {IERC721-transferFrom}.
1847      */
1848     function transferFrom(
1849         address from,
1850         address to,
1851         uint256 tokenId
1852     ) public virtual override {
1853         //solhint-disable-next-line max-line-length
1854         require(
1855             _isApprovedOrOwner(_msgSender(), tokenId),
1856             "ERC721: transfer caller is not owner nor approved"
1857         );
1858 
1859         _transfer(from, to, tokenId);
1860     }
1861 
1862     /**
1863      * @dev See {IERC721-safeTransferFrom}.
1864      */
1865     function safeTransferFrom(
1866         address from,
1867         address to,
1868         uint256 tokenId
1869     ) public virtual override {
1870         safeTransferFrom(from, to, tokenId, "");
1871     }
1872 
1873     /**
1874      * @dev See {IERC721-safeTransferFrom}.
1875      */
1876     function safeTransferFrom(
1877         address from,
1878         address to,
1879         uint256 tokenId,
1880         bytes memory _data
1881     ) public virtual override {
1882         require(
1883             _isApprovedOrOwner(_msgSender(), tokenId),
1884             "ERC721: transfer caller is not owner nor approved"
1885         );
1886         _safeTransfer(from, to, tokenId, _data);
1887     }
1888 
1889     /**
1890      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1891      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1892      *
1893      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1894      *
1895      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1896      * implement alternative mechanisms to perform token transfer, such as signature-based.
1897      *
1898      * Requirements:
1899      *
1900      * - `from` cannot be the zero address.
1901      * - `to` cannot be the zero address.
1902      * - `tokenId` token must exist and be owned by `from`.
1903      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1904      *
1905      * Emits a {Transfer} event.
1906      */
1907     function _safeTransfer(
1908         address from,
1909         address to,
1910         uint256 tokenId,
1911         bytes memory _data
1912     ) internal virtual {
1913         _transfer(from, to, tokenId);
1914         require(
1915             _checkOnERC721Received(from, to, tokenId, _data),
1916             "ERC721: transfer to non ERC721Receiver implementer"
1917         );
1918     }
1919 
1920     /**
1921      * @dev Returns whether `tokenId` exists.
1922      *
1923      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1924      *
1925      * Tokens start existing when they are minted (`_mint`),
1926      * and stop existing when they are burned (`_burn`).
1927      */
1928     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1929         return _tokenOwners.contains(tokenId);
1930     }
1931 
1932     /**
1933      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1934      *
1935      * Requirements:
1936      *
1937      * - `tokenId` must exist.
1938      */
1939     function _isApprovedOrOwner(address spender, uint256 tokenId)
1940         internal
1941         view
1942         virtual
1943         returns (bool)
1944     {
1945         require(
1946             _exists(tokenId),
1947             "ERC721: operator query for nonexistent token"
1948         );
1949         address owner = ERC721.ownerOf(tokenId);
1950         return (spender == owner ||
1951             getApproved(tokenId) == spender ||
1952             ERC721.isApprovedForAll(owner, spender));
1953     }
1954 
1955     /**
1956      * @dev Safely mints `tokenId` and transfers it to `to`.
1957      *
1958      * Requirements:
1959      d*
1960      * - `tokenId` must not exist.
1961      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1962      *
1963      * Emits a {Transfer} event.
1964      */
1965     function _safeMint(address to, uint256 tokenId) internal virtual {
1966         _safeMint(to, tokenId, "");
1967     }
1968 
1969     /**
1970      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1971      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1972      */
1973     function _safeMint(
1974         address to,
1975         uint256 tokenId,
1976         bytes memory _data
1977     ) internal virtual {
1978         _mint(to, tokenId);
1979         require(
1980             _checkOnERC721Received(address(0), to, tokenId, _data),
1981             "ERC721: transfer to non ERC721Receiver implementer"
1982         );
1983     }
1984 
1985     /**
1986      * @dev Mints `tokenId` and transfers it to `to`.
1987      *
1988      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1989      *
1990      * Requirements:
1991      *
1992      * - `tokenId` must not exist.
1993      * - `to` cannot be the zero address.
1994      *
1995      * Emits a {Transfer} event.
1996      */
1997     function _mint(address to, uint256 tokenId) internal virtual {
1998         require(to != address(0), "ERC721: mint to the zero address");
1999         require(!_exists(tokenId), "ERC721: token already minted");
2000 
2001         _beforeTokenTransfer(address(0), to, tokenId);
2002 
2003         _holderTokens[to].add(tokenId);
2004 
2005         _tokenOwners.set(tokenId, to);
2006 
2007         emit Transfer(address(0), to, tokenId);
2008     }
2009 
2010     /**
2011      * @dev Destroys `tokenId`.
2012      * The approval is cleared when the token is burned.
2013      *
2014      * Requirements:
2015      *
2016      * - `tokenId` must exist.
2017      *
2018      * Emits a {Transfer} event.
2019      */
2020     function _burn(uint256 tokenId) internal virtual {
2021         address owner = ERC721.ownerOf(tokenId); // internal owner
2022 
2023         _beforeTokenTransfer(owner, address(0), tokenId);
2024 
2025         // Clear approvals
2026         _approve(address(0), tokenId);
2027 
2028         // Clear metadata (if any)
2029         if (bytes(_tokenURIs[tokenId]).length != 0) {
2030             delete _tokenURIs[tokenId];
2031         }
2032 
2033         _holderTokens[owner].remove(tokenId);
2034 
2035         _tokenOwners.remove(tokenId);
2036 
2037         emit Transfer(owner, address(0), tokenId);
2038     }
2039 
2040     /**
2041      * @dev Transfers `tokenId` from `from` to `to`.
2042      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2043      *
2044      * Requirements:
2045      *
2046      * - `to` cannot be the zero address.
2047      * - `tokenId` token must be owned by `from`.
2048      *
2049      * Emits a {Transfer} event.
2050      */
2051     function _transfer(
2052         address from,
2053         address to,
2054         uint256 tokenId
2055     ) internal virtual {
2056         require(
2057             ERC721.ownerOf(tokenId) == from,
2058             "ERC721: transfer of token that is not own"
2059         ); // internal owner
2060         require(to != address(0), "ERC721: transfer to the zero address");
2061 
2062         _beforeTokenTransfer(from, to, tokenId);
2063 
2064         // Clear approvals from the previous owner
2065         _approve(address(0), tokenId);
2066 
2067         _holderTokens[from].remove(tokenId);
2068         _holderTokens[to].add(tokenId);
2069 
2070         _tokenOwners.set(tokenId, to);
2071 
2072         emit Transfer(from, to, tokenId);
2073     }
2074 
2075     /**
2076      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
2077      *
2078      * Requirements:
2079      *
2080      * - `tokenId` must exist.
2081      */
2082     function _setTokenURI(uint256 tokenId, string memory _tokenURI)
2083         internal
2084         virtual
2085     {
2086         require(
2087             _exists(tokenId),
2088             "ERC721Metadata: URI set of nonexistent token"
2089         );
2090         _tokenURIs[tokenId] = _tokenURI;
2091     }
2092 
2093     /**
2094      * @dev Internal function to set the base URI for all token IDs. It is
2095      * automatically added as a prefix to the value returned in {tokenURI},
2096      * or to the token ID if {tokenURI} is empty.
2097      */
2098     function _setBaseURI(string memory baseURI_) internal virtual {
2099         _baseURI = baseURI_;
2100     }
2101 
2102     /**
2103      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2104      * The call is not executed if the target address is not a contract.
2105      *
2106      * @param from address representing the previous owner of the given token ID
2107      * @param to target address that will receive the tokens
2108      * @param tokenId uint256 ID of the token to be transferred
2109      * @param _data bytes optional data to send along with the call
2110      * @return bool whether the call correctly returned the expected magic value
2111      */
2112     function _checkOnERC721Received(
2113         address from,
2114         address to,
2115         uint256 tokenId,
2116         bytes memory _data
2117     ) private returns (bool) {
2118         if (!to.isContract()) {
2119             return true;
2120         }
2121         bytes memory returndata = to.functionCall(
2122             abi.encodeWithSelector(
2123                 IERC721Receiver(to).onERC721Received.selector,
2124                 _msgSender(),
2125                 from,
2126                 tokenId,
2127                 _data
2128             ),
2129             "ERC721: transfer to non ERC721Receiver implementer"
2130         );
2131         bytes4 retval = abi.decode(returndata, (bytes4));
2132         return (retval == _ERC721_RECEIVED);
2133     }
2134 
2135     /**
2136      * @dev Approve `to` to operate on `tokenId`
2137      *
2138      * Emits an {Approval} event.
2139      */
2140     function _approve(address to, uint256 tokenId) internal virtual {
2141         _tokenApprovals[tokenId] = to;
2142         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
2143     }
2144 
2145     /**
2146      * @dev Hook that is called before any token transfer. This includes minting
2147      * and burning.
2148      *
2149      * Calling conditions:
2150      *
2151      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2152      * transferred to `to`.
2153      * - When `from` is zero, `tokenId` will be minted for `to`.
2154      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2155      * - `from` cannot be the zero address.
2156      * - `to` cannot be the zero address.
2157      *
2158      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2159      */
2160     function _beforeTokenTransfer(
2161         address from,
2162         address to,
2163         uint256 tokenId
2164     ) internal virtual {}
2165 }
2166 
2167 // File: @openzeppelin/contracts/access/Ownable.sol
2168 
2169 pragma solidity >=0.6.0 <0.8.0;
2170 
2171 /**
2172  * @dev Contract module which provides a basic access control mechanism, where
2173  * there is an account (an owner) that can be granted exclusive access to
2174  * specific functions.
2175  *
2176  * By default, the owner account will be the one that deploys the contract. This
2177  * can later be changed with {transferOwnership}.
2178  *
2179  * This module is used through inheritance. It will make available the modifier
2180  * `onlyOwner`, which can be applied to your functions to restrict their use to
2181  * the owner.
2182  */
2183 abstract contract Ownable is Context {
2184     address private _owner;
2185 
2186     event OwnershipTransferred(
2187         address indexed previousOwner,
2188         address indexed newOwner
2189     );
2190 
2191     /**
2192      * @dev Initializes the contract setting the deployer as the initial owner.
2193      */
2194     constructor() {
2195         address msgSender = _msgSender();
2196         _owner = msgSender;
2197         emit OwnershipTransferred(address(0), msgSender);
2198     }
2199 
2200     /**
2201      * @dev Returns the address of the current owner.
2202      */
2203     function owner() public view virtual returns (address) {
2204         return _owner;
2205     }
2206 
2207     /**
2208      * @dev Throws if called by any account other than the owner.
2209      */
2210     modifier onlyOwner() {
2211         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2212         _;
2213     }
2214 
2215     /**
2216      * @dev Leaves the contract without owner. It will not be possible to call
2217      * `onlyOwner` functions anymore. Can only be called by the current owner.
2218      *
2219      * NOTE: Renouncing ownership will leave the contract without an owner,
2220      * thereby removing any functionality that is only available to the owner.
2221      */
2222     function renounceOwnership() public virtual onlyOwner {
2223         emit OwnershipTransferred(_owner, address(0));
2224         _owner = address(0);
2225     }
2226 
2227     /**
2228      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2229      * Can only be called by the current owner.
2230      */
2231     function transferOwnership(address newOwner) public virtual onlyOwner {
2232         require(
2233             newOwner != address(0),
2234             "Ownable: new owner is the zero address"
2235         );
2236         emit OwnershipTransferred(_owner, newOwner);
2237         _owner = newOwner;
2238     }
2239 }
2240 
2241 pragma solidity ^0.7.0;
2242 pragma abicoder v2;
2243 
2244 contract Gaias is ERC721, Ownable {
2245     using SafeMath for uint256;
2246 
2247     string public GAIAS_PROVENANCE = ""; // IPFS PROVENANCE TO BE ADDED WHEN SOLD OUT
2248 
2249     string public LICENSE_TEXT = "";
2250 
2251     bool licenseLocked = false;
2252     
2253     uint256 public gaiaPrice = 75000000000000000; // 0.075 ETH
2254 
2255 
2256     uint256 public constant maxGaiaPurchase = 100;
2257 
2258     uint256 public constant MAX_GAIAS = 10000;
2259 
2260     bool public saleIsActive = false;
2261 
2262     uint256 public gaiaReserve = 1550; // Reserve 55 faces for team & community (Used in giveaways, events etc...)
2263 
2264     event licenseisLocked(string _licenseText);
2265     address ownerAddress;
2266 
2267     constructor() ERC721("GAIA", "GAIA") {
2268         ownerAddress = msg.sender;
2269     }
2270 
2271     function withdraw() external onlyOwner {
2272         uint256 balance = address(this).balance;
2273         payable(ownerAddress).transfer(balance);
2274     }
2275 
2276     function reserveGaias(address _to, uint256 _reserveAmount)
2277         public
2278         onlyOwner
2279     {
2280         uint256 supply = totalSupply();
2281         require(
2282             _reserveAmount > 0 && _reserveAmount <= gaiaReserve,
2283             "Not enough reserve left for team"
2284         );
2285         for (uint256 i = 0; i < _reserveAmount; i++) {
2286             _safeMint(_to, supply + i);
2287         }
2288         gaiaReserve = gaiaReserve.sub(_reserveAmount);
2289     }
2290 
2291     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
2292         GAIAS_PROVENANCE = provenanceHash;
2293     }
2294 
2295     function setBaseURI(string memory baseURI) public onlyOwner {
2296         _setBaseURI(baseURI);
2297     }
2298 
2299     function flipSaleState() public onlyOwner {
2300         saleIsActive = !saleIsActive;
2301     }
2302 
2303     function tokensOfOwner(address _owner)
2304         external
2305         view
2306         returns (uint256[] memory)
2307     {
2308         uint256 tokenCount = balanceOf(_owner);
2309         if (tokenCount == 0) {
2310             // Return an empty array
2311             return new uint256[](0);
2312         } else {
2313             uint256[] memory result = new uint256[](tokenCount);
2314             uint256 index;
2315             for (index = 0; index < tokenCount; index++) {
2316                 result[index] = tokenOfOwnerByIndex(_owner, index);
2317             }
2318             return result;
2319         }
2320     }
2321 
2322     // Returns the license for tokens
2323     function tokenLicense(uint256 _id) public view returns (string memory) {
2324         require(_id < totalSupply(), "CHOOSE A GAIA WITHIN RANGE");
2325         return LICENSE_TEXT;
2326     }
2327 
2328     // Locks the license to prevent further changes
2329     function lockLicense() public onlyOwner {
2330         licenseLocked = true;
2331         emit licenseisLocked(LICENSE_TEXT);
2332     }
2333 
2334     // Change the license
2335     function changeLicense(string memory _license) public onlyOwner {
2336         require(licenseLocked == false, "License already locked");
2337         LICENSE_TEXT = _license;
2338     }
2339 
2340     function mintGaia(uint256 numberOfTokens) public payable {
2341         require(saleIsActive, "Sale must be active to mint Gaia");
2342         require(
2343             numberOfTokens > 0 && numberOfTokens <= maxGaiaPurchase,
2344             "Can only mint 50 tokens at a time"
2345         );
2346         require(
2347             totalSupply().add(numberOfTokens) <= MAX_GAIAS,
2348             "Purchase would exceed max supply of Gaias"
2349         );
2350         require(
2351             msg.value >= gaiaPrice.mul(numberOfTokens),
2352             "Ether value sent is not correct"
2353         );
2354 
2355         for (uint256 i = 0; i < numberOfTokens; i++) {
2356             uint256 mintIndex = totalSupply();
2357             if (totalSupply() < MAX_GAIAS) {
2358                 _safeMint(msg.sender, mintIndex);
2359             }
2360         }
2361     }
2362 
2363     function setFacePrice(uint256 newPrice) public onlyOwner {
2364         gaiaPrice = newPrice;
2365     }
2366 
2367 }