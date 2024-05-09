1 // Sources flattened with buidler v0.1.4
2 pragma solidity 0.4.24;
3 
4 
5 // File openzeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol@v1.10.0
6 
7 /**
8  * @title ERC721 Non-Fungible Token Standard basic interface
9  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
10  */
11 contract ERC721Basic {
12   event Transfer(
13     address indexed _from,
14     address indexed _to,
15     uint256 _tokenId
16   );
17   event Approval(
18     address indexed _owner,
19     address indexed _approved,
20     uint256 _tokenId
21   );
22   event ApprovalForAll(
23     address indexed _owner,
24     address indexed _operator,
25     bool _approved
26   );
27 
28   function balanceOf(address _owner) public view returns (uint256 _balance);
29   function ownerOf(uint256 _tokenId) public view returns (address _owner);
30   function exists(uint256 _tokenId) public view returns (bool _exists);
31 
32   function approve(address _to, uint256 _tokenId) public;
33   function getApproved(uint256 _tokenId)
34     public view returns (address _operator);
35 
36   function setApprovalForAll(address _operator, bool _approved) public;
37   function isApprovedForAll(address _owner, address _operator)
38     public view returns (bool);
39 
40   function transferFrom(address _from, address _to, uint256 _tokenId) public;
41   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
42     public;
43 
44   function safeTransferFrom(
45     address _from,
46     address _to,
47     uint256 _tokenId,
48     bytes _data
49   )
50     public;
51 }
52 
53 
54 // File openzeppelin-solidity/contracts/token/ERC721/ERC721.sol@v1.10.0
55 
56 /**
57  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
58  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
59  */
60 contract ERC721Enumerable is ERC721Basic {
61   function totalSupply() public view returns (uint256);
62   function tokenOfOwnerByIndex(
63     address _owner,
64     uint256 _index
65   )
66     public
67     view
68     returns (uint256 _tokenId);
69 
70   function tokenByIndex(uint256 _index) public view returns (uint256);
71 }
72 
73 
74 /**
75  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
76  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
77  */
78 contract ERC721Metadata is ERC721Basic {
79   function name() public view returns (string _name);
80   function symbol() public view returns (string _symbol);
81   function tokenURI(uint256 _tokenId) public view returns (string);
82 }
83 
84 
85 /**
86  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
87  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
88  */
89 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
90 }
91 
92 
93 // File openzeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol@v1.10.0
94 
95 /**
96  * @title ERC721 token receiver interface
97  * @dev Interface for any contract that wants to support safeTransfers
98  *  from ERC721 asset contracts.
99  */
100 contract ERC721Receiver {
101   /**
102    * @dev Magic value to be returned upon successful reception of an NFT
103    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
104    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
105    */
106   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
107 
108   /**
109    * @notice Handle the receipt of an NFT
110    * @dev The ERC721 smart contract calls this function on the recipient
111    *  after a `safetransfer`. This function MAY throw to revert and reject the
112    *  transfer. This function MUST use 50,000 gas or less. Return of other
113    *  than the magic value MUST result in the transaction being reverted.
114    *  Note: the contract address is always the message sender.
115    * @param _from The sending address
116    * @param _tokenId The NFT identifier which is being transfered
117    * @param _data Additional data with no specified format
118    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
119    */
120   function onERC721Received(
121     address _from,
122     uint256 _tokenId,
123     bytes _data
124   )
125     public
126     returns(bytes4);
127 }
128 
129 
130 // File openzeppelin-solidity/contracts/math/SafeMath.sol@v1.10.0
131 
132 /**
133  * @title SafeMath
134  * @dev Math operations with safety checks that throw on error
135  */
136 library SafeMath {
137 
138   /**
139   * @dev Multiplies two numbers, throws on overflow.
140   */
141   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
142     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
143     // benefit is lost if 'b' is also tested.
144     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
145     if (a == 0) {
146       return 0;
147     }
148 
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
182 
183 // File openzeppelin-solidity/contracts/AddressUtils.sol@v1.10.0
184 
185 /**
186  * Utility library of inline functions on addresses
187  */
188 library AddressUtils {
189 
190   /**
191    * Returns whether the target address is a contract
192    * @dev This function will return false if invoked during the constructor of a contract,
193    *  as the code is not actually created until after the constructor finishes.
194    * @param addr address to check
195    * @return whether the target address is a contract
196    */
197   function isContract(address addr) internal view returns (bool) {
198     uint256 size;
199     // XXX Currently there is no better way to check if there is a contract in an address
200     // than to check the size of the code at that address.
201     // See https://ethereum.stackexchange.com/a/14016/36603
202     // for more details about how this works.
203     // TODO Check this again before the Serenity release, because all addresses will be
204     // contracts then.
205     // solium-disable-next-line security/no-inline-assembly
206     assembly { size := extcodesize(addr) }
207     return size > 0;
208   }
209 
210 }
211 
212 
213 // File openzeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol@v1.10.0
214 
215 /**
216  * @title ERC721 Non-Fungible Token Standard basic implementation
217  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
218  */
219 contract ERC721BasicToken is ERC721Basic {
220   using SafeMath for uint256;
221   using AddressUtils for address;
222 
223   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
224   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
225   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
226 
227   // Mapping from token ID to owner
228   mapping (uint256 => address) internal tokenOwner;
229 
230   // Mapping from token ID to approved address
231   mapping (uint256 => address) internal tokenApprovals;
232 
233   // Mapping from owner to number of owned token
234   mapping (address => uint256) internal ownedTokensCount;
235 
236   // Mapping from owner to operator approvals
237   mapping (address => mapping (address => bool)) internal operatorApprovals;
238 
239   /**
240    * @dev Guarantees msg.sender is owner of the given token
241    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
242    */
243   modifier onlyOwnerOf(uint256 _tokenId) {
244     require(ownerOf(_tokenId) == msg.sender);
245     _;
246   }
247 
248   /**
249    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
250    * @param _tokenId uint256 ID of the token to validate
251    */
252   modifier canTransfer(uint256 _tokenId) {
253     require(isApprovedOrOwner(msg.sender, _tokenId));
254     _;
255   }
256 
257   /**
258    * @dev Gets the balance of the specified address
259    * @param _owner address to query the balance of
260    * @return uint256 representing the amount owned by the passed address
261    */
262   function balanceOf(address _owner) public view returns (uint256) {
263     require(_owner != address(0));
264     return ownedTokensCount[_owner];
265   }
266 
267   /**
268    * @dev Gets the owner of the specified token ID
269    * @param _tokenId uint256 ID of the token to query the owner of
270    * @return owner address currently marked as the owner of the given token ID
271    */
272   function ownerOf(uint256 _tokenId) public view returns (address) {
273     address owner = tokenOwner[_tokenId];
274     require(owner != address(0));
275     return owner;
276   }
277 
278   /**
279    * @dev Returns whether the specified token exists
280    * @param _tokenId uint256 ID of the token to query the existence of
281    * @return whether the token exists
282    */
283   function exists(uint256 _tokenId) public view returns (bool) {
284     address owner = tokenOwner[_tokenId];
285     return owner != address(0);
286   }
287 
288   /**
289    * @dev Approves another address to transfer the given token ID
290    * @dev The zero address indicates there is no approved address.
291    * @dev There can only be one approved address per token at a given time.
292    * @dev Can only be called by the token owner or an approved operator.
293    * @param _to address to be approved for the given token ID
294    * @param _tokenId uint256 ID of the token to be approved
295    */
296   function approve(address _to, uint256 _tokenId) public {
297     address owner = ownerOf(_tokenId);
298     require(_to != owner);
299     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
300 
301     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
302       tokenApprovals[_tokenId] = _to;
303       emit Approval(owner, _to, _tokenId);
304     }
305   }
306 
307   /**
308    * @dev Gets the approved address for a token ID, or zero if no address set
309    * @param _tokenId uint256 ID of the token to query the approval of
310    * @return address currently approved for the given token ID
311    */
312   function getApproved(uint256 _tokenId) public view returns (address) {
313     return tokenApprovals[_tokenId];
314   }
315 
316   /**
317    * @dev Sets or unsets the approval of a given operator
318    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
319    * @param _to operator address to set the approval
320    * @param _approved representing the status of the approval to be set
321    */
322   function setApprovalForAll(address _to, bool _approved) public {
323     require(_to != msg.sender);
324     operatorApprovals[msg.sender][_to] = _approved;
325     emit ApprovalForAll(msg.sender, _to, _approved);
326   }
327 
328   /**
329    * @dev Tells whether an operator is approved by a given owner
330    * @param _owner owner address which you want to query the approval of
331    * @param _operator operator address which you want to query the approval of
332    * @return bool whether the given operator is approved by the given owner
333    */
334   function isApprovedForAll(
335     address _owner,
336     address _operator
337   )
338     public
339     view
340     returns (bool)
341   {
342     return operatorApprovals[_owner][_operator];
343   }
344 
345   /**
346    * @dev Transfers the ownership of a given token ID to another address
347    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
348    * @dev Requires the msg sender to be the owner, approved, or operator
349    * @param _from current owner of the token
350    * @param _to address to receive the ownership of the given token ID
351    * @param _tokenId uint256 ID of the token to be transferred
352   */
353   function transferFrom(
354     address _from,
355     address _to,
356     uint256 _tokenId
357   )
358     public
359     canTransfer(_tokenId)
360   {
361     require(_from != address(0));
362     require(_to != address(0));
363 
364     clearApproval(_from, _tokenId);
365     removeTokenFrom(_from, _tokenId);
366     addTokenTo(_to, _tokenId);
367 
368     emit Transfer(_from, _to, _tokenId);
369   }
370 
371   /**
372    * @dev Safely transfers the ownership of a given token ID to another address
373    * @dev If the target address is a contract, it must implement `onERC721Received`,
374    *  which is called upon a safe transfer, and return the magic value
375    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
376    *  the transfer is reverted.
377    * @dev Requires the msg sender to be the owner, approved, or operator
378    * @param _from current owner of the token
379    * @param _to address to receive the ownership of the given token ID
380    * @param _tokenId uint256 ID of the token to be transferred
381   */
382   function safeTransferFrom(
383     address _from,
384     address _to,
385     uint256 _tokenId
386   )
387     public
388     canTransfer(_tokenId)
389   {
390     // solium-disable-next-line arg-overflow
391     safeTransferFrom(_from, _to, _tokenId, "");
392   }
393 
394   /**
395    * @dev Safely transfers the ownership of a given token ID to another address
396    * @dev If the target address is a contract, it must implement `onERC721Received`,
397    *  which is called upon a safe transfer, and return the magic value
398    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
399    *  the transfer is reverted.
400    * @dev Requires the msg sender to be the owner, approved, or operator
401    * @param _from current owner of the token
402    * @param _to address to receive the ownership of the given token ID
403    * @param _tokenId uint256 ID of the token to be transferred
404    * @param _data bytes data to send along with a safe transfer check
405    */
406   function safeTransferFrom(
407     address _from,
408     address _to,
409     uint256 _tokenId,
410     bytes _data
411   )
412     public
413     canTransfer(_tokenId)
414   {
415     transferFrom(_from, _to, _tokenId);
416     // solium-disable-next-line arg-overflow
417     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
418   }
419 
420   /**
421    * @dev Returns whether the given spender can transfer a given token ID
422    * @param _spender address of the spender to query
423    * @param _tokenId uint256 ID of the token to be transferred
424    * @return bool whether the msg.sender is approved for the given token ID,
425    *  is an operator of the owner, or is the owner of the token
426    */
427   function isApprovedOrOwner(
428     address _spender,
429     uint256 _tokenId
430   )
431     internal
432     view
433     returns (bool)
434   {
435     address owner = ownerOf(_tokenId);
436     // Disable solium check because of
437     // https://github.com/duaraghav8/Solium/issues/175
438     // solium-disable-next-line operator-whitespace
439     return (
440       _spender == owner ||
441       getApproved(_tokenId) == _spender ||
442       isApprovedForAll(owner, _spender)
443     );
444   }
445 
446   /**
447    * @dev Internal function to mint a new token
448    * @dev Reverts if the given token ID already exists
449    * @param _to The address that will own the minted token
450    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
451    */
452   function _mint(address _to, uint256 _tokenId) internal {
453     require(_to != address(0));
454     addTokenTo(_to, _tokenId);
455     emit Transfer(address(0), _to, _tokenId);
456   }
457 
458   /**
459    * @dev Internal function to burn a specific token
460    * @dev Reverts if the token does not exist
461    * @param _tokenId uint256 ID of the token being burned by the msg.sender
462    */
463   function _burn(address _owner, uint256 _tokenId) internal {
464     clearApproval(_owner, _tokenId);
465     removeTokenFrom(_owner, _tokenId);
466     emit Transfer(_owner, address(0), _tokenId);
467   }
468 
469   /**
470    * @dev Internal function to clear current approval of a given token ID
471    * @dev Reverts if the given address is not indeed the owner of the token
472    * @param _owner owner of the token
473    * @param _tokenId uint256 ID of the token to be transferred
474    */
475   function clearApproval(address _owner, uint256 _tokenId) internal {
476     require(ownerOf(_tokenId) == _owner);
477     if (tokenApprovals[_tokenId] != address(0)) {
478       tokenApprovals[_tokenId] = address(0);
479       emit Approval(_owner, address(0), _tokenId);
480     }
481   }
482 
483   /**
484    * @dev Internal function to add a token ID to the list of a given address
485    * @param _to address representing the new owner of the given token ID
486    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
487    */
488   function addTokenTo(address _to, uint256 _tokenId) internal {
489     require(tokenOwner[_tokenId] == address(0));
490     tokenOwner[_tokenId] = _to;
491     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
492   }
493 
494   /**
495    * @dev Internal function to remove a token ID from the list of a given address
496    * @param _from address representing the previous owner of the given token ID
497    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
498    */
499   function removeTokenFrom(address _from, uint256 _tokenId) internal {
500     require(ownerOf(_tokenId) == _from);
501     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
502     tokenOwner[_tokenId] = address(0);
503   }
504 
505   /**
506    * @dev Internal function to invoke `onERC721Received` on a target address
507    * @dev The call is not executed if the target address is not a contract
508    * @param _from address representing the previous owner of the given token ID
509    * @param _to target address that will receive the tokens
510    * @param _tokenId uint256 ID of the token to be transferred
511    * @param _data bytes optional data to send along with the call
512    * @return whether the call correctly returned the expected magic value
513    */
514   function checkAndCallSafeTransfer(
515     address _from,
516     address _to,
517     uint256 _tokenId,
518     bytes _data
519   )
520     internal
521     returns (bool)
522   {
523     if (!_to.isContract()) {
524       return true;
525     }
526     bytes4 retval = ERC721Receiver(_to).onERC721Received(
527       _from, _tokenId, _data);
528     return (retval == ERC721_RECEIVED);
529   }
530 }
531 
532 
533 // File openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol@v1.10.0
534 
535 /**
536  * @title Full ERC721 Token
537  * This implementation includes all the required and some optional functionality of the ERC721 standard
538  * Moreover, it includes approve all functionality using operator terminology
539  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
540  */
541 contract ERC721Token is ERC721, ERC721BasicToken {
542   // Token name
543   string internal name_;
544 
545   // Token symbol
546   string internal symbol_;
547 
548   // Mapping from owner to list of owned token IDs
549   mapping(address => uint256[]) internal ownedTokens;
550 
551   // Mapping from token ID to index of the owner tokens list
552   mapping(uint256 => uint256) internal ownedTokensIndex;
553 
554   // Array with all token ids, used for enumeration
555   uint256[] internal allTokens;
556 
557   // Mapping from token id to position in the allTokens array
558   mapping(uint256 => uint256) internal allTokensIndex;
559 
560   // Optional mapping for token URIs
561   mapping(uint256 => string) internal tokenURIs;
562 
563   /**
564    * @dev Constructor function
565    */
566   constructor(string _name, string _symbol) public {
567     name_ = _name;
568     symbol_ = _symbol;
569   }
570 
571   /**
572    * @dev Gets the token name
573    * @return string representing the token name
574    */
575   function name() public view returns (string) {
576     return name_;
577   }
578 
579   /**
580    * @dev Gets the token symbol
581    * @return string representing the token symbol
582    */
583   function symbol() public view returns (string) {
584     return symbol_;
585   }
586 
587   /**
588    * @dev Returns an URI for a given token ID
589    * @dev Throws if the token ID does not exist. May return an empty string.
590    * @param _tokenId uint256 ID of the token to query
591    */
592   function tokenURI(uint256 _tokenId) public view returns (string) {
593     require(exists(_tokenId));
594     return tokenURIs[_tokenId];
595   }
596 
597   /**
598    * @dev Gets the token ID at a given index of the tokens list of the requested owner
599    * @param _owner address owning the tokens list to be accessed
600    * @param _index uint256 representing the index to be accessed of the requested tokens list
601    * @return uint256 token ID at the given index of the tokens list owned by the requested address
602    */
603   function tokenOfOwnerByIndex(
604     address _owner,
605     uint256 _index
606   )
607     public
608     view
609     returns (uint256)
610   {
611     require(_index < balanceOf(_owner));
612     return ownedTokens[_owner][_index];
613   }
614 
615   /**
616    * @dev Gets the total amount of tokens stored by the contract
617    * @return uint256 representing the total amount of tokens
618    */
619   function totalSupply() public view returns (uint256) {
620     return allTokens.length;
621   }
622 
623   /**
624    * @dev Gets the token ID at a given index of all the tokens in this contract
625    * @dev Reverts if the index is greater or equal to the total number of tokens
626    * @param _index uint256 representing the index to be accessed of the tokens list
627    * @return uint256 token ID at the given index of the tokens list
628    */
629   function tokenByIndex(uint256 _index) public view returns (uint256) {
630     require(_index < totalSupply());
631     return allTokens[_index];
632   }
633 
634   /**
635    * @dev Internal function to set the token URI for a given token
636    * @dev Reverts if the token ID does not exist
637    * @param _tokenId uint256 ID of the token to set its URI
638    * @param _uri string URI to assign
639    */
640   function _setTokenURI(uint256 _tokenId, string _uri) internal {
641     require(exists(_tokenId));
642     tokenURIs[_tokenId] = _uri;
643   }
644 
645   /**
646    * @dev Internal function to add a token ID to the list of a given address
647    * @param _to address representing the new owner of the given token ID
648    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
649    */
650   function addTokenTo(address _to, uint256 _tokenId) internal {
651     super.addTokenTo(_to, _tokenId);
652     uint256 length = ownedTokens[_to].length;
653     ownedTokens[_to].push(_tokenId);
654     ownedTokensIndex[_tokenId] = length;
655   }
656 
657   /**
658    * @dev Internal function to remove a token ID from the list of a given address
659    * @param _from address representing the previous owner of the given token ID
660    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
661    */
662   function removeTokenFrom(address _from, uint256 _tokenId) internal {
663     super.removeTokenFrom(_from, _tokenId);
664 
665     uint256 tokenIndex = ownedTokensIndex[_tokenId];
666     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
667     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
668 
669     ownedTokens[_from][tokenIndex] = lastToken;
670     ownedTokens[_from][lastTokenIndex] = 0;
671     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
672     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
673     // the lastToken to the first position, and then dropping the element placed in the last position of the list
674 
675     ownedTokens[_from].length--;
676     ownedTokensIndex[_tokenId] = 0;
677     ownedTokensIndex[lastToken] = tokenIndex;
678   }
679 
680   /**
681    * @dev Internal function to mint a new token
682    * @dev Reverts if the given token ID already exists
683    * @param _to address the beneficiary that will own the minted token
684    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
685    */
686   function _mint(address _to, uint256 _tokenId) internal {
687     super._mint(_to, _tokenId);
688 
689     allTokensIndex[_tokenId] = allTokens.length;
690     allTokens.push(_tokenId);
691   }
692 
693   /**
694    * @dev Internal function to burn a specific token
695    * @dev Reverts if the token does not exist
696    * @param _owner owner of the token to burn
697    * @param _tokenId uint256 ID of the token being burned by the msg.sender
698    */
699   function _burn(address _owner, uint256 _tokenId) internal {
700     super._burn(_owner, _tokenId);
701 
702     // Clear metadata (if any)
703     if (bytes(tokenURIs[_tokenId]).length != 0) {
704       delete tokenURIs[_tokenId];
705     }
706 
707     // Reorg all tokens array
708     uint256 tokenIndex = allTokensIndex[_tokenId];
709     uint256 lastTokenIndex = allTokens.length.sub(1);
710     uint256 lastToken = allTokens[lastTokenIndex];
711 
712     allTokens[tokenIndex] = lastToken;
713     allTokens[lastTokenIndex] = 0;
714 
715     allTokens.length--;
716     allTokensIndex[_tokenId] = 0;
717     allTokensIndex[lastToken] = tokenIndex;
718   }
719 
720 }
721 
722 
723 // File openzeppelin-solidity/contracts/ownership/Ownable.sol@v1.10.0
724 
725 /**
726  * @title Ownable
727  * @dev The Ownable contract has an owner address, and provides basic authorization control
728  * functions, this simplifies the implementation of "user permissions".
729  */
730 contract Ownable {
731   address public owner;
732 
733 
734   event OwnershipRenounced(address indexed previousOwner);
735   event OwnershipTransferred(
736     address indexed previousOwner,
737     address indexed newOwner
738   );
739 
740 
741   /**
742    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
743    * account.
744    */
745   constructor() public {
746     owner = msg.sender;
747   }
748 
749   /**
750    * @dev Throws if called by any account other than the owner.
751    */
752   modifier onlyOwner() {
753     require(msg.sender == owner);
754     _;
755   }
756 
757   /**
758    * @dev Allows the current owner to relinquish control of the contract.
759    */
760   function renounceOwnership() public onlyOwner {
761     emit OwnershipRenounced(owner);
762     owner = address(0);
763   }
764 
765   /**
766    * @dev Allows the current owner to transfer control of the contract to a newOwner.
767    * @param _newOwner The address to transfer ownership to.
768    */
769   function transferOwnership(address _newOwner) public onlyOwner {
770     _transferOwnership(_newOwner);
771   }
772 
773   /**
774    * @dev Transfers control of the contract to a newOwner.
775    * @param _newOwner The address to transfer ownership to.
776    */
777   function _transferOwnership(address _newOwner) internal {
778     require(_newOwner != address(0));
779     emit OwnershipTransferred(owner, _newOwner);
780     owner = _newOwner;
781   }
782 }
783 
784 
785 // File contracts/Invite.sol
786 
787 contract DecentralandInvite is ERC721Token, Ownable {
788   mapping (address => uint256) public balance;
789   mapping (uint256 => bytes) public metadata;
790 
791   event Invited(address who, address target, uint256 id, bytes note);
792   event UpdateInvites(address who, uint256 amount);
793   event URIUpdated(uint256 id, string newUri);
794 
795   constructor() public ERC721Token("Decentraland Invite", "DCLI") {}
796 
797   function allow(address target, uint256 amount) public onlyOwner {
798     balance[target] = amount;
799     emit UpdateInvites(target, amount);
800   }
801 
802   function invite(address target, bytes note) public {
803     require(balance[msg.sender] > 0);
804     balance[msg.sender] -= 1;
805     uint256 id = totalSupply();
806     _mint(target, id);
807     metadata[id] = note;
808     emit Invited(msg.sender, target, id, note);
809   }
810 
811   function setTokenURI(uint256 id, string uri) public {
812     require(msg.sender == ownerOf(id));
813     _setTokenURI(id, uri);
814     emit URIUpdated(id, uri);
815   }
816 }