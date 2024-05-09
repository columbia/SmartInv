1 /**
2  * @title Math
3  * @dev Assorted math operations
4  */
5 library Math {
6   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
7     return a >= b ? a : b;
8   }
9 
10   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
11     return a < b ? a : b;
12   }
13 
14   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
15     return a >= b ? a : b;
16   }
17 
18   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
19     return a < b ? a : b;
20   }
21 }
22 
23 
24 
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that throw on error
28  */
29 library SafeMath {
30 
31   /**
32   * @dev Multiplies two numbers, throws on overflow.
33   */
34   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35     if (a == 0) {
36       return 0;
37     }
38     uint256 c = a * b;
39     assert(c / a == b);
40     return c;
41   }
42 
43   /**
44   * @dev Integer division of two numbers, truncating the quotient.
45   */
46   function div(uint256 a, uint256 b) internal pure returns (uint256) {
47     // assert(b > 0); // Solidity automatically throws when dividing by 0
48     // uint256 c = a / b;
49     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50     return a / b;
51   }
52 
53   /**
54   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
55   */
56   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57     assert(b <= a);
58     return a - b;
59   }
60 
61   /**
62   * @dev Adds two numbers, throws on overflow.
63   */
64   function add(uint256 a, uint256 b) internal pure returns (uint256) {
65     uint256 c = a + b;
66     assert(c >= a);
67     return c;
68   }
69 }
70 
71 
72 /**
73  * @title Ownable
74  * @dev The Ownable contract has an owner address, and provides basic authorization control
75  * functions, this simplifies the implementation of "user permissions".
76  */
77 contract Ownable {
78   address public owner;
79 
80   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82   /**
83    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
84    * account.
85    */
86   function Ownable() public {
87     owner = msg.sender;
88   }
89 
90   /**
91    * @dev Throws if called by any account other than the owner.
92    */
93   modifier onlyOwner() {
94     require(msg.sender == owner);
95     _;
96   }
97 
98   /**
99    * @dev Allows the current owner to transfer control of the contract to a newOwner.
100    * @param newOwner The address to transfer ownership to.
101    */
102   function transferOwnership(address newOwner) public onlyOwner {
103     require(newOwner != address(0));
104     emit OwnershipTransferred(owner, newOwner);
105     owner = newOwner;
106   }
107 
108 }
109 
110 
111 contract ExternalInterface {
112   function giveItem(address _recipient, uint256 _traits) external;
113 
114   function giveMultipleItems(address _recipient, uint256[] _traits) external;
115 
116   function giveMultipleItemsToMultipleRecipients(address[] _recipients, uint256[] _traits) external;
117 
118   function giveMultipleItemsAndDestroyMultipleItems(address _recipient, uint256[] _traits, uint256[] _tokenIds) external;
119   
120   function destroyItem(uint256 _tokenId) external;
121 
122   function destroyMultipleItems(uint256[] _tokenIds) external;
123 
124   function updateItemTraits(uint256 _tokenId, uint256 _traits) external;
125 }
126 
127 
128 
129 contract LootboxInterface {
130   event LootboxPurchased(address indexed owner, address indexed storeAddress, uint16 displayValue);
131   
132   function buy(address _buyer) external;
133 }
134 
135 
136 /// @title ERC-165 Standard Interface Detection
137 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
138 interface ERC165 {
139     function supportsInterface(bytes4 interfaceID) external view returns (bool);
140 }
141 
142 
143 
144 /**
145  * @title ERC721 Non-Fungible Token Standard basic interface
146  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
147  */
148 contract ERC721Basic {
149   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
150   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
151   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
152 
153   function balanceOf(address _owner) public view returns (uint256 _balance);
154   function ownerOf(uint256 _tokenId) public view returns (address _owner);
155   function exists(uint256 _tokenId) public view returns (bool _exists);
156 
157   function approve(address _to, uint256 _tokenId) public;
158   function getApproved(uint256 _tokenId) public view returns (address _operator);
159 
160   function setApprovalForAll(address _operator, bool _approved) public;
161   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
162 
163   function transferFrom(address _from, address _to, uint256 _tokenId) public;
164   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
165   function safeTransferFrom(
166     address _from,
167     address _to,
168     uint256 _tokenId,
169     bytes _data
170   )
171     public;
172 }
173 
174 
175 /**
176  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
177  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
178  */
179 contract ERC721Enumerable is ERC721Basic {
180   function totalSupply() public view returns (uint256);
181   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
182   function tokenByIndex(uint256 _index) public view returns (uint256);
183   function tokensOf(address _owner) public view returns (uint256[]);
184 }
185 
186 /**
187  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
188  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
189  */
190 contract ERC721 is ERC721Basic, ERC721Enumerable {
191 }
192 
193 
194 
195 /**
196  * @title ERC721 Non-Fungible Token Standard basic implementation
197  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
198  */
199 contract ERC721BasicToken is ERC721Basic {
200   using SafeMath for uint256;
201   using AddressUtils for address;
202 
203   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
204   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
205   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
206 
207   // Mapping from token ID to owner
208   mapping (uint256 => address) internal tokenOwner;
209 
210   // Mapping from token ID to approved address
211   mapping (uint256 => address) internal tokenApprovals;
212 
213   // Mapping from owner to number of owned token
214   mapping (address => uint256) internal ownedTokensCount;
215 
216   // Mapping from owner to operator approvals
217   mapping (address => mapping (address => bool)) internal operatorApprovals;
218 
219   /**
220   * @dev Guarantees msg.sender is owner of the given token
221   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
222   */
223   modifier onlyOwnerOf(uint256 _tokenId) {
224     require(ownerOf(_tokenId) == msg.sender);
225     _;
226   }
227 
228   /**
229   * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
230   * @param _tokenId uint256 ID of the token to validate
231   */
232   modifier canTransfer(uint256 _tokenId) {
233     require(isApprovedOrOwner(msg.sender, _tokenId));
234     _;
235   }
236 
237   /**
238   * @dev Gets the balance of the specified address
239   * @param _owner address to query the balance of
240   * @return uint256 representing the amount owned by the passed address
241   */
242   function balanceOf(address _owner) public view returns (uint256) {
243     require(_owner != address(0));
244     return ownedTokensCount[_owner];
245   }
246 
247   /**
248   * @dev Gets the owner of the specified token ID
249   * @param _tokenId uint256 ID of the token to query the owner of
250   * @return owner address currently marked as the owner of the given token ID
251   */
252   function ownerOf(uint256 _tokenId) public view returns (address) {
253     address owner = tokenOwner[_tokenId];
254     require(owner != address(0));
255     return owner;
256   }
257 
258   /**
259   * @dev Returns whether the specified token exists
260   * @param _tokenId uint256 ID of the token to query the existance of
261   * @return whether the token exists
262   */
263   function exists(uint256 _tokenId) public view returns (bool) {
264     address owner = tokenOwner[_tokenId];
265     return owner != address(0);
266   }
267 
268   /**
269   * @dev Approves another address to transfer the given token ID
270   * @dev The zero address indicates there is no approved address.
271   * @dev There can only be one approved address per token at a given time.
272   * @dev Can only be called by the token owner or an approved operator.
273   * @param _to address to be approved for the given token ID
274   * @param _tokenId uint256 ID of the token to be approved
275   */
276   function approve(address _to, uint256 _tokenId) public {
277     address owner = ownerOf(_tokenId);
278     require(_to != owner);
279     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
280 
281     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
282       tokenApprovals[_tokenId] = _to;
283       emit Approval(owner, _to, _tokenId);
284     }
285   }
286 
287   /**
288    * @dev Gets the approved address for a token ID, or zero if no address set
289    * @param _tokenId uint256 ID of the token to query the approval of
290    * @return address currently approved for a the given token ID
291    */
292   function getApproved(uint256 _tokenId) public view returns (address) {
293     return tokenApprovals[_tokenId];
294   }
295 
296   /**
297   * @dev Sets or unsets the approval of a given operator
298   * @dev An operator is allowed to transfer all tokens of the sender on their behalf
299   * @param _to operator address to set the approval
300   * @param _approved representing the status of the approval to be set
301   */
302   function setApprovalForAll(address _to, bool _approved) public {
303     require(_to != msg.sender);
304     operatorApprovals[msg.sender][_to] = _approved;
305     emit ApprovalForAll(msg.sender, _to, _approved);
306   }
307 
308   /**
309    * @dev Tells whether an operator is approved by a given owner
310    * @param _owner owner address which you want to query the approval of
311    * @param _operator operator address which you want to query the approval of
312    * @return bool whether the given operator is approved by the given owner
313    */
314   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
315     return operatorApprovals[_owner][_operator];
316   }
317 
318   /**
319   * @dev Transfers the ownership of a given token ID to another address
320   * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
321   * @dev Requires the msg sender to be the owner, approved, or operator
322   * @param _from current owner of the token
323   * @param _to address to receive the ownership of the given token ID
324   * @param _tokenId uint256 ID of the token to be transferred
325   */
326   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
327     require(_from != address(0));
328     require(_to != address(0));
329 
330     clearApproval(_from, _tokenId);
331     removeTokenFrom(_from, _tokenId);
332     addTokenTo(_to, _tokenId);
333 
334     emit Transfer(_from, _to, _tokenId);
335   }
336 
337   /**
338   * @dev Safely transfers the ownership of a given token ID to another address
339   * @dev If the target address is a contract, it must implement `onERC721Received`,
340   *  which is called upon a safe transfer, and return the magic value
341   *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
342   *  the transfer is reverted.
343   * @dev Requires the msg sender to be the owner, approved, or operator
344   * @param _from current owner of the token
345   * @param _to address to receive the ownership of the given token ID
346   * @param _tokenId uint256 ID of the token to be transferred
347   */
348   function safeTransferFrom(
349     address _from,
350     address _to,
351     uint256 _tokenId
352   )
353     public
354     canTransfer(_tokenId)
355   {
356     safeTransferFrom(_from, _to, _tokenId, "");
357   }
358 
359   /**
360   * @dev Safely transfers the ownership of a given token ID to another address
361   * @dev If the target address is a contract, it must implement `onERC721Received`,
362   *  which is called upon a safe transfer, and return the magic value
363   *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
364   *  the transfer is reverted.
365   * @dev Requires the msg sender to be the owner, approved, or operator
366   * @param _from current owner of the token
367   * @param _to address to receive the ownership of the given token ID
368   * @param _tokenId uint256 ID of the token to be transferred
369   * @param _data bytes data to send along with a safe transfer check
370   */
371   function safeTransferFrom(
372     address _from,
373     address _to,
374     uint256 _tokenId,
375     bytes _data
376   )
377     public
378     canTransfer(_tokenId)
379   {
380     transferFrom(_from, _to, _tokenId);
381     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
382   }
383 
384   /**
385    * @dev Returns whether the given spender can transfer a given token ID
386    * @param _spender address of the spender to query
387    * @param _tokenId uint256 ID of the token to be transferred
388    * @return bool whether the msg.sender is approved for the given token ID,
389    *  is an operator of the owner, or is the owner of the token
390    */
391   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
392     address owner = ownerOf(_tokenId);
393     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
394   }
395 
396   /**
397   * @dev Internal function to mint a new token
398   * @dev Reverts if the given token ID already exists
399   * @param _to The address that will own the minted token
400   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
401   */
402   function _mint(address _to, uint256 _tokenId) internal {
403     require(_to != address(0));
404     addTokenTo(_to, _tokenId);
405     emit Transfer(address(0), _to, _tokenId);
406   }
407 
408   /**
409   * @dev Internal function to burn a specific token
410   * @dev Reverts if the token does not exist
411   * @param _tokenId uint256 ID of the token being burned by the msg.sender
412   */
413   function _burn(address _owner, uint256 _tokenId) internal {
414     clearApproval(_owner, _tokenId);
415     removeTokenFrom(_owner, _tokenId);
416     emit Transfer(_owner, address(0), _tokenId);
417   }
418 
419   /**
420   * @dev Internal function to clear current approval of a given token ID
421   * @dev Reverts if the given address is not indeed the owner of the token
422   * @param _owner owner of the token
423   * @param _tokenId uint256 ID of the token to be transferred
424   */
425   function clearApproval(address _owner, uint256 _tokenId) internal {
426     require(ownerOf(_tokenId) == _owner);
427     if (tokenApprovals[_tokenId] != address(0)) {
428       tokenApprovals[_tokenId] = address(0);
429       emit Approval(_owner, address(0), _tokenId);
430     }
431   }
432 
433   /**
434   * @dev Internal function to add a token ID to the list of a given address
435   * @param _to address representing the new owner of the given token ID
436   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
437   */
438   function addTokenTo(address _to, uint256 _tokenId) internal {
439     require(tokenOwner[_tokenId] == address(0));
440     tokenOwner[_tokenId] = _to;
441     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
442   }
443 
444   /**
445   * @dev Internal function to remove a token ID from the list of a given address
446   * @param _from address representing the previous owner of the given token ID
447   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
448   */
449   function removeTokenFrom(address _from, uint256 _tokenId) internal {
450     require(ownerOf(_tokenId) == _from);
451     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
452     tokenOwner[_tokenId] = address(0);
453   }
454 
455   /**
456   * @dev Internal function to invoke `onERC721Received` on a target address
457   * @dev The call is not executed if the target address is not a contract
458   * @param _from address representing the previous owner of the given token ID
459   * @param _to target address that will receive the tokens
460   * @param _tokenId uint256 ID of the token to be transferred
461   * @param _data bytes optional data to send along with the call
462   * @return whether the call correctly returned the expected magic value
463   */
464   function checkAndCallSafeTransfer(
465     address _from,
466     address _to,
467     uint256 _tokenId,
468     bytes _data
469   )
470     internal
471     returns (bool)
472   {
473     if (!_to.isContract()) {
474       return true;
475     }
476     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
477     return (retval == ERC721_RECEIVED);
478   }
479 }
480 
481 
482 /**
483  * @title ERC721 token receiver interface
484  * @dev Interface for any contract that wants to support safeTransfers
485  *  from ERC721 asset contracts.
486  */
487 contract ERC721Receiver {
488   /**
489    * @dev Magic value to be returned upon successful reception of an NFT
490    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
491    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
492    */
493   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
494 
495   /**
496    * @notice Handle the receipt of an NFT
497    * @dev The ERC721 smart contract calls this function on the recipient
498    *  after a `safetransfer`. This function MAY throw to revert and reject the
499    *  transfer. This function MUST use 50,000 gas or less. Return of other
500    *  than the magic value MUST result in the transaction being reverted.
501    *  Note: the contract address is always the message sender.
502    * @param _from The sending address
503    * @param _tokenId The NFT identifier which is being transfered
504    * @param _data Additional data with no specified format
505    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
506    */
507   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
508 }
509 
510 
511 
512 /**
513  * @title Full ERC721 Token
514  * This implementation includes all the required and some optional functionality of the ERC721 standard
515  * Moreover, it includes approve all functionality using operator terminology
516  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
517  */
518 contract ERC721Token is ERC721, ERC721BasicToken, ERC165 {
519   // Mapping from owner to list of owned token IDs
520   mapping (address => uint256[]) internal ownedTokens;
521 
522   // Mapping from token ID to index of the owner tokens list
523   mapping(uint256 => uint256) internal ownedTokensIndex;
524 
525   // Array with all token ids, used for enumeration
526   uint256[] internal allTokens;
527 
528   // Mapping from token id to position in the allTokens array
529   mapping(uint256 => uint256) internal allTokensIndex;
530 
531   /**
532   * @dev Gets the token ID at a given index of the tokens list of the requested owner
533   * @param _owner address owning the tokens list to be accessed
534   * @param _index uint256 representing the index to be accessed of the requested tokens list
535   * @return uint256 token ID at the given index of the tokens list owned by the requested address
536   */
537   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
538     require(_index < balanceOf(_owner));
539     return ownedTokens[_owner][_index];
540   }
541   
542   /**
543   * @dev Gets the list of tokens owned by a requested address
544   * @param _owner address to query the tokens of
545   * @return uint256[] representing the list of tokens owned by the requested address
546   */
547   function tokensOf(address _owner) public view returns (uint256[]) {
548     return ownedTokens[_owner];
549   }
550 
551   /**
552   * @dev Gets the total amount of tokens stored by the contract
553   * @return uint256 representing the total amount of tokens
554   */
555   function totalSupply() public view returns (uint256) {
556     return allTokens.length;
557   }
558 
559   /**
560   * @dev Gets the token ID at a given index of all the tokens in this contract
561   * @dev Reverts if the index is greater or equal to the total number of tokens
562   * @param _index uint256 representing the index to be accessed of the tokens list
563   * @return uint256 token ID at the given index of the tokens list
564   */
565   function tokenByIndex(uint256 _index) public view returns (uint256) {
566     require(_index < totalSupply());
567     return allTokens[_index];
568   }
569 
570   /**
571   * @dev Internal function to add a token ID to the list of a given address
572   * @param _to address representing the new owner of the given token ID
573   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
574   */
575   function addTokenTo(address _to, uint256 _tokenId) internal {
576     super.addTokenTo(_to, _tokenId);
577     uint256 length = ownedTokens[_to].length;
578     ownedTokens[_to].push(_tokenId);
579     ownedTokensIndex[_tokenId] = length;
580   }
581 
582   /**
583   * @dev Internal function to remove a token ID from the list of a given address
584   * @param _from address representing the previous owner of the given token ID
585   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
586   */
587   function removeTokenFrom(address _from, uint256 _tokenId) internal {
588     super.removeTokenFrom(_from, _tokenId);
589 
590     uint256 tokenIndex = ownedTokensIndex[_tokenId];
591     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
592     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
593 
594     ownedTokens[_from][tokenIndex] = lastToken;
595     ownedTokens[_from][lastTokenIndex] = 0;
596     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
597     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
598     // the lastToken to the first position, and then dropping the element placed in the last position of the list
599 
600     ownedTokens[_from].length--;
601     ownedTokensIndex[_tokenId] = 0;
602     ownedTokensIndex[lastToken] = tokenIndex;
603   }
604 
605   /**
606   * @dev Internal function to mint a new token
607   * @dev Reverts if the given token ID already exists
608   * @param _to address the beneficiary that will own the minted token
609   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
610   */
611   function _mint(address _to, uint256 _tokenId) internal {
612     super._mint(_to, _tokenId);
613 
614     allTokensIndex[_tokenId] = allTokens.length;
615     allTokens.push(_tokenId);
616   }
617 
618   /**
619   * @dev Internal function to burn a specific token
620   * @dev Reverts if the token does not exist
621   * @param _owner owner of the token to burn
622   * @param _tokenId uint256 ID of the token being burned by the msg.sender
623   */
624   function _burn(address _owner, uint256 _tokenId) internal {
625     super._burn(_owner, _tokenId);
626 
627     // Reorg all tokens array
628     uint256 tokenIndex = allTokensIndex[_tokenId];
629     uint256 lastTokenIndex = allTokens.length.sub(1);
630     uint256 lastToken = allTokens[lastTokenIndex];
631 
632     allTokens[tokenIndex] = lastToken;
633     allTokens[lastTokenIndex] = 0;
634 
635     allTokens.length--;
636     allTokensIndex[_tokenId] = 0;
637     allTokensIndex[lastToken] = tokenIndex;
638   }
639 
640   /**
641   * @dev Query if a contract implements an interface
642   * @param _interfaceID interfaceID being checked
643   * @return bool if the current contract supports the queried interface
644   */
645   function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
646     return _interfaceID == 0x01ffc9a7 || // ERC165
647            _interfaceID == 0x80ac58cd || // ERC721
648            _interfaceID == 0x780e9d63; // ERC721Enumerable
649   }
650 }
651 
652 
653 
654 
655 /**
656  * Utility library of inline functions on addresses
657  */
658 library AddressUtils {
659 
660   /**
661    * Returns whether the target address is a contract
662    * @dev This function will return false if invoked during the constructor of a contract,
663    *  as the code is not actually created until after the constructor finishes.
664    * @param addr address to check
665    * @return whether the target address is a contract
666    */
667   function isContract(address addr) internal view returns (bool) {
668     uint256 size;
669     // XXX Currently there is no better way to check if there is a contract in an address
670     // than to check the size of the code at that address.
671     // See https://ethereum.stackexchange.com/a/14016/36603
672     // for more details about how this works.
673     // TODO Check this again before the Serenity release, because all addresses will be
674     // contracts then.
675     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
676     return size > 0;
677   }
678 
679 }
680 
681 
682 contract Base is ERC721Token, Ownable {
683 
684   event NewCRLToken(address indexed owner, uint256 indexed tokenId, uint256 traits);
685   event UpdatedCRLToken(uint256 indexed UUID, uint256 indexed tokenId, uint256 traits);
686 
687   uint256 TOKEN_UUID;
688   uint256 UPGRADE_UUID;
689 
690   function _createToken(address _owner, uint256 _traits) internal {
691     // emit the creaton event
692     emit NewCRLToken(
693       _owner,
694       TOKEN_UUID,
695       _traits
696     );
697 
698     // This will assign ownership, and also emit the Transfer event
699     _mint(_owner, TOKEN_UUID);
700 
701     TOKEN_UUID++;
702   }
703 
704   function _updateToken(uint256 _tokenId, uint256 _traits) internal {
705     // emit the upgrade event
706     emit UpdatedCRLToken(
707       UPGRADE_UUID,
708       _tokenId,
709       _traits
710     );
711 
712     UPGRADE_UUID++;
713   }
714 
715   // Eth balance controls
716 
717   // We can withdraw eth balance of contract.
718   function withdrawBalance() onlyOwner external {
719     require(address(this).balance > 0);
720 
721     msg.sender.transfer(address(this).balance);
722   }
723 }
724 
725 
726 
727 contract LootboxStore is Base {
728   // mapping between specific Lootbox contract address to price in wei
729   mapping(address => uint256) ethPricedLootboxes;
730 
731   // mapping between specific Lootbox contract address to price in NOS tokens
732   mapping(uint256 => uint256) NOSPackages;
733 
734   uint256 UUID;
735 
736   event NOSPurchased(uint256 indexed UUID, address indexed owner, uint256 indexed NOSAmtPurchased);
737 
738   function addLootbox(address _lootboxAddress, uint256 _price) external onlyOwner {
739     ethPricedLootboxes[_lootboxAddress] = _price;
740   }
741 
742   function removeLootbox(address _lootboxAddress) external onlyOwner {
743     delete ethPricedLootboxes[_lootboxAddress];
744   }
745 
746   function buyEthLootbox(address _lootboxAddress) payable external {
747     // Verify the given lootbox contract exists and they've paid enough
748     require(ethPricedLootboxes[_lootboxAddress] != 0);
749     require(msg.value >= ethPricedLootboxes[_lootboxAddress]);
750 
751     LootboxInterface(_lootboxAddress).buy(msg.sender);
752   }
753 
754   function addNOSPackage(uint256 _NOSAmt, uint256 _ethPrice) external onlyOwner {
755     NOSPackages[_NOSAmt] = _ethPrice;
756   }
757   
758   function removeNOSPackage(uint256 _NOSAmt) external onlyOwner {
759     delete NOSPackages[_NOSAmt];
760   }
761 
762   function buyNOS(uint256 _NOSAmt) payable external {
763     require(NOSPackages[_NOSAmt] != 0);
764     require(msg.value >= NOSPackages[_NOSAmt]);
765     
766     emit NOSPurchased(UUID, msg.sender, _NOSAmt);
767     UUID++;
768   }
769 }
770 
771 contract Core is LootboxStore, ExternalInterface {
772   mapping(address => uint256) authorizedExternal;
773 
774   function addAuthorizedExternal(address _address) external onlyOwner {
775     authorizedExternal[_address] = 1;
776   }
777 
778   function removeAuthorizedExternal(address _address) external onlyOwner {
779     delete authorizedExternal[_address];
780   }
781 
782   // Verify the caller of this function is a Lootbox contract or race, or crafting, or upgrade
783   modifier onlyAuthorized() { 
784     require(ethPricedLootboxes[msg.sender] != 0 ||
785             authorizedExternal[msg.sender] != 0);
786       _; 
787   }
788 
789   function giveItem(address _recipient, uint256 _traits) onlyAuthorized external {
790     _createToken(_recipient, _traits);
791   }
792 
793   function giveMultipleItems(address _recipient, uint256[] _traits) onlyAuthorized external {
794     for (uint i = 0; i < _traits.length; ++i) {
795       _createToken(_recipient, _traits[i]);
796     }
797   }
798 
799   function giveMultipleItemsToMultipleRecipients(address[] _recipients, uint256[] _traits) onlyAuthorized external {
800     require(_recipients.length == _traits.length);
801 
802     for (uint i = 0; i < _traits.length; ++i) {
803       _createToken(_recipients[i], _traits[i]);
804     }
805   }
806 
807   function giveMultipleItemsAndDestroyMultipleItems(address _recipient, uint256[] _traits, uint256[] _tokenIds) onlyAuthorized external {
808     for (uint i = 0; i < _traits.length; ++i) {
809       _createToken(_recipient, _traits[i]);
810     }
811 
812     for (i = 0; i < _tokenIds.length; ++i) {
813       _burn(ownerOf(_tokenIds[i]), _tokenIds[i]);
814     }
815   }
816 
817   function destroyItem(uint256 _tokenId) onlyAuthorized external {
818     _burn(ownerOf(_tokenId), _tokenId);
819   }
820 
821   function destroyMultipleItems(uint256[] _tokenIds) onlyAuthorized external {
822     for (uint i = 0; i < _tokenIds.length; ++i) {
823       _burn(ownerOf(_tokenIds[i]), _tokenIds[i]);
824     }
825   }
826 
827   function updateItemTraits(uint256 _tokenId, uint256 _traits) onlyAuthorized external {
828     _updateToken(_tokenId, _traits);
829   }
830 }