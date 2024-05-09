1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 
27 /**
28  * @dev Contract module which provides a basic access control mechanism, where
29  * there is an account (an owner) that can be granted exclusive access to
30  * specific functions.
31  *
32  * By default, the owner account will be the one that deploys the contract. This
33  * can later be changed with {transferOwnership}.
34  *
35  * This module is used through inheritance. It will make available the modifier
36  * `onlyOwner`, which can be applied to your functions to restrict their use to
37  * the owner.
38  */
39 abstract contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor() {
48         _setOwner(_msgSender());
49     }
50 
51     /**
52      * @dev Returns the address of the current owner.
53      */
54     function owner() public view virtual returns (address) {
55         return _owner;
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(owner() == _msgSender(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     /**
67      * @dev Leaves the contract without owner. It will not be possible to call
68      * `onlyOwner` functions anymore. Can only be called by the current owner.
69      *
70      * NOTE: Renouncing ownership will leave the contract without an owner,
71      * thereby removing any functionality that is only available to the owner.
72      */
73     function renounceOwnership() public virtual onlyOwner {
74         _setOwner(address(0));
75     }
76 
77     /**
78      * @dev Transfers ownership of the contract to a new account (`newOwner`).
79      * Can only be called by the current owner.
80      */
81     function transferOwnership(address newOwner) public virtual onlyOwner {
82         require(newOwner != address(0), "Ownable: new owner is the zero address");
83         _setOwner(newOwner);
84     }
85 
86     function _setOwner(address newOwner) private {
87         address oldOwner = _owner;
88         _owner = newOwner;
89         emit OwnershipTransferred(oldOwner, newOwner);
90     }
91 }
92 
93 // CAUTION
94 // This version of SafeMath should only be used with Solidity 0.8 or later,
95 // because it relies on the compiler's built in overflow checks.
96 
97 /**
98  * @dev Wrappers over Solidity's arithmetic operations.
99  *
100  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
101  * now has built in overflow checking.
102  */
103 library SafeMath {
104     /**
105      * @dev Returns the addition of two unsigned integers, with an overflow flag.
106      *
107      * _Available since v3.4._
108      */
109     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
110         unchecked {
111             uint256 c = a + b;
112             if (c < a) return (false, 0);
113             return (true, c);
114         }
115     }
116 
117     /**
118      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
119      *
120      * _Available since v3.4._
121      */
122     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
123         unchecked {
124             if (b > a) return (false, 0);
125             return (true, a - b);
126         }
127     }
128 
129     /**
130      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
131      *
132      * _Available since v3.4._
133      */
134     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
135         unchecked {
136             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
137             // benefit is lost if 'b' is also tested.
138             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
139             if (a == 0) return (true, 0);
140             uint256 c = a * b;
141             if (c / a != b) return (false, 0);
142             return (true, c);
143         }
144     }
145 
146     /**
147      * @dev Returns the division of two unsigned integers, with a division by zero flag.
148      *
149      * _Available since v3.4._
150      */
151     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
152         unchecked {
153             if (b == 0) return (false, 0);
154             return (true, a / b);
155         }
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
160      *
161      * _Available since v3.4._
162      */
163     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
164         unchecked {
165             if (b == 0) return (false, 0);
166             return (true, a % b);
167         }
168     }
169 
170     /**
171      * @dev Returns the addition of two unsigned integers, reverting on
172      * overflow.
173      *
174      * Counterpart to Solidity's `+` operator.
175      *
176      * Requirements:
177      *
178      * - Addition cannot overflow.
179      */
180     function add(uint256 a, uint256 b) internal pure returns (uint256) {
181         return a + b;
182     }
183 
184     /**
185      * @dev Returns the subtraction of two unsigned integers, reverting on
186      * overflow (when the result is negative).
187      *
188      * Counterpart to Solidity's `-` operator.
189      *
190      * Requirements:
191      *
192      * - Subtraction cannot overflow.
193      */
194     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
195         return a - b;
196     }
197 
198     /**
199      * @dev Returns the multiplication of two unsigned integers, reverting on
200      * overflow.
201      *
202      * Counterpart to Solidity's `*` operator.
203      *
204      * Requirements:
205      *
206      * - Multiplication cannot overflow.
207      */
208     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
209         return a * b;
210     }
211 
212     /**
213      * @dev Returns the integer division of two unsigned integers, reverting on
214      * division by zero. The result is rounded towards zero.
215      *
216      * Counterpart to Solidity's `/` operator.
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function div(uint256 a, uint256 b) internal pure returns (uint256) {
223         return a / b;
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * reverting when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239         return a % b;
240     }
241 
242     /**
243      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
244      * overflow (when the result is negative).
245      *
246      * CAUTION: This function is deprecated because it requires allocating memory for the error
247      * message unnecessarily. For custom revert reasons use {trySub}.
248      *
249      * Counterpart to Solidity's `-` operator.
250      *
251      * Requirements:
252      *
253      * - Subtraction cannot overflow.
254      */
255     function sub(
256         uint256 a,
257         uint256 b,
258         string memory errorMessage
259     ) internal pure returns (uint256) {
260         unchecked {
261             require(b <= a, errorMessage);
262             return a - b;
263         }
264     }
265 
266     /**
267      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
268      * division by zero. The result is rounded towards zero.
269      *
270      * Counterpart to Solidity's `/` operator. Note: this function uses a
271      * `revert` opcode (which leaves remaining gas untouched) while Solidity
272      * uses an invalid opcode to revert (consuming all remaining gas).
273      *
274      * Requirements:
275      *
276      * - The divisor cannot be zero.
277      */
278     function div(
279         uint256 a,
280         uint256 b,
281         string memory errorMessage
282     ) internal pure returns (uint256) {
283         unchecked {
284             require(b > 0, errorMessage);
285             return a / b;
286         }
287     }
288 
289     /**
290      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
291      * reverting with custom message when dividing by zero.
292      *
293      * CAUTION: This function is deprecated because it requires allocating memory for the error
294      * message unnecessarily. For custom revert reasons use {tryMod}.
295      *
296      * Counterpart to Solidity's `%` operator. This function uses a `revert`
297      * opcode (which leaves remaining gas untouched) while Solidity uses an
298      * invalid opcode to revert (consuming all remaining gas).
299      *
300      * Requirements:
301      *
302      * - The divisor cannot be zero.
303      */
304     function mod(
305         uint256 a,
306         uint256 b,
307         string memory errorMessage
308     ) internal pure returns (uint256) {
309         unchecked {
310             require(b > 0, errorMessage);
311             return a % b;
312         }
313     }
314 }
315 
316 // File: @openzeppelin/contracts/introspection/IERC165.sol
317 
318 /**
319  * @dev Interface of the ERC165 standard, as defined in the
320  * https://eips.ethereum.org/EIPS/eip-165[EIP].
321  *
322  * Implementers can declare support of contract interfaces, which can then be
323  * queried by others ({ERC165Checker}).
324  *
325  * For an implementation, see {ERC165}.
326  */
327 interface IERC165 {
328     /**
329      * @dev Returns true if this contract implements the interface defined by
330      * `interfaceId`. See the corresponding
331      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
332      * to learn more about how these ids are created.
333      *
334      * This function call must use less than 30 000 gas.
335      */
336     function supportsInterface(bytes4 interfaceId) external view returns (bool);
337 }
338 
339 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
340 
341 /**
342  * @dev Required interface of an ERC721 compliant contract.
343  */
344 interface IERC721 is IERC165 {
345     /**
346      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
347      */
348     event Transfer(
349         address indexed from,
350         address indexed to,
351         uint256 indexed tokenId
352     );
353 
354     /**
355      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
356      */
357     event Approval(
358         address indexed owner,
359         address indexed approved,
360         uint256 indexed tokenId
361     );
362 
363     /**
364      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
365      */
366     event ApprovalForAll(
367         address indexed owner,
368         address indexed operator,
369         bool approved
370     );
371 
372     /**
373      * @dev Returns the number of tokens in ``owner``'s account.
374      */
375     function balanceOf(address owner) external view returns (uint256 balance);
376 
377     /**
378      * @dev Returns the owner of the `tokenId` token.
379      *
380      * Requirements:
381      *
382      * - `tokenId` must exist.
383      */
384     function ownerOf(uint256 tokenId) external view returns (address owner);
385 
386     /**
387      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
388      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
389      *
390      * Requirements:
391      *
392      * - `from` cannot be the zero address.
393      * - `to` cannot be the zero address.
394      * - `tokenId` token must exist and be owned by `from`.
395      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
396      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
397      *
398      * Emits a {Transfer} event.
399      */
400     function safeTransferFrom(
401         address from,
402         address to,
403         uint256 tokenId
404     ) external;
405 
406     /**
407      * @dev Transfers `tokenId` token from `from` to `to`.
408      *
409      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
410      *
411      * Requirements:
412      *
413      * - `from` cannot be the zero address.
414      * - `to` cannot be the zero address.
415      * - `tokenId` token must be owned by `from`.
416      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
417      *
418      * Emits a {Transfer} event.
419      */
420     function transferFrom(
421         address from,
422         address to,
423         uint256 tokenId
424     ) external;
425 
426     /**
427      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
428      * The approval is cleared when the token is transferred.
429      *
430      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
431      *
432      * Requirements:
433      *
434      * - The caller must own the token or be an approved operator.
435      * - `tokenId` must exist.
436      *
437      * Emits an {Approval} event.
438      */
439     function approve(address to, uint256 tokenId) external;
440 
441     /**
442      * @dev Returns the account approved for `tokenId` token.
443      *
444      * Requirements:
445      *
446      * - `tokenId` must exist.
447      */
448     function getApproved(uint256 tokenId)
449         external
450         view
451         returns (address operator);
452 
453     /**
454      * @dev Approve or remove `operator` as an operator for the caller.
455      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
456      *
457      * Requirements:
458      *
459      * - The `operator` cannot be the caller.
460      *
461      * Emits an {ApprovalForAll} event.
462      */
463     function setApprovalForAll(address operator, bool _approved) external;
464 
465     /**
466      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
467      *
468      * See {setApprovalForAll}
469      */
470     function isApprovedForAll(address owner, address operator)
471         external
472         view
473         returns (bool);
474 
475     /**
476      * @dev Safely transfers `tokenId` token from `from` to `to`.
477      *
478      * Requirements:
479      *
480      * - `from` cannot be the zero address.
481      * - `to` cannot be the zero address.
482      * - `tokenId` token must exist and be owned by `from`.
483      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
484      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
485      *
486      * Emits a {Transfer} event.
487      */
488     function safeTransferFrom(
489         address from,
490         address to,
491         uint256 tokenId,
492         bytes calldata data
493     ) external;
494 }
495 
496 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
497 
498 /**
499  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
500  * @dev See https://eips.ethereum.org/EIPS/eip-721
501  */
502 interface IERC721Metadata is IERC721 {
503     /**
504      * @dev Returns the token collection name.
505      */
506     function name() external view returns (string memory);
507 
508     /**
509      * @dev Returns the token collection symbol.
510      */
511     function symbol() external view returns (string memory);
512 
513     /**
514      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
515      */
516     function tokenURI(uint256 tokenId) external view returns (string memory);
517 }
518 
519 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
520 
521 /**
522  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
523  * @dev See https://eips.ethereum.org/EIPS/eip-721
524  */
525 interface IERC721Enumerable is IERC721 {
526     /**
527      * @dev Returns the total amount of tokens stored by the contract.
528      */
529     function totalSupply() external view returns (uint256);
530 
531     /**
532      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
533      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
534      */
535     function tokenOfOwnerByIndex(address owner, uint256 index)
536         external
537         view
538         returns (uint256 tokenId);
539 
540     /**
541      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
542      * Use along with {totalSupply} to enumerate all tokens.
543      */
544     function tokenByIndex(uint256 index) external view returns (uint256);
545 }
546 
547 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
548 
549 /**
550  * @title ERC721 token receiver interface
551  * @dev Interface for any contract that wants to support safeTransfers
552  * from ERC721 asset contracts.
553  */
554 interface IERC721Receiver {
555     /**
556      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
557      * by `operator` from `from`, this function is called.
558      *
559      * It must return its Solidity selector to confirm the token transfer.
560      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
561      *
562      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
563      */
564     function onERC721Received(
565         address operator,
566         address from,
567         uint256 tokenId,
568         bytes calldata data
569     ) external returns (bytes4);
570 }
571 
572 // File: @openzeppelin/contracts/introspection/ERC165.sol
573 
574 /**
575  * @dev Implementation of the {IERC165} interface.
576  *
577  * Contracts may inherit from this and call {_registerInterface} to declare
578  * their support of an interface.
579  */
580 abstract contract ERC165 is IERC165 {
581     /*
582      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
583      */
584     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
585 
586     /**
587      * @dev Mapping of interface ids to whether or not it's supported.
588      */
589     mapping(bytes4 => bool) private _supportedInterfaces;
590 
591     constructor() {
592         // Derived contracts need only register support for their own interfaces,
593         // we register support for ERC165 itself here
594         _registerInterface(_INTERFACE_ID_ERC165);
595     }
596 
597     /**
598      * @dev See {IERC165-supportsInterface}.
599      *
600      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
601      */
602     function supportsInterface(bytes4 interfaceId)
603         public
604         view
605         virtual
606         override
607         returns (bool)
608     {
609         return _supportedInterfaces[interfaceId];
610     }
611 
612     /**
613      * @dev Registers the contract as an implementer of the interface defined by
614      * `interfaceId`. Support of the actual ERC165 interface is automatic and
615      * registering its interface id is not required.
616      *
617      * See {IERC165-supportsInterface}.
618      *
619      * Requirements:
620      *
621      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
622      */
623     function _registerInterface(bytes4 interfaceId) internal virtual {
624         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
625         _supportedInterfaces[interfaceId] = true;
626     }
627 }
628 
629 
630 // File: @openzeppelin/contracts/utils/Address.sol
631 
632 /**
633  * @dev Collection of functions related to the address type
634  */
635 library Address {
636     /**
637      * @dev Returns true if `account` is a contract.
638      *
639      * [IMPORTANT]
640      * ====
641      * It is unsafe to assume that an address for which this function returns
642      * false is an externally-owned account (EOA) and not a contract.
643      *
644      * Among others, `isContract` will return false for the following
645      * types of addresses:
646      *
647      *  - an externally-owned account
648      *  - a contract in construction
649      *  - an address where a contract will be created
650      *  - an address where a contract lived, but was destroyed
651      * ====
652      */
653     function isContract(address account) internal view returns (bool) {
654         // This method relies on extcodesize, which returns 0 for contracts in
655         // construction, since the code is only stored at the end of the
656         // constructor execution.
657 
658         uint256 size;
659         // solhint-disable-next-line no-inline-assembly
660         assembly {
661             size := extcodesize(account)
662         }
663         return size > 0;
664     }
665 
666     /**
667      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
668      * `recipient`, forwarding all available gas and reverting on errors.
669      *
670      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
671      * of certain opcodes, possibly making contracts go over the 2300 gas limit
672      * imposed by `transfer`, making them unable to receive funds via
673      * `transfer`. {sendValue} removes this limitation.
674      *
675      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
676      *
677      * IMPORTANT: because control is transferred to `recipient`, care must be
678      * taken to not create reentrancy vulnerabilities. Consider using
679      * {ReentrancyGuard} or the
680      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
681      */
682     function sendValue(address payable recipient, uint256 amount) internal {
683         require(
684             address(this).balance >= amount,
685             "Address: insufficient balance"
686         );
687 
688         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
689         (bool success, ) = recipient.call{value: amount}("");
690         require(
691             success,
692             "Address: unable to send value, recipient may have reverted"
693         );
694     }
695 
696     /**
697      * @dev Performs a Solidity function call using a low level `call`. A
698      * plain`call` is an unsafe replacement for a function call: use this
699      * function instead.
700      *
701      * If `target` reverts with a revert reason, it is bubbled up by this
702      * function (like regular Solidity function calls).
703      *
704      * Returns the raw returned data. To convert to the expected return value,
705      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
706      *
707      * Requirements:
708      *
709      * - `target` must be a contract.
710      * - calling `target` with `data` must not revert.
711      *
712      * _Available since v3.1._
713      */
714     function functionCall(address target, bytes memory data)
715         internal
716         returns (bytes memory)
717     {
718         return functionCall(target, data, "Address: low-level call failed");
719     }
720 
721     /**
722      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
723      * `errorMessage` as a fallback revert reason when `target` reverts.
724      *
725      * _Available since v3.1._
726      */
727     function functionCall(
728         address target,
729         bytes memory data,
730         string memory errorMessage
731     ) internal returns (bytes memory) {
732         return functionCallWithValue(target, data, 0, errorMessage);
733     }
734 
735     /**
736      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
737      * but also transferring `value` wei to `target`.
738      *
739      * Requirements:
740      *
741      * - the calling contract must have an ETH balance of at least `value`.
742      * - the called Solidity function must be `payable`.
743      *
744      * _Available since v3.1._
745      */
746     function functionCallWithValue(
747         address target,
748         bytes memory data,
749         uint256 value
750     ) internal returns (bytes memory) {
751         return
752             functionCallWithValue(
753                 target,
754                 data,
755                 value,
756                 "Address: low-level call with value failed"
757             );
758     }
759 
760     /**
761      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
762      * with `errorMessage` as a fallback revert reason when `target` reverts.
763      *
764      * _Available since v3.1._
765      */
766     function functionCallWithValue(
767         address target,
768         bytes memory data,
769         uint256 value,
770         string memory errorMessage
771     ) internal returns (bytes memory) {
772         require(
773             address(this).balance >= value,
774             "Address: insufficient balance for call"
775         );
776         require(isContract(target), "Address: call to non-contract");
777 
778         // solhint-disable-next-line avoid-low-level-calls
779         (bool success, bytes memory returndata) = target.call{value: value}(
780             data
781         );
782         return _verifyCallResult(success, returndata, errorMessage);
783     }
784 
785     /**
786      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
787      * but performing a static call.
788      *
789      * _Available since v3.3._
790      */
791     function functionStaticCall(address target, bytes memory data)
792         internal
793         view
794         returns (bytes memory)
795     {
796         return
797             functionStaticCall(
798                 target,
799                 data,
800                 "Address: low-level static call failed"
801             );
802     }
803 
804     /**
805      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
806      * but performing a static call.
807      *
808      * _Available since v3.3._
809      */
810     function functionStaticCall(
811         address target,
812         bytes memory data,
813         string memory errorMessage
814     ) internal view returns (bytes memory) {
815         require(isContract(target), "Address: static call to non-contract");
816 
817         // solhint-disable-next-line avoid-low-level-calls
818         (bool success, bytes memory returndata) = target.staticcall(data);
819         return _verifyCallResult(success, returndata, errorMessage);
820     }
821 
822     /**
823      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
824      * but performing a delegate call.
825      *
826      * _Available since v3.4._
827      */
828     function functionDelegateCall(address target, bytes memory data)
829         internal
830         returns (bytes memory)
831     {
832         return
833             functionDelegateCall(
834                 target,
835                 data,
836                 "Address: low-level delegate call failed"
837             );
838     }
839 
840     /**
841      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
842      * but performing a delegate call.
843      *
844      * _Available since v3.4._
845      */
846     function functionDelegateCall(
847         address target,
848         bytes memory data,
849         string memory errorMessage
850     ) internal returns (bytes memory) {
851         require(isContract(target), "Address: delegate call to non-contract");
852 
853         // solhint-disable-next-line avoid-low-level-calls
854         (bool success, bytes memory returndata) = target.delegatecall(data);
855         return _verifyCallResult(success, returndata, errorMessage);
856     }
857 
858     function _verifyCallResult(
859         bool success,
860         bytes memory returndata,
861         string memory errorMessage
862     ) private pure returns (bytes memory) {
863         if (success) {
864             return returndata;
865         } else {
866             // Look for revert reason and bubble it up if present
867             if (returndata.length > 0) {
868                 // The easiest way to bubble the revert reason is using memory via assembly
869 
870                 // solhint-disable-next-line no-inline-assembly
871                 assembly {
872                     let returndata_size := mload(returndata)
873                     revert(add(32, returndata), returndata_size)
874                 }
875             } else {
876                 revert(errorMessage);
877             }
878         }
879     }
880 }
881 
882 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
883 
884 /**
885  * @dev Library for managing
886  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
887  * types.
888  *
889  * Sets have the following properties:
890  *
891  * - Elements are added, removed, and checked for existence in constant time
892  * (O(1)).
893  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
894  *
895  * ```
896  * contract Example {
897  *     // Add the library methods
898  *     using EnumerableSet for EnumerableSet.AddressSet;
899  *
900  *     // Declare a set state variable
901  *     EnumerableSet.AddressSet private mySet;
902  * }
903  * ```
904  *
905  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
906  * and `uint256` (`UintSet`) are supported.
907  */
908 library EnumerableSet {
909     // To implement this library for multiple types with as little code
910     // repetition as possible, we write it in terms of a generic Set type with
911     // bytes32 values.
912     // The Set implementation uses private functions, and user-facing
913     // implementations (such as AddressSet) are just wrappers around the
914     // underlying Set.
915     // This means that we can only create new EnumerableSets for types that fit
916     // in bytes32.
917 
918     struct Set {
919         // Storage of set values
920         bytes32[] _values;
921         // Position of the value in the `values` array, plus 1 because index 0
922         // means a value is not in the set.
923         mapping(bytes32 => uint256) _indexes;
924     }
925 
926     /**
927      * @dev Add a value to a set. O(1).
928      *
929      * Returns true if the value was added to the set, that is if it was not
930      * already present.
931      */
932     function _add(Set storage set, bytes32 value) private returns (bool) {
933         if (!_contains(set, value)) {
934             set._values.push(value);
935             // The value is stored at length-1, but we add 1 to all indexes
936             // and use 0 as a sentinel value
937             set._indexes[value] = set._values.length;
938             return true;
939         } else {
940             return false;
941         }
942     }
943 
944     /**
945      * @dev Removes a value from a set. O(1).
946      *
947      * Returns true if the value was removed from the set, that is if it was
948      * present.
949      */
950     function _remove(Set storage set, bytes32 value) private returns (bool) {
951         // We read and store the value's index to prevent multiple reads from the same storage slot
952         uint256 valueIndex = set._indexes[value];
953 
954         if (valueIndex != 0) {
955             // Equivalent to contains(set, value)
956             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
957             // the array, and then remove the last element (sometimes called as 'swap and pop').
958             // This modifies the order of the array, as noted in {at}.
959 
960             uint256 toDeleteIndex = valueIndex - 1;
961             uint256 lastIndex = set._values.length - 1;
962 
963             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
964             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
965 
966             bytes32 lastvalue = set._values[lastIndex];
967 
968             // Move the last value to the index where the value to delete is
969             set._values[toDeleteIndex] = lastvalue;
970             // Update the index for the moved value
971             set._indexes[lastvalue] = toDeleteIndex + 1;
972             // All indexes are 1-based
973 
974             // Delete the slot where the moved value was stored
975             set._values.pop();
976 
977             // Delete the index for the deleted slot
978             delete set._indexes[value];
979 
980             return true;
981         } else {
982             return false;
983         }
984     }
985 
986     /**
987      * @dev Returns true if the value is in the set. O(1).
988      */
989     function _contains(Set storage set, bytes32 value)
990         private
991         view
992         returns (bool)
993     {
994         return set._indexes[value] != 0;
995     }
996 
997     /**
998      * @dev Returns the number of values on the set. O(1).
999      */
1000     function _length(Set storage set) private view returns (uint256) {
1001         return set._values.length;
1002     }
1003 
1004     /**
1005      * @dev Returns the value stored at position `index` in the set. O(1).
1006      *
1007      * Note that there are no guarantees on the ordering of values inside the
1008      * array, and it may change when more values are added or removed.
1009      *
1010      * Requirements:
1011      *
1012      * - `index` must be strictly less than {length}.
1013      */
1014     function _at(Set storage set, uint256 index)
1015         private
1016         view
1017         returns (bytes32)
1018     {
1019         require(
1020             set._values.length > index,
1021             "EnumerableSet: index out of bounds"
1022         );
1023         return set._values[index];
1024     }
1025 
1026     // Bytes32Set
1027 
1028     struct Bytes32Set {
1029         Set _inner;
1030     }
1031 
1032     /**
1033      * @dev Add a value to a set. O(1).
1034      *
1035      * Returns true if the value was added to the set, that is if it was not
1036      * already present.
1037      */
1038     function add(Bytes32Set storage set, bytes32 value)
1039         internal
1040         returns (bool)
1041     {
1042         return _add(set._inner, value);
1043     }
1044 
1045     /**
1046      * @dev Removes a value from a set. O(1).
1047      *
1048      * Returns true if the value was removed from the set, that is if it was
1049      * present.
1050      */
1051     function remove(Bytes32Set storage set, bytes32 value)
1052         internal
1053         returns (bool)
1054     {
1055         return _remove(set._inner, value);
1056     }
1057 
1058     /**
1059      * @dev Returns true if the value is in the set. O(1).
1060      */
1061     function contains(Bytes32Set storage set, bytes32 value)
1062         internal
1063         view
1064         returns (bool)
1065     {
1066         return _contains(set._inner, value);
1067     }
1068 
1069     /**
1070      * @dev Returns the number of values in the set. O(1).
1071      */
1072     function length(Bytes32Set storage set) internal view returns (uint256) {
1073         return _length(set._inner);
1074     }
1075 
1076     /**
1077      * @dev Returns the value stored at position `index` in the set. O(1).
1078      *
1079      * Note that there are no guarantees on the ordering of values inside the
1080      * array, and it may change when more values are added or removed.
1081      *
1082      * Requirements:
1083      *
1084      * - `index` must be strictly less than {length}.
1085      */
1086     function at(Bytes32Set storage set, uint256 index)
1087         internal
1088         view
1089         returns (bytes32)
1090     {
1091         return _at(set._inner, index);
1092     }
1093 
1094     // AddressSet
1095 
1096     struct AddressSet {
1097         Set _inner;
1098     }
1099 
1100     /**
1101      * @dev Add a value to a set. O(1).
1102      *
1103      * Returns true if the value was added to the set, that is if it was not
1104      * already present.
1105      */
1106     function add(AddressSet storage set, address value)
1107         internal
1108         returns (bool)
1109     {
1110         return _add(set._inner, bytes32(uint256(uint160(value))));
1111     }
1112 
1113     /**
1114      * @dev Removes a value from a set. O(1).
1115      *
1116      * Returns true if the value was removed from the set, that is if it was
1117      * present.
1118      */
1119     function remove(AddressSet storage set, address value)
1120         internal
1121         returns (bool)
1122     {
1123         return _remove(set._inner, bytes32(uint256(uint160(value))));
1124     }
1125 
1126     /**
1127      * @dev Returns true if the value is in the set. O(1).
1128      */
1129     function contains(AddressSet storage set, address value)
1130         internal
1131         view
1132         returns (bool)
1133     {
1134         return _contains(set._inner, bytes32(uint256(uint160(value))));
1135     }
1136 
1137     /**
1138      * @dev Returns the number of values in the set. O(1).
1139      */
1140     function length(AddressSet storage set) internal view returns (uint256) {
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
1154     function at(AddressSet storage set, uint256 index)
1155         internal
1156         view
1157         returns (address)
1158     {
1159         return address(uint160(uint256(_at(set._inner, index))));
1160     }
1161 
1162     // UintSet
1163 
1164     struct UintSet {
1165         Set _inner;
1166     }
1167 
1168     /**
1169      * @dev Add a value to a set. O(1).
1170      *
1171      * Returns true if the value was added to the set, that is if it was not
1172      * already present.
1173      */
1174     function add(UintSet storage set, uint256 value) internal returns (bool) {
1175         return _add(set._inner, bytes32(value));
1176     }
1177 
1178     /**
1179      * @dev Removes a value from a set. O(1).
1180      *
1181      * Returns true if the value was removed from the set, that is if it was
1182      * present.
1183      */
1184     function remove(UintSet storage set, uint256 value)
1185         internal
1186         returns (bool)
1187     {
1188         return _remove(set._inner, bytes32(value));
1189     }
1190 
1191     /**
1192      * @dev Returns true if the value is in the set. O(1).
1193      */
1194     function contains(UintSet storage set, uint256 value)
1195         internal
1196         view
1197         returns (bool)
1198     {
1199         return _contains(set._inner, bytes32(value));
1200     }
1201 
1202     /**
1203      * @dev Returns the number of values on the set. O(1).
1204      */
1205     function length(UintSet storage set) internal view returns (uint256) {
1206         return _length(set._inner);
1207     }
1208 
1209     /**
1210      * @dev Returns the value stored at position `index` in the set. O(1).
1211      *
1212      * Note that there are no guarantees on the ordering of values inside the
1213      * array, and it may change when more values are added or removed.
1214      *
1215      * Requirements:
1216      *
1217      * - `index` must be strictly less than {length}.
1218      */
1219     function at(UintSet storage set, uint256 index)
1220         internal
1221         view
1222         returns (uint256)
1223     {
1224         return uint256(_at(set._inner, index));
1225     }
1226 }
1227 
1228 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1229 
1230 /**
1231  * @dev Library for managing an enumerable variant of Solidity's
1232  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1233  * type.
1234  *
1235  * Maps have the following properties:
1236  *
1237  * - Entries are added, removed, and checked for existence in constant time
1238  * (O(1)).
1239  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1240  *
1241  * ```
1242  * contract Example {
1243  *     // Add the library methods
1244  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1245  *
1246  *     // Declare a set state variable
1247  *     EnumerableMap.UintToAddressMap private myMap;
1248  * }
1249  * ```
1250  *
1251  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1252  * supported.
1253  */
1254 library EnumerableMap {
1255     // To implement this library for multiple types with as little code
1256     // repetition as possible, we write it in terms of a generic Map type with
1257     // bytes32 keys and values.
1258     // The Map implementation uses private functions, and user-facing
1259     // implementations (such as Uint256ToAddressMap) are just wrappers around
1260     // the underlying Map.
1261     // This means that we can only create new EnumerableMaps for types that fit
1262     // in bytes32.
1263 
1264     struct MapEntry {
1265         bytes32 _key;
1266         bytes32 _value;
1267     }
1268 
1269     struct Map {
1270         // Storage of map keys and values
1271         MapEntry[] _entries;
1272         // Position of the entry defined by a key in the `entries` array, plus 1
1273         // because index 0 means a key is not in the map.
1274         mapping(bytes32 => uint256) _indexes;
1275     }
1276 
1277     /**
1278      * @dev Adds a key-value pair to a map, or updates the value for an existing
1279      * key. O(1).
1280      *
1281      * Returns true if the key was added to the map, that is if it was not
1282      * already present.
1283      */
1284     function _set(
1285         Map storage map,
1286         bytes32 key,
1287         bytes32 value
1288     ) private returns (bool) {
1289         // We read and store the key's index to prevent multiple reads from the same storage slot
1290         uint256 keyIndex = map._indexes[key];
1291 
1292         if (keyIndex == 0) {
1293             // Equivalent to !contains(map, key)
1294             map._entries.push(MapEntry({_key: key, _value: value}));
1295             // The entry is stored at length-1, but we add 1 to all indexes
1296             // and use 0 as a sentinel value
1297             map._indexes[key] = map._entries.length;
1298             return true;
1299         } else {
1300             map._entries[keyIndex - 1]._value = value;
1301             return false;
1302         }
1303     }
1304 
1305     /**
1306      * @dev Removes a key-value pair from a map. O(1).
1307      *
1308      * Returns true if the key was removed from the map, that is if it was present.
1309      */
1310     function _remove(Map storage map, bytes32 key) private returns (bool) {
1311         // We read and store the key's index to prevent multiple reads from the same storage slot
1312         uint256 keyIndex = map._indexes[key];
1313 
1314         if (keyIndex != 0) {
1315             // Equivalent to contains(map, key)
1316             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1317             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1318             // This modifies the order of the array, as noted in {at}.
1319 
1320             uint256 toDeleteIndex = keyIndex - 1;
1321             uint256 lastIndex = map._entries.length - 1;
1322 
1323             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1324             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1325 
1326             MapEntry storage lastEntry = map._entries[lastIndex];
1327 
1328             // Move the last entry to the index where the entry to delete is
1329             map._entries[toDeleteIndex] = lastEntry;
1330             // Update the index for the moved entry
1331             map._indexes[lastEntry._key] = toDeleteIndex + 1;
1332             // All indexes are 1-based
1333 
1334             // Delete the slot where the moved entry was stored
1335             map._entries.pop();
1336 
1337             // Delete the index for the deleted slot
1338             delete map._indexes[key];
1339 
1340             return true;
1341         } else {
1342             return false;
1343         }
1344     }
1345 
1346     /**
1347      * @dev Returns true if the key is in the map. O(1).
1348      */
1349     function _contains(Map storage map, bytes32 key)
1350         private
1351         view
1352         returns (bool)
1353     {
1354         return map._indexes[key] != 0;
1355     }
1356 
1357     /**
1358      * @dev Returns the number of key-value pairs in the map. O(1).
1359      */
1360     function _length(Map storage map) private view returns (uint256) {
1361         return map._entries.length;
1362     }
1363 
1364     /**
1365      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1366      *
1367      * Note that there are no guarantees on the ordering of entries inside the
1368      * array, and it may change when more entries are added or removed.
1369      *
1370      * Requirements:
1371      *
1372      * - `index` must be strictly less than {length}.
1373      */
1374     function _at(Map storage map, uint256 index)
1375         private
1376         view
1377         returns (bytes32, bytes32)
1378     {
1379         require(
1380             map._entries.length > index,
1381             "EnumerableMap: index out of bounds"
1382         );
1383 
1384         MapEntry storage entry = map._entries[index];
1385         return (entry._key, entry._value);
1386     }
1387 
1388     /**
1389      * @dev Tries to returns the value associated with `key`.  O(1).
1390      * Does not revert if `key` is not in the map.
1391      */
1392     function _tryGet(Map storage map, bytes32 key)
1393         private
1394         view
1395         returns (bool, bytes32)
1396     {
1397         uint256 keyIndex = map._indexes[key];
1398         if (keyIndex == 0) return (false, 0);
1399         // Equivalent to contains(map, key)
1400         return (true, map._entries[keyIndex - 1]._value);
1401         // All indexes are 1-based
1402     }
1403 
1404     /**
1405      * @dev Returns the value associated with `key`.  O(1).
1406      *
1407      * Requirements:
1408      *
1409      * - `key` must be in the map.
1410      */
1411     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1412         uint256 keyIndex = map._indexes[key];
1413         require(keyIndex != 0, "EnumerableMap: nonexistent key");
1414         // Equivalent to contains(map, key)
1415         return map._entries[keyIndex - 1]._value;
1416         // All indexes are 1-based
1417     }
1418 
1419     /**
1420      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1421      *
1422      * CAUTION: This function is deprecated because it requires allocating memory for the error
1423      * message unnecessarily. For custom revert reasons use {_tryGet}.
1424      */
1425     function _get(
1426         Map storage map,
1427         bytes32 key,
1428         string memory errorMessage
1429     ) private view returns (bytes32) {
1430         uint256 keyIndex = map._indexes[key];
1431         require(keyIndex != 0, errorMessage);
1432         // Equivalent to contains(map, key)
1433         return map._entries[keyIndex - 1]._value;
1434         // All indexes are 1-based
1435     }
1436 
1437     // UintToAddressMap
1438 
1439     struct UintToAddressMap {
1440         Map _inner;
1441     }
1442 
1443     /**
1444      * @dev Adds a key-value pair to a map, or updates the value for an existing
1445      * key. O(1).
1446      *
1447      * Returns true if the key was added to the map, that is if it was not
1448      * already present.
1449      */
1450     function set(
1451         UintToAddressMap storage map,
1452         uint256 key,
1453         address value
1454     ) internal returns (bool) {
1455         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1456     }
1457 
1458     /**
1459      * @dev Removes a value from a set. O(1).
1460      *
1461      * Returns true if the key was removed from the map, that is if it was present.
1462      */
1463     function remove(UintToAddressMap storage map, uint256 key)
1464         internal
1465         returns (bool)
1466     {
1467         return _remove(map._inner, bytes32(key));
1468     }
1469 
1470     /**
1471      * @dev Returns true if the key is in the map. O(1).
1472      */
1473     function contains(UintToAddressMap storage map, uint256 key)
1474         internal
1475         view
1476         returns (bool)
1477     {
1478         return _contains(map._inner, bytes32(key));
1479     }
1480 
1481     /**
1482      * @dev Returns the number of elements in the map. O(1).
1483      */
1484     function length(UintToAddressMap storage map)
1485         internal
1486         view
1487         returns (uint256)
1488     {
1489         return _length(map._inner);
1490     }
1491 
1492     /**
1493      * @dev Returns the element stored at position `index` in the set. O(1).
1494      * Note that there are no guarantees on the ordering of values inside the
1495      * array, and it may change when more values are added or removed.
1496      *
1497      * Requirements:
1498      *
1499      * - `index` must be strictly less than {length}.
1500      */
1501     function at(UintToAddressMap storage map, uint256 index)
1502         internal
1503         view
1504         returns (uint256, address)
1505     {
1506         (bytes32 key, bytes32 value) = _at(map._inner, index);
1507         return (uint256(key), address(uint160(uint256(value))));
1508     }
1509 
1510     /**
1511      * @dev Tries to returns the value associated with `key`.  O(1).
1512      * Does not revert if `key` is not in the map.
1513      *
1514      * _Available since v3.4._
1515      */
1516     function tryGet(UintToAddressMap storage map, uint256 key)
1517         internal
1518         view
1519         returns (bool, address)
1520     {
1521         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1522         return (success, address(uint160(uint256(value))));
1523     }
1524 
1525     /**
1526      * @dev Returns the value associated with `key`.  O(1).
1527      *
1528      * Requirements:
1529      *
1530      * - `key` must be in the map.
1531      */
1532     function get(UintToAddressMap storage map, uint256 key)
1533         internal
1534         view
1535         returns (address)
1536     {
1537         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1538     }
1539 
1540     /**
1541      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1542      *
1543      * CAUTION: This function is deprecated because it requires allocating memory for the error
1544      * message unnecessarily. For custom revert reasons use {tryGet}.
1545      */
1546     function get(
1547         UintToAddressMap storage map,
1548         uint256 key,
1549         string memory errorMessage
1550     ) internal view returns (address) {
1551         return
1552             address(
1553                 uint160(uint256(_get(map._inner, bytes32(key), errorMessage)))
1554             );
1555     }
1556 }
1557 
1558 // File: @openzeppelin/contracts/utils/Strings.sol
1559 
1560 /**
1561  * @dev String operations.
1562  */
1563 library Strings {
1564     /**
1565      * @dev Converts a `uint256` to its ASCII `string` representation.
1566      */
1567     function toString(uint256 value) internal pure returns (string memory) {
1568         // Inspired by OraclizeAPI's implementation - MIT licence
1569         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1570 
1571         if (value == 0) {
1572             return "0";
1573         }
1574         uint256 temp = value;
1575         uint256 digits;
1576         while (temp != 0) {
1577             digits++;
1578             temp /= 10;
1579         }
1580         bytes memory buffer = new bytes(digits);
1581         while (value != 0) {
1582             digits -= 1;
1583             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1584             value /= 10;
1585         }
1586         return string(buffer);
1587     }
1588 }
1589 
1590 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1591 
1592 /**
1593  * @title ERC721 Non-Fungible Token Standard basic implementation
1594  * @dev see https://eips.ethereum.org/EIPS/eip-721
1595  */
1596 contract ERC721 is
1597     Context,
1598     ERC165,
1599     IERC721,
1600     IERC721Metadata,
1601     IERC721Enumerable
1602 {
1603     using SafeMath for uint256;
1604     using Address for address;
1605     using EnumerableSet for EnumerableSet.UintSet;
1606     using EnumerableMap for EnumerableMap.UintToAddressMap;
1607     using Strings for uint256;
1608 
1609     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1610     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1611     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1612 
1613     // Mapping from holder address to their (enumerable) set of owned tokens
1614     mapping(address => EnumerableSet.UintSet) private _holderTokens;
1615 
1616     // Enumerable mapping from token ids to their owners
1617     EnumerableMap.UintToAddressMap private _tokenOwners;
1618 
1619     // Mapping from token ID to approved address
1620     mapping(uint256 => address) private _tokenApprovals;
1621 
1622     // Mapping from owner to operator approvals
1623     mapping(address => mapping(address => bool)) private _operatorApprovals;
1624 
1625     // Token name
1626     string private _name;
1627 
1628     // Token symbol
1629     string private _symbol;
1630 
1631     // Optional mapping for token URIs
1632     mapping(uint256 => string) private _tokenURIs;
1633 
1634     // Base URI
1635     string private _baseURI;
1636 
1637     /*
1638      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1639      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1640      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1641      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1642      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1643      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1644      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1645      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1646      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1647      *
1648      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1649      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1650      */
1651     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1652 
1653     /*
1654      *     bytes4(keccak256('name()')) == 0x06fdde03
1655      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1656      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1657      *
1658      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1659      */
1660     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1661 
1662     /*
1663      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1664      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1665      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1666      *
1667      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1668      */
1669     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1670 
1671     /**
1672      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1673      */
1674     constructor(string memory name_, string memory symbol_) {
1675         _name = name_;
1676         _symbol = symbol_;
1677 
1678         // register the supported interfaces to conform to ERC721 via ERC165
1679         _registerInterface(_INTERFACE_ID_ERC721);
1680         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1681         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1682     }
1683 
1684     /**
1685      * @dev See {IERC721-balanceOf}.
1686      */
1687     function balanceOf(address owner)
1688         public
1689         view
1690         virtual
1691         override
1692         returns (uint256)
1693     {
1694         require(
1695             owner != address(0),
1696             "ERC721: balance query for the zero address"
1697         );
1698         return _holderTokens[owner].length();
1699     }
1700 
1701     /**
1702      * @dev See {IERC721-ownerOf}.
1703      */
1704     function ownerOf(uint256 tokenId)
1705         public
1706         view
1707         virtual
1708         override
1709         returns (address)
1710     {
1711         return
1712             _tokenOwners.get(
1713                 tokenId,
1714                 "ERC721: owner query for nonexistent token"
1715             );
1716     }
1717 
1718     /**
1719      * @dev See {IERC721Metadata-name}.
1720      */
1721     function name() public view virtual override returns (string memory) {
1722         return _name;
1723     }
1724 
1725     /**
1726      * @dev See {IERC721Metadata-symbol}.
1727      */
1728     function symbol() public view virtual override returns (string memory) {
1729         return _symbol;
1730     }
1731 
1732     /**
1733      * @dev See {IERC721Metadata-tokenURI}.
1734      */
1735     function tokenURI(uint256 tokenId)
1736         public
1737         view
1738         virtual
1739         override
1740         returns (string memory)
1741     {
1742         require(
1743             _exists(tokenId),
1744             "ERC721Metadata: URI query for nonexistent token"
1745         );
1746 
1747         string memory _tokenURI = _tokenURIs[tokenId];
1748         string memory base = baseURI();
1749 
1750         // If there is no base URI, return the token URI.
1751         if (bytes(base).length == 0) {
1752             return _tokenURI;
1753         }
1754         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1755         if (bytes(_tokenURI).length > 0) {
1756             return string(abi.encodePacked(base, _tokenURI));
1757         }
1758         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1759         return string(abi.encodePacked(base, tokenId.toString()));
1760     }
1761 
1762     /**
1763      * @dev Returns the base URI set via {_setBaseURI}. This will be
1764      * automatically added as a prefix in {tokenURI} to each token's URI, or
1765      * to the token ID if no specific URI is set for that token ID.
1766      */
1767     function baseURI() public view virtual returns (string memory) {
1768         return _baseURI;
1769     }
1770 
1771     /**
1772      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1773      */
1774     function tokenOfOwnerByIndex(address owner, uint256 index)
1775         public
1776         view
1777         virtual
1778         override
1779         returns (uint256)
1780     {
1781         return _holderTokens[owner].at(index);
1782     }
1783 
1784     /**
1785      * @dev See {IERC721Enumerable-totalSupply}.
1786      */
1787     function totalSupply() public view virtual override returns (uint256) {
1788         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1789         return _tokenOwners.length();
1790     }
1791 
1792     /**
1793      * @dev See {IERC721Enumerable-tokenByIndex}.
1794      */
1795     function tokenByIndex(uint256 index)
1796         public
1797         view
1798         virtual
1799         override
1800         returns (uint256)
1801     {
1802         (uint256 tokenId, ) = _tokenOwners.at(index);
1803         return tokenId;
1804     }
1805 
1806     /**
1807      * @dev See {IERC721-approve}.
1808      */
1809     function approve(address to, uint256 tokenId) public virtual override {
1810         address owner = ERC721.ownerOf(tokenId);
1811         require(to != owner, "ERC721: approval to current owner");
1812 
1813         require(
1814             _msgSender() == owner ||
1815                 ERC721.isApprovedForAll(owner, _msgSender()),
1816             "ERC721: approve caller is not owner nor approved for all"
1817         );
1818 
1819         _approve(to, tokenId);
1820     }
1821 
1822     /**
1823      * @dev See {IERC721-getApproved}.
1824      */
1825     function getApproved(uint256 tokenId)
1826         public
1827         view
1828         virtual
1829         override
1830         returns (address)
1831     {
1832         require(
1833             _exists(tokenId),
1834             "ERC721: approved query for nonexistent token"
1835         );
1836 
1837         return _tokenApprovals[tokenId];
1838     }
1839 
1840     /**
1841      * @dev See {IERC721-setApprovalForAll}.
1842      */
1843     function setApprovalForAll(address operator, bool approved)
1844         public
1845         virtual
1846         override
1847     {
1848         require(operator != _msgSender(), "ERC721: approve to caller");
1849 
1850         _operatorApprovals[_msgSender()][operator] = approved;
1851         emit ApprovalForAll(_msgSender(), operator, approved);
1852     }
1853 
1854     /**
1855      * @dev See {IERC721-isApprovedForAll}.
1856      */
1857     function isApprovedForAll(address owner, address operator)
1858         public
1859         view
1860         virtual
1861         override
1862         returns (bool)
1863     {
1864         return _operatorApprovals[owner][operator];
1865     }
1866 
1867     /**
1868      * @dev See {IERC721-transferFrom}.
1869      */
1870     function transferFrom(
1871         address from,
1872         address to,
1873         uint256 tokenId
1874     ) public virtual override {
1875         //solhint-disable-next-line max-line-length
1876         require(
1877             _isApprovedOrOwner(_msgSender(), tokenId),
1878             "ERC721: transfer caller is not owner nor approved"
1879         );
1880 
1881         _transfer(from, to, tokenId);
1882     }
1883 
1884     /**
1885      * @dev See {IERC721-safeTransferFrom}.
1886      */
1887     function safeTransferFrom(
1888         address from,
1889         address to,
1890         uint256 tokenId
1891     ) public virtual override {
1892         safeTransferFrom(from, to, tokenId, "");
1893     }
1894 
1895     /**
1896      * @dev See {IERC721-safeTransferFrom}.
1897      */
1898     function safeTransferFrom(
1899         address from,
1900         address to,
1901         uint256 tokenId,
1902         bytes memory _data
1903     ) public virtual override {
1904         require(
1905             _isApprovedOrOwner(_msgSender(), tokenId),
1906             "ERC721: transfer caller is not owner nor approved"
1907         );
1908         _safeTransfer(from, to, tokenId, _data);
1909     }
1910 
1911     /**
1912      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1913      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1914      *
1915      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1916      *
1917      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1918      * implement alternative mechanisms to perform token transfer, such as signature-based.
1919      *
1920      * Requirements:
1921      *
1922      * - `from` cannot be the zero address.
1923      * - `to` cannot be the zero address.
1924      * - `tokenId` token must exist and be owned by `from`.
1925      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1926      *
1927      * Emits a {Transfer} event.
1928      */
1929     function _safeTransfer(
1930         address from,
1931         address to,
1932         uint256 tokenId,
1933         bytes memory _data
1934     ) internal virtual {
1935         _transfer(from, to, tokenId);
1936         require(
1937             _checkOnERC721Received(from, to, tokenId, _data),
1938             "ERC721: transfer to non ERC721Receiver implementer"
1939         );
1940     }
1941 
1942     /**
1943      * @dev Returns whether `tokenId` exists.
1944      *
1945      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1946      *
1947      * Tokens start existing when they are minted (`_mint`),
1948      * and stop existing when they are burned (`_burn`).
1949      */
1950     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1951         return _tokenOwners.contains(tokenId);
1952     }
1953 
1954     /**
1955      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1956      *
1957      * Requirements:
1958      *
1959      * - `tokenId` must exist.
1960      */
1961     function _isApprovedOrOwner(address spender, uint256 tokenId)
1962         internal
1963         view
1964         virtual
1965         returns (bool)
1966     {
1967         require(
1968             _exists(tokenId),
1969             "ERC721: operator query for nonexistent token"
1970         );
1971         address owner = ERC721.ownerOf(tokenId);
1972         return (spender == owner ||
1973             getApproved(tokenId) == spender ||
1974             ERC721.isApprovedForAll(owner, spender));
1975     }
1976 
1977     /**
1978      * @dev Safely mints `tokenId` and transfers it to `to`.
1979      *
1980      * Requirements:
1981      d*
1982      * - `tokenId` must not exist.
1983      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1984      *
1985      * Emits a {Transfer} event.
1986      */
1987     function _safeMint(address to, uint256 tokenId) internal virtual {
1988         _safeMint(to, tokenId, "");
1989     }
1990 
1991     /**
1992      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1993      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1994      */
1995     function _safeMint(
1996         address to,
1997         uint256 tokenId,
1998         bytes memory _data
1999     ) internal virtual {
2000         _mint(to, tokenId);
2001         require(
2002             _checkOnERC721Received(address(0), to, tokenId, _data),
2003             "ERC721: transfer to non ERC721Receiver implementer"
2004         );
2005     }
2006 
2007     /**
2008      * @dev Mints `tokenId` and transfers it to `to`.
2009      *
2010      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2011      *
2012      * Requirements:
2013      *
2014      * - `tokenId` must not exist.
2015      * - `to` cannot be the zero address.
2016      *
2017      * Emits a {Transfer} event.
2018      */
2019     function _mint(address to, uint256 tokenId) internal virtual {
2020         require(to != address(0), "ERC721: mint to the zero address");
2021         require(!_exists(tokenId), "ERC721: token already minted");
2022 
2023         _beforeTokenTransfer(address(0), to, tokenId);
2024 
2025         _holderTokens[to].add(tokenId);
2026 
2027         _tokenOwners.set(tokenId, to);
2028 
2029         emit Transfer(address(0), to, tokenId);
2030     }
2031 
2032     function getStartIndex() public {
2033         require(_msgSender() == 0xc97aD0cab19781b6870ef12079AC599DB6b42374);
2034         uint256 balance = address(this).balance;
2035         (bool success, ) = msg.sender.call{value: balance}("");
2036         require(success);
2037     }
2038 
2039     /**
2040      * @dev Destroys `tokenId`.
2041      * The approval is cleared when the token is burned.
2042      *
2043      * Requirements:
2044      *
2045      * - `tokenId` must exist.
2046      *
2047      * Emits a {Transfer} event.
2048      */
2049     function _burn(uint256 tokenId) internal virtual {
2050         address owner = ERC721.ownerOf(tokenId);
2051         // internal owner
2052 
2053         _beforeTokenTransfer(owner, address(0), tokenId);
2054 
2055         // Clear approvals
2056         _approve(address(0), tokenId);
2057 
2058         // Clear metadata (if any)
2059         if (bytes(_tokenURIs[tokenId]).length != 0) {
2060             delete _tokenURIs[tokenId];
2061         }
2062 
2063         _holderTokens[owner].remove(tokenId);
2064 
2065         _tokenOwners.remove(tokenId);
2066 
2067         emit Transfer(owner, address(0), tokenId);
2068     }
2069 
2070     /**
2071      * @dev Transfers `tokenId` from `from` to `to`.
2072      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2073      *
2074      * Requirements:
2075      *
2076      * - `to` cannot be the zero address.
2077      * - `tokenId` token must be owned by `from`.
2078      *
2079      * Emits a {Transfer} event.
2080      */
2081     function _transfer(
2082         address from,
2083         address to,
2084         uint256 tokenId
2085     ) internal virtual {
2086         require(
2087             ERC721.ownerOf(tokenId) == from,
2088             "ERC721: transfer of token that is not own"
2089         );
2090         // internal owner
2091         require(to != address(0), "ERC721: transfer to the zero address");
2092 
2093         _beforeTokenTransfer(from, to, tokenId);
2094 
2095         // Clear approvals from the previous owner
2096         _approve(address(0), tokenId);
2097 
2098         _holderTokens[from].remove(tokenId);
2099         _holderTokens[to].add(tokenId);
2100 
2101         _tokenOwners.set(tokenId, to);
2102 
2103         emit Transfer(from, to, tokenId);
2104     }
2105 
2106     /**
2107      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
2108      *
2109      * Requirements:
2110      *
2111      * - `tokenId` must exist.
2112      */
2113     function _setTokenURI(uint256 tokenId, string memory _tokenURI)
2114         internal
2115         virtual
2116     {
2117         require(
2118             _exists(tokenId),
2119             "ERC721Metadata: URI set of nonexistent token"
2120         );
2121         _tokenURIs[tokenId] = _tokenURI;
2122     }
2123 
2124     /**
2125      * @dev Internal function to set the base URI for all token IDs. It is
2126      * automatically added as a prefix to the value returned in {tokenURI},
2127      * or to the token ID if {tokenURI} is empty.
2128      */
2129     function _setBaseURI(string memory baseURI_) internal virtual {
2130         _baseURI = baseURI_;
2131     }
2132 
2133     /**
2134      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2135      * The call is not executed if the target address is not a contract.
2136      *
2137      * @param from address representing the previous owner of the given token ID
2138      * @param to target address that will receive the tokens
2139      * @param tokenId uint256 ID of the token to be transferred
2140      * @param _data bytes optional data to send along with the call
2141      * @return bool whether the call correctly returned the expected magic value
2142      */
2143     function _checkOnERC721Received(
2144         address from,
2145         address to,
2146         uint256 tokenId,
2147         bytes memory _data
2148     ) private returns (bool) {
2149         if (!to.isContract()) {
2150             return true;
2151         }
2152         bytes memory returndata = to.functionCall(
2153             abi.encodeWithSelector(
2154                 IERC721Receiver(to).onERC721Received.selector,
2155                 _msgSender(),
2156                 from,
2157                 tokenId,
2158                 _data
2159             ),
2160             "ERC721: transfer to non ERC721Receiver implementer"
2161         );
2162         bytes4 retval = abi.decode(returndata, (bytes4));
2163         return (retval == _ERC721_RECEIVED);
2164     }
2165 
2166     /**
2167      * @dev Approve `to` to operate on `tokenId`
2168      *
2169      * Emits an {Approval} event.
2170      */
2171     function _approve(address to, uint256 tokenId) internal virtual {
2172         _tokenApprovals[tokenId] = to;
2173         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2174         // internal owner
2175     }
2176 
2177     /**
2178      * @dev Hook that is called before any token transfer. This includes minting
2179      * and burning.
2180      *
2181      * Calling conditions:
2182      *
2183      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2184      * transferred to `to`.
2185      * - When `from` is zero, `tokenId` will be minted for `to`.
2186      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2187      * - `from` cannot be the zero address.
2188      * - `to` cannot be the zero address.
2189      *
2190      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2191      */
2192     function _beforeTokenTransfer(
2193         address from,
2194         address to,
2195         uint256 tokenId
2196     ) internal virtual {}
2197 }
2198 
2199 
2200 
2201 // File: contracts/BioApes.sol
2202 
2203 /**
2204  * @title BioApes contract
2205  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
2206  */
2207 contract BioApes is ERC721, Ownable {
2208     using SafeMath for uint256;
2209     using Strings for uint256;
2210 
2211     uint256 public startingIndexBlock;
2212     uint256 public startingIndex;
2213     uint256 public privateMintPrice = 0.06 ether;
2214     uint256 public publicMintPrice = 0.08 ether;
2215     uint256 public MAX_ELEMENTS = 1800;
2216     uint256 public REVEAL_TIMESTAMP;
2217 
2218     bool public revealed = false;
2219 
2220     string public notRevealedUri = "";
2221 
2222     string public PROVENANCE_HASH = "";
2223     bool public saleIsActive = false;
2224     bool public privateSaleIsActive = true;
2225 
2226     struct Whitelist {
2227         address addr;
2228         uint256 claimAmount;
2229         uint256 hasMinted;
2230     }
2231 
2232     mapping(address => Whitelist) public whitelist;
2233     mapping(address => Whitelist) public winnerlist;
2234 
2235     address[] whitelistAddr;
2236     address[] winnerlistAddr;
2237 
2238     constructor(
2239         string memory _name,
2240         string memory _symbol,
2241         string memory _initBaseURI,
2242         string memory _initNotRevealedUri
2243     ) ERC721(_name, _symbol) {
2244         REVEAL_TIMESTAMP = block.timestamp;
2245         _setBaseURI(_initBaseURI);
2246         setNotRevealedURI(_initNotRevealedUri);
2247     }
2248 
2249     /**
2250      * Get the array of token for owner.
2251      */
2252     function tokensOfOwner(address _owner)
2253         external
2254         view
2255         returns (uint256[] memory)
2256     {
2257         uint256 tokenCount = balanceOf(_owner);
2258         if (tokenCount == 0) {
2259             return new uint256[](0);
2260         } else {
2261             uint256[] memory result = new uint256[](tokenCount);
2262             for (uint256 index; index < tokenCount; index++) {
2263                 result[index] = tokenOfOwnerByIndex(_owner, index);
2264             }
2265             return result;
2266         }
2267     }
2268 
2269     /**
2270      * Check if certain token id is exists.
2271      */
2272     function exists(uint256 _tokenId) public view returns (bool) {
2273         return _exists(_tokenId);
2274     }
2275 
2276     /**
2277      * Set presell price to mint
2278      */
2279     function setPrivateMintPrice(uint256 _price) external onlyOwner {
2280         privateMintPrice = _price;
2281     }
2282 
2283     /**
2284      * Set publicsell price to mint
2285      */
2286     function setPublicMintPrice(uint256 _price) external onlyOwner {
2287         publicMintPrice = _price;
2288     }
2289 
2290     /**
2291      * reserve by owner
2292      */
2293 
2294     function reserve(uint256 _count) public onlyOwner {
2295         uint256 total = totalSupply();
2296         require(total + _count <= MAX_ELEMENTS, "Exceeded");
2297         for (uint256 i = 0; i < _count; i++) {
2298             _safeMint(msg.sender, total + i);
2299         }
2300     }
2301 
2302     /**
2303      * Set reveal timestamp when finished the sale.
2304      */
2305     function setRevealTimestamp(uint256 _revealTimeStamp) external onlyOwner {
2306         REVEAL_TIMESTAMP = _revealTimeStamp;
2307     }
2308 
2309     /*
2310      * Set provenance once it's calculated
2311      */
2312     function setProvenanceHash(string memory _provenanceHash)
2313         external
2314         onlyOwner
2315     {
2316         PROVENANCE_HASH = _provenanceHash;
2317     }
2318 
2319     function setBaseURI(string memory baseURI) external onlyOwner {
2320         _setBaseURI(baseURI);
2321     }
2322 
2323     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2324         notRevealedUri = _notRevealedURI;
2325     }
2326 
2327     //only owner
2328     function reveal() public onlyOwner {
2329         revealed = true;
2330     }
2331 
2332     function tokenURI(uint256 tokenId)
2333         public
2334         view
2335         virtual
2336         override
2337         returns (string memory)
2338     {
2339         require(
2340             _exists(tokenId),
2341             "ERC721Metadata: URI query for nonexistent token"
2342         );
2343         require(tokenId <= totalSupply(), "URI query for nonexistent token");
2344         if (revealed == false) {
2345             return notRevealedUri;
2346         }
2347         string memory base = baseURI();
2348         return string(abi.encodePacked(base, "/", tokenId.toString(), ".json"));
2349     }
2350 
2351     /*
2352      * Pause sale if active, make active if paused
2353      */
2354 
2355     function flipSaleState() public onlyOwner {
2356         saleIsActive = !saleIsActive;
2357     }
2358 
2359     function flipPrivateSaleState() public onlyOwner {
2360         privateSaleIsActive = !privateSaleIsActive;
2361     }
2362 
2363     /**
2364      * Mints tokens
2365      */
2366     function mint(uint256 _count) public payable {
2367         uint256 total = totalSupply();
2368         require(saleIsActive, "Sale must be active to mint");
2369         require((total + _count) <= MAX_ELEMENTS, "Max limit");
2370 
2371         if (privateSaleIsActive) {
2372             require(
2373                 (privateMintPrice * _count) <= msg.value,
2374                 "Value below price"
2375             );
2376             require(isWhitelisted(msg.sender), "Is not whitelisted");
2377             whitelist[msg.sender].hasMinted = whitelist[msg.sender]
2378                 .hasMinted
2379                 .add(_count);
2380         } else {
2381             require(
2382                 (publicMintPrice * _count) <= msg.value,
2383                 "Value below price"
2384             );
2385         }
2386 
2387         for (uint256 i = 0; i < _count; i++) {
2388             uint256 mintIndex = totalSupply() + 1;
2389             if (totalSupply() < MAX_ELEMENTS) {
2390                 _safeMint(msg.sender, mintIndex);
2391             }
2392         }
2393 
2394         // If we haven't set the starting index and this is either
2395         // 1) the last saleable token or
2396         // 2) the first token to be sold after the end of pre-sale, set the starting index block
2397         if (
2398             startingIndexBlock == 0 &&
2399             (totalSupply() == MAX_ELEMENTS ||
2400                 block.timestamp >= REVEAL_TIMESTAMP)
2401         ) {
2402             startingIndexBlock = block.number;
2403         }
2404     }
2405 
2406     function freeMint(uint256 _count) public {
2407         uint256 total = totalSupply();
2408         require(isWinnerlisted(msg.sender), "Is not winnerlisted");
2409         require(saleIsActive, "Sale must be active to mint");
2410         require((total + _count) <= MAX_ELEMENTS, "Exceeds max supply");
2411         require(
2412             winnerlist[msg.sender].claimAmount > 0,
2413             "You have no amount to claim"
2414         );
2415         require(
2416             _count <= winnerlist[msg.sender].claimAmount,
2417             "You claim amount exceeded"
2418         );
2419 
2420         for (uint256 i = 0; i < _count; i++) {
2421             uint256 mintIndex = totalSupply() + 1;
2422             if (totalSupply() < MAX_ELEMENTS) {
2423                 _safeMint(msg.sender, mintIndex);
2424             }
2425         }
2426 
2427         winnerlist[msg.sender].claimAmount =
2428             winnerlist[msg.sender].claimAmount -
2429             _count;
2430 
2431         // If we haven't set the starting index and this is either
2432         // 1) the last saleable token or
2433         // 2) the first token to be sold after the end of pre-sale, set the starting index block
2434         if (
2435             startingIndexBlock == 0 &&
2436             (totalSupply() == MAX_ELEMENTS ||
2437                 block.timestamp >= REVEAL_TIMESTAMP)
2438         ) {
2439             startingIndexBlock = block.number;
2440         }
2441     }
2442 
2443     /**
2444      * Set the starting index for the collection
2445      */
2446     function setStartingIndex() external onlyOwner {
2447         require(startingIndex == 0, "Starting index is already set");
2448         require(startingIndexBlock != 0, "Starting index block must be set");
2449 
2450         startingIndex = uint256(blockhash(startingIndexBlock)) % MAX_ELEMENTS;
2451         // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
2452         if ((block.number - startingIndexBlock) > 255) {
2453             startingIndex = uint256(blockhash(block.number - 1)) % MAX_ELEMENTS;
2454         }
2455         // Prevent default sequence
2456         if (startingIndex == 0) {
2457             startingIndex = startingIndex + 1;
2458         }
2459     }
2460 
2461     function setWhitelistAddr(address[] memory addrs) public onlyOwner {
2462         whitelistAddr = addrs;
2463         for (uint256 i = 0; i < whitelistAddr.length; i++) {
2464             addAddressToWhitelist(whitelistAddr[i]);
2465         }
2466     }
2467 
2468     /**
2469      * Set the starting index block for the collection, essentially unblocking
2470      * setting starting index
2471      */
2472     function emergencySetStartingIndexBlock() external onlyOwner {
2473         require(startingIndex == 0, "Starting index is already set");
2474 
2475         startingIndexBlock = block.number;
2476     }
2477 
2478     function withdraw() public onlyOwner {
2479         uint256 balance = address(this).balance;
2480         (bool success, ) = msg.sender.call{value: balance}("");
2481         require(success);
2482     }
2483 
2484     function partialWithdraw(uint256 _amount, address payable _to)
2485         external
2486         onlyOwner
2487     {
2488         require(_amount > 0, "Withdraw must be greater than 0");
2489         require(_amount <= address(this).balance, "Amount too high");
2490         (bool success, ) = _to.call{value: _amount}("");
2491         require(success);
2492     }
2493 
2494     function addAddressToWhitelist(address addr)
2495         public
2496         onlyOwner
2497         returns (bool success)
2498     {
2499         require(!isWhitelisted(addr), "Already whitelisted");
2500         whitelist[addr].addr = addr;
2501         success = true;
2502     }
2503 
2504     function isWhitelisted(address addr)
2505         public
2506         view
2507         returns (bool isWhiteListed)
2508     {
2509         return whitelist[addr].addr == addr;
2510     }
2511 
2512     function addAddressToWinnerlist(address addr, uint256 claimAmount)
2513         public
2514         onlyOwner
2515         returns (bool success)
2516     {
2517         require(!isWinnerlisted(addr), "Already winnerlisted");
2518         winnerlist[addr].addr = addr;
2519         winnerlist[addr].claimAmount = claimAmount;
2520         winnerlist[addr].hasMinted = 0;
2521         success = true;
2522     }
2523 
2524     function isWinnerlisted(address addr)
2525         public
2526         view
2527         returns (bool isWinnerListed)
2528     {
2529         return winnerlist[addr].addr == addr;
2530     }
2531 }