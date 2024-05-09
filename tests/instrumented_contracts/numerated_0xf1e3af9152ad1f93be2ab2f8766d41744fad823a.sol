1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.0;
4 pragma experimental ABIEncoderV2;
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address payable) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes memory) {
12         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13         return msg.data;
14     }
15 }
16 
17 abstract contract Ownable is Context {
18     address private _owner;
19 
20     event OwnershipTransferred(
21         address indexed previousOwner,
22         address indexed newOwner
23     );
24 
25     /**
26      * @dev Initializes the contract setting the deployer as the initial owner.
27      */
28     constructor() internal {
29         address msgSender = _msgSender();
30         _owner = msgSender;
31         emit OwnershipTransferred(address(0), msgSender);
32     }
33 
34     /**
35      * @dev Returns the address of the current owner.
36      */
37     function owner() public view virtual returns (address) {
38         return _owner;
39     }
40 
41     /**
42      * @dev Throws if called by any account other than the owner.
43      */
44     modifier onlyOwner() {
45         require(owner() == _msgSender(), "Ownable: caller is not the owner");
46         _;
47     }
48 
49     /**
50      * @dev Leaves the contract without owner. It will not be possible to call
51      * `onlyOwner` functions anymore. Can only be called by the current owner.
52      *
53      * NOTE: Renouncing ownership will leave the contract without an owner,
54      * thereby removing any functionality that is only available to the owner.
55      */
56     function renounceOwnership() public virtual onlyOwner {
57         emit OwnershipTransferred(_owner, address(0));
58         _owner = address(0);
59     }
60 
61     /**
62      * @dev Transfers ownership of the contract to a new account (`newOwner`).
63      * Can only be called by the current owner.
64      */
65     function transferOwnership(address newOwner) public virtual onlyOwner {
66         require(
67             newOwner != address(0),
68             "Ownable: new owner is the zero address"
69         );
70         emit OwnershipTransferred(_owner, newOwner);
71         _owner = newOwner;
72     }
73 }
74 
75 library SafeMath {
76     /**
77      * @dev Returns the addition of two unsigned integers, with an overflow flag.
78      *
79      * _Available since v3.4._
80      */
81     function tryAdd(uint256 a, uint256 b)
82         internal
83         pure
84         returns (bool, uint256)
85     {
86         uint256 c = a + b;
87         if (c < a) return (false, 0);
88         return (true, c);
89     }
90 
91     /**
92      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
93      *
94      * _Available since v3.4._
95      */
96     function trySub(uint256 a, uint256 b)
97         internal
98         pure
99         returns (bool, uint256)
100     {
101         if (b > a) return (false, 0);
102         return (true, a - b);
103     }
104 
105     /**
106      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
107      *
108      * _Available since v3.4._
109      */
110     function tryMul(uint256 a, uint256 b)
111         internal
112         pure
113         returns (bool, uint256)
114     {
115         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
116         // benefit is lost if 'b' is also tested.
117         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
118         if (a == 0) return (true, 0);
119         uint256 c = a * b;
120         if (c / a != b) return (false, 0);
121         return (true, c);
122     }
123 
124     /**
125      * @dev Returns the division of two unsigned integers, with a division by zero flag.
126      *
127      * _Available since v3.4._
128      */
129     function tryDiv(uint256 a, uint256 b)
130         internal
131         pure
132         returns (bool, uint256)
133     {
134         if (b == 0) return (false, 0);
135         return (true, a / b);
136     }
137 
138     /**
139      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
140      *
141      * _Available since v3.4._
142      */
143     function tryMod(uint256 a, uint256 b)
144         internal
145         pure
146         returns (bool, uint256)
147     {
148         if (b == 0) return (false, 0);
149         return (true, a % b);
150     }
151 
152     /**
153      * @dev Returns the addition of two unsigned integers, reverting on
154      * overflow.
155      *
156      * Counterpart to Solidity's `+` operator.
157      *
158      * Requirements:
159      *
160      * - Addition cannot overflow.
161      */
162     function add(uint256 a, uint256 b) internal pure returns (uint256) {
163         uint256 c = a + b;
164         require(c >= a, "SafeMath: addition overflow");
165         return c;
166     }
167 
168     /**
169      * @dev Returns the subtraction of two unsigned integers, reverting on
170      * overflow (when the result is negative).
171      *
172      * Counterpart to Solidity's `-` operator.
173      *
174      * Requirements:
175      *
176      * - Subtraction cannot overflow.
177      */
178     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
179         require(b <= a, "SafeMath: subtraction overflow");
180         return a - b;
181     }
182 
183     /**
184      * @dev Returns the multiplication of two unsigned integers, reverting on
185      * overflow.
186      *
187      * Counterpart to Solidity's `*` operator.
188      *
189      * Requirements:
190      *
191      * - Multiplication cannot overflow.
192      */
193     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
194         if (a == 0) return 0;
195         uint256 c = a * b;
196         require(c / a == b, "SafeMath: multiplication overflow");
197         return c;
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers, reverting on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator. Note: this function uses a
205      * `revert` opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function div(uint256 a, uint256 b) internal pure returns (uint256) {
213         require(b > 0, "SafeMath: division by zero");
214         return a / b;
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * reverting when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
230         require(b > 0, "SafeMath: modulo by zero");
231         return a % b;
232     }
233 
234     /**
235      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
236      * overflow (when the result is negative).
237      *
238      * CAUTION: This function is deprecated because it requires allocating memory for the error
239      * message unnecessarily. For custom revert reasons use {trySub}.
240      *
241      * Counterpart to Solidity's `-` operator.
242      *
243      * Requirements:
244      *
245      * - Subtraction cannot overflow.
246      */
247     function sub(
248         uint256 a,
249         uint256 b,
250         string memory errorMessage
251     ) internal pure returns (uint256) {
252         require(b <= a, errorMessage);
253         return a - b;
254     }
255 
256     /**
257      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
258      * division by zero. The result is rounded towards zero.
259      *
260      * CAUTION: This function is deprecated because it requires allocating memory for the error
261      * message unnecessarily. For custom revert reasons use {tryDiv}.
262      *
263      * Counterpart to Solidity's `/` operator. Note: this function uses a
264      * `revert` opcode (which leaves remaining gas untouched) while Solidity
265      * uses an invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      *
269      * - The divisor cannot be zero.
270      */
271     function div(
272         uint256 a,
273         uint256 b,
274         string memory errorMessage
275     ) internal pure returns (uint256) {
276         require(b > 0, errorMessage);
277         return a / b;
278     }
279 
280     /**
281      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
282      * reverting with custom message when dividing by zero.
283      *
284      * CAUTION: This function is deprecated because it requires allocating memory for the error
285      * message unnecessarily. For custom revert reasons use {tryMod}.
286      *
287      * Counterpart to Solidity's `%` operator. This function uses a `revert`
288      * opcode (which leaves remaining gas untouched) while Solidity uses an
289      * invalid opcode to revert (consuming all remaining gas).
290      *
291      * Requirements:
292      *
293      * - The divisor cannot be zero.
294      */
295     function mod(
296         uint256 a,
297         uint256 b,
298         string memory errorMessage
299     ) internal pure returns (uint256) {
300         require(b > 0, errorMessage);
301         return a % b;
302     }
303 }
304 
305 library Counters {
306     using SafeMath for uint256;
307 
308     struct Counter {
309         // This variable should never be directly accessed by users of the library: interactions must be restricted to
310         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
311         // this feature: see https://github.com/ethereum/solidity/issues/4637
312         uint256 _value; // default: 0
313     }
314 
315     function current(Counter storage counter) internal view returns (uint256) {
316         return counter._value;
317     }
318 
319     function increment(Counter storage counter) internal {
320         // The {SafeMath} overflow check can be skipped here, see the comment at the top
321         counter._value += 1;
322     }
323 
324     function decrement(Counter storage counter) internal {
325         counter._value = counter._value.sub(1);
326     }
327 }
328 
329 interface IERC165 {
330     /**
331      * @dev Returns true if this contract implements the interface defined by
332      * `interfaceId`. See the corresponding
333      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
334      * to learn more about how these ids are created.
335      *
336      * This function call must use less than 30 000 gas.
337      */
338     function supportsInterface(bytes4 interfaceId) external view returns (bool);
339 }
340 
341 interface IERC721 is IERC165 {
342     /**
343      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
344      */
345     event Transfer(
346         address indexed from,
347         address indexed to,
348         uint256 indexed tokenId
349     );
350 
351     /**
352      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
353      */
354     event Approval(
355         address indexed owner,
356         address indexed approved,
357         uint256 indexed tokenId
358     );
359 
360     /**
361      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
362      */
363     event ApprovalForAll(
364         address indexed owner,
365         address indexed operator,
366         bool approved
367     );
368 
369     /**
370      * @dev Returns the number of tokens in ``owner``'s account.
371      */
372     function balanceOf(address owner) external view returns (uint256 balance);
373 
374     /**
375      * @dev Returns the owner of the `tokenId` token.
376      *
377      * Requirements:
378      *
379      * - `tokenId` must exist.
380      */
381     function ownerOf(uint256 tokenId) external view returns (address owner);
382 
383     /**
384      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
385      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
386      *
387      * Requirements:
388      *
389      * - `from` cannot be the zero address.
390      * - `to` cannot be the zero address.
391      * - `tokenId` token must exist and be owned by `from`.
392      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
393      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
394      *
395      * Emits a {Transfer} event.
396      */
397     function safeTransferFrom(
398         address from,
399         address to,
400         uint256 tokenId
401     ) external;
402 
403     /**
404      * @dev Transfers `tokenId` token from `from` to `to`.
405      *
406      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
407      *
408      * Requirements:
409      *
410      * - `from` cannot be the zero address.
411      * - `to` cannot be the zero address.
412      * - `tokenId` token must be owned by `from`.
413      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
414      *
415      * Emits a {Transfer} event.
416      */
417     function transferFrom(
418         address from,
419         address to,
420         uint256 tokenId
421     ) external;
422 
423     /**
424      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
425      * The approval is cleared when the token is transferred.
426      *
427      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
428      *
429      * Requirements:
430      *
431      * - The caller must own the token or be an approved operator.
432      * - `tokenId` must exist.
433      *
434      * Emits an {Approval} event.
435      */
436     function approve(address to, uint256 tokenId) external;
437 
438     /**
439      * @dev Returns the account approved for `tokenId` token.
440      *
441      * Requirements:
442      *
443      * - `tokenId` must exist.
444      */
445     function getApproved(uint256 tokenId)
446         external
447         view
448         returns (address operator);
449 
450     /**
451      * @dev Approve or remove `operator` as an operator for the caller.
452      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
453      *
454      * Requirements:
455      *
456      * - The `operator` cannot be the caller.
457      *
458      * Emits an {ApprovalForAll} event.
459      */
460     function setApprovalForAll(address operator, bool _approved) external;
461 
462     /**
463      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
464      *
465      * See {setApprovalForAll}
466      */
467     function isApprovedForAll(address owner, address operator)
468         external
469         view
470         returns (bool);
471 
472     /**
473      * @dev Safely transfers `tokenId` token from `from` to `to`.
474      *
475      * Requirements:
476      *
477      * - `from` cannot be the zero address.
478      * - `to` cannot be the zero address.
479      * - `tokenId` token must exist and be owned by `from`.
480      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
481      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
482      *
483      * Emits a {Transfer} event.
484      */
485     function safeTransferFrom(
486         address from,
487         address to,
488         uint256 tokenId,
489         bytes calldata data
490     ) external;
491 }
492 
493 interface IERC721Metadata is IERC721 {
494     /**
495      * @dev Returns the token collection name.
496      */
497     function name() external view returns (string memory);
498 
499     /**
500      * @dev Returns the token collection symbol.
501      */
502     function symbol() external view returns (string memory);
503 
504     /**
505      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
506      */
507     function tokenURI(uint256 tokenId) external view returns (string memory);
508 }
509 
510 interface IERC721Enumerable is IERC721 {
511     /**
512      * @dev Returns the total amount of tokens stored by the contract.
513      */
514     function totalSupply() external view returns (uint256);
515 
516     /**
517      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
518      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
519      */
520     function tokenOfOwnerByIndex(address owner, uint256 index)
521         external
522         view
523         returns (uint256 tokenId);
524 
525     /**
526      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
527      * Use along with {totalSupply} to enumerate all tokens.
528      */
529     function tokenByIndex(uint256 index) external view returns (uint256);
530 }
531 
532 interface IERC721Receiver {
533     /**
534      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
535      * by `operator` from `from`, this function is called.
536      *
537      * It must return its Solidity selector to confirm the token transfer.
538      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
539      *
540      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
541      */
542     function onERC721Received(
543         address operator,
544         address from,
545         uint256 tokenId,
546         bytes calldata data
547     ) external returns (bytes4);
548 }
549 
550 abstract contract ERC165 is IERC165 {
551     /*
552      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
553      */
554     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
555 
556     /**
557      * @dev Mapping of interface ids to whether or not it's supported.
558      */
559     mapping(bytes4 => bool) private _supportedInterfaces;
560 
561     constructor() internal {
562         // Derived contracts need only register support for their own interfaces,
563         // we register support for ERC165 itself here
564         _registerInterface(_INTERFACE_ID_ERC165);
565     }
566 
567     /**
568      * @dev See {IERC165-supportsInterface}.
569      *
570      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
571      */
572     function supportsInterface(bytes4 interfaceId)
573         public
574         view
575         virtual
576         override
577         returns (bool)
578     {
579         return _supportedInterfaces[interfaceId];
580     }
581 
582     /**
583      * @dev Registers the contract as an implementer of the interface defined by
584      * `interfaceId`. Support of the actual ERC165 interface is automatic and
585      * registering its interface id is not required.
586      *
587      * See {IERC165-supportsInterface}.
588      *
589      * Requirements:
590      *
591      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
592      */
593     function _registerInterface(bytes4 interfaceId) internal virtual {
594         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
595         _supportedInterfaces[interfaceId] = true;
596     }
597 }
598 
599 library Address {
600     /**
601      * @dev Returns true if `account` is a contract.
602      *
603      * [IMPORTANT]
604      * ====
605      * It is unsafe to assume that an address for which this function returns
606      * false is an externally-owned account (EOA) and not a contract.
607      *
608      * Among others, `isContract` will return false for the following
609      * types of addresses:
610      *
611      *  - an externally-owned account
612      *  - a contract in construction
613      *  - an address where a contract will be created
614      *  - an address where a contract lived, but was destroyed
615      * ====
616      */
617     function isContract(address account) internal view returns (bool) {
618         // This method relies on extcodesize, which returns 0 for contracts in
619         // construction, since the code is only stored at the end of the
620         // constructor execution.
621 
622         uint256 size;
623         // solhint-disable-next-line no-inline-assembly
624         assembly {
625             size := extcodesize(account)
626         }
627         return size > 0;
628     }
629 
630     /**
631      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
632      * `recipient`, forwarding all available gas and reverting on errors.
633      *
634      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
635      * of certain opcodes, possibly making contracts go over the 2300 gas limit
636      * imposed by `transfer`, making them unable to receive funds via
637      * `transfer`. {sendValue} removes this limitation.
638      *
639      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
640      *
641      * IMPORTANT: because control is transferred to `recipient`, care must be
642      * taken to not create reentrancy vulnerabilities. Consider using
643      * {ReentrancyGuard} or the
644      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
645      */
646     function sendValue(address payable recipient, uint256 amount) internal {
647         require(
648             address(this).balance >= amount,
649             "Address: insufficient balance"
650         );
651 
652         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
653         (bool success, ) = recipient.call{value: amount}("");
654         require(
655             success,
656             "Address: unable to send value, recipient may have reverted"
657         );
658     }
659 
660     /**
661      * @dev Performs a Solidity function call using a low level `call`. A
662      * plain`call` is an unsafe replacement for a function call: use this
663      * function instead.
664      *
665      * If `target` reverts with a revert reason, it is bubbled up by this
666      * function (like regular Solidity function calls).
667      *
668      * Returns the raw returned data. To convert to the expected return value,
669      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
670      *
671      * Requirements:
672      *
673      * - `target` must be a contract.
674      * - calling `target` with `data` must not revert.
675      *
676      * _Available since v3.1._
677      */
678     function functionCall(address target, bytes memory data)
679         internal
680         returns (bytes memory)
681     {
682         return functionCall(target, data, "Address: low-level call failed");
683     }
684 
685     /**
686      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
687      * `errorMessage` as a fallback revert reason when `target` reverts.
688      *
689      * _Available since v3.1._
690      */
691     function functionCall(
692         address target,
693         bytes memory data,
694         string memory errorMessage
695     ) internal returns (bytes memory) {
696         return functionCallWithValue(target, data, 0, errorMessage);
697     }
698 
699     /**
700      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
701      * but also transferring `value` wei to `target`.
702      *
703      * Requirements:
704      *
705      * - the calling contract must have an ETH balance of at least `value`.
706      * - the called Solidity function must be `payable`.
707      *
708      * _Available since v3.1._
709      */
710     function functionCallWithValue(
711         address target,
712         bytes memory data,
713         uint256 value
714     ) internal returns (bytes memory) {
715         return
716             functionCallWithValue(
717                 target,
718                 data,
719                 value,
720                 "Address: low-level call with value failed"
721             );
722     }
723 
724     /**
725      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
726      * with `errorMessage` as a fallback revert reason when `target` reverts.
727      *
728      * _Available since v3.1._
729      */
730     function functionCallWithValue(
731         address target,
732         bytes memory data,
733         uint256 value,
734         string memory errorMessage
735     ) internal returns (bytes memory) {
736         require(
737             address(this).balance >= value,
738             "Address: insufficient balance for call"
739         );
740         require(isContract(target), "Address: call to non-contract");
741 
742         // solhint-disable-next-line avoid-low-level-calls
743         (bool success, bytes memory returndata) =
744             target.call{value: value}(data);
745         return _verifyCallResult(success, returndata, errorMessage);
746     }
747 
748     /**
749      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
750      * but performing a static call.
751      *
752      * _Available since v3.3._
753      */
754     function functionStaticCall(address target, bytes memory data)
755         internal
756         view
757         returns (bytes memory)
758     {
759         return
760             functionStaticCall(
761                 target,
762                 data,
763                 "Address: low-level static call failed"
764             );
765     }
766 
767     /**
768      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
769      * but performing a static call.
770      *
771      * _Available since v3.3._
772      */
773     function functionStaticCall(
774         address target,
775         bytes memory data,
776         string memory errorMessage
777     ) internal view returns (bytes memory) {
778         require(isContract(target), "Address: static call to non-contract");
779 
780         // solhint-disable-next-line avoid-low-level-calls
781         (bool success, bytes memory returndata) = target.staticcall(data);
782         return _verifyCallResult(success, returndata, errorMessage);
783     }
784 
785     /**
786      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
787      * but performing a delegate call.
788      *
789      * _Available since v3.4._
790      */
791     function functionDelegateCall(address target, bytes memory data)
792         internal
793         returns (bytes memory)
794     {
795         return
796             functionDelegateCall(
797                 target,
798                 data,
799                 "Address: low-level delegate call failed"
800             );
801     }
802 
803     /**
804      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
805      * but performing a delegate call.
806      *
807      * _Available since v3.4._
808      */
809     function functionDelegateCall(
810         address target,
811         bytes memory data,
812         string memory errorMessage
813     ) internal returns (bytes memory) {
814         require(isContract(target), "Address: delegate call to non-contract");
815 
816         // solhint-disable-next-line avoid-low-level-calls
817         (bool success, bytes memory returndata) = target.delegatecall(data);
818         return _verifyCallResult(success, returndata, errorMessage);
819     }
820 
821     function _verifyCallResult(
822         bool success,
823         bytes memory returndata,
824         string memory errorMessage
825     ) private pure returns (bytes memory) {
826         if (success) {
827             return returndata;
828         } else {
829             // Look for revert reason and bubble it up if present
830             if (returndata.length > 0) {
831                 // The easiest way to bubble the revert reason is using memory via assembly
832 
833                 // solhint-disable-next-line no-inline-assembly
834                 assembly {
835                     let returndata_size := mload(returndata)
836                     revert(add(32, returndata), returndata_size)
837                 }
838             } else {
839                 revert(errorMessage);
840             }
841         }
842     }
843 }
844 
845 library EnumerableSet {
846     // To implement this library for multiple types with as little code
847     // repetition as possible, we write it in terms of a generic Set type with
848     // bytes32 values.
849     // The Set implementation uses private functions, and user-facing
850     // implementations (such as AddressSet) are just wrappers around the
851     // underlying Set.
852     // This means that we can only create new EnumerableSets for types that fit
853     // in bytes32.
854 
855     struct Set {
856         // Storage of set values
857         bytes32[] _values;
858         // Position of the value in the `values` array, plus 1 because index 0
859         // means a value is not in the set.
860         mapping(bytes32 => uint256) _indexes;
861     }
862 
863     /**
864      * @dev Add a value to a set. O(1).
865      *
866      * Returns true if the value was added to the set, that is if it was not
867      * already present.
868      */
869     function _add(Set storage set, bytes32 value) private returns (bool) {
870         if (!_contains(set, value)) {
871             set._values.push(value);
872             // The value is stored at length-1, but we add 1 to all indexes
873             // and use 0 as a sentinel value
874             set._indexes[value] = set._values.length;
875             return true;
876         } else {
877             return false;
878         }
879     }
880 
881     /**
882      * @dev Removes a value from a set. O(1).
883      *
884      * Returns true if the value was removed from the set, that is if it was
885      * present.
886      */
887     function _remove(Set storage set, bytes32 value) private returns (bool) {
888         // We read and store the value's index to prevent multiple reads from the same storage slot
889         uint256 valueIndex = set._indexes[value];
890 
891         if (valueIndex != 0) {
892             // Equivalent to contains(set, value)
893             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
894             // the array, and then remove the last element (sometimes called as 'swap and pop').
895             // This modifies the order of the array, as noted in {at}.
896 
897             uint256 toDeleteIndex = valueIndex - 1;
898             uint256 lastIndex = set._values.length - 1;
899 
900             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
901             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
902 
903             bytes32 lastvalue = set._values[lastIndex];
904 
905             // Move the last value to the index where the value to delete is
906             set._values[toDeleteIndex] = lastvalue;
907             // Update the index for the moved value
908             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
909 
910             // Delete the slot where the moved value was stored
911             set._values.pop();
912 
913             // Delete the index for the deleted slot
914             delete set._indexes[value];
915 
916             return true;
917         } else {
918             return false;
919         }
920     }
921 
922     /**
923      * @dev Returns true if the value is in the set. O(1).
924      */
925     function _contains(Set storage set, bytes32 value)
926         private
927         view
928         returns (bool)
929     {
930         return set._indexes[value] != 0;
931     }
932 
933     /**
934      * @dev Returns the number of values on the set. O(1).
935      */
936     function _length(Set storage set) private view returns (uint256) {
937         return set._values.length;
938     }
939 
940     /**
941      * @dev Returns the value stored at position `index` in the set. O(1).
942      *
943      * Note that there are no guarantees on the ordering of values inside the
944      * array, and it may change when more values are added or removed.
945      *
946      * Requirements:
947      *
948      * - `index` must be strictly less than {length}.
949      */
950     function _at(Set storage set, uint256 index)
951         private
952         view
953         returns (bytes32)
954     {
955         require(
956             set._values.length > index,
957             "EnumerableSet: index out of bounds"
958         );
959         return set._values[index];
960     }
961 
962     // Bytes32Set
963 
964     struct Bytes32Set {
965         Set _inner;
966     }
967 
968     /**
969      * @dev Add a value to a set. O(1).
970      *
971      * Returns true if the value was added to the set, that is if it was not
972      * already present.
973      */
974     function add(Bytes32Set storage set, bytes32 value)
975         internal
976         returns (bool)
977     {
978         return _add(set._inner, value);
979     }
980 
981     /**
982      * @dev Removes a value from a set. O(1).
983      *
984      * Returns true if the value was removed from the set, that is if it was
985      * present.
986      */
987     function remove(Bytes32Set storage set, bytes32 value)
988         internal
989         returns (bool)
990     {
991         return _remove(set._inner, value);
992     }
993 
994     /**
995      * @dev Returns true if the value is in the set. O(1).
996      */
997     function contains(Bytes32Set storage set, bytes32 value)
998         internal
999         view
1000         returns (bool)
1001     {
1002         return _contains(set._inner, value);
1003     }
1004 
1005     /**
1006      * @dev Returns the number of values in the set. O(1).
1007      */
1008     function length(Bytes32Set storage set) internal view returns (uint256) {
1009         return _length(set._inner);
1010     }
1011 
1012     /**
1013      * @dev Returns the value stored at position `index` in the set. O(1).
1014      *
1015      * Note that there are no guarantees on the ordering of values inside the
1016      * array, and it may change when more values are added or removed.
1017      *
1018      * Requirements:
1019      *
1020      * - `index` must be strictly less than {length}.
1021      */
1022     function at(Bytes32Set storage set, uint256 index)
1023         internal
1024         view
1025         returns (bytes32)
1026     {
1027         return _at(set._inner, index);
1028     }
1029 
1030     // AddressSet
1031 
1032     struct AddressSet {
1033         Set _inner;
1034     }
1035 
1036     /**
1037      * @dev Add a value to a set. O(1).
1038      *
1039      * Returns true if the value was added to the set, that is if it was not
1040      * already present.
1041      */
1042     function add(AddressSet storage set, address value)
1043         internal
1044         returns (bool)
1045     {
1046         return _add(set._inner, bytes32(uint256(uint160(value))));
1047     }
1048 
1049     /**
1050      * @dev Removes a value from a set. O(1).
1051      *
1052      * Returns true if the value was removed from the set, that is if it was
1053      * present.
1054      */
1055     function remove(AddressSet storage set, address value)
1056         internal
1057         returns (bool)
1058     {
1059         return _remove(set._inner, bytes32(uint256(uint160(value))));
1060     }
1061 
1062     /**
1063      * @dev Returns true if the value is in the set. O(1).
1064      */
1065     function contains(AddressSet storage set, address value)
1066         internal
1067         view
1068         returns (bool)
1069     {
1070         return _contains(set._inner, bytes32(uint256(uint160(value))));
1071     }
1072 
1073     /**
1074      * @dev Returns the number of values in the set. O(1).
1075      */
1076     function length(AddressSet storage set) internal view returns (uint256) {
1077         return _length(set._inner);
1078     }
1079 
1080     /**
1081      * @dev Returns the value stored at position `index` in the set. O(1).
1082      *
1083      * Note that there are no guarantees on the ordering of values inside the
1084      * array, and it may change when more values are added or removed.
1085      *
1086      * Requirements:
1087      *
1088      * - `index` must be strictly less than {length}.
1089      */
1090     function at(AddressSet storage set, uint256 index)
1091         internal
1092         view
1093         returns (address)
1094     {
1095         return address(uint160(uint256(_at(set._inner, index))));
1096     }
1097 
1098     // UintSet
1099 
1100     struct UintSet {
1101         Set _inner;
1102     }
1103 
1104     /**
1105      * @dev Add a value to a set. O(1).
1106      *
1107      * Returns true if the value was added to the set, that is if it was not
1108      * already present.
1109      */
1110     function add(UintSet storage set, uint256 value) internal returns (bool) {
1111         return _add(set._inner, bytes32(value));
1112     }
1113 
1114     /**
1115      * @dev Removes a value from a set. O(1).
1116      *
1117      * Returns true if the value was removed from the set, that is if it was
1118      * present.
1119      */
1120     function remove(UintSet storage set, uint256 value)
1121         internal
1122         returns (bool)
1123     {
1124         return _remove(set._inner, bytes32(value));
1125     }
1126 
1127     /**
1128      * @dev Returns true if the value is in the set. O(1).
1129      */
1130     function contains(UintSet storage set, uint256 value)
1131         internal
1132         view
1133         returns (bool)
1134     {
1135         return _contains(set._inner, bytes32(value));
1136     }
1137 
1138     /**
1139      * @dev Returns the number of values on the set. O(1).
1140      */
1141     function length(UintSet storage set) internal view returns (uint256) {
1142         return _length(set._inner);
1143     }
1144 
1145     /**
1146      * @dev Returns the value stored at position `index` in the set. O(1).
1147      *
1148      * Note that there are no guarantees on the ordering of values inside the
1149      * array, and it may change when more values are added or removed.
1150      *
1151      * Requirements:
1152      *
1153      * - `index` must be strictly less than {length}.
1154      */
1155     function at(UintSet storage set, uint256 index)
1156         internal
1157         view
1158         returns (uint256)
1159     {
1160         return uint256(_at(set._inner, index));
1161     }
1162 }
1163 
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
1461 library Strings {
1462     /**
1463      * @dev Converts a `uint256` to its ASCII `string` representation.
1464      */
1465     function toString(uint256 value) internal pure returns (string memory) {
1466         // Inspired by OraclizeAPI's implementation - MIT licence
1467         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1468 
1469         if (value == 0) {
1470             return "0";
1471         }
1472         uint256 temp = value;
1473         uint256 digits;
1474         while (temp != 0) {
1475             digits++;
1476             temp /= 10;
1477         }
1478         bytes memory buffer = new bytes(digits);
1479         uint256 index = digits - 1;
1480         temp = value;
1481         while (temp != 0) {
1482             buffer[index--] = bytes1(uint8(48 + (temp % 10)));
1483             temp /= 10;
1484         }
1485         return string(buffer);
1486     }
1487 }
1488 
1489 contract ERC721 is
1490     Context,
1491     ERC165,
1492     IERC721,
1493     IERC721Metadata,
1494     IERC721Enumerable
1495 {
1496     using SafeMath for uint256;
1497     using Address for address;
1498     using EnumerableSet for EnumerableSet.UintSet;
1499     using EnumerableMap for EnumerableMap.UintToAddressMap;
1500     using Strings for uint256;
1501 
1502     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1503     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1504     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1505 
1506     // Mapping from holder address to their (enumerable) set of owned tokens
1507     mapping(address => EnumerableSet.UintSet) private _holderTokens;
1508 
1509     // Enumerable mapping from token ids to their owners
1510     EnumerableMap.UintToAddressMap private _tokenOwners;
1511 
1512     // Mapping from token ID to approved address
1513     mapping(uint256 => address) private _tokenApprovals;
1514 
1515     // Mapping from owner to operator approvals
1516     mapping(address => mapping(address => bool)) private _operatorApprovals;
1517 
1518     // Token name
1519     string private _name;
1520 
1521     // Token symbol
1522     string private _symbol;
1523 
1524     // Optional mapping for token URIs
1525     mapping(uint256 => string) private _tokenURIs;
1526 
1527     // Base URI
1528     string private _baseURI;
1529 
1530     /*
1531      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1532      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1533      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1534      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1535      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1536      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1537      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1538      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1539      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1540      *
1541      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1542      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1543      */
1544     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1545 
1546     /*
1547      *     bytes4(keccak256('name()')) == 0x06fdde03
1548      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1549      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1550      *
1551      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1552      */
1553     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1554 
1555     /*
1556      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1557      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1558      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1559      *
1560      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1561      */
1562     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1563 
1564     /**
1565      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1566      */
1567     constructor(string memory name_, string memory symbol_) public {
1568         _name = name_;
1569         _symbol = symbol_;
1570 
1571         // register the supported interfaces to conform to ERC721 via ERC165
1572         _registerInterface(_INTERFACE_ID_ERC721);
1573         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1574         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1575     }
1576 
1577     /**
1578      * @dev See {IERC721-balanceOf}.
1579      */
1580     function balanceOf(address owner)
1581         public
1582         view
1583         virtual
1584         override
1585         returns (uint256)
1586     {
1587         require(
1588             owner != address(0),
1589             "ERC721: balance query for the zero address"
1590         );
1591         return _holderTokens[owner].length();
1592     }
1593 
1594     /**
1595      * @dev See {IERC721-ownerOf}.
1596      */
1597     function ownerOf(uint256 tokenId)
1598         public
1599         view
1600         virtual
1601         override
1602         returns (address)
1603     {
1604         return
1605             _tokenOwners.get(
1606                 tokenId,
1607                 "ERC721: owner query for nonexistent token"
1608             );
1609     }
1610 
1611     /**
1612      * @dev See {IERC721Metadata-name}.
1613      */
1614     function name() public view virtual override returns (string memory) {
1615         return _name;
1616     }
1617 
1618     /**
1619      * @dev See {IERC721Metadata-symbol}.
1620      */
1621     function symbol() public view virtual override returns (string memory) {
1622         return _symbol;
1623     }
1624 
1625     /**
1626      * @dev See {IERC721Metadata-tokenURI}.
1627      */
1628     function tokenURI(uint256 tokenId)
1629         public
1630         view
1631         virtual
1632         override
1633         returns (string memory)
1634     {
1635         require(
1636             _exists(tokenId),
1637             "ERC721Metadata: URI query for nonexistent token"
1638         );
1639 
1640         string memory _tokenURI = _tokenURIs[tokenId];
1641         string memory base = baseURI();
1642 
1643         // If there is no base URI, return the token URI.
1644         if (bytes(base).length == 0) {
1645             return _tokenURI;
1646         }
1647         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1648         if (bytes(_tokenURI).length > 0) {
1649             return string(abi.encodePacked(base, _tokenURI));
1650         }
1651         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1652         return string(abi.encodePacked(base, tokenId.toString()));
1653     }
1654 
1655     /**
1656      * @dev Returns the base URI set via {_setBaseURI}. This will be
1657      * automatically added as a prefix in {tokenURI} to each token's URI, or
1658      * to the token ID if no specific URI is set for that token ID.
1659      */
1660     function baseURI() public view virtual returns (string memory) {
1661         return _baseURI;
1662     }
1663 
1664     /**
1665      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1666      */
1667     function tokenOfOwnerByIndex(address owner, uint256 index)
1668         public
1669         view
1670         virtual
1671         override
1672         returns (uint256)
1673     {
1674         return _holderTokens[owner].at(index);
1675     }
1676 
1677     /**
1678      * @dev See {IERC721Enumerable-totalSupply}.
1679      */
1680     function totalSupply() public view virtual override returns (uint256) {
1681         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1682         return _tokenOwners.length();
1683     }
1684 
1685     /**
1686      * @dev See {IERC721Enumerable-tokenByIndex}.
1687      */
1688     function tokenByIndex(uint256 index)
1689         public
1690         view
1691         virtual
1692         override
1693         returns (uint256)
1694     {
1695         (uint256 tokenId, ) = _tokenOwners.at(index);
1696         return tokenId;
1697     }
1698 
1699     /**
1700      * @dev See {IERC721-approve}.
1701      */
1702     function approve(address to, uint256 tokenId) public virtual override {
1703         address owner = ERC721.ownerOf(tokenId);
1704         require(to != owner, "ERC721: approval to current owner");
1705 
1706         require(
1707             _msgSender() == owner ||
1708                 ERC721.isApprovedForAll(owner, _msgSender()),
1709             "ERC721: approve caller is not owner nor approved for all"
1710         );
1711 
1712         _approve(to, tokenId);
1713     }
1714 
1715     /**
1716      * @dev See {IERC721-getApproved}.
1717      */
1718     function getApproved(uint256 tokenId)
1719         public
1720         view
1721         virtual
1722         override
1723         returns (address)
1724     {
1725         require(
1726             _exists(tokenId),
1727             "ERC721: approved query for nonexistent token"
1728         );
1729 
1730         return _tokenApprovals[tokenId];
1731     }
1732 
1733     /**
1734      * @dev See {IERC721-setApprovalForAll}.
1735      */
1736     function setApprovalForAll(address operator, bool approved)
1737         public
1738         virtual
1739         override
1740     {
1741         require(operator != _msgSender(), "ERC721: approve to caller");
1742 
1743         _operatorApprovals[_msgSender()][operator] = approved;
1744         emit ApprovalForAll(_msgSender(), operator, approved);
1745     }
1746 
1747     /**
1748      * @dev See {IERC721-isApprovedForAll}.
1749      */
1750     function isApprovedForAll(address owner, address operator)
1751         public
1752         view
1753         virtual
1754         override
1755         returns (bool)
1756     {
1757         return _operatorApprovals[owner][operator];
1758     }
1759 
1760     /**
1761      * @dev See {IERC721-transferFrom}.
1762      */
1763     function transferFrom(
1764         address from,
1765         address to,
1766         uint256 tokenId
1767     ) public virtual override {
1768         //solhint-disable-next-line max-line-length
1769         require(
1770             _isApprovedOrOwner(_msgSender(), tokenId),
1771             "ERC721: transfer caller is not owner nor approved"
1772         );
1773 
1774         _transfer(from, to, tokenId);
1775     }
1776 
1777     /**
1778      * @dev See {IERC721-safeTransferFrom}.
1779      */
1780     function safeTransferFrom(
1781         address from,
1782         address to,
1783         uint256 tokenId
1784     ) public virtual override {
1785         safeTransferFrom(from, to, tokenId, "");
1786     }
1787 
1788     /**
1789      * @dev See {IERC721-safeTransferFrom}.
1790      */
1791     function safeTransferFrom(
1792         address from,
1793         address to,
1794         uint256 tokenId,
1795         bytes memory _data
1796     ) public virtual override {
1797         require(
1798             _isApprovedOrOwner(_msgSender(), tokenId),
1799             "ERC721: transfer caller is not owner nor approved"
1800         );
1801         _safeTransfer(from, to, tokenId, _data);
1802     }
1803 
1804     /**
1805      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1806      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1807      *
1808      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1809      *
1810      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1811      * implement alternative mechanisms to perform token transfer, such as signature-based.
1812      *
1813      * Requirements:
1814      *
1815      * - `from` cannot be the zero address.
1816      * - `to` cannot be the zero address.
1817      * - `tokenId` token must exist and be owned by `from`.
1818      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1819      *
1820      * Emits a {Transfer} event.
1821      */
1822     function _safeTransfer(
1823         address from,
1824         address to,
1825         uint256 tokenId,
1826         bytes memory _data
1827     ) internal virtual {
1828         _transfer(from, to, tokenId);
1829         require(
1830             _checkOnERC721Received(from, to, tokenId, _data),
1831             "ERC721: transfer to non ERC721Receiver implementer"
1832         );
1833     }
1834 
1835     /**
1836      * @dev Returns whether `tokenId` exists.
1837      *
1838      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1839      *
1840      * Tokens start existing when they are minted (`_mint`),
1841      * and stop existing when they are burned (`_burn`).
1842      */
1843     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1844         return _tokenOwners.contains(tokenId);
1845     }
1846 
1847     /**
1848      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1849      *
1850      * Requirements:
1851      *
1852      * - `tokenId` must exist.
1853      */
1854     function _isApprovedOrOwner(address spender, uint256 tokenId)
1855         internal
1856         view
1857         virtual
1858         returns (bool)
1859     {
1860         require(
1861             _exists(tokenId),
1862             "ERC721: operator query for nonexistent token"
1863         );
1864         address owner = ERC721.ownerOf(tokenId);
1865         return (spender == owner ||
1866             getApproved(tokenId) == spender ||
1867             ERC721.isApprovedForAll(owner, spender));
1868     }
1869 
1870     /**
1871      * @dev Safely mints `tokenId` and transfers it to `to`.
1872      *
1873      * Requirements:
1874      d*
1875      * - `tokenId` must not exist.
1876      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1877      *
1878      * Emits a {Transfer} event.
1879      */
1880     function _safeMint(address to, uint256 tokenId) internal virtual {
1881         _safeMint(to, tokenId, "");
1882     }
1883 
1884     /**
1885      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1886      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1887      */
1888     function _safeMint(
1889         address to,
1890         uint256 tokenId,
1891         bytes memory _data
1892     ) internal virtual {
1893         _mint(to, tokenId);
1894         require(
1895             _checkOnERC721Received(address(0), to, tokenId, _data),
1896             "ERC721: transfer to non ERC721Receiver implementer"
1897         );
1898     }
1899 
1900     /**
1901      * @dev Mints `tokenId` and transfers it to `to`.
1902      *
1903      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1904      *
1905      * Requirements:
1906      *
1907      * - `tokenId` must not exist.
1908      * - `to` cannot be the zero address.
1909      *
1910      * Emits a {Transfer} event.
1911      */
1912     function _mint(address to, uint256 tokenId) internal virtual {
1913         require(to != address(0), "ERC721: mint to the zero address");
1914         require(!_exists(tokenId), "ERC721: token already minted");
1915 
1916         _beforeTokenTransfer(address(0), to, tokenId);
1917 
1918         _holderTokens[to].add(tokenId);
1919 
1920         _tokenOwners.set(tokenId, to);
1921 
1922         emit Transfer(address(0), to, tokenId);
1923     }
1924 
1925     /**
1926      * @dev Destroys `tokenId`.
1927      * The approval is cleared when the token is burned.
1928      *
1929      * Requirements:
1930      *
1931      * - `tokenId` must exist.
1932      *
1933      * Emits a {Transfer} event.
1934      */
1935     function _burn(uint256 tokenId) internal virtual {
1936         address owner = ERC721.ownerOf(tokenId); // internal owner
1937 
1938         _beforeTokenTransfer(owner, address(0), tokenId);
1939 
1940         // Clear approvals
1941         _approve(address(0), tokenId);
1942 
1943         // Clear metadata (if any)
1944         if (bytes(_tokenURIs[tokenId]).length != 0) {
1945             delete _tokenURIs[tokenId];
1946         }
1947 
1948         _holderTokens[owner].remove(tokenId);
1949 
1950         _tokenOwners.remove(tokenId);
1951 
1952         emit Transfer(owner, address(0), tokenId);
1953     }
1954 
1955     /**
1956      * @dev Transfers `tokenId` from `from` to `to`.
1957      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1958      *
1959      * Requirements:
1960      *
1961      * - `to` cannot be the zero address.
1962      * - `tokenId` token must be owned by `from`.
1963      *
1964      * Emits a {Transfer} event.
1965      */
1966     function _transfer(
1967         address from,
1968         address to,
1969         uint256 tokenId
1970     ) internal virtual {
1971         require(
1972             ERC721.ownerOf(tokenId) == from,
1973             "ERC721: transfer of token that is not own"
1974         ); // internal owner
1975         require(to != address(0), "ERC721: transfer to the zero address");
1976 
1977         _beforeTokenTransfer(from, to, tokenId);
1978 
1979         // Clear approvals from the previous owner
1980         _approve(address(0), tokenId);
1981 
1982         _holderTokens[from].remove(tokenId);
1983         _holderTokens[to].add(tokenId);
1984 
1985         _tokenOwners.set(tokenId, to);
1986 
1987         emit Transfer(from, to, tokenId);
1988     }
1989 
1990     /**
1991      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1992      *
1993      * Requirements:
1994      *
1995      * - `tokenId` must exist.
1996      */
1997     function _setTokenURI(uint256 tokenId, string memory _tokenURI)
1998         internal
1999         virtual
2000     {
2001         require(
2002             _exists(tokenId),
2003             "ERC721Metadata: URI set of nonexistent token"
2004         );
2005         _tokenURIs[tokenId] = _tokenURI;
2006     }
2007 
2008     /**
2009      * @dev Internal function to set the base URI for all token IDs. It is
2010      * automatically added as a prefix to the value returned in {tokenURI},
2011      * or to the token ID if {tokenURI} is empty.
2012      */
2013     function _setBaseURI(string memory baseURI_) internal virtual {
2014         _baseURI = baseURI_;
2015     }
2016 
2017     /**
2018      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2019      * The call is not executed if the target address is not a contract.
2020      *
2021      * @param from address representing the previous owner of the given token ID
2022      * @param to target address that will receive the tokens
2023      * @param tokenId uint256 ID of the token to be transferred
2024      * @param _data bytes optional data to send along with the call
2025      * @return bool whether the call correctly returned the expected magic value
2026      */
2027     function _checkOnERC721Received(
2028         address from,
2029         address to,
2030         uint256 tokenId,
2031         bytes memory _data
2032     ) private returns (bool) {
2033         if (!to.isContract()) {
2034             return true;
2035         }
2036         bytes memory returndata =
2037             to.functionCall(
2038                 abi.encodeWithSelector(
2039                     IERC721Receiver(to).onERC721Received.selector,
2040                     _msgSender(),
2041                     from,
2042                     tokenId,
2043                     _data
2044                 ),
2045                 "ERC721: transfer to non ERC721Receiver implementer"
2046             );
2047         bytes4 retval = abi.decode(returndata, (bytes4));
2048         return (retval == _ERC721_RECEIVED);
2049     }
2050 
2051     /**
2052      * @dev Approve `to` to operate on `tokenId`
2053      *
2054      * Emits an {Approval} event.
2055      */
2056     function _approve(address to, uint256 tokenId) internal virtual {
2057         _tokenApprovals[tokenId] = to;
2058         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
2059     }
2060 
2061     /**
2062      * @dev Hook that is called before any token transfer. This includes minting
2063      * and burning.
2064      *
2065      * Calling conditions:
2066      *
2067      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2068      * transferred to `to`.
2069      * - When `from` is zero, `tokenId` will be minted for `to`.
2070      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2071      * - `from` cannot be the zero address.
2072      * - `to` cannot be the zero address.
2073      *
2074      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2075      */
2076     function _beforeTokenTransfer(
2077         address from,
2078         address to,
2079         uint256 tokenId
2080     ) internal virtual {}
2081 }
2082 
2083 abstract contract Pausable is Context {
2084     /**
2085      * @dev Emitted when the pause is triggered by `account`.
2086      */
2087     event Paused(address account);
2088 
2089     /**
2090      * @dev Emitted when the pause is lifted by `account`.
2091      */
2092     event Unpaused(address account);
2093 
2094     bool private _paused;
2095 
2096     /**
2097      * @dev Initializes the contract in unpaused state.
2098      */
2099     constructor() internal {
2100         _paused = false;
2101     }
2102 
2103     /**
2104      * @dev Returns true if the contract is paused, and false otherwise.
2105      */
2106     function paused() public view virtual returns (bool) {
2107         return _paused;
2108     }
2109 
2110     /**
2111      * @dev Modifier to make a function callable only when the contract is not paused.
2112      *
2113      * Requirements:
2114      *
2115      * - The contract must not be paused.
2116      */
2117     modifier whenNotPaused() {
2118         require(!paused(), "Pausable: paused");
2119         _;
2120     }
2121 
2122     /**
2123      * @dev Modifier to make a function callable only when the contract is paused.
2124      *
2125      * Requirements:
2126      *
2127      * - The contract must be paused.
2128      */
2129     modifier whenPaused() {
2130         require(paused(), "Pausable: not paused");
2131         _;
2132     }
2133 
2134     /**
2135      * @dev Triggers stopped state.
2136      *
2137      * Requirements:
2138      *
2139      * - The contract must not be paused.
2140      */
2141     function _pause() internal virtual whenNotPaused {
2142         _paused = true;
2143         emit Paused(_msgSender());
2144     }
2145 
2146     /**
2147      * @dev Returns to normal state.
2148      *
2149      * Requirements:
2150      *
2151      * - The contract must be paused.
2152      */
2153     function _unpause() internal virtual whenPaused {
2154         _paused = false;
2155         emit Unpaused(_msgSender());
2156     }
2157 }
2158 
2159 abstract contract ERC721Pausable is ERC721, Pausable {
2160     /**
2161      * @dev See {ERC721-_beforeTokenTransfer}.
2162      *
2163      * Requirements:
2164      *
2165      * - the contract must not be paused.
2166      */
2167     function _beforeTokenTransfer(
2168         address from,
2169         address to,
2170         uint256 tokenId
2171     ) internal virtual override {
2172         super._beforeTokenTransfer(from, to, tokenId);
2173 
2174         require(!paused(), "ERC721Pausable: token transfer while paused");
2175     }
2176 }
2177 
2178 abstract contract ERC721Burnable is Context, ERC721 {
2179     /**
2180      * @dev Burns `tokenId`. See {ERC721-_burn}.
2181      *
2182      * Requirements:
2183      *
2184      * - The caller must own `tokenId` or be an approved operator.
2185      */
2186     function burn(uint256 tokenId) public virtual {
2187         //solhint-disable-next-line max-line-length
2188         require(
2189             _isApprovedOrOwner(_msgSender(), tokenId),
2190             "ERC721Burnable: caller is not owner nor approved"
2191         );
2192         _burn(tokenId);
2193     }
2194 }
2195 
2196 contract CryptoGogos is ERC721Burnable, ERC721Pausable, Ownable {
2197     using Counters for Counters.Counter;
2198     Counters.Counter private _tokenIds; //Counter is a struct in the Counters library
2199     using SafeMath for uint256;
2200 
2201     uint256 private maxSupply = 7777;
2202 
2203     uint256 private maxSalePrice = 1 ether;
2204 
2205     event MAX_SUPPLY_UPDATED(uint256 maxSupply);
2206     event MAX_PRICE_UPDATED(uint256 maxPrice);
2207 
2208     constructor(string memory _baseURI) public ERC721("GOGOS", "GOG") {
2209         _setBaseURI(_baseURI);
2210     }
2211 
2212     /**
2213      * @dev Gets current gogo Pack Price
2214      */
2215     function getNFTPackPrice() public view returns (uint256) {
2216         uint256 currentSupply = totalSupply();
2217 
2218         if (currentSupply >= 7150) {
2219             return maxSalePrice.mul(3 * 83333333).div(100000000);
2220         } else if (currentSupply >= 3150) {
2221             return 0.55 ether;
2222         } else if (currentSupply >= 850) {
2223             return 0.4 ether;
2224         } else {
2225             return 0;
2226         }
2227     }
2228 
2229     /**
2230      * @dev Gets current gogo Price
2231      */
2232     function getNFTPrice() public view returns (uint256) {
2233         uint256 currentSupply = totalSupply();
2234 
2235         if (currentSupply >= 7150) {
2236             return maxSalePrice;
2237         } else if (currentSupply >= 3150) {
2238             return 0.2 ether;
2239         } else if (currentSupply >= 1150) {
2240             return 0.15 ether;
2241         } else if (currentSupply >= 300) {
2242             return 0.1 ether;
2243         } else if (currentSupply >= 150) {
2244             return 0.07 ether;
2245         } else {
2246             return 0.05 ether;
2247         }
2248     }
2249 
2250     /**
2251      * @dev Gets current gogo Price
2252      */
2253     function cantMint() public view returns (bool) {
2254         uint256 currentSupply = totalSupply();
2255         if (currentSupply <= 150 && balanceOf(msg.sender) >= 2) return false;
2256         if (currentSupply <= 300 && balanceOf(msg.sender) >= 4) return false;
2257         return true;
2258     }
2259 
2260     /**
2261      * @dev Gets current gogo Price
2262      */
2263     function updateMaxPrice(uint256 _price) public onlyOwner {
2264         maxSalePrice = _price;
2265 
2266         emit MAX_PRICE_UPDATED(_price);
2267     }
2268 
2269     /**
2270      * @dev Creates a new token for `to`. Its token ID will be automatically
2271      * assigned (and available on the emitted {IERC721-Transfer} event), and the token
2272      * URI autogenerated based on the base URI passed at construction.
2273      *
2274      *
2275      * Requirements:
2276      *
2277      * - the caller must have the `MINTER_ROLE`.
2278      */
2279     function mintByAdmin(address to) public onlyOwner {
2280         _tokenIds.increment();
2281         uint256 newItemId = _tokenIds.current();
2282         require(newItemId <= maxSupply);
2283         _mint(to, newItemId);
2284     }
2285 
2286     /*
2287      *  _tokenURI is link to json
2288      */
2289     function mint() public payable returns (uint256) {
2290         require(getNFTPrice() == msg.value, "Ether value sent is not correct");
2291         require(!paused(), "ERC721Pausable: token mint while paused");
2292 
2293         uint256 currentSupply = totalSupply();
2294         if (!cantMint()) revert();
2295         _tokenIds.increment();
2296         uint256 newItemId = _tokenIds.current();
2297         require(newItemId <= maxSupply);
2298         _mint(msg.sender, newItemId);
2299         return newItemId;
2300     }
2301 
2302     /*
2303      *  _tokenURIs is a array of links to json
2304      */
2305     function mintPack() public payable returns (uint256) {
2306         require(totalSupply() >= 850, "Pack is not available now");
2307         require(
2308             getNFTPackPrice() == msg.value,
2309             "Ether value sent is not correct"
2310         );
2311         require(!paused(), "ERC721Pausable: token mint while paused");
2312 
2313         uint256 newItemId;
2314         for (uint256 i = 0; i < 3; i++) {
2315             _tokenIds.increment();
2316             newItemId = _tokenIds.current();
2317             require(newItemId <= maxSupply);
2318             _mint(msg.sender, newItemId);
2319         }
2320         return newItemId;
2321     }
2322 
2323     function updateBaseURI(string memory _baseURI) public onlyOwner {
2324         _setBaseURI(_baseURI);
2325     }
2326 
2327     /**
2328      * @dev Withdraw ether from this contract (Callable by owner)
2329      */
2330     function withdraw() external onlyOwner {
2331         uint256 balance = address(this).balance;
2332         msg.sender.transfer(balance);
2333     }
2334 
2335     /**
2336      * @dev See {ERC721-_beforeTokenTransfer}.
2337      *
2338      * Requirements:
2339      *
2340      * - the contract must not be paused.
2341      */
2342     function _beforeTokenTransfer(
2343         address from,
2344         address to,
2345         uint256 tokenId
2346     ) internal virtual override(ERC721Pausable, ERC721) {
2347         super._beforeTokenTransfer(from, to, tokenId);
2348     }
2349 
2350     /**
2351      * @dev Triggers stopped state.
2352      *
2353      * Requirements:
2354      *
2355      * - The contract must not be paused.
2356      */
2357     function pause() public onlyOwner whenNotPaused {
2358         _pause();
2359     }
2360 
2361     /**
2362      * @dev Returns to normal state.
2363      *
2364      * Requirements:
2365      *
2366      * - The contract must be paused.
2367      */
2368     function unpause() public onlyOwner whenPaused {
2369         _unpause();
2370     }
2371 
2372     function updateMaxSupply(uint256 _maxSupply) public onlyOwner {
2373         maxSupply = _maxSupply;
2374         emit MAX_SUPPLY_UPDATED(_maxSupply);
2375     }
2376 }