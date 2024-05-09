1 pragma solidity 0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
12     // benefit is lost if 'b' is also tested.
13     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
14     if (a == 0) {
15       return 0;
16     }
17 
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 library AddressUtils {
52 
53   /**
54    * Returns whether the target address is a contract
55    * @dev This function will return false if invoked during the constructor of a contract,
56    * as the code is not actually created until after the constructor finishes.
57    * @param addr address to check
58    * @return whether the target address is a contract
59    */
60   function isContract(address addr) internal view returns (bool) {
61     uint256 size;
62     // XXX Currently there is no better way to check if there is a contract in an address
63     // than to check the size of the code at that address.
64     // See https://ethereum.stackexchange.com/a/14016/36603
65     // for more details about how this works.
66     // TODO Check this again before the Serenity release, because all addresses will be
67     // contracts then.
68     // solium-disable-next-line security/no-inline-assembly
69     assembly { size := extcodesize(addr) }
70     return size > 0;
71   }
72 
73 }
74 
75 interface ERC165 {
76 
77   /**
78    * @notice Query if a contract implements an interface
79    * @param _interfaceId The interface identifier, as specified in ERC-165
80    * @dev Interface identification is specified in ERC-165. This function
81    * uses less than 30,000 gas.
82    */
83   function supportsInterface(bytes4 _interfaceId)
84     external
85     view
86     returns (bool);
87 }
88 
89 contract Ownable {
90   address public owner;
91 
92 
93   event OwnershipRenounced(address indexed previousOwner);
94   event OwnershipTransferred(
95     address indexed previousOwner,
96     address indexed newOwner
97   );
98 
99 
100   /**
101    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
102    * account.
103    */
104   constructor() public {
105     owner = msg.sender;
106   }
107 
108   /**
109    * @dev Throws if called by any account other than the owner.
110    */
111   modifier onlyOwner() {
112     require(msg.sender == owner);
113     _;
114   }
115 
116   /**
117    * @dev Allows the current owner to relinquish control of the contract.
118    * @notice Renouncing to ownership will leave the contract without an owner.
119    * It will not be possible to call the functions with the `onlyOwner`
120    * modifier anymore.
121    */
122   function renounceOwnership() public onlyOwner {
123     emit OwnershipRenounced(owner);
124     owner = address(0);
125   }
126 
127   /**
128    * @dev Allows the current owner to transfer control of the contract to a newOwner.
129    * @param _newOwner The address to transfer ownership to.
130    */
131   function transferOwnership(address _newOwner) public onlyOwner {
132     _transferOwnership(_newOwner);
133   }
134 
135   /**
136    * @dev Transfers control of the contract to a newOwner.
137    * @param _newOwner The address to transfer ownership to.
138    */
139   function _transferOwnership(address _newOwner) internal {
140     require(_newOwner != address(0));
141     emit OwnershipTransferred(owner, _newOwner);
142     owner = _newOwner;
143   }
144 }
145 
146 contract ERC20Basic {
147   function totalSupply() public view returns (uint256);
148   function balanceOf(address who) public view returns (uint256);
149   function transfer(address to, uint256 value) public returns (bool);
150   event Transfer(address indexed from, address indexed to, uint256 value);
151 }
152 
153 contract ERC721Receiver {
154   /**
155    * @dev Magic value to be returned upon successful reception of an NFT
156    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
157    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
158    */
159   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
160 
161   /**
162    * @notice Handle the receipt of an NFT
163    * @dev The ERC721 smart contract calls this function on the recipient
164    * after a `safetransfer`. This function MAY throw to revert and reject the
165    * transfer. Return of other than the magic value MUST result in the 
166    * transaction being reverted.
167    * Note: the contract address is always the message sender.
168    * @param _operator The address which called `safeTransferFrom` function
169    * @param _from The address which previously owned the token
170    * @param _tokenId The NFT identifier which is being transfered
171    * @param _data Additional data with no specified format
172    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
173    */
174   function onERC721Received(
175     address _operator,
176     address _from,
177     uint256 _tokenId,
178     bytes _data
179   )
180     public
181     returns(bytes4);
182 }
183 
184 contract SupportsInterfaceWithLookup is ERC165 {
185   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
186   /**
187    * 0x01ffc9a7 ===
188    *   bytes4(keccak256('supportsInterface(bytes4)'))
189    */
190 
191   /**
192    * @dev a mapping of interface id to whether or not it's supported
193    */
194   mapping(bytes4 => bool) internal supportedInterfaces;
195 
196   /**
197    * @dev A contract implementing SupportsInterfaceWithLookup
198    * implement ERC165 itself
199    */
200   constructor()
201     public
202   {
203     _registerInterface(InterfaceId_ERC165);
204   }
205 
206   /**
207    * @dev implement supportsInterface(bytes4) using a lookup table
208    */
209   function supportsInterface(bytes4 _interfaceId)
210     external
211     view
212     returns (bool)
213   {
214     return supportedInterfaces[_interfaceId];
215   }
216 
217   /**
218    * @dev private method for registering an interface
219    */
220   function _registerInterface(bytes4 _interfaceId)
221     internal
222   {
223     require(_interfaceId != 0xffffffff);
224     supportedInterfaces[_interfaceId] = true;
225   }
226 }
227 
228 contract ERC20 is ERC20Basic {
229   function allowance(address owner, address spender)
230     public view returns (uint256);
231 
232   function transferFrom(address from, address to, uint256 value)
233     public returns (bool);
234 
235   function approve(address spender, uint256 value) public returns (bool);
236   event Approval(
237     address indexed owner,
238     address indexed spender,
239     uint256 value
240   );
241 }
242 
243 contract ERC721Basic is ERC165 {
244   event Transfer(
245     address indexed _from,
246     address indexed _to,
247     uint256 indexed _tokenId
248   );
249   event Approval(
250     address indexed _owner,
251     address indexed _approved,
252     uint256 indexed _tokenId
253   );
254   event ApprovalForAll(
255     address indexed _owner,
256     address indexed _operator,
257     bool _approved
258   );
259 
260   function balanceOf(address _owner) public view returns (uint256 _balance);
261   function ownerOf(uint256 _tokenId) public view returns (address _owner);
262   function exists(uint256 _tokenId) public view returns (bool _exists);
263 
264   function approve(address _to, uint256 _tokenId) public;
265   function getApproved(uint256 _tokenId)
266     public view returns (address _operator);
267 
268   function setApprovalForAll(address _operator, bool _approved) public;
269   function isApprovedForAll(address _owner, address _operator)
270     public view returns (bool);
271 
272   function transferFrom(address _from, address _to, uint256 _tokenId) public;
273   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
274     public;
275 
276   function safeTransferFrom(
277     address _from,
278     address _to,
279     uint256 _tokenId,
280     bytes _data
281   )
282     public;
283 }
284 
285 contract ERC721Enumerable is ERC721Basic {
286   function totalSupply() public view returns (uint256);
287   function tokenOfOwnerByIndex(
288     address _owner,
289     uint256 _index
290   )
291     public
292     view
293     returns (uint256 _tokenId);
294 
295   function tokenByIndex(uint256 _index) public view returns (uint256);
296 }
297 
298 
299 /**
300  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
301  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
302  */
303 contract ERC721Metadata is ERC721Basic {
304   function name() external view returns (string _name);
305   function symbol() external view returns (string _symbol);
306   function tokenURI(uint256 _tokenId) public view returns (string);
307 }
308 
309 
310 /**
311  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
312  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
313  */
314 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
315 }
316 
317 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
318 
319   bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
320   /*
321    * 0x80ac58cd ===
322    *   bytes4(keccak256('balanceOf(address)')) ^
323    *   bytes4(keccak256('ownerOf(uint256)')) ^
324    *   bytes4(keccak256('approve(address,uint256)')) ^
325    *   bytes4(keccak256('getApproved(uint256)')) ^
326    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
327    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
328    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
329    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
330    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
331    */
332 
333   bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
334   /*
335    * 0x4f558e79 ===
336    *   bytes4(keccak256('exists(uint256)'))
337    */
338 
339   using SafeMath for uint256;
340   using AddressUtils for address;
341 
342   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
343   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
344   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
345 
346   // Mapping from token ID to owner
347   mapping (uint256 => address) internal tokenOwner;
348 
349   // Mapping from token ID to approved address
350   mapping (uint256 => address) internal tokenApprovals;
351 
352   // Mapping from owner to number of owned token
353   mapping (address => uint256) internal ownedTokensCount;
354 
355   // Mapping from owner to operator approvals
356   mapping (address => mapping (address => bool)) internal operatorApprovals;
357 
358   /**
359    * @dev Guarantees msg.sender is owner of the given token
360    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
361    */
362   modifier onlyOwnerOf(uint256 _tokenId) {
363     require(ownerOf(_tokenId) == msg.sender);
364     _;
365   }
366 
367   /**
368    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
369    * @param _tokenId uint256 ID of the token to validate
370    */
371   modifier canTransfer(uint256 _tokenId) {
372     require(isApprovedOrOwner(msg.sender, _tokenId));
373     _;
374   }
375 
376   constructor()
377     public
378   {
379     // register the supported interfaces to conform to ERC721 via ERC165
380     _registerInterface(InterfaceId_ERC721);
381     _registerInterface(InterfaceId_ERC721Exists);
382   }
383 
384   /**
385    * @dev Gets the balance of the specified address
386    * @param _owner address to query the balance of
387    * @return uint256 representing the amount owned by the passed address
388    */
389   function balanceOf(address _owner) public view returns (uint256) {
390     require(_owner != address(0));
391     return ownedTokensCount[_owner];
392   }
393 
394   /**
395    * @dev Gets the owner of the specified token ID
396    * @param _tokenId uint256 ID of the token to query the owner of
397    * @return owner address currently marked as the owner of the given token ID
398    */
399   function ownerOf(uint256 _tokenId) public view returns (address) {
400     address owner = tokenOwner[_tokenId];
401     require(owner != address(0));
402     return owner;
403   }
404 
405   /**
406    * @dev Returns whether the specified token exists
407    * @param _tokenId uint256 ID of the token to query the existence of
408    * @return whether the token exists
409    */
410   function exists(uint256 _tokenId) public view returns (bool) {
411     address owner = tokenOwner[_tokenId];
412     return owner != address(0);
413   }
414 
415   /**
416    * @dev Approves another address to transfer the given token ID
417    * The zero address indicates there is no approved address.
418    * There can only be one approved address per token at a given time.
419    * Can only be called by the token owner or an approved operator.
420    * @param _to address to be approved for the given token ID
421    * @param _tokenId uint256 ID of the token to be approved
422    */
423   function approve(address _to, uint256 _tokenId) public {
424     address owner = ownerOf(_tokenId);
425     require(_to != owner);
426     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
427 
428     tokenApprovals[_tokenId] = _to;
429     emit Approval(owner, _to, _tokenId);
430   }
431 
432   /**
433    * @dev Gets the approved address for a token ID, or zero if no address set
434    * @param _tokenId uint256 ID of the token to query the approval of
435    * @return address currently approved for the given token ID
436    */
437   function getApproved(uint256 _tokenId) public view returns (address) {
438     return tokenApprovals[_tokenId];
439   }
440 
441   /**
442    * @dev Sets or unsets the approval of a given operator
443    * An operator is allowed to transfer all tokens of the sender on their behalf
444    * @param _to operator address to set the approval
445    * @param _approved representing the status of the approval to be set
446    */
447   function setApprovalForAll(address _to, bool _approved) public {
448     require(_to != msg.sender);
449     operatorApprovals[msg.sender][_to] = _approved;
450     emit ApprovalForAll(msg.sender, _to, _approved);
451   }
452 
453   /**
454    * @dev Tells whether an operator is approved by a given owner
455    * @param _owner owner address which you want to query the approval of
456    * @param _operator operator address which you want to query the approval of
457    * @return bool whether the given operator is approved by the given owner
458    */
459   function isApprovedForAll(
460     address _owner,
461     address _operator
462   )
463     public
464     view
465     returns (bool)
466   {
467     return operatorApprovals[_owner][_operator];
468   }
469 
470   /**
471    * @dev Transfers the ownership of a given token ID to another address
472    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
473    * Requires the msg sender to be the owner, approved, or operator
474    * @param _from current owner of the token
475    * @param _to address to receive the ownership of the given token ID
476    * @param _tokenId uint256 ID of the token to be transferred
477   */
478   function transferFrom(
479     address _from,
480     address _to,
481     uint256 _tokenId
482   )
483     public
484     canTransfer(_tokenId)
485   {
486     require(_from != address(0));
487     require(_to != address(0));
488 
489     clearApproval(_from, _tokenId);
490     removeTokenFrom(_from, _tokenId);
491     addTokenTo(_to, _tokenId);
492 
493     emit Transfer(_from, _to, _tokenId);
494   }
495 
496   /**
497    * @dev Safely transfers the ownership of a given token ID to another address
498    * If the target address is a contract, it must implement `onERC721Received`,
499    * which is called upon a safe transfer, and return the magic value
500    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
501    * the transfer is reverted.
502    *
503    * Requires the msg sender to be the owner, approved, or operator
504    * @param _from current owner of the token
505    * @param _to address to receive the ownership of the given token ID
506    * @param _tokenId uint256 ID of the token to be transferred
507   */
508   function safeTransferFrom(
509     address _from,
510     address _to,
511     uint256 _tokenId
512   )
513     public
514     canTransfer(_tokenId)
515   {
516     // solium-disable-next-line arg-overflow
517     safeTransferFrom(_from, _to, _tokenId, "");
518   }
519 
520   /**
521    * @dev Safely transfers the ownership of a given token ID to another address
522    * If the target address is a contract, it must implement `onERC721Received`,
523    * which is called upon a safe transfer, and return the magic value
524    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
525    * the transfer is reverted.
526    * Requires the msg sender to be the owner, approved, or operator
527    * @param _from current owner of the token
528    * @param _to address to receive the ownership of the given token ID
529    * @param _tokenId uint256 ID of the token to be transferred
530    * @param _data bytes data to send along with a safe transfer check
531    */
532   function safeTransferFrom(
533     address _from,
534     address _to,
535     uint256 _tokenId,
536     bytes _data
537   )
538     public
539     canTransfer(_tokenId)
540   {
541     transferFrom(_from, _to, _tokenId);
542     // solium-disable-next-line arg-overflow
543     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
544   }
545 
546   /**
547    * @dev Returns whether the given spender can transfer a given token ID
548    * @param _spender address of the spender to query
549    * @param _tokenId uint256 ID of the token to be transferred
550    * @return bool whether the msg.sender is approved for the given token ID,
551    *  is an operator of the owner, or is the owner of the token
552    */
553   function isApprovedOrOwner(
554     address _spender,
555     uint256 _tokenId
556   )
557     internal
558     view
559     returns (bool)
560   {
561     address owner = ownerOf(_tokenId);
562     // Disable solium check because of
563     // https://github.com/duaraghav8/Solium/issues/175
564     // solium-disable-next-line operator-whitespace
565     return (
566       _spender == owner ||
567       getApproved(_tokenId) == _spender ||
568       isApprovedForAll(owner, _spender)
569     );
570   }
571 
572   /**
573    * @dev Internal function to mint a new token
574    * Reverts if the given token ID already exists
575    * @param _to The address that will own the minted token
576    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
577    */
578   function _mint(address _to, uint256 _tokenId) internal {
579     require(_to != address(0));
580     addTokenTo(_to, _tokenId);
581     emit Transfer(address(0), _to, _tokenId);
582   }
583 
584   /**
585    * @dev Internal function to burn a specific token
586    * Reverts if the token does not exist
587    * @param _tokenId uint256 ID of the token being burned by the msg.sender
588    */
589   function _burn(address _owner, uint256 _tokenId) internal {
590     clearApproval(_owner, _tokenId);
591     removeTokenFrom(_owner, _tokenId);
592     emit Transfer(_owner, address(0), _tokenId);
593   }
594 
595   /**
596    * @dev Internal function to clear current approval of a given token ID
597    * Reverts if the given address is not indeed the owner of the token
598    * @param _owner owner of the token
599    * @param _tokenId uint256 ID of the token to be transferred
600    */
601   function clearApproval(address _owner, uint256 _tokenId) internal {
602     require(ownerOf(_tokenId) == _owner);
603     if (tokenApprovals[_tokenId] != address(0)) {
604       tokenApprovals[_tokenId] = address(0);
605     }
606   }
607 
608   /**
609    * @dev Internal function to add a token ID to the list of a given address
610    * @param _to address representing the new owner of the given token ID
611    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
612    */
613   function addTokenTo(address _to, uint256 _tokenId) internal {
614     require(tokenOwner[_tokenId] == address(0));
615     tokenOwner[_tokenId] = _to;
616     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
617   }
618 
619   /**
620    * @dev Internal function to remove a token ID from the list of a given address
621    * @param _from address representing the previous owner of the given token ID
622    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
623    */
624   function removeTokenFrom(address _from, uint256 _tokenId) internal {
625     require(ownerOf(_tokenId) == _from);
626     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
627     tokenOwner[_tokenId] = address(0);
628   }
629 
630   /**
631    * @dev Internal function to invoke `onERC721Received` on a target address
632    * The call is not executed if the target address is not a contract
633    * @param _from address representing the previous owner of the given token ID
634    * @param _to target address that will receive the tokens
635    * @param _tokenId uint256 ID of the token to be transferred
636    * @param _data bytes optional data to send along with the call
637    * @return whether the call correctly returned the expected magic value
638    */
639   function checkAndCallSafeTransfer(
640     address _from,
641     address _to,
642     uint256 _tokenId,
643     bytes _data
644   )
645     internal
646     returns (bool)
647   {
648     if (!_to.isContract()) {
649       return true;
650     }
651     bytes4 retval = ERC721Receiver(_to).onERC721Received(
652       msg.sender, _from, _tokenId, _data);
653     return (retval == ERC721_RECEIVED);
654   }
655 }
656 
657 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
658 
659   bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
660   /**
661    * 0x780e9d63 ===
662    *   bytes4(keccak256('totalSupply()')) ^
663    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
664    *   bytes4(keccak256('tokenByIndex(uint256)'))
665    */
666 
667   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
668   /**
669    * 0x5b5e139f ===
670    *   bytes4(keccak256('name()')) ^
671    *   bytes4(keccak256('symbol()')) ^
672    *   bytes4(keccak256('tokenURI(uint256)'))
673    */
674 
675   // Token name
676   string internal name_;
677 
678   // Token symbol
679   string internal symbol_;
680 
681   // Mapping from owner to list of owned token IDs
682   mapping(address => uint256[]) internal ownedTokens;
683 
684   // Mapping from token ID to index of the owner tokens list
685   mapping(uint256 => uint256) internal ownedTokensIndex;
686 
687   // Array with all token ids, used for enumeration
688   uint256[] internal allTokens;
689 
690   // Mapping from token id to position in the allTokens array
691   mapping(uint256 => uint256) internal allTokensIndex;
692 
693   // Optional mapping for token URIs
694   mapping(uint256 => string) internal tokenURIs;
695 
696   /**
697    * @dev Constructor function
698    */
699   constructor(string _name, string _symbol) public {
700     name_ = _name;
701     symbol_ = _symbol;
702 
703     // register the supported interfaces to conform to ERC721 via ERC165
704     _registerInterface(InterfaceId_ERC721Enumerable);
705     _registerInterface(InterfaceId_ERC721Metadata);
706   }
707 
708   /**
709    * @dev Gets the token name
710    * @return string representing the token name
711    */
712   function name() external view returns (string) {
713     return name_;
714   }
715 
716   /**
717    * @dev Gets the token symbol
718    * @return string representing the token symbol
719    */
720   function symbol() external view returns (string) {
721     return symbol_;
722   }
723 
724   /**
725    * @dev Returns an URI for a given token ID
726    * Throws if the token ID does not exist. May return an empty string.
727    * @param _tokenId uint256 ID of the token to query
728    */
729   function tokenURI(uint256 _tokenId) public view returns (string) {
730     require(exists(_tokenId));
731     return tokenURIs[_tokenId];
732   }
733 
734   /**
735    * @dev Gets the token ID at a given index of the tokens list of the requested owner
736    * @param _owner address owning the tokens list to be accessed
737    * @param _index uint256 representing the index to be accessed of the requested tokens list
738    * @return uint256 token ID at the given index of the tokens list owned by the requested address
739    */
740   function tokenOfOwnerByIndex(
741     address _owner,
742     uint256 _index
743   )
744     public
745     view
746     returns (uint256)
747   {
748     require(_index < balanceOf(_owner));
749     return ownedTokens[_owner][_index];
750   }
751 
752   /**
753    * @dev Gets the total amount of tokens stored by the contract
754    * @return uint256 representing the total amount of tokens
755    */
756   function totalSupply() public view returns (uint256) {
757     return allTokens.length;
758   }
759 
760   /**
761    * @dev Gets the token ID at a given index of all the tokens in this contract
762    * Reverts if the index is greater or equal to the total number of tokens
763    * @param _index uint256 representing the index to be accessed of the tokens list
764    * @return uint256 token ID at the given index of the tokens list
765    */
766   function tokenByIndex(uint256 _index) public view returns (uint256) {
767     require(_index < totalSupply());
768     return allTokens[_index];
769   }
770 
771   /**
772    * @dev Internal function to set the token URI for a given token
773    * Reverts if the token ID does not exist
774    * @param _tokenId uint256 ID of the token to set its URI
775    * @param _uri string URI to assign
776    */
777   function _setTokenURI(uint256 _tokenId, string _uri) internal {
778     require(exists(_tokenId));
779     tokenURIs[_tokenId] = _uri;
780   }
781 
782   /**
783    * @dev Internal function to add a token ID to the list of a given address
784    * @param _to address representing the new owner of the given token ID
785    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
786    */
787   function addTokenTo(address _to, uint256 _tokenId) internal {
788     super.addTokenTo(_to, _tokenId);
789     uint256 length = ownedTokens[_to].length;
790     ownedTokens[_to].push(_tokenId);
791     ownedTokensIndex[_tokenId] = length;
792   }
793 
794   /**
795    * @dev Internal function to remove a token ID from the list of a given address
796    * @param _from address representing the previous owner of the given token ID
797    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
798    */
799   function removeTokenFrom(address _from, uint256 _tokenId) internal {
800     super.removeTokenFrom(_from, _tokenId);
801 
802     uint256 tokenIndex = ownedTokensIndex[_tokenId];
803     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
804     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
805 
806     ownedTokens[_from][tokenIndex] = lastToken;
807     ownedTokens[_from][lastTokenIndex] = 0;
808     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
809     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
810     // the lastToken to the first position, and then dropping the element placed in the last position of the list
811 
812     ownedTokens[_from].length--;
813     ownedTokensIndex[_tokenId] = 0;
814     ownedTokensIndex[lastToken] = tokenIndex;
815   }
816 
817   /**
818    * @dev Internal function to mint a new token
819    * Reverts if the given token ID already exists
820    * @param _to address the beneficiary that will own the minted token
821    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
822    */
823   function _mint(address _to, uint256 _tokenId) internal {
824     super._mint(_to, _tokenId);
825 
826     allTokensIndex[_tokenId] = allTokens.length;
827     allTokens.push(_tokenId);
828   }
829 
830   /**
831    * @dev Internal function to burn a specific token
832    * Reverts if the token does not exist
833    * @param _owner owner of the token to burn
834    * @param _tokenId uint256 ID of the token being burned by the msg.sender
835    */
836   function _burn(address _owner, uint256 _tokenId) internal {
837     super._burn(_owner, _tokenId);
838 
839     // Clear metadata (if any)
840     if (bytes(tokenURIs[_tokenId]).length != 0) {
841       delete tokenURIs[_tokenId];
842     }
843 
844     // Reorg all tokens array
845     uint256 tokenIndex = allTokensIndex[_tokenId];
846     uint256 lastTokenIndex = allTokens.length.sub(1);
847     uint256 lastToken = allTokens[lastTokenIndex];
848 
849     allTokens[tokenIndex] = lastToken;
850     allTokens[lastTokenIndex] = 0;
851 
852     allTokens.length--;
853     allTokensIndex[_tokenId] = 0;
854     allTokensIndex[lastToken] = tokenIndex;
855   }
856 
857 }
858 
859 contract EveryDappToken is ERC721Token, Ownable {
860     using SafeMath for uint256;
861 
862     struct Ad {
863         uint32 width; //in pixels
864         uint32 height;
865         string imageUrl;
866         string href;
867         bool forSale;
868         uint256 price;
869     }
870 
871     event AdOffered(uint256 adId, uint256 price);
872     event OfferCancelled(uint256 adId);
873     event AdBought(uint256 adId);
874     event AdAdded(uint256 adId);
875 
876     mapping(uint256 => Ad) public ads;
877     mapping(uint256 => uint) public suggestedAdPrices;
878     uint256 public ownerCut; //0-10000, in 0,01% so 10000 means 100%
879     uint256 public priceProgression; //0-10000, in 0,01% so 10000 means 100%
880 
881     constructor() public ERC721Token("EveryDapp Token", "EVDT") {
882         ownerCut = 1000;
883         priceProgression = 1000;
884     }
885 
886     modifier onlyExistingAd(uint256 _adId) {
887         require(exists(_adId));
888         _;
889     }
890 
891     function adIds() public view returns (uint256[]) {
892         return allTokens;
893     }
894 
895     function transferFrom(
896         address _from,
897         address _to,
898         uint256 _adId
899     ) public {
900         ERC721BasicToken.transferFrom(_from, _to, _adId);
901 
902         _cancelOffer(_adId);
903     }
904 
905     function addAd(
906         uint32 _width,
907         uint32 _height,
908         string _imageUrl,
909         string _href,
910         string _uri,
911         uint256 _initialPrice
912     ) public onlyOwner {
913         uint256 newAdId = allTokens.length;
914         super._mint(owner, newAdId);
915         ads[newAdId] = Ad({
916             width: _width,
917             height: _height,
918             imageUrl: _imageUrl,
919             href: _href,
920             forSale: false,
921             price: 0
922         });
923         tokenURIs[newAdId] = _uri;
924         _setSuggestedAdPrice(newAdId, _initialPrice);
925 
926         emit AdAdded(newAdId);
927     }
928 
929     function setAdURI(uint256 _id, string _uri) public onlyOwner {
930         tokenURIs[_id] = _uri;
931     }
932 
933     function setAdData(
934         uint256 _adId,
935         string _imageUrl,
936         string _href
937     ) public onlyOwnerOf(_adId) {
938         ads[_adId].imageUrl = _imageUrl;
939         ads[_adId].href = _href;
940     }
941 
942     function offerAd(uint256 _adId, uint256 _price) public onlyOwnerOf(_adId) {
943         ads[_adId].forSale = true;
944 
945         if (_price == 0) {
946             ads[_adId].price = suggestedAdPrices[_adId];
947         } else {
948             ads[_adId].price = _price;
949         }
950 
951         emit AdOffered(_adId, ads[_adId].price);
952     }
953 
954     function cancelOffer(uint256 _adId) public onlyOwnerOf(_adId) {
955         _cancelOffer(_adId);
956     }
957 
958     function buyAd(uint256 _adId) public payable onlyExistingAd(_adId) {
959         address adOwner = ownerOf(_adId);
960         uint256 adPrice = ads[_adId].price;
961 
962         require(ads[_adId].forSale);
963         require(msg.value == adPrice);
964         require(msg.sender != adOwner);
965 
966         tokenApprovals[_adId] = msg.sender;
967         safeTransferFrom(adOwner, msg.sender, _adId);
968 
969         _setSuggestedAdPrice(_adId, _progressAdPrice(adPrice));
970 
971         uint256 ownerFee = calculateOwnerFee(msg.value);
972         uint256 sellerFee = msg.value - ownerFee;
973 
974         owner.transfer(ownerFee);
975         adOwner.transfer(sellerFee);
976 
977         emit AdBought(_adId);
978     }
979 
980     function setOwnerCut(uint16 _ownerCut) public onlyOwner {
981         ownerCut = _ownerCut;
982     }
983 
984     function setPriceProgression(uint16 _priceProgression) public onlyOwner {
985         priceProgression = _priceProgression;
986     }
987 
988     function setSuggestedAdPrice(uint256 _adId, uint256 _price) public onlyOwner {
989         require(!ads[_adId].forSale);
990 
991         _setSuggestedAdPrice(_adId, _price);
992     }
993 
994     function calculateOwnerFee(uint256 _value) public view returns (uint256) {
995         return _value.mul(ownerCut).div(10000);
996     }
997 
998     function _cancelOffer(uint256 _adId) private {
999         bool wasOffered = ads[_adId].forSale;
1000 
1001         ads[_adId].forSale = false;
1002         ads[_adId].price = 0;
1003 
1004         if (wasOffered) {
1005             emit OfferCancelled(_adId);
1006         }
1007     }
1008 
1009     function _setSuggestedAdPrice(uint256 _adId, uint256 _price) private {
1010         require(!ads[_adId].forSale);
1011 
1012         suggestedAdPrices[_adId] = _price;
1013     }
1014 
1015     function _progressAdPrice(uint256 _basePrice) private view returns (uint256) {
1016         return _basePrice.mul(priceProgression.add(10000)).div(10000);
1017     }
1018 
1019     // In case of accidental ether lock on contract
1020     function withdraw() public onlyOwner {
1021         owner.transfer(address(this).balance);
1022     }
1023 
1024     // In case of accidental token transfer to this address, owner can transfer it elsewhere
1025     function transferERC20Token(
1026         address _tokenAddress,
1027         address _to,
1028         uint256 _value
1029     ) public onlyOwner {
1030         ERC20 token = ERC20(_tokenAddress);
1031         assert(token.transfer(_to, _value));
1032     }
1033 }