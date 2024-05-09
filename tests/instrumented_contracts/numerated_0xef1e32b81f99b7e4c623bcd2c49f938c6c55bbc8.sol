1 // Sources flattened with hardhat v2.8.3 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.4.2
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev These functions deal with verification of Merkle Trees proofs.
12  *
13  * The proofs can be generated using the JavaScript library
14  * https://github.com/miguelmota/merkletreejs[merkletreejs].
15  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
16  *
17  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
18  */
19 library MerkleProof {
20   /**
21    * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
22    * defined by `root`. For this, a `proof` must be provided, containing
23    * sibling hashes on the branch from the leaf to the root of the tree. Each
24    * pair of leaves and each pair of pre-images are assumed to be sorted.
25    */
26   function verify(
27     bytes32[] memory proof,
28     bytes32 root,
29     bytes32 leaf
30   ) internal pure returns (bool) {
31     return processProof(proof, leaf) == root;
32   }
33 
34   /**
35    * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
36    * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
37    * hash matches the root of the tree. When processing the proof, the pairs
38    * of leafs & pre-images are assumed to be sorted.
39    *
40    * _Available since v4.4._
41    */
42   function processProof(bytes32[] memory proof, bytes32 leaf)
43     internal
44     pure
45     returns (bytes32)
46   {
47     bytes32 computedHash = leaf;
48     for (uint256 i = 0; i < proof.length; i++) {
49       bytes32 proofElement = proof[i];
50       if (computedHash <= proofElement) {
51         // Hash(current computed hash + current element of the proof)
52         computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
53       } else {
54         // Hash(current element of the proof + current computed hash)
55         computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
56       }
57     }
58     return computedHash;
59   }
60 }
61 
62 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
63 
64 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
65 
66 pragma solidity ^0.8.0;
67 
68 /**
69  * @dev Provides information about the current execution context, including the
70  * sender of the transaction and its data. While these are generally available
71  * via msg.sender and msg.data, they should not be accessed in such a direct
72  * manner, since when dealing with meta-transactions the account sending and
73  * paying for execution may not be the actual sender (as far as an application
74  * is concerned).
75  *
76  * This contract is only required for intermediate, library-like contracts.
77  */
78 abstract contract Context {
79   function _msgSender() internal view virtual returns (address) {
80     return msg.sender;
81   }
82 
83   function _msgData() internal view virtual returns (bytes calldata) {
84     return msg.data;
85   }
86 }
87 
88 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
89 
90 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 /**
95  * @dev Contract module which provides a basic access control mechanism, where
96  * there is an account (an owner) that can be granted exclusive access to
97  * specific functions.
98  *
99  * By default, the owner account will be the one that deploys the contract. This
100  * can later be changed with {transferOwnership}.
101  *
102  * This module is used through inheritance. It will make available the modifier
103  * `onlyOwner`, which can be applied to your functions to restrict their use to
104  * the owner.
105  */
106 abstract contract Ownable is Context {
107   address private _owner;
108 
109   event OwnershipTransferred(
110     address indexed previousOwner,
111     address indexed newOwner
112   );
113 
114   /**
115    * @dev Initializes the contract setting the deployer as the initial owner.
116    */
117   constructor() {
118     _transferOwnership(_msgSender());
119   }
120 
121   /**
122    * @dev Returns the address of the current owner.
123    */
124   function owner() public view virtual returns (address) {
125     return _owner;
126   }
127 
128   /**
129    * @dev Throws if called by any account other than the owner.
130    */
131   modifier onlyOwner() {
132     require(owner() == _msgSender(), "Ownable: caller is not the owner");
133     _;
134   }
135 
136   /**
137    * @dev Leaves the contract without owner. It will not be possible to call
138    * `onlyOwner` functions anymore. Can only be called by the current owner.
139    *
140    * NOTE: Renouncing ownership will leave the contract without an owner,
141    * thereby removing any functionality that is only available to the owner.
142    */
143   function renounceOwnership() public virtual onlyOwner {
144     _transferOwnership(address(0));
145   }
146 
147   /**
148    * @dev Transfers ownership of the contract to a new account (`newOwner`).
149    * Can only be called by the current owner.
150    */
151   function transferOwnership(address newOwner) public virtual onlyOwner {
152     require(newOwner != address(0), "Ownable: new owner is the zero address");
153     _transferOwnership(newOwner);
154   }
155 
156   /**
157    * @dev Transfers ownership of the contract to a new account (`newOwner`).
158    * Internal function without access restriction.
159    */
160   function _transferOwnership(address newOwner) internal virtual {
161     address oldOwner = _owner;
162     _owner = newOwner;
163     emit OwnershipTransferred(oldOwner, newOwner);
164   }
165 }
166 
167 // File @chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol@v0.3.1
168 
169 pragma solidity ^0.8.0;
170 
171 interface LinkTokenInterface {
172   function allowance(address owner, address spender)
173     external
174     view
175     returns (uint256 remaining);
176 
177   function approve(address spender, uint256 value)
178     external
179     returns (bool success);
180 
181   function balanceOf(address owner) external view returns (uint256 balance);
182 
183   function decimals() external view returns (uint8 decimalPlaces);
184 
185   function decreaseApproval(address spender, uint256 addedValue)
186     external
187     returns (bool success);
188 
189   function increaseApproval(address spender, uint256 subtractedValue) external;
190 
191   function name() external view returns (string memory tokenName);
192 
193   function symbol() external view returns (string memory tokenSymbol);
194 
195   function totalSupply() external view returns (uint256 totalTokensIssued);
196 
197   function transfer(address to, uint256 value) external returns (bool success);
198 
199   function transferAndCall(
200     address to,
201     uint256 value,
202     bytes calldata data
203   ) external returns (bool success);
204 
205   function transferFrom(
206     address from,
207     address to,
208     uint256 value
209   ) external returns (bool success);
210 }
211 
212 // File @chainlink/contracts/src/v0.8/VRFRequestIDBase.sol@v0.3.1
213 
214 pragma solidity ^0.8.0;
215 
216 contract VRFRequestIDBase {
217   /**
218    * @notice returns the seed which is actually input to the VRF coordinator
219    *
220    * @dev To prevent repetition of VRF output due to repetition of the
221    * @dev user-supplied seed, that seed is combined in a hash with the
222    * @dev user-specific nonce, and the address of the consuming contract. The
223    * @dev risk of repetition is mostly mitigated by inclusion of a blockhash in
224    * @dev the final seed, but the nonce does protect against repetition in
225    * @dev requests which are included in a single block.
226    *
227    * @param _userSeed VRF seed input provided by user
228    * @param _requester Address of the requesting contract
229    * @param _nonce User-specific nonce at the time of the request
230    */
231   function makeVRFInputSeed(
232     bytes32 _keyHash,
233     uint256 _userSeed,
234     address _requester,
235     uint256 _nonce
236   ) internal pure returns (uint256) {
237     return
238       uint256(keccak256(abi.encode(_keyHash, _userSeed, _requester, _nonce)));
239   }
240 
241   /**
242    * @notice Returns the id for this request
243    * @param _keyHash The serviceAgreement ID to be used for this request
244    * @param _vRFInputSeed The seed to be passed directly to the VRF
245    * @return The id for this request
246    *
247    * @dev Note that _vRFInputSeed is not the seed passed by the consuming
248    * @dev contract, but the one generated by makeVRFInputSeed
249    */
250   function makeRequestId(bytes32 _keyHash, uint256 _vRFInputSeed)
251     internal
252     pure
253     returns (bytes32)
254   {
255     return keccak256(abi.encodePacked(_keyHash, _vRFInputSeed));
256   }
257 }
258 
259 // File @chainlink/contracts/src/v0.8/VRFConsumerBase.sol@v0.3.1
260 
261 pragma solidity ^0.8.0;
262 
263 /** ****************************************************************************
264  * @notice Interface for contracts using VRF randomness
265  * *****************************************************************************
266  * @dev PURPOSE
267  *
268  * @dev Reggie the Random Oracle (not his real job) wants to provide randomness
269  * @dev to Vera the verifier in such a way that Vera can be sure he's not
270  * @dev making his output up to suit himself. Reggie provides Vera a public key
271  * @dev to which he knows the secret key. Each time Vera provides a seed to
272  * @dev Reggie, he gives back a value which is computed completely
273  * @dev deterministically from the seed and the secret key.
274  *
275  * @dev Reggie provides a proof by which Vera can verify that the output was
276  * @dev correctly computed once Reggie tells it to her, but without that proof,
277  * @dev the output is indistinguishable to her from a uniform random sample
278  * @dev from the output space.
279  *
280  * @dev The purpose of this contract is to make it easy for unrelated contracts
281  * @dev to talk to Vera the verifier about the work Reggie is doing, to provide
282  * @dev simple access to a verifiable source of randomness.
283  * *****************************************************************************
284  * @dev USAGE
285  *
286  * @dev Calling contracts must inherit from VRFConsumerBase, and can
287  * @dev initialize VRFConsumerBase's attributes in their constructor as
288  * @dev shown:
289  *
290  * @dev   contract VRFConsumer {
291  * @dev     constuctor(<other arguments>, address _vrfCoordinator, address _link)
292  * @dev       VRFConsumerBase(_vrfCoordinator, _link) public {
293  * @dev         <initialization with other arguments goes here>
294  * @dev       }
295  * @dev   }
296  *
297  * @dev The oracle will have given you an ID for the VRF keypair they have
298  * @dev committed to (let's call it keyHash), and have told you the minimum LINK
299  * @dev price for VRF service. Make sure your contract has sufficient LINK, and
300  * @dev call requestRandomness(keyHash, fee, seed), where seed is the input you
301  * @dev want to generate randomness from.
302  *
303  * @dev Once the VRFCoordinator has received and validated the oracle's response
304  * @dev to your request, it will call your contract's fulfillRandomness method.
305  *
306  * @dev The randomness argument to fulfillRandomness is the actual random value
307  * @dev generated from your seed.
308  *
309  * @dev The requestId argument is generated from the keyHash and the seed by
310  * @dev makeRequestId(keyHash, seed). If your contract could have concurrent
311  * @dev requests open, you can use the requestId to track which seed is
312  * @dev associated with which randomness. See VRFRequestIDBase.sol for more
313  * @dev details. (See "SECURITY CONSIDERATIONS" for principles to keep in mind,
314  * @dev if your contract could have multiple requests in flight simultaneously.)
315  *
316  * @dev Colliding `requestId`s are cryptographically impossible as long as seeds
317  * @dev differ. (Which is critical to making unpredictable randomness! See the
318  * @dev next section.)
319  *
320  * *****************************************************************************
321  * @dev SECURITY CONSIDERATIONS
322  *
323  * @dev A method with the ability to call your fulfillRandomness method directly
324  * @dev could spoof a VRF response with any random value, so it's critical that
325  * @dev it cannot be directly called by anything other than this base contract
326  * @dev (specifically, by the VRFConsumerBase.rawFulfillRandomness method).
327  *
328  * @dev For your users to trust that your contract's random behavior is free
329  * @dev from malicious interference, it's best if you can write it so that all
330  * @dev behaviors implied by a VRF response are executed *during* your
331  * @dev fulfillRandomness method. If your contract must store the response (or
332  * @dev anything derived from it) and use it later, you must ensure that any
333  * @dev user-significant behavior which depends on that stored value cannot be
334  * @dev manipulated by a subsequent VRF request.
335  *
336  * @dev Similarly, both miners and the VRF oracle itself have some influence
337  * @dev over the order in which VRF responses appear on the blockchain, so if
338  * @dev your contract could have multiple VRF requests in flight simultaneously,
339  * @dev you must ensure that the order in which the VRF responses arrive cannot
340  * @dev be used to manipulate your contract's user-significant behavior.
341  *
342  * @dev Since the ultimate input to the VRF is mixed with the block hash of the
343  * @dev block in which the request is made, user-provided seeds have no impact
344  * @dev on its economic security properties. They are only included for API
345  * @dev compatability with previous versions of this contract.
346  *
347  * @dev Since the block hash of the block which contains the requestRandomness
348  * @dev call is mixed into the input to the VRF *last*, a sufficiently powerful
349  * @dev miner could, in principle, fork the blockchain to evict the block
350  * @dev containing the request, forcing the request to be included in a
351  * @dev different block with a different hash, and therefore a different input
352  * @dev to the VRF. However, such an attack would incur a substantial economic
353  * @dev cost. This cost scales with the number of blocks the VRF oracle waits
354  * @dev until it calls responds to a request.
355  */
356 abstract contract VRFConsumerBase is VRFRequestIDBase {
357   /**
358    * @notice fulfillRandomness handles the VRF response. Your contract must
359    * @notice implement it. See "SECURITY CONSIDERATIONS" above for important
360    * @notice principles to keep in mind when implementing your fulfillRandomness
361    * @notice method.
362    *
363    * @dev VRFConsumerBase expects its subcontracts to have a method with this
364    * @dev signature, and will call it once it has verified the proof
365    * @dev associated with the randomness. (It is triggered via a call to
366    * @dev rawFulfillRandomness, below.)
367    *
368    * @param requestId The Id initially returned by requestRandomness
369    * @param randomness the VRF output
370    */
371   function fulfillRandomness(bytes32 requestId, uint256 randomness)
372     internal
373     virtual;
374 
375   /**
376    * @dev In order to keep backwards compatibility we have kept the user
377    * seed field around. We remove the use of it because given that the blockhash
378    * enters later, it overrides whatever randomness the used seed provides.
379    * Given that it adds no security, and can easily lead to misunderstandings,
380    * we have removed it from usage and can now provide a simpler API.
381    */
382   uint256 private constant USER_SEED_PLACEHOLDER = 0;
383 
384   /**
385    * @notice requestRandomness initiates a request for VRF output given _seed
386    *
387    * @dev The fulfillRandomness method receives the output, once it's provided
388    * @dev by the Oracle, and verified by the vrfCoordinator.
389    *
390    * @dev The _keyHash must already be registered with the VRFCoordinator, and
391    * @dev the _fee must exceed the fee specified during registration of the
392    * @dev _keyHash.
393    *
394    * @dev The _seed parameter is vestigial, and is kept only for API
395    * @dev compatibility with older versions. It can't *hurt* to mix in some of
396    * @dev your own randomness, here, but it's not necessary because the VRF
397    * @dev oracle will mix the hash of the block containing your request into the
398    * @dev VRF seed it ultimately uses.
399    *
400    * @param _keyHash ID of public key against which randomness is generated
401    * @param _fee The amount of LINK to send with the request
402    *
403    * @return requestId unique ID for this request
404    *
405    * @dev The returned requestId can be used to distinguish responses to
406    * @dev concurrent requests. It is passed as the first argument to
407    * @dev fulfillRandomness.
408    */
409   function requestRandomness(bytes32 _keyHash, uint256 _fee)
410     internal
411     returns (bytes32 requestId)
412   {
413     LINK.transferAndCall(
414       vrfCoordinator,
415       _fee,
416       abi.encode(_keyHash, USER_SEED_PLACEHOLDER)
417     );
418     // This is the seed passed to VRFCoordinator. The oracle will mix this with
419     // the hash of the block containing this request to obtain the seed/input
420     // which is finally passed to the VRF cryptographic machinery.
421     uint256 vRFSeed = makeVRFInputSeed(
422       _keyHash,
423       USER_SEED_PLACEHOLDER,
424       address(this),
425       nonces[_keyHash]
426     );
427     // nonces[_keyHash] must stay in sync with
428     // VRFCoordinator.nonces[_keyHash][this], which was incremented by the above
429     // successful LINK.transferAndCall (in VRFCoordinator.randomnessRequest).
430     // This provides protection against the user repeating their input seed,
431     // which would result in a predictable/duplicate output, if multiple such
432     // requests appeared in the same block.
433     nonces[_keyHash] = nonces[_keyHash] + 1;
434     return makeRequestId(_keyHash, vRFSeed);
435   }
436 
437   LinkTokenInterface internal immutable LINK;
438   address private immutable vrfCoordinator;
439 
440   // Nonces for each VRF key from which randomness has been requested.
441   //
442   // Must stay in sync with VRFCoordinator[_keyHash][this]
443   mapping(bytes32 => uint256) /* keyHash */ /* nonce */
444     private nonces;
445 
446   /**
447    * @param _vrfCoordinator address of VRFCoordinator contract
448    * @param _link address of LINK token contract
449    *
450    * @dev https://docs.chain.link/docs/link-token-contracts
451    */
452   constructor(address _vrfCoordinator, address _link) {
453     vrfCoordinator = _vrfCoordinator;
454     LINK = LinkTokenInterface(_link);
455   }
456 
457   // rawFulfillRandomness is called by VRFCoordinator when it receives a valid VRF
458   // proof. rawFulfillRandomness then calls fulfillRandomness, after validating
459   // the origin of the call
460   function rawFulfillRandomness(bytes32 requestId, uint256 randomness)
461     external
462   {
463     require(msg.sender == vrfCoordinator, "Only VRFCoordinator can fulfill");
464     fulfillRandomness(requestId, randomness);
465   }
466 }
467 
468 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
469 
470 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
471 
472 pragma solidity ^0.8.0;
473 
474 /**
475  * @dev Interface of the ERC165 standard, as defined in the
476  * https://eips.ethereum.org/EIPS/eip-165[EIP].
477  *
478  * Implementers can declare support of contract interfaces, which can then be
479  * queried by others ({ERC165Checker}).
480  *
481  * For an implementation, see {ERC165}.
482  */
483 interface IERC165 {
484   /**
485    * @dev Returns true if this contract implements the interface defined by
486    * `interfaceId`. See the corresponding
487    * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
488    * to learn more about how these ids are created.
489    *
490    * This function call must use less than 30 000 gas.
491    */
492   function supportsInterface(bytes4 interfaceId) external view returns (bool);
493 }
494 
495 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
496 
497 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
498 
499 pragma solidity ^0.8.0;
500 
501 /**
502  * @dev Required interface of an ERC721 compliant contract.
503  */
504 interface IERC721 is IERC165 {
505   /**
506    * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
507    */
508   event Transfer(
509     address indexed from,
510     address indexed to,
511     uint256 indexed tokenId
512   );
513 
514   /**
515    * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
516    */
517   event Approval(
518     address indexed owner,
519     address indexed approved,
520     uint256 indexed tokenId
521   );
522 
523   /**
524    * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
525    */
526   event ApprovalForAll(
527     address indexed owner,
528     address indexed operator,
529     bool approved
530   );
531 
532   /**
533    * @dev Returns the number of tokens in ``owner``'s account.
534    */
535   function balanceOf(address owner) external view returns (uint256 balance);
536 
537   /**
538    * @dev Returns the owner of the `tokenId` token.
539    *
540    * Requirements:
541    *
542    * - `tokenId` must exist.
543    */
544   function ownerOf(uint256 tokenId) external view returns (address owner);
545 
546   /**
547    * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
548    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
549    *
550    * Requirements:
551    *
552    * - `from` cannot be the zero address.
553    * - `to` cannot be the zero address.
554    * - `tokenId` token must exist and be owned by `from`.
555    * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
556    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
557    *
558    * Emits a {Transfer} event.
559    */
560   function safeTransferFrom(
561     address from,
562     address to,
563     uint256 tokenId
564   ) external;
565 
566   /**
567    * @dev Transfers `tokenId` token from `from` to `to`.
568    *
569    * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
570    *
571    * Requirements:
572    *
573    * - `from` cannot be the zero address.
574    * - `to` cannot be the zero address.
575    * - `tokenId` token must be owned by `from`.
576    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
577    *
578    * Emits a {Transfer} event.
579    */
580   function transferFrom(
581     address from,
582     address to,
583     uint256 tokenId
584   ) external;
585 
586   /**
587    * @dev Gives permission to `to` to transfer `tokenId` token to another account.
588    * The approval is cleared when the token is transferred.
589    *
590    * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
591    *
592    * Requirements:
593    *
594    * - The caller must own the token or be an approved operator.
595    * - `tokenId` must exist.
596    *
597    * Emits an {Approval} event.
598    */
599   function approve(address to, uint256 tokenId) external;
600 
601   /**
602    * @dev Returns the account approved for `tokenId` token.
603    *
604    * Requirements:
605    *
606    * - `tokenId` must exist.
607    */
608   function getApproved(uint256 tokenId)
609     external
610     view
611     returns (address operator);
612 
613   /**
614    * @dev Approve or remove `operator` as an operator for the caller.
615    * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
616    *
617    * Requirements:
618    *
619    * - The `operator` cannot be the caller.
620    *
621    * Emits an {ApprovalForAll} event.
622    */
623   function setApprovalForAll(address operator, bool _approved) external;
624 
625   /**
626    * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
627    *
628    * See {setApprovalForAll}
629    */
630   function isApprovedForAll(address owner, address operator)
631     external
632     view
633     returns (bool);
634 
635   /**
636    * @dev Safely transfers `tokenId` token from `from` to `to`.
637    *
638    * Requirements:
639    *
640    * - `from` cannot be the zero address.
641    * - `to` cannot be the zero address.
642    * - `tokenId` token must exist and be owned by `from`.
643    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
644    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
645    *
646    * Emits a {Transfer} event.
647    */
648   function safeTransferFrom(
649     address from,
650     address to,
651     uint256 tokenId,
652     bytes calldata data
653   ) external;
654 }
655 
656 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
657 
658 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
659 
660 pragma solidity ^0.8.0;
661 
662 /**
663  * @title ERC721 token receiver interface
664  * @dev Interface for any contract that wants to support safeTransfers
665  * from ERC721 asset contracts.
666  */
667 interface IERC721Receiver {
668   /**
669    * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
670    * by `operator` from `from`, this function is called.
671    *
672    * It must return its Solidity selector to confirm the token transfer.
673    * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
674    *
675    * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
676    */
677   function onERC721Received(
678     address operator,
679     address from,
680     uint256 tokenId,
681     bytes calldata data
682   ) external returns (bytes4);
683 }
684 
685 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
686 
687 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
688 
689 pragma solidity ^0.8.0;
690 
691 /**
692  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
693  * @dev See https://eips.ethereum.org/EIPS/eip-721
694  */
695 interface IERC721Metadata is IERC721 {
696   /**
697    * @dev Returns the token collection name.
698    */
699   function name() external view returns (string memory);
700 
701   /**
702    * @dev Returns the token collection symbol.
703    */
704   function symbol() external view returns (string memory);
705 
706   /**
707    * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
708    */
709   function tokenURI(uint256 tokenId) external view returns (string memory);
710 }
711 
712 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.2
713 
714 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
715 
716 pragma solidity ^0.8.0;
717 
718 /**
719  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
720  * @dev See https://eips.ethereum.org/EIPS/eip-721
721  */
722 interface IERC721Enumerable is IERC721 {
723   /**
724    * @dev Returns the total amount of tokens stored by the contract.
725    */
726   function totalSupply() external view returns (uint256);
727 
728   /**
729    * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
730    * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
731    */
732   function tokenOfOwnerByIndex(address owner, uint256 index)
733     external
734     view
735     returns (uint256 tokenId);
736 
737   /**
738    * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
739    * Use along with {totalSupply} to enumerate all tokens.
740    */
741   function tokenByIndex(uint256 index) external view returns (uint256);
742 }
743 
744 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
745 
746 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
747 
748 pragma solidity ^0.8.0;
749 
750 /**
751  * @dev Collection of functions related to the address type
752  */
753 library Address {
754   /**
755    * @dev Returns true if `account` is a contract.
756    *
757    * [IMPORTANT]
758    * ====
759    * It is unsafe to assume that an address for which this function returns
760    * false is an externally-owned account (EOA) and not a contract.
761    *
762    * Among others, `isContract` will return false for the following
763    * types of addresses:
764    *
765    *  - an externally-owned account
766    *  - a contract in construction
767    *  - an address where a contract will be created
768    *  - an address where a contract lived, but was destroyed
769    * ====
770    */
771   function isContract(address account) internal view returns (bool) {
772     // This method relies on extcodesize, which returns 0 for contracts in
773     // construction, since the code is only stored at the end of the
774     // constructor execution.
775 
776     uint256 size;
777     assembly {
778       size := extcodesize(account)
779     }
780     return size > 0;
781   }
782 
783   /**
784    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
785    * `recipient`, forwarding all available gas and reverting on errors.
786    *
787    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
788    * of certain opcodes, possibly making contracts go over the 2300 gas limit
789    * imposed by `transfer`, making them unable to receive funds via
790    * `transfer`. {sendValue} removes this limitation.
791    *
792    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
793    *
794    * IMPORTANT: because control is transferred to `recipient`, care must be
795    * taken to not create reentrancy vulnerabilities. Consider using
796    * {ReentrancyGuard} or the
797    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
798    */
799   function sendValue(address payable recipient, uint256 amount) internal {
800     require(address(this).balance >= amount, "Address: insufficient balance");
801 
802     (bool success, ) = recipient.call{ value: amount }("");
803     require(
804       success,
805       "Address: unable to send value, recipient may have reverted"
806     );
807   }
808 
809   /**
810    * @dev Performs a Solidity function call using a low level `call`. A
811    * plain `call` is an unsafe replacement for a function call: use this
812    * function instead.
813    *
814    * If `target` reverts with a revert reason, it is bubbled up by this
815    * function (like regular Solidity function calls).
816    *
817    * Returns the raw returned data. To convert to the expected return value,
818    * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
819    *
820    * Requirements:
821    *
822    * - `target` must be a contract.
823    * - calling `target` with `data` must not revert.
824    *
825    * _Available since v3.1._
826    */
827   function functionCall(address target, bytes memory data)
828     internal
829     returns (bytes memory)
830   {
831     return functionCall(target, data, "Address: low-level call failed");
832   }
833 
834   /**
835    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
836    * `errorMessage` as a fallback revert reason when `target` reverts.
837    *
838    * _Available since v3.1._
839    */
840   function functionCall(
841     address target,
842     bytes memory data,
843     string memory errorMessage
844   ) internal returns (bytes memory) {
845     return functionCallWithValue(target, data, 0, errorMessage);
846   }
847 
848   /**
849    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
850    * but also transferring `value` wei to `target`.
851    *
852    * Requirements:
853    *
854    * - the calling contract must have an ETH balance of at least `value`.
855    * - the called Solidity function must be `payable`.
856    *
857    * _Available since v3.1._
858    */
859   function functionCallWithValue(
860     address target,
861     bytes memory data,
862     uint256 value
863   ) internal returns (bytes memory) {
864     return
865       functionCallWithValue(
866         target,
867         data,
868         value,
869         "Address: low-level call with value failed"
870       );
871   }
872 
873   /**
874    * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
875    * with `errorMessage` as a fallback revert reason when `target` reverts.
876    *
877    * _Available since v3.1._
878    */
879   function functionCallWithValue(
880     address target,
881     bytes memory data,
882     uint256 value,
883     string memory errorMessage
884   ) internal returns (bytes memory) {
885     require(
886       address(this).balance >= value,
887       "Address: insufficient balance for call"
888     );
889     require(isContract(target), "Address: call to non-contract");
890 
891     (bool success, bytes memory returndata) = target.call{ value: value }(data);
892     return verifyCallResult(success, returndata, errorMessage);
893   }
894 
895   /**
896    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
897    * but performing a static call.
898    *
899    * _Available since v3.3._
900    */
901   function functionStaticCall(address target, bytes memory data)
902     internal
903     view
904     returns (bytes memory)
905   {
906     return
907       functionStaticCall(target, data, "Address: low-level static call failed");
908   }
909 
910   /**
911    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
912    * but performing a static call.
913    *
914    * _Available since v3.3._
915    */
916   function functionStaticCall(
917     address target,
918     bytes memory data,
919     string memory errorMessage
920   ) internal view returns (bytes memory) {
921     require(isContract(target), "Address: static call to non-contract");
922 
923     (bool success, bytes memory returndata) = target.staticcall(data);
924     return verifyCallResult(success, returndata, errorMessage);
925   }
926 
927   /**
928    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
929    * but performing a delegate call.
930    *
931    * _Available since v3.4._
932    */
933   function functionDelegateCall(address target, bytes memory data)
934     internal
935     returns (bytes memory)
936   {
937     return
938       functionDelegateCall(
939         target,
940         data,
941         "Address: low-level delegate call failed"
942       );
943   }
944 
945   /**
946    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
947    * but performing a delegate call.
948    *
949    * _Available since v3.4._
950    */
951   function functionDelegateCall(
952     address target,
953     bytes memory data,
954     string memory errorMessage
955   ) internal returns (bytes memory) {
956     require(isContract(target), "Address: delegate call to non-contract");
957 
958     (bool success, bytes memory returndata) = target.delegatecall(data);
959     return verifyCallResult(success, returndata, errorMessage);
960   }
961 
962   /**
963    * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
964    * revert reason using the provided one.
965    *
966    * _Available since v4.3._
967    */
968   function verifyCallResult(
969     bool success,
970     bytes memory returndata,
971     string memory errorMessage
972   ) internal pure returns (bytes memory) {
973     if (success) {
974       return returndata;
975     } else {
976       // Look for revert reason and bubble it up if present
977       if (returndata.length > 0) {
978         // The easiest way to bubble the revert reason is using memory via assembly
979 
980         assembly {
981           let returndata_size := mload(returndata)
982           revert(add(32, returndata), returndata_size)
983         }
984       } else {
985         revert(errorMessage);
986       }
987     }
988   }
989 }
990 
991 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
992 
993 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
994 
995 pragma solidity ^0.8.0;
996 
997 /**
998  * @dev String operations.
999  */
1000 library Strings {
1001   bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1002 
1003   /**
1004    * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1005    */
1006   function toString(uint256 value) internal pure returns (string memory) {
1007     // Inspired by OraclizeAPI's implementation - MIT licence
1008     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1009 
1010     if (value == 0) {
1011       return "0";
1012     }
1013     uint256 temp = value;
1014     uint256 digits;
1015     while (temp != 0) {
1016       digits++;
1017       temp /= 10;
1018     }
1019     bytes memory buffer = new bytes(digits);
1020     while (value != 0) {
1021       digits -= 1;
1022       buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1023       value /= 10;
1024     }
1025     return string(buffer);
1026   }
1027 
1028   /**
1029    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1030    */
1031   function toHexString(uint256 value) internal pure returns (string memory) {
1032     if (value == 0) {
1033       return "0x00";
1034     }
1035     uint256 temp = value;
1036     uint256 length = 0;
1037     while (temp != 0) {
1038       length++;
1039       temp >>= 8;
1040     }
1041     return toHexString(value, length);
1042   }
1043 
1044   /**
1045    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1046    */
1047   function toHexString(uint256 value, uint256 length)
1048     internal
1049     pure
1050     returns (string memory)
1051   {
1052     bytes memory buffer = new bytes(2 * length + 2);
1053     buffer[0] = "0";
1054     buffer[1] = "x";
1055     for (uint256 i = 2 * length + 1; i > 1; --i) {
1056       buffer[i] = _HEX_SYMBOLS[value & 0xf];
1057       value >>= 4;
1058     }
1059     require(value == 0, "Strings: hex length insufficient");
1060     return string(buffer);
1061   }
1062 }
1063 
1064 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
1065 
1066 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1067 
1068 pragma solidity ^0.8.0;
1069 
1070 /**
1071  * @dev Implementation of the {IERC165} interface.
1072  *
1073  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1074  * for the additional interface id that will be supported. For example:
1075  *
1076  * ```solidity
1077  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1078  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1079  * }
1080  * ```
1081  *
1082  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1083  */
1084 abstract contract ERC165 is IERC165 {
1085   /**
1086    * @dev See {IERC165-supportsInterface}.
1087    */
1088   function supportsInterface(bytes4 interfaceId)
1089     public
1090     view
1091     virtual
1092     override
1093     returns (bool)
1094   {
1095     return interfaceId == type(IERC165).interfaceId;
1096   }
1097 }
1098 
1099 // File contracts/token/ERC721/ERC721.sol
1100 
1101 // Creators: locationtba.eth, 2pmflow.eth
1102 
1103 pragma solidity ^0.8.0;
1104 
1105 /**
1106  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1107  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1108  *
1109  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1110  *
1111  * Does not support burning tokens to address(0).
1112  */
1113 abstract contract ERC721 is
1114   Context,
1115   ERC165,
1116   IERC721,
1117   IERC721Metadata,
1118   IERC721Enumerable
1119 {
1120   using Address for address;
1121   using Strings for uint256;
1122 
1123   struct TokenOwnership {
1124     address addr;
1125     uint64 startTimestamp;
1126   }
1127 
1128   struct AddressData {
1129     uint128 balance;
1130     uint128 numberMinted;
1131   }
1132 
1133   uint256 private currentIndex = 0;
1134 
1135   uint256 internal immutable maxBatchSize;
1136 
1137   // Token name
1138   string private _name;
1139 
1140   // Token symbol
1141   string private _symbol;
1142 
1143   // Mapping from token ID to ownership details
1144   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1145   mapping(uint256 => TokenOwnership) private _ownerships;
1146 
1147   // Mapping owner address to address data
1148   mapping(address => AddressData) private _addressData;
1149 
1150   // Mapping from token ID to approved address
1151   mapping(uint256 => address) private _tokenApprovals;
1152 
1153   // Mapping from owner to operator approvals
1154   mapping(address => mapping(address => bool)) private _operatorApprovals;
1155 
1156   /**
1157    * @dev
1158    * `maxBatchSize` refers to how much a minter can mint at a time.
1159    */
1160   constructor(
1161     string memory name_,
1162     string memory symbol_,
1163     uint256 maxBatchSize_
1164   ) {
1165     require(maxBatchSize_ > 0, "ERC721: max batch size must be nonzero");
1166     _name = name_;
1167     _symbol = symbol_;
1168     maxBatchSize = maxBatchSize_;
1169   }
1170 
1171   /**
1172    * @dev See {IERC721Enumerable-totalSupply}.
1173    */
1174   function totalSupply() public view override returns (uint256) {
1175     return currentIndex;
1176   }
1177 
1178   /**
1179    * @dev See {IERC721Enumerable-tokenByIndex}.
1180    */
1181   function tokenByIndex(uint256 index) public view override returns (uint256) {
1182     require(index < totalSupply(), "ERC721: global index out of bounds");
1183     return index;
1184   }
1185 
1186   /**
1187    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1188    * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1189    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1190    */
1191   function tokenOfOwnerByIndex(address owner, uint256 index)
1192     public
1193     view
1194     override
1195     returns (uint256)
1196   {
1197     require(index < balanceOf(owner), "ERC721: owner index out of bounds");
1198     uint256 numMintedSoFar = totalSupply();
1199     uint256 tokenIdsIdx = 0;
1200     address currOwnershipAddr = address(0);
1201     for (uint256 i = 0; i < numMintedSoFar; i++) {
1202       TokenOwnership memory ownership = _ownerships[i];
1203       if (ownership.addr != address(0)) {
1204         currOwnershipAddr = ownership.addr;
1205       }
1206       if (currOwnershipAddr == owner) {
1207         if (tokenIdsIdx == index) {
1208           return i;
1209         }
1210         tokenIdsIdx++;
1211       }
1212     }
1213     revert("ERC721: unable to get token of owner by index");
1214   }
1215 
1216   /**
1217    * @dev See {IERC165-supportsInterface}.
1218    */
1219   function supportsInterface(bytes4 interfaceId)
1220     public
1221     view
1222     virtual
1223     override(ERC165, IERC165)
1224     returns (bool)
1225   {
1226     return
1227       interfaceId == type(IERC721).interfaceId ||
1228       interfaceId == type(IERC721Metadata).interfaceId ||
1229       interfaceId == type(IERC721Enumerable).interfaceId ||
1230       super.supportsInterface(interfaceId);
1231   }
1232 
1233   /**
1234    * @dev See {IERC721-balanceOf}.
1235    */
1236   function balanceOf(address owner) public view override returns (uint256) {
1237     require(owner != address(0), "ERC721: balance query for the zero address");
1238     return uint256(_addressData[owner].balance);
1239   }
1240 
1241   function _numberMinted(address owner) internal view returns (uint256) {
1242     require(
1243       owner != address(0),
1244       "ERC721: number minted query for the zero address"
1245     );
1246     return uint256(_addressData[owner].numberMinted);
1247   }
1248 
1249   function ownershipOf(uint256 tokenId)
1250     internal
1251     view
1252     returns (TokenOwnership memory)
1253   {
1254     require(_exists(tokenId), "ERC721: owner query for nonexistent token");
1255 
1256     uint256 lowestTokenToCheck;
1257     if (tokenId >= maxBatchSize) {
1258       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1259     }
1260 
1261     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1262       TokenOwnership memory ownership = _ownerships[curr];
1263       if (ownership.addr != address(0)) {
1264         return ownership;
1265       }
1266     }
1267 
1268     revert("ERC721: unable to determine the owner of token");
1269   }
1270 
1271   /**
1272    * @dev See {IERC721-ownerOf}.
1273    */
1274   function ownerOf(uint256 tokenId) public view override returns (address) {
1275     return ownershipOf(tokenId).addr;
1276   }
1277 
1278   /**
1279    * @dev See {IERC721Metadata-name}.
1280    */
1281   function name() public view virtual override returns (string memory) {
1282     return _name;
1283   }
1284 
1285   /**
1286    * @dev See {IERC721Metadata-symbol}.
1287    */
1288   function symbol() public view virtual override returns (string memory) {
1289     return _symbol;
1290   }
1291 
1292   /**
1293    * @dev See {IERC721Metadata-tokenURI}.
1294    */
1295   function tokenURI(uint256 tokenId)
1296     public
1297     view
1298     virtual
1299     override
1300     returns (string memory)
1301   {
1302     require(
1303       _exists(tokenId),
1304       "ERC721Metadata: URI query for nonexistent token"
1305     );
1306 
1307     string memory baseURI = _baseURI();
1308     return
1309       bytes(baseURI).length > 0
1310         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1311         : "";
1312   }
1313 
1314   /**
1315    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1316    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1317    * by default, can be overriden in child contracts.
1318    */
1319   function _baseURI() internal view virtual returns (string memory) {
1320     return "";
1321   }
1322 
1323   /**
1324    * @dev See {IERC721-approve}.
1325    */
1326   function approve(address to, uint256 tokenId) public override {
1327     address owner = ERC721.ownerOf(tokenId);
1328     require(to != owner, "ERC721: approval to current owner");
1329 
1330     require(
1331       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1332       "ERC721: approve caller is not owner nor approved for all"
1333     );
1334 
1335     _approve(to, tokenId, owner);
1336   }
1337 
1338   /**
1339    * @dev See {IERC721-getApproved}.
1340    */
1341   function getApproved(uint256 tokenId) public view override returns (address) {
1342     require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1343 
1344     return _tokenApprovals[tokenId];
1345   }
1346 
1347   /**
1348    * @dev See {IERC721-setApprovalForAll}.
1349    */
1350   function setApprovalForAll(address operator, bool approved) public override {
1351     require(operator != _msgSender(), "ERC721: approve to caller");
1352 
1353     _operatorApprovals[_msgSender()][operator] = approved;
1354     emit ApprovalForAll(_msgSender(), operator, approved);
1355   }
1356 
1357   /**
1358    * @dev See {IERC721-isApprovedForAll}.
1359    */
1360   function isApprovedForAll(address owner, address operator)
1361     public
1362     view
1363     virtual
1364     override
1365     returns (bool)
1366   {
1367     return _operatorApprovals[owner][operator];
1368   }
1369 
1370   /**
1371    * @dev See {IERC721-transferFrom}.
1372    */
1373   function transferFrom(
1374     address from,
1375     address to,
1376     uint256 tokenId
1377   ) public override {
1378     _transfer(from, to, tokenId);
1379   }
1380 
1381   /**
1382    * @dev See {IERC721-safeTransferFrom}.
1383    */
1384   function safeTransferFrom(
1385     address from,
1386     address to,
1387     uint256 tokenId
1388   ) public override {
1389     safeTransferFrom(from, to, tokenId, "");
1390   }
1391 
1392   /**
1393    * @dev See {IERC721-safeTransferFrom}.
1394    */
1395   function safeTransferFrom(
1396     address from,
1397     address to,
1398     uint256 tokenId,
1399     bytes memory _data
1400   ) public override {
1401     _transfer(from, to, tokenId);
1402     require(
1403       _checkOnERC721Received(from, to, tokenId, _data),
1404       "ERC721: transfer to non ERC721Receiver implementer"
1405     );
1406   }
1407 
1408   /**
1409    * @dev Returns whether `tokenId` exists.
1410    *
1411    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1412    *
1413    * Tokens start existing when they are minted (`_mint`),
1414    */
1415   function _exists(uint256 tokenId) internal view returns (bool) {
1416     return tokenId < currentIndex;
1417   }
1418 
1419   function _safeMint(address to, uint256 quantity) internal {
1420     _safeMint(to, quantity, "");
1421   }
1422 
1423   /**
1424    * @dev Mints `quantity` tokens and transfers them to `to`.
1425    *
1426    * Requirements:
1427    *
1428    * - `to` cannot be the zero address.
1429    * - `quantity` cannot be larger than the max batch size.
1430    *
1431    * Emits a {Transfer} event.
1432    */
1433   function _safeMint(
1434     address to,
1435     uint256 quantity,
1436     bytes memory _data
1437   ) internal {
1438     uint256 startTokenId = currentIndex;
1439     require(to != address(0), "ERC721: mint to the zero address");
1440     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1441     require(!_exists(startTokenId), "ERC721: token already minted");
1442     require(quantity <= maxBatchSize, "ERC721: quantity to mint too high");
1443 
1444     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1445 
1446     AddressData memory addressData = _addressData[to];
1447     _addressData[to] = AddressData(
1448       addressData.balance + uint128(quantity),
1449       addressData.numberMinted + uint128(quantity)
1450     );
1451     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1452 
1453     uint256 updatedIndex = startTokenId;
1454 
1455     for (uint256 i = 0; i < quantity; i++) {
1456       emit Transfer(address(0), to, updatedIndex);
1457       require(
1458         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1459         "ERC721: transfer to non ERC721Receiver implementer"
1460       );
1461       updatedIndex++;
1462     }
1463 
1464     currentIndex = updatedIndex;
1465     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1466   }
1467 
1468   /**
1469    * @dev Transfers `tokenId` from `from` to `to`.
1470    *
1471    * Requirements:
1472    *
1473    * - `to` cannot be the zero address.
1474    * - `tokenId` token must be owned by `from`.
1475    *
1476    * Emits a {Transfer} event.
1477    */
1478   function _transfer(
1479     address from,
1480     address to,
1481     uint256 tokenId
1482   ) private {
1483     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1484 
1485     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1486       getApproved(tokenId) == _msgSender() ||
1487       isApprovedForAll(prevOwnership.addr, _msgSender()));
1488 
1489     require(
1490       isApprovedOrOwner,
1491       "ERC721: transfer caller is not owner nor approved"
1492     );
1493 
1494     require(
1495       prevOwnership.addr == from,
1496       "ERC721: transfer from incorrect owner"
1497     );
1498     require(to != address(0), "ERC721: transfer to the zero address");
1499 
1500     _beforeTokenTransfers(from, to, tokenId, 1);
1501 
1502     // Clear approvals from the previous owner
1503     _approve(address(0), tokenId, prevOwnership.addr);
1504 
1505     _addressData[from].balance -= 1;
1506     _addressData[to].balance += 1;
1507     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1508 
1509     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1510     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1511     uint256 nextTokenId = tokenId + 1;
1512     if (_ownerships[nextTokenId].addr == address(0)) {
1513       if (_exists(nextTokenId)) {
1514         _ownerships[nextTokenId] = TokenOwnership(
1515           prevOwnership.addr,
1516           prevOwnership.startTimestamp
1517         );
1518       }
1519     }
1520 
1521     emit Transfer(from, to, tokenId);
1522     _afterTokenTransfers(from, to, tokenId, 1);
1523   }
1524 
1525   /**
1526    * @dev Approve `to` to operate on `tokenId`
1527    *
1528    * Emits a {Approval} event.
1529    */
1530   function _approve(
1531     address to,
1532     uint256 tokenId,
1533     address owner
1534   ) private {
1535     _tokenApprovals[tokenId] = to;
1536     emit Approval(owner, to, tokenId);
1537   }
1538 
1539   uint256 public nextOwnerToExplicitlySet = 0;
1540 
1541   /**
1542    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1543    */
1544   function _setOwnersExplicit(uint256 quantity) internal {
1545     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1546     require(quantity > 0, "quantity must be nonzero");
1547     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1548     if (endIndex > currentIndex - 1) {
1549       endIndex = currentIndex - 1;
1550     }
1551     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1552     require(_exists(endIndex), "not enough minted yet for this cleanup");
1553     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1554       if (_ownerships[i].addr == address(0)) {
1555         TokenOwnership memory ownership = ownershipOf(i);
1556         _ownerships[i] = TokenOwnership(
1557           ownership.addr,
1558           ownership.startTimestamp
1559         );
1560       }
1561     }
1562     nextOwnerToExplicitlySet = endIndex + 1;
1563   }
1564 
1565   /**
1566    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1567    * The call is not executed if the target address is not a contract.
1568    *
1569    * @param from address representing the previous owner of the given token ID
1570    * @param to target address that will receive the tokens
1571    * @param tokenId uint256 ID of the token to be transferred
1572    * @param _data bytes optional data to send along with the call
1573    * @return bool whether the call correctly returned the expected magic value
1574    */
1575   function _checkOnERC721Received(
1576     address from,
1577     address to,
1578     uint256 tokenId,
1579     bytes memory _data
1580   ) private returns (bool) {
1581     if (to.isContract()) {
1582       try
1583         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1584       returns (bytes4 retval) {
1585         return retval == IERC721Receiver(to).onERC721Received.selector;
1586       } catch (bytes memory reason) {
1587         if (reason.length == 0) {
1588           revert("ERC721: transfer to non ERC721Receiver implementer");
1589         } else {
1590           assembly {
1591             revert(add(32, reason), mload(reason))
1592           }
1593         }
1594       }
1595     } else {
1596       return true;
1597     }
1598   }
1599 
1600   /**
1601    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1602    *
1603    * startTokenId - the first token id to be transferred
1604    * quantity - the amount to be transferred
1605    *
1606    * Calling conditions:
1607    *
1608    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1609    * transferred to `to`.
1610    * - When `from` is zero, `tokenId` will be minted for `to`.
1611    */
1612   function _beforeTokenTransfers(
1613     address from,
1614     address to,
1615     uint256 startTokenId,
1616     uint256 quantity
1617   ) internal virtual {}
1618 
1619   /**
1620    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1621    * minting.
1622    *
1623    * startTokenId - the first token id to be transferred
1624    * quantity - the amount to be transferred
1625    *
1626    * Calling conditions:
1627    *
1628    * - when `from` and `to` are both non-zero.
1629    * - `from` and `to` are never both zero.
1630    */
1631   function _afterTokenTransfers(
1632     address from,
1633     address to,
1634     uint256 startTokenId,
1635     uint256 quantity
1636   ) internal virtual {}
1637 }
1638 
1639 // File contracts/SquirrellySquirrels.sol
1640 
1641 //                              ██
1642 //                            ██
1643 //                            ██
1644 //                        ██████████
1645 //                    ██████████████████
1646 //                  ██████████████████████
1647 //                  ██████████████████████
1648 //                ██████████████████████████
1649 //                  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
1650 //                  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
1651 //                  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
1652 //                  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
1653 //                  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
1654 //                  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
1655 //                  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
1656 //                  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
1657 //                    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
1658 //                      ▒▒▒▒▒▒▒▒▒▒▒▒▒▒
1659 //                          ▒▒▒▒▒▒
1660 //
1661 //  ____   ___  _   _ ___ ____  ____  _____ _     _  __   __
1662 // / ___| / _ \| | | |_ _|  _ \|  _ \| ____| |   | | \ \ / /
1663 // \___ \| | | | | | || || |_) | |_) |  _| | |   | |  \ V /
1664 //  ___) | |_| | |_| || ||  _ <|  _ <| |___| |___| |___| |
1665 // |____/ \__\_\\___/|___|_| \_\_| \_\_____|_____|_____|_|
1666 //
1667 //    ____   ___  _   _ ___ ____  ____  _____ _     ____
1668 //   / ___| / _ \| | | |_ _|  _ \|  _ \| ____| |   / ___|
1669 //   \___ \| | | | | | || || |_) | |_) |  _| | |   \___ \
1670 //    ___) | |_| | |_| || ||  _ <|  _ <| |___| |___ ___) |
1671 //   |____/ \__\_\\___/|___|_| \_\_| \_\_____|_____|____/
1672 
1673 pragma solidity ^0.8.0;
1674 
1675 contract SquirrellySquirrels is VRFConsumerBase, ERC721, Ownable {
1676   using Strings for uint256;
1677 
1678   uint256 public constant NFT_1_PRICE = 0.16 ether;
1679   uint256 public constant NFT_3_PRICE = 0.39 ether;
1680   uint256 public constant NFT_5_PRICE = 0.45 ether;
1681   uint256 public constant MAX_NFT_PURCHASE_PRESALE = 5;
1682   uint256 public constant MAX_MINT_PER_TX = 5;
1683   uint256 public constant MAX_SUPPLY = 10000;
1684 
1685   bool public saleIsActive = false;
1686   bool public presaleIsActive = false;
1687 
1688   bool public revealed = false;
1689 
1690   uint256 public reserve = 300;
1691   uint256 public startingIndex;
1692 
1693   mapping(address => uint256) public allowListNumClaimed;
1694   bytes32 public allowListMerkleRoot;
1695   bytes32 public startingIndexRequestId;
1696 
1697   string public uriPrefix = "";
1698   string public uriSuffix = ".json";
1699   string public hiddenMetadataUri = "";
1700   string public provenance;
1701 
1702   string private _baseURIExtended;
1703 
1704   modifier mintCompliance(uint256 _numberOfTokens) {
1705     require(
1706       _numberOfTokens > 0 &&
1707         _numberOfTokens != 2 &&
1708         _numberOfTokens != 4 &&
1709         _numberOfTokens <= MAX_MINT_PER_TX,
1710       "Invalid mint amount"
1711     );
1712 
1713     require(
1714       (_numberOfTokens == 1 && msg.value == NFT_1_PRICE) ||
1715         (_numberOfTokens == 3 && msg.value == NFT_3_PRICE) ||
1716         (_numberOfTokens == 5 && msg.value == NFT_5_PRICE),
1717       "Sent ether value is incorrect"
1718     );
1719 
1720     _;
1721   }
1722 
1723   constructor(
1724     address _vrfCoordinator,
1725     address _link,
1726     address _owner
1727   )
1728     ERC721("Squirrelly Squirrels", "SQRLY", 300)
1729     VRFConsumerBase(_vrfCoordinator, _link)
1730   {
1731     transferOwnership(_owner);
1732   }
1733 
1734   function requestStartingIndex(bytes32 _keyHash, uint256 _fee)
1735     external
1736     onlyOwner
1737     returns (bytes32 requestId)
1738   {
1739     require(startingIndex == 0, "startingIndex has already been set");
1740     bytes32 _requestId = requestRandomness(_keyHash, _fee);
1741     startingIndexRequestId = _requestId;
1742     return _requestId;
1743   }
1744 
1745   function fulfillRandomness(bytes32 _requestId, uint256 _randomness)
1746     internal
1747     override
1748   {
1749     if (startingIndexRequestId == _requestId) {
1750       startingIndex = _randomness % MAX_SUPPLY;
1751     }
1752   }
1753 
1754   function claimReserve(address _to, uint256 _reserveAmount)
1755     external
1756     onlyOwner
1757   {
1758     require(
1759       _reserveAmount > 0 && _reserveAmount <= reserve,
1760       "Not enough reserve left for team"
1761     );
1762 
1763     reserve = reserve - _reserveAmount;
1764 
1765     _safeMint(_to, _reserveAmount);
1766   }
1767 
1768   function flipSaleState() external onlyOwner {
1769     saleIsActive = !saleIsActive;
1770   }
1771 
1772   function flipPresaleState() external onlyOwner {
1773     presaleIsActive = !presaleIsActive;
1774   }
1775 
1776   function isAllowListed(bytes32[] memory _proof, address _address)
1777     public
1778     view
1779     returns (bool)
1780   {
1781     require(_address != address(0), "Zero address not on Allow List");
1782 
1783     bytes32 leaf = keccak256(abi.encodePacked(_address));
1784     return MerkleProof.verify(_proof, allowListMerkleRoot, leaf);
1785   }
1786 
1787   function setAllowListMerkleRoot(bytes32 _allowListMerkleRoot)
1788     external
1789     onlyOwner
1790   {
1791     allowListMerkleRoot = _allowListMerkleRoot;
1792   }
1793 
1794   function mintPresale(bytes32[] memory _proof, uint256 _numberOfTokens)
1795     external
1796     payable
1797     mintCompliance(_numberOfTokens)
1798   {
1799     require(presaleIsActive, "Presale is not active at the moment");
1800     require(
1801       isAllowListed(_proof, msg.sender),
1802       "This address is not allow listed for the presale"
1803     );
1804     require(
1805       allowListNumClaimed[msg.sender] + _numberOfTokens <=
1806         MAX_NFT_PURCHASE_PRESALE,
1807       "Exceeds allowed presale you can mint"
1808     );
1809     require(
1810       totalSupply() + _numberOfTokens <= MAX_SUPPLY - reserve,
1811       "Purchase would exceed max supply"
1812     );
1813 
1814     _safeMint(msg.sender, _numberOfTokens);
1815 
1816     allowListNumClaimed[msg.sender] += _numberOfTokens;
1817   }
1818 
1819   function mint(uint256 _numberOfTokens)
1820     external
1821     payable
1822     mintCompliance(_numberOfTokens)
1823   {
1824     require(saleIsActive, "Sale is not active at the moment");
1825     require(
1826       totalSupply() + _numberOfTokens <= MAX_SUPPLY - reserve,
1827       "Purchase would exceed max supply"
1828     );
1829 
1830     _safeMint(msg.sender, _numberOfTokens);
1831   }
1832 
1833   function walletOfOwner(address _owner)
1834     external
1835     view
1836     returns (uint256[] memory)
1837   {
1838     uint256 ownerTokenCount = balanceOf(_owner);
1839     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1840 
1841     for (uint256 i = 0; i < ownerTokenCount; i++) {
1842       ownedTokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1843     }
1844 
1845     return ownedTokenIds;
1846   }
1847 
1848   function tokenURI(uint256 _tokenId)
1849     public
1850     view
1851     virtual
1852     override
1853     returns (string memory)
1854   {
1855     require(
1856       _exists(_tokenId),
1857       "ERC721Metadata: URI query for nonexistent token"
1858     );
1859 
1860     if (revealed == false) {
1861       return hiddenMetadataUri;
1862     }
1863 
1864     string memory currentBaseURI = _baseURI();
1865     return
1866       bytes(currentBaseURI).length > 0
1867         ? string(
1868           abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix)
1869         )
1870         : "";
1871   }
1872 
1873   function setHiddenMetadataUri(string memory _hiddenMetadataUri)
1874     external
1875     onlyOwner
1876   {
1877     hiddenMetadataUri = _hiddenMetadataUri;
1878   }
1879 
1880   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1881     uriPrefix = _uriPrefix;
1882   }
1883 
1884   function setUriSuffix(string memory _uriSuffix) external onlyOwner {
1885     uriSuffix = _uriSuffix;
1886   }
1887 
1888   function setRevealed(bool _state) external onlyOwner {
1889     revealed = _state;
1890   }
1891 
1892   function setProvenance(string calldata _provenance) external onlyOwner {
1893     provenance = _provenance;
1894   }
1895 
1896   function withdraw() external onlyOwner {
1897     (bool os, ) = payable(owner()).call{ value: address(this).balance }("");
1898     require(os, "withdraw: transfer failed");
1899   }
1900 
1901   function _baseURI() internal view virtual override returns (string memory) {
1902     return uriPrefix;
1903   }
1904 }