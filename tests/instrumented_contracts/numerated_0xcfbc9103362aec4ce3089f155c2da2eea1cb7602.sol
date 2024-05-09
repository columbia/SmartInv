1 pragma solidity ^0.4.23;
2 
3 // File: contracts/zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: contracts/Acceptable.sol
46 
47 // @title Acceptable
48 // @author Takayuki Jimba
49 // @dev Provide basic access control.
50 contract Acceptable is Ownable {
51     address public sender;
52 
53     // @dev Throws if called by any address other than the sender.
54     modifier onlyAcceptable {
55         require(msg.sender == sender);
56         _;
57     }
58 
59     // @dev Change acceptable address
60     // @param _sender The address to new sender
61     function setAcceptable(address _sender) public onlyOwner {
62         sender = _sender;
63     }
64 }
65 
66 // File: contracts/zeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
67 
68 /**
69  * @title ERC721 Non-Fungible Token Standard basic interface
70  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
71  */
72 contract ERC721Basic {
73   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
74   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
75   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);  
76 
77   function balanceOf(address _owner) public view returns (uint256 _balance);
78   function ownerOf(uint256 _tokenId) public view returns (address _owner);
79   function exists(uint256 _tokenId) public view returns (bool _exists);
80   
81   function approve(address _to, uint256 _tokenId) public;
82   function getApproved(uint256 _tokenId) public view returns (address _operator);
83   
84   function setApprovalForAll(address _operator, bool _approved) public;
85   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
86 
87   function transferFrom(address _from, address _to, uint256 _tokenId) public;
88   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;  
89   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public;
90 }
91 
92 // File: contracts/zeppelin-solidity/contracts/token/ERC721/ERC721.sol
93 
94 /**
95  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
96  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
97  */
98 contract ERC721Enumerable is ERC721Basic {
99   function totalSupply() public view returns (uint256);
100   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
101   function tokenByIndex(uint256 _index) public view returns (uint256);
102 }
103 
104 /**
105  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
106  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
107  */
108 contract ERC721Metadata is ERC721Basic {
109   function name() public view returns (string _name);
110   function symbol() public view returns (string _symbol);
111   function tokenURI(uint256 _tokenId) public view returns (string);
112 }
113 
114 /**
115  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
116  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
117  */
118 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
119 }
120 
121 // File: contracts/zeppelin-solidity/contracts/token/ERC721/DeprecatedERC721.sol
122 
123 /**
124  * @title ERC-721 methods shipped in OpenZeppelin v1.7.0, removed in the latest version of the standard
125  * @dev Only use this interface for compatibility with previously deployed contracts
126  * @dev Use ERC721 for interacting with new contracts which are standard-compliant
127  */
128 contract DeprecatedERC721 is ERC721 {
129   function takeOwnership(uint256 _tokenId) public;
130   function transfer(address _to, uint256 _tokenId) public;
131   function tokensOf(address _owner) public view returns (uint256[]);
132 }
133 
134 // File: contracts/zeppelin-solidity/contracts/AddressUtils.sol
135 
136 /**
137  * Utility library of inline functions on addresses
138  */
139 library AddressUtils {
140 
141   /**
142    * Returns whether there is code in the target address
143    * @dev This function will return false if invoked during the constructor of a contract,
144    *  as the code is not actually created until after the constructor finishes.
145    * @param addr address address to check
146    * @return whether there is code in the target address
147    */
148   function isContract(address addr) internal view returns (bool) {
149     uint256 size;
150     assembly { size := extcodesize(addr) }
151     return size > 0;
152   }
153 
154 }
155 
156 // File: contracts/zeppelin-solidity/contracts/math/SafeMath.sol
157 
158 /**
159  * @title SafeMath
160  * @dev Math operations with safety checks that throw on error
161  */
162 library SafeMath {
163 
164   /**
165   * @dev Multiplies two numbers, throws on overflow.
166   */
167   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
168     if (a == 0) {
169       return 0;
170     }
171     uint256 c = a * b;
172     assert(c / a == b);
173     return c;
174   }
175 
176   /**
177   * @dev Integer division of two numbers, truncating the quotient.
178   */
179   function div(uint256 a, uint256 b) internal pure returns (uint256) {
180     // assert(b > 0); // Solidity automatically throws when dividing by 0
181     uint256 c = a / b;
182     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
183     return c;
184   }
185 
186   /**
187   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
188   */
189   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
190     assert(b <= a);
191     return a - b;
192   }
193 
194   /**
195   * @dev Adds two numbers, throws on overflow.
196   */
197   function add(uint256 a, uint256 b) internal pure returns (uint256) {
198     uint256 c = a + b;
199     assert(c >= a);
200     return c;
201   }
202 }
203 
204 // File: contracts/zeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
205 
206 /**
207  * @title ERC721 token receiver interface
208  * @dev Interface for any contract that wants to support safeTransfers
209  *  from ERC721 asset contracts.
210  */
211 contract ERC721Receiver {
212   /**
213    * @dev Magic value to be returned upon successful reception of an NFT
214    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
215    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
216    */
217   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba; 
218 
219   /**
220    * @notice Handle the receipt of an NFT
221    * @dev The ERC721 smart contract calls this function on the recipient
222    *  after a `safetransfer`. This function MAY throw to revert and reject the
223    *  transfer. This function MUST use 50,000 gas or less. Return of other
224    *  than the magic value MUST result in the transaction being reverted.
225    *  Note: the contract address is always the message sender.
226    * @param _from The sending address 
227    * @param _tokenId The NFT identifier which is being transfered
228    * @param _data Additional data with no specified format
229    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
230    */
231   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
232 }
233 
234 // File: contracts/zeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
235 
236 /**
237  * @title ERC721 Non-Fungible Token Standard basic implementation
238  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
239  */
240 contract ERC721BasicToken is ERC721Basic {
241   using SafeMath for uint256;
242   using AddressUtils for address;
243   
244   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
245   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
246   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba; 
247 
248   // Mapping from token ID to owner
249   mapping (uint256 => address) internal tokenOwner;
250 
251   // Mapping from token ID to approved address
252   mapping (uint256 => address) internal tokenApprovals;
253 
254   // Mapping from owner to number of owned token
255   mapping (address => uint256) internal ownedTokensCount;
256 
257   // Mapping from owner to operator approvals
258   mapping (address => mapping (address => bool)) internal operatorApprovals;
259 
260   /**
261   * @dev Guarantees msg.sender is owner of the given token
262   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
263   */
264   modifier onlyOwnerOf(uint256 _tokenId) {
265     require(ownerOf(_tokenId) == msg.sender);
266     _;
267   }
268 
269   /**
270   * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
271   * @param _tokenId uint256 ID of the token to validate
272   */
273   modifier canTransfer(uint256 _tokenId) {
274     require(isApprovedOrOwner(msg.sender, _tokenId));
275     _;
276   }
277 
278   /**
279   * @dev Gets the balance of the specified address
280   * @param _owner address to query the balance of
281   * @return uint256 representing the amount owned by the passed address
282   */
283   function balanceOf(address _owner) public view returns (uint256) {
284     require(_owner != address(0));
285     return ownedTokensCount[_owner];
286   }
287 
288   /**
289   * @dev Gets the owner of the specified token ID
290   * @param _tokenId uint256 ID of the token to query the owner of
291   * @return owner address currently marked as the owner of the given token ID
292   */
293   function ownerOf(uint256 _tokenId) public view returns (address) {
294     address owner = tokenOwner[_tokenId];
295     require(owner != address(0));
296     return owner;
297   }
298 
299   /**
300   * @dev Returns whether the specified token exists
301   * @param _tokenId uint256 ID of the token to query the existance of
302   * @return whether the token exists
303   */
304   function exists(uint256 _tokenId) public view returns (bool) {
305     address owner = tokenOwner[_tokenId];
306     return owner != address(0);
307   }
308 
309   /**
310   * @dev Approves another address to transfer the given token ID
311   * @dev The zero address indicates there is no approved address.
312   * @dev There can only be one approved address per token at a given time.
313   * @dev Can only be called by the token owner or an approved operator.
314   * @param _to address to be approved for the given token ID
315   * @param _tokenId uint256 ID of the token to be approved
316   */
317   function approve(address _to, uint256 _tokenId) public {
318     address owner = ownerOf(_tokenId);
319     require(_to != owner);
320     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
321 
322     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
323       tokenApprovals[_tokenId] = _to;
324       Approval(owner, _to, _tokenId);
325     }
326   }
327 
328   /**
329    * @dev Gets the approved address for a token ID, or zero if no address set
330    * @param _tokenId uint256 ID of the token to query the approval of
331    * @return address currently approved for a the given token ID
332    */
333   function getApproved(uint256 _tokenId) public view returns (address) {
334     return tokenApprovals[_tokenId];
335   }
336 
337 
338   /**
339   * @dev Sets or unsets the approval of a given operator
340   * @dev An operator is allowed to transfer all tokens of the sender on their behalf
341   * @param _to operator address to set the approval
342   * @param _approved representing the status of the approval to be set
343   */
344   function setApprovalForAll(address _to, bool _approved) public {
345     require(_to != msg.sender);
346     operatorApprovals[msg.sender][_to] = _approved;
347     ApprovalForAll(msg.sender, _to, _approved);
348   }
349 
350   /**
351    * @dev Tells whether an operator is approved by a given owner
352    * @param _owner owner address which you want to query the approval of
353    * @param _operator operator address which you want to query the approval of
354    * @return bool whether the given operator is approved by the given owner
355    */
356   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
357     return operatorApprovals[_owner][_operator];
358   }
359 
360   /**
361   * @dev Transfers the ownership of a given token ID to another address
362   * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
363   * @dev Requires the msg sender to be the owner, approved, or operator
364   * @param _from current owner of the token
365   * @param _to address to receive the ownership of the given token ID
366   * @param _tokenId uint256 ID of the token to be transferred
367   */
368   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
369     require(_from != address(0));
370     require(_to != address(0));
371 
372     clearApproval(_from, _tokenId);
373     removeTokenFrom(_from, _tokenId);
374     addTokenTo(_to, _tokenId);
375     
376     Transfer(_from, _to, _tokenId);
377   }
378 
379   /**
380   * @dev Safely transfers the ownership of a given token ID to another address
381   * @dev If the target address is a contract, it must implement `onERC721Received`,
382   *  which is called upon a safe transfer, and return the magic value
383   *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
384   *  the transfer is reverted.
385   * @dev Requires the msg sender to be the owner, approved, or operator
386   * @param _from current owner of the token
387   * @param _to address to receive the ownership of the given token ID
388   * @param _tokenId uint256 ID of the token to be transferred
389   */
390   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
391     safeTransferFrom(_from, _to, _tokenId, "");
392   }
393 
394   /**
395   * @dev Safely transfers the ownership of a given token ID to another address
396   * @dev If the target address is a contract, it must implement `onERC721Received`,
397   *  which is called upon a safe transfer, and return the magic value
398   *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
399   *  the transfer is reverted.
400   * @dev Requires the msg sender to be the owner, approved, or operator
401   * @param _from current owner of the token
402   * @param _to address to receive the ownership of the given token ID
403   * @param _tokenId uint256 ID of the token to be transferred
404   * @param _data bytes data to send along with a safe transfer check
405   */
406   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public canTransfer(_tokenId) {
407     transferFrom(_from, _to, _tokenId);
408     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
409   }
410 
411   /**
412    * @dev Returns whether the given spender can transfer a given token ID
413    * @param _spender address of the spender to query
414    * @param _tokenId uint256 ID of the token to be transferred
415    * @return bool whether the msg.sender is approved for the given token ID,
416    *  is an operator of the owner, or is the owner of the token
417    */
418   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
419     address owner = ownerOf(_tokenId);
420     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
421   }
422 
423   /**
424   * @dev Internal function to mint a new token
425   * @dev Reverts if the given token ID already exists
426   * @param _to The address that will own the minted token
427   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
428   */
429   function _mint(address _to, uint256 _tokenId) internal {
430     require(_to != address(0));
431     addTokenTo(_to, _tokenId);
432     Transfer(address(0), _to, _tokenId);
433   }
434 
435   /**
436   * @dev Internal function to burn a specific token
437   * @dev Reverts if the token does not exist
438   * @param _tokenId uint256 ID of the token being burned by the msg.sender
439   */
440   function _burn(address _owner, uint256 _tokenId) internal {
441     clearApproval(_owner, _tokenId);
442     removeTokenFrom(_owner, _tokenId);
443     Transfer(_owner, address(0), _tokenId);
444   }
445 
446   /**
447   * @dev Internal function to clear current approval of a given token ID
448   * @dev Reverts if the given address is not indeed the owner of the token
449   * @param _owner owner of the token
450   * @param _tokenId uint256 ID of the token to be transferred
451   */
452   function clearApproval(address _owner, uint256 _tokenId) internal {
453     require(ownerOf(_tokenId) == _owner);
454     if (tokenApprovals[_tokenId] != address(0)) {
455       tokenApprovals[_tokenId] = address(0);
456       Approval(_owner, address(0), _tokenId);
457     }
458   }
459 
460   /**
461   * @dev Internal function to add a token ID to the list of a given address
462   * @param _to address representing the new owner of the given token ID
463   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
464   */
465   function addTokenTo(address _to, uint256 _tokenId) internal {
466     require(tokenOwner[_tokenId] == address(0));
467     tokenOwner[_tokenId] = _to;
468     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
469   }
470 
471   /**
472   * @dev Internal function to remove a token ID from the list of a given address
473   * @param _from address representing the previous owner of the given token ID
474   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
475   */
476   function removeTokenFrom(address _from, uint256 _tokenId) internal {
477     require(ownerOf(_tokenId) == _from);
478     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
479     tokenOwner[_tokenId] = address(0);
480   }
481 
482   /**
483   * @dev Internal function to invoke `onERC721Received` on a target address
484   * @dev The call is not executed if the target address is not a contract
485   * @param _from address representing the previous owner of the given token ID
486   * @param _to target address that will receive the tokens
487   * @param _tokenId uint256 ID of the token to be transferred
488   * @param _data bytes optional data to send along with the call
489   * @return whether the call correctly returned the expected magic value
490   */
491   function checkAndCallSafeTransfer(address _from, address _to, uint256 _tokenId, bytes _data) internal returns (bool) {
492     if (!_to.isContract()) {
493       return true;
494     }
495     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
496     return (retval == ERC721_RECEIVED);
497   }
498 }
499 
500 // File: contracts/zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
501 
502 /**
503  * @title Full ERC721 Token
504  * This implementation includes all the required and some optional functionality of the ERC721 standard
505  * Moreover, it includes approve all functionality using operator terminology
506  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
507  */
508 contract ERC721Token is ERC721, ERC721BasicToken {
509   // Token name
510   string internal name_;
511 
512   // Token symbol
513   string internal symbol_;
514 
515   // Mapping from owner to list of owned token IDs
516   mapping (address => uint256[]) internal ownedTokens;
517 
518   // Mapping from token ID to index of the owner tokens list
519   mapping(uint256 => uint256) internal ownedTokensIndex;
520 
521   // Array with all token ids, used for enumeration
522   uint256[] internal allTokens;
523 
524   // Mapping from token id to position in the allTokens array
525   mapping(uint256 => uint256) internal allTokensIndex;
526 
527   // Optional mapping for token URIs 
528   mapping(uint256 => string) internal tokenURIs;
529 
530   /**
531   * @dev Constructor function
532   */
533   function ERC721Token(string _name, string _symbol) public {
534     name_ = _name;
535     symbol_ = _symbol;
536   }
537 
538   /**
539   * @dev Gets the token name
540   * @return string representing the token name
541   */
542   function name() public view returns (string) {
543     return name_;
544   }
545 
546   /**
547   * @dev Gets the token symbol
548   * @return string representing the token symbol
549   */
550   function symbol() public view returns (string) {
551     return symbol_;
552   }
553 
554   /**
555   * @dev Returns an URI for a given token ID
556   * @dev Throws if the token ID does not exist. May return an empty string.
557   * @param _tokenId uint256 ID of the token to query
558   */
559   function tokenURI(uint256 _tokenId) public view returns (string) {
560     require(exists(_tokenId));
561     return tokenURIs[_tokenId];
562   }
563 
564   /**
565   * @dev Internal function to set the token URI for a given token
566   * @dev Reverts if the token ID does not exist
567   * @param _tokenId uint256 ID of the token to set its URI
568   * @param _uri string URI to assign
569   */
570   function _setTokenURI(uint256 _tokenId, string _uri) internal {
571     require(exists(_tokenId));
572     tokenURIs[_tokenId] = _uri;
573   }
574 
575   /**
576   * @dev Gets the token ID at a given index of the tokens list of the requested owner
577   * @param _owner address owning the tokens list to be accessed
578   * @param _index uint256 representing the index to be accessed of the requested tokens list
579   * @return uint256 token ID at the given index of the tokens list owned by the requested address
580   */
581   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
582     require(_index < balanceOf(_owner));
583     return ownedTokens[_owner][_index];
584   }
585 
586   /**
587   * @dev Gets the total amount of tokens stored by the contract
588   * @return uint256 representing the total amount of tokens
589   */
590   function totalSupply() public view returns (uint256) {
591     return allTokens.length;
592   }
593 
594   /**
595   * @dev Gets the token ID at a given index of all the tokens in this contract
596   * @dev Reverts if the index is greater or equal to the total number of tokens
597   * @param _index uint256 representing the index to be accessed of the tokens list
598   * @return uint256 token ID at the given index of the tokens list
599   */
600   function tokenByIndex(uint256 _index) public view returns (uint256) {
601     require(_index < totalSupply());
602     return allTokens[_index];
603   }
604 
605   /**
606   * @dev Internal function to add a token ID to the list of a given address
607   * @param _to address representing the new owner of the given token ID
608   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
609   */
610   function addTokenTo(address _to, uint256 _tokenId) internal {
611     super.addTokenTo(_to, _tokenId);
612     uint256 length = ownedTokens[_to].length;
613     ownedTokens[_to].push(_tokenId);
614     ownedTokensIndex[_tokenId] = length;
615   }
616 
617   /**
618   * @dev Internal function to remove a token ID from the list of a given address
619   * @param _from address representing the previous owner of the given token ID
620   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
621   */
622   function removeTokenFrom(address _from, uint256 _tokenId) internal {
623     super.removeTokenFrom(_from, _tokenId);
624 
625     uint256 tokenIndex = ownedTokensIndex[_tokenId];
626     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
627     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
628 
629     ownedTokens[_from][tokenIndex] = lastToken;
630     ownedTokens[_from][lastTokenIndex] = 0;
631     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
632     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
633     // the lastToken to the first position, and then dropping the element placed in the last position of the list
634 
635     ownedTokens[_from].length--;
636     ownedTokensIndex[_tokenId] = 0;
637     ownedTokensIndex[lastToken] = tokenIndex;
638   }
639 
640   /**
641   * @dev Internal function to mint a new token
642   * @dev Reverts if the given token ID already exists
643   * @param _to address the beneficiary that will own the minted token
644   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
645   */
646   function _mint(address _to, uint256 _tokenId) internal {
647     super._mint(_to, _tokenId);
648     
649     allTokensIndex[_tokenId] = allTokens.length;
650     allTokens.push(_tokenId);
651   }
652 
653   /**
654   * @dev Internal function to burn a specific token
655   * @dev Reverts if the token does not exist
656   * @param _owner owner of the token to burn
657   * @param _tokenId uint256 ID of the token being burned by the msg.sender
658   */
659   function _burn(address _owner, uint256 _tokenId) internal {
660     super._burn(_owner, _tokenId);
661 
662     // Clear metadata (if any)
663     if (bytes(tokenURIs[_tokenId]).length != 0) {
664       delete tokenURIs[_tokenId];
665     }
666 
667     // Reorg all tokens array
668     uint256 tokenIndex = allTokensIndex[_tokenId];
669     uint256 lastTokenIndex = allTokens.length.sub(1);
670     uint256 lastToken = allTokens[lastTokenIndex];
671 
672     allTokens[tokenIndex] = lastToken;
673     allTokens[lastTokenIndex] = 0;
674 
675     allTokens.length--;
676     allTokensIndex[_tokenId] = 0;
677     allTokensIndex[lastToken] = tokenIndex;
678   }
679 
680 }
681 
682 // File: contracts/CrystalBase.sol
683 
684 // @title CrystalBase
685 // @author Takayuki Jimba
686 // @dev ERC721 token.
687 //      mint, burn and transferFrom are supposed to be called from CryptoCrystal contract only.
688 contract CrystalBase is Acceptable, ERC721Token {
689 
690     // Each of Crystal occupies 3 slots.
691     struct Crystal {
692         /* slot1 */
693 
694         uint256 tokenId;
695 
696         /* slot2 */
697         uint256 gene;
698 
699         /* slot3 */
700 
701         // kind is between 0 and 100.
702         // 2^8 = 256 is adequate.
703         uint8 kind;
704 
705         // totalWeight of cryptocrystals is 21 * 10**13.
706         // 2^128 = 3.4028237e+38 is adequate.
707         uint128 weight;
708 
709         // unix timestamp
710         uint64 mintedAt;
711     }
712 
713     mapping(uint256 => Crystal) internal tokenIdToCrystal;
714     event CrystalBurned(address indexed owner, uint256 tokenId);
715     event CrystalMinted(address indexed owner, uint256 tokenId, uint256 gene, uint256 kind, uint256 weight);
716 
717     uint256 currentTokenId = 1;
718 
719     constructor() ERC721Token("CryptoCrystal", "CC") public {
720 
721     }
722 
723     function mint(
724         address _owner,
725         uint256 _gene,
726         uint256 _kind,
727         uint256 _weight
728     ) public onlyAcceptable returns(uint256) {
729         require(_gene > 0);
730         require(_weight > 0);
731 
732         uint256 _tokenId = currentTokenId;
733         currentTokenId++;
734         super._mint(_owner, _tokenId);
735         Crystal memory _crystal = Crystal({
736             tokenId: _tokenId,
737             gene: _gene,
738             kind: uint8(_kind),
739             weight: uint128(_weight),
740             mintedAt: uint64(now)
741             });
742         tokenIdToCrystal[_tokenId] = _crystal;
743         emit CrystalMinted(_owner, _tokenId, _gene, _kind, _weight);
744         return _tokenId;
745     }
746 
747     function burn(address _owner, uint256 _tokenId) public onlyAcceptable {
748         require(ownerOf(_tokenId) == _owner);
749 
750         delete tokenIdToCrystal[_tokenId];
751         super._burn(_owner, _tokenId);
752         emit CrystalBurned(_owner, _tokenId);
753     }
754 
755     // @dev Transfers the ownership of a given token ID to another address.
756     //      _transferFrom is almost the same to openzeppelin-solidity's implementation.
757     //      ref. https://github.com/OpenZeppelin/openzeppelin-solidity/blob/ad12381549c4c0711c2f3310e9fb1f65d51c299c/contracts/token/ERC721/ERC721BasicToken.sol#L140
758     //      We use onlyAcceptable modifier instead of canTransfer.
759     //      _transferFrom is intended to be called only from cryptocrystal contract.
760     // @param _from owner of the token
761     // @param _to address to receive the ownership of the given token ID
762     // @param _tokenId uint256 ID of the token to be transferred
763     function _transferFrom(address _from, address _to, uint256 _tokenId) public onlyAcceptable {
764         require(ownerOf(_tokenId) == _from);
765         require(_to != address(0));
766 
767         clearApproval(_from, _tokenId);
768         removeTokenFrom(_from, _tokenId);
769         addTokenTo(_to, _tokenId);
770 
771         emit Transfer(_from, _to, _tokenId);
772     }
773 
774     function getCrystalKindWeight(uint256 _tokenId) public onlyAcceptable view returns(
775         uint256 kind,
776         uint256 weight
777     ) {
778         require(exists(_tokenId));
779 
780         Crystal memory _crystal = tokenIdToCrystal[_tokenId];
781         kind = _crystal.kind;
782         weight = _crystal.weight;
783     }
784 
785     function getCrystalGeneKindWeight(uint256 _tokenId) public onlyAcceptable view returns(
786         uint256 gene,
787         uint256 kind,
788         uint256 weight
789     ) {
790         require(exists(_tokenId));
791 
792         Crystal memory _crystal = tokenIdToCrystal[_tokenId];
793         gene = _crystal.gene;
794         kind = _crystal.kind;
795         weight = _crystal.weight;
796     }
797 
798     function getCrystal(uint256 _tokenId) external view returns(
799         address owner,
800         uint256 gene,
801         uint256 kind,
802         uint256 weight,
803         uint256 mintedAt
804     ) {
805         require(exists(_tokenId));
806 
807         Crystal memory _crystal = tokenIdToCrystal[_tokenId];
808 
809         owner = ownerOf(_tokenId);
810         gene = _crystal.gene;
811         kind = _crystal.kind;
812         weight = _crystal.weight;
813         mintedAt = _crystal.mintedAt;
814     }
815 
816     function getCrystalsSummary(address _owner) external view returns(
817         uint256[] amounts,
818         uint256[] weights
819     ) {
820         amounts = new uint256[](100);
821         weights = new uint256[](100);
822         uint256 _tokenCount = ownedTokensCount[_owner];
823         for (uint256 i = 0; i < _tokenCount; i++) {
824             uint256 _tokenId = ownedTokens[_owner][i];
825             Crystal memory _crystal = tokenIdToCrystal[_tokenId];
826             amounts[_crystal.kind] = amounts[_crystal.kind].add(1);
827             weights[_crystal.kind] = weights[_crystal.kind].add(_crystal.weight);
828         }
829     }
830 
831     function getCrystals(address _owner) external view returns(
832         uint256[] tokenIds,
833         uint256[] genes,
834         uint256[] kinds,
835         uint256[] weights,
836         uint256[] mintedAts
837     ) {
838         uint256 _tokenCount = ownedTokensCount[_owner];
839         tokenIds = new uint256[](_tokenCount);
840         genes = new uint256[](_tokenCount);
841         kinds = new uint256[](_tokenCount);
842         weights = new uint256[](_tokenCount);
843         mintedAts = new uint256[](_tokenCount);
844         for (uint256 i = 0; i < _tokenCount; i++) {
845             uint256 _tokenId = ownedTokens[_owner][i];
846             Crystal memory _crystal = tokenIdToCrystal[_tokenId];
847             tokenIds[i] = _tokenId;
848             genes[i] = _crystal.gene;
849             kinds[i] = _crystal.kind;
850             weights[i] = _crystal.weight;
851             mintedAts[i] = _crystal.mintedAt;
852         }
853     }
854 
855     function getCrystalsByKind(address _owner, uint256 _kind) external view returns(
856         uint256[] tokenIds,
857         uint256[] genes,
858         uint256[] weights,
859         uint256[] mintedAts
860     ) {
861         require(_kind < 100);
862 
863         uint256 _tokenCount = ownedTokensCount[_owner];
864         tokenIds = new uint256[](_tokenCount);
865         genes = new uint256[](_tokenCount);
866         weights = new uint256[](_tokenCount);
867         mintedAts = new uint256[](_tokenCount);
868         uint256 index;
869         for (uint256 i = 0; i < _tokenCount; i++) {
870             uint256 _tokenId = ownedTokens[_owner][i];
871             Crystal memory _crystal = tokenIdToCrystal[_tokenId];
872             if (_crystal.kind == _kind) {
873                 tokenIds[index] = _tokenId;
874                 genes[index] = _crystal.gene;
875                 weights[index] = _crystal.weight;
876                 mintedAts[i] = _crystal.mintedAt;
877                 index = index.add(1);
878             }
879         }
880     }
881 }