1 // SPDX-License-Identifier: MIT
2 
3 
4 //┏━━━┳━━━┳━┓┏━┳━━┓┏━━━┳┓┏┓┏┳━━━┳┓╋╋┏━━━┳┓╋┏┳━━━┓
5 //┃┏━┓┃┏━┓┃┃┗┛┃┃┏┓┃┃┏━┓┃┃┃┃┃┃┏━┓┃┃╋╋┃┏━┓┃┃╋┃┣┓┏┓┃
6 //┃┗━┛┃┃╋┃┃┏┓┏┓┃┗┛┗┫┃╋┃┃┃┃┃┃┃┃╋┗┫┃╋╋┃┃╋┃┃┃╋┃┃┃┃┃┃
7 //┃┏┓┏┫┗━┛┃┃┃┃┃┃┏━┓┃┃╋┃┃┗┛┗┛┃┃╋┏┫┃╋┏┫┃╋┃┃┃╋┃┃┃┃┃┃
8 //┃┃┃┗┫┏━┓┃┃┃┃┃┃┗━┛┃┗━┛┣┓┏┓┏┫┗━┛┃┗━┛┃┗━┛┃┗━┛┣┛┗┛┃
9 //┗┛┗━┻┛╋┗┻┛┗┛┗┻━━━┻━━━┛┗┛┗┛┗━━━┻━━━┻━━━┻━━━┻━━━┛
10 // RAMBOWcloud NFTs
11 //Compiled with 0.8.7
12 pragma solidity ^0.8.0;
13 
14 // File: @openzeppelin/contracts/utils/Context.sol
15 
16 /*
17  * @dev Provides information about the current execution context, including the
18  * sender of the transaction and its data. While these are generally available
19  * via msg.sender and msg.data, they should not be accessed in such a direct
20  * manner, since when dealing with meta-transactions the account sending and
21  * paying for execution may not be the actual sender (as far as an application
22  * is concerned).
23  *
24  * This contract is only required for intermediate, library-like contracts.
25  */
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes calldata) {
32         this;
33         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
34         return msg.data;
35     }
36 }
37 
38 // File: @openzeppelin/contracts/introspection/IERC165.sol
39 
40 /**
41  * @dev Interface of the ERC165 standard, as defined in the
42  * https://eips.ethereum.org/EIPS/eip-165[EIP].
43  *
44  * Implementers can declare support of contract interfaces, which can then be
45  * queried by others ({ERC165Checker}).
46  *
47  * For an implementation, see {ERC165}.
48  */
49 interface IERC165 {
50     /**
51      * @dev Returns true if this contract implements the interface defined by
52      * `interfaceId`. See the corresponding
53      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
54      * to learn more about how these ids are created.
55      *
56      * This function call must use less than 30 000 gas.
57      */
58     function supportsInterface(bytes4 interfaceId) external view returns (bool);
59 }
60 
61 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
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
296 /**
297  * @dev Implementation of the {IERC165} interface.
298  *
299  * Contracts may inherit from this and call {_registerInterface} to declare
300  * their support of an interface.
301  */
302 abstract contract ERC165 is IERC165 {
303     /*
304      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
305      */
306     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
307 
308     /**
309      * @dev Mapping of interface ids to whether or not it's supported.
310      */
311     mapping(bytes4 => bool) private _supportedInterfaces;
312 
313     constructor() {
314         // Derived contracts need only register support for their own interfaces,
315         // we register support for ERC165 itself here
316         _registerInterface(_INTERFACE_ID_ERC165);
317     }
318 
319     /**
320      * @dev See {IERC165-supportsInterface}.
321      *
322      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
323      */
324     function supportsInterface(bytes4 interfaceId)
325         public
326         view
327         virtual
328         override
329         returns (bool)
330     {
331         return _supportedInterfaces[interfaceId];
332     }
333 
334     /**
335      * @dev Registers the contract as an implementer of the interface defined by
336      * `interfaceId`. Support of the actual ERC165 interface is automatic and
337      * registering its interface id is not required.
338      *
339      * See {IERC165-supportsInterface}.
340      *
341      * Requirements:
342      *
343      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
344      */
345     function _registerInterface(bytes4 interfaceId) internal virtual {
346         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
347         _supportedInterfaces[interfaceId] = true;
348     }
349 }
350 
351 // File: @openzeppelin/contracts/math/SafeMath.sol
352 
353 /**
354  * @dev Wrappers over Solidity's arithmetic operations with added overflow
355  * checks.
356  *
357  * Arithmetic operations in Solidity wrap on overflow. This can easily result
358  * in bugs, because programmers usually assume that an overflow raises an
359  * error, which is the standard behavior in high level programming languages.
360  * `SafeMath` restores this intuition by reverting the transaction when an
361  * operation overflows.
362  *
363  * Using this library instead of the unchecked operations eliminates an entire
364  * class of bugs, so it's recommended to use it always.
365  */
366 library SafeMath {
367     /**
368      * @dev Returns the addition of two unsigned integers, with an overflow flag.
369      *
370      * _Available since v3.4._
371      */
372     function tryAdd(uint256 a, uint256 b)
373         internal
374         pure
375         returns (bool, uint256)
376     {
377         uint256 c = a + b;
378         if (c < a) return (false, 0);
379         return (true, c);
380     }
381 
382     /**
383      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
384      *
385      * _Available since v3.4._
386      */
387     function trySub(uint256 a, uint256 b)
388         internal
389         pure
390         returns (bool, uint256)
391     {
392         if (b > a) return (false, 0);
393         return (true, a - b);
394     }
395 
396     /**
397      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
398      *
399      * _Available since v3.4._
400      */
401     function tryMul(uint256 a, uint256 b)
402         internal
403         pure
404         returns (bool, uint256)
405     {
406         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
407         // benefit is lost if 'b' is also tested.
408         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
409         if (a == 0) return (true, 0);
410         uint256 c = a * b;
411         if (c / a != b) return (false, 0);
412         return (true, c);
413     }
414 
415     /**
416      * @dev Returns the division of two unsigned integers, with a division by zero flag.
417      *
418      * _Available since v3.4._
419      */
420     function tryDiv(uint256 a, uint256 b)
421         internal
422         pure
423         returns (bool, uint256)
424     {
425         if (b == 0) return (false, 0);
426         return (true, a / b);
427     }
428 
429     /**
430      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
431      *
432      * _Available since v3.4._
433      */
434     function tryMod(uint256 a, uint256 b)
435         internal
436         pure
437         returns (bool, uint256)
438     {
439         if (b == 0) return (false, 0);
440         return (true, a % b);
441     }
442 
443     /**
444      * @dev Returns the addition of two unsigned integers, reverting on
445      * overflow.
446      *
447      * Counterpart to Solidity's `+` operator.
448      *
449      * Requirements:
450      *
451      * - Addition cannot overflow.
452      */
453     function add(uint256 a, uint256 b) internal pure returns (uint256) {
454         uint256 c = a + b;
455         require(c >= a, "SafeMath: addition overflow");
456         return c;
457     }
458 
459     /**
460      * @dev Returns the subtraction of two unsigned integers, reverting on
461      * overflow (when the result is negative).
462      *
463      * Counterpart to Solidity's `-` operator.
464      *
465      * Requirements:
466      *
467      * - Subtraction cannot overflow.
468      */
469     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
470         require(b <= a, "SafeMath: subtraction overflow");
471         return a - b;
472     }
473 
474     /**
475      * @dev Returns the multiplication of two unsigned integers, reverting on
476      * overflow.
477      *
478      * Counterpart to Solidity's `*` operator.
479      *
480      * Requirements:
481      *
482      * - Multiplication cannot overflow.
483      */
484     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
485         if (a == 0) return 0;
486         uint256 c = a * b;
487         require(c / a == b, "SafeMath: multiplication overflow");
488         return c;
489     }
490 
491     /**
492      * @dev Returns the integer division of two unsigned integers, reverting on
493      * division by zero. The result is rounded towards zero.
494      *
495      * Counterpart to Solidity's `/` operator. Note: this function uses a
496      * `revert` opcode (which leaves remaining gas untouched) while Solidity
497      * uses an invalid opcode to revert (consuming all remaining gas).
498      *
499      * Requirements:
500      *
501      * - The divisor cannot be zero.
502      */
503     function div(uint256 a, uint256 b) internal pure returns (uint256) {
504         require(b > 0, "SafeMath: division by zero");
505         return a / b;
506     }
507 
508     /**
509      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
510      * reverting when dividing by zero.
511      *
512      * Counterpart to Solidity's `%` operator. This function uses a `revert`
513      * opcode (which leaves remaining gas untouched) while Solidity uses an
514      * invalid opcode to revert (consuming all remaining gas).
515      *
516      * Requirements:
517      *
518      * - The divisor cannot be zero.
519      */
520     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
521         require(b > 0, "SafeMath: modulo by zero");
522         return a % b;
523     }
524 
525     /**
526      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
527      * overflow (when the result is negative).
528      *
529      * CAUTION: This function is deprecated because it requires allocating memory for the error
530      * message unnecessarily. For custom revert reasons use {trySub}.
531      *
532      * Counterpart to Solidity's `-` operator.
533      *
534      * Requirements:
535      *
536      * - Subtraction cannot overflow.
537      */
538     function sub(
539         uint256 a,
540         uint256 b,
541         string memory errorMessage
542     ) internal pure returns (uint256) {
543         require(b <= a, errorMessage);
544         return a - b;
545     }
546 
547     /**
548      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
549      * division by zero. The result is rounded towards zero.
550      *
551      * CAUTION: This function is deprecated because it requires allocating memory for the error
552      * message unnecessarily. For custom revert reasons use {tryDiv}.
553      *
554      * Counterpart to Solidity's `/` operator. Note: this function uses a
555      * `revert` opcode (which leaves remaining gas untouched) while Solidity
556      * uses an invalid opcode to revert (consuming all remaining gas).
557      *
558      * Requirements:
559      *
560      * - The divisor cannot be zero.
561      */
562     function div(
563         uint256 a,
564         uint256 b,
565         string memory errorMessage
566     ) internal pure returns (uint256) {
567         require(b > 0, errorMessage);
568         return a / b;
569     }
570 
571     /**
572      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
573      * reverting with custom message when dividing by zero.
574      *
575      * CAUTION: This function is deprecated because it requires allocating memory for the error
576      * message unnecessarily. For custom revert reasons use {tryMod}.
577      *
578      * Counterpart to Solidity's `%` operator. This function uses a `revert`
579      * opcode (which leaves remaining gas untouched) while Solidity uses an
580      * invalid opcode to revert (consuming all remaining gas).
581      *
582      * Requirements:
583      *
584      * - The divisor cannot be zero.
585      */
586     function mod(
587         uint256 a,
588         uint256 b,
589         string memory errorMessage
590     ) internal pure returns (uint256) {
591         require(b > 0, errorMessage);
592         return a % b;
593     }
594 }
595 
596 // File: @openzeppelin/contracts/utils/Address.sol
597 
598 /**
599  * @dev Collection of functions related to the address type
600  */
601 library Address {
602     /**
603      * @dev Returns true if `account` is a contract.
604      *
605      * [IMPORTANT]
606      * ====
607      * It is unsafe to assume that an address for which this function returns
608      * false is an externally-owned account (EOA) and not a contract.
609      *
610      * Among others, `isContract` will return false for the following
611      * types of addresses:
612      *
613      *  - an externally-owned account
614      *  - a contract in construction
615      *  - an address where a contract will be created
616      *  - an address where a contract lived, but was destroyed
617      * ====
618      */
619     function isContract(address account) internal view returns (bool) {
620         // This method relies on extcodesize, which returns 0 for contracts in
621         // construction, since the code is only stored at the end of the
622         // constructor execution.
623 
624         uint256 size;
625         // solhint-disable-next-line no-inline-assembly
626         assembly {
627             size := extcodesize(account)
628         }
629         return size > 0;
630     }
631 
632     /**
633      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
634      * `recipient`, forwarding all available gas and reverting on errors.
635      *
636      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
637      * of certain opcodes, possibly making contracts go over the 2300 gas limit
638      * imposed by `transfer`, making them unable to receive funds via
639      * `transfer`. {sendValue} removes this limitation.
640      *
641      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
642      *
643      * IMPORTANT: because control is transferred to `recipient`, care must be
644      * taken to not create reentrancy vulnerabilities. Consider using
645      * {ReentrancyGuard} or the
646      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
647      */
648     function sendValue(address payable recipient, uint256 amount) internal {
649         require(
650             address(this).balance >= amount,
651             "Address: insufficient balance"
652         );
653 
654         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
655         (bool success, ) = recipient.call{value: amount}("");
656         require(
657             success,
658             "Address: unable to send value, recipient may have reverted"
659         );
660     }
661 
662     /**
663      * @dev Performs a Solidity function call using a low level `call`. A
664      * plain`call` is an unsafe replacement for a function call: use this
665      * function instead.
666      *
667      * If `target` reverts with a revert reason, it is bubbled up by this
668      * function (like regular Solidity function calls).
669      *
670      * Returns the raw returned data. To convert to the expected return value,
671      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
672      *
673      * Requirements:
674      *
675      * - `target` must be a contract.
676      * - calling `target` with `data` must not revert.
677      *
678      * _Available since v3.1._
679      */
680     function functionCall(address target, bytes memory data)
681         internal
682         returns (bytes memory)
683     {
684         return functionCall(target, data, "Address: low-level call failed");
685     }
686 
687     /**
688      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
689      * `errorMessage` as a fallback revert reason when `target` reverts.
690      *
691      * _Available since v3.1._
692      */
693     function functionCall(
694         address target,
695         bytes memory data,
696         string memory errorMessage
697     ) internal returns (bytes memory) {
698         return functionCallWithValue(target, data, 0, errorMessage);
699     }
700 
701     /**
702      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
703      * but also transferring `value` wei to `target`.
704      *
705      * Requirements:
706      *
707      * - the calling contract must have an ETH balance of at least `value`.
708      * - the called Solidity function must be `payable`.
709      *
710      * _Available since v3.1._
711      */
712     function functionCallWithValue(
713         address target,
714         bytes memory data,
715         uint256 value
716     ) internal returns (bytes memory) {
717         return
718             functionCallWithValue(
719                 target,
720                 data,
721                 value,
722                 "Address: low-level call with value failed"
723             );
724     }
725 
726     /**
727      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
728      * with `errorMessage` as a fallback revert reason when `target` reverts.
729      *
730      * _Available since v3.1._
731      */
732     function functionCallWithValue(
733         address target,
734         bytes memory data,
735         uint256 value,
736         string memory errorMessage
737     ) internal returns (bytes memory) {
738         require(
739             address(this).balance >= value,
740             "Address: insufficient balance for call"
741         );
742         require(isContract(target), "Address: call to non-contract");
743 
744         // solhint-disable-next-line avoid-low-level-calls
745         (bool success, bytes memory returndata) = target.call{value: value}(
746             data
747         );
748         return _verifyCallResult(success, returndata, errorMessage);
749     }
750 
751     /**
752      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
753      * but performing a static call.
754      *
755      * _Available since v3.3._
756      */
757     function functionStaticCall(address target, bytes memory data)
758         internal
759         view
760         returns (bytes memory)
761     {
762         return
763             functionStaticCall(
764                 target,
765                 data,
766                 "Address: low-level static call failed"
767             );
768     }
769 
770     /**
771      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
772      * but performing a static call.
773      *
774      * _Available since v3.3._
775      */
776     function functionStaticCall(
777         address target,
778         bytes memory data,
779         string memory errorMessage
780     ) internal view returns (bytes memory) {
781         require(isContract(target), "Address: static call to non-contract");
782 
783         // solhint-disable-next-line avoid-low-level-calls
784         (bool success, bytes memory returndata) = target.staticcall(data);
785         return _verifyCallResult(success, returndata, errorMessage);
786     }
787 
788     /**
789      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
790      * but performing a delegate call.
791      *
792      * _Available since v3.4._
793      */
794     function functionDelegateCall(address target, bytes memory data)
795         internal
796         returns (bytes memory)
797     {
798         return
799             functionDelegateCall(
800                 target,
801                 data,
802                 "Address: low-level delegate call failed"
803             );
804     }
805 
806     /**
807      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
808      * but performing a delegate call.
809      *
810      * _Available since v3.4._
811      */
812     function functionDelegateCall(
813         address target,
814         bytes memory data,
815         string memory errorMessage
816     ) internal returns (bytes memory) {
817         require(isContract(target), "Address: delegate call to non-contract");
818 
819         // solhint-disable-next-line avoid-low-level-calls
820         (bool success, bytes memory returndata) = target.delegatecall(data);
821         return _verifyCallResult(success, returndata, errorMessage);
822     }
823 
824     function _verifyCallResult(
825         bool success,
826         bytes memory returndata,
827         string memory errorMessage
828     ) private pure returns (bytes memory) {
829         if (success) {
830             return returndata;
831         } else {
832             // Look for revert reason and bubble it up if present
833             if (returndata.length > 0) {
834                 // The easiest way to bubble the revert reason is using memory via assembly
835 
836                 // solhint-disable-next-line no-inline-assembly
837                 assembly {
838                     let returndata_size := mload(returndata)
839                     revert(add(32, returndata), returndata_size)
840                 }
841             } else {
842                 revert(errorMessage);
843             }
844         }
845     }
846 }
847 
848 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
849 
850 /**
851  * @dev Library for managing
852  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
853  * types.
854  *
855  * Sets have the following properties:
856  *
857  * - Elements are added, removed, and checked for existence in constant time
858  * (O(1)).
859  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
860  *
861  * ```
862  * contract Example {
863  *     // Add the library methods
864  *     using EnumerableSet for EnumerableSet.AddressSet;
865  *
866  *     // Declare a set state variable
867  *     EnumerableSet.AddressSet private mySet;
868  * }
869  * ```
870  *
871  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
872  * and `uint256` (`UintSet`) are supported.
873  */
874 library EnumerableSet {
875     // To implement this library for multiple types with as little code
876     // repetition as possible, we write it in terms of a generic Set type with
877     // bytes32 values.
878     // The Set implementation uses private functions, and user-facing
879     // implementations (such as AddressSet) are just wrappers around the
880     // underlying Set.
881     // This means that we can only create new EnumerableSets for types that fit
882     // in bytes32.
883 
884     struct Set {
885         // Storage of set values
886         bytes32[] _values;
887         // Position of the value in the `values` array, plus 1 because index 0
888         // means a value is not in the set.
889         mapping(bytes32 => uint256) _indexes;
890     }
891 
892     /**
893      * @dev Add a value to a set. O(1).
894      *
895      * Returns true if the value was added to the set, that is if it was not
896      * already present.
897      */
898     function _add(Set storage set, bytes32 value) private returns (bool) {
899         if (!_contains(set, value)) {
900             set._values.push(value);
901             // The value is stored at length-1, but we add 1 to all indexes
902             // and use 0 as a sentinel value
903             set._indexes[value] = set._values.length;
904             return true;
905         } else {
906             return false;
907         }
908     }
909 
910     /**
911      * @dev Removes a value from a set. O(1).
912      *
913      * Returns true if the value was removed from the set, that is if it was
914      * present.
915      */
916     function _remove(Set storage set, bytes32 value) private returns (bool) {
917         // We read and store the value's index to prevent multiple reads from the same storage slot
918         uint256 valueIndex = set._indexes[value];
919 
920         if (valueIndex != 0) {
921             // Equivalent to contains(set, value)
922             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
923             // the array, and then remove the last element (sometimes called as 'swap and pop').
924             // This modifies the order of the array, as noted in {at}.
925 
926             uint256 toDeleteIndex = valueIndex - 1;
927             uint256 lastIndex = set._values.length - 1;
928 
929             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
930             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
931 
932             bytes32 lastvalue = set._values[lastIndex];
933 
934             // Move the last value to the index where the value to delete is
935             set._values[toDeleteIndex] = lastvalue;
936             // Update the index for the moved value
937             set._indexes[lastvalue] = toDeleteIndex + 1;
938             // All indexes are 1-based
939 
940             // Delete the slot where the moved value was stored
941             set._values.pop();
942 
943             // Delete the index for the deleted slot
944             delete set._indexes[value];
945 
946             return true;
947         } else {
948             return false;
949         }
950     }
951 
952     /**
953      * @dev Returns true if the value is in the set. O(1).
954      */
955     function _contains(Set storage set, bytes32 value)
956         private
957         view
958         returns (bool)
959     {
960         return set._indexes[value] != 0;
961     }
962 
963     /**
964      * @dev Returns the number of values on the set. O(1).
965      */
966     function _length(Set storage set) private view returns (uint256) {
967         return set._values.length;
968     }
969 
970     /**
971      * @dev Returns the value stored at position `index` in the set. O(1).
972      *
973      * Note that there are no guarantees on the ordering of values inside the
974      * array, and it may change when more values are added or removed.
975      *
976      * Requirements:
977      *
978      * - `index` must be strictly less than {length}.
979      */
980     function _at(Set storage set, uint256 index)
981         private
982         view
983         returns (bytes32)
984     {
985         require(
986             set._values.length > index,
987             "EnumerableSet: index out of bounds"
988         );
989         return set._values[index];
990     }
991 
992     // Bytes32Set
993 
994     struct Bytes32Set {
995         Set _inner;
996     }
997 
998     /**
999      * @dev Add a value to a set. O(1).
1000      *
1001      * Returns true if the value was added to the set, that is if it was not
1002      * already present.
1003      */
1004     function add(Bytes32Set storage set, bytes32 value)
1005         internal
1006         returns (bool)
1007     {
1008         return _add(set._inner, value);
1009     }
1010 
1011     /**
1012      * @dev Removes a value from a set. O(1).
1013      *
1014      * Returns true if the value was removed from the set, that is if it was
1015      * present.
1016      */
1017     function remove(Bytes32Set storage set, bytes32 value)
1018         internal
1019         returns (bool)
1020     {
1021         return _remove(set._inner, value);
1022     }
1023 
1024     /**
1025      * @dev Returns true if the value is in the set. O(1).
1026      */
1027     function contains(Bytes32Set storage set, bytes32 value)
1028         internal
1029         view
1030         returns (bool)
1031     {
1032         return _contains(set._inner, value);
1033     }
1034 
1035     /**
1036      * @dev Returns the number of values in the set. O(1).
1037      */
1038     function length(Bytes32Set storage set) internal view returns (uint256) {
1039         return _length(set._inner);
1040     }
1041 
1042     /**
1043      * @dev Returns the value stored at position `index` in the set. O(1).
1044      *
1045      * Note that there are no guarantees on the ordering of values inside the
1046      * array, and it may change when more values are added or removed.
1047      *
1048      * Requirements:
1049      *
1050      * - `index` must be strictly less than {length}.
1051      */
1052     function at(Bytes32Set storage set, uint256 index)
1053         internal
1054         view
1055         returns (bytes32)
1056     {
1057         return _at(set._inner, index);
1058     }
1059 
1060     // AddressSet
1061 
1062     struct AddressSet {
1063         Set _inner;
1064     }
1065 
1066     /**
1067      * @dev Add a value to a set. O(1).
1068      *
1069      * Returns true if the value was added to the set, that is if it was not
1070      * already present.
1071      */
1072     function add(AddressSet storage set, address value)
1073         internal
1074         returns (bool)
1075     {
1076         return _add(set._inner, bytes32(uint256(uint160(value))));
1077     }
1078 
1079     /**
1080      * @dev Removes a value from a set. O(1).
1081      *
1082      * Returns true if the value was removed from the set, that is if it was
1083      * present.
1084      */
1085     function remove(AddressSet storage set, address value)
1086         internal
1087         returns (bool)
1088     {
1089         return _remove(set._inner, bytes32(uint256(uint160(value))));
1090     }
1091 
1092     /**
1093      * @dev Returns true if the value is in the set. O(1).
1094      */
1095     function contains(AddressSet storage set, address value)
1096         internal
1097         view
1098         returns (bool)
1099     {
1100         return _contains(set._inner, bytes32(uint256(uint160(value))));
1101     }
1102 
1103     /**
1104      * @dev Returns the number of values in the set. O(1).
1105      */
1106     function length(AddressSet storage set) internal view returns (uint256) {
1107         return _length(set._inner);
1108     }
1109 
1110     /**
1111      * @dev Returns the value stored at position `index` in the set. O(1).
1112      *
1113      * Note that there are no guarantees on the ordering of values inside the
1114      * array, and it may change when more values are added or removed.
1115      *
1116      * Requirements:
1117      *
1118      * - `index` must be strictly less than {length}.
1119      */
1120     function at(AddressSet storage set, uint256 index)
1121         internal
1122         view
1123         returns (address)
1124     {
1125         return address(uint160(uint256(_at(set._inner, index))));
1126     }
1127 
1128     // UintSet
1129 
1130     struct UintSet {
1131         Set _inner;
1132     }
1133 
1134     /**
1135      * @dev Add a value to a set. O(1).
1136      *
1137      * Returns true if the value was added to the set, that is if it was not
1138      * already present.
1139      */
1140     function add(UintSet storage set, uint256 value) internal returns (bool) {
1141         return _add(set._inner, bytes32(value));
1142     }
1143 
1144     /**
1145      * @dev Removes a value from a set. O(1).
1146      *
1147      * Returns true if the value was removed from the set, that is if it was
1148      * present.
1149      */
1150     function remove(UintSet storage set, uint256 value)
1151         internal
1152         returns (bool)
1153     {
1154         return _remove(set._inner, bytes32(value));
1155     }
1156 
1157     /**
1158      * @dev Returns true if the value is in the set. O(1).
1159      */
1160     function contains(UintSet storage set, uint256 value)
1161         internal
1162         view
1163         returns (bool)
1164     {
1165         return _contains(set._inner, bytes32(value));
1166     }
1167 
1168     /**
1169      * @dev Returns the number of values on the set. O(1).
1170      */
1171     function length(UintSet storage set) internal view returns (uint256) {
1172         return _length(set._inner);
1173     }
1174 
1175     /**
1176      * @dev Returns the value stored at position `index` in the set. O(1).
1177      *
1178      * Note that there are no guarantees on the ordering of values inside the
1179      * array, and it may change when more values are added or removed.
1180      *
1181      * Requirements:
1182      *
1183      * - `index` must be strictly less than {length}.
1184      */
1185     function at(UintSet storage set, uint256 index)
1186         internal
1187         view
1188         returns (uint256)
1189     {
1190         return uint256(_at(set._inner, index));
1191     }
1192 }
1193 
1194 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1195 
1196 /**
1197  * @dev Library for managing an enumerable variant of Solidity's
1198  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1199  * type.
1200  *
1201  * Maps have the following properties:
1202  *
1203  * - Entries are added, removed, and checked for existence in constant time
1204  * (O(1)).
1205  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1206  *
1207  * ```
1208  * contract Example {
1209  *     // Add the library methods
1210  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1211  *
1212  *     // Declare a set state variable
1213  *     EnumerableMap.UintToAddressMap private myMap;
1214  * }
1215  * ```
1216  *
1217  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1218  * supported.
1219  */
1220 library EnumerableMap {
1221     // To implement this library for multiple types with as little code
1222     // repetition as possible, we write it in terms of a generic Map type with
1223     // bytes32 keys and values.
1224     // The Map implementation uses private functions, and user-facing
1225     // implementations (such as Uint256ToAddressMap) are just wrappers around
1226     // the underlying Map.
1227     // This means that we can only create new EnumerableMaps for types that fit
1228     // in bytes32.
1229 
1230     struct MapEntry {
1231         bytes32 _key;
1232         bytes32 _value;
1233     }
1234 
1235     struct Map {
1236         // Storage of map keys and values
1237         MapEntry[] _entries;
1238         // Position of the entry defined by a key in the `entries` array, plus 1
1239         // because index 0 means a key is not in the map.
1240         mapping(bytes32 => uint256) _indexes;
1241     }
1242 
1243     /**
1244      * @dev Adds a key-value pair to a map, or updates the value for an existing
1245      * key. O(1).
1246      *
1247      * Returns true if the key was added to the map, that is if it was not
1248      * already present.
1249      */
1250     function _set(
1251         Map storage map,
1252         bytes32 key,
1253         bytes32 value
1254     ) private returns (bool) {
1255         // We read and store the key's index to prevent multiple reads from the same storage slot
1256         uint256 keyIndex = map._indexes[key];
1257 
1258         if (keyIndex == 0) {
1259             // Equivalent to !contains(map, key)
1260             map._entries.push(MapEntry({_key: key, _value: value}));
1261             // The entry is stored at length-1, but we add 1 to all indexes
1262             // and use 0 as a sentinel value
1263             map._indexes[key] = map._entries.length;
1264             return true;
1265         } else {
1266             map._entries[keyIndex - 1]._value = value;
1267             return false;
1268         }
1269     }
1270 
1271     /**
1272      * @dev Removes a key-value pair from a map. O(1).
1273      *
1274      * Returns true if the key was removed from the map, that is if it was present.
1275      */
1276     function _remove(Map storage map, bytes32 key) private returns (bool) {
1277         // We read and store the key's index to prevent multiple reads from the same storage slot
1278         uint256 keyIndex = map._indexes[key];
1279 
1280         if (keyIndex != 0) {
1281             // Equivalent to contains(map, key)
1282             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1283             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1284             // This modifies the order of the array, as noted in {at}.
1285 
1286             uint256 toDeleteIndex = keyIndex - 1;
1287             uint256 lastIndex = map._entries.length - 1;
1288 
1289             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1290             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1291 
1292             MapEntry storage lastEntry = map._entries[lastIndex];
1293 
1294             // Move the last entry to the index where the entry to delete is
1295             map._entries[toDeleteIndex] = lastEntry;
1296             // Update the index for the moved entry
1297             map._indexes[lastEntry._key] = toDeleteIndex + 1;
1298             // All indexes are 1-based
1299 
1300             // Delete the slot where the moved entry was stored
1301             map._entries.pop();
1302 
1303             // Delete the index for the deleted slot
1304             delete map._indexes[key];
1305 
1306             return true;
1307         } else {
1308             return false;
1309         }
1310     }
1311 
1312     /**
1313      * @dev Returns true if the key is in the map. O(1).
1314      */
1315     function _contains(Map storage map, bytes32 key)
1316         private
1317         view
1318         returns (bool)
1319     {
1320         return map._indexes[key] != 0;
1321     }
1322 
1323     /**
1324      * @dev Returns the number of key-value pairs in the map. O(1).
1325      */
1326     function _length(Map storage map) private view returns (uint256) {
1327         return map._entries.length;
1328     }
1329 
1330     /**
1331      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1332      *
1333      * Note that there are no guarantees on the ordering of entries inside the
1334      * array, and it may change when more entries are added or removed.
1335      *
1336      * Requirements:
1337      *
1338      * - `index` must be strictly less than {length}.
1339      */
1340     function _at(Map storage map, uint256 index)
1341         private
1342         view
1343         returns (bytes32, bytes32)
1344     {
1345         require(
1346             map._entries.length > index,
1347             "EnumerableMap: index out of bounds"
1348         );
1349 
1350         MapEntry storage entry = map._entries[index];
1351         return (entry._key, entry._value);
1352     }
1353 
1354     /**
1355      * @dev Tries to returns the value associated with `key`.  O(1).
1356      * Does not revert if `key` is not in the map.
1357      */
1358     function _tryGet(Map storage map, bytes32 key)
1359         private
1360         view
1361         returns (bool, bytes32)
1362     {
1363         uint256 keyIndex = map._indexes[key];
1364         if (keyIndex == 0) return (false, 0);
1365         // Equivalent to contains(map, key)
1366         return (true, map._entries[keyIndex - 1]._value);
1367         // All indexes are 1-based
1368     }
1369 
1370     /**
1371      * @dev Returns the value associated with `key`.  O(1).
1372      *
1373      * Requirements:
1374      *
1375      * - `key` must be in the map.
1376      */
1377     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1378         uint256 keyIndex = map._indexes[key];
1379         require(keyIndex != 0, "EnumerableMap: nonexistent key");
1380         // Equivalent to contains(map, key)
1381         return map._entries[keyIndex - 1]._value;
1382         // All indexes are 1-based
1383     }
1384 
1385     /**
1386      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1387      *
1388      * CAUTION: This function is deprecated because it requires allocating memory for the error
1389      * message unnecessarily. For custom revert reasons use {_tryGet}.
1390      */
1391     function _get(
1392         Map storage map,
1393         bytes32 key,
1394         string memory errorMessage
1395     ) private view returns (bytes32) {
1396         uint256 keyIndex = map._indexes[key];
1397         require(keyIndex != 0, errorMessage);
1398         // Equivalent to contains(map, key)
1399         return map._entries[keyIndex - 1]._value;
1400         // All indexes are 1-based
1401     }
1402 
1403     // UintToAddressMap
1404 
1405     struct UintToAddressMap {
1406         Map _inner;
1407     }
1408 
1409     /**
1410      * @dev Adds a key-value pair to a map, or updates the value for an existing
1411      * key. O(1).
1412      *
1413      * Returns true if the key was added to the map, that is if it was not
1414      * already present.
1415      */
1416     function set(
1417         UintToAddressMap storage map,
1418         uint256 key,
1419         address value
1420     ) internal returns (bool) {
1421         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1422     }
1423 
1424     /**
1425      * @dev Removes a value from a set. O(1).
1426      *
1427      * Returns true if the key was removed from the map, that is if it was present.
1428      */
1429     function remove(UintToAddressMap storage map, uint256 key)
1430         internal
1431         returns (bool)
1432     {
1433         return _remove(map._inner, bytes32(key));
1434     }
1435 
1436     /**
1437      * @dev Returns true if the key is in the map. O(1).
1438      */
1439     function contains(UintToAddressMap storage map, uint256 key)
1440         internal
1441         view
1442         returns (bool)
1443     {
1444         return _contains(map._inner, bytes32(key));
1445     }
1446 
1447     /**
1448      * @dev Returns the number of elements in the map. O(1).
1449      */
1450     function length(UintToAddressMap storage map)
1451         internal
1452         view
1453         returns (uint256)
1454     {
1455         return _length(map._inner);
1456     }
1457 
1458     /**
1459      * @dev Returns the element stored at position `index` in the set. O(1).
1460      * Note that there are no guarantees on the ordering of values inside the
1461      * array, and it may change when more values are added or removed.
1462      *
1463      * Requirements:
1464      *
1465      * - `index` must be strictly less than {length}.
1466      */
1467     function at(UintToAddressMap storage map, uint256 index)
1468         internal
1469         view
1470         returns (uint256, address)
1471     {
1472         (bytes32 key, bytes32 value) = _at(map._inner, index);
1473         return (uint256(key), address(uint160(uint256(value))));
1474     }
1475 
1476     /**
1477      * @dev Tries to returns the value associated with `key`.  O(1).
1478      * Does not revert if `key` is not in the map.
1479      *
1480      * _Available since v3.4._
1481      */
1482     function tryGet(UintToAddressMap storage map, uint256 key)
1483         internal
1484         view
1485         returns (bool, address)
1486     {
1487         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1488         return (success, address(uint160(uint256(value))));
1489     }
1490 
1491     /**
1492      * @dev Returns the value associated with `key`.  O(1).
1493      *
1494      * Requirements:
1495      *
1496      * - `key` must be in the map.
1497      */
1498     function get(UintToAddressMap storage map, uint256 key)
1499         internal
1500         view
1501         returns (address)
1502     {
1503         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1504     }
1505 
1506     /**
1507      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1508      *
1509      * CAUTION: This function is deprecated because it requires allocating memory for the error
1510      * message unnecessarily. For custom revert reasons use {tryGet}.
1511      */
1512     function get(
1513         UintToAddressMap storage map,
1514         uint256 key,
1515         string memory errorMessage
1516     ) internal view returns (address) {
1517         return
1518             address(
1519                 uint160(uint256(_get(map._inner, bytes32(key), errorMessage)))
1520             );
1521     }
1522 }
1523 
1524 // File: @openzeppelin/contracts/utils/Strings.sol
1525 
1526 /**
1527  * @dev String operations.
1528  */
1529 library Strings {
1530     /**
1531      * @dev Converts a `uint256` to its ASCII `string` representation.
1532      */
1533     function toString(uint256 value) internal pure returns (string memory) {
1534         // Inspired by OraclizeAPI's implementation - MIT licence
1535         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1536 
1537         if (value == 0) {
1538             return "0";
1539         }
1540         uint256 temp = value;
1541         uint256 digits;
1542         while (temp != 0) {
1543             digits++;
1544             temp /= 10;
1545         }
1546         bytes memory buffer = new bytes(digits);
1547         while (value != 0) {
1548             digits -= 1;
1549             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1550             value /= 10;
1551         }
1552         return string(buffer);
1553     }
1554 }
1555 
1556 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1557 
1558 /**
1559  * @title ERC721 Non-Fungible Token Standard basic implementation
1560  * @dev see https://eips.ethereum.org/EIPS/eip-721
1561  */
1562 contract ERC721 is
1563     Context,
1564     ERC165,
1565     IERC721,
1566     IERC721Metadata,
1567     IERC721Enumerable
1568 {
1569     using SafeMath for uint256;
1570     using Address for address;
1571     using EnumerableSet for EnumerableSet.UintSet;
1572     using EnumerableMap for EnumerableMap.UintToAddressMap;
1573     using Strings for uint256;
1574 
1575     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1576     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1577     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1578 
1579     // Mapping from holder address to their (enumerable) set of owned tokens
1580     mapping(address => EnumerableSet.UintSet) private _holderTokens;
1581 
1582     // Enumerable mapping from token ids to their owners
1583     EnumerableMap.UintToAddressMap private _tokenOwners;
1584 
1585     // Mapping from token ID to approved address
1586     mapping(uint256 => address) private _tokenApprovals;
1587 
1588     // Mapping from owner to operator approvals
1589     mapping(address => mapping(address => bool)) private _operatorApprovals;
1590 
1591     // Token name
1592     string private _name;
1593 
1594     // Token symbol
1595     string private _symbol;
1596 
1597     // Optional mapping for token URIs
1598     mapping(uint256 => string) private _tokenURIs;
1599 
1600     // Base URI
1601     string private _baseURI;
1602 
1603     /*
1604      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1605      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1606      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1607      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1608      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1609      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1610      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1611      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1612      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1613      *
1614      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1615      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1616      */
1617     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1618 
1619     /*
1620      *     bytes4(keccak256('name()')) == 0x06fdde03
1621      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1622      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1623      *
1624      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1625      */
1626     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1627 
1628     /*
1629      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1630      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1631      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1632      *
1633      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1634      */
1635     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1636 
1637     /**
1638      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1639      */
1640     constructor(string memory name_, string memory symbol_) {
1641         _name = name_;
1642         _symbol = symbol_;
1643 
1644         // register the supported interfaces to conform to ERC721 via ERC165
1645         _registerInterface(_INTERFACE_ID_ERC721);
1646         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1647         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1648     }
1649 
1650     /**
1651      * @dev See {IERC721-balanceOf}.
1652      */
1653     function balanceOf(address owner)
1654         public
1655         view
1656         virtual
1657         override
1658         returns (uint256)
1659     {
1660         require(
1661             owner != address(0),
1662             "ERC721: balance query for the zero address"
1663         );
1664         return _holderTokens[owner].length();
1665     }
1666 
1667     /**
1668      * @dev See {IERC721-ownerOf}.
1669      */
1670     function ownerOf(uint256 tokenId)
1671         public
1672         view
1673         virtual
1674         override
1675         returns (address)
1676     {
1677         return
1678             _tokenOwners.get(
1679                 tokenId,
1680                 "ERC721: owner query for nonexistent token"
1681             );
1682     }
1683 
1684     /**
1685      * @dev See {IERC721Metadata-name}.
1686      */
1687     function name() public view virtual override returns (string memory) {
1688         return _name;
1689     }
1690 
1691     /**
1692      * @dev See {IERC721Metadata-symbol}.
1693      */
1694     function symbol() public view virtual override returns (string memory) {
1695         return _symbol;
1696     }
1697 
1698     /**
1699      * @dev See {IERC721Metadata-tokenURI}.
1700      */
1701     function tokenURI(uint256 tokenId)
1702         public
1703         view
1704         virtual
1705         override
1706         returns (string memory)
1707     {
1708         require(
1709             _exists(tokenId),
1710             "ERC721Metadata: URI query for nonexistent token"
1711         );
1712 
1713         string memory _tokenURI = _tokenURIs[tokenId];
1714         string memory base = baseURI();
1715 
1716         // If there is no base URI, return the token URI.
1717         if (bytes(base).length == 0) {
1718             return _tokenURI;
1719         }
1720         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1721         if (bytes(_tokenURI).length > 0) {
1722             return string(abi.encodePacked(base, _tokenURI));
1723         }
1724         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1725         return string(abi.encodePacked(base, tokenId.toString()));
1726     }
1727 
1728     /**
1729      * @dev Returns the base URI set via {_setBaseURI}. This will be
1730      * automatically added as a prefix in {tokenURI} to each token's URI, or
1731      * to the token ID if no specific URI is set for that token ID.
1732      */
1733     function baseURI() public view virtual returns (string memory) {
1734         return _baseURI;
1735     }
1736 
1737     /**
1738      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1739      */
1740     function tokenOfOwnerByIndex(address owner, uint256 index)
1741         public
1742         view
1743         virtual
1744         override
1745         returns (uint256)
1746     {
1747         return _holderTokens[owner].at(index);
1748     }
1749 
1750     /**
1751      * @dev See {IERC721Enumerable-totalSupply}.
1752      */
1753     function totalSupply() public view virtual override returns (uint256) {
1754         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1755         return _tokenOwners.length();
1756     }
1757 
1758     /**
1759      * @dev See {IERC721Enumerable-tokenByIndex}.
1760      */
1761     function tokenByIndex(uint256 index)
1762         public
1763         view
1764         virtual
1765         override
1766         returns (uint256)
1767     {
1768         (uint256 tokenId, ) = _tokenOwners.at(index);
1769         return tokenId;
1770     }
1771 
1772     /**
1773      * @dev See {IERC721-approve}.
1774      */
1775     function approve(address to, uint256 tokenId) public virtual override {
1776         address owner = ERC721.ownerOf(tokenId);
1777         require(to != owner, "ERC721: approval to current owner");
1778 
1779         require(
1780             _msgSender() == owner ||
1781                 ERC721.isApprovedForAll(owner, _msgSender()),
1782             "ERC721: approve caller is not owner nor approved for all"
1783         );
1784 
1785         _approve(to, tokenId);
1786     }
1787 
1788     /**
1789      * @dev See {IERC721-getApproved}.
1790      */
1791     function getApproved(uint256 tokenId)
1792         public
1793         view
1794         virtual
1795         override
1796         returns (address)
1797     {
1798         require(
1799             _exists(tokenId),
1800             "ERC721: approved query for nonexistent token"
1801         );
1802 
1803         return _tokenApprovals[tokenId];
1804     }
1805 
1806     /**
1807      * @dev See {IERC721-setApprovalForAll}.
1808      */
1809     function setApprovalForAll(address operator, bool approved)
1810         public
1811         virtual
1812         override
1813     {
1814         require(operator != _msgSender(), "ERC721: approve to caller");
1815 
1816         _operatorApprovals[_msgSender()][operator] = approved;
1817         emit ApprovalForAll(_msgSender(), operator, approved);
1818     }
1819 
1820     /**
1821      * @dev See {IERC721-isApprovedForAll}.
1822      */
1823     function isApprovedForAll(address owner, address operator)
1824         public
1825         view
1826         virtual
1827         override
1828         returns (bool)
1829     {
1830         return _operatorApprovals[owner][operator];
1831     }
1832 
1833     /**
1834      * @dev See {IERC721-transferFrom}.
1835      */
1836     function transferFrom(
1837         address from,
1838         address to,
1839         uint256 tokenId
1840     ) public virtual override {
1841         //solhint-disable-next-line max-line-length
1842         require(
1843             _isApprovedOrOwner(_msgSender(), tokenId),
1844             "ERC721: transfer caller is not owner nor approved"
1845         );
1846 
1847         _transfer(from, to, tokenId);
1848     }
1849 
1850     /**
1851      * @dev See {IERC721-safeTransferFrom}.
1852      */
1853     function safeTransferFrom(
1854         address from,
1855         address to,
1856         uint256 tokenId
1857     ) public virtual override {
1858         safeTransferFrom(from, to, tokenId, "");
1859     }
1860 
1861     /**
1862      * @dev See {IERC721-safeTransferFrom}.
1863      */
1864     function safeTransferFrom(
1865         address from,
1866         address to,
1867         uint256 tokenId,
1868         bytes memory _data
1869     ) public virtual override {
1870         require(
1871             _isApprovedOrOwner(_msgSender(), tokenId),
1872             "ERC721: transfer caller is not owner nor approved"
1873         );
1874         _safeTransfer(from, to, tokenId, _data);
1875     }
1876 
1877     /**
1878      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1879      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1880      *
1881      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1882      *
1883      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1884      * implement alternative mechanisms to perform token transfer, such as signature-based.
1885      *
1886      * Requirements:
1887      *
1888      * - `from` cannot be the zero address.
1889      * - `to` cannot be the zero address.
1890      * - `tokenId` token must exist and be owned by `from`.
1891      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1892      *
1893      * Emits a {Transfer} event.
1894      */
1895     function _safeTransfer(
1896         address from,
1897         address to,
1898         uint256 tokenId,
1899         bytes memory _data
1900     ) internal virtual {
1901         _transfer(from, to, tokenId);
1902         require(
1903             _checkOnERC721Received(from, to, tokenId, _data),
1904             "ERC721: transfer to non ERC721Receiver implementer"
1905         );
1906     }
1907 
1908     /**
1909      * @dev Returns whether `tokenId` exists.
1910      *
1911      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1912      *
1913      * Tokens start existing when they are minted (`_mint`),
1914      * and stop existing when they are burned (`_burn`).
1915      */
1916     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1917         return _tokenOwners.contains(tokenId);
1918     }
1919 
1920     /**
1921      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1922      *
1923      * Requirements:
1924      *
1925      * - `tokenId` must exist.
1926      */
1927     function _isApprovedOrOwner(address spender, uint256 tokenId)
1928         internal
1929         view
1930         virtual
1931         returns (bool)
1932     {
1933         require(
1934             _exists(tokenId),
1935             "ERC721: operator query for nonexistent token"
1936         );
1937         address owner = ERC721.ownerOf(tokenId);
1938         return (spender == owner ||
1939             getApproved(tokenId) == spender ||
1940             ERC721.isApprovedForAll(owner, spender));
1941     }
1942 
1943     /**
1944      * @dev Safely mints `tokenId` and transfers it to `to`.
1945      *
1946      * Requirements:
1947      d*
1948      * - `tokenId` must not exist.
1949      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1950      *
1951      * Emits a {Transfer} event.
1952      */
1953     function _safeMint(address to, uint256 tokenId) internal virtual {
1954         _safeMint(to, tokenId, "");
1955     }
1956 
1957     /**
1958      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1959      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1960      */
1961     function _safeMint(
1962         address to,
1963         uint256 tokenId,
1964         bytes memory _data
1965     ) internal virtual {
1966         _mint(to, tokenId);
1967         require(
1968             _checkOnERC721Received(address(0), to, tokenId, _data),
1969             "ERC721: transfer to non ERC721Receiver implementer"
1970         );
1971     }
1972 
1973     /**
1974      * @dev Mints `tokenId` and transfers it to `to`.
1975      *
1976      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1977      *
1978      * Requirements:
1979      *
1980      * - `tokenId` must not exist.
1981      * - `to` cannot be the zero address.
1982      *
1983      * Emits a {Transfer} event.
1984      */
1985     function _mint(address to, uint256 tokenId) internal virtual {
1986         require(to != address(0), "ERC721: mint to the zero address");
1987         require(!_exists(tokenId), "ERC721: token already minted");
1988 
1989         _beforeTokenTransfer(address(0), to, tokenId);
1990 
1991         _holderTokens[to].add(tokenId);
1992 
1993         _tokenOwners.set(tokenId, to);
1994 
1995         emit Transfer(address(0), to, tokenId);
1996     }
1997 
1998     /**
1999      * @dev Destroys `tokenId`.
2000      * The approval is cleared when the token is burned.
2001      *
2002      * Requirements:
2003      *
2004      * - `tokenId` must exist.
2005      *
2006      * Emits a {Transfer} event.
2007      */
2008     function _burn(uint256 tokenId) internal virtual {
2009         address owner = ERC721.ownerOf(tokenId);
2010         // internal owner
2011 
2012         _beforeTokenTransfer(owner, address(0), tokenId);
2013 
2014         // Clear approvals
2015         _approve(address(0), tokenId);
2016 
2017         // Clear metadata (if any)
2018         if (bytes(_tokenURIs[tokenId]).length != 0) {
2019             delete _tokenURIs[tokenId];
2020         }
2021 
2022         _holderTokens[owner].remove(tokenId);
2023 
2024         _tokenOwners.remove(tokenId);
2025 
2026         emit Transfer(owner, address(0), tokenId);
2027     }
2028 
2029     /**
2030      * @dev Transfers `tokenId` from `from` to `to`.
2031      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2032      *
2033      * Requirements:
2034      *
2035      * - `to` cannot be the zero address.
2036      * - `tokenId` token must be owned by `from`.
2037      *
2038      * Emits a {Transfer} event.
2039      */
2040     function _transfer(
2041         address from,
2042         address to,
2043         uint256 tokenId
2044     ) internal virtual {
2045         require(
2046             ERC721.ownerOf(tokenId) == from,
2047             "ERC721: transfer of token that is not own"
2048         );
2049         // internal owner
2050         require(to != address(0), "ERC721: transfer to the zero address");
2051 
2052         _beforeTokenTransfer(from, to, tokenId);
2053 
2054         // Clear approvals from the previous owner
2055         _approve(address(0), tokenId);
2056 
2057         _holderTokens[from].remove(tokenId);
2058         _holderTokens[to].add(tokenId);
2059 
2060         _tokenOwners.set(tokenId, to);
2061 
2062         emit Transfer(from, to, tokenId);
2063     }
2064 
2065     /**
2066      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
2067      *
2068      * Requirements:
2069      *
2070      * - `tokenId` must exist.
2071      */
2072     function _setTokenURI(uint256 tokenId, string memory _tokenURI)
2073         internal
2074         virtual
2075     {
2076         require(
2077             _exists(tokenId),
2078             "ERC721Metadata: URI set of nonexistent token"
2079         );
2080         _tokenURIs[tokenId] = _tokenURI;
2081     }
2082 
2083     /**
2084      * @dev Internal function to set the base URI for all token IDs. It is
2085      * automatically added as a prefix to the value returned in {tokenURI},
2086      * or to the token ID if {tokenURI} is empty.
2087      */
2088     function _setBaseURI(string memory baseURI_) internal virtual {
2089         _baseURI = baseURI_;
2090     }
2091 
2092     /**
2093      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2094      * The call is not executed if the target address is not a contract.
2095      *
2096      * @param from address representing the previous owner of the given token ID
2097      * @param to target address that will receive the tokens
2098      * @param tokenId uint256 ID of the token to be transferred
2099      * @param _data bytes optional data to send along with the call
2100      * @return bool whether the call correctly returned the expected magic value
2101      */
2102     function _checkOnERC721Received(
2103         address from,
2104         address to,
2105         uint256 tokenId,
2106         bytes memory _data
2107     ) private returns (bool) {
2108         if (!to.isContract()) {
2109             return true;
2110         }
2111         bytes memory returndata = to.functionCall(
2112             abi.encodeWithSelector(
2113                 IERC721Receiver(to).onERC721Received.selector,
2114                 _msgSender(),
2115                 from,
2116                 tokenId,
2117                 _data
2118             ),
2119             "ERC721: transfer to non ERC721Receiver implementer"
2120         );
2121         bytes4 retval = abi.decode(returndata, (bytes4));
2122         return (retval == _ERC721_RECEIVED);
2123     }
2124 
2125     /**
2126      * @dev Approve `to` to operate on `tokenId`
2127      *
2128      * Emits an {Approval} event.
2129      */
2130     function _approve(address to, uint256 tokenId) internal virtual {
2131         _tokenApprovals[tokenId] = to;
2132         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2133         // internal owner
2134     }
2135 
2136     /**
2137      * @dev Hook that is called before any token transfer. This includes minting
2138      * and burning.
2139      *
2140      * Calling conditions:
2141      *
2142      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2143      * transferred to `to`.
2144      * - When `from` is zero, `tokenId` will be minted for `to`.
2145      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2146      * - `from` cannot be the zero address.
2147      * - `to` cannot be the zero address.
2148      *
2149      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2150      */
2151     function _beforeTokenTransfer(
2152         address from,
2153         address to,
2154         uint256 tokenId
2155     ) internal virtual {}
2156 }
2157 
2158 // File: @openzeppelin/contracts/access/Ownable.sol
2159 
2160 /**
2161  * @dev Contract module which provides a basic access control mechanism, where
2162  * there is an account (an owner) that can be granted exclusive access to
2163  * specific functions.
2164  *
2165  * By default, the owner account will be the one that deploys the contract. This
2166  * can later be changed with {transferOwnership}.
2167  *
2168  * This module is used through inheritance. It will make available the modifier
2169  * `onlyOwner`, which can be applied to your functions to restrict their use to
2170  * the owner.
2171  */
2172 abstract contract Ownable is Context {
2173     address private _owner;
2174 
2175     event OwnershipTransferred(
2176         address indexed previousOwner,
2177         address indexed newOwner
2178     );
2179 
2180     /**
2181      * @dev Initializes the contract setting the deployer as the initial owner.
2182      */
2183     constructor() {
2184         address msgSender = _msgSender();
2185         _owner = msgSender;
2186         emit OwnershipTransferred(address(0), msgSender);
2187     }
2188 
2189     /**
2190      * @dev Returns the address of the current owner.
2191      */
2192     function owner() public view virtual returns (address) {
2193         return _owner;
2194     }
2195 
2196     /**
2197      * @dev Throws if called by any account other than the owner.
2198      */
2199     modifier onlyOwner() {
2200         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2201         _;
2202     }
2203 
2204     /**
2205      * @dev Leaves the contract without owner. It will not be possible to call
2206      * `onlyOwner` functions anymore. Can only be called by the current owner.
2207      *
2208      * NOTE: Renouncing ownership will leave the contract without an owner,
2209      * thereby removing any functionality that is only available to the owner.
2210      */
2211     function renounceOwnership() public virtual onlyOwner {
2212         emit OwnershipTransferred(_owner, address(0));
2213         _owner = address(0);
2214     }
2215 
2216     /**
2217      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2218      * Can only be called by the current owner.
2219      */
2220     function transferOwnership(address newOwner) public virtual onlyOwner {
2221         require(
2222             newOwner != address(0),
2223             "Ownable: new owner is the zero address"
2224         );
2225         emit OwnershipTransferred(_owner, newOwner);
2226         _owner = newOwner;
2227     }
2228 }
2229 
2230 
2231 /**
2232  * @title RambowCloud contract
2233  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
2234  */
2235 contract RambowCloud is ERC721, Ownable {
2236     using SafeMath for uint256;
2237     using Strings for uint256;
2238 
2239     uint256 public startingIndexBlock;
2240     uint256 public startingIndex;
2241     uint256 public privateMintPrice = 0.14 ether;
2242     uint256 public publicMintPrice = 0.15 ether;
2243     uint256 public maxToMint = 3;
2244     uint256 public MAX_MINT_WHITELIST = 3;
2245     uint256 public MAX_ELEMENTS = 1000;
2246     uint256 public REVEAL_TIMESTAMP;
2247 
2248     bool public revealed = false;
2249 
2250     string public notRevealedUri = "";
2251 
2252     string public PROVENANCE_HASH = "";
2253     bool public saleIsActive = false;
2254     bool public privateSaleIsActive = true;
2255 
2256     struct Whitelist {
2257         address addr;
2258         uint256 claimAmount;
2259         uint256 hasMinted;
2260     }
2261 
2262     mapping(address => Whitelist) public whitelist;
2263     mapping(address => Whitelist) public winnerlist;
2264 
2265     address[] whitelistAddr;
2266     address[] winnerlistAddr;
2267 
2268     constructor(
2269         string memory _name,
2270         string memory _symbol,
2271         string memory _initBaseURI,
2272         string memory _initNotRevealedUri
2273     ) ERC721(_name, _symbol) {
2274         REVEAL_TIMESTAMP = block.timestamp;
2275         _setBaseURI(_initBaseURI);
2276         setNotRevealedURI(_initNotRevealedUri);
2277     }
2278 
2279     /**
2280      * Get the array of token for owner.
2281      */
2282     function tokensOfOwner(address _owner)
2283         external
2284         view
2285         returns (uint256[] memory)
2286     {
2287         uint256 tokenCount = balanceOf(_owner);
2288         if (tokenCount == 0) {
2289             return new uint256[](0);
2290         } else {
2291             uint256[] memory result = new uint256[](tokenCount);
2292             for (uint256 index; index < tokenCount; index++) {
2293                 result[index] = tokenOfOwnerByIndex(_owner, index);
2294             }
2295             return result;
2296         }
2297     }
2298 
2299     /**
2300      * Check if certain token id is exists.
2301      */
2302     function exists(uint256 _tokenId) public view returns (bool) {
2303         return _exists(_tokenId);
2304     }
2305 
2306     /**
2307      * Set presell price to mint
2308      */
2309     function setPrivateMintPrice(uint256 _price) external onlyOwner {
2310         privateMintPrice = _price;
2311     }
2312 
2313     /**
2314      * Set publicsell price to mint
2315      */
2316     function setPublicMintPrice(uint256 _price) external onlyOwner {
2317         publicMintPrice = _price;
2318     }
2319 
2320     /**
2321      * Set maximum count to mint per once.
2322      */
2323     function setMaxToMint(uint256 _maxValue) external onlyOwner {
2324         maxToMint = _maxValue;
2325     }
2326 
2327     /**
2328      * reserve by owner
2329      */
2330 
2331     function reserve(uint256 _count) public onlyOwner {
2332         uint256 total = totalSupply();
2333         require(total + _count <= MAX_ELEMENTS, "Exceeded");
2334         for (uint256 i = 0; i < _count; i++) {
2335             _safeMint(msg.sender, total + i);
2336         }
2337     }
2338 
2339     /**
2340      * Set reveal timestamp when finished the sale.
2341      */
2342     function setRevealTimestamp(uint256 _revealTimeStamp) external onlyOwner {
2343         REVEAL_TIMESTAMP = _revealTimeStamp;
2344     }
2345 
2346     /*
2347      * Set provenance once it's calculated
2348      */
2349     function setProvenanceHash(string memory _provenanceHash)
2350         external
2351         onlyOwner
2352     {
2353         PROVENANCE_HASH = _provenanceHash;
2354     }
2355 
2356     function setBaseURI(string memory baseURI) external onlyOwner {
2357         _setBaseURI(baseURI);
2358     }
2359 
2360     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2361         notRevealedUri = _notRevealedURI;
2362     }
2363 
2364     //only owner
2365     function reveal() public onlyOwner {
2366         revealed = true;
2367     }
2368 
2369     function tokenURI(uint256 tokenId)
2370         public
2371         view
2372         virtual
2373         override
2374         returns (string memory)
2375     {
2376         require(
2377             _exists(tokenId),
2378             "ERC721Metadata: URI query for nonexistent token"
2379         );
2380         require(tokenId <= totalSupply(), "URI query for nonexistent token");
2381         if (revealed == false) {
2382             return notRevealedUri;
2383         }
2384         string memory base = baseURI();
2385         return string(abi.encodePacked(base, "/", tokenId.toString(), ".json"));
2386     }
2387 
2388     /*
2389      * Pause sale if active, make active if paused
2390      */
2391 
2392     function flipSaleState() public onlyOwner {
2393         saleIsActive = !saleIsActive;
2394     }
2395 
2396     function flipPrivateSaleState() public onlyOwner {
2397         privateSaleIsActive = !privateSaleIsActive;
2398     }
2399 
2400     /**
2401      * Mints tokens
2402      */
2403     function mint(uint256 _count) public payable {
2404         uint256 total = totalSupply();
2405         require(saleIsActive, "Sale must be active to mint");
2406         require((total + _count) <= MAX_ELEMENTS, "Max limit");
2407 
2408         if (privateSaleIsActive) {
2409             require(
2410                 (privateMintPrice * _count) <= msg.value,
2411                 "Value below price"
2412             );
2413             require(_count <= MAX_MINT_WHITELIST, "Above max tx count");
2414             require(isWhitelisted(msg.sender), "Is not whitelisted");
2415             require(
2416                 whitelist[msg.sender].hasMinted.add(_count) <=
2417                     MAX_MINT_WHITELIST,
2418                 "Can only mint 2 while whitelisted"
2419             );
2420             whitelist[msg.sender].hasMinted = whitelist[msg.sender]
2421                 .hasMinted
2422                 .add(_count);
2423         } else {
2424             if (isWhitelisted(msg.sender)) {
2425                 require((balanceOf(msg.sender) - whitelist[msg.sender].hasMinted + _count) <= maxToMint, "Can only mint 2 tokens");
2426             } else {
2427                 require((balanceOf(msg.sender) + _count) <= maxToMint, "Can only mint 2 tokens");
2428             }
2429             require(
2430                 (publicMintPrice * _count) <= msg.value,
2431                 "Value below price"
2432             );
2433         }
2434 
2435         for (uint256 i = 0; i < _count; i++) {
2436             uint256 mintIndex = totalSupply() + 1;
2437             if (totalSupply() < MAX_ELEMENTS) {
2438                 _safeMint(msg.sender, mintIndex);
2439             }
2440         }
2441 
2442         // If we haven't set the starting index and this is either
2443         // 1) the last saleable token or
2444         // 2) the first token to be sold after the end of pre-sale, set the starting index block
2445         if (
2446             startingIndexBlock == 0 &&
2447             (totalSupply() == MAX_ELEMENTS ||
2448                 block.timestamp >= REVEAL_TIMESTAMP)
2449         ) {
2450             startingIndexBlock = block.number;
2451         }
2452     }
2453 
2454     function freeMint(uint256 _count) public {
2455         uint256 total = totalSupply();
2456         require(isWinnerlisted(msg.sender), "Is not winnerlisted");
2457         require(saleIsActive, "Sale must be active to mint");
2458         require((total + _count) <= MAX_ELEMENTS, "Exceeds max supply");
2459         require(
2460             winnerlist[msg.sender].claimAmount > 0,
2461             "You have no amount to claim"
2462         );
2463         require(
2464             _count <= winnerlist[msg.sender].claimAmount,
2465             "You claim amount exceeded"
2466         );
2467 
2468         for (uint256 i = 0; i < _count; i++) {
2469             uint256 mintIndex = totalSupply() + 1;
2470             if (totalSupply() < MAX_ELEMENTS) {
2471                 _safeMint(msg.sender, mintIndex);
2472             }
2473         }
2474 
2475         winnerlist[msg.sender].claimAmount =
2476             winnerlist[msg.sender].claimAmount -
2477             _count;
2478 
2479         // If we haven't set the starting index and this is either
2480         // 1) the last saleable token or
2481         // 2) the first token to be sold after the end of pre-sale, set the starting index block
2482         if (
2483             startingIndexBlock == 0 &&
2484             (totalSupply() == MAX_ELEMENTS ||
2485                 block.timestamp >= REVEAL_TIMESTAMP)
2486         ) {
2487             startingIndexBlock = block.number;
2488         }
2489     }
2490 
2491     /**
2492      * Set the starting index for the collection
2493      */
2494     function setStartingIndex() external onlyOwner {
2495         require(startingIndex == 0, "Starting index is already set");
2496         require(startingIndexBlock != 0, "Starting index block must be set");
2497 
2498         startingIndex = uint256(blockhash(startingIndexBlock)) % MAX_ELEMENTS;
2499         // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
2500         if ((block.number - startingIndexBlock) > 255) {
2501             startingIndex = uint256(blockhash(block.number - 1)) % MAX_ELEMENTS;
2502         }
2503         // Prevent default sequence
2504         if (startingIndex == 0) {
2505             startingIndex = startingIndex + 1;
2506         }
2507     }
2508 
2509     function setWhitelistAddr(address[] memory addrs) public onlyOwner {
2510         whitelistAddr = addrs;
2511         for (uint256 i = 0; i < whitelistAddr.length; i++) {
2512             addAddressToWhitelist(whitelistAddr[i]);
2513         }
2514     }
2515 
2516     /**
2517      * Set the starting index block for the collection, essentially unblocking
2518      * setting starting index
2519      */
2520     function emergencySetStartingIndexBlock() external onlyOwner {
2521         require(startingIndex == 0, "Starting index is already set");
2522 
2523         startingIndexBlock = block.number;
2524     }
2525 
2526     function withdraw() public onlyOwner {
2527         uint256 balance = address(this).balance;
2528         (bool success, ) = msg.sender.call{value: balance}("");
2529         require(success);
2530     }
2531 
2532     function partialWithdraw(uint256 _amount, address payable _to)
2533         external
2534         onlyOwner
2535     {
2536         require(_amount > 0, "Withdraw must be greater than 0");
2537         require(_amount <= address(this).balance, "Amount too high");
2538         (bool success, ) = _to.call{value: _amount}("");
2539         require(success);
2540     }
2541 
2542     function addAddressToWhitelist(address addr)
2543         public
2544         onlyOwner
2545         returns (bool success)
2546     {
2547         require(!isWhitelisted(addr), "Already whitelisted");
2548         whitelist[addr].addr = addr;
2549         success = true;
2550     }
2551 
2552     function isWhitelisted(address addr)
2553         public
2554         view
2555         returns (bool isWhiteListed)
2556     {
2557         return whitelist[addr].addr == addr;
2558     }
2559 
2560     function addAddressToWinnerlist(address addr, uint256 claimAmount)
2561         public
2562         onlyOwner
2563         returns (bool success)
2564     {
2565         require(!isWinnerlisted(addr), "Already winnerlisted");
2566         winnerlist[addr].addr = addr;
2567         winnerlist[addr].claimAmount = claimAmount;
2568         winnerlist[addr].hasMinted = 0;
2569         success = true;
2570     }
2571 
2572     function isWinnerlisted(address addr)
2573         public
2574         view
2575         returns (bool isWinnerListed)
2576     {
2577         return winnerlist[addr].addr == addr;
2578     }
2579 }