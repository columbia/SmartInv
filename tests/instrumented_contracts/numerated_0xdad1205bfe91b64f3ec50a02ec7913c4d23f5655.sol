1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58 
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   function Ownable() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     emit OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 
90 
91 /**
92  * @title ERC721 Non-Fungible Token Standard basic interface
93  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
94  */
95 contract ERC721Basic {
96   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
97   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
98   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
99 
100   function balanceOf(address _owner) public view returns (uint256 _balance);
101   function ownerOf(uint256 _tokenId) public view returns (address _owner);
102   function exists(uint256 _tokenId) public view returns (bool _exists);
103 
104   function approve(address _to, uint256 _tokenId) public;
105   function getApproved(uint256 _tokenId) public view returns (address _operator);
106 
107   function setApprovalForAll(address _operator, bool _approved) public;
108   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
109 
110   function transferFrom(address _from, address _to, uint256 _tokenId) public;
111   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
112   function safeTransferFrom(
113     address _from,
114     address _to,
115     uint256 _tokenId,
116     bytes _data
117   )
118     public;
119 }
120 
121 
122 /**
123  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
124  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
125  */
126 contract ERC721Enumerable is ERC721Basic {
127   function totalSupply() public view returns (uint256);
128   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
129   function tokenByIndex(uint256 _index) public view returns (uint256);
130 }
131 
132 
133 /**
134  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
135  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
136  */
137 contract ERC721Metadata is ERC721Basic {
138   function name() public view returns (string _name);
139   function symbol() public view returns (string _symbol);
140   function tokenURI(uint256 _tokenId) public view returns (string);
141 }
142 
143 
144 /**
145  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
146  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
147  */
148 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
149 }
150 
151 pragma solidity ^0.4.21;
152 
153 
154 /**
155  * @title ERC721 token receiver interface
156  * @dev Interface for any contract that wants to support safeTransfers
157  *  from ERC721 asset contracts.
158  */
159 contract ERC721Receiver {
160   /**
161    * @dev Magic value to be returned upon successful reception of an NFT
162    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
163    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
164    */
165   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
166 
167   /**
168    * @notice Handle the receipt of an NFT
169    * @dev The ERC721 smart contract calls this function on the recipient
170    *  after a `safetransfer`. This function MAY throw to revert and reject the
171    *  transfer. This function MUST use 50,000 gas or less. Return of other
172    *  than the magic value MUST result in the transaction being reverted.
173    *  Note: the contract address is always the message sender.
174    * @param _from The sending address
175    * @param _tokenId The NFT identifier which is being transfered
176    * @param _data Additional data with no specified format
177    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
178    */
179   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
180 }
181 pragma solidity ^0.4.21;
182 
183 
184 /**
185  * Utility library of inline functions on addresses
186  */
187 library AddressUtils {
188 
189   /**
190    * Returns whether the target address is a contract
191    * @dev This function will return false if invoked during the constructor of a contract,
192    *  as the code is not actually created until after the constructor finishes.
193    * @param addr address to check
194    * @return whether the target address is a contract
195    */
196   function isContract(address addr) internal view returns (bool) {
197     uint256 size;
198     // XXX Currently there is no better way to check if there is a contract in an address
199     // than to check the size of the code at that address.
200     // See https://ethereum.stackexchange.com/a/14016/36603
201     // for more details about how this works.
202     // TODO Check this again before the Serenity release, because all addresses will be
203     // contracts then.
204     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
205     return size > 0;
206   }
207 
208 }
209 
210 
211 /**
212  * @title ERC721 Non-Fungible Token Standard basic implementation
213  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
214  */
215 contract ERC721BasicToken is ERC721Basic {
216   using SafeMath for uint256;
217   using AddressUtils for address;
218 
219   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
220   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
221   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
222 
223   // Mapping from token ID to owner
224   mapping (uint256 => address) internal tokenOwner;
225 
226   // Mapping from token ID to approved address
227   mapping (uint256 => address) internal tokenApprovals;
228 
229   // Mapping from owner to number of owned token
230   mapping (address => uint256) internal ownedTokensCount;
231 
232   // Mapping from owner to operator approvals
233   mapping (address => mapping (address => bool)) internal operatorApprovals;
234 
235   /**
236    * @dev Guarantees msg.sender is owner of the given token
237    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
238    */
239   modifier onlyOwnerOf(uint256 _tokenId) {
240     require(ownerOf(_tokenId) == msg.sender);
241     _;
242   }
243 
244   /**
245    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
246    * @param _tokenId uint256 ID of the token to validate
247    */
248   modifier canTransfer(uint256 _tokenId) {
249     require(isApprovedOrOwner(msg.sender, _tokenId));
250     _;
251   }
252 
253   /**
254    * @dev Gets the balance of the specified address
255    * @param _owner address to query the balance of
256    * @return uint256 representing the amount owned by the passed address
257    */
258   function balanceOf(address _owner) public view returns (uint256) {
259     require(_owner != address(0));
260     return ownedTokensCount[_owner];
261   }
262 
263   /**
264    * @dev Gets the owner of the specified token ID
265    * @param _tokenId uint256 ID of the token to query the owner of
266    * @return owner address currently marked as the owner of the given token ID
267    */
268   function ownerOf(uint256 _tokenId) public view returns (address) {
269     address owner = tokenOwner[_tokenId];
270     require(owner != address(0));
271     return owner;
272   }
273 
274   /**
275    * @dev Returns whether the specified token exists
276    * @param _tokenId uint256 ID of the token to query the existance of
277    * @return whether the token exists
278    */
279   function exists(uint256 _tokenId) public view returns (bool) {
280     address owner = tokenOwner[_tokenId];
281     return owner != address(0);
282   }
283 
284   /**
285    * @dev Approves another address to transfer the given token ID
286    * @dev The zero address indicates there is no approved address.
287    * @dev There can only be one approved address per token at a given time.
288    * @dev Can only be called by the token owner or an approved operator.
289    * @param _to address to be approved for the given token ID
290    * @param _tokenId uint256 ID of the token to be approved
291    */
292   function approve(address _to, uint256 _tokenId) public {
293     address owner = ownerOf(_tokenId);
294     require(_to != owner);
295     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
296 
297     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
298       tokenApprovals[_tokenId] = _to;
299       emit Approval(owner, _to, _tokenId);
300     }
301   }
302 
303   /**
304    * @dev Gets the approved address for a token ID, or zero if no address set
305    * @param _tokenId uint256 ID of the token to query the approval of
306    * @return address currently approved for a the given token ID
307    */
308   function getApproved(uint256 _tokenId) public view returns (address) {
309     return tokenApprovals[_tokenId];
310   }
311 
312   /**
313    * @dev Sets or unsets the approval of a given operator
314    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
315    * @param _to operator address to set the approval
316    * @param _approved representing the status of the approval to be set
317    */
318   function setApprovalForAll(address _to, bool _approved) public {
319     require(_to != msg.sender);
320     operatorApprovals[msg.sender][_to] = _approved;
321     emit ApprovalForAll(msg.sender, _to, _approved);
322   }
323 
324   /**
325    * @dev Tells whether an operator is approved by a given owner
326    * @param _owner owner address which you want to query the approval of
327    * @param _operator operator address which you want to query the approval of
328    * @return bool whether the given operator is approved by the given owner
329    */
330   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
331     return operatorApprovals[_owner][_operator];
332   }
333 
334   /**
335    * @dev Transfers the ownership of a given token ID to another address
336    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
337    * @dev Requires the msg sender to be the owner, approved, or operator
338    * @param _from current owner of the token
339    * @param _to address to receive the ownership of the given token ID
340    * @param _tokenId uint256 ID of the token to be transferred
341   */
342   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
343     require(_from != address(0));
344     require(_to != address(0));
345 
346     clearApproval(_from, _tokenId);
347     removeTokenFrom(_from, _tokenId);
348     addTokenTo(_to, _tokenId);
349 
350     emit Transfer(_from, _to, _tokenId);
351   }
352 
353   /**
354    * @dev Safely transfers the ownership of a given token ID to another address
355    * @dev If the target address is a contract, it must implement `onERC721Received`,
356    *  which is called upon a safe transfer, and return the magic value
357    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
358    *  the transfer is reverted.
359    * @dev Requires the msg sender to be the owner, approved, or operator
360    * @param _from current owner of the token
361    * @param _to address to receive the ownership of the given token ID
362    * @param _tokenId uint256 ID of the token to be transferred
363   */
364   function safeTransferFrom(
365     address _from,
366     address _to,
367     uint256 _tokenId
368   )
369     public
370     canTransfer(_tokenId)
371   {
372     // solium-disable-next-line arg-overflow
373     safeTransferFrom(_from, _to, _tokenId, "");
374   }
375 
376   /**
377    * @dev Safely transfers the ownership of a given token ID to another address
378    * @dev If the target address is a contract, it must implement `onERC721Received`,
379    *  which is called upon a safe transfer, and return the magic value
380    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
381    *  the transfer is reverted.
382    * @dev Requires the msg sender to be the owner, approved, or operator
383    * @param _from current owner of the token
384    * @param _to address to receive the ownership of the given token ID
385    * @param _tokenId uint256 ID of the token to be transferred
386    * @param _data bytes data to send along with a safe transfer check
387    */
388   function safeTransferFrom(
389     address _from,
390     address _to,
391     uint256 _tokenId,
392     bytes _data
393   )
394     public
395     canTransfer(_tokenId)
396   {
397     transferFrom(_from, _to, _tokenId);
398     // solium-disable-next-line arg-overflow
399     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
400   }
401 
402   /**
403    * @dev Returns whether the given spender can transfer a given token ID
404    * @param _spender address of the spender to query
405    * @param _tokenId uint256 ID of the token to be transferred
406    * @return bool whether the msg.sender is approved for the given token ID,
407    *  is an operator of the owner, or is the owner of the token
408    */
409   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
410     address owner = ownerOf(_tokenId);
411     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
412   }
413 
414   /**
415    * @dev Internal function to mint a new token
416    * @dev Reverts if the given token ID already exists
417    * @param _to The address that will own the minted token
418    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
419    */
420   function _mint(address _to, uint256 _tokenId) internal {
421     require(_to != address(0));
422     addTokenTo(_to, _tokenId);
423     emit Transfer(address(0), _to, _tokenId);
424   }
425 
426   /**
427    * @dev Internal function to burn a specific token
428    * @dev Reverts if the token does not exist
429    * @param _tokenId uint256 ID of the token being burned by the msg.sender
430    */
431   function _burn(address _owner, uint256 _tokenId) internal {
432     clearApproval(_owner, _tokenId);
433     removeTokenFrom(_owner, _tokenId);
434     emit Transfer(_owner, address(0), _tokenId);
435   }
436 
437   /**
438    * @dev Internal function to clear current approval of a given token ID
439    * @dev Reverts if the given address is not indeed the owner of the token
440    * @param _owner owner of the token
441    * @param _tokenId uint256 ID of the token to be transferred
442    */
443   function clearApproval(address _owner, uint256 _tokenId) internal {
444     require(ownerOf(_tokenId) == _owner);
445     if (tokenApprovals[_tokenId] != address(0)) {
446       tokenApprovals[_tokenId] = address(0);
447       emit Approval(_owner, address(0), _tokenId);
448     }
449   }
450 
451   /**
452    * @dev Internal function to add a token ID to the list of a given address
453    * @param _to address representing the new owner of the given token ID
454    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
455    */
456   function addTokenTo(address _to, uint256 _tokenId) internal {
457     require(tokenOwner[_tokenId] == address(0));
458     tokenOwner[_tokenId] = _to;
459     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
460   }
461 
462   /**
463    * @dev Internal function to remove a token ID from the list of a given address
464    * @param _from address representing the previous owner of the given token ID
465    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
466    */
467   function removeTokenFrom(address _from, uint256 _tokenId) internal {
468     require(ownerOf(_tokenId) == _from);
469     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
470     tokenOwner[_tokenId] = address(0);
471   }
472 
473   /**
474    * @dev Internal function to invoke `onERC721Received` on a target address
475    * @dev The call is not executed if the target address is not a contract
476    * @param _from address representing the previous owner of the given token ID
477    * @param _to target address that will receive the tokens
478    * @param _tokenId uint256 ID of the token to be transferred
479    * @param _data bytes optional data to send along with the call
480    * @return whether the call correctly returned the expected magic value
481    */
482   function checkAndCallSafeTransfer(
483     address _from,
484     address _to,
485     uint256 _tokenId,
486     bytes _data
487   )
488     internal
489     returns (bool)
490   {
491     if (!_to.isContract()) {
492       return true;
493     }
494     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
495     return (retval == ERC721_RECEIVED);
496   }
497 }
498 
499 
500 /**
501  * @title Full ERC721 Token
502  * This implementation includes all the required and some optional functionality of the ERC721 standard
503  * Moreover, it includes approve all functionality using operator terminology
504  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
505  */
506 contract ERC721Token is ERC721, ERC721BasicToken {
507   // Token name
508   string internal name_;
509 
510   // Token symbol
511   string internal symbol_;
512 
513   // Mapping from owner to list of owned token IDs
514   mapping (address => uint256[]) internal ownedTokens;
515 
516   // Mapping from token ID to index of the owner tokens list
517   mapping(uint256 => uint256) internal ownedTokensIndex;
518 
519   // Array with all token ids, used for enumeration
520   uint256[] internal allTokens;
521 
522   // Mapping from token id to position in the allTokens array
523   mapping(uint256 => uint256) internal allTokensIndex;
524 
525   // Optional mapping for token URIs
526   mapping(uint256 => string) internal tokenURIs;
527 
528   /**
529    * @dev Constructor function
530    */
531   function ERC721Token(string _name, string _symbol) public {
532     name_ = _name;
533     symbol_ = _symbol;
534   }
535 
536   /**
537    * @dev Gets the token name
538    * @return string representing the token name
539    */
540   function name() public view returns (string) {
541     return name_;
542   }
543 
544   /**
545    * @dev Gets the token symbol
546    * @return string representing the token symbol
547    */
548   function symbol() public view returns (string) {
549     return symbol_;
550   }
551 
552   /**
553    * @dev Returns an URI for a given token ID
554    * @dev Throws if the token ID does not exist. May return an empty string.
555    * @param _tokenId uint256 ID of the token to query
556    */
557   function tokenURI(uint256 _tokenId) public view returns (string) {
558     require(exists(_tokenId));
559     return tokenURIs[_tokenId];
560   }
561 
562   /**
563    * @dev Gets the token ID at a given index of the tokens list of the requested owner
564    * @param _owner address owning the tokens list to be accessed
565    * @param _index uint256 representing the index to be accessed of the requested tokens list
566    * @return uint256 token ID at the given index of the tokens list owned by the requested address
567    */
568   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
569     require(_index < balanceOf(_owner));
570     return ownedTokens[_owner][_index];
571   }
572 
573   /**
574    * @dev Gets the total amount of tokens stored by the contract
575    * @return uint256 representing the total amount of tokens
576    */
577   function totalSupply() public view returns (uint256) {
578     return allTokens.length;
579   }
580 
581   /**
582    * @dev Gets the token ID at a given index of all the tokens in this contract
583    * @dev Reverts if the index is greater or equal to the total number of tokens
584    * @param _index uint256 representing the index to be accessed of the tokens list
585    * @return uint256 token ID at the given index of the tokens list
586    */
587   function tokenByIndex(uint256 _index) public view returns (uint256) {
588     require(_index < totalSupply());
589     return allTokens[_index];
590   }
591 
592   /**
593    * @dev Internal function to set the token URI for a given token
594    * @dev Reverts if the token ID does not exist
595    * @param _tokenId uint256 ID of the token to set its URI
596    * @param _uri string URI to assign
597    */
598   function _setTokenURI(uint256 _tokenId, string _uri) internal {
599     require(exists(_tokenId));
600     tokenURIs[_tokenId] = _uri;
601   }
602 
603   /**
604    * @dev Internal function to add a token ID to the list of a given address
605    * @param _to address representing the new owner of the given token ID
606    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
607    */
608   function addTokenTo(address _to, uint256 _tokenId) internal {
609     super.addTokenTo(_to, _tokenId);
610     uint256 length = ownedTokens[_to].length;
611     ownedTokens[_to].push(_tokenId);
612     ownedTokensIndex[_tokenId] = length;
613   }
614 
615   /**
616    * @dev Internal function to remove a token ID from the list of a given address
617    * @param _from address representing the previous owner of the given token ID
618    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
619    */
620   function removeTokenFrom(address _from, uint256 _tokenId) internal {
621     super.removeTokenFrom(_from, _tokenId);
622 
623     uint256 tokenIndex = ownedTokensIndex[_tokenId];
624     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
625     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
626 
627     ownedTokens[_from][tokenIndex] = lastToken;
628     ownedTokens[_from][lastTokenIndex] = 0;
629     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
630     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
631     // the lastToken to the first position, and then dropping the element placed in the last position of the list
632 
633     ownedTokens[_from].length--;
634     ownedTokensIndex[_tokenId] = 0;
635     ownedTokensIndex[lastToken] = tokenIndex;
636   }
637 
638   /**
639    * @dev Internal function to mint a new token
640    * @dev Reverts if the given token ID already exists
641    * @param _to address the beneficiary that will own the minted token
642    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
643    */
644   function _mint(address _to, uint256 _tokenId) internal {
645     super._mint(_to, _tokenId);
646 
647     allTokensIndex[_tokenId] = allTokens.length;
648     allTokens.push(_tokenId);
649   }
650 
651   /**
652    * @dev Internal function to burn a specific token
653    * @dev Reverts if the token does not exist
654    * @param _owner owner of the token to burn
655    * @param _tokenId uint256 ID of the token being burned by the msg.sender
656    */
657   function _burn(address _owner, uint256 _tokenId) internal {
658     super._burn(_owner, _tokenId);
659 
660     // Clear metadata (if any)
661     if (bytes(tokenURIs[_tokenId]).length != 0) {
662       delete tokenURIs[_tokenId];
663     }
664 
665     // Reorg all tokens array
666     uint256 tokenIndex = allTokensIndex[_tokenId];
667     uint256 lastTokenIndex = allTokens.length.sub(1);
668     uint256 lastToken = allTokens[lastTokenIndex];
669 
670     allTokens[tokenIndex] = lastToken;
671     allTokens[lastTokenIndex] = 0;
672 
673     allTokens.length--;
674     allTokensIndex[_tokenId] = 0;
675     allTokensIndex[lastToken] = tokenIndex;
676   }
677 
678 }
679 
680 
681 
682 /**
683  * @title Pausable
684  * @dev Base contract which allows children to implement an emergency stop mechanism.
685  */
686 contract Pausable is Ownable {
687   event Pause();
688   event Unpause();
689 
690   bool public paused = false;
691 
692 
693   /**
694    * @dev Modifier to make a function callable only when the contract is not paused.
695    */
696   modifier whenNotPaused() {
697     require(!paused);
698     _;
699   }
700 
701   /**
702    * @dev Modifier to make a function callable only when the contract is paused.
703    */
704   modifier whenPaused() {
705     require(paused);
706     _;
707   }
708 
709   /**
710    * @dev called by the owner to pause, triggers stopped state
711    */
712   function pause() onlyOwner whenNotPaused public {
713     paused = true;
714     emit Pause();
715   }
716 
717   /**
718    * @dev called by the owner to unpause, returns to normal state
719    */
720   function unpause() onlyOwner whenPaused public {
721     paused = false;
722     emit Unpause();
723   }
724 }
725 
726 
727 /**
728  * @title Contracts that should not own Ether
729  * @author Remco Bloemen <remco@2π.com>
730  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
731  * in the contract, it will allow the owner to reclaim this ether.
732  * @notice Ether can still be sent to this contract by:
733  * calling functions labeled `payable`
734  * `selfdestruct(contract_address)`
735  * mining directly to the contract address
736  */
737 contract HasNoEther is Ownable {
738 
739   /**
740   * @dev Constructor that rejects incoming Ether
741   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
742   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
743   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
744   * we could use assembly to access msg.value.
745   */
746   function HasNoEther() public payable {
747     require(msg.value == 0);
748   }
749 
750   /**
751    * @dev Disallows direct send by settings a default function without the `payable` flag.
752    */
753   function() external {
754   }
755 
756   /**
757    * @dev Transfer all Ether held by the contract to the owner.
758    */
759   function reclaimEther() external onlyOwner {
760     // solium-disable-next-line security/no-send
761     assert(owner.send(address(this).balance));
762   }
763 }
764 
765 /**
766  * @title ERC20Basic
767  * @dev Simpler version of ERC20 interface
768  * @dev see https://github.com/ethereum/EIPs/issues/179
769  */
770 contract ERC20Basic {
771   function totalSupply() public view returns (uint256);
772   function balanceOf(address who) public view returns (uint256);
773   function transfer(address to, uint256 value) public returns (bool);
774   event Transfer(address indexed from, address indexed to, uint256 value);
775 }
776 
777 /**
778  * @title ERC20 interface
779  * @dev see https://github.com/ethereum/EIPs/issues/20
780  */
781 contract ERC20 is ERC20Basic {
782   function allowance(address owner, address spender) public view returns (uint256);
783   function transferFrom(address from, address to, uint256 value) public returns (bool);
784   function approve(address spender, uint256 value) public returns (bool);
785   event Approval(address indexed owner, address indexed spender, uint256 value);
786 }
787 
788 
789 /**
790  * @title SafeERC20
791  * @dev Wrappers around ERC20 operations that throw on failure.
792  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
793  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
794  */
795 library SafeERC20 {
796   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
797     assert(token.transfer(to, value));
798   }
799 
800   function safeTransferFrom(
801     ERC20 token,
802     address from,
803     address to,
804     uint256 value
805   )
806     internal
807   {
808     assert(token.transferFrom(from, to, value));
809   }
810 
811   function safeApprove(ERC20 token, address spender, uint256 value) internal {
812     assert(token.approve(spender, value));
813   }
814 }
815 
816 
817 /**
818  * @title Contracts that should be able to recover tokens
819  * @author SylTi
820  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
821  * This will prevent any accidental loss of tokens.
822  */
823 contract CanReclaimToken is Ownable {
824   using SafeERC20 for ERC20Basic;
825 
826   /**
827    * @dev Reclaim all ERC20Basic compatible tokens
828    * @param token ERC20Basic The address of the token contract
829    */
830   function reclaimToken(ERC20Basic token) external onlyOwner {
831     uint256 balance = token.balanceOf(this);
832     token.safeTransfer(owner, balance);
833   }
834 
835 }
836 
837 
838 /**
839  * @title Contracts that should not own Tokens
840  * @author Remco Bloemen <remco@2π.com>
841  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
842  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
843  * owner to reclaim the tokens.
844  */
845 contract HasNoTokens is CanReclaimToken {
846 
847  /**
848   * @dev Reject all ERC223 compatible tokens
849   * @param from_ address The address that is transferring the tokens
850   * @param value_ uint256 the amount of the specified token
851   * @param data_ Bytes The data passed from the caller.
852   */
853   function tokenFallback(address from_, uint256 value_, bytes data_) external {
854     from_;
855     value_;
856     data_;
857     revert();
858   }
859 
860 }
861 
862 /**
863  * @title Contracts that should not own Contracts
864  * @author Remco Bloemen <remco@2π.com>
865  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
866  * of this contract to reclaim ownership of the contracts.
867  */
868 contract HasNoContracts is Ownable {
869 
870   /**
871    * @dev Reclaim ownership of Ownable contracts
872    * @param contractAddr The address of the Ownable to be reclaimed.
873    */
874   function reclaimContract(address contractAddr) external onlyOwner {
875     Ownable contractInst = Ownable(contractAddr);
876     contractInst.transferOwnership(owner);
877   }
878 }
879 
880 
881 /**
882  * @title Base contract for contracts that should not own things.
883  * @author Remco Bloemen <remco@2π.com>
884  * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or
885  * Owned contracts. See respective base contracts for details.
886  */
887 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
888 }
889 
890 contract MintingUtility is Pausable, NoOwner {
891   mapping (address => bool) public _authorizedMinters;
892 
893   modifier onlyMinter() {
894     bool isAuthorized = _authorizedMinters[msg.sender];
895     require(isAuthorized || msg.sender == owner);
896     _;
897   }
898 
899   function setAuthorizedMinter(address _minter, bool _isAuthorized) external onlyOwner {
900     _authorizedMinters[_minter] = _isAuthorized;
901   }
902 
903 }
904 
905 contract MintableNFT is ERC721Token, MintingUtility {
906   using SafeMath for uint256;
907 
908   uint8 public bitsMask;
909   uint248 public maxMask;
910 
911   mapping (uint256 => uint256) public tokenTypeQuantity;
912   mapping (uint256 => uint256) public tokenTypeAvailableQuantity;
913 
914   constructor(string _name, string _symbol, uint8 _bytesMask) ERC721Token(_name, _symbol) public {
915     require(_bytesMask > 0); // The mask has to be bigger than zero
916     require(_bytesMask < 32); // The mask can not occupy the entire length, because we need at least one byte to reflect the token type
917     bitsMask = _bytesMask * 8; // Mask is set at creation and can't be modified (max 248 bits, fits on uint8(256))
918     uint256 maximumValueOfMask = uint256(2) ** (uint256(bitsMask)) - 1; // Gets the maximum uint value for the mask;
919     maxMask = uint248(maximumValueOfMask);
920   }
921 
922   /*
923    * @notice Makes the contract type verifiable.
924    * @dev Function to prove the contract is MintableNFT.
925    */
926   function isMintableNFT() external pure returns (bool) {
927     return true;
928   }
929 
930   /*
931    @dev Establishes ownership and brings token into existence AKA minting a token
932    @param _beneficiary - who gets the the tokens
933    @param _tokenIds - tokens.
934   */
935   function mint(address _beneficiary,
936                 uint256 _tokenType) public onlyMinter whenNotPaused  {
937 
938     require(tokenTypeAvailableQuantity[_tokenType] > 0);
939     bytes32 tokenIdMasked = bytes32(_tokenType) << bitsMask;
940 
941     tokenTypeAvailableQuantity[_tokenType] = tokenTypeAvailableQuantity[_tokenType].sub(1);
942     bytes32 quantityId = bytes32(tokenTypeQuantity[_tokenType].sub(tokenTypeAvailableQuantity[_tokenType]));
943 
944     uint256 tokenId = uint256(tokenIdMasked | quantityId);
945     // This will assign ownership, and also emit the Transfer event
946     _mint(_beneficiary, tokenId);
947   }
948 
949   function setTokensQuantity(uint256[] _tokenTypes, uint248[] _quantities) public onlyOwner {
950     require(_tokenTypes.length > 0 && _tokenTypes.length == _quantities.length);
951     bytes32 normalizedToken;
952     for (uint i = 0; i < _tokenTypes.length; i++) {
953 
954       normalizedToken = bytes32(_tokenTypes[i]); // Clears non relevant bytes
955       normalizedToken = normalizedToken << bitsMask; // Clears non relevant bytes
956       normalizedToken = normalizedToken >> bitsMask; // Clears non relevant bytes
957 
958       require(uint256(normalizedToken) == _tokenTypes[i]); // Avoids overflow mistakes when setting the tokens quantities
959       require(tokenTypeQuantity[_tokenTypes[i]] == 0); // Ensures quantity is not set
960       require(_quantities[i] > 0 && _quantities[i] <= maxMask); // Ensures no overflow by using maxMask as quantity.
961 
962       tokenTypeQuantity[_tokenTypes[i]] = _quantities[i];
963       tokenTypeAvailableQuantity[_tokenTypes[i]] = _quantities[i];
964     }
965   }
966 
967   function getOwnedTokensIds(address _owner) external view returns (uint[] tokensIds) {
968     tokensIds = new uint[](balanceOf(_owner));
969 
970     for (uint i = 0; i < balanceOf(_owner); i++) {
971       tokensIds[i] = tokenOfOwnerByIndex(_owner, i);
972     }
973 
974     return tokensIds;
975   }
976 
977 }
978 
979 
980 contract NFTMinter is MintingUtility {
981 
982   using SafeMath for uint256;
983 
984   event TokenPurchase(address indexed purchaser, uint256 price, uint256 tokenType);
985 
986   address public wallet;
987 
988   uint256 public weiRaised;
989 
990   MintableNFT public nftContract;
991 
992   uint256[] public enabledTokens;
993 
994   mapping (uint256 => uint256) public enabledTokenIndex;
995 
996   mapping (uint256 => uint256) public tokenTypePrices;
997 
998   constructor(address _wallet,
999               MintableNFT _nftContract) public {
1000 
1001     require(_wallet != address(0));
1002     require(_nftContract.isMintableNFT());
1003     wallet = _wallet;
1004     nftContract = _nftContract;
1005   }
1006 
1007   function setTokenPrices(uint256[] _tokenTypes, uint256[] _prices) public onlyOwner {
1008     require(_tokenTypes.length > 0 && _tokenTypes.length == _prices.length);
1009 
1010     for (uint i = 0; i < _tokenTypes.length; i++) {
1011       require(nftContract.tokenTypeQuantity(_tokenTypes[i]) > 0);
1012       tokenTypePrices[_tokenTypes[i]] = _prices[i];
1013 
1014       require(enabledTokens.length == 0 || enabledTokens[enabledTokenIndex[_tokenTypes[i]]] != _tokenTypes[i]);
1015 
1016       enabledTokenIndex[_tokenTypes[i]] = enabledTokens.push(_tokenTypes[i]) - 1;
1017     }
1018   }
1019 
1020   function disableTokens(uint256[] _tokenTypes) public onlyOwner {
1021     require(_tokenTypes.length > 0);
1022 
1023     for (uint i = 0; i < _tokenTypes.length; i++) {
1024       require(tokenEnabled(_tokenTypes[i]));
1025       uint256 lastToken = enabledTokens[enabledTokens.length.sub(1)];
1026       enabledTokens[enabledTokenIndex[_tokenTypes[i]]] = lastToken;
1027       enabledTokenIndex[lastToken] = enabledTokenIndex[_tokenTypes[i]];
1028       enabledTokens.length = enabledTokens.length.sub(1);
1029 
1030       delete enabledTokenIndex[_tokenTypes[i]];
1031     }
1032   }
1033 
1034   function buyTokens(uint256 _tokenType) public payable {
1035     require(msg.sender != address(0));
1036     require(tokenEnabled(_tokenType));
1037     require(validPurchase(_tokenType));
1038 
1039     uint256 weiAmount = msg.value;
1040 
1041     weiRaised = weiRaised.add(weiAmount);
1042 
1043     emit TokenPurchase(msg.sender, weiAmount, _tokenType);
1044 
1045     forwardFunds();
1046 
1047     nftContract.mint(msg.sender, _tokenType);
1048   }
1049 
1050   function forwardFunds() internal {
1051     wallet.transfer(msg.value);
1052   }
1053 
1054   function validPurchase(uint256 _tokenType) internal view returns (bool) {
1055     bool availableTokens = nftContract.tokenTypeAvailableQuantity(_tokenType) >= 1;
1056     bool correctPayment = msg.value == tokenTypePrices[_tokenType];
1057     return availableTokens && correctPayment;
1058   }
1059 
1060   function tokenEnabled(uint256 _tokenType) public view returns (bool) {
1061     return enabledTokens.length > enabledTokenIndex[_tokenType] &&
1062            enabledTokens[enabledTokenIndex[_tokenType]] == _tokenType;
1063   }
1064 
1065   function getEnabledTokensLength() external view returns (uint length) {
1066     return enabledTokens.length;
1067   }
1068 
1069   function getEnabledTokensInformation() external view returns (uint256[] tokenTypesIds,
1070                                                                 uint256[] tokenTypesPrices,
1071                                                                 uint256[] tokenTypesQuantities,
1072                                                                 uint256[] tokenTypesAvailableQuantities) {
1073     tokenTypesIds = new uint[](enabledTokens.length);
1074     tokenTypesPrices = new uint[](enabledTokens.length);
1075     tokenTypesQuantities = new uint[](enabledTokens.length);
1076     tokenTypesAvailableQuantities = new uint[](enabledTokens.length);
1077     for (uint i = 0; i < enabledTokens.length; i++) {
1078       tokenTypesIds[i] = (enabledTokens[i]);
1079       tokenTypesPrices[i] = (tokenTypePrices[enabledTokens[i]]);
1080       tokenTypesQuantities[i] = (nftContract.tokenTypeQuantity(enabledTokens[i]));
1081       tokenTypesAvailableQuantities[i] = (nftContract.tokenTypeAvailableQuantity(enabledTokens[i]));
1082     }
1083   }
1084 }