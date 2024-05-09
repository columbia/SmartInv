1 pragma solidity ^0.4.24;
2 
3 // File: @0xcert/ethereum-erc721/contracts/tokens/ERC721Enumerable.sol
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
48 // File: @0xcert/ethereum-erc721/contracts/tokens/ERC721.sol
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
217 // File: @0xcert/ethereum-erc721/contracts/tokens/ERC721TokenReceiver.sol
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
232    * @param _from The sending address.
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
332 // File: @0xcert/ethereum-utils/contracts/ownership/Ownable.sol
333 
334 /**
335  * @dev The contract has an owner address, and provides basic authorization control whitch
336  * simplifies the implementation of user permissions. This contract is based on the source code
337  * at https://goo.gl/n2ZGVt.
338  */
339 contract Ownable {
340   address public owner;
341 
342   /**
343    * @dev An event which is triggered when the owner is changed.
344    * @param previousOwner The address of the previous owner.
345    * @param newOwner The address of the new owner.
346    */
347   event OwnershipTransferred(
348     address indexed previousOwner,
349     address indexed newOwner
350   );
351 
352   /**
353    * @dev The constructor sets the original `owner` of the contract to the sender account.
354    */
355   constructor()
356     public
357   {
358     owner = msg.sender;
359   }
360 
361   /**
362    * @dev Throws if called by any account other than the owner.
363    */
364   modifier onlyOwner() {
365     require(msg.sender == owner);
366     _;
367   }
368 
369   /**
370    * @dev Allows the current owner to transfer control of the contract to a newOwner.
371    * @param _newOwner The address to transfer ownership to.
372    */
373   function transferOwnership(
374     address _newOwner
375   )
376     onlyOwner
377     public
378   {
379     require(_newOwner != address(0));
380     emit OwnershipTransferred(owner, _newOwner);
381     owner = _newOwner;
382   }
383 
384 }
385 
386 // File: @0xcert/ethereum-utils/contracts/utils/AddressUtils.sol
387 
388 /**
389  * @dev Utility library of inline functions on addresses.
390  */
391 library AddressUtils {
392 
393   /**
394    * @dev Returns whether the target address is a contract.
395    * @param _addr Address to check.
396    */
397   function isContract(
398     address _addr
399   )
400     internal
401     view
402     returns (bool)
403   {
404     uint256 size;
405 
406     /**
407      * XXX Currently there is no better way to check if there is a contract in an address than to
408      * check the size of the code at that address.
409      * See https://ethereum.stackexchange.com/a/14016/36603 for more details about how this works.
410      * TODO: Check this again before the Serenity release, because all addresses will be
411      * contracts then.
412      */
413     assembly { size := extcodesize(_addr) } // solium-disable-line security/no-inline-assembly
414     return size > 0;
415   }
416 
417 }
418 
419 // File: @0xcert/ethereum-utils/contracts/utils/ERC165.sol
420 
421 /**
422  * @dev A standard for detecting smart contract interfaces. See https://goo.gl/cxQCse.
423  */
424 interface ERC165 {
425 
426   /**
427    * @dev Checks if the smart contract includes a specific interface.
428    * @notice This function uses less than 30,000 gas.
429    * @param _interfaceID The interface identifier, as specified in ERC-165.
430    */
431   function supportsInterface(
432     bytes4 _interfaceID
433   )
434     external
435     view
436     returns (bool);
437 
438 }
439 
440 // File: @0xcert/ethereum-utils/contracts/utils/SupportsInterface.sol
441 
442 /**
443  * @dev Implementation of standard for detect smart contract interfaces.
444  */
445 contract SupportsInterface is
446   ERC165
447 {
448 
449   /**
450    * @dev Mapping of supported intefraces.
451    * @notice You must not set element 0xffffffff to true.
452    */
453   mapping(bytes4 => bool) internal supportedInterfaces;
454 
455   /**
456    * @dev Contract constructor.
457    */
458   constructor()
459     public
460   {
461     supportedInterfaces[0x01ffc9a7] = true; // ERC165
462   }
463 
464   /**
465    * @dev Function to check which interfaces are suported by this contract.
466    * @param _interfaceID Id of the interface.
467    */
468   function supportsInterface(
469     bytes4 _interfaceID
470   )
471     external
472     view
473     returns (bool)
474   {
475     return supportedInterfaces[_interfaceID];
476   }
477 
478 }
479 
480 // File: @0xcert/ethereum-erc721/contracts/tokens/NFToken.sol
481 
482 /**
483  * @dev Implementation of ERC-721 non-fungible token standard.
484  */
485 contract NFToken is
486   Ownable,
487   ERC721,
488   SupportsInterface
489 {
490   using SafeMath for uint256;
491   using AddressUtils for address;
492 
493   /**
494    * @dev A mapping from NFT ID to the address that owns it.
495    */
496   mapping (uint256 => address) internal idToOwner;
497 
498   /**
499    * @dev Mapping from NFT ID to approved address.
500    */
501   mapping (uint256 => address) internal idToApprovals;
502 
503    /**
504    * @dev Mapping from owner address to count of his tokens.
505    */
506   mapping (address => uint256) internal ownerToNFTokenCount;
507 
508   /**
509    * @dev Mapping from owner address to mapping of operator addresses.
510    */
511   mapping (address => mapping (address => bool)) internal ownerToOperators;
512 
513   /**
514    * @dev Magic value of a smart contract that can recieve NFT.
515    * Equal to: bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")).
516    */
517   bytes4 constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
518 
519   /**
520    * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
521    * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
522    * number of NFTs may be created and assigned without emitting Transfer. At the time of any
523    * transfer, the approved address for that NFT (if any) is reset to none.
524    * @param _from Sender of NFT (if address is zero address it indicates token creation).
525    * @param _to Receiver of NFT (if address is zero address it indicates token destruction).
526    * @param _tokenId The NFT that got transfered.
527    */
528   event Transfer(
529     address indexed _from,
530     address indexed _to,
531     uint256 indexed _tokenId
532   );
533 
534   /**
535    * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
536    * address indicates there is no approved address. When a Transfer event emits, this also
537    * indicates that the approved address for that NFT (if any) is reset to none.
538    * @param _owner Owner of NFT.
539    * @param _approved Address that we are approving.
540    * @param _tokenId NFT which we are approving.
541    */
542   event Approval(
543     address indexed _owner,
544     address indexed _approved,
545     uint256 indexed _tokenId
546   );
547 
548   /**
549    * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
550    * all NFTs of the owner.
551    * @param _owner Owner of NFT.
552    * @param _operator Address to which we are setting operator rights.
553    * @param _approved Status of operator rights(true if operator rights are given and false if
554    * revoked).
555    */
556   event ApprovalForAll(
557     address indexed _owner,
558     address indexed _operator,
559     bool _approved
560   );
561 
562   /**
563    * @dev Guarantees that the msg.sender is an owner or operator of the given NFT.
564    * @param _tokenId ID of the NFT to validate.
565    */
566   modifier canOperate(
567     uint256 _tokenId
568   ) {
569     address tokenOwner = idToOwner[_tokenId];
570     require(tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender]);
571     _;
572   }
573 
574   /**
575    * @dev Guarantees that the msg.sender is allowed to transfer NFT.
576    * @param _tokenId ID of the NFT to transfer.
577    */
578   modifier canTransfer(
579     uint256 _tokenId
580   ) {
581     address tokenOwner = idToOwner[_tokenId];
582     require(
583       tokenOwner == msg.sender
584       || getApproved(_tokenId) == msg.sender
585       || ownerToOperators[tokenOwner][msg.sender]
586     );
587 
588     _;
589   }
590 
591   /**
592    * @dev Guarantees that _tokenId is a valid Token.
593    * @param _tokenId ID of the NFT to validate.
594    */
595   modifier validNFToken(
596     uint256 _tokenId
597   ) {
598     require(idToOwner[_tokenId] != address(0));
599     _;
600   }
601 
602   /**
603    * @dev Contract constructor.
604    */
605   constructor()
606     public
607   {
608     supportedInterfaces[0x80ac58cd] = true; // ERC721
609   }
610 
611   /**
612    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
613    * considered invalid, and this function throws for queries about the zero address.
614    * @param _owner Address for whom to query the balance.
615    */
616   function balanceOf(
617     address _owner
618   )
619     external
620     view
621     returns (uint256)
622   {
623     require(_owner != address(0));
624     return ownerToNFTokenCount[_owner];
625   }
626 
627   /**
628    * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered
629    * invalid, and queries about them do throw.
630    * @param _tokenId The identifier for an NFT.
631    */
632   function ownerOf(
633     uint256 _tokenId
634   )
635     external
636     view
637     returns (address _owner)
638   {
639     _owner = idToOwner[_tokenId];
640     require(_owner != address(0));
641   }
642 
643   /**
644    * @dev Transfers the ownership of an NFT from one address to another address.
645    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
646    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
647    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
648    * function checks if `_to` is a smart contract (code size > 0). If so, it calls `onERC721Received`
649    * on `_to` and throws if the return value is not `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
650    * @param _from The current owner of the NFT.
651    * @param _to The new owner.
652    * @param _tokenId The NFT to transfer.
653    * @param _data Additional data with no specified format, sent in call to `_to`.
654    */
655   function safeTransferFrom(
656     address _from,
657     address _to,
658     uint256 _tokenId,
659     bytes _data
660   )
661     external
662   {
663     _safeTransferFrom(_from, _to, _tokenId, _data);
664   }
665 
666   /**
667    * @dev Transfers the ownership of an NFT from one address to another address.
668    * @notice This works identically to the other function with an extra data parameter, except this
669    * function just sets data to ""
670    * @param _from The current owner of the NFT.
671    * @param _to The new owner.
672    * @param _tokenId The NFT to transfer.
673    */
674   function safeTransferFrom(
675     address _from,
676     address _to,
677     uint256 _tokenId
678   )
679     external
680   {
681     _safeTransferFrom(_from, _to, _tokenId, "");
682   }
683 
684   /**
685    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
686    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
687    * address. Throws if `_tokenId` is not a valid NFT.
688    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
689    * they maybe be permanently lost.
690    * @param _from The current owner of the NFT.
691    * @param _to The new owner.
692    * @param _tokenId The NFT to transfer.
693    */
694   function transferFrom(
695     address _from,
696     address _to,
697     uint256 _tokenId
698   )
699     external
700     canTransfer(_tokenId)
701     validNFToken(_tokenId)
702   {
703     address tokenOwner = idToOwner[_tokenId];
704     require(tokenOwner == _from);
705     require(_to != address(0));
706 
707     _transfer(_to, _tokenId);
708   }
709 
710   /**
711    * @dev Set or reaffirm the approved address for an NFT.
712    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
713    * the current NFT owner, or an authorized operator of the current owner.
714    * @param _approved Address to be approved for the given NFT ID.
715    * @param _tokenId ID of the token to be approved.
716    */
717   function approve(
718     address _approved,
719     uint256 _tokenId
720   )
721     external
722     canOperate(_tokenId)
723     validNFToken(_tokenId)
724   {
725     address tokenOwner = idToOwner[_tokenId];
726     require(_approved != tokenOwner);
727 
728     idToApprovals[_tokenId] = _approved;
729     emit Approval(tokenOwner, _approved, _tokenId);
730   }
731 
732   /**
733    * @dev Enables or disables approval for a third party ("operator") to manage all of
734    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
735    * @notice This works even if sender doesn't own any tokens at the time.
736    * @param _operator Address to add to the set of authorized operators.
737    * @param _approved True if the operators is approved, false to revoke approval.
738    */
739   function setApprovalForAll(
740     address _operator,
741     bool _approved
742   )
743     external
744   {
745     require(_operator != address(0));
746     ownerToOperators[msg.sender][_operator] = _approved;
747     emit ApprovalForAll(msg.sender, _operator, _approved);
748   }
749 
750   /**
751    * @dev Get the approved address for a single NFT.
752    * @notice Throws if `_tokenId` is not a valid NFT.
753    * @param _tokenId ID of the NFT to query the approval of.
754    */
755   function getApproved(
756     uint256 _tokenId
757   )
758     public
759     view
760     validNFToken(_tokenId)
761     returns (address)
762   {
763     return idToApprovals[_tokenId];
764   }
765 
766   /**
767    * @dev Checks if `_operator` is an approved operator for `_owner`.
768    * @param _owner The address that owns the NFTs.
769    * @param _operator The address that acts on behalf of the owner.
770    */
771   function isApprovedForAll(
772     address _owner,
773     address _operator
774   )
775     external
776     view
777     returns (bool)
778   {
779     require(_owner != address(0));
780     require(_operator != address(0));
781     return ownerToOperators[_owner][_operator];
782   }
783 
784   /**
785    * @dev Actually perform the safeTransferFrom.
786    * @param _from The current owner of the NFT.
787    * @param _to The new owner.
788    * @param _tokenId The NFT to transfer.
789    * @param _data Additional data with no specified format, sent in call to `_to`.
790    */
791   function _safeTransferFrom(
792     address _from,
793     address _to,
794     uint256 _tokenId,
795     bytes _data
796   )
797     internal
798     canTransfer(_tokenId)
799     validNFToken(_tokenId)
800   {
801     address tokenOwner = idToOwner[_tokenId];
802     require(tokenOwner == _from);
803     require(_to != address(0));
804 
805     _transfer(_to, _tokenId);
806 
807     if (_to.isContract()) {
808       bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
809       require(retval == MAGIC_ON_ERC721_RECEIVED);
810     }
811   }
812 
813   /**
814    * @dev Actually preforms the transfer.
815    * @notice Does NO checks.
816    * @param _to Address of a new owner.
817    * @param _tokenId The NFT that is being transferred.
818    */
819   function _transfer(
820     address _to,
821     uint256 _tokenId
822   )
823     private
824   {
825     address from = idToOwner[_tokenId];
826 
827     clearApproval(from, _tokenId);
828     removeNFToken(from, _tokenId);
829     addNFToken(_to, _tokenId);
830 
831     emit Transfer(from, _to, _tokenId);
832   }
833 
834   /**
835    * @dev Mints a new NFT.
836    * @notice This is a private function which should be called from user-implemented external
837    * mint function. Its purpose is to show and properly initialize data structures when using this
838    * implementation.
839    * @param _to The address that will own the minted NFT.
840    * @param _tokenId of the NFT to be minted by the msg.sender.
841    */
842   function _mint(
843     address _to,
844     uint256 _tokenId
845   )
846     internal
847   {
848     require(_to != address(0));
849     require(_tokenId != 0);
850     require(idToOwner[_tokenId] == address(0));
851 
852     addNFToken(_to, _tokenId);
853 
854     emit Transfer(address(0), _to, _tokenId);
855   }
856 
857   /**
858    * @dev Burns a NFT.
859    * @notice This is a private function which should be called from user-implemented external
860    * burn function. Its purpose is to show and properly initialize data structures when using this
861    * implementation.
862    * @param _owner Address of the NFT owner.
863    * @param _tokenId ID of the NFT to be burned.
864    */
865   function _burn(
866     address _owner,
867     uint256 _tokenId
868   )
869     validNFToken(_tokenId)
870     internal
871   {
872     clearApproval(_owner, _tokenId);
873     removeNFToken(_owner, _tokenId);
874     emit Transfer(_owner, address(0), _tokenId);
875   }
876 
877   /**
878    * @dev Clears the current approval of a given NFT ID.
879    * @param _tokenId ID of the NFT to be transferred.
880    */
881   function clearApproval(
882     address _owner,
883     uint256 _tokenId
884   )
885     internal
886   {
887     delete idToApprovals[_tokenId];
888     emit Approval(_owner, 0, _tokenId);
889   }
890 
891   /**
892    * @dev Removes a NFT from owner.
893    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
894    * @param _from Address from wich we want to remove the NFT.
895    * @param _tokenId Which NFT we want to remove.
896    */
897   function removeNFToken(
898     address _from,
899     uint256 _tokenId
900   )
901    internal
902   {
903     require(idToOwner[_tokenId] == _from);
904     assert(ownerToNFTokenCount[_from] > 0);
905     ownerToNFTokenCount[_from] = ownerToNFTokenCount[_from].sub(1);
906     delete idToOwner[_tokenId];
907   }
908 
909   /**
910    * @dev Assignes a new NFT to owner.
911    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
912    * @param _to Address to wich we want to add the NFT.
913    * @param _tokenId Which NFT we want to add.
914    */
915   function addNFToken(
916     address _to,
917     uint256 _tokenId
918   )
919     internal
920   {
921     require(idToOwner[_tokenId] == address(0));
922 
923     idToOwner[_tokenId] = _to;
924     ownerToNFTokenCount[_to] = ownerToNFTokenCount[_to].add(1);
925   }
926 
927 }
928 
929 // File: @0xcert/ethereum-erc721/contracts/tokens/NFTokenEnumerable.sol
930 
931 /**
932  * @dev Optional enumeration implementation for ERC-721 non-fungible token standard.
933  */
934 contract NFTokenEnumerable is
935   NFToken,
936   ERC721Enumerable
937 {
938 
939   /**
940    * @dev Array of all NFT IDs.
941    */
942   uint256[] internal tokens;
943 
944   /**
945    * @dev Mapping from owner address to a list of owned NFT IDs.
946    */
947   mapping(uint256 => uint256) internal idToIndex;
948 
949   /**
950    * @dev Mapping from owner to list of owned NFT IDs.
951    */
952   mapping(address => uint256[]) internal ownerToIds;
953 
954   /**
955    * @dev Mapping from NFT ID to its index in the owner tokens list.
956    */
957   mapping(uint256 => uint256) internal idToOwnerIndex;
958 
959   /**
960    * @dev Contract constructor.
961    */
962   constructor()
963     public
964   {
965     supportedInterfaces[0x780e9d63] = true; // ERC721Enumerable
966   }
967 
968   /**
969    * @dev Mints a new NFT.
970    * @notice This is a private function which should be called from user-implemented external
971    * mint function. Its purpose is to show and properly initialize data structures when using this
972    * implementation.
973    * @param _to The address that will own the minted NFT.
974    * @param _tokenId of the NFT to be minted by the msg.sender.
975    */
976   function _mint(
977     address _to,
978     uint256 _tokenId
979   )
980     internal
981   {
982     super._mint(_to, _tokenId);
983     tokens.push(_tokenId);
984   }
985 
986   /**
987    * @dev Burns a NFT.
988    * @notice This is a private function which should be called from user-implemented external
989    * burn function. Its purpose is to show and properly initialize data structures when using this
990    * implementation.
991    * @param _owner Address of the NFT owner.
992    * @param _tokenId ID of the NFT to be burned.
993    */
994   function _burn(
995     address _owner,
996     uint256 _tokenId
997   )
998     internal
999   {
1000     assert(tokens.length > 0);
1001     super._burn(_owner, _tokenId);
1002 
1003     uint256 tokenIndex = idToIndex[_tokenId];
1004     uint256 lastTokenIndex = tokens.length.sub(1);
1005     uint256 lastToken = tokens[lastTokenIndex];
1006 
1007     tokens[tokenIndex] = lastToken;
1008     tokens[lastTokenIndex] = 0;
1009 
1010     tokens.length--;
1011     idToIndex[_tokenId] = 0;
1012     idToIndex[lastToken] = tokenIndex;
1013   }
1014 
1015   /**
1016    * @dev Removes a NFT from an address.
1017    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
1018    * @param _from Address from wich we want to remove the NFT.
1019    * @param _tokenId Which NFT we want to remove.
1020    */
1021   function removeNFToken(
1022     address _from,
1023     uint256 _tokenId
1024   )
1025    internal
1026   {
1027     super.removeNFToken(_from, _tokenId);
1028     assert(ownerToIds[_from].length > 0);
1029 
1030     uint256 tokenToRemoveIndex = idToOwnerIndex[_tokenId];
1031     uint256 lastTokenIndex = ownerToIds[_from].length.sub(1);
1032     uint256 lastToken = ownerToIds[_from][lastTokenIndex];
1033 
1034     ownerToIds[_from][tokenToRemoveIndex] = lastToken;
1035 
1036     ownerToIds[_from].length--;
1037     idToOwnerIndex[_tokenId] = 0;
1038     idToOwnerIndex[lastToken] = tokenToRemoveIndex;
1039   }
1040 
1041   /**
1042    * @dev Assignes a new NFT to an address.
1043    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
1044    * @param _to Address to wich we want to add the NFT.
1045    * @param _tokenId Which NFT we want to add.
1046    */
1047   function addNFToken(
1048     address _to,
1049     uint256 _tokenId
1050   )
1051     internal
1052   {
1053     super.addNFToken(_to, _tokenId);
1054 
1055     uint256 length = ownerToIds[_to].length;
1056     ownerToIds[_to].push(_tokenId);
1057     idToOwnerIndex[_tokenId] = length;
1058   }
1059 
1060   /**
1061    * @dev Returns the count of all existing NFTokens.
1062    */
1063   function totalSupply()
1064     external
1065     view
1066     returns (uint256)
1067   {
1068     return tokens.length;
1069   }
1070 
1071   /**
1072    * @dev Returns NFT ID by its index.
1073    * @param _index A counter less than `totalSupply()`.
1074    */
1075   function tokenByIndex(
1076     uint256 _index
1077   )
1078     external
1079     view
1080     returns (uint256)
1081   {
1082     require(_index < tokens.length);
1083     return tokens[_index];
1084   }
1085 
1086   /**
1087    * @dev returns the n-th NFT ID from a list of owner's tokens.
1088    * @param _owner Token owner's address.
1089    * @param _index Index number representing n-th token in owner's list of tokens.
1090    */
1091   function tokenOfOwnerByIndex(
1092     address _owner,
1093     uint256 _index
1094   )
1095     external
1096     view
1097     returns (uint256)
1098   {
1099     require(_index < ownerToIds[_owner].length);
1100     return ownerToIds[_owner][_index];
1101   }
1102 
1103 }
1104 
1105 // File: @0xcert/ethereum-erc721/contracts/tokens/ERC721Metadata.sol
1106 
1107 /**
1108  * @dev Optional metadata extension for ERC-721 non-fungible token standard.
1109  * See https://goo.gl/pc9yoS.
1110  */
1111 interface ERC721Metadata {
1112 
1113   /**
1114    * @dev Returns a descriptive name for a collection of NFTs in this contract.
1115    */
1116   function name()
1117     external
1118     view
1119     returns (string _name);
1120 
1121   /**
1122    * @dev Returns a abbreviated name for a collection of NFTs in this contract.
1123    */
1124   function symbol()
1125     external
1126     view
1127     returns (string _symbol);
1128 
1129   /**
1130    * @dev Returns a distinct Uniform Resource Identifier (URI) for a given asset. It Throws if
1131    * `_tokenId` is not a valid NFT. URIs are defined in RFC3986. The URI may point to a JSON file
1132    * that conforms to the "ERC721 Metadata JSON Schema".
1133    */
1134   function tokenURI(uint256 _tokenId)
1135     external
1136     view
1137     returns (string);
1138 
1139 }
1140 
1141 // File: @0xcert/ethereum-erc721/contracts/tokens/NFTokenMetadata.sol
1142 
1143 /**
1144  * @dev Optional metadata implementation for ERC-721 non-fungible token standard.
1145  */
1146 contract NFTokenMetadata is
1147   NFToken,
1148   ERC721Metadata
1149 {
1150 
1151   /**
1152    * @dev A descriptive name for a collection of NFTs.
1153    */
1154   string internal nftName;
1155 
1156   /**
1157    * @dev An abbreviated name for NFTokens.
1158    */
1159   string internal nftSymbol;
1160 
1161   /**
1162    * @dev Mapping from NFT ID to metadata uri.
1163    */
1164   mapping (uint256 => string) internal idToUri;
1165 
1166   /**
1167    * @dev Contract constructor.
1168    * @notice When implementing this contract don't forget to set nftName and nftSymbol.
1169    */
1170   constructor()
1171     public
1172   {
1173     supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
1174   }
1175 
1176   /**
1177    * @dev Burns a NFT.
1178    * @notice This is a internal function which should be called from user-implemented external
1179    * burn function. Its purpose is to show and properly initialize data structures when using this
1180    * implementation.
1181    * @param _owner Address of the NFT owner.
1182    * @param _tokenId ID of the NFT to be burned.
1183    */
1184   function _burn(
1185     address _owner,
1186     uint256 _tokenId
1187   )
1188     internal
1189   {
1190     super._burn(_owner, _tokenId);
1191 
1192     if (bytes(idToUri[_tokenId]).length != 0) {
1193       delete idToUri[_tokenId];
1194     }
1195   }
1196 
1197   /**
1198    * @dev Set a distinct URI (RFC 3986) for a given NFT ID.
1199    * @notice this is a internal function which should be called from user-implemented external
1200    * function. Its purpose is to show and properly initialize data structures when using this
1201    * implementation.
1202    * @param _tokenId Id for which we want uri.
1203    * @param _uri String representing RFC 3986 URI.
1204    */
1205   function _setTokenUri(
1206     uint256 _tokenId,
1207     string _uri
1208   )
1209     validNFToken(_tokenId)
1210     internal
1211   {
1212     idToUri[_tokenId] = _uri;
1213   }
1214 
1215   /**
1216    * @dev Returns a descriptive name for a collection of NFTokens.
1217    */
1218   function name()
1219     external
1220     view
1221     returns (string _name)
1222   {
1223     _name = nftName;
1224   }
1225 
1226   /**
1227    * @dev Returns an abbreviated name for NFTokens.
1228    */
1229   function symbol()
1230     external
1231     view
1232     returns (string _symbol)
1233   {
1234     _symbol = nftSymbol;
1235   }
1236 
1237   /**
1238    * @dev A distinct URI (RFC 3986) for a given NFT.
1239    * @param _tokenId Id for which we want uri.
1240    */
1241   function tokenURI(
1242     uint256 _tokenId
1243   )
1244     validNFToken(_tokenId)
1245     external
1246     view
1247     returns (string)
1248   {
1249     return idToUri[_tokenId];
1250   }
1251 
1252 }
1253 
1254 // File: contracts/tokens/Xcert.sol
1255 
1256 /**
1257  * @dev Xcert implementation.
1258  */
1259 contract Xcert is NFTokenEnumerable, NFTokenMetadata {
1260   using SafeMath for uint256;
1261   using AddressUtils for address;
1262 
1263   /**
1264    * @dev Unique ID which determines each Xcert smart contract type by its JSON convention.
1265    * @notice Calculated as bytes4(keccak256(jsonSchema)).
1266    */
1267   bytes4 internal nftConventionId;
1268 
1269   /**
1270    * @dev Maps NFT ID to proof.
1271    */
1272   mapping (uint256 => string) internal idToProof;
1273 
1274   /**
1275    * @dev Maps NFT ID to protocol config.
1276    */
1277   mapping (uint256 => bytes32[]) internal config;
1278 
1279   /**
1280    * @dev Maps NFT ID to convention data.
1281    */
1282   mapping (uint256 => bytes32[]) internal data;
1283 
1284   /**
1285    * @dev Maps address to authorization of contract.
1286    */
1287   mapping (address => bool) internal addressToAuthorized;
1288 
1289   /**
1290    * @dev Emits when an address is authorized to some contract control or the authorization is revoked.
1291    * The _target has some contract controle like minting new NFTs.
1292    * @param _target Address to set authorized state.
1293    * @param _authorized True if the _target is authorised, false to revoke authorization.
1294    */
1295   event AuthorizedAddress(
1296     address indexed _target,
1297     bool _authorized
1298   );
1299 
1300   /**
1301    * @dev Guarantees that msg.sender is allowed to mint a new NFT.
1302    */
1303   modifier isAuthorized() {
1304     require(msg.sender == owner || addressToAuthorized[msg.sender]);
1305     _;
1306   }
1307 
1308   /**
1309    * @dev Contract constructor.
1310    * @notice When implementing this contract don't forget to set nftConventionId, nftName and
1311    * nftSymbol.
1312    */
1313   constructor()
1314     public
1315   {
1316     supportedInterfaces[0x6be14f75] = true; // Xcert
1317   }
1318 
1319   /**
1320    * @dev Mints a new NFT.
1321    * @param _to The address that will own the minted NFT.
1322    * @param _id The NFT to be minted by the msg.sender.
1323    * @param _uri An URI pointing to NFT metadata.
1324    * @param _proof Cryptographic asset imprint.
1325    * @param _config Array of protocol config values where 0 index represents token expiration
1326    * timestamp, other indexes are not yet definied but are ready for future xcert upgrades.
1327    * @param _data Array of convention data values.
1328    */
1329   function mint(
1330     address _to,
1331     uint256 _id,
1332     string _uri,
1333     string _proof,
1334     bytes32[] _config,
1335     bytes32[] _data
1336   )
1337     external
1338     isAuthorized()
1339   {
1340     require(_config.length > 0);
1341     require(bytes(_proof).length > 0);
1342     super._mint(_to, _id);
1343     super._setTokenUri(_id, _uri);
1344     idToProof[_id] = _proof;
1345     config[_id] = _config;
1346     data[_id] = _data;
1347   }
1348 
1349   /**
1350    * @dev Returns a bytes4 of keccak256 of json schema representing 0xcert protocol convention.
1351    */
1352   function conventionId()
1353     external
1354     view
1355     returns (bytes4 _conventionId)
1356   {
1357     _conventionId = nftConventionId;
1358   }
1359 
1360   /**
1361    * @dev Returns proof for NFT.
1362    * @param _tokenId Id of the NFT.
1363    */
1364   function tokenProof(
1365     uint256 _tokenId
1366   )
1367     validNFToken(_tokenId)
1368     external
1369     view
1370     returns(string)
1371   {
1372     return idToProof[_tokenId];
1373   }
1374 
1375   /**
1376    * @dev Returns convention data value for a given index field.
1377    * @param _tokenId Id of the NFT we want to get value for key.
1378    * @param _index for which we want to get value.
1379    */
1380   function tokenDataValue(
1381     uint256 _tokenId,
1382     uint256 _index
1383   )
1384     validNFToken(_tokenId)
1385     public
1386     view
1387     returns(bytes32 value)
1388   {
1389     require(_index < data[_tokenId].length);
1390     value = data[_tokenId][_index];
1391   }
1392 
1393   /**
1394    * @dev Returns expiration date from 0 index of token config values.
1395    * @param _tokenId Id of the NFT we want to get expiration time of.
1396    */
1397   function tokenExpirationTime(
1398     uint256 _tokenId
1399   )
1400     validNFToken(_tokenId)
1401     external
1402     view
1403     returns(bytes32)
1404   {
1405     return config[_tokenId][0];
1406   }
1407 
1408   /**
1409    * @dev Sets authorised address for minting.
1410    * @param _target Address to set authorized state.
1411    * @param _authorized True if the _target is authorised, false to revoke authorization.
1412    */
1413   function setAuthorizedAddress(
1414     address _target,
1415     bool _authorized
1416   )
1417     onlyOwner
1418     external
1419   {
1420     require(_target != address(0));
1421     addressToAuthorized[_target] = _authorized;
1422     emit AuthorizedAddress(_target, _authorized);
1423   }
1424 
1425   /**
1426    * @dev Sets mint authorised address.
1427    * @param _target Address for which we want to check if it is authorized.
1428    * @return Is authorized or not.
1429    */
1430   function isAuthorizedAddress(
1431     address _target
1432   )
1433     external
1434     view
1435     returns (bool)
1436   {
1437     require(_target != address(0));
1438     return addressToAuthorized[_target];
1439   }
1440 }
1441 
1442 // File: contracts/tokens/MutableXcert.sol
1443 
1444 /**
1445  * @dev Xcert implementation where token data can be changed by authorized address.
1446  */
1447 contract MutableXcert is Xcert {
1448 
1449   /**
1450    * @dev Emits when an Token data is changed.
1451    * @param _id NFT that data got changed.
1452    * @param _data New data.
1453    */
1454   event TokenDataChange(
1455     uint256 indexed _id,
1456     bytes32[] _data
1457   );
1458 
1459   /**
1460    * @dev Contract constructor.
1461    * @notice When implementing this contract don't forget to set nftConventionId, nftName and
1462    * nftSymbol.
1463    */
1464   constructor()
1465     public
1466   {
1467     supportedInterfaces[0x59118221] = true; // MutableXcert
1468   }
1469 
1470   /**
1471    * @dev Modifies convention data by setting a new value for a given index field.
1472    * @param _tokenId Id of the NFT we want to set key value data.
1473    * @param _data New token data.
1474    */
1475   function setTokenData(
1476     uint256 _tokenId,
1477     bytes32[] _data
1478   )
1479     validNFToken(_tokenId)
1480     isAuthorized()
1481     external
1482   {
1483     data[_tokenId] = _data;
1484     emit TokenDataChange(_tokenId, _data);
1485   }
1486 }
1487 
1488 // File: contracts/tokens/PausableXcert.sol
1489 
1490 /**
1491  * @dev Xcert implementation where tokens transfer can be paused/unpaused.
1492  */
1493 contract PausableXcert is Xcert {
1494 
1495   /**
1496    * @dev This emits when ability of beeing able to transfer NFTs changes (paused/unpaused).
1497    */
1498   event IsPaused(bool _isPaused);
1499 
1500   /**
1501    * @dev Are NFT paused or not.
1502    */
1503   bool public isPaused;
1504 
1505   /**
1506    * @dev Contract constructor.
1507    * @notice When implementing this contract don't forget to set nftConventionId, nftName,
1508    * nftSymbol and isPaused.
1509    */
1510   constructor()
1511     public
1512   {
1513     supportedInterfaces[0xbedb86fb] = true; // PausableXcert
1514   }
1515 
1516   /**
1517    * @dev Guarantees that the msg.sender is allowed to transfer NFT.
1518    * @param _tokenId ID of the NFT to transfer.
1519    */
1520   modifier canTransfer(
1521     uint256 _tokenId
1522   )
1523   {
1524     address owner = idToOwner[_tokenId];
1525     require(!isPaused && (
1526       owner == msg.sender
1527       || getApproved(_tokenId) == msg.sender
1528       || ownerToOperators[owner][msg.sender])
1529     );
1530 
1531     _;
1532   }
1533 
1534   /**
1535    * @dev Sets if NFTs are paused or not.
1536    * @param _isPaused Pause status.
1537    */
1538   function setPause(
1539     bool _isPaused
1540   )
1541     external
1542     onlyOwner
1543   {
1544     require(isPaused != _isPaused);
1545     isPaused = _isPaused;
1546     emit IsPaused(_isPaused);
1547   }
1548 
1549 }
1550 
1551 // File: contracts/tokens/RevokableXcert.sol
1552 
1553 /**
1554  * @dev Xcert implementation where tokens can be destroyed by the issuer.
1555  */
1556 contract RevokableXcert is Xcert {
1557 
1558   /**
1559    * @dev Contract constructor.
1560    * @notice When implementing this contract don't forget to set nftConventionId, nftName and
1561    * nftSymbol.
1562    */
1563   constructor()
1564     public
1565   {
1566     supportedInterfaces[0x20c5429b] = true; // RevokableXcert
1567   }
1568 
1569   /**
1570    * @dev Revokes a specified NFT.
1571    * @param _tokenId Id of the NFT we want to revoke.
1572    */
1573   function revoke(
1574     uint256 _tokenId
1575   )
1576     validNFToken(_tokenId)
1577     onlyOwner
1578     external
1579   {
1580     address tokenOwner = idToOwner[_tokenId];
1581     super._burn(tokenOwner, _tokenId);
1582     delete data[_tokenId];
1583     delete config[_tokenId];
1584     delete idToProof[_tokenId];
1585   }
1586 }
1587 
1588 // File: contracts/mocks/KycToken.sol
1589 
1590 contract KycToken is
1591   PausableXcert,
1592   RevokableXcert,
1593   MutableXcert
1594 {
1595 
1596   constructor()
1597     public
1598   {
1599     nftName = "0xcert KYC";
1600     nftSymbol = "KYC";
1601     nftConventionId = 0xfc3ee448;
1602     isPaused = true;
1603   }
1604 
1605 }