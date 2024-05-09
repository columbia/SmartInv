1 pragma solidity ^0.4.24;
2 
3 
4 
5 /**
6  * @title ERC165
7  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
8  */
9 interface ERC165 {
10 
11   /**
12    * @notice Query if a contract implements an interface
13    * @param _interfaceId The interface identifier, as specified in ERC-165
14    * @dev Interface identification is specified in ERC-165. This function
15    * uses less than 30,000 gas.
16    */
17   function supportsInterface(bytes4 _interfaceId)
18     external
19     view
20     returns (bool);
21 }
22 
23 
24 
25 /**
26  * @title SupportsInterfaceWithLookup
27  * @author Matt Condon (@shrugs)
28  * @dev Implements ERC165 using a lookup table.
29  */
30 contract SupportsInterfaceWithLookup is ERC165 {
31 
32   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
33   /**
34    * 0x01ffc9a7 ===
35    *   bytes4(keccak256('supportsInterface(bytes4)'))
36    */
37 
38   /**
39    * @dev a mapping of interface id to whether or not it's supported
40    */
41   mapping(bytes4 => bool) internal supportedInterfaces;
42 
43   /**
44    * @dev A contract implementing SupportsInterfaceWithLookup
45    * implement ERC165 itself
46    */
47   constructor()
48     public
49   {
50     _registerInterface(InterfaceId_ERC165);
51   }
52 
53   /**
54    * @dev implement supportsInterface(bytes4) using a lookup table
55    */
56   function supportsInterface(bytes4 _interfaceId)
57     external
58     view
59     returns (bool)
60   {
61     return supportedInterfaces[_interfaceId];
62   }
63 
64   /**
65    * @dev private method for registering an interface
66    */
67   function _registerInterface(bytes4 _interfaceId)
68     internal
69   {
70     require(_interfaceId != 0xffffffff);
71     supportedInterfaces[_interfaceId] = true;
72   }
73 }
74 
75 
76 /**
77  * @title ERC721 Non-Fungible Token Standard basic interface
78  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
79  */
80 contract ERC721Basic is ERC165 {
81 
82   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
83   /*
84    * 0x80ac58cd ===
85    *   bytes4(keccak256('balanceOf(address)')) ^
86    *   bytes4(keccak256('ownerOf(uint256)')) ^
87    *   bytes4(keccak256('approve(address,uint256)')) ^
88    *   bytes4(keccak256('getApproved(uint256)')) ^
89    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
90    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
91    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
92    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
93    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
94    */
95 
96   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
97   /**
98    * 0x780e9d63 ===
99    *   bytes4(keccak256('totalSupply()')) ^
100    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
101    *   bytes4(keccak256('tokenByIndex(uint256)'))
102    */
103 
104   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
105   /**
106    * 0x5b5e139f ===
107    *   bytes4(keccak256('name()')) ^
108    *   bytes4(keccak256('symbol()')) ^
109    *   bytes4(keccak256('tokenURI(uint256)'))
110    */
111 
112   event Transfer(
113     address indexed _from,
114     address indexed _to,
115     uint256 indexed _tokenId
116   );
117   event Approval(
118     address indexed _owner,
119     address indexed _approved,
120     uint256 indexed _tokenId
121   );
122   event ApprovalForAll(
123     address indexed _owner,
124     address indexed _operator,
125     bool _approved
126   );
127 
128   function balanceOf(address _owner) public view returns (uint256 _balance);
129   function ownerOf(uint256 _tokenId) public view returns (address _owner);
130 
131   function approve(address _to, uint256 _tokenId) public;
132   function getApproved(uint256 _tokenId)
133     public view returns (address _operator);
134 
135   function setApprovalForAll(address _operator, bool _approved) public;
136   function isApprovedForAll(address _owner, address _operator)
137     public view returns (bool);
138 
139   function transferFrom(address _from, address _to, uint256 _tokenId) public;
140   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
141     public;
142 
143   function safeTransferFrom(
144     address _from,
145     address _to,
146     uint256 _tokenId,
147     bytes _data
148   )
149     public;
150 }
151 
152 
153 
154 contract THORChain721Receiver {
155   /**
156    * @dev Magic value to be returned upon successful reception of an NFT
157    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
158    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
159    */
160   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
161 
162   bytes4 retval;
163   bool reverts;
164 
165   constructor(bytes4 _retval, bool _reverts) public {
166     retval = _retval;
167     reverts = _reverts;
168   }
169 
170   event Received(
171     address _operator,
172     address _from,
173     uint256 _tokenId,
174     bytes _data,
175     uint256 _gas
176   );
177 
178   function onERC721Received(
179     address _operator,
180     address _from,
181     uint256 _tokenId,
182     bytes _data
183   )
184     public
185     returns(bytes4)
186   {
187     require(!reverts);
188     emit Received(
189       _operator,
190       _from,
191       _tokenId,
192       _data,
193       gasleft()
194     );
195     return retval;
196   }
197 }
198 
199 
200 
201 /**
202  * @title SafeMath
203  * @dev Math operations with safety checks that revert on error
204  */
205 library SafeMath {
206 
207   /**
208   * @dev Multiplies two numbers, reverts on overflow.
209   */
210   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
211     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
212     // benefit is lost if 'b' is also tested.
213     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
214     if (_a == 0) {
215       return 0;
216     }
217 
218     uint256 c = _a * _b;
219     require(c / _a == _b);
220 
221     return c;
222   }
223 
224   /**
225   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
226   */
227   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
228     require(_b > 0); // Solidity only automatically asserts when dividing by 0
229     uint256 c = _a / _b;
230     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
231 
232     return c;
233   }
234 
235   /**
236   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
237   */
238   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
239     require(_b <= _a);
240     uint256 c = _a - _b;
241 
242     return c;
243   }
244 
245   /**
246   * @dev Adds two numbers, reverts on overflow.
247   */
248   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
249     uint256 c = _a + _b;
250     require(c >= _a);
251 
252     return c;
253   }
254 
255   /**
256   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
257   * reverts when dividing by zero.
258   */
259   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
260     require(b != 0);
261     return a % b;
262   }
263 }
264 
265 
266 /**
267  * Utility library of inline functions on addresses
268  */
269 library AddressUtils {
270 
271   /**
272    * Returns whether the target address is a contract
273    * @dev This function will return false if invoked during the constructor of a contract,
274    * as the code is not actually created until after the constructor finishes.
275    * @param _account address of the account to check
276    * @return whether the target address is a contract
277    */
278   function isContract(address _account) internal view returns (bool) {
279     uint256 size;
280     // XXX Currently there is no better way to check if there is a contract in an address
281     // than to check the size of the code at that address.
282     // See https://ethereum.stackexchange.com/a/14016/36603
283     // for more details about how this works.
284     // TODO Check this again before the Serenity release, because all addresses will be
285     // contracts then.
286     // solium-disable-next-line security/no-inline-assembly
287     assembly { size := extcodesize(_account) }
288     return size > 0;
289   }
290 
291 }
292 
293 
294 /**
295  * @title ERC721 Non-Fungible Token Standard basic implementation
296  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
297  */
298 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
299 
300   using SafeMath for uint256;
301   using AddressUtils for address;
302 
303   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
304   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
305   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
306 
307   // Mapping from token ID to owner
308   mapping (uint256 => address) internal tokenOwner;
309 
310   // Mapping from token ID to approved address
311   mapping (uint256 => address) internal tokenApprovals;
312 
313   // Mapping from owner to number of owned token
314   mapping (address => uint256) internal ownedTokensCount;
315 
316   // Mapping from owner to operator approvals
317   mapping (address => mapping (address => bool)) internal operatorApprovals;
318 
319   constructor()
320     public
321   {
322     // register the supported interfaces to conform to ERC721 via ERC165
323     _registerInterface(InterfaceId_ERC721);
324   }
325 
326   /**
327    * @dev Gets the balance of the specified address
328    * @param _owner address to query the balance of
329    * @return uint256 representing the amount owned by the passed address
330    */
331   function balanceOf(address _owner) public view returns (uint256) {
332     require(_owner != address(0));
333     return ownedTokensCount[_owner];
334   }
335 
336   /**
337    * @dev Gets the owner of the specified token ID
338    * @param _tokenId uint256 ID of the token to query the owner of
339    * @return owner address currently marked as the owner of the given token ID
340    */
341   function ownerOf(uint256 _tokenId) public view returns (address) {
342     address owner = tokenOwner[_tokenId];
343     require(owner != address(0));
344     return owner;
345   }
346 
347   /**
348    * @dev Approves another address to transfer the given token ID
349    * The zero address indicates there is no approved address.
350    * There can only be one approved address per token at a given time.
351    * Can only be called by the token owner or an approved operator.
352    * @param _to address to be approved for the given token ID
353    * @param _tokenId uint256 ID of the token to be approved
354    */
355   function approve(address _to, uint256 _tokenId) public {
356     address owner = ownerOf(_tokenId);
357     require(_to != owner);
358     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
359 
360     tokenApprovals[_tokenId] = _to;
361     emit Approval(owner, _to, _tokenId);
362   }
363 
364   /**
365    * @dev Gets the approved address for a token ID, or zero if no address set
366    * @param _tokenId uint256 ID of the token to query the approval of
367    * @return address currently approved for the given token ID
368    */
369   function getApproved(uint256 _tokenId) public view returns (address) {
370     return tokenApprovals[_tokenId];
371   }
372 
373   /**
374    * @dev Sets or unsets the approval of a given operator
375    * An operator is allowed to transfer all tokens of the sender on their behalf
376    * @param _to operator address to set the approval
377    * @param _approved representing the status of the approval to be set
378    */
379   function setApprovalForAll(address _to, bool _approved) public {
380     require(_to != msg.sender);
381     operatorApprovals[msg.sender][_to] = _approved;
382     emit ApprovalForAll(msg.sender, _to, _approved);
383   }
384 
385   /**
386    * @dev Tells whether an operator is approved by a given owner
387    * @param _owner owner address which you want to query the approval of
388    * @param _operator operator address which you want to query the approval of
389    * @return bool whether the given operator is approved by the given owner
390    */
391   function isApprovedForAll(
392     address _owner,
393     address _operator
394   )
395     public
396     view
397     returns (bool)
398   {
399     return operatorApprovals[_owner][_operator];
400   }
401 
402   /**
403    * @dev Transfers the ownership of a given token ID to another address
404    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
405    * Requires the msg sender to be the owner, approved, or operator
406    * @param _from current owner of the token
407    * @param _to address to receive the ownership of the given token ID
408    * @param _tokenId uint256 ID of the token to be transferred
409   */
410   function transferFrom(
411     address _from,
412     address _to,
413     uint256 _tokenId
414   )
415     public
416   {
417     require(isApprovedOrOwner(msg.sender, _tokenId));
418     require(_to != address(0));
419 
420     clearApproval(_from, _tokenId);
421     removeTokenFrom(_from, _tokenId);
422     addTokenTo(_to, _tokenId);
423 
424     emit Transfer(_from, _to, _tokenId);
425   }
426 
427   /**
428    * @dev Safely transfers the ownership of a given token ID to another address
429    * If the target address is a contract, it must implement `onERC721Received`,
430    * which is called upon a safe transfer, and return the magic value
431    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
432    * the transfer is reverted.
433    *
434    * Requires the msg sender to be the owner, approved, or operator
435    * @param _from current owner of the token
436    * @param _to address to receive the ownership of the given token ID
437    * @param _tokenId uint256 ID of the token to be transferred
438   */
439   function safeTransferFrom(
440     address _from,
441     address _to,
442     uint256 _tokenId
443   )
444     public
445   {
446     // solium-disable-next-line arg-overflow
447     safeTransferFrom(_from, _to, _tokenId, "");
448   }
449 
450   /**
451    * @dev Safely transfers the ownership of a given token ID to another address
452    * If the target address is a contract, it must implement `onERC721Received`,
453    * which is called upon a safe transfer, and return the magic value
454    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
455    * the transfer is reverted.
456    * Requires the msg sender to be the owner, approved, or operator
457    * @param _from current owner of the token
458    * @param _to address to receive the ownership of the given token ID
459    * @param _tokenId uint256 ID of the token to be transferred
460    * @param _data bytes data to send along with a safe transfer check
461    */
462   function safeTransferFrom(
463     address _from,
464     address _to,
465     uint256 _tokenId,
466     bytes _data
467   )
468     public
469   {
470     transferFrom(_from, _to, _tokenId);
471     // solium-disable-next-line arg-overflow
472     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
473   }
474 
475   /**
476    * @dev Returns whether the specified token exists
477    * @param _tokenId uint256 ID of the token to query the existence of
478    * @return whether the token exists
479    */
480   function _exists(uint256 _tokenId) internal view returns (bool) {
481     address owner = tokenOwner[_tokenId];
482     return owner != address(0);
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
513    * Reverts if the given token ID already exists
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
525    * Reverts if the token does not exist
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
536    * Reverts if the given address is not indeed the owner of the token
537    * @param _owner owner of the token
538    * @param _tokenId uint256 ID of the token to be transferred
539    */
540   function clearApproval(address _owner, uint256 _tokenId) internal {
541     require(ownerOf(_tokenId) == _owner);
542     if (tokenApprovals[_tokenId] != address(0)) {
543       tokenApprovals[_tokenId] = address(0);
544     }
545   }
546 
547   /**
548    * @dev Internal function to add a token ID to the list of a given address
549    * @param _to address representing the new owner of the given token ID
550    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
551    */
552   function addTokenTo(address _to, uint256 _tokenId) internal {
553     require(tokenOwner[_tokenId] == address(0));
554     tokenOwner[_tokenId] = _to;
555     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
556   }
557 
558   /**
559    * @dev Internal function to remove a token ID from the list of a given address
560    * @param _from address representing the previous owner of the given token ID
561    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
562    */
563   function removeTokenFrom(address _from, uint256 _tokenId) internal {
564     require(ownerOf(_tokenId) == _from);
565     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
566     tokenOwner[_tokenId] = address(0);
567   }
568 
569   /**
570    * @dev Internal function to invoke `onERC721Received` on a target address
571    * The call is not executed if the target address is not a contract
572    * @param _from address representing the previous owner of the given token ID
573    * @param _to target address that will receive the tokens
574    * @param _tokenId uint256 ID of the token to be transferred
575    * @param _data bytes optional data to send along with the call
576    * @return whether the call correctly returned the expected magic value
577    */
578   function checkAndCallSafeTransfer(
579     address _from,
580     address _to,
581     uint256 _tokenId,
582     bytes _data
583   )
584     internal
585     returns (bool)
586   {
587     if (!_to.isContract()) {
588       return true;
589     }
590     bytes4 retval = THORChain721Receiver(_to).onERC721Received(
591       msg.sender, _from, _tokenId, _data);
592     return (retval == ERC721_RECEIVED);
593   }
594 }
595 
596 
597 
598 
599 
600 
601 /**
602  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
603  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
604  */
605 contract ERC721Enumerable is ERC721Basic {
606   function totalSupply() public view returns (uint256);
607   function tokenOfOwnerByIndex(
608     address _owner,
609     uint256 _index
610   )
611     public
612     view
613     returns (uint256 _tokenId);
614 
615   function tokenByIndex(uint256 _index) public view returns (uint256);
616 }
617 
618 
619 /**
620  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
621  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
622  */
623 contract ERC721Metadata is ERC721Basic {
624   function name() external view returns (string _name);
625   function symbol() external view returns (string _symbol);
626   function tokenURI(uint256 _tokenId) public view returns (string);
627 }
628 
629 
630 /**
631  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
632  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
633  */
634 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
635 }
636 
637 
638 
639 
640 /**
641  * @title Full ERC721 Token
642  * This implementation includes all the required and some optional functionality of the ERC721 standard
643  * Moreover, it includes approve all functionality using operator terminology
644  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
645  */
646 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
647 
648   // Token name
649   string internal name_;
650 
651   // Token symbol
652   string internal symbol_;
653 
654   // Mapping from owner to list of owned token IDs
655   mapping(address => uint256[]) internal ownedTokens;
656 
657   // Mapping from token ID to index of the owner tokens list
658   mapping(uint256 => uint256) internal ownedTokensIndex;
659 
660   // Array with all token ids, used for enumeration
661   uint256[] internal allTokens;
662 
663   // Mapping from token id to position in the allTokens array
664   mapping(uint256 => uint256) internal allTokensIndex;
665 
666   // Optional mapping for token URIs
667   mapping(uint256 => string) internal tokenURIs;
668 
669   /**
670    * @dev Constructor function
671    */
672   constructor(string _name, string _symbol) public {
673     name_ = _name;
674     symbol_ = _symbol;
675 
676     // register the supported interfaces to conform to ERC721 via ERC165
677     _registerInterface(InterfaceId_ERC721Enumerable);
678     _registerInterface(InterfaceId_ERC721Metadata);
679   }
680 
681   /**
682    * @dev Gets the token name
683    * @return string representing the token name
684    */
685   function name() external view returns (string) {
686     return name_;
687   }
688 
689   /**
690    * @dev Gets the token symbol
691    * @return string representing the token symbol
692    */
693   function symbol() external view returns (string) {
694     return symbol_;
695   }
696 
697   /**
698    * @dev Returns an URI for a given token ID
699    * Throws if the token ID does not exist. May return an empty string.
700    * @param _tokenId uint256 ID of the token to query
701    */
702   function tokenURI(uint256 _tokenId) public view returns (string) {
703     require(_exists(_tokenId));
704     return tokenURIs[_tokenId];
705   }
706 
707   /**
708    * @dev Gets the token ID at a given index of the tokens list of the requested owner
709    * @param _owner address owning the tokens list to be accessed
710    * @param _index uint256 representing the index to be accessed of the requested tokens list
711    * @return uint256 token ID at the given index of the tokens list owned by the requested address
712    */
713   function tokenOfOwnerByIndex(
714     address _owner,
715     uint256 _index
716   )
717     public
718     view
719     returns (uint256)
720   {
721     require(_index < balanceOf(_owner));
722     return ownedTokens[_owner][_index];
723   }
724 
725   /**
726    * @dev Gets the total amount of tokens stored by the contract
727    * @return uint256 representing the total amount of tokens
728    */
729   function totalSupply() public view returns (uint256) {
730     return allTokens.length;
731   }
732 
733   /**
734    * @dev Gets the token ID at a given index of all the tokens in this contract
735    * Reverts if the index is greater or equal to the total number of tokens
736    * @param _index uint256 representing the index to be accessed of the tokens list
737    * @return uint256 token ID at the given index of the tokens list
738    */
739   function tokenByIndex(uint256 _index) public view returns (uint256) {
740     require(_index < totalSupply());
741     return allTokens[_index];
742   }
743 
744   /**
745    * @dev Internal function to set the token URI for a given token
746    * Reverts if the token ID does not exist
747    * @param _tokenId uint256 ID of the token to set its URI
748    * @param _uri string URI to assign
749    */
750   function _setTokenURI(uint256 _tokenId, string _uri) internal {
751     require(_exists(_tokenId));
752     tokenURIs[_tokenId] = _uri;
753   }
754 
755   /**
756    * @dev Internal function to add a token ID to the list of a given address
757    * @param _to address representing the new owner of the given token ID
758    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
759    */
760   function addTokenTo(address _to, uint256 _tokenId) internal {
761     super.addTokenTo(_to, _tokenId);
762     uint256 length = ownedTokens[_to].length;
763     ownedTokens[_to].push(_tokenId);
764     ownedTokensIndex[_tokenId] = length;
765   }
766 
767   /**
768    * @dev Internal function to mint a new token
769    * Reverts if the given token ID already exists
770    * @param _to address the beneficiary that will own the minted token
771    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
772    */
773   function _mint(address _to, uint256 _tokenId) internal {
774     super._mint(_to, _tokenId);
775 
776     allTokensIndex[_tokenId] = allTokens.length;
777     allTokens.push(_tokenId);
778   }
779 
780 }
781 
782 contract THORChain721 is ERC721Token {
783     
784     address public owner;
785 
786     modifier onlyOwner {
787         require(msg.sender == owner);
788         _;
789     }
790 
791     constructor () public ERC721Token("THORChain Collectible", "THORChain Collectible") {
792         owner = msg.sender;
793     }
794 
795     // Revert any transaction to this contract.
796     function() public payable { 
797         revert(); 
798     }
799     
800     function mint(address _to, uint256 _tokenId) public onlyOwner {
801         super._mint(_to, _tokenId);
802     }
803 
804     function setTokenURI(uint256 _tokenId, string _uri) public onlyOwner {
805         super._setTokenURI(_tokenId, _uri);
806     }
807 }