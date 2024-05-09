1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 interface IERC165 {
68 
69   /**
70    * @notice Query if a contract implements an interface
71    * @param interfaceId The interface identifier, as specified in ERC-165
72    * @dev Interface identification is specified in ERC-165. This function
73    * uses less than 30,000 gas.
74    */
75   function supportsInterface(bytes4 interfaceId)
76     external
77     view
78     returns (bool);
79 }
80 
81 interface ISuperRare {
82   /**
83    * @notice A descriptive name for a collection of NFTs in this contract
84    */
85   function name() external pure returns (string _name);
86 
87   /**
88    * @notice An abbreviated name for NFTs in this contract
89    */
90   function symbol() external pure returns (string _symbol);
91 
92   /** 
93    * @dev Returns whether the creator is whitelisted
94    * @param _creator address to check
95    * @return bool 
96    */
97   function isWhitelisted(address _creator) external view returns (bool);
98 
99   /** 
100    * @notice A distinct Uniform Resource Identifier (URI) for a given asset.
101    * @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
102    * 3986. The URI may point to a JSON file that conforms to the "ERC721
103    * Metadata JSON Schema".
104    */
105   function tokenURI(uint256 _tokenId) external view returns (string);
106 
107   /**
108   * @dev Gets the creator of the token
109   * @param _tokenId uint256 ID of the token
110   * @return address of the creator
111   */
112   function creatorOfToken(uint256 _tokenId) public view returns (address);
113 
114   /**
115   * @dev Gets the total amount of tokens stored by the contract
116   * @return uint256 representing the total amount of tokens
117   */
118   function totalSupply() public view returns (uint256);
119 }
120 
121 /**
122  * @title ERC721 token receiver interface
123  * @dev Interface for any contract that wants to support safeTransfers
124  * from ERC721 asset contracts.
125  */
126 contract IERC721Receiver {
127   /**
128    * @notice Handle the receipt of an NFT
129    * @dev The ERC721 smart contract calls this function on the recipient
130    * after a `safeTransfer`. This function MUST return the function selector,
131    * otherwise the caller will revert the transaction. The selector to be
132    * returned can be obtained as `this.onERC721Received.selector`. This
133    * function MAY throw to revert and reject the transfer.
134    * Note: the ERC721 contract address is always the message sender.
135    * @param operator The address which called `safeTransferFrom` function
136    * @param from The address which previously owned the token
137    * @param tokenId The NFT identifier which is being transferred
138    * @param data Additional data with no specified format
139    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
140    */
141   function onERC721Received(
142     address operator,
143     address from,
144     uint256 tokenId,
145     bytes data
146   )
147     public
148     returns(bytes4);
149 }
150 
151 contract IERC721 is IERC165 {
152 
153   event Transfer(
154     address indexed from,
155     address indexed to,
156     uint256 indexed tokenId
157   );
158   event Approval(
159     address indexed owner,
160     address indexed approved,
161     uint256 indexed tokenId
162   );
163   event ApprovalForAll(
164     address indexed owner,
165     address indexed operator,
166     bool approved
167   );
168 
169   function balanceOf(address owner) public view returns (uint256 balance);
170   function ownerOf(uint256 tokenId) public view returns (address owner);
171 
172   function approve(address to, uint256 tokenId) public;
173   function getApproved(uint256 tokenId)
174     public view returns (address operator);
175 
176   function setApprovalForAll(address operator, bool _approved) public;
177   function isApprovedForAll(address owner, address operator)
178     public view returns (bool);
179 
180   function transferFrom(address from, address to, uint256 tokenId) public;
181   function safeTransferFrom(address from, address to, uint256 tokenId)
182     public;
183 
184   function safeTransferFrom(
185     address from,
186     address to,
187     uint256 tokenId,
188     bytes data
189   )
190     public;
191 }
192 
193 contract IERC721Creator is IERC721 {
194     /**
195    * @dev Gets the creator of the token
196    * @param _tokenId uint256 ID of the token
197    * @return address of the creator
198    */
199     function tokenCreator(uint256 _tokenId) public view returns (address);
200 }
201 
202 /**
203  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
204  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
205  */
206 contract IERC721Metadata is IERC721 {
207   function name() external view returns (string);
208   function symbol() external view returns (string);
209   function tokenURI(uint256 tokenId) external view returns (string);
210 }
211 
212 /**
213  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
214  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
215  */
216 contract IERC721Enumerable is IERC721 {
217   function totalSupply() public view returns (uint256);
218   function tokenOfOwnerByIndex(
219     address owner,
220     uint256 index
221   )
222     public
223     view
224     returns (uint256 tokenId);
225 
226   function tokenByIndex(uint256 index) public view returns (uint256);
227 }
228 
229 /**
230  * Utility library of inline functions on addresses
231  */
232 library Address {
233 
234   /**
235    * Returns whether the target address is a contract
236    * @dev This function will return false if invoked during the constructor of a contract,
237    * as the code is not actually created until after the constructor finishes.
238    * @param account address of the account to check
239    * @return whether the target address is a contract
240    */
241   function isContract(address account) internal view returns (bool) {
242     uint256 size;
243     // XXX Currently there is no better way to check if there is a contract in an address
244     // than to check the size of the code at that address.
245     // See https://ethereum.stackexchange.com/a/14016/36603
246     // for more details about how this works.
247     // TODO Check this again before the Serenity release, because all addresses will be
248     // contracts then.
249     // solium-disable-next-line security/no-inline-assembly
250     assembly { size := extcodesize(account) }
251     return size > 0;
252   }
253 
254 }
255 
256 /**
257  * @title ERC165
258  * @author Matt Condon (@shrugs)
259  * @dev Implements ERC165 using a lookup table.
260  */
261 contract ERC165 is IERC165 {
262 
263   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
264   /**
265    * 0x01ffc9a7 ===
266    *   bytes4(keccak256('supportsInterface(bytes4)'))
267    */
268 
269   /**
270    * @dev a mapping of interface id to whether or not it's supported
271    */
272   mapping(bytes4 => bool) private _supportedInterfaces;
273 
274   /**
275    * @dev A contract implementing SupportsInterfaceWithLookup
276    * implement ERC165 itself
277    */
278   constructor()
279     internal
280   {
281     _registerInterface(_InterfaceId_ERC165);
282   }
283 
284   /**
285    * @dev implement supportsInterface(bytes4) using a lookup table
286    */
287   function supportsInterface(bytes4 interfaceId)
288     external
289     view
290     returns (bool)
291   {
292     return _supportedInterfaces[interfaceId];
293   }
294 
295   /**
296    * @dev internal method for registering an interface
297    */
298   function _registerInterface(bytes4 interfaceId)
299     internal
300   {
301     require(interfaceId != 0xffffffff);
302     _supportedInterfaces[interfaceId] = true;
303   }
304 }
305 
306 /**
307  * @title ERC721 Non-Fungible Token Standard basic implementation
308  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
309  */
310 contract ERC721 is ERC165, IERC721 {
311 
312   using SafeMath for uint256;
313   using Address for address;
314 
315   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
316   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
317   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
318 
319   // Mapping from token ID to owner
320   mapping (uint256 => address) private _tokenOwner;
321 
322   // Mapping from token ID to approved address
323   mapping (uint256 => address) private _tokenApprovals;
324 
325   // Mapping from owner to number of owned token
326   mapping (address => uint256) private _ownedTokensCount;
327 
328   // Mapping from owner to operator approvals
329   mapping (address => mapping (address => bool)) private _operatorApprovals;
330 
331   bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
332   /*
333    * 0x80ac58cd ===
334    *   bytes4(keccak256('balanceOf(address)')) ^
335    *   bytes4(keccak256('ownerOf(uint256)')) ^
336    *   bytes4(keccak256('approve(address,uint256)')) ^
337    *   bytes4(keccak256('getApproved(uint256)')) ^
338    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
339    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
340    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
341    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
342    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
343    */
344 
345   constructor()
346     public
347   {
348     // register the supported interfaces to conform to ERC721 via ERC165
349     _registerInterface(_InterfaceId_ERC721);
350   }
351 
352   /**
353    * @dev Gets the balance of the specified address
354    * @param owner address to query the balance of
355    * @return uint256 representing the amount owned by the passed address
356    */
357   function balanceOf(address owner) public view returns (uint256) {
358     require(owner != address(0));
359     return _ownedTokensCount[owner];
360   }
361 
362   /**
363    * @dev Gets the owner of the specified token ID
364    * @param tokenId uint256 ID of the token to query the owner of
365    * @return owner address currently marked as the owner of the given token ID
366    */
367   function ownerOf(uint256 tokenId) public view returns (address) {
368     address owner = _tokenOwner[tokenId];
369     require(owner != address(0));
370     return owner;
371   }
372 
373   /**
374    * @dev Approves another address to transfer the given token ID
375    * The zero address indicates there is no approved address.
376    * There can only be one approved address per token at a given time.
377    * Can only be called by the token owner or an approved operator.
378    * @param to address to be approved for the given token ID
379    * @param tokenId uint256 ID of the token to be approved
380    */
381   function approve(address to, uint256 tokenId) public {
382     address owner = ownerOf(tokenId);
383     require(to != owner);
384     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
385 
386     _tokenApprovals[tokenId] = to;
387     emit Approval(owner, to, tokenId);
388   }
389 
390   /**
391    * @dev Gets the approved address for a token ID, or zero if no address set
392    * Reverts if the token ID does not exist.
393    * @param tokenId uint256 ID of the token to query the approval of
394    * @return address currently approved for the given token ID
395    */
396   function getApproved(uint256 tokenId) public view returns (address) {
397     require(_exists(tokenId));
398     return _tokenApprovals[tokenId];
399   }
400 
401   /**
402    * @dev Sets or unsets the approval of a given operator
403    * An operator is allowed to transfer all tokens of the sender on their behalf
404    * @param to operator address to set the approval
405    * @param approved representing the status of the approval to be set
406    */
407   function setApprovalForAll(address to, bool approved) public {
408     require(to != msg.sender);
409     _operatorApprovals[msg.sender][to] = approved;
410     emit ApprovalForAll(msg.sender, to, approved);
411   }
412 
413   /**
414    * @dev Tells whether an operator is approved by a given owner
415    * @param owner owner address which you want to query the approval of
416    * @param operator operator address which you want to query the approval of
417    * @return bool whether the given operator is approved by the given owner
418    */
419   function isApprovedForAll(
420     address owner,
421     address operator
422   )
423     public
424     view
425     returns (bool)
426   {
427     return _operatorApprovals[owner][operator];
428   }
429 
430   /**
431    * @dev Transfers the ownership of a given token ID to another address
432    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
433    * Requires the msg sender to be the owner, approved, or operator
434    * @param from current owner of the token
435    * @param to address to receive the ownership of the given token ID
436    * @param tokenId uint256 ID of the token to be transferred
437   */
438   function transferFrom(
439     address from,
440     address to,
441     uint256 tokenId
442   )
443     public
444   {
445     require(_isApprovedOrOwner(msg.sender, tokenId));
446     require(to != address(0));
447 
448     _clearApproval(from, tokenId);
449     _removeTokenFrom(from, tokenId);
450     _addTokenTo(to, tokenId);
451 
452     emit Transfer(from, to, tokenId);
453   }
454 
455   /**
456    * @dev Safely transfers the ownership of a given token ID to another address
457    * If the target address is a contract, it must implement `onERC721Received`,
458    * which is called upon a safe transfer, and return the magic value
459    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
460    * the transfer is reverted.
461    *
462    * Requires the msg sender to be the owner, approved, or operator
463    * @param from current owner of the token
464    * @param to address to receive the ownership of the given token ID
465    * @param tokenId uint256 ID of the token to be transferred
466   */
467   function safeTransferFrom(
468     address from,
469     address to,
470     uint256 tokenId
471   )
472     public
473   {
474     // solium-disable-next-line arg-overflow
475     safeTransferFrom(from, to, tokenId, "");
476   }
477 
478   /**
479    * @dev Safely transfers the ownership of a given token ID to another address
480    * If the target address is a contract, it must implement `onERC721Received`,
481    * which is called upon a safe transfer, and return the magic value
482    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
483    * the transfer is reverted.
484    * Requires the msg sender to be the owner, approved, or operator
485    * @param from current owner of the token
486    * @param to address to receive the ownership of the given token ID
487    * @param tokenId uint256 ID of the token to be transferred
488    * @param _data bytes data to send along with a safe transfer check
489    */
490   function safeTransferFrom(
491     address from,
492     address to,
493     uint256 tokenId,
494     bytes _data
495   )
496     public
497   {
498     transferFrom(from, to, tokenId);
499     // solium-disable-next-line arg-overflow
500     require(_checkOnERC721Received(from, to, tokenId, _data));
501   }
502 
503   /**
504    * @dev Returns whether the specified token exists
505    * @param tokenId uint256 ID of the token to query the existence of
506    * @return whether the token exists
507    */
508   function _exists(uint256 tokenId) internal view returns (bool) {
509     address owner = _tokenOwner[tokenId];
510     return owner != address(0);
511   }
512 
513   /**
514    * @dev Returns whether the given spender can transfer a given token ID
515    * @param spender address of the spender to query
516    * @param tokenId uint256 ID of the token to be transferred
517    * @return bool whether the msg.sender is approved for the given token ID,
518    *  is an operator of the owner, or is the owner of the token
519    */
520   function _isApprovedOrOwner(
521     address spender,
522     uint256 tokenId
523   )
524     internal
525     view
526     returns (bool)
527   {
528     address owner = ownerOf(tokenId);
529     // Disable solium check because of
530     // https://github.com/duaraghav8/Solium/issues/175
531     // solium-disable-next-line operator-whitespace
532     return (
533       spender == owner ||
534       getApproved(tokenId) == spender ||
535       isApprovedForAll(owner, spender)
536     );
537   }
538 
539   /**
540    * @dev Internal function to mint a new token
541    * Reverts if the given token ID already exists
542    * @param to The address that will own the minted token
543    * @param tokenId uint256 ID of the token to be minted by the msg.sender
544    */
545   function _mint(address to, uint256 tokenId) internal {
546     require(to != address(0));
547     _addTokenTo(to, tokenId);
548     emit Transfer(address(0), to, tokenId);
549   }
550 
551   /**
552    * @dev Internal function to burn a specific token
553    * Reverts if the token does not exist
554    * @param tokenId uint256 ID of the token being burned by the msg.sender
555    */
556   function _burn(address owner, uint256 tokenId) internal {
557     _clearApproval(owner, tokenId);
558     _removeTokenFrom(owner, tokenId);
559     emit Transfer(owner, address(0), tokenId);
560   }
561 
562   /**
563    * @dev Internal function to add a token ID to the list of a given address
564    * Note that this function is left internal to make ERC721Enumerable possible, but is not
565    * intended to be called by custom derived contracts: in particular, it emits no Transfer event.
566    * @param to address representing the new owner of the given token ID
567    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
568    */
569   function _addTokenTo(address to, uint256 tokenId) internal {
570     require(_tokenOwner[tokenId] == address(0));
571     _tokenOwner[tokenId] = to;
572     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
573   }
574 
575   /**
576    * @dev Internal function to remove a token ID from the list of a given address
577    * Note that this function is left internal to make ERC721Enumerable possible, but is not
578    * intended to be called by custom derived contracts: in particular, it emits no Transfer event,
579    * and doesn't clear approvals.
580    * @param from address representing the previous owner of the given token ID
581    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
582    */
583   function _removeTokenFrom(address from, uint256 tokenId) internal {
584     require(ownerOf(tokenId) == from);
585     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
586     _tokenOwner[tokenId] = address(0);
587   }
588 
589   /**
590    * @dev Internal function to invoke `onERC721Received` on a target address
591    * The call is not executed if the target address is not a contract
592    * @param from address representing the previous owner of the given token ID
593    * @param to target address that will receive the tokens
594    * @param tokenId uint256 ID of the token to be transferred
595    * @param _data bytes optional data to send along with the call
596    * @return whether the call correctly returned the expected magic value
597    */
598   function _checkOnERC721Received(
599     address from,
600     address to,
601     uint256 tokenId,
602     bytes _data
603   )
604     internal
605     returns (bool)
606   {
607     if (!to.isContract()) {
608       return true;
609     }
610     bytes4 retval = IERC721Receiver(to).onERC721Received(
611       msg.sender, from, tokenId, _data);
612     return (retval == _ERC721_RECEIVED);
613   }
614 
615   /**
616    * @dev Private function to clear current approval of a given token ID
617    * Reverts if the given address is not indeed the owner of the token
618    * @param owner owner of the token
619    * @param tokenId uint256 ID of the token to be transferred
620    */
621   function _clearApproval(address owner, uint256 tokenId) private {
622     require(ownerOf(tokenId) == owner);
623     if (_tokenApprovals[tokenId] != address(0)) {
624       _tokenApprovals[tokenId] = address(0);
625     }
626   }
627 }
628 
629 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
630   // Mapping from owner to list of owned token IDs
631   mapping(address => uint256[]) private _ownedTokens;
632 
633   // Mapping from token ID to index of the owner tokens list
634   mapping(uint256 => uint256) private _ownedTokensIndex;
635 
636   // Array with all token ids, used for enumeration
637   uint256[] private _allTokens;
638 
639   // Mapping from token id to position in the allTokens array
640   mapping(uint256 => uint256) private _allTokensIndex;
641 
642   bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;
643   /**
644    * 0x780e9d63 ===
645    *   bytes4(keccak256('totalSupply()')) ^
646    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
647    *   bytes4(keccak256('tokenByIndex(uint256)'))
648    */
649 
650   /**
651    * @dev Constructor function
652    */
653   constructor() public {
654     // register the supported interface to conform to ERC721 via ERC165
655     _registerInterface(_InterfaceId_ERC721Enumerable);
656   }
657 
658   /**
659    * @dev Gets the token ID at a given index of the tokens list of the requested owner
660    * @param owner address owning the tokens list to be accessed
661    * @param index uint256 representing the index to be accessed of the requested tokens list
662    * @return uint256 token ID at the given index of the tokens list owned by the requested address
663    */
664   function tokenOfOwnerByIndex(
665     address owner,
666     uint256 index
667   )
668     public
669     view
670     returns (uint256)
671   {
672     require(index < balanceOf(owner));
673     return _ownedTokens[owner][index];
674   }
675 
676   /**
677    * @dev Gets the total amount of tokens stored by the contract
678    * @return uint256 representing the total amount of tokens
679    */
680   function totalSupply() public view returns (uint256) {
681     return _allTokens.length;
682   }
683 
684   /**
685    * @dev Gets the token ID at a given index of all the tokens in this contract
686    * Reverts if the index is greater or equal to the total number of tokens
687    * @param index uint256 representing the index to be accessed of the tokens list
688    * @return uint256 token ID at the given index of the tokens list
689    */
690   function tokenByIndex(uint256 index) public view returns (uint256) {
691     require(index < totalSupply());
692     return _allTokens[index];
693   }
694 
695   /**
696    * @dev Internal function to add a token ID to the list of a given address
697    * This function is internal due to language limitations, see the note in ERC721.sol.
698    * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event.
699    * @param to address representing the new owner of the given token ID
700    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
701    */
702   function _addTokenTo(address to, uint256 tokenId) internal {
703     super._addTokenTo(to, tokenId);
704     uint256 length = _ownedTokens[to].length;
705     _ownedTokens[to].push(tokenId);
706     _ownedTokensIndex[tokenId] = length;
707   }
708 
709   /**
710    * @dev Internal function to remove a token ID from the list of a given address
711    * This function is internal due to language limitations, see the note in ERC721.sol.
712    * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event,
713    * and doesn't clear approvals.
714    * @param from address representing the previous owner of the given token ID
715    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
716    */
717   function _removeTokenFrom(address from, uint256 tokenId) internal {
718     super._removeTokenFrom(from, tokenId);
719 
720     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
721     // then delete the last slot.
722     uint256 tokenIndex = _ownedTokensIndex[tokenId];
723     uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
724     uint256 lastToken = _ownedTokens[from][lastTokenIndex];
725 
726     _ownedTokens[from][tokenIndex] = lastToken;
727     // This also deletes the contents at the last position of the array
728     _ownedTokens[from].length--;
729 
730     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
731     // be zero. Then we can make sure that we will remove tokenId from the ownedTokens list since we are first swapping
732     // the lastToken to the first position, and then dropping the element placed in the last position of the list
733 
734     _ownedTokensIndex[tokenId] = 0;
735     _ownedTokensIndex[lastToken] = tokenIndex;
736   }
737 
738   /**
739    * @dev Internal function to mint a new token
740    * Reverts if the given token ID already exists
741    * @param to address the beneficiary that will own the minted token
742    * @param tokenId uint256 ID of the token to be minted by the msg.sender
743    */
744   function _mint(address to, uint256 tokenId) internal {
745     super._mint(to, tokenId);
746 
747     _allTokensIndex[tokenId] = _allTokens.length;
748     _allTokens.push(tokenId);
749   }
750 
751   /**
752    * @dev Internal function to burn a specific token
753    * Reverts if the token does not exist
754    * @param owner owner of the token to burn
755    * @param tokenId uint256 ID of the token being burned by the msg.sender
756    */
757   function _burn(address owner, uint256 tokenId) internal {
758     super._burn(owner, tokenId);
759 
760     // Reorg all tokens array
761     uint256 tokenIndex = _allTokensIndex[tokenId];
762     uint256 lastTokenIndex = _allTokens.length.sub(1);
763     uint256 lastToken = _allTokens[lastTokenIndex];
764 
765     _allTokens[tokenIndex] = lastToken;
766     _allTokens[lastTokenIndex] = 0;
767 
768     _allTokens.length--;
769     _allTokensIndex[tokenId] = 0;
770     _allTokensIndex[lastToken] = tokenIndex;
771   }
772 }
773 
774 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
775   // Token name
776   string private _name;
777 
778   // Token symbol
779   string private _symbol;
780 
781   // Optional mapping for token URIs
782   mapping(uint256 => string) private _tokenURIs;
783 
784   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
785   /**
786    * 0x5b5e139f ===
787    *   bytes4(keccak256('name()')) ^
788    *   bytes4(keccak256('symbol()')) ^
789    *   bytes4(keccak256('tokenURI(uint256)'))
790    */
791 
792   /**
793    * @dev Constructor function
794    */
795   constructor(string name, string symbol) public {
796     _name = name;
797     _symbol = symbol;
798 
799     // register the supported interfaces to conform to ERC721 via ERC165
800     _registerInterface(InterfaceId_ERC721Metadata);
801   }
802 
803   /**
804    * @dev Gets the token name
805    * @return string representing the token name
806    */
807   function name() external view returns (string) {
808     return _name;
809   }
810 
811   /**
812    * @dev Gets the token symbol
813    * @return string representing the token symbol
814    */
815   function symbol() external view returns (string) {
816     return _symbol;
817   }
818 
819   /**
820    * @dev Returns an URI for a given token ID
821    * Throws if the token ID does not exist. May return an empty string.
822    * @param tokenId uint256 ID of the token to query
823    */
824   function tokenURI(uint256 tokenId) external view returns (string) {
825     require(_exists(tokenId));
826     return _tokenURIs[tokenId];
827   }
828 
829   /**
830    * @dev Internal function to set the token URI for a given token
831    * Reverts if the token ID does not exist
832    * @param tokenId uint256 ID of the token to set its URI
833    * @param uri string URI to assign
834    */
835   function _setTokenURI(uint256 tokenId, string uri) internal {
836     require(_exists(tokenId));
837     _tokenURIs[tokenId] = uri;
838   }
839 
840   /**
841    * @dev Internal function to burn a specific token
842    * Reverts if the token does not exist
843    * @param owner owner of the token to burn
844    * @param tokenId uint256 ID of the token being burned by the msg.sender
845    */
846   function _burn(address owner, uint256 tokenId) internal {
847     super._burn(owner, tokenId);
848 
849     // Clear metadata (if any)
850     if (bytes(_tokenURIs[tokenId]).length != 0) {
851       delete _tokenURIs[tokenId];
852     }
853   }
854 }
855 
856 /**
857  * @title Ownable
858  * @dev The Ownable contract has an owner address, and provides basic authorization control
859  * functions, this simplifies the implementation of "user permissions".
860  */
861 contract Ownable {
862   address private _owner;
863 
864   event OwnershipTransferred(
865     address indexed previousOwner,
866     address indexed newOwner
867   );
868 
869   /**
870    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
871    * account.
872    */
873   constructor() internal {
874     _owner = msg.sender;
875     emit OwnershipTransferred(address(0), _owner);
876   }
877 
878   /**
879    * @return the address of the owner.
880    */
881   function owner() public view returns(address) {
882     return _owner;
883   }
884 
885   /**
886    * @dev Throws if called by any account other than the owner.
887    */
888   modifier onlyOwner() {
889     require(isOwner());
890     _;
891   }
892 
893   /**
894    * @return true if `msg.sender` is the owner of the contract.
895    */
896   function isOwner() public view returns(bool) {
897     return msg.sender == _owner;
898   }
899 
900   /**
901    * @dev Allows the current owner to relinquish control of the contract.
902    * @notice Renouncing to ownership will leave the contract without an owner.
903    * It will not be possible to call the functions with the `onlyOwner`
904    * modifier anymore.
905    */
906   function renounceOwnership() public onlyOwner {
907     emit OwnershipTransferred(_owner, address(0));
908     _owner = address(0);
909   }
910 
911   /**
912    * @dev Allows the current owner to transfer control of the contract to a newOwner.
913    * @param newOwner The address to transfer ownership to.
914    */
915   function transferOwnership(address newOwner) public onlyOwner {
916     _transferOwnership(newOwner);
917   }
918 
919   /**
920    * @dev Transfers control of the contract to a newOwner.
921    * @param newOwner The address to transfer ownership to.
922    */
923   function _transferOwnership(address newOwner) internal {
924     require(newOwner != address(0));
925     emit OwnershipTransferred(_owner, newOwner);
926     _owner = newOwner;
927   }
928 }
929 
930 contract Whitelist is Ownable {
931     // Mapping of address to boolean indicating whether the address is whitelisted
932     mapping(address => bool) private whitelistMap;
933 
934     // flag controlling whether whitelist is enabled.
935     bool private whitelistEnabled = true;
936 
937     event AddToWhitelist(address indexed _newAddress);
938     event RemoveFromWhitelist(address indexed _removedAddress);
939 
940     /**
941    * @dev Enable or disable the whitelist
942    * @param _enabled bool of whether to enable the whitelist.
943    */
944     function enableWhitelist(bool _enabled) public onlyOwner {
945         whitelistEnabled = _enabled;
946     }
947 
948     /**
949    * @dev Adds the provided address to the whitelist
950    * @param _newAddress address to be added to the whitelist
951    */
952     function addToWhitelist(address _newAddress) public onlyOwner {
953         _whitelist(_newAddress);
954         emit AddToWhitelist(_newAddress);
955     }
956 
957     /**
958    * @dev Removes the provided address to the whitelist
959    * @param _removedAddress address to be removed from the whitelist
960    */
961     function removeFromWhitelist(address _removedAddress) public onlyOwner {
962         _unWhitelist(_removedAddress);
963         emit RemoveFromWhitelist(_removedAddress);
964     }
965 
966     /**
967    * @dev Returns whether the address is whitelisted
968    * @param _address address to check
969    * @return bool
970    */
971     function isWhitelisted(address _address) public view returns (bool) {
972         if (whitelistEnabled) {
973             return whitelistMap[_address];
974         } else {
975             return true;
976         }
977     }
978 
979     /**
980    * @dev Internal function for removing an address from the whitelist
981    * @param _removedAddress address to unwhitelisted
982    */
983     function _unWhitelist(address _removedAddress) internal {
984         whitelistMap[_removedAddress] = false;
985     }
986 
987     /**
988    * @dev Internal function for adding the provided address to the whitelist
989    * @param _newAddress address to be added to the whitelist
990    */
991     function _whitelist(address _newAddress) internal {
992         whitelistMap[_newAddress] = true;
993     }
994 }
995 
996 /**
997  * @title Full ERC721 Token
998  * This implementation includes all the required and some optional functionality of the ERC721 standard
999  * Moreover, it includes approve all functionality using operator terminology
1000  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1001  */
1002 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1003   constructor(string name, string symbol) ERC721Metadata(name, symbol)
1004     public
1005   {
1006   }
1007 }
1008 
1009 
1010 contract SuperRareV2 is ERC721Full, IERC721Creator, Ownable, Whitelist {
1011     using SafeMath for uint256;
1012 
1013     // Mapping from token ID to the creator's address.
1014     mapping(uint256 => address) private tokenCreators;
1015 
1016     // Counter for creating token IDs
1017     uint256 private idCounter;
1018 
1019     // Old SuperRare contract to look up token details.
1020     ISuperRare private oldSuperRare;
1021 
1022     // Event indicating metadata was updated.
1023     event TokenURIUpdated(uint256 indexed _tokenId, string  _uri);
1024 
1025     constructor(
1026       string _name,
1027       string _symbol,
1028       address _oldSuperRare
1029     )
1030     ERC721Full(_name, _symbol)
1031     {
1032       // Get reference to old SR contract.
1033       oldSuperRare = ISuperRare(_oldSuperRare);
1034 
1035       uint256 oldSupply = oldSuperRare.totalSupply();
1036       // Set id counter to be continuous with SuperRare.
1037       idCounter = oldSupply + 1;
1038     }
1039 
1040     /**
1041      * @dev Whitelists a bunch of addresses.
1042      * @param _whitelistees address[] of addresses to whitelist.
1043      */
1044     function initWhitelist(address[] _whitelistees) public onlyOwner {
1045       // Add all whitelistees.
1046       for (uint256 i = 0; i < _whitelistees.length; i++) {
1047         address creator = _whitelistees[i];
1048         if (!isWhitelisted(creator)) {
1049           _whitelist(creator);
1050         }
1051       }
1052     }
1053 
1054     /**
1055      * @dev Checks that the token is owned by the sender.
1056      * @param _tokenId uint256 ID of the token.
1057      */
1058     modifier onlyTokenOwner(uint256 _tokenId) {
1059       address owner = ownerOf(_tokenId);
1060       require(owner == msg.sender, "must be the owner of the token");
1061       _;
1062     }
1063 
1064     /**
1065      * @dev Checks that the token was created by the sender.
1066      * @param _tokenId uint256 ID of the token.
1067      */
1068     modifier onlyTokenCreator(uint256 _tokenId) {
1069       address creator = tokenCreator(_tokenId);
1070       require(creator == msg.sender, "must be the creator of the token");
1071       _;
1072     }
1073 
1074     /**
1075      * @dev Adds a new unique token to the supply.
1076      * @param _uri string metadata uri associated with the token.
1077      */
1078     function addNewToken(string _uri) public {
1079       require(isWhitelisted(msg.sender), "must be whitelisted to create tokens");
1080       _createToken(_uri, msg.sender);
1081     }
1082 
1083     /**
1084      * @dev Deletes the token with the provided ID.
1085      * @param _tokenId uint256 ID of the token.
1086      */
1087     function deleteToken(uint256 _tokenId) public onlyTokenOwner(_tokenId) {
1088       _burn(msg.sender, _tokenId);
1089     }
1090 
1091     /**
1092      * @dev Updates the token metadata if the owner is also the
1093      *      creator.
1094      * @param _tokenId uint256 ID of the token.
1095      * @param _uri string metadata URI.
1096      */
1097     function updateTokenMetadata(uint256 _tokenId, string _uri)
1098       public
1099       onlyTokenOwner(_tokenId)
1100       onlyTokenCreator(_tokenId)
1101     {
1102       _setTokenURI(_tokenId, _uri);
1103       emit TokenURIUpdated(_tokenId, _uri);
1104     }
1105 
1106     /**
1107     * @dev Gets the creator of the token.
1108     * @param _tokenId uint256 ID of the token.
1109     * @return address of the creator.
1110     */
1111     function tokenCreator(uint256 _tokenId) public view returns (address) {
1112         return tokenCreators[_tokenId];
1113     }
1114 
1115     /**
1116      * @dev Internal function for setting the token's creator.
1117      * @param _tokenId uint256 id of the token.
1118      * @param _creator address of the creator of the token.
1119      */
1120     function _setTokenCreator(uint256 _tokenId, address _creator) internal {
1121       tokenCreators[_tokenId] = _creator;
1122     }
1123 
1124     /**
1125      * @dev Internal function creating a new token.
1126      * @param _uri string metadata uri associated with the token
1127      * @param _creator address of the creator of the token.
1128      */
1129     function _createToken(string _uri, address _creator) internal returns (uint256) {
1130       uint256 newId = idCounter;
1131       idCounter++;
1132       _mint(_creator, newId);
1133       _setTokenURI(newId, _uri);
1134       _setTokenCreator(newId, _creator);
1135       return newId;
1136     }
1137 }