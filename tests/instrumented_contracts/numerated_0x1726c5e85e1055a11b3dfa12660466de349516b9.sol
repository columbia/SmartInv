1 pragma solidity 0.4.21;
2 
3 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
4 
5 /**
6  * @title ERC721 Non-Fungible Token Standard basic interface
7  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
8  */
9 contract ERC721Basic {
10   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
11   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
12   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
13 
14   function balanceOf(address _owner) public view returns (uint256 _balance);
15   function ownerOf(uint256 _tokenId) public view returns (address _owner);
16   function exists(uint256 _tokenId) public view returns (bool _exists);
17 
18   function approve(address _to, uint256 _tokenId) public;
19   function getApproved(uint256 _tokenId) public view returns (address _operator);
20 
21   function setApprovalForAll(address _operator, bool _approved) public;
22   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
23 
24   function transferFrom(address _from, address _to, uint256 _tokenId) public;
25   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
26   function safeTransferFrom(
27     address _from,
28     address _to,
29     uint256 _tokenId,
30     bytes _data
31   )
32     public;
33 }
34 
35 // File: zeppelin-solidity/contracts/token/ERC721/ERC721.sol
36 
37 /**
38  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
39  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
40  */
41 contract ERC721Enumerable is ERC721Basic {
42   function totalSupply() public view returns (uint256);
43   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
44   function tokenByIndex(uint256 _index) public view returns (uint256);
45 }
46 
47 
48 /**
49  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
50  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
51  */
52 contract ERC721Metadata is ERC721Basic {
53   function name() public view returns (string _name);
54   function symbol() public view returns (string _symbol);
55   function tokenURI(uint256 _tokenId) public view returns (string);
56 }
57 
58 
59 /**
60  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
61  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
62  */
63 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
64 }
65 
66 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
67 
68 /**
69  * @title ERC721 token receiver interface
70  * @dev Interface for any contract that wants to support safeTransfers
71  *  from ERC721 asset contracts.
72  */
73 contract ERC721Receiver {
74   /**
75    * @dev Magic value to be returned upon successful reception of an NFT
76    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
77    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
78    */
79   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
80 
81   /**
82    * @notice Handle the receipt of an NFT
83    * @dev The ERC721 smart contract calls this function on the recipient
84    *  after a `safetransfer`. This function MAY throw to revert and reject the
85    *  transfer. This function MUST use 50,000 gas or less. Return of other
86    *  than the magic value MUST result in the transaction being reverted.
87    *  Note: the contract address is always the message sender.
88    * @param _from The sending address
89    * @param _tokenId The NFT identifier which is being transfered
90    * @param _data Additional data with no specified format
91    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
92    */
93   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
94 }
95 
96 // File: zeppelin-solidity/contracts/math/SafeMath.sol
97 
98 /**
99  * @title SafeMath
100  * @dev Math operations with safety checks that throw on error
101  */
102 library SafeMath {
103 
104   /**
105   * @dev Multiplies two numbers, throws on overflow.
106   */
107   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
108     if (a == 0) {
109       return 0;
110     }
111     c = a * b;
112     assert(c / a == b);
113     return c;
114   }
115 
116   /**
117   * @dev Integer division of two numbers, truncating the quotient.
118   */
119   function div(uint256 a, uint256 b) internal pure returns (uint256) {
120     // assert(b > 0); // Solidity automatically throws when dividing by 0
121     // uint256 c = a / b;
122     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123     return a / b;
124   }
125 
126   /**
127   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
128   */
129   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
130     assert(b <= a);
131     return a - b;
132   }
133 
134   /**
135   * @dev Adds two numbers, throws on overflow.
136   */
137   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
138     c = a + b;
139     assert(c >= a);
140     return c;
141   }
142 }
143 
144 // File: zeppelin-solidity/contracts/AddressUtils.sol
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
172 // File: zeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
173 
174 /**
175  * @title ERC721 Non-Fungible Token Standard basic implementation
176  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
177  */
178 contract ERC721BasicToken is ERC721Basic {
179   using SafeMath for uint256;
180   using AddressUtils for address;
181 
182   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
183   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
184   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
185 
186   // Mapping from token ID to owner
187   mapping (uint256 => address) internal tokenOwner;
188 
189   // Mapping from token ID to approved address
190   mapping (uint256 => address) internal tokenApprovals;
191 
192   // Mapping from owner to number of owned token
193   mapping (address => uint256) internal ownedTokensCount;
194 
195   // Mapping from owner to operator approvals
196   mapping (address => mapping (address => bool)) internal operatorApprovals;
197 
198   /**
199    * @dev Guarantees msg.sender is owner of the given token
200    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
201    */
202   modifier onlyOwnerOf(uint256 _tokenId) {
203     require(ownerOf(_tokenId) == msg.sender);
204     _;
205   }
206 
207   /**
208    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
209    * @param _tokenId uint256 ID of the token to validate
210    */
211   modifier canTransfer(uint256 _tokenId) {
212     require(isApprovedOrOwner(msg.sender, _tokenId));
213     _;
214   }
215 
216   /**
217    * @dev Gets the balance of the specified address
218    * @param _owner address to query the balance of
219    * @return uint256 representing the amount owned by the passed address
220    */
221   function balanceOf(address _owner) public view returns (uint256) {
222     require(_owner != address(0));
223     return ownedTokensCount[_owner];
224   }
225 
226   /**
227    * @dev Gets the owner of the specified token ID
228    * @param _tokenId uint256 ID of the token to query the owner of
229    * @return owner address currently marked as the owner of the given token ID
230    */
231   function ownerOf(uint256 _tokenId) public view returns (address) {
232     address owner = tokenOwner[_tokenId];
233     require(owner != address(0));
234     return owner;
235   }
236 
237   /**
238    * @dev Returns whether the specified token exists
239    * @param _tokenId uint256 ID of the token to query the existance of
240    * @return whether the token exists
241    */
242   function exists(uint256 _tokenId) public view returns (bool) {
243     address owner = tokenOwner[_tokenId];
244     return owner != address(0);
245   }
246 
247   /**
248    * @dev Approves another address to transfer the given token ID
249    * @dev The zero address indicates there is no approved address.
250    * @dev There can only be one approved address per token at a given time.
251    * @dev Can only be called by the token owner or an approved operator.
252    * @param _to address to be approved for the given token ID
253    * @param _tokenId uint256 ID of the token to be approved
254    */
255   function approve(address _to, uint256 _tokenId) public {
256     address owner = ownerOf(_tokenId);
257     require(_to != owner);
258     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
259 
260     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
261       tokenApprovals[_tokenId] = _to;
262       emit Approval(owner, _to, _tokenId);
263     }
264   }
265 
266   /**
267    * @dev Gets the approved address for a token ID, or zero if no address set
268    * @param _tokenId uint256 ID of the token to query the approval of
269    * @return address currently approved for a the given token ID
270    */
271   function getApproved(uint256 _tokenId) public view returns (address) {
272     return tokenApprovals[_tokenId];
273   }
274 
275   /**
276    * @dev Sets or unsets the approval of a given operator
277    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
278    * @param _to operator address to set the approval
279    * @param _approved representing the status of the approval to be set
280    */
281   function setApprovalForAll(address _to, bool _approved) public {
282     require(_to != msg.sender);
283     operatorApprovals[msg.sender][_to] = _approved;
284     emit ApprovalForAll(msg.sender, _to, _approved);
285   }
286 
287   /**
288    * @dev Tells whether an operator is approved by a given owner
289    * @param _owner owner address which you want to query the approval of
290    * @param _operator operator address which you want to query the approval of
291    * @return bool whether the given operator is approved by the given owner
292    */
293   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
294     return operatorApprovals[_owner][_operator];
295   }
296 
297   /**
298    * @dev Transfers the ownership of a given token ID to another address
299    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
300    * @dev Requires the msg sender to be the owner, approved, or operator
301    * @param _from current owner of the token
302    * @param _to address to receive the ownership of the given token ID
303    * @param _tokenId uint256 ID of the token to be transferred
304   */
305   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
306     require(_from != address(0));
307     require(_to != address(0));
308 
309     clearApproval(_from, _tokenId);
310     removeTokenFrom(_from, _tokenId);
311     addTokenTo(_to, _tokenId);
312 
313     emit Transfer(_from, _to, _tokenId);
314   }
315 
316   /**
317    * @dev Safely transfers the ownership of a given token ID to another address
318    * @dev If the target address is a contract, it must implement `onERC721Received`,
319    *  which is called upon a safe transfer, and return the magic value
320    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
321    *  the transfer is reverted.
322    * @dev Requires the msg sender to be the owner, approved, or operator
323    * @param _from current owner of the token
324    * @param _to address to receive the ownership of the given token ID
325    * @param _tokenId uint256 ID of the token to be transferred
326   */
327   function safeTransferFrom(
328     address _from,
329     address _to,
330     uint256 _tokenId
331   )
332     public
333     canTransfer(_tokenId)
334   {
335     // solium-disable-next-line arg-overflow
336     safeTransferFrom(_from, _to, _tokenId, "");
337   }
338 
339   /**
340    * @dev Safely transfers the ownership of a given token ID to another address
341    * @dev If the target address is a contract, it must implement `onERC721Received`,
342    *  which is called upon a safe transfer, and return the magic value
343    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
344    *  the transfer is reverted.
345    * @dev Requires the msg sender to be the owner, approved, or operator
346    * @param _from current owner of the token
347    * @param _to address to receive the ownership of the given token ID
348    * @param _tokenId uint256 ID of the token to be transferred
349    * @param _data bytes data to send along with a safe transfer check
350    */
351   function safeTransferFrom(
352     address _from,
353     address _to,
354     uint256 _tokenId,
355     bytes _data
356   )
357     public
358     canTransfer(_tokenId)
359   {
360     transferFrom(_from, _to, _tokenId);
361     // solium-disable-next-line arg-overflow
362     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
363   }
364 
365   /**
366    * @dev Returns whether the given spender can transfer a given token ID
367    * @param _spender address of the spender to query
368    * @param _tokenId uint256 ID of the token to be transferred
369    * @return bool whether the msg.sender is approved for the given token ID,
370    *  is an operator of the owner, or is the owner of the token
371    */
372   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
373     address owner = ownerOf(_tokenId);
374     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
375   }
376 
377   /**
378    * @dev Internal function to mint a new token
379    * @dev Reverts if the given token ID already exists
380    * @param _to The address that will own the minted token
381    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
382    */
383   function _mint(address _to, uint256 _tokenId) internal {
384     require(_to != address(0));
385     addTokenTo(_to, _tokenId);
386     emit Transfer(address(0), _to, _tokenId);
387   }
388 
389   /**
390    * @dev Internal function to burn a specific token
391    * @dev Reverts if the token does not exist
392    * @param _tokenId uint256 ID of the token being burned by the msg.sender
393    */
394   function _burn(address _owner, uint256 _tokenId) internal {
395     clearApproval(_owner, _tokenId);
396     removeTokenFrom(_owner, _tokenId);
397     emit Transfer(_owner, address(0), _tokenId);
398   }
399 
400   /**
401    * @dev Internal function to clear current approval of a given token ID
402    * @dev Reverts if the given address is not indeed the owner of the token
403    * @param _owner owner of the token
404    * @param _tokenId uint256 ID of the token to be transferred
405    */
406   function clearApproval(address _owner, uint256 _tokenId) internal {
407     require(ownerOf(_tokenId) == _owner);
408     if (tokenApprovals[_tokenId] != address(0)) {
409       tokenApprovals[_tokenId] = address(0);
410       emit Approval(_owner, address(0), _tokenId);
411     }
412   }
413 
414   /**
415    * @dev Internal function to add a token ID to the list of a given address
416    * @param _to address representing the new owner of the given token ID
417    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
418    */
419   function addTokenTo(address _to, uint256 _tokenId) internal {
420     require(tokenOwner[_tokenId] == address(0));
421     tokenOwner[_tokenId] = _to;
422     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
423   }
424 
425   /**
426    * @dev Internal function to remove a token ID from the list of a given address
427    * @param _from address representing the previous owner of the given token ID
428    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
429    */
430   function removeTokenFrom(address _from, uint256 _tokenId) internal {
431     require(ownerOf(_tokenId) == _from);
432     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
433     tokenOwner[_tokenId] = address(0);
434   }
435 
436   /**
437    * @dev Internal function to invoke `onERC721Received` on a target address
438    * @dev The call is not executed if the target address is not a contract
439    * @param _from address representing the previous owner of the given token ID
440    * @param _to target address that will receive the tokens
441    * @param _tokenId uint256 ID of the token to be transferred
442    * @param _data bytes optional data to send along with the call
443    * @return whether the call correctly returned the expected magic value
444    */
445   function checkAndCallSafeTransfer(
446     address _from,
447     address _to,
448     uint256 _tokenId,
449     bytes _data
450   )
451     internal
452     returns (bool)
453   {
454     if (!_to.isContract()) {
455       return true;
456     }
457     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
458     return (retval == ERC721_RECEIVED);
459   }
460 }
461 
462 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
463 
464 /**
465  * @title Full ERC721 Token
466  * This implementation includes all the required and some optional functionality of the ERC721 standard
467  * Moreover, it includes approve all functionality using operator terminology
468  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
469  */
470 contract ERC721Token is ERC721, ERC721BasicToken {
471   // Token name
472   string internal name_;
473 
474   // Token symbol
475   string internal symbol_;
476 
477   // Mapping from owner to list of owned token IDs
478   mapping (address => uint256[]) internal ownedTokens;
479 
480   // Mapping from token ID to index of the owner tokens list
481   mapping(uint256 => uint256) internal ownedTokensIndex;
482 
483   // Array with all token ids, used for enumeration
484   uint256[] internal allTokens;
485 
486   // Mapping from token id to position in the allTokens array
487   mapping(uint256 => uint256) internal allTokensIndex;
488 
489   // Optional mapping for token URIs
490   mapping(uint256 => string) internal tokenURIs;
491 
492   /**
493    * @dev Constructor function
494    */
495   function ERC721Token(string _name, string _symbol) public {
496     name_ = _name;
497     symbol_ = _symbol;
498   }
499 
500   /**
501    * @dev Gets the token name
502    * @return string representing the token name
503    */
504   function name() public view returns (string) {
505     return name_;
506   }
507 
508   /**
509    * @dev Gets the token symbol
510    * @return string representing the token symbol
511    */
512   function symbol() public view returns (string) {
513     return symbol_;
514   }
515 
516   /**
517    * @dev Returns an URI for a given token ID
518    * @dev Throws if the token ID does not exist. May return an empty string.
519    * @param _tokenId uint256 ID of the token to query
520    */
521   function tokenURI(uint256 _tokenId) public view returns (string) {
522     require(exists(_tokenId));
523     return tokenURIs[_tokenId];
524   }
525 
526   /**
527    * @dev Gets the token ID at a given index of the tokens list of the requested owner
528    * @param _owner address owning the tokens list to be accessed
529    * @param _index uint256 representing the index to be accessed of the requested tokens list
530    * @return uint256 token ID at the given index of the tokens list owned by the requested address
531    */
532   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
533     require(_index < balanceOf(_owner));
534     return ownedTokens[_owner][_index];
535   }
536 
537   /**
538    * @dev Gets the total amount of tokens stored by the contract
539    * @return uint256 representing the total amount of tokens
540    */
541   function totalSupply() public view returns (uint256) {
542     return allTokens.length;
543   }
544 
545   /**
546    * @dev Gets the token ID at a given index of all the tokens in this contract
547    * @dev Reverts if the index is greater or equal to the total number of tokens
548    * @param _index uint256 representing the index to be accessed of the tokens list
549    * @return uint256 token ID at the given index of the tokens list
550    */
551   function tokenByIndex(uint256 _index) public view returns (uint256) {
552     require(_index < totalSupply());
553     return allTokens[_index];
554   }
555 
556   /**
557    * @dev Internal function to set the token URI for a given token
558    * @dev Reverts if the token ID does not exist
559    * @param _tokenId uint256 ID of the token to set its URI
560    * @param _uri string URI to assign
561    */
562   function _setTokenURI(uint256 _tokenId, string _uri) internal {
563     require(exists(_tokenId));
564     tokenURIs[_tokenId] = _uri;
565   }
566 
567   /**
568    * @dev Internal function to add a token ID to the list of a given address
569    * @param _to address representing the new owner of the given token ID
570    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
571    */
572   function addTokenTo(address _to, uint256 _tokenId) internal {
573     super.addTokenTo(_to, _tokenId);
574     uint256 length = ownedTokens[_to].length;
575     ownedTokens[_to].push(_tokenId);
576     ownedTokensIndex[_tokenId] = length;
577   }
578 
579   /**
580    * @dev Internal function to remove a token ID from the list of a given address
581    * @param _from address representing the previous owner of the given token ID
582    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
583    */
584   function removeTokenFrom(address _from, uint256 _tokenId) internal {
585     super.removeTokenFrom(_from, _tokenId);
586 
587     uint256 tokenIndex = ownedTokensIndex[_tokenId];
588     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
589     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
590 
591     ownedTokens[_from][tokenIndex] = lastToken;
592     ownedTokens[_from][lastTokenIndex] = 0;
593     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
594     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
595     // the lastToken to the first position, and then dropping the element placed in the last position of the list
596 
597     ownedTokens[_from].length--;
598     ownedTokensIndex[_tokenId] = 0;
599     ownedTokensIndex[lastToken] = tokenIndex;
600   }
601 
602   /**
603    * @dev Internal function to mint a new token
604    * @dev Reverts if the given token ID already exists
605    * @param _to address the beneficiary that will own the minted token
606    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
607    */
608   function _mint(address _to, uint256 _tokenId) internal {
609     super._mint(_to, _tokenId);
610 
611     allTokensIndex[_tokenId] = allTokens.length;
612     allTokens.push(_tokenId);
613   }
614 
615   /**
616    * @dev Internal function to burn a specific token
617    * @dev Reverts if the token does not exist
618    * @param _owner owner of the token to burn
619    * @param _tokenId uint256 ID of the token being burned by the msg.sender
620    */
621   function _burn(address _owner, uint256 _tokenId) internal {
622     super._burn(_owner, _tokenId);
623 
624     // Clear metadata (if any)
625     if (bytes(tokenURIs[_tokenId]).length != 0) {
626       delete tokenURIs[_tokenId];
627     }
628 
629     // Reorg all tokens array
630     uint256 tokenIndex = allTokensIndex[_tokenId];
631     uint256 lastTokenIndex = allTokens.length.sub(1);
632     uint256 lastToken = allTokens[lastTokenIndex];
633 
634     allTokens[tokenIndex] = lastToken;
635     allTokens[lastTokenIndex] = 0;
636 
637     allTokens.length--;
638     allTokensIndex[_tokenId] = 0;
639     allTokensIndex[lastToken] = tokenIndex;
640   }
641 
642 }
643 
644 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
645 
646 /**
647  * @title Ownable
648  * @dev The Ownable contract has an owner address, and provides basic authorization control
649  * functions, this simplifies the implementation of "user permissions".
650  */
651 contract Ownable {
652   address public owner;
653 
654 
655   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
656 
657 
658   /**
659    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
660    * account.
661    */
662   function Ownable() public {
663     owner = msg.sender;
664   }
665 
666   /**
667    * @dev Throws if called by any account other than the owner.
668    */
669   modifier onlyOwner() {
670     require(msg.sender == owner);
671     _;
672   }
673 
674   /**
675    * @dev Allows the current owner to transfer control of the contract to a newOwner.
676    * @param newOwner The address to transfer ownership to.
677    */
678   function transferOwnership(address newOwner) public onlyOwner {
679     require(newOwner != address(0));
680     emit OwnershipTransferred(owner, newOwner);
681     owner = newOwner;
682   }
683 
684 }
685 
686 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
687 
688 /**
689  * @title ERC20Basic
690  * @dev Simpler version of ERC20 interface
691  * @dev see https://github.com/ethereum/EIPs/issues/179
692  */
693 contract ERC20Basic {
694   function totalSupply() public view returns (uint256);
695   function balanceOf(address who) public view returns (uint256);
696   function transfer(address to, uint256 value) public returns (bool);
697   event Transfer(address indexed from, address indexed to, uint256 value);
698 }
699 
700 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
701 
702 /**
703  * @title Basic token
704  * @dev Basic version of StandardToken, with no allowances.
705  */
706 contract BasicToken is ERC20Basic {
707   using SafeMath for uint256;
708 
709   mapping(address => uint256) balances;
710 
711   uint256 totalSupply_;
712 
713   /**
714   * @dev total number of tokens in existence
715   */
716   function totalSupply() public view returns (uint256) {
717     return totalSupply_;
718   }
719 
720   /**
721   * @dev transfer token for a specified address
722   * @param _to The address to transfer to.
723   * @param _value The amount to be transferred.
724   */
725   function transfer(address _to, uint256 _value) public returns (bool) {
726     require(_to != address(0));
727     require(_value <= balances[msg.sender]);
728 
729     balances[msg.sender] = balances[msg.sender].sub(_value);
730     balances[_to] = balances[_to].add(_value);
731     emit Transfer(msg.sender, _to, _value);
732     return true;
733   }
734 
735   /**
736   * @dev Gets the balance of the specified address.
737   * @param _owner The address to query the the balance of.
738   * @return An uint256 representing the amount owned by the passed address.
739   */
740   function balanceOf(address _owner) public view returns (uint256) {
741     return balances[_owner];
742   }
743 
744 }
745 
746 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
747 
748 /**
749  * @title ERC20 interface
750  * @dev see https://github.com/ethereum/EIPs/issues/20
751  */
752 contract ERC20 is ERC20Basic {
753   function allowance(address owner, address spender) public view returns (uint256);
754   function transferFrom(address from, address to, uint256 value) public returns (bool);
755   function approve(address spender, uint256 value) public returns (bool);
756   event Approval(address indexed owner, address indexed spender, uint256 value);
757 }
758 
759 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
760 
761 /**
762  * @title Standard ERC20 token
763  *
764  * @dev Implementation of the basic standard token.
765  * @dev https://github.com/ethereum/EIPs/issues/20
766  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
767  */
768 contract StandardToken is ERC20, BasicToken {
769 
770   mapping (address => mapping (address => uint256)) internal allowed;
771 
772 
773   /**
774    * @dev Transfer tokens from one address to another
775    * @param _from address The address which you want to send tokens from
776    * @param _to address The address which you want to transfer to
777    * @param _value uint256 the amount of tokens to be transferred
778    */
779   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
780     require(_to != address(0));
781     require(_value <= balances[_from]);
782     require(_value <= allowed[_from][msg.sender]);
783 
784     balances[_from] = balances[_from].sub(_value);
785     balances[_to] = balances[_to].add(_value);
786     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
787     emit Transfer(_from, _to, _value);
788     return true;
789   }
790 
791   /**
792    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
793    *
794    * Beware that changing an allowance with this method brings the risk that someone may use both the old
795    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
796    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
797    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
798    * @param _spender The address which will spend the funds.
799    * @param _value The amount of tokens to be spent.
800    */
801   function approve(address _spender, uint256 _value) public returns (bool) {
802     allowed[msg.sender][_spender] = _value;
803     emit Approval(msg.sender, _spender, _value);
804     return true;
805   }
806 
807   /**
808    * @dev Function to check the amount of tokens that an owner allowed to a spender.
809    * @param _owner address The address which owns the funds.
810    * @param _spender address The address which will spend the funds.
811    * @return A uint256 specifying the amount of tokens still available for the spender.
812    */
813   function allowance(address _owner, address _spender) public view returns (uint256) {
814     return allowed[_owner][_spender];
815   }
816 
817   /**
818    * @dev Increase the amount of tokens that an owner allowed to a spender.
819    *
820    * approve should be called when allowed[_spender] == 0. To increment
821    * allowed value is better to use this function to avoid 2 calls (and wait until
822    * the first transaction is mined)
823    * From MonolithDAO Token.sol
824    * @param _spender The address which will spend the funds.
825    * @param _addedValue The amount of tokens to increase the allowance by.
826    */
827   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
828     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
829     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
830     return true;
831   }
832 
833   /**
834    * @dev Decrease the amount of tokens that an owner allowed to a spender.
835    *
836    * approve should be called when allowed[_spender] == 0. To decrement
837    * allowed value is better to use this function to avoid 2 calls (and wait until
838    * the first transaction is mined)
839    * From MonolithDAO Token.sol
840    * @param _spender The address which will spend the funds.
841    * @param _subtractedValue The amount of tokens to decrease the allowance by.
842    */
843   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
844     uint oldValue = allowed[msg.sender][_spender];
845     if (_subtractedValue > oldValue) {
846       allowed[msg.sender][_spender] = 0;
847     } else {
848       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
849     }
850     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
851     return true;
852   }
853 
854 }
855 
856 // File: contracts/IWasFirstServiceToken.sol
857 
858 contract IWasFirstServiceToken is StandardToken, Ownable {
859 
860     string public constant NAME = "IWasFirstServiceToken"; // solium-disable-line uppercase
861     string public constant SYMBOL = "IWF"; // solium-disable-line uppercase
862     uint8 public constant DECIMALS = 18; // solium-disable-line uppercase
863 
864     uint256 public constant INITIAL_SUPPLY = 10000000 * (10 ** uint256(DECIMALS));
865     address fungibleTokenAddress;
866     address shareTokenAddress;
867 
868     /**
869      * @dev Constructor that gives msg.sender all of existing tokens.
870      */
871     function IWasFirstServiceToken() public {
872         totalSupply_ = INITIAL_SUPPLY;
873         balances[msg.sender] = INITIAL_SUPPLY;
874        emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
875     }
876 
877     function getFungibleTokenAddress() public view returns (address) {
878         return fungibleTokenAddress;
879     }
880 
881     function setFungibleTokenAddress(address _address) onlyOwner() public {
882         require(fungibleTokenAddress == address(0));
883         fungibleTokenAddress = _address;
884     }
885 
886     function getShareTokenAddress() public view returns (address) {
887         return shareTokenAddress;
888     }
889 
890     function setShareTokenAddress(address _address) onlyOwner() public {
891         require(shareTokenAddress == address(0));
892         shareTokenAddress = _address;
893     }
894 
895     function transferByRelatedToken(address _from, address _to, uint256 _value) public returns (bool) {
896         require(msg.sender == fungibleTokenAddress || msg.sender == shareTokenAddress);
897         require(_to != address(0));
898         require(_value <= balances[_from]);
899 
900         balances[_from] = balances[_from].sub(_value);
901         balances[_to] = balances[_to].add(_value);
902         emit Transfer(_from, _to, _value);
903         return true;
904     }
905 }
906 
907 // File: contracts/IWasFirstFungibleToken.sol
908 
909 contract IWasFirstFungibleToken is ERC721Token("IWasFirstFungible", "IWX"), Ownable {
910 
911     struct TokenMetaData {
912         uint creationTime;
913         string creatorMetadataJson;
914     }
915     address _serviceTokenAddress;
916     address _shareTokenAddress;
917     mapping (uint256 => string) internal tokenHash;
918     mapping (string => uint256) internal tokenIdOfHash;
919     uint256 internal tokenIdSeq = 1;
920     mapping (uint256 => TokenMetaData[]) internal tokenMetaData;
921     
922     function hashExists(string hash) public view returns (bool) {
923         return tokenIdOfHash[hash] != 0;
924     }
925 
926     function mint(string hash, string creatorMetadataJson) external {
927         require(!hashExists(hash));
928         uint256 currentTokenId = tokenIdSeq;
929         tokenIdSeq = tokenIdSeq + 1;
930         IWasFirstServiceToken serviceToken = IWasFirstServiceToken(_serviceTokenAddress);
931         serviceToken.transferByRelatedToken(msg.sender, _shareTokenAddress, 10 ** uint256(serviceToken.DECIMALS()));
932         tokenHash[currentTokenId] = hash;
933         tokenIdOfHash[hash] = currentTokenId;
934         tokenMetaData[currentTokenId].push(TokenMetaData(now, creatorMetadataJson));
935         super._mint(msg.sender, currentTokenId);
936     }
937 
938     function getTokenCreationTime(string hash) public view returns(uint) {
939         require(hashExists(hash));
940         uint length = tokenMetaData[tokenIdOfHash[hash]].length;
941         return tokenMetaData[tokenIdOfHash[hash]][length-1].creationTime;
942     }
943 
944     function getCreatorMetadata(string hash) public view returns(string) {
945         require(hashExists(hash));
946         uint length = tokenMetaData[tokenIdOfHash[hash]].length;
947         return tokenMetaData[tokenIdOfHash[hash]][length-1].creatorMetadataJson;
948     }
949 
950     function getMetadataHistoryLength(string hash) public view returns(uint) {
951         if(hashExists(hash)) {
952             return tokenMetaData[tokenIdOfHash[hash]].length;
953         } else {
954             return 0;
955         }
956     }
957 
958     function getCreationDateOfHistoricalMetadata(string hash, uint index) public view returns(uint) {
959         require(hashExists(hash));
960         return tokenMetaData[tokenIdOfHash[hash]][index].creationTime;
961     }
962 
963     function getCreatorMetadataOfHistoricalMetadata(string hash, uint index) public view returns(string) {
964         require(hashExists(hash));
965         return tokenMetaData[tokenIdOfHash[hash]][index].creatorMetadataJson;
966     }
967 
968     function updateMetadata(string hash, string creatorMetadataJson) public {
969         require(hashExists(hash));
970         require(ownerOf(tokenIdOfHash[hash]) == msg.sender);
971         tokenMetaData[tokenIdOfHash[hash]].push(TokenMetaData(now, creatorMetadataJson));
972     }
973 
974     function getTokenIdByHash(string hash) public view returns(uint256) {
975         require(hashExists(hash));
976         return tokenIdOfHash[hash];
977     }
978 
979     function getHashByTokenId(uint256 tokenId) public view returns(string) {
980         require(exists(tokenId));
981         return tokenHash[tokenId];
982     }
983 
984     function getNumberOfTokens() public view returns(uint) {
985         return allTokens.length;
986     }
987 
988     function setServiceTokenAddress(address serviceTokenAdress) onlyOwner() public {
989         require(_serviceTokenAddress == address(0));
990         _serviceTokenAddress = serviceTokenAdress;
991     }
992 
993     function getServiceTokenAddress() public view returns(address) {
994         return _serviceTokenAddress;
995     }
996 
997     function setShareTokenAddress(address shareTokenAdress) onlyOwner() public {
998         require(_shareTokenAddress == address(0));
999         _shareTokenAddress = shareTokenAdress;
1000     }
1001 
1002     function getShareTokenAddress() public view returns(address) {
1003         return _shareTokenAddress;
1004     }
1005 }