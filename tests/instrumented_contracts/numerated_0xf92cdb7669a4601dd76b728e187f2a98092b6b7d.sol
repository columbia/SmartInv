1 // Sources flattened with hardhat v2.7.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.3.3
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(
67         address sender,
68         address recipient,
69         uint256 amount
70     ) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 
88 // File @openzeppelin/contracts/utils/Context.sol@v4.3.3
89 
90 
91 
92 pragma solidity ^0.8.0;
93 
94 /**
95  * @dev Provides information about the current execution context, including the
96  * sender of the transaction and its data. While these are generally available
97  * via msg.sender and msg.data, they should not be accessed in such a direct
98  * manner, since when dealing with meta-transactions the account sending and
99  * paying for execution may not be the actual sender (as far as an application
100  * is concerned).
101  *
102  * This contract is only required for intermediate, library-like contracts.
103  */
104 abstract contract Context {
105     function _msgSender() internal view virtual returns (address) {
106         return msg.sender;
107     }
108 
109     function _msgData() internal view virtual returns (bytes calldata) {
110         return msg.data;
111     }
112 }
113 
114 
115 // File @openzeppelin/contracts/security/Pausable.sol@v4.3.3
116 
117 
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev Contract module which allows children to implement an emergency stop
123  * mechanism that can be triggered by an authorized account.
124  *
125  * This module is used through inheritance. It will make available the
126  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
127  * the functions of your contract. Note that they will not be pausable by
128  * simply including this module, only once the modifiers are put in place.
129  */
130 abstract contract Pausable is Context {
131     /**
132      * @dev Emitted when the pause is triggered by `account`.
133      */
134     event Paused(address account);
135 
136     /**
137      * @dev Emitted when the pause is lifted by `account`.
138      */
139     event Unpaused(address account);
140 
141     bool private _paused;
142 
143     /**
144      * @dev Initializes the contract in unpaused state.
145      */
146     constructor() {
147         _paused = false;
148     }
149 
150     /**
151      * @dev Returns true if the contract is paused, and false otherwise.
152      */
153     function paused() public view virtual returns (bool) {
154         return _paused;
155     }
156 
157     /**
158      * @dev Modifier to make a function callable only when the contract is not paused.
159      *
160      * Requirements:
161      *
162      * - The contract must not be paused.
163      */
164     modifier whenNotPaused() {
165         require(!paused(), "Pausable: paused");
166         _;
167     }
168 
169     /**
170      * @dev Modifier to make a function callable only when the contract is paused.
171      *
172      * Requirements:
173      *
174      * - The contract must be paused.
175      */
176     modifier whenPaused() {
177         require(paused(), "Pausable: not paused");
178         _;
179     }
180 
181     /**
182      * @dev Triggers stopped state.
183      *
184      * Requirements:
185      *
186      * - The contract must not be paused.
187      */
188     function _pause() internal virtual whenNotPaused {
189         _paused = true;
190         emit Paused(_msgSender());
191     }
192 
193     /**
194      * @dev Returns to normal state.
195      *
196      * Requirements:
197      *
198      * - The contract must be paused.
199      */
200     function _unpause() internal virtual whenPaused {
201         _paused = false;
202         emit Unpaused(_msgSender());
203     }
204 }
205 
206 
207 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.3.3
208 
209 
210 
211 pragma solidity ^0.8.0;
212 
213 /**
214  * @dev Contract module that helps prevent reentrant calls to a function.
215  *
216  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
217  * available, which can be applied to functions to make sure there are no nested
218  * (reentrant) calls to them.
219  *
220  * Note that because there is a single `nonReentrant` guard, functions marked as
221  * `nonReentrant` may not call one another. This can be worked around by making
222  * those functions `private`, and then adding `external` `nonReentrant` entry
223  * points to them.
224  *
225  * TIP: If you would like to learn more about reentrancy and alternative ways
226  * to protect against it, check out our blog post
227  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
228  */
229 abstract contract ReentrancyGuard {
230     // Booleans are more expensive than uint256 or any type that takes up a full
231     // word because each write operation emits an extra SLOAD to first read the
232     // slot's contents, replace the bits taken up by the boolean, and then write
233     // back. This is the compiler's defense against contract upgrades and
234     // pointer aliasing, and it cannot be disabled.
235 
236     // The values being non-zero value makes deployment a bit more expensive,
237     // but in exchange the refund on every call to nonReentrant will be lower in
238     // amount. Since refunds are capped to a percentage of the total
239     // transaction's gas, it is best to keep them low in cases like this one, to
240     // increase the likelihood of the full refund coming into effect.
241     uint256 private constant _NOT_ENTERED = 1;
242     uint256 private constant _ENTERED = 2;
243 
244     uint256 private _status;
245 
246     constructor() {
247         _status = _NOT_ENTERED;
248     }
249 
250     /**
251      * @dev Prevents a contract from calling itself, directly or indirectly.
252      * Calling a `nonReentrant` function from another `nonReentrant`
253      * function is not supported. It is possible to prevent this from happening
254      * by making the `nonReentrant` function external, and make it call a
255      * `private` function that does the actual work.
256      */
257     modifier nonReentrant() {
258         // On the first call to nonReentrant, _notEntered will be true
259         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
260 
261         // Any calls to nonReentrant after this point will fail
262         _status = _ENTERED;
263 
264         _;
265 
266         // By storing the original value once again, a refund is triggered (see
267         // https://eips.ethereum.org/EIPS/eip-2200)
268         _status = _NOT_ENTERED;
269     }
270 }
271 
272 
273 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.3
274 
275 
276 
277 pragma solidity ^0.8.0;
278 
279 /**
280  * @dev Contract module which provides a basic access control mechanism, where
281  * there is an account (an owner) that can be granted exclusive access to
282  * specific functions.
283  *
284  * By default, the owner account will be the one that deploys the contract. This
285  * can later be changed with {transferOwnership}.
286  *
287  * This module is used through inheritance. It will make available the modifier
288  * `onlyOwner`, which can be applied to your functions to restrict their use to
289  * the owner.
290  */
291 abstract contract Ownable is Context {
292     address private _owner;
293 
294     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
295 
296     /**
297      * @dev Initializes the contract setting the deployer as the initial owner.
298      */
299     constructor() {
300         _setOwner(_msgSender());
301     }
302 
303     /**
304      * @dev Returns the address of the current owner.
305      */
306     function owner() public view virtual returns (address) {
307         return _owner;
308     }
309 
310     /**
311      * @dev Throws if called by any account other than the owner.
312      */
313     modifier onlyOwner() {
314         require(owner() == _msgSender(), "Ownable: caller is not the owner");
315         _;
316     }
317 
318     /**
319      * @dev Leaves the contract without owner. It will not be possible to call
320      * `onlyOwner` functions anymore. Can only be called by the current owner.
321      *
322      * NOTE: Renouncing ownership will leave the contract without an owner,
323      * thereby removing any functionality that is only available to the owner.
324      */
325     function renounceOwnership() public virtual onlyOwner {
326         _setOwner(address(0));
327     }
328 
329     /**
330      * @dev Transfers ownership of the contract to a new account (`newOwner`).
331      * Can only be called by the current owner.
332      */
333     function transferOwnership(address newOwner) public virtual onlyOwner {
334         require(newOwner != address(0), "Ownable: new owner is the zero address");
335         _setOwner(newOwner);
336     }
337 
338     function _setOwner(address newOwner) private {
339         address oldOwner = _owner;
340         _owner = newOwner;
341         emit OwnershipTransferred(oldOwner, newOwner);
342     }
343 }
344 
345 
346 // File contracts/utils/AccessProtected.sol
347 
348 
349 pragma solidity ^0.8.0;
350 
351 abstract contract AccessProtected is Ownable {
352     mapping(address => bool) private _admins; // user address => admin? mapping
353 
354     event AdminAccess(address _admin, bool _isEnabled);
355 
356     /**
357      * @notice Set Admin Access
358      *
359      * @param admin - Address of Minter
360      * @param isEnabled - Enable/Disable Admin Access
361      */
362     function setAdmin(address admin, bool isEnabled) external onlyOwner {
363         _admins[admin] = isEnabled;
364         emit AdminAccess(admin, isEnabled);
365     }
366 
367     /**
368      * @notice Check Admin Access
369      *
370      * @param admin - Address of Admin
371      * @return whether minter has access
372      */
373     function isAdmin(address admin) public view returns (bool) {
374         return _admins[admin];
375     }
376 
377     /**
378      * Throws if called by any account other than the Admin.
379      */
380     modifier onlyAdmin() {
381         require(_admins[_msgSender()] || _msgSender() == owner(), "Caller does not have Admin Access");
382         _;
383     }
384 }
385 
386 
387 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.3.3
388 
389 
390 
391 pragma solidity ^0.8.0;
392 
393 /**
394  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
395  *
396  * These functions can be used to verify that a message was signed by the holder
397  * of the private keys of a given address.
398  */
399 library ECDSA {
400     enum RecoverError {
401         NoError,
402         InvalidSignature,
403         InvalidSignatureLength,
404         InvalidSignatureS,
405         InvalidSignatureV
406     }
407 
408     function _throwError(RecoverError error) private pure {
409         if (error == RecoverError.NoError) {
410             return; // no error: do nothing
411         } else if (error == RecoverError.InvalidSignature) {
412             revert("ECDSA: invalid signature");
413         } else if (error == RecoverError.InvalidSignatureLength) {
414             revert("ECDSA: invalid signature length");
415         } else if (error == RecoverError.InvalidSignatureS) {
416             revert("ECDSA: invalid signature 's' value");
417         } else if (error == RecoverError.InvalidSignatureV) {
418             revert("ECDSA: invalid signature 'v' value");
419         }
420     }
421 
422     /**
423      * @dev Returns the address that signed a hashed message (`hash`) with
424      * `signature` or error string. This address can then be used for verification purposes.
425      *
426      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
427      * this function rejects them by requiring the `s` value to be in the lower
428      * half order, and the `v` value to be either 27 or 28.
429      *
430      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
431      * verification to be secure: it is possible to craft signatures that
432      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
433      * this is by receiving a hash of the original message (which may otherwise
434      * be too long), and then calling {toEthSignedMessageHash} on it.
435      *
436      * Documentation for signature generation:
437      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
438      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
439      *
440      * _Available since v4.3._
441      */
442     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
443         // Check the signature length
444         // - case 65: r,s,v signature (standard)
445         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
446         if (signature.length == 65) {
447             bytes32 r;
448             bytes32 s;
449             uint8 v;
450             // ecrecover takes the signature parameters, and the only way to get them
451             // currently is to use assembly.
452             assembly {
453                 r := mload(add(signature, 0x20))
454                 s := mload(add(signature, 0x40))
455                 v := byte(0, mload(add(signature, 0x60)))
456             }
457             return tryRecover(hash, v, r, s);
458         } else if (signature.length == 64) {
459             bytes32 r;
460             bytes32 vs;
461             // ecrecover takes the signature parameters, and the only way to get them
462             // currently is to use assembly.
463             assembly {
464                 r := mload(add(signature, 0x20))
465                 vs := mload(add(signature, 0x40))
466             }
467             return tryRecover(hash, r, vs);
468         } else {
469             return (address(0), RecoverError.InvalidSignatureLength);
470         }
471     }
472 
473     /**
474      * @dev Returns the address that signed a hashed message (`hash`) with
475      * `signature`. This address can then be used for verification purposes.
476      *
477      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
478      * this function rejects them by requiring the `s` value to be in the lower
479      * half order, and the `v` value to be either 27 or 28.
480      *
481      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
482      * verification to be secure: it is possible to craft signatures that
483      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
484      * this is by receiving a hash of the original message (which may otherwise
485      * be too long), and then calling {toEthSignedMessageHash} on it.
486      */
487     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
488         (address recovered, RecoverError error) = tryRecover(hash, signature);
489         _throwError(error);
490         return recovered;
491     }
492 
493     /**
494      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
495      *
496      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
497      *
498      * _Available since v4.3._
499      */
500     function tryRecover(
501         bytes32 hash,
502         bytes32 r,
503         bytes32 vs
504     ) internal pure returns (address, RecoverError) {
505         bytes32 s;
506         uint8 v;
507         assembly {
508             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
509             v := add(shr(255, vs), 27)
510         }
511         return tryRecover(hash, v, r, s);
512     }
513 
514     /**
515      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
516      *
517      * _Available since v4.2._
518      */
519     function recover(
520         bytes32 hash,
521         bytes32 r,
522         bytes32 vs
523     ) internal pure returns (address) {
524         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
525         _throwError(error);
526         return recovered;
527     }
528 
529     /**
530      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
531      * `r` and `s` signature fields separately.
532      *
533      * _Available since v4.3._
534      */
535     function tryRecover(
536         bytes32 hash,
537         uint8 v,
538         bytes32 r,
539         bytes32 s
540     ) internal pure returns (address, RecoverError) {
541         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
542         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
543         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
544         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
545         //
546         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
547         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
548         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
549         // these malleable signatures as well.
550         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
551             return (address(0), RecoverError.InvalidSignatureS);
552         }
553         if (v != 27 && v != 28) {
554             return (address(0), RecoverError.InvalidSignatureV);
555         }
556 
557         // If the signature is valid (and not malleable), return the signer address
558         address signer = ecrecover(hash, v, r, s);
559         if (signer == address(0)) {
560             return (address(0), RecoverError.InvalidSignature);
561         }
562 
563         return (signer, RecoverError.NoError);
564     }
565 
566     /**
567      * @dev Overload of {ECDSA-recover} that receives the `v`,
568      * `r` and `s` signature fields separately.
569      */
570     function recover(
571         bytes32 hash,
572         uint8 v,
573         bytes32 r,
574         bytes32 s
575     ) internal pure returns (address) {
576         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
577         _throwError(error);
578         return recovered;
579     }
580 
581     /**
582      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
583      * produces hash corresponding to the one signed with the
584      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
585      * JSON-RPC method as part of EIP-191.
586      *
587      * See {recover}.
588      */
589     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
590         // 32 is the length in bytes of hash,
591         // enforced by the type signature above
592         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
593     }
594 
595     /**
596      * @dev Returns an Ethereum Signed Typed Data, created from a
597      * `domainSeparator` and a `structHash`. This produces hash corresponding
598      * to the one signed with the
599      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
600      * JSON-RPC method as part of EIP-712.
601      *
602      * See {recover}.
603      */
604     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
605         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
606     }
607 }
608 
609 
610 // File contracts/ethereum/token/BicoClaimNew.sol
611 
612 
613 pragma solidity ^0.8.0;
614 
615 //import "./BiconomyToken.sol";
616 
617 
618 
619 
620 
621 //TODO
622 //make upgradeable again
623 //clean up
624 //add pausability modifier and reentrancy guard
625 //remove constrctor and setup proper initializer
626 //check sample audit reports and review security for all contracts
627 //trasnfer limits, max claim limit etc
628 contract BicoClaimNew is AccessProtected, Pausable, ReentrancyGuard {
629     using ECDSA for bytes32;
630     struct Voucher {
631         address recipient;
632         uint256 amount;
633         bytes signature;
634     }
635 
636     uint256 public bicoHardLimit = 10000*1e18;
637 
638     bytes32 internal constant EIP712_DOMAIN_TYPEHASH = keccak256(bytes("EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"));
639     bytes32 public constant VOUCHER_TYPEHASH = keccak256(bytes("Voucher(address recipient,uint256 amount)"));
640     bytes32 internal domainSeparator;
641     address public tokenAddress;
642 
643     mapping(address => uint256) public totalTokensClaimedByUser; // total $BICO tokens claimed per address
644     
645     event BicoClaimed(address indexed _user,uint256 _claimedBico);
646     
647     constructor(address _tokenAddress, string memory name, string memory version) {
648         require(_tokenAddress != address(0),"Token address can not be zero");
649         tokenAddress = _tokenAddress;
650         domainSeparator = keccak256(abi.encode(
651             EIP712_DOMAIN_TYPEHASH,
652             keccak256(bytes(name)),
653             keccak256(bytes(version)),
654             address(this),
655             bytes32(getChainID())
656         ));
657     }
658 
659     // returns total number of bico tokens claimed so far from user
660     function getTokensClaimedByUser(address user) public view returns (uint256) {
661         return totalTokensClaimedByUser[user];
662     }
663 
664     /**
665      * claim voucher bico tokens
666      *
667      * returns number of bico claimed
668      */
669     function claimVoucher(Voucher calldata _voucher) external whenNotPaused nonReentrant returns (uint256) {
670         address recipient = _msgSender();
671 
672         address signer = _verify(_voucher);
673         uint256 claimedAmount = totalTokensClaimedByUser[recipient]; // total claimed bico
674 
675         require(recipient == _voucher.recipient, "TokenClaim: msg.sender does not match recipient");
676         require(_voucher.amount > claimedAmount, "TokenClaim: No $BICO left to claim");
677 
678         require(signer != address(0), "TokenClaim: Unable to recover signer from signature");
679         require(isAdmin(signer) || signer == owner(), "TokenClaim: Invalid Voucher, not signed by admin or owner");
680         require(recipient == _voucher.recipient, "TokenClaim: This Voucher does not belong to msg.sender");
681         
682         uint256 claimable = (_voucher.amount - claimedAmount)*1e18;
683         require(claimable < bicoHardLimit,"voucher claim amount exceeds the hard-cap");
684 
685         // set bico to latest amount on voucher
686         totalTokensClaimedByUser[recipient] = _voucher.amount;
687 
688         // transfer tokens to user
689         IERC20(tokenAddress).transfer(recipient, claimable);
690         emit BicoClaimed(recipient,claimable);
691         return claimable;
692     }
693 
694     function _verify(Voucher memory voucher) internal view returns (address) {
695         bytes32 digest =
696             keccak256(abi.encodePacked(
697                 "\x19\x01",
698                 getDomainSeparator(),
699                 keccak256(abi.encode(VOUCHER_TYPEHASH,
700                             voucher.recipient,
701                             voucher.amount
702                         ))));
703         return digest.recover(voucher.signature);
704     }
705 
706     /**
707      * Withdraw ERC20 Tokens from the Token Claim contract address
708      *
709      */
710     function withdrawTokens(address wallet, uint256 amount) external onlyOwner nonReentrant {
711         require(amount > 0, "Nothing to withdraw");
712         IERC20(tokenAddress).transfer(wallet, amount);
713     }
714     
715     function getDomainSeparator() internal view returns(bytes32) {
716         return domainSeparator;
717     }
718 
719     /** set proxy registry address
720      */
721     function setHardCap(uint256 _hardLimit) external onlyOwner {
722         require(_hardLimit > 0,"Must be greater than zero");
723         bicoHardLimit = _hardLimit;
724     }
725 
726 
727     function getChainID() public view returns (uint256 id) {
728         assembly {
729             id := chainid()
730         }
731     }
732 
733     function pause() external onlyAdmin {
734         _pause();
735     }
736 
737     function unpause() external onlyAdmin {
738         _unpause();
739     }
740 }