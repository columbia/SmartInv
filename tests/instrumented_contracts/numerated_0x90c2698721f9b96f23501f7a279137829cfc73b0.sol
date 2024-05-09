1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title ERC721 Non-Fungible Token Standard basic interface
6  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
7  */
8 contract ERC721Basic {
9   event Transfer(
10     address indexed _from,
11     address indexed _to,
12     uint256 _tokenId
13   );
14   event Approval(
15     address indexed _owner,
16     address indexed _approved,
17     uint256 _tokenId
18   );
19   event ApprovalForAll(
20     address indexed _owner,
21     address indexed _operator,
22     bool _approved
23   );
24 
25   function balanceOf(address _owner) public view returns (uint256 _balance);
26   function ownerOf(uint256 _tokenId) public view returns (address _owner);
27   function exists(uint256 _tokenId) public view returns (bool _exists);
28 
29   function approve(address _to, uint256 _tokenId) public;
30   function getApproved(uint256 _tokenId)
31     public view returns (address _operator);
32 
33   function setApprovalForAll(address _operator, bool _approved) public;
34   function isApprovedForAll(address _owner, address _operator)
35     public view returns (bool);
36 
37   function transferFrom(address _from, address _to, uint256 _tokenId) public;
38   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
39     public;
40 
41   function safeTransferFrom(
42     address _from,
43     address _to,
44     uint256 _tokenId,
45     bytes _data
46   )
47     public;
48 }
49 
50 /**
51  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
52  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
53  */
54 contract ERC721Enumerable is ERC721Basic {
55   function totalSupply() public view returns (uint256);
56   function tokenOfOwnerByIndex(
57     address _owner,
58     uint256 _index
59   )
60     public
61     view
62     returns (uint256 _tokenId);
63 
64   function tokenByIndex(uint256 _index) public view returns (uint256);
65 }
66 
67 
68 /**
69  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
70  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
71  */
72 contract ERC721Metadata is ERC721Basic {
73   function name() public view returns (string _name);
74   function symbol() public view returns (string _symbol);
75   function tokenURI(uint256 _tokenId) public view returns (string);
76 }
77 
78 
79 /**
80  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
81  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
82  */
83 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
84 }
85 
86 
87 /**
88  * @title ERC721 token receiver interface
89  * @dev Interface for any contract that wants to support safeTransfers
90  *  from ERC721 asset contracts.
91  */
92 contract ERC721Receiver {
93   /**
94    * @dev Magic value to be returned upon successful reception of an NFT
95    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
96    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
97    */
98   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
99 
100   /**
101    * @notice Handle the receipt of an NFT
102    * @dev The ERC721 smart contract calls this function on the recipient
103    *  after a `safetransfer`. This function MAY throw to revert and reject the
104    *  transfer. This function MUST use 50,000 gas or less. Return of other
105    *  than the magic value MUST result in the transaction being reverted.
106    *  Note: the contract address is always the message sender.
107    * @param _from The sending address
108    * @param _tokenId The NFT identifier which is being transfered
109    * @param _data Additional data with no specified format
110    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
111    */
112   function onERC721Received(
113     address _from,
114     uint256 _tokenId,
115     bytes _data
116   )
117     public
118     returns(bytes4);
119 }
120 
121 
122 /**
123  * @title SafeMath
124  * @dev Math operations with safety checks that throw on error
125  */
126 library SafeMath {
127 
128   /**
129   * @dev Multiplies two numbers, throws on overflow.
130   */
131   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
132     if (a == 0) {
133       return 0;
134     }
135     c = a * b;
136     assert(c / a == b);
137     return c;
138   }
139 
140   /**
141   * @dev Integer division of two numbers, truncating the quotient.
142   */
143   function div(uint256 a, uint256 b) internal pure returns (uint256) {
144     // assert(b > 0); // Solidity automatically throws when dividing by 0
145     // uint256 c = a / b;
146     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
147     return a / b;
148   }
149 
150   /**
151   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
152   */
153   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154     assert(b <= a);
155     return a - b;
156   }
157 
158   /**
159   * @dev Adds two numbers, throws on overflow.
160   */
161   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
162     c = a + b;
163     assert(c >= a);
164     return c;
165   }
166 }
167 
168 
169 /**
170  * Utility library of inline functions on addresses
171  */
172 library AddressUtils {
173 
174   /**
175    * Returns whether the target address is a contract
176    * @dev This function will return false if invoked during the constructor of a contract,
177    *  as the code is not actually created until after the constructor finishes.
178    * @param addr address to check
179    * @return whether the target address is a contract
180    */
181   function isContract(address addr) internal view returns (bool) {
182     uint256 size;
183     // XXX Currently there is no better way to check if there is a contract in an address
184     // than to check the size of the code at that address.
185     // See https://ethereum.stackexchange.com/a/14016/36603
186     // for more details about how this works.
187     // TODO Check this again before the Serenity release, because all addresses will be
188     // contracts then.
189     // solium-disable-next-line security/no-inline-assembly
190     assembly { size := extcodesize(addr) }
191     return size > 0;
192   }
193 
194 }
195 
196 
197 /**
198  * @title ERC721 Non-Fungible Token Standard basic implementation
199  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
200  */
201 contract ERC721BasicToken is ERC721Basic {
202   using SafeMath for uint256;
203   using AddressUtils for address;
204 
205   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
206   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
207   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
208 
209   // Mapping from token ID to owner
210   mapping (uint256 => address) internal tokenOwner;
211 
212   // Mapping from token ID to approved address
213   mapping (uint256 => address) internal tokenApprovals;
214 
215   // Mapping from owner to number of owned token
216   mapping (address => uint256) internal ownedTokensCount;
217 
218   // Mapping from owner to operator approvals
219   mapping (address => mapping (address => bool)) internal operatorApprovals;
220 
221   /**
222    * @dev Guarantees msg.sender is owner of the given token
223    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
224    */
225   modifier onlyOwnerOf(uint256 _tokenId) {
226     require(ownerOf(_tokenId) == msg.sender);
227     _;
228   }
229 
230   /**
231    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
232    * @param _tokenId uint256 ID of the token to validate
233    */
234   modifier canTransfer(uint256 _tokenId) {
235     require(isApprovedOrOwner(msg.sender, _tokenId));
236     _;
237   }
238 
239   /**
240    * @dev Gets the balance of the specified address
241    * @param _owner address to query the balance of
242    * @return uint256 representing the amount owned by the passed address
243    */
244   function balanceOf(address _owner) public view returns (uint256) {
245     require(_owner != address(0));
246     return ownedTokensCount[_owner];
247   }
248 
249   /**
250    * @dev Gets the owner of the specified token ID
251    * @param _tokenId uint256 ID of the token to query the owner of
252    * @return owner address currently marked as the owner of the given token ID
253    */
254   function ownerOf(uint256 _tokenId) public view returns (address) {
255     address owner = tokenOwner[_tokenId];
256     require(owner != address(0));
257     return owner;
258   }
259 
260   /**
261    * @dev Returns whether the specified token exists
262    * @param _tokenId uint256 ID of the token to query the existence of
263    * @return whether the token exists
264    */
265   function exists(uint256 _tokenId) public view returns (bool) {
266     address owner = tokenOwner[_tokenId];
267     return owner != address(0);
268   }
269 
270   /**
271    * @dev Approves another address to transfer the given token ID
272    * @dev The zero address indicates there is no approved address.
273    * @dev There can only be one approved address per token at a given time.
274    * @dev Can only be called by the token owner or an approved operator.
275    * @param _to address to be approved for the given token ID
276    * @param _tokenId uint256 ID of the token to be approved
277    */
278   function approve(address _to, uint256 _tokenId) public {
279     address owner = ownerOf(_tokenId);
280     require(_to != owner);
281     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
282 
283     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
284       tokenApprovals[_tokenId] = _to;
285       emit Approval(owner, _to, _tokenId);
286     }
287   }
288 
289   /**
290    * @dev Gets the approved address for a token ID, or zero if no address set
291    * @param _tokenId uint256 ID of the token to query the approval of
292    * @return address currently approved for the given token ID
293    */
294   function getApproved(uint256 _tokenId) public view returns (address) {
295     return tokenApprovals[_tokenId];
296   }
297 
298   /**
299    * @dev Sets or unsets the approval of a given operator
300    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
301    * @param _to operator address to set the approval
302    * @param _approved representing the status of the approval to be set
303    */
304   function setApprovalForAll(address _to, bool _approved) public {
305     require(_to != msg.sender);
306     operatorApprovals[msg.sender][_to] = _approved;
307     emit ApprovalForAll(msg.sender, _to, _approved);
308   }
309 
310   /**
311    * @dev Tells whether an operator is approved by a given owner
312    * @param _owner owner address which you want to query the approval of
313    * @param _operator operator address which you want to query the approval of
314    * @return bool whether the given operator is approved by the given owner
315    */
316   function isApprovedForAll(
317     address _owner,
318     address _operator
319   )
320     public
321     view
322     returns (bool)
323   {
324     return operatorApprovals[_owner][_operator];
325   }
326 
327   /**
328    * @dev Transfers the ownership of a given token ID to another address
329    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
330    * @dev Requires the msg sender to be the owner, approved, or operator
331    * @param _from current owner of the token
332    * @param _to address to receive the ownership of the given token ID
333    * @param _tokenId uint256 ID of the token to be transferred
334   */
335   function transferFrom(
336     address _from,
337     address _to,
338     uint256 _tokenId
339   )
340     public
341     canTransfer(_tokenId)
342   {
343     require(_from != address(0));
344     require(_to != address(0));
345 
346     clearApproval(_from, _tokenId);
347     removeTokenFrom(_from, _tokenId);
348     addTokenTo(_to, _tokenId);
349 
350     emit Transfer(_from, _to, _tokenId);
351   }
352 
353   /**
354    * @dev Safely transfers the ownership of a given token ID to another address
355    * @dev If the target address is a contract, it must implement `onERC721Received`,
356    *  which is called upon a safe transfer, and return the magic value
357    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
358    *  the transfer is reverted.
359    * @dev Requires the msg sender to be the owner, approved, or operator
360    * @param _from current owner of the token
361    * @param _to address to receive the ownership of the given token ID
362    * @param _tokenId uint256 ID of the token to be transferred
363   */
364   function safeTransferFrom(
365     address _from,
366     address _to,
367     uint256 _tokenId
368   )
369     public
370     canTransfer(_tokenId)
371   {
372     // solium-disable-next-line arg-overflow
373     safeTransferFrom(_from, _to, _tokenId, "");
374   }
375 
376   /**
377    * @dev Safely transfers the ownership of a given token ID to another address
378    * @dev If the target address is a contract, it must implement `onERC721Received`,
379    *  which is called upon a safe transfer, and return the magic value
380    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
381    *  the transfer is reverted.
382    * @dev Requires the msg sender to be the owner, approved, or operator
383    * @param _from current owner of the token
384    * @param _to address to receive the ownership of the given token ID
385    * @param _tokenId uint256 ID of the token to be transferred
386    * @param _data bytes data to send along with a safe transfer check
387    */
388   function safeTransferFrom(
389     address _from,
390     address _to,
391     uint256 _tokenId,
392     bytes _data
393   )
394     public
395     canTransfer(_tokenId)
396   {
397     transferFrom(_from, _to, _tokenId);
398     // solium-disable-next-line arg-overflow
399     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
400   }
401 
402   /**
403    * @dev Returns whether the given spender can transfer a given token ID
404    * @param _spender address of the spender to query
405    * @param _tokenId uint256 ID of the token to be transferred
406    * @return bool whether the msg.sender is approved for the given token ID,
407    *  is an operator of the owner, or is the owner of the token
408    */
409   function isApprovedOrOwner(
410     address _spender,
411     uint256 _tokenId
412   )
413     internal
414     view
415     returns (bool)
416   {
417     address owner = ownerOf(_tokenId);
418     // Disable solium check because of
419     // https://github.com/duaraghav8/Solium/issues/175
420     // solium-disable-next-line operator-whitespace
421     return (
422       _spender == owner ||
423       getApproved(_tokenId) == _spender ||
424       isApprovedForAll(owner, _spender)
425     );
426   }
427 
428   /**
429    * @dev Internal function to mint a new token
430    * @dev Reverts if the given token ID already exists
431    * @param _to The address that will own the minted token
432    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
433    */
434   function _mint(address _to, uint256 _tokenId) internal {
435     require(_to != address(0));
436     addTokenTo(_to, _tokenId);
437     emit Transfer(address(0), _to, _tokenId);
438   }
439 
440   /**
441    * @dev Internal function to burn a specific token
442    * @dev Reverts if the token does not exist
443    * @param _tokenId uint256 ID of the token being burned by the msg.sender
444    */
445   function _burn(address _owner, uint256 _tokenId) internal {
446     clearApproval(_owner, _tokenId);
447     removeTokenFrom(_owner, _tokenId);
448     emit Transfer(_owner, address(0), _tokenId);
449   }
450 
451   /**
452    * @dev Internal function to clear current approval of a given token ID
453    * @dev Reverts if the given address is not indeed the owner of the token
454    * @param _owner owner of the token
455    * @param _tokenId uint256 ID of the token to be transferred
456    */
457   function clearApproval(address _owner, uint256 _tokenId) internal {
458     require(ownerOf(_tokenId) == _owner);
459     if (tokenApprovals[_tokenId] != address(0)) {
460       tokenApprovals[_tokenId] = address(0);
461       emit Approval(_owner, address(0), _tokenId);
462     }
463   }
464 
465   /**
466    * @dev Internal function to add a token ID to the list of a given address
467    * @param _to address representing the new owner of the given token ID
468    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
469    */
470   function addTokenTo(address _to, uint256 _tokenId) internal {
471     require(tokenOwner[_tokenId] == address(0));
472     tokenOwner[_tokenId] = _to;
473     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
474   }
475 
476   /**
477    * @dev Internal function to remove a token ID from the list of a given address
478    * @param _from address representing the previous owner of the given token ID
479    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
480    */
481   function removeTokenFrom(address _from, uint256 _tokenId) internal {
482     require(ownerOf(_tokenId) == _from);
483     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
484     tokenOwner[_tokenId] = address(0);
485   }
486 
487   /**
488    * @dev Internal function to invoke `onERC721Received` on a target address
489    * @dev The call is not executed if the target address is not a contract
490    * @param _from address representing the previous owner of the given token ID
491    * @param _to target address that will receive the tokens
492    * @param _tokenId uint256 ID of the token to be transferred
493    * @param _data bytes optional data to send along with the call
494    * @return whether the call correctly returned the expected magic value
495    */
496   function checkAndCallSafeTransfer(
497     address _from,
498     address _to,
499     uint256 _tokenId,
500     bytes _data
501   )
502     internal
503     returns (bool)
504   {
505     if (!_to.isContract()) {
506       return true;
507     }
508     bytes4 retval = ERC721Receiver(_to).onERC721Received(
509       _from, _tokenId, _data);
510     return (retval == ERC721_RECEIVED);
511   }
512 }
513 
514 
515 /**
516  * @title Full ERC721 Token
517  * This implementation includes all the required and some optional functionality of the ERC721 standard
518  * Moreover, it includes approve all functionality using operator terminology
519  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
520  */
521 contract ERC721Token is ERC721, ERC721BasicToken {
522   // Token name
523   string internal name_;
524 
525   // Token symbol
526   string internal symbol_;
527 
528   // Mapping from owner to list of owned token IDs
529   mapping(address => uint256[]) internal ownedTokens;
530 
531   // Mapping from token ID to index of the owner tokens list
532   mapping(uint256 => uint256) internal ownedTokensIndex;
533 
534   // Array with all token ids, used for enumeration
535   uint256[] internal allTokens;
536 
537   // Mapping from token id to position in the allTokens array
538   mapping(uint256 => uint256) internal allTokensIndex;
539 
540   // Optional mapping for token URIs
541   mapping(uint256 => string) internal tokenURIs;
542 
543   /**
544    * @dev Constructor function
545    */
546   constructor(string _name, string _symbol) public {
547     name_ = _name;
548     symbol_ = _symbol;
549   }
550 
551   /**
552    * @dev Gets the token name
553    * @return string representing the token name
554    */
555   function name() public view returns (string) {
556     return name_;
557   }
558 
559   /**
560    * @dev Gets the token symbol
561    * @return string representing the token symbol
562    */
563   function symbol() public view returns (string) {
564     return symbol_;
565   }
566 
567   /**
568    * @dev Returns an URI for a given token ID
569    * @dev Throws if the token ID does not exist. May return an empty string.
570    * @param _tokenId uint256 ID of the token to query
571    */
572   function tokenURI(uint256 _tokenId) public view returns (string) {
573     require(exists(_tokenId));
574     return tokenURIs[_tokenId];
575   }
576 
577   /**
578    * @dev Gets the token ID at a given index of the tokens list of the requested owner
579    * @param _owner address owning the tokens list to be accessed
580    * @param _index uint256 representing the index to be accessed of the requested tokens list
581    * @return uint256 token ID at the given index of the tokens list owned by the requested address
582    */
583   function tokenOfOwnerByIndex(
584     address _owner,
585     uint256 _index
586   )
587     public
588     view
589     returns (uint256)
590   {
591     require(_index < balanceOf(_owner));
592     return ownedTokens[_owner][_index];
593   }
594 
595   /**
596    * @dev Gets the total amount of tokens stored by the contract
597    * @return uint256 representing the total amount of tokens
598    */
599   function totalSupply() public view returns (uint256) {
600     return allTokens.length;
601   }
602 
603   /**
604    * @dev Gets the token ID at a given index of all the tokens in this contract
605    * @dev Reverts if the index is greater or equal to the total number of tokens
606    * @param _index uint256 representing the index to be accessed of the tokens list
607    * @return uint256 token ID at the given index of the tokens list
608    */
609   function tokenByIndex(uint256 _index) public view returns (uint256) {
610     require(_index < totalSupply());
611     return allTokens[_index];
612   }
613 
614   /**
615    * @dev Internal function to set the token URI for a given token
616    * @dev Reverts if the token ID does not exist
617    * @param _tokenId uint256 ID of the token to set its URI
618    * @param _uri string URI to assign
619    */
620   function _setTokenURI(uint256 _tokenId, string _uri) internal {
621     require(exists(_tokenId));
622     tokenURIs[_tokenId] = _uri;
623   }
624 
625   /**
626    * @dev Internal function to add a token ID to the list of a given address
627    * @param _to address representing the new owner of the given token ID
628    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
629    */
630   function addTokenTo(address _to, uint256 _tokenId) internal {
631     super.addTokenTo(_to, _tokenId);
632     uint256 length = ownedTokens[_to].length;
633     ownedTokens[_to].push(_tokenId);
634     ownedTokensIndex[_tokenId] = length;
635   }
636 
637   /**
638    * @dev Internal function to remove a token ID from the list of a given address
639    * @param _from address representing the previous owner of the given token ID
640    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
641    */
642   function removeTokenFrom(address _from, uint256 _tokenId) internal {
643     super.removeTokenFrom(_from, _tokenId);
644 
645     uint256 tokenIndex = ownedTokensIndex[_tokenId];
646     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
647     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
648 
649     ownedTokens[_from][tokenIndex] = lastToken;
650     ownedTokens[_from][lastTokenIndex] = 0;
651     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
652     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
653     // the lastToken to the first position, and then dropping the element placed in the last position of the list
654 
655     ownedTokens[_from].length--;
656     ownedTokensIndex[_tokenId] = 0;
657     ownedTokensIndex[lastToken] = tokenIndex;
658   }
659 
660   /**
661    * @dev Internal function to mint a new token
662    * @dev Reverts if the given token ID already exists
663    * @param _to address the beneficiary that will own the minted token
664    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
665    */
666   function _mint(address _to, uint256 _tokenId) internal {
667     super._mint(_to, _tokenId);
668 
669     allTokensIndex[_tokenId] = allTokens.length;
670     allTokens.push(_tokenId);
671   }
672 
673   /**
674    * @dev Internal function to burn a specific token
675    * @dev Reverts if the token does not exist
676    * @param _owner owner of the token to burn
677    * @param _tokenId uint256 ID of the token being burned by the msg.sender
678    */
679   function _burn(address _owner, uint256 _tokenId) internal {
680     super._burn(_owner, _tokenId);
681 
682     // Clear metadata (if any)
683     if (bytes(tokenURIs[_tokenId]).length != 0) {
684       delete tokenURIs[_tokenId];
685     }
686 
687     // Reorg all tokens array
688     uint256 tokenIndex = allTokensIndex[_tokenId];
689     uint256 lastTokenIndex = allTokens.length.sub(1);
690     uint256 lastToken = allTokens[lastTokenIndex];
691 
692     allTokens[tokenIndex] = lastToken;
693     allTokens[lastTokenIndex] = 0;
694 
695     allTokens.length--;
696     allTokensIndex[_tokenId] = 0;
697     allTokensIndex[lastToken] = tokenIndex;
698   }
699 
700 }
701 
702 
703 /**
704  * @title Ownable
705  * @dev The Ownable contract has an owner address, and provides basic authorization control
706  * functions, this simplifies the implementation of "user permissions".
707  */
708 contract Ownable {
709   address public owner;
710 
711 
712   event OwnershipRenounced(address indexed previousOwner);
713   event OwnershipTransferred(
714     address indexed previousOwner,
715     address indexed newOwner
716   );
717 
718 
719   /**
720    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
721    * account.
722    */
723   constructor() public {
724     owner = msg.sender;
725   }
726 
727   /**
728    * @dev Throws if called by any account other than the owner.
729    */
730   modifier onlyOwner() {
731     require(msg.sender == owner);
732     _;
733   }
734 
735   /**
736    * @dev Allows the current owner to transfer control of the contract to a newOwner.
737    * @param newOwner The address to transfer ownership to.
738    */
739   function transferOwnership(address newOwner) public onlyOwner {
740     require(newOwner != address(0));
741     emit OwnershipTransferred(owner, newOwner);
742     owner = newOwner;
743   }
744 
745   /**
746    * @dev Allows the current owner to relinquish control of the contract.
747    */
748   function renounceOwnership() public onlyOwner {
749     emit OwnershipRenounced(owner);
750     owner = address(0);
751   }
752 }
753 
754 
755 /*
756  *  @title CryptoFlower
757  *  @dev This is a constrained but compliant ERC725 token implementation with additional genome sequence for each token
758  *  @dev rewrites the CanTransfer modifier of OZs' implementation in order to disable transfers
759  */
760 contract CryptoFlower is ERC721Token, Ownable {
761 
762     // Disallowing transfers
763     bool transfersAllowed = false;
764 
765     // Storage of flower generator
766     mapping (uint256 => bytes7) genes;
767     mapping (uint256 => string) dedication;
768 
769     // event definitions
770     event FlowerAwarded(address indexed owner, uint256 tokenID, bytes7 gen);
771     event FlowerDedicated(uint256 tokenID, string wording);
772 
773     /*
774      *  @dev Constructor
775      *  @param string _name simple setter for the token.name variable
776      *  @param string _symbol simple setter for the token.symbol variable
777      */
778     constructor(string _name, string _symbol)
779     ERC721Token(_name, _symbol)
780     public {}
781 
782     /*
783      *  @dev Minting function calling token._mint procedure
784      *  @param address beneficiary is the destination of the token ownership
785      *  @param bytes32 generator is a hash generated by the fundraiser contract
786      *  @param uint karma is a genome influencer which will help to get a higher bonus gene
787      *  @return bool - true
788      */
789     function mint(address beneficiary, bytes32 generator, uint karma) onlyOwner external returns (bool)  {
790         /*
791          *  Interpretation mechanism [variant (value interval)]
792          *  Flower:             1 (0-85); 2 (86-170); 3 (171-255);
793          *  Bloom:              1 (0-51); 2 (52-102); 3 (103-153); 4 (154-204); 5 (205-255)
794          *  Stem:               1 (0-85); 2 (86-170); 3 (171-255);
795          *  Special:            None (0-222);1 (223-239); 2 (240-255);
796          *  Color Bloom:        hue variation
797          *  Color Stem:         hue variation
798          *  Color Background:   hue variation
799          */
800 
801         bytes1[7] memory genome;
802         genome[0] = generator[0];
803         genome[1] = generator[1];
804         genome[2] = generator[2];
805         if (uint(generator[3]) + karma >= 255) {
806             genome[3] = bytes1(255);
807         } else {
808             genome[3] = bytes1(uint(generator[3]) + karma);
809         }
810         genome[4] = generator[4];
811         genome[5] = generator[5];
812         genome[6] = generator[6];
813 
814         genes[lastID() + 1] = bytesToBytes7(genome);
815         emit FlowerAwarded(beneficiary, lastID() + 1, genes[lastID() + 1]);
816         _mint(beneficiary, lastID() + 1);
817         return true;
818     }
819 
820     /*
821      *  @dev function that enables to add one-off additional text to the token
822      *  @param uint256 tokenID of the token an owner wants to add dedication text to
823      *  @param string wording of the dedication to be shown with the flower
824      */
825     function addDedication(uint256 tokenID, string wording)
826     onlyOwnerOf(tokenID)
827     public {
828         require(bytes(dedication[tokenID]).length == 0);
829         dedication[tokenID] = wording;
830         emit FlowerDedicated(tokenID, wording);
831     }
832 
833     /*
834      *  Helper functions
835      */
836 
837     /*
838      *  @dev function returning tokenID of the last token issued
839      *  @return uint256 - the tokenID
840      */
841     function lastID() view public returns (uint256)  {
842         return allTokens.length - 1;
843     }
844 
845     /*
846      *  @dev CryptoFlower specific function returning the genome of a token
847      *  @param uint256 tokenID to look up the genome
848      *  @return bytes7 genome of the token
849      */
850     function getGen(uint256 tokenID) public view returns(bytes7) {
851         return genes[tokenID];
852     }
853 
854     /*
855      *  @dev function transforming a genom byte array to bytes7 type
856      *  @param bytes1[7] b - an array of 7 single bytes representing individual genes
857      *  @return bytes7 the compact type
858      */
859     function bytesToBytes7(bytes1[7] b) private pure returns (bytes7) {
860         bytes7 out;
861 
862         for (uint i = 0; i < 7; i++) {
863           out |= bytes7(b[i] & 0xFF) >> (i * 8);
864         }
865 
866         return out;
867     }
868 
869     /**
870    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
871    * @param _tokenId uint256 ID of the token to validate
872    */
873     modifier canTransfer(uint256 _tokenId) {
874         require(transfersAllowed);
875         require(isApprovedOrOwner(msg.sender, _tokenId));
876         _;
877     }
878 }
879 
880 
881 
882 /*
883  *  @title CryptoFlowerFundraiser
884  *  @dev The contract enables to participate in a charitable fundraiser and be rewarded by a ERC721 collectible item
885  *  @dev Transaction sent with Ether above the pricing point will result in issuing a new unique and semi-random token
886  */
887 contract CryptoFlowerRaiser {
888     // address of the token
889     CryptoFlower public token;
890 
891     // price of a flower
892     uint256 public price;
893 
894     // start and end timestamps when investments are allowed (both inclusive)
895     uint256 public startTime;
896     uint256 public endTime;
897 
898     // address where funds are collected
899     address public wallet;
900 
901     // total amount of wei raised
902     uint256 public raised;
903 
904     // finalization helper variable
905     bool public finalized;
906 
907     // the owner of the contract
908     address public owner;
909 
910     // onlyOwner modifier extracted from OZs' Ownable contract
911     modifier onlyOwner() {
912         require(msg.sender == owner);
913         _;
914     }
915 
916     // event declaration
917     event Donation(address indexed purchaser, uint256 value, uint256 totalRaised);
918     event Finalized();
919 
920     /*
921      *  @dev Constructor of the contract
922      *  @param uint256 _startTime - starting time of the fundraiser MUST be set in future
923      *  @param uint256 _endTime - time of the end of the fundraiser MUST be larger than _startTime, no funds will be accepted afterwards
924      *  @param uint256 _price - minimal contribution to generate a token
925      *  @param address _wallet - of the funds destination
926      */
927     constructor(uint256 _startTime, uint256 _endTime, uint256 _price, address _wallet) public {
928         require(_startTime >= now);
929         require(_endTime >= _startTime);
930         require(_price != 0x0);
931         require(_wallet != 0x0);
932 
933         token = new CryptoFlower("CryptoFlowers", "FLO");
934         startTime = _startTime;
935         endTime = _endTime;
936         price = _price;
937         wallet = _wallet;
938 
939         owner = msg.sender;
940     }
941 
942     /*
943      *  @dev fallback function triggering the buyToken procedure
944      */
945     function () payable public {
946         buyTokens(msg.sender);
947     }
948 
949     /*
950      *  @dev donation and token purchase method
951      *  @param address beneficiary is the destination of the token ownership
952      */
953     function buyTokens(address beneficiary) public payable {
954         require(beneficiary != 0x0);
955         require(msg.value != 0);
956 
957         // check if within buying period
958         require(now >= startTime && now <= endTime);
959 
960         // increase chance to land a special flower if the participation is high enough
961         if (msg.value >= price) {
962             uint karma;
963             if (msg.value >= 0.1 ether) {
964                 karma = 16;
965             } else if (msg.value >= 0.2 ether) {
966                 karma = 32;
967             } else if (msg.value >= 0.5 ether) {
968                 karma = 48;
969             }
970 
971             bytes32 generator = keccak256(abi.encodePacked(block.coinbase, now, token.getGen(token.lastID())));
972 
973             // mint tokens
974             token.mint(beneficiary, generator, karma);
975         }
976 
977         raised += msg.value; // we don't care about overflows here ;)
978         emit Donation(beneficiary, msg.value, raised);
979 
980         // forward funds to storage
981         wallet.transfer(msg.value);
982     }
983 
984     /*
985      *  @dev finalization function to formally end the fundraiser
986      *  @dev only owner can call this
987      */
988     function finalize() onlyOwner public {
989         require(!finalized);
990         require(now > endTime);
991 
992         token.transferOwnership(owner);
993 
994         finalized = true;
995         emit Finalized();
996     }
997 
998     /*
999      *  @dev clean up function to call a self-destruct benefiting the owner
1000      */
1001     function cleanUp() onlyOwner public {
1002         require(finalized);
1003         selfdestruct(owner);
1004     }
1005 }