1 pragma solidity 0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11      * @dev Multiplies two numbers, throws on overflow.
12      */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         c = a * b;
22         assert(c / a == b);
23         return c;
24     }
25 
26     /**
27      * @dev Integer division of two numbers, truncating the quotient.
28      */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         // uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return a / b;
34     }
35 
36     /**
37      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38      */
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     /**
45      * @dev Adds two numbers, throws on overflow.
46      */
47     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48         c = a + b;
49         assert(c >= a);
50         return c;
51     }
52 }
53 
54 
55 /**
56  * Utility library of inline functions on addresses
57  */
58 library AddressUtils {
59 
60     /**
61      * Returns whether the target address is a contract
62      * @dev This function will return false if invoked during the constructor of a contract,
63      *  as the code is not actually created until after the constructor finishes.
64      * @param addr address to check
65      * @return whether the target address is a contract
66      */
67     function isContract(address addr) internal view returns (bool) {
68         uint256 size;
69         // XXX Currently there is no better way to check if there is a contract in an address
70         // than to check the size of the code at that address.
71         // See https://ethereum.stackexchange.com/a/14016/36603
72         // for more details about how this works.
73         // TODO Check this again before the Serenity release, because all addresses will be
74         // contracts then.
75         // solium-disable-next-line security/no-inline-assembly
76         assembly { size := extcodesize(addr) }
77         return size > 0;
78     }
79 
80 }
81 
82 
83 /**
84  * @title ERC721 token receiver interface
85  * @dev Interface for any contract that wants to support safeTransfers
86  * from ERC721 asset contracts.
87  */
88 contract ERC721Receiver {
89     /**
90     * @dev Magic value to be returned upon successful reception of an NFT
91     *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
92     *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
93     */
94     bytes4 internal constant ERC721_RECEIVED = 0xf0b9e5ba;
95 
96     /**
97     * @notice Handle the receipt of an NFT
98     * @dev The ERC721 smart contract calls this function on the recipient
99     * after a `safetransfer`. This function MAY throw to revert and reject the
100     * transfer. This function MUST use 50,000 gas or less. Return of other
101     * than the magic value MUST result in the transaction being reverted.
102     * Note: the contract address is always the message sender.
103     * @param _from The sending address
104     * @param _tokenId The NFT identifier which is being transfered
105     * @param _data Additional data with no specified format
106     * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
107     */
108     function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
109 }
110 
111 /**
112  * @title ERC165
113  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
114  */
115 interface ERC165 {
116 
117     /**
118      * @notice Query if a contract implements an interface
119      * @param _interfaceId The interface identifier, as specified in ERC-165
120      * @dev Interface identification is specified in ERC-165. This function
121      * uses less than 30,000 gas.
122      */
123     function supportsInterface(bytes4 _interfaceId) external view returns (bool);
124 }
125 
126 
127 /**
128  * @title ERC721 Non-Fungible Token Standard basic interface
129  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
130  */
131 contract ERC721Basic is ERC165 {
132     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
133     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
134     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
135 
136     function balanceOf(address _owner) public view returns (uint256 _balance);
137     function ownerOf(uint256 _tokenId) public view returns (address _owner);
138     function exists(uint256 _tokenId) public view returns (bool _exists);
139 
140     function approve(address _to, uint256 _tokenId) public;
141     function getApproved(uint256 _tokenId) public view returns (address _operator);
142 
143     function setApprovalForAll(address _operator, bool _approved) public;
144     function isApprovedForAll(address _owner, address _operator) public view returns (bool);
145 
146     function transferFrom(address _from, address _to, uint256 _tokenId) public;
147     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
148 
149     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public;
150 }
151 
152 
153 /**
154  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
155  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
156  */
157 contract ERC721Enumerable is ERC721Basic {
158     function totalSupply() public view returns (uint256);
159     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
160     function tokenByIndex(uint256 _index) public view returns (uint256);
161 }
162 
163 
164 /**
165  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
166  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
167  */
168 contract ERC721Metadata is ERC721Basic {
169     function name() external view returns (string _name);
170     function symbol() external view returns (string _symbol);
171     function tokenURI(uint256 _tokenId) public view returns (string);
172 }
173 
174 
175 /**
176  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
177  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
178  */
179 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
180 
181 }
182 
183 
184 contract ERC721Holder is ERC721Receiver {
185     function onERC721Received(address, uint256, bytes) public returns(bytes4) {
186         return ERC721_RECEIVED;
187     }
188 }
189 
190 
191 /**
192  * @title SupportsInterfaceWithLookup
193  * @author Matt Condon (@shrugs)
194  * @dev Implements ERC165 using a lookup table.
195  */
196 contract SupportsInterfaceWithLookup is ERC165 {
197     bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
198     /**
199      * 0x01ffc9a7 ===
200      *   bytes4(keccak256('supportsInterface(bytes4)'))
201      */
202 
203     /**
204      * @dev a mapping of interface id to whether or not it's supported
205      */
206     mapping(bytes4 => bool) internal supportedInterfaces;
207 
208     /**
209      * @dev A contract implementing SupportsInterfaceWithLookup
210      * implement ERC165 itself
211      */
212     constructor() public {
213         _registerInterface(InterfaceId_ERC165);
214     }
215 
216     /**
217      * @dev implement supportsInterface(bytes4) using a lookup table
218      */
219     function supportsInterface(bytes4 _interfaceId) external view returns (bool) {
220         return supportedInterfaces[_interfaceId];
221     }
222 
223     /**
224      * @dev private method for registering an interface
225      */
226     function _registerInterface(bytes4 _interfaceId) internal {
227         require(_interfaceId != 0xffffffff);
228         supportedInterfaces[_interfaceId] = true;
229     }
230 }
231 
232 
233 /**
234  * @title ERC721 Non-Fungible Token Standard basic implementation
235  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
236  */
237 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
238 
239     bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
240     /*
241      * 0x80ac58cd ===
242      *   bytes4(keccak256('balanceOf(address)')) ^
243      *   bytes4(keccak256('ownerOf(uint256)')) ^
244      *   bytes4(keccak256('approve(address,uint256)')) ^
245      *   bytes4(keccak256('getApproved(uint256)')) ^
246      *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
247      *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
248      *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
249      *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
250      *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
251      */
252 
253     bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
254     /*
255      * 0x4f558e79 ===
256      *   bytes4(keccak256('exists(uint256)'))
257      */
258 
259     using SafeMath for uint256;
260     using AddressUtils for address;
261 
262     // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
263     // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
264     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
265 
266     // Mapping from token ID to owner
267     mapping (uint256 => address) internal tokenOwner;
268 
269     // Mapping from token ID to approved address
270     mapping (uint256 => address) internal tokenApprovals;
271 
272     // Mapping from owner to number of owned token
273     mapping (address => uint256) internal ownedTokensCount;
274 
275     // Mapping from owner to operator approvals
276     mapping (address => mapping (address => bool)) internal operatorApprovals;
277 
278     /**
279      * @dev Guarantees msg.sender is owner of the given token
280      * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
281      */
282     modifier onlyOwnerOf(uint256 _tokenId) {
283         require(ownerOf(_tokenId) == msg.sender);
284         _;
285     }
286 
287     /**
288      * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
289      * @param _tokenId uint256 ID of the token to validate
290      */
291     modifier canTransfer(uint256 _tokenId) {
292         require(isApprovedOrOwner(msg.sender, _tokenId));
293         _;
294     }
295 
296     constructor() public {
297         // register the supported interfaces to conform to ERC721 via ERC165
298         _registerInterface(InterfaceId_ERC721);
299         _registerInterface(InterfaceId_ERC721Exists);
300     }
301 
302     /**
303      * @dev Gets the balance of the specified address
304      * @param _owner address to query the balance of
305      * @return uint256 representing the amount owned by the passed address
306      */
307     function balanceOf(address _owner) public view returns (uint256) {
308         require(_owner != address(0));
309         return ownedTokensCount[_owner];
310     }
311 
312     /**
313      * @dev Gets the owner of the specified token ID
314      * @param _tokenId uint256 ID of the token to query the owner of
315      * @return owner address currently marked as the owner of the given token ID
316      */
317     function ownerOf(uint256 _tokenId) public view returns (address) {
318         address owner = tokenOwner[_tokenId];
319         require(owner != address(0));
320         return owner;
321     }
322 
323     /**
324      * @dev Returns whether the specified token exists
325      * @param _tokenId uint256 ID of the token to query the existence of
326      * @return whether the token exists
327      */
328     function exists(uint256 _tokenId) public view returns (bool) {
329         address owner = tokenOwner[_tokenId];
330         return owner != address(0);
331     }
332 
333     /**
334      * @dev Approves another address to transfer the given token ID
335      * @dev The zero address indicates there is no approved address.
336      * @dev There can only be one approved address per token at a given time.
337      * @dev Can only be called by the token owner or an approved operator.
338      * @param _to address to be approved for the given token ID
339      * @param _tokenId uint256 ID of the token to be approved
340      */
341     function approve(address _to, uint256 _tokenId) public {
342         address owner = ownerOf(_tokenId);
343         require(_to != owner);
344         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
345 
346         tokenApprovals[_tokenId] = _to;
347         emit Approval(owner, _to, _tokenId);
348     }
349 
350     /**
351      * @dev Gets the approved address for a token ID, or zero if no address set
352      * @param _tokenId uint256 ID of the token to query the approval of
353      * @return address currently approved for the given token ID
354      */
355     function getApproved(uint256 _tokenId) public view returns (address) {
356         return tokenApprovals[_tokenId];
357     }
358 
359     /**
360      * @dev Sets or unsets the approval of a given operator
361      * @dev An operator is allowed to transfer all tokens of the sender on their behalf
362      * @param _to operator address to set the approval
363      * @param _approved representing the status of the approval to be set
364      */
365     function setApprovalForAll(address _to, bool _approved) public {
366         require(_to != msg.sender);
367         operatorApprovals[msg.sender][_to] = _approved;
368         emit ApprovalForAll(msg.sender, _to, _approved);
369     }
370 
371     /**
372      * @dev Tells whether an operator is approved by a given owner
373      * @param _owner owner address which you want to query the approval of
374      * @param _operator operator address which you want to query the approval of
375      * @return bool whether the given operator is approved by the given owner
376      */
377     function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
378         return operatorApprovals[_owner][_operator];
379     }
380 
381     /**
382      * @dev Transfers the ownership of a given token ID to another address
383      * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
384      * @dev Requires the msg sender to be the owner, approved, or operator
385      * @param _from current owner of the token
386      * @param _to address to receive the ownership of the given token ID
387      * @param _tokenId uint256 ID of the token to be transferred
388     */
389     function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
390         require(_from != address(0));
391         require(_to != address(0));
392 
393         clearApproval(_from, _tokenId);
394         removeTokenFrom(_from, _tokenId);
395         addTokenTo(_to, _tokenId);
396 
397         emit Transfer(_from, _to, _tokenId);
398     }
399 
400     /**
401      * @dev Safely transfers the ownership of a given token ID to another address
402      * @dev If the target address is a contract, it must implement `onERC721Received`,
403      *  which is called upon a safe transfer, and return the magic value
404      *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
405      *  the transfer is reverted.
406      * @dev Requires the msg sender to be the owner, approved, or operator
407      * @param _from current owner of the token
408      * @param _to address to receive the ownership of the given token ID
409      * @param _tokenId uint256 ID of the token to be transferred
410     */
411     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
412         // solium-disable-next-line arg-overflow
413         safeTransferFrom(_from, _to, _tokenId, "");
414     }
415 
416     /**
417      * @dev Safely transfers the ownership of a given token ID to another address
418      * @dev If the target address is a contract, it must implement `onERC721Received`,
419      *  which is called upon a safe transfer, and return the magic value
420      *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
421      *  the transfer is reverted.
422      * @dev Requires the msg sender to be the owner, approved, or operator
423      * @param _from current owner of the token
424      * @param _to address to receive the ownership of the given token ID
425      * @param _tokenId uint256 ID of the token to be transferred
426      * @param _data bytes data to send along with a safe transfer check
427      */
428     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public canTransfer(_tokenId) {
429         transferFrom(_from, _to, _tokenId);
430         // solium-disable-next-line arg-overflow
431         require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
432     }
433 
434     /**
435      * @dev Returns whether the given spender can transfer a given token ID
436      * @param _spender address of the spender to query
437      * @param _tokenId uint256 ID of the token to be transferred
438      * @return bool whether the msg.sender is approved for the given token ID,
439      *  is an operator of the owner, or is the owner of the token
440      */
441     function isApprovedOrOwner(
442         address _spender,
443         uint256 _tokenId
444     )
445         internal
446         view
447         returns (bool)
448     {
449         address owner = ownerOf(_tokenId);
450         // Disable solium check because of
451         // https://github.com/duaraghav8/Solium/issues/175
452         // solium-disable-next-line operator-whitespace
453         return (
454             _spender == owner ||
455             getApproved(_tokenId) == _spender ||
456             isApprovedForAll(owner, _spender)
457         );
458     }
459 
460     /**
461      * @dev Internal function to mint a new token
462      * @dev Reverts if the given token ID already exists
463      * @param _to The address that will own the minted token
464      * @param _tokenId uint256 ID of the token to be minted by the msg.sender
465      */
466     function _mint(address _to, uint256 _tokenId) internal {
467         require(_to != address(0));
468         addTokenTo(_to, _tokenId);
469         emit Transfer(address(0), _to, _tokenId);
470     }
471 
472     /**
473      * @dev Internal function to clear current approval of a given token ID
474      * @dev Reverts if the given address is not indeed the owner of the token
475      * @param _owner owner of the token
476      * @param _tokenId uint256 ID of the token to be transferred
477      */
478     function clearApproval(address _owner, uint256 _tokenId) internal {
479         require(ownerOf(_tokenId) == _owner);
480         if (tokenApprovals[_tokenId] != address(0)) {
481             tokenApprovals[_tokenId] = address(0);
482             emit Approval(_owner, address(0), _tokenId);
483         }
484     }
485 
486     /**
487      * @dev Internal function to add a token ID to the list of a given address
488      * @param _to address representing the new owner of the given token ID
489      * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
490      */
491     function addTokenTo(address _to, uint256 _tokenId) internal {
492         require(tokenOwner[_tokenId] == address(0));
493         tokenOwner[_tokenId] = _to;
494         ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
495     }
496 
497     /**
498      * @dev Internal function to remove a token ID from the list of a given address
499      * @param _from address representing the previous owner of the given token ID
500      * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
501      */
502     function removeTokenFrom(address _from, uint256 _tokenId) internal {
503         require(ownerOf(_tokenId) == _from);
504         ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
505         tokenOwner[_tokenId] = address(0);
506     }
507 
508     /**
509      * @dev Internal function to invoke `onERC721Received` on a target address
510      * The call is not executed if the target address is not a contract
511      * @param _from address representing the previous owner of the given token ID
512      * @param _to target address that will receive the tokens
513      * @param _tokenId uint256 ID of the token to be transferred
514      * @param _data bytes optional data to send along with the call
515      * @return whether the call correctly returned the expected magic value
516      */
517     function checkAndCallSafeTransfer(
518         address _from,
519         address _to,
520         uint256 _tokenId,
521         bytes _data
522     )
523         internal
524         returns (bool)
525     {
526         if (!_to.isContract()) {
527             return true;
528         }
529 
530         bytes4 retval = ERC721Receiver(_to).onERC721Received(
531         _from, _tokenId, _data);
532         return (retval == ERC721_RECEIVED);
533     }
534 }
535 
536 
537 /**
538  * @title Ownable
539  * @dev The Ownable contract has an owner address, and provides basic authorization control
540  * functions, this simplifies the implementation of "user permissions".
541  */
542  contract Ownable {
543      address public owner;
544      address public pendingOwner;
545      address public manager;
546 
547      event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
548 
549      /**
550      * @dev Throws if called by any account other than the owner.
551      */
552      modifier onlyOwner() {
553          require(msg.sender == owner);
554          _;
555      }
556 
557      /**
558       * @dev Modifier throws if called by any account other than the manager.
559       */
560      modifier onlyManager() {
561          require(msg.sender == manager);
562          _;
563      }
564 
565      /**
566       * @dev Modifier throws if called by any account other than the pendingOwner.
567       */
568      modifier onlyPendingOwner() {
569          require(msg.sender == pendingOwner);
570          _;
571      }
572 
573      constructor() public {
574          owner = msg.sender;
575      }
576 
577      /**
578       * @dev Allows the current owner to set the pendingOwner address.
579       * @param newOwner The address to transfer ownership to.
580       */
581      function transferOwnership(address newOwner) public onlyOwner {
582          pendingOwner = newOwner;
583      }
584 
585      /**
586       * @dev Allows the pendingOwner address to finalize the transfer.
587       */
588      function claimOwnership() public onlyPendingOwner {
589          emit OwnershipTransferred(owner, pendingOwner);
590          owner = pendingOwner;
591          pendingOwner = address(0);
592      }
593 
594      /**
595       * @dev Sets the manager address.
596       * @param _manager The manager address.
597       */
598      function setManager(address _manager) public onlyOwner {
599          require(_manager != address(0));
600          manager = _manager;
601      }
602 
603  }
604 
605 
606 
607 /**
608  * @title Full ERC721 Token
609  * This implementation includes all the required and some optional functionality of the ERC721 standard
610  * Moreover, it includes approve all functionality using operator terminology
611  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
612  */
613 contract AviationSecurityToken is SupportsInterfaceWithLookup, ERC721, ERC721BasicToken, Ownable {
614 
615     bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
616     /**
617      * 0x780e9d63 ===
618      *   bytes4(keccak256('totalSupply()')) ^
619      *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
620      *   bytes4(keccak256('tokenByIndex(uint256)'))
621      */
622 
623     bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
624     /**
625      * 0x5b5e139f ===
626      *   bytes4(keccak256('name()')) ^
627      *   bytes4(keccak256('symbol()')) ^
628      *   bytes4(keccak256('tokenURI(uint256)'))
629      */
630 
631     // Token name
632     string public name_ = "AviationSecurityToken";
633 
634     // Token symbol
635     string public symbol_ = "AVNS";
636 
637     // Mapping from owner to list of owned token IDs
638     mapping(address => uint256[]) internal ownedTokens;
639 
640     // Mapping from token ID to index of the owner tokens list
641     mapping(uint256 => uint256) internal ownedTokensIndex;
642 
643     // Array with all token ids, used for enumeration
644     uint256[] internal allTokens;
645 
646     // Mapping from token id to position in the allTokens array
647     mapping(uint256 => uint256) internal allTokensIndex;
648 
649     // Optional mapping for token URIs
650     mapping(uint256 => string) internal tokenURIs;
651 
652     struct Data{
653         string liscence;
654         string URL;
655     }
656     
657     mapping(uint256 => Data) internal tokenData;
658     /**
659      * @dev Constructor function
660      */
661     constructor() public {
662 
663 
664         // register the supported interfaces to conform to ERC721 via ERC165
665         _registerInterface(InterfaceId_ERC721Enumerable);
666         _registerInterface(InterfaceId_ERC721Metadata);
667     }
668 
669     /**
670      * @dev External function to mint a new token
671      * @dev Reverts if the given token ID already exists
672      * @param _to address the beneficiary that will own the minted token
673      */
674     function mint(address _to, uint256 _id) external onlyManager {
675         _mint(_to, _id);
676     }
677 
678     /**
679      * @dev Gets the token name
680      * @return string representing the token name
681      */
682     function name() external view returns (string) {
683         return name_;
684     }
685 
686     /**
687      * @dev Gets the token symbol
688      * @return string representing the token symbol
689      */
690     function symbol() external view returns (string) {
691         return symbol_;
692     }
693 
694     function arrayOfTokensByAddress(address _holder) public view returns(uint256[]) {
695         return ownedTokens[_holder];
696     }
697 
698     /**
699      * @dev Returns an URI for a given token ID
700      * @dev Throws if the token ID does not exist. May return an empty string.
701      * @param _tokenId uint256 ID of the token to query
702      */
703     function tokenURI(uint256 _tokenId) public view returns (string) {
704         require(exists(_tokenId));
705         return tokenURIs[_tokenId];
706     }
707 
708     /**
709      * @dev Gets the token ID at a given index of the tokens list of the requested owner
710      * @param _owner address owning the tokens list to be accessed
711      * @param _index uint256 representing the index to be accessed of the requested tokens list
712      * @return uint256 token ID at the given index of the tokens list owned by the requested address
713      */
714     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
715         require(_index < balanceOf(_owner));
716         return ownedTokens[_owner][_index];
717     }
718 
719     /**
720      * @dev Gets the total amount of tokens stored by the contract
721      * @return uint256 representing the total amount of tokens
722      */
723     function totalSupply() public view returns (uint256) {
724         return allTokens.length;
725     }
726 
727     /**
728      * @dev Gets the token ID at a given index of all the tokens in this contract
729      * @dev Reverts if the index is greater or equal to the total number of tokens
730      * @param _index uint256 representing the index to be accessed of the tokens list
731      * @return uint256 token ID at the given index of the tokens list
732      */
733     function tokenByIndex(uint256 _index) public view returns (uint256) {
734         require(_index < totalSupply());
735         return allTokens[_index];
736     }
737 
738     /**
739      * @dev Internal function to set the token URI for a given token
740      * @dev Reverts if the token ID does not exist
741      * @param _tokenId uint256 ID of the token to set its URI
742      * @param _uri string URI to assign
743      */
744     function _setTokenURI(uint256 _tokenId, string _uri) internal {
745         require(exists(_tokenId));
746         tokenURIs[_tokenId] = _uri;
747     }
748 
749     /**
750      * @dev Internal function to add a token ID to the list of a given address
751      * @param _to address representing the new owner of the given token ID
752      * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
753      */
754     function addTokenTo(address _to, uint256 _tokenId) internal {
755         super.addTokenTo(_to, _tokenId);
756         uint256 length = ownedTokens[_to].length;
757         ownedTokens[_to].push(_tokenId);
758         ownedTokensIndex[_tokenId] = length;
759     }
760 
761     /**
762      * @dev Internal function to remove a token ID from the list of a given address
763      * @param _from address representing the previous owner of the given token ID
764      * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
765      */
766     function removeTokenFrom(address _from, uint256 _tokenId) internal {
767         super.removeTokenFrom(_from, _tokenId);
768 
769         uint256 tokenIndex = ownedTokensIndex[_tokenId];
770         uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
771         uint256 lastToken = ownedTokens[_from][lastTokenIndex];
772 
773         ownedTokens[_from][tokenIndex] = lastToken;
774         ownedTokens[_from][lastTokenIndex] = 0;
775         // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are
776         // going to be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are
777         // first swapping the lastToken to the first position, and then dropping the element placed in the last
778         // position of the list
779 
780         ownedTokens[_from].length--;
781         ownedTokensIndex[_tokenId] = 0;
782         ownedTokensIndex[lastToken] = tokenIndex;
783     }
784 
785     /**
786      * @dev Internal function to mint a new token
787      * @dev Reverts if the given token ID already exists
788      * @param _to address the beneficiary that will own the minted token
789      */
790     function _mint(address _to, uint256 _id) internal {
791         allTokens.push(_id);
792         allTokensIndex[_id] = _id;
793         super._mint(_to, _id);
794     }
795     
796     function addTokenData(uint _tokenId, string _liscence, string _URL) public {
797             require(ownerOf(_tokenId) == msg.sender);
798             tokenData[_tokenId].liscence = _liscence;
799             tokenData[_tokenId].URL = _URL;
800 
801         
802     }
803     
804     function getTokenData(uint _tokenId) public view returns(string Liscence, string URL){
805         require(exists(_tokenId));
806         Liscence = tokenData[_tokenId].liscence;
807         URL = tokenData[_tokenId].URL;
808     }
809 }