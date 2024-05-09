1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title IERC165
5  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
6  */
7 interface IERC165 {
8 
9   /**
10    * @notice Query if a contract implements an interface
11    * @param interfaceId The interface identifier, as specified in ERC-165
12    * @dev Interface identification is specified in ERC-165. This function
13    * uses less than 30,000 gas.
14    */
15   function supportsInterface(bytes4 interfaceId)
16     external
17     view
18     returns (bool);
19 }
20 
21 
22 
23 /**
24  * @title ERC165
25  * @author Matt Condon (@shrugs)
26  * @dev Implements ERC165 using a lookup table.
27  */
28 contract ERC165 is IERC165 {
29 
30   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
31   /**
32    * 0x01ffc9a7 ===
33    *   bytes4(keccak256('supportsInterface(bytes4)'))
34    */
35 
36   /**
37    * @dev a mapping of interface id to whether or not it's supported
38    */
39   mapping(bytes4 => bool) private _supportedInterfaces;
40 
41   /**
42    * @dev A contract implementing SupportsInterfaceWithLookup
43    * implement ERC165 itself
44    */
45   constructor()
46     internal
47   {
48     _registerInterface(_InterfaceId_ERC165);
49   }
50 
51   /**
52    * @dev implement supportsInterface(bytes4) using a lookup table
53    */
54   function supportsInterface(bytes4 interfaceId)
55     external
56     view
57     returns (bool)
58   {
59     return _supportedInterfaces[interfaceId];
60   }
61 
62   /**
63    * @dev internal method for registering an interface
64    */
65   function _registerInterface(bytes4 interfaceId)
66     internal
67   {
68     require(interfaceId != 0xffffffff);
69     _supportedInterfaces[interfaceId] = true;
70   }
71 }
72 
73 
74 
75 
76 /**
77  * @title ERC721 Non-Fungible Token Standard basic interface
78  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
79  */
80 contract IERC721 is IERC165 {
81 
82   event Transfer(
83     address indexed from,
84     address indexed to,
85     uint256 indexed tokenId
86   );
87   event Approval(
88     address indexed owner,
89     address indexed approved,
90     uint256 indexed tokenId
91   );
92   event ApprovalForAll(
93     address indexed owner,
94     address indexed operator,
95     bool approved
96   );
97 
98   function balanceOf(address owner) public view returns (uint256 balance);
99   function ownerOf(uint256 tokenId) public view returns (address owner);
100 
101   function approve(address to, uint256 tokenId) public;
102   function getApproved(uint256 tokenId)
103     public view returns (address operator);
104 
105   function setApprovalForAll(address operator, bool _approved) public;
106   function isApprovedForAll(address owner, address operator)
107     public view returns (bool);
108 
109   /*function transferFrom(address from, address to, uint256 tokenId) public;*/
110   /*function safeTransferFrom(address from, address to, uint256 tokenId)
111     public;*/
112 
113   /*function safeTransferFrom(
114     address from,
115     address to,
116     uint256 tokenId,
117     bytes data
118   )
119     public;*/
120 }
121 
122 
123 /**
124  * @title ERC721 token receiver interface
125  * @dev Interface for any contract that wants to support safeTransfers
126  * from ERC721 asset contracts.
127  */
128 contract IERC721Receiver {
129   /**
130    * @notice Handle the receipt of an NFT
131    * @dev The ERC721 smart contract calls this function on the recipient
132    * after a `safeTransfer`. This function MUST return the function selector,
133    * otherwise the caller will revert the transaction. The selector to be
134    * returned can be obtained as `this.onERC721Received.selector`. This
135    * function MAY throw to revert and reject the transfer.
136    * Note: the ERC721 contract address is always the message sender.
137    * @param operator The address which called `safeTransferFrom` function
138    * @param from The address which previously owned the token
139    * @param tokenId The NFT identifier which is being transferred
140    * @param data Additional data with no specified format
141    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
142    */
143   function onERC721Received(
144     address operator,
145     address from,
146     uint256 tokenId,
147     bytes data
148   )
149     public
150     returns(bytes4);
151 }
152 
153 
154 /**
155  * @title SafeMath
156  * @dev Math operations with safety checks that revert on error
157  */
158 library SafeMath {
159 
160   /**
161   * @dev Multiplies two numbers, reverts on overflow.
162   */
163   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
164     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
165     // benefit is lost if 'b' is also tested.
166     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
167     if (a == 0) {
168       return 0;
169     }
170 
171     uint256 c = a * b;
172     require(c / a == b);
173 
174     return c;
175   }
176 
177   /**
178   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
179   */
180   function div(uint256 a, uint256 b) internal pure returns (uint256) {
181     require(b > 0); // Solidity only automatically asserts when dividing by 0
182     uint256 c = a / b;
183     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
184 
185     return c;
186   }
187 
188   /**
189   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
190   */
191   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
192     require(b <= a);
193     uint256 c = a - b;
194 
195     return c;
196   }
197 
198   /**
199   * @dev Adds two numbers, reverts on overflow.
200   */
201   function add(uint256 a, uint256 b) internal pure returns (uint256) {
202     uint256 c = a + b;
203     require(c >= a);
204 
205     return c;
206   }
207 
208   /**
209   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
210   * reverts when dividing by zero.
211   */
212   /*
213   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
214     require(b != 0);
215     return a % b;
216   }
217   */
218 }
219 
220 
221 /**
222  * Utility library of inline functions on addresses
223  */
224 library Address {
225 
226   /**
227    * Returns whether the target address is a contract
228    * @dev This function will return false if invoked during the constructor of a contract,
229    * as the code is not actually created until after the constructor finishes.
230    * @param account address of the account to check
231    * @return whether the target address is a contract
232    */
233   function isContract(address account) internal view returns (bool) {
234     uint256 size;
235     // XXX Currently there is no better way to check if there is a contract in an address
236     // than to check the size of the code at that address.
237     // See https://ethereum.stackexchange.com/a/14016/36603
238     // for more details about how this works.
239     // TODO Check this again before the Serenity release, because all addresses will be
240     // contracts then.
241     // solium-disable-next-line security/no-inline-assembly
242     assembly { size := extcodesize(account) }
243     return size > 0;
244   }
245 
246 }
247 
248 
249 /**
250  * @title ERC721 Non-Fungible Token Standard basic implementation
251  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
252  */
253 contract ERC721_custom is ERC165, IERC721 {
254 
255   using SafeMath for uint256;
256   using Address for address;
257 
258   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
259   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
260   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
261 
262   // Mapping from token ID to owner
263   mapping (uint256 => address) private _tokenOwner;
264 
265   // Mapping from token ID to approved address
266   mapping (uint256 => address) private _tokenApprovals;
267 
268   // Mapping from owner to number of owned token
269   mapping (address => uint256) private _ownedTokensCount;
270 
271   // Mapping from owner to operator approvals
272   mapping (address => mapping (address => bool)) private _operatorApprovals;
273 
274   bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
275   /*
276    * 0x80ac58cd ===
277    *   bytes4(keccak256('balanceOf(address)')) ^
278    *   bytes4(keccak256('ownerOf(uint256)')) ^
279    *   bytes4(keccak256('approve(address,uint256)')) ^
280    *   bytes4(keccak256('getApproved(uint256)')) ^
281    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
282    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
283    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
284    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
285    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
286    */
287 
288   constructor()
289     public
290   {
291     // register the supported interfaces to conform to ERC721 via ERC165
292     _registerInterface(_InterfaceId_ERC721);
293   }
294 
295   /**
296    * @dev Gets the balance of the specified address
297    * @param owner address to query the balance of
298    * @return uint256 representing the amount owned by the passed address
299    */
300   function balanceOf(address owner) public view returns (uint256) {
301     require(owner != address(0));
302     return _ownedTokensCount[owner];
303   }
304 
305   /**
306    * @dev Gets the owner of the specified token ID
307    * @param tokenId uint256 ID of the token to query the owner of
308    * @return owner address currently marked as the owner of the given token ID
309    */
310   function ownerOf(uint256 tokenId) public view returns (address) {
311     address owner = _tokenOwner[tokenId];
312     require(owner != address(0));
313     return owner;
314   }
315 
316   /**
317    * @dev Approves another address to transfer the given token ID
318    * The zero address indicates there is no approved address.
319    * There can only be one approved address per token at a given time.
320    * Can only be called by the token owner or an approved operator.
321    * @param to address to be approved for the given token ID
322    * @param tokenId uint256 ID of the token to be approved
323    */
324   function approve(address to, uint256 tokenId) public {
325     address owner = ownerOf(tokenId);
326     require(to != owner);
327     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
328 
329     _tokenApprovals[tokenId] = to;
330     emit Approval(owner, to, tokenId);
331   }
332 
333   /**
334    * @dev Gets the approved address for a token ID, or zero if no address set
335    * Reverts if the token ID does not exist.
336    * @param tokenId uint256 ID of the token to query the approval of
337    * @return address currently approved for the given token ID
338    */
339   function getApproved(uint256 tokenId) public view returns (address) {
340     require(_exists(tokenId));
341     return _tokenApprovals[tokenId];
342   }
343 
344   /**
345    * @dev Sets or unsets the approval of a given operator
346    * An operator is allowed to transfer all tokens of the sender on their behalf
347    * @param to operator address to set the approval
348    * @param approved representing the status of the approval to be set
349    */
350   function setApprovalForAll(address to, bool approved) public {
351     require(to != msg.sender);
352     _operatorApprovals[msg.sender][to] = approved;
353     emit ApprovalForAll(msg.sender, to, approved);
354   }
355 
356   /**
357    * @dev Tells whether an operator is approved by a given owner
358    * @param owner owner address which you want to query the approval of
359    * @param operator operator address which you want to query the approval of
360    * @return bool whether the given operator is approved by the given owner
361    */
362   function isApprovedForAll(
363     address owner,
364     address operator
365   )
366     public
367     view
368     returns (bool)
369   {
370     return _operatorApprovals[owner][operator];
371   }
372 
373   /**
374    * @dev Transfers the ownership of a given token ID to another address
375    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
376    * Requires the msg sender to be the owner, approved, or operator
377    * @param from current owner of the token
378    * @param to address to receive the ownership of the given token ID
379    * @param tokenId uint256 ID of the token to be transferred
380   */
381   function transferFrom(
382     address from,
383     address to,
384     uint256 tokenId
385   )
386     public
387   {
388     require(_isApprovedOrOwner(msg.sender, tokenId));
389   //  require(to != address(0));
390 
391     _clearApproval(from, tokenId);
392     _removeTokenFrom(from, tokenId);
393     _addTokenTo(to, tokenId);
394 
395     emit Transfer(from, to, tokenId);
396   }
397   
398   
399   
400   
401     function internal_transferFrom(
402         address _from,
403         address to,
404         uint256 tokenId
405     )
406     internal
407   {
408     // permissions already checked on price basis
409     
410    // require(to != address(0));
411 
412     if (_tokenApprovals[tokenId] != address(0)) {
413       _tokenApprovals[tokenId] = address(0);
414     }
415     
416     //_removeTokenFrom(from, tokenId);
417     if(_ownedTokensCount[_from] > 1) {
418     _ownedTokensCount[_from] = _ownedTokensCount[_from] -1; //.sub(1); // error here
419     // works without .sub()????
420     
421     }
422     _tokenOwner[tokenId] = address(0); 
423     
424     _addTokenTo(to, tokenId); // error here?
425 
426     emit Transfer(_from, to, tokenId);
427     
428   }
429 
430   /**
431    * @dev Safely transfers the ownership of a given token ID to another address
432    * If the target address is a contract, it must implement `onERC721Received`,
433    * which is called upon a safe transfer, and return the magic value
434    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
435    * the transfer is reverted.
436    *
437    * Requires the msg sender to be the owner, approved, or operator
438    * @param from current owner of the token
439    * @param to address to receive the ownership of the given token ID
440    * @param tokenId uint256 ID of the token to be transferred
441   */
442   /*function safeTransferFrom(
443     address from,
444     address to,
445     uint256 tokenId
446   )
447     public
448   {
449     // solium-disable-next-line arg-overflow
450     safeTransferFrom(from, to, tokenId, "");
451   }*/
452 
453   /**
454    * @dev Safely transfers the ownership of a given token ID to another address
455    * If the target address is a contract, it must implement `onERC721Received`,
456    * which is called upon a safe transfer, and return the magic value
457    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
458    * the transfer is reverted.
459    * Requires the msg sender to be the owner, approved, or operator
460    * @param from current owner of the token
461    * @param to address to receive the ownership of the given token ID
462    * @param tokenId uint256 ID of the token to be transferred
463    * @param _data bytes data to send along with a safe transfer check
464    */
465   /*function safeTransferFrom(
466     address from,
467     address to,
468     uint256 tokenId,
469     bytes _data
470   )
471     public
472   {
473     transferFrom(from, to, tokenId);
474     // solium-disable-next-line arg-overflow
475     require(_checkOnERC721Received(from, to, tokenId, _data));
476   }*/
477 
478   /**
479    * @dev Returns whether the specified token exists
480    * @param tokenId uint256 ID of the token to query the existence of
481    * @return whether the token exists
482    */
483   function _exists(uint256 tokenId) internal view returns (bool) {
484     address owner = _tokenOwner[tokenId];
485     return owner != address(0);
486   }
487 
488   /**
489    * @dev Returns whether the given spender can transfer a given token ID
490    * @param spender address of the spender to query
491    * @param tokenId uint256 ID of the token to be transferred
492    * @return bool whether the msg.sender is approved for the given token ID,
493    *  is an operator of the owner, or is the owner of the token
494    */
495   function _isApprovedOrOwner(
496     address spender,
497     uint256 tokenId
498   )
499     internal
500     view
501     returns (bool)
502   {
503     address owner = ownerOf(tokenId);
504     // Disable solium check because of
505     // https://github.com/duaraghav8/Solium/issues/175
506     // solium-disable-next-line operator-whitespace
507     return (
508       spender == owner ||
509       getApproved(tokenId) == spender ||
510       isApprovedForAll(owner, spender)
511     );
512   }
513 
514   /**
515    * @dev Internal function to mint a new token
516    * Reverts if the given token ID already exists
517    * @param to The address that will own the minted token
518    * @param tokenId uint256 ID of the token to be minted by the msg.sender
519    */
520   function _mint(address to, uint256 tokenId) internal {
521     require(to != address(0));
522     _addTokenTo(to, tokenId);
523     emit Transfer(address(0), to, tokenId);
524   }
525 
526   /**
527    * @dev Internal function to burn a specific token
528    * Reverts if the token does not exist
529    * @param tokenId uint256 ID of the token being burned by the msg.sender
530    */
531   function _burn(address owner, uint256 tokenId) internal {
532     _clearApproval(owner, tokenId);
533     _removeTokenFrom(owner, tokenId);
534     emit Transfer(owner, address(0), tokenId);
535   }
536 
537   /**
538    * @dev Internal function to add a token ID to the list of a given address
539    * Note that this function is left internal to make ERC721Enumerable possible, but is not
540    * intended to be called by custom derived contracts: in particular, it emits no Transfer event.
541    * @param to address representing the new owner of the given token ID
542    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
543    */
544   function _addTokenTo(address to, uint256 tokenId) internal {
545     require(_tokenOwner[tokenId] == address(0));
546     _tokenOwner[tokenId] = to;
547     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
548   }
549 
550   /**
551    * @dev Internal function to remove a token ID from the list of a given address
552    * Note that this function is left internal to make ERC721Enumerable possible, but is not
553    * intended to be called by custom derived contracts: in particular, it emits no Transfer event,
554    * and doesn't clear approvals.
555    * @param from address representing the previous owner of the given token ID
556    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
557    */
558   function _removeTokenFrom(address from, uint256 tokenId) internal {
559     require(ownerOf(tokenId) == from);
560     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
561     _tokenOwner[tokenId] = address(0);
562   }
563   
564   
565 
566   /**
567    * @dev Internal function to invoke `onERC721Received` on a target address
568    * The call is not executed if the target address is not a contract
569    * @param from address representing the previous owner of the given token ID
570    * @param to target address that will receive the tokens
571    * @param tokenId uint256 ID of the token to be transferred
572    * @param _data bytes optional data to send along with the call
573    * @return whether the call correctly returned the expected magic value
574    */
575   function _checkOnERC721Received(
576     address from,
577     address to,
578     uint256 tokenId,
579     bytes _data
580   )
581     internal
582     returns (bool)
583   {
584     if (!to.isContract()) {
585       return true;
586     }
587     bytes4 retval = IERC721Receiver(to).onERC721Received(
588       msg.sender, from, tokenId, _data);
589     return (retval == _ERC721_RECEIVED);
590   }
591 
592   /**
593    * @dev Private function to clear current approval of a given token ID
594    * Reverts if the given address is not indeed the owner of the token
595    * @param owner owner of the token
596    * @param tokenId uint256 ID of the token to be transferred
597    */
598   function _clearApproval(address owner, uint256 tokenId) private {
599     require(ownerOf(tokenId) == owner);
600     if (_tokenApprovals[tokenId] != address(0)) {
601       _tokenApprovals[tokenId] = address(0);
602     }
603   }
604 }
605 
606 
607 
608 
609 /**
610  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
611  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
612  */
613 contract IERC721Enumerable is IERC721 {
614   function totalSupply() public view returns (uint256);
615   function tokenOfOwnerByIndex(
616     address owner,
617     uint256 index
618   )
619     public
620     view
621     returns (uint256 tokenId);
622 
623   function tokenByIndex(uint256 index) public view returns (uint256);
624 }
625 
626 
627 
628 /**
629  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
630  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
631  */
632 contract ERC721Enumerable_custom is ERC165, ERC721_custom, IERC721Enumerable {
633   // Mapping from owner to list of owned token IDs
634   mapping(address => uint256[]) private _ownedTokens;
635 
636   // Mapping from token ID to index of the owner tokens list
637   mapping(uint256 => uint256) private _ownedTokensIndex;
638 
639   // Array with all token ids, used for enumeration
640   uint256[] private _allTokens;
641 
642   // Mapping from token id to position in the allTokens array
643   mapping(uint256 => uint256) private _allTokensIndex;
644 
645   bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;
646   /**
647    * 0x780e9d63 ===
648    *   bytes4(keccak256('totalSupply()')) ^
649    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
650    *   bytes4(keccak256('tokenByIndex(uint256)'))
651    */
652 
653   /**
654    * @dev Constructor function
655    */
656   constructor() public {
657     // register the supported interface to conform to ERC721 via ERC165
658     _registerInterface(_InterfaceId_ERC721Enumerable);
659   }
660 
661   /**
662    * @dev Gets the token ID at a given index of the tokens list of the requested owner
663    * @param owner address owning the tokens list to be accessed
664    * @param index uint256 representing the index to be accessed of the requested tokens list
665    * @return uint256 token ID at the given index of the tokens list owned by the requested address
666    */
667   function tokenOfOwnerByIndex(
668     address owner,
669     uint256 index
670   )
671     public
672     view
673     returns (uint256)
674   {
675     require(index < balanceOf(owner));
676     return _ownedTokens[owner][index];
677   }
678 
679   /**
680    * @dev Gets the total amount of tokens stored by the contract
681    * @return uint256 representing the total amount of tokens
682    */
683   function totalSupply() public view returns (uint256) {
684     return _allTokens.length;
685   }
686 
687   /**
688    * @dev Gets the token ID at a given index of all the tokens in this contract
689    * Reverts if the index is greater or equal to the total number of tokens
690    * @param index uint256 representing the index to be accessed of the tokens list
691    * @return uint256 token ID at the given index of the tokens list
692    */
693   function tokenByIndex(uint256 index) public view returns (uint256) {
694     require(index < totalSupply());
695     return _allTokens[index];
696   }
697 
698   /**
699    * @dev Internal function to add a token ID to the list of a given address
700    * This function is internal due to language limitations, see the note in ERC721.sol.
701    * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event.
702    * @param to address representing the new owner of the given token ID
703    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
704    */
705   function _addTokenTo(address to, uint256 tokenId) internal {
706     super._addTokenTo(to, tokenId);
707     uint256 length = _ownedTokens[to].length;
708     _ownedTokens[to].push(tokenId);
709     _ownedTokensIndex[tokenId] = length;
710   }
711 
712   /**
713    * @dev Internal function to remove a token ID from the list of a given address
714    * This function is internal due to language limitations, see the note in ERC721.sol.
715    * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event,
716    * and doesn't clear approvals.
717    * @param from address representing the previous owner of the given token ID
718    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
719    */
720   function _removeTokenFrom(address from, uint256 tokenId) internal {
721     super._removeTokenFrom(from, tokenId);
722 
723     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
724     // then delete the last slot.
725     uint256 tokenIndex = _ownedTokensIndex[tokenId];
726     uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
727     uint256 lastToken = _ownedTokens[from][lastTokenIndex];
728 
729     _ownedTokens[from][tokenIndex] = lastToken;
730     // This also deletes the contents at the last position of the array
731     _ownedTokens[from].length--;
732 
733     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
734     // be zero. Then we can make sure that we will remove tokenId from the ownedTokens list since we are first swapping
735     // the lastToken to the first position, and then dropping the element placed in the last position of the list
736 
737     _ownedTokensIndex[tokenId] = 0;
738     _ownedTokensIndex[lastToken] = tokenIndex;
739   }
740 
741   /**
742    * @dev Internal function to mint a new token
743    * Reverts if the given token ID already exists
744    * @param to address the beneficiary that will own the minted token
745    * @param tokenId uint256 ID of the token to be minted by the msg.sender
746    */
747   function _mint(address to, uint256 tokenId) internal {
748     super._mint(to, tokenId);
749 
750     _allTokensIndex[tokenId] = _allTokens.length;
751     _allTokens.push(tokenId);
752   }
753 
754   /**
755    * @dev Internal function to burn a specific token
756    * Reverts if the token does not exist
757    * @param owner owner of the token to burn
758    * @param tokenId uint256 ID of the token being burned by the msg.sender
759    */
760   function _burn(address owner, uint256 tokenId) internal {
761     super._burn(owner, tokenId);
762 
763     // Reorg all tokens array
764     uint256 tokenIndex = _allTokensIndex[tokenId];
765     uint256 lastTokenIndex = _allTokens.length.sub(1);
766     uint256 lastToken = _allTokens[lastTokenIndex];
767 
768     _allTokens[tokenIndex] = lastToken;
769     _allTokens[lastTokenIndex] = 0;
770 
771     _allTokens.length--;
772     _allTokensIndex[tokenId] = 0;
773     _allTokensIndex[lastToken] = tokenIndex;
774   }
775 }
776 
777 
778 
779 
780 
781 
782 contract IERC721Metadata is IERC721 {
783   function name() external view returns (string);
784   function symbol() external view returns (string);
785   function tokenURI(uint256 tokenId) external view returns (string);
786 }
787 
788 
789 contract ERC721Metadata_custom is ERC165, ERC721_custom, IERC721Metadata {
790   // Token name
791   string private _name;
792 
793   // Token symbol
794   string private _symbol;
795 
796   // Optional mapping for token URIs
797   mapping(uint256 => string) private _tokenURIs;
798 
799   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
800   /**
801    * 0x5b5e139f ===
802    *   bytes4(keccak256('name()')) ^
803    *   bytes4(keccak256('symbol()')) ^
804    *   bytes4(keccak256('tokenURI(uint256)'))
805    */
806 
807   /**
808    * @dev Constructor function
809    */
810   constructor(string name, string symbol) public {
811     _name = name;
812     _symbol = symbol;
813 
814     // register the supported interfaces to conform to ERC721 via ERC165
815     _registerInterface(InterfaceId_ERC721Metadata);
816   }
817 
818   function name() external view returns (string) {
819     return _name;
820   }
821 
822   
823   function symbol() external view returns (string) {
824     return _symbol;
825   }
826 
827   /*
828   function tokenURI(uint256 tokenId) external view returns (string) {
829     require(_exists(tokenId));
830     return _tokenURIs[tokenId];
831   }
832 
833   
834   function _setTokenURI(uint256 tokenId, string uri) internal {
835     require(_exists(tokenId));
836     _tokenURIs[tokenId] = uri;
837   }
838 */
839   
840   function _burn(address owner, uint256 tokenId) internal {
841     super._burn(owner, tokenId);
842 
843     // Clear metadata (if any)
844     if (bytes(_tokenURIs[tokenId]).length != 0) {
845       delete _tokenURIs[tokenId];
846     }
847   }
848 }
849 
850 
851 contract ERC721Full_custom is ERC721_custom, ERC721Enumerable_custom, ERC721Metadata_custom {
852   constructor(string name, string symbol) ERC721Metadata_custom(name, symbol)
853     public
854   {
855   }
856 }
857 
858 
859 interface PlanetCryptoCoin_I {
860     function balanceOf(address owner) external returns(uint256);
861     function transfer(address to, uint256 value) external returns (bool);
862     function transferFrom(address from, address to, uint256 value) external returns(bool);
863 }
864 
865 interface PlanetCryptoUtils_I {
866     function validateLand(address _sender, int256[] plots_lat, int256[] plots_lng) external returns(bool);
867     function validatePurchase(address _sender, uint256 _value, int256[] plots_lat, int256[] plots_lng) external returns(bool);
868     function validateTokenPurchase(address _sender, int256[] plots_lat, int256[] plots_lng) external returns(bool);
869     function validateResale(address _sender, uint256 _value, uint256 _token_id) external returns(bool);
870     function validateLandTakeover(address _sender, uint256 _value, uint256 _token_id) external returns(bool);
871     //UTILS
872     function strConcat(string _a, string _b, string _c, string _d, string _e, string _f) external view returns (string);
873     function strConcat(string _a, string _b, string _c, string _d, string _e) external view returns (string);
874     function strConcat(string _a, string _b, string _c, string _d) external view returns (string);
875     function strConcat(string _a, string _b, string _c) external view returns (string);
876     function strConcat(string _a, string _b) external view returns (string);
877     function int2str(int i) external view returns (string);
878     function uint2str(uint i) external view returns (string);
879     function substring(string str, uint startIndex, uint endIndex) external view returns (string);
880     function utfStringLength(string str) external view returns (uint length);
881     function ceil1(int256 a, int256 m) external view returns (int256 );
882     function parseInt(string _a, uint _b) external view returns (uint);
883     
884     function roundLatLngFull(uint8 _zoomLvl, int256 __in) external pure returns(int256);
885 }
886 
887 interface PlanetCryptoToken_I {
888     
889     function all_playerObjects(uint256) external returns(
890         address playerAddress,
891         uint256 lastAccess,
892         uint256 totalEmpireScore,
893         uint256 totalLand);
894         
895     function balanceOf(address) external returns(uint256);
896     
897     function getAllPlayerObjectLen() external returns(uint256);
898     
899     function getToken(uint256 _token_id, bool isBasic) external returns(
900         address token_owner,
901         bytes32  name,
902         uint256 orig_value,
903         uint256 current_value,
904         uint256 empire_score,
905         int256[] plots_lat,
906         int256[] plots_lng
907         );
908         
909     
910     function tax_distributed() external returns(uint256);
911     function tax_fund() external returns(uint256);
912     
913     function taxEarningsAvailable() external returns(uint256);
914     
915     function tokens_rewards_allocated() external returns(uint256);
916     function tokens_rewards_available() external returns(uint256);
917     
918     function total_empire_score() external returns(uint256);
919     function total_land_sold() external returns(uint256);
920     function total_trades() external returns(uint256);
921     function totalSupply() external returns(uint256);
922     function current_plot_price() external returns(uint256);
923     
924     
925 }
926 
927 
928 library Percent {
929 
930   struct percent {
931     uint num;
932     uint den;
933   }
934   function mul(percent storage p, uint a) internal view returns (uint) {
935     if (a == 0) {
936       return 0;
937     }
938     return a*p.num/p.den;
939   }
940 /*
941   function div(percent storage p, uint a) internal view returns (uint) {
942     return a/p.num*p.den;
943   }
944 
945   function sub(percent storage p, uint a) internal view returns (uint) {
946     uint b = mul(p, a);
947     if (b >= a) return 0;
948     return a - b;
949   }
950 
951   function add(percent storage p, uint a) internal view returns (uint) {
952     return a + mul(p, a);
953   }
954 */
955 }
956 
957 
958 
959 contract PlanetCryptoToken is ERC721Full_custom{
960     
961     using Percent for Percent.percent;
962     
963     
964     // EVENTS
965         
966     event referralPaid(address indexed search_to,
967                     address to, uint256 amnt, uint256 timestamp);
968     
969     event issueCoinTokens(address indexed searched_to, 
970                     address to, uint256 amnt, uint256 timestamp);
971     
972     event landPurchased(uint256 indexed search_token_id, address indexed search_buyer, 
973             uint256 token_id, address buyer, bytes32 name, int256 center_lat, int256 center_lng, uint256 size, uint256 bought_at, uint256 empire_score, uint256 timestamp);
974     
975     event taxDistributed(uint256 amnt, uint256 total_players, uint256 timestamp);
976     
977     event cardBought(
978                     uint256 indexed search_token_id, address indexed search_from, address indexed search_to,
979                     uint256 token_id, address from, address to, 
980                     bytes32 name,
981                     uint256 orig_value, 
982                     uint256 new_value,
983                     uint256 empireScore, uint256 newEmpireScore, uint256 timestamp);
984 
985     event cardChange(
986             uint256 indexed search_token_id,
987             address indexed search_owner, 
988             uint256 token_id,
989             address owner, uint256 changeType, bytes32 data, uint256 timestamp);
990             
991 
992     // CONTRACT MANAGERS
993     address owner;
994     address devBankAddress; // where marketing funds are sent
995     address tokenBankAddress; 
996 
997     // MODIFIERS
998     modifier onlyOwner() {
999         require(msg.sender == owner);
1000         _;
1001     }
1002     
1003     modifier validateLand(int256[] plots_lat, int256[] plots_lng) {
1004         
1005         require(planetCryptoUtils_interface.validateLand(msg.sender, plots_lat, plots_lng) == true, "Some of this land already owned!");
1006 
1007         
1008         _;
1009     }
1010     
1011     modifier validatePurchase(int256[] plots_lat, int256[] plots_lng) {
1012 
1013         require(planetCryptoUtils_interface.validatePurchase(msg.sender, msg.value, plots_lat, plots_lng) == true, "Not enough ETH!");
1014         _;
1015     }
1016     
1017     
1018     modifier validateTokenPurchase(int256[] plots_lat, int256[] plots_lng) {
1019 
1020         require(planetCryptoUtils_interface.validateTokenPurchase(msg.sender, plots_lat, plots_lng) == true, "Not enough COINS to buy these plots!");
1021         
1022 
1023         
1024 
1025         require(planetCryptoCoin_interface.transferFrom(msg.sender, tokenBankAddress, plots_lat.length) == true, "Token transfer failed");
1026         
1027         
1028         _;
1029     }
1030     
1031     
1032     modifier validateResale(uint256 _token_id) {
1033         require(planetCryptoUtils_interface.validateResale(msg.sender, msg.value, _token_id) == true, "Not enough ETH to buy this card!");
1034         _;
1035     }
1036     
1037     
1038     modifier updateUsersLastAccess() {
1039         
1040         uint256 allPlyersIdx = playerAddressToPlayerObjectID[msg.sender];
1041         if(allPlyersIdx == 0){
1042 
1043             all_playerObjects.push(player(msg.sender,now,0,0));
1044             playerAddressToPlayerObjectID[msg.sender] = all_playerObjects.length-1;
1045         } else {
1046             all_playerObjects[allPlyersIdx].lastAccess = now;
1047         }
1048         
1049         _;
1050     }
1051     
1052     // STRUCTS
1053     struct plotDetail {
1054         bytes32 name;
1055         uint256 orig_value;
1056         uint256 current_value;
1057         uint256 empire_score;
1058         int256[] plots_lat;
1059         int256[] plots_lng;
1060         bytes32 img;
1061     }
1062     
1063     struct plotBasic {
1064         int256 lat;
1065         int256 lng;
1066     }
1067     
1068     struct player {
1069         address playerAddress;
1070         uint256 lastAccess;
1071         uint256 totalEmpireScore;
1072         uint256 totalLand;
1073         
1074         
1075     }
1076     
1077 
1078     // INTERFACES
1079     address planetCryptoCoinAddress = 0xA1c8031EF18272d8BfeD22E1b61319D6d9d2881B; // mainnet
1080     //address planetCryptoCoinAddress = 0xe1418a2546fe0c35653c89b354978bd1772bb431; // ropsten
1081     PlanetCryptoCoin_I internal planetCryptoCoin_interface;
1082     
1083 
1084     address planetCryptoUtilsAddress = 0x40089b9f4d5eb36d62548133f32e52b14fa54c52; // mainnet
1085     //address planetCryptoUtilsAddress = 0x7e3d67c3b1469f152f38367c06463917412c9c19; // ropsten
1086     PlanetCryptoUtils_I internal planetCryptoUtils_interface;
1087     
1088     
1089     
1090     // settings
1091     Percent.percent private m_newPlot_devPercent = Percent.percent(75,100); //75/100*100% = 75%
1092     Percent.percent private m_newPlot_taxPercent = Percent.percent(25,100); //25%
1093     
1094     Percent.percent private m_resalePlot_devPercent = Percent.percent(10,100); // 10%
1095     Percent.percent private m_resalePlot_taxPercent = Percent.percent(10,100); // 10%
1096     Percent.percent private m_resalePlot_ownerPercent = Percent.percent(80,100); // 80%
1097     
1098     //Percent.percent private m_takeoverPlot_devPercent = Percent.percent(10,100); // 10%
1099     //Percent.percent private m_takeoverPlot_taxPercent = Percent.percent(10,100); // 10%
1100     //Percent.percent private m_takeoverPlot_ownerPercent = Percent.percent(80,100); // 80%
1101     
1102     Percent.percent private m_refPercent = Percent.percent(5,100); // 5% referral 
1103     
1104     Percent.percent private m_empireScoreMultiplier = Percent.percent(150,100); // 150%
1105     Percent.percent private m_resaleMultipler = Percent.percent(200,100); // 200%;
1106 
1107     
1108 
1109     
1110     
1111     uint256 public devHoldings = 0; // holds dev funds in cases where the instant transfer fails
1112 
1113 
1114     mapping(address => uint256) internal playersFundsOwed;
1115 
1116 
1117 
1118 
1119     // add in limit of land plots before tokens stop being distributed
1120     uint256 public tokens_rewards_available;
1121     uint256 public tokens_rewards_allocated;
1122     
1123     // add in spend amount required to earn tokens
1124     uint256 public min_plots_purchase_for_token_reward = 10;
1125     uint256 public plots_token_reward_divisor = 10;
1126     
1127     
1128     // GAME SETTINGS
1129     uint256 public current_plot_price = 20000000000000000;
1130     uint256 public price_update_amount = 2000000000000;
1131     uint256 public cardChangeNameCost = 50000000000000000;
1132     uint256 public cardImageCost = 100000000000000000;
1133 
1134     uint256 public current_plot_empire_score = 100;
1135 
1136     string public baseURI = 'https://planetcrypto.app/api/token/';
1137     
1138     
1139     uint256 public tax_fund = 0;
1140     uint256 public tax_distributed = 0;
1141 
1142 
1143     // GAME STATS
1144     uint256 public tokenIDCount = 0;
1145     bool public game_started = false;
1146     uint256 public total_land_sold = 0;
1147     uint256 public total_trades = 0;
1148     uint256 internal tax_carried_forward = 0;
1149     
1150     uint256 public total_empire_score; 
1151     player[] public all_playerObjects;
1152     mapping(address => uint256) internal playerAddressToPlayerObjectID;
1153     
1154     
1155     
1156     
1157     plotDetail[] plotDetails;
1158     mapping(uint256 => uint256) internal tokenIDplotdetailsIndexId; // e.g. tokenIDplotdetailsIndexId shows us the index of the detail obj for each token
1159 
1160 
1161 
1162     
1163     mapping(int256 => mapping(int256 => uint256)) internal latlngTokenID_grids;
1164     //mapping(uint256 => plotBasic[]) internal tokenIDlatlngLookup; // To allow burn lookups
1165     //mapping(uint256 => int256[]) internal tokenIDlatlngLookup_lat; // To allow burn lookups
1166     //mapping(uint256 => int256[]) internal tokenIDlatlngLookup_lng; // To allow burn lookups
1167     
1168     
1169     
1170     mapping(uint8 => mapping(int256 => mapping(int256 => uint256))) internal latlngTokenID_zoomAll;
1171 
1172     mapping(uint8 => mapping(uint256 => plotBasic[])) internal tokenIDlatlngLookup_zoomAll;
1173 
1174 
1175     PlanetCryptoToken internal planetCryptoToken_I = PlanetCryptoToken(0x1806B3527C18Fb532C46405f6f014C1F381b499A);
1176     //PlanetCryptoToken internal planetCryptoToken_I = PlanetCryptoToken(0xd13faafc8e8b3f1acc6b84c8df845992e56dcd5b);
1177     
1178     constructor() ERC721Full_custom("PlanetCrypto", "PLANET") public {
1179         owner = msg.sender;
1180         tokenBankAddress = owner;
1181         devBankAddress = owner;
1182         planetCryptoCoin_interface = PlanetCryptoCoin_I(planetCryptoCoinAddress);
1183         planetCryptoUtils_interface = PlanetCryptoUtils_I(planetCryptoUtilsAddress);
1184         all_playerObjects.push(player(address(0x0),0,0,0));
1185         playerAddressToPlayerObjectID[address(0x0)] = 0;
1186         
1187         
1188     
1189         total_trades = planetCryptoToken_I.total_trades();
1190         total_land_sold = planetCryptoToken_I.total_land_sold();
1191         total_empire_score = planetCryptoToken_I.total_empire_score();
1192         tokens_rewards_available = planetCryptoToken_I.tokens_rewards_available();
1193         tokens_rewards_allocated = planetCryptoToken_I.tokens_rewards_allocated();
1194         tax_distributed = planetCryptoToken_I.tax_distributed();
1195         tax_fund = 0;
1196         current_plot_price = planetCryptoToken_I.current_plot_price();
1197         
1198 
1199         
1200     }
1201     
1202     function initPlayers(uint32 _start, uint32 _end) public onlyOwner {
1203         require(game_started == false);
1204         
1205         for(uint32 c=_start; c< _end+1; c++){
1206             transferPlayer(uint256(c));
1207         }
1208     }
1209     
1210     function transferPlayer(uint256 _player_id) internal {
1211         (address _playerAddress, uint256 _uint1, uint256 _uint2, uint256 _uint3) 
1212             =  planetCryptoToken_I.all_playerObjects(_player_id);
1213         
1214 
1215         all_playerObjects.push(
1216                 player(
1217                     _playerAddress,
1218                     _uint1,
1219                     _uint2,
1220                     _uint3
1221                     )
1222                 );
1223         playerAddressToPlayerObjectID[_playerAddress] = all_playerObjects.length-1;
1224     }
1225     
1226     
1227     function transferTokens(uint256 _start, uint256 _end) public onlyOwner {
1228         require(game_started == false);
1229         
1230         for(uint256 c=_start; c< _end+1; c++) {
1231             
1232             (
1233                 address _playerAddress,
1234                 bytes32 name,
1235                 uint256 orig_value,
1236                 uint256 current_value,
1237                 uint256 empire_score,
1238                 int256[] memory plots_lat,
1239                 int256[] memory plots_lng
1240             ) = 
1241                 planetCryptoToken_I.getToken(c, false);
1242     
1243 
1244             transferCards(c, _playerAddress, name, orig_value, current_value, empire_score, plots_lat, plots_lng);
1245         }
1246         
1247     }
1248     
1249     
1250 
1251     
1252     function transferCards(
1253                             uint256 _cardID,
1254                             address token_owner,
1255                             bytes32 name,
1256                             uint256 orig_value,
1257                             uint256 current_value,
1258                             uint256 empire_score,
1259                             int256[] memory plots_lat,
1260                             int256[] memory plots_lng
1261                             ) internal {
1262 
1263         
1264 
1265        
1266         _mint(token_owner, _cardID);
1267         tokenIDCount = tokenIDCount + 1;
1268             
1269         plotDetails.push(plotDetail(
1270             name,
1271             orig_value,
1272             current_value,
1273             empire_score,
1274             plots_lat, plots_lng, ''
1275         ));
1276         
1277         tokenIDplotdetailsIndexId[_cardID] = plotDetails.length-1;
1278         
1279         
1280         setupPlotOwnership(_cardID, plots_lat, plots_lng);
1281         
1282         
1283 
1284     }
1285     
1286 
1287     function tokenURI(uint256 tokenId) external view returns (string) {
1288         require(_exists(tokenId));
1289         return planetCryptoUtils_interface.strConcat(baseURI, 
1290                     planetCryptoUtils_interface.uint2str(tokenId));
1291     }
1292 
1293 
1294     function getToken(uint256 _tokenId, bool isBasic) public view returns(
1295         address token_owner,
1296         bytes32 name,
1297         uint256 orig_value,
1298         uint256 current_value,
1299         uint256 empire_score,
1300         int256[] plots_lat,
1301         int256[] plots_lng
1302         ) {
1303         token_owner = ownerOf(_tokenId);
1304         plotDetail memory _plotDetail = plotDetails[tokenIDplotdetailsIndexId[_tokenId]];
1305         name = _plotDetail.name;
1306         empire_score = _plotDetail.empire_score;
1307         orig_value = _plotDetail.orig_value;
1308         current_value = _plotDetail.current_value;
1309         if(!isBasic){
1310             plots_lat = _plotDetail.plots_lat;
1311             plots_lng = _plotDetail.plots_lng;
1312         }
1313     }
1314     function getTokenEnhanced(uint256 _tokenId, bool isBasic) public view returns(
1315         address token_owner,
1316         bytes32 name,
1317         bytes32 img,
1318         uint256 orig_value,
1319         uint256 current_value,
1320         uint256 empire_score,
1321         int256[] plots_lat,
1322         int256[] plots_lng
1323         ) {
1324         token_owner = ownerOf(_tokenId);
1325         plotDetail memory _plotDetail = plotDetails[tokenIDplotdetailsIndexId[_tokenId]];
1326         name = _plotDetail.name;
1327         img = _plotDetail.img;
1328         empire_score = _plotDetail.empire_score;
1329         orig_value = _plotDetail.orig_value;
1330         current_value = _plotDetail.current_value;
1331         if(!isBasic){
1332             plots_lat = _plotDetail.plots_lat;
1333             plots_lng = _plotDetail.plots_lng;
1334         }
1335     }
1336     
1337 
1338     function taxEarningsAvailable() public view returns(uint256) {
1339         return playersFundsOwed[msg.sender];
1340     }
1341 
1342     function withdrawTaxEarning() public {
1343         uint256 taxEarnings = playersFundsOwed[msg.sender];
1344         playersFundsOwed[msg.sender] = 0;
1345         tax_fund = tax_fund.sub(taxEarnings);
1346         
1347         if(!msg.sender.send(taxEarnings)) {
1348             playersFundsOwed[msg.sender] = playersFundsOwed[msg.sender] + taxEarnings;
1349             tax_fund = tax_fund.add(taxEarnings);
1350         }
1351     }
1352 
1353     function buyLandWithTokens(bytes32 _name, int256[] _plots_lat, int256[] _plots_lng)
1354      validateTokenPurchase(_plots_lat, _plots_lng) validateLand(_plots_lat, _plots_lng) updateUsersLastAccess() public {
1355         require(_name.length > 4);
1356         
1357 
1358         processPurchase(_name, _plots_lat, _plots_lng); 
1359         game_started = true;
1360     }
1361     
1362 
1363     
1364     function buyLand(bytes32 _name, 
1365             int256[] _plots_lat, int256[] _plots_lng,
1366             address _referrer
1367             )
1368                 validatePurchase(_plots_lat, _plots_lng) 
1369                 validateLand(_plots_lat, _plots_lng) 
1370                 updateUsersLastAccess()
1371                 public payable {
1372         require(_name.length > 4);
1373        
1374         // split payment
1375         uint256 _runningTotal = msg.value;
1376         
1377         _runningTotal = _runningTotal.sub(processReferer(_referrer));
1378         
1379 
1380         tax_fund = tax_fund.add(m_newPlot_taxPercent.mul(_runningTotal));
1381         
1382         
1383         processDevPayment(_runningTotal, m_newPlot_devPercent);
1384         
1385 
1386         processPurchase(_name, _plots_lat, _plots_lng);
1387         
1388         calcPlayerDivs(m_newPlot_taxPercent.mul(_runningTotal));
1389         
1390         game_started = true;
1391         
1392         if(_plots_lat.length >= min_plots_purchase_for_token_reward
1393             && tokens_rewards_available > 0) {
1394                 
1395             uint256 _token_rewards = _plots_lat.length / plots_token_reward_divisor;
1396             if(_token_rewards > tokens_rewards_available)
1397                 _token_rewards = tokens_rewards_available;
1398                 
1399                 
1400             planetCryptoCoin_interface.transfer(msg.sender, _token_rewards);
1401                 
1402             emit issueCoinTokens(msg.sender, msg.sender, _token_rewards, now);
1403             tokens_rewards_allocated = tokens_rewards_allocated + _token_rewards;
1404             tokens_rewards_available = tokens_rewards_available - _token_rewards;
1405         }
1406     
1407     }
1408     
1409     function processReferer(address _referrer) internal returns(uint256) {
1410         uint256 _referrerAmnt = 0;
1411         if(_referrer != msg.sender && _referrer != address(0)) {
1412             _referrerAmnt = m_refPercent.mul(msg.value);
1413             if(_referrer.send(_referrerAmnt)) {
1414                 emit referralPaid(_referrer, _referrer, _referrerAmnt, now);
1415                 //_runningTotal = _runningTotal.sub(_referrerAmnt);
1416             }
1417         }
1418         return _referrerAmnt;
1419     }
1420     
1421     
1422     function processDevPayment(uint256 _runningTotal, Percent.percent storage _percent) internal {
1423         if(!devBankAddress.send(_percent.mul(_runningTotal))){
1424             devHoldings = devHoldings.add(_percent.mul(_runningTotal));
1425         }
1426     }
1427     
1428     // TO BE TESTED
1429     function buyCard(uint256 _token_id, address _referrer) updateUsersLastAccess() public payable {
1430         
1431         
1432         //validateResale(_token_id)
1433         
1434         if(planetCryptoUtils_interface.validateResale(msg.sender, msg.value, _token_id) == false) {
1435             if(planetCryptoUtils_interface.validateLandTakeover(msg.sender, msg.value, _token_id) == false) {
1436                 revert("Cannot Buy this Card Yet!");
1437             }
1438         }
1439         
1440         processBuyCard(_token_id, _referrer);
1441 
1442     }
1443     
1444     
1445     
1446     function processBuyCard(uint256 _token_id, address _referrer) internal {
1447         // split payment
1448         uint256 _runningTotal = msg.value;
1449         _runningTotal = _runningTotal.sub(processReferer(_referrer));
1450         
1451         tax_fund = tax_fund.add(m_resalePlot_taxPercent.mul(_runningTotal));
1452         
1453         processDevPayment(_runningTotal, m_resalePlot_devPercent);
1454 
1455         address from = ownerOf(_token_id);
1456         
1457         if(!from.send(m_resalePlot_ownerPercent.mul(_runningTotal))) {
1458             playersFundsOwed[from] = playersFundsOwed[from].add(m_resalePlot_ownerPercent.mul(_runningTotal));
1459         }
1460         
1461         
1462         process_swap(from,msg.sender,_token_id);
1463         internal_transferFrom(from, msg.sender, _token_id);
1464         
1465 
1466         //plotDetail memory _plotDetail = plotDetails[tokenIDplotdetailsIndexId[_token_id]];
1467         uint256 _empireScore = plotDetails[tokenIDplotdetailsIndexId[_token_id]].empire_score; // apply bonus when card is bought through site
1468         uint256 _newEmpireScore = m_empireScoreMultiplier.mul(_empireScore);
1469         uint256 _origValue = plotDetails[tokenIDplotdetailsIndexId[_token_id]].current_value;
1470         
1471 
1472         all_playerObjects[playerAddressToPlayerObjectID[msg.sender]].totalEmpireScore
1473             = all_playerObjects[playerAddressToPlayerObjectID[msg.sender]].totalEmpireScore + (_newEmpireScore - _empireScore);
1474         
1475         plotDetails[tokenIDplotdetailsIndexId[_token_id]].empire_score = _newEmpireScore;
1476 
1477         total_empire_score = total_empire_score + (_newEmpireScore - _empireScore);
1478         
1479         plotDetails[tokenIDplotdetailsIndexId[_token_id]].current_value = 
1480             m_resaleMultipler.mul(plotDetails[tokenIDplotdetailsIndexId[_token_id]].current_value);
1481         
1482         total_trades = total_trades + 1;
1483         
1484         
1485         calcPlayerDivs(m_resalePlot_taxPercent.mul(_runningTotal));
1486         
1487         
1488         plotDetail memory _plot =plotDetails[tokenIDplotdetailsIndexId[_token_id]];
1489        
1490         emit cardBought(_token_id, from, ownerOf(_token_id),
1491                     _token_id, from, ownerOf(_token_id), 
1492                     _plot.name,
1493                     _origValue, 
1494                     _plot.current_value,
1495                     _empireScore, 
1496                     _plot.empire_score, 
1497                     now);
1498     }
1499     
1500     
1501     
1502     function processPurchase(bytes32 _name, 
1503             int256[] _plots_lat, int256[] _plots_lng) internal {
1504     
1505         tokenIDCount = tokenIDCount + 1;
1506         
1507         //uint256 _token_id = tokenIDCount; //totalSupply().add(1);
1508         _mint(msg.sender, tokenIDCount);
1509         
1510 
1511            
1512             
1513         plotDetails.push(plotDetail(
1514             _name,
1515             current_plot_price * _plots_lat.length,
1516             current_plot_price * _plots_lat.length,
1517             current_plot_empire_score * _plots_lng.length,
1518             _plots_lat, _plots_lng, ''
1519         ));
1520 
1521         
1522         tokenIDplotdetailsIndexId[tokenIDCount] = plotDetails.length-1;
1523         
1524         
1525         
1526         setupPlotOwnership(tokenIDCount, _plots_lat, _plots_lng);
1527         
1528         
1529         
1530         uint256 _playerObject_idx = playerAddressToPlayerObjectID[msg.sender];
1531         all_playerObjects[_playerObject_idx].totalEmpireScore
1532             = all_playerObjects[_playerObject_idx].totalEmpireScore + (current_plot_empire_score * _plots_lng.length);
1533             
1534         total_empire_score = total_empire_score + (current_plot_empire_score * _plots_lng.length);
1535             
1536         all_playerObjects[_playerObject_idx].totalLand
1537             = all_playerObjects[_playerObject_idx].totalLand + _plots_lat.length;
1538             
1539         
1540         emit landPurchased(
1541                 tokenIDCount, msg.sender,
1542                 tokenIDCount, msg.sender, _name, _plots_lat[0], _plots_lng[0], _plots_lat.length, current_plot_price, (current_plot_empire_score * _plots_lng.length), now);
1543 
1544 
1545         current_plot_price = current_plot_price + (price_update_amount * _plots_lat.length);
1546         total_land_sold = total_land_sold + _plots_lat.length;
1547 
1548     }
1549 
1550     function updateCardDetail(uint256 _token_id, uint256 _updateType, bytes32 _data) public payable {
1551         require(msg.sender == ownerOf(_token_id));
1552         if(_updateType == 1) {
1553             // CardImage
1554             require(msg.value == cardImageCost);
1555             
1556             plotDetails[
1557                     tokenIDplotdetailsIndexId[_token_id]
1558                         ].img = _data;
1559 
1560         }
1561         if(_updateType == 2) {
1562             // Name change
1563             require(_data.length > 4);
1564             require(msg.value == cardChangeNameCost);
1565             plotDetails[
1566                     tokenIDplotdetailsIndexId[_token_id]
1567                         ].name = _data;
1568         }
1569         
1570         
1571         processDevPayment(msg.value,m_newPlot_devPercent);
1572         /*
1573         if(!devBankAddress.send(msg.value)){
1574             devHoldings = devHoldings.add(msg.value);
1575         }
1576         */
1577         
1578         emit cardChange(
1579             _token_id,
1580             msg.sender, 
1581             _token_id, msg.sender, _updateType, _data, now);
1582             
1583     }
1584     
1585     
1586     
1587 
1588 
1589     
1590     
1591     function calcPlayerDivs(uint256 _value) internal {
1592         // total up amount split so we can emit it
1593         //if(totalSupply() > 1) {
1594         if(game_started) {
1595             uint256 _totalDivs = 0;
1596             uint256 _totalPlayers = 0;
1597             
1598             uint256 _taxToDivide = _value + tax_carried_forward;
1599             
1600             // ignore player 0
1601             for(uint256 c=1; c< all_playerObjects.length; c++) {
1602                 
1603                 // allow for 0.0001 % =  * 10000
1604                 
1605                 uint256 _playersPercent 
1606                     = (all_playerObjects[c].totalEmpireScore*10000000 / total_empire_score * 10000000) / 10000000;
1607                     
1608                 uint256 _playerShare = _taxToDivide / 10000000 * _playersPercent;
1609                 
1610 
1611                 
1612                 if(_playerShare > 0) {
1613                     
1614                     
1615                     playersFundsOwed[all_playerObjects[c].playerAddress] = playersFundsOwed[all_playerObjects[c].playerAddress].add(_playerShare);
1616                     tax_distributed = tax_distributed.add(_playerShare);
1617                     
1618                     _totalDivs = _totalDivs + _playerShare;
1619                     _totalPlayers = _totalPlayers + 1;
1620                 
1621                 }
1622             }
1623 
1624             tax_carried_forward = 0;
1625             emit taxDistributed(_totalDivs, _totalPlayers, now);
1626 
1627         } else {
1628             // first land purchase - no divs this time, carried forward
1629             tax_carried_forward = tax_carried_forward + _value;
1630         }
1631     }
1632     
1633 
1634     
1635     
1636     function setupPlotOwnership(uint256 _token_id, int256[] _plots_lat, int256[] _plots_lng) internal {
1637 
1638        for(uint256 c=0;c< _plots_lat.length;c++) {
1639          
1640             latlngTokenID_grids[_plots_lat[c]]
1641                 [_plots_lng[c]] = _token_id;
1642                 
1643 
1644             
1645         }
1646        
1647 
1648 
1649         for(uint8 zoomC = 1; c < 5; c++) {
1650             setupZoomLvl(zoomC,_plots_lat[0], _plots_lng[0], _token_id); // correct rounding / 10 on way out    
1651         }
1652 
1653       
1654     }
1655 
1656 
1657 
1658 
1659     function setupZoomLvl(uint8 zoom, int256 lat, int256 lng, uint256 _token_id) internal  {
1660         
1661         lat = planetCryptoUtils_interface.roundLatLngFull(zoom, lat);
1662         lng = planetCryptoUtils_interface.roundLatLngFull(zoom, lng);
1663         
1664         
1665       
1666         
1667         latlngTokenID_zoomAll[zoom][lat][lng] = _token_id;
1668         tokenIDlatlngLookup_zoomAll[zoom][_token_id].push(
1669             plotBasic(lat,lng)
1670             );
1671  
1672         
1673         
1674     }
1675 
1676 
1677 
1678 
1679     
1680 
1681 
1682     function getAllPlayerObjectLen() public view returns(uint256){
1683         return all_playerObjects.length;
1684     }
1685     
1686 
1687     function queryMap(uint8 zoom, int256[] lat_rows, int256[] lng_columns) public view returns(string _outStr) {
1688         
1689         
1690         for(uint256 y=0; y< lat_rows.length; y++) {
1691 
1692             for(uint256 x=0; x< lng_columns.length; x++) {
1693                 
1694                 
1695                 
1696                 if(zoom == 0){
1697                     if(latlngTokenID_grids[lat_rows[y]][lng_columns[x]] > 0){
1698                         
1699                         
1700                       _outStr = planetCryptoUtils_interface.strConcat(
1701                             _outStr, '[', planetCryptoUtils_interface.int2str(lat_rows[y]) , ':', planetCryptoUtils_interface.int2str(lng_columns[x]) );
1702                       _outStr = planetCryptoUtils_interface.strConcat(_outStr, ':', 
1703                                     planetCryptoUtils_interface.uint2str(latlngTokenID_grids[lat_rows[y]][lng_columns[x]]), ']');
1704                     }
1705                     
1706                 } else {
1707                     //_out[c] = latlngTokenID_zoomAll[zoom][lat_rows[y]][lng_columns[x]];
1708                     if(latlngTokenID_zoomAll[zoom][lat_rows[y]][lng_columns[x]] > 0){
1709                       _outStr = planetCryptoUtils_interface.strConcat(_outStr, '[', planetCryptoUtils_interface.int2str(lat_rows[y]) , ':', planetCryptoUtils_interface.int2str(lng_columns[x]) );
1710                       _outStr = planetCryptoUtils_interface.strConcat(_outStr, ':', 
1711                                     planetCryptoUtils_interface.uint2str(latlngTokenID_zoomAll[zoom][lat_rows[y]][lng_columns[x]]), ']');
1712                     }
1713                     
1714                 }
1715                 //c = c+1;
1716                 
1717             }
1718         }
1719         
1720         //return _out;
1721     }
1722     // used in utils
1723     function queryPlotExists(uint8 zoom, int256[] lat_rows, int256[] lng_columns) public view returns(bool) {
1724         
1725         
1726         for(uint256 y=0; y< lat_rows.length; y++) {
1727 
1728             for(uint256 x=0; x< lng_columns.length; x++) {
1729                 
1730                 if(zoom == 0){
1731                     if(latlngTokenID_grids[lat_rows[y]][lng_columns[x]] > 0){
1732                         return true;
1733                     } 
1734                 } else {
1735                     if(latlngTokenID_zoomAll[zoom][lat_rows[y]][lng_columns[x]] > 0){
1736 
1737                         return true;
1738                         
1739                     }                     
1740                 }
1741            
1742                 
1743             }
1744         }
1745         
1746         return false;
1747     }
1748 
1749     
1750 
1751     
1752 
1753    
1754 
1755 
1756 
1757 
1758     // ERC721 overrides
1759     
1760     function safeTransferFrom(address from, address to, uint256 tokenId) public {
1761         safeTransferFrom(from, to, tokenId, "");
1762     }
1763     function safeTransferFrom(address from, address to, uint256 tokenId, bytes _data) public {
1764         transferFrom(from, to, tokenId);
1765         // solium-disable-next-line arg-overflow
1766         require(_checkOnERC721Received(from, to, tokenId, _data));
1767     }
1768     
1769 
1770 
1771     function transferFrom(address from, address to, uint256 tokenId) public {
1772         // check permission on the from address first
1773         require(_isApprovedOrOwner(msg.sender, tokenId));
1774         require(to != address(0));
1775         
1776         process_swap(from,to,tokenId);
1777         
1778         super.transferFrom(from, to, tokenId);
1779 
1780     }
1781     
1782     function process_swap(address from, address to, uint256 tokenId) internal {
1783 
1784         
1785         // remove the empire score & total land owned...
1786         uint256 _empireScore;
1787         uint256 _size;
1788         
1789         //plotDetail memory _plotDetail = plotDetails[tokenIDplotdetailsIndexId[tokenId]];
1790         _empireScore = plotDetails[tokenIDplotdetailsIndexId[tokenId]].empire_score;
1791         _size = plotDetails[tokenIDplotdetailsIndexId[tokenId]].plots_lat.length;
1792         
1793         uint256 _playerObject_idx = playerAddressToPlayerObjectID[from];
1794         
1795         all_playerObjects[_playerObject_idx].totalEmpireScore
1796             = all_playerObjects[_playerObject_idx].totalEmpireScore - _empireScore;
1797             
1798         all_playerObjects[_playerObject_idx].totalLand
1799             = all_playerObjects[_playerObject_idx].totalLand - _size;
1800             
1801         // and increment on the other side...
1802         _playerObject_idx = playerAddressToPlayerObjectID[to];
1803         
1804         // ensure the player is setup first...
1805         if(_playerObject_idx == 0){
1806             all_playerObjects.push(player(to,now,0,0));
1807             playerAddressToPlayerObjectID[to] = all_playerObjects.length-1;
1808             _playerObject_idx = all_playerObjects.length-1;
1809         }
1810         
1811         all_playerObjects[_playerObject_idx].totalEmpireScore
1812             = all_playerObjects[_playerObject_idx].totalEmpireScore + _empireScore;
1813             
1814         all_playerObjects[_playerObject_idx].totalLand
1815             = all_playerObjects[_playerObject_idx].totalLand + _size;
1816     }
1817 
1818 
1819    
1820 
1821 
1822     // PRIVATE METHODS
1823     function p_update_action(uint256 _type, address _address, uint256 _val, string _strVal) public onlyOwner {
1824         if(_type == 0){
1825             owner = _address;    
1826         }
1827         if(_type == 1){
1828             tokenBankAddress = _address;    
1829         }
1830         if(_type == 2) {
1831             devBankAddress = _address;
1832         }
1833         if(_type == 3) {
1834             cardChangeNameCost = _val;    
1835         }
1836         if(_type == 4) {
1837             cardImageCost = _val;    
1838         }
1839         if(_type == 5) {
1840             baseURI = _strVal;
1841         }
1842         if(_type == 6) {
1843             price_update_amount = _val;
1844         }
1845         if(_type == 7) {
1846             current_plot_empire_score = _val;    
1847         }
1848         if(_type == 8) {
1849             planetCryptoCoinAddress = _address;
1850             if(address(planetCryptoCoinAddress) != address(0)){ 
1851                 planetCryptoCoin_interface = PlanetCryptoCoin_I(planetCryptoCoinAddress);
1852             }
1853         }
1854         if(_type ==9) {
1855             planetCryptoUtilsAddress = _address;
1856             if(address(planetCryptoUtilsAddress) != address(0)){ 
1857                 planetCryptoUtils_interface = PlanetCryptoUtils_I(planetCryptoUtilsAddress);
1858             }            
1859         }
1860         if(_type == 10) {
1861             m_newPlot_devPercent = Percent.percent(_val,100);    
1862         }
1863         if(_type == 11) {
1864             m_newPlot_taxPercent = Percent.percent(_val,100);    
1865         }
1866         if(_type == 12) {
1867             m_resalePlot_devPercent = Percent.percent(_val,100);    
1868         }
1869         if(_type == 13) {
1870             m_resalePlot_taxPercent = Percent.percent(_val,100);    
1871         }
1872         if(_type == 14) {
1873             m_resalePlot_ownerPercent = Percent.percent(_val,100);    
1874         }
1875         if(_type == 15) {
1876             m_refPercent = Percent.percent(_val,100);    
1877         }
1878         if(_type == 16) {
1879             m_empireScoreMultiplier = Percent.percent(_val, 100);    
1880         }
1881         if(_type == 17) {
1882             m_resaleMultipler = Percent.percent(_val, 100);    
1883         }
1884         if(_type == 18) {
1885             tokens_rewards_available = _val;    
1886         }
1887         if(_type == 19) {
1888             tokens_rewards_allocated = _val;    
1889         }
1890         if(_type == 20) {
1891             // clear card image 
1892             plotDetails[
1893                     tokenIDplotdetailsIndexId[_val]
1894                         ].img = '';
1895                         
1896             emit cardChange(
1897                 _val,
1898                 msg.sender, 
1899                 _val, msg.sender, 1, '', now);
1900         }
1901 
1902         
1903         if(_type == 99) {
1904             // burnToken 
1905         
1906             address _token_owner = ownerOf(_val);
1907             //internal_transferFrom(_token_owner, 0x0000000000000000000000000000000000000000, _val);
1908             processBurn(_token_owner, _val);
1909         
1910         }
1911     }
1912     
1913     function burn(uint256 _token_id) public {
1914         require(msg.sender == ownerOf(_token_id));
1915         
1916         uint256 _cardSize = plotDetails[tokenIDplotdetailsIndexId[_token_id]].plots_lat.length;
1917         
1918         //super.transferFrom(msg.sender, 0x0000000000000000000000000000000000000000, _token_id);
1919         processBurn(msg.sender, _token_id);
1920         
1921         // allocate PlanetCOIN tokens to user...
1922         planetCryptoCoin_interface.transfer(msg.sender, _cardSize);
1923         
1924         
1925         
1926     }
1927     
1928     function processBurn(address _token_owner, uint256 _val) internal {
1929         _burn(_token_owner, _val);
1930 
1931         
1932 
1933 
1934         // remove the empire score & total land owned...
1935         uint256 _empireScore;
1936         uint256 _size;
1937         
1938 
1939         _empireScore = plotDetails[tokenIDplotdetailsIndexId[_val]].empire_score;
1940         _size = plotDetails[tokenIDplotdetailsIndexId[_val]].plots_lat.length;
1941         
1942         total_land_sold = total_land_sold - _size;
1943         total_empire_score = total_empire_score - _empireScore;
1944         
1945         uint256 _playerObject_idx = playerAddressToPlayerObjectID[_token_owner];
1946         
1947         all_playerObjects[_playerObject_idx].totalEmpireScore
1948             = all_playerObjects[_playerObject_idx].totalEmpireScore - _empireScore;
1949             
1950         all_playerObjects[_playerObject_idx].totalLand
1951             = all_playerObjects[_playerObject_idx].totalLand - _size;
1952             
1953             
1954         for(uint256 c=0;c < plotDetails[tokenIDplotdetailsIndexId[_val]].plots_lat.length; c++) {
1955             latlngTokenID_grids[
1956                     //tokenIDlatlngLookup_lat[_val][c]
1957                     plotDetails[tokenIDplotdetailsIndexId[_val]].plots_lat[c]
1958                 ]
1959                 [
1960                     //tokenIDlatlngLookup_lng[_val][c]
1961                     plotDetails[tokenIDplotdetailsIndexId[_val]].plots_lng[c]
1962                 ] = 0;
1963         }
1964 
1965         
1966   
1967         for(uint8 zoom=1; zoom < 5; zoom++) {
1968             plotBasic[] storage _plotBasicList = tokenIDlatlngLookup_zoomAll[zoom][_val];
1969             for(c=0; c< _plotBasicList.length; c++) {
1970                 delete latlngTokenID_zoomAll[zoom][
1971                     _plotBasicList[c].lat
1972                     ][
1973                         _plotBasicList[c].lng
1974                         ];
1975                         
1976                 delete _plotBasicList[c];
1977             }
1978         }
1979         
1980         
1981         delete plotDetails[tokenIDplotdetailsIndexId[_val]];
1982         tokenIDplotdetailsIndexId[_val] = 0;
1983         //delete tokenIDplotdetailsIndexId[_val];
1984         
1985         
1986 
1987 
1988     }
1989 
1990     function p_withdrawDevHoldings() public {
1991         require(msg.sender == devBankAddress);
1992         uint256 _t = devHoldings;
1993         devHoldings = 0;
1994         if(!devBankAddress.send(devHoldings)){
1995             devHoldings = _t;
1996         }
1997     }
1998 
1999 
2000 
2001 
2002     function m() public {
2003         
2004     }
2005     
2006 }