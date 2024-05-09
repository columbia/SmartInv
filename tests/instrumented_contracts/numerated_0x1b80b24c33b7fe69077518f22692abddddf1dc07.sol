1 // File: contracts/Strings.sol
2 
3 library Strings {
4     // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
5     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
6         bytes memory _ba = bytes(_a);
7         bytes memory _bb = bytes(_b);
8         bytes memory _bc = bytes(_c);
9         bytes memory _bd = bytes(_d);
10         bytes memory _be = bytes(_e);
11         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
12         bytes memory babcde = bytes(abcde);
13         uint k = 0;
14         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
15         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
16         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
17         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
18         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
19         return string(babcde);
20     }
21 
22     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
23         return strConcat(_a, _b, _c, _d, "");
24     }
25 
26     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
27         return strConcat(_a, _b, _c, "", "");
28     }
29 
30     function strConcat(string _a, string _b) internal pure returns (string) {
31         return strConcat(_a, _b, "", "", "");
32     }
33 
34     function uint2str(uint i) internal pure returns (string) {
35         if (i == 0) return "0";
36         uint j = i;
37         uint len;
38         while (j != 0){
39             len++;
40             j /= 10;
41         }
42         bytes memory bstr = new bytes(len);
43         uint k = len - 1;
44         while (i != 0){
45             bstr[k--] = byte(48 + i % 10);
46             i /= 10;
47         }
48         return string(bstr);
49     }
50 }
51 
52 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
53 
54 pragma solidity ^0.4.23;
55 
56 
57 /**
58  * @title ERC721 Non-Fungible Token Standard basic interface
59  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
60  */
61 contract ERC721Basic {
62   event Transfer(
63     address indexed _from,
64     address indexed _to,
65     uint256 _tokenId
66   );
67   event Approval(
68     address indexed _owner,
69     address indexed _approved,
70     uint256 _tokenId
71   );
72   event ApprovalForAll(
73     address indexed _owner,
74     address indexed _operator,
75     bool _approved
76   );
77 
78   function balanceOf(address _owner) public view returns (uint256 _balance);
79   function ownerOf(uint256 _tokenId) public view returns (address _owner);
80   function exists(uint256 _tokenId) public view returns (bool _exists);
81 
82   function approve(address _to, uint256 _tokenId) public;
83   function getApproved(uint256 _tokenId)
84     public view returns (address _operator);
85 
86   function setApprovalForAll(address _operator, bool _approved) public;
87   function isApprovedForAll(address _owner, address _operator)
88     public view returns (bool);
89 
90   function transferFrom(address _from, address _to, uint256 _tokenId) public;
91   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
92     public;
93 
94   function safeTransferFrom(
95     address _from,
96     address _to,
97     uint256 _tokenId,
98     bytes _data
99   )
100     public;
101 }
102 
103 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
104 
105 pragma solidity ^0.4.23;
106 
107 
108 
109 /**
110  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
111  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
112  */
113 contract ERC721Enumerable is ERC721Basic {
114   function totalSupply() public view returns (uint256);
115   function tokenOfOwnerByIndex(
116     address _owner,
117     uint256 _index
118   )
119     public
120     view
121     returns (uint256 _tokenId);
122 
123   function tokenByIndex(uint256 _index) public view returns (uint256);
124 }
125 
126 
127 /**
128  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
129  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
130  */
131 contract ERC721Metadata is ERC721Basic {
132   function name() public view returns (string _name);
133   function symbol() public view returns (string _symbol);
134   function tokenURI(uint256 _tokenId) public view returns (string);
135 }
136 
137 
138 /**
139  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
140  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
141  */
142 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
143 }
144 
145 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
146 
147 pragma solidity ^0.4.23;
148 
149 
150 /**
151  * @title ERC721 token receiver interface
152  * @dev Interface for any contract that wants to support safeTransfers
153  *  from ERC721 asset contracts.
154  */
155 contract ERC721Receiver {
156   /**
157    * @dev Magic value to be returned upon successful reception of an NFT
158    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
159    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
160    */
161   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
162 
163   /**
164    * @notice Handle the receipt of an NFT
165    * @dev The ERC721 smart contract calls this function on the recipient
166    *  after a `safetransfer`. This function MAY throw to revert and reject the
167    *  transfer. This function MUST use 50,000 gas or less. Return of other
168    *  than the magic value MUST result in the transaction being reverted.
169    *  Note: the contract address is always the message sender.
170    * @param _from The sending address
171    * @param _tokenId The NFT identifier which is being transfered
172    * @param _data Additional data with no specified format
173    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
174    */
175   function onERC721Received(
176     address _from,
177     uint256 _tokenId,
178     bytes _data
179   )
180     public
181     returns(bytes4);
182 }
183 
184 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
185 
186 pragma solidity ^0.4.23;
187 
188 
189 /**
190  * @title SafeMath
191  * @dev Math operations with safety checks that throw on error
192  */
193 library SafeMath {
194 
195   /**
196   * @dev Multiplies two numbers, throws on overflow.
197   */
198   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
199     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
200     // benefit is lost if 'b' is also tested.
201     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
202     if (a == 0) {
203       return 0;
204     }
205 
206     c = a * b;
207     assert(c / a == b);
208     return c;
209   }
210 
211   /**
212   * @dev Integer division of two numbers, truncating the quotient.
213   */
214   function div(uint256 a, uint256 b) internal pure returns (uint256) {
215     // assert(b > 0); // Solidity automatically throws when dividing by 0
216     // uint256 c = a / b;
217     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
218     return a / b;
219   }
220 
221   /**
222   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
223   */
224   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
225     assert(b <= a);
226     return a - b;
227   }
228 
229   /**
230   * @dev Adds two numbers, throws on overflow.
231   */
232   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
233     c = a + b;
234     assert(c >= a);
235     return c;
236   }
237 }
238 
239 // File: openzeppelin-solidity/contracts/AddressUtils.sol
240 
241 pragma solidity ^0.4.23;
242 
243 
244 /**
245  * Utility library of inline functions on addresses
246  */
247 library AddressUtils {
248 
249   /**
250    * Returns whether the target address is a contract
251    * @dev This function will return false if invoked during the constructor of a contract,
252    *  as the code is not actually created until after the constructor finishes.
253    * @param addr address to check
254    * @return whether the target address is a contract
255    */
256   function isContract(address addr) internal view returns (bool) {
257     uint256 size;
258     // XXX Currently there is no better way to check if there is a contract in an address
259     // than to check the size of the code at that address.
260     // See https://ethereum.stackexchange.com/a/14016/36603
261     // for more details about how this works.
262     // TODO Check this again before the Serenity release, because all addresses will be
263     // contracts then.
264     // solium-disable-next-line security/no-inline-assembly
265     assembly { size := extcodesize(addr) }
266     return size > 0;
267   }
268 
269 }
270 
271 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
272 
273 pragma solidity ^0.4.23;
274 
275 
276 
277 
278 
279 
280 /**
281  * @title ERC721 Non-Fungible Token Standard basic implementation
282  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
283  */
284 contract ERC721BasicToken is ERC721Basic {
285   using SafeMath for uint256;
286   using AddressUtils for address;
287 
288   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
289   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
290   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
291 
292   // Mapping from token ID to owner
293   mapping (uint256 => address) internal tokenOwner;
294 
295   // Mapping from token ID to approved address
296   mapping (uint256 => address) internal tokenApprovals;
297 
298   // Mapping from owner to number of owned token
299   mapping (address => uint256) internal ownedTokensCount;
300 
301   // Mapping from owner to operator approvals
302   mapping (address => mapping (address => bool)) internal operatorApprovals;
303 
304   /**
305    * @dev Guarantees msg.sender is owner of the given token
306    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
307    */
308   modifier onlyOwnerOf(uint256 _tokenId) {
309     require(ownerOf(_tokenId) == msg.sender);
310     _;
311   }
312 
313   /**
314    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
315    * @param _tokenId uint256 ID of the token to validate
316    */
317   modifier canTransfer(uint256 _tokenId) {
318     require(isApprovedOrOwner(msg.sender, _tokenId));
319     _;
320   }
321 
322   /**
323    * @dev Gets the balance of the specified address
324    * @param _owner address to query the balance of
325    * @return uint256 representing the amount owned by the passed address
326    */
327   function balanceOf(address _owner) public view returns (uint256) {
328     require(_owner != address(0));
329     return ownedTokensCount[_owner];
330   }
331 
332   /**
333    * @dev Gets the owner of the specified token ID
334    * @param _tokenId uint256 ID of the token to query the owner of
335    * @return owner address currently marked as the owner of the given token ID
336    */
337   function ownerOf(uint256 _tokenId) public view returns (address) {
338     address owner = tokenOwner[_tokenId];
339     require(owner != address(0));
340     return owner;
341   }
342 
343   /**
344    * @dev Returns whether the specified token exists
345    * @param _tokenId uint256 ID of the token to query the existence of
346    * @return whether the token exists
347    */
348   function exists(uint256 _tokenId) public view returns (bool) {
349     address owner = tokenOwner[_tokenId];
350     return owner != address(0);
351   }
352 
353   /**
354    * @dev Approves another address to transfer the given token ID
355    * @dev The zero address indicates there is no approved address.
356    * @dev There can only be one approved address per token at a given time.
357    * @dev Can only be called by the token owner or an approved operator.
358    * @param _to address to be approved for the given token ID
359    * @param _tokenId uint256 ID of the token to be approved
360    */
361   function approve(address _to, uint256 _tokenId) public {
362     address owner = ownerOf(_tokenId);
363     require(_to != owner);
364     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
365 
366     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
367       tokenApprovals[_tokenId] = _to;
368       emit Approval(owner, _to, _tokenId);
369     }
370   }
371 
372   /**
373    * @dev Gets the approved address for a token ID, or zero if no address set
374    * @param _tokenId uint256 ID of the token to query the approval of
375    * @return address currently approved for the given token ID
376    */
377   function getApproved(uint256 _tokenId) public view returns (address) {
378     return tokenApprovals[_tokenId];
379   }
380 
381   /**
382    * @dev Sets or unsets the approval of a given operator
383    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
384    * @param _to operator address to set the approval
385    * @param _approved representing the status of the approval to be set
386    */
387   function setApprovalForAll(address _to, bool _approved) public {
388     require(_to != msg.sender);
389     operatorApprovals[msg.sender][_to] = _approved;
390     emit ApprovalForAll(msg.sender, _to, _approved);
391   }
392 
393   /**
394    * @dev Tells whether an operator is approved by a given owner
395    * @param _owner owner address which you want to query the approval of
396    * @param _operator operator address which you want to query the approval of
397    * @return bool whether the given operator is approved by the given owner
398    */
399   function isApprovedForAll(
400     address _owner,
401     address _operator
402   )
403     public
404     view
405     returns (bool)
406   {
407     return operatorApprovals[_owner][_operator];
408   }
409 
410   /**
411    * @dev Transfers the ownership of a given token ID to another address
412    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
413    * @dev Requires the msg sender to be the owner, approved, or operator
414    * @param _from current owner of the token
415    * @param _to address to receive the ownership of the given token ID
416    * @param _tokenId uint256 ID of the token to be transferred
417   */
418   function transferFrom(
419     address _from,
420     address _to,
421     uint256 _tokenId
422   )
423     public
424     canTransfer(_tokenId)
425   {
426     require(_from != address(0));
427     require(_to != address(0));
428 
429     clearApproval(_from, _tokenId);
430     removeTokenFrom(_from, _tokenId);
431     addTokenTo(_to, _tokenId);
432 
433     emit Transfer(_from, _to, _tokenId);
434   }
435 
436   /**
437    * @dev Safely transfers the ownership of a given token ID to another address
438    * @dev If the target address is a contract, it must implement `onERC721Received`,
439    *  which is called upon a safe transfer, and return the magic value
440    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
441    *  the transfer is reverted.
442    * @dev Requires the msg sender to be the owner, approved, or operator
443    * @param _from current owner of the token
444    * @param _to address to receive the ownership of the given token ID
445    * @param _tokenId uint256 ID of the token to be transferred
446   */
447   function safeTransferFrom(
448     address _from,
449     address _to,
450     uint256 _tokenId
451   )
452     public
453     canTransfer(_tokenId)
454   {
455     // solium-disable-next-line arg-overflow
456     safeTransferFrom(_from, _to, _tokenId, "");
457   }
458 
459   /**
460    * @dev Safely transfers the ownership of a given token ID to another address
461    * @dev If the target address is a contract, it must implement `onERC721Received`,
462    *  which is called upon a safe transfer, and return the magic value
463    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
464    *  the transfer is reverted.
465    * @dev Requires the msg sender to be the owner, approved, or operator
466    * @param _from current owner of the token
467    * @param _to address to receive the ownership of the given token ID
468    * @param _tokenId uint256 ID of the token to be transferred
469    * @param _data bytes data to send along with a safe transfer check
470    */
471   function safeTransferFrom(
472     address _from,
473     address _to,
474     uint256 _tokenId,
475     bytes _data
476   )
477     public
478     canTransfer(_tokenId)
479   {
480     transferFrom(_from, _to, _tokenId);
481     // solium-disable-next-line arg-overflow
482     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
483   }
484 
485   /**
486    * @dev Returns whether the given spender can transfer a given token ID
487    * @param _spender address of the spender to query
488    * @param _tokenId uint256 ID of the token to be transferred
489    * @return bool whether the msg.sender is approved for the given token ID,
490    *  is an operator of the owner, or is the owner of the token
491    */
492   function isApprovedOrOwner(
493     address _spender,
494     uint256 _tokenId
495   )
496     internal
497     view
498     returns (bool)
499   {
500     address owner = ownerOf(_tokenId);
501     // Disable solium check because of
502     // https://github.com/duaraghav8/Solium/issues/175
503     // solium-disable-next-line operator-whitespace
504     return (
505       _spender == owner ||
506       getApproved(_tokenId) == _spender ||
507       isApprovedForAll(owner, _spender)
508     );
509   }
510 
511   /**
512    * @dev Internal function to mint a new token
513    * @dev Reverts if the given token ID already exists
514    * @param _to The address that will own the minted token
515    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
516    */
517   function _mint(address _to, uint256 _tokenId) internal {
518     require(_to != address(0));
519     addTokenTo(_to, _tokenId);
520     emit Transfer(address(0), _to, _tokenId);
521   }
522 
523   /**
524    * @dev Internal function to burn a specific token
525    * @dev Reverts if the token does not exist
526    * @param _tokenId uint256 ID of the token being burned by the msg.sender
527    */
528   function _burn(address _owner, uint256 _tokenId) internal {
529     clearApproval(_owner, _tokenId);
530     removeTokenFrom(_owner, _tokenId);
531     emit Transfer(_owner, address(0), _tokenId);
532   }
533 
534   /**
535    * @dev Internal function to clear current approval of a given token ID
536    * @dev Reverts if the given address is not indeed the owner of the token
537    * @param _owner owner of the token
538    * @param _tokenId uint256 ID of the token to be transferred
539    */
540   function clearApproval(address _owner, uint256 _tokenId) internal {
541     require(ownerOf(_tokenId) == _owner);
542     if (tokenApprovals[_tokenId] != address(0)) {
543       tokenApprovals[_tokenId] = address(0);
544       emit Approval(_owner, address(0), _tokenId);
545     }
546   }
547 
548   /**
549    * @dev Internal function to add a token ID to the list of a given address
550    * @param _to address representing the new owner of the given token ID
551    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
552    */
553   function addTokenTo(address _to, uint256 _tokenId) internal {
554     require(tokenOwner[_tokenId] == address(0));
555     tokenOwner[_tokenId] = _to;
556     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
557   }
558 
559   /**
560    * @dev Internal function to remove a token ID from the list of a given address
561    * @param _from address representing the previous owner of the given token ID
562    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
563    */
564   function removeTokenFrom(address _from, uint256 _tokenId) internal {
565     require(ownerOf(_tokenId) == _from);
566     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
567     tokenOwner[_tokenId] = address(0);
568   }
569 
570   /**
571    * @dev Internal function to invoke `onERC721Received` on a target address
572    * @dev The call is not executed if the target address is not a contract
573    * @param _from address representing the previous owner of the given token ID
574    * @param _to target address that will receive the tokens
575    * @param _tokenId uint256 ID of the token to be transferred
576    * @param _data bytes optional data to send along with the call
577    * @return whether the call correctly returned the expected magic value
578    */
579   function checkAndCallSafeTransfer(
580     address _from,
581     address _to,
582     uint256 _tokenId,
583     bytes _data
584   )
585     internal
586     returns (bool)
587   {
588     if (!_to.isContract()) {
589       return true;
590     }
591     bytes4 retval = ERC721Receiver(_to).onERC721Received(
592       _from, _tokenId, _data);
593     return (retval == ERC721_RECEIVED);
594   }
595 }
596 
597 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
598 
599 pragma solidity ^0.4.23;
600 
601 
602 
603 
604 /**
605  * @title Full ERC721 Token
606  * This implementation includes all the required and some optional functionality of the ERC721 standard
607  * Moreover, it includes approve all functionality using operator terminology
608  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
609  */
610 contract ERC721Token is ERC721, ERC721BasicToken {
611   // Token name
612   string internal name_;
613 
614   // Token symbol
615   string internal symbol_;
616 
617   // Mapping from owner to list of owned token IDs
618   mapping(address => uint256[]) internal ownedTokens;
619 
620   // Mapping from token ID to index of the owner tokens list
621   mapping(uint256 => uint256) internal ownedTokensIndex;
622 
623   // Array with all token ids, used for enumeration
624   uint256[] internal allTokens;
625 
626   // Mapping from token id to position in the allTokens array
627   mapping(uint256 => uint256) internal allTokensIndex;
628 
629   // Optional mapping for token URIs
630   mapping(uint256 => string) internal tokenURIs;
631 
632   /**
633    * @dev Constructor function
634    */
635   constructor(string _name, string _symbol) public {
636     name_ = _name;
637     symbol_ = _symbol;
638   }
639 
640   /**
641    * @dev Gets the token name
642    * @return string representing the token name
643    */
644   function name() public view returns (string) {
645     return name_;
646   }
647 
648   /**
649    * @dev Gets the token symbol
650    * @return string representing the token symbol
651    */
652   function symbol() public view returns (string) {
653     return symbol_;
654   }
655 
656   /**
657    * @dev Returns an URI for a given token ID
658    * @dev Throws if the token ID does not exist. May return an empty string.
659    * @param _tokenId uint256 ID of the token to query
660    */
661   function tokenURI(uint256 _tokenId) public view returns (string) {
662     require(exists(_tokenId));
663     return tokenURIs[_tokenId];
664   }
665 
666   /**
667    * @dev Gets the token ID at a given index of the tokens list of the requested owner
668    * @param _owner address owning the tokens list to be accessed
669    * @param _index uint256 representing the index to be accessed of the requested tokens list
670    * @return uint256 token ID at the given index of the tokens list owned by the requested address
671    */
672   function tokenOfOwnerByIndex(
673     address _owner,
674     uint256 _index
675   )
676     public
677     view
678     returns (uint256)
679   {
680     require(_index < balanceOf(_owner));
681     return ownedTokens[_owner][_index];
682   }
683 
684   /**
685    * @dev Gets the total amount of tokens stored by the contract
686    * @return uint256 representing the total amount of tokens
687    */
688   function totalSupply() public view returns (uint256) {
689     return allTokens.length;
690   }
691 
692   /**
693    * @dev Gets the token ID at a given index of all the tokens in this contract
694    * @dev Reverts if the index is greater or equal to the total number of tokens
695    * @param _index uint256 representing the index to be accessed of the tokens list
696    * @return uint256 token ID at the given index of the tokens list
697    */
698   function tokenByIndex(uint256 _index) public view returns (uint256) {
699     require(_index < totalSupply());
700     return allTokens[_index];
701   }
702 
703   /**
704    * @dev Internal function to set the token URI for a given token
705    * @dev Reverts if the token ID does not exist
706    * @param _tokenId uint256 ID of the token to set its URI
707    * @param _uri string URI to assign
708    */
709   function _setTokenURI(uint256 _tokenId, string _uri) internal {
710     require(exists(_tokenId));
711     tokenURIs[_tokenId] = _uri;
712   }
713 
714   /**
715    * @dev Internal function to add a token ID to the list of a given address
716    * @param _to address representing the new owner of the given token ID
717    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
718    */
719   function addTokenTo(address _to, uint256 _tokenId) internal {
720     super.addTokenTo(_to, _tokenId);
721     uint256 length = ownedTokens[_to].length;
722     ownedTokens[_to].push(_tokenId);
723     ownedTokensIndex[_tokenId] = length;
724   }
725 
726   /**
727    * @dev Internal function to remove a token ID from the list of a given address
728    * @param _from address representing the previous owner of the given token ID
729    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
730    */
731   function removeTokenFrom(address _from, uint256 _tokenId) internal {
732     super.removeTokenFrom(_from, _tokenId);
733 
734     uint256 tokenIndex = ownedTokensIndex[_tokenId];
735     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
736     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
737 
738     ownedTokens[_from][tokenIndex] = lastToken;
739     ownedTokens[_from][lastTokenIndex] = 0;
740     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
741     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
742     // the lastToken to the first position, and then dropping the element placed in the last position of the list
743 
744     ownedTokens[_from].length--;
745     ownedTokensIndex[_tokenId] = 0;
746     ownedTokensIndex[lastToken] = tokenIndex;
747   }
748 
749   /**
750    * @dev Internal function to mint a new token
751    * @dev Reverts if the given token ID already exists
752    * @param _to address the beneficiary that will own the minted token
753    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
754    */
755   function _mint(address _to, uint256 _tokenId) internal {
756     super._mint(_to, _tokenId);
757 
758     allTokensIndex[_tokenId] = allTokens.length;
759     allTokens.push(_tokenId);
760   }
761 
762   /**
763    * @dev Internal function to burn a specific token
764    * @dev Reverts if the token does not exist
765    * @param _owner owner of the token to burn
766    * @param _tokenId uint256 ID of the token being burned by the msg.sender
767    */
768   function _burn(address _owner, uint256 _tokenId) internal {
769     super._burn(_owner, _tokenId);
770 
771     // Clear metadata (if any)
772     if (bytes(tokenURIs[_tokenId]).length != 0) {
773       delete tokenURIs[_tokenId];
774     }
775 
776     // Reorg all tokens array
777     uint256 tokenIndex = allTokensIndex[_tokenId];
778     uint256 lastTokenIndex = allTokens.length.sub(1);
779     uint256 lastToken = allTokens[lastTokenIndex];
780 
781     allTokens[tokenIndex] = lastToken;
782     allTokens[lastTokenIndex] = 0;
783 
784     allTokens.length--;
785     allTokensIndex[_tokenId] = 0;
786     allTokensIndex[lastToken] = tokenIndex;
787   }
788 
789 }
790 
791 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
792 
793 pragma solidity ^0.4.23;
794 
795 
796 /**
797  * @title Ownable
798  * @dev The Ownable contract has an owner address, and provides basic authorization control
799  * functions, this simplifies the implementation of "user permissions".
800  */
801 contract Ownable {
802   address public owner;
803 
804 
805   event OwnershipRenounced(address indexed previousOwner);
806   event OwnershipTransferred(
807     address indexed previousOwner,
808     address indexed newOwner
809   );
810 
811 
812   /**
813    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
814    * account.
815    */
816   constructor() public {
817     owner = msg.sender;
818   }
819 
820   /**
821    * @dev Throws if called by any account other than the owner.
822    */
823   modifier onlyOwner() {
824     require(msg.sender == owner);
825     _;
826   }
827 
828   /**
829    * @dev Allows the current owner to relinquish control of the contract.
830    */
831   function renounceOwnership() public onlyOwner {
832     emit OwnershipRenounced(owner);
833     owner = address(0);
834   }
835 
836   /**
837    * @dev Allows the current owner to transfer control of the contract to a newOwner.
838    * @param _newOwner The address to transfer ownership to.
839    */
840   function transferOwnership(address _newOwner) public onlyOwner {
841     _transferOwnership(_newOwner);
842   }
843 
844   /**
845    * @dev Transfers control of the contract to a newOwner.
846    * @param _newOwner The address to transfer ownership to.
847    */
848   function _transferOwnership(address _newOwner) internal {
849     require(_newOwner != address(0));
850     emit OwnershipTransferred(owner, _newOwner);
851     owner = _newOwner;
852   }
853 }
854 
855 // File: contracts/TradeableERC721Token.sol
856 
857 /*
858 Abstract contract which allows trading to some external (contract) party
859 
860 Mostly copied from OpenSea https://github.com/ProjectOpenSea/opensea-creatures/blob/master/contracts/TradeableERC721Token.sol
861 
862 */
863 pragma solidity ^0.4.25;
864 
865 
866 
867 
868 
869 
870 
871 contract OwnableDelegateProxy { }
872 
873 contract ProxyRegistry {
874     mapping(address => OwnableDelegateProxy) public proxies;
875 }
876 
877 /**
878  * @title TradeableERC721Token
879  * TradeableERC721Token - ERC721 contract that whitelists a trading address, and has minting functionality.
880  */
881 contract TradeableERC721Token is ERC721Token, Ownable {
882     using SafeMath for uint256;
883     using Strings for string;
884 
885     uint256 burnedCounter = 0;
886     address proxyRegistryAddress;
887     string baseURI;
888 
889     constructor(string _name, string _symbol, address _proxyRegistryAddress, string _baseTokenURI) ERC721Token(_name, _symbol) public {
890         proxyRegistryAddress = _proxyRegistryAddress;
891         baseURI = _baseTokenURI;
892     }
893 
894     /**
895       * @dev Mints a token to an address with a tokenURI.
896       * @param _to address of the future owner of the token
897       */
898     function mintTo(address _to) public onlyOwner {
899         uint256 newTokenId = _getNextTokenId();
900         _mint(_to, newTokenId);
901     }
902 
903     /**
904    * @dev Approves another address to transfer the given array of token IDs
905    * @param _to address to be approved for the given token ID
906    * @param _tokenIds uint256[] IDs of the tokens to be approved
907    */
908     function approveBulk(address _to, uint256[] _tokenIds) public {
909         for (uint256 i = 0; i < _tokenIds.length; i++) {
910            approve(_to, _tokenIds[i]);
911         }
912     }
913 
914     /**
915       * @dev calculates the next token ID based on totalSupply and the burned offset
916       * @return uint256 for the next token ID
917       */
918     function _getNextTokenId() private view returns (uint256) {
919         return totalSupply().add(1).add(burnedCounter);
920     }
921 
922     /**
923       * @dev extends default burn functionality with the the burned counter
924       */
925     function _burn(address _owner, uint256 _tokenId) internal {
926         super._burn(_owner, _tokenId);
927         burnedCounter++;
928     }
929 
930     function baseTokenURI() public view returns (string) {
931         return baseURI;
932     }
933 
934     function tokenURI(uint256 _tokenId) public view returns (string) {
935         return Strings.strConcat(
936             baseTokenURI(),
937             Strings.uint2str(_tokenId)
938         );
939     }
940 
941     /**
942      * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
943      */
944     function isApprovedForAll(
945         address owner,
946         address operator
947     )
948     public
949     view
950     returns (bool)
951     {
952         //Check optional proxy
953         if (proxyRegistryAddress != address(0)) {
954             // Whitelist OpenSea proxy contract for easy trading.
955             ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
956             if (proxyRegistry.proxies(owner) == operator) {
957                 return true;
958             }
959         }
960 
961         return super.isApprovedForAll(owner, operator);
962     }
963 
964     /// @notice Returns a list of all tokens assigned to an address.
965     /// @param _owner The owner whose tokens we are interested in.
966     /// @dev This method MUST NEVER be called by smart contract code, due to the price
967     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
968         uint256 tokenCount = balanceOf(_owner);
969 
970         if (tokenCount == 0) {
971             // Return an empty array
972             return new uint256[](0);
973         } else {
974             uint256[] memory result = new uint256[](tokenCount);
975             uint256 resultIndex = 0;
976 
977             uint256 _tokenIdx;
978 
979             for (_tokenIdx = 0; _tokenIdx < tokenCount; _tokenIdx++) {
980                 result[resultIndex] = tokenOfOwnerByIndex(_owner, _tokenIdx);
981                 resultIndex++;
982             }
983 
984             return result;
985         }
986     }
987 }
988 
989 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
990 
991 pragma solidity ^0.4.23;
992 
993 
994 /**
995  * @title ERC20Basic
996  * @dev Simpler version of ERC20 interface
997  * @dev see https://github.com/ethereum/EIPs/issues/179
998  */
999 contract ERC20Basic {
1000   function totalSupply() public view returns (uint256);
1001   function balanceOf(address who) public view returns (uint256);
1002   function transfer(address to, uint256 value) public returns (bool);
1003   event Transfer(address indexed from, address indexed to, uint256 value);
1004 }
1005 
1006 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
1007 
1008 pragma solidity ^0.4.23;
1009 
1010 
1011 
1012 /**
1013  * @title ERC20 interface
1014  * @dev see https://github.com/ethereum/EIPs/issues/20
1015  */
1016 contract ERC20 is ERC20Basic {
1017   function allowance(address owner, address spender)
1018     public view returns (uint256);
1019 
1020   function transferFrom(address from, address to, uint256 value)
1021     public returns (bool);
1022 
1023   function approve(address spender, uint256 value) public returns (bool);
1024   event Approval(
1025     address indexed owner,
1026     address indexed spender,
1027     uint256 value
1028   );
1029 }
1030 
1031 // File: contracts/ERC20Box.sol
1032 
1033 pragma solidity ^0.4.25;
1034 
1035 
1036 
1037 /**
1038  * @title ERC20Box
1039  *
1040  * A tradable box (ERC-721), OpenSee.io compliant, which holds a portion of ERC-20 tokens,
1041  * that get credited to the owner upon 'opening' it
1042  */
1043 contract ERC20Box is TradeableERC721Token {
1044 
1045     ERC20 public token;
1046 
1047     uint256 tokensPerBox;
1048 
1049     /**
1050    * @dev Constructor function
1051    * Important! This token is not functional until depositERC() is called
1052    */
1053     constructor(string _name, string _symbol, address _proxyRegistryAddress, address _tokenAddress,
1054     uint256 _tokensPerBox, string _baseTokenURI)
1055     TradeableERC721Token(_name, _symbol, _proxyRegistryAddress, _baseTokenURI) public {
1056         token = ERC20(_tokenAddress);
1057         tokensPerBox = _tokensPerBox;
1058     }
1059 
1060     // Important! remember to call ERC20(address).approve(this, amount)
1061     // or this contract will not be able to do the transfer on your behalf.
1062     function depositERC(uint256 amount) onlyOwner public {
1063         require(amount % tokensPerBox == 0, "Wrong amount of tokens!");
1064         require(token.transferFrom(msg.sender, this, amount), "Insufficient funds");
1065         for(uint i = 0; i < amount.div(tokensPerBox); i++) {
1066             mintTo(msg.sender);
1067         }
1068     }
1069 
1070     function unpack(uint256 _tokenId) public onlyOwnerOf(_tokenId){
1071         require(token.balanceOf(this) >= tokensPerBox, "Hmm, been opened already?");
1072         require(token.transfer(msg.sender, tokensPerBox), "Couldn't transfer token");
1073 
1074         // Burn the box.
1075         _burn(msg.sender, _tokenId);
1076     }
1077 
1078     /**
1079    * @dev OpenSee compatibility, expects user-friendly number
1080    */
1081     function itemsPerLootbox() public view returns (uint256) {
1082         return tokensPerBox.div(10**18);
1083     }
1084 }