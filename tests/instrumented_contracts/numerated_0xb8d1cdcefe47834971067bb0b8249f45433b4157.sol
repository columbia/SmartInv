1 pragma solidity ^0.4.13;
2 
3 library AddressUtils {
4 
5   /**
6    * Returns whether there is code in the target address
7    * @dev This function will return false if invoked during the constructor of a contract,
8    *  as the code is not actually created until after the constructor finishes.
9    * @param addr address address to check
10    * @return whether there is code in the target address
11    */
12   function isContract(address addr) internal view returns (bool) {
13     uint256 size;
14     assembly { size := extcodesize(addr) }
15     return size > 0;
16   }
17 
18 }
19 
20 library SafeMath {
21 
22   /**
23   * @dev Multiplies two numbers, throws on overflow.
24   */
25   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26     if (a == 0) {
27       return 0;
28     }
29     uint256 c = a * b;
30     assert(c / a == b);
31     return c;
32   }
33 
34   /**
35   * @dev Integer division of two numbers, truncating the quotient.
36   */
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42   }
43 
44   /**
45   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
46   */
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   /**
53   * @dev Adds two numbers, throws on overflow.
54   */
55   function add(uint256 a, uint256 b) internal pure returns (uint256) {
56     uint256 c = a + b;
57     assert(c >= a);
58     return c;
59   }
60 }
61 
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   function Ownable() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to transfer control of the contract to a newOwner.
87    * @param newOwner The address to transfer ownership to.
88    */
89   function transferOwnership(address newOwner) public onlyOwner {
90     require(newOwner != address(0));
91     OwnershipTransferred(owner, newOwner);
92     owner = newOwner;
93   }
94 
95 }
96 
97 contract ERC721Basic {
98   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
99   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
100   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);  
101 
102   function balanceOf(address _owner) public view returns (uint256 _balance);
103   function ownerOf(uint256 _tokenId) public view returns (address _owner);
104   function exists(uint256 _tokenId) public view returns (bool _exists);
105   
106   function approve(address _to, uint256 _tokenId) public;
107   function getApproved(uint256 _tokenId) public view returns (address _operator);
108   
109   function setApprovalForAll(address _operator, bool _approved) public;
110   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
111 
112   function transferFrom(address _from, address _to, uint256 _tokenId) public;
113   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;  
114   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public;
115 }
116 
117 contract ERC721Enumerable is ERC721Basic {
118   function totalSupply() public view returns (uint256);
119   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
120   function tokenByIndex(uint256 _index) public view returns (uint256);
121 }
122 
123 contract ERC721Metadata is ERC721Basic {
124   function name() public view returns (string _name);
125   function symbol() public view returns (string _symbol);
126   function tokenURI(uint256 _tokenId) public view returns (string);
127 }
128 
129 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
130 }
131 
132 contract DeprecatedERC721 is ERC721 {
133   function takeOwnership(uint256 _tokenId) public;
134   function transfer(address _to, uint256 _tokenId) public;
135   function tokensOf(address _owner) public view returns (uint256[]);
136 }
137 
138 contract ERC721BasicToken is ERC721Basic {
139   using SafeMath for uint256;
140   using AddressUtils for address;
141   
142   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
143   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
144   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba; 
145 
146   // Mapping from token ID to owner
147   mapping (uint256 => address) internal tokenOwner;
148 
149   // Mapping from token ID to approved address
150   mapping (uint256 => address) internal tokenApprovals;
151 
152   // Mapping from owner to number of owned token
153   mapping (address => uint256) internal ownedTokensCount;
154 
155   // Mapping from owner to operator approvals
156   mapping (address => mapping (address => bool)) internal operatorApprovals;
157 
158   /**
159   * @dev Guarantees msg.sender is owner of the given token
160   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
161   */
162   modifier onlyOwnerOf(uint256 _tokenId) {
163     require(ownerOf(_tokenId) == msg.sender);
164     _;
165   }
166 
167   /**
168   * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
169   * @param _tokenId uint256 ID of the token to validate
170   */
171   modifier canTransfer(uint256 _tokenId) {
172     require(isApprovedOrOwner(msg.sender, _tokenId));
173     _;
174   }
175 
176   /**
177   * @dev Gets the balance of the specified address
178   * @param _owner address to query the balance of
179   * @return uint256 representing the amount owned by the passed address
180   */
181   function balanceOf(address _owner) public view returns (uint256) {
182     require(_owner != address(0));
183     return ownedTokensCount[_owner];
184   }
185 
186   /**
187   * @dev Gets the owner of the specified token ID
188   * @param _tokenId uint256 ID of the token to query the owner of
189   * @return owner address currently marked as the owner of the given token ID
190   */
191   function ownerOf(uint256 _tokenId) public view returns (address) {
192     address owner = tokenOwner[_tokenId];
193     require(owner != address(0));
194     return owner;
195   }
196 
197   /**
198   * @dev Returns whether the specified token exists
199   * @param _tokenId uint256 ID of the token to query the existance of
200   * @return whether the token exists
201   */
202   function exists(uint256 _tokenId) public view returns (bool) {
203     address owner = tokenOwner[_tokenId];
204     return owner != address(0);
205   }
206 
207   /**
208   * @dev Approves another address to transfer the given token ID
209   * @dev The zero address indicates there is no approved address.
210   * @dev There can only be one approved address per token at a given time.
211   * @dev Can only be called by the token owner or an approved operator.
212   * @param _to address to be approved for the given token ID
213   * @param _tokenId uint256 ID of the token to be approved
214   */
215   function approve(address _to, uint256 _tokenId) public {
216     address owner = ownerOf(_tokenId);
217     require(_to != owner);
218     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
219 
220     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
221       tokenApprovals[_tokenId] = _to;
222       Approval(owner, _to, _tokenId);
223     }
224   }
225 
226   /**
227    * @dev Gets the approved address for a token ID, or zero if no address set
228    * @param _tokenId uint256 ID of the token to query the approval of
229    * @return address currently approved for a the given token ID
230    */
231   function getApproved(uint256 _tokenId) public view returns (address) {
232     return tokenApprovals[_tokenId];
233   }
234 
235 
236   /**
237   * @dev Sets or unsets the approval of a given operator
238   * @dev An operator is allowed to transfer all tokens of the sender on their behalf
239   * @param _to operator address to set the approval
240   * @param _approved representing the status of the approval to be set
241   */
242   function setApprovalForAll(address _to, bool _approved) public {
243     require(_to != msg.sender);
244     operatorApprovals[msg.sender][_to] = _approved;
245     ApprovalForAll(msg.sender, _to, _approved);
246   }
247 
248   /**
249    * @dev Tells whether an operator is approved by a given owner
250    * @param _owner owner address which you want to query the approval of
251    * @param _operator operator address which you want to query the approval of
252    * @return bool whether the given operator is approved by the given owner
253    */
254   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
255     return operatorApprovals[_owner][_operator];
256   }
257 
258   /**
259   * @dev Transfers the ownership of a given token ID to another address
260   * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
261   * @dev Requires the msg sender to be the owner, approved, or operator
262   * @param _from current owner of the token
263   * @param _to address to receive the ownership of the given token ID
264   * @param _tokenId uint256 ID of the token to be transferred
265   */
266   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
267     require(_from != address(0));
268     require(_to != address(0));
269 
270     clearApproval(_from, _tokenId);
271     removeTokenFrom(_from, _tokenId);
272     addTokenTo(_to, _tokenId);
273     
274     Transfer(_from, _to, _tokenId);
275   }
276 
277   /**
278   * @dev Safely transfers the ownership of a given token ID to another address
279   * @dev If the target address is a contract, it must implement `onERC721Received`,
280   *  which is called upon a safe transfer, and return the magic value
281   *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
282   *  the transfer is reverted.
283   * @dev Requires the msg sender to be the owner, approved, or operator
284   * @param _from current owner of the token
285   * @param _to address to receive the ownership of the given token ID
286   * @param _tokenId uint256 ID of the token to be transferred
287   */
288   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
289     safeTransferFrom(_from, _to, _tokenId, "");
290   }
291 
292   /**
293   * @dev Safely transfers the ownership of a given token ID to another address
294   * @dev If the target address is a contract, it must implement `onERC721Received`,
295   *  which is called upon a safe transfer, and return the magic value
296   *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
297   *  the transfer is reverted.
298   * @dev Requires the msg sender to be the owner, approved, or operator
299   * @param _from current owner of the token
300   * @param _to address to receive the ownership of the given token ID
301   * @param _tokenId uint256 ID of the token to be transferred
302   * @param _data bytes data to send along with a safe transfer check
303   */
304   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public canTransfer(_tokenId) {
305     transferFrom(_from, _to, _tokenId);
306     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
307   }
308 
309   /**
310    * @dev Returns whether the given spender can transfer a given token ID
311    * @param _spender address of the spender to query
312    * @param _tokenId uint256 ID of the token to be transferred
313    * @return bool whether the msg.sender is approved for the given token ID,
314    *  is an operator of the owner, or is the owner of the token
315    */
316   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
317     address owner = ownerOf(_tokenId);
318     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
319   }
320 
321   /**
322   * @dev Internal function to mint a new token
323   * @dev Reverts if the given token ID already exists
324   * @param _to The address that will own the minted token
325   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
326   */
327   function _mint(address _to, uint256 _tokenId) internal {
328     require(_to != address(0));
329     addTokenTo(_to, _tokenId);
330     Transfer(address(0), _to, _tokenId);
331   }
332 
333   /**
334   * @dev Internal function to burn a specific token
335   * @dev Reverts if the token does not exist
336   * @param _tokenId uint256 ID of the token being burned by the msg.sender
337   */
338   function _burn(address _owner, uint256 _tokenId) internal {
339     clearApproval(_owner, _tokenId);
340     removeTokenFrom(_owner, _tokenId);
341     Transfer(_owner, address(0), _tokenId);
342   }
343 
344   /**
345   * @dev Internal function to clear current approval of a given token ID
346   * @dev Reverts if the given address is not indeed the owner of the token
347   * @param _owner owner of the token
348   * @param _tokenId uint256 ID of the token to be transferred
349   */
350   function clearApproval(address _owner, uint256 _tokenId) internal {
351     require(ownerOf(_tokenId) == _owner);
352     if (tokenApprovals[_tokenId] != address(0)) {
353       tokenApprovals[_tokenId] = address(0);
354       Approval(_owner, address(0), _tokenId);
355     }
356   }
357 
358   /**
359   * @dev Internal function to add a token ID to the list of a given address
360   * @param _to address representing the new owner of the given token ID
361   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
362   */
363   function addTokenTo(address _to, uint256 _tokenId) internal {
364     require(tokenOwner[_tokenId] == address(0));
365     tokenOwner[_tokenId] = _to;
366     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
367   }
368 
369   /**
370   * @dev Internal function to remove a token ID from the list of a given address
371   * @param _from address representing the previous owner of the given token ID
372   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
373   */
374   function removeTokenFrom(address _from, uint256 _tokenId) internal {
375     require(ownerOf(_tokenId) == _from);
376     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
377     tokenOwner[_tokenId] = address(0);
378   }
379 
380   /**
381   * @dev Internal function to invoke `onERC721Received` on a target address
382   * @dev The call is not executed if the target address is not a contract
383   * @param _from address representing the previous owner of the given token ID
384   * @param _to target address that will receive the tokens
385   * @param _tokenId uint256 ID of the token to be transferred
386   * @param _data bytes optional data to send along with the call
387   * @return whether the call correctly returned the expected magic value
388   */
389   function checkAndCallSafeTransfer(address _from, address _to, uint256 _tokenId, bytes _data) internal returns (bool) {
390     if (!_to.isContract()) {
391       return true;
392     }
393     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
394     return (retval == ERC721_RECEIVED);
395   }
396 }
397 
398 contract ERC721Receiver {
399   /**
400    * @dev Magic value to be returned upon successful reception of an NFT
401    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
402    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
403    */
404   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba; 
405 
406   /**
407    * @notice Handle the receipt of an NFT
408    * @dev The ERC721 smart contract calls this function on the recipient
409    *  after a `safetransfer`. This function MAY throw to revert and reject the
410    *  transfer. This function MUST use 50,000 gas or less. Return of other
411    *  than the magic value MUST result in the transaction being reverted.
412    *  Note: the contract address is always the message sender.
413    * @param _from The sending address 
414    * @param _tokenId The NFT identifier which is being transfered
415    * @param _data Additional data with no specified format
416    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
417    */
418   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
419 }
420 
421 contract ERC721Token is ERC721, ERC721BasicToken {
422   // Token name
423   string internal name_;
424 
425   // Token symbol
426   string internal symbol_;
427 
428   // Mapping from owner to list of owned token IDs
429   mapping (address => uint256[]) internal ownedTokens;
430 
431   // Mapping from token ID to index of the owner tokens list
432   mapping(uint256 => uint256) internal ownedTokensIndex;
433 
434   // Array with all token ids, used for enumeration
435   uint256[] internal allTokens;
436 
437   // Mapping from token id to position in the allTokens array
438   mapping(uint256 => uint256) internal allTokensIndex;
439 
440   // Optional mapping for token URIs 
441   mapping(uint256 => string) internal tokenURIs;
442 
443   /**
444   * @dev Constructor function
445   */
446   function ERC721Token(string _name, string _symbol) public {
447     name_ = _name;
448     symbol_ = _symbol;
449   }
450 
451   /**
452   * @dev Gets the token name
453   * @return string representing the token name
454   */
455   function name() public view returns (string) {
456     return name_;
457   }
458 
459   /**
460   * @dev Gets the token symbol
461   * @return string representing the token symbol
462   */
463   function symbol() public view returns (string) {
464     return symbol_;
465   }
466 
467   /**
468   * @dev Returns an URI for a given token ID
469   * @dev Throws if the token ID does not exist. May return an empty string.
470   * @param _tokenId uint256 ID of the token to query
471   */
472   function tokenURI(uint256 _tokenId) public view returns (string) {
473     require(exists(_tokenId));
474     return tokenURIs[_tokenId];
475   }
476 
477   /**
478   * @dev Internal function to set the token URI for a given token
479   * @dev Reverts if the token ID does not exist
480   * @param _tokenId uint256 ID of the token to set its URI
481   * @param _uri string URI to assign
482   */
483   function _setTokenURI(uint256 _tokenId, string _uri) internal {
484     require(exists(_tokenId));
485     tokenURIs[_tokenId] = _uri;
486   }
487 
488   /**
489   * @dev Gets the token ID at a given index of the tokens list of the requested owner
490   * @param _owner address owning the tokens list to be accessed
491   * @param _index uint256 representing the index to be accessed of the requested tokens list
492   * @return uint256 token ID at the given index of the tokens list owned by the requested address
493   */
494   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
495     require(_index < balanceOf(_owner));
496     return ownedTokens[_owner][_index];
497   }
498 
499   /**
500   * @dev Gets the total amount of tokens stored by the contract
501   * @return uint256 representing the total amount of tokens
502   */
503   function totalSupply() public view returns (uint256) {
504     return allTokens.length;
505   }
506 
507   /**
508   * @dev Gets the token ID at a given index of all the tokens in this contract
509   * @dev Reverts if the index is greater or equal to the total number of tokens
510   * @param _index uint256 representing the index to be accessed of the tokens list
511   * @return uint256 token ID at the given index of the tokens list
512   */
513   function tokenByIndex(uint256 _index) public view returns (uint256) {
514     require(_index < totalSupply());
515     return allTokens[_index];
516   }
517 
518   /**
519   * @dev Internal function to add a token ID to the list of a given address
520   * @param _to address representing the new owner of the given token ID
521   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
522   */
523   function addTokenTo(address _to, uint256 _tokenId) internal {
524     super.addTokenTo(_to, _tokenId);
525     uint256 length = ownedTokens[_to].length;
526     ownedTokens[_to].push(_tokenId);
527     ownedTokensIndex[_tokenId] = length;
528   }
529 
530   /**
531   * @dev Internal function to remove a token ID from the list of a given address
532   * @param _from address representing the previous owner of the given token ID
533   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
534   */
535   function removeTokenFrom(address _from, uint256 _tokenId) internal {
536     super.removeTokenFrom(_from, _tokenId);
537 
538     uint256 tokenIndex = ownedTokensIndex[_tokenId];
539     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
540     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
541 
542     ownedTokens[_from][tokenIndex] = lastToken;
543     ownedTokens[_from][lastTokenIndex] = 0;
544     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
545     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
546     // the lastToken to the first position, and then dropping the element placed in the last position of the list
547 
548     ownedTokens[_from].length--;
549     ownedTokensIndex[_tokenId] = 0;
550     ownedTokensIndex[lastToken] = tokenIndex;
551   }
552 
553   /**
554   * @dev Internal function to mint a new token
555   * @dev Reverts if the given token ID already exists
556   * @param _to address the beneficiary that will own the minted token
557   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
558   */
559   function _mint(address _to, uint256 _tokenId) internal {
560     super._mint(_to, _tokenId);
561     
562     allTokensIndex[_tokenId] = allTokens.length;
563     allTokens.push(_tokenId);
564   }
565 
566   /**
567   * @dev Internal function to burn a specific token
568   * @dev Reverts if the token does not exist
569   * @param _owner owner of the token to burn
570   * @param _tokenId uint256 ID of the token being burned by the msg.sender
571   */
572   function _burn(address _owner, uint256 _tokenId) internal {
573     super._burn(_owner, _tokenId);
574 
575     // Clear metadata (if any)
576     if (bytes(tokenURIs[_tokenId]).length != 0) {
577       delete tokenURIs[_tokenId];
578     }
579 
580     // Reorg all tokens array
581     uint256 tokenIndex = allTokensIndex[_tokenId];
582     uint256 lastTokenIndex = allTokens.length.sub(1);
583     uint256 lastToken = allTokens[lastTokenIndex];
584 
585     allTokens[tokenIndex] = lastToken;
586     allTokens[lastTokenIndex] = 0;
587 
588     allTokens.length--;
589     allTokensIndex[_tokenId] = 0;
590     allTokensIndex[lastToken] = tokenIndex;
591   }
592 
593 }
594 
595 contract DeusToken is Ownable, ERC721Token {
596   function DeusToken() public ERC721Token("DeusETH Token", "DEUS") {
597   }
598   
599   function safeTransferFromWithData(address from, address to, uint256 tokenId, bytes data) public {
600     return super.safeTransferFrom(from, to, tokenId, data);
601   }
602   
603   function mint(address _to, uint256 _tokenId) public onlyOwner {
604     super._mint(_to, _tokenId);
605   }
606   
607   function burn(address _owner, uint256 _tokenId) public onlyOwner {
608     super._burn(_owner, _tokenId);
609   }
610   
611   function setTokenURI(uint256 _tokenId, string _uri) public onlyOwner {
612     super._setTokenURI(_tokenId, _uri);
613   }
614 }