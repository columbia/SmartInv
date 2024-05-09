1 // File: node_modules\zeppelin-solidity\contracts\ownership\Ownable.sol
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
19   function Ownable() public {
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
43 // File: node_modules\zeppelin-solidity\contracts\token\ERC721\ERC721Basic.sol
44 
45 /**
46  * @title ERC721 Non-Fungible Token Standard basic interface
47  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
48  */
49 contract ERC721Basic {
50   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
51   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
52   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
53 
54   function balanceOf(address _owner) public view returns (uint256 _balance);
55   function ownerOf(uint256 _tokenId) public view returns (address _owner);
56   function exists(uint256 _tokenId) public view returns (bool _exists);
57 
58   function approve(address _to, uint256 _tokenId) public;
59   function getApproved(uint256 _tokenId) public view returns (address _operator);
60 
61   function setApprovalForAll(address _operator, bool _approved) public;
62   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
63 
64   function transferFrom(address _from, address _to, uint256 _tokenId) public;
65   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
66   function safeTransferFrom(
67     address _from,
68     address _to,
69     uint256 _tokenId,
70     bytes _data
71   )
72     public;
73 }
74 
75 // File: node_modules\zeppelin-solidity\contracts\token\ERC721\ERC721.sol
76 
77 /**
78  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
79  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
80  */
81 contract ERC721Enumerable is ERC721Basic {
82   function totalSupply() public view returns (uint256);
83   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
84   function tokenByIndex(uint256 _index) public view returns (uint256);
85 }
86 
87 
88 /**
89  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
90  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
91  */
92 contract ERC721Metadata is ERC721Basic {
93   function name() public view returns (string _name);
94   function symbol() public view returns (string _symbol);
95   function tokenURI(uint256 _tokenId) public view returns (string);
96 }
97 
98 
99 /**
100  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
101  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
102  */
103 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
104 }
105 
106 // File: node_modules\zeppelin-solidity\contracts\AddressUtils.sol
107 
108 /**
109  * Utility library of inline functions on addresses
110  */
111 library AddressUtils {
112 
113   /**
114    * Returns whether the target address is a contract
115    * @dev This function will return false if invoked during the constructor of a contract,
116    *  as the code is not actually created until after the constructor finishes.
117    * @param addr address to check
118    * @return whether the target address is a contract
119    */
120   function isContract(address addr) internal view returns (bool) {
121     uint256 size;
122     // XXX Currently there is no better way to check if there is a contract in an address
123     // than to check the size of the code at that address.
124     // See https://ethereum.stackexchange.com/a/14016/36603
125     // for more details about how this works.
126     // TODO Check this again before the Serenity release, because all addresses will be
127     // contracts then.
128     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
129     return size > 0;
130   }
131 
132 }
133 
134 // File: node_modules\zeppelin-solidity\contracts\math\SafeMath.sol
135 
136 /**
137  * @title SafeMath
138  * @dev Math operations with safety checks that throw on error
139  */
140 library SafeMath {
141 
142   /**
143   * @dev Multiplies two numbers, throws on overflow.
144   */
145   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
146     if (a == 0) {
147       return 0;
148     }
149     c = a * b;
150     assert(c / a == b);
151     return c;
152   }
153 
154   /**
155   * @dev Integer division of two numbers, truncating the quotient.
156   */
157   function div(uint256 a, uint256 b) internal pure returns (uint256) {
158     // assert(b > 0); // Solidity automatically throws when dividing by 0
159     // uint256 c = a / b;
160     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
161     return a / b;
162   }
163 
164   /**
165   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
166   */
167   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
168     assert(b <= a);
169     return a - b;
170   }
171 
172   /**
173   * @dev Adds two numbers, throws on overflow.
174   */
175   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
176     c = a + b;
177     assert(c >= a);
178     return c;
179   }
180 }
181 
182 // File: node_modules\zeppelin-solidity\contracts\token\ERC721\ERC721Receiver.sol
183 
184 /**
185  * @title ERC721 token receiver interface
186  * @dev Interface for any contract that wants to support safeTransfers
187  *  from ERC721 asset contracts.
188  */
189 contract ERC721Receiver {
190   /**
191    * @dev Magic value to be returned upon successful reception of an NFT
192    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
193    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
194    */
195   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
196 
197   /**
198    * @notice Handle the receipt of an NFT
199    * @dev The ERC721 smart contract calls this function on the recipient
200    *  after a `safetransfer`. This function MAY throw to revert and reject the
201    *  transfer. This function MUST use 50,000 gas or less. Return of other
202    *  than the magic value MUST result in the transaction being reverted.
203    *  Note: the contract address is always the message sender.
204    * @param _from The sending address
205    * @param _tokenId The NFT identifier which is being transfered
206    * @param _data Additional data with no specified format
207    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
208    */
209   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
210 }
211 
212 // File: node_modules\zeppelin-solidity\contracts\token\ERC721\ERC721BasicToken.sol
213 
214 /**
215  * @title ERC721 Non-Fungible Token Standard basic implementation
216  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
217  */
218 contract ERC721BasicToken is ERC721Basic {
219   using SafeMath for uint256;
220   using AddressUtils for address;
221 
222   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
223   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
224   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
225 
226   // Mapping from token ID to owner
227   mapping (uint256 => address) internal tokenOwner;
228 
229   // Mapping from token ID to approved address
230   mapping (uint256 => address) internal tokenApprovals;
231 
232   // Mapping from owner to number of owned token
233   mapping (address => uint256) internal ownedTokensCount;
234 
235   // Mapping from owner to operator approvals
236   mapping (address => mapping (address => bool)) internal operatorApprovals;
237 
238   /**
239    * @dev Guarantees msg.sender is owner of the given token
240    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
241    */
242   modifier onlyOwnerOf(uint256 _tokenId) {
243     require(ownerOf(_tokenId) == msg.sender);
244     _;
245   }
246 
247   /**
248    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
249    * @param _tokenId uint256 ID of the token to validate
250    */
251   modifier canTransfer(uint256 _tokenId) {
252     require(isApprovedOrOwner(msg.sender, _tokenId));
253     _;
254   }
255 
256   /**
257    * @dev Gets the balance of the specified address
258    * @param _owner address to query the balance of
259    * @return uint256 representing the amount owned by the passed address
260    */
261   function balanceOf(address _owner) public view returns (uint256) {
262     require(_owner != address(0));
263     return ownedTokensCount[_owner];
264   }
265 
266   /**
267    * @dev Gets the owner of the specified token ID
268    * @param _tokenId uint256 ID of the token to query the owner of
269    * @return owner address currently marked as the owner of the given token ID
270    */
271   function ownerOf(uint256 _tokenId) public view returns (address) {
272     address owner = tokenOwner[_tokenId];
273     require(owner != address(0));
274     return owner;
275   }
276 
277   /**
278    * @dev Returns whether the specified token exists
279    * @param _tokenId uint256 ID of the token to query the existance of
280    * @return whether the token exists
281    */
282   function exists(uint256 _tokenId) public view returns (bool) {
283     address owner = tokenOwner[_tokenId];
284     return owner != address(0);
285   }
286 
287   /**
288    * @dev Approves another address to transfer the given token ID
289    * @dev The zero address indicates there is no approved address.
290    * @dev There can only be one approved address per token at a given time.
291    * @dev Can only be called by the token owner or an approved operator.
292    * @param _to address to be approved for the given token ID
293    * @param _tokenId uint256 ID of the token to be approved
294    */
295   function approve(address _to, uint256 _tokenId) public {
296     address owner = ownerOf(_tokenId);
297     require(_to != owner);
298     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
299 
300     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
301       tokenApprovals[_tokenId] = _to;
302       emit Approval(owner, _to, _tokenId);
303     }
304   }
305 
306   /**
307    * @dev Gets the approved address for a token ID, or zero if no address set
308    * @param _tokenId uint256 ID of the token to query the approval of
309    * @return address currently approved for a the given token ID
310    */
311   function getApproved(uint256 _tokenId) public view returns (address) {
312     return tokenApprovals[_tokenId];
313   }
314 
315   /**
316    * @dev Sets or unsets the approval of a given operator
317    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
318    * @param _to operator address to set the approval
319    * @param _approved representing the status of the approval to be set
320    */
321   function setApprovalForAll(address _to, bool _approved) public {
322     require(_to != msg.sender);
323     operatorApprovals[msg.sender][_to] = _approved;
324     emit ApprovalForAll(msg.sender, _to, _approved);
325   }
326 
327   /**
328    * @dev Tells whether an operator is approved by a given owner
329    * @param _owner owner address which you want to query the approval of
330    * @param _operator operator address which you want to query the approval of
331    * @return bool whether the given operator is approved by the given owner
332    */
333   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
334     return operatorApprovals[_owner][_operator];
335   }
336 
337   /**
338    * @dev Transfers the ownership of a given token ID to another address
339    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
340    * @dev Requires the msg sender to be the owner, approved, or operator
341    * @param _from current owner of the token
342    * @param _to address to receive the ownership of the given token ID
343    * @param _tokenId uint256 ID of the token to be transferred
344   */
345   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
346     require(_from != address(0));
347     require(_to != address(0));
348 
349     clearApproval(_from, _tokenId);
350     removeTokenFrom(_from, _tokenId);
351     addTokenTo(_to, _tokenId);
352 
353     emit Transfer(_from, _to, _tokenId);
354   }
355 
356   /**
357    * @dev Safely transfers the ownership of a given token ID to another address
358    * @dev If the target address is a contract, it must implement `onERC721Received`,
359    *  which is called upon a safe transfer, and return the magic value
360    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
361    *  the transfer is reverted.
362    * @dev Requires the msg sender to be the owner, approved, or operator
363    * @param _from current owner of the token
364    * @param _to address to receive the ownership of the given token ID
365    * @param _tokenId uint256 ID of the token to be transferred
366   */
367   function safeTransferFrom(
368     address _from,
369     address _to,
370     uint256 _tokenId
371   )
372     public
373     canTransfer(_tokenId)
374   {
375     // solium-disable-next-line arg-overflow
376     safeTransferFrom(_from, _to, _tokenId, "");
377   }
378 
379   /**
380    * @dev Safely transfers the ownership of a given token ID to another address
381    * @dev If the target address is a contract, it must implement `onERC721Received`,
382    *  which is called upon a safe transfer, and return the magic value
383    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
384    *  the transfer is reverted.
385    * @dev Requires the msg sender to be the owner, approved, or operator
386    * @param _from current owner of the token
387    * @param _to address to receive the ownership of the given token ID
388    * @param _tokenId uint256 ID of the token to be transferred
389    * @param _data bytes data to send along with a safe transfer check
390    */
391   function safeTransferFrom(
392     address _from,
393     address _to,
394     uint256 _tokenId,
395     bytes _data
396   )
397     public
398     canTransfer(_tokenId)
399   {
400     transferFrom(_from, _to, _tokenId);
401     // solium-disable-next-line arg-overflow
402     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
403   }
404 
405   /**
406    * @dev Returns whether the given spender can transfer a given token ID
407    * @param _spender address of the spender to query
408    * @param _tokenId uint256 ID of the token to be transferred
409    * @return bool whether the msg.sender is approved for the given token ID,
410    *  is an operator of the owner, or is the owner of the token
411    */
412   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
413     address owner = ownerOf(_tokenId);
414     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
415   }
416 
417   /**
418    * @dev Internal function to mint a new token
419    * @dev Reverts if the given token ID already exists
420    * @param _to The address that will own the minted token
421    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
422    */
423   function _mint(address _to, uint256 _tokenId) internal {
424     require(_to != address(0));
425     addTokenTo(_to, _tokenId);
426     emit Transfer(address(0), _to, _tokenId);
427   }
428 
429   /**
430    * @dev Internal function to burn a specific token
431    * @dev Reverts if the token does not exist
432    * @param _tokenId uint256 ID of the token being burned by the msg.sender
433    */
434   function _burn(address _owner, uint256 _tokenId) internal {
435     clearApproval(_owner, _tokenId);
436     removeTokenFrom(_owner, _tokenId);
437     emit Transfer(_owner, address(0), _tokenId);
438   }
439 
440   /**
441    * @dev Internal function to clear current approval of a given token ID
442    * @dev Reverts if the given address is not indeed the owner of the token
443    * @param _owner owner of the token
444    * @param _tokenId uint256 ID of the token to be transferred
445    */
446   function clearApproval(address _owner, uint256 _tokenId) internal {
447     require(ownerOf(_tokenId) == _owner);
448     if (tokenApprovals[_tokenId] != address(0)) {
449       tokenApprovals[_tokenId] = address(0);
450       emit Approval(_owner, address(0), _tokenId);
451     }
452   }
453 
454   /**
455    * @dev Internal function to add a token ID to the list of a given address
456    * @param _to address representing the new owner of the given token ID
457    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
458    */
459   function addTokenTo(address _to, uint256 _tokenId) internal {
460     require(tokenOwner[_tokenId] == address(0));
461     tokenOwner[_tokenId] = _to;
462     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
463   }
464 
465   /**
466    * @dev Internal function to remove a token ID from the list of a given address
467    * @param _from address representing the previous owner of the given token ID
468    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
469    */
470   function removeTokenFrom(address _from, uint256 _tokenId) internal {
471     require(ownerOf(_tokenId) == _from);
472     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
473     tokenOwner[_tokenId] = address(0);
474   }
475 
476   /**
477    * @dev Internal function to invoke `onERC721Received` on a target address
478    * @dev The call is not executed if the target address is not a contract
479    * @param _from address representing the previous owner of the given token ID
480    * @param _to target address that will receive the tokens
481    * @param _tokenId uint256 ID of the token to be transferred
482    * @param _data bytes optional data to send along with the call
483    * @return whether the call correctly returned the expected magic value
484    */
485   function checkAndCallSafeTransfer(
486     address _from,
487     address _to,
488     uint256 _tokenId,
489     bytes _data
490   )
491     internal
492     returns (bool)
493   {
494     if (!_to.isContract()) {
495       return true;
496     }
497     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
498     return (retval == ERC721_RECEIVED);
499   }
500 }
501 
502 // File: node_modules\zeppelin-solidity\contracts\token\ERC721\ERC721Token.sol
503 
504 /**
505  * @title Full ERC721 Token
506  * This implementation includes all the required and some optional functionality of the ERC721 standard
507  * Moreover, it includes approve all functionality using operator terminology
508  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
509  */
510 contract ERC721Token is ERC721, ERC721BasicToken {
511   // Token name
512   string internal name_;
513 
514   // Token symbol
515   string internal symbol_;
516 
517   // Mapping from owner to list of owned token IDs
518   mapping (address => uint256[]) internal ownedTokens;
519 
520   // Mapping from token ID to index of the owner tokens list
521   mapping(uint256 => uint256) internal ownedTokensIndex;
522 
523   // Array with all token ids, used for enumeration
524   uint256[] internal allTokens;
525 
526   // Mapping from token id to position in the allTokens array
527   mapping(uint256 => uint256) internal allTokensIndex;
528 
529   // Optional mapping for token URIs
530   mapping(uint256 => string) internal tokenURIs;
531 
532   /**
533    * @dev Constructor function
534    */
535   function ERC721Token(string _name, string _symbol) public {
536     name_ = _name;
537     symbol_ = _symbol;
538   }
539 
540   /**
541    * @dev Gets the token name
542    * @return string representing the token name
543    */
544   function name() public view returns (string) {
545     return name_;
546   }
547 
548   /**
549    * @dev Gets the token symbol
550    * @return string representing the token symbol
551    */
552   function symbol() public view returns (string) {
553     return symbol_;
554   }
555 
556   /**
557    * @dev Returns an URI for a given token ID
558    * @dev Throws if the token ID does not exist. May return an empty string.
559    * @param _tokenId uint256 ID of the token to query
560    */
561   function tokenURI(uint256 _tokenId) public view returns (string) {
562     require(exists(_tokenId));
563     return tokenURIs[_tokenId];
564   }
565 
566   /**
567    * @dev Gets the token ID at a given index of the tokens list of the requested owner
568    * @param _owner address owning the tokens list to be accessed
569    * @param _index uint256 representing the index to be accessed of the requested tokens list
570    * @return uint256 token ID at the given index of the tokens list owned by the requested address
571    */
572   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
573     require(_index < balanceOf(_owner));
574     return ownedTokens[_owner][_index];
575   }
576 
577   /**
578    * @dev Gets the total amount of tokens stored by the contract
579    * @return uint256 representing the total amount of tokens
580    */
581   function totalSupply() public view returns (uint256) {
582     return allTokens.length;
583   }
584 
585   /**
586    * @dev Gets the token ID at a given index of all the tokens in this contract
587    * @dev Reverts if the index is greater or equal to the total number of tokens
588    * @param _index uint256 representing the index to be accessed of the tokens list
589    * @return uint256 token ID at the given index of the tokens list
590    */
591   function tokenByIndex(uint256 _index) public view returns (uint256) {
592     require(_index < totalSupply());
593     return allTokens[_index];
594   }
595 
596   /**
597    * @dev Internal function to set the token URI for a given token
598    * @dev Reverts if the token ID does not exist
599    * @param _tokenId uint256 ID of the token to set its URI
600    * @param _uri string URI to assign
601    */
602   function _setTokenURI(uint256 _tokenId, string _uri) internal {
603     require(exists(_tokenId));
604     tokenURIs[_tokenId] = _uri;
605   }
606 
607   /**
608    * @dev Internal function to add a token ID to the list of a given address
609    * @param _to address representing the new owner of the given token ID
610    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
611    */
612   function addTokenTo(address _to, uint256 _tokenId) internal {
613     super.addTokenTo(_to, _tokenId);
614     uint256 length = ownedTokens[_to].length;
615     ownedTokens[_to].push(_tokenId);
616     ownedTokensIndex[_tokenId] = length;
617   }
618 
619   /**
620    * @dev Internal function to remove a token ID from the list of a given address
621    * @param _from address representing the previous owner of the given token ID
622    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
623    */
624   function removeTokenFrom(address _from, uint256 _tokenId) internal {
625     super.removeTokenFrom(_from, _tokenId);
626 
627     uint256 tokenIndex = ownedTokensIndex[_tokenId];
628     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
629     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
630 
631     ownedTokens[_from][tokenIndex] = lastToken;
632     ownedTokens[_from][lastTokenIndex] = 0;
633     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
634     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
635     // the lastToken to the first position, and then dropping the element placed in the last position of the list
636 
637     ownedTokens[_from].length--;
638     ownedTokensIndex[_tokenId] = 0;
639     ownedTokensIndex[lastToken] = tokenIndex;
640   }
641 
642   /**
643    * @dev Internal function to mint a new token
644    * @dev Reverts if the given token ID already exists
645    * @param _to address the beneficiary that will own the minted token
646    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
647    */
648   function _mint(address _to, uint256 _tokenId) internal {
649     super._mint(_to, _tokenId);
650 
651     allTokensIndex[_tokenId] = allTokens.length;
652     allTokens.push(_tokenId);
653   }
654 
655   /**
656    * @dev Internal function to burn a specific token
657    * @dev Reverts if the token does not exist
658    * @param _owner owner of the token to burn
659    * @param _tokenId uint256 ID of the token being burned by the msg.sender
660    */
661   function _burn(address _owner, uint256 _tokenId) internal {
662     super._burn(_owner, _tokenId);
663 
664     // Clear metadata (if any)
665     if (bytes(tokenURIs[_tokenId]).length != 0) {
666       delete tokenURIs[_tokenId];
667     }
668 
669     // Reorg all tokens array
670     uint256 tokenIndex = allTokensIndex[_tokenId];
671     uint256 lastTokenIndex = allTokens.length.sub(1);
672     uint256 lastToken = allTokens[lastTokenIndex];
673 
674     allTokens[tokenIndex] = lastToken;
675     allTokens[lastTokenIndex] = 0;
676 
677     allTokens.length--;
678     allTokensIndex[_tokenId] = 0;
679     allTokensIndex[lastToken] = tokenIndex;
680   }
681 
682 }
683 
684 // File: contracts\Integers.sol
685 
686 /**
687  * Integers Library
688  *
689  * In summary this is a simple library of integer functions which allow a simple
690  * conversion to and from strings
691  *
692  * @author James Lockhart <james@n3tw0rk.co.uk>
693  */
694 library Integers {
695     /**
696      * Parse Int
697      *
698      * Converts an ASCII string value into an uint as long as the string
699      * its self is a valid unsigned integer
700      *
701      * @param _value The ASCII string to be converted to an unsigned integer
702      * @return uint The unsigned value of the ASCII string
703      */
704     function parseInt(string _value)
705         public
706         returns (uint _ret) {
707         bytes memory _bytesValue = bytes(_value);
708         uint j = 1;
709         for(uint i = _bytesValue.length-1; i >= 0 && i < _bytesValue.length; i--) {
710             assert(_bytesValue[i] >= 48 && _bytesValue[i] <= 57);
711             _ret += (uint(_bytesValue[i]) - 48)*j;
712             j*=10;
713         }
714     }
715 
716     /**
717      * To String
718      *
719      * Converts an unsigned integer to the ASCII string equivalent value
720      *
721      * @param _base The unsigned integer to be converted to a string
722      * @return string The resulting ASCII string value
723      */
724     function toString(uint _base)
725         internal
726         returns (string) {
727         bytes memory _tmp = new bytes(32);
728         uint i;
729         for(i = 0;_base > 0;i++) {
730             _tmp[i] = byte((_base % 10) + 48);
731             _base /= 10;
732         }
733         bytes memory _real = new bytes(i--);
734         for(uint j = 0; j < _real.length; j++) {
735             _real[j] = _tmp[i--];
736         }
737         return string(_real);
738     }
739 
740     /**
741      * To Byte
742      *
743      * Convert an 8 bit unsigned integer to a byte
744      *
745      * @param _base The 8 bit unsigned integer
746      * @return byte The byte equivalent
747      */
748     function toByte(uint8 _base)
749         public
750         returns (byte _ret) {
751         assembly {
752             let m_alloc := add(msize(),0x1)
753             mstore8(m_alloc, _base)
754             _ret := mload(m_alloc)
755         }
756     }
757 
758     /**
759      * To Bytes
760      *
761      * Converts an unsigned integer to bytes
762      *
763      * @param _base The integer to be converted to bytes
764      * @return bytes The bytes equivalent
765      */
766     function toBytes(uint _base)
767         internal
768         returns (bytes _ret) {
769         assembly {
770             let m_alloc := add(msize(),0x1)
771             _ret := mload(m_alloc)
772             mstore(_ret, 0x20)
773             mstore(add(_ret, 0x20), _base)
774         }
775     }
776 }
777 
778 // File: contracts\Strings.sol
779 
780 /**
781  * Strings Library
782  *
783  * In summary this is a simple library of string functions which make simple
784  * string operations less tedious in solidity.
785  *
786  * Please be aware these functions can be quite gas heavy so use them only when
787  * necessary not to clog the blockchain with expensive transactions.
788  *
789  * @author James Lockhart <james@n3tw0rk.co.uk>
790  */
791 library Strings {
792 
793     /**
794      * Concat (High gas cost)
795      *
796      * Appends two strings together and returns a new value
797      *
798      * @param _base When being used for a data type this is the extended object
799      *              otherwise this is the string which will be the concatenated
800      *              prefix
801      * @param _value The value to be the concatenated suffix
802      * @return string The resulting string from combinging the base and value
803      */
804     function concat(string _base, string _value)
805         internal
806         returns (string) {
807         bytes memory _baseBytes = bytes(_base);
808         bytes memory _valueBytes = bytes(_value);
809 
810         assert(_valueBytes.length > 0);
811 
812         string memory _tmpValue = new string(_baseBytes.length +
813             _valueBytes.length);
814         bytes memory _newValue = bytes(_tmpValue);
815 
816         uint i;
817         uint j;
818 
819         for(i = 0; i < _baseBytes.length; i++) {
820             _newValue[j++] = _baseBytes[i];
821         }
822 
823         for(i = 0; i<_valueBytes.length; i++) {
824             _newValue[j++] = _valueBytes[i];
825         }
826 
827         return string(_newValue);
828     }
829 
830     /**
831      * Index Of
832      *
833      * Locates and returns the position of a character within a string
834      *
835      * @param _base When being used for a data type this is the extended object
836      *              otherwise this is the string acting as the haystack to be
837      *              searched
838      * @param _value The needle to search for, at present this is currently
839      *               limited to one character
840      * @return int The position of the needle starting from 0 and returning -1
841      *             in the case of no matches found
842      */
843     function indexOf(string _base, string _value)
844         internal
845         returns (int) {
846         return _indexOf(_base, _value, 0);
847     }
848 
849     /**
850      * Index Of
851      *
852      * Locates and returns the position of a character within a string starting
853      * from a defined offset
854      *
855      * @param _base When being used for a data type this is the extended object
856      *              otherwise this is the string acting as the haystack to be
857      *              searched
858      * @param _value The needle to search for, at present this is currently
859      *               limited to one character
860      * @param _offset The starting point to start searching from which can start
861      *                from 0, but must not exceed the length of the string
862      * @return int The position of the needle starting from 0 and returning -1
863      *             in the case of no matches found
864      */
865     function _indexOf(string _base, string _value, uint _offset)
866         internal
867         returns (int) {
868         bytes memory _baseBytes = bytes(_base);
869         bytes memory _valueBytes = bytes(_value);
870 
871         assert(_valueBytes.length == 1);
872 
873         for(uint i = _offset; i < _baseBytes.length; i++) {
874             if (_baseBytes[i] == _valueBytes[0]) {
875                 return int(i);
876             }
877         }
878 
879         return -1;
880     }
881 
882     /**
883      * Length
884      *
885      * Returns the length of the specified string
886      *
887      * @param _base When being used for a data type this is the extended object
888      *              otherwise this is the string to be measured
889      * @return uint The length of the passed string
890      */
891     function length(string _base)
892         internal
893         returns (uint) {
894         bytes memory _baseBytes = bytes(_base);
895         return _baseBytes.length;
896     }
897 
898     /**
899      * Sub String
900      *
901      * Extracts the beginning part of a string based on the desired length
902      *
903      * @param _base When being used for a data type this is the extended object
904      *              otherwise this is the string that will be used for
905      *              extracting the sub string from
906      * @param _length The length of the sub string to be extracted from the base
907      * @return string The extracted sub string
908      */
909     function substring(string _base, int _length)
910         internal
911         returns (string) {
912         return _substring(_base, _length, 0);
913     }
914 
915     /**
916      * Sub String
917      *
918      * Extracts the part of a string based on the desired length and offset. The
919      * offset and length must not exceed the lenth of the base string.
920      *
921      * @param _base When being used for a data type this is the extended object
922      *              otherwise this is the string that will be used for
923      *              extracting the sub string from
924      * @param _length The length of the sub string to be extracted from the base
925      * @param _offset The starting point to extract the sub string from
926      * @return string The extracted sub string
927      */
928     function _substring(string _base, int _length, int _offset)
929         internal
930         returns (string) {
931         bytes memory _baseBytes = bytes(_base);
932 
933         assert(uint(_offset+_length) <= _baseBytes.length);
934 
935         string memory _tmp = new string(uint(_length));
936         bytes memory _tmpBytes = bytes(_tmp);
937 
938         uint j = 0;
939         for(uint i = uint(_offset); i < uint(_offset+_length); i++) {
940           _tmpBytes[j++] = _baseBytes[i];
941         }
942 
943         return string(_tmpBytes);
944     }
945 
946     /**
947      * String Split (Very high gas cost)
948      *
949      * Splits a string into an array of strings based off the delimiter value.
950      * Please note this can be quite a gas expensive function due to the use of
951      * storage so only use if really required.
952      *
953      * @param _base When being used for a data type this is the extended object
954      *               otherwise this is the string value to be split.
955      * @param _value The delimiter to split the string on which must be a single
956      *               character
957      * @return string[] An array of values split based off the delimiter, but
958      *                  do not container the delimiter.
959      */
960     function split(string _base, string _value)
961         internal
962         returns (string[] storage splitArr) {
963         bytes memory _baseBytes = bytes(_base);
964         uint _offset = 0;
965 
966         while(_offset < _baseBytes.length-1) {
967 
968             int _limit = _indexOf(_base, _value, _offset);
969             if (_limit == -1) {
970                 _limit = int(_baseBytes.length);
971             }
972 
973             string memory _tmp = new string(uint(_limit)-_offset);
974             bytes memory _tmpBytes = bytes(_tmp);
975 
976             uint j = 0;
977             for(uint i = _offset; i < uint(_limit); i++) {
978                 _tmpBytes[j++] = _baseBytes[i];
979             }
980             _offset = uint(_limit) + 1;
981             splitArr.push(string(_tmpBytes));
982         }
983         return splitArr;
984     }
985 
986     /**
987      * Compare To
988      *
989      * Compares the characters of two strings, to ensure that they have an
990      * identical footprint
991      *
992      * @param _base When being used for a data type this is the extended object
993      *               otherwise this is the string base to compare against
994      * @param _value The string the base is being compared to
995      * @return bool Simply notates if the two string have an equivalent
996      */
997     function compareTo(string _base, string _value)
998         internal
999         returns (bool) {
1000         bytes memory _baseBytes = bytes(_base);
1001         bytes memory _valueBytes = bytes(_value);
1002 
1003         if (_baseBytes.length != _valueBytes.length) {
1004             return false;
1005         }
1006 
1007         for(uint i = 0; i < _baseBytes.length; i++) {
1008             if (_baseBytes[i] != _valueBytes[i]) {
1009                 return false;
1010             }
1011         }
1012 
1013         return true;
1014     }
1015 
1016     /**
1017      * Compare To Ignore Case (High gas cost)
1018      *
1019      * Compares the characters of two strings, converting them to the same case
1020      * where applicable to alphabetic characters to distinguish if the values
1021      * match.
1022      *
1023      * @param _base When being used for a data type this is the extended object
1024      *               otherwise this is the string base to compare against
1025      * @param _value The string the base is being compared to
1026      * @return bool Simply notates if the two string have an equivalent value
1027      *              discarding case
1028      */
1029     function compareToIgnoreCase(string _base, string _value)
1030         internal
1031         returns (bool) {
1032         bytes memory _baseBytes = bytes(_base);
1033         bytes memory _valueBytes = bytes(_value);
1034 
1035         if (_baseBytes.length != _valueBytes.length) {
1036             return false;
1037         }
1038 
1039         for(uint i = 0; i < _baseBytes.length; i++) {
1040             if (_baseBytes[i] != _valueBytes[i] &&
1041                 _upper(_baseBytes[i]) != _upper(_valueBytes[i])) {
1042                 return false;
1043             }
1044         }
1045 
1046         return true;
1047     }
1048 
1049     /**
1050      * Upper
1051      *
1052      * Converts all the values of a string to their corresponding upper case
1053      * value.
1054      *
1055      * @param _base When being used for a data type this is the extended object
1056      *              otherwise this is the string base to convert to upper case
1057      * @return string
1058      */
1059     function upper(string _base)
1060         internal
1061         returns (string) {
1062         bytes memory _baseBytes = bytes(_base);
1063         for (uint i = 0; i < _baseBytes.length; i++) {
1064             _baseBytes[i] = _upper(_baseBytes[i]);
1065         }
1066         return string(_baseBytes);
1067     }
1068 
1069     /**
1070      * Lower
1071      *
1072      * Converts all the values of a string to their corresponding lower case
1073      * value.
1074      *
1075      * @param _base When being used for a data type this is the extended object
1076      *              otherwise this is the string base to convert to lower case
1077      * @return string
1078      */
1079     function lower(string _base)
1080         internal
1081         returns (string) {
1082         bytes memory _baseBytes = bytes(_base);
1083         for (uint i = 0; i < _baseBytes.length; i++) {
1084             _baseBytes[i] = _lower(_baseBytes[i]);
1085         }
1086         return string(_baseBytes);
1087     }
1088 
1089     /**
1090      * Upper
1091      *
1092      * Convert an alphabetic character to upper case and return the original
1093      * value when not alphabetic
1094      *
1095      * @param _b1 The byte to be converted to upper case
1096      * @return bytes1 The converted value if the passed value was alphabetic
1097      *                and in a lower case otherwise returns the original value
1098      */
1099     function _upper(bytes1 _b1)
1100         private
1101         constant
1102         returns (bytes1) {
1103 
1104         if (_b1 >= 0x61 && _b1 <= 0x7A) {
1105             return bytes1(uint8(_b1)-32);
1106         }
1107 
1108         return _b1;
1109     }
1110 
1111     /**
1112      * Lower
1113      *
1114      * Convert an alphabetic character to lower case and return the original
1115      * value when not alphabetic
1116      *
1117      * @param _b1 The byte to be converted to lower case
1118      * @return bytes1 The converted value if the passed value was alphabetic
1119      *                and in a upper case otherwise returns the original value
1120      */
1121     function _lower(bytes1 _b1)
1122         private
1123         constant
1124         returns (bytes1) {
1125 
1126         if (_b1 >= 0x41 && _b1 <= 0x5A) {
1127             return bytes1(uint8(_b1)+32);
1128         }
1129 
1130         return _b1;
1131     }
1132 }
1133 
1134 // File: contracts\EtherBrosMaker.sol
1135 
1136 contract EtherBrosMaker is Ownable, ERC721Token {
1137     using Strings for string;
1138     using Integers for uint;
1139 
1140     event AuctionCreated(uint256 tokenId, uint256 price);
1141     event AuctionSuccessful(uint256 tokenId, uint256 price, address buyer);
1142     event AuctionCancelled(uint256 tokenId);
1143 
1144     struct Auction {
1145         address seller;
1146         uint128 price;
1147     }
1148 
1149     mapping (uint256 => Auction) public tokenIdToAuction;
1150     mapping (uint256 => string) public tokenImage;
1151 
1152     uint128 public mintingFee = 0.001 ether;
1153     uint8 prefix = 1;
1154     string preURI = "https://enigmatic-castle-32612.herokuapp.com/api/meta?tokenId=";
1155     string image = "http://app.givinglog.com/game/ether-bros-maker/img/Etherbro";
1156     uint private nonce = 0;
1157     uint16[] public etherBros;
1158     uint128 ownerCut = 100;
1159 
1160     function EtherBrosMaker () ERC721Token("EtherBrosMaker" ,"EBM") public {
1161 
1162     }
1163 
1164     /*** Owner Action ***/
1165     function withdraw() public onlyOwner {
1166         owner.transfer(this.balance);
1167     }
1168 
1169     function setPrefix(uint8 _prefix) external onlyOwner {
1170         require(prefix > 0);
1171         prefix = _prefix;
1172     }
1173 
1174     function setPreURI(string _preURI) external onlyOwner {
1175         preURI = _preURI;
1176     }
1177 
1178     function _createEtherBro(uint16 _genes,address _owner) internal returns (uint32){
1179         uint32 newEtherBroId = uint32(etherBros.push(_genes) - 1);
1180         _mint(_owner, newEtherBroId);
1181         string memory _uri = preURI.concat(uint(_genes).toString());
1182         tokenImage[newEtherBroId] = image.concat(uint(_genes).toString()).concat(".png");
1183         _setTokenURI(newEtherBroId, _uri);
1184         return newEtherBroId;
1185     }
1186 
1187     function _gensGenerate() internal returns(uint16){
1188         uint16 result = prefix * 10000;
1189         uint8 _randam1 = rand();
1190         uint8 _randam2 = rand();
1191         uint8 _randam3 = rand();
1192         uint8 _randam4 = rand();
1193 
1194         if (_randam1 > 0 && _randam1 <4){
1195             result = result + 1000;
1196         } else if (_randam1 > 3 && _randam1 <7){
1197             result = result + 2000;
1198         } else if (_randam1 > 6){
1199             result = result + 3000;
1200         }
1201 
1202         if (_randam2 > 0 && _randam2 <4){
1203             result = result + 100;
1204         } else if (_randam2 > 3 && _randam2 <7){
1205             result = result + 200;
1206         } else if (_randam2 > 6){
1207             result = result + 300;
1208         }
1209 
1210         if (_randam3 > 0 && _randam3 <4){
1211             result = result + 10;
1212         } else if (_randam3 > 3 && _randam3 <7){
1213             result = result + 20;
1214         } else if (_randam3 > 6){
1215             result = result + 30;
1216         }
1217 
1218         if (_randam4 > 0 && _randam4 <4){
1219             result = result + 1;
1220         } else if (_randam4 > 3 && _randam4 <7){
1221             result = result + 2;
1222         } else if (_randam4 > 6){
1223             result = result + 3;
1224         }
1225 
1226         return result;
1227     }
1228 
1229 
1230     function mintEtherBro () public {
1231         _createEtherBro(_gensGenerate(),msg.sender);
1232     }
1233 
1234     function mintPromoEtherBro (uint16 _gens) public onlyOwner {
1235         uint16 _promoGens = prefix * 10000 + _gens;
1236         _createEtherBro(_promoGens, msg.sender);
1237     }
1238 
1239     function rand() internal returns (uint8){
1240         nonce++;
1241         return uint8(uint256(keccak256(nonce))%10);
1242     }
1243 
1244     function myEtherBros(address _owner) public view returns (uint256[]) {
1245         return ownedTokens[_owner];
1246     }
1247 
1248     function myEtherBrosCount(address _owner) public view returns (uint256) {
1249         return ownedTokensCount[_owner];
1250     }
1251 
1252     function returnIdImage(uint32 _id) public view returns (uint32, string){
1253         return (_id, tokenImage[_id]);
1254     }
1255 
1256 
1257 //  function addEtherBroAuction(uint256 _tokenId, uint128 _price) public returns (bool) {
1258     function addEtherBroAuction(uint256 _tokenId, uint128 _price) public {
1259         require(ownerOf(_tokenId) == msg.sender);
1260         require(tokenIdToAuction[_tokenId].seller == address(0));
1261         require(_price >= 0);
1262 
1263         Auction memory _auction = Auction(msg.sender, _price);
1264         tokenIdToAuction[_tokenId] = _auction;
1265 
1266         approve(address(this), _tokenId);
1267         transferFrom(msg.sender, address(this), _tokenId);
1268 
1269         AuctionCreated(uint256(_tokenId), uint256(_auction.price));
1270 
1271     }
1272 
1273     function cancelEtherBroAuction(uint256 _tokenId) public {
1274         require(tokenIdToAuction[_tokenId].seller == msg.sender);
1275         this.transferFrom(address(this), tokenIdToAuction[_tokenId].seller, _tokenId);
1276         delete tokenIdToAuction[_tokenId];
1277         AuctionCancelled(_tokenId);
1278     }
1279 
1280     function purchase(uint256 _tokenId) public payable {
1281         require(tokenIdToAuction[_tokenId].seller != address(0));
1282         require(tokenIdToAuction[_tokenId].seller != msg.sender);
1283         require(tokenIdToAuction[_tokenId].price == msg.value);
1284 
1285         Auction memory auction = tokenIdToAuction[_tokenId];
1286 
1287         if (auction.price > 0) {
1288             uint128 actualOwnerCut = _computeOwnerCut(auction.price);
1289             uint128 proceeds = auction.price - actualOwnerCut;
1290             auction.seller.transfer(proceeds);
1291         }
1292         delete tokenIdToAuction[_tokenId];
1293         this.transferFrom(address(this), msg.sender, _tokenId);
1294         AuctionSuccessful(_tokenId, auction.price, msg.sender);
1295     }
1296 
1297     /*** Tools ***/
1298     function _computeOwnerCut(uint128 _price) internal view returns (uint128) {
1299         return _price * ownerCut / 10000;
1300     }
1301 
1302 }