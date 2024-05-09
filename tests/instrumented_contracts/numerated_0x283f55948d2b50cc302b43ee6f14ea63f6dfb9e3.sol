1 // File @openzeppelin/contracts/utils/Context.sol@v4.3.0
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /**
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
23         return msg.data;
24     }
25 }
26 
27 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.0
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev Contract module which provides a basic access control mechanism, where
33  * there is an account (an owner) that can be granted exclusive access to
34  * specific functions.
35  *
36  * By default, the owner account will be the one that deploys the contract. This
37  * can later be changed with {transferOwnership}.
38  *
39  * This module is used through inheritance. It will make available the modifier
40  * `onlyOwner`, which can be applied to your functions to restrict their use to
41  * the owner.
42  */
43 abstract contract Ownable is Context {
44     address private _owner;
45 
46     event OwnershipTransferred(
47         address indexed previousOwner,
48         address indexed newOwner
49     );
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         _setOwner(_msgSender());
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(owner() == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         _setOwner(address(0));
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(
90             newOwner != address(0),
91             "Ownable: new owner is the zero address"
92         );
93         _setOwner(newOwner);
94     }
95 
96     function _setOwner(address newOwner) private {
97         address oldOwner = _owner;
98         _owner = newOwner;
99         emit OwnershipTransferred(oldOwner, newOwner);
100     }
101 }
102 
103 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.3.0
104 
105 pragma solidity ^0.8.0;
106 
107 // CAUTION
108 // This version of SafeMath should only be used with Solidity 0.8 or later,
109 // because it relies on the compiler's built in overflow checks.
110 
111 /**
112  * @dev Wrappers over Solidity's arithmetic operations.
113  *
114  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
115  * now has built in overflow checking.
116  */
117 library SafeMath {
118     /**
119      * @dev Returns the addition of two unsigned integers, with an overflow flag.
120      *
121      * _Available since v3.4._
122      */
123     function tryAdd(uint256 a, uint256 b)
124         internal
125         pure
126         returns (bool, uint256)
127     {
128         unchecked {
129             uint256 c = a + b;
130             if (c < a) return (false, 0);
131             return (true, c);
132         }
133     }
134 
135     /**
136      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
137      *
138      * _Available since v3.4._
139      */
140     function trySub(uint256 a, uint256 b)
141         internal
142         pure
143         returns (bool, uint256)
144     {
145         unchecked {
146             if (b > a) return (false, 0);
147             return (true, a - b);
148         }
149     }
150 
151     /**
152      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
153      *
154      * _Available since v3.4._
155      */
156     function tryMul(uint256 a, uint256 b)
157         internal
158         pure
159         returns (bool, uint256)
160     {
161         unchecked {
162             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
163             // benefit is lost if 'b' is also tested.
164             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
165             if (a == 0) return (true, 0);
166             uint256 c = a * b;
167             if (c / a != b) return (false, 0);
168             return (true, c);
169         }
170     }
171 
172     /**
173      * @dev Returns the division of two unsigned integers, with a division by zero flag.
174      *
175      * _Available since v3.4._
176      */
177     function tryDiv(uint256 a, uint256 b)
178         internal
179         pure
180         returns (bool, uint256)
181     {
182         unchecked {
183             if (b == 0) return (false, 0);
184             return (true, a / b);
185         }
186     }
187 
188     /**
189      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
190      *
191      * _Available since v3.4._
192      */
193     function tryMod(uint256 a, uint256 b)
194         internal
195         pure
196         returns (bool, uint256)
197     {
198         unchecked {
199             if (b == 0) return (false, 0);
200             return (true, a % b);
201         }
202     }
203 
204     /**
205      * @dev Returns the addition of two unsigned integers, reverting on
206      * overflow.
207      *
208      * Counterpart to Solidity's `+` operator.
209      *
210      * Requirements:
211      *
212      * - Addition cannot overflow.
213      */
214     function add(uint256 a, uint256 b) internal pure returns (uint256) {
215         return a + b;
216     }
217 
218     /**
219      * @dev Returns the subtraction of two unsigned integers, reverting on
220      * overflow (when the result is negative).
221      *
222      * Counterpart to Solidity's `-` operator.
223      *
224      * Requirements:
225      *
226      * - Subtraction cannot overflow.
227      */
228     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
229         return a - b;
230     }
231 
232     /**
233      * @dev Returns the multiplication of two unsigned integers, reverting on
234      * overflow.
235      *
236      * Counterpart to Solidity's `*` operator.
237      *
238      * Requirements:
239      *
240      * - Multiplication cannot overflow.
241      */
242     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
243         return a * b;
244     }
245 
246     /**
247      * @dev Returns the integer division of two unsigned integers, reverting on
248      * division by zero. The result is rounded towards zero.
249      *
250      * Counterpart to Solidity's `/` operator.
251      *
252      * Requirements:
253      *
254      * - The divisor cannot be zero.
255      */
256     function div(uint256 a, uint256 b) internal pure returns (uint256) {
257         return a / b;
258     }
259 
260     /**
261      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
262      * reverting when dividing by zero.
263      *
264      * Counterpart to Solidity's `%` operator. This function uses a `revert`
265      * opcode (which leaves remaining gas untouched) while Solidity uses an
266      * invalid opcode to revert (consuming all remaining gas).
267      *
268      * Requirements:
269      *
270      * - The divisor cannot be zero.
271      */
272     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
273         return a % b;
274     }
275 
276     /**
277      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
278      * overflow (when the result is negative).
279      *
280      * CAUTION: This function is deprecated because it requires allocating memory for the error
281      * message unnecessarily. For custom revert reasons use {trySub}.
282      *
283      * Counterpart to Solidity's `-` operator.
284      *
285      * Requirements:
286      *
287      * - Subtraction cannot overflow.
288      */
289     function sub(
290         uint256 a,
291         uint256 b,
292         string memory errorMessage
293     ) internal pure returns (uint256) {
294         unchecked {
295             require(b <= a, errorMessage);
296             return a - b;
297         }
298     }
299 
300     /**
301      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
302      * division by zero. The result is rounded towards zero.
303      *
304      * Counterpart to Solidity's `/` operator. Note: this function uses a
305      * `revert` opcode (which leaves remaining gas untouched) while Solidity
306      * uses an invalid opcode to revert (consuming all remaining gas).
307      *
308      * Requirements:
309      *
310      * - The divisor cannot be zero.
311      */
312     function div(
313         uint256 a,
314         uint256 b,
315         string memory errorMessage
316     ) internal pure returns (uint256) {
317         unchecked {
318             require(b > 0, errorMessage);
319             return a / b;
320         }
321     }
322 
323     /**
324      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
325      * reverting with custom message when dividing by zero.
326      *
327      * CAUTION: This function is deprecated because it requires allocating memory for the error
328      * message unnecessarily. For custom revert reasons use {tryMod}.
329      *
330      * Counterpart to Solidity's `%` operator. This function uses a `revert`
331      * opcode (which leaves remaining gas untouched) while Solidity uses an
332      * invalid opcode to revert (consuming all remaining gas).
333      *
334      * Requirements:
335      *
336      * - The divisor cannot be zero.
337      */
338     function mod(
339         uint256 a,
340         uint256 b,
341         string memory errorMessage
342     ) internal pure returns (uint256) {
343         unchecked {
344             require(b > 0, errorMessage);
345             return a % b;
346         }
347     }
348 }
349 
350 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.0
351 
352 pragma solidity ^0.8.0;
353 
354 /**
355  * @dev Interface of the ERC165 standard, as defined in the
356  * https://eips.ethereum.org/EIPS/eip-165[EIP].
357  *
358  * Implementers can declare support of contract interfaces, which can then be
359  * queried by others ({ERC165Checker}).
360  *
361  * For an implementation, see {ERC165}.
362  */
363 interface IERC165 {
364     /**
365      * @dev Returns true if this contract implements the interface defined by
366      * `interfaceId`. See the corresponding
367      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
368      * to learn more about how these ids are created.
369      *
370      * This function call must use less than 30 000 gas.
371      */
372     function supportsInterface(bytes4 interfaceId) external view returns (bool);
373 }
374 
375 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.0
376 
377 pragma solidity ^0.8.0;
378 
379 /**
380  * @dev Required interface of an ERC721 compliant contract.
381  */
382 interface IERC721 is IERC165 {
383     /**
384      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
385      */
386     event Transfer(
387         address indexed from,
388         address indexed to,
389         uint256 indexed tokenId
390     );
391 
392     /**
393      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
394      */
395     event Approval(
396         address indexed owner,
397         address indexed approved,
398         uint256 indexed tokenId
399     );
400 
401     /**
402      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
403      */
404     event ApprovalForAll(
405         address indexed owner,
406         address indexed operator,
407         bool approved
408     );
409 
410     /**
411      * @dev Returns the number of tokens in ``owner``'s account.
412      */
413     function balanceOf(address owner) external view returns (uint256 balance);
414 
415     /**
416      * @dev Returns the owner of the `tokenId` token.
417      *
418      * Requirements:
419      *
420      * - `tokenId` must exist.
421      */
422     function ownerOf(uint256 tokenId) external view returns (address owner);
423 
424     /**
425      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
426      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
427      *
428      * Requirements:
429      *
430      * - `from` cannot be the zero address.
431      * - `to` cannot be the zero address.
432      * - `tokenId` token must exist and be owned by `from`.
433      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
434      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
435      *
436      * Emits a {Transfer} event.
437      */
438     function safeTransferFrom(
439         address from,
440         address to,
441         uint256 tokenId
442     ) external;
443 
444     /**
445      * @dev Transfers `tokenId` token from `from` to `to`.
446      *
447      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
448      *
449      * Requirements:
450      *
451      * - `from` cannot be the zero address.
452      * - `to` cannot be the zero address.
453      * - `tokenId` token must be owned by `from`.
454      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
455      *
456      * Emits a {Transfer} event.
457      */
458     function transferFrom(
459         address from,
460         address to,
461         uint256 tokenId
462     ) external;
463 
464     /**
465      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
466      * The approval is cleared when the token is transferred.
467      *
468      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
469      *
470      * Requirements:
471      *
472      * - The caller must own the token or be an approved operator.
473      * - `tokenId` must exist.
474      *
475      * Emits an {Approval} event.
476      */
477     function approve(address to, uint256 tokenId) external;
478 
479     /**
480      * @dev Returns the account approved for `tokenId` token.
481      *
482      * Requirements:
483      *
484      * - `tokenId` must exist.
485      */
486     function getApproved(uint256 tokenId)
487         external
488         view
489         returns (address operator);
490 
491     /**
492      * @dev Approve or remove `operator` as an operator for the caller.
493      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
494      *
495      * Requirements:
496      *
497      * - The `operator` cannot be the caller.
498      *
499      * Emits an {ApprovalForAll} event.
500      */
501     function setApprovalForAll(address operator, bool _approved) external;
502 
503     /**
504      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
505      *
506      * See {setApprovalForAll}
507      */
508     function isApprovedForAll(address owner, address operator)
509         external
510         view
511         returns (bool);
512 
513     /**
514      * @dev Safely transfers `tokenId` token from `from` to `to`.
515      *
516      * Requirements:
517      *
518      * - `from` cannot be the zero address.
519      * - `to` cannot be the zero address.
520      * - `tokenId` token must exist and be owned by `from`.
521      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
522      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
523      *
524      * Emits a {Transfer} event.
525      */
526     function safeTransferFrom(
527         address from,
528         address to,
529         uint256 tokenId,
530         bytes calldata data
531     ) external;
532 }
533 
534 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.0
535 
536 pragma solidity ^0.8.0;
537 
538 /**
539  * @title ERC721 token receiver interface
540  * @dev Interface for any contract that wants to support safeTransfers
541  * from ERC721 asset contracts.
542  */
543 interface IERC721Receiver {
544     /**
545      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
546      * by `operator` from `from`, this function is called.
547      *
548      * It must return its Solidity selector to confirm the token transfer.
549      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
550      *
551      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
552      */
553     function onERC721Received(
554         address operator,
555         address from,
556         uint256 tokenId,
557         bytes calldata data
558     ) external returns (bytes4);
559 }
560 
561 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.0
562 
563 pragma solidity ^0.8.0;
564 
565 /**
566  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
567  * @dev See https://eips.ethereum.org/EIPS/eip-721
568  */
569 interface IERC721Metadata is IERC721 {
570     /**
571      * @dev Returns the token collection name.
572      */
573     function name() external view returns (string memory);
574 
575     /**
576      * @dev Returns the token collection symbol.
577      */
578     function symbol() external view returns (string memory);
579 
580     /**
581      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
582      */
583     function tokenURI(uint256 tokenId) external view returns (string memory);
584 }
585 
586 // File @openzeppelin/contracts/utils/Address.sol@v4.3.0
587 
588 pragma solidity ^0.8.0;
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
615 
616         uint256 size;
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
645         (bool success, ) = recipient.call{value: amount}("");
646         require(
647             success,
648             "Address: unable to send value, recipient may have reverted"
649         );
650     }
651 
652     /**
653      * @dev Performs a Solidity function call using a low level `call`. A
654      * plain `call` is an unsafe replacement for a function call: use this
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
734         (bool success, bytes memory returndata) = target.call{value: value}(
735             data
736         );
737         return verifyCallResult(success, returndata, errorMessage);
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
771 
772         (bool success, bytes memory returndata) = target.staticcall(data);
773         return verifyCallResult(success, returndata, errorMessage);
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
806 
807         (bool success, bytes memory returndata) = target.delegatecall(data);
808         return verifyCallResult(success, returndata, errorMessage);
809     }
810 
811     /**
812      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
813      * revert reason using the provided one.
814      *
815      * _Available since v4.3._
816      */
817     function verifyCallResult(
818         bool success,
819         bytes memory returndata,
820         string memory errorMessage
821     ) internal pure returns (bytes memory) {
822         if (success) {
823             return returndata;
824         } else {
825             // Look for revert reason and bubble it up if present
826             if (returndata.length > 0) {
827                 // The easiest way to bubble the revert reason is using memory via assembly
828 
829                 assembly {
830                     let returndata_size := mload(returndata)
831                     revert(add(32, returndata), returndata_size)
832                 }
833             } else {
834                 revert(errorMessage);
835             }
836         }
837     }
838 }
839 
840 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.0
841 
842 pragma solidity ^0.8.0;
843 
844 /**
845  * @dev String operations.
846  */
847 library Strings {
848     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
849 
850     /**
851      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
852      */
853     function toString(uint256 value) internal pure returns (string memory) {
854         // Inspired by OraclizeAPI's implementation - MIT licence
855         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
856 
857         if (value == 0) {
858             return "0";
859         }
860         uint256 temp = value;
861         uint256 digits;
862         while (temp != 0) {
863             digits++;
864             temp /= 10;
865         }
866         bytes memory buffer = new bytes(digits);
867         while (value != 0) {
868             digits -= 1;
869             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
870             value /= 10;
871         }
872         return string(buffer);
873     }
874 
875     /**
876      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
877      */
878     function toHexString(uint256 value) internal pure returns (string memory) {
879         if (value == 0) {
880             return "0x00";
881         }
882         uint256 temp = value;
883         uint256 length = 0;
884         while (temp != 0) {
885             length++;
886             temp >>= 8;
887         }
888         return toHexString(value, length);
889     }
890 
891     /**
892      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
893      */
894     function toHexString(uint256 value, uint256 length)
895         internal
896         pure
897         returns (string memory)
898     {
899         bytes memory buffer = new bytes(2 * length + 2);
900         buffer[0] = "0";
901         buffer[1] = "x";
902         for (uint256 i = 2 * length + 1; i > 1; --i) {
903             buffer[i] = _HEX_SYMBOLS[value & 0xf];
904             value >>= 4;
905         }
906         require(value == 0, "Strings: hex length insufficient");
907         return string(buffer);
908     }
909 }
910 
911 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.0
912 
913 pragma solidity ^0.8.0;
914 
915 /**
916  * @dev Implementation of the {IERC165} interface.
917  *
918  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
919  * for the additional interface id that will be supported. For example:
920  *
921  * ```solidity
922  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
923  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
924  * }
925  * ```
926  *
927  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
928  */
929 abstract contract ERC165 is IERC165 {
930     /**
931      * @dev See {IERC165-supportsInterface}.
932      */
933     function supportsInterface(bytes4 interfaceId)
934         public
935         view
936         virtual
937         override
938         returns (bool)
939     {
940         return interfaceId == type(IERC165).interfaceId;
941     }
942 }
943 
944 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.0
945 
946 pragma solidity ^0.8.0;
947 
948 /**
949  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
950  * the Metadata extension, but not including the Enumerable extension, which is available separately as
951  * {ERC721Enumerable}.
952  */
953 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
954     using Address for address;
955     using Strings for uint256;
956 
957     // Token name
958     string private _name;
959 
960     // Token symbol
961     string private _symbol;
962 
963     // Mapping from token ID to owner address
964     mapping(uint256 => address) private _owners;
965 
966     // Mapping owner address to token count
967     mapping(address => uint256) private _balances;
968 
969     // Mapping from token ID to approved address
970     mapping(uint256 => address) private _tokenApprovals;
971 
972     // Mapping from owner to operator approvals
973     mapping(address => mapping(address => bool)) private _operatorApprovals;
974 
975     /**
976      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
977      */
978     constructor(string memory name_, string memory symbol_) {
979         _name = name_;
980         _symbol = symbol_;
981     }
982 
983     /**
984      * @dev See {IERC165-supportsInterface}.
985      */
986     function supportsInterface(bytes4 interfaceId)
987         public
988         view
989         virtual
990         override(ERC165, IERC165)
991         returns (bool)
992     {
993         return
994             interfaceId == type(IERC721).interfaceId ||
995             interfaceId == type(IERC721Metadata).interfaceId ||
996             super.supportsInterface(interfaceId);
997     }
998 
999     /**
1000      * @dev See {IERC721-balanceOf}.
1001      */
1002     function balanceOf(address owner)
1003         public
1004         view
1005         virtual
1006         override
1007         returns (uint256)
1008     {
1009         require(
1010             owner != address(0),
1011             "ERC721: balance query for the zero address"
1012         );
1013         return _balances[owner];
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-ownerOf}.
1018      */
1019     function ownerOf(uint256 tokenId)
1020         public
1021         view
1022         virtual
1023         override
1024         returns (address)
1025     {
1026         address owner = _owners[tokenId];
1027         require(
1028             owner != address(0),
1029             "ERC721: owner query for nonexistent token"
1030         );
1031         return owner;
1032     }
1033 
1034     /**
1035      * @dev See {IERC721Metadata-name}.
1036      */
1037     function name() public view virtual override returns (string memory) {
1038         return _name;
1039     }
1040 
1041     /**
1042      * @dev See {IERC721Metadata-symbol}.
1043      */
1044     function symbol() public view virtual override returns (string memory) {
1045         return _symbol;
1046     }
1047 
1048     /**
1049      * @dev See {IERC721Metadata-tokenURI}.
1050      */
1051     function tokenURI(uint256 tokenId)
1052         public
1053         view
1054         virtual
1055         override
1056         returns (string memory)
1057     {
1058         require(
1059             _exists(tokenId),
1060             "ERC721Metadata: URI query for nonexistent token"
1061         );
1062 
1063         string memory baseURI = _baseURI();
1064         return
1065             bytes(baseURI).length > 0
1066                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1067                 : "";
1068     }
1069 
1070     /**
1071      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1072      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1073      * by default, can be overriden in child contracts.
1074      */
1075     function _baseURI() internal view virtual returns (string memory) {
1076         return "";
1077     }
1078 
1079     /**
1080      * @dev See {IERC721-approve}.
1081      */
1082     function approve(address to, uint256 tokenId) public virtual override {
1083         address owner = ERC721.ownerOf(tokenId);
1084         require(to != owner, "ERC721: approval to current owner");
1085 
1086         require(
1087             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1088             "ERC721: approve caller is not owner nor approved for all"
1089         );
1090 
1091         _approve(to, tokenId);
1092     }
1093 
1094     /**
1095      * @dev See {IERC721-getApproved}.
1096      */
1097     function getApproved(uint256 tokenId)
1098         public
1099         view
1100         virtual
1101         override
1102         returns (address)
1103     {
1104         require(
1105             _exists(tokenId),
1106             "ERC721: approved query for nonexistent token"
1107         );
1108 
1109         return _tokenApprovals[tokenId];
1110     }
1111 
1112     /**
1113      * @dev See {IERC721-setApprovalForAll}.
1114      */
1115     function setApprovalForAll(address operator, bool approved)
1116         public
1117         virtual
1118         override
1119     {
1120         require(operator != _msgSender(), "ERC721: approve to caller");
1121 
1122         _operatorApprovals[_msgSender()][operator] = approved;
1123         emit ApprovalForAll(_msgSender(), operator, approved);
1124     }
1125 
1126     /**
1127      * @dev See {IERC721-isApprovedForAll}.
1128      */
1129     function isApprovedForAll(address owner, address operator)
1130         public
1131         view
1132         virtual
1133         override
1134         returns (bool)
1135     {
1136         return _operatorApprovals[owner][operator];
1137     }
1138 
1139     /**
1140      * @dev See {IERC721-transferFrom}.
1141      */
1142     function transferFrom(
1143         address from,
1144         address to,
1145         uint256 tokenId
1146     ) public virtual override {
1147         //solhint-disable-next-line max-line-length
1148         require(
1149             _isApprovedOrOwner(_msgSender(), tokenId),
1150             "ERC721: transfer caller is not owner nor approved"
1151         );
1152 
1153         _transfer(from, to, tokenId);
1154     }
1155 
1156     /**
1157      * @dev See {IERC721-safeTransferFrom}.
1158      */
1159     function safeTransferFrom(
1160         address from,
1161         address to,
1162         uint256 tokenId
1163     ) public virtual override {
1164         safeTransferFrom(from, to, tokenId, "");
1165     }
1166 
1167     /**
1168      * @dev See {IERC721-safeTransferFrom}.
1169      */
1170     function safeTransferFrom(
1171         address from,
1172         address to,
1173         uint256 tokenId,
1174         bytes memory _data
1175     ) public virtual override {
1176         require(
1177             _isApprovedOrOwner(_msgSender(), tokenId),
1178             "ERC721: transfer caller is not owner nor approved"
1179         );
1180         _safeTransfer(from, to, tokenId, _data);
1181     }
1182 
1183     /**
1184      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1185      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1186      *
1187      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1188      *
1189      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1190      * implement alternative mechanisms to perform token transfer, such as signature-based.
1191      *
1192      * Requirements:
1193      *
1194      * - `from` cannot be the zero address.
1195      * - `to` cannot be the zero address.
1196      * - `tokenId` token must exist and be owned by `from`.
1197      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1198      *
1199      * Emits a {Transfer} event.
1200      */
1201     function _safeTransfer(
1202         address from,
1203         address to,
1204         uint256 tokenId,
1205         bytes memory _data
1206     ) internal virtual {
1207         _transfer(from, to, tokenId);
1208         require(
1209             _checkOnERC721Received(from, to, tokenId, _data),
1210             "ERC721: transfer to non ERC721Receiver implementer"
1211         );
1212     }
1213 
1214     /**
1215      * @dev Returns whether `tokenId` exists.
1216      *
1217      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1218      *
1219      * Tokens start existing when they are minted (`_mint`),
1220      * and stop existing when they are burned (`_burn`).
1221      */
1222     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1223         return _owners[tokenId] != address(0);
1224     }
1225 
1226     /**
1227      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1228      *
1229      * Requirements:
1230      *
1231      * - `tokenId` must exist.
1232      */
1233     function _isApprovedOrOwner(address spender, uint256 tokenId)
1234         internal
1235         view
1236         virtual
1237         returns (bool)
1238     {
1239         require(
1240             _exists(tokenId),
1241             "ERC721: operator query for nonexistent token"
1242         );
1243         address owner = ERC721.ownerOf(tokenId);
1244         return (spender == owner ||
1245             getApproved(tokenId) == spender ||
1246             isApprovedForAll(owner, spender));
1247     }
1248 
1249     /**
1250      * @dev Safely mints `tokenId` and transfers it to `to`.
1251      *
1252      * Requirements:
1253      *
1254      * - `tokenId` must not exist.
1255      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1256      *
1257      * Emits a {Transfer} event.
1258      */
1259     function _safeMint(address to, uint256 tokenId) internal virtual {
1260         _safeMint(to, tokenId, "");
1261     }
1262 
1263     /**
1264      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1265      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1266      */
1267     function _safeMint(
1268         address to,
1269         uint256 tokenId,
1270         bytes memory _data
1271     ) internal virtual {
1272         _mint(to, tokenId);
1273         require(
1274             _checkOnERC721Received(address(0), to, tokenId, _data),
1275             "ERC721: transfer to non ERC721Receiver implementer"
1276         );
1277     }
1278 
1279     /**
1280      * @dev Mints `tokenId` and transfers it to `to`.
1281      *
1282      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1283      *
1284      * Requirements:
1285      *
1286      * - `tokenId` must not exist.
1287      * - `to` cannot be the zero address.
1288      *
1289      * Emits a {Transfer} event.
1290      */
1291     function _mint(address to, uint256 tokenId) internal virtual {
1292         require(to != address(0), "ERC721: mint to the zero address");
1293         require(!_exists(tokenId), "ERC721: token already minted");
1294 
1295         _beforeTokenTransfer(address(0), to, tokenId);
1296 
1297         _balances[to] += 1;
1298         _owners[tokenId] = to;
1299 
1300         emit Transfer(address(0), to, tokenId);
1301     }
1302 
1303     /**
1304      * @dev Destroys `tokenId`.
1305      * The approval is cleared when the token is burned.
1306      *
1307      * Requirements:
1308      *
1309      * - `tokenId` must exist.
1310      *
1311      * Emits a {Transfer} event.
1312      */
1313     function _burn(uint256 tokenId) internal virtual {
1314         address owner = ERC721.ownerOf(tokenId);
1315 
1316         _beforeTokenTransfer(owner, address(0), tokenId);
1317 
1318         // Clear approvals
1319         _approve(address(0), tokenId);
1320 
1321         _balances[owner] -= 1;
1322         delete _owners[tokenId];
1323 
1324         emit Transfer(owner, address(0), tokenId);
1325     }
1326 
1327     /**
1328      * @dev Transfers `tokenId` from `from` to `to`.
1329      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1330      *
1331      * Requirements:
1332      *
1333      * - `to` cannot be the zero address.
1334      * - `tokenId` token must be owned by `from`.
1335      *
1336      * Emits a {Transfer} event.
1337      */
1338     function _transfer(
1339         address from,
1340         address to,
1341         uint256 tokenId
1342     ) internal virtual {
1343         require(
1344             ERC721.ownerOf(tokenId) == from,
1345             "ERC721: transfer of token that is not own"
1346         );
1347         require(to != address(0), "ERC721: transfer to the zero address");
1348 
1349         _beforeTokenTransfer(from, to, tokenId);
1350 
1351         // Clear approvals from the previous owner
1352         _approve(address(0), tokenId);
1353 
1354         _balances[from] -= 1;
1355         _balances[to] += 1;
1356         _owners[tokenId] = to;
1357 
1358         emit Transfer(from, to, tokenId);
1359     }
1360 
1361     /**
1362      * @dev Approve `to` to operate on `tokenId`
1363      *
1364      * Emits a {Approval} event.
1365      */
1366     function _approve(address to, uint256 tokenId) internal virtual {
1367         _tokenApprovals[tokenId] = to;
1368         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1369     }
1370 
1371     /**
1372      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1373      * The call is not executed if the target address is not a contract.
1374      *
1375      * @param from address representing the previous owner of the given token ID
1376      * @param to target address that will receive the tokens
1377      * @param tokenId uint256 ID of the token to be transferred
1378      * @param _data bytes optional data to send along with the call
1379      * @return bool whether the call correctly returned the expected magic value
1380      */
1381     function _checkOnERC721Received(
1382         address from,
1383         address to,
1384         uint256 tokenId,
1385         bytes memory _data
1386     ) private returns (bool) {
1387         if (to.isContract()) {
1388             try
1389                 IERC721Receiver(to).onERC721Received(
1390                     _msgSender(),
1391                     from,
1392                     tokenId,
1393                     _data
1394                 )
1395             returns (bytes4 retval) {
1396                 return retval == IERC721Receiver.onERC721Received.selector;
1397             } catch (bytes memory reason) {
1398                 if (reason.length == 0) {
1399                     revert(
1400                         "ERC721: transfer to non ERC721Receiver implementer"
1401                     );
1402                 } else {
1403                     assembly {
1404                         revert(add(32, reason), mload(reason))
1405                     }
1406                 }
1407             }
1408         } else {
1409             return true;
1410         }
1411     }
1412 
1413     /**
1414      * @dev Hook that is called before any token transfer. This includes minting
1415      * and burning.
1416      *
1417      * Calling conditions:
1418      *
1419      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1420      * transferred to `to`.
1421      * - When `from` is zero, `tokenId` will be minted for `to`.
1422      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1423      * - `from` and `to` are never both zero.
1424      *
1425      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1426      */
1427     function _beforeTokenTransfer(
1428         address from,
1429         address to,
1430         uint256 tokenId
1431     ) internal virtual {}
1432 }
1433 
1434 // File @openzeppelin/contracts/security/Pausable.sol@v4.3.0
1435 
1436 pragma solidity ^0.8.0;
1437 
1438 /**
1439  * @dev Contract module which allows children to implement an emergency stop
1440  * mechanism that can be triggered by an authorized account.
1441  *
1442  * This module is used through inheritance. It will make available the
1443  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1444  * the functions of your contract. Note that they will not be pausable by
1445  * simply including this module, only once the modifiers are put in place.
1446  */
1447 abstract contract Pausable is Context {
1448     /**
1449      * @dev Emitted when the pause is triggered by `account`.
1450      */
1451     event Paused(address account);
1452 
1453     /**
1454      * @dev Emitted when the pause is lifted by `account`.
1455      */
1456     event Unpaused(address account);
1457 
1458     bool private _paused;
1459 
1460     /**
1461      * @dev Initializes the contract in unpaused state.
1462      */
1463     constructor() {
1464         _paused = false;
1465     }
1466 
1467     /**
1468      * @dev Returns true if the contract is paused, and false otherwise.
1469      */
1470     function paused() public view virtual returns (bool) {
1471         return _paused;
1472     }
1473 
1474     /**
1475      * @dev Modifier to make a function callable only when the contract is not paused.
1476      *
1477      * Requirements:
1478      *
1479      * - The contract must not be paused.
1480      */
1481     modifier whenNotPaused() {
1482         require(!paused(), "Pausable: paused");
1483         _;
1484     }
1485 
1486     /**
1487      * @dev Modifier to make a function callable only when the contract is paused.
1488      *
1489      * Requirements:
1490      *
1491      * - The contract must be paused.
1492      */
1493     modifier whenPaused() {
1494         require(paused(), "Pausable: not paused");
1495         _;
1496     }
1497 
1498     /**
1499      * @dev Triggers stopped state.
1500      *
1501      * Requirements:
1502      *
1503      * - The contract must not be paused.
1504      */
1505     function _pause() internal virtual whenNotPaused {
1506         _paused = true;
1507         emit Paused(_msgSender());
1508     }
1509 
1510     /**
1511      * @dev Returns to normal state.
1512      *
1513      * Requirements:
1514      *
1515      * - The contract must be paused.
1516      */
1517     function _unpause() internal virtual whenPaused {
1518         _paused = false;
1519         emit Unpaused(_msgSender());
1520     }
1521 }
1522 
1523 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol@v4.3.0
1524 
1525 pragma solidity ^0.8.0;
1526 
1527 /**
1528  * @dev ERC721 token with pausable token transfers, minting and burning.
1529  *
1530  * Useful for scenarios such as preventing trades until the end of an evaluation
1531  * period, or having an emergency switch for freezing all token transfers in the
1532  * event of a large bug.
1533  */
1534 abstract contract ERC721Pausable is ERC721, Pausable {
1535     /**
1536      * @dev See {ERC721-_beforeTokenTransfer}.
1537      *
1538      * Requirements:
1539      *
1540      * - the contract must not be paused.
1541      */
1542     function _beforeTokenTransfer(
1543         address from,
1544         address to,
1545         uint256 tokenId
1546     ) internal virtual override {
1547         super._beforeTokenTransfer(from, to, tokenId);
1548 
1549         require(!paused(), "ERC721Pausable: token transfer while paused");
1550     }
1551 }
1552 
1553 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.0
1554 
1555 pragma solidity ^0.8.0;
1556 
1557 /**
1558  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1559  * @dev See https://eips.ethereum.org/EIPS/eip-721
1560  */
1561 interface IERC721Enumerable is IERC721 {
1562     /**
1563      * @dev Returns the total amount of tokens stored by the contract.
1564      */
1565     function totalSupply() external view returns (uint256);
1566 
1567     /**
1568      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1569      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1570      */
1571     function tokenOfOwnerByIndex(address owner, uint256 index)
1572         external
1573         view
1574         returns (uint256 tokenId);
1575 
1576     /**
1577      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1578      * Use along with {totalSupply} to enumerate all tokens.
1579      */
1580     function tokenByIndex(uint256 index) external view returns (uint256);
1581 }
1582 
1583 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.0
1584 
1585 pragma solidity ^0.8.0;
1586 
1587 /**
1588  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1589  * enumerability of all the token ids in the contract as well as all token ids owned by each
1590  * account.
1591  */
1592 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1593     // Mapping from owner to list of owned token IDs
1594     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1595 
1596     // Mapping from token ID to index of the owner tokens list
1597     mapping(uint256 => uint256) private _ownedTokensIndex;
1598 
1599     // Array with all token ids, used for enumeration
1600     uint256[] private _allTokens;
1601 
1602     // Mapping from token id to position in the allTokens array
1603     mapping(uint256 => uint256) private _allTokensIndex;
1604 
1605     /**
1606      * @dev See {IERC165-supportsInterface}.
1607      */
1608     function supportsInterface(bytes4 interfaceId)
1609         public
1610         view
1611         virtual
1612         override(IERC165, ERC721)
1613         returns (bool)
1614     {
1615         return
1616             interfaceId == type(IERC721Enumerable).interfaceId ||
1617             super.supportsInterface(interfaceId);
1618     }
1619 
1620     /**
1621      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1622      */
1623     function tokenOfOwnerByIndex(address owner, uint256 index)
1624         public
1625         view
1626         virtual
1627         override
1628         returns (uint256)
1629     {
1630         require(
1631             index < ERC721.balanceOf(owner),
1632             "ERC721Enumerable: owner index out of bounds"
1633         );
1634         return _ownedTokens[owner][index];
1635     }
1636 
1637     /**
1638      * @dev See {IERC721Enumerable-totalSupply}.
1639      */
1640     function totalSupply() public view virtual override returns (uint256) {
1641         return _allTokens.length;
1642     }
1643 
1644     /**
1645      * @dev See {IERC721Enumerable-tokenByIndex}.
1646      */
1647     function tokenByIndex(uint256 index)
1648         public
1649         view
1650         virtual
1651         override
1652         returns (uint256)
1653     {
1654         require(
1655             index < ERC721Enumerable.totalSupply(),
1656             "ERC721Enumerable: global index out of bounds"
1657         );
1658         return _allTokens[index];
1659     }
1660 
1661     /**
1662      * @dev Hook that is called before any token transfer. This includes minting
1663      * and burning.
1664      *
1665      * Calling conditions:
1666      *
1667      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1668      * transferred to `to`.
1669      * - When `from` is zero, `tokenId` will be minted for `to`.
1670      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1671      * - `from` cannot be the zero address.
1672      * - `to` cannot be the zero address.
1673      *
1674      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1675      */
1676     function _beforeTokenTransfer(
1677         address from,
1678         address to,
1679         uint256 tokenId
1680     ) internal virtual override {
1681         super._beforeTokenTransfer(from, to, tokenId);
1682 
1683         if (from == address(0)) {
1684             _addTokenToAllTokensEnumeration(tokenId);
1685         } else if (from != to) {
1686             _removeTokenFromOwnerEnumeration(from, tokenId);
1687         }
1688         if (to == address(0)) {
1689             _removeTokenFromAllTokensEnumeration(tokenId);
1690         } else if (to != from) {
1691             _addTokenToOwnerEnumeration(to, tokenId);
1692         }
1693     }
1694 
1695     /**
1696      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1697      * @param to address representing the new owner of the given token ID
1698      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1699      */
1700     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1701         uint256 length = ERC721.balanceOf(to);
1702         _ownedTokens[to][length] = tokenId;
1703         _ownedTokensIndex[tokenId] = length;
1704     }
1705 
1706     /**
1707      * @dev Private function to add a token to this extension's token tracking data structures.
1708      * @param tokenId uint256 ID of the token to be added to the tokens list
1709      */
1710     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1711         _allTokensIndex[tokenId] = _allTokens.length;
1712         _allTokens.push(tokenId);
1713     }
1714 
1715     /**
1716      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1717      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1718      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1719      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1720      * @param from address representing the previous owner of the given token ID
1721      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1722      */
1723     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1724         private
1725     {
1726         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1727         // then delete the last slot (swap and pop).
1728 
1729         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1730         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1731 
1732         // When the token to delete is the last token, the swap operation is unnecessary
1733         if (tokenIndex != lastTokenIndex) {
1734             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1735 
1736             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1737             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1738         }
1739 
1740         // This also deletes the contents at the last position of the array
1741         delete _ownedTokensIndex[tokenId];
1742         delete _ownedTokens[from][lastTokenIndex];
1743     }
1744 
1745     /**
1746      * @dev Private function to remove a token from this extension's token tracking data structures.
1747      * This has O(1) time complexity, but alters the order of the _allTokens array.
1748      * @param tokenId uint256 ID of the token to be removed from the tokens list
1749      */
1750     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1751         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1752         // then delete the last slot (swap and pop).
1753 
1754         uint256 lastTokenIndex = _allTokens.length - 1;
1755         uint256 tokenIndex = _allTokensIndex[tokenId];
1756 
1757         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1758         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1759         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1760         uint256 lastTokenId = _allTokens[lastTokenIndex];
1761 
1762         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1763         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1764 
1765         // This also deletes the contents at the last position of the array
1766         delete _allTokensIndex[tokenId];
1767         _allTokens.pop();
1768     }
1769 }
1770 
1771 // File @openzeppelin/contracts/utils/introspection/ERC165Storage.sol@v4.3.0
1772 
1773 pragma solidity ^0.8.0;
1774 
1775 /**
1776  * @dev Storage based implementation of the {IERC165} interface.
1777  *
1778  * Contracts may inherit from this and call {_registerInterface} to declare
1779  * their support of an interface.
1780  */
1781 abstract contract ERC165Storage is ERC165 {
1782     /**
1783      * @dev Mapping of interface ids to whether or not it's supported.
1784      */
1785     mapping(bytes4 => bool) private _supportedInterfaces;
1786 
1787     /**
1788      * @dev See {IERC165-supportsInterface}.
1789      */
1790     function supportsInterface(bytes4 interfaceId)
1791         public
1792         view
1793         virtual
1794         override
1795         returns (bool)
1796     {
1797         return
1798             super.supportsInterface(interfaceId) ||
1799             _supportedInterfaces[interfaceId];
1800     }
1801 
1802     /**
1803      * @dev Registers the contract as an implementer of the interface defined by
1804      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1805      * registering its interface id is not required.
1806      *
1807      * See {IERC165-supportsInterface}.
1808      *
1809      * Requirements:
1810      *
1811      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1812      */
1813     function _registerInterface(bytes4 interfaceId) internal virtual {
1814         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1815         _supportedInterfaces[interfaceId] = true;
1816     }
1817 }
1818 
1819 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.3.0
1820 
1821 pragma solidity ^0.8.0;
1822 
1823 /**
1824  * @dev Contract module that helps prevent reentrant calls to a function.
1825  *
1826  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1827  * available, which can be applied to functions to make sure there are no nested
1828  * (reentrant) calls to them.
1829  *
1830  * Note that because there is a single `nonReentrant` guard, functions marked as
1831  * `nonReentrant` may not call one another. This can be worked around by making
1832  * those functions `private`, and then adding `external` `nonReentrant` entry
1833  * points to them.
1834  *
1835  * TIP: If you would like to learn more about reentrancy and alternative ways
1836  * to protect against it, check out our blog post
1837  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1838  */
1839 abstract contract ReentrancyGuard {
1840     // Booleans are more expensive than uint256 or any type that takes up a full
1841     // word because each write operation emits an extra SLOAD to first read the
1842     // slot's contents, replace the bits taken up by the boolean, and then write
1843     // back. This is the compiler's defense against contract upgrades and
1844     // pointer aliasing, and it cannot be disabled.
1845 
1846     // The values being non-zero value makes deployment a bit more expensive,
1847     // but in exchange the refund on every call to nonReentrant will be lower in
1848     // amount. Since refunds are capped to a percentage of the total
1849     // transaction's gas, it is best to keep them low in cases like this one, to
1850     // increase the likelihood of the full refund coming into effect.
1851     uint256 private constant _NOT_ENTERED = 1;
1852     uint256 private constant _ENTERED = 2;
1853 
1854     uint256 private _status;
1855 
1856     constructor() {
1857         _status = _NOT_ENTERED;
1858     }
1859 
1860     /**
1861      * @dev Prevents a contract from calling itself, directly or indirectly.
1862      * Calling a `nonReentrant` function from another `nonReentrant`
1863      * function is not supported. It is possible to prevent this from happening
1864      * by making the `nonReentrant` function external, and make it call a
1865      * `private` function that does the actual work.
1866      */
1867     modifier nonReentrant() {
1868         // On the first call to nonReentrant, _notEntered will be true
1869         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1870 
1871         // Any calls to nonReentrant after this point will fail
1872         _status = _ENTERED;
1873 
1874         _;
1875 
1876         // By storing the original value once again, a refund is triggered (see
1877         // https://eips.ethereum.org/EIPS/eip-2200)
1878         _status = _NOT_ENTERED;
1879     }
1880 }
1881 
1882 // ----------------------------------------------------------------------------------------------------
1883 // ----------------------------------------------------------------------------------------------------
1884 // ----------------------------------------------------------------------------------------------------
1885 
1886 
1887 // struct Book {
1888 //   uint num;
1889 //   uint reserveNum;
1890 //   uint price;
1891 //   uint maxSupply;
1892 //   uint purchaseLimit;
1893 // }
1894 
1895 pragma solidity ^0.8.5;
1896 pragma experimental ABIEncoderV2;
1897 
1898 contract ABTF is Ownable, ERC721Enumerable, ReentrancyGuard {
1899     using SafeMath for uint256;
1900     string public ABTF_PROVENANCE = "";
1901     string public BASE_URI = "";
1902 
1903     uint256[] public prices = [0.035 ether, 0.035 ether, 0.035 ether, 0.035 ether];
1904     uint256[] public reserveNumbers = [166, 100, 100, 100];
1905     uint256[] public maxTokens = [626, 500, 500, 500];
1906     uint256[] public purchaseLimit = [1000, 1000, 1000, 1000];
1907     uint256[] public totalReserved = [0, 0, 0, 0];
1908     uint256[] public totalMinted = [0, 0, 0, 0];
1909     bool[] public saleActive = [false, false, false, false];
1910 
1911     constructor() ERC721("A Bug Travels Far", "ABTF") {}
1912 
1913     function withdraw() public onlyOwner {
1914         address payable to = payable(msg.sender);
1915         (bool success, ) = to.call{value: address(this).balance}("");
1916         require(success, "Transfer failed.");
1917     }
1918 
1919     function flipSaleState(uint256 bookNum) public onlyOwner {
1920         saleActive[bookNum] = !saleActive[bookNum];
1921     }
1922 
1923     function _baseURI() internal view override returns (string memory) {
1924         return BASE_URI;
1925     }
1926 
1927     function setBaseURI(string memory baseURI_) public onlyOwner {
1928         BASE_URI = baseURI_;
1929     }
1930 
1931     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1932         ABTF_PROVENANCE = provenanceHash;
1933     }
1934 
1935     // ------------------------
1936 
1937     function setPrice(uint256 _bookNum, uint256 _price) public onlyOwner {
1938         prices[_bookNum] = _price;
1939     }
1940 
1941     function setReserveNumber(uint256 _bookNum, uint256 _reserveNumber) public onlyOwner {
1942         reserveNumbers[_bookNum] = _reserveNumber;
1943     }
1944 
1945     function setMaxTokens(uint256 _bookNum, uint256 _maxTokens) public onlyOwner {
1946         maxTokens[_bookNum] = _maxTokens;
1947     }
1948 
1949     function setPurchaseLimit(uint256 _bookNum, uint256 _purchaseLimit) public onlyOwner {
1950         purchaseLimit[_bookNum] = _purchaseLimit;
1951     }
1952 
1953     // ------------------------
1954 
1955     function purchase(uint256 numberOfTokens, uint256 _bookNum) public payable nonReentrant {
1956         require(_bookNum >= 0 && _bookNum <= 3, "Must enter a book number");
1957         require(saleActive[_bookNum], "Sale for this book is not active");
1958         require(totalMinted[_bookNum] <= maxTokens[_bookNum], "All tokens have been minted for this book");
1959         require(totalMinted[_bookNum].add(numberOfTokens) <= maxTokens[_bookNum], "Would exceed total supply for this book");
1960         require(numberOfTokens > 0 && numberOfTokens <= purchaseLimit[_bookNum],"Would exceed purchase limit for this book");
1961         require(msg.value / numberOfTokens == prices[_bookNum], "Eth value is not good");
1962 
1963         for (uint256 i = 0; i < numberOfTokens; i++) {
1964             if (totalMinted[_bookNum] < maxTokens[_bookNum]) {
1965                 uint256 tokenId = 0;
1966                 if(_bookNum == 0) {
1967                     tokenId = reserveNumbers[_bookNum] + totalMinted[_bookNum];
1968                 } else {
1969                     for (uint256 j = 0; j < _bookNum; j++) {
1970                         tokenId += maxTokens[j];
1971                     }
1972                     tokenId += reserveNumbers[_bookNum] + totalMinted[_bookNum];
1973                 }
1974                 // uint256 tokenId = totalMinted[_bookNum];
1975                 totalMinted[_bookNum] += 1;
1976                 _safeMint(msg.sender, tokenId);
1977             }
1978         }
1979     }
1980 
1981     function reserve(address _to, uint256 _reserveAmount, uint256 _bookNum) public onlyOwner {
1982         require(_reserveAmount > 0, "Must enter a number to reserve");
1983         require(_bookNum >= 0 && _bookNum <= 3, "Must enter a book number");
1984         require(totalReserved[_bookNum].add(_reserveAmount) <= reserveNumbers[_bookNum], "Not enough reserve left for this book");
1985         require(totalMinted[_bookNum].add(totalReserved[_bookNum]).add(_reserveAmount) <= maxTokens[_bookNum], "All tokens for this book have been minted");
1986 
1987         for (uint256 i = 0; i < _reserveAmount; i++) {
1988             uint256 tokenId = 0;
1989             if(_bookNum == 0) {
1990                 tokenId = totalReserved[_bookNum];
1991             } else {
1992                 for (uint256 j = 0; j < _bookNum; j++) {
1993                     tokenId += maxTokens[j];
1994                 }
1995                 tokenId += totalReserved[_bookNum];
1996             }
1997             totalReserved[_bookNum] += 1;
1998             _safeMint(_to, tokenId);
1999         }
2000 
2001         // reserveNumbers[_bookNum] = reserveNumbers[_bookNum].sub(_reserveAmount);
2002     }
2003 
2004     function tokensOfOwner(address _owner) external view returns (uint256[] memory)
2005     {
2006         uint256 tokenCount = balanceOf(_owner);
2007         if (tokenCount == 0) {
2008             return new uint256[](0);
2009         } else {
2010             uint256[] memory result = new uint256[](tokenCount);
2011             uint256 index;
2012             for (index = 0; index < tokenCount; index++) {
2013                 result[index] = tokenOfOwnerByIndex(_owner, index);
2014             }
2015             return result;
2016         }
2017     }
2018 }