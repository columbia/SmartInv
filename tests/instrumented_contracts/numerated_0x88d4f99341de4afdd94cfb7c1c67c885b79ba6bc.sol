1 pragma solidity ^0.4.23;
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
644 // File: @ensdomains/ens/contracts/Deed.sol
645 
646 /**
647  * @title Deed to hold ether in exchange for ownership of a node
648  * @dev The deed can be controlled only by the registrar and can only send ether back to the owner.
649  */
650 contract Deed {
651 
652     address constant burn = 0xdead;
653 
654     address public registrar;
655     address public owner;
656     address public previousOwner;
657 
658     uint public creationDate;
659     uint public value;
660 
661     bool active;
662 
663     event OwnerChanged(address newOwner);
664     event DeedClosed();
665 
666     modifier onlyRegistrar {
667         require(msg.sender == registrar);
668         _;
669     }
670 
671     modifier onlyActive {
672         require(active);
673         _;
674     }
675 
676     function Deed(address _owner) public payable {
677         owner = _owner;
678         registrar = msg.sender;
679         creationDate = now;
680         active = true;
681         value = msg.value;
682     }
683 
684     function setOwner(address newOwner) public onlyRegistrar {
685         require(newOwner != 0);
686         previousOwner = owner;  // This allows contracts to check who sent them the ownership
687         owner = newOwner;
688         OwnerChanged(newOwner);
689     }
690 
691     function setRegistrar(address newRegistrar) public onlyRegistrar {
692         registrar = newRegistrar;
693     }
694 
695     function setBalance(uint newValue, bool throwOnFailure) public onlyRegistrar onlyActive {
696         // Check if it has enough balance to set the value
697         require(value >= newValue);
698         value = newValue;
699         // Send the difference to the owner
700         require(owner.send(this.balance - newValue) || !throwOnFailure);
701     }
702 
703     /**
704      * @dev Close a deed and refund a specified fraction of the bid value
705      *
706      * @param refundRatio The amount*1/1000 to refund
707      */
708     function closeDeed(uint refundRatio) public onlyRegistrar onlyActive {
709         active = false;
710         require(burn.send(((1000 - refundRatio) * this.balance)/1000));
711         DeedClosed();
712         destroyDeed();
713     }
714 
715     /**
716      * @dev Close a deed and refund a specified fraction of the bid value
717      */
718     function destroyDeed() public {
719         require(!active);
720 
721         // Instead of selfdestruct(owner), invoke owner fallback function to allow
722         // owner to log an event if desired; but owner should also be aware that
723         // its fallback function can also be invoked by setBalance
724         if (owner.send(this.balance)) {
725             selfdestruct(burn);
726         }
727     }
728 }
729 
730 // File: @ensdomains/ens/contracts/ENS.sol
731 
732 interface ENS {
733 
734     // Logged when the owner of a node assigns a new owner to a subnode.
735     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
736 
737     // Logged when the owner of a node transfers ownership to a new account.
738     event Transfer(bytes32 indexed node, address owner);
739 
740     // Logged when the resolver for a node changes.
741     event NewResolver(bytes32 indexed node, address resolver);
742 
743     // Logged when the TTL of a node changes
744     event NewTTL(bytes32 indexed node, uint64 ttl);
745 
746 
747     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) public;
748     function setResolver(bytes32 node, address resolver) public;
749     function setOwner(bytes32 node, address owner) public;
750     function setTTL(bytes32 node, uint64 ttl) public;
751     function owner(bytes32 node) public view returns (address);
752     function resolver(bytes32 node) public view returns (address);
753     function ttl(bytes32 node) public view returns (uint64);
754 
755 }
756 
757 // File: @ensdomains/ens/contracts/HashRegistrarSimplified.sol
758 
759 /*
760 
761 Temporary Hash Registrar
762 ========================
763 
764 This is a simplified version of a hash registrar. It is purporsefully limited:
765 names cannot be six letters or shorter, new auctions will stop after 4 years.
766 
767 The plan is to test the basic features and then move to a new contract in at most
768 2 years, when some sort of renewal mechanism will be enabled.
769 */
770 
771 
772 
773 /**
774  * @title Registrar
775  * @dev The registrar handles the auction process for each subnode of the node it owns.
776  */
777 contract Registrar {
778     ENS public ens;
779     bytes32 public rootNode;
780 
781     mapping (bytes32 => Entry) _entries;
782     mapping (address => mapping (bytes32 => Deed)) public sealedBids;
783     
784     enum Mode { Open, Auction, Owned, Forbidden, Reveal, NotYetAvailable }
785 
786     uint32 constant totalAuctionLength = 5 days;
787     uint32 constant revealPeriod = 48 hours;
788     uint32 public constant launchLength = 8 weeks;
789 
790     uint constant minPrice = 0.01 ether;
791     uint public registryStarted;
792 
793     event AuctionStarted(bytes32 indexed hash, uint registrationDate);
794     event NewBid(bytes32 indexed hash, address indexed bidder, uint deposit);
795     event BidRevealed(bytes32 indexed hash, address indexed owner, uint value, uint8 status);
796     event HashRegistered(bytes32 indexed hash, address indexed owner, uint value, uint registrationDate);
797     event HashReleased(bytes32 indexed hash, uint value);
798     event HashInvalidated(bytes32 indexed hash, string indexed name, uint value, uint registrationDate);
799 
800     struct Entry {
801         Deed deed;
802         uint registrationDate;
803         uint value;
804         uint highestBid;
805     }
806 
807     modifier inState(bytes32 _hash, Mode _state) {
808         require(state(_hash) == _state);
809         _;
810     }
811 
812     modifier onlyOwner(bytes32 _hash) {
813         require(state(_hash) == Mode.Owned && msg.sender == _entries[_hash].deed.owner());
814         _;
815     }
816 
817     modifier registryOpen() {
818         require(now >= registryStarted && now <= registryStarted + 4 years && ens.owner(rootNode) == address(this));
819         _;
820     }
821 
822     /**
823      * @dev Constructs a new Registrar, with the provided address as the owner of the root node.
824      *
825      * @param _ens The address of the ENS
826      * @param _rootNode The hash of the rootnode.
827      */
828     function Registrar(ENS _ens, bytes32 _rootNode, uint _startDate) public {
829         ens = _ens;
830         rootNode = _rootNode;
831         registryStarted = _startDate > 0 ? _startDate : now;
832     }
833 
834     /**
835      * @dev Start an auction for an available hash
836      *
837      * @param _hash The hash to start an auction on
838      */
839     function startAuction(bytes32 _hash) public registryOpen() {
840         Mode mode = state(_hash);
841         if (mode == Mode.Auction) return;
842         require(mode == Mode.Open);
843 
844         Entry storage newAuction = _entries[_hash];
845         newAuction.registrationDate = now + totalAuctionLength;
846         newAuction.value = 0;
847         newAuction.highestBid = 0;
848         AuctionStarted(_hash, newAuction.registrationDate);
849     }
850 
851     /**
852      * @dev Start multiple auctions for better anonymity
853      *
854      * Anyone can start an auction by sending an array of hashes that they want to bid for.
855      * Arrays are sent so that someone can open up an auction for X dummy hashes when they
856      * are only really interested in bidding for one. This will increase the cost for an
857      * attacker to simply bid blindly on all new auctions. Dummy auctions that are
858      * open but not bid on are closed after a week.
859      *
860      * @param _hashes An array of hashes, at least one of which you presumably want to bid on
861      */
862     function startAuctions(bytes32[] _hashes) public {
863         for (uint i = 0; i < _hashes.length; i ++) {
864             startAuction(_hashes[i]);
865         }
866     }
867 
868     /**
869      * @dev Submit a new sealed bid on a desired hash in a blind auction
870      *
871      * Bids are sent by sending a message to the main contract with a hash and an amount. The hash
872      * contains information about the bid, including the bidded hash, the bid amount, and a random
873      * salt. Bids are not tied to any one auction until they are revealed. The value of the bid
874      * itself can be masqueraded by sending more than the value of your actual bid. This is
875      * followed by a 48h reveal period. Bids revealed after this period will be burned and the ether unrecoverable.
876      * Since this is an auction, it is expected that most public hashes, like known domains and common dictionary
877      * words, will have multiple bidders pushing the price up.
878      *
879      * @param sealedBid A sealedBid, created by the shaBid function
880      */
881     function newBid(bytes32 sealedBid) public payable {
882         require(address(sealedBids[msg.sender][sealedBid]) == 0x0);
883         require(msg.value >= minPrice);
884 
885         // Creates a new hash contract with the owner
886         Deed newBid = (new Deed).value(msg.value)(msg.sender);
887         sealedBids[msg.sender][sealedBid] = newBid;
888         NewBid(sealedBid, msg.sender, msg.value);
889     }
890 
891     /**
892      * @dev Start a set of auctions and bid on one of them
893      *
894      * This method functions identically to calling `startAuctions` followed by `newBid`,
895      * but all in one transaction.
896      *
897      * @param hashes A list of hashes to start auctions on.
898      * @param sealedBid A sealed bid for one of the auctions.
899      */
900     function startAuctionsAndBid(bytes32[] hashes, bytes32 sealedBid) public payable {
901         startAuctions(hashes);
902         newBid(sealedBid);
903     }
904 
905     /**
906      * @dev Submit the properties of a bid to reveal them
907      *
908      * @param _hash The node in the sealedBid
909      * @param _value The bid amount in the sealedBid
910      * @param _salt The sale in the sealedBid
911      */
912     function unsealBid(bytes32 _hash, uint _value, bytes32 _salt) public {
913         bytes32 seal = shaBid(_hash, msg.sender, _value, _salt);
914         Deed bid = sealedBids[msg.sender][seal];
915         require(address(bid) != 0);
916 
917         sealedBids[msg.sender][seal] = Deed(0);
918         Entry storage h = _entries[_hash];
919         uint value = min(_value, bid.value());
920         bid.setBalance(value, true);
921 
922         var auctionState = state(_hash);
923         if (auctionState == Mode.Owned) {
924             // Too late! Bidder loses their bid. Gets 0.5% back.
925             bid.closeDeed(5);
926             BidRevealed(_hash, msg.sender, value, 1);
927         } else if (auctionState != Mode.Reveal) {
928             // Invalid phase
929             revert();
930         } else if (value < minPrice || bid.creationDate() > h.registrationDate - revealPeriod) {
931             // Bid too low or too late, refund 99.5%
932             bid.closeDeed(995);
933             BidRevealed(_hash, msg.sender, value, 0);
934         } else if (value > h.highestBid) {
935             // New winner
936             // Cancel the other bid, refund 99.5%
937             if (address(h.deed) != 0) {
938                 Deed previousWinner = h.deed;
939                 previousWinner.closeDeed(995);
940             }
941 
942             // Set new winner
943             // Per the rules of a vickery auction, the value becomes the previous highestBid
944             h.value = h.highestBid;  // will be zero if there's only 1 bidder
945             h.highestBid = value;
946             h.deed = bid;
947             BidRevealed(_hash, msg.sender, value, 2);
948         } else if (value > h.value) {
949             // Not winner, but affects second place
950             h.value = value;
951             bid.closeDeed(995);
952             BidRevealed(_hash, msg.sender, value, 3);
953         } else {
954             // Bid doesn't affect auction
955             bid.closeDeed(995);
956             BidRevealed(_hash, msg.sender, value, 4);
957         }
958     }
959 
960     /**
961      * @dev Cancel a bid
962      *
963      * @param seal The value returned by the shaBid function
964      */
965     function cancelBid(address bidder, bytes32 seal) public {
966         Deed bid = sealedBids[bidder][seal];
967         
968         // If a sole bidder does not `unsealBid` in time, they have a few more days
969         // where they can call `startAuction` (again) and then `unsealBid` during
970         // the revealPeriod to get back their bid value.
971         // For simplicity, they should call `startAuction` within
972         // 9 days (2 weeks - totalAuctionLength), otherwise their bid will be
973         // cancellable by anyone.
974         require(address(bid) != 0 && now >= bid.creationDate() + totalAuctionLength + 2 weeks);
975 
976         // Send the canceller 0.5% of the bid, and burn the rest.
977         bid.setOwner(msg.sender);
978         bid.closeDeed(5);
979         sealedBids[bidder][seal] = Deed(0);
980         BidRevealed(seal, bidder, 0, 5);
981     }
982 
983     /**
984      * @dev Finalize an auction after the registration date has passed
985      *
986      * @param _hash The hash of the name the auction is for
987      */
988     function finalizeAuction(bytes32 _hash) public onlyOwner(_hash) {
989         Entry storage h = _entries[_hash];
990         
991         // Handles the case when there's only a single bidder (h.value is zero)
992         h.value =  max(h.value, minPrice);
993         h.deed.setBalance(h.value, true);
994 
995         trySetSubnodeOwner(_hash, h.deed.owner());
996         HashRegistered(_hash, h.deed.owner(), h.value, h.registrationDate);
997     }
998 
999     /**
1000      * @dev The owner of a domain may transfer it to someone else at any time.
1001      *
1002      * @param _hash The node to transfer
1003      * @param newOwner The address to transfer ownership to
1004      */
1005     function transfer(bytes32 _hash, address newOwner) public onlyOwner(_hash) {
1006         require(newOwner != 0);
1007 
1008         Entry storage h = _entries[_hash];
1009         h.deed.setOwner(newOwner);
1010         trySetSubnodeOwner(_hash, newOwner);
1011     }
1012 
1013     /**
1014      * @dev After some time, or if we're no longer the registrar, the owner can release
1015      *      the name and get their ether back.
1016      *
1017      * @param _hash The node to release
1018      */
1019     function releaseDeed(bytes32 _hash) public onlyOwner(_hash) {
1020         Entry storage h = _entries[_hash];
1021         Deed deedContract = h.deed;
1022 
1023         require(now >= h.registrationDate + 1 years || ens.owner(rootNode) != address(this));
1024 
1025         h.value = 0;
1026         h.highestBid = 0;
1027         h.deed = Deed(0);
1028 
1029         _tryEraseSingleNode(_hash);
1030         deedContract.closeDeed(1000);
1031         HashReleased(_hash, h.value);        
1032     }
1033 
1034     /**
1035      * @dev Submit a name 6 characters long or less. If it has been registered,
1036      *      the submitter will earn 50% of the deed value. 
1037      * 
1038      * We are purposefully handicapping the simplified registrar as a way 
1039      * to force it into being restructured in a few years.
1040      *
1041      * @param unhashedName An invalid name to search for in the registry.
1042      */
1043     function invalidateName(string unhashedName) public inState(keccak256(unhashedName), Mode.Owned) {
1044         require(strlen(unhashedName) <= 6);
1045         bytes32 hash = keccak256(unhashedName);
1046 
1047         Entry storage h = _entries[hash];
1048 
1049         _tryEraseSingleNode(hash);
1050 
1051         if (address(h.deed) != 0) {
1052             // Reward the discoverer with 50% of the deed
1053             // The previous owner gets 50%
1054             h.value = max(h.value, minPrice);
1055             h.deed.setBalance(h.value/2, false);
1056             h.deed.setOwner(msg.sender);
1057             h.deed.closeDeed(1000);
1058         }
1059 
1060         HashInvalidated(hash, unhashedName, h.value, h.registrationDate);
1061 
1062         h.value = 0;
1063         h.highestBid = 0;
1064         h.deed = Deed(0);
1065     }
1066 
1067     /**
1068      * @dev Allows anyone to delete the owner and resolver records for a (subdomain of) a
1069      *      name that is not currently owned in the registrar. If passing, eg, 'foo.bar.eth',
1070      *      the owner and resolver fields on 'foo.bar.eth' and 'bar.eth' will all be cleared.
1071      *
1072      * @param labels A series of label hashes identifying the name to zero out, rooted at the
1073      *        registrar's root. Must contain at least one element. For instance, to zero 
1074      *        'foo.bar.eth' on a registrar that owns '.eth', pass an array containing
1075      *        [keccak256('foo'), keccak256('bar')].
1076      */
1077     function eraseNode(bytes32[] labels) public {
1078         require(labels.length != 0);
1079         require(state(labels[labels.length - 1]) != Mode.Owned);
1080 
1081         _eraseNodeHierarchy(labels.length - 1, labels, rootNode);
1082     }
1083 
1084     /**
1085      * @dev Transfers the deed to the current registrar, if different from this one.
1086      *
1087      * Used during the upgrade process to a permanent registrar.
1088      *
1089      * @param _hash The name hash to transfer.
1090      */
1091     function transferRegistrars(bytes32 _hash) public onlyOwner(_hash) {
1092         address registrar = ens.owner(rootNode);
1093         require(registrar != address(this));
1094 
1095         // Migrate the deed
1096         Entry storage h = _entries[_hash];
1097         h.deed.setRegistrar(registrar);
1098 
1099         // Call the new registrar to accept the transfer
1100         Registrar(registrar).acceptRegistrarTransfer(_hash, h.deed, h.registrationDate);
1101 
1102         // Zero out the Entry
1103         h.deed = Deed(0);
1104         h.registrationDate = 0;
1105         h.value = 0;
1106         h.highestBid = 0;
1107     }
1108 
1109     /**
1110      * @dev Accepts a transfer from a previous registrar; stubbed out here since there
1111      *      is no previous registrar implementing this interface.
1112      *
1113      * @param hash The sha3 hash of the label to transfer.
1114      * @param deed The Deed object for the name being transferred in.
1115      * @param registrationDate The date at which the name was originally registered.
1116      */
1117     function acceptRegistrarTransfer(bytes32 hash, Deed deed, uint registrationDate) public {
1118         hash; deed; registrationDate; // Don't warn about unused variables
1119     }
1120 
1121     // State transitions for names:
1122     //   Open -> Auction (startAuction)
1123     //   Auction -> Reveal
1124     //   Reveal -> Owned
1125     //   Reveal -> Open (if nobody bid)
1126     //   Owned -> Open (releaseDeed or invalidateName)
1127     function state(bytes32 _hash) public view returns (Mode) {
1128         Entry storage entry = _entries[_hash];
1129 
1130         if (!isAllowed(_hash, now)) {
1131             return Mode.NotYetAvailable;
1132         } else if (now < entry.registrationDate) {
1133             if (now < entry.registrationDate - revealPeriod) {
1134                 return Mode.Auction;
1135             } else {
1136                 return Mode.Reveal;
1137             }
1138         } else {
1139             if (entry.highestBid == 0) {
1140                 return Mode.Open;
1141             } else {
1142                 return Mode.Owned;
1143             }
1144         }
1145     }
1146 
1147     function entries(bytes32 _hash) public view returns (Mode, address, uint, uint, uint) {
1148         Entry storage h = _entries[_hash];
1149         return (state(_hash), h.deed, h.registrationDate, h.value, h.highestBid);
1150     }
1151 
1152     /**
1153      * @dev Determines if a name is available for registration yet
1154      *
1155      * Each name will be assigned a random date in which its auction
1156      * can be started, from 0 to 8 weeks
1157      *
1158      * @param _hash The hash to start an auction on
1159      * @param _timestamp The timestamp to query about
1160      */
1161     function isAllowed(bytes32 _hash, uint _timestamp) public view returns (bool allowed) {
1162         return _timestamp > getAllowedTime(_hash);
1163     }
1164 
1165     /**
1166      * @dev Returns available date for hash
1167      *
1168      * The available time from the `registryStarted` for a hash is proportional
1169      * to its numeric value.
1170      *
1171      * @param _hash The hash to start an auction on
1172      */
1173     function getAllowedTime(bytes32 _hash) public view returns (uint) {
1174         return registryStarted + ((launchLength * (uint(_hash) >> 128)) >> 128);
1175         // Right shift operator: a >> b == a / 2**b
1176     }
1177 
1178     /**
1179      * @dev Hash the values required for a secret bid
1180      *
1181      * @param hash The node corresponding to the desired namehash
1182      * @param value The bid amount
1183      * @param salt A random value to ensure secrecy of the bid
1184      * @return The hash of the bid values
1185      */
1186     function shaBid(bytes32 hash, address owner, uint value, bytes32 salt) public pure returns (bytes32) {
1187         return keccak256(hash, owner, value, salt);
1188     }
1189 
1190     function _tryEraseSingleNode(bytes32 label) internal {
1191         if (ens.owner(rootNode) == address(this)) {
1192             ens.setSubnodeOwner(rootNode, label, address(this));
1193             bytes32 node = keccak256(rootNode, label);
1194             ens.setResolver(node, 0);
1195             ens.setOwner(node, 0);
1196         }
1197     }
1198 
1199     function _eraseNodeHierarchy(uint idx, bytes32[] labels, bytes32 node) internal {
1200         // Take ownership of the node
1201         ens.setSubnodeOwner(node, labels[idx], address(this));
1202         node = keccak256(node, labels[idx]);
1203 
1204         // Recurse if there are more labels
1205         if (idx > 0) {
1206             _eraseNodeHierarchy(idx - 1, labels, node);
1207         }
1208 
1209         // Erase the resolver and owner records
1210         ens.setResolver(node, 0);
1211         ens.setOwner(node, 0);
1212     }
1213 
1214     /**
1215      * @dev Assign the owner in ENS, if we're still the registrar
1216      *
1217      * @param _hash hash to change owner
1218      * @param _newOwner new owner to transfer to
1219      */
1220     function trySetSubnodeOwner(bytes32 _hash, address _newOwner) internal {
1221         if (ens.owner(rootNode) == address(this))
1222             ens.setSubnodeOwner(rootNode, _hash, _newOwner);
1223     }
1224 
1225     /**
1226      * @dev Returns the maximum of two unsigned integers
1227      *
1228      * @param a A number to compare
1229      * @param b A number to compare
1230      * @return The maximum of two unsigned integers
1231      */
1232     function max(uint a, uint b) internal pure returns (uint) {
1233         if (a > b)
1234             return a;
1235         else
1236             return b;
1237     }
1238 
1239     /**
1240      * @dev Returns the minimum of two unsigned integers
1241      *
1242      * @param a A number to compare
1243      * @param b A number to compare
1244      * @return The minimum of two unsigned integers
1245      */
1246     function min(uint a, uint b) internal pure returns (uint) {
1247         if (a < b)
1248             return a;
1249         else
1250             return b;
1251     }
1252 
1253     /**
1254      * @dev Returns the length of a given string
1255      *
1256      * @param s The string to measure the length of
1257      * @return The length of the input string
1258      */
1259     function strlen(string s) internal pure returns (uint) {
1260         s; // Don't warn about unused variables
1261         // Starting here means the LSB will be the byte we care about
1262         uint ptr;
1263         uint end;
1264         assembly {
1265             ptr := add(s, 1)
1266             end := add(mload(s), ptr)
1267         }
1268         for (uint len = 0; ptr < end; len++) {
1269             uint8 b;
1270             assembly { b := and(mload(ptr), 0xFF) }
1271             if (b < 0x80) {
1272                 ptr += 1;
1273             } else if (b < 0xE0) {
1274                 ptr += 2;
1275             } else if (b < 0xF0) {
1276                 ptr += 3;
1277             } else if (b < 0xF8) {
1278                 ptr += 4;
1279             } else if (b < 0xFC) {
1280                 ptr += 5;
1281             } else {
1282                 ptr += 6;
1283             }
1284         }
1285         return len;
1286     }
1287 
1288 }
1289 
1290 // File: contracts/ENSNFT.sol
1291 
1292 contract ENSNFT is ERC721Token {
1293     Registrar registrar;
1294     constructor (string _name, string _symbol, address _registrar) public
1295         ERC721Token(_name, _symbol) {
1296         registrar = Registrar(_registrar);
1297     }
1298     function mint(bytes32 _hash) public {
1299         address deedAddress;
1300         (, deedAddress, , , ) = registrar.entries(_hash);
1301         Deed deed = Deed(deedAddress);
1302         require(deed.owner() == address(this));
1303         require(deed.previousOwner() == msg.sender);
1304         uint256 tokenId = uint256(_hash); // dont do math on this
1305         _mint(deed.previousOwner(), tokenId);
1306     }
1307     function burn(uint256 tokenId) {
1308         require(ownerOf(tokenId) == msg.sender);
1309         _burn(msg.sender, tokenId);
1310         registrar.transfer(bytes32(tokenId), msg.sender);
1311     }
1312 }