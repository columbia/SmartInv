1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   constructor() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     emit OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * @title Pausable
45  * @dev Base contract which allows children to implement an emergency stop mechanism.
46  */
47 contract Pausable is Ownable {
48   event Pause();
49   event Unpause();
50 
51   bool public paused = false;
52 
53 
54   /**
55    * @dev Modifier to make a function callable only when the contract is not paused.
56    */
57   modifier whenNotPaused() {
58     require(!paused);
59     _;
60   }
61 
62   /**
63    * @dev Modifier to make a function callable only when the contract is paused.
64    */
65   modifier whenPaused() {
66     require(paused);
67     _;
68   }
69 
70   /**
71    * @dev called by the owner to pause, triggers stopped state
72    */
73   function pause() onlyOwner whenNotPaused public {
74     paused = true;
75     emit Pause();
76   }
77 
78   /**
79    * @dev called by the owner to unpause, returns to normal state
80    */
81   function unpause() onlyOwner whenPaused public {
82     paused = false;
83     emit Unpause();
84   }
85 }
86 
87 /**
88  * @title ERC721 Non-Fungible Token Standard basic interface
89  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
90  */
91 contract ERC721Basic {
92   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
93   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
94   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
95 
96   function balanceOf(address _owner) public view returns (uint256 _balance);
97   function ownerOf(uint256 _tokenId) public view returns (address _owner);
98   function exists(uint256 _tokenId) public view returns (bool _exists);
99 
100   function approve(address _to, uint256 _tokenId) public;
101   function getApproved(uint256 _tokenId) public view returns (address _operator);
102 
103   function setApprovalForAll(address _operator, bool _approved) public;
104   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
105 
106   function transferFrom(address _from, address _to, uint256 _tokenId) public;
107   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
108   function safeTransferFrom(
109     address _from,
110     address _to,
111     uint256 _tokenId,
112     bytes _data
113   )
114     public;
115 }
116 
117 /**
118  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
119  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
120  */
121 contract ERC721Enumerable is ERC721Basic {
122   function totalSupply() public view returns (uint256);
123   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
124   function tokenByIndex(uint256 _index) public view returns (uint256);
125 }
126 
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
138 
139 /**
140  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
141  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
142  */
143 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
144 }
145 
146 /**
147  * Utility library of inline functions on addresses
148  */
149 library AddressUtils {
150 
151   /**
152    * Returns whether the target address is a contract
153    * @dev This function will return false if invoked during the constructor of a contract,
154    *  as the code is not actually created until after the constructor finishes.
155    * @param addr address to check
156    * @return whether the target address is a contract
157    */
158   function isContract(address addr) internal view returns (bool) {
159     uint256 size;
160     // XXX Currently there is no better way to check if there is a contract in an address
161     // than to check the size of the code at that address.
162     // See https://ethereum.stackexchange.com/a/14016/36603
163     // for more details about how this works.
164     // TODO Check this again before the Serenity release, because all addresses will be
165     // contracts then.
166     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
167     return size > 0;
168   }
169 
170 }
171 
172 /**
173  * @title SafeMath
174  * @dev Math operations with safety checks that throw on error
175  */
176 library SafeMath {
177 
178   /**
179   * @dev Multiplies two numbers, throws on overflow.
180   */
181   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
182     if (a == 0) {
183       return 0;
184     }
185     c = a * b;
186     assert(c / a == b);
187     return c;
188   }
189 
190   /**
191   * @dev Integer division of two numbers, truncating the quotient.
192   */
193   function div(uint256 a, uint256 b) internal pure returns (uint256) {
194     // assert(b > 0); // Solidity automatically throws when dividing by 0
195     // uint256 c = a / b;
196     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197     return a / b;
198   }
199 
200   /**
201   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
202   */
203   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
204     assert(b <= a);
205     return a - b;
206   }
207 
208   /**
209   * @dev Adds two numbers, throws on overflow.
210   */
211   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
212     c = a + b;
213     assert(c >= a);
214     return c;
215   }
216 }
217 
218 /**
219  * @title ERC721 token receiver interface
220  * @dev Interface for any contract that wants to support safeTransfers
221  *  from ERC721 asset contracts.
222  */
223 contract ERC721Receiver {
224   /**
225    * @dev Magic value to be returned upon successful reception of an NFT
226    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
227    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
228    */
229   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
230 
231   /**
232    * @notice Handle the receipt of an NFT
233    * @dev The ERC721 smart contract calls this function on the recipient
234    *  after a `safetransfer`. This function MAY throw to revert and reject the
235    *  transfer. This function MUST use 50,000 gas or less. Return of other
236    *  than the magic value MUST result in the transaction being reverted.
237    *  Note: the contract address is always the message sender.
238    * @param _from The sending address
239    * @param _tokenId The NFT identifier which is being transfered
240    * @param _data Additional data with no specified format
241    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
242    */
243   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
244 }
245 
246 /**
247  * @title ERC721 Non-Fungible Token Standard basic implementation
248  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
249  */
250 contract ERC721BasicToken is ERC721Basic {
251   using SafeMath for uint256;
252   using AddressUtils for address;
253 
254   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
255   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
256   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
257 
258   // Mapping from token ID to owner
259   mapping (uint256 => address) internal tokenOwner;
260 
261   // Mapping from token ID to approved address
262   mapping (uint256 => address) internal tokenApprovals;
263 
264   // Mapping from owner to number of owned token
265   mapping (address => uint256) internal ownedTokensCount;
266 
267   // Mapping from owner to operator approvals
268   mapping (address => mapping (address => bool)) internal operatorApprovals;
269 
270   /**
271    * @dev Guarantees msg.sender is owner of the given token
272    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
273    */
274   modifier onlyOwnerOf(uint256 _tokenId) {
275     require(ownerOf(_tokenId) == msg.sender);
276     _;
277   }
278 
279   /**
280    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
281    * @param _tokenId uint256 ID of the token to validate
282    */
283   modifier canTransfer(uint256 _tokenId) {
284     require(isApprovedOrOwner(msg.sender, _tokenId));
285     _;
286   }
287 
288   /**
289    * @dev Gets the balance of the specified address
290    * @param _owner address to query the balance of
291    * @return uint256 representing the amount owned by the passed address
292    */
293   function balanceOf(address _owner) public view returns (uint256) {
294     require(_owner != address(0));
295     return ownedTokensCount[_owner];
296   }
297 
298   /**
299    * @dev Gets the owner of the specified token ID
300    * @param _tokenId uint256 ID of the token to query the owner of
301    * @return owner address currently marked as the owner of the given token ID
302    */
303   function ownerOf(uint256 _tokenId) public view returns (address) {
304     address owner = tokenOwner[_tokenId];
305     require(owner != address(0));
306     return owner;
307   }
308 
309   /**
310    * @dev Returns whether the specified token exists
311    * @param _tokenId uint256 ID of the token to query the existance of
312    * @return whether the token exists
313    */
314   function exists(uint256 _tokenId) public view returns (bool) {
315     address owner = tokenOwner[_tokenId];
316     return owner != address(0);
317   }
318 
319   /**
320    * @dev Approves another address to transfer the given token ID
321    * @dev The zero address indicates there is no approved address.
322    * @dev There can only be one approved address per token at a given time.
323    * @dev Can only be called by the token owner or an approved operator.
324    * @param _to address to be approved for the given token ID
325    * @param _tokenId uint256 ID of the token to be approved
326    */
327   function approve(address _to, uint256 _tokenId) public {
328     address owner = ownerOf(_tokenId);
329     require(_to != owner);
330     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
331 
332     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
333       tokenApprovals[_tokenId] = _to;
334       emit Approval(owner, _to, _tokenId);
335     }
336   }
337 
338   /**
339    * @dev Gets the approved address for a token ID, or zero if no address set
340    * @param _tokenId uint256 ID of the token to query the approval of
341    * @return address currently approved for a the given token ID
342    */
343   function getApproved(uint256 _tokenId) public view returns (address) {
344     return tokenApprovals[_tokenId];
345   }
346 
347   /**
348    * @dev Sets or unsets the approval of a given operator
349    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
350    * @param _to operator address to set the approval
351    * @param _approved representing the status of the approval to be set
352    */
353   function setApprovalForAll(address _to, bool _approved) public {
354     require(_to != msg.sender);
355     operatorApprovals[msg.sender][_to] = _approved;
356     emit ApprovalForAll(msg.sender, _to, _approved);
357   }
358 
359   /**
360    * @dev Tells whether an operator is approved by a given owner
361    * @param _owner owner address which you want to query the approval of
362    * @param _operator operator address which you want to query the approval of
363    * @return bool whether the given operator is approved by the given owner
364    */
365   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
366     return operatorApprovals[_owner][_operator];
367   }
368 
369   /**
370    * @dev Transfers the ownership of a given token ID to another address
371    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
372    * @dev Requires the msg sender to be the owner, approved, or operator
373    * @param _from current owner of the token
374    * @param _to address to receive the ownership of the given token ID
375    * @param _tokenId uint256 ID of the token to be transferred
376   */
377   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
378     require(_from != address(0));
379     require(_to != address(0));
380 
381     clearApproval(_from, _tokenId);
382     removeTokenFrom(_from, _tokenId);
383     addTokenTo(_to, _tokenId);
384 
385     emit Transfer(_from, _to, _tokenId);
386   }
387 
388   /**
389    * @dev Safely transfers the ownership of a given token ID to another address
390    * @dev If the target address is a contract, it must implement `onERC721Received`,
391    *  which is called upon a safe transfer, and return the magic value
392    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
393    *  the transfer is reverted.
394    * @dev Requires the msg sender to be the owner, approved, or operator
395    * @param _from current owner of the token
396    * @param _to address to receive the ownership of the given token ID
397    * @param _tokenId uint256 ID of the token to be transferred
398   */
399   function safeTransferFrom(
400     address _from,
401     address _to,
402     uint256 _tokenId
403   )
404     public
405     canTransfer(_tokenId)
406   {
407     // solium-disable-next-line arg-overflow
408     safeTransferFrom(_from, _to, _tokenId, "");
409   }
410 
411   /**
412    * @dev Safely transfers the ownership of a given token ID to another address
413    * @dev If the target address is a contract, it must implement `onERC721Received`,
414    *  which is called upon a safe transfer, and return the magic value
415    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
416    *  the transfer is reverted.
417    * @dev Requires the msg sender to be the owner, approved, or operator
418    * @param _from current owner of the token
419    * @param _to address to receive the ownership of the given token ID
420    * @param _tokenId uint256 ID of the token to be transferred
421    * @param _data bytes data to send along with a safe transfer check
422    */
423   function safeTransferFrom(
424     address _from,
425     address _to,
426     uint256 _tokenId,
427     bytes _data
428   )
429     public
430     canTransfer(_tokenId)
431   {
432     transferFrom(_from, _to, _tokenId);
433     // solium-disable-next-line arg-overflow
434     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
435   }
436 
437   /**
438    * @dev Returns whether the given spender can transfer a given token ID
439    * @param _spender address of the spender to query
440    * @param _tokenId uint256 ID of the token to be transferred
441    * @return bool whether the msg.sender is approved for the given token ID,
442    *  is an operator of the owner, or is the owner of the token
443    */
444   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
445     address owner = ownerOf(_tokenId);
446     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
447   }
448 
449   /**
450    * @dev Internal function to mint a new token
451    * @dev Reverts if the given token ID already exists
452    * @param _to The address that will own the minted token
453    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
454    */
455   function _mint(address _to, uint256 _tokenId) internal {
456     require(_to != address(0));
457     addTokenTo(_to, _tokenId);
458     emit Transfer(address(0), _to, _tokenId);
459   }
460 
461   /**
462    * @dev Internal function to burn a specific token
463    * @dev Reverts if the token does not exist
464    * @param _tokenId uint256 ID of the token being burned by the msg.sender
465    */
466   function _burn(address _owner, uint256 _tokenId) internal {
467     clearApproval(_owner, _tokenId);
468     removeTokenFrom(_owner, _tokenId);
469     emit Transfer(_owner, address(0), _tokenId);
470   }
471 
472   /**
473    * @dev Internal function to clear current approval of a given token ID
474    * @dev Reverts if the given address is not indeed the owner of the token
475    * @param _owner owner of the token
476    * @param _tokenId uint256 ID of the token to be transferred
477    */
478   function clearApproval(address _owner, uint256 _tokenId) internal {
479     require(ownerOf(_tokenId) == _owner);
480     if (tokenApprovals[_tokenId] != address(0)) {
481       tokenApprovals[_tokenId] = address(0);
482       emit Approval(_owner, address(0), _tokenId);
483     }
484   }
485 
486   /**
487    * @dev Internal function to add a token ID to the list of a given address
488    * @param _to address representing the new owner of the given token ID
489    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
490    */
491   function addTokenTo(address _to, uint256 _tokenId) internal {
492     require(tokenOwner[_tokenId] == address(0));
493     tokenOwner[_tokenId] = _to;
494     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
495   }
496 
497   /**
498    * @dev Internal function to remove a token ID from the list of a given address
499    * @param _from address representing the previous owner of the given token ID
500    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
501    */
502   function removeTokenFrom(address _from, uint256 _tokenId) internal {
503     require(ownerOf(_tokenId) == _from);
504     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
505     tokenOwner[_tokenId] = address(0);
506   }
507 
508   /**
509    * @dev Internal function to invoke `onERC721Received` on a target address
510    * @dev The call is not executed if the target address is not a contract
511    * @param _from address representing the previous owner of the given token ID
512    * @param _to target address that will receive the tokens
513    * @param _tokenId uint256 ID of the token to be transferred
514    * @param _data bytes optional data to send along with the call
515    * @return whether the call correctly returned the expected magic value
516    */
517   function checkAndCallSafeTransfer(
518     address _from,
519     address _to,
520     uint256 _tokenId,
521     bytes _data
522   )
523     internal
524     returns (bool)
525   {
526     if (!_to.isContract()) {
527       return true;
528     }
529     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
530     return (retval == ERC721_RECEIVED);
531   }
532 }
533 
534 /**
535  * @title Full ERC721 Token
536  * This implementation includes all the required and some optional functionality of the ERC721 standard
537  * Moreover, it includes approve all functionality using operator terminology
538  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
539  */
540 contract ERC721Token is ERC721, ERC721BasicToken {
541   // Token name
542   string internal name_;
543 
544   // Token symbol
545   string internal symbol_;
546 
547   // Mapping from owner to list of owned token IDs
548   mapping (address => uint256[]) internal ownedTokens;
549 
550   // Mapping from token ID to index of the owner tokens list
551   mapping(uint256 => uint256) internal ownedTokensIndex;
552 
553   // Array with all token ids, used for enumeration
554   uint256[] internal allTokens;
555 
556   // Mapping from token id to position in the allTokens array
557   mapping(uint256 => uint256) internal allTokensIndex;
558 
559   // Optional mapping for token URIs
560   mapping(uint256 => string) internal tokenURIs;
561 
562   /**
563    * @dev Constructor function
564    */
565   constructor(string _name, string _symbol) public {
566     name_ = _name;
567     symbol_ = _symbol;
568   }
569 
570   /**
571    * @dev Gets the token name
572    * @return string representing the token name
573    */
574   function name() public view returns (string) {
575     return name_;
576   }
577 
578   /**
579    * @dev Gets the token symbol
580    * @return string representing the token symbol
581    */
582   function symbol() public view returns (string) {
583     return symbol_;
584   }
585 
586   /**
587    * @dev Returns an URI for a given token ID
588    * @dev Throws if the token ID does not exist. May return an empty string.
589    * @param _tokenId uint256 ID of the token to query
590    */
591   function tokenURI(uint256 _tokenId) public view returns (string) {
592     require(exists(_tokenId));
593     return tokenURIs[_tokenId];
594   }
595 
596   /**
597    * @dev Gets the token ID at a given index of the tokens list of the requested owner
598    * @param _owner address owning the tokens list to be accessed
599    * @param _index uint256 representing the index to be accessed of the requested tokens list
600    * @return uint256 token ID at the given index of the tokens list owned by the requested address
601    */
602   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
603     require(_index < balanceOf(_owner));
604     return ownedTokens[_owner][_index];
605   }
606 
607   /**
608    * @dev Gets the total amount of tokens stored by the contract
609    * @return uint256 representing the total amount of tokens
610    */
611   function totalSupply() public view returns (uint256) {
612     return allTokens.length;
613   }
614 
615   /**
616    * @dev Gets the token ID at a given index of all the tokens in this contract
617    * @dev Reverts if the index is greater or equal to the total number of tokens
618    * @param _index uint256 representing the index to be accessed of the tokens list
619    * @return uint256 token ID at the given index of the tokens list
620    */
621   function tokenByIndex(uint256 _index) public view returns (uint256) {
622     require(_index < totalSupply());
623     return allTokens[_index];
624   }
625 
626   /**
627    * @dev Internal function to set the token URI for a given token
628    * @dev Reverts if the token ID does not exist
629    * @param _tokenId uint256 ID of the token to set its URI
630    * @param _uri string URI to assign
631    */
632   function _setTokenURI(uint256 _tokenId, string _uri) internal {
633     require(exists(_tokenId));
634     tokenURIs[_tokenId] = _uri;
635   }
636 
637   /**
638    * @dev Internal function to add a token ID to the list of a given address
639    * @param _to address representing the new owner of the given token ID
640    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
641    */
642   function addTokenTo(address _to, uint256 _tokenId) internal {
643     super.addTokenTo(_to, _tokenId);
644     uint256 length = ownedTokens[_to].length;
645     ownedTokens[_to].push(_tokenId);
646     ownedTokensIndex[_tokenId] = length;
647   }
648 
649   /**
650    * @dev Internal function to remove a token ID from the list of a given address
651    * @param _from address representing the previous owner of the given token ID
652    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
653    */
654   function removeTokenFrom(address _from, uint256 _tokenId) internal {
655     super.removeTokenFrom(_from, _tokenId);
656 
657     uint256 tokenIndex = ownedTokensIndex[_tokenId];
658     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
659     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
660 
661     ownedTokens[_from][tokenIndex] = lastToken;
662     ownedTokens[_from][lastTokenIndex] = 0;
663     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
664     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
665     // the lastToken to the first position, and then dropping the element placed in the last position of the list
666 
667     ownedTokens[_from].length--;
668     ownedTokensIndex[_tokenId] = 0;
669     ownedTokensIndex[lastToken] = tokenIndex;
670   }
671 
672   /**
673    * @dev Internal function to mint a new token
674    * @dev Reverts if the given token ID already exists
675    * @param _to address the beneficiary that will own the minted token
676    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
677    */
678   function _mint(address _to, uint256 _tokenId) internal {
679     super._mint(_to, _tokenId);
680 
681     allTokensIndex[_tokenId] = allTokens.length;
682     allTokens.push(_tokenId);
683   }
684 
685   /**
686    * @dev Internal function to burn a specific token
687    * @dev Reverts if the token does not exist
688    * @param _owner owner of the token to burn
689    * @param _tokenId uint256 ID of the token being burned by the msg.sender
690    */
691   function _burn(address _owner, uint256 _tokenId) internal {
692     super._burn(_owner, _tokenId);
693 
694     // Clear metadata (if any)
695     if (bytes(tokenURIs[_tokenId]).length != 0) {
696       delete tokenURIs[_tokenId];
697     }
698 
699     // Reorg all tokens array
700     uint256 tokenIndex = allTokensIndex[_tokenId];
701     uint256 lastTokenIndex = allTokens.length.sub(1);
702     uint256 lastToken = allTokens[lastTokenIndex];
703 
704     allTokens[tokenIndex] = lastToken;
705     allTokens[lastTokenIndex] = 0;
706 
707     allTokens.length--;
708     allTokensIndex[_tokenId] = 0;
709     allTokensIndex[lastToken] = tokenIndex;
710   }
711 
712 }
713 
714 /**
715 * @title TraxionDeed 
716 * @dev Traxion Pre ICO deed of sale
717 *
718 */
719 
720 contract TraxionDeed is ERC721Token, Pausable {
721 
722     using SafeMath for uint256;
723 
724     uint256 public constant rate = 1000;
725     uint256 public weiRaised;
726     uint256 public iouTokens;
727 
728     constructor(string name, string symbol) public
729     ERC721Token(name, symbol)
730     { }    
731 
732     /** @dev Modified Pausable.sol from https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/lifecycle/Pausable.sol 
733         Purpose of this is to prevent unecessary burning of deed of sale during pre-ICO stage.
734     ***/
735 
736     event MainICO();
737     
738     bool public main_sale = false;
739 
740    /**
741    * @dev Modifier to make a function callable only when during Pre-ICO.
742    */
743     modifier isPreICO() {
744         require(!main_sale);
745         _;
746     }    
747     
748    /**
749    * @dev Modifier to make a function callable only when during Main-ICO.
750    */
751     modifier isMainICO() {
752         require(main_sale);
753         _;
754     }
755 
756    /**
757    * @dev called by the owner to initialize Main-ICO
758    */
759     function mainICO() public onlyOwner isPreICO {
760         main_sale = true;
761         emit MainICO();
762     }
763 
764     /*** @dev Traxion Deed of Sale Metadata ***/
765     struct Token {
766         address mintedFor;
767         uint64 mintedAt;
768         uint256 tokenAmount;
769         uint256 weiAmount;
770     }
771 
772     Token[] public tokens;
773 
774     function tokensOf(address _owner) public view returns (uint256[]) {
775         return ownedTokens[_owner];
776     }    
777 
778     /*** @dev function to create Deed of Sale ***/
779 
780     function buyTokens(address beneficiary, uint256 weiAmt) public onlyOwner whenNotPaused {
781         require(beneficiary != address(0));
782         require(weiAmt != 0);
783 
784         uint256 _tokenamount = weiAmt.mul(rate);
785 
786         mint(beneficiary, _tokenamount, weiAmt);
787     }
788 
789     /*** @dev function to burn the deed and swap it to Traxion Tokens ***/
790 
791     function burn(uint256 _tokenId) public isMainICO {
792         super._burn(ownerOf(_tokenId), _tokenId);
793     }
794 
795     function mint(address _to, uint256 value, uint256 weiAmt) internal returns (uint256 _tokenId) {
796 
797         weiRaised = weiRaised.add(weiAmt);
798         iouTokens = iouTokens.add(value);
799 
800         _tokenId = tokens.push(Token({
801                         mintedFor: _to,
802                         mintedAt: uint64(now),
803                         tokenAmount: value,
804                         weiAmount: weiAmt
805                     })) - 1;
806                     
807         super._mint(_to, _tokenId);
808     }
809 
810 }
811 //Github: @AlvinVeroy