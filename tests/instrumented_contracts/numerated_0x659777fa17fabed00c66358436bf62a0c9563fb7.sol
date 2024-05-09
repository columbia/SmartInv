1 pragma solidity ^0.4.24;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
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
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
46 
47 /**
48  * @title ERC721 Non-Fungible Token Standard basic interface
49  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
50  */
51 contract ERC721Basic {
52   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
53   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
54   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
55 
56   function balanceOf(address _owner) public view returns (uint256 _balance);
57   function ownerOf(uint256 _tokenId) public view returns (address _owner);
58   function exists(uint256 _tokenId) public view returns (bool _exists);
59 
60   function approve(address _to, uint256 _tokenId) public;
61   function getApproved(uint256 _tokenId) public view returns (address _operator);
62 
63   function setApprovalForAll(address _operator, bool _approved) public;
64   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
65 
66   function transferFrom(address _from, address _to, uint256 _tokenId) public;
67   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
68   function safeTransferFrom(
69     address _from,
70     address _to,
71     uint256 _tokenId,
72     bytes _data
73   )
74     public;
75 }
76 
77 // File: zeppelin-solidity/contracts/token/ERC721/ERC721.sol
78 
79 /**
80  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
81  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
82  */
83 contract ERC721Enumerable is ERC721Basic {
84   function totalSupply() public view returns (uint256);
85   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
86   function tokenByIndex(uint256 _index) public view returns (uint256);
87 }
88 
89 
90 /**
91  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
92  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
93  */
94 contract ERC721Metadata is ERC721Basic {
95   function name() public view returns (string _name);
96   function symbol() public view returns (string _symbol);
97   function tokenURI(uint256 _tokenId) public view returns (string);
98 }
99 
100 
101 /**
102  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
103  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
104  */
105 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
106 }
107 
108 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
109 
110 /**
111  * @title ERC721 token receiver interface
112  * @dev Interface for any contract that wants to support safeTransfers
113  *  from ERC721 asset contracts.
114  */
115 contract ERC721Receiver {
116   /**
117    * @dev Magic value to be returned upon successful reception of an NFT
118    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
119    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
120    */
121   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
122 
123   /**
124    * @notice Handle the receipt of an NFT
125    * @dev The ERC721 smart contract calls this function on the recipient
126    *  after a `safetransfer`. This function MAY throw to revert and reject the
127    *  transfer. This function MUST use 50,000 gas or less. Return of other
128    *  than the magic value MUST result in the transaction being reverted.
129    *  Note: the contract address is always the message sender.
130    * @param _from The sending address
131    * @param _tokenId The NFT identifier which is being transfered
132    * @param _data Additional data with no specified format
133    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
134    */
135   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
136 }
137 
138 // File: zeppelin-solidity/contracts/math/SafeMath.sol
139 
140 /**
141  * @title SafeMath
142  * @dev Math operations with safety checks that throw on error
143  */
144 library SafeMath {
145 
146   /**
147   * @dev Multiplies two numbers, throws on overflow.
148   */
149   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
150     if (a == 0) {
151       return 0;
152     }
153     c = a * b;
154     assert(c / a == b);
155     return c;
156   }
157 
158   /**
159   * @dev Integer division of two numbers, truncating the quotient.
160   */
161   function div(uint256 a, uint256 b) internal pure returns (uint256) {
162     // assert(b > 0); // Solidity automatically throws when dividing by 0
163     // uint256 c = a / b;
164     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
165     return a / b;
166   }
167 
168   /**
169   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
170   */
171   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
172     assert(b <= a);
173     return a - b;
174   }
175 
176   /**
177   * @dev Adds two numbers, throws on overflow.
178   */
179   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
180     c = a + b;
181     assert(c >= a);
182     return c;
183   }
184 }
185 
186 // File: zeppelin-solidity/contracts/AddressUtils.sol
187 
188 /**
189  * Utility library of inline functions on addresses
190  */
191 library AddressUtils {
192 
193   /**
194    * Returns whether the target address is a contract
195    * @dev This function will return false if invoked during the constructor of a contract,
196    *  as the code is not actually created until after the constructor finishes.
197    * @param addr address to check
198    * @return whether the target address is a contract
199    */
200   function isContract(address addr) internal view returns (bool) {
201     uint256 size;
202     // XXX Currently there is no better way to check if there is a contract in an address
203     // than to check the size of the code at that address.
204     // See https://ethereum.stackexchange.com/a/14016/36603
205     // for more details about how this works.
206     // TODO Check this again before the Serenity release, because all addresses will be
207     // contracts then.
208     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
209     return size > 0;
210   }
211 
212 }
213 
214 // File: zeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
215 
216 /**
217  * @title ERC721 Non-Fungible Token Standard basic implementation
218  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
219  */
220 contract ERC721BasicToken is ERC721Basic {
221   using SafeMath for uint256;
222   using AddressUtils for address;
223 
224   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
225   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
226   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
227 
228   // Mapping from token ID to owner
229   mapping (uint256 => address) internal tokenOwner;
230 
231   // Mapping from token ID to approved address
232   mapping (uint256 => address) internal tokenApprovals;
233 
234   // Mapping from owner to number of owned token
235   mapping (address => uint256) internal ownedTokensCount;
236 
237   // Mapping from owner to operator approvals
238   mapping (address => mapping (address => bool)) internal operatorApprovals;
239 
240   /**
241    * @dev Guarantees msg.sender is owner of the given token
242    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
243    */
244   modifier onlyOwnerOf(uint256 _tokenId) {
245     require(ownerOf(_tokenId) == msg.sender);
246     _;
247   }
248 
249   /**
250    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
251    * @param _tokenId uint256 ID of the token to validate
252    */
253   modifier canTransfer(uint256 _tokenId) {
254     require(isApprovedOrOwner(msg.sender, _tokenId));
255     _;
256   }
257 
258   /**
259    * @dev Gets the balance of the specified address
260    * @param _owner address to query the balance of
261    * @return uint256 representing the amount owned by the passed address
262    */
263   function balanceOf(address _owner) public view returns (uint256) {
264     require(_owner != address(0));
265     return ownedTokensCount[_owner];
266   }
267 
268   /**
269    * @dev Gets the owner of the specified token ID
270    * @param _tokenId uint256 ID of the token to query the owner of
271    * @return owner address currently marked as the owner of the given token ID
272    */
273   function ownerOf(uint256 _tokenId) public view returns (address) {
274     address owner = tokenOwner[_tokenId];
275     require(owner != address(0));
276     return owner;
277   }
278 
279   /**
280    * @dev Returns whether the specified token exists
281    * @param _tokenId uint256 ID of the token to query the existance of
282    * @return whether the token exists
283    */
284   function exists(uint256 _tokenId) public view returns (bool) {
285     address owner = tokenOwner[_tokenId];
286     return owner != address(0);
287   }
288 
289   /**
290    * @dev Approves another address to transfer the given token ID
291    * @dev The zero address indicates there is no approved address.
292    * @dev There can only be one approved address per token at a given time.
293    * @dev Can only be called by the token owner or an approved operator.
294    * @param _to address to be approved for the given token ID
295    * @param _tokenId uint256 ID of the token to be approved
296    */
297   function approve(address _to, uint256 _tokenId) public {
298     address owner = ownerOf(_tokenId);
299     require(_to != owner);
300     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
301 
302     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
303       tokenApprovals[_tokenId] = _to;
304       emit Approval(owner, _to, _tokenId);
305     }
306   }
307 
308   /**
309    * @dev Gets the approved address for a token ID, or zero if no address set
310    * @param _tokenId uint256 ID of the token to query the approval of
311    * @return address currently approved for a the given token ID
312    */
313   function getApproved(uint256 _tokenId) public view returns (address) {
314     return tokenApprovals[_tokenId];
315   }
316 
317   /**
318    * @dev Sets or unsets the approval of a given operator
319    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
320    * @param _to operator address to set the approval
321    * @param _approved representing the status of the approval to be set
322    */
323   function setApprovalForAll(address _to, bool _approved) public {
324     require(_to != msg.sender);
325     operatorApprovals[msg.sender][_to] = _approved;
326     emit ApprovalForAll(msg.sender, _to, _approved);
327   }
328 
329   /**
330    * @dev Tells whether an operator is approved by a given owner
331    * @param _owner owner address which you want to query the approval of
332    * @param _operator operator address which you want to query the approval of
333    * @return bool whether the given operator is approved by the given owner
334    */
335   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
336     return operatorApprovals[_owner][_operator];
337   }
338 
339   /**
340    * @dev Transfers the ownership of a given token ID to another address
341    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
342    * @dev Requires the msg sender to be the owner, approved, or operator
343    * @param _from current owner of the token
344    * @param _to address to receive the ownership of the given token ID
345    * @param _tokenId uint256 ID of the token to be transferred
346   */
347   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
348     require(_from != address(0));
349     require(_to != address(0));
350 
351     clearApproval(_from, _tokenId);
352     removeTokenFrom(_from, _tokenId);
353     addTokenTo(_to, _tokenId);
354 
355     emit Transfer(_from, _to, _tokenId);
356   }
357 
358   /**
359    * @dev Safely transfers the ownership of a given token ID to another address
360    * @dev If the target address is a contract, it must implement `onERC721Received`,
361    *  which is called upon a safe transfer, and return the magic value
362    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
363    *  the transfer is reverted.
364    * @dev Requires the msg sender to be the owner, approved, or operator
365    * @param _from current owner of the token
366    * @param _to address to receive the ownership of the given token ID
367    * @param _tokenId uint256 ID of the token to be transferred
368   */
369   function safeTransferFrom(
370     address _from,
371     address _to,
372     uint256 _tokenId
373   )
374     public
375     canTransfer(_tokenId)
376   {
377     // solium-disable-next-line arg-overflow
378     safeTransferFrom(_from, _to, _tokenId, "");
379   }
380 
381   /**
382    * @dev Safely transfers the ownership of a given token ID to another address
383    * @dev If the target address is a contract, it must implement `onERC721Received`,
384    *  which is called upon a safe transfer, and return the magic value
385    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
386    *  the transfer is reverted.
387    * @dev Requires the msg sender to be the owner, approved, or operator
388    * @param _from current owner of the token
389    * @param _to address to receive the ownership of the given token ID
390    * @param _tokenId uint256 ID of the token to be transferred
391    * @param _data bytes data to send along with a safe transfer check
392    */
393   function safeTransferFrom(
394     address _from,
395     address _to,
396     uint256 _tokenId,
397     bytes _data
398   )
399     public
400     canTransfer(_tokenId)
401   {
402     transferFrom(_from, _to, _tokenId);
403     // solium-disable-next-line arg-overflow
404     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
405   }
406 
407   /**
408    * @dev Returns whether the given spender can transfer a given token ID
409    * @param _spender address of the spender to query
410    * @param _tokenId uint256 ID of the token to be transferred
411    * @return bool whether the msg.sender is approved for the given token ID,
412    *  is an operator of the owner, or is the owner of the token
413    */
414   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
415     address owner = ownerOf(_tokenId);
416     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
417   }
418 
419   /**
420    * @dev Internal function to mint a new token
421    * @dev Reverts if the given token ID already exists
422    * @param _to The address that will own the minted token
423    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
424    */
425   function _mint(address _to, uint256 _tokenId) internal {
426     require(_to != address(0));
427     addTokenTo(_to, _tokenId);
428     emit Transfer(address(0), _to, _tokenId);
429   }
430 
431   /**
432    * @dev Internal function to burn a specific token
433    * @dev Reverts if the token does not exist
434    * @param _tokenId uint256 ID of the token being burned by the msg.sender
435    */
436   function _burn(address _owner, uint256 _tokenId) internal {
437     clearApproval(_owner, _tokenId);
438     removeTokenFrom(_owner, _tokenId);
439     emit Transfer(_owner, address(0), _tokenId);
440   }
441 
442   /**
443    * @dev Internal function to clear current approval of a given token ID
444    * @dev Reverts if the given address is not indeed the owner of the token
445    * @param _owner owner of the token
446    * @param _tokenId uint256 ID of the token to be transferred
447    */
448   function clearApproval(address _owner, uint256 _tokenId) internal {
449     require(ownerOf(_tokenId) == _owner);
450     if (tokenApprovals[_tokenId] != address(0)) {
451       tokenApprovals[_tokenId] = address(0);
452       emit Approval(_owner, address(0), _tokenId);
453     }
454   }
455 
456   /**
457    * @dev Internal function to add a token ID to the list of a given address
458    * @param _to address representing the new owner of the given token ID
459    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
460    */
461   function addTokenTo(address _to, uint256 _tokenId) internal {
462     require(tokenOwner[_tokenId] == address(0));
463     tokenOwner[_tokenId] = _to;
464     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
465   }
466 
467   /**
468    * @dev Internal function to remove a token ID from the list of a given address
469    * @param _from address representing the previous owner of the given token ID
470    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
471    */
472   function removeTokenFrom(address _from, uint256 _tokenId) internal {
473     require(ownerOf(_tokenId) == _from);
474     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
475     tokenOwner[_tokenId] = address(0);
476   }
477 
478   /**
479    * @dev Internal function to invoke `onERC721Received` on a target address
480    * @dev The call is not executed if the target address is not a contract
481    * @param _from address representing the previous owner of the given token ID
482    * @param _to target address that will receive the tokens
483    * @param _tokenId uint256 ID of the token to be transferred
484    * @param _data bytes optional data to send along with the call
485    * @return whether the call correctly returned the expected magic value
486    */
487   function checkAndCallSafeTransfer(
488     address _from,
489     address _to,
490     uint256 _tokenId,
491     bytes _data
492   )
493     internal
494     returns (bool)
495   {
496     if (!_to.isContract()) {
497       return true;
498     }
499     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
500     return (retval == ERC721_RECEIVED);
501   }
502 }
503 
504 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
505 
506 /**
507  * @title Full ERC721 Token
508  * This implementation includes all the required and some optional functionality of the ERC721 standard
509  * Moreover, it includes approve all functionality using operator terminology
510  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
511  */
512 contract ERC721Token is ERC721, ERC721BasicToken {
513   // Token name
514   string internal name_;
515 
516   // Token symbol
517   string internal symbol_;
518 
519   // Mapping from owner to list of owned token IDs
520   mapping (address => uint256[]) internal ownedTokens;
521 
522   // Mapping from token ID to index of the owner tokens list
523   mapping(uint256 => uint256) internal ownedTokensIndex;
524 
525   // Array with all token ids, used for enumeration
526   uint256[] internal allTokens;
527 
528   // Mapping from token id to position in the allTokens array
529   mapping(uint256 => uint256) internal allTokensIndex;
530 
531   // Optional mapping for token URIs
532   mapping(uint256 => string) internal tokenURIs;
533 
534   /**
535    * @dev Constructor function
536    */
537   function ERC721Token(string _name, string _symbol) public {
538     name_ = _name;
539     symbol_ = _symbol;
540   }
541 
542   /**
543    * @dev Gets the token name
544    * @return string representing the token name
545    */
546   function name() public view returns (string) {
547     return name_;
548   }
549 
550   /**
551    * @dev Gets the token symbol
552    * @return string representing the token symbol
553    */
554   function symbol() public view returns (string) {
555     return symbol_;
556   }
557 
558   /**
559    * @dev Returns an URI for a given token ID
560    * @dev Throws if the token ID does not exist. May return an empty string.
561    * @param _tokenId uint256 ID of the token to query
562    */
563   function tokenURI(uint256 _tokenId) public view returns (string) {
564     require(exists(_tokenId));
565     return tokenURIs[_tokenId];
566   }
567 
568   /**
569    * @dev Gets the token ID at a given index of the tokens list of the requested owner
570    * @param _owner address owning the tokens list to be accessed
571    * @param _index uint256 representing the index to be accessed of the requested tokens list
572    * @return uint256 token ID at the given index of the tokens list owned by the requested address
573    */
574   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
575     require(_index < balanceOf(_owner));
576     return ownedTokens[_owner][_index];
577   }
578 
579   /**
580    * @dev Gets the total amount of tokens stored by the contract
581    * @return uint256 representing the total amount of tokens
582    */
583   function totalSupply() public view returns (uint256) {
584     return allTokens.length;
585   }
586 
587   /**
588    * @dev Gets the token ID at a given index of all the tokens in this contract
589    * @dev Reverts if the index is greater or equal to the total number of tokens
590    * @param _index uint256 representing the index to be accessed of the tokens list
591    * @return uint256 token ID at the given index of the tokens list
592    */
593   function tokenByIndex(uint256 _index) public view returns (uint256) {
594     require(_index < totalSupply());
595     return allTokens[_index];
596   }
597 
598   /**
599    * @dev Internal function to set the token URI for a given token
600    * @dev Reverts if the token ID does not exist
601    * @param _tokenId uint256 ID of the token to set its URI
602    * @param _uri string URI to assign
603    */
604   function _setTokenURI(uint256 _tokenId, string _uri) internal {
605     require(exists(_tokenId));
606     tokenURIs[_tokenId] = _uri;
607   }
608 
609   /**
610    * @dev Internal function to add a token ID to the list of a given address
611    * @param _to address representing the new owner of the given token ID
612    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
613    */
614   function addTokenTo(address _to, uint256 _tokenId) internal {
615     super.addTokenTo(_to, _tokenId);
616     uint256 length = ownedTokens[_to].length;
617     ownedTokens[_to].push(_tokenId);
618     ownedTokensIndex[_tokenId] = length;
619   }
620 
621   /**
622    * @dev Internal function to remove a token ID from the list of a given address
623    * @param _from address representing the previous owner of the given token ID
624    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
625    */
626   function removeTokenFrom(address _from, uint256 _tokenId) internal {
627     super.removeTokenFrom(_from, _tokenId);
628 
629     uint256 tokenIndex = ownedTokensIndex[_tokenId];
630     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
631     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
632 
633     ownedTokens[_from][tokenIndex] = lastToken;
634     ownedTokens[_from][lastTokenIndex] = 0;
635     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
636     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
637     // the lastToken to the first position, and then dropping the element placed in the last position of the list
638 
639     ownedTokens[_from].length--;
640     ownedTokensIndex[_tokenId] = 0;
641     ownedTokensIndex[lastToken] = tokenIndex;
642   }
643 
644   /**
645    * @dev Internal function to mint a new token
646    * @dev Reverts if the given token ID already exists
647    * @param _to address the beneficiary that will own the minted token
648    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
649    */
650   function _mint(address _to, uint256 _tokenId) internal {
651     super._mint(_to, _tokenId);
652 
653     allTokensIndex[_tokenId] = allTokens.length;
654     allTokens.push(_tokenId);
655   }
656 
657   /**
658    * @dev Internal function to burn a specific token
659    * @dev Reverts if the token does not exist
660    * @param _owner owner of the token to burn
661    * @param _tokenId uint256 ID of the token being burned by the msg.sender
662    */
663   function _burn(address _owner, uint256 _tokenId) internal {
664     super._burn(_owner, _tokenId);
665 
666     // Clear metadata (if any)
667     if (bytes(tokenURIs[_tokenId]).length != 0) {
668       delete tokenURIs[_tokenId];
669     }
670 
671     // Reorg all tokens array
672     uint256 tokenIndex = allTokensIndex[_tokenId];
673     uint256 lastTokenIndex = allTokens.length.sub(1);
674     uint256 lastToken = allTokens[lastTokenIndex];
675 
676     allTokens[tokenIndex] = lastToken;
677     allTokens[lastTokenIndex] = 0;
678 
679     allTokens.length--;
680     allTokensIndex[_tokenId] = 0;
681     allTokensIndex[lastToken] = tokenIndex;
682   }
683 
684 }
685 
686 // File: contracts/TVPremium.sol
687 
688 contract ITVCoupon {
689 
690 }
691 
692 contract ITVCrowdsale {
693     uint256 public currentRate;
694     function buyTokens(address _beneficiary) public payable;
695 }
696 
697 contract ITVToken {
698     function transfer(address _to, uint256 _value) public returns (bool);
699     function safeTransfer(address _to, uint256 _value, bytes _data) public;
700 }
701 
702 contract TVPremium is Ownable, ERC721Token {
703     uint public discountPercentage;
704     uint public price;
705     address public manager;
706     address public TVCouponAddress;
707     address public wallet;
708     address public TVTokenAddress;
709     address public TVCrowdsaleAddress;
710 
711     bytes4 constant TOKEN_RECEIVED = bytes4(keccak256("onTokenReceived(address,uint256,bytes)"));
712     uint internal incrementId = 0;
713     address internal checkAndBuySender;
714 
715     mapping(uint => bool) public usedCoupons;
716 
717     modifier onlyOwnerOrManager() {
718         require(msg.sender == owner || manager == msg.sender);
719         _;
720     }
721 
722     event TokenReceived(address from, uint value, bytes data, uint couponId);
723     event ChangeAndBuyPremium(address buyer, uint rate, uint price, uint couponId);
724 
725     constructor(
726         address _TVTokenAddress,
727         address _TVCrowdsaleAddress,
728         address _TVCouponAddress,
729         address _manager,
730         uint _discountPercentage,
731         address _wallet
732     ) public ERC721Token("TVPremium Token", "TVP")  {
733         TVCouponAddress = _TVCouponAddress;
734         manager = _manager;
735         discountPercentage = _discountPercentage;
736         TVCrowdsaleAddress = _TVCrowdsaleAddress;
737         TVTokenAddress = _TVTokenAddress;
738         wallet = _wallet;
739     }
740 
741     function mint(address to) public onlyOwnerOrManager {
742         incrementId++;
743         super._mint(to, incrementId);
744     }
745 
746     function onTokenReceived(address _from, uint256 _value, bytes _data) public returns (bytes4) {
747         require(msg.sender == TVTokenAddress);
748         uint couponId = uint256(convertBytesToBytes32(_data));
749         uint premiumPrice = couponId == 0 ? price : price - (price * discountPercentage) / 100;
750         require(premiumPrice == _value);
751         if (couponId > 0) {
752             require(!usedCoupons[couponId]);
753             usedCoupons[couponId] = true;
754         }
755         ITVToken(TVTokenAddress).transfer(wallet, _value);
756         _from = this == _from ? checkAndBuySender : _from;
757         checkAndBuySender = address(0);
758 
759         incrementId++;
760         super._mint(_from, incrementId);
761 
762         emit TokenReceived(_from, _value, _data, couponId);
763         return TOKEN_RECEIVED;
764     }
765 
766     function changeAndBuyPremium(uint couponId) public payable {
767         uint rate = ITVCrowdsale(TVCrowdsaleAddress).currentRate();
768         uint premiumPrice = couponId == 0 ? price : price - (price * discountPercentage) / 100;
769 
770         uint priceWei = premiumPrice / rate;
771         require(priceWei == msg.value);
772 
773         ITVCrowdsale(TVCrowdsaleAddress).buyTokens.value(msg.value)(this);
774         bytes memory data = toBytes(couponId);
775         checkAndBuySender = msg.sender;
776         ITVToken(TVTokenAddress).safeTransfer(this, premiumPrice, data);
777 
778         emit ChangeAndBuyPremium(msg.sender, rate, priceWei, couponId);
779     }
780 
781     function getDiscountPrice() public view returns(uint) {
782         return price - (price * discountPercentage) / 100;
783     }
784 
785     function changePrice(uint _price) public onlyOwnerOrManager {
786         price = _price;
787     }
788 
789     function changeTVCouponAddress(address _address) public onlyOwnerOrManager {
790         TVCouponAddress = _address;
791     }
792 
793     function changeDiscountPercentage(uint percentage) public onlyOwnerOrManager {
794         require(discountPercentage <= 100);
795         discountPercentage = percentage;
796     }
797 
798     function changeWallet(address _wallet) public onlyOwnerOrManager {
799         wallet = _wallet;
800     }
801 
802     function changeTVTokenAddress(address newAddress) public onlyOwnerOrManager {
803         TVTokenAddress = newAddress;
804     }
805 
806     function changeTVCrowdsaleAddress(address newAddress) public onlyOwnerOrManager {
807         TVCrowdsaleAddress = newAddress;
808     }
809 
810     function setManager(address _manager) public onlyOwner {
811         manager = _manager;
812     }
813 
814     function convertBytesToBytes32(bytes inBytes) internal pure returns (bytes32 out) {
815         if (inBytes.length == 0) {
816             return 0x0;
817         }
818 
819         assembly {
820             out := mload(add(inBytes, 32))
821         }
822     }
823 
824     function toBytes(uint256 x) internal pure returns (bytes b) {
825         b = new bytes(32);
826         assembly {mstore(add(b, 32), x)}
827     }
828 }