1 pragma solidity ^0.4.24;
2 
3 // File: @0xcert/ethereum-utils/contracts/math/SafeMath.sol
4 
5 /**
6  * @dev Math operations with safety checks that throw on error. This contract is based
7  * on the source code at https://goo.gl/iyQsmU.
8  */
9 library SafeMath {
10 
11   /**
12    * @dev Multiplies two numbers, throws on overflow.
13    * @param _a Factor number.
14    * @param _b Factor number.
15    */
16   function mul(
17     uint256 _a,
18     uint256 _b
19   )
20     internal
21     pure
22     returns (uint256)
23   {
24     if (_a == 0) {
25       return 0;
26     }
27     uint256 c = _a * _b;
28     assert(c / _a == _b);
29     return c;
30   }
31 
32   /**
33    * @dev Integer division of two numbers, truncating the quotient.
34    * @param _a Dividend number.
35    * @param _b Divisor number.
36    */
37   function div(
38     uint256 _a,
39     uint256 _b
40   )
41     internal
42     pure
43     returns (uint256)
44   {
45     uint256 c = _a / _b;
46     // assert(b > 0); // Solidity automatically throws when dividing by 0
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return c;
49   }
50 
51   /**
52    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53    * @param _a Minuend number.
54    * @param _b Subtrahend number.
55    */
56   function sub(
57     uint256 _a,
58     uint256 _b
59   )
60     internal
61     pure
62     returns (uint256)
63   {
64     assert(_b <= _a);
65     return _a - _b;
66   }
67 
68   /**
69    * @dev Adds two numbers, throws on overflow.
70    * @param _a Number.
71    * @param _b Number.
72    */
73   function add(
74     uint256 _a,
75     uint256 _b
76   )
77     internal
78     pure
79     returns (uint256)
80   {
81     uint256 c = _a + _b;
82     assert(c >= _a);
83     return c;
84   }
85 
86 }
87 
88 // File: @0xcert/ethereum-erc721/contracts/tokens/ERC721Enumerable.sol
89 
90 /**
91  * @dev Optional enumeration extension for ERC-721 non-fungible token standard.
92  * See https://goo.gl/pc9yoS.
93  */
94 interface ERC721Enumerable {
95 
96   /**
97    * @dev Returns a count of valid NFTs tracked by this contract, where each one of them has an
98    * assigned and queryable owner not equal to the zero address.
99    */
100   function totalSupply()
101     external
102     view
103     returns (uint256);
104 
105   /**
106    * @dev Returns the token identifier for the `_index`th NFT. Sort order is not specified.
107    * @param _index A counter less than `totalSupply()`.
108    */
109   function tokenByIndex(
110     uint256 _index
111   )
112     external
113     view
114     returns (uint256);
115 
116   /**
117    * @dev Returns the token identifier for the `_index`th NFT assigned to `_owner`. Sort order is
118    * not specified. It throws if `_index` >= `balanceOf(_owner)` or if `_owner` is the zero address,
119    * representing invalid NFTs.
120    * @param _owner An address where we are interested in NFTs owned by them.
121    * @param _index A counter less than `balanceOf(_owner)`.
122    */
123   function tokenOfOwnerByIndex(
124     address _owner,
125     uint256 _index
126   )
127     external
128     view
129     returns (uint256);
130 
131 }
132 
133 // File: @0xcert/ethereum-erc721/contracts/tokens/ERC721.sol
134 
135 /**
136  * @dev ERC-721 non-fungible token standard. See https://goo.gl/pc9yoS.
137  */
138 interface ERC721 {
139 
140   /**
141    * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
142    * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
143    * number of NFTs may be created and assigned without emitting Transfer. At the time of any
144    * transfer, the approved address for that NFT (if any) is reset to none.
145    */
146   event Transfer(
147     address indexed _from,
148     address indexed _to,
149     uint256 indexed _tokenId
150   );
151 
152   /**
153    * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
154    * address indicates there is no approved address. When a Transfer event emits, this also
155    * indicates that the approved address for that NFT (if any) is reset to none.
156    */
157   event Approval(
158     address indexed _owner,
159     address indexed _approved,
160     uint256 indexed _tokenId
161   );
162 
163   /**
164    * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
165    * all NFTs of the owner.
166    */
167   event ApprovalForAll(
168     address indexed _owner,
169     address indexed _operator,
170     bool _approved
171   );
172 
173   /**
174    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
175    * considered invalid, and this function throws for queries about the zero address.
176    * @param _owner Address for whom to query the balance.
177    */
178   function balanceOf(
179     address _owner
180   )
181     external
182     view
183     returns (uint256);
184 
185   /**
186    * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered
187    * invalid, and queries about them do throw.
188    * @param _tokenId The identifier for an NFT.
189    */
190   function ownerOf(
191     uint256 _tokenId
192   )
193     external
194     view
195     returns (address);
196 
197   /**
198    * @dev Transfers the ownership of an NFT from one address to another address.
199    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
200    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
201    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
202    * function checks if `_to` is a smart contract (code size > 0). If so, it calls `onERC721Received`
203    * on `_to` and throws if the return value is not `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
204    * @param _from The current owner of the NFT.
205    * @param _to The new owner.
206    * @param _tokenId The NFT to transfer.
207    * @param _data Additional data with no specified format, sent in call to `_to`.
208    */
209   function safeTransferFrom(
210     address _from,
211     address _to,
212     uint256 _tokenId,
213     bytes _data
214   )
215     external;
216 
217   /**
218    * @dev Transfers the ownership of an NFT from one address to another address.
219    * @notice This works identically to the other function with an extra data parameter, except this
220    * function just sets data to ""
221    * @param _from The current owner of the NFT.
222    * @param _to The new owner.
223    * @param _tokenId The NFT to transfer.
224    */
225   function safeTransferFrom(
226     address _from,
227     address _to,
228     uint256 _tokenId
229   )
230     external;
231 
232   /**
233    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
234    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
235    * address. Throws if `_tokenId` is not a valid NFT.
236    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
237    * they mayb be permanently lost.
238    * @param _from The current owner of the NFT.
239    * @param _to The new owner.
240    * @param _tokenId The NFT to transfer.
241    */
242   function transferFrom(
243     address _from,
244     address _to,
245     uint256 _tokenId
246   )
247     external;
248 
249   /**
250    * @dev Set or reaffirm the approved address for an NFT.
251    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
252    * the current NFT owner, or an authorized operator of the current owner.
253    * @param _approved The new approved NFT controller.
254    * @param _tokenId The NFT to approve.
255    */
256   function approve(
257     address _approved,
258     uint256 _tokenId
259   )
260     external;
261 
262   /**
263    * @dev Enables or disables approval for a third party ("operator") to manage all of
264    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
265    * @notice The contract MUST allow multiple operators per owner.
266    * @param _operator Address to add to the set of authorized operators.
267    * @param _approved True if the operators is approved, false to revoke approval.
268    */
269   function setApprovalForAll(
270     address _operator,
271     bool _approved
272   )
273     external;
274 
275   /**
276    * @dev Get the approved address for a single NFT.
277    * @notice Throws if `_tokenId` is not a valid NFT.
278    * @param _tokenId The NFT to find the approved address for.
279    */
280   function getApproved(
281     uint256 _tokenId
282   )
283     external
284     view
285     returns (address);
286 
287   /**
288    * @dev Returns true if `_operator` is an approved operator for `_owner`, false otherwise.
289    * @param _owner The address that owns the NFTs.
290    * @param _operator The address that acts on behalf of the owner.
291    */
292   function isApprovedForAll(
293     address _owner,
294     address _operator
295   )
296     external
297     view
298     returns (bool);
299 
300 }
301 
302 // File: @0xcert/ethereum-erc721/contracts/tokens/ERC721TokenReceiver.sol
303 
304 /**
305  * @dev ERC-721 interface for accepting safe transfers. See https://goo.gl/pc9yoS.
306  */
307 interface ERC721TokenReceiver {
308 
309   /**
310    * @dev Handle the receipt of a NFT. The ERC721 smart contract calls this function on the
311    * recipient after a `transfer`. This function MAY throw to revert and reject the transfer. Return
312    * of other than the magic value MUST result in the transaction being reverted.
313    * Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))` unless throwing.
314    * @notice The contract address is always the message sender. A wallet/broker/auction application
315    * MUST implement the wallet interface if it will accept safe transfers.
316    * @param _operator The address which called `safeTransferFrom` function.
317    * @param _from The address which previously owned the token.
318    * @param _tokenId The NFT identifier which is being transferred.
319    * @param _data Additional data with no specified format.
320    */
321   function onERC721Received(
322     address _operator,
323     address _from,
324     uint256 _tokenId,
325     bytes _data
326   )
327     external
328     returns(bytes4);
329     
330 }
331 
332 // File: @0xcert/ethereum-utils/contracts/utils/AddressUtils.sol
333 
334 /**
335  * @dev Utility library of inline functions on addresses.
336  */
337 library AddressUtils {
338 
339   /**
340    * @dev Returns whether the target address is a contract.
341    * @param _addr Address to check.
342    */
343   function isContract(
344     address _addr
345   )
346     internal
347     view
348     returns (bool)
349   {
350     uint256 size;
351 
352     /**
353      * XXX Currently there is no better way to check if there is a contract in an address than to
354      * check the size of the code at that address.
355      * See https://ethereum.stackexchange.com/a/14016/36603 for more details about how this works.
356      * TODO: Check this again before the Serenity release, because all addresses will be
357      * contracts then.
358      */
359     assembly { size := extcodesize(_addr) } // solium-disable-line security/no-inline-assembly
360     return size > 0;
361   }
362 
363 }
364 
365 // File: @0xcert/ethereum-utils/contracts/utils/ERC165.sol
366 
367 /**
368  * @dev A standard for detecting smart contract interfaces. See https://goo.gl/cxQCse.
369  */
370 interface ERC165 {
371 
372   /**
373    * @dev Checks if the smart contract includes a specific interface.
374    * @notice This function uses less than 30,000 gas.
375    * @param _interfaceID The interface identifier, as specified in ERC-165.
376    */
377   function supportsInterface(
378     bytes4 _interfaceID
379   )
380     external
381     view
382     returns (bool);
383 }
384 
385 // File: @0xcert/ethereum-utils/contracts/utils/SupportsInterface.sol
386 
387 /**
388  * @dev Implementation of standard for detect smart contract interfaces.
389  */
390 contract SupportsInterface is ERC165 {
391 
392   /**
393    * @dev Mapping of supported intefraces.
394    * @notice You must not set element 0xffffffff to true.
395    */
396   mapping(bytes4 => bool) internal supportedInterfaces;
397 
398   /**
399    * @dev Contract constructor.
400    */
401   constructor()
402     public
403   {
404     supportedInterfaces[0x01ffc9a7] = true; // ERC165
405   }
406 
407   /**
408    * @dev Function to check which interfaces are suported by this contract.
409    * @param _interfaceID Id of the interface.
410    */
411   function supportsInterface(
412     bytes4 _interfaceID
413   )
414     external
415     view
416     returns (bool)
417   {
418     return supportedInterfaces[_interfaceID];
419   }
420 
421 }
422 
423 // File: @0xcert/ethereum-erc721/contracts/tokens/NFToken.sol
424 
425 /**
426  * @dev Implementation of ERC-721 non-fungible token standard.
427  */
428 contract NFToken is
429   ERC721,
430   SupportsInterface
431 {
432   using SafeMath for uint256;
433   using AddressUtils for address;
434 
435   /**
436    * @dev A mapping from NFT ID to the address that owns it.
437    */
438   mapping (uint256 => address) internal idToOwner;
439 
440   /**
441    * @dev Mapping from NFT ID to approved address.
442    */
443   mapping (uint256 => address) internal idToApprovals;
444 
445    /**
446    * @dev Mapping from owner address to count of his tokens.
447    */
448   mapping (address => uint256) internal ownerToNFTokenCount;
449 
450   /**
451    * @dev Mapping from owner address to mapping of operator addresses.
452    */
453   mapping (address => mapping (address => bool)) internal ownerToOperators;
454 
455   /**
456    * @dev Magic value of a smart contract that can recieve NFT.
457    * Equal to: bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")).
458    */
459   bytes4 constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
460 
461   /**
462    * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
463    * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
464    * number of NFTs may be created and assigned without emitting Transfer. At the time of any
465    * transfer, the approved address for that NFT (if any) is reset to none.
466    * @param _from Sender of NFT (if address is zero address it indicates token creation).
467    * @param _to Receiver of NFT (if address is zero address it indicates token destruction).
468    * @param _tokenId The NFT that got transfered.
469    */
470   event Transfer(
471     address indexed _from,
472     address indexed _to,
473     uint256 indexed _tokenId
474   );
475 
476   /**
477    * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
478    * address indicates there is no approved address. When a Transfer event emits, this also
479    * indicates that the approved address for that NFT (if any) is reset to none.
480    * @param _owner Owner of NFT.
481    * @param _approved Address that we are approving.
482    * @param _tokenId NFT which we are approving.
483    */
484   event Approval(
485     address indexed _owner,
486     address indexed _approved,
487     uint256 indexed _tokenId
488   );
489 
490   /**
491    * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
492    * all NFTs of the owner.
493    * @param _owner Owner of NFT.
494    * @param _operator Address to which we are setting operator rights.
495    * @param _approved Status of operator rights(true if operator rights are given and false if
496    * revoked).
497    */
498   event ApprovalForAll(
499     address indexed _owner,
500     address indexed _operator,
501     bool _approved
502   );
503 
504   /**
505    * @dev Guarantees that the msg.sender is an owner or operator of the given NFT.
506    * @param _tokenId ID of the NFT to validate.
507    */
508   modifier canOperate(
509     uint256 _tokenId
510   ) {
511     address tokenOwner = idToOwner[_tokenId];
512     require(tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender]);
513     _;
514   }
515 
516   /**
517    * @dev Guarantees that the msg.sender is allowed to transfer NFT.
518    * @param _tokenId ID of the NFT to transfer.
519    */
520   modifier canTransfer(
521     uint256 _tokenId
522   ) {
523     address tokenOwner = idToOwner[_tokenId];
524     require(
525       tokenOwner == msg.sender
526       || getApproved(_tokenId) == msg.sender
527       || ownerToOperators[tokenOwner][msg.sender]
528     );
529 
530     _;
531   }
532 
533   /**
534    * @dev Guarantees that _tokenId is a valid Token.
535    * @param _tokenId ID of the NFT to validate.
536    */
537   modifier validNFToken(
538     uint256 _tokenId
539   ) {
540     require(idToOwner[_tokenId] != address(0));
541     _;
542   }
543 
544   /**
545    * @dev Contract constructor.
546    */
547   constructor()
548     public
549   {
550     supportedInterfaces[0x80ac58cd] = true; // ERC721
551   }
552 
553   /**
554    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
555    * considered invalid, and this function throws for queries about the zero address.
556    * @param _owner Address for whom to query the balance.
557    */
558   function balanceOf(
559     address _owner
560   )
561     external
562     view
563     returns (uint256)
564   {
565     require(_owner != address(0));
566     return ownerToNFTokenCount[_owner];
567   }
568 
569   /**
570    * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered
571    * invalid, and queries about them do throw.
572    * @param _tokenId The identifier for an NFT.
573    */
574   function ownerOf(
575     uint256 _tokenId
576   )
577     external
578     view
579     returns (address _owner)
580   {
581     _owner = idToOwner[_tokenId];
582     require(_owner != address(0));
583   }
584 
585   /**
586    * @dev Transfers the ownership of an NFT from one address to another address.
587    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
588    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
589    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
590    * function checks if `_to` is a smart contract (code size > 0). If so, it calls `onERC721Received`
591    * on `_to` and throws if the return value is not `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
592    * @param _from The current owner of the NFT.
593    * @param _to The new owner.
594    * @param _tokenId The NFT to transfer.
595    * @param _data Additional data with no specified format, sent in call to `_to`.
596    */
597   function safeTransferFrom(
598     address _from,
599     address _to,
600     uint256 _tokenId,
601     bytes _data
602   )
603     external
604   {
605     _safeTransferFrom(_from, _to, _tokenId, _data);
606   }
607 
608   /**
609    * @dev Transfers the ownership of an NFT from one address to another address.
610    * @notice This works identically to the other function with an extra data parameter, except this
611    * function just sets data to ""
612    * @param _from The current owner of the NFT.
613    * @param _to The new owner.
614    * @param _tokenId The NFT to transfer.
615    */
616   function safeTransferFrom(
617     address _from,
618     address _to,
619     uint256 _tokenId
620   )
621     external
622   {
623     _safeTransferFrom(_from, _to, _tokenId, "");
624   }
625 
626   /**
627    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
628    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
629    * address. Throws if `_tokenId` is not a valid NFT.
630    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
631    * they maybe be permanently lost.
632    * @param _from The current owner of the NFT.
633    * @param _to The new owner.
634    * @param _tokenId The NFT to transfer.
635    */
636   function transferFrom(
637     address _from,
638     address _to,
639     uint256 _tokenId
640   )
641     external
642     canTransfer(_tokenId)
643     validNFToken(_tokenId)
644   {
645     address tokenOwner = idToOwner[_tokenId];
646     require(tokenOwner == _from);
647     require(_to != address(0));
648 
649     _transfer(_to, _tokenId);
650   }
651 
652   /**
653    * @dev Set or reaffirm the approved address for an NFT.
654    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
655    * the current NFT owner, or an authorized operator of the current owner.
656    * @param _approved Address to be approved for the given NFT ID.
657    * @param _tokenId ID of the token to be approved.
658    */
659   function approve(
660     address _approved,
661     uint256 _tokenId
662   )
663     external
664     canOperate(_tokenId)
665     validNFToken(_tokenId)
666   {
667     address tokenOwner = idToOwner[_tokenId];
668     require(_approved != tokenOwner);
669 
670     idToApprovals[_tokenId] = _approved;
671     emit Approval(tokenOwner, _approved, _tokenId);
672   }
673 
674   /**
675    * @dev Enables or disables approval for a third party ("operator") to manage all of
676    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
677    * @notice This works even if sender doesn't own any tokens at the time.
678    * @param _operator Address to add to the set of authorized operators.
679    * @param _approved True if the operators is approved, false to revoke approval.
680    */
681   function setApprovalForAll(
682     address _operator,
683     bool _approved
684   )
685     external
686   {
687     require(_operator != address(0));
688     ownerToOperators[msg.sender][_operator] = _approved;
689     emit ApprovalForAll(msg.sender, _operator, _approved);
690   }
691 
692   /**
693    * @dev Get the approved address for a single NFT.
694    * @notice Throws if `_tokenId` is not a valid NFT.
695    * @param _tokenId ID of the NFT to query the approval of.
696    */
697   function getApproved(
698     uint256 _tokenId
699   )
700     public
701     view
702     validNFToken(_tokenId)
703     returns (address)
704   {
705     return idToApprovals[_tokenId];
706   }
707 
708   /**
709    * @dev Checks if `_operator` is an approved operator for `_owner`.
710    * @param _owner The address that owns the NFTs.
711    * @param _operator The address that acts on behalf of the owner.
712    */
713   function isApprovedForAll(
714     address _owner,
715     address _operator
716   )
717     external
718     view
719     returns (bool)
720   {
721     require(_owner != address(0));
722     require(_operator != address(0));
723     return ownerToOperators[_owner][_operator];
724   }
725 
726   /**
727    * @dev Actually perform the safeTransferFrom.
728    * @param _from The current owner of the NFT.
729    * @param _to The new owner.
730    * @param _tokenId The NFT to transfer.
731    * @param _data Additional data with no specified format, sent in call to `_to`.
732    */
733   function _safeTransferFrom(
734     address _from,
735     address _to,
736     uint256 _tokenId,
737     bytes _data
738   )
739     internal
740     canTransfer(_tokenId)
741     validNFToken(_tokenId)
742   {
743     address tokenOwner = idToOwner[_tokenId];
744     require(tokenOwner == _from);
745     require(_to != address(0));
746 
747     _transfer(_to, _tokenId);
748 
749     if (_to.isContract()) {
750       bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
751       require(retval == MAGIC_ON_ERC721_RECEIVED);
752     }
753   }
754 
755   /**
756    * @dev Actually preforms the transfer.
757    * @notice Does NO checks.
758    * @param _to Address of a new owner.
759    * @param _tokenId The NFT that is being transferred.
760    */
761   function _transfer(
762     address _to,
763     uint256 _tokenId
764   )
765     private
766   {
767     address from = idToOwner[_tokenId];
768     clearApproval(_tokenId);
769 
770     removeNFToken(from, _tokenId);
771     addNFToken(_to, _tokenId);
772 
773     emit Transfer(from, _to, _tokenId);
774   }
775    
776   /**
777    * @dev Mints a new NFT.
778    * @notice This is a private function which should be called from user-implemented external
779    * mint function. Its purpose is to show and properly initialize data structures when using this
780    * implementation.
781    * @param _to The address that will own the minted NFT.
782    * @param _tokenId of the NFT to be minted by the msg.sender.
783    */
784   function _mint(
785     address _to,
786     uint256 _tokenId
787   )
788     internal
789   {
790     require(_to != address(0));
791     require(_tokenId != 0);
792     require(idToOwner[_tokenId] == address(0));
793 
794     addNFToken(_to, _tokenId);
795 
796     emit Transfer(address(0), _to, _tokenId);
797   }
798 
799   /**
800    * @dev Burns a NFT.
801    * @notice This is a private function which should be called from user-implemented external
802    * burn function. Its purpose is to show and properly initialize data structures when using this
803    * implementation.
804    * @param _owner Address of the NFT owner.
805    * @param _tokenId ID of the NFT to be burned.
806    */
807   function _burn(
808     address _owner,
809     uint256 _tokenId
810   )
811     validNFToken(_tokenId)
812     internal
813   {
814     clearApproval(_tokenId);
815     removeNFToken(_owner, _tokenId);
816     emit Transfer(_owner, address(0), _tokenId);
817   }
818 
819   /** 
820    * @dev Clears the current approval of a given NFT ID.
821    * @param _tokenId ID of the NFT to be transferred.
822    */
823   function clearApproval(
824     uint256 _tokenId
825   )
826     private
827   {
828     if(idToApprovals[_tokenId] != 0)
829     {
830       delete idToApprovals[_tokenId];
831     }
832   }
833 
834   /**
835    * @dev Removes a NFT from owner.
836    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
837    * @param _from Address from wich we want to remove the NFT.
838    * @param _tokenId Which NFT we want to remove.
839    */
840   function removeNFToken(
841     address _from,
842     uint256 _tokenId
843   )
844    internal
845   {
846     require(idToOwner[_tokenId] == _from);
847     assert(ownerToNFTokenCount[_from] > 0);
848     ownerToNFTokenCount[_from] = ownerToNFTokenCount[_from].sub(1);
849     delete idToOwner[_tokenId];
850   }
851 
852   /**
853    * @dev Assignes a new NFT to owner.
854    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
855    * @param _to Address to wich we want to add the NFT.
856    * @param _tokenId Which NFT we want to add.
857    */
858   function addNFToken(
859     address _to,
860     uint256 _tokenId
861   )
862     internal
863   {
864     require(idToOwner[_tokenId] == address(0));
865 
866     idToOwner[_tokenId] = _to;
867     ownerToNFTokenCount[_to] = ownerToNFTokenCount[_to].add(1);
868   }
869 
870 }
871 
872 // File: @0xcert/ethereum-erc721/contracts/tokens/NFTokenEnumerable.sol
873 
874 /**
875  * @dev Optional enumeration implementation for ERC-721 non-fungible token standard.
876  */
877 contract NFTokenEnumerable is
878   NFToken,
879   ERC721Enumerable
880 {
881 
882   /**
883    * @dev Array of all NFT IDs.
884    */
885   uint256[] internal tokens;
886 
887   /**
888    * @dev Mapping from token ID its index in global tokens array.
889    */
890   mapping(uint256 => uint256) internal idToIndex;
891 
892   /**
893    * @dev Mapping from owner to list of owned NFT IDs.
894    */
895   mapping(address => uint256[]) internal ownerToIds;
896 
897   /**
898    * @dev Mapping from NFT ID to its index in the owner tokens list.
899    */
900   mapping(uint256 => uint256) internal idToOwnerIndex;
901 
902   /**
903    * @dev Contract constructor.
904    */
905   constructor()
906     public
907   {
908     supportedInterfaces[0x780e9d63] = true; // ERC721Enumerable
909   }
910 
911   /**
912    * @dev Mints a new NFT.
913    * @notice This is a private function which should be called from user-implemented external
914    * mint function. Its purpose is to show and properly initialize data structures when using this
915    * implementation.
916    * @param _to The address that will own the minted NFT.
917    * @param _tokenId of the NFT to be minted by the msg.sender.
918    */
919   function _mint(
920     address _to,
921     uint256 _tokenId
922   )
923     internal
924   {
925     super._mint(_to, _tokenId);
926     tokens.push(_tokenId);
927     idToIndex[_tokenId] = tokens.length.sub(1);
928   }
929 
930   /**
931    * @dev Burns a NFT.
932    * @notice This is a private function which should be called from user-implemented external
933    * burn function. Its purpose is to show and properly initialize data structures when using this
934    * implementation.
935    * @param _owner Address of the NFT owner.
936    * @param _tokenId ID of the NFT to be burned.
937    */
938   function _burn(
939     address _owner,
940     uint256 _tokenId
941   )
942     internal
943   {
944     super._burn(_owner, _tokenId);
945     assert(tokens.length > 0);
946 
947     uint256 tokenIndex = idToIndex[_tokenId];
948     // Sanity check. This could be removed in the future.
949     assert(tokens[tokenIndex] == _tokenId);
950     uint256 lastTokenIndex = tokens.length.sub(1);
951     uint256 lastToken = tokens[lastTokenIndex];
952 
953     tokens[tokenIndex] = lastToken;
954 
955     tokens.length--;
956     // Consider adding a conditional check for the last token in order to save GAS.
957     idToIndex[lastToken] = tokenIndex;
958     idToIndex[_tokenId] = 0;
959   }
960 
961   /**
962    * @dev Removes a NFT from an address.
963    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
964    * @param _from Address from wich we want to remove the NFT.
965    * @param _tokenId Which NFT we want to remove.
966    */
967   function removeNFToken(
968     address _from,
969     uint256 _tokenId
970   )
971    internal
972   {
973     super.removeNFToken(_from, _tokenId);
974     assert(ownerToIds[_from].length > 0);
975 
976     uint256 tokenToRemoveIndex = idToOwnerIndex[_tokenId];
977     uint256 lastTokenIndex = ownerToIds[_from].length.sub(1);
978     uint256 lastToken = ownerToIds[_from][lastTokenIndex];
979 
980     ownerToIds[_from][tokenToRemoveIndex] = lastToken;
981 
982     ownerToIds[_from].length--;
983     // Consider adding a conditional check for the last token in order to save GAS.
984     idToOwnerIndex[lastToken] = tokenToRemoveIndex;
985     idToOwnerIndex[_tokenId] = 0;
986   }
987 
988   /**
989    * @dev Assignes a new NFT to an address.
990    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
991    * @param _to Address to wich we want to add the NFT.
992    * @param _tokenId Which NFT we want to add.
993    */
994   function addNFToken(
995     address _to,
996     uint256 _tokenId
997   )
998     internal
999   {
1000     super.addNFToken(_to, _tokenId);
1001 
1002     uint256 length = ownerToIds[_to].length;
1003     ownerToIds[_to].push(_tokenId);
1004     idToOwnerIndex[_tokenId] = length;
1005   }
1006 
1007   /**
1008    * @dev Returns the count of all existing NFTokens.
1009    */
1010   function totalSupply()
1011     external
1012     view
1013     returns (uint256)
1014   {
1015     return tokens.length;
1016   }
1017 
1018   /**
1019    * @dev Returns NFT ID by its index.
1020    * @param _index A counter less than `totalSupply()`.
1021    */
1022   function tokenByIndex(
1023     uint256 _index
1024   )
1025     external
1026     view
1027     returns (uint256)
1028   {
1029     require(_index < tokens.length);
1030     // Sanity check. This could be removed in the future.
1031     assert(idToIndex[tokens[_index]] == _index);
1032     return tokens[_index];
1033   }
1034 
1035   /**
1036    * @dev returns the n-th NFT ID from a list of owner's tokens.
1037    * @param _owner Token owner's address.
1038    * @param _index Index number representing n-th token in owner's list of tokens.
1039    */
1040   function tokenOfOwnerByIndex(
1041     address _owner,
1042     uint256 _index
1043   )
1044     external
1045     view
1046     returns (uint256)
1047   {
1048     require(_index < ownerToIds[_owner].length);
1049     return ownerToIds[_owner][_index];
1050   }
1051 
1052 }
1053 
1054 // File: @0xcert/ethereum-erc721/contracts/tokens/ERC721Metadata.sol
1055 
1056 /**
1057  * @dev Optional metadata extension for ERC-721 non-fungible token standard.
1058  * See https://goo.gl/pc9yoS.
1059  */
1060 interface ERC721Metadata {
1061 
1062   /**
1063    * @dev Returns a descriptive name for a collection of NFTs in this contract.
1064    */
1065   function name()
1066     external
1067     view
1068     returns (string _name);
1069 
1070   /**
1071    * @dev Returns a abbreviated name for a collection of NFTs in this contract.
1072    */
1073   function symbol()
1074     external
1075     view
1076     returns (string _symbol);
1077 
1078   /**
1079    * @dev Returns a distinct Uniform Resource Identifier (URI) for a given asset. It Throws if
1080    * `_tokenId` is not a valid NFT. URIs are defined in RFC3986. The URI may point to a JSON file
1081    * that conforms to the "ERC721 Metadata JSON Schema".
1082    */
1083   function tokenURI(uint256 _tokenId)
1084     external
1085     view
1086     returns (string);
1087 
1088 }
1089 
1090 // File: @0xcert/ethereum-erc721/contracts/tokens/NFTokenMetadata.sol
1091 
1092 /**
1093  * @dev Optional metadata implementation for ERC-721 non-fungible token standard.
1094  */
1095 contract NFTokenMetadata is
1096   NFToken,
1097   ERC721Metadata
1098 {
1099 
1100   /**
1101    * @dev A descriptive name for a collection of NFTs.
1102    */
1103   string internal nftName;
1104 
1105   /**
1106    * @dev An abbreviated name for NFTokens.
1107    */
1108   string internal nftSymbol;
1109 
1110   /**
1111    * @dev Mapping from NFT ID to metadata uri.
1112    */
1113   mapping (uint256 => string) internal idToUri;
1114 
1115   /**
1116    * @dev Contract constructor.
1117    * @notice When implementing this contract don't forget to set nftName and nftSymbol.
1118    */
1119   constructor()
1120     public
1121   {
1122     supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
1123   }
1124 
1125   /**
1126    * @dev Burns a NFT.
1127    * @notice This is a internal function which should be called from user-implemented external
1128    * burn function. Its purpose is to show and properly initialize data structures when using this
1129    * implementation.
1130    * @param _owner Address of the NFT owner.
1131    * @param _tokenId ID of the NFT to be burned.
1132    */
1133   function _burn(
1134     address _owner,
1135     uint256 _tokenId
1136   )
1137     internal
1138   {
1139     super._burn(_owner, _tokenId);
1140 
1141     if (bytes(idToUri[_tokenId]).length != 0) {
1142       delete idToUri[_tokenId];
1143     }
1144   }
1145 
1146   /**
1147    * @dev Set a distinct URI (RFC 3986) for a given NFT ID.
1148    * @notice this is a internal function which should be called from user-implemented external
1149    * function. Its purpose is to show and properly initialize data structures when using this
1150    * implementation.
1151    * @param _tokenId Id for which we want uri.
1152    * @param _uri String representing RFC 3986 URI.
1153    */
1154   function _setTokenUri(
1155     uint256 _tokenId,
1156     string _uri
1157   )
1158     validNFToken(_tokenId)
1159     internal
1160   {
1161     idToUri[_tokenId] = _uri;
1162   }
1163 
1164   /**
1165    * @dev Returns a descriptive name for a collection of NFTokens.
1166    */
1167   function name()
1168     external
1169     view
1170     returns (string _name)
1171   {
1172     _name = nftName;
1173   }
1174 
1175   /**
1176    * @dev Returns an abbreviated name for NFTokens.
1177    */
1178   function symbol()
1179     external
1180     view
1181     returns (string _symbol)
1182   {
1183     _symbol = nftSymbol;
1184   }
1185 
1186   /**
1187    * @dev A distinct URI (RFC 3986) for a given NFT.
1188    * @param _tokenId Id for which we want uri.
1189    */
1190   function tokenURI(
1191     uint256 _tokenId
1192   )
1193     validNFToken(_tokenId)
1194     external
1195     view
1196     returns (string)
1197   {
1198     return idToUri[_tokenId];
1199   }
1200 
1201 }
1202 
1203 // File: @0xcert/ethereum-utils/contracts/ownership/Ownable.sol
1204 
1205 /**
1206  * @dev The contract has an owner address, and provides basic authorization control whitch
1207  * simplifies the implementation of user permissions. This contract is based on the source code
1208  * at https://goo.gl/n2ZGVt.
1209  */
1210 contract Ownable {
1211   address public owner;
1212 
1213   /**
1214    * @dev An event which is triggered when the owner is changed.
1215    * @param previousOwner The address of the previous owner.
1216    * @param newOwner The address of the new owner.
1217    */
1218   event OwnershipTransferred(
1219     address indexed previousOwner,
1220     address indexed newOwner
1221   );
1222 
1223   /**
1224    * @dev The constructor sets the original `owner` of the contract to the sender account.
1225    */
1226   constructor()
1227     public
1228   {
1229     owner = msg.sender;
1230   }
1231 
1232   /**
1233    * @dev Throws if called by any account other than the owner.
1234    */
1235   modifier onlyOwner() {
1236     require(msg.sender == owner);
1237     _;
1238   }
1239 
1240   /**
1241    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1242    * @param _newOwner The address to transfer ownership to.
1243    */
1244   function transferOwnership(
1245     address _newOwner
1246   )
1247     onlyOwner
1248     public
1249   {
1250     require(_newOwner != address(0));
1251     emit OwnershipTransferred(owner, _newOwner);
1252     owner = _newOwner;
1253   }
1254 
1255 }
1256 
1257 // File: @0xcert/ethereum-xcert/contracts/tokens/Xcert.sol
1258 
1259 /**
1260  * @dev Xcert implementation.
1261  */
1262 contract Xcert is NFTokenEnumerable, NFTokenMetadata, Ownable {
1263   using SafeMath for uint256;
1264   using AddressUtils for address;
1265 
1266   /**
1267    * @dev Unique ID which determines each Xcert smart contract type by its JSON convention.
1268    * @notice Calculated as bytes4(keccak256(jsonSchema)).
1269    */
1270   bytes4 internal nftConventionId;
1271 
1272   /**
1273    * @dev Maps NFT ID to proof.
1274    */
1275   mapping (uint256 => string) internal idToProof;
1276 
1277   /**
1278    * @dev Maps NFT ID to protocol config.
1279    */
1280   mapping (uint256 => bytes32[]) internal config;
1281 
1282   /**
1283    * @dev Maps NFT ID to convention data.
1284    */
1285   mapping (uint256 => bytes32[]) internal data;
1286 
1287   /**
1288    * @dev Maps address to authorization of contract.
1289    */
1290   mapping (address => bool) internal addressToAuthorized;
1291 
1292   /**
1293    * @dev Emits when an address is authorized to some contract control or the authorization is revoked.
1294    * The _target has some contract controle like minting new NFTs.
1295    * @param _target Address to set authorized state.
1296    * @param _authorized True if the _target is authorised, false to revoke authorization.
1297    */
1298   event AuthorizedAddress(
1299     address indexed _target,
1300     bool _authorized
1301   );
1302 
1303   /**
1304    * @dev Guarantees that msg.sender is allowed to mint a new NFT.
1305    */
1306   modifier isAuthorized() {
1307     require(msg.sender == owner || addressToAuthorized[msg.sender]);
1308     _;
1309   }
1310 
1311   /**
1312    * @dev Contract constructor.
1313    * @notice When implementing this contract don't forget to set nftConventionId, nftName and
1314    * nftSymbol.
1315    */
1316   constructor()
1317     public
1318   {
1319     supportedInterfaces[0x6be14f75] = true; // Xcert
1320   }
1321 
1322   /**
1323    * @dev Mints a new NFT.
1324    * @param _to The address that will own the minted NFT.
1325    * @param _id The NFT to be minted by the msg.sender.
1326    * @param _uri An URI pointing to NFT metadata.
1327    * @param _proof Cryptographic asset imprint.
1328    * @param _config Array of protocol config values where 0 index represents token expiration
1329    * timestamp, other indexes are not yet definied but are ready for future xcert upgrades.
1330    * @param _data Array of convention data values.
1331    */
1332   function mint(
1333     address _to,
1334     uint256 _id,
1335     string _uri,
1336     string _proof,
1337     bytes32[] _config,
1338     bytes32[] _data
1339   )
1340     external
1341     isAuthorized()
1342   {
1343     require(_config.length > 0);
1344     require(bytes(_proof).length > 0);
1345     super._mint(_to, _id);
1346     super._setTokenUri(_id, _uri);
1347     idToProof[_id] = _proof;
1348     config[_id] = _config;
1349     data[_id] = _data;
1350   }
1351 
1352   /**
1353    * @dev Returns a bytes4 of keccak256 of json schema representing 0xcert protocol convention.
1354    */
1355   function conventionId()
1356     external
1357     view
1358     returns (bytes4 _conventionId)
1359   {
1360     _conventionId = nftConventionId;
1361   }
1362 
1363   /**
1364    * @dev Returns proof for NFT.
1365    * @param _tokenId Id of the NFT.
1366    */
1367   function tokenProof(
1368     uint256 _tokenId
1369   )
1370     validNFToken(_tokenId)
1371     external
1372     view
1373     returns(string)
1374   {
1375     return idToProof[_tokenId];
1376   }
1377 
1378   /**
1379    * @dev Returns convention data value for a given index field.
1380    * @param _tokenId Id of the NFT we want to get value for key.
1381    * @param _index for which we want to get value.
1382    */
1383   function tokenDataValue(
1384     uint256 _tokenId,
1385     uint256 _index
1386   )
1387     validNFToken(_tokenId)
1388     public
1389     view
1390     returns(bytes32 value)
1391   {
1392     require(_index < data[_tokenId].length);
1393     value = data[_tokenId][_index];
1394   }
1395 
1396   /**
1397    * @dev Returns expiration date from 0 index of token config values.
1398    * @param _tokenId Id of the NFT we want to get expiration time of.
1399    */
1400   function tokenExpirationTime(
1401     uint256 _tokenId
1402   )
1403     validNFToken(_tokenId)
1404     external
1405     view
1406     returns(bytes32)
1407   {
1408     return config[_tokenId][0];
1409   }
1410 
1411   /**
1412    * @dev Sets authorised address for minting.
1413    * @param _target Address to set authorized state.
1414    * @param _authorized True if the _target is authorised, false to revoke authorization.
1415    */
1416   function setAuthorizedAddress(
1417     address _target,
1418     bool _authorized
1419   )
1420     onlyOwner
1421     external
1422   {
1423     require(_target != address(0));
1424     addressToAuthorized[_target] = _authorized;
1425     emit AuthorizedAddress(_target, _authorized);
1426   }
1427 
1428   /**
1429    * @dev Sets mint authorised address.
1430    * @param _target Address for which we want to check if it is authorized.
1431    * @return Is authorized or not.
1432    */
1433   function isAuthorizedAddress(
1434     address _target
1435   )
1436     external
1437     view
1438     returns (bool)
1439   {
1440     require(_target != address(0));
1441     return addressToAuthorized[_target];
1442   }
1443 }
1444 
1445 // File: @0xcert/ethereum-erc20/contracts/tokens/ERC20.sol
1446 
1447 /**
1448  * @title A standard interface for tokens.
1449  */
1450 interface ERC20 {
1451 
1452   /**
1453    * @dev Returns the name of the token.
1454    */
1455   function name()
1456     external
1457     view
1458     returns (string _name);
1459 
1460   /**
1461    * @dev Returns the symbol of the token.
1462    */
1463   function symbol()
1464     external
1465     view
1466     returns (string _symbol);
1467 
1468   /**
1469    * @dev Returns the number of decimals the token uses.
1470    */
1471   function decimals()
1472     external
1473     view
1474     returns (uint8 _decimals);
1475 
1476   /**
1477    * @dev Returns the total token supply.
1478    */
1479   function totalSupply()
1480     external
1481     view
1482     returns (uint256 _totalSupply);
1483 
1484   /**
1485    * @dev Returns the account balance of another account with address _owner.
1486    * @param _owner The address from which the balance will be retrieved.
1487    */
1488   function balanceOf(
1489     address _owner
1490   )
1491     external
1492     view
1493     returns (uint256 _balance);
1494 
1495   /**
1496    * @dev Transfers _value amount of tokens to address _to, and MUST fire the Transfer event. The
1497    * function SHOULD throw if the _from account balance does not have enough tokens to spend.
1498    * @param _to The address of the recipient.
1499    * @param _value The amount of token to be transferred.
1500    */
1501   function transfer(
1502     address _to,
1503     uint256 _value
1504   )
1505     external
1506     returns (bool _success);
1507 
1508   /**
1509    * @dev Transfers _value amount of tokens from address _from to address _to, and MUST fire the
1510    * Transfer event.
1511    * @param _from The address of the sender.
1512    * @param _to The address of the recipient.
1513    * @param _value The amount of token to be transferred.
1514    */
1515   function transferFrom(
1516     address _from,
1517     address _to,
1518     uint256 _value
1519   )
1520     external
1521     returns (bool _success);
1522 
1523   /**
1524    * @dev Allows _spender to withdraw from your account multiple times, up to
1525    * the _value amount. If this function is called again it overwrites the current
1526    * allowance with _value.
1527    * @param _spender The address of the account able to transfer the tokens.
1528    * @param _value The amount of tokens to be approved for transfer.
1529    */
1530   function approve(
1531     address _spender,
1532     uint256 _value
1533   )
1534     external
1535     returns (bool _success);
1536 
1537   /**
1538    * @dev Returns the amount which _spender is still allowed to withdraw from _owner.
1539    * @param _owner The address of the account owning tokens.
1540    * @param _spender The address of the account able to transfer the tokens.
1541    */
1542   function allowance(
1543     address _owner,
1544     address _spender
1545   )
1546     external
1547     view
1548     returns (uint256 _remaining);
1549 
1550   /**
1551    * @dev Triggers when tokens are transferred, including zero value transfers.
1552    */
1553   event Transfer(
1554     address indexed _from,
1555     address indexed _to,
1556     uint256 _value
1557   );
1558 
1559   /**
1560    * @dev Triggers on any successful call to approve(address _spender, uint256 _value).
1561    */
1562   event Approval(
1563     address indexed _owner,
1564     address indexed _spender,
1565     uint256 _value
1566   );
1567 
1568 }
1569 
1570 // File: @0xcert/ethereum-erc20/contracts/tokens/Token.sol
1571 
1572 /**
1573  * @title ERC20 standard token implementation.
1574  * @dev Standard ERC20 token. This contract follows the implementation at https://goo.gl/mLbAPJ.
1575  */
1576 contract Token is
1577   ERC20
1578 {
1579   using SafeMath for uint256;
1580 
1581   /**
1582    * Token name.
1583    */
1584   string internal tokenName;
1585 
1586   /**
1587    * Token symbol.
1588    */
1589   string internal tokenSymbol;
1590 
1591   /**
1592    * Number of decimals.
1593    */
1594   uint8 internal tokenDecimals;
1595 
1596   /**
1597    * Total supply of tokens.
1598    */
1599   uint256 internal tokenTotalSupply;
1600 
1601   /**
1602    * Balance information map.
1603    */
1604   mapping (address => uint256) internal balances;
1605 
1606   /**
1607    * Token allowance mapping.
1608    */
1609   mapping (address => mapping (address => uint256)) internal allowed;
1610 
1611   /**
1612    * @dev Trigger when tokens are transferred, including zero value transfers.
1613    */
1614   event Transfer(
1615     address indexed _from,
1616     address indexed _to,
1617     uint256 _value
1618   );
1619 
1620   /**
1621    * @dev Trigger on any successful call to approve(address _spender, uint256 _value).
1622    */
1623   event Approval(
1624     address indexed _owner,
1625     address indexed _spender,
1626     uint256 _value
1627   );
1628 
1629   /**
1630    * @dev Returns the name of the token.
1631    */
1632   function name()
1633     external
1634     view
1635     returns (string _name)
1636   {
1637     _name = tokenName;
1638   }
1639 
1640   /**
1641    * @dev Returns the symbol of the token.
1642    */
1643   function symbol()
1644     external
1645     view
1646     returns (string _symbol)
1647   {
1648     _symbol = tokenSymbol;
1649   }
1650 
1651   /**
1652    * @dev Returns the number of decimals the token uses.
1653    */
1654   function decimals()
1655     external
1656     view
1657     returns (uint8 _decimals)
1658   {
1659     _decimals = tokenDecimals;
1660   }
1661 
1662   /**
1663    * @dev Returns the total token supply.
1664    */
1665   function totalSupply()
1666     external
1667     view
1668     returns (uint256 _totalSupply)
1669   {
1670     _totalSupply = tokenTotalSupply;
1671   }
1672 
1673   /**
1674    * @dev Returns the account balance of another account with address _owner.
1675    * @param _owner The address from which the balance will be retrieved.
1676    */
1677   function balanceOf(
1678     address _owner
1679   )
1680     external
1681     view
1682     returns (uint256 _balance)
1683   {
1684     _balance = balances[_owner];
1685   }
1686 
1687   /**
1688    * @dev Transfers _value amount of tokens to address _to, and MUST fire the Transfer event. The
1689    * function SHOULD throw if the _from account balance does not have enough tokens to spend.
1690    * @param _to The address of the recipient.
1691    * @param _value The amount of token to be transferred.
1692    */
1693   function transfer(
1694     address _to,
1695     uint256 _value
1696   )
1697     public
1698     returns (bool _success)
1699   {
1700     require(_value <= balances[msg.sender]);
1701 
1702     balances[msg.sender] = balances[msg.sender].sub(_value);
1703     balances[_to] = balances[_to].add(_value);
1704 
1705     emit Transfer(msg.sender, _to, _value);
1706     _success = true;
1707   }
1708 
1709   /**
1710    * @dev Allows _spender to withdraw from your account multiple times, up to the _value amount. If
1711    * this function is called again it overwrites the current allowance with _value.
1712    * @param _spender The address of the account able to transfer the tokens.
1713    * @param _value The amount of tokens to be approved for transfer.
1714    */
1715   function approve(
1716     address _spender,
1717     uint256 _value
1718   )
1719     public
1720     returns (bool _success)
1721   {
1722     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
1723 
1724     allowed[msg.sender][_spender] = _value;
1725 
1726     emit Approval(msg.sender, _spender, _value);
1727     _success = true;
1728   }
1729 
1730   /**
1731    * @dev Returns the amount which _spender is still allowed to withdraw from _owner.
1732    * @param _owner The address of the account owning tokens.
1733    * @param _spender The address of the account able to transfer the tokens.
1734    */
1735   function allowance(
1736     address _owner,
1737     address _spender
1738   )
1739     external
1740     view
1741     returns (uint256 _remaining)
1742   {
1743     _remaining = allowed[_owner][_spender];
1744   }
1745 
1746   /**
1747    * @dev Transfers _value amount of tokens from address _from to address _to, and MUST fire the
1748    * Transfer event.
1749    * @param _from The address of the sender.
1750    * @param _to The address of the recipient.
1751    * @param _value The amount of token to be transferred.
1752    */
1753   function transferFrom(
1754     address _from,
1755     address _to,
1756     uint256 _value
1757   )
1758     public
1759     returns (bool _success)
1760   {
1761     require(_value <= balances[_from]);
1762     require(_value <= allowed[_from][msg.sender]);
1763 
1764     balances[_from] = balances[_from].sub(_value);
1765     balances[_to] = balances[_to].add(_value);
1766     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1767 
1768     emit Transfer(_from, _to, _value);
1769     _success = true;
1770   }
1771 
1772 }
1773 
1774 // File: @0xcert/ethereum-zxc/contracts/tokens/Zxc.sol
1775 
1776 /*
1777  * @title ZXC protocol token.
1778  * @dev Standard ERC20 token used by the 0xcert protocol. This contract follows the implementation
1779  * at https://goo.gl/twbPwp.
1780  */
1781 contract Zxc is
1782   Token,
1783   Ownable
1784 {
1785   using SafeMath for uint256;
1786 
1787   /**
1788    * Transfer feature state.
1789    */
1790   bool internal transferEnabled;
1791 
1792   /**
1793    * Crowdsale smart contract address.
1794    */
1795   address public crowdsaleAddress;
1796 
1797   /**
1798    * @dev An event which is triggered when tokens are burned.
1799    * @param _burner The address which burns tokens.
1800    * @param _value The amount of burned tokens.
1801    */
1802   event Burn(
1803     address indexed _burner,
1804     uint256 _value
1805   );
1806 
1807   /**
1808    * @dev Assures that the provided address is a valid destination to transfer tokens to.
1809    * @param _to Target address.
1810    */
1811   modifier validDestination(
1812     address _to
1813   )
1814   {
1815     require(_to != address(0x0));
1816     require(_to != address(this));
1817     require(_to != address(crowdsaleAddress));
1818     _;
1819   }
1820 
1821   /**
1822    * @dev Assures that tokens can be transfered.
1823    */
1824   modifier onlyWhenTransferAllowed()
1825   {
1826     require(transferEnabled || msg.sender == crowdsaleAddress);
1827     _;
1828   }
1829 
1830   /**
1831    * @dev Contract constructor.
1832    */
1833   constructor()
1834     public
1835   {
1836     tokenName = "0xcert Protocol Token";
1837     tokenSymbol = "ZXC";
1838     tokenDecimals = 18;
1839     tokenTotalSupply = 400000000000000000000000000;
1840     transferEnabled = false;
1841 
1842     balances[owner] = tokenTotalSupply;
1843     emit Transfer(address(0x0), owner, tokenTotalSupply);
1844   }
1845 
1846   /**
1847    * @dev Transfers token to a specified address.
1848    * @param _to The address to transfer to.
1849    * @param _value The amount to be transferred.
1850    */
1851   function transfer(
1852     address _to,
1853     uint256 _value
1854   )
1855     onlyWhenTransferAllowed()
1856     validDestination(_to)
1857     public
1858     returns (bool _success)
1859   {
1860     _success = super.transfer(_to, _value);
1861   }
1862 
1863   /**
1864    * @dev Transfers tokens from one address to another.
1865    * @param _from address The address which you want to send tokens from.
1866    * @param _to address The address which you want to transfer to.
1867    * @param _value uint256 The amount of tokens to be transferred.
1868    */
1869   function transferFrom(
1870     address _from,
1871     address _to,
1872     uint256 _value
1873   )
1874     onlyWhenTransferAllowed()
1875     validDestination(_to)
1876     public
1877     returns (bool _success)
1878   {
1879     _success = super.transferFrom(_from, _to, _value);
1880   }
1881 
1882   /**
1883    * @dev Enables token transfers.
1884    */
1885   function enableTransfer()
1886     onlyOwner()
1887     external
1888   {
1889     transferEnabled = true;
1890   }
1891 
1892   /**
1893    * @dev Burns a specific amount of tokens. This function is based on BurnableToken implementation
1894    * at goo.gl/GZEhaq.
1895    * @notice Only owner is allowed to perform this operation.
1896    * @param _value The amount of tokens to be burned.
1897    */
1898   function burn(
1899     uint256 _value
1900   )
1901     onlyOwner()
1902     external
1903   {
1904     require(_value <= balances[msg.sender]);
1905 
1906     balances[owner] = balances[owner].sub(_value);
1907     tokenTotalSupply = tokenTotalSupply.sub(_value);
1908 
1909     emit Burn(owner, _value);
1910     emit Transfer(owner, address(0x0), _value);
1911   }
1912 
1913   /**
1914     * @dev Set crowdsale address which can distribute tokens even when onlyWhenTransferAllowed is
1915     * false.
1916     * @param crowdsaleAddr Address of token offering contract.
1917     */
1918   function setCrowdsaleAddress(
1919     address crowdsaleAddr
1920   )
1921     external
1922     onlyOwner()
1923   {
1924     crowdsaleAddress = crowdsaleAddr;
1925   }
1926 
1927 }
1928 
1929 // File: contracts/crowdsale/ZxcCrowdsale.sol
1930 
1931 /**
1932  * @title ZXC crowdsale contract.
1933  * @dev Crowdsale contract for distributing ZXC tokens.
1934  * Start timestamps for the token sale stages (start dates are inclusive, end exclusive):
1935  *   - Token presale with 10% bonus: 2018/06/26 - 2018/07/04
1936  *   - Token sale with 5% bonus: 2018/07/04 - 2018/07/05
1937  *   - Token sale with 0% bonus: 2018/07/05 - 2018/07/18
1938  */
1939 contract ZxcCrowdsale
1940 {
1941   using SafeMath for uint256;
1942 
1943   /**
1944    * @dev Token being sold.
1945    */
1946   Zxc public token;
1947 
1948   /**
1949    * @dev Xcert KYC token.
1950    */
1951   Xcert public xcertKyc;
1952 
1953   /**
1954    * @dev Start time of the presale.
1955    */
1956   uint256 public startTimePresale;
1957 
1958   /**
1959    * @dev Start time of the token sale with bonus.
1960    */
1961   uint256 public startTimeSaleWithBonus;
1962 
1963   /**
1964    * @dev Start time of the token sale with no bonus.
1965    */
1966   uint256 public startTimeSaleNoBonus;
1967 
1968   /**
1969    * @dev Presale bonus expressed as percentage integer (10% = 10).
1970    */
1971   uint256 public bonusPresale;
1972 
1973   /**
1974    * @dev Token sale bonus expressed as percentage integer (10% = 10).
1975    */
1976   uint256 public bonusSale;
1977 
1978   /**
1979    * @dev End timestamp to end the crowdsale.
1980    */
1981   uint256 public endTime;
1982 
1983   /**
1984    * @dev Minimum required wei deposit for public presale period.
1985    */
1986   uint256 public minimumPresaleWeiDeposit;
1987 
1988   /**
1989    * @dev Total amount of ZXC tokens offered for the presale.
1990    */
1991   uint256 public preSaleZxcCap;
1992 
1993   /**
1994    * @dev Total supply of ZXC tokens for the sale.
1995    */
1996   uint256 public crowdSaleZxcSupply;
1997 
1998   /**
1999    * @dev Amount of ZXC tokens sold.
2000    */
2001   uint256 public zxcSold;
2002 
2003   /**
2004    * @dev Address where funds are collected.
2005    */
2006   address public wallet;
2007 
2008   /**
2009    * @dev How many token units buyer gets per wei.
2010    */
2011   uint256 public rate;
2012 
2013   /**
2014    * @dev An event which is triggered when tokens are bought.
2015    * @param _from The address sending tokens.
2016    * @param _to The address receiving tokens.
2017    * @param _weiAmount Purchase amount in wei.
2018    * @param _tokenAmount The amount of purchased tokens.
2019    */
2020   event TokenPurchase(
2021     address indexed _from,
2022     address indexed _to,
2023     uint256 _weiAmount,
2024     uint256 _tokenAmount
2025   );
2026 
2027   /**
2028    * @dev Contract constructor.
2029    * @param _walletAddress Address of the wallet which collects funds.
2030    * @param _tokenAddress Address of the ZXC token contract.
2031    * @param _xcertKycAddress Address of the Xcert KYC token contract.
2032    * @param _startTimePresale Start time of presale stage.
2033    * @param _startTimeSaleWithBonus Start time of public sale stage with bonus.
2034    * @param _startTimeSaleNoBonus Start time of public sale stage with no bonus.
2035    * @param _endTime Time when sale ends.
2036    * @param _rate ZXC/ETH exchange rate.
2037    * @param _presaleZxcCap Maximum number of ZXC offered for the presale.
2038    * @param _crowdSaleZxcSupply Supply of ZXC tokens offered for the sale. Includes _presaleZxcCap.
2039    * @param _bonusPresale Bonus token percentage for presale.
2040    * @param _bonusSale Bonus token percentage for public sale stage with bonus.
2041    * @param _minimumPresaleWeiDeposit Minimum required deposit in wei.
2042    */
2043   constructor(
2044     address _walletAddress,
2045     address _tokenAddress,
2046     address _xcertKycAddress,
2047     uint256 _startTimePresale,  // 1529971200: date -d '2018-06-26 00:00:00 UTC' +%s
2048     uint256 _startTimeSaleWithBonus, // 1530662400: date -d '2018-07-04 00:00:00 UTC' +%s
2049     uint256 _startTimeSaleNoBonus,  //1530748800: date -d '2018-07-05 00:00:00 UTC' +%s
2050     uint256 _endTime,  // 1531872000: date -d '2018-07-18 00:00:00 UTC' +%s
2051     uint256 _rate,  // 10000: 1 ETH = 10,000 ZXC
2052     uint256 _presaleZxcCap, // 195M
2053     uint256 _crowdSaleZxcSupply, // 250M
2054     uint256 _bonusPresale,  // 10 (%)
2055     uint256 _bonusSale,  // 5 (%)
2056     uint256 _minimumPresaleWeiDeposit  // 1 ether;
2057   )
2058     public
2059   {
2060     require(_walletAddress != address(0));
2061     require(_tokenAddress != address(0));
2062     require(_xcertKycAddress != address(0));
2063     require(_tokenAddress != _walletAddress);
2064     require(_tokenAddress != _xcertKycAddress);
2065     require(_xcertKycAddress != _walletAddress);
2066 
2067     token = Zxc(_tokenAddress);
2068     xcertKyc = Xcert(_xcertKycAddress);
2069 
2070     uint8 _tokenDecimals = token.decimals();
2071     require(_tokenDecimals == 18);  // Sanity check.
2072     wallet = _walletAddress;
2073 
2074     // Bonus should be > 0% and <= 100%
2075     require(_bonusPresale > 0 && _bonusPresale <= 100);
2076     require(_bonusSale > 0 && _bonusSale <= 100);
2077 
2078     bonusPresale = _bonusPresale;
2079     bonusSale = _bonusSale;
2080 
2081     require(_startTimeSaleWithBonus > _startTimePresale);
2082     require(_startTimeSaleNoBonus > _startTimeSaleWithBonus);
2083 
2084     startTimePresale = _startTimePresale;
2085     startTimeSaleWithBonus = _startTimeSaleWithBonus;
2086     startTimeSaleNoBonus = _startTimeSaleNoBonus;
2087     endTime = _endTime;
2088 
2089     require(_rate > 0);
2090     rate = _rate;
2091 
2092     require(_crowdSaleZxcSupply > 0);
2093     require(token.totalSupply() >= _crowdSaleZxcSupply);
2094     crowdSaleZxcSupply = _crowdSaleZxcSupply;
2095 
2096     require(_presaleZxcCap > 0 && _presaleZxcCap <= _crowdSaleZxcSupply);
2097     preSaleZxcCap = _presaleZxcCap;
2098 
2099     zxcSold = 71157402800000000000000000;
2100 
2101     require(_minimumPresaleWeiDeposit > 0);
2102     minimumPresaleWeiDeposit = _minimumPresaleWeiDeposit;
2103   }
2104 
2105   /**
2106    * @dev Fallback function can be used to buy tokens.
2107    */
2108   function()
2109     external
2110     payable
2111   {
2112     buyTokens();
2113   }
2114 
2115   /**
2116    * @dev Low level token purchase function.
2117    */
2118   function buyTokens()
2119     public
2120     payable
2121   {
2122     uint256 tokens;
2123 
2124     // Sender needs Xcert KYC token.
2125     uint256 balance = xcertKyc.balanceOf(msg.sender);
2126     require(balance > 0);
2127 
2128     uint256 tokenId = xcertKyc.tokenOfOwnerByIndex(msg.sender, balance - 1);
2129     uint256 kycLevel = uint(xcertKyc.tokenDataValue(tokenId, 0));
2130 
2131     if (isInTimeRange(startTimePresale, startTimeSaleWithBonus)) {
2132       require(kycLevel > 1);
2133       require(msg.value >= minimumPresaleWeiDeposit);
2134       tokens = getTokenAmount(msg.value, bonusPresale);
2135       require(zxcSold.add(tokens) <= preSaleZxcCap);
2136     }
2137     else if (isInTimeRange(startTimeSaleWithBonus, startTimeSaleNoBonus)) {
2138       require(kycLevel > 0);
2139       tokens = getTokenAmount(msg.value, bonusSale);
2140     }
2141     else if (isInTimeRange(startTimeSaleNoBonus, endTime)) {
2142       require(kycLevel > 0);
2143       tokens = getTokenAmount(msg.value, uint256(0));
2144     }
2145     else {
2146       revert("Purchase outside of token sale time windows");
2147     }
2148 
2149     require(zxcSold.add(tokens) <= crowdSaleZxcSupply);
2150     zxcSold = zxcSold.add(tokens);
2151 
2152     wallet.transfer(msg.value);
2153     require(token.transferFrom(token.owner(), msg.sender, tokens));
2154     emit TokenPurchase(msg.sender, msg.sender, msg.value, tokens);
2155   }
2156 
2157   /**
2158    * @return true if crowdsale event has ended
2159    */
2160   function hasEnded()
2161     external
2162     view
2163     returns (bool)
2164   {
2165     bool capReached = zxcSold >= crowdSaleZxcSupply;
2166     bool endTimeReached = now >= endTime;
2167     return capReached || endTimeReached;
2168   }
2169 
2170   /**
2171    * @dev Check if currently active period is a given time period.
2172    * @param _startTime Starting timestamp (inclusive).
2173    * @param _endTime Ending timestamp (exclusive).
2174    * @return bool
2175    */
2176   function isInTimeRange(
2177     uint256 _startTime,
2178     uint256 _endTime
2179   )
2180     internal
2181     view
2182     returns(bool)
2183   {
2184     if (now >= _startTime && now < _endTime) {
2185       return true;
2186     }
2187     else {
2188       return false;
2189     }
2190   }
2191 
2192   /**
2193    * @dev Calculate amount of tokens for a given wei amount. Apply special bonuses depending on
2194    * @param weiAmount Amount of wei for token purchase.
2195    * @param bonusPercent Percentage of bonus tokens.
2196    * @return Number of tokens with possible bonus.
2197    */
2198   function getTokenAmount(
2199     uint256 weiAmount,
2200     uint256 bonusPercent
2201   )
2202     internal
2203     view
2204     returns(uint256)
2205   {
2206     uint256 tokens = weiAmount.mul(rate);
2207 
2208     if (bonusPercent > 0) {
2209       uint256 bonusTokens = tokens.mul(bonusPercent).div(uint256(100)); // tokens * bonus (%) / 100%
2210       tokens = tokens.add(bonusTokens);
2211     }
2212 
2213     return tokens;
2214   }
2215 }