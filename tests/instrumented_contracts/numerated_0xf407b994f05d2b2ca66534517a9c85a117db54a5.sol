1 // Welcome to Booty Bay, ye scurvy sea dog!
2 // Plodding Pirates is a 10,000-unit limited NFT collection for the discerning swashbuckler. Ghoulish bilge rats, ghostly buccaneers and betentacled marauders await you on the seven seas. Savvy?
3 // Come say YarARRGH ->  https://discord.gg/arCDND7HuW
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 // File: @openzeppelin/contracts/introspection/IERC165.sol
31 
32 pragma solidity >=0.6.0 <0.8.0;
33 
34 /**
35  * @dev Interface of the ERC165 standard, as defined in the
36  * https://eips.ethereum.org/EIPS/eip-165[EIP].
37  *
38  * Implementers can declare support of contract interfaces, which can then be
39  * queried by others ({ERC165Checker}).
40  *
41  * For an implementation, see {ERC165}.
42  */
43 interface IERC165 {
44     /**
45      * @dev Returns true if this contract implements the interface defined by
46      * `interfaceId`. See the corresponding
47      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
48      * to learn more about how these ids are created.
49      *
50      * This function call must use less than 30 000 gas.
51      */
52     function supportsInterface(bytes4 interfaceId) external view returns (bool);
53 }
54 
55 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
56 
57 pragma solidity >=0.6.2 <0.8.0;
58 
59 /**
60  * @dev Required interface of an ERC721 compliant contract.
61  */
62 interface IERC721 is IERC165 {
63     /**
64      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
65      */
66     event Transfer(
67         address indexed from,
68         address indexed to,
69         uint256 indexed tokenId
70     );
71 
72     /**
73      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
74      */
75     event Approval(
76         address indexed owner,
77         address indexed approved,
78         uint256 indexed tokenId
79     );
80 
81     /**
82      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
83      */
84     event ApprovalForAll(
85         address indexed owner,
86         address indexed operator,
87         bool approved
88     );
89 
90     /**
91      * @dev Returns the number of tokens in ``owner``'s account.
92      */
93     function balanceOf(address owner) external view returns (uint256 balance);
94 
95     /**
96      * @dev Returns the owner of the `tokenId` token.
97      *
98      * Requirements:
99      *
100      * - `tokenId` must exist.
101      */
102     function ownerOf(uint256 tokenId) external view returns (address owner);
103 
104     /**
105      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
106      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
107      *
108      * Requirements:
109      *
110      * - `from` cannot be the zero address.
111      * - `to` cannot be the zero address.
112      * - `tokenId` token must exist and be owned by `from`.
113      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
114      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
115      *
116      * Emits a {Transfer} event.
117      */
118     function safeTransferFrom(
119         address from,
120         address to,
121         uint256 tokenId
122     ) external;
123 
124     /**
125      * @dev Transfers `tokenId` token from `from` to `to`.
126      *
127      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
128      *
129      * Requirements:
130      *
131      * - `from` cannot be the zero address.
132      * - `to` cannot be the zero address.
133      * - `tokenId` token must be owned by `from`.
134      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
135      *
136      * Emits a {Transfer} event.
137      */
138     function transferFrom(
139         address from,
140         address to,
141         uint256 tokenId
142     ) external;
143 
144     /**
145      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
146      * The approval is cleared when the token is transferred.
147      *
148      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
149      *
150      * Requirements:
151      *
152      * - The caller must own the token or be an approved operator.
153      * - `tokenId` must exist.
154      *
155      * Emits an {Approval} event.
156      */
157     function approve(address to, uint256 tokenId) external;
158 
159     /**
160      * @dev Returns the account approved for `tokenId` token.
161      *
162      * Requirements:
163      *
164      * - `tokenId` must exist.
165      */
166     function getApproved(uint256 tokenId)
167         external
168         view
169         returns (address operator);
170 
171     /**
172      * @dev Approve or remove `operator` as an operator for the caller.
173      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
174      *
175      * Requirements:
176      *
177      * - The `operator` cannot be the caller.
178      *
179      * Emits an {ApprovalForAll} event.
180      */
181     function setApprovalForAll(address operator, bool _approved) external;
182 
183     /**
184      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
185      *
186      * See {setApprovalForAll}
187      */
188     function isApprovedForAll(address owner, address operator)
189         external
190         view
191         returns (bool);
192 
193     /**
194      * @dev Safely transfers `tokenId` token from `from` to `to`.
195      *
196      * Requirements:
197      *
198      * - `from` cannot be the zero address.
199      * - `to` cannot be the zero address.
200      * - `tokenId` token must exist and be owned by `from`.
201      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
202      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
203      *
204      * Emits a {Transfer} event.
205      */
206     function safeTransferFrom(
207         address from,
208         address to,
209         uint256 tokenId,
210         bytes calldata data
211     ) external;
212 }
213 
214 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
215 
216 pragma solidity >=0.6.2 <0.8.0;
217 
218 /**
219  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
220  * @dev See https://eips.ethereum.org/EIPS/eip-721
221  */
222 interface IERC721Metadata is IERC721 {
223     /**
224      * @dev Returns the token collection name.
225      */
226     function name() external view returns (string memory);
227 
228     /**
229      * @dev Returns the token collection symbol.
230      */
231     function symbol() external view returns (string memory);
232 
233     /**
234      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
235      */
236     function tokenURI(uint256 tokenId) external view returns (string memory);
237 }
238 
239 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
240 
241 pragma solidity >=0.6.2 <0.8.0;
242 
243 /**
244  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
245  * @dev See https://eips.ethereum.org/EIPS/eip-721
246  */
247 interface IERC721Enumerable is IERC721 {
248     /**
249      * @dev Returns the total amount of tokens stored by the contract.
250      */
251     function totalSupply() external view returns (uint256);
252 
253     /**
254      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
255      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
256      */
257     function tokenOfOwnerByIndex(address owner, uint256 index)
258         external
259         view
260         returns (uint256 tokenId);
261 
262     /**
263      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
264      * Use along with {totalSupply} to enumerate all tokens.
265      */
266     function tokenByIndex(uint256 index) external view returns (uint256);
267 }
268 
269 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
270 
271 pragma solidity >=0.6.0 <0.8.0;
272 
273 /**
274  * @title ERC721 token receiver interface
275  * @dev Interface for any contract that wants to support safeTransfers
276  * from ERC721 asset contracts.
277  */
278 interface IERC721Receiver {
279     /**
280      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
281      * by `operator` from `from`, this function is called.
282      *
283      * It must return its Solidity selector to confirm the token transfer.
284      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
285      *
286      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
287      */
288     function onERC721Received(
289         address operator,
290         address from,
291         uint256 tokenId,
292         bytes calldata data
293     ) external returns (bytes4);
294 }
295 
296 // File: @openzeppelin/contracts/introspection/ERC165.sol
297 
298 pragma solidity >=0.6.0 <0.8.0;
299 
300 /**
301  * @dev Implementation of the {IERC165} interface.
302  *
303  * Contracts may inherit from this and call {_registerInterface} to declare
304  * their support of an interface.
305  */
306 abstract contract ERC165 is IERC165 {
307     /*
308      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
309      */
310     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
311 
312     /**
313      * @dev Mapping of interface ids to whether or not it's supported.
314      */
315     mapping(bytes4 => bool) private _supportedInterfaces;
316 
317     constructor() internal {
318         // Derived contracts need only register support for their own interfaces,
319         // we register support for ERC165 itself here
320         _registerInterface(_INTERFACE_ID_ERC165);
321     }
322 
323     /**
324      * @dev See {IERC165-supportsInterface}.
325      *
326      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
327      */
328     function supportsInterface(bytes4 interfaceId)
329         public
330         view
331         virtual
332         override
333         returns (bool)
334     {
335         return _supportedInterfaces[interfaceId];
336     }
337 
338     /**
339      * @dev Registers the contract as an implementer of the interface defined by
340      * `interfaceId`. Support of the actual ERC165 interface is automatic and
341      * registering its interface id is not required.
342      *
343      * See {IERC165-supportsInterface}.
344      *
345      * Requirements:
346      *
347      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
348      */
349     function _registerInterface(bytes4 interfaceId) internal virtual {
350         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
351         _supportedInterfaces[interfaceId] = true;
352     }
353 }
354 
355 // File: @openzeppelin/contracts/math/SafeMath.sol
356 
357 pragma solidity >=0.6.0 <0.8.0;
358 
359 /**
360  * @dev Wrappers over Solidity's arithmetic operations with added overflow
361  * checks.
362  *
363  * Arithmetic operations in Solidity wrap on overflow. This can easily result
364  * in bugs, because programmers usually assume that an overflow raises an
365  * error, which is the standard behavior in high level programming languages.
366  * `SafeMath` restores this intuition by reverting the transaction when an
367  * operation overflows.
368  *
369  * Using this library instead of the unchecked operations eliminates an entire
370  * class of bugs, so it's recommended to use it always.
371  */
372 library SafeMath {
373     /**
374      * @dev Returns the addition of two unsigned integers, with an overflow flag.
375      *
376      * _Available since v3.4._
377      */
378     function tryAdd(uint256 a, uint256 b)
379         internal
380         pure
381         returns (bool, uint256)
382     {
383         uint256 c = a + b;
384         if (c < a) return (false, 0);
385         return (true, c);
386     }
387 
388     /**
389      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
390      *
391      * _Available since v3.4._
392      */
393     function trySub(uint256 a, uint256 b)
394         internal
395         pure
396         returns (bool, uint256)
397     {
398         if (b > a) return (false, 0);
399         return (true, a - b);
400     }
401 
402     /**
403      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
404      *
405      * _Available since v3.4._
406      */
407     function tryMul(uint256 a, uint256 b)
408         internal
409         pure
410         returns (bool, uint256)
411     {
412         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
413         // benefit is lost if 'b' is also tested.
414         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
415         if (a == 0) return (true, 0);
416         uint256 c = a * b;
417         if (c / a != b) return (false, 0);
418         return (true, c);
419     }
420 
421     /**
422      * @dev Returns the division of two unsigned integers, with a division by zero flag.
423      *
424      * _Available since v3.4._
425      */
426     function tryDiv(uint256 a, uint256 b)
427         internal
428         pure
429         returns (bool, uint256)
430     {
431         if (b == 0) return (false, 0);
432         return (true, a / b);
433     }
434 
435     /**
436      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
437      *
438      * _Available since v3.4._
439      */
440     function tryMod(uint256 a, uint256 b)
441         internal
442         pure
443         returns (bool, uint256)
444     {
445         if (b == 0) return (false, 0);
446         return (true, a % b);
447     }
448 
449     /**
450      * @dev Returns the addition of two unsigned integers, reverting on
451      * overflow.
452      *
453      * Counterpart to Solidity's `+` operator.
454      *
455      * Requirements:
456      *
457      * - Addition cannot overflow.
458      */
459     function add(uint256 a, uint256 b) internal pure returns (uint256) {
460         uint256 c = a + b;
461         require(c >= a, "SafeMath: addition overflow");
462         return c;
463     }
464 
465     /**
466      * @dev Returns the subtraction of two unsigned integers, reverting on
467      * overflow (when the result is negative).
468      *
469      * Counterpart to Solidity's `-` operator.
470      *
471      * Requirements:
472      *
473      * - Subtraction cannot overflow.
474      */
475     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
476         require(b <= a, "SafeMath: subtraction overflow");
477         return a - b;
478     }
479 
480     /**
481      * @dev Returns the multiplication of two unsigned integers, reverting on
482      * overflow.
483      *
484      * Counterpart to Solidity's `*` operator.
485      *
486      * Requirements:
487      *
488      * - Multiplication cannot overflow.
489      */
490     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
491         if (a == 0) return 0;
492         uint256 c = a * b;
493         require(c / a == b, "SafeMath: multiplication overflow");
494         return c;
495     }
496 
497     /**
498      * @dev Returns the integer division of two unsigned integers, reverting on
499      * division by zero. The result is rounded towards zero.
500      *
501      * Counterpart to Solidity's `/` operator. Note: this function uses a
502      * `revert` opcode (which leaves remaining gas untouched) while Solidity
503      * uses an invalid opcode to revert (consuming all remaining gas).
504      *
505      * Requirements:
506      *
507      * - The divisor cannot be zero.
508      */
509     function div(uint256 a, uint256 b) internal pure returns (uint256) {
510         require(b > 0, "SafeMath: division by zero");
511         return a / b;
512     }
513 
514     /**
515      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
516      * reverting when dividing by zero.
517      *
518      * Counterpart to Solidity's `%` operator. This function uses a `revert`
519      * opcode (which leaves remaining gas untouched) while Solidity uses an
520      * invalid opcode to revert (consuming all remaining gas).
521      *
522      * Requirements:
523      *
524      * - The divisor cannot be zero.
525      */
526     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
527         require(b > 0, "SafeMath: modulo by zero");
528         return a % b;
529     }
530 
531     /**
532      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
533      * overflow (when the result is negative).
534      *
535      * CAUTION: This function is deprecated because it requires allocating memory for the error
536      * message unnecessarily. For custom revert reasons use {trySub}.
537      *
538      * Counterpart to Solidity's `-` operator.
539      *
540      * Requirements:
541      *
542      * - Subtraction cannot overflow.
543      */
544     function sub(
545         uint256 a,
546         uint256 b,
547         string memory errorMessage
548     ) internal pure returns (uint256) {
549         require(b <= a, errorMessage);
550         return a - b;
551     }
552 
553     /**
554      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
555      * division by zero. The result is rounded towards zero.
556      *
557      * CAUTION: This function is deprecated because it requires allocating memory for the error
558      * message unnecessarily. For custom revert reasons use {tryDiv}.
559      *
560      * Counterpart to Solidity's `/` operator. Note: this function uses a
561      * `revert` opcode (which leaves remaining gas untouched) while Solidity
562      * uses an invalid opcode to revert (consuming all remaining gas).
563      *
564      * Requirements:
565      *
566      * - The divisor cannot be zero.
567      */
568     function div(
569         uint256 a,
570         uint256 b,
571         string memory errorMessage
572     ) internal pure returns (uint256) {
573         require(b > 0, errorMessage);
574         return a / b;
575     }
576 
577     /**
578      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
579      * reverting with custom message when dividing by zero.
580      *
581      * CAUTION: This function is deprecated because it requires allocating memory for the error
582      * message unnecessarily. For custom revert reasons use {tryMod}.
583      *
584      * Counterpart to Solidity's `%` operator. This function uses a `revert`
585      * opcode (which leaves remaining gas untouched) while Solidity uses an
586      * invalid opcode to revert (consuming all remaining gas).
587      *
588      * Requirements:
589      *
590      * - The divisor cannot be zero.
591      */
592     function mod(
593         uint256 a,
594         uint256 b,
595         string memory errorMessage
596     ) internal pure returns (uint256) {
597         require(b > 0, errorMessage);
598         return a % b;
599     }
600 }
601 
602 // File: @openzeppelin/contracts/utils/Address.sol
603 
604 pragma solidity >=0.6.2 <0.8.0;
605 
606 /**
607  * @dev Collection of functions related to the address type
608  */
609 library Address {
610     /**
611      * @dev Returns true if `account` is a contract.
612      *
613      * [IMPORTANT]
614      * ====
615      * It is unsafe to assume that an address for which this function returns
616      * false is an externally-owned account (EOA) and not a contract.
617      *
618      * Among others, `isContract` will return false for the following
619      * types of addresses:
620      *
621      *  - an externally-owned account
622      *  - a contract in construction
623      *  - an address where a contract will be created
624      *  - an address where a contract lived, but was destroyed
625      * ====
626      */
627     function isContract(address account) internal view returns (bool) {
628         // This method relies on extcodesize, which returns 0 for contracts in
629         // construction, since the code is only stored at the end of the
630         // constructor execution.
631 
632         uint256 size;
633         // solhint-disable-next-line no-inline-assembly
634         assembly {
635             size := extcodesize(account)
636         }
637         return size > 0;
638     }
639 
640     /**
641      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
642      * `recipient`, forwarding all available gas and reverting on errors.
643      *
644      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
645      * of certain opcodes, possibly making contracts go over the 2300 gas limit
646      * imposed by `transfer`, making them unable to receive funds via
647      * `transfer`. {sendValue} removes this limitation.
648      *
649      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
650      *
651      * IMPORTANT: because control is transferred to `recipient`, care must be
652      * taken to not create reentrancy vulnerabilities. Consider using
653      * {ReentrancyGuard} or the
654      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
655      */
656     function sendValue(address payable recipient, uint256 amount) internal {
657         require(
658             address(this).balance >= amount,
659             "Address: insufficient balance"
660         );
661 
662         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
663         (bool success, ) = recipient.call{value: amount}("");
664         require(
665             success,
666             "Address: unable to send value, recipient may have reverted"
667         );
668     }
669 
670     /**
671      * @dev Performs a Solidity function call using a low level `call`. A
672      * plain`call` is an unsafe replacement for a function call: use this
673      * function instead.
674      *
675      * If `target` reverts with a revert reason, it is bubbled up by this
676      * function (like regular Solidity function calls).
677      *
678      * Returns the raw returned data. To convert to the expected return value,
679      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
680      *
681      * Requirements:
682      *
683      * - `target` must be a contract.
684      * - calling `target` with `data` must not revert.
685      *
686      * _Available since v3.1._
687      */
688     function functionCall(address target, bytes memory data)
689         internal
690         returns (bytes memory)
691     {
692         return functionCall(target, data, "Address: low-level call failed");
693     }
694 
695     /**
696      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
697      * `errorMessage` as a fallback revert reason when `target` reverts.
698      *
699      * _Available since v3.1._
700      */
701     function functionCall(
702         address target,
703         bytes memory data,
704         string memory errorMessage
705     ) internal returns (bytes memory) {
706         return functionCallWithValue(target, data, 0, errorMessage);
707     }
708 
709     /**
710      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
711      * but also transferring `value` wei to `target`.
712      *
713      * Requirements:
714      *
715      * - the calling contract must have an ETH balance of at least `value`.
716      * - the called Solidity function must be `payable`.
717      *
718      * _Available since v3.1._
719      */
720     function functionCallWithValue(
721         address target,
722         bytes memory data,
723         uint256 value
724     ) internal returns (bytes memory) {
725         return
726             functionCallWithValue(
727                 target,
728                 data,
729                 value,
730                 "Address: low-level call with value failed"
731             );
732     }
733 
734     /**
735      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
736      * with `errorMessage` as a fallback revert reason when `target` reverts.
737      *
738      * _Available since v3.1._
739      */
740     function functionCallWithValue(
741         address target,
742         bytes memory data,
743         uint256 value,
744         string memory errorMessage
745     ) internal returns (bytes memory) {
746         require(
747             address(this).balance >= value,
748             "Address: insufficient balance for call"
749         );
750         require(isContract(target), "Address: call to non-contract");
751 
752         // solhint-disable-next-line avoid-low-level-calls
753         (bool success, bytes memory returndata) = target.call{value: value}(
754             data
755         );
756         return _verifyCallResult(success, returndata, errorMessage);
757     }
758 
759     /**
760      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
761      * but performing a static call.
762      *
763      * _Available since v3.3._
764      */
765     function functionStaticCall(address target, bytes memory data)
766         internal
767         view
768         returns (bytes memory)
769     {
770         return
771             functionStaticCall(
772                 target,
773                 data,
774                 "Address: low-level static call failed"
775             );
776     }
777 
778     /**
779      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
780      * but performing a static call.
781      *
782      * _Available since v3.3._
783      */
784     function functionStaticCall(
785         address target,
786         bytes memory data,
787         string memory errorMessage
788     ) internal view returns (bytes memory) {
789         require(isContract(target), "Address: static call to non-contract");
790 
791         // solhint-disable-next-line avoid-low-level-calls
792         (bool success, bytes memory returndata) = target.staticcall(data);
793         return _verifyCallResult(success, returndata, errorMessage);
794     }
795 
796     /**
797      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
798      * but performing a delegate call.
799      *
800      * _Available since v3.4._
801      */
802     function functionDelegateCall(address target, bytes memory data)
803         internal
804         returns (bytes memory)
805     {
806         return
807             functionDelegateCall(
808                 target,
809                 data,
810                 "Address: low-level delegate call failed"
811             );
812     }
813 
814     /**
815      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
816      * but performing a delegate call.
817      *
818      * _Available since v3.4._
819      */
820     function functionDelegateCall(
821         address target,
822         bytes memory data,
823         string memory errorMessage
824     ) internal returns (bytes memory) {
825         require(isContract(target), "Address: delegate call to non-contract");
826 
827         // solhint-disable-next-line avoid-low-level-calls
828         (bool success, bytes memory returndata) = target.delegatecall(data);
829         return _verifyCallResult(success, returndata, errorMessage);
830     }
831 
832     function _verifyCallResult(
833         bool success,
834         bytes memory returndata,
835         string memory errorMessage
836     ) private pure returns (bytes memory) {
837         if (success) {
838             return returndata;
839         } else {
840             // Look for revert reason and bubble it up if present
841             if (returndata.length > 0) {
842                 // The easiest way to bubble the revert reason is using memory via assembly
843 
844                 // solhint-disable-next-line no-inline-assembly
845                 assembly {
846                     let returndata_size := mload(returndata)
847                     revert(add(32, returndata), returndata_size)
848                 }
849             } else {
850                 revert(errorMessage);
851             }
852         }
853     }
854 }
855 
856 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
857 
858 pragma solidity >=0.6.0 <0.8.0;
859 
860 /**
861  * @dev Library for managing
862  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
863  * types.
864  *
865  * Sets have the following properties:
866  *
867  * - Elements are added, removed, and checked for existence in constant time
868  * (O(1)).
869  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
870  *
871  * ```
872  * contract Example {
873  *     // Add the library methods
874  *     using EnumerableSet for EnumerableSet.AddressSet;
875  *
876  *     // Declare a set state variable
877  *     EnumerableSet.AddressSet private mySet;
878  * }
879  * ```
880  *
881  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
882  * and `uint256` (`UintSet`) are supported.
883  */
884 library EnumerableSet {
885     // To implement this library for multiple types with as little code
886     // repetition as possible, we write it in terms of a generic Set type with
887     // bytes32 values.
888     // The Set implementation uses private functions, and user-facing
889     // implementations (such as AddressSet) are just wrappers around the
890     // underlying Set.
891     // This means that we can only create new EnumerableSets for types that fit
892     // in bytes32.
893 
894     struct Set {
895         // Storage of set values
896         bytes32[] _values;
897         // Position of the value in the `values` array, plus 1 because index 0
898         // means a value is not in the set.
899         mapping(bytes32 => uint256) _indexes;
900     }
901 
902     /**
903      * @dev Add a value to a set. O(1).
904      *
905      * Returns true if the value was added to the set, that is if it was not
906      * already present.
907      */
908     function _add(Set storage set, bytes32 value) private returns (bool) {
909         if (!_contains(set, value)) {
910             set._values.push(value);
911             // The value is stored at length-1, but we add 1 to all indexes
912             // and use 0 as a sentinel value
913             set._indexes[value] = set._values.length;
914             return true;
915         } else {
916             return false;
917         }
918     }
919 
920     /**
921      * @dev Removes a value from a set. O(1).
922      *
923      * Returns true if the value was removed from the set, that is if it was
924      * present.
925      */
926     function _remove(Set storage set, bytes32 value) private returns (bool) {
927         // We read and store the value's index to prevent multiple reads from the same storage slot
928         uint256 valueIndex = set._indexes[value];
929 
930         if (valueIndex != 0) {
931             // Equivalent to contains(set, value)
932             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
933             // the array, and then remove the last element (sometimes called as 'swap and pop').
934             // This modifies the order of the array, as noted in {at}.
935 
936             uint256 toDeleteIndex = valueIndex - 1;
937             uint256 lastIndex = set._values.length - 1;
938 
939             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
940             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
941 
942             bytes32 lastvalue = set._values[lastIndex];
943 
944             // Move the last value to the index where the value to delete is
945             set._values[toDeleteIndex] = lastvalue;
946             // Update the index for the moved value
947             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
948 
949             // Delete the slot where the moved value was stored
950             set._values.pop();
951 
952             // Delete the index for the deleted slot
953             delete set._indexes[value];
954 
955             return true;
956         } else {
957             return false;
958         }
959     }
960 
961     /**
962      * @dev Returns true if the value is in the set. O(1).
963      */
964     function _contains(Set storage set, bytes32 value)
965         private
966         view
967         returns (bool)
968     {
969         return set._indexes[value] != 0;
970     }
971 
972     /**
973      * @dev Returns the number of values on the set. O(1).
974      */
975     function _length(Set storage set) private view returns (uint256) {
976         return set._values.length;
977     }
978 
979     /**
980      * @dev Returns the value stored at position `index` in the set. O(1).
981      *
982      * Note that there are no guarantees on the ordering of values inside the
983      * array, and it may change when more values are added or removed.
984      *
985      * Requirements:
986      *
987      * - `index` must be strictly less than {length}.
988      */
989     function _at(Set storage set, uint256 index)
990         private
991         view
992         returns (bytes32)
993     {
994         require(
995             set._values.length > index,
996             "EnumerableSet: index out of bounds"
997         );
998         return set._values[index];
999     }
1000 
1001     // Bytes32Set
1002 
1003     struct Bytes32Set {
1004         Set _inner;
1005     }
1006 
1007     /**
1008      * @dev Add a value to a set. O(1).
1009      *
1010      * Returns true if the value was added to the set, that is if it was not
1011      * already present.
1012      */
1013     function add(Bytes32Set storage set, bytes32 value)
1014         internal
1015         returns (bool)
1016     {
1017         return _add(set._inner, value);
1018     }
1019 
1020     /**
1021      * @dev Removes a value from a set. O(1).
1022      *
1023      * Returns true if the value was removed from the set, that is if it was
1024      * present.
1025      */
1026     function remove(Bytes32Set storage set, bytes32 value)
1027         internal
1028         returns (bool)
1029     {
1030         return _remove(set._inner, value);
1031     }
1032 
1033     /**
1034      * @dev Returns true if the value is in the set. O(1).
1035      */
1036     function contains(Bytes32Set storage set, bytes32 value)
1037         internal
1038         view
1039         returns (bool)
1040     {
1041         return _contains(set._inner, value);
1042     }
1043 
1044     /**
1045      * @dev Returns the number of values in the set. O(1).
1046      */
1047     function length(Bytes32Set storage set) internal view returns (uint256) {
1048         return _length(set._inner);
1049     }
1050 
1051     /**
1052      * @dev Returns the value stored at position `index` in the set. O(1).
1053      *
1054      * Note that there are no guarantees on the ordering of values inside the
1055      * array, and it may change when more values are added or removed.
1056      *
1057      * Requirements:
1058      *
1059      * - `index` must be strictly less than {length}.
1060      */
1061     function at(Bytes32Set storage set, uint256 index)
1062         internal
1063         view
1064         returns (bytes32)
1065     {
1066         return _at(set._inner, index);
1067     }
1068 
1069     // AddressSet
1070 
1071     struct AddressSet {
1072         Set _inner;
1073     }
1074 
1075     /**
1076      * @dev Add a value to a set. O(1).
1077      *
1078      * Returns true if the value was added to the set, that is if it was not
1079      * already present.
1080      */
1081     function add(AddressSet storage set, address value)
1082         internal
1083         returns (bool)
1084     {
1085         return _add(set._inner, bytes32(uint256(uint160(value))));
1086     }
1087 
1088     /**
1089      * @dev Removes a value from a set. O(1).
1090      *
1091      * Returns true if the value was removed from the set, that is if it was
1092      * present.
1093      */
1094     function remove(AddressSet storage set, address value)
1095         internal
1096         returns (bool)
1097     {
1098         return _remove(set._inner, bytes32(uint256(uint160(value))));
1099     }
1100 
1101     /**
1102      * @dev Returns true if the value is in the set. O(1).
1103      */
1104     function contains(AddressSet storage set, address value)
1105         internal
1106         view
1107         returns (bool)
1108     {
1109         return _contains(set._inner, bytes32(uint256(uint160(value))));
1110     }
1111 
1112     /**
1113      * @dev Returns the number of values in the set. O(1).
1114      */
1115     function length(AddressSet storage set) internal view returns (uint256) {
1116         return _length(set._inner);
1117     }
1118 
1119     /**
1120      * @dev Returns the value stored at position `index` in the set. O(1).
1121      *
1122      * Note that there are no guarantees on the ordering of values inside the
1123      * array, and it may change when more values are added or removed.
1124      *
1125      * Requirements:
1126      *
1127      * - `index` must be strictly less than {length}.
1128      */
1129     function at(AddressSet storage set, uint256 index)
1130         internal
1131         view
1132         returns (address)
1133     {
1134         return address(uint160(uint256(_at(set._inner, index))));
1135     }
1136 
1137     // UintSet
1138 
1139     struct UintSet {
1140         Set _inner;
1141     }
1142 
1143     /**
1144      * @dev Add a value to a set. O(1).
1145      *
1146      * Returns true if the value was added to the set, that is if it was not
1147      * already present.
1148      */
1149     function add(UintSet storage set, uint256 value) internal returns (bool) {
1150         return _add(set._inner, bytes32(value));
1151     }
1152 
1153     /**
1154      * @dev Removes a value from a set. O(1).
1155      *
1156      * Returns true if the value was removed from the set, that is if it was
1157      * present.
1158      */
1159     function remove(UintSet storage set, uint256 value)
1160         internal
1161         returns (bool)
1162     {
1163         return _remove(set._inner, bytes32(value));
1164     }
1165 
1166     /**
1167      * @dev Returns true if the value is in the set. O(1).
1168      */
1169     function contains(UintSet storage set, uint256 value)
1170         internal
1171         view
1172         returns (bool)
1173     {
1174         return _contains(set._inner, bytes32(value));
1175     }
1176 
1177     /**
1178      * @dev Returns the number of values on the set. O(1).
1179      */
1180     function length(UintSet storage set) internal view returns (uint256) {
1181         return _length(set._inner);
1182     }
1183 
1184     /**
1185      * @dev Returns the value stored at position `index` in the set. O(1).
1186      *
1187      * Note that there are no guarantees on the ordering of values inside the
1188      * array, and it may change when more values are added or removed.
1189      *
1190      * Requirements:
1191      *
1192      * - `index` must be strictly less than {length}.
1193      */
1194     function at(UintSet storage set, uint256 index)
1195         internal
1196         view
1197         returns (uint256)
1198     {
1199         return uint256(_at(set._inner, index));
1200     }
1201 }
1202 
1203 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1204 
1205 pragma solidity >=0.6.0 <0.8.0;
1206 
1207 /**
1208  * @dev Library for managing an enumerable variant of Solidity's
1209  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1210  * type.
1211  *
1212  * Maps have the following properties:
1213  *
1214  * - Entries are added, removed, and checked for existence in constant time
1215  * (O(1)).
1216  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1217  *
1218  * ```
1219  * contract Example {
1220  *     // Add the library methods
1221  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1222  *
1223  *     // Declare a set state variable
1224  *     EnumerableMap.UintToAddressMap private myMap;
1225  * }
1226  * ```
1227  *
1228  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1229  * supported.
1230  */
1231 library EnumerableMap {
1232     // To implement this library for multiple types with as little code
1233     // repetition as possible, we write it in terms of a generic Map type with
1234     // bytes32 keys and values.
1235     // The Map implementation uses private functions, and user-facing
1236     // implementations (such as Uint256ToAddressMap) are just wrappers around
1237     // the underlying Map.
1238     // This means that we can only create new EnumerableMaps for types that fit
1239     // in bytes32.
1240 
1241     struct MapEntry {
1242         bytes32 _key;
1243         bytes32 _value;
1244     }
1245 
1246     struct Map {
1247         // Storage of map keys and values
1248         MapEntry[] _entries;
1249         // Position of the entry defined by a key in the `entries` array, plus 1
1250         // because index 0 means a key is not in the map.
1251         mapping(bytes32 => uint256) _indexes;
1252     }
1253 
1254     /**
1255      * @dev Adds a key-value pair to a map, or updates the value for an existing
1256      * key. O(1).
1257      *
1258      * Returns true if the key was added to the map, that is if it was not
1259      * already present.
1260      */
1261     function _set(
1262         Map storage map,
1263         bytes32 key,
1264         bytes32 value
1265     ) private returns (bool) {
1266         // We read and store the key's index to prevent multiple reads from the same storage slot
1267         uint256 keyIndex = map._indexes[key];
1268 
1269         if (keyIndex == 0) {
1270             // Equivalent to !contains(map, key)
1271             map._entries.push(MapEntry({_key: key, _value: value}));
1272             // The entry is stored at length-1, but we add 1 to all indexes
1273             // and use 0 as a sentinel value
1274             map._indexes[key] = map._entries.length;
1275             return true;
1276         } else {
1277             map._entries[keyIndex - 1]._value = value;
1278             return false;
1279         }
1280     }
1281 
1282     /**
1283      * @dev Removes a key-value pair from a map. O(1).
1284      *
1285      * Returns true if the key was removed from the map, that is if it was present.
1286      */
1287     function _remove(Map storage map, bytes32 key) private returns (bool) {
1288         // We read and store the key's index to prevent multiple reads from the same storage slot
1289         uint256 keyIndex = map._indexes[key];
1290 
1291         if (keyIndex != 0) {
1292             // Equivalent to contains(map, key)
1293             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1294             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1295             // This modifies the order of the array, as noted in {at}.
1296 
1297             uint256 toDeleteIndex = keyIndex - 1;
1298             uint256 lastIndex = map._entries.length - 1;
1299 
1300             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1301             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1302 
1303             MapEntry storage lastEntry = map._entries[lastIndex];
1304 
1305             // Move the last entry to the index where the entry to delete is
1306             map._entries[toDeleteIndex] = lastEntry;
1307             // Update the index for the moved entry
1308             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1309 
1310             // Delete the slot where the moved entry was stored
1311             map._entries.pop();
1312 
1313             // Delete the index for the deleted slot
1314             delete map._indexes[key];
1315 
1316             return true;
1317         } else {
1318             return false;
1319         }
1320     }
1321 
1322     /**
1323      * @dev Returns true if the key is in the map. O(1).
1324      */
1325     function _contains(Map storage map, bytes32 key)
1326         private
1327         view
1328         returns (bool)
1329     {
1330         return map._indexes[key] != 0;
1331     }
1332 
1333     /**
1334      * @dev Returns the number of key-value pairs in the map. O(1).
1335      */
1336     function _length(Map storage map) private view returns (uint256) {
1337         return map._entries.length;
1338     }
1339 
1340     /**
1341      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1342      *
1343      * Note that there are no guarantees on the ordering of entries inside the
1344      * array, and it may change when more entries are added or removed.
1345      *
1346      * Requirements:
1347      *
1348      * - `index` must be strictly less than {length}.
1349      */
1350     function _at(Map storage map, uint256 index)
1351         private
1352         view
1353         returns (bytes32, bytes32)
1354     {
1355         require(
1356             map._entries.length > index,
1357             "EnumerableMap: index out of bounds"
1358         );
1359 
1360         MapEntry storage entry = map._entries[index];
1361         return (entry._key, entry._value);
1362     }
1363 
1364     /**
1365      * @dev Tries to returns the value associated with `key`.  O(1).
1366      * Does not revert if `key` is not in the map.
1367      */
1368     function _tryGet(Map storage map, bytes32 key)
1369         private
1370         view
1371         returns (bool, bytes32)
1372     {
1373         uint256 keyIndex = map._indexes[key];
1374         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1375         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1376     }
1377 
1378     /**
1379      * @dev Returns the value associated with `key`.  O(1).
1380      *
1381      * Requirements:
1382      *
1383      * - `key` must be in the map.
1384      */
1385     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1386         uint256 keyIndex = map._indexes[key];
1387         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1388         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1389     }
1390 
1391     /**
1392      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1393      *
1394      * CAUTION: This function is deprecated because it requires allocating memory for the error
1395      * message unnecessarily. For custom revert reasons use {_tryGet}.
1396      */
1397     function _get(
1398         Map storage map,
1399         bytes32 key,
1400         string memory errorMessage
1401     ) private view returns (bytes32) {
1402         uint256 keyIndex = map._indexes[key];
1403         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1404         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1405     }
1406 
1407     // UintToAddressMap
1408 
1409     struct UintToAddressMap {
1410         Map _inner;
1411     }
1412 
1413     /**
1414      * @dev Adds a key-value pair to a map, or updates the value for an existing
1415      * key. O(1).
1416      *
1417      * Returns true if the key was added to the map, that is if it was not
1418      * already present.
1419      */
1420     function set(
1421         UintToAddressMap storage map,
1422         uint256 key,
1423         address value
1424     ) internal returns (bool) {
1425         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1426     }
1427 
1428     /**
1429      * @dev Removes a value from a set. O(1).
1430      *
1431      * Returns true if the key was removed from the map, that is if it was present.
1432      */
1433     function remove(UintToAddressMap storage map, uint256 key)
1434         internal
1435         returns (bool)
1436     {
1437         return _remove(map._inner, bytes32(key));
1438     }
1439 
1440     /**
1441      * @dev Returns true if the key is in the map. O(1).
1442      */
1443     function contains(UintToAddressMap storage map, uint256 key)
1444         internal
1445         view
1446         returns (bool)
1447     {
1448         return _contains(map._inner, bytes32(key));
1449     }
1450 
1451     /**
1452      * @dev Returns the number of elements in the map. O(1).
1453      */
1454     function length(UintToAddressMap storage map)
1455         internal
1456         view
1457         returns (uint256)
1458     {
1459         return _length(map._inner);
1460     }
1461 
1462     /**
1463      * @dev Returns the element stored at position `index` in the set. O(1).
1464      * Note that there are no guarantees on the ordering of values inside the
1465      * array, and it may change when more values are added or removed.
1466      *
1467      * Requirements:
1468      *
1469      * - `index` must be strictly less than {length}.
1470      */
1471     function at(UintToAddressMap storage map, uint256 index)
1472         internal
1473         view
1474         returns (uint256, address)
1475     {
1476         (bytes32 key, bytes32 value) = _at(map._inner, index);
1477         return (uint256(key), address(uint160(uint256(value))));
1478     }
1479 
1480     /**
1481      * @dev Tries to returns the value associated with `key`.  O(1).
1482      * Does not revert if `key` is not in the map.
1483      *
1484      * _Available since v3.4._
1485      */
1486     function tryGet(UintToAddressMap storage map, uint256 key)
1487         internal
1488         view
1489         returns (bool, address)
1490     {
1491         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1492         return (success, address(uint160(uint256(value))));
1493     }
1494 
1495     /**
1496      * @dev Returns the value associated with `key`.  O(1).
1497      *
1498      * Requirements:
1499      *
1500      * - `key` must be in the map.
1501      */
1502     function get(UintToAddressMap storage map, uint256 key)
1503         internal
1504         view
1505         returns (address)
1506     {
1507         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1508     }
1509 
1510     /**
1511      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1512      *
1513      * CAUTION: This function is deprecated because it requires allocating memory for the error
1514      * message unnecessarily. For custom revert reasons use {tryGet}.
1515      */
1516     function get(
1517         UintToAddressMap storage map,
1518         uint256 key,
1519         string memory errorMessage
1520     ) internal view returns (address) {
1521         return
1522             address(
1523                 uint160(uint256(_get(map._inner, bytes32(key), errorMessage)))
1524             );
1525     }
1526 }
1527 
1528 // File: @openzeppelin/contracts/utils/Strings.sol
1529 
1530 pragma solidity >=0.6.0 <0.8.0;
1531 
1532 /**
1533  * @dev String operations.
1534  */
1535 library Strings {
1536     /**
1537      * @dev Converts a `uint256` to its ASCII `string` representation.
1538      */
1539     function toString(uint256 value) internal pure returns (string memory) {
1540         // Inspired by OraclizeAPI's implementation - MIT licence
1541         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1542 
1543         if (value == 0) {
1544             return "0";
1545         }
1546         uint256 temp = value;
1547         uint256 digits;
1548         while (temp != 0) {
1549             digits++;
1550             temp /= 10;
1551         }
1552         bytes memory buffer = new bytes(digits);
1553         uint256 index = digits - 1;
1554         temp = value;
1555         while (temp != 0) {
1556             buffer[index--] = bytes1(uint8(48 + (temp % 10)));
1557             temp /= 10;
1558         }
1559         return string(buffer);
1560     }
1561 }
1562 
1563 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1564 
1565 pragma solidity >=0.6.0 <0.8.0;
1566 
1567 /**
1568  * @title ERC721 Non-Fungible Token Standard basic implementation
1569  * @dev see https://eips.ethereum.org/EIPS/eip-721
1570  */
1571 
1572 contract ERC721 is
1573     Context,
1574     ERC165,
1575     IERC721,
1576     IERC721Metadata,
1577     IERC721Enumerable
1578 {
1579     using SafeMath for uint256;
1580     using Address for address;
1581     using EnumerableSet for EnumerableSet.UintSet;
1582     using EnumerableMap for EnumerableMap.UintToAddressMap;
1583     using Strings for uint256;
1584 
1585     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1586     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1587     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1588 
1589     // Mapping from holder address to their (enumerable) set of owned tokens
1590     mapping(address => EnumerableSet.UintSet) private _holderTokens;
1591 
1592     // Enumerable mapping from token ids to their owners
1593     EnumerableMap.UintToAddressMap private _tokenOwners;
1594 
1595     // Mapping from token ID to approved address
1596     mapping(uint256 => address) private _tokenApprovals;
1597 
1598     // Mapping from owner to operator approvals
1599     mapping(address => mapping(address => bool)) private _operatorApprovals;
1600 
1601     // Token name
1602     string private _name;
1603 
1604     // Token symbol
1605     string private _symbol;
1606 
1607     // Optional mapping for token URIs
1608     mapping(uint256 => string) private _tokenURIs;
1609 
1610     // Base URI
1611     string private _baseURI;
1612 
1613     /*
1614      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1615      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1616      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1617      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1618      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1619      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1620      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1621      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1622      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1623      *
1624      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1625      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1626      */
1627     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1628 
1629     /*
1630      *     bytes4(keccak256('name()')) == 0x06fdde03
1631      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1632      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1633      *
1634      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1635      */
1636     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1637 
1638     /*
1639      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1640      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1641      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1642      *
1643      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1644      */
1645     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1646 
1647     /**
1648      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1649      */
1650     constructor(string memory name_, string memory symbol_) public {
1651         _name = name_;
1652         _symbol = symbol_;
1653 
1654         // register the supported interfaces to conform to ERC721 via ERC165
1655         _registerInterface(_INTERFACE_ID_ERC721);
1656         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1657         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1658     }
1659 
1660     /**
1661      * @dev See {IERC721-balanceOf}.
1662      */
1663     function balanceOf(address owner)
1664         public
1665         view
1666         virtual
1667         override
1668         returns (uint256)
1669     {
1670         require(
1671             owner != address(0),
1672             "ERC721: balance query for the zero address"
1673         );
1674         return _holderTokens[owner].length();
1675     }
1676 
1677     /**
1678      * @dev See {IERC721-ownerOf}.
1679      */
1680     function ownerOf(uint256 tokenId)
1681         public
1682         view
1683         virtual
1684         override
1685         returns (address)
1686     {
1687         return
1688             _tokenOwners.get(
1689                 tokenId,
1690                 "ERC721: owner query for nonexistent token"
1691             );
1692     }
1693 
1694     /**
1695      * @dev See {IERC721Metadata-name}.
1696      */
1697     function name() public view virtual override returns (string memory) {
1698         return _name;
1699     }
1700 
1701     /**
1702      * @dev See {IERC721Metadata-symbol}.
1703      */
1704     function symbol() public view virtual override returns (string memory) {
1705         return _symbol;
1706     }
1707 
1708     /**
1709      * @dev See {IERC721Metadata-tokenURI}.
1710      */
1711     function tokenURI(uint256 tokenId)
1712         public
1713         view
1714         virtual
1715         override
1716         returns (string memory)
1717     {
1718         require(
1719             _exists(tokenId),
1720             "ERC721Metadata: URI query for nonexistent token"
1721         );
1722 
1723         string memory _tokenURI = _tokenURIs[tokenId];
1724         string memory base = baseURI();
1725 
1726         // If there is no base URI, return the token URI.
1727         if (bytes(base).length == 0) {
1728             return _tokenURI;
1729         }
1730         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1731         if (bytes(_tokenURI).length > 0) {
1732             return string(abi.encodePacked(base, _tokenURI));
1733         }
1734         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1735         return string(abi.encodePacked(base, tokenId.toString()));
1736     }
1737 
1738     /**
1739      * @dev Returns the base URI set via {_setBaseURI}. This will be
1740      * automatically added as a prefix in {tokenURI} to each token's URI, or
1741      * to the token ID if no specific URI is set for that token ID.
1742      */
1743     function baseURI() public view virtual returns (string memory) {
1744         return _baseURI;
1745     }
1746 
1747     /**
1748      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1749      */
1750     function tokenOfOwnerByIndex(address owner, uint256 index)
1751         public
1752         view
1753         virtual
1754         override
1755         returns (uint256)
1756     {
1757         return _holderTokens[owner].at(index);
1758     }
1759 
1760     /**
1761      * @dev See {IERC721Enumerable-totalSupply}.
1762      */
1763     function totalSupply() public view virtual override returns (uint256) {
1764         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1765         return _tokenOwners.length();
1766     }
1767 
1768     /**
1769      * @dev See {IERC721Enumerable-tokenByIndex}.
1770      */
1771     function tokenByIndex(uint256 index)
1772         public
1773         view
1774         virtual
1775         override
1776         returns (uint256)
1777     {
1778         (uint256 tokenId, ) = _tokenOwners.at(index);
1779         return tokenId;
1780     }
1781 
1782     /**
1783      * @dev See {IERC721-approve}.
1784      */
1785     function approve(address to, uint256 tokenId) public virtual override {
1786         address owner = ERC721.ownerOf(tokenId);
1787         require(to != owner, "ERC721: approval to current owner");
1788 
1789         require(
1790             _msgSender() == owner ||
1791                 ERC721.isApprovedForAll(owner, _msgSender()),
1792             "ERC721: approve caller is not owner nor approved for all"
1793         );
1794 
1795         _approve(to, tokenId);
1796     }
1797 
1798     /**
1799      * @dev See {IERC721-getApproved}.
1800      */
1801     function getApproved(uint256 tokenId)
1802         public
1803         view
1804         virtual
1805         override
1806         returns (address)
1807     {
1808         require(
1809             _exists(tokenId),
1810             "ERC721: approved query for nonexistent token"
1811         );
1812 
1813         return _tokenApprovals[tokenId];
1814     }
1815 
1816     /**
1817      * @dev See {IERC721-setApprovalForAll}.
1818      */
1819     function setApprovalForAll(address operator, bool approved)
1820         public
1821         virtual
1822         override
1823     {
1824         require(operator != _msgSender(), "ERC721: approve to caller");
1825 
1826         _operatorApprovals[_msgSender()][operator] = approved;
1827         emit ApprovalForAll(_msgSender(), operator, approved);
1828     }
1829 
1830     /**
1831      * @dev See {IERC721-isApprovedForAll}.
1832      */
1833     function isApprovedForAll(address owner, address operator)
1834         public
1835         view
1836         virtual
1837         override
1838         returns (bool)
1839     {
1840         return _operatorApprovals[owner][operator];
1841     }
1842 
1843     /**
1844      * @dev See {IERC721-transferFrom}.
1845      */
1846     function transferFrom(
1847         address from,
1848         address to,
1849         uint256 tokenId
1850     ) public virtual override {
1851         //solhint-disable-next-line max-line-length
1852         require(
1853             _isApprovedOrOwner(_msgSender(), tokenId),
1854             "ERC721: transfer caller is not owner nor approved"
1855         );
1856 
1857         _transfer(from, to, tokenId);
1858     }
1859 
1860     /**
1861      * @dev See {IERC721-safeTransferFrom}.
1862      */
1863     function safeTransferFrom(
1864         address from,
1865         address to,
1866         uint256 tokenId
1867     ) public virtual override {
1868         safeTransferFrom(from, to, tokenId, "");
1869     }
1870 
1871     /**
1872      * @dev See {IERC721-safeTransferFrom}.
1873      */
1874     function safeTransferFrom(
1875         address from,
1876         address to,
1877         uint256 tokenId,
1878         bytes memory _data
1879     ) public virtual override {
1880         require(
1881             _isApprovedOrOwner(_msgSender(), tokenId),
1882             "ERC721: transfer caller is not owner nor approved"
1883         );
1884         _safeTransfer(from, to, tokenId, _data);
1885     }
1886 
1887     /**
1888      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1889      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1890      *
1891      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1892      *
1893      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1894      * implement alternative mechanisms to perform token transfer, such as signature-based.
1895      *
1896      * Requirements:
1897      *
1898      * - `from` cannot be the zero address.
1899      * - `to` cannot be the zero address.
1900      * - `tokenId` token must exist and be owned by `from`.
1901      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1902      *
1903      * Emits a {Transfer} event.
1904      */
1905     function _safeTransfer(
1906         address from,
1907         address to,
1908         uint256 tokenId,
1909         bytes memory _data
1910     ) internal virtual {
1911         _transfer(from, to, tokenId);
1912         require(
1913             _checkOnERC721Received(from, to, tokenId, _data),
1914             "ERC721: transfer to non ERC721Receiver implementer"
1915         );
1916     }
1917 
1918     /**
1919      * @dev Returns whether `tokenId` exists.
1920      *
1921      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1922      *
1923      * Tokens start existing when they are minted (`_mint`),
1924      * and stop existing when they are burned (`_burn`).
1925      */
1926     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1927         return _tokenOwners.contains(tokenId);
1928     }
1929 
1930     /**
1931      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1932      *
1933      * Requirements:
1934      *
1935      * - `tokenId` must exist.
1936      */
1937     function _isApprovedOrOwner(address spender, uint256 tokenId)
1938         internal
1939         view
1940         virtual
1941         returns (bool)
1942     {
1943         require(
1944             _exists(tokenId),
1945             "ERC721: operator query for nonexistent token"
1946         );
1947         address owner = ERC721.ownerOf(tokenId);
1948         return (spender == owner ||
1949             getApproved(tokenId) == spender ||
1950             ERC721.isApprovedForAll(owner, spender));
1951     }
1952 
1953     /**
1954      * @dev Safely mints `tokenId` and transfers it to `to`.
1955      *
1956      * Requirements:
1957      d*
1958      * - `tokenId` must not exist.
1959      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1960      *
1961      * Emits a {Transfer} event.
1962      */
1963     function _safeMint(address to, uint256 tokenId) internal virtual {
1964         _safeMint(to, tokenId, "");
1965     }
1966 
1967     /**
1968      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1969      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1970      */
1971     function _safeMint(
1972         address to,
1973         uint256 tokenId,
1974         bytes memory _data
1975     ) internal virtual {
1976         _mint(to, tokenId);
1977         require(
1978             _checkOnERC721Received(address(0), to, tokenId, _data),
1979             "ERC721: transfer to non ERC721Receiver implementer"
1980         );
1981     }
1982 
1983     /**
1984      * @dev Mints `tokenId` and transfers it to `to`.
1985      *
1986      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1987      *
1988      * Requirements:
1989      *
1990      * - `tokenId` must not exist.
1991      * - `to` cannot be the zero address.
1992      *
1993      * Emits a {Transfer} event.
1994      */
1995     function _mint(address to, uint256 tokenId) internal virtual {
1996         require(to != address(0), "ERC721: mint to the zero address");
1997         require(!_exists(tokenId), "ERC721: token already minted");
1998 
1999         _beforeTokenTransfer(address(0), to, tokenId);
2000 
2001         _holderTokens[to].add(tokenId);
2002 
2003         _tokenOwners.set(tokenId, to);
2004 
2005         emit Transfer(address(0), to, tokenId);
2006     }
2007 
2008     /**
2009      * @dev Destroys `tokenId`.
2010      * The approval is cleared when the token is burned.
2011      *
2012      * Requirements:
2013      *
2014      * - `tokenId` must exist.
2015      *
2016      * Emits a {Transfer} event.
2017      */
2018     function _burn(uint256 tokenId) internal virtual {
2019         address owner = ERC721.ownerOf(tokenId); // internal owner
2020 
2021         _beforeTokenTransfer(owner, address(0), tokenId);
2022 
2023         // Clear approvals
2024         _approve(address(0), tokenId);
2025 
2026         // Clear metadata (if any)
2027         if (bytes(_tokenURIs[tokenId]).length != 0) {
2028             delete _tokenURIs[tokenId];
2029         }
2030 
2031         _holderTokens[owner].remove(tokenId);
2032 
2033         _tokenOwners.remove(tokenId);
2034 
2035         emit Transfer(owner, address(0), tokenId);
2036     }
2037 
2038     /**
2039      * @dev Transfers `tokenId` from `from` to `to`.
2040      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2041      *
2042      * Requirements:
2043      *
2044      * - `to` cannot be the zero address.
2045      * - `tokenId` token must be owned by `from`.
2046      *
2047      * Emits a {Transfer} event.
2048      */
2049     function _transfer(
2050         address from,
2051         address to,
2052         uint256 tokenId
2053     ) internal virtual {
2054         require(
2055             ERC721.ownerOf(tokenId) == from,
2056             "ERC721: transfer of token that is not own"
2057         ); // internal owner
2058         require(to != address(0), "ERC721: transfer to the zero address");
2059 
2060         _beforeTokenTransfer(from, to, tokenId);
2061 
2062         // Clear approvals from the previous owner
2063         _approve(address(0), tokenId);
2064 
2065         _holderTokens[from].remove(tokenId);
2066         _holderTokens[to].add(tokenId);
2067 
2068         _tokenOwners.set(tokenId, to);
2069 
2070         emit Transfer(from, to, tokenId);
2071     }
2072 
2073     /**
2074      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
2075      *
2076      * Requirements:
2077      *
2078      * - `tokenId` must exist.
2079      */
2080     function _setTokenURI(uint256 tokenId, string memory _tokenURI)
2081         internal
2082         virtual
2083     {
2084         require(
2085             _exists(tokenId),
2086             "ERC721Metadata: URI set of nonexistent token"
2087         );
2088         _tokenURIs[tokenId] = _tokenURI;
2089     }
2090 
2091     /**
2092      * @dev Internal function to set the base URI for all token IDs. It is
2093      * automatically added as a prefix to the value returned in {tokenURI},
2094      * or to the token ID if {tokenURI} is empty.
2095      */
2096     function _setBaseURI(string memory baseURI_) internal virtual {
2097         _baseURI = baseURI_;
2098     }
2099 
2100     /**
2101      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2102      * The call is not executed if the target address is not a contract.
2103      *
2104      * @param from address representing the previous owner of the given token ID
2105      * @param to target address that will receive the tokens
2106      * @param tokenId uint256 ID of the token to be transferred
2107      * @param _data bytes optional data to send along with the call
2108      * @return bool whether the call correctly returned the expected magic value
2109      */
2110     function _checkOnERC721Received(
2111         address from,
2112         address to,
2113         uint256 tokenId,
2114         bytes memory _data
2115     ) private returns (bool) {
2116         if (!to.isContract()) {
2117             return true;
2118         }
2119         bytes memory returndata = to.functionCall(
2120             abi.encodeWithSelector(
2121                 IERC721Receiver(to).onERC721Received.selector,
2122                 _msgSender(),
2123                 from,
2124                 tokenId,
2125                 _data
2126             ),
2127             "ERC721: transfer to non ERC721Receiver implementer"
2128         );
2129         bytes4 retval = abi.decode(returndata, (bytes4));
2130         return (retval == _ERC721_RECEIVED);
2131     }
2132 
2133     /**
2134      * @dev Approve `to` to operate on `tokenId`
2135      *
2136      * Emits an {Approval} event.
2137      */
2138     function _approve(address to, uint256 tokenId) internal virtual {
2139         _tokenApprovals[tokenId] = to;
2140         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
2141     }
2142 
2143     /**
2144      * @dev Hook that is called before any token transfer. This includes minting
2145      * and burning.
2146      *
2147      * Calling conditions:
2148      *
2149      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2150      * transferred to `to`.
2151      * - When `from` is zero, `tokenId` will be minted for `to`.
2152      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2153      * - `from` cannot be the zero address.
2154      * - `to` cannot be the zero address.
2155      *
2156      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2157      */
2158     function _beforeTokenTransfer(
2159         address from,
2160         address to,
2161         uint256 tokenId
2162     ) internal virtual {}
2163 }
2164 
2165 // File: @openzeppelin/contracts/access/Ownable.sol
2166 
2167 pragma solidity >=0.6.0 <0.8.0;
2168 
2169 /**
2170  * @dev Contract module which provides a basic access control mechanism, where
2171  * there is an account (an owner) that can be granted exclusive access to
2172  * specific functions.
2173  *
2174  * By default, the owner account will be the one that deploys the contract. This
2175  * can later be changed with {transferOwnership}.
2176  *
2177  * This module is used through inheritance. It will make available the modifier
2178  * `onlyOwner`, which can be applied to your functions to restrict their use to
2179  * the owner.
2180  */
2181 abstract contract Ownable is Context {
2182     address private _owner;
2183 
2184     event OwnershipTransferred(
2185         address indexed previousOwner,
2186         address indexed newOwner
2187     );
2188 
2189     /**
2190      * @dev Initializes the contract setting the deployer as the initial owner.
2191      */
2192     constructor() internal {
2193         address msgSender = _msgSender();
2194         _owner = msgSender;
2195         emit OwnershipTransferred(address(0), msgSender);
2196     }
2197 
2198     /**
2199      * @dev Returns the address of the current owner.
2200      */
2201     function owner() public view virtual returns (address) {
2202         return _owner;
2203     }
2204 
2205     /**
2206      * @dev Throws if called by any account other than the owner.
2207      */
2208     modifier onlyOwner() {
2209         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2210         _;
2211     }
2212 
2213     /**
2214      * @dev Leaves the contract without owner. It will not be possible to call
2215      * `onlyOwner` functions anymore. Can only be called by the current owner.
2216      *
2217      * NOTE: Renouncing ownership will leave the contract without an owner,
2218      * thereby removing any functionality that is only available to the owner.
2219      */
2220     function renounceOwnership() public virtual onlyOwner {
2221         emit OwnershipTransferred(_owner, address(0));
2222         _owner = address(0);
2223     }
2224 
2225     /**
2226      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2227      * Can only be called by the current owner.
2228      */
2229     function transferOwnership(address newOwner) public virtual onlyOwner {
2230         require(
2231             newOwner != address(0),
2232             "Ownable: new owner is the zero address"
2233         );
2234         emit OwnershipTransferred(_owner, newOwner);
2235         _owner = newOwner;
2236     }
2237 }
2238 
2239 
2240 pragma solidity ^0.7.0;
2241 pragma abicoder v2;
2242 
2243 contract PloddingPirates is ERC721, Ownable {
2244     using SafeMath for uint256;
2245 
2246     string public Pirate_Provenance = ""; 
2247     string public LICENSE_TEXT = "";
2248     bool licenseLocked = false;
2249     uint256 public PiratePrice = 25000000000000000; // 0.025 ETH
2250     uint256 public constant maxPiratePurchase = 30;
2251     uint256 public constant MAX_PIRATES = 10000;
2252     bool public saleIsActive = false;
2253     uint256 public PirateReserve = 100; // Reserve 100 Pirates for team & community (Used in giveaways, events etc...) 
2254     event licenseisLocked(string _licenseText);
2255 
2256 
2257     constructor() ERC721("Plodding Pirates", "PPS") {
2258  
2259     }
2260     
2261         
2262         
2263        function withdraw() external {
2264         require(
2265                 msg.sender == 0xe1Dad4ae4BFD1d53D234303655bfc44982D46353 ||
2266                 msg.sender == 0x672c36FA22029369490BB5e33e6d16a7E1309c1e ||
2267                 msg.sender == 0x59cE6Be860F8E0A4d8880a0AE39Bd0bc63B82672 
2268         );
2269 
2270         uint256 bal = address(this).balance;
2271 
2272         uint256 FortyFive = bal.mul(45).div(100);
2273         payable(address(0xe1Dad4ae4BFD1d53D234303655bfc44982D46353)).call{
2274             value: FortyFive
2275         }("");
2276 
2277         uint256 FortyFive1 = bal.mul(45).div(100);
2278         payable(address(0x672c36FA22029369490BB5e33e6d16a7E1309c1e)).call{
2279             value: FortyFive1
2280         }("");
2281 
2282         uint256 Ten = bal.mul(10).div(100);
2283         payable(address(0x59cE6Be860F8E0A4d8880a0AE39Bd0bc63B82672)).call{
2284             value: Ten
2285         }("");
2286     }
2287 
2288     function emergencyWithdraw() external onlyOwner {
2289         require(msg.sender == 0xe1Dad4ae4BFD1d53D234303655bfc44982D46353);
2290         (bool success, ) = payable(0xe1Dad4ae4BFD1d53D234303655bfc44982D46353)
2291             .call{value: address(this).balance}("");
2292         require(success);
2293     }
2294 
2295     function reservePirates(address _to, uint256 _reserveAmount)
2296         public
2297         onlyOwner
2298     {
2299         uint256 supply = totalSupply();
2300         require(
2301             _reserveAmount > 0 && _reserveAmount <= PirateReserve,
2302             "Not enough reserve left for team"
2303         );
2304         for (uint256 i = 0; i < _reserveAmount; i++) {
2305             _safeMint(_to, supply + i);
2306         }
2307         PirateReserve = PirateReserve.sub(_reserveAmount);
2308     }
2309 
2310     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
2311         Pirate_Provenance = provenanceHash;
2312     }
2313 
2314     function setBaseURI(string memory baseURI) public onlyOwner {
2315         _setBaseURI(baseURI);
2316     }
2317 
2318     function flipSaleState() public onlyOwner {
2319         saleIsActive = !saleIsActive;
2320     }
2321 
2322     function tokensOfOwner(address _owner)
2323         external
2324         view
2325         returns (uint256[] memory)
2326     {
2327         uint256 tokenCount = balanceOf(_owner);
2328         if (tokenCount == 0) {
2329             // Return an empty array
2330             return new uint256[](0);
2331         } else {
2332             uint256[] memory result = new uint256[](tokenCount);
2333             uint256 index;
2334             for (index = 0; index < tokenCount; index++) {
2335                 result[index] = tokenOfOwnerByIndex(_owner, index);
2336             }
2337             return result;
2338         }
2339     }
2340 
2341 
2342     
2343     // Returns the license for tokens
2344     function tokenLicense(uint256 _id) public view returns (string memory) {
2345         require(_id < totalSupply(), "CHOOSE A PIRATE WITHIN RANGE");
2346         return LICENSE_TEXT;
2347     }
2348 
2349     // Locks the license to prevent further changes
2350     function lockLicense() public onlyOwner {
2351         licenseLocked = true;
2352         emit licenseisLocked(LICENSE_TEXT);
2353     }
2354 
2355     // Change the license
2356     function changeLicense(string memory _license) public onlyOwner {
2357         require(licenseLocked == false, "License already locked");
2358         LICENSE_TEXT = _license;
2359     }
2360     
2361 
2362     function mintPirate(uint256 numberOfTokens) public payable {
2363         require(saleIsActive, "Sale must be active to mint a Pirate");
2364         require(
2365             numberOfTokens > 0 && numberOfTokens <= maxPiratePurchase,
2366             "Can only mint 30 tokens at a time"
2367         );
2368         require(
2369             totalSupply().add(numberOfTokens) <= MAX_PIRATES,
2370             "Purchase would exceed max supply of Pirates"
2371         );
2372         require(
2373             msg.value >= PiratePrice.mul(numberOfTokens),
2374             "Ether value sent is not correct"
2375         );
2376 
2377         for (uint256 i = 0; i < numberOfTokens; i++) {
2378             uint256 mintIndex = totalSupply();
2379             if (totalSupply() < MAX_PIRATES) {
2380                 _safeMint(msg.sender, mintIndex);
2381             }
2382         }
2383     }
2384 
2385     function setPiratePrice(uint256 newPrice) public onlyOwner {
2386         PiratePrice = newPrice;
2387     }
2388     receive() external payable {}
2389 }