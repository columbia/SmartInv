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
313    * Returns `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))` unless throwing.
314    * @notice The contract address is always the message sender. A wallet/broker/auction application
315    * MUST implement the wallet interface if it will accept safe transfers.
316    * @param _from The sending address.
317    * @param _tokenId The NFT identifier which is being transfered.
318    * @param _data Additional data with no specified format.
319    */
320   function onERC721Received(
321     address _from,
322     uint256 _tokenId,
323     bytes _data
324   )
325     external
326     returns(bytes4);
327 
328 }
329 
330 // File: @0xcert/ethereum-utils/contracts/ownership/Ownable.sol
331 
332 /**
333  * @dev The contract has an owner address, and provides basic authorization control whitch
334  * simplifies the implementation of user permissions. This contract is based on the source code
335  * at https://goo.gl/n2ZGVt.
336  */
337 contract Ownable {
338   address public owner;
339 
340   /**
341    * @dev An event which is triggered when the owner is changed.
342    * @param previousOwner The address of the previous owner.
343    * @param newOwner The address of the new owner.
344    */
345   event OwnershipTransferred(
346     address indexed previousOwner,
347     address indexed newOwner
348   );
349 
350   /**
351    * @dev The constructor sets the original `owner` of the contract to the sender account.
352    */
353   constructor()
354     public
355   {
356     owner = msg.sender;
357   }
358 
359   /**
360    * @dev Throws if called by any account other than the owner.
361    */
362   modifier onlyOwner() {
363     require(msg.sender == owner);
364     _;
365   }
366 
367   /**
368    * @dev Allows the current owner to transfer control of the contract to a newOwner.
369    * @param _newOwner The address to transfer ownership to.
370    */
371   function transferOwnership(
372     address _newOwner
373   )
374     onlyOwner
375     public
376   {
377     require(_newOwner != address(0));
378     emit OwnershipTransferred(owner, _newOwner);
379     owner = _newOwner;
380   }
381 
382 }
383 
384 // File: @0xcert/ethereum-utils/contracts/utils/AddressUtils.sol
385 
386 /**
387  * @dev Utility library of inline functions on addresses.
388  */
389 library AddressUtils {
390 
391   /**
392    * @dev Returns whether the target address is a contract.
393    * @param _addr Address to check.
394    */
395   function isContract(
396     address _addr
397   )
398     internal
399     view
400     returns (bool)
401   {
402     uint256 size;
403 
404     /**
405      * XXX Currently there is no better way to check if there is a contract in an address than to
406      * check the size of the code at that address.
407      * See https://ethereum.stackexchange.com/a/14016/36603 for more details about how this works.
408      * TODO: Check this again before the Serenity release, because all addresses will be
409      * contracts then.
410      */
411     assembly { size := extcodesize(_addr) } // solium-disable-line security/no-inline-assembly
412     return size > 0;
413   }
414 
415 }
416 
417 // File: @0xcert/ethereum-utils/contracts/utils/ERC165.sol
418 
419 /**
420  * @dev A standard for detecting smart contract interfaces. See https://goo.gl/cxQCse.
421  */
422 interface ERC165 {
423 
424   /**
425    * @dev Checks if the smart contract includes a specific interface.
426    * @notice This function uses less than 30,000 gas.
427    * @param _interfaceID The interface identifier, as specified in ERC-165.
428    */
429   function supportsInterface(
430     bytes4 _interfaceID
431   )
432     external
433     view
434     returns (bool);
435 }
436 
437 // File: @0xcert/ethereum-utils/contracts/utils/SupportsInterface.sol
438 
439 /**
440  * @dev Implementation of standard for detect smart contract interfaces.
441  */
442 contract SupportsInterface is ERC165 {
443 
444   /**
445    * @dev Mapping of supported intefraces.
446    * @notice You must not set element 0xffffffff to true.
447    */
448   mapping(bytes4 => bool) internal supportedInterfaces;
449 
450   /**
451    * @dev Contract constructor.
452    */
453   constructor()
454     public
455   {
456     supportedInterfaces[0x01ffc9a7] = true; // ERC165
457   }
458 
459   /**
460    * @dev Function to check which interfaces are suported by this contract.
461    * @param _interfaceID Id of the interface.
462    */
463   function supportsInterface(
464     bytes4 _interfaceID
465   )
466     external
467     view
468     returns (bool)
469   {
470     return supportedInterfaces[_interfaceID];
471   }
472 
473 }
474 
475 // File: @0xcert/ethereum-erc721/contracts/tokens/NFToken.sol
476 
477 /**
478  * @dev Implementation of ERC-721 non-fungible token standard.
479  */
480 contract NFToken is
481   Ownable,
482   ERC721,
483   SupportsInterface
484 {
485   using SafeMath for uint256;
486   using AddressUtils for address;
487 
488   /**
489    * @dev A mapping from NFT ID to the address that owns it.
490    */
491   mapping (uint256 => address) internal idToOwner;
492 
493   /**
494    * @dev Mapping from NFT ID to approved address.
495    */
496   mapping (uint256 => address) internal idToApprovals;
497 
498    /**
499    * @dev Mapping from owner address to count of his tokens.
500    */
501   mapping (address => uint256) internal ownerToNFTokenCount;
502 
503   /**
504    * @dev Mapping from owner address to mapping of operator addresses.
505    */
506   mapping (address => mapping (address => bool)) internal ownerToOperators;
507 
508   /**
509    * @dev Magic value of a smart contract that can recieve NFT.
510    * Equal to: keccak256("onERC721Received(address,uint256,bytes)").
511    */
512   bytes4 constant MAGIC_ON_ERC721_RECEIVED = 0xf0b9e5ba;
513 
514   /**
515    * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
516    * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
517    * number of NFTs may be created and assigned without emitting Transfer. At the time of any
518    * transfer, the approved address for that NFT (if any) is reset to none.
519    * @param _from Sender of NFT (if address is zero address it indicates token creation).
520    * @param _to Receiver of NFT (if address is zero address it indicates token destruction).
521    * @param _tokenId The NFT that got transfered.
522    */
523   event Transfer(
524     address indexed _from,
525     address indexed _to,
526     uint256 indexed _tokenId
527   );
528 
529   /**
530    * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
531    * address indicates there is no approved address. When a Transfer event emits, this also
532    * indicates that the approved address for that NFT (if any) is reset to none.
533    * @param _owner Owner of NFT.
534    * @param _approved Address that we are approving.
535    * @param _tokenId NFT which we are approving.
536    */
537   event Approval(
538     address indexed _owner,
539     address indexed _approved,
540     uint256 indexed _tokenId
541   );
542 
543   /**
544    * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
545    * all NFTs of the owner.
546    * @param _owner Owner of NFT.
547    * @param _operator Address to which we are setting operator rights.
548    * @param _approved Status of operator rights(true if operator rights are given and false if
549    * revoked).
550    */
551   event ApprovalForAll(
552     address indexed _owner,
553     address indexed _operator,
554     bool _approved
555   );
556 
557   /**
558    * @dev Guarantees that the msg.sender is an owner or operator of the given NFT.
559    * @param _tokenId ID of the NFT to validate.
560    */
561   modifier canOperate(
562     uint256 _tokenId
563   ) {
564     address tokenOwner = idToOwner[_tokenId];
565     require(tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender]);
566     _;
567   }
568 
569   /**
570    * @dev Guarantees that the msg.sender is allowed to transfer NFT.
571    * @param _tokenId ID of the NFT to transfer.
572    */
573   modifier canTransfer(
574     uint256 _tokenId
575   ) {
576     address tokenOwner = idToOwner[_tokenId];
577     require(
578       tokenOwner == msg.sender
579       || getApproved(_tokenId) == msg.sender
580       || ownerToOperators[tokenOwner][msg.sender]
581     );
582 
583     _;
584   }
585 
586   /**
587    * @dev Guarantees that _tokenId is a valid Token.
588    * @param _tokenId ID of the NFT to validate.
589    */
590   modifier validNFToken(
591     uint256 _tokenId
592   ) {
593     require(idToOwner[_tokenId] != address(0));
594     _;
595   }
596 
597   /**
598    * @dev Contract constructor.
599    */
600   constructor()
601     public
602   {
603     supportedInterfaces[0x80ac58cd] = true; // ERC721
604   }
605 
606   /**
607    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
608    * considered invalid, and this function throws for queries about the zero address.
609    * @param _owner Address for whom to query the balance.
610    */
611   function balanceOf(
612     address _owner
613   )
614     external
615     view
616     returns (uint256)
617   {
618     require(_owner != address(0));
619     return ownerToNFTokenCount[_owner];
620   }
621 
622   /**
623    * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered
624    * invalid, and queries about them do throw.
625    * @param _tokenId The identifier for an NFT.
626    */
627   function ownerOf(
628     uint256 _tokenId
629   )
630     external
631     view
632     returns (address _owner)
633   {
634     _owner = idToOwner[_tokenId];
635     require(_owner != address(0));
636   }
637 
638   /**
639    * @dev Transfers the ownership of an NFT from one address to another address.
640    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
641    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
642    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
643    * function checks if `_to` is a smart contract (code size > 0). If so, it calls `onERC721Received`
644    * on `_to` and throws if the return value is not `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
645    * @param _from The current owner of the NFT.
646    * @param _to The new owner.
647    * @param _tokenId The NFT to transfer.
648    * @param _data Additional data with no specified format, sent in call to `_to`.
649    */
650   function safeTransferFrom(
651     address _from,
652     address _to,
653     uint256 _tokenId,
654     bytes _data
655   )
656     external
657   {
658     _safeTransferFrom(_from, _to, _tokenId, _data);
659   }
660 
661   /**
662    * @dev Transfers the ownership of an NFT from one address to another address.
663    * @notice This works identically to the other function with an extra data parameter, except this
664    * function just sets data to ""
665    * @param _from The current owner of the NFT.
666    * @param _to The new owner.
667    * @param _tokenId The NFT to transfer.
668    */
669   function safeTransferFrom(
670     address _from,
671     address _to,
672     uint256 _tokenId
673   )
674     external
675   {
676     _safeTransferFrom(_from, _to, _tokenId, "");
677   }
678 
679   /**
680    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
681    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
682    * address. Throws if `_tokenId` is not a valid NFT.
683    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
684    * they maybe be permanently lost.
685    * @param _from The current owner of the NFT.
686    * @param _to The new owner.
687    * @param _tokenId The NFT to transfer.
688    */
689   function transferFrom(
690     address _from,
691     address _to,
692     uint256 _tokenId
693   )
694     external
695     canTransfer(_tokenId)
696     validNFToken(_tokenId)
697   {
698     address tokenOwner = idToOwner[_tokenId];
699     require(tokenOwner == _from);
700     require(_to != address(0));
701 
702     _transfer(_to, _tokenId);
703   }
704 
705   /**
706    * @dev Set or reaffirm the approved address for an NFT.
707    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
708    * the current NFT owner, or an authorized operator of the current owner.
709    * @param _approved Address to be approved for the given NFT ID.
710    * @param _tokenId ID of the token to be approved.
711    */
712   function approve(
713     address _approved,
714     uint256 _tokenId
715   )
716     external
717     canOperate(_tokenId)
718     validNFToken(_tokenId)
719   {
720     address tokenOwner = idToOwner[_tokenId];
721     require(_approved != tokenOwner);
722 
723     idToApprovals[_tokenId] = _approved;
724     emit Approval(tokenOwner, _approved, _tokenId);
725   }
726 
727   /**
728    * @dev Enables or disables approval for a third party ("operator") to manage all of
729    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
730    * @notice This works even if sender doesn't own any tokens at the time.
731    * @param _operator Address to add to the set of authorized operators.
732    * @param _approved True if the operators is approved, false to revoke approval.
733    */
734   function setApprovalForAll(
735     address _operator,
736     bool _approved
737   )
738     external
739   {
740     require(_operator != address(0));
741     ownerToOperators[msg.sender][_operator] = _approved;
742     emit ApprovalForAll(msg.sender, _operator, _approved);
743   }
744 
745   /**
746    * @dev Get the approved address for a single NFT.
747    * @notice Throws if `_tokenId` is not a valid NFT.
748    * @param _tokenId ID of the NFT to query the approval of.
749    */
750   function getApproved(
751     uint256 _tokenId
752   )
753     public
754     view
755     validNFToken(_tokenId)
756     returns (address)
757   {
758     return idToApprovals[_tokenId];
759   }
760 
761   /**
762    * @dev Checks if `_operator` is an approved operator for `_owner`.
763    * @param _owner The address that owns the NFTs.
764    * @param _operator The address that acts on behalf of the owner.
765    */
766   function isApprovedForAll(
767     address _owner,
768     address _operator
769   )
770     external
771     view
772     returns (bool)
773   {
774     require(_owner != address(0));
775     require(_operator != address(0));
776     return ownerToOperators[_owner][_operator];
777   }
778 
779   /**
780    * @dev Actually perform the safeTransferFrom.
781    * @param _from The current owner of the NFT.
782    * @param _to The new owner.
783    * @param _tokenId The NFT to transfer.
784    * @param _data Additional data with no specified format, sent in call to `_to`.
785    */
786   function _safeTransferFrom(
787     address _from,
788     address _to,
789     uint256 _tokenId,
790     bytes _data
791   )
792     internal
793     canTransfer(_tokenId)
794     validNFToken(_tokenId)
795   {
796     address tokenOwner = idToOwner[_tokenId];
797     require(tokenOwner == _from);
798     require(_to != address(0));
799 
800     _transfer(_to, _tokenId);
801 
802     if (_to.isContract()) {
803       bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, _data);
804       require(retval == MAGIC_ON_ERC721_RECEIVED);
805     }
806   }
807 
808   /**
809    * @dev Actually preforms the transfer.
810    * @notice Does NO checks.
811    * @param _to Address of a new owner.
812    * @param _tokenId The NFT that is being transferred.
813    */
814   function _transfer(
815     address _to,
816     uint256 _tokenId
817   )
818     private
819   {
820     address from = idToOwner[_tokenId];
821 
822     clearApproval(from, _tokenId);
823     removeNFToken(from, _tokenId);
824     addNFToken(_to, _tokenId);
825 
826     emit Transfer(from, _to, _tokenId);
827   }
828 
829   /**
830    * @dev Mints a new NFT.
831    * @notice This is a private function which should be called from user-implemented external
832    * mint function. Its purpose is to show and properly initialize data structures when using this
833    * implementation.
834    * @param _to The address that will own the minted NFT.
835    * @param _tokenId of the NFT to be minted by the msg.sender.
836    */
837   function _mint(
838     address _to,
839     uint256 _tokenId
840   )
841     internal
842   {
843     require(_to != address(0));
844     require(_tokenId != 0);
845     require(idToOwner[_tokenId] == address(0));
846 
847     addNFToken(_to, _tokenId);
848 
849     emit Transfer(address(0), _to, _tokenId);
850   }
851 
852   /**
853    * @dev Burns a NFT.
854    * @notice This is a private function which should be called from user-implemented external
855    * burn function. Its purpose is to show and properly initialize data structures when using this
856    * implementation.
857    * @param _owner Address of the NFT owner.
858    * @param _tokenId ID of the NFT to be burned.
859    */
860   function _burn(
861     address _owner,
862     uint256 _tokenId
863   )
864     validNFToken(_tokenId)
865     internal
866   {
867     clearApproval(_owner, _tokenId);
868     removeNFToken(_owner, _tokenId);
869     emit Transfer(_owner, address(0), _tokenId);
870   }
871 
872   /**
873    * @dev Clears the current approval of a given NFT ID.
874    * @param _tokenId ID of the NFT to be transferred.
875    */
876   function clearApproval(
877     address _owner,
878     uint256 _tokenId
879   )
880     internal
881   {
882     delete idToApprovals[_tokenId];
883     emit Approval(_owner, 0, _tokenId);
884   }
885 
886   /**
887    * @dev Removes a NFT from owner.
888    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
889    * @param _from Address from wich we want to remove the NFT.
890    * @param _tokenId Which NFT we want to remove.
891    */
892   function removeNFToken(
893     address _from,
894     uint256 _tokenId
895   )
896    internal
897   {
898     require(idToOwner[_tokenId] == _from);
899     assert(ownerToNFTokenCount[_from] > 0);
900     ownerToNFTokenCount[_from] = ownerToNFTokenCount[_from].sub(1);
901     delete idToOwner[_tokenId];
902   }
903 
904   /**
905    * @dev Assignes a new NFT to owner.
906    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
907    * @param _to Address to wich we want to add the NFT.
908    * @param _tokenId Which NFT we want to add.
909    */
910   function addNFToken(
911     address _to,
912     uint256 _tokenId
913   )
914     internal
915   {
916     require(idToOwner[_tokenId] == address(0));
917 
918     idToOwner[_tokenId] = _to;
919     ownerToNFTokenCount[_to] = ownerToNFTokenCount[_to].add(1);
920   }
921 
922 }
923 
924 // File: @0xcert/ethereum-erc721/contracts/tokens/NFTokenEnumerable.sol
925 
926 /**
927  * @dev Optional enumeration implementation for ERC-721 non-fungible token standard.
928  */
929 contract NFTokenEnumerable is
930   NFToken,
931   ERC721Enumerable
932 {
933 
934   /**
935    * @dev Array of all NFT IDs.
936    */
937   uint256[] internal tokens;
938 
939   /**
940    * @dev Mapping from owner address to a list of owned NFT IDs.
941    */
942   mapping(uint256 => uint256) internal idToIndex;
943 
944   /**
945    * @dev Mapping from owner to list of owned NFT IDs.
946    */
947   mapping(address => uint256[]) internal ownerToIds;
948 
949   /**
950    * @dev Mapping from NFT ID to its index in the owner tokens list.
951    */
952   mapping(uint256 => uint256) internal idToOwnerIndex;
953 
954   /**
955    * @dev Contract constructor.
956    */
957   constructor()
958     public
959   {
960     supportedInterfaces[0x780e9d63] = true; // ERC721Enumerable
961   }
962 
963   /**
964    * @dev Mints a new NFT.
965    * @notice This is a private function which should be called from user-implemented external
966    * mint function. Its purpose is to show and properly initialize data structures when using this
967    * implementation.
968    * @param _to The address that will own the minted NFT.
969    * @param _tokenId of the NFT to be minted by the msg.sender.
970    */
971   function _mint(
972     address _to,
973     uint256 _tokenId
974   )
975     internal
976   {
977     super._mint(_to, _tokenId);
978     tokens.push(_tokenId);
979   }
980 
981   /**
982    * @dev Burns a NFT.
983    * @notice This is a private function which should be called from user-implemented external
984    * burn function. Its purpose is to show and properly initialize data structures when using this
985    * implementation.
986    * @param _owner Address of the NFT owner.
987    * @param _tokenId ID of the NFT to be burned.
988    */
989   function _burn(
990     address _owner,
991     uint256 _tokenId
992   )
993     internal
994   {
995     assert(tokens.length > 0);
996     super._burn(_owner, _tokenId);
997 
998     uint256 tokenIndex = idToIndex[_tokenId];
999     uint256 lastTokenIndex = tokens.length.sub(1);
1000     uint256 lastToken = tokens[lastTokenIndex];
1001 
1002     tokens[tokenIndex] = lastToken;
1003     tokens[lastTokenIndex] = 0;
1004 
1005     tokens.length--;
1006     idToIndex[_tokenId] = 0;
1007     idToIndex[lastToken] = tokenIndex;
1008   }
1009 
1010   /**
1011    * @dev Removes a NFT from an address.
1012    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
1013    * @param _from Address from wich we want to remove the NFT.
1014    * @param _tokenId Which NFT we want to remove.
1015    */
1016   function removeNFToken(
1017     address _from,
1018     uint256 _tokenId
1019   )
1020    internal
1021   {
1022     super.removeNFToken(_from, _tokenId);
1023     assert(ownerToIds[_from].length > 0);
1024 
1025     uint256 tokenToRemoveIndex = idToOwnerIndex[_tokenId];
1026     uint256 lastTokenIndex = ownerToIds[_from].length.sub(1);
1027     uint256 lastToken = ownerToIds[_from][lastTokenIndex];
1028 
1029     ownerToIds[_from][tokenToRemoveIndex] = lastToken;
1030     ownerToIds[_from][lastTokenIndex] = 0;
1031 
1032     ownerToIds[_from].length--;
1033     idToOwnerIndex[_tokenId] = 0;
1034     idToOwnerIndex[lastToken] = tokenToRemoveIndex;
1035   }
1036 
1037   /**
1038    * @dev Assignes a new NFT to an address.
1039    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
1040    * @param _to Address to wich we want to add the NFT.
1041    * @param _tokenId Which NFT we want to add.
1042    */
1043   function addNFToken(
1044     address _to,
1045     uint256 _tokenId
1046   )
1047     internal
1048   {
1049     super.addNFToken(_to, _tokenId);
1050 
1051     uint256 length = ownerToIds[_to].length;
1052     ownerToIds[_to].push(_tokenId);
1053     idToOwnerIndex[_tokenId] = length;
1054   }
1055 
1056   /**
1057    * @dev Returns the count of all existing NFTokens.
1058    */
1059   function totalSupply()
1060     external
1061     view
1062     returns (uint256)
1063   {
1064     return tokens.length;
1065   }
1066 
1067   /**
1068    * @dev Returns NFT ID by its index.
1069    * @param _index A counter less than `totalSupply()`.
1070    */
1071   function tokenByIndex(
1072     uint256 _index
1073   )
1074     external
1075     view
1076     returns (uint256)
1077   {
1078     require(_index < tokens.length);
1079     return tokens[_index];
1080   }
1081 
1082   /**
1083    * @dev returns the n-th NFT ID from a list of owner's tokens.
1084    * @param _owner Token owner's address.
1085    * @param _index Index number representing n-th token in owner's list of tokens.
1086    */
1087   function tokenOfOwnerByIndex(
1088     address _owner,
1089     uint256 _index
1090   )
1091     external
1092     view
1093     returns (uint256)
1094   {
1095     require(_index < ownerToIds[_owner].length);
1096     return ownerToIds[_owner][_index];
1097   }
1098 
1099 }
1100 
1101 // File: @0xcert/ethereum-erc721/contracts/tokens/ERC721Metadata.sol
1102 
1103 /**
1104  * @dev Optional metadata extension for ERC-721 non-fungible token standard.
1105  * See https://goo.gl/pc9yoS.
1106  */
1107 interface ERC721Metadata {
1108 
1109   /**
1110    * @dev Returns a descriptive name for a collection of NFTs in this contract.
1111    */
1112   function name()
1113     external
1114     view
1115     returns (string _name);
1116 
1117   /**
1118    * @dev Returns a abbreviated name for a collection of NFTs in this contract.
1119    */
1120   function symbol()
1121     external
1122     view
1123     returns (string _symbol);
1124 
1125   /**
1126    * @dev Returns a distinct Uniform Resource Identifier (URI) for a given asset. It Throws if
1127    * `_tokenId` is not a valid NFT. URIs are defined in RFC3986. The URI may point to a JSON file
1128    * that conforms to the "ERC721 Metadata JSON Schema".
1129    */
1130   function tokenURI(uint256 _tokenId)
1131     external
1132     view
1133     returns (string);
1134 
1135 }
1136 
1137 // File: @0xcert/ethereum-erc721/contracts/tokens/NFTokenMetadata.sol
1138 
1139 /**
1140  * @dev Optional metadata implementation for ERC-721 non-fungible token standard.
1141  */
1142 contract NFTokenMetadata is
1143   NFToken,
1144   ERC721Metadata
1145 {
1146 
1147   /**
1148    * @dev A descriptive name for a collection of NFTs.
1149    */
1150   string internal nftName;
1151 
1152   /**
1153    * @dev An abbreviated name for NFTokens.
1154    */
1155   string internal nftSymbol;
1156 
1157   /**
1158    * @dev Mapping from NFT ID to metadata uri.
1159    */
1160   mapping (uint256 => string) internal idToUri;
1161 
1162   /**
1163    * @dev Contract constructor.
1164    * @notice When implementing this contract don't forget to set nftName and nftSymbol.
1165    */
1166   constructor()
1167     public
1168   {
1169     supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
1170   }
1171 
1172   /**
1173    * @dev Burns a NFT.
1174    * @notice This is a internal function which should be called from user-implemented external
1175    * burn function. Its purpose is to show and properly initialize data structures when using this
1176    * implementation.
1177    * @param _owner Address of the NFT owner.
1178    * @param _tokenId ID of the NFT to be burned.
1179    */
1180   function _burn(
1181     address _owner,
1182     uint256 _tokenId
1183   )
1184     internal
1185   {
1186     super._burn(_owner, _tokenId);
1187 
1188     if (bytes(idToUri[_tokenId]).length != 0) {
1189       delete idToUri[_tokenId];
1190     }
1191   }
1192 
1193   /**
1194    * @dev Set a distinct URI (RFC 3986) for a given NFT ID.
1195    * @notice this is a internal function which should be called from user-implemented external
1196    * function. Its purpose is to show and properly initialize data structures when using this
1197    * implementation.
1198    * @param _tokenId Id for which we want uri.
1199    * @param _uri String representing RFC 3986 URI.
1200    */
1201   function _setTokenUri(
1202     uint256 _tokenId,
1203     string _uri
1204   )
1205     validNFToken(_tokenId)
1206     internal
1207   {
1208     idToUri[_tokenId] = _uri;
1209   }
1210 
1211   /**
1212    * @dev Returns a descriptive name for a collection of NFTokens.
1213    */
1214   function name()
1215     external
1216     view
1217     returns (string _name)
1218   {
1219     _name = nftName;
1220   }
1221 
1222   /**
1223    * @dev Returns an abbreviated name for NFTokens.
1224    */
1225   function symbol()
1226     external
1227     view
1228     returns (string _symbol)
1229   {
1230     _symbol = nftSymbol;
1231   }
1232 
1233   /**
1234    * @dev A distinct URI (RFC 3986) for a given NFT.
1235    * @param _tokenId Id for which we want uri.
1236    */
1237   function tokenURI(
1238     uint256 _tokenId
1239   )
1240     validNFToken(_tokenId)
1241     external
1242     view
1243     returns (string)
1244   {
1245     return idToUri[_tokenId];
1246   }
1247 
1248 }
1249 
1250 // File: @0xcert/ethereum-xcert/contracts/tokens/Xcert.sol
1251 
1252 /**
1253  * @dev Xcert implementation.
1254  */
1255 contract Xcert is NFTokenEnumerable, NFTokenMetadata {
1256   using SafeMath for uint256;
1257   using AddressUtils for address;
1258 
1259   /**
1260    * @dev Unique ID which determines each Xcert smart contract type by its JSON convention.
1261    * @notice Calculated as bytes4(keccak256(jsonSchema)).
1262    */
1263   bytes4 internal nftConventionId;
1264 
1265   /**
1266    * @dev Maps NFT ID to proof.
1267    */
1268   mapping (uint256 => string) internal idToProof;
1269 
1270   /**
1271    * @dev Maps NFT ID to protocol config.
1272    */
1273   mapping (uint256 => bytes32[]) internal config;
1274 
1275   /**
1276    * @dev Maps NFT ID to convention data.
1277    */
1278   mapping (uint256 => bytes32[]) internal data;
1279 
1280   /**
1281    * @dev Maps address to authorization of contract.
1282    */
1283   mapping (address => bool) internal addressToAuthorized;
1284 
1285   /**
1286    * @dev Emits when an address is authorized to some contract control or the authorization is revoked.
1287    * The _target has some contract controle like minting new NFTs.
1288    * @param _target Address to set authorized state.
1289    * @param _authorized True if the _target is authorised, false to revoke authorization.
1290    */
1291   event AuthorizedAddress(
1292     address indexed _target,
1293     bool _authorized
1294   );
1295 
1296   /**
1297    * @dev Guarantees that msg.sender is allowed to mint a new NFT.
1298    */
1299   modifier isAuthorized() {
1300     require(msg.sender == owner || addressToAuthorized[msg.sender]);
1301     _;
1302   }
1303 
1304   /**
1305    * @dev Contract constructor.
1306    * @notice When implementing this contract don't forget to set nftConventionId, nftName and
1307    * nftSymbol.
1308    */
1309   constructor()
1310     public
1311   {
1312     supportedInterfaces[0x6be14f75] = true; // Xcert
1313   }
1314 
1315   /**
1316    * @dev Mints a new NFT.
1317    * @param _to The address that will own the minted NFT.
1318    * @param _id The NFT to be minted by the msg.sender.
1319    * @param _uri An URI pointing to NFT metadata.
1320    * @param _proof Cryptographic asset imprint.
1321    * @param _config Array of protocol config values where 0 index represents token expiration
1322    * timestamp, other indexes are not yet definied but are ready for future xcert upgrades.
1323    * @param _data Array of convention data values.
1324    */
1325   function mint(
1326     address _to,
1327     uint256 _id,
1328     string _uri,
1329     string _proof,
1330     bytes32[] _config,
1331     bytes32[] _data
1332   )
1333     external
1334     isAuthorized()
1335   {
1336     require(_config.length > 0);
1337     require(bytes(_proof).length > 0);
1338     super._mint(_to, _id);
1339     super._setTokenUri(_id, _uri);
1340     idToProof[_id] = _proof;
1341     config[_id] = _config;
1342     data[_id] = _data;
1343   }
1344 
1345   /**
1346    * @dev Returns a bytes4 of keccak256 of json schema representing 0xcert protocol convention.
1347    */
1348   function conventionId()
1349     external
1350     view
1351     returns (bytes4 _conventionId)
1352   {
1353     _conventionId = nftConventionId;
1354   }
1355 
1356   /**
1357    * @dev Returns proof for NFT.
1358    * @param _tokenId Id of the NFT.
1359    */
1360   function tokenProof(
1361     uint256 _tokenId
1362   )
1363     validNFToken(_tokenId)
1364     external
1365     view
1366     returns(string)
1367   {
1368     return idToProof[_tokenId];
1369   }
1370 
1371   /**
1372    * @dev Returns convention data value for a given index field.
1373    * @param _tokenId Id of the NFT we want to get value for key.
1374    * @param _index for which we want to get value.
1375    */
1376   function tokenDataValue(
1377     uint256 _tokenId,
1378     uint256 _index
1379   )
1380     validNFToken(_tokenId)
1381     public
1382     view
1383     returns(bytes32 value)
1384   {
1385     require(_index < data[_tokenId].length);
1386     value = data[_tokenId][_index];
1387   }
1388 
1389   /**
1390    * @dev Returns expiration date from 0 index of token config values.
1391    * @param _tokenId Id of the NFT we want to get expiration time of.
1392    */
1393   function tokenExpirationTime(
1394     uint256 _tokenId
1395   )
1396     validNFToken(_tokenId)
1397     external
1398     view
1399     returns(bytes32)
1400   {
1401     return config[_tokenId][0];
1402   }
1403 
1404   /**
1405    * @dev Sets authorised address for minting.
1406    * @param _target Address to set authorized state.
1407    * @param _authorized True if the _target is authorised, false to revoke authorization.
1408    */
1409   function setAuthorizedAddress(
1410     address _target,
1411     bool _authorized
1412   )
1413     onlyOwner
1414     external
1415   {
1416     require(_target != address(0));
1417     addressToAuthorized[_target] = _authorized;
1418     emit AuthorizedAddress(_target, _authorized);
1419   }
1420 
1421   /**
1422    * @dev Sets mint authorised address.
1423    * @param _target Address for which we want to check if it is authorized.
1424    * @return Is authorized or not.
1425    */
1426   function isAuthorizedAddress(
1427     address _target
1428   )
1429     external
1430     view
1431     returns (bool)
1432   {
1433     require(_target != address(0));
1434     return addressToAuthorized[_target];
1435   }
1436 }
1437 
1438 // File: @0xcert/ethereum-erc20/contracts/tokens/ERC20.sol
1439 
1440 /**
1441  * @title A standard interface for tokens.
1442  */
1443 interface ERC20 {
1444 
1445   /**
1446    * @dev Returns the name of the token.
1447    */
1448   function name()
1449     external
1450     view
1451     returns (string _name);
1452 
1453   /**
1454    * @dev Returns the symbol of the token.
1455    */
1456   function symbol()
1457     external
1458     view
1459     returns (string _symbol);
1460 
1461   /**
1462    * @dev Returns the number of decimals the token uses.
1463    */
1464   function decimals()
1465     external
1466     view
1467     returns (uint8 _decimals);
1468 
1469   /**
1470    * @dev Returns the total token supply.
1471    */
1472   function totalSupply()
1473     external
1474     view
1475     returns (uint256 _totalSupply);
1476 
1477   /**
1478    * @dev Returns the account balance of another account with address _owner.
1479    * @param _owner The address from which the balance will be retrieved.
1480    */
1481   function balanceOf(
1482     address _owner
1483   )
1484     external
1485     view
1486     returns (uint256 _balance);
1487 
1488   /**
1489    * @dev Transfers _value amount of tokens to address _to, and MUST fire the Transfer event. The
1490    * function SHOULD throw if the _from account balance does not have enough tokens to spend.
1491    * @param _to The address of the recipient.
1492    * @param _value The amount of token to be transferred.
1493    */
1494   function transfer(
1495     address _to,
1496     uint256 _value
1497   )
1498     external
1499     returns (bool _success);
1500 
1501   /**
1502    * @dev Transfers _value amount of tokens from address _from to address _to, and MUST fire the
1503    * Transfer event.
1504    * @param _from The address of the sender.
1505    * @param _to The address of the recipient.
1506    * @param _value The amount of token to be transferred.
1507    */
1508   function transferFrom(
1509     address _from,
1510     address _to,
1511     uint256 _value
1512   )
1513     external
1514     returns (bool _success);
1515 
1516   /**
1517    * @dev Allows _spender to withdraw from your account multiple times, up to
1518    * the _value amount. If this function is called again it overwrites the current
1519    * allowance with _value.
1520    * @param _spender The address of the account able to transfer the tokens.
1521    * @param _value The amount of tokens to be approved for transfer.
1522    */
1523   function approve(
1524     address _spender,
1525     uint256 _value
1526   )
1527     external
1528     returns (bool _success);
1529 
1530   /**
1531    * @dev Returns the amount which _spender is still allowed to withdraw from _owner.
1532    * @param _owner The address of the account owning tokens.
1533    * @param _spender The address of the account able to transfer the tokens.
1534    */
1535   function allowance(
1536     address _owner,
1537     address _spender
1538   )
1539     external
1540     view
1541     returns (uint256 _remaining);
1542 
1543   /**
1544    * @dev Triggers when tokens are transferred, including zero value transfers.
1545    */
1546   event Transfer(
1547     address indexed _from,
1548     address indexed _to,
1549     uint256 _value
1550   );
1551 
1552   /**
1553    * @dev Triggers on any successful call to approve(address _spender, uint256 _value).
1554    */
1555   event Approval(
1556     address indexed _owner,
1557     address indexed _spender,
1558     uint256 _value
1559   );
1560 
1561 }
1562 
1563 // File: @0xcert/ethereum-erc20/contracts/tokens/Token.sol
1564 
1565 /**
1566  * @title ERC20 standard token implementation.
1567  * @dev Standard ERC20 token. This contract follows the implementation at https://goo.gl/mLbAPJ.
1568  */
1569 contract Token is
1570   ERC20
1571 {
1572   using SafeMath for uint256;
1573 
1574   /**
1575    * Token name.
1576    */
1577   string internal tokenName;
1578 
1579   /**
1580    * Token symbol.
1581    */
1582   string internal tokenSymbol;
1583 
1584   /**
1585    * Number of decimals.
1586    */
1587   uint8 internal tokenDecimals;
1588 
1589   /**
1590    * Total supply of tokens.
1591    */
1592   uint256 internal tokenTotalSupply;
1593 
1594   /**
1595    * Balance information map.
1596    */
1597   mapping (address => uint256) internal balances;
1598 
1599   /**
1600    * Token allowance mapping.
1601    */
1602   mapping (address => mapping (address => uint256)) internal allowed;
1603 
1604   /**
1605    * @dev Trigger when tokens are transferred, including zero value transfers.
1606    */
1607   event Transfer(
1608     address indexed _from,
1609     address indexed _to,
1610     uint256 _value
1611   );
1612 
1613   /**
1614    * @dev Trigger on any successful call to approve(address _spender, uint256 _value).
1615    */
1616   event Approval(
1617     address indexed _owner,
1618     address indexed _spender,
1619     uint256 _value
1620   );
1621 
1622   /**
1623    * @dev Returns the name of the token.
1624    */
1625   function name()
1626     external
1627     view
1628     returns (string _name)
1629   {
1630     _name = tokenName;
1631   }
1632 
1633   /**
1634    * @dev Returns the symbol of the token.
1635    */
1636   function symbol()
1637     external
1638     view
1639     returns (string _symbol)
1640   {
1641     _symbol = tokenSymbol;
1642   }
1643 
1644   /**
1645    * @dev Returns the number of decimals the token uses.
1646    */
1647   function decimals()
1648     external
1649     view
1650     returns (uint8 _decimals)
1651   {
1652     _decimals = tokenDecimals;
1653   }
1654 
1655   /**
1656    * @dev Returns the total token supply.
1657    */
1658   function totalSupply()
1659     external
1660     view
1661     returns (uint256 _totalSupply)
1662   {
1663     _totalSupply = tokenTotalSupply;
1664   }
1665 
1666   /**
1667    * @dev Returns the account balance of another account with address _owner.
1668    * @param _owner The address from which the balance will be retrieved.
1669    */
1670   function balanceOf(
1671     address _owner
1672   )
1673     external
1674     view
1675     returns (uint256 _balance)
1676   {
1677     _balance = balances[_owner];
1678   }
1679 
1680   /**
1681    * @dev Transfers _value amount of tokens to address _to, and MUST fire the Transfer event. The
1682    * function SHOULD throw if the _from account balance does not have enough tokens to spend.
1683    * @param _to The address of the recipient.
1684    * @param _value The amount of token to be transferred.
1685    */
1686   function transfer(
1687     address _to,
1688     uint256 _value
1689   )
1690     public
1691     returns (bool _success)
1692   {
1693     require(_value <= balances[msg.sender]);
1694 
1695     balances[msg.sender] = balances[msg.sender].sub(_value);
1696     balances[_to] = balances[_to].add(_value);
1697 
1698     emit Transfer(msg.sender, _to, _value);
1699     _success = true;
1700   }
1701 
1702   /**
1703    * @dev Allows _spender to withdraw from your account multiple times, up to the _value amount. If
1704    * this function is called again it overwrites the current allowance with _value.
1705    * @param _spender The address of the account able to transfer the tokens.
1706    * @param _value The amount of tokens to be approved for transfer.
1707    */
1708   function approve(
1709     address _spender,
1710     uint256 _value
1711   )
1712     public
1713     returns (bool _success)
1714   {
1715     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
1716 
1717     allowed[msg.sender][_spender] = _value;
1718 
1719     emit Approval(msg.sender, _spender, _value);
1720     _success = true;
1721   }
1722 
1723   /**
1724    * @dev Returns the amount which _spender is still allowed to withdraw from _owner.
1725    * @param _owner The address of the account owning tokens.
1726    * @param _spender The address of the account able to transfer the tokens.
1727    */
1728   function allowance(
1729     address _owner,
1730     address _spender
1731   )
1732     external
1733     view
1734     returns (uint256 _remaining)
1735   {
1736     _remaining = allowed[_owner][_spender];
1737   }
1738 
1739   /**
1740    * @dev Transfers _value amount of tokens from address _from to address _to, and MUST fire the
1741    * Transfer event.
1742    * @param _from The address of the sender.
1743    * @param _to The address of the recipient.
1744    * @param _value The amount of token to be transferred.
1745    */
1746   function transferFrom(
1747     address _from,
1748     address _to,
1749     uint256 _value
1750   )
1751     public
1752     returns (bool _success)
1753   {
1754     require(_value <= balances[_from]);
1755     require(_value <= allowed[_from][msg.sender]);
1756 
1757     balances[_from] = balances[_from].sub(_value);
1758     balances[_to] = balances[_to].add(_value);
1759     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1760 
1761     emit Transfer(_from, _to, _value);
1762     _success = true;
1763   }
1764 
1765 }
1766 
1767 // File: @0xcert/ethereum-zxc/contracts/tokens/Zxc.sol
1768 
1769 /*
1770  * @title ZXC protocol token.
1771  * @dev Standard ERC20 token used by the 0xcert protocol. This contract follows the implementation
1772  * at https://goo.gl/twbPwp.
1773  */
1774 contract Zxc is
1775   Token,
1776   Ownable
1777 {
1778   using SafeMath for uint256;
1779 
1780   /**
1781    * Transfer feature state.
1782    */
1783   bool internal transferEnabled;
1784 
1785   /**
1786    * Crowdsale smart contract address.
1787    */
1788   address public crowdsaleAddress;
1789 
1790   /**
1791    * @dev An event which is triggered when tokens are burned.
1792    * @param _burner The address which burns tokens.
1793    * @param _value The amount of burned tokens.
1794    */
1795   event Burn(
1796     address indexed _burner,
1797     uint256 _value
1798   );
1799 
1800   /**
1801    * @dev Assures that the provided address is a valid destination to transfer tokens to.
1802    * @param _to Target address.
1803    */
1804   modifier validDestination(
1805     address _to
1806   )
1807   {
1808     require(_to != address(0x0));
1809     require(_to != address(this));
1810     require(_to != address(crowdsaleAddress));
1811     _;
1812   }
1813 
1814   /**
1815    * @dev Assures that tokens can be transfered.
1816    */
1817   modifier onlyWhenTransferAllowed()
1818   {
1819     require(transferEnabled || msg.sender == crowdsaleAddress);
1820     _;
1821   }
1822 
1823   /**
1824    * @dev Contract constructor.
1825    */
1826   constructor()
1827     public
1828   {
1829     tokenName = "0xcert Protocol Token";
1830     tokenSymbol = "ZXC";
1831     tokenDecimals = 18;
1832     tokenTotalSupply = 400000000000000000000000000;
1833     transferEnabled = false;
1834 
1835     balances[owner] = tokenTotalSupply;
1836     emit Transfer(address(0x0), owner, tokenTotalSupply);
1837   }
1838 
1839   /**
1840    * @dev Transfers token to a specified address.
1841    * @param _to The address to transfer to.
1842    * @param _value The amount to be transferred.
1843    */
1844   function transfer(
1845     address _to,
1846     uint256 _value
1847   )
1848     onlyWhenTransferAllowed()
1849     validDestination(_to)
1850     public
1851     returns (bool _success)
1852   {
1853     _success = super.transfer(_to, _value);
1854   }
1855 
1856   /**
1857    * @dev Transfers tokens from one address to another.
1858    * @param _from address The address which you want to send tokens from.
1859    * @param _to address The address which you want to transfer to.
1860    * @param _value uint256 The amount of tokens to be transferred.
1861    */
1862   function transferFrom(
1863     address _from,
1864     address _to,
1865     uint256 _value
1866   )
1867     onlyWhenTransferAllowed()
1868     validDestination(_to)
1869     public
1870     returns (bool _success)
1871   {
1872     _success = super.transferFrom(_from, _to, _value);
1873   }
1874 
1875   /**
1876    * @dev Enables token transfers.
1877    */
1878   function enableTransfer()
1879     onlyOwner()
1880     external
1881   {
1882     transferEnabled = true;
1883   }
1884 
1885   /**
1886    * @dev Burns a specific amount of tokens. This function is based on BurnableToken implementation
1887    * at goo.gl/GZEhaq.
1888    * @notice Only owner is allowed to perform this operation.
1889    * @param _value The amount of tokens to be burned.
1890    */
1891   function burn(
1892     uint256 _value
1893   )
1894     onlyOwner()
1895     external
1896   {
1897     require(_value <= balances[msg.sender]);
1898 
1899     balances[owner] = balances[owner].sub(_value);
1900     tokenTotalSupply = tokenTotalSupply.sub(_value);
1901 
1902     emit Burn(owner, _value);
1903     emit Transfer(owner, address(0x0), _value);
1904   }
1905 
1906   /**
1907     * @dev Set crowdsale address which can distribute tokens even when onlyWhenTransferAllowed is
1908     * false.
1909     * @param crowdsaleAddr Address of token offering contract.
1910     */
1911   function setCrowdsaleAddress(
1912     address crowdsaleAddr
1913   )
1914     external
1915     onlyOwner()
1916   {
1917     crowdsaleAddress = crowdsaleAddr;
1918   }
1919 
1920 }
1921 
1922 // File: contracts/crowdsale/ZxcCrowdsale.sol
1923 
1924 /**
1925  * @title ZXC crowdsale contract.
1926  * @dev Crowdsale contract for distributing ZXC tokens.
1927  * Start timestamps for the token sale stages (start dates are inclusive, end exclusive):
1928  *   - Token presale with 10% bonus: 2018/06/26 - 2018/07/04
1929  *   - Token sale with 5% bonus: 2018/07/04 - 2018/07/05
1930  *   - Token sale with 0% bonus: 2018/07/05 - 2018/07/18
1931  */
1932 contract ZxcCrowdsale
1933 {
1934   using SafeMath for uint256;
1935 
1936   /**
1937    * @dev Token being sold.
1938    */
1939   Zxc public token;
1940 
1941   /**
1942    * @dev Xcert KYC token.
1943    */
1944   Xcert public xcertKyc;
1945 
1946   /**
1947    * @dev Start time of the presale.
1948    */
1949   uint256 public startTimePresale;
1950 
1951   /**
1952    * @dev Start time of the token sale with bonus.
1953    */
1954   uint256 public startTimeSaleWithBonus;
1955 
1956   /**
1957    * @dev Start time of the token sale with no bonus.
1958    */
1959   uint256 public startTimeSaleNoBonus;
1960 
1961   /**
1962    * @dev Presale bonus expressed as percentage integer (10% = 10).
1963    */
1964   uint256 public bonusPresale;
1965 
1966   /**
1967    * @dev Token sale bonus expressed as percentage integer (10% = 10).
1968    */
1969   uint256 public bonusSale;
1970 
1971   /**
1972    * @dev End timestamp to end the crowdsale.
1973    */
1974   uint256 public endTime;
1975 
1976   /**
1977    * @dev Minimum required wei deposit for public presale period.
1978    */
1979   uint256 public minimumPresaleWeiDeposit;
1980 
1981   /**
1982    * @dev Total amount of ZXC tokens offered for the presale.
1983    */
1984   uint256 public preSaleZxcCap;
1985 
1986   /**
1987    * @dev Total supply of ZXC tokens for the sale.
1988    */
1989   uint256 public crowdSaleZxcSupply;
1990 
1991   /**
1992    * @dev Amount of ZXC tokens sold.
1993    */
1994   uint256 public zxcSold;
1995 
1996   /**
1997    * @dev Address where funds are collected.
1998    */
1999   address public wallet;
2000 
2001   /**
2002    * @dev How many token units buyer gets per wei.
2003    */
2004   uint256 public rate;
2005 
2006   /**
2007    * @dev An event which is triggered when tokens are bought.
2008    * @param _from The address sending tokens.
2009    * @param _to The address receiving tokens.
2010    * @param _weiAmount Purchase amount in wei.
2011    * @param _tokenAmount The amount of purchased tokens.
2012    */
2013   event TokenPurchase(
2014     address indexed _from,
2015     address indexed _to,
2016     uint256 _weiAmount,
2017     uint256 _tokenAmount
2018   );
2019 
2020   /**
2021    * @dev Contract constructor.
2022    * @param _walletAddress Address of the wallet which collects funds.
2023    * @param _tokenAddress Address of the ZXC token contract.
2024    * @param _xcertKycAddress Address of the Xcert KYC token contract.
2025    * @param _startTimePresale Start time of presale stage.
2026    * @param _startTimeSaleWithBonus Start time of public sale stage with bonus.
2027    * @param _startTimeSaleNoBonus Start time of public sale stage with no bonus.
2028    * @param _endTime Time when sale ends.
2029    * @param _rate ZXC/ETH exchange rate.
2030    * @param _presaleZxcCap Maximum number of ZXC offered for the presale.
2031    * @param _crowdSaleZxcSupply Supply of ZXC tokens offered for the sale. Includes _presaleZxcCap.
2032    * @param _bonusPresale Bonus token percentage for presale.
2033    * @param _bonusSale Bonus token percentage for public sale stage with bonus.
2034    * @param _minimumPresaleWeiDeposit Minimum required deposit in wei.
2035    */
2036   constructor(
2037     address _walletAddress,
2038     address _tokenAddress,
2039     address _xcertKycAddress,
2040     uint256 _startTimePresale,  // 1529971200: date -d '2018-06-26 00:00:00 UTC' +%s
2041     uint256 _startTimeSaleWithBonus, // 1530662400: date -d '2018-07-04 00:00:00 UTC' +%s
2042     uint256 _startTimeSaleNoBonus,  //1530748800: date -d '2018-07-05 00:00:00 UTC' +%s
2043     uint256 _endTime,  // 1531872000: date -d '2018-07-18 00:00:00 UTC' +%s
2044     uint256 _rate,  // 10000: 1 ETH = 10,000 ZXC
2045     uint256 _presaleZxcCap, // 195M
2046     uint256 _crowdSaleZxcSupply, // 250M
2047     uint256 _bonusPresale,  // 10 (%)
2048     uint256 _bonusSale,  // 5 (%)
2049     uint256 _minimumPresaleWeiDeposit  // 1 ether;
2050   )
2051     public
2052   {
2053     require(_walletAddress != address(0));
2054     require(_tokenAddress != address(0));
2055     require(_xcertKycAddress != address(0));
2056     require(_tokenAddress != _walletAddress);
2057     require(_tokenAddress != _xcertKycAddress);
2058     require(_xcertKycAddress != _walletAddress);
2059 
2060     token = Zxc(_tokenAddress);
2061     xcertKyc = Xcert(_xcertKycAddress);
2062 
2063     uint8 _tokenDecimals = token.decimals();
2064     require(_tokenDecimals == 18);  // Sanity check.
2065     wallet = _walletAddress;
2066 
2067     // Bonus should be > 0% and <= 100%
2068     require(_bonusPresale > 0 && _bonusPresale <= 100);
2069     require(_bonusSale > 0 && _bonusSale <= 100);
2070 
2071     bonusPresale = _bonusPresale;
2072     bonusSale = _bonusSale;
2073 
2074     require(_startTimePresale >= now);
2075     require(_startTimeSaleWithBonus > _startTimePresale);
2076     require(_startTimeSaleNoBonus > _startTimeSaleWithBonus);
2077 
2078     startTimePresale = _startTimePresale;
2079     startTimeSaleWithBonus = _startTimeSaleWithBonus;
2080     startTimeSaleNoBonus = _startTimeSaleNoBonus;
2081     endTime = _endTime;
2082 
2083     require(_rate > 0);
2084     rate = _rate;
2085 
2086     require(_crowdSaleZxcSupply > 0);
2087     require(token.totalSupply() >= _crowdSaleZxcSupply);
2088     crowdSaleZxcSupply = _crowdSaleZxcSupply;
2089 
2090     require(_presaleZxcCap > 0 && _presaleZxcCap <= _crowdSaleZxcSupply);
2091     preSaleZxcCap = _presaleZxcCap;
2092 
2093     zxcSold = 0;
2094 
2095     require(_minimumPresaleWeiDeposit > 0);
2096     minimumPresaleWeiDeposit = _minimumPresaleWeiDeposit;
2097   }
2098 
2099   /**
2100    * @dev Fallback function can be used to buy tokens.
2101    */
2102   function()
2103     external
2104     payable
2105   {
2106     buyTokens();
2107   }
2108 
2109   /**
2110    * @dev Low level token purchase function.
2111    */
2112   function buyTokens()
2113     public
2114     payable
2115   {
2116     uint256 tokens;
2117 
2118     // Sender needs Xcert KYC token.
2119     uint256 balance = xcertKyc.balanceOf(msg.sender);
2120     require(balance > 0);
2121     
2122     if (isInTimeRange(startTimePresale, startTimeSaleWithBonus)) {
2123       uint256 tokenId = xcertKyc.tokenOfOwnerByIndex(msg.sender, balance.sub(1));
2124       uint256 kycLevel = uint(xcertKyc.tokenDataValue(tokenId, 0));
2125       require(kycLevel > 1);
2126       require(msg.value >= minimumPresaleWeiDeposit);
2127       tokens = getTokenAmount(msg.value, bonusPresale);
2128       require(tokens <= preSaleZxcCap);
2129     }
2130     else if (isInTimeRange(startTimeSaleWithBonus, startTimeSaleNoBonus)) {
2131       tokens = getTokenAmount(msg.value, bonusSale);
2132     }
2133     else if (isInTimeRange(startTimeSaleNoBonus, endTime)) {
2134       tokens = getTokenAmount(msg.value, uint256(0));
2135     }
2136     else {
2137       revert("Purchase outside of token sale time windows");
2138     }
2139 
2140     require(zxcSold.add(tokens) <= crowdSaleZxcSupply);
2141     zxcSold = zxcSold.add(tokens);
2142 
2143     wallet.transfer(msg.value);
2144     require(token.transferFrom(token.owner(), msg.sender, tokens));
2145     emit TokenPurchase(msg.sender, msg.sender, msg.value, tokens);
2146   }
2147 
2148   /**
2149    * @return true if crowdsale event has ended
2150    */
2151   function hasEnded()
2152     external
2153     view
2154     returns (bool)
2155   {
2156     bool capReached = zxcSold >= crowdSaleZxcSupply;
2157     bool endTimeReached = now >= endTime;
2158     return capReached || endTimeReached;
2159   }
2160 
2161   /**
2162    * @dev Check if currently active period is a given time period.
2163    * @param _startTime Starting timestamp (inclusive).
2164    * @param _endTime Ending timestamp (exclusive).
2165    * @return bool
2166    */
2167   function isInTimeRange(
2168     uint256 _startTime,
2169     uint256 _endTime
2170   )
2171     internal
2172     view
2173     returns(bool)
2174   {
2175     if (now >= _startTime && now < _endTime) {
2176       return true;
2177     }
2178     else {
2179       return false;
2180     }
2181   }
2182 
2183   /**
2184    * @dev Calculate amount of tokens for a given wei amount. Apply special bonuses depending on
2185    * @param weiAmount Amount of wei for token purchase.
2186    * @param bonusPercent Percentage of bonus tokens.
2187    * @return Number of tokens with possible bonus.
2188    */
2189   function getTokenAmount(
2190     uint256 weiAmount,
2191     uint256 bonusPercent
2192   )
2193     internal
2194     view
2195     returns(uint256)
2196   {
2197     uint256 tokens = weiAmount.mul(rate);
2198 
2199     if (bonusPercent > 0) {
2200       uint256 bonusTokens = tokens.mul(bonusPercent).div(uint256(100)); // tokens * bonus (%) / 100%
2201       tokens = tokens.add(bonusTokens);
2202     }
2203 
2204     return tokens;
2205   }
2206 }