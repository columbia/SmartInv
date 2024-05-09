1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
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
30 pragma solidity >=0.6.0 <0.8.0;
31 
32 /**
33  * @dev Interface of the ERC165 standard, as defined in the
34  * https://eips.ethereum.org/EIPS/eip-165[EIP].
35  *
36  * Implementers can declare support of contract interfaces, which can then be
37  * queried by others ({ERC165Checker}).
38  *
39  * For an implementation, see {ERC165}.
40  */
41 interface IERC165 {
42     /**
43      * @dev Returns true if this contract implements the interface defined by
44      * `interfaceId`. See the corresponding
45      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
46      * to learn more about how these ids are created.
47      *
48      * This function call must use less than 30 000 gas.
49      */
50     function supportsInterface(bytes4 interfaceId) external view returns (bool);
51 }
52 
53 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
54 
55 pragma solidity >=0.6.2 <0.8.0;
56 
57 /**
58  * @dev Required interface of an ERC721 compliant contract.
59  */
60 interface IERC721 is IERC165 {
61     /**
62      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
63      */
64     event Transfer(
65         address indexed from,
66         address indexed to,
67         uint256 indexed tokenId
68     );
69 
70     /**
71      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
72      */
73     event Approval(
74         address indexed owner,
75         address indexed approved,
76         uint256 indexed tokenId
77     );
78 
79     /**
80      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
81      */
82     event ApprovalForAll(
83         address indexed owner,
84         address indexed operator,
85         bool approved
86     );
87 
88     /**
89      * @dev Returns the number of tokens in ``owner``'s account.
90      */
91     function balanceOf(address owner) external view returns (uint256 balance);
92 
93     /**
94      * @dev Returns the owner of the `tokenId` token.
95      *
96      * Requirements:
97      *
98      * - `tokenId` must exist.
99      */
100     function ownerOf(uint256 tokenId) external view returns (address owner);
101 
102     /**
103      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
104      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
105      *
106      * Requirements:
107      *
108      * - `from` cannot be the zero address.
109      * - `to` cannot be the zero address.
110      * - `tokenId` token must exist and be owned by `from`.
111      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
112      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
113      *
114      * Emits a {Transfer} event.
115      */
116     function safeTransferFrom(
117         address from,
118         address to,
119         uint256 tokenId
120     ) external;
121 
122     /**
123      * @dev Transfers `tokenId` token from `from` to `to`.
124      *
125      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
126      *
127      * Requirements:
128      *
129      * - `from` cannot be the zero address.
130      * - `to` cannot be the zero address.
131      * - `tokenId` token must be owned by `from`.
132      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
133      *
134      * Emits a {Transfer} event.
135      */
136     function transferFrom(
137         address from,
138         address to,
139         uint256 tokenId
140     ) external;
141 
142     /**
143      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
144      * The approval is cleared when the token is transferred.
145      *
146      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
147      *
148      * Requirements:
149      *
150      * - The caller must own the token or be an approved operator.
151      * - `tokenId` must exist.
152      *
153      * Emits an {Approval} event.
154      */
155     function approve(address to, uint256 tokenId) external;
156 
157     /**
158      * @dev Returns the account approved for `tokenId` token.
159      *
160      * Requirements:
161      *
162      * - `tokenId` must exist.
163      */
164     function getApproved(uint256 tokenId)
165         external
166         view
167         returns (address operator);
168 
169     /**
170      * @dev Approve or remove `operator` as an operator for the caller.
171      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
172      *
173      * Requirements:
174      *
175      * - The `operator` cannot be the caller.
176      *
177      * Emits an {ApprovalForAll} event.
178      */
179     function setApprovalForAll(address operator, bool _approved) external;
180 
181     /**
182      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
183      *
184      * See {setApprovalForAll}
185      */
186     function isApprovedForAll(address owner, address operator)
187         external
188         view
189         returns (bool);
190 
191     /**
192      * @dev Safely transfers `tokenId` token from `from` to `to`.
193      *
194      * Requirements:
195      *
196      * - `from` cannot be the zero address.
197      * - `to` cannot be the zero address.
198      * - `tokenId` token must exist and be owned by `from`.
199      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
200      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
201      *
202      * Emits a {Transfer} event.
203      */
204     function safeTransferFrom(
205         address from,
206         address to,
207         uint256 tokenId,
208         bytes calldata data
209     ) external;
210 }
211 
212 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
213 
214 pragma solidity >=0.6.2 <0.8.0;
215 
216 /**
217  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
218  * @dev See https://eips.ethereum.org/EIPS/eip-721
219  */
220 interface IERC721Metadata is IERC721 {
221     /**
222      * @dev Returns the token collection name.
223      */
224     function name() external view returns (string memory);
225 
226     /**
227      * @dev Returns the token collection symbol.
228      */
229     function symbol() external view returns (string memory);
230 
231     /**
232      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
233      */
234     function tokenURI(uint256 tokenId) external view returns (string memory);
235 }
236 
237 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
238 
239 pragma solidity >=0.6.2 <0.8.0;
240 
241 /**
242  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
243  * @dev See https://eips.ethereum.org/EIPS/eip-721
244  */
245 interface IERC721Enumerable is IERC721 {
246     /**
247      * @dev Returns the total amount of tokens stored by the contract.
248      */
249     function totalSupply() external view returns (uint256);
250 
251     /**
252      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
253      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
254      */
255     function tokenOfOwnerByIndex(address owner, uint256 index)
256         external
257         view
258         returns (uint256 tokenId);
259 
260     /**
261      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
262      * Use along with {totalSupply} to enumerate all tokens.
263      */
264     function tokenByIndex(uint256 index) external view returns (uint256);
265 }
266 
267 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
268 
269 pragma solidity >=0.6.0 <0.8.0;
270 
271 /**
272  * @title ERC721 token receiver interface
273  * @dev Interface for any contract that wants to support safeTransfers
274  * from ERC721 asset contracts.
275  */
276 interface IERC721Receiver {
277     /**
278      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
279      * by `operator` from `from`, this function is called.
280      *
281      * It must return its Solidity selector to confirm the token transfer.
282      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
283      *
284      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
285      */
286     function onERC721Received(
287         address operator,
288         address from,
289         uint256 tokenId,
290         bytes calldata data
291     ) external returns (bytes4);
292 }
293 
294 // File: @openzeppelin/contracts/introspection/ERC165.sol
295 
296 pragma solidity >=0.6.0 <0.8.0;
297 
298 /**
299  * @dev Implementation of the {IERC165} interface.
300  *
301  * Contracts may inherit from this and call {_registerInterface} to declare
302  * their support of an interface.
303  */
304 abstract contract ERC165 is IERC165 {
305     /*
306      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
307      */
308     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
309 
310     /**
311      * @dev Mapping of interface ids to whether or not it's supported.
312      */
313     mapping(bytes4 => bool) private _supportedInterfaces;
314 
315     constructor() internal {
316         // Derived contracts need only register support for their own interfaces,
317         // we register support for ERC165 itself here
318         _registerInterface(_INTERFACE_ID_ERC165);
319     }
320 
321     /**
322      * @dev See {IERC165-supportsInterface}.
323      *
324      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
325      */
326     function supportsInterface(bytes4 interfaceId)
327         public
328         view
329         virtual
330         override
331         returns (bool)
332     {
333         return _supportedInterfaces[interfaceId];
334     }
335 
336     /**
337      * @dev Registers the contract as an implementer of the interface defined by
338      * `interfaceId`. Support of the actual ERC165 interface is automatic and
339      * registering its interface id is not required.
340      *
341      * See {IERC165-supportsInterface}.
342      *
343      * Requirements:
344      *
345      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
346      */
347     function _registerInterface(bytes4 interfaceId) internal virtual {
348         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
349         _supportedInterfaces[interfaceId] = true;
350     }
351 }
352 
353 // File: @openzeppelin/contracts/math/SafeMath.sol
354 
355 pragma solidity >=0.6.0 <0.8.0;
356 
357 /**
358  * @dev Wrappers over Solidity's arithmetic operations with added overflow
359  * checks.
360  *
361  * Arithmetic operations in Solidity wrap on overflow. This can easily result
362  * in bugs, because programmers usually assume that an overflow raises an
363  * error, which is the standard behavior in high level programming languages.
364  * `SafeMath` restores this intuition by reverting the transaction when an
365  * operation overflows.
366  *
367  * Using this library instead of the unchecked operations eliminates an entire
368  * class of bugs, so it's recommended to use it always.
369  */
370 library SafeMath {
371     /**
372      * @dev Returns the addition of two unsigned integers, with an overflow flag.
373      *
374      * _Available since v3.4._
375      */
376     function tryAdd(uint256 a, uint256 b)
377         internal
378         pure
379         returns (bool, uint256)
380     {
381         uint256 c = a + b;
382         if (c < a) return (false, 0);
383         return (true, c);
384     }
385 
386     /**
387      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
388      *
389      * _Available since v3.4._
390      */
391     function trySub(uint256 a, uint256 b)
392         internal
393         pure
394         returns (bool, uint256)
395     {
396         if (b > a) return (false, 0);
397         return (true, a - b);
398     }
399 
400     /**
401      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
402      *
403      * _Available since v3.4._
404      */
405     function tryMul(uint256 a, uint256 b)
406         internal
407         pure
408         returns (bool, uint256)
409     {
410         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
411         // benefit is lost if 'b' is also tested.
412         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
413         if (a == 0) return (true, 0);
414         uint256 c = a * b;
415         if (c / a != b) return (false, 0);
416         return (true, c);
417     }
418 
419     /**
420      * @dev Returns the division of two unsigned integers, with a division by zero flag.
421      *
422      * _Available since v3.4._
423      */
424     function tryDiv(uint256 a, uint256 b)
425         internal
426         pure
427         returns (bool, uint256)
428     {
429         if (b == 0) return (false, 0);
430         return (true, a / b);
431     }
432 
433     /**
434      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
435      *
436      * _Available since v3.4._
437      */
438     function tryMod(uint256 a, uint256 b)
439         internal
440         pure
441         returns (bool, uint256)
442     {
443         if (b == 0) return (false, 0);
444         return (true, a % b);
445     }
446 
447     /**
448      * @dev Returns the addition of two unsigned integers, reverting on
449      * overflow.
450      *
451      * Counterpart to Solidity's `+` operator.
452      *
453      * Requirements:
454      *
455      * - Addition cannot overflow.
456      */
457     function add(uint256 a, uint256 b) internal pure returns (uint256) {
458         uint256 c = a + b;
459         require(c >= a, "SafeMath: addition overflow");
460         return c;
461     }
462 
463     /**
464      * @dev Returns the subtraction of two unsigned integers, reverting on
465      * overflow (when the result is negative).
466      *
467      * Counterpart to Solidity's `-` operator.
468      *
469      * Requirements:
470      *
471      * - Subtraction cannot overflow.
472      */
473     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
474         require(b <= a, "SafeMath: subtraction overflow");
475         return a - b;
476     }
477 
478     /**
479      * @dev Returns the multiplication of two unsigned integers, reverting on
480      * overflow.
481      *
482      * Counterpart to Solidity's `*` operator.
483      *
484      * Requirements:
485      *
486      * - Multiplication cannot overflow.
487      */
488     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
489         if (a == 0) return 0;
490         uint256 c = a * b;
491         require(c / a == b, "SafeMath: multiplication overflow");
492         return c;
493     }
494 
495     /**
496      * @dev Returns the integer division of two unsigned integers, reverting on
497      * division by zero. The result is rounded towards zero.
498      *
499      * Counterpart to Solidity's `/` operator. Note: this function uses a
500      * `revert` opcode (which leaves remaining gas untouched) while Solidity
501      * uses an invalid opcode to revert (consuming all remaining gas).
502      *
503      * Requirements:
504      *
505      * - The divisor cannot be zero.
506      */
507     function div(uint256 a, uint256 b) internal pure returns (uint256) {
508         require(b > 0, "SafeMath: division by zero");
509         return a / b;
510     }
511 
512     /**
513      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
514      * reverting when dividing by zero.
515      *
516      * Counterpart to Solidity's `%` operator. This function uses a `revert`
517      * opcode (which leaves remaining gas untouched) while Solidity uses an
518      * invalid opcode to revert (consuming all remaining gas).
519      *
520      * Requirements:
521      *
522      * - The divisor cannot be zero.
523      */
524     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
525         require(b > 0, "SafeMath: modulo by zero");
526         return a % b;
527     }
528 
529     /**
530      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
531      * overflow (when the result is negative).
532      *
533      * CAUTION: This function is deprecated because it requires allocating memory for the error
534      * message unnecessarily. For custom revert reasons use {trySub}.
535      *
536      * Counterpart to Solidity's `-` operator.
537      *
538      * Requirements:
539      *
540      * - Subtraction cannot overflow.
541      */
542     function sub(
543         uint256 a,
544         uint256 b,
545         string memory errorMessage
546     ) internal pure returns (uint256) {
547         require(b <= a, errorMessage);
548         return a - b;
549     }
550 
551     /**
552      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
553      * division by zero. The result is rounded towards zero.
554      *
555      * CAUTION: This function is deprecated because it requires allocating memory for the error
556      * message unnecessarily. For custom revert reasons use {tryDiv}.
557      *
558      * Counterpart to Solidity's `/` operator. Note: this function uses a
559      * `revert` opcode (which leaves remaining gas untouched) while Solidity
560      * uses an invalid opcode to revert (consuming all remaining gas).
561      *
562      * Requirements:
563      *
564      * - The divisor cannot be zero.
565      */
566     function div(
567         uint256 a,
568         uint256 b,
569         string memory errorMessage
570     ) internal pure returns (uint256) {
571         require(b > 0, errorMessage);
572         return a / b;
573     }
574 
575     /**
576      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
577      * reverting with custom message when dividing by zero.
578      *
579      * CAUTION: This function is deprecated because it requires allocating memory for the error
580      * message unnecessarily. For custom revert reasons use {tryMod}.
581      *
582      * Counterpart to Solidity's `%` operator. This function uses a `revert`
583      * opcode (which leaves remaining gas untouched) while Solidity uses an
584      * invalid opcode to revert (consuming all remaining gas).
585      *
586      * Requirements:
587      *
588      * - The divisor cannot be zero.
589      */
590     function mod(
591         uint256 a,
592         uint256 b,
593         string memory errorMessage
594     ) internal pure returns (uint256) {
595         require(b > 0, errorMessage);
596         return a % b;
597     }
598 }
599 
600 // File: @openzeppelin/contracts/utils/Address.sol
601 
602 pragma solidity >=0.6.2 <0.8.0;
603 
604 /**
605  * @dev Collection of functions related to the address type
606  */
607 library Address {
608     /**
609      * @dev Returns true if `account` is a contract.
610      *
611      * [IMPORTANT]
612      * ====
613      * It is unsafe to assume that an address for which this function returns
614      * false is an externally-owned account (EOA) and not a contract.
615      *
616      * Among others, `isContract` will return false for the following
617      * types of addresses:
618      *
619      *  - an externally-owned account
620      *  - a contract in construction
621      *  - an address where a contract will be created
622      *  - an address where a contract lived, but was destroyed
623      * ====
624      */
625     function isContract(address account) internal view returns (bool) {
626         // This method relies on extcodesize, which returns 0 for contracts in
627         // construction, since the code is only stored at the end of the
628         // constructor execution.
629 
630         uint256 size;
631         // solhint-disable-next-line no-inline-assembly
632         assembly {
633             size := extcodesize(account)
634         }
635         return size > 0;
636     }
637 
638     /**
639      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
640      * `recipient`, forwarding all available gas and reverting on errors.
641      *
642      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
643      * of certain opcodes, possibly making contracts go over the 2300 gas limit
644      * imposed by `transfer`, making them unable to receive funds via
645      * `transfer`. {sendValue} removes this limitation.
646      *
647      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
648      *
649      * IMPORTANT: because control is transferred to `recipient`, care must be
650      * taken to not create reentrancy vulnerabilities. Consider using
651      * {ReentrancyGuard} or the
652      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
653      */
654     function sendValue(address payable recipient, uint256 amount) internal {
655         require(
656             address(this).balance >= amount,
657             "Address: insufficient balance"
658         );
659 
660         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
661         (bool success, ) = recipient.call{value: amount}("");
662         require(
663             success,
664             "Address: unable to send value, recipient may have reverted"
665         );
666     }
667 
668     /**
669      * @dev Performs a Solidity function call using a low level `call`. A
670      * plain`call` is an unsafe replacement for a function call: use this
671      * function instead.
672      *
673      * If `target` reverts with a revert reason, it is bubbled up by this
674      * function (like regular Solidity function calls).
675      *
676      * Returns the raw returned data. To convert to the expected return value,
677      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
678      *
679      * Requirements:
680      *
681      * - `target` must be a contract.
682      * - calling `target` with `data` must not revert.
683      *
684      * _Available since v3.1._
685      */
686     function functionCall(address target, bytes memory data)
687         internal
688         returns (bytes memory)
689     {
690         return functionCall(target, data, "Address: low-level call failed");
691     }
692 
693     /**
694      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
695      * `errorMessage` as a fallback revert reason when `target` reverts.
696      *
697      * _Available since v3.1._
698      */
699     function functionCall(
700         address target,
701         bytes memory data,
702         string memory errorMessage
703     ) internal returns (bytes memory) {
704         return functionCallWithValue(target, data, 0, errorMessage);
705     }
706 
707     /**
708      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
709      * but also transferring `value` wei to `target`.
710      *
711      * Requirements:
712      *
713      * - the calling contract must have an ETH balance of at least `value`.
714      * - the called Solidity function must be `payable`.
715      *
716      * _Available since v3.1._
717      */
718     function functionCallWithValue(
719         address target,
720         bytes memory data,
721         uint256 value
722     ) internal returns (bytes memory) {
723         return
724             functionCallWithValue(
725                 target,
726                 data,
727                 value,
728                 "Address: low-level call with value failed"
729             );
730     }
731 
732     /**
733      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
734      * with `errorMessage` as a fallback revert reason when `target` reverts.
735      *
736      * _Available since v3.1._
737      */
738     function functionCallWithValue(
739         address target,
740         bytes memory data,
741         uint256 value,
742         string memory errorMessage
743     ) internal returns (bytes memory) {
744         require(
745             address(this).balance >= value,
746             "Address: insufficient balance for call"
747         );
748         require(isContract(target), "Address: call to non-contract");
749 
750         // solhint-disable-next-line avoid-low-level-calls
751         (bool success, bytes memory returndata) = target.call{value: value}(
752             data
753         );
754         return _verifyCallResult(success, returndata, errorMessage);
755     }
756 
757     /**
758      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
759      * but performing a static call.
760      *
761      * _Available since v3.3._
762      */
763     function functionStaticCall(address target, bytes memory data)
764         internal
765         view
766         returns (bytes memory)
767     {
768         return
769             functionStaticCall(
770                 target,
771                 data,
772                 "Address: low-level static call failed"
773             );
774     }
775 
776     /**
777      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
778      * but performing a static call.
779      *
780      * _Available since v3.3._
781      */
782     function functionStaticCall(
783         address target,
784         bytes memory data,
785         string memory errorMessage
786     ) internal view returns (bytes memory) {
787         require(isContract(target), "Address: static call to non-contract");
788 
789         // solhint-disable-next-line avoid-low-level-calls
790         (bool success, bytes memory returndata) = target.staticcall(data);
791         return _verifyCallResult(success, returndata, errorMessage);
792     }
793 
794     /**
795      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
796      * but performing a delegate call.
797      *
798      * _Available since v3.4._
799      */
800     function functionDelegateCall(address target, bytes memory data)
801         internal
802         returns (bytes memory)
803     {
804         return
805             functionDelegateCall(
806                 target,
807                 data,
808                 "Address: low-level delegate call failed"
809             );
810     }
811 
812     /**
813      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
814      * but performing a delegate call.
815      *
816      * _Available since v3.4._
817      */
818     function functionDelegateCall(
819         address target,
820         bytes memory data,
821         string memory errorMessage
822     ) internal returns (bytes memory) {
823         require(isContract(target), "Address: delegate call to non-contract");
824 
825         // solhint-disable-next-line avoid-low-level-calls
826         (bool success, bytes memory returndata) = target.delegatecall(data);
827         return _verifyCallResult(success, returndata, errorMessage);
828     }
829 
830     function _verifyCallResult(
831         bool success,
832         bytes memory returndata,
833         string memory errorMessage
834     ) private pure returns (bytes memory) {
835         if (success) {
836             return returndata;
837         } else {
838             // Look for revert reason and bubble it up if present
839             if (returndata.length > 0) {
840                 // The easiest way to bubble the revert reason is using memory via assembly
841 
842                 // solhint-disable-next-line no-inline-assembly
843                 assembly {
844                     let returndata_size := mload(returndata)
845                     revert(add(32, returndata), returndata_size)
846                 }
847             } else {
848                 revert(errorMessage);
849             }
850         }
851     }
852 }
853 
854 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
855 
856 pragma solidity >=0.6.0 <0.8.0;
857 
858 /**
859  * @dev Library for managing
860  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
861  * types.
862  *
863  * Sets have the following properties:
864  *
865  * - Elements are added, removed, and checked for existence in constant time
866  * (O(1)).
867  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
868  *
869  * ```
870  * contract Example {
871  *     // Add the library methods
872  *     using EnumerableSet for EnumerableSet.AddressSet;
873  *
874  *     // Declare a set state variable
875  *     EnumerableSet.AddressSet private mySet;
876  * }
877  * ```
878  *
879  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
880  * and `uint256` (`UintSet`) are supported.
881  */
882 library EnumerableSet {
883     // To implement this library for multiple types with as little code
884     // repetition as possible, we write it in terms of a generic Set type with
885     // bytes32 values.
886     // The Set implementation uses private functions, and user-facing
887     // implementations (such as AddressSet) are just wrappers around the
888     // underlying Set.
889     // This means that we can only create new EnumerableSets for types that fit
890     // in bytes32.
891 
892     struct Set {
893         // Storage of set values
894         bytes32[] _values;
895         // Position of the value in the `values` array, plus 1 because index 0
896         // means a value is not in the set.
897         mapping(bytes32 => uint256) _indexes;
898     }
899 
900     /**
901      * @dev Add a value to a set. O(1).
902      *
903      * Returns true if the value was added to the set, that is if it was not
904      * already present.
905      */
906     function _add(Set storage set, bytes32 value) private returns (bool) {
907         if (!_contains(set, value)) {
908             set._values.push(value);
909             // The value is stored at length-1, but we add 1 to all indexes
910             // and use 0 as a sentinel value
911             set._indexes[value] = set._values.length;
912             return true;
913         } else {
914             return false;
915         }
916     }
917 
918     /**
919      * @dev Removes a value from a set. O(1).
920      *
921      * Returns true if the value was removed from the set, that is if it was
922      * present.
923      */
924     function _remove(Set storage set, bytes32 value) private returns (bool) {
925         // We read and store the value's index to prevent multiple reads from the same storage slot
926         uint256 valueIndex = set._indexes[value];
927 
928         if (valueIndex != 0) {
929             // Equivalent to contains(set, value)
930             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
931             // the array, and then remove the last element (sometimes called as 'swap and pop').
932             // This modifies the order of the array, as noted in {at}.
933 
934             uint256 toDeleteIndex = valueIndex - 1;
935             uint256 lastIndex = set._values.length - 1;
936 
937             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
938             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
939 
940             bytes32 lastvalue = set._values[lastIndex];
941 
942             // Move the last value to the index where the value to delete is
943             set._values[toDeleteIndex] = lastvalue;
944             // Update the index for the moved value
945             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
946 
947             // Delete the slot where the moved value was stored
948             set._values.pop();
949 
950             // Delete the index for the deleted slot
951             delete set._indexes[value];
952 
953             return true;
954         } else {
955             return false;
956         }
957     }
958 
959     /**
960      * @dev Returns true if the value is in the set. O(1).
961      */
962     function _contains(Set storage set, bytes32 value)
963         private
964         view
965         returns (bool)
966     {
967         return set._indexes[value] != 0;
968     }
969 
970     /**
971      * @dev Returns the number of values on the set. O(1).
972      */
973     function _length(Set storage set) private view returns (uint256) {
974         return set._values.length;
975     }
976 
977     /**
978      * @dev Returns the value stored at position `index` in the set. O(1).
979      *
980      * Note that there are no guarantees on the ordering of values inside the
981      * array, and it may change when more values are added or removed.
982      *
983      * Requirements:
984      *
985      * - `index` must be strictly less than {length}.
986      */
987     function _at(Set storage set, uint256 index)
988         private
989         view
990         returns (bytes32)
991     {
992         require(
993             set._values.length > index,
994             "EnumerableSet: index out of bounds"
995         );
996         return set._values[index];
997     }
998 
999     // Bytes32Set
1000 
1001     struct Bytes32Set {
1002         Set _inner;
1003     }
1004 
1005     /**
1006      * @dev Add a value to a set. O(1).
1007      *
1008      * Returns true if the value was added to the set, that is if it was not
1009      * already present.
1010      */
1011     function add(Bytes32Set storage set, bytes32 value)
1012         internal
1013         returns (bool)
1014     {
1015         return _add(set._inner, value);
1016     }
1017 
1018     /**
1019      * @dev Removes a value from a set. O(1).
1020      *
1021      * Returns true if the value was removed from the set, that is if it was
1022      * present.
1023      */
1024     function remove(Bytes32Set storage set, bytes32 value)
1025         internal
1026         returns (bool)
1027     {
1028         return _remove(set._inner, value);
1029     }
1030 
1031     /**
1032      * @dev Returns true if the value is in the set. O(1).
1033      */
1034     function contains(Bytes32Set storage set, bytes32 value)
1035         internal
1036         view
1037         returns (bool)
1038     {
1039         return _contains(set._inner, value);
1040     }
1041 
1042     /**
1043      * @dev Returns the number of values in the set. O(1).
1044      */
1045     function length(Bytes32Set storage set) internal view returns (uint256) {
1046         return _length(set._inner);
1047     }
1048 
1049     /**
1050      * @dev Returns the value stored at position `index` in the set. O(1).
1051      *
1052      * Note that there are no guarantees on the ordering of values inside the
1053      * array, and it may change when more values are added or removed.
1054      *
1055      * Requirements:
1056      *
1057      * - `index` must be strictly less than {length}.
1058      */
1059     function at(Bytes32Set storage set, uint256 index)
1060         internal
1061         view
1062         returns (bytes32)
1063     {
1064         return _at(set._inner, index);
1065     }
1066 
1067     // AddressSet
1068 
1069     struct AddressSet {
1070         Set _inner;
1071     }
1072 
1073     /**
1074      * @dev Add a value to a set. O(1).
1075      *
1076      * Returns true if the value was added to the set, that is if it was not
1077      * already present.
1078      */
1079     function add(AddressSet storage set, address value)
1080         internal
1081         returns (bool)
1082     {
1083         return _add(set._inner, bytes32(uint256(uint160(value))));
1084     }
1085 
1086     /**
1087      * @dev Removes a value from a set. O(1).
1088      *
1089      * Returns true if the value was removed from the set, that is if it was
1090      * present.
1091      */
1092     function remove(AddressSet storage set, address value)
1093         internal
1094         returns (bool)
1095     {
1096         return _remove(set._inner, bytes32(uint256(uint160(value))));
1097     }
1098 
1099     /**
1100      * @dev Returns true if the value is in the set. O(1).
1101      */
1102     function contains(AddressSet storage set, address value)
1103         internal
1104         view
1105         returns (bool)
1106     {
1107         return _contains(set._inner, bytes32(uint256(uint160(value))));
1108     }
1109 
1110     /**
1111      * @dev Returns the number of values in the set. O(1).
1112      */
1113     function length(AddressSet storage set) internal view returns (uint256) {
1114         return _length(set._inner);
1115     }
1116 
1117     /**
1118      * @dev Returns the value stored at position `index` in the set. O(1).
1119      *
1120      * Note that there are no guarantees on the ordering of values inside the
1121      * array, and it may change when more values are added or removed.
1122      *
1123      * Requirements:
1124      *
1125      * - `index` must be strictly less than {length}.
1126      */
1127     function at(AddressSet storage set, uint256 index)
1128         internal
1129         view
1130         returns (address)
1131     {
1132         return address(uint160(uint256(_at(set._inner, index))));
1133     }
1134 
1135     // UintSet
1136 
1137     struct UintSet {
1138         Set _inner;
1139     }
1140 
1141     /**
1142      * @dev Add a value to a set. O(1).
1143      *
1144      * Returns true if the value was added to the set, that is if it was not
1145      * already present.
1146      */
1147     function add(UintSet storage set, uint256 value) internal returns (bool) {
1148         return _add(set._inner, bytes32(value));
1149     }
1150 
1151     /**
1152      * @dev Removes a value from a set. O(1).
1153      *
1154      * Returns true if the value was removed from the set, that is if it was
1155      * present.
1156      */
1157     function remove(UintSet storage set, uint256 value)
1158         internal
1159         returns (bool)
1160     {
1161         return _remove(set._inner, bytes32(value));
1162     }
1163 
1164     /**
1165      * @dev Returns true if the value is in the set. O(1).
1166      */
1167     function contains(UintSet storage set, uint256 value)
1168         internal
1169         view
1170         returns (bool)
1171     {
1172         return _contains(set._inner, bytes32(value));
1173     }
1174 
1175     /**
1176      * @dev Returns the number of values on the set. O(1).
1177      */
1178     function length(UintSet storage set) internal view returns (uint256) {
1179         return _length(set._inner);
1180     }
1181 
1182     /**
1183      * @dev Returns the value stored at position `index` in the set. O(1).
1184      *
1185      * Note that there are no guarantees on the ordering of values inside the
1186      * array, and it may change when more values are added or removed.
1187      *
1188      * Requirements:
1189      *
1190      * - `index` must be strictly less than {length}.
1191      */
1192     function at(UintSet storage set, uint256 index)
1193         internal
1194         view
1195         returns (uint256)
1196     {
1197         return uint256(_at(set._inner, index));
1198     }
1199 }
1200 
1201 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1202 
1203 pragma solidity >=0.6.0 <0.8.0;
1204 
1205 /**
1206  * @dev Library for managing an enumerable variant of Solidity's
1207  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1208  * type.
1209  *
1210  * Maps have the following properties:
1211  *
1212  * - Entries are added, removed, and checked for existence in constant time
1213  * (O(1)).
1214  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1215  *
1216  * ```
1217  * contract Example {
1218  *     // Add the library methods
1219  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1220  *
1221  *     // Declare a set state variable
1222  *     EnumerableMap.UintToAddressMap private myMap;
1223  * }
1224  * ```
1225  *
1226  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1227  * supported.
1228  */
1229 library EnumerableMap {
1230     // To implement this library for multiple types with as little code
1231     // repetition as possible, we write it in terms of a generic Map type with
1232     // bytes32 keys and values.
1233     // The Map implementation uses private functions, and user-facing
1234     // implementations (such as Uint256ToAddressMap) are just wrappers around
1235     // the underlying Map.
1236     // This means that we can only create new EnumerableMaps for types that fit
1237     // in bytes32.
1238 
1239     struct MapEntry {
1240         bytes32 _key;
1241         bytes32 _value;
1242     }
1243 
1244     struct Map {
1245         // Storage of map keys and values
1246         MapEntry[] _entries;
1247         // Position of the entry defined by a key in the `entries` array, plus 1
1248         // because index 0 means a key is not in the map.
1249         mapping(bytes32 => uint256) _indexes;
1250     }
1251 
1252     /**
1253      * @dev Adds a key-value pair to a map, or updates the value for an existing
1254      * key. O(1).
1255      *
1256      * Returns true if the key was added to the map, that is if it was not
1257      * already present.
1258      */
1259     function _set(
1260         Map storage map,
1261         bytes32 key,
1262         bytes32 value
1263     ) private returns (bool) {
1264         // We read and store the key's index to prevent multiple reads from the same storage slot
1265         uint256 keyIndex = map._indexes[key];
1266 
1267         if (keyIndex == 0) {
1268             // Equivalent to !contains(map, key)
1269             map._entries.push(MapEntry({_key: key, _value: value}));
1270             // The entry is stored at length-1, but we add 1 to all indexes
1271             // and use 0 as a sentinel value
1272             map._indexes[key] = map._entries.length;
1273             return true;
1274         } else {
1275             map._entries[keyIndex - 1]._value = value;
1276             return false;
1277         }
1278     }
1279 
1280     /**
1281      * @dev Removes a key-value pair from a map. O(1).
1282      *
1283      * Returns true if the key was removed from the map, that is if it was present.
1284      */
1285     function _remove(Map storage map, bytes32 key) private returns (bool) {
1286         // We read and store the key's index to prevent multiple reads from the same storage slot
1287         uint256 keyIndex = map._indexes[key];
1288 
1289         if (keyIndex != 0) {
1290             // Equivalent to contains(map, key)
1291             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1292             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1293             // This modifies the order of the array, as noted in {at}.
1294 
1295             uint256 toDeleteIndex = keyIndex - 1;
1296             uint256 lastIndex = map._entries.length - 1;
1297 
1298             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1299             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1300 
1301             MapEntry storage lastEntry = map._entries[lastIndex];
1302 
1303             // Move the last entry to the index where the entry to delete is
1304             map._entries[toDeleteIndex] = lastEntry;
1305             // Update the index for the moved entry
1306             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1307 
1308             // Delete the slot where the moved entry was stored
1309             map._entries.pop();
1310 
1311             // Delete the index for the deleted slot
1312             delete map._indexes[key];
1313 
1314             return true;
1315         } else {
1316             return false;
1317         }
1318     }
1319 
1320     /**
1321      * @dev Returns true if the key is in the map. O(1).
1322      */
1323     function _contains(Map storage map, bytes32 key)
1324         private
1325         view
1326         returns (bool)
1327     {
1328         return map._indexes[key] != 0;
1329     }
1330 
1331     /**
1332      * @dev Returns the number of key-value pairs in the map. O(1).
1333      */
1334     function _length(Map storage map) private view returns (uint256) {
1335         return map._entries.length;
1336     }
1337 
1338     /**
1339      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1340      *
1341      * Note that there are no guarantees on the ordering of entries inside the
1342      * array, and it may change when more entries are added or removed.
1343      *
1344      * Requirements:
1345      *
1346      * - `index` must be strictly less than {length}.
1347      */
1348     function _at(Map storage map, uint256 index)
1349         private
1350         view
1351         returns (bytes32, bytes32)
1352     {
1353         require(
1354             map._entries.length > index,
1355             "EnumerableMap: index out of bounds"
1356         );
1357 
1358         MapEntry storage entry = map._entries[index];
1359         return (entry._key, entry._value);
1360     }
1361 
1362     /**
1363      * @dev Tries to returns the value associated with `key`.  O(1).
1364      * Does not revert if `key` is not in the map.
1365      */
1366     function _tryGet(Map storage map, bytes32 key)
1367         private
1368         view
1369         returns (bool, bytes32)
1370     {
1371         uint256 keyIndex = map._indexes[key];
1372         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1373         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1374     }
1375 
1376     /**
1377      * @dev Returns the value associated with `key`.  O(1).
1378      *
1379      * Requirements:
1380      *
1381      * - `key` must be in the map.
1382      */
1383     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1384         uint256 keyIndex = map._indexes[key];
1385         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1386         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1387     }
1388 
1389     /**
1390      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1391      *
1392      * CAUTION: This function is deprecated because it requires allocating memory for the error
1393      * message unnecessarily. For custom revert reasons use {_tryGet}.
1394      */
1395     function _get(
1396         Map storage map,
1397         bytes32 key,
1398         string memory errorMessage
1399     ) private view returns (bytes32) {
1400         uint256 keyIndex = map._indexes[key];
1401         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1402         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1403     }
1404 
1405     // UintToAddressMap
1406 
1407     struct UintToAddressMap {
1408         Map _inner;
1409     }
1410 
1411     /**
1412      * @dev Adds a key-value pair to a map, or updates the value for an existing
1413      * key. O(1).
1414      *
1415      * Returns true if the key was added to the map, that is if it was not
1416      * already present.
1417      */
1418     function set(
1419         UintToAddressMap storage map,
1420         uint256 key,
1421         address value
1422     ) internal returns (bool) {
1423         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1424     }
1425 
1426     /**
1427      * @dev Removes a value from a set. O(1).
1428      *
1429      * Returns true if the key was removed from the map, that is if it was present.
1430      */
1431     function remove(UintToAddressMap storage map, uint256 key)
1432         internal
1433         returns (bool)
1434     {
1435         return _remove(map._inner, bytes32(key));
1436     }
1437 
1438     /**
1439      * @dev Returns true if the key is in the map. O(1).
1440      */
1441     function contains(UintToAddressMap storage map, uint256 key)
1442         internal
1443         view
1444         returns (bool)
1445     {
1446         return _contains(map._inner, bytes32(key));
1447     }
1448 
1449     /**
1450      * @dev Returns the number of elements in the map. O(1).
1451      */
1452     function length(UintToAddressMap storage map)
1453         internal
1454         view
1455         returns (uint256)
1456     {
1457         return _length(map._inner);
1458     }
1459 
1460     /**
1461      * @dev Returns the element stored at position `index` in the set. O(1).
1462      * Note that there are no guarantees on the ordering of values inside the
1463      * array, and it may change when more values are added or removed.
1464      *
1465      * Requirements:
1466      *
1467      * - `index` must be strictly less than {length}.
1468      */
1469     function at(UintToAddressMap storage map, uint256 index)
1470         internal
1471         view
1472         returns (uint256, address)
1473     {
1474         (bytes32 key, bytes32 value) = _at(map._inner, index);
1475         return (uint256(key), address(uint160(uint256(value))));
1476     }
1477 
1478     /**
1479      * @dev Tries to returns the value associated with `key`.  O(1).
1480      * Does not revert if `key` is not in the map.
1481      *
1482      * _Available since v3.4._
1483      */
1484     function tryGet(UintToAddressMap storage map, uint256 key)
1485         internal
1486         view
1487         returns (bool, address)
1488     {
1489         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1490         return (success, address(uint160(uint256(value))));
1491     }
1492 
1493     /**
1494      * @dev Returns the value associated with `key`.  O(1).
1495      *
1496      * Requirements:
1497      *
1498      * - `key` must be in the map.
1499      */
1500     function get(UintToAddressMap storage map, uint256 key)
1501         internal
1502         view
1503         returns (address)
1504     {
1505         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1506     }
1507 
1508     /**
1509      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1510      *
1511      * CAUTION: This function is deprecated because it requires allocating memory for the error
1512      * message unnecessarily. For custom revert reasons use {tryGet}.
1513      */
1514     function get(
1515         UintToAddressMap storage map,
1516         uint256 key,
1517         string memory errorMessage
1518     ) internal view returns (address) {
1519         return
1520             address(
1521                 uint160(uint256(_get(map._inner, bytes32(key), errorMessage)))
1522             );
1523     }
1524 }
1525 
1526 // File: @openzeppelin/contracts/utils/Strings.sol
1527 
1528 pragma solidity >=0.6.0 <0.8.0;
1529 
1530 /**
1531  * @dev String operations.
1532  */
1533 library Strings {
1534     /**
1535      * @dev Converts a `uint256` to its ASCII `string` representation.
1536      */
1537     function toString(uint256 value) internal pure returns (string memory) {
1538         // Inspired by OraclizeAPI's implementation - MIT licence
1539         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1540 
1541         if (value == 0) {
1542             return "0";
1543         }
1544         uint256 temp = value;
1545         uint256 digits;
1546         while (temp != 0) {
1547             digits++;
1548             temp /= 10;
1549         }
1550         bytes memory buffer = new bytes(digits);
1551         uint256 index = digits - 1;
1552         temp = value;
1553         while (temp != 0) {
1554             buffer[index--] = bytes1(uint8(48 + (temp % 10)));
1555             temp /= 10;
1556         }
1557         return string(buffer);
1558     }
1559 }
1560 
1561 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1562 
1563 pragma solidity >=0.6.0 <0.8.0;
1564 
1565 /**
1566  * @title ERC721 Non-Fungible Token Standard basic implementation
1567  * @dev see https://eips.ethereum.org/EIPS/eip-721
1568  */
1569 
1570 contract ERC721 is
1571     Context,
1572     ERC165,
1573     IERC721,
1574     IERC721Metadata,
1575     IERC721Enumerable
1576 {
1577     using SafeMath for uint256;
1578     using Address for address;
1579     using EnumerableSet for EnumerableSet.UintSet;
1580     using EnumerableMap for EnumerableMap.UintToAddressMap;
1581     using Strings for uint256;
1582 
1583     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1584     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1585     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1586 
1587     // Mapping from holder address to their (enumerable) set of owned tokens
1588     mapping(address => EnumerableSet.UintSet) private _holderTokens;
1589 
1590     // Enumerable mapping from token ids to their owners
1591     EnumerableMap.UintToAddressMap private _tokenOwners;
1592 
1593     // Mapping from token ID to approved address
1594     mapping(uint256 => address) private _tokenApprovals;
1595 
1596     // Mapping from owner to operator approvals
1597     mapping(address => mapping(address => bool)) private _operatorApprovals;
1598 
1599     // Token name
1600     string private _name;
1601 
1602     // Token symbol
1603     string private _symbol;
1604 
1605     // Optional mapping for token URIs
1606     mapping(uint256 => string) private _tokenURIs;
1607 
1608     // Base URI
1609     string private _baseURI;
1610 
1611     /*
1612      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1613      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1614      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1615      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1616      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1617      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1618      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1619      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1620      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1621      *
1622      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1623      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1624      */
1625     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1626 
1627     /*
1628      *     bytes4(keccak256('name()')) == 0x06fdde03
1629      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1630      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1631      *
1632      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1633      */
1634     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1635 
1636     /*
1637      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1638      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1639      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1640      *
1641      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1642      */
1643     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1644 
1645     /**
1646      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1647      */
1648     constructor(string memory name_, string memory symbol_) public {
1649         _name = name_;
1650         _symbol = symbol_;
1651 
1652         // register the supported interfaces to conform to ERC721 via ERC165
1653         _registerInterface(_INTERFACE_ID_ERC721);
1654         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1655         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1656     }
1657 
1658     /**
1659      * @dev See {IERC721-balanceOf}.
1660      */
1661     function balanceOf(address owner)
1662         public
1663         view
1664         virtual
1665         override
1666         returns (uint256)
1667     {
1668         require(
1669             owner != address(0),
1670             "ERC721: balance query for the zero address"
1671         );
1672         return _holderTokens[owner].length();
1673     }
1674 
1675     /**
1676      * @dev See {IERC721-ownerOf}.
1677      */
1678     function ownerOf(uint256 tokenId)
1679         public
1680         view
1681         virtual
1682         override
1683         returns (address)
1684     {
1685         return
1686             _tokenOwners.get(
1687                 tokenId,
1688                 "ERC721: owner query for nonexistent token"
1689             );
1690     }
1691 
1692     /**
1693      * @dev See {IERC721Metadata-name}.
1694      */
1695     function name() public view virtual override returns (string memory) {
1696         return _name;
1697     }
1698 
1699     /**
1700      * @dev See {IERC721Metadata-symbol}.
1701      */
1702     function symbol() public view virtual override returns (string memory) {
1703         return _symbol;
1704     }
1705 
1706     /**
1707      * @dev See {IERC721Metadata-tokenURI}.
1708      */
1709     function tokenURI(uint256 tokenId)
1710         public
1711         view
1712         virtual
1713         override
1714         returns (string memory)
1715     {
1716         require(
1717             _exists(tokenId),
1718             "ERC721Metadata: URI query for nonexistent token"
1719         );
1720 
1721         string memory _tokenURI = _tokenURIs[tokenId];
1722         string memory base = baseURI();
1723 
1724         // If there is no base URI, return the token URI.
1725         if (bytes(base).length == 0) {
1726             return _tokenURI;
1727         }
1728         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1729         if (bytes(_tokenURI).length > 0) {
1730             return string(abi.encodePacked(base, _tokenURI));
1731         }
1732         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1733         return string(abi.encodePacked(base, tokenId.toString()));
1734     }
1735 
1736     /**
1737      * @dev Returns the base URI set via {_setBaseURI}. This will be
1738      * automatically added as a prefix in {tokenURI} to each token's URI, or
1739      * to the token ID if no specific URI is set for that token ID.
1740      */
1741     function baseURI() public view virtual returns (string memory) {
1742         return _baseURI;
1743     }
1744 
1745     /**
1746      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1747      */
1748     function tokenOfOwnerByIndex(address owner, uint256 index)
1749         public
1750         view
1751         virtual
1752         override
1753         returns (uint256)
1754     {
1755         return _holderTokens[owner].at(index);
1756     }
1757 
1758     /**
1759      * @dev See {IERC721Enumerable-totalSupply}.
1760      */
1761     function totalSupply() public view virtual override returns (uint256) {
1762         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1763         return _tokenOwners.length();
1764     }
1765 
1766     /**
1767      * @dev See {IERC721Enumerable-tokenByIndex}.
1768      */
1769     function tokenByIndex(uint256 index)
1770         public
1771         view
1772         virtual
1773         override
1774         returns (uint256)
1775     {
1776         (uint256 tokenId, ) = _tokenOwners.at(index);
1777         return tokenId;
1778     }
1779 
1780     /**
1781      * @dev See {IERC721-approve}.
1782      */
1783     function approve(address to, uint256 tokenId) public virtual override {
1784         address owner = ERC721.ownerOf(tokenId);
1785         require(to != owner, "ERC721: approval to current owner");
1786 
1787         require(
1788             _msgSender() == owner ||
1789                 ERC721.isApprovedForAll(owner, _msgSender()),
1790             "ERC721: approve caller is not owner nor approved for all"
1791         );
1792 
1793         _approve(to, tokenId);
1794     }
1795 
1796     /**
1797      * @dev See {IERC721-getApproved}.
1798      */
1799     function getApproved(uint256 tokenId)
1800         public
1801         view
1802         virtual
1803         override
1804         returns (address)
1805     {
1806         require(
1807             _exists(tokenId),
1808             "ERC721: approved query for nonexistent token"
1809         );
1810 
1811         return _tokenApprovals[tokenId];
1812     }
1813 
1814     /**
1815      * @dev See {IERC721-setApprovalForAll}.
1816      */
1817     function setApprovalForAll(address operator, bool approved)
1818         public
1819         virtual
1820         override
1821     {
1822         require(operator != _msgSender(), "ERC721: approve to caller");
1823 
1824         _operatorApprovals[_msgSender()][operator] = approved;
1825         emit ApprovalForAll(_msgSender(), operator, approved);
1826     }
1827 
1828     /**
1829      * @dev See {IERC721-isApprovedForAll}.
1830      */
1831     function isApprovedForAll(address owner, address operator)
1832         public
1833         view
1834         virtual
1835         override
1836         returns (bool)
1837     {
1838         return _operatorApprovals[owner][operator];
1839     }
1840 
1841     /**
1842      * @dev See {IERC721-transferFrom}.
1843      */
1844     function transferFrom(
1845         address from,
1846         address to,
1847         uint256 tokenId
1848     ) public virtual override {
1849         //solhint-disable-next-line max-line-length
1850         require(
1851             _isApprovedOrOwner(_msgSender(), tokenId),
1852             "ERC721: transfer caller is not owner nor approved"
1853         );
1854 
1855         _transfer(from, to, tokenId);
1856     }
1857 
1858     /**
1859      * @dev See {IERC721-safeTransferFrom}.
1860      */
1861     function safeTransferFrom(
1862         address from,
1863         address to,
1864         uint256 tokenId
1865     ) public virtual override {
1866         safeTransferFrom(from, to, tokenId, "");
1867     }
1868 
1869     /**
1870      * @dev See {IERC721-safeTransferFrom}.
1871      */
1872     function safeTransferFrom(
1873         address from,
1874         address to,
1875         uint256 tokenId,
1876         bytes memory _data
1877     ) public virtual override {
1878         require(
1879             _isApprovedOrOwner(_msgSender(), tokenId),
1880             "ERC721: transfer caller is not owner nor approved"
1881         );
1882         _safeTransfer(from, to, tokenId, _data);
1883     }
1884 
1885     /**
1886      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1887      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1888      *
1889      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1890      *
1891      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1892      * implement alternative mechanisms to perform token transfer, such as signature-based.
1893      *
1894      * Requirements:
1895      *
1896      * - `from` cannot be the zero address.
1897      * - `to` cannot be the zero address.
1898      * - `tokenId` token must exist and be owned by `from`.
1899      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1900      *
1901      * Emits a {Transfer} event.
1902      */
1903     function _safeTransfer(
1904         address from,
1905         address to,
1906         uint256 tokenId,
1907         bytes memory _data
1908     ) internal virtual {
1909         _transfer(from, to, tokenId);
1910         require(
1911             _checkOnERC721Received(from, to, tokenId, _data),
1912             "ERC721: transfer to non ERC721Receiver implementer"
1913         );
1914     }
1915 
1916     /**
1917      * @dev Returns whether `tokenId` exists.
1918      *
1919      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1920      *
1921      * Tokens start existing when they are minted (`_mint`),
1922      * and stop existing when they are burned (`_burn`).
1923      */
1924     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1925         return _tokenOwners.contains(tokenId);
1926     }
1927 
1928     /**
1929      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1930      *
1931      * Requirements:
1932      *
1933      * - `tokenId` must exist.
1934      */
1935     function _isApprovedOrOwner(address spender, uint256 tokenId)
1936         internal
1937         view
1938         virtual
1939         returns (bool)
1940     {
1941         require(
1942             _exists(tokenId),
1943             "ERC721: operator query for nonexistent token"
1944         );
1945         address owner = ERC721.ownerOf(tokenId);
1946         return (spender == owner ||
1947             getApproved(tokenId) == spender ||
1948             ERC721.isApprovedForAll(owner, spender));
1949     }
1950 
1951     /**
1952      * @dev Safely mints `tokenId` and transfers it to `to`.
1953      *
1954      * Requirements:
1955      d*
1956      * - `tokenId` must not exist.
1957      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1958      *
1959      * Emits a {Transfer} event.
1960      */
1961     function _safeMint(address to, uint256 tokenId) internal virtual {
1962         _safeMint(to, tokenId, "");
1963     }
1964 
1965     /**
1966      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1967      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1968      */
1969     function _safeMint(
1970         address to,
1971         uint256 tokenId,
1972         bytes memory _data
1973     ) internal virtual {
1974         _mint(to, tokenId);
1975         require(
1976             _checkOnERC721Received(address(0), to, tokenId, _data),
1977             "ERC721: transfer to non ERC721Receiver implementer"
1978         );
1979     }
1980 
1981     /**
1982      * @dev Mints `tokenId` and transfers it to `to`.
1983      *
1984      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1985      *
1986      * Requirements:
1987      *
1988      * - `tokenId` must not exist.
1989      * - `to` cannot be the zero address.
1990      *
1991      * Emits a {Transfer} event.
1992      */
1993     function _mint(address to, uint256 tokenId) internal virtual {
1994         require(to != address(0), "ERC721: mint to the zero address");
1995         require(!_exists(tokenId), "ERC721: token already minted");
1996 
1997         _beforeTokenTransfer(address(0), to, tokenId);
1998 
1999         _holderTokens[to].add(tokenId);
2000 
2001         _tokenOwners.set(tokenId, to);
2002 
2003         emit Transfer(address(0), to, tokenId);
2004     }
2005 
2006     /**
2007      * @dev Destroys `tokenId`.
2008      * The approval is cleared when the token is burned.
2009      *
2010      * Requirements:
2011      *
2012      * - `tokenId` must exist.
2013      *
2014      * Emits a {Transfer} event.
2015      */
2016     function _burn(uint256 tokenId) internal virtual {
2017         address owner = ERC721.ownerOf(tokenId); // internal owner
2018 
2019         _beforeTokenTransfer(owner, address(0), tokenId);
2020 
2021         // Clear approvals
2022         _approve(address(0), tokenId);
2023 
2024         // Clear metadata (if any)
2025         if (bytes(_tokenURIs[tokenId]).length != 0) {
2026             delete _tokenURIs[tokenId];
2027         }
2028 
2029         _holderTokens[owner].remove(tokenId);
2030 
2031         _tokenOwners.remove(tokenId);
2032 
2033         emit Transfer(owner, address(0), tokenId);
2034     }
2035 
2036     /**
2037      * @dev Transfers `tokenId` from `from` to `to`.
2038      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2039      *
2040      * Requirements:
2041      *
2042      * - `to` cannot be the zero address.
2043      * - `tokenId` token must be owned by `from`.
2044      *
2045      * Emits a {Transfer} event.
2046      */
2047     function _transfer(
2048         address from,
2049         address to,
2050         uint256 tokenId
2051     ) internal virtual {
2052         require(
2053             ERC721.ownerOf(tokenId) == from,
2054             "ERC721: transfer of token that is not own"
2055         ); // internal owner
2056         require(to != address(0), "ERC721: transfer to the zero address");
2057 
2058         _beforeTokenTransfer(from, to, tokenId);
2059 
2060         // Clear approvals from the previous owner
2061         _approve(address(0), tokenId);
2062 
2063         _holderTokens[from].remove(tokenId);
2064         _holderTokens[to].add(tokenId);
2065 
2066         _tokenOwners.set(tokenId, to);
2067 
2068         emit Transfer(from, to, tokenId);
2069     }
2070 
2071     /**
2072      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
2073      *
2074      * Requirements:
2075      *
2076      * - `tokenId` must exist.
2077      */
2078     function _setTokenURI(uint256 tokenId, string memory _tokenURI)
2079         internal
2080         virtual
2081     {
2082         require(
2083             _exists(tokenId),
2084             "ERC721Metadata: URI set of nonexistent token"
2085         );
2086         _tokenURIs[tokenId] = _tokenURI;
2087     }
2088 
2089     /**
2090      * @dev Internal function to set the base URI for all token IDs. It is
2091      * automatically added as a prefix to the value returned in {tokenURI},
2092      * or to the token ID if {tokenURI} is empty.
2093      */
2094     function _setBaseURI(string memory baseURI_) internal virtual {
2095         _baseURI = baseURI_;
2096     }
2097 
2098     /**
2099      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2100      * The call is not executed if the target address is not a contract.
2101      *
2102      * @param from address representing the previous owner of the given token ID
2103      * @param to target address that will receive the tokens
2104      * @param tokenId uint256 ID of the token to be transferred
2105      * @param _data bytes optional data to send along with the call
2106      * @return bool whether the call correctly returned the expected magic value
2107      */
2108     function _checkOnERC721Received(
2109         address from,
2110         address to,
2111         uint256 tokenId,
2112         bytes memory _data
2113     ) private returns (bool) {
2114         if (!to.isContract()) {
2115             return true;
2116         }
2117         bytes memory returndata = to.functionCall(
2118             abi.encodeWithSelector(
2119                 IERC721Receiver(to).onERC721Received.selector,
2120                 _msgSender(),
2121                 from,
2122                 tokenId,
2123                 _data
2124             ),
2125             "ERC721: transfer to non ERC721Receiver implementer"
2126         );
2127         bytes4 retval = abi.decode(returndata, (bytes4));
2128         return (retval == _ERC721_RECEIVED);
2129     }
2130 
2131     /**
2132      * @dev Approve `to` to operate on `tokenId`
2133      *
2134      * Emits an {Approval} event.
2135      */
2136     function _approve(address to, uint256 tokenId) internal virtual {
2137         _tokenApprovals[tokenId] = to;
2138         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
2139     }
2140 
2141     /**
2142      * @dev Hook that is called before any token transfer. This includes minting
2143      * and burning.
2144      *
2145      * Calling conditions:
2146      *
2147      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2148      * transferred to `to`.
2149      * - When `from` is zero, `tokenId` will be minted for `to`.
2150      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2151      * - `from` cannot be the zero address.
2152      * - `to` cannot be the zero address.
2153      *
2154      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2155      */
2156     function _beforeTokenTransfer(
2157         address from,
2158         address to,
2159         uint256 tokenId
2160     ) internal virtual {}
2161 }
2162 
2163 // File: @openzeppelin/contracts/access/Ownable.sol
2164 
2165 pragma solidity >=0.6.0 <0.8.0;
2166 
2167 /**
2168  * @dev Contract module which provides a basic access control mechanism, where
2169  * there is an account (an owner) that can be granted exclusive access to
2170  * specific functions.
2171  *
2172  * By default, the owner account will be the one that deploys the contract. This
2173  * can later be changed with {transferOwnership}.
2174  *
2175  * This module is used through inheritance. It will make available the modifier
2176  * `onlyOwner`, which can be applied to your functions to restrict their use to
2177  * the owner.
2178  */
2179 abstract contract Ownable is Context {
2180     address private _owner;
2181 
2182     event OwnershipTransferred(
2183         address indexed previousOwner,
2184         address indexed newOwner
2185     );
2186 
2187     /**
2188      * @dev Initializes the contract setting the deployer as the initial owner.
2189      */
2190     constructor() internal {
2191         address msgSender = _msgSender();
2192         _owner = msgSender;
2193         emit OwnershipTransferred(address(0), msgSender);
2194     }
2195 
2196     /**
2197      * @dev Returns the address of the current owner.
2198      */
2199     function owner() public view virtual returns (address) {
2200         return _owner;
2201     }
2202 
2203     /**
2204      * @dev Throws if called by any account other than the owner.
2205      */
2206     modifier onlyOwner() {
2207         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2208         _;
2209     }
2210 
2211     /**
2212      * @dev Leaves the contract without owner. It will not be possible to call
2213      * `onlyOwner` functions anymore. Can only be called by the current owner.
2214      *
2215      * NOTE: Renouncing ownership will leave the contract without an owner,
2216      * thereby removing any functionality that is only available to the owner.
2217      */
2218     function renounceOwnership() public virtual onlyOwner {
2219         emit OwnershipTransferred(_owner, address(0));
2220         _owner = address(0);
2221     }
2222 
2223     /**
2224      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2225      * Can only be called by the current owner.
2226      */
2227     function transferOwnership(address newOwner) public virtual onlyOwner {
2228         require(
2229             newOwner != address(0),
2230             "Ownable: new owner is the zero address"
2231         );
2232         emit OwnershipTransferred(_owner, newOwner);
2233         _owner = newOwner;
2234     }
2235 }
2236 
2237 pragma solidity ^0.7.0;
2238 pragma abicoder v2;
2239 
2240 /**
2241  * @title Odd Ogres contract
2242  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
2243  */
2244 
2245 contract OddOgres is ERC721, Ownable {
2246   using SafeMath for uint256;
2247 
2248   bool public saleIsActive = false; // current status of sale, default is inactive
2249   string public NFT_PROVENANCE = ''; // hash representing ownership history of the NFT
2250   uint256 public NFTPrice = 33000000000000000; // 0.033 ETH
2251   uint256 public NFTReserve = 200; // Reserve amount of NFTs
2252   uint256 public constant maxNFTPurchase = 20; // max no. of tokens that can be bought at a time
2253   uint256 public constant MAX_NFTS = 9999; // max total supply of NFTs
2254 
2255   constructor() ERC721('Odd Ogres', 'Ogre') {}
2256 
2257   // Withdraws entire balance of contract (ETH) to owner account (owner-only)
2258   function withdraw() public onlyOwner {
2259     uint256 balance = address(this).balance;
2260     msg.sender.transfer(balance);
2261   }
2262 
2263   // Withdraws amount specified (ETH) from balance of contract to owner account (owner-only)
2264   function withdrawPartial(address payable _recipient, uint256 _amount)
2265     public
2266     onlyOwner
2267   {
2268     // Check that amount is not more than total contract balance
2269     require(
2270       _amount > 0 && _amount <= address(this).balance,
2271       'Withdraw amount must be positive and not exceed total contract balance'
2272     );
2273     _recipient.transfer(_amount);
2274   }
2275 
2276   // Sets a new price for the NFT (owner-only)
2277   function setNFTPrice(uint256 newPrice) public onlyOwner {
2278     NFTPrice = newPrice;
2279   }
2280 
2281   /**
2282    * Mints specified amount of new tokens for the recipient from the reserve
2283    * reduces the reserve by this amount (owner-only)
2284    */
2285   function reserveNFTs(address _to, uint256 _reserveAmount) public onlyOwner {
2286     uint256 supply = totalSupply();
2287     // Checks that there is sufficient reserve supply of tokens for the transaction
2288     require(
2289       _reserveAmount > 0 && _reserveAmount <= NFTReserve,
2290       'Not enough reserve left'
2291     );
2292     for (uint256 i = 0; i < _reserveAmount; i++) {
2293       _safeMint(_to, supply + i);
2294     }
2295     NFTReserve = NFTReserve.sub(_reserveAmount);
2296   }
2297 
2298   // Sets the provenance (ownership history) of the NFT (owner-only). The information is encoded by its hash value.
2299   function setProvenanceHash(string memory provenanceHash) public onlyOwner {
2300     NFT_PROVENANCE = provenanceHash;
2301   }
2302 
2303   /**
2304    * Sets the base URI for all token IDs. It is automatically added as a prefix to the value returned in {tokenURI},
2305    * or to the token ID if {tokenURI} is empty. Identical to internal function _setBaseURI, but with public
2306    * visibility, and can be called by owner only.
2307    */
2308   function setBaseURI(string memory baseURI) public onlyOwner {
2309     _setBaseURI(baseURI);
2310   }
2311 
2312   // Toggle the current status of the sale between active/inactive (owner-only)
2313   function flipSaleState() public onlyOwner {
2314     saleIsActive = !saleIsActive;
2315   }
2316 
2317   // Returns an array of all tokens belonging to an owner (if any), indexed by their token ID
2318   function tokensOfOwner(address _owner)
2319     external
2320     view
2321     returns (uint256[] memory)
2322   {
2323     uint256 tokenCount = balanceOf(_owner);
2324     if (tokenCount == 0) {
2325       // Return an empty array
2326       return new uint256[](0);
2327     } else {
2328       uint256[] memory result = new uint256[](tokenCount);
2329       uint256 index;
2330       for (index = 0; index < tokenCount; index++) {
2331         result[index] = tokenOfOwnerByIndex(_owner, index);
2332       }
2333       return result;
2334     }
2335   }
2336 
2337   // Mints specified number of NFTs for the receiver and accepts payment (ETH) in return
2338   function mintNFT(uint256 numberOfTokens) public payable {
2339     // Checks that sale is currently active
2340     require(saleIsActive, 'Sale must be active to mint NFT');
2341     // Checks that requested number of tokens is positive and not more than the max purchase limit
2342     require(
2343       numberOfTokens > 0 && numberOfTokens <= maxNFTPurchase,
2344       'Exceeded max token purchase'
2345     );
2346     // Checks that final total supply of tokens (if sale occurs) would not exceed the max supply limit
2347     require(
2348       totalSupply().add(numberOfTokens) <= MAX_NFTS,
2349       'Purchase would exceed max supply of NFTs'
2350     );
2351     /**
2352          Checks that the buyer sends at least the total price of the transaction (ETH), calculated as number 
2353         * of tokens times the token price
2354         */
2355     require(
2356       msg.value >= NFTPrice.mul(numberOfTokens),
2357       'ETH value sent is not correct'
2358     );
2359 
2360     for (uint256 i = 0; i < numberOfTokens; i++) {
2361       uint256 mintIndex = totalSupply();
2362       if (totalSupply() < MAX_NFTS) {
2363         _safeMint(msg.sender, mintIndex);
2364       }
2365     }
2366   }
2367 }