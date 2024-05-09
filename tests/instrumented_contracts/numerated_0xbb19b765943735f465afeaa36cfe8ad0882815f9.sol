1 pragma solidity 0.5.1;
2 
3 // File: src/contracts/tokens/erc721.sol
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
44    * @dev Transfers the ownership of an NFT from one address to another address.
45    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
46    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
47    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
48    * function checks if `_to` is a smart contract (code size > 0). If so, it calls `onERC721Received`
49    * on `_to` and throws if the return value is not `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
50    * @param _from The current owner of the NFT.
51    * @param _to The new owner.
52    * @param _tokenId The NFT to transfer.
53    * @param _data Additional data with no specified format, sent in call to `_to`.
54    */
55   function safeTransferFrom(
56     address _from,
57     address _to,
58     uint256 _tokenId,
59     bytes calldata _data
60   )
61     external;
62 
63   /**
64    * @dev Transfers the ownership of an NFT from one address to another address.
65    * @notice This works identically to the other function with an extra data parameter, except this
66    * function just sets data to ""
67    * @param _from The current owner of the NFT.
68    * @param _to The new owner.
69    * @param _tokenId The NFT to transfer.
70    */
71   function safeTransferFrom(
72     address _from,
73     address _to,
74     uint256 _tokenId
75   )
76     external;
77 
78   /**
79    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
80    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
81    * address. Throws if `_tokenId` is not a valid NFT.
82    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
83    * they mayb be permanently lost.
84    * @param _from The current owner of the NFT.
85    * @param _to The new owner.
86    * @param _tokenId The NFT to transfer.
87    */
88   function transferFrom(
89     address _from,
90     address _to,
91     uint256 _tokenId
92   )
93     external;
94 
95   /**
96    * @dev Set or reaffirm the approved address for an NFT.
97    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
98    * the current NFT owner, or an authorized operator of the current owner.
99    * @param _approved The new approved NFT controller.
100    * @param _tokenId The NFT to approve.
101    */
102   function approve(
103     address _approved,
104     uint256 _tokenId
105   )
106     external;
107 
108   /**
109    * @dev Enables or disables approval for a third party ("operator") to manage all of
110    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
111    * @notice The contract MUST allow multiple operators per owner.
112    * @param _operator Address to add to the set of authorized operators.
113    * @param _approved True if the operators is approved, false to revoke approval.
114    */
115   function setApprovalForAll(
116     address _operator,
117     bool _approved
118   )
119     external;
120 
121   /**
122    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
123    * considered invalid, and this function throws for queries about the zero address.
124    * @param _owner Address for whom to query the balance.
125    */
126   function balanceOf(
127     address _owner
128   )
129     external
130     view
131     returns (uint256);
132 
133   /**
134    * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered
135    * invalid, and queries about them do throw.
136    * @param _tokenId The identifier for an NFT.
137    */
138   function ownerOf(
139     uint256 _tokenId
140   )
141     external
142     view
143     returns (address);
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
172 // File: src/contracts/tokens/erc721-token-receiver.sol
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
195     bytes calldata _data
196   )
197     external
198     returns(bytes4);
199     
200 }
201 
202 // File: src/contracts/math/safe-math.sol
203 
204 /**
205  * @dev Math operations with safety checks that throw on error. This contract is based on the 
206  * source code at: 
207  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol.
208  */
209 library SafeMath {
210 
211   /**
212    * @dev Multiplies two numbers, reverts on overflow.
213    * @param _a Factor number.
214    * @param _b Factor number.
215    */
216   function mul(
217     uint256 _a,
218     uint256 _b
219   )
220     internal
221     pure
222     returns (uint256)
223   {
224     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
225     // benefit is lost if 'b' is also tested.
226     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
227     if (_a == 0) {
228       return 0;
229     }
230 
231     uint256 c = _a * _b;
232     require(c / _a == _b);
233 
234     return c;
235   }
236 
237   /**
238    * @dev Integer division of two numbers, truncating the quotient, reverts on division by zero.
239    * @param _a Dividend number.
240    * @param _b Divisor number.
241    */
242   function div(
243     uint256 _a,
244     uint256 _b
245   )
246     internal
247     pure
248     returns (uint256)
249   {
250     // Solidity only automatically asserts when dividing by 0
251     require(_b > 0);
252     uint256 c = _a / _b;
253     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
254 
255     return c;
256   }
257 
258   /**
259    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
260    * @param _a Minuend number.
261    * @param _b Subtrahend number.
262    */
263   function sub(
264     uint256 _a,
265     uint256 _b
266   )
267     internal
268     pure
269     returns (uint256)
270   {
271     require(_b <= _a);
272     uint256 c = _a - _b;
273 
274     return c;
275   }
276 
277   /**
278    * @dev Adds two numbers, reverts on overflow.
279    * @param _a Number.
280    * @param _b Number.
281    */
282   function add(
283     uint256 _a,
284     uint256 _b
285   )
286     internal
287     pure
288     returns (uint256)
289   {
290     uint256 c = _a + _b;
291     require(c >= _a);
292 
293     return c;
294   }
295 
296   /**
297     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
298     * reverts when dividing by zero.
299     * @param _a Number.
300     * @param _b Number.
301     */
302   function mod(
303     uint256 _a,
304     uint256 _b
305   )
306     internal
307     pure
308     returns (uint256) 
309   {
310     require(_b != 0);
311     return _a % _b;
312   }
313 
314 }
315 
316 // File: src/contracts/utils/erc165.sol
317 
318 /**
319  * @dev A standard for detecting smart contract interfaces. 
320  * See: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md.
321  */
322 interface ERC165 {
323 
324   /**
325    * @dev Checks if the smart contract includes a specific interface.
326    * @notice This function uses less than 30,000 gas.
327    * @param _interfaceID The interface identifier, as specified in ERC-165.
328    */
329   function supportsInterface(
330     bytes4 _interfaceID
331   )
332     external
333     view
334     returns (bool);
335     
336 }
337 
338 // File: src/contracts/utils/supports-interface.sol
339 
340 /**
341  * @dev Implementation of standard for detect smart contract interfaces.
342  */
343 contract SupportsInterface is
344   ERC165
345 {
346 
347   /**
348    * @dev Mapping of supported intefraces.
349    * @notice You must not set element 0xffffffff to true.
350    */
351   mapping(bytes4 => bool) internal supportedInterfaces;
352 
353   /**
354    * @dev Contract constructor.
355    */
356   constructor()
357     public 
358   {
359     supportedInterfaces[0x01ffc9a7] = true; // ERC165
360   }
361 
362   /**
363    * @dev Function to check which interfaces are suported by this contract.
364    * @param _interfaceID Id of the interface.
365    */
366   function supportsInterface(
367     bytes4 _interfaceID
368   )
369     external
370     view
371     returns (bool)
372   {
373     return supportedInterfaces[_interfaceID];
374   }
375 
376 }
377 
378 // File: src/contracts/utils/address-utils.sol
379 
380 /**
381  * @dev Utility library of inline functions on addresses.
382  */
383 library AddressUtils {
384 
385   /**
386    * @dev Returns whether the target address is a contract.
387    * @param _addr Address to check.
388    */
389   function isContract(
390     address _addr
391   )
392     internal
393     view
394     returns (bool)
395   {
396 
397     uint256 size;
398 
399     /**
400      * XXX Currently there is no better way to check if there is a contract in an address than to
401      * check the size of the code at that address.
402      * See https://ethereum.stackexchange.com/a/14016/36603 for more details about how this works.
403      * TODO: Check this again before the Serenity release, because all addresses will be
404      * contracts then.
405      */
406     assembly { size := extcodesize(_addr) } // solhint-disable-line
407     return size > 0;
408   }
409 
410 }
411 
412 // File: src/contracts/tokens/nf-token.sol
413 
414 /**
415  * @dev Implementation of ERC-721 non-fungible token standard.
416  */
417 contract NFToken is
418   ERC721,
419   SupportsInterface
420 {
421   using SafeMath for uint256;
422   using AddressUtils for address;
423 
424   /**
425    * @dev A mapping from NFT ID to the address that owns it.
426    */
427   mapping (uint256 => address) internal idToOwner;
428 
429   /**
430    * @dev Mapping from NFT ID to approved address.
431    */
432   mapping (uint256 => address) internal idToApprovals;
433 
434    /**
435    * @dev Mapping from owner address to count of his tokens.
436    */
437   mapping (address => uint256) private ownerToNFTokenCount;
438 
439   /**
440    * @dev Mapping from owner address to mapping of operator addresses.
441    */
442   mapping (address => mapping (address => bool)) internal ownerToOperators;
443 
444   /**
445    * @dev Magic value of a smart contract that can recieve NFT.
446    * Equal to: bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")).
447    */
448   bytes4 private constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
449 
450   /**
451    * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
452    * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
453    * number of NFTs may be created and assigned without emitting Transfer. At the time of any
454    * transfer, the approved address for that NFT (if any) is reset to none.
455    * @param _from Sender of NFT (if address is zero address it indicates token creation).
456    * @param _to Receiver of NFT (if address is zero address it indicates token destruction).
457    * @param _tokenId The NFT that got transfered.
458    */
459   event Transfer(
460     address indexed _from,
461     address indexed _to,
462     uint256 indexed _tokenId
463   );
464 
465   /**
466    * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
467    * address indicates there is no approved address. When a Transfer event emits, this also
468    * indicates that the approved address for that NFT (if any) is reset to none.
469    * @param _owner Owner of NFT.
470    * @param _approved Address that we are approving.
471    * @param _tokenId NFT which we are approving.
472    */
473   event Approval(
474     address indexed _owner,
475     address indexed _approved,
476       uint256 indexed _tokenId
477   );
478 
479   /**
480    * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
481    * all NFTs of the owner.
482    * @param _owner Owner of NFT.
483    * @param _operator Address to which we are setting operator rights.
484    * @param _approved Status of operator rights(true if operator rights are given and false if
485    * revoked).
486    */
487   event ApprovalForAll(
488     address indexed _owner,
489     address indexed _operator,
490     bool _approved
491   );
492 
493   /**
494    * @dev Guarantees that the msg.sender is an owner or operator of the given NFT.
495    * @param _tokenId ID of the NFT to validate.
496    */
497   modifier canOperate(
498     uint256 _tokenId
499   ) 
500   {
501     address tokenOwner = idToOwner[_tokenId];
502     require(tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender]);
503     _;
504   }
505 
506   /**
507    * @dev Guarantees that the msg.sender is allowed to transfer NFT.
508    * @param _tokenId ID of the NFT to transfer.
509    */
510   modifier canTransfer(
511     uint256 _tokenId
512   ) {
513     address tokenOwner = idToOwner[_tokenId];
514     require(
515       tokenOwner == msg.sender
516       || idToApprovals[_tokenId] == msg.sender
517       || ownerToOperators[tokenOwner][msg.sender]
518     );
519     _;
520   }
521 
522   /**
523    * @dev Guarantees that _tokenId is a valid Token.
524    * @param _tokenId ID of the NFT to validate.
525    */
526   modifier validNFToken(
527     uint256 _tokenId
528   ) {
529     require(idToOwner[_tokenId] != address(0));
530     _;
531   }
532 
533   /**
534    * @dev Contract constructor.
535    */
536   constructor()
537     public
538   {
539     supportedInterfaces[0x80ac58cd] = true; // ERC721
540   }
541 
542   /**
543    * @dev Transfers the ownership of an NFT from one address to another address. This function can
544    * be changed to payable.
545    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
546    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
547    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
548    * function checks if `_to` is a smart contract (code size > 0). If so, it calls 
549    * `onERC721Received` on `_to` and throws if the return value is not 
550    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
551    * @param _from The current owner of the NFT.
552    * @param _to The new owner.
553    * @param _tokenId The NFT to transfer.
554    * @param _data Additional data with no specified format, sent in call to `_to`.
555    */
556   function safeTransferFrom(
557     address _from,
558     address _to,
559     uint256 _tokenId,
560     bytes calldata _data
561   )
562     external
563   {
564     _safeTransferFrom(_from, _to, _tokenId, _data);
565   }
566 
567   /**
568    * @dev Transfers the ownership of an NFT from one address to another address. This function can
569    * be changed to payable.
570    * @notice This works identically to the other function with an extra data parameter, except this
571    * function just sets data to ""
572    * @param _from The current owner of the NFT.
573    * @param _to The new owner.
574    * @param _tokenId The NFT to transfer.
575    */
576   function safeTransferFrom(
577     address _from,
578     address _to,
579     uint256 _tokenId
580   )
581     external
582   {
583     _safeTransferFrom(_from, _to, _tokenId, "");
584   }
585 
586   /**
587    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
588    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
589    * address. Throws if `_tokenId` is not a valid NFT. This function can be changed to payable.
590    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
591    * they maybe be permanently lost.
592    * @param _from The current owner of the NFT.
593    * @param _to The new owner.
594    * @param _tokenId The NFT to transfer.
595    */
596   function transferFrom(
597     address _from,
598     address _to,
599     uint256 _tokenId
600   )
601     external
602     canTransfer(_tokenId)
603     validNFToken(_tokenId)
604   {
605     address tokenOwner = idToOwner[_tokenId];
606     require(tokenOwner == _from);
607     require(_to != address(0));
608 
609     _transfer(_to, _tokenId);
610   }
611 
612   /**
613    * @dev Set or reaffirm the approved address for an NFT. This function can be changed to payable.
614    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
615    * the current NFT owner, or an authorized operator of the current owner.
616    * @param _approved Address to be approved for the given NFT ID.
617    * @param _tokenId ID of the token to be approved.
618    */
619   function approve(
620     address _approved,
621     uint256 _tokenId
622   )
623     external
624     canOperate(_tokenId)
625     validNFToken(_tokenId)
626   {
627     address tokenOwner = idToOwner[_tokenId];
628     require(_approved != tokenOwner);
629 
630     idToApprovals[_tokenId] = _approved;
631     emit Approval(tokenOwner, _approved, _tokenId);
632   }
633 
634   /**
635    * @dev Enables or disables approval for a third party ("operator") to manage all of
636    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
637    * @notice This works even if sender doesn't own any tokens at the time.
638    * @param _operator Address to add to the set of authorized operators.
639    * @param _approved True if the operators is approved, false to revoke approval.
640    */
641   function setApprovalForAll(
642     address _operator,
643     bool _approved
644   )
645     external
646   {
647     ownerToOperators[msg.sender][_operator] = _approved;
648     emit ApprovalForAll(msg.sender, _operator, _approved);
649   }
650 
651   /**
652    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
653    * considered invalid, and this function throws for queries about the zero address.
654    * @param _owner Address for whom to query the balance.
655    */
656   function balanceOf(
657     address _owner
658   )
659     external
660     view
661     returns (uint256)
662   {
663     require(_owner != address(0));
664     return getOwnerNFTCount(_owner);
665   }
666 
667   /**
668    * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered
669    * invalid, and queries about them do throw.
670    * @param _tokenId The identifier for an NFT.
671    */
672   function ownerOf(
673     uint256 _tokenId
674   )
675     external
676     view
677     returns (address _owner)
678   {
679     _owner = idToOwner[_tokenId];
680     require(_owner != address(0));
681   }
682 
683   /**
684    * @dev Get the approved address for a single NFT.
685    * @notice Throws if `_tokenId` is not a valid NFT.
686    * @param _tokenId ID of the NFT to query the approval of.
687    */
688   function getApproved(
689     uint256 _tokenId
690   )
691     external
692     view
693     validNFToken(_tokenId)
694     returns (address)
695   {
696     return idToApprovals[_tokenId];
697   }
698 
699   /**
700    * @dev Checks if `_operator` is an approved operator for `_owner`.
701    * @param _owner The address that owns the NFTs.
702    * @param _operator The address that acts on behalf of the owner.
703    */
704   function isApprovedForAll(
705     address _owner,
706     address _operator
707   )
708     external
709     view
710     returns (bool)
711   {
712     return ownerToOperators[_owner][_operator];
713   }
714 
715   /**
716    * @dev Actually preforms the transfer.
717    * @notice Does NO checks.
718    * @param _to Address of a new owner.
719    * @param _tokenId The NFT that is being transferred.
720    */
721   function _transfer(
722     address _to,
723     uint256 _tokenId
724   )
725     internal
726   {
727     address from = idToOwner[_tokenId];
728     clearApproval(_tokenId);
729 
730     removeNFToken(from, _tokenId);
731     addNFToken(_to, _tokenId);
732 
733     emit Transfer(from, _to, _tokenId);
734   }
735    
736   /**
737    * @dev Mints a new NFT.
738    * @notice This is a private function which should be called from user-implemented external
739    * mint function. Its purpose is to show and properly initialize data structures when using this
740    * implementation.
741    * @param _to The address that will own the minted NFT.
742    * @param _tokenId of the NFT to be minted by the msg.sender.
743    */
744   function _mint(
745     address _to,
746     uint256 _tokenId
747   )
748     internal
749   {
750     require(_to != address(0));
751     require(idToOwner[_tokenId] == address(0));
752 
753     addNFToken(_to, _tokenId);
754 
755     emit Transfer(address(0), _to, _tokenId);
756   }
757 
758   /**
759    * @dev Burns a NFT.
760    * @notice This is a private function which should be called from user-implemented external
761    * burn function. Its purpose is to show and properly initialize data structures when using this
762    * implementation.
763    * @param _tokenId ID of the NFT to be burned.
764    */
765   function _burn(
766     uint256 _tokenId
767   )
768     internal
769     validNFToken(_tokenId)
770   {
771     address tokenOwner = idToOwner[_tokenId];
772     clearApproval(_tokenId);
773     removeNFToken(tokenOwner, _tokenId);
774     emit Transfer(tokenOwner, address(0), _tokenId);
775   }
776 
777   /**
778    * @dev Removes a NFT from owner.
779    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
780    * @param _from Address from wich we want to remove the NFT.
781    * @param _tokenId Which NFT we want to remove.
782    */
783   function removeNFToken(
784     address _from,
785     uint256 _tokenId
786   )
787     internal
788   {
789     require(idToOwner[_tokenId] == _from);
790     assert(ownerToNFTokenCount[_from] > 0);
791     ownerToNFTokenCount[_from] = ownerToNFTokenCount[_from] - 1;
792     delete idToOwner[_tokenId];
793   }
794 
795   /**
796    * @dev Assignes a new NFT to owner.
797    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
798    * @param _to Address to wich we want to add the NFT.
799    * @param _tokenId Which NFT we want to add.
800    */
801   function addNFToken(
802     address _to,
803     uint256 _tokenId
804   )
805     internal
806   {
807     require(idToOwner[_tokenId] == address(0));
808 
809     idToOwner[_tokenId] = _to;
810     ownerToNFTokenCount[_to] = ownerToNFTokenCount[_to].add(1);
811   }
812 
813   /**
814    * @dev Helper function that gets NFT count of owner. This is needed for overriding in enumerable
815    * extension to remove double storage (gas optimization) of owner nft count.
816    * @param _owner Address for whom to query the count.
817    */
818   function getOwnerNFTCount(
819     address _owner
820   )
821     internal
822     view
823     returns (uint256)
824   {
825     return ownerToNFTokenCount[_owner];
826   }
827 
828   /**
829    * @dev Actually perform the safeTransferFrom.
830    * @param _from The current owner of the NFT.
831    * @param _to The new owner.
832    * @param _tokenId The NFT to transfer.
833    * @param _data Additional data with no specified format, sent in call to `_to`.
834    */
835   function _safeTransferFrom(
836     address _from,
837     address _to,
838     uint256 _tokenId,
839     bytes memory _data
840   )
841     private
842     canTransfer(_tokenId)
843     validNFToken(_tokenId)
844   {
845     address tokenOwner = idToOwner[_tokenId];
846     require(tokenOwner == _from);
847     require(_to != address(0));
848 
849     _transfer(_to, _tokenId);
850 
851     if (_to.isContract()) {
852       bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
853       require(retval == MAGIC_ON_ERC721_RECEIVED);
854     }
855   }
856 
857   /** 
858    * @dev Clears the current approval of a given NFT ID.
859    * @param _tokenId ID of the NFT to be transferred.
860    */
861   function clearApproval(
862     uint256 _tokenId
863   )
864     private
865   {
866     if (idToApprovals[_tokenId] != address(0))
867     {
868       delete idToApprovals[_tokenId];
869     }
870   }
871 
872 }
873 
874 // File: src/contracts/tokens/erc721-enumerable.sol
875 
876 /**
877  * @dev Optional enumeration extension for ERC-721 non-fungible token standard.
878  * See https://goo.gl/pc9yoS.
879  */
880 interface ERC721Enumerable {
881 
882   /**
883    * @dev Returns a count of valid NFTs tracked by this contract, where each one of them has an
884    * assigned and queryable owner not equal to the zero address.
885    */
886   function totalSupply()
887     external
888     view
889     returns (uint256);
890 
891   /**
892    * @dev Returns the token identifier for the `_index`th NFT. Sort order is not specified.
893    * @param _index A counter less than `totalSupply()`.
894    */
895   function tokenByIndex(
896     uint256 _index
897   )
898     external
899     view
900     returns (uint256);
901 
902   /**
903    * @dev Returns the token identifier for the `_index`th NFT assigned to `_owner`. Sort order is
904    * not specified. It throws if `_index` >= `balanceOf(_owner)` or if `_owner` is the zero address,
905    * representing invalid NFTs.
906    * @param _owner An address where we are interested in NFTs owned by them.
907    * @param _index A counter less than `balanceOf(_owner)`.
908    */
909   function tokenOfOwnerByIndex(
910     address _owner,
911     uint256 _index
912   )
913     external
914     view
915     returns (uint256);
916 
917 }
918 
919 // File: src/contracts/tokens/nf-token-enumerable.sol
920 
921 /**
922  * @dev Optional enumeration implementation for ERC-721 non-fungible token standard.
923  */
924 contract NFTokenEnumerable is
925   NFToken,
926   ERC721Enumerable
927 {
928 
929   /**
930    * @dev Array of all NFT IDs.
931    */
932   uint256[] internal tokens;
933 
934   /**
935    * @dev Mapping from token ID its index in global tokens array.
936    */
937   mapping(uint256 => uint256) internal idToIndex;
938 
939   /**
940    * @dev Mapping from owner to list of owned NFT IDs.
941    */
942   mapping(address => uint256[]) internal ownerToIds;
943 
944   /**
945    * @dev Mapping from NFT ID to its index in the owner tokens list.
946    */
947   mapping(uint256 => uint256) internal idToOwnerIndex;
948 
949   /**
950    * @dev Contract constructor.
951    */
952   constructor()
953     public
954   {
955     supportedInterfaces[0x780e9d63] = true; // ERC721Enumerable
956   }
957 
958   /**
959    * @dev Returns the count of all existing NFTokens.
960    */
961   function totalSupply()
962     external
963     view
964     returns (uint256)
965   {
966     return tokens.length;
967   }
968 
969   /**
970    * @dev Returns NFT ID by its index.
971    * @param _index A counter less than `totalSupply()`.
972    */
973   function tokenByIndex(
974     uint256 _index
975   )
976     external
977     view
978     returns (uint256)
979   {
980     require(_index < tokens.length);
981     // Sanity check. This could be removed in the future.
982     assert(idToIndex[tokens[_index]] == _index);
983     return tokens[_index];
984   }
985 
986   /**
987    * @dev returns the n-th NFT ID from a list of owner's tokens.
988    * @param _owner Token owner's address.
989    * @param _index Index number representing n-th token in owner's list of tokens.
990    */
991   function tokenOfOwnerByIndex(
992     address _owner,
993     uint256 _index
994   )
995     external
996     view
997     returns (uint256)
998   {
999     require(_index < ownerToIds[_owner].length);
1000     return ownerToIds[_owner][_index];
1001   }
1002 
1003   /**
1004    * @dev Mints a new NFT.
1005    * @notice This is a private function which should be called from user-implemented external
1006    * mint function. Its purpose is to show and properly initialize data structures when using this
1007    * implementation.
1008    * @param _to The address that will own the minted NFT.
1009    * @param _tokenId of the NFT to be minted by the msg.sender.
1010    */
1011   function _mint(
1012     address _to,
1013     uint256 _tokenId
1014   )
1015     internal
1016   {
1017     super._mint(_to, _tokenId);
1018     uint256 length = tokens.push(_tokenId);
1019     idToIndex[_tokenId] = length - 1;
1020   }
1021 
1022   /**
1023    * @dev Burns a NFT.
1024    * @notice This is a private function which should be called from user-implemented external
1025    * burn function. Its purpose is to show and properly initialize data structures when using this
1026    * implementation.
1027    * @param _tokenId ID of the NFT to be burned.
1028    */
1029   function _burn(
1030     uint256 _tokenId
1031   )
1032     internal
1033   {
1034     super._burn(_tokenId);
1035     assert(tokens.length > 0);
1036 
1037     uint256 tokenIndex = idToIndex[_tokenId];
1038     // Sanity check. This could be removed in the future.
1039     assert(tokens[tokenIndex] == _tokenId);
1040     uint256 lastTokenIndex = tokens.length - 1;
1041     uint256 lastToken = tokens[lastTokenIndex];
1042 
1043     tokens[tokenIndex] = lastToken;
1044 
1045     tokens.length--;
1046     // This wastes gas if you are burning the last token but saves a little gas if you are not. 
1047     idToIndex[lastToken] = tokenIndex;
1048     idToIndex[_tokenId] = 0;
1049   }
1050 
1051   /**
1052    * @dev Removes a NFT from an address.
1053    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
1054    * @param _from Address from wich we want to remove the NFT.
1055    * @param _tokenId Which NFT we want to remove.
1056    */
1057   function removeNFToken(
1058     address _from,
1059     uint256 _tokenId
1060   )
1061     internal
1062   {
1063     require(idToOwner[_tokenId] == _from);
1064     delete idToOwner[_tokenId];
1065     assert(ownerToIds[_from].length > 0);
1066 
1067     uint256 tokenToRemoveIndex = idToOwnerIndex[_tokenId];
1068     uint256 lastTokenIndex = ownerToIds[_from].length - 1;
1069 
1070     if (lastTokenIndex != tokenToRemoveIndex)
1071     {
1072       uint256 lastToken = ownerToIds[_from][lastTokenIndex];
1073       ownerToIds[_from][tokenToRemoveIndex] = lastToken;
1074       idToOwnerIndex[lastToken] = tokenToRemoveIndex;
1075     }
1076 
1077     ownerToIds[_from].length--;
1078   }
1079 
1080   /**
1081    * @dev Assignes a new NFT to an address.
1082    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
1083    * @param _to Address to wich we want to add the NFT.
1084    * @param _tokenId Which NFT we want to add.
1085    */
1086   function addNFToken(
1087     address _to,
1088     uint256 _tokenId
1089   )
1090     internal
1091   {
1092     require(idToOwner[_tokenId] == address(0));
1093     idToOwner[_tokenId] = _to;
1094 
1095     uint256 length = ownerToIds[_to].push(_tokenId);
1096     idToOwnerIndex[_tokenId] = length - 1;
1097   }
1098 
1099   /**
1100    * @dev Helper function that gets NFT count of owner. This is needed for overriding in enumerable
1101    * extension to remove double storage(gas optimization) of owner nft count.
1102    * @param _owner Address for whom to query the count.
1103    */
1104   function getOwnerNFTCount(
1105     address _owner
1106   )
1107     internal
1108     view
1109     returns (uint256)
1110   {
1111     return ownerToIds[_owner].length;
1112   }
1113 }
1114 
1115 // File: src/contracts/ownership/ownable.sol
1116 
1117 /**
1118  * @dev The contract has an owner address, and provides basic authorization control whitch
1119  * simplifies the implementation of user permissions. This contract is based on the source code at:
1120  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
1121  */
1122 contract Ownable {
1123   
1124   /**
1125    * @dev Error constants.
1126    */
1127   string public constant NOT_OWNER = "018001";
1128   string public constant ZERO_ADDRESS = "018002";
1129 
1130   address public owner;
1131 
1132   /**
1133    * @dev An event which is triggered when the owner is changed.
1134    * @param previousOwner The address of the previous owner.
1135    * @param newOwner The address of the new owner.
1136    */
1137   event OwnershipTransferred(
1138     address indexed previousOwner,
1139     address indexed newOwner
1140   );
1141 
1142   /**
1143    * @dev The constructor sets the original `owner` of the contract to the sender account.
1144    */
1145   constructor()
1146     public
1147   {
1148     owner = msg.sender;
1149   }
1150 
1151   /**
1152    * @dev Throws if called by any account other than the owner.
1153    */
1154   modifier onlyOwner() {
1155     require(msg.sender == owner, NOT_OWNER);
1156     _;
1157   }
1158 
1159   /**
1160    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1161    * @param _newOwner The address to transfer ownership to.
1162    */
1163   function transferOwnership(
1164     address _newOwner
1165   )
1166     public
1167     onlyOwner
1168   {
1169     require(_newOwner != address(0), ZERO_ADDRESS);
1170     emit OwnershipTransferred(owner, _newOwner);
1171     owner = _newOwner;
1172   }
1173 
1174 }
1175 
1176 // File: src/contracts/mocks/nf-token-enumerable-mock.sol
1177 
1178 /**
1179  * @dev This is an example contract implementation of NFToken with enumerable extension.
1180  */
1181 contract NFTokenEnumerableMock is
1182   NFTokenEnumerable,
1183   Ownable
1184 {
1185 
1186   /**
1187    * @dev Mints a new NFT.
1188    * @param _to The address that will own the minted NFT.
1189    * @param _tokenId of the NFT to be minted by the msg.sender.
1190    */
1191   function mint(
1192     address _to,
1193     uint256 _tokenId
1194   )
1195     external
1196     onlyOwner
1197   {
1198     super._mint(_to, _tokenId);
1199   }
1200 
1201   /**
1202    * @dev Removes a NFT from owner.
1203    * @param _tokenId Which NFT we want to remove.
1204    */
1205   function burn(
1206     uint256 _tokenId
1207   )
1208     external
1209     onlyOwner
1210   {
1211     super._burn(_tokenId);
1212   }
1213 
1214 }
1215 
1216 // File: src/contracts/tokens/erc721-metadata.sol
1217 
1218 /**
1219  * @dev Optional metadata extension for ERC-721 non-fungible token standard.
1220  * See https://goo.gl/pc9yoS.
1221  */
1222 interface ERC721Metadata {
1223 
1224   /**
1225    * @dev Returns a descriptive name for a collection of NFTs in this contract.
1226    */
1227   function name()
1228     external
1229     view
1230     returns (string memory _name);
1231 
1232   /**
1233    * @dev Returns a abbreviated name for a collection of NFTs in this contract.
1234    */
1235   function symbol()
1236     external
1237     view
1238     returns (string memory _symbol);
1239 
1240   /**
1241    * @dev Returns a distinct Uniform Resource Identifier (URI) for a given asset. It Throws if
1242    * `_tokenId` is not a valid NFT. URIs are defined in RFC3986. The URI may point to a JSON file
1243    * that conforms to the "ERC721 Metadata JSON Schema".
1244    */
1245   function tokenURI(uint256 _tokenId)
1246     external
1247     view
1248     returns (string memory);
1249 
1250 }
1251 
1252 // File: src/contracts/tokens/nf-token-metadata.sol
1253 
1254 /**
1255  * @dev Optional metadata implementation for ERC-721 non-fungible token standard.
1256  */
1257 contract NFTokenMetadata is
1258   NFToken,
1259   ERC721Metadata
1260 {
1261 
1262   /**
1263    * @dev A descriptive name for a collection of NFTs.
1264    */
1265   string internal nftName;
1266 
1267   /**
1268    * @dev An abbreviated name for NFTokens.
1269    */
1270   string internal nftSymbol;
1271 
1272   /**
1273    * @dev Mapping from NFT ID to metadata uri.
1274    */
1275   mapping (uint256 => string) internal idToUri;
1276 
1277   /**
1278    * @dev Contract constructor.
1279    * @notice When implementing this contract don't forget to set nftName and nftSymbol.
1280    */
1281   constructor()
1282     public
1283   {
1284     supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
1285   }
1286 
1287   /**
1288    * @dev Returns a descriptive name for a collection of NFTokens.
1289    */
1290   function name()
1291     external
1292     view
1293     returns (string memory _name)
1294   {
1295     _name = nftName;
1296   }
1297 
1298   /**
1299    * @dev Returns an abbreviated name for NFTokens.
1300    */
1301   function symbol()
1302     external
1303     view
1304     returns (string memory _symbol)
1305   {
1306     _symbol = nftSymbol;
1307   }
1308 
1309   /**
1310    * @dev A distinct URI (RFC 3986) for a given NFT.
1311    * @param _tokenId Id for which we want uri.
1312    */
1313   function tokenURI(
1314     uint256 _tokenId
1315   )
1316     external
1317     view
1318     validNFToken(_tokenId)
1319     returns (string memory)
1320   {
1321     return idToUri[_tokenId];
1322   }
1323 
1324   /**
1325    * @dev Burns a NFT.
1326    * @notice This is a internal function which should be called from user-implemented external
1327    * burn function. Its purpose is to show and properly initialize data structures when using this
1328    * implementation.
1329    * @param _tokenId ID of the NFT to be burned.
1330    */
1331   function _burn(
1332     uint256 _tokenId
1333   )
1334     internal
1335   {
1336     super._burn(_tokenId);
1337 
1338     if (bytes(idToUri[_tokenId]).length != 0) {
1339       delete idToUri[_tokenId];
1340     }
1341   }
1342 
1343   /**
1344    * @dev Set a distinct URI (RFC 3986) for a given NFT ID.
1345    * @notice this is a internal function which should be called from user-implemented external
1346    * function. Its purpose is to show and properly initialize data structures when using this
1347    * implementation.
1348    * @param _tokenId Id for which we want uri.
1349    * @param _uri String representing RFC 3986 URI.
1350    */
1351   function _setTokenUri(
1352     uint256 _tokenId,
1353     string memory _uri
1354   )
1355     internal
1356     validNFToken(_tokenId)
1357   {
1358     idToUri[_tokenId] = _uri;
1359   }
1360 
1361 }
1362 
1363 // File: src/contracts/mocks/nf-token-metadata-enumerable-mock.sol
1364 
1365 /**
1366  * @dev This is an example contract implementation of NFToken with enumerable and metadata
1367  * extensions.
1368  */
1369 contract NFTokenMetadataEnumerableMock is
1370   NFTokenEnumerable,
1371   NFTokenMetadata,
1372   Ownable
1373 {
1374 
1375   /**
1376    * @dev Contract constructor.
1377    * @param _name A descriptive name for a collection of NFTs.
1378    * @param _symbol An abbreviated name for NFTokens.
1379    */
1380   constructor(
1381     string memory _name,
1382     string memory _symbol
1383   )
1384     public
1385   {
1386     nftName = _name;
1387     nftSymbol = _symbol;
1388   }
1389 
1390   /**
1391    * @dev Mints a new NFT.
1392    * @param _to The address that will own the minted NFT.
1393    * @param _tokenId of the NFT to be minted by the msg.sender.
1394    * @param _uri String representing RFC 3986 URI.
1395    */
1396   function mint(
1397     address _to,
1398     uint256 _tokenId,
1399     string calldata _uri
1400   )
1401     external
1402     onlyOwner
1403   {
1404     super._mint(_to, _tokenId);
1405     super._setTokenUri(_tokenId, _uri);
1406   }
1407 
1408   /**
1409    * @dev Removes a NFT from owner.
1410    * @param _tokenId Which NFT we want to remove.
1411    */
1412   function burn(
1413     uint256 _tokenId
1414   )
1415     external
1416     onlyOwner
1417   {
1418     super._burn(_tokenId);
1419   }
1420 
1421 }
1422 
1423 // File: src/contracts/mocks/nf-token-metadata-mock.sol
1424 
1425 /**
1426  * @dev This is an example contract implementation of NFToken with metadata extension.
1427  */
1428 contract NFTokenMetadataMock is
1429   NFTokenMetadata,
1430   Ownable
1431 {
1432 
1433   /**
1434    * @dev Contract constructor.
1435    * @param _name A descriptive name for a collection of NFTs.
1436    * @param _symbol An abbreviated name for NFTokens.
1437    */
1438   constructor(
1439     string memory _name,
1440     string memory _symbol
1441   )
1442     public
1443   {
1444     nftName = _name;
1445     nftSymbol = _symbol;
1446   }
1447 
1448   /**
1449    * @dev Mints a new NFT.
1450    * @param _to The address that will own the minted NFT.
1451    * @param _tokenId of the NFT to be minted by the msg.sender.
1452    * @param _uri String representing RFC 3986 URI.
1453    */
1454   function mint(
1455     address _to,
1456     uint256 _tokenId,
1457     string calldata _uri
1458   )
1459     external
1460     onlyOwner
1461   {
1462     super._mint(_to, _tokenId);
1463     super._setTokenUri(_tokenId, _uri);
1464   }
1465 
1466   /**
1467    * @dev Removes a NFT from owner.
1468    * @param _tokenId Which NFT we want to remove.
1469    */
1470   function burn(
1471     uint256 _tokenId
1472   )
1473     external
1474     onlyOwner
1475   {
1476     super._burn(_tokenId);
1477   }
1478 
1479 }
1480 
1481 // File: src/contracts/mocks/nf-token-mock.sol
1482 
1483 /**
1484  * @dev This is an example contract implementation of NFToken.
1485  */
1486 contract NFTokenMock is
1487   NFToken,
1488   Ownable
1489 {
1490 
1491   /**
1492    * @dev Mints a new NFT.
1493    * @param _to The address that will own the minted NFT.
1494    * @param _tokenId of the NFT to be minted by the msg.sender.
1495    */
1496   function mint(
1497     address _to,
1498     uint256 _tokenId
1499   )
1500     external
1501     onlyOwner
1502   {
1503     super._mint(_to, _tokenId);
1504   }
1505 
1506   /**
1507    * @dev Removes a NFT from owner.
1508    * @param _tokenId Which NFT we want to remove.
1509    */
1510   function burn(
1511     uint256 _tokenId
1512   )
1513     external
1514     onlyOwner
1515   {
1516     super._burn(_tokenId);
1517   }
1518 
1519 }
1520 
1521 // File: src/contracts/tokens/unchain.sol
1522 
1523 contract Unchain is
1524   NFTokenMetadata,
1525   NFTokenEnumerable,
1526   Ownable
1527 {
1528   constructor(
1529     string memory _name,
1530     string memory _symbol
1531   )
1532     public
1533   {
1534     nftName = _name;
1535     nftSymbol = _symbol;
1536   }
1537 
1538   /**
1539    * @dev Mint an NFT.
1540    * @notice Owner only method.
1541    * @param _owner Address to be minetd for the given NFT ID.
1542    * @param _id ID of the token to be minted.
1543    * @param _uri of the token to be minted.
1544    */
1545   function mint(
1546     address _owner,
1547     uint256 _id,
1548     string calldata _uri
1549   )
1550     onlyOwner
1551     external
1552   {
1553     super._mint(_owner, _id);
1554     super._setTokenUri(_id, _uri);
1555   }
1556 
1557   function burn(
1558     uint256 _tokenId
1559   )
1560     onlyOwner
1561     external
1562   {
1563     super._burn(_tokenId);
1564   }
1565 
1566 }