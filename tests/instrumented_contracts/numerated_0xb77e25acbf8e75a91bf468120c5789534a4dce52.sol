1 pragma solidity ^0.4.21;
2 
3 // File: contracts/ERC165.sol
4 
5 interface ERC165 {
6   /// @notice Query if a contract implements an interface
7   /// @param interfaceID The interface identifier, as specified in ERC-165
8   /// @dev Interface identification is specified in ERC-165. This function
9   ///  uses less than 30,000 gas.
10   /// @return `true` if the contract implements `interfaceID` and
11   ///  `interfaceID` is not 0xffffffff, `false` otherwise
12   function supportsInterface(bytes4 interfaceID) external pure returns (bool);
13 }
14 
15 // File: contracts/ERC721Basic.sol
16 
17 /**
18  * @title ERC721 Non-Fungible Token Standard basic interface
19  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
20  */
21 contract ERC721Basic {
22   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
23   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
24   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
25 
26   function balanceOf(address _owner) public view returns (uint256 _balance);
27   function ownerOf(uint256 _tokenId) public view returns (address _owner);
28   function exists(uint256 _tokenId) public view returns (bool _exists);
29 
30   function approve(address _to, uint256 _tokenId) public;
31   function getApproved(uint256 _tokenId) public view returns (address _operator);
32 
33   function setApprovalForAll(address _operator, bool _approved) public;
34   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
35 
36   function transferFrom(address _from, address _to, uint256 _tokenId) public;
37   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
38   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public;
39 }
40 
41 // File: contracts/ERC721.sol
42 
43 /**
44  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
45  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
46  */
47 contract ERC721Enumerable is ERC721Basic {
48   function totalSupply() public view returns (uint256);
49   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
50   function tokenByIndex(uint256 _index) public view returns (uint256);
51 }
52 
53 /**
54  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
55  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
56  */
57 contract ERC721Metadata is ERC721Basic {
58   function name() public view returns (string _name);
59   function symbol() public view returns (string _symbol);
60   function tokenURI(uint256 _tokenId) public view returns (string);
61 }
62 
63 /**
64  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
65  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
66  */
67 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
68 }
69 
70 // File: contracts/ERC721Receiver.sol
71 
72 /**
73  * @title ERC721 token receiver interface
74  * @dev Interface for any contract that wants to support safeTransfers
75  *  from ERC721 asset contracts.
76  */
77 contract ERC721Receiver {
78   /**
79    * @dev Magic value to be returned upon successful reception of an NFT
80    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
81    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
82    */
83   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
84 
85   /**
86    * @notice Handle the receipt of an NFT
87    * @dev The ERC721 smart contract calls this function on the recipient
88    *  after a `safetransfer`. This function MAY throw to revert and reject the
89    *  transfer. This function MUST use 50,000 gas or less. Return of other
90    *  than the magic value MUST result in the transaction being reverted.
91    *  Note: the contract address is always the message sender.
92    * @param _from The sending address
93    * @param _tokenId The NFT identifier which is being transfered
94    * @param _data Additional data with no specified format
95    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
96    */
97   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
98 }
99 
100 // File: zeppelin-solidity/contracts/AddressUtils.sol
101 
102 /**
103  * Utility library of inline functions on addresses
104  */
105 library AddressUtils {
106 
107   /**
108    * Returns whether there is code in the target address
109    * @dev This function will return false if invoked during the constructor of a contract,
110    *  as the code is not actually created until after the constructor finishes.
111    * @param addr address address to check
112    * @return whether there is code in the target address
113    */
114   function isContract(address addr) internal view returns (bool) {
115     uint256 size;
116     assembly { size := extcodesize(addr) }
117     return size > 0;
118   }
119 
120 }
121 
122 // File: zeppelin-solidity/contracts/math/SafeMath.sol
123 
124 /**
125  * @title SafeMath
126  * @dev Math operations with safety checks that throw on error
127  */
128 library SafeMath {
129 
130   /**
131   * @dev Multiplies two numbers, throws on overflow.
132   */
133   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
134     if (a == 0) {
135       return 0;
136     }
137     uint256 c = a * b;
138     assert(c / a == b);
139     return c;
140   }
141 
142   /**
143   * @dev Integer division of two numbers, truncating the quotient.
144   */
145   function div(uint256 a, uint256 b) internal pure returns (uint256) {
146     // assert(b > 0); // Solidity automatically throws when dividing by 0
147     uint256 c = a / b;
148     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
149     return c;
150   }
151 
152   /**
153   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
154   */
155   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156     assert(b <= a);
157     return a - b;
158   }
159 
160   /**
161   * @dev Adds two numbers, throws on overflow.
162   */
163   function add(uint256 a, uint256 b) internal pure returns (uint256) {
164     uint256 c = a + b;
165     assert(c >= a);
166     return c;
167   }
168 }
169 
170 // File: contracts/ERC721BasicToken.sol
171 
172 /**
173  * @title ERC721 Non-Fungible Token Standard basic implementation
174  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
175  */
176 contract ERC721BasicToken is ERC721Basic {
177   using SafeMath for uint256;
178   using AddressUtils for address;
179 
180   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
181   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
182   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
183 
184   // Mapping from token ID to owner
185   mapping (uint256 => address) internal tokenOwner;
186 
187   // Mapping from token ID to approved address
188   mapping (uint256 => address) internal tokenApprovals;
189 
190   // Mapping from owner to number of owned token
191   mapping (address => uint256) internal ownedTokensCount;
192 
193   // Mapping from owner to operator approvals
194   mapping (address => mapping (address => bool)) internal operatorApprovals;
195 
196   /**
197   * @dev Guarantees msg.sender is owner of the given token
198   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
199   */
200   modifier onlyOwnerOf(uint256 _tokenId) {
201     require(ownerOf(_tokenId) == msg.sender);
202     _;
203   }
204 
205   /**
206   * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
207   * @param _tokenId uint256 ID of the token to validate
208   */
209   modifier canTransfer(uint256 _tokenId) {
210     require(isApprovedOrOwner(msg.sender, _tokenId));
211     _;
212   }
213 
214   /**
215   * @dev Gets the balance of the specified address
216   * @param _owner address to query the balance of
217   * @return uint256 representing the amount owned by the passed address
218   */
219   function balanceOf(address _owner) public view returns (uint256) {
220     require(_owner != address(0));
221     return ownedTokensCount[_owner];
222   }
223 
224   /**
225   * @dev Gets the owner of the specified token ID
226   * @param _tokenId uint256 ID of the token to query the owner of
227   * @return owner address currently marked as the owner of the given token ID
228   */
229   function ownerOf(uint256 _tokenId) public view returns (address) {
230     address owner = tokenOwner[_tokenId];
231     require(owner != address(0));
232     return owner;
233   }
234 
235   /**
236   * @dev Returns whether the specified token exists
237   * @param _tokenId uint256 ID of the token to query the existance of
238   * @return whether the token exists
239   */
240   function exists(uint256 _tokenId) public view returns (bool) {
241     address owner = tokenOwner[_tokenId];
242     return owner != address(0);
243   }
244 
245   /**
246   * @dev Approves another address to transfer the given token ID
247   * @dev The zero address indicates there is no approved address.
248   * @dev There can only be one approved address per token at a given time.
249   * @dev Can only be called by the token owner or an approved operator.
250   * @param _to address to be approved for the given token ID
251   * @param _tokenId uint256 ID of the token to be approved
252   */
253   function approve(address _to, uint256 _tokenId) public {
254     address owner = ownerOf(_tokenId);
255     require(_to != owner);
256     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
257 
258     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
259       tokenApprovals[_tokenId] = _to;
260       Approval(owner, _to, _tokenId);
261     }
262   }
263 
264   /**
265    * @dev Gets the approved address for a token ID, or zero if no address set
266    * @param _tokenId uint256 ID of the token to query the approval of
267    * @return address currently approved for a the given token ID
268    */
269   function getApproved(uint256 _tokenId) public view returns (address) {
270     return tokenApprovals[_tokenId];
271   }
272 
273 
274   /**
275   * @dev Sets or unsets the approval of a given operator
276   * @dev An operator is allowed to transfer all tokens of the sender on their behalf
277   * @param _to operator address to set the approval
278   * @param _approved representing the status of the approval to be set
279   */
280   function setApprovalForAll(address _to, bool _approved) public {
281     require(_to != msg.sender);
282     operatorApprovals[msg.sender][_to] = _approved;
283     ApprovalForAll(msg.sender, _to, _approved);
284   }
285 
286   /**
287    * @dev Tells whether an operator is approved by a given owner
288    * @param _owner owner address which you want to query the approval of
289    * @param _operator operator address which you want to query the approval of
290    * @return bool whether the given operator is approved by the given owner
291    */
292   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
293     return operatorApprovals[_owner][_operator];
294   }
295 
296   /**
297   * @dev Transfers the ownership of a given token ID to another address
298   * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
299   * @dev Requires the msg sender to be the owner, approved, or operator
300   * @param _from current owner of the token
301   * @param _to address to receive the ownership of the given token ID
302   * @param _tokenId uint256 ID of the token to be transferred
303   */
304   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
305     require(_from != address(0));
306     require(_to != address(0));
307 
308     clearApproval(_from, _tokenId);
309     removeTokenFrom(_from, _tokenId);
310     addTokenTo(_to, _tokenId);
311 
312     Transfer(_from, _to, _tokenId);
313   }
314 
315   /**
316   * @dev Safely transfers the ownership of a given token ID to another address
317   * @dev If the target address is a contract, it must implement `onERC721Received`,
318   *  which is called upon a safe transfer, and return the magic value
319   *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
320   *  the transfer is reverted.
321   * @dev Requires the msg sender to be the owner, approved, or operator
322   * @param _from current owner of the token
323   * @param _to address to receive the ownership of the given token ID
324   * @param _tokenId uint256 ID of the token to be transferred
325   */
326   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
327     safeTransferFrom(_from, _to, _tokenId, "");
328   }
329 
330   /**
331   * @dev Safely transfers the ownership of a given token ID to another address
332   * @dev If the target address is a contract, it must implement `onERC721Received`,
333   *  which is called upon a safe transfer, and return the magic value
334   *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
335   *  the transfer is reverted.
336   * @dev Requires the msg sender to be the owner, approved, or operator
337   * @param _from current owner of the token
338   * @param _to address to receive the ownership of the given token ID
339   * @param _tokenId uint256 ID of the token to be transferred
340   * @param _data bytes data to send along with a safe transfer check
341   */
342   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public canTransfer(_tokenId) {
343     transferFrom(_from, _to, _tokenId);
344     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
345   }
346 
347   /**
348    * @dev Returns whether the given spender can transfer a given token ID
349    * @param _spender address of the spender to query
350    * @param _tokenId uint256 ID of the token to be transferred
351    * @return bool whether the msg.sender is approved for the given token ID,
352    *  is an operator of the owner, or is the owner of the token
353    */
354   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
355     address owner = ownerOf(_tokenId);
356     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
357   }
358 
359   /**
360   * @dev Internal function to mint a new token
361   * @dev Reverts if the given token ID already exists
362   * @param _to The address that will own the minted token
363   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
364   */
365   function _mint(address _to, uint256 _tokenId) internal {
366     require(_to != address(0));
367     addTokenTo(_to, _tokenId);
368     Transfer(address(0), _to, _tokenId);
369   }
370 
371   /**
372   * @dev Internal function to burn a specific token
373   * @dev Reverts if the token does not exist
374   * @param _tokenId uint256 ID of the token being burned by the msg.sender
375   */
376   function _burn(address _owner, uint256 _tokenId) internal {
377     clearApproval(_owner, _tokenId);
378     removeTokenFrom(_owner, _tokenId);
379     Transfer(_owner, address(0), _tokenId);
380   }
381 
382   /**
383   * @dev Internal function to clear current approval of a given token ID
384   * @dev Reverts if the given address is not indeed the owner of the token
385   * @param _owner owner of the token
386   * @param _tokenId uint256 ID of the token to be transferred
387   */
388   function clearApproval(address _owner, uint256 _tokenId) internal {
389     require(ownerOf(_tokenId) == _owner);
390     if (tokenApprovals[_tokenId] != address(0)) {
391       tokenApprovals[_tokenId] = address(0);
392       Approval(_owner, address(0), _tokenId);
393     }
394   }
395 
396   /**
397   * @dev Internal function to add a token ID to the list of a given address
398   * @param _to address representing the new owner of the given token ID
399   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
400   */
401   function addTokenTo(address _to, uint256 _tokenId) internal {
402     require(tokenOwner[_tokenId] == address(0));
403     tokenOwner[_tokenId] = _to;
404     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
405   }
406 
407   /**
408   * @dev Internal function to remove a token ID from the list of a given address
409   * @param _from address representing the previous owner of the given token ID
410   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
411   */
412   function removeTokenFrom(address _from, uint256 _tokenId) internal {
413     require(ownerOf(_tokenId) == _from);
414     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
415     tokenOwner[_tokenId] = address(0);
416   }
417 
418   /**
419   * @dev Internal function to invoke `onERC721Received` on a target address
420   * @dev The call is not executed if the target address is not a contract
421   * @param _from address representing the previous owner of the given token ID
422   * @param _to target address that will receive the tokens
423   * @param _tokenId uint256 ID of the token to be transferred
424   * @param _data bytes optional data to send along with the call
425   * @return whether the call correctly returned the expected magic value
426   */
427   function checkAndCallSafeTransfer(address _from, address _to, uint256 _tokenId, bytes _data) internal returns (bool) {
428     if (!_to.isContract()) {
429       return true;
430     }
431     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
432     return (retval == ERC721_RECEIVED);
433   }
434 }
435 
436 // File: contracts/ERC721Token.sol
437 
438 /**
439  * @title Full ERC721 Token
440  * This implementation includes all the required and some optional functionality of the ERC721 standard
441  * Moreover, it includes approve all functionality using operator terminology
442  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
443  */
444 contract ERC721Token is ERC721, ERC721BasicToken {
445   // Token name
446   string internal name_;
447 
448   // Token symbol
449   string internal symbol_;
450 
451   // Mapping from owner to list of owned token IDs
452   mapping (address => uint256[]) internal ownedTokens;
453 
454   // Mapping from token ID to index of the owner tokens list
455   mapping(uint256 => uint256) internal ownedTokensIndex;
456 
457   // Array with all token ids, used for enumeration
458   uint256[] internal allTokens;
459 
460   // Mapping from token id to position in the allTokens array
461   mapping(uint256 => uint256) internal allTokensIndex;
462 
463   // Optional mapping for token URIs
464   mapping(uint256 => string) internal tokenURIs;
465 
466   /**
467   * @dev Constructor function
468   */
469   function ERC721Token(string _name, string _symbol) public {
470     name_ = _name;
471     symbol_ = _symbol;
472   }
473 
474   /**
475   * @dev Gets the token name
476   * @return string representing the token name
477   */
478   function name() public view returns (string) {
479     return name_;
480   }
481 
482   /**
483   * @dev Gets the token symbol
484   * @return string representing the token symbol
485   */
486   function symbol() public view returns (string) {
487     return symbol_;
488   }
489 
490   /**
491   * @dev Returns an URI for a given token ID
492   * @dev Throws if the token ID does not exist. May return an empty string.
493   * @param _tokenId uint256 ID of the token to query
494   */
495   function tokenURI(uint256 _tokenId) public view returns (string) {
496     require(exists(_tokenId));
497     return tokenURIs[_tokenId];
498   }
499 
500   /**
501   * @dev Internal function to set the token URI for a given token
502   * @dev Reverts if the token ID does not exist
503   * @param _tokenId uint256 ID of the token to set its URI
504   * @param _uri string URI to assign
505   */
506   function _setTokenURI(uint256 _tokenId, string _uri) internal {
507     require(exists(_tokenId));
508     tokenURIs[_tokenId] = _uri;
509   }
510 
511   /**
512   * @dev Gets the token ID at a given index of the tokens list of the requested owner
513   * @param _owner address owning the tokens list to be accessed
514   * @param _index uint256 representing the index to be accessed of the requested tokens list
515   * @return uint256 token ID at the given index of the tokens list owned by the requested address
516   */
517   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
518     require(_index < balanceOf(_owner));
519     return ownedTokens[_owner][_index];
520   }
521 
522   /**
523   * @dev Gets the total amount of tokens stored by the contract
524   * @return uint256 representing the total amount of tokens
525   */
526   function totalSupply() public view returns (uint256) {
527     return allTokens.length;
528   }
529 
530   /**
531   * @dev Gets the token ID at a given index of all the tokens in this contract
532   * @dev Reverts if the index is greater or equal to the total number of tokens
533   * @param _index uint256 representing the index to be accessed of the tokens list
534   * @return uint256 token ID at the given index of the tokens list
535   */
536   function tokenByIndex(uint256 _index) public view returns (uint256) {
537     require(_index < totalSupply());
538     return allTokens[_index];
539   }
540 
541   /**
542   * @dev Internal function to add a token ID to the list of a given address
543   * @param _to address representing the new owner of the given token ID
544   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
545   */
546   function addTokenTo(address _to, uint256 _tokenId) internal {
547     super.addTokenTo(_to, _tokenId);
548     uint256 length = ownedTokens[_to].length;
549     ownedTokens[_to].push(_tokenId);
550     ownedTokensIndex[_tokenId] = length;
551   }
552 
553   /**
554   * @dev Internal function to remove a token ID from the list of a given address
555   * @param _from address representing the previous owner of the given token ID
556   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
557   */
558   function removeTokenFrom(address _from, uint256 _tokenId) internal {
559     super.removeTokenFrom(_from, _tokenId);
560 
561     uint256 tokenIndex = ownedTokensIndex[_tokenId];
562     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
563     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
564 
565     ownedTokens[_from][tokenIndex] = lastToken;
566     ownedTokens[_from][lastTokenIndex] = 0;
567     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
568     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
569     // the lastToken to the first position, and then dropping the element placed in the last position of the list
570 
571     ownedTokens[_from].length--;
572     ownedTokensIndex[_tokenId] = 0;
573     ownedTokensIndex[lastToken] = tokenIndex;
574   }
575 
576   /**
577   * @dev Internal function to mint a new token
578   * @dev Reverts if the given token ID already exists
579   * @param _to address the beneficiary that will own the minted token
580   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
581   */
582   function _mint(address _to, uint256 _tokenId) internal {
583     super._mint(_to, _tokenId);
584 
585     allTokensIndex[_tokenId] = allTokens.length;
586     allTokens.push(_tokenId);
587   }
588 
589   /**
590   * @dev Internal function to burn a specific token
591   * @dev Reverts if the token does not exist
592   * @param _owner owner of the token to burn
593   * @param _tokenId uint256 ID of the token being burned by the msg.sender
594   */
595   function _burn(address _owner, uint256 _tokenId) internal {
596     super._burn(_owner, _tokenId);
597 
598     // Clear metadata (if any)
599     if (bytes(tokenURIs[_tokenId]).length != 0) {
600       delete tokenURIs[_tokenId];
601     }
602 
603     // Reorg all tokens array
604     uint256 tokenIndex = allTokensIndex[_tokenId];
605     uint256 lastTokenIndex = allTokens.length.sub(1);
606     uint256 lastToken = allTokens[lastTokenIndex];
607 
608     allTokens[tokenIndex] = lastToken;
609     allTokens[lastTokenIndex] = 0;
610 
611     allTokens.length--;
612     allTokensIndex[_tokenId] = 0;
613     allTokensIndex[lastToken] = tokenIndex;
614   }
615 
616 }
617 
618 // File: contracts/Strings.sol
619 
620 library Strings {
621   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
622   function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
623     bytes memory _ba = bytes(_a);
624     bytes memory _bb = bytes(_b);
625     bytes memory _bc = bytes(_c);
626     bytes memory _bd = bytes(_d);
627     bytes memory _be = bytes(_e);
628     string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
629     bytes memory babcde = bytes(abcde);
630     uint k = 0;
631     for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
632     for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
633     for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
634     for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
635     for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
636     return string(babcde);
637   }
638 
639   function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
640     return strConcat(_a, _b, _c, _d, "");
641   }
642 
643   function strConcat(string _a, string _b, string _c) internal pure returns (string) {
644     return strConcat(_a, _b, _c, "", "");
645   }
646 
647   function strConcat(string _a, string _b) internal pure returns (string) {
648     return strConcat(_a, _b, "", "", "");
649   }
650 
651   function bytes16ToStr(bytes16 _bytes16, uint8 _start, uint8 _end) internal pure returns (string) {
652     bytes memory bytesArray = new bytes(_end - _start);
653     uint8 pos = 0;
654     for (uint8 i = _start; i < _end; i++) {
655       bytesArray[pos] = _bytes16[i];
656       pos++;
657     }
658     return string(bytesArray);
659   }
660 }
661 
662 // File: contracts/KnownOriginDigitalAsset.sol
663 
664 /**
665 * @title KnownOriginDigitalAsset
666 *
667 * http://www.knownorigin.io/
668 *
669 * ERC721 compliant digital assets for real-world artwork.
670 * BE ORIGINAL. BUY ORIGINAL.
671 *
672 */
673 contract KnownOriginDigitalAsset is ERC721Token, ERC165 {
674   using SafeMath for uint256;
675 
676   bytes4 constant InterfaceSignature_ERC165 = 0x01ffc9a7;
677     /*
678     bytes4(keccak256('supportsInterface(bytes4)'));
679     */
680 
681   bytes4 constant InterfaceSignature_ERC721Enumerable = 0x780e9d63;
682     /*
683     bytes4(keccak256('totalSupply()')) ^
684     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
685     bytes4(keccak256('tokenByIndex(uint256)'));
686     */
687 
688   bytes4 constant InterfaceSignature_ERC721Metadata = 0x5b5e139f;
689     /*
690     bytes4(keccak256('name()')) ^
691     bytes4(keccak256('symbol()')) ^
692     bytes4(keccak256('tokenURI(uint256)'));
693     */
694 
695   bytes4 constant InterfaceSignature_ERC721 = 0x80ac58cd;
696     /*
697     bytes4(keccak256('balanceOf(address)')) ^
698     bytes4(keccak256('ownerOf(uint256)')) ^
699     bytes4(keccak256('approve(address,uint256)')) ^
700     bytes4(keccak256('getApproved(uint256)')) ^
701     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
702     bytes4(keccak256('isApprovedForAll(address,address)')) ^
703     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
704     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
705     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'));
706     */
707 
708   bytes4 public constant InterfaceSignature_ERC721Optional =- 0x4f558e79;
709     /*
710     bytes4(keccak256('exists(uint256)'));
711     */
712 
713   /**
714    * @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
715    * @dev Returns true for any standardized interfaces implemented by this contract.
716    * @param _interfaceID bytes4 the interface to check for
717    * @return true for any standardized interfaces implemented by this contract.
718    */
719   function supportsInterface(bytes4 _interfaceID) external pure returns (bool) {
720     return ((_interfaceID == InterfaceSignature_ERC165)
721     || (_interfaceID == InterfaceSignature_ERC721)
722     || (_interfaceID == InterfaceSignature_ERC721Optional)
723     || (_interfaceID == InterfaceSignature_ERC721Enumerable)
724     || (_interfaceID == InterfaceSignature_ERC721Metadata));
725   }
726 
727   struct CommissionStructure {
728     uint8 curator;
729     uint8 developer;
730   }
731 
732   string internal tokenBaseURI = "https://ipfs.infura.io/ipfs/";
733 
734   // creates and owns the original assets all primary purchases transferred to this account
735   address public curatorAccount;
736 
737   // the person who is responsible for designing and building the contract
738   address public developerAccount;
739 
740   // total wei been processed through the contract
741   uint256 public totalPurchaseValueInWei;
742 
743   // number of assets sold of any type
744   uint256 public totalNumberOfPurchases;
745 
746   // A pointer to the next token to be minted, zero indexed
747   uint256 public tokenIdPointer = 0;
748 
749   enum PurchaseState {Unsold, EtherPurchase, FiatPurchase}
750 
751   mapping(string => CommissionStructure) internal editionTypeToCommission;
752   mapping(uint256 => PurchaseState) internal tokenIdToPurchased;
753 
754   mapping(uint256 => bytes16) internal tokenIdToEdition;
755   mapping(uint256 => uint256) internal tokenIdToPriceInWei;
756   mapping(uint256 => uint32) internal tokenIdToPurchaseFromTime;
757 
758   mapping(bytes16 => uint256) internal editionToEditionNumber;
759   mapping(bytes16 => address) internal editionToArtistAccount;
760 
761   event PurchasedWithEther(uint256 indexed _tokenId, address indexed _buyer);
762 
763   event PurchasedWithFiat(uint256 indexed _tokenId);
764 
765   event PurchasedWithFiatReversed(uint256 indexed _tokenId);
766 
767   modifier onlyCurator() {
768     require(msg.sender == curatorAccount);
769     _;
770   }
771 
772   modifier onlyUnsold(uint256 _tokenId) {
773     require(tokenIdToPurchased[_tokenId] == PurchaseState.Unsold);
774     _;
775   }
776 
777   modifier onlyFiatPurchased(uint256 _tokenId) {
778     require(tokenIdToPurchased[_tokenId] == PurchaseState.FiatPurchase);
779     _;
780   }
781 
782   modifier onlyKnownOriginOwnedToken(uint256 _tokenId) {
783     require(tokenOwner[_tokenId] == curatorAccount || tokenOwner[_tokenId] == developerAccount);
784     _;
785   }
786 
787   modifier onlyKnownOrigin() {
788     require(msg.sender == curatorAccount || msg.sender == developerAccount);
789     _;
790   }
791 
792   modifier onlyAfterPurchaseFromTime(uint256 _tokenId) {
793     require(tokenIdToPurchaseFromTime[_tokenId] <= block.timestamp);
794     _;
795   }
796 
797 
798   function KnownOriginDigitalAsset(address _curatorAccount) public ERC721Token("KnownOriginDigitalAsset", "KODA") {
799     developerAccount = msg.sender;
800     curatorAccount = _curatorAccount;
801   }
802 
803   // don't accept payment directly to contract
804   function() public payable {
805     revert();
806   }
807 
808   /**
809    * @dev Mint a new KODA token
810    * @dev Reverts if not called by management
811    * @param _tokenURI the IPFS or equivalent hash
812    * @param _edition the identifier of the edition - leading 3 bytes are the artist code, trailing 3 bytes are the asset type
813    * @param _priceInWei the price of the KODA token
814    * @param _auctionStartDate the date when the token is available for sale
815    */
816   function mint(string _tokenURI, bytes16 _edition, uint256 _priceInWei, uint32 _auctionStartDate, address _artistAccount) external onlyKnownOrigin {
817     require(_artistAccount != address(0));
818 
819     uint256 _tokenId = tokenIdPointer;
820 
821     super._mint(msg.sender, _tokenId);
822     super._setTokenURI(_tokenId, _tokenURI);
823 
824     editionToArtistAccount[_edition] = _artistAccount;
825 
826     _populateTokenData(_tokenId, _edition, _priceInWei, _auctionStartDate);
827 
828     tokenIdPointer = tokenIdPointer.add(1);
829   }
830 
831   function _populateTokenData(uint _tokenId, bytes16 _edition, uint256 _priceInWei, uint32 _purchaseFromTime) internal {
832     tokenIdToEdition[_tokenId] = _edition;
833     editionToEditionNumber[_edition] = editionToEditionNumber[_edition].add(1);
834     tokenIdToPriceInWei[_tokenId] = _priceInWei;
835     tokenIdToPurchaseFromTime[_tokenId] = _purchaseFromTime;
836   }
837 
838   /**
839    * @dev Burns a KODA token
840    * @dev Reverts if token is not unsold or not owned by management
841    * @param _tokenId the KODA token ID
842    */
843   function burn(uint256 _tokenId) public onlyKnownOrigin onlyUnsold(_tokenId) onlyKnownOriginOwnedToken(_tokenId) {
844     require(exists(_tokenId));
845     super._burn(ownerOf(_tokenId), _tokenId);
846 
847     bytes16 edition = tokenIdToEdition[_tokenId];
848 
849     delete tokenIdToEdition[_tokenId];
850     delete tokenIdToPriceInWei[_tokenId];
851     delete tokenIdToPurchaseFromTime[_tokenId];
852 
853     editionToEditionNumber[edition] = editionToEditionNumber[edition].sub(1);
854   }
855 
856   /**
857    * @dev Utility function for updating a KODA assets token URI
858    * @dev Reverts if not called by management
859    * @param _tokenId the KODA token ID
860    * @param _uri the token URI, will be concatenated with baseUri
861    */
862   function setTokenURI(uint256 _tokenId, string _uri) external onlyKnownOrigin {
863     require(exists(_tokenId));
864     _setTokenURI(_tokenId, _uri);
865   }
866 
867   /**
868    * @dev Utility function for updating a KODA assets price
869    * @dev Reverts if token is not unsold or not called by management
870    * @param _tokenId the KODA token ID
871    * @param _priceInWei the price in wei
872    */
873   function setPriceInWei(uint _tokenId, uint256 _priceInWei) external onlyKnownOrigin onlyUnsold(_tokenId) {
874     require(exists(_tokenId));
875     tokenIdToPriceInWei[_tokenId] = _priceInWei;
876   }
877 
878   /**
879    * @dev Used to pre-approve a purchaser in order for internal purchase methods
880    * to succeed without calling approve() directly
881    * @param _tokenId the KODA token ID
882    * @return address currently approved for a the given token ID
883    */
884   function _approvePurchaser(address _to, uint256 _tokenId) internal {
885     address owner = ownerOf(_tokenId);
886     require(_to != address(0));
887 
888     tokenApprovals[_tokenId] = _to;
889     Approval(owner, _to, _tokenId);
890   }
891 
892   /**
893    * @dev Updates the commission structure for the given _type
894    * @dev Reverts if not called by management
895    * @param _type the asset type
896    * @param _curator the curators commission
897    * @param _developer the developers commission
898    */
899   function updateCommission(string _type, uint8 _curator, uint8 _developer) external onlyKnownOrigin {
900     require(_curator > 0);
901     require(_developer > 0);
902     require((_curator + _developer) < 100);
903 
904     editionTypeToCommission[_type] = CommissionStructure({curator : _curator, developer : _developer});
905   }
906 
907   /**
908    * @dev Utility function for retrieving the commission structure for the provided _type
909    * @param _type the asset type
910    * @return the commission structure or zero for both values when not found
911    */
912   function getCommissionForType(string _type) public view returns (uint8 _curator, uint8 _developer) {
913     CommissionStructure storage commission = editionTypeToCommission[_type];
914     return (commission.curator, commission.developer);
915   }
916 
917   /**
918    * @dev Purchase the provide token in Ether
919    * @dev Reverts if token not unsold and not available to be purchased
920    * msg.sender will become the owner of the token
921    * msg.value needs to be >= to the token priceInWei
922    * @param _tokenId the KODA token ID
923    * @return true/false depending on success
924    */
925   function purchaseWithEther(uint256 _tokenId) public payable onlyUnsold(_tokenId) onlyKnownOriginOwnedToken(_tokenId) onlyAfterPurchaseFromTime(_tokenId) {
926     require(exists(_tokenId));
927 
928     uint256 priceInWei = tokenIdToPriceInWei[_tokenId];
929     require(msg.value >= priceInWei);
930 
931     // approve sender as they have paid the required amount
932     _approvePurchaser(msg.sender, _tokenId);
933 
934     // transfer assets from contract creator (curator) to new owner
935     safeTransferFrom(curatorAccount, msg.sender, _tokenId);
936 
937     // now purchased - don't allow re-purchase!
938     tokenIdToPurchased[_tokenId] = PurchaseState.EtherPurchase;
939 
940     totalPurchaseValueInWei = totalPurchaseValueInWei.add(msg.value);
941     totalNumberOfPurchases = totalNumberOfPurchases.add(1);
942 
943     // Only apply commission if the art work has value
944     if (priceInWei > 0) {
945       _applyCommission(_tokenId);
946     }
947 
948     PurchasedWithEther(_tokenId, msg.sender);
949   }
950 
951   /**
952    * @dev Purchase the provide token in FIAT, management command only for taking fiat payments during KODA physical exhibitions
953    * Equivalent to taking the KODA token off the market and marking as sold
954    * @dev Reverts if token not unsold and not available to be purchased and not called by management
955    * @param _tokenId the KODA token ID
956    */
957   function purchaseWithFiat(uint256 _tokenId) public onlyKnownOrigin onlyUnsold(_tokenId) onlyAfterPurchaseFromTime(_tokenId) {
958     require(exists(_tokenId));
959 
960     // now purchased - don't allow re-purchase!
961     tokenIdToPurchased[_tokenId] = PurchaseState.FiatPurchase;
962 
963     totalNumberOfPurchases = totalNumberOfPurchases.add(1);
964 
965     PurchasedWithFiat(_tokenId);
966   }
967 
968   /**
969    * @dev Reverse a fiat purchase made by calling purchaseWithFiat()
970    * @dev Reverts if token not purchased with fiat and not available to be purchased and not called by management
971    * @param _tokenId the KODA token ID
972    */
973   function reverseFiatPurchase(uint256 _tokenId) public onlyKnownOrigin onlyFiatPurchased(_tokenId) onlyAfterPurchaseFromTime(_tokenId) {
974     require(exists(_tokenId));
975 
976     // reset to Unsold
977     tokenIdToPurchased[_tokenId] = PurchaseState.Unsold;
978 
979     totalNumberOfPurchases = totalNumberOfPurchases.sub(1);
980 
981     PurchasedWithFiatReversed(_tokenId);
982   }
983 
984   /**
985    * @dev Internal function for apply commission on purchase
986    */
987   function _applyCommission(uint256 _tokenId) internal {
988     bytes16 edition = tokenIdToEdition[_tokenId];
989 
990     string memory typeCode = getTypeFromEdition(edition);
991 
992     CommissionStructure memory commission = editionTypeToCommission[typeCode];
993 
994     // split & transfer fee for curator
995     uint curatorAccountFee = msg.value / 100 * commission.curator;
996     curatorAccount.transfer(curatorAccountFee);
997 
998     // split & transfer fee for developer
999     uint developerAccountFee = msg.value / 100 * commission.developer;
1000     developerAccount.transfer(developerAccountFee);
1001 
1002     // final payment to commission would be the remaining value
1003     uint finalCommissionTotal = msg.value - (curatorAccountFee + developerAccountFee);
1004 
1005     // send ether
1006     address artistAccount = editionToArtistAccount[edition];
1007     artistAccount.transfer(finalCommissionTotal);
1008   }
1009 
1010   /**
1011    * @dev Retrieve all asset information for the provided token
1012    * @param _tokenId the KODA token ID
1013    * @return tokenId, owner, purchaseState, priceInWei, purchaseFromDateTime
1014    */
1015   function assetInfo(uint _tokenId) public view returns (
1016     uint256 _tokId,
1017     address _owner,
1018     PurchaseState _purchaseState,
1019     uint256 _priceInWei,
1020     uint32 _purchaseFromTime
1021   ) {
1022     return (
1023       _tokenId,
1024       tokenOwner[_tokenId],
1025       tokenIdToPurchased[_tokenId],
1026       tokenIdToPriceInWei[_tokenId],
1027       tokenIdToPurchaseFromTime[_tokenId]
1028     );
1029   }
1030 
1031   /**
1032    * @dev Retrieve all edition information for the provided token
1033    * @param _tokenId the KODA token ID
1034    * @return tokenId, edition, editionNumber, tokenUri
1035    */
1036   function editionInfo(uint256 _tokenId) public view returns (
1037     uint256 _tokId,
1038     bytes16 _edition,
1039     uint256 _editionNumber,
1040     string _tokenURI,
1041     address _artistAccount
1042   ) {
1043     bytes16 edition = tokenIdToEdition[_tokenId];
1044     return (
1045       _tokenId,
1046       edition,
1047       editionToEditionNumber[edition],
1048       tokenURI(_tokenId),
1049       editionToArtistAccount[edition]
1050     );
1051   }
1052 
1053   function tokensOf(address _owner) public view returns (uint256[] _tokenIds) {
1054     return ownedTokens[_owner];
1055   }
1056 
1057   /**
1058    * @dev Return the total number of assets in an edition
1059    * @param _edition the edition identifier
1060    */
1061   function numberOf(bytes16 _edition) public view returns (uint256) {
1062     return editionToEditionNumber[_edition];
1063   }
1064 
1065   /**
1066    * @dev Get the token purchase state for the given token
1067    * @param _tokenId the KODA token ID
1068    * @return the purchase sate, either 0, 1, 2, reverts if token not found
1069    */
1070   function isPurchased(uint256 _tokenId) public view returns (PurchaseState _purchased) {
1071     require(exists(_tokenId));
1072     return tokenIdToPurchased[_tokenId];
1073   }
1074 
1075   /**
1076    * @dev Get the edition identifier for the given token
1077    * @param _tokenId the KODA token ID
1078    * @return the edition is found, reverts if token not found
1079    */
1080   function editionOf(uint256 _tokenId) public view returns (bytes16 _edition) {
1081     require(exists(_tokenId));
1082     return tokenIdToEdition[_tokenId];
1083   }
1084 
1085   /**
1086    * @dev Get the purchase from time for the given token
1087    * @param _tokenId the KODA token ID
1088    * @return the purchased from time, reverts if token not found
1089    */
1090   function purchaseFromTime(uint256 _tokenId) public view returns (uint32 _purchaseFromTime) {
1091     require(exists(_tokenId));
1092     return tokenIdToPurchaseFromTime[_tokenId];
1093   }
1094 
1095   /**
1096    * @dev Get the price in wei for the given token
1097    * @param _tokenId the KODA token ID
1098    * @return the price in wei, reverts if token not found
1099    */
1100   function priceInWei(uint256 _tokenId) public view returns (uint256 _priceInWei) {
1101     require(exists(_tokenId));
1102     return tokenIdToPriceInWei[_tokenId];
1103   }
1104 
1105   /**
1106    * @dev Get the type for the provided edition, useful for testing purposes
1107    * @param _edition the edition identifier
1108    * @return the type or blank string
1109    */
1110   function getTypeFromEdition(bytes16 _edition) public pure returns (string) {
1111     // return last 3 chars that represent the edition type
1112     return Strings.bytes16ToStr(_edition, 13, 16);
1113   }
1114 
1115   /**
1116    * @dev Get token URI fro the given token, useful for testing purposes
1117    * @param _tokenId the KODA token ID
1118    * @return the token ID or only the base URI if not found
1119    */
1120   function tokenURI(uint256 _tokenId) public view returns (string) {
1121     return Strings.strConcat(tokenBaseURI, tokenURIs[_tokenId]);
1122   }
1123 
1124   /**
1125    * @dev Allows management to update the base tokenURI path
1126    * @dev Reverts if not called by management
1127    * @param _newBaseURI the new base URI to set
1128    */
1129   function setTokenBaseURI(string _newBaseURI) external onlyKnownOrigin {
1130     tokenBaseURI = _newBaseURI;
1131   }
1132 
1133   /**
1134    * @dev Allows management to update the artist account (where commission is sent)
1135    * @dev Reverts if not called by management
1136    * @param _edition edition to adjust
1137     * @param _artistAccount address of artist on blockchain
1138    */
1139   function setArtistAccount(bytes16 _edition, address _artistAccount) external onlyKnownOrigin {
1140     require(_artistAccount != address(0));
1141 
1142     editionToArtistAccount[_edition] = _artistAccount;
1143   }
1144 }