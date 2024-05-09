1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity 0.8.15;
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
28 
29 /**
30  * @dev Contract module which provides a basic access control mechanism, where
31  * there is an account (an owner) that can be granted exclusive access to
32  * specific functions.
33  *
34  * By default, the owner account will be the one that deploys the contract. This
35  * can later be changed with {transferOwnership}.
36  *
37  * This module is used through inheritance. It will make available the modifier
38  * `onlyOwner`, which can be applied to your functions to restrict their use to
39  * the owner.
40  */
41 abstract contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(
45         address indexed previousOwner,
46         address indexed newOwner
47     );
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() {
53         _transferOwnership(_msgSender());
54     }
55 
56     /**
57      * @dev Throws if called by any account other than the owner.
58      */
59     modifier onlyOwner() {
60         _checkOwner();
61         _;
62     }
63 
64     /**
65      * @dev Returns the address of the current owner.
66      */
67     function owner() public view virtual returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Throws if the sender is not the owner.
73      */
74     function _checkOwner() internal view virtual {
75         require(owner() == _msgSender(), "Ownable: caller is not the owner");
76     }
77 
78     /**
79      * @dev Leaves the contract without owner. It will not be possible to call
80      * `onlyOwner` functions anymore. Can only be called by the current owner.
81      *
82      * NOTE: Renouncing ownership will leave the contract without an owner,
83      * thereby removing any functionality that is only available to the owner.
84      */
85     function renounceOwnership() public virtual onlyOwner {
86         _transferOwnership(address(0));
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public virtual onlyOwner {
94         require(
95             newOwner != address(0),
96             "Ownable: new owner is the zero address"
97         );
98         _transferOwnership(newOwner);
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      * Internal function without access restriction.
104      */
105     function _transferOwnership(address newOwner) internal virtual {
106         address oldOwner = _owner;
107         _owner = newOwner;
108         emit OwnershipTransferred(oldOwner, newOwner);
109     }
110 }
111 
112 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
113 
114 /**
115  * @dev Contract module which allows children to implement an emergency stop
116  * mechanism that can be triggered by an authorized account.
117  *
118  * This module is used through inheritance. It will make available the
119  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
120  * the functions of your contract. Note that they will not be pausable by
121  * simply including this module, only once the modifiers are put in place.
122  */
123 abstract contract Pausable is Context {
124     /**
125      * @dev Emitted when the pause is triggered by `account`.
126      */
127     event Paused(address account);
128 
129     /**
130      * @dev Emitted when the pause is lifted by `account`.
131      */
132     event Unpaused(address account);
133 
134     bool private _paused;
135 
136     /**
137      * @dev Initializes the contract in unpaused state.
138      */
139     constructor() {
140         _paused = false;
141     }
142 
143     /**
144      * @dev Modifier to make a function callable only when the contract is not paused.
145      *
146      * Requirements:
147      *
148      * - The contract must not be paused.
149      */
150     modifier whenNotPaused() {
151         _requireNotPaused();
152         _;
153     }
154 
155     /**
156      * @dev Modifier to make a function callable only when the contract is paused.
157      *
158      * Requirements:
159      *
160      * - The contract must be paused.
161      */
162     modifier whenPaused() {
163         _requirePaused();
164         _;
165     }
166 
167     /**
168      * @dev Returns true if the contract is paused, and false otherwise.
169      */
170     function paused() public view virtual returns (bool) {
171         return _paused;
172     }
173 
174     /**
175      * @dev Throws if the contract is paused.
176      */
177     function _requireNotPaused() internal view virtual {
178         require(!paused(), "Pausable: paused");
179     }
180 
181     /**
182      * @dev Throws if the contract is not paused.
183      */
184     function _requirePaused() internal view virtual {
185         require(paused(), "Pausable: not paused");
186     }
187 
188     /**
189      * @dev Triggers stopped state.
190      *
191      * Requirements:
192      *
193      * - The contract must not be paused.
194      */
195     function _pause() internal virtual whenNotPaused {
196         _paused = true;
197         emit Paused(_msgSender());
198     }
199 
200     /**
201      * @dev Returns to normal state.
202      *
203      * Requirements:
204      *
205      * - The contract must be paused.
206      */
207     function _unpause() internal virtual whenPaused {
208         _paused = false;
209         emit Unpaused(_msgSender());
210     }
211 }
212 
213 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/Clones.sol)
214 
215 /**
216  * @dev https://eips.ethereum.org/EIPS/eip-1167[EIP 1167] is a standard for
217  * deploying minimal proxy contracts, also known as "clones".
218  *
219  * > To simply and cheaply clone contract functionality in an immutable way, this standard specifies
220  * > a minimal bytecode implementation that delegates all calls to a known, fixed address.
221  *
222  * The library includes functions to deploy a proxy using either `create` (traditional deployment) or `create2`
223  * (salted deterministic deployment). It also includes functions to predict the addresses of clones deployed using the
224  * deterministic method.
225  *
226  * _Available since v3.4._
227  */
228 library Clones {
229     /**
230      * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
231      *
232      * This function uses the create opcode, which should never revert.
233      */
234     function clone(address implementation) internal returns (address instance) {
235         /// @solidity memory-safe-assembly
236         assembly {
237             let ptr := mload(0x40)
238             mstore(
239                 ptr,
240                 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000
241             )
242             mstore(add(ptr, 0x14), shl(0x60, implementation))
243             mstore(
244                 add(ptr, 0x28),
245                 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000
246             )
247             instance := create(0, ptr, 0x37)
248         }
249         require(instance != address(0), "ERC1167: create failed");
250     }
251 
252     /**
253      * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
254      *
255      * This function uses the create2 opcode and a `salt` to deterministically deploy
256      * the clone. Using the same `implementation` and `salt` multiple time will revert, since
257      * the clones cannot be deployed twice at the same address.
258      */
259     function cloneDeterministic(address implementation, bytes32 salt)
260         internal
261         returns (address instance)
262     {
263         /// @solidity memory-safe-assembly
264         assembly {
265             let ptr := mload(0x40)
266             mstore(
267                 ptr,
268                 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000
269             )
270             mstore(add(ptr, 0x14), shl(0x60, implementation))
271             mstore(
272                 add(ptr, 0x28),
273                 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000
274             )
275             instance := create2(0, ptr, 0x37, salt)
276         }
277         require(instance != address(0), "ERC1167: create2 failed");
278     }
279 
280     /**
281      * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
282      */
283     function predictDeterministicAddress(
284         address implementation,
285         bytes32 salt,
286         address deployer
287     ) internal pure returns (address predicted) {
288         /// @solidity memory-safe-assembly
289         assembly {
290             let ptr := mload(0x40)
291             mstore(
292                 ptr,
293                 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000
294             )
295             mstore(add(ptr, 0x14), shl(0x60, implementation))
296             mstore(
297                 add(ptr, 0x28),
298                 0x5af43d82803e903d91602b57fd5bf3ff00000000000000000000000000000000
299             )
300             mstore(add(ptr, 0x38), shl(0x60, deployer))
301             mstore(add(ptr, 0x4c), salt)
302             mstore(add(ptr, 0x6c), keccak256(ptr, 0x37))
303             predicted := keccak256(add(ptr, 0x37), 0x55)
304         }
305     }
306 
307     /**
308      * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
309      */
310     function predictDeterministicAddress(address implementation, bytes32 salt)
311         internal
312         view
313         returns (address predicted)
314     {
315         return predictDeterministicAddress(implementation, salt, address(this));
316     }
317 }
318 
319 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
320 
321 /**
322  * @dev Interface of the ERC165 standard, as defined in the
323  * https://eips.ethereum.org/EIPS/eip-165[EIP].
324  *
325  * Implementers can declare support of contract interfaces, which can then be
326  * queried by others ({ERC165Checker}).
327  *
328  * For an implementation, see {ERC165}.
329  */
330 interface IERC165 {
331     /**
332      * @dev Returns true if this contract implements the interface defined by
333      * `interfaceId`. See the corresponding
334      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
335      * to learn more about how these ids are created.
336      *
337      * This function call must use less than 30 000 gas.
338      */
339     function supportsInterface(bytes4 interfaceId) external view returns (bool);
340 }
341 
342 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165Checker.sol)
343 
344 /**
345  * @dev Library used to query support of an interface declared via {IERC165}.
346  *
347  * Note that these functions return the actual result of the query: they do not
348  * `revert` if an interface is not supported. It is up to the caller to decide
349  * what to do in these cases.
350  */
351 library ERC165Checker {
352     // As per the EIP-165 spec, no interface should ever match 0xffffffff
353     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
354 
355     /**
356      * @dev Returns true if `account` supports the {IERC165} interface,
357      */
358     function supportsERC165(address account) internal view returns (bool) {
359         // Any contract that implements ERC165 must explicitly indicate support of
360         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
361         return
362             supportsERC165InterfaceUnchecked(
363                 account,
364                 type(IERC165).interfaceId
365             ) &&
366             !supportsERC165InterfaceUnchecked(account, _INTERFACE_ID_INVALID);
367     }
368 
369     /**
370      * @dev Returns true if `account` supports the interface defined by
371      * `interfaceId`. Support for {IERC165} itself is queried automatically.
372      *
373      * See {IERC165-supportsInterface}.
374      */
375     function supportsInterface(address account, bytes4 interfaceId)
376         internal
377         view
378         returns (bool)
379     {
380         // query support of both ERC165 as per the spec and support of _interfaceId
381         return
382             supportsERC165(account) &&
383             supportsERC165InterfaceUnchecked(account, interfaceId);
384     }
385 
386     /**
387      * @dev Returns a boolean array where each value corresponds to the
388      * interfaces passed in and whether they're supported or not. This allows
389      * you to batch check interfaces for a contract where your expectation
390      * is that some interfaces may not be supported.
391      *
392      * See {IERC165-supportsInterface}.
393      *
394      * _Available since v3.4._
395      */
396     function getSupportedInterfaces(
397         address account,
398         bytes4[] memory interfaceIds
399     ) internal view returns (bool[] memory) {
400         // an array of booleans corresponding to interfaceIds and whether they're supported or not
401         bool[] memory interfaceIdsSupported = new bool[](interfaceIds.length);
402 
403         // query support of ERC165 itself
404         if (supportsERC165(account)) {
405             // query support of each interface in interfaceIds
406             for (uint256 i = 0; i < interfaceIds.length; i++) {
407                 interfaceIdsSupported[i] = supportsERC165InterfaceUnchecked(
408                     account,
409                     interfaceIds[i]
410                 );
411             }
412         }
413 
414         return interfaceIdsSupported;
415     }
416 
417     /**
418      * @dev Returns true if `account` supports all the interfaces defined in
419      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
420      *
421      * Batch-querying can lead to gas savings by skipping repeated checks for
422      * {IERC165} support.
423      *
424      * See {IERC165-supportsInterface}.
425      */
426     function supportsAllInterfaces(
427         address account,
428         bytes4[] memory interfaceIds
429     ) internal view returns (bool) {
430         // query support of ERC165 itself
431         if (!supportsERC165(account)) {
432             return false;
433         }
434 
435         // query support of each interface in _interfaceIds
436         for (uint256 i = 0; i < interfaceIds.length; i++) {
437             if (!supportsERC165InterfaceUnchecked(account, interfaceIds[i])) {
438                 return false;
439             }
440         }
441 
442         // all interfaces supported
443         return true;
444     }
445 
446     /**
447      * @notice Query if a contract implements an interface, does not check ERC165 support
448      * @param account The address of the contract to query for support of an interface
449      * @param interfaceId The interface identifier, as specified in ERC-165
450      * @return true if the contract at account indicates support of the interface with
451      * identifier interfaceId, false otherwise
452      * @dev Assumes that account contains a contract that supports ERC165, otherwise
453      * the behavior of this method is undefined. This precondition can be checked
454      * with {supportsERC165}.
455      * Interface identification is specified in ERC-165.
456      */
457     function supportsERC165InterfaceUnchecked(
458         address account,
459         bytes4 interfaceId
460     ) internal view returns (bool) {
461         // prepare call
462         bytes memory encodedParams = abi.encodeWithSelector(
463             IERC165.supportsInterface.selector,
464             interfaceId
465         );
466 
467         // perform static call
468         bool success;
469         uint256 returnSize;
470         uint256 returnValue;
471         assembly {
472             success := staticcall(
473                 30000,
474                 account,
475                 add(encodedParams, 0x20),
476                 mload(encodedParams),
477                 0x00,
478                 0x20
479             )
480             returnSize := returndatasize()
481             returnValue := mload(0x00)
482         }
483 
484         return success && returnSize >= 0x20 && returnValue > 0;
485     }
486 }
487 
488 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
489 
490 /**
491  * @dev Interface of the ERC165 standard, as defined in the
492  * https://eips.ethereum.org/EIPS/eip-165[EIP].
493  *
494  * Implementers can declare support of contract interfaces, which can then be
495  * queried by others ({ERC165Checker}).
496  *
497  * For an implementation, see {ERC165}.
498  */
499 interface IERC165Upgradeable {
500     /**
501      * @dev Returns true if this contract implements the interface defined by
502      * `interfaceId`. See the corresponding
503      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
504      * to learn more about how these ids are created.
505      *
506      * This function call must use less than 30 000 gas.
507      */
508     function supportsInterface(bytes4 interfaceId) external view returns (bool);
509 }
510 
511 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
512 
513 /**
514  * @dev Required interface of an ERC721 compliant contract.
515  */
516 interface IERC721Upgradeable is IERC165Upgradeable {
517     /**
518      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
519      */
520     event Transfer(
521         address indexed from,
522         address indexed to,
523         uint256 indexed tokenId
524     );
525 
526     /**
527      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
528      */
529     event Approval(
530         address indexed owner,
531         address indexed approved,
532         uint256 indexed tokenId
533     );
534 
535     /**
536      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
537      */
538     event ApprovalForAll(
539         address indexed owner,
540         address indexed operator,
541         bool approved
542     );
543 
544     /**
545      * @dev Returns the number of tokens in ``owner``'s account.
546      */
547     function balanceOf(address owner) external view returns (uint256 balance);
548 
549     /**
550      * @dev Returns the owner of the `tokenId` token.
551      *
552      * Requirements:
553      *
554      * - `tokenId` must exist.
555      */
556     function ownerOf(uint256 tokenId) external view returns (address owner);
557 
558     /**
559      * @dev Safely transfers `tokenId` token from `from` to `to`.
560      *
561      * Requirements:
562      *
563      * - `from` cannot be the zero address.
564      * - `to` cannot be the zero address.
565      * - `tokenId` token must exist and be owned by `from`.
566      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
567      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
568      *
569      * Emits a {Transfer} event.
570      */
571     function safeTransferFrom(
572         address from,
573         address to,
574         uint256 tokenId,
575         bytes calldata data
576     ) external;
577 
578     /**
579      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
580      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
581      *
582      * Requirements:
583      *
584      * - `from` cannot be the zero address.
585      * - `to` cannot be the zero address.
586      * - `tokenId` token must exist and be owned by `from`.
587      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
588      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
589      *
590      * Emits a {Transfer} event.
591      */
592     function safeTransferFrom(
593         address from,
594         address to,
595         uint256 tokenId
596     ) external;
597 
598     /**
599      * @dev Transfers `tokenId` token from `from` to `to`.
600      *
601      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
602      *
603      * Requirements:
604      *
605      * - `from` cannot be the zero address.
606      * - `to` cannot be the zero address.
607      * - `tokenId` token must be owned by `from`.
608      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
609      *
610      * Emits a {Transfer} event.
611      */
612     function transferFrom(
613         address from,
614         address to,
615         uint256 tokenId
616     ) external;
617 
618     /**
619      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
620      * The approval is cleared when the token is transferred.
621      *
622      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
623      *
624      * Requirements:
625      *
626      * - The caller must own the token or be an approved operator.
627      * - `tokenId` must exist.
628      *
629      * Emits an {Approval} event.
630      */
631     function approve(address to, uint256 tokenId) external;
632 
633     /**
634      * @dev Approve or remove `operator` as an operator for the caller.
635      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
636      *
637      * Requirements:
638      *
639      * - The `operator` cannot be the caller.
640      *
641      * Emits an {ApprovalForAll} event.
642      */
643     function setApprovalForAll(address operator, bool _approved) external;
644 
645     /**
646      * @dev Returns the account approved for `tokenId` token.
647      *
648      * Requirements:
649      *
650      * - `tokenId` must exist.
651      */
652     function getApproved(uint256 tokenId)
653         external
654         view
655         returns (address operator);
656 
657     /**
658      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
659      *
660      * See {setApprovalForAll}
661      */
662     function isApprovedForAll(address owner, address operator)
663         external
664         view
665         returns (bool);
666 }
667 
668 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
669 
670 /**
671  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
672  * @dev See https://eips.ethereum.org/EIPS/eip-721
673  */
674 interface IERC721MetadataUpgradeable is IERC721Upgradeable {
675     /**
676      * @dev Returns the token collection name.
677      */
678     function name() external view returns (string memory);
679 
680     /**
681      * @dev Returns the token collection symbol.
682      */
683     function symbol() external view returns (string memory);
684 
685     /**
686      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
687      */
688     function tokenURI(uint256 tokenId) external view returns (string memory);
689 }
690 
691 /**
692  * Interface for a Guard that governs whether a token can be minted, burned, or
693  * transferred by a particular operator, from a particular sender (`from` is
694  * address 0 iff the token is being minted), to a particular recipient (`to` is
695  * address 0 iff the token is being burned).
696  */
697 interface IGuard {
698     /**
699      * @return True iff the transaction is allowed
700      * @param operator Transaction msg.sender
701      * @param from Token sender
702      * @param to Token recipient
703      * @param value Amount (ERC20) or token ID (ERC721)
704      */
705     function isAllowed(
706         address operator,
707         address from,
708         address to,
709         uint256 value // amount (ERC20) or tokenId (ERC721)
710     ) external view returns (bool);
711 }
712 
713 interface ITokenEnforceable {
714     event ControlDisabled(address indexed controller);
715     event GuardLocked(
716         bool mintGuardLocked,
717         bool burnGuardLocked,
718         bool transferGuardLocked
719     );
720     event GuardUpdated(GuardType indexed guard, address indexed implementation);
721     event BatcherUpdated(address batcher);
722 
723     /**
724      * @return The address of the transaction batcher used to batch calls over
725      * onlyOwner functions.
726      */
727     function batcher() external view returns (address);
728 
729     /**
730      * @return True iff the token contract owner is allowed to mint, burn, or
731      * transfer on behalf of arbitrary addresses.
732      */
733     function isControllable() external view returns (bool);
734 
735     /**
736      * @return The address of the Guard used to determine whether a mint is
737      * allowed. The contract at this address is assumed to implement the IGuard
738      * interface.
739      */
740     function mintGuard() external view returns (IGuard);
741 
742     /**
743      * @return The address of the Guard used to determine whether a burn is
744      * allowed. The contract at this address is assumed to implement the IGuard
745      * interface.
746      */
747     function burnGuard() external view returns (IGuard);
748 
749     /**
750      * @return The address of the Guard used to determine whether a transfer is
751      * allowed. The contract at this address is assumed to implement the IGuard
752      * interface.
753      */
754     function transferGuard() external view returns (IGuard);
755 
756     /**
757      * @return True iff the mint Guard cannot be changed.
758      */
759     function mintGuardLocked() external view returns (bool);
760 
761     /**
762      * @return True iff the burn Guard cannot be changed.
763      */
764     function burnGuardLocked() external view returns (bool);
765 
766     /**
767      * @return True iff the transfer Guard cannot be changed.
768      */
769     function transferGuardLocked() external view returns (bool);
770 
771     /**
772      * Irreversibly disables the token contract owner from minting, burning,
773      * and transferring on behalf of arbitrary addresses.
774      *
775      * Emits a `ControlDisabled` event.
776      *
777      * Requirements:
778      * - The caller must be the token contract owner.
779      */
780     function disableControl() external;
781 
782     /**
783      * Irreversibly prevents the token contract owner from changing the mint,
784      * burn, and/or transfer Guards.
785      *
786      * If at least one guard was requested to be locked, emits a `GuardLocked`
787      * event confirming whether each Guard is locked.
788      *
789      * Requirements:
790      * - The caller must be the owner.
791      * @param mintGuardLock If true, the mint Guard will be locked. If false,
792      * does nothing to the mint Guard.
793      * @param burnGuardLock If true, the mint Guard will be locked. If false,
794      * does nothing to the burn Guard.
795      * @param transferGuardLock If true, the mint Guard will be locked. If
796      * false, does nothing to the transfer Guard.
797      */
798     function lockGuards(
799         bool mintGuardLock,
800         bool burnGuardLock,
801         bool transferGuardLock
802     ) external;
803 
804     /**
805      * Update the address of the batcher for batching calls over
806      * onlyOwner functions.
807      *
808      * Emits a `BatcherUpdated` event.
809      *
810      * Requirements:
811      * - The caller must be the token contract owner or the batcher.
812      * @param implementation Address of the batcher.
813      */
814     function updateBatcher(address implementation) external;
815 
816     /**
817      * Update the address of the Guard for minting. The contract at the
818      * passed-in address is assumed to implement the IGuard interface.
819      *
820      * Emits a `GuardUpdated` event with `GuardType.Mint`.
821      *
822      * Requirements:
823      * - The caller must be the token contract owner or the batcher.
824      * - The mint Guard must not be locked.
825      * @param implementation Address of mint Guard
826      */
827     function updateMintGuard(address implementation) external;
828 
829     /**
830      * Update the address of the Guard for burning. The contract at the
831      * passed-in address is assumed to implement the IGuard interface.
832      *
833      * Emits a `GuardUpdated` event with `GuardType.Burn`.
834      *
835      * Requirements:
836      * - The caller must be the token contract owner or the batcher.
837      * - The burn Guard must not be locked.
838      * @param implementation Address of new burn Guard
839      */
840     function updateBurnGuard(address implementation) external;
841 
842     /**
843      * Update the address of the Guard for transferring. The contract at the
844      * passed-in address is assumed to implement the IGuard interface.
845      *
846      * Emits a `GuardUpdated` event with `GuardType.Transfer`.
847      *
848      * Requirements:
849      * - The caller must be the token contract owner or the batcher.
850      * - The transfer Guard must not be locked.
851      * @param implementation Address of transfer Guard
852      */
853     function updateTransferGuard(address implementation) external;
854 
855     /**
856      * @return True iff a token can be minted, burned, or transferred by a
857      * particular operator, from a particular sender (`from` is address 0 iff
858      * the token is being minted), to a particular recipient (`to` is address 0
859      * iff the token is being burned).
860      * @param operator Transaction msg.sender
861      * @param from Token sender
862      * @param to Token recipient
863      * @param value Amount (ERC20) or token ID (ERC721)
864      */
865     function isAllowed(
866         address operator,
867         address from,
868         address to,
869         uint256 value // amount (ERC20) or tokenId (ERC721)
870     ) external view returns (bool);
871 
872     /**
873      * @return owner The address of the token contract owner
874      */
875     function owner() external view returns (address);
876 
877     /**
878      * Transfers ownership of the contract to a new account (`newOwner`)
879      *
880      * Requirements:
881      * - The caller must be the current owner.
882      * @param newOwner Address that will become the owner
883      */
884     function transferOwnership(address newOwner) external;
885 
886     /**
887      * Leaves the contract without an owner. After calling this function, it
888      * will no longer be possible to call `onlyOwner` functions.
889      *
890      * Requirements:
891      * - The caller must be the current owner.
892      */
893     function renounceOwnership() external;
894 }
895 
896 enum GuardType {
897     Mint,
898     Burn,
899     Transfer
900 }
901 
902 /**
903  * @title IERC1644 Controller Token Operation (part of the ERC1400 Security
904  * Token Standards)
905  *
906  * See https://github.com/ethereum/EIPs/issues/1644. Data and operatorData
907  * parameters were removed.
908  */
909 interface IERC1644 {
910     event ControllerRedemption(
911         address account,
912         address indexed from,
913         uint256 value
914     );
915 
916     event ControllerTransfer(
917         address controller,
918         address indexed from,
919         address indexed to,
920         uint256 value
921     );
922 
923     /**
924      * Burns `tokenId` without checking whether the caller owns or is approved
925      * to spend the token.
926      *
927      * Requirements:
928      * - The caller must be the token contract owner.
929      * - `isControllable must be true.
930      * @param account The account whose token will be burned.
931      * @param value Amount (ERC20) or token ID (ERC721)
932      */
933     function controllerRedeem(
934         address account,
935         uint256 value // amount (ERC20) or tokenId (ERC721))
936     ) external;
937 
938     /**
939      * Transfers `tokenId` token from `from` to `to`, without checking whether
940      * the caller owns or is approved to spend the token.
941      *
942      * Requirements:
943      * - The caller must be the token contract owner.
944      * - `isControllable` must be true.
945      * @param from The account sending the token.
946      * @param to The account to receive the token.
947      * @param value Amount (ERC20) or token ID (ERC721)
948      */
949     function controllerTransfer(
950         address from,
951         address to,
952         uint256 value // amount (ERC20) or tokenId (ERC721)
953     ) external;
954 }
955 
956 /**
957  * Interface for functions defined in ERC721UpgradeableFork
958  */
959 interface IERC721UpgradeableFork is IERC721MetadataUpgradeable {
960     /**
961      * @return ID of the next token that will be minted. Existing tokens are
962      * limited to IDs between `STARTING_TOKEN_ID` and `_nextTokenId` (including
963      * `STARTING_TOKEN_ID` and excluding `_nextTokenId`, though not all of these
964      * IDs may be in use if tokens have been burned).
965      */
966     function nextTokenId() external view returns (uint256);
967 }
968 
969 /**
970  * Interface for only functions defined in ERC721Collective (excludes inherited
971  * and overridden functions)
972  */
973 interface IERC721CollectiveUnchained is IERC1644 {
974     event RendererUpdated(address indexed implementation);
975     event RendererLocked();
976 
977     /**
978      * Initializes ERC721Collective.
979      * @param name_ Name of token
980      * @param symbol_ Symbol of token
981      * @param mintGuard_ Address of mint guard
982      * @param burnGuard_ Address of burn guard
983      * @param transferGuard_ Address of transfer guard
984      * @param renderer_ Address of renderer
985      */
986     function __ERC721Collective_init(
987         string memory name_,
988         string memory symbol_,
989         address mintGuard_,
990         address burnGuard_,
991         address transferGuard_,
992         address renderer_
993     ) external;
994 
995     /**
996      * @return Number of currently-existing tokens (tokens that have been
997      * minted and that have not been burned).
998      */
999     function totalSupply() external view returns (uint256);
1000 
1001     // name(), symbol(), and tokenURI() overriding ERC721UpgradeableFork
1002     // declared in IERC721Fork
1003 
1004     /**
1005      * @return The address of the token Renderer. The contract at this address
1006      * is assumed to implement the IRenderer interface.
1007      */
1008     function renderer() external view returns (address);
1009 
1010     /**
1011      * @return True iff the Renderer cannot be changed.
1012      */
1013     function rendererLocked() external view returns (bool);
1014 
1015     /**
1016      * Update the address of the token Renderer. The contract at the passed-in
1017      * address is assumed to implement the IRenderer interface.
1018      *
1019      * Emits a `RendererUpdated` event.
1020      *
1021      * Requirements:
1022      * - The caller must be the token contract owner.
1023      * - Renderer must not be locked.
1024      * @param implementation Address of new Renderer
1025      */
1026     function updateRenderer(address implementation) external;
1027 
1028     /**
1029      * Irreversibly prevents the token contract owner from changing the token
1030      * Renderer.
1031      *
1032      * Emits a `RendererLocked` event.
1033      *
1034      * Requirements:
1035      * - The caller must be the token contract owner.
1036      */
1037     function lockRenderer() external;
1038 
1039     // supportsInterface(bytes4 interfaceId) overriding ERC1644 declared in
1040     // IERC1644
1041 
1042     /**
1043      * @return True after successfully executing mint and transfer of
1044      * `nextTokenId` to `account`.
1045      *
1046      * Emits a `Transfer` event with `address(0)` as `from`.
1047      *
1048      * Requirements:
1049      * - `account` cannot be the zero address.
1050      * @param account The account to receive the minted token.
1051      */
1052     function mintTo(address account) external returns (bool);
1053 
1054     /**
1055      * @return True after successfully bulk minting and transferring the
1056      * `nextTokenId` through `nextTokenId + amount` tokens to `account`.
1057      *
1058      * Emits a `Transfer` event (with `address(0)` as `from`) for each token
1059      * that is minted.
1060      *
1061      * Requirements:
1062      * - `account` cannot be the zero address.
1063      * @param account The account to receive the minted tokens.
1064      * @param amount The number of tokens to be minted.
1065      */
1066     function bulkMintToOneAddress(address account, uint256 amount)
1067         external
1068         returns (bool);
1069 
1070     /**
1071      * @return True after successfully bulk minting and transferring one of the
1072      * `nextTokenId` through `nextTokenId + accounts.length` tokens to each of
1073      * the addresses in `accounts`.
1074      *
1075      * Emits a `Transfer` event (with `address(0)` as `from`) for each token
1076      * that is minted.
1077      *
1078      * Requirements:
1079      * - `accounts` cannot have length 0.
1080      * - None of the addresses in `accounts` can be the zero address.
1081      * @param accounts The accounts to receive the minted tokens.
1082      */
1083     function bulkMintToNAddresses(address[] calldata accounts)
1084         external
1085         returns (bool);
1086 
1087     /**
1088      * @return True after successfully burning `tokenId`.
1089      *
1090      * Emits a `Transfer` event with `address(0)` as `to`.
1091      *
1092      * Requirements:
1093      * - The caller must either own or be approved to spend the `tokenId` token.
1094      * - `tokenId` must exist.
1095      * @param tokenId The tokenId to be burned.
1096      */
1097     function redeem(uint256 tokenId) external returns (bool);
1098 
1099     // controllerRedeem() and controllerTransfer() declared in IERC1644
1100 }
1101 
1102 /**
1103  * Interface for all functions in ERC721Collective, including inherited and
1104  * overridden functions
1105  */
1106 interface IERC721Collective is
1107     ITokenEnforceable,
1108     IERC721UpgradeableFork,
1109     IERC721CollectiveUnchained
1110 {
1111 
1112 }
1113 
1114 /// Mixin can be used by any module using an address that should be an
1115 /// ERC721Collective and needs to check if it indeed is one.
1116 abstract contract ERC165CheckerERC721Collective {
1117     /// Only proceed if collective implements IERC721Collective interface
1118     /// @param collective collective to check
1119     modifier onlyCollectiveInterface(address collective) {
1120         _checkCollectiveInterface(collective);
1121         _;
1122     }
1123 
1124     function _checkCollectiveInterface(address collective) internal view {
1125         require(
1126             ERC165Checker.supportsInterface(
1127                 collective,
1128                 type(IERC721Collective).interfaceId
1129             ),
1130             "ERC165CheckerERC721Collective: collective address does not implement proper interface"
1131         );
1132     }
1133 }
1134 
1135 /**
1136  * Factory for creating new Syndicate Collectives. The Collective token is
1137  * cloned from a default Collective address and implements default guards
1138  * and renderer.
1139  *
1140  * Copyright (c) 2021-present Syndicate Inc. All rights reserved.
1141  */
1142 contract ERC721CollectiveFactory is
1143     Ownable,
1144     Pausable,
1145     ERC165CheckerERC721Collective
1146 {
1147     address public collective;
1148     address public mintGuard;
1149     address public burnGuard;
1150     address public transferGuard;
1151     address public renderer;
1152 
1153     uint256 public creationFee;
1154 
1155     event ERC721CollectiveCreated(
1156         address indexed collective,
1157         string name,
1158         string symbol,
1159         bytes32 salt
1160     );
1161 
1162     event ERC721CollectiveFactoryImplementationsSet(
1163         address indexed collective,
1164         address mintGuard,
1165         address burnGuard,
1166         address transferGuard,
1167         address renderer
1168     );
1169 
1170     event CreationFeeUpdated(uint256 indexed creationFee);
1171 
1172     /**
1173      * Configure factory with owner and set default guard contracts
1174      * @param owner_ Address to make the factory owner
1175      * @param collective_ Address of the deployed ERC721Collective
1176      * token to be cloned
1177      * @param mintGuard_ Address of mint guard contract
1178      * @param burnGuard_ Address of burn guard contract
1179      * @param transferGuard_ Address of transfer guard contract
1180      * @param renderer_ Address of token renderer contract
1181      */
1182     constructor(
1183         address owner_,
1184         address collective_,
1185         address mintGuard_,
1186         address burnGuard_,
1187         address transferGuard_,
1188         address renderer_
1189     ) Ownable() Pausable() {
1190         setImplementations(
1191             collective_,
1192             mintGuard_,
1193             burnGuard_,
1194             transferGuard_,
1195             renderer_
1196         );
1197         transferOwnership(owner_);
1198     }
1199 
1200     /// Set creation fee
1201     /// @notice only the owner of the factory can set this
1202     /// @param creationFee_ creation fee in wei
1203     function setCreationFee(uint256 creationFee_) external onlyOwner {
1204         creationFee = creationFee_;
1205         emit CreationFeeUpdated(creationFee_);
1206     }
1207 
1208     /// Predict collective token address for given salt
1209     /// @param salt Salt for determinisitic clone
1210     /// @return token Address of token created with salt
1211     function predictAddress(bytes32 salt) external view returns (address) {
1212         return Clones.predictDeterministicAddress(collective, salt);
1213     }
1214 
1215     /**
1216      * Create a new Collective via Clone
1217      * @return token Address of new token
1218      * @param name Name of token
1219      * @param symbol Symbol of token
1220      * @param salt random salt for deterministic token creation
1221      * @param setupContracts array of contracts to setup
1222      * @param data array of bytes for setup contract calls
1223      */
1224     function create(
1225         string memory name,
1226         string memory symbol,
1227         bytes32 salt,
1228         address[] calldata setupContracts,
1229         bytes[] calldata data
1230     ) external payable whenNotPaused returns (address token) {
1231         if (creationFee > 0) {
1232             require(
1233                 msg.value == creationFee,
1234                 "ERC721CollectiveFactory: Must send correct amount for creation fee"
1235             );
1236             (bool sent, ) = payable(this.owner()).call{value: msg.value}("");
1237             require(
1238                 sent,
1239                 "ERC721CollectiveFactory: Failed to collect creation fee"
1240             );
1241         }
1242 
1243         token = _clone(name, symbol, salt);
1244 
1245         uint256 length = setupContracts.length;
1246         for (uint256 i; i < length; ) {
1247             // solhint-disable-next-line avoid-low-level-calls
1248             (bool sent, ) = setupContracts[i].call(data[i]);
1249             require(sent, "ERC721CollectiveFactory: Error making setup calls");
1250             unchecked {
1251                 ++i;
1252             }
1253         }
1254 
1255         Ownable(token).transferOwnership(msg.sender);
1256     }
1257 
1258     /**
1259      * Clone new CollectiveERC721 token
1260      * @return token Address of new token
1261      * @param name Name of token
1262      * @param symbol Symbol of token
1263      * @param salt random salt for deterministic token creation
1264      */
1265     function _clone(
1266         string memory name,
1267         string memory symbol,
1268         bytes32 salt
1269     ) internal whenNotPaused returns (address token) {
1270         token = Clones.cloneDeterministic(collective, salt);
1271 
1272         IERC721Collective(token).__ERC721Collective_init(
1273             name,
1274             symbol,
1275             mintGuard,
1276             burnGuard,
1277             transferGuard,
1278             renderer
1279         );
1280 
1281         emit ERC721CollectiveCreated(
1282             token,
1283             name,
1284             string(abi.encodePacked(unicode"✺", symbol)),
1285             salt
1286         );
1287     }
1288 
1289     /**
1290      * Set implementation addresses.
1291      *
1292      * Requirements:
1293      * - Only the owner can call this function.
1294      * - The `collective_` to clone must implement IERC721Collective.
1295      * - The guards and renderer cannot be address 0.
1296      * @param collective_ Address of the deployed ERC721Collective
1297      * implementation to be cloned
1298      * @param mintGuard_ Address of mint guard contract
1299      * @param burnGuard_ Address of burn guard contract
1300      * @param transferGuard_ Address of transfer guard contract
1301      * @param renderer_ Address of token renderer contract
1302      */
1303     function setImplementations(
1304         address collective_,
1305         address mintGuard_,
1306         address burnGuard_,
1307         address transferGuard_,
1308         address renderer_
1309     ) public onlyOwner onlyCollectiveInterface(collective_) {
1310         require(
1311             mintGuard_ != address(0) &&
1312                 burnGuard_ != address(0) &&
1313                 transferGuard_ != address(0) &&
1314                 renderer_ != address(0),
1315             "ERC721CollectiveFactory: implementations cannot be address(0)"
1316         );
1317 
1318         collective = collective_;
1319         mintGuard = mintGuard_;
1320         burnGuard = burnGuard_;
1321         transferGuard = transferGuard_;
1322         renderer = renderer_;
1323 
1324         emit ERC721CollectiveFactoryImplementationsSet(
1325             collective,
1326             mintGuard,
1327             burnGuard,
1328             transferGuard,
1329             renderer
1330         );
1331     }
1332 
1333     /**
1334      * Triggers paused state. Only accessible by the club owner.
1335      */
1336     function pause() external onlyOwner {
1337         _pause();
1338     }
1339 
1340     /**
1341      * Returns to normal state. Only accessible by the club owner.
1342      */
1343     function unpause() external onlyOwner {
1344         _unpause();
1345     }
1346 
1347     /**
1348      * This function is called for all messages sent to this contract (there
1349      * are no other functions). Sending Ether to this contract will cause an
1350      * exception, because the fallback function does not have the `payable`
1351      * modifier.
1352      * Source: https://docs.soliditylang.org/en/v0.8.9/contracts.html?highlight=fallback#fallback-function
1353      */
1354     fallback() external {
1355         revert("ERC721CollectiveFactory: non-existent function");
1356     }
1357 }