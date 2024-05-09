1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title ERC721 Non-Fungible Token Standard basic interface
6  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
7  */
8 contract ERC721Basic {
9   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
10   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
11   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
12 
13   function balanceOf(address _owner) public view returns (uint256 _balance);
14   function ownerOf(uint256 _tokenId) public view returns (address _owner);
15   function exists(uint256 _tokenId) public view returns (bool _exists);
16 
17   function approve(address _to, uint256 _tokenId) public;
18   function getApproved(uint256 _tokenId) public view returns (address _operator);
19 
20   function setApprovalForAll(address _operator, bool _approved) public;
21   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
22 
23   function transferFrom(address _from, address _to, uint256 _tokenId) public;
24   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
25   function safeTransferFrom(
26     address _from,
27     address _to,
28     uint256 _tokenId,
29     bytes _data
30   )
31     public;
32 }
33 
34 
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42   address public owner;
43 
44 
45   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   function Ownable() public {
53     owner = msg.sender;
54   }
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) public onlyOwner {
69     require(newOwner != address(0));
70     emit OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 
76 
77 /// @title An optional contract that allows us to associate metadata to our cards.
78 /// @author The CryptoStrikers Team
79 contract StrikersMetadata {
80 
81   /// @dev The base url for the API where we fetch the metadata.
82   ///   ex: https://us-central1-cryptostrikers-api.cloudfunctions.net/cards/
83   string public apiUrl;
84 
85   constructor(string _apiUrl) public {
86     apiUrl = _apiUrl;
87   }
88 
89   /// @dev Returns the API URL for a given token Id.
90   ///   ex: https://us-central1-cryptostrikers-api.cloudfunctions.net/cards/22
91   ///   Right now, this endpoint returns a JSON blob conforming to OpenSea's spec.
92   ///   see: https://docs.opensea.io/docs/2-adding-metadata
93   function tokenURI(uint256 _tokenId) external view returns (string) {
94     string memory _id = uint2str(_tokenId);
95     return strConcat(apiUrl, _id);
96   }
97 
98   // String helpers below were taken from Oraclize.
99   // https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.4.sol
100 
101   function strConcat(string _a, string _b) internal pure returns (string) {
102     bytes memory _ba = bytes(_a);
103     bytes memory _bb = bytes(_b);
104     string memory ab = new string(_ba.length + _bb.length);
105     bytes memory bab = bytes(ab);
106     uint k = 0;
107     for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
108     for (i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
109     return string(bab);
110   }
111 
112   function uint2str(uint i) internal pure returns (string) {
113     if (i == 0) return "0";
114     uint j = i;
115     uint len;
116     while (j != 0) {
117       len++;
118       j /= 10;
119     }
120     bytes memory bstr = new bytes(len);
121     uint k = len - 1;
122     while (i != 0) {
123       bstr[k--] = byte(48 + i % 10);
124       i /= 10;
125     }
126     return string(bstr);
127   }
128 }
129 
130 
131 
132 
133 
134 
135 
136 
137 
138 
139 
140 
141 
142 
143 
144 
145 /**
146  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
147  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
148  */
149 contract ERC721Enumerable is ERC721Basic {
150   function totalSupply() public view returns (uint256);
151   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
152   function tokenByIndex(uint256 _index) public view returns (uint256);
153 }
154 
155 
156 /**
157  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
158  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
159  */
160 contract ERC721Metadata is ERC721Basic {
161   function name() public view returns (string _name);
162   function symbol() public view returns (string _symbol);
163   function tokenURI(uint256 _tokenId) public view returns (string);
164 }
165 
166 
167 /**
168  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
169  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
170  */
171 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
172 }
173 
174 
175 
176 
177 
178 
179 
180 /**
181  * @title ERC721 token receiver interface
182  * @dev Interface for any contract that wants to support safeTransfers
183  *  from ERC721 asset contracts.
184  */
185 contract ERC721Receiver {
186   /**
187    * @dev Magic value to be returned upon successful reception of an NFT
188    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
189    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
190    */
191   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
192 
193   /**
194    * @notice Handle the receipt of an NFT
195    * @dev The ERC721 smart contract calls this function on the recipient
196    *  after a `safetransfer`. This function MAY throw to revert and reject the
197    *  transfer. This function MUST use 50,000 gas or less. Return of other
198    *  than the magic value MUST result in the transaction being reverted.
199    *  Note: the contract address is always the message sender.
200    * @param _from The sending address
201    * @param _tokenId The NFT identifier which is being transfered
202    * @param _data Additional data with no specified format
203    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
204    */
205   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
206 }
207 
208 
209 
210 
211 /**
212  * @title SafeMath
213  * @dev Math operations with safety checks that throw on error
214  */
215 library SafeMath {
216 
217   /**
218   * @dev Multiplies two numbers, throws on overflow.
219   */
220   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
221     if (a == 0) {
222       return 0;
223     }
224     c = a * b;
225     assert(c / a == b);
226     return c;
227   }
228 
229   /**
230   * @dev Integer division of two numbers, truncating the quotient.
231   */
232   function div(uint256 a, uint256 b) internal pure returns (uint256) {
233     // assert(b > 0); // Solidity automatically throws when dividing by 0
234     // uint256 c = a / b;
235     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
236     return a / b;
237   }
238 
239   /**
240   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
241   */
242   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
243     assert(b <= a);
244     return a - b;
245   }
246 
247   /**
248   * @dev Adds two numbers, throws on overflow.
249   */
250   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
251     c = a + b;
252     assert(c >= a);
253     return c;
254   }
255 }
256 
257 
258 
259 
260 /**
261  * Utility library of inline functions on addresses
262  */
263 library AddressUtils {
264 
265   /**
266    * Returns whether the target address is a contract
267    * @dev This function will return false if invoked during the constructor of a contract,
268    *  as the code is not actually created until after the constructor finishes.
269    * @param addr address to check
270    * @return whether the target address is a contract
271    */
272   function isContract(address addr) internal view returns (bool) {
273     uint256 size;
274     // XXX Currently there is no better way to check if there is a contract in an address
275     // than to check the size of the code at that address.
276     // See https://ethereum.stackexchange.com/a/14016/36603
277     // for more details about how this works.
278     // TODO Check this again before the Serenity release, because all addresses will be
279     // contracts then.
280     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
281     return size > 0;
282   }
283 
284 }
285 
286 
287 
288 /**
289  * @title ERC721 Non-Fungible Token Standard basic implementation
290  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
291  */
292 contract ERC721BasicToken is ERC721Basic {
293   using SafeMath for uint256;
294   using AddressUtils for address;
295 
296   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
297   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
298   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
299 
300   // Mapping from token ID to owner
301   mapping (uint256 => address) internal tokenOwner;
302 
303   // Mapping from token ID to approved address
304   mapping (uint256 => address) internal tokenApprovals;
305 
306   // Mapping from owner to number of owned token
307   mapping (address => uint256) internal ownedTokensCount;
308 
309   // Mapping from owner to operator approvals
310   mapping (address => mapping (address => bool)) internal operatorApprovals;
311 
312   /**
313    * @dev Guarantees msg.sender is owner of the given token
314    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
315    */
316   modifier onlyOwnerOf(uint256 _tokenId) {
317     require(ownerOf(_tokenId) == msg.sender);
318     _;
319   }
320 
321   /**
322    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
323    * @param _tokenId uint256 ID of the token to validate
324    */
325   modifier canTransfer(uint256 _tokenId) {
326     require(isApprovedOrOwner(msg.sender, _tokenId));
327     _;
328   }
329 
330   /**
331    * @dev Gets the balance of the specified address
332    * @param _owner address to query the balance of
333    * @return uint256 representing the amount owned by the passed address
334    */
335   function balanceOf(address _owner) public view returns (uint256) {
336     require(_owner != address(0));
337     return ownedTokensCount[_owner];
338   }
339 
340   /**
341    * @dev Gets the owner of the specified token ID
342    * @param _tokenId uint256 ID of the token to query the owner of
343    * @return owner address currently marked as the owner of the given token ID
344    */
345   function ownerOf(uint256 _tokenId) public view returns (address) {
346     address owner = tokenOwner[_tokenId];
347     require(owner != address(0));
348     return owner;
349   }
350 
351   /**
352    * @dev Returns whether the specified token exists
353    * @param _tokenId uint256 ID of the token to query the existance of
354    * @return whether the token exists
355    */
356   function exists(uint256 _tokenId) public view returns (bool) {
357     address owner = tokenOwner[_tokenId];
358     return owner != address(0);
359   }
360 
361   /**
362    * @dev Approves another address to transfer the given token ID
363    * @dev The zero address indicates there is no approved address.
364    * @dev There can only be one approved address per token at a given time.
365    * @dev Can only be called by the token owner or an approved operator.
366    * @param _to address to be approved for the given token ID
367    * @param _tokenId uint256 ID of the token to be approved
368    */
369   function approve(address _to, uint256 _tokenId) public {
370     address owner = ownerOf(_tokenId);
371     require(_to != owner);
372     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
373 
374     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
375       tokenApprovals[_tokenId] = _to;
376       emit Approval(owner, _to, _tokenId);
377     }
378   }
379 
380   /**
381    * @dev Gets the approved address for a token ID, or zero if no address set
382    * @param _tokenId uint256 ID of the token to query the approval of
383    * @return address currently approved for a the given token ID
384    */
385   function getApproved(uint256 _tokenId) public view returns (address) {
386     return tokenApprovals[_tokenId];
387   }
388 
389   /**
390    * @dev Sets or unsets the approval of a given operator
391    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
392    * @param _to operator address to set the approval
393    * @param _approved representing the status of the approval to be set
394    */
395   function setApprovalForAll(address _to, bool _approved) public {
396     require(_to != msg.sender);
397     operatorApprovals[msg.sender][_to] = _approved;
398     emit ApprovalForAll(msg.sender, _to, _approved);
399   }
400 
401   /**
402    * @dev Tells whether an operator is approved by a given owner
403    * @param _owner owner address which you want to query the approval of
404    * @param _operator operator address which you want to query the approval of
405    * @return bool whether the given operator is approved by the given owner
406    */
407   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
408     return operatorApprovals[_owner][_operator];
409   }
410 
411   /**
412    * @dev Transfers the ownership of a given token ID to another address
413    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
414    * @dev Requires the msg sender to be the owner, approved, or operator
415    * @param _from current owner of the token
416    * @param _to address to receive the ownership of the given token ID
417    * @param _tokenId uint256 ID of the token to be transferred
418   */
419   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
420     require(_from != address(0));
421     require(_to != address(0));
422 
423     clearApproval(_from, _tokenId);
424     removeTokenFrom(_from, _tokenId);
425     addTokenTo(_to, _tokenId);
426 
427     emit Transfer(_from, _to, _tokenId);
428   }
429 
430   /**
431    * @dev Safely transfers the ownership of a given token ID to another address
432    * @dev If the target address is a contract, it must implement `onERC721Received`,
433    *  which is called upon a safe transfer, and return the magic value
434    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
435    *  the transfer is reverted.
436    * @dev Requires the msg sender to be the owner, approved, or operator
437    * @param _from current owner of the token
438    * @param _to address to receive the ownership of the given token ID
439    * @param _tokenId uint256 ID of the token to be transferred
440   */
441   function safeTransferFrom(
442     address _from,
443     address _to,
444     uint256 _tokenId
445   )
446     public
447     canTransfer(_tokenId)
448   {
449     // solium-disable-next-line arg-overflow
450     safeTransferFrom(_from, _to, _tokenId, "");
451   }
452 
453   /**
454    * @dev Safely transfers the ownership of a given token ID to another address
455    * @dev If the target address is a contract, it must implement `onERC721Received`,
456    *  which is called upon a safe transfer, and return the magic value
457    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
458    *  the transfer is reverted.
459    * @dev Requires the msg sender to be the owner, approved, or operator
460    * @param _from current owner of the token
461    * @param _to address to receive the ownership of the given token ID
462    * @param _tokenId uint256 ID of the token to be transferred
463    * @param _data bytes data to send along with a safe transfer check
464    */
465   function safeTransferFrom(
466     address _from,
467     address _to,
468     uint256 _tokenId,
469     bytes _data
470   )
471     public
472     canTransfer(_tokenId)
473   {
474     transferFrom(_from, _to, _tokenId);
475     // solium-disable-next-line arg-overflow
476     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
477   }
478 
479   /**
480    * @dev Returns whether the given spender can transfer a given token ID
481    * @param _spender address of the spender to query
482    * @param _tokenId uint256 ID of the token to be transferred
483    * @return bool whether the msg.sender is approved for the given token ID,
484    *  is an operator of the owner, or is the owner of the token
485    */
486   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
487     address owner = ownerOf(_tokenId);
488     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
489   }
490 
491   /**
492    * @dev Internal function to mint a new token
493    * @dev Reverts if the given token ID already exists
494    * @param _to The address that will own the minted token
495    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
496    */
497   function _mint(address _to, uint256 _tokenId) internal {
498     require(_to != address(0));
499     addTokenTo(_to, _tokenId);
500     emit Transfer(address(0), _to, _tokenId);
501   }
502 
503   /**
504    * @dev Internal function to burn a specific token
505    * @dev Reverts if the token does not exist
506    * @param _tokenId uint256 ID of the token being burned by the msg.sender
507    */
508   function _burn(address _owner, uint256 _tokenId) internal {
509     clearApproval(_owner, _tokenId);
510     removeTokenFrom(_owner, _tokenId);
511     emit Transfer(_owner, address(0), _tokenId);
512   }
513 
514   /**
515    * @dev Internal function to clear current approval of a given token ID
516    * @dev Reverts if the given address is not indeed the owner of the token
517    * @param _owner owner of the token
518    * @param _tokenId uint256 ID of the token to be transferred
519    */
520   function clearApproval(address _owner, uint256 _tokenId) internal {
521     require(ownerOf(_tokenId) == _owner);
522     if (tokenApprovals[_tokenId] != address(0)) {
523       tokenApprovals[_tokenId] = address(0);
524       emit Approval(_owner, address(0), _tokenId);
525     }
526   }
527 
528   /**
529    * @dev Internal function to add a token ID to the list of a given address
530    * @param _to address representing the new owner of the given token ID
531    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
532    */
533   function addTokenTo(address _to, uint256 _tokenId) internal {
534     require(tokenOwner[_tokenId] == address(0));
535     tokenOwner[_tokenId] = _to;
536     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
537   }
538 
539   /**
540    * @dev Internal function to remove a token ID from the list of a given address
541    * @param _from address representing the previous owner of the given token ID
542    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
543    */
544   function removeTokenFrom(address _from, uint256 _tokenId) internal {
545     require(ownerOf(_tokenId) == _from);
546     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
547     tokenOwner[_tokenId] = address(0);
548   }
549 
550   /**
551    * @dev Internal function to invoke `onERC721Received` on a target address
552    * @dev The call is not executed if the target address is not a contract
553    * @param _from address representing the previous owner of the given token ID
554    * @param _to target address that will receive the tokens
555    * @param _tokenId uint256 ID of the token to be transferred
556    * @param _data bytes optional data to send along with the call
557    * @return whether the call correctly returned the expected magic value
558    */
559   function checkAndCallSafeTransfer(
560     address _from,
561     address _to,
562     uint256 _tokenId,
563     bytes _data
564   )
565     internal
566     returns (bool)
567   {
568     if (!_to.isContract()) {
569       return true;
570     }
571     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
572     return (retval == ERC721_RECEIVED);
573   }
574 }
575 
576 
577 
578 /**
579  * @title Full ERC721 Token
580  * This implementation includes all the required and some optional functionality of the ERC721 standard
581  * Moreover, it includes approve all functionality using operator terminology
582  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
583  */
584 contract ERC721Token is ERC721, ERC721BasicToken {
585   // Token name
586   string internal name_;
587 
588   // Token symbol
589   string internal symbol_;
590 
591   // Mapping from owner to list of owned token IDs
592   mapping (address => uint256[]) internal ownedTokens;
593 
594   // Mapping from token ID to index of the owner tokens list
595   mapping(uint256 => uint256) internal ownedTokensIndex;
596 
597   // Array with all token ids, used for enumeration
598   uint256[] internal allTokens;
599 
600   // Mapping from token id to position in the allTokens array
601   mapping(uint256 => uint256) internal allTokensIndex;
602 
603   // Optional mapping for token URIs
604   mapping(uint256 => string) internal tokenURIs;
605 
606   /**
607    * @dev Constructor function
608    */
609   function ERC721Token(string _name, string _symbol) public {
610     name_ = _name;
611     symbol_ = _symbol;
612   }
613 
614   /**
615    * @dev Gets the token name
616    * @return string representing the token name
617    */
618   function name() public view returns (string) {
619     return name_;
620   }
621 
622   /**
623    * @dev Gets the token symbol
624    * @return string representing the token symbol
625    */
626   function symbol() public view returns (string) {
627     return symbol_;
628   }
629 
630   /**
631    * @dev Returns an URI for a given token ID
632    * @dev Throws if the token ID does not exist. May return an empty string.
633    * @param _tokenId uint256 ID of the token to query
634    */
635   function tokenURI(uint256 _tokenId) public view returns (string) {
636     require(exists(_tokenId));
637     return tokenURIs[_tokenId];
638   }
639 
640   /**
641    * @dev Gets the token ID at a given index of the tokens list of the requested owner
642    * @param _owner address owning the tokens list to be accessed
643    * @param _index uint256 representing the index to be accessed of the requested tokens list
644    * @return uint256 token ID at the given index of the tokens list owned by the requested address
645    */
646   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
647     require(_index < balanceOf(_owner));
648     return ownedTokens[_owner][_index];
649   }
650 
651   /**
652    * @dev Gets the total amount of tokens stored by the contract
653    * @return uint256 representing the total amount of tokens
654    */
655   function totalSupply() public view returns (uint256) {
656     return allTokens.length;
657   }
658 
659   /**
660    * @dev Gets the token ID at a given index of all the tokens in this contract
661    * @dev Reverts if the index is greater or equal to the total number of tokens
662    * @param _index uint256 representing the index to be accessed of the tokens list
663    * @return uint256 token ID at the given index of the tokens list
664    */
665   function tokenByIndex(uint256 _index) public view returns (uint256) {
666     require(_index < totalSupply());
667     return allTokens[_index];
668   }
669 
670   /**
671    * @dev Internal function to set the token URI for a given token
672    * @dev Reverts if the token ID does not exist
673    * @param _tokenId uint256 ID of the token to set its URI
674    * @param _uri string URI to assign
675    */
676   function _setTokenURI(uint256 _tokenId, string _uri) internal {
677     require(exists(_tokenId));
678     tokenURIs[_tokenId] = _uri;
679   }
680 
681   /**
682    * @dev Internal function to add a token ID to the list of a given address
683    * @param _to address representing the new owner of the given token ID
684    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
685    */
686   function addTokenTo(address _to, uint256 _tokenId) internal {
687     super.addTokenTo(_to, _tokenId);
688     uint256 length = ownedTokens[_to].length;
689     ownedTokens[_to].push(_tokenId);
690     ownedTokensIndex[_tokenId] = length;
691   }
692 
693   /**
694    * @dev Internal function to remove a token ID from the list of a given address
695    * @param _from address representing the previous owner of the given token ID
696    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
697    */
698   function removeTokenFrom(address _from, uint256 _tokenId) internal {
699     super.removeTokenFrom(_from, _tokenId);
700 
701     uint256 tokenIndex = ownedTokensIndex[_tokenId];
702     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
703     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
704 
705     ownedTokens[_from][tokenIndex] = lastToken;
706     ownedTokens[_from][lastTokenIndex] = 0;
707     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
708     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
709     // the lastToken to the first position, and then dropping the element placed in the last position of the list
710 
711     ownedTokens[_from].length--;
712     ownedTokensIndex[_tokenId] = 0;
713     ownedTokensIndex[lastToken] = tokenIndex;
714   }
715 
716   /**
717    * @dev Internal function to mint a new token
718    * @dev Reverts if the given token ID already exists
719    * @param _to address the beneficiary that will own the minted token
720    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
721    */
722   function _mint(address _to, uint256 _tokenId) internal {
723     super._mint(_to, _tokenId);
724 
725     allTokensIndex[_tokenId] = allTokens.length;
726     allTokens.push(_tokenId);
727   }
728 
729   /**
730    * @dev Internal function to burn a specific token
731    * @dev Reverts if the token does not exist
732    * @param _owner owner of the token to burn
733    * @param _tokenId uint256 ID of the token being burned by the msg.sender
734    */
735   function _burn(address _owner, uint256 _tokenId) internal {
736     super._burn(_owner, _tokenId);
737 
738     // Clear metadata (if any)
739     if (bytes(tokenURIs[_tokenId]).length != 0) {
740       delete tokenURIs[_tokenId];
741     }
742 
743     // Reorg all tokens array
744     uint256 tokenIndex = allTokensIndex[_tokenId];
745     uint256 lastTokenIndex = allTokens.length.sub(1);
746     uint256 lastToken = allTokens[lastTokenIndex];
747 
748     allTokens[tokenIndex] = lastToken;
749     allTokens[lastTokenIndex] = 0;
750 
751     allTokens.length--;
752     allTokensIndex[_tokenId] = 0;
753     allTokensIndex[lastToken] = tokenIndex;
754   }
755 
756 }
757 
758 
759 
760 
761 
762 
763 
764 /// @title The contract that manages all the players that appear in our game.
765 /// @author The CryptoStrikers Team
766 contract StrikersPlayerList is Ownable {
767   // We only use playerIds in StrikersChecklist.sol (to
768   // indicate which player features on instances of a
769   // given ChecklistItem), and nowhere else in the app.
770   // While it's not explictly necessary for any of our
771   // contracts to know that playerId 0 corresponds to
772   // Lionel Messi, we think that it's nice to have
773   // a canonical source of truth for who the playerIds
774   // actually refer to. Storing strings (player names)
775   // is expensive, so we just use Events to prove that,
776   // at some point, we said a playerId represents a given person.
777 
778   /// @dev The event we fire when we add a player.
779   event PlayerAdded(uint8 indexed id, string name);
780 
781   /// @dev How many players we've added so far
782   ///   (max 255, though we don't plan on getting close)
783   uint8 public playerCount;
784 
785   /// @dev Here we add the players we are launching with on Day 1.
786   ///   Players are loosely ranked by things like FIFA ratings,
787   ///   number of Instagram followers, and opinions of CryptoStrikers
788   ///   team members. Feel free to yell at us on Twitter.
789   constructor() public {
790     addPlayer("Lionel Messi"); // 0
791     addPlayer("Cristiano Ronaldo"); // 1
792     addPlayer("Neymar"); // 2
793     addPlayer("Mohamed Salah"); // 3
794     addPlayer("Robert Lewandowski"); // 4
795     addPlayer("Kevin De Bruyne"); // 5
796     addPlayer("Luka Modrić"); // 6
797     addPlayer("Eden Hazard"); // 7
798     addPlayer("Sergio Ramos"); // 8
799     addPlayer("Toni Kroos"); // 9
800     addPlayer("Luis Suárez"); // 10
801     addPlayer("Harry Kane"); // 11
802     addPlayer("Sergio Agüero"); // 12
803     addPlayer("Kylian Mbappé"); // 13
804     addPlayer("Gonzalo Higuaín"); // 14
805     addPlayer("David de Gea"); // 15
806     addPlayer("Antoine Griezmann"); // 16
807     addPlayer("N'Golo Kanté"); // 17
808     addPlayer("Edinson Cavani"); // 18
809     addPlayer("Paul Pogba"); // 19
810     addPlayer("Isco"); // 20
811     addPlayer("Marcelo"); // 21
812     addPlayer("Manuel Neuer"); // 22
813     addPlayer("Dries Mertens"); // 23
814     addPlayer("James Rodríguez"); // 24
815     addPlayer("Paulo Dybala"); // 25
816     addPlayer("Christian Eriksen"); // 26
817     addPlayer("David Silva"); // 27
818     addPlayer("Gabriel Jesus"); // 28
819     addPlayer("Thiago"); // 29
820     addPlayer("Thibaut Courtois"); // 30
821     addPlayer("Philippe Coutinho"); // 31
822     addPlayer("Andrés Iniesta"); // 32
823     addPlayer("Casemiro"); // 33
824     addPlayer("Romelu Lukaku"); // 34
825     addPlayer("Gerard Piqué"); // 35
826     addPlayer("Mats Hummels"); // 36
827     addPlayer("Diego Godín"); // 37
828     addPlayer("Mesut Özil"); // 38
829     addPlayer("Son Heung-min"); // 39
830     addPlayer("Raheem Sterling"); // 40
831     addPlayer("Hugo Lloris"); // 41
832     addPlayer("Radamel Falcao"); // 42
833     addPlayer("Ivan Rakitić"); // 43
834     addPlayer("Leroy Sané"); // 44
835     addPlayer("Roberto Firmino"); // 45
836     addPlayer("Sadio Mané"); // 46
837     addPlayer("Thomas Müller"); // 47
838     addPlayer("Dele Alli"); // 48
839     addPlayer("Keylor Navas"); // 49
840     addPlayer("Thiago Silva"); // 50
841     addPlayer("Raphaël Varane"); // 51
842     addPlayer("Ángel Di María"); // 52
843     addPlayer("Jordi Alba"); // 53
844     addPlayer("Medhi Benatia"); // 54
845     addPlayer("Timo Werner"); // 55
846     addPlayer("Gylfi Sigurðsson"); // 56
847     addPlayer("Nemanja Matić"); // 57
848     addPlayer("Kalidou Koulibaly"); // 58
849     addPlayer("Bernardo Silva"); // 59
850     addPlayer("Vincent Kompany"); // 60
851     addPlayer("João Moutinho"); // 61
852     addPlayer("Toby Alderweireld"); // 62
853     addPlayer("Emil Forsberg"); // 63
854     addPlayer("Mario Mandžukić"); // 64
855     addPlayer("Sergej Milinković-Savić"); // 65
856     addPlayer("Shinji Kagawa"); // 66
857     addPlayer("Granit Xhaka"); // 67
858     addPlayer("Andreas Christensen"); // 68
859     addPlayer("Piotr Zieliński"); // 69
860     addPlayer("Fyodor Smolov"); // 70
861     addPlayer("Xherdan Shaqiri"); // 71
862     addPlayer("Marcus Rashford"); // 72
863     addPlayer("Javier Hernández"); // 73
864     addPlayer("Hirving Lozano"); // 74
865     addPlayer("Hakim Ziyech"); // 75
866     addPlayer("Victor Moses"); // 76
867     addPlayer("Jefferson Farfán"); // 77
868     addPlayer("Mohamed Elneny"); // 78
869     addPlayer("Marcus Berg"); // 79
870     addPlayer("Guillermo Ochoa"); // 80
871     addPlayer("Igor Akinfeev"); // 81
872     addPlayer("Sardar Azmoun"); // 82
873     addPlayer("Christian Cueva"); // 83
874     addPlayer("Wahbi Khazri"); // 84
875     addPlayer("Keisuke Honda"); // 85
876     addPlayer("Tim Cahill"); // 86
877     addPlayer("John Obi Mikel"); // 87
878     addPlayer("Ki Sung-yueng"); // 88
879     addPlayer("Bryan Ruiz"); // 89
880     addPlayer("Maya Yoshida"); // 90
881     addPlayer("Nawaf Al Abed"); // 91
882     addPlayer("Lee Chung-yong"); // 92
883     addPlayer("Gabriel Gómez"); // 93
884     addPlayer("Naïm Sliti"); // 94
885     addPlayer("Reza Ghoochannejhad"); // 95
886     addPlayer("Mile Jedinak"); // 96
887     addPlayer("Mohammad Al-Sahlawi"); // 97
888     addPlayer("Aron Gunnarsson"); // 98
889     addPlayer("Blas Pérez"); // 99
890     addPlayer("Dani Alves"); // 100
891     addPlayer("Zlatan Ibrahimović"); // 101
892   }
893 
894   /// @dev Fires an event, proving that we said a player corresponds to a given ID.
895   /// @param _name The name of the player we are adding.
896   function addPlayer(string _name) public onlyOwner {
897     require(playerCount < 255, "You've already added the maximum amount of players.");
898     emit PlayerAdded(playerCount, _name);
899     playerCount++;
900   }
901 }
902 
903 
904 /// @title The contract that manages checklist items, sets, and rarity tiers.
905 /// @author The CryptoStrikers Team
906 contract StrikersChecklist is StrikersPlayerList {
907   // High level overview of everything going on in this contract:
908   //
909   // ChecklistItem is the parent class to Card and has 3 properties:
910   //  - uint8 checklistId (000 to 255)
911   //  - uint8 playerId (see StrikersPlayerList.sol)
912   //  - RarityTier tier (more info below)
913   //
914   // Two things to note: the checklistId is not explicitly stored
915   // on the checklistItem struct, and it's composed of two parts.
916   // (For the following, assume it is left padded with zeros to reach
917   // three digits, such that checklistId 0 becomes 000)
918   //  - the first digit represents the setId
919   //      * 0 = Originals Set
920   //      * 1 = Iconics Set
921   //      * 2 = Unreleased Set
922   //  - the last two digits represent its index in the appropriate set arary
923   //
924   //  For example, checklist ID 100 would represent fhe first checklist item
925   //  in the iconicChecklistItems array (first digit = 1 = Iconics Set, last two
926   //  digits = 00 = first index of array)
927   //
928   // Because checklistId is represented as a uint8 throughout the app, the highest
929   // value it can take is 255, which means we can't add more than 56 items to our
930   // Unreleased Set's unreleasedChecklistItems array (setId 2). Also, once we've initialized
931   // this contract, it's impossible for us to add more checklist items to the Originals
932   // and Iconics set -- what you see here is what you get.
933   //
934   // Simple enough right?
935 
936   /// @dev We initialize this contract with so much data that we have
937   ///   to stage it in 4 different steps, ~33 checklist items at a time.
938   enum DeployStep {
939     WaitingForStepOne,
940     WaitingForStepTwo,
941     WaitingForStepThree,
942     WaitingForStepFour,
943     DoneInitialDeploy
944   }
945 
946   /// @dev Enum containing all our rarity tiers, just because
947   ///   it's cleaner dealing with these values than with uint8s.
948   enum RarityTier {
949     IconicReferral,
950     IconicInsert,
951     Diamond,
952     Gold,
953     Silver,
954     Bronze
955   }
956 
957   /// @dev A lookup table indicating how limited the cards
958   ///   in each tier are. If this value is 0, it means
959   ///   that cards of this rarity tier are unlimited,
960   ///   which is only the case for the 8 Iconics cards
961   ///   we give away as part of our referral program.
962   uint16[] public tierLimits = [
963     0,    // Iconic - Referral Bonus (uncapped)
964     100,  // Iconic Inserts ("Card of the Day")
965     1000, // Diamond
966     1664, // Gold
967     3328, // Silver
968     4352  // Bronze
969   ];
970 
971   /// @dev ChecklistItem is essentially the parent class to Card.
972   ///   It represents a given superclass of cards (eg Originals Messi),
973   ///   and then each Card is an instance of this ChecklistItem, with
974   ///   its own serial number, mint date, etc.
975   struct ChecklistItem {
976     uint8 playerId;
977     RarityTier tier;
978   }
979 
980   /// @dev The deploy step we're at. Defaults to WaitingForStepOne.
981   DeployStep public deployStep;
982 
983   /// @dev Array containing all the Originals checklist items (000 - 099)
984   ChecklistItem[] public originalChecklistItems;
985 
986   /// @dev Array containing all the Iconics checklist items (100 - 131)
987   ChecklistItem[] public iconicChecklistItems;
988 
989   /// @dev Array containing all the unreleased checklist items (200 - 255 max)
990   ChecklistItem[] public unreleasedChecklistItems;
991 
992   /// @dev Internal function to add a checklist item to the Originals set.
993   /// @param _playerId The player represented by this checklist item. (see StrikersPlayerList.sol)
994   /// @param _tier This checklist item's rarity tier. (see Rarity Tier enum and corresponding tierLimits)
995   function _addOriginalChecklistItem(uint8 _playerId, RarityTier _tier) internal {
996     originalChecklistItems.push(ChecklistItem({
997       playerId: _playerId,
998       tier: _tier
999     }));
1000   }
1001 
1002   /// @dev Internal function to add a checklist item to the Iconics set.
1003   /// @param _playerId The player represented by this checklist item. (see StrikersPlayerList.sol)
1004   /// @param _tier This checklist item's rarity tier. (see Rarity Tier enum and corresponding tierLimits)
1005   function _addIconicChecklistItem(uint8 _playerId, RarityTier _tier) internal {
1006     iconicChecklistItems.push(ChecklistItem({
1007       playerId: _playerId,
1008       tier: _tier
1009     }));
1010   }
1011 
1012   /// @dev External function to add a checklist item to our mystery set.
1013   ///   Must have completed initial deploy, and can't add more than 56 items (because checklistId is a uint8).
1014   /// @param _playerId The player represented by this checklist item. (see StrikersPlayerList.sol)
1015   /// @param _tier This checklist item's rarity tier. (see Rarity Tier enum and corresponding tierLimits)
1016   function addUnreleasedChecklistItem(uint8 _playerId, RarityTier _tier) external onlyOwner {
1017     require(deployStep == DeployStep.DoneInitialDeploy, "Finish deploying the Originals and Iconics sets first.");
1018     require(unreleasedCount() < 56, "You can't add any more checklist items.");
1019     require(_playerId < playerCount, "This player doesn't exist in our player list.");
1020     unreleasedChecklistItems.push(ChecklistItem({
1021       playerId: _playerId,
1022       tier: _tier
1023     }));
1024   }
1025 
1026   /// @dev Returns how many Original checklist items we've added.
1027   function originalsCount() external view returns (uint256) {
1028     return originalChecklistItems.length;
1029   }
1030 
1031   /// @dev Returns how many Iconic checklist items we've added.
1032   function iconicsCount() public view returns (uint256) {
1033     return iconicChecklistItems.length;
1034   }
1035 
1036   /// @dev Returns how many Unreleased checklist items we've added.
1037   function unreleasedCount() public view returns (uint256) {
1038     return unreleasedChecklistItems.length;
1039   }
1040 
1041   // In the next four functions, we initialize this contract with our
1042   // 132 initial checklist items (100 Originals, 32 Iconics). Because
1043   // of how much data we need to store, it has to be broken up into
1044   // four different function calls, which need to be called in sequence.
1045   // The ordering of the checklist items we add determines their
1046   // checklist ID, which is left-padded in our frontend to be a
1047   // 3-digit identifier where the first digit is the setId and the last
1048   // 2 digits represents the checklist items index in the appropriate ___ChecklistItems array.
1049   // For example, Originals Messi is the first item for set ID 0, and this
1050   // is displayed as #000 throughout the app. Our Card struct declare its
1051   // checklistId property as uint8, so we have
1052   // to be mindful that we can only have 256 total checklist items.
1053 
1054   /// @dev Deploys Originals #000 through #032.
1055   function deployStepOne() external onlyOwner {
1056     require(deployStep == DeployStep.WaitingForStepOne, "You're not following the steps in order...");
1057 
1058     /* ORIGINALS - DIAMOND */
1059     _addOriginalChecklistItem(0, RarityTier.Diamond); // 000 Messi
1060     _addOriginalChecklistItem(1, RarityTier.Diamond); // 001 Ronaldo
1061     _addOriginalChecklistItem(2, RarityTier.Diamond); // 002 Neymar
1062     _addOriginalChecklistItem(3, RarityTier.Diamond); // 003 Salah
1063 
1064     /* ORIGINALS - GOLD */
1065     _addOriginalChecklistItem(4, RarityTier.Gold); // 004 Lewandowski
1066     _addOriginalChecklistItem(5, RarityTier.Gold); // 005 De Bruyne
1067     _addOriginalChecklistItem(6, RarityTier.Gold); // 006 Modrić
1068     _addOriginalChecklistItem(7, RarityTier.Gold); // 007 Hazard
1069     _addOriginalChecklistItem(8, RarityTier.Gold); // 008 Ramos
1070     _addOriginalChecklistItem(9, RarityTier.Gold); // 009 Kroos
1071     _addOriginalChecklistItem(10, RarityTier.Gold); // 010 Suárez
1072     _addOriginalChecklistItem(11, RarityTier.Gold); // 011 Kane
1073     _addOriginalChecklistItem(12, RarityTier.Gold); // 012 Agüero
1074     _addOriginalChecklistItem(13, RarityTier.Gold); // 013 Mbappé
1075     _addOriginalChecklistItem(14, RarityTier.Gold); // 014 Higuaín
1076     _addOriginalChecklistItem(15, RarityTier.Gold); // 015 de Gea
1077     _addOriginalChecklistItem(16, RarityTier.Gold); // 016 Griezmann
1078     _addOriginalChecklistItem(17, RarityTier.Gold); // 017 Kanté
1079     _addOriginalChecklistItem(18, RarityTier.Gold); // 018 Cavani
1080     _addOriginalChecklistItem(19, RarityTier.Gold); // 019 Pogba
1081 
1082     /* ORIGINALS - SILVER (020 to 032) */
1083     _addOriginalChecklistItem(20, RarityTier.Silver); // 020 Isco
1084     _addOriginalChecklistItem(21, RarityTier.Silver); // 021 Marcelo
1085     _addOriginalChecklistItem(22, RarityTier.Silver); // 022 Neuer
1086     _addOriginalChecklistItem(23, RarityTier.Silver); // 023 Mertens
1087     _addOriginalChecklistItem(24, RarityTier.Silver); // 024 James
1088     _addOriginalChecklistItem(25, RarityTier.Silver); // 025 Dybala
1089     _addOriginalChecklistItem(26, RarityTier.Silver); // 026 Eriksen
1090     _addOriginalChecklistItem(27, RarityTier.Silver); // 027 David Silva
1091     _addOriginalChecklistItem(28, RarityTier.Silver); // 028 Gabriel Jesus
1092     _addOriginalChecklistItem(29, RarityTier.Silver); // 029 Thiago
1093     _addOriginalChecklistItem(30, RarityTier.Silver); // 030 Courtois
1094     _addOriginalChecklistItem(31, RarityTier.Silver); // 031 Coutinho
1095     _addOriginalChecklistItem(32, RarityTier.Silver); // 032 Iniesta
1096 
1097     // Move to the next deploy step.
1098     deployStep = DeployStep.WaitingForStepTwo;
1099   }
1100 
1101   /// @dev Deploys Originals #033 through #065.
1102   function deployStepTwo() external onlyOwner {
1103     require(deployStep == DeployStep.WaitingForStepTwo, "You're not following the steps in order...");
1104 
1105     /* ORIGINALS - SILVER (033 to 049) */
1106     _addOriginalChecklistItem(33, RarityTier.Silver); // 033 Casemiro
1107     _addOriginalChecklistItem(34, RarityTier.Silver); // 034 Lukaku
1108     _addOriginalChecklistItem(35, RarityTier.Silver); // 035 Piqué
1109     _addOriginalChecklistItem(36, RarityTier.Silver); // 036 Hummels
1110     _addOriginalChecklistItem(37, RarityTier.Silver); // 037 Godín
1111     _addOriginalChecklistItem(38, RarityTier.Silver); // 038 Özil
1112     _addOriginalChecklistItem(39, RarityTier.Silver); // 039 Son
1113     _addOriginalChecklistItem(40, RarityTier.Silver); // 040 Sterling
1114     _addOriginalChecklistItem(41, RarityTier.Silver); // 041 Lloris
1115     _addOriginalChecklistItem(42, RarityTier.Silver); // 042 Falcao
1116     _addOriginalChecklistItem(43, RarityTier.Silver); // 043 Rakitić
1117     _addOriginalChecklistItem(44, RarityTier.Silver); // 044 Sané
1118     _addOriginalChecklistItem(45, RarityTier.Silver); // 045 Firmino
1119     _addOriginalChecklistItem(46, RarityTier.Silver); // 046 Mané
1120     _addOriginalChecklistItem(47, RarityTier.Silver); // 047 Müller
1121     _addOriginalChecklistItem(48, RarityTier.Silver); // 048 Alli
1122     _addOriginalChecklistItem(49, RarityTier.Silver); // 049 Navas
1123 
1124     /* ORIGINALS - BRONZE (050 to 065) */
1125     _addOriginalChecklistItem(50, RarityTier.Bronze); // 050 Thiago Silva
1126     _addOriginalChecklistItem(51, RarityTier.Bronze); // 051 Varane
1127     _addOriginalChecklistItem(52, RarityTier.Bronze); // 052 Di María
1128     _addOriginalChecklistItem(53, RarityTier.Bronze); // 053 Alba
1129     _addOriginalChecklistItem(54, RarityTier.Bronze); // 054 Benatia
1130     _addOriginalChecklistItem(55, RarityTier.Bronze); // 055 Werner
1131     _addOriginalChecklistItem(56, RarityTier.Bronze); // 056 Sigurðsson
1132     _addOriginalChecklistItem(57, RarityTier.Bronze); // 057 Matić
1133     _addOriginalChecklistItem(58, RarityTier.Bronze); // 058 Koulibaly
1134     _addOriginalChecklistItem(59, RarityTier.Bronze); // 059 Bernardo Silva
1135     _addOriginalChecklistItem(60, RarityTier.Bronze); // 060 Kompany
1136     _addOriginalChecklistItem(61, RarityTier.Bronze); // 061 Moutinho
1137     _addOriginalChecklistItem(62, RarityTier.Bronze); // 062 Alderweireld
1138     _addOriginalChecklistItem(63, RarityTier.Bronze); // 063 Forsberg
1139     _addOriginalChecklistItem(64, RarityTier.Bronze); // 064 Mandžukić
1140     _addOriginalChecklistItem(65, RarityTier.Bronze); // 065 Milinković-Savić
1141 
1142     // Move to the next deploy step.
1143     deployStep = DeployStep.WaitingForStepThree;
1144   }
1145 
1146   /// @dev Deploys Originals #066 through #099.
1147   function deployStepThree() external onlyOwner {
1148     require(deployStep == DeployStep.WaitingForStepThree, "You're not following the steps in order...");
1149 
1150     /* ORIGINALS - BRONZE (066 to 099) */
1151     _addOriginalChecklistItem(66, RarityTier.Bronze); // 066 Kagawa
1152     _addOriginalChecklistItem(67, RarityTier.Bronze); // 067 Xhaka
1153     _addOriginalChecklistItem(68, RarityTier.Bronze); // 068 Christensen
1154     _addOriginalChecklistItem(69, RarityTier.Bronze); // 069 Zieliński
1155     _addOriginalChecklistItem(70, RarityTier.Bronze); // 070 Smolov
1156     _addOriginalChecklistItem(71, RarityTier.Bronze); // 071 Shaqiri
1157     _addOriginalChecklistItem(72, RarityTier.Bronze); // 072 Rashford
1158     _addOriginalChecklistItem(73, RarityTier.Bronze); // 073 Hernández
1159     _addOriginalChecklistItem(74, RarityTier.Bronze); // 074 Lozano
1160     _addOriginalChecklistItem(75, RarityTier.Bronze); // 075 Ziyech
1161     _addOriginalChecklistItem(76, RarityTier.Bronze); // 076 Moses
1162     _addOriginalChecklistItem(77, RarityTier.Bronze); // 077 Farfán
1163     _addOriginalChecklistItem(78, RarityTier.Bronze); // 078 Elneny
1164     _addOriginalChecklistItem(79, RarityTier.Bronze); // 079 Berg
1165     _addOriginalChecklistItem(80, RarityTier.Bronze); // 080 Ochoa
1166     _addOriginalChecklistItem(81, RarityTier.Bronze); // 081 Akinfeev
1167     _addOriginalChecklistItem(82, RarityTier.Bronze); // 082 Azmoun
1168     _addOriginalChecklistItem(83, RarityTier.Bronze); // 083 Cueva
1169     _addOriginalChecklistItem(84, RarityTier.Bronze); // 084 Khazri
1170     _addOriginalChecklistItem(85, RarityTier.Bronze); // 085 Honda
1171     _addOriginalChecklistItem(86, RarityTier.Bronze); // 086 Cahill
1172     _addOriginalChecklistItem(87, RarityTier.Bronze); // 087 Mikel
1173     _addOriginalChecklistItem(88, RarityTier.Bronze); // 088 Sung-yueng
1174     _addOriginalChecklistItem(89, RarityTier.Bronze); // 089 Ruiz
1175     _addOriginalChecklistItem(90, RarityTier.Bronze); // 090 Yoshida
1176     _addOriginalChecklistItem(91, RarityTier.Bronze); // 091 Al Abed
1177     _addOriginalChecklistItem(92, RarityTier.Bronze); // 092 Chung-yong
1178     _addOriginalChecklistItem(93, RarityTier.Bronze); // 093 Gómez
1179     _addOriginalChecklistItem(94, RarityTier.Bronze); // 094 Sliti
1180     _addOriginalChecklistItem(95, RarityTier.Bronze); // 095 Ghoochannejhad
1181     _addOriginalChecklistItem(96, RarityTier.Bronze); // 096 Jedinak
1182     _addOriginalChecklistItem(97, RarityTier.Bronze); // 097 Al-Sahlawi
1183     _addOriginalChecklistItem(98, RarityTier.Bronze); // 098 Gunnarsson
1184     _addOriginalChecklistItem(99, RarityTier.Bronze); // 099 Pérez
1185 
1186     // Move to the next deploy step.
1187     deployStep = DeployStep.WaitingForStepFour;
1188   }
1189 
1190   /// @dev Deploys all Iconics and marks the deploy as complete!
1191   function deployStepFour() external onlyOwner {
1192     require(deployStep == DeployStep.WaitingForStepFour, "You're not following the steps in order...");
1193 
1194     /* ICONICS */
1195     _addIconicChecklistItem(0, RarityTier.IconicInsert); // 100 Messi
1196     _addIconicChecklistItem(1, RarityTier.IconicInsert); // 101 Ronaldo
1197     _addIconicChecklistItem(2, RarityTier.IconicInsert); // 102 Neymar
1198     _addIconicChecklistItem(3, RarityTier.IconicInsert); // 103 Salah
1199     _addIconicChecklistItem(4, RarityTier.IconicInsert); // 104 Lewandowski
1200     _addIconicChecklistItem(5, RarityTier.IconicInsert); // 105 De Bruyne
1201     _addIconicChecklistItem(6, RarityTier.IconicInsert); // 106 Modrić
1202     _addIconicChecklistItem(7, RarityTier.IconicInsert); // 107 Hazard
1203     _addIconicChecklistItem(8, RarityTier.IconicInsert); // 108 Ramos
1204     _addIconicChecklistItem(9, RarityTier.IconicInsert); // 109 Kroos
1205     _addIconicChecklistItem(10, RarityTier.IconicInsert); // 110 Suárez
1206     _addIconicChecklistItem(11, RarityTier.IconicInsert); // 111 Kane
1207     _addIconicChecklistItem(12, RarityTier.IconicInsert); // 112 Agüero
1208     _addIconicChecklistItem(15, RarityTier.IconicInsert); // 113 de Gea
1209     _addIconicChecklistItem(16, RarityTier.IconicInsert); // 114 Griezmann
1210     _addIconicChecklistItem(17, RarityTier.IconicReferral); // 115 Kanté
1211     _addIconicChecklistItem(18, RarityTier.IconicReferral); // 116 Cavani
1212     _addIconicChecklistItem(19, RarityTier.IconicInsert); // 117 Pogba
1213     _addIconicChecklistItem(21, RarityTier.IconicInsert); // 118 Marcelo
1214     _addIconicChecklistItem(24, RarityTier.IconicInsert); // 119 James
1215     _addIconicChecklistItem(26, RarityTier.IconicInsert); // 120 Eriksen
1216     _addIconicChecklistItem(29, RarityTier.IconicReferral); // 121 Thiago
1217     _addIconicChecklistItem(36, RarityTier.IconicReferral); // 122 Hummels
1218     _addIconicChecklistItem(38, RarityTier.IconicReferral); // 123 Özil
1219     _addIconicChecklistItem(39, RarityTier.IconicInsert); // 124 Son
1220     _addIconicChecklistItem(46, RarityTier.IconicInsert); // 125 Mané
1221     _addIconicChecklistItem(48, RarityTier.IconicInsert); // 126 Alli
1222     _addIconicChecklistItem(49, RarityTier.IconicReferral); // 127 Navas
1223     _addIconicChecklistItem(73, RarityTier.IconicInsert); // 128 Hernández
1224     _addIconicChecklistItem(85, RarityTier.IconicInsert); // 129 Honda
1225     _addIconicChecklistItem(100, RarityTier.IconicReferral); // 130 Alves
1226     _addIconicChecklistItem(101, RarityTier.IconicReferral); // 131 Zlatan
1227 
1228     // Mark the initial deploy as complete.
1229     deployStep = DeployStep.DoneInitialDeploy;
1230   }
1231 
1232   /// @dev Returns the mint limit for a given checklist item, based on its tier.
1233   /// @param _checklistId Which checklist item we need to get the limit for.
1234   /// @return How much of this checklist item we are allowed to mint.
1235   function limitForChecklistId(uint8 _checklistId) external view returns (uint16) {
1236     RarityTier rarityTier;
1237     uint8 index;
1238     if (_checklistId < 100) { // Originals = #000 to #099
1239       rarityTier = originalChecklistItems[_checklistId].tier;
1240     } else if (_checklistId < 200) { // Iconics = #100 to #131
1241       index = _checklistId - 100;
1242       require(index < iconicsCount(), "This Iconics checklist item doesn't exist.");
1243       rarityTier = iconicChecklistItems[index].tier;
1244     } else { // Unreleased = #200 to max #255
1245       index = _checklistId - 200;
1246       require(index < unreleasedCount(), "This Unreleased checklist item doesn't exist.");
1247       rarityTier = unreleasedChecklistItems[index].tier;
1248     }
1249     return tierLimits[uint8(rarityTier)];
1250   }
1251 }
1252 
1253 
1254 /// @title Base contract for CryptoStrikers. Defines what a card is and how to mint one.
1255 /// @author The CryptoStrikers Team
1256 contract StrikersBase is ERC721Token("CryptoStrikers", "STRK") {
1257 
1258   /// @dev Emit this event whenever we mint a new card (see _mintCard below)
1259   event CardMinted(uint256 cardId);
1260 
1261   /// @dev The struct representing the game's main object, a sports trading card.
1262   struct Card {
1263     // The timestamp at which this card was minted.
1264     // With uint32 we are good until 2106, by which point we will have not minted
1265     // a card in like, 88 years.
1266     uint32 mintTime;
1267 
1268     // The checklist item represented by this card. See StrikersChecklist.sol for more info.
1269     uint8 checklistId;
1270 
1271     // Cards for a given player have a serial number, which gets
1272     // incremented in sequence. For example, if we mint 1000 of a card,
1273     // the third one to be minted has serialNumber = 3 (out of 1000).
1274     uint16 serialNumber;
1275   }
1276 
1277   /*** STORAGE ***/
1278 
1279   /// @dev All the cards that have been minted, indexed by cardId.
1280   Card[] public cards;
1281 
1282   /// @dev Keeps track of how many cards we have minted for a given checklist item
1283   ///   to make sure we don't go over the limit for it.
1284   ///   NB: uint16 has a capacity of 65,535, but we are not minting more than
1285   ///   4,352 of any given checklist item.
1286   mapping (uint8 => uint16) public mintedCountForChecklistId;
1287 
1288   /// @dev A reference to our checklist contract, which contains all the minting limits.
1289   StrikersChecklist public strikersChecklist;
1290 
1291   /*** FUNCTIONS ***/
1292 
1293   /// @dev For a given owner, returns two arrays. The first contains the IDs of every card owned
1294   ///   by this address. The second returns the corresponding checklist ID for each of these cards.
1295   ///   There are a few places we need this info in the web app and short of being able to return an
1296   ///   actual array of Cards, this is the best solution we could come up with...
1297   function cardAndChecklistIdsForOwner(address _owner) external view returns (uint256[], uint8[]) {
1298     uint256[] memory cardIds = ownedTokens[_owner];
1299     uint256 cardCount = cardIds.length;
1300     uint8[] memory checklistIds = new uint8[](cardCount);
1301 
1302     for (uint256 i = 0; i < cardCount; i++) {
1303       uint256 cardId = cardIds[i];
1304       checklistIds[i] = cards[cardId].checklistId;
1305     }
1306 
1307     return (cardIds, checklistIds);
1308   }
1309 
1310   /// @dev An internal method that creates a new card and stores it.
1311   ///  Emits both a CardMinted and a Transfer event.
1312   /// @param _checklistId The ID of the checklistItem represented by the card (see Checklist.sol)
1313   /// @param _owner The card's first owner!
1314   function _mintCard(
1315     uint8 _checklistId,
1316     address _owner
1317   )
1318     internal
1319     returns (uint256)
1320   {
1321     uint16 mintLimit = strikersChecklist.limitForChecklistId(_checklistId);
1322     require(mintLimit == 0 || mintedCountForChecklistId[_checklistId] < mintLimit, "Can't mint any more of this card!");
1323     uint16 serialNumber = ++mintedCountForChecklistId[_checklistId];
1324     Card memory newCard = Card({
1325       mintTime: uint32(now),
1326       checklistId: _checklistId,
1327       serialNumber: serialNumber
1328     });
1329     uint256 newCardId = cards.push(newCard) - 1;
1330     emit CardMinted(newCardId);
1331     _mint(_owner, newCardId);
1332     return newCardId;
1333   }
1334 }
1335 
1336 
1337 
1338 
1339 
1340 
1341 
1342 /**
1343  * @title Pausable
1344  * @dev Base contract which allows children to implement an emergency stop mechanism.
1345  */
1346 contract Pausable is Ownable {
1347   event Pause();
1348   event Unpause();
1349 
1350   bool public paused = false;
1351 
1352 
1353   /**
1354    * @dev Modifier to make a function callable only when the contract is not paused.
1355    */
1356   modifier whenNotPaused() {
1357     require(!paused);
1358     _;
1359   }
1360 
1361   /**
1362    * @dev Modifier to make a function callable only when the contract is paused.
1363    */
1364   modifier whenPaused() {
1365     require(paused);
1366     _;
1367   }
1368 
1369   /**
1370    * @dev called by the owner to pause, triggers stopped state
1371    */
1372   function pause() onlyOwner whenNotPaused public {
1373     paused = true;
1374     emit Pause();
1375   }
1376 
1377   /**
1378    * @dev called by the owner to unpause, returns to normal state
1379    */
1380   function unpause() onlyOwner whenPaused public {
1381     paused = false;
1382     emit Unpause();
1383   }
1384 }
1385 
1386 
1387 /// @title The contract that exposes minting functions to the outside world and limits who can call them.
1388 /// @author The CryptoStrikers Team
1389 contract StrikersMinting is StrikersBase, Pausable {
1390 
1391   /// @dev Emit this when we decide to no longer mint a given checklist ID.
1392   event PulledFromCirculation(uint8 checklistId);
1393 
1394   /// @dev If the value for a checklistId is true, we can no longer mint it.
1395   mapping (uint8 => bool) public outOfCirculation;
1396 
1397   /// @dev The address of the contract that manages the pack sale.
1398   address public packSaleAddress;
1399 
1400   /// @dev Only the owner can update the address of the pack sale contract.
1401   /// @param _address The address of the new StrikersPackSale contract.
1402   function setPackSaleAddress(address _address) external onlyOwner {
1403     packSaleAddress = _address;
1404   }
1405 
1406   /// @dev Allows the contract at packSaleAddress to mint cards.
1407   /// @param _checklistId The checklist item represented by this new card.
1408   /// @param _owner The card's first owner!
1409   /// @return The new card's ID.
1410   function mintPackSaleCard(uint8 _checklistId, address _owner) external returns (uint256) {
1411     require(msg.sender == packSaleAddress, "Only the pack sale contract can mint here.");
1412     require(!outOfCirculation[_checklistId], "Can't mint any more of this checklist item...");
1413     return _mintCard(_checklistId, _owner);
1414   }
1415 
1416   /// @dev Allows the owner to mint cards from our Unreleased Set.
1417   /// @param _checklistId The checklist item represented by this new card. Must be >= 200.
1418   /// @param _owner The card's first owner!
1419   function mintUnreleasedCard(uint8 _checklistId, address _owner) external onlyOwner {
1420     require(_checklistId >= 200, "You can only use this to mint unreleased cards.");
1421     require(!outOfCirculation[_checklistId], "Can't mint any more of this checklist item...");
1422     _mintCard(_checklistId, _owner);
1423   }
1424 
1425   /// @dev Allows the owner or the pack sale contract to prevent an Iconic or Unreleased card from ever being minted again.
1426   /// @param _checklistId The Iconic or Unreleased card we want to remove from circulation.
1427   function pullFromCirculation(uint8 _checklistId) external {
1428     bool ownerOrPackSale = (msg.sender == owner) || (msg.sender == packSaleAddress);
1429     require(ownerOrPackSale, "Only the owner or pack sale can take checklist items out of circulation.");
1430     require(_checklistId >= 100, "This function is reserved for Iconics and Unreleased sets.");
1431     outOfCirculation[_checklistId] = true;
1432     emit PulledFromCirculation(_checklistId);
1433   }
1434 }
1435 
1436 
1437 /// @title StrikersTrading - Allows users to trustlessly trade cards.
1438 /// @author The CryptoStrikers Team
1439 contract StrikersTrading is StrikersMinting {
1440 
1441   /// @dev Emitting this allows us to look up if a trade has been
1442   ///   successfully filled, by who, and which cards were involved.
1443   event TradeFilled(
1444     bytes32 indexed tradeHash,
1445     address indexed maker,
1446     uint256 makerCardId,
1447     address indexed taker,
1448     uint256 takerCardId
1449   );
1450 
1451   /// @dev Emitting this allows us to look up if a trade has been cancelled.
1452   event TradeCancelled(bytes32 indexed tradeHash, address indexed maker);
1453 
1454   /// @dev All the possible states for a trade.
1455   enum TradeState {
1456     Valid,
1457     Filled,
1458     Cancelled
1459   }
1460 
1461   /// @dev Mapping of tradeHash => TradeState. Defaults to Valid.
1462   mapping (bytes32 => TradeState) public tradeStates;
1463 
1464   /// @dev A taker (someone who has received a signed trade hash)
1465   ///   submits a cardId to this function and, if it satisfies
1466   ///   the given criteria, the trade is executed.
1467   /// @param _maker Address of the maker (i.e. trade creator).
1468   /// @param _makerCardId ID of the card the maker has agreed to give up.
1469   /// @param _taker The counterparty the maker wishes to trade with (if it's address(0), anybody can fill the trade!)
1470   /// @param _takerCardOrChecklistId If taker is the 0-address, then this is a checklist ID (e.g. "any Originals John Smith").
1471   ///                                If not, then it's a card ID (e.g. "Originals John Smith #8/100").
1472   /// @param _salt A uint256 timestamp to differentiate trades that have otherwise identical params (prevents replay attacks).
1473   /// @param _submittedCardId The card the taker is using to fill the trade. Must satisfy either the card or checklist ID
1474   ///                         specified in _takerCardOrChecklistId.
1475   /// @param _v ECDSA signature parameter v from the tradeHash signed by the maker.
1476   /// @param _r ECDSA signature parameters r from the tradeHash signed by the maker.
1477   /// @param _s ECDSA signature parameters s from the tradeHash signed by the maker.
1478   function fillTrade(
1479     address _maker,
1480     uint256 _makerCardId,
1481     address _taker,
1482     uint256 _takerCardOrChecklistId,
1483     uint256 _salt,
1484     uint256 _submittedCardId,
1485     uint8 _v,
1486     bytes32 _r,
1487     bytes32 _s)
1488     external
1489     whenNotPaused
1490   {
1491     require(_maker != msg.sender, "You can't fill your own trade.");
1492     require(_taker == address(0) || _taker == msg.sender, "You are not authorized to fill this trade.");
1493 
1494     if (_taker == address(0)) {
1495       // This trade is open to the public so we are requesting a checklistItem, rather than a specific card.
1496       require(cards[_submittedCardId].checklistId == _takerCardOrChecklistId, "The card you submitted is not valid for this trade.");
1497     } else {
1498       // We are trading directly with another user and are requesting a specific card.
1499       require(_submittedCardId == _takerCardOrChecklistId, "The card you submitted is not valid for this trade.");
1500     }
1501 
1502     bytes32 tradeHash = getTradeHash(
1503       _maker,
1504       _makerCardId,
1505       _taker,
1506       _takerCardOrChecklistId,
1507       _salt
1508     );
1509 
1510     require(tradeStates[tradeHash] == TradeState.Valid, "This trade is no longer valid.");
1511     require(isValidSignature(_maker, tradeHash, _v, _r, _s), "Invalid signature.");
1512 
1513     tradeStates[tradeHash] = TradeState.Filled;
1514 
1515     // For better UX, we assume that by signing the trade, the maker has given
1516     // implicit approval for this token to be transferred. This saves us from an
1517     // extra approval transaction...
1518     tokenApprovals[_makerCardId] = msg.sender;
1519 
1520     safeTransferFrom(_maker, msg.sender, _makerCardId);
1521     safeTransferFrom(msg.sender, _maker, _submittedCardId);
1522 
1523     emit TradeFilled(tradeHash, _maker, _makerCardId, msg.sender, _submittedCardId);
1524   }
1525 
1526   /// @dev Allows the maker to cancel a trade that hasn't been filled yet.
1527   /// @param _maker Address of the maker (i.e. trade creator).
1528   /// @param _makerCardId ID of the card the maker has agreed to give up.
1529   /// @param _taker The counterparty the maker wishes to trade with (if it's address(0), anybody can fill the trade!)
1530   /// @param _takerCardOrChecklistId If taker is the 0-address, then this is a checklist ID (e.g. "any Lionel Messi").
1531   ///                                If not, then it's a card ID (e.g. "Lionel Messi #8/100").
1532   /// @param _salt A uint256 timestamp to differentiate trades that have otherwise identical params (prevents replay attacks).
1533   function cancelTrade(
1534     address _maker,
1535     uint256 _makerCardId,
1536     address _taker,
1537     uint256 _takerCardOrChecklistId,
1538     uint256 _salt)
1539     external
1540   {
1541     require(_maker == msg.sender, "Only the trade creator can cancel this trade.");
1542 
1543     bytes32 tradeHash = getTradeHash(
1544       _maker,
1545       _makerCardId,
1546       _taker,
1547       _takerCardOrChecklistId,
1548       _salt
1549     );
1550 
1551     require(tradeStates[tradeHash] == TradeState.Valid, "This trade has already been cancelled or filled.");
1552     tradeStates[tradeHash] = TradeState.Cancelled;
1553     emit TradeCancelled(tradeHash, _maker);
1554   }
1555 
1556   /// @dev Calculates Keccak-256 hash of a trade with specified parameters.
1557   /// @param _maker Address of the maker (i.e. trade creator).
1558   /// @param _makerCardId ID of the card the maker has agreed to give up.
1559   /// @param _taker The counterparty the maker wishes to trade with (if it's address(0), anybody can fill the trade!)
1560   /// @param _takerCardOrChecklistId If taker is the 0-address, then this is a checklist ID (e.g. "any Lionel Messi").
1561   ///                                If not, then it's a card ID (e.g. "Lionel Messi #8/100").
1562   /// @param _salt A uint256 timestamp to differentiate trades that have otherwise identical params (prevents replay attacks).
1563   /// @return Keccak-256 hash of trade.
1564   function getTradeHash(
1565     address _maker,
1566     uint256 _makerCardId,
1567     address _taker,
1568     uint256 _takerCardOrChecklistId,
1569     uint256 _salt)
1570     public
1571     view
1572     returns (bytes32)
1573   {
1574     // Hashing the contract address prevents a trade from being replayed on any new trade contract we deploy.
1575     bytes memory packed = abi.encodePacked(this, _maker, _makerCardId, _taker, _takerCardOrChecklistId, _salt);
1576     return keccak256(packed);
1577   }
1578 
1579   /// @dev Verifies that a signed trade is valid.
1580   /// @param _signer Address of signer.
1581   /// @param _tradeHash Signed Keccak-256 hash.
1582   /// @param _v ECDSA signature parameter v.
1583   /// @param _r ECDSA signature parameters r.
1584   /// @param _s ECDSA signature parameters s.
1585   /// @return Validity of signature.
1586   function isValidSignature(
1587     address _signer,
1588     bytes32 _tradeHash,
1589     uint8 _v,
1590     bytes32 _r,
1591     bytes32 _s)
1592     public
1593     pure
1594     returns (bool)
1595   {
1596     bytes memory packed = abi.encodePacked("\x19Ethereum Signed Message:\n32", _tradeHash);
1597     return _signer == ecrecover(keccak256(packed), _v, _r, _s);
1598   }
1599 }
1600 
1601 
1602 /// @title The main, ERC721-compliant CryptoStrikers contract.
1603 /// @author The CryptoStrikers Team
1604 contract StrikersCore is StrikersTrading {
1605 
1606   /// @dev An external metadata contract that the owner can upgrade.
1607   StrikersMetadata public strikersMetadata;
1608 
1609   /// @dev We initialize the CryptoStrikers game with an immutable checklist that oversees card rarity.
1610   constructor(address _checklistAddress) public {
1611     strikersChecklist = StrikersChecklist(_checklistAddress);
1612   }
1613 
1614   /// @dev Allows the contract owner to update the metadata contract.
1615   function setMetadataAddress(address _contractAddress) external onlyOwner {
1616     strikersMetadata = StrikersMetadata(_contractAddress);
1617   }
1618 
1619   /// @dev If we've set an external metadata contract, use that.
1620   function tokenURI(uint256 _tokenId) public view returns (string) {
1621     if (strikersMetadata == address(0)) {
1622       return super.tokenURI(_tokenId);
1623     }
1624 
1625     require(exists(_tokenId), "Card does not exist.");
1626     return strikersMetadata.tokenURI(_tokenId);
1627   }
1628 }