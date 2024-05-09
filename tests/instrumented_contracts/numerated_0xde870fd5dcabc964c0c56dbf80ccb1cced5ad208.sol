1 pragma solidity 0.4.25;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  /home/phillip/Projects/cryptocare/contracts/contracts/CryptoCareMinter.sol
6 // flattened :  Saturday, 20-Oct-18 22:15:01 UTC
7 contract ERC721Receiver {
8   /**
9    * @dev Magic value to be returned upon successful reception of an NFT
10    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
11    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
12    */
13   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
14 
15   /**
16    * @notice Handle the receipt of an NFT
17    * @dev The ERC721 smart contract calls this function on the recipient
18    * after a `safetransfer`. This function MAY throw to revert and reject the
19    * transfer. Return of other than the magic value MUST result in the 
20    * transaction being reverted.
21    * Note: the contract address is always the message sender.
22    * @param _operator The address which called `safeTransferFrom` function
23    * @param _from The address which previously owned the token
24    * @param _tokenId The NFT identifier which is being transfered
25    * @param _data Additional data with no specified format
26    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
27    */
28   function onERC721Received(
29     address _operator,
30     address _from,
31     uint256 _tokenId,
32     bytes _data
33   )
34     public
35     returns(bytes4);
36 }
37 
38 library AddressUtils {
39 
40   /**
41    * Returns whether the target address is a contract
42    * @dev This function will return false if invoked during the constructor of a contract,
43    * as the code is not actually created until after the constructor finishes.
44    * @param addr address to check
45    * @return whether the target address is a contract
46    */
47   function isContract(address addr) internal view returns (bool) {
48     uint256 size;
49     // XXX Currently there is no better way to check if there is a contract in an address
50     // than to check the size of the code at that address.
51     // See https://ethereum.stackexchange.com/a/14016/36603
52     // for more details about how this works.
53     // TODO Check this again before the Serenity release, because all addresses will be
54     // contracts then.
55     // solium-disable-next-line security/no-inline-assembly
56     assembly { size := extcodesize(addr) }
57     return size > 0;
58   }
59 
60 }
61 
62 library SafeMath {
63 
64   /**
65   * @dev Multiplies two numbers, throws on overflow.
66   */
67   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
68     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
69     // benefit is lost if 'b' is also tested.
70     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
71     if (a == 0) {
72       return 0;
73     }
74 
75     c = a * b;
76     assert(c / a == b);
77     return c;
78   }
79 
80   /**
81   * @dev Integer division of two numbers, truncating the quotient.
82   */
83   function div(uint256 a, uint256 b) internal pure returns (uint256) {
84     // assert(b > 0); // Solidity automatically throws when dividing by 0
85     // uint256 c = a / b;
86     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
87     return a / b;
88   }
89 
90   /**
91   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
92   */
93   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
94     assert(b <= a);
95     return a - b;
96   }
97 
98   /**
99   * @dev Adds two numbers, throws on overflow.
100   */
101   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
102     c = a + b;
103     assert(c >= a);
104     return c;
105   }
106 }
107 
108 contract Ownable {
109   address public owner;
110 
111 
112   event OwnershipRenounced(address indexed previousOwner);
113   event OwnershipTransferred(
114     address indexed previousOwner,
115     address indexed newOwner
116   );
117 
118 
119   /**
120    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
121    * account.
122    */
123   constructor() public {
124     owner = msg.sender;
125   }
126 
127   /**
128    * @dev Throws if called by any account other than the owner.
129    */
130   modifier onlyOwner() {
131     require(msg.sender == owner);
132     _;
133   }
134 
135   /**
136    * @dev Allows the current owner to relinquish control of the contract.
137    * @notice Renouncing to ownership will leave the contract without an owner.
138    * It will not be possible to call the functions with the `onlyOwner`
139    * modifier anymore.
140    */
141   function renounceOwnership() public onlyOwner {
142     emit OwnershipRenounced(owner);
143     owner = address(0);
144   }
145 
146   /**
147    * @dev Allows the current owner to transfer control of the contract to a newOwner.
148    * @param _newOwner The address to transfer ownership to.
149    */
150   function transferOwnership(address _newOwner) public onlyOwner {
151     _transferOwnership(_newOwner);
152   }
153 
154   /**
155    * @dev Transfers control of the contract to a newOwner.
156    * @param _newOwner The address to transfer ownership to.
157    */
158   function _transferOwnership(address _newOwner) internal {
159     require(_newOwner != address(0));
160     emit OwnershipTransferred(owner, _newOwner);
161     owner = _newOwner;
162   }
163 }
164 
165 interface ERC165 {
166 
167   /**
168    * @notice Query if a contract implements an interface
169    * @param _interfaceId The interface identifier, as specified in ERC-165
170    * @dev Interface identification is specified in ERC-165. This function
171    * uses less than 30,000 gas.
172    */
173   function supportsInterface(bytes4 _interfaceId)
174     external
175     view
176     returns (bool);
177 }
178 
179 contract Pausable is Ownable {
180   event Pause();
181   event Unpause();
182 
183   bool public paused = false;
184 
185 
186   /**
187    * @dev Modifier to make a function callable only when the contract is not paused.
188    */
189   modifier whenNotPaused() {
190     require(!paused);
191     _;
192   }
193 
194   /**
195    * @dev Modifier to make a function callable only when the contract is paused.
196    */
197   modifier whenPaused() {
198     require(paused);
199     _;
200   }
201 
202   /**
203    * @dev called by the owner to pause, triggers stopped state
204    */
205   function pause() onlyOwner whenNotPaused public {
206     paused = true;
207     emit Pause();
208   }
209 
210   /**
211    * @dev called by the owner to unpause, returns to normal state
212    */
213   function unpause() onlyOwner whenPaused public {
214     paused = false;
215     emit Unpause();
216   }
217 }
218 
219 contract ERC721Basic is ERC165 {
220   event Transfer(
221     address indexed _from,
222     address indexed _to,
223     uint256 indexed _tokenId
224   );
225   event Approval(
226     address indexed _owner,
227     address indexed _approved,
228     uint256 indexed _tokenId
229   );
230   event ApprovalForAll(
231     address indexed _owner,
232     address indexed _operator,
233     bool _approved
234   );
235 
236   function balanceOf(address _owner) public view returns (uint256 _balance);
237   function ownerOf(uint256 _tokenId) public view returns (address _owner);
238   function exists(uint256 _tokenId) public view returns (bool _exists);
239 
240   function approve(address _to, uint256 _tokenId) public;
241   function getApproved(uint256 _tokenId)
242     public view returns (address _operator);
243 
244   function setApprovalForAll(address _operator, bool _approved) public;
245   function isApprovedForAll(address _owner, address _operator)
246     public view returns (bool);
247 
248   function transferFrom(address _from, address _to, uint256 _tokenId) public;
249   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
250     public;
251 
252   function safeTransferFrom(
253     address _from,
254     address _to,
255     uint256 _tokenId,
256     bytes _data
257   )
258     public;
259 }
260 
261 contract SupportsInterfaceWithLookup is ERC165 {
262   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
263   /**
264    * 0x01ffc9a7 ===
265    *   bytes4(keccak256('supportsInterface(bytes4)'))
266    */
267 
268   /**
269    * @dev a mapping of interface id to whether or not it's supported
270    */
271   mapping(bytes4 => bool) internal supportedInterfaces;
272 
273   /**
274    * @dev A contract implementing SupportsInterfaceWithLookup
275    * implement ERC165 itself
276    */
277   constructor()
278     public
279   {
280     _registerInterface(InterfaceId_ERC165);
281   }
282 
283   /**
284    * @dev implement supportsInterface(bytes4) using a lookup table
285    */
286   function supportsInterface(bytes4 _interfaceId)
287     external
288     view
289     returns (bool)
290   {
291     return supportedInterfaces[_interfaceId];
292   }
293 
294   /**
295    * @dev private method for registering an interface
296    */
297   function _registerInterface(bytes4 _interfaceId)
298     internal
299   {
300     require(_interfaceId != 0xffffffff);
301     supportedInterfaces[_interfaceId] = true;
302   }
303 }
304 
305 contract ERC721Enumerable is ERC721Basic {
306   function totalSupply() public view returns (uint256);
307   function tokenOfOwnerByIndex(
308     address _owner,
309     uint256 _index
310   )
311     public
312     view
313     returns (uint256 _tokenId);
314 
315   function tokenByIndex(uint256 _index) public view returns (uint256);
316 }
317 
318 
319 /**
320  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
321  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
322  */
323 contract ERC721Metadata is ERC721Basic {
324   function name() external view returns (string _name);
325   function symbol() external view returns (string _symbol);
326   function tokenURI(uint256 _tokenId) public view returns (string);
327 }
328 
329 
330 /**
331  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
332  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
333  */
334 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
335 }
336 
337 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
338 
339   bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
340   /*
341    * 0x80ac58cd ===
342    *   bytes4(keccak256('balanceOf(address)')) ^
343    *   bytes4(keccak256('ownerOf(uint256)')) ^
344    *   bytes4(keccak256('approve(address,uint256)')) ^
345    *   bytes4(keccak256('getApproved(uint256)')) ^
346    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
347    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
348    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
349    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
350    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
351    */
352 
353   bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
354   /*
355    * 0x4f558e79 ===
356    *   bytes4(keccak256('exists(uint256)'))
357    */
358 
359   using SafeMath for uint256;
360   using AddressUtils for address;
361 
362   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
363   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
364   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
365 
366   // Mapping from token ID to owner
367   mapping (uint256 => address) internal tokenOwner;
368 
369   // Mapping from token ID to approved address
370   mapping (uint256 => address) internal tokenApprovals;
371 
372   // Mapping from owner to number of owned token
373   mapping (address => uint256) internal ownedTokensCount;
374 
375   // Mapping from owner to operator approvals
376   mapping (address => mapping (address => bool)) internal operatorApprovals;
377 
378   /**
379    * @dev Guarantees msg.sender is owner of the given token
380    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
381    */
382   modifier onlyOwnerOf(uint256 _tokenId) {
383     require(ownerOf(_tokenId) == msg.sender);
384     _;
385   }
386 
387   /**
388    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
389    * @param _tokenId uint256 ID of the token to validate
390    */
391   modifier canTransfer(uint256 _tokenId) {
392     require(isApprovedOrOwner(msg.sender, _tokenId));
393     _;
394   }
395 
396   constructor()
397     public
398   {
399     // register the supported interfaces to conform to ERC721 via ERC165
400     _registerInterface(InterfaceId_ERC721);
401     _registerInterface(InterfaceId_ERC721Exists);
402   }
403 
404   /**
405    * @dev Gets the balance of the specified address
406    * @param _owner address to query the balance of
407    * @return uint256 representing the amount owned by the passed address
408    */
409   function balanceOf(address _owner) public view returns (uint256) {
410     require(_owner != address(0));
411     return ownedTokensCount[_owner];
412   }
413 
414   /**
415    * @dev Gets the owner of the specified token ID
416    * @param _tokenId uint256 ID of the token to query the owner of
417    * @return owner address currently marked as the owner of the given token ID
418    */
419   function ownerOf(uint256 _tokenId) public view returns (address) {
420     address owner = tokenOwner[_tokenId];
421     require(owner != address(0));
422     return owner;
423   }
424 
425   /**
426    * @dev Returns whether the specified token exists
427    * @param _tokenId uint256 ID of the token to query the existence of
428    * @return whether the token exists
429    */
430   function exists(uint256 _tokenId) public view returns (bool) {
431     address owner = tokenOwner[_tokenId];
432     return owner != address(0);
433   }
434 
435   /**
436    * @dev Approves another address to transfer the given token ID
437    * The zero address indicates there is no approved address.
438    * There can only be one approved address per token at a given time.
439    * Can only be called by the token owner or an approved operator.
440    * @param _to address to be approved for the given token ID
441    * @param _tokenId uint256 ID of the token to be approved
442    */
443   function approve(address _to, uint256 _tokenId) public {
444     address owner = ownerOf(_tokenId);
445     require(_to != owner);
446     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
447 
448     tokenApprovals[_tokenId] = _to;
449     emit Approval(owner, _to, _tokenId);
450   }
451 
452   /**
453    * @dev Gets the approved address for a token ID, or zero if no address set
454    * @param _tokenId uint256 ID of the token to query the approval of
455    * @return address currently approved for the given token ID
456    */
457   function getApproved(uint256 _tokenId) public view returns (address) {
458     return tokenApprovals[_tokenId];
459   }
460 
461   /**
462    * @dev Sets or unsets the approval of a given operator
463    * An operator is allowed to transfer all tokens of the sender on their behalf
464    * @param _to operator address to set the approval
465    * @param _approved representing the status of the approval to be set
466    */
467   function setApprovalForAll(address _to, bool _approved) public {
468     require(_to != msg.sender);
469     operatorApprovals[msg.sender][_to] = _approved;
470     emit ApprovalForAll(msg.sender, _to, _approved);
471   }
472 
473   /**
474    * @dev Tells whether an operator is approved by a given owner
475    * @param _owner owner address which you want to query the approval of
476    * @param _operator operator address which you want to query the approval of
477    * @return bool whether the given operator is approved by the given owner
478    */
479   function isApprovedForAll(
480     address _owner,
481     address _operator
482   )
483     public
484     view
485     returns (bool)
486   {
487     return operatorApprovals[_owner][_operator];
488   }
489 
490   /**
491    * @dev Transfers the ownership of a given token ID to another address
492    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
493    * Requires the msg sender to be the owner, approved, or operator
494    * @param _from current owner of the token
495    * @param _to address to receive the ownership of the given token ID
496    * @param _tokenId uint256 ID of the token to be transferred
497   */
498   function transferFrom(
499     address _from,
500     address _to,
501     uint256 _tokenId
502   )
503     public
504     canTransfer(_tokenId)
505   {
506     require(_from != address(0));
507     require(_to != address(0));
508 
509     clearApproval(_from, _tokenId);
510     removeTokenFrom(_from, _tokenId);
511     addTokenTo(_to, _tokenId);
512 
513     emit Transfer(_from, _to, _tokenId);
514   }
515 
516   /**
517    * @dev Safely transfers the ownership of a given token ID to another address
518    * If the target address is a contract, it must implement `onERC721Received`,
519    * which is called upon a safe transfer, and return the magic value
520    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
521    * the transfer is reverted.
522    *
523    * Requires the msg sender to be the owner, approved, or operator
524    * @param _from current owner of the token
525    * @param _to address to receive the ownership of the given token ID
526    * @param _tokenId uint256 ID of the token to be transferred
527   */
528   function safeTransferFrom(
529     address _from,
530     address _to,
531     uint256 _tokenId
532   )
533     public
534     canTransfer(_tokenId)
535   {
536     // solium-disable-next-line arg-overflow
537     safeTransferFrom(_from, _to, _tokenId, "");
538   }
539 
540   /**
541    * @dev Safely transfers the ownership of a given token ID to another address
542    * If the target address is a contract, it must implement `onERC721Received`,
543    * which is called upon a safe transfer, and return the magic value
544    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
545    * the transfer is reverted.
546    * Requires the msg sender to be the owner, approved, or operator
547    * @param _from current owner of the token
548    * @param _to address to receive the ownership of the given token ID
549    * @param _tokenId uint256 ID of the token to be transferred
550    * @param _data bytes data to send along with a safe transfer check
551    */
552   function safeTransferFrom(
553     address _from,
554     address _to,
555     uint256 _tokenId,
556     bytes _data
557   )
558     public
559     canTransfer(_tokenId)
560   {
561     transferFrom(_from, _to, _tokenId);
562     // solium-disable-next-line arg-overflow
563     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
564   }
565 
566   /**
567    * @dev Returns whether the given spender can transfer a given token ID
568    * @param _spender address of the spender to query
569    * @param _tokenId uint256 ID of the token to be transferred
570    * @return bool whether the msg.sender is approved for the given token ID,
571    *  is an operator of the owner, or is the owner of the token
572    */
573   function isApprovedOrOwner(
574     address _spender,
575     uint256 _tokenId
576   )
577     internal
578     view
579     returns (bool)
580   {
581     address owner = ownerOf(_tokenId);
582     // Disable solium check because of
583     // https://github.com/duaraghav8/Solium/issues/175
584     // solium-disable-next-line operator-whitespace
585     return (
586       _spender == owner ||
587       getApproved(_tokenId) == _spender ||
588       isApprovedForAll(owner, _spender)
589     );
590   }
591 
592   /**
593    * @dev Internal function to mint a new token
594    * Reverts if the given token ID already exists
595    * @param _to The address that will own the minted token
596    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
597    */
598   function _mint(address _to, uint256 _tokenId) internal {
599     require(_to != address(0));
600     addTokenTo(_to, _tokenId);
601     emit Transfer(address(0), _to, _tokenId);
602   }
603 
604   /**
605    * @dev Internal function to burn a specific token
606    * Reverts if the token does not exist
607    * @param _tokenId uint256 ID of the token being burned by the msg.sender
608    */
609   function _burn(address _owner, uint256 _tokenId) internal {
610     clearApproval(_owner, _tokenId);
611     removeTokenFrom(_owner, _tokenId);
612     emit Transfer(_owner, address(0), _tokenId);
613   }
614 
615   /**
616    * @dev Internal function to clear current approval of a given token ID
617    * Reverts if the given address is not indeed the owner of the token
618    * @param _owner owner of the token
619    * @param _tokenId uint256 ID of the token to be transferred
620    */
621   function clearApproval(address _owner, uint256 _tokenId) internal {
622     require(ownerOf(_tokenId) == _owner);
623     if (tokenApprovals[_tokenId] != address(0)) {
624       tokenApprovals[_tokenId] = address(0);
625     }
626   }
627 
628   /**
629    * @dev Internal function to add a token ID to the list of a given address
630    * @param _to address representing the new owner of the given token ID
631    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
632    */
633   function addTokenTo(address _to, uint256 _tokenId) internal {
634     require(tokenOwner[_tokenId] == address(0));
635     tokenOwner[_tokenId] = _to;
636     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
637   }
638 
639   /**
640    * @dev Internal function to remove a token ID from the list of a given address
641    * @param _from address representing the previous owner of the given token ID
642    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
643    */
644   function removeTokenFrom(address _from, uint256 _tokenId) internal {
645     require(ownerOf(_tokenId) == _from);
646     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
647     tokenOwner[_tokenId] = address(0);
648   }
649 
650   /**
651    * @dev Internal function to invoke `onERC721Received` on a target address
652    * The call is not executed if the target address is not a contract
653    * @param _from address representing the previous owner of the given token ID
654    * @param _to target address that will receive the tokens
655    * @param _tokenId uint256 ID of the token to be transferred
656    * @param _data bytes optional data to send along with the call
657    * @return whether the call correctly returned the expected magic value
658    */
659   function checkAndCallSafeTransfer(
660     address _from,
661     address _to,
662     uint256 _tokenId,
663     bytes _data
664   )
665     internal
666     returns (bool)
667   {
668     if (!_to.isContract()) {
669       return true;
670     }
671     bytes4 retval = ERC721Receiver(_to).onERC721Received(
672       msg.sender, _from, _tokenId, _data);
673     return (retval == ERC721_RECEIVED);
674   }
675 }
676 
677 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
678 
679   bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
680   /**
681    * 0x780e9d63 ===
682    *   bytes4(keccak256('totalSupply()')) ^
683    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
684    *   bytes4(keccak256('tokenByIndex(uint256)'))
685    */
686 
687   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
688   /**
689    * 0x5b5e139f ===
690    *   bytes4(keccak256('name()')) ^
691    *   bytes4(keccak256('symbol()')) ^
692    *   bytes4(keccak256('tokenURI(uint256)'))
693    */
694 
695   // Token name
696   string internal name_;
697 
698   // Token symbol
699   string internal symbol_;
700 
701   // Mapping from owner to list of owned token IDs
702   mapping(address => uint256[]) internal ownedTokens;
703 
704   // Mapping from token ID to index of the owner tokens list
705   mapping(uint256 => uint256) internal ownedTokensIndex;
706 
707   // Array with all token ids, used for enumeration
708   uint256[] internal allTokens;
709 
710   // Mapping from token id to position in the allTokens array
711   mapping(uint256 => uint256) internal allTokensIndex;
712 
713   // Optional mapping for token URIs
714   mapping(uint256 => string) internal tokenURIs;
715 
716   /**
717    * @dev Constructor function
718    */
719   constructor(string _name, string _symbol) public {
720     name_ = _name;
721     symbol_ = _symbol;
722 
723     // register the supported interfaces to conform to ERC721 via ERC165
724     _registerInterface(InterfaceId_ERC721Enumerable);
725     _registerInterface(InterfaceId_ERC721Metadata);
726   }
727 
728   /**
729    * @dev Gets the token name
730    * @return string representing the token name
731    */
732   function name() external view returns (string) {
733     return name_;
734   }
735 
736   /**
737    * @dev Gets the token symbol
738    * @return string representing the token symbol
739    */
740   function symbol() external view returns (string) {
741     return symbol_;
742   }
743 
744   /**
745    * @dev Returns an URI for a given token ID
746    * Throws if the token ID does not exist. May return an empty string.
747    * @param _tokenId uint256 ID of the token to query
748    */
749   function tokenURI(uint256 _tokenId) public view returns (string) {
750     require(exists(_tokenId));
751     return tokenURIs[_tokenId];
752   }
753 
754   /**
755    * @dev Gets the token ID at a given index of the tokens list of the requested owner
756    * @param _owner address owning the tokens list to be accessed
757    * @param _index uint256 representing the index to be accessed of the requested tokens list
758    * @return uint256 token ID at the given index of the tokens list owned by the requested address
759    */
760   function tokenOfOwnerByIndex(
761     address _owner,
762     uint256 _index
763   )
764     public
765     view
766     returns (uint256)
767   {
768     require(_index < balanceOf(_owner));
769     return ownedTokens[_owner][_index];
770   }
771 
772   /**
773    * @dev Gets the total amount of tokens stored by the contract
774    * @return uint256 representing the total amount of tokens
775    */
776   function totalSupply() public view returns (uint256) {
777     return allTokens.length;
778   }
779 
780   /**
781    * @dev Gets the token ID at a given index of all the tokens in this contract
782    * Reverts if the index is greater or equal to the total number of tokens
783    * @param _index uint256 representing the index to be accessed of the tokens list
784    * @return uint256 token ID at the given index of the tokens list
785    */
786   function tokenByIndex(uint256 _index) public view returns (uint256) {
787     require(_index < totalSupply());
788     return allTokens[_index];
789   }
790 
791   /**
792    * @dev Internal function to set the token URI for a given token
793    * Reverts if the token ID does not exist
794    * @param _tokenId uint256 ID of the token to set its URI
795    * @param _uri string URI to assign
796    */
797   function _setTokenURI(uint256 _tokenId, string _uri) internal {
798     require(exists(_tokenId));
799     tokenURIs[_tokenId] = _uri;
800   }
801 
802   /**
803    * @dev Internal function to add a token ID to the list of a given address
804    * @param _to address representing the new owner of the given token ID
805    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
806    */
807   function addTokenTo(address _to, uint256 _tokenId) internal {
808     super.addTokenTo(_to, _tokenId);
809     uint256 length = ownedTokens[_to].length;
810     ownedTokens[_to].push(_tokenId);
811     ownedTokensIndex[_tokenId] = length;
812   }
813 
814   /**
815    * @dev Internal function to remove a token ID from the list of a given address
816    * @param _from address representing the previous owner of the given token ID
817    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
818    */
819   function removeTokenFrom(address _from, uint256 _tokenId) internal {
820     super.removeTokenFrom(_from, _tokenId);
821 
822     uint256 tokenIndex = ownedTokensIndex[_tokenId];
823     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
824     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
825 
826     ownedTokens[_from][tokenIndex] = lastToken;
827     ownedTokens[_from][lastTokenIndex] = 0;
828     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
829     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
830     // the lastToken to the first position, and then dropping the element placed in the last position of the list
831 
832     ownedTokens[_from].length--;
833     ownedTokensIndex[_tokenId] = 0;
834     ownedTokensIndex[lastToken] = tokenIndex;
835   }
836 
837   /**
838    * @dev Internal function to mint a new token
839    * Reverts if the given token ID already exists
840    * @param _to address the beneficiary that will own the minted token
841    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
842    */
843   function _mint(address _to, uint256 _tokenId) internal {
844     super._mint(_to, _tokenId);
845 
846     allTokensIndex[_tokenId] = allTokens.length;
847     allTokens.push(_tokenId);
848   }
849 
850   /**
851    * @dev Internal function to burn a specific token
852    * Reverts if the token does not exist
853    * @param _owner owner of the token to burn
854    * @param _tokenId uint256 ID of the token being burned by the msg.sender
855    */
856   function _burn(address _owner, uint256 _tokenId) internal {
857     super._burn(_owner, _tokenId);
858 
859     // Clear metadata (if any)
860     if (bytes(tokenURIs[_tokenId]).length != 0) {
861       delete tokenURIs[_tokenId];
862     }
863 
864     // Reorg all tokens array
865     uint256 tokenIndex = allTokensIndex[_tokenId];
866     uint256 lastTokenIndex = allTokens.length.sub(1);
867     uint256 lastToken = allTokens[lastTokenIndex];
868 
869     allTokens[tokenIndex] = lastToken;
870     allTokens[lastTokenIndex] = 0;
871 
872     allTokens.length--;
873     allTokensIndex[_tokenId] = 0;
874     allTokensIndex[lastToken] = tokenIndex;
875   }
876 
877 }
878 
879 contract CryptoCareToken is ERC721Token, Ownable, Pausable {
880     event TokenURIUpdated(uint256 _tokenID, string _tokenURI);
881 
882     address public minterAddress;
883 
884     constructor() public ERC721Token("CryptoCare", "CARE") {}
885 
886     /**
887     * @dev Throws if called by any account other than the minter.
888     */
889     modifier onlyMinter() {
890         require(msg.sender == minterAddress);
891         _;
892     }
893 
894     /**
895     * @dev Mints a new token with given tokenURI for an address
896     * @param _to the address to mint the token to
897     * @param _tokenURI the token URI containing the token metadata
898     */
899     function mintToken(address _to, string _tokenURI) public onlyMinter whenNotPaused returns (uint256) {
900         uint256 newTokenId = _getNextTokenId();
901         _mint(_to, newTokenId);
902         _setTokenURI(newTokenId, _tokenURI);
903 
904         return newTokenId;
905     }
906 
907     /**
908     * @dev Updates the token URI for a given token ID
909     * @param _tokenID the token ID to update
910     */
911     function updateTokenURI(uint256 _tokenID, string _tokenURI) public onlyMinter whenNotPaused {
912         _setTokenURI(_tokenID, _tokenURI);
913         emit TokenURIUpdated(_tokenID, _tokenURI);
914     }
915 
916     /**
917     * @dev Updates the minter address
918     * @param _addr the new minter address
919     */
920     function updateMinter(address _addr) public onlyOwner whenNotPaused {
921         require(_addr > 0);
922         minterAddress = _addr;
923     }
924 
925     /**
926     * @dev calculates the next token ID based on totalSupply
927     * @return uint256 for the next token ID
928     */
929     function _getNextTokenId() private view returns (uint256) {
930         return totalSupply().add(1);
931     }
932 }
933 
934 contract CryptoCareMinter is Ownable, Pausable {
935     event Adoption(uint256 tokenId, address indexed toAddress, string tokenURI, uint8 beneficiaryId, uint256 price, uint8 rate);
936 
937     event BeneficiaryAdded(uint8 beneficiaryId, address addr);
938     event BeneficiaryRateUpdated(uint8 beneficiaryId, uint8 rate);
939     event BeneficiaryActivated(uint8 beneficiaryId);
940     event BeneficiaryDeactivated(uint8 beneficiaryId);
941 
942     struct beneficiaryInfo {
943         address addr;
944         bool isActive;
945         uint256 total;
946     }
947 
948     address public minterAddress;
949     mapping(uint8 => beneficiaryInfo) public beneficiaries;
950     mapping(uint256 => bool) private usedNonces;
951 
952     uint8 public overrideRate;
953     bool public overrideRateActive;
954 
955     CryptoCareToken public tokenContract;
956 
957     /**
958     * @dev Mints a token to an address with a tokenURI
959     *            and sends funds to beneficiary specified
960     * @param _to address of the future owner of the token
961     * @param _beneficiaryId the id in beneficiaryAddresses to send the money to
962     * @param _tokenURI token URI for the token metadata
963     * @param _nonce nonce for the transaction
964     */
965     function mintTo(
966         address _to, uint8 _beneficiaryId, string _tokenURI, uint256 _nonce, uint8 _rate, uint8 v, bytes32 r, bytes32 s
967     ) public payable whenNotPaused returns (uint256) {
968         require(msg.value > 0);
969         require(!usedNonces[_nonce]);
970         require(beneficiaries[_beneficiaryId].addr > 0);
971         require(beneficiaries[_beneficiaryId].isActive);
972         require(verifyMessage(keccak256(abi.encodePacked(_to, _tokenURI, _beneficiaryId, _nonce, msg.value)), v, r, s));
973         usedNonces[_nonce] = true;
974 
975         uint256 newTokenId = CryptoCareToken(tokenContract).mintToken(_to, _tokenURI);
976         transferToBeneficiary(msg.value, _beneficiaryId, _rate);
977 
978         emit Adoption(newTokenId, _to, _tokenURI, _beneficiaryId, msg.value, _rate);
979 
980         return newTokenId;
981     }
982 
983     /**
984     * @dev Adds a beneficiary to the mapping
985     * @param beneficiaryId the identifier for the beneficiary address
986     * @param addr the address of the beneficiary
987     */
988     function addBeneficiary(uint8 beneficiaryId, address addr) public onlyOwner {
989         require(beneficiaries[beneficiaryId].addr == 0);
990         beneficiaries[beneficiaryId] = beneficiaryInfo(addr, true, 0);
991         emit BeneficiaryAdded(beneficiaryId, addr);
992     }
993 
994     /**
995     * @dev Activates an existing beneficiary in the mapping
996     * @param beneficiaryId the identifier for the beneficiary address
997     */
998     function activateBeneficiary(uint8 beneficiaryId) public onlyOwner {
999         require(beneficiaries[beneficiaryId].addr > 0);
1000         require(!beneficiaries[beneficiaryId].isActive);
1001 
1002         beneficiaries[beneficiaryId].isActive = true;
1003         emit BeneficiaryActivated(beneficiaryId);
1004     }
1005 
1006     /**
1007     * @dev Deactivates a beneficiary from the mapping
1008     * @param beneficiaryId the identifier for the beneficiary address
1009     */
1010     function deactivateBeneficiary(uint8 beneficiaryId) public onlyOwner {
1011         require(beneficiaries[beneficiaryId].addr > 0);
1012         require(beneficiaries[beneficiaryId].isActive);
1013 
1014         beneficiaries[beneficiaryId].isActive = false;
1015         emit BeneficiaryDeactivated(beneficiaryId);
1016     }
1017 
1018     /**
1019     * @dev Updates the minter address
1020     * @param _addr the new minter address
1021     */
1022     function updateMinter(address _addr) public onlyOwner {
1023         require(_addr > 0);
1024         minterAddress = _addr;
1025     }
1026 
1027     /**
1028     * @dev Updates the token contract address
1029     * @param _tokenContractAddress the new token contract address
1030     */
1031     function updateTokenContract(address _tokenContractAddress) public onlyOwner {
1032         tokenContract = CryptoCareToken(_tokenContractAddress);
1033     }
1034 
1035     /**
1036     * @dev Updates override rate and if it is active
1037     * @param _active whether the override is active or not
1038     * @param _rate the new override rate
1039     */
1040     function updateOverrideRate(bool _active, uint8 _rate) public onlyOwner {
1041         require(_rate < 100);
1042         overrideRateActive = _active;
1043         overrideRate = _rate;
1044     }
1045 
1046     /**
1047     * @dev Allows owner to withdraw funds in contract
1048     */
1049     function withdraw() public onlyOwner {
1050         owner.transfer(address(this).balance);
1051     }
1052 
1053     function tokenURI(uint256 _tokenId) public view returns (string) {
1054         return CryptoCareToken(tokenContract).tokenURI(_tokenId);
1055     }
1056 
1057     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
1058         return CryptoCareToken(tokenContract).tokenOfOwnerByIndex(_owner, _index);
1059     }
1060 
1061     /**
1062     * @dev Verifies a given hash and ECDSA signature match the minter address
1063     * @param h to verify
1064     * @param v ECDSA signature parameter
1065     * @param r ECDSA signature parameter
1066     * @param s ECDSA signature parameter
1067     * @return bool whether the hash was signed by the minter
1068     */
1069     function verifyMessage(bytes32 h, uint8 v, bytes32 r, bytes32 s) private view returns (bool) {
1070         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
1071         bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, h));
1072         address addr = ecrecover(prefixedHash, v, r, s);
1073         bool verified = (addr == minterAddress);
1074         return verified;
1075     }
1076 
1077     /**
1078     * @dev Transfers amount to beneficiary
1079     * @param amount the amount to transfer
1080     * @param _beneficiaryId the beneficiary to receive it
1081     */
1082     function transferToBeneficiary(uint256 amount, uint8 _beneficiaryId, uint8 _rate) private {
1083         beneficiaryInfo storage beneficiary = beneficiaries[_beneficiaryId];
1084         uint8 rate = overrideRateActive ? overrideRate : _rate;
1085         uint256 beneficiaryTotal = (amount * (100 - rate))/100;
1086 
1087         beneficiary.addr.transfer(beneficiaryTotal);
1088         beneficiary.total += beneficiaryTotal;
1089     }
1090 }