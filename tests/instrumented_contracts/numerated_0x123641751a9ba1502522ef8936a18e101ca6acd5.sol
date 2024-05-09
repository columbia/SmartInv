1 // File: contracts/tokens/erc721.sol
2 
3 // SPDX-License-Identifier: MIT AND GPL-3.0
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev ERC-721 non-fungible token standard.
8  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
9  */
10 interface ERC721
11 {
12 
13   /**
14    * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
15    * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
16    * number of NFTs may be created and assigned without emitting Transfer. At the time of any
17    * transfer, the approved address for that NFT (if any) is reset to none.
18    */
19   event Transfer(
20     address indexed _from,
21     address indexed _to,
22     uint256 indexed _tokenId
23   );
24 
25   /**
26    * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
27    * address indicates there is no approved address. When a Transfer event emits, this also
28    * indicates that the approved address for that NFT (if any) is reset to none.
29    */
30   event Approval(
31     address indexed _owner,
32     address indexed _approved,
33     uint256 indexed _tokenId
34   );
35 
36   /**
37    * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
38    * all NFTs of the owner.
39    */
40   event ApprovalForAll(
41     address indexed _owner,
42     address indexed _operator,
43     bool _approved
44   );
45 
46   /**
47    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
48    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
49    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
50    * function checks if `_to` is a smart contract (code size > 0). If so, it calls
51    * `onERC721Received` on `_to` and throws if the return value is not
52    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
53    * @dev Transfers the ownership of an NFT from one address to another address. This function can
54    * be changed to payable.
55    * @param _from The current owner of the NFT.
56    * @param _to The new owner.
57    * @param _tokenId The NFT to transfer.
58    * @param _data Additional data with no specified format, sent in call to `_to`.
59    */
60   function safeTransferFrom(
61     address _from,
62     address _to,
63     uint256 _tokenId,
64     bytes calldata _data
65   )
66     external;
67 
68   /**
69    * @notice This works identically to the other function with an extra data parameter, except this
70    * function just sets data to ""
71    * @dev Transfers the ownership of an NFT from one address to another address. This function can
72    * be changed to payable.
73    * @param _from The current owner of the NFT.
74    * @param _to The new owner.
75    * @param _tokenId The NFT to transfer.
76    */
77   function safeTransferFrom(
78     address _from,
79     address _to,
80     uint256 _tokenId
81   )
82     external;
83 
84   /**
85    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
86    * they may be permanently lost.
87    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
88    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
89    * address. Throws if `_tokenId` is not a valid NFT.  This function can be changed to payable.
90    * @param _from The current owner of the NFT.
91    * @param _to The new owner.
92    * @param _tokenId The NFT to transfer.
93    */
94   function transferFrom(
95     address _from,
96     address _to,
97     uint256 _tokenId
98   )
99     external;
100 
101   /**
102    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
103    * the current NFT owner, or an authorized operator of the current owner.
104    * @param _approved The new approved NFT controller.
105    * @dev Set or reaffirm the approved address for an NFT. This function can be changed to payable.
106    * @param _tokenId The NFT to approve.
107    */
108   function approve(
109     address _approved,
110     uint256 _tokenId
111   )
112     external;
113 
114   /**
115    * @notice The contract MUST allow multiple operators per owner.
116    * @dev Enables or disables approval for a third party ("operator") to manage all of
117    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
118    * @param _operator Address to add to the set of authorized operators.
119    * @param _approved True if the operators is approved, false to revoke approval.
120    */
121   function setApprovalForAll(
122     address _operator,
123     bool _approved
124   )
125     external;
126 
127   /**
128    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
129    * considered invalid, and this function throws for queries about the zero address.
130    * @notice Count all NFTs assigned to an owner.
131    * @param _owner Address for whom to query the balance.
132    * @return Balance of _owner.
133    */
134   function balanceOf(
135     address _owner
136   )
137     external
138     view
139     returns (uint256);
140 
141   /**
142    * @notice Find the owner of an NFT.
143    * @dev Returns the address of the owner of the NFT. NFTs assigned to the zero address are
144    * considered invalid, and queries about them do throw.
145    * @param _tokenId The identifier for an NFT.
146    * @return Address of _tokenId owner.
147    */
148   function ownerOf(
149     uint256 _tokenId
150   )
151     external
152     view
153     returns (address);
154 
155   /**
156    * @notice Throws if `_tokenId` is not a valid NFT.
157    * @dev Get the approved address for a single NFT.
158    * @param _tokenId The NFT to find the approved address for.
159    * @return Address that _tokenId is approved for.
160    */
161   function getApproved(
162     uint256 _tokenId
163   )
164     external
165     view
166     returns (address);
167 
168   /**
169    * @notice Query if an address is an authorized operator for another address.
170    * @dev Returns true if `_operator` is an approved operator for `_owner`, false otherwise.
171    * @param _owner The address that owns the NFTs.
172    * @param _operator The address that acts on behalf of the owner.
173    * @return True if approved for all, false otherwise.
174    */
175   function isApprovedForAll(
176     address _owner,
177     address _operator
178   )
179     external
180     view
181     returns (bool);
182 
183 }
184 
185 // File: contracts/tokens/erc721-token-receiver.sol
186 
187 pragma solidity ^0.8.0;
188 
189 /**
190  * @dev ERC-721 interface for accepting safe transfers.
191  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
192  */
193 interface ERC721TokenReceiver
194 {
195 
196   /**
197    * @notice The contract address is always the message sender. A wallet/broker/auction application
198    * MUST implement the wallet interface if it will accept safe transfers.
199    * @dev Handle the receipt of a NFT. The ERC721 smart contract calls this function on the
200    * recipient after a `transfer`. This function MAY throw to revert and reject the transfer. Return
201    * of other than the magic value MUST result in the transaction being reverted.
202    * Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))` unless throwing.
203    * @param _operator The address which called `safeTransferFrom` function.
204    * @param _from The address which previously owned the token.
205    * @param _tokenId The NFT identifier which is being transferred.
206    * @param _data Additional data with no specified format.
207    * @return Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
208    */
209   function onERC721Received(
210     address _operator,
211     address _from,
212     uint256 _tokenId,
213     bytes calldata _data
214   )
215     external
216     returns(bytes4);
217 
218 }
219 
220 // File: contracts/utils/erc165.sol
221 
222 pragma solidity ^0.8.0;
223 
224 /**
225  * @dev A standard for detecting smart contract interfaces. 
226  * See: https://eips.ethereum.org/EIPS/eip-165.
227  */
228 interface ERC165
229 {
230 
231   /**
232    * @dev Checks if the smart contract includes a specific interface.
233    * This function uses less than 30,000 gas.
234    * @param _interfaceID The interface identifier, as specified in ERC-165.
235    * @return True if _interfaceID is supported, false otherwise.
236    */
237   function supportsInterface(
238     bytes4 _interfaceID
239   )
240     external
241     view
242     returns (bool);
243     
244 }
245 
246 // File: contracts/utils/supports-interface.sol
247 
248 pragma solidity ^0.8.0;
249 
250 /**
251  * @dev Implementation of standard for detect smart contract interfaces.
252  */
253 contract SupportsInterface is
254   ERC165
255 {
256 
257   /**
258    * @dev Mapping of supported intefraces. You must not set element 0xffffffff to true.
259    */
260   mapping(bytes4 => bool) internal supportedInterfaces;
261 
262   /**
263    * @dev Contract constructor.
264    */
265   constructor()
266   {
267     supportedInterfaces[0x01ffc9a7] = true; // ERC165
268   }
269 
270   /**
271    * @dev Function to check which interfaces are suported by this contract.
272    * @param _interfaceID Id of the interface.
273    * @return True if _interfaceID is supported, false otherwise.
274    */
275   function supportsInterface(
276     bytes4 _interfaceID
277   )
278     external
279     override
280     view
281     returns (bool)
282   {
283     return supportedInterfaces[_interfaceID];
284   }
285 
286 }
287 
288 // File: contracts/utils/address-utils.sol
289 
290 pragma solidity ^0.8.0;
291 
292 /**
293  * @notice Based on:
294  * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
295  * Requires EIP-1052.
296  * @dev Utility library of inline functions on addresses.
297  */
298 library AddressUtils
299 {
300 
301   /**
302    * @dev Returns whether the target address is a contract.
303    * @param _addr Address to check.
304    * @return addressCheck True if _addr is a contract, false if not.
305    */
306   function isContract(
307     address _addr
308   )
309     internal
310     view
311     returns (bool addressCheck)
312   {
313     // This method relies in extcodesize, which returns 0 for contracts in
314     // construction, since the code is only stored at the end of the
315     // constructor execution.
316 
317     // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
318     // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
319     // for accounts without code, i.e. `keccak256('')`
320     bytes32 codehash;
321     bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
322     assembly { codehash := extcodehash(_addr) } // solhint-disable-line
323     addressCheck = (codehash != 0x0 && codehash != accountHash);
324   }
325 
326 }
327 
328 // File: contracts/tokens/nf-token.sol
329 
330 pragma solidity ^0.8.0;
331 
332 
333 
334 
335 /**
336  * @dev Implementation of ERC-721 non-fungible token standard.
337  */
338 contract NFToken is
339   ERC721,
340   SupportsInterface
341 {
342   using AddressUtils for address;
343 
344   /**
345    * @dev List of revert message codes. Implementing dApp should handle showing the correct message.
346    * Based on 0xcert framework error codes.
347    */
348   string constant ZERO_ADDRESS = "003001";
349   string constant NOT_VALID_NFT = "003002";
350   string constant NOT_OWNER_OR_OPERATOR = "003003";
351   string constant NOT_OWNER_APPROVED_OR_OPERATOR = "003004";
352   string constant NOT_ABLE_TO_RECEIVE_NFT = "003005";
353   string constant NFT_ALREADY_EXISTS = "003006";
354   string constant NOT_OWNER = "003007";
355   string constant IS_OWNER = "003008";
356 
357   /**
358    * @dev Magic value of a smart contract that can receive NFT.
359    * Equal to: bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")).
360    */
361   bytes4 internal constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
362 
363   /**
364    * @dev A mapping from NFT ID to the address that owns it.
365    */
366   mapping (uint256 => address) internal idToOwner;
367 
368   /**
369    * @dev Mapping from NFT ID to approved address.
370    */
371   mapping (uint256 => address) internal idToApproval;
372 
373    /**
374    * @dev Mapping from owner address to count of their tokens.
375    */
376   mapping (address => uint256) private ownerToNFTokenCount;
377 
378   /**
379    * @dev Mapping from owner address to mapping of operator addresses.
380    */
381   mapping (address => mapping (address => bool)) internal ownerToOperators;
382 
383   /**
384    * @dev Guarantees that the msg.sender is an owner or operator of the given NFT.
385    * @param _tokenId ID of the NFT to validate.
386    */
387   modifier canOperate(
388     uint256 _tokenId
389   )
390   {
391     address tokenOwner = idToOwner[_tokenId];
392     require(
393       tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender],
394       NOT_OWNER_OR_OPERATOR
395     );
396     _;
397   }
398 
399   /**
400    * @dev Guarantees that the msg.sender is allowed to transfer NFT.
401    * @param _tokenId ID of the NFT to transfer.
402    */
403   modifier canTransfer(
404     uint256 _tokenId
405   )
406   {
407     address tokenOwner = idToOwner[_tokenId];
408     require(
409       tokenOwner == msg.sender
410       || idToApproval[_tokenId] == msg.sender
411       || ownerToOperators[tokenOwner][msg.sender],
412       NOT_OWNER_APPROVED_OR_OPERATOR
413     );
414     _;
415   }
416 
417   /**
418    * @dev Guarantees that _tokenId is a valid Token.
419    * @param _tokenId ID of the NFT to validate.
420    */
421   modifier validNFToken(
422     uint256 _tokenId
423   )
424   {
425     require(idToOwner[_tokenId] != address(0), NOT_VALID_NFT);
426     _;
427   }
428 
429   /**
430    * @dev Contract constructor.
431    */
432   constructor()
433   {
434     supportedInterfaces[0x80ac58cd] = true; // ERC721
435   }
436 
437   /**
438    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
439    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
440    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
441    * function checks if `_to` is a smart contract (code size > 0). If so, it calls
442    * `onERC721Received` on `_to` and throws if the return value is not
443    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
444    * @dev Transfers the ownership of an NFT from one address to another address. This function can
445    * be changed to payable.
446    * @param _from The current owner of the NFT.
447    * @param _to The new owner.
448    * @param _tokenId The NFT to transfer.
449    * @param _data Additional data with no specified format, sent in call to `_to`.
450    */
451   function safeTransferFrom(
452     address _from,
453     address _to,
454     uint256 _tokenId,
455     bytes calldata _data
456   )
457     external
458     override
459   {
460     _safeTransferFrom(_from, _to, _tokenId, _data);
461   }
462 
463   /**
464    * @notice This works identically to the other function with an extra data parameter, except this
465    * function just sets data to "".
466    * @dev Transfers the ownership of an NFT from one address to another address. This function can
467    * be changed to payable.
468    * @param _from The current owner of the NFT.
469    * @param _to The new owner.
470    * @param _tokenId The NFT to transfer.
471    */
472   function safeTransferFrom(
473     address _from,
474     address _to,
475     uint256 _tokenId
476   )
477     external
478     override
479   {
480     _safeTransferFrom(_from, _to, _tokenId, "");
481   }
482 
483   /**
484    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
485    * they may be permanently lost.
486    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
487    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
488    * address. Throws if `_tokenId` is not a valid NFT. This function can be changed to payable.
489    * @param _from The current owner of the NFT.
490    * @param _to The new owner.
491    * @param _tokenId The NFT to transfer.
492    */
493   function transferFrom(
494     address _from,
495     address _to,
496     uint256 _tokenId
497   )
498     external
499     override
500     canTransfer(_tokenId)
501     validNFToken(_tokenId)
502   {
503     address tokenOwner = idToOwner[_tokenId];
504     require(tokenOwner == _from, NOT_OWNER);
505     require(_to != address(0), ZERO_ADDRESS);
506 
507     _transfer(_to, _tokenId);
508   }
509 
510   /**
511    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
512    * the current NFT owner, or an authorized operator of the current owner.
513    * @dev Set or reaffirm the approved address for an NFT. This function can be changed to payable.
514    * @param _approved Address to be approved for the given NFT ID.
515    * @param _tokenId ID of the token to be approved.
516    */
517   function approve(
518     address _approved,
519     uint256 _tokenId
520   )
521     external
522     override
523     canOperate(_tokenId)
524     validNFToken(_tokenId)
525   {
526     address tokenOwner = idToOwner[_tokenId];
527     require(_approved != tokenOwner, IS_OWNER);
528 
529     idToApproval[_tokenId] = _approved;
530     emit Approval(tokenOwner, _approved, _tokenId);
531   }
532 
533   /**
534    * @notice This works even if sender doesn't own any tokens at the time.
535    * @dev Enables or disables approval for a third party ("operator") to manage all of
536    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
537    * @param _operator Address to add to the set of authorized operators.
538    * @param _approved True if the operators is approved, false to revoke approval.
539    */
540   function setApprovalForAll(
541     address _operator,
542     bool _approved
543   )
544     external
545     override
546   {
547     ownerToOperators[msg.sender][_operator] = _approved;
548     emit ApprovalForAll(msg.sender, _operator, _approved);
549   }
550 
551   /**
552    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
553    * considered invalid, and this function throws for queries about the zero address.
554    * @param _owner Address for whom to query the balance.
555    * @return Balance of _owner.
556    */
557   function balanceOf(
558     address _owner
559   )
560     external
561     override
562     view
563     returns (uint256)
564   {
565     require(_owner != address(0), ZERO_ADDRESS);
566     return _getOwnerNFTCount(_owner);
567   }
568 
569   /**
570    * @dev Returns the address of the owner of the NFT. NFTs assigned to the zero address are
571    * considered invalid, and queries about them do throw.
572    * @param _tokenId The identifier for an NFT.
573    * @return _owner Address of _tokenId owner.
574    */
575   function ownerOf(
576     uint256 _tokenId
577   )
578     external
579     override
580     view
581     returns (address _owner)
582   {
583     _owner = idToOwner[_tokenId];
584     require(_owner != address(0), NOT_VALID_NFT);
585   }
586 
587   /**
588    * @notice Throws if `_tokenId` is not a valid NFT.
589    * @dev Get the approved address for a single NFT.
590    * @param _tokenId ID of the NFT to query the approval of.
591    * @return Address that _tokenId is approved for.
592    */
593   function getApproved(
594     uint256 _tokenId
595   )
596     external
597     override
598     view
599     validNFToken(_tokenId)
600     returns (address)
601   {
602     return idToApproval[_tokenId];
603   }
604 
605   /**
606    * @dev Checks if `_operator` is an approved operator for `_owner`.
607    * @param _owner The address that owns the NFTs.
608    * @param _operator The address that acts on behalf of the owner.
609    * @return True if approved for all, false otherwise.
610    */
611   function isApprovedForAll(
612     address _owner,
613     address _operator
614   )
615     external
616     override
617     view
618     returns (bool)
619   {
620     return ownerToOperators[_owner][_operator];
621   }
622 
623   /**
624    * @notice Does NO checks.
625    * @dev Actually performs the transfer.
626    * @param _to Address of a new owner.
627    * @param _tokenId The NFT that is being transferred.
628    */
629   function _transfer(
630     address _to,
631     uint256 _tokenId
632   )
633     internal
634     virtual
635   {
636     address from = idToOwner[_tokenId];
637     _clearApproval(_tokenId);
638 
639     _removeNFToken(from, _tokenId);
640     _addNFToken(_to, _tokenId);
641 
642     emit Transfer(from, _to, _tokenId);
643   }
644 
645   /**
646    * @notice This is an internal function which should be called from user-implemented external
647    * mint function. Its purpose is to show and properly initialize data structures when using this
648    * implementation.
649    * @dev Mints a new NFT.
650    * @param _to The address that will own the minted NFT.
651    * @param _tokenId of the NFT to be minted by the msg.sender.
652    */
653   function _mint(
654     address _to,
655     uint256 _tokenId
656   )
657     internal
658     virtual
659   {
660     require(_to != address(0), ZERO_ADDRESS);
661     require(idToOwner[_tokenId] == address(0), NFT_ALREADY_EXISTS);
662 
663     _addNFToken(_to, _tokenId);
664 
665     emit Transfer(address(0), _to, _tokenId);
666   }
667 
668   /**
669    * @notice This is an internal function which should be called from user-implemented external burn
670    * function. Its purpose is to show and properly initialize data structures when using this
671    * implementation. Also, note that this burn implementation allows the minter to re-mint a burned
672    * NFT.
673    * @dev Burns a NFT.
674    * @param _tokenId ID of the NFT to be burned.
675    */
676   function _burn(
677     uint256 _tokenId
678   )
679     internal
680     virtual
681     validNFToken(_tokenId)
682   {
683     address tokenOwner = idToOwner[_tokenId];
684     _clearApproval(_tokenId);
685     _removeNFToken(tokenOwner, _tokenId);
686     emit Transfer(tokenOwner, address(0), _tokenId);
687   }
688 
689   /**
690    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
691    * @dev Removes a NFT from owner.
692    * @param _from Address from which we want to remove the NFT.
693    * @param _tokenId Which NFT we want to remove.
694    */
695   function _removeNFToken(
696     address _from,
697     uint256 _tokenId
698   )
699     internal
700     virtual
701   {
702     require(idToOwner[_tokenId] == _from, NOT_OWNER);
703     ownerToNFTokenCount[_from] -= 1;
704     delete idToOwner[_tokenId];
705   }
706 
707   /**
708    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
709    * @dev Assigns a new NFT to owner.
710    * @param _to Address to which we want to add the NFT.
711    * @param _tokenId Which NFT we want to add.
712    */
713   function _addNFToken(
714     address _to,
715     uint256 _tokenId
716   )
717     internal
718     virtual
719   {
720     require(idToOwner[_tokenId] == address(0), NFT_ALREADY_EXISTS);
721 
722     idToOwner[_tokenId] = _to;
723     ownerToNFTokenCount[_to] += 1;
724   }
725 
726   /**
727    * @dev Helper function that gets NFT count of owner. This is needed for overriding in enumerable
728    * extension to remove double storage (gas optimization) of owner NFT count.
729    * @param _owner Address for whom to query the count.
730    * @return Number of _owner NFTs.
731    */
732   function _getOwnerNFTCount(
733     address _owner
734   )
735     internal
736     virtual
737     view
738     returns (uint256)
739   {
740     return ownerToNFTokenCount[_owner];
741   }
742 
743   /**
744    * @dev Actually perform the safeTransferFrom.
745    * @param _from The current owner of the NFT.
746    * @param _to The new owner.
747    * @param _tokenId The NFT to transfer.
748    * @param _data Additional data with no specified format, sent in call to `_to`.
749    */
750   function _safeTransferFrom(
751     address _from,
752     address _to,
753     uint256 _tokenId,
754     bytes memory _data
755   )
756     private
757     canTransfer(_tokenId)
758     validNFToken(_tokenId)
759   {
760     address tokenOwner = idToOwner[_tokenId];
761     require(tokenOwner == _from, NOT_OWNER);
762     require(_to != address(0), ZERO_ADDRESS);
763 
764     _transfer(_to, _tokenId);
765 
766     if (_to.isContract())
767     {
768       bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
769       require(retval == MAGIC_ON_ERC721_RECEIVED, NOT_ABLE_TO_RECEIVE_NFT);
770     }
771   }
772 
773   /**
774    * @dev Clears the current approval of a given NFT ID.
775    * @param _tokenId ID of the NFT to be transferred.
776    */
777   function _clearApproval(
778     uint256 _tokenId
779   )
780     private
781   {
782     delete idToApproval[_tokenId];
783   }
784 
785 }
786 
787 // File: contracts/tokens/erc721-metadata.sol
788 
789 pragma solidity ^0.8.0;
790 
791 /**
792  * @dev Optional metadata extension for ERC-721 non-fungible token standard.
793  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
794  */
795 interface ERC721Metadata
796 {
797 
798   /**
799    * @dev Returns a descriptive name for a collection of NFTs in this contract.
800    * @return _name Representing name.
801    */
802   function name()
803     external
804     view
805     returns (string memory _name);
806 
807   /**
808    * @dev Returns a abbreviated name for a collection of NFTs in this contract.
809    * @return _symbol Representing symbol.
810    */
811   function symbol()
812     external
813     view
814     returns (string memory _symbol);
815 
816   /**
817    * @dev Returns a distinct Uniform Resource Identifier (URI) for a given asset. It Throws if
818    * `_tokenId` is not a valid NFT. URIs are defined in RFC3986. The URI may point to a JSON file
819    * that conforms to the "ERC721 Metadata JSON Schema".
820    * @return URI of _tokenId.
821    */
822   function tokenURI(uint256 _tokenId)
823     external
824     view
825     returns (string memory);
826 
827 }
828 
829 // File: contracts/NFTokenMetadata.sol
830 
831 pragma solidity 0.8.6;
832 
833 
834 /**
835  * @dev Optional metadata implementation for ERC-721 non-fungible token standard.
836  */
837 contract NFTokenMetadata is
838 NFToken,
839 ERC721Metadata
840 {
841 
842     /**
843      * @dev A descriptive name for a collection of NFTs.
844      */
845     string internal nftName;
846 
847     /**
848      * @dev An abbreviated name for NFTokens.
849      */
850     string internal nftSymbol;
851 
852     /**
853      * @dev The baseUri for NFTokens.
854      */
855     string internal baseUri;
856 
857     /**
858      * @dev Contract constructor.
859      * @notice When implementing, don't forget to set nftName, nftSymbol, and baseUri
860      */
861     constructor()
862     {
863         supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
864     }
865 
866     /**
867      * @dev Returns a descriptive name for a collection of NFTokens.
868      * @return _name Representing name.
869      */
870     function name()
871     external
872     override
873     view
874     returns (string memory _name)
875     {
876         _name = nftName;
877     }
878 
879     /**
880      * @dev Returns an abbreviated name for NFTokens.
881      * @return _symbol Representing symbol.
882      */
883     function symbol()
884     external
885     override
886     view
887     returns (string memory _symbol)
888     {
889         _symbol = nftSymbol;
890     }
891 
892     /**
893      * @dev A distinct URI (RFC 3986) for a given NFT.
894      * @param _tokenId Id for which we want uri.
895      * @return concatenated baseURI and _tokenId string.
896      */
897     function tokenURI(
898         uint256 _tokenId
899     )
900     external
901     override
902     view
903     validNFToken(_tokenId)
904     returns (string memory)
905     {
906         return string(abi.encodePacked(baseUri, uint2str(_tokenId)));
907     }
908 
909     function uint2str(uint _i) internal pure returns (string memory) {
910     if (_i == 0) {
911         return "0";
912     }
913     uint j = _i;
914     uint length;
915     while (j != 0) {
916         length++;
917         j /= 10;
918     }
919     bytes memory str = new bytes(length);
920     while (_i != 0) {
921         str[--length] = bytes1(uint8(48 + _i % 10));
922         _i /= 10;
923     }
924     return string(str);
925 }
926 
927 }
928 
929 // File: contracts/ownership/ownable.sol
930 
931 pragma solidity ^0.8.0;
932 
933 /**
934  * @dev The contract has an owner address, and provides basic authorization control whitch
935  * simplifies the implementation of user permissions. This contract is based on the source code at:
936  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
937  */
938 contract Ownable
939 {
940 
941   /**
942    * @dev Error constants.
943    */
944   string public constant NOT_CURRENT_OWNER = "018001";
945   string public constant CANNOT_TRANSFER_TO_ZERO_ADDRESS = "018002";
946 
947   /**
948    * @dev Current owner address.
949    */
950   address public owner;
951 
952   /**
953    * @dev An event which is triggered when the owner is changed.
954    * @param previousOwner The address of the previous owner.
955    * @param newOwner The address of the new owner.
956    */
957   event OwnershipTransferred(
958     address indexed previousOwner,
959     address indexed newOwner
960   );
961 
962   /**
963    * @dev The constructor sets the original `owner` of the contract to the sender account.
964    */
965   constructor()
966   {
967     owner = msg.sender;
968   }
969 
970   /**
971    * @dev Throws if called by any account other than the owner.
972    */
973   modifier onlyOwner()
974   {
975     require(msg.sender == owner, NOT_CURRENT_OWNER);
976     _;
977   }
978 
979   /**
980    * @dev Allows the current owner to transfer control of the contract to a newOwner.
981    * @param _newOwner The address to transfer ownership to.
982    */
983   function transferOwnership(
984     address _newOwner
985   )
986     public
987     onlyOwner
988   {
989     require(_newOwner != address(0), CANNOT_TRANSFER_TO_ZERO_ADDRESS);
990     emit OwnershipTransferred(owner, _newOwner);
991     owner = _newOwner;
992   }
993 
994 }
995 
996 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
997 
998 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)
999 
1000 pragma solidity ^0.8.0;
1001 
1002 // CAUTION
1003 // This version of SafeMath should only be used with Solidity 0.8 or later,
1004 // because it relies on the compiler's built in overflow checks.
1005 
1006 /**
1007  * @dev Wrappers over Solidity's arithmetic operations.
1008  *
1009  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1010  * now has built in overflow checking.
1011  */
1012 library SafeMath {
1013     /**
1014      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1015      *
1016      * _Available since v3.4._
1017      */
1018     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1019         unchecked {
1020             uint256 c = a + b;
1021             if (c < a) return (false, 0);
1022             return (true, c);
1023         }
1024     }
1025 
1026     /**
1027      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
1028      *
1029      * _Available since v3.4._
1030      */
1031     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1032         unchecked {
1033             if (b > a) return (false, 0);
1034             return (true, a - b);
1035         }
1036     }
1037 
1038     /**
1039      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1040      *
1041      * _Available since v3.4._
1042      */
1043     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1044         unchecked {
1045             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1046             // benefit is lost if 'b' is also tested.
1047             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1048             if (a == 0) return (true, 0);
1049             uint256 c = a * b;
1050             if (c / a != b) return (false, 0);
1051             return (true, c);
1052         }
1053     }
1054 
1055     /**
1056      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1057      *
1058      * _Available since v3.4._
1059      */
1060     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1061         unchecked {
1062             if (b == 0) return (false, 0);
1063             return (true, a / b);
1064         }
1065     }
1066 
1067     /**
1068      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1069      *
1070      * _Available since v3.4._
1071      */
1072     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1073         unchecked {
1074             if (b == 0) return (false, 0);
1075             return (true, a % b);
1076         }
1077     }
1078 
1079     /**
1080      * @dev Returns the addition of two unsigned integers, reverting on
1081      * overflow.
1082      *
1083      * Counterpart to Solidity's `+` operator.
1084      *
1085      * Requirements:
1086      *
1087      * - Addition cannot overflow.
1088      */
1089     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1090         return a + b;
1091     }
1092 
1093     /**
1094      * @dev Returns the subtraction of two unsigned integers, reverting on
1095      * overflow (when the result is negative).
1096      *
1097      * Counterpart to Solidity's `-` operator.
1098      *
1099      * Requirements:
1100      *
1101      * - Subtraction cannot overflow.
1102      */
1103     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1104         return a - b;
1105     }
1106 
1107     /**
1108      * @dev Returns the multiplication of two unsigned integers, reverting on
1109      * overflow.
1110      *
1111      * Counterpart to Solidity's `*` operator.
1112      *
1113      * Requirements:
1114      *
1115      * - Multiplication cannot overflow.
1116      */
1117     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1118         return a * b;
1119     }
1120 
1121     /**
1122      * @dev Returns the integer division of two unsigned integers, reverting on
1123      * division by zero. The result is rounded towards zero.
1124      *
1125      * Counterpart to Solidity's `/` operator.
1126      *
1127      * Requirements:
1128      *
1129      * - The divisor cannot be zero.
1130      */
1131     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1132         return a / b;
1133     }
1134 
1135     /**
1136      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1137      * reverting when dividing by zero.
1138      *
1139      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1140      * opcode (which leaves remaining gas untouched) while Solidity uses an
1141      * invalid opcode to revert (consuming all remaining gas).
1142      *
1143      * Requirements:
1144      *
1145      * - The divisor cannot be zero.
1146      */
1147     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1148         return a % b;
1149     }
1150 
1151     /**
1152      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1153      * overflow (when the result is negative).
1154      *
1155      * CAUTION: This function is deprecated because it requires allocating memory for the error
1156      * message unnecessarily. For custom revert reasons use {trySub}.
1157      *
1158      * Counterpart to Solidity's `-` operator.
1159      *
1160      * Requirements:
1161      *
1162      * - Subtraction cannot overflow.
1163      */
1164     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1165         unchecked {
1166             require(b <= a, errorMessage);
1167             return a - b;
1168         }
1169     }
1170 
1171     /**
1172      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1173      * division by zero. The result is rounded towards zero.
1174      *
1175      * Counterpart to Solidity's `/` operator. Note: this function uses a
1176      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1177      * uses an invalid opcode to revert (consuming all remaining gas).
1178      *
1179      * Requirements:
1180      *
1181      * - The divisor cannot be zero.
1182      */
1183     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1184         unchecked {
1185             require(b > 0, errorMessage);
1186             return a / b;
1187         }
1188     }
1189 
1190     /**
1191      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1192      * reverting with custom message when dividing by zero.
1193      *
1194      * CAUTION: This function is deprecated because it requires allocating memory for the error
1195      * message unnecessarily. For custom revert reasons use {tryMod}.
1196      *
1197      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1198      * opcode (which leaves remaining gas untouched) while Solidity uses an
1199      * invalid opcode to revert (consuming all remaining gas).
1200      *
1201      * Requirements:
1202      *
1203      * - The divisor cannot be zero.
1204      */
1205     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1206         unchecked {
1207             require(b > 0, errorMessage);
1208             return a % b;
1209         }
1210     }
1211 }
1212 
1213 // File: contracts/Robobots.sol
1214 
1215 pragma solidity 0.8.6;
1216 
1217 
1218 
1219 /**
1220  * @dev Robobots ERC721 & Marketplace.
1221  */
1222 contract Robobots is NFTokenMetadata, Ownable {
1223 
1224     using SafeMath for uint256;
1225 
1226     string constant NOT_FOR_SALE = "004001";
1227     string constant NOT_FOR_SALE_TO_YOU = "004002";
1228     string constant INSUFFICIENT_VALUE = "004003";
1229     string constant BID_INFLATION = "004004";
1230     string constant MISSING_BID = "004005";
1231     string constant NOT_BIDDER = "004006";
1232     string constant INTERNAL_INCONSISTENCY = "004007";
1233 
1234     string public constant imageHash = "d4c5e36e00ab8cefae0f3c04ad14f71209e75897a9dd1a3e59a01a51be7dfbf0";
1235     uint256 public constant totalSupply = 10000;
1236     uint256 public constant feePercent = 1; // of 100 basis points, or 1%
1237 
1238     struct Offer {
1239         bool isForSale;
1240         uint tokenId;
1241         address seller;
1242         uint minValue;
1243         address onlySellTo; // optionally sell only to a specific address
1244     }
1245 
1246     struct Bid {
1247         bool hasBid;
1248         uint tokenId;
1249         address bidder;
1250         uint value;
1251     }
1252 
1253     // A record of tokens that are offered for sale at a minimum value, and optionally to a specific buyer
1254     mapping (uint => Offer) public offers;
1255     // A record of the highest bid per token
1256     mapping (uint => Bid) public bids;
1257     // Ether stored in the contract until a seller withdraws
1258     mapping (address => uint) public pendingWithdrawals;
1259 
1260     event PurchaseMade(uint indexed tokenId, uint value, address indexed fromAddress, address indexed toAddress);
1261     event OfferMade(uint indexed tokenId, uint minValue, address indexed toAddress);
1262     event OfferRemoved(uint indexed tokenId);
1263     event BidMade(uint indexed tokenId, uint value, address indexed fromAddress);
1264     event BidRemoved(uint indexed tokenId, uint value, address indexed fromAddress);
1265 
1266     /**
1267     * @dev Contract constructor. Sets metadata extension `name` and `symbol`.
1268     */
1269     constructor() {
1270         nftName = "robobots";
1271         nftSymbol = unicode"🤖";
1272         baseUri = "https://robobots-f79f8.web.app/metadata/bot";
1273     }
1274 
1275     function setBaseTokenURI(string calldata _baseUri) external onlyOwner {
1276         baseUri = _baseUri;
1277     }
1278 
1279     /**
1280     * @dev Mints a new NFT.
1281     * @param _to The address that will own the minted NFT.
1282     * @param _tokenId of the NFT to be minted by the msg.sender.
1283     */
1284     function mint(address _to, uint256 _tokenId) external {
1285         require(_tokenId < totalSupply, NOT_VALID_NFT); // _tokenId should range from 0 to totalSupply-1
1286         super._mint(_to, _tokenId);
1287     }
1288 
1289     /**
1290     * @dev onlyOwner backdoor to allow multiple mints in one transaction
1291     * @param _to The addresses that will own a minted NFT.
1292     * @param _tokenIds to be minted by the msg.sender.
1293     */
1294     function mintAll(address[] memory _to, uint256[] memory _tokenIds) external onlyOwner {
1295         uint n = _to.length;
1296         for (uint i = 0; i < n; i++) {
1297             require(_tokenIds[i] < totalSupply, NOT_VALID_NFT);
1298             super._mint(_to[i], _tokenIds[i]);
1299         }
1300     }
1301 
1302     /**
1303     * @dev Put the token on sale at a minimum sale price.
1304     * @param _tokenId The token for sale, operated by msg.sender
1305     * @param _minSalePriceInWei the minimum payment accepted
1306     */
1307     function makeOffer(uint256 _tokenId, uint _minSalePriceInWei) external canOperate(_tokenId) {
1308         offers[_tokenId] = Offer(true, _tokenId, msg.sender, _minSalePriceInWei, address(0));
1309         emit OfferMade(_tokenId, _minSalePriceInWei, address(0));
1310     }
1311 
1312     /**
1313     * @dev Like makeOffer, but the token may only be bought from a specific address.
1314     * @param _tokenId The token for sale, operated by msg.sender
1315     * @param _minSalePriceInWei the minimum payment accepted
1316     * @param _toAddress the only allowed buyer
1317     */
1318     function makeOfferToAddress(uint256 _tokenId, uint _minSalePriceInWei, address _toAddress) external canOperate(_tokenId) {
1319         offers[_tokenId] = Offer(true, _tokenId, msg.sender, _minSalePriceInWei, _toAddress);
1320         emit OfferMade(_tokenId, _minSalePriceInWei, _toAddress);
1321     }
1322 
1323     /**
1324     * @dev Remove the offer for this token.
1325     * @param _tokenId The token (previously) for sale, operated by msg.sender
1326     */
1327     function withdrawOffer(uint256 _tokenId) external canOperate(_tokenId) {
1328         _removeOffer(_tokenId);
1329     }
1330 
1331     /**
1332     * @dev Buy the token at the minimum sale price.
1333     * @param _tokenId The token for sale
1334     */
1335     function buy(uint256 _tokenId) external payable {
1336         // check that this is a valid purchase attempt
1337         require(_tokenId < totalSupply, NOT_VALID_NFT);
1338         Offer memory offer = offers[_tokenId];
1339         require(offer.isForSale, NOT_FOR_SALE);
1340         require(offer.onlySellTo == address(0) || offer.onlySellTo == msg.sender, NOT_FOR_SALE_TO_YOU);
1341         require(msg.value >= offer.minValue, INSUFFICIENT_VALUE);
1342         address seller = offer.seller;
1343         require(seller == idToOwner[_tokenId], INTERNAL_INCONSISTENCY);
1344 
1345         // make the Transfer
1346         _transfer(msg.sender, _tokenId);
1347 
1348 
1349         // collect fee, and make proceeds available to seller
1350         uint256 fee = (msg.value.mul(feePercent)).div(100);
1351         uint256 proceeds = msg.value - fee;
1352         pendingWithdrawals[owner] += fee;
1353         pendingWithdrawals[seller] += proceeds;
1354         emit PurchaseMade(_tokenId, msg.value, seller, msg.sender);
1355 
1356         // Check for the case where there is a bid from the new owner and refund it.
1357         // Any other bid can stay in place.
1358         Bid memory bid = bids[_tokenId];
1359         if (bid.bidder == msg.sender) {
1360             // Delete bid and refund value
1361             pendingWithdrawals[msg.sender] += bid.value;
1362             _removeBid(_tokenId);
1363         }
1364     }
1365 
1366     /**
1367     * @dev Remove funds from this contract, after a sale and/or a withdrawn bid.
1368     */
1369     function withdrawFunds() external {
1370         uint amount = pendingWithdrawals[msg.sender];
1371         // Zero the pending refund before sending to prevent re-entrancy attacks
1372         pendingWithdrawals[msg.sender] = 0;
1373         payable(msg.sender).transfer(amount);
1374     }
1375 
1376     /**
1377     * @dev Make a bid for the token with msg.value.
1378     * @param _tokenId The coveted token
1379     */
1380     function makeBid(uint256 _tokenId) external payable {
1381         require(_tokenId < totalSupply, NOT_VALID_NFT);
1382         require(idToOwner[_tokenId] != address(0), ZERO_ADDRESS);
1383         require(idToOwner[_tokenId] != msg.sender, BID_INFLATION);
1384         Bid memory existingBid = bids[_tokenId];
1385         require(msg.value > existingBid.value, INSUFFICIENT_VALUE);
1386         if (existingBid.value > 0) {
1387             pendingWithdrawals[existingBid.bidder] += existingBid.value; // refund the outbid bidder
1388         }
1389         bids[_tokenId] = Bid(true, _tokenId, msg.sender, msg.value);
1390         emit BidMade(_tokenId, msg.value, msg.sender);
1391     }
1392 
1393     /**
1394     * @dev Accept the highest bid, assuming a minimum sale price.
1395     * @param _tokenId The coveted token, operated by msg.sender
1396     * @param _minSalePriceInWei the minimum payment accepted, ensuring the bid has not just been reduced.
1397     */
1398     function acceptBid(uint256 _tokenId, uint _minSalePriceInWei) external canOperate(_tokenId) {
1399         address seller = msg.sender;
1400         Bid memory bid = bids[_tokenId];
1401         require(bid.hasBid, MISSING_BID);
1402         require(bid.value > 0, INTERNAL_INCONSISTENCY);
1403         require(bid.value >= _minSalePriceInWei, INSUFFICIENT_VALUE);
1404 
1405         // make the Transfer
1406         _transfer(bid.bidder, _tokenId);
1407 
1408         uint amount = bid.value;
1409         _removeBid(_tokenId);
1410 
1411         // collect fee, and make proceeds available to seller
1412         uint256 fee = (amount.mul(feePercent)).div(100);
1413         uint256 proceeds = amount - fee;
1414         pendingWithdrawals[owner] += fee;
1415         pendingWithdrawals[seller] += proceeds;
1416         emit PurchaseMade(_tokenId, bid.value, seller, bid.bidder);
1417     }
1418 
1419     /**
1420     * @dev Withdraw the bid for this token.
1421     * @param _tokenId The (once-)coveted token
1422     */
1423     function withdrawBid(uint256 _tokenId) external {
1424         require(_tokenId < totalSupply, NOT_VALID_NFT);
1425         require(idToOwner[_tokenId] != msg.sender, BID_INFLATION);
1426         Bid memory bid = bids[_tokenId];
1427         require(bid.bidder == msg.sender, NOT_BIDDER);
1428         uint amount = bid.value;
1429         _removeBid(_tokenId);
1430         // Refund the bid money
1431         payable(msg.sender).transfer(amount);
1432     }
1433 
1434     function _removeOffer(uint256 _tokenId) internal {
1435         if (offers[_tokenId].isForSale) {
1436             offers[_tokenId] = Offer(false, _tokenId, address(0), 0, address(0));
1437             emit OfferRemoved(_tokenId);
1438         }
1439     }
1440 
1441     function _removeBid(uint256 _tokenId) internal {
1442         Bid memory bid = bids[_tokenId];
1443         bids[_tokenId] = Bid(false, 0, address(0), 0);
1444         emit BidRemoved(_tokenId, bid.value, bid.bidder);
1445     }
1446 
1447     /**
1448     * @dev Transfers the ownership of an NFT from one address to another address.
1449     * Removes any existing offer for the token when ownership changes.
1450     * @param _to The new owner.
1451     * @param _tokenId The NFT to transfer.
1452     */
1453 function _transfer(address _to, uint256 _tokenId) internal override {
1454     super._transfer(_to, _tokenId);
1455     _removeOffer(_tokenId);
1456 }
1457 }