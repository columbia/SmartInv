1 pragma solidity ^0.4.24;
2 
3 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
4 
5 /**
6  * @title ERC721 Non-Fungible Token Standard basic interface
7  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
8  */
9 contract ERC721Basic {
10   event Transfer(
11     address indexed _from,
12     address indexed _to,
13     uint256 _tokenId
14   );
15   event Approval(
16     address indexed _owner,
17     address indexed _approved,
18     uint256 _tokenId
19   );
20   event ApprovalForAll(
21     address indexed _owner,
22     address indexed _operator,
23     bool _approved
24   );
25 
26   function balanceOf(address _owner) public view returns (uint256 _balance);
27   function ownerOf(uint256 _tokenId) public view returns (address _owner);
28   function exists(uint256 _tokenId) public view returns (bool _exists);
29 
30   function approve(address _to, uint256 _tokenId) public;
31   function getApproved(uint256 _tokenId)
32     public view returns (address _operator);
33 
34   function setApprovalForAll(address _operator, bool _approved) public;
35   function isApprovedForAll(address _owner, address _operator)
36     public view returns (bool);
37 
38   function transferFrom(address _from, address _to, uint256 _tokenId) public;
39   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
40     public;
41 
42   function safeTransferFrom(
43     address _from,
44     address _to,
45     uint256 _tokenId,
46     bytes _data
47   )
48     public;
49 }
50 
51 // File: zeppelin-solidity/contracts/token/ERC721/ERC721.sol
52 
53 /**
54  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
55  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
56  */
57 contract ERC721Enumerable is ERC721Basic {
58   function totalSupply() public view returns (uint256);
59   function tokenOfOwnerByIndex(
60     address _owner,
61     uint256 _index
62   )
63     public
64     view
65     returns (uint256 _tokenId);
66 
67   function tokenByIndex(uint256 _index) public view returns (uint256);
68 }
69 
70 
71 /**
72  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
73  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
74  */
75 contract ERC721Metadata is ERC721Basic {
76   function name() public view returns (string _name);
77   function symbol() public view returns (string _symbol);
78   function tokenURI(uint256 _tokenId) public view returns (string);
79 }
80 
81 
82 /**
83  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
84  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
85  */
86 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
87 }
88 
89 // File: zeppelin-solidity/contracts/AddressUtils.sol
90 
91 /**
92  * Utility library of inline functions on addresses
93  */
94 library AddressUtils {
95 
96   /**
97    * Returns whether the target address is a contract
98    * @dev This function will return false if invoked during the constructor of a contract,
99    *  as the code is not actually created until after the constructor finishes.
100    * @param addr address to check
101    * @return whether the target address is a contract
102    */
103   function isContract(address addr) internal view returns (bool) {
104     uint256 size;
105     // XXX Currently there is no better way to check if there is a contract in an address
106     // than to check the size of the code at that address.
107     // See https://ethereum.stackexchange.com/a/14016/36603
108     // for more details about how this works.
109     // TODO Check this again before the Serenity release, because all addresses will be
110     // contracts then.
111     // solium-disable-next-line security/no-inline-assembly
112     assembly { size := extcodesize(addr) }
113     return size > 0;
114   }
115 
116 }
117 
118 // File: zeppelin-solidity/contracts/math/SafeMath.sol
119 
120 /**
121  * @title SafeMath
122  * @dev Math operations with safety checks that throw on error
123  */
124 library SafeMath {
125 
126   /**
127   * @dev Multiplies two numbers, throws on overflow.
128   */
129   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
130     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
131     // benefit is lost if 'b' is also tested.
132     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
133     if (a == 0) {
134       return 0;
135     }
136 
137     c = a * b;
138     assert(c / a == b);
139     return c;
140   }
141 
142   /**
143   * @dev Integer division of two numbers, truncating the quotient.
144   */
145   function div(uint256 a, uint256 b) internal pure returns (uint256) {
146     // assert(b > 0); // Solidity automatically throws when dividing by 0
147     // uint256 c = a / b;
148     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
149     return a / b;
150   }
151 
152   /**
153   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
154   */
155   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156     assert(b <= a);
157     return a - b;
158   }
159 
160   /**
161   * @dev Adds two numbers, throws on overflow.
162   */
163   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
164     c = a + b;
165     assert(c >= a);
166     return c;
167   }
168 }
169 
170 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
171 
172 /**
173  * @title ERC721 token receiver interface
174  * @dev Interface for any contract that wants to support safeTransfers
175  *  from ERC721 asset contracts.
176  */
177 contract ERC721Receiver {
178   /**
179    * @dev Magic value to be returned upon successful reception of an NFT
180    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
181    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
182    */
183   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
184 
185   /**
186    * @notice Handle the receipt of an NFT
187    * @dev The ERC721 smart contract calls this function on the recipient
188    *  after a `safetransfer`. This function MAY throw to revert and reject the
189    *  transfer. This function MUST use 50,000 gas or less. Return of other
190    *  than the magic value MUST result in the transaction being reverted.
191    *  Note: the contract address is always the message sender.
192    * @param _from The sending address
193    * @param _tokenId The NFT identifier which is being transfered
194    * @param _data Additional data with no specified format
195    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
196    */
197   function onERC721Received(
198     address _from,
199     uint256 _tokenId,
200     bytes _data
201   )
202     public
203     returns(bytes4);
204 }
205 
206 // File: zeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
207 
208 /**
209  * @title ERC721 Non-Fungible Token Standard basic implementation
210  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
211  */
212 contract ERC721BasicToken is ERC721Basic {
213   using SafeMath for uint256;
214   using AddressUtils for address;
215 
216   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
217   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
218   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
219 
220   // Mapping from token ID to owner
221   mapping (uint256 => address) internal tokenOwner;
222 
223   // Mapping from token ID to approved address
224   mapping (uint256 => address) internal tokenApprovals;
225 
226   // Mapping from owner to number of owned token
227   mapping (address => uint256) internal ownedTokensCount;
228 
229   // Mapping from owner to operator approvals
230   mapping (address => mapping (address => bool)) internal operatorApprovals;
231 
232   /**
233    * @dev Guarantees msg.sender is owner of the given token
234    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
235    */
236   modifier onlyOwnerOf(uint256 _tokenId) {
237     require(ownerOf(_tokenId) == msg.sender);
238     _;
239   }
240 
241   /**
242    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
243    * @param _tokenId uint256 ID of the token to validate
244    */
245   modifier canTransfer(uint256 _tokenId) {
246     require(isApprovedOrOwner(msg.sender, _tokenId));
247     _;
248   }
249 
250   /**
251    * @dev Gets the balance of the specified address
252    * @param _owner address to query the balance of
253    * @return uint256 representing the amount owned by the passed address
254    */
255   function balanceOf(address _owner) public view returns (uint256) {
256     require(_owner != address(0));
257     return ownedTokensCount[_owner];
258   }
259 
260   /**
261    * @dev Gets the owner of the specified token ID
262    * @param _tokenId uint256 ID of the token to query the owner of
263    * @return owner address currently marked as the owner of the given token ID
264    */
265   function ownerOf(uint256 _tokenId) public view returns (address) {
266     address owner = tokenOwner[_tokenId];
267     require(owner != address(0));
268     return owner;
269   }
270 
271   /**
272    * @dev Returns whether the specified token exists
273    * @param _tokenId uint256 ID of the token to query the existence of
274    * @return whether the token exists
275    */
276   function exists(uint256 _tokenId) public view returns (bool) {
277     address owner = tokenOwner[_tokenId];
278     return owner != address(0);
279   }
280 
281   /**
282    * @dev Approves another address to transfer the given token ID
283    * @dev The zero address indicates there is no approved address.
284    * @dev There can only be one approved address per token at a given time.
285    * @dev Can only be called by the token owner or an approved operator.
286    * @param _to address to be approved for the given token ID
287    * @param _tokenId uint256 ID of the token to be approved
288    */
289   function approve(address _to, uint256 _tokenId) public {
290     address owner = ownerOf(_tokenId);
291     require(_to != owner);
292     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
293 
294     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
295       tokenApprovals[_tokenId] = _to;
296       emit Approval(owner, _to, _tokenId);
297     }
298   }
299 
300   /**
301    * @dev Gets the approved address for a token ID, or zero if no address set
302    * @param _tokenId uint256 ID of the token to query the approval of
303    * @return address currently approved for the given token ID
304    */
305   function getApproved(uint256 _tokenId) public view returns (address) {
306     return tokenApprovals[_tokenId];
307   }
308 
309   /**
310    * @dev Sets or unsets the approval of a given operator
311    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
312    * @param _to operator address to set the approval
313    * @param _approved representing the status of the approval to be set
314    */
315   function setApprovalForAll(address _to, bool _approved) public {
316     require(_to != msg.sender);
317     operatorApprovals[msg.sender][_to] = _approved;
318     emit ApprovalForAll(msg.sender, _to, _approved);
319   }
320 
321   /**
322    * @dev Tells whether an operator is approved by a given owner
323    * @param _owner owner address which you want to query the approval of
324    * @param _operator operator address which you want to query the approval of
325    * @return bool whether the given operator is approved by the given owner
326    */
327   function isApprovedForAll(
328     address _owner,
329     address _operator
330   )
331     public
332     view
333     returns (bool)
334   {
335     return operatorApprovals[_owner][_operator];
336   }
337 
338   /**
339    * @dev Transfers the ownership of a given token ID to another address
340    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
341    * @dev Requires the msg sender to be the owner, approved, or operator
342    * @param _from current owner of the token
343    * @param _to address to receive the ownership of the given token ID
344    * @param _tokenId uint256 ID of the token to be transferred
345   */
346   function transferFrom(
347     address _from,
348     address _to,
349     uint256 _tokenId
350   )
351     public
352     canTransfer(_tokenId)
353   {
354     require(_from != address(0));
355     require(_to != address(0));
356 
357     clearApproval(_from, _tokenId);
358     removeTokenFrom(_from, _tokenId);
359     addTokenTo(_to, _tokenId);
360 
361     emit Transfer(_from, _to, _tokenId);
362   }
363 
364   /**
365    * @dev Safely transfers the ownership of a given token ID to another address
366    * @dev If the target address is a contract, it must implement `onERC721Received`,
367    *  which is called upon a safe transfer, and return the magic value
368    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
369    *  the transfer is reverted.
370    * @dev Requires the msg sender to be the owner, approved, or operator
371    * @param _from current owner of the token
372    * @param _to address to receive the ownership of the given token ID
373    * @param _tokenId uint256 ID of the token to be transferred
374   */
375   function safeTransferFrom(
376     address _from,
377     address _to,
378     uint256 _tokenId
379   )
380     public
381     canTransfer(_tokenId)
382   {
383     // solium-disable-next-line arg-overflow
384     safeTransferFrom(_from, _to, _tokenId, "");
385   }
386 
387   /**
388    * @dev Safely transfers the ownership of a given token ID to another address
389    * @dev If the target address is a contract, it must implement `onERC721Received`,
390    *  which is called upon a safe transfer, and return the magic value
391    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
392    *  the transfer is reverted.
393    * @dev Requires the msg sender to be the owner, approved, or operator
394    * @param _from current owner of the token
395    * @param _to address to receive the ownership of the given token ID
396    * @param _tokenId uint256 ID of the token to be transferred
397    * @param _data bytes data to send along with a safe transfer check
398    */
399   function safeTransferFrom(
400     address _from,
401     address _to,
402     uint256 _tokenId,
403     bytes _data
404   )
405     public
406     canTransfer(_tokenId)
407   {
408     transferFrom(_from, _to, _tokenId);
409     // solium-disable-next-line arg-overflow
410     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
411   }
412 
413   /**
414    * @dev Returns whether the given spender can transfer a given token ID
415    * @param _spender address of the spender to query
416    * @param _tokenId uint256 ID of the token to be transferred
417    * @return bool whether the msg.sender is approved for the given token ID,
418    *  is an operator of the owner, or is the owner of the token
419    */
420   function isApprovedOrOwner(
421     address _spender,
422     uint256 _tokenId
423   )
424     internal
425     view
426     returns (bool)
427   {
428     address owner = ownerOf(_tokenId);
429     // Disable solium check because of
430     // https://github.com/duaraghav8/Solium/issues/175
431     // solium-disable-next-line operator-whitespace
432     return (
433       _spender == owner ||
434       getApproved(_tokenId) == _spender ||
435       isApprovedForAll(owner, _spender)
436     );
437   }
438 
439   /**
440    * @dev Internal function to mint a new token
441    * @dev Reverts if the given token ID already exists
442    * @param _to The address that will own the minted token
443    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
444    */
445   function _mint(address _to, uint256 _tokenId) internal {
446     require(_to != address(0));
447     addTokenTo(_to, _tokenId);
448     emit Transfer(address(0), _to, _tokenId);
449   }
450 
451   /**
452    * @dev Internal function to burn a specific token
453    * @dev Reverts if the token does not exist
454    * @param _tokenId uint256 ID of the token being burned by the msg.sender
455    */
456   function _burn(address _owner, uint256 _tokenId) internal {
457     clearApproval(_owner, _tokenId);
458     removeTokenFrom(_owner, _tokenId);
459     emit Transfer(_owner, address(0), _tokenId);
460   }
461 
462   /**
463    * @dev Internal function to clear current approval of a given token ID
464    * @dev Reverts if the given address is not indeed the owner of the token
465    * @param _owner owner of the token
466    * @param _tokenId uint256 ID of the token to be transferred
467    */
468   function clearApproval(address _owner, uint256 _tokenId) internal {
469     require(ownerOf(_tokenId) == _owner);
470     if (tokenApprovals[_tokenId] != address(0)) {
471       tokenApprovals[_tokenId] = address(0);
472       emit Approval(_owner, address(0), _tokenId);
473     }
474   }
475 
476   /**
477    * @dev Internal function to add a token ID to the list of a given address
478    * @param _to address representing the new owner of the given token ID
479    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
480    */
481   function addTokenTo(address _to, uint256 _tokenId) internal {
482     require(tokenOwner[_tokenId] == address(0));
483     tokenOwner[_tokenId] = _to;
484     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
485   }
486 
487   /**
488    * @dev Internal function to remove a token ID from the list of a given address
489    * @param _from address representing the previous owner of the given token ID
490    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
491    */
492   function removeTokenFrom(address _from, uint256 _tokenId) internal {
493     require(ownerOf(_tokenId) == _from);
494     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
495     tokenOwner[_tokenId] = address(0);
496   }
497 
498   /**
499    * @dev Internal function to invoke `onERC721Received` on a target address
500    * @dev The call is not executed if the target address is not a contract
501    * @param _from address representing the previous owner of the given token ID
502    * @param _to target address that will receive the tokens
503    * @param _tokenId uint256 ID of the token to be transferred
504    * @param _data bytes optional data to send along with the call
505    * @return whether the call correctly returned the expected magic value
506    */
507   function checkAndCallSafeTransfer(
508     address _from,
509     address _to,
510     uint256 _tokenId,
511     bytes _data
512   )
513     internal
514     returns (bool)
515   {
516     if (!_to.isContract()) {
517       return true;
518     }
519     bytes4 retval = ERC721Receiver(_to).onERC721Received(
520       _from, _tokenId, _data);
521     return (retval == ERC721_RECEIVED);
522   }
523 }
524 
525 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
526 
527 /**
528  * @title Full ERC721 Token
529  * This implementation includes all the required and some optional functionality of the ERC721 standard
530  * Moreover, it includes approve all functionality using operator terminology
531  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
532  */
533 contract ERC721Token is ERC721, ERC721BasicToken {
534   // Token name
535   string internal name_;
536 
537   // Token symbol
538   string internal symbol_;
539 
540   // Mapping from owner to list of owned token IDs
541   mapping(address => uint256[]) internal ownedTokens;
542 
543   // Mapping from token ID to index of the owner tokens list
544   mapping(uint256 => uint256) internal ownedTokensIndex;
545 
546   // Array with all token ids, used for enumeration
547   uint256[] internal allTokens;
548 
549   // Mapping from token id to position in the allTokens array
550   mapping(uint256 => uint256) internal allTokensIndex;
551 
552   // Optional mapping for token URIs
553   mapping(uint256 => string) internal tokenURIs;
554 
555   /**
556    * @dev Constructor function
557    */
558   constructor(string _name, string _symbol) public {
559     name_ = _name;
560     symbol_ = _symbol;
561   }
562 
563   /**
564    * @dev Gets the token name
565    * @return string representing the token name
566    */
567   function name() public view returns (string) {
568     return name_;
569   }
570 
571   /**
572    * @dev Gets the token symbol
573    * @return string representing the token symbol
574    */
575   function symbol() public view returns (string) {
576     return symbol_;
577   }
578 
579   /**
580    * @dev Returns an URI for a given token ID
581    * @dev Throws if the token ID does not exist. May return an empty string.
582    * @param _tokenId uint256 ID of the token to query
583    */
584   function tokenURI(uint256 _tokenId) public view returns (string) {
585     require(exists(_tokenId));
586     return tokenURIs[_tokenId];
587   }
588 
589   /**
590    * @dev Gets the token ID at a given index of the tokens list of the requested owner
591    * @param _owner address owning the tokens list to be accessed
592    * @param _index uint256 representing the index to be accessed of the requested tokens list
593    * @return uint256 token ID at the given index of the tokens list owned by the requested address
594    */
595   function tokenOfOwnerByIndex(
596     address _owner,
597     uint256 _index
598   )
599     public
600     view
601     returns (uint256)
602   {
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
714 // File: contracts/rp.sol
715 
716 contract OrderString {
717     function getOrderString () view external returns(string);
718 }
719 contract RP is ERC721Token("侠客行", "赏善罚恶令") {
720     uint8 public decimals = 0;
721     string[] internal orders;
722     mapping (uint256 => bool) internal unavailableOrders;
723     uint public available;
724     address internal contractOwner;
725     function implementsERC721() public pure returns (bool) {
726         return true;
727     }
728     event GetAvailable(uint256 indexed random, uint256 indexed available);
729 
730     modifier onlyOwner() {
731         require(msg.sender == contractOwner);
732         _;
733     }
734 
735     constructor() public {
736         contractOwner = msg.sender;
737     }
738     
739     function getOrders (address _orderContract) onlyOwner public returns(bool res){
740         require(_orderContract.isContract());
741         bytes memory _orderString = bytes(OrderString(_orderContract).getOrderString());
742         bytes memory char = new bytes(3);
743         delete orders;
744         for (uint i = 0;i < _orderString.length;i += 3) {
745             for (uint j = 0;j < 3;j++) {
746                 char[j] = _orderString[i + j];
747             }
748             orders.push(string(char));
749         }
750         available = orders.length;
751         return true;
752     }
753     
754     function getTokenOrder(uint256 tokenId) view public returns (string) {
755         return orders[tokenId];
756     }
757     
758     function getOwnedTokens() view public returns (string) {
759         bytes memory ownedTokens = new bytes(orders.length * 3);
760         bytes memory fullspace = '　'; // full space (UTF-8)
761         uint c = 0;
762         uint j = 0;
763         for (uint i = 0;i < orders.length;i++) {
764             if (tokenOwner[i] == msg.sender) {
765                 for (c = 0;c < 3;c++) {
766                     ownedTokens[j++] = bytes(orders[i])[c];
767                 }
768             } else {
769                 for (c = 0;c < 3;c++) {
770                     ownedTokens[j++] = bytes(fullspace)[c];
771                 }
772             }
773         }
774         return string(ownedTokens);
775     }
776     
777     function () payable public {
778         require (available > 0,"not available");
779         require (msg.value >= 0.01 ether,"lowest ether");
780         require (msg.sender == contractOwner || balanceOf(msg.sender) == 0,"had one");
781         
782         uint tokenId = _getRandom(orders.length);
783         uint reset = 0;
784         for (uint i = tokenId;i < orders.length;i++) {
785             if (reset == 1) {
786                 i = 0;
787                 reset = 0;
788             }
789             if (! unavailableOrders[i]) {
790                 emit GetAvailable(tokenId,i);
791                 tokenId = i;
792                 break;
793             } else if (i == orders.length - 1) {
794                 reset = 1;
795                 i = 0;
796             }
797         }
798         _mint(msg.sender, tokenId);
799         unavailableOrders[tokenId] = true;
800         available--;
801     }
802 
803     function _getRandom(uint max) private view returns(uint256) {
804         uint256 random = uint256(keccak256(abi.encodePacked(block.difficulty,now)));
805         return  random % max;
806     }
807 
808     function approve(address _to, uint256 _tokenId) public {
809         require (_to == contractOwner || balanceOf(_to) == 0,"had one");
810         super.approve(_to, _tokenId);
811     }
812 
813     function setApprovalForAll(address _to, bool _approved) public {
814         require (_to == contractOwner || balanceOf(_to) == 0,"had one");
815         super.setApprovalForAll(_to, _approved);
816     }
817     
818     function withdraw() external onlyOwner {
819         address contractAddress = this;
820         contractOwner.transfer(contractAddress.balance);
821     }
822 }