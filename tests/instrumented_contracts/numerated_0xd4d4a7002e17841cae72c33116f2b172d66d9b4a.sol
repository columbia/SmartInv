1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.7;
3 // File: SafeMath.sol
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b)
25         internal
26         pure
27         returns (bool, uint256)
28     {
29         uint256 c = a + b;
30         if (c < a) return (false, 0);
31         return (true, c);
32     }
33 
34     /**
35      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
36      *
37      * _Available since v3.4._
38      */
39     function trySub(uint256 a, uint256 b)
40         internal
41         pure
42         returns (bool, uint256)
43     {
44         if (b > a) return (false, 0);
45         return (true, a - b);
46     }
47 
48     /**
49      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
50      *
51      * _Available since v3.4._
52      */
53     function tryMul(uint256 a, uint256 b)
54         internal
55         pure
56         returns (bool, uint256)
57     {
58         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
59         // benefit is lost if 'b' is also tested.
60         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
61         if (a == 0) return (true, 0);
62         uint256 c = a * b;
63         if (c / a != b) return (false, 0);
64         return (true, c);
65     }
66 
67     /**
68      * @dev Returns the division of two unsigned integers, with a division by zero flag.
69      *
70      * _Available since v3.4._
71      */
72     function tryDiv(uint256 a, uint256 b)
73         internal
74         pure
75         returns (bool, uint256)
76     {
77         if (b == 0) return (false, 0);
78         return (true, a / b);
79     }
80 
81     /**
82      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
83      *
84      * _Available since v3.4._
85      */
86     function tryMod(uint256 a, uint256 b)
87         internal
88         pure
89         returns (bool, uint256)
90     {
91         if (b == 0) return (false, 0);
92         return (true, a % b);
93     }
94 
95     /**
96      * @dev Returns the addition of two unsigned integers, reverting on
97      * overflow.
98      *
99      * Counterpart to Solidity's `+` operator.
100      *
101      * Requirements:
102      *
103      * - Addition cannot overflow.
104      */
105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
106         uint256 c = a + b;
107         require(c >= a, "SafeMath: addition overflow");
108         return c;
109     }
110 
111     /**
112      * @dev Returns the subtraction of two unsigned integers, reverting on
113      * overflow (when the result is negative).
114      *
115      * Counterpart to Solidity's `-` operator.
116      *
117      * Requirements:
118      *
119      * - Subtraction cannot overflow.
120      */
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         require(b <= a, "SafeMath: subtraction overflow");
123         return a - b;
124     }
125 
126     /**
127      * @dev Returns the multiplication of two unsigned integers, reverting on
128      * overflow.
129      *
130      * Counterpart to Solidity's `*` operator.
131      *
132      * Requirements:
133      *
134      * - Multiplication cannot overflow.
135      */
136     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
137         if (a == 0) return 0;
138         uint256 c = a * b;
139         require(c / a == b, "SafeMath: multiplication overflow");
140         return c;
141     }
142 
143     /**
144      * @dev Returns the integer division of two unsigned integers, reverting on
145      * division by zero. The result is rounded towards zero.
146      *
147      * Counterpart to Solidity's `/` operator. Note: this function uses a
148      * `revert` opcode (which leaves remaining gas untouched) while Solidity
149      * uses an invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function div(uint256 a, uint256 b) internal pure returns (uint256) {
156         require(b > 0, "SafeMath: division by zero");
157         return a / b;
158     }
159 
160     /**
161      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
162      * reverting when dividing by zero.
163      *
164      * Counterpart to Solidity's `%` operator. This function uses a `revert`
165      * opcode (which leaves remaining gas untouched) while Solidity uses an
166      * invalid opcode to revert (consuming all remaining gas).
167      *
168      * Requirements:
169      *
170      * - The divisor cannot be zero.
171      */
172     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
173         require(b > 0, "SafeMath: modulo by zero");
174         return a % b;
175     }
176 
177     /**
178      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
179      * overflow (when the result is negative).
180      *
181      * CAUTION: This function is deprecated because it requires allocating memory for the error
182      * message unnecessarily. For custom revert reasons use {trySub}.
183      *
184      * Counterpart to Solidity's `-` operator.
185      *
186      * Requirements:
187      *
188      * - Subtraction cannot overflow.
189      */
190     function sub(
191         uint256 a,
192         uint256 b,
193         string memory errorMessage
194     ) internal pure returns (uint256) {
195         require(b <= a, errorMessage);
196         return a - b;
197     }
198 
199     /**
200      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
201      * division by zero. The result is rounded towards zero.
202      *
203      * CAUTION: This function is deprecated because it requires allocating memory for the error
204      * message unnecessarily. For custom revert reasons use {tryDiv}.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function div(
215         uint256 a,
216         uint256 b,
217         string memory errorMessage
218     ) internal pure returns (uint256) {
219         require(b > 0, errorMessage);
220         return a / b;
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * reverting with custom message when dividing by zero.
226      *
227      * CAUTION: This function is deprecated because it requires allocating memory for the error
228      * message unnecessarily. For custom revert reasons use {tryMod}.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(
239         uint256 a,
240         uint256 b,
241         string memory errorMessage
242     ) internal pure returns (uint256) {
243         require(b > 0, errorMessage);
244         return a % b;
245     }
246 }
247 // File: Strings.sol
248 
249 
250 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
251 
252 
253 /**
254  * @dev String operations.
255  */
256 library Strings {
257     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
258 
259     /**
260      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
261      */
262     function toString(uint256 value) internal pure returns (string memory) {
263         // Inspired by OraclizeAPI's implementation - MIT licence
264         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
265 
266         if (value == 0) {
267             return "0";
268         }
269         uint256 temp = value;
270         uint256 digits;
271         while (temp != 0) {
272             digits++;
273             temp /= 10;
274         }
275         bytes memory buffer = new bytes(digits);
276         while (value != 0) {
277             digits -= 1;
278             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
279             value /= 10;
280         }
281         return string(buffer);
282     }
283 
284     /**
285      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
286      */
287     function toHexString(uint256 value) internal pure returns (string memory) {
288         if (value == 0) {
289             return "0x00";
290         }
291         uint256 temp = value;
292         uint256 length = 0;
293         while (temp != 0) {
294             length++;
295             temp >>= 8;
296         }
297         return toHexString(value, length);
298     }
299 
300     /**
301      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
302      */
303     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
304         bytes memory buffer = new bytes(2 * length + 2);
305         buffer[0] = "0";
306         buffer[1] = "x";
307         for (uint256 i = 2 * length + 1; i > 1; --i) {
308             buffer[i] = _HEX_SYMBOLS[value & 0xf];
309             value >>= 4;
310         }
311         require(value == 0, "Strings: hex length insufficient");
312         return string(buffer);
313     }
314 }
315 // File: Context.sol
316 
317 
318 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
319 
320 
321 /**
322  * @dev Provides information about the current execution context, including the
323  * sender of the transaction and its data. While these are generally available
324  * via msg.sender and msg.data, they should not be accessed in such a direct
325  * manner, since when dealing with meta-transactions the account sending and
326  * paying for execution may not be the actual sender (as far as an application
327  * is concerned).
328  *
329  * This contract is only required for intermediate, library-like contracts.
330  */
331 abstract contract Context {
332     function _msgSender() internal view virtual returns (address) {
333         return msg.sender;
334     }
335 
336     function _msgData() internal view virtual returns (bytes calldata) {
337         return msg.data;
338     }
339 }
340 // File: Ownable.sol
341 
342 
343 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
344 
345 
346 
347 /**
348  * @dev Contract module which provides a basic access control mechanism, where
349  * there is an account (an owner) that can be granted exclusive access to
350  * specific functions.
351  *
352  * By default, the owner account will be the one that deploys the contract. This
353  * can later be changed with {transferOwnership}.
354  *
355  * This module is used through inheritance. It will make available the modifier
356  * `onlyOwner`, which can be applied to your functions to restrict their use to
357  * the owner.
358  */
359 abstract contract Ownable is Context {
360     address private _owner;
361 
362     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
363 
364     /**
365      * @dev Initializes the contract setting the deployer as the initial owner.
366      */
367     constructor() {
368         _transferOwnership(_msgSender());
369     }
370 
371     /**
372      * @dev Returns the address of the current owner.
373      */
374     function owner() public view virtual returns (address) {
375         return _owner;
376     }
377 
378     /**
379      * @dev Throws if called by any account other than the owner.
380      */
381     modifier onlyOwner() {
382         require(owner() == _msgSender(), "Ownable: caller is not the owner");
383         _;
384     }
385 
386     /**
387      * @dev Leaves the contract without owner. It will not be possible to call
388      * `onlyOwner` functions anymore. Can only be called by the current owner.
389      *
390      * NOTE: Renouncing ownership will leave the contract without an owner,
391      * thereby removing any functionality that is only available to the owner.
392      */
393     function renounceOwnership() public virtual onlyOwner {
394         _transferOwnership(address(0));
395     }
396 
397     /**
398      * @dev Transfers ownership of the contract to a new account (`newOwner`).
399      * Can only be called by the current owner.
400      */
401     function transferOwnership(address newOwner) public virtual onlyOwner {
402         require(newOwner != address(0), "Ownable: new owner is the zero address");
403         _transferOwnership(newOwner);
404     }
405 
406     /**
407      * @dev Transfers ownership of the contract to a new account (`newOwner`).
408      * Internal function without access restriction.
409      */
410     function _transferOwnership(address newOwner) internal virtual {
411         address oldOwner = _owner;
412         _owner = newOwner;
413         emit OwnershipTransferred(oldOwner, newOwner);
414     }
415 }
416 // File: Address.sol
417 
418 
419 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
420 
421 
422 /**
423  * @dev Collection of functions related to the address type
424  */
425 library Address {
426     /**
427      * @dev Returns true if `account` is a contract.
428      *
429      * [IMPORTANT]
430      * ====
431      * It is unsafe to assume that an address for which this function returns
432      * false is an externally-owned account (EOA) and not a contract.
433      *
434      * Among others, `isContract` will return false for the following
435      * types of addresses:
436      *
437      *  - an externally-owned account
438      *  - a contract in construction
439      *  - an address where a contract will be created
440      *  - an address where a contract lived, but was destroyed
441      * ====
442      *
443      * [IMPORTANT]
444      * ====
445      * You shouldn't rely on `isContract` to protect against flash loan attacks!
446      *
447      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
448      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
449      * constructor.
450      * ====
451      */
452     function isContract(address account) internal view returns (bool) {
453         // This method relies on extcodesize/address.code.length, which returns 0
454         // for contracts in construction, since the code is only stored at the end
455         // of the constructor execution.
456 
457         return account.code.length > 0;
458     }
459 
460     /**
461      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
462      * `recipient`, forwarding all available gas and reverting on errors.
463      *
464      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
465      * of certain opcodes, possibly making contracts go over the 2300 gas limit
466      * imposed by `transfer`, making them unable to receive funds via
467      * `transfer`. {sendValue} removes this limitation.
468      *
469      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
470      *
471      * IMPORTANT: because control is transferred to `recipient`, care must be
472      * taken to not create reentrancy vulnerabilities. Consider using
473      * {ReentrancyGuard} or the
474      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
475      */
476     function sendValue(address payable recipient, uint256 amount) internal {
477         require(address(this).balance >= amount, "Address: insufficient balance");
478 
479         (bool success, ) = recipient.call{value: amount}("");
480         require(success, "Address: unable to send value, recipient may have reverted");
481     }
482 
483     /**
484      * @dev Performs a Solidity function call using a low level `call`. A
485      * plain `call` is an unsafe replacement for a function call: use this
486      * function instead.
487      *
488      * If `target` reverts with a revert reason, it is bubbled up by this
489      * function (like regular Solidity function calls).
490      *
491      * Returns the raw returned data. To convert to the expected return value,
492      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
493      *
494      * Requirements:
495      *
496      * - `target` must be a contract.
497      * - calling `target` with `data` must not revert.
498      *
499      * _Available since v3.1._
500      */
501     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
502         return functionCall(target, data, "Address: low-level call failed");
503     }
504 
505     /**
506      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
507      * `errorMessage` as a fallback revert reason when `target` reverts.
508      *
509      * _Available since v3.1._
510      */
511     function functionCall(
512         address target,
513         bytes memory data,
514         string memory errorMessage
515     ) internal returns (bytes memory) {
516         return functionCallWithValue(target, data, 0, errorMessage);
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
521      * but also transferring `value` wei to `target`.
522      *
523      * Requirements:
524      *
525      * - the calling contract must have an ETH balance of at least `value`.
526      * - the called Solidity function must be `payable`.
527      *
528      * _Available since v3.1._
529      */
530     function functionCallWithValue(
531         address target,
532         bytes memory data,
533         uint256 value
534     ) internal returns (bytes memory) {
535         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
536     }
537 
538     /**
539      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
540      * with `errorMessage` as a fallback revert reason when `target` reverts.
541      *
542      * _Available since v3.1._
543      */
544     function functionCallWithValue(
545         address target,
546         bytes memory data,
547         uint256 value,
548         string memory errorMessage
549     ) internal returns (bytes memory) {
550         require(address(this).balance >= value, "Address: insufficient balance for call");
551         require(isContract(target), "Address: call to non-contract");
552 
553         (bool success, bytes memory returndata) = target.call{value: value}(data);
554         return verifyCallResult(success, returndata, errorMessage);
555     }
556 
557     /**
558      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
559      * but performing a static call.
560      *
561      * _Available since v3.3._
562      */
563     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
564         return functionStaticCall(target, data, "Address: low-level static call failed");
565     }
566 
567     /**
568      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
569      * but performing a static call.
570      *
571      * _Available since v3.3._
572      */
573     function functionStaticCall(
574         address target,
575         bytes memory data,
576         string memory errorMessage
577     ) internal view returns (bytes memory) {
578         require(isContract(target), "Address: static call to non-contract");
579 
580         (bool success, bytes memory returndata) = target.staticcall(data);
581         return verifyCallResult(success, returndata, errorMessage);
582     }
583 
584     /**
585      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
586      * but performing a delegate call.
587      *
588      * _Available since v3.4._
589      */
590     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
591         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
592     }
593 
594     /**
595      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
596      * but performing a delegate call.
597      *
598      * _Available since v3.4._
599      */
600     function functionDelegateCall(
601         address target,
602         bytes memory data,
603         string memory errorMessage
604     ) internal returns (bytes memory) {
605         require(isContract(target), "Address: delegate call to non-contract");
606 
607         (bool success, bytes memory returndata) = target.delegatecall(data);
608         return verifyCallResult(success, returndata, errorMessage);
609     }
610 
611     /**
612      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
613      * revert reason using the provided one.
614      *
615      * _Available since v4.3._
616      */
617     function verifyCallResult(
618         bool success,
619         bytes memory returndata,
620         string memory errorMessage
621     ) internal pure returns (bytes memory) {
622         if (success) {
623             return returndata;
624         } else {
625             // Look for revert reason and bubble it up if present
626             if (returndata.length > 0) {
627                 // The easiest way to bubble the revert reason is using memory via assembly
628 
629                 assembly {
630                     let returndata_size := mload(returndata)
631                     revert(add(32, returndata), returndata_size)
632                 }
633             } else {
634                 revert(errorMessage);
635             }
636         }
637     }
638 }
639 // File: IERC721Receiver.sol
640 
641 
642 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
643 
644 
645 /**
646  * @title ERC721 token receiver interface
647  * @dev Interface for any contract that wants to support safeTransfers
648  * from ERC721 asset contracts.
649  */
650 interface IERC721Receiver {
651     /**
652      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
653      * by `operator` from `from`, this function is called.
654      *
655      * It must return its Solidity selector to confirm the token transfer.
656      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
657      *
658      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
659      */
660     function onERC721Received(
661         address operator,
662         address from,
663         uint256 tokenId,
664         bytes calldata data
665     ) external returns (bytes4);
666 }
667 // File: IERC165.sol
668 
669 
670 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
671 
672 
673 /**
674  * @dev Interface of the ERC165 standard, as defined in the
675  * https://eips.ethereum.org/EIPS/eip-165[EIP].
676  *
677  * Implementers can declare support of contract interfaces, which can then be
678  * queried by others ({ERC165Checker}).
679  *
680  * For an implementation, see {ERC165}.
681  */
682 interface IERC165 {
683     /**
684      * @dev Returns true if this contract implements the interface defined by
685      * `interfaceId`. See the corresponding
686      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
687      * to learn more about how these ids are created.
688      *
689      * This function call must use less than 30 000 gas.
690      */
691     function supportsInterface(bytes4 interfaceId) external view returns (bool);
692 }
693 // File: ERC165.sol
694 
695 
696 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
697 
698 
699 
700 /**
701  * @dev Implementation of the {IERC165} interface.
702  *
703  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
704  * for the additional interface id that will be supported. For example:
705  *
706  * ```solidity
707  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
708  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
709  * }
710  * ```
711  *
712  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
713  */
714 abstract contract ERC165 is IERC165 {
715     /**
716      * @dev See {IERC165-supportsInterface}.
717      */
718     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
719         return interfaceId == type(IERC165).interfaceId;
720     }
721 }
722 // File: IERC721.sol
723 
724 
725 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
726 
727 
728 
729 /**
730  * @dev Required interface of an ERC721 compliant contract.
731  */
732 interface IERC721 is IERC165 {
733     /**
734      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
735      */
736     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
737 
738     /**
739      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
740      */
741     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
742 
743     /**
744      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
745      */
746     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
747 
748     /**
749      * @dev Returns the number of tokens in ``owner``'s account.
750      */
751     function balanceOf(address owner) external view returns (uint256 balance);
752 
753     /**
754      * @dev Returns the owner of the `tokenId` token.
755      *
756      * Requirements:
757      *
758      * - `tokenId` must exist.
759      */
760     function ownerOf(uint256 tokenId) external view returns (address owner);
761 
762     /**
763      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
764      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
765      *
766      * Requirements:
767      *
768      * - `from` cannot be the zero address.
769      * - `to` cannot be the zero address.
770      * - `tokenId` token must exist and be owned by `from`.
771      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
772      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
773      *
774      * Emits a {Transfer} event.
775      */
776     function safeTransferFrom(
777         address from,
778         address to,
779         uint256 tokenId
780     ) external;
781 
782     /**
783      * @dev Transfers `tokenId` token from `from` to `to`.
784      *
785      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
786      *
787      * Requirements:
788      *
789      * - `from` cannot be the zero address.
790      * - `to` cannot be the zero address.
791      * - `tokenId` token must be owned by `from`.
792      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
793      *
794      * Emits a {Transfer} event.
795      */
796     function transferFrom(
797         address from,
798         address to,
799         uint256 tokenId
800     ) external;
801 
802     /**
803      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
804      * The approval is cleared when the token is transferred.
805      *
806      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
807      *
808      * Requirements:
809      *
810      * - The caller must own the token or be an approved operator.
811      * - `tokenId` must exist.
812      *
813      * Emits an {Approval} event.
814      */
815     function approve(address to, uint256 tokenId) external;
816 
817     /**
818      * @dev Returns the account approved for `tokenId` token.
819      *
820      * Requirements:
821      *
822      * - `tokenId` must exist.
823      */
824     function getApproved(uint256 tokenId) external view returns (address operator);
825 
826     /**
827      * @dev Approve or remove `operator` as an operator for the caller.
828      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
829      *
830      * Requirements:
831      *
832      * - The `operator` cannot be the caller.
833      *
834      * Emits an {ApprovalForAll} event.
835      */
836     function setApprovalForAll(address operator, bool _approved) external;
837 
838     /**
839      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
840      *
841      * See {setApprovalForAll}
842      */
843     function isApprovedForAll(address owner, address operator) external view returns (bool);
844 
845     /**
846      * @dev Safely transfers `tokenId` token from `from` to `to`.
847      *
848      * Requirements:
849      *
850      * - `from` cannot be the zero address.
851      * - `to` cannot be the zero address.
852      * - `tokenId` token must exist and be owned by `from`.
853      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
854      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
855      *
856      * Emits a {Transfer} event.
857      */
858     function safeTransferFrom(
859         address from,
860         address to,
861         uint256 tokenId,
862         bytes calldata data
863     ) external;
864 }
865 // File: IERC721Enumerable.sol
866 
867 
868 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
869 
870 
871 
872 /**
873  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
874  * @dev See https://eips.ethereum.org/EIPS/eip-721
875  */
876 interface IERC721Enumerable is IERC721 {
877     /**
878      * @dev Returns the total amount of tokens stored by the contract.
879      */
880     function totalSupply() external view returns (uint256);
881 
882     /**
883      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
884      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
885      */
886     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
887 
888     /**
889      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
890      * Use along with {totalSupply} to enumerate all tokens.
891      */
892     function tokenByIndex(uint256 index) external view returns (uint256);
893 }
894 // File: IERC721Metadata.sol
895 
896 
897 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
898 
899 
900 
901 /**
902  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
903  * @dev See https://eips.ethereum.org/EIPS/eip-721
904  */
905 interface IERC721Metadata is IERC721 {
906     /**
907      * @dev Returns the token collection name.
908      */
909     function name() external view returns (string memory);
910 
911     /**
912      * @dev Returns the token collection symbol.
913      */
914     function symbol() external view returns (string memory);
915 
916     /**
917      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
918      */
919     function tokenURI(uint256 tokenId) external view returns (string memory);
920 }
921 // File: ERC721A.sol
922 
923 error ApprovalCallerNotOwnerNorApproved();
924 error ApprovalQueryForNonexistentToken();
925 error ApproveToCaller();
926 error ApprovalToCurrentOwner();
927 error BalanceQueryForZeroAddress();
928 error MintedQueryForZeroAddress();
929 error BurnedQueryForZeroAddress();
930 error MintToZeroAddress();
931 error MintZeroQuantity();
932 error OwnerIndexOutOfBounds();
933 error OwnerQueryForNonexistentToken();
934 error TokenIndexOutOfBounds();
935 error TransferCallerNotOwnerNorApproved();
936 error TransferFromIncorrectOwner();
937 error TransferToNonERC721ReceiverImplementer();
938 error TransferToZeroAddress();
939 error URIQueryForNonexistentToken();
940 
941 /**
942  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
943  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
944  *
945  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
946  *
947  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
948  *
949  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
950  */
951 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
952     using Address for address;
953     using Strings for uint256;
954 
955     // Compiler will pack this into a single 256bit word.
956     struct TokenOwnership {
957         // The address of the owner.
958         address addr;
959         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
960         uint64 startTimestamp;
961         // Whether the token has been burned.
962         bool burned;
963     }
964 
965     // Compiler will pack this into a single 256bit word.
966     struct AddressData {
967         // Realistically, 2**64-1 is more than enough.
968         uint64 balance;
969         // Keeps track of mint count with minimal overhead for tokenomics.
970         uint64 numberMinted;
971         // Keeps track of burn count with minimal overhead for tokenomics.
972         uint64 numberBurned;
973     }
974 
975     // Compiler will pack the following 
976     // _currentIndex and _burnCounter into a single 256bit word.
977     
978     // The tokenId of the next token to be minted.
979     uint128 internal _currentIndex;
980 
981     // The number of tokens burned.
982     uint128 internal _burnCounter;
983 
984     // Token name
985     string private _name;
986 
987     // Token symbol
988     string private _symbol;
989 
990     // Mapping from token ID to ownership details
991     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
992     mapping(uint256 => TokenOwnership) internal _ownerships;
993 
994     // Mapping owner address to address data
995     mapping(address => AddressData) private _addressData;
996 
997     // Mapping from token ID to approved address
998     mapping(uint256 => address) private _tokenApprovals;
999 
1000     // Mapping from owner to operator approvals
1001     mapping(address => mapping(address => bool)) private _operatorApprovals;
1002 
1003     constructor(string memory name_, string memory symbol_) {
1004         _name = name_;
1005         _symbol = symbol_;
1006     }
1007 
1008     /**
1009      * @dev See {IERC721Enumerable-totalSupply}.
1010      */
1011     function totalSupply() public view override returns (uint256) {
1012         // Counter underflow is impossible as _burnCounter cannot be incremented
1013         // more than _currentIndex times
1014         unchecked {
1015             return _currentIndex - _burnCounter;    
1016         }
1017     }
1018 
1019     /**
1020      * @dev See {IERC721Enumerable-tokenByIndex}.
1021      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1022      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1023      */
1024     function tokenByIndex(uint256 index) public view override returns (uint256) {
1025         uint256 numMintedSoFar = _currentIndex;
1026         uint256 tokenIdsIdx;
1027 
1028         // Counter overflow is impossible as the loop breaks when
1029         // uint256 i is equal to another uint256 numMintedSoFar.
1030         unchecked {
1031             for (uint256 i; i < numMintedSoFar; i++) {
1032                 TokenOwnership memory ownership = _ownerships[i];
1033                 if (!ownership.burned) {
1034                     if (tokenIdsIdx == index) {
1035                         return i;
1036                     }
1037                     tokenIdsIdx++;
1038                 }
1039             }
1040         }
1041         revert TokenIndexOutOfBounds();
1042     }
1043 
1044     /**
1045      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1046      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1047      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1048      */
1049     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1050         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
1051         uint256 numMintedSoFar = _currentIndex;
1052         uint256 tokenIdsIdx;
1053         address currOwnershipAddr;
1054 
1055         // Counter overflow is impossible as the loop breaks when
1056         // uint256 i is equal to another uint256 numMintedSoFar.
1057         unchecked {
1058             for (uint256 i; i < numMintedSoFar; i++) {
1059                 TokenOwnership memory ownership = _ownerships[i];
1060                 if (ownership.burned) {
1061                     continue;
1062                 }
1063                 if (ownership.addr != address(0)) {
1064                     currOwnershipAddr = ownership.addr;
1065                 }
1066                 if (currOwnershipAddr == owner) {
1067                     if (tokenIdsIdx == index) {
1068                         return i;
1069                     }
1070                     tokenIdsIdx++;
1071                 }
1072             }
1073         }
1074 
1075         // Execution should never reach this point.
1076         revert();
1077     }
1078 
1079     /**
1080      * @dev See {IERC165-supportsInterface}.
1081      */
1082     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1083         return
1084             interfaceId == type(IERC721).interfaceId ||
1085             interfaceId == type(IERC721Metadata).interfaceId ||
1086             interfaceId == type(IERC721Enumerable).interfaceId ||
1087             super.supportsInterface(interfaceId);
1088     }
1089 
1090     /**
1091      * @dev See {IERC721-balanceOf}.
1092      */
1093     function balanceOf(address owner) public view override returns (uint256) {
1094         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1095         return uint256(_addressData[owner].balance);
1096     }
1097 
1098     function _numberMinted(address owner) internal view returns (uint256) {
1099         if (owner == address(0)) revert MintedQueryForZeroAddress();
1100         return uint256(_addressData[owner].numberMinted);
1101     }
1102 
1103     function _numberBurned(address owner) internal view returns (uint256) {
1104         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1105         return uint256(_addressData[owner].numberBurned);
1106     }
1107 
1108     /**
1109      * Gas spent here starts off proportional to the maximum mint batch size.
1110      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1111      */
1112     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1113         uint256 curr = tokenId;
1114 
1115         unchecked {
1116             if (curr < _currentIndex) {
1117                 TokenOwnership memory ownership = _ownerships[curr];
1118                 if (!ownership.burned) {
1119                     if (ownership.addr != address(0)) {
1120                         return ownership;
1121                     }
1122                     // Invariant: 
1123                     // There will always be an ownership that has an address and is not burned 
1124                     // before an ownership that does not have an address and is not burned.
1125                     // Hence, curr will not underflow.
1126                     while (true) {
1127                         curr--;
1128                         ownership = _ownerships[curr];
1129                         if (ownership.addr != address(0)) {
1130                             return ownership;
1131                         }
1132                     }
1133                 }
1134             }
1135         }
1136         revert OwnerQueryForNonexistentToken();
1137     }
1138 
1139     /**
1140      * @dev See {IERC721-ownerOf}.
1141      */
1142     function ownerOf(uint256 tokenId) public view override returns (address) {
1143         return ownershipOf(tokenId).addr;
1144     }
1145 
1146     /**
1147      * @dev See {IERC721Metadata-name}.
1148      */
1149     function name() public view virtual override returns (string memory) {
1150         return _name;
1151     }
1152 
1153     /**
1154      * @dev See {IERC721Metadata-symbol}.
1155      */
1156     function symbol() public view virtual override returns (string memory) {
1157         return _symbol;
1158     }
1159 
1160     /**
1161      * @dev See {IERC721Metadata-tokenURI}.
1162      */
1163     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1164         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1165 
1166         string memory baseURI = _baseURI();
1167         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1168     }
1169 
1170     /**
1171      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1172      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1173      * by default, can be overriden in child contracts.
1174      */
1175     function _baseURI() internal view virtual returns (string memory) {
1176         return '';
1177     }
1178 
1179     /**
1180      * @dev See {IERC721-approve}.
1181      */
1182     function approve(address to, uint256 tokenId) public override {
1183         address owner = ERC721A.ownerOf(tokenId);
1184         if (to == owner) revert ApprovalToCurrentOwner();
1185 
1186         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1187             revert ApprovalCallerNotOwnerNorApproved();
1188         }
1189 
1190         _approve(to, tokenId, owner);
1191     }
1192 
1193     /**
1194      * @dev See {IERC721-getApproved}.
1195      */
1196     function getApproved(uint256 tokenId) public view override returns (address) {
1197         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1198 
1199         return _tokenApprovals[tokenId];
1200     }
1201 
1202     /**
1203      * @dev See {IERC721-setApprovalForAll}.
1204      */
1205     function setApprovalForAll(address operator, bool approved) public override {
1206         if (operator == _msgSender()) revert ApproveToCaller();
1207 
1208         _operatorApprovals[_msgSender()][operator] = approved;
1209         emit ApprovalForAll(_msgSender(), operator, approved);
1210     }
1211 
1212     /**
1213      * @dev See {IERC721-isApprovedForAll}.
1214      */
1215     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1216         return _operatorApprovals[owner][operator];
1217     }
1218 
1219     /**
1220      * @dev See {IERC721-transferFrom}.
1221      */
1222     function transferFrom(
1223         address from,
1224         address to,
1225         uint256 tokenId
1226     ) public virtual override {
1227         _transfer(from, to, tokenId);
1228     }
1229 
1230     /**
1231      * @dev See {IERC721-safeTransferFrom}.
1232      */
1233     function safeTransferFrom(
1234         address from,
1235         address to,
1236         uint256 tokenId
1237     ) public virtual override {
1238         safeTransferFrom(from, to, tokenId, '');
1239     }
1240 
1241     /**
1242      * @dev See {IERC721-safeTransferFrom}.
1243      */
1244     function safeTransferFrom(
1245         address from,
1246         address to,
1247         uint256 tokenId,
1248         bytes memory _data
1249     ) public virtual override {
1250         _transfer(from, to, tokenId);
1251         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1252             revert TransferToNonERC721ReceiverImplementer();
1253         }
1254     }
1255 
1256     /**
1257      * @dev Returns whether `tokenId` exists.
1258      *
1259      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1260      *
1261      * Tokens start existing when they are minted (`_mint`),
1262      */
1263     function _exists(uint256 tokenId) internal view returns (bool) {
1264         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1265     }
1266 
1267     function _safeMint(address to, uint256 quantity) internal {
1268         _safeMint(to, quantity, '');
1269     }
1270 
1271     /**
1272      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1273      *
1274      * Requirements:
1275      *
1276      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1277      * - `quantity` must be greater than 0.
1278      *
1279      * Emits a {Transfer} event.
1280      */
1281     function _safeMint(
1282         address to,
1283         uint256 quantity,
1284         bytes memory _data
1285     ) internal {
1286         _mint(to, quantity, _data, true);
1287     }
1288 
1289     /**
1290      * @dev Mints `quantity` tokens and transfers them to `to`.
1291      *
1292      * Requirements:
1293      *
1294      * - `to` cannot be the zero address.
1295      * - `quantity` must be greater than 0.
1296      *
1297      * Emits a {Transfer} event.
1298      */
1299     function _mint(
1300         address to,
1301         uint256 quantity,
1302         bytes memory _data,
1303         bool safe
1304     ) internal {
1305         uint256 startTokenId = _currentIndex;
1306         if (to == address(0)) revert MintToZeroAddress();
1307         if (quantity == 0) revert MintZeroQuantity();
1308 
1309         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1310 
1311         // Overflows are incredibly unrealistic.
1312         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1313         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1314         unchecked {
1315             _addressData[to].balance += uint64(quantity);
1316             _addressData[to].numberMinted += uint64(quantity);
1317 
1318             _ownerships[startTokenId].addr = to;
1319             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1320 
1321             uint256 updatedIndex = startTokenId;
1322             for (uint256 i; i < quantity; i++) {
1323                 emit Transfer(address(0), to, updatedIndex);
1324                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1325                     revert TransferToNonERC721ReceiverImplementer();
1326                 }
1327                 updatedIndex++;
1328             }
1329 
1330             _currentIndex = uint128(updatedIndex);
1331         }
1332         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1333     }
1334 
1335     /**
1336      * @dev Transfers `tokenId` from `from` to `to`.
1337      *
1338      * Requirements:
1339      *
1340      * - `to` cannot be the zero address.
1341      * - `tokenId` token must be owned by `from`.
1342      *
1343      * Emits a {Transfer} event.
1344      */
1345     function _transfer(
1346         address from,
1347         address to,
1348         uint256 tokenId
1349     ) private {
1350         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1351 
1352         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1353             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1354             getApproved(tokenId) == _msgSender());
1355 
1356         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1357         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1358         if (to == address(0)) revert TransferToZeroAddress();
1359 
1360         _beforeTokenTransfers(from, to, tokenId, 1);
1361 
1362         // Clear approvals from the previous owner
1363         _approve(address(0), tokenId, prevOwnership.addr);
1364 
1365         // Underflow of the sender's balance is impossible because we check for
1366         // ownership above and the recipient's balance can't realistically overflow.
1367         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1368         unchecked {
1369             _addressData[from].balance -= 1;
1370             _addressData[to].balance += 1;
1371 
1372             _ownerships[tokenId].addr = to;
1373             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1374 
1375             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1376             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1377             uint256 nextTokenId = tokenId + 1;
1378             if (_ownerships[nextTokenId].addr == address(0)) {
1379                 // This will suffice for checking _exists(nextTokenId),
1380                 // as a burned slot cannot contain the zero address.
1381                 if (nextTokenId < _currentIndex) {
1382                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1383                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1384                 }
1385             }
1386         }
1387 
1388         emit Transfer(from, to, tokenId);
1389         _afterTokenTransfers(from, to, tokenId, 1);
1390     }
1391 
1392     /**
1393      * @dev Destroys `tokenId`.
1394      * The approval is cleared when the token is burned.
1395      *
1396      * Requirements:
1397      *
1398      * - `tokenId` must exist.
1399      *
1400      * Emits a {Transfer} event.
1401      */
1402     function _burn(uint256 tokenId) internal virtual {
1403         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1404 
1405         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1406 
1407         // Clear approvals from the previous owner
1408         _approve(address(0), tokenId, prevOwnership.addr);
1409 
1410         // Underflow of the sender's balance is impossible because we check for
1411         // ownership above and the recipient's balance can't realistically overflow.
1412         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1413         unchecked {
1414             _addressData[prevOwnership.addr].balance -= 1;
1415             _addressData[prevOwnership.addr].numberBurned += 1;
1416 
1417             // Keep track of who burned the token, and the timestamp of burning.
1418             _ownerships[tokenId].addr = prevOwnership.addr;
1419             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1420             _ownerships[tokenId].burned = true;
1421 
1422             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1423             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1424             uint256 nextTokenId = tokenId + 1;
1425             if (_ownerships[nextTokenId].addr == address(0)) {
1426                 // This will suffice for checking _exists(nextTokenId),
1427                 // as a burned slot cannot contain the zero address.
1428                 if (nextTokenId < _currentIndex) {
1429                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1430                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1431                 }
1432             }
1433         }
1434 
1435         emit Transfer(prevOwnership.addr, address(0), tokenId);
1436         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1437 
1438         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1439         unchecked { 
1440             _burnCounter++;
1441         }
1442     }
1443 
1444     /**
1445      * @dev Approve `to` to operate on `tokenId`
1446      *
1447      * Emits a {Approval} event.
1448      */
1449     function _approve(
1450         address to,
1451         uint256 tokenId,
1452         address owner
1453     ) private {
1454         _tokenApprovals[tokenId] = to;
1455         emit Approval(owner, to, tokenId);
1456     }
1457 
1458     /**
1459      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1460      * The call is not executed if the target address is not a contract.
1461      *
1462      * @param from address representing the previous owner of the given token ID
1463      * @param to target address that will receive the tokens
1464      * @param tokenId uint256 ID of the token to be transferred
1465      * @param _data bytes optional data to send along with the call
1466      * @return bool whether the call correctly returned the expected magic value
1467      */
1468     function _checkOnERC721Received(
1469         address from,
1470         address to,
1471         uint256 tokenId,
1472         bytes memory _data
1473     ) private returns (bool) {
1474         if (to.isContract()) {
1475             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1476                 return retval == IERC721Receiver(to).onERC721Received.selector;
1477             } catch (bytes memory reason) {
1478                 if (reason.length == 0) {
1479                     revert TransferToNonERC721ReceiverImplementer();
1480                 } else {
1481                     assembly {
1482                         revert(add(32, reason), mload(reason))
1483                     }
1484                 }
1485             }
1486         } else {
1487             return true;
1488         }
1489     }
1490 
1491     /**
1492      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1493      * And also called before burning one token.
1494      *
1495      * startTokenId - the first token id to be transferred
1496      * quantity - the amount to be transferred
1497      *
1498      * Calling conditions:
1499      *
1500      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1501      * transferred to `to`.
1502      * - When `from` is zero, `tokenId` will be minted for `to`.
1503      * - When `to` is zero, `tokenId` will be burned by `from`.
1504      * - `from` and `to` are never both zero.
1505      */
1506     function _beforeTokenTransfers(
1507         address from,
1508         address to,
1509         uint256 startTokenId,
1510         uint256 quantity
1511     ) internal virtual {}
1512 
1513     /**
1514      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1515      * minting.
1516      * And also called after one token has been burned.
1517      *
1518      * startTokenId - the first token id to be transferred
1519      * quantity - the amount to be transferred
1520      *
1521      * Calling conditions:
1522      *
1523      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1524      * transferred to `to`.
1525      * - When `from` is zero, `tokenId` has been minted for `to`.
1526      * - When `to` is zero, `tokenId` has been burned by `from`.
1527      * - `from` and `to` are never both zero.
1528      */
1529     function _afterTokenTransfers(
1530         address from,
1531         address to,
1532         uint256 startTokenId,
1533         uint256 quantity
1534     ) internal virtual {}
1535 }
1536 // File: ERC721A.sol
1537 
1538 /*
1539 * ERC721A Basic Sale Gas Optimized Minting
1540 *  https://twitter.com/SQUIDzillaz0e
1541 */
1542 
1543 
1544 contract PrepareForFlight is ERC721A, Ownable {
1545     using SafeMath for uint256;
1546 
1547     /*
1548      * @dev Set Initial Parameters Before deployment
1549      * settings are still fully updateable after deployment
1550      */
1551     uint256 public MAX_SUPPLY = 10200;
1552     uint256 public mintRate = 0.017 ether;
1553 
1554     /*
1555     * @Dev Booleans for sale state. 
1556     * salesIsActive must be true in any case to mint
1557     */
1558     bool public saleIsActive = false;
1559 
1560     /*
1561      * @dev Set base URI, Make sure when dpeloying if you plan to Have an 
1562      * Unrevealed Sale or Period you Do not Deploy with your Revealed
1563      * base URI here or they will mint With your revealed Images Showing
1564      * I reccomend setting an Incorrect or an Unrevealed URI here, You can also leave
1565      * it Not filled in and Update it with the setBaseURI Function at any Point
1566      */
1567     string public baseURI = "ipfs://SNIPER-NO-SNIPING/";
1568     
1569     /*
1570      * @dev Set your Collection/Contract name and Token Ticker
1571      * below. Constructor Parameter cannot be changed after
1572      * contract deployment.
1573      */
1574     constructor() ERC721A("Prepare For Flight", "FLIGHT") {}
1575 
1576     /*
1577      *@dev
1578      * Set sale price to mint per NFT
1579      */
1580     function setPublicMintPrice(uint256 _price) external onlyOwner {
1581         mintRate = _price;
1582     }
1583 
1584     /*
1585     * @dev mint funtion with _to address. no cost mint
1586     *  by contract owner/deployer
1587     */
1588     function Devmint(uint256 quantity, address _to) external onlyOwner {
1589         require(totalSupply() + quantity <= MAX_SUPPLY, "Not enough tokens left");
1590         _safeMint(_to, quantity);
1591     }
1592 
1593     /*
1594     * @dev mint function and checks for saleState and mint quantity
1595     * Includes Private/public sale checks and quantity minted.
1596     * ** Updated to only look for whitelist during Presale state only
1597     * Use Max Mints more of a max perwallet than how many can be minted.
1598     * This remedied the bug of not being able to mint in Public sale after
1599     * a presale mint has occured. or a mint has occured and was transfered to a different wallet.
1600     */   
1601     function mint(uint256 quantity) external payable {
1602         require(saleIsActive, "Sale must be active to mint");
1603         // _safeMint's second argument now takes in a quantity, not a tokenId.
1604         require(totalSupply() + quantity <= MAX_SUPPLY, "Not enough tokens left to Mint");
1605 
1606         if(saleIsActive) {
1607             require((mintRate * quantity) <= msg.value, "Value below price");
1608         }
1609 
1610         if (totalSupply() < MAX_SUPPLY){
1611         _safeMint(msg.sender, quantity);
1612         }
1613     }
1614 
1615     /*
1616      * @dev Set new Base URI
1617      * useful for setting unrevealed uri to revealed Base URI
1618      * same as a reveal switch/state but less chance of prematurely
1619      * exposing your token URI to Snipers and Bots
1620      */
1621     function setBaseURI(string calldata newBaseURI) external onlyOwner {
1622         baseURI = newBaseURI;
1623     }
1624 
1625      /*
1626      * @dev returns Base URI on frontend/etherscan
1627      */
1628     function _baseURI() internal view override returns (string memory) {
1629         return baseURI;
1630     }
1631 
1632      /*
1633      * @dev Pause sale if active, make active if paused
1634      */
1635     function setSaleActive() public onlyOwner {
1636         saleIsActive = !saleIsActive;
1637     }
1638     
1639     
1640     /*
1641      * @dev Withdrawl function, Contract ETH balance
1642      * to owner wallet address. Only callable
1643      * from owner address
1644      */
1645     function withdraw() public onlyOwner {
1646         payable(owner()).transfer(address(this).balance);
1647     }
1648     
1649     /*
1650     * @dev Alternative withdrawl
1651     * mint funds to a specified address
1652     * good for splitting payments or direct payments to external wallets
1653     * only callable from Owner Wallet
1654     */
1655     function altWithdraw(uint256 _amount, address payable _to)
1656         external
1657         onlyOwner
1658     {
1659         require(_amount > 0, "Withdraw must be greater than 0");
1660         require(_amount <= address(this).balance, "Amount too high");
1661         (bool success, ) = _to.call{value: _amount}("");
1662         require(success);
1663     }
1664 
1665 
1666 }