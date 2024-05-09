1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.7;
4 
5 
6 
7 // Part: IheroesUpgrader
8 
9 interface IheroesUpgrader {
10 
11     enum Rarity {Simple, SimpleUpgraded, Rare, Legendary, F1, F2, F3}
12     function getRarity(address _contract, uint256 tokenId) external view returns (uint8);
13     function getRarity2(address _contract, uint256 tokenId) external view returns (uint8);
14 }
15 
16 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/Context
17 
18 /**
19  * @dev Provides information about the current execution context, including the
20  * sender of the transaction and its data. While these are generally available
21  * via msg.sender and msg.data, they should not be accessed in such a direct
22  * manner, since when dealing with meta-transactions the account sending and
23  * paying for execution may not be the actual sender (as far as an application
24  * is concerned).
25  *
26  * This contract is only required for intermediate, library-like contracts.
27  */
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes calldata) {
34         return msg.data;
35     }
36 }
37 
38 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/ECDSA
39 
40 /**
41  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
42  *
43  * These functions can be used to verify that a message was signed by the holder
44  * of the private keys of a given address.
45  */
46 library ECDSA {
47     enum RecoverError {
48         NoError,
49         InvalidSignature,
50         InvalidSignatureLength,
51         InvalidSignatureS,
52         InvalidSignatureV
53     }
54 
55     function _throwError(RecoverError error) private pure {
56         if (error == RecoverError.NoError) {
57             return; // no error: do nothing
58         } else if (error == RecoverError.InvalidSignature) {
59             revert("ECDSA: invalid signature");
60         } else if (error == RecoverError.InvalidSignatureLength) {
61             revert("ECDSA: invalid signature length");
62         } else if (error == RecoverError.InvalidSignatureS) {
63             revert("ECDSA: invalid signature 's' value");
64         } else if (error == RecoverError.InvalidSignatureV) {
65             revert("ECDSA: invalid signature 'v' value");
66         }
67     }
68 
69     /**
70      * @dev Returns the address that signed a hashed message (`hash`) with
71      * `signature` or error string. This address can then be used for verification purposes.
72      *
73      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
74      * this function rejects them by requiring the `s` value to be in the lower
75      * half order, and the `v` value to be either 27 or 28.
76      *
77      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
78      * verification to be secure: it is possible to craft signatures that
79      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
80      * this is by receiving a hash of the original message (which may otherwise
81      * be too long), and then calling {toEthSignedMessageHash} on it.
82      *
83      * Documentation for signature generation:
84      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
85      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
86      *
87      * _Available since v4.3._
88      */
89     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
90         // Check the signature length
91         // - case 65: r,s,v signature (standard)
92         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
93         if (signature.length == 65) {
94             bytes32 r;
95             bytes32 s;
96             uint8 v;
97             // ecrecover takes the signature parameters, and the only way to get them
98             // currently is to use assembly.
99             assembly {
100                 r := mload(add(signature, 0x20))
101                 s := mload(add(signature, 0x40))
102                 v := byte(0, mload(add(signature, 0x60)))
103             }
104             return tryRecover(hash, v, r, s);
105         } else if (signature.length == 64) {
106             bytes32 r;
107             bytes32 vs;
108             // ecrecover takes the signature parameters, and the only way to get them
109             // currently is to use assembly.
110             assembly {
111                 r := mload(add(signature, 0x20))
112                 vs := mload(add(signature, 0x40))
113             }
114             return tryRecover(hash, r, vs);
115         } else {
116             return (address(0), RecoverError.InvalidSignatureLength);
117         }
118     }
119 
120     /**
121      * @dev Returns the address that signed a hashed message (`hash`) with
122      * `signature`. This address can then be used for verification purposes.
123      *
124      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
125      * this function rejects them by requiring the `s` value to be in the lower
126      * half order, and the `v` value to be either 27 or 28.
127      *
128      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
129      * verification to be secure: it is possible to craft signatures that
130      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
131      * this is by receiving a hash of the original message (which may otherwise
132      * be too long), and then calling {toEthSignedMessageHash} on it.
133      */
134     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
135         (address recovered, RecoverError error) = tryRecover(hash, signature);
136         _throwError(error);
137         return recovered;
138     }
139 
140     /**
141      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
142      *
143      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
144      *
145      * _Available since v4.3._
146      */
147     function tryRecover(
148         bytes32 hash,
149         bytes32 r,
150         bytes32 vs
151     ) internal pure returns (address, RecoverError) {
152         bytes32 s;
153         uint8 v;
154         assembly {
155             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
156             v := add(shr(255, vs), 27)
157         }
158         return tryRecover(hash, v, r, s);
159     }
160 
161     /**
162      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
163      *
164      * _Available since v4.2._
165      */
166     function recover(
167         bytes32 hash,
168         bytes32 r,
169         bytes32 vs
170     ) internal pure returns (address) {
171         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
172         _throwError(error);
173         return recovered;
174     }
175 
176     /**
177      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
178      * `r` and `s` signature fields separately.
179      *
180      * _Available since v4.3._
181      */
182     function tryRecover(
183         bytes32 hash,
184         uint8 v,
185         bytes32 r,
186         bytes32 s
187     ) internal pure returns (address, RecoverError) {
188         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
189         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
190         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
191         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
192         //
193         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
194         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
195         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
196         // these malleable signatures as well.
197         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
198             return (address(0), RecoverError.InvalidSignatureS);
199         }
200         if (v != 27 && v != 28) {
201             return (address(0), RecoverError.InvalidSignatureV);
202         }
203 
204         // If the signature is valid (and not malleable), return the signer address
205         address signer = ecrecover(hash, v, r, s);
206         if (signer == address(0)) {
207             return (address(0), RecoverError.InvalidSignature);
208         }
209 
210         return (signer, RecoverError.NoError);
211     }
212 
213     /**
214      * @dev Overload of {ECDSA-recover} that receives the `v`,
215      * `r` and `s` signature fields separately.
216      */
217     function recover(
218         bytes32 hash,
219         uint8 v,
220         bytes32 r,
221         bytes32 s
222     ) internal pure returns (address) {
223         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
224         _throwError(error);
225         return recovered;
226     }
227 
228     /**
229      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
230      * produces hash corresponding to the one signed with the
231      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
232      * JSON-RPC method as part of EIP-191.
233      *
234      * See {recover}.
235      */
236     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
237         // 32 is the length in bytes of hash,
238         // enforced by the type signature above
239         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
240     }
241 
242     /**
243      * @dev Returns an Ethereum Signed Typed Data, created from a
244      * `domainSeparator` and a `structHash`. This produces hash corresponding
245      * to the one signed with the
246      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
247      * JSON-RPC method as part of EIP-712.
248      *
249      * See {recover}.
250      */
251     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
252         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
253     }
254 }
255 
256 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/IERC165
257 
258 /**
259  * @dev Interface of the ERC165 standard, as defined in the
260  * https://eips.ethereum.org/EIPS/eip-165[EIP].
261  *
262  * Implementers can declare support of contract interfaces, which can then be
263  * queried by others ({ERC165Checker}).
264  *
265  * For an implementation, see {ERC165}.
266  */
267 interface IERC165 {
268     /**
269      * @dev Returns true if this contract implements the interface defined by
270      * `interfaceId`. See the corresponding
271      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
272      * to learn more about how these ids are created.
273      *
274      * This function call must use less than 30 000 gas.
275      */
276     function supportsInterface(bytes4 interfaceId) external view returns (bool);
277 }
278 
279 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/IERC20
280 
281 /**
282  * @dev Interface of the ERC20 standard as defined in the EIP.
283  */
284 interface IERC20 {
285     /**
286      * @dev Returns the amount of tokens in existence.
287      */
288     function totalSupply() external view returns (uint256);
289 
290     /**
291      * @dev Returns the amount of tokens owned by `account`.
292      */
293     function balanceOf(address account) external view returns (uint256);
294 
295     /**
296      * @dev Moves `amount` tokens from the caller's account to `recipient`.
297      *
298      * Returns a boolean value indicating whether the operation succeeded.
299      *
300      * Emits a {Transfer} event.
301      */
302     function transfer(address recipient, uint256 amount) external returns (bool);
303 
304     /**
305      * @dev Returns the remaining number of tokens that `spender` will be
306      * allowed to spend on behalf of `owner` through {transferFrom}. This is
307      * zero by default.
308      *
309      * This value changes when {approve} or {transferFrom} are called.
310      */
311     function allowance(address owner, address spender) external view returns (uint256);
312 
313     /**
314      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
315      *
316      * Returns a boolean value indicating whether the operation succeeded.
317      *
318      * IMPORTANT: Beware that changing an allowance with this method brings the risk
319      * that someone may use both the old and the new allowance by unfortunate
320      * transaction ordering. One possible solution to mitigate this race
321      * condition is to first reduce the spender's allowance to 0 and set the
322      * desired value afterwards:
323      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
324      *
325      * Emits an {Approval} event.
326      */
327     function approve(address spender, uint256 amount) external returns (bool);
328 
329     /**
330      * @dev Moves `amount` tokens from `sender` to `recipient` using the
331      * allowance mechanism. `amount` is then deducted from the caller's
332      * allowance.
333      *
334      * Returns a boolean value indicating whether the operation succeeded.
335      *
336      * Emits a {Transfer} event.
337      */
338     function transferFrom(
339         address sender,
340         address recipient,
341         uint256 amount
342     ) external returns (bool);
343 
344     /**
345      * @dev Emitted when `value` tokens are moved from one account (`from`) to
346      * another (`to`).
347      *
348      * Note that `value` may be zero.
349      */
350     event Transfer(address indexed from, address indexed to, uint256 value);
351 
352     /**
353      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
354      * a call to {approve}. `value` is the new allowance.
355      */
356     event Approval(address indexed owner, address indexed spender, uint256 value);
357 }
358 
359 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/IERC721Receiver
360 
361 /**
362  * @title ERC721 token receiver interface
363  * @dev Interface for any contract that wants to support safeTransfers
364  * from ERC721 asset contracts.
365  */
366 interface IERC721Receiver {
367     /**
368      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
369      * by `operator` from `from`, this function is called.
370      *
371      * It must return its Solidity selector to confirm the token transfer.
372      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
373      *
374      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
375      */
376     function onERC721Received(
377         address operator,
378         address from,
379         uint256 tokenId,
380         bytes calldata data
381     ) external returns (bytes4);
382 }
383 
384 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/IERC721
385 
386 /**
387  * @dev Required interface of an ERC721 compliant contract.
388  */
389 interface IERC721 is IERC165 {
390     /**
391      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
392      */
393     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
394 
395     /**
396      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
397      */
398     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
399 
400     /**
401      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
402      */
403     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
404 
405     /**
406      * @dev Returns the number of tokens in ``owner``'s account.
407      */
408     function balanceOf(address owner) external view returns (uint256 balance);
409 
410     /**
411      * @dev Returns the owner of the `tokenId` token.
412      *
413      * Requirements:
414      *
415      * - `tokenId` must exist.
416      */
417     function ownerOf(uint256 tokenId) external view returns (address owner);
418 
419     /**
420      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
421      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
422      *
423      * Requirements:
424      *
425      * - `from` cannot be the zero address.
426      * - `to` cannot be the zero address.
427      * - `tokenId` token must exist and be owned by `from`.
428      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
429      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
430      *
431      * Emits a {Transfer} event.
432      */
433     function safeTransferFrom(
434         address from,
435         address to,
436         uint256 tokenId
437     ) external;
438 
439     /**
440      * @dev Transfers `tokenId` token from `from` to `to`.
441      *
442      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
443      *
444      * Requirements:
445      *
446      * - `from` cannot be the zero address.
447      * - `to` cannot be the zero address.
448      * - `tokenId` token must be owned by `from`.
449      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
450      *
451      * Emits a {Transfer} event.
452      */
453     function transferFrom(
454         address from,
455         address to,
456         uint256 tokenId
457     ) external;
458 
459     /**
460      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
461      * The approval is cleared when the token is transferred.
462      *
463      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
464      *
465      * Requirements:
466      *
467      * - The caller must own the token or be an approved operator.
468      * - `tokenId` must exist.
469      *
470      * Emits an {Approval} event.
471      */
472     function approve(address to, uint256 tokenId) external;
473 
474     /**
475      * @dev Returns the account approved for `tokenId` token.
476      *
477      * Requirements:
478      *
479      * - `tokenId` must exist.
480      */
481     function getApproved(uint256 tokenId) external view returns (address operator);
482 
483     /**
484      * @dev Approve or remove `operator` as an operator for the caller.
485      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
486      *
487      * Requirements:
488      *
489      * - The `operator` cannot be the caller.
490      *
491      * Emits an {ApprovalForAll} event.
492      */
493     function setApprovalForAll(address operator, bool _approved) external;
494 
495     /**
496      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
497      *
498      * See {setApprovalForAll}
499      */
500     function isApprovedForAll(address owner, address operator) external view returns (bool);
501 
502     /**
503      * @dev Safely transfers `tokenId` token from `from` to `to`.
504      *
505      * Requirements:
506      *
507      * - `from` cannot be the zero address.
508      * - `to` cannot be the zero address.
509      * - `tokenId` token must exist and be owned by `from`.
510      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
511      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
512      *
513      * Emits a {Transfer} event.
514      */
515     function safeTransferFrom(
516         address from,
517         address to,
518         uint256 tokenId,
519         bytes calldata data
520     ) external;
521 }
522 
523 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/Ownable
524 
525 /**
526  * @dev Contract module which provides a basic access control mechanism, where
527  * there is an account (an owner) that can be granted exclusive access to
528  * specific functions.
529  *
530  * By default, the owner account will be the one that deploys the contract. This
531  * can later be changed with {transferOwnership}.
532  *
533  * This module is used through inheritance. It will make available the modifier
534  * `onlyOwner`, which can be applied to your functions to restrict their use to
535  * the owner.
536  */
537 abstract contract Ownable is Context {
538     address private _owner;
539 
540     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
541 
542     /**
543      * @dev Initializes the contract setting the deployer as the initial owner.
544      */
545     constructor() {
546         _setOwner(_msgSender());
547     }
548 
549     /**
550      * @dev Returns the address of the current owner.
551      */
552     function owner() public view virtual returns (address) {
553         return _owner;
554     }
555 
556     /**
557      * @dev Throws if called by any account other than the owner.
558      */
559     modifier onlyOwner() {
560         require(owner() == _msgSender(), "Ownable: caller is not the owner");
561         _;
562     }
563 
564     /**
565      * @dev Leaves the contract without owner. It will not be possible to call
566      * `onlyOwner` functions anymore. Can only be called by the current owner.
567      *
568      * NOTE: Renouncing ownership will leave the contract without an owner,
569      * thereby removing any functionality that is only available to the owner.
570      */
571     function renounceOwnership() public virtual onlyOwner {
572         _setOwner(address(0));
573     }
574 
575     /**
576      * @dev Transfers ownership of the contract to a new account (`newOwner`).
577      * Can only be called by the current owner.
578      */
579     function transferOwnership(address newOwner) public virtual onlyOwner {
580         require(newOwner != address(0), "Ownable: new owner is the zero address");
581         _setOwner(newOwner);
582     }
583 
584     function _setOwner(address newOwner) private {
585         address oldOwner = _owner;
586         _owner = newOwner;
587         emit OwnershipTransferred(oldOwner, newOwner);
588     }
589 }
590 
591 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/IERC721Enumerable
592 
593 /**
594  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
595  * @dev See https://eips.ethereum.org/EIPS/eip-721
596  */
597 interface IERC721Enumerable is IERC721 {
598     /**
599      * @dev Returns the total amount of tokens stored by the contract.
600      */
601     function totalSupply() external view returns (uint256);
602 
603     /**
604      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
605      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
606      */
607     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
608 
609     /**
610      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
611      * Use along with {totalSupply} to enumerate all tokens.
612      */
613     function tokenByIndex(uint256 index) external view returns (uint256);
614 }
615 
616 // File: NFT721Farming.sol
617 
618 contract NFT721Farming is Ownable, IERC721Receiver {
619 
620     using ECDSA for bytes32;
621     // pool struct
622     struct PoolInfo {
623         uint256 totalReward;       // total reward for pull
624         uint256 lastRewardTime;    // last block that reward is given
625         uint256 expectedLastTime;  // last block that farming is supposed to finish
626         uint256 blockCreation;
627 
628     }
629 
630     // user struct
631     struct UserInfo {
632         uint256 rewardDebt;         // substracted reward from user's total reward
633         uint256 lastBlock;
634     }
635 
636     struct TokenInfo {
637         bool isFarming;             // user is farming or not
638         uint256 tokenId;            // token id
639         address tokenAddress;       // address of the NFT721 address
640     }
641 
642 
643     address public NFTS;
644     address public heroesUpgrader;
645     address[] internal users;
646 
647     mapping (uint8 => mapping(address => TokenInfo[])) public userTokenInfo; // rarity => user
648     mapping (address => UserInfo) private userRewardInfo;
649     mapping (uint8 => PoolInfo) public poolInfo;  // rarity => pool info
650     mapping (address => bool) public trustedSigner;
651 
652     /// Emit in case of any changes: stake or unstake for now
653     /// 0 - Staked
654     /// 1 - Unstaked 
655     event StakeChanged(address indexed user, uint256 tokenId, uint256 timestamp, uint8 changeType);
656     event Harvest(address indexed user, uint256 _amount, uint256 lastBlockNumber, uint256 currentBlockNumber);
657 
658 
659     constructor(address _contract, address reward) {
660         heroesUpgrader = _contract;
661         NFTS = reward;
662     }
663 
664 
665     function deposit(address tokenAddress, uint256 tokenId) public {
666         _deposit(msg.sender,tokenAddress, tokenId);
667         emit StakeChanged(msg.sender, tokenId, block.timestamp, 0);
668     }
669 
670 
671     function depositBatch(address tokenAddress, uint256[] memory tokenId) public {
672          _depositBatch(msg.sender, tokenAddress, tokenId);
673     }
674 
675     function withdraw(uint8 rarity,  uint256 index) public {
676         PoolInfo storage pool = poolInfo[rarity];
677         TokenInfo storage user = userTokenInfo[rarity][msg.sender][index];
678 
679         user.isFarming = false;
680         IERC721 nft = IERC721(user.tokenAddress);
681         nft.safeTransferFrom(address(this), address(msg.sender), user.tokenId, "");
682         emit StakeChanged(msg.sender, user.tokenId, block.timestamp,1);
683     }
684 
685     function harvest(
686         uint256 _amount, 
687         uint256 _lastBlockNumber, 
688         uint256 _currentBlockNumber, 
689         bytes32 _msgForSign, 
690         bytes memory _signature
691     ) public 
692     {
693         require(_currentBlockNumber <= block.number, "currentBlockNumber cannot be larger than the last block");
694 
695         //Double spend check
696         require(getLastBlock(msg.sender) == _lastBlockNumber, "lastBlockNumber must be equal to the value in the storage");
697 
698         //1. Lets check signer
699         address signedBy = _msgForSign.recover(_signature);
700         require(trustedSigner[signedBy] == true, "Signature check failed!");
701 
702         //2. Check signed msg integrety
703         bytes32 actualMsg = getMsgForSign(
704             _amount,
705             _lastBlockNumber,
706             _currentBlockNumber,
707             msg.sender
708         );
709         require(actualMsg.toEthSignedMessageHash() == _msgForSign,"Integrety check failed!");
710 
711         //Actions
712 
713         userRewardInfo[msg.sender].rewardDebt += _amount;
714         userRewardInfo[msg.sender].lastBlock = _currentBlockNumber;
715         if (_amount > 0) {
716             IERC20 ERC20Token = IERC20(NFTS);
717             ERC20Token.transfer(msg.sender, _amount);
718         }
719         emit Harvest(msg.sender, _amount, _lastBlockNumber, _currentBlockNumber);
720     }
721 
722 
723 
724     function getMyTokenIds(address _user, address tokenAddress) public view returns(uint256[] memory) {
725         return _getMyTokenIds(_user, tokenAddress);
726     }
727 
728     function getRewards(address _user) public view returns(uint256) {
729         return  userRewardInfo[_user].rewardDebt;
730     }
731 
732 
733     function getLastBlock(address _user) public view returns(uint256) {
734         return userRewardInfo[_user].lastBlock;
735     }
736 
737 
738     function getMsgForSign(uint256 _amount, uint256 _lastBlockNumber, uint256 _currentBlockNumber, address _sender) public pure returns(bytes32) {
739         return keccak256(abi.encode( _amount, _lastBlockNumber, _currentBlockNumber, _sender));
740     }
741 
742     function getUserNFTsInfosByRare(address _user, uint8 rare) public view returns (TokenInfo[] memory) {
743         return userTokenInfo[rare][_user];
744     }
745 
746     function getUserBalanceByRare(address _user, uint8 rare) public view returns (uint256) {
747         return _getUserBalanceByRares(_user, rare);
748     }
749 
750     function getUsersCount() public view returns(uint256) {
751         return users.length;
752     } 
753     
754     function getUser(uint256 _userId) public view returns(address) {
755         return users[_userId];
756     } 
757 
758     ////////////////////////////////////////////////////////////
759     /////////// Admin only           ////////////////////////////
760     ////////////////////////////////////////////////////////////
761     function addFarming(uint8 r,  uint256 _totalReward, uint256 dailyReward, uint256 _startTime, uint256 _endTime) public onlyOwner {
762         require(IERC20(NFTS).balanceOf(address(this))>= _totalReward, "Unsufficient balance");
763 
764         poolInfo[r] = PoolInfo({
765                                 lastRewardTime: _startTime,
766                                 expectedLastTime: _endTime,
767                                 totalReward : _totalReward,
768                                 blockCreation : block.number
769         });
770     }
771 
772 
773     function updateFarmingTotalReward(uint8 r, uint256 _totalReward) public onlyOwner {
774         poolInfo[r].totalReward = _totalReward;
775 
776     }
777     function setTrustedSigner(address _signer, bool _isValid) public onlyOwner {
778         trustedSigner[_signer] = _isValid;
779     }
780 
781 
782     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data
783     ) external override returns (bytes4) {
784         return IERC721Receiver.onERC721Received.selector;
785     }
786 
787 
788      ////////////////////////////////////////////////////////////
789     /////////// internal           /////////////////////////////
790     ////////////////////////////////////////////////////////////
791 
792     function _registration(address _user, uint256 _lastBlock) internal {
793 
794         if (getLastBlock(_user) == 0){
795             users.push(_user);
796         }
797         UserInfo storage _userInfo = userRewardInfo[_user];
798         _userInfo.lastBlock = _lastBlock;
799     }
800 
801     function _getUserBalanceByRares(address _user, uint8 rare) internal view returns (uint256) {
802         TokenInfo[] memory user =  userTokenInfo[rare][_user];
803         uint256 balance;
804         for(uint256 i=0; i<user.length; i++) {
805             if(user[i].isFarming) {
806                 balance++;
807             }
808         }
809         return balance;
810     }
811 
812 
813     function _depositBatch(address _user, address tokenAddress, uint256[] memory tokenId) internal {
814         for(uint256 i=0; i<tokenId.length; i++) {
815             _deposit(_user, tokenAddress, tokenId[i]);
816             emit StakeChanged(_user, tokenId[i], block.timestamp, 0);
817         }
818     }
819 
820     function _deposit(address _user, address tokenAddress, uint256 tokenId) internal {
821         uint8 r =  IheroesUpgrader(heroesUpgrader).getRarity2(tokenAddress, tokenId);
822         PoolInfo storage pool = poolInfo[r];
823         require(pool.blockCreation > 0, "Pool with this rarity does not exists");
824         TokenInfo[] storage user =  userTokenInfo[r][_user];
825         IERC721 nft = IERC721(tokenAddress);
826         nft.safeTransferFrom(address(_user), address(this), tokenId);
827 
828         _registration(_user, block.number);
829 
830         user.push(TokenInfo({
831             isFarming: true,
832             tokenId: tokenId,
833             tokenAddress: tokenAddress
834         }));
835     }
836 
837     function _getMyTokenIds(address _user, address tokenAddress) internal view returns (uint256[] memory) {
838         IERC721Enumerable nft = IERC721Enumerable(tokenAddress);
839         uint256 balance = nft.balanceOf(_user);
840         uint256[] memory tokenIds = new uint256[](balance);
841 
842         for(uint256 i=0; i<balance; i++) {
843             tokenIds[i] = (nft.tokenOfOwnerByIndex(_user, i));
844         }
845         return tokenIds;
846     }
847 }
