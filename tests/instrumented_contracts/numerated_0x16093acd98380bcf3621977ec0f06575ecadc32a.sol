1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * See https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address _who) public view returns (uint256);
12   function transfer(address _to, uint256 _value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title ERC165
20  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
21  */
22 interface ERC165 {
23 
24   /**
25    * @notice Query if a contract implements an interface
26    * @param _interfaceId The interface identifier, as specified in ERC-165
27    * @dev Interface identification is specified in ERC-165. This function
28    * uses less than 30,000 gas.
29    */
30   function supportsInterface(bytes4 _interfaceId)
31     external
32     view
33     returns (bool);
34 }
35 
36 
37 contract Activatable {
38     bool public activated;
39 
40     modifier whenActivated {
41         require(activated);
42         _;
43     }
44 
45     modifier whenNotActivated {
46         require(!activated);
47         _;
48     }
49 
50     function activate() public returns (bool) {
51         activated = true;
52         return true;
53     }
54 }
55 
56 
57 
58 /**
59  * @title Ownable
60  * @dev The Ownable contract has an owner address, and provides basic authorization control
61  * functions, this simplifies the implementation of "user permissions".
62  */
63 contract Ownable {
64   address public owner;
65 
66 
67   event OwnershipRenounced(address indexed previousOwner);
68   event OwnershipTransferred(
69     address indexed previousOwner,
70     address indexed newOwner
71   );
72 
73 
74   /**
75    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
76    * account.
77    */
78   constructor() public {
79     owner = msg.sender;
80   }
81 
82   /**
83    * @dev Throws if called by any account other than the owner.
84    */
85   modifier onlyOwner() {
86     require(msg.sender == owner);
87     _;
88   }
89 
90   /**
91    * @dev Allows the current owner to relinquish control of the contract.
92    * @notice Renouncing to ownership will leave the contract without an owner.
93    * It will not be possible to call the functions with the `onlyOwner`
94    * modifier anymore.
95    */
96   function renounceOwnership() public onlyOwner {
97     emit OwnershipRenounced(owner);
98     owner = address(0);
99   }
100 
101   /**
102    * @dev Allows the current owner to transfer control of the contract to a newOwner.
103    * @param _newOwner The address to transfer ownership to.
104    */
105   function transferOwnership(address _newOwner) public onlyOwner {
106     _transferOwnership(_newOwner);
107   }
108 
109   /**
110    * @dev Transfers control of the contract to a newOwner.
111    * @param _newOwner The address to transfer ownership to.
112    */
113   function _transferOwnership(address _newOwner) internal {
114     require(_newOwner != address(0));
115     emit OwnershipTransferred(owner, _newOwner);
116     owner = _newOwner;
117   }
118 }
119 
120 
121 
122 
123 
124 
125 /**
126  * @title SupportsInterfaceWithLookup
127  * @author Matt Condon (@shrugs)
128  * @dev Implements ERC165 using a lookup table.
129  */
130 contract SupportsInterfaceWithLookup is ERC165 {
131 
132   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
133   /**
134    * 0x01ffc9a7 ===
135    *   bytes4(keccak256('supportsInterface(bytes4)'))
136    */
137 
138   /**
139    * @dev a mapping of interface id to whether or not it's supported
140    */
141   mapping(bytes4 => bool) internal supportedInterfaces;
142 
143   /**
144    * @dev A contract implementing SupportsInterfaceWithLookup
145    * implement ERC165 itself
146    */
147   constructor()
148     public
149   {
150     _registerInterface(InterfaceId_ERC165);
151   }
152 
153   /**
154    * @dev implement supportsInterface(bytes4) using a lookup table
155    */
156   function supportsInterface(bytes4 _interfaceId)
157     external
158     view
159     returns (bool)
160   {
161     return supportedInterfaces[_interfaceId];
162   }
163 
164   /**
165    * @dev private method for registering an interface
166    */
167   function _registerInterface(bytes4 _interfaceId)
168     internal
169   {
170     require(_interfaceId != 0xffffffff);
171     supportedInterfaces[_interfaceId] = true;
172   }
173 }
174 
175 
176 contract Contract is Ownable, SupportsInterfaceWithLookup {
177     /**
178      * @notice this.owner.selector ^ this.renounceOwnership.selector ^ this.transferOwnership.selector
179         ^ this.template.selector
180      */
181     bytes4 public constant InterfaceId_Contract = 0x6125ede5;
182 
183     Template public template;
184 
185     constructor(address _owner) public {
186         require(_owner != address(0));
187 
188         template = Template(msg.sender);
189         owner = _owner;
190 
191         _registerInterface(InterfaceId_Contract);
192     }
193 }
194 
195 
196 
197 
198 
199 
200 
201 contract Strategy is Contract, Activatable {
202     /**
203      * @notice this.owner.selector ^ this.renounceOwnership.selector ^ this.transferOwnership.selector
204         ^ this.template.selector ^ this.activate.selector
205      */
206     bytes4 public constant InterfaceId_Strategy = 0x6e301925;
207 
208     constructor(address _owner) public Contract(_owner) {
209         _registerInterface(InterfaceId_Strategy);
210     }
211 
212     function activate() onlyOwner public returns (bool) {
213         return super.activate();
214     }
215 }
216 
217 
218 
219 contract SaleStrategy is Strategy {
220     /**
221      * @notice this.owner.selector ^ this.renounceOwnership.selector ^ this.transferOwnership.selector
222         ^ this.template.selector ^ this.activate.selector ^ this.deactivate.selector
223         ^ this.started.selector ^ this.successful.selector ^ this.finished.selector
224      */
225     bytes4 public constant InterfaceId_SaleStrategy = 0x04c8123d;
226 
227     Sale public sale;
228 
229     constructor(address _owner, Sale _sale) public Strategy(_owner) {
230         sale = _sale;
231 
232         _registerInterface(InterfaceId_SaleStrategy);
233     }
234 
235     modifier whenSaleActivated {
236         require(sale.activated());
237         _;
238     }
239 
240     modifier whenSaleNotActivated {
241         require(!sale.activated());
242         _;
243     }
244 
245     function activate() whenSaleNotActivated public returns (bool) {
246         return super.activate();
247     }
248 
249     function deactivate() onlyOwner whenSaleNotActivated public returns (bool) {
250         activated = false;
251         return true;
252     }
253 
254     function started() public view returns (bool);
255 
256     function successful() public view returns (bool);
257 
258     function finished() public view returns (bool);
259 }
260 
261 
262 
263 /**
264  * @title SafeMath
265  * @dev Math operations with safety checks that throw on error
266  */
267 library SafeMath {
268 
269   /**
270   * @dev Multiplies two numbers, throws on overflow.
271   */
272   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
273     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
274     // benefit is lost if 'b' is also tested.
275     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
276     if (_a == 0) {
277       return 0;
278     }
279 
280     c = _a * _b;
281     assert(c / _a == _b);
282     return c;
283   }
284 
285   /**
286   * @dev Integer division of two numbers, truncating the quotient.
287   */
288   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
289     // assert(_b > 0); // Solidity automatically throws when dividing by 0
290     // uint256 c = _a / _b;
291     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
292     return _a / _b;
293   }
294 
295   /**
296   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
297   */
298   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
299     assert(_b <= _a);
300     return _a - _b;
301   }
302 
303   /**
304   * @dev Adds two numbers, throws on overflow.
305   */
306   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
307     c = _a + _b;
308     assert(c >= _a);
309     return c;
310   }
311 }
312 
313 
314 
315 
316 
317 /**
318  * @title ERC721 Non-Fungible Token Standard basic interface
319  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
320  */
321 contract ERC721Basic is ERC165 {
322 
323   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
324   /*
325    * 0x80ac58cd ===
326    *   bytes4(keccak256('balanceOf(address)')) ^
327    *   bytes4(keccak256('ownerOf(uint256)')) ^
328    *   bytes4(keccak256('approve(address,uint256)')) ^
329    *   bytes4(keccak256('getApproved(uint256)')) ^
330    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
331    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
332    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
333    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
334    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
335    */
336 
337   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
338   /*
339    * 0x4f558e79 ===
340    *   bytes4(keccak256('exists(uint256)'))
341    */
342 
343   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
344   /**
345    * 0x780e9d63 ===
346    *   bytes4(keccak256('totalSupply()')) ^
347    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
348    *   bytes4(keccak256('tokenByIndex(uint256)'))
349    */
350 
351   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
352   /**
353    * 0x5b5e139f ===
354    *   bytes4(keccak256('name()')) ^
355    *   bytes4(keccak256('symbol()')) ^
356    *   bytes4(keccak256('tokenURI(uint256)'))
357    */
358 
359   event Transfer(
360     address indexed _from,
361     address indexed _to,
362     uint256 indexed _tokenId
363   );
364   event Approval(
365     address indexed _owner,
366     address indexed _approved,
367     uint256 indexed _tokenId
368   );
369   event ApprovalForAll(
370     address indexed _owner,
371     address indexed _operator,
372     bool _approved
373   );
374 
375   function balanceOf(address _owner) public view returns (uint256 _balance);
376   function ownerOf(uint256 _tokenId) public view returns (address _owner);
377   function exists(uint256 _tokenId) public view returns (bool _exists);
378 
379   function approve(address _to, uint256 _tokenId) public;
380   function getApproved(uint256 _tokenId)
381     public view returns (address _operator);
382 
383   function setApprovalForAll(address _operator, bool _approved) public;
384   function isApprovedForAll(address _owner, address _operator)
385     public view returns (bool);
386 
387   function transferFrom(address _from, address _to, uint256 _tokenId) public;
388   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
389     public;
390 
391   function safeTransferFrom(
392     address _from,
393     address _to,
394     uint256 _tokenId,
395     bytes _data
396   )
397     public;
398 }
399 
400 
401 
402 
403 
404 
405 
406 
407 
408 /**
409  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
410  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
411  */
412 contract ERC721Enumerable is ERC721Basic {
413   function totalSupply() public view returns (uint256);
414   function tokenOfOwnerByIndex(
415     address _owner,
416     uint256 _index
417   )
418     public
419     view
420     returns (uint256 _tokenId);
421 
422   function tokenByIndex(uint256 _index) public view returns (uint256);
423 }
424 
425 
426 /**
427  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
428  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
429  */
430 contract ERC721Metadata is ERC721Basic {
431   function name() external view returns (string _name);
432   function symbol() external view returns (string _symbol);
433   function tokenURI(uint256 _tokenId) public view returns (string);
434 }
435 
436 
437 /**
438  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
439  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
440  */
441 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
442 }
443 
444 
445 
446 
447 
448 
449 
450 /**
451  * @title ERC721 token receiver interface
452  * @dev Interface for any contract that wants to support safeTransfers
453  * from ERC721 asset contracts.
454  */
455 contract ERC721Receiver {
456   /**
457    * @dev Magic value to be returned upon successful reception of an NFT
458    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
459    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
460    */
461   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
462 
463   /**
464    * @notice Handle the receipt of an NFT
465    * @dev The ERC721 smart contract calls this function on the recipient
466    * after a `safetransfer`. This function MAY throw to revert and reject the
467    * transfer. Return of other than the magic value MUST result in the
468    * transaction being reverted.
469    * Note: the contract address is always the message sender.
470    * @param _operator The address which called `safeTransferFrom` function
471    * @param _from The address which previously owned the token
472    * @param _tokenId The NFT identifier which is being transferred
473    * @param _data Additional data with no specified format
474    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
475    */
476   function onERC721Received(
477     address _operator,
478     address _from,
479     uint256 _tokenId,
480     bytes _data
481   )
482     public
483     returns(bytes4);
484 }
485 
486 
487 
488 
489 
490 /**
491  * Utility library of inline functions on addresses
492  */
493 library AddressUtils {
494 
495   /**
496    * Returns whether the target address is a contract
497    * @dev This function will return false if invoked during the constructor of a contract,
498    * as the code is not actually created until after the constructor finishes.
499    * @param _addr address to check
500    * @return whether the target address is a contract
501    */
502   function isContract(address _addr) internal view returns (bool) {
503     uint256 size;
504     // XXX Currently there is no better way to check if there is a contract in an address
505     // than to check the size of the code at that address.
506     // See https://ethereum.stackexchange.com/a/14016/36603
507     // for more details about how this works.
508     // TODO Check this again before the Serenity release, because all addresses will be
509     // contracts then.
510     // solium-disable-next-line security/no-inline-assembly
511     assembly { size := extcodesize(_addr) }
512     return size > 0;
513   }
514 
515 }
516 
517 
518 
519 /**
520  * @title ERC721 Non-Fungible Token Standard basic implementation
521  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
522  */
523 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
524 
525   using SafeMath for uint256;
526   using AddressUtils for address;
527 
528   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
529   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
530   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
531 
532   // Mapping from token ID to owner
533   mapping (uint256 => address) internal tokenOwner;
534 
535   // Mapping from token ID to approved address
536   mapping (uint256 => address) internal tokenApprovals;
537 
538   // Mapping from owner to number of owned token
539   mapping (address => uint256) internal ownedTokensCount;
540 
541   // Mapping from owner to operator approvals
542   mapping (address => mapping (address => bool)) internal operatorApprovals;
543 
544   constructor()
545     public
546   {
547     // register the supported interfaces to conform to ERC721 via ERC165
548     _registerInterface(InterfaceId_ERC721);
549     _registerInterface(InterfaceId_ERC721Exists);
550   }
551 
552   /**
553    * @dev Gets the balance of the specified address
554    * @param _owner address to query the balance of
555    * @return uint256 representing the amount owned by the passed address
556    */
557   function balanceOf(address _owner) public view returns (uint256) {
558     require(_owner != address(0));
559     return ownedTokensCount[_owner];
560   }
561 
562   /**
563    * @dev Gets the owner of the specified token ID
564    * @param _tokenId uint256 ID of the token to query the owner of
565    * @return owner address currently marked as the owner of the given token ID
566    */
567   function ownerOf(uint256 _tokenId) public view returns (address) {
568     address owner = tokenOwner[_tokenId];
569     require(owner != address(0));
570     return owner;
571   }
572 
573   /**
574    * @dev Returns whether the specified token exists
575    * @param _tokenId uint256 ID of the token to query the existence of
576    * @return whether the token exists
577    */
578   function exists(uint256 _tokenId) public view returns (bool) {
579     address owner = tokenOwner[_tokenId];
580     return owner != address(0);
581   }
582 
583   /**
584    * @dev Approves another address to transfer the given token ID
585    * The zero address indicates there is no approved address.
586    * There can only be one approved address per token at a given time.
587    * Can only be called by the token owner or an approved operator.
588    * @param _to address to be approved for the given token ID
589    * @param _tokenId uint256 ID of the token to be approved
590    */
591   function approve(address _to, uint256 _tokenId) public {
592     address owner = ownerOf(_tokenId);
593     require(_to != owner);
594     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
595 
596     tokenApprovals[_tokenId] = _to;
597     emit Approval(owner, _to, _tokenId);
598   }
599 
600   /**
601    * @dev Gets the approved address for a token ID, or zero if no address set
602    * @param _tokenId uint256 ID of the token to query the approval of
603    * @return address currently approved for the given token ID
604    */
605   function getApproved(uint256 _tokenId) public view returns (address) {
606     return tokenApprovals[_tokenId];
607   }
608 
609   /**
610    * @dev Sets or unsets the approval of a given operator
611    * An operator is allowed to transfer all tokens of the sender on their behalf
612    * @param _to operator address to set the approval
613    * @param _approved representing the status of the approval to be set
614    */
615   function setApprovalForAll(address _to, bool _approved) public {
616     require(_to != msg.sender);
617     operatorApprovals[msg.sender][_to] = _approved;
618     emit ApprovalForAll(msg.sender, _to, _approved);
619   }
620 
621   /**
622    * @dev Tells whether an operator is approved by a given owner
623    * @param _owner owner address which you want to query the approval of
624    * @param _operator operator address which you want to query the approval of
625    * @return bool whether the given operator is approved by the given owner
626    */
627   function isApprovedForAll(
628     address _owner,
629     address _operator
630   )
631     public
632     view
633     returns (bool)
634   {
635     return operatorApprovals[_owner][_operator];
636   }
637 
638   /**
639    * @dev Transfers the ownership of a given token ID to another address
640    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
641    * Requires the msg sender to be the owner, approved, or operator
642    * @param _from current owner of the token
643    * @param _to address to receive the ownership of the given token ID
644    * @param _tokenId uint256 ID of the token to be transferred
645   */
646   function transferFrom(
647     address _from,
648     address _to,
649     uint256 _tokenId
650   )
651     public
652   {
653     require(isApprovedOrOwner(msg.sender, _tokenId));
654     require(_from != address(0));
655     require(_to != address(0));
656 
657     clearApproval(_from, _tokenId);
658     removeTokenFrom(_from, _tokenId);
659     addTokenTo(_to, _tokenId);
660 
661     emit Transfer(_from, _to, _tokenId);
662   }
663 
664   /**
665    * @dev Safely transfers the ownership of a given token ID to another address
666    * If the target address is a contract, it must implement `onERC721Received`,
667    * which is called upon a safe transfer, and return the magic value
668    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
669    * the transfer is reverted.
670    *
671    * Requires the msg sender to be the owner, approved, or operator
672    * @param _from current owner of the token
673    * @param _to address to receive the ownership of the given token ID
674    * @param _tokenId uint256 ID of the token to be transferred
675   */
676   function safeTransferFrom(
677     address _from,
678     address _to,
679     uint256 _tokenId
680   )
681     public
682   {
683     // solium-disable-next-line arg-overflow
684     safeTransferFrom(_from, _to, _tokenId, "");
685   }
686 
687   /**
688    * @dev Safely transfers the ownership of a given token ID to another address
689    * If the target address is a contract, it must implement `onERC721Received`,
690    * which is called upon a safe transfer, and return the magic value
691    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
692    * the transfer is reverted.
693    * Requires the msg sender to be the owner, approved, or operator
694    * @param _from current owner of the token
695    * @param _to address to receive the ownership of the given token ID
696    * @param _tokenId uint256 ID of the token to be transferred
697    * @param _data bytes data to send along with a safe transfer check
698    */
699   function safeTransferFrom(
700     address _from,
701     address _to,
702     uint256 _tokenId,
703     bytes _data
704   )
705     public
706   {
707     transferFrom(_from, _to, _tokenId);
708     // solium-disable-next-line arg-overflow
709     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
710   }
711 
712   /**
713    * @dev Returns whether the given spender can transfer a given token ID
714    * @param _spender address of the spender to query
715    * @param _tokenId uint256 ID of the token to be transferred
716    * @return bool whether the msg.sender is approved for the given token ID,
717    *  is an operator of the owner, or is the owner of the token
718    */
719   function isApprovedOrOwner(
720     address _spender,
721     uint256 _tokenId
722   )
723     internal
724     view
725     returns (bool)
726   {
727     address owner = ownerOf(_tokenId);
728     // Disable solium check because of
729     // https://github.com/duaraghav8/Solium/issues/175
730     // solium-disable-next-line operator-whitespace
731     return (
732       _spender == owner ||
733       getApproved(_tokenId) == _spender ||
734       isApprovedForAll(owner, _spender)
735     );
736   }
737 
738   /**
739    * @dev Internal function to mint a new token
740    * Reverts if the given token ID already exists
741    * @param _to The address that will own the minted token
742    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
743    */
744   function _mint(address _to, uint256 _tokenId) internal {
745     require(_to != address(0));
746     addTokenTo(_to, _tokenId);
747     emit Transfer(address(0), _to, _tokenId);
748   }
749 
750   /**
751    * @dev Internal function to burn a specific token
752    * Reverts if the token does not exist
753    * @param _tokenId uint256 ID of the token being burned by the msg.sender
754    */
755   function _burn(address _owner, uint256 _tokenId) internal {
756     clearApproval(_owner, _tokenId);
757     removeTokenFrom(_owner, _tokenId);
758     emit Transfer(_owner, address(0), _tokenId);
759   }
760 
761   /**
762    * @dev Internal function to clear current approval of a given token ID
763    * Reverts if the given address is not indeed the owner of the token
764    * @param _owner owner of the token
765    * @param _tokenId uint256 ID of the token to be transferred
766    */
767   function clearApproval(address _owner, uint256 _tokenId) internal {
768     require(ownerOf(_tokenId) == _owner);
769     if (tokenApprovals[_tokenId] != address(0)) {
770       tokenApprovals[_tokenId] = address(0);
771     }
772   }
773 
774   /**
775    * @dev Internal function to add a token ID to the list of a given address
776    * @param _to address representing the new owner of the given token ID
777    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
778    */
779   function addTokenTo(address _to, uint256 _tokenId) internal {
780     require(tokenOwner[_tokenId] == address(0));
781     tokenOwner[_tokenId] = _to;
782     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
783   }
784 
785   /**
786    * @dev Internal function to remove a token ID from the list of a given address
787    * @param _from address representing the previous owner of the given token ID
788    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
789    */
790   function removeTokenFrom(address _from, uint256 _tokenId) internal {
791     require(ownerOf(_tokenId) == _from);
792     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
793     tokenOwner[_tokenId] = address(0);
794   }
795 
796   /**
797    * @dev Internal function to invoke `onERC721Received` on a target address
798    * The call is not executed if the target address is not a contract
799    * @param _from address representing the previous owner of the given token ID
800    * @param _to target address that will receive the tokens
801    * @param _tokenId uint256 ID of the token to be transferred
802    * @param _data bytes optional data to send along with the call
803    * @return whether the call correctly returned the expected magic value
804    */
805   function checkAndCallSafeTransfer(
806     address _from,
807     address _to,
808     uint256 _tokenId,
809     bytes _data
810   )
811     internal
812     returns (bool)
813   {
814     if (!_to.isContract()) {
815       return true;
816     }
817     bytes4 retval = ERC721Receiver(_to).onERC721Received(
818       msg.sender, _from, _tokenId, _data);
819     return (retval == ERC721_RECEIVED);
820   }
821 }
822 
823 
824 
825 
826 /**
827  * @title Full ERC721 Token
828  * This implementation includes all the required and some optional functionality of the ERC721 standard
829  * Moreover, it includes approve all functionality using operator terminology
830  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
831  */
832 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
833 
834   // Token name
835   string internal name_;
836 
837   // Token symbol
838   string internal symbol_;
839 
840   // Mapping from owner to list of owned token IDs
841   mapping(address => uint256[]) internal ownedTokens;
842 
843   // Mapping from token ID to index of the owner tokens list
844   mapping(uint256 => uint256) internal ownedTokensIndex;
845 
846   // Array with all token ids, used for enumeration
847   uint256[] internal allTokens;
848 
849   // Mapping from token id to position in the allTokens array
850   mapping(uint256 => uint256) internal allTokensIndex;
851 
852   // Optional mapping for token URIs
853   mapping(uint256 => string) internal tokenURIs;
854 
855   /**
856    * @dev Constructor function
857    */
858   constructor(string _name, string _symbol) public {
859     name_ = _name;
860     symbol_ = _symbol;
861 
862     // register the supported interfaces to conform to ERC721 via ERC165
863     _registerInterface(InterfaceId_ERC721Enumerable);
864     _registerInterface(InterfaceId_ERC721Metadata);
865   }
866 
867   /**
868    * @dev Gets the token name
869    * @return string representing the token name
870    */
871   function name() external view returns (string) {
872     return name_;
873   }
874 
875   /**
876    * @dev Gets the token symbol
877    * @return string representing the token symbol
878    */
879   function symbol() external view returns (string) {
880     return symbol_;
881   }
882 
883   /**
884    * @dev Returns an URI for a given token ID
885    * Throws if the token ID does not exist. May return an empty string.
886    * @param _tokenId uint256 ID of the token to query
887    */
888   function tokenURI(uint256 _tokenId) public view returns (string) {
889     require(exists(_tokenId));
890     return tokenURIs[_tokenId];
891   }
892 
893   /**
894    * @dev Gets the token ID at a given index of the tokens list of the requested owner
895    * @param _owner address owning the tokens list to be accessed
896    * @param _index uint256 representing the index to be accessed of the requested tokens list
897    * @return uint256 token ID at the given index of the tokens list owned by the requested address
898    */
899   function tokenOfOwnerByIndex(
900     address _owner,
901     uint256 _index
902   )
903     public
904     view
905     returns (uint256)
906   {
907     require(_index < balanceOf(_owner));
908     return ownedTokens[_owner][_index];
909   }
910 
911   /**
912    * @dev Gets the total amount of tokens stored by the contract
913    * @return uint256 representing the total amount of tokens
914    */
915   function totalSupply() public view returns (uint256) {
916     return allTokens.length;
917   }
918 
919   /**
920    * @dev Gets the token ID at a given index of all the tokens in this contract
921    * Reverts if the index is greater or equal to the total number of tokens
922    * @param _index uint256 representing the index to be accessed of the tokens list
923    * @return uint256 token ID at the given index of the tokens list
924    */
925   function tokenByIndex(uint256 _index) public view returns (uint256) {
926     require(_index < totalSupply());
927     return allTokens[_index];
928   }
929 
930   /**
931    * @dev Internal function to set the token URI for a given token
932    * Reverts if the token ID does not exist
933    * @param _tokenId uint256 ID of the token to set its URI
934    * @param _uri string URI to assign
935    */
936   function _setTokenURI(uint256 _tokenId, string _uri) internal {
937     require(exists(_tokenId));
938     tokenURIs[_tokenId] = _uri;
939   }
940 
941   /**
942    * @dev Internal function to add a token ID to the list of a given address
943    * @param _to address representing the new owner of the given token ID
944    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
945    */
946   function addTokenTo(address _to, uint256 _tokenId) internal {
947     super.addTokenTo(_to, _tokenId);
948     uint256 length = ownedTokens[_to].length;
949     ownedTokens[_to].push(_tokenId);
950     ownedTokensIndex[_tokenId] = length;
951   }
952 
953   /**
954    * @dev Internal function to remove a token ID from the list of a given address
955    * @param _from address representing the previous owner of the given token ID
956    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
957    */
958   function removeTokenFrom(address _from, uint256 _tokenId) internal {
959     super.removeTokenFrom(_from, _tokenId);
960 
961     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
962     // then delete the last slot.
963     uint256 tokenIndex = ownedTokensIndex[_tokenId];
964     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
965     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
966 
967     ownedTokens[_from][tokenIndex] = lastToken;
968     // This also deletes the contents at the last position of the array
969     ownedTokens[_from].length--;
970 
971     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
972     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
973     // the lastToken to the first position, and then dropping the element placed in the last position of the list
974 
975     ownedTokensIndex[_tokenId] = 0;
976     ownedTokensIndex[lastToken] = tokenIndex;
977   }
978 
979   /**
980    * @dev Internal function to mint a new token
981    * Reverts if the given token ID already exists
982    * @param _to address the beneficiary that will own the minted token
983    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
984    */
985   function _mint(address _to, uint256 _tokenId) internal {
986     super._mint(_to, _tokenId);
987 
988     allTokensIndex[_tokenId] = allTokens.length;
989     allTokens.push(_tokenId);
990   }
991 
992   /**
993    * @dev Internal function to burn a specific token
994    * Reverts if the token does not exist
995    * @param _owner owner of the token to burn
996    * @param _tokenId uint256 ID of the token being burned by the msg.sender
997    */
998   function _burn(address _owner, uint256 _tokenId) internal {
999     super._burn(_owner, _tokenId);
1000 
1001     // Clear metadata (if any)
1002     if (bytes(tokenURIs[_tokenId]).length != 0) {
1003       delete tokenURIs[_tokenId];
1004     }
1005 
1006     // Reorg all tokens array
1007     uint256 tokenIndex = allTokensIndex[_tokenId];
1008     uint256 lastTokenIndex = allTokens.length.sub(1);
1009     uint256 lastToken = allTokens[lastTokenIndex];
1010 
1011     allTokens[tokenIndex] = lastToken;
1012     allTokens[lastTokenIndex] = 0;
1013 
1014     allTokens.length--;
1015     allTokensIndex[_tokenId] = 0;
1016     allTokensIndex[lastToken] = tokenIndex;
1017   }
1018 
1019 }
1020 
1021 
1022 
1023 
1024 
1025 
1026 /**
1027  * @title ERC20 interface
1028  * @dev see https://github.com/ethereum/EIPs/issues/20
1029  */
1030 contract ERC20 is ERC20Basic {
1031   function allowance(address _owner, address _spender)
1032     public view returns (uint256);
1033 
1034   function transferFrom(address _from, address _to, uint256 _value)
1035     public returns (bool);
1036 
1037   function approve(address _spender, uint256 _value) public returns (bool);
1038   event Approval(
1039     address indexed owner,
1040     address indexed spender,
1041     uint256 value
1042   );
1043 }
1044 
1045 
1046 
1047 
1048 
1049 
1050 
1051 
1052 
1053 
1054 
1055 
1056 
1057 
1058 
1059 /**
1060  * @title Basic token
1061  * @dev Basic version of StandardToken, with no allowances.
1062  */
1063 contract BasicToken is ERC20Basic {
1064   using SafeMath for uint256;
1065 
1066   mapping(address => uint256) internal balances;
1067 
1068   uint256 internal totalSupply_;
1069 
1070   /**
1071   * @dev Total number of tokens in existence
1072   */
1073   function totalSupply() public view returns (uint256) {
1074     return totalSupply_;
1075   }
1076 
1077   /**
1078   * @dev Transfer token for a specified address
1079   * @param _to The address to transfer to.
1080   * @param _value The amount to be transferred.
1081   */
1082   function transfer(address _to, uint256 _value) public returns (bool) {
1083     require(_value <= balances[msg.sender]);
1084     require(_to != address(0));
1085 
1086     balances[msg.sender] = balances[msg.sender].sub(_value);
1087     balances[_to] = balances[_to].add(_value);
1088     emit Transfer(msg.sender, _to, _value);
1089     return true;
1090   }
1091 
1092   /**
1093   * @dev Gets the balance of the specified address.
1094   * @param _owner The address to query the the balance of.
1095   * @return An uint256 representing the amount owned by the passed address.
1096   */
1097   function balanceOf(address _owner) public view returns (uint256) {
1098     return balances[_owner];
1099   }
1100 
1101 }
1102 
1103 
1104 
1105 
1106 /**
1107  * @title Standard ERC20 token
1108  *
1109  * @dev Implementation of the basic standard token.
1110  * https://github.com/ethereum/EIPs/issues/20
1111  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
1112  */
1113 contract StandardToken is ERC20, BasicToken {
1114 
1115   mapping (address => mapping (address => uint256)) internal allowed;
1116 
1117 
1118   /**
1119    * @dev Transfer tokens from one address to another
1120    * @param _from address The address which you want to send tokens from
1121    * @param _to address The address which you want to transfer to
1122    * @param _value uint256 the amount of tokens to be transferred
1123    */
1124   function transferFrom(
1125     address _from,
1126     address _to,
1127     uint256 _value
1128   )
1129     public
1130     returns (bool)
1131   {
1132     require(_value <= balances[_from]);
1133     require(_value <= allowed[_from][msg.sender]);
1134     require(_to != address(0));
1135 
1136     balances[_from] = balances[_from].sub(_value);
1137     balances[_to] = balances[_to].add(_value);
1138     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1139     emit Transfer(_from, _to, _value);
1140     return true;
1141   }
1142 
1143   /**
1144    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1145    * Beware that changing an allowance with this method brings the risk that someone may use both the old
1146    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1147    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1148    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1149    * @param _spender The address which will spend the funds.
1150    * @param _value The amount of tokens to be spent.
1151    */
1152   function approve(address _spender, uint256 _value) public returns (bool) {
1153     allowed[msg.sender][_spender] = _value;
1154     emit Approval(msg.sender, _spender, _value);
1155     return true;
1156   }
1157 
1158   /**
1159    * @dev Function to check the amount of tokens that an owner allowed to a spender.
1160    * @param _owner address The address which owns the funds.
1161    * @param _spender address The address which will spend the funds.
1162    * @return A uint256 specifying the amount of tokens still available for the spender.
1163    */
1164   function allowance(
1165     address _owner,
1166     address _spender
1167    )
1168     public
1169     view
1170     returns (uint256)
1171   {
1172     return allowed[_owner][_spender];
1173   }
1174 
1175   /**
1176    * @dev Increase the amount of tokens that an owner allowed to a spender.
1177    * approve should be called when allowed[_spender] == 0. To increment
1178    * allowed value is better to use this function to avoid 2 calls (and wait until
1179    * the first transaction is mined)
1180    * From MonolithDAO Token.sol
1181    * @param _spender The address which will spend the funds.
1182    * @param _addedValue The amount of tokens to increase the allowance by.
1183    */
1184   function increaseApproval(
1185     address _spender,
1186     uint256 _addedValue
1187   )
1188     public
1189     returns (bool)
1190   {
1191     allowed[msg.sender][_spender] = (
1192       allowed[msg.sender][_spender].add(_addedValue));
1193     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1194     return true;
1195   }
1196 
1197   /**
1198    * @dev Decrease the amount of tokens that an owner allowed to a spender.
1199    * approve should be called when allowed[_spender] == 0. To decrement
1200    * allowed value is better to use this function to avoid 2 calls (and wait until
1201    * the first transaction is mined)
1202    * From MonolithDAO Token.sol
1203    * @param _spender The address which will spend the funds.
1204    * @param _subtractedValue The amount of tokens to decrease the allowance by.
1205    */
1206   function decreaseApproval(
1207     address _spender,
1208     uint256 _subtractedValue
1209   )
1210     public
1211     returns (bool)
1212   {
1213     uint256 oldValue = allowed[msg.sender][_spender];
1214     if (_subtractedValue >= oldValue) {
1215       allowed[msg.sender][_spender] = 0;
1216     } else {
1217       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1218     }
1219     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1220     return true;
1221   }
1222 
1223 }
1224 
1225 
1226 
1227 
1228 /**
1229  * @title Mintable token
1230  * @dev Simple ERC20 Token example, with mintable token creation
1231  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
1232  */
1233 contract MintableToken is StandardToken, Ownable {
1234   event Mint(address indexed to, uint256 amount);
1235   event MintFinished();
1236 
1237   bool public mintingFinished = false;
1238 
1239 
1240   modifier canMint() {
1241     require(!mintingFinished);
1242     _;
1243   }
1244 
1245   modifier hasMintPermission() {
1246     require(msg.sender == owner);
1247     _;
1248   }
1249 
1250   /**
1251    * @dev Function to mint tokens
1252    * @param _to The address that will receive the minted tokens.
1253    * @param _amount The amount of tokens to mint.
1254    * @return A boolean that indicates if the operation was successful.
1255    */
1256   function mint(
1257     address _to,
1258     uint256 _amount
1259   )
1260     public
1261     hasMintPermission
1262     canMint
1263     returns (bool)
1264   {
1265     totalSupply_ = totalSupply_.add(_amount);
1266     balances[_to] = balances[_to].add(_amount);
1267     emit Mint(_to, _amount);
1268     emit Transfer(address(0), _to, _amount);
1269     return true;
1270   }
1271 
1272   /**
1273    * @dev Function to stop minting new tokens.
1274    * @return True if the operation was successful.
1275    */
1276   function finishMinting() public onlyOwner canMint returns (bool) {
1277     mintingFinished = true;
1278     emit MintFinished();
1279     return true;
1280   }
1281 }
1282 
1283 
1284 
1285 
1286 
1287 
1288 /**
1289  * @title DetailedERC20 token
1290  * @dev The decimals are only for visualization purposes.
1291  * All the operations are done using the smallest and indivisible token unit,
1292  * just as on Ethereum all the operations are done in wei.
1293  */
1294 contract DetailedERC20 is ERC20 {
1295   string public name;
1296   string public symbol;
1297   uint8 public decimals;
1298 
1299   constructor(string _name, string _symbol, uint8 _decimals) public {
1300     name = _name;
1301     symbol = _symbol;
1302     decimals = _decimals;
1303   }
1304 }
1305 
1306 
1307 contract Boost is MintableToken, DetailedERC20("Boost", "BST", 18) {
1308 }
1309 
1310 
1311 
1312 
1313 
1314 
1315 
1316 
1317 
1318 
1319 
1320 
1321 
1322 
1323 /**
1324  * @title Template
1325  * @notice Template instantiates `Contract`s of the same form.
1326  */
1327 contract Template is Ownable, SupportsInterfaceWithLookup {
1328     /**
1329      * @notice this.owner.selector ^ this.renounceOwnership.selector ^ this.transferOwnership.selector
1330         ^ this.bytecodeHash.selector ^ this.price.selector ^ this.beneficiary.selector
1331         ^ this.name.selector ^ this.description.selector ^ this.setNameAndDescription.selector
1332         ^ this.instantiate.selector
1333      */
1334     bytes4 public constant InterfaceId_Template = 0xd48445ff;
1335 
1336     mapping(string => string) nameOfLocale;
1337     mapping(string => string) descriptionOfLocale;
1338     /**
1339      * @notice Hash of EVM bytecode to be instantiated.
1340      */
1341     bytes32 public bytecodeHash;
1342     /**
1343      * @notice Price to pay when instantiating
1344      */
1345     uint public price;
1346     /**
1347      * @notice Address to receive payment
1348      */
1349     address public beneficiary;
1350 
1351     /**
1352      * @notice Logged when a new `Contract` instantiated.
1353      */
1354     event Instantiated(address indexed creator, address indexed contractAddress);
1355 
1356     /**
1357      * @param _bytecodeHash Hash of EVM bytecode
1358      * @param _price Price of instantiating in wei
1359      * @param _beneficiary Address to transfer _price when instantiating
1360      */
1361     constructor(
1362         bytes32 _bytecodeHash,
1363         uint _price,
1364         address _beneficiary
1365     ) public {
1366         bytecodeHash = _bytecodeHash;
1367         price = _price;
1368         beneficiary = _beneficiary;
1369         if (price > 0) {
1370             require(beneficiary != address(0));
1371         }
1372 
1373         _registerInterface(InterfaceId_Template);
1374     }
1375 
1376     /**
1377      * @param _locale IETF language tag(https://en.wikipedia.org/wiki/IETF_language_tag)
1378      * @return Name in `_locale`.
1379      */
1380     function name(string _locale) public view returns (string) {
1381         return nameOfLocale[_locale];
1382     }
1383 
1384     /**
1385      * @param _locale IETF language tag(https://en.wikipedia.org/wiki/IETF_language_tag)
1386      * @return Description in `_locale`.
1387      */
1388     function description(string _locale) public view returns (string) {
1389         return descriptionOfLocale[_locale];
1390     }
1391 
1392     /**
1393      * @param _locale IETF language tag(https://en.wikipedia.org/wiki/IETF_language_tag)
1394      * @param _name Name to set
1395      * @param _description Description to set
1396      */
1397     function setNameAndDescription(string _locale, string _name, string _description) public onlyOwner {
1398         nameOfLocale[_locale] = _name;
1399         descriptionOfLocale[_locale] = _description;
1400     }
1401 
1402     /**
1403      * @notice `msg.sender` is passed as first argument for the newly created `Contract`.
1404      * @param _bytecode Bytecode corresponding to `bytecodeHash`
1405      * @param _args If arguments where passed to this function, those will be appended to the arguments for `Contract`.
1406      * @return Newly created contract account's address
1407      */
1408     function instantiate(bytes _bytecode, bytes _args) public payable returns (address contractAddress) {
1409         require(bytecodeHash == keccak256(_bytecode));
1410         bytes memory calldata = abi.encodePacked(_bytecode, _args);
1411         assembly {
1412             contractAddress := create(0, add(calldata, 0x20), mload(calldata))
1413         }
1414         if (contractAddress == address(0)) {
1415             revert("Cannot instantiate contract");
1416         } else {
1417             Contract c = Contract(contractAddress);
1418             // InterfaceId_ERC165
1419             require(c.supportsInterface(0x01ffc9a7));
1420             // InterfaceId_Contract
1421             require(c.supportsInterface(0x6125ede5));
1422 
1423             if (price > 0) {
1424                 require(msg.value == price);
1425                 beneficiary.transfer(msg.value);
1426             }
1427             emit Instantiated(msg.sender, contractAddress);
1428         }
1429     }
1430 }
1431 
1432 
1433 
1434 
1435 
1436 
1437 
1438 
1439 
1440 contract StrategyTemplate is Template {
1441     constructor(
1442         bytes32 _bytecodeHash,
1443         uint _price,
1444         address _beneficiary
1445     ) public
1446     Template(
1447         _bytecodeHash,
1448         _price,
1449         _beneficiary
1450     ) {
1451     }
1452 
1453     function instantiate(bytes _bytecode, bytes _args) public payable returns (address contractAddress) {
1454         Strategy strategy = Strategy(super.instantiate(_bytecode, _args));
1455         // InterfaceId_Strategy
1456         require(strategy.supportsInterface(0x6e301925));
1457         return strategy;
1458     }
1459 }
1460 
1461 
1462 
1463 contract SaleStrategyTemplate is StrategyTemplate {
1464     constructor(
1465         bytes32 _bytecodeHash,
1466         uint _price,
1467         address _beneficiary
1468     ) public
1469     StrategyTemplate(
1470         _bytecodeHash,
1471         _price,
1472         _beneficiary
1473     ) {
1474     }
1475 
1476     function instantiate(bytes _bytecode, bytes _args) public payable returns (address contractAddress) {
1477         SaleStrategy strategy = SaleStrategy(super.instantiate(_bytecode, _args));
1478         // InterfaceId_SaleStrategy
1479         require(strategy.supportsInterface(0x04c8123d));
1480         return strategy;
1481     }
1482 }
1483 
1484 
1485 
1486 contract Sale is Contract, Activatable {
1487     using SafeMath for uint;
1488 
1489     /**
1490      * @notice this.owner.selector ^ this.renounceOwnership.selector ^ this.transferOwnership.selector
1491         ^ this.template.selector ^ this.activate.selector
1492         ^ this.projectName.selector ^ this.projectSummary.selector ^ this.projectDescription.selector
1493         ^ this.logoUrl.selector ^ this.coverImageUrl.selector ^ this.websiteUrl.selector ^ this.whitepaperUrl.selector
1494         ^ this.name.selector ^ this.weiRaised.selector ^ this.withdrawn.selector ^ this.ready.selector
1495         ^ this.started.selector ^ this.successful.selector ^ this.finished.selector ^ this.paymentOf.selector
1496         ^ this.update.selector ^ this.addStrategy.selector ^ this.numberOfStrategies.selector ^ this.strategyAt.selector
1497         ^ this.numberOfActivatedStrategies.selector ^ this.activatedStrategyAt.selector
1498         ^ this.withdraw.selector ^ this.claimRefund.selector
1499      */
1500     bytes4 public constant InterfaceId_Sale = 0x8139792d;
1501 
1502     string public projectName;
1503     string public projectSummary;
1504     string public projectDescription;
1505     string public logoUrl;
1506     string public coverImageUrl;
1507     string public websiteUrl;
1508     string public whitepaperUrl;
1509     string public name;
1510 
1511     uint256 public weiRaised;
1512     bool public withdrawn;
1513 
1514     SaleStrategy[] strategies;
1515     SaleStrategy[] activatedStrategies;
1516     mapping(address => uint256) paymentOfPurchaser;
1517 
1518     constructor(
1519         address _owner,
1520         string _projectName,
1521         string _name
1522     ) public Contract(_owner) {
1523         projectName = _projectName;
1524         name = _name;
1525 
1526         _registerInterface(InterfaceId_Sale);
1527     }
1528 
1529     function update(
1530         string _projectName,
1531         string _projectSummary,
1532         string _projectDescription,
1533         string _logoUrl,
1534         string _coverImageUrl,
1535         string _websiteUrl,
1536         string _whitepaperUrl,
1537         string _name
1538     ) public onlyOwner whenNotActivated {
1539         projectName = _projectName;
1540         projectSummary = _projectSummary;
1541         projectDescription = _projectDescription;
1542         logoUrl = _logoUrl;
1543         coverImageUrl = _coverImageUrl;
1544         websiteUrl = _websiteUrl;
1545         whitepaperUrl = _whitepaperUrl;
1546         name = _name;
1547     }
1548 
1549     function addStrategy(SaleStrategyTemplate _template, bytes _bytecode) onlyOwner whenNotActivated public payable {
1550         // InterfaceId_ERC165
1551         require(_template.supportsInterface(0x01ffc9a7));
1552         // InterfaceId_Template
1553         require(_template.supportsInterface(0xd48445ff));
1554 
1555         require(_isUniqueStrategy(_template));
1556 
1557         bytes memory args = abi.encode(msg.sender, address(this));
1558         SaleStrategy strategy = SaleStrategy(_template.instantiate.value(msg.value)(_bytecode, args));
1559         strategies.push(strategy);
1560     }
1561 
1562     function _isUniqueStrategy(SaleStrategyTemplate _template) private view returns (bool) {
1563         for (uint i = 0; i < strategies.length; i++) {
1564             SaleStrategy strategy = strategies[i];
1565             if (address(strategy.template()) == address(_template)) {
1566                 return false;
1567             }
1568         }
1569         return true;
1570     }
1571 
1572     function numberOfStrategies() public view returns (uint256) {
1573         return strategies.length;
1574     }
1575 
1576     function strategyAt(uint256 index) public view returns (address) {
1577         return strategies[index];
1578     }
1579 
1580     function numberOfActivatedStrategies() public view returns (uint256) {
1581         return activatedStrategies.length;
1582     }
1583 
1584     function activatedStrategyAt(uint256 index) public view returns (address) {
1585         return activatedStrategies[index];
1586     }
1587 
1588     function activate() onlyOwner public returns (bool) {
1589         for (uint i = 0; i < strategies.length; i++) {
1590             SaleStrategy strategy = strategies[i];
1591             if (strategy.activated()) {
1592                 activatedStrategies.push(strategy);
1593             }
1594         }
1595         return super.activate();
1596     }
1597 
1598     function started() public view returns (bool) {
1599         if (!activated) return false;
1600 
1601         bool s = false;
1602         for (uint i = 0; i < activatedStrategies.length; i++) {
1603             s = s || activatedStrategies[i].started();
1604         }
1605         return s;
1606     }
1607 
1608     function successful() public view returns (bool){
1609         if (!started()) return false;
1610 
1611         bool s = false;
1612         for (uint i = 0; i < activatedStrategies.length; i++) {
1613             s = s || activatedStrategies[i].successful();
1614         }
1615         return s;
1616     }
1617 
1618     function finished() public view returns (bool){
1619         if (!started()) return false;
1620 
1621         bool f = false;
1622         for (uint i = 0; i < activatedStrategies.length; i++) {
1623             f = f || activatedStrategies[i].finished();
1624         }
1625         return f;
1626     }
1627 
1628     function() external payable;
1629 
1630     function increasePaymentOf(address _purchaser, uint256 _weiAmount) internal {
1631         require(!finished());
1632         require(started());
1633 
1634         paymentOfPurchaser[_purchaser] = paymentOfPurchaser[_purchaser].add(_weiAmount);
1635         weiRaised = weiRaised.add(_weiAmount);
1636     }
1637 
1638     function paymentOf(address _purchaser) public view returns (uint256 weiAmount) {
1639         return paymentOfPurchaser[_purchaser];
1640     }
1641 
1642     function withdraw() onlyOwner whenActivated public returns (bool) {
1643         require(!withdrawn);
1644         require(finished());
1645         require(successful());
1646 
1647         withdrawn = true;
1648         msg.sender.transfer(weiRaised);
1649 
1650         return true;
1651     }
1652 
1653     function claimRefund() whenActivated public returns (bool) {
1654         require(finished());
1655         require(!successful());
1656 
1657         uint256 amount = paymentOfPurchaser[msg.sender];
1658         require(amount > 0);
1659 
1660         paymentOfPurchaser[msg.sender] = 0;
1661         msg.sender.transfer(amount);
1662 
1663         return true;
1664     }
1665 }
1666 
1667 
1668 
1669 
1670 
1671 contract SaleTemplate is Template {
1672     constructor(
1673         bytes32 _bytecodeHash,
1674         uint _price,
1675         address _beneficiary
1676     ) public
1677     Template(
1678         _bytecodeHash,
1679         _price,
1680         _beneficiary
1681     ) {
1682     }
1683 
1684     function instantiate(bytes _bytecode, bytes _args) public payable returns (address contractAddress) {
1685         Sale sale = Sale(super.instantiate(_bytecode, _args));
1686         // InterfaceId_Sale
1687         require(sale.supportsInterface(0x8139792d));
1688         return sale;
1689     }
1690 }
1691 
1692 
1693 contract Raiser is ERC721Token("Raiser", "RAI"), Ownable {
1694     using SafeMath for uint256;
1695 
1696     event Mint(address indexed to, uint256 tokenId);
1697 
1698     uint256 public constant HALVING_WEI = 21000000 * (10 ** 18);
1699     uint256 public constant MAX_HALVING_ERA = 20;
1700 
1701     Boost public boost;
1702     uint256 public rewardEra = 0;
1703 
1704     uint256 weiUntilNextHalving = HALVING_WEI;
1705     mapping(uint256 => Sale) saleOfTokenId;
1706     mapping(uint256 => string) slugOfTokenId;
1707     mapping(uint256 => mapping(address => uint256)) rewardedBoostsOfSomeoneOfTokenId;
1708 
1709     constructor(Boost _boost) public {
1710         boost = _boost;
1711     }
1712 
1713     function mint(string _slug, SaleTemplate _template, bytes _bytecode, bytes _args) public payable {
1714         // InterfaceId_ERC165
1715         require(_template.supportsInterface(0x01ffc9a7));
1716         // InterfaceId_Template
1717         require(_template.supportsInterface(0xd48445ff));
1718 
1719         uint256 tokenId = toTokenId(_slug);
1720         require(address(saleOfTokenId[tokenId]) == address(0));
1721 
1722         Sale sale = Sale(_template.instantiate.value(msg.value)(_bytecode, _args));
1723         saleOfTokenId[tokenId] = sale;
1724         slugOfTokenId[tokenId] = _slug;
1725 
1726         _mint(msg.sender, tokenId);
1727         emit Mint(msg.sender, tokenId);
1728     }
1729 
1730     function toTokenId(string _slug) public pure returns (uint256 tokenId) {
1731         bytes memory chars = bytes(_slug);
1732         require(chars.length > 0, "String is empty.");
1733         for (uint i = 0; i < _min(chars.length, 32); i++) {
1734             uint c = uint(chars[i]);
1735             require(0x61 <= c && c <= 0x7a || c == 0x2d, "String must contain only lowercase alphabets or hyphens.");
1736         }
1737         assembly {
1738             tokenId := mload(add(chars, 32))
1739         }
1740     }
1741 
1742     function slugOf(uint256 _tokenId) public view returns (string slug) {
1743         return slugOfTokenId[_tokenId];
1744     }
1745 
1746     function saleOf(uint256 _tokenId) public view returns (Sale sale) {
1747         return saleOfTokenId[_tokenId];
1748     }
1749 
1750     function claimableBoostsOf(uint256 _tokenId) public view returns (uint256 boosts, uint256 newRewardEra, uint256 newWeiUntilNextHalving) {
1751         if (rewardedBoostsOfSomeoneOfTokenId[_tokenId][msg.sender] > 0) {
1752             return (0, rewardEra, weiUntilNextHalving);
1753         }
1754 
1755         Sale sale = saleOfTokenId[_tokenId];
1756         require(address(sale) != address(0));
1757         require(sale.finished());
1758 
1759         uint256 weiAmount = sale.paymentOf(msg.sender);
1760         if (sale.owner() == msg.sender) {
1761             weiAmount = weiAmount.add(sale.weiRaised());
1762         }
1763         return _weiToBoosts(weiAmount);
1764     }
1765 
1766     function claimBoostsOf(uint256 _tokenId) public returns (bool) {
1767         (uint256 boosts, uint256 newRewardEra, uint256 newWeiUntilNextHalving) = claimableBoostsOf(_tokenId);
1768         rewardEra = newRewardEra;
1769         weiUntilNextHalving = newWeiUntilNextHalving;
1770         if (boosts > 0) {
1771             boost.mint(msg.sender, boosts);
1772         }
1773         rewardedBoostsOfSomeoneOfTokenId[_tokenId][msg.sender] = boosts;
1774         return true;
1775     }
1776 
1777     function rewardedBoostsOf(uint256 _tokenId) public view returns (uint256 boosts) {
1778         return rewardedBoostsOfSomeoneOfTokenId[_tokenId][msg.sender];
1779     }
1780 
1781     function claimableBoosts() public view returns (uint256 boosts, uint256 newRewardEra, uint256 newWeiUntilNextHalving) {
1782         for (uint i = 0; i < totalSupply(); i++) {
1783             uint256 tokenId = tokenByIndex(i);
1784             (uint256 b, uint256 r, uint256 w) = claimableBoostsOf(tokenId);
1785             boosts = boosts.add(b);
1786             newRewardEra = r;
1787             newWeiUntilNextHalving = w;
1788         }
1789     }
1790 
1791     function claimBoosts() public returns (bool) {
1792         for (uint i = 0; i < totalSupply(); i++) {
1793             uint256 tokenId = tokenByIndex(i);
1794             claimBoostsOf(tokenId);
1795         }
1796         return true;
1797     }
1798 
1799     function rewardedBoosts() public view returns (uint256 boosts) {
1800         for (uint i = 0; i < totalSupply(); i++) {
1801             uint256 tokenId = tokenByIndex(i);
1802             boosts = boosts.add(rewardedBoostsOf(tokenId));
1803         }
1804     }
1805 
1806     function boostsUntilNextHalving() public view returns (uint256) {
1807         (uint256 boosts,,) = _weiToBoosts(weiUntilNextHalving);
1808         return boosts;
1809     }
1810 
1811     function _weiToBoosts(uint256 _weiAmount) private view returns (uint256 boosts, uint256 newRewardEra, uint256 newWeiUntilNextHalving) {
1812         if (rewardEra > MAX_HALVING_ERA) {
1813             return (0, rewardEra, weiUntilNextHalving);
1814         }
1815         uint256 amount = _weiAmount;
1816         boosts = 0;
1817         newRewardEra = rewardEra;
1818         newWeiUntilNextHalving = weiUntilNextHalving;
1819         while (amount > 0) {
1820             uint256 a = _min(amount, weiUntilNextHalving);
1821             boosts = boosts.add(a.mul(2 ** (MAX_HALVING_ERA.sub(newRewardEra)).div(1000)));
1822             amount = amount.sub(a);
1823             newWeiUntilNextHalving = newWeiUntilNextHalving.sub(a);
1824             if (newWeiUntilNextHalving == 0) {
1825                 newWeiUntilNextHalving = HALVING_WEI;
1826                 newRewardEra += 1;
1827             }
1828         }
1829     }
1830 
1831     function _min(uint256 _a, uint256 _b) private pure returns (uint256) {
1832         return _a < _b ? _a : _b;
1833     }
1834 }