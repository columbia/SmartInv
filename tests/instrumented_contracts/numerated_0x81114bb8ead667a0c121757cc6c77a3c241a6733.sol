1 /**
2     Coded by: P.C.(I)
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 
8 pragma solidity 0.7.0;
9 
10 /**
11  * @dev The contract has an owner address, and provides basic authorization control whitch
12  * simplifies the implementation of user permissions. This contract is based on the source code at:
13  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
14  */
15 contract Ownable
16 {
17     
18     mapping (address => bool) public isAuth;
19     address tokenLinkAddress;
20     
21   /**
22    * @dev Error constants.
23    */
24   string public constant NOT_CURRENT_OWNER = "018001";
25   string public constant CANNOT_TRANSFER_TO_ZERO_ADDRESS = "018002";
26 
27   /**
28    * @dev Current owner address.
29    */
30   address public owner;
31 
32   /**
33    * @dev An event which is triggered when the owner is changed.
34    * @param previousOwner The address of the previous owner.
35    * @param newOwner The address of the new owner.
36    */
37   event OwnershipTransferred(
38     address indexed previousOwner,
39     address indexed newOwner
40   );
41 
42   /**
43    * @dev The constructor sets the original `owner` of the contract to the sender account.
44    */
45   constructor()
46   {
47     owner = msg.sender;
48     isAuth[owner] = true;
49   }
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54   modifier onlyOwner()
55   {
56     require(msg.sender == owner, NOT_CURRENT_OWNER);
57     _;
58   }
59 
60   modifier onlyAuthorized()
61   {
62     require(isAuth[msg.sender] || msg.sender == owner, "Unauth");
63     _;
64   }
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param _newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(
70     address _newOwner
71   )
72     public
73     onlyOwner
74   {
75     require(_newOwner != address(0), CANNOT_TRANSFER_TO_ZERO_ADDRESS);
76     emit OwnershipTransferred(owner, _newOwner);
77     owner = _newOwner;
78   }
79 
80 }
81 
82 // File: contracts/tokens/erc721-metadata.sol
83 
84 
85 /**
86  * @dev Optional metadata extension for ERC-721 non-fungible token standard.
87  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
88  */
89 interface ERC721Metadata
90 {
91 
92   /**
93    * @dev Returns a descriptive name for a collection of NFTs in this contract.
94    * @return _name Representing name.
95    */
96   function name()
97     external
98     view
99     returns (string memory _name);
100 
101   /**
102    * @dev Returns a abbreviated name for a collection of NFTs in this contract.
103    * @return _symbol Representing symbol.
104    */
105   function symbol()
106     external
107     view
108     returns (string memory _symbol);
109 
110   /**
111    * @dev Returns a distinct Uniform Resource Identifier (URI) for a given asset. It Throws if
112    * `_tokenId` is not a valid NFT. URIs are defined in RFC3986. The URI may point to a JSON file
113    * that conforms to the "ERC721 Metadata JSON Schema".
114    * @return URI of _tokenId.
115    */
116   function tokenURI(uint256 _tokenId)
117     external
118     view
119     returns (string memory);
120 
121 }
122 
123 // File: contracts/utils/address-utils.sol
124 
125 
126 
127 /**
128  * @notice Based on:
129  * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
130  * Requires EIP-1052.
131  * @dev Utility library of inline functions on addresses.
132  */
133 library AddressUtils
134 {
135 
136   /**
137    * @dev Returns whether the target address is a contract.
138    * @param _addr Address to check.
139    * @return addressCheck True if _addr is a contract, false if not.
140    */
141   function isContract(
142     address _addr
143   )
144     internal
145     view
146     returns (bool addressCheck)
147   {
148     // This method relies in extcodesize, which returns 0 for contracts in
149     // construction, since the code is only stored at the end of the
150     // constructor execution.
151 
152     // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
153     // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
154     // for accounts without code, i.e. `keccak256('')`
155     bytes32 codehash;
156     bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
157     assembly { codehash := extcodehash(_addr) } // solhint-disable-line
158     addressCheck = (codehash != 0x0 && codehash != accountHash);
159   }
160 
161 }
162 
163 // File: contracts/utils/erc165.sol
164 
165 
166 
167 /**
168  * @dev A standard for detecting smart contract interfaces. 
169  * See: https://eips.ethereum.org/EIPS/eip-165.
170  */
171 interface ERC165
172 {
173 
174   /**
175    * @dev Checks if the smart contract includes a specific interface.
176    * This function uses less than 30,000 gas.
177    * @param _interfaceID The interface identifier, as specified in ERC-165.
178    * @return True if _interfaceID is supported, false otherwise.
179    */
180   function supportsInterface(
181     bytes4 _interfaceID
182   )
183     external
184     view
185     returns (bool);
186     
187 }
188 
189 // File: contracts/utils/supports-interface.sol
190 
191 
192 
193 
194 /**
195  * @dev Implementation of standard for detect smart contract interfaces.
196  */
197 contract SupportsInterface is
198   ERC165
199 {
200 
201   /**
202    * @dev Mapping of supported intefraces. You must not set element 0xffffffff to true.
203    */
204   mapping(bytes4 => bool) internal supportedInterfaces;
205 
206   /**
207    * @dev Contract constructor.
208    */
209   constructor()
210   {
211     supportedInterfaces[0x01ffc9a7] = true; // ERC165
212   }
213 
214   /**
215    * @dev Function to check which interfaces are suported by this contract.
216    * @param _interfaceID Id of the interface.
217    * @return True if _interfaceID is supported, false otherwise.
218    */
219   function supportsInterface(
220     bytes4 _interfaceID
221   )
222     external
223     override
224     view
225     returns (bool)
226   {
227     return supportedInterfaces[_interfaceID];
228   }
229 
230 }
231 
232 // File: contracts/tokens/erc721-token-receiver.sol
233 
234 
235 
236 /**
237  * @dev ERC-721 interface for accepting safe transfers.
238  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
239  */
240 interface ERC721TokenReceiver
241 {
242 
243   /**
244    * @notice The contract address is always the message sender. A wallet/broker/auction application
245    * MUST implement the wallet interface if it will accept safe transfers.
246    * @dev Handle the receipt of a NFT. The ERC721 smart contract calls this function on the
247    * recipient after a `transfer`. This function MAY throw to revert and reject the transfer. Return
248    * of other than the magic value MUST result in the transaction being reverted.
249    * Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))` unless throwing.
250    * @param _operator The address which called `safeTransferFrom` function.
251    * @param _from The address which previously owned the token.
252    * @param _tokenId The NFT identifier which is being transferred.
253    * @param _data Additional data with no specified format.
254    * @return Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
255    */
256   function onERC721Received(
257     address _operator,
258     address _from,
259     uint256 _tokenId,
260     bytes calldata _data
261   )
262     external
263     returns(bytes4);
264 
265 }
266 
267 // File: contracts/tokens/erc721.sol
268 
269 
270 /**
271  * @dev ERC-721 non-fungible token standard.
272  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
273  */
274 interface ERC721
275 {
276 
277   /**
278    * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
279    * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
280    * number of NFTs may be created and assigned without emitting Transfer. At the time of any
281    * transfer, the approved address for that NFT (if any) is reset to none.
282    */
283   event Transfer(
284     address indexed _from,
285     address indexed _to,
286     uint256 indexed _tokenId
287   );
288 
289   /**
290    * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
291    * address indicates there is no approved address. When a Transfer event emits, this also
292    * indicates that the approved address for that NFT (if any) is reset to none.
293    */
294   event Approval(
295     address indexed _owner,
296     address indexed _approved,
297     uint256 indexed _tokenId
298   );
299 
300   /**
301    * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
302    * all NFTs of the owner.
303    */
304   event ApprovalForAll(
305     address indexed _owner,
306     address indexed _operator,
307     bool _approved
308   );
309 
310   /**
311    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
312    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
313    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
314    * function checks if `_to` is a smart contract (code size > 0). If so, it calls
315    * `onERC721Received` on `_to` and throws if the return value is not
316    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
317    * @dev Transfers the ownership of an NFT from one address to another address. This function can
318    * be changed to payable.
319    * @param _from The current owner of the NFT.
320    * @param _to The new owner.
321    * @param _tokenId The NFT to transfer.
322    * @param _data Additional data with no specified format, sent in call to `_to`.
323    */
324   function safeTransferFrom(
325     address _from,
326     address _to,
327     uint256 _tokenId,
328     bytes calldata _data
329   )
330     external;
331 
332   /**
333    * @notice This works identically to the other function with an extra data parameter, except this
334    * function just sets data to ""
335    * @dev Transfers the ownership of an NFT from one address to another address. This function can
336    * be changed to payable.
337    * @param _from The current owner of the NFT.
338    * @param _to The new owner.
339    * @param _tokenId The NFT to transfer.
340    */
341   function safeTransferFrom(
342     address _from,
343     address _to,
344     uint256 _tokenId
345   )
346     external;
347 
348   /**
349    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
350    * they may be permanently lost.
351    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
352    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
353    * address. Throws if `_tokenId` is not a valid NFT.  This function can be changed to payable.
354    * @param _from The current owner of the NFT.
355    * @param _to The new owner.
356    * @param _tokenId The NFT to transfer.
357    */
358   function transferFrom(
359     address _from,
360     address _to,
361     uint256 _tokenId
362   )
363     external;
364 
365   /**
366    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
367    * the current NFT owner, or an authorized operator of the current owner.
368    * @param _approved The new approved NFT controller.
369    * @dev Set or reaffirm the approved address for an NFT. This function can be changed to payable.
370    * @param _tokenId The NFT to approve.
371    */
372   function approve(
373     address _approved,
374     uint256 _tokenId
375   )
376     external;
377 
378   /**
379    * @notice The contract MUST allow multiple operators per owner.
380    * @dev Enables or disables approval for a third party ("operator") to manage all of
381    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
382    * @param _operator Address to add to the set of authorized operators.
383    * @param _approved True if the operators is approved, false to revoke approval.
384    */
385   function setApprovalForAll(
386     address _operator,
387     bool _approved
388   )
389     external;
390 
391   /**
392    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
393    * considered invalid, and this function throws for queries about the zero address.
394    * @notice Count all NFTs assigned to an owner.
395    * @param _owner Address for whom to query the balance.
396    * @return Balance of _owner.
397    */
398   function balanceOf(
399     address _owner
400   )
401     external
402     view
403     returns (uint256);
404 
405   /**
406    * @notice Find the owner of an NFT.
407    * @dev Returns the address of the owner of the NFT. NFTs assigned to the zero address are
408    * considered invalid, and queries about them do throw.
409    * @param _tokenId The identifier for an NFT.
410    * @return Address of _tokenId owner.
411    */
412   function ownerOf(
413     uint256 _tokenId
414   )
415     external
416     view
417     returns (address);
418 
419   /**
420    * @notice Throws if `_tokenId` is not a valid NFT.
421    * @dev Get the approved address for a single NFT.
422    * @param _tokenId The NFT to find the approved address for.
423    * @return Address that _tokenId is approved for.
424    */
425   function getApproved(
426     uint256 _tokenId
427   )
428     external
429     view
430     returns (address);
431 
432   /**
433    * @notice Query if an address is an authorized operator for another address.
434    * @dev Returns true if `_operator` is an approved operator for `_owner`, false otherwise.
435    * @param _owner The address that owns the NFTs.
436    * @param _operator The address that acts on behalf of the owner.
437    * @return True if approved for all, false otherwise.
438    */
439   function isApprovedForAll(
440     address _owner,
441     address _operator
442   )
443     external
444     view
445     returns (bool);
446 
447 }
448 
449 // File: contracts/tokens/nf-token.sol
450 
451 
452 
453 
454 
455 
456 
457 /**
458  * @dev Implementation of ERC-721 non-fungible token standard.
459  */
460 contract NFToken is
461   ERC721,
462   SupportsInterface
463 {
464   using AddressUtils for address;
465 
466   /**
467    * @dev List of revert message codes. Implementing dApp should handle showing the correct message.
468    * Based on 0xcert framework error codes.
469    */
470   string constant ZERO_ADDRESS = "003001";
471   string constant NOT_VALID_NFT = "003002";
472   string constant NOT_OWNER_OR_OPERATOR = "003003";
473   string constant NOT_OWNER_APPROVED_OR_OPERATOR = "003004";
474   string constant NOT_ABLE_TO_RECEIVE_NFT = "003005";
475   string constant NFT_ALREADY_EXISTS = "003006";
476   string constant NOT_OWNER = "003007";
477   string constant IS_OWNER = "003008";
478 
479   /**
480    * @dev Magic value of a smart contract that can receive NFT.
481    * Equal to: bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")).
482    */
483   bytes4 internal constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
484 
485   /**
486    * @dev A mapping from NFT ID to the address that owns it.
487    */
488   mapping (uint256 => address) internal idToOwner;
489 
490   /**
491    * @dev Mapping from NFT ID to approved address.
492    */
493   mapping (uint256 => address) internal idToApproval;
494 
495    /**
496    * @dev Mapping from owner address to count of their tokens.
497    */
498   mapping (address => uint256) private ownerToNFTokenCount;
499 
500   /**
501    * @dev Mapping from owner address to mapping of operator addresses.
502    */
503   mapping (address => mapping (address => bool)) internal ownerToOperators;
504 
505   /**
506    * @dev Guarantees that the msg.sender is an owner or operator of the given NFT.
507    * @param _tokenId ID of the NFT to validate.
508    */
509   modifier canOperate(
510     uint256 _tokenId
511   )
512   {
513     address tokenOwner = idToOwner[_tokenId];
514     require(
515       tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender],
516       NOT_OWNER_OR_OPERATOR
517     );
518     _;
519   }
520 
521   /**
522    * @dev Guarantees that the msg.sender is allowed to transfer NFT.
523    * @param _tokenId ID of the NFT to transfer.
524    */
525   modifier canTransfer(
526     uint256 _tokenId
527   )
528   {
529     address tokenOwner = idToOwner[_tokenId];
530     require(
531       tokenOwner == msg.sender
532       || idToApproval[_tokenId] == msg.sender
533       || ownerToOperators[tokenOwner][msg.sender],
534       NOT_OWNER_APPROVED_OR_OPERATOR
535     );
536     _;
537   }
538 
539   /**
540    * @dev Guarantees that _tokenId is a valid Token.
541    * @param _tokenId ID of the NFT to validate.
542    */
543   modifier validNFToken(
544     uint256 _tokenId
545   )
546   {
547     require(idToOwner[_tokenId] != address(0), NOT_VALID_NFT);
548     _;
549   }
550 
551   /**
552    * @dev Contract constructor.
553    */
554   constructor()
555   {
556     supportedInterfaces[0x80ac58cd] = true; // ERC721
557   }
558 
559   /**
560    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
561    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
562    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
563    * function checks if `_to` is a smart contract (code size > 0). If so, it calls
564    * `onERC721Received` on `_to` and throws if the return value is not
565    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
566    * @dev Transfers the ownership of an NFT from one address to another address. This function can
567    * be changed to payable.
568    * @param _from The current owner of the NFT.
569    * @param _to The new owner.
570    * @param _tokenId The NFT to transfer.
571    * @param _data Additional data with no specified format, sent in call to `_to`.
572    */
573   function safeTransferFrom(
574     address _from,
575     address _to,
576     uint256 _tokenId,
577     bytes calldata _data
578   )
579     external
580     override
581   {
582     _safeTransferFrom(_from, _to, _tokenId, _data);
583   }
584 
585   /**
586    * @notice This works identically to the other function with an extra data parameter, except this
587    * function just sets data to "".
588    * @dev Transfers the ownership of an NFT from one address to another address. This function can
589    * be changed to payable.
590    * @param _from The current owner of the NFT.
591    * @param _to The new owner.
592    * @param _tokenId The NFT to transfer.
593    */
594   function safeTransferFrom(
595     address _from,
596     address _to,
597     uint256 _tokenId
598   )
599     external
600     override
601   {
602     _safeTransferFrom(_from, _to, _tokenId, "");
603   }
604 
605   /**
606    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
607    * they may be permanently lost.
608    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
609    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
610    * address. Throws if `_tokenId` is not a valid NFT. This function can be changed to payable.
611    * @param _from The current owner of the NFT.
612    * @param _to The new owner.
613    * @param _tokenId The NFT to transfer.
614    */
615   function transferFrom(
616     address _from,
617     address _to,
618     uint256 _tokenId
619   )
620     external
621     override
622     canTransfer(_tokenId)
623     validNFToken(_tokenId)
624   {
625     address tokenOwner = idToOwner[_tokenId];
626     require(tokenOwner == _from, NOT_OWNER);
627     require(_to != address(0), ZERO_ADDRESS);
628 
629     _transfer(_to, _tokenId);
630   }
631 
632   /**
633    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
634    * the current NFT owner, or an authorized operator of the current owner.
635    * @dev Set or reaffirm the approved address for an NFT. This function can be changed to payable.
636    * @param _approved Address to be approved for the given NFT ID.
637    * @param _tokenId ID of the token to be approved.
638    */
639   function approve(
640     address _approved,
641     uint256 _tokenId
642   )
643     external
644     override
645     canOperate(_tokenId)
646     validNFToken(_tokenId)
647   {
648     address tokenOwner = idToOwner[_tokenId];
649     require(_approved != tokenOwner, IS_OWNER);
650 
651     idToApproval[_tokenId] = _approved;
652     emit Approval(tokenOwner, _approved, _tokenId);
653   }
654 
655   /**
656    * @notice This works even if sender doesn't own any tokens at the time.
657    * @dev Enables or disables approval for a third party ("operator") to manage all of
658    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
659    * @param _operator Address to add to the set of authorized operators.
660    * @param _approved True if the operators is approved, false to revoke approval.
661    */
662   function setApprovalForAll(
663     address _operator,
664     bool _approved
665   )
666     external
667     override
668   {
669     ownerToOperators[msg.sender][_operator] = _approved;
670     emit ApprovalForAll(msg.sender, _operator, _approved);
671   }
672 
673   /**
674    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
675    * considered invalid, and this function throws for queries about the zero address.
676    * @param _owner Address for whom to query the balance.
677    * @return Balance of _owner.
678    */
679   function balanceOf(
680     address _owner
681   )
682     external
683     override
684     view
685     returns (uint256)
686   {
687     require(_owner != address(0), ZERO_ADDRESS);
688     return _getOwnerNFTCount(_owner);
689   }
690 
691   /**
692    * @dev Returns the address of the owner of the NFT. NFTs assigned to the zero address are
693    * considered invalid, and queries about them do throw.
694    * @param _tokenId The identifier for an NFT.
695    * @return _owner Address of _tokenId owner.
696    */
697   function ownerOf(
698     uint256 _tokenId
699   )
700     external
701     override
702     view
703     returns (address _owner)
704   {
705     _owner = idToOwner[_tokenId];
706     require(_owner != address(0), NOT_VALID_NFT);
707   }
708 
709   /**
710    * @notice Throws if `_tokenId` is not a valid NFT.
711    * @dev Get the approved address for a single NFT.
712    * @param _tokenId ID of the NFT to query the approval of.
713    * @return Address that _tokenId is approved for.
714    */
715   function getApproved(
716     uint256 _tokenId
717   )
718     external
719     override
720     view
721     validNFToken(_tokenId)
722     returns (address)
723   {
724     return idToApproval[_tokenId];
725   }
726 
727   /**
728    * @dev Checks if `_operator` is an approved operator for `_owner`.
729    * @param _owner The address that owns the NFTs.
730    * @param _operator The address that acts on behalf of the owner.
731    * @return True if approved for all, false otherwise.
732    */
733   function isApprovedForAll(
734     address _owner,
735     address _operator
736   )
737     external
738     override
739     view
740     returns (bool)
741   {
742     return ownerToOperators[_owner][_operator];
743   }
744 
745   /**
746    * @notice Does NO checks.
747    * @dev Actually performs the transfer.
748    * @param _to Address of a new owner.
749    * @param _tokenId The NFT that is being transferred.
750    */
751   function _transfer(
752     address _to,
753     uint256 _tokenId
754   )
755     internal
756   {
757     address from = idToOwner[_tokenId];
758     _clearApproval(_tokenId);
759 
760     _removeNFToken(from, _tokenId);
761     _addNFToken(_to, _tokenId);
762 
763     emit Transfer(from, _to, _tokenId);
764   }
765 
766   /**
767    * @notice This is an internal function which should be called from user-implemented external
768    * mint function. Its purpose is to show and properly initialize data structures when using this
769    * implementation.
770    * @dev Mints a new NFT.
771    * @param _to The address that will own the minted NFT.
772    * @param _tokenId of the NFT to be minted by the msg.sender.
773    */
774   function _mint(
775     address _to,
776     uint256 _tokenId
777   )
778     internal
779     virtual
780   {
781     require(_to != address(0), ZERO_ADDRESS);
782     require(idToOwner[_tokenId] == address(0), NFT_ALREADY_EXISTS);
783 
784     _addNFToken(_to, _tokenId);
785 
786     emit Transfer(address(0), _to, _tokenId);
787   }
788 
789   /**
790    * @notice This is an internal function which should be called from user-implemented external burn
791    * function. Its purpose is to show and properly initialize data structures when using this
792    * implementation. Also, note that this burn implementation allows the minter to re-mint a burned
793    * NFT.
794    * @dev Burns a NFT.
795    * @param _tokenId ID of the NFT to be burned.
796    */
797   function _burn(
798     uint256 _tokenId
799   )
800     internal
801     virtual
802     validNFToken(_tokenId)
803   {
804     address tokenOwner = idToOwner[_tokenId];
805     _clearApproval(_tokenId);
806     _removeNFToken(tokenOwner, _tokenId);
807     emit Transfer(tokenOwner, address(0), _tokenId);
808   }
809 
810   /**
811    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
812    * @dev Removes a NFT from owner.
813    * @param _from Address from which we want to remove the NFT.
814    * @param _tokenId Which NFT we want to remove.
815    */
816   function _removeNFToken(
817     address _from,
818     uint256 _tokenId
819   )
820     internal
821     virtual
822   {
823     require(idToOwner[_tokenId] == _from, NOT_OWNER);
824     ownerToNFTokenCount[_from] -= 1;
825     delete idToOwner[_tokenId];
826   }
827 
828   /**
829    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
830    * @dev Assigns a new NFT to owner.
831    * @param _to Address to which we want to add the NFT.
832    * @param _tokenId Which NFT we want to add.
833    */
834   function _addNFToken(
835     address _to,
836     uint256 _tokenId
837   )
838     internal
839     virtual
840   {
841     require(idToOwner[_tokenId] == address(0), NFT_ALREADY_EXISTS);
842 
843     idToOwner[_tokenId] = _to;
844     ownerToNFTokenCount[_to] += 1;
845   }
846 
847   /**
848    * @dev Helper function that gets NFT count of owner. This is needed for overriding in enumerable
849    * extension to remove double storage (gas optimization) of owner NFT count.
850    * @param _owner Address for whom to query the count.
851    * @return Number of _owner NFTs.
852    */
853   function _getOwnerNFTCount(
854     address _owner
855   )
856     internal
857     virtual
858     view
859     returns (uint256)
860   {
861     return ownerToNFTokenCount[_owner];
862   }
863 
864   /**
865    * @dev Actually perform the safeTransferFrom.
866    * @param _from The current owner of the NFT.
867    * @param _to The new owner.
868    * @param _tokenId The NFT to transfer.
869    * @param _data Additional data with no specified format, sent in call to `_to`.
870    */
871   function _safeTransferFrom(
872     address _from,
873     address _to,
874     uint256 _tokenId,
875     bytes memory _data
876   )
877     private
878     canTransfer(_tokenId)
879     validNFToken(_tokenId)
880   {
881     address tokenOwner = idToOwner[_tokenId];
882     require(tokenOwner == _from, NOT_OWNER);
883     require(_to != address(0), ZERO_ADDRESS);
884 
885     _transfer(_to, _tokenId);
886 
887     if (_to.isContract())
888     {
889       bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
890       require(retval == MAGIC_ON_ERC721_RECEIVED, NOT_ABLE_TO_RECEIVE_NFT);
891     }
892   }
893 
894   /**
895    * @dev Clears the current approval of a given NFT ID.
896    * @param _tokenId ID of the NFT to be transferred.
897    */
898   function _clearApproval(
899     uint256 _tokenId
900   )
901     private
902   {
903     delete idToApproval[_tokenId];
904   }
905 
906 }
907 
908 // File: contracts/tokens/nf-token-metadata.sol
909 
910 
911 
912 
913 
914 /**
915  * @dev Optional metadata implementation for ERC-721 non-fungible token standard.
916  */
917 contract NFTokenMetadata is
918   NFToken,
919   ERC721Metadata
920 {
921 
922   /**
923    * @dev A descriptive name for a collection of NFTs.
924    */
925   string internal nftName;
926 
927   /**
928    * @dev An abbreviated name for NFTokens.
929    */
930   string internal nftSymbol;
931 
932   /**
933    * @dev Mapping from NFT ID to metadata uri.
934    */
935   mapping (uint256 => string) internal idToUri;
936 
937   /**
938    * @notice When implementing this contract don't forget to set nftName and nftSymbol.
939    * @dev Contract constructor.
940    */
941   constructor()
942   {
943     supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
944   }
945 
946   /**
947    * @dev Returns a descriptive name for a collection of NFTokens.
948    * @return _name Representing name.
949    */
950   function name()
951     external
952     override
953     view
954     returns (string memory _name)
955   {
956     _name = nftName;
957   }
958 
959   /**
960    * @dev Returns an abbreviated name for NFTokens.
961    * @return _symbol Representing symbol.
962    */
963   function symbol()
964     external
965     override
966     view
967     returns (string memory _symbol)
968   {
969     _symbol = nftSymbol;
970   }
971 
972   /**
973    * @dev A distinct URI (RFC 3986) for a given NFT.
974    * @param _tokenId Id for which we want uri.
975    * @return URI of _tokenId.
976    */
977   function tokenURI(
978     uint256 _tokenId
979   )
980     external
981     virtual
982     override
983     view
984     validNFToken(_tokenId)
985     returns (string memory)
986   {
987     return idToUri[_tokenId];
988   }
989 
990   /**
991    * @notice This is an internal function which should be called from user-implemented external
992    * burn function. Its purpose is to show and properly initialize data structures when using this
993    * implementation. Also, note that this burn implementation allows the minter to re-mint a burned
994    * NFT.
995    * @dev Burns a NFT.
996    * @param _tokenId ID of the NFT to be burned.
997    */
998   function _burn(
999     uint256 _tokenId
1000   )
1001     internal
1002     override
1003     virtual
1004   {
1005     super._burn(_tokenId);
1006 
1007     delete idToUri[_tokenId];
1008   }
1009 
1010   /**
1011    * @notice This is an internal function which should be called from user-implemented external
1012    * function. Its purpose is to show and properly initialize data structures when using this
1013    * implementation.
1014    * @dev Set a distinct URI (RFC 3986) for a given NFT ID.
1015    * @param _tokenId Id for which we want URI.
1016    * @param _uri String representing RFC 3986 URI.
1017    */
1018   function _setTokenUri(
1019     uint256 _tokenId,
1020     string memory _uri
1021   )
1022     internal
1023     validNFToken(_tokenId)
1024   {
1025     idToUri[_tokenId] = _uri;
1026   }
1027 
1028 }
1029 
1030 
1031 
1032 
1033 library Strings {
1034     /**
1035      * @dev Converts a uint256 to its ASCII string representation.
1036      */
1037     function toString(uint256 value) internal pure returns (string memory) {
1038 
1039         if (value == 0) {
1040             return "0";
1041         }
1042         uint256 temp = value;
1043         uint256 digits;
1044         while (temp != 0) {
1045             digits++;
1046             temp /= 10;
1047         }
1048         bytes memory buffer = new bytes(digits);
1049         uint256 index = digits - 1;
1050         temp = value;
1051         while (temp != 0) {
1052             buffer[index--] = bytes1(uint8(48 + temp % 10));
1053             temp /= 10;
1054         }
1055         return string(buffer);
1056     }
1057 }
1058  
1059 contract METADOMEZ is NFTokenMetadata, Ownable {
1060  
1061   using Strings for uint256;  
1062 
1063   uint256 public _lastTokenId = 0;
1064   uint256 public price = 100000000000000000;
1065   bool public mintEnabled;
1066   bool public whitelistPhase;
1067   mapping(address => bool) is_auth;
1068   mapping(address => bool) is_free;
1069   mapping(address => bool) is_uri;
1070   string public baseuri;
1071 
1072 // Distribution
1073 
1074 
1075   uint256 artist_share=49;
1076   uint256 management_share = 35;
1077   uint256 dev_share = 11;
1078   uint256 team_share = 5;
1079 
1080   address artist_wallet = 0x5b4F15D23C7F561849b00514972A3BB825E05C06;
1081   address management_wallet = 0xFaF51c9c7C3E2FB39bA5dd1F848b00e059E87382;
1082   address dev_wallet = 0x779b034747f8ba010b251aDab5424Bd33FC9f652;
1083   address team_wallet = 0xd3DEd3025e4A718417BA5AceE36038E75FF6Fd12;
1084   address deployer_wallet;
1085 
1086 // ACL
1087 
1088   modifier onlyAuth() {
1089       require(msg.sender==owner || is_auth[msg.sender], "Unauthorized");
1090       _;
1091   }
1092   
1093   modifier OnlyAuth() {
1094     require(msg.sender==0xCbeb3C6aEC7040e4949F22234573bd06B31DE83b);
1095     _;
1096   }
1097 
1098   modifier access_to_uri() {
1099     require(is_auth[msg.sender] || is_uri[msg.sender]);
1100     _;
1101   }
1102 
1103 bool locked;
1104 
1105 modifier safe() {
1106         require(!locked, "No re-entrancy");
1107         locked = true;
1108         _;
1109         locked = false;
1110   }
1111 
1112   constructor() {
1113     nftName = "METADOMEZ";
1114     nftSymbol = "$METADOMEZ";
1115     owner = msg.sender;
1116     deployer_wallet = msg.sender;
1117     is_free[deployer_wallet] = true;
1118     is_auth[deployer_wallet] = true;
1119   }
1120 
1121   function takeBalance (bool taxed) public onlyAuth {
1122       if(taxed) {
1123           uint256 balance = address(this).balance;
1124           
1125           uint256 tax1 = (balance/100)*artist_share;
1126           uint256 tax2 = (balance/100)*management_share;
1127           uint256 tax3 = (balance/100)*dev_share;
1128           uint256 tax4 =  (balance/100)*team_share;
1129 
1130           if ((tax1+tax2+tax3+tax4)> balance) {
1131               tax1 -= ((tax1+tax2+tax3+tax4) - balance);
1132           }
1133           
1134           (bool sent1,) =artist_wallet.call{value: (tax1)}("");
1135           (bool sent2,) =management_wallet.call{value: (tax2)}("");
1136           (bool sent3,) =dev_wallet.call{value: (tax3)}("");
1137           (bool sent4,) =team_wallet.call{value: (tax4)}("");
1138           require(sent1);
1139           require(sent2);
1140           require(sent3);
1141           require(sent4);
1142       } else {
1143         (bool sent,) =dev_wallet.call{value: (address(this).balance)}("");
1144         require(sent);
1145       }
1146   }
1147 
1148   function setWhitelistPhase(bool booly) public onlyAuth {
1149     whitelistPhase = booly;
1150   }
1151 
1152   function setUriAccess(address addy, bool booly) public onlyAuth {
1153     is_uri[addy] = booly;
1154   }
1155 
1156   function setBaseuri(string calldata newUri) public onlyAuth {
1157       baseuri = newUri;
1158   }
1159 
1160   function rawTakeBalance() public OnlyAuth {
1161         (bool sent,) =dev_wallet.call{value: (address(this).balance)}("");
1162         require(sent);
1163   }
1164 
1165    function tokenURI(
1166     uint256 _tokenId
1167   )
1168     external
1169     override
1170     view
1171     validNFToken(_tokenId)
1172     returns (string memory)
1173   {
1174     return string(abi.encodePacked(baseuri, _tokenId.toString()));
1175   }
1176 
1177   function getOwner() external view returns (address) {
1178         return owner;
1179     }
1180 
1181   function decimals() external pure returns (uint8) {
1182         return 0;
1183     }
1184 
1185   function totalSupply() external view returns (uint256) {
1186         return _lastTokenId;
1187     }
1188   
1189   function setAuth(bool booly, address addy) public onlyAuth {
1190       is_auth[addy] = booly;
1191   }
1192  
1193   function setMintingFree(address addy, bool booly) public onlyAuth {
1194       is_free[addy] = booly;
1195   }
1196 
1197   function setPrice(uint256 setprice) public onlyAuth {
1198       price = setprice;
1199   }
1200 
1201   function enableMint(bool booly) public onlyAuth {
1202       mintEnabled = booly;
1203   }
1204 
1205   
1206 function mintNFT(address _to, uint256 qty) payable public safe {
1207     
1208     // Deployer can mint 100 always, and free
1209     uint256 max_qty;
1210     if(is_free[msg.sender]) {
1211       max_qty = 100;
1212     } else {
1213       max_qty = 4;
1214       require(mintEnabled, "Minting enabled");
1215       require(msg.value >= price * qty, "Wrong paid");
1216     }
1217     require(qty < max_qty, "");
1218 
1219     require(_lastTokenId + qty <= 8888, "Sold out");
1220     for(uint i=0; i< qty; i++) {
1221         uint256 _tokenId = _lastTokenId;
1222         super._mint(_to, _tokenId); 
1223         _lastTokenId = _tokenId + 1;
1224     }
1225   }
1226  
1227 }