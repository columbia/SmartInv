1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.7.0 <0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 /**
27  * @dev Interface of the ERC165 standard, as defined in the
28  * https://eips.ethereum.org/EIPS/eip-165[EIP].
29  *
30  * Implementers can declare support of contract interfaces, which can then be
31  * queried by others ({ERC165Checker}).
32  *
33  * For an implementation, see {ERC165}.
34  */
35 interface IERC165 {
36     /**
37      * @dev Returns true if this contract implements the interface defined by
38      * `interfaceId`. See the corresponding
39      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
40      * to learn more about how these ids are created.
41      *
42      * This function call must use less than 30 000 gas.
43      */
44     function supportsInterface(bytes4 interfaceId) external view returns (bool);
45 }
46 
47 /**
48  * @dev Required interface of an ERC721 compliant contract.
49  */
50 interface IERC721 is IERC165 {
51     /**
52      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
53      */
54     event Transfer(
55         address indexed from,
56         address indexed to,
57         uint256 indexed tokenId
58     );
59 
60     /**
61      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
62      */
63     event Approval(
64         address indexed owner,
65         address indexed approved,
66         uint256 indexed tokenId
67     );
68 
69     /**
70      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
71      */
72     event ApprovalForAll(
73         address indexed owner,
74         address indexed operator,
75         bool approved
76     );
77 
78     /**
79      * @dev Returns the number of tokens in ``owner``'s account.
80      */
81     function balanceOf(address owner) external view returns (uint256 balance);
82 
83     /**
84      * @dev Returns the owner of the `tokenId` token.
85      *
86      * Requirements:
87      *
88      * - `tokenId` must exist.
89      */
90     function ownerOf(uint256 tokenId) external view returns (address owner);
91 
92     /**
93      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
94      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
95      *
96      * Requirements:
97      *
98      * - `from` cannot be the zero address.
99      * - `to` cannot be the zero address.
100      * - `tokenId` token must exist and be owned by `from`.
101      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
102      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
103      *
104      * Emits a {Transfer} event.
105      */
106     function safeTransferFrom(
107         address from,
108         address to,
109         uint256 tokenId
110     ) external;
111 
112     /**
113      * @dev Transfers `tokenId` token from `from` to `to`.
114      *
115      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
116      *
117      * Requirements:
118      *
119      * - `from` cannot be the zero address.
120      * - `to` cannot be the zero address.
121      * - `tokenId` token must be owned by `from`.
122      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
123      *
124      * Emits a {Transfer} event.
125      */
126     function transferFrom(
127         address from,
128         address to,
129         uint256 tokenId
130     ) external;
131 
132     /**
133      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
134      * The approval is cleared when the token is transferred.
135      *
136      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
137      *
138      * Requirements:
139      *
140      * - The caller must own the token or be an approved operator.
141      * - `tokenId` must exist.
142      *
143      * Emits an {Approval} event.
144      */
145     function approve(address to, uint256 tokenId) external;
146 
147     /**
148      * @dev Returns the account approved for `tokenId` token.
149      *
150      * Requirements:
151      *
152      * - `tokenId` must exist.
153      */
154     function getApproved(uint256 tokenId)
155         external
156         view
157         returns (address operator);
158 
159     /**
160      * @dev Approve or remove `operator` as an operator for the caller.
161      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
162      *
163      * Requirements:
164      *
165      * - The `operator` cannot be the caller.
166      *
167      * Emits an {ApprovalForAll} event.
168      */
169     function setApprovalForAll(address operator, bool _approved) external;
170 
171     /**
172      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
173      *
174      * See {setApprovalForAll}
175      */
176     function isApprovedForAll(address owner, address operator)
177         external
178         view
179         returns (bool);
180 
181     /**
182      * @dev Safely transfers `tokenId` token from `from` to `to`.
183      *
184      * Requirements:
185      *
186      * - `from` cannot be the zero address.
187      * - `to` cannot be the zero address.
188      * - `tokenId` token must exist and be owned by `from`.
189      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
190      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
191      *
192      * Emits a {Transfer} event.
193      */
194     function safeTransferFrom(
195         address from,
196         address to,
197         uint256 tokenId,
198         bytes calldata data
199     ) external;
200 }
201 
202 /**
203  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
204  * @dev See https://eips.ethereum.org/EIPS/eip-721
205  */
206 interface IERC721Metadata is IERC721 {
207     /**
208      * @dev Returns the token collection name.
209      */
210     function name() external view returns (string memory);
211 
212     /**
213      * @dev Returns the token collection symbol.
214      */
215     function symbol() external view returns (string memory);
216 
217     /**
218      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
219      */
220     function tokenURI(uint256 tokenId) external view returns (string memory);
221 }
222 
223 /**
224  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
225  * @dev See https://eips.ethereum.org/EIPS/eip-721
226  */
227 interface IERC721Enumerable is IERC721 {
228     /**
229      * @dev Returns the total amount of tokens stored by the contract.
230      */
231     function totalSupply() external view returns (uint256);
232 
233     /**
234      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
235      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
236      */
237     function tokenOfOwnerByIndex(address owner, uint256 index)
238         external
239         view
240         returns (uint256 tokenId);
241 
242     /**
243      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
244      * Use along with {totalSupply} to enumerate all tokens.
245      */
246     function tokenByIndex(uint256 index) external view returns (uint256);
247 }
248 
249 /**
250  * @title ERC721 token receiver interface
251  * @dev Interface for any contract that wants to support safeTransfers
252  * from ERC721 asset contracts.
253  */
254 interface IERC721Receiver {
255     /**
256      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
257      * by `operator` from `from`, this function is called.
258      *
259      * It must return its Solidity selector to confirm the token transfer.
260      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
261      *
262      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
263      */
264     function onERC721Received(
265         address operator,
266         address from,
267         uint256 tokenId,
268         bytes calldata data
269     ) external returns (bytes4);
270 }
271 
272 /**
273  * @dev Implementation of the {IERC165} interface.
274  *
275  * Contracts may inherit from this and call {_registerInterface} to declare
276  * their support of an interface.
277  */
278 abstract contract ERC165 is IERC165 {
279     /*
280      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
281      */
282     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
283 
284     /**
285      * @dev Mapping of interface ids to whether or not it's supported.
286      */
287     mapping(bytes4 => bool) private _supportedInterfaces;
288 
289     constructor() internal {
290         // Derived contracts need only register support for their own interfaces,
291         // we register support for ERC165 itself here
292         _registerInterface(_INTERFACE_ID_ERC165);
293     }
294 
295     /**
296      * @dev See {IERC165-supportsInterface}.
297      *
298      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
299      */
300     function supportsInterface(bytes4 interfaceId)
301         public
302         view
303         virtual
304         override
305         returns (bool)
306     {
307         return _supportedInterfaces[interfaceId];
308     }
309 
310     /**
311      * @dev Registers the contract as an implementer of the interface defined by
312      * `interfaceId`. Support of the actual ERC165 interface is automatic and
313      * registering its interface id is not required.
314      *
315      * See {IERC165-supportsInterface}.
316      *
317      * Requirements:
318      *
319      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
320      */
321     function _registerInterface(bytes4 interfaceId) internal virtual {
322         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
323         _supportedInterfaces[interfaceId] = true;
324     }
325 }
326 
327 /**
328  * @dev Wrappers over Solidity's arithmetic operations with added overflow
329  * checks.
330  *
331  * Arithmetic operations in Solidity wrap on overflow. This can easily result
332  * in bugs, because programmers usually assume that an overflow raises an
333  * error, which is the standard behavior in high level programming languages.
334  * `SafeMath` restores this intuition by reverting the transaction when an
335  * operation overflows.
336  *
337  * Using this library instead of the unchecked operations eliminates an entire
338  * class of bugs, so it's recommended to use it always.
339  */
340 library SafeMath {
341     /**
342      * @dev Returns the addition of two unsigned integers, with an overflow flag.
343      *
344      * _Available since v3.4._
345      */
346     function tryAdd(uint256 a, uint256 b)
347         internal
348         pure
349         returns (bool, uint256)
350     {
351         uint256 c = a + b;
352         if (c < a) return (false, 0);
353         return (true, c);
354     }
355 
356     /**
357      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
358      *
359      * _Available since v3.4._
360      */
361     function trySub(uint256 a, uint256 b)
362         internal
363         pure
364         returns (bool, uint256)
365     {
366         if (b > a) return (false, 0);
367         return (true, a - b);
368     }
369 
370     /**
371      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
372      *
373      * _Available since v3.4._
374      */
375     function tryMul(uint256 a, uint256 b)
376         internal
377         pure
378         returns (bool, uint256)
379     {
380         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
381         // benefit is lost if 'b' is also tested.
382         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
383         if (a == 0) return (true, 0);
384         uint256 c = a * b;
385         if (c / a != b) return (false, 0);
386         return (true, c);
387     }
388 
389     /**
390      * @dev Returns the division of two unsigned integers, with a division by zero flag.
391      *
392      * _Available since v3.4._
393      */
394     function tryDiv(uint256 a, uint256 b)
395         internal
396         pure
397         returns (bool, uint256)
398     {
399         if (b == 0) return (false, 0);
400         return (true, a / b);
401     }
402 
403     /**
404      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
405      *
406      * _Available since v3.4._
407      */
408     function tryMod(uint256 a, uint256 b)
409         internal
410         pure
411         returns (bool, uint256)
412     {
413         if (b == 0) return (false, 0);
414         return (true, a % b);
415     }
416 
417     /**
418      * @dev Returns the addition of two unsigned integers, reverting on
419      * overflow.
420      *
421      * Counterpart to Solidity's `+` operator.
422      *
423      * Requirements:
424      *
425      * - Addition cannot overflow.
426      */
427     function add(uint256 a, uint256 b) internal pure returns (uint256) {
428         uint256 c = a + b;
429         require(c >= a, "SafeMath: addition overflow");
430         return c;
431     }
432 
433     /**
434      * @dev Returns the subtraction of two unsigned integers, reverting on
435      * overflow (when the result is negative).
436      *
437      * Counterpart to Solidity's `-` operator.
438      *
439      * Requirements:
440      *
441      * - Subtraction cannot overflow.
442      */
443     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
444         require(b <= a, "SafeMath: subtraction overflow");
445         return a - b;
446     }
447 
448     /**
449      * @dev Returns the multiplication of two unsigned integers, reverting on
450      * overflow.
451      *
452      * Counterpart to Solidity's `*` operator.
453      *
454      * Requirements:
455      *
456      * - Multiplication cannot overflow.
457      */
458     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
459         if (a == 0) return 0;
460         uint256 c = a * b;
461         require(c / a == b, "SafeMath: multiplication overflow");
462         return c;
463     }
464 
465     /**
466      * @dev Returns the integer division of two unsigned integers, reverting on
467      * division by zero. The result is rounded towards zero.
468      *
469      * Counterpart to Solidity's `/` operator. Note: this function uses a
470      * `revert` opcode (which leaves remaining gas untouched) while Solidity
471      * uses an invalid opcode to revert (consuming all remaining gas).
472      *
473      * Requirements:
474      *
475      * - The divisor cannot be zero.
476      */
477     function div(uint256 a, uint256 b) internal pure returns (uint256) {
478         require(b > 0, "SafeMath: division by zero");
479         return a / b;
480     }
481 
482     /**
483      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
484      * reverting when dividing by zero.
485      *
486      * Counterpart to Solidity's `%` operator. This function uses a `revert`
487      * opcode (which leaves remaining gas untouched) while Solidity uses an
488      * invalid opcode to revert (consuming all remaining gas).
489      *
490      * Requirements:
491      *
492      * - The divisor cannot be zero.
493      */
494     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
495         require(b > 0, "SafeMath: modulo by zero");
496         return a % b;
497     }
498 
499     /**
500      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
501      * overflow (when the result is negative).
502      *
503      * CAUTION: This function is deprecated because it requires allocating memory for the error
504      * message unnecessarily. For custom revert reasons use {trySub}.
505      *
506      * Counterpart to Solidity's `-` operator.
507      *
508      * Requirements:
509      *
510      * - Subtraction cannot overflow.
511      */
512     function sub(
513         uint256 a,
514         uint256 b,
515         string memory errorMessage
516     ) internal pure returns (uint256) {
517         require(b <= a, errorMessage);
518         return a - b;
519     }
520 
521     /**
522      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
523      * division by zero. The result is rounded towards zero.
524      *
525      * CAUTION: This function is deprecated because it requires allocating memory for the error
526      * message unnecessarily. For custom revert reasons use {tryDiv}.
527      *
528      * Counterpart to Solidity's `/` operator. Note: this function uses a
529      * `revert` opcode (which leaves remaining gas untouched) while Solidity
530      * uses an invalid opcode to revert (consuming all remaining gas).
531      *
532      * Requirements:
533      *
534      * - The divisor cannot be zero.
535      */
536     function div(
537         uint256 a,
538         uint256 b,
539         string memory errorMessage
540     ) internal pure returns (uint256) {
541         require(b > 0, errorMessage);
542         return a / b;
543     }
544 
545     /**
546      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
547      * reverting with custom message when dividing by zero.
548      *
549      * CAUTION: This function is deprecated because it requires allocating memory for the error
550      * message unnecessarily. For custom revert reasons use {tryMod}.
551      *
552      * Counterpart to Solidity's `%` operator. This function uses a `revert`
553      * opcode (which leaves remaining gas untouched) while Solidity uses an
554      * invalid opcode to revert (consuming all remaining gas).
555      *
556      * Requirements:
557      *
558      * - The divisor cannot be zero.
559      */
560     function mod(
561         uint256 a,
562         uint256 b,
563         string memory errorMessage
564     ) internal pure returns (uint256) {
565         require(b > 0, errorMessage);
566         return a % b;
567     }
568 }
569 
570 /**
571  * @dev Collection of functions related to the address type
572  */
573 library Address {
574     /**
575      * @dev Returns true if `account` is a contract.
576      *
577      * [IMPORTANT]
578      * ====
579      * It is unsafe to assume that an address for which this function returns
580      * false is an externally-owned account (EOA) and not a contract.
581      *
582      * Among others, `isContract` will return false for the following
583      * types of addresses:
584      *
585      *  - an externally-owned account
586      *  - a contract in construction
587      *  - an address where a contract will be created
588      *  - an address where a contract lived, but was destroyed
589      * ====
590      */
591     function isContract(address account) internal view returns (bool) {
592         // This method relies on extcodesize, which returns 0 for contracts in
593         // construction, since the code is only stored at the end of the
594         // constructor execution.
595 
596         uint256 size;
597         // solhint-disable-next-line no-inline-assembly
598         assembly {
599             size := extcodesize(account)
600         }
601         return size > 0;
602     }
603 
604     /**
605      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
606      * `recipient`, forwarding all available gas and reverting on errors.
607      *
608      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
609      * of certain opcodes, possibly making contracts go over the 2300 gas limit
610      * imposed by `transfer`, making them unable to receive funds via
611      * `transfer`. {sendValue} removes this limitation.
612      *
613      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
614      *
615      * IMPORTANT: because control is transferred to `recipient`, care must be
616      * taken to not create reentrancy vulnerabilities. Consider using
617      * {ReentrancyGuard} or the
618      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
619      */
620     function sendValue(address payable recipient, uint256 amount) internal {
621         require(
622             address(this).balance >= amount,
623             "Address: insufficient balance"
624         );
625 
626         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
627         (bool success, ) = recipient.call{value: amount}("");
628         require(
629             success,
630             "Address: unable to send value, recipient may have reverted"
631         );
632     }
633 
634     /**
635      * @dev Performs a Solidity function call using a low level `call`. A
636      * plain`call` is an unsafe replacement for a function call: use this
637      * function instead.
638      *
639      * If `target` reverts with a revert reason, it is bubbled up by this
640      * function (like regular Solidity function calls).
641      *
642      * Returns the raw returned data. To convert to the expected return value,
643      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
644      *
645      * Requirements:
646      *
647      * - `target` must be a contract.
648      * - calling `target` with `data` must not revert.
649      *
650      * _Available since v3.1._
651      */
652     function functionCall(address target, bytes memory data)
653         internal
654         returns (bytes memory)
655     {
656         return functionCall(target, data, "Address: low-level call failed");
657     }
658 
659     /**
660      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
661      * `errorMessage` as a fallback revert reason when `target` reverts.
662      *
663      * _Available since v3.1._
664      */
665     function functionCall(
666         address target,
667         bytes memory data,
668         string memory errorMessage
669     ) internal returns (bytes memory) {
670         return functionCallWithValue(target, data, 0, errorMessage);
671     }
672 
673     /**
674      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
675      * but also transferring `value` wei to `target`.
676      *
677      * Requirements:
678      *
679      * - the calling contract must have an ETH balance of at least `value`.
680      * - the called Solidity function must be `payable`.
681      *
682      * _Available since v3.1._
683      */
684     function functionCallWithValue(
685         address target,
686         bytes memory data,
687         uint256 value
688     ) internal returns (bytes memory) {
689         return
690             functionCallWithValue(
691                 target,
692                 data,
693                 value,
694                 "Address: low-level call with value failed"
695             );
696     }
697 
698     /**
699      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
700      * with `errorMessage` as a fallback revert reason when `target` reverts.
701      *
702      * _Available since v3.1._
703      */
704     function functionCallWithValue(
705         address target,
706         bytes memory data,
707         uint256 value,
708         string memory errorMessage
709     ) internal returns (bytes memory) {
710         require(
711             address(this).balance >= value,
712             "Address: insufficient balance for call"
713         );
714         require(isContract(target), "Address: call to non-contract");
715 
716         // solhint-disable-next-line avoid-low-level-calls
717         (bool success, bytes memory returndata) = target.call{value: value}(
718             data
719         );
720         return _verifyCallResult(success, returndata, errorMessage);
721     }
722 
723     /**
724      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
725      * but performing a static call.
726      *
727      * _Available since v3.3._
728      */
729     function functionStaticCall(address target, bytes memory data)
730         internal
731         view
732         returns (bytes memory)
733     {
734         return
735             functionStaticCall(
736                 target,
737                 data,
738                 "Address: low-level static call failed"
739             );
740     }
741 
742     /**
743      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
744      * but performing a static call.
745      *
746      * _Available since v3.3._
747      */
748     function functionStaticCall(
749         address target,
750         bytes memory data,
751         string memory errorMessage
752     ) internal view returns (bytes memory) {
753         require(isContract(target), "Address: static call to non-contract");
754 
755         // solhint-disable-next-line avoid-low-level-calls
756         (bool success, bytes memory returndata) = target.staticcall(data);
757         return _verifyCallResult(success, returndata, errorMessage);
758     }
759 
760     /**
761      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
762      * but performing a delegate call.
763      *
764      * _Available since v3.4._
765      */
766     function functionDelegateCall(address target, bytes memory data)
767         internal
768         returns (bytes memory)
769     {
770         return
771             functionDelegateCall(
772                 target,
773                 data,
774                 "Address: low-level delegate call failed"
775             );
776     }
777 
778     /**
779      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
780      * but performing a delegate call.
781      *
782      * _Available since v3.4._
783      */
784     function functionDelegateCall(
785         address target,
786         bytes memory data,
787         string memory errorMessage
788     ) internal returns (bytes memory) {
789         require(isContract(target), "Address: delegate call to non-contract");
790 
791         // solhint-disable-next-line avoid-low-level-calls
792         (bool success, bytes memory returndata) = target.delegatecall(data);
793         return _verifyCallResult(success, returndata, errorMessage);
794     }
795 
796     function _verifyCallResult(
797         bool success,
798         bytes memory returndata,
799         string memory errorMessage
800     ) private pure returns (bytes memory) {
801         if (success) {
802             return returndata;
803         } else {
804             // Look for revert reason and bubble it up if present
805             if (returndata.length > 0) {
806                 // The easiest way to bubble the revert reason is using memory via assembly
807 
808                 // solhint-disable-next-line no-inline-assembly
809                 assembly {
810                     let returndata_size := mload(returndata)
811                     revert(add(32, returndata), returndata_size)
812                 }
813             } else {
814                 revert(errorMessage);
815             }
816         }
817     }
818 }
819 
820 /**
821  * @dev Library for managing
822  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
823  * types.
824  *
825  * Sets have the following properties:
826  *
827  * - Elements are added, removed, and checked for existence in constant time
828  * (O(1)).
829  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
830  *
831  * ```
832  * contract Example {
833  *     // Add the library methods
834  *     using EnumerableSet for EnumerableSet.AddressSet;
835  *
836  *     // Declare a set state variable
837  *     EnumerableSet.AddressSet private mySet;
838  * }
839  * ```
840  *
841  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
842  * and `uint256` (`UintSet`) are supported.
843  */
844 library EnumerableSet {
845     // To implement this library for multiple types with as little code
846     // repetition as possible, we write it in terms of a generic Set type with
847     // bytes32 values.
848     // The Set implementation uses private functions, and user-facing
849     // implementations (such as AddressSet) are just wrappers around the
850     // underlying Set.
851     // This means that we can only create new EnumerableSets for types that fit
852     // in bytes32.
853 
854     struct Set {
855         // Storage of set values
856         bytes32[] _values;
857         // Position of the value in the `values` array, plus 1 because index 0
858         // means a value is not in the set.
859         mapping(bytes32 => uint256) _indexes;
860     }
861 
862     /**
863      * @dev Add a value to a set. O(1).
864      *
865      * Returns true if the value was added to the set, that is if it was not
866      * already present.
867      */
868     function _add(Set storage set, bytes32 value) private returns (bool) {
869         if (!_contains(set, value)) {
870             set._values.push(value);
871             // The value is stored at length-1, but we add 1 to all indexes
872             // and use 0 as a sentinel value
873             set._indexes[value] = set._values.length;
874             return true;
875         } else {
876             return false;
877         }
878     }
879 
880     /**
881      * @dev Removes a value from a set. O(1).
882      *
883      * Returns true if the value was removed from the set, that is if it was
884      * present.
885      */
886     function _remove(Set storage set, bytes32 value) private returns (bool) {
887         // We read and store the value's index to prevent multiple reads from the same storage slot
888         uint256 valueIndex = set._indexes[value];
889 
890         if (valueIndex != 0) {
891             // Equivalent to contains(set, value)
892             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
893             // the array, and then remove the last element (sometimes called as 'swap and pop').
894             // This modifies the order of the array, as noted in {at}.
895 
896             uint256 toDeleteIndex = valueIndex - 1;
897             uint256 lastIndex = set._values.length - 1;
898 
899             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
900             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
901 
902             bytes32 lastvalue = set._values[lastIndex];
903 
904             // Move the last value to the index where the value to delete is
905             set._values[toDeleteIndex] = lastvalue;
906             // Update the index for the moved value
907             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
908 
909             // Delete the slot where the moved value was stored
910             set._values.pop();
911 
912             // Delete the index for the deleted slot
913             delete set._indexes[value];
914 
915             return true;
916         } else {
917             return false;
918         }
919     }
920 
921     /**
922      * @dev Returns true if the value is in the set. O(1).
923      */
924     function _contains(Set storage set, bytes32 value)
925         private
926         view
927         returns (bool)
928     {
929         return set._indexes[value] != 0;
930     }
931 
932     /**
933      * @dev Returns the number of values on the set. O(1).
934      */
935     function _length(Set storage set) private view returns (uint256) {
936         return set._values.length;
937     }
938 
939     /**
940      * @dev Returns the value stored at position `index` in the set. O(1).
941      *
942      * Note that there are no guarantees on the ordering of values inside the
943      * array, and it may change when more values are added or removed.
944      *
945      * Requirements:
946      *
947      * - `index` must be strictly less than {length}.
948      */
949     function _at(Set storage set, uint256 index)
950         private
951         view
952         returns (bytes32)
953     {
954         require(
955             set._values.length > index,
956             "EnumerableSet: index out of bounds"
957         );
958         return set._values[index];
959     }
960 
961     // Bytes32Set
962 
963     struct Bytes32Set {
964         Set _inner;
965     }
966 
967     /**
968      * @dev Add a value to a set. O(1).
969      *
970      * Returns true if the value was added to the set, that is if it was not
971      * already present.
972      */
973     function add(Bytes32Set storage set, bytes32 value)
974         internal
975         returns (bool)
976     {
977         return _add(set._inner, value);
978     }
979 
980     /**
981      * @dev Removes a value from a set. O(1).
982      *
983      * Returns true if the value was removed from the set, that is if it was
984      * present.
985      */
986     function remove(Bytes32Set storage set, bytes32 value)
987         internal
988         returns (bool)
989     {
990         return _remove(set._inner, value);
991     }
992 
993     /**
994      * @dev Returns true if the value is in the set. O(1).
995      */
996     function contains(Bytes32Set storage set, bytes32 value)
997         internal
998         view
999         returns (bool)
1000     {
1001         return _contains(set._inner, value);
1002     }
1003 
1004     /**
1005      * @dev Returns the number of values in the set. O(1).
1006      */
1007     function length(Bytes32Set storage set) internal view returns (uint256) {
1008         return _length(set._inner);
1009     }
1010 
1011     /**
1012      * @dev Returns the value stored at position `index` in the set. O(1).
1013      *
1014      * Note that there are no guarantees on the ordering of values inside the
1015      * array, and it may change when more values are added or removed.
1016      *
1017      * Requirements:
1018      *
1019      * - `index` must be strictly less than {length}.
1020      */
1021     function at(Bytes32Set storage set, uint256 index)
1022         internal
1023         view
1024         returns (bytes32)
1025     {
1026         return _at(set._inner, index);
1027     }
1028 
1029     // AddressSet
1030 
1031     struct AddressSet {
1032         Set _inner;
1033     }
1034 
1035     /**
1036      * @dev Add a value to a set. O(1).
1037      *
1038      * Returns true if the value was added to the set, that is if it was not
1039      * already present.
1040      */
1041     function add(AddressSet storage set, address value)
1042         internal
1043         returns (bool)
1044     {
1045         return _add(set._inner, bytes32(uint256(uint160(value))));
1046     }
1047 
1048     /**
1049      * @dev Removes a value from a set. O(1).
1050      *
1051      * Returns true if the value was removed from the set, that is if it was
1052      * present.
1053      */
1054     function remove(AddressSet storage set, address value)
1055         internal
1056         returns (bool)
1057     {
1058         return _remove(set._inner, bytes32(uint256(uint160(value))));
1059     }
1060 
1061     /**
1062      * @dev Returns true if the value is in the set. O(1).
1063      */
1064     function contains(AddressSet storage set, address value)
1065         internal
1066         view
1067         returns (bool)
1068     {
1069         return _contains(set._inner, bytes32(uint256(uint160(value))));
1070     }
1071 
1072     /**
1073      * @dev Returns the number of values in the set. O(1).
1074      */
1075     function length(AddressSet storage set) internal view returns (uint256) {
1076         return _length(set._inner);
1077     }
1078 
1079     /**
1080      * @dev Returns the value stored at position `index` in the set. O(1).
1081      *
1082      * Note that there are no guarantees on the ordering of values inside the
1083      * array, and it may change when more values are added or removed.
1084      *
1085      * Requirements:
1086      *
1087      * - `index` must be strictly less than {length}.
1088      */
1089     function at(AddressSet storage set, uint256 index)
1090         internal
1091         view
1092         returns (address)
1093     {
1094         return address(uint160(uint256(_at(set._inner, index))));
1095     }
1096 
1097     // UintSet
1098 
1099     struct UintSet {
1100         Set _inner;
1101     }
1102 
1103     /**
1104      * @dev Add a value to a set. O(1).
1105      *
1106      * Returns true if the value was added to the set, that is if it was not
1107      * already present.
1108      */
1109     function add(UintSet storage set, uint256 value) internal returns (bool) {
1110         return _add(set._inner, bytes32(value));
1111     }
1112 
1113     /**
1114      * @dev Removes a value from a set. O(1).
1115      *
1116      * Returns true if the value was removed from the set, that is if it was
1117      * present.
1118      */
1119     function remove(UintSet storage set, uint256 value)
1120         internal
1121         returns (bool)
1122     {
1123         return _remove(set._inner, bytes32(value));
1124     }
1125 
1126     /**
1127      * @dev Returns true if the value is in the set. O(1).
1128      */
1129     function contains(UintSet storage set, uint256 value)
1130         internal
1131         view
1132         returns (bool)
1133     {
1134         return _contains(set._inner, bytes32(value));
1135     }
1136 
1137     /**
1138      * @dev Returns the number of values on the set. O(1).
1139      */
1140     function length(UintSet storage set) internal view returns (uint256) {
1141         return _length(set._inner);
1142     }
1143 
1144     /**
1145      * @dev Returns the value stored at position `index` in the set. O(1).
1146      *
1147      * Note that there are no guarantees on the ordering of values inside the
1148      * array, and it may change when more values are added or removed.
1149      *
1150      * Requirements:
1151      *
1152      * - `index` must be strictly less than {length}.
1153      */
1154     function at(UintSet storage set, uint256 index)
1155         internal
1156         view
1157         returns (uint256)
1158     {
1159         return uint256(_at(set._inner, index));
1160     }
1161 }
1162 
1163 /**
1164  * @dev Library for managing an enumerable variant of Solidity's
1165  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1166  * type.
1167  *
1168  * Maps have the following properties:
1169  *
1170  * - Entries are added, removed, and checked for existence in constant time
1171  * (O(1)).
1172  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1173  *
1174  * ```
1175  * contract Example {
1176  *     // Add the library methods
1177  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1178  *
1179  *     // Declare a set state variable
1180  *     EnumerableMap.UintToAddressMap private myMap;
1181  * }
1182  * ```
1183  *
1184  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1185  * supported.
1186  */
1187 library EnumerableMap {
1188     // To implement this library for multiple types with as little code
1189     // repetition as possible, we write it in terms of a generic Map type with
1190     // bytes32 keys and values.
1191     // The Map implementation uses private functions, and user-facing
1192     // implementations (such as Uint256ToAddressMap) are just wrappers around
1193     // the underlying Map.
1194     // This means that we can only create new EnumerableMaps for types that fit
1195     // in bytes32.
1196 
1197     struct MapEntry {
1198         bytes32 _key;
1199         bytes32 _value;
1200     }
1201 
1202     struct Map {
1203         // Storage of map keys and values
1204         MapEntry[] _entries;
1205         // Position of the entry defined by a key in the `entries` array, plus 1
1206         // because index 0 means a key is not in the map.
1207         mapping(bytes32 => uint256) _indexes;
1208     }
1209 
1210     /**
1211      * @dev Adds a key-value pair to a map, or updates the value for an existing
1212      * key. O(1).
1213      *
1214      * Returns true if the key was added to the map, that is if it was not
1215      * already present.
1216      */
1217     function _set(
1218         Map storage map,
1219         bytes32 key,
1220         bytes32 value
1221     ) private returns (bool) {
1222         // We read and store the key's index to prevent multiple reads from the same storage slot
1223         uint256 keyIndex = map._indexes[key];
1224 
1225         if (keyIndex == 0) {
1226             // Equivalent to !contains(map, key)
1227             map._entries.push(MapEntry({_key: key, _value: value}));
1228             // The entry is stored at length-1, but we add 1 to all indexes
1229             // and use 0 as a sentinel value
1230             map._indexes[key] = map._entries.length;
1231             return true;
1232         } else {
1233             map._entries[keyIndex - 1]._value = value;
1234             return false;
1235         }
1236     }
1237 
1238     /**
1239      * @dev Removes a key-value pair from a map. O(1).
1240      *
1241      * Returns true if the key was removed from the map, that is if it was present.
1242      */
1243     function _remove(Map storage map, bytes32 key) private returns (bool) {
1244         // We read and store the key's index to prevent multiple reads from the same storage slot
1245         uint256 keyIndex = map._indexes[key];
1246 
1247         if (keyIndex != 0) {
1248             // Equivalent to contains(map, key)
1249             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1250             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1251             // This modifies the order of the array, as noted in {at}.
1252 
1253             uint256 toDeleteIndex = keyIndex - 1;
1254             uint256 lastIndex = map._entries.length - 1;
1255 
1256             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1257             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1258 
1259             MapEntry storage lastEntry = map._entries[lastIndex];
1260 
1261             // Move the last entry to the index where the entry to delete is
1262             map._entries[toDeleteIndex] = lastEntry;
1263             // Update the index for the moved entry
1264             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1265 
1266             // Delete the slot where the moved entry was stored
1267             map._entries.pop();
1268 
1269             // Delete the index for the deleted slot
1270             delete map._indexes[key];
1271 
1272             return true;
1273         } else {
1274             return false;
1275         }
1276     }
1277 
1278     /**
1279      * @dev Returns true if the key is in the map. O(1).
1280      */
1281     function _contains(Map storage map, bytes32 key)
1282         private
1283         view
1284         returns (bool)
1285     {
1286         return map._indexes[key] != 0;
1287     }
1288 
1289     /**
1290      * @dev Returns the number of key-value pairs in the map. O(1).
1291      */
1292     function _length(Map storage map) private view returns (uint256) {
1293         return map._entries.length;
1294     }
1295 
1296     /**
1297      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1298      *
1299      * Note that there are no guarantees on the ordering of entries inside the
1300      * array, and it may change when more entries are added or removed.
1301      *
1302      * Requirements:
1303      *
1304      * - `index` must be strictly less than {length}.
1305      */
1306     function _at(Map storage map, uint256 index)
1307         private
1308         view
1309         returns (bytes32, bytes32)
1310     {
1311         require(
1312             map._entries.length > index,
1313             "EnumerableMap: index out of bounds"
1314         );
1315 
1316         MapEntry storage entry = map._entries[index];
1317         return (entry._key, entry._value);
1318     }
1319 
1320     /**
1321      * @dev Tries to returns the value associated with `key`.  O(1).
1322      * Does not revert if `key` is not in the map.
1323      */
1324     function _tryGet(Map storage map, bytes32 key)
1325         private
1326         view
1327         returns (bool, bytes32)
1328     {
1329         uint256 keyIndex = map._indexes[key];
1330         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1331         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1332     }
1333 
1334     /**
1335      * @dev Returns the value associated with `key`.  O(1).
1336      *
1337      * Requirements:
1338      *
1339      * - `key` must be in the map.
1340      */
1341     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1342         uint256 keyIndex = map._indexes[key];
1343         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1344         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1345     }
1346 
1347     /**
1348      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1349      *
1350      * CAUTION: This function is deprecated because it requires allocating memory for the error
1351      * message unnecessarily. For custom revert reasons use {_tryGet}.
1352      */
1353     function _get(
1354         Map storage map,
1355         bytes32 key,
1356         string memory errorMessage
1357     ) private view returns (bytes32) {
1358         uint256 keyIndex = map._indexes[key];
1359         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1360         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1361     }
1362 
1363     // UintToAddressMap
1364 
1365     struct UintToAddressMap {
1366         Map _inner;
1367     }
1368 
1369     /**
1370      * @dev Adds a key-value pair to a map, or updates the value for an existing
1371      * key. O(1).
1372      *
1373      * Returns true if the key was added to the map, that is if it was not
1374      * already present.
1375      */
1376     function set(
1377         UintToAddressMap storage map,
1378         uint256 key,
1379         address value
1380     ) internal returns (bool) {
1381         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1382     }
1383 
1384     /**
1385      * @dev Removes a value from a set. O(1).
1386      *
1387      * Returns true if the key was removed from the map, that is if it was present.
1388      */
1389     function remove(UintToAddressMap storage map, uint256 key)
1390         internal
1391         returns (bool)
1392     {
1393         return _remove(map._inner, bytes32(key));
1394     }
1395 
1396     /**
1397      * @dev Returns true if the key is in the map. O(1).
1398      */
1399     function contains(UintToAddressMap storage map, uint256 key)
1400         internal
1401         view
1402         returns (bool)
1403     {
1404         return _contains(map._inner, bytes32(key));
1405     }
1406 
1407     /**
1408      * @dev Returns the number of elements in the map. O(1).
1409      */
1410     function length(UintToAddressMap storage map)
1411         internal
1412         view
1413         returns (uint256)
1414     {
1415         return _length(map._inner);
1416     }
1417 
1418     /**
1419      * @dev Returns the element stored at position `index` in the set. O(1).
1420      * Note that there are no guarantees on the ordering of values inside the
1421      * array, and it may change when more values are added or removed.
1422      *
1423      * Requirements:
1424      *
1425      * - `index` must be strictly less than {length}.
1426      */
1427     function at(UintToAddressMap storage map, uint256 index)
1428         internal
1429         view
1430         returns (uint256, address)
1431     {
1432         (bytes32 key, bytes32 value) = _at(map._inner, index);
1433         return (uint256(key), address(uint160(uint256(value))));
1434     }
1435 
1436     /**
1437      * @dev Tries to returns the value associated with `key`.  O(1).
1438      * Does not revert if `key` is not in the map.
1439      *
1440      * _Available since v3.4._
1441      */
1442     function tryGet(UintToAddressMap storage map, uint256 key)
1443         internal
1444         view
1445         returns (bool, address)
1446     {
1447         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1448         return (success, address(uint160(uint256(value))));
1449     }
1450 
1451     /**
1452      * @dev Returns the value associated with `key`.  O(1).
1453      *
1454      * Requirements:
1455      *
1456      * - `key` must be in the map.
1457      */
1458     function get(UintToAddressMap storage map, uint256 key)
1459         internal
1460         view
1461         returns (address)
1462     {
1463         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1464     }
1465 
1466     /**
1467      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1468      *
1469      * CAUTION: This function is deprecated because it requires allocating memory for the error
1470      * message unnecessarily. For custom revert reasons use {tryGet}.
1471      */
1472     function get(
1473         UintToAddressMap storage map,
1474         uint256 key,
1475         string memory errorMessage
1476     ) internal view returns (address) {
1477         return
1478             address(
1479                 uint160(uint256(_get(map._inner, bytes32(key), errorMessage)))
1480             );
1481     }
1482 }
1483 
1484 /**
1485  * @dev String operations.
1486  */
1487 library Strings {
1488     /**
1489      * @dev Converts a `uint256` to its ASCII `string` representation.
1490      */
1491     function toString(uint256 value) internal pure returns (string memory) {
1492         // Inspired by OraclizeAPI's implementation - MIT licence
1493         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1494 
1495         if (value == 0) {
1496             return "0";
1497         }
1498         uint256 temp = value;
1499         uint256 digits;
1500         while (temp != 0) {
1501             digits++;
1502             temp /= 10;
1503         }
1504         bytes memory buffer = new bytes(digits);
1505         uint256 index = digits - 1;
1506         temp = value;
1507         while (temp != 0) {
1508             buffer[index--] = bytes1(uint8(48 + (temp % 10)));
1509             temp /= 10;
1510         }
1511         return string(buffer);
1512     }
1513 }
1514 
1515 /**
1516  * @title ERC721 Non-Fungible Token Standard basic implementation
1517  * @dev see https://eips.ethereum.org/EIPS/eip-721
1518  */
1519 contract ERC721 is
1520     Context,
1521     ERC165,
1522     IERC721,
1523     IERC721Metadata,
1524     IERC721Enumerable
1525 {
1526     using SafeMath for uint256;
1527     using Address for address;
1528     using EnumerableSet for EnumerableSet.UintSet;
1529     using EnumerableMap for EnumerableMap.UintToAddressMap;
1530     using Strings for uint256;
1531 
1532     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1533     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1534     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1535 
1536     // Mapping from holder address to their (enumerable) set of owned tokens
1537     mapping(address => EnumerableSet.UintSet) private _holderTokens;
1538 
1539     // Enumerable mapping from token ids to their owners
1540     EnumerableMap.UintToAddressMap private _tokenOwners;
1541 
1542     // Mapping from token ID to approved address
1543     mapping(uint256 => address) private _tokenApprovals;
1544 
1545     // Mapping from owner to operator approvals
1546     mapping(address => mapping(address => bool)) private _operatorApprovals;
1547 
1548     // Token name
1549     string private _name;
1550 
1551     // Token symbol
1552     string private _symbol;
1553 
1554     // Optional mapping for token URIs
1555     mapping(uint256 => string) private _tokenURIs;
1556 
1557     // Base URI
1558     string private _baseURI;
1559 
1560     /*
1561      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1562      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1563      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1564      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1565      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1566      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1567      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1568      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1569      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1570      *
1571      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1572      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1573      */
1574     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1575 
1576     /*
1577      *     bytes4(keccak256('name()')) == 0x06fdde03
1578      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1579      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1580      *
1581      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1582      */
1583     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1584 
1585     /*
1586      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1587      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1588      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1589      *
1590      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1591      */
1592     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1593 
1594     /**
1595      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1596      */
1597     constructor(string memory name_, string memory symbol_) public {
1598         _name = name_;
1599         _symbol = symbol_;
1600 
1601         // register the supported interfaces to conform to ERC721 via ERC165
1602         _registerInterface(_INTERFACE_ID_ERC721);
1603         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1604         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1605     }
1606 
1607     /**
1608      * @dev See {IERC721-balanceOf}.
1609      */
1610     function balanceOf(address owner)
1611         public
1612         view
1613         virtual
1614         override
1615         returns (uint256)
1616     {
1617         require(
1618             owner != address(0),
1619             "ERC721: balance query for the zero address"
1620         );
1621         return _holderTokens[owner].length();
1622     }
1623 
1624     /**
1625      * @dev See {IERC721-ownerOf}.
1626      */
1627     function ownerOf(uint256 tokenId)
1628         public
1629         view
1630         virtual
1631         override
1632         returns (address)
1633     {
1634         return
1635             _tokenOwners.get(
1636                 tokenId,
1637                 "ERC721: owner query for nonexistent token"
1638             );
1639     }
1640 
1641     /**
1642      * @dev See {IERC721Metadata-name}.
1643      */
1644     function name() public view virtual override returns (string memory) {
1645         return _name;
1646     }
1647 
1648     /**
1649      * @dev See {IERC721Metadata-symbol}.
1650      */
1651     function symbol() public view virtual override returns (string memory) {
1652         return _symbol;
1653     }
1654 
1655     /**
1656      * @dev See {IERC721Metadata-tokenURI}.
1657      */
1658     function tokenURI(uint256 tokenId)
1659         public
1660         view
1661         virtual
1662         override
1663         returns (string memory)
1664     {
1665         require(
1666             _exists(tokenId),
1667             "ERC721Metadata: URI query for nonexistent token"
1668         );
1669 
1670         string memory _tokenURI = _tokenURIs[tokenId];
1671         string memory base = baseURI();
1672 
1673         // If there is no base URI, return the token URI.
1674         if (bytes(base).length == 0) {
1675             return _tokenURI;
1676         }
1677         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1678         if (bytes(_tokenURI).length > 0) {
1679             return string(abi.encodePacked(base, _tokenURI));
1680         }
1681         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1682         return string(abi.encodePacked(base, tokenId.toString()));
1683     }
1684 
1685     /**
1686      * @dev Returns the base URI set via {_setBaseURI}. This will be
1687      * automatically added as a prefix in {tokenURI} to each token's URI, or
1688      * to the token ID if no specific URI is set for that token ID.
1689      */
1690     function baseURI() public view virtual returns (string memory) {
1691         return _baseURI;
1692     }
1693 
1694     /**
1695      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1696      */
1697     function tokenOfOwnerByIndex(address owner, uint256 index)
1698         public
1699         view
1700         virtual
1701         override
1702         returns (uint256)
1703     {
1704         return _holderTokens[owner].at(index);
1705     }
1706 
1707     /**
1708      * @dev See {IERC721Enumerable-totalSupply}.
1709      */
1710     function totalSupply() public view virtual override returns (uint256) {
1711         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1712         return _tokenOwners.length();
1713     }
1714 
1715     /**
1716      * @dev See {IERC721Enumerable-tokenByIndex}.
1717      */
1718     function tokenByIndex(uint256 index)
1719         public
1720         view
1721         virtual
1722         override
1723         returns (uint256)
1724     {
1725         (uint256 tokenId, ) = _tokenOwners.at(index);
1726         return tokenId;
1727     }
1728 
1729     /**
1730      * @dev See {IERC721-approve}.
1731      */
1732     function approve(address to, uint256 tokenId) public virtual override {
1733         address owner = ERC721.ownerOf(tokenId);
1734         require(to != owner, "ERC721: approval to current owner");
1735 
1736         require(
1737             _msgSender() == owner ||
1738                 ERC721.isApprovedForAll(owner, _msgSender()),
1739             "ERC721: approve caller is not owner nor approved for all"
1740         );
1741 
1742         _approve(to, tokenId);
1743     }
1744 
1745     /**
1746      * @dev See {IERC721-getApproved}.
1747      */
1748     function getApproved(uint256 tokenId)
1749         public
1750         view
1751         virtual
1752         override
1753         returns (address)
1754     {
1755         require(
1756             _exists(tokenId),
1757             "ERC721: approved query for nonexistent token"
1758         );
1759 
1760         return _tokenApprovals[tokenId];
1761     }
1762 
1763     /**
1764      * @dev See {IERC721-setApprovalForAll}.
1765      */
1766     function setApprovalForAll(address operator, bool approved)
1767         public
1768         virtual
1769         override
1770     {
1771         require(operator != _msgSender(), "ERC721: approve to caller");
1772 
1773         _operatorApprovals[_msgSender()][operator] = approved;
1774         emit ApprovalForAll(_msgSender(), operator, approved);
1775     }
1776 
1777     /**
1778      * @dev See {IERC721-isApprovedForAll}.
1779      */
1780     function isApprovedForAll(address owner, address operator)
1781         public
1782         view
1783         virtual
1784         override
1785         returns (bool)
1786     {
1787         return _operatorApprovals[owner][operator];
1788     }
1789 
1790     /**
1791      * @dev See {IERC721-transferFrom}.
1792      */
1793     function transferFrom(
1794         address from,
1795         address to,
1796         uint256 tokenId
1797     ) public virtual override {
1798         //solhint-disable-next-line max-line-length
1799         require(
1800             _isApprovedOrOwner(_msgSender(), tokenId),
1801             "ERC721: transfer caller is not owner nor approved"
1802         );
1803 
1804         _transfer(from, to, tokenId);
1805     }
1806 
1807     /**
1808      * @dev See {IERC721-safeTransferFrom}.
1809      */
1810     function safeTransferFrom(
1811         address from,
1812         address to,
1813         uint256 tokenId
1814     ) public virtual override {
1815         safeTransferFrom(from, to, tokenId, "");
1816     }
1817 
1818     /**
1819      * @dev See {IERC721-safeTransferFrom}.
1820      */
1821     function safeTransferFrom(
1822         address from,
1823         address to,
1824         uint256 tokenId,
1825         bytes memory _data
1826     ) public virtual override {
1827         require(
1828             _isApprovedOrOwner(_msgSender(), tokenId),
1829             "ERC721: transfer caller is not owner nor approved"
1830         );
1831         _safeTransfer(from, to, tokenId, _data);
1832     }
1833 
1834     /**
1835      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1836      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1837      *
1838      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1839      *
1840      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1841      * implement alternative mechanisms to perform token transfer, such as signature-based.
1842      *
1843      * Requirements:
1844      *
1845      * - `from` cannot be the zero address.
1846      * - `to` cannot be the zero address.
1847      * - `tokenId` token must exist and be owned by `from`.
1848      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1849      *
1850      * Emits a {Transfer} event.
1851      */
1852     function _safeTransfer(
1853         address from,
1854         address to,
1855         uint256 tokenId,
1856         bytes memory _data
1857     ) internal virtual {
1858         _transfer(from, to, tokenId);
1859         require(
1860             _checkOnERC721Received(from, to, tokenId, _data),
1861             "ERC721: transfer to non ERC721Receiver implementer"
1862         );
1863     }
1864 
1865     /**
1866      * @dev Returns whether `tokenId` exists.
1867      *
1868      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1869      *
1870      * Tokens start existing when they are minted (`_mint`),
1871      * and stop existing when they are burned (`_burn`).
1872      */
1873     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1874         return _tokenOwners.contains(tokenId);
1875     }
1876 
1877     /**
1878      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1879      *
1880      * Requirements:
1881      *
1882      * - `tokenId` must exist.
1883      */
1884     function _isApprovedOrOwner(address spender, uint256 tokenId)
1885         internal
1886         view
1887         virtual
1888         returns (bool)
1889     {
1890         require(
1891             _exists(tokenId),
1892             "ERC721: operator query for nonexistent token"
1893         );
1894         address owner = ERC721.ownerOf(tokenId);
1895         return (spender == owner ||
1896             getApproved(tokenId) == spender ||
1897             ERC721.isApprovedForAll(owner, spender));
1898     }
1899 
1900     /**
1901      * @dev Safely mints `tokenId` and transfers it to `to`.
1902      *
1903      * Requirements:
1904      d*
1905      * - `tokenId` must not exist.
1906      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1907      *
1908      * Emits a {Transfer} event.
1909      */
1910     function _safeMint(address to, uint256 tokenId) internal virtual {
1911         _safeMint(to, tokenId, "");
1912     }
1913 
1914     /**
1915      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1916      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1917      */
1918     function _safeMint(
1919         address to,
1920         uint256 tokenId,
1921         bytes memory _data
1922     ) internal virtual {
1923         _mint(to, tokenId);
1924         require(
1925             _checkOnERC721Received(address(0), to, tokenId, _data),
1926             "ERC721: transfer to non ERC721Receiver implementer"
1927         );
1928     }
1929 
1930     /**
1931      * @dev Mints `tokenId` and transfers it to `to`.
1932      *
1933      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1934      *
1935      * Requirements:
1936      *
1937      * - `tokenId` must not exist.
1938      * - `to` cannot be the zero address.
1939      *
1940      * Emits a {Transfer} event.
1941      */
1942     function _mint(address to, uint256 tokenId) internal virtual {
1943         require(to != address(0), "ERC721: mint to the zero address");
1944         require(!_exists(tokenId), "ERC721: token already minted");
1945 
1946         _beforeTokenTransfer(address(0), to, tokenId);
1947 
1948         _holderTokens[to].add(tokenId);
1949 
1950         _tokenOwners.set(tokenId, to);
1951 
1952         emit Transfer(address(0), to, tokenId);
1953     }
1954 
1955     /**
1956      * @dev Destroys `tokenId`.
1957      * The approval is cleared when the token is burned.
1958      *
1959      * Requirements:
1960      *
1961      * - `tokenId` must exist.
1962      *
1963      * Emits a {Transfer} event.
1964      */
1965     function _burn(uint256 tokenId) internal virtual {
1966         address owner = ERC721.ownerOf(tokenId); // internal owner
1967 
1968         _beforeTokenTransfer(owner, address(0), tokenId);
1969 
1970         // Clear approvals
1971         _approve(address(0), tokenId);
1972 
1973         // Clear metadata (if any)
1974         if (bytes(_tokenURIs[tokenId]).length != 0) {
1975             delete _tokenURIs[tokenId];
1976         }
1977 
1978         _holderTokens[owner].remove(tokenId);
1979 
1980         _tokenOwners.remove(tokenId);
1981 
1982         emit Transfer(owner, address(0), tokenId);
1983     }
1984 
1985     /**
1986      * @dev Transfers `tokenId` from `from` to `to`.
1987      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1988      *
1989      * Requirements:
1990      *
1991      * - `to` cannot be the zero address.
1992      * - `tokenId` token must be owned by `from`.
1993      *
1994      * Emits a {Transfer} event.
1995      */
1996     function _transfer(
1997         address from,
1998         address to,
1999         uint256 tokenId
2000     ) internal virtual {
2001         require(
2002             ERC721.ownerOf(tokenId) == from,
2003             "ERC721: transfer of token that is not own"
2004         ); // internal owner
2005         require(to != address(0), "ERC721: transfer to the zero address");
2006 
2007         _beforeTokenTransfer(from, to, tokenId);
2008 
2009         // Clear approvals from the previous owner
2010         _approve(address(0), tokenId);
2011 
2012         _holderTokens[from].remove(tokenId);
2013         _holderTokens[to].add(tokenId);
2014 
2015         _tokenOwners.set(tokenId, to);
2016 
2017         emit Transfer(from, to, tokenId);
2018     }
2019 
2020     /**
2021      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
2022      *
2023      * Requirements:
2024      *
2025      * - `tokenId` must exist.
2026      */
2027     function _setTokenURI(uint256 tokenId, string memory _tokenURI)
2028         internal
2029         virtual
2030     {
2031         require(
2032             _exists(tokenId),
2033             "ERC721Metadata: URI set of nonexistent token"
2034         );
2035         _tokenURIs[tokenId] = _tokenURI;
2036     }
2037 
2038     /**
2039      * @dev Internal function to set the base URI for all token IDs. It is
2040      * automatically added as a prefix to the value returned in {tokenURI},
2041      * or to the token ID if {tokenURI} is empty.
2042      */
2043     function _setBaseURI(string memory baseURI_) internal virtual {
2044         _baseURI = baseURI_;
2045     }
2046 
2047     /**
2048      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2049      * The call is not executed if the target address is not a contract.
2050      *
2051      * @param from address representing the previous owner of the given token ID
2052      * @param to target address that will receive the tokens
2053      * @param tokenId uint256 ID of the token to be transferred
2054      * @param _data bytes optional data to send along with the call
2055      * @return bool whether the call correctly returned the expected magic value
2056      */
2057     function _checkOnERC721Received(
2058         address from,
2059         address to,
2060         uint256 tokenId,
2061         bytes memory _data
2062     ) private returns (bool) {
2063         if (!to.isContract()) {
2064             return true;
2065         }
2066         bytes memory returndata = to.functionCall(
2067             abi.encodeWithSelector(
2068                 IERC721Receiver(to).onERC721Received.selector,
2069                 _msgSender(),
2070                 from,
2071                 tokenId,
2072                 _data
2073             ),
2074             "ERC721: transfer to non ERC721Receiver implementer"
2075         );
2076         bytes4 retval = abi.decode(returndata, (bytes4));
2077         return (retval == _ERC721_RECEIVED);
2078     }
2079 
2080     /**
2081      * @dev Approve `to` to operate on `tokenId`
2082      *
2083      * Emits an {Approval} event.
2084      */
2085     function _approve(address to, uint256 tokenId) internal virtual {
2086         _tokenApprovals[tokenId] = to;
2087         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
2088     }
2089 
2090     /**
2091      * @dev Hook that is called before any token transfer. This includes minting
2092      * and burning.
2093      *
2094      * Calling conditions:
2095      *
2096      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2097      * transferred to `to`.
2098      * - When `from` is zero, `tokenId` will be minted for `to`.
2099      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2100      * - `from` cannot be the zero address.
2101      * - `to` cannot be the zero address.
2102      *
2103      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2104      */
2105     function _beforeTokenTransfer(
2106         address from,
2107         address to,
2108         uint256 tokenId
2109     ) internal virtual {}
2110 }
2111 
2112 /**
2113  * @dev Contract module which provides a basic access control mechanism, where
2114  * there is an account (an owner) that can be granted exclusive access to
2115  * specific functions.
2116  *
2117  * By default, the owner account will be the one that deploys the contract. This
2118  * can later be changed with {transferOwnership}.
2119  *
2120  * This module is used through inheritance. It will make available the modifier
2121  * `onlyOwner`, which can be applied to your functions to restrict their use to
2122  * the owner.
2123  */
2124 abstract contract Ownable is Context {
2125     address private _owner;
2126 
2127     event OwnershipTransferred(
2128         address indexed previousOwner,
2129         address indexed newOwner
2130     );
2131 
2132     /**
2133      * @dev Initializes the contract setting the deployer as the initial owner.
2134      */
2135     constructor() internal {
2136         address msgSender = _msgSender();
2137         _owner = msgSender;
2138         emit OwnershipTransferred(address(0), msgSender);
2139     }
2140 
2141     /**
2142      * @dev Returns the address of the current owner.
2143      */
2144     function owner() public view virtual returns (address) {
2145         return _owner;
2146     }
2147 
2148     /**
2149      * @dev Throws if called by any account other than the owner.
2150      */
2151     modifier onlyOwner() {
2152         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2153         _;
2154     }
2155 
2156     /**
2157      * @dev Leaves the contract without owner. It will not be possible to call
2158      * `onlyOwner` functions anymore. Can only be called by the current owner.
2159      *
2160      * NOTE: Renouncing ownership will leave the contract without an owner,
2161      * thereby removing any functionality that is only available to the owner.
2162      */
2163     function renounceOwnership() public virtual onlyOwner {
2164         emit OwnershipTransferred(_owner, address(0));
2165         _owner = address(0);
2166     }
2167 
2168     /**
2169      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2170      * Can only be called by the current owner.
2171      */
2172     function transferOwnership(address newOwner) public virtual onlyOwner {
2173         require(
2174             newOwner != address(0),
2175             "Ownable: new owner is the zero address"
2176         );
2177         emit OwnershipTransferred(_owner, newOwner);
2178         _owner = newOwner;
2179     }
2180 }
2181 
2182 /**
2183  * @title BoredApeYachtClub contract
2184  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
2185  */
2186 contract HLFamily is ERC721, Ownable {
2187     using SafeMath for uint256;
2188 
2189     string public PROVENANCE = "";
2190 
2191     uint256 public startingIndexBlock;
2192 
2193     uint256 public startingIndex;
2194 
2195     uint256 public mintPrice = 30000000000000000; //0.03 ETH
2196 
2197     uint256 public maxPurchase = 20;
2198 
2199     uint256 public MAX_NFTS;
2200 
2201     uint256 public START_MINT;
2202 
2203     uint256 public MINT_KEEP_SEC;
2204 
2205     constructor(
2206         string memory name,
2207         string memory symbol,
2208         uint256 maxNftSupply,
2209         string memory baseURI,
2210         uint256 mintStart,
2211         uint256 mintKeepMinutes
2212     ) ERC721(name, symbol) {
2213         _setBaseURI(baseURI);
2214         MAX_NFTS = maxNftSupply;
2215         START_MINT = mintStart;
2216         MINT_KEEP_SEC = mintKeepMinutes * 60;
2217     }
2218 
2219     function withdraw() public onlyOwner {
2220         uint256 balance = address(this).balance;
2221         msg.sender.transfer(balance);
2222     }
2223 
2224     /**
2225      * Set some NFTs aside
2226      */
2227     function reserveNFTs() public onlyOwner {
2228         uint256 supply = totalSupply();
2229         uint256 i;
2230         for (i = 0; i < 30; i++) {
2231             _safeMint(msg.sender, supply + i);
2232         }
2233     }
2234 
2235     /**
2236      * DM Gargamel in Discord that you're standing right behind him.
2237      */
2238     function setStartMint(uint256 mintStart, uint256 mintKeepMinutes)
2239         public
2240         onlyOwner
2241     {
2242         START_MINT = mintStart;
2243         MINT_KEEP_SEC = mintKeepMinutes * 60;
2244     }
2245 
2246     /*
2247      * Set mint price
2248      */
2249     function setMintPrice(uint256 price) public onlyOwner {
2250         mintPrice = price;
2251     }
2252 
2253     /*
2254      * Set max purchase
2255      */
2256     function setMaxPurchase(uint256 newMaxPurchase) public onlyOwner {
2257         maxPurchase = newMaxPurchase;
2258     }
2259 
2260     /*
2261      * Set provenance once it's calculated
2262      */
2263     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
2264         PROVENANCE = provenanceHash;
2265     }
2266 
2267     function setBaseURI(string memory baseURI) public onlyOwner {
2268         _setBaseURI(baseURI);
2269     }
2270 
2271     /**
2272      * Mints NFT
2273      */
2274     function mint(uint256 numberOfTokens) public payable {
2275         require(block.timestamp > START_MINT, "Has not yet started to mint");
2276         require(
2277             MINT_KEEP_SEC == 0 ||
2278                 block.timestamp < (START_MINT + MINT_KEEP_SEC),
2279             "Minting has stopped"
2280         );
2281         require(
2282             numberOfTokens <= maxPurchase,
2283             "Can only mint limited tokens at a time"
2284         );
2285         require(
2286             totalSupply().add(numberOfTokens) <= MAX_NFTS,
2287             "Purchase would exceed max supply of NFTs"
2288         );
2289         require(
2290             mintPrice.mul(numberOfTokens) <= msg.value,
2291             "Ether value sent is not correct"
2292         );
2293 
2294         for (uint256 i = 0; i < numberOfTokens; i++) {
2295             uint256 mintIndex = totalSupply();
2296             if (totalSupply() < MAX_NFTS) {
2297                 _safeMint(msg.sender, mintIndex);
2298             }
2299         }
2300 
2301         // If we haven't set the starting index and this is either 1) the last saleable token or 2) the first token to be sold after
2302         // the end of pre-sale, set the starting index block
2303         if (startingIndexBlock == 0 && totalSupply() == MAX_NFTS) {
2304             startingIndexBlock = block.number;
2305         }
2306     }
2307 
2308     /**
2309      * Set the starting index for the collection
2310      */
2311     function setStartingIndex() public {
2312         require(startingIndex == 0, "Starting index is already set");
2313         require(startingIndexBlock != 0, "Starting index block must be set");
2314 
2315         startingIndex = uint256(blockhash(startingIndexBlock)) % MAX_NFTS;
2316         // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
2317         if (block.number.sub(startingIndexBlock) > 255) {
2318             startingIndex = uint256(blockhash(block.number - 1)) % MAX_NFTS;
2319         }
2320         // Prevent default sequence
2321         if (startingIndex == 0) {
2322             startingIndex = startingIndex.add(1);
2323         }
2324     }
2325 
2326     /**
2327      * Set the starting index block for the collection, essentially unblocking
2328      * setting starting index
2329      */
2330     function emergencySetStartingIndexBlock() public onlyOwner {
2331         require(startingIndex == 0, "Starting index is already set");
2332 
2333         startingIndexBlock = block.number;
2334     }
2335 }