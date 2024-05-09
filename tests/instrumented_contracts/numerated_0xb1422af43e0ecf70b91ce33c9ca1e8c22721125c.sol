1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 contract Ownable {
6   address public owner;
7 
8 
9   event OwnershipRenounced(address indexed previousOwner);
10   event OwnershipTransferred(
11     address indexed previousOwner,
12     address indexed newOwner
13   );
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to relinquish control of the contract.
34    * @notice Renouncing to ownership will leave the contract without an owner.
35    * It will not be possible to call the functions with the `onlyOwner`
36    * modifier anymore.
37    */
38   function renounceOwnership() public onlyOwner {
39     emit OwnershipRenounced(owner);
40     owner = address(0);
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param _newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address _newOwner) public onlyOwner {
48     _transferOwnership(_newOwner);
49   }
50 
51   /**
52    * @dev Transfers control of the contract to a newOwner.
53    * @param _newOwner The address to transfer ownership to.
54    */
55   function _transferOwnership(address _newOwner) internal {
56     require(_newOwner != address(0));
57     emit OwnershipTransferred(owner, _newOwner);
58     owner = _newOwner;
59   }
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
108 interface ERC165 {
109 
110   /**
111    * @notice Query if a contract implements an interface
112    * @param _interfaceId The interface identifier, as specified in ERC-165
113    * @dev Interface identification is specified in ERC-165. This function
114    * uses less than 30,000 gas.
115    */
116   function supportsInterface(bytes4 _interfaceId)
117     external
118     view
119     returns (bool);
120 }
121 
122 contract ERC721Receiver {
123   /**
124    * @dev Magic value to be returned upon successful reception of an NFT
125    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
126    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
127    */
128   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
129 
130   /**
131    * @notice Handle the receipt of an NFT
132    * @dev The ERC721 smart contract calls this function on the recipient
133    * after a `safetransfer`. This function MAY throw to revert and reject the
134    * transfer. Return of other than the magic value MUST result in the 
135    * transaction being reverted.
136    * Note: the contract address is always the message sender.
137    * @param _operator The address which called `safeTransferFrom` function
138    * @param _from The address which previously owned the token
139    * @param _tokenId The NFT identifier which is being transfered
140    * @param _data Additional data with no specified format
141    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
142    */
143   function onERC721Received(
144     address _operator,
145     address _from,
146     uint256 _tokenId,
147     bytes _data
148   )
149     public
150     returns(bytes4);
151 }
152 
153 library AddressUtils {
154 
155   /**
156    * Returns whether the target address is a contract
157    * @dev This function will return false if invoked during the constructor of a contract,
158    * as the code is not actually created until after the constructor finishes.
159    * @param addr address to check
160    * @return whether the target address is a contract
161    */
162   function isContract(address addr) internal view returns (bool) {
163     uint256 size;
164     // XXX Currently there is no better way to check if there is a contract in an address
165     // than to check the size of the code at that address.
166     // See https://ethereum.stackexchange.com/a/14016/36603
167     // for more details about how this works.
168     // TODO Check this again before the Serenity release, because all addresses will be
169     // contracts then.
170     // solium-disable-next-line security/no-inline-assembly
171     assembly { size := extcodesize(addr) }
172     return size > 0;
173   }
174 
175 }
176 
177 contract SupportsInterfaceWithLookup is ERC165 {
178   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
179   /**
180    * 0x01ffc9a7 ===
181    *   bytes4(keccak256('supportsInterface(bytes4)'))
182    */
183 
184   /**
185    * @dev a mapping of interface id to whether or not it's supported
186    */
187   mapping(bytes4 => bool) internal supportedInterfaces;
188 
189   /**
190    * @dev A contract implementing SupportsInterfaceWithLookup
191    * implement ERC165 itself
192    */
193   constructor()
194     public
195   {
196     _registerInterface(InterfaceId_ERC165);
197   }
198 
199   /**
200    * @dev implement supportsInterface(bytes4) using a lookup table
201    */
202   function supportsInterface(bytes4 _interfaceId)
203     external
204     view
205     returns (bool)
206   {
207     return supportedInterfaces[_interfaceId];
208   }
209 
210   /**
211    * @dev private method for registering an interface
212    */
213   function _registerInterface(bytes4 _interfaceId)
214     internal
215   {
216     require(_interfaceId != 0xffffffff);
217     supportedInterfaces[_interfaceId] = true;
218   }
219 }
220 
221 contract ERC721Basic is ERC165 {
222   event Transfer(
223     address indexed _from,
224     address indexed _to,
225     uint256 indexed _tokenId
226   );
227   event Approval(
228     address indexed _owner,
229     address indexed _approved,
230     uint256 indexed _tokenId
231   );
232   event ApprovalForAll(
233     address indexed _owner,
234     address indexed _operator,
235     bool _approved
236   );
237 
238   function balanceOf(address _owner) public view returns (uint256 _balance);
239   function ownerOf(uint256 _tokenId) public view returns (address _owner);
240   function exists(uint256 _tokenId) public view returns (bool _exists);
241 
242   function approve(address _to, uint256 _tokenId) public;
243   function getApproved(uint256 _tokenId)
244     public view returns (address _operator);
245 
246   function setApprovalForAll(address _operator, bool _approved) public;
247   function isApprovedForAll(address _owner, address _operator)
248     public view returns (bool);
249 
250   function transferFrom(address _from, address _to, uint256 _tokenId) public;
251   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
252     public;
253 
254   function safeTransferFrom(
255     address _from,
256     address _to,
257     uint256 _tokenId,
258     bytes _data
259   )
260     public;
261 }
262 
263 contract ERC721Enumerable is ERC721Basic {
264   function totalSupply() public view returns (uint256);
265   function tokenOfOwnerByIndex(
266     address _owner,
267     uint256 _index
268   )
269     public
270     view
271     returns (uint256 _tokenId);
272 
273   function tokenByIndex(uint256 _index) public view returns (uint256);
274 }
275 
276 
277 /**
278  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
279  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
280  */
281 contract ERC721Metadata is ERC721Basic {
282   function name() external view returns (string _name);
283   function symbol() external view returns (string _symbol);
284   function tokenURI(uint256 _tokenId) public view returns (string);
285 }
286 
287 
288 /**
289  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
290  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
291  */
292 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
293 }
294 
295 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
296 
297   bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
298   /*
299    * 0x80ac58cd ===
300    *   bytes4(keccak256('balanceOf(address)')) ^
301    *   bytes4(keccak256('ownerOf(uint256)')) ^
302    *   bytes4(keccak256('approve(address,uint256)')) ^
303    *   bytes4(keccak256('getApproved(uint256)')) ^
304    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
305    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
306    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
307    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
308    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
309    */
310 
311   bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
312   /*
313    * 0x4f558e79 ===
314    *   bytes4(keccak256('exists(uint256)'))
315    */
316 
317   using SafeMath for uint256;
318   using AddressUtils for address;
319 
320   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
321   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
322   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
323 
324   // Mapping from token ID to owner
325   mapping (uint256 => address) internal tokenOwner;
326 
327   // Mapping from token ID to approved address
328   mapping (uint256 => address) internal tokenApprovals;
329 
330   // Mapping from owner to number of owned token
331   mapping (address => uint256) internal ownedTokensCount;
332 
333   // Mapping from owner to operator approvals
334   mapping (address => mapping (address => bool)) internal operatorApprovals;
335 
336   /**
337    * @dev Guarantees msg.sender is owner of the given token
338    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
339    */
340   modifier onlyOwnerOf(uint256 _tokenId) {
341     require(ownerOf(_tokenId) == msg.sender);
342     _;
343   }
344 
345   /**
346    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
347    * @param _tokenId uint256 ID of the token to validate
348    */
349   modifier canTransfer(uint256 _tokenId) {
350     require(isApprovedOrOwner(msg.sender, _tokenId));
351     _;
352   }
353 
354   constructor()
355     public
356   {
357     // register the supported interfaces to conform to ERC721 via ERC165
358     _registerInterface(InterfaceId_ERC721);
359     _registerInterface(InterfaceId_ERC721Exists);
360   }
361 
362   /**
363    * @dev Gets the balance of the specified address
364    * @param _owner address to query the balance of
365    * @return uint256 representing the amount owned by the passed address
366    */
367   function balanceOf(address _owner) public view returns (uint256) {
368     require(_owner != address(0));
369     return ownedTokensCount[_owner];
370   }
371 
372   /**
373    * @dev Gets the owner of the specified token ID
374    * @param _tokenId uint256 ID of the token to query the owner of
375    * @return owner address currently marked as the owner of the given token ID
376    */
377   function ownerOf(uint256 _tokenId) public view returns (address) {
378     address owner = tokenOwner[_tokenId];
379     require(owner != address(0));
380     return owner;
381   }
382 
383   /**
384    * @dev Returns whether the specified token exists
385    * @param _tokenId uint256 ID of the token to query the existence of
386    * @return whether the token exists
387    */
388   function exists(uint256 _tokenId) public view returns (bool) {
389     address owner = tokenOwner[_tokenId];
390     return owner != address(0);
391   }
392 
393   /**
394    * @dev Approves another address to transfer the given token ID
395    * The zero address indicates there is no approved address.
396    * There can only be one approved address per token at a given time.
397    * Can only be called by the token owner or an approved operator.
398    * @param _to address to be approved for the given token ID
399    * @param _tokenId uint256 ID of the token to be approved
400    */
401   function approve(address _to, uint256 _tokenId) public {
402     address owner = ownerOf(_tokenId);
403     require(_to != owner);
404     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
405 
406     tokenApprovals[_tokenId] = _to;
407     emit Approval(owner, _to, _tokenId);
408   }
409 
410   /**
411    * @dev Gets the approved address for a token ID, or zero if no address set
412    * @param _tokenId uint256 ID of the token to query the approval of
413    * @return address currently approved for the given token ID
414    */
415   function getApproved(uint256 _tokenId) public view returns (address) {
416     return tokenApprovals[_tokenId];
417   }
418 
419   /**
420    * @dev Sets or unsets the approval of a given operator
421    * An operator is allowed to transfer all tokens of the sender on their behalf
422    * @param _to operator address to set the approval
423    * @param _approved representing the status of the approval to be set
424    */
425   function setApprovalForAll(address _to, bool _approved) public {
426     require(_to != msg.sender);
427     operatorApprovals[msg.sender][_to] = _approved;
428     emit ApprovalForAll(msg.sender, _to, _approved);
429   }
430 
431   /**
432    * @dev Tells whether an operator is approved by a given owner
433    * @param _owner owner address which you want to query the approval of
434    * @param _operator operator address which you want to query the approval of
435    * @return bool whether the given operator is approved by the given owner
436    */
437   function isApprovedForAll(
438     address _owner,
439     address _operator
440   )
441     public
442     view
443     returns (bool)
444   {
445     return operatorApprovals[_owner][_operator];
446   }
447 
448   /**
449    * @dev Transfers the ownership of a given token ID to another address
450    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
451    * Requires the msg sender to be the owner, approved, or operator
452    * @param _from current owner of the token
453    * @param _to address to receive the ownership of the given token ID
454    * @param _tokenId uint256 ID of the token to be transferred
455   */
456   function transferFrom(
457     address _from,
458     address _to,
459     uint256 _tokenId
460   )
461     public
462     canTransfer(_tokenId)
463   {
464     require(_from != address(0));
465     require(_to != address(0));
466 
467     clearApproval(_from, _tokenId);
468     removeTokenFrom(_from, _tokenId);
469     addTokenTo(_to, _tokenId);
470 
471     emit Transfer(_from, _to, _tokenId);
472   }
473 
474   /**
475    * @dev Safely transfers the ownership of a given token ID to another address
476    * If the target address is a contract, it must implement `onERC721Received`,
477    * which is called upon a safe transfer, and return the magic value
478    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
479    * the transfer is reverted.
480    *
481    * Requires the msg sender to be the owner, approved, or operator
482    * @param _from current owner of the token
483    * @param _to address to receive the ownership of the given token ID
484    * @param _tokenId uint256 ID of the token to be transferred
485   */
486   function safeTransferFrom(
487     address _from,
488     address _to,
489     uint256 _tokenId
490   )
491     public
492     canTransfer(_tokenId)
493   {
494     // solium-disable-next-line arg-overflow
495     safeTransferFrom(_from, _to, _tokenId, "");
496   }
497 
498   /**
499    * @dev Safely transfers the ownership of a given token ID to another address
500    * If the target address is a contract, it must implement `onERC721Received`,
501    * which is called upon a safe transfer, and return the magic value
502    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
503    * the transfer is reverted.
504    * Requires the msg sender to be the owner, approved, or operator
505    * @param _from current owner of the token
506    * @param _to address to receive the ownership of the given token ID
507    * @param _tokenId uint256 ID of the token to be transferred
508    * @param _data bytes data to send along with a safe transfer check
509    */
510   function safeTransferFrom(
511     address _from,
512     address _to,
513     uint256 _tokenId,
514     bytes _data
515   )
516     public
517     canTransfer(_tokenId)
518   {
519     transferFrom(_from, _to, _tokenId);
520     // solium-disable-next-line arg-overflow
521     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
522   }
523 
524   /**
525    * @dev Returns whether the given spender can transfer a given token ID
526    * @param _spender address of the spender to query
527    * @param _tokenId uint256 ID of the token to be transferred
528    * @return bool whether the msg.sender is approved for the given token ID,
529    *  is an operator of the owner, or is the owner of the token
530    */
531   function isApprovedOrOwner(
532     address _spender,
533     uint256 _tokenId
534   )
535     internal
536     view
537     returns (bool)
538   {
539     address owner = ownerOf(_tokenId);
540     // Disable solium check because of
541     // https://github.com/duaraghav8/Solium/issues/175
542     // solium-disable-next-line operator-whitespace
543     return (
544       _spender == owner ||
545       getApproved(_tokenId) == _spender ||
546       isApprovedForAll(owner, _spender)
547     );
548   }
549 
550   /**
551    * @dev Internal function to mint a new token
552    * Reverts if the given token ID already exists
553    * @param _to The address that will own the minted token
554    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
555    */
556   function _mint(address _to, uint256 _tokenId) internal {
557     require(_to != address(0));
558     addTokenTo(_to, _tokenId);
559     emit Transfer(address(0), _to, _tokenId);
560   }
561 
562   /**
563    * @dev Internal function to burn a specific token
564    * Reverts if the token does not exist
565    * @param _tokenId uint256 ID of the token being burned by the msg.sender
566    */
567   function _burn(address _owner, uint256 _tokenId) internal {
568     clearApproval(_owner, _tokenId);
569     removeTokenFrom(_owner, _tokenId);
570     emit Transfer(_owner, address(0), _tokenId);
571   }
572 
573   /**
574    * @dev Internal function to clear current approval of a given token ID
575    * Reverts if the given address is not indeed the owner of the token
576    * @param _owner owner of the token
577    * @param _tokenId uint256 ID of the token to be transferred
578    */
579   function clearApproval(address _owner, uint256 _tokenId) internal {
580     require(ownerOf(_tokenId) == _owner);
581     if (tokenApprovals[_tokenId] != address(0)) {
582       tokenApprovals[_tokenId] = address(0);
583     }
584   }
585 
586   /**
587    * @dev Internal function to add a token ID to the list of a given address
588    * @param _to address representing the new owner of the given token ID
589    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
590    */
591   function addTokenTo(address _to, uint256 _tokenId) internal {
592     require(tokenOwner[_tokenId] == address(0));
593     tokenOwner[_tokenId] = _to;
594     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
595   }
596 
597   /**
598    * @dev Internal function to remove a token ID from the list of a given address
599    * @param _from address representing the previous owner of the given token ID
600    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
601    */
602   function removeTokenFrom(address _from, uint256 _tokenId) internal {
603     require(ownerOf(_tokenId) == _from);
604     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
605     tokenOwner[_tokenId] = address(0);
606   }
607 
608   /**
609    * @dev Internal function to invoke `onERC721Received` on a target address
610    * The call is not executed if the target address is not a contract
611    * @param _from address representing the previous owner of the given token ID
612    * @param _to target address that will receive the tokens
613    * @param _tokenId uint256 ID of the token to be transferred
614    * @param _data bytes optional data to send along with the call
615    * @return whether the call correctly returned the expected magic value
616    */
617   function checkAndCallSafeTransfer(
618     address _from,
619     address _to,
620     uint256 _tokenId,
621     bytes _data
622   )
623     internal
624     returns (bool)
625   {
626     if (!_to.isContract()) {
627       return true;
628     }
629     bytes4 retval = ERC721Receiver(_to).onERC721Received(
630       msg.sender, _from, _tokenId, _data);
631     return (retval == ERC721_RECEIVED);
632   }
633 }
634 
635 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
636 
637   bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
638   /**
639    * 0x780e9d63 ===
640    *   bytes4(keccak256('totalSupply()')) ^
641    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
642    *   bytes4(keccak256('tokenByIndex(uint256)'))
643    */
644 
645   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
646   /**
647    * 0x5b5e139f ===
648    *   bytes4(keccak256('name()')) ^
649    *   bytes4(keccak256('symbol()')) ^
650    *   bytes4(keccak256('tokenURI(uint256)'))
651    */
652 
653   // Token name
654   string internal name_;
655 
656   // Token symbol
657   string internal symbol_;
658 
659   // Mapping from owner to list of owned token IDs
660   mapping(address => uint256[]) internal ownedTokens;
661 
662   // Mapping from token ID to index of the owner tokens list
663   mapping(uint256 => uint256) internal ownedTokensIndex;
664 
665   // Array with all token ids, used for enumeration
666   uint256[] internal allTokens;
667 
668   // Mapping from token id to position in the allTokens array
669   mapping(uint256 => uint256) internal allTokensIndex;
670 
671   // Optional mapping for token URIs
672   mapping(uint256 => string) internal tokenURIs;
673 
674   /**
675    * @dev Constructor function
676    */
677   constructor(string _name, string _symbol) public {
678     name_ = _name;
679     symbol_ = _symbol;
680 
681     // register the supported interfaces to conform to ERC721 via ERC165
682     _registerInterface(InterfaceId_ERC721Enumerable);
683     _registerInterface(InterfaceId_ERC721Metadata);
684   }
685 
686   /**
687    * @dev Gets the token name
688    * @return string representing the token name
689    */
690   function name() external view returns (string) {
691     return name_;
692   }
693 
694   /**
695    * @dev Gets the token symbol
696    * @return string representing the token symbol
697    */
698   function symbol() external view returns (string) {
699     return symbol_;
700   }
701 
702   /**
703    * @dev Returns an URI for a given token ID
704    * Throws if the token ID does not exist. May return an empty string.
705    * @param _tokenId uint256 ID of the token to query
706    */
707   function tokenURI(uint256 _tokenId) public view returns (string) {
708     require(exists(_tokenId));
709     return tokenURIs[_tokenId];
710   }
711 
712   /**
713    * @dev Gets the token ID at a given index of the tokens list of the requested owner
714    * @param _owner address owning the tokens list to be accessed
715    * @param _index uint256 representing the index to be accessed of the requested tokens list
716    * @return uint256 token ID at the given index of the tokens list owned by the requested address
717    */
718   function tokenOfOwnerByIndex(
719     address _owner,
720     uint256 _index
721   )
722     public
723     view
724     returns (uint256)
725   {
726     require(_index < balanceOf(_owner));
727     return ownedTokens[_owner][_index];
728   }
729 
730   /**
731    * @dev Gets the total amount of tokens stored by the contract
732    * @return uint256 representing the total amount of tokens
733    */
734   function totalSupply() public view returns (uint256) {
735     return allTokens.length;
736   }
737 
738   /**
739    * @dev Gets the token ID at a given index of all the tokens in this contract
740    * Reverts if the index is greater or equal to the total number of tokens
741    * @param _index uint256 representing the index to be accessed of the tokens list
742    * @return uint256 token ID at the given index of the tokens list
743    */
744   function tokenByIndex(uint256 _index) public view returns (uint256) {
745     require(_index < totalSupply());
746     return allTokens[_index];
747   }
748 
749   /**
750    * @dev Internal function to set the token URI for a given token
751    * Reverts if the token ID does not exist
752    * @param _tokenId uint256 ID of the token to set its URI
753    * @param _uri string URI to assign
754    */
755   function _setTokenURI(uint256 _tokenId, string _uri) internal {
756     require(exists(_tokenId));
757     tokenURIs[_tokenId] = _uri;
758   }
759 
760   /**
761    * @dev Internal function to add a token ID to the list of a given address
762    * @param _to address representing the new owner of the given token ID
763    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
764    */
765   function addTokenTo(address _to, uint256 _tokenId) internal {
766     super.addTokenTo(_to, _tokenId);
767     uint256 length = ownedTokens[_to].length;
768     ownedTokens[_to].push(_tokenId);
769     ownedTokensIndex[_tokenId] = length;
770   }
771 
772   /**
773    * @dev Internal function to remove a token ID from the list of a given address
774    * @param _from address representing the previous owner of the given token ID
775    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
776    */
777   function removeTokenFrom(address _from, uint256 _tokenId) internal {
778     super.removeTokenFrom(_from, _tokenId);
779 
780     uint256 tokenIndex = ownedTokensIndex[_tokenId];
781     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
782     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
783 
784     ownedTokens[_from][tokenIndex] = lastToken;
785     ownedTokens[_from][lastTokenIndex] = 0;
786     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
787     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
788     // the lastToken to the first position, and then dropping the element placed in the last position of the list
789 
790     ownedTokens[_from].length--;
791     ownedTokensIndex[_tokenId] = 0;
792     ownedTokensIndex[lastToken] = tokenIndex;
793   }
794 
795   /**
796    * @dev Internal function to mint a new token
797    * Reverts if the given token ID already exists
798    * @param _to address the beneficiary that will own the minted token
799    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
800    */
801   function _mint(address _to, uint256 _tokenId) internal {
802     super._mint(_to, _tokenId);
803 
804     allTokensIndex[_tokenId] = allTokens.length;
805     allTokens.push(_tokenId);
806   }
807 
808   /**
809    * @dev Internal function to burn a specific token
810    * Reverts if the token does not exist
811    * @param _owner owner of the token to burn
812    * @param _tokenId uint256 ID of the token being burned by the msg.sender
813    */
814   function _burn(address _owner, uint256 _tokenId) internal {
815     super._burn(_owner, _tokenId);
816 
817     // Clear metadata (if any)
818     if (bytes(tokenURIs[_tokenId]).length != 0) {
819       delete tokenURIs[_tokenId];
820     }
821 
822     // Reorg all tokens array
823     uint256 tokenIndex = allTokensIndex[_tokenId];
824     uint256 lastTokenIndex = allTokens.length.sub(1);
825     uint256 lastToken = allTokens[lastTokenIndex];
826 
827     allTokens[tokenIndex] = lastToken;
828     allTokens[lastTokenIndex] = 0;
829 
830     allTokens.length--;
831     allTokensIndex[_tokenId] = 0;
832     allTokensIndex[lastToken] = tokenIndex;
833   }
834 
835 }
836 
837 contract SmartTixToken is ERC721Token("TokenForum Certificates", "TokenForum"), Ownable {
838     event LogAddress(string msg, address output);
839     event LogId(string msg, uint256 output);
840 
841     /**
842     * @dev Mints a single token to a unique address with a tokenURI.
843     * @param _to address of the future owner of the token
844     * @param _tokenURI token URI for the token
845     * @return newly generated token id 
846     */
847     function mintTicket(
848         address _to,
849         string  _tokenURI
850     ) public onlyOwner returns (uint256) {
851         // ensure 1 token per user
852         require(super.balanceOf(_to) == 0);
853 
854         uint256 _tokenId = totalSupply().add(1); 
855         super._mint(_to, _tokenId);
856         super._setTokenURI(_tokenId, _tokenURI);
857         return _tokenId;
858     }
859 
860     /** @dev Sets token metadata URI.
861     * @param _tokenId token ID
862     * @param _tokenURI token URI for the token
863     */
864     function setTokenURI(
865         uint256 _tokenId, string _tokenURI
866     ) public onlyOwner {
867         super._setTokenURI(_tokenId, _tokenURI);
868     }
869 
870     /** @dev Get token metadata URI.
871     * @param _owner address of token owner
872     * @return string representing URI of the user's token
873     */
874     function getTokenURI(address _owner) public  view returns (string) {
875         uint256 _tokenId = super.tokenOfOwnerByIndex(_owner, 0);
876         require(_tokenId > 0);
877         return super.tokenURI(_tokenId);
878     }
879 }