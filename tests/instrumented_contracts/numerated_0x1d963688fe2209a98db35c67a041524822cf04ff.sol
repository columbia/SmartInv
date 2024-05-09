1 // File: @0xcert/ethereum-erc721/contracts/tokens/ERC721.sol
2 
3 pragma solidity ^0.4.24;
4 
5 /**
6  * @dev ERC-721 non-fungible token standard. See https://goo.gl/pc9yoS.
7  */
8 interface ERC721 {
9 
10   /**
11    * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
12    * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
13    * number of NFTs may be created and assigned without emitting Transfer. At the time of any
14    * transfer, the approved address for that NFT (if any) is reset to none.
15    */
16   event Transfer(
17     address indexed _from,
18     address indexed _to,
19     uint256 indexed _tokenId
20   );
21 
22   /**
23    * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
24    * address indicates there is no approved address. When a Transfer event emits, this also
25    * indicates that the approved address for that NFT (if any) is reset to none.
26    */
27   event Approval(
28     address indexed _owner,
29     address indexed _approved,
30     uint256 indexed _tokenId
31   );
32 
33   /**
34    * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
35    * all NFTs of the owner.
36    */
37   event ApprovalForAll(
38     address indexed _owner,
39     address indexed _operator,
40     bool _approved
41   );
42 
43   /**
44    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
45    * considered invalid, and this function throws for queries about the zero address.
46    * @param _owner Address for whom to query the balance.
47    */
48   function balanceOf(
49     address _owner
50   )
51     external
52     view
53     returns (uint256);
54 
55   /**
56    * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered
57    * invalid, and queries about them do throw.
58    * @param _tokenId The identifier for an NFT.
59    */
60   function ownerOf(
61     uint256 _tokenId
62   )
63     external
64     view
65     returns (address);
66 
67   /**
68    * @dev Transfers the ownership of an NFT from one address to another address.
69    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
70    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
71    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
72    * function checks if `_to` is a smart contract (code size > 0). If so, it calls `onERC721Received`
73    * on `_to` and throws if the return value is not `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
74    * @param _from The current owner of the NFT.
75    * @param _to The new owner.
76    * @param _tokenId The NFT to transfer.
77    * @param _data Additional data with no specified format, sent in call to `_to`.
78    */
79   function safeTransferFrom(
80     address _from,
81     address _to,
82     uint256 _tokenId,
83     bytes _data
84   )
85     external;
86 
87   /**
88    * @dev Transfers the ownership of an NFT from one address to another address.
89    * @notice This works identically to the other function with an extra data parameter, except this
90    * function just sets data to ""
91    * @param _from The current owner of the NFT.
92    * @param _to The new owner.
93    * @param _tokenId The NFT to transfer.
94    */
95   function safeTransferFrom(
96     address _from,
97     address _to,
98     uint256 _tokenId
99   )
100     external;
101 
102   /**
103    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
104    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
105    * address. Throws if `_tokenId` is not a valid NFT.
106    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
107    * they mayb be permanently lost.
108    * @param _from The current owner of the NFT.
109    * @param _to The new owner.
110    * @param _tokenId The NFT to transfer.
111    */
112   function transferFrom(
113     address _from,
114     address _to,
115     uint256 _tokenId
116   )
117     external;
118 
119   /**
120    * @dev Set or reaffirm the approved address for an NFT.
121    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
122    * the current NFT owner, or an authorized operator of the current owner.
123    * @param _approved The new approved NFT controller.
124    * @param _tokenId The NFT to approve.
125    */
126   function approve(
127     address _approved,
128     uint256 _tokenId
129   )
130     external;
131 
132   /**
133    * @dev Enables or disables approval for a third party ("operator") to manage all of
134    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
135    * @notice The contract MUST allow multiple operators per owner.
136    * @param _operator Address to add to the set of authorized operators.
137    * @param _approved True if the operators is approved, false to revoke approval.
138    */
139   function setApprovalForAll(
140     address _operator,
141     bool _approved
142   )
143     external;
144 
145   /**
146    * @dev Get the approved address for a single NFT.
147    * @notice Throws if `_tokenId` is not a valid NFT.
148    * @param _tokenId The NFT to find the approved address for.
149    */
150   function getApproved(
151     uint256 _tokenId
152   )
153     external
154     view
155     returns (address);
156 
157   /**
158    * @dev Returns true if `_operator` is an approved operator for `_owner`, false otherwise.
159    * @param _owner The address that owns the NFTs.
160    * @param _operator The address that acts on behalf of the owner.
161    */
162   function isApprovedForAll(
163     address _owner,
164     address _operator
165   )
166     external
167     view
168     returns (bool);
169 
170 }
171 
172 // File: @0xcert/ethereum-erc721/contracts/tokens/ERC721TokenReceiver.sol
173 
174 pragma solidity ^0.4.24;
175 
176 /**
177  * @dev ERC-721 interface for accepting safe transfers. See https://goo.gl/pc9yoS.
178  */
179 interface ERC721TokenReceiver {
180 
181   /**
182    * @dev Handle the receipt of a NFT. The ERC721 smart contract calls this function on the
183    * recipient after a `transfer`. This function MAY throw to revert and reject the transfer. Return
184    * of other than the magic value MUST result in the transaction being reverted.
185    * Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))` unless throwing.
186    * @notice The contract address is always the message sender. A wallet/broker/auction application
187    * MUST implement the wallet interface if it will accept safe transfers.
188    * @param _operator The address which called `safeTransferFrom` function.
189    * @param _from The address which previously owned the token.
190    * @param _tokenId The NFT identifier which is being transferred.
191    * @param _data Additional data with no specified format.
192    */
193   function onERC721Received(
194     address _operator,
195     address _from,
196     uint256 _tokenId,
197     bytes _data
198   )
199     external
200     returns(bytes4);
201     
202 }
203 
204 // File: @0xcert/ethereum-utils/contracts/math/SafeMath.sol
205 
206 pragma solidity ^0.4.24;
207 
208 /**
209  * @dev Math operations with safety checks that throw on error. This contract is based
210  * on the source code at https://goo.gl/iyQsmU.
211  */
212 library SafeMath {
213 
214   /**
215    * @dev Multiplies two numbers, throws on overflow.
216    * @param _a Factor number.
217    * @param _b Factor number.
218    */
219   function mul(
220     uint256 _a,
221     uint256 _b
222   )
223     internal
224     pure
225     returns (uint256)
226   {
227     if (_a == 0) {
228       return 0;
229     }
230     uint256 c = _a * _b;
231     assert(c / _a == _b);
232     return c;
233   }
234 
235   /**
236    * @dev Integer division of two numbers, truncating the quotient.
237    * @param _a Dividend number.
238    * @param _b Divisor number.
239    */
240   function div(
241     uint256 _a,
242     uint256 _b
243   )
244     internal
245     pure
246     returns (uint256)
247   {
248     uint256 c = _a / _b;
249     // assert(b > 0); // Solidity automatically throws when dividing by 0
250     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
251     return c;
252   }
253 
254   /**
255    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
256    * @param _a Minuend number.
257    * @param _b Subtrahend number.
258    */
259   function sub(
260     uint256 _a,
261     uint256 _b
262   )
263     internal
264     pure
265     returns (uint256)
266   {
267     assert(_b <= _a);
268     return _a - _b;
269   }
270 
271   /**
272    * @dev Adds two numbers, throws on overflow.
273    * @param _a Number.
274    * @param _b Number.
275    */
276   function add(
277     uint256 _a,
278     uint256 _b
279   )
280     internal
281     pure
282     returns (uint256)
283   {
284     uint256 c = _a + _b;
285     assert(c >= _a);
286     return c;
287   }
288 
289 }
290 
291 // File: @0xcert/ethereum-utils/contracts/utils/ERC165.sol
292 
293 pragma solidity ^0.4.24;
294 
295 /**
296  * @dev A standard for detecting smart contract interfaces. See https://goo.gl/cxQCse.
297  */
298 interface ERC165 {
299 
300   /**
301    * @dev Checks if the smart contract includes a specific interface.
302    * @notice This function uses less than 30,000 gas.
303    * @param _interfaceID The interface identifier, as specified in ERC-165.
304    */
305   function supportsInterface(
306     bytes4 _interfaceID
307   )
308     external
309     view
310     returns (bool);
311 
312 }
313 
314 // File: @0xcert/ethereum-utils/contracts/utils/SupportsInterface.sol
315 
316 pragma solidity ^0.4.24;
317 
318 
319 /**
320  * @dev Implementation of standard for detect smart contract interfaces.
321  */
322 contract SupportsInterface is
323   ERC165
324 {
325 
326   /**
327    * @dev Mapping of supported intefraces.
328    * @notice You must not set element 0xffffffff to true.
329    */
330   mapping(bytes4 => bool) internal supportedInterfaces;
331 
332   /**
333    * @dev Contract constructor.
334    */
335   constructor()
336     public
337   {
338     supportedInterfaces[0x01ffc9a7] = true; // ERC165
339   }
340 
341   /**
342    * @dev Function to check which interfaces are suported by this contract.
343    * @param _interfaceID Id of the interface.
344    */
345   function supportsInterface(
346     bytes4 _interfaceID
347   )
348     external
349     view
350     returns (bool)
351   {
352     return supportedInterfaces[_interfaceID];
353   }
354 
355 }
356 
357 // File: @0xcert/ethereum-utils/contracts/utils/AddressUtils.sol
358 
359 pragma solidity ^0.4.24;
360 
361 /**
362  * @dev Utility library of inline functions on addresses.
363  */
364 library AddressUtils {
365 
366   /**
367    * @dev Returns whether the target address is a contract.
368    * @param _addr Address to check.
369    */
370   function isContract(
371     address _addr
372   )
373     internal
374     view
375     returns (bool)
376   {
377     uint256 size;
378 
379     /**
380      * XXX Currently there is no better way to check if there is a contract in an address than to
381      * check the size of the code at that address.
382      * See https://ethereum.stackexchange.com/a/14016/36603 for more details about how this works.
383      * TODO: Check this again before the Serenity release, because all addresses will be
384      * contracts then.
385      */
386     assembly { size := extcodesize(_addr) } // solium-disable-line security/no-inline-assembly
387     return size > 0;
388   }
389 
390 }
391 
392 // File: @0xcert/ethereum-erc721/contracts/tokens/NFToken.sol
393 
394 pragma solidity ^0.4.24;
395 
396 
397 
398 
399 
400 
401 /**
402  * @dev Implementation of ERC-721 non-fungible token standard.
403  */
404 contract NFToken is
405   ERC721,
406   SupportsInterface
407 {
408   using SafeMath for uint256;
409   using AddressUtils for address;
410 
411   /**
412    * @dev A mapping from NFT ID to the address that owns it.
413    */
414   mapping (uint256 => address) internal idToOwner;
415 
416   /**
417    * @dev Mapping from NFT ID to approved address.
418    */
419   mapping (uint256 => address) internal idToApprovals;
420 
421    /**
422    * @dev Mapping from owner address to count of his tokens.
423    */
424   mapping (address => uint256) internal ownerToNFTokenCount;
425 
426   /**
427    * @dev Mapping from owner address to mapping of operator addresses.
428    */
429   mapping (address => mapping (address => bool)) internal ownerToOperators;
430 
431   /**
432    * @dev Magic value of a smart contract that can recieve NFT.
433    * Equal to: bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")).
434    */
435   bytes4 constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
436 
437   /**
438    * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
439    * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
440    * number of NFTs may be created and assigned without emitting Transfer. At the time of any
441    * transfer, the approved address for that NFT (if any) is reset to none.
442    * @param _from Sender of NFT (if address is zero address it indicates token creation).
443    * @param _to Receiver of NFT (if address is zero address it indicates token destruction).
444    * @param _tokenId The NFT that got transfered.
445    */
446   event Transfer(
447     address indexed _from,
448     address indexed _to,
449     uint256 indexed _tokenId
450   );
451 
452   /**
453    * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
454    * address indicates there is no approved address. When a Transfer event emits, this also
455    * indicates that the approved address for that NFT (if any) is reset to none.
456    * @param _owner Owner of NFT.
457    * @param _approved Address that we are approving.
458    * @param _tokenId NFT which we are approving.
459    */
460   event Approval(
461     address indexed _owner,
462     address indexed _approved,
463     uint256 indexed _tokenId
464   );
465 
466   /**
467    * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
468    * all NFTs of the owner.
469    * @param _owner Owner of NFT.
470    * @param _operator Address to which we are setting operator rights.
471    * @param _approved Status of operator rights(true if operator rights are given and false if
472    * revoked).
473    */
474   event ApprovalForAll(
475     address indexed _owner,
476     address indexed _operator,
477     bool _approved
478   );
479 
480   /**
481    * @dev Guarantees that the msg.sender is an owner or operator of the given NFT.
482    * @param _tokenId ID of the NFT to validate.
483    */
484   modifier canOperate(
485     uint256 _tokenId
486   ) {
487     address tokenOwner = idToOwner[_tokenId];
488     require(tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender]);
489     _;
490   }
491 
492   /**
493    * @dev Guarantees that the msg.sender is allowed to transfer NFT.
494    * @param _tokenId ID of the NFT to transfer.
495    */
496   modifier canTransfer(
497     uint256 _tokenId
498   ) {
499     address tokenOwner = idToOwner[_tokenId];
500     require(
501       tokenOwner == msg.sender
502       || getApproved(_tokenId) == msg.sender
503       || ownerToOperators[tokenOwner][msg.sender]
504     );
505 
506     _;
507   }
508 
509   /**
510    * @dev Guarantees that _tokenId is a valid Token.
511    * @param _tokenId ID of the NFT to validate.
512    */
513   modifier validNFToken(
514     uint256 _tokenId
515   ) {
516     require(idToOwner[_tokenId] != address(0));
517     _;
518   }
519 
520   /**
521    * @dev Contract constructor.
522    */
523   constructor()
524     public
525   {
526     supportedInterfaces[0x80ac58cd] = true; // ERC721
527   }
528 
529   /**
530    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
531    * considered invalid, and this function throws for queries about the zero address.
532    * @param _owner Address for whom to query the balance.
533    */
534   function balanceOf(
535     address _owner
536   )
537     external
538     view
539     returns (uint256)
540   {
541     require(_owner != address(0));
542     return ownerToNFTokenCount[_owner];
543   }
544 
545   /**
546    * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered
547    * invalid, and queries about them do throw.
548    * @param _tokenId The identifier for an NFT.
549    */
550   function ownerOf(
551     uint256 _tokenId
552   )
553     external
554     view
555     returns (address _owner)
556   {
557     _owner = idToOwner[_tokenId];
558     require(_owner != address(0));
559   }
560 
561   /**
562    * @dev Transfers the ownership of an NFT from one address to another address.
563    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
564    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
565    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
566    * function checks if `_to` is a smart contract (code size > 0). If so, it calls `onERC721Received`
567    * on `_to` and throws if the return value is not `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
568    * @param _from The current owner of the NFT.
569    * @param _to The new owner.
570    * @param _tokenId The NFT to transfer.
571    * @param _data Additional data with no specified format, sent in call to `_to`.
572    */
573   function safeTransferFrom(
574     address _from,
575     address _to,
576     uint256 _tokenId,
577     bytes _data
578   )
579     external
580   {
581     _safeTransferFrom(_from, _to, _tokenId, _data);
582   }
583 
584   /**
585    * @dev Transfers the ownership of an NFT from one address to another address.
586    * @notice This works identically to the other function with an extra data parameter, except this
587    * function just sets data to ""
588    * @param _from The current owner of the NFT.
589    * @param _to The new owner.
590    * @param _tokenId The NFT to transfer.
591    */
592   function safeTransferFrom(
593     address _from,
594     address _to,
595     uint256 _tokenId
596   )
597     external
598   {
599     _safeTransferFrom(_from, _to, _tokenId, "");
600   }
601 
602   /**
603    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
604    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
605    * address. Throws if `_tokenId` is not a valid NFT.
606    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
607    * they maybe be permanently lost.
608    * @param _from The current owner of the NFT.
609    * @param _to The new owner.
610    * @param _tokenId The NFT to transfer.
611    */
612   function transferFrom(
613     address _from,
614     address _to,
615     uint256 _tokenId
616   )
617     external
618     canTransfer(_tokenId)
619     validNFToken(_tokenId)
620   {
621     address tokenOwner = idToOwner[_tokenId];
622     require(tokenOwner == _from);
623     require(_to != address(0));
624 
625     _transfer(_to, _tokenId);
626   }
627 
628   /**
629    * @dev Set or reaffirm the approved address for an NFT.
630    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
631    * the current NFT owner, or an authorized operator of the current owner.
632    * @param _approved Address to be approved for the given NFT ID.
633    * @param _tokenId ID of the token to be approved.
634    */
635   function approve(
636     address _approved,
637     uint256 _tokenId
638   )
639     external
640     canOperate(_tokenId)
641     validNFToken(_tokenId)
642   {
643     address tokenOwner = idToOwner[_tokenId];
644     require(_approved != tokenOwner);
645 
646     idToApprovals[_tokenId] = _approved;
647     emit Approval(tokenOwner, _approved, _tokenId);
648   }
649 
650   /**
651    * @dev Enables or disables approval for a third party ("operator") to manage all of
652    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
653    * @notice This works even if sender doesn't own any tokens at the time.
654    * @param _operator Address to add to the set of authorized operators.
655    * @param _approved True if the operators is approved, false to revoke approval.
656    */
657   function setApprovalForAll(
658     address _operator,
659     bool _approved
660   )
661     external
662   {
663     require(_operator != address(0));
664     ownerToOperators[msg.sender][_operator] = _approved;
665     emit ApprovalForAll(msg.sender, _operator, _approved);
666   }
667 
668   /**
669    * @dev Get the approved address for a single NFT.
670    * @notice Throws if `_tokenId` is not a valid NFT.
671    * @param _tokenId ID of the NFT to query the approval of.
672    */
673   function getApproved(
674     uint256 _tokenId
675   )
676     public
677     view
678     validNFToken(_tokenId)
679     returns (address)
680   {
681     return idToApprovals[_tokenId];
682   }
683 
684   /**
685    * @dev Checks if `_operator` is an approved operator for `_owner`.
686    * @param _owner The address that owns the NFTs.
687    * @param _operator The address that acts on behalf of the owner.
688    */
689   function isApprovedForAll(
690     address _owner,
691     address _operator
692   )
693     external
694     view
695     returns (bool)
696   {
697     require(_owner != address(0));
698     require(_operator != address(0));
699     return ownerToOperators[_owner][_operator];
700   }
701 
702   /**
703    * @dev Actually perform the safeTransferFrom.
704    * @param _from The current owner of the NFT.
705    * @param _to The new owner.
706    * @param _tokenId The NFT to transfer.
707    * @param _data Additional data with no specified format, sent in call to `_to`.
708    */
709   function _safeTransferFrom(
710     address _from,
711     address _to,
712     uint256 _tokenId,
713     bytes _data
714   )
715     internal
716     canTransfer(_tokenId)
717     validNFToken(_tokenId)
718   {
719     address tokenOwner = idToOwner[_tokenId];
720     require(tokenOwner == _from);
721     require(_to != address(0));
722 
723     _transfer(_to, _tokenId);
724 
725     if (_to.isContract()) {
726       bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
727       require(retval == MAGIC_ON_ERC721_RECEIVED);
728     }
729   }
730 
731   /**
732    * @dev Actually preforms the transfer.
733    * @notice Does NO checks.
734    * @param _to Address of a new owner.
735    * @param _tokenId The NFT that is being transferred.
736    */
737   function _transfer(
738     address _to,
739     uint256 _tokenId
740   )
741     private
742   {
743     address from = idToOwner[_tokenId];
744     clearApproval(_tokenId);
745 
746     removeNFToken(from, _tokenId);
747     addNFToken(_to, _tokenId);
748 
749     emit Transfer(from, _to, _tokenId);
750   }
751    
752   /**
753    * @dev Mints a new NFT.
754    * @notice This is a private function which should be called from user-implemented external
755    * mint function. Its purpose is to show and properly initialize data structures when using this
756    * implementation.
757    * @param _to The address that will own the minted NFT.
758    * @param _tokenId of the NFT to be minted by the msg.sender.
759    */
760   function _mint(
761     address _to,
762     uint256 _tokenId
763   )
764     internal
765   {
766     require(_to != address(0));
767     require(_tokenId != 0);
768     require(idToOwner[_tokenId] == address(0));
769 
770     addNFToken(_to, _tokenId);
771 
772     emit Transfer(address(0), _to, _tokenId);
773   }
774 
775   /**
776    * @dev Burns a NFT.
777    * @notice This is a private function which should be called from user-implemented external
778    * burn function. Its purpose is to show and properly initialize data structures when using this
779    * implementation.
780    * @param _owner Address of the NFT owner.
781    * @param _tokenId ID of the NFT to be burned.
782    */
783   function _burn(
784     address _owner,
785     uint256 _tokenId
786   )
787     validNFToken(_tokenId)
788     internal
789   {
790     clearApproval(_tokenId);
791     removeNFToken(_owner, _tokenId);
792     emit Transfer(_owner, address(0), _tokenId);
793   }
794 
795   /** 
796    * @dev Clears the current approval of a given NFT ID.
797    * @param _tokenId ID of the NFT to be transferred.
798    */
799   function clearApproval(
800     uint256 _tokenId
801   )
802     private
803   {
804     if(idToApprovals[_tokenId] != 0)
805     {
806       delete idToApprovals[_tokenId];
807     }
808   }
809 
810   /**
811    * @dev Removes a NFT from owner.
812    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
813    * @param _from Address from wich we want to remove the NFT.
814    * @param _tokenId Which NFT we want to remove.
815    */
816   function removeNFToken(
817     address _from,
818     uint256 _tokenId
819   )
820    internal
821   {
822     require(idToOwner[_tokenId] == _from);
823     assert(ownerToNFTokenCount[_from] > 0);
824     ownerToNFTokenCount[_from] = ownerToNFTokenCount[_from].sub(1);
825     delete idToOwner[_tokenId];
826   }
827 
828   /**
829    * @dev Assignes a new NFT to owner.
830    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
831    * @param _to Address to wich we want to add the NFT.
832    * @param _tokenId Which NFT we want to add.
833    */
834   function addNFToken(
835     address _to,
836     uint256 _tokenId
837   )
838     internal
839   {
840     require(idToOwner[_tokenId] == address(0));
841 
842     idToOwner[_tokenId] = _to;
843     ownerToNFTokenCount[_to] = ownerToNFTokenCount[_to].add(1);
844   }
845 
846 }
847 
848 // File: @0xcert/ethereum-erc721/contracts/tokens/ERC721Metadata.sol
849 
850 pragma solidity ^0.4.24;
851 
852 /**
853  * @dev Optional metadata extension for ERC-721 non-fungible token standard.
854  * See https://goo.gl/pc9yoS.
855  */
856 interface ERC721Metadata {
857 
858   /**
859    * @dev Returns a descriptive name for a collection of NFTs in this contract.
860    */
861   function name()
862     external
863     view
864     returns (string _name);
865 
866   /**
867    * @dev Returns a abbreviated name for a collection of NFTs in this contract.
868    */
869   function symbol()
870     external
871     view
872     returns (string _symbol);
873 
874   /**
875    * @dev Returns a distinct Uniform Resource Identifier (URI) for a given asset. It Throws if
876    * `_tokenId` is not a valid NFT. URIs are defined in RFC3986. The URI may point to a JSON file
877    * that conforms to the "ERC721 Metadata JSON Schema".
878    */
879   function tokenURI(uint256 _tokenId)
880     external
881     view
882     returns (string);
883 
884 }
885 
886 // File: @0xcert/ethereum-erc721/contracts/tokens/NFTokenMetadata.sol
887 
888 pragma solidity ^0.4.24;
889 
890 
891 
892 /**
893  * @dev Optional metadata implementation for ERC-721 non-fungible token standard.
894  */
895 contract NFTokenMetadata is
896   NFToken,
897   ERC721Metadata
898 {
899 
900   /**
901    * @dev A descriptive name for a collection of NFTs.
902    */
903   string internal nftName;
904 
905   /**
906    * @dev An abbreviated name for NFTokens.
907    */
908   string internal nftSymbol;
909 
910   /**
911    * @dev Mapping from NFT ID to metadata uri.
912    */
913   mapping (uint256 => string) internal idToUri;
914 
915   /**
916    * @dev Contract constructor.
917    * @notice When implementing this contract don't forget to set nftName and nftSymbol.
918    */
919   constructor()
920     public
921   {
922     supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
923   }
924 
925   /**
926    * @dev Burns a NFT.
927    * @notice This is a internal function which should be called from user-implemented external
928    * burn function. Its purpose is to show and properly initialize data structures when using this
929    * implementation.
930    * @param _owner Address of the NFT owner.
931    * @param _tokenId ID of the NFT to be burned.
932    */
933   function _burn(
934     address _owner,
935     uint256 _tokenId
936   )
937     internal
938   {
939     super._burn(_owner, _tokenId);
940 
941     if (bytes(idToUri[_tokenId]).length != 0) {
942       delete idToUri[_tokenId];
943     }
944   }
945 
946   /**
947    * @dev Set a distinct URI (RFC 3986) for a given NFT ID.
948    * @notice this is a internal function which should be called from user-implemented external
949    * function. Its purpose is to show and properly initialize data structures when using this
950    * implementation.
951    * @param _tokenId Id for which we want uri.
952    * @param _uri String representing RFC 3986 URI.
953    */
954   function _setTokenUri(
955     uint256 _tokenId,
956     string _uri
957   )
958     validNFToken(_tokenId)
959     internal
960   {
961     idToUri[_tokenId] = _uri;
962   }
963 
964   /**
965    * @dev Returns a descriptive name for a collection of NFTokens.
966    */
967   function name()
968     external
969     view
970     returns (string _name)
971   {
972     _name = nftName;
973   }
974 
975   /**
976    * @dev Returns an abbreviated name for NFTokens.
977    */
978   function symbol()
979     external
980     view
981     returns (string _symbol)
982   {
983     _symbol = nftSymbol;
984   }
985 
986   /**
987    * @dev A distinct URI (RFC 3986) for a given NFT.
988    * @param _tokenId Id for which we want uri.
989    */
990   function tokenURI(
991     uint256 _tokenId
992   )
993     validNFToken(_tokenId)
994     external
995     view
996     returns (string)
997   {
998     return idToUri[_tokenId];
999   }
1000 
1001 }
1002 
1003 // File: @0xcert/ethereum-erc721/contracts/tokens/ERC721Enumerable.sol
1004 
1005 pragma solidity ^0.4.24;
1006 
1007 /**
1008  * @dev Optional enumeration extension for ERC-721 non-fungible token standard.
1009  * See https://goo.gl/pc9yoS.
1010  */
1011 interface ERC721Enumerable {
1012 
1013   /**
1014    * @dev Returns a count of valid NFTs tracked by this contract, where each one of them has an
1015    * assigned and queryable owner not equal to the zero address.
1016    */
1017   function totalSupply()
1018     external
1019     view
1020     returns (uint256);
1021 
1022   /**
1023    * @dev Returns the token identifier for the `_index`th NFT. Sort order is not specified.
1024    * @param _index A counter less than `totalSupply()`.
1025    */
1026   function tokenByIndex(
1027     uint256 _index
1028   )
1029     external
1030     view
1031     returns (uint256);
1032 
1033   /**
1034    * @dev Returns the token identifier for the `_index`th NFT assigned to `_owner`. Sort order is
1035    * not specified. It throws if `_index` >= `balanceOf(_owner)` or if `_owner` is the zero address,
1036    * representing invalid NFTs.
1037    * @param _owner An address where we are interested in NFTs owned by them.
1038    * @param _index A counter less than `balanceOf(_owner)`.
1039    */
1040   function tokenOfOwnerByIndex(
1041     address _owner,
1042     uint256 _index
1043   )
1044     external
1045     view
1046     returns (uint256);
1047 
1048 }
1049 
1050 // File: @0xcert/ethereum-erc721/contracts/tokens/NFTokenEnumerable.sol
1051 
1052 pragma solidity ^0.4.24;
1053 
1054 
1055 
1056 /**
1057  * @dev Optional enumeration implementation for ERC-721 non-fungible token standard.
1058  */
1059 contract NFTokenEnumerable is
1060   NFToken,
1061   ERC721Enumerable
1062 {
1063 
1064   /**
1065    * @dev Array of all NFT IDs.
1066    */
1067   uint256[] internal tokens;
1068 
1069   /**
1070    * @dev Mapping from token ID its index in global tokens array.
1071    */
1072   mapping(uint256 => uint256) internal idToIndex;
1073 
1074   /**
1075    * @dev Mapping from owner to list of owned NFT IDs.
1076    */
1077   mapping(address => uint256[]) internal ownerToIds;
1078 
1079   /**
1080    * @dev Mapping from NFT ID to its index in the owner tokens list.
1081    */
1082   mapping(uint256 => uint256) internal idToOwnerIndex;
1083 
1084   /**
1085    * @dev Contract constructor.
1086    */
1087   constructor()
1088     public
1089   {
1090     supportedInterfaces[0x780e9d63] = true; // ERC721Enumerable
1091   }
1092 
1093   /**
1094    * @dev Mints a new NFT.
1095    * @notice This is a private function which should be called from user-implemented external
1096    * mint function. Its purpose is to show and properly initialize data structures when using this
1097    * implementation.
1098    * @param _to The address that will own the minted NFT.
1099    * @param _tokenId of the NFT to be minted by the msg.sender.
1100    */
1101   function _mint(
1102     address _to,
1103     uint256 _tokenId
1104   )
1105     internal
1106   {
1107     super._mint(_to, _tokenId);
1108     tokens.push(_tokenId);
1109     idToIndex[_tokenId] = tokens.length.sub(1);
1110   }
1111 
1112   /**
1113    * @dev Burns a NFT.
1114    * @notice This is a private function which should be called from user-implemented external
1115    * burn function. Its purpose is to show and properly initialize data structures when using this
1116    * implementation.
1117    * @param _owner Address of the NFT owner.
1118    * @param _tokenId ID of the NFT to be burned.
1119    */
1120   function _burn(
1121     address _owner,
1122     uint256 _tokenId
1123   )
1124     internal
1125   {
1126     super._burn(_owner, _tokenId);
1127     assert(tokens.length > 0);
1128 
1129     uint256 tokenIndex = idToIndex[_tokenId];
1130     // Sanity check. This could be removed in the future.
1131     assert(tokens[tokenIndex] == _tokenId);
1132     uint256 lastTokenIndex = tokens.length.sub(1);
1133     uint256 lastToken = tokens[lastTokenIndex];
1134 
1135     tokens[tokenIndex] = lastToken;
1136 
1137     tokens.length--;
1138     // Consider adding a conditional check for the last token in order to save GAS.
1139     idToIndex[lastToken] = tokenIndex;
1140     idToIndex[_tokenId] = 0;
1141   }
1142 
1143   /**
1144    * @dev Removes a NFT from an address.
1145    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
1146    * @param _from Address from wich we want to remove the NFT.
1147    * @param _tokenId Which NFT we want to remove.
1148    */
1149   function removeNFToken(
1150     address _from,
1151     uint256 _tokenId
1152   )
1153    internal
1154   {
1155     super.removeNFToken(_from, _tokenId);
1156     assert(ownerToIds[_from].length > 0);
1157 
1158     uint256 tokenToRemoveIndex = idToOwnerIndex[_tokenId];
1159     uint256 lastTokenIndex = ownerToIds[_from].length.sub(1);
1160     uint256 lastToken = ownerToIds[_from][lastTokenIndex];
1161 
1162     ownerToIds[_from][tokenToRemoveIndex] = lastToken;
1163 
1164     ownerToIds[_from].length--;
1165     // Consider adding a conditional check for the last token in order to save GAS.
1166     idToOwnerIndex[lastToken] = tokenToRemoveIndex;
1167     idToOwnerIndex[_tokenId] = 0;
1168   }
1169 
1170   /**
1171    * @dev Assignes a new NFT to an address.
1172    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
1173    * @param _to Address to wich we want to add the NFT.
1174    * @param _tokenId Which NFT we want to add.
1175    */
1176   function addNFToken(
1177     address _to,
1178     uint256 _tokenId
1179   )
1180     internal
1181   {
1182     super.addNFToken(_to, _tokenId);
1183 
1184     uint256 length = ownerToIds[_to].length;
1185     ownerToIds[_to].push(_tokenId);
1186     idToOwnerIndex[_tokenId] = length;
1187   }
1188 
1189   /**
1190    * @dev Returns the count of all existing NFTokens.
1191    */
1192   function totalSupply()
1193     external
1194     view
1195     returns (uint256)
1196   {
1197     return tokens.length;
1198   }
1199 
1200   /**
1201    * @dev Returns NFT ID by its index.
1202    * @param _index A counter less than `totalSupply()`.
1203    */
1204   function tokenByIndex(
1205     uint256 _index
1206   )
1207     external
1208     view
1209     returns (uint256)
1210   {
1211     require(_index < tokens.length);
1212     // Sanity check. This could be removed in the future.
1213     assert(idToIndex[tokens[_index]] == _index);
1214     return tokens[_index];
1215   }
1216 
1217   /**
1218    * @dev returns the n-th NFT ID from a list of owner's tokens.
1219    * @param _owner Token owner's address.
1220    * @param _index Index number representing n-th token in owner's list of tokens.
1221    */
1222   function tokenOfOwnerByIndex(
1223     address _owner,
1224     uint256 _index
1225   )
1226     external
1227     view
1228     returns (uint256)
1229   {
1230     require(_index < ownerToIds[_owner].length);
1231     return ownerToIds[_owner][_index];
1232   }
1233 
1234 }
1235 
1236 // File: @0xcert/ethereum-utils/contracts/ownership/Ownable.sol
1237 
1238 pragma solidity ^0.4.24;
1239 
1240 /**
1241  * @dev The contract has an owner address, and provides basic authorization control whitch
1242  * simplifies the implementation of user permissions. This contract is based on the source code
1243  * at https://goo.gl/n2ZGVt.
1244  */
1245 contract Ownable {
1246   address public owner;
1247 
1248   /**
1249    * @dev An event which is triggered when the owner is changed.
1250    * @param previousOwner The address of the previous owner.
1251    * @param newOwner The address of the new owner.
1252    */
1253   event OwnershipTransferred(
1254     address indexed previousOwner,
1255     address indexed newOwner
1256   );
1257 
1258   /**
1259    * @dev The constructor sets the original `owner` of the contract to the sender account.
1260    */
1261   constructor()
1262     public
1263   {
1264     owner = msg.sender;
1265   }
1266 
1267   /**
1268    * @dev Throws if called by any account other than the owner.
1269    */
1270   modifier onlyOwner() {
1271     require(msg.sender == owner);
1272     _;
1273   }
1274 
1275   /**
1276    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1277    * @param _newOwner The address to transfer ownership to.
1278    */
1279   function transferOwnership(
1280     address _newOwner
1281   )
1282     onlyOwner
1283     public
1284   {
1285     require(_newOwner != address(0));
1286     emit OwnershipTransferred(owner, _newOwner);
1287     owner = _newOwner;
1288   }
1289 
1290 }
1291 
1292 // File: @0xcert/ethereum-utils/contracts/ownership/Claimable.sol
1293 
1294 pragma solidity ^0.4.24;
1295 
1296 
1297 /**
1298  * @dev The contract has an owner address, and provides basic authorization control whitch
1299  * simplifies the implementation of user permissions. This contract is based on the source code
1300  * at goo.gl/CfEAkv and upgrades Ownable contracts with additional claim step which makes ownership
1301  * transfers less prone to errors.
1302  */
1303 contract Claimable is Ownable {
1304   address public pendingOwner;
1305 
1306   /**
1307    * @dev An event which is triggered when the owner is changed.
1308    * @param previousOwner The address of the previous owner.
1309    * @param newOwner The address of the new owner.
1310    */
1311   event OwnershipTransferred(
1312     address indexed previousOwner,
1313     address indexed newOwner
1314   );
1315 
1316   /**
1317    * @dev Allows the current owner to give new owner ability to claim the ownership of the contract.
1318    * This differs from the Owner's function in that it allows setting pedingOwner address to 0x0,
1319    * which effectively cancels an active claim.
1320    * @param _newOwner The address which can claim ownership of the contract.
1321    */
1322   function transferOwnership(
1323     address _newOwner
1324   )
1325     onlyOwner
1326     public
1327   {
1328     pendingOwner = _newOwner;
1329   }
1330 
1331   /**
1332    * @dev Allows the current pending owner to claim the ownership of the contract. It emits
1333    * OwnershipTransferred event and resets pending owner to 0.
1334    */
1335   function claimOwnership()
1336     public
1337   {
1338     require(msg.sender == pendingOwner);
1339     address previousOwner = owner;
1340     owner = pendingOwner;
1341     pendingOwner = 0;
1342     emit OwnershipTransferred(previousOwner, owner);
1343   }
1344 }
1345 
1346 // File: contracts/Adminable.sol
1347 
1348 pragma solidity ^0.4.24;
1349 
1350 
1351 /**
1352  * @title Adminable
1353  * @dev Allows to manage privilages to special contract functionality.
1354  */
1355 contract Adminable is Claimable {
1356   mapping(address => uint) public adminsMap;
1357   address[] public adminList;
1358 
1359   /**
1360    * @dev Returns true, if provided address has special privilages, otherwise false
1361    * @param adminAddress - address to check
1362    */
1363   function isAdmin(address adminAddress)
1364     public
1365     view
1366     returns(bool isIndeed)
1367   {
1368     if (adminAddress == owner) return true;
1369 
1370     if (adminList.length == 0) return false;
1371     return (adminList[adminsMap[adminAddress]] == adminAddress);
1372   }
1373 
1374   /**
1375    * @dev Grants special rights for address holder
1376    * @param adminAddress - address of future admin
1377    */
1378   function addAdmin(address adminAddress)
1379     public
1380     onlyOwner
1381     returns(uint index)
1382   {
1383     require(!isAdmin(adminAddress), "Address already has admin rights!");
1384 
1385     adminsMap[adminAddress] = adminList.push(adminAddress)-1;
1386 
1387     return adminList.length-1;
1388   }
1389 
1390   /**
1391    * @dev Removes special rights for provided address
1392    * @param adminAddress - address of current admin
1393    */
1394   function removeAdmin(address adminAddress)
1395     public
1396     onlyOwner
1397     returns(uint index)
1398   {
1399     // we can not remove owner from admin role
1400     require(owner != adminAddress, "Owner can not be removed from admin role!");
1401     require(isAdmin(adminAddress), "Provided address is not admin.");
1402 
1403     uint rowToDelete = adminsMap[adminAddress];
1404     address keyToMove = adminList[adminList.length-1];
1405     adminList[rowToDelete] = keyToMove;
1406     adminsMap[keyToMove] = rowToDelete;
1407     adminList.length--;
1408 
1409     return rowToDelete;
1410   }
1411 
1412   /**
1413    * @dev modifier Throws if called by any account other than the owner.
1414    */
1415   modifier onlyAdmin() {
1416     require(isAdmin(msg.sender), "Can be executed only by admin accounts!");
1417     _;
1418   }
1419 }
1420 
1421 // File: contracts/MarbleNFTInterface.sol
1422 
1423 pragma solidity ^0.4.24;
1424 
1425 /**
1426  * @title Marble NFT Interface
1427  * @dev Defines Marbles unique extension of NFT.
1428  * ...It contains methodes returning core properties what describe Marble NFTs and provides management options to create,
1429  * burn NFT or change approvals of it.
1430  */
1431 interface MarbleNFTInterface {
1432 
1433   /**
1434    * @dev Mints Marble NFT.
1435    * @notice This is a external function which should be called just by the owner of contract or any other user who has priviladge of being resposible
1436    * of creating valid Marble NFT. Valid token contains all neccessary information to be able recreate marble card image.
1437    * @param _tokenId The ID of new NFT.
1438    * @param _owner Address of the NFT owner.
1439    * @param _uri Unique URI proccessed by Marble services to be sure it is valid NFTs DNA. Most likely it is URL pointing to some website address.
1440    * @param _metadataUri URI pointing to "ERC721 Metadata JSON Schema"
1441    * @param _tokenId ID of the NFT to be burned.
1442    */
1443   function mint(
1444     uint256 _tokenId,
1445     address _owner,
1446     address _creator,
1447     string _uri,
1448     string _metadataUri,
1449     uint256 _created
1450   )
1451     external;
1452 
1453   /**
1454    * @dev Burns Marble NFT. Should be fired only by address with proper authority as contract owner or etc.
1455    * @param _tokenId ID of the NFT to be burned.
1456    */
1457   function burn(
1458     uint256 _tokenId
1459   )
1460     external;
1461 
1462   /**
1463    * @dev Allowes to change approval for change of ownership even when sender is not NFT holder. Sender has to have special role granted by contract to use this tool.
1464    * @notice Careful with this!!!! :))
1465    * @param _tokenId ID of the NFT to be updated.
1466    * @param _approved ETH address what supposed to gain approval to take ownership of NFT.
1467    */
1468   function forceApproval(
1469     uint256 _tokenId,
1470     address _approved
1471   )
1472     external;
1473 
1474   /**
1475    * @dev Returns properties used for generating NFT metadata image (a.k.a. card).
1476    * @param _tokenId ID of the NFT.
1477    */
1478   function tokenSource(uint256 _tokenId)
1479     external
1480     view
1481     returns (
1482       string uri,
1483       address creator,
1484       uint256 created
1485     );
1486 
1487   /**
1488    * @dev Returns ID of NFT what matches provided source URI.
1489    * @param _uri URI of source website.
1490    */
1491   function tokenBySourceUri(string _uri)
1492     external
1493     view
1494     returns (uint256 tokenId);
1495 
1496   /**
1497    * @dev Returns all properties of Marble NFT. Lets call it Marble NFT Model with properties described below:
1498    * @param _tokenId ID  of NFT
1499    * Returned model:
1500    * uint256 id ID of NFT
1501    * string uri  URI of source website. Website is used to mine data to crate NFT metadata image.
1502    * string metadataUri URI to NFT metadata assets. In our case to our websevice providing JSON with additional information based on "ERC721 Metadata JSON Schema".
1503    * address owner NFT owner address.
1504    * address creator Address of creator of this NFT. It means that this addres placed sourceURI to candidate contract.
1505    * uint256 created Date and time of creation of NFT candidate.
1506    *
1507    * (id, uri, metadataUri, owner, creator, created)
1508    */
1509   function getNFT(uint256 _tokenId)
1510     external
1511     view
1512     returns(
1513       uint256 id,
1514       string uri,
1515       string metadataUri,
1516       address owner,
1517       address creator,
1518       uint256 created
1519     );
1520 
1521 
1522     /**
1523      * @dev Transforms URI to hash.
1524      * @param _uri URI to be transformed to hash.
1525      */
1526     function getSourceUriHash(string _uri)
1527       external
1528       view
1529       returns(uint256 hash);
1530 }
1531 
1532 // File: contracts/MarbleNFT.sol
1533 
1534 pragma solidity ^0.4.24;
1535 
1536 
1537 
1538 
1539 
1540 /**
1541  * @title MARBLE NFT CONTRACT
1542  * @notice We omit a fallback function to prevent accidental sends to this contract.
1543  */
1544 contract MarbleNFT is
1545   Adminable,
1546   NFTokenMetadata,
1547   NFTokenEnumerable,
1548   MarbleNFTInterface
1549 {
1550 
1551   /*
1552    * @dev structure storing additional information about created NFT
1553    * uri: URI used as source/key/representation of NFT, it can be considered as tokens DNA
1554    * creator:  address of candidate creator - a.k.a. address of person who initialy provided source URI
1555    * created: date of NFT creation
1556    */
1557   struct MarbleNFTSource {
1558 
1559     // URI used as source/key of NFT, we can consider it as tokens DNA
1560     string uri;
1561 
1562     // address of candidate creator - a.k.a. address of person who initialy provided source URI
1563     address creator;
1564 
1565     // date of NFT creation
1566     uint256 created;
1567   }
1568 
1569   /**
1570    * @dev Mapping from NFT ID to marble NFT source.
1571    */
1572   mapping (uint256 => MarbleNFTSource) public idToMarbleNFTSource;
1573   /**
1574    * @dev Mapping from marble NFT source uri hash TO NFT ID .
1575    */
1576   mapping (uint256 => uint256) public sourceUriHashToId;
1577 
1578   constructor()
1579     public
1580   {
1581     nftName = "MARBLE-NFT";
1582     nftSymbol = "MRBLNFT";
1583   }
1584 
1585   /**
1586    * @dev Mints a new NFT.
1587    * @param _tokenId The unique number representing NFT
1588    * @param _owner Holder of Marble NFT
1589    * @param _creator Creator of Marble NFT
1590    * @param _uri URI representing NFT
1591    * @param _metadataUri URI pointing to "ERC721 Metadata JSON Schema"
1592    * @param _created date of creation of NFT candidate
1593    */
1594   function mint(
1595     uint256 _tokenId,
1596     address _owner,
1597     address _creator,
1598     string _uri,
1599     string _metadataUri,
1600     uint256 _created
1601   )
1602     external
1603     onlyAdmin
1604   {
1605     uint256 uriHash = _getSourceUriHash(_uri);
1606 
1607     require(uriHash != _getSourceUriHash(""), "NFT URI can not be empty!");
1608     require(sourceUriHashToId[uriHash] == 0, "NFT with same URI already exists!");
1609 
1610     _mint(_owner, _tokenId);
1611     _setTokenUri(_tokenId, _metadataUri);
1612 
1613     idToMarbleNFTSource[_tokenId] = MarbleNFTSource(_uri, _creator, _created);
1614     sourceUriHashToId[uriHash] = _tokenId;
1615   }
1616 
1617   /**
1618    * @dev Burns NFT. Sadly, trully.. ...probably someone marbled something ugly!!!! :)
1619    * @param _tokenId ID of ugly NFT
1620    */
1621   function burn(
1622     uint256 _tokenId
1623   )
1624     external
1625     onlyAdmin
1626   {
1627     address owner = idToOwner[_tokenId];
1628 
1629     MarbleNFTSource memory marbleNFTSource = idToMarbleNFTSource[_tokenId];
1630 
1631     if (bytes(marbleNFTSource.uri).length != 0) {
1632       uint256 uriHash = _getSourceUriHash(marbleNFTSource.uri);
1633       delete sourceUriHashToId[uriHash];
1634       delete idToMarbleNFTSource[_tokenId];
1635     }
1636 
1637     _burn(owner, _tokenId);
1638   }
1639 
1640   /**
1641    * @dev Tool to manage misstreated NFTs or to be able to extend our services for new cool stuff like auctions, weird games and so on......
1642    * @param _tokenId ID of the NFT to be update.
1643    * @param _approved Address to replace current approved address on NFT
1644    */
1645   function forceApproval(
1646     uint256 _tokenId,
1647     address _approved
1648   )
1649     external
1650     onlyAdmin
1651   {
1652     address tokenOwner = idToOwner[_tokenId];
1653     require(_approved != tokenOwner,"Owner can not be become new owner!");
1654 
1655     idToApprovals[_tokenId] = _approved;
1656     emit Approval(tokenOwner, _approved, _tokenId);
1657   }
1658 
1659   /**
1660    * @dev Returns model of Marble NFT source properties
1661    * @param _tokenId ID of the NFT
1662    */
1663   function tokenSource(uint256 _tokenId)
1664     external
1665     view
1666     returns (
1667       string uri,
1668       address creator,
1669       uint256 created)
1670   {
1671     MarbleNFTSource memory marbleNFTSource = idToMarbleNFTSource[_tokenId];
1672     return (marbleNFTSource.uri, marbleNFTSource.creator, marbleNFTSource.created);
1673   }
1674 
1675   /**
1676    * @dev Returns token ID related to provided source uri
1677    * @param _uri URI representing created NFT
1678    */
1679   function tokenBySourceUri(string _uri)
1680     external
1681     view
1682     returns (uint256 tokenId)
1683   {
1684     return sourceUriHashToId[_getSourceUriHash(_uri)];
1685   }
1686 
1687   /**
1688    * @dev Returns whole Marble NFT model
1689    * --------------------
1690    *   MARBLE NFT MODEL
1691    * --------------------
1692    * uint256 id NFT unique identification
1693    * string uri NFT source URI, source is whole site what was proccessed by marble to create this NFT, it is URI representation of NFT (call it DNA)
1694    * string metadataUri  URI pointint to token NFT metadata shcema
1695    * address owner Current NFT owner
1696    * address creator First NFT owner
1697    * uint256 created Date of NFT candidate creation
1698    *
1699    * (id, uri, metadataUri, owner, creator, created)
1700    */
1701   function getNFT(uint256 _tokenId)
1702     external
1703     view
1704     returns(
1705       uint256 id,
1706       string uri,
1707       string metadataUri,
1708       address owner,
1709       address creator,
1710       uint256 created
1711     )
1712   {
1713 
1714     MarbleNFTSource memory marbleNFTSource = idToMarbleNFTSource[_tokenId];
1715 
1716     return (
1717       _tokenId,
1718       marbleNFTSource.uri,
1719       idToUri[_tokenId],
1720       idToOwner[_tokenId],
1721       marbleNFTSource.creator,
1722       marbleNFTSource.created);
1723   }
1724 
1725 
1726   /**
1727    * @dev Transforms URI to hash.
1728    * @param _uri URI to be transformed to hash.
1729    */
1730   function getSourceUriHash(string _uri)
1731      external
1732      view
1733      returns(uint256 hash)
1734   {
1735      return _getSourceUriHash(_uri);
1736   }
1737 
1738   /**
1739    * @dev Transforms URI to hash.
1740    * @param _uri URI to be transformed to hash.
1741    */
1742   function _getSourceUriHash(string _uri)
1743     internal
1744     pure
1745     returns(uint256 hash)
1746   {
1747     return uint256(keccak256(abi.encodePacked(_uri)));
1748   }
1749 }