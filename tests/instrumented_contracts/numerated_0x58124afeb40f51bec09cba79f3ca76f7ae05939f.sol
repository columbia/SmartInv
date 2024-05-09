1 pragma solidity ^0.4.21;
2 
3 // File: contracts/ownership/Ownable.sol
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
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   function Ownable() public {
23     owner = msg.sender;
24   }
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) public onlyOwner {
39     require(newOwner != address(0));
40     emit OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44   /**
45    * @dev Allows the current owner to relinquish control of the contract.
46    */
47   function renounceOwnership() public onlyOwner {
48     emit OwnershipRenounced(owner);
49     owner = address(0);
50   }
51 }
52 
53 // File: contracts/token/ERC721/ERC721Basic.sol
54 
55 /**
56  * @title ERC721 Non-Fungible Token Standard basic interface
57  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
58  */
59 contract ERC721Basic {
60   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
61   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
62   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
63 
64   function balanceOf(address _owner) public view returns (uint256 _balance);
65   function ownerOf(uint256 _tokenId) public view returns (address _owner);
66   function exists(uint256 _tokenId) public view returns (bool _exists);
67 
68   function approve(address _to, uint256 _tokenId) public;
69   function getApproved(uint256 _tokenId) public view returns (address _operator);
70 
71   function setApprovalForAll(address _operator, bool _approved) public;
72   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
73 
74   function transferFrom(address _from, address _to, uint256 _tokenId) public;
75   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
76   function safeTransferFrom(
77     address _from,
78     address _to,
79     uint256 _tokenId,
80     bytes _data
81   )
82     public;
83 }
84 
85 // File: contracts/token/ERC721/ERC721.sol
86 
87 /**
88  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
89  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
90  */
91 contract ERC721Enumerable is ERC721Basic {
92   function totalSupply() public view returns (uint256);
93   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
94   function tokenByIndex(uint256 _index) public view returns (uint256);
95 }
96 
97 
98 /**
99  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
100  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
101  */
102 contract ERC721Metadata is ERC721Basic {
103   function name() public view returns (string _name);
104   function symbol() public view returns (string _symbol);
105   function tokenURI(uint256 _tokenId) public view returns (string);
106 }
107 
108 
109 /**
110  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
111  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
112  */
113 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
114 }
115 
116 // File: contracts/AddressUtils.sol
117 
118 /**
119  * Utility library of inline functions on addresses
120  */
121 library AddressUtils {
122 
123   /**
124    * Returns whether the target address is a contract
125    * @dev This function will return false if invoked during the constructor of a contract,
126    *  as the code is not actually created until after the constructor finishes.
127    * @param addr address to check
128    * @return whether the target address is a contract
129    */
130   function isContract(address addr) internal view returns (bool) {
131     uint256 size;
132     // XXX Currently there is no better way to check if there is a contract in an address
133     // than to check the size of the code at that address.
134     // See https://ethereum.stackexchange.com/a/14016/36603
135     // for more details about how this works.
136     // TODO Check this again before the Serenity release, because all addresses will be
137     // contracts then.
138     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
139     return size > 0;
140   }
141 
142 }
143 
144 // File: contracts/math/SafeMath.sol
145 
146 /**
147  * @title SafeMath
148  * @dev Math operations with safety checks that throw on error
149  */
150 library SafeMath {
151 
152   /**
153   * @dev Multiplies two numbers, throws on overflow.
154   */
155   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
156     if (a == 0) {
157       return 0;
158     }
159     c = a * b;
160     assert(c / a == b);
161     return c;
162   }
163 
164   /**
165   * @dev Integer division of two numbers, truncating the quotient.
166   */
167   function div(uint256 a, uint256 b) internal pure returns (uint256) {
168     // assert(b > 0); // Solidity automatically throws when dividing by 0
169     // uint256 c = a / b;
170     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
171     return a / b;
172   }
173 
174   /**
175   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
176   */
177   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
178     assert(b <= a);
179     return a - b;
180   }
181 
182   /**
183   * @dev Adds two numbers, throws on overflow.
184   */
185   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
186     c = a + b;
187     assert(c >= a);
188     return c;
189   }
190 }
191 
192 // File: contracts/token/ERC721/ERC721Receiver.sol
193 
194 /**
195  * @title ERC721 token receiver interface
196  * @dev Interface for any contract that wants to support safeTransfers
197  *  from ERC721 asset contracts.
198  */
199 contract ERC721Receiver {
200   /**
201    * @dev Magic value to be returned upon successful reception of an NFT
202    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
203    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
204    */
205   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
206 
207   /**
208    * @notice Handle the receipt of an NFT
209    * @dev The ERC721 smart contract calls this function on the recipient
210    *  after a `safetransfer`. This function MAY throw to revert and reject the
211    *  transfer. This function MUST use 50,000 gas or less. Return of other
212    *  than the magic value MUST result in the transaction being reverted.
213    *  Note: the contract address is always the message sender.
214    * @param _from The sending address
215    * @param _tokenId The NFT identifier which is being transfered
216    * @param _data Additional data with no specified format
217    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
218    */
219   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
220 }
221 
222 // File: contracts/token/ERC721/ERC721BasicToken.sol
223 
224 /**
225  * @title ERC721 Non-Fungible Token Standard basic implementation
226  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
227  */
228 contract ERC721BasicToken is ERC721Basic {
229   using SafeMath for uint256;
230   using AddressUtils for address;
231 
232   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
233   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
234   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
235 
236   // Mapping from token ID to owner
237   mapping (uint256 => address) internal tokenOwner;
238 
239   // Mapping from token ID to approved address
240   mapping (uint256 => address) internal tokenApprovals;
241 
242   // Mapping from owner to number of owned token
243   mapping (address => uint256) internal ownedTokensCount;
244 
245   // Mapping from owner to operator approvals
246   mapping (address => mapping (address => bool)) internal operatorApprovals;
247 
248   /**
249    * @dev Guarantees msg.sender is owner of the given token
250    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
251    */
252   modifier onlyOwnerOf(uint256 _tokenId) {
253     require(ownerOf(_tokenId) == msg.sender);
254     _;
255   }
256 
257   /**
258    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
259    * @param _tokenId uint256 ID of the token to validate
260    */
261   modifier canTransfer(uint256 _tokenId) {
262     require(isApprovedOrOwner(msg.sender, _tokenId));
263     _;
264   }
265 
266   /**
267    * @dev Gets the balance of the specified address
268    * @param _owner address to query the balance of
269    * @return uint256 representing the amount owned by the passed address
270    */
271   function balanceOf(address _owner) public view returns (uint256) {
272     require(_owner != address(0));
273     return ownedTokensCount[_owner];
274   }
275 
276   /**
277    * @dev Gets the owner of the specified token ID
278    * @param _tokenId uint256 ID of the token to query the owner of
279    * @return owner address currently marked as the owner of the given token ID
280    */
281   function ownerOf(uint256 _tokenId) public view returns (address) {
282     address owner = tokenOwner[_tokenId];
283     require(owner != address(0));
284     return owner;
285   }
286 
287   /**
288    * @dev Returns whether the specified token exists
289    * @param _tokenId uint256 ID of the token to query the existance of
290    * @return whether the token exists
291    */
292   function exists(uint256 _tokenId) public view returns (bool) {
293     address owner = tokenOwner[_tokenId];
294     return owner != address(0);
295   }
296 
297   /**
298    * @dev Approves another address to transfer the given token ID
299    * @dev The zero address indicates there is no approved address.
300    * @dev There can only be one approved address per token at a given time.
301    * @dev Can only be called by the token owner or an approved operator.
302    * @param _to address to be approved for the given token ID
303    * @param _tokenId uint256 ID of the token to be approved
304    */
305   function approve(address _to, uint256 _tokenId) public {
306     address owner = ownerOf(_tokenId);
307     require(_to != owner);
308     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
309 
310     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
311       tokenApprovals[_tokenId] = _to;
312       emit Approval(owner, _to, _tokenId);
313     }
314   }
315 
316   /**
317    * @dev Gets the approved address for a token ID, or zero if no address set
318    * @param _tokenId uint256 ID of the token to query the approval of
319    * @return address currently approved for a the given token ID
320    */
321   function getApproved(uint256 _tokenId) public view returns (address) {
322     return tokenApprovals[_tokenId];
323   }
324 
325   /**
326    * @dev Sets or unsets the approval of a given operator
327    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
328    * @param _to operator address to set the approval
329    * @param _approved representing the status of the approval to be set
330    */
331   function setApprovalForAll(address _to, bool _approved) public {
332     require(_to != msg.sender);
333     operatorApprovals[msg.sender][_to] = _approved;
334     emit ApprovalForAll(msg.sender, _to, _approved);
335   }
336 
337   /**
338    * @dev Tells whether an operator is approved by a given owner
339    * @param _owner owner address which you want to query the approval of
340    * @param _operator operator address which you want to query the approval of
341    * @return bool whether the given operator is approved by the given owner
342    */
343   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
344     return operatorApprovals[_owner][_operator];
345   }
346 
347   /**
348    * @dev Transfers the ownership of a given token ID to another address
349    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
350    * @dev Requires the msg sender to be the owner, approved, or operator
351    * @param _from current owner of the token
352    * @param _to address to receive the ownership of the given token ID
353    * @param _tokenId uint256 ID of the token to be transferred
354   */
355   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
356     require(_from != address(0));
357     require(_to != address(0));
358 
359     clearApproval(_from, _tokenId);
360     removeTokenFrom(_from, _tokenId);
361     addTokenTo(_to, _tokenId);
362 
363     emit Transfer(_from, _to, _tokenId);
364   }
365 
366   /**
367    * @dev Safely transfers the ownership of a given token ID to another address
368    * @dev If the target address is a contract, it must implement `onERC721Received`,
369    *  which is called upon a safe transfer, and return the magic value
370    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
371    *  the transfer is reverted.
372    * @dev Requires the msg sender to be the owner, approved, or operator
373    * @param _from current owner of the token
374    * @param _to address to receive the ownership of the given token ID
375    * @param _tokenId uint256 ID of the token to be transferred
376   */
377   function safeTransferFrom(
378     address _from,
379     address _to,
380     uint256 _tokenId
381   )
382     public
383     canTransfer(_tokenId)
384   {
385     // solium-disable-next-line arg-overflow
386     safeTransferFrom(_from, _to, _tokenId, "");
387   }
388 
389   /**
390    * @dev Safely transfers the ownership of a given token ID to another address
391    * @dev If the target address is a contract, it must implement `onERC721Received`,
392    *  which is called upon a safe transfer, and return the magic value
393    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
394    *  the transfer is reverted.
395    * @dev Requires the msg sender to be the owner, approved, or operator
396    * @param _from current owner of the token
397    * @param _to address to receive the ownership of the given token ID
398    * @param _tokenId uint256 ID of the token to be transferred
399    * @param _data bytes data to send along with a safe transfer check
400    */
401   function safeTransferFrom(
402     address _from,
403     address _to,
404     uint256 _tokenId,
405     bytes _data
406   )
407     public
408     canTransfer(_tokenId)
409   {
410     transferFrom(_from, _to, _tokenId);
411     // solium-disable-next-line arg-overflow
412     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
413   }
414 
415   /**
416    * @dev Returns whether the given spender can transfer a given token ID
417    * @param _spender address of the spender to query
418    * @param _tokenId uint256 ID of the token to be transferred
419    * @return bool whether the msg.sender is approved for the given token ID,
420    *  is an operator of the owner, or is the owner of the token
421    */
422   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
423     address owner = ownerOf(_tokenId);
424     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
425   }
426 
427   /**
428    * @dev Internal function to mint a new token
429    * @dev Reverts if the given token ID already exists
430    * @param _to The address that will own the minted token
431    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
432    */
433   function _mint(address _to, uint256 _tokenId) internal {
434     require(_to != address(0));
435     addTokenTo(_to, _tokenId);
436     emit Transfer(address(0), _to, _tokenId);
437   }
438 
439   /**
440    * @dev Internal function to burn a specific token
441    * @dev Reverts if the token does not exist
442    * @param _tokenId uint256 ID of the token being burned by the msg.sender
443    */
444   function _burn(address _owner, uint256 _tokenId) internal {
445     clearApproval(_owner, _tokenId);
446     removeTokenFrom(_owner, _tokenId);
447     emit Transfer(_owner, address(0), _tokenId);
448   }
449 
450   /**
451    * @dev Internal function to clear current approval of a given token ID
452    * @dev Reverts if the given address is not indeed the owner of the token
453    * @param _owner owner of the token
454    * @param _tokenId uint256 ID of the token to be transferred
455    */
456   function clearApproval(address _owner, uint256 _tokenId) internal {
457     require(ownerOf(_tokenId) == _owner);
458     if (tokenApprovals[_tokenId] != address(0)) {
459       tokenApprovals[_tokenId] = address(0);
460       emit Approval(_owner, address(0), _tokenId);
461     }
462   }
463 
464   /**
465    * @dev Internal function to add a token ID to the list of a given address
466    * @param _to address representing the new owner of the given token ID
467    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
468    */
469   function addTokenTo(address _to, uint256 _tokenId) internal {
470     require(tokenOwner[_tokenId] == address(0));
471     tokenOwner[_tokenId] = _to;
472     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
473   }
474 
475   /**
476    * @dev Internal function to remove a token ID from the list of a given address
477    * @param _from address representing the previous owner of the given token ID
478    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
479    */
480   function removeTokenFrom(address _from, uint256 _tokenId) internal {
481     require(ownerOf(_tokenId) == _from);
482     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
483     tokenOwner[_tokenId] = address(0);
484   }
485 
486   /**
487    * @dev Internal function to invoke `onERC721Received` on a target address
488    * @dev The call is not executed if the target address is not a contract
489    * @param _from address representing the previous owner of the given token ID
490    * @param _to target address that will receive the tokens
491    * @param _tokenId uint256 ID of the token to be transferred
492    * @param _data bytes optional data to send along with the call
493    * @return whether the call correctly returned the expected magic value
494    */
495   function checkAndCallSafeTransfer(
496     address _from,
497     address _to,
498     uint256 _tokenId,
499     bytes _data
500   )
501     internal
502     returns (bool)
503   {
504     if (!_to.isContract()) {
505       return true;
506     }
507     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
508     return (retval == ERC721_RECEIVED);
509   }
510 }
511 
512 // File: contracts/token/ERC721/ERC721Token.sol
513 
514 /**
515  * @title Full ERC721 Token
516  * This implementation includes all the required and some optional functionality of the ERC721 standard
517  * Moreover, it includes approve all functionality using operator terminology
518  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
519  */
520 contract ERC721Token is ERC721, ERC721BasicToken {
521   // Token name
522   string internal name_;
523 
524   // Token symbol
525   string internal symbol_;
526 
527   // Mapping from owner to list of owned token IDs
528   mapping (address => uint256[]) internal ownedTokens;
529 
530   // Mapping from token ID to index of the owner tokens list
531   mapping(uint256 => uint256) internal ownedTokensIndex;
532 
533   // Array with all token ids, used for enumeration
534   uint256[] internal allTokens;
535 
536   // Mapping from token id to position in the allTokens array
537   mapping(uint256 => uint256) internal allTokensIndex;
538 
539   // Optional mapping for token URIs
540   mapping(uint256 => string) internal tokenURIs;
541 
542   /**
543    * @dev Constructor function
544    */
545   function ERC721Token(string _name, string _symbol) public {
546     name_ = _name;
547     symbol_ = _symbol;
548   }
549 
550   /**
551    * @dev Gets the token name
552    * @return string representing the token name
553    */
554   function name() public view returns (string) {
555     return name_;
556   }
557 
558   /**
559    * @dev Gets the token symbol
560    * @return string representing the token symbol
561    */
562   function symbol() public view returns (string) {
563     return symbol_;
564   }
565 
566   /**
567    * @dev Returns an URI for a given token ID
568    * @dev Throws if the token ID does not exist. May return an empty string.
569    * @param _tokenId uint256 ID of the token to query
570    */
571   function tokenURI(uint256 _tokenId) public view returns (string) {
572     require(exists(_tokenId));
573     return tokenURIs[_tokenId];
574   }
575 
576   /**
577    * @dev Gets the token ID at a given index of the tokens list of the requested owner
578    * @param _owner address owning the tokens list to be accessed
579    * @param _index uint256 representing the index to be accessed of the requested tokens list
580    * @return uint256 token ID at the given index of the tokens list owned by the requested address
581    */
582   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
583     require(_index < balanceOf(_owner));
584     return ownedTokens[_owner][_index];
585   }
586 
587   /**
588    * @dev Gets the total amount of tokens stored by the contract
589    * @return uint256 representing the total amount of tokens
590    */
591   function totalSupply() public view returns (uint256) {
592     return allTokens.length;
593   }
594 
595   /**
596    * @dev Gets the token ID at a given index of all the tokens in this contract
597    * @dev Reverts if the index is greater or equal to the total number of tokens
598    * @param _index uint256 representing the index to be accessed of the tokens list
599    * @return uint256 token ID at the given index of the tokens list
600    */
601   function tokenByIndex(uint256 _index) public view returns (uint256) {
602     require(_index < totalSupply());
603     return allTokens[_index];
604   }
605 
606   /**
607    * @dev Internal function to set the token URI for a given token
608    * @dev Reverts if the token ID does not exist
609    * @param _tokenId uint256 ID of the token to set its URI
610    * @param _uri string URI to assign
611    */
612   function _setTokenURI(uint256 _tokenId, string _uri) internal {
613     require(exists(_tokenId));
614     tokenURIs[_tokenId] = _uri;
615   }
616 
617   /**
618    * @dev Internal function to add a token ID to the list of a given address
619    * @param _to address representing the new owner of the given token ID
620    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
621    */
622   function addTokenTo(address _to, uint256 _tokenId) internal {
623     super.addTokenTo(_to, _tokenId);
624     uint256 length = ownedTokens[_to].length;
625     ownedTokens[_to].push(_tokenId);
626     ownedTokensIndex[_tokenId] = length;
627   }
628 
629   /**
630    * @dev Internal function to remove a token ID from the list of a given address
631    * @param _from address representing the previous owner of the given token ID
632    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
633    */
634   function removeTokenFrom(address _from, uint256 _tokenId) internal {
635     super.removeTokenFrom(_from, _tokenId);
636 
637     uint256 tokenIndex = ownedTokensIndex[_tokenId];
638     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
639     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
640 
641     ownedTokens[_from][tokenIndex] = lastToken;
642     ownedTokens[_from][lastTokenIndex] = 0;
643     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
644     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
645     // the lastToken to the first position, and then dropping the element placed in the last position of the list
646 
647     ownedTokens[_from].length--;
648     ownedTokensIndex[_tokenId] = 0;
649     ownedTokensIndex[lastToken] = tokenIndex;
650   }
651 
652   /**
653    * @dev Internal function to mint a new token
654    * @dev Reverts if the given token ID already exists
655    * @param _to address the beneficiary that will own the minted token
656    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
657    */
658   function _mint(address _to, uint256 _tokenId) internal {
659     super._mint(_to, _tokenId);
660 
661     allTokensIndex[_tokenId] = allTokens.length;
662     allTokens.push(_tokenId);
663   }
664 
665   /**
666    * @dev Internal function to burn a specific token
667    * @dev Reverts if the token does not exist
668    * @param _owner owner of the token to burn
669    * @param _tokenId uint256 ID of the token being burned by the msg.sender
670    */
671   function _burn(address _owner, uint256 _tokenId) internal {
672     super._burn(_owner, _tokenId);
673 
674     // Clear metadata (if any)
675     if (bytes(tokenURIs[_tokenId]).length != 0) {
676       delete tokenURIs[_tokenId];
677     }
678 
679     // Reorg all tokens array
680     uint256 tokenIndex = allTokensIndex[_tokenId];
681     uint256 lastTokenIndex = allTokens.length.sub(1);
682     uint256 lastToken = allTokens[lastTokenIndex];
683 
684     allTokens[tokenIndex] = lastToken;
685     allTokens[lastTokenIndex] = 0;
686 
687     allTokens.length--;
688     allTokensIndex[_tokenId] = 0;
689     allTokensIndex[lastToken] = tokenIndex;
690   }
691 
692 }
693 
694 // File: contracts/token/ERC721/strings.sol
695 
696 /*
697  * @title String & slice utility library for Solidity contracts.
698  * @author Nick Johnson <arachnid@notdot.net>
699  *
700  * @dev Functionality in this library is largely implemented using an
701  *      abstraction called a 'slice'. A slice represents a part of a string -
702  *      anything from the entire string to a single character, or even no
703  *      characters at all (a 0-length slice). Since a slice only has to specify
704  *      an offset and a length, copying and manipulating slices is a lot less
705  *      expensive than copying and manipulating the strings they reference.
706  *
707  *      To further reduce gas costs, most functions on slice that need to return
708  *      a slice modify the original one instead of allocating a new one; for
709  *      instance, `s.split(".")` will return the text up to the first '.',
710  *      modifying s to only contain the remainder of the string after the '.'.
711  *      In situations where you do not want to modify the original slice, you
712  *      can make a copy first with `.copy()`, for example:
713  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
714  *      Solidity has no memory management, it will result in allocating many
715  *      short-lived slices that are later discarded.
716  *
717  *      Functions that return two slices come in two versions: a non-allocating
718  *      version that takes the second slice as an argument, modifying it in
719  *      place, and an allocating version that allocates and returns the second
720  *      slice; see `nextRune` for example.
721  *
722  *      Functions that have to copy string data will return strings rather than
723  *      slices; these can be cast back to slices for further processing if
724  *      required.
725  *
726  *      For convenience, some functions are provided with non-modifying
727  *      variants that create a new slice and return both; for instance,
728  *      `s.splitNew('.')` leaves s unmodified, and returns two values
729  *      corresponding to the left and right parts of the string.
730  */
731 
732 pragma solidity ^0.4.14;
733 
734 library strings {
735     struct slice {
736         uint _len;
737         uint _ptr;
738     }
739 
740     function memcpy(uint dest, uint src, uint len) private pure {
741         // Copy word-length chunks while possible
742         for(; len >= 32; len -= 32) {
743             assembly {
744                 mstore(dest, mload(src))
745             }
746             dest += 32;
747             src += 32;
748         }
749 
750         // Copy remaining bytes
751         uint mask = 256 ** (32 - len) - 1;
752         assembly {
753             let srcpart := and(mload(src), not(mask))
754             let destpart := and(mload(dest), mask)
755             mstore(dest, or(destpart, srcpart))
756         }
757     }
758 
759     /*
760      * @dev Returns a slice containing the entire string.
761      * @param self The string to make a slice from.
762      * @return A newly allocated slice containing the entire string.
763      */
764     function toSlice(string self) internal pure returns (slice) {
765         uint ptr;
766         assembly {
767             ptr := add(self, 0x20)
768         }
769         return slice(bytes(self).length, ptr);
770     }
771 
772     /*
773      * @dev Returns the length of a null-terminated bytes32 string.
774      * @param self The value to find the length of.
775      * @return The length of the string, from 0 to 32.
776      */
777     function len(bytes32 self) internal pure returns (uint) {
778         uint ret;
779         if (self == 0)
780             return 0;
781         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
782             ret += 16;
783             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
784         }
785         if (self & 0xffffffffffffffff == 0) {
786             ret += 8;
787             self = bytes32(uint(self) / 0x10000000000000000);
788         }
789         if (self & 0xffffffff == 0) {
790             ret += 4;
791             self = bytes32(uint(self) / 0x100000000);
792         }
793         if (self & 0xffff == 0) {
794             ret += 2;
795             self = bytes32(uint(self) / 0x10000);
796         }
797         if (self & 0xff == 0) {
798             ret += 1;
799         }
800         return 32 - ret;
801     }
802 
803     /*
804      * @dev Returns a slice containing the entire bytes32, interpreted as a
805      *      null-terminated utf-8 string.
806      * @param self The bytes32 value to convert to a slice.
807      * @return A new slice containing the value of the input argument up to the
808      *         first null.
809      */
810     function toSliceB32(bytes32 self) internal pure returns (slice ret) {
811         // Allocate space for `self` in memory, copy it there, and point ret at it
812         assembly {
813             let ptr := mload(0x40)
814             mstore(0x40, add(ptr, 0x20))
815             mstore(ptr, self)
816             mstore(add(ret, 0x20), ptr)
817         }
818         ret._len = len(self);
819     }
820 
821     /*
822      * @dev Returns a new slice containing the same data as the current slice.
823      * @param self The slice to copy.
824      * @return A new slice containing the same data as `self`.
825      */
826     function copy(slice self) internal pure returns (slice) {
827         return slice(self._len, self._ptr);
828     }
829 
830     /*
831      * @dev Copies a slice to a new string.
832      * @param self The slice to copy.
833      * @return A newly allocated string containing the slice's text.
834      */
835     function toString(slice self) internal pure returns (string) {
836         string memory ret = new string(self._len);
837         uint retptr;
838         assembly { retptr := add(ret, 32) }
839 
840         memcpy(retptr, self._ptr, self._len);
841         return ret;
842     }
843 
844     /*
845      * @dev Returns the length in runes of the slice. Note that this operation
846      *      takes time proportional to the length of the slice; avoid using it
847      *      in loops, and call `slice.empty()` if you only need to know whether
848      *      the slice is empty or not.
849      * @param self The slice to operate on.
850      * @return The length of the slice in runes.
851      */
852     function len(slice self) internal pure returns (uint l) {
853         // Starting at ptr-31 means the LSB will be the byte we care about
854         uint ptr = self._ptr - 31;
855         uint end = ptr + self._len;
856         for (l = 0; ptr < end; l++) {
857             uint8 b;
858             assembly { b := and(mload(ptr), 0xFF) }
859             if (b < 0x80) {
860                 ptr += 1;
861             } else if(b < 0xE0) {
862                 ptr += 2;
863             } else if(b < 0xF0) {
864                 ptr += 3;
865             } else if(b < 0xF8) {
866                 ptr += 4;
867             } else if(b < 0xFC) {
868                 ptr += 5;
869             } else {
870                 ptr += 6;
871             }
872         }
873     }
874 
875     /*
876      * @dev Returns true if the slice is empty (has a length of 0).
877      * @param self The slice to operate on.
878      * @return True if the slice is empty, False otherwise.
879      */
880     function empty(slice self) internal pure returns (bool) {
881         return self._len == 0;
882     }
883 
884     /*
885      * @dev Returns a positive number if `other` comes lexicographically after
886      *      `self`, a negative number if it comes before, or zero if the
887      *      contents of the two slices are equal. Comparison is done per-rune,
888      *      on unicode codepoints.
889      * @param self The first slice to compare.
890      * @param other The second slice to compare.
891      * @return The result of the comparison.
892      */
893     function compare(slice self, slice other) internal pure returns (int) {
894         uint shortest = self._len;
895         if (other._len < self._len)
896             shortest = other._len;
897 
898         uint selfptr = self._ptr;
899         uint otherptr = other._ptr;
900         for (uint idx = 0; idx < shortest; idx += 32) {
901             uint a;
902             uint b;
903             assembly {
904                 a := mload(selfptr)
905                 b := mload(otherptr)
906             }
907             if (a != b) {
908                 // Mask out irrelevant bytes and check again
909                 uint256 mask = uint256(-1); // 0xffff...
910                 if(shortest < 32) {
911                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
912                 }
913                 uint256 diff = (a & mask) - (b & mask);
914                 if (diff != 0)
915                     return int(diff);
916             }
917             selfptr += 32;
918             otherptr += 32;
919         }
920         return int(self._len) - int(other._len);
921     }
922 
923     /*
924      * @dev Returns true if the two slices contain the same text.
925      * @param self The first slice to compare.
926      * @param self The second slice to compare.
927      * @return True if the slices are equal, false otherwise.
928      */
929     function equals(slice self, slice other) internal pure returns (bool) {
930         return compare(self, other) == 0;
931     }
932 
933     /*
934      * @dev Extracts the first rune in the slice into `rune`, advancing the
935      *      slice to point to the next rune and returning `self`.
936      * @param self The slice to operate on.
937      * @param rune The slice that will contain the first rune.
938      * @return `rune`.
939      */
940     function nextRune(slice self, slice rune) internal pure returns (slice) {
941         rune._ptr = self._ptr;
942 
943         if (self._len == 0) {
944             rune._len = 0;
945             return rune;
946         }
947 
948         uint l;
949         uint b;
950         // Load the first byte of the rune into the LSBs of b
951         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
952         if (b < 0x80) {
953             l = 1;
954         } else if(b < 0xE0) {
955             l = 2;
956         } else if(b < 0xF0) {
957             l = 3;
958         } else {
959             l = 4;
960         }
961 
962         // Check for truncated codepoints
963         if (l > self._len) {
964             rune._len = self._len;
965             self._ptr += self._len;
966             self._len = 0;
967             return rune;
968         }
969 
970         self._ptr += l;
971         self._len -= l;
972         rune._len = l;
973         return rune;
974     }
975 
976     /*
977      * @dev Returns the first rune in the slice, advancing the slice to point
978      *      to the next rune.
979      * @param self The slice to operate on.
980      * @return A slice containing only the first rune from `self`.
981      */
982     function nextRune(slice self) internal pure returns (slice ret) {
983         nextRune(self, ret);
984     }
985 
986     /*
987      * @dev Returns the number of the first codepoint in the slice.
988      * @param self The slice to operate on.
989      * @return The number of the first codepoint in the slice.
990      */
991     function ord(slice self) internal pure returns (uint ret) {
992         if (self._len == 0) {
993             return 0;
994         }
995 
996         uint word;
997         uint length;
998         uint divisor = 2 ** 248;
999 
1000         // Load the rune into the MSBs of b
1001         assembly { word:= mload(mload(add(self, 32))) }
1002         uint b = word / divisor;
1003         if (b < 0x80) {
1004             ret = b;
1005             length = 1;
1006         } else if(b < 0xE0) {
1007             ret = b & 0x1F;
1008             length = 2;
1009         } else if(b < 0xF0) {
1010             ret = b & 0x0F;
1011             length = 3;
1012         } else {
1013             ret = b & 0x07;
1014             length = 4;
1015         }
1016 
1017         // Check for truncated codepoints
1018         if (length > self._len) {
1019             return 0;
1020         }
1021 
1022         for (uint i = 1; i < length; i++) {
1023             divisor = divisor / 256;
1024             b = (word / divisor) & 0xFF;
1025             if (b & 0xC0 != 0x80) {
1026                 // Invalid UTF-8 sequence
1027                 return 0;
1028             }
1029             ret = (ret * 64) | (b & 0x3F);
1030         }
1031 
1032         return ret;
1033     }
1034 
1035     /*
1036      * @dev Returns the keccak-256 hash of the slice.
1037      * @param self The slice to hash.
1038      * @return The hash of the slice.
1039      */
1040     function keccak(slice self) internal pure returns (bytes32 ret) {
1041         assembly {
1042             ret := keccak256(mload(add(self, 32)), mload(self))
1043         }
1044     }
1045 
1046     /*
1047      * @dev Returns true if `self` starts with `needle`.
1048      * @param self The slice to operate on.
1049      * @param needle The slice to search for.
1050      * @return True if the slice starts with the provided text, false otherwise.
1051      */
1052     function startsWith(slice self, slice needle) internal pure returns (bool) {
1053         if (self._len < needle._len) {
1054             return false;
1055         }
1056 
1057         if (self._ptr == needle._ptr) {
1058             return true;
1059         }
1060 
1061         bool equal;
1062         assembly {
1063             let length := mload(needle)
1064             let selfptr := mload(add(self, 0x20))
1065             let needleptr := mload(add(needle, 0x20))
1066             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1067         }
1068         return equal;
1069     }
1070 
1071     /*
1072      * @dev If `self` starts with `needle`, `needle` is removed from the
1073      *      beginning of `self`. Otherwise, `self` is unmodified.
1074      * @param self The slice to operate on.
1075      * @param needle The slice to search for.
1076      * @return `self`
1077      */
1078     function beyond(slice self, slice needle) internal pure returns (slice) {
1079         if (self._len < needle._len) {
1080             return self;
1081         }
1082 
1083         bool equal = true;
1084         if (self._ptr != needle._ptr) {
1085             assembly {
1086                 let length := mload(needle)
1087                 let selfptr := mload(add(self, 0x20))
1088                 let needleptr := mload(add(needle, 0x20))
1089                 equal := eq(sha3(selfptr, length), sha3(needleptr, length))
1090             }
1091         }
1092 
1093         if (equal) {
1094             self._len -= needle._len;
1095             self._ptr += needle._len;
1096         }
1097 
1098         return self;
1099     }
1100 
1101     /*
1102      * @dev Returns true if the slice ends with `needle`.
1103      * @param self The slice to operate on.
1104      * @param needle The slice to search for.
1105      * @return True if the slice starts with the provided text, false otherwise.
1106      */
1107     function endsWith(slice self, slice needle) internal pure returns (bool) {
1108         if (self._len < needle._len) {
1109             return false;
1110         }
1111 
1112         uint selfptr = self._ptr + self._len - needle._len;
1113 
1114         if (selfptr == needle._ptr) {
1115             return true;
1116         }
1117 
1118         bool equal;
1119         assembly {
1120             let length := mload(needle)
1121             let needleptr := mload(add(needle, 0x20))
1122             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1123         }
1124 
1125         return equal;
1126     }
1127 
1128     /*
1129      * @dev If `self` ends with `needle`, `needle` is removed from the
1130      *      end of `self`. Otherwise, `self` is unmodified.
1131      * @param self The slice to operate on.
1132      * @param needle The slice to search for.
1133      * @return `self`
1134      */
1135     function until(slice self, slice needle) internal pure returns (slice) {
1136         if (self._len < needle._len) {
1137             return self;
1138         }
1139 
1140         uint selfptr = self._ptr + self._len - needle._len;
1141         bool equal = true;
1142         if (selfptr != needle._ptr) {
1143             assembly {
1144                 let length := mload(needle)
1145                 let needleptr := mload(add(needle, 0x20))
1146                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1147             }
1148         }
1149 
1150         if (equal) {
1151             self._len -= needle._len;
1152         }
1153 
1154         return self;
1155     }
1156 
1157     event log_bytemask(bytes32 mask);
1158 
1159     // Returns the memory address of the first byte of the first occurrence of
1160     // `needle` in `self`, or the first byte after `self` if not found.
1161     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
1162         uint ptr = selfptr;
1163         uint idx;
1164 
1165         if (needlelen <= selflen) {
1166             if (needlelen <= 32) {
1167                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
1168 
1169                 bytes32 needledata;
1170                 assembly { needledata := and(mload(needleptr), mask) }
1171 
1172                 uint end = selfptr + selflen - needlelen;
1173                 bytes32 ptrdata;
1174                 assembly { ptrdata := and(mload(ptr), mask) }
1175 
1176                 while (ptrdata != needledata) {
1177                     if (ptr >= end)
1178                         return selfptr + selflen;
1179                     ptr++;
1180                     assembly { ptrdata := and(mload(ptr), mask) }
1181                 }
1182                 return ptr;
1183             } else {
1184                 // For long needles, use hashing
1185                 bytes32 hash;
1186                 assembly { hash := sha3(needleptr, needlelen) }
1187 
1188                 for (idx = 0; idx <= selflen - needlelen; idx++) {
1189                     bytes32 testHash;
1190                     assembly { testHash := sha3(ptr, needlelen) }
1191                     if (hash == testHash)
1192                         return ptr;
1193                     ptr += 1;
1194                 }
1195             }
1196         }
1197         return selfptr + selflen;
1198     }
1199 
1200     // Returns the memory address of the first byte after the last occurrence of
1201     // `needle` in `self`, or the address of `self` if not found.
1202     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
1203         uint ptr;
1204 
1205         if (needlelen <= selflen) {
1206             if (needlelen <= 32) {
1207                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
1208 
1209                 bytes32 needledata;
1210                 assembly { needledata := and(mload(needleptr), mask) }
1211 
1212                 ptr = selfptr + selflen - needlelen;
1213                 bytes32 ptrdata;
1214                 assembly { ptrdata := and(mload(ptr), mask) }
1215 
1216                 while (ptrdata != needledata) {
1217                     if (ptr <= selfptr)
1218                         return selfptr;
1219                     ptr--;
1220                     assembly { ptrdata := and(mload(ptr), mask) }
1221                 }
1222                 return ptr + needlelen;
1223             } else {
1224                 // For long needles, use hashing
1225                 bytes32 hash;
1226                 assembly { hash := sha3(needleptr, needlelen) }
1227                 ptr = selfptr + (selflen - needlelen);
1228                 while (ptr >= selfptr) {
1229                     bytes32 testHash;
1230                     assembly { testHash := sha3(ptr, needlelen) }
1231                     if (hash == testHash)
1232                         return ptr + needlelen;
1233                     ptr -= 1;
1234                 }
1235             }
1236         }
1237         return selfptr;
1238     }
1239 
1240     /*
1241      * @dev Modifies `self` to contain everything from the first occurrence of
1242      *      `needle` to the end of the slice. `self` is set to the empty slice
1243      *      if `needle` is not found.
1244      * @param self The slice to search and modify.
1245      * @param needle The text to search for.
1246      * @return `self`.
1247      */
1248     function find(slice self, slice needle) internal pure returns (slice) {
1249         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1250         self._len -= ptr - self._ptr;
1251         self._ptr = ptr;
1252         return self;
1253     }
1254 
1255     /*
1256      * @dev Modifies `self` to contain the part of the string from the start of
1257      *      `self` to the end of the first occurrence of `needle`. If `needle`
1258      *      is not found, `self` is set to the empty slice.
1259      * @param self The slice to search and modify.
1260      * @param needle The text to search for.
1261      * @return `self`.
1262      */
1263     function rfind(slice self, slice needle) internal pure returns (slice) {
1264         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1265         self._len = ptr - self._ptr;
1266         return self;
1267     }
1268 
1269     /*
1270      * @dev Splits the slice, setting `self` to everything after the first
1271      *      occurrence of `needle`, and `token` to everything before it. If
1272      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1273      *      and `token` is set to the entirety of `self`.
1274      * @param self The slice to split.
1275      * @param needle The text to search for in `self`.
1276      * @param token An output parameter to which the first token is written.
1277      * @return `token`.
1278      */
1279     function split(slice self, slice needle, slice token) internal pure returns (slice) {
1280         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1281         token._ptr = self._ptr;
1282         token._len = ptr - self._ptr;
1283         if (ptr == self._ptr + self._len) {
1284             // Not found
1285             self._len = 0;
1286         } else {
1287             self._len -= token._len + needle._len;
1288             self._ptr = ptr + needle._len;
1289         }
1290         return token;
1291     }
1292 
1293     /*
1294      * @dev Splits the slice, setting `self` to everything after the first
1295      *      occurrence of `needle`, and returning everything before it. If
1296      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1297      *      and the entirety of `self` is returned.
1298      * @param self The slice to split.
1299      * @param needle The text to search for in `self`.
1300      * @return The part of `self` up to the first occurrence of `delim`.
1301      */
1302     function split(slice self, slice needle) internal pure returns (slice token) {
1303         split(self, needle, token);
1304     }
1305 
1306     /*
1307      * @dev Splits the slice, setting `self` to everything before the last
1308      *      occurrence of `needle`, and `token` to everything after it. If
1309      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1310      *      and `token` is set to the entirety of `self`.
1311      * @param self The slice to split.
1312      * @param needle The text to search for in `self`.
1313      * @param token An output parameter to which the first token is written.
1314      * @return `token`.
1315      */
1316     function rsplit(slice self, slice needle, slice token) internal pure returns (slice) {
1317         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1318         token._ptr = ptr;
1319         token._len = self._len - (ptr - self._ptr);
1320         if (ptr == self._ptr) {
1321             // Not found
1322             self._len = 0;
1323         } else {
1324             self._len -= token._len + needle._len;
1325         }
1326         return token;
1327     }
1328 
1329     /*
1330      * @dev Splits the slice, setting `self` to everything before the last
1331      *      occurrence of `needle`, and returning everything after it. If
1332      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1333      *      and the entirety of `self` is returned.
1334      * @param self The slice to split.
1335      * @param needle The text to search for in `self`.
1336      * @return The part of `self` after the last occurrence of `delim`.
1337      */
1338     function rsplit(slice self, slice needle) internal pure returns (slice token) {
1339         rsplit(self, needle, token);
1340     }
1341 
1342     /*
1343      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1344      * @param self The slice to search.
1345      * @param needle The text to search for in `self`.
1346      * @return The number of occurrences of `needle` found in `self`.
1347      */
1348     function count(slice self, slice needle) internal pure returns (uint cnt) {
1349         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1350         while (ptr <= self._ptr + self._len) {
1351             cnt++;
1352             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1353         }
1354     }
1355 
1356     /*
1357      * @dev Returns True if `self` contains `needle`.
1358      * @param self The slice to search.
1359      * @param needle The text to search for in `self`.
1360      * @return True if `needle` is found in `self`, false otherwise.
1361      */
1362     function contains(slice self, slice needle) internal pure returns (bool) {
1363         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1364     }
1365 
1366     /*
1367      * @dev Returns a newly allocated string containing the concatenation of
1368      *      `self` and `other`.
1369      * @param self The first slice to concatenate.
1370      * @param other The second slice to concatenate.
1371      * @return The concatenation of the two strings.
1372      */
1373     function concat(slice self, slice other) internal pure returns (string) {
1374         string memory ret = new string(self._len + other._len);
1375         uint retptr;
1376         assembly { retptr := add(ret, 32) }
1377         memcpy(retptr, self._ptr, self._len);
1378         memcpy(retptr + self._len, other._ptr, other._len);
1379         return ret;
1380     }
1381 
1382     /*
1383      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1384      *      newly allocated string.
1385      * @param self The delimiter to use.
1386      * @param parts A list of slices to join.
1387      * @return A newly allocated string containing all the slices in `parts`,
1388      *         joined with `self`.
1389      */
1390     function join(slice self, slice[] parts) internal pure returns (string) {
1391         if (parts.length == 0)
1392             return "";
1393 
1394         uint length = self._len * (parts.length - 1);
1395         for(uint i = 0; i < parts.length; i++)
1396             length += parts[i]._len;
1397 
1398         string memory ret = new string(length);
1399         uint retptr;
1400         assembly { retptr := add(ret, 32) }
1401 
1402         for(i = 0; i < parts.length; i++) {
1403             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1404             retptr += parts[i]._len;
1405             if (i < parts.length - 1) {
1406                 memcpy(retptr, self._ptr, self._len);
1407                 retptr += self._len;
1408             }
1409         }
1410 
1411         return ret;
1412     }
1413 }
1414 
1415 // File: contracts/token/ERC721/TwitterCoin.sol
1416 
1417 /**
1418  * @title ERC721 Non-Fungible Token
1419  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1420  */
1421 contract Twicoin is ERC721Token, Ownable {
1422     using strings for *;
1423     using SafeMath for uint256;
1424 
1425     constructor(string _name, string _symbol) public ERC721Token(_name, _symbol) {}
1426 
1427     address internal signer;
1428     string internal baseUri;
1429 
1430     function mint(uint _twitterId, uint _price, string _len, uint8 _v, bytes32 _r, bytes32 _s) external payable {
1431         require(!exists(_twitterId));
1432         require(msg.value >= _price);
1433         require(verify(_twitterId, _price, _len,  _v, _r, _s));
1434 
1435         super._mint(msg.sender, _twitterId);
1436     }
1437 
1438     function burn(uint256 _tokenId) external onlyOwnerOf(_tokenId) {
1439         super._burn(msg.sender, _tokenId);
1440     }
1441 
1442     function tokenURI(uint256 _tokenId) public view returns (string) {
1443         require(exists(_tokenId));
1444         return baseUri.toSlice().concat(uintToBytes(_tokenId).toSliceB32());
1445     }
1446 
1447     function withdraw() external onlyOwner {
1448         owner.transfer(address(this).balance);
1449     }
1450 
1451     function setBaseUri(string _uri) external onlyOwner {
1452         baseUri = _uri;
1453     }
1454 
1455     function seSigner(address _signer) external onlyOwner {
1456         signer = _signer;
1457     }
1458 
1459     function getToken(uint _index) external view returns (uint twitterId, address owner){
1460         require(_index < totalSupply()); 
1461         return (allTokens[_index], ownerOf(allTokens[_index]));
1462     }
1463 
1464     function verify(uint _tokenId, uint _price, string _len, uint8 v, bytes32 r, bytes32 s) private view returns (bool) {
1465 
1466         string memory header = "\x19Ethereum Signed Message:\n";
1467         header = header.toSlice().concat(_len.toSlice());
1468         
1469         string memory message = uintToBytes(_tokenId).toSliceB32().concat(" ".toSlice());
1470         message = message.toSlice().concat(uintToBytes(_price).toSliceB32());
1471         
1472         bytes32 check = keccak256(header, message);
1473 
1474         return (signer == ecrecover(check, v, r, s));
1475     }
1476 
1477     function uintToBytes(uint v) private pure returns (bytes32 ret) {
1478         if (v == 0) {
1479             ret = '0';
1480         }
1481         else {
1482             while (v > 0) {
1483                 ret = bytes32(uint(ret) / (2 ** 8));
1484                 ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
1485                 v /= 10;
1486             }
1487         }
1488         return ret;
1489     }
1490 }