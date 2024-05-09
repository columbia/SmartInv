1 pragma solidity ^0.4.25;
2 
3 
4 /**
5 * WHAT IS OpenEthereumToken?   
6  * OpenEthereumToken for general ethereum NFT token use; NFT Block Chain Token, URL link, Ethereum Interface,
7  *                                      Data Rewrite possible, On Chain Data Storage, Transfer of Token
8  * 
9  *      Pay to Recieve token     Individual Token Optimization   Security Useage
10  * 
11  * Contract for OET tokens
12  *                      How to Use:
13  *                              Send Ether to Contract Address Min amount 0.16 
14  *                              Automatically recieve 1 OET Token to payee address, Inventory Number as next Minted
15  *                              Add Token Information with addTokenData function (with contract write)
16  *                                      any Information / Data can be written to Chain
17  *                              Transfer via SafeTransfers (with contract write)
18  * 
19  *
20 **/
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26 
27 
28     /**
29      * @dev Multiplies two numbers, throws on overflow.
30      */
31     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
32         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
33         // benefit is lost if 'b' is also tested.
34         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
35         if (a == 0) {
36             return 0;
37         }
38 
39 
40         c = a * b;
41         assert(c / a == b);
42         return c;
43     }
44 
45 
46     /**
47      * @dev Integer division of two numbers, truncating the quotient.
48      */
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         // assert(b > 0); // Solidity automatically throws when dividing by 0
51         // uint256 c = a / b;
52         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53         return a / b;
54     }
55 
56 
57     /**
58      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
59      */
60     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61         assert(b <= a);
62         return a - b;
63     }
64 
65 
66     /**
67      * @dev Adds two numbers, throws on overflow.
68      */
69     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
70         c = a + b;
71         assert(c >= a);
72         return c;
73     }
74 }
75 
76 
77 
78 
79 /**
80  * Utility library of inline functions on addresses
81  */
82 library AddressUtils {
83 
84 
85     /**
86      * Returns whether the target address is a contract
87      * @dev This function will return false if invoked during the constructor of a contract,
88      *  as the code is not actually created until after the constructor finishes.
89      * @param addr address to check
90      * @return whether the target address is a contract
91      */
92     function isContract(address addr) internal view returns (bool) {
93         uint256 size;
94         // XXX Currently there is no better way to check if there is a contract in an address
95         // than to check the size of the code at that address.
96         // See https://ethereum.stackexchange.com/a/14016/36603
97         // for more details about how this works.
98         // TODO Check this again before the Serenity release, because all addresses will be
99         // contracts then.
100         // solium-disable-next-line security/no-inline-assembly
101         assembly { size := extcodesize(addr) }
102         return size > 0;
103     }
104 
105 
106 }
107 
108 
109 
110 
111 /**
112  * @title ERC721 token receiver interface
113  * @dev Interface for any contract that wants to support safeTransfers
114  * from ERC721 asset contracts.
115  */
116 contract ERC721Receiver {
117     /**
118     * @dev Magic value to be returned upon successful reception of an NFT
119     *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
120     *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
121     */
122     bytes4 internal constant ERC721_RECEIVED = 0xf0b9e5ba;
123 
124 
125     /**
126     * @notice Handle the receipt of an NFT
127     * @dev The ERC721 smart contract calls this function on the recipient
128     * after a `safetransfer`. This function MAY throw to revert and reject the
129     * transfer. This function MUST use 50,000 gas or less. Return of other
130     * than the magic value MUST result in the transaction being reverted.
131     * Note: the contract address is always the message sender.
132     * @param _from The sending address
133     * @param _tokenId The NFT identifier which is being transfered
134     * @param _data Additional data with no specified format
135     * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
136     */
137     function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
138 }
139 
140 
141 /**
142  * @title ERC165
143  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
144  */
145 interface ERC165 {
146 
147 
148     /**
149      * @notice Query if a contract implements an interface
150      * @param _interfaceId The interface identifier, as specified in ERC-165
151      * @dev Interface identification is specified in ERC-165. This function
152      * uses less than 30,000 gas.
153      */
154     function supportsInterface(bytes4 _interfaceId) external view returns (bool);
155 }
156 
157 
158 
159 
160 /**
161  * @title ERC721 Non-Fungible Token Standard basic interface
162  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
163  */
164 contract ERC721Basic is ERC165 {
165     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
166     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
167     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
168 
169 
170     function balanceOf(address _owner) public view returns (uint256 _balance);
171     function ownerOf(uint256 _tokenId) public view returns (address _owner);
172     function exists(uint256 _tokenId) public view returns (bool _exists);
173 
174 
175     function approve(address _to, uint256 _tokenId) public;
176     function getApproved(uint256 _tokenId) public view returns (address _operator);
177 
178 
179     function setApprovalForAll(address _operator, bool _approved) public;
180     function isApprovedForAll(address _owner, address _operator) public view returns (bool);
181 
182 
183     function transferFrom(address _from, address _to, uint256 _tokenId) public;
184     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
185 
186 
187     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public;
188 }
189 
190 
191 
192 
193 /**
194  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
195  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
196  */
197 contract ERC721Enumerable is ERC721Basic {
198     function totalSupply() public view returns (uint256);
199     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
200     function tokenByIndex(uint256 _index) public view returns (uint256);
201 }
202 
203 
204 
205 
206 /**
207  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
208  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
209  */
210 contract ERC721Metadata is ERC721Basic {
211     function name() external view returns (string _name);
212     function symbol() external view returns (string _symbol);
213     function tokenURI(uint256 _tokenId) public view returns (string);
214 }
215 
216 
217 
218 
219 /**
220  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
221  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
222  */
223 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
224 
225 
226 }
227 
228 
229 
230 
231 contract ERC721Holder is ERC721Receiver {
232     function onERC721Received(address, uint256, bytes) public returns(bytes4) {
233         return ERC721_RECEIVED;
234     }
235 }
236 
237 
238 
239 
240 /**
241  * @title SupportsInterfaceWithLookup
242  * @author Matt Condon (@shrugs)
243  * @dev Implements ERC165 using a lookup table.
244  */
245 contract SupportsInterfaceWithLookup is ERC165 {
246     bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
247     /**
248      * 0x01ffc9a7 ===
249      *   bytes4(keccak256('supportsInterface(bytes4)'))
250      */
251 
252 
253     /**
254      * @dev a mapping of interface id to whether or not it's supported
255      */
256     mapping(bytes4 => bool) internal supportedInterfaces;
257 
258 
259     /**
260      * @dev A contract implementing SupportsInterfaceWithLookup
261      * implement ERC165 itself
262      */
263     constructor() public {
264         _registerInterface(InterfaceId_ERC165);
265     }
266 
267 
268     /**
269      * @dev implement supportsInterface(bytes4) using a lookup table
270      */
271     function supportsInterface(bytes4 _interfaceId) external view returns (bool) {
272         return supportedInterfaces[_interfaceId];
273     }
274 
275 
276     /**
277      * @dev private method for registering an interface
278      */
279     function _registerInterface(bytes4 _interfaceId) internal {
280         require(_interfaceId != 0xffffffff);
281         supportedInterfaces[_interfaceId] = true;
282     }
283 }
284 
285 
286 
287 
288 /**
289  * @title ERC721 Non-Fungible Token Standard basic implementation
290  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
291  */
292 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
293 
294 
295     bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
296     /*
297      * 0x80ac58cd ===
298      *   bytes4(keccak256('balanceOf(address)')) ^
299      *   bytes4(keccak256('ownerOf(uint256)')) ^
300      *   bytes4(keccak256('approve(address,uint256)')) ^
301      *   bytes4(keccak256('getApproved(uint256)')) ^
302      *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
303      *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
304      *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
305      *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
306      *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
307      */
308 
309 
310     bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
311     /*
312      * 0x4f558e79 ===
313      *   bytes4(keccak256('exists(uint256)'))
314      */
315 
316 
317     using SafeMath for uint256;
318     using AddressUtils for address;
319 
320 
321     // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
322     // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
323     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
324 
325 
326     // Mapping from token ID to owner
327     mapping (uint256 => address) internal tokenOwner;
328 
329 
330     // Mapping from token ID to approved address
331     mapping (uint256 => address) internal tokenApprovals;
332 
333 
334     // Mapping from owner to number of owned token
335     mapping (address => uint256) internal ownedTokensCount;
336 
337 
338     // Mapping from owner to operator approvals
339     mapping (address => mapping (address => bool)) internal operatorApprovals;
340 
341 
342     /**
343      * @dev Guarantees msg.sender is owner of the given token
344      * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
345      */
346     modifier onlyOwnerOf(uint256 _tokenId) {
347         require(ownerOf(_tokenId) == msg.sender);
348         _;
349     }
350 
351 
352     /**
353      * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
354      * @param _tokenId uint256 ID of the token to validate
355      */
356     modifier canTransfer(uint256 _tokenId) {
357         require(isApprovedOrOwner(msg.sender, _tokenId));
358         _;
359     }
360 
361 
362     constructor() public {
363         // register the supported interfaces to conform to ERC721 via ERC165
364         _registerInterface(InterfaceId_ERC721);
365         _registerInterface(InterfaceId_ERC721Exists);
366     }
367 
368 
369     /**
370      * @dev Gets the balance of the specified address
371      * @param _owner address to query the balance of
372      * @return uint256 representing the amount owned by the passed address
373      */
374     function balanceOf(address _owner) public view returns (uint256) {
375         require(_owner != address(0));
376         return ownedTokensCount[_owner];
377     }
378 
379 
380     /**
381      * @dev Gets the owner of the specified token ID
382      * @param _tokenId uint256 ID of the token to query the owner of
383      * @return owner address currently marked as the owner of the given token ID
384      */
385     function ownerOf(uint256 _tokenId) public view returns (address) {
386         address owner = tokenOwner[_tokenId];
387         require(owner != address(0));
388         return owner;
389     }
390 
391 
392     /**
393      * @dev Returns whether the specified token exists
394      * @param _tokenId uint256 ID of the token to query the existence of
395      * @return whether the token exists
396      */
397     function exists(uint256 _tokenId) public view returns (bool) {
398         address owner = tokenOwner[_tokenId];
399         return owner != address(0);
400     }
401 
402 
403     /**
404      * @dev Approves another address to transfer the given token ID
405      * @dev The zero address indicates there is no approved address.
406      * @dev There can only be one approved address per token at a given time.
407      * @dev Can only be called by the token owner or an approved operator.
408      * @param _to address to be approved for the given token ID
409      * @param _tokenId uint256 ID of the token to be approved
410      */
411     function approve(address _to, uint256 _tokenId) public {
412         address owner = ownerOf(_tokenId);
413         require(_to != owner);
414         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
415 
416 
417         tokenApprovals[_tokenId] = _to;
418         emit Approval(owner, _to, _tokenId);
419     }
420 
421 
422     /**
423      * @dev Gets the approved address for a token ID, or zero if no address set
424      * @param _tokenId uint256 ID of the token to query the approval of
425      * @return address currently approved for the given token ID
426      */
427     function getApproved(uint256 _tokenId) public view returns (address) {
428         return tokenApprovals[_tokenId];
429     }
430 
431 
432     /**
433      * @dev Sets or unsets the approval of a given operator
434      * @dev An operator is allowed to transfer all tokens of the sender on their behalf
435      * @param _to operator address to set the approval
436      * @param _approved representing the status of the approval to be set
437      */
438     function setApprovalForAll(address _to, bool _approved) public {
439         require(_to != msg.sender);
440         operatorApprovals[msg.sender][_to] = _approved;
441         emit ApprovalForAll(msg.sender, _to, _approved);
442     }
443 
444 
445     /**
446      * @dev Tells whether an operator is approved by a given owner
447      * @param _owner owner address which you want to query the approval of
448      * @param _operator operator address which you want to query the approval of
449      * @return bool whether the given operator is approved by the given owner
450      */
451     function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
452         return operatorApprovals[_owner][_operator];
453     }
454 
455 
456     /**
457      * @dev Transfers the ownership of a given token ID to another address
458      * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
459      * @dev Requires the msg sender to be the owner, approved, or operator
460      * @param _from current owner of the token
461      * @param _to address to receive the ownership of the given token ID
462      * @param _tokenId uint256 ID of the token to be transferred
463     */
464     function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
465         require(_from != address(0));
466         require(_to != address(0));
467 
468 
469         clearApproval(_from, _tokenId);
470         removeTokenFrom(_from, _tokenId);
471         addTokenTo(_to, _tokenId);
472 
473 
474         emit Transfer(_from, _to, _tokenId);
475     }
476 
477 
478     /**
479      * @dev Safely transfers the ownership of a given token ID to another address
480      * @dev If the target address is a contract, it must implement `onERC721Received`,
481      *  which is called upon a safe transfer, and return the magic value
482      *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
483      *  the transfer is reverted.
484      * @dev Requires the msg sender to be the owner, approved, or operator
485      * @param _from current owner of the token
486      * @param _to address to receive the ownership of the given token ID
487      * @param _tokenId uint256 ID of the token to be transferred
488     */
489     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
490         // solium-disable-next-line arg-overflow
491         safeTransferFrom(_from, _to, _tokenId, "");
492     }
493 
494 
495     /**
496      * @dev Safely transfers the ownership of a given token ID to another address
497      * @dev If the target address is a contract, it must implement `onERC721Received`,
498      *  which is called upon a safe transfer, and return the magic value
499      *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
500      *  the transfer is reverted.
501      * @dev Requires the msg sender to be the owner, approved, or operator
502      * @param _from current owner of the token
503      * @param _to address to receive the ownership of the given token ID
504      * @param _tokenId uint256 ID of the token to be transferred
505      * @param _data bytes data to send along with a safe transfer check
506      */
507     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public canTransfer(_tokenId) {
508         transferFrom(_from, _to, _tokenId);
509         // solium-disable-next-line arg-overflow
510         require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
511     }
512 
513 
514     /**
515      * @dev Returns whether the given spender can transfer a given token ID
516      * @param _spender address of the spender to query
517      * @param _tokenId uint256 ID of the token to be transferred
518      * @return bool whether the msg.sender is approved for the given token ID,
519      *  is an operator of the owner, or is the owner of the token
520      */
521     function isApprovedOrOwner(
522         address _spender,
523         uint256 _tokenId
524     )
525         internal
526         view
527         returns (bool)
528     {
529         address owner = ownerOf(_tokenId);
530         // Disable solium check because of
531         // https://github.com/duaraghav8/Solium/issues/175
532         // solium-disable-next-line operator-whitespace
533         return (
534             _spender == owner ||
535             getApproved(_tokenId) == _spender ||
536             isApprovedForAll(owner, _spender)
537         );
538     }
539 
540 
541     /**
542      * @dev Internal function to mint a new token
543      * @dev Reverts if the given token ID already exists
544      * @param _to The address that will own the minted token
545      * @param _tokenId uint256 ID of the token to be minted by the msg.sender
546      */
547     function _mint(address _to, uint256 _tokenId) internal {
548         require(_to != address(0));
549         addTokenTo(_to, _tokenId);
550         emit Transfer(address(0), _to, _tokenId);
551     }
552 
553 
554     /**
555      * @dev Internal function to clear current approval of a given token ID
556      * @dev Reverts if the given address is not indeed the owner of the token
557      * @param _owner owner of the token
558      * @param _tokenId uint256 ID of the token to be transferred
559      */
560     function clearApproval(address _owner, uint256 _tokenId) internal {
561         require(ownerOf(_tokenId) == _owner);
562         if (tokenApprovals[_tokenId] != address(0)) {
563             tokenApprovals[_tokenId] = address(0);
564             emit Approval(_owner, address(0), _tokenId);
565         }
566     }
567 
568 
569     /**
570      * @dev Internal function to add a token ID to the list of a given address
571      * @param _to address representing the new owner of the given token ID
572      * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
573      */
574     function addTokenTo(address _to, uint256 _tokenId) internal {
575         require(tokenOwner[_tokenId] == address(0));
576         tokenOwner[_tokenId] = _to;
577         ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
578     }
579 
580 
581     /**
582      * @dev Internal function to remove a token ID from the list of a given address
583      * @param _from address representing the previous owner of the given token ID
584      * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
585      */
586     function removeTokenFrom(address _from, uint256 _tokenId) internal {
587         require(ownerOf(_tokenId) == _from);
588         ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
589         tokenOwner[_tokenId] = address(0);
590     }
591 
592 
593     /**
594      * @dev Internal function to invoke `onERC721Received` on a target address
595      * The call is not executed if the target address is not a contract
596      * @param _from address representing the previous owner of the given token ID
597      * @param _to target address that will receive the tokens
598      * @param _tokenId uint256 ID of the token to be transferred
599      * @param _data bytes optional data to send along with the call
600      * @return whether the call correctly returned the expected magic value
601      */
602     function checkAndCallSafeTransfer(
603         address _from,
604         address _to,
605         uint256 _tokenId,
606         bytes _data
607     )
608         internal
609         returns (bool)
610     {
611         if (!_to.isContract()) {
612             return true;
613         }
614 
615 
616         bytes4 retval = ERC721Receiver(_to).onERC721Received(
617         _from, _tokenId, _data);
618         return (retval == ERC721_RECEIVED);
619     }
620 }
621 
622 
623 
624 
625 /**
626  * @title Ownable
627  * @dev The Ownable contract has an owner address, and provides basic authorization control
628  * functions, this simplifies the implementation of "user permissions".
629  */
630  contract Ownable {
631      address public owner;
632      address public pendingOwner;
633      address public manager;
634 
635 
636      event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
637 
638 
639      /**
640      * @dev Throws if called by any account other than the owner.
641      */
642      modifier onlyOwner() {
643          require(msg.sender == owner);
644          _;
645      }
646 
647 
648      /**
649       * @dev Modifier throws if called by any account other than the manager.
650       */
651      modifier onlyManager() {
652          require(msg.sender == manager);
653          _;
654      }
655 
656 
657      /**
658       * @dev Modifier throws if called by any account other than the pendingOwner.
659       */
660      modifier onlyPendingOwner() {
661          require(msg.sender == pendingOwner);
662          _;
663      }
664 
665 
666      constructor() public {
667          owner = msg.sender;
668      }
669 
670 
671      /**
672       * @dev Allows the current owner to set the pendingOwner address.
673       * @param newOwner The address to transfer ownership to.
674       */
675      function transferOwnership(address newOwner) public onlyOwner {
676          pendingOwner = newOwner;
677      }
678 
679 
680      /**
681       * @dev Allows the pendingOwner address to finalize the transfer.
682       */
683      function claimOwnership() public onlyPendingOwner {
684          emit OwnershipTransferred(owner, pendingOwner);
685          owner = pendingOwner;
686          pendingOwner = address(0);
687      }
688 
689 
690      /**
691       * @dev Sets the manager address.
692       * @param _manager The manager address.
693       */
694      function setManager(address _manager) public onlyOwner {
695          require(_manager != address(0));
696          manager = _manager;
697      }
698 
699 
700  }
701 
702 
703 
704 
705 
706 
707 /**
708  * @title Full ERC721 Token
709  * This implementation includes all the required and some optional functionality of the ERC721 standard
710  * Moreover, it includes approve all functionality using operator terminology
711  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
712  */
713 contract OpenEthereumToken is SupportsInterfaceWithLookup, ERC721, ERC721BasicToken, Ownable {
714 
715 
716     bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
717     /**
718      * 0x780e9d63 ===
719      *   bytes4(keccak256('totalSupply()')) ^
720      *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
721      *   bytes4(keccak256('tokenByIndex(uint256)'))
722      */
723 
724 
725     bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
726     /**
727      * 0x5b5e139f ===
728      *   bytes4(keccak256('name()')) ^
729      *   bytes4(keccak256('symbol()')) ^
730      *   bytes4(keccak256('tokenURI(uint256)'))
731      */
732 
733 
734     // Token name
735     string public name_ = "OpenEthereumToken";
736 
737 
738     // Token symbol
739     string public symbol_ = "OET";
740     
741     uint public tokenIDCount = 0;
742 
743 
744     // Mapping from owner to list of owned token IDs
745     mapping(address => uint256[]) internal ownedTokens;
746 
747 
748     // Mapping from token ID to index of the owner tokens list
749     mapping(uint256 => uint256) internal ownedTokensIndex;
750 
751 
752     // Array with all token ids, used for enumeration
753     uint256[] internal allTokens;
754 
755 
756     // Mapping from token id to position in the allTokens array
757     mapping(uint256 => uint256) internal allTokensIndex;
758 
759 
760     // Optional mapping for token URIs
761     mapping(uint256 => string) internal tokenURIs;
762 
763 
764     struct Data{
765         string information;
766         string URL;
767     }
768     
769     mapping(uint256 => Data) internal tokenData;
770     /**
771      * @dev Constructor function
772      */
773     constructor() public {
774 
775 
776 
777 
778         // register the supported interfaces to conform to ERC721 via ERC165
779         _registerInterface(InterfaceId_ERC721Enumerable);
780         _registerInterface(InterfaceId_ERC721Metadata);
781     }
782 
783 
784     /**
785      * @dev External function to mint a new token
786      * @dev Reverts if the given token ID already exists
787      * @param _to address the beneficiary that will own the minted token
788      */
789     function mint(address _to) external onlyManager {
790         _mint(_to, tokenIDCount++);
791     }
792 
793 
794     /**
795      * @dev Gets the token name
796      * @return string representing the token name
797      */
798     function name() external view returns (string) {
799         return name_;
800     }
801 
802 
803     /**
804      * @dev Gets the token symbol
805      * @return string representing the token symbol
806      */
807     function symbol() external view returns (string) {
808         return symbol_;
809     }
810 
811 
812     function arrayOfTokensByAddress(address _holder) public view returns(uint256[]) {
813         return ownedTokens[_holder];
814     }
815 
816 
817     /**
818      * @dev Returns an URI for a given token ID
819      * @dev Throws if the token ID does not exist. May return an empty string.
820      * @param _tokenId uint256 ID of the token to query
821      */
822     function tokenURI(uint256 _tokenId) public view returns (string) {
823         require(exists(_tokenId));
824         return tokenURIs[_tokenId];
825     }
826 
827 
828     /**
829      * @dev Gets the token ID at a given index of the tokens list of the requested owner
830      * @param _owner address owning the tokens list to be accessed
831      * @param _index uint256 representing the index to be accessed of the requested tokens list
832      * @return uint256 token ID at the given index of the tokens list owned by the requested address
833      */
834     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
835         require(_index < balanceOf(_owner));
836         return ownedTokens[_owner][_index];
837     }
838 
839 
840     /**
841      * @dev Gets the total amount of tokens stored by the contract
842      * @return uint256 representing the total amount of tokens
843      */
844     function totalSupply() public view returns (uint256) {
845         return allTokens.length;
846     }
847 
848 
849     /**
850      * @dev Gets the token ID at a given index of all the tokens in this contract
851      * @dev Reverts if the index is greater or equal to the total number of tokens
852      * @param _index uint256 representing the index to be accessed of the tokens list
853      * @return uint256 token ID at the given index of the tokens list
854      */
855     function tokenByIndex(uint256 _index) public view returns (uint256) {
856         require(_index < totalSupply());
857         return allTokens[_index];
858     }
859 
860 
861     /**
862      * @dev Internal function to set the token URI for a given token
863      * @dev Reverts if the token ID does not exist
864      * @param _tokenId uint256 ID of the token to set its URI
865      * @param _uri string URI to assign
866      */
867     function _setTokenURI(uint256 _tokenId, string _uri) internal {
868         require(exists(_tokenId));
869         tokenURIs[_tokenId] = _uri;
870     }
871 
872 
873     /**
874      * @dev Internal function to add a token ID to the list of a given address
875      * @param _to address representing the new owner of the given token ID
876      * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
877      */
878     function addTokenTo(address _to, uint256 _tokenId) internal {
879         super.addTokenTo(_to, _tokenId);
880         uint256 length = ownedTokens[_to].length;
881         ownedTokens[_to].push(_tokenId);
882         ownedTokensIndex[_tokenId] = length;
883     }
884 
885 
886     /**
887      * @dev Internal function to remove a token ID from the list of a given address
888      * @param _from address representing the previous owner of the given token ID
889      * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
890      */
891     function removeTokenFrom(address _from, uint256 _tokenId) internal {
892         super.removeTokenFrom(_from, _tokenId);
893 
894 
895         uint256 tokenIndex = ownedTokensIndex[_tokenId];
896         uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
897         uint256 lastToken = ownedTokens[_from][lastTokenIndex];
898 
899 
900         ownedTokens[_from][tokenIndex] = lastToken;
901         ownedTokens[_from][lastTokenIndex] = 0;
902         // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are
903         // going to be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are
904         // first swapping the lastToken to the first position, and then dropping the element placed in the last
905         // position of the list
906 
907 
908         ownedTokens[_from].length--;
909         ownedTokensIndex[_tokenId] = 0;
910         ownedTokensIndex[lastToken] = tokenIndex;
911     }
912 
913 
914     /**
915      * @dev Internal function to mint a new token
916      * @dev Reverts if the given token ID already exists
917      * @param _to address the beneficiary that will own the minted token
918      */
919     function _mint(address _to, uint256 _id) internal {
920         allTokens.push(_id);
921         allTokensIndex[_id] = _id;
922         super._mint(_to, _id);
923     }
924     
925     function addTokenData(uint _tokenId, string _information, string _URL) public {
926             require(ownerOf(_tokenId) == msg.sender);
927             tokenData[_tokenId].information = _information;
928             tokenData[_tokenId].URL = _URL;
929 
930 
931         
932     }
933     
934     function getTokenData(uint _tokenId) public view returns(string Liscence, string URL){
935         require(exists(_tokenId));
936         Liscence = tokenData[_tokenId].information;
937         URL = tokenData[_tokenId].URL;
938     }
939     
940     function() payable{
941         require(msg.value > 0.16 ether);
942         _mint(msg.sender, tokenIDCount++);
943     }
944     
945     function withdraw() public onlyManager{
946         require(0.5 ether > 0);
947         manager.transfer(0.5 ether);
948     }
949 }