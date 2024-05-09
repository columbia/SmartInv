1 pragma solidity ^0.4.19;
2 
3 contract ERC721 {
4   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
5   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
6   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
7 
8   function balanceOf(address _owner) public view returns (uint256 _balance);
9   function ownerOf(uint256 _tokenId) public view returns (address _owner);
10   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) public;
11   function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
12   function transfer(address _to, uint256 _tokenId) external;
13   function transferFrom(address _from, address _to, uint256 _tokenId) public;
14   function approve(address _to, uint256 _tokenId) external;
15   function setApprovalForAll(address _to, bool _approved) external;
16   function getApproved(uint256 _tokenId) public view returns (address);
17   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
18 }
19 
20 interface ERC165 {
21     /// @notice Query if a contract implements an interface
22     /// @param interfaceID The interface identifier, as specified in ERC-165
23     /// @dev Interface identification is specified in ERC-165. This function
24     ///  uses less than 30,000 gas.
25     /// @return `true` if the contract implements `interfaceID` and
26     ///  `interfaceID` is not 0xffffffff, `false` otherwise
27     function supportsInterface(bytes4 interfaceID) external view returns (bool);
28 }
29 
30 interface ERC721TokenReceiver {
31     /// @notice Handle the receipt of an NFT
32     /// @dev The ERC721 smart contract calls this function on the recipient
33     ///  after a `transfer`. This function MAY throw to revert and reject the
34     ///  transfer. This function MUST use 50,000 gas or less. Return of other
35     ///  than the magic value MUST result in the transaction being reverted.
36     ///  Note: the contract address is always the message sender.
37     /// @param _from The sending address
38     /// @param _tokenId The NFT identifier which is being transfered
39     /// @param _data Additional data with no specified format
40     /// @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
41     ///  unless throwing
42   function onERC721Received(address _from, uint256 _tokenId, bytes _data) external returns(bytes4);
43 }
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50 
51   /**
52   * @dev Multiplies two numbers, throws on overflow.
53   */
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers, truncating the quotient.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return c;
71   }
72 
73   /**
74   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75   */
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   /**
82   * @dev Adds two numbers, throws on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256) {
85     uint256 c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 }
90 
91 /**
92  * @title Ownable
93  * @dev The Ownable contract has an owner address, and provides basic authorization control
94  * functions, this simplifies the implementation of "user permissions".
95  */
96 contract Ownable {
97   address public owner;
98 
99 
100   event OwnershipRenounced(address indexed previousOwner);
101   event OwnershipTransferred(
102     address indexed previousOwner,
103     address indexed newOwner
104   );
105 
106 
107   /**
108    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
109    * account.
110    */
111   constructor() public {
112     owner = msg.sender;
113   }
114 
115   /**
116    * @dev Throws if called by any account other than the owner.
117    */
118   modifier onlyOwner() {
119     require(msg.sender == owner);
120     _;
121   }
122 
123   /**
124    * @dev Allows the current owner to transfer control of the contract to a newOwner.
125    * @param newOwner The address to transfer ownership to.
126    */
127   function transferOwnership(address newOwner) public onlyOwner {
128     require(newOwner != address(0));
129     emit OwnershipTransferred(owner, newOwner);
130     owner = newOwner;
131   }
132 
133   /**
134    * @dev Allows the current owner to relinquish control of the contract.
135    */
136   function renounceOwnership() public onlyOwner {
137     emit OwnershipRenounced(owner);
138     owner = address(0);
139   }
140 }
141 
142 library Strings {
143   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
144   function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
145       bytes memory _ba = bytes(_a);
146       bytes memory _bb = bytes(_b);
147       bytes memory _bc = bytes(_c);
148       bytes memory _bd = bytes(_d);
149       bytes memory _be = bytes(_e);
150       string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
151       bytes memory babcde = bytes(abcde);
152       uint k = 0;
153       for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
154       for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
155       for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
156       for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
157       for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
158       return string(babcde);
159     }
160 
161     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
162         return strConcat(_a, _b, _c, _d, "");
163     }
164 
165     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
166         return strConcat(_a, _b, _c, "", "");
167     }
168 
169     function strConcat(string _a, string _b) internal pure returns (string) {
170         return strConcat(_a, _b, "", "", "");
171     }
172 
173     function uint2str(uint i) internal pure returns (string) {
174         if (i == 0) return "0";
175         uint j = i;
176         uint len;
177         while (j != 0){
178             len++;
179             j /= 10;
180         }
181         bytes memory bstr = new bytes(len);
182         uint k = len - 1;
183         while (i != 0){
184             bstr[k--] = byte(48 + i % 10);
185             i /= 10;
186         }
187         return string(bstr);
188     }
189 }
190 
191 
192 /// @title ERC-721 Non-Fungible Token Standard, optional metadata extension
193 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
194 ///  Note: the ERC-165 identifier for this interface is 0x5b5e139f
195 interface ERC721Metadata /* is ERC721 */ {
196     /// @notice A descriptive name for a collection of NFTs in this contract
197     function name() external pure returns (string _name);
198 
199     /// @notice An abbreviated name for NFTs in this contract
200     function symbol() external pure returns (string _symbol);
201 
202     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
203     /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
204     ///  3986. The URI may point to a JSON file that conforms to the "ERC721
205     ///  Metadata JSON Schema".
206     function tokenURI(uint256 _tokenId) external view returns (string);
207 }
208 
209 contract ERC721SlimToken is Ownable, ERC721, ERC165, ERC721Metadata {
210   using SafeMath for uint256;
211 
212   string public constant NAME = "EtherLoot";
213   string public constant SYMBOL = "ETLT";
214   string public tokenMetadataBaseURI = "http://api.etherloot.moonshadowgames.com/tokenmetadata/";
215 
216   struct AddressAndTokenIndex {
217     address owner;
218     uint32 tokenIndex;
219   }
220 
221   mapping (uint256 => AddressAndTokenIndex) private tokenOwnerAndTokensIndex;
222 
223   mapping (address => uint256[]) private ownedTokens;
224 
225   mapping (uint256 => address) private tokenApprovals;
226 
227   mapping (address => mapping (address => bool)) private operatorApprovals;
228 
229   mapping (address => bool) private approvedContractAddresses;
230 
231   bool approvedContractsFinalized = false;
232 
233   function implementsERC721() external pure returns (bool) {
234     return true;
235   }
236 
237 
238 
239   function supportsInterface(
240     bytes4 interfaceID)
241     external view returns (bool)
242   {
243     return
244       interfaceID == this.supportsInterface.selector || // ERC165
245       interfaceID == 0x5b5e139f || // ERC721Metadata
246       interfaceID == 0x6466353c; // ERC-721
247   }
248 
249   function name() external pure returns (string) {
250     return NAME;
251   }
252 
253   function symbol() external pure returns (string) {
254     return SYMBOL;
255   }
256 
257   function setTokenMetadataBaseURI(string _tokenMetadataBaseURI) external onlyOwner {
258     tokenMetadataBaseURI = _tokenMetadataBaseURI;
259   }
260 
261   function tokenURI(uint256 tokenId)
262     external
263     view
264     returns (string infoUrl)
265   {
266     return Strings.strConcat(
267       tokenMetadataBaseURI,
268       Strings.uint2str(tokenId));
269   }
270 
271   /**
272   * @notice Guarantees msg.sender is owner of the given token
273   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
274   */
275   modifier onlyOwnerOf(uint256 _tokenId) {
276     require(ownerOf(_tokenId) == msg.sender, "not owner");
277     _;
278   }
279 
280   /**
281   * @notice Gets the balance of the specified address
282   * @param _owner address to query the balance of
283   * @return uint256 representing the amount owned by the passed address
284   */
285   function balanceOf(address _owner) public view returns (uint256) {
286     require(_owner != address(0), "null owner");
287     return ownedTokens[_owner].length;
288   }
289 
290   /**
291   * @notice Gets the list of tokens owned by a given address
292   * @param _owner address to query the tokens of
293   * @return uint256[] representing the list of tokens owned by the passed address
294   */
295   function tokensOf(address _owner) public view returns (uint256[]) {
296     return ownedTokens[_owner];
297   }
298 
299   /**
300   * @notice Enumerate NFTs assigned to an owner
301   * @dev Throws if `_index` >= `balanceOf(_owner)` or if
302   *  `_owner` is the zero address, representing invalid NFTs.
303   * @param _owner An address where we are interested in NFTs owned by them
304   * @param _index A counter less than `balanceOf(_owner)`
305   * @return The token identifier for the `_index`th NFT assigned to `_owner`,
306   */
307   function tokenOfOwnerByIndex(address _owner, uint256 _index)
308     external
309     view
310     returns (uint256 _tokenId)
311   {
312     require(_index < balanceOf(_owner), "invalid index");
313     return ownedTokens[_owner][_index];
314   }
315 
316   /**
317   * @notice Gets the owner of the specified token ID
318   * @param _tokenId uint256 ID of the token to query the owner of
319   * @return owner address currently marked as the owner of the given token ID
320   */
321   function ownerOf(uint256 _tokenId) public view returns (address) {
322     address _owner = tokenOwnerAndTokensIndex[_tokenId].owner;
323     require(_owner != address(0), "invalid owner");
324     return _owner;
325   }
326 
327   function exists(uint256 _tokenId) public view returns (bool) {
328     address _owner = tokenOwnerAndTokensIndex[_tokenId].owner;
329     return (_owner != address(0));
330   }
331 
332   /**
333    * @notice Gets the approved address to take ownership of a given token ID
334    * @param _tokenId uint256 ID of the token to query the approval of
335    * @return address currently approved to take ownership of the given token ID
336    */
337   function getApproved(uint256 _tokenId) public view returns (address) {
338     return tokenApprovals[_tokenId];
339   }
340 
341   /**
342    * @notice Tells whether the msg.sender is approved to transfer the given token ID or not
343    * Checks both for specific approval and operator approval
344    * @param _tokenId uint256 ID of the token to query the approval of
345    * @return bool whether transfer by msg.sender is approved for the given token ID or not
346    */
347   function isSenderApprovedFor(uint256 _tokenId) internal view returns (bool) {
348     return
349       ownerOf(_tokenId) == msg.sender ||
350       isSpecificallyApprovedFor(msg.sender, _tokenId) ||
351       isApprovedForAll(ownerOf(_tokenId), msg.sender);
352   }
353 
354   /**
355    * @notice Tells whether the msg.sender is approved for the given token ID or not
356    * @param _asker address of asking for approval
357    * @param _tokenId uint256 ID of the token to query the approval of
358    * @return bool whether the msg.sender is approved for the given token ID or not
359    */
360   function isSpecificallyApprovedFor(address _asker, uint256 _tokenId) internal view returns (bool) {
361     return getApproved(_tokenId) == _asker;
362   }
363 
364   /**
365    * @notice Tells whether an operator is approved by a given owner
366    * @param _owner owner address which you want to query the approval of
367    * @param _operator operator address which you want to query the approval of
368    * @return bool whether the given operator is approved by the given owner
369    */
370   function isApprovedForAll(address _owner, address _operator) public view returns (bool)
371   {
372     return operatorApprovals[_owner][_operator];
373   }
374 
375   /**
376   * @notice Transfers the ownership of a given token ID to another address
377   * @param _to address to receive the ownership of the given token ID
378   * @param _tokenId uint256 ID of the token to be transferred
379   */
380   function transfer(address _to, uint256 _tokenId)
381     external
382     onlyOwnerOf(_tokenId)
383   {
384     _clearApprovalAndTransfer(msg.sender, _to, _tokenId);
385   }
386 
387   /**
388   * @notice Approves another address to claim for the ownership of the given token ID
389   * @param _to address to be approved for the given token ID
390   * @param _tokenId uint256 ID of the token to be approved
391   */
392   function approve(address _to, uint256 _tokenId)
393     external
394     onlyOwnerOf(_tokenId)
395   {
396     address _owner = ownerOf(_tokenId);
397     require(_to != _owner, "already owns");
398     if (getApproved(_tokenId) != 0 || _to != 0) {
399       tokenApprovals[_tokenId] = _to;
400       emit Approval(_owner, _to, _tokenId);
401     }
402   }
403 
404   /**
405   * @notice Enable or disable approval for a third party ("operator") to manage all your assets
406   * @dev Emits the ApprovalForAll event
407   * @param _to Address to add to the set of authorized operators.
408   * @param _approved True if the operators is approved, false to revoke approval
409   */
410   function setApprovalForAll(address _to, bool _approved)
411     external
412   {
413     if(_approved) {
414       approveAll(_to);
415     } else {
416       disapproveAll(_to);
417     }
418   }
419 
420   /**
421   * @notice Approves another address to claim for the ownership of any tokens owned by this account
422   * @param _to address to be approved for the given token ID
423   */
424   function approveAll(address _to)
425     public
426   {
427     require(_to != msg.sender, "cant approve yourself");
428     require(_to != address(0), "invalid owner");
429     operatorApprovals[msg.sender][_to] = true;
430     emit ApprovalForAll(msg.sender, _to, true);
431   }
432 
433   /**
434   * @notice Removes approval for another address to claim for the ownership of any
435   *  tokens owned by this account.
436   * @dev Note that this only removes the operator approval and
437   *  does not clear any independent, specific approvals of token transfers to this address
438   * @param _to address to be disapproved for the given token ID
439   */
440   function disapproveAll(address _to)
441     public
442   {
443     require(_to != msg.sender, "cant unapprove yourself");
444     delete operatorApprovals[msg.sender][_to];
445     emit ApprovalForAll(msg.sender, _to, false);
446   }
447 
448   /**
449   * @notice Claims the ownership of a given token ID
450   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
451   */
452   function takeOwnership(uint256 _tokenId)
453    external
454   {
455     require(isSenderApprovedFor(_tokenId), "not approved");
456     _clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
457   }
458 
459   /**
460   * @notice Transfer a token owned by another address, for which the calling address has
461   *  previously been granted transfer approval by the owner.
462   * @param _from The address that owns the token
463   * @param _to The address that will take ownership of the token. Can be any address, including the caller
464   * @param _tokenId The ID of the token to be transferred
465   */
466   function transferFrom(
467     address _from,
468     address _to,
469     uint256 _tokenId
470   )
471     public
472   {
473     address tokenOwner = ownerOf(_tokenId);
474     require(isSenderApprovedFor(_tokenId) || 
475       (approvedContractAddresses[msg.sender] && tokenOwner == tx.origin), "not an approved sender");
476     require(tokenOwner == _from, "wrong owner");
477     _clearApprovalAndTransfer(ownerOf(_tokenId), _to, _tokenId);
478   }
479 
480   /**
481   * @notice Transfers the ownership of an NFT from one address to another address
482   * @dev Throws unless `msg.sender` is the current owner, an authorized
483   * operator, or the approved address for this NFT. Throws if `_from` is
484   * not the current owner. Throws if `_to` is the zero address. Throws if
485   * `_tokenId` is not a valid NFT. When transfer is complete, this function
486   * checks if `_to` is a smart contract (code size > 0). If so, it calls
487   * `onERC721Received` on `_to` and throws if the return value is not
488   * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
489   * @param _from The current owner of the NFT
490   * @param _to The new owner
491   * @param _tokenId The NFT to transfer
492   * @param _data Additional data with no specified format, sent in call to `_to`
493   */
494   function safeTransferFrom(
495     address _from,
496     address _to,
497     uint256 _tokenId,
498     bytes _data
499   )
500     public
501   {
502     require(_to != address(0), "invalid target address");
503     transferFrom(_from, _to, _tokenId);
504     if (_isContract(_to)) {
505       bytes4 tokenReceiverResponse = ERC721TokenReceiver(_to).onERC721Received.gas(50000)(
506         _from, _tokenId, _data
507       );
508       require(tokenReceiverResponse == bytes4(keccak256("onERC721Received(address,uint256,bytes)")), "invalid receiver respononse");
509     }
510   }
511 
512   /*
513    * @notice Transfers the ownership of an NFT from one address to another address
514    * @dev This works identically to the other function with an extra data parameter,
515    *  except this function just sets data to ""
516    * @param _from The current owner of the NFT
517    * @param _to The new owner
518    * @param _tokenId The NFT to transfer
519   */
520   function safeTransferFrom(
521     address _from,
522     address _to,
523     uint256 _tokenId
524   )
525     external
526   {
527     safeTransferFrom(_from, _to, _tokenId, "");
528   }
529 
530   /**
531   * @notice Approve a contract address for minting tokens and transferring tokens, when approved by the owner
532   * @param contractAddress The address that will be approved
533   */
534   function addApprovedContractAddress(address contractAddress) public onlyOwner
535   {
536     require(!approvedContractsFinalized);
537     approvedContractAddresses[contractAddress] = true;
538   }
539 
540   /**
541   * @notice Unapprove a contract address for minting tokens and transferring tokens
542   * @param contractAddress The address that will be unapproved
543   */
544   function removeApprovedContractAddress(address contractAddress) public onlyOwner
545   {
546     require(!approvedContractsFinalized);
547     approvedContractAddresses[contractAddress] = false;
548   }
549 
550   /**
551   * @notice Finalize the contract so it will be forever impossible to change the approved contracts list
552   */
553   function finalizeApprovedContracts() public onlyOwner {
554     approvedContractsFinalized = true;
555   }
556 
557   /**
558   * @notice Mint token function
559   * @param _to The address that will own the minted token
560   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
561   */
562   function mint(address _to, uint256 _tokenId) public {
563     require(
564       approvedContractAddresses[msg.sender] ||
565       msg.sender == owner, "minter not approved"
566     );
567     _mint(_to, _tokenId);
568   }
569 
570   /**
571   * @notice Mint token function
572   * @param _to The address that will own the minted token
573   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
574   */
575   function _mint(address _to, uint256 _tokenId) internal {
576     require(_to != address(0), "invalid target address");
577     require(tokenOwnerAndTokensIndex[_tokenId].owner == address(0), "token already exists");
578     _addToken(_to, _tokenId);
579     emit Transfer(0x0, _to, _tokenId);
580   }
581 
582   /**
583   * @notice Internal function to clear current approval and transfer the ownership of a given token ID
584   * @param _from address which you want to send tokens from
585   * @param _to address which you want to transfer the token to
586   * @param _tokenId uint256 ID of the token to be transferred
587   */
588   function _clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
589     require(_to != address(0), "invalid target address");
590     require(_to != ownerOf(_tokenId), "already owns");
591     require(ownerOf(_tokenId) == _from, "wrong owner");
592 
593     _clearApproval(_from, _tokenId);
594     _removeToken(_from, _tokenId);
595     _addToken(_to, _tokenId);
596     emit Transfer(_from, _to, _tokenId);
597   }
598 
599   /**
600   * @notice Internal function to clear current approval of a given token ID
601   * @param _tokenId uint256 ID of the token to be transferred
602   */
603   function _clearApproval(address _owner, uint256 _tokenId) private {
604     require(ownerOf(_tokenId) == _owner, "wrong owner");
605     if (tokenApprovals[_tokenId] != 0) {
606       tokenApprovals[_tokenId] = 0;
607       emit Approval(_owner, 0, _tokenId);
608     }
609   }
610 
611   /**
612   * @notice Internal function to add a token ID to the list of a given address
613   * @param _to address representing the new owner of the given token ID
614   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
615   */
616   function _addToken(address _to, uint256 _tokenId) private {
617     uint256 newTokenIndex = ownedTokens[_to].length;
618     ownedTokens[_to].push(_tokenId);
619 
620     // I don't expect anyone to own 4 billion tokens, but just in case...
621     require(newTokenIndex == uint256(uint32(newTokenIndex)), "overflow");
622 
623     tokenOwnerAndTokensIndex[_tokenId] = AddressAndTokenIndex({owner: _to, tokenIndex: uint32(newTokenIndex)});
624   }
625 
626   /**
627   * @notice Internal function to remove a token ID from the list of a given address
628   * @param _from address representing the previous owner of the given token ID
629   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
630   */
631   function _removeToken(address _from, uint256 _tokenId) private {
632     require(ownerOf(_tokenId) == _from, "wrong owner");
633 
634     uint256 tokenIndex = tokenOwnerAndTokensIndex[_tokenId].tokenIndex;
635     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
636     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
637 
638     ownedTokens[_from][tokenIndex] = lastToken;
639 
640     ownedTokens[_from].length--;
641     tokenOwnerAndTokensIndex[lastToken] = AddressAndTokenIndex({owner: _from, tokenIndex: uint32(tokenIndex)});
642   }
643 
644   function _isContract(address addr) internal view returns (bool) {
645     uint size;
646     assembly { size := extcodesize(addr) }
647     return size > 0;
648   }
649 }