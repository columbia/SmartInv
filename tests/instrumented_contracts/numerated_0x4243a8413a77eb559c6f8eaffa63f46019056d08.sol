1 pragma solidity ^0.4.21;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
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
35 // File: node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
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
66 // File: node_modules/openzeppelin-solidity/contracts/AddressUtils.sol
67 
68 /**
69  * Utility library of inline functions on addresses
70  */
71 library AddressUtils {
72 
73   /**
74    * Returns whether the target address is a contract
75    * @dev This function will return false if invoked during the constructor of a contract,
76    *  as the code is not actually created until after the constructor finishes.
77    * @param addr address to check
78    * @return whether the target address is a contract
79    */
80   function isContract(address addr) internal view returns (bool) {
81     uint256 size;
82     // XXX Currently there is no better way to check if there is a contract in an address
83     // than to check the size of the code at that address.
84     // See https://ethereum.stackexchange.com/a/14016/36603
85     // for more details about how this works.
86     // TODO Check this again before the Serenity release, because all addresses will be
87     // contracts then.
88     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
89     return size > 0;
90   }
91 
92 }
93 
94 // File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
95 
96 /**
97  * @title SafeMath
98  * @dev Math operations with safety checks that throw on error
99  */
100 library SafeMath {
101 
102   /**
103   * @dev Multiplies two numbers, throws on overflow.
104   */
105   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
106     if (a == 0) {
107       return 0;
108     }
109     c = a * b;
110     assert(c / a == b);
111     return c;
112   }
113 
114   /**
115   * @dev Integer division of two numbers, truncating the quotient.
116   */
117   function div(uint256 a, uint256 b) internal pure returns (uint256) {
118     // assert(b > 0); // Solidity automatically throws when dividing by 0
119     // uint256 c = a / b;
120     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121     return a / b;
122   }
123 
124   /**
125   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
126   */
127   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128     assert(b <= a);
129     return a - b;
130   }
131 
132   /**
133   * @dev Adds two numbers, throws on overflow.
134   */
135   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
136     c = a + b;
137     assert(c >= a);
138     return c;
139   }
140 }
141 
142 // File: node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
143 
144 /**
145  * @title ERC721 token receiver interface
146  * @dev Interface for any contract that wants to support safeTransfers
147  *  from ERC721 asset contracts.
148  */
149 contract ERC721Receiver {
150   /**
151    * @dev Magic value to be returned upon successful reception of an NFT
152    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
153    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
154    */
155   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
156 
157   /**
158    * @notice Handle the receipt of an NFT
159    * @dev The ERC721 smart contract calls this function on the recipient
160    *  after a `safetransfer`. This function MAY throw to revert and reject the
161    *  transfer. This function MUST use 50,000 gas or less. Return of other
162    *  than the magic value MUST result in the transaction being reverted.
163    *  Note: the contract address is always the message sender.
164    * @param _from The sending address
165    * @param _tokenId The NFT identifier which is being transfered
166    * @param _data Additional data with no specified format
167    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
168    */
169   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
170 }
171 
172 // File: node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
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
462 // File: node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
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
644 // File: contracts/Name.sol
645 
646 contract Name is ERC721Token {
647     mapping(string => bool) internal canonicalNames;
648     mapping(uint256 => string) internal lookupNames;
649     mapping(string => uint256) internal names;
650     uint256 internal topToken;
651 
652     constructor () public
653         ERC721Token('Cryptovoxels Name', 'NAME')
654     {
655         topToken = 0;
656     }
657 
658     /*
659     From https://ethereum.stackexchange.com/questions/10811/solidity-concatenate-uint-into-a-string
660     */
661 
662     function _appendUintToString(string inStr, uint v) internal pure returns (string str) {
663       uint maxlength = 100;
664       bytes memory reversed = new bytes(maxlength);
665       uint i = 0;
666       while (v != 0) {
667           uint remainder = v % 10;
668           v = v / 10;
669           reversed[i++] = byte(48 + remainder);
670       }
671       bytes memory inStrb = bytes(inStr);
672       bytes memory s = new bytes(inStrb.length + i);
673       uint j;
674       for (j = 0; j < inStrb.length; j++) {
675           s[j] = inStrb[j];
676       }
677       for (j = 0; j < i; j++) {
678           s[j + inStrb.length] = reversed[i - 1 - j];
679       }
680       str = string(s);
681     }
682 
683 
684     function _toLower(string str) internal pure returns (string) {
685         bytes memory bStr = bytes(str);
686         bytes memory bLower = new bytes(bStr.length);
687         for (uint i = 0; i < bStr.length; i++) {
688             // Uppercase character...
689             if ((bStr[i] >= 65) && (bStr[i] <= 90)) {
690                 // So we add 32 to make it lowercase
691                 bLower[i] = bytes1(int(bStr[i]) + 32);
692             } else {
693                 bLower[i] = bStr[i];
694             }
695         }
696         return string(bLower);
697     }
698 
699     function _isNameValid(string str) internal pure returns (bool){
700         bytes memory b = bytes(str);
701         if(b.length > 20) return false;
702         if(b.length < 3) return false;
703 
704         for(uint i; i<b.length; i++){
705             bytes1 char = b[i];
706 
707             if(
708                 !(char >= 0x30 && char <= 0x39) && //9-0
709                 !(char >= 0x41 && char <= 0x5A) && //A-Z
710                 !(char >= 0x61 && char <= 0x7A) && //a-z
711                 !(char == 95) && !(char == 45) // _ or -
712 
713             )
714                 return false;
715         }
716 
717         char = b[0];
718 
719         // no punctuation at start
720         if ((char == 95) || (char == 45)) {
721             return false;
722         }
723 
724         char = b[b.length - 1];
725 
726         // no punctuation at end
727         if ((char == 95) || (char == 45)) {
728             return false;
729         }
730 
731         return true;
732     }
733 
734     function mint(
735         address _to,
736         string _name
737     ) public returns (uint256) {
738         require(_isNameValid(_name));
739         string memory canonical = _toLower(_name);
740 
741         require(canonicalNames[canonical] == false);
742 
743         // It's taken
744         canonicalNames[canonical] = true;
745 
746         // Increment totalsupply
747         topToken = topToken + 1;
748 
749         // Use this tokenId
750         uint256 _tokenId = topToken;
751 
752         // Set capitalized name (cant be changed)
753         names[_name] = _tokenId;
754 
755         // Set a lookup
756         lookupNames[_tokenId] = _name;
757 
758         super._mint(_to, _tokenId);
759 
760         return _tokenId;
761     }
762 
763     function tokenURI(uint256 _tokenId) public view returns (string) {
764         return (_appendUintToString("https://www.cryptovoxels.com/n/", _tokenId));
765     }
766 
767     function getName(uint256 _tokenId) public view returns (string) {
768         return lookupNames[_tokenId];
769     }
770 }