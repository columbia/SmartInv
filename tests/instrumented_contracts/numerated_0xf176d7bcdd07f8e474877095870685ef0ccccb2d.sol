1 pragma solidity ^0.4.24;
2 
3 // File: contracts/tokens/ERC721Enumerable.sol
4 
5 /**
6  * @dev Optional enumeration extension for ERC-721 non-fungible token standard.
7  * See https://goo.gl/pc9yoS.
8  */
9 interface ERC721Enumerable {
10 
11   /**
12    * @dev Returns a count of valid NFTs tracked by this contract, where each one of them has an
13    * assigned and queryable owner not equal to the zero address.
14    */
15   function totalSupply()
16     external
17     view
18     returns (uint256);
19 
20   /**
21    * @dev Returns the token identifier for the `_index`th NFT. Sort order is not specified.
22    * @param _index A counter less than `totalSupply()`.
23    */
24   function tokenByIndex(
25     uint256 _index
26   )
27     external
28     view
29     returns (uint256);
30 
31   /**
32    * @dev Returns the token identifier for the `_index`th NFT assigned to `_owner`. Sort order is
33    * not specified. It throws if `_index` >= `balanceOf(_owner)` or if `_owner` is the zero address,
34    * representing invalid NFTs.
35    * @param _owner An address where we are interested in NFTs owned by them.
36    * @param _index A counter less than `balanceOf(_owner)`.
37    */
38   function tokenOfOwnerByIndex(
39     address _owner,
40     uint256 _index
41   )
42     external
43     view
44     returns (uint256);
45 
46 }
47 
48 // File: contracts/tokens/ERC721.sol
49 
50 /**
51  * @dev ERC-721 non-fungible token standard. See https://goo.gl/pc9yoS.
52  */
53 interface ERC721 {
54 
55   /**
56    * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
57    * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
58    * number of NFTs may be created and assigned without emitting Transfer. At the time of any
59    * transfer, the approved address for that NFT (if any) is reset to none.
60    */
61   event Transfer(
62     address indexed _from,
63     address indexed _to,
64     uint256 indexed _tokenId
65   );
66 
67   /**
68    * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
69    * address indicates there is no approved address. When a Transfer event emits, this also
70    * indicates that the approved address for that NFT (if any) is reset to none.
71    */
72   event Approval(
73     address indexed _owner,
74     address indexed _approved,
75     uint256 indexed _tokenId
76   );
77 
78   /**
79    * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
80    * all NFTs of the owner.
81    */
82   event ApprovalForAll(
83     address indexed _owner,
84     address indexed _operator,
85     bool _approved
86   );
87 
88   /**
89    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
90    * considered invalid, and this function throws for queries about the zero address.
91    * @param _owner Address for whom to query the balance.
92    */
93   function balanceOf(
94     address _owner
95   )
96     external
97     view
98     returns (uint256);
99 
100   /**
101    * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered
102    * invalid, and queries about them do throw.
103    * @param _tokenId The identifier for an NFT.
104    */
105   function ownerOf(
106     uint256 _tokenId
107   )
108     external
109     view
110     returns (address);
111 
112   /**
113    * @dev Transfers the ownership of an NFT from one address to another address.
114    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
115    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
116    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
117    * function checks if `_to` is a smart contract (code size > 0). If so, it calls `onERC721Received`
118    * on `_to` and throws if the return value is not `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
119    * @param _from The current owner of the NFT.
120    * @param _to The new owner.
121    * @param _tokenId The NFT to transfer.
122    * @param _data Additional data with no specified format, sent in call to `_to`.
123    */
124   function safeTransferFrom(
125     address _from,
126     address _to,
127     uint256 _tokenId,
128     bytes _data
129   )
130     external;
131 
132   /**
133    * @dev Transfers the ownership of an NFT from one address to another address.
134    * @notice This works identically to the other function with an extra data parameter, except this
135    * function just sets data to ""
136    * @param _from The current owner of the NFT.
137    * @param _to The new owner.
138    * @param _tokenId The NFT to transfer.
139    */
140   function safeTransferFrom(
141     address _from,
142     address _to,
143     uint256 _tokenId
144   )
145     external;
146 
147   /**
148    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
149    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
150    * address. Throws if `_tokenId` is not a valid NFT.
151    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
152    * they mayb be permanently lost.
153    * @param _from The current owner of the NFT.
154    * @param _to The new owner.
155    * @param _tokenId The NFT to transfer.
156    */
157   function transferFrom(
158     address _from,
159     address _to,
160     uint256 _tokenId
161   )
162     external;
163 
164   /**
165    * @dev Set or reaffirm the approved address for an NFT.
166    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
167    * the current NFT owner, or an authorized operator of the current owner.
168    * @param _approved The new approved NFT controller.
169    * @param _tokenId The NFT to approve.
170    */
171   function approve(
172     address _approved,
173     uint256 _tokenId
174   )
175     external;
176 
177   /**
178    * @dev Enables or disables approval for a third party ("operator") to manage all of
179    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
180    * @notice The contract MUST allow multiple operators per owner.
181    * @param _operator Address to add to the set of authorized operators.
182    * @param _approved True if the operators is approved, false to revoke approval.
183    */
184   function setApprovalForAll(
185     address _operator,
186     bool _approved
187   )
188     external;
189 
190   /**
191    * @dev Get the approved address for a single NFT.
192    * @notice Throws if `_tokenId` is not a valid NFT.
193    * @param _tokenId The NFT to find the approved address for.
194    */
195   function getApproved(
196     uint256 _tokenId
197   )
198     external
199     view
200     returns (address);
201 
202   /**
203    * @dev Returns true if `_operator` is an approved operator for `_owner`, false otherwise.
204    * @param _owner The address that owns the NFTs.
205    * @param _operator The address that acts on behalf of the owner.
206    */
207   function isApprovedForAll(
208     address _owner,
209     address _operator
210   )
211     external
212     view
213     returns (bool);
214 
215 }
216 
217 // File: contracts/tokens/ERC721TokenReceiver.sol
218 
219 /**
220  * @dev ERC-721 interface for accepting safe transfers. See https://goo.gl/pc9yoS.
221  */
222 interface ERC721TokenReceiver {
223 
224   /**
225    * @dev Handle the receipt of a NFT. The ERC721 smart contract calls this function on the
226    * recipient after a `transfer`. This function MAY throw to revert and reject the transfer. Return
227    * of other than the magic value MUST result in the transaction being reverted.
228    * Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))` unless throwing.
229    * @notice The contract address is always the message sender. A wallet/broker/auction application
230    * MUST implement the wallet interface if it will accept safe transfers.
231    * @param _operator The address which called `safeTransferFrom` function.
232    * @param _from The address which previously owned the token.
233    * @param _tokenId The NFT identifier which is being transferred.
234    * @param _data Additional data with no specified format.
235    */
236   function onERC721Received(
237     address _operator,
238     address _from,
239     uint256 _tokenId,
240     bytes _data
241   )
242     external
243     returns(bytes4);
244     
245 }
246 
247 // File: @0xcert/ethereum-utils/contracts/math/SafeMath.sol
248 
249 /**
250  * @dev Math operations with safety checks that throw on error. This contract is based
251  * on the source code at https://goo.gl/iyQsmU.
252  */
253 library SafeMath {
254 
255   /**
256    * @dev Multiplies two numbers, throws on overflow.
257    * @param _a Factor number.
258    * @param _b Factor number.
259    */
260   function mul(
261     uint256 _a,
262     uint256 _b
263   )
264     internal
265     pure
266     returns (uint256)
267   {
268     if (_a == 0) {
269       return 0;
270     }
271     uint256 c = _a * _b;
272     assert(c / _a == _b);
273     return c;
274   }
275 
276   /**
277    * @dev Integer division of two numbers, truncating the quotient.
278    * @param _a Dividend number.
279    * @param _b Divisor number.
280    */
281   function div(
282     uint256 _a,
283     uint256 _b
284   )
285     internal
286     pure
287     returns (uint256)
288   {
289     uint256 c = _a / _b;
290     // assert(b > 0); // Solidity automatically throws when dividing by 0
291     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
292     return c;
293   }
294 
295   /**
296    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
297    * @param _a Minuend number.
298    * @param _b Subtrahend number.
299    */
300   function sub(
301     uint256 _a,
302     uint256 _b
303   )
304     internal
305     pure
306     returns (uint256)
307   {
308     assert(_b <= _a);
309     return _a - _b;
310   }
311 
312   /**
313    * @dev Adds two numbers, throws on overflow.
314    * @param _a Number.
315    * @param _b Number.
316    */
317   function add(
318     uint256 _a,
319     uint256 _b
320   )
321     internal
322     pure
323     returns (uint256)
324   {
325     uint256 c = _a + _b;
326     assert(c >= _a);
327     return c;
328   }
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
383 
384 }
385 
386 // File: @0xcert/ethereum-utils/contracts/utils/SupportsInterface.sol
387 
388 /**
389  * @dev Implementation of standard for detect smart contract interfaces.
390  */
391 contract SupportsInterface is
392   ERC165
393 {
394 
395   /**
396    * @dev Mapping of supported intefraces.
397    * @notice You must not set element 0xffffffff to true.
398    */
399   mapping(bytes4 => bool) internal supportedInterfaces;
400 
401   /**
402    * @dev Contract constructor.
403    */
404   constructor()
405     public
406   {
407     supportedInterfaces[0x01ffc9a7] = true; // ERC165
408   }
409 
410   /**
411    * @dev Function to check which interfaces are suported by this contract.
412    * @param _interfaceID Id of the interface.
413    */
414   function supportsInterface(
415     bytes4 _interfaceID
416   )
417     external
418     view
419     returns (bool)
420   {
421     return supportedInterfaces[_interfaceID];
422   }
423 
424 }
425 
426 // File: contracts/tokens/NFToken.sol
427 
428 /**
429  * @dev Implementation of ERC-721 non-fungible token standard.
430  */
431 contract NFToken is
432   ERC721,
433   SupportsInterface
434 {
435   using SafeMath for uint256;
436   using AddressUtils for address;
437 
438   /**
439    * @dev A mapping from NFT ID to the address that owns it.
440    */
441   mapping (uint256 => address) internal idToOwner;
442 
443   /**
444    * @dev Mapping from NFT ID to approved address.
445    */
446   mapping (uint256 => address) internal idToApprovals;
447 
448    /**
449    * @dev Mapping from owner address to count of his tokens.
450    */
451   mapping (address => uint256) internal ownerToNFTokenCount;
452 
453   /**
454    * @dev Mapping from owner address to mapping of operator addresses.
455    */
456   mapping (address => mapping (address => bool)) internal ownerToOperators;
457 
458   /**
459    * @dev Magic value of a smart contract that can recieve NFT.
460    * Equal to: bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")).
461    */
462   bytes4 constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
463 
464   /**
465    * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
466    * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
467    * number of NFTs may be created and assigned without emitting Transfer. At the time of any
468    * transfer, the approved address for that NFT (if any) is reset to none.
469    * @param _from Sender of NFT (if address is zero address it indicates token creation).
470    * @param _to Receiver of NFT (if address is zero address it indicates token destruction).
471    * @param _tokenId The NFT that got transfered.
472    */
473   event Transfer(
474     address indexed _from,
475     address indexed _to,
476     uint256 indexed _tokenId
477   );
478 
479   /**
480    * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
481    * address indicates there is no approved address. When a Transfer event emits, this also
482    * indicates that the approved address for that NFT (if any) is reset to none.
483    * @param _owner Owner of NFT.
484    * @param _approved Address that we are approving.
485    * @param _tokenId NFT which we are approving.
486    */
487   event Approval(
488     address indexed _owner,
489     address indexed _approved,
490     uint256 indexed _tokenId
491   );
492 
493   /**
494    * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
495    * all NFTs of the owner.
496    * @param _owner Owner of NFT.
497    * @param _operator Address to which we are setting operator rights.
498    * @param _approved Status of operator rights(true if operator rights are given and false if
499    * revoked).
500    */
501   event ApprovalForAll(
502     address indexed _owner,
503     address indexed _operator,
504     bool _approved
505   );
506 
507   /**
508    * @dev Guarantees that the msg.sender is an owner or operator of the given NFT.
509    * @param _tokenId ID of the NFT to validate.
510    */
511   modifier canOperate(
512     uint256 _tokenId
513   ) {
514     address tokenOwner = idToOwner[_tokenId];
515     require(tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender]);
516     _;
517   }
518 
519   /**
520    * @dev Guarantees that the msg.sender is allowed to transfer NFT.
521    * @param _tokenId ID of the NFT to transfer.
522    */
523   modifier canTransfer(
524     uint256 _tokenId
525   ) {
526     address tokenOwner = idToOwner[_tokenId];
527     require(
528       tokenOwner == msg.sender
529       || getApproved(_tokenId) == msg.sender
530       || ownerToOperators[tokenOwner][msg.sender]
531     );
532 
533     _;
534   }
535 
536   /**
537    * @dev Guarantees that _tokenId is a valid Token.
538    * @param _tokenId ID of the NFT to validate.
539    */
540   modifier validNFToken(
541     uint256 _tokenId
542   ) {
543     require(idToOwner[_tokenId] != address(0));
544     _;
545   }
546 
547   /**
548    * @dev Contract constructor.
549    */
550   constructor()
551     public
552   {
553     supportedInterfaces[0x80ac58cd] = true; // ERC721
554   }
555 
556   /**
557    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
558    * considered invalid, and this function throws for queries about the zero address.
559    * @param _owner Address for whom to query the balance.
560    */
561   function balanceOf(
562     address _owner
563   )
564     external
565     view
566     returns (uint256)
567   {
568     require(_owner != address(0));
569     return ownerToNFTokenCount[_owner];
570   }
571 
572   /**
573    * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered
574    * invalid, and queries about them do throw.
575    * @param _tokenId The identifier for an NFT.
576    */
577   function ownerOf(
578     uint256 _tokenId
579   )
580     external
581     view
582     returns (address _owner)
583   {
584     _owner = idToOwner[_tokenId];
585     require(_owner != address(0));
586   }
587 
588   /**
589    * @dev Transfers the ownership of an NFT from one address to another address.
590    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
591    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
592    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
593    * function checks if `_to` is a smart contract (code size > 0). If so, it calls `onERC721Received`
594    * on `_to` and throws if the return value is not `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
595    * @param _from The current owner of the NFT.
596    * @param _to The new owner.
597    * @param _tokenId The NFT to transfer.
598    * @param _data Additional data with no specified format, sent in call to `_to`.
599    */
600   function safeTransferFrom(
601     address _from,
602     address _to,
603     uint256 _tokenId,
604     bytes _data
605   )
606     external
607   {
608     _safeTransferFrom(_from, _to, _tokenId, _data);
609   }
610 
611   /**
612    * @dev Transfers the ownership of an NFT from one address to another address.
613    * @notice This works identically to the other function with an extra data parameter, except this
614    * function just sets data to ""
615    * @param _from The current owner of the NFT.
616    * @param _to The new owner.
617    * @param _tokenId The NFT to transfer.
618    */
619   function safeTransferFrom(
620     address _from,
621     address _to,
622     uint256 _tokenId
623   )
624     external
625   {
626     _safeTransferFrom(_from, _to, _tokenId, "");
627   }
628 
629   /**
630    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
631    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
632    * address. Throws if `_tokenId` is not a valid NFT.
633    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
634    * they maybe be permanently lost.
635    * @param _from The current owner of the NFT.
636    * @param _to The new owner.
637    * @param _tokenId The NFT to transfer.
638    */
639   function transferFrom(
640     address _from,
641     address _to,
642     uint256 _tokenId
643   )
644     external
645     canTransfer(_tokenId)
646     validNFToken(_tokenId)
647   {
648     address tokenOwner = idToOwner[_tokenId];
649     require(tokenOwner == _from);
650     require(_to != address(0));
651 
652     _transfer(_to, _tokenId);
653   }
654 
655   /**
656    * @dev Set or reaffirm the approved address for an NFT.
657    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
658    * the current NFT owner, or an authorized operator of the current owner.
659    * @param _approved Address to be approved for the given NFT ID.
660    * @param _tokenId ID of the token to be approved.
661    */
662   function approve(
663     address _approved,
664     uint256 _tokenId
665   )
666     external
667     canOperate(_tokenId)
668     validNFToken(_tokenId)
669   {
670     address tokenOwner = idToOwner[_tokenId];
671     require(_approved != tokenOwner);
672 
673     idToApprovals[_tokenId] = _approved;
674     emit Approval(tokenOwner, _approved, _tokenId);
675   }
676 
677   /**
678    * @dev Enables or disables approval for a third party ("operator") to manage all of
679    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
680    * @notice This works even if sender doesn't own any tokens at the time.
681    * @param _operator Address to add to the set of authorized operators.
682    * @param _approved True if the operators is approved, false to revoke approval.
683    */
684   function setApprovalForAll(
685     address _operator,
686     bool _approved
687   )
688     external
689   {
690     require(_operator != address(0));
691     ownerToOperators[msg.sender][_operator] = _approved;
692     emit ApprovalForAll(msg.sender, _operator, _approved);
693   }
694 
695   /**
696    * @dev Get the approved address for a single NFT.
697    * @notice Throws if `_tokenId` is not a valid NFT.
698    * @param _tokenId ID of the NFT to query the approval of.
699    */
700   function getApproved(
701     uint256 _tokenId
702   )
703     public
704     view
705     validNFToken(_tokenId)
706     returns (address)
707   {
708     return idToApprovals[_tokenId];
709   }
710 
711   /**
712    * @dev Checks if `_operator` is an approved operator for `_owner`.
713    * @param _owner The address that owns the NFTs.
714    * @param _operator The address that acts on behalf of the owner.
715    */
716   function isApprovedForAll(
717     address _owner,
718     address _operator
719   )
720     external
721     view
722     returns (bool)
723   {
724     require(_owner != address(0));
725     require(_operator != address(0));
726     return ownerToOperators[_owner][_operator];
727   }
728 
729   /**
730    * @dev Actually perform the safeTransferFrom.
731    * @param _from The current owner of the NFT.
732    * @param _to The new owner.
733    * @param _tokenId The NFT to transfer.
734    * @param _data Additional data with no specified format, sent in call to `_to`.
735    */
736   function _safeTransferFrom(
737     address _from,
738     address _to,
739     uint256 _tokenId,
740     bytes _data
741   )
742     internal
743     canTransfer(_tokenId)
744     validNFToken(_tokenId)
745   {
746     address tokenOwner = idToOwner[_tokenId];
747     require(tokenOwner == _from);
748     require(_to != address(0));
749 
750     _transfer(_to, _tokenId);
751 
752     if (_to.isContract()) {
753       bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
754       require(retval == MAGIC_ON_ERC721_RECEIVED);
755     }
756   }
757 
758   /**
759    * @dev Actually preforms the transfer.
760    * @notice Does NO checks.
761    * @param _to Address of a new owner.
762    * @param _tokenId The NFT that is being transferred.
763    */
764   function _transfer(
765     address _to,
766     uint256 _tokenId
767   )
768     private
769   {
770     address from = idToOwner[_tokenId];
771     clearApproval(_tokenId);
772 
773     removeNFToken(from, _tokenId);
774     addNFToken(_to, _tokenId);
775 
776     emit Transfer(from, _to, _tokenId);
777   }
778    
779   /**
780    * @dev Mints a new NFT.
781    * @notice This is a private function which should be called from user-implemented external
782    * mint function. Its purpose is to show and properly initialize data structures when using this
783    * implementation.
784    * @param _to The address that will own the minted NFT.
785    * @param _tokenId of the NFT to be minted by the msg.sender.
786    */
787   function _mint(
788     address _to,
789     uint256 _tokenId
790   )
791     internal
792   {
793     require(_to != address(0));
794     require(_tokenId != 0);
795     require(idToOwner[_tokenId] == address(0));
796 
797     addNFToken(_to, _tokenId);
798 
799     emit Transfer(address(0), _to, _tokenId);
800   }
801 
802   /**
803    * @dev Burns a NFT.
804    * @notice This is a private function which should be called from user-implemented external
805    * burn function. Its purpose is to show and properly initialize data structures when using this
806    * implementation.
807    * @param _owner Address of the NFT owner.
808    * @param _tokenId ID of the NFT to be burned.
809    */
810   function _burn(
811     address _owner,
812     uint256 _tokenId
813   )
814     validNFToken(_tokenId)
815     internal
816   {
817     clearApproval(_tokenId);
818     removeNFToken(_owner, _tokenId);
819     emit Transfer(_owner, address(0), _tokenId);
820   }
821 
822   /** 
823    * @dev Clears the current approval of a given NFT ID.
824    * @param _tokenId ID of the NFT to be transferred.
825    */
826   function clearApproval(
827     uint256 _tokenId
828   )
829     private
830   {
831     if(idToApprovals[_tokenId] != 0)
832     {
833       delete idToApprovals[_tokenId];
834     }
835   }
836 
837   /**
838    * @dev Removes a NFT from owner.
839    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
840    * @param _from Address from wich we want to remove the NFT.
841    * @param _tokenId Which NFT we want to remove.
842    */
843   function removeNFToken(
844     address _from,
845     uint256 _tokenId
846   )
847    internal
848   {
849     require(idToOwner[_tokenId] == _from);
850     assert(ownerToNFTokenCount[_from] > 0);
851     ownerToNFTokenCount[_from] = ownerToNFTokenCount[_from] - 1;
852     delete idToOwner[_tokenId];
853   }
854 
855   /**
856    * @dev Assignes a new NFT to owner.
857    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
858    * @param _to Address to wich we want to add the NFT.
859    * @param _tokenId Which NFT we want to add.
860    */
861   function addNFToken(
862     address _to,
863     uint256 _tokenId
864   )
865     internal
866   {
867     require(idToOwner[_tokenId] == address(0));
868 
869     idToOwner[_tokenId] = _to;
870     ownerToNFTokenCount[_to] = ownerToNFTokenCount[_to].add(1);
871   }
872 
873 }
874 
875 // File: contracts/tokens/NFTokenEnumerable.sol
876 
877 /**
878  * @dev Optional enumeration implementation for ERC-721 non-fungible token standard.
879  */
880 contract NFTokenEnumerable is
881   NFToken,
882   ERC721Enumerable
883 {
884 
885   /**
886    * @dev Array of all NFT IDs.
887    */
888   uint256[] internal tokens;
889 
890   /**
891    * @dev Mapping from token ID its index in global tokens array.
892    */
893   mapping(uint256 => uint256) internal idToIndex;
894 
895   /**
896    * @dev Mapping from owner to list of owned NFT IDs.
897    */
898   mapping(address => uint256[]) internal ownerToIds;
899 
900   /**
901    * @dev Mapping from NFT ID to its index in the owner tokens list.
902    */
903   mapping(uint256 => uint256) internal idToOwnerIndex;
904 
905   /**
906    * @dev Contract constructor.
907    */
908   constructor()
909     public
910   {
911     supportedInterfaces[0x780e9d63] = true; // ERC721Enumerable
912   }
913 
914   /**
915    * @dev Mints a new NFT.
916    * @notice This is a private function which should be called from user-implemented external
917    * mint function. Its purpose is to show and properly initialize data structures when using this
918    * implementation.
919    * @param _to The address that will own the minted NFT.
920    * @param _tokenId of the NFT to be minted by the msg.sender.
921    */
922   function _mint(
923     address _to,
924     uint256 _tokenId
925   )
926     internal
927   {
928     super._mint(_to, _tokenId);
929     uint256 length = tokens.push(_tokenId);
930     idToIndex[_tokenId] = length - 1;
931   }
932 
933   /**
934    * @dev Burns a NFT.
935    * @notice This is a private function which should be called from user-implemented external
936    * burn function. Its purpose is to show and properly initialize data structures when using this
937    * implementation.
938    * @param _owner Address of the NFT owner.
939    * @param _tokenId ID of the NFT to be burned.
940    */
941   function _burn(
942     address _owner,
943     uint256 _tokenId
944   )
945     internal
946   {
947     super._burn(_owner, _tokenId);
948     assert(tokens.length > 0);
949 
950     uint256 tokenIndex = idToIndex[_tokenId];
951     // Sanity check. This could be removed in the future.
952     assert(tokens[tokenIndex] == _tokenId);
953     uint256 lastTokenIndex = tokens.length - 1;
954     uint256 lastToken = tokens[lastTokenIndex];
955 
956     tokens[tokenIndex] = lastToken;
957 
958     tokens.length--;
959     // Consider adding a conditional check for the last token in order to save GAS.
960     idToIndex[lastToken] = tokenIndex;
961     idToIndex[_tokenId] = 0;
962   }
963 
964   /**
965    * @dev Removes a NFT from an address.
966    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
967    * @param _from Address from wich we want to remove the NFT.
968    * @param _tokenId Which NFT we want to remove.
969    */
970   function removeNFToken(
971     address _from,
972     uint256 _tokenId
973   )
974    internal
975   {
976     super.removeNFToken(_from, _tokenId);
977     assert(ownerToIds[_from].length > 0);
978 
979     uint256 tokenToRemoveIndex = idToOwnerIndex[_tokenId];
980     uint256 lastTokenIndex = ownerToIds[_from].length - 1;
981     uint256 lastToken = ownerToIds[_from][lastTokenIndex];
982 
983     ownerToIds[_from][tokenToRemoveIndex] = lastToken;
984 
985     ownerToIds[_from].length--;
986     // Consider adding a conditional check for the last token in order to save GAS.
987     idToOwnerIndex[lastToken] = tokenToRemoveIndex;
988     idToOwnerIndex[_tokenId] = 0;
989   }
990 
991   /**
992    * @dev Assignes a new NFT to an address.
993    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
994    * @param _to Address to wich we want to add the NFT.
995    * @param _tokenId Which NFT we want to add.
996    */
997   function addNFToken(
998     address _to,
999     uint256 _tokenId
1000   )
1001     internal
1002   {
1003     super.addNFToken(_to, _tokenId);
1004 
1005     uint256 length = ownerToIds[_to].push(_tokenId);
1006     idToOwnerIndex[_tokenId] = length - 1;
1007   }
1008 
1009   /**
1010    * @dev Returns the count of all existing NFTokens.
1011    */
1012   function totalSupply()
1013     external
1014     view
1015     returns (uint256)
1016   {
1017     return tokens.length;
1018   }
1019 
1020   /**
1021    * @dev Returns NFT ID by its index.
1022    * @param _index A counter less than `totalSupply()`.
1023    */
1024   function tokenByIndex(
1025     uint256 _index
1026   )
1027     external
1028     view
1029     returns (uint256)
1030   {
1031     require(_index < tokens.length);
1032     // Sanity check. This could be removed in the future.
1033     assert(idToIndex[tokens[_index]] == _index);
1034     return tokens[_index];
1035   }
1036 
1037   /**
1038    * @dev returns the n-th NFT ID from a list of owner's tokens.
1039    * @param _owner Token owner's address.
1040    * @param _index Index number representing n-th token in owner's list of tokens.
1041    */
1042   function tokenOfOwnerByIndex(
1043     address _owner,
1044     uint256 _index
1045   )
1046     external
1047     view
1048     returns (uint256)
1049   {
1050     require(_index < ownerToIds[_owner].length);
1051     return ownerToIds[_owner][_index];
1052   }
1053 
1054 }
1055 
1056 // File: @0xcert/ethereum-utils/contracts/ownership/Ownable.sol
1057 
1058 /**
1059  * @dev The contract has an owner address, and provides basic authorization control whitch
1060  * simplifies the implementation of user permissions. This contract is based on the source code
1061  * at https://goo.gl/n2ZGVt.
1062  */
1063 contract Ownable {
1064   address public owner;
1065 
1066   /**
1067    * @dev An event which is triggered when the owner is changed.
1068    * @param previousOwner The address of the previous owner.
1069    * @param newOwner The address of the new owner.
1070    */
1071   event OwnershipTransferred(
1072     address indexed previousOwner,
1073     address indexed newOwner
1074   );
1075 
1076   /**
1077    * @dev The constructor sets the original `owner` of the contract to the sender account.
1078    */
1079   constructor()
1080     public
1081   {
1082     owner = msg.sender;
1083   }
1084 
1085   /**
1086    * @dev Throws if called by any account other than the owner.
1087    */
1088   modifier onlyOwner() {
1089     require(msg.sender == owner);
1090     _;
1091   }
1092 
1093   /**
1094    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1095    * @param _newOwner The address to transfer ownership to.
1096    */
1097   function transferOwnership(
1098     address _newOwner
1099   )
1100     onlyOwner
1101     public
1102   {
1103     require(_newOwner != address(0));
1104     emit OwnershipTransferred(owner, _newOwner);
1105     owner = _newOwner;
1106   }
1107 
1108 }
1109 
1110 // File: contracts/tokens/ERC721Metadata.sol
1111 
1112 /**
1113  * @dev Optional metadata extension for ERC-721 non-fungible token standard.
1114  * See https://goo.gl/pc9yoS.
1115  */
1116 interface ERC721Metadata {
1117 
1118   /**
1119    * @dev Returns a descriptive name for a collection of NFTs in this contract.
1120    */
1121   function name()
1122     external
1123     view
1124     returns (string _name);
1125 
1126   /**
1127    * @dev Returns a abbreviated name for a collection of NFTs in this contract.
1128    */
1129   function symbol()
1130     external
1131     view
1132     returns (string _symbol);
1133 
1134   /**
1135    * @dev Returns a distinct Uniform Resource Identifier (URI) for a given asset. It Throws if
1136    * `_tokenId` is not a valid NFT. URIs are defined in RFC3986. The URI may point to a JSON file
1137    * that conforms to the "ERC721 Metadata JSON Schema".
1138    */
1139   function tokenURI(uint256 _tokenId)
1140     external
1141     view
1142     returns (string);
1143 
1144 }
1145 
1146 // File: contracts/tokens/NFTokenMetadata.sol
1147 
1148 /**
1149  * @dev Optional metadata implementation for ERC-721 non-fungible token standard.
1150  */
1151 contract NFTokenMetadata is
1152   NFToken,
1153   ERC721Metadata
1154 {
1155 
1156   /**
1157    * @dev A descriptive name for a collection of NFTs.
1158    */
1159   string internal nftName;
1160 
1161   /**
1162    * @dev An abbreviated name for NFTokens.
1163    */
1164   string internal nftSymbol;
1165 
1166   /**
1167    * @dev Mapping from NFT ID to metadata uri.
1168    */
1169   mapping (uint256 => string) internal idToUri;
1170 
1171   /**
1172    * @dev Contract constructor.
1173    * @notice When implementing this contract don't forget to set nftName and nftSymbol.
1174    */
1175   constructor()
1176     public
1177   {
1178     supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
1179   }
1180 
1181   /**
1182    * @dev Burns a NFT.
1183    * @notice This is a internal function which should be called from user-implemented external
1184    * burn function. Its purpose is to show and properly initialize data structures when using this
1185    * implementation.
1186    * @param _owner Address of the NFT owner.
1187    * @param _tokenId ID of the NFT to be burned.
1188    */
1189   function _burn(
1190     address _owner,
1191     uint256 _tokenId
1192   )
1193     internal
1194   {
1195     super._burn(_owner, _tokenId);
1196 
1197     if (bytes(idToUri[_tokenId]).length != 0) {
1198       delete idToUri[_tokenId];
1199     }
1200   }
1201 
1202   /**
1203    * @dev Set a distinct URI (RFC 3986) for a given NFT ID.
1204    * @notice this is a internal function which should be called from user-implemented external
1205    * function. Its purpose is to show and properly initialize data structures when using this
1206    * implementation.
1207    * @param _tokenId Id for which we want uri.
1208    * @param _uri String representing RFC 3986 URI.
1209    */
1210   function _setTokenUri(
1211     uint256 _tokenId,
1212     string _uri
1213   )
1214     validNFToken(_tokenId)
1215     internal
1216   {
1217     idToUri[_tokenId] = _uri;
1218   }
1219 
1220   /**
1221    * @dev Returns a descriptive name for a collection of NFTokens.
1222    */
1223   function name()
1224     external
1225     view
1226     returns (string _name)
1227   {
1228     _name = nftName;
1229   }
1230 
1231   /**
1232    * @dev Returns an abbreviated name for NFTokens.
1233    */
1234   function symbol()
1235     external
1236     view
1237     returns (string _symbol)
1238   {
1239     _symbol = nftSymbol;
1240   }
1241 
1242   /**
1243    * @dev A distinct URI (RFC 3986) for a given NFT.
1244    * @param _tokenId Id for which we want uri.
1245    */
1246   function tokenURI(
1247     uint256 _tokenId
1248   )
1249     validNFToken(_tokenId)
1250     external
1251     view
1252     returns (string)
1253   {
1254     return idToUri[_tokenId];
1255   }
1256 
1257 }
1258 
1259 // File: contracts/mocks/NFTokenMetadataEnumerableMock.sol
1260 
1261 /**
1262  * @dev This is an example contract implementation of NFToken with enumerable and metadata
1263  * extensions.
1264  */
1265 contract NFTokenMetadataEnumerableMock is
1266   NFTokenEnumerable,
1267   NFTokenMetadata,
1268   Ownable
1269 {
1270 
1271   /**
1272    * @dev Contract constructor.
1273    * @param _name A descriptive name for a collection of NFTs.
1274    * @param _symbol An abbreviated name for NFTokens.
1275    */
1276   constructor(
1277     string _name,
1278     string _symbol
1279   )
1280     public
1281   {
1282     nftName = _name;
1283     nftSymbol = _symbol;
1284   }
1285 
1286   /**
1287    * @dev Mints a new NFT.
1288    * @param _to The address that will own the minted NFT.
1289    * @param _tokenId of the NFT to be minted by the msg.sender.
1290    * @param _uri String representing RFC 3986 URI.
1291    */
1292   function mint(
1293     address _to,
1294     uint256 _tokenId,
1295     string _uri
1296   )
1297     external
1298   {
1299     super._mint(_to, _tokenId);
1300     super._setTokenUri(_tokenId, _uri);
1301   }
1302 
1303   /**
1304    * @dev Removes a NFT from owner.
1305    * @param _owner Address from wich we want to remove the NFT.
1306    * @param _tokenId Which NFT we want to remove.
1307    */
1308   function burn(
1309     address _owner,
1310     uint256 _tokenId
1311   )
1312     onlyOwner
1313     external
1314   {
1315     super._burn(_owner, _tokenId);
1316   }
1317 
1318 }