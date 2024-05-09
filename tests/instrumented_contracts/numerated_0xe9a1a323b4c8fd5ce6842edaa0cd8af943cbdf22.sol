1 // SPDX-License-Identifier: Unlicense
2 pragma solidity ^0.8.10;
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
28 /**
29  * @dev Optional metadata extension for ERC-721 non-fungible token standard.
30  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
31  */
32 interface ERC721Metadata
33 {
34 
35   /**
36    * @dev Returns a descriptive name for a collection of NFTs in this contract.
37    * @return _name Representing name.
38    */
39   function name()
40     external
41     view
42     returns (string memory _name);
43 
44   /**
45    * @dev Returns a abbreviated name for a collection of NFTs in this contract.
46    * @return _symbol Representing symbol.
47    */
48   function symbol()
49     external
50     view
51     returns (string memory _symbol);
52 
53 }
54 
55 
56 /**
57  * @dev ERC-721 interface for accepting safe transfers.
58  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
59  */
60 interface ERC721TokenReceiver
61 {
62 
63   /**
64    * @notice The contract address is always the message sender. A wallet/broker/auction application
65    * MUST implement the wallet interface if it will accept safe transfers.
66    * @dev Handle the receipt of a NFT. The ERC721 smart contract calls this function on the
67    * recipient after a `transfer`. This function MAY throw to revert and reject the transfer. Return
68    * of other than the magic value MUST result in the transaction being reverted.
69    * Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))` unless throwing.
70    * @param _operator The address which called `safeTransferFrom` function.
71    * @param _from The address which previously owned the token.
72    * @param _tokenId The NFT identifier which is being transferred.
73    * @param _data Additional data with no specified format.
74    * @return Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
75    */
76   function onERC721Received(
77     address _operator,
78     address _from,
79     uint256 _tokenId,
80     bytes calldata _data
81   )
82     external
83     returns(bytes4);
84 
85 }
86 
87 
88 /**
89  * @dev ERC-721 non-fungible token standard.
90  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
91  */
92 interface ERC721
93 {
94 
95   /**
96    * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
97    * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
98    * number of NFTs may be created and assigned without emitting Transfer. At the time of any
99    * transfer, the approved address for that NFT (if any) is reset to none.
100    */
101   event Transfer(
102     address indexed _from,
103     address indexed _to,
104     uint256 indexed _tokenId
105   );
106 
107   /**
108    * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
109    * address indicates there is no approved address. When a Transfer event emits, this also
110    * indicates that the approved address for that NFT (if any) is reset to none.
111    */
112   event Approval(
113     address indexed _owner,
114     address indexed _approved,
115     uint256 indexed _tokenId
116   );
117 
118   /**
119    * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
120    * all NFTs of the owner.
121    */
122   event ApprovalForAll(
123     address indexed _owner,
124     address indexed _operator,
125     bool _approved
126   );
127 
128   /**
129    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
130    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
131    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
132    * function checks if `_to` is a smart contract (code size > 0). If so, it calls
133    * `onERC721Received` on `_to` and throws if the return value is not
134    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
135    * @dev Transfers the ownership of an NFT from one address to another address. This function can
136    * be changed to payable.
137    * @param _from The current owner of the NFT.
138    * @param _to The new owner.
139    * @param _tokenId The NFT to transfer.
140    * @param _data Additional data with no specified format, sent in call to `_to`.
141    */
142   function safeTransferFrom(
143     address _from,
144     address _to,
145     uint256 _tokenId,
146     bytes calldata _data
147   )
148     external;
149 
150   /**
151    * @notice This works identically to the other function with an extra data parameter, except this
152    * function just sets data to ""
153    * @dev Transfers the ownership of an NFT from one address to another address. This function can
154    * be changed to payable.
155    * @param _from The current owner of the NFT.
156    * @param _to The new owner.
157    * @param _tokenId The NFT to transfer.
158    */
159   function safeTransferFrom(
160     address _from,
161     address _to,
162     uint256 _tokenId
163   )
164     external;
165 
166   /**
167    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
168    * they may be permanently lost.
169    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
170    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
171    * address. Throws if `_tokenId` is not a valid NFT.  This function can be changed to payable.
172    * @param _from The current owner of the NFT.
173    * @param _to The new owner.
174    * @param _tokenId The NFT to transfer.
175    */
176   function transferFrom(
177     address _from,
178     address _to,
179     uint256 _tokenId
180   )
181     external;
182 
183   /**
184    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
185    * the current NFT owner, or an authorized operator of the current owner.
186    * @param _approved The new approved NFT controller.
187    * @dev Set or reaffirm the approved address for an NFT. This function can be changed to payable.
188    * @param _tokenId The NFT to approve.
189    */
190   function approve(
191     address _approved,
192     uint256 _tokenId
193   )
194     external;
195 
196   /**
197    * @notice The contract MUST allow multiple operators per owner.
198    * @dev Enables or disables approval for a third party ("operator") to manage all of
199    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
200    * @param _operator Address to add to the set of authorized operators.
201    * @param _approved True if the operators is approved, false to revoke approval.
202    */
203   function setApprovalForAll(
204     address _operator,
205     bool _approved
206   )
207     external;
208 
209   /**
210    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
211    * considered invalid, and this function throws for queries about the zero address.
212    * @notice Count all NFTs assigned to an owner.
213    * @param _owner Address for whom to query the balance.
214    * @return Balance of _owner.
215    */
216   function balanceOf(
217     address _owner
218   )
219     external
220     view
221     returns (uint256);
222 
223   /**
224    * @notice Find the owner of an NFT.
225    * @dev Returns the address of the owner of the NFT. NFTs assigned to the zero address are
226    * considered invalid, and queries about them do throw.
227    * @param _tokenId The identifier for an NFT.
228    * @return Address of _tokenId owner.
229    */
230   function ownerOf(
231     uint256 _tokenId
232   )
233     external
234     view
235     returns (address);
236 
237   /**
238    * @notice Throws if `_tokenId` is not a valid NFT.
239    * @dev Get the approved address for a single NFT.
240    * @param _tokenId The NFT to find the approved address for.
241    * @return Address that _tokenId is approved for.
242    */
243   function getApproved(
244     uint256 _tokenId
245   )
246     external
247     view
248     returns (address);
249 
250   /**
251    * @notice Query if an address is an authorized operator for another address.
252    * @dev Returns true if `_operator` is an approved operator for `_owner`, false otherwise.
253    * @param _owner The address that owns the NFTs.
254    * @param _operator The address that acts on behalf of the owner.
255    * @return True if approved for all, false otherwise.
256    */
257   function isApprovedForAll(
258     address _owner,
259     address _operator
260   )
261     external
262     view
263     returns (bool);
264 
265 }
266 
267 
268 /**
269  * @dev A standard for detecting smart contract interfaces. 
270  * See: https://eips.ethereum.org/EIPS/eip-165.
271  */
272 interface ERC165
273 {
274 
275   /**
276    * @dev Checks if the smart contract includes a specific interface.
277    * This function uses less than 30,000 gas.
278    * @param _interfaceID The interface identifier, as specified in ERC-165.
279    * @return True if _interfaceID is supported, false otherwise.
280    */
281   function supportsInterface(
282     bytes4 _interfaceID
283   )
284     external
285     view
286     returns (bool);
287     
288 }
289 
290 
291 /**
292  * @dev Implementation of standard for detect smart contract interfaces.
293  */
294 contract SupportsInterface is
295   ERC165
296 {
297 
298   /**
299    * @dev Mapping of supported intefraces. You must not set element 0xffffffff to true.
300    */
301   mapping(bytes4 => bool) internal supportedInterfaces;
302 
303   /**
304    * @dev Contract constructor.
305    */
306   constructor()
307   {
308     supportedInterfaces[0x01ffc9a7] = true; // ERC165
309   }
310 
311   /**
312    * @dev Function to check which interfaces are suported by this contract.
313    * @param _interfaceID Id of the interface.
314    * @return True if _interfaceID is supported, false otherwise.
315    */
316   function supportsInterface(
317     bytes4 _interfaceID
318   )
319     external
320     override
321     view
322     returns (bool)
323   {
324     return supportedInterfaces[_interfaceID];
325   }
326 
327 }
328 
329 /**
330  * @dev The contract has an owner address, and provides basic authorization control whitch
331  * simplifies the implementation of user permissions. This contract is based on the source code at:
332  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
333  */
334 contract Ownable
335 {
336 
337   /**
338    * @dev Error constants.
339    */
340   string public constant NOT_CURRENT_OWNER = "018001";
341   string public constant CANNOT_TRANSFER_TO_ZERO_ADDRESS = "018002";
342 
343   /**
344    * @dev Current owner address.
345    */
346   address public owner;
347 
348   /**
349    * @dev An event which is triggered when the owner is changed.
350    * @param previousOwner The address of the previous owner.
351    * @param newOwner The address of the new owner.
352    */
353   event OwnershipTransferred(
354     address indexed previousOwner,
355     address indexed newOwner
356   );
357 
358   /**
359    * @dev The constructor sets the original `owner` of the contract to the sender account.
360    */
361   constructor()
362   {
363     owner = msg.sender;
364   }
365 
366   /**
367    * @dev Throws if called by any account other than the owner.
368    */
369   modifier onlyOwner()
370   {
371     require(msg.sender == owner, NOT_CURRENT_OWNER);
372     _;
373   }
374 
375   /**
376    * @dev Allows the current owner to transfer control of the contract to a newOwner.
377    * @param _newOwner The address to transfer ownership to.
378    */
379   function transferOwnership(
380     address _newOwner
381   )
382     public
383     onlyOwner
384   {
385     require(_newOwner != address(0), CANNOT_TRANSFER_TO_ZERO_ADDRESS);
386     emit OwnershipTransferred(owner, _newOwner);
387     owner = _newOwner;
388   }
389 
390 }
391 
392 
393 /**
394  * @dev Implementation of ERC-721 non-fungible token standard.
395  */
396 contract NFToken is
397   ERC721,
398   SupportsInterface
399 {
400   using AddressUtils for address;
401 
402   /**
403    * @dev List of revert message codes. Implementing dApp should handle showing the correct message.
404    * Based on 0xcert framework error codes.
405    */
406   string constant ZERO_ADDRESS = "003001";
407   string constant NOT_VALID_NFT = "003002";
408   string constant NOT_OWNER_OR_OPERATOR = "003003";
409   string constant NOT_OWNER_APPROVED_OR_OPERATOR = "003004";
410   string constant NOT_ABLE_TO_RECEIVE_NFT = "003005";
411   string constant NFT_ALREADY_EXISTS = "003006";
412   string constant NOT_OWNER = "003007";
413   string constant IS_OWNER = "003008";
414 
415   /**
416    * @dev Magic value of a smart contract that can receive NFT.
417    * Equal to: bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")).
418    */
419   bytes4 internal constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
420 
421   /**
422    * @dev A mapping from NFT ID to the address that owns it.
423    */
424   mapping (uint256 => address) internal idToOwner;
425 
426   /**
427    * @dev Mapping from NFT ID to approved address.
428    */
429   mapping (uint256 => address) internal idToApproval;
430 
431    /**
432    * @dev Mapping from owner address to count of their tokens.
433    */
434   mapping (address => uint256) private ownerToNFTokenCount;
435 
436   /**
437    * @dev Mapping from owner address to mapping of operator addresses.
438    */
439   mapping (address => mapping (address => bool)) internal ownerToOperators;
440 
441   /**
442    * @dev Guarantees that the msg.sender is an owner or operator of the given NFT.
443    * @param _tokenId ID of the NFT to validate.
444    */
445   modifier canOperate(
446     uint256 _tokenId
447   )
448   {
449     address tokenOwner = idToOwner[_tokenId];
450     require(
451       tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender],
452       NOT_OWNER_OR_OPERATOR
453     );
454     _;
455   }
456 
457   /**
458    * @dev Guarantees that the msg.sender is allowed to transfer NFT.
459    * @param _tokenId ID of the NFT to transfer.
460    */
461   modifier canTransfer(
462     uint256 _tokenId
463   )
464   {
465     address tokenOwner = idToOwner[_tokenId];
466     require(
467       tokenOwner == msg.sender
468       || idToApproval[_tokenId] == msg.sender
469       || ownerToOperators[tokenOwner][msg.sender],
470       NOT_OWNER_APPROVED_OR_OPERATOR
471     );
472     _;
473   }
474 
475   /**
476    * @dev Guarantees that _tokenId is a valid Token.
477    * @param _tokenId ID of the NFT to validate.
478    */
479   modifier validNFToken(
480     uint256 _tokenId
481   )
482   {
483     require(idToOwner[_tokenId] != address(0), NOT_VALID_NFT);
484     _;
485   }
486 
487   /**
488    * @dev Contract constructor.
489    */
490   constructor()
491   {
492     supportedInterfaces[0x80ac58cd] = true; // ERC721
493   }
494 
495   /**
496    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
497    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
498    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
499    * function checks if `_to` is a smart contract (code size > 0). If so, it calls
500    * `onERC721Received` on `_to` and throws if the return value is not
501    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
502    * @dev Transfers the ownership of an NFT from one address to another address. This function can
503    * be changed to payable.
504    * @param _from The current owner of the NFT.
505    * @param _to The new owner.
506    * @param _tokenId The NFT to transfer.
507    * @param _data Additional data with no specified format, sent in call to `_to`.
508    */
509   function safeTransferFrom(
510     address _from,
511     address _to,
512     uint256 _tokenId,
513     bytes calldata _data
514   )
515     external
516     override
517   {
518     _safeTransferFrom(_from, _to, _tokenId, _data);
519   }
520 
521   /**
522    * @notice This works identically to the other function with an extra data parameter, except this
523    * function just sets data to "".
524    * @dev Transfers the ownership of an NFT from one address to another address. This function can
525    * be changed to payable.
526    * @param _from The current owner of the NFT.
527    * @param _to The new owner.
528    * @param _tokenId The NFT to transfer.
529    */
530   function safeTransferFrom(
531     address _from,
532     address _to,
533     uint256 _tokenId
534   )
535     external
536     override
537   {
538     _safeTransferFrom(_from, _to, _tokenId, "");
539   }
540 
541   /**
542    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
543    * they may be permanently lost.
544    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
545    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
546    * address. Throws if `_tokenId` is not a valid NFT. This function can be changed to payable.
547    * @param _from The current owner of the NFT.
548    * @param _to The new owner.
549    * @param _tokenId The NFT to transfer.
550    */
551   function transferFrom(
552     address _from,
553     address _to,
554     uint256 _tokenId
555   )
556     external
557     override
558     canTransfer(_tokenId)
559     validNFToken(_tokenId)
560   {
561     address tokenOwner = idToOwner[_tokenId];
562     require(tokenOwner == _from, NOT_OWNER);
563     require(_to != address(0), ZERO_ADDRESS);
564 
565     _transfer(_to, _tokenId);
566   }
567 
568   /**
569    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
570    * the current NFT owner, or an authorized operator of the current owner.
571    * @dev Set or reaffirm the approved address for an NFT. This function can be changed to payable.
572    * @param _approved Address to be approved for the given NFT ID.
573    * @param _tokenId ID of the token to be approved.
574    */
575   function approve(
576     address _approved,
577     uint256 _tokenId
578   )
579     external
580     override
581     canOperate(_tokenId)
582     validNFToken(_tokenId)
583   {
584     address tokenOwner = idToOwner[_tokenId];
585     require(_approved != tokenOwner, IS_OWNER);
586 
587     idToApproval[_tokenId] = _approved;
588     emit Approval(tokenOwner, _approved, _tokenId);
589   }
590 
591   /**
592    * @notice This works even if sender does not own any tokens at the time.
593    * @dev Enables or disables approval for a third party ("operator") to manage all of
594    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
595    * @param _operator Address to add to the set of authorized operators.
596    * @param _approved True if the operators is approved, false to revoke approval.
597    */
598   function setApprovalForAll(
599     address _operator,
600     bool _approved
601   )
602     external
603     override
604   {
605     ownerToOperators[msg.sender][_operator] = _approved;
606     emit ApprovalForAll(msg.sender, _operator, _approved);
607   }
608 
609   /**
610    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
611    * considered invalid, and this function throws for queries about the zero address.
612    * @param _owner Address for whom to query the balance.
613    * @return Balance of _owner.
614    */
615   function balanceOf(
616     address _owner
617   )
618     external
619     override
620     view
621     returns (uint256)
622   {
623     require(_owner != address(0), ZERO_ADDRESS);
624     return _getOwnerNFTCount(_owner);
625   }
626 
627   /**
628    * @dev Returns the address of the owner of the NFT. NFTs assigned to the zero address are
629    * considered invalid, and queries about them do throw.
630    * @param _tokenId The identifier for an NFT.
631    * @return _owner Address of _tokenId owner.
632    */
633   function ownerOf(
634     uint256 _tokenId
635   )
636     external
637     override
638     view
639     returns (address _owner)
640   {
641     _owner = idToOwner[_tokenId];
642     require(_owner != address(0), NOT_VALID_NFT);
643   }
644   
645   function ownerOfInternal(
646     uint256 _tokenId
647   )
648     internal
649     view
650     returns (address _owner)
651   {
652     _owner = idToOwner[_tokenId];
653     require(_owner != address(0), NOT_VALID_NFT);
654   }
655 
656   /**
657    * @notice Throws if `_tokenId` is not a valid NFT.
658    * @dev Get the approved address for a single NFT.
659    * @param _tokenId ID of the NFT to query the approval of.
660    * @return Address that _tokenId is approved for.
661    */
662   function getApproved(
663     uint256 _tokenId
664   )
665     external
666     override
667     view
668     validNFToken(_tokenId)
669     returns (address)
670   {
671     return idToApproval[_tokenId];
672   }
673 
674   /**
675    * @dev Checks if `_operator` is an approved operator for `_owner`.
676    * @param _owner The address that owns the NFTs.
677    * @param _operator The address that acts on behalf of the owner.
678    * @return True if approved for all, false otherwise.
679    */
680   function isApprovedForAll(
681     address _owner,
682     address _operator
683   )
684     external
685     override
686     view
687     returns (bool)
688   {
689     return ownerToOperators[_owner][_operator];
690   }
691 
692   /**
693    * @notice Does NO checks.
694    * @dev Actually performs the transfer.
695    * @param _to Address of a new owner.
696    * @param _tokenId The NFT that is being transferred.
697    */
698   function _transfer(
699     address _to,
700     uint256 _tokenId
701   )
702     internal
703   {
704     address from = idToOwner[_tokenId];
705     _clearApproval(_tokenId);
706 
707     _removeNFToken(from, _tokenId);
708     _addNFToken(_to, _tokenId);
709 
710     emit Transfer(from, _to, _tokenId);
711   }
712 
713   /**
714    * @notice This is an internal function which should be called from user-implemented external
715    * mint function. Its purpose is to show and properly initialize data structures when using this
716    * implementation.
717    * @dev Mints a new NFT.
718    * @param _to The address that will own the minted NFT.
719    * @param _tokenId of the NFT to be minted by the msg.sender.
720    */
721   function _mint(
722     address _to,
723     uint256 _tokenId
724   )
725     internal
726     virtual
727   {
728     require(_to != address(0), ZERO_ADDRESS);
729     require(idToOwner[_tokenId] == address(0), NFT_ALREADY_EXISTS);
730 
731     _addNFToken(_to, _tokenId);
732 
733     emit Transfer(address(0), _to, _tokenId);
734   }
735 
736   /**
737    * @notice This is an internal function which should be called from user-implemented external burn
738    * function. Its purpose is to show and properly initialize data structures when using this
739    * implementation. Also, note that this burn implementation allows the minter to re-mint a burned
740    * NFT.
741    * @dev Burns a NFT.
742    * @param _tokenId ID of the NFT to be burned.
743    */
744   function _burn(
745     uint256 _tokenId
746   )
747     internal
748     virtual
749     validNFToken(_tokenId)
750   {
751     address tokenOwner = idToOwner[_tokenId];
752     _clearApproval(_tokenId);
753     _removeNFToken(tokenOwner, _tokenId);
754     emit Transfer(tokenOwner, address(0), _tokenId);
755   }
756 
757   /**
758    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
759    * @dev Removes a NFT from owner.
760    * @param _from Address from which we want to remove the NFT.
761    * @param _tokenId Which NFT we want to remove.
762    */
763   function _removeNFToken(
764     address _from,
765     uint256 _tokenId
766   )
767     internal
768     virtual
769   {
770     require(idToOwner[_tokenId] == _from, NOT_OWNER);
771     ownerToNFTokenCount[_from] -= 1;
772     delete idToOwner[_tokenId];
773   }
774 
775   /**
776    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
777    * @dev Assigns a new NFT to owner.
778    * @param _to Address to which we want to add the NFT.
779    * @param _tokenId Which NFT we want to add.
780    */
781   function _addNFToken(
782     address _to,
783     uint256 _tokenId
784   )
785     internal
786     virtual
787   {
788     require(idToOwner[_tokenId] == address(0), NFT_ALREADY_EXISTS);
789 
790     idToOwner[_tokenId] = _to;
791     ownerToNFTokenCount[_to] += 1;
792   }
793 
794   /**
795    * @dev Helper function that gets NFT count of owner. This is needed for overriding in enumerable
796    * extension to remove double storage (gas optimization) of owner NFT count.
797    * @param _owner Address for whom to query the count.
798    * @return Number of _owner NFTs.
799    */
800   function _getOwnerNFTCount(
801     address _owner
802   )
803     internal
804     virtual
805     view
806     returns (uint256)
807   {
808     return ownerToNFTokenCount[_owner];
809   }
810 
811   /**
812    * @dev Actually perform the safeTransferFrom.
813    * @param _from The current owner of the NFT.
814    * @param _to The new owner.
815    * @param _tokenId The NFT to transfer.
816    * @param _data Additional data with no specified format, sent in call to `_to`.
817    */
818   function _safeTransferFrom(
819     address _from,
820     address _to,
821     uint256 _tokenId,
822     bytes memory _data
823   )
824     private
825     canTransfer(_tokenId)
826     validNFToken(_tokenId)
827   {
828     address tokenOwner = idToOwner[_tokenId];
829     require(tokenOwner == _from, NOT_OWNER);
830     require(_to != address(0), ZERO_ADDRESS);
831 
832     _transfer(_to, _tokenId);
833 
834     if (_to.isContract())
835     {
836       bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
837       require(retval == MAGIC_ON_ERC721_RECEIVED, NOT_ABLE_TO_RECEIVE_NFT);
838     }
839   }
840 
841   /**
842    * @dev Clears the current approval of a given NFT ID.
843    * @param _tokenId ID of the NFT to be transferred.
844    */
845   function _clearApproval(
846     uint256 _tokenId
847   )
848     private
849   {
850     delete idToApproval[_tokenId];
851   }
852 
853 }
854 
855 
856 
857 /**
858  * @dev Optional metadata implementation for ERC-721 non-fungible token standard.
859  */
860 contract NFTokenMetadata is
861   NFToken,
862   ERC721Metadata
863 {
864 
865   /**
866    * @dev A descriptive name for a collection of NFTs.
867    */
868   string internal nftName;
869 
870   /**
871    * @dev An abbreviated name for NFTokens.
872    */
873   string internal nftSymbol;
874 
875 
876   /**
877    * @notice When implementing this contract don't forget to set nftName and nftSymbol.
878    * @dev Contract constructor.
879    */
880   constructor()
881   {
882     supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
883   }
884 
885   /**
886    * @dev Returns a descriptive name for a collection of NFTokens.
887    * @return _name Representing name.
888    */
889   function name()
890     external
891     override
892     view
893     returns (string memory _name)
894   {
895     _name = nftName;
896   }
897 
898   /**
899    * @dev Returns an abbreviated name for NFTokens.
900    * @return _symbol Representing symbol.
901    */
902   function symbol()
903     external
904     override
905     view
906     returns (string memory _symbol)
907   {
908     _symbol = nftSymbol;
909   }
910 
911   /**
912    * @dev A distinct URI (RFC 3986) for a given NFT.
913    * @param _tokenId Id for which we want uri.
914    * @return URI of _tokenId.
915    */
916 
917 
918 }
919 
920 
921 contract TheWildBunch is NFTokenMetadata, Ownable 
922 {
923     // Properties
924     address payable feeAddress;
925     uint constant public wildOnePrice = 0.1 ether;
926     uint constant public maxWildOnes = 4000;    // Total WildOne Supply
927 
928     // Switches
929     bool public isMintingActive = false;        // Is minting open? Yes or no.
930     bool public isWhiteListActive = true;       // Is the public sale open or is it only whitelisted?
931 
932     // Mappings
933     mapping(address => bool) private whiteList; // Map of addresses on the whitelist.
934     mapping(address => uint256) public wildOnesClaimed; // Map of how many Wild Ones are minted per address.
935 
936     // Vars
937     uint256 public current_minted = 0;
938     uint public mintLimit = 5;
939     
940     // URI Data
941     string private metaAddress = "https://api.thewildbunch.io/metadata/";
942     string constant private jsonAppend = ".json";
943 
944     // Events
945     event Minted(address sender, uint256 count);
946 
947     constructor()
948     {
949         nftName = "The Wild Bunch";
950         nftSymbol = "TWB";
951         feeAddress = payable(msg.sender);
952     }
953 
954     function tokenURI(uint tokenID) external view returns (string memory)
955     {   // @dev Token URIs are generated dynamically on view requests. 
956         // This is to allow easy server changes and reduce gas fees for minting. -ssa2
957         require(tokenID > 0, "Token does not exist.");
958         require(tokenID <= current_minted, "Token hasn't been minted yet.");
959 
960         bytes32 thisToken;
961         bytes memory concat;
962         thisToken = uintToBytes(tokenID);
963         concat = abi.encodePacked(metaAddress, thisToken, jsonAppend);
964         return string(concat);
965     }
966 
967     // Toggle whether any gals can be minted at all.
968     function toggleMinting() public onlyOwner
969     {
970         isMintingActive = !isMintingActive;
971     }
972 
973     // Toggle if we're in the Whitelist or Public Sale.
974     function toggleWhiteList() public onlyOwner
975     {
976         isWhiteListActive = !isWhiteListActive;
977     }
978 
979     // Add a list of wallet addresses to the Whitelist.
980     function addToWhiteList(address[] calldata addresses) external onlyOwner {
981         for (uint256 i = 0; i < addresses.length; i++) {
982             require(addresses[i] != address(0), "Cannot add the null address");
983 
984             whiteList[addresses[i]] = true;
985         }
986     }
987 
988     // Tells the world if a given address is whitelisted or not.
989     function onWhiteList(address addr) external view returns (bool) {
990         return whiteList[addr];
991     }
992 
993     // }:)
994     function removeFromwhiteList(address[] calldata addresses) external onlyOwner {
995         for (uint256 i = 0; i < addresses.length; i++) {
996             require(addresses[i] != address(0), "Cant add null address");
997 
998             whiteList[addresses[i]] = false;
999         }
1000     }
1001 
1002     // Tells the world how many Wild Ones a given address has minted.
1003     function claimedBy(address owner) external view returns (uint256) {
1004         require(owner != address(0), 'The zero address cannot mint anything.');
1005 
1006         return wildOnesClaimed[owner];
1007     }
1008 
1009     // Address  ETH gets sent to when withdrawing.
1010     function updateRecipient(address payable _newAddress) public onlyOwner
1011     {
1012         feeAddress = _newAddress;
1013     }
1014 
1015     // Takes care of converting an integer into the raw bytes of it's abi-encodable string.
1016     function uintToBytes(uint v) private pure returns (bytes32 ret) {
1017         if (v == 0)
1018         {
1019             ret = '0';
1020         }
1021         else
1022         {
1023             while (v > 0) 
1024             {
1025                 ret = bytes32(uint(ret) / (2 ** 8));
1026                 ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
1027                 v /= 10;
1028             }
1029         }
1030         return ret;
1031     }
1032 
1033     // Public Sale minting function
1034     function mint(uint8 _mintNum) public payable
1035     {
1036         require(isMintingActive, "Yall cant mint yet.");
1037         require(_mintNum > 0, "Youre gonna have to mint at least one...");
1038         require(_mintNum + wildOnesClaimed[msg.sender] <= mintLimit, "Cant mint more than 5 Wild Ones per Wallet.");
1039         require(msg.value >= wildOnePrice * _mintNum, "Yall are gonna need more ETH to afford that.");
1040         require(current_minted + _mintNum <= maxWildOnes, "Sorry partner, we dont got enough of those left in stock.");
1041         if(isWhiteListActive)
1042         {
1043             require(whiteList[msg.sender], "I reckon youre not on the whitelist...");
1044         }
1045 
1046         for(uint i = 0; i < _mintNum; i++)
1047         {
1048             current_minted += 1;
1049             super._mint(msg.sender, current_minted);
1050             wildOnesClaimed[msg.sender] += 1;
1051         }
1052 
1053         emit Minted(msg.sender, _mintNum);
1054     }
1055 
1056     // Emergency Devmint function if something gets messed up.
1057     function devMint(uint8 _mintNum) external onlyOwner 
1058     {
1059         require(_mintNum + current_minted <= maxWildOnes, "Cannot mint more the total supply.");
1060         for(uint256 i = 0; i < _mintNum; i++) 
1061         {
1062             current_minted += 1;
1063             wildOnesClaimed[msg.sender] += 1;
1064             super._mint(msg.sender, current_minted);
1065         }
1066     }
1067 
1068     // Withdraw the ETH stored in the contract.
1069     function withdrawETH() external onlyOwner 
1070     {
1071         feeAddress.transfer(address(this).balance);
1072     }
1073 
1074     // Update the metadata URI to a new server or IPFS if needed.
1075     function updateURI(string calldata _URI) external onlyOwner 
1076     {
1077         metaAddress = _URI;
1078     }
1079 
1080     // Update how many can be purchased at a time if need be.
1081     function updateLimit(uint newLimit) external onlyOwner
1082     {
1083         mintLimit = newLimit;
1084     }
1085 
1086     // Get how many Wild Ones are minted right now.
1087     function totalSupply() public view returns(uint) 
1088     {
1089         return current_minted;
1090     }
1091 
1092     // Get how many Wild Ones MAX can be minted.    
1093     function maxSupply() public pure returns(uint) 
1094     {
1095         return maxWildOnes;
1096     }
1097 }