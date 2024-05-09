1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.0;
3 
4 /**
5  * @dev ERC-721 non-fungible token standard.
6  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
7  */
8 interface ERC721
9 {
10 
11   /**
12    * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
13    * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
14    * number of NFTs may be created and assigned without emitting Transfer. At the time of any
15    * transfer, the approved address for that NFT (if any) is reset to none.
16    */
17   event Transfer(
18     address indexed _from,
19     address indexed _to,
20     uint256 indexed _tokenId
21   );
22 
23   /**
24    * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
25    * address indicates there is no approved address. When a Transfer event emits, this also
26    * indicates that the approved address for that NFT (if any) is reset to none.
27    */
28   event Approval(
29     address indexed _owner,
30     address indexed _approved,
31     uint256 indexed _tokenId
32   );
33 
34   /**
35    * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
36    * all NFTs of the owner.
37    */
38   event ApprovalForAll(
39     address indexed _owner,
40     address indexed _operator,
41     bool _approved
42   );
43 
44   /**
45    * @dev Transfers the ownership of an NFT from one address to another address.
46    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
47    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
48    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
49    * function checks if `_to` is a smart contract (code size > 0). If so, it calls
50    * `onERC721Received` on `_to` and throws if the return value is not
51    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
52    * @param _from The current owner of the NFT.
53    * @param _to The new owner.
54    * @param _tokenId The NFT to transfer.
55    * @param _data Additional data with no specified format, sent in call to `_to`.
56    */
57   function safeTransferFrom(
58     address _from,
59     address _to,
60     uint256 _tokenId,
61     bytes calldata _data
62   )
63     external;
64 
65   /**
66    * @dev Transfers the ownership of an NFT from one address to another address.
67    * @notice This works identically to the other function with an extra data parameter, except this
68    * function just sets data to ""
69    * @param _from The current owner of the NFT.
70    * @param _to The new owner.
71    * @param _tokenId The NFT to transfer.
72    */
73   function safeTransferFrom(
74     address _from,
75     address _to,
76     uint256 _tokenId
77   )
78     external;
79 
80   /**
81    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
82    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
83    * address. Throws if `_tokenId` is not a valid NFT.
84    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
85    * they may be permanently lost.
86    * @param _from The current owner of the NFT.
87    * @param _to The new owner.
88    * @param _tokenId The NFT to transfer.
89    */
90   function transferFrom(
91     address _from,
92     address _to,
93     uint256 _tokenId
94   )
95     external;
96 
97   /**
98    * @dev Set or reaffirm the approved address for an NFT.
99    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
100    * the current NFT owner, or an authorized operator of the current owner.
101    * @param _approved The new approved NFT controller.
102    * @param _tokenId The NFT to approve.
103    */
104   function approve(
105     address _approved,
106     uint256 _tokenId
107   )
108     external;
109 
110   /**
111    * @dev Enables or disables approval for a third party ("operator") to manage all of
112    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
113    * @notice The contract MUST allow multiple operators per owner.
114    * @param _operator Address to add to the set of authorized operators.
115    * @param _approved True if the operators is approved, false to revoke approval.
116    */
117   function setApprovalForAll(
118     address _operator,
119     bool _approved
120   )
121     external;
122 
123   /**
124    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
125    * considered invalid, and this function throws for queries about the zero address.
126    * @param _owner Address for whom to query the balance.
127    * @return Balance of _owner.
128    */
129   function balanceOf(
130     address _owner
131   )
132     external
133     view
134     returns (uint256);
135 
136   /**
137    * @dev Returns the address of the owner of the NFT. NFTs assigned to the zero address are
138    * considered invalid, and queries about them do throw.
139    * @param _tokenId The identifier for an NFT.
140    * @return Address of _tokenId owner.
141    */
142   function ownerOf(
143     uint256 _tokenId
144   )
145     external
146     view
147     returns (address);
148 
149   /**
150    * @dev Get the approved address for a single NFT.
151    * @notice Throws if `_tokenId` is not a valid NFT.
152    * @param _tokenId The NFT to find the approved address for.
153    * @return Address that _tokenId is approved for.
154    */
155   function getApproved(
156     uint256 _tokenId
157   )
158     external
159     view
160     returns (address);
161 
162   /**
163    * @dev Returns true if `_operator` is an approved operator for `_owner`, false otherwise.
164    * @param _owner The address that owns the NFTs.
165    * @param _operator The address that acts on behalf of the owner.
166    * @return True if approved for all, false otherwise.
167    */
168   function isApprovedForAll(
169     address _owner,
170     address _operator
171   )
172     external
173     view
174     returns (bool);
175 
176 }
177 /**
178  * @dev Optional metadata extension for ERC-721 non-fungible token standard.
179  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
180  */
181 interface ERC721Metadata
182 {
183 
184   /**
185    * @dev Returns a descriptive name for a collection of NFTs in this contract.
186    * @return _name Representing name.
187    */
188   function name()
189     external
190     view
191     returns (string memory _name);
192 
193   /**
194    * @dev Returns a abbreviated name for a collection of NFTs in this contract.
195    * @return _symbol Representing symbol.
196    */
197   function symbol()
198     external
199     view
200     returns (string memory _symbol);
201 
202   /**
203    * @dev Returns a distinct Uniform Resource Identifier (URI) for a given asset. It Throws if
204    * `_tokenId` is not a valid NFT. URIs are defined in RFC3986. The URI may point to a JSON file
205    * that conforms to the "ERC721 Metadata JSON Schema".
206    * @return URI of _tokenId.
207    */
208   function tokenURI(uint256 _tokenId)
209     external
210     view
211     returns (string memory);
212 
213 }
214 /**
215  * @dev Utility library of inline functions on addresses.
216  * @notice Based on:
217  * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
218  * Requires EIP-1052.
219  */
220 library AddressUtils
221 {
222 
223   /**
224    * @dev Returns whether the target address is a contract.
225    * @param _addr Address to check.
226    * @return addressCheck True if _addr is a contract, false if not.
227    */
228   function isContract(
229     address _addr
230   )
231     internal
232     view
233     returns (bool addressCheck)
234   {
235     // This method relies in extcodesize, which returns 0 for contracts in
236     // construction, since the code is only stored at the end of the
237     // constructor execution.
238 
239     // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
240     // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
241     // for accounts without code, i.e. `keccak256('')`
242     bytes32 codehash;
243     bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
244     assembly { codehash := extcodehash(_addr) } // solhint-disable-line
245     addressCheck = (codehash != 0x0 && codehash != accountHash);
246   }
247 
248 }
249 /**
250  * @dev A standard for detecting smart contract interfaces. 
251  * See: https://eips.ethereum.org/EIPS/eip-165.
252  */
253 interface ERC165
254 {
255 
256   /**
257    * @dev Checks if the smart contract includes a specific interface.
258    * This function uses less than 30,000 gas.
259    * @param _interfaceID The interface identifier, as specified in ERC-165.
260    * @return True if _interfaceID is supported, false otherwise.
261    */
262   function supportsInterface(
263     bytes4 _interfaceID
264   )
265     external
266     view
267     returns (bool);
268     
269 }
270 /**
271  * @dev ERC-721 interface for accepting safe transfers.
272  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
273  */
274 interface ERC721TokenReceiver
275 {
276 
277   /**
278    * @dev Handle the receipt of a NFT. The ERC721 smart contract calls this function on the
279    * recipient after a `transfer`. This function MAY throw to revert and reject the transfer. Return
280    * of other than the magic value MUST result in the transaction being reverted.
281    * Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))` unless throwing.
282    * @notice The contract address is always the message sender. A wallet/broker/auction application
283    * MUST implement the wallet interface if it will accept safe transfers.
284    * @param _operator The address which called `safeTransferFrom` function.
285    * @param _from The address which previously owned the token.
286    * @param _tokenId The NFT identifier which is being transferred.
287    * @param _data Additional data with no specified format.
288    * @return Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
289    */
290   function onERC721Received(
291     address _operator,
292     address _from,
293     uint256 _tokenId,
294     bytes calldata _data
295   )
296     external
297     returns(bytes4);
298 
299 }
300 /**
301  * @dev Implementation of standard for detect smart contract interfaces.
302  */
303 contract SupportsInterface is
304   ERC165
305 {
306 
307   /**
308    * @dev Mapping of supported intefraces. You must not set element 0xffffffff to true.
309    */
310   mapping(bytes4 => bool) internal supportedInterfaces;
311 
312   /**
313    * @dev Contract constructor.
314    */
315   constructor()
316   {
317     supportedInterfaces[0x01ffc9a7] = true; // ERC165
318   }
319 
320   /**
321    * @dev Function to check which interfaces are suported by this contract.
322    * @param _interfaceID Id of the interface.
323    * @return True if _interfaceID is supported, false otherwise.
324    */
325   function supportsInterface(
326     bytes4 _interfaceID
327   )
328     external
329     override
330     view
331     returns (bool)
332   {
333     return supportedInterfaces[_interfaceID];
334   }
335 
336 }
337 /**
338  * @dev Implementation of ERC-721 non-fungible token standard.
339  */
340 contract NFToken is
341   ERC721,
342   SupportsInterface
343 {
344   using AddressUtils for address;
345 
346   /**
347    * @dev List of revert message codes. Implementing dApp should handle showing the correct message.
348    * Based on 0xcert framework error codes.
349    */
350   string constant ZERO_ADDRESS = "003001";
351   string constant NOT_VALID_NFT = "003002";
352   string constant NOT_OWNER_OR_OPERATOR = "003003";
353   string constant NOT_OWNER_APPROVED_OR_OPERATOR = "003004";
354   string constant NOT_ABLE_TO_RECEIVE_NFT = "003005";
355   string constant NFT_ALREADY_EXISTS = "003006";
356   string constant NOT_OWNER = "003007";
357   string constant IS_OWNER = "003008";
358 
359   /**
360    * @dev Magic value of a smart contract that can receive NFT.
361    * Equal to: bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")).
362    */
363   bytes4 internal constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
364 
365   /**
366    * @dev A mapping from NFT ID to the address that owns it.
367    */
368   mapping (uint256 => address) internal idToOwner;
369 
370   /**
371    * @dev Mapping from NFT ID to approved address.
372    */
373   mapping (uint256 => address) internal idToApproval;
374 
375    /**
376    * @dev Mapping from owner address to count of their tokens.
377    */
378   mapping (address => uint256) private ownerToNFTokenCount;
379 
380   /**
381    * @dev Mapping from owner address to mapping of operator addresses.
382    */
383   mapping (address => mapping (address => bool)) internal ownerToOperators;
384 
385   /**
386    * @dev Guarantees that the msg.sender is an owner or operator of the given NFT.
387    * @param _tokenId ID of the NFT to validate.
388    */
389   modifier canOperate(
390     uint256 _tokenId
391   )
392   {
393     address tokenOwner = idToOwner[_tokenId];
394     require(
395       tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender],
396       NOT_OWNER_OR_OPERATOR
397     );
398     _;
399   }
400 
401   /**
402    * @dev Guarantees that the msg.sender is allowed to transfer NFT.
403    * @param _tokenId ID of the NFT to transfer.
404    */
405   modifier canTransfer(
406     uint256 _tokenId
407   )
408   {
409     address tokenOwner = idToOwner[_tokenId];
410     require(
411       tokenOwner == msg.sender
412       || idToApproval[_tokenId] == msg.sender
413       || ownerToOperators[tokenOwner][msg.sender],
414       NOT_OWNER_APPROVED_OR_OPERATOR
415     );
416     _;
417   }
418 
419   /**
420    * @dev Guarantees that _tokenId is a valid Token.
421    * @param _tokenId ID of the NFT to validate.
422    */
423   modifier validNFToken(
424     uint256 _tokenId
425   )
426   {
427     require(idToOwner[_tokenId] != address(0), NOT_VALID_NFT);
428     _;
429   }
430 
431   /**
432    * @dev Contract constructor.
433    */
434   constructor()
435   {
436     supportedInterfaces[0x80ac58cd] = true; // ERC721
437   }
438 
439   /**
440    * @dev Transfers the ownership of an NFT from one address to another address. This function can
441    * be changed to payable.
442    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
443    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
444    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
445    * function checks if `_to` is a smart contract (code size > 0). If so, it calls
446    * `onERC721Received` on `_to` and throws if the return value is not
447    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
448    * @param _from The current owner of the NFT.
449    * @param _to The new owner.
450    * @param _tokenId The NFT to transfer.
451    * @param _data Additional data with no specified format, sent in call to `_to`.
452    */
453   function safeTransferFrom(
454     address _from,
455     address _to,
456     uint256 _tokenId,
457     bytes calldata _data
458   )
459     external
460     override
461   {
462     _safeTransferFrom(_from, _to, _tokenId, _data);
463   }
464 
465   /**
466    * @dev Transfers the ownership of an NFT from one address to another address. This function can
467    * be changed to payable.
468    * @notice This works identically to the other function with an extra data parameter, except this
469    * function just sets data to ""
470    * @param _from The current owner of the NFT.
471    * @param _to The new owner.
472    * @param _tokenId The NFT to transfer.
473    */
474   function safeTransferFrom(
475     address _from,
476     address _to,
477     uint256 _tokenId
478   )
479     external
480     override
481   {
482     _safeTransferFrom(_from, _to, _tokenId, "");
483   }
484 
485   /**
486    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
487    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
488    * address. Throws if `_tokenId` is not a valid NFT. This function can be changed to payable.
489    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
490    * they may be permanently lost.
491    * @param _from The current owner of the NFT.
492    * @param _to The new owner.
493    * @param _tokenId The NFT to transfer.
494    */
495   function transferFrom(
496     address _from,
497     address _to,
498     uint256 _tokenId
499   )
500     external
501     override
502     canTransfer(_tokenId)
503     validNFToken(_tokenId)
504   {
505     address tokenOwner = idToOwner[_tokenId];
506     require(tokenOwner == _from, NOT_OWNER);
507     require(_to != address(0), ZERO_ADDRESS);
508 
509     _transfer(_to, _tokenId);
510   }
511 
512   /**
513    * @dev Set or reaffirm the approved address for an NFT. This function can be changed to payable.
514    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
515    * the current NFT owner, or an authorized operator of the current owner.
516    * @param _approved Address to be approved for the given NFT ID.
517    * @param _tokenId ID of the token to be approved.
518    */
519   function approve(
520     address _approved,
521     uint256 _tokenId
522   )
523     external
524     override
525     canOperate(_tokenId)
526     validNFToken(_tokenId)
527   {
528     address tokenOwner = idToOwner[_tokenId];
529     require(_approved != tokenOwner, IS_OWNER);
530 
531     idToApproval[_tokenId] = _approved;
532     emit Approval(tokenOwner, _approved, _tokenId);
533   }
534 
535   /**
536    * @dev Enables or disables approval for a third party ("operator") to manage all of
537    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
538    * @notice This works even if sender doesn't own any tokens at the time.
539    * @param _operator Address to add to the set of authorized operators.
540    * @param _approved True if the operators is approved, false to revoke approval.
541    */
542   function setApprovalForAll(
543     address _operator,
544     bool _approved
545   )
546     external
547     override
548   {
549     ownerToOperators[msg.sender][_operator] = _approved;
550     emit ApprovalForAll(msg.sender, _operator, _approved);
551   }
552 
553   /**
554    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
555    * considered invalid, and this function throws for queries about the zero address.
556    * @param _owner Address for whom to query the balance.
557    * @return Balance of _owner.
558    */
559   function balanceOf(
560     address _owner
561   )
562     external
563     override
564     view
565     returns (uint256)
566   {
567     require(_owner != address(0), ZERO_ADDRESS);
568     return _getOwnerNFTCount(_owner);
569   }
570 
571   /**
572    * @dev Returns the address of the owner of the NFT. NFTs assigned to the zero address are
573    * considered invalid, and queries about them do throw.
574    * @param _tokenId The identifier for an NFT.
575    * @return _owner Address of _tokenId owner.
576    */
577   function ownerOf(
578     uint256 _tokenId
579   )
580     external
581     override
582     view
583     returns (address _owner)
584   {
585     _owner = idToOwner[_tokenId];
586     require(_owner != address(0), NOT_VALID_NFT);
587   }
588 
589   /**
590    * @dev Get the approved address for a single NFT.
591    * @notice Throws if `_tokenId` is not a valid NFT.
592    * @param _tokenId ID of the NFT to query the approval of.
593    * @return Address that _tokenId is approved for.
594    */
595   function getApproved(
596     uint256 _tokenId
597   )
598     external
599     override
600     view
601     validNFToken(_tokenId)
602     returns (address)
603   {
604     return idToApproval[_tokenId];
605   }
606 
607   /**
608    * @dev Checks if `_operator` is an approved operator for `_owner`.
609    * @param _owner The address that owns the NFTs.
610    * @param _operator The address that acts on behalf of the owner.
611    * @return True if approved for all, false otherwise.
612    */
613   function isApprovedForAll(
614     address _owner,
615     address _operator
616   )
617     external
618     override
619     view
620     returns (bool)
621   {
622     return ownerToOperators[_owner][_operator];
623   }
624 
625   /**
626    * @dev Actually performs the transfer.
627    * @notice Does NO checks.
628    * @param _to Address of a new owner.
629    * @param _tokenId The NFT that is being transferred.
630    */
631   function _transfer(
632     address _to,
633     uint256 _tokenId
634   )
635     internal
636   {
637     address from = idToOwner[_tokenId];
638     _clearApproval(_tokenId);
639 
640     _removeNFToken(from, _tokenId);
641     _addNFToken(_to, _tokenId);
642 
643     emit Transfer(from, _to, _tokenId);
644   }
645 
646   /**
647    * @dev Mints a new NFT.
648    * @notice This is an internal function which should be called from user-implemented external
649    * mint function. Its purpose is to show and properly initialize data structures when using this
650    * implementation.
651    * @param _to The address that will own the minted NFT.
652    * @param _tokenId of the NFT to be minted by the msg.sender.
653    */
654   function _mint(
655     address _to,
656     uint256 _tokenId
657   )
658     internal
659     virtual
660   {
661     require(_to != address(0), ZERO_ADDRESS);
662     require(idToOwner[_tokenId] == address(0), NFT_ALREADY_EXISTS);
663 
664     _addNFToken(_to, _tokenId);
665 
666     emit Transfer(address(0), _to, _tokenId);
667   }
668 
669   /**
670    * @dev Burns a NFT.
671    * @notice This is an internal function which should be called from user-implemented external burn
672    * function. Its purpose is to show and properly initialize data structures when using this
673    * implementation. Also, note that this burn implementation allows the minter to re-mint a burned
674    * NFT.
675    * @param _tokenId ID of the NFT to be burned.
676    */
677   function _burn(
678     uint256 _tokenId
679   )
680     internal
681     virtual
682     validNFToken(_tokenId)
683   {
684     address tokenOwner = idToOwner[_tokenId];
685     _clearApproval(_tokenId);
686     _removeNFToken(tokenOwner, _tokenId);
687     emit Transfer(tokenOwner, address(0), _tokenId);
688   }
689 
690   /**
691    * @dev Removes a NFT from owner.
692    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
693    * @param _from Address from which we want to remove the NFT.
694    * @param _tokenId Which NFT we want to remove.
695    */
696   function _removeNFToken(
697     address _from,
698     uint256 _tokenId
699   )
700     internal
701     virtual
702   {
703     require(idToOwner[_tokenId] == _from, NOT_OWNER);
704     ownerToNFTokenCount[_from] -= 1;
705     delete idToOwner[_tokenId];
706   }
707 
708   /**
709    * @dev Assigns a new NFT to owner.
710    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
711    * @param _to Address to which we want to add the NFT.
712    * @param _tokenId Which NFT we want to add.
713    */
714   function _addNFToken(
715     address _to,
716     uint256 _tokenId
717   )
718     internal
719     virtual
720   {
721     require(idToOwner[_tokenId] == address(0), NFT_ALREADY_EXISTS);
722 
723     idToOwner[_tokenId] = _to;
724     ownerToNFTokenCount[_to] += 1;
725   }
726 
727   /**
728    * @dev Helper function that gets NFT count of owner. This is needed for overriding in enumerable
729    * extension to remove double storage (gas optimization) of owner NFT count.
730    * @param _owner Address for whom to query the count.
731    * @return Number of _owner NFTs.
732    */
733   function _getOwnerNFTCount(
734     address _owner
735   )
736     internal
737     virtual
738     view
739     returns (uint256)
740   {
741     return ownerToNFTokenCount[_owner];
742   }
743 
744   /**
745    * @dev Actually perform the safeTransferFrom.
746    * @param _from The current owner of the NFT.
747    * @param _to The new owner.
748    * @param _tokenId The NFT to transfer.
749    * @param _data Additional data with no specified format, sent in call to `_to`.
750    */
751   function _safeTransferFrom(
752     address _from,
753     address _to,
754     uint256 _tokenId,
755     bytes memory _data
756   )
757     private
758     canTransfer(_tokenId)
759     validNFToken(_tokenId)
760   {
761     address tokenOwner = idToOwner[_tokenId];
762     require(tokenOwner == _from, NOT_OWNER);
763     require(_to != address(0), ZERO_ADDRESS);
764 
765     _transfer(_to, _tokenId);
766 
767     if (_to.isContract())
768     {
769       bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
770       require(retval == MAGIC_ON_ERC721_RECEIVED, NOT_ABLE_TO_RECEIVE_NFT);
771     }
772   }
773 
774   /**
775    * @dev Clears the current approval of a given NFT ID.
776    * @param _tokenId ID of the NFT to be transferred.
777    */
778   function _clearApproval(
779     uint256 _tokenId
780   )
781     private
782   {
783     delete idToApproval[_tokenId];
784   }
785 
786 }
787 /**
788  * @dev Optional metadata implementation for ERC-721 non-fungible token standard.
789  */
790 contract NFTokenMetadata is
791   NFToken,
792   ERC721Metadata
793 {
794 
795   /**
796    * @dev A descriptive name for a collection of NFTs.
797    */
798   string internal nftName;
799 
800   /**
801    * @dev An abbreviated name for NFTokens.
802    */
803   string internal nftSymbol;
804 
805   /**
806    * @dev Mapping from NFT ID to metadata uri.
807    */
808   mapping (uint256 => string) internal idToUri;
809 
810   /**
811    * @dev Contract constructor.
812    * @notice When implementing this contract don't forget to set nftName and nftSymbol.
813    */
814   constructor()
815   {
816     supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
817   }
818 
819   /**
820    * @dev Returns a descriptive name for a collection of NFTokens.
821    * @return _name Representing name.
822    */
823   function name()
824     external
825     override
826     view
827     returns (string memory _name)
828   {
829     _name = nftName;
830   }
831 
832   /**
833    * @dev Returns an abbreviated name for NFTokens.
834    * @return _symbol Representing symbol.
835    */
836   function symbol()
837     external
838     override
839     view
840     returns (string memory _symbol)
841   {
842     _symbol = nftSymbol;
843   }
844 
845   /**
846    * @dev A distinct URI (RFC 3986) for a given NFT.
847    * @param _tokenId Id for which we want uri.
848    * @return URI of _tokenId.
849    */
850   function tokenURI(
851     uint256 _tokenId
852   )
853     external
854     override
855     view
856     validNFToken(_tokenId)
857     returns (string memory)
858   {
859     return idToUri[_tokenId];
860   }
861 
862   /**
863    * @dev Burns a NFT.
864    * @notice This is an internal function which should be called from user-implemented external
865    * burn function. Its purpose is to show and properly initialize data structures when using this
866    * implementation. Also, note that this burn implementation allows the minter to re-mint a burned
867    * NFT.
868    * @param _tokenId ID of the NFT to be burned.
869    */
870   function _burn(
871     uint256 _tokenId
872   )
873     internal
874     override
875     virtual
876   {
877     super._burn(_tokenId);
878 
879     delete idToUri[_tokenId];
880   }
881 
882   /**
883    * @dev Set a distinct URI (RFC 3986) for a given NFT ID.
884    * @notice This is an internal function which should be called from user-implemented external
885    * function. Its purpose is to show and properly initialize data structures when using this
886    * implementation.
887    * @param _tokenId Id for which we want URI.
888    * @param _uri String representing RFC 3986 URI.
889    */
890   function _setTokenUri(
891     uint256 _tokenId,
892     string memory _uri
893   )
894     internal
895     validNFToken(_tokenId)
896   {
897     idToUri[_tokenId] = _uri;
898   }
899 
900 }
901 /**
902  * @dev The contract has an owner address, and provides basic authorization control whitch
903  * simplifies the implementation of user permissions. This contract is based on the source code at:
904  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
905  */
906 contract Ownable
907 {
908 
909   /**
910    * @dev Error constants.
911    */
912   string public constant NOT_CURRENT_OWNER = "018001";
913   string public constant CANNOT_TRANSFER_TO_ZERO_ADDRESS = "018002";
914 
915   /**
916    * @dev Current owner address.
917    */
918   address public owner;
919 
920   /**
921    * @dev An event which is triggered when the owner is changed.
922    * @param previousOwner The address of the previous owner.
923    * @param newOwner The address of the new owner.
924    */
925   event OwnershipTransferred(
926     address indexed previousOwner,
927     address indexed newOwner
928   );
929 
930   /**
931    * @dev The constructor sets the original `owner` of the contract to the sender account.
932    */
933   constructor()
934   {
935     owner = msg.sender;
936   }
937 
938   /**
939    * @dev Throws if called by any account other than the owner.
940    */
941   modifier onlyOwner()
942   {
943     require(msg.sender == owner, NOT_CURRENT_OWNER);
944     _;
945   }
946 
947   /**
948    * @dev Allows the current owner to transfer control of the contract to a newOwner.
949    * @param _newOwner The address to transfer ownership to.
950    */
951   function transferOwnership(
952     address _newOwner
953   )
954     public
955     onlyOwner
956   {
957     require(_newOwner != address(0), CANNOT_TRANSFER_TO_ZERO_ADDRESS);
958     emit OwnershipTransferred(owner, _newOwner);
959     owner = _newOwner;
960   }
961 
962 }
963 
964 contract newNFT is NFTokenMetadata, Ownable {
965 
966   uint internal numTokens = 20000;
967   constructor() {
968     nftName = "MemeCalf-NFT";
969     nftSymbol = "MemeCalf";
970   }
971 
972   function mint(address _to, uint256 _tokenId, string calldata _uri) external onlyOwner {
973     super._mint(_to, _tokenId);
974     super._setTokenUri(_tokenId, _uri);
975   }
976   function totalSupply() public view returns (uint256) {
977     return numTokens;
978   }
979 
980 }