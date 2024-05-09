1 // File: contracts/exchange/ownable.sol
2 
3 pragma solidity 0.5.6;
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner());
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * It will not be possible to call the functions with the `onlyOwner`
49      * modifier anymore.
50      * @notice Renouncing ownership will leave the contract without an owner,
51      * thereby removing any functionality that is only available to the owner.
52      */
53     function renounceOwnership() public onlyOwner {
54         emit OwnershipTransferred(_owner, address(0));
55         _owner = address(0);
56     }
57 
58     /**
59      * @dev Allows the current owner to transfer control of the contract to a newOwner.
60      * @param newOwner The address to transfer ownership to.
61      */
62     function transferOwnership(address newOwner) public onlyOwner {
63         _transferOwnership(newOwner);
64     }
65 
66     /**
67      * @dev Transfers control of the contract to a newOwner.
68      * @param newOwner The address to transfer ownership to.
69      */
70     function _transferOwnership(address newOwner) internal {
71         require(newOwner != address(0));
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75 }
76 
77 // File: contracts/exchange/safe-math.sol
78 
79 pragma solidity 0.5.6;
80 
81 /**
82  * @dev Math operations with safety checks that throw on error. This contract is based on the 
83  * source code at: 
84  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol.
85  */
86 library SafeMath
87 {
88 
89   /**
90    * @dev Multiplies two numbers, reverts on overflow.
91    * @param _factor1 Factor number.
92    * @param _factor2 Factor number.
93    * @return The product of the two factors.
94    */
95   function mul(
96     uint256 _factor1,
97     uint256 _factor2
98   )
99     internal
100     pure
101     returns (uint256 product)
102   {
103     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
104     // benefit is lost if 'b' is also tested.
105     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
106     if (_factor1 == 0)
107     {
108       return 0;
109     }
110 
111     product = _factor1 * _factor2;
112     require(product / _factor1 == _factor2);
113   }
114 
115   /**
116    * @dev Integer division of two numbers, truncating the quotient, reverts on division by zero.
117    * @param _dividend Dividend number.
118    * @param _divisor Divisor number.
119    * @return The quotient.
120    */
121   function div(
122     uint256 _dividend,
123     uint256 _divisor
124   )
125     internal
126     pure
127     returns (uint256 quotient)
128   {
129     // Solidity automatically asserts when dividing by 0, using all gas.
130     require(_divisor > 0);
131     quotient = _dividend / _divisor;
132     // assert(_dividend == _divisor * quotient + _dividend % _divisor); // There is no case in which this doesn't hold.
133   }
134 
135   /**
136    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
137    * @param _minuend Minuend number.
138    * @param _subtrahend Subtrahend number.
139    * @return Difference.
140    */
141   function sub(
142     uint256 _minuend,
143     uint256 _subtrahend
144   )
145     internal
146     pure
147     returns (uint256 difference)
148   {
149     require(_subtrahend <= _minuend);
150     difference = _minuend - _subtrahend;
151   }
152 
153   /**
154    * @dev Adds two numbers, reverts on overflow.
155    * @param _addend1 Number.
156    * @param _addend2 Number.
157    * @return Sum.
158    */
159   function add(
160     uint256 _addend1,
161     uint256 _addend2
162   )
163     internal
164     pure
165     returns (uint256 sum)
166   {
167     sum = _addend1 + _addend2;
168     require(sum >= _addend1);
169   }
170 
171   /**
172     * @dev Divides two numbers and returns the remainder (unsigned integer modulo), reverts when
173     * dividing by zero.
174     * @param _dividend Number.
175     * @param _divisor Number.
176     * @return Remainder.
177     */
178   function mod(
179     uint256 _dividend,
180     uint256 _divisor
181   )
182     internal
183     pure
184     returns (uint256 remainder) 
185   {
186     require(_divisor != 0);
187     remainder = _dividend % _divisor;
188   }
189 
190 }
191 
192 // File: contracts/exchange/erc721-token-receiver.sol
193 
194 pragma solidity 0.5.6;
195 
196 /**
197  * @dev ERC-721 interface for accepting safe transfers. 
198  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
199  */
200 interface ERC721TokenReceiver
201 {
202 
203   /**
204    * @dev Handle the receipt of a NFT. The ERC721 smart contract calls this function on the
205    * recipient after a `transfer`. This function MAY throw to revert and reject the transfer. Return
206    * of other than the magic value MUST result in the transaction being reverted.
207    * Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))` unless throwing.
208    * @notice The contract address is always the message sender. A wallet/broker/auction application
209    * MUST implement the wallet interface if it will accept safe transfers.
210    * @param _operator The address which called `safeTransferFrom` function.
211    * @param _from The address which previously owned the token.
212    * @param _tokenId The NFT identifier which is being transferred.
213    * @param _data Additional data with no specified format.
214    * @return Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
215    */
216   function onERC721Received(
217     address _operator,
218     address _from,
219     uint256 _tokenId,
220     bytes calldata _data
221   )
222     external
223     returns(bytes4);
224 
225 	function onERC721Received(
226     address _from, 
227     uint256 _tokenId, 
228     bytes calldata _data
229   ) 
230   external 
231   returns 
232   (bytes4);
233 
234 }
235 
236 // File: contracts/exchange/ERC165Checker.sol
237 
238 pragma solidity ^0.5.6;
239 
240 /**
241  * @title ERC165Checker
242  * @dev Use `using ERC165Checker for address`; to include this library
243  * https://eips.ethereum.org/EIPS/eip-165
244  */
245 library ERC165Checker {
246     // As per the EIP-165 spec, no interface should ever match 0xffffffff
247     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
248 
249     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
250     /*
251      * 0x01ffc9a7 ===
252      *     bytes4(keccak256('supportsInterface(bytes4)'))
253      */
254 
255     /**
256      * @notice Query if a contract supports ERC165
257      * @param account The address of the contract to query for support of ERC165
258      * @return true if the contract at account implements ERC165
259      */
260     function _supportsERC165(address account) internal view returns (bool) {
261         // Any contract that implements ERC165 must explicitly indicate support of
262         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
263         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
264             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
265     }
266 
267     /**
268      * @notice Query if a contract implements an interface, also checks support of ERC165
269      * @param account The address of the contract to query for support of an interface
270      * @param interfaceId The interface identifier, as specified in ERC-165
271      * @return true if the contract at account indicates support of the interface with
272      * identifier interfaceId, false otherwise
273      * @dev Interface identification is specified in ERC-165.
274      */
275     function _supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
276         // query support of both ERC165 as per the spec and support of _interfaceId
277         return _supportsERC165(account) &&
278             _supportsERC165Interface(account, interfaceId);
279     }
280 
281     /**
282      * @notice Query if a contract implements interfaces, also checks support of ERC165
283      * @param account The address of the contract to query for support of an interface
284      * @param interfaceIds A list of interface identifiers, as specified in ERC-165
285      * @return true if the contract at account indicates support all interfaces in the
286      * interfaceIds list, false otherwise
287      * @dev Interface identification is specified in ERC-165.
288      */
289     function _supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
290         // query support of ERC165 itself
291         if (!_supportsERC165(account)) {
292             return false;
293         }
294 
295         // query support of each interface in _interfaceIds
296         for (uint256 i = 0; i < interfaceIds.length; i++) {
297             if (!_supportsERC165Interface(account, interfaceIds[i])) {
298                 return false;
299             }
300         }
301 
302         // all interfaces supported
303         return true;
304     }
305 
306     /**
307      * @notice Query if a contract implements an interface, does not check ERC165 support
308      * @param account The address of the contract to query for support of an interface
309      * @param interfaceId The interface identifier, as specified in ERC-165
310      * @return true if the contract at account indicates support of the interface with
311      * identifier interfaceId, false otherwise
312      * @dev Assumes that account contains a contract that supports ERC165, otherwise
313      * the behavior of this method is undefined. This precondition can be checked
314      * with the `supportsERC165` method in this library.
315      * Interface identification is specified in ERC-165.
316      */
317     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
318         // success determines whether the staticcall succeeded and result determines
319         // whether the contract at account indicates support of _interfaceId
320         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
321 
322         return (success && result);
323     }
324 
325     /**
326      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
327      * @param account The address of the contract to query for support of an interface
328      * @param interfaceId The interface identifier, as specified in ERC-165
329      * @return success true if the STATICCALL succeeded, false otherwise
330      * @return result true if the STATICCALL succeeded and the contract at account
331      * indicates support of the interface with identifier interfaceId, false otherwise
332      */
333     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
334         private
335         view
336         returns (bool success, bool result)
337     {
338         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
339 
340         // solhint-disable-next-line no-inline-assembly
341         assembly {
342             let encodedParams_data := add(0x20, encodedParams)
343             let encodedParams_size := mload(encodedParams)
344 
345             let output := mload(0x40)    // Find empty storage location using "free memory pointer"
346             mstore(output, 0x0)
347 
348             success := staticcall(
349                 30000,                   // 30k gas
350                 account,                 // To addr
351                 encodedParams_data,
352                 encodedParams_size,
353                 output,
354                 0x20                     // Outputs are 32 bytes long
355             )
356 
357             result := mload(output)      // Load the result
358         }
359     }
360 }
361 
362 // File: contracts/exchange/exchange.sol
363 
364 pragma solidity 0.5.6;
365 
366 
367 
368 
369 
370 /**
371  * @dev Interface to Interative with ERC-721 Contract.
372  */
373 contract Erc721Interface {
374     function transferFrom(address _from, address _to, uint256 _tokenId) external;
375     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
376     function ownerOf(uint256 _tokenId) external view returns (address _owner);
377 }
378 
379 /**
380  * @dev Interface to Interative with CryptoKitties Contract.
381  */
382 contract KittyInterface {
383     mapping (uint256 => address) public kittyIndexToApproved;
384     function transfer(address _to, uint256 _tokenId) external;
385     function transferFrom(address _from, address _to, uint256 _tokenId) external;
386     function ownerOf(uint256 _tokenId) external view returns (address _owner);
387 }
388 
389 
390 contract Exchange is Ownable, ERC721TokenReceiver {
391 
392     using SafeMath for uint256;
393     using SafeMath for uint;
394     using ERC165Checker for address;
395 
396     /**
397      * @dev CryptoKitties KittyCore Contract address.
398      */
399     address constant internal  CryptoKittiesAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
400     
401     /**
402      * @dev Magic value of a smart contract that can recieve NFT.
403      * Equal to: bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")).
404      */
405     bytes4 internal constant ERC721_RECEIVED_THREE_INPUT = 0xf0b9e5ba;
406 
407     /**
408     * @dev Magic value of a smart contract that can recieve NFT.
409     * Equal to: bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")).
410     */
411     bytes4 internal constant ERC721_RECEIVED_FOUR_INPUT = 0x150b7a02;
412 
413     /**
414     * @dev A mapping from NFT ID to the owner address.
415     */
416     mapping (address => mapping (uint256 => address)) internal TokenToOwner;
417 
418     /**
419     * @dev A mapping from owner address to specific contract address's all NFT IDs 
420     */
421     mapping (address => mapping (address => uint256[])) internal OwnerToTokens;
422 
423     /**
424     * @dev A mapping from specific contract address's NFT ID to its index in owner tokens array 
425     */
426     mapping (address => mapping(uint256 => uint256)) internal TokenToIndex;
427 
428     /**
429     * @dev A mapping from the address to all order it owns
430     */
431     mapping (address => bytes32[]) internal OwnerToOrders;
432 
433     /**
434     * @dev A mapping from order to owner address
435     */
436     mapping (bytes32 => address) internal OrderToOwner;
437 
438     /**
439     * @dev A mapping from order to its index in owner order array.
440     */
441     mapping (bytes32 => uint) internal OrderToIndex;
442 
443     /**
444     * @dev A mapping from matchorder to owner address
445     */
446     mapping (bytes32 => address) internal MatchOrderToOwner;
447    
448     /**
449     * @dev A mapping from order to all matchorder it owns
450     */
451     mapping (bytes32 => bytes32[]) internal OrderToMatchOrders;
452 
453     /**
454     * @dev A mapping from matchorder to its index in order's matchorder array
455     */
456     mapping (bytes32 => mapping(bytes32 => uint)) internal OrderToMatchOrderIndex;
457 
458     /**
459     * @dev A mapping from order to confirm it exist or not
460     */
461     mapping (bytes32 => bool) internal OrderToExist;
462 
463 
464     /**
465     * @dev An array which contains all support NFT interface in Exchange
466     */
467     bytes4[] internal SupportNFTInterface;
468 
469     /**
470     * @dev order and matchorder is equal to keccak256(contractAddress, tokenId, owner),
471     * because order is just a hash, so OrderObj is use to record details.
472     */
473     struct OrderObj {
474         // NFT's owner
475         address owner;
476 
477         // NFT's contract address
478         address contractAddress;
479         
480         // NFT's id
481         uint256 tokenId;
482     }
483 
484     /**
485     * @dev An mapping from order or matchorder's hash to it order obj
486     */
487     mapping (bytes32 => OrderObj) internal HashToOrderObj;
488 
489     /**
490     * @dev This emits when someone called receiveErc721Token and success transfer NFT to 
491     * exchange contract.
492     * @param _from Owner of NFT  
493     * @param _contractAddress NFT's contract address
494     * @param _tokenId NFT's id
495     */
496     event ReceiveToken(
497         address indexed _from, 
498         address _contractAddress, 
499         uint256 _tokenId
500     );
501 
502 
503     /**
504     * @dev This emits when someone called SendBackToken and transfer NFT from
505     * exchange contract to it owner
506     * @param _owner Owner of NFT  
507     * @param _contractAddress NFT's contract address
508     * @param _tokenId NFT's id
509     */
510     event SendBackToken(
511         address indexed _owner, 
512         address _contractAddress, 
513         uint256 _tokenId
514     );
515 
516     /**
517     * @dev This emits when send NFT happened from exchange contract to other address
518     * @param _to exchange contract send address
519     * @param _contractAddress NFT's contract address
520     * @param _tokenId NFT's id
521     */
522     event SendToken(
523         address indexed _to, 
524         address _contractAddress, 
525         uint256 _tokenId
526     );
527 
528     /**
529     * @dev This emits when an OrderObj be created 
530     * @param _hash order's hash
531     * @param _owner Owner of NFT  
532     * @param _contractAddress NFT's contract address
533     * @param _tokenId NFT's id
534     */
535     event CreateOrderObj(
536         bytes32 indexed _hash,
537         address _owner,
538         address _contractAddress,
539         uint256 _tokenId   
540     );
541 
542     /**
543     * @dev This emits when an order be created 
544     * @param _from this order's owner
545     * @param _orderHash this order's hash
546     * @param _contractAddress NFT's contract address
547     * @param _tokenId NFT's id
548     */
549     event CreateOrder(
550         address indexed _from,
551         bytes32 indexed _orderHash,
552         address _contractAddress,
553         uint256 _tokenId
554     );
555 
556     /**
557     * @dev This emits when an matchorder be created 
558     * @param _from this order's owner
559     * @param _orderHash order's hash which matchorder pairing
560     * @param _matchOrderHash this matchorder's hash
561     * @param _contractAddress NFT's contract address
562     * @param _tokenId NFT's id
563     */
564     event CreateMatchOrder(
565         address indexed _from,
566         bytes32 indexed _orderHash,
567         bytes32 indexed _matchOrderHash,
568         address _contractAddress,
569         uint256 _tokenId
570     );
571 
572     /**
573     * @dev This emits when an order be deleted 
574     * @param _from this order's owner
575     * @param _orderHash this order's hash
576     */
577     event DeleteOrder(
578         address indexed _from,
579         bytes32 indexed _orderHash
580     );
581 
582     /**
583     * @dev This emits when an matchorder be deleted 
584     * @param _from this matchorder's owner
585     * @param _orderHash order which matchorder pairing
586     * @param _matchOrderHash this matchorder
587     */
588     event DeleteMatchOrder(
589         address indexed _from,
590         bytes32 indexed _orderHash,
591         bytes32 indexed _matchOrderHash
592     );
593 
594 
595     /**
596     * @dev Function only be executed when massage sender is NFT's owner
597     * @param contractAddress NFT's contract address
598     * @param tokenId NFT's id
599     */
600     modifier onlySenderIsOriginalOwner(
601         address contractAddress, 
602         uint256 tokenId
603     ) 
604     {
605         require(TokenToOwner[contractAddress][tokenId] == msg.sender, "original owner should be message sender");
606         _;
607     }
608 
609     constructor () public {
610         //nf-token
611         SupportNFTInterface.push(0x80ac58cd);
612 
613         //nf-token-metadata
614         SupportNFTInterface.push(0x780e9d63);
615 
616         //nf-token-enumerable
617         SupportNFTInterface.push(0x5b5e139f);
618     }
619 
620    /**
621    * @dev Add support NFT interface in Exchange
622    * @notice Only Exchange owner can do tihs
623    * @param interface_id Support NFT interface's interface_id
624    */
625     function addSupportNFTInterface(
626         bytes4 interface_id
627     )
628     external
629     onlyOwner()
630     {
631         SupportNFTInterface.push(interface_id);
632     }
633 
634    /**
635    * @dev NFT contract will call when it use safeTransferFrom method
636    */
637     function onERC721Received(
638         address _from, 
639         uint256 _tokenId, 
640         bytes calldata _data
641     ) 
642     external 
643     returns (bytes4)
644     {
645         return ERC721_RECEIVED_THREE_INPUT;
646     }
647 
648    /**
649    * @dev NFT contract will call when it use safeTransferFrom method
650    */
651     function onERC721Received(
652         address _operator,
653         address _from,
654         uint256 _tokenId,
655         bytes calldata data
656     )
657     external
658     returns(bytes4)
659     {
660         return ERC721_RECEIVED_FOUR_INPUT;
661     }
662 
663    /**
664    * @dev Create an order for your NFT and other people can pairing their NFT to exchange
665    * @notice You must call receiveErc721Token method first to send your NFT to exchange contract,
666    * if your NFT have matchorder pair with other order, then they will become Invalid until you
667    * delete this order.
668    * @param contractAddress NFT's contract address
669    * @param tokenId NFT's id
670    */
671     function createOrder(
672         address contractAddress, 
673         uint256 tokenId
674     ) 
675     external 
676     onlySenderIsOriginalOwner(
677         contractAddress, 
678         tokenId
679     ) 
680     {
681         bytes32 orderHash = keccak256(abi.encodePacked(contractAddress, tokenId, msg.sender));
682         require(OrderToOwner[orderHash] != msg.sender, "Order already exist");
683         _addOrder(msg.sender, orderHash);
684         emit CreateOrder(msg.sender, orderHash, contractAddress, tokenId);
685     }
686 
687    /**
688    * @dev write order information to exchange contract.
689    * @param sender order's owner
690    * @param orderHash order's hash
691    */
692     function _addOrder(
693         address sender, 
694         bytes32 orderHash
695     ) 
696     internal 
697     {
698         uint index = OwnerToOrders[sender].push(orderHash).sub(1);
699         OrderToOwner[orderHash] = sender;
700         OrderToIndex[orderHash] = index;
701         OrderToExist[orderHash] = true;
702     }
703 
704    /**
705    * @dev Delete an order if you don't want exchange NFT to anyone, or you want get your NFT back.
706    * @param orderHash order's hash
707    */
708     function deleteOrder(
709         bytes32 orderHash
710     )
711     external
712     {
713         require(OrderToOwner[orderHash] == msg.sender, "this order hash not belongs to this address");
714         _removeOrder(msg.sender, orderHash);
715         emit DeleteOrder(msg.sender, orderHash);
716     }
717 
718    /**
719    * @dev Remove order information on exchange contract 
720    * @param sender order's owner
721    * @param orderHash order's hash
722    */
723     function _removeOrder(
724         address sender,
725         bytes32 orderHash
726     )
727     internal
728     {
729         OrderToExist[orderHash] = false;
730         delete OrderToOwner[orderHash];
731         uint256 orderIndex = OrderToIndex[orderHash];
732         uint256 lastOrderIndex = OwnerToOrders[sender].length.sub(1);
733         if (lastOrderIndex != orderIndex){
734             bytes32 lastOwnerOrder = OwnerToOrders[sender][lastOrderIndex];
735             OwnerToOrders[sender][orderIndex] = lastOwnerOrder;
736             OrderToIndex[lastOwnerOrder] = orderIndex;
737         }
738         OwnerToOrders[sender].length--;
739     }
740 
741    /**
742    * @dev If your are interested in specfic order's NFT, create a matchorder and pair with it so order's owner
743    * can know and choose to exchange with you
744    * @notice You must call receiveErc721Token method first to send your NFT to exchange contract,
745    * if your NFT already create order, then you will be prohibit create matchorder until you delete this NFT's 
746    * order.
747    * @param contractAddress NFT's contract address
748    * @param tokenId NFT's id
749    * @param orderHash order's hash which matchorder want to pair with 
750    */
751     function createMatchOrder(
752         address contractAddress,
753         uint256 tokenId, 
754         bytes32 orderHash
755     ) 
756     external 
757     onlySenderIsOriginalOwner(
758         contractAddress, 
759         tokenId
760     ) 
761     {
762         bytes32 matchOrderHash = keccak256(abi.encodePacked(contractAddress, tokenId, msg.sender));
763         require(OrderToOwner[matchOrderHash] != msg.sender, "Order already exist");
764         _addMatchOrder(matchOrderHash, orderHash);
765         emit CreateMatchOrder(msg.sender, orderHash, matchOrderHash, contractAddress, tokenId);
766     }
767 
768    /**
769    * @dev add matchorder information on exchange contract 
770    * @param matchOrderHash matchorder's hash
771    * @param orderHash order's hash which matchorder pair with 
772    */
773     function _addMatchOrder(
774         bytes32 matchOrderHash, 
775         bytes32 orderHash
776     ) 
777     internal 
778     {
779         uint inOrderIndex = OrderToMatchOrders[orderHash].push(matchOrderHash).sub(1);
780         OrderToMatchOrderIndex[orderHash][matchOrderHash] = inOrderIndex;
781     }
782 
783    /**
784    * @dev delete matchorder information on exchange contract 
785    * @param matchOrderHash matchorder's hash
786    * @param orderHash order's hash which matchorder pair with 
787    */
788     function deleteMatchOrder(
789         bytes32 matchOrderHash,
790         bytes32 orderHash
791     )
792     external
793     {
794         require(MatchOrderToOwner[matchOrderHash] == msg.sender, "match order doens't belong to this address" );
795         require(OrderToExist[orderHash] == true, "this order is not exist");
796         _removeMatchOrder(orderHash, matchOrderHash);
797         emit DeleteMatchOrder(msg.sender, orderHash, matchOrderHash);
798     }
799 
800   /**
801    * @dev delete matchorder information on exchange contract 
802    * @param orderHash order's hash which matchorder pair with 
803    * @param matchOrderHash matchorder's hash
804    */
805     function _removeMatchOrder(
806         bytes32 orderHash,
807         bytes32 matchOrderHash
808     )
809     internal
810     {
811         uint256 matchOrderIndex = OrderToMatchOrderIndex[orderHash][matchOrderHash];
812         uint256 lastMatchOrderIndex = OrderToMatchOrders[orderHash].length.sub(1);
813         if (lastMatchOrderIndex != matchOrderIndex){
814             bytes32 lastMatchOrder = OrderToMatchOrders[orderHash][lastMatchOrderIndex];
815             OrderToMatchOrders[orderHash][matchOrderIndex] = lastMatchOrder;
816             OrderToMatchOrderIndex[orderHash][lastMatchOrder] = matchOrderIndex;
817         }
818         OrderToMatchOrders[orderHash].length--;
819     }
820 
821     /**
822     * @dev order's owner can choose NFT to exchange from it's match order array, when function 
823     * execute, order will be deleted, both NFT will be exchanged and send to corresponding address.
824     * @param order order's hash which matchorder pair with 
825     * @param matchOrder matchorder's hash
826     */
827     function exchangeToken(
828         bytes32 order,
829         bytes32 matchOrder
830     ) 
831     external 
832     {
833         require(OrderToOwner[order] == msg.sender, "this order doesn't belongs to this address");
834         OrderObj memory orderObj = HashToOrderObj[order];
835         uint index = OrderToMatchOrderIndex[order][matchOrder];
836         require(OrderToMatchOrders[order][index] == matchOrder, "match order is not in this order");
837         require(OrderToExist[matchOrder] != true, "this match order's token have open order");
838         OrderObj memory matchOrderObj = HashToOrderObj[matchOrder];
839         _sendToken(matchOrderObj.owner, orderObj.contractAddress, orderObj.tokenId);
840         _sendToken(orderObj.owner, matchOrderObj.contractAddress, matchOrderObj.tokenId);
841         _removeMatchOrder(order, matchOrder);
842         _removeOrder(msg.sender, order);
843     }
844 
845     /**
846     * @dev if you want to create order and matchorder on exchange contract, you must call this function
847     * to send your NFT to exchange contract, if your NFT is followed erc165 and erc721 standard, exchange
848     * contract will checked and execute sucessfully, then contract will record your information so you 
849     * don't need worried about NFT lost.
850     * @notice because contract can't directly transfer your NFT, so you should call setApprovalForAll 
851     * on NFT contract first, so this function can execute successfully.
852     * @param contractAddress NFT's Contract address
853     * @param tokenId NFT's id 
854     */
855     function receiveErc721Token(
856         address contractAddress, 
857         uint256 tokenId
858     ) 
859     external  
860     {
861         bool checkSupportErc165Interface = false;
862         if(contractAddress != CryptoKittiesAddress){
863             for(uint i = 0; i < SupportNFTInterface.length; i++){
864                 if(contractAddress._supportsInterface(SupportNFTInterface[i]) == true){
865                     checkSupportErc165Interface = true;
866                 }
867             }
868             require(checkSupportErc165Interface == true, "not supported Erc165 Interface");
869             Erc721Interface erc721Contract = Erc721Interface(contractAddress);
870             require(erc721Contract.isApprovedForAll(msg.sender,address(this)) == true, "contract doesn't have power to control this token id");
871             erc721Contract.transferFrom(msg.sender, address(this), tokenId);
872         }else {
873             KittyInterface kittyContract = KittyInterface(contractAddress);
874             require(kittyContract.kittyIndexToApproved(tokenId) == address(this), "contract doesn't have power to control this cryptoKitties's id");
875             kittyContract.transferFrom(msg.sender, address(this), tokenId);
876         }
877         _addToken(msg.sender, contractAddress, tokenId);
878         emit ReceiveToken(msg.sender, contractAddress, tokenId);
879 
880     }
881 
882     /**
883     * @dev add token and OrderObj information on exchange contract, because order hash and matchorder
884     * hash are same, so one NFT have mapping to one OrderObj
885     * @param sender NFT's owner
886     * @param contractAddress NFT's contract address
887     * @param tokenId NFT's id
888     */
889     function _addToken(
890         address sender, 
891         address contractAddress, 
892         uint256 tokenId
893     ) 
894     internal 
895     {   
896         bytes32 matchOrderHash = keccak256(abi.encodePacked(contractAddress, tokenId, sender));
897         MatchOrderToOwner[matchOrderHash] = sender;
898         HashToOrderObj[matchOrderHash] = OrderObj(sender,contractAddress,tokenId);
899         TokenToOwner[contractAddress][tokenId] = sender;
900         uint index = OwnerToTokens[sender][contractAddress].push(tokenId).sub(1);
901         TokenToIndex[contractAddress][tokenId] = index;
902         emit CreateOrderObj(matchOrderHash, sender, contractAddress, tokenId);
903     }
904 
905 
906     /**
907     * @dev send your NFT back to address which you send token in, if your NFT still have open order,
908     * then order will be deleted
909     * @notice matchorder will not be deleted because cost too high, but they will be useless and other
910     * people can't choose your match order to exchange
911     * @param contractAddress NFT's Contract address
912     * @param tokenId NFT's id 
913     */
914     function sendBackToken(
915         address contractAddress, 
916         uint256 tokenId
917     ) 
918     external 
919     onlySenderIsOriginalOwner(
920         contractAddress, 
921         tokenId
922     ) 
923     {
924         bytes32 orderHash = keccak256(abi.encodePacked(contractAddress, tokenId, msg.sender));
925         if(OrderToExist[orderHash] == true) {
926             _removeOrder(msg.sender, orderHash);
927         }
928         _sendToken(msg.sender, contractAddress, tokenId);
929         emit SendBackToken(msg.sender, contractAddress, tokenId);
930     }  
931 
932 
933     /**
934     * @dev Drive NFT contract to send NFT to corresponding address
935     * @notice because cryptokittes contract method are not the same as general NFT contract, so 
936     * need treat it individually
937     * @param sendAddress NFT's owner
938     * @param contractAddress NFT's contract address
939     * @param tokenId NFT's id
940     */
941     function _sendToken(
942         address sendAddress,
943         address contractAddress, 
944         uint256 tokenId
945     )
946     internal
947     {   
948         if(contractAddress != CryptoKittiesAddress){
949             Erc721Interface erc721Contract = Erc721Interface(contractAddress);
950             require(erc721Contract.ownerOf(tokenId) == address(this), "exchange contract should have this token");
951             erc721Contract.transferFrom(address(this), sendAddress, tokenId);
952         }else{
953             KittyInterface kittyContract = KittyInterface(contractAddress);
954             require(kittyContract.ownerOf(tokenId) == address(this), "exchange contract should have this token");
955             kittyContract.transfer(sendAddress, tokenId);
956         }
957         _removeToken(contractAddress, tokenId);
958         emit SendToken(sendAddress, contractAddress, tokenId);
959     }
960 
961     /**
962     * @dev remove token and OrderObj information on exchange contract
963     * @param contractAddress NFT's contract address
964     * @param tokenId NFT's id
965     */
966     function _removeToken(
967         address contractAddress, 
968         uint256 tokenId
969     ) 
970     internal 
971     {
972         address owner = TokenToOwner[contractAddress][tokenId];
973         bytes32 orderHash = keccak256(abi.encodePacked(contractAddress, tokenId, owner));
974         delete HashToOrderObj[orderHash];
975         delete MatchOrderToOwner[orderHash];
976         delete TokenToOwner[contractAddress][tokenId];
977         uint256 tokenIndex = TokenToIndex[contractAddress][tokenId];
978         uint256 lastOwnerTokenIndex = OwnerToTokens[owner][contractAddress].length.sub(1);
979         if (lastOwnerTokenIndex != tokenIndex){
980             uint256 lastOwnerToken = OwnerToTokens[owner][contractAddress][lastOwnerTokenIndex];
981             OwnerToTokens[owner][contractAddress][tokenIndex] = lastOwnerToken;
982             TokenToIndex[contractAddress][lastOwnerToken] = tokenIndex;
983         }
984         OwnerToTokens[owner][contractAddress].length--;
985     }
986 
987     /**
988     * @dev get NFT owner address
989     * @param contractAddress NFT's contract address
990     * @param tokenId NFT's id
991     * @return NFT owner address
992     */
993     function getTokenOwner(
994         address contractAddress, 
995         uint256 tokenId
996     ) 
997     external 
998     view 
999     returns (address)
1000     {
1001         return TokenToOwner[contractAddress][tokenId];
1002     }
1003     
1004     /**
1005     * @dev get owner's specfic contract address's all NFT array 
1006     * @param ownerAddress owner address
1007     * @param contractAddress  NFT's contract address
1008     * @return NFT's array
1009     */
1010     function getOwnerTokens(
1011         address ownerAddress, 
1012         address contractAddress
1013     ) 
1014     external 
1015     view 
1016     returns (uint256[] memory)
1017     {
1018         return OwnerToTokens[ownerAddress][contractAddress];
1019     }
1020 
1021     /**
1022     * @dev get NFT's index in owner NFT's array 
1023     * @param contractAddress NFT's contract address
1024     * @param tokenId NFT's id
1025     * @return NFT's index
1026     */
1027     function getTokenIndex(
1028         address contractAddress, 
1029         uint256 tokenId
1030     ) 
1031     external 
1032     view
1033     returns (uint256)
1034     {
1035         return TokenToIndex[contractAddress][tokenId];
1036     }
1037 
1038     /**
1039     * @dev get owner address's all orders
1040     * @param ownerAddress owner address
1041     * @return orders array
1042     */
1043     function getOwnerOrders(
1044         address ownerAddress
1045     ) 
1046     external 
1047     view 
1048     returns (bytes32[] memory){
1049         return OwnerToOrders[ownerAddress];
1050     }
1051 
1052     /**
1053     * @dev get specfit order's owner address
1054     * @param order order's hash
1055     * @return order's owner address
1056     */
1057     function getOrderOwner(
1058         bytes32 order
1059     ) 
1060     external 
1061     view 
1062     returns (address)
1063     {
1064         return OrderToOwner[order];
1065     }
1066 
1067     /**
1068     * @dev get order's index in owner orders array
1069     * @param order order's hash
1070     * @return order's index
1071     */
1072     function getOrderIndex(
1073         bytes32 order
1074     ) 
1075     external 
1076     view 
1077     returns (uint)
1078     {
1079         return OrderToIndex[order];
1080     }
1081 
1082     /**
1083     * @dev get order exist or not in exchange contract
1084     * @param order order's hash
1085     * @return boolean to express order exist 
1086     */
1087     function getOrderExist(
1088         bytes32 order
1089     )
1090     external
1091     view
1092     returns (bool){
1093         return OrderToExist[order];
1094     }
1095 
1096     /**
1097     * @dev get specfit matchorder's owner address
1098     * @param matchOrder matchorder's hash
1099     * @return matchorder's owner address
1100     */
1101     function getMatchOrderOwner(
1102         bytes32 matchOrder
1103     ) 
1104     external 
1105     view 
1106     returns (address)
1107     {
1108         return MatchOrderToOwner[matchOrder];
1109     }
1110 
1111     /**
1112     * @dev get matchorder's index in NFT order's matchorders array
1113     * @param order matchorder's hash
1114     * @return matchorder's index
1115     */
1116     function getOrderMatchOrderIndex(
1117         bytes32 order,
1118         bytes32 matchOrder
1119     ) 
1120     external 
1121     view 
1122     returns (uint)
1123     {
1124         return OrderToMatchOrderIndex[order][matchOrder];
1125     }
1126 
1127     /**
1128     * @dev get order's matchorder array
1129     * @param order order's hash
1130     * @return matchorder array
1131     */
1132     function getOrderMatchOrders(
1133         bytes32 order
1134     ) 
1135     external 
1136     view 
1137     returns (bytes32[] memory)
1138     {
1139         return OrderToMatchOrders[order];
1140     }
1141 
1142     /**
1143     * @dev get mapping from order or matchorder's hash to OrderObj
1144     * @param hashOrder order or matchorder's hash
1145     * @return OrderObj
1146     */
1147     function getHashOrderObj(
1148         bytes32 hashOrder
1149     )
1150     external
1151     view
1152     returns(
1153         address, 
1154         address, 
1155         uint256
1156     )
1157     {
1158         OrderObj memory orderObj = HashToOrderObj[hashOrder];
1159         return(
1160             orderObj.owner,
1161             orderObj.contractAddress,
1162             orderObj.tokenId
1163         );
1164     }
1165 }