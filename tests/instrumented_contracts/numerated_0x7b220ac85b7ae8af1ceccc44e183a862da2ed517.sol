1 pragma solidity 0.5.5;
2 
3 /**
4  * @dev Standard interface for a dex proxy contract.
5  */
6 interface Proxy {
7 
8   /**
9    * @dev Executes an action.
10    * @param _target Target of execution.
11    * @param _a Address usually representing from.
12    * @param _b Address usually representing to.
13    * @param _c Integer usually repersenting amount/value/id.
14    */
15   function execute(
16     address _target,
17     address _a,
18     address _b,
19     uint256 _c
20   )
21     external;
22     
23 }
24 
25 /**
26  * @dev Xcert interface.
27  */
28 interface Xcert // is ERC721 metadata enumerable
29 {
30 
31   /**
32    * @dev Creates a new Xcert.
33    * @param _to The address that will own the created Xcert.
34    * @param _id The Xcert to be created by the msg.sender.
35    * @param _imprint Cryptographic asset imprint.
36    */
37   function create(
38     address _to,
39     uint256 _id,
40     bytes32 _imprint
41   )
42     external;
43 
44   /**
45    * @dev Change URI base.
46    * @param _uriBase New uriBase.
47    */
48   function setUriBase(
49     string calldata _uriBase
50   )
51     external;
52 
53   /**
54    * @dev Returns a bytes4 of keccak256 of json schema representing 0xcert Protocol convention.
55    * @return Schema id.
56    */
57   function schemaId()
58     external
59     view
60     returns (bytes32 _schemaId);
61 
62   /**
63    * @dev Returns imprint for Xcert.
64    * @param _tokenId Id of the Xcert.
65    * @return Token imprint.
66    */
67   function tokenImprint(
68     uint256 _tokenId
69   )
70     external
71     view
72     returns(bytes32 imprint);
73 
74 }
75 
76 /**
77  * @dev Xcert burnable interface.
78  */
79 interface XcertBurnable // is Xcert
80 {
81 
82   /**
83    * @dev Destroys a specified Xcert. Reverts if not called from Xcert owner or operator.
84    * @param _tokenId Id of the Xcert we want to destroy.
85    */
86   function destroy(
87     uint256 _tokenId
88   )
89     external;
90 
91 }
92 
93 /**
94  * @dev Xcert nutable interface.
95  */
96 interface XcertMutable // is Xcert
97 {
98   
99   /**
100    * @dev Updates Xcert imprint.
101    * @param _tokenId Id of the Xcert.
102    * @param _imprint New imprint.
103    */
104   function updateTokenImprint(
105     uint256 _tokenId,
106     bytes32 _imprint
107   )
108     external;
109 
110 }
111 
112 /**
113  * @dev Xcert pausable interface.
114  */
115 interface XcertPausable // is Xcert
116 {
117 
118   /**
119    * @dev Sets if Xcerts transfers are paused (can be performed) or not.
120    * @param _isPaused Pause status.
121    */
122   function setPause(
123     bool _isPaused
124   )
125     external;
126     
127 }
128 
129 /**
130  * @dev Xcert revokable interface.
131  */
132 interface XcertRevokable // is Xcert
133 {
134   
135   /**
136    * @dev Revokes a specified Xcert. Reverts if not called from contract owner or authorized 
137    * address.
138    * @param _tokenId Id of the Xcert we want to destroy.
139    */
140   function revoke(
141     uint256 _tokenId
142   )
143     external;
144 
145 }
146 
147 /**
148  * @dev Math operations with safety checks that throw on error. This contract is based on the 
149  * source code at: 
150  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol.
151  */
152 library SafeMath
153 {
154 
155   /**
156    * @dev Error constants.
157    */
158   string constant OVERFLOW = "008001";
159   string constant SUBTRAHEND_GREATER_THEN_MINUEND = "008002";
160   string constant DIVISION_BY_ZERO = "008003";
161 
162   /**
163    * @dev Multiplies two numbers, reverts on overflow.
164    * @param _factor1 Factor number.
165    * @param _factor2 Factor number.
166    * @return The product of the two factors.
167    */
168   function mul(
169     uint256 _factor1,
170     uint256 _factor2
171   )
172     internal
173     pure
174     returns (uint256 product)
175   {
176     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
177     // benefit is lost if 'b' is also tested.
178     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
179     if (_factor1 == 0)
180     {
181       return 0;
182     }
183 
184     product = _factor1 * _factor2;
185     require(product / _factor1 == _factor2, OVERFLOW);
186   }
187 
188   /**
189    * @dev Integer division of two numbers, truncating the quotient, reverts on division by zero.
190    * @param _dividend Dividend number.
191    * @param _divisor Divisor number.
192    * @return The quotient.
193    */
194   function div(
195     uint256 _dividend,
196     uint256 _divisor
197   )
198     internal
199     pure
200     returns (uint256 quotient)
201   {
202     // Solidity automatically asserts when dividing by 0, using all gas.
203     require(_divisor > 0, DIVISION_BY_ZERO);
204     quotient = _dividend / _divisor;
205     // assert(_dividend == _divisor * quotient + _dividend % _divisor); // There is no case in which this doesn't hold.
206   }
207 
208   /**
209    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
210    * @param _minuend Minuend number.
211    * @param _subtrahend Subtrahend number.
212    * @return Difference.
213    */
214   function sub(
215     uint256 _minuend,
216     uint256 _subtrahend
217   )
218     internal
219     pure
220     returns (uint256 difference)
221   {
222     require(_subtrahend <= _minuend, SUBTRAHEND_GREATER_THEN_MINUEND);
223     difference = _minuend - _subtrahend;
224   }
225 
226   /**
227    * @dev Adds two numbers, reverts on overflow.
228    * @param _addend1 Number.
229    * @param _addend2 Number.
230    * @return Sum.
231    */
232   function add(
233     uint256 _addend1,
234     uint256 _addend2
235   )
236     internal
237     pure
238     returns (uint256 sum)
239   {
240     sum = _addend1 + _addend2;
241     require(sum >= _addend1, OVERFLOW);
242   }
243 
244   /**
245     * @dev Divides two numbers and returns the remainder (unsigned integer modulo), reverts when
246     * dividing by zero.
247     * @param _dividend Number.
248     * @param _divisor Number.
249     * @return Remainder.
250     */
251   function mod(
252     uint256 _dividend,
253     uint256 _divisor
254   )
255     internal
256     pure
257     returns (uint256 remainder) 
258   {
259     require(_divisor != 0, DIVISION_BY_ZERO);
260     remainder = _dividend % _divisor;
261   }
262 
263 }
264 
265 /**
266  * @title Contract for setting abilities.
267  * @dev For optimization purposes the abilities are represented as a bitfield. Maximum number of
268  * abilities is therefore 256. This is an example(for simplicity is made for max 8 abilities) of how
269  * this works. 
270  * 00000001 Ability A - number representation 1
271  * 00000010 Ability B - number representation 2
272  * 00000100 Ability C - number representation 4
273  * 00001000 Ability D - number representation 8
274  * 00010000 Ability E - number representation 16
275  * etc ... 
276  * To grant abilities B and C, we would need a bitfield of 00000110 which is represented by number
277  * 6, in other words, the sum of abilities B and C. The same concept works for revoking abilities
278  * and checking if someone has multiple abilities.
279  */
280 contract Abilitable
281 {
282   using SafeMath for uint;
283 
284   /**
285    * @dev Error constants.
286    */
287   string constant NOT_AUTHORIZED = "017001";
288   string constant CANNOT_REVOKE_OWN_SUPER_ABILITY = "017002";
289   string constant INVALID_INPUT = "017003";
290 
291   /**
292    * @dev Ability 1 (00000001) is a reserved ability called super ability. It is an
293    * ability to grant or revoke abilities of other accounts. Other abilities are determined by the
294    * implementing contract.
295    */
296   uint8 constant SUPER_ABILITY = 1;
297 
298   /**
299    * @dev Maps address to ability ids.
300    */
301   mapping(address => uint256) public addressToAbility;
302 
303   /**
304    * @dev Emits when an address is granted an ability.
305    * @param _target Address to which we are granting abilities.
306    * @param _abilities Number representing bitfield of abilities we are granting.
307    */
308   event GrantAbilities(
309     address indexed _target,
310     uint256 indexed _abilities
311   );
312 
313   /**
314    * @dev Emits when an address gets an ability revoked.
315    * @param _target Address of which we are revoking an ability.
316    * @param _abilities Number representing bitfield of abilities we are revoking.
317    */
318   event RevokeAbilities(
319     address indexed _target,
320     uint256 indexed _abilities
321   );
322 
323   /**
324    * @dev Guarantees that msg.sender has certain abilities.
325    */
326   modifier hasAbilities(
327     uint256 _abilities
328   ) 
329   {
330     require(_abilities > 0, INVALID_INPUT);
331     require(
332       addressToAbility[msg.sender] & _abilities == _abilities,
333       NOT_AUTHORIZED
334     );
335     _;
336   }
337 
338   /**
339    * @dev Contract constructor.
340    * Sets SUPER_ABILITY ability to the sender account.
341    */
342   constructor()
343     public
344   {
345     addressToAbility[msg.sender] = SUPER_ABILITY;
346     emit GrantAbilities(msg.sender, SUPER_ABILITY);
347   }
348 
349   /**
350    * @dev Grants specific abilities to specified address.
351    * @param _target Address to grant abilities to.
352    * @param _abilities Number representing bitfield of abilities we are granting.
353    */
354   function grantAbilities(
355     address _target,
356     uint256 _abilities
357   )
358     external
359     hasAbilities(SUPER_ABILITY)
360   {
361     addressToAbility[_target] |= _abilities;
362     emit GrantAbilities(_target, _abilities);
363   }
364 
365   /**
366    * @dev Unassigns specific abilities from specified address.
367    * @param _target Address of which we revoke abilites.
368    * @param _abilities Number representing bitfield of abilities we are revoking.
369    * @param _allowSuperRevoke Additional check that prevents you from removing your own super
370    * ability by mistake.
371    */
372   function revokeAbilities(
373     address _target,
374     uint256 _abilities,
375     bool _allowSuperRevoke
376   )
377     external
378     hasAbilities(SUPER_ABILITY)
379   {
380     if (!_allowSuperRevoke && msg.sender == _target)
381     {
382       require((_abilities & 1) == 0, CANNOT_REVOKE_OWN_SUPER_ABILITY);
383     }
384     addressToAbility[_target] &= ~_abilities;
385     emit RevokeAbilities(_target, _abilities);
386   }
387 
388   /**
389    * @dev Check if an address has a specific ability. Throws if checking for 0.
390    * @param _target Address for which we want to check if it has a specific abilities.
391    * @param _abilities Number representing bitfield of abilities we are checking.
392    */
393   function isAble(
394     address _target,
395     uint256 _abilities
396   )
397     external
398     view
399     returns (bool)
400   {
401     require(_abilities > 0, INVALID_INPUT);
402     return (addressToAbility[_target] & _abilities) == _abilities;
403   }
404   
405 }
406 
407 /**
408  * @dev ERC-721 non-fungible token standard. 
409  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
410  */
411 interface ERC721
412 {
413 
414   /**
415    * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
416    * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
417    * number of NFTs may be created and assigned without emitting Transfer. At the time of any
418    * transfer, the approved address for that NFT (if any) is reset to none.
419    */
420   event Transfer(
421     address indexed _from,
422     address indexed _to,
423     uint256 indexed _tokenId
424   );
425 
426   /**
427    * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
428    * address indicates there is no approved address. When a Transfer event emits, this also
429    * indicates that the approved address for that NFT (if any) is reset to none.
430    */
431   event Approval(
432     address indexed _owner,
433     address indexed _approved,
434     uint256 indexed _tokenId
435   );
436 
437   /**
438    * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
439    * all NFTs of the owner.
440    */
441   event ApprovalForAll(
442     address indexed _owner,
443     address indexed _operator,
444     bool _approved
445   );
446 
447   /**
448    * @dev Transfers the ownership of an NFT from one address to another address.
449    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
450    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
451    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
452    * function checks if `_to` is a smart contract (code size > 0). If so, it calls
453    * `onERC721Received` on `_to` and throws if the return value is not 
454    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
455    * @param _from The current owner of the NFT.
456    * @param _to The new owner.
457    * @param _tokenId The NFT to transfer.
458    * @param _data Additional data with no specified format, sent in call to `_to`.
459    */
460   function safeTransferFrom(
461     address _from,
462     address _to,
463     uint256 _tokenId,
464     bytes calldata _data
465   )
466     external;
467 
468   /**
469    * @dev Transfers the ownership of an NFT from one address to another address.
470    * @notice This works identically to the other function with an extra data parameter, except this
471    * function just sets data to ""
472    * @param _from The current owner of the NFT.
473    * @param _to The new owner.
474    * @param _tokenId The NFT to transfer.
475    */
476   function safeTransferFrom(
477     address _from,
478     address _to,
479     uint256 _tokenId
480   )
481     external;
482 
483   /**
484    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
485    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
486    * address. Throws if `_tokenId` is not a valid NFT.
487    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
488    * they mayb be permanently lost.
489    * @param _from The current owner of the NFT.
490    * @param _to The new owner.
491    * @param _tokenId The NFT to transfer.
492    */
493   function transferFrom(
494     address _from,
495     address _to,
496     uint256 _tokenId
497   )
498     external;
499 
500   /**
501    * @dev Set or reaffirm the approved address for an NFT.
502    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
503    * the current NFT owner, or an authorized operator of the current owner.
504    * @param _approved The new approved NFT controller.
505    * @param _tokenId The NFT to approve.
506    */
507   function approve(
508     address _approved,
509     uint256 _tokenId
510   )
511     external;
512 
513   /**
514    * @dev Enables or disables approval for a third party ("operator") to manage all of
515    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
516    * @notice The contract MUST allow multiple operators per owner.
517    * @param _operator Address to add to the set of authorized operators.
518    * @param _approved True if the operators is approved, false to revoke approval.
519    */
520   function setApprovalForAll(
521     address _operator,
522     bool _approved
523   )
524     external;
525 
526   /**
527    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
528    * considered invalid, and this function throws for queries about the zero address.
529    * @param _owner Address for whom to query the balance.
530    * @return Balance of _owner.
531    */
532   function balanceOf(
533     address _owner
534   )
535     external
536     view
537     returns (uint256);
538 
539   /**
540    * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered
541    * invalid, and queries about them do throw.
542    * @param _tokenId The identifier for an NFT.
543    * @return Address of _tokenId owner.
544    */
545   function ownerOf(
546     uint256 _tokenId
547   )
548     external
549     view
550     returns (address);
551     
552   /**
553    * @dev Get the approved address for a single NFT.
554    * @notice Throws if `_tokenId` is not a valid NFT.
555    * @param _tokenId The NFT to find the approved address for.
556    * @return Address that _tokenId is approved for. 
557    */
558   function getApproved(
559     uint256 _tokenId
560   )
561     external
562     view
563     returns (address);
564 
565   /**
566    * @dev Returns true if `_operator` is an approved operator for `_owner`, false otherwise.
567    * @param _owner The address that owns the NFTs.
568    * @param _operator The address that acts on behalf of the owner.
569    * @return True if approved for all, false otherwise.
570    */
571   function isApprovedForAll(
572     address _owner,
573     address _operator
574   )
575     external
576     view
577     returns (bool);
578 
579 }
580 
581 /**
582  * @dev Optional metadata extension for ERC-721 non-fungible token standard.
583  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
584  */
585 interface ERC721Metadata
586 {
587 
588   /**
589    * @dev Returns a descriptive name for a collection of NFTs in this contract.
590    * @return Representing name. 
591    */
592   function name()
593     external
594     view
595     returns (string memory _name);
596 
597   /**
598    * @dev Returns a abbreviated name for a collection of NFTs in this contract.
599    * @return Representing symbol. 
600    */
601   function symbol()
602     external
603     view
604     returns (string memory _symbol);
605 
606   /**
607    * @dev Returns a distinct Uniform Resource Identifier (URI) for a given asset. It Throws if
608    * `_tokenId` is not a valid NFT. URIs are defined in RFC3986. The URI may point to a JSON file
609    * that conforms to the "ERC721 Metadata JSON Schema".
610    * @return URI of _tokenId.
611    */
612   function tokenURI(uint256 _tokenId)
613     external
614     view
615     returns (string memory);
616 
617 }
618 
619 /**
620  * @dev Optional enumeration extension for ERC-721 non-fungible token standard.
621  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
622  */
623 interface ERC721Enumerable
624 {
625 
626   /**
627    * @dev Returns a count of valid NFTs tracked by this contract, where each one of them has an
628    * assigned and queryable owner not equal to the zero address.
629    * @return Total supply of NFTs.
630    */
631   function totalSupply()
632     external
633     view
634     returns (uint256);
635 
636   /**
637    * @dev Returns the token identifier for the `_index`th NFT. Sort order is not specified.
638    * @param _index A counter less than `totalSupply()`.
639    * @return Token id.
640    */
641   function tokenByIndex(
642     uint256 _index
643   )
644     external
645     view
646     returns (uint256);
647 
648   /**
649    * @dev Returns the token identifier for the `_index`th NFT assigned to `_owner`. Sort order is
650    * not specified. It throws if `_index` >= `balanceOf(_owner)` or if `_owner` is the zero address,
651    * representing invalid NFTs.
652    * @param _owner An address where we are interested in NFTs owned by them.
653    * @param _index A counter less than `balanceOf(_owner)`.
654    * @return Token id.
655    */
656   function tokenOfOwnerByIndex(
657     address _owner,
658     uint256 _index
659   )
660     external
661     view
662     returns (uint256);
663 
664 }
665 
666 /**
667  * @dev ERC-721 interface for accepting safe transfers. 
668  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
669  */
670 interface ERC721TokenReceiver
671 {
672 
673   /**
674    * @dev Handle the receipt of a NFT. The ERC721 smart contract calls this function on the
675    * recipient after a `transfer`. This function MAY throw to revert and reject the transfer. Return
676    * of other than the magic value MUST result in the transaction being reverted.
677    * Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))` unless throwing.
678    * @notice The contract address is always the message sender. A wallet/broker/auction application
679    * MUST implement the wallet interface if it will accept safe transfers.
680    * @param _operator The address which called `safeTransferFrom` function.
681    * @param _from The address which previously owned the token.
682    * @param _tokenId The NFT identifier which is being transferred.
683    * @param _data Additional data with no specified format.
684    * @return Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
685    */
686   function onERC721Received(
687     address _operator,
688     address _from,
689     uint256 _tokenId,
690     bytes calldata _data
691   )
692     external
693     returns(bytes4);
694     
695 }
696 
697 /**
698  * @dev A standard for detecting smart contract interfaces.
699  * See: https://eips.ethereum.org/EIPS/eip-165.
700  */
701 interface ERC165
702 {
703 
704   /**
705    * @dev Checks if the smart contract implements a specific interface.
706    * @notice This function uses less than 30,000 gas.
707    * @param _interfaceID The interface identifier, as specified in ERC-165.
708    */
709   function supportsInterface(
710     bytes4 _interfaceID
711   )
712     external
713     view
714     returns (bool);
715 
716 }
717 
718 /**
719  * @dev Implementation of standard to publish supported interfaces.
720  */
721 contract SupportsInterface is
722   ERC165
723 {
724 
725   /**
726    * @dev Mapping of supported intefraces.
727    * @notice You must not set element 0xffffffff to true.
728    */
729   mapping(bytes4 => bool) internal supportedInterfaces;
730 
731   /**
732    * @dev Contract constructor.
733    */
734   constructor()
735     public
736   {
737     supportedInterfaces[0x01ffc9a7] = true; // ERC165
738   }
739 
740   /**
741    * @dev Function to check which interfaces are suported by this contract.
742    * @param _interfaceID Id of the interface.
743    */
744   function supportsInterface(
745     bytes4 _interfaceID
746   )
747     external
748     view
749     returns (bool)
750   {
751     return supportedInterfaces[_interfaceID];
752   }
753 
754 }
755 
756 /**
757  * @dev Utility library of inline functions on addresses.
758  */
759 library AddressUtils
760 {
761 
762   /**
763    * @dev Returns whether the target address is a contract.
764    * @param _addr Address to check.
765    * @return True if _addr is a contract, false if not.
766    */
767   function isContract(
768     address _addr
769   )
770     internal
771     view
772     returns (bool addressCheck)
773   {
774     uint256 size;
775 
776     /**
777      * XXX Currently there is no better way to check if there is a contract in an address than to
778      * check the size of the code at that address.
779      * See https://ethereum.stackexchange.com/a/14016/36603 for more details about how this works.
780      * TODO: Check this again before the Serenity release, because all addresses will be
781      * contracts then.
782      */
783     assembly { size := extcodesize(_addr) } // solhint-disable-line
784     addressCheck = size > 0;
785   }
786 
787 }
788 
789 /**
790  * @dev Optional metadata enumerable implementation for ERC-721 non-fungible token standard.
791  */
792 contract NFTokenMetadataEnumerable is
793   ERC721,
794   ERC721Metadata,
795   ERC721Enumerable,
796   SupportsInterface
797 {
798   using SafeMath for uint256;
799   using AddressUtils for address;
800 
801   /**
802    * @dev Error constants.
803    */
804   string constant ZERO_ADDRESS = "006001";
805   string constant NOT_VALID_NFT = "006002";
806   string constant NOT_OWNER_OR_OPERATOR = "006003";
807   string constant NOT_OWNER_APPROWED_OR_OPERATOR = "006004";
808   string constant NOT_ABLE_TO_RECEIVE_NFT = "006005";
809   string constant NFT_ALREADY_EXISTS = "006006";
810   string constant INVALID_INDEX = "006007";
811 
812   /**
813    * @dev Magic value of a smart contract that can recieve NFT.
814    * Equal to: bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")).
815    */
816   bytes4 constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
817 
818   /**
819    * @dev A descriptive name for a collection of NFTs.
820    */
821   string internal nftName;
822 
823   /**
824    * @dev An abbreviated name for NFTs.
825    */
826   string internal nftSymbol;
827 
828   /**
829    * @dev URI base for NFT metadata. NFT URI is made from base + NFT id.
830    */
831   string public uriBase;
832 
833   /**
834    * @dev Array of all NFT IDs.
835    */
836   uint256[] internal tokens;
837 
838   /**
839    * @dev Mapping from token ID its index in global tokens array.
840    */
841   mapping(uint256 => uint256) internal idToIndex;
842 
843   /**
844    * @dev Mapping from owner to list of owned NFT IDs.
845    */
846   mapping(address => uint256[]) internal ownerToIds;
847 
848   /**
849    * @dev Mapping from NFT ID to its index in the owner tokens list.
850    */
851   mapping(uint256 => uint256) internal idToOwnerIndex;
852 
853   /**
854    * @dev A mapping from NFT ID to the address that owns it.
855    */
856   mapping (uint256 => address) internal idToOwner;
857 
858   /**
859    * @dev Mapping from NFT ID to approved address.
860    */
861   mapping (uint256 => address) internal idToApproval;
862 
863   /**
864    * @dev Mapping from owner address to mapping of operator addresses.
865    */
866   mapping (address => mapping (address => bool)) internal ownerToOperators;
867 
868   /**
869    * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
870    * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
871    * number of NFTs may be created and assigned without emitting Transfer. At the time of any
872    * transfer, the approved address for that NFT (if any) is reset to none.
873    * @param _from Sender of NFT (if address is zero address it indicates token creation).
874    * @param _to Receiver of NFT (if address is zero address it indicates token destruction).
875    * @param _tokenId The NFT that got transfered.
876    */
877   event Transfer(
878     address indexed _from,
879     address indexed _to,
880     uint256 indexed _tokenId
881   );
882 
883   /**
884    * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
885    * address indicates there is no approved address. When a Transfer event emits, this also
886    * indicates that the approved address for that NFT (if any) is reset to none.
887    * @param _owner Owner of NFT.
888    * @param _approved Address that we are approving.
889    * @param _tokenId NFT which we are approving.
890    */
891   event Approval(
892     address indexed _owner,
893     address indexed _approved,
894     uint256 indexed _tokenId
895   );
896 
897   /**
898    * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
899    * all NFTs of the owner.
900    * @param _owner Owner of NFT.
901    * @param _operator Address to which we are setting operator rights.
902    * @param _approved Status of operator rights(true if operator rights are given and false if
903    * revoked).
904    */
905   event ApprovalForAll(
906     address indexed _owner,
907     address indexed _operator,
908     bool _approved
909   );
910 
911   /**
912    * @dev Contract constructor.
913    * @notice When implementing this contract don't forget to set nftName, nftSymbol and uriBase.
914    */
915   constructor()
916     public
917   {
918     supportedInterfaces[0x80ac58cd] = true; // ERC721
919     supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
920     supportedInterfaces[0x780e9d63] = true; // ERC721Enumerable
921   }
922 
923   /**
924    * @dev Transfers the ownership of an NFT from one address to another address.
925    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
926    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
927    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
928    * function checks if `_to` is a smart contract (code size > 0). If so, it calls 
929    * `onERC721Received` on `_to` and throws if the return value is not 
930    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
931    * @param _from The current owner of the NFT.
932    * @param _to The new owner.
933    * @param _tokenId The NFT to transfer.
934    * @param _data Additional data with no specified format, sent in call to `_to`.
935    */
936   function safeTransferFrom(
937     address _from,
938     address _to,
939     uint256 _tokenId,
940     bytes calldata _data
941   )
942     external
943   {
944     _safeTransferFrom(_from, _to, _tokenId, _data);
945   }
946 
947   /**
948    * @dev Transfers the ownership of an NFT from one address to another address.
949    * @notice This works identically to the other function with an extra data parameter, except this
950    * function just sets data to "".
951    * @param _from The current owner of the NFT.
952    * @param _to The new owner.
953    * @param _tokenId The NFT to transfer.
954    */
955   function safeTransferFrom(
956     address _from,
957     address _to,
958     uint256 _tokenId
959   )
960     external
961   {
962     _safeTransferFrom(_from, _to, _tokenId, "");
963   }
964 
965   /**
966    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
967    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
968    * address. Throws if `_tokenId` is not a valid NFT.
969    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
970    * they maybe be permanently lost.
971    * @param _from The current owner of the NFT.
972    * @param _to The new owner.
973    * @param _tokenId The NFT to transfer.
974    */
975   function transferFrom(
976     address _from,
977     address _to,
978     uint256 _tokenId
979   )
980     external
981   {
982     _transferFrom(_from, _to, _tokenId);
983   }
984 
985   /**
986    * @dev Set or reaffirm the approved address for an NFT.
987    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
988    * the current NFT owner, or an authorized operator of the current owner.
989    * @param _approved Address to be approved for the given NFT ID.
990    * @param _tokenId ID of the token to be approved.
991    */
992   function approve(
993     address _approved,
994     uint256 _tokenId
995   )
996     external
997   {
998     // can operate
999     address tokenOwner = idToOwner[_tokenId];
1000     require(
1001       tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender],
1002       NOT_OWNER_OR_OPERATOR
1003     );
1004 
1005     idToApproval[_tokenId] = _approved;
1006     emit Approval(tokenOwner, _approved, _tokenId);
1007   }
1008 
1009   /**
1010    * @dev Enables or disables approval for a third party ("operator") to manage all of
1011    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
1012    * @notice This works even if sender doesn't own any tokens at the time.
1013    * @param _operator Address to add to the set of authorized operators.
1014    * @param _approved True if the operators is approved, false to revoke approval.
1015    */
1016   function setApprovalForAll(
1017     address _operator,
1018     bool _approved
1019   )
1020     external
1021   {
1022     ownerToOperators[msg.sender][_operator] = _approved;
1023     emit ApprovalForAll(msg.sender, _operator, _approved);
1024   }
1025 
1026   /**
1027    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
1028    * considered invalid, and this function throws for queries about the zero address.
1029    * @param _owner Address for whom to query the balance.
1030    * @return Balance of _owner.
1031    */
1032   function balanceOf(
1033     address _owner
1034   )
1035     external
1036     view
1037     returns (uint256)
1038   {
1039     require(_owner != address(0), ZERO_ADDRESS);
1040     return ownerToIds[_owner].length;
1041   }
1042 
1043   /**
1044    * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered
1045    * invalid, and queries about them do throw.
1046    * @param _tokenId The identifier for an NFT.
1047    * @return Address of _tokenId owner.
1048    */
1049   function ownerOf(
1050     uint256 _tokenId
1051   )
1052     external
1053     view
1054     returns (address _owner)
1055   {
1056     _owner = idToOwner[_tokenId];
1057     require(_owner != address(0), NOT_VALID_NFT);
1058   }
1059 
1060   /**
1061    * @dev Get the approved address for a single NFT.
1062    * @notice Throws if `_tokenId` is not a valid NFT.
1063    * @param _tokenId ID of the NFT to query the approval of.
1064    * @return Address that _tokenId is approved for. 
1065    */
1066   function getApproved(
1067     uint256 _tokenId
1068   )
1069     external
1070     view
1071     returns (address)
1072   {
1073     require(idToOwner[_tokenId] != address(0), NOT_VALID_NFT);
1074     return idToApproval[_tokenId];
1075   }
1076 
1077   /**
1078    * @dev Checks if `_operator` is an approved operator for `_owner`.
1079    * @param _owner The address that owns the NFTs.
1080    * @param _operator The address that acts on behalf of the owner.
1081    * @return True if approved for all, false otherwise.
1082    */
1083   function isApprovedForAll(
1084     address _owner,
1085     address _operator
1086   )
1087     external
1088     view
1089     returns (bool)
1090   {
1091     return ownerToOperators[_owner][_operator];
1092   }
1093 
1094   /**
1095    * @dev Returns the count of all existing NFTs.
1096    * @return Total supply of NFTs.
1097    */
1098   function totalSupply()
1099     external
1100     view
1101     returns (uint256)
1102   {
1103     return tokens.length;
1104   }
1105 
1106   /**
1107    * @dev Returns NFT ID by its index.
1108    * @param _index A counter less than `totalSupply()`.
1109    * @return Token id.
1110    */
1111   function tokenByIndex(
1112     uint256 _index
1113   )
1114     external
1115     view
1116     returns (uint256)
1117   {
1118     require(_index < tokens.length, INVALID_INDEX);
1119     return tokens[_index];
1120   }
1121 
1122   /**
1123    * @dev returns the n-th NFT ID from a list of owner's tokens.
1124    * @param _owner Token owner's address.
1125    * @param _index Index number representing n-th token in owner's list of tokens.
1126    * @return Token id.
1127    */
1128   function tokenOfOwnerByIndex(
1129     address _owner,
1130     uint256 _index
1131   )
1132     external
1133     view
1134     returns (uint256)
1135   {
1136     require(_index < ownerToIds[_owner].length, INVALID_INDEX);
1137     return ownerToIds[_owner][_index];
1138   }
1139 
1140   /**
1141    * @dev Returns a descriptive name for a collection of NFTs.
1142    * @return Representing name. 
1143    */
1144   function name()
1145     external
1146     view
1147     returns (string memory _name)
1148   {
1149     _name = nftName;
1150   }
1151 
1152   /**
1153    * @dev Returns an abbreviated name for NFTs.
1154    * @return Representing symbol. 
1155    */
1156   function symbol()
1157     external
1158     view
1159     returns (string memory _symbol)
1160   {
1161     _symbol = nftSymbol;
1162   }
1163   
1164   /**
1165    * @notice A distinct Uniform Resource Identifier (URI) for a given asset.
1166    * @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC 3986. The URI may point
1167    * to a JSON file that conforms to the "ERC721 Metadata JSON Schema".
1168    * @param _tokenId Id for which we want URI.
1169    * @return URI of _tokenId.
1170    */
1171   function tokenURI(
1172     uint256 _tokenId
1173   )
1174     external
1175     view
1176     returns (string memory)
1177   {
1178     require(idToOwner[_tokenId] != address(0), NOT_VALID_NFT);
1179     if (bytes(uriBase).length > 0)
1180     {
1181       return string(abi.encodePacked(uriBase, _uint2str(_tokenId)));
1182     }
1183     return "";
1184   }
1185 
1186   /**
1187    * @dev Set a distinct URI (RFC 3986) base for all nfts.
1188    * @notice this is a internal function which should be called from user-implemented external
1189    * function. Its purpose is to show and properly initialize data structures when using this
1190    * implementation.
1191    * @param _uriBase String representing RFC 3986 URI base.
1192    */
1193   function _setUriBase(
1194     string memory _uriBase
1195   )
1196     internal
1197   {
1198     uriBase = _uriBase;
1199   }
1200 
1201   /**
1202    * @dev Creates a new NFT.
1203    * @notice This is a private function which should be called from user-implemented external
1204    * function. Its purpose is to show and properly initialize data structures when using this
1205    * implementation.
1206    * @param _to The address that will own the created NFT.
1207    * @param _tokenId of the NFT to be created by the msg.sender.
1208    */
1209   function _create(
1210     address _to,
1211     uint256 _tokenId
1212   )
1213     internal
1214   {
1215     require(_to != address(0), ZERO_ADDRESS);
1216     require(idToOwner[_tokenId] == address(0), NFT_ALREADY_EXISTS);
1217 
1218     // add NFT
1219     idToOwner[_tokenId] = _to;
1220 
1221     uint256 length = ownerToIds[_to].push(_tokenId);
1222     idToOwnerIndex[_tokenId] = length - 1;
1223 
1224     // add to tokens array
1225     length = tokens.push(_tokenId);
1226     idToIndex[_tokenId] = length - 1;
1227 
1228     emit Transfer(address(0), _to, _tokenId);
1229   }
1230 
1231   /**
1232    * @dev Destroys a NFT.
1233    * @notice This is a private function which should be called from user-implemented external
1234    * destroy function. Its purpose is to show and properly initialize data structures when using this
1235    * implementation.
1236    * @param _tokenId ID of the NFT to be destroyed.
1237    */
1238   function _destroy(
1239     uint256 _tokenId
1240   )
1241     internal
1242   {
1243     // valid NFT
1244     address owner = idToOwner[_tokenId];
1245     require(owner != address(0), NOT_VALID_NFT);
1246 
1247     // clear approval
1248     if (idToApproval[_tokenId] != address(0))
1249     {
1250       delete idToApproval[_tokenId];
1251     }
1252 
1253     // remove NFT
1254     assert(ownerToIds[owner].length > 0);
1255 
1256     uint256 tokenToRemoveIndex = idToOwnerIndex[_tokenId];
1257     uint256 lastTokenIndex = ownerToIds[owner].length - 1;
1258     uint256 lastToken;
1259     if (lastTokenIndex != tokenToRemoveIndex)
1260     {
1261       lastToken = ownerToIds[owner][lastTokenIndex];
1262       ownerToIds[owner][tokenToRemoveIndex] = lastToken;
1263       idToOwnerIndex[lastToken] = tokenToRemoveIndex;
1264     }
1265 
1266     delete idToOwner[_tokenId];
1267     delete idToOwnerIndex[_tokenId];
1268     ownerToIds[owner].length--;
1269 
1270     // remove from tokens array
1271     assert(tokens.length > 0);
1272 
1273     uint256 tokenIndex = idToIndex[_tokenId];
1274     lastTokenIndex = tokens.length - 1;
1275     lastToken = tokens[lastTokenIndex];
1276 
1277     tokens[tokenIndex] = lastToken;
1278 
1279     tokens.length--;
1280     // Consider adding a conditional check for the last token in order to save GAS.
1281     idToIndex[lastToken] = tokenIndex;
1282     idToIndex[_tokenId] = 0;
1283 
1284     emit Transfer(owner, address(0), _tokenId);
1285   }
1286 
1287   /**
1288    * @dev Helper methods that actually does the transfer.
1289    * @param _from The current owner of the NFT.
1290    * @param _to The new owner.
1291    * @param _tokenId The NFT to transfer.
1292    */
1293   function _transferFrom(
1294     address _from,
1295     address _to,
1296     uint256 _tokenId
1297   )
1298     internal
1299   {
1300     // valid NFT
1301     require(_from != address(0), ZERO_ADDRESS);
1302     require(idToOwner[_tokenId] == _from, NOT_VALID_NFT);
1303     require(_to != address(0), ZERO_ADDRESS);
1304 
1305     // can transfer
1306     require(
1307       _from == msg.sender
1308       || idToApproval[_tokenId] == msg.sender
1309       || ownerToOperators[_from][msg.sender],
1310       NOT_OWNER_APPROWED_OR_OPERATOR
1311     );
1312 
1313     // clear approval
1314     if (idToApproval[_tokenId] != address(0))
1315     {
1316       delete idToApproval[_tokenId];
1317     }
1318 
1319     // remove NFT
1320     assert(ownerToIds[_from].length > 0);
1321 
1322     uint256 tokenToRemoveIndex = idToOwnerIndex[_tokenId];
1323     uint256 lastTokenIndex = ownerToIds[_from].length - 1;
1324 
1325     if (lastTokenIndex != tokenToRemoveIndex)
1326     {
1327       uint256 lastToken = ownerToIds[_from][lastTokenIndex];
1328       ownerToIds[_from][tokenToRemoveIndex] = lastToken;
1329       idToOwnerIndex[lastToken] = tokenToRemoveIndex;
1330     }
1331 
1332     ownerToIds[_from].length--;
1333 
1334     // add NFT
1335     idToOwner[_tokenId] = _to;
1336     uint256 length = ownerToIds[_to].push(_tokenId);
1337     idToOwnerIndex[_tokenId] = length - 1;
1338 
1339     emit Transfer(_from, _to, _tokenId);
1340   }
1341 
1342   /**
1343    * @dev Helper function that actually does the safeTransfer.
1344    * @param _from The current owner of the NFT.
1345    * @param _to The new owner.
1346    * @param _tokenId The NFT to transfer.
1347    * @param _data Additional data with no specified format, sent in call to `_to`.
1348    */
1349   function _safeTransferFrom(
1350     address _from,
1351     address _to,
1352     uint256 _tokenId,
1353     bytes memory _data
1354   )
1355     internal
1356   {
1357     if (_to.isContract())
1358     {
1359       require(
1360         ERC721TokenReceiver(_to)
1361           .onERC721Received(msg.sender, _from, _tokenId, _data) == MAGIC_ON_ERC721_RECEIVED,
1362         NOT_ABLE_TO_RECEIVE_NFT
1363       );
1364     }
1365 
1366     _transferFrom(_from, _to, _tokenId);
1367   }
1368 
1369   /**
1370    * @dev Helper function that changes uint to string representation.
1371    * @return String representation.
1372    */
1373   function _uint2str(
1374     uint256 _i
1375   ) 
1376     internal
1377     pure
1378     returns (string memory str)
1379   {
1380     if (_i == 0)
1381     {
1382       return "0";
1383     }
1384     uint256 j = _i;
1385     uint256 length;
1386     while (j != 0)
1387     {
1388       length++;
1389       j /= 10;
1390     }
1391     bytes memory bstr = new bytes(length);
1392     uint256 k = length - 1;
1393     j = _i;
1394     while (j != 0)
1395     {
1396       bstr[k--] = byte(uint8(48 + j % 10));
1397       j /= 10;
1398     }
1399     str = string(bstr);
1400   }
1401   
1402 }
1403 
1404 /**
1405  * @dev Xcert implementation.
1406  */
1407 contract XcertToken is 
1408   Xcert,
1409   XcertBurnable,
1410   XcertMutable,
1411   XcertPausable,
1412   XcertRevokable,
1413   NFTokenMetadataEnumerable,
1414   Abilitable
1415 {
1416 
1417   /**
1418    * @dev List of abilities (gathered from all extensions):
1419    */
1420   uint8 constant ABILITY_CREATE_ASSET = 2;
1421   uint8 constant ABILITY_REVOKE_ASSET = 4;
1422   uint8 constant ABILITY_TOGGLE_TRANSFERS = 8;
1423   uint8 constant ABILITY_UPDATE_ASSET_IMPRINT = 16;
1424   /// ABILITY_ALLOW_CREATE_ASSET = 32 - A specific ability that is bounded to atomic orders.
1425   /// When creating a new Xcert trough `OrderGateway`, the order maker has to have this ability.
1426   uint8 constant ABILITY_UPDATE_URI_BASE = 64;
1427 
1428   /**
1429    * @dev List of capabilities (supportInterface bytes4 representations).
1430    */
1431   bytes4 constant MUTABLE = 0xbda0e852;
1432   bytes4 constant BURNABLE = 0x9d118770;
1433   bytes4 constant PAUSABLE = 0xbedb86fb;
1434   bytes4 constant REVOKABLE = 0x20c5429b;
1435 
1436   /**
1437    * @dev Error constants.
1438    */
1439   string constant CAPABILITY_NOT_SUPPORTED = "007001";
1440   string constant TRANSFERS_DISABLED = "007002";
1441   string constant NOT_VALID_XCERT = "007003";
1442   string constant NOT_OWNER_OR_OPERATOR = "007004";
1443 
1444   /**
1445    * @dev This emits when ability of beeing able to transfer Xcerts changes (paused/unpaused).
1446    */
1447   event IsPaused(bool isPaused);
1448 
1449   /**
1450    * @dev Emits when imprint of a token is changed.
1451    * @param _tokenId Id of the Xcert.
1452    * @param _imprint Cryptographic asset imprint.
1453    */
1454   event TokenImprintUpdate(
1455     uint256 indexed _tokenId,
1456     bytes32 _imprint
1457   );
1458 
1459   /**
1460    * @dev Unique ID which determines each Xcert smart contract type by its JSON convention.
1461    * @notice Calculated as keccak256(jsonSchema).
1462    */
1463   bytes32 internal nftSchemaId;
1464 
1465   /**
1466    * @dev Maps NFT ID to imprint.
1467    */
1468   mapping (uint256 => bytes32) internal idToImprint;
1469 
1470   /**
1471    * @dev Maps address to authorization of contract.
1472    */
1473   mapping (address => bool) internal addressToAuthorized;
1474 
1475   /**
1476    * @dev Are Xcerts transfers paused (can be performed) or not.
1477    */
1478   bool public isPaused;
1479 
1480   /**
1481    * @dev Contract constructor.
1482    * @notice When implementing this contract don't forget to set nftSchemaId, nftName, nftSymbol
1483    * and uriBase.
1484    */
1485   constructor()
1486     public
1487   {
1488     supportedInterfaces[0xe08725ee] = true; // Xcert
1489   }
1490 
1491   /**
1492    * @dev Creates a new Xcert.
1493    * @param _to The address that will own the created Xcert.
1494    * @param _id The Xcert to be created by the msg.sender.
1495    * @param _imprint Cryptographic asset imprint.
1496    */
1497   function create(
1498     address _to,
1499     uint256 _id,
1500     bytes32 _imprint
1501   )
1502     external
1503     hasAbilities(ABILITY_CREATE_ASSET)
1504   {
1505     super._create(_to, _id);
1506     idToImprint[_id] = _imprint;
1507   }
1508 
1509   /**
1510    * @dev Change URI base.
1511    * @param _uriBase New uriBase.
1512    */
1513   function setUriBase(
1514     string calldata _uriBase
1515   )
1516     external
1517     hasAbilities(ABILITY_UPDATE_URI_BASE)
1518   {
1519     super._setUriBase(_uriBase);
1520   }
1521 
1522   /**
1523    * @dev Revokes(destroys) a specified Xcert. Reverts if not called from contract owner or 
1524    * authorized address.
1525    * @param _tokenId Id of the Xcert we want to destroy.
1526    */
1527   function revoke(
1528     uint256 _tokenId
1529   )
1530     external
1531     hasAbilities(ABILITY_REVOKE_ASSET)
1532   {
1533     require(supportedInterfaces[REVOKABLE], CAPABILITY_NOT_SUPPORTED);
1534     super._destroy(_tokenId);
1535     delete idToImprint[_tokenId];
1536   }
1537 
1538   /**
1539    * @dev Sets if Xcerts transfers are paused (can be performed) or not.
1540    * @param _isPaused Pause status.
1541    */
1542   function setPause(
1543     bool _isPaused
1544   )
1545     external
1546     hasAbilities(ABILITY_TOGGLE_TRANSFERS)
1547   {
1548     require(supportedInterfaces[PAUSABLE], CAPABILITY_NOT_SUPPORTED);
1549     isPaused = _isPaused;
1550     emit IsPaused(_isPaused);
1551   }
1552 
1553   /**
1554    * @dev Updates Xcert imprint.
1555    * @param _tokenId Id of the Xcert.
1556    * @param _imprint New imprint.
1557    */
1558   function updateTokenImprint(
1559     uint256 _tokenId,
1560     bytes32 _imprint
1561   )
1562     external
1563     hasAbilities(ABILITY_UPDATE_ASSET_IMPRINT)
1564   {
1565     require(supportedInterfaces[MUTABLE], CAPABILITY_NOT_SUPPORTED);
1566     require(idToOwner[_tokenId] != address(0), NOT_VALID_XCERT);
1567     idToImprint[_tokenId] = _imprint;
1568     emit TokenImprintUpdate(_tokenId, _imprint);
1569   }
1570 
1571   /**
1572    * @dev Destroys a specified Xcert. Reverts if not called from Xcert owner or operator.
1573    * @param _tokenId Id of the Xcert we want to destroy.
1574    */
1575   function destroy(
1576     uint256 _tokenId
1577   )
1578     external
1579   {
1580     require(supportedInterfaces[BURNABLE], CAPABILITY_NOT_SUPPORTED);
1581     address tokenOwner = idToOwner[_tokenId];
1582     super._destroy(_tokenId);
1583     require(
1584       tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender],
1585       NOT_OWNER_OR_OPERATOR
1586     );
1587     delete idToImprint[_tokenId];
1588   }
1589 
1590   /**
1591    * @dev Returns a bytes32 of sha256 of json schema representing 0xcert Protocol convention.
1592    * @return Schema id.
1593    */
1594   function schemaId()
1595     external
1596     view
1597     returns (bytes32 _schemaId)
1598   {
1599     _schemaId = nftSchemaId;
1600   }
1601 
1602   /**
1603    * @dev Returns imprint for Xcert.
1604    * @param _tokenId Id of the Xcert.
1605    * @return Token imprint.
1606    */
1607   function tokenImprint(
1608     uint256 _tokenId
1609   )
1610     external
1611     view
1612     returns(bytes32 imprint)
1613   {
1614     imprint = idToImprint[_tokenId];
1615   }
1616 
1617   /**
1618    * @dev Helper methods that actually does the transfer.
1619    * @param _from The current owner of the NFT.
1620    * @param _to The new owner.
1621    * @param _tokenId The NFT to transfer.
1622    */
1623   function _transferFrom(
1624     address _from,
1625     address _to,
1626     uint256 _tokenId
1627   )
1628     internal
1629   {
1630     /**
1631      * if (supportedInterfaces[0xbedb86fb])
1632      * {
1633      *   require(!isPaused, TRANSFERS_DISABLED);
1634      * }
1635      * There is no need to check for pausable capability here since by using logical deduction we 
1636      * can say based on code above that:
1637      * !supportedInterfaces[0xbedb86fb] => !isPaused
1638      * isPaused => supportedInterfaces[0xbedb86fb]
1639      * (supportedInterfaces[0xbedb86fb] ∧ isPaused) <=> isPaused. 
1640      * This saves 200 gas.
1641      */
1642     require(!isPaused, TRANSFERS_DISABLED); 
1643     super._transferFrom(_from, _to, _tokenId);
1644   }
1645 }
1646 
1647 /**
1648  * @title XcertCreateProxy - creates a token on behalf of contracts that have been approved via
1649  * decentralized governance.
1650  */
1651 contract XcertCreateProxy is 
1652   Abilitable 
1653 {
1654 
1655   /**
1656    * @dev List of abilities:
1657    * 2 - Ability to execute create. 
1658    */
1659   uint8 constant ABILITY_TO_EXECUTE = 2;
1660 
1661   /**
1662    * @dev Creates a new NFT.
1663    * @param _xcert Address of the Xcert contract on which the creation will be perfomed.
1664    * @param _to The address that will own the created NFT.
1665    * @param _id The NFT to be created by the msg.sender.
1666    * @param _imprint Cryptographic asset imprint.
1667    */
1668   function create(
1669     address _xcert,
1670     address _to,
1671     uint256 _id,
1672     bytes32 _imprint
1673   )
1674     external
1675     hasAbilities(ABILITY_TO_EXECUTE)
1676   {
1677     Xcert(_xcert).create(_to, _id, _imprint);
1678   }
1679   
1680 }
1681 
1682 pragma experimental ABIEncoderV2;
1683 
1684 
1685 
1686 
1687 /**
1688  * @dev Decentralize exchange, creating, updating and other actions for fundgible and non-fundgible 
1689  * tokens powered by atomic swaps. 
1690  */
1691 contract OrderGateway is
1692   Abilitable
1693 {
1694 
1695   /**
1696    * @dev List of abilities:
1697    * 2 - Ability to set proxies.
1698    */
1699   uint8 constant ABILITY_TO_SET_PROXIES = 2;
1700 
1701   /**
1702    * @dev Xcert abilities.
1703    */
1704   uint8 constant ABILITY_ALLOW_CREATE_ASSET = 32;
1705 
1706   /**
1707    * @dev Error constants.
1708    */
1709   string constant INVALID_SIGNATURE_KIND = "015001";
1710   string constant INVALID_PROXY = "015002";
1711   string constant TAKER_NOT_EQUAL_TO_SENDER = "015003";
1712   string constant SENDER_NOT_TAKER_OR_MAKER = "015004";
1713   string constant CLAIM_EXPIRED = "015005";
1714   string constant INVALID_SIGNATURE = "015006";
1715   string constant ORDER_CANCELED = "015007";
1716   string constant ORDER_ALREADY_PERFORMED = "015008";
1717   string constant MAKER_NOT_EQUAL_TO_SENDER = "015009";
1718   string constant SIGNER_NOT_AUTHORIZED = "015010";
1719 
1720   /**
1721    * @dev Enum of available signature kinds.
1722    * @param eth_sign Signature using eth sign.
1723    * @param trezor Signature from Trezor hardware wallet.
1724    * It differs from web3.eth_sign in the encoding of message length
1725    * (Bitcoin varint encoding vs ascii-decimal, the latter is not
1726    * self-terminating which leads to ambiguities).
1727    * See also:
1728    * https://en.bitcoin.it/wiki/Protocol_documentation#Variable_length_integer
1729    * https://github.com/trezor/trezor-mcu/blob/master/firmware/ethereum.c#L602
1730    * https://github.com/trezor/trezor-mcu/blob/master/firmware/crypto.c#L36 
1731    * @param eip721 Signature using eip721.
1732    */
1733   enum SignatureKind
1734   {
1735     eth_sign,
1736     trezor,
1737     eip712
1738   }
1739 
1740   /**
1741    * Enum of available action kinds.
1742    */
1743   enum ActionKind
1744   {
1745     create,
1746     transfer
1747   }
1748 
1749   /**
1750    * @dev Structure representing what to send and where.
1751    * @param kind Enum representing action kind. 
1752    * @param proxy Id representing approved proxy address.
1753    * @param token Address of the token we are sending.
1754    * @param param1 Address of the sender or imprint.
1755    * @param to Address of the receiver.
1756    * @param value Amount of ERC20 or ID of ERC721.
1757    */
1758   struct ActionData 
1759   {
1760     ActionKind kind;
1761     uint32 proxy;
1762     address token;
1763     bytes32 param1;
1764     address to;
1765     uint256 value;
1766   }
1767 
1768   /**
1769    * @dev Structure representing the signature parts.
1770    * @param r ECDSA signature parameter r.
1771    * @param s ECDSA signature parameter s.
1772    * @param v ECDSA signature parameter v.
1773    * @param kind Type of signature. 
1774    */
1775   struct SignatureData
1776   {
1777     bytes32 r;
1778     bytes32 s;
1779     uint8 v;
1780     SignatureKind kind;
1781   }
1782 
1783   /**
1784    * @dev Structure representing the data needed to do the order.
1785    * @param maker Address of the one that made the claim.
1786    * @param taker Address of the one that is executing the claim.
1787    * @param actions Data of all the actions that should accure it this order.
1788    * @param signature Data from the signed claim.
1789    * @param seed Arbitrary number to facilitate uniqueness of the order's hash. Usually timestamp.
1790    * @param expiration Timestamp of when the claim expires. 0 if indefinet. 
1791    */
1792   struct OrderData 
1793   {
1794     address maker;
1795     address taker;
1796     ActionData[] actions;
1797     uint256 seed;
1798     uint256 expiration;
1799   }
1800 
1801   /** 
1802    * @dev Valid proxy contract addresses.
1803    */
1804   address[] public proxies;
1805 
1806   /**
1807    * @dev Mapping of all cancelled orders.
1808    */
1809   mapping(bytes32 => bool) public orderCancelled;
1810 
1811   /**
1812    * @dev Mapping of all performed orders.
1813    */
1814   mapping(bytes32 => bool) public orderPerformed;
1815 
1816   /**
1817    * @dev This event emmits when tokens change ownership.
1818    */
1819   event Perform(
1820     address indexed _maker,
1821     address indexed _taker,
1822     bytes32 _claim
1823   );
1824 
1825   /**
1826    * @dev This event emmits when transfer order is cancelled.
1827    */
1828   event Cancel(
1829     address indexed _maker,
1830     address indexed _taker,
1831     bytes32 _claim
1832   );
1833 
1834   /**
1835    * @dev This event emmits when proxy address is changed..
1836    */
1837   event ProxyChange(
1838     uint256 indexed _index,
1839     address _proxy
1840   );
1841 
1842   /**
1843    * @dev Adds a verified proxy address. 
1844    * @notice Can be done through a multisig wallet in the future.
1845    * @param _proxy Proxy address.
1846    */
1847   function addProxy(
1848     address _proxy
1849   )
1850     external
1851     hasAbilities(ABILITY_TO_SET_PROXIES)
1852   {
1853     uint256 length = proxies.push(_proxy);
1854     emit ProxyChange(length - 1, _proxy);
1855   }
1856 
1857   /**
1858    * @dev Removes a proxy address. 
1859    * @notice Can be done through a multisig wallet in the future.
1860    * @param _index Index of proxy we are removing.
1861    */
1862   function removeProxy(
1863     uint256 _index
1864   )
1865     external
1866     hasAbilities(ABILITY_TO_SET_PROXIES)
1867   {
1868     proxies[_index] = address(0);
1869     emit ProxyChange(_index, address(0));
1870   }
1871 
1872   /**
1873    * @dev Performs the atomic swap that can exchange, create, update and do other actions for
1874    * fungible and non-fungible tokens.
1875    * @param _data Data required to make the order.
1876    * @param _signature Data from the signature. 
1877    */
1878   function perform(
1879     OrderData memory _data,
1880     SignatureData memory _signature
1881   )
1882     public 
1883   {
1884     require(_data.taker == msg.sender, TAKER_NOT_EQUAL_TO_SENDER);
1885     require(_data.expiration >= now, CLAIM_EXPIRED);
1886 
1887     bytes32 claim = getOrderDataClaim(_data);
1888     require(
1889       isValidSignature(
1890         _data.maker,
1891         claim,
1892         _signature
1893       ), 
1894       INVALID_SIGNATURE
1895     );
1896 
1897     require(!orderCancelled[claim], ORDER_CANCELED);
1898     require(!orderPerformed[claim], ORDER_ALREADY_PERFORMED);
1899 
1900     orderPerformed[claim] = true;
1901 
1902     _doActions(_data);
1903 
1904     emit Perform(
1905       _data.maker,
1906       _data.taker,
1907       claim
1908     );
1909   }
1910 
1911   /** 
1912    * @dev Cancels order.
1913    * @notice You can cancel the same order multiple times. There is no check for whether the order
1914    * was already canceled due to gas optimization. You should either check orderCancelled variable
1915    * or listen to Cancel event if you want to check if an order is already canceled.
1916    * @param _data Data of order to cancel.
1917    */
1918   function cancel(
1919     OrderData memory _data
1920   )
1921     public
1922   {
1923     require(_data.maker == msg.sender, MAKER_NOT_EQUAL_TO_SENDER);
1924 
1925     bytes32 claim = getOrderDataClaim(_data);
1926     require(!orderPerformed[claim], ORDER_ALREADY_PERFORMED);
1927 
1928     orderCancelled[claim] = true;
1929     emit Cancel(
1930       _data.maker,
1931       _data.taker,
1932       claim
1933     );
1934   }
1935 
1936   /**
1937    * @dev Calculates keccak-256 hash of OrderData from parameters.
1938    * @param _orderData Data needed for atomic swap.
1939    * @return keccak-hash of order data.
1940    */
1941   function getOrderDataClaim(
1942     OrderData memory _orderData
1943   )
1944     public
1945     view
1946     returns (bytes32)
1947   {
1948     bytes32 temp = 0x0;
1949 
1950     for(uint256 i = 0; i < _orderData.actions.length; i++)
1951     {
1952       temp = keccak256(
1953         abi.encodePacked(
1954           temp,
1955           _orderData.actions[i].kind,
1956           _orderData.actions[i].proxy,
1957           _orderData.actions[i].token,
1958           _orderData.actions[i].param1,
1959           _orderData.actions[i].to,
1960           _orderData.actions[i].value
1961         )
1962       );
1963     }
1964 
1965     return keccak256(
1966       abi.encodePacked(
1967         address(this),
1968         _orderData.maker,
1969         _orderData.taker,
1970         temp,
1971         _orderData.seed,
1972         _orderData.expiration
1973       )
1974     );
1975   }
1976   
1977   /**
1978    * @dev Verifies if claim signature is valid.
1979    * @param _signer address of signer.
1980    * @param _claim Signed Keccak-256 hash.
1981    * @param _signature Signature data.
1982    */
1983   function isValidSignature(
1984     address _signer,
1985     bytes32 _claim,
1986     SignatureData memory _signature
1987   )
1988     public
1989     pure
1990     returns (bool)
1991   {
1992     if (_signature.kind == SignatureKind.eth_sign)
1993     {
1994       return _signer == ecrecover(
1995         keccak256(
1996           abi.encodePacked(
1997             "\x19Ethereum Signed Message:\n32",
1998             _claim
1999           )
2000         ),
2001         _signature.v,
2002         _signature.r,
2003         _signature.s
2004       );
2005     } else if (_signature.kind == SignatureKind.trezor)
2006     {
2007       return _signer == ecrecover(
2008         keccak256(
2009           abi.encodePacked(
2010             "\x19Ethereum Signed Message:\n\x20",
2011             _claim
2012           )
2013         ),
2014         _signature.v,
2015         _signature.r,
2016         _signature.s
2017       );
2018     } else if (_signature.kind == SignatureKind.eip712)
2019     {
2020       return _signer == ecrecover(
2021         _claim,
2022         _signature.v,
2023         _signature.r,
2024         _signature.s
2025       );
2026     }
2027 
2028     revert(INVALID_SIGNATURE_KIND);
2029   }
2030 
2031   /**
2032    * @dev Helper function that makes transfes.
2033    * @param _order Data needed for order.
2034    */
2035   function _doActions(
2036     OrderData memory _order
2037   )
2038     private
2039   {
2040     for(uint256 i = 0; i < _order.actions.length; i++)
2041     {
2042       require(
2043         proxies[_order.actions[i].proxy] != address(0),
2044         INVALID_PROXY
2045       );
2046 
2047       if (_order.actions[i].kind == ActionKind.create)
2048       {
2049         require(
2050           Abilitable(_order.actions[i].token).isAble(_order.maker, ABILITY_ALLOW_CREATE_ASSET),
2051           SIGNER_NOT_AUTHORIZED
2052         );
2053         
2054         XcertCreateProxy(proxies[_order.actions[i].proxy]).create(
2055           _order.actions[i].token,
2056           _order.actions[i].to,
2057           _order.actions[i].value,
2058           _order.actions[i].param1
2059         );
2060       } 
2061       else if (_order.actions[i].kind == ActionKind.transfer)
2062       {
2063         address from = address(uint160(bytes20(_order.actions[i].param1)));
2064         require(
2065           from == _order.maker
2066           || from == _order.taker,
2067           SENDER_NOT_TAKER_OR_MAKER
2068         );
2069         
2070         Proxy(proxies[_order.actions[i].proxy]).execute(
2071           _order.actions[i].token,
2072           from,
2073           _order.actions[i].to,
2074           _order.actions[i].value
2075         );
2076       }
2077     }
2078   }
2079   
2080 }