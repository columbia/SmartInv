1 //import "node_modules\@openzeppelin\contracts\utils\Counters.sol";
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @title Counters
7  * @author Matt Condon (@shrugs)
8  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
9  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
10  *
11  * Include with `using Counters for Counters.Counter;`
12  */
13 library Counters {
14     struct Counter {
15         // This variable should never be directly accessed by users of the library: interactions must be restricted to
16         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
17         // this feature: see https://github.com/ethereum/solidity/issues/4637
18         uint256 _value; // default: 0
19     }
20 
21     function current(Counter storage counter) internal view returns (uint256) {
22         return counter._value;
23     }
24 
25     function increment(Counter storage counter) internal {
26         unchecked {
27             counter._value += 1;
28         }
29     }
30 
31     function decrement(Counter storage counter) internal {
32         uint256 value = counter._value;
33         require(value > 0, "Counter: decrement overflow");
34         unchecked {
35             counter._value = value - 1;
36         }
37     }
38 
39     function reset(Counter storage counter) internal {
40         counter._value = 0;
41     }
42 }
43 
44 
45 // File: node_modules\@openzeppelin\contracts\utils\math\SafeMath.sol";
46 
47 pragma solidity ^0.8.0;
48 
49 // CAUTION
50 // This version of SafeMath should only be used with Solidity 0.8 or later,
51 // because it relies on the compiler's built in overflow checks.
52 
53 /**
54  * @dev Wrappers over Solidity's arithmetic operations.
55  *
56  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
57  * now has built in overflow checking.
58  */
59 library SafeMath {
60     /**
61      * @dev Returns the addition of two unsigned integers, with an overflow flag.
62      *
63      * _Available since v3.4._
64      */
65     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
66         unchecked {
67             uint256 c = a + b;
68             if (c < a) return (false, 0);
69             return (true, c);
70         }
71     }
72 
73     /**
74      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
75      *
76      * _Available since v3.4._
77      */
78     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b > a) return (false, 0);
81             return (true, a - b);
82         }
83     }
84 
85     /**
86      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
87      *
88      * _Available since v3.4._
89      */
90     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
91         unchecked {
92             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
93             // benefit is lost if 'b' is also tested.
94             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
95             if (a == 0) return (true, 0);
96             uint256 c = a * b;
97             if (c / a != b) return (false, 0);
98             return (true, c);
99         }
100     }
101 
102     /**
103      * @dev Returns the division of two unsigned integers, with a division by zero flag.
104      *
105      * _Available since v3.4._
106      */
107     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
108         unchecked {
109             if (b == 0) return (false, 0);
110             return (true, a / b);
111         }
112     }
113 
114     /**
115      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
116      *
117      * _Available since v3.4._
118      */
119     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
120         unchecked {
121             if (b == 0) return (false, 0);
122             return (true, a % b);
123         }
124     }
125 
126     /**
127      * @dev Returns the addition of two unsigned integers, reverting on
128      * overflow.
129      *
130      * Counterpart to Solidity's `+` operator.
131      *
132      * Requirements:
133      *
134      * - Addition cannot overflow.
135      */
136     function add(uint256 a, uint256 b) internal pure returns (uint256) {
137         return a + b;
138     }
139 
140     /**
141      * @dev Returns the subtraction of two unsigned integers, reverting on
142      * overflow (when the result is negative).
143      *
144      * Counterpart to Solidity's `-` operator.
145      *
146      * Requirements:
147      *
148      * - Subtraction cannot overflow.
149      */
150     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
151         return a - b;
152     }
153 
154     /**
155      * @dev Returns the multiplication of two unsigned integers, reverting on
156      * overflow.
157      *
158      * Counterpart to Solidity's `*` operator.
159      *
160      * Requirements:
161      *
162      * - Multiplication cannot overflow.
163      */
164     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
165         return a * b;
166     }
167 
168     /**
169      * @dev Returns the integer division of two unsigned integers, reverting on
170      * division by zero. The result is rounded towards zero.
171      *
172      * Counterpart to Solidity's `/` operator.
173      *
174      * Requirements:
175      *
176      * - The divisor cannot be zero.
177      */
178     function div(uint256 a, uint256 b) internal pure returns (uint256) {
179         return a / b;
180     }
181 
182     /**
183      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
184      * reverting when dividing by zero.
185      *
186      * Counterpart to Solidity's `%` operator. This function uses a `revert`
187      * opcode (which leaves remaining gas untouched) while Solidity uses an
188      * invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
195         return a % b;
196     }
197 
198     /**
199      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
200      * overflow (when the result is negative).
201      *
202      * CAUTION: This function is deprecated because it requires allocating memory for the error
203      * message unnecessarily. For custom revert reasons use {trySub}.
204      *
205      * Counterpart to Solidity's `-` operator.
206      *
207      * Requirements:
208      *
209      * - Subtraction cannot overflow.
210      */
211     function sub(
212         uint256 a,
213         uint256 b,
214         string memory errorMessage
215     ) internal pure returns (uint256) {
216         unchecked {
217             require(b <= a, errorMessage);
218             return a - b;
219         }
220     }
221 
222     /**
223      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
224      * division by zero. The result is rounded towards zero.
225      *
226      * Counterpart to Solidity's `/` operator. Note: this function uses a
227      * `revert` opcode (which leaves remaining gas untouched) while Solidity
228      * uses an invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function div(
235         uint256 a,
236         uint256 b,
237         string memory errorMessage
238     ) internal pure returns (uint256) {
239         unchecked {
240             require(b > 0, errorMessage);
241             return a / b;
242         }
243     }
244 
245     /**
246      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
247      * reverting with custom message when dividing by zero.
248      *
249      * CAUTION: This function is deprecated because it requires allocating memory for the error
250      * message unnecessarily. For custom revert reasons use {tryMod}.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function mod(
261         uint256 a,
262         uint256 b,
263         string memory errorMessage
264     ) internal pure returns (uint256) {
265         unchecked {
266             require(b > 0, errorMessage);
267             return a % b;
268         }
269     }
270 }
271 // File: node_modules\@openzeppelin\contracts\utils\Context.sol
272 
273 
274 
275 pragma solidity ^0.8.0;
276 
277 /**
278  * @dev Provides information about the current execution context, including the
279  * sender of the transaction and its data. While these are generally available
280  * via msg.sender and msg.data, they should not be accessed in such a direct
281  * manner, since when dealing with meta-transactions the account sending and
282  * paying for execution may not be the actual sender (as far as an application
283  * is concerned).
284  *
285  * This contract is only required for intermediate, library-like contracts.
286  */
287 abstract contract Context {
288     function _msgSender() internal view virtual returns (address) {
289         return msg.sender;
290     }
291 
292     function _msgData() internal view virtual returns (bytes calldata) {
293         return msg.data;
294     }
295 }
296 
297 // File: @openzeppelin\contracts\access\Ownable.sol
298 
299 
300 
301 pragma solidity ^0.8.0;
302 
303 
304 /**
305  * @dev Contract module which provides a basic access control mechanism, where
306  * there is an account (an owner) that can be granted exclusive access to
307  * specific functions.
308  *
309  * By default, the owner account will be the one that deploys the contract. This
310  * can later be changed with {transferOwnership}.
311  *
312  * This module is used through inheritance. It will make available the modifier
313  * `onlyOwner`, which can be applied to your functions to restrict their use to
314  * the owner.
315  */
316 abstract contract Ownable is Context {
317     address private _owner;
318 
319     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
320 
321     /**
322      * @dev Initializes the contract setting the deployer as the initial owner.
323      */
324     constructor() {
325         _setOwner(_msgSender());
326     }
327 
328     /**
329      * @dev Returns the address of the current owner.
330      */
331     function owner() public view virtual returns (address) {
332         return _owner;
333     }
334 
335     /**
336      * @dev Throws if called by any account other than the owner.
337      */
338     modifier onlyOwner() {
339         require(owner() == _msgSender(), "Ownable: caller is not the owner");
340         _;
341     }
342 
343     /**
344      * @dev Leaves the contract without owner. It will not be possible to call
345      * `onlyOwner` functions anymore. Can only be called by the current owner.
346      *
347      * NOTE: Renouncing ownership will leave the contract without an owner,
348      * thereby removing any functionality that is only available to the owner.
349      */
350     function renounceOwnership() public virtual onlyOwner {
351         _setOwner(address(0));
352     }
353 
354     /**
355      * @dev Transfers ownership of the contract to a new account (`newOwner`).
356      * Can only be called by the current owner.
357      */
358     function transferOwnership(address newOwner) public virtual onlyOwner {
359         require(newOwner != address(0), "Ownable: new owner is the zero address");
360         _setOwner(newOwner);
361     }
362 
363     function _setOwner(address newOwner) private {
364         address oldOwner = _owner;
365         _owner = newOwner;
366         emit OwnershipTransferred(oldOwner, newOwner);
367     }
368 }
369 
370 // File: node_modules\@openzeppelin\contracts\utils\introspection\IERC165.sol
371 
372 
373 
374 pragma solidity ^0.8.0;
375 
376 /**
377  * @dev Interface of the ERC165 standard, as defined in the
378  * https://eips.ethereum.org/EIPS/eip-165[EIP].
379  *
380  * Implementers can declare support of contract interfaces, which can then be
381  * queried by others ({ERC165Checker}).
382  *
383  * For an implementation, see {ERC165}.
384  */
385 interface IERC165 {
386     /**
387      * @dev Returns true if this contract implements the interface defined by
388      * `interfaceId`. See the corresponding
389      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
390      * to learn more about how these ids are created.
391      *
392      * This function call must use less than 30 000 gas.
393      */
394     function supportsInterface(bytes4 interfaceId) external view returns (bool);
395 }
396 
397 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721.sol
398 
399 
400 
401 pragma solidity ^0.8.0;
402 
403 
404 /**
405  * @dev Required interface of an ERC721 compliant contract.
406  */
407 interface IERC721 is IERC165 {
408     /**
409      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
410      */
411     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
412 
413     /**
414      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
415      */
416     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
417 
418     /**
419      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
420      */
421     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
422 
423     /**
424      * @dev Returns the number of tokens in ``owner``'s account.
425      */
426     function balanceOf(address owner) external view returns (uint256 balance);
427 
428     /**
429      * @dev Returns the owner of the `tokenId` token.
430      *
431      * Requirements:
432      *
433      * - `tokenId` must exist.
434      */
435     function ownerOf(uint256 tokenId) external view returns (address owner);
436 
437     /**
438      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
439      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
440      *
441      * Requirements:
442      *
443      * - `from` cannot be the zero address.
444      * - `to` cannot be the zero address.
445      * - `tokenId` token must exist and be owned by `from`.
446      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
447      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
448      *
449      * Emits a {Transfer} event.
450      */
451     function safeTransferFrom(
452         address from,
453         address to,
454         uint256 tokenId
455     ) external;
456 
457     /**
458      * @dev Transfers `tokenId` token from `from` to `to`.
459      *
460      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
461      *
462      * Requirements:
463      *
464      * - `from` cannot be the zero address.
465      * - `to` cannot be the zero address.
466      * - `tokenId` token must be owned by `from`.
467      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
468      *
469      * Emits a {Transfer} event.
470      */
471     function transferFrom(
472         address from,
473         address to,
474         uint256 tokenId
475     ) external;
476 
477     /**
478      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
479      * The approval is cleared when the token is transferred.
480      *
481      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
482      *
483      * Requirements:
484      *
485      * - The caller must own the token or be an approved operator.
486      * - `tokenId` must exist.
487      *
488      * Emits an {Approval} event.
489      */
490     function approve(address to, uint256 tokenId) external;
491 
492     /**
493      * @dev Returns the account approved for `tokenId` token.
494      *
495      * Requirements:
496      *
497      * - `tokenId` must exist.
498      */
499     function getApproved(uint256 tokenId) external view returns (address operator);
500 
501     /**
502      * @dev Approve or remove `operator` as an operator for the caller.
503      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
504      *
505      * Requirements:
506      *
507      * - The `operator` cannot be the caller.
508      *
509      * Emits an {ApprovalForAll} event.
510      */
511     function setApprovalForAll(address operator, bool _approved) external;
512 
513     /**
514      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
515      *
516      * See {setApprovalForAll}
517      */
518     function isApprovedForAll(address owner, address operator) external view returns (bool);
519 
520     /**
521      * @dev Safely transfers `tokenId` token from `from` to `to`.
522      *
523      * Requirements:
524      *
525      * - `from` cannot be the zero address.
526      * - `to` cannot be the zero address.
527      * - `tokenId` token must exist and be owned by `from`.
528      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
529      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
530      *
531      * Emits a {Transfer} event.
532      */
533     function safeTransferFrom(
534         address from,
535         address to,
536         uint256 tokenId,
537         bytes calldata data
538     ) external;
539 }
540 
541 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721Receiver.sol
542 
543 
544 
545 pragma solidity ^0.8.0;
546 
547 /**
548  * @title ERC721 token receiver interface
549  * @dev Interface for any contract that wants to support safeTransfers
550  * from ERC721 asset contracts.
551  */
552 interface IERC721Receiver {
553     /**
554      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
555      * by `operator` from `from`, this function is called.
556      *
557      * It must return its Solidity selector to confirm the token transfer.
558      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
559      *
560      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
561      */
562     function onERC721Received(
563         address operator,
564         address from,
565         uint256 tokenId,
566         bytes calldata data
567     ) external returns (bytes4);
568 }
569 
570 // File: node_modules\@openzeppelin\contracts\token\ERC721\extensions\IERC721Metadata.sol
571 
572 
573 
574 pragma solidity ^0.8.0;
575 
576 
577 /**
578  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
579  * @dev See https://eips.ethereum.org/EIPS/eip-721
580  */
581 interface IERC721Metadata is IERC721 {
582     /**
583      * @dev Returns the token collection name.
584      */
585     function name() external view returns (string memory);
586 
587     /**
588      * @dev Returns the token collection symbol.
589      */
590     function symbol() external view returns (string memory);
591 
592     /**
593      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
594      */
595     function tokenURI(uint256 tokenId) external view returns (string memory);
596 }
597 
598 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
599 
600 
601 
602 pragma solidity ^0.8.0;
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
631         assembly {
632             size := extcodesize(account)
633         }
634         return size > 0;
635     }
636 
637     /**
638      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
639      * `recipient`, forwarding all available gas and reverting on errors.
640      *
641      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
642      * of certain opcodes, possibly making contracts go over the 2300 gas limit
643      * imposed by `transfer`, making them unable to receive funds via
644      * `transfer`. {sendValue} removes this limitation.
645      *
646      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
647      *
648      * IMPORTANT: because control is transferred to `recipient`, care must be
649      * taken to not create reentrancy vulnerabilities. Consider using
650      * {ReentrancyGuard} or the
651      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
652      */
653     function sendValue(address payable recipient, uint256 amount) internal {
654         require(address(this).balance >= amount, "Address: insufficient balance");
655 
656         (bool success, ) = recipient.call{value: amount}("");
657         require(success, "Address: unable to send value, recipient may have reverted");
658     }
659 
660     /**
661      * @dev Performs a Solidity function call using a low level `call`. A
662      * plain `call` is an unsafe replacement for a function call: use this
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
678     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
679         return functionCall(target, data, "Address: low-level call failed");
680     }
681 
682     /**
683      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
684      * `errorMessage` as a fallback revert reason when `target` reverts.
685      *
686      * _Available since v3.1._
687      */
688     function functionCall(
689         address target,
690         bytes memory data,
691         string memory errorMessage
692     ) internal returns (bytes memory) {
693         return functionCallWithValue(target, data, 0, errorMessage);
694     }
695 
696     /**
697      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
698      * but also transferring `value` wei to `target`.
699      *
700      * Requirements:
701      *
702      * - the calling contract must have an ETH balance of at least `value`.
703      * - the called Solidity function must be `payable`.
704      *
705      * _Available since v3.1._
706      */
707     function functionCallWithValue(
708         address target,
709         bytes memory data,
710         uint256 value
711     ) internal returns (bytes memory) {
712         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
713     }
714 
715     /**
716      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
717      * with `errorMessage` as a fallback revert reason when `target` reverts.
718      *
719      * _Available since v3.1._
720      */
721     function functionCallWithValue(
722         address target,
723         bytes memory data,
724         uint256 value,
725         string memory errorMessage
726     ) internal returns (bytes memory) {
727         require(address(this).balance >= value, "Address: insufficient balance for call");
728         require(isContract(target), "Address: call to non-contract");
729 
730         (bool success, bytes memory returndata) = target.call{value: value}(data);
731         return verifyCallResult(success, returndata, errorMessage);
732     }
733 
734     /**
735      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
736      * but performing a static call.
737      *
738      * _Available since v3.3._
739      */
740     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
741         return functionStaticCall(target, data, "Address: low-level static call failed");
742     }
743 
744     /**
745      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
746      * but performing a static call.
747      *
748      * _Available since v3.3._
749      */
750     function functionStaticCall(
751         address target,
752         bytes memory data,
753         string memory errorMessage
754     ) internal view returns (bytes memory) {
755         require(isContract(target), "Address: static call to non-contract");
756 
757         (bool success, bytes memory returndata) = target.staticcall(data);
758         return verifyCallResult(success, returndata, errorMessage);
759     }
760 
761     /**
762      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
763      * but performing a delegate call.
764      *
765      * _Available since v3.4._
766      */
767     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
768         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
769     }
770 
771     /**
772      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
773      * but performing a delegate call.
774      *
775      * _Available since v3.4._
776      */
777     function functionDelegateCall(
778         address target,
779         bytes memory data,
780         string memory errorMessage
781     ) internal returns (bytes memory) {
782         require(isContract(target), "Address: delegate call to non-contract");
783 
784         (bool success, bytes memory returndata) = target.delegatecall(data);
785         return verifyCallResult(success, returndata, errorMessage);
786     }
787 
788     /**
789      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
790      * revert reason using the provided one.
791      *
792      * _Available since v4.3._
793      */
794     function verifyCallResult(
795         bool success,
796         bytes memory returndata,
797         string memory errorMessage
798     ) internal pure returns (bytes memory) {
799         if (success) {
800             return returndata;
801         } else {
802             // Look for revert reason and bubble it up if present
803             if (returndata.length > 0) {
804                 // The easiest way to bubble the revert reason is using memory via assembly
805 
806                 assembly {
807                     let returndata_size := mload(returndata)
808                     revert(add(32, returndata), returndata_size)
809                 }
810             } else {
811                 revert(errorMessage);
812             }
813         }
814     }
815 }
816 
817 // File: node_modules\@openzeppelin\contracts\utils\Strings.sol
818 
819 
820 
821 pragma solidity ^0.8.0;
822 
823 /**
824  * @dev String operations.
825  */
826 library Strings {
827     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
828 
829     /**
830      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
831      */
832     function toString(uint256 value) internal pure returns (string memory) {
833         // Inspired by OraclizeAPI's implementation - MIT licence
834         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
835 
836         if (value == 0) {
837             return "0";
838         }
839         uint256 temp = value;
840         uint256 digits;
841         while (temp != 0) {
842             digits++;
843             temp /= 10;
844         }
845         bytes memory buffer = new bytes(digits);
846         while (value != 0) {
847             digits -= 1;
848             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
849             value /= 10;
850         }
851         return string(buffer);
852     }
853 
854     /**
855      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
856      */
857     function toHexString(uint256 value) internal pure returns (string memory) {
858         if (value == 0) {
859             return "0x00";
860         }
861         uint256 temp = value;
862         uint256 length = 0;
863         while (temp != 0) {
864             length++;
865             temp >>= 8;
866         }
867         return toHexString(value, length);
868     }
869 
870     /**
871      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
872      */
873     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
874         bytes memory buffer = new bytes(2 * length + 2);
875         buffer[0] = "0";
876         buffer[1] = "x";
877         for (uint256 i = 2 * length + 1; i > 1; --i) {
878             buffer[i] = _HEX_SYMBOLS[value & 0xf];
879             value >>= 4;
880         }
881         require(value == 0, "Strings: hex length insufficient");
882         return string(buffer);
883     }
884 }
885 
886 // File: node_modules\@openzeppelin\contracts\utils\introspection\ERC165.sol
887 
888 
889 
890 pragma solidity ^0.8.0;
891 
892 
893 /**
894  * @dev Implementation of the {IERC165} interface.
895  *
896  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
897  * for the additional interface id that will be supported. For example:
898  *
899  * ```solidity
900  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
901  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
902  * }
903  * ```
904  *
905  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
906  */
907 abstract contract ERC165 is IERC165 {
908     /**
909      * @dev See {IERC165-supportsInterface}.
910      */
911     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
912         return interfaceId == type(IERC165).interfaceId;
913     }
914 }
915 
916 // File: @openzeppelin\contracts\token\ERC721\ERC721.sol
917 
918 
919 
920 pragma solidity ^0.8.0;
921 
922 
923 
924 
925 
926 
927 
928 
929 /**
930  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
931  * the Metadata extension, but not including the Enumerable extension, which is available separately as
932  * {ERC721Enumerable}.
933  */
934 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
935     using Address for address;
936     using Strings for uint256;
937 
938     // Token name
939     string private _name;
940 
941     // Token symbol
942     string private _symbol;
943 
944     // Mapping from token ID to owner address
945     mapping(uint256 => address) private _owners;
946 
947     // Mapping owner address to token count
948     mapping(address => uint256) private _balances;
949 
950     // Mapping from token ID to approved address
951     mapping(uint256 => address) private _tokenApprovals;
952 
953     // Mapping from owner to operator approvals
954     mapping(address => mapping(address => bool)) private _operatorApprovals;
955 
956     /**
957      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
958      */
959     constructor(string memory name_, string memory symbol_) {
960         _name = name_;
961         _symbol = symbol_;
962     }
963 
964     /**
965      * @dev See {IERC165-supportsInterface}.
966      */
967     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
968         return
969             interfaceId == type(IERC721).interfaceId ||
970             interfaceId == type(IERC721Metadata).interfaceId ||
971             super.supportsInterface(interfaceId);
972     }
973 
974     /**
975      * @dev See {IERC721-balanceOf}.
976      */
977     function balanceOf(address owner) public view virtual override returns (uint256) {
978         require(owner != address(0), "ERC721: balance query for the zero address");
979         return _balances[owner];
980     }
981 
982     /**
983      * @dev See {IERC721-ownerOf}.
984      */
985     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
986         address owner = _owners[tokenId];
987         require(owner != address(0), "ERC721: owner query for nonexistent token");
988         return owner;
989     }
990 
991     /**
992      * @dev See {IERC721Metadata-name}.
993      */
994     function name() public view virtual override returns (string memory) {
995         return _name;
996     }
997 
998     /**
999      * @dev See {IERC721Metadata-symbol}.
1000      */
1001     function symbol() public view virtual override returns (string memory) {
1002         return _symbol;
1003     }
1004 
1005     /**
1006      * @dev See {IERC721Metadata-tokenURI}.
1007      */
1008     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1009         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1010 
1011         string memory baseURI = _baseURI();
1012         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1013     }
1014 
1015     /**
1016      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1017      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1018      * by default, can be overriden in child contracts.
1019      */
1020     function _baseURI() internal view virtual returns (string memory) {
1021         return "";
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-approve}.
1026      */
1027     function approve(address to, uint256 tokenId) public virtual override {
1028         address owner = ERC721.ownerOf(tokenId);
1029         require(to != owner, "ERC721: approval to current owner");
1030 
1031         require(
1032             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1033             "ERC721: approve caller is not owner nor approved for all"
1034         );
1035 
1036         _approve(to, tokenId);
1037     }
1038 
1039     /**
1040      * @dev See {IERC721-getApproved}.
1041      */
1042     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1043         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1044 
1045         return _tokenApprovals[tokenId];
1046     }
1047 
1048     /**
1049      * @dev See {IERC721-setApprovalForAll}.
1050      */
1051     function setApprovalForAll(address operator, bool approved) public virtual override {
1052         require(operator != _msgSender(), "ERC721: approve to caller");
1053 
1054         _operatorApprovals[_msgSender()][operator] = approved;
1055         emit ApprovalForAll(_msgSender(), operator, approved);
1056     }
1057 
1058     /**
1059      * @dev See {IERC721-isApprovedForAll}.
1060      */
1061     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1062         return _operatorApprovals[owner][operator];
1063     }
1064 
1065     /**
1066      * @dev See {IERC721-transferFrom}.
1067      */
1068     function transferFrom(
1069         address from,
1070         address to,
1071         uint256 tokenId
1072     ) public virtual override {
1073         //solhint-disable-next-line max-line-length
1074         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1075 
1076         _transfer(from, to, tokenId);
1077     }
1078 
1079     /**
1080      * @dev See {IERC721-safeTransferFrom}.
1081      */
1082     function safeTransferFrom(
1083         address from,
1084         address to,
1085         uint256 tokenId
1086     ) public virtual override {
1087         safeTransferFrom(from, to, tokenId, "");
1088     }
1089 
1090     /**
1091      * @dev See {IERC721-safeTransferFrom}.
1092      */
1093     function safeTransferFrom(
1094         address from,
1095         address to,
1096         uint256 tokenId,
1097         bytes memory _data
1098     ) public virtual override {
1099         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1100         _safeTransfer(from, to, tokenId, _data);
1101     }
1102 
1103     /**
1104      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1105      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1106      *
1107      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1108      *
1109      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1110      * implement alternative mechanisms to perform token transfer, such as signature-based.
1111      *
1112      * Requirements:
1113      *
1114      * - `from` cannot be the zero address.
1115      * - `to` cannot be the zero address.
1116      * - `tokenId` token must exist and be owned by `from`.
1117      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1118      *
1119      * Emits a {Transfer} event.
1120      */
1121     function _safeTransfer(
1122         address from,
1123         address to,
1124         uint256 tokenId,
1125         bytes memory _data
1126     ) internal virtual {
1127         _transfer(from, to, tokenId);
1128         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1129     }
1130 
1131     /**
1132      * @dev Returns whether `tokenId` exists.
1133      *
1134      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1135      *
1136      * Tokens start existing when they are minted (`_mint`),
1137      * and stop existing when they are burned (`_burn`).
1138      */
1139     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1140         return _owners[tokenId] != address(0);
1141     }
1142 
1143     /**
1144      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1145      *
1146      * Requirements:
1147      *
1148      * - `tokenId` must exist.
1149      */
1150     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1151         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1152         address owner = ERC721.ownerOf(tokenId);
1153         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1154     }
1155 
1156     /**
1157      * @dev Safely mints `tokenId` and transfers it to `to`.
1158      *
1159      * Requirements:
1160      *
1161      * - `tokenId` must not exist.
1162      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1163      *
1164      * Emits a {Transfer} event.
1165      */
1166     function _safeMint(address to, uint256 tokenId) internal virtual {
1167         _safeMint(to, tokenId, "");
1168     }
1169 
1170     /**
1171      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1172      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1173      */
1174     function _safeMint(
1175         address to,
1176         uint256 tokenId,
1177         bytes memory _data
1178     ) internal virtual {
1179         _mint(to, tokenId);
1180         require(
1181             _checkOnERC721Received(address(0), to, tokenId, _data),
1182             "ERC721: transfer to non ERC721Receiver implementer"
1183         );
1184     }
1185 
1186     /**
1187      * @dev Mints `tokenId` and transfers it to `to`.
1188      *
1189      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1190      *
1191      * Requirements:
1192      *
1193      * - `tokenId` must not exist.
1194      * - `to` cannot be the zero address.
1195      *
1196      * Emits a {Transfer} event.
1197      */
1198     function _mint(address to, uint256 tokenId) internal virtual {
1199         require(to != address(0), "ERC721: mint to the zero address");
1200         require(!_exists(tokenId), "ERC721: token already minted");
1201 
1202         _beforeTokenTransfer(address(0), to, tokenId);
1203 
1204         _balances[to] += 1;
1205         _owners[tokenId] = to;
1206 
1207         emit Transfer(address(0), to, tokenId);
1208     }
1209 
1210     /**
1211      * @dev Destroys `tokenId`.
1212      * The approval is cleared when the token is burned.
1213      *
1214      * Requirements:
1215      *
1216      * - `tokenId` must exist.
1217      *
1218      * Emits a {Transfer} event.
1219      */
1220     function _burn(uint256 tokenId) internal virtual {
1221         address owner = ERC721.ownerOf(tokenId);
1222 
1223         _beforeTokenTransfer(owner, address(0), tokenId);
1224 
1225         // Clear approvals
1226         _approve(address(0), tokenId);
1227 
1228         _balances[owner] -= 1;
1229         delete _owners[tokenId];
1230 
1231         emit Transfer(owner, address(0), tokenId);
1232     }
1233 
1234     /**
1235      * @dev Transfers `tokenId` from `from` to `to`.
1236      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1237      *
1238      * Requirements:
1239      *
1240      * - `to` cannot be the zero address.
1241      * - `tokenId` token must be owned by `from`.
1242      *
1243      * Emits a {Transfer} event.
1244      */
1245     function _transfer(
1246         address from,
1247         address to,
1248         uint256 tokenId
1249     ) internal virtual {
1250         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1251         require(to != address(0), "ERC721: transfer to the zero address");
1252 
1253         _beforeTokenTransfer(from, to, tokenId);
1254 
1255         // Clear approvals from the previous owner
1256         _approve(address(0), tokenId);
1257 
1258         _balances[from] -= 1;
1259         _balances[to] += 1;
1260         _owners[tokenId] = to;
1261 
1262         emit Transfer(from, to, tokenId);
1263     }
1264 
1265     /**
1266      * @dev Approve `to` to operate on `tokenId`
1267      *
1268      * Emits a {Approval} event.
1269      */
1270     function _approve(address to, uint256 tokenId) internal virtual {
1271         _tokenApprovals[tokenId] = to;
1272         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1273     }
1274 
1275     /**
1276      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1277      * The call is not executed if the target address is not a contract.
1278      *
1279      * @param from address representing the previous owner of the given token ID
1280      * @param to target address that will receive the tokens
1281      * @param tokenId uint256 ID of the token to be transferred
1282      * @param _data bytes optional data to send along with the call
1283      * @return bool whether the call correctly returned the expected magic value
1284      */
1285     function _checkOnERC721Received(
1286         address from,
1287         address to,
1288         uint256 tokenId,
1289         bytes memory _data
1290     ) private returns (bool) {
1291         if (to.isContract()) {
1292             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1293                 return retval == IERC721Receiver.onERC721Received.selector;
1294             } catch (bytes memory reason) {
1295                 if (reason.length == 0) {
1296                     revert("ERC721: transfer to non ERC721Receiver implementer");
1297                 } else {
1298                     assembly {
1299                         revert(add(32, reason), mload(reason))
1300                     }
1301                 }
1302             }
1303         } else {
1304             return true;
1305         }
1306     }
1307 
1308     /**
1309      * @dev Hook that is called before any token transfer. This includes minting
1310      * and burning.
1311      *
1312      * Calling conditions:
1313      *
1314      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1315      * transferred to `to`.
1316      * - When `from` is zero, `tokenId` will be minted for `to`.
1317      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1318      * - `from` and `to` are never both zero.
1319      *
1320      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1321      */
1322     function _beforeTokenTransfer(
1323         address from,
1324         address to,
1325         uint256 tokenId
1326     ) internal virtual {}
1327 }
1328 
1329 // File: contracts\CheYuWuXNobody.sol
1330 
1331 // SPDX-License-Identifier: UNLICENSED
1332 //
1333 //
1334 //  __         \ /                                       
1335 // /  |_  _ --- Y       | |            |\| _ |_  _  _| \/
1336 // \__| |(/_    | |_|   |^||_|   ><    | |(_)|_)(_)(_| / 
1337 //
1338 //
1339 //                  .----. 
1340 //                 /      \
1341 //   --{}--        \      /
1342 //                  `----' 
1343 //        _--- -[ ]- ---_ 
1344 //       /   ¸ ¸ ¸       \  
1345 //    ¸ ¦|               |¦
1346 //    0 ¦|  [  X ]  (  •}|¦ O    º±_
1347 //      ¦|            ¨¨¨|¦      ”\\ 
1348 //   ~~~~\   =# # # #=   / ~~~~               
1349 //   ~~~~~ --- -- -- ---¯ ~~~~~
1350 //   ~~~~~~~~~~~~~~~~~~~~~~~~~~
1351 //     
1352 
1353 
1354 pragma solidity ^0.8.0;
1355 pragma experimental ABIEncoderV2;
1356 
1357 contract CheYuWuXNobody is ERC721, Ownable {
1358   using SafeMath for uint256;
1359   using Counters for Counters.Counter;
1360 
1361 
1362   uint public maxNobody = 1092;
1363   uint public maxNobodyPerPurchase = 10;
1364   uint256 public price = 109000000000000000; //0.109 
1365 
1366   bool public isSaleActive = false;
1367   bool public isPreSaleActive = false;
1368   bool public isClaimActive = true;
1369   string public baseURI;
1370 
1371   Counters.Counter private _tokenIds;
1372 
1373   address public c1 = 0x7ddD43C63aa73CDE4c5aa6b5De5D9681882D88f8; 
1374   address public c2 = 0xB60D52448A5C76c87853C011bB4b8EC3114A3277; 
1375 
1376   mapping(address => uint256) claimAllowance;
1377   mapping(address => uint256) presaleAllowance;
1378 
1379   constructor (uint _maxNobody, uint _maxNobodyPerPurchase ) ERC721("CheYuWuXNobody", "CheYuWuXNobody") {
1380     maxNobody = _maxNobody;
1381     maxNobodyPerPurchase = _maxNobodyPerPurchase;
1382     _minttokens(c1, 1);
1383     _minttokens(c2, 1);
1384   }
1385 
1386   function totalSupply() public view returns (uint256) {
1387     return _tokenIds.current();
1388   }
1389   
1390   function claimmint(uint256 _count ) public{
1391     require(isClaimActive, "Sale is not active!" );
1392     require(isClaim(msg.sender,_count), "Insufficient reserved tokens for your address");
1393     require(totalSupply().add(_count) <= maxNobody, "Sorry too many nobody!");
1394 
1395     _minttokens(msg.sender, _count);
1396     claimAllowance[msg.sender] -= _count;
1397   }
1398   
1399   function presalemint(uint256 _count ) public payable {
1400     require(isPreSaleActive, "Sale is not active!" );
1401     require(isWhitelisted(msg.sender,_count), "Insufficient reserved tokens for your address");
1402     require(totalSupply().add(_count) <= maxNobody, "Sorry too many nobody!");
1403     require(msg.value >= price.mul(_count), "Ether value sent is not correct!");
1404 
1405     _minttokens(msg.sender, _count);
1406     presaleAllowance[msg.sender] -= _count;
1407   }
1408 
1409   function mint(uint256 _count ) public payable {
1410     require(isSaleActive, "Sale is not active!" );
1411     require(_count > 0 && _count <= maxNobodyPerPurchase, 'Max is 10 at a time');
1412     require(totalSupply().add(_count) <= maxNobody, "Sorry too many nobody!");
1413     require(msg.value >= price.mul(_count), "Ether value sent is not correct!");
1414 
1415     _minttokens(msg.sender, _count);
1416   }
1417 
1418   function _minttokens(address _to, uint256 _count ) internal {
1419     for (uint256 i = 0; i < _count; i++) {
1420         uint256 newItemId = _tokenIds.current();
1421         _tokenIds.increment();
1422         _safeMint(_to, newItemId);
1423     }
1424   }
1425 
1426   function _baseURI() internal view virtual override returns (string memory) {
1427       return baseURI;
1428   }
1429 
1430   //whitelist
1431   function setWhitelistAllowance(address _to, uint256 _allowance) public onlyOwner {
1432       presaleAllowance[_to] = _allowance;
1433   }
1434 
1435   function setWhitelistAllowances(address[] memory _to, uint256[] memory _allowance) public onlyOwner {
1436       for (uint256 i = 0; i < _to.length; i++) {
1437           presaleAllowance[_to[i]] = _allowance[i];
1438       }
1439   }
1440 
1441   function getWhitelistAllowance(address _to) public view returns (uint256) {
1442       return presaleAllowance[_to];
1443   }
1444 
1445   function isWhitelisted(address _account, uint256 _count) public view returns (bool) {
1446       return presaleAllowance[_account] >= _count;
1447   }
1448 
1449   //claim
1450   function setClaimAllowance(address _to, uint256 _allowance) public onlyOwner {
1451       claimAllowance[_to] = _allowance;
1452   }
1453 
1454   function setClaimAllowances(address[] memory _to, uint256[] memory _allowance) public onlyOwner {
1455       for (uint256 i = 0; i < _to.length; i++) {
1456           claimAllowance[_to[i]] = _allowance[i];
1457       }
1458   }
1459 
1460   function getClaimAllowance(address _to) public view returns (uint256) {
1461       return claimAllowance[_to];
1462   }
1463 
1464   function isClaim(address _account, uint256 _count) public view returns (bool) {
1465       return claimAllowance[_account] >= _count;
1466   }
1467 
1468   //owner only
1469   function flipSaleState() public onlyOwner {
1470       isSaleActive = !isSaleActive;
1471   }
1472 
1473   function flipPreSaleState() public onlyOwner {
1474       isPreSaleActive = !isPreSaleActive;
1475   }
1476 
1477   function flipClaimState() public onlyOwner {
1478       isClaimActive = !isClaimActive;
1479   }
1480 
1481   function setPrice(uint256 _newPrice) public onlyOwner {
1482       price = _newPrice;
1483   }
1484   
1485   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1486       baseURI = _newBaseURI;
1487   }
1488      function setMaxsupply(uint256 _newmaxNobody) public onlyOwner {
1489       maxNobody = _newmaxNobody;
1490   }
1491 
1492   function reserveTokens(address[] memory _to, uint256 _count) public onlyOwner {
1493      require(totalSupply().add(_count) <= maxNobody, "Sorry too many nobody!");
1494       for (uint256 i = 0; i < _to.length; i++) {
1495          _minttokens(_to[i],_count);
1496      }
1497   }
1498 
1499   function withdraw() public onlyOwner {
1500       uint256 balance = address(this).balance;
1501       uint256 _f1Amt = balance.mul(50).div(100);
1502       uint256 _f2Amt = balance.mul(50).div(100);      
1503       require(payable(c1).send(_f1Amt));
1504       require(payable(c2).send(_f2Amt));
1505 
1506   }
1507 
1508   function airdrop(address[] memory _to, uint256 _count ) public onlyOwner {        
1509       for (uint256 i = 0; i < _to.length; i++) {
1510       _minttokens(_to[i], _count);
1511       }
1512   }
1513 
1514   fallback() external payable {
1515       require(msg.value > 0, "Insufficient input balance (0)");
1516     }
1517 
1518   receive() external payable {
1519       require(msg.value > 0, "Insufficient input balance (0)");
1520     }
1521   
1522 }