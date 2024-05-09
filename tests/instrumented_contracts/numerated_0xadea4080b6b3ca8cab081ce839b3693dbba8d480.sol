1 // Dependency file: openzeppelin-solidity/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: GPL-3.0
4 
5 // pragma solidity >=0.6.0 <0.8.0;
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
28 // Dependency file: openzeppelin-solidity/contracts/access/Ownable.sol
29 
30 
31 
32 // pragma solidity >=0.6.0 <0.8.0;
33 
34 // import "../utils/Context.sol";
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 abstract contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53      * @dev Initializes the contract setting the deployer as the initial owner.
54      */
55     constructor () internal {
56         address msgSender = _msgSender();
57         _owner = msgSender;
58         emit OwnershipTransferred(address(0), msgSender);
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view virtual returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         emit OwnershipTransferred(_owner, newOwner);
95         _owner = newOwner;
96     }
97 }
98 
99 // Dependency file: openzeppelin-solidity/contracts/introspection/IERC165.sol
100 
101 
102 
103 // pragma solidity >=0.6.0 <0.8.0;
104 
105 /**
106  * @dev Interface of the ERC165 standard, as defined in the
107  * https://eips.ethereum.org/EIPS/eip-165[EIP].
108  *
109  * Implementers can declare support of contract interfaces, which can then be
110  * queried by others ({ERC165Checker}).
111  *
112  * For an implementation, see {ERC165}.
113  */
114 interface IERC165 {
115     /**
116      * @dev Returns true if this contract implements the interface defined by
117      * `interfaceId`. See the corresponding
118      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
119      * to learn more about how these ids are created.
120      *
121      * This function call must use less than 30 000 gas.
122      */
123     function supportsInterface(bytes4 interfaceId) external view returns (bool);
124 }
125 
126 // Dependency file: openzeppelin-solidity/contracts/math/SafeMath.sol
127 
128 
129 
130 // pragma solidity >=0.6.0 <0.8.0;
131 
132 /**
133  * @dev Wrappers over Solidity's arithmetic operations with added overflow
134  * checks.
135  *
136  * Arithmetic operations in Solidity wrap on overflow. This can easily result
137  * in bugs, because programmers usually assume that an overflow raises an
138  * error, which is the standard behavior in high level programming languages.
139  * `SafeMath` restores this intuition by reverting the transaction when an
140  * operation overflows.
141  *
142  * Using this library instead of the unchecked operations eliminates an entire
143  * class of bugs, so it's recommended to use it always.
144  */
145 library SafeMath {
146     /**
147      * @dev Returns the addition of two unsigned integers, with an overflow flag.
148      *
149      * _Available since v3.4._
150      */
151     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
152         uint256 c = a + b;
153         if (c < a) return (false, 0);
154         return (true, c);
155     }
156 
157     /**
158      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
159      *
160      * _Available since v3.4._
161      */
162     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
163         if (b > a) return (false, 0);
164         return (true, a - b);
165     }
166 
167     /**
168      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
169      *
170      * _Available since v3.4._
171      */
172     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
173         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
174         // benefit is lost if 'b' is also tested.
175         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
176         if (a == 0) return (true, 0);
177         uint256 c = a * b;
178         if (c / a != b) return (false, 0);
179         return (true, c);
180     }
181 
182     /**
183      * @dev Returns the division of two unsigned integers, with a division by zero flag.
184      *
185      * _Available since v3.4._
186      */
187     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
188         if (b == 0) return (false, 0);
189         return (true, a / b);
190     }
191 
192     /**
193      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
194      *
195      * _Available since v3.4._
196      */
197     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
198         if (b == 0) return (false, 0);
199         return (true, a % b);
200     }
201 
202     /**
203      * @dev Returns the addition of two unsigned integers, reverting on
204      * overflow.
205      *
206      * Counterpart to Solidity's `+` operator.
207      *
208      * Requirements:
209      *
210      * - Addition cannot overflow.
211      */
212     function add(uint256 a, uint256 b) internal pure returns (uint256) {
213         uint256 c = a + b;
214         require(c >= a, "SafeMath: addition overflow");
215         return c;
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
229         require(b <= a, "SafeMath: subtraction overflow");
230         return a - b;
231     }
232 
233     /**
234      * @dev Returns the multiplication of two unsigned integers, reverting on
235      * overflow.
236      *
237      * Counterpart to Solidity's `*` operator.
238      *
239      * Requirements:
240      *
241      * - Multiplication cannot overflow.
242      */
243     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
244         if (a == 0) return 0;
245         uint256 c = a * b;
246         require(c / a == b, "SafeMath: multiplication overflow");
247         return c;
248     }
249 
250     /**
251      * @dev Returns the integer division of two unsigned integers, reverting on
252      * division by zero. The result is rounded towards zero.
253      *
254      * Counterpart to Solidity's `/` operator. Note: this function uses a
255      * `revert` opcode (which leaves remaining gas untouched) while Solidity
256      * uses an invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      *
260      * - The divisor cannot be zero.
261      */
262     function div(uint256 a, uint256 b) internal pure returns (uint256) {
263         require(b > 0, "SafeMath: division by zero");
264         return a / b;
265     }
266 
267     /**
268      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
269      * reverting when dividing by zero.
270      *
271      * Counterpart to Solidity's `%` operator. This function uses a `revert`
272      * opcode (which leaves remaining gas untouched) while Solidity uses an
273      * invalid opcode to revert (consuming all remaining gas).
274      *
275      * Requirements:
276      *
277      * - The divisor cannot be zero.
278      */
279     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
280         require(b > 0, "SafeMath: modulo by zero");
281         return a % b;
282     }
283 
284     /**
285      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
286      * overflow (when the result is negative).
287      *
288      * CAUTION: This function is deprecated because it requires allocating memory for the error
289      * message unnecessarily. For custom revert reasons use {trySub}.
290      *
291      * Counterpart to Solidity's `-` operator.
292      *
293      * Requirements:
294      *
295      * - Subtraction cannot overflow.
296      */
297     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
298         require(b <= a, errorMessage);
299         return a - b;
300     }
301 
302     /**
303      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
304      * division by zero. The result is rounded towards zero.
305      *
306      * CAUTION: This function is deprecated because it requires allocating memory for the error
307      * message unnecessarily. For custom revert reasons use {tryDiv}.
308      *
309      * Counterpart to Solidity's `/` operator. Note: this function uses a
310      * `revert` opcode (which leaves remaining gas untouched) while Solidity
311      * uses an invalid opcode to revert (consuming all remaining gas).
312      *
313      * Requirements:
314      *
315      * - The divisor cannot be zero.
316      */
317     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
318         require(b > 0, errorMessage);
319         return a / b;
320     }
321 
322     /**
323      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
324      * reverting with custom message when dividing by zero.
325      *
326      * CAUTION: This function is deprecated because it requires allocating memory for the error
327      * message unnecessarily. For custom revert reasons use {tryMod}.
328      *
329      * Counterpart to Solidity's `%` operator. This function uses a `revert`
330      * opcode (which leaves remaining gas untouched) while Solidity uses an
331      * invalid opcode to revert (consuming all remaining gas).
332      *
333      * Requirements:
334      *
335      * - The divisor cannot be zero.
336      */
337     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
338         require(b > 0, errorMessage);
339         return a % b;
340     }
341 }
342 
343 // Dependency file: openzeppelin-solidity/contracts/cryptography/ECDSA.sol
344 
345 
346 
347 // pragma solidity >=0.6.0 <0.8.0;
348 
349 /**
350  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
351  *
352  * These functions can be used to verify that a message was signed by the holder
353  * of the private keys of a given address.
354  */
355 library ECDSA {
356     /**
357      * @dev Returns the address that signed a hashed message (`hash`) with
358      * `signature`. This address can then be used for verification purposes.
359      *
360      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
361      * this function rejects them by requiring the `s` value to be in the lower
362      * half order, and the `v` value to be either 27 or 28.
363      *
364      * // importANT: `hash` _must_ be the result of a hash operation for the
365      * verification to be secure: it is possible to craft signatures that
366      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
367      * this is by receiving a hash of the original message (which may otherwise
368      * be too long), and then calling {toEthSignedMessageHash} on it.
369      */
370     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
371         // Check the signature length
372         if (signature.length != 65) {
373             revert("ECDSA: invalid signature length");
374         }
375 
376         // Divide the signature in r, s and v variables
377         bytes32 r;
378         bytes32 s;
379         uint8 v;
380 
381         // ecrecover takes the signature parameters, and the only way to get them
382         // currently is to use assembly.
383         // solhint-disable-next-line no-inline-assembly
384         assembly {
385             r := mload(add(signature, 0x20))
386             s := mload(add(signature, 0x40))
387             v := byte(0, mload(add(signature, 0x60)))
388         }
389 
390         return recover(hash, v, r, s);
391     }
392 
393     /**
394      * @dev Overload of {ECDSA-recover-bytes32-bytes-} that receives the `v`,
395      * `r` and `s` signature fields separately.
396      */
397     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
398         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
399         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
400         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
401         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
402         //
403         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
404         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
405         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
406         // these malleable signatures as well.
407         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
408         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
409 
410         // If the signature is valid (and not malleable), return the signer address
411         address signer = ecrecover(hash, v, r, s);
412         require(signer != address(0), "ECDSA: invalid signature");
413 
414         return signer;
415     }
416 
417     /**
418      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
419      * replicates the behavior of the
420      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
421      * JSON-RPC method.
422      *
423      * See {recover}.
424      */
425     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
426         // 32 is the length in bytes of hash,
427         // enforced by the type signature above
428         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
429     }
430 }
431 
432 // Dependency file: contracts/interfaces/ILinkdropCommon.sol
433 
434 // pragma solidity >=0.6.0 <0.8.0;
435 
436 interface ILinkdropCommon {
437 
438     function initialize
439     (
440         address _owner,
441         address payable _linkdropMaster,
442         uint _version,
443         uint _chainId
444     )
445     external returns (bool);
446 
447     function isClaimedLink(address _linkId) external view returns (bool);
448     function isCanceledLink(address _linkId) external view returns (bool);
449     function paused() external view returns (bool);
450     function cancel(address _linkId) external  returns (bool);
451     function withdraw() external returns (bool);
452     function pause() external returns (bool);
453     function unpause() external returns (bool);
454     function addSigner(address _linkdropSigner) external payable returns (bool);
455     function removeSigner(address _linkdropSigner) external returns (bool);
456     function destroy() external;
457     function getMasterCopyVersion() external view returns (uint);
458     function verifyReceiverSignature( address _linkId,
459                                       address _receiver,
460                                       bytes calldata _signature
461                                       )  external view returns (bool);
462     receive() external payable;
463 
464 }
465 
466 // Dependency file: contracts/storage/LinkdropFactoryStorage.sol
467 
468 // pragma solidity >=0.6.0 <0.8.0;
469 // import "openzeppelin-solidity/contracts/access/Ownable.sol";
470 
471 contract LinkdropFactoryStorage is Ownable {
472 
473     // Current version of mastercopy contract
474     uint public masterCopyVersion;
475 
476     // Contract bytecode to be installed when deploying proxy
477     bytes internal _bytecode;
478 
479     // Bootstrap initcode to fetch the actual contract bytecode. Used to generate repeatable contract addresses
480     bytes internal _initcode;
481 
482     // Network id
483     uint public chainId;
484 
485     // Maps hash(sender address, campaign id) to its corresponding proxy address
486     mapping (bytes32 => address) public deployed;
487 
488     // Events
489     event Deployed(address payable indexed owner, uint campaignId, address payable proxy, bytes32 salt);
490     event Destroyed(address payable owner, address payable proxy);
491     event SetMasterCopy(address masterCopy, uint version);
492 
493 }
494 
495 // Dependency file: openzeppelin-solidity/contracts/token/ERC1155/IERC1155.sol
496 
497 
498 
499 // pragma solidity >=0.6.2 <0.8.0;
500 
501 // import "../../introspection/IERC165.sol";
502 
503 /**
504  * @dev Required interface of an ERC1155 compliant contract, as defined in the
505  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
506  *
507  * _Available since v3.1._
508  */
509 interface IERC1155 is IERC165 {
510     /**
511      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
512      */
513     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
514 
515     /**
516      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
517      * transfers.
518      */
519     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
520 
521     /**
522      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
523      * `approved`.
524      */
525     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
526 
527     /**
528      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
529      *
530      * If an {URI} event was emitted for `id`, the standard
531      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
532      * returned by {IERC1155MetadataURI-uri}.
533      */
534     event URI(string value, uint256 indexed id);
535 
536     /**
537      * @dev Returns the amount of tokens of token type `id` owned by `account`.
538      *
539      * Requirements:
540      *
541      * - `account` cannot be the zero address.
542      */
543     function balanceOf(address account, uint256 id) external view returns (uint256);
544 
545     /**
546      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
547      *
548      * Requirements:
549      *
550      * - `accounts` and `ids` must have the same length.
551      */
552     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
553 
554     /**
555      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
556      *
557      * Emits an {ApprovalForAll} event.
558      *
559      * Requirements:
560      *
561      * - `operator` cannot be the caller.
562      */
563     function setApprovalForAll(address operator, bool approved) external;
564 
565     /**
566      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
567      *
568      * See {setApprovalForAll}.
569      */
570     function isApprovedForAll(address account, address operator) external view returns (bool);
571 
572     /**
573      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
574      *
575      * Emits a {TransferSingle} event.
576      *
577      * Requirements:
578      *
579      * - `to` cannot be the zero address.
580      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
581      * - `from` must have a balance of tokens of type `id` of at least `amount`.
582      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
583      * acceptance magic value.
584      */
585     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
586 
587     /**
588      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
589      *
590      * Emits a {TransferBatch} event.
591      *
592      * Requirements:
593      *
594      * - `ids` and `amounts` must have the same length.
595      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
596      * acceptance magic value.
597      */
598     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
599 }
600 
601 // Dependency file: contracts/interfaces/ILinkdropFactoryERC1155.sol
602 
603 // pragma solidity >=0.6.0 <0.8.0;
604 
605 interface ILinkdropFactoryERC1155 {
606 
607     function checkClaimParamsERC1155
608     (
609         uint _weiAmount,
610         address _nftAddress,
611         uint _tokenId,
612         uint _tokenAmount,
613         uint _expiration,
614         address _linkId,
615         address payable _linkdropMaster,
616         uint _campaignId,
617         bytes calldata _linkdropSignerSignature,
618         address _receiver,
619         bytes calldata _receiverSignature
620     )
621     external view
622     returns (bool);
623 
624     function claimERC1155
625     (
626         uint _weiAmount,
627         address _nftAddress,
628         uint _tokenId,
629         uint _tokenAmount,
630         uint _expiration,
631         address _linkId,
632         address payable _linkdropMaster,
633         uint _campaignId,
634         bytes calldata _linkdropSignerSignature,
635         address payable _receiver,
636         bytes calldata _receiverSignature
637     )
638     external
639     returns (bool);
640 
641 }
642 
643 // Dependency file: contracts/interfaces/ILinkdropERC1155.sol
644 
645 // pragma solidity >=0.6.0 <0.8.0;
646 
647 interface ILinkdropERC1155 {
648 
649     function verifyLinkdropSignerSignatureERC1155
650     (
651         uint _weiAmount,
652         address _nftAddress,
653         uint _tokenId,
654         uint _tokenAmount,
655         uint _expiration,
656         address _linkId,
657         bytes calldata _signature
658     )
659     external view returns (bool);
660 
661     function checkClaimParamsERC1155
662     (
663         uint _weiAmount,
664         address _nftAddress,
665         uint _tokenId,
666         uint _tokenAmount,        
667         uint _expiration,
668         address _linkId,
669         bytes calldata _linkdropSignerSignature,
670         address _receiver,
671         bytes calldata _receiverSignature
672      )
673     external view returns (bool);
674 
675     function claimERC1155
676     (
677         uint _weiAmount,
678         address _nftAddress,
679         uint _tokenId,
680         uint _tokenAmount,
681         uint _expiration,
682         address _linkId,
683         bytes calldata _linkdropSignerSignature,
684         address payable _receiver,
685         bytes calldata _receiverSignature
686     )
687     external returns (bool);
688 
689 }
690 
691 // Dependency file: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
692 
693 
694 
695 // pragma solidity >=0.6.2 <0.8.0;
696 
697 // import "../../introspection/IERC165.sol";
698 
699 /**
700  * @dev Required interface of an ERC721 compliant contract.
701  */
702 interface IERC721 is IERC165 {
703     /**
704      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
705      */
706     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
707 
708     /**
709      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
710      */
711     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
712 
713     /**
714      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
715      */
716     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
717 
718     /**
719      * @dev Returns the number of tokens in ``owner``'s account.
720      */
721     function balanceOf(address owner) external view returns (uint256 balance);
722 
723     /**
724      * @dev Returns the owner of the `tokenId` token.
725      *
726      * Requirements:
727      *
728      * - `tokenId` must exist.
729      */
730     function ownerOf(uint256 tokenId) external view returns (address owner);
731 
732     /**
733      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
734      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
735      *
736      * Requirements:
737      *
738      * - `from` cannot be the zero address.
739      * - `to` cannot be the zero address.
740      * - `tokenId` token must exist and be owned by `from`.
741      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
742      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
743      *
744      * Emits a {Transfer} event.
745      */
746     function safeTransferFrom(address from, address to, uint256 tokenId) external;
747 
748     /**
749      * @dev Transfers `tokenId` token from `from` to `to`.
750      *
751      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
752      *
753      * Requirements:
754      *
755      * - `from` cannot be the zero address.
756      * - `to` cannot be the zero address.
757      * - `tokenId` token must be owned by `from`.
758      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
759      *
760      * Emits a {Transfer} event.
761      */
762     function transferFrom(address from, address to, uint256 tokenId) external;
763 
764     /**
765      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
766      * The approval is cleared when the token is transferred.
767      *
768      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
769      *
770      * Requirements:
771      *
772      * - The caller must own the token or be an approved operator.
773      * - `tokenId` must exist.
774      *
775      * Emits an {Approval} event.
776      */
777     function approve(address to, uint256 tokenId) external;
778 
779     /**
780      * @dev Returns the account approved for `tokenId` token.
781      *
782      * Requirements:
783      *
784      * - `tokenId` must exist.
785      */
786     function getApproved(uint256 tokenId) external view returns (address operator);
787 
788     /**
789      * @dev Approve or remove `operator` as an operator for the caller.
790      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
791      *
792      * Requirements:
793      *
794      * - The `operator` cannot be the caller.
795      *
796      * Emits an {ApprovalForAll} event.
797      */
798     function setApprovalForAll(address operator, bool _approved) external;
799 
800     /**
801      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
802      *
803      * See {setApprovalForAll}
804      */
805     function isApprovedForAll(address owner, address operator) external view returns (bool);
806 
807     /**
808       * @dev Safely transfers `tokenId` token from `from` to `to`.
809       *
810       * Requirements:
811       *
812       * - `from` cannot be the zero address.
813       * - `to` cannot be the zero address.
814       * - `tokenId` token must exist and be owned by `from`.
815       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
816       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
817       *
818       * Emits a {Transfer} event.
819       */
820     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
821 }
822 
823 // Dependency file: contracts/interfaces/ILinkdropFactoryERC721.sol
824 
825 // pragma solidity >=0.6.0 <0.8.0;
826 
827 interface ILinkdropFactoryERC721 {
828 
829     function checkClaimParamsERC721
830     (
831         uint _weiAmount,
832         address _nftAddress,
833         uint _tokenId,
834         uint _expiration,
835         address _linkId,
836         address payable _linkdropMaster,
837         uint _campaignId,
838         bytes calldata _linkdropSignerSignature,
839         address _receiver,
840         bytes calldata _receiverSignature
841     )
842     external view
843     returns (bool);
844 
845     function claimERC721
846     (
847         uint _weiAmount,
848         address _nftAddress,
849         uint _tokenId,
850         uint _expiration,
851         address _linkId,
852         address payable _linkdropMaster,
853         uint _campaignId,
854         bytes calldata _linkdropSignerSignature,
855         address payable _receiver,
856         bytes calldata _receiverSignature
857     )
858     external
859     returns (bool);
860 
861 }
862 
863 // Dependency file: contracts/interfaces/ILinkdropERC721.sol
864 
865 // pragma solidity >=0.6.0 <0.8.0;
866 
867 interface ILinkdropERC721 {
868 
869     function verifyLinkdropSignerSignatureERC721
870     (
871         uint _weiAmount,
872         address _nftAddress,
873         uint _tokenId,
874         uint _expiration,
875         address _linkId,
876         bytes calldata _signature
877     )
878     external view returns (bool);
879 
880     function verifyReceiverSignatureERC721
881     (
882         address _linkId,
883 	    address _receiver,
884 		bytes calldata _signature
885     )
886     external view returns (bool);
887 
888     function checkClaimParamsERC721
889     (
890         uint _weiAmount,
891         address _nftAddress,
892         uint _tokenId,
893         uint _expiration,
894         address _linkId,
895         bytes calldata _linkdropSignerSignature,
896         address _receiver,
897         bytes calldata _receiverSignature
898     )
899     external view returns (bool);
900 
901     function claimERC721
902     (
903         uint _weiAmount,
904         address _nftAddress,
905         uint _tokenId,
906         uint _expiration,
907         address _linkId,
908         bytes calldata _linkdropSignerSignature,
909         address payable _receiver,
910         bytes calldata _receiverSignature
911     )
912     external returns (bool);
913 
914 }
915 
916 // Dependency file: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
917 
918 
919 
920 // pragma solidity >=0.6.0 <0.8.0;
921 
922 /**
923  * @dev Interface of the ERC20 standard as defined in the EIP.
924  */
925 interface IERC20 {
926     /**
927      * @dev Returns the amount of tokens in existence.
928      */
929     function totalSupply() external view returns (uint256);
930 
931     /**
932      * @dev Returns the amount of tokens owned by `account`.
933      */
934     function balanceOf(address account) external view returns (uint256);
935 
936     /**
937      * @dev Moves `amount` tokens from the caller's account to `recipient`.
938      *
939      * Returns a boolean value indicating whether the operation succeeded.
940      *
941      * Emits a {Transfer} event.
942      */
943     function transfer(address recipient, uint256 amount) external returns (bool);
944 
945     /**
946      * @dev Returns the remaining number of tokens that `spender` will be
947      * allowed to spend on behalf of `owner` through {transferFrom}. This is
948      * zero by default.
949      *
950      * This value changes when {approve} or {transferFrom} are called.
951      */
952     function allowance(address owner, address spender) external view returns (uint256);
953 
954     /**
955      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
956      *
957      * Returns a boolean value indicating whether the operation succeeded.
958      *
959      * // importANT: Beware that changing an allowance with this method brings the risk
960      * that someone may use both the old and the new allowance by unfortunate
961      * transaction ordering. One possible solution to mitigate this race
962      * condition is to first reduce the spender's allowance to 0 and set the
963      * desired value afterwards:
964      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
965      *
966      * Emits an {Approval} event.
967      */
968     function approve(address spender, uint256 amount) external returns (bool);
969 
970     /**
971      * @dev Moves `amount` tokens from `sender` to `recipient` using the
972      * allowance mechanism. `amount` is then deducted from the caller's
973      * allowance.
974      *
975      * Returns a boolean value indicating whether the operation succeeded.
976      *
977      * Emits a {Transfer} event.
978      */
979     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
980 
981     /**
982      * @dev Emitted when `value` tokens are moved from one account (`from`) to
983      * another (`to`).
984      *
985      * Note that `value` may be zero.
986      */
987     event Transfer(address indexed from, address indexed to, uint256 value);
988 
989     /**
990      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
991      * a call to {approve}. `value` is the new allowance.
992      */
993     event Approval(address indexed owner, address indexed spender, uint256 value);
994 }
995 
996 // Dependency file: contracts/factory/LinkdropFactoryCommon.sol
997 
998 // pragma solidity >=0.6.0 <0.8.0;
999 
1000 // import "../storage/LinkdropFactoryStorage.sol";
1001 // import "../interfaces/ILinkdropCommon.sol";
1002 // import "openzeppelin-solidity/contracts/cryptography/ECDSA.sol";
1003 // import "openzeppelin-solidity/contracts/math/SafeMath.sol";
1004 
1005 contract LinkdropFactoryCommon is LinkdropFactoryStorage {
1006     using SafeMath for uint;
1007 
1008     /**
1009     * @dev Indicates whether a proxy contract for linkdrop master is deployed or not
1010     * @param _linkdropMaster Address of linkdrop master
1011     * @param _campaignId Campaign id
1012     * @return True if deployed
1013     */
1014     function isDeployed(address _linkdropMaster, uint _campaignId) public view returns (bool) {
1015         return (deployed[salt(_linkdropMaster, _campaignId)] != address(0));
1016     }
1017 
1018     /**
1019     * @dev Indicates whether a link is claimed or not
1020     * @param _linkdropMaster Address of lindkrop master
1021     * @param _campaignId Campaign id
1022     * @param _linkId Address corresponding to link key
1023     * @return True if claimed
1024     */
1025     function isClaimedLink(address payable _linkdropMaster, uint _campaignId, address _linkId) public view returns (bool) {
1026 
1027         if (!isDeployed(_linkdropMaster, _campaignId)) {
1028             return false;
1029         }
1030         else {
1031             address payable proxy = address(uint160(deployed[salt(_linkdropMaster, _campaignId)]));
1032             return ILinkdropCommon(proxy).isClaimedLink(_linkId);
1033         }
1034 
1035     }
1036 
1037     /**
1038     * @dev Function to deploy a proxy contract for msg.sender
1039     * @param _campaignId Campaign id
1040     * @return proxy Proxy contract address
1041     */
1042     function deployProxy(uint _campaignId)
1043     public
1044     payable
1045     returns (address payable proxy)
1046     {
1047         proxy = _deployProxy(msg.sender, _campaignId);
1048     }
1049 
1050     /**
1051     * @dev Function to deploy a proxy contract for msg.sender and add a new signing key
1052     * @param _campaignId Campaign id
1053     * @param _signer Address corresponding to signing key
1054     * @return proxy Proxy contract address
1055     */
1056     function deployProxyWithSigner(uint _campaignId, address _signer)
1057     public
1058     payable
1059     returns (address payable proxy)
1060     {
1061         proxy = deployProxy(_campaignId);
1062         ILinkdropCommon(proxy).addSigner(_signer);
1063     }
1064 
1065     /**
1066     * @dev Internal function to deploy a proxy contract for linkdrop master
1067     * @param _linkdropMaster Address of linkdrop master
1068     * @param _campaignId Campaign id
1069     * @return proxy Proxy contract address
1070     */
1071     function _deployProxy(address payable _linkdropMaster, uint _campaignId)
1072     internal
1073     returns (address payable proxy)
1074     {
1075 
1076         require(!isDeployed(_linkdropMaster, _campaignId), "LINKDROP_PROXY_CONTRACT_ALREADY_DEPLOYED");
1077         require(_linkdropMaster != address(0), "INVALID_LINKDROP_MASTER_ADDRESS");
1078 
1079         bytes32 salt = salt(_linkdropMaster, _campaignId);
1080         bytes memory initcode = getInitcode();
1081 
1082         assembly {
1083             proxy := create2(0, add(initcode, 0x20), mload(initcode), salt)
1084             if iszero(extcodesize(proxy)) { revert(0, 0) }
1085         }
1086 
1087         deployed[salt] = proxy;
1088 
1089         // Initialize owner address, linkdrop master address master copy version in proxy contract
1090         require
1091         (
1092             ILinkdropCommon(proxy).initialize
1093             (
1094                 address(this), // Owner address
1095                 _linkdropMaster, // Linkdrop master address
1096                 masterCopyVersion,
1097                 chainId
1098             ),
1099             "INITIALIZATION_FAILED"
1100         );
1101 
1102         // Send funds attached to proxy contract
1103         proxy.transfer(msg.value);
1104 
1105         emit Deployed(_linkdropMaster, _campaignId, proxy, salt);
1106         return proxy;
1107     }
1108 
1109     /**
1110     * @dev Function to destroy proxy contract, called by proxy owner
1111     * @param _campaignId Campaign id
1112     * @return True if destroyed successfully
1113     */
1114     function destroyProxy(uint _campaignId)
1115     public
1116     returns (bool)
1117     {
1118         require(isDeployed(msg.sender, _campaignId), "LINKDROP_PROXY_CONTRACT_NOT_DEPLOYED");
1119         address payable proxy = address(uint160(deployed[salt(msg.sender, _campaignId)]));
1120         ILinkdropCommon(proxy).destroy();
1121         delete deployed[salt(msg.sender, _campaignId)];
1122         emit Destroyed(msg.sender, proxy);
1123         return true;
1124     }
1125 
1126     /**
1127     * @dev Function to get bootstrap initcode for generating repeatable contract addresses
1128     * @return Static bootstrap initcode
1129     */
1130     function getInitcode()
1131     public view
1132     returns (bytes memory)
1133     {
1134         return _initcode;
1135     }
1136 
1137     /**
1138     * @dev Function to fetch the actual contract bytecode to install. Called by proxy when executing initcode
1139     * @return Contract bytecode to install
1140     */
1141     function getBytecode()
1142     public view
1143     returns (bytes memory)
1144     {
1145         return _bytecode;
1146     }
1147 
1148     /**
1149     * @dev Function to set new master copy and update contract bytecode to install. Can only be called by factory owner
1150     * @param _masterCopy Address of linkdrop mastercopy contract to calculate bytecode from
1151     * @return True if updated successfully
1152     */
1153     function setMasterCopy(address payable _masterCopy)
1154     public onlyOwner
1155     returns (bool)
1156     {
1157         require(_masterCopy != address(0), "INVALID_MASTER_COPY_ADDRESS");
1158         masterCopyVersion = masterCopyVersion.add(1);
1159 
1160         require
1161         (
1162             ILinkdropCommon(_masterCopy).initialize
1163             (
1164                 address(0), // Owner address
1165                 address(0), // Linkdrop master address
1166                 masterCopyVersion,
1167                 chainId
1168             ),
1169             "INITIALIZATION_FAILED"
1170         );
1171 
1172         bytes memory bytecode = abi.encodePacked
1173         (
1174             hex"363d3d373d3d3d363d73",
1175             _masterCopy,
1176             hex"5af43d82803e903d91602b57fd5bf3"
1177         );
1178 
1179         _bytecode = bytecode;
1180 
1181         emit SetMasterCopy(_masterCopy, masterCopyVersion);
1182         return true;
1183     }
1184 
1185     /**
1186     * @dev Function to fetch the master copy version installed (or to be installed) to proxy
1187     * @param _linkdropMaster Address of linkdrop master
1188     * @param _campaignId Campaign id
1189     * @return Master copy version
1190     */
1191     function getProxyMasterCopyVersion(address _linkdropMaster, uint _campaignId) external view returns (uint) {
1192 
1193         if (!isDeployed(_linkdropMaster, _campaignId)) {
1194             return masterCopyVersion;
1195         }
1196         else {
1197             address payable proxy = address(uint160(deployed[salt(_linkdropMaster, _campaignId)]));
1198             return ILinkdropCommon(proxy).getMasterCopyVersion();
1199         }
1200     }
1201 
1202     /**
1203      * @dev Function to hash `_linkdropMaster` and `_campaignId` params. Used as salt when deploying with create2
1204      * @param _linkdropMaster Address of linkdrop master
1205      * @param _campaignId Campaign id
1206      * @return Hash of passed arguments
1207      */
1208     function salt(address _linkdropMaster, uint _campaignId) public pure returns (bytes32) {
1209         return keccak256(abi.encodePacked(_linkdropMaster, _campaignId));
1210     }
1211 }
1212 
1213 // Dependency file: contracts/interfaces/ILinkdropFactoryERC20.sol
1214 
1215 // pragma solidity >=0.6.0 <0.8.0;
1216 
1217 interface ILinkdropFactoryERC20 {
1218 
1219     function checkClaimParams
1220     (
1221         uint _weiAmount,
1222         address _tokenAddress,
1223         uint _tokenAmount,
1224         uint _expiration,
1225         address _linkId,
1226         address payable _linkdropMaster,
1227         uint _campaignId,
1228         bytes calldata _linkdropSignerSignature,
1229         address _receiver,
1230         bytes calldata _receiverSignature
1231     )
1232     external view
1233     returns (bool);
1234 
1235     function claim
1236     (
1237         uint _weiAmount,
1238         address _tokenAddress,
1239         uint _tokenAmount,
1240         uint _expiration,
1241         address _linkId,
1242         address payable _linkdropMaster,
1243         uint _campaignId,
1244         bytes calldata _linkdropSignerSignature,
1245         address payable _receiver,
1246         bytes calldata _receiverSignature
1247     )
1248     external
1249     returns (bool);
1250 
1251 }
1252 
1253 // Dependency file: contracts/interfaces/ILinkdropERC20.sol
1254 
1255 // pragma solidity >=0.6.0 <0.8.0;
1256 
1257 interface ILinkdropERC20 {
1258 
1259     function verifyLinkdropSignerSignature
1260     (
1261         uint _weiAmount,
1262         address _tokenAddress,
1263         uint _tokenAmount,
1264         uint _expiration,
1265         address _linkId,
1266         bytes calldata _signature
1267     )
1268     external view returns (bool);
1269 
1270     function checkClaimParams
1271     (
1272         uint _weiAmount,
1273         address _tokenAddress,
1274         uint _tokenAmount,
1275         uint _expiration,
1276         address _linkId,
1277         bytes calldata _linkdropSignerSignature,
1278         address _receiver,
1279         bytes calldata _receiverSignature
1280     )
1281     external view returns (bool);
1282 
1283     function claim
1284     (
1285         uint _weiAmount,
1286         address _tokenAddress,
1287         uint _tokenAmount,
1288         uint _expiration,
1289         address _linkId,
1290         bytes calldata _linkdropSignerSignature,
1291         address payable _receiver,
1292         bytes calldata _receiverSignature
1293     )
1294     external returns (bool);
1295 
1296 }
1297 
1298 // Dependency file: contracts/factory/LinkdropFactoryERC1155.sol
1299 
1300 // pragma solidity >=0.6.0 <0.8.0;
1301 
1302 // import "../interfaces/ILinkdropERC1155.sol";
1303 // import "../interfaces/ILinkdropFactoryERC1155.sol";
1304 // import "./LinkdropFactoryCommon.sol";
1305 // import "openzeppelin-solidity/contracts/token/ERC1155/IERC1155.sol";
1306 
1307 contract LinkdropFactoryERC1155 is ILinkdropFactoryERC1155, LinkdropFactoryCommon {
1308 
1309     /**
1310     * @dev Function to verify claim params, make sure the link is not claimed or canceled and proxy is allowed to spend token
1311     * @param _weiAmount Amount of wei to be claimed
1312     * @param _nftAddress NFT address
1313     * @param _tokenId Token id to be claimed
1314     * @param _tokenAmount Token id to be claimed
1315     * @param _expiration Unix timestamp of link expiration time
1316     * @param _linkId Address corresponding to link key
1317     * @param _linkdropMaster Address corresponding to linkdrop master key
1318     * @param _campaignId Campaign id
1319     * @param _linkdropSignerSignature ECDSA signature of linkdrop signer
1320     * @param _receiver Address of linkdrop receiver
1321     * @param _receiverSignature ECDSA signature of linkdrop receiver
1322     * @return True if success
1323     */
1324     function checkClaimParamsERC1155
1325     (
1326         uint _weiAmount,
1327         address _nftAddress,
1328         uint _tokenId,
1329         uint _tokenAmount,
1330         uint _expiration,
1331         address _linkId,
1332         address payable _linkdropMaster,
1333         uint _campaignId,
1334         bytes memory _linkdropSignerSignature,
1335         address _receiver,
1336         bytes memory _receiverSignature
1337     )
1338     public
1339     override
1340     view
1341     returns (bool)
1342     {
1343         // Make sure proxy contract is deployed
1344         require(isDeployed(_linkdropMaster, _campaignId), "LINKDROP_PROXY_CONTRACT_NOT_DEPLOYED");
1345 
1346         return ILinkdropERC1155(deployed[salt(_linkdropMaster, _campaignId)]).checkClaimParamsERC1155
1347         (
1348             _weiAmount,
1349             _nftAddress,
1350             _tokenId,
1351             _tokenAmount,
1352             _expiration,
1353             _linkId,
1354             _linkdropSignerSignature,
1355             _receiver,
1356             _receiverSignature
1357         );
1358     }
1359 
1360     /**
1361     * @dev Function to claim ETH and/or ERC1155 token
1362     * @param _weiAmount Amount of wei to be claimed
1363     * @param _nftAddress NFT address
1364     * @param _tokenId Token id to be claimed
1365     * @param _tokenAmount Token id to be claimed
1366     * @param _expiration Unix timestamp of link expiration time
1367     * @param _linkId Address corresponding to link key
1368     * @param _linkdropMaster Address corresponding to linkdrop master key
1369     * @param _campaignId Campaign id
1370     * @param _linkdropSignerSignature ECDSA signature of linkdrop signer
1371     * @param _receiver Address of linkdrop receiver
1372     * @param _receiverSignature ECDSA signature of linkdrop receiver
1373     * @return True if success
1374     */
1375     function claimERC1155
1376     (
1377         uint _weiAmount,
1378         address _nftAddress,
1379         uint _tokenId,
1380         uint _tokenAmount,
1381         uint _expiration,
1382         address _linkId,
1383         address payable _linkdropMaster,
1384         uint _campaignId,
1385         bytes calldata _linkdropSignerSignature,
1386         address payable _receiver,
1387         bytes calldata _receiverSignature
1388     )
1389     external
1390     override      
1391     returns (bool)
1392     {
1393       // Make sure proxy contract is deployed
1394       require(isDeployed(_linkdropMaster, _campaignId), "LINKDROP_PROXY_CONTRACT_NOT_DEPLOYED");
1395       
1396       // Call claim function in the context of proxy contract
1397       ILinkdropERC1155(deployed[salt(_linkdropMaster, _campaignId)]).claimERC1155
1398         (
1399          _weiAmount,
1400          _nftAddress,
1401          _tokenId,
1402          _tokenAmount,
1403          _expiration,
1404          _linkId,
1405          _linkdropSignerSignature,
1406          _receiver,
1407          _receiverSignature
1408        );
1409 
1410       return true;
1411     }
1412 
1413 }
1414 
1415 // Dependency file: contracts/factory/LinkdropFactoryERC721.sol
1416 
1417 // pragma solidity >=0.6.0 <0.8.0;
1418 
1419 // import "../interfaces/ILinkdropERC721.sol";
1420 // import "../interfaces/ILinkdropFactoryERC721.sol";
1421 // import "./LinkdropFactoryCommon.sol";
1422 // import "openzeppelin-solidity/contracts/token/ERC721/IERC721.sol";
1423 
1424 contract LinkdropFactoryERC721 is ILinkdropFactoryERC721, LinkdropFactoryCommon {
1425 
1426     /**
1427     * @dev Function to verify claim params, make sure the link is not claimed or canceled and proxy is allowed to spend token
1428     * @param _weiAmount Amount of wei to be claimed
1429     * @param _nftAddress NFT address
1430     * @param _tokenId Token id to be claimed
1431     * @param _expiration Unix timestamp of link expiration time
1432     * @param _linkId Address corresponding to link key
1433     * @param _linkdropMaster Address corresponding to linkdrop master key
1434     * @param _campaignId Campaign id
1435     * @param _linkdropSignerSignature ECDSA signature of linkdrop signer
1436     * @param _receiver Address of linkdrop receiver
1437     * @param _receiverSignature ECDSA signature of linkdrop receiver
1438     * @return True if success
1439     */
1440     function checkClaimParamsERC721
1441     (
1442         uint _weiAmount,
1443         address _nftAddress,
1444         uint _tokenId,
1445         uint _expiration,
1446         address _linkId,
1447         address payable _linkdropMaster,
1448         uint _campaignId,
1449         bytes memory _linkdropSignerSignature,
1450         address _receiver,
1451         bytes memory _receiverSignature
1452     )
1453     public
1454     override
1455     view
1456     returns (bool)
1457     {
1458         // Make sure proxy contract is deployed
1459         require(isDeployed(_linkdropMaster, _campaignId), "LINKDROP_PROXY_CONTRACT_NOT_DEPLOYED");
1460 
1461         return ILinkdropERC721(deployed[salt(_linkdropMaster, _campaignId)]).checkClaimParamsERC721
1462         (
1463             _weiAmount,
1464             _nftAddress,
1465             _tokenId,
1466             _expiration,
1467             _linkId,
1468             _linkdropSignerSignature,
1469             _receiver,
1470             _receiverSignature
1471         );
1472     }
1473 
1474     /**
1475     * @dev Function to claim ETH and/or ERC721 token
1476     * @param _weiAmount Amount of wei to be claimed
1477     * @param _nftAddress NFT address
1478     * @param _tokenId Token id to be claimed
1479     * @param _expiration Unix timestamp of link expiration time
1480     * @param _linkId Address corresponding to link key
1481     * @param _linkdropMaster Address corresponding to linkdrop master key
1482     * @param _campaignId Campaign id
1483     * @param _linkdropSignerSignature ECDSA signature of linkdrop signer
1484     * @param _receiver Address of linkdrop receiver
1485     * @param _receiverSignature ECDSA signature of linkdrop receiver
1486     * @return True if success
1487     */
1488     function claimERC721
1489     (
1490         uint _weiAmount,
1491         address _nftAddress,
1492         uint _tokenId,
1493         uint _expiration,
1494         address _linkId,
1495         address payable _linkdropMaster,
1496         uint _campaignId,
1497         bytes calldata _linkdropSignerSignature,
1498         address payable _receiver,
1499         bytes calldata _receiverSignature
1500     )
1501     external
1502     override      
1503     returns (bool)
1504     {
1505         // Make sure proxy contract is deployed
1506         require(isDeployed(_linkdropMaster, _campaignId), "LINKDROP_PROXY_CONTRACT_NOT_DEPLOYED");
1507 
1508         // Call claim function in the context of proxy contract
1509         ILinkdropERC721(deployed[salt(_linkdropMaster, _campaignId)]).claimERC721
1510         (
1511             _weiAmount,
1512             _nftAddress,
1513             _tokenId,
1514             _expiration,
1515             _linkId,
1516             _linkdropSignerSignature,
1517             _receiver,
1518             _receiverSignature
1519         );
1520 
1521         return true;
1522     }
1523 
1524 }
1525 
1526 // Dependency file: contracts/factory/LinkdropFactoryERC20.sol
1527 
1528 // pragma solidity >=0.6.0 <0.8.0;
1529 
1530 // import "../interfaces/ILinkdropERC20.sol";
1531 // import "../interfaces/ILinkdropFactoryERC20.sol";
1532 // import "./LinkdropFactoryCommon.sol";
1533 // import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
1534 
1535 contract LinkdropFactoryERC20 is ILinkdropFactoryERC20, LinkdropFactoryCommon {
1536 
1537     /**
1538     * @dev Function to verify claim params, make sure the link is not claimed or canceled and proxy has sufficient balance
1539     * @param _weiAmount Amount of wei to be claimed
1540     * @param _tokenAddress Token address
1541     * @param _tokenAmount Amount of tokens to be claimed (in atomic value)
1542     * @param _expiration Unix timestamp of link expiration time
1543     * @param _linkId Address corresponding to link key
1544     * @param _linkdropMaster Address corresponding to linkdrop master key
1545     * @param _campaignId Campaign id
1546     * @param _linkdropSignerSignature ECDSA signature of linkdrop signer
1547     * @param _receiver Address of linkdrop receiver
1548     * @param _receiverSignature ECDSA signature of linkdrop receiver
1549     * @return True if success
1550     */
1551     function checkClaimParams
1552     (
1553         uint _weiAmount,
1554         address _tokenAddress,
1555         uint _tokenAmount,
1556         uint _expiration,
1557         address _linkId,
1558         address payable _linkdropMaster,
1559         uint _campaignId,
1560         bytes memory _linkdropSignerSignature,
1561         address _receiver,
1562         bytes memory _receiverSignature
1563     )
1564     public
1565     override      
1566     view
1567     returns (bool)
1568     {
1569         // Make sure proxy contract is deployed
1570         require(isDeployed(_linkdropMaster, _campaignId), "LINKDROP_PROXY_CONTRACT_NOT_DEPLOYED");
1571 
1572         return ILinkdropERC20(deployed[salt(_linkdropMaster, _campaignId)]).checkClaimParams
1573         (
1574             _weiAmount,
1575             _tokenAddress,
1576             _tokenAmount,
1577             _expiration,
1578             _linkId,
1579             _linkdropSignerSignature,
1580             _receiver,
1581             _receiverSignature
1582         );
1583     }
1584 
1585     /**
1586     * @dev Function to claim ETH and/or ERC20 tokens
1587     * @param _weiAmount Amount of wei to be claimed
1588     * @param _tokenAddress Token address
1589     * @param _tokenAmount Amount of tokens to be claimed (in atomic value)
1590     * @param _expiration Unix timestamp of link expiration time
1591     * @param _linkId Address corresponding to link key
1592     * @param _linkdropMaster Address corresponding to linkdrop master key
1593     * @param _campaignId Campaign id
1594     * @param _linkdropSignerSignature ECDSA signature of linkdrop signer
1595     * @param _receiver Address of linkdrop receiver
1596     * @param _receiverSignature ECDSA signature of linkdrop receiver
1597     * @return True if success
1598     */
1599     function claim
1600     (
1601         uint _weiAmount,
1602         address _tokenAddress,
1603         uint _tokenAmount,
1604         uint _expiration,
1605         address _linkId,
1606         address payable _linkdropMaster,
1607         uint _campaignId,
1608         bytes calldata _linkdropSignerSignature,
1609         address payable _receiver,
1610         bytes calldata _receiverSignature
1611     )
1612     external
1613     override      
1614     returns (bool)
1615     {
1616         // Make sure proxy contract is deployed
1617         require(isDeployed(_linkdropMaster, _campaignId), "LINKDROP_PROXY_CONTRACT_NOT_DEPLOYED");
1618 
1619         // Call claim function in the context of proxy contract
1620         ILinkdropERC20(deployed[salt(_linkdropMaster, _campaignId)]).claim
1621         (
1622             _weiAmount,
1623             _tokenAddress,
1624             _tokenAmount,
1625             _expiration,
1626             _linkId,
1627             _linkdropSignerSignature,
1628             _receiver,
1629             _receiverSignature
1630         );
1631 
1632         return true;
1633     }
1634 
1635 }
1636 
1637 pragma solidity >=0.6.0 <0.8.0;
1638 
1639 // import "./LinkdropFactoryERC20.sol";
1640 // import "./LinkdropFactoryERC721.sol";
1641 // import "./LinkdropFactoryERC1155.sol";
1642 
1643 contract LinkdropFactory is LinkdropFactoryERC20, LinkdropFactoryERC721, LinkdropFactoryERC1155 {
1644 
1645     /**
1646     * @dev Constructor that sets bootstap initcode, factory owner, chainId and master copy
1647     * @param _masterCopy Linkdrop mastercopy contract address to calculate bytecode from
1648     * @param _chainId Chain id
1649     */
1650     constructor(address payable _masterCopy, uint _chainId) public {
1651         _initcode = (hex"6352c7420d6000526103ff60206004601c335afa6040516060f3");
1652         chainId = _chainId;
1653         setMasterCopy(_masterCopy);
1654     }
1655 
1656 }