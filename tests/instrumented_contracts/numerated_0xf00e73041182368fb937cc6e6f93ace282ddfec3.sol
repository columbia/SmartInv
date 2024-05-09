1 pragma solidity >=0.4.24 <0.6.0;
2 
3 library SafeMath {
4     /**
5     * @dev Multiplies two unsigned integers, reverts on overflow.
6     */
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
9         // benefit is lost if 'b' is also tested.
10         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
11         if (a == 0) {
12             return 0;
13         }
14 
15         uint256 c = a * b;
16         require(c / a == b);
17 
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // Solidity only automatically asserts when dividing by 0
26         require(b > 0);
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 
30         return c;
31     }
32 
33     /**
34     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b <= a);
38         uint256 c = a - b;
39 
40         return c;
41     }
42 
43     /**
44     * @dev Adds two unsigned integers, reverts on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a);
49 
50         return c;
51     }
52 
53     /**
54     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
55     * reverts when dividing by zero.
56     */
57     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58         require(b != 0);
59         return a % b;
60     }
61 }
62 
63 library AddressUtils {
64 
65   /**
66    * Returns whether the target address is a contract
67    * @dev This function will return false if invoked during the constructor of a contract,
68    * as the code is not actually created until after the constructor finishes.
69    * @param _addr address to check
70    * @return whether the target address is a contract
71    */
72   function isContract(address _addr) internal view returns (bool) {
73     uint256 size;
74     // XXX Currently there is no better way to check if there is a contract in an address
75     // than to check the size of the code at that address.
76     // See https://ethereum.stackexchange.com/a/14016/36603
77     // for more details about how this works.
78     // TODO Check this again before the Serenity release, because all addresses will be
79     // contracts then.
80     // solium-disable-next-line security/no-inline-assembly
81     assembly { size := extcodesize(_addr) }
82     return size > 0;
83   }
84 
85 }
86 
87 contract ERC721Receiver {
88   /**
89    * @dev Magic value to be returned upon successful reception of an NFT
90    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
91    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
92    */
93   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
94 
95   /**
96    * @notice Handle the receipt of an NFT
97    * @dev The ERC721 smart contract calls this function on the recipient
98    * after a `safetransfer`. This function MAY throw to revert and reject the
99    * transfer. Return of other than the magic value MUST result in the
100    * transaction being reverted.
101    * Note: the contract address is always the message sender.
102    * @param _operator The address which called `safeTransferFrom` function
103    * @param _from The address which previously owned the token
104    * @param _tokenId The NFT identifier which is being transferred
105    * @param _data Additional data with no specified format
106    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
107    */
108   function onERC721Received(
109     address _operator,
110     address _from,
111     uint256 _tokenId,
112     bytes memory _data
113   )
114     public
115     returns(bytes4);
116 }
117 
118 interface ERC165 {
119 
120   /**
121    * @notice Query if a contract implements an interface
122    * @param _interfaceId The interface identifier, as specified in ERC-165
123    * @dev Interface identification is specified in ERC-165. This function
124    * uses less than 30,000 gas.
125    */
126   function supportsInterface(bytes4 _interfaceId)
127     external
128     view
129     returns (bool);
130 }
131 
132 contract ERC721Basic is ERC165 {
133 
134   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
135   /*
136    * 0x80ac58cd ===
137    *   bytes4(keccak256('balanceOf(address)')) ^
138    *   bytes4(keccak256('ownerOf(uint256)')) ^
139    *   bytes4(keccak256('approve(address,uint256)')) ^
140    *   bytes4(keccak256('getApproved(uint256)')) ^
141    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
142    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
143    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
144    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
145    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
146    */
147 
148   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
149   /*
150    * 0x4f558e79 ===
151    *   bytes4(keccak256('exists(uint256)'))
152    */
153 
154   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
155   /**
156    * 0x780e9d63 ===
157    *   bytes4(keccak256('totalSupply()')) ^
158    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
159    *   bytes4(keccak256('tokenByIndex(uint256)'))
160    */
161 
162   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
163   /**
164    * 0x5b5e139f ===
165    *   bytes4(keccak256('name()')) ^
166    *   bytes4(keccak256('symbol()')) ^
167    *   bytes4(keccak256('tokenURI(uint256)'))
168    */
169 
170   event Transfer(
171     address indexed _from,
172     address indexed _to,
173     uint256 indexed _tokenId
174   );
175   event Approval(
176     address indexed _owner,
177     address indexed _approved,
178     uint256 indexed _tokenId
179   );
180   event ApprovalForAll(
181     address indexed _owner,
182     address indexed _operator,
183     bool _approved
184   );
185 
186   function balanceOf(address _owner) public view returns (uint256 _balance);
187   function ownerOf(uint256 _tokenId) public view returns (address _owner);
188   function exists(uint256 _tokenId) public view returns (bool _exists);
189 
190   function approve(address _to, uint256 _tokenId) public;
191   function getApproved(uint256 _tokenId)
192     public view returns (address _operator);
193 
194   function setApprovalForAll(address _operator, bool _approved) public;
195   function isApprovedForAll(address _owner, address _operator)
196     public view returns (bool);
197 
198   function transferFrom(address _from, address _to, uint256 _tokenId) public;
199   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
200     public;
201 
202   function safeTransferFrom(
203     address _from,
204     address _to,
205     uint256 _tokenId,
206     bytes memory _data
207   )
208     public;
209 }
210 
211 contract SupportsInterfaceWithLookup is ERC165 {
212 
213   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
214   /**
215    * 0x01ffc9a7 ===
216    *   bytes4(keccak256('supportsInterface(bytes4)'))
217    */
218 
219   /**
220    * @dev a mapping of interface id to whether or not it's supported
221    */
222   mapping(bytes4 => bool) internal supportedInterfaces;
223 
224   /**
225    * @dev A contract implementing SupportsInterfaceWithLookup
226    * implement ERC165 itself
227    */
228   constructor()
229     public
230   {
231     _registerInterface(InterfaceId_ERC165);
232   }
233 
234   /**
235    * @dev implement supportsInterface(bytes4) using a lookup table
236    */
237   function supportsInterface(bytes4 _interfaceId)
238     external
239     view
240     returns (bool)
241   {
242     return supportedInterfaces[_interfaceId];
243   }
244 
245   /**
246    * @dev private method for registering an interface
247    */
248   function _registerInterface(bytes4 _interfaceId)
249     internal
250   {
251     require(_interfaceId != 0xffffffff);
252     supportedInterfaces[_interfaceId] = true;
253   }
254 }
255 
256 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
257 
258   using SafeMath for uint256;
259   using AddressUtils for address;
260 
261   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
262   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
263   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
264 
265   // Mapping from token ID to owner
266   mapping (uint256 => address) internal tokenOwner;
267 
268   // Mapping from token ID to approved address
269   mapping (uint256 => address) internal tokenApprovals;
270 
271   // Mapping from owner to number of owned token
272   mapping (address => uint256) internal ownedTokensCount;
273 
274   // Mapping from owner to operator approvals
275   mapping (address => mapping (address => bool)) internal operatorApprovals;
276 
277   constructor()
278     public
279   {
280     // register the supported interfaces to conform to ERC721 via ERC165
281     _registerInterface(InterfaceId_ERC721);
282     _registerInterface(InterfaceId_ERC721Exists);
283   }
284 
285   /**
286    * @dev Gets the balance of the specified address
287    * @param _owner address to query the balance of
288    * @return uint256 representing the amount owned by the passed address
289    */
290   function balanceOf(address _owner) public view returns (uint256) {
291     require(_owner != address(0));
292     return ownedTokensCount[_owner];
293   }
294 
295   /**
296    * @dev Gets the owner of the specified token ID
297    * @param _tokenId uint256 ID of the token to query the owner of
298    * @return owner address currently marked as the owner of the given token ID
299    */
300   function ownerOf(uint256 _tokenId) public view returns (address) {
301     address owner = tokenOwner[_tokenId];
302     require(owner != address(0));
303     return owner;
304   }
305 
306   /**
307    * @dev Returns whether the specified token exists
308    * @param _tokenId uint256 ID of the token to query the existence of
309    * @return whether the token exists
310    */
311   function exists(uint256 _tokenId) public view returns (bool) {
312     address owner = tokenOwner[_tokenId];
313     return owner != address(0);
314   }
315 
316   /**
317    * @dev Approves another address to transfer the given token ID
318    * The zero address indicates there is no approved address.
319    * There can only be one approved address per token at a given time.
320    * Can only be called by the token owner or an approved operator.
321    * @param _to address to be approved for the given token ID
322    * @param _tokenId uint256 ID of the token to be approved
323    */
324   function approve(address _to, uint256 _tokenId) public {
325     address owner = ownerOf(_tokenId);
326     require(_to != owner);
327     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
328 
329     tokenApprovals[_tokenId] = _to;
330     emit Approval(owner, _to, _tokenId);
331   }
332 
333   /**
334    * @dev Gets the approved address for a token ID, or zero if no address set
335    * @param _tokenId uint256 ID of the token to query the approval of
336    * @return address currently approved for the given token ID
337    */
338   function getApproved(uint256 _tokenId) public view returns (address) {
339     return tokenApprovals[_tokenId];
340   }
341 
342   /**
343    * @dev Sets or unsets the approval of a given operator
344    * An operator is allowed to transfer all tokens of the sender on their behalf
345    * @param _to operator address to set the approval
346    * @param _approved representing the status of the approval to be set
347    */
348   function setApprovalForAll(address _to, bool _approved) public {
349     require(_to != msg.sender);
350     operatorApprovals[msg.sender][_to] = _approved;
351     emit ApprovalForAll(msg.sender, _to, _approved);
352   }
353 
354   /**
355    * @dev Tells whether an operator is approved by a given owner
356    * @param _owner owner address which you want to query the approval of
357    * @param _operator operator address which you want to query the approval of
358    * @return bool whether the given operator is approved by the given owner
359    */
360   function isApprovedForAll(
361     address _owner,
362     address _operator
363   )
364     public
365     view
366     returns (bool)
367   {
368     return operatorApprovals[_owner][_operator];
369   }
370 
371   /**
372    * @dev Transfers the ownership of a given token ID to another address
373    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
374    * Requires the msg sender to be the owner, approved, or operator
375    * @param _from current owner of the token
376    * @param _to address to receive the ownership of the given token ID
377    * @param _tokenId uint256 ID of the token to be transferred
378   */
379   function transferFrom(
380     address _from,
381     address _to,
382     uint256 _tokenId
383   )
384     public
385   {
386     require(isApprovedOrOwner(msg.sender, _tokenId));
387     require(_from != address(0));
388     require(_to != address(0));
389 
390     clearApproval(_from, _tokenId);
391     removeTokenFrom(_from, _tokenId);
392     addTokenTo(_to, _tokenId);
393 
394     emit Transfer(_from, _to, _tokenId);
395   }
396 
397   /**
398    * @dev Safely transfers the ownership of a given token ID to another address
399    * If the target address is a contract, it must implement `onERC721Received`,
400    * which is called upon a safe transfer, and return the magic value
401    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
402    * the transfer is reverted.
403    *
404    * Requires the msg sender to be the owner, approved, or operator
405    * @param _from current owner of the token
406    * @param _to address to receive the ownership of the given token ID
407    * @param _tokenId uint256 ID of the token to be transferred
408   */
409   function safeTransferFrom(
410     address _from,
411     address _to,
412     uint256 _tokenId
413   )
414     public
415   {
416     // solium-disable-next-line arg-overflow
417     safeTransferFrom(_from, _to, _tokenId, "");
418   }
419 
420   /**
421    * @dev Safely transfers the ownership of a given token ID to another address
422    * If the target address is a contract, it must implement `onERC721Received`,
423    * which is called upon a safe transfer, and return the magic value
424    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
425    * the transfer is reverted.
426    * Requires the msg sender to be the owner, approved, or operator
427    * @param _from current owner of the token
428    * @param _to address to receive the ownership of the given token ID
429    * @param _tokenId uint256 ID of the token to be transferred
430    * @param _data bytes data to send along with a safe transfer check
431    */
432   function safeTransferFrom(
433     address _from,
434     address _to,
435     uint256 _tokenId,
436     bytes memory _data
437   )
438     public
439   {
440     transferFrom(_from, _to, _tokenId);
441     // solium-disable-next-line arg-overflow
442     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
443   }
444 
445   /**
446    * @dev Returns whether the given spender can transfer a given token ID
447    * @param _spender address of the spender to query
448    * @param _tokenId uint256 ID of the token to be transferred
449    * @return bool whether the msg.sender is approved for the given token ID,
450    *  is an operator of the owner, or is the owner of the token
451    */
452   function isApprovedOrOwner(
453     address _spender,
454     uint256 _tokenId
455   )
456     internal
457     view
458     returns (bool)
459   {
460     address owner = ownerOf(_tokenId);
461     // Disable solium check because of
462     // https://github.com/duaraghav8/Solium/issues/175
463     // solium-disable-next-line operator-whitespace
464     return (
465       _spender == owner ||
466       getApproved(_tokenId) == _spender ||
467       isApprovedForAll(owner, _spender)
468     );
469   }
470 
471   /**
472    * @dev Internal function to mint a new token
473    * Reverts if the given token ID already exists
474    * @param _to The address that will own the minted token
475    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
476    */
477   function _mint(address _to, uint256 _tokenId) internal {
478     require(_to != address(0));
479     addTokenTo(_to, _tokenId);
480     emit Transfer(address(0), _to, _tokenId);
481   }
482 
483   /**
484    * @dev Internal function to burn a specific token
485    * Reverts if the token does not exist
486    * @param _tokenId uint256 ID of the token being burned by the msg.sender
487    */
488   function _burn(address _owner, uint256 _tokenId) internal {
489     clearApproval(_owner, _tokenId);
490     removeTokenFrom(_owner, _tokenId);
491     emit Transfer(_owner, address(0), _tokenId);
492   }
493 
494   /**
495    * @dev Internal function to clear current approval of a given token ID
496    * Reverts if the given address is not indeed the owner of the token
497    * @param _owner owner of the token
498    * @param _tokenId uint256 ID of the token to be transferred
499    */
500   function clearApproval(address _owner, uint256 _tokenId) internal {
501     require(ownerOf(_tokenId) == _owner);
502     if (tokenApprovals[_tokenId] != address(0)) {
503       tokenApprovals[_tokenId] = address(0);
504     }
505   }
506 
507   /**
508    * @dev Internal function to add a token ID to the list of a given address
509    * @param _to address representing the new owner of the given token ID
510    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
511    */
512   function addTokenTo(address _to, uint256 _tokenId) internal {
513     require(tokenOwner[_tokenId] == address(0));
514     tokenOwner[_tokenId] = _to;
515     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
516   }
517 
518   /**
519    * @dev Internal function to remove a token ID from the list of a given address
520    * @param _from address representing the previous owner of the given token ID
521    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
522    */
523   function removeTokenFrom(address _from, uint256 _tokenId) internal {
524     require(ownerOf(_tokenId) == _from);
525     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
526     tokenOwner[_tokenId] = address(0);
527   }
528 
529   /**
530    * @dev Internal function to invoke `onERC721Received` on a target address
531    * The call is not executed if the target address is not a contract
532    * @param _from address representing the previous owner of the given token ID
533    * @param _to target address that will receive the tokens
534    * @param _tokenId uint256 ID of the token to be transferred
535    * @param _data bytes optional data to send along with the call
536    * @return whether the call correctly returned the expected magic value
537    */
538   function checkAndCallSafeTransfer(
539     address _from,
540     address _to,
541     uint256 _tokenId,
542     bytes memory _data
543   )
544     internal
545     returns (bool)
546   {
547     if (!_to.isContract()) {
548       return true;
549     }
550     bytes4 retval = ERC721Receiver(_to).onERC721Received(
551       msg.sender, _from, _tokenId, _data);
552     return (retval == ERC721_RECEIVED);
553   }
554 }
555 
556 contract ERC721Enumerable is ERC721Basic {
557   function totalSupply() public view returns (uint256);
558   function tokenOfOwnerByIndex(
559     address _owner,
560     uint256 _index
561   )
562     public
563     view
564     returns (uint256 _tokenId);
565 
566   function tokenByIndex(uint256 _index) public view returns (uint256);
567 }
568 
569 
570 /**
571  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
572  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
573  */
574 contract ERC721Metadata is ERC721Basic {
575   function name() external view returns (string memory _name);
576   function symbol() external view returns (string memory _symbol);
577   function tokenURI(uint256 _tokenId) public view returns (string memory);
578 }
579 
580 
581 /**
582  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
583  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
584  */
585 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
586 }
587 
588 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
589 
590   // Token name
591   string internal name_;
592 
593   // Token symbol
594   string internal symbol_;
595 
596   // Mapping from owner to list of owned token IDs
597   mapping(address => uint256[]) internal ownedTokens;
598 
599   // Mapping from token ID to index of the owner tokens list
600   mapping(uint256 => uint256) internal ownedTokensIndex;
601 
602   // Array with all token ids, used for enumeration
603   uint256[] internal allTokens;
604 
605   // Mapping from token id to position in the allTokens array
606   mapping(uint256 => uint256) internal allTokensIndex;
607 
608   // Optional mapping for token URIs
609   mapping(uint256 => string) internal tokenURIs;
610 
611   /**
612    * @dev Constructor function
613    */
614   constructor() public {
615     
616 
617     // register the supported interfaces to conform to ERC721 via ERC165
618     _registerInterface(InterfaceId_ERC721Enumerable);
619     _registerInterface(InterfaceId_ERC721Metadata);
620   }
621 
622   /**
623    * @dev Gets the token name
624    * @return string representing the token name
625    */
626   function name() external view returns (string memory) {
627     return name_;
628   }
629 
630   /**
631    * @dev Gets the token symbol
632    * @return string representing the token symbol
633    */
634   function symbol() external view returns (string memory) {
635     return symbol_;
636   }
637 
638   /**
639    * @dev Returns an URI for a given token ID
640    * Throws if the token ID does not exist. May return an empty string.
641    * @param _tokenId uint256 ID of the token to query
642    */
643   function tokenURI(uint256 _tokenId) public view returns (string memory) {
644     require(exists(_tokenId));
645     return tokenURIs[_tokenId];
646   }
647 
648   /**
649    * @dev Gets the token ID at a given index of the tokens list of the requested owner
650    * @param _owner address owning the tokens list to be accessed
651    * @param _index uint256 representing the index to be accessed of the requested tokens list
652    * @return uint256 token ID at the given index of the tokens list owned by the requested address
653    */
654   function tokenOfOwnerByIndex(
655     address _owner,
656     uint256 _index
657   )
658     public
659     view
660     returns (uint256)
661   {
662     require(_index < balanceOf(_owner));
663     return ownedTokens[_owner][_index];
664   }
665 
666   /**
667    * @dev Gets the total amount of tokens stored by the contract
668    * @return uint256 representing the total amount of tokens
669    */
670   function totalSupply() public view returns (uint256) {
671     return allTokens.length;
672   }
673 
674   /**
675    * @dev Gets the token ID at a given index of all the tokens in this contract
676    * Reverts if the index is greater or equal to the total number of tokens
677    * @param _index uint256 representing the index to be accessed of the tokens list
678    * @return uint256 token ID at the given index of the tokens list
679    */
680   function tokenByIndex(uint256 _index) public view returns (uint256) {
681     require(_index < totalSupply());
682     return allTokens[_index];
683   }
684 
685   /**
686    * @dev Internal function to set the token URI for a given token
687    * Reverts if the token ID does not exist
688    * @param _tokenId uint256 ID of the token to set its URI
689    * @param _uri string URI to assign
690    */
691   function _setTokenURI(uint256 _tokenId, string memory _uri) internal {
692     require(exists(_tokenId));
693     tokenURIs[_tokenId] = _uri;
694   }
695 
696   /**
697    * @dev Internal function to add a token ID to the list of a given address
698    * @param _to address representing the new owner of the given token ID
699    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
700    */
701   function addTokenTo(address _to, uint256 _tokenId) internal {
702     super.addTokenTo(_to, _tokenId);
703     uint256 length = ownedTokens[_to].length;
704     ownedTokens[_to].push(_tokenId);
705     ownedTokensIndex[_tokenId] = length;
706   }
707 
708   /**
709    * @dev Internal function to remove a token ID from the list of a given address
710    * @param _from address representing the previous owner of the given token ID
711    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
712    */
713   function removeTokenFrom(address _from, uint256 _tokenId) internal {
714     super.removeTokenFrom(_from, _tokenId);
715 
716     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
717     // then delete the last slot.
718     uint256 tokenIndex = ownedTokensIndex[_tokenId];
719     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
720     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
721 
722     ownedTokens[_from][tokenIndex] = lastToken;
723     // This also deletes the contents at the last position of the array
724     ownedTokens[_from].length--;
725 
726     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
727     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
728     // the lastToken to the first position, and then dropping the element placed in the last position of the list
729 
730     ownedTokensIndex[_tokenId] = 0;
731     ownedTokensIndex[lastToken] = tokenIndex;
732   }
733 
734   /**
735    * @dev Internal function to mint a new token
736    * Reverts if the given token ID already exists
737    * @param _to address the beneficiary that will own the minted token
738    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
739    */
740   function _mint(address _to, uint256 _tokenId) internal {
741     super._mint(_to, _tokenId);
742 
743     allTokensIndex[_tokenId] = allTokens.length;
744     allTokens.push(_tokenId);
745   }
746 
747   /**
748    * @dev Internal function to burn a specific token
749    * Reverts if the token does not exist
750    * @param _owner owner of the token to burn
751    * @param _tokenId uint256 ID of the token being burned by the msg.sender
752    */
753   function _burn(address _owner, uint256 _tokenId) internal {
754     super._burn(_owner, _tokenId);
755 
756     // Clear metadata (if any)
757     if (bytes(tokenURIs[_tokenId]).length != 0) {
758       delete tokenURIs[_tokenId];
759     }
760 
761     // Reorg all tokens array
762     uint256 tokenIndex = allTokensIndex[_tokenId];
763     uint256 lastTokenIndex = allTokens.length.sub(1);
764     uint256 lastToken = allTokens[lastTokenIndex];
765 
766     allTokens[tokenIndex] = lastToken;
767     allTokens[lastTokenIndex] = 0;
768 
769     allTokens.length--;
770     allTokensIndex[_tokenId] = 0;
771     allTokensIndex[lastToken] = tokenIndex;
772   }
773 
774 }
775 
776 contract WeMeme is ERC721Token {
777 
778     event Memed(uint256 id, uint256 amount, uint256 totalCost, string content);
779     event Rewarded(uint256 id, address creator, uint256 amount, uint256 reward);
780 
781     using SafeMath for uint256;
782 
783     uint256 public topId;
784     uint256 constant private PRECISION = 10000000000;
785     address payable constant public wememe = 0x4d6cC9Dc492F2041B9eaFba4B63cA191DBA65BFc;
786     mapping(uint256 => uint256) public totalSupply_;
787     mapping(uint256 => uint256) public poolBalance;
788     mapping(uint256 => mapping(address => uint256)) public balances;
789     mapping(uint256 => uint256) public num;
790     mapping(uint256 => string) public content;
791     mapping(uint256 => address payable[]) public creators;
792 
793     constructor() public {
794         name_ = "wememe";
795         symbol_ = "MEME";
796     }
797 
798     /// @dev        Calculate the integral from 0 to t
799     /// @param t    The number to integrate to
800     function curveIntegral(uint256 t) internal returns (uint256) {
801         // Calculate integral of t^exponent
802         return PRECISION.div(2).mul(t ** 2).div(PRECISION);
803     }
804 
805     function priceToMint(uint256 id, uint256 numTokens) public returns(uint256) {
806         return curveIntegral(totalSupply_[id].add(numTokens)).sub(poolBalance[id]);
807     }
808 
809     function rewardForBurn(uint256 id, uint256 numTokens) public returns(uint256) {
810         return poolBalance[id].mul(numTokens.div(totalSupply_[id]));
811     }
812 
813     /// @dev                Mint new tokens with ether
814     /// @param numTokens    The number of tokens you want to mint
815     function meme(uint256 id, uint256 numTokens, string memory _content) public payable {
816         if (id == topId) {
817             topId = topId + 1;
818         }
819         require(id < topId);
820         require(num[id] < 3);
821         uint256 priceForTokens = priceToMint(id, numTokens);
822         require(msg.value >= priceForTokens);
823 
824         totalSupply_[id] = totalSupply_[id].add(numTokens);
825         balances[id][msg.sender] = balances[id][msg.sender].add(numTokens);
826         poolBalance[id] = poolBalance[id].add(msg.value);
827 
828         num[id] = num[id] + 1;
829         content[id] = _content;
830         creators[id].push(msg.sender);
831         emit Memed(id, numTokens, priceForTokens, _content);
832     }
833 
834     function reward(uint256 id, address payable creator) private {
835         uint256 ethToReturn = rewardForBurn(id, balances[id][creator]);
836         creator.transfer(ethToReturn);
837         
838         emit Rewarded(id, creator, balances[id][creator], ethToReturn);
839         balances[id][creator] = 0;
840     }
841     
842     function buy(uint256 id) public payable {
843         require(num[id] == 3);
844         require(msg.value >= poolBalance[id]);
845         uint256 fee = msg.value.div(100).mul(3);
846         poolBalance[id] = poolBalance[id].add(msg.value - fee);
847         // send nft to msg.sender
848         _mint(msg.sender, id);
849         _setTokenURI(id, content[id]);
850         
851         // send eth back to creators
852         reward(id, creators[id][0]);
853         reward(id, creators[id][1]);
854         reward(id, creators[id][2]);
855         wememe.transfer(fee);
856         poolBalance[id] = 0;
857     }
858 }