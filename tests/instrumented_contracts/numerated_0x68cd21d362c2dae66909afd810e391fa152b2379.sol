1 // SPDX-License-Identifier: Unlicense
2 pragma solidity ^0.8.9;
3 
4 library AddressUtils {
5 
6   /**
7    * Returns whether the target address is a contract
8    * @dev This function will return false if invoked during the constructor of a contract,
9    * as the code is not actually created until after the constructor finishes.
10    * @param _addr address to check
11    * @return whether the target address is a contract
12    */
13   function isContract(address _addr) internal view returns (bool) {
14     uint256 size;
15     // XXX Currently there is no better way to check if there is a contract in an address
16     // than to check the size of the code at that address.
17     // See https://ethereum.stackexchange.com/a/14016/36603
18     // for more details about how this works.
19     // TODO Check this again before the Serenity release, because all addresses will be
20     // contracts then.
21     // solium-disable-next-line security/no-inline-assembly
22     assembly { size := extcodesize(_addr) }
23     return size > 0;
24   }
25 
26 }
27 
28 library MerkleProof {
29 function verify(
30     bytes32[] memory proof,
31     bytes32 root,
32     bytes32 leaf
33   )
34     internal
35     pure
36     returns (bool)
37   {
38     bytes32 computedHash = leaf;
39 
40     for (uint256 i = 0; i < proof.length; i++) {
41       bytes32 proofElement = proof[i];
42 
43       if (computedHash < proofElement) {
44         // Hash(current computed hash + current element of the proof)
45         computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
46       } else {
47         // Hash(current element of the proof + current computed hash)
48         computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
49       }
50     }
51 
52     // Check if the computed hash (root) is equal to the provided root
53     return computedHash == root;
54   }
55 }
56 
57 /**
58  * @dev Optional metadata extension for ERC-721 non-fungible token standard.
59  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
60  */
61 interface ERC721Metadata
62 {
63 
64   /**
65    * @dev Returns a descriptive name for a collection of NFTs in this contract.
66    * @return _name Representing name.
67    */
68   function name()
69     external
70     view
71     returns (string memory _name);
72 
73   /**
74    * @dev Returns a abbreviated name for a collection of NFTs in this contract.
75    * @return _symbol Representing symbol.
76    */
77   function symbol()
78     external
79     view
80     returns (string memory _symbol);
81 
82 }
83 
84 
85 /**
86  * @dev ERC-721 interface for accepting safe transfers.
87  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
88  */
89 interface ERC721TokenReceiver
90 {
91 
92   /**
93    * @notice The contract address is always the message sender. A wallet/broker/auction application
94    * MUST implement the wallet interface if it will accept safe transfers.
95    * @dev Handle the receipt of a NFT. The ERC721 smart contract calls this function on the
96    * recipient after a `transfer`. This function MAY throw to revert and reject the transfer. Return
97    * of other than the magic value MUST result in the transaction being reverted.
98    * Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))` unless throwing.
99    * @param _operator The address which called `safeTransferFrom` function.
100    * @param _from The address which previously owned the token.
101    * @param _tokenId The NFT identifier which is being transferred.
102    * @param _data Additional data with no specified format.
103    * @return Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
104    */
105   function onERC721Received(
106     address _operator,
107     address _from,
108     uint256 _tokenId,
109     bytes calldata _data
110   )
111     external
112     returns(bytes4);
113 
114 }
115 
116 
117 /**
118  * @dev ERC-721 non-fungible token standard.
119  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
120  */
121 interface ERC721
122 {
123 
124   /**
125    * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
126    * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
127    * number of NFTs may be created and assigned without emitting Transfer. At the time of any
128    * transfer, the approved address for that NFT (if any) is reset to none.
129    */
130   event Transfer(
131     address indexed _from,
132     address indexed _to,
133     uint256 indexed _tokenId
134   );
135 
136   /**
137    * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
138    * address indicates there is no approved address. When a Transfer event emits, this also
139    * indicates that the approved address for that NFT (if any) is reset to none.
140    */
141   event Approval(
142     address indexed _owner,
143     address indexed _approved,
144     uint256 indexed _tokenId
145   );
146 
147   /**
148    * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
149    * all NFTs of the owner.
150    */
151   event ApprovalForAll(
152     address indexed _owner,
153     address indexed _operator,
154     bool _approved
155   );
156 
157   /**
158    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
159    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
160    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
161    * function checks if `_to` is a smart contract (code size > 0). If so, it calls
162    * `onERC721Received` on `_to` and throws if the return value is not
163    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
164    * @dev Transfers the ownership of an NFT from one address to another address. This function can
165    * be changed to payable.
166    * @param _from The current owner of the NFT.
167    * @param _to The new owner.
168    * @param _tokenId The NFT to transfer.
169    * @param _data Additional data with no specified format, sent in call to `_to`.
170    */
171   function safeTransferFrom(
172     address _from,
173     address _to,
174     uint256 _tokenId,
175     bytes calldata _data
176   )
177     external;
178 
179   /**
180    * @notice This works identically to the other function with an extra data parameter, except this
181    * function just sets data to ""
182    * @dev Transfers the ownership of an NFT from one address to another address. This function can
183    * be changed to payable.
184    * @param _from The current owner of the NFT.
185    * @param _to The new owner.
186    * @param _tokenId The NFT to transfer.
187    */
188   function safeTransferFrom(
189     address _from,
190     address _to,
191     uint256 _tokenId
192   )
193     external;
194 
195   /**
196    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
197    * they may be permanently lost.
198    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
199    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
200    * address. Throws if `_tokenId` is not a valid NFT.  This function can be changed to payable.
201    * @param _from The current owner of the NFT.
202    * @param _to The new owner.
203    * @param _tokenId The NFT to transfer.
204    */
205   function transferFrom(
206     address _from,
207     address _to,
208     uint256 _tokenId
209   )
210     external;
211 
212   /**
213    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
214    * the current NFT owner, or an authorized operator of the current owner.
215    * @param _approved The new approved NFT controller.
216    * @dev Set or reaffirm the approved address for an NFT. This function can be changed to payable.
217    * @param _tokenId The NFT to approve.
218    */
219   function approve(
220     address _approved,
221     uint256 _tokenId
222   )
223     external;
224 
225   /**
226    * @notice The contract MUST allow multiple operators per owner.
227    * @dev Enables or disables approval for a third party ("operator") to manage all of
228    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
229    * @param _operator Address to add to the set of authorized operators.
230    * @param _approved True if the operators is approved, false to revoke approval.
231    */
232   function setApprovalForAll(
233     address _operator,
234     bool _approved
235   )
236     external;
237 
238   /**
239    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
240    * considered invalid, and this function throws for queries about the zero address.
241    * @notice Count all NFTs assigned to an owner.
242    * @param _owner Address for whom to query the balance.
243    * @return Balance of _owner.
244    */
245   function balanceOf(
246     address _owner
247   )
248     external
249     view
250     returns (uint256);
251 
252   /**
253    * @notice Find the owner of an NFT.
254    * @dev Returns the address of the owner of the NFT. NFTs assigned to the zero address are
255    * considered invalid, and queries about them do throw.
256    * @param _tokenId The identifier for an NFT.
257    * @return Address of _tokenId owner.
258    */
259   function ownerOf(
260     uint256 _tokenId
261   )
262     external
263     view
264     returns (address);
265 
266   /**
267    * @notice Throws if `_tokenId` is not a valid NFT.
268    * @dev Get the approved address for a single NFT.
269    * @param _tokenId The NFT to find the approved address for.
270    * @return Address that _tokenId is approved for.
271    */
272   function getApproved(
273     uint256 _tokenId
274   )
275     external
276     view
277     returns (address);
278 
279   /**
280    * @notice Query if an address is an authorized operator for another address.
281    * @dev Returns true if `_operator` is an approved operator for `_owner`, false otherwise.
282    * @param _owner The address that owns the NFTs.
283    * @param _operator The address that acts on behalf of the owner.
284    * @return True if approved for all, false otherwise.
285    */
286   function isApprovedForAll(
287     address _owner,
288     address _operator
289   )
290     external
291     view
292     returns (bool);
293 
294 }
295 
296 
297 /**
298  * @dev A standard for detecting smart contract interfaces. 
299  * See: https://eips.ethereum.org/EIPS/eip-165.
300  */
301 interface ERC165
302 {
303 
304   /**
305    * @dev Checks if the smart contract includes a specific interface.
306    * This function uses less than 30,000 gas.
307    * @param _interfaceID The interface identifier, as specified in ERC-165.
308    * @return True if _interfaceID is supported, false otherwise.
309    */
310   function supportsInterface(
311     bytes4 _interfaceID
312   )
313     external
314     view
315     returns (bool);
316     
317 }
318 
319 
320 /**
321  * @dev Implementation of standard for detect smart contract interfaces.
322  */
323 contract SupportsInterface is
324   ERC165
325 {
326 
327   /**
328    * @dev Mapping of supported intefraces. You must not set element 0xffffffff to true.
329    */
330   mapping(bytes4 => bool) internal supportedInterfaces;
331 
332   /**
333    * @dev Contract constructor.
334    */
335   constructor()
336   {
337     supportedInterfaces[0x01ffc9a7] = true; // ERC165
338   }
339 
340   /**
341    * @dev Function to check which interfaces are suported by this contract.
342    * @param _interfaceID Id of the interface.
343    * @return True if _interfaceID is supported, false otherwise.
344    */
345   function supportsInterface(
346     bytes4 _interfaceID
347   )
348     external
349     override
350     view
351     returns (bool)
352   {
353     return supportedInterfaces[_interfaceID];
354   }
355 
356 }
357 
358 /**
359  * @dev The contract has an owner address, and provides basic authorization control whitch
360  * simplifies the implementation of user permissions. This contract is based on the source code at:
361  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
362  */
363 contract Ownable
364 {
365 
366   /**
367    * @dev Error constants.
368    */
369   string public constant NOT_CURRENT_OWNER = "018001";
370   string public constant CANNOT_TRANSFER_TO_ZERO_ADDRESS = "018002";
371 
372   /**
373    * @dev Current owner address.
374    */
375   address public owner;
376 
377   /**
378    * @dev An event which is triggered when the owner is changed.
379    * @param previousOwner The address of the previous owner.
380    * @param newOwner The address of the new owner.
381    */
382   event OwnershipTransferred(
383     address indexed previousOwner,
384     address indexed newOwner
385   );
386 
387   /**
388    * @dev The constructor sets the original `owner` of the contract to the sender account.
389    */
390   constructor()
391   {
392     owner = msg.sender;
393   }
394 
395   /**
396    * @dev Throws if called by any account other than the owner.
397    */
398   modifier onlyOwner()
399   {
400     require(msg.sender == owner, NOT_CURRENT_OWNER);
401     _;
402   }
403 
404   /**
405    * @dev Allows the current owner to transfer control of the contract to a newOwner.
406    * @param _newOwner The address to transfer ownership to.
407    */
408   function transferOwnership(
409     address _newOwner
410   )
411     public
412     onlyOwner
413   {
414     require(_newOwner != address(0), CANNOT_TRANSFER_TO_ZERO_ADDRESS);
415     emit OwnershipTransferred(owner, _newOwner);
416     owner = _newOwner;
417   }
418 
419 }
420 
421 
422 /**
423  * @dev Implementation of ERC-721 non-fungible token standard.
424  */
425 contract NFToken is
426   ERC721,
427   SupportsInterface
428 {
429   using AddressUtils for address;
430 
431   /**
432    * @dev List of revert message codes. Implementing dApp should handle showing the correct message.
433    * Based on 0xcert framework error codes.
434    */
435   string constant ZERO_ADDRESS = "003001";
436   string constant NOT_VALID_NFT = "003002";
437   string constant NOT_OWNER_OR_OPERATOR = "003003";
438   string constant NOT_OWNER_APPROVED_OR_OPERATOR = "003004";
439   string constant NOT_ABLE_TO_RECEIVE_NFT = "003005";
440   string constant NFT_ALREADY_EXISTS = "003006";
441   string constant NOT_OWNER = "003007";
442   string constant IS_OWNER = "003008";
443 
444   /**
445    * @dev Magic value of a smart contract that can receive NFT.
446    * Equal to: bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")).
447    */
448   bytes4 internal constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
449 
450   /**
451    * @dev A mapping from NFT ID to the address that owns it.
452    */
453   mapping (uint256 => address) internal idToOwner;
454 
455   /**
456    * @dev Mapping from NFT ID to approved address.
457    */
458   mapping (uint256 => address) internal idToApproval;
459 
460    /**
461    * @dev Mapping from owner address to count of their tokens.
462    */
463   mapping (address => uint256) private ownerToNFTokenCount;
464 
465   /**
466    * @dev Mapping from owner address to mapping of operator addresses.
467    */
468   mapping (address => mapping (address => bool)) internal ownerToOperators;
469 
470   /**
471    * @dev Guarantees that the msg.sender is an owner or operator of the given NFT.
472    * @param _tokenId ID of the NFT to validate.
473    */
474   modifier canOperate(
475     uint256 _tokenId
476   )
477   {
478     address tokenOwner = idToOwner[_tokenId];
479     require(
480       tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender],
481       NOT_OWNER_OR_OPERATOR
482     );
483     _;
484   }
485 
486   /**
487    * @dev Guarantees that the msg.sender is allowed to transfer NFT.
488    * @param _tokenId ID of the NFT to transfer.
489    */
490   modifier canTransfer(
491     uint256 _tokenId
492   )
493   {
494     address tokenOwner = idToOwner[_tokenId];
495     require(
496       tokenOwner == msg.sender
497       || idToApproval[_tokenId] == msg.sender
498       || ownerToOperators[tokenOwner][msg.sender],
499       NOT_OWNER_APPROVED_OR_OPERATOR
500     );
501     _;
502   }
503 
504   /**
505    * @dev Guarantees that _tokenId is a valid Token.
506    * @param _tokenId ID of the NFT to validate.
507    */
508   modifier validNFToken(
509     uint256 _tokenId
510   )
511   {
512     require(idToOwner[_tokenId] != address(0), NOT_VALID_NFT);
513     _;
514   }
515 
516   /**
517    * @dev Contract constructor.
518    */
519   constructor()
520   {
521     supportedInterfaces[0x80ac58cd] = true; // ERC721
522   }
523 
524   /**
525    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
526    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
527    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
528    * function checks if `_to` is a smart contract (code size > 0). If so, it calls
529    * `onERC721Received` on `_to` and throws if the return value is not
530    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
531    * @dev Transfers the ownership of an NFT from one address to another address. This function can
532    * be changed to payable.
533    * @param _from The current owner of the NFT.
534    * @param _to The new owner.
535    * @param _tokenId The NFT to transfer.
536    * @param _data Additional data with no specified format, sent in call to `_to`.
537    */
538   function safeTransferFrom(
539     address _from,
540     address _to,
541     uint256 _tokenId,
542     bytes calldata _data
543   )
544     external
545     override
546   {
547     _safeTransferFrom(_from, _to, _tokenId, _data);
548   }
549 
550   /**
551    * @notice This works identically to the other function with an extra data parameter, except this
552    * function just sets data to "".
553    * @dev Transfers the ownership of an NFT from one address to another address. This function can
554    * be changed to payable.
555    * @param _from The current owner of the NFT.
556    * @param _to The new owner.
557    * @param _tokenId The NFT to transfer.
558    */
559   function safeTransferFrom(
560     address _from,
561     address _to,
562     uint256 _tokenId
563   )
564     external
565     override
566   {
567     _safeTransferFrom(_from, _to, _tokenId, "");
568   }
569 
570   /**
571    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
572    * they may be permanently lost.
573    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
574    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
575    * address. Throws if `_tokenId` is not a valid NFT. This function can be changed to payable.
576    * @param _from The current owner of the NFT.
577    * @param _to The new owner.
578    * @param _tokenId The NFT to transfer.
579    */
580   function transferFrom(
581     address _from,
582     address _to,
583     uint256 _tokenId
584   )
585     external
586     override
587     canTransfer(_tokenId)
588     validNFToken(_tokenId)
589   {
590     address tokenOwner = idToOwner[_tokenId];
591     require(tokenOwner == _from, NOT_OWNER);
592     require(_to != address(0), ZERO_ADDRESS);
593 
594     _transfer(_to, _tokenId);
595   }
596 
597   /**
598    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
599    * the current NFT owner, or an authorized operator of the current owner.
600    * @dev Set or reaffirm the approved address for an NFT. This function can be changed to payable.
601    * @param _approved Address to be approved for the given NFT ID.
602    * @param _tokenId ID of the token to be approved.
603    */
604   function approve(
605     address _approved,
606     uint256 _tokenId
607   )
608     external
609     override
610     canOperate(_tokenId)
611     validNFToken(_tokenId)
612   {
613     address tokenOwner = idToOwner[_tokenId];
614     require(_approved != tokenOwner, IS_OWNER);
615 
616     idToApproval[_tokenId] = _approved;
617     emit Approval(tokenOwner, _approved, _tokenId);
618   }
619 
620   /**
621    * @notice This works even if sender does not own any tokens at the time.
622    * @dev Enables or disables approval for a third party ("operator") to manage all of
623    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
624    * @param _operator Address to add to the set of authorized operators.
625    * @param _approved True if the operators is approved, false to revoke approval.
626    */
627   function setApprovalForAll(
628     address _operator,
629     bool _approved
630   )
631     external
632     override
633   {
634     ownerToOperators[msg.sender][_operator] = _approved;
635     emit ApprovalForAll(msg.sender, _operator, _approved);
636   }
637 
638   /**
639    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
640    * considered invalid, and this function throws for queries about the zero address.
641    * @param _owner Address for whom to query the balance.
642    * @return Balance of _owner.
643    */
644   function balanceOf(
645     address _owner
646   )
647     external
648     override
649     view
650     returns (uint256)
651   {
652     require(_owner != address(0), ZERO_ADDRESS);
653     return _getOwnerNFTCount(_owner);
654   }
655 
656   /**
657    * @dev Returns the address of the owner of the NFT. NFTs assigned to the zero address are
658    * considered invalid, and queries about them do throw.
659    * @param _tokenId The identifier for an NFT.
660    * @return _owner Address of _tokenId owner.
661    */
662   function ownerOf(
663     uint256 _tokenId
664   )
665     external
666     override
667     view
668     returns (address _owner)
669   {
670     _owner = idToOwner[_tokenId];
671     require(_owner != address(0), NOT_VALID_NFT);
672   }
673   
674   function ownerOfInternal(
675     uint256 _tokenId
676   )
677     internal
678     view
679     returns (address _owner)
680   {
681     _owner = idToOwner[_tokenId];
682     require(_owner != address(0), NOT_VALID_NFT);
683   }
684 
685   /**
686    * @notice Throws if `_tokenId` is not a valid NFT.
687    * @dev Get the approved address for a single NFT.
688    * @param _tokenId ID of the NFT to query the approval of.
689    * @return Address that _tokenId is approved for.
690    */
691   function getApproved(
692     uint256 _tokenId
693   )
694     external
695     override
696     view
697     validNFToken(_tokenId)
698     returns (address)
699   {
700     return idToApproval[_tokenId];
701   }
702 
703   /**
704    * @dev Checks if `_operator` is an approved operator for `_owner`.
705    * @param _owner The address that owns the NFTs.
706    * @param _operator The address that acts on behalf of the owner.
707    * @return True if approved for all, false otherwise.
708    */
709   function isApprovedForAll(
710     address _owner,
711     address _operator
712   )
713     external
714     override
715     view
716     returns (bool)
717   {
718     return ownerToOperators[_owner][_operator];
719   }
720 
721   /**
722    * @notice Does NO checks.
723    * @dev Actually performs the transfer.
724    * @param _to Address of a new owner.
725    * @param _tokenId The NFT that is being transferred.
726    */
727   function _transfer(
728     address _to,
729     uint256 _tokenId
730   )
731     internal
732   {
733     address from = idToOwner[_tokenId];
734     _clearApproval(_tokenId);
735 
736     _removeNFToken(from, _tokenId);
737     _addNFToken(_to, _tokenId);
738 
739     emit Transfer(from, _to, _tokenId);
740   }
741 
742   /**
743    * @notice This is an internal function which should be called from user-implemented external
744    * mint function. Its purpose is to show and properly initialize data structures when using this
745    * implementation.
746    * @dev Mints a new NFT.
747    * @param _to The address that will own the minted NFT.
748    * @param _tokenId of the NFT to be minted by the msg.sender.
749    */
750   function _mint(
751     address _to,
752     uint256 _tokenId
753   )
754     internal
755     virtual
756   {
757     require(_to != address(0), ZERO_ADDRESS);
758     require(idToOwner[_tokenId] == address(0), NFT_ALREADY_EXISTS);
759 
760     _addNFToken(_to, _tokenId);
761 
762     emit Transfer(address(0), _to, _tokenId);
763   }
764 
765   /**
766    * @notice This is an internal function which should be called from user-implemented external burn
767    * function. Its purpose is to show and properly initialize data structures when using this
768    * implementation. Also, note that this burn implementation allows the minter to re-mint a burned
769    * NFT.
770    * @dev Burns a NFT.
771    * @param _tokenId ID of the NFT to be burned.
772    */
773   function _burn(
774     uint256 _tokenId
775   )
776     internal
777     virtual
778     validNFToken(_tokenId)
779   {
780     address tokenOwner = idToOwner[_tokenId];
781     _clearApproval(_tokenId);
782     _removeNFToken(tokenOwner, _tokenId);
783     emit Transfer(tokenOwner, address(0), _tokenId);
784   }
785 
786   /**
787    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
788    * @dev Removes a NFT from owner.
789    * @param _from Address from which we want to remove the NFT.
790    * @param _tokenId Which NFT we want to remove.
791    */
792   function _removeNFToken(
793     address _from,
794     uint256 _tokenId
795   )
796     internal
797     virtual
798   {
799     require(idToOwner[_tokenId] == _from, NOT_OWNER);
800     ownerToNFTokenCount[_from] -= 1;
801     delete idToOwner[_tokenId];
802   }
803 
804   /**
805    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
806    * @dev Assigns a new NFT to owner.
807    * @param _to Address to which we want to add the NFT.
808    * @param _tokenId Which NFT we want to add.
809    */
810   function _addNFToken(
811     address _to,
812     uint256 _tokenId
813   )
814     internal
815     virtual
816   {
817     require(idToOwner[_tokenId] == address(0), NFT_ALREADY_EXISTS);
818 
819     idToOwner[_tokenId] = _to;
820     ownerToNFTokenCount[_to] += 1;
821   }
822 
823   /**
824    * @dev Helper function that gets NFT count of owner. This is needed for overriding in enumerable
825    * extension to remove double storage (gas optimization) of owner NFT count.
826    * @param _owner Address for whom to query the count.
827    * @return Number of _owner NFTs.
828    */
829   function _getOwnerNFTCount(
830     address _owner
831   )
832     internal
833     virtual
834     view
835     returns (uint256)
836   {
837     return ownerToNFTokenCount[_owner];
838   }
839 
840   /**
841    * @dev Actually perform the safeTransferFrom.
842    * @param _from The current owner of the NFT.
843    * @param _to The new owner.
844    * @param _tokenId The NFT to transfer.
845    * @param _data Additional data with no specified format, sent in call to `_to`.
846    */
847   function _safeTransferFrom(
848     address _from,
849     address _to,
850     uint256 _tokenId,
851     bytes memory _data
852   )
853     private
854     canTransfer(_tokenId)
855     validNFToken(_tokenId)
856   {
857     address tokenOwner = idToOwner[_tokenId];
858     require(tokenOwner == _from, NOT_OWNER);
859     require(_to != address(0), ZERO_ADDRESS);
860 
861     _transfer(_to, _tokenId);
862 
863     if (_to.isContract())
864     {
865       bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
866       require(retval == MAGIC_ON_ERC721_RECEIVED, NOT_ABLE_TO_RECEIVE_NFT);
867     }
868   }
869 
870   /**
871    * @dev Clears the current approval of a given NFT ID.
872    * @param _tokenId ID of the NFT to be transferred.
873    */
874   function _clearApproval(
875     uint256 _tokenId
876   )
877     private
878   {
879     delete idToApproval[_tokenId];
880   }
881 
882 }
883 
884 
885 
886 /**
887  * @dev Optional metadata implementation for ERC-721 non-fungible token standard.
888  */
889 contract NFTokenMetadata is
890   NFToken,
891   ERC721Metadata
892 {
893 
894   /**
895    * @dev A descriptive name for a collection of NFTs.
896    */
897   string internal nftName;
898 
899   /**
900    * @dev An abbreviated name for NFTokens.
901    */
902   string internal nftSymbol;
903 
904 
905   /**
906    * @notice When implementing this contract don't forget to set nftName and nftSymbol.
907    * @dev Contract constructor.
908    */
909   constructor()
910   {
911     supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
912   }
913 
914   /**
915    * @dev Returns a descriptive name for a collection of NFTokens.
916    * @return _name Representing name.
917    */
918   function name()
919     external
920     override
921     view
922     returns (string memory _name)
923   {
924     _name = nftName;
925   }
926 
927   /**
928    * @dev Returns an abbreviated name for NFTokens.
929    * @return _symbol Representing symbol.
930    */
931   function symbol()
932     external
933     override
934     view
935     returns (string memory _symbol)
936   {
937     _symbol = nftSymbol;
938   }
939 
940   /**
941    * @dev A distinct URI (RFC 3986) for a given NFT.
942    * @param _tokenId Id for which we want uri.
943    * @return URI of _tokenId.
944    */
945 
946 
947 }
948 
949 // OmegaM
950 
951 contract AnimeMetaverse is NFTokenMetadata, Ownable 
952 {
953     // Properties
954     address payable feeAddress;
955 
956     // OmegaM
957     uint constant public nftPrice = 0.25 ether;
958     uint constant public maxNft   = 5000;   // Total nfts
959     
960     // Switches
961     bool public isMintingActive     = false;  // Is minting open? Yes or no.
962     bool public isWhiteListActive   = false;  // Is the public sale open or is it only whitelisted?
963     bool public isMerkleActive      = true;   // OmegaM
964 
965     // Mappings 
966     mapping(address => bool) private    whiteList; // Map of addresses on the whitelist.
967     mapping(address => uint256) public  nftClaimed; // Map of how many nfts are minted per address.
968 
969     // Vars
970     uint256 public current_minted = 0;
971     // OmegaM
972     uint public mintLimit = 1;
973     
974     // URI Data
975     // OmegaM
976     string private metaAddress = "https://mint.animemetaverse.ai/metadata/";
977     string constant private jsonAppend = ".json";
978 
979     // Events
980     event Minted(address sender, uint256 count);
981 
982     // Merkle tree support
983 
984     bytes32 public merkleRoot;
985 
986     constructor()
987     {
988         // OmegaM
989         nftName     = "Anime Metaverse: Soulmates";
990         nftSymbol   = "AMS";
991         feeAddress  = payable(msg.sender);
992     }
993 
994     function tokenURI(uint tokenID) external view returns (string memory)
995     {   // @dev Token URIs are generated dynamically on view requests. 
996         // This is to allow easy server changes and reduce gas fees for minting. -ssa2
997         require(tokenID > 0, "Token does not exist.");
998         require(tokenID <= current_minted, "Token hasn't been minted yet.");
999 
1000         bytes32 thisToken;
1001         bytes memory concat;
1002         thisToken = uintToBytes(tokenID);
1003         concat = abi.encodePacked(metaAddress, thisToken, jsonAppend);
1004         return string(concat);
1005     }
1006 
1007     function setMerkleRoot (bytes32 merkle) external onlyOwner {
1008       require(merkle[0] != 0, "merkle root value is invalid");
1009 
1010         merkleRoot = merkle;
1011     }
1012 
1013 
1014     // Toggle whether any gals can be minted at all.
1015     function toggleMinting() public onlyOwner
1016     {
1017         isMintingActive = !isMintingActive;
1018     }
1019 
1020     // Toggle if we're in the Whitelist or Public Sale.
1021     function toggleWhiteList() public onlyOwner
1022     {
1023         isWhiteListActive = !isWhiteListActive;
1024     }
1025 
1026     function toggleMerkle () public onlyOwner {
1027       isMerkleActive = !isMerkleActive;      
1028     }
1029 
1030     // Add a list of wallet addresses to the Whitelist.
1031     function addToWhiteList(address[] calldata addresses) external onlyOwner {
1032         for (uint256 i = 0; i < addresses.length; i++) {
1033             require(addresses[i] != address(0), "Cannot add the null address");
1034 
1035             whiteList[addresses[i]] = true;
1036         }
1037     }
1038 
1039     // Tells the world if a given address is whitelisted or not.
1040     function onWhiteList(address addr) external view returns (bool) {
1041         return whiteList[addr];
1042     }
1043 
1044     // }:)
1045     function removeFromwhiteList(address[] calldata addresses) external onlyOwner {
1046         for (uint256 i = 0; i < addresses.length; i++) {
1047             require(addresses[i] != address(0), "Cant add null address");
1048 
1049             whiteList[addresses[i]] = false;
1050         }
1051     }
1052 
1053     // Public annoucement how many nfts a given address has minted.
1054     function claimedBy(address owner) external view returns (uint256) {
1055         require(owner != address(0), 'The zero address cannot mint anything.');
1056 
1057         return nftClaimed[owner];
1058     }
1059 
1060     // Address  ETH gets sent to when withdrawing.
1061     function updateRecipient(address payable _newAddress) public onlyOwner
1062     {
1063         feeAddress = _newAddress;
1064     }
1065 
1066     // Takes care of converting an integer into the raw bytes of it's abi-encodable string.
1067     function uintToBytes(uint v) private pure returns (bytes32 ret) {
1068         if (v == 0)
1069         {
1070             ret = '0';
1071         }
1072         else
1073         {
1074             while (v > 0) 
1075             {
1076                 ret = bytes32(uint(ret) / (2 ** 8));
1077                 ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
1078                 v /= 10;
1079             }
1080         }
1081         return ret;
1082     }
1083 
1084     function verify(bytes32[] calldata proof)
1085         public
1086         view
1087         returns (bool)
1088     {
1089         require(merkleRoot[0] != 0, "merkle root not set");
1090         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1091         return MerkleProof.verify(proof, merkleRoot, leaf);
1092     }
1093 
1094     // Public Sale minting function
1095     function mint(uint8 _mintNum, bytes32[] calldata _proof) public payable
1096     {
1097         require(isMintingActive, "Minting not available yet or paused for next round");
1098         require(_mintNum > 0, "At least one art is needed");
1099         require(_mintNum + nftClaimed[msg.sender] <= mintLimit, "Can't mint more than 1 limit per Wallet.");
1100         require(msg.value >= nftPrice * _mintNum, "NFTs are expensive, need more ETH to afford that.");
1101         require(current_minted + _mintNum <= maxNft, "Not enough of those left in stock.");
1102         require(_proof.length <= 10, "Invalid proof");
1103         
1104         if (isMerkleActive)
1105         {
1106             require(verify(_proof), "Not in the Merkle tree, only for exclusive invitees");
1107         }
1108 
1109         if(isWhiteListActive)
1110         {
1111             require(whiteList[msg.sender], "Only for exclusive invitees...");
1112         }
1113 
1114         for(uint i = 0; i < _mintNum; i++)
1115         {
1116             current_minted += 1;
1117             super._mint(msg.sender, current_minted);
1118             nftClaimed[msg.sender] += 1;
1119         }
1120 
1121         emit Minted(msg.sender, _mintNum);
1122     }
1123 
1124     // Emergency Devmint function if something gets messed up.
1125     function devMint(uint8 _mintNum) external onlyOwner 
1126     {
1127         require(_mintNum + current_minted <= maxNft, "Cannot mint more the total supply.");
1128         for(uint256 i = 0; i < _mintNum; i++) 
1129         {
1130             current_minted += 1;
1131             nftClaimed[msg.sender] += 1;
1132             super._mint(msg.sender, current_minted);
1133         }
1134     }
1135 
1136     // Withdraw the ETH stored in the contract.
1137     function withdrawETH() external onlyOwner 
1138     {
1139         feeAddress.transfer(address(this).balance);
1140     }
1141 
1142     // Update the metadata URI to a new server or IPFS if needed.
1143     function updateURI(string calldata _URI) external onlyOwner 
1144     {
1145         metaAddress = _URI;
1146     }
1147 
1148     // Update how many can be purchased at a time if need be.
1149     function updateLimit(uint newLimit) external onlyOwner
1150     {
1151         mintLimit = newLimit;
1152     }
1153 
1154     // Get how many nfts are minted right now.
1155     function totalSupply() public view returns(uint) 
1156     {
1157         return current_minted;
1158     }
1159 
1160     // Get how many nfts can be minted.    
1161     function maxSupply() public pure returns(uint) 
1162     {
1163         return maxNft;
1164     }
1165 }