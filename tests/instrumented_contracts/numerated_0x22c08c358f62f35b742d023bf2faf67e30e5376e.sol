1 // SPDX-License-Identifier: AGPL-3.0-only
2 
3 pragma solidity >=0.8.0;
4 
5 /// @notice Modern, minimalist, and gas efficient ERC-721 implementation.
6 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC721.sol)
7 /// @dev Note that balanceOf does not revert if passed the zero address, in defiance of the ERC.
8 abstract contract ERC721 {
9     /*///////////////////////////////////////////////////////////////
10                                  EVENTS
11     //////////////////////////////////////////////////////////////*/
12 
13     event Transfer(address indexed from, address indexed to, uint256 indexed id);
14 
15     event Approval(address indexed owner, address indexed spender, uint256 indexed id);
16 
17     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
18 
19     /*///////////////////////////////////////////////////////////////
20                           METADATA STORAGE/LOGIC
21     //////////////////////////////////////////////////////////////*/
22 
23     string public name;
24 
25     string public symbol;
26 
27     function tokenURI(uint256 id) public view virtual returns (string memory);
28 
29     /*///////////////////////////////////////////////////////////////
30                             ERC721 STORAGE                        
31     //////////////////////////////////////////////////////////////*/
32 
33     mapping(address => uint256) public balanceOf;
34 
35     mapping(uint256 => address) public ownerOf;
36 
37     mapping(uint256 => address) public getApproved;
38 
39     mapping(address => mapping(address => bool)) public isApprovedForAll;
40 
41     /*///////////////////////////////////////////////////////////////
42                               CONSTRUCTOR
43     //////////////////////////////////////////////////////////////*/
44 
45     constructor(string memory _name, string memory _symbol) {
46         name = _name;
47         symbol = _symbol;
48     }
49 
50     /*///////////////////////////////////////////////////////////////
51                               ERC721 LOGIC
52     //////////////////////////////////////////////////////////////*/
53 
54     function approve(address spender, uint256 id) public virtual {
55         address owner = ownerOf[id];
56 
57         require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "NOT_AUTHORIZED");
58 
59         getApproved[id] = spender;
60 
61         emit Approval(owner, spender, id);
62     }
63 
64     function setApprovalForAll(address operator, bool approved) public virtual {
65         isApprovedForAll[msg.sender][operator] = approved;
66 
67         emit ApprovalForAll(msg.sender, operator, approved);
68     }
69 
70     function transferFrom(
71         address from,
72         address to,
73         uint256 id
74     ) public virtual {
75         require(from == ownerOf[id], "WRONG_FROM");
76 
77         require(to != address(0), "INVALID_RECIPIENT");
78 
79         require(
80             msg.sender == from || msg.sender == getApproved[id] || isApprovedForAll[from][msg.sender],
81             "NOT_AUTHORIZED"
82         );
83 
84         // Underflow of the sender's balance is impossible because we check for
85         // ownership above and the recipient's balance can't realistically overflow.
86         unchecked {
87             balanceOf[from]--;
88 
89             balanceOf[to]++;
90         }
91 
92         ownerOf[id] = to;
93 
94         delete getApproved[id];
95 
96         emit Transfer(from, to, id);
97     }
98 
99     function safeTransferFrom(
100         address from,
101         address to,
102         uint256 id
103     ) public virtual {
104         transferFrom(from, to, id);
105 
106         require(
107             to.code.length == 0 ||
108                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, "") ==
109                 ERC721TokenReceiver.onERC721Received.selector,
110             "UNSAFE_RECIPIENT"
111         );
112     }
113 
114     function safeTransferFrom(
115         address from,
116         address to,
117         uint256 id,
118         bytes memory data
119     ) public virtual {
120         transferFrom(from, to, id);
121 
122         require(
123             to.code.length == 0 ||
124                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, data) ==
125                 ERC721TokenReceiver.onERC721Received.selector,
126             "UNSAFE_RECIPIENT"
127         );
128     }
129 
130     /*///////////////////////////////////////////////////////////////
131                               ERC165 LOGIC
132     //////////////////////////////////////////////////////////////*/
133 
134     function supportsInterface(bytes4 interfaceId) public pure virtual returns (bool) {
135         return
136             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
137             interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
138             interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
139     }
140 
141     /*///////////////////////////////////////////////////////////////
142                        INTERNAL MINT/BURN LOGIC
143     //////////////////////////////////////////////////////////////*/
144 
145     function _mint(address to, uint256 id) internal virtual {
146         require(to != address(0), "INVALID_RECIPIENT");
147 
148         require(ownerOf[id] == address(0), "ALREADY_MINTED");
149 
150         // Counter overflow is incredibly unrealistic.
151         unchecked {
152             balanceOf[to]++;
153         }
154 
155         ownerOf[id] = to;
156 
157         emit Transfer(address(0), to, id);
158     }
159 
160     function _burn(uint256 id) internal virtual {
161         address owner = ownerOf[id];
162 
163         require(ownerOf[id] != address(0), "NOT_MINTED");
164 
165         // Ownership check above ensures no underflow.
166         unchecked {
167             balanceOf[owner]--;
168         }
169 
170         delete ownerOf[id];
171 
172         delete getApproved[id];
173 
174         emit Transfer(owner, address(0), id);
175     }
176 
177     /*///////////////////////////////////////////////////////////////
178                        INTERNAL SAFE MINT LOGIC
179     //////////////////////////////////////////////////////////////*/
180 
181     function _safeMint(address to, uint256 id) internal virtual {
182         _mint(to, id);
183 
184         require(
185             to.code.length == 0 ||
186                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, "") ==
187                 ERC721TokenReceiver.onERC721Received.selector,
188             "UNSAFE_RECIPIENT"
189         );
190     }
191 
192     function _safeMint(
193         address to,
194         uint256 id,
195         bytes memory data
196     ) internal virtual {
197         _mint(to, id);
198 
199         require(
200             to.code.length == 0 ||
201                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, data) ==
202                 ERC721TokenReceiver.onERC721Received.selector,
203             "UNSAFE_RECIPIENT"
204         );
205     }
206 }
207 
208 /// @notice A generic interface for a contract which properly accepts ERC721 tokens.
209 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC721.sol)
210 interface ERC721TokenReceiver {
211     function onERC721Received(
212         address operator,
213         address from,
214         uint256 id,
215         bytes calldata data
216     ) external returns (bytes4);
217 }
218 
219 
220 // File @rari-capital/solmate/src/tokens/ERC20.sol@v6.2.0
221 
222 
223 pragma solidity >=0.8.0;
224 
225 /// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
226 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC20.sol)
227 /// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
228 /// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
229 abstract contract ERC20 {
230     /*///////////////////////////////////////////////////////////////
231                                   EVENTS
232     //////////////////////////////////////////////////////////////*/
233 
234     event Transfer(address indexed from, address indexed to, uint256 amount);
235 
236     event Approval(address indexed owner, address indexed spender, uint256 amount);
237 
238     /*///////////////////////////////////////////////////////////////
239                              METADATA STORAGE
240     //////////////////////////////////////////////////////////////*/
241 
242     string public name;
243 
244     string public symbol;
245 
246     uint8 public immutable decimals;
247 
248     /*///////////////////////////////////////////////////////////////
249                               ERC20 STORAGE
250     //////////////////////////////////////////////////////////////*/
251 
252     uint256 public totalSupply;
253 
254     mapping(address => uint256) public balanceOf;
255 
256     mapping(address => mapping(address => uint256)) public allowance;
257 
258     /*///////////////////////////////////////////////////////////////
259                              EIP-2612 STORAGE
260     //////////////////////////////////////////////////////////////*/
261 
262     bytes32 public constant PERMIT_TYPEHASH =
263         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
264 
265     uint256 internal immutable INITIAL_CHAIN_ID;
266 
267     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
268 
269     mapping(address => uint256) public nonces;
270 
271     /*///////////////////////////////////////////////////////////////
272                                CONSTRUCTOR
273     //////////////////////////////////////////////////////////////*/
274 
275     constructor(
276         string memory _name,
277         string memory _symbol,
278         uint8 _decimals
279     ) {
280         name = _name;
281         symbol = _symbol;
282         decimals = _decimals;
283 
284         INITIAL_CHAIN_ID = block.chainid;
285         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
286     }
287 
288     /*///////////////////////////////////////////////////////////////
289                               ERC20 LOGIC
290     //////////////////////////////////////////////////////////////*/
291 
292     function approve(address spender, uint256 amount) public virtual returns (bool) {
293         allowance[msg.sender][spender] = amount;
294 
295         emit Approval(msg.sender, spender, amount);
296 
297         return true;
298     }
299 
300     function transfer(address to, uint256 amount) public virtual returns (bool) {
301         balanceOf[msg.sender] -= amount;
302 
303         // Cannot overflow because the sum of all user
304         // balances can't exceed the max uint256 value.
305         unchecked {
306             balanceOf[to] += amount;
307         }
308 
309         emit Transfer(msg.sender, to, amount);
310 
311         return true;
312     }
313 
314     function transferFrom(
315         address from,
316         address to,
317         uint256 amount
318     ) public virtual returns (bool) {
319         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
320 
321         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
322 
323         balanceOf[from] -= amount;
324 
325         // Cannot overflow because the sum of all user
326         // balances can't exceed the max uint256 value.
327         unchecked {
328             balanceOf[to] += amount;
329         }
330 
331         emit Transfer(from, to, amount);
332 
333         return true;
334     }
335 
336     /*///////////////////////////////////////////////////////////////
337                               EIP-2612 LOGIC
338     //////////////////////////////////////////////////////////////*/
339 
340     function permit(
341         address owner,
342         address spender,
343         uint256 value,
344         uint256 deadline,
345         uint8 v,
346         bytes32 r,
347         bytes32 s
348     ) public virtual {
349         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
350 
351         // Unchecked because the only math done is incrementing
352         // the owner's nonce which cannot realistically overflow.
353         unchecked {
354             bytes32 digest = keccak256(
355                 abi.encodePacked(
356                     "\x19\x01",
357                     DOMAIN_SEPARATOR(),
358                     keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
359                 )
360             );
361 
362             address recoveredAddress = ecrecover(digest, v, r, s);
363 
364             require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");
365 
366             allowance[recoveredAddress][spender] = value;
367         }
368 
369         emit Approval(owner, spender, value);
370     }
371 
372     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
373         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
374     }
375 
376     function computeDomainSeparator() internal view virtual returns (bytes32) {
377         return
378             keccak256(
379                 abi.encode(
380                     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
381                     keccak256(bytes(name)),
382                     keccak256("1"),
383                     block.chainid,
384                     address(this)
385                 )
386             );
387     }
388 
389     /*///////////////////////////////////////////////////////////////
390                        INTERNAL MINT/BURN LOGIC
391     //////////////////////////////////////////////////////////////*/
392 
393     function _mint(address to, uint256 amount) internal virtual {
394         totalSupply += amount;
395 
396         // Cannot overflow because the sum of all user
397         // balances can't exceed the max uint256 value.
398         unchecked {
399             balanceOf[to] += amount;
400         }
401 
402         emit Transfer(address(0), to, amount);
403     }
404 
405     function _burn(address from, uint256 amount) internal virtual {
406         balanceOf[from] -= amount;
407 
408         // Cannot underflow because a user's balance
409         // will never be larger than the total supply.
410         unchecked {
411             totalSupply -= amount;
412         }
413 
414         emit Transfer(from, address(0), amount);
415     }
416 }
417 
418 
419 // File @rari-capital/solmate/src/utils/SafeTransferLib.sol@v6.2.0
420 
421 
422 pragma solidity >=0.8.0;
423 
424 /// @notice Safe ETH and ERC20 transfer library that gracefully handles missing return values.
425 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/utils/SafeTransferLib.sol)
426 /// @author Modified from Gnosis (https://github.com/gnosis/gp-v2-contracts/blob/main/src/contracts/libraries/GPv2SafeERC20.sol)
427 /// @dev Use with caution! Some functions in this library knowingly create dirty bits at the destination of the free memory pointer.
428 library SafeTransferLib {
429     /*///////////////////////////////////////////////////////////////
430                             ETH OPERATIONS
431     //////////////////////////////////////////////////////////////*/
432 
433     function safeTransferETH(address to, uint256 amount) internal {
434         bool callStatus;
435 
436         assembly {
437             // Transfer the ETH and store if it succeeded or not.
438             callStatus := call(gas(), to, amount, 0, 0, 0, 0)
439         }
440 
441         require(callStatus, "ETH_TRANSFER_FAILED");
442     }
443 
444     /*///////////////////////////////////////////////////////////////
445                            ERC20 OPERATIONS
446     //////////////////////////////////////////////////////////////*/
447 
448     function safeTransferFrom(
449         ERC20 token,
450         address from,
451         address to,
452         uint256 amount
453     ) internal {
454         bool callStatus;
455 
456         assembly {
457             // Get a pointer to some free memory.
458             let freeMemoryPointer := mload(0x40)
459 
460             // Write the abi-encoded calldata to memory piece by piece:
461             mstore(freeMemoryPointer, 0x23b872dd00000000000000000000000000000000000000000000000000000000) // Begin with the function selector.
462             mstore(add(freeMemoryPointer, 4), and(from, 0xffffffffffffffffffffffffffffffffffffffff)) // Mask and append the "from" argument.
463             mstore(add(freeMemoryPointer, 36), and(to, 0xffffffffffffffffffffffffffffffffffffffff)) // Mask and append the "to" argument.
464             mstore(add(freeMemoryPointer, 68), amount) // Finally append the "amount" argument. No mask as it's a full 32 byte value.
465 
466             // Call the token and store if it succeeded or not.
467             // We use 100 because the calldata length is 4 + 32 * 3.
468             callStatus := call(gas(), token, 0, freeMemoryPointer, 100, 0, 0)
469         }
470 
471         require(didLastOptionalReturnCallSucceed(callStatus), "TRANSFER_FROM_FAILED");
472     }
473 
474     function safeTransfer(
475         ERC20 token,
476         address to,
477         uint256 amount
478     ) internal {
479         bool callStatus;
480 
481         assembly {
482             // Get a pointer to some free memory.
483             let freeMemoryPointer := mload(0x40)
484 
485             // Write the abi-encoded calldata to memory piece by piece:
486             mstore(freeMemoryPointer, 0xa9059cbb00000000000000000000000000000000000000000000000000000000) // Begin with the function selector.
487             mstore(add(freeMemoryPointer, 4), and(to, 0xffffffffffffffffffffffffffffffffffffffff)) // Mask and append the "to" argument.
488             mstore(add(freeMemoryPointer, 36), amount) // Finally append the "amount" argument. No mask as it's a full 32 byte value.
489 
490             // Call the token and store if it succeeded or not.
491             // We use 68 because the calldata length is 4 + 32 * 2.
492             callStatus := call(gas(), token, 0, freeMemoryPointer, 68, 0, 0)
493         }
494 
495         require(didLastOptionalReturnCallSucceed(callStatus), "TRANSFER_FAILED");
496     }
497 
498     function safeApprove(
499         ERC20 token,
500         address to,
501         uint256 amount
502     ) internal {
503         bool callStatus;
504 
505         assembly {
506             // Get a pointer to some free memory.
507             let freeMemoryPointer := mload(0x40)
508 
509             // Write the abi-encoded calldata to memory piece by piece:
510             mstore(freeMemoryPointer, 0x095ea7b300000000000000000000000000000000000000000000000000000000) // Begin with the function selector.
511             mstore(add(freeMemoryPointer, 4), and(to, 0xffffffffffffffffffffffffffffffffffffffff)) // Mask and append the "to" argument.
512             mstore(add(freeMemoryPointer, 36), amount) // Finally append the "amount" argument. No mask as it's a full 32 byte value.
513 
514             // Call the token and store if it succeeded or not.
515             // We use 68 because the calldata length is 4 + 32 * 2.
516             callStatus := call(gas(), token, 0, freeMemoryPointer, 68, 0, 0)
517         }
518 
519         require(didLastOptionalReturnCallSucceed(callStatus), "APPROVE_FAILED");
520     }
521 
522     /*///////////////////////////////////////////////////////////////
523                          INTERNAL HELPER LOGIC
524     //////////////////////////////////////////////////////////////*/
525 
526     function didLastOptionalReturnCallSucceed(bool callStatus) private pure returns (bool success) {
527         assembly {
528             // Get how many bytes the call returned.
529             let returnDataSize := returndatasize()
530 
531             // If the call reverted:
532             if iszero(callStatus) {
533                 // Copy the revert message into memory.
534                 returndatacopy(0, 0, returnDataSize)
535 
536                 // Revert with the same message.
537                 revert(0, returnDataSize)
538             }
539 
540             switch returnDataSize
541             case 32 {
542                 // Copy the return data into memory.
543                 returndatacopy(0, 0, returnDataSize)
544 
545                 // Set success to whether it returned true.
546                 success := iszero(iszero(mload(0)))
547             }
548             case 0 {
549                 // There was no return data.
550                 success := 1
551             }
552             default {
553                 // It returned some malformed input.
554                 success := 0
555             }
556         }
557     }
558 }
559 
560 
561 // File contracts/Ownable.sol
562 
563 
564 pragma solidity 0.8.10;
565 
566 error NotOwner();
567 
568 abstract contract Ownable {
569   address internal _owner;
570 
571   event OwnershipTransferred(
572     address indexed previousOwner,
573     address indexed newOwner
574   );
575 
576   constructor() {
577     _owner = msg.sender;
578   }
579 
580   function owner() external view returns (address) {
581     return _owner;
582   }
583 
584   function transferOwnership(address _newOwner) external {
585     if (msg.sender != _owner) revert NotOwner();
586 
587     _owner = _newOwner;
588   }
589 
590   function renounceOwnership() public {
591     if (msg.sender != _owner) revert NotOwner();
592 
593     _owner = address(0);
594   }
595 }
596 
597 
598 // File contracts/IERC721.sol
599 
600 
601 
602 pragma solidity 0.8.10;
603 
604 /**
605  * @dev Required interface of an ERC721 compliant contract.
606  */
607 interface IERC721 {
608   /**
609    * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
610    */
611   event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
612 
613   /**
614    * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
615    */
616   event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
617 
618   /**
619    * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
620    */
621   event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
622 
623   /**
624    * @dev Returns the number of tokens in ``owner``'s account.
625    */
626   function balanceOf(address owner) external view returns (uint256 balance);
627 
628   /**
629    * @dev Returns the owner of the `tokenId` token.
630    *
631    * Requirements:
632    *
633    * - `tokenId` must exist.
634    */
635   function ownerOf(uint256 tokenId) external view returns (address owner);
636 
637   /**
638    * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
639    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
640    *
641    * Requirements:
642    *
643    * - `from` cannot be the zero address.
644    * - `to` cannot be the zero address.
645    * - `tokenId` token must exist and be owned by `from`.
646    * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
647    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
648    *
649    * Emits a {Transfer} event.
650    */
651   function safeTransferFrom(
652     address from,
653     address to,
654     uint256 tokenId
655   ) external;
656 
657   /**
658    * @dev Transfers `tokenId` token from `from` to `to`.
659    *
660    * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
661    *
662    * Requirements:
663    *
664    * - `from` cannot be the zero address.
665    * - `to` cannot be the zero address.
666    * - `tokenId` token must be owned by `from`.
667    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
668    *
669    * Emits a {Transfer} event.
670    */
671   function transferFrom(
672     address from,
673     address to,
674     uint256 tokenId
675   ) external;
676 
677   /**
678    * @dev Gives permission to `to` to transfer `tokenId` token to another account.
679    * The approval is cleared when the token is transferred.
680    *
681    * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
682    *
683    * Requirements:
684    *
685    * - The caller must own the token or be an approved operator.
686    * - `tokenId` must exist.
687    *
688    * Emits an {Approval} event.
689    */
690   function approve(address to, uint256 tokenId) external;
691 
692   /**
693    * @dev Returns the account approved for `tokenId` token.
694    *
695    * Requirements:
696    *
697    * - `tokenId` must exist.
698    */
699   function getApproved(uint256 tokenId) external view returns (address operator);
700 
701   /**
702    * @dev Approve or remove `operator` as an operator for the caller.
703    * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
704    *
705    * Requirements:
706    *
707    * - The `operator` cannot be the caller.
708    *
709    * Emits an {ApprovalForAll} event.
710    */
711   function setApprovalForAll(address operator, bool _approved) external;
712 
713   /**
714    * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
715    *
716    * See {setApprovalForAll}
717    */
718   function isApprovedForAll(address owner, address operator) external view returns (bool);
719 
720   /**
721    * @dev Safely transfers `tokenId` token from `from` to `to`.
722    *
723    * Requirements:
724    *
725    * - `from` cannot be the zero address.
726    * - `to` cannot be the zero address.
727    * - `tokenId` token must exist and be owned by `from`.
728    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
729    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
730    *
731    * Emits a {Transfer} event.
732    */
733   function safeTransferFrom(
734     address from,
735     address to,
736     uint256 tokenId,
737     bytes calldata data
738   ) external;
739 
740   // Original 0xApes contract specifc
741   function getPhunksBelongingToOwner(address _owner) external view returns (uint256[] memory);
742 }
743 
744 
745 // File contracts/Strings.sol
746 
747 
748 pragma solidity 0.8.10;
749 
750 library Strings {
751     /**
752      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
753      */
754     function toString(uint256 value) internal pure returns (string memory) {
755         // Inspired by OraclizeAPI's implementation - MIT licence
756         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
757 
758         if (value == 0) {
759             return "0";
760         }
761         uint256 temp = value;
762         uint256 digits;
763         while (temp != 0) {
764             digits++;
765             temp /= 10;
766         }
767         bytes memory buffer = new bytes(digits);
768         while (value != 0) {
769             digits -= 1;
770             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
771             value /= 10;
772         }
773         return string(buffer);
774     }
775 }
776 
777 
778 // File contracts/Ape721.sol
779 
780 
781 pragma solidity 0.8.10;
782 error DoesNotExist();
783 error NoTokensLeft();
784 error NotEnoughETH();
785 error AssertionError();
786 error NotTokenOwner();
787 error MintNotActive();
788 error MintAlreadyActive();
789 error MintLimitPerTx();
790 
791 contract xApe721 is Ownable, ERC721 {
792   using Strings for uint256;
793 
794   uint256 public constant TOTAL_SUPPLY = 10_000;
795   uint256 public constant PRICE_PER_MINT = 0.05 ether;
796   uint256 public constant MAX_MINT_PER_TX = 20;
797 
798   bool public mintActive;
799 
800   uint256 public totalSupply;
801   uint256 internal nextMintableId = 10038; // IDs start at 10038
802 
803   string public baseURI;
804 
805   IERC721 public oldContract = IERC721(0x090b1DE324fEA5f0A0B4226101Db645819102629);
806   address private teamWallet = 0x26CDE90abDD4e41ECA2948d79fE383E8103678b5;
807 
808   constructor(
809     string memory name,
810     string memory symbol,
811     string memory _baseURI,
812     address _oldContract,
813     address[] memory recipients,
814     uint256[] memory tokens
815   ) payable ERC721(name, symbol) {
816     require(recipients.length == tokens.length, "Airdrop lengths");
817     baseURI = _baseURI;
818 
819     if (_oldContract != address(0)) {
820       oldContract = IERC721(_oldContract);
821     }
822 
823     uint256 length = tokens.length;
824 
825     for (uint i; i < length; ++i) {
826       _mint(recipients[i], tokens[i]);
827       totalSupply++;
828     }
829   }
830 
831   modifier onlyTeamWallet() {
832     require(msg.sender == teamWallet, "Not callable except by team wallet");
833     _;
834   }
835 
836   function mint(uint16 amount) external payable {
837     if (!mintActive) revert MintNotActive();
838     if (totalSupply + amount >= TOTAL_SUPPLY) revert NoTokensLeft();
839     if (msg.value < amount * PRICE_PER_MINT) revert NotEnoughETH();
840     if (amount > MAX_MINT_PER_TX) revert MintLimitPerTx();
841 
842     uint256 supply = totalSupply;
843 
844     unchecked {
845       for (uint16 index = 0; index < amount; index++) {
846         uint256 newId = _getNextUnusedID();
847         _mint(msg.sender, newId);
848         supply++;
849       }
850     }
851 
852     totalSupply = supply;
853   }
854 
855   function claim(uint256 tokenId) external payable {
856     if (_ownsOldToken(msg.sender, tokenId))  {
857       // Transfering into this contract effectively burns the old
858       // token as there is no way to get it out of here
859       oldContract.safeTransferFrom(msg.sender, address(this), tokenId);
860       _mint(msg.sender, tokenId);
861       totalSupply++;
862       return;
863     }
864     revert NotTokenOwner();
865   }
866 
867   function claimAll() external payable {
868     uint256[] memory ownedTokens = oldContract.getPhunksBelongingToOwner(msg.sender);
869     uint256 length = ownedTokens.length; // gas saving
870 
871     uint256 supply = totalSupply;
872 
873     for (uint256 i; i < length; ++i) {
874       if (ownerOf[ownedTokens[i]] == address(0)) {
875         // Has not been claimed yet
876 
877         // Transfering into this contract effectively burns the
878         // old token as there is no way to get it out of here
879         oldContract.safeTransferFrom(msg.sender, address(this), ownedTokens[i]);
880         _mint(msg.sender, ownedTokens[i]);
881         supply++;
882       }
883     }
884 
885     totalSupply = supply;
886   }
887 
888   function _ownsOldToken(address account, uint256 tokenId) internal view returns(bool) {
889     try oldContract.ownerOf(tokenId) returns (address tokenOwner) {
890       return account == tokenOwner;
891     } catch Error(string memory /*reason*/) {
892       return false;
893     }
894   }
895 
896   function _getNextUnusedID() internal returns (uint256) {
897     uint256 newId = nextMintableId;
898 
899     // Using 10 iterations instead of while loop as it is known
900     // that the maximum contiguous group of successive IDs in
901     // the original contract is 7 (14960-14966). Cannot have unbounded gas usage
902     for (uint256 i; i < 10; ++i) {
903       if (ownerOf[newId] != address(0)) {
904         // Token is owned in this contract
905         newId++;
906         continue;
907       }
908 
909       try oldContract.ownerOf(newId) returns (address) {
910         // Token is owned in the old contract
911         // ownerOf always reverts if the token isn't owned
912         // so no need for zero check here
913         newId++;
914         continue;
915       } catch Error(string memory /*reason*/) {
916         nextMintableId = newId + 1;
917         return newId;
918       }
919     }
920     revert AssertionError();
921   }
922 
923   function tokenURI(uint256 id) public view override returns (string memory) {
924     if (ownerOf[id] == address(0)) revert DoesNotExist();
925 
926     return string(abi.encodePacked(baseURI, id.toString()));
927   }
928 
929   function withdraw() external onlyTeamWallet() {
930     SafeTransferLib.safeTransferETH(teamWallet, address(this).balance);
931   }
932 
933   function pauseMint() external {
934     if (msg.sender != _owner) revert NotOwner();
935     if (!mintActive) revert MintNotActive();
936 
937     mintActive = false;
938   }
939 
940   function startMint() external {
941     if (msg.sender != _owner) revert NotOwner();
942     if (mintActive) revert MintAlreadyActive();
943 
944     mintActive = true;
945   }
946 
947   function setBaseURI(string memory _baseURI) external {
948     if (msg.sender != _owner) revert NotOwner();
949       baseURI = _baseURI;
950   }
951 
952   function supportsInterface(bytes4 interfaceId)
953     public
954     pure
955     override
956     returns (bool)
957   {
958     return
959       interfaceId == 0x7f5828d0 || // ERC165 Interface ID for ERC173
960       interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
961       interfaceId == 0x5b5e139f || // ERC165 Interface ID for ERC165
962       interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC721Metadata
963       interfaceId == 0x150b7a02;   // ERC721 Receiver
964   }
965 
966   function onERC721Received(
967       address operator,
968       address from,
969       uint256 tokenId,
970       bytes calldata data
971   ) external returns (bytes4) {
972       return 0x150b7a02;
973   }
974 }