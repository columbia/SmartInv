1 // File: contracts/controllers/ISignatureController.sol
2 
3 pragma solidity 0.5.12;
4 
5 /**
6  * @title ISignatureController
7  * @dev All of the signature controller functions follow the same pattern. Each
8  * function mirrors another function in another controller or on the registry.
9  * The intent is that these signature functions can be an alternative to signing
10  * away unilateral control via an approval without having to build significant
11  * smart contract infrastructure, and without the domain owner having to have
12  * ether for gas.
13  *
14  * @dev The way these functions work is by validating a extra signature argument
15  * of all of the arguments of the function and a nonce, and crosschecking the
16  * recovered address with the registry to ensure that the signer is the owner.
17  * Instead of checking msg.sender for authentication.
18  *
19  * @dev The method we use for signing is non standard. It'd be worth it to
20  * consider using EIP712 Typed signing https://eips.ethereum.org/EIPS/eip-712.
21  */
22 interface ISignatureController {
23 
24     /**
25      * @dev Returns the given owners' nonce.
26      * @param tokenId token ID to query the nonce of
27      * @return uint256 nonce of the owner
28      */
29     function nonceOf(uint256 tokenId) external view returns (uint256);
30 
31     /// A signature function based on transferFrom inside Open Zeppelin's ERC721.sol.
32     function transferFromFor(address from, address to, uint256 tokenId, bytes calldata signature) external;
33 
34     /// A signature function based on safeTransferFrom inside Open Zeppelin's ERC721.sol.
35     function safeTransferFromFor(address from, address to, uint256 tokenId, bytes calldata _data, bytes calldata signature) external;
36     function safeTransferFromFor(address from, address to, uint256 tokenId, bytes calldata signature) external;
37 
38     /// A signature function based on resolveTo inside ./IRegistry.sol.
39     function resolveToFor(address to, uint256 tokenId, bytes calldata signature) external;
40 
41     /// A signature function based on burn inside ./IRegistry.sol.
42     function burnFor(uint256 tokenId, bytes calldata signature) external;
43 
44     /// A signature function based on mintChild inside ./IChildController.sol.
45     function mintChildFor(address to, uint256 tokenId, string calldata label, bytes calldata signature) external;
46 
47     /// A signature function based on transferFromChild inside ./IChildController.sol.
48     function transferFromChildFor(address from, address to, uint256 tokenId, string calldata label, bytes calldata signature) external;
49 
50     /// A signature function based on safeTransferFromChild inside ./IChildController.sol.
51     function safeTransferFromChildFor(address from, address to, uint256 tokenId, string calldata label, bytes calldata _data, bytes calldata signature) external;
52     function safeTransferFromChildFor(address from, address to, uint256 tokenId, string calldata label, bytes calldata signature) external;
53 
54     /// A signature function based on burnChild inside ./IChildController.sol.
55     function burnChildFor(uint256 tokenId, string calldata label, bytes calldata signature) external;
56 
57 }
58 
59 // File: @openzeppelin/contracts/cryptography/ECDSA.sol
60 
61 pragma solidity ^0.5.0;
62 
63 /**
64  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
65  *
66  * These functions can be used to verify that a message was signed by the holder
67  * of the private keys of a given address.
68  */
69 library ECDSA {
70     /**
71      * @dev Returns the address that signed a hashed message (`hash`) with
72      * `signature`. This address can then be used for verification purposes.
73      *
74      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
75      * this function rejects them by requiring the `s` value to be in the lower
76      * half order, and the `v` value to be either 27 or 28.
77      *
78      * (.note) This call _does not revert_ if the signature is invalid, or
79      * if the signer is otherwise unable to be retrieved. In those scenarios,
80      * the zero address is returned.
81      *
82      * (.warning) `hash` _must_ be the result of a hash operation for the
83      * verification to be secure: it is possible to craft signatures that
84      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
85      * this is by receiving a hash of the original message (which may otherwise)
86      * be too long), and then calling `toEthSignedMessageHash` on it.
87      */
88     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
89         // Check the signature length
90         if (signature.length != 65) {
91             return (address(0));
92         }
93 
94         // Divide the signature in r, s and v variables
95         bytes32 r;
96         bytes32 s;
97         uint8 v;
98 
99         // ecrecover takes the signature parameters, and the only way to get them
100         // currently is to use assembly.
101         // solhint-disable-next-line no-inline-assembly
102         assembly {
103             r := mload(add(signature, 0x20))
104             s := mload(add(signature, 0x40))
105             v := byte(0, mload(add(signature, 0x60)))
106         }
107 
108         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
109         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
110         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
111         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
112         //
113         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
114         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
115         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
116         // these malleable signatures as well.
117         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
118             return address(0);
119         }
120 
121         if (v != 27 && v != 28) {
122             return address(0);
123         }
124 
125         // If the signature is valid (and not malleable), return the signer address
126         return ecrecover(hash, v, r, s);
127     }
128 
129     /**
130      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
131      * replicates the behavior of the
132      * [`eth_sign`](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign)
133      * JSON-RPC method.
134      *
135      * See `recover`.
136      */
137     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
138         // 32 is the length in bytes of hash,
139         // enforced by the type signature above
140         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
141     }
142 }
143 
144 // File: @openzeppelin/contracts/introspection/IERC165.sol
145 
146 pragma solidity ^0.5.0;
147 
148 /**
149  * @dev Interface of the ERC165 standard, as defined in the
150  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
151  *
152  * Implementers can declare support of contract interfaces, which can then be
153  * queried by others (`ERC165Checker`).
154  *
155  * For an implementation, see `ERC165`.
156  */
157 interface IERC165 {
158     /**
159      * @dev Returns true if this contract implements the interface defined by
160      * `interfaceId`. See the corresponding
161      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
162      * to learn more about how these ids are created.
163      *
164      * This function call must use less than 30 000 gas.
165      */
166     function supportsInterface(bytes4 interfaceId) external view returns (bool);
167 }
168 
169 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
170 
171 pragma solidity ^0.5.0;
172 
173 
174 /**
175  * @dev Required interface of an ERC721 compliant contract.
176  */
177 contract IERC721 is IERC165 {
178     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
179     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
180     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
181 
182     /**
183      * @dev Returns the number of NFTs in `owner`'s account.
184      */
185     function balanceOf(address owner) public view returns (uint256 balance);
186 
187     /**
188      * @dev Returns the owner of the NFT specified by `tokenId`.
189      */
190     function ownerOf(uint256 tokenId) public view returns (address owner);
191 
192     /**
193      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
194      * another (`to`).
195      *
196      * 
197      *
198      * Requirements:
199      * - `from`, `to` cannot be zero.
200      * - `tokenId` must be owned by `from`.
201      * - If the caller is not `from`, it must be have been allowed to move this
202      * NFT by either `approve` or `setApproveForAll`.
203      */
204     function safeTransferFrom(address from, address to, uint256 tokenId) public;
205     /**
206      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
207      * another (`to`).
208      *
209      * Requirements:
210      * - If the caller is not `from`, it must be approved to move this NFT by
211      * either `approve` or `setApproveForAll`.
212      */
213     function transferFrom(address from, address to, uint256 tokenId) public;
214     function approve(address to, uint256 tokenId) public;
215     function getApproved(uint256 tokenId) public view returns (address operator);
216 
217     function setApprovalForAll(address operator, bool _approved) public;
218     function isApprovedForAll(address owner, address operator) public view returns (bool);
219 
220 
221     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
222 }
223 
224 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
225 
226 pragma solidity ^0.5.0;
227 
228 
229 /**
230  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
231  * @dev See https://eips.ethereum.org/EIPS/eip-721
232  */
233 contract IERC721Metadata is IERC721 {
234     function name() external view returns (string memory);
235     function symbol() external view returns (string memory);
236     function tokenURI(uint256 tokenId) external view returns (string memory);
237 }
238 
239 // File: contracts/IRegistry.sol
240 
241 pragma solidity 0.5.12;
242 
243 
244 contract IRegistry is IERC721Metadata {
245 
246     event NewURI(uint256 indexed tokenId, string uri);
247 
248     event NewURIPrefix(string prefix);
249 
250     event Resolve(uint256 indexed tokenId, address indexed to);
251 
252     event Sync(address indexed resolver, uint256 indexed updateId, uint256 indexed tokenId);
253 
254     /**
255      * @dev Controlled function to set the token URI Prefix for all tokens.
256      * @param prefix string URI to assign
257      */
258     function controlledSetTokenURIPrefix(string calldata prefix) external;
259 
260     /**
261      * @dev Returns whether the given spender can transfer a given token ID.
262      * @param spender address of the spender to query
263      * @param tokenId uint256 ID of the token to be transferred
264      * @return bool whether the msg.sender is approved for the given token ID,
265      * is an operator of the owner, or is the owner of the token
266      */
267     function isApprovedOrOwner(address spender, uint256 tokenId) external view returns (bool);
268 
269     /**
270      * @dev Mints a new a child token.
271      * Calculates child token ID using a namehash function.
272      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
273      * Requires the token not exist.
274      * @param to address to receive the ownership of the given token ID
275      * @param tokenId uint256 ID of the parent token
276      * @param label subdomain label of the child token ID
277      */
278     function mintChild(address to, uint256 tokenId, string calldata label) external;
279 
280     /**
281      * @dev Controlled function to mint a given token ID.
282      * Requires the msg.sender to be controller.
283      * Requires the token ID to not exist.
284      * @param to address the given token ID will be minted to
285      * @param label string that is a subdomain
286      * @param tokenId uint256 ID of the parent token
287      */
288     function controlledMintChild(address to, uint256 tokenId, string calldata label) external;
289 
290     /**
291      * @dev Transfers the ownership of a child token ID to another address.
292      * Calculates child token ID using a namehash function.
293      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
294      * Requires the token already exist.
295      * @param from current owner of the token
296      * @param to address to receive the ownership of the given token ID
297      * @param tokenId uint256 ID of the token to be transferred
298      * @param label subdomain label of the child token ID
299      */
300     function transferFromChild(address from, address to, uint256 tokenId, string calldata label) external;
301 
302     /**
303      * @dev Controlled function to transfers the ownership of a token ID to
304      * another address.
305      * Requires the msg.sender to be controller.
306      * Requires the token already exist.
307      * @param from current owner of the token
308      * @param to address to receive the ownership of the given token ID
309      * @param tokenId uint256 ID of the token to be transferred
310      */
311     function controlledTransferFrom(address from, address to, uint256 tokenId) external;
312 
313     /**
314      * @dev Safely transfers the ownership of a child token ID to another address.
315      * Calculates child token ID using a namehash function.
316      * Implements a ERC721Reciever check unlike transferFromChild.
317      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
318      * Requires the token already exist.
319      * @param from current owner of the token
320      * @param to address to receive the ownership of the given token ID
321      * @param tokenId uint256 parent ID of the token to be transferred
322      * @param label subdomain label of the child token ID
323      * @param _data bytes data to send along with a safe transfer check
324      */
325     function safeTransferFromChild(address from, address to, uint256 tokenId, string calldata label, bytes calldata _data) external;
326 
327     /// Shorthand for calling the above ^^^ safeTransferFromChild function with an empty _data parameter. Similar to ERC721.safeTransferFrom.
328     function safeTransferFromChild(address from, address to, uint256 tokenId, string calldata label) external;
329 
330     /**
331      * @dev Controlled frunction to safely transfers the ownership of a token ID
332      * to another address.
333      * Implements a ERC721Reciever check unlike controlledSafeTransferFrom.
334      * Requires the msg.sender to be controller.
335      * Requires the token already exist.
336      * @param from current owner of the token
337      * @param to address to receive the ownership of the given token ID
338      * @param tokenId uint256 parent ID of the token to be transferred
339      * @param _data bytes data to send along with a safe transfer check
340      */
341     function controlledSafeTransferFrom(address from, address to, uint256 tokenId, bytes calldata _data) external;
342 
343     /**
344      * @dev Burns a child token ID.
345      * Calculates child token ID using a namehash function.
346      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
347      * Requires the token already exist.
348      * @param tokenId uint256 ID of the token to be transferred
349      * @param label subdomain label of the child token ID
350      */
351     function burnChild(uint256 tokenId, string calldata label) external;
352 
353     /**
354      * @dev Controlled function to burn a given token ID.
355      * Requires the msg.sender to be controller.
356      * Requires the token already exist.
357      * @param tokenId uint256 ID of the token to be burned
358      */
359     function controlledBurn(uint256 tokenId) external;
360 
361     /**
362      * @dev Sets the resolver of a given token ID to another address.
363      * Requires the msg.sender to be the owner, approved, or operator.
364      * @param to address the given token ID will resolve to
365      * @param tokenId uint256 ID of the token to be transferred
366      */
367     function resolveTo(address to, uint256 tokenId) external;
368 
369     /**
370      * @dev Gets the resolver of the specified token ID.
371      * @param tokenId uint256 ID of the token to query the resolver of
372      * @return address currently marked as the resolver of the given token ID
373      */
374     function resolverOf(uint256 tokenId) external view returns (address);
375 
376     /**
377      * @dev Controlled function to sets the resolver of a given token ID.
378      * Requires the msg.sender to be controller.
379      * @param to address the given token ID will resolve to
380      * @param tokenId uint256 ID of the token to be transferred
381      */
382     function controlledResolveTo(address to, uint256 tokenId) external;
383 
384 }
385 
386 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
387 
388 pragma solidity ^0.5.0;
389 
390 /**
391  * @title ERC721 token receiver interface
392  * @dev Interface for any contract that wants to support safeTransfers
393  * from ERC721 asset contracts.
394  */
395 contract IERC721Receiver {
396     /**
397      * @notice Handle the receipt of an NFT
398      * @dev The ERC721 smart contract calls this function on the recipient
399      * after a `safeTransfer`. This function MUST return the function selector,
400      * otherwise the caller will revert the transaction. The selector to be
401      * returned can be obtained as `this.onERC721Received.selector`. This
402      * function MAY throw to revert and reject the transfer.
403      * Note: the ERC721 contract address is always the message sender.
404      * @param operator The address which called `safeTransferFrom` function
405      * @param from The address which previously owned the token
406      * @param tokenId The NFT identifier which is being transferred
407      * @param data Additional data with no specified format
408      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
409      */
410     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
411     public returns (bytes4);
412 }
413 
414 // File: @openzeppelin/contracts/math/SafeMath.sol
415 
416 pragma solidity ^0.5.0;
417 
418 /**
419  * @dev Wrappers over Solidity's arithmetic operations with added overflow
420  * checks.
421  *
422  * Arithmetic operations in Solidity wrap on overflow. This can easily result
423  * in bugs, because programmers usually assume that an overflow raises an
424  * error, which is the standard behavior in high level programming languages.
425  * `SafeMath` restores this intuition by reverting the transaction when an
426  * operation overflows.
427  *
428  * Using this library instead of the unchecked operations eliminates an entire
429  * class of bugs, so it's recommended to use it always.
430  */
431 library SafeMath {
432     /**
433      * @dev Returns the addition of two unsigned integers, reverting on
434      * overflow.
435      *
436      * Counterpart to Solidity's `+` operator.
437      *
438      * Requirements:
439      * - Addition cannot overflow.
440      */
441     function add(uint256 a, uint256 b) internal pure returns (uint256) {
442         uint256 c = a + b;
443         require(c >= a, "SafeMath: addition overflow");
444 
445         return c;
446     }
447 
448     /**
449      * @dev Returns the subtraction of two unsigned integers, reverting on
450      * overflow (when the result is negative).
451      *
452      * Counterpart to Solidity's `-` operator.
453      *
454      * Requirements:
455      * - Subtraction cannot overflow.
456      */
457     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
458         require(b <= a, "SafeMath: subtraction overflow");
459         uint256 c = a - b;
460 
461         return c;
462     }
463 
464     /**
465      * @dev Returns the multiplication of two unsigned integers, reverting on
466      * overflow.
467      *
468      * Counterpart to Solidity's `*` operator.
469      *
470      * Requirements:
471      * - Multiplication cannot overflow.
472      */
473     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
474         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
475         // benefit is lost if 'b' is also tested.
476         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
477         if (a == 0) {
478             return 0;
479         }
480 
481         uint256 c = a * b;
482         require(c / a == b, "SafeMath: multiplication overflow");
483 
484         return c;
485     }
486 
487     /**
488      * @dev Returns the integer division of two unsigned integers. Reverts on
489      * division by zero. The result is rounded towards zero.
490      *
491      * Counterpart to Solidity's `/` operator. Note: this function uses a
492      * `revert` opcode (which leaves remaining gas untouched) while Solidity
493      * uses an invalid opcode to revert (consuming all remaining gas).
494      *
495      * Requirements:
496      * - The divisor cannot be zero.
497      */
498     function div(uint256 a, uint256 b) internal pure returns (uint256) {
499         // Solidity only automatically asserts when dividing by 0
500         require(b > 0, "SafeMath: division by zero");
501         uint256 c = a / b;
502         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
503 
504         return c;
505     }
506 
507     /**
508      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
509      * Reverts when dividing by zero.
510      *
511      * Counterpart to Solidity's `%` operator. This function uses a `revert`
512      * opcode (which leaves remaining gas untouched) while Solidity uses an
513      * invalid opcode to revert (consuming all remaining gas).
514      *
515      * Requirements:
516      * - The divisor cannot be zero.
517      */
518     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
519         require(b != 0, "SafeMath: modulo by zero");
520         return a % b;
521     }
522 }
523 
524 // File: @openzeppelin/contracts/utils/Address.sol
525 
526 pragma solidity ^0.5.0;
527 
528 /**
529  * @dev Collection of functions related to the address type,
530  */
531 library Address {
532     /**
533      * @dev Returns true if `account` is a contract.
534      *
535      * This test is non-exhaustive, and there may be false-negatives: during the
536      * execution of a contract's constructor, its address will be reported as
537      * not containing a contract.
538      *
539      * > It is unsafe to assume that an address for which this function returns
540      * false is an externally-owned account (EOA) and not a contract.
541      */
542     function isContract(address account) internal view returns (bool) {
543         // This method relies in extcodesize, which returns 0 for contracts in
544         // construction, since the code is only stored at the end of the
545         // constructor execution.
546 
547         uint256 size;
548         // solhint-disable-next-line no-inline-assembly
549         assembly { size := extcodesize(account) }
550         return size > 0;
551     }
552 }
553 
554 // File: @openzeppelin/contracts/drafts/Counters.sol
555 
556 pragma solidity ^0.5.0;
557 
558 
559 /**
560  * @title Counters
561  * @author Matt Condon (@shrugs)
562  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
563  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
564  *
565  * Include with `using Counters for Counters.Counter;`
566  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
567  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
568  * directly accessed.
569  */
570 library Counters {
571     using SafeMath for uint256;
572 
573     struct Counter {
574         // This variable should never be directly accessed by users of the library: interactions must be restricted to
575         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
576         // this feature: see https://github.com/ethereum/solidity/issues/4637
577         uint256 _value; // default: 0
578     }
579 
580     function current(Counter storage counter) internal view returns (uint256) {
581         return counter._value;
582     }
583 
584     function increment(Counter storage counter) internal {
585         counter._value += 1;
586     }
587 
588     function decrement(Counter storage counter) internal {
589         counter._value = counter._value.sub(1);
590     }
591 }
592 
593 // File: @openzeppelin/contracts/introspection/ERC165.sol
594 
595 pragma solidity ^0.5.0;
596 
597 
598 /**
599  * @dev Implementation of the `IERC165` interface.
600  *
601  * Contracts may inherit from this and call `_registerInterface` to declare
602  * their support of an interface.
603  */
604 contract ERC165 is IERC165 {
605     /*
606      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
607      */
608     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
609 
610     /**
611      * @dev Mapping of interface ids to whether or not it's supported.
612      */
613     mapping(bytes4 => bool) private _supportedInterfaces;
614 
615     constructor () internal {
616         // Derived contracts need only register support for their own interfaces,
617         // we register support for ERC165 itself here
618         _registerInterface(_INTERFACE_ID_ERC165);
619     }
620 
621     /**
622      * @dev See `IERC165.supportsInterface`.
623      *
624      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
625      */
626     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
627         return _supportedInterfaces[interfaceId];
628     }
629 
630     /**
631      * @dev Registers the contract as an implementer of the interface defined by
632      * `interfaceId`. Support of the actual ERC165 interface is automatic and
633      * registering its interface id is not required.
634      *
635      * See `IERC165.supportsInterface`.
636      *
637      * Requirements:
638      *
639      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
640      */
641     function _registerInterface(bytes4 interfaceId) internal {
642         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
643         _supportedInterfaces[interfaceId] = true;
644     }
645 }
646 
647 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
648 
649 pragma solidity ^0.5.0;
650 
651 
652 
653 
654 
655 
656 
657 /**
658  * @title ERC721 Non-Fungible Token Standard basic implementation
659  * @dev see https://eips.ethereum.org/EIPS/eip-721
660  */
661 contract ERC721 is ERC165, IERC721 {
662     using SafeMath for uint256;
663     using Address for address;
664     using Counters for Counters.Counter;
665 
666     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
667     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
668     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
669 
670     // Mapping from token ID to owner
671     mapping (uint256 => address) private _tokenOwner;
672 
673     // Mapping from token ID to approved address
674     mapping (uint256 => address) private _tokenApprovals;
675 
676     // Mapping from owner to number of owned token
677     mapping (address => Counters.Counter) private _ownedTokensCount;
678 
679     // Mapping from owner to operator approvals
680     mapping (address => mapping (address => bool)) private _operatorApprovals;
681 
682     /*
683      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
684      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
685      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
686      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
687      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
688      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c
689      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
690      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
691      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
692      *
693      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
694      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
695      */
696     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
697 
698     constructor () public {
699         // register the supported interfaces to conform to ERC721 via ERC165
700         _registerInterface(_INTERFACE_ID_ERC721);
701     }
702 
703     /**
704      * @dev Gets the balance of the specified address.
705      * @param owner address to query the balance of
706      * @return uint256 representing the amount owned by the passed address
707      */
708     function balanceOf(address owner) public view returns (uint256) {
709         require(owner != address(0), "ERC721: balance query for the zero address");
710 
711         return _ownedTokensCount[owner].current();
712     }
713 
714     /**
715      * @dev Gets the owner of the specified token ID.
716      * @param tokenId uint256 ID of the token to query the owner of
717      * @return address currently marked as the owner of the given token ID
718      */
719     function ownerOf(uint256 tokenId) public view returns (address) {
720         address owner = _tokenOwner[tokenId];
721         require(owner != address(0), "ERC721: owner query for nonexistent token");
722 
723         return owner;
724     }
725 
726     /**
727      * @dev Approves another address to transfer the given token ID
728      * The zero address indicates there is no approved address.
729      * There can only be one approved address per token at a given time.
730      * Can only be called by the token owner or an approved operator.
731      * @param to address to be approved for the given token ID
732      * @param tokenId uint256 ID of the token to be approved
733      */
734     function approve(address to, uint256 tokenId) public {
735         address owner = ownerOf(tokenId);
736         require(to != owner, "ERC721: approval to current owner");
737 
738         require(msg.sender == owner || isApprovedForAll(owner, msg.sender),
739             "ERC721: approve caller is not owner nor approved for all"
740         );
741 
742         _tokenApprovals[tokenId] = to;
743         emit Approval(owner, to, tokenId);
744     }
745 
746     /**
747      * @dev Gets the approved address for a token ID, or zero if no address set
748      * Reverts if the token ID does not exist.
749      * @param tokenId uint256 ID of the token to query the approval of
750      * @return address currently approved for the given token ID
751      */
752     function getApproved(uint256 tokenId) public view returns (address) {
753         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
754 
755         return _tokenApprovals[tokenId];
756     }
757 
758     /**
759      * @dev Sets or unsets the approval of a given operator
760      * An operator is allowed to transfer all tokens of the sender on their behalf.
761      * @param to operator address to set the approval
762      * @param approved representing the status of the approval to be set
763      */
764     function setApprovalForAll(address to, bool approved) public {
765         require(to != msg.sender, "ERC721: approve to caller");
766 
767         _operatorApprovals[msg.sender][to] = approved;
768         emit ApprovalForAll(msg.sender, to, approved);
769     }
770 
771     /**
772      * @dev Tells whether an operator is approved by a given owner.
773      * @param owner owner address which you want to query the approval of
774      * @param operator operator address which you want to query the approval of
775      * @return bool whether the given operator is approved by the given owner
776      */
777     function isApprovedForAll(address owner, address operator) public view returns (bool) {
778         return _operatorApprovals[owner][operator];
779     }
780 
781     /**
782      * @dev Transfers the ownership of a given token ID to another address.
783      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible.
784      * Requires the msg.sender to be the owner, approved, or operator.
785      * @param from current owner of the token
786      * @param to address to receive the ownership of the given token ID
787      * @param tokenId uint256 ID of the token to be transferred
788      */
789     function transferFrom(address from, address to, uint256 tokenId) public {
790         //solhint-disable-next-line max-line-length
791         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
792 
793         _transferFrom(from, to, tokenId);
794     }
795 
796     /**
797      * @dev Safely transfers the ownership of a given token ID to another address
798      * If the target address is a contract, it must implement `onERC721Received`,
799      * which is called upon a safe transfer, and return the magic value
800      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
801      * the transfer is reverted.
802      * Requires the msg.sender to be the owner, approved, or operator
803      * @param from current owner of the token
804      * @param to address to receive the ownership of the given token ID
805      * @param tokenId uint256 ID of the token to be transferred
806      */
807     function safeTransferFrom(address from, address to, uint256 tokenId) public {
808         safeTransferFrom(from, to, tokenId, "");
809     }
810 
811     /**
812      * @dev Safely transfers the ownership of a given token ID to another address
813      * If the target address is a contract, it must implement `onERC721Received`,
814      * which is called upon a safe transfer, and return the magic value
815      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
816      * the transfer is reverted.
817      * Requires the msg.sender to be the owner, approved, or operator
818      * @param from current owner of the token
819      * @param to address to receive the ownership of the given token ID
820      * @param tokenId uint256 ID of the token to be transferred
821      * @param _data bytes data to send along with a safe transfer check
822      */
823     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
824         transferFrom(from, to, tokenId);
825         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
826     }
827 
828     /**
829      * @dev Returns whether the specified token exists.
830      * @param tokenId uint256 ID of the token to query the existence of
831      * @return bool whether the token exists
832      */
833     function _exists(uint256 tokenId) internal view returns (bool) {
834         address owner = _tokenOwner[tokenId];
835         return owner != address(0);
836     }
837 
838     /**
839      * @dev Returns whether the given spender can transfer a given token ID.
840      * @param spender address of the spender to query
841      * @param tokenId uint256 ID of the token to be transferred
842      * @return bool whether the msg.sender is approved for the given token ID,
843      * is an operator of the owner, or is the owner of the token
844      */
845     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
846         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
847         address owner = ownerOf(tokenId);
848         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
849     }
850 
851     /**
852      * @dev Internal function to mint a new token.
853      * Reverts if the given token ID already exists.
854      * @param to The address that will own the minted token
855      * @param tokenId uint256 ID of the token to be minted
856      */
857     function _mint(address to, uint256 tokenId) internal {
858         require(to != address(0), "ERC721: mint to the zero address");
859         require(!_exists(tokenId), "ERC721: token already minted");
860 
861         _tokenOwner[tokenId] = to;
862         _ownedTokensCount[to].increment();
863 
864         emit Transfer(address(0), to, tokenId);
865     }
866 
867     /**
868      * @dev Internal function to burn a specific token.
869      * Reverts if the token does not exist.
870      * Deprecated, use _burn(uint256) instead.
871      * @param owner owner of the token to burn
872      * @param tokenId uint256 ID of the token being burned
873      */
874     function _burn(address owner, uint256 tokenId) internal {
875         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
876 
877         _clearApproval(tokenId);
878 
879         _ownedTokensCount[owner].decrement();
880         _tokenOwner[tokenId] = address(0);
881 
882         emit Transfer(owner, address(0), tokenId);
883     }
884 
885     /**
886      * @dev Internal function to burn a specific token.
887      * Reverts if the token does not exist.
888      * @param tokenId uint256 ID of the token being burned
889      */
890     function _burn(uint256 tokenId) internal {
891         _burn(ownerOf(tokenId), tokenId);
892     }
893 
894     /**
895      * @dev Internal function to transfer ownership of a given token ID to another address.
896      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
897      * @param from current owner of the token
898      * @param to address to receive the ownership of the given token ID
899      * @param tokenId uint256 ID of the token to be transferred
900      */
901     function _transferFrom(address from, address to, uint256 tokenId) internal {
902         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
903         require(to != address(0), "ERC721: transfer to the zero address");
904 
905         _clearApproval(tokenId);
906 
907         _ownedTokensCount[from].decrement();
908         _ownedTokensCount[to].increment();
909 
910         _tokenOwner[tokenId] = to;
911 
912         emit Transfer(from, to, tokenId);
913     }
914 
915     /**
916      * @dev Internal function to invoke `onERC721Received` on a target address.
917      * The call is not executed if the target address is not a contract.
918      *
919      * This function is deprecated.
920      * @param from address representing the previous owner of the given token ID
921      * @param to target address that will receive the tokens
922      * @param tokenId uint256 ID of the token to be transferred
923      * @param _data bytes optional data to send along with the call
924      * @return bool whether the call correctly returned the expected magic value
925      */
926     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
927         internal returns (bool)
928     {
929         if (!to.isContract()) {
930             return true;
931         }
932 
933         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
934         return (retval == _ERC721_RECEIVED);
935     }
936 
937     /**
938      * @dev Private function to clear current approval of a given token ID.
939      * @param tokenId uint256 ID of the token to be transferred
940      */
941     function _clearApproval(uint256 tokenId) private {
942         if (_tokenApprovals[tokenId] != address(0)) {
943             _tokenApprovals[tokenId] = address(0);
944         }
945     }
946 }
947 
948 // File: @openzeppelin/contracts/token/ERC721/ERC721Burnable.sol
949 
950 pragma solidity ^0.5.0;
951 
952 
953 /**
954  * @title ERC721 Burnable Token
955  * @dev ERC721 Token that can be irreversibly burned (destroyed).
956  */
957 contract ERC721Burnable is ERC721 {
958     /**
959      * @dev Burns a specific ERC721 token.
960      * @param tokenId uint256 id of the ERC721 token to be burned.
961      */
962     function burn(uint256 tokenId) public {
963         //solhint-disable-next-line max-line-length
964         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721Burnable: caller is not owner nor approved");
965         _burn(tokenId);
966     }
967 }
968 
969 // File: @openzeppelin/contracts/access/Roles.sol
970 
971 pragma solidity ^0.5.0;
972 
973 /**
974  * @title Roles
975  * @dev Library for managing addresses assigned to a Role.
976  */
977 library Roles {
978     struct Role {
979         mapping (address => bool) bearer;
980     }
981 
982     /**
983      * @dev Give an account access to this role.
984      */
985     function add(Role storage role, address account) internal {
986         require(!has(role, account), "Roles: account already has role");
987         role.bearer[account] = true;
988     }
989 
990     /**
991      * @dev Remove an account's access to this role.
992      */
993     function remove(Role storage role, address account) internal {
994         require(has(role, account), "Roles: account does not have role");
995         role.bearer[account] = false;
996     }
997 
998     /**
999      * @dev Check if an account has this role.
1000      * @return bool
1001      */
1002     function has(Role storage role, address account) internal view returns (bool) {
1003         require(account != address(0), "Roles: account is the zero address");
1004         return role.bearer[account];
1005     }
1006 }
1007 
1008 // File: contracts/util/ControllerRole.sol
1009 
1010 pragma solidity 0.5.12;
1011 
1012 
1013 // solium-disable error-reason
1014 
1015 /**
1016  * @title ControllerRole
1017  * @dev An Controller role defined using the Open Zeppelin Role system.
1018  */
1019 contract ControllerRole {
1020 
1021     using Roles for Roles.Role;
1022 
1023     // NOTE: Commented out standard Role events to save gas.
1024     // event ControllerAdded(address indexed account);
1025     // event ControllerRemoved(address indexed account);
1026 
1027     Roles.Role private _controllers;
1028 
1029     constructor () public {
1030         _addController(msg.sender);
1031     }
1032 
1033     modifier onlyController() {
1034         require(isController(msg.sender));
1035         _;
1036     }
1037 
1038     function isController(address account) public view returns (bool) {
1039         return _controllers.has(account);
1040     }
1041 
1042     function addController(address account) public onlyController {
1043         _addController(account);
1044     }
1045 
1046     function renounceController() public {
1047         _removeController(msg.sender);
1048     }
1049 
1050     function _addController(address account) internal {
1051         _controllers.add(account);
1052         // emit ControllerAdded(account);
1053     }
1054 
1055     function _removeController(address account) internal {
1056         _controllers.remove(account);
1057         // emit ControllerRemoved(account);
1058     }
1059 
1060 }
1061 
1062 // File: contracts/Registry.sol
1063 
1064 pragma solidity 0.5.12;
1065 
1066 
1067 
1068 
1069 // solium-disable no-empty-blocks,error-reason
1070 
1071 /**
1072  * @title Registry
1073  * @dev An ERC721 Token see https://eips.ethereum.org/EIPS/eip-721. With
1074  * additional functions so other trusted contracts to interact with the tokens.
1075  */
1076 contract Registry is IRegistry, ControllerRole, ERC721Burnable {
1077 
1078     // Optional mapping for token URIs
1079     mapping(uint256 => string) internal _tokenURIs;
1080 
1081     string internal _prefix;
1082 
1083     // Mapping from token ID to resolver address
1084     mapping (uint256 => address) internal _tokenResolvers;
1085 
1086     // uint256(keccak256(abi.encodePacked(uint256(0x0), keccak256(abi.encodePacked("crypto")))))
1087     uint256 private constant _CRYPTO_HASH =
1088         0x0f4a10a4f46c288cea365fcf45cccf0e9d901b945b9829ccdb54c10dc3cb7a6f;
1089 
1090     modifier onlyApprovedOrOwner(uint256 tokenId) {
1091         require(_isApprovedOrOwner(msg.sender, tokenId));
1092         _;
1093     }
1094 
1095     constructor () public {
1096         _mint(address(0xdead), _CRYPTO_HASH);
1097         // register the supported interfaces to conform to ERC721 via ERC165
1098         _registerInterface(0x5b5e139f); // ERC721 Metadata Interface
1099         _tokenURIs[root()] = "crypto";
1100         emit NewURI(root(), "crypto");
1101     }
1102 
1103     /// ERC721 Metadata extension
1104 
1105     function name() external view returns (string memory) {
1106         return ".crypto";
1107     }
1108 
1109     function symbol() external view returns (string memory) {
1110         return "UD";
1111     }
1112 
1113     function tokenURI(uint256 tokenId) external view returns (string memory) {
1114         require(_exists(tokenId));
1115         return string(abi.encodePacked(_prefix, _tokenURIs[tokenId]));
1116     }
1117 
1118     function controlledSetTokenURIPrefix(string calldata prefix) external onlyController {
1119         _prefix = prefix;
1120         emit NewURIPrefix(prefix);
1121     }
1122 
1123     /// Ownership
1124 
1125     function isApprovedOrOwner(address spender, uint256 tokenId) external view returns (bool) {
1126         return _isApprovedOrOwner(spender, tokenId);
1127     }
1128 
1129     /// Registry Constants
1130 
1131     function root() public pure returns (uint256) {
1132         return _CRYPTO_HASH;
1133     }
1134 
1135     function childIdOf(uint256 tokenId, string calldata label) external pure returns (uint256) {
1136         return _childId(tokenId, label);
1137     }
1138 
1139     /// Minting
1140 
1141     function mintChild(address to, uint256 tokenId, string calldata label) external onlyApprovedOrOwner(tokenId) {
1142         _mintChild(to, tokenId, label);
1143     }
1144 
1145     function controlledMintChild(address to, uint256 tokenId, string calldata label) external onlyController {
1146         _mintChild(to, tokenId, label);
1147     }
1148 
1149     function safeMintChild(address to, uint256 tokenId, string calldata label) external onlyApprovedOrOwner(tokenId) {
1150         _safeMintChild(to, tokenId, label, "");
1151     }
1152 
1153     function safeMintChild(address to, uint256 tokenId, string calldata label, bytes calldata _data)
1154         external
1155         onlyApprovedOrOwner(tokenId)
1156     {
1157         _safeMintChild(to, tokenId, label, _data);
1158     }
1159 
1160     function controlledSafeMintChild(address to, uint256 tokenId, string calldata label, bytes calldata _data)
1161         external
1162         onlyController
1163     {
1164         _safeMintChild(to, tokenId, label, _data);
1165     }
1166 
1167     /// Transfering
1168 
1169     function setOwner(address to, uint256 tokenId) external onlyApprovedOrOwner(tokenId)  {
1170         super._transferFrom(ownerOf(tokenId), to, tokenId);
1171     }
1172 
1173     function transferFromChild(address from, address to, uint256 tokenId, string calldata label)
1174         external
1175         onlyApprovedOrOwner(tokenId)
1176     {
1177         _transferFrom(from, to, _childId(tokenId, label));
1178     }
1179 
1180     function controlledTransferFrom(address from, address to, uint256 tokenId) external onlyController {
1181         _transferFrom(from, to, tokenId);
1182     }
1183 
1184     function safeTransferFromChild(
1185         address from,
1186         address to,
1187         uint256 tokenId,
1188         string memory label,
1189         bytes memory _data
1190     ) public onlyApprovedOrOwner(tokenId) {
1191         uint256 childId = _childId(tokenId, label);
1192         _transferFrom(from, to, childId);
1193         require(_checkOnERC721Received(from, to, childId, _data));
1194     }
1195 
1196     function safeTransferFromChild(address from, address to, uint256 tokenId, string calldata label) external {
1197         safeTransferFromChild(from, to, tokenId, label, "");
1198     }
1199 
1200     function controlledSafeTransferFrom(address from, address to, uint256 tokenId, bytes calldata _data)
1201         external
1202         onlyController
1203     {
1204         _transferFrom(from, to, tokenId);
1205         require(_checkOnERC721Received(from, to, tokenId, _data));
1206     }
1207 
1208     /// Burning
1209 
1210     function burnChild(uint256 tokenId, string calldata label) external onlyApprovedOrOwner(tokenId) {
1211         _burn(_childId(tokenId, label));
1212     }
1213 
1214     function controlledBurn(uint256 tokenId) external onlyController {
1215         _burn(tokenId);
1216     }
1217 
1218     /// Resolution
1219 
1220     function resolverOf(uint256 tokenId) external view returns (address) {
1221         address resolver = _tokenResolvers[tokenId];
1222         require(resolver != address(0));
1223         return resolver;
1224     }
1225 
1226     function resolveTo(address to, uint256 tokenId) external onlyApprovedOrOwner(tokenId) {
1227         _resolveTo(to, tokenId);
1228     }
1229 
1230     function controlledResolveTo(address to, uint256 tokenId) external onlyController {
1231         _resolveTo(to, tokenId);
1232     }
1233 
1234     function sync(uint256 tokenId, uint256 updateId) external {
1235         require(_tokenResolvers[tokenId] == msg.sender);
1236         emit Sync(msg.sender, updateId, tokenId);
1237     }
1238 
1239     /// Internal
1240 
1241     function _childId(uint256 tokenId, string memory label) internal pure returns (uint256) {
1242         require(bytes(label).length != 0);
1243         return uint256(keccak256(abi.encodePacked(tokenId, keccak256(abi.encodePacked(label)))));
1244     }
1245 
1246     function _mintChild(address to, uint256 tokenId, string memory label) internal {
1247         uint256 childId = _childId(tokenId, label);
1248         _mint(to, childId);
1249 
1250         require(bytes(label).length != 0);
1251         require(_exists(childId));
1252 
1253         bytes memory domain = abi.encodePacked(label, ".", _tokenURIs[tokenId]);
1254 
1255         _tokenURIs[childId] = string(domain);
1256         emit NewURI(childId, string(domain));
1257     }
1258 
1259     function _safeMintChild(address to, uint256 tokenId, string memory label, bytes memory _data) internal {
1260         _mintChild(to, tokenId, label);
1261         require(_checkOnERC721Received(address(0), to, _childId(tokenId, label), _data));
1262     }
1263 
1264     function _transferFrom(address from, address to, uint256 tokenId) internal {
1265         super._transferFrom(from, to, tokenId);
1266         // Clear resolver (if any)
1267         if (_tokenResolvers[tokenId] != address(0x0)) {
1268             delete _tokenResolvers[tokenId];
1269         }
1270     }
1271 
1272     function _burn(uint256 tokenId) internal {
1273         super._burn(tokenId);
1274         // Clear resolver (if any)
1275         if (_tokenResolvers[tokenId] != address(0x0)) {
1276             delete _tokenResolvers[tokenId];
1277         }
1278         // Clear metadata (if any)
1279         if (bytes(_tokenURIs[tokenId]).length != 0) {
1280             delete _tokenURIs[tokenId];
1281         }
1282     }
1283 
1284     function _resolveTo(address to, uint256 tokenId) internal {
1285         require(_exists(tokenId));
1286         emit Resolve(tokenId, to);
1287         _tokenResolvers[tokenId] = to;
1288     }
1289 
1290 }
1291 
1292 // File: contracts/util/SignatureUtil.sol
1293 
1294 pragma solidity 0.5.12;
1295 
1296 
1297 
1298 // solium-disable error-reason
1299 
1300 contract SignatureUtil {
1301     using ECDSA for bytes32;
1302 
1303     // Mapping from owner to a nonce
1304     mapping (uint256 => uint256) internal _nonces;
1305 
1306     Registry internal _registry;
1307 
1308     constructor(Registry registry) public {
1309         _registry = registry;
1310     }
1311 
1312     function registry() external view returns (address) {
1313         return address(_registry);
1314     }
1315 
1316     /**
1317      * @dev Gets the nonce of the specified address.
1318      * @param tokenId token ID for nonce query
1319      * @return nonce of the given address
1320      */
1321     function nonceOf(uint256 tokenId) external view returns (uint256) {
1322         return _nonces[tokenId];
1323     }
1324 
1325     function _validate(bytes32 hash, uint256 tokenId, bytes memory signature) internal {
1326         uint256 nonce = _nonces[tokenId];
1327 
1328         address signer = keccak256(abi.encodePacked(hash, address(this), nonce)).toEthSignedMessageHash().recover(signature);
1329         require(
1330             signer != address(0) &&
1331             _registry.isApprovedOrOwner(
1332                 signer,
1333                 tokenId
1334             )
1335         );
1336 
1337         _nonces[tokenId] += 1;
1338     }
1339 
1340 }
1341 
1342 // File: contracts/controllers/SignatureController.sol
1343 
1344 pragma solidity 0.5.12;
1345 
1346 
1347 
1348 
1349 
1350 // solium-disable error-reason
1351 
1352 /**
1353  * @title SignatureController
1354  * @dev The SignatureController allows any account to submit select management
1355  * transactions on behalf of a token owner.
1356  */
1357 contract SignatureController is ISignatureController, SignatureUtil {
1358 
1359     constructor (Registry registry) public SignatureUtil(registry) {}
1360 
1361     /*
1362      * 0x23b872dd == bytes4(keccak256('transferFrom(address,address,uint256)'))
1363      */
1364     function transferFromFor(address from, address to, uint256 tokenId, bytes calldata signature) external {
1365         _validate(
1366             keccak256(abi.encodeWithSelector(0x23b872dd, from, to, tokenId)),
1367             tokenId,
1368             signature
1369         );
1370         _registry.controlledTransferFrom(from, to, tokenId);
1371     }
1372 
1373     /*
1374      * 0xb88d4fde == bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
1375      */
1376     function safeTransferFromFor(
1377         address from,
1378         address to,
1379         uint256 tokenId,
1380         bytes calldata _data,
1381         bytes calldata signature
1382     )
1383         external
1384     {
1385         _validate(
1386             keccak256(abi.encodeWithSelector(0xb88d4fde, from, to, tokenId, _data)),
1387             tokenId,
1388             signature
1389         );
1390         _registry.controlledSafeTransferFrom(from, to, tokenId, _data);
1391     }
1392 
1393     /*
1394      * 0x42842e0e == bytes4(keccak256('safeTransferFrom(address,address,uint256)'))
1395      */
1396     function safeTransferFromFor(address from, address to, uint256 tokenId, bytes calldata signature) external {
1397         _validate(
1398             keccak256(abi.encodeWithSelector(0x42842e0e, from, to, tokenId)),
1399             tokenId,
1400             signature
1401         );
1402         _registry.controlledSafeTransferFrom(from, to, tokenId, "");
1403     }
1404 
1405     /*
1406      * 0x42966c68 == bytes4(keccak256('burn(uint256)'))
1407      */
1408     function burnFor(uint256 tokenId, bytes calldata signature) external {
1409         _validate(
1410             keccak256(abi.encodeWithSelector(0x42966c68, tokenId)),
1411             tokenId,
1412             signature
1413         );
1414         _registry.controlledBurn(tokenId);
1415     }
1416 
1417     /*
1418      * 0xd8d3cc6e == bytes4(keccak256('mintChild(address,uint256,string)'))
1419      */
1420     function mintChildFor(address to, uint256 tokenId, string calldata label, bytes calldata signature) external {
1421         _validate(
1422             keccak256(abi.encodeWithSelector(0xd8d3cc6e, to, tokenId, label)),
1423             tokenId,
1424             signature
1425         );
1426         _registry.controlledMintChild(to, tokenId, label);
1427     }
1428 
1429     /*
1430      * 0xce9fb82b == bytes4(keccak256('safeMintChild(address,uint256,string,bytes)'))
1431      */
1432     function safeMintChildFor(address to, uint256 tokenId, string calldata label, bytes calldata _data, bytes calldata signature) external {
1433         _validate(
1434             keccak256(abi.encodeWithSelector(0xce9fb82b, to, tokenId, label, _data)),
1435             tokenId,
1436             signature
1437         );
1438         _registry.controlledSafeMintChild(to, tokenId, label, _data);
1439     }
1440 
1441     /*
1442      * 0x7c69eae2 == bytes4(keccak256('safeMintChild(address,uint256,string)'))
1443      */
1444     function safeMintChildFor(address to, uint256 tokenId, string calldata label, bytes calldata signature) external {
1445         _validate(
1446             keccak256(abi.encodeWithSelector(0x7c69eae2, to, tokenId, label)),
1447             tokenId,
1448             signature
1449         );
1450         _registry.controlledSafeMintChild(to, tokenId, label, "");
1451     }
1452 
1453     /*
1454      * 0x9e5be9a5 == bytes4(keccak256('transferFromChild(address,address,uint256,string)'))
1455      */
1456     function transferFromChildFor(
1457         address from,
1458         address to,
1459         uint256 tokenId,
1460         string calldata label,
1461         bytes calldata signature
1462     )
1463         external
1464     {
1465         _validate(
1466             keccak256(abi.encodeWithSelector(0x9e5be9a5, from, to, tokenId, label)),
1467             tokenId,
1468             signature
1469         );
1470         _registry.controlledTransferFrom(from, to, _registry.childIdOf(tokenId, label));
1471     }
1472 
1473     /*
1474      * 0xc29b52f9 == bytes4(keccak256('safeTransferFromChild(address,address,uint256,string,bytes)'))
1475      */
1476     function safeTransferFromChildFor(
1477         address from,
1478         address to,
1479         uint256 tokenId,
1480         string calldata label,
1481         bytes calldata _data,
1482         bytes calldata signature
1483     )
1484         external
1485     {
1486         _validate(
1487             keccak256(abi.encodeWithSelector(0xc29b52f9, from, to, tokenId, label, _data)),
1488             tokenId,
1489             signature
1490         );
1491         _registry.controlledSafeTransferFrom(from, to, _registry.childIdOf(tokenId, label), _data);
1492     }
1493 
1494     /*
1495      * 0x9d743989 == bytes4(keccak256('safeTransferFromChild(address,address,uint256,string)'))
1496      */
1497     function safeTransferFromChildFor(
1498         address from,
1499         address to,
1500         uint256 tokenId,
1501         string calldata label,
1502         bytes calldata signature
1503     )
1504         external
1505     {
1506         _validate(
1507             keccak256(abi.encodeWithSelector(0x9d743989, from, to, tokenId, label)),
1508             tokenId,
1509             signature
1510         );
1511         _registry.controlledSafeTransferFrom(from, to, _registry.childIdOf(tokenId, label), "");
1512     }
1513 
1514     /*
1515      * 0x5cbe1112 == bytes4(keccak256('burnChild(uint256,string)'))
1516      */
1517     function burnChildFor(uint256 tokenId, string calldata label, bytes calldata signature) external {
1518         _validate(
1519             keccak256(abi.encodeWithSelector(0x5cbe1112, tokenId, label)),
1520             tokenId,
1521             signature
1522         );
1523         _registry.controlledBurn(_registry.childIdOf(tokenId, label));
1524     }
1525 
1526     /*
1527      * 0x2392c189 == bytes4(keccak256('resolveTo(address,uint256)'))
1528      */
1529     function resolveToFor(address to, uint256 tokenId, bytes calldata signature) external {
1530         _validate(
1531             keccak256(abi.encodeWithSelector(0x2392c189, to, tokenId)),
1532             tokenId,
1533             signature
1534         );
1535         _registry.controlledResolveTo(to, tokenId);
1536     }
1537 
1538 }