1 pragma solidity ^0.4.24;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: node_modules/openzeppelin-solidity/contracts/introspection/ERC165.sol
56 
57 /**
58  * @title ERC165
59  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
60  */
61 interface ERC165 {
62 
63   /**
64    * @notice Query if a contract implements an interface
65    * @param _interfaceId The interface identifier, as specified in ERC-165
66    * @dev Interface identification is specified in ERC-165. This function
67    * uses less than 30,000 gas.
68    */
69   function supportsInterface(bytes4 _interfaceId)
70     external
71     view
72     returns (bool);
73 }
74 
75 // File: node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
76 
77 /**
78  * @title ERC721 Non-Fungible Token Standard basic interface
79  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
80  */
81 contract ERC721Basic is ERC165 {
82   event Transfer(
83     address indexed _from,
84     address indexed _to,
85     uint256 indexed _tokenId
86   );
87   event Approval(
88     address indexed _owner,
89     address indexed _approved,
90     uint256 indexed _tokenId
91   );
92   event ApprovalForAll(
93     address indexed _owner,
94     address indexed _operator,
95     bool _approved
96   );
97 
98   function balanceOf(address _owner) public view returns (uint256 _balance);
99   function ownerOf(uint256 _tokenId) public view returns (address _owner);
100   function exists(uint256 _tokenId) public view returns (bool _exists);
101 
102   function approve(address _to, uint256 _tokenId) public;
103   function getApproved(uint256 _tokenId)
104     public view returns (address _operator);
105 
106   function setApprovalForAll(address _operator, bool _approved) public;
107   function isApprovedForAll(address _owner, address _operator)
108     public view returns (bool);
109 
110   function transferFrom(address _from, address _to, uint256 _tokenId) public;
111   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
112     public;
113 
114   function safeTransferFrom(
115     address _from,
116     address _to,
117     uint256 _tokenId,
118     bytes _data
119   )
120     public;
121 }
122 
123 // File: contracts/ERC721.sol
124 
125 /**
126  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
127  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
128  */
129 contract ERC721Enumerable is ERC721Basic {
130     function totalSupply() public view returns (uint256);
131 }
132 
133 
134 /**
135  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
136  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
137  */
138 contract ERC721Metadata is ERC721Basic {
139     function name() external view returns (string _name);
140     function symbol() external view returns (string _symbol);
141     function tokenURI(uint256 _tokenId) public view returns (string);
142 }
143 
144 
145 /**
146  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
147  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
148  */
149 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
150 }
151 
152 // File: node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
153 
154 /**
155  * @title ERC721 token receiver interface
156  * @dev Interface for any contract that wants to support safeTransfers
157  * from ERC721 asset contracts.
158  */
159 contract ERC721Receiver {
160   /**
161    * @dev Magic value to be returned upon successful reception of an NFT
162    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
163    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
164    */
165   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
166 
167   /**
168    * @notice Handle the receipt of an NFT
169    * @dev The ERC721 smart contract calls this function on the recipient
170    * after a `safetransfer`. This function MAY throw to revert and reject the
171    * transfer. Return of other than the magic value MUST result in the 
172    * transaction being reverted.
173    * Note: the contract address is always the message sender.
174    * @param _operator The address which called `safeTransferFrom` function
175    * @param _from The address which previously owned the token
176    * @param _tokenId The NFT identifier which is being transfered
177    * @param _data Additional data with no specified format
178    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
179    */
180   function onERC721Received(
181     address _operator,
182     address _from,
183     uint256 _tokenId,
184     bytes _data
185   )
186     public
187     returns(bytes4);
188 }
189 
190 // File: node_modules/openzeppelin-solidity/contracts/AddressUtils.sol
191 
192 /**
193  * Utility library of inline functions on addresses
194  */
195 library AddressUtils {
196 
197   /**
198    * Returns whether the target address is a contract
199    * @dev This function will return false if invoked during the constructor of a contract,
200    * as the code is not actually created until after the constructor finishes.
201    * @param addr address to check
202    * @return whether the target address is a contract
203    */
204   function isContract(address addr) internal view returns (bool) {
205     uint256 size;
206     // XXX Currently there is no better way to check if there is a contract in an address
207     // than to check the size of the code at that address.
208     // See https://ethereum.stackexchange.com/a/14016/36603
209     // for more details about how this works.
210     // TODO Check this again before the Serenity release, because all addresses will be
211     // contracts then.
212     // solium-disable-next-line security/no-inline-assembly
213     assembly { size := extcodesize(addr) }
214     return size > 0;
215   }
216 
217 }
218 
219 // File: node_modules/openzeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol
220 
221 /**
222  * @title SupportsInterfaceWithLookup
223  * @author Matt Condon (@shrugs)
224  * @dev Implements ERC165 using a lookup table.
225  */
226 contract SupportsInterfaceWithLookup is ERC165 {
227   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
228   /**
229    * 0x01ffc9a7 ===
230    *   bytes4(keccak256('supportsInterface(bytes4)'))
231    */
232 
233   /**
234    * @dev a mapping of interface id to whether or not it's supported
235    */
236   mapping(bytes4 => bool) internal supportedInterfaces;
237 
238   /**
239    * @dev A contract implementing SupportsInterfaceWithLookup
240    * implement ERC165 itself
241    */
242   constructor()
243     public
244   {
245     _registerInterface(InterfaceId_ERC165);
246   }
247 
248   /**
249    * @dev implement supportsInterface(bytes4) using a lookup table
250    */
251   function supportsInterface(bytes4 _interfaceId)
252     external
253     view
254     returns (bool)
255   {
256     return supportedInterfaces[_interfaceId];
257   }
258 
259   /**
260    * @dev private method for registering an interface
261    */
262   function _registerInterface(bytes4 _interfaceId)
263     internal
264   {
265     require(_interfaceId != 0xffffffff);
266     supportedInterfaces[_interfaceId] = true;
267   }
268 }
269 
270 // File: contracts/ERC721BasicToken.sol
271 
272 /**
273  * @title ERC721 Non-Fungible Token Standard basic implementation
274  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
275  */
276 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
277 
278     bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
279     /*
280     * 0x80ac58cd ===
281     *   bytes4(keccak256('balanceOf(address)')) ^
282     *   bytes4(keccak256('ownerOf(uint256)')) ^
283     *   bytes4(keccak256('approve(address,uint256)')) ^
284     *   bytes4(keccak256('getApproved(uint256)')) ^
285     *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
286     *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
287     *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
288     *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
289     *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
290     */
291 
292     bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
293     /*
294     * 0x4f558e79 ===
295     *   bytes4(keccak256('exists(uint256)'))
296     */
297 
298     using SafeMath for uint256;
299     using AddressUtils for address;
300 
301     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
302     // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
303     bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
304 
305     // Mapping from token ID to owner
306     mapping (uint256 => address) internal tokenOwner;
307 
308     // Mapping from token ID to approved address
309     mapping (uint256 => address) internal tokenApprovals;
310 
311     // Mapping from owner to operator approvals
312     mapping (address => mapping (address => bool)) internal operatorApprovals;
313 
314     /**
315     * @dev Guarantees msg.sender is owner of the given token
316     * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
317     */
318     modifier onlyOwnerOf(uint256 _tokenId) {
319         require(ownerOf(_tokenId) == msg.sender);
320         _;
321     }
322 
323     /**
324     * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
325     * @param _tokenId uint256 ID of the token to validate
326     */
327     modifier canTransfer(uint256 _tokenId) {
328         require(isApprovedOrOwner(msg.sender, _tokenId)); //, "canTransfer"
329         _;
330     }
331 
332     constructor()
333         public
334     {
335         // register the supported interfaces to conform to ERC721 via ERC165
336         _registerInterface(InterfaceId_ERC721);
337         _registerInterface(InterfaceId_ERC721Exists);
338     }
339 
340     /**
341     * @dev Gets the balance of the specified address
342     * @param _owner address to query the balance of
343     * @return uint256 representing the amount owned by the passed address
344     */
345     function balanceOf(address _owner) public view returns (uint256);
346 
347     /**
348     * @dev Gets the owner of the specified token ID
349     * @param _tokenId uint256 ID of the token to query the owner of
350     * @return owner address currently marked as the owner of the given token ID
351     */
352     function ownerOf(uint256 _tokenId) public view returns (address) {
353         address owner = tokenOwner[_tokenId];
354         require(owner != address(0));
355         return owner;
356     }
357 
358     /**
359     * @dev Returns whether the specified token exists
360     * @param _tokenId uint256 ID of the token to query the existence of
361     * @return whether the token exists
362     */
363     function exists(uint256 _tokenId) public view returns (bool) {
364         address owner = tokenOwner[_tokenId];
365         return owner != address(0);
366     }
367 
368     /**
369     * @dev Approves another address to transfer the given token ID
370     * The zero address indicates there is no approved address.
371     * There can only be one approved address per token at a given time.
372     * Can only be called by the token owner or an approved operator.
373     * @param _to address to be approved for the given token ID
374     * @param _tokenId uint256 ID of the token to be approved
375     */
376     function approve(address _to, uint256 _tokenId) public {
377         address owner = ownerOf(_tokenId);
378         require(_to != owner); //, "_to eq owner"
379         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
380 
381         tokenApprovals[_tokenId] = _to;
382         emit Approval(owner, _to, _tokenId);
383     }
384 
385     /**
386     * @dev Gets the approved address for a token ID, or zero if no address set
387     * @param _tokenId uint256 ID of the token to query the approval of
388     * @return address currently approved for the given token ID
389     */
390     function getApproved(uint256 _tokenId) public view returns (address) {
391         return tokenApprovals[_tokenId];
392     }
393 
394     /**
395     * @dev Sets or unsets the approval of a given operator
396     * An operator is allowed to transfer all tokens of the sender on their behalf
397     * @param _to operator address to set the approval
398     * @param _approved representing the status of the approval to be set
399     */
400     function setApprovalForAll(address _to, bool _approved) public {
401         require(_to != msg.sender);
402         operatorApprovals[msg.sender][_to] = _approved;
403         emit ApprovalForAll(msg.sender, _to, _approved);
404     }
405 
406     /**
407     * @dev Tells whether an operator is approved by a given owner
408     * @param _owner owner address which you want to query the approval of
409     * @param _operator operator address which you want to query the approval of
410     * @return bool whether the given operator is approved by the given owner
411     */
412     function isApprovedForAll(
413         address _owner,
414         address _operator
415     )
416         public
417         view
418         returns (bool)
419     {
420         return operatorApprovals[_owner][_operator];
421     }
422 
423     /**
424     * @dev Transfers the ownership of a given token ID to another address
425     * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
426     * Requires the msg sender to be the owner, approved, or operator
427     * @param _from current owner of the token
428     * @param _to address to receive the ownership of the given token ID
429     * @param _tokenId uint256 ID of the token to be transferred
430     */
431     function transferFrom(
432         address _from,
433         address _to,
434         uint256 _tokenId
435     )
436         public
437         canTransfer(_tokenId)
438     {
439         require(_from != address(0)); //, "transferFrom 1"
440         require(_to != address(0)); //, "transferFrom 2"
441 
442         clearApproval(_from, _tokenId);
443         removeTokenFrom(_from, _tokenId);
444         addTokenTo(_to, _tokenId);
445 
446         emit Transfer(_from, _to, _tokenId);
447     }
448 
449     /**
450     * @dev Safely transfers the ownership of a given token ID to another address
451     * If the target address is a contract, it must implement `onERC721Received`,
452     * which is called upon a safe transfer, and return the magic value
453     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
454     * the transfer is reverted.
455     *
456     * Requires the msg sender to be the owner, approved, or operator
457     * @param _from current owner of the token
458     * @param _to address to receive the ownership of the given token ID
459     * @param _tokenId uint256 ID of the token to be transferred
460     */
461     function safeTransferFrom(
462         address _from,
463         address _to,
464         uint256 _tokenId
465     )
466         public
467         canTransfer(_tokenId)
468     {
469         // solium-disable-next-line arg-overflow
470         safeTransferFrom(_from, _to, _tokenId, "");
471     }
472 
473     /**
474     * @dev Safely transfers the ownership of a given token ID to another address
475     * If the target address is a contract, it must implement `onERC721Received`,
476     * which is called upon a safe transfer, and return the magic value
477     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
478     * the transfer is reverted.
479     * Requires the msg sender to be the owner, approved, or operator
480     * @param _from current owner of the token
481     * @param _to address to receive the ownership of the given token ID
482     * @param _tokenId uint256 ID of the token to be transferred
483     * @param _data bytes data to send along with a safe transfer check
484     */
485     function safeTransferFrom(
486         address _from,
487         address _to,
488         uint256 _tokenId,
489         bytes _data
490     )
491         public
492         canTransfer(_tokenId)
493     {
494         transferFrom(_from, _to, _tokenId);
495         // solium-disable-next-line arg-overflow
496         require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
497     }
498 
499     /**
500     * @dev Returns whether the given spender can transfer a given token ID
501     * @param _spender address of the spender to query
502     * @param _tokenId uint256 ID of the token to be transferred
503     * @return bool whether the msg.sender is approved for the given token ID,
504     *  is an operator of the owner, or is the owner of the token
505     */
506     function isApprovedOrOwner(
507         address _spender,
508         uint256 _tokenId
509     )
510         internal
511         view
512         returns (bool)
513     {
514         address owner = ownerOf(_tokenId);
515         // Disable solium check because of
516         // https://github.com/duaraghav8/Solium/issues/175
517         // solium-disable-next-line operator-whitespace
518         return (
519         _spender == owner ||
520         getApproved(_tokenId) == _spender ||
521         isApprovedForAll(owner, _spender)
522         );
523     }
524 
525     /**
526     * @dev Internal function to mint a new token
527     * Reverts if the given token ID already exists
528     * @param _to The address that will own the minted token
529     * @param _tokenId uint256 ID of the token to be minted by the msg.sender
530     */
531     function _mint(address _to, uint256 _tokenId) internal {
532         require(_to != address(0));
533         addTokenTo(_to, _tokenId);
534         emit Transfer(address(0), _to, _tokenId);
535     }
536 
537     /**
538     * @dev Internal function to burn a specific token
539     * Reverts if the token does not exist
540     * @param _tokenId uint256 ID of the token being burned by the msg.sender
541     */
542     function _burn(address _owner, uint256 _tokenId) internal {
543         clearApproval(_owner, _tokenId);
544         removeTokenFrom(_owner, _tokenId);
545         emit Transfer(_owner, address(0), _tokenId);
546     }
547 
548     /**
549     * @dev Internal function to clear current approval of a given token ID
550     * Reverts if the given address is not indeed the owner of the token
551     * @param _owner owner of the token
552     * @param _tokenId uint256 ID of the token to be transferred
553     */
554     function clearApproval(address _owner, uint256 _tokenId) internal {
555         require(ownerOf(_tokenId) == _owner); //, "clearApproval"
556         if (tokenApprovals[_tokenId] != address(0)) {
557             tokenApprovals[_tokenId] = address(0);
558         }
559     }
560 
561     /**
562     * @dev Internal function to add a token ID to the list of a given address
563     * @param _to address representing the new owner of the given token ID
564     * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
565     */
566     function addTokenTo(address _to, uint256 _tokenId) internal {
567         require(tokenOwner[_tokenId] == address(0)); //, "addTokenTo"
568         tokenOwner[_tokenId] = _to;
569     }
570 
571     /**
572     * @dev Internal function to remove a token ID from the list of a given address
573     * @param _from address representing the previous owner of the given token ID
574     * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
575     */
576     function removeTokenFrom(address _from, uint256 _tokenId) internal {
577         require(ownerOf(_tokenId) == _from); //, "removeTokenFrom"
578         tokenOwner[_tokenId] = address(0);
579     }
580 
581     /**
582     * @dev Internal function to invoke `onERC721Received` on a target address
583     * The call is not executed if the target address is not a contract
584     * @param _from address representing the previous owner of the given token ID
585     * @param _to target address that will receive the tokens
586     * @param _tokenId uint256 ID of the token to be transferred
587     * @param _data bytes optional data to send along with the call
588     * @return whether the call correctly returned the expected magic value
589     */
590     function checkAndCallSafeTransfer(
591         address _from,
592         address _to,
593         uint256 _tokenId,
594         bytes _data
595     )
596         internal
597         returns (bool)
598     {
599         if (!_to.isContract()) {
600             return true;
601         }
602         bytes4 retval = ERC721Receiver(_to).onERC721Received(
603         msg.sender, _from, _tokenId, _data);
604         return (retval == ERC721_RECEIVED);
605     }
606 }
607 
608 // File: contracts/IEntityStorage.sol
609 
610 interface IEntityStorage {
611     function storeBulk(uint256[] _tokenIds, uint256[] _attributes) external;
612     function store(uint256 _tokenId, uint256 _attributes, uint256[] _componentIds) external;
613     function remove(uint256 _tokenId) external;
614     function list() external view returns (uint256[] tokenIds);
615     function getAttributes(uint256 _tokenId) external view returns (uint256 attrs, uint256[] compIds);
616     function updateAttributes(uint256 _tokenId, uint256 _attributes, uint256[] _componentIds) external;
617     function totalSupply() external view returns (uint256);
618 }
619 
620 // File: contracts/ERC721Token.sol
621 
622 /**
623  * @title Full ERC721 Token
624  * This implementation includes all the required and some optional functionality of the ERC721 standard
625  * Moreover, it includes approve all functionality using operator terminology
626  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md Customized to support non-transferability.
627  */
628 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
629 
630     IEntityStorage internal cbStorage;
631 
632     bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
633     /**
634     * 0x780e9d63 ===
635     *   bytes4(keccak256('totalSupply()')) ^
636     *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
637     *   bytes4(keccak256('tokenByIndex(uint256)'))
638     */
639 
640     bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
641     /**
642     * 0x5b5e139f ===
643     *   bytes4(keccak256('name()')) ^
644     *   bytes4(keccak256('symbol()')) ^
645     *   bytes4(keccak256('tokenURI(uint256)'))
646     */
647 
648     string internal uriPrefix;
649 
650     // Token name
651     string internal name_;
652 
653     // Token symbol
654     string internal symbol_;
655 
656     // Mapping from owner to list of owned token IDs
657     mapping(address => uint256[]) internal ownedTokens;
658     
659     // Array with transferable Tokens
660     uint256[] internal transferableTokens;
661 
662     /**
663     * @dev Constructor function
664     */
665     constructor(string _name, string _symbol, string _uriPrefix, address _storage) public {
666         require(_storage != address(0), "Storage Address is required");
667         name_ = _name;
668         symbol_ = _symbol;
669 
670         // register the supported interfaces to conform to ERC721 via ERC165
671         _registerInterface(InterfaceId_ERC721Enumerable);
672         _registerInterface(InterfaceId_ERC721Metadata);
673         cbStorage = IEntityStorage(_storage);
674         uriPrefix = _uriPrefix;
675     }
676 
677     /**
678     * @dev Gets the token name
679     * @return string representing the token name
680     */
681     function name() external view returns (string) {
682         return name_;
683     }
684 
685     /**
686     * @dev Gets the token symbol
687     * @return string representing the token symbol
688     */
689     function symbol() external view returns (string) {
690         return symbol_;
691     }
692 
693     /**
694     * @dev Returns an URI for a given token ID
695     * Throws if the token ID does not exist. May return an empty string.
696     * @param _tokenId uint256 ID of the token to query
697     */
698     function tokenURI(uint256 _tokenId) public view returns (string) {
699         require(exists(_tokenId));
700         return strConcat(uriPrefix, uintToString(_tokenId));
701     }
702 
703     /**
704     * @dev Gets the total amount of tokens stored by the contract
705     * @return uint256 representing the total amount of tokens
706     */
707     function totalSupply() public view returns (uint256) {
708         return cbStorage.totalSupply();
709     }
710 
711     /**
712     * @dev Internal function to add a token ID to the list owned by a given address
713     * @param _to address representing the new owner of the token ID
714     * @param _tokenId uint256 ID of the token to be added 
715     */
716     function addTokenTo(address _to, uint256 _tokenId) internal {
717         super.addTokenTo(_to, _tokenId);
718         ownedTokens[_to].push(_tokenId);
719     }
720 
721     /**
722     * @dev Internal function to remove a token ID from the list owned by a given address
723     * @param _from address representing the previous owner of the token ID
724     * @param _tokenId uint256 ID of the token to be removed
725     */
726     function removeTokenFrom(address _from, uint256 _tokenId) internal {
727         super.removeTokenFrom(_from, _tokenId);
728 
729         uint256 tokenIndex = 0;
730         while (ownedTokens[_from][tokenIndex] != _tokenId && tokenIndex < ownedTokens[_from].length) {
731             tokenIndex++;
732         }
733         // Reorg allTokens array
734         uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
735         uint256 lastToken = ownedTokens[_from][lastTokenIndex];
736 
737         ownedTokens[_from][tokenIndex] = lastToken;
738         ownedTokens[_from][lastTokenIndex] = 0;
739 
740         ownedTokens[_from].length--;
741     }
742 
743     /**
744     * @dev Internal function to burn a specific token
745     * Reverts if the token does not exist, or is marked transferable
746     * @param _owner owner address of the token being burned
747     * @param _tokenId uint256 ID of the token being burned 
748     */
749     function _burn(address _owner, uint256 _tokenId) internal {
750         // cannot burn a token that is up for sale
751         require(!isTransferable(_tokenId)); //, "_burn"
752         super._burn(_owner, _tokenId);
753         cbStorage.remove(_tokenId);
754     }
755 
756     /**
757     * @dev Gets the number of tokens owned by the specified address
758     * @param _owner address of the token owner
759     * @return uint256 the number of tokens owned 
760     */
761     function balanceOf(address _owner) public view returns (uint256) {
762         require(_owner != address(0));
763         return ownedTokens[_owner].length;
764     }
765 
766         /**
767     * @dev List all token Ids that can be transfered
768     * @return array of token IDs
769     */
770     function listTransferableTokens() public view returns(uint256[]) {
771         return transferableTokens;
772     } 
773 
774     /**
775     * @dev Is Token Transferable
776     * @param _tokenId uint256 ID of the token
777     * @return bool is tokenId transferable 
778     */
779     function isTransferable(uint256 _tokenId) public view returns (bool) {
780         for (uint256 index = 0; index < transferableTokens.length; index++) {
781             if (transferableTokens[index] == _tokenId) {
782                 return true;
783             }
784         }
785         return false;
786     }
787 
788     /**
789     * @dev Returns whether the given spender can transfer a given token ID
790     * @param _spender address of the spender to query
791     * @param _tokenId uint256 ID of the token to be transferred
792     * @return bool whether the token is transferable and msg.sender is approved for the given token ID,
793     *  is an operator of the owner, or is the owner of the token
794     */
795     function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
796         address owner = ownerOf(_tokenId);
797         if (isTransferable(_tokenId)) {
798             return (_spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender));
799         }
800         return false;
801     }
802 
803     /**
804     * Converts a uint, such aa a token ID number, to a string
805     */
806     function uintToString(uint v) internal pure returns (string str) {
807         uint maxlength = 100;
808         bytes memory reversed = new bytes(maxlength);
809         uint i = 0;
810         while (v != 0) {
811             uint remainder = v % 10;
812             v = v / 10;
813             reversed[i++] = byte(48 + remainder);
814         }
815         bytes memory s = new bytes(i);
816         for (uint j = 0; j < i; j++) {
817             s[j] = reversed[i - 1 - j];
818         }
819         str = string(s);
820     }
821 
822     /**
823     * Basic smashing together of strings.
824     */
825     function strConcat(string _a, string _b)internal pure returns (string) {
826         bytes memory _ba = bytes(_a);
827         bytes memory _bb = bytes(_b);
828         string memory ab = new string(_ba.length + _bb.length);
829         bytes memory ba = bytes(ab);
830         uint k = 0;
831         for (uint i = 0; i < _ba.length; i++) ba[k++] = _ba[i];
832         for (i = 0; i < _bb.length; i++) ba[k++] = _bb[i];
833         return string(ba);
834     }
835 }
836 
837 // File: contracts/Ownable.sol
838 
839 /**
840  * @title Ownable
841  * @dev The Ownable contract has an owner address, and provides basic authorization control
842  * functions, this simplifies the implementation of "user permissions".
843  */
844 contract Ownable {
845     address public owner;
846     address public newOwner;
847     
848     // mapping for creature Type to Sale
849     address[] internal controllers;
850     //mapping(address => address) internal controllers;
851     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
852 
853    /**
854    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
855    * account.
856    */
857     constructor() public {
858         owner = msg.sender;
859     }
860    
861     /**
862     * @dev Throws if called by any account that's not a superuser.
863     */
864     modifier onlyController() {
865         require(isController(msg.sender), "only Controller");
866         _;
867     }
868 
869     modifier onlyOwnerOrController() {
870         require(msg.sender == owner || isController(msg.sender), "only Owner Or Controller");
871         _;
872     }
873 
874     /**
875     * @dev Throws if called by any account other than the owner.
876     */
877     modifier onlyOwner() {
878         require(msg.sender == owner, "sender address must be the owner's address");
879         _;
880     }
881 
882     /**
883     * @dev Allows the current owner to transfer control of the contract to a newOwner.
884     * @param _newOwner The address to transfer ownership to.
885     */
886     function transferOwnership(address _newOwner) public onlyOwner {
887         require(address(0) != _newOwner, "new owner address must not be the owner's address");
888         newOwner = _newOwner;
889     }
890 
891     /**
892     * @dev Allows the new owner to confirm that they are taking control of the contract..tr
893     */
894     function acceptOwnership() public {
895         require(msg.sender == newOwner, "sender address must not be the new owner's address");
896         emit OwnershipTransferred(owner, msg.sender);
897         owner = msg.sender;
898         newOwner = address(0);
899     }
900 
901     function isController(address _controller) internal view returns(bool) {
902         for (uint8 index = 0; index < controllers.length; index++) {
903             if (controllers[index] == _controller) {
904                 return true;
905             }
906         }
907         return false;
908     }
909 
910     function getControllers() public onlyOwner view returns(address[]) {
911         return controllers;
912     }
913 
914     /**
915     * @dev Allows a new controllers to be added
916     * @param _controller The address controller.
917     */
918     function addController(address _controller) public onlyOwner {
919         require(address(0) != _controller, "controller address must not be 0");
920         require(_controller != owner, "controller address must not be the owner's address");
921         for (uint8 index = 0; index < controllers.length; index++) {
922             if (controllers[index] == _controller) {
923                 return;
924             }
925         }
926         controllers.push(_controller);
927     }
928 
929     /**
930     * @dev Allows a new controllers to be added
931     * @param _controller The address controller.
932     */
933     function removeController(address _controller) public onlyOwner {
934         require(address(0) != _controller, "controller address must not be 0");
935         for (uint8 index = 0; index < controllers.length; index++) {
936             if (controllers[index] == _controller) {
937                 delete controllers[index];
938             }
939         }
940     }
941 }
942 
943 // File: contracts/ICryptoBeastiesToken.sol
944 
945 interface ICryptoBeastiesToken {
946     function bulk(uint256[] _tokenIds, uint256[] _attributes, address[] _owners) external;
947     function create(uint256 _tokenId, uint256 _attributes, uint256[] _componentIds, address _owner) external;
948     function tokensOfOwner(address _owner) external view returns (uint256[] tokens);
949     function getProperties(uint256 _tokenId) external view returns (uint256 attrs, uint256[] compIds); 
950     function updateAttributes(uint256 _tokenId, uint256 _attributes, uint256[] _componentIds) external; 
951     function updateStorage(address _storage) external;
952     function listTokens() external view returns (uint256[] tokens);
953     function setURI(string _uriPrefix) external;
954     function setTransferable(uint256 _tokenId) external;
955     function removeTransferable(uint256 _tokenId) external;
956 }
957 
958 // File: contracts/CryptoBeastiesToken.sol
959 
960 /**
961  * @title CryptoBeasties Full ERC721 Token
962  * This implementation includes all the required and some optional functionality of the ERC721 standard,
963  * plus references a separate storage contract for recording the game-specific data for each token. 
964  * CryptoBeasties content and source code is Copyright (C) 2018 PlayStakes LLC, All rights reserved.
965  */
966 contract CryptoBeastiesToken is ERC721Token, Ownable, ICryptoBeastiesToken { 
967     using SafeMath for uint256;
968 
969     address proxyRegistryAddress;
970 
971     /**
972     * @dev Constructor function
973     * @param _storage address for Creature Storage
974     * @param _uriPrefix string for url prefix
975     */
976     constructor(address _storage, string _uriPrefix) 
977         ERC721Token("CryptoBeasties Token", "CRYB", _uriPrefix, _storage) public {
978         proxyRegistryAddress = address(0);
979     }
980 
981     /**
982     * @dev Set a Proxy Registry Address, to be used by 3rd-party marketplaces.
983     * @param _proxyRegistryAddress Address of the marketplace's proxy registry address
984     */
985     function setProxyRegistryAddress(address _proxyRegistryAddress) external onlyOwnerOrController {
986         proxyRegistryAddress = _proxyRegistryAddress;
987     }
988 
989     /**
990     * @dev Bulk load a number of tokens, as a way of reducing gas fees and migration time.
991     * @param _tokenIds Array of tokenIds
992     * @param _attributes Matching array of CryptoBeasties attributes
993     * @param _owners Matching array of token owner addresses
994     */
995     function bulk(uint256[] _tokenIds, uint256[] _attributes, address[] _owners) external onlyOwnerOrController {
996         for (uint index = 0; index < _tokenIds.length; index++) {
997             ownedTokens[_owners[index]].push(_tokenIds[index]);
998             tokenOwner[_tokenIds[index]] = _owners[index];
999             emit Transfer(address(0), _owners[index], _tokenIds[index]);
1000         }
1001         cbStorage.storeBulk(_tokenIds, _attributes);
1002     }
1003 
1004     /**
1005     * @dev Create CryptoBeasties Token 
1006     * @param _tokenId ID of the new token
1007     * @param _attributes CryptoBeasties attributes
1008     * @param _owner address of the token owner
1009     */
1010     function create(uint256 _tokenId, uint256 _attributes, uint256[] _componentIds, address _owner) external onlyOwnerOrController {
1011         require(!super.exists(_tokenId));
1012         require(_owner != address(0));
1013         require(_attributes > 0); 
1014         super._mint(_owner, _tokenId);
1015         cbStorage.store(_tokenId, _attributes, _componentIds);
1016     }
1017 
1018    /**
1019    * Override isApprovedForAll to whitelist a 3rd-party marketplace's proxy accounts to enable gas-less listings.
1020    */
1021     function isApprovedForAll(
1022         address owner,
1023         address operator
1024     )
1025     public
1026     view
1027     returns (bool)
1028     {
1029         if (proxyRegistryAddress != address(0)) {
1030             ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1031             if (proxyRegistry.proxies(owner) == operator) {
1032                 return true;
1033             }
1034         }
1035 
1036         return super.isApprovedForAll(owner, operator);
1037     }
1038 
1039     /**
1040     * @dev List all token ids for a owner
1041     * @param _owner address of the token owner
1042     */
1043     function tokensOfOwner(address _owner) external view returns (uint256[]) {
1044         return ownedTokens[_owner];
1045     }
1046     
1047     /**
1048     * @dev List all token ids, an array of their attributes and an array componentIds (i.e. PowerStones)
1049     * @param _owner address for the given token ID
1050     */
1051     function getOwnedTokenData(
1052         address _owner
1053         ) 
1054         public 
1055         view 
1056         returns 
1057         (
1058             uint256[] tokens, 
1059             uint256[] attrs, 
1060             uint256[] componentIds, 
1061             bool[] isTransferable
1062         ) {
1063 
1064         uint256[] memory tokenIds = this.tokensOfOwner(_owner);
1065         uint256[] memory attribs = new uint256[](tokenIds.length);
1066         uint256[] memory firstCompIds = new uint256[](tokenIds.length);
1067         bool[] memory transferable = new bool[](tokenIds.length);
1068         
1069         uint256[] memory compIds;
1070 
1071         for (uint i = 0; i < tokenIds.length; i++) {
1072             (attribs[i], compIds) = cbStorage.getAttributes(tokenIds[i]);
1073             transferable[i] = this.isTransferable(tokenIds[i]);
1074             if (compIds.length > 0)
1075             {
1076                 firstCompIds[i] = compIds[0];
1077             }
1078         }
1079         return (tokenIds, attribs, firstCompIds, transferable);
1080     }
1081 
1082     /**
1083     * @dev Get attributes and Component Ids (i.e. PowerStones) CryptoBeastie
1084     * @param _tokenId uint256 for the given token
1085     */
1086     function getProperties(uint256 _tokenId) external view returns (uint256 attrs, uint256[] compIds) {
1087         return cbStorage.getAttributes(_tokenId);
1088     }
1089 
1090     /**
1091     * @dev attributes and Component Ids (i.e. PowerStones) CryptoBeastie
1092     * @param _tokenId uint256 for the given token
1093     * @param _attributes Cryptobeasties attributes
1094     * @param _componentIds Array of Cryptobeasties componentIds (i.e. PowerStones)
1095     */
1096     function updateAttributes(uint256 _tokenId, uint256 _attributes, uint256[] _componentIds) external {
1097         require(ownerOf(_tokenId) == msg.sender || owner == msg.sender || isController(msg.sender)); //, "token owner"
1098         cbStorage.updateAttributes(_tokenId, _attributes, _componentIds);
1099     }
1100 
1101     /**
1102     * @dev Update the reference to the CryptoBeasties storage contract
1103     * @param _storage address for CryptoBeasties storage contract
1104     */
1105     function updateStorage(address _storage) external  onlyOwnerOrController {
1106         cbStorage = IEntityStorage(_storage);
1107     }
1108 
1109     /**
1110     * @dev List all of the CryptoBeasties token Ids held in the Storage Contract
1111     */
1112     function listTokens() external view returns (uint256[] tokens) {
1113         return cbStorage.list();
1114     }
1115 
1116     /**
1117     * @dev Update the URI prefix
1118     * @param _uriPrefix string for url prefix
1119     */
1120     function setURI(string _uriPrefix) external onlyOwnerOrController {
1121         uriPrefix = _uriPrefix;
1122     }
1123 
1124     /**
1125     * @dev Bulk setup of token Ids that can be transferred
1126     * @param _tokenIds array of token Ids that will be set for transfer
1127     */
1128     function bulkTransferable(uint256[] _tokenIds) external {
1129         address _owner = ownerOf(_tokenIds[0]);
1130         require(_owner == msg.sender || owner == msg.sender || isController(msg.sender)); //, "token owner"
1131         for (uint256 index = 0; index < _tokenIds.length; index++) {
1132             if (_owner == msg.sender) {
1133                 require(ownerOf(_tokenIds[index]) == _owner); //, "token owner"
1134             } 
1135             transferableTokens.push(_tokenIds[index]);
1136         }
1137     }
1138 
1139     /**
1140     * @dev Set a Token Id that can be transfer
1141     * @param _tokenId Token Id that will be set for transfer
1142     */
1143     function setTransferable(uint256 _tokenId) external {
1144         require(ownerOf(_tokenId) == msg.sender || owner == msg.sender || isController(msg.sender)); //, "token owner"
1145         transferableTokens.push(_tokenId);
1146     }
1147 
1148     /**
1149     * @dev Bulk remove transferability of token Ids
1150     * @param _tokenIds array of token Ids that will be removed for transfer
1151     */
1152     function bulkRemoveTransferable(uint256[] _tokenIds) external {
1153         address _owner = ownerOf(_tokenIds[0]);
1154         require(_owner == msg.sender || owner == msg.sender || isController(msg.sender)); //, "token owner"
1155         for (uint256 index = 0; index < _tokenIds.length; index++) {
1156             if (_owner == msg.sender) {
1157                 require(ownerOf(_tokenIds[index]) == _owner); //, "token owner"
1158             }
1159             _removeTransfer(_tokenIds[index]);
1160         }
1161     }
1162 
1163     /**
1164     * @dev A token Id that will be removed from transfer
1165     * @param _tokenId Token Id that will be removed for transfer
1166     */
1167     function removeTransferable(uint256 _tokenId) external {
1168         require(ownerOf(_tokenId) == msg.sender || owner == msg.sender || isController(msg.sender)); //, "token owner"
1169         _removeTransfer(_tokenId);
1170     }
1171 
1172     /**
1173     * @dev Internal function to remove transferability of a token Id
1174     * @param _tokenId Token Id that will be removed for Transfer
1175     */
1176     function _removeTransfer(uint256 _tokenId) internal {
1177         uint256 tokenIndex = 0;
1178         while (transferableTokens[tokenIndex] != _tokenId && tokenIndex < transferableTokens.length) {
1179             tokenIndex++;
1180         }
1181 
1182         // Reorg allTokens array
1183         uint256 lastTokenIndex = transferableTokens.length.sub(1);
1184         uint256 lastToken = transferableTokens[lastTokenIndex];
1185 
1186         transferableTokens[tokenIndex] = lastToken;
1187         transferableTokens[lastTokenIndex] = 0;
1188 
1189         transferableTokens.length--;
1190     }
1191 
1192     /**
1193     * @dev Support merging multiple tokens into one, to increase XP and level-up the target.
1194     * @param _mergeTokenIds Array of tokens to be removed and merged into the target
1195     * @param _targetTokenId The token whose attributes will be improved by the merge
1196     * @param _targetAttributes The new improved attributes for the target token
1197     */
1198     function mergeTokens(uint256[] _mergeTokenIds, uint256 _targetTokenId, uint256 _targetAttributes) external {
1199         address _owner = ownerOf(_targetTokenId);
1200         require(_owner == msg.sender || owner == msg.sender || isController(msg.sender)); //, "token owner"
1201         require(_mergeTokenIds.length > 0); //, "mergeTokens"
1202         require(!isTransferable(_targetTokenId)); // cannot target a token that is up for sale
1203 
1204 
1205         // remove merge material tokens
1206         for (uint256 index = 0; index < _mergeTokenIds.length; index++) {
1207             require(ownerOf(_mergeTokenIds[index]) == _owner); //, "array"
1208             _burn(_owner, _mergeTokenIds[index]);
1209         }
1210 
1211         // update target token
1212         uint256 attribs;
1213         uint256[] memory compIds;
1214         (attribs, compIds) = cbStorage.getAttributes(_targetTokenId);
1215         cbStorage.updateAttributes(_targetTokenId, _targetAttributes, compIds);
1216     }
1217 }
1218 
1219 contract OwnableDelegateProxy { }
1220 
1221 contract ProxyRegistry {
1222     mapping(address => OwnableDelegateProxy) public proxies;
1223 }