1 pragma solidity ^0.4.25;
2 
3 
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12 
13     /**
14      * @dev Multiplies two numbers, throws on overflow.
15      */
16     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
17         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
18         // benefit is lost if 'b' is also tested.
19         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
20         if (a == 0) {
21             return 0;
22         }
23 
24 
25         c = a * b;
26         assert(c / a == b);
27         return c;
28     }
29 
30 
31     /**
32      * @dev Integer division of two numbers, truncating the quotient.
33      */
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         // assert(b > 0); // Solidity automatically throws when dividing by 0
36         // uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38         return a / b;
39     }
40 
41 
42     /**
43      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
44      */
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         assert(b <= a);
47         return a - b;
48     }
49 
50 
51     /**
52      * @dev Adds two numbers, throws on overflow.
53      */
54     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
55         c = a + b;
56         assert(c >= a);
57         return c;
58     }
59 }
60 
61 
62 
63 
64 /**
65  * Utility library of inline functions on addresses
66  */
67 library AddressUtils {
68 
69 
70     /**
71      * Returns whether the target address is a contract
72      * @dev This function will return false if invoked during the constructor of a contract,
73      *  as the code is not actually created until after the constructor finishes.
74      * @param addr address to check
75      * @return whether the target address is a contract
76      */
77     function isContract(address addr) internal view returns (bool) {
78         uint256 size;
79         // XXX Currently there is no better way to check if there is a contract in an address
80         // than to check the size of the code at that address.
81         // See https://ethereum.stackexchange.com/a/14016/36603
82         // for more details about how this works.
83         // TODO Check this again before the Serenity release, because all addresses will be
84         // contracts then.
85         // solium-disable-next-line security/no-inline-assembly
86         assembly { size := extcodesize(addr) }
87         return size > 0;
88     }
89 
90 
91 }
92 
93 
94 
95 
96 /**
97  * @title ERC721 token receiver interface
98  * @dev Interface for any contract that wants to support safeTransfers
99  * from ERC721 asset contracts.
100  */
101 contract ERC721Receiver {
102     /**
103     * @dev Magic value to be returned upon successful reception of an NFT
104     *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
105     *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
106     */
107     bytes4 internal constant ERC721_RECEIVED = 0xf0b9e5ba;
108 
109 
110     /**
111     * @notice Handle the receipt of an NFT
112     * @dev The ERC721 smart contract calls this function on the recipient
113     * after a `safetransfer`. This function MAY throw to revert and reject the
114     * transfer. This function MUST use 50,000 gas or less. Return of other
115     * than the magic value MUST result in the transaction being reverted.
116     * Note: the contract address is always the message sender.
117     * @param _from The sending address
118     * @param _tokenId The NFT identifier which is being transfered
119     * @param _data Additional data with no specified format
120     * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
121     */
122     function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
123 }
124 
125 
126 /**
127  * @title ERC165
128  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
129  */
130 interface ERC165 {
131 
132 
133     /**
134      * @notice Query if a contract implements an interface
135      * @param _interfaceId The interface identifier, as specified in ERC-165
136      * @dev Interface identification is specified in ERC-165. This function
137      * uses less than 30,000 gas.
138      */
139     function supportsInterface(bytes4 _interfaceId) external view returns (bool);
140 }
141 
142 
143 
144 
145 /**
146  * @title ERC721 Non-Fungible Token Standard basic interface
147  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
148  */
149 contract ERC721Basic is ERC165 {
150     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
151     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
152     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
153 
154 
155     function balanceOf(address _owner) public view returns (uint256 _balance);
156     function ownerOf(uint256 _tokenId) public view returns (address _owner);
157     function exists(uint256 _tokenId) public view returns (bool _exists);
158 
159 
160     function approve(address _to, uint256 _tokenId) public;
161     function getApproved(uint256 _tokenId) public view returns (address _operator);
162 
163 
164     function setApprovalForAll(address _operator, bool _approved) public;
165     function isApprovedForAll(address _owner, address _operator) public view returns (bool);
166 
167 
168     function transferFrom(address _from, address _to, uint256 _tokenId) public;
169     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
170 
171 
172     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public;
173 }
174 
175 
176 
177 
178 /**
179  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
180  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
181  */
182 contract ERC721Enumerable is ERC721Basic {
183     function totalSupply() public view returns (uint256);
184     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
185     function tokenByIndex(uint256 _index) public view returns (uint256);
186 }
187 
188 
189 
190 
191 /**
192  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
193  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
194  */
195 contract ERC721Metadata is ERC721Basic {
196     function name() external view returns (string _name);
197     function symbol() external view returns (string _symbol);
198     function tokenURI(uint256 _tokenId) public view returns (string);
199 }
200 
201 
202 
203 
204 /**
205  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
206  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
207  */
208 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
209 
210 
211 }
212 
213 
214 
215 
216 contract ERC721Holder is ERC721Receiver {
217     function onERC721Received(address, uint256, bytes) public returns(bytes4) {
218         return ERC721_RECEIVED;
219     }
220 }
221 
222 
223 
224 
225 /**
226  * @title SupportsInterfaceWithLookup
227  * @author Matt Condon (@shrugs)
228  * @dev Implements ERC165 using a lookup table.
229  */
230 contract SupportsInterfaceWithLookup is ERC165 {
231     bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
232     /**
233      * 0x01ffc9a7 ===
234      *   bytes4(keccak256('supportsInterface(bytes4)'))
235      */
236 
237 
238     /**
239      * @dev a mapping of interface id to whether or not it's supported
240      */
241     mapping(bytes4 => bool) internal supportedInterfaces;
242 
243 
244     /**
245      * @dev A contract implementing SupportsInterfaceWithLookup
246      * implement ERC165 itself
247      */
248     constructor() public {
249         _registerInterface(InterfaceId_ERC165);
250     }
251 
252 
253     /**
254      * @dev implement supportsInterface(bytes4) using a lookup table
255      */
256     function supportsInterface(bytes4 _interfaceId) external view returns (bool) {
257         return supportedInterfaces[_interfaceId];
258     }
259 
260 
261     /**
262      * @dev private method for registering an interface
263      */
264     function _registerInterface(bytes4 _interfaceId) internal {
265         require(_interfaceId != 0xffffffff);
266         supportedInterfaces[_interfaceId] = true;
267     }
268 }
269 
270 
271 
272 
273 /**
274  * @title ERC721 Non-Fungible Token Standard basic implementation
275  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
276  */
277 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
278 
279 
280     bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
281     /*
282      * 0x80ac58cd ===
283      *   bytes4(keccak256('balanceOf(address)')) ^
284      *   bytes4(keccak256('ownerOf(uint256)')) ^
285      *   bytes4(keccak256('approve(address,uint256)')) ^
286      *   bytes4(keccak256('getApproved(uint256)')) ^
287      *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
288      *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
289      *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
290      *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
291      *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
292      */
293 
294 
295     bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
296     /*
297      * 0x4f558e79 ===
298      *   bytes4(keccak256('exists(uint256)'))
299      */
300 
301 
302     using SafeMath for uint256;
303     using AddressUtils for address;
304 
305 
306     // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
307     // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
308     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
309 
310 
311     // Mapping from token ID to owner
312     mapping (uint256 => address) internal tokenOwner;
313 
314 
315     // Mapping from token ID to approved address
316     mapping (uint256 => address) internal tokenApprovals;
317 
318 
319     // Mapping from owner to number of owned token
320     mapping (address => uint256) internal ownedTokensCount;
321 
322 
323     // Mapping from owner to operator approvals
324     mapping (address => mapping (address => bool)) internal operatorApprovals;
325 
326 
327     /**
328      * @dev Guarantees msg.sender is owner of the given token
329      * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
330      */
331     modifier onlyOwnerOf(uint256 _tokenId) {
332         require(ownerOf(_tokenId) == msg.sender);
333         _;
334     }
335 
336 
337     /**
338      * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
339      * @param _tokenId uint256 ID of the token to validate
340      */
341     modifier canTransfer(uint256 _tokenId) {
342         require(isApprovedOrOwner(msg.sender, _tokenId));
343         _;
344     }
345 
346 
347     constructor() public {
348         // register the supported interfaces to conform to ERC721 via ERC165
349         _registerInterface(InterfaceId_ERC721);
350         _registerInterface(InterfaceId_ERC721Exists);
351     }
352 
353 
354     /**
355      * @dev Gets the balance of the specified address
356      * @param _owner address to query the balance of
357      * @return uint256 representing the amount owned by the passed address
358      */
359     function balanceOf(address _owner) public view returns (uint256) {
360         require(_owner != address(0));
361         return ownedTokensCount[_owner];
362     }
363 
364 
365     /**
366      * @dev Gets the owner of the specified token ID
367      * @param _tokenId uint256 ID of the token to query the owner of
368      * @return owner address currently marked as the owner of the given token ID
369      */
370     function ownerOf(uint256 _tokenId) public view returns (address) {
371         address owner = tokenOwner[_tokenId];
372         require(owner != address(0));
373         return owner;
374     }
375 
376 
377     /**
378      * @dev Returns whether the specified token exists
379      * @param _tokenId uint256 ID of the token to query the existence of
380      * @return whether the token exists
381      */
382     function exists(uint256 _tokenId) public view returns (bool) {
383         address owner = tokenOwner[_tokenId];
384         return owner != address(0);
385     }
386 
387 
388     /**
389      * @dev Approves another address to transfer the given token ID
390      * @dev The zero address indicates there is no approved address.
391      * @dev There can only be one approved address per token at a given time.
392      * @dev Can only be called by the token owner or an approved operator.
393      * @param _to address to be approved for the given token ID
394      * @param _tokenId uint256 ID of the token to be approved
395      */
396     function approve(address _to, uint256 _tokenId) public {
397         address owner = ownerOf(_tokenId);
398         require(_to != owner);
399         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
400 
401 
402         tokenApprovals[_tokenId] = _to;
403         emit Approval(owner, _to, _tokenId);
404     }
405 
406 
407     /**
408      * @dev Gets the approved address for a token ID, or zero if no address set
409      * @param _tokenId uint256 ID of the token to query the approval of
410      * @return address currently approved for the given token ID
411      */
412     function getApproved(uint256 _tokenId) public view returns (address) {
413         return tokenApprovals[_tokenId];
414     }
415 
416 
417     /**
418      * @dev Sets or unsets the approval of a given operator
419      * @dev An operator is allowed to transfer all tokens of the sender on their behalf
420      * @param _to operator address to set the approval
421      * @param _approved representing the status of the approval to be set
422      */
423     function setApprovalForAll(address _to, bool _approved) public {
424         require(_to != msg.sender);
425         operatorApprovals[msg.sender][_to] = _approved;
426         emit ApprovalForAll(msg.sender, _to, _approved);
427     }
428 
429 
430     /**
431      * @dev Tells whether an operator is approved by a given owner
432      * @param _owner owner address which you want to query the approval of
433      * @param _operator operator address which you want to query the approval of
434      * @return bool whether the given operator is approved by the given owner
435      */
436     function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
437         return operatorApprovals[_owner][_operator];
438     }
439 
440 
441     /**
442      * @dev Transfers the ownership of a given token ID to another address
443      * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
444      * @dev Requires the msg sender to be the owner, approved, or operator
445      * @param _from current owner of the token
446      * @param _to address to receive the ownership of the given token ID
447      * @param _tokenId uint256 ID of the token to be transferred
448     */
449     function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
450         require(_from != address(0));
451         require(_to != address(0));
452 
453 
454         clearApproval(_from, _tokenId);
455         removeTokenFrom(_from, _tokenId);
456         addTokenTo(_to, _tokenId);
457 
458 
459         emit Transfer(_from, _to, _tokenId);
460     }
461 
462 
463     /**
464      * @dev Safely transfers the ownership of a given token ID to another address
465      * @dev If the target address is a contract, it must implement `onERC721Received`,
466      *  which is called upon a safe transfer, and return the magic value
467      *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
468      *  the transfer is reverted.
469      * @dev Requires the msg sender to be the owner, approved, or operator
470      * @param _from current owner of the token
471      * @param _to address to receive the ownership of the given token ID
472      * @param _tokenId uint256 ID of the token to be transferred
473     */
474     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
475         // solium-disable-next-line arg-overflow
476         safeTransferFrom(_from, _to, _tokenId, "");
477     }
478 
479 
480     /**
481      * @dev Safely transfers the ownership of a given token ID to another address
482      * @dev If the target address is a contract, it must implement `onERC721Received`,
483      *  which is called upon a safe transfer, and return the magic value
484      *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
485      *  the transfer is reverted.
486      * @dev Requires the msg sender to be the owner, approved, or operator
487      * @param _from current owner of the token
488      * @param _to address to receive the ownership of the given token ID
489      * @param _tokenId uint256 ID of the token to be transferred
490      * @param _data bytes data to send along with a safe transfer check
491      */
492     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public canTransfer(_tokenId) {
493         transferFrom(_from, _to, _tokenId);
494         // solium-disable-next-line arg-overflow
495         require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
496     }
497 
498 
499     /**
500      * @dev Returns whether the given spender can transfer a given token ID
501      * @param _spender address of the spender to query
502      * @param _tokenId uint256 ID of the token to be transferred
503      * @return bool whether the msg.sender is approved for the given token ID,
504      *  is an operator of the owner, or is the owner of the token
505      */
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
519             _spender == owner ||
520             getApproved(_tokenId) == _spender ||
521             isApprovedForAll(owner, _spender)
522         );
523     }
524 
525 
526     /**
527      * @dev Internal function to mint a new token
528      * @dev Reverts if the given token ID already exists
529      * @param _to The address that will own the minted token
530      * @param _tokenId uint256 ID of the token to be minted by the msg.sender
531      */
532     function _mint(address _to, uint256 _tokenId) internal {
533         require(_to != address(0));
534         addTokenTo(_to, _tokenId);
535         emit Transfer(address(0), _to, _tokenId);
536     }
537 
538 
539     /**
540      * @dev Internal function to clear current approval of a given token ID
541      * @dev Reverts if the given address is not indeed the owner of the token
542      * @param _owner owner of the token
543      * @param _tokenId uint256 ID of the token to be transferred
544      */
545     function clearApproval(address _owner, uint256 _tokenId) internal {
546         require(ownerOf(_tokenId) == _owner);
547         if (tokenApprovals[_tokenId] != address(0)) {
548             tokenApprovals[_tokenId] = address(0);
549             emit Approval(_owner, address(0), _tokenId);
550         }
551     }
552 
553 
554     /**
555      * @dev Internal function to add a token ID to the list of a given address
556      * @param _to address representing the new owner of the given token ID
557      * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
558      */
559     function addTokenTo(address _to, uint256 _tokenId) internal {
560         require(tokenOwner[_tokenId] == address(0));
561         tokenOwner[_tokenId] = _to;
562         ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
563     }
564 
565 
566     /**
567      * @dev Internal function to remove a token ID from the list of a given address
568      * @param _from address representing the previous owner of the given token ID
569      * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
570      */
571     function removeTokenFrom(address _from, uint256 _tokenId) internal {
572         require(ownerOf(_tokenId) == _from);
573         ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
574         tokenOwner[_tokenId] = address(0);
575     }
576 
577 
578     /**
579      * @dev Internal function to invoke `onERC721Received` on a target address
580      * The call is not executed if the target address is not a contract
581      * @param _from address representing the previous owner of the given token ID
582      * @param _to target address that will receive the tokens
583      * @param _tokenId uint256 ID of the token to be transferred
584      * @param _data bytes optional data to send along with the call
585      * @return whether the call correctly returned the expected magic value
586      */
587     function checkAndCallSafeTransfer(
588         address _from,
589         address _to,
590         uint256 _tokenId,
591         bytes _data
592     )
593         internal
594         returns (bool)
595     {
596         if (!_to.isContract()) {
597             return true;
598         }
599 
600 
601         bytes4 retval = ERC721Receiver(_to).onERC721Received(
602         _from, _tokenId, _data);
603         return (retval == ERC721_RECEIVED);
604     }
605 }
606 
607 
608 
609 
610 /**
611  * @title Ownable
612  * @dev The Ownable contract has an owner address, and provides basic authorization control
613  * functions, this simplifies the implementation of "user permissions".
614  */
615  contract Ownable {
616      address public owner;
617      address public pendingOwner;
618      address public manager;
619 
620 
621      event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
622 
623 
624      /**
625      * @dev Throws if called by any account other than the owner.
626      */
627      modifier onlyOwner() {
628          require(msg.sender == owner);
629          _;
630      }
631 
632 
633      /**
634       * @dev Modifier throws if called by any account other than the manager.
635       */
636      modifier onlyManager() {
637          require(msg.sender == manager);
638          _;
639      }
640 
641 
642      /**
643       * @dev Modifier throws if called by any account other than the pendingOwner.
644       */
645      modifier onlyPendingOwner() {
646          require(msg.sender == pendingOwner);
647          _;
648      }
649 
650 
651      constructor() public {
652          owner = msg.sender;
653      }
654 
655 
656      /**
657       * @dev Allows the current owner to set the pendingOwner address.
658       * @param newOwner The address to transfer ownership to.
659       */
660      function transferOwnership(address newOwner) public onlyOwner {
661          pendingOwner = newOwner;
662      }
663 
664 
665      /**
666       * @dev Allows the pendingOwner address to finalize the transfer.
667       */
668      function claimOwnership() public onlyPendingOwner {
669          emit OwnershipTransferred(owner, pendingOwner);
670          owner = pendingOwner;
671          pendingOwner = address(0);
672      }
673 
674 
675      /**
676       * @dev Sets the manager address.
677       * @param _manager The manager address.
678       */
679      function setManager(address _manager) public onlyOwner {
680          require(_manager != address(0));
681          manager = _manager;
682      }
683 
684 
685  }
686 
687 
688 
689 
690 
691 
692 /**
693  * @title Full ERC721 Token
694  * This implementation includes all the required and some optional functionality of the ERC721 standard
695  * Moreover, it includes approve all functionality using operator terminology
696  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
697  */
698 contract GeneralEthereumToken is SupportsInterfaceWithLookup, ERC721, ERC721BasicToken, Ownable {
699 
700 
701     bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
702     /**
703      * 0x780e9d63 ===
704      *   bytes4(keccak256('totalSupply()')) ^
705      *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
706      *   bytes4(keccak256('tokenByIndex(uint256)'))
707      */
708 
709 
710     bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
711     /**
712      * 0x5b5e139f ===
713      *   bytes4(keccak256('name()')) ^
714      *   bytes4(keccak256('symbol()')) ^
715      *   bytes4(keccak256('tokenURI(uint256)'))
716      */
717 
718 
719     // Token name
720     string public name_ = "GeneralEthereumToken";
721 
722 
723     // Token symbol
724     string public symbol_ = "GET";
725     
726     uint public tokenIDCount = 0;
727 
728 
729     // Mapping from owner to list of owned token IDs
730     mapping(address => uint256[]) internal ownedTokens;
731 
732 
733     // Mapping from token ID to index of the owner tokens list
734     mapping(uint256 => uint256) internal ownedTokensIndex;
735 
736 
737     // Array with all token ids, used for enumeration
738     uint256[] internal allTokens;
739 
740 
741     // Mapping from token id to position in the allTokens array
742     mapping(uint256 => uint256) internal allTokensIndex;
743 
744 
745     // Optional mapping for token URIs
746     mapping(uint256 => string) internal tokenURIs;
747 
748 
749     struct Data{
750         string information;
751         string URL;
752     }
753     
754     mapping(uint256 => Data) internal tokenData;
755     /**
756      * @dev Constructor function
757      */
758     constructor() public {
759 
760 
761 
762 
763         // register the supported interfaces to conform to ERC721 via ERC165
764         _registerInterface(InterfaceId_ERC721Enumerable);
765         _registerInterface(InterfaceId_ERC721Metadata);
766     }
767 
768 
769     /**
770      * @dev External function to mint a new token
771      * @dev Reverts if the given token ID already exists
772      * @param _to address the beneficiary that will own the minted token
773      */
774     function mint(address _to) external onlyManager {
775         _mint(_to, tokenIDCount++);
776     }
777 
778 
779     /**
780      * @dev Gets the token name
781      * @return string representing the token name
782      */
783     function name() external view returns (string) {
784         return name_;
785     }
786 
787 
788     /**
789      * @dev Gets the token symbol
790      * @return string representing the token symbol
791      */
792     function symbol() external view returns (string) {
793         return symbol_;
794     }
795 
796 
797     function arrayOfTokensByAddress(address _holder) public view returns(uint256[]) {
798         return ownedTokens[_holder];
799     }
800 
801 
802     /**
803      * @dev Returns an URI for a given token ID
804      * @dev Throws if the token ID does not exist. May return an empty string.
805      * @param _tokenId uint256 ID of the token to query
806      */
807     function tokenURI(uint256 _tokenId) public view returns (string) {
808         require(exists(_tokenId));
809         return tokenURIs[_tokenId];
810     }
811 
812 
813     /**
814      * @dev Gets the token ID at a given index of the tokens list of the requested owner
815      * @param _owner address owning the tokens list to be accessed
816      * @param _index uint256 representing the index to be accessed of the requested tokens list
817      * @return uint256 token ID at the given index of the tokens list owned by the requested address
818      */
819     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
820         require(_index < balanceOf(_owner));
821         return ownedTokens[_owner][_index];
822     }
823 
824 
825     /**
826      * @dev Gets the total amount of tokens stored by the contract
827      * @return uint256 representing the total amount of tokens
828      */
829     function totalSupply() public view returns (uint256) {
830         return allTokens.length;
831     }
832 
833 
834     /**
835      * @dev Gets the token ID at a given index of all the tokens in this contract
836      * @dev Reverts if the index is greater or equal to the total number of tokens
837      * @param _index uint256 representing the index to be accessed of the tokens list
838      * @return uint256 token ID at the given index of the tokens list
839      */
840     function tokenByIndex(uint256 _index) public view returns (uint256) {
841         require(_index < totalSupply());
842         return allTokens[_index];
843     }
844 
845 
846     /**
847      * @dev Internal function to set the token URI for a given token
848      * @dev Reverts if the token ID does not exist
849      * @param _tokenId uint256 ID of the token to set its URI
850      * @param _uri string URI to assign
851      */
852     function _setTokenURI(uint256 _tokenId, string _uri) internal {
853         require(exists(_tokenId));
854         tokenURIs[_tokenId] = _uri;
855     }
856 
857 
858     /**
859      * @dev Internal function to add a token ID to the list of a given address
860      * @param _to address representing the new owner of the given token ID
861      * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
862      */
863     function addTokenTo(address _to, uint256 _tokenId) internal {
864         super.addTokenTo(_to, _tokenId);
865         uint256 length = ownedTokens[_to].length;
866         ownedTokens[_to].push(_tokenId);
867         ownedTokensIndex[_tokenId] = length;
868     }
869 
870 
871     /**
872      * @dev Internal function to remove a token ID from the list of a given address
873      * @param _from address representing the previous owner of the given token ID
874      * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
875      */
876     function removeTokenFrom(address _from, uint256 _tokenId) internal {
877         super.removeTokenFrom(_from, _tokenId);
878 
879 
880         uint256 tokenIndex = ownedTokensIndex[_tokenId];
881         uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
882         uint256 lastToken = ownedTokens[_from][lastTokenIndex];
883 
884 
885         ownedTokens[_from][tokenIndex] = lastToken;
886         ownedTokens[_from][lastTokenIndex] = 0;
887         // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are
888         // going to be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are
889         // first swapping the lastToken to the first position, and then dropping the element placed in the last
890         // position of the list
891 
892 
893         ownedTokens[_from].length--;
894         ownedTokensIndex[_tokenId] = 0;
895         ownedTokensIndex[lastToken] = tokenIndex;
896     }
897 
898 
899     /**
900      * @dev Internal function to mint a new token
901      * @dev Reverts if the given token ID already exists
902      * @param _to address the beneficiary that will own the minted token
903      */
904     function _mint(address _to, uint256 _id) internal {
905         allTokens.push(_id);
906         allTokensIndex[_id] = _id;
907         super._mint(_to, _id);
908     }
909     
910     function addTokenData(uint _tokenId, string _information, string _URL) public {
911             require(ownerOf(_tokenId) == msg.sender);
912             tokenData[_tokenId].information = _information;
913             tokenData[_tokenId].URL = _URL;
914 
915 
916         
917     }
918     
919     function getTokenData(uint _tokenId) public view returns(string Liscence, string URL){
920         require(exists(_tokenId));
921         Liscence = tokenData[_tokenId].information;
922         URL = tokenData[_tokenId].URL;
923     }
924     
925     function() payable{
926         require(msg.value > 0.16 ether);
927         _mint(msg.sender, tokenIDCount++);
928     }
929     
930     function withdraw() public onlyManager{
931         require(0.5 ether > 0);
932         manager.transfer(0.5 ether);
933     }
934 }