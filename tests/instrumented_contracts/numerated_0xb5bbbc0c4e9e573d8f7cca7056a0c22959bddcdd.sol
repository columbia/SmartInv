1 pragma solidity ^0.4.21;
2 
3 
4 
5 
6 
7 /**
8  * @title Ownable
9  * @dev The Ownable contract has an owner address, and provides basic authorization control
10  * functions, this simplifies the implementation of "user permissions".
11  */
12 contract Ownable {
13   address public owner;
14 
15 
16   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   function Ownable() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 
48 /**
49  * @title Pausable
50  * @dev Base contract which allows children to implement an emergency stop mechanism.
51  */
52 contract Pausable is Ownable {
53   event Pause();
54   event Unpause();
55 
56   bool public paused = false;
57 
58 
59   /**
60    * @dev Modifier to make a function callable only when the contract is not paused.
61    */
62   modifier whenNotPaused() {
63     require(!paused);
64     _;
65   }
66 
67   /**
68    * @dev Modifier to make a function callable only when the contract is paused.
69    */
70   modifier whenPaused() {
71     require(paused);
72     _;
73   }
74 
75   /**
76    * @dev called by the owner to pause, triggers stopped state
77    */
78   function pause() onlyOwner whenNotPaused public {
79     paused = true;
80     Pause();
81   }
82 
83   /**
84    * @dev called by the owner to unpause, returns to normal state
85    */
86   function unpause() onlyOwner whenPaused public {
87     paused = false;
88     Unpause();
89   }
90 }
91 
92 
93 
94 /**
95  * @title ERC721 Non-Fungible Token Standard basic interface
96  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
97  */
98 contract ERC721Basic {
99   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
100   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
101   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);  
102 
103   function balanceOf(address _owner) public view returns (uint256 _balance);
104   function ownerOf(uint256 _tokenId) public view returns (address _owner);
105   function exists(uint256 _tokenId) public view returns (bool _exists);
106   
107   function approve(address _to, uint256 _tokenId) public;
108   function getApproved(uint256 _tokenId) public view returns (address _operator);
109   
110   function setApprovalForAll(address _operator, bool _approved) public;
111   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
112 
113   function transferFrom(address _from, address _to, uint256 _tokenId) public;
114   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;  
115   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public;
116 }
117 
118 /**
119  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
120  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
121  */
122 contract ERC721Enumerable is ERC721Basic {
123   function totalSupply() public view returns (uint256);
124   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
125   function tokenByIndex(uint256 _index) public view returns (uint256);
126 }
127 
128 /**
129  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
130  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
131  */
132 contract ERC721Metadata is ERC721Basic {
133   function name() public view returns (string _name);
134   function symbol() public view returns (string _symbol);
135   function tokenURI(uint256 _tokenId) public view returns (string);
136 }
137 
138 /**
139  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
140  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
141  */
142 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
143 }
144 
145 
146 /**
147  * @title ERC-721 methods shipped in OpenZeppelin v1.7.0, removed in the latest version of the standard
148  * @dev Only use this interface for compatibility with previously deployed contracts
149  * @dev Use ERC721 for interacting with new contracts which are standard-compliant
150  */
151 contract DeprecatedERC721 is ERC721 {
152   function takeOwnership(uint256 _tokenId) public;
153   function transfer(address _to, uint256 _tokenId) public;
154   function tokensOf(address _owner) public view returns (uint256[]);
155 }
156 
157 
158 
159 /**
160  * @title ERC721 token receiver interface
161  * @dev Interface for any contract that wants to support safeTransfers
162  *  from ERC721 asset contracts.
163  */
164 contract ERC721Receiver {
165   /**
166    * @dev Magic value to be returned upon successful reception of an NFT
167    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
168    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
169    */
170   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba; 
171 
172   /**
173    * @notice Handle the receipt of an NFT
174    * @dev The ERC721 smart contract calls this function on the recipient
175    *  after a `safetransfer`. This function MAY throw to revert and reject the
176    *  transfer. This function MUST use 50,000 gas or less. Return of other
177    *  than the magic value MUST result in the transaction being reverted.
178    *  Note: the contract address is always the message sender.
179    * @param _from The sending address 
180    * @param _tokenId The NFT identifier which is being transfered
181    * @param _data Additional data with no specified format
182    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
183    */
184   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
185 }
186 
187 
188 /**
189  * @title SafeMath
190  * @dev Math operations with safety checks that throw on error
191  */
192 library SafeMath {
193 
194   /**
195   * @dev Multiplies two numbers, throws on overflow.
196   */
197   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
198     if (a == 0) {
199       return 0;
200     }
201     uint256 c = a * b;
202     assert(c / a == b);
203     return c;
204   }
205 
206   /**
207   * @dev Integer division of two numbers, truncating the quotient.
208   */
209   function div(uint256 a, uint256 b) internal pure returns (uint256) {
210     // assert(b > 0); // Solidity automatically throws when dividing by 0
211     uint256 c = a / b;
212     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
213     return c;
214   }
215 
216   /**
217   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
218   */
219   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
220     assert(b <= a);
221     return a - b;
222   }
223 
224   /**
225   * @dev Adds two numbers, throws on overflow.
226   */
227   function add(uint256 a, uint256 b) internal pure returns (uint256) {
228     uint256 c = a + b;
229     assert(c >= a);
230     return c;
231   }
232 }
233 
234 /**
235  * Utility library of inline functions on addresses
236  */
237 library AddressUtils {
238 
239   /**
240    * Returns whether there is code in the target address
241    * @dev This function will return false if invoked during the constructor of a contract,
242    *  as the code is not actually created until after the constructor finishes.
243    * @param addr address address to check
244    * @return whether there is code in the target address
245    */
246   function isContract(address addr) internal view returns (bool) {
247     uint256 size;
248     assembly { size := extcodesize(addr) }
249     return size > 0;
250   }
251 
252 }
253 
254 /**
255  * @title ERC721 Non-Fungible Token Standard basic implementation
256  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
257  */
258 contract ERC721BasicToken is ERC721Basic {
259   using SafeMath for uint256;
260   using AddressUtils for address;
261   
262   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
263   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
264   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba; 
265 
266   // Mapping from token ID to owner
267   mapping (uint256 => address) internal tokenOwner;
268 
269   // Mapping from token ID to approved address
270   mapping (uint256 => address) internal tokenApprovals;
271 
272   // Mapping from owner to number of owned token
273   mapping (address => uint256) internal ownedTokensCount;
274 
275   // Mapping from owner to operator approvals
276   mapping (address => mapping (address => bool)) internal operatorApprovals;
277 
278   /**
279   * @dev Guarantees msg.sender is owner of the given token
280   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
281   */
282   modifier onlyOwnerOf(uint256 _tokenId) {
283     require(ownerOf(_tokenId) == msg.sender);
284     _;
285   }
286 
287   /**
288   * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
289   * @param _tokenId uint256 ID of the token to validate
290   */
291   modifier canTransfer(uint256 _tokenId) {
292     require(isApprovedOrOwner(msg.sender, _tokenId));
293     _;
294   }
295 
296   /**
297   * @dev Gets the balance of the specified address
298   * @param _owner address to query the balance of
299   * @return uint256 representing the amount owned by the passed address
300   */
301   function balanceOf(address _owner) public view returns (uint256) {
302     require(_owner != address(0));
303     return ownedTokensCount[_owner];
304   }
305 
306   /**
307   * @dev Gets the owner of the specified token ID
308   * @param _tokenId uint256 ID of the token to query the owner of
309   * @return owner address currently marked as the owner of the given token ID
310   */
311   function ownerOf(uint256 _tokenId) public view returns (address) {
312     address owner = tokenOwner[_tokenId];
313     require(owner != address(0));
314     return owner;
315   }
316 
317   /**
318   * @dev Returns whether the specified token exists
319   * @param _tokenId uint256 ID of the token to query the existance of
320   * @return whether the token exists
321   */
322   function exists(uint256 _tokenId) public view returns (bool) {
323     address owner = tokenOwner[_tokenId];
324     return owner != address(0);
325   }
326 
327   /**
328   * @dev Approves another address to transfer the given token ID
329   * @dev The zero address indicates there is no approved address.
330   * @dev There can only be one approved address per token at a given time.
331   * @dev Can only be called by the token owner or an approved operator.
332   * @param _to address to be approved for the given token ID
333   * @param _tokenId uint256 ID of the token to be approved
334   */
335   function approve(address _to, uint256 _tokenId) public {
336     address owner = ownerOf(_tokenId);
337     require(_to != owner);
338     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
339 
340     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
341       tokenApprovals[_tokenId] = _to;
342       Approval(owner, _to, _tokenId);
343     }
344   }
345 
346   /**
347    * @dev Gets the approved address for a token ID, or zero if no address set
348    * @param _tokenId uint256 ID of the token to query the approval of
349    * @return address currently approved for a the given token ID
350    */
351   function getApproved(uint256 _tokenId) public view returns (address) {
352     return tokenApprovals[_tokenId];
353   }
354 
355 
356   /**
357   * @dev Sets or unsets the approval of a given operator
358   * @dev An operator is allowed to transfer all tokens of the sender on their behalf
359   * @param _to operator address to set the approval
360   * @param _approved representing the status of the approval to be set
361   */
362   function setApprovalForAll(address _to, bool _approved) public {
363     require(_to != msg.sender);
364     operatorApprovals[msg.sender][_to] = _approved;
365     ApprovalForAll(msg.sender, _to, _approved);
366   }
367 
368   /**
369    * @dev Tells whether an operator is approved by a given owner
370    * @param _owner owner address which you want to query the approval of
371    * @param _operator operator address which you want to query the approval of
372    * @return bool whether the given operator is approved by the given owner
373    */
374   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
375     return operatorApprovals[_owner][_operator];
376   }
377 
378   /**
379   * @dev Transfers the ownership of a given token ID to another address
380   * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
381   * @dev Requires the msg sender to be the owner, approved, or operator
382   * @param _from current owner of the token
383   * @param _to address to receive the ownership of the given token ID
384   * @param _tokenId uint256 ID of the token to be transferred
385   */
386   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
387     require(_from != address(0));
388     require(_to != address(0));
389 
390     clearApproval(_from, _tokenId);
391     removeTokenFrom(_from, _tokenId);
392     addTokenTo(_to, _tokenId);
393     
394     Transfer(_from, _to, _tokenId);
395   }
396 
397   /**
398   * @dev Safely transfers the ownership of a given token ID to another address
399   * @dev If the target address is a contract, it must implement `onERC721Received`,
400   *  which is called upon a safe transfer, and return the magic value
401   *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
402   *  the transfer is reverted.
403   * @dev Requires the msg sender to be the owner, approved, or operator
404   * @param _from current owner of the token
405   * @param _to address to receive the ownership of the given token ID
406   * @param _tokenId uint256 ID of the token to be transferred
407   */
408   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
409     safeTransferFrom(_from, _to, _tokenId, "");
410   }
411 
412   /**
413   * @dev Safely transfers the ownership of a given token ID to another address
414   * @dev If the target address is a contract, it must implement `onERC721Received`,
415   *  which is called upon a safe transfer, and return the magic value
416   *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
417   *  the transfer is reverted.
418   * @dev Requires the msg sender to be the owner, approved, or operator
419   * @param _from current owner of the token
420   * @param _to address to receive the ownership of the given token ID
421   * @param _tokenId uint256 ID of the token to be transferred
422   * @param _data bytes data to send along with a safe transfer check
423   */
424   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public canTransfer(_tokenId) {
425     transferFrom(_from, _to, _tokenId);
426     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
427   }
428 
429   /**
430    * @dev Returns whether the given spender can transfer a given token ID
431    * @param _spender address of the spender to query
432    * @param _tokenId uint256 ID of the token to be transferred
433    * @return bool whether the msg.sender is approved for the given token ID,
434    *  is an operator of the owner, or is the owner of the token
435    */
436   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
437     address owner = ownerOf(_tokenId);
438     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
439   }
440 
441   /**
442   * @dev Internal function to mint a new token
443   * @dev Reverts if the given token ID already exists
444   * @param _to The address that will own the minted token
445   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
446   */
447   function _mint(address _to, uint256 _tokenId) internal {
448     require(_to != address(0));
449     addTokenTo(_to, _tokenId);
450     Transfer(address(0), _to, _tokenId);
451   }
452 
453   /**
454   * @dev Internal function to burn a specific token
455   * @dev Reverts if the token does not exist
456   * @param _tokenId uint256 ID of the token being burned by the msg.sender
457   */
458   function _burn(address _owner, uint256 _tokenId) internal {
459     clearApproval(_owner, _tokenId);
460     removeTokenFrom(_owner, _tokenId);
461     Transfer(_owner, address(0), _tokenId);
462   }
463 
464   /**
465   * @dev Internal function to clear current approval of a given token ID
466   * @dev Reverts if the given address is not indeed the owner of the token
467   * @param _owner owner of the token
468   * @param _tokenId uint256 ID of the token to be transferred
469   */
470   function clearApproval(address _owner, uint256 _tokenId) internal {
471     require(ownerOf(_tokenId) == _owner);
472     if (tokenApprovals[_tokenId] != address(0)) {
473       tokenApprovals[_tokenId] = address(0);
474       Approval(_owner, address(0), _tokenId);
475     }
476   }
477 
478   /**
479   * @dev Internal function to add a token ID to the list of a given address
480   * @param _to address representing the new owner of the given token ID
481   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
482   */
483   function addTokenTo(address _to, uint256 _tokenId) internal {
484     require(tokenOwner[_tokenId] == address(0));
485     tokenOwner[_tokenId] = _to;
486     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
487   }
488 
489   /**
490   * @dev Internal function to remove a token ID from the list of a given address
491   * @param _from address representing the previous owner of the given token ID
492   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
493   */
494   function removeTokenFrom(address _from, uint256 _tokenId) internal {
495     require(ownerOf(_tokenId) == _from);
496     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
497     tokenOwner[_tokenId] = address(0);
498   }
499 
500   /**
501   * @dev Internal function to invoke `onERC721Received` on a target address
502   * @dev The call is not executed if the target address is not a contract
503   * @param _from address representing the previous owner of the given token ID
504   * @param _to target address that will receive the tokens
505   * @param _tokenId uint256 ID of the token to be transferred
506   * @param _data bytes optional data to send along with the call
507   * @return whether the call correctly returned the expected magic value
508   */
509   function checkAndCallSafeTransfer(address _from, address _to, uint256 _tokenId, bytes _data) internal returns (bool) {
510     if (!_to.isContract()) {
511       return true;
512     }
513     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
514     return (retval == ERC721_RECEIVED);
515   }
516 }
517 
518 
519 /**
520  * @title Full ERC721 Token
521  * This implementation includes all the required and some optional functionality of the ERC721 standard
522  * Moreover, it includes approve all functionality using operator terminology
523  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
524  */
525 contract ERC721Token is ERC721, ERC721BasicToken {
526   // Token name
527   string internal name_;
528 
529   // Token symbol
530   string internal symbol_;
531 
532   // Mapping from owner to list of owned token IDs
533   mapping (address => uint256[]) internal ownedTokens;
534 
535   // Mapping from token ID to index of the owner tokens list
536   mapping(uint256 => uint256) internal ownedTokensIndex;
537 
538   // Array with all token ids, used for enumeration
539   uint256[] internal allTokens;
540 
541   // Mapping from token id to position in the allTokens array
542   mapping(uint256 => uint256) internal allTokensIndex;
543 
544   // Optional mapping for token URIs 
545   mapping(uint256 => string) internal tokenURIs;
546 
547   /**
548   * @dev Constructor function
549   */
550   function ERC721Token(string _name, string _symbol) public {
551     name_ = _name;
552     symbol_ = _symbol;
553   }
554 
555   /**
556   * @dev Gets the token name
557   * @return string representing the token name
558   */
559   function name() public view returns (string) {
560     return name_;
561   }
562 
563   /**
564   * @dev Gets the token symbol
565   * @return string representing the token symbol
566   */
567   function symbol() public view returns (string) {
568     return symbol_;
569   }
570 
571   /**
572   * @dev Returns an URI for a given token ID
573   * @dev Throws if the token ID does not exist. May return an empty string.
574   * @param _tokenId uint256 ID of the token to query
575   */
576   function tokenURI(uint256 _tokenId) public view returns (string) {
577     require(exists(_tokenId));
578     return tokenURIs[_tokenId];
579   }
580 
581   /**
582   * @dev Internal function to set the token URI for a given token
583   * @dev Reverts if the token ID does not exist
584   * @param _tokenId uint256 ID of the token to set its URI
585   * @param _uri string URI to assign
586   */
587   function _setTokenURI(uint256 _tokenId, string _uri) internal {
588     require(exists(_tokenId));
589     tokenURIs[_tokenId] = _uri;
590   }
591 
592   /**
593   * @dev Gets the token ID at a given index of the tokens list of the requested owner
594   * @param _owner address owning the tokens list to be accessed
595   * @param _index uint256 representing the index to be accessed of the requested tokens list
596   * @return uint256 token ID at the given index of the tokens list owned by the requested address
597   */
598   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
599     require(_index < balanceOf(_owner));
600     return ownedTokens[_owner][_index];
601   }
602 
603   /**
604   * @dev Gets the total amount of tokens stored by the contract
605   * @return uint256 representing the total amount of tokens
606   */
607   function totalSupply() public view returns (uint256) {
608     return allTokens.length;
609   }
610 
611   /**
612   * @dev Gets the token ID at a given index of all the tokens in this contract
613   * @dev Reverts if the index is greater or equal to the total number of tokens
614   * @param _index uint256 representing the index to be accessed of the tokens list
615   * @return uint256 token ID at the given index of the tokens list
616   */
617   function tokenByIndex(uint256 _index) public view returns (uint256) {
618     require(_index < totalSupply());
619     return allTokens[_index];
620   }
621 
622   /**
623   * @dev Internal function to add a token ID to the list of a given address
624   * @param _to address representing the new owner of the given token ID
625   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
626   */
627   function addTokenTo(address _to, uint256 _tokenId) internal {
628     super.addTokenTo(_to, _tokenId);
629     uint256 length = ownedTokens[_to].length;
630     ownedTokens[_to].push(_tokenId);
631     ownedTokensIndex[_tokenId] = length;
632   }
633 
634   /**
635   * @dev Internal function to remove a token ID from the list of a given address
636   * @param _from address representing the previous owner of the given token ID
637   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
638   */
639   function removeTokenFrom(address _from, uint256 _tokenId) internal {
640     super.removeTokenFrom(_from, _tokenId);
641 
642     uint256 tokenIndex = ownedTokensIndex[_tokenId];
643     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
644     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
645 
646     ownedTokens[_from][tokenIndex] = lastToken;
647     ownedTokens[_from][lastTokenIndex] = 0;
648     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
649     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
650     // the lastToken to the first position, and then dropping the element placed in the last position of the list
651 
652     ownedTokens[_from].length--;
653     ownedTokensIndex[_tokenId] = 0;
654     ownedTokensIndex[lastToken] = tokenIndex;
655   }
656 
657   /**
658   * @dev Internal function to mint a new token
659   * @dev Reverts if the given token ID already exists
660   * @param _to address the beneficiary that will own the minted token
661   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
662   */
663   function _mint(address _to, uint256 _tokenId) internal {
664     super._mint(_to, _tokenId);
665     
666     allTokensIndex[_tokenId] = allTokens.length;
667     allTokens.push(_tokenId);
668   }
669 
670   /**
671   * @dev Internal function to burn a specific token
672   * @dev Reverts if the token does not exist
673   * @param _owner owner of the token to burn
674   * @param _tokenId uint256 ID of the token being burned by the msg.sender
675   */
676   function _burn(address _owner, uint256 _tokenId) internal {
677     super._burn(_owner, _tokenId);
678 
679     // Clear metadata (if any)
680     if (bytes(tokenURIs[_tokenId]).length != 0) {
681       delete tokenURIs[_tokenId];
682     }
683 
684     // Reorg all tokens array
685     uint256 tokenIndex = allTokensIndex[_tokenId];
686     uint256 lastTokenIndex = allTokens.length.sub(1);
687     uint256 lastToken = allTokens[lastTokenIndex];
688 
689     allTokens[tokenIndex] = lastToken;
690     allTokens[lastTokenIndex] = 0;
691 
692     allTokens.length--;
693     allTokensIndex[_tokenId] = 0;
694     allTokensIndex[lastToken] = tokenIndex;
695   }
696 
697 }
698 
699 /**
700 * @title TraxionDeed 
701 * @dev Traxion Pre ICO deed of sale
702 *
703 */
704 
705 contract TraxionDeed is ERC721Token, Pausable {
706 
707     using SafeMath for uint256;
708 
709     uint256 public constant rate = 1000;
710     uint256 public weiRaised;
711     uint256 public iouTokens;
712 
713     constructor() public
714     ERC721Token("Traxion Deed of Sale", "TXND")
715     {
716       transferOwnership(0xC889dFBDc9C1D0FC3E77e46c3b82A3903b2D919c);
717     }
718 
719     /** @dev Modified Pausable.sol from https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/lifecycle/Pausable.sol 
720         Purpose of this is to prevent unecessary burning of deed of sale during pre-ICO stage.
721     ***/
722 
723     event MainICO();
724     
725     bool public main_sale = false;
726 
727    /**
728    * @dev Modifier to make a function callable only when during Pre-ICO.
729    */
730     modifier isPreICO() {
731         require(!main_sale);
732         _;
733     }    
734     
735    /**
736    * @dev Modifier to make a function callable only when during Main-ICO.
737    */
738     modifier isMainICO() {
739         require(main_sale);
740         _;
741     }
742 
743    /**
744    * @dev called by the owner to initialize Main-ICO
745    */
746     function mainICO() public onlyOwner isPreICO {
747         main_sale = true;
748         emit MainICO();
749     }
750 
751     /*** @dev Traxion Deed of Sale Metadata ***/
752     struct Token {
753         address mintedFor;
754         uint64 mintedAt;
755         uint256 tokenAmount;
756         uint256 weiAmount;
757     }
758 
759     Token[] public tokens;
760 
761     function tokensOf(address _owner) public view returns (uint256[]) {
762         return ownedTokens[_owner];
763     }
764 
765     /*** @dev function to create Deed of Sale ***/
766 
767     function buyTokens(address beneficiary, uint256 weiAmt) public onlyOwner whenNotPaused {
768         require(beneficiary != address(0));
769         require(weiAmt != 0);
770 
771         uint256 _tokenamount = weiAmt.mul(rate);
772 
773         mint(beneficiary, _tokenamount, weiAmt);
774     }
775 
776     /*** @dev function to burn the deed and swap it to Traxion Tokens ***/
777 
778     function burn(uint256 _tokenId) public isMainICO {
779         super._burn(ownerOf(_tokenId), _tokenId);
780     }
781 
782     function mint(address _to, uint256 value, uint256 weiAmt) internal returns (uint256 _tokenId) {
783 
784         weiRaised = weiRaised.add(weiAmt);
785         iouTokens = iouTokens.add(value);
786 
787         _tokenId = tokens.push(Token({
788                         mintedFor: _to,
789                         mintedAt: uint64(now),
790                         tokenAmount: value,
791                         weiAmount: weiAmt
792                     })) - 1;
793                     
794         super._mint(_to, _tokenId);
795     }
796 
797 }