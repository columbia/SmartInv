1 pragma solidity ^0.4.24;
2 
3 // File: contracts/tokens/ERC721.sol
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
172 // File: contracts/tokens/ERC721TokenReceiver.sol
173 
174 /**
175  * @dev ERC-721 interface for accepting safe transfers. See https://goo.gl/pc9yoS.
176  */
177 interface ERC721TokenReceiver {
178 
179   /**
180    * @dev Handle the receipt of a NFT. The ERC721 smart contract calls this function on the
181    * recipient after a `transfer`. This function MAY throw to revert and reject the transfer. Return
182    * of other than the magic value MUST result in the transaction being reverted.
183    * Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))` unless throwing.
184    * @notice The contract address is always the message sender. A wallet/broker/auction application
185    * MUST implement the wallet interface if it will accept safe transfers.
186    * @param _operator The address which called `safeTransferFrom` function.
187    * @param _from The address which previously owned the token.
188    * @param _tokenId The NFT identifier which is being transferred.
189    * @param _data Additional data with no specified format.
190    */
191   function onERC721Received(
192     address _operator,
193     address _from,
194     uint256 _tokenId,
195     bytes _data
196   )
197     external
198     returns(bytes4);
199     
200 }
201 
202 // File: @0xcert/ethereum-utils/contracts/math/SafeMath.sol
203 
204 /**
205  * @dev Math operations with safety checks that throw on error. This contract is based
206  * on the source code at https://goo.gl/iyQsmU.
207  */
208 library SafeMath {
209 
210   /**
211    * @dev Multiplies two numbers, throws on overflow.
212    * @param _a Factor number.
213    * @param _b Factor number.
214    */
215   function mul(
216     uint256 _a,
217     uint256 _b
218   )
219     internal
220     pure
221     returns (uint256)
222   {
223     if (_a == 0) {
224       return 0;
225     }
226     uint256 c = _a * _b;
227     assert(c / _a == _b);
228     return c;
229   }
230 
231   /**
232    * @dev Integer division of two numbers, truncating the quotient.
233    * @param _a Dividend number.
234    * @param _b Divisor number.
235    */
236   function div(
237     uint256 _a,
238     uint256 _b
239   )
240     internal
241     pure
242     returns (uint256)
243   {
244     uint256 c = _a / _b;
245     // assert(b > 0); // Solidity automatically throws when dividing by 0
246     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
247     return c;
248   }
249 
250   /**
251    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
252    * @param _a Minuend number.
253    * @param _b Subtrahend number.
254    */
255   function sub(
256     uint256 _a,
257     uint256 _b
258   )
259     internal
260     pure
261     returns (uint256)
262   {
263     assert(_b <= _a);
264     return _a - _b;
265   }
266 
267   /**
268    * @dev Adds two numbers, throws on overflow.
269    * @param _a Number.
270    * @param _b Number.
271    */
272   function add(
273     uint256 _a,
274     uint256 _b
275   )
276     internal
277     pure
278     returns (uint256)
279   {
280     uint256 c = _a + _b;
281     assert(c >= _a);
282     return c;
283   }
284 
285 }
286 
287 // File: @0xcert/ethereum-utils/contracts/utils/ERC165.sol
288 
289 /**
290  * @dev A standard for detecting smart contract interfaces. See https://goo.gl/cxQCse.
291  */
292 interface ERC165 {
293 
294   /**
295    * @dev Checks if the smart contract includes a specific interface.
296    * @notice This function uses less than 30,000 gas.
297    * @param _interfaceID The interface identifier, as specified in ERC-165.
298    */
299   function supportsInterface(
300     bytes4 _interfaceID
301   )
302     external
303     view
304     returns (bool);
305 
306 }
307 
308 // File: @0xcert/ethereum-utils/contracts/utils/SupportsInterface.sol
309 
310 /**
311  * @dev Implementation of standard for detect smart contract interfaces.
312  */
313 contract SupportsInterface is
314   ERC165
315 {
316 
317   /**
318    * @dev Mapping of supported intefraces.
319    * @notice You must not set element 0xffffffff to true.
320    */
321   mapping(bytes4 => bool) internal supportedInterfaces;
322 
323   /**
324    * @dev Contract constructor.
325    */
326   constructor()
327     public
328   {
329     supportedInterfaces[0x01ffc9a7] = true; // ERC165
330   }
331 
332   /**
333    * @dev Function to check which interfaces are suported by this contract.
334    * @param _interfaceID Id of the interface.
335    */
336   function supportsInterface(
337     bytes4 _interfaceID
338   )
339     external
340     view
341     returns (bool)
342   {
343     return supportedInterfaces[_interfaceID];
344   }
345 
346 }
347 
348 // File: @0xcert/ethereum-utils/contracts/utils/AddressUtils.sol
349 
350 /**
351  * @dev Utility library of inline functions on addresses.
352  */
353 library AddressUtils {
354 
355   /**
356    * @dev Returns whether the target address is a contract.
357    * @param _addr Address to check.
358    */
359   function isContract(
360     address _addr
361   )
362     internal
363     view
364     returns (bool)
365   {
366     uint256 size;
367 
368     /**
369      * XXX Currently there is no better way to check if there is a contract in an address than to
370      * check the size of the code at that address.
371      * See https://ethereum.stackexchange.com/a/14016/36603 for more details about how this works.
372      * TODO: Check this again before the Serenity release, because all addresses will be
373      * contracts then.
374      */
375     assembly { size := extcodesize(_addr) } // solium-disable-line security/no-inline-assembly
376     return size > 0;
377   }
378 
379 }
380 
381 // File: contracts/tokens/NFToken.sol
382 
383 /**
384  * @dev Implementation of ERC-721 non-fungible token standard.
385  */
386 contract NFToken is
387   ERC721,
388   SupportsInterface
389 {
390   using SafeMath for uint256;
391   using AddressUtils for address;
392 
393   /**
394    * @dev A mapping from NFT ID to the address that owns it.
395    */
396   mapping (uint256 => address) internal idToOwner;
397 
398   /**
399    * @dev Mapping from NFT ID to approved address.
400    */
401   mapping (uint256 => address) internal idToApprovals;
402 
403    /**
404    * @dev Mapping from owner address to count of his tokens.
405    */
406   mapping (address => uint256) internal ownerToNFTokenCount;
407 
408   /**
409    * @dev Mapping from owner address to mapping of operator addresses.
410    */
411   mapping (address => mapping (address => bool)) internal ownerToOperators;
412 
413   /**
414    * @dev Magic value of a smart contract that can recieve NFT.
415    * Equal to: bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")).
416    */
417   bytes4 constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
418 
419   /**
420    * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
421    * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
422    * number of NFTs may be created and assigned without emitting Transfer. At the time of any
423    * transfer, the approved address for that NFT (if any) is reset to none.
424    * @param _from Sender of NFT (if address is zero address it indicates token creation).
425    * @param _to Receiver of NFT (if address is zero address it indicates token destruction).
426    * @param _tokenId The NFT that got transfered.
427    */
428   event Transfer(
429     address indexed _from,
430     address indexed _to,
431     uint256 indexed _tokenId
432   );
433 
434   /**
435    * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
436    * address indicates there is no approved address. When a Transfer event emits, this also
437    * indicates that the approved address for that NFT (if any) is reset to none.
438    * @param _owner Owner of NFT.
439    * @param _approved Address that we are approving.
440    * @param _tokenId NFT which we are approving.
441    */
442   event Approval(
443     address indexed _owner,
444     address indexed _approved,
445     uint256 indexed _tokenId
446   );
447 
448   /**
449    * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
450    * all NFTs of the owner.
451    * @param _owner Owner of NFT.
452    * @param _operator Address to which we are setting operator rights.
453    * @param _approved Status of operator rights(true if operator rights are given and false if
454    * revoked).
455    */
456   event ApprovalForAll(
457     address indexed _owner,
458     address indexed _operator,
459     bool _approved
460   );
461 
462   /**
463    * @dev Guarantees that the msg.sender is an owner or operator of the given NFT.
464    * @param _tokenId ID of the NFT to validate.
465    */
466   modifier canOperate(
467     uint256 _tokenId
468   ) {
469     address tokenOwner = idToOwner[_tokenId];
470     require(tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender]);
471     _;
472   }
473 
474   /**
475    * @dev Guarantees that the msg.sender is allowed to transfer NFT.
476    * @param _tokenId ID of the NFT to transfer.
477    */
478   modifier canTransfer(
479     uint256 _tokenId
480   ) {
481     address tokenOwner = idToOwner[_tokenId];
482     require(
483       tokenOwner == msg.sender
484       || getApproved(_tokenId) == msg.sender
485       || ownerToOperators[tokenOwner][msg.sender]
486     );
487 
488     _;
489   }
490 
491   /**
492    * @dev Guarantees that _tokenId is a valid Token.
493    * @param _tokenId ID of the NFT to validate.
494    */
495   modifier validNFToken(
496     uint256 _tokenId
497   ) {
498     require(idToOwner[_tokenId] != address(0));
499     _;
500   }
501 
502   /**
503    * @dev Contract constructor.
504    */
505   constructor()
506     public
507   {
508     supportedInterfaces[0x80ac58cd] = true; // ERC721
509   }
510 
511   /**
512    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
513    * considered invalid, and this function throws for queries about the zero address.
514    * @param _owner Address for whom to query the balance.
515    */
516   function balanceOf(
517     address _owner
518   )
519     external
520     view
521     returns (uint256)
522   {
523     require(_owner != address(0));
524     return ownerToNFTokenCount[_owner];
525   }
526 
527   /**
528    * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered
529    * invalid, and queries about them do throw.
530    * @param _tokenId The identifier for an NFT.
531    */
532   function ownerOf(
533     uint256 _tokenId
534   )
535     external
536     view
537     returns (address _owner)
538   {
539     _owner = idToOwner[_tokenId];
540     require(_owner != address(0));
541   }
542 
543   /**
544    * @dev Transfers the ownership of an NFT from one address to another address.
545    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
546    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
547    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
548    * function checks if `_to` is a smart contract (code size > 0). If so, it calls `onERC721Received`
549    * on `_to` and throws if the return value is not `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
550    * @param _from The current owner of the NFT.
551    * @param _to The new owner.
552    * @param _tokenId The NFT to transfer.
553    * @param _data Additional data with no specified format, sent in call to `_to`.
554    */
555   function safeTransferFrom(
556     address _from,
557     address _to,
558     uint256 _tokenId,
559     bytes _data
560   )
561     external
562   {
563     _safeTransferFrom(_from, _to, _tokenId, _data);
564   }
565 
566   /**
567    * @dev Transfers the ownership of an NFT from one address to another address.
568    * @notice This works identically to the other function with an extra data parameter, except this
569    * function just sets data to ""
570    * @param _from The current owner of the NFT.
571    * @param _to The new owner.
572    * @param _tokenId The NFT to transfer.
573    */
574   function safeTransferFrom(
575     address _from,
576     address _to,
577     uint256 _tokenId
578   )
579     external
580   {
581     _safeTransferFrom(_from, _to, _tokenId, "");
582   }
583 
584   /**
585    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
586    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
587    * address. Throws if `_tokenId` is not a valid NFT.
588    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
589    * they maybe be permanently lost.
590    * @param _from The current owner of the NFT.
591    * @param _to The new owner.
592    * @param _tokenId The NFT to transfer.
593    */
594   function transferFrom(
595     address _from,
596     address _to,
597     uint256 _tokenId
598   )
599     external
600     canTransfer(_tokenId)
601     validNFToken(_tokenId)
602   {
603     address tokenOwner = idToOwner[_tokenId];
604     require(tokenOwner == _from);
605     require(_to != address(0));
606 
607     _transfer(_to, _tokenId);
608   }
609 
610   /**
611    * @dev Set or reaffirm the approved address for an NFT.
612    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
613    * the current NFT owner, or an authorized operator of the current owner.
614    * @param _approved Address to be approved for the given NFT ID.
615    * @param _tokenId ID of the token to be approved.
616    */
617   function approve(
618     address _approved,
619     uint256 _tokenId
620   )
621     external
622     canOperate(_tokenId)
623     validNFToken(_tokenId)
624   {
625     address tokenOwner = idToOwner[_tokenId];
626     require(_approved != tokenOwner);
627 
628     idToApprovals[_tokenId] = _approved;
629     emit Approval(tokenOwner, _approved, _tokenId);
630   }
631 
632   /**
633    * @dev Enables or disables approval for a third party ("operator") to manage all of
634    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
635    * @notice This works even if sender doesn't own any tokens at the time.
636    * @param _operator Address to add to the set of authorized operators.
637    * @param _approved True if the operators is approved, false to revoke approval.
638    */
639   function setApprovalForAll(
640     address _operator,
641     bool _approved
642   )
643     external
644   {
645     require(_operator != address(0));
646     ownerToOperators[msg.sender][_operator] = _approved;
647     emit ApprovalForAll(msg.sender, _operator, _approved);
648   }
649 
650   /**
651    * @dev Get the approved address for a single NFT.
652    * @notice Throws if `_tokenId` is not a valid NFT.
653    * @param _tokenId ID of the NFT to query the approval of.
654    */
655   function getApproved(
656     uint256 _tokenId
657   )
658     public
659     view
660     validNFToken(_tokenId)
661     returns (address)
662   {
663     return idToApprovals[_tokenId];
664   }
665 
666   /**
667    * @dev Checks if `_operator` is an approved operator for `_owner`.
668    * @param _owner The address that owns the NFTs.
669    * @param _operator The address that acts on behalf of the owner.
670    */
671   function isApprovedForAll(
672     address _owner,
673     address _operator
674   )
675     external
676     view
677     returns (bool)
678   {
679     require(_owner != address(0));
680     require(_operator != address(0));
681     return ownerToOperators[_owner][_operator];
682   }
683 
684   /**
685    * @dev Actually perform the safeTransferFrom.
686    * @param _from The current owner of the NFT.
687    * @param _to The new owner.
688    * @param _tokenId The NFT to transfer.
689    * @param _data Additional data with no specified format, sent in call to `_to`.
690    */
691   function _safeTransferFrom(
692     address _from,
693     address _to,
694     uint256 _tokenId,
695     bytes _data
696   )
697     internal
698     canTransfer(_tokenId)
699     validNFToken(_tokenId)
700   {
701     address tokenOwner = idToOwner[_tokenId];
702     require(tokenOwner == _from);
703     require(_to != address(0));
704 
705     _transfer(_to, _tokenId);
706 
707     if (_to.isContract()) {
708       bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
709       require(retval == MAGIC_ON_ERC721_RECEIVED);
710     }
711   }
712 
713   /**
714    * @dev Actually preforms the transfer.
715    * @notice Does NO checks.
716    * @param _to Address of a new owner.
717    * @param _tokenId The NFT that is being transferred.
718    */
719   function _transfer(
720     address _to,
721     uint256 _tokenId
722   )
723     private
724   {
725     address from = idToOwner[_tokenId];
726     clearApproval(_tokenId);
727 
728     removeNFToken(from, _tokenId);
729     addNFToken(_to, _tokenId);
730 
731     emit Transfer(from, _to, _tokenId);
732   }
733    
734   /**
735    * @dev Mints a new NFT.
736    * @notice This is a private function which should be called from user-implemented external
737    * mint function. Its purpose is to show and properly initialize data structures when using this
738    * implementation.
739    * @param _to The address that will own the minted NFT.
740    * @param _tokenId of the NFT to be minted by the msg.sender.
741    */
742   function _mint(
743     address _to,
744     uint256 _tokenId
745   )
746     internal
747   {
748     require(_to != address(0));
749     require(_tokenId != 0);
750     require(idToOwner[_tokenId] == address(0));
751 
752     addNFToken(_to, _tokenId);
753 
754     emit Transfer(address(0), _to, _tokenId);
755   }
756 
757   /**
758    * @dev Burns a NFT.
759    * @notice This is a private function which should be called from user-implemented external
760    * burn function. Its purpose is to show and properly initialize data structures when using this
761    * implementation.
762    * @param _owner Address of the NFT owner.
763    * @param _tokenId ID of the NFT to be burned.
764    */
765   function _burn(
766     address _owner,
767     uint256 _tokenId
768   )
769     validNFToken(_tokenId)
770     internal
771   {
772     clearApproval(_tokenId);
773     removeNFToken(_owner, _tokenId);
774     emit Transfer(_owner, address(0), _tokenId);
775   }
776 
777   /** 
778    * @dev Clears the current approval of a given NFT ID.
779    * @param _tokenId ID of the NFT to be transferred.
780    */
781   function clearApproval(
782     uint256 _tokenId
783   )
784     private
785   {
786     if(idToApprovals[_tokenId] != 0)
787     {
788       delete idToApprovals[_tokenId];
789     }
790   }
791 
792   /**
793    * @dev Removes a NFT from owner.
794    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
795    * @param _from Address from wich we want to remove the NFT.
796    * @param _tokenId Which NFT we want to remove.
797    */
798   function removeNFToken(
799     address _from,
800     uint256 _tokenId
801   )
802    internal
803   {
804     require(idToOwner[_tokenId] == _from);
805     assert(ownerToNFTokenCount[_from] > 0);
806     ownerToNFTokenCount[_from] = ownerToNFTokenCount[_from] - 1;
807     delete idToOwner[_tokenId];
808   }
809 
810   /**
811    * @dev Assignes a new NFT to owner.
812    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
813    * @param _to Address to wich we want to add the NFT.
814    * @param _tokenId Which NFT we want to add.
815    */
816   function addNFToken(
817     address _to,
818     uint256 _tokenId
819   )
820     internal
821   {
822     require(idToOwner[_tokenId] == address(0));
823 
824     idToOwner[_tokenId] = _to;
825     ownerToNFTokenCount[_to] = ownerToNFTokenCount[_to].add(1);
826   }
827 
828 }
829 
830 // File: contracts/tokens/ERC721Metadata.sol
831 
832 /**
833  * @dev Optional metadata extension for ERC-721 non-fungible token standard.
834  * See https://goo.gl/pc9yoS.
835  */
836 interface ERC721Metadata {
837 
838   /**
839    * @dev Returns a descriptive name for a collection of NFTs in this contract.
840    */
841   function name()
842     external
843     view
844     returns (string _name);
845 
846   /**
847    * @dev Returns a abbreviated name for a collection of NFTs in this contract.
848    */
849   function symbol()
850     external
851     view
852     returns (string _symbol);
853 
854   /**
855    * @dev Returns a distinct Uniform Resource Identifier (URI) for a given asset. It Throws if
856    * `_tokenId` is not a valid NFT. URIs are defined in RFC3986. The URI may point to a JSON file
857    * that conforms to the "ERC721 Metadata JSON Schema".
858    */
859   function tokenURI(uint256 _tokenId)
860     external
861     view
862     returns (string);
863 
864 }
865 
866 // File: contracts/tokens/NFTokenMetadata.sol
867 
868 /**
869  * @dev Optional metadata implementation for ERC-721 non-fungible token standard.
870  */
871 contract NFTokenMetadata is
872   NFToken,
873   ERC721Metadata
874 {
875 
876   /**
877    * @dev A descriptive name for a collection of NFTs.
878    */
879   string internal nftName;
880 
881   /**
882    * @dev An abbreviated name for NFTokens.
883    */
884   string internal nftSymbol;
885 
886   /**
887    * @dev Mapping from NFT ID to metadata uri.
888    */
889   mapping (uint256 => string) internal idToUri;
890 
891   /**
892    * @dev Contract constructor.
893    * @notice When implementing this contract don't forget to set nftName and nftSymbol.
894    */
895   constructor()
896     public
897   {
898     supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
899   }
900 
901   /**
902    * @dev Burns a NFT.
903    * @notice This is a internal function which should be called from user-implemented external
904    * burn function. Its purpose is to show and properly initialize data structures when using this
905    * implementation.
906    * @param _owner Address of the NFT owner.
907    * @param _tokenId ID of the NFT to be burned.
908    */
909   function _burn(
910     address _owner,
911     uint256 _tokenId
912   )
913     internal
914   {
915     super._burn(_owner, _tokenId);
916 
917     if (bytes(idToUri[_tokenId]).length != 0) {
918       delete idToUri[_tokenId];
919     }
920   }
921 
922   /**
923    * @dev Set a distinct URI (RFC 3986) for a given NFT ID.
924    * @notice this is a internal function which should be called from user-implemented external
925    * function. Its purpose is to show and properly initialize data structures when using this
926    * implementation.
927    * @param _tokenId Id for which we want uri.
928    * @param _uri String representing RFC 3986 URI.
929    */
930   function _setTokenUri(
931     uint256 _tokenId,
932     string _uri
933   )
934     validNFToken(_tokenId)
935     internal
936   {
937     idToUri[_tokenId] = _uri;
938   }
939 
940   /**
941    * @dev Returns a descriptive name for a collection of NFTokens.
942    */
943   function name()
944     external
945     view
946     returns (string _name)
947   {
948     _name = nftName;
949   }
950 
951   /**
952    * @dev Returns an abbreviated name for NFTokens.
953    */
954   function symbol()
955     external
956     view
957     returns (string _symbol)
958   {
959     _symbol = nftSymbol;
960   }
961 
962   /**
963    * @dev A distinct URI (RFC 3986) for a given NFT.
964    * @param _tokenId Id for which we want uri.
965    */
966   function tokenURI(
967     uint256 _tokenId
968   )
969     validNFToken(_tokenId)
970     external
971     view
972     returns (string)
973   {
974     return idToUri[_tokenId];
975   }
976 
977 }
978 
979 // File: @0xcert/ethereum-utils/contracts/ownership/Ownable.sol
980 
981 /**
982  * @dev The contract has an owner address, and provides basic authorization control whitch
983  * simplifies the implementation of user permissions. This contract is based on the source code
984  * at https://goo.gl/n2ZGVt.
985  */
986 contract Ownable {
987   address public owner;
988 
989   /**
990    * @dev An event which is triggered when the owner is changed.
991    * @param previousOwner The address of the previous owner.
992    * @param newOwner The address of the new owner.
993    */
994   event OwnershipTransferred(
995     address indexed previousOwner,
996     address indexed newOwner
997   );
998 
999   /**
1000    * @dev The constructor sets the original `owner` of the contract to the sender account.
1001    */
1002   constructor()
1003     public
1004   {
1005     owner = msg.sender;
1006   }
1007 
1008   /**
1009    * @dev Throws if called by any account other than the owner.
1010    */
1011   modifier onlyOwner() {
1012     require(msg.sender == owner);
1013     _;
1014   }
1015 
1016   /**
1017    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1018    * @param _newOwner The address to transfer ownership to.
1019    */
1020   function transferOwnership(
1021     address _newOwner
1022   )
1023     onlyOwner
1024     public
1025   {
1026     require(_newOwner != address(0));
1027     emit OwnershipTransferred(owner, _newOwner);
1028     owner = _newOwner;
1029   }
1030 
1031 }
1032 
1033 // File: contracts/tokens/CopyrightToken.sol
1034 
1035 contract CopyrightToken is
1036   NFTokenMetadata,
1037   Ownable
1038 {
1039 
1040   constructor(
1041     string _name,
1042     string _symbol
1043   )
1044     public
1045   {
1046     nftName = _name;
1047     nftSymbol = _symbol;
1048   }
1049 
1050   function mint(
1051     address _owner,
1052     uint256 _id
1053   )
1054     onlyOwner
1055     external
1056   {
1057     super._mint(_owner, _id);
1058   }
1059 
1060   function burn(
1061     address _owner,
1062     uint256 _tokenId
1063   )
1064     onlyOwner
1065     external
1066   {
1067     super._burn(_owner, _tokenId);
1068   }
1069 
1070   function setTokenUri(
1071     uint256 _tokenId,
1072     string _uri
1073   )
1074     onlyOwner
1075     external
1076   {
1077     super._setTokenUri(_tokenId, _uri);
1078   }
1079 
1080 }