1 // File: browser/github/0xcert/ethereum-erc721/src/contracts/ownership/ownable.sol
2 
3 pragma solidity 0.6.2;
4 
5 /**
6  * @dev The contract has an owner address, and provides basic authorization control whitch
7  * simplifies the implementation of user permissions. This contract is based on the source code at:
8  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
9  */
10 contract Ownable
11 {
12 
13   /**
14    * @dev Error constants.
15    */
16   string public constant NOT_CURRENT_OWNER = "018001";
17   string public constant CANNOT_TRANSFER_TO_ZERO_ADDRESS = "018002";
18 
19   /**
20    * @dev Current owner address.
21    */
22   address public owner;
23 
24   /**
25    * @dev An event which is triggered when the owner is changed.
26    * @param previousOwner The address of the previous owner.
27    * @param newOwner The address of the new owner.
28    */
29   event OwnershipTransferred(
30     address indexed previousOwner,
31     address indexed newOwner
32   );
33 
34   /**
35    * @dev The constructor sets the original `owner` of the contract to the sender account.
36    */
37   constructor()
38     public
39   {
40     owner = msg.sender;
41   }
42 
43   /**
44    * @dev Throws if called by any account other than the owner.
45    */
46   modifier onlyOwner()
47   {
48     require(msg.sender == owner, NOT_CURRENT_OWNER);
49     _;
50   }
51 
52   /**
53    * @dev Allows the current owner to transfer control of the contract to a newOwner.
54    * @param _newOwner The address to transfer ownership to.
55    */
56   function transferOwnership(
57     address _newOwner
58   )
59     public
60     onlyOwner
61   {
62     require(_newOwner != address(0), CANNOT_TRANSFER_TO_ZERO_ADDRESS);
63     emit OwnershipTransferred(owner, _newOwner);
64     owner = _newOwner;
65   }
66 
67 }
68 
69 // File: browser/github/0xcert/ethereum-erc721/src/contracts/tokens/erc721-enumerable.sol
70 
71 pragma solidity 0.6.2;
72 
73 /**
74  * @dev Optional enumeration extension for ERC-721 non-fungible token standard.
75  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
76  */
77 interface ERC721Enumerable
78 {
79 
80   /**
81    * @dev Returns a count of valid NFTs tracked by this contract, where each one of them has an
82    * assigned and queryable owner not equal to the zero address.
83    * @return Total supply of NFTs.
84    */
85   function totalSupply()
86     external
87     view
88     returns (uint256);
89 
90   /**
91    * @dev Returns the token identifier for the `_index`th NFT. Sort order is not specified.
92    * @param _index A counter less than `totalSupply()`.
93    * @return Token id.
94    */
95   function tokenByIndex(
96     uint256 _index
97   )
98     external
99     view
100     returns (uint256);
101 
102   /**
103    * @dev Returns the token identifier for the `_index`th NFT assigned to `_owner`. Sort order is
104    * not specified. It throws if `_index` >= `balanceOf(_owner)` or if `_owner` is the zero address,
105    * representing invalid NFTs.
106    * @param _owner An address where we are interested in NFTs owned by them.
107    * @param _index A counter less than `balanceOf(_owner)`.
108    * @return Token id.
109    */
110   function tokenOfOwnerByIndex(
111     address _owner,
112     uint256 _index
113   )
114     external
115     view
116     returns (uint256);
117 
118 }
119 
120 // File: browser/github/0xcert/ethereum-erc721/src/contracts/tokens/erc721-metadata.sol
121 
122 pragma solidity 0.6.2;
123 
124 /**
125  * @dev Optional metadata extension for ERC-721 non-fungible token standard.
126  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
127  */
128 interface ERC721Metadata
129 {
130 
131   /**
132    * @dev Returns a descriptive name for a collection of NFTs in this contract.
133    * @return _name Representing name.
134    */
135   function name()
136     external
137     view
138     returns (string memory _name);
139 
140   /**
141    * @dev Returns a abbreviated name for a collection of NFTs in this contract.
142    * @return _symbol Representing symbol.
143    */
144   function symbol()
145     external
146     view
147     returns (string memory _symbol);
148 
149   /**
150    * @dev Returns a distinct Uniform Resource Identifier (URI) for a given asset. It Throws if
151    * `_tokenId` is not a valid NFT. URIs are defined in RFC3986. The URI may point to a JSON file
152    * that conforms to the "ERC721 Metadata JSON Schema".
153    * @return URI of _tokenId.
154    */
155   function tokenURI(uint256 _tokenId)
156     external
157     view
158     returns (string memory);
159 
160 }
161 
162 // File: browser/github/0xcert/ethereum-erc721/src/contracts/utils/address-utils.sol
163 
164 pragma solidity 0.6.2;
165 
166 /**
167  * @dev Utility library of inline functions on addresses.
168  * @notice Based on:
169  * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
170  * Requires EIP-1052.
171  */
172 library AddressUtils
173 {
174 
175   /**
176    * @dev Returns whether the target address is a contract.
177    * @param _addr Address to check.
178    * @return addressCheck True if _addr is a contract, false if not.
179    */
180   function isContract(
181     address _addr
182   )
183     internal
184     view
185     returns (bool addressCheck)
186   {
187     // This method relies in extcodesize, which returns 0 for contracts in
188     // construction, since the code is only stored at the end of the
189     // constructor execution.
190 
191     // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
192     // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
193     // for accounts without code, i.e. `keccak256('')`
194     bytes32 codehash;
195     bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
196     assembly { codehash := extcodehash(_addr) } // solhint-disable-line
197     addressCheck = (codehash != 0x0 && codehash != accountHash);
198   }
199 
200 }
201 
202 // File: browser/github/0xcert/ethereum-erc721/src/contracts/utils/erc165.sol
203 
204 pragma solidity 0.6.2;
205 
206 /**
207  * @dev A standard for detecting smart contract interfaces. 
208  * See: https://eips.ethereum.org/EIPS/eip-165.
209  */
210 interface ERC165
211 {
212 
213   /**
214    * @dev Checks if the smart contract includes a specific interface.
215    * @notice This function uses less than 30,000 gas.
216    * @param _interfaceID The interface identifier, as specified in ERC-165.
217    * @return True if _interfaceID is supported, false otherwise.
218    */
219   function supportsInterface(
220     bytes4 _interfaceID
221   )
222     external
223     view
224     returns (bool);
225     
226 }
227 
228 // File: browser/github/0xcert/ethereum-erc721/src/contracts/utils/supports-interface.sol
229 
230 pragma solidity 0.6.2;
231 
232 
233 /**
234  * @dev Implementation of standard for detect smart contract interfaces.
235  */
236 contract SupportsInterface is
237   ERC165
238 {
239 
240   /**
241    * @dev Mapping of supported intefraces.
242    * @notice You must not set element 0xffffffff to true.
243    */
244   mapping(bytes4 => bool) internal supportedInterfaces;
245 
246   /**
247    * @dev Contract constructor.
248    */
249   constructor()
250     public
251   {
252     supportedInterfaces[0x01ffc9a7] = true; // ERC165
253   }
254 
255   /**
256    * @dev Function to check which interfaces are suported by this contract.
257    * @param _interfaceID Id of the interface.
258    * @return True if _interfaceID is supported, false otherwise.
259    */
260   function supportsInterface(
261     bytes4 _interfaceID
262   )
263     external
264     override
265     view
266     returns (bool)
267   {
268     return supportedInterfaces[_interfaceID];
269   }
270 
271 }
272 
273 // File: browser/github/0xcert/ethereum-erc721/src/contracts/math/safe-math.sol
274 
275 pragma solidity 0.6.2;
276 
277 /**
278  * @dev Math operations with safety checks that throw on error. This contract is based on the
279  * source code at:
280  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol.
281  */
282 library SafeMath
283 {
284   /**
285    * List of revert message codes. Implementing dApp should handle showing the correct message.
286    * Based on 0xcert framework error codes.
287    */
288   string constant OVERFLOW = "008001";
289   string constant SUBTRAHEND_GREATER_THEN_MINUEND = "008002";
290   string constant DIVISION_BY_ZERO = "008003";
291 
292   /**
293    * @dev Multiplies two numbers, reverts on overflow.
294    * @param _factor1 Factor number.
295    * @param _factor2 Factor number.
296    * @return product The product of the two factors.
297    */
298   function mul(
299     uint256 _factor1,
300     uint256 _factor2
301   )
302     internal
303     pure
304     returns (uint256 product)
305   {
306     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
307     // benefit is lost if 'b' is also tested.
308     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
309     if (_factor1 == 0)
310     {
311       return 0;
312     }
313 
314     product = _factor1 * _factor2;
315     require(product / _factor1 == _factor2, OVERFLOW);
316   }
317 
318   /**
319    * @dev Integer division of two numbers, truncating the quotient, reverts on division by zero.
320    * @param _dividend Dividend number.
321    * @param _divisor Divisor number.
322    * @return quotient The quotient.
323    */
324   function div(
325     uint256 _dividend,
326     uint256 _divisor
327   )
328     internal
329     pure
330     returns (uint256 quotient)
331   {
332     // Solidity automatically asserts when dividing by 0, using all gas.
333     require(_divisor > 0, DIVISION_BY_ZERO);
334     quotient = _dividend / _divisor;
335     // assert(_dividend == _divisor * quotient + _dividend % _divisor); // There is no case in which this doesn't hold.
336   }
337 
338   /**
339    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
340    * @param _minuend Minuend number.
341    * @param _subtrahend Subtrahend number.
342    * @return difference Difference.
343    */
344   function sub(
345     uint256 _minuend,
346     uint256 _subtrahend
347   )
348     internal
349     pure
350     returns (uint256 difference)
351   {
352     require(_subtrahend <= _minuend, SUBTRAHEND_GREATER_THEN_MINUEND);
353     difference = _minuend - _subtrahend;
354   }
355 
356   /**
357    * @dev Adds two numbers, reverts on overflow.
358    * @param _addend1 Number.
359    * @param _addend2 Number.
360    * @return sum Sum.
361    */
362   function add(
363     uint256 _addend1,
364     uint256 _addend2
365   )
366     internal
367     pure
368     returns (uint256 sum)
369   {
370     sum = _addend1 + _addend2;
371     require(sum >= _addend1, OVERFLOW);
372   }
373 
374   /**
375     * @dev Divides two numbers and returns the remainder (unsigned integer modulo), reverts when
376     * dividing by zero.
377     * @param _dividend Number.
378     * @param _divisor Number.
379     * @return remainder Remainder.
380     */
381   function mod(
382     uint256 _dividend,
383     uint256 _divisor
384   )
385     internal
386     pure
387     returns (uint256 remainder)
388   {
389     require(_divisor != 0, DIVISION_BY_ZERO);
390     remainder = _dividend % _divisor;
391   }
392 
393 }
394 
395 // File: browser/github/0xcert/ethereum-erc721/src/contracts/tokens/erc721-token-receiver.sol
396 
397 pragma solidity 0.6.2;
398 
399 /**
400  * @dev ERC-721 interface for accepting safe transfers.
401  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
402  */
403 interface ERC721TokenReceiver
404 {
405 
406   /**
407    * @dev Handle the receipt of a NFT. The ERC721 smart contract calls this function on the
408    * recipient after a `transfer`. This function MAY throw to revert and reject the transfer. Return
409    * of other than the magic value MUST result in the transaction being reverted.
410    * Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))` unless throwing.
411    * @notice The contract address is always the message sender. A wallet/broker/auction application
412    * MUST implement the wallet interface if it will accept safe transfers.
413    * @param _operator The address which called `safeTransferFrom` function.
414    * @param _from The address which previously owned the token.
415    * @param _tokenId The NFT identifier which is being transferred.
416    * @param _data Additional data with no specified format.
417    * @return Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
418    */
419   function onERC721Received(
420     address _operator,
421     address _from,
422     uint256 _tokenId,
423     bytes calldata _data
424   )
425     external
426     returns(bytes4);
427 
428 }
429 
430 // File: browser/github/0xcert/ethereum-erc721/src/contracts/tokens/erc721.sol
431 
432 pragma solidity 0.6.2;
433 
434 /**
435  * @dev ERC-721 non-fungible token standard.
436  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
437  */
438 interface ERC721
439 {
440 
441   /**
442    * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
443    * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
444    * number of NFTs may be created and assigned without emitting Transfer. At the time of any
445    * transfer, the approved address for that NFT (if any) is reset to none.
446    */
447   event Transfer(
448     address indexed _from,
449     address indexed _to,
450     uint256 indexed _tokenId
451   );
452 
453   /**
454    * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
455    * address indicates there is no approved address. When a Transfer event emits, this also
456    * indicates that the approved address for that NFT (if any) is reset to none.
457    */
458   event Approval(
459     address indexed _owner,
460     address indexed _approved,
461     uint256 indexed _tokenId
462   );
463 
464   /**
465    * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
466    * all NFTs of the owner.
467    */
468   event ApprovalForAll(
469     address indexed _owner,
470     address indexed _operator,
471     bool _approved
472   );
473 
474   /**
475    * @dev Transfers the ownership of an NFT from one address to another address.
476    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
477    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
478    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
479    * function checks if `_to` is a smart contract (code size > 0). If so, it calls
480    * `onERC721Received` on `_to` and throws if the return value is not
481    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
482    * @param _from The current owner of the NFT.
483    * @param _to The new owner.
484    * @param _tokenId The NFT to transfer.
485    * @param _data Additional data with no specified format, sent in call to `_to`.
486    */
487   function safeTransferFrom(
488     address _from,
489     address _to,
490     uint256 _tokenId,
491     bytes calldata _data
492   )
493     external;
494 
495   /**
496    * @dev Transfers the ownership of an NFT from one address to another address.
497    * @notice This works identically to the other function with an extra data parameter, except this
498    * function just sets data to ""
499    * @param _from The current owner of the NFT.
500    * @param _to The new owner.
501    * @param _tokenId The NFT to transfer.
502    */
503   function safeTransferFrom(
504     address _from,
505     address _to,
506     uint256 _tokenId
507   )
508     external;
509 
510   /**
511    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
512    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
513    * address. Throws if `_tokenId` is not a valid NFT.
514    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
515    * they mayb be permanently lost.
516    * @param _from The current owner of the NFT.
517    * @param _to The new owner.
518    * @param _tokenId The NFT to transfer.
519    */
520   function transferFrom(
521     address _from,
522     address _to,
523     uint256 _tokenId
524   )
525     external;
526 
527   /**
528    * @dev Set or reaffirm the approved address for an NFT.
529    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
530    * the current NFT owner, or an authorized operator of the current owner.
531    * @param _approved The new approved NFT controller.
532    * @param _tokenId The NFT to approve.
533    */
534   function approve(
535     address _approved,
536     uint256 _tokenId
537   )
538     external;
539 
540   /**
541    * @dev Enables or disables approval for a third party ("operator") to manage all of
542    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
543    * @notice The contract MUST allow multiple operators per owner.
544    * @param _operator Address to add to the set of authorized operators.
545    * @param _approved True if the operators is approved, false to revoke approval.
546    */
547   function setApprovalForAll(
548     address _operator,
549     bool _approved
550   )
551     external;
552 
553   /**
554    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
555    * considered invalid, and this function throws for queries about the zero address.
556    * @param _owner Address for whom to query the balance.
557    * @return Balance of _owner.
558    */
559   function balanceOf(
560     address _owner
561   )
562     external
563     view
564     returns (uint256);
565 
566   /**
567    * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered
568    * invalid, and queries about them do throw.
569    * @param _tokenId The identifier for an NFT.
570    * @return Address of _tokenId owner.
571    */
572   function ownerOf(
573     uint256 _tokenId
574   )
575     external
576     view
577     returns (address);
578 
579   /**
580    * @dev Get the approved address for a single NFT.
581    * @notice Throws if `_tokenId` is not a valid NFT.
582    * @param _tokenId The NFT to find the approved address for.
583    * @return Address that _tokenId is approved for.
584    */
585   function getApproved(
586     uint256 _tokenId
587   )
588     external
589     view
590     returns (address);
591 
592   /**
593    * @dev Returns true if `_operator` is an approved operator for `_owner`, false otherwise.
594    * @param _owner The address that owns the NFTs.
595    * @param _operator The address that acts on behalf of the owner.
596    * @return True if approved for all, false otherwise.
597    */
598   function isApprovedForAll(
599     address _owner,
600     address _operator
601   )
602     external
603     view
604     returns (bool);
605 
606 }
607 
608 // File: browser/github/0xcert/ethereum-erc721/src/contracts/tokens/nf-token.sol
609 
610 pragma solidity 0.6.2;
611 
612 
613 
614 
615 
616 
617 /**
618  * @dev Implementation of ERC-721 non-fungible token standard.
619  */
620 contract NFToken is
621   ERC721,
622   SupportsInterface
623 {
624   using SafeMath for uint256;
625   using AddressUtils for address;
626 
627   /**
628    * List of revert message codes. Implementing dApp should handle showing the correct message.
629    * Based on 0xcert framework error codes.
630    */
631   string constant ZERO_ADDRESS = "003001";
632   string constant NOT_VALID_NFT = "003002";
633   string constant NOT_OWNER_OR_OPERATOR = "003003";
634   string constant NOT_OWNER_APPROWED_OR_OPERATOR = "003004";
635   string constant NOT_ABLE_TO_RECEIVE_NFT = "003005";
636   string constant NFT_ALREADY_EXISTS = "003006";
637   string constant NOT_OWNER = "003007";
638   string constant IS_OWNER = "003008";
639 
640   /**
641    * @dev Magic value of a smart contract that can recieve NFT.
642    * Equal to: bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")).
643    */
644   bytes4 internal constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
645 
646   /**
647    * @dev A mapping from NFT ID to the address that owns it.
648    */
649   mapping (uint256 => address) internal idToOwner;
650 
651   /**
652    * @dev Mapping from NFT ID to approved address.
653    */
654   mapping (uint256 => address) internal idToApproval;
655 
656    /**
657    * @dev Mapping from owner address to count of his tokens.
658    */
659   mapping (address => uint256) private ownerToNFTokenCount;
660 
661   /**
662    * @dev Mapping from owner address to mapping of operator addresses.
663    */
664   mapping (address => mapping (address => bool)) internal ownerToOperators;
665 
666   /**
667    * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
668    * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
669    * number of NFTs may be created and assigned without emitting Transfer. At the time of any
670    * transfer, the approved address for that NFT (if any) is reset to none.
671    * @param _from Sender of NFT (if address is zero address it indicates token creation).
672    * @param _to Receiver of NFT (if address is zero address it indicates token destruction).
673    * @param _tokenId The NFT that got transfered.
674    */
675   event Transfer(
676     address indexed _from,
677     address indexed _to,
678     uint256 indexed _tokenId
679   );
680 
681   /**
682    * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
683    * address indicates there is no approved address. When a Transfer event emits, this also
684    * indicates that the approved address for that NFT (if any) is reset to none.
685    * @param _owner Owner of NFT.
686    * @param _approved Address that we are approving.
687    * @param _tokenId NFT which we are approving.
688    */
689   event Approval(
690     address indexed _owner,
691     address indexed _approved,
692     uint256 indexed _tokenId
693   );
694 
695   /**
696    * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
697    * all NFTs of the owner.
698    * @param _owner Owner of NFT.
699    * @param _operator Address to which we are setting operator rights.
700    * @param _approved Status of operator rights(true if operator rights are given and false if
701    * revoked).
702    */
703   event ApprovalForAll(
704     address indexed _owner,
705     address indexed _operator,
706     bool _approved
707   );
708 
709   /**
710    * @dev Guarantees that the msg.sender is an owner or operator of the given NFT.
711    * @param _tokenId ID of the NFT to validate.
712    */
713   modifier canOperate(
714     uint256 _tokenId
715   )
716   {
717     address tokenOwner = idToOwner[_tokenId];
718     require(tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender], NOT_OWNER_OR_OPERATOR);
719     _;
720   }
721 
722   /**
723    * @dev Guarantees that the msg.sender is allowed to transfer NFT.
724    * @param _tokenId ID of the NFT to transfer.
725    */
726   modifier canTransfer(
727     uint256 _tokenId
728   )
729   {
730     address tokenOwner = idToOwner[_tokenId];
731     require(
732       tokenOwner == msg.sender
733       || idToApproval[_tokenId] == msg.sender
734       || ownerToOperators[tokenOwner][msg.sender],
735       NOT_OWNER_APPROWED_OR_OPERATOR
736     );
737     _;
738   }
739 
740   /**
741    * @dev Guarantees that _tokenId is a valid Token.
742    * @param _tokenId ID of the NFT to validate.
743    */
744   modifier validNFToken(
745     uint256 _tokenId
746   )
747   {
748     require(idToOwner[_tokenId] != address(0), NOT_VALID_NFT);
749     _;
750   }
751 
752   /**
753    * @dev Contract constructor.
754    */
755   constructor()
756     public
757   {
758     supportedInterfaces[0x80ac58cd] = true; // ERC721
759   }
760 
761   /**
762    * @dev Transfers the ownership of an NFT from one address to another address. This function can
763    * be changed to payable.
764    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
765    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
766    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
767    * function checks if `_to` is a smart contract (code size > 0). If so, it calls
768    * `onERC721Received` on `_to` and throws if the return value is not
769    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
770    * @param _from The current owner of the NFT.
771    * @param _to The new owner.
772    * @param _tokenId The NFT to transfer.
773    * @param _data Additional data with no specified format, sent in call to `_to`.
774    */
775   function safeTransferFrom(
776     address _from,
777     address _to,
778     uint256 _tokenId,
779     bytes calldata _data
780   )
781     external
782     override
783   {
784     _safeTransferFrom(_from, _to, _tokenId, _data);
785   }
786 
787   /**
788    * @dev Transfers the ownership of an NFT from one address to another address. This function can
789    * be changed to payable.
790    * @notice This works identically to the other function with an extra data parameter, except this
791    * function just sets data to ""
792    * @param _from The current owner of the NFT.
793    * @param _to The new owner.
794    * @param _tokenId The NFT to transfer.
795    */
796   function safeTransferFrom(
797     address _from,
798     address _to,
799     uint256 _tokenId
800   )
801     external
802     override
803   {
804     _safeTransferFrom(_from, _to, _tokenId, "");
805   }
806 
807   /**
808    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
809    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
810    * address. Throws if `_tokenId` is not a valid NFT. This function can be changed to payable.
811    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
812    * they maybe be permanently lost.
813    * @param _from The current owner of the NFT.
814    * @param _to The new owner.
815    * @param _tokenId The NFT to transfer.
816    */
817   function transferFrom(
818     address _from,
819     address _to,
820     uint256 _tokenId
821   )
822     external
823     override
824     canTransfer(_tokenId)
825     validNFToken(_tokenId)
826   {
827     address tokenOwner = idToOwner[_tokenId];
828     require(tokenOwner == _from, NOT_OWNER);
829     require(_to != address(0), ZERO_ADDRESS);
830 
831     _transfer(_to, _tokenId);
832   }
833 
834   /**
835    * @dev Set or reaffirm the approved address for an NFT. This function can be changed to payable.
836    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
837    * the current NFT owner, or an authorized operator of the current owner.
838    * @param _approved Address to be approved for the given NFT ID.
839    * @param _tokenId ID of the token to be approved.
840    */
841   function approve(
842     address _approved,
843     uint256 _tokenId
844   )
845     external
846     override
847     canOperate(_tokenId)
848     validNFToken(_tokenId)
849   {
850     address tokenOwner = idToOwner[_tokenId];
851     require(_approved != tokenOwner, IS_OWNER);
852 
853     idToApproval[_tokenId] = _approved;
854     emit Approval(tokenOwner, _approved, _tokenId);
855   }
856 
857   /**
858    * @dev Enables or disables approval for a third party ("operator") to manage all of
859    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
860    * @notice This works even if sender doesn't own any tokens at the time.
861    * @param _operator Address to add to the set of authorized operators.
862    * @param _approved True if the operators is approved, false to revoke approval.
863    */
864   function setApprovalForAll(
865     address _operator,
866     bool _approved
867   )
868     external
869     override
870   {
871     ownerToOperators[msg.sender][_operator] = _approved;
872     emit ApprovalForAll(msg.sender, _operator, _approved);
873   }
874 
875   /**
876    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
877    * considered invalid, and this function throws for queries about the zero address.
878    * @param _owner Address for whom to query the balance.
879    * @return Balance of _owner.
880    */
881   function balanceOf(
882     address _owner
883   )
884     external
885     override
886     view
887     returns (uint256)
888   {
889     require(_owner != address(0), ZERO_ADDRESS);
890     return _getOwnerNFTCount(_owner);
891   }
892 
893   /**
894    * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered
895    * invalid, and queries about them do throw.
896    * @param _tokenId The identifier for an NFT.
897    * @return _owner Address of _tokenId owner.
898    */
899   function ownerOf(
900     uint256 _tokenId
901   )
902     external
903     override
904     view
905     returns (address _owner)
906   {
907     _owner = idToOwner[_tokenId];
908     require(_owner != address(0), NOT_VALID_NFT);
909   }
910 
911   /**
912    * @dev Get the approved address for a single NFT.
913    * @notice Throws if `_tokenId` is not a valid NFT.
914    * @param _tokenId ID of the NFT to query the approval of.
915    * @return Address that _tokenId is approved for.
916    */
917   function getApproved(
918     uint256 _tokenId
919   )
920     external
921     override
922     view
923     validNFToken(_tokenId)
924     returns (address)
925   {
926     return idToApproval[_tokenId];
927   }
928 
929   /**
930    * @dev Checks if `_operator` is an approved operator for `_owner`.
931    * @param _owner The address that owns the NFTs.
932    * @param _operator The address that acts on behalf of the owner.
933    * @return True if approved for all, false otherwise.
934    */
935   function isApprovedForAll(
936     address _owner,
937     address _operator
938   )
939     external
940     override
941     view
942     returns (bool)
943   {
944     return ownerToOperators[_owner][_operator];
945   }
946 
947   /**
948    * @dev Actually preforms the transfer.
949    * @notice Does NO checks.
950    * @param _to Address of a new owner.
951    * @param _tokenId The NFT that is being transferred.
952    */
953   function _transfer(
954     address _to,
955     uint256 _tokenId
956   )
957     internal
958   {
959     address from = idToOwner[_tokenId];
960     _clearApproval(_tokenId);
961 
962     _removeNFToken(from, _tokenId);
963     _addNFToken(_to, _tokenId);
964 
965     emit Transfer(from, _to, _tokenId);
966   }
967 
968   /**
969    * @dev Mints a new NFT.
970    * @notice This is an internal function which should be called from user-implemented external
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
981     virtual
982   {
983     require(_to != address(0), ZERO_ADDRESS);
984     require(idToOwner[_tokenId] == address(0), NFT_ALREADY_EXISTS);
985 
986     _addNFToken(_to, _tokenId);
987 
988     emit Transfer(address(0), _to, _tokenId);
989   }
990 
991   /**
992    * @dev Burns a NFT.
993    * @notice This is an internal function which should be called from user-implemented external burn
994    * function. Its purpose is to show and properly initialize data structures when using this
995    * implementation. Also, note that this burn implementation allows the minter to re-mint a burned
996    * NFT.
997    * @param _tokenId ID of the NFT to be burned.
998    */
999   function _burn(
1000     uint256 _tokenId
1001   )
1002     internal
1003     virtual
1004     validNFToken(_tokenId)
1005   {
1006     address tokenOwner = idToOwner[_tokenId];
1007     _clearApproval(_tokenId);
1008     _removeNFToken(tokenOwner, _tokenId);
1009     emit Transfer(tokenOwner, address(0), _tokenId);
1010   }
1011 
1012   /**
1013    * @dev Removes a NFT from owner.
1014    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
1015    * @param _from Address from wich we want to remove the NFT.
1016    * @param _tokenId Which NFT we want to remove.
1017    */
1018   function _removeNFToken(
1019     address _from,
1020     uint256 _tokenId
1021   )
1022     internal
1023     virtual
1024   {
1025     require(idToOwner[_tokenId] == _from, NOT_OWNER);
1026     ownerToNFTokenCount[_from] = ownerToNFTokenCount[_from] - 1;
1027     delete idToOwner[_tokenId];
1028   }
1029 
1030   /**
1031    * @dev Assignes a new NFT to owner.
1032    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
1033    * @param _to Address to wich we want to add the NFT.
1034    * @param _tokenId Which NFT we want to add.
1035    */
1036   function _addNFToken(
1037     address _to,
1038     uint256 _tokenId
1039   )
1040     internal
1041     virtual
1042   {
1043     require(idToOwner[_tokenId] == address(0), NFT_ALREADY_EXISTS);
1044 
1045     idToOwner[_tokenId] = _to;
1046     ownerToNFTokenCount[_to] = ownerToNFTokenCount[_to].add(1);
1047   }
1048 
1049   /**
1050    * @dev Helper function that gets NFT count of owner. This is needed for overriding in enumerable
1051    * extension to remove double storage (gas optimization) of owner nft count.
1052    * @param _owner Address for whom to query the count.
1053    * @return Number of _owner NFTs.
1054    */
1055   function _getOwnerNFTCount(
1056     address _owner
1057   )
1058     internal
1059     virtual
1060     view
1061     returns (uint256)
1062   {
1063     return ownerToNFTokenCount[_owner];
1064   }
1065 
1066   /**
1067    * @dev Actually perform the safeTransferFrom.
1068    * @param _from The current owner of the NFT.
1069    * @param _to The new owner.
1070    * @param _tokenId The NFT to transfer.
1071    * @param _data Additional data with no specified format, sent in call to `_to`.
1072    */
1073   function _safeTransferFrom(
1074     address _from,
1075     address _to,
1076     uint256 _tokenId,
1077     bytes memory _data
1078   )
1079     private
1080     canTransfer(_tokenId)
1081     validNFToken(_tokenId)
1082   {
1083     address tokenOwner = idToOwner[_tokenId];
1084     require(tokenOwner == _from, NOT_OWNER);
1085     require(_to != address(0), ZERO_ADDRESS);
1086 
1087     _transfer(_to, _tokenId);
1088 
1089     if (_to.isContract())
1090     {
1091       bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
1092       require(retval == MAGIC_ON_ERC721_RECEIVED, NOT_ABLE_TO_RECEIVE_NFT);
1093     }
1094   }
1095 
1096   /**
1097    * @dev Clears the current approval of a given NFT ID.
1098    * @param _tokenId ID of the NFT to be transferred.
1099    */
1100   function _clearApproval(
1101     uint256 _tokenId
1102   )
1103     private
1104   {
1105     if (idToApproval[_tokenId] != address(0))
1106     {
1107       delete idToApproval[_tokenId];
1108     }
1109   }
1110 
1111 }
1112 
1113 // File: browser/github/0xcert/ethereum-erc721/src/contracts/tokens/nf-token-enumerable-metadata.sol
1114 
1115 pragma solidity 0.6.2;
1116 
1117 
1118 
1119 
1120 /**
1121  * @dev Optional metadata implementation for ERC-721 non-fungible token standard.
1122  */
1123 abstract contract NFTokenEnumerableMetadata is
1124     NFToken,
1125     ERC721Metadata,
1126     ERC721Enumerable
1127 {
1128 
1129   /**
1130    * @dev A descriptive name for a collection of NFTs.
1131    */
1132   string internal nftName;
1133 
1134   /**
1135    * @dev An abbreviated name for NFTokens.
1136    */
1137   string internal nftSymbol;
1138   
1139     /**
1140    * @dev An uri to represent the metadata for this contract.
1141    */
1142   string internal nftContractMetadataUri;
1143 
1144   /**
1145    * @dev Mapping from NFT ID to metadata uri.
1146    */
1147   mapping (uint256 => string) internal idToUri;
1148   
1149   /**
1150    * @dev Mapping from NFT ID to encrypted value.
1151    */
1152   mapping (uint256 => string) internal idToPayload;
1153 
1154   /**
1155    * @dev Contract constructor.
1156    * @notice When implementing this contract don't forget to set nftName and nftSymbol.
1157    */
1158   constructor()
1159     public
1160   {
1161     supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
1162     supportedInterfaces[0x780e9d63] = true; // ERC721Enumerable
1163   }
1164 
1165   /**
1166    * @dev Returns a descriptive name for a collection of NFTokens.
1167    * @return _name Representing name.
1168    */
1169   function name()
1170     external
1171     override
1172     view
1173     returns (string memory _name)
1174   {
1175     _name = nftName;
1176   }
1177 
1178   /**
1179    * @dev Returns an abbreviated name for NFTokens.
1180    * @return _symbol Representing symbol.
1181    */
1182   function symbol()
1183     external
1184     override
1185     view
1186     returns (string memory _symbol)
1187   {
1188     _symbol = nftSymbol;
1189   }
1190 
1191   /**
1192    * @dev A distinct URI (RFC 3986) for a given NFT.
1193    * @param _tokenId Id for which we want uri.
1194    * @return URI of _tokenId.
1195    */
1196   function tokenURI(
1197     uint256 _tokenId
1198   )
1199     external
1200     override
1201     view
1202     validNFToken(_tokenId)
1203     returns (string memory)
1204   {
1205     return idToUri[_tokenId];
1206   }
1207   
1208     /**
1209    * @dev A distinct URI (RFC 3986) for a given NFT.
1210    * @param _tokenId Id for which we want uri.
1211    * @return URI of _tokenId.
1212    */
1213   function tokenPayload(
1214     uint256 _tokenId
1215   )
1216     external
1217     view
1218     validNFToken(_tokenId)
1219     returns (string memory)
1220   {
1221     return idToPayload[_tokenId];
1222   }
1223 
1224   /**
1225    * @dev Set a distinct URI (RFC 3986) for a given NFT ID.
1226    * @notice This is an internal function which should be called from user-implemented external
1227    * function. Its purpose is to show and properly initialize data structures when using this
1228    * implementation.
1229    * @param _tokenId Id for which we want URI.
1230    * @param _uri String representing RFC 3986 URI.
1231    */
1232   function _setTokenUri(
1233     uint256 _tokenId,
1234     string memory _uri
1235   )
1236     internal
1237     validNFToken(_tokenId)
1238   {
1239     idToUri[_tokenId] = _uri;
1240   }
1241   
1242 function _setTokenPayload(
1243     uint256 _tokenId,
1244     string memory _uri
1245   )
1246     internal
1247     validNFToken(_tokenId)
1248   {
1249     idToPayload[_tokenId] = _uri;
1250   }
1251   
1252   /**
1253    * List of revert message codes. Implementing dApp should handle showing the correct message.
1254    * Based on 0xcert framework error codes.
1255    */
1256   string constant INVALID_INDEX = "005007";
1257 
1258   /**
1259    * @dev Array of all NFT IDs.
1260    */
1261   uint256[] internal tokens;
1262 
1263   /**
1264    * @dev Mapping from token ID to its index in global tokens array.
1265    */
1266   mapping(uint256 => uint256) internal idToIndex;
1267 
1268   /**
1269    * @dev Mapping from owner to list of owned NFT IDs.
1270    */
1271   mapping(address => uint256[]) internal ownerToIds;
1272 
1273   /**
1274    * @dev Mapping from NFT ID to its index in the owner tokens list.
1275    */
1276   mapping(uint256 => uint256) internal idToOwnerIndex;
1277   
1278   /**
1279    * @dev Returns the count of all existing NFTokens.
1280    * @return Total supply of NFTs.
1281    */
1282   function totalSupply()
1283     external
1284     override
1285     view
1286     returns (uint256)
1287   {
1288     return tokens.length;
1289   }
1290 
1291   /**
1292    * @dev Returns NFT ID by its index.
1293    * @param _index A counter less than `totalSupply()`.
1294    * @return Token id.
1295    */
1296   function tokenByIndex(
1297     uint256 _index
1298   )
1299     external
1300     override
1301     view
1302     returns (uint256)
1303   {
1304     require(_index < tokens.length, INVALID_INDEX);
1305     return tokens[_index];
1306   }
1307 
1308   /**
1309    * @dev returns the n-th NFT ID from a list of owner's tokens.
1310    * @param _owner Token owner's address.
1311    * @param _index Index number representing n-th token in owner's list of tokens.
1312    * @return Token id.
1313    */
1314   function tokenOfOwnerByIndex(
1315     address _owner,
1316     uint256 _index
1317   )
1318     external
1319     override
1320     view
1321     returns (uint256)
1322   {
1323     require(_index < ownerToIds[_owner].length, INVALID_INDEX);
1324     return ownerToIds[_owner][_index];
1325   }
1326 
1327   /**
1328    * @dev Mints a new NFT.
1329    * @notice This is an internal function which should be called from user-implemented external
1330    * mint function. Its purpose is to show and properly initialize data structures when using this
1331    * implementation.
1332    * @param _to The address that will own the minted NFT.
1333    * @param _tokenId of the NFT to be minted by the msg.sender.
1334    */
1335   function _mint(
1336     address _to,
1337     uint256 _tokenId
1338   )
1339     internal
1340     override
1341     virtual
1342   {
1343     super._mint(_to, _tokenId);
1344     tokens.push(_tokenId);
1345     idToIndex[_tokenId] = tokens.length - 1;
1346   }
1347 
1348   /**
1349    * @dev Burns a NFT.
1350    * @notice This is an internal function which should be called from user-implemented external
1351    * burn function. Its purpose is to show and properly initialize data structures when using this
1352    * implementation. Also, note that this burn implementation allows the minter to re-mint a burned
1353    * NFT.
1354    * @param _tokenId ID of the NFT to be burned.
1355    */
1356   function _burn(
1357     uint256 _tokenId
1358   )
1359     internal
1360     override
1361     virtual
1362   {
1363     super._burn(_tokenId);
1364     
1365     if (bytes(idToUri[_tokenId]).length != 0)
1366     {
1367       delete idToUri[_tokenId];
1368     }
1369     
1370     if (bytes(idToPayload[_tokenId]).length != 0)
1371     {
1372       delete idToPayload[_tokenId];
1373     }
1374     
1375     uint256 tokenIndex = idToIndex[_tokenId];
1376     uint256 lastTokenIndex = tokens.length - 1;
1377     uint256 lastToken = tokens[lastTokenIndex];
1378 
1379     tokens[tokenIndex] = lastToken;
1380 
1381     tokens.pop();
1382     // This wastes gas if you are burning the last token but saves a little gas if you are not.
1383     idToIndex[lastToken] = tokenIndex;
1384     idToIndex[_tokenId] = 0;
1385   }
1386 
1387   /**
1388    * @dev Removes a NFT from an address.
1389    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
1390    * @param _from Address from wich we want to remove the NFT.
1391    * @param _tokenId Which NFT we want to remove.
1392    */
1393   function _removeNFToken(
1394     address _from,
1395     uint256 _tokenId
1396   )
1397     internal
1398     override
1399     virtual
1400   {
1401     require(idToOwner[_tokenId] == _from, NOT_OWNER);
1402     delete idToOwner[_tokenId];
1403 
1404     uint256 tokenToRemoveIndex = idToOwnerIndex[_tokenId];
1405     uint256 lastTokenIndex = ownerToIds[_from].length - 1;
1406 
1407     if (lastTokenIndex != tokenToRemoveIndex)
1408     {
1409       uint256 lastToken = ownerToIds[_from][lastTokenIndex];
1410       ownerToIds[_from][tokenToRemoveIndex] = lastToken;
1411       idToOwnerIndex[lastToken] = tokenToRemoveIndex;
1412     }
1413 
1414     ownerToIds[_from].pop();
1415   }
1416 
1417   /**
1418    * @dev Assignes a new NFT to an address.
1419    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
1420    * @param _to Address to wich we want to add the NFT.
1421    * @param _tokenId Which NFT we want to add.
1422    */
1423   function _addNFToken(
1424     address _to,
1425     uint256 _tokenId
1426   )
1427     internal
1428     override
1429     virtual
1430   {
1431     require(idToOwner[_tokenId] == address(0), NFT_ALREADY_EXISTS);
1432     idToOwner[_tokenId] = _to;
1433 
1434     ownerToIds[_to].push(_tokenId);
1435     idToOwnerIndex[_tokenId] = ownerToIds[_to].length - 1;
1436   }
1437 
1438   /**
1439    * @dev Helper function that gets NFT count of owner. This is needed for overriding in enumerable
1440    * extension to remove double storage(gas optimization) of owner nft count.
1441    * @param _owner Address for whom to query the count.
1442    * @return Number of _owner NFTs.
1443    */
1444   function _getOwnerNFTCount(
1445     address _owner
1446   )
1447     internal
1448     override
1449     virtual
1450     view
1451     returns (uint256)
1452   {
1453     return ownerToIds[_owner].length;
1454   }
1455 
1456 }
1457 
1458 // File: browser/EmblemVault_v2.sol
1459 
1460 pragma experimental ABIEncoderV2;
1461 pragma solidity 0.6.2;
1462 
1463 
1464 
1465 /**
1466  * @dev This is an example contract implementation of NFToken with metadata extension.
1467  */
1468 contract EmblemVault is
1469   NFTokenEnumerableMetadata,
1470   Ownable
1471 {
1472 
1473   /**
1474    * @dev Contract constructor. Sets metadata extension `name` and `symbol`.
1475    */
1476   constructor() public {
1477     nftName = "Emblem Vault V2";
1478     nftSymbol = "Emblem.pro";
1479   }
1480   
1481   function changeName(string calldata name, string calldata symbol) external onlyOwner {
1482       nftName = name;
1483       nftSymbol = symbol;
1484   }
1485 
1486   /**
1487    * @dev Mints a new NFT.
1488    * @param _to The address that will own the minted NFT.
1489    * @param _tokenId of the NFT to be minted by the msg.sender.
1490    * @param _uri String representing RFC 3986 URI.
1491    */
1492   function mint( address _to, uint256 _tokenId, string calldata _uri, string calldata _payload) external onlyOwner {
1493     super._mint(_to, _tokenId);
1494     super._setTokenUri(_tokenId, _uri);
1495     super._setTokenPayload(_tokenId, _payload);
1496   }
1497   
1498   function burn(uint256 _tokenId) external canTransfer(_tokenId) {
1499     super._burn(_tokenId);
1500   }
1501   
1502   function contractURI() public view returns (string memory) {
1503     return nftContractMetadataUri;
1504   }
1505   
1506   event UpdatedContractURI(string _from, string _to);
1507   function updateContractURI(string memory uri) public onlyOwner {
1508     emit UpdatedContractURI(nftContractMetadataUri, uri);
1509     nftContractMetadataUri = uri;
1510   }
1511   
1512   function getOwnerNFTCount(address _owner) public view returns (uint256) {
1513       return NFTokenEnumerableMetadata._getOwnerNFTCount(_owner);
1514   }
1515   
1516   function updateTokenUri(
1517     uint256 _tokenId,
1518     string memory _uri
1519   )
1520     public
1521     validNFToken(_tokenId)
1522     onlyOwner
1523   {
1524     idToUri[_tokenId] = _uri;
1525   }
1526   
1527   
1528 
1529 }