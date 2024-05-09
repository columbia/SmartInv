1 // File: src/contracts/tokens/erc721.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev ERC-721 non-fungible token standard. 
7  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
8  */
9 interface ERC721
10 {
11 
12   /**
13    * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
14    * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
15    * number of NFTs may be created and assigned without emitting Transfer. At the time of any
16    * transfer, the approved address for that NFT (if any) is reset to none.
17    */
18   event Transfer(
19     address indexed _from,
20     address indexed _to,
21     uint256 indexed _tokenId
22   );
23 
24   /**
25    * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
26    * address indicates there is no approved address. When a Transfer event emits, this also
27    * indicates that the approved address for that NFT (if any) is reset to none.
28    */
29   event Approval(
30     address indexed _owner,
31     address indexed _approved,
32     uint256 indexed _tokenId
33   );
34 
35   /**
36    * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
37    * all NFTs of the owner.
38    */
39   event ApprovalForAll(
40     address indexed _owner,
41     address indexed _operator,
42     bool _approved
43   );
44 
45   /**
46    * @dev Transfers the ownership of an NFT from one address to another address.
47    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
48    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
49    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
50    * function checks if `_to` is a smart contract (code size > 0). If so, it calls
51    * `onERC721Received` on `_to` and throws if the return value is not 
52    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
53    * @param _from The current owner of the NFT.
54    * @param _to The new owner.
55    * @param _tokenId The NFT to transfer.
56    * @param _data Additional data with no specified format, sent in call to `_to`.
57    */
58   function safeTransferFrom(
59     address _from,
60     address _to,
61     uint256 _tokenId,
62     bytes calldata _data
63   )
64     external;
65 
66   /**
67    * @dev Transfers the ownership of an NFT from one address to another address.
68    * @notice This works identically to the other function with an extra data parameter, except this
69    * function just sets data to ""
70    * @param _from The current owner of the NFT.
71    * @param _to The new owner.
72    * @param _tokenId The NFT to transfer.
73    */
74   function safeTransferFrom(
75     address _from,
76     address _to,
77     uint256 _tokenId
78   )
79     external;
80 
81   /**
82    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
83    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
84    * address. Throws if `_tokenId` is not a valid NFT.
85    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
86    * they mayb be permanently lost.
87    * @param _from The current owner of the NFT.
88    * @param _to The new owner.
89    * @param _tokenId The NFT to transfer.
90    */
91   function transferFrom(
92     address _from,
93     address _to,
94     uint256 _tokenId
95   )
96     external;
97 
98   /**
99    * @dev Set or reaffirm the approved address for an NFT.
100    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
101    * the current NFT owner, or an authorized operator of the current owner.
102    * @param _approved The new approved NFT controller.
103    * @param _tokenId The NFT to approve.
104    */
105   function approve(
106     address _approved,
107     uint256 _tokenId
108   )
109     external;
110 
111   /**
112    * @dev Enables or disables approval for a third party ("operator") to manage all of
113    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
114    * @notice The contract MUST allow multiple operators per owner.
115    * @param _operator Address to add to the set of authorized operators.
116    * @param _approved True if the operators is approved, false to revoke approval.
117    */
118   function setApprovalForAll(
119     address _operator,
120     bool _approved
121   )
122     external;
123 
124   /**
125    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
126    * considered invalid, and this function throws for queries about the zero address.
127    * @param _owner Address for whom to query the balance.
128    * @return Balance of _owner.
129    */
130   function balanceOf(
131     address _owner
132   )
133     external
134     view
135     returns (uint256);
136 
137   /**
138    * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered
139    * invalid, and queries about them do throw.
140    * @param _tokenId The identifier for an NFT.
141    * @return Address of _tokenId owner.
142    */
143   function ownerOf(
144     uint256 _tokenId
145   )
146     external
147     view
148     returns (address);
149     
150   /**
151    * @dev Get the approved address for a single NFT.
152    * @notice Throws if `_tokenId` is not a valid NFT.
153    * @param _tokenId The NFT to find the approved address for.
154    * @return Address that _tokenId is approved for. 
155    */
156   function getApproved(
157     uint256 _tokenId
158   )
159     external
160     view
161     returns (address);
162 
163   /**
164    * @dev Returns true if `_operator` is an approved operator for `_owner`, false otherwise.
165    * @param _owner The address that owns the NFTs.
166    * @param _operator The address that acts on behalf of the owner.
167    * @return True if approved for all, false otherwise.
168    */
169   function isApprovedForAll(
170     address _owner,
171     address _operator
172   )
173     external
174     view
175     returns (bool);
176 
177 }
178 
179 // File: src/contracts/tokens/erc721-token-receiver.sol
180 
181 pragma solidity ^0.5.0;
182 
183 /**
184  * @dev ERC-721 interface for accepting safe transfers. 
185  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
186  */
187 interface ERC721TokenReceiver
188 {
189 
190   /**
191    * @dev Handle the receipt of a NFT. The ERC721 smart contract calls this function on the
192    * recipient after a `transfer`. This function MAY throw to revert and reject the transfer. Return
193    * of other than the magic value MUST result in the transaction being reverted.
194    * Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))` unless throwing.
195    * @notice The contract address is always the message sender. A wallet/broker/auction application
196    * MUST implement the wallet interface if it will accept safe transfers.
197    * @param _operator The address which called `safeTransferFrom` function.
198    * @param _from The address which previously owned the token.
199    * @param _tokenId The NFT identifier which is being transferred.
200    * @param _data Additional data with no specified format.
201    * @return Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
202    */
203   function onERC721Received(
204     address _operator,
205     address _from,
206     uint256 _tokenId,
207     bytes calldata _data
208   )
209     external
210     returns(bytes4);
211     
212 }
213 
214 // File: src/contracts/math/safe-math.sol
215 
216 pragma solidity ^0.5.0;
217 
218 /**
219  * @dev Math operations with safety checks that throw on error. This contract is based on the 
220  * source code at: 
221  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol.
222  */
223 library SafeMath
224 {
225 
226   /**
227    * @dev Multiplies two numbers, reverts on overflow.
228    * @param _factor1 Factor number.
229    * @param _factor2 Factor number.
230    * @return The product of the two factors.
231    */
232   function mul(
233     uint256 _factor1,
234     uint256 _factor2
235   )
236     internal
237     pure
238     returns (uint256 product)
239   {
240     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
241     // benefit is lost if 'b' is also tested.
242     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
243     if (_factor1 == 0)
244     {
245       return 0;
246     }
247 
248     product = _factor1 * _factor2;
249     require(product / _factor1 == _factor2);
250   }
251 
252   /**
253    * @dev Integer division of two numbers, truncating the quotient, reverts on division by zero.
254    * @param _dividend Dividend number.
255    * @param _divisor Divisor number.
256    * @return The quotient.
257    */
258   function div(
259     uint256 _dividend,
260     uint256 _divisor
261   )
262     internal
263     pure
264     returns (uint256 quotient)
265   {
266     // Solidity automatically asserts when dividing by 0, using all gas.
267     require(_divisor > 0);
268     quotient = _dividend / _divisor;
269     // assert(_dividend == _divisor * quotient + _dividend % _divisor); // There is no case in which this doesn't hold.
270   }
271 
272   /**
273    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
274    * @param _minuend Minuend number.
275    * @param _subtrahend Subtrahend number.
276    * @return Difference.
277    */
278   function sub(
279     uint256 _minuend,
280     uint256 _subtrahend
281   )
282     internal
283     pure
284     returns (uint256 difference)
285   {
286     require(_subtrahend <= _minuend);
287     difference = _minuend - _subtrahend;
288   }
289 
290   /**
291    * @dev Adds two numbers, reverts on overflow.
292    * @param _addend1 Number.
293    * @param _addend2 Number.
294    * @return Sum.
295    */
296   function add(
297     uint256 _addend1,
298     uint256 _addend2
299   )
300     internal
301     pure
302     returns (uint256 sum)
303   {
304     sum = _addend1 + _addend2;
305     require(sum >= _addend1);
306   }
307 
308   /**
309     * @dev Divides two numbers and returns the remainder (unsigned integer modulo), reverts when
310     * dividing by zero.
311     * @param _dividend Number.
312     * @param _divisor Number.
313     * @return Remainder.
314     */
315   function mod(
316     uint256 _dividend,
317     uint256 _divisor
318   )
319     internal
320     pure
321     returns (uint256 remainder) 
322   {
323     require(_divisor != 0);
324     remainder = _dividend % _divisor;
325   }
326 
327 }
328 
329 // File: src/contracts/utils/erc165.sol
330 
331 pragma solidity ^0.5.0;
332 
333 /**
334  * @dev A standard for detecting smart contract interfaces. 
335  * See: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md.
336  */
337 interface ERC165
338 {
339 
340   /**
341    * @dev Checks if the smart contract includes a specific interface.
342    * @notice This function uses less than 30,000 gas.
343    * @param _interfaceID The interface identifier, as specified in ERC-165.
344    * @return True if _interfaceID is supported, false otherwise.
345    */
346   function supportsInterface(
347     bytes4 _interfaceID
348   )
349     external
350     view
351     returns (bool);
352     
353 }
354 
355 // File: src/contracts/utils/supports-interface.sol
356 
357 pragma solidity ^0.5.0;
358 
359 
360 /**
361  * @dev Implementation of standard for detect smart contract interfaces.
362  */
363 contract SupportsInterface is
364   ERC165
365 {
366 
367   /**
368    * @dev Mapping of supported intefraces.
369    * @notice You must not set element 0xffffffff to true.
370    */
371   mapping(bytes4 => bool) internal supportedInterfaces;
372 
373   /**
374    * @dev Contract constructor.
375    */
376   constructor ()
377     public 
378   {
379     supportedInterfaces[0x01ffc9a7] = true; // ERC165
380   }
381 
382   /**
383    * @dev Function to check which interfaces are suported by this contract.
384    * @param _interfaceID Id of the interface.
385    * @return True if _interfaceID is supported, false otherwise.
386    */
387   function supportsInterface(
388     bytes4 _interfaceID
389   )
390     external
391     view
392     returns (bool)
393   {
394     return supportedInterfaces[_interfaceID];
395   }
396 
397 }
398 
399 // File: src/contracts/utils/address-utils.sol
400 
401 pragma solidity ^0.5.0;
402 
403 /**
404  * @dev Utility library of inline functions on addresses.
405  */
406 library AddressUtils
407 {
408 
409   /**
410    * @dev Returns whether the target address is a contract.
411    * @param _addr Address to check.
412    * @return True if _addr is a contract, false if not.
413    */
414   function isContract(
415     address _addr
416   )
417     internal
418     view
419     returns (bool addressCheck)
420   {
421     uint256 size;
422 
423     /**
424      * XXX Currently there is no better way to check if there is a contract in an address than to
425      * check the size of the code at that address.
426      * See https://ethereum.stackexchange.com/a/14016/36603 for more details about how this works.
427      * TODO: Check this again before the Serenity release, because all addresses will be
428      * contracts then.
429      */
430     assembly { size := extcodesize(_addr) } // solhint-disable-line
431     addressCheck = size > 0;
432   }
433 
434 }
435 
436 // File: src/contracts/tokens/nf-token.sol
437 
438 pragma solidity ^0.5.0;
439 
440 
441 
442 
443 
444 
445 /**
446  * @dev Implementation of ERC-721 non-fungible token standard.
447  */
448 contract NFToken is
449   ERC721,
450   SupportsInterface
451 {
452   using SafeMath for uint256;
453   using AddressUtils for address;
454 
455   /**
456    * @dev Magic value of a smart contract that can recieve NFT.
457    * Equal to: bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")).
458    */
459   bytes4 internal constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
460 
461   /**
462    * @dev A mapping from NFT ID to the address that owns it.
463    */
464   mapping (uint256 => address) internal idToOwner;
465 
466   /**
467    * @dev Mapping from NFT ID to approved address.
468    */
469   mapping (uint256 => address) internal idToApproval;
470 
471    /**
472    * @dev Mapping from owner address to count of his tokens.
473    */
474   mapping (address => uint256) private ownerToNFTokenCount;
475 
476   /**
477    * @dev Mapping from owner address to mapping of operator addresses.
478    */
479   mapping (address => mapping (address => bool)) internal ownerToOperators;
480 
481   /**
482    * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
483    * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
484    * number of NFTs may be created and assigned without emitting Transfer. At the time of any
485    * transfer, the approved address for that NFT (if any) is reset to none.
486    * @param _from Sender of NFT (if address is zero address it indicates token creation).
487    * @param _to Receiver of NFT (if address is zero address it indicates token destruction).
488    * @param _tokenId The NFT that got transfered.
489    */
490   event Transfer(
491     address indexed _from,
492     address indexed _to,
493     uint256 indexed _tokenId
494   );
495 
496   /**
497    * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
498    * address indicates there is no approved address. When a Transfer event emits, this also
499    * indicates that the approved address for that NFT (if any) is reset to none.
500    * @param _owner Owner of NFT.
501    * @param _approved Address that we are approving.
502    * @param _tokenId NFT which we are approving.
503    */
504   event Approval(
505     address indexed _owner,
506     address indexed _approved,
507     uint256 indexed _tokenId
508   );
509 
510   /**
511    * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
512    * all NFTs of the owner.
513    * @param _owner Owner of NFT.
514    * @param _operator Address to which we are setting operator rights.
515    * @param _approved Status of operator rights(true if operator rights are given and false if
516    * revoked).
517    */
518   event ApprovalForAll(
519     address indexed _owner,
520     address indexed _operator,
521     bool _approved
522   );
523 
524   /**
525    * @dev Guarantees that the msg.sender is an owner or operator of the given NFT.
526    * @param _tokenId ID of the NFT to validate.
527    */
528   modifier canOperate(
529     uint256 _tokenId
530   ) 
531   {
532     address tokenOwner = idToOwner[_tokenId];
533     require(tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender]);
534     _;
535   }
536 
537   /**
538    * @dev Guarantees that the msg.sender is allowed to transfer NFT.
539    * @param _tokenId ID of the NFT to transfer.
540    */
541   modifier canTransfer(
542     uint256 _tokenId
543   ) 
544   {
545     address tokenOwner = idToOwner[_tokenId];
546     require(
547       tokenOwner == msg.sender
548       || idToApproval[_tokenId] == msg.sender
549       || ownerToOperators[tokenOwner][msg.sender]
550     );
551     _;
552   }
553 
554   /**
555    * @dev Guarantees that _tokenId is a valid Token.
556    * @param _tokenId ID of the NFT to validate.
557    */
558   modifier validNFToken(
559     uint256 _tokenId
560   )
561   {
562     require(idToOwner[_tokenId] != address(0));
563     _;
564   }
565 
566   /**
567    * @dev Contract constructor.
568    */
569   constructor()
570     public
571   {
572     supportedInterfaces[0x80ac58cd] = true; // ERC721
573   }
574 
575   /**
576    * @dev Transfers the ownership of an NFT from one address to another address. This function can
577    * be changed to payable.
578    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
579    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
580    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
581    * function checks if `_to` is a smart contract (code size > 0). If so, it calls 
582    * `onERC721Received` on `_to` and throws if the return value is not 
583    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
584    * @param _from The current owner of the NFT.
585    * @param _to The new owner.
586    * @param _tokenId The NFT to transfer.
587    * @param _data Additional data with no specified format, sent in call to `_to`.
588    */
589   function safeTransferFrom(
590     address _from,
591     address _to,
592     uint256 _tokenId,
593     bytes calldata _data
594   )
595     external
596   {
597     _safeTransferFrom(_from, _to, _tokenId, _data);
598   }
599 
600   /**
601    * @dev Transfers the ownership of an NFT from one address to another address. This function can
602    * be changed to payable.
603    * @notice This works identically to the other function with an extra data parameter, except this
604    * function just sets data to ""
605    * @param _from The current owner of the NFT.
606    * @param _to The new owner.
607    * @param _tokenId The NFT to transfer.
608    */
609   function safeTransferFrom(
610     address _from,
611     address _to,
612     uint256 _tokenId
613   )
614     external
615   {
616     _safeTransferFrom(_from, _to, _tokenId, "");
617   }
618 
619   /**
620    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
621    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
622    * address. Throws if `_tokenId` is not a valid NFT. This function can be changed to payable.
623    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
624    * they maybe be permanently lost.
625    * @param _from The current owner of the NFT.
626    * @param _to The new owner.
627    * @param _tokenId The NFT to transfer.
628    */
629   function transferFrom(
630     address _from,
631     address _to,
632     uint256 _tokenId
633   )
634     external
635     canTransfer(_tokenId)
636     validNFToken(_tokenId)
637   {
638     address tokenOwner = idToOwner[_tokenId];
639     require(tokenOwner == _from);
640     require(_to != address(0));
641 
642     _transfer(_to, _tokenId);
643   }
644 
645   /**
646    * @dev Set or reaffirm the approved address for an NFT. This function can be changed to payable.
647    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
648    * the current NFT owner, or an authorized operator of the current owner.
649    * @param _approved Address to be approved for the given NFT ID.
650    * @param _tokenId ID of the token to be approved.
651    */
652   function approve(
653     address _approved,
654     uint256 _tokenId
655   )
656     external
657     canOperate(_tokenId)
658     validNFToken(_tokenId)
659   {
660     address tokenOwner = idToOwner[_tokenId];
661     require(_approved != tokenOwner);
662 
663     idToApproval[_tokenId] = _approved;
664     emit Approval(tokenOwner, _approved, _tokenId);
665   }
666 
667   /**
668    * @dev Enables or disables approval for a third party ("operator") to manage all of
669    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
670    * @notice This works even if sender doesn't own any tokens at the time.
671    * @param _operator Address to add to the set of authorized operators.
672    * @param _approved True if the operators is approved, false to revoke approval.
673    */
674   function setApprovalForAll(
675     address _operator,
676     bool _approved
677   )
678     external
679   {
680     ownerToOperators[msg.sender][_operator] = _approved;
681     emit ApprovalForAll(msg.sender, _operator, _approved);
682   }
683 
684   /**
685    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
686    * considered invalid, and this function throws for queries about the zero address.
687    * @param _owner Address for whom to query the balance.
688    * @return Balance of _owner.
689    */
690   function balanceOf(
691     address _owner
692   )
693     external
694     view
695     returns (uint256)
696   {
697     require(_owner != address(0));
698     return _getOwnerNFTCount(_owner);
699   }
700 
701   /**
702    * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered
703    * invalid, and queries about them do throw.
704    * @param _tokenId The identifier for an NFT.
705    * @return Address of _tokenId owner.
706    */
707   function ownerOf(
708     uint256 _tokenId
709   )
710     external
711     view
712     returns (address _owner)
713   {
714     _owner = idToOwner[_tokenId];
715     require(_owner != address(0));
716   }
717 
718   /**
719    * @dev Get the approved address for a single NFT.
720    * @notice Throws if `_tokenId` is not a valid NFT.
721    * @param _tokenId ID of the NFT to query the approval of.
722    * @return Address that _tokenId is approved for. 
723    */
724   function getApproved(
725     uint256 _tokenId
726   )
727     external
728     view
729     validNFToken(_tokenId)
730     returns (address)
731   {
732     return idToApproval[_tokenId];
733   }
734 
735   /**
736    * @dev Checks if `_operator` is an approved operator for `_owner`.
737    * @param _owner The address that owns the NFTs.
738    * @param _operator The address that acts on behalf of the owner.
739    * @return True if approved for all, false otherwise.
740    */
741   function isApprovedForAll(
742     address _owner,
743     address _operator
744   )
745     external
746     view
747     returns (bool)
748   {
749     return ownerToOperators[_owner][_operator];
750   }
751 
752   /**
753    * @dev Actually preforms the transfer.
754    * @notice Does NO checks.
755    * @param _to Address of a new owner.
756    * @param _tokenId The NFT that is being transferred.
757    */
758   function _transfer(
759     address _to,
760     uint256 _tokenId
761   )
762     internal
763   {
764     address from = idToOwner[_tokenId];
765     _clearApproval(_tokenId);
766 
767     _removeNFToken(from, _tokenId);
768     _addNFToken(_to, _tokenId);
769 
770     emit Transfer(from, _to, _tokenId);
771   }
772    
773   /**
774    * @dev Mints a new NFT.
775    * @notice This is an internal function which should be called from user-implemented external
776    * mint function. Its purpose is to show and properly initialize data structures when using this
777    * implementation.
778    * @param _to The address that will own the minted NFT.
779    * @param _tokenId of the NFT to be minted by the msg.sender.
780    */
781   function _mint(
782     address _to,
783     uint256 _tokenId
784   )
785     internal
786   {
787     require(_to != address(0));
788     require(idToOwner[_tokenId] == address(0));
789 
790     _addNFToken(_to, _tokenId);
791 
792     emit Transfer(address(0), _to, _tokenId);
793   }
794 
795   /**
796    * @dev Burns a NFT.
797    * @notice This is an internal function which should be called from user-implemented external burn
798    * function. Its purpose is to show and properly initialize data structures when using this
799    * implementation. Also, note that this burn implementation allows the minter to re-mint a burned
800    * NFT.
801    * @param _tokenId ID of the NFT to be burned.
802    */
803   function _burn(
804     uint256 _tokenId
805   )
806     internal
807     validNFToken(_tokenId)
808   {
809     address tokenOwner = idToOwner[_tokenId];
810     _clearApproval(_tokenId);
811     _removeNFToken(tokenOwner, _tokenId);
812     emit Transfer(tokenOwner, address(0), _tokenId);
813   }
814 
815   /**
816    * @dev Removes a NFT from owner.
817    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
818    * @param _from Address from wich we want to remove the NFT.
819    * @param _tokenId Which NFT we want to remove.
820    */
821   function _removeNFToken(
822     address _from,
823     uint256 _tokenId
824   )
825     internal
826   {
827     require(idToOwner[_tokenId] == _from);
828     ownerToNFTokenCount[_from] = ownerToNFTokenCount[_from] - 1;
829     delete idToOwner[_tokenId];
830   }
831 
832   /**
833    * @dev Assignes a new NFT to owner.
834    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
835    * @param _to Address to wich we want to add the NFT.
836    * @param _tokenId Which NFT we want to add.
837    */
838   function _addNFToken(
839     address _to,
840     uint256 _tokenId
841   )
842     internal
843   {
844     require(idToOwner[_tokenId] == address(0));
845 
846     idToOwner[_tokenId] = _to;
847     ownerToNFTokenCount[_to] = ownerToNFTokenCount[_to].add(1);
848   }
849 
850   /**
851    * @dev Helper function that gets NFT count of owner. This is needed for overriding in enumerable
852    * extension to remove double storage (gas optimization) of owner nft count.
853    * @param _owner Address for whom to query the count.
854    * @return Number of _owner NFTs.
855    */
856   function _getOwnerNFTCount(
857     address _owner
858   )
859     internal
860     view
861     returns (uint256)
862   {
863     return ownerToNFTokenCount[_owner];
864   }
865 
866   /**
867    * @dev Actually perform the safeTransferFrom.
868    * @param _from The current owner of the NFT.
869    * @param _to The new owner.
870    * @param _tokenId The NFT to transfer.
871    * @param _data Additional data with no specified format, sent in call to `_to`.
872    */
873   function _safeTransferFrom(
874     address _from,
875     address _to,
876     uint256 _tokenId,
877     bytes memory _data
878   )
879     private
880     canTransfer(_tokenId)
881     validNFToken(_tokenId)
882   {
883     address tokenOwner = idToOwner[_tokenId];
884     require(tokenOwner == _from);
885     require(_to != address(0));
886 
887     _transfer(_to, _tokenId);
888 
889     if (_to.isContract()) 
890     {
891       bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
892       require(retval == MAGIC_ON_ERC721_RECEIVED);
893     }
894   }
895 
896   /** 
897    * @dev Clears the current approval of a given NFT ID.
898    * @param _tokenId ID of the NFT to be transferred.
899    */
900   function _clearApproval(
901     uint256 _tokenId
902   )
903     private
904   {
905     if (idToApproval[_tokenId] != address(0))
906     {
907       delete idToApproval[_tokenId];
908     }
909   }
910 
911 }
912 
913 // File: src/contracts/tokens/erc721-enumerable.sol
914 
915 pragma solidity ^0.5.0;
916 
917 /**
918  * @dev Optional enumeration extension for ERC-721 non-fungible token standard.
919  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
920  */
921 interface ERC721Enumerable
922 {
923 
924   /**
925    * @dev Returns a count of valid NFTs tracked by this contract, where each one of them has an
926    * assigned and queryable owner not equal to the zero address.
927    * @return Total supply of NFTs.
928    */
929   function totalSupply()
930     external
931     view
932     returns (uint256);
933 
934   /**
935    * @dev Returns the token identifier for the `_index`th NFT. Sort order is not specified.
936    * @param _index A counter less than `totalSupply()`.
937    * @return Token id.
938    */
939   function tokenByIndex(
940     uint256 _index
941   )
942     external
943     view
944     returns (uint256);
945 
946   /**
947    * @dev Returns the token identifier for the `_index`th NFT assigned to `_owner`. Sort order is
948    * not specified. It throws if `_index` >= `balanceOf(_owner)` or if `_owner` is the zero address,
949    * representing invalid NFTs.
950    * @param _owner An address where we are interested in NFTs owned by them.
951    * @param _index A counter less than `balanceOf(_owner)`.
952    * @return Token id.
953    */
954   function tokenOfOwnerByIndex(
955     address _owner,
956     uint256 _index
957   )
958     external
959     view
960     returns (uint256);
961 
962 }
963 
964 // File: src/contracts/tokens/nf-token-enumerable.sol
965 
966 pragma solidity ^0.5.0;
967 
968 
969 
970 /**
971  * @dev Optional enumeration implementation for ERC-721 non-fungible token standard.
972  */
973 contract NFTokenEnumerable is
974   NFToken,
975   ERC721Enumerable
976 {
977 
978   /**
979    * @dev Array of all NFT IDs.
980    */
981   uint256[] internal tokens;
982 
983   /**
984    * @dev Mapping from token ID to its index in global tokens array.
985    */
986   mapping(uint256 => uint256) internal idToIndex;
987 
988   /**
989    * @dev Mapping from owner to list of owned NFT IDs.
990    */
991   mapping(address => uint256[]) internal ownerToIds;
992 
993   /**
994    * @dev Mapping from NFT ID to its index in the owner tokens list.
995    */
996   mapping(uint256 => uint256) internal idToOwnerIndex;
997 
998   /**
999    * @dev Contract constructor.
1000    */
1001   constructor ()
1002     public
1003   {
1004     supportedInterfaces[0x780e9d63] = true; // ERC721Enumerable
1005   }
1006 
1007   /**
1008    * @dev Returns the count of all existing NFTokens.
1009    * @return Total supply of NFTs.
1010    */
1011   function totalSupply()
1012     external
1013     view
1014     returns (uint256)
1015   {
1016     return tokens.length;
1017   }
1018 
1019   /**
1020    * @dev Returns NFT ID by its index.
1021    * @param _index A counter less than `totalSupply()`.
1022    * @return Token id.
1023    */
1024   function tokenByIndex(
1025     uint256 _index
1026   )
1027     external
1028     view
1029     returns (uint256)
1030   {
1031     require(_index < tokens.length);
1032     return tokens[_index];
1033   }
1034 
1035   /**
1036    * @dev returns the n-th NFT ID from a list of owner's tokens.
1037    * @param _owner Token owner's address.
1038    * @param _index Index number representing n-th token in owner's list of tokens.
1039    * @return Token id.
1040    */
1041   function tokenOfOwnerByIndex(
1042     address _owner,
1043     uint256 _index
1044   )
1045     external
1046     view
1047     returns (uint256)
1048   {
1049     require(_index < ownerToIds[_owner].length);
1050     return ownerToIds[_owner][_index];
1051   }
1052 
1053   /**
1054    * @dev Mints a new NFT.
1055    * @notice This is an internal function which should be called from user-implemented external
1056    * mint function. Its purpose is to show and properly initialize data structures when using this
1057    * implementation.
1058    * @param _to The address that will own the minted NFT.
1059    * @param _tokenId of the NFT to be minted by the msg.sender.
1060    */
1061   function _mint(
1062     address _to,
1063     uint256 _tokenId
1064   )
1065     internal
1066   {
1067     super._mint(_to, _tokenId);
1068     uint256 length = tokens.push(_tokenId);
1069     idToIndex[_tokenId] = length - 1;
1070   }
1071 
1072   /**
1073    * @dev Burns a NFT.
1074    * @notice This is an internal function which should be called from user-implemented external
1075    * burn function. Its purpose is to show and properly initialize data structures when using this
1076    * implementation. Also, note that this burn implementation allows the minter to re-mint a burned
1077    * NFT.
1078    * @param _tokenId ID of the NFT to be burned.
1079    */
1080   function _burn(
1081     uint256 _tokenId
1082   )
1083     internal
1084   {
1085     super._burn(_tokenId);
1086 
1087     uint256 tokenIndex = idToIndex[_tokenId];
1088     uint256 lastTokenIndex = tokens.length - 1;
1089     uint256 lastToken = tokens[lastTokenIndex];
1090 
1091     tokens[tokenIndex] = lastToken;
1092 
1093     tokens.length--;
1094     // This wastes gas if you are burning the last token but saves a little gas if you are not. 
1095     idToIndex[lastToken] = tokenIndex;
1096     idToIndex[_tokenId] = 0;
1097   }
1098 
1099   /**
1100    * @dev Removes a NFT from an address.
1101    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
1102    * @param _from Address from wich we want to remove the NFT.
1103    * @param _tokenId Which NFT we want to remove.
1104    */
1105   function _removeNFToken(
1106     address _from,
1107     uint256 _tokenId
1108   )
1109     internal
1110   {
1111     require(idToOwner[_tokenId] == _from);
1112     delete idToOwner[_tokenId];
1113 
1114     uint256 tokenToRemoveIndex = idToOwnerIndex[_tokenId];
1115     uint256 lastTokenIndex = ownerToIds[_from].length - 1;
1116 
1117     if (lastTokenIndex != tokenToRemoveIndex)
1118     {
1119       uint256 lastToken = ownerToIds[_from][lastTokenIndex];
1120       ownerToIds[_from][tokenToRemoveIndex] = lastToken;
1121       idToOwnerIndex[lastToken] = tokenToRemoveIndex;
1122     }
1123 
1124     ownerToIds[_from].length--;
1125   }
1126 
1127   /**
1128    * @dev Assignes a new NFT to an address.
1129    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
1130    * @param _to Address to wich we want to add the NFT.
1131    * @param _tokenId Which NFT we want to add.
1132    */
1133   function _addNFToken(
1134     address _to,
1135     uint256 _tokenId
1136   )
1137     internal
1138   {
1139     require(idToOwner[_tokenId] == address(0));
1140     idToOwner[_tokenId] = _to;
1141 
1142     uint256 length = ownerToIds[_to].push(_tokenId);
1143     idToOwnerIndex[_tokenId] = length - 1;
1144   }
1145 
1146   /**
1147    * @dev Helper function that gets NFT count of owner. This is needed for overriding in enumerable
1148    * extension to remove double storage(gas optimization) of owner nft count.
1149    * @param _owner Address for whom to query the count.
1150    * @return Number of _owner NFTs.
1151    */
1152   function _getOwnerNFTCount(
1153     address _owner
1154   )
1155     internal
1156     view
1157     returns (uint256)
1158   {
1159     return ownerToIds[_owner].length;
1160   }
1161 }
1162 
1163 // File: src/contracts/ownership/ownable.sol
1164 
1165 pragma solidity ^0.5.0;
1166 
1167 /**
1168  * @dev The contract has an owner address, and provides basic authorization control whitch
1169  * simplifies the implementation of user permissions. This contract is based on the source code at:
1170  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
1171  */
1172 contract Ownable
1173 {
1174   
1175   /**
1176    * @dev Error constants.
1177    */
1178   string public constant NOT_OWNER = "018001";
1179   string public constant ZERO_ADDRESS = "018002";
1180 
1181   /**
1182    * @dev Current owner address.
1183    */
1184   address public owner;
1185 
1186   /**
1187    * @dev An event which is triggered when the owner is changed.
1188    * @param previousOwner The address of the previous owner.
1189    * @param newOwner The address of the new owner.
1190    */
1191   event OwnershipTransferred(
1192     address indexed previousOwner,
1193     address indexed newOwner
1194   );
1195 
1196   /**
1197    * @dev The constructor sets the original `owner` of the contract to the sender account.
1198    */
1199   constructor ()
1200     public
1201   {
1202     owner = msg.sender;
1203   }
1204 
1205   /**
1206    * @dev Throws if called by any account other than the owner.
1207    */
1208   modifier onlyOwner()
1209   {
1210     require(msg.sender == owner, NOT_OWNER);
1211     _;
1212   }
1213 
1214   /**
1215    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1216    * @param _newOwner The address to transfer ownership to.
1217    */
1218   function transferOwnership(
1219     address _newOwner
1220   )
1221     public
1222     onlyOwner
1223   {
1224     require(_newOwner != address(0), ZERO_ADDRESS);
1225     emit OwnershipTransferred(owner, _newOwner);
1226     owner = _newOwner;
1227   }
1228 
1229 }
1230 
1231 // File: src/contracts/mocks/nf-token-enumerable-mock.sol
1232 
1233 pragma solidity ^0.5.0;
1234 
1235 
1236 
1237 /**
1238  * @dev This is an example contract implementation of NFToken with enumerable extension.
1239  */
1240 contract NFTokenEnumerableMock is
1241   NFTokenEnumerable,
1242   Ownable
1243 {
1244 
1245   /**
1246    * @dev Mints a new NFT.
1247    * @param _to The address that will own the minted NFT.
1248    * @param _tokenId of the NFT to be minted by the msg.sender.
1249    */
1250   function mint(
1251     address _to,
1252     uint256 _tokenId
1253   )
1254     external
1255     onlyOwner
1256   {
1257     super._mint(_to, _tokenId);
1258   }
1259 
1260   /**
1261    * @dev Removes a NFT from owner.
1262    * @param _tokenId Which NFT we want to remove.
1263    */
1264   function burn(
1265     uint256 _tokenId
1266   )
1267     external
1268     onlyOwner
1269   {
1270     super._burn(_tokenId);
1271   }
1272 
1273 }
1274 
1275 // File: src/contracts/tokens/erc721-metadata.sol
1276 
1277 pragma solidity ^0.5.0;
1278 
1279 /**
1280  * @dev Optional metadata extension for ERC-721 non-fungible token standard.
1281  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
1282  */
1283 interface ERC721Metadata
1284 {
1285 
1286   /**
1287    * @dev Returns a descriptive name for a collection of NFTs in this contract.
1288    * @return Representing name. 
1289    */
1290   function name()
1291     external
1292     view
1293     returns (string memory _name);
1294 
1295   /**
1296    * @dev Returns a abbreviated name for a collection of NFTs in this contract.
1297    * @return Representing symbol. 
1298    */
1299   function symbol()
1300     external
1301     view
1302     returns (string memory _symbol);
1303 
1304   /**
1305    * @dev Returns a distinct Uniform Resource Identifier (URI) for a given asset. It Throws if
1306    * `_tokenId` is not a valid NFT. URIs are defined in RFC3986. The URI may point to a JSON file
1307    * that conforms to the "ERC721 Metadata JSON Schema".
1308    * @return URI of _tokenId.
1309    */
1310   function tokenURI(uint256 _tokenId)
1311     external
1312     view
1313     returns (string memory);
1314 
1315 }
1316 
1317 // File: src/contracts/tokens/nf-token-metadata.sol
1318 
1319 pragma solidity ^0.5.0;
1320 
1321 
1322 
1323 /**
1324  * @dev Optional metadata implementation for ERC-721 non-fungible token standard.
1325  */
1326 contract NFTokenMetadata is
1327   NFToken,
1328   ERC721Metadata
1329 {
1330 
1331   /**
1332    * @dev A descriptive name for a collection of NFTs.
1333    */
1334   string internal nftName;
1335 
1336   /**
1337    * @dev An abbreviated name for NFTokens.
1338    */
1339   string internal nftSymbol;
1340 
1341   /**
1342    * @dev Mapping from NFT ID to metadata uri.
1343    */
1344   mapping (uint256 => string) internal idToUri;
1345 
1346   /**
1347    * @dev Contract constructor.
1348    * @notice When implementing this contract don't forget to set nftName and nftSymbol.
1349    */
1350   constructor ()
1351     public
1352   {
1353     supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
1354   }
1355 
1356   /**
1357    * @dev Returns a descriptive name for a collection of NFTokens.
1358    * @return Representing name. 
1359    */
1360   function name()
1361     external
1362     view
1363     returns (string memory _name)
1364   {
1365     _name = nftName;
1366   }
1367 
1368   /**
1369    * @dev Returns an abbreviated name for NFTokens.
1370    * @return Representing symbol. 
1371    */
1372   function symbol()
1373     external
1374     view
1375     returns (string memory _symbol)
1376   {
1377     _symbol = nftSymbol;
1378   }
1379 
1380   /**
1381    * @dev A distinct URI (RFC 3986) for a given NFT.
1382    * @param _tokenId Id for which we want uri.
1383    * @return URI of _tokenId.
1384    */
1385   function tokenURI(
1386     uint256 _tokenId
1387   )
1388     external
1389     view
1390     validNFToken(_tokenId)
1391     returns (string memory)
1392   {
1393     return idToUri[_tokenId];
1394   }
1395 
1396   /**
1397    * @dev Burns a NFT.
1398    * @notice This is an internal function which should be called from user-implemented external
1399    * burn function. Its purpose is to show and properly initialize data structures when using this
1400    * implementation. Also, note that this burn implementation allows the minter to re-mint a burned
1401    * NFT.
1402    * @param _tokenId ID of the NFT to be burned.
1403    */
1404   function _burn(
1405     uint256 _tokenId
1406   )
1407     internal
1408   {
1409     super._burn(_tokenId);
1410 
1411     if (bytes(idToUri[_tokenId]).length != 0)
1412     {
1413       delete idToUri[_tokenId];
1414     }
1415   }
1416 
1417   /**
1418    * @dev Set a distinct URI (RFC 3986) for a given NFT ID.
1419    * @notice This is an internal function which should be called from user-implemented external
1420    * function. Its purpose is to show and properly initialize data structures when using this
1421    * implementation.
1422    * @param _tokenId Id for which we want uri.
1423    * @param _uri String representing RFC 3986 URI.
1424    */
1425   function _setTokenUri(
1426     uint256 _tokenId,
1427     string memory _uri
1428   )
1429     internal
1430     validNFToken(_tokenId)
1431   {
1432     idToUri[_tokenId] = _uri;
1433   }
1434 
1435 }
1436 
1437 // File: src/contracts/mocks/nf-token-metadata-enumerable-mock.sol
1438 
1439 pragma solidity ^0.5.0;
1440 
1441 
1442 
1443 
1444 /**
1445  * @dev This is an example contract implementation of NFToken with enumerable and metadata
1446  * extensions.
1447  */
1448 contract NFTokenMetadataEnumerableMock is
1449   NFTokenEnumerable,
1450   NFTokenMetadata,
1451   Ownable
1452 {
1453 
1454   /**
1455    * @dev Contract constructor.
1456    * @param _name A descriptive name for a collection of NFTs.
1457    * @param _symbol An abbreviated name for NFTokens.
1458    */
1459   constructor (
1460     string memory _name,
1461     string memory _symbol
1462   )
1463     public
1464   {
1465     nftName = _name;
1466     nftSymbol = _symbol;
1467   }
1468 
1469   /**
1470    * @dev Mints a new NFT.
1471    * @param _to The address that will own the minted NFT.
1472    * @param _tokenId of the NFT to be minted by the msg.sender.
1473    * @param _uri String representing RFC 3986 URI.
1474    */
1475   function mint(
1476     address _to,
1477     uint256 _tokenId,
1478     string calldata _uri
1479   )
1480     external
1481     onlyOwner
1482   {
1483     super._mint(_to, _tokenId);
1484     super._setTokenUri(_tokenId, _uri);
1485   }
1486 
1487   /**
1488    * @dev Removes a NFT from owner.
1489    * @param _tokenId Which NFT we want to remove.
1490    */
1491   function burn(
1492     uint256 _tokenId
1493   )
1494     external
1495     onlyOwner
1496   {
1497     super._burn(_tokenId);
1498   }
1499 
1500 }
1501 
1502 // File: src/contracts/mocks/nf-token-metadata-mock.sol
1503 
1504 pragma solidity ^0.5.0;
1505 
1506 
1507 
1508 /**
1509  * @dev This is an example contract implementation of NFToken with metadata extension.
1510  */
1511 contract NFTokenMetadataMock is
1512   NFTokenMetadata,
1513   Ownable
1514 {
1515 
1516   /**
1517    * @dev Contract constructor.
1518    * @param _name A descriptive name for a collection of NFTs.
1519    * @param _symbol An abbreviated name for NFTokens.
1520    */
1521   constructor (
1522     string memory _name,
1523     string memory _symbol
1524   )
1525     public
1526   {
1527     nftName = _name;
1528     nftSymbol = _symbol;
1529   }
1530 
1531   /**
1532    * @dev Mints a new NFT.
1533    * @param _to The address that will own the minted NFT.
1534    * @param _tokenId of the NFT to be minted by the msg.sender.
1535    * @param _uri String representing RFC 3986 URI.
1536    */
1537   function mint(
1538     address _to,
1539     uint256 _tokenId,
1540     string calldata _uri
1541   )
1542     external
1543     onlyOwner
1544   {
1545     super._mint(_to, _tokenId);
1546     super._setTokenUri(_tokenId, _uri);
1547   }
1548 
1549   /**
1550    * @dev Removes a NFT from owner.
1551    * @param _tokenId Which NFT we want to remove.
1552    */
1553   function burn(
1554     uint256 _tokenId
1555   )
1556     external
1557     onlyOwner
1558   {
1559     super._burn(_tokenId);
1560   }
1561 
1562 }
1563 
1564 // File: src/contracts/mocks/nf-token-mock.sol
1565 
1566 pragma solidity ^0.5.0;
1567 
1568 
1569 
1570 /**
1571  * @dev This is an example contract implementation of NFToken.
1572  */
1573 contract NFTokenMock is
1574   NFToken,
1575   Ownable
1576 {
1577 
1578   /**
1579    * @dev Mints a new NFT.
1580    * @param _to The address that will own the minted NFT.
1581    * @param _tokenId of the NFT to be minted by the msg.sender.
1582    */
1583   function mint(
1584     address _to,
1585     uint256 _tokenId
1586   )
1587     external
1588     onlyOwner
1589   {
1590     super._mint(_to, _tokenId);
1591   }
1592 
1593 }
1594 
1595 // File: src/contracts/tokens/linker-license-proxy.sol
1596 
1597 pragma solidity ^0.5.0;
1598 
1599 
1600 
1601 
1602 contract OwnableDelegateProxy { }
1603 
1604 contract ProxyRegistry {
1605     mapping(address => OwnableDelegateProxy) public proxies;
1606 }
1607 
1608 
1609 contract LinkerProxyNFT058 is
1610   NFTokenMetadata,
1611   NFTokenEnumerable,
1612   Ownable
1613 {
1614   address proxyRegistryAddress;
1615   constructor (
1616     string memory _name,
1617     string memory _symbol
1618   )
1619     public
1620   {
1621     nftName = _name;
1622     nftSymbol = _symbol;
1623     proxyRegistryAddress = msg.sender;
1624   }
1625 
1626   /**
1627    * @dev Returns an abbreviated name for NFTokens.
1628    * @return Representing symbol. 
1629    */
1630   function proxyAddress()
1631     external
1632     view
1633     returns (address _proxyAddress)
1634   {
1635     _proxyAddress = proxyRegistryAddress;
1636   }
1637 
1638 
1639   /**
1640    * @dev Mint an NFT.
1641    * @notice Owner only method.
1642    * @param _owner Address to be minetd for the given NFT ID.
1643    * @param _id ID of the token to be minted.
1644    * @param _uri of the token to be minted.
1645    */
1646   function mint(
1647     address _owner,
1648     uint256 _id,
1649     string calldata _uri
1650   )
1651     onlyOwner
1652     external
1653   {
1654     super._mint(_owner, _id);
1655     super._setTokenUri(_id, _uri);
1656     this.setApprovalForAll(proxyRegistryAddress, true);
1657   }
1658 
1659   function burn(
1660     uint256 _tokenId
1661   )
1662     onlyOwner
1663     external
1664   {
1665     super._burn(_tokenId);
1666   }
1667 
1668   /**
1669    * @dev Enables or disables approval for a third party ("operator") to manage all of
1670    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
1671    * @notice This works even if sender doesn't own any tokens at the time.
1672    * @param _operator Address to add to the set of authorized operators.
1673    * @param _approved True if the operators is approved, false to revoke approval.
1674    */
1675   function setApprovalForAll(
1676     address _operator,
1677     bool _approved
1678   )
1679     external
1680   {
1681     if (address(proxyRegistryAddress) == _operator){
1682       this.setApprovalForAll(_operator, true);
1683     }
1684     this.setApprovalForAll(_operator, _approved);
1685   }
1686 }
1687 
1688 // File: src/contracts/tokens/linker-license.sol
1689 
1690 pragma solidity ^0.5.0;
1691 
1692 
1693 
1694 
1695 
1696 contract LinkerCommonNFT058 is
1697   NFTokenMetadata,
1698   NFTokenEnumerable,
1699   Ownable
1700 {
1701   constructor (
1702     string memory _name,
1703     string memory _symbol
1704   )
1705     public
1706   {
1707     nftName = _name;
1708     nftSymbol = _symbol;
1709   }
1710 
1711   /**
1712    * @dev Mint an NFT.
1713    * @notice Owner only method.
1714    * @param _owner Address to be minetd for the given NFT ID.
1715    * @param _id ID of the token to be minted.
1716    * @param _uri of the token to be minted.
1717    */
1718   function mint(
1719     address _owner,
1720     uint256 _id,
1721     string calldata _uri
1722   )
1723     onlyOwner
1724     external
1725   {
1726     super._mint(_owner, _id);
1727     super._setTokenUri(_id, _uri);
1728   }
1729 
1730   function burn(
1731     uint256 _tokenId
1732   )
1733     onlyOwner
1734     external
1735   {
1736     super._burn(_tokenId);
1737   }
1738 }
1739 
1740 // File: src/contracts/tokens/unchain.sol
1741 
1742 pragma solidity ^0.5.0;
1743 
1744 
1745 
1746 
1747 
1748 contract Unchain is
1749   NFTokenMetadata,
1750   NFTokenEnumerable,
1751   Ownable
1752 {
1753   constructor (
1754     string memory _name,
1755     string memory _symbol
1756   )
1757     public
1758   {
1759     nftName = _name;
1760     nftSymbol = _symbol;
1761   }
1762 
1763   /**
1764    * @dev Mint an NFT.
1765    * @notice Owner only method.
1766    * @param _owner Address to be minetd for the given NFT ID.
1767    * @param _id ID of the token to be minted.
1768    * @param _uri of the token to be minted.
1769    */
1770   function mint(
1771     address _owner,
1772     uint256 _id,
1773     string calldata _uri
1774   )
1775     onlyOwner
1776     external
1777   {
1778     super._mint(_owner, _id);
1779     super._setTokenUri(_id, _uri);
1780   }
1781 
1782   function burn(
1783     uint256 _tokenId
1784   )
1785     onlyOwner
1786     external
1787   {
1788     super._burn(_tokenId);
1789   }
1790 }