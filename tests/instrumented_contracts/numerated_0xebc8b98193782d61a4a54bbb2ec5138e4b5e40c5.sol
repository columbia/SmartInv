1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     c = _a * _b;
22     assert(c / _a == _b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     // assert(_b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33     return _a / _b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
40     assert(_b <= _a);
41     return _a - _b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
48     c = _a + _b;
49     assert(c >= _a);
50     return c;
51   }
52 }
53 
54 
55 /**
56  * Utility library of inline functions on addresses
57  */
58 library AddressUtils {
59 
60   /**
61    * Returns whether the target address is a contract
62    * @dev This function will return false if invoked during the constructor of a contract,
63    * as the code is not actually created until after the constructor finishes.
64    * @param _addr address to check
65    * @return whether the target address is a contract
66    */
67   function isContract(address _addr) internal view returns (bool) {
68     uint256 size;
69     // XXX Currently there is no better way to check if there is a contract in an address
70     // than to check the size of the code at that address.
71     // See https://ethereum.stackexchange.com/a/14016/36603
72     // for more details about how this works.
73     // TODO Check this again before the Serenity release, because all addresses will be
74     // contracts then.
75     // solium-disable-next-line security/no-inline-assembly
76     assembly { size := extcodesize(_addr) }
77     return size > 0;
78   }
79 
80 }
81 
82 /**
83  * @title Ownable
84  * @dev The Ownable contract has an owner address, and provides basic authorization control
85  * functions, this simplifies the implementation of "user permissions".
86  */
87 contract Ownable {
88   address public owner;
89 
90 
91   event OwnershipRenounced(address indexed previousOwner);
92   event OwnershipTransferred(
93     address indexed previousOwner,
94     address indexed newOwner
95   );
96 
97 
98   /**
99    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
100    * account.
101    */
102   constructor() public {
103     owner = msg.sender;
104   }
105 
106   /**
107    * @dev Throws if called by any account other than the owner.
108    */
109   modifier onlyOwner() {
110     require(msg.sender == owner);
111     _;
112   }
113 
114   /**
115    * @dev Allows the current owner to relinquish control of the contract.
116    * @notice Renouncing to ownership will leave the contract without an owner.
117    * It will not be possible to call the functions with the `onlyOwner`
118    * modifier anymore.
119    */
120   function renounceOwnership() public onlyOwner {
121     emit OwnershipRenounced(owner);
122     owner = address(0);
123   }
124 
125   /**
126    * @dev Allows the current owner to transfer control of the contract to a newOwner.
127    * @param _newOwner The address to transfer ownership to.
128    */
129   function transferOwnership(address _newOwner) public onlyOwner {
130     _transferOwnership(_newOwner);
131   }
132 
133   /**
134    * @dev Transfers control of the contract to a newOwner.
135    * @param _newOwner The address to transfer ownership to.
136    */
137   function _transferOwnership(address _newOwner) internal {
138     require(_newOwner != address(0));
139     emit OwnershipTransferred(owner, _newOwner);
140     owner = _newOwner;
141   }
142 }
143 
144 /**
145  * @title ERC165
146  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
147  */
148 interface ERC165 {
149 
150   /**
151    * @notice Query if a contract implements an interface
152    * @param _interfaceId The interface identifier, as specified in ERC-165
153    * @dev Interface identification is specified in ERC-165. This function
154    * uses less than 30,000 gas.
155    */
156   function supportsInterface(bytes4 _interfaceId)
157     external
158     view
159     returns (bool);
160 }
161 
162 /**
163  * @title SupportsInterfaceWithLookup
164  * @author Matt Condon (@shrugs)
165  * @dev Implements ERC165 using a lookup table.
166  */
167 contract SupportsInterfaceWithLookup is ERC165 {
168 
169   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
170   /**
171    * 0x01ffc9a7 ===
172    *   bytes4(keccak256('supportsInterface(bytes4)'))
173    */
174 
175   /**
176    * @dev a mapping of interface id to whether or not it's supported
177    */
178   mapping(bytes4 => bool) internal supportedInterfaces;
179 
180   /**
181    * @dev A contract implementing SupportsInterfaceWithLookup
182    * implement ERC165 itself
183    */
184   constructor()
185     public
186   {
187     _registerInterface(InterfaceId_ERC165);
188   }
189 
190   /**
191    * @dev implement supportsInterface(bytes4) using a lookup table
192    */
193   function supportsInterface(bytes4 _interfaceId)
194     external
195     view
196     returns (bool)
197   {
198     return supportedInterfaces[_interfaceId];
199   }
200 
201   /**
202    * @dev private method for registering an interface
203    */
204   function _registerInterface(bytes4 _interfaceId)
205     internal
206   {
207     require(_interfaceId != 0xffffffff);
208     supportedInterfaces[_interfaceId] = true;
209   }
210 }
211 
212 
213 /**
214  * @title ERC721 Non-Fungible Token Standard basic interface
215  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
216  */
217 contract ERC721Basic is ERC165 {
218 
219   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
220   /*
221    * 0x80ac58cd ===
222    *   bytes4(keccak256('balanceOf(address)')) ^
223    *   bytes4(keccak256('ownerOf(uint256)')) ^
224    *   bytes4(keccak256('approve(address,uint256)')) ^
225    *   bytes4(keccak256('getApproved(uint256)')) ^
226    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
227    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
228    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
229    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
230    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
231    */
232 
233   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
234   /*
235    * 0x4f558e79 ===
236    *   bytes4(keccak256('exists(uint256)'))
237    */
238 
239   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
240   /**
241    * 0x780e9d63 ===
242    *   bytes4(keccak256('totalSupply()')) ^
243    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
244    *   bytes4(keccak256('tokenByIndex(uint256)'))
245    */
246 
247   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
248   /**
249    * 0x5b5e139f ===
250    *   bytes4(keccak256('name()')) ^
251    *   bytes4(keccak256('symbol()')) ^
252    *   bytes4(keccak256('tokenURI(uint256)'))
253    */
254 
255   event Transfer(
256     address indexed _from,
257     address indexed _to,
258     uint256 indexed _tokenId
259   );
260   event Approval(
261     address indexed _owner,
262     address indexed _approved,
263     uint256 indexed _tokenId
264   );
265   event ApprovalForAll(
266     address indexed _owner,
267     address indexed _operator,
268     bool _approved
269   );
270 
271   function balanceOf(address _owner) public view returns (uint256 _balance);
272   function ownerOf(uint256 _tokenId) public view returns (address _owner);
273   function exists(uint256 _tokenId) public view returns (bool _exists);
274 
275   function approve(address _to, uint256 _tokenId) public;
276   function getApproved(uint256 _tokenId)
277     public view returns (address _operator);
278 
279   function setApprovalForAll(address _operator, bool _approved) public;
280   function isApprovedForAll(address _owner, address _operator)
281     public view returns (bool);
282 
283   function transferFrom(address _from, address _to, uint256 _tokenId) public;
284   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
285     public;
286 
287   function safeTransferFrom(
288     address _from,
289     address _to,
290     uint256 _tokenId,
291     bytes _data
292   )
293     public;
294 }
295 
296 /**
297  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
298  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
299  */
300 contract ERC721Metadata is ERC721Basic {
301   function name() external view returns (string _name);
302   function symbol() external view returns (string _symbol);
303   function tokenURI(uint256 _tokenId) public view returns (string);
304 }
305 
306 /**
307  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
308  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
309  */
310 contract ERC721Enumerable is ERC721Basic {
311   function totalSupply() public view returns (uint256);
312   function tokenOfOwnerByIndex(
313     address _owner,
314     uint256 _index
315   )
316     public
317     view
318     returns (uint256 _tokenId);
319 
320   function tokenByIndex(uint256 _index) public view returns (uint256);
321 }
322 
323 /**
324  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
325  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
326  */
327 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
328 }
329 
330 /**
331  * @title ERC721 token receiver interface
332  * @dev Interface for any contract that wants to support safeTransfers
333  * from ERC721 asset contracts.
334  */
335 contract ERC721Receiver {
336   /**
337    * @dev Magic value to be returned upon successful reception of an NFT
338    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
339    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
340    */
341   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
342 
343   /**
344    * @notice Handle the receipt of an NFT
345    * @dev The ERC721 smart contract calls this function on the recipient
346    * after a `safetransfer`. This function MAY throw to revert and reject the
347    * transfer. Return of other than the magic value MUST result in the
348    * transaction being reverted.
349    * Note: the contract address is always the message sender.
350    * @param _operator The address which called `safeTransferFrom` function
351    * @param _from The address which previously owned the token
352    * @param _tokenId The NFT identifier which is being transferred
353    * @param _data Additional data with no specified format
354    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
355    */
356   function onERC721Received(
357     address _operator,
358     address _from,
359     uint256 _tokenId,
360     bytes _data
361   )
362     public
363     returns(bytes4);
364 }
365 
366 
367 /**
368  * @title ERC721 Non-Fungible Token Standard basic implementation
369  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
370  */
371 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
372 
373   using SafeMath for uint256;
374   using AddressUtils for address;
375 
376   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
377   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
378   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
379 
380   // Mapping from token ID to owner
381   mapping (uint256 => address) internal tokenOwner;
382 
383   // Mapping from token ID to approved address
384   mapping (uint256 => address) internal tokenApprovals;
385 
386   // Mapping from owner to number of owned token
387   mapping (address => uint256) internal ownedTokensCount;
388 
389   // Mapping from owner to operator approvals
390   mapping (address => mapping (address => bool)) internal operatorApprovals;
391 
392   constructor()
393     public
394   {
395     // register the supported interfaces to conform to ERC721 via ERC165
396     _registerInterface(InterfaceId_ERC721);
397     _registerInterface(InterfaceId_ERC721Exists);
398   }
399 
400   /**
401    * @dev Gets the balance of the specified address
402    * @param _owner address to query the balance of
403    * @return uint256 representing the amount owned by the passed address
404    */
405   function balanceOf(address _owner) public view returns (uint256) {
406     require(_owner != address(0));
407     return ownedTokensCount[_owner];
408   }
409 
410   /**
411    * @dev Gets the owner of the specified token ID
412    * @param _tokenId uint256 ID of the token to query the owner of
413    * @return owner address currently marked as the owner of the given token ID
414    */
415   function ownerOf(uint256 _tokenId) public view returns (address) {
416     address owner = tokenOwner[_tokenId];
417     require(owner != address(0));
418     return owner;
419   }
420 
421   /**
422    * @dev Returns whether the specified token exists
423    * @param _tokenId uint256 ID of the token to query the existence of
424    * @return whether the token exists
425    */
426   function exists(uint256 _tokenId) public view returns (bool) {
427     address owner = tokenOwner[_tokenId];
428     return owner != address(0);
429   }
430 
431   /**
432    * @dev Approves another address to transfer the given token ID
433    * The zero address indicates there is no approved address.
434    * There can only be one approved address per token at a given time.
435    * Can only be called by the token owner or an approved operator.
436    * @param _to address to be approved for the given token ID
437    * @param _tokenId uint256 ID of the token to be approved
438    */
439   function approve(address _to, uint256 _tokenId) public {
440     address owner = ownerOf(_tokenId);
441     require(_to != owner);
442     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
443 
444     tokenApprovals[_tokenId] = _to;
445     emit Approval(owner, _to, _tokenId);
446   }
447 
448   /**
449    * @dev Gets the approved address for a token ID, or zero if no address set
450    * @param _tokenId uint256 ID of the token to query the approval of
451    * @return address currently approved for the given token ID
452    */
453   function getApproved(uint256 _tokenId) public view returns (address) {
454     return tokenApprovals[_tokenId];
455   }
456 
457   /**
458    * @dev Sets or unsets the approval of a given operator
459    * An operator is allowed to transfer all tokens of the sender on their behalf
460    * @param _to operator address to set the approval
461    * @param _approved representing the status of the approval to be set
462    */
463   function setApprovalForAll(address _to, bool _approved) public {
464     require(_to != msg.sender);
465     operatorApprovals[msg.sender][_to] = _approved;
466     emit ApprovalForAll(msg.sender, _to, _approved);
467   }
468 
469   /**
470    * @dev Tells whether an operator is approved by a given owner
471    * @param _owner owner address which you want to query the approval of
472    * @param _operator operator address which you want to query the approval of
473    * @return bool whether the given operator is approved by the given owner
474    */
475   function isApprovedForAll(
476     address _owner,
477     address _operator
478   )
479     public
480     view
481     returns (bool)
482   {
483     return operatorApprovals[_owner][_operator];
484   }
485 
486   /**
487    * @dev Transfers the ownership of a given token ID to another address
488    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
489    * Requires the msg sender to be the owner, approved, or operator
490    * @param _from current owner of the token
491    * @param _to address to receive the ownership of the given token ID
492    * @param _tokenId uint256 ID of the token to be transferred
493   */
494   function transferFrom(
495     address _from,
496     address _to,
497     uint256 _tokenId
498   )
499     public
500   {
501     require(isApprovedOrOwner(msg.sender, _tokenId));
502     require(_from != address(0));
503     require(_to != address(0));
504 
505     clearApproval(_from, _tokenId);
506     removeTokenFrom(_from, _tokenId);
507     addTokenTo(_to, _tokenId);
508 
509     emit Transfer(_from, _to, _tokenId);
510   }
511 
512   /**
513    * @dev Safely transfers the ownership of a given token ID to another address
514    * If the target address is a contract, it must implement `onERC721Received`,
515    * which is called upon a safe transfer, and return the magic value
516    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
517    * the transfer is reverted.
518    *
519    * Requires the msg sender to be the owner, approved, or operator
520    * @param _from current owner of the token
521    * @param _to address to receive the ownership of the given token ID
522    * @param _tokenId uint256 ID of the token to be transferred
523   */
524   function safeTransferFrom(
525     address _from,
526     address _to,
527     uint256 _tokenId
528   )
529     public
530   {
531     // solium-disable-next-line arg-overflow
532     safeTransferFrom(_from, _to, _tokenId, "");
533   }
534 
535   /**
536    * @dev Safely transfers the ownership of a given token ID to another address
537    * If the target address is a contract, it must implement `onERC721Received`,
538    * which is called upon a safe transfer, and return the magic value
539    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
540    * the transfer is reverted.
541    * Requires the msg sender to be the owner, approved, or operator
542    * @param _from current owner of the token
543    * @param _to address to receive the ownership of the given token ID
544    * @param _tokenId uint256 ID of the token to be transferred
545    * @param _data bytes data to send along with a safe transfer check
546    */
547   function safeTransferFrom(
548     address _from,
549     address _to,
550     uint256 _tokenId,
551     bytes _data
552   )
553     public
554   {
555     transferFrom(_from, _to, _tokenId);
556     // solium-disable-next-line arg-overflow
557     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
558   }
559 
560   /**
561    * @dev Returns whether the given spender can transfer a given token ID
562    * @param _spender address of the spender to query
563    * @param _tokenId uint256 ID of the token to be transferred
564    * @return bool whether the msg.sender is approved for the given token ID,
565    *  is an operator of the owner, or is the owner of the token
566    */
567   function isApprovedOrOwner(
568     address _spender,
569     uint256 _tokenId
570   )
571     internal
572     view
573     returns (bool)
574   {
575     address owner = ownerOf(_tokenId);
576     // Disable solium check because of
577     // https://github.com/duaraghav8/Solium/issues/175
578     // solium-disable-next-line operator-whitespace
579     return (
580       _spender == owner ||
581       getApproved(_tokenId) == _spender ||
582       isApprovedForAll(owner, _spender)
583     );
584   }
585 
586   /**
587    * @dev Internal function to mint a new token
588    * Reverts if the given token ID already exists
589    * @param _to The address that will own the minted token
590    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
591    */
592   function _mint(address _to, uint256 _tokenId) internal {
593     require(_to != address(0));
594     addTokenTo(_to, _tokenId);
595     emit Transfer(address(0), _to, _tokenId);
596   }
597 
598   /**
599    * @dev Internal function to burn a specific token
600    * Reverts if the token does not exist
601    * @param _tokenId uint256 ID of the token being burned by the msg.sender
602    */
603   function _burn(address _owner, uint256 _tokenId) internal {
604     clearApproval(_owner, _tokenId);
605     removeTokenFrom(_owner, _tokenId);
606     emit Transfer(_owner, address(0), _tokenId);
607   }
608 
609   /**
610    * @dev Internal function to clear current approval of a given token ID
611    * Reverts if the given address is not indeed the owner of the token
612    * @param _owner owner of the token
613    * @param _tokenId uint256 ID of the token to be transferred
614    */
615   function clearApproval(address _owner, uint256 _tokenId) internal {
616     require(ownerOf(_tokenId) == _owner);
617     if (tokenApprovals[_tokenId] != address(0)) {
618       tokenApprovals[_tokenId] = address(0);
619     }
620   }
621 
622   /**
623    * @dev Internal function to add a token ID to the list of a given address
624    * @param _to address representing the new owner of the given token ID
625    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
626    */
627   function addTokenTo(address _to, uint256 _tokenId) internal {
628     require(tokenOwner[_tokenId] == address(0));
629     tokenOwner[_tokenId] = _to;
630     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
631   }
632 
633   /**
634    * @dev Internal function to remove a token ID from the list of a given address
635    * @param _from address representing the previous owner of the given token ID
636    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
637    */
638   function removeTokenFrom(address _from, uint256 _tokenId) internal {
639     require(ownerOf(_tokenId) == _from);
640     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
641     tokenOwner[_tokenId] = address(0);
642   }
643 
644   /**
645    * @dev Internal function to invoke `onERC721Received` on a target address
646    * The call is not executed if the target address is not a contract
647    * @param _from address representing the previous owner of the given token ID
648    * @param _to target address that will receive the tokens
649    * @param _tokenId uint256 ID of the token to be transferred
650    * @param _data bytes optional data to send along with the call
651    * @return whether the call correctly returned the expected magic value
652    */
653   function checkAndCallSafeTransfer(
654     address _from,
655     address _to,
656     uint256 _tokenId,
657     bytes _data
658   )
659     internal
660     returns (bool)
661   {
662     if (!_to.isContract()) {
663       return true;
664     }
665     bytes4 retval = ERC721Receiver(_to).onERC721Received(
666       msg.sender, _from, _tokenId, _data);
667     return (retval == ERC721_RECEIVED);
668   }
669 }
670 
671 
672 /**
673  * @title Full ERC721 Token
674  * This implementation includes all the required and some optional functionality of the ERC721 standard
675  * Moreover, it includes approve all functionality using operator terminology
676  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
677  */
678 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
679 
680   // Token name
681   string internal name_;
682 
683   // Token symbol
684   string internal symbol_;
685 
686   // Mapping from owner to list of owned token IDs
687   mapping(address => uint256[]) internal ownedTokens;
688 
689   // Mapping from token ID to index of the owner tokens list
690   mapping(uint256 => uint256) internal ownedTokensIndex;
691 
692   // Array with all token ids, used for enumeration
693   uint256[] internal allTokens;
694 
695   // Mapping from token id to position in the allTokens array
696   mapping(uint256 => uint256) internal allTokensIndex;
697 
698   // Optional mapping for token URIs
699   mapping(uint256 => string) internal tokenURIs;
700 
701   /**
702    * @dev Constructor function
703    */
704   constructor(string _name, string _symbol) public {
705     name_ = _name;
706     symbol_ = _symbol;
707 
708     // register the supported interfaces to conform to ERC721 via ERC165
709     _registerInterface(InterfaceId_ERC721Enumerable);
710     _registerInterface(InterfaceId_ERC721Metadata);
711   }
712 
713   /**
714    * @dev Gets the token name
715    * @return string representing the token name
716    */
717   function name() external view returns (string) {
718     return name_;
719   }
720 
721   /**
722    * @dev Gets the token symbol
723    * @return string representing the token symbol
724    */
725   function symbol() external view returns (string) {
726     return symbol_;
727   }
728 
729   /**
730    * @dev Returns an URI for a given token ID
731    * Throws if the token ID does not exist. May return an empty string.
732    * @param _tokenId uint256 ID of the token to query
733    */
734   function tokenURI(uint256 _tokenId) public view returns (string) {
735     require(exists(_tokenId));
736     return tokenURIs[_tokenId];
737   }
738 
739   /**
740    * @dev Gets the token ID at a given index of the tokens list of the requested owner
741    * @param _owner address owning the tokens list to be accessed
742    * @param _index uint256 representing the index to be accessed of the requested tokens list
743    * @return uint256 token ID at the given index of the tokens list owned by the requested address
744    */
745   function tokenOfOwnerByIndex(
746     address _owner,
747     uint256 _index
748   )
749     public
750     view
751     returns (uint256)
752   {
753     require(_index < balanceOf(_owner));
754     return ownedTokens[_owner][_index];
755   }
756 
757   /**
758    * @dev Gets the total amount of tokens stored by the contract
759    * @return uint256 representing the total amount of tokens
760    */
761   function totalSupply() public view returns (uint256) {
762     return allTokens.length;
763   }
764 
765   /**
766    * @dev Gets the token ID at a given index of all the tokens in this contract
767    * Reverts if the index is greater or equal to the total number of tokens
768    * @param _index uint256 representing the index to be accessed of the tokens list
769    * @return uint256 token ID at the given index of the tokens list
770    */
771   function tokenByIndex(uint256 _index) public view returns (uint256) {
772     require(_index < totalSupply());
773     return allTokens[_index];
774   }
775 
776   /**
777    * @dev Internal function to set the token URI for a given token
778    * Reverts if the token ID does not exist
779    * @param _tokenId uint256 ID of the token to set its URI
780    * @param _uri string URI to assign
781    */
782   function _setTokenURI(uint256 _tokenId, string _uri) internal {
783     require(exists(_tokenId));
784     tokenURIs[_tokenId] = _uri;
785   }
786 
787   /**
788    * @dev Internal function to add a token ID to the list of a given address
789    * @param _to address representing the new owner of the given token ID
790    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
791    */
792   function addTokenTo(address _to, uint256 _tokenId) internal {
793     super.addTokenTo(_to, _tokenId);
794     uint256 length = ownedTokens[_to].length;
795     ownedTokens[_to].push(_tokenId);
796     ownedTokensIndex[_tokenId] = length;
797   }
798 
799   /**
800    * @dev Internal function to remove a token ID from the list of a given address
801    * @param _from address representing the previous owner of the given token ID
802    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
803    */
804   function removeTokenFrom(address _from, uint256 _tokenId) internal {
805     super.removeTokenFrom(_from, _tokenId);
806 
807     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
808     // then delete the last slot.
809     uint256 tokenIndex = ownedTokensIndex[_tokenId];
810     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
811     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
812 
813     ownedTokens[_from][tokenIndex] = lastToken;
814     // This also deletes the contents at the last position of the array
815     ownedTokens[_from].length--;
816 
817     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
818     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
819     // the lastToken to the first position, and then dropping the element placed in the last position of the list
820 
821     ownedTokensIndex[_tokenId] = 0;
822     ownedTokensIndex[lastToken] = tokenIndex;
823   }
824 
825   /**
826    * @dev Internal function to mint a new token
827    * Reverts if the given token ID already exists
828    * @param _to address the beneficiary that will own the minted token
829    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
830    */
831   function _mint(address _to, uint256 _tokenId) internal {
832     super._mint(_to, _tokenId);
833 
834     allTokensIndex[_tokenId] = allTokens.length;
835     allTokens.push(_tokenId);
836   }
837 
838   /**
839    * @dev Internal function to burn a specific token
840    * Reverts if the token does not exist
841    * @param _owner owner of the token to burn
842    * @param _tokenId uint256 ID of the token being burned by the msg.sender
843    */
844   function _burn(address _owner, uint256 _tokenId) internal {
845     super._burn(_owner, _tokenId);
846 
847     // Clear metadata (if any)
848     if (bytes(tokenURIs[_tokenId]).length != 0) {
849       delete tokenURIs[_tokenId];
850     }
851 
852     // Reorg all tokens array
853     uint256 tokenIndex = allTokensIndex[_tokenId];
854     uint256 lastTokenIndex = allTokens.length.sub(1);
855     uint256 lastToken = allTokens[lastTokenIndex];
856 
857     allTokens[tokenIndex] = lastToken;
858     allTokens[lastTokenIndex] = 0;
859 
860     allTokens.length--;
861     allTokensIndex[_tokenId] = 0;
862     allTokensIndex[lastToken] = tokenIndex;
863   }
864 
865 }
866 
867 contract ERC721Contract is ERC721Token, Ownable {
868   uint256 tokenCap;
869   constructor(string _name, string _symbol, uint256 _tokenCap) ERC721Token(_name, _symbol) public {
870     tokenCap = _tokenCap;
871   }
872   
873   modifier belowCap() {
874     require(totalSupply() < tokenCap);
875     _;
876   }
877 
878   function mintTo(address _to) public onlyOwner belowCap {
879     uint256 newTokenId = _getNextTokenId();
880     _mint(_to, newTokenId);
881   }
882 
883   function _getNextTokenId() private view returns (uint256) {
884     return totalSupply().add(1);
885   }
886 
887   function tokenURI(uint256 _tokenId) public view returns (string) {
888     return "https://snark-art-shameless-promo.herokuapp.com/";
889   }
890 }
891 
892 contract ShamelessPromoToken is ERC721Contract {
893   constructor() ERC721Contract("Shameless Promo Token", "SPT", 50) public {}
894 }