1 // SPDX-License-Identifier:MIT
2 pragma solidity >=0.7.0 <0.9.0;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         return msg.data;
11     }
12 }
13 
14 abstract contract Pausable is Context {
15     /**
16      * @dev Emitted when the pause is triggered by `account`.
17      */
18     event Paused(address account);
19 
20     /**
21      * @dev Emitted when the pause is lifted by `account`.
22      */
23     event Unpaused(address account);
24 
25     bool private _paused;
26 
27     /**
28      * @dev Initializes the contract in unpaused state.
29      */
30     constructor() {
31         _paused = false;
32     }
33 
34     /**
35      * @dev Returns true if the contract is paused, and false otherwise.
36      */
37     function paused() public view virtual returns (bool) {
38         return _paused;
39     }
40 
41     /**
42      * @dev Modifier to make a function callable only when the contract is not paused.
43      *
44      * Requirements:
45      *
46      * - The contract must not be paused.
47      */
48     modifier whenNotPaused() {
49         require(!paused(), "Pausable: paused");
50         _;
51     }
52 
53     /**
54      * @dev Modifier to make a function callable only when the contract is paused.
55      *
56      * Requirements:
57      *
58      * - The contract must be paused.
59      */
60     modifier whenPaused() {
61         require(paused(), "Pausable: not paused");
62         _;
63     }
64 
65     /**
66      * @dev Triggers stopped state.
67      *
68      * Requirements:
69      *
70      * - The contract must not be paused.
71      */
72     function _pause() internal virtual whenNotPaused {
73         _paused = true;
74         emit Paused(_msgSender());
75     }
76 
77     /**
78      * @dev Returns to normal state.
79      *
80      * Requirements:
81      *
82      * - The contract must be paused.
83      */
84     function _unpause() internal virtual whenPaused {
85         _paused = false;
86         emit Unpaused(_msgSender());
87     }
88 }
89 
90 library SafeMath {
91     /**
92      * @dev Returns the addition of two unsigned integers, with an overflow flag.
93      *
94      * _Available since v3.4._
95      */
96     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
97         unchecked {
98             uint256 c = a + b;
99             if (c < a) return (false, 0);
100             return (true, c);
101         }
102     }
103 
104     /**
105      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
106      *
107      * _Available since v3.4._
108      */
109     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
110         unchecked {
111             if (b > a) return (false, 0);
112             return (true, a - b);
113         }
114     }
115 
116     /**
117      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
118      *
119      * _Available since v3.4._
120      */
121     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
122         unchecked {
123             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
124             // benefit is lost if 'b' is also tested.
125             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
126             if (a == 0) return (true, 0);
127             uint256 c = a * b;
128             if (c / a != b) return (false, 0);
129             return (true, c);
130         }
131     }
132 
133     /**
134      * @dev Returns the division of two unsigned integers, with a division by zero flag.
135      *
136      * _Available since v3.4._
137      */
138     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
139         unchecked {
140             if (b == 0) return (false, 0);
141             return (true, a / b);
142         }
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
147      *
148      * _Available since v3.4._
149      */
150     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
151         unchecked {
152             if (b == 0) return (false, 0);
153             return (true, a % b);
154         }
155     }
156 
157     /**
158      * @dev Returns the addition of two unsigned integers, reverting on
159      * overflow.
160      *
161      * Counterpart to Solidity's `+` operator.
162      *
163      * Requirements:
164      *
165      * - Addition cannot overflow.
166      */
167     function add(uint256 a, uint256 b) internal pure returns (uint256) {
168         return a + b;
169     }
170 
171     /**
172      * @dev Returns the subtraction of two unsigned integers, reverting on
173      * overflow (when the result is negative).
174      *
175      * Counterpart to Solidity's `-` operator.
176      *
177      * Requirements:
178      *
179      * - Subtraction cannot overflow.
180      */
181     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
182         return a - b;
183     }
184 
185     /**
186      * @dev Returns the multiplication of two unsigned integers, reverting on
187      * overflow.
188      *
189      * Counterpart to Solidity's `*` operator.
190      *
191      * Requirements:
192      *
193      * - Multiplication cannot overflow.
194      */
195     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
196         return a * b;
197     }
198 
199     /**
200      * @dev Returns the integer division of two unsigned integers, reverting on
201      * division by zero. The result is rounded towards zero.
202      *
203      * Counterpart to Solidity's `/` operator.
204      *
205      * Requirements:
206      *
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b) internal pure returns (uint256) {
210         return a / b;
211     }
212 
213     /**
214      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
215      * reverting when dividing by zero.
216      *
217      * Counterpart to Solidity's `%` operator. This function uses a `revert`
218      * opcode (which leaves remaining gas untouched) while Solidity uses an
219      * invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
226         return a % b;
227     }
228 
229     /**
230      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
231      * overflow (when the result is negative).
232      *
233      * CAUTION: This function is deprecated because it requires allocating memory for the error
234      * message unnecessarily. For custom revert reasons use {trySub}.
235      *
236      * Counterpart to Solidity's `-` operator.
237      *
238      * Requirements:
239      *
240      * - Subtraction cannot overflow.
241      */
242     function sub(
243         uint256 a,
244         uint256 b,
245         string memory errorMessage
246     ) internal pure returns (uint256) {
247         unchecked {
248             require(b <= a, errorMessage);
249             return a - b;
250         }
251     }
252 
253     /**
254      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
255      * division by zero. The result is rounded towards zero.
256      *
257      * Counterpart to Solidity's `/` operator. Note: this function uses a
258      * `revert` opcode (which leaves remaining gas untouched) while Solidity
259      * uses an invalid opcode to revert (consuming all remaining gas).
260      *
261      * Requirements:
262      *
263      * - The divisor cannot be zero.
264      */
265     function div(
266         uint256 a,
267         uint256 b,
268         string memory errorMessage
269     ) internal pure returns (uint256) {
270         unchecked {
271             require(b > 0, errorMessage);
272             return a / b;
273         }
274     }
275 
276     /**
277      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
278      * reverting with custom message when dividing by zero.
279      *
280      * CAUTION: This function is deprecated because it requires allocating memory for the error
281      * message unnecessarily. For custom revert reasons use {tryMod}.
282      *
283      * Counterpart to Solidity's `%` operator. This function uses a `revert`
284      * opcode (which leaves remaining gas untouched) while Solidity uses an
285      * invalid opcode to revert (consuming all remaining gas).
286      *
287      * Requirements:
288      *
289      * - The divisor cannot be zero.
290      */
291     function mod(
292         uint256 a,
293         uint256 b,
294         string memory errorMessage
295     ) internal pure returns (uint256) {
296         unchecked {
297             require(b > 0, errorMessage);
298             return a % b;
299         }
300     }
301 }
302 
303 interface IERC165 {
304     /**
305      * @dev Returns true if this contract implements the interface defined by
306      * `interfaceId`. See the corresponding
307      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
308      * to learn more about how these ids are created.
309      *
310      * This function call must use less than 30 000 gas.
311      */
312     function supportsInterface(bytes4 interfaceId) external view returns (bool);
313 }
314 
315 abstract contract ERC165 is IERC165 {
316     /**
317      * @dev See {IERC165-supportsInterface}.
318      */
319     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
320         return interfaceId == type(IERC165).interfaceId;
321     }
322 }
323 
324 library Counters {
325     struct Counter {
326         // This variable should never be directly accessed by users of the library: interactions must be restricted to
327         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
328         // this feature: see https://github.com/ethereum/solidity/issues/4637
329         uint256 _value; // default: 0
330     }
331 
332     function current(Counter storage counter) internal view returns (uint256) {
333         return counter._value;
334     }
335 
336     function increment(Counter storage counter) internal {
337         unchecked {
338             counter._value += 1;
339         }
340     }
341 
342     function decrement(Counter storage counter) internal {
343         uint256 value = counter._value;
344         require(value > 0, "Counter: decrement overflow");
345         unchecked {
346             counter._value = value - 1;
347         }
348     }
349 
350     function reset(Counter storage counter) internal {
351         counter._value = 0;
352     }
353 }
354 
355 library Strings {
356     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
357 
358     /**
359      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
360      */
361     function toString(uint256 value) internal pure returns (string memory) {
362         // Inspired by OraclizeAPI's implementation - MIT licence
363         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
364 
365         if (value == 0) {
366             return "0";
367         }
368         uint256 temp = value;
369         uint256 digits;
370         while (temp != 0) {
371             digits++;
372             temp /= 10;
373         }
374         bytes memory buffer = new bytes(digits);
375         while (value != 0) {
376             digits -= 1;
377             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
378             value /= 10;
379         }
380         return string(buffer);
381     }
382 
383     /**
384      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
385      */
386     function toHexString(uint256 value) internal pure returns (string memory) {
387         if (value == 0) {
388             return "0x00";
389         }
390         uint256 temp = value;
391         uint256 length = 0;
392         while (temp != 0) {
393             length++;
394             temp >>= 8;
395         }
396         return toHexString(value, length);
397     }
398 
399     /**
400      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
401      */
402     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
403         bytes memory buffer = new bytes(2 * length + 2);
404         buffer[0] = "0";
405         buffer[1] = "x";
406         for (uint256 i = 2 * length + 1; i > 1; --i) {
407             buffer[i] = _HEX_SYMBOLS[value & 0xf];
408             value >>= 4;
409         }
410         require(value == 0, "Strings: hex length insufficient");
411         return string(buffer);
412     }
413 }
414 library Address {
415     /**
416      * @dev Returns true if `account` is a contract.
417      *
418      * [IMPORTANT]
419      * ====
420      * It is unsafe to assume that an address for which this function returns
421      * false is an externally-owned account (EOA) and not a contract.
422      *
423      * Among others, `isContract` will return false for the following
424      * types of addresses:
425      *
426      *  - an externally-owned account
427      *  - a contract in construction
428      *  - an address where a contract will be created
429      *  - an address where a contract lived, but was destroyed
430      * ====
431      */
432     function isContract(address account) internal view returns (bool) {
433         // This method relies on extcodesize, which returns 0 for contracts in
434         // construction, since the code is only stored at the end of the
435         // constructor execution.
436 
437         uint256 size;
438         assembly {
439             size := extcodesize(account)
440         }
441         return size > 0;
442     }
443 
444     /**
445      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
446      * `recipient`, forwarding all available gas and reverting on errors.
447      *
448      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
449      * of certain opcodes, possibly making contracts go over the 2300 gas limit
450      * imposed by `transfer`, making them unable to receive funds via
451      * `transfer`. {sendValue} removes this limitation.
452      *
453      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
454      *
455      * IMPORTANT: because control is transferred to `recipient`, care must be
456      * taken to not create reentrancy vulnerabilities. Consider using
457      * {ReentrancyGuard} or the
458      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
459      */
460     function sendValue(address payable recipient, uint256 amount) internal {
461         require(address(this).balance >= amount, "Address: insufficient balance");
462 
463         (bool success, ) = recipient.call{value: amount}("");
464         require(success, "Address: unable to send value, recipient may have reverted");
465     }
466 
467     /**
468      * @dev Performs a Solidity function call using a low level `call`. A
469      * plain `call` is an unsafe replacement for a function call: use this
470      * function instead.
471      *
472      * If `target` reverts with a revert reason, it is bubbled up by this
473      * function (like regular Solidity function calls).
474      *
475      * Returns the raw returned data. To convert to the expected return value,
476      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
477      *
478      * Requirements:
479      *
480      * - `target` must be a contract.
481      * - calling `target` with `data` must not revert.
482      *
483      * _Available since v3.1._
484      */
485     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
486         return functionCall(target, data, "Address: low-level call failed");
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
491      * `errorMessage` as a fallback revert reason when `target` reverts.
492      *
493      * _Available since v3.1._
494      */
495     function functionCall(
496         address target,
497         bytes memory data,
498         string memory errorMessage
499     ) internal returns (bytes memory) {
500         return functionCallWithValue(target, data, 0, errorMessage);
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
505      * but also transferring `value` wei to `target`.
506      *
507      * Requirements:
508      *
509      * - the calling contract must have an ETH balance of at least `value`.
510      * - the called Solidity function must be `payable`.
511      *
512      * _Available since v3.1._
513      */
514     function functionCallWithValue(
515         address target,
516         bytes memory data,
517         uint256 value
518     ) internal returns (bytes memory) {
519         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
520     }
521 
522     /**
523      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
524      * with `errorMessage` as a fallback revert reason when `target` reverts.
525      *
526      * _Available since v3.1._
527      */
528     function functionCallWithValue(
529         address target,
530         bytes memory data,
531         uint256 value,
532         string memory errorMessage
533     ) internal returns (bytes memory) {
534         require(address(this).balance >= value, "Address: insufficient balance for call");
535         require(isContract(target), "Address: call to non-contract");
536 
537         (bool success, bytes memory returndata) = target.call{value: value}(data);
538         return verifyCallResult(success, returndata, errorMessage);
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
543      * but performing a static call.
544      *
545      * _Available since v3.3._
546      */
547     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
548         return functionStaticCall(target, data, "Address: low-level static call failed");
549     }
550 
551     /**
552      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
553      * but performing a static call.
554      *
555      * _Available since v3.3._
556      */
557     function functionStaticCall(
558         address target,
559         bytes memory data,
560         string memory errorMessage
561     ) internal view returns (bytes memory) {
562         require(isContract(target), "Address: static call to non-contract");
563 
564         (bool success, bytes memory returndata) = target.staticcall(data);
565         return verifyCallResult(success, returndata, errorMessage);
566     }
567 
568     /**
569      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
570      * but performing a delegate call.
571      *
572      * _Available since v3.4._
573      */
574     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
575         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
576     }
577 
578     /**
579      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
580      * but performing a delegate call.
581      *
582      * _Available since v3.4._
583      */
584     function functionDelegateCall(
585         address target,
586         bytes memory data,
587         string memory errorMessage
588     ) internal returns (bytes memory) {
589         require(isContract(target), "Address: delegate call to non-contract");
590 
591         (bool success, bytes memory returndata) = target.delegatecall(data);
592         return verifyCallResult(success, returndata, errorMessage);
593     }
594 
595     /**
596      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
597      * revert reason using the provided one.
598      *
599      * _Available since v4.3._
600      */
601     function verifyCallResult(
602         bool success,
603         bytes memory returndata,
604         string memory errorMessage
605     ) internal pure returns (bytes memory) {
606         if (success) {
607             return returndata;
608         } else {
609             // Look for revert reason and bubble it up if present
610             if (returndata.length > 0) {
611                 // The easiest way to bubble the revert reason is using memory via assembly
612 
613                 assembly {
614                     let returndata_size := mload(returndata)
615                     revert(add(32, returndata), returndata_size)
616                 }
617             } else {
618                 revert(errorMessage);
619             }
620         }
621     }
622 }
623 
624 abstract contract Ownable is Context {
625     address private _owner;
626 
627     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
628 
629     /**
630      * @dev Initializes the contract setting the deployer as the initial owner.
631      */
632     constructor() {
633         _setOwner(_msgSender());
634     }
635 
636     /**
637      * @dev Returns the address of the current owner.
638      */
639     function owner() public view virtual returns (address) {
640         return _owner;
641     }
642 
643     /**
644      * @dev Throws if called by any account other than the owner.
645      */
646     modifier onlyOwner() {
647         require(owner() == _msgSender(), "Ownable: caller is not the owner");
648         _;
649     }
650 
651     /**
652      * @dev Leaves the contract without owner. It will not be possible to call
653      * `onlyOwner` functions anymore. Can only be called by the current owner.
654      *
655      * NOTE: Renouncing ownership will leave the contract without an owner,
656      * thereby removing any functionality that is only available to the owner.
657      */
658     function renounceOwnership() public virtual onlyOwner {
659         _setOwner(address(0));
660     }
661 
662     /**
663      * @dev Transfers ownership of the contract to a new account (`newOwner`).
664      * Can only be called by the current owner.
665      */
666     function transferOwnership(address newOwner) public virtual onlyOwner {
667         require(newOwner != address(0), "Ownable: new owner is the zero address");
668         _setOwner(newOwner);
669     }
670 
671     function _setOwner(address newOwner) private {
672         address oldOwner = _owner;
673         _owner = newOwner;
674         emit OwnershipTransferred(oldOwner, newOwner);
675     }
676 }
677 
678 interface IERC721 is IERC165 {
679     /**
680      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
681      */
682     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
683 
684     /**
685      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
686      */
687     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
688 
689     /**
690      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
691      */
692     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
693 
694     /**
695      * @dev Returns the number of tokens in ``owner``'s account.
696      */
697     function balanceOf(address owner) external view returns (uint256 balance);
698 
699     /**
700      * @dev Returns the owner of the `tokenId` token.
701      *
702      * Requirements:
703      *
704      * - `tokenId` must exist.
705      */
706     function ownerOf(uint256 tokenId) external view returns (address owner);
707 
708     /**
709      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
710      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
711      *
712      * Requirements:
713      *
714      * - `from` cannot be the zero address.
715      * - `to` cannot be the zero address.
716      * - `tokenId` token must exist and be owned by `from`.
717      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
718      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
719      *
720      * Emits a {Transfer} event.
721      */
722     function safeTransferFrom(
723         address from,
724         address to,
725         uint256 tokenId
726     ) external;
727 
728     /**
729      * @dev Transfers `tokenId` token from `from` to `to`.
730      *
731      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
732      *
733      * Requirements:
734      *
735      * - `from` cannot be the zero address.
736      * - `to` cannot be the zero address.
737      * - `tokenId` token must be owned by `from`.
738      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
739      *
740      * Emits a {Transfer} event.
741      */
742     function transferFrom(
743         address from,
744         address to,
745         uint256 tokenId
746     ) external;
747 
748     /**
749      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
750      * The approval is cleared when the token is transferred.
751      *
752      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
753      *
754      * Requirements:
755      *
756      * - The caller must own the token or be an approved operator.
757      * - `tokenId` must exist.
758      *
759      * Emits an {Approval} event.
760      */
761     function approve(address to, uint256 tokenId) external;
762 
763     /**
764      * @dev Returns the account approved for `tokenId` token.
765      *
766      * Requirements:
767      *
768      * - `tokenId` must exist.
769      */
770     function getApproved(uint256 tokenId) external view returns (address operator);
771 
772     /**
773      * @dev Approve or remove `operator` as an operator for the caller.
774      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
775      *
776      * Requirements:
777      *
778      * - The `operator` cannot be the caller.
779      *
780      * Emits an {ApprovalForAll} event.
781      */
782     function setApprovalForAll(address operator, bool _approved) external;
783 
784     /**
785      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
786      *
787      * See {setApprovalForAll}
788      */
789     function isApprovedForAll(address owner, address operator) external view returns (bool);
790 
791     /**
792      * @dev Safely transfers `tokenId` token from `from` to `to`.
793      *
794      * Requirements:
795      *
796      * - `from` cannot be the zero address.
797      * - `to` cannot be the zero address.
798      * - `tokenId` token must exist and be owned by `from`.
799      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
800      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
801      *
802      * Emits a {Transfer} event.
803      */
804     function safeTransferFrom(
805         address from,
806         address to,
807         uint256 tokenId,
808         bytes calldata data
809     ) external;
810 }
811 
812 interface IERC721Metadata is IERC721 {
813     /**
814      * @dev Returns the token collection name.
815      */
816     function name() external view returns (string memory);
817 
818     /**
819      * @dev Returns the token collection symbol.
820      */
821     function symbol() external view returns (string memory);
822 
823     /**
824      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
825      */
826     function tokenURI(uint256 tokenId) external view returns (string memory);
827 }
828 
829 interface IERC721Enumerable is IERC721 {
830     /**
831      * @dev Returns the total amount of tokens stored by the contract.
832      */
833     function totalSupply() external view returns (uint256);
834 
835     /**
836      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
837      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
838      */
839     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
840 
841     /**
842      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
843      * Use along with {totalSupply} to enumerate all tokens.
844      */
845     function tokenByIndex(uint256 index) external view returns (uint256);
846 }
847 
848 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
849     using Address for address;
850     using Strings for uint256;
851 
852     // Token name
853     string private _name;
854 
855     // Token symbol
856     string private _symbol;
857 
858     // Mapping from token ID to owner address
859     mapping(uint256 => address) private _owners;
860 
861     // Mapping owner address to token count
862     mapping(address => uint256) private _balances;
863 
864     // Mapping from token ID to approved address
865     mapping(uint256 => address) private _tokenApprovals;
866 
867     // Mapping from owner to operator approvals
868     mapping(address => mapping(address => bool)) private _operatorApprovals;
869 
870     /**
871      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
872      */
873     constructor(string memory name_, string memory symbol_) {
874         _name = name_;
875         _symbol = symbol_;
876     }
877 
878     /**
879      * @dev See {IERC165-supportsInterface}.
880      */
881     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
882         return
883             interfaceId == type(IERC721).interfaceId ||
884             interfaceId == type(IERC721Metadata).interfaceId ||
885             super.supportsInterface(interfaceId);
886     }
887 
888     /**
889      * @dev See {IERC721-balanceOf}.
890      */
891     function balanceOf(address owner) public view virtual override returns (uint256) {
892         require(owner != address(0), "ERC721: balance query for the zero address");
893         return _balances[owner];
894     }
895 
896     /**
897      * @dev See {IERC721-ownerOf}.
898      */
899     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
900         address owner = _owners[tokenId];
901         require(owner != address(0), "ERC721: owner query for nonexistent token");
902         return owner;
903     }
904 
905     /**
906      * @dev See {IERC721Metadata-name}.
907      */
908     function name() public view virtual override returns (string memory) {
909         return _name;
910     }
911 
912     /**
913      * @dev See {IERC721Metadata-symbol}.
914      */
915     function symbol() public view virtual override returns (string memory) {
916         return _symbol;
917     }
918 
919     /**
920      * @dev See {IERC721Metadata-tokenURI}.
921      */
922     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
923         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
924 
925         string memory baseURI = _baseURI();
926         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
927     }
928 
929     /**
930      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
931      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
932      * by default, can be overriden in child contracts.
933      */
934     function _baseURI() internal view virtual returns (string memory) {
935         return "";
936     }
937 
938     /**
939      * @dev See {IERC721-approve}.
940      */
941     function approve(address to, uint256 tokenId) public virtual override {
942         address owner = ERC721.ownerOf(tokenId);
943         require(to != owner, "ERC721: approval to current owner");
944 
945         require(
946             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
947             "ERC721: approve caller is not owner nor approved for all"
948         );
949 
950         _approve(to, tokenId);
951     }
952 
953     /**
954      * @dev See {IERC721-getApproved}.
955      */
956     function getApproved(uint256 tokenId) public view virtual override returns (address) {
957         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
958 
959         return _tokenApprovals[tokenId];
960     }
961 
962     /**
963      * @dev See {IERC721-setApprovalForAll}.
964      */
965     function setApprovalForAll(address operator, bool approved) public virtual override {
966         require(operator != _msgSender(), "ERC721: approve to caller");
967 
968         _operatorApprovals[_msgSender()][operator] = approved;
969         emit ApprovalForAll(_msgSender(), operator, approved);
970     }
971 
972     /**
973      * @dev See {IERC721-isApprovedForAll}.
974      */
975     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
976         return _operatorApprovals[owner][operator];
977     }
978 
979     /**
980      * @dev See {IERC721-transferFrom}.
981      */
982     function transferFrom(
983         address from,
984         address to,
985         uint256 tokenId
986     ) public virtual override {
987         //solhint-disable-next-line max-line-length
988         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
989 
990         _transfer(from, to, tokenId);
991     }
992 
993     /**
994      * @dev See {IERC721-safeTransferFrom}.
995      */
996     function safeTransferFrom(
997         address from,
998         address to,
999         uint256 tokenId
1000     ) public virtual override {
1001         safeTransferFrom(from, to, tokenId, "");
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-safeTransferFrom}.
1006      */
1007     function safeTransferFrom(
1008         address from,
1009         address to,
1010         uint256 tokenId,
1011         bytes memory _data
1012     ) public virtual override {
1013         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1014         _safeTransfer(from, to, tokenId, _data);
1015     }
1016 
1017     /**
1018      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1019      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1020      *
1021      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1022      *
1023      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1024      * implement alternative mechanisms to perform token transfer, such as signature-based.
1025      *
1026      * Requirements:
1027      *
1028      * - `from` cannot be the zero address.
1029      * - `to` cannot be the zero address.
1030      * - `tokenId` token must exist and be owned by `from`.
1031      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1032      *
1033      * Emits a {Transfer} event.
1034      */
1035     function _safeTransfer(
1036         address from,
1037         address to,
1038         uint256 tokenId,
1039         bytes memory _data
1040     ) internal virtual {
1041         _transfer(from, to, tokenId);
1042         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1043     }
1044 
1045     /**
1046      * @dev Returns whether `tokenId` exists.
1047      *
1048      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1049      *
1050      * Tokens start existing when they are minted (`_mint`),
1051      * and stop existing when they are burned (`_burn`).
1052      */
1053     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1054         return _owners[tokenId] != address(0);
1055     }
1056 
1057     /**
1058      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1059      *
1060      * Requirements:
1061      *
1062      * - `tokenId` must exist.
1063      */
1064     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1065         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1066         address owner = ERC721.ownerOf(tokenId);
1067         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1068     }
1069 
1070     /**
1071      * @dev Safely mints `tokenId` and transfers it to `to`.
1072      *
1073      * Requirements:
1074      *
1075      * - `tokenId` must not exist.
1076      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1077      *
1078      * Emits a {Transfer} event.
1079      */
1080     function _safeMint(address to, uint256 tokenId) internal virtual {
1081         _safeMint(to, tokenId, "");
1082     }
1083 
1084     /**
1085      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1086      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1087      */
1088     function _safeMint(
1089         address to,
1090         uint256 tokenId,
1091         bytes memory _data
1092     ) internal virtual {
1093         _mint(to, tokenId);
1094         require(
1095             _checkOnERC721Received(address(0), to, tokenId, _data),
1096             "ERC721: transfer to non ERC721Receiver implementer"
1097         );
1098     }
1099 
1100     /**
1101      * @dev Mints `tokenId` and transfers it to `to`.
1102      *
1103      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1104      *
1105      * Requirements:
1106      *
1107      * - `tokenId` must not exist.
1108      * - `to` cannot be the zero address.
1109      *
1110      * Emits a {Transfer} event.
1111      */
1112     function _mint(address to, uint256 tokenId) internal virtual {
1113         require(to != address(0), "ERC721: mint to the zero address");
1114         require(!_exists(tokenId), "ERC721: token already minted");
1115 
1116         _beforeTokenTransfer(address(0), to, tokenId);
1117 
1118         _balances[to] += 1;
1119         _owners[tokenId] = to;
1120 
1121         emit Transfer(address(0), to, tokenId);
1122     }
1123 
1124     /**
1125      * @dev Destroys `tokenId`.
1126      * The approval is cleared when the token is burned.
1127      *
1128      * Requirements:
1129      *
1130      * - `tokenId` must exist.
1131      *
1132      * Emits a {Transfer} event.
1133      */
1134     function _burn(uint256 tokenId) internal virtual {
1135         address owner = ERC721.ownerOf(tokenId);
1136 
1137         _beforeTokenTransfer(owner, address(0), tokenId);
1138 
1139         // Clear approvals
1140         _approve(address(0), tokenId);
1141 
1142         _balances[owner] -= 1;
1143         delete _owners[tokenId];
1144 
1145         emit Transfer(owner, address(0), tokenId);
1146     }
1147 
1148     /**
1149      * @dev Transfers `tokenId` from `from` to `to`.
1150      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1151      *
1152      * Requirements:
1153      *
1154      * - `to` cannot be the zero address.
1155      * - `tokenId` token must be owned by `from`.
1156      *
1157      * Emits a {Transfer} event.
1158      */
1159     function _transfer(
1160         address from,
1161         address to,
1162         uint256 tokenId
1163     ) internal virtual {
1164         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1165         require(to != address(0), "ERC721: transfer to the zero address");
1166 
1167         _beforeTokenTransfer(from, to, tokenId);
1168 
1169         // Clear approvals from the previous owner
1170         _approve(address(0), tokenId);
1171 
1172         _balances[from] -= 1;
1173         _balances[to] += 1;
1174         _owners[tokenId] = to;
1175 
1176         emit Transfer(from, to, tokenId);
1177     }
1178 
1179     /**
1180      * @dev Approve `to` to operate on `tokenId`
1181      *
1182      * Emits a {Approval} event.
1183      */
1184     function _approve(address to, uint256 tokenId) internal virtual {
1185         _tokenApprovals[tokenId] = to;
1186         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1187     }
1188 
1189     /**
1190      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1191      * The call is not executed if the target address is not a contract.
1192      *
1193      * @param from address representing the previous owner of the given token ID
1194      * @param to target address that will receive the tokens
1195      * @param tokenId uint256 ID of the token to be transferred
1196      * @param _data bytes optional data to send along with the call
1197      * @return bool whether the call correctly returned the expected magic value
1198      */
1199     function _checkOnERC721Received(
1200         address from,
1201         address to,
1202         uint256 tokenId,
1203         bytes memory _data
1204     ) private returns (bool) {
1205         if (to.isContract()) {
1206             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1207                 return retval == IERC721Receiver.onERC721Received.selector;
1208             } catch (bytes memory reason) {
1209                 if (reason.length == 0) {
1210                     revert("ERC721: transfer to non ERC721Receiver implementer");
1211                 } else {
1212                     assembly {
1213                         revert(add(32, reason), mload(reason))
1214                     }
1215                 }
1216             }
1217         } else {
1218             return true;
1219         }
1220     }
1221 
1222     /**
1223      * @dev Hook that is called before any token transfer. This includes minting
1224      * and burning.
1225      *
1226      * Calling conditions:
1227      *
1228      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1229      * transferred to `to`.
1230      * - When `from` is zero, `tokenId` will be minted for `to`.
1231      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1232      * - `from` and `to` are never both zero.
1233      *
1234      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1235      */
1236     function _beforeTokenTransfer(
1237         address from,
1238         address to,
1239         uint256 tokenId
1240     ) internal virtual {}
1241 }
1242 
1243 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1244     // Mapping from owner to list of owned token IDs
1245     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1246 
1247     // Mapping from token ID to index of the owner tokens list
1248     mapping(uint256 => uint256) private _ownedTokensIndex;
1249 
1250     // Array with all token ids, used for enumeration
1251     uint256[] private _allTokens;
1252 
1253     // Mapping from token id to position in the allTokens array
1254     mapping(uint256 => uint256) private _allTokensIndex;
1255 
1256     /**
1257      * @dev See {IERC165-supportsInterface}.
1258      */
1259     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1260         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1261     }
1262 
1263     /**
1264      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1265      */
1266     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1267         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1268         return _ownedTokens[owner][index];
1269     }
1270 
1271     /**
1272      * @dev See {IERC721Enumerable-totalSupply}.
1273      */
1274     function totalSupply() public view virtual override returns (uint256) {
1275         return _allTokens.length;
1276     }
1277 
1278     /**
1279      * @dev See {IERC721Enumerable-tokenByIndex}.
1280      */
1281     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1282         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1283         return _allTokens[index];
1284     }
1285 
1286     /**
1287      * @dev Hook that is called before any token transfer. This includes minting
1288      * and burning.
1289      *
1290      * Calling conditions:
1291      *
1292      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1293      * transferred to `to`.
1294      * - When `from` is zero, `tokenId` will be minted for `to`.
1295      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1296      * - `from` cannot be the zero address.
1297      * - `to` cannot be the zero address.
1298      *
1299      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1300      */
1301     function _beforeTokenTransfer(
1302         address from,
1303         address to,
1304         uint256 tokenId
1305     ) internal virtual override {
1306         super._beforeTokenTransfer(from, to, tokenId);
1307 
1308         if (from == address(0)) {
1309             _addTokenToAllTokensEnumeration(tokenId);
1310         } else if (from != to) {
1311             _removeTokenFromOwnerEnumeration(from, tokenId);
1312         }
1313         if (to == address(0)) {
1314             _removeTokenFromAllTokensEnumeration(tokenId);
1315         } else if (to != from) {
1316             _addTokenToOwnerEnumeration(to, tokenId);
1317         }
1318     }
1319 
1320     /**
1321      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1322      * @param to address representing the new owner of the given token ID
1323      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1324      */
1325     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1326         uint256 length = ERC721.balanceOf(to);
1327         _ownedTokens[to][length] = tokenId;
1328         _ownedTokensIndex[tokenId] = length;
1329     }
1330 
1331     /**
1332      * @dev Private function to add a token to this extension's token tracking data structures.
1333      * @param tokenId uint256 ID of the token to be added to the tokens list
1334      */
1335     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1336         _allTokensIndex[tokenId] = _allTokens.length;
1337         _allTokens.push(tokenId);
1338     }
1339 
1340     /**
1341      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1342      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1343      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1344      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1345      * @param from address representing the previous owner of the given token ID
1346      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1347      */
1348     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1349         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1350         // then delete the last slot (swap and pop).
1351 
1352         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1353         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1354 
1355         // When the token to delete is the last token, the swap operation is unnecessary
1356         if (tokenIndex != lastTokenIndex) {
1357             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1358 
1359             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1360             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1361         }
1362 
1363         // This also deletes the contents at the last position of the array
1364         delete _ownedTokensIndex[tokenId];
1365         delete _ownedTokens[from][lastTokenIndex];
1366     }
1367 
1368     /**
1369      * @dev Private function to remove a token from this extension's token tracking data structures.
1370      * This has O(1) time complexity, but alters the order of the _allTokens array.
1371      * @param tokenId uint256 ID of the token to be removed from the tokens list
1372      */
1373     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1374         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1375         // then delete the last slot (swap and pop).
1376 
1377         uint256 lastTokenIndex = _allTokens.length - 1;
1378         uint256 tokenIndex = _allTokensIndex[tokenId];
1379 
1380         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1381         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1382         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1383         uint256 lastTokenId = _allTokens[lastTokenIndex];
1384 
1385         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1386         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1387 
1388         // This also deletes the contents at the last position of the array
1389         delete _allTokensIndex[tokenId];
1390         _allTokens.pop();
1391     }
1392 }
1393 
1394 interface IERC721Receiver {
1395     /**
1396      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1397      * by `operator` from `from`, this function is called.
1398      *
1399      * It must return its Solidity selector to confirm the token transfer.
1400      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1401      *
1402      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1403      */
1404     function onERC721Received(
1405         address operator,
1406         address from,
1407         uint256 tokenId,
1408         bytes calldata data
1409     ) external returns (bytes4);
1410 }
1411 
1412 library Roles {
1413     struct Role {
1414         mapping (address => bool) bearer;
1415     }
1416 
1417     /**
1418      * @dev Give an account access to this role.
1419      */
1420     function add(Role storage role, address account) internal {
1421         require(!has(role, account), "Roles: account already has role");
1422         role.bearer[account] = true;
1423     }
1424 
1425     /**
1426      * @dev Remove an account's access to this role.
1427      */
1428     function remove(Role storage role, address account) internal {
1429         require(has(role, account), "Roles: account does not have role");
1430         role.bearer[account] = false;
1431     }
1432 
1433     /**
1434      * @dev Check if an account has this role.
1435      * @return bool
1436      */
1437     function has(Role storage role, address account) internal view returns (bool) {
1438         require(account != address(0), "Roles: account is the zero address");
1439         return role.bearer[account];
1440     }
1441 }
1442 
1443 contract AdminControl is Ownable {
1444 
1445     using Roles for Roles.Role;
1446 
1447     Roles.Role private _controllerRoles;
1448 
1449 
1450     modifier onlyMinterController() {
1451       require (
1452         hasRole(msg.sender), 
1453         "AdminControl: sender must has minting role"
1454       );
1455       _;
1456     }
1457 
1458     modifier onlyMinter() {
1459       require (
1460         hasRole(msg.sender), 
1461         "AdminControl: sender must has minting role"
1462       );
1463       _;
1464     }
1465 
1466     constructor() {
1467       _grantRole(msg.sender);
1468     }
1469 
1470     function grantMinterRole (address account) public  onlyOwner {
1471       _grantRole(account);
1472     }
1473 
1474     function revokeMinterRole (address account) public  onlyOwner {
1475       _revokeRole(account);
1476     }
1477 
1478     function hasRole(address account) public view returns (bool) {
1479       return _controllerRoles.has(account);
1480     }
1481     
1482     function _grantRole (address account) internal {
1483       _controllerRoles.add(account);
1484     }
1485 
1486     function _revokeRole (address account) internal {
1487       _controllerRoles.remove(account);
1488     }
1489 
1490 }
1491 
1492 library StringUtil {
1493 
1494     /**
1495      * @dev Return the count of the dot "." in a string
1496     */
1497     function dotCount(string memory s) internal pure returns (uint) {
1498         s; // Don't warn about unused variables
1499         // Starting here means the LSB will be the byte we care about
1500         uint ptr;
1501         uint end;
1502         assembly {
1503             ptr := add(s, 1)
1504             end := add(mload(s), ptr)
1505         }
1506         uint num = 0;
1507         uint len = 0;
1508         for (len; ptr < end; len++) {
1509             uint8 b;
1510             assembly { b := and(mload(ptr), 0xFF) }
1511             if (b == 0x2e) {
1512                 num += 1;
1513             }
1514             ptr += 1;
1515         }
1516         return num;
1517     }
1518 	
1519 	function toLower(string memory str) internal pure returns (string memory) {
1520         bytes memory bStr = bytes(str);
1521         bytes memory bLower = new bytes(bStr.length);
1522         for (uint i = 0; i < bStr.length; i++) {
1523             // Uppercase character...
1524             if ((uint8(bStr[i]) >= 65) && (uint8(bStr[i]) <= 90)) {
1525                 // So we add 32 to make it lowercase
1526                 bLower[i] = bytes1(uint8(bStr[i]) + 32);
1527             } else {
1528                 bLower[i] = bStr[i];
1529             }
1530         }
1531         return string(bLower);
1532     }
1533 	
1534 	function toHash(string memory _s) internal pure returns (bytes32) {
1535         return keccak256(abi.encode(_s));
1536     }
1537 
1538     function isEmpty(string memory _s) internal pure returns (bool) {
1539         return bytes(_s).length == 0;
1540     }
1541 	
1542 	 function compare(string memory _a, string memory _b) internal pure returns (int) {
1543         bytes memory a = bytes(_a);
1544         bytes memory b = bytes(_b);
1545         uint minLength = a.length;
1546         if (b.length < minLength) minLength = b.length;
1547         //@todo unroll the loop into increments of 32 and do full 32 byte comparisons
1548         for (uint i = 0; i < minLength; i ++)
1549             if (a[i] < b[i])
1550                 return -1;
1551             else if (a[i] > b[i])
1552                 return 1;
1553         if (a.length < b.length)
1554             return -1;
1555         else if (a.length > b.length)
1556             return 1;
1557         else
1558             return 0;
1559     }
1560     /// @dev Compares two strings and returns true iff they are equal.
1561     function equal(string memory _a, string memory _b) internal pure returns (bool) {
1562         return compare(_a, _b) == 0;
1563     }
1564     /// @dev Finds the index of the first occurrence of _needle in _haystack
1565     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int)
1566     {
1567     	bytes memory h = bytes(_haystack);
1568     	bytes memory n = bytes(_needle);
1569     	if(h.length < 1 || n.length < 1 || (n.length > h.length)) 
1570     		return -1;
1571     	else if(h.length > (2**128 -1)) // since we have to be able to return -1 (if the char isn't found or input error), this function must return an "int" type with a max length of (2^128 - 1)
1572     		return -1;									
1573     	else
1574     	{
1575     		uint subindex = 0;
1576     		for (uint i = 0; i < h.length; i ++)
1577     		{
1578     			if (h[i] == n[0]) // found the first char of b
1579     			{
1580     				subindex = 1;
1581     				while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) // search until the chars don't match or until we reach the end of a or b
1582     				{
1583     					subindex++;
1584     				}	
1585     				if(subindex == n.length)
1586     					return int(i);
1587     			}
1588     		}
1589     		return -1;
1590     	}	
1591     }
1592 	
1593 	
1594 }
1595 
1596 library EnumerableSet {
1597     // To implement this library for multiple types with as little code
1598     // repetition as possible, we write it in terms of a generic Set type with
1599     // bytes32 values.
1600     // The Set implementation uses private functions, and user-facing
1601     // implementations (such as AddressSet) are just wrappers around the
1602     // underlying Set.
1603     // This means that we can only create new EnumerableSets for types that fit
1604     // in bytes32.
1605 
1606     struct Set {
1607         // Storage of set values
1608         bytes32[] _values;
1609         // Position of the value in the `values` array, plus 1 because index 0
1610         // means a value is not in the set.
1611         mapping(bytes32 => uint256) _indexes;
1612     }
1613 
1614     /**
1615      * @dev Add a value to a set. O(1).
1616      *
1617      * Returns true if the value was added to the set, that is if it was not
1618      * already present.
1619      */
1620     function _add(Set storage set, bytes32 value) private returns (bool) {
1621         if (!_contains(set, value)) {
1622             set._values.push(value);
1623             // The value is stored at length-1, but we add 1 to all indexes
1624             // and use 0 as a sentinel value
1625             set._indexes[value] = set._values.length;
1626             return true;
1627         } else {
1628             return false;
1629         }
1630     }
1631 
1632     /**
1633      * @dev Removes a value from a set. O(1).
1634      *
1635      * Returns true if the value was removed from the set, that is if it was
1636      * present.
1637      */
1638     function _remove(Set storage set, bytes32 value) private returns (bool) {
1639         // We read and store the value's index to prevent multiple reads from the same storage slot
1640         uint256 valueIndex = set._indexes[value];
1641 
1642         if (valueIndex != 0) {
1643             // Equivalent to contains(set, value)
1644             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1645             // the array, and then remove the last element (sometimes called as 'swap and pop').
1646             // This modifies the order of the array, as noted in {at}.
1647 
1648             uint256 toDeleteIndex = valueIndex - 1;
1649             uint256 lastIndex = set._values.length - 1;
1650 
1651             if (lastIndex != toDeleteIndex) {
1652                 bytes32 lastvalue = set._values[lastIndex];
1653 
1654                 // Move the last value to the index where the value to delete is
1655                 set._values[toDeleteIndex] = lastvalue;
1656                 // Update the index for the moved value
1657                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
1658             }
1659 
1660             // Delete the slot where the moved value was stored
1661             set._values.pop();
1662 
1663             // Delete the index for the deleted slot
1664             delete set._indexes[value];
1665 
1666             return true;
1667         } else {
1668             return false;
1669         }
1670     }
1671 
1672     /**
1673      * @dev Returns true if the value is in the set. O(1).
1674      */
1675     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1676         return set._indexes[value] != 0;
1677     }
1678 
1679     /**
1680      * @dev Returns the number of values on the set. O(1).
1681      */
1682     function _length(Set storage set) private view returns (uint256) {
1683         return set._values.length;
1684     }
1685 
1686     /**
1687      * @dev Returns the value stored at position `index` in the set. O(1).
1688      *
1689      * Note that there are no guarantees on the ordering of values inside the
1690      * array, and it may change when more values are added or removed.
1691      *
1692      * Requirements:
1693      *
1694      * - `index` must be strictly less than {length}.
1695      */
1696     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1697         return set._values[index];
1698     }
1699 
1700     /**
1701      * @dev Return the entire set in an array
1702      *
1703      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1704      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1705      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1706      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1707      */
1708     function _values(Set storage set) private view returns (bytes32[] memory) {
1709         return set._values;
1710     }
1711 
1712     // Bytes32Set
1713 
1714     struct Bytes32Set {
1715         Set _inner;
1716     }
1717 
1718     /**
1719      * @dev Add a value to a set. O(1).
1720      *
1721      * Returns true if the value was added to the set, that is if it was not
1722      * already present.
1723      */
1724     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1725         return _add(set._inner, value);
1726     }
1727 
1728     /**
1729      * @dev Removes a value from a set. O(1).
1730      *
1731      * Returns true if the value was removed from the set, that is if it was
1732      * present.
1733      */
1734     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1735         return _remove(set._inner, value);
1736     }
1737 
1738     /**
1739      * @dev Returns true if the value is in the set. O(1).
1740      */
1741     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1742         return _contains(set._inner, value);
1743     }
1744 
1745     /**
1746      * @dev Returns the number of values in the set. O(1).
1747      */
1748     function length(Bytes32Set storage set) internal view returns (uint256) {
1749         return _length(set._inner);
1750     }
1751 
1752     /**
1753      * @dev Returns the value stored at position `index` in the set. O(1).
1754      *
1755      * Note that there are no guarantees on the ordering of values inside the
1756      * array, and it may change when more values are added or removed.
1757      *
1758      * Requirements:
1759      *
1760      * - `index` must be strictly less than {length}.
1761      */
1762     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1763         return _at(set._inner, index);
1764     }
1765 
1766     /**
1767      * @dev Return the entire set in an array
1768      *
1769      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1770      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1771      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1772      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1773      */
1774     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
1775         return _values(set._inner);
1776     }
1777 
1778     // AddressSet
1779 
1780     struct AddressSet {
1781         Set _inner;
1782     }
1783 
1784     /**
1785      * @dev Add a value to a set. O(1).
1786      *
1787      * Returns true if the value was added to the set, that is if it was not
1788      * already present.
1789      */
1790     function add(AddressSet storage set, address value) internal returns (bool) {
1791         return _add(set._inner, bytes32(uint256(uint160(value))));
1792     }
1793 
1794     /**
1795      * @dev Removes a value from a set. O(1).
1796      *
1797      * Returns true if the value was removed from the set, that is if it was
1798      * present.
1799      */
1800     function remove(AddressSet storage set, address value) internal returns (bool) {
1801         return _remove(set._inner, bytes32(uint256(uint160(value))));
1802     }
1803 
1804     /**
1805      * @dev Returns true if the value is in the set. O(1).
1806      */
1807     function contains(AddressSet storage set, address value) internal view returns (bool) {
1808         return _contains(set._inner, bytes32(uint256(uint160(value))));
1809     }
1810 
1811     /**
1812      * @dev Returns the number of values in the set. O(1).
1813      */
1814     function length(AddressSet storage set) internal view returns (uint256) {
1815         return _length(set._inner);
1816     }
1817 
1818     /**
1819      * @dev Returns the value stored at position `index` in the set. O(1).
1820      *
1821      * Note that there are no guarantees on the ordering of values inside the
1822      * array, and it may change when more values are added or removed.
1823      *
1824      * Requirements:
1825      *
1826      * - `index` must be strictly less than {length}.
1827      */
1828     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1829         return address(uint160(uint256(_at(set._inner, index))));
1830     }
1831 
1832     /**
1833      * @dev Return the entire set in an array
1834      *
1835      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1836      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1837      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1838      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1839      */
1840     function values(AddressSet storage set) internal view returns (address[] memory) {
1841         bytes32[] memory store = _values(set._inner);
1842         address[] memory result;
1843 
1844         assembly {
1845             result := store
1846         }
1847 
1848         return result;
1849     }
1850 
1851     // UintSet
1852 
1853     struct UintSet {
1854         Set _inner;
1855     }
1856 
1857     /**
1858      * @dev Add a value to a set. O(1).
1859      *
1860      * Returns true if the value was added to the set, that is if it was not
1861      * already present.
1862      */
1863     function add(UintSet storage set, uint256 value) internal returns (bool) {
1864         return _add(set._inner, bytes32(value));
1865     }
1866 
1867     /**
1868      * @dev Removes a value from a set. O(1).
1869      *
1870      * Returns true if the value was removed from the set, that is if it was
1871      * present.
1872      */
1873     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1874         return _remove(set._inner, bytes32(value));
1875     }
1876 
1877     /**
1878      * @dev Returns true if the value is in the set. O(1).
1879      */
1880     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1881         return _contains(set._inner, bytes32(value));
1882     }
1883 
1884     /**
1885      * @dev Returns the number of values on the set. O(1).
1886      */
1887     function length(UintSet storage set) internal view returns (uint256) {
1888         return _length(set._inner);
1889     }
1890 
1891     /**
1892      * @dev Returns the value stored at position `index` in the set. O(1).
1893      *
1894      * Note that there are no guarantees on the ordering of values inside the
1895      * array, and it may change when more values are added or removed.
1896      *
1897      * Requirements:
1898      *
1899      * - `index` must be strictly less than {length}.
1900      */
1901     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1902         return uint256(_at(set._inner, index));
1903     }
1904 
1905     /**
1906      * @dev Return the entire set in an array
1907      *
1908      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1909      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1910      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1911      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1912      */
1913     function values(UintSet storage set) internal view returns (uint256[] memory) {
1914         bytes32[] memory store = _values(set._inner);
1915         uint256[] memory result;
1916 
1917         assembly {
1918             result := store
1919         }
1920 
1921         return result;
1922     }
1923 }
1924 
1925 abstract contract KeyStorage {
1926     mapping(uint256 => string) private _keys;
1927 
1928     function getKey(uint256 keyHash) public view returns (string memory) {
1929         return _keys[keyHash];
1930     }
1931 
1932     function getKeys(uint256[] calldata hashes) public view returns (string[] memory values) {
1933         values = new string[](hashes.length);
1934         for (uint256 i = 0; i < hashes.length; i++) {
1935             values[i] = getKey(hashes[i]);
1936         }
1937     }
1938 
1939     function addKey(string memory key) external {
1940         _addKey(uint256(keccak256(abi.encodePacked(key))), key);
1941     }
1942 
1943     function _existsKey(uint256 keyHash) internal view returns (bool) {
1944         return bytes(_keys[keyHash]).length > 0;
1945     }
1946 
1947     function _addKey(uint256 keyHash, string memory key) internal {
1948         if (!_existsKey(keyHash)) {
1949             _keys[keyHash] = key;
1950         }
1951     }
1952 }
1953 
1954 interface IRecordReader {
1955     /**
1956      * @dev Function to get record.
1957      * @param key The key to query the value of.
1958      * @param tokenId The token id to fetch.
1959      * @return The value string.
1960      */
1961     function get(string calldata key, uint256 tokenId) external view returns (string memory);
1962 
1963     /**
1964      * @dev Function to get multiple record.
1965      * @param keys The keys to query the value of.
1966      * @param tokenId The token id to fetch.
1967      * @return The values.
1968      */
1969     function getMany(string[] calldata keys, uint256 tokenId) external view returns (string[] memory);
1970 
1971     /**
1972      * @dev Function get value by provied key hash.
1973      * @param keyHash The key to query the value of.
1974      * @param tokenId The token id to set.
1975      */
1976     function getByHash(uint256 keyHash, uint256 tokenId) external view returns (string memory key, string memory value);
1977 
1978     /**
1979      * @dev Function get values by provied key hashes.
1980      * @param keyHashes The key to query the value of.
1981      * @param tokenId The token id to set.
1982      */
1983     function getManyByHash(uint256[] calldata keyHashes, uint256 tokenId)
1984         external
1985         view
1986         returns (string[] memory keys, string[] memory values);
1987 }
1988 
1989 interface IRecordStorage is IRecordReader {
1990     event Set(uint256 indexed tokenId, string indexed keyIndex, string indexed valueIndex, string key, string value);
1991 
1992     event NewKey(uint256 indexed tokenId, string indexed keyIndex, string key);
1993 
1994     event ResetRecords(uint256 indexed tokenId);
1995 
1996     /**
1997      * @dev Set record by key
1998      * @param key The key set the value of
1999      * @param value The value to set key to
2000      * @param tokenId ERC-721 token id to set
2001      */
2002     function set(
2003         string calldata key,
2004         string calldata value,
2005         uint256 tokenId
2006     ) external;
2007 
2008     /**
2009      * @dev Set records by keys
2010      * @param keys The keys set the values of
2011      * @param values Records values
2012      * @param tokenId ERC-721 token id of the domain
2013      */
2014     function setMany(
2015         string[] memory keys,
2016         string[] memory values,
2017         uint256 tokenId
2018     ) external;
2019 
2020     /**
2021      * @dev Set record by key hash
2022      * @param keyHash The key hash set the value of
2023      * @param value The value to set key to
2024      * @param tokenId ERC-721 token id to set
2025      */
2026     function setByHash(
2027         uint256 keyHash,
2028         string calldata value,
2029         uint256 tokenId
2030     ) external;
2031 
2032     /**
2033      * @dev Set records by key hashes
2034      * @param keyHashes The key hashes set the values of
2035      * @param values Records values
2036      * @param tokenId ERC-721 token id of the domain
2037      */
2038     function setManyByHash(
2039         uint256[] calldata keyHashes,
2040         string[] calldata values,
2041         uint256 tokenId
2042     ) external;
2043 
2044     /**
2045      * @dev Reset all domain records and set new ones
2046      * @param keys New record keys
2047      * @param values New record values
2048      * @param tokenId ERC-721 token id of the domain
2049      */
2050     function reconfigure(
2051         string[] memory keys,
2052         string[] memory values,
2053         uint256 tokenId
2054     ) external;
2055 
2056     /**
2057      * @dev Function to reset all existing records on a domain.
2058      * @param tokenId ERC-721 token id to set.
2059      */
2060     function reset(uint256 tokenId) external;
2061 }
2062 
2063 abstract contract RecordStorage is KeyStorage, IRecordStorage {
2064     /// @dev mapping of presetIds to keyIds to values
2065     mapping(uint256 => mapping(uint256 => string)) internal _records;
2066 
2067     /// @dev mapping of tokenIds to presetIds
2068     mapping(uint256 => uint256) internal _tokenPresets;
2069 
2070     function get(string calldata key, uint256 tokenId) external view override returns (string memory value) {
2071         value = _get(key, tokenId);
2072     }
2073 
2074     function getMany(string[] calldata keys, uint256 tokenId) external view override returns (string[] memory values) {
2075         values = new string[](keys.length);
2076         for (uint256 i = 0; i < keys.length; i++) {
2077             values[i] = _get(keys[i], tokenId);
2078         }
2079     }
2080 
2081     function getByHash(uint256 keyHash, uint256 tokenId)
2082         external
2083         view
2084         override
2085         returns (string memory key, string memory value)
2086     {
2087         (key, value) = _getByHash(keyHash, tokenId);
2088     }
2089 
2090     function getManyByHash(uint256[] calldata keyHashes, uint256 tokenId)
2091         external
2092         view
2093         override
2094         returns (string[] memory keys, string[] memory values)
2095     {
2096         keys = new string[](keyHashes.length);
2097         values = new string[](keyHashes.length);
2098         for (uint256 i = 0; i < keyHashes.length; i++) {
2099             (keys[i], values[i]) = _getByHash(keyHashes[i], tokenId);
2100         }
2101     }
2102 
2103     function _presetOf(uint256 tokenId) internal view virtual returns (uint256) {
2104         return _tokenPresets[tokenId] == 0 ? tokenId : _tokenPresets[tokenId];
2105     }
2106 
2107     function _set(
2108         string calldata key,
2109         string calldata value,
2110         uint256 tokenId
2111     ) internal {
2112         uint256 keyHash = uint256(keccak256(abi.encodePacked(key)));
2113         _addKey(keyHash, key);
2114         _set(keyHash, key, value, tokenId);
2115     }
2116 
2117     function _setMany(
2118         string[] calldata keys,
2119         string[] calldata values,
2120         uint256 tokenId
2121     ) internal {
2122         for (uint256 i = 0; i < keys.length; i++) {
2123             _set(keys[i], values[i], tokenId);
2124         }
2125     }
2126 
2127     function _setByHash(
2128         uint256 keyHash,
2129         string calldata value,
2130         uint256 tokenId
2131     ) internal {
2132         require(_existsKey(keyHash), 'RecordStorage: KEY_NOT_FOUND');
2133         _set(keyHash, getKey(keyHash), value, tokenId);
2134     }
2135 
2136     function _setManyByHash(
2137         uint256[] calldata keyHashes,
2138         string[] calldata values,
2139         uint256 tokenId
2140     ) internal {
2141         for (uint256 i = 0; i < keyHashes.length; i++) {
2142             _setByHash(keyHashes[i], values[i], tokenId);
2143         }
2144     }
2145 
2146     function _reconfigure(
2147         string[] calldata keys,
2148         string[] calldata values,
2149         uint256 tokenId
2150     ) internal {
2151         _reset(tokenId);
2152         _setMany(keys, values, tokenId);
2153     }
2154 
2155     function _reset(uint256 tokenId) internal {
2156         _tokenPresets[tokenId] = uint256(keccak256(abi.encodePacked(_presetOf(tokenId))));
2157         emit ResetRecords(tokenId);
2158     }
2159 
2160     function _get(string memory key, uint256 tokenId) private view returns (string memory) {
2161         return _get(uint256(keccak256(abi.encodePacked(key))), tokenId);
2162     }
2163 
2164     function _getByHash(uint256 keyHash, uint256 tokenId)
2165         private
2166         view
2167         returns (string memory key, string memory value)
2168     {
2169         key = getKey(keyHash);
2170         value = _get(keyHash, tokenId);
2171     }
2172 
2173     function _get(uint256 keyHash, uint256 tokenId) private view returns (string memory) {
2174         return _records[_presetOf(tokenId)][keyHash];
2175     }
2176 
2177     function _set(
2178         uint256 keyHash,
2179         string memory key,
2180         string memory value,
2181         uint256 tokenId
2182     ) private {
2183         if (bytes(_records[_presetOf(tokenId)][keyHash]).length == 0) {
2184             emit NewKey(tokenId, key, key);
2185         }
2186 
2187         _records[_presetOf(tokenId)][keyHash] = value;
2188         emit Set(tokenId, key, value, key, value);
2189     }
2190 }
2191 
2192 abstract contract WhiteList is AdminControl {
2193 
2194     mapping(address => uint256) public _whiteList;
2195 	
2196 	bool public isWhiteListActive = false;
2197 
2198     function setWhiteListActive(bool _isWhiteListActive) external onlyOwner {
2199         isWhiteListActive = _isWhiteListActive;
2200     }
2201 
2202     function addWhiteLists(address[] calldata accounts, uint256 numbers) external onlyMinterController {
2203         for (uint256 i = 0; i < accounts.length; i++) 
2204 		{
2205             _whiteList[accounts[i]] = numbers;
2206         }
2207     }
2208 	
2209 	function addWhiteList(address account, uint256 numbers) external onlyMinterController {
2210         _whiteList[account] = numbers;
2211     }
2212 	
2213 	function numberInWhiteList(address addr) external view returns (uint256) {
2214         return _whiteList[addr];
2215     }
2216 	
2217 	function chkInWhiteList(address addr) external view returns (bool) {
2218         return _whiteList[addr] > 0;
2219     }
2220 }
2221 
2222 abstract contract BookingList is AdminControl {
2223 
2224     mapping(bytes => string) public _bookingList;
2225 	
2226 	bool public _isBookingListActive = false;
2227 
2228     function setBookingListActive() external onlyOwner {
2229         _isBookingListActive = !_isBookingListActive;
2230     }
2231 
2232     function addBookingLists(string[] calldata names) external onlyMinterController {
2233         for (uint256 i = 0; i < names.length; i++) 
2234 		{
2235             _bookingList[bytes(names[i])] = names[i];
2236         }
2237     }
2238 	
2239 	function addBookingList(string calldata name) external onlyMinterController {
2240         _bookingList[bytes(name)] = name;
2241     }
2242 	
2243 	function removeBookingList(string calldata name) external onlyMinterController {
2244 		delete _bookingList[bytes(name)];
2245     }
2246 	
2247 	function chkInBookingList(string calldata name) external view returns (bool) {
2248 		string memory _name = _bookingList[bytes(name)];
2249         return bytes(_name).length > 0;
2250     }
2251 }
2252 
2253 
2254 contract KeKDomains is ERC721, ERC721Enumerable, AdminControl, RecordStorage, WhiteList, BookingList
2255 {
2256 	using SafeMath for uint256;
2257 	 
2258 	using EnumerableSet for EnumerableSet.UintSet;  
2259 	
2260 	event NewURI(uint256 indexed tokenId, string tokenUri);
2261 		
2262 	mapping (uint256 => EnumerableSet.UintSet) private _subTokens;
2263 
2264 	mapping (uint256 => string) public _tokenURIs;
2265 	
2266 	mapping(uint256 => bytes) public _nativeAddress;
2267 	
2268 	mapping (uint256 => address) internal _tokenResolvers;
2269 	
2270 	mapping(address => uint256) private _tokenReverses;
2271 
2272     mapping(uint256 => string) private _tlds;
2273 	
2274 	string private _nftBaseURI = "https://api-kek.herokuapp.com/";
2275 	
2276 	bool public _saleIsActive = false;
2277 	
2278 	bool public _saleTwoCharIsActive = false;
2279 
2280 	uint256 private _price = 0.005 ether;
2281 	
2282 	uint256 private _2chartimes = 20;
2283 	
2284 	uint256 private _3chartimes = 10;
2285 	
2286 	uint256 private _4chartimes = 6;
2287 	
2288     modifier onlyApprovedOrOwner(uint256 tokenId) {
2289         require(
2290             _isApprovedOrOwner(_msgSender(), tokenId)
2291         );
2292         _;
2293     }
2294 	
2295 	constructor() ERC721("KEKISTANI NAMING SERVICE", ".KEK") {
2296 		
2297 	}
2298 	
2299     function isApprovedOrOwner(address account, uint256 tokenId) external view returns(bool)  {
2300         return _isApprovedOrOwner(account, tokenId);
2301     }
2302 	
2303 	
2304 	function getOwner(string memory domain) external view returns (address)  {
2305 		string memory _domain = StringUtil.toLower(domain);
2306 	    uint256 tokenId = uint256(keccak256(abi.encodePacked(_domain)));
2307         return ownerOf(tokenId);
2308     }
2309 	
2310 	function getDomainbyAddress(address account) external view returns (uint256[] memory tokenIds,  string[] memory domains)  {
2311 		uint256 _balance = balanceOf(account);
2312         require(_balance > 0, "");	
2313         uint256[] memory _tokenIds = new uint256[](_balance);
2314         string[] memory _domains = new string[](_balance);
2315         for (uint256 i = 0; i < _balance; i++) {
2316             uint256 tokenId = tokenOfOwnerByIndex(account, i);
2317             string memory domain = _tokenURIs[tokenId];
2318             _tokenIds[i] = tokenId;
2319             _domains[i] = domain;
2320         }
2321         tokenIds = _tokenIds;
2322         domains = _domains;
2323     }
2324 	
2325 		
2326 	function exists(uint256 tokenId) external view returns (bool) {
2327         return _exists(tokenId);
2328     }
2329 
2330 
2331 	function getPrice() public view returns (uint256) {
2332         return _price;
2333     }
2334 	
2335 	function getPrice2Char() public view returns (uint256) {
2336         return getPrice().mul(_2chartimes);
2337     }
2338 	
2339 	function getPrice3Char() public view returns (uint256) {
2340         return getPrice().mul(_3chartimes);
2341     }
2342 	
2343 	function getPrice4Char() public view returns (uint256) {
2344         return getPrice().mul(_4chartimes);
2345     }
2346 	
2347 	function get2charTimes() public view returns (uint256) {
2348         return _2chartimes;
2349     }
2350 	
2351 	function get3charTimes() public view returns (uint256) {
2352         return _3chartimes;
2353     }
2354 	
2355 	function get4charTimes() public view returns (uint256) {
2356         return _4chartimes;
2357     }
2358 	
2359 	function setTimes(uint256 _2chartimenew, uint256 _3chartimenew, uint256 _4chartimenew) public onlyOwner {
2360 		_2chartimes = _2chartimenew;
2361         _3chartimes = _3chartimenew;
2362 		_4chartimes = _4chartimenew;
2363     }
2364 	
2365 	function setPrice(uint256 price) public onlyOwner {
2366         _price = price;
2367     }
2368 	
2369 	function setSaleStateTwoChar() public onlyOwner {
2370         _saleTwoCharIsActive = !_saleTwoCharIsActive;
2371     }
2372 	
2373 	function setTLD(string memory _tld) public onlyOwner {
2374         uint256 tokenId = genTokenId(_tld);
2375 		_tlds[tokenId] = _tld;
2376     }
2377 	
2378 	function isTLD(string memory _tld) public view returns (bool) {
2379 		bool isExist = false;
2380         uint256 tokenId = genTokenId(_tld);
2381 		if (bytes(_tlds[tokenId]).length != 0){
2382             isExist = true;
2383         }
2384 		return isExist;
2385 	}
2386 	
2387 	function setSaleState() public onlyOwner {
2388         _saleIsActive = !_saleIsActive;
2389     }
2390 	
2391 	function _baseURI() internal view override returns (string memory) {
2392         return _nftBaseURI;
2393     }
2394     
2395     function setBaseURI(string memory _uri) external onlyOwner {
2396         _nftBaseURI = _uri;
2397     }
2398 	
2399 	function tokenURI(uint256 tokenId) public view override returns (string memory) {
2400         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2401 
2402         string memory _tokenURI = _tokenURIs[tokenId];
2403 
2404         // If there is no base URI, return the token URI.
2405 		string memory baseURI = _baseURI();
2406         if (bytes(baseURI).length == 0) {
2407             return _tokenURI;
2408         }
2409         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
2410         if (bytes(_tokenURI).length > 0) {
2411             return string(abi.encodePacked(baseURI, _tokenURI));
2412         }
2413         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
2414         return string(abi.encodePacked(baseURI, tokenId));
2415     }
2416 
2417 	function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
2418         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
2419         _tokenURIs[tokenId] = _tokenURI;
2420     }
2421 	
2422 
2423 	function buyDomain(string memory domain, string memory tld) external payable 
2424 	{
2425 		require(_saleIsActive, "Sale must be active to buy");
2426 		
2427 		require(bytes(tld).length != 0, "Top level domain must be non-empty");
2428 		
2429 		require(isTLD(tld) == true, "Top level domain not exist");
2430 		
2431 		require(StringUtil.dotCount(domain) == 0, "Domains cannot contain dot");
2432 		
2433 		uint256 _length = bytes(domain).length;
2434 		
2435 		require(_length != 0, "Domain must be non-empty");	
2436 		
2437 		require(_length >= 2, "Domain requires at least 2 characters");	
2438 		
2439 		  // Check BookingList
2440 		if (_isBookingListActive == true){
2441 			string memory name = _bookingList[bytes(domain)];
2442 			require(bytes(name).length == 0, "This name is already reserved");
2443 		}
2444 		
2445 		
2446 	    // Check WhiteList
2447 		if (isWhiteListActive == true){
2448 			uint256 numbers = _whiteList[msg.sender];
2449 			require(numbers > 0, "The address is not in the Whitelist");
2450 			require(numbers >= balanceOf(msg.sender), "Exceeded max available to purchase");
2451 		}
2452 		
2453 		if (_length == 2)
2454 		{
2455 			require(_saleTwoCharIsActive == true, "2 Character domain names need to be allowed to buy");
2456 			
2457 			require(msg.value >= getPrice().mul(_2chartimes), "Insufficient Token or Token value sent is not correct");
2458 		}
2459 	
2460 		if (_length == 3)
2461 		{
2462 			require(msg.value >= getPrice().mul(_3chartimes), "Insufficient Token or Token value sent is not correct");
2463 		}
2464 		
2465 		if (_length == 4)
2466 		{
2467 			require(msg.value >= getPrice().mul(_4chartimes), "Insufficient Token or Token value sent is not correct");
2468 		}
2469 		
2470 		if (_length >= 5)
2471 		{
2472 			require(msg.value >= getPrice(), "Insufficient Token or Token value sent is not correct");
2473 		}
2474 		
2475 		string memory _domain = StringUtil.toLower(domain);
2476 		
2477 		string memory _tld = StringUtil.toLower(tld);
2478 		
2479 		_domain = string(abi.encodePacked(_domain, ".", _tld));
2480 		
2481 		uint256 tokenId = genTokenId(_domain);
2482 		
2483 		require (!_exists(tokenId), "Domain already exists");
2484 		
2485 	   _safeMint(msg.sender, tokenId);
2486 	   
2487 	   _setTokenURI(tokenId, _domain);
2488 	   
2489 	   emit NewURI(tokenId, _domain);
2490     }
2491 
2492 	function registerDomain(address to, string memory domain, string memory tld) external onlyMinterController 
2493 	{
2494 		require(to != address(0), "To address is null");
2495 		
2496 		require(bytes(tld).length != 0, "Top level domain must be non-empty");
2497 		
2498 		require(isTLD(tld) == true, "Top level domain not exist");
2499 		
2500 		require(bytes(domain).length != 0, "Domain must be non-empty");	
2501 		
2502 		require(StringUtil.dotCount(domain) == 0, "Domain not support");
2503 
2504 		string memory _domain = StringUtil.toLower(domain);
2505 
2506 		string memory _tld = StringUtil.toLower(tld);
2507 		
2508 		_domain = string(abi.encodePacked(_domain, ".", _tld));
2509 
2510 		uint256 tokenId = genTokenId(_domain);
2511 		
2512 		require (!_exists(tokenId), "Domain already exists");
2513 		
2514        _safeMint(to, tokenId);
2515 	   
2516 	   _setTokenURI(tokenId, _domain);
2517 	   
2518 	   emit NewURI(tokenId, _domain);
2519     }
2520 
2521 	function transferFrom(
2522         address from,
2523         address to,
2524         uint256 tokenId
2525     ) public virtual override(IERC721, ERC721)  {
2526 
2527         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2528 		
2529 		_reset(tokenId);
2530 		
2531         _transfer(from, to, tokenId);
2532     }
2533 
2534     function safeTransferFrom(
2535         address from,
2536         address to,
2537         uint256 tokenId
2538     ) public virtual override(IERC721, ERC721)  {
2539         safeTransferFrom(from, to, tokenId, "");
2540     }
2541 
2542 
2543     function safeTransferFrom(
2544         address from,
2545         address to,
2546         uint256 tokenId,
2547         bytes memory _data
2548     ) public virtual override(IERC721, ERC721) {
2549         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2550 		
2551 		_reset(tokenId);
2552 		
2553         _safeTransfer(from, to, tokenId, _data);
2554     }
2555 		
2556 	function burn(uint256 tokenId) public virtual {
2557         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
2558 		
2559 		if (bytes(_tokenURIs[tokenId]).length != 0) {
2560             delete _tokenURIs[tokenId];
2561         }
2562 		
2563 		if (_tokenReverses[_msgSender()] != 0) {
2564             delete _tokenReverses[_msgSender()];
2565         }
2566 		
2567 		if (_tokenResolvers[tokenId] != address(0)) {
2568             delete _tokenResolvers[tokenId];
2569         }
2570 		
2571 		_reset(tokenId);
2572 
2573         _burn(tokenId);
2574     }
2575 
2576     function setOwner(address to, uint256 tokenId) external onlyApprovedOrOwner(tokenId) {
2577         _transfer(ownerOf(tokenId), to, tokenId);
2578     }
2579 	
2580 	/**
2581      * Begin: set and get Reverses
2582      */
2583 	function reverseOf(address account) public view returns (string memory){
2584         uint256 tokenId = _tokenReverses[account];
2585         require(tokenId != 0, 'ReverseResolver: REVERSE_RECORD_IS_EMPTY');
2586         require(_isApprovedOrOwner(account, tokenId), 'ReverseResolver: ACCOUNT_IS_NOT_APPROVED_OR_OWNER');
2587         return _tokenURIs[tokenId];
2588     }
2589 	
2590 	function setReverse(uint256 tokenId) public {
2591         address _sender = _msgSender();
2592         require(_isApprovedOrOwner(_sender, tokenId), 'ReverseResolver: SENDER_IS_NOT_APPROVED_OR_OWNER');
2593         _tokenReverses[_sender] = tokenId;
2594     }
2595 	
2596 	function setReverse(string memory domain) public {
2597 		uint256 tokenId = genTokenId(domain);
2598         address _sender = _msgSender();
2599         require(_isApprovedOrOwner(_sender, tokenId), 'ReverseResolver: SENDER_IS_NOT_APPROVED_OR_OWNER');
2600         _tokenReverses[_sender] = tokenId;
2601     }
2602 	
2603 	function removeReverse() public {
2604         address _sender = _msgSender();
2605         uint256 tokenId = _tokenReverses[_sender];
2606         require(tokenId != 0, 'ReverseResolver: REVERSE_RECORD_IS_EMPTY');
2607         delete _tokenReverses[_sender];
2608     }
2609 	/**
2610      * End: set and get Reverses
2611      */
2612 	 
2613 	/**
2614 	* Begin set and get Resolver
2615 	**/
2616 	
2617 	function setResolver(uint256 tokenId, address resolver) external onlyApprovedOrOwner(tokenId) {
2618         _setResolver(tokenId, resolver);
2619     }
2620 	
2621 	function resolverOf(string memory domain) external view returns (address) {
2622 		uint256 tokenId = genTokenId(domain);
2623 		if (_exists(tokenId) == false){
2624 			return address(0);
2625 		}
2626 		address resolver = _tokenResolvers[tokenId];
2627         if (resolver == address(0)){
2628 			resolver = address(this);
2629 		}
2630         return resolver;
2631 	}
2632 
2633     function resolverOf(uint256 tokenId) external view returns (address) {
2634 		if (_exists(tokenId) == false){
2635 			return address(0);
2636 		}
2637 		address resolver = _tokenResolvers[tokenId];
2638         if (resolver == address(0)){
2639 			resolver = address(this);
2640 		}
2641         return resolver;
2642     }
2643 	
2644 	function removeResolver(string memory domain) external {
2645         uint256 tokenId = genTokenId(domain);
2646         address _sender = _msgSender();
2647         require(_isApprovedOrOwner(_sender, tokenId), 'ReverseResolver: SENDER_IS_NOT_APPROVED_OR_OWNER');
2648         delete _tokenResolvers[tokenId];
2649     }
2650 	
2651 	function removeResolver(uint256 tokenId) external onlyApprovedOrOwner(tokenId) {
2652         require(tokenId != 0, 'ReverseResolver: REVERSE_RECORD_IS_EMPTY');
2653         delete _tokenResolvers[tokenId];
2654     }
2655     
2656 	function _setResolver(uint256 tokenId, address resolver) internal {
2657         require (_exists(tokenId));
2658         _tokenResolvers[tokenId] = resolver;
2659     }
2660 	/**
2661      * End:Resolver
2662      */
2663 
2664 	/**
2665      * Begin: Subdomain
2666      */
2667     function registerSubDomain(address to, uint256 tokenId, string memory sub) external 
2668         onlyApprovedOrOwner(tokenId) 
2669     {
2670         _safeMintSubDomain(to, tokenId, sub, "");
2671     }
2672 	
2673     function burnSubDomain(uint256 tokenId, string memory sub) external onlyApprovedOrOwner(tokenId) 
2674 	{
2675         _burnSubDomain(tokenId, sub);
2676     }
2677 	
2678 	function _safeMintSubDomain(address to, uint256 tokenId, string memory sub, bytes memory _data) internal {
2679 		require(to != address(0));
2680         require (bytes(sub).length != 0);
2681         require (StringUtil.dotCount(sub) == 0);
2682         require (_exists(tokenId));
2683 		
2684 		string memory _sub = StringUtil.toLower(sub);
2685 		
2686         bytes memory _newUri = abi.encodePacked(_sub, ".", _tokenURIs[tokenId]);
2687 		
2688 		uint256 _newTokenId = genTokenId(string(_newUri));
2689 
2690         uint256 count = StringUtil.dotCount(_tokenURIs[tokenId]);
2691 		
2692         if (count == 1) 
2693 		{
2694             _subTokens[tokenId].add(_newTokenId);
2695         }
2696 
2697         if (bytes(_data).length != 0) {
2698             _safeMint(to, _newTokenId, _data);
2699         } else {
2700             _safeMint(to, _newTokenId);
2701         }
2702         
2703         _setTokenURI(_newTokenId, string(_newUri));
2704 
2705         emit NewURI(_newTokenId, string(_newUri));
2706     }
2707 	
2708 	function _burnSubDomain(uint256 tokenId, string memory sub) internal {
2709         string memory _sub = StringUtil.toLower(sub);
2710 		
2711         bytes memory _newUri = abi.encodePacked(_sub, ".", _tokenURIs[tokenId]);
2712 		
2713 		uint256 _newTokenId = genTokenId(string(_newUri));
2714         // remove sub tokenIds itself
2715         _subTokens[tokenId].remove(_newTokenId);
2716 		
2717 		if (bytes(_tokenURIs[_newTokenId]).length != 0) {
2718             delete _tokenURIs[_newTokenId];
2719         }
2720 		
2721         super._burn(_newTokenId);
2722     }
2723 	function subTokenIdCount(uint256 tokenId) public view returns (uint256) {
2724         require (_exists(tokenId));
2725         return _subTokens[tokenId].length();
2726     }
2727 	
2728 	function subTokenIdByIndex(uint256 tokenId, uint256 index) public view returns (uint256) {
2729         require (subTokenIdCount(tokenId) > index);
2730         return _subTokens[tokenId].at(index);
2731     }
2732 	/**
2733      * End:Subdomain
2734      */
2735 
2736   
2737 	/**
2738      * Begin: System
2739      */
2740 	function genTokenId(string memory label) public pure returns(uint256)  {
2741         require (bytes(label).length != 0);
2742         return uint256(keccak256(abi.encodePacked(label)));
2743     }
2744 
2745     
2746 	function withdraw() external payable onlyOwner {
2747         require(payable(msg.sender).send(address(this).balance));
2748     }
2749 	
2750 	function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
2751 		super._beforeTokenTransfer(from, to, tokenId);
2752 	}
2753 
2754 	function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
2755 		return super.supportsInterface(interfaceId);
2756 	}
2757 	/**
2758      * End: System
2759      */
2760 	/**
2761      * Begin: working with metadata like: avatar, cover, email, phone, address, social ...
2762      */
2763 	function set(
2764         string calldata key,
2765         string calldata value,
2766         uint256 tokenId
2767     ) external onlyApprovedOrOwner(tokenId)  {
2768         _set(key, value, tokenId);
2769     }
2770 
2771     function setMany(
2772         string[] calldata keys,
2773         string[] calldata values,
2774         uint256 tokenId
2775     ) external onlyApprovedOrOwner(tokenId)  {
2776         _setMany(keys, values, tokenId);
2777     }
2778 
2779     function setByHash(
2780         uint256 keyHash,
2781         string calldata value,
2782         uint256 tokenId
2783     ) external override onlyApprovedOrOwner(tokenId)  {
2784         _setByHash(keyHash, value, tokenId);
2785     }
2786 
2787     function setManyByHash(
2788         uint256[] calldata keyHashes,
2789         string[] calldata values,
2790         uint256 tokenId
2791     ) external override onlyApprovedOrOwner(tokenId)  {
2792         _setManyByHash(keyHashes, values, tokenId);
2793     }
2794 
2795     function reconfigure(
2796         string[] calldata keys,
2797         string[] calldata values,
2798         uint256 tokenId
2799     ) external override onlyApprovedOrOwner(tokenId) {
2800         _reconfigure(keys, values, tokenId);
2801     }
2802 
2803     function reset(uint256 tokenId) external override onlyApprovedOrOwner(tokenId) {
2804         _reset(tokenId);
2805     }
2806 	/**
2807      * End: metadata
2808      */
2809 }