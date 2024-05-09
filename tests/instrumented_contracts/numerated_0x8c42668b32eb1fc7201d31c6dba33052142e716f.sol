1 pragma solidity ^0.4.24;
2 
3 /**
4  * @dev Optional enumeration extension for ERC-721 non-fungible token standard.
5  * See https://goo.gl/pc9yoS.
6  */
7 interface ERC721Enumerable {
8 
9   /**
10    * @dev Returns a count of valid NFTs tracked by this contract, where each one of them has an
11    * assigned and queryable owner not equal to the zero address.
12    */
13   function totalSupply()
14     external
15     view
16     returns (uint256);
17 
18   /**
19    * @dev Returns the token identifier for the `_index`th NFT. Sort order is not specified.
20    * @param _index A counter less than `totalSupply()`.
21    */
22   function tokenByIndex(
23     uint256 _index
24   )
25     external
26     view
27     returns (uint256);
28 
29   /**
30    * @dev Returns the token identifier for the `_index`th NFT assigned to `_owner`. Sort order is
31    * not specified. It throws if `_index` >= `balanceOf(_owner)` or if `_owner` is the zero address,
32    * representing invalid NFTs.
33    * @param _owner An address where we are interested in NFTs owned by them.
34    * @param _index A counter less than `balanceOf(_owner)`.
35    */
36   function tokenOfOwnerByIndex(
37     address _owner,
38     uint256 _index
39   )
40     external
41     view
42     returns (uint256);
43 
44 }
45 
46 /**
47  * @dev ERC-721 non-fungible token standard. See https://goo.gl/pc9yoS.
48  */
49 interface ERC721 {
50 
51   /**
52    * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
53    * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
54    * number of NFTs may be created and assigned without emitting Transfer. At the time of any
55    * transfer, the approved address for that NFT (if any) is reset to none.
56    */
57   event Transfer(
58     address indexed _from,
59     address indexed _to,
60     uint256 indexed _tokenId
61   );
62 
63   /**
64    * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
65    * address indicates there is no approved address. When a Transfer event emits, this also
66    * indicates that the approved address for that NFT (if any) is reset to none.
67    */
68   event Approval(
69     address indexed _owner,
70     address indexed _approved,
71     uint256 indexed _tokenId
72   );
73 
74   /**
75    * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
76    * all NFTs of the owner.
77    */
78   event ApprovalForAll(
79     address indexed _owner,
80     address indexed _operator,
81     bool _approved
82   );
83 
84   /**
85    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
86    * considered invalid, and this function throws for queries about the zero address.
87    * @param _owner Address for whom to query the balance.
88    */
89   function balanceOf(
90     address _owner
91   )
92     external
93     view
94     returns (uint256);
95 
96   /**
97    * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered
98    * invalid, and queries about them do throw.
99    * @param _tokenId The identifier for an NFT.
100    */
101   function ownerOf(
102     uint256 _tokenId
103   )
104     external
105     view
106     returns (address);
107 
108   /**
109    * @dev Transfers the ownership of an NFT from one address to another address.
110    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
111    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
112    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
113    * function checks if `_to` is a smart contract (code size > 0). If so, it calls `onERC721Received`
114    * on `_to` and throws if the return value is not `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
115    * @param _from The current owner of the NFT.
116    * @param _to The new owner.
117    * @param _tokenId The NFT to transfer.
118    * @param _data Additional data with no specified format, sent in call to `_to`.
119    */
120   function safeTransferFrom(
121     address _from,
122     address _to,
123     uint256 _tokenId,
124     bytes _data
125   )
126     external;
127 
128   /**
129    * @dev Transfers the ownership of an NFT from one address to another address.
130    * @notice This works identically to the other function with an extra data parameter, except this
131    * function just sets data to ""
132    * @param _from The current owner of the NFT.
133    * @param _to The new owner.
134    * @param _tokenId The NFT to transfer.
135    */
136   function safeTransferFrom(
137     address _from,
138     address _to,
139     uint256 _tokenId
140   )
141     external;
142 
143   /**
144    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
145    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
146    * address. Throws if `_tokenId` is not a valid NFT.
147    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
148    * they mayb be permanently lost.
149    * @param _from The current owner of the NFT.
150    * @param _to The new owner.
151    * @param _tokenId The NFT to transfer.
152    */
153   function transferFrom(
154     address _from,
155     address _to,
156     uint256 _tokenId
157   )
158     external;
159 
160   /**
161    * @dev Set or reaffirm the approved address for an NFT.
162    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
163    * the current NFT owner, or an authorized operator of the current owner.
164    * @param _approved The new approved NFT controller.
165    * @param _tokenId The NFT to approve.
166    */
167   function approve(
168     address _approved,
169     uint256 _tokenId
170   )
171     external;
172 
173   /**
174    * @dev Enables or disables approval for a third party ("operator") to manage all of
175    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
176    * @notice The contract MUST allow multiple operators per owner.
177    * @param _operator Address to add to the set of authorized operators.
178    * @param _approved True if the operators is approved, false to revoke approval.
179    */
180   function setApprovalForAll(
181     address _operator,
182     bool _approved
183   )
184     external;
185 
186   /**
187    * @dev Get the approved address for a single NFT.
188    * @notice Throws if `_tokenId` is not a valid NFT.
189    * @param _tokenId The NFT to find the approved address for.
190    */
191   function getApproved(
192     uint256 _tokenId
193   )
194     external
195     view
196     returns (address);
197 
198   /**
199    * @dev Returns true if `_operator` is an approved operator for `_owner`, false otherwise.
200    * @param _owner The address that owns the NFTs.
201    * @param _operator The address that acts on behalf of the owner.
202    */
203   function isApprovedForAll(
204     address _owner,
205     address _operator
206   )
207     external
208     view
209     returns (bool);
210 
211 }
212 
213 /**
214  * @dev ERC-721 interface for accepting safe transfers. See https://goo.gl/pc9yoS.
215  */
216 interface ERC721TokenReceiver {
217 
218   /**
219    * @dev Handle the receipt of a NFT. The ERC721 smart contract calls this function on the
220    * recipient after a `transfer`. This function MAY throw to revert and reject the transfer. Return
221    * of other than the magic value MUST result in the transaction being reverted.
222    * Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))` unless throwing.
223    * @notice The contract address is always the message sender. A wallet/broker/auction application
224    * MUST implement the wallet interface if it will accept safe transfers.
225    * @param _operator The address which called `safeTransferFrom` function.
226    * @param _from The address which previously owned the token.
227    * @param _tokenId The NFT identifier which is being transferred.
228    * @param _data Additional data with no specified format.
229    */
230   function onERC721Received(
231     address _operator,
232     address _from,
233     uint256 _tokenId,
234     bytes _data
235   )
236     external
237     returns(bytes4);
238     
239 }
240 
241 /**
242  * @dev Math operations with safety checks that throw on error. This contract is based
243  * on the source code at https://goo.gl/iyQsmU.
244  */
245 library SafeMath {
246 
247   /**
248    * @dev Multiplies two numbers, throws on overflow.
249    * @param _a Factor number.
250    * @param _b Factor number.
251    */
252   function mul(
253     uint256 _a,
254     uint256 _b
255   )
256     internal
257     pure
258     returns (uint256)
259   {
260     if (_a == 0) {
261       return 0;
262     }
263     uint256 c = _a * _b;
264     assert(c / _a == _b);
265     return c;
266   }
267 
268   /**
269    * @dev Integer division of two numbers, truncating the quotient.
270    * @param _a Dividend number.
271    * @param _b Divisor number.
272    */
273   function div(
274     uint256 _a,
275     uint256 _b
276   )
277     internal
278     pure
279     returns (uint256)
280   {
281     uint256 c = _a / _b;
282     // assert(b > 0); // Solidity automatically throws when dividing by 0
283     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
284     return c;
285   }
286 
287   /**
288    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
289    * @param _a Minuend number.
290    * @param _b Subtrahend number.
291    */
292   function sub(
293     uint256 _a,
294     uint256 _b
295   )
296     internal
297     pure
298     returns (uint256)
299   {
300     assert(_b <= _a);
301     return _a - _b;
302   }
303 
304   /**
305    * @dev Adds two numbers, throws on overflow.
306    * @param _a Number.
307    * @param _b Number.
308    */
309   function add(
310     uint256 _a,
311     uint256 _b
312   )
313     internal
314     pure
315     returns (uint256)
316   {
317     uint256 c = _a + _b;
318     assert(c >= _a);
319     return c;
320   }
321 
322 }
323 
324 /**
325  * @dev Utility library of inline functions on addresses.
326  */
327 library AddressUtils {
328 
329   /**
330    * @dev Returns whether the target address is a contract.
331    * @param _addr Address to check.
332    */
333   function isContract(
334     address _addr
335   )
336     internal
337     view
338     returns (bool)
339   {
340     uint256 size;
341 
342     /**
343      * XXX Currently there is no better way to check if there is a contract in an address than to
344      * check the size of the code at that address.
345      * See https://ethereum.stackexchange.com/a/14016/36603 for more details about how this works.
346      * TODO: Check this again before the Serenity release, because all addresses will be
347      * contracts then.
348      */
349     assembly { size := extcodesize(_addr) } // solium-disable-line security/no-inline-assembly
350     return size > 0;
351   }
352 
353 }
354 
355 /**
356  * @dev A standard for detecting smart contract interfaces. See https://goo.gl/cxQCse.
357  */
358 interface ERC165 {
359 
360   /**
361    * @dev Checks if the smart contract includes a specific interface.
362    * @notice This function uses less than 30,000 gas.
363    * @param _interfaceID The interface identifier, as specified in ERC-165.
364    */
365   function supportsInterface(
366     bytes4 _interfaceID
367   )
368     external
369     view
370     returns (bool);
371 
372 }
373 
374 /**
375  * @dev Implementation of standard for detect smart contract interfaces.
376  */
377 contract SupportsInterface is
378   ERC165
379 {
380 
381   /**
382    * @dev Mapping of supported intefraces.
383    * @notice You must not set element 0xffffffff to true.
384    */
385   mapping(bytes4 => bool) internal supportedInterfaces;
386 
387   /**
388    * @dev Contract constructor.
389    */
390   constructor()
391     public
392   {
393     supportedInterfaces[0x01ffc9a7] = true; // ERC165
394   }
395 
396   /**
397    * @dev Function to check which interfaces are suported by this contract.
398    * @param _interfaceID Id of the interface.
399    */
400   function supportsInterface(
401     bytes4 _interfaceID
402   )
403     external
404     view
405     returns (bool)
406   {
407     return supportedInterfaces[_interfaceID];
408   }
409 
410 }
411 
412 /**
413  * @dev Implementation of ERC-721 non-fungible token standard.
414  */
415 contract NFToken is
416   ERC721,
417   SupportsInterface
418 {
419   using SafeMath for uint256;
420   using AddressUtils for address;
421 
422   /**
423    * @dev A mapping from NFT ID to the address that owns it.
424    */
425   mapping (uint256 => address) internal idToOwner;
426 
427   /**
428    * @dev Mapping from NFT ID to approved address.
429    */
430   mapping (uint256 => address) internal idToApprovals;
431 
432    /**
433    * @dev Mapping from owner address to count of his tokens.
434    */
435   mapping (address => uint256) internal ownerToNFTokenCount;
436 
437   /**
438    * @dev Mapping from owner address to mapping of operator addresses.
439    */
440   mapping (address => mapping (address => bool)) internal ownerToOperators;
441 
442   /**
443    * @dev Magic value of a smart contract that can recieve NFT.
444    * Equal to: bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")).
445    */
446   bytes4 constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
447 
448   /**
449    * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
450    * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
451    * number of NFTs may be created and assigned without emitting Transfer. At the time of any
452    * transfer, the approved address for that NFT (if any) is reset to none.
453    * @param _from Sender of NFT (if address is zero address it indicates token creation).
454    * @param _to Receiver of NFT (if address is zero address it indicates token destruction).
455    * @param _tokenId The NFT that got transfered.
456    */
457   event Transfer(
458     address indexed _from,
459     address indexed _to,
460     uint256 indexed _tokenId
461   );
462 
463   /**
464    * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
465    * address indicates there is no approved address. When a Transfer event emits, this also
466    * indicates that the approved address for that NFT (if any) is reset to none.
467    * @param _owner Owner of NFT.
468    * @param _approved Address that we are approving.
469    * @param _tokenId NFT which we are approving.
470    */
471   event Approval(
472     address indexed _owner,
473     address indexed _approved,
474     uint256 indexed _tokenId
475   );
476 
477   /**
478    * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
479    * all NFTs of the owner.
480    * @param _owner Owner of NFT.
481    * @param _operator Address to which we are setting operator rights.
482    * @param _approved Status of operator rights(true if operator rights are given and false if
483    * revoked).
484    */
485   event ApprovalForAll(
486     address indexed _owner,
487     address indexed _operator,
488     bool _approved
489   );
490 
491   /**
492    * @dev Guarantees that the msg.sender is an owner or operator of the given NFT.
493    * @param _tokenId ID of the NFT to validate.
494    */
495   modifier canOperate(
496     uint256 _tokenId
497   ) {
498     address tokenOwner = idToOwner[_tokenId];
499     require(tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender]);
500     _;
501   }
502 
503   /**
504    * @dev Guarantees that the msg.sender is allowed to transfer NFT.
505    * @param _tokenId ID of the NFT to transfer.
506    */
507   modifier canTransfer(
508     uint256 _tokenId
509   ) {
510     address tokenOwner = idToOwner[_tokenId];
511     require(
512       tokenOwner == msg.sender
513       || getApproved(_tokenId) == msg.sender
514       || ownerToOperators[tokenOwner][msg.sender]
515     );
516 
517     _;
518   }
519 
520   /**
521    * @dev Guarantees that _tokenId is a valid Token.
522    * @param _tokenId ID of the NFT to validate.
523    */
524   modifier validNFToken(
525     uint256 _tokenId
526   ) {
527     require(idToOwner[_tokenId] != address(0));
528     _;
529   }
530 
531   /**
532    * @dev Contract constructor.
533    */
534   constructor()
535     public
536   {
537     supportedInterfaces[0x80ac58cd] = true; // ERC721
538   }
539 
540   /**
541    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
542    * considered invalid, and this function throws for queries about the zero address.
543    * @param _owner Address for whom to query the balance.
544    */
545   function balanceOf(
546     address _owner
547   )
548     external
549     view
550     returns (uint256)
551   {
552     require(_owner != address(0));
553     return ownerToNFTokenCount[_owner];
554   }
555 
556   /**
557    * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered
558    * invalid, and queries about them do throw.
559    * @param _tokenId The identifier for an NFT.
560    */
561   function ownerOf(
562     uint256 _tokenId
563   )
564     external
565     view
566     returns (address _owner)
567   {
568     _owner = idToOwner[_tokenId];
569     require(_owner != address(0));
570   }
571 
572   /**
573    * @dev Transfers the ownership of an NFT from one address to another address.
574    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
575    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
576    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
577    * function checks if `_to` is a smart contract (code size > 0). If so, it calls `onERC721Received`
578    * on `_to` and throws if the return value is not `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
579    * @param _from The current owner of the NFT.
580    * @param _to The new owner.
581    * @param _tokenId The NFT to transfer.
582    * @param _data Additional data with no specified format, sent in call to `_to`.
583    */
584   function safeTransferFrom(
585     address _from,
586     address _to,
587     uint256 _tokenId,
588     bytes _data
589   )
590     external
591   {
592     _safeTransferFrom(_from, _to, _tokenId, _data);
593   }
594 
595   /**
596    * @dev Transfers the ownership of an NFT from one address to another address.
597    * @notice This works identically to the other function with an extra data parameter, except this
598    * function just sets data to ""
599    * @param _from The current owner of the NFT.
600    * @param _to The new owner.
601    * @param _tokenId The NFT to transfer.
602    */
603   function safeTransferFrom(
604     address _from,
605     address _to,
606     uint256 _tokenId
607   )
608     external
609   {
610     _safeTransferFrom(_from, _to, _tokenId, "");
611   }
612 
613   /**
614    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
615    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
616    * address. Throws if `_tokenId` is not a valid NFT.
617    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
618    * they maybe be permanently lost.
619    * @param _from The current owner of the NFT.
620    * @param _to The new owner.
621    * @param _tokenId The NFT to transfer.
622    */
623   function transferFrom(
624     address _from,
625     address _to,
626     uint256 _tokenId
627   )
628     external
629     canTransfer(_tokenId)
630     validNFToken(_tokenId)
631   {
632     address tokenOwner = idToOwner[_tokenId];
633     require(tokenOwner == _from);
634     require(_to != address(0));
635 
636     _transfer(_to, _tokenId);
637   }
638 
639   /**
640    * @dev Set or reaffirm the approved address for an NFT.
641    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
642    * the current NFT owner, or an authorized operator of the current owner.
643    * @param _approved Address to be approved for the given NFT ID.
644    * @param _tokenId ID of the token to be approved.
645    */
646   function approve(
647     address _approved,
648     uint256 _tokenId
649   )
650     external
651     canOperate(_tokenId)
652     validNFToken(_tokenId)
653   {
654     address tokenOwner = idToOwner[_tokenId];
655     require(_approved != tokenOwner);
656 
657     idToApprovals[_tokenId] = _approved;
658     emit Approval(tokenOwner, _approved, _tokenId);
659   }
660 
661   /**
662    * @dev Enables or disables approval for a third party ("operator") to manage all of
663    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
664    * @notice This works even if sender doesn't own any tokens at the time.
665    * @param _operator Address to add to the set of authorized operators.
666    * @param _approved True if the operators is approved, false to revoke approval.
667    */
668   function setApprovalForAll(
669     address _operator,
670     bool _approved
671   )
672     external
673   {
674     require(_operator != address(0));
675     ownerToOperators[msg.sender][_operator] = _approved;
676     emit ApprovalForAll(msg.sender, _operator, _approved);
677   }
678 
679   /**
680    * @dev Get the approved address for a single NFT.
681    * @notice Throws if `_tokenId` is not a valid NFT.
682    * @param _tokenId ID of the NFT to query the approval of.
683    */
684   function getApproved(
685     uint256 _tokenId
686   )
687     public
688     view
689     validNFToken(_tokenId)
690     returns (address)
691   {
692     return idToApprovals[_tokenId];
693   }
694 
695   /**
696    * @dev Checks if `_operator` is an approved operator for `_owner`.
697    * @param _owner The address that owns the NFTs.
698    * @param _operator The address that acts on behalf of the owner.
699    */
700   function isApprovedForAll(
701     address _owner,
702     address _operator
703   )
704     external
705     view
706     returns (bool)
707   {
708     require(_owner != address(0));
709     require(_operator != address(0));
710     return ownerToOperators[_owner][_operator];
711   }
712 
713   /**
714    * @dev Actually perform the safeTransferFrom.
715    * @param _from The current owner of the NFT.
716    * @param _to The new owner.
717    * @param _tokenId The NFT to transfer.
718    * @param _data Additional data with no specified format, sent in call to `_to`.
719    */
720   function _safeTransferFrom(
721     address _from,
722     address _to,
723     uint256 _tokenId,
724     bytes _data
725   )
726     internal
727     canTransfer(_tokenId)
728     validNFToken(_tokenId)
729   {
730     address tokenOwner = idToOwner[_tokenId];
731     require(tokenOwner == _from);
732     require(_to != address(0));
733 
734     _transfer(_to, _tokenId);
735 
736     if (_to.isContract()) {
737       bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
738       require(retval == MAGIC_ON_ERC721_RECEIVED);
739     }
740   }
741 
742   /**
743    * @dev Actually preforms the transfer.
744    * @notice Does NO checks.
745    * @param _to Address of a new owner.
746    * @param _tokenId The NFT that is being transferred.
747    */
748   function _transfer(
749     address _to,
750     uint256 _tokenId
751   )
752     private
753   {
754     address from = idToOwner[_tokenId];
755     clearApproval(_tokenId);
756 
757     removeNFToken(from, _tokenId);
758     addNFToken(_to, _tokenId);
759 
760     emit Transfer(from, _to, _tokenId);
761   }
762    
763   /**
764    * @dev Mints a new NFT.
765    * @notice This is a private function which should be called from user-implemented external
766    * mint function. Its purpose is to show and properly initialize data structures when using this
767    * implementation.
768    * @param _to The address that will own the minted NFT.
769    * @param _tokenId of the NFT to be minted by the msg.sender.
770    */
771   function _mint(
772     address _to,
773     uint256 _tokenId
774   )
775     internal
776   {
777     require(_to != address(0));
778     require(_tokenId != 0);
779     require(idToOwner[_tokenId] == address(0));
780 
781     addNFToken(_to, _tokenId);
782 
783     emit Transfer(address(0), _to, _tokenId);
784   }
785 
786   /**
787    * @dev Burns a NFT.
788    * @notice This is a private function which should be called from user-implemented external
789    * burn function. Its purpose is to show and properly initialize data structures when using this
790    * implementation.
791    * @param _owner Address of the NFT owner.
792    * @param _tokenId ID of the NFT to be burned.
793    */
794   function _burn(
795     address _owner,
796     uint256 _tokenId
797   )
798     validNFToken(_tokenId)
799     internal
800   {
801     clearApproval(_tokenId);
802     removeNFToken(_owner, _tokenId);
803     emit Transfer(_owner, address(0), _tokenId);
804   }
805 
806   /** 
807    * @dev Clears the current approval of a given NFT ID.
808    * @param _tokenId ID of the NFT to be transferred.
809    */
810   function clearApproval(
811     uint256 _tokenId
812   )
813     private
814   {
815     if(idToApprovals[_tokenId] != 0)
816     {
817       delete idToApprovals[_tokenId];
818     }
819   }
820 
821   /**
822    * @dev Removes a NFT from owner.
823    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
824    * @param _from Address from wich we want to remove the NFT.
825    * @param _tokenId Which NFT we want to remove.
826    */
827   function removeNFToken(
828     address _from,
829     uint256 _tokenId
830   )
831    internal
832   {
833     require(idToOwner[_tokenId] == _from);
834     assert(ownerToNFTokenCount[_from] > 0);
835     ownerToNFTokenCount[_from] = ownerToNFTokenCount[_from] - 1;
836     delete idToOwner[_tokenId];
837   }
838 
839   /**
840    * @dev Assignes a new NFT to owner.
841    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
842    * @param _to Address to wich we want to add the NFT.
843    * @param _tokenId Which NFT we want to add.
844    */
845   function addNFToken(
846     address _to,
847     uint256 _tokenId
848   )
849     internal
850   {
851     require(idToOwner[_tokenId] == address(0));
852 
853     idToOwner[_tokenId] = _to;
854     ownerToNFTokenCount[_to] = ownerToNFTokenCount[_to].add(1);
855   }
856 
857 }
858 
859 /**
860  * @dev Optional enumeration implementation for ERC-721 non-fungible token standard.
861  */
862 contract NFTokenEnumerable is
863   NFToken,
864   ERC721Enumerable
865 {
866 
867   /**
868    * @dev Array of all NFT IDs.
869    */
870   uint256[] internal tokens;
871 
872   /**
873    * @dev Mapping from token ID its index in global tokens array.
874    */
875   mapping(uint256 => uint256) internal idToIndex;
876 
877   /**
878    * @dev Mapping from owner to list of owned NFT IDs.
879    */
880   mapping(address => uint256[]) internal ownerToIds;
881 
882   /**
883    * @dev Mapping from NFT ID to its index in the owner tokens list.
884    */
885   mapping(uint256 => uint256) internal idToOwnerIndex;
886 
887   /**
888    * @dev Contract constructor.
889    */
890   constructor()
891     public
892   {
893     supportedInterfaces[0x780e9d63] = true; // ERC721Enumerable
894   }
895 
896   /**
897    * @dev Mints a new NFT.
898    * @notice This is a private function which should be called from user-implemented external
899    * mint function. Its purpose is to show and properly initialize data structures when using this
900    * implementation.
901    * @param _to The address that will own the minted NFT.
902    * @param _tokenId of the NFT to be minted by the msg.sender.
903    */
904   function _mint(
905     address _to,
906     uint256 _tokenId
907   )
908     internal
909   {
910     super._mint(_to, _tokenId);
911     uint256 length = tokens.push(_tokenId);
912     idToIndex[_tokenId] = length - 1;
913   }
914 
915   /**
916    * @dev Burns a NFT.
917    * @notice This is a private function which should be called from user-implemented external
918    * burn function. Its purpose is to show and properly initialize data structures when using this
919    * implementation.
920    * @param _owner Address of the NFT owner.
921    * @param _tokenId ID of the NFT to be burned.
922    */
923   function _burn(
924     address _owner,
925     uint256 _tokenId
926   )
927     internal
928   {
929     super._burn(_owner, _tokenId);
930     assert(tokens.length > 0);
931 
932     uint256 tokenIndex = idToIndex[_tokenId];
933     // Sanity check. This could be removed in the future.
934     assert(tokens[tokenIndex] == _tokenId);
935     uint256 lastTokenIndex = tokens.length - 1;
936     uint256 lastToken = tokens[lastTokenIndex];
937 
938     tokens[tokenIndex] = lastToken;
939 
940     tokens.length--;
941     // Consider adding a conditional check for the last token in order to save GAS.
942     idToIndex[lastToken] = tokenIndex;
943     idToIndex[_tokenId] = 0;
944   }
945 
946   /**
947    * @dev Removes a NFT from an address.
948    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
949    * @param _from Address from wich we want to remove the NFT.
950    * @param _tokenId Which NFT we want to remove.
951    */
952   function removeNFToken(
953     address _from,
954     uint256 _tokenId
955   )
956    internal
957   {
958     super.removeNFToken(_from, _tokenId);
959     assert(ownerToIds[_from].length > 0);
960 
961     uint256 tokenToRemoveIndex = idToOwnerIndex[_tokenId];
962     uint256 lastTokenIndex = ownerToIds[_from].length - 1;
963     uint256 lastToken = ownerToIds[_from][lastTokenIndex];
964 
965     ownerToIds[_from][tokenToRemoveIndex] = lastToken;
966 
967     ownerToIds[_from].length--;
968     // Consider adding a conditional check for the last token in order to save GAS.
969     idToOwnerIndex[lastToken] = tokenToRemoveIndex;
970     idToOwnerIndex[_tokenId] = 0;
971   }
972 
973   /**
974    * @dev Assignes a new NFT to an address.
975    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
976    * @param _to Address to wich we want to add the NFT.
977    * @param _tokenId Which NFT we want to add.
978    */
979   function addNFToken(
980     address _to,
981     uint256 _tokenId
982   )
983     internal
984   {
985     super.addNFToken(_to, _tokenId);
986 
987     uint256 length = ownerToIds[_to].push(_tokenId);
988     idToOwnerIndex[_tokenId] = length - 1;
989   }
990 
991   /**
992    * @dev Returns the count of all existing NFTokens.
993    */
994   function totalSupply()
995     external
996     view
997     returns (uint256)
998   {
999     return tokens.length;
1000   }
1001 
1002   /**
1003    * @dev Returns NFT ID by its index.
1004    * @param _index A counter less than `totalSupply()`.
1005    */
1006   function tokenByIndex(
1007     uint256 _index
1008   )
1009     external
1010     view
1011     returns (uint256)
1012   {
1013     require(_index < tokens.length);
1014     // Sanity check. This could be removed in the future.
1015     assert(idToIndex[tokens[_index]] == _index);
1016     return tokens[_index];
1017   }
1018 
1019   /**
1020    * @dev returns the n-th NFT ID from a list of owner's tokens.
1021    * @param _owner Token owner's address.
1022    * @param _index Index number representing n-th token in owner's list of tokens.
1023    */
1024   function tokenOfOwnerByIndex(
1025     address _owner,
1026     uint256 _index
1027   )
1028     external
1029     view
1030     returns (uint256)
1031   {
1032     require(_index < ownerToIds[_owner].length);
1033     return ownerToIds[_owner][_index];
1034   }
1035 
1036 }
1037 
1038 /**
1039  * @dev The contract has an owner address, and provides basic authorization control whitch
1040  * simplifies the implementation of user permissions. This contract is based on the source code
1041  * at https://goo.gl/n2ZGVt.
1042  */
1043 contract Ownable {
1044   address public owner;
1045 
1046   /**
1047    * @dev An event which is triggered when the owner is changed.
1048    * @param previousOwner The address of the previous owner.
1049    * @param newOwner The address of the new owner.
1050    */
1051   event OwnershipTransferred(
1052     address indexed previousOwner,
1053     address indexed newOwner
1054   );
1055 
1056   /**
1057    * @dev The constructor sets the original `owner` of the contract to the sender account.
1058    */
1059   constructor()
1060     public
1061   {
1062     owner = msg.sender;
1063   }
1064 
1065   /**
1066    * @dev Throws if called by any account other than the owner.
1067    */
1068   modifier onlyOwner() {
1069     require(msg.sender == owner);
1070     _;
1071   }
1072 
1073   /**
1074    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1075    * @param _newOwner The address to transfer ownership to.
1076    */
1077   function transferOwnership(
1078     address _newOwner
1079   )
1080     onlyOwner
1081     public
1082   {
1083     require(_newOwner != address(0));
1084     emit OwnershipTransferred(owner, _newOwner);
1085     owner = _newOwner;
1086   }
1087 
1088 }
1089 
1090 /**
1091  * @dev Optional metadata extension for ERC-721 non-fungible token standard.
1092  * See https://goo.gl/pc9yoS.
1093  */
1094 interface ERC721Metadata {
1095 
1096   /**
1097    * @dev Returns a descriptive name for a collection of NFTs in this contract.
1098    */
1099   function name()
1100     external
1101     view
1102     returns (string _name);
1103 
1104   /**
1105    * @dev Returns a abbreviated name for a collection of NFTs in this contract.
1106    */
1107   function symbol()
1108     external
1109     view
1110     returns (string _symbol);
1111 
1112   /**
1113    * @dev Returns a distinct Uniform Resource Identifier (URI) for a given asset. It Throws if
1114    * `_tokenId` is not a valid NFT. URIs are defined in RFC3986. The URI may point to a JSON file
1115    * that conforms to the "ERC721 Metadata JSON Schema".
1116    */
1117   function tokenURI(uint256 _tokenId)
1118     external
1119     view
1120     returns (string);
1121 
1122 }
1123 
1124 /**
1125  * @dev Optional metadata implementation for ERC-721 non-fungible token standard.
1126  */
1127 contract NFTokenMetadata is
1128   NFToken,
1129   ERC721Metadata
1130 {
1131 
1132   /**
1133    * @dev A descriptive name for a collection of NFTs.
1134    */
1135   string internal nftName;
1136 
1137   /**
1138    * @dev An abbreviated name for NFTokens.
1139    */
1140   string internal nftSymbol;
1141 
1142   /**
1143    * @dev Mapping from NFT ID to metadata uri.
1144    */
1145   mapping (uint256 => string) internal idToUri;
1146 
1147   /**
1148    * @dev Contract constructor.
1149    * @notice When implementing this contract don't forget to set nftName and nftSymbol.
1150    */
1151   constructor()
1152     public
1153   {
1154     supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
1155   }
1156 
1157   /**
1158    * @dev Burns a NFT.
1159    * @notice This is a internal function which should be called from user-implemented external
1160    * burn function. Its purpose is to show and properly initialize data structures when using this
1161    * implementation.
1162    * @param _owner Address of the NFT owner.
1163    * @param _tokenId ID of the NFT to be burned.
1164    */
1165   function _burn(
1166     address _owner,
1167     uint256 _tokenId
1168   )
1169     internal
1170   {
1171     super._burn(_owner, _tokenId);
1172 
1173     if (bytes(idToUri[_tokenId]).length != 0) {
1174       delete idToUri[_tokenId];
1175     }
1176   }
1177 
1178   /**
1179    * @dev Set a distinct URI (RFC 3986) for a given NFT ID.
1180    * @notice this is a internal function which should be called from user-implemented external
1181    * function. Its purpose is to show and properly initialize data structures when using this
1182    * implementation.
1183    * @param _tokenId Id for which we want uri.
1184    * @param _uri String representing RFC 3986 URI.
1185    */
1186   function _setTokenUri(uint256 _tokenId, string _uri ) validNFToken(_tokenId) internal {
1187     idToUri[_tokenId] = _uri;
1188   }
1189 
1190   /**
1191    * @dev Returns a descriptive name for a collection of NFTokens.
1192    */
1193   function name() external view returns (string _name) {
1194     _name = nftName;
1195   }
1196 
1197   /**
1198    * @dev Returns an abbreviated name for NFTokens.
1199    */
1200   function symbol() external view returns (string _symbol) {
1201     _symbol = nftSymbol;
1202   }
1203 
1204   /**
1205    * @dev A distinct URI (RFC 3986) for a given NFT.
1206    * @param _tokenId Id for which we want uri.
1207    */
1208   function tokenURI(uint256 _tokenId) validNFToken(_tokenId) external view returns (string) {
1209     return idToUri[_tokenId];
1210   }
1211 
1212 }
1213 
1214 /**
1215  * @dev This is an example contract implementation of NFToken with enumerable and metadata
1216  * extensions.
1217  */
1218 contract CryptoParrots is NFTokenEnumerable, NFTokenMetadata, Ownable {
1219 
1220   /**
1221    * @dev Contract constructor.
1222    */
1223   constructor() public {
1224     nftName = "CryptoParrots";
1225     nftSymbol = "CP";
1226   }
1227   
1228   /**
1229    * @dev Give a new NFT.
1230    * @param _to The address that will own the minted NFT.
1231    * @param _uri String representing RFC 3986 URI.
1232    */
1233   function giveMeAParrot(address _to, string _uri) external {
1234     uint256 tokenId = tokens.length + 1;
1235     super._mint(_to, tokenId);
1236     super._setTokenUri(tokenId, _uri);
1237   }
1238 
1239   /**
1240    * @dev Removes a NFT from owner.
1241    * @param _owner Address from wich we want to remove the NFT.
1242    * @param _tokenId Which NFT we want to remove.
1243    */
1244   function burn(address _owner, uint256 _tokenId) onlyOwner external {
1245     super._burn(_owner, _tokenId);
1246   }
1247 
1248 }