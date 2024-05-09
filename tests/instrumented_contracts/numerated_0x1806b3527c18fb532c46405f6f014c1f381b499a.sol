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
389     require(to != address(0));
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
410     require(to != address(0));
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
870 
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
983                     uint256 empireScore, uint256 newEmpireScore, uint256 now);
984                     
985     event cardChange(
986             uint256 indexed search_token_id,
987             address indexed search_owner, 
988             uint256 token_id,
989             address owner, uint256 changeType, bytes32 data, uint256 now);
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
1080     PlanetCryptoCoin_I internal planetCryptoCoin_interface;
1081     
1082 
1083     address planetCryptoUtilsAddress = 0x8a511e355e4233f0ab14cddbc1dd60a80a349f8b; // mainnet
1084     PlanetCryptoUtils_I internal planetCryptoUtils_interface;
1085     
1086     
1087     
1088     // settings
1089     Percent.percent private m_newPlot_devPercent = Percent.percent(75,100); //75/100*100% = 75%
1090     Percent.percent private m_newPlot_taxPercent = Percent.percent(25,100); //25%
1091     
1092     Percent.percent private m_resalePlot_devPercent = Percent.percent(10,100); // 10%
1093     Percent.percent private m_resalePlot_taxPercent = Percent.percent(10,100); // 10%
1094     Percent.percent private m_resalePlot_ownerPercent = Percent.percent(80,100); // 80%
1095     
1096     Percent.percent private m_refPercent = Percent.percent(5,100); // 5% referral 
1097     
1098     Percent.percent private m_empireScoreMultiplier = Percent.percent(150,100); // 150%
1099     Percent.percent private m_resaleMultipler = Percent.percent(200,100); // 200%;
1100 
1101     
1102     
1103     
1104     uint256 public devHoldings = 0; // holds dev funds in cases where the instant transfer fails
1105 
1106 
1107     mapping(address => uint256) internal playersFundsOwed;
1108 
1109 
1110 
1111 
1112     // add in limit of land plots before tokens stop being distributed
1113     uint256 public tokens_rewards_available;
1114     uint256 public tokens_rewards_allocated;
1115     
1116     // add in spend amount required to earn tokens
1117     uint256 public min_plots_purchase_for_token_reward = 10;
1118     uint256 public plots_token_reward_divisor = 10;
1119     
1120     
1121     // GAME SETTINGS
1122     uint256 public current_plot_price = 20000000000000000;
1123     uint256 public price_update_amount = 2000000000000;
1124     uint256 public cardChangeNameCost = 50000000000000000;
1125     uint256 public cardImageCost = 100000000000000000;
1126 
1127     uint256 public current_plot_empire_score = 100;
1128 
1129     string public baseURI = 'https://planetcrypto.app/api/token/';
1130     
1131     
1132     uint256 public tax_fund = 0;
1133     uint256 public tax_distributed = 0;
1134 
1135 
1136     // GAME STATS
1137     bool public game_started = false;
1138     uint256 public total_land_sold = 0;
1139     uint256 public total_trades = 0;
1140     uint256 internal tax_carried_forward = 0;
1141     
1142     uint256 public total_empire_score; 
1143     player[] public all_playerObjects;
1144     mapping(address => uint256) internal playerAddressToPlayerObjectID;
1145     
1146     
1147     
1148     
1149     plotDetail[] plotDetails;
1150     mapping(uint256 => uint256) internal tokenIDplotdetailsIndexId; // e.g. tokenIDplotdetailsIndexId shows us the index of the detail obj for each token
1151 
1152 
1153 
1154     
1155     mapping(int256 => mapping(int256 => uint256)) internal latlngTokenID_grids;
1156     //mapping(uint256 => plotBasic[]) internal tokenIDlatlngLookup; // IS THIS USED???
1157     
1158     
1159     
1160     mapping(uint8 => mapping(int256 => mapping(int256 => uint256))) internal latlngTokenID_zoomAll;
1161 
1162     mapping(uint8 => mapping(uint256 => plotBasic[])) internal tokenIDlatlngLookup_zoomAll;
1163 
1164 
1165     PlanetCryptoToken internal planetCryptoToken_I = PlanetCryptoToken(0x8C55B18e6bb7083b29102e57c34d0C3124c0a952);
1166     
1167     constructor() ERC721Full_custom("PlanetCrypto", "PTC") public {
1168         owner = msg.sender;
1169         tokenBankAddress = owner;
1170         devBankAddress = owner;
1171         planetCryptoCoin_interface = PlanetCryptoCoin_I(planetCryptoCoinAddress);
1172         planetCryptoUtils_interface = PlanetCryptoUtils_I(planetCryptoUtilsAddress);
1173         all_playerObjects.push(player(address(0x0),0,0,0));
1174         playerAddressToPlayerObjectID[address(0x0)] = 0;
1175         
1176         
1177         //planetCryptoToken_I = PlanetCryptoToken(_prevAddress);
1178         
1179     
1180         total_trades = planetCryptoToken_I.total_trades();
1181         total_land_sold = planetCryptoToken_I.total_land_sold();
1182         total_empire_score = planetCryptoToken_I.total_empire_score();
1183         tokens_rewards_available = planetCryptoToken_I.tokens_rewards_available();
1184         tokens_rewards_allocated = planetCryptoToken_I.tokens_rewards_allocated();
1185         tax_distributed = planetCryptoToken_I.tax_distributed();
1186         tax_fund = 0;
1187         current_plot_price = planetCryptoToken_I.current_plot_price();
1188         
1189     }
1190     
1191     function initPlayers(uint32 _start, uint32 _end) public onlyOwner {
1192         require(game_started == false);
1193         
1194         for(uint32 c=_start; c< _end+1; c++){
1195             transferPlayer(uint256(c));
1196         }
1197     }
1198     
1199     function transferPlayer(uint256 _player_id) internal {
1200         (address _playerAddress, uint256 _uint1, uint256 _uint2, uint256 _uint3) 
1201             =  planetCryptoToken_I.all_playerObjects(_player_id);
1202         
1203 
1204         all_playerObjects.push(
1205                 player(
1206                     _playerAddress,
1207                     _uint1,
1208                     _uint2,
1209                     _uint3
1210                     )
1211                 );
1212         playerAddressToPlayerObjectID[_playerAddress] = all_playerObjects.length-1;
1213     }
1214     
1215     
1216     function transferTokens(uint256 _start, uint256 _end) public onlyOwner {
1217         require(game_started == false);
1218         
1219         for(uint256 c=_start; c< _end+1; c++) {
1220             
1221             (
1222                 address _playerAddress,
1223                 bytes32 name,
1224                 uint256 orig_value,
1225                 uint256 current_value,
1226                 uint256 empire_score,
1227                 int256[] memory plots_lat,
1228                 int256[] memory plots_lng
1229             ) = 
1230                 planetCryptoToken_I.getToken(c, false);
1231     
1232 
1233             transferCards(c, _playerAddress, name, orig_value, current_value, empire_score, plots_lat, plots_lng);
1234         }
1235         
1236     }
1237     
1238     
1239 
1240     
1241     function transferCards(
1242                             uint256 _cardID,
1243                             address token_owner,
1244                             bytes32 name,
1245                             uint256 orig_value,
1246                             uint256 current_value,
1247                             uint256 empire_score,
1248                             int256[] memory plots_lat,
1249                             int256[] memory plots_lng
1250                             ) internal {
1251 
1252         
1253 
1254        
1255        _mint(token_owner, _cardID);
1256 
1257             
1258         plotDetails.push(plotDetail(
1259             name,
1260             orig_value,
1261             current_value,
1262             empire_score,
1263             plots_lat, plots_lng, ''
1264         ));
1265         
1266         tokenIDplotdetailsIndexId[_cardID] = plotDetails.length-1;
1267         
1268         
1269         setupPlotOwnership(_cardID, plots_lat, plots_lng);
1270         
1271         
1272 
1273     }
1274     
1275 
1276     function tokenURI(uint256 tokenId) external view returns (string) {
1277         require(_exists(tokenId));
1278         return planetCryptoUtils_interface.strConcat(baseURI, 
1279                     planetCryptoUtils_interface.uint2str(tokenId));
1280     }
1281 
1282 
1283     function getToken(uint256 _tokenId, bool isBasic) public view returns(
1284         address token_owner,
1285         bytes32 name,
1286         uint256 orig_value,
1287         uint256 current_value,
1288         uint256 empire_score,
1289         int256[] plots_lat,
1290         int256[] plots_lng
1291         ) {
1292         token_owner = ownerOf(_tokenId);
1293         plotDetail memory _plotDetail = plotDetails[tokenIDplotdetailsIndexId[_tokenId]];
1294         name = _plotDetail.name;
1295         empire_score = _plotDetail.empire_score;
1296         orig_value = _plotDetail.orig_value;
1297         current_value = _plotDetail.current_value;
1298         if(!isBasic){
1299             plots_lat = _plotDetail.plots_lat;
1300             plots_lng = _plotDetail.plots_lng;
1301         }
1302     }
1303     function getTokenEnhanced(uint256 _tokenId, bool isBasic) public view returns(
1304         address token_owner,
1305         bytes32 name,
1306         bytes32 img,
1307         uint256 orig_value,
1308         uint256 current_value,
1309         uint256 empire_score,
1310         int256[] plots_lat,
1311         int256[] plots_lng
1312         ) {
1313         token_owner = ownerOf(_tokenId);
1314         plotDetail memory _plotDetail = plotDetails[tokenIDplotdetailsIndexId[_tokenId]];
1315         name = _plotDetail.name;
1316         img = _plotDetail.img;
1317         empire_score = _plotDetail.empire_score;
1318         orig_value = _plotDetail.orig_value;
1319         current_value = _plotDetail.current_value;
1320         if(!isBasic){
1321             plots_lat = _plotDetail.plots_lat;
1322             plots_lng = _plotDetail.plots_lng;
1323         }
1324     }
1325     
1326 
1327     function taxEarningsAvailable() public view returns(uint256) {
1328         return playersFundsOwed[msg.sender];
1329     }
1330 
1331     function withdrawTaxEarning() public {
1332         uint256 taxEarnings = playersFundsOwed[msg.sender];
1333         playersFundsOwed[msg.sender] = 0;
1334         tax_fund = tax_fund.sub(taxEarnings);
1335         
1336         if(!msg.sender.send(taxEarnings)) {
1337             playersFundsOwed[msg.sender] = playersFundsOwed[msg.sender] + taxEarnings;
1338             tax_fund = tax_fund.add(taxEarnings);
1339         }
1340     }
1341 
1342     function buyLandWithTokens(bytes32 _name, int256[] _plots_lat, int256[] _plots_lng)
1343      validateTokenPurchase(_plots_lat, _plots_lng) validateLand(_plots_lat, _plots_lng) updateUsersLastAccess() public {
1344         require(_name.length > 4);
1345         
1346 
1347         processPurchase(_name, _plots_lat, _plots_lng); 
1348         game_started = true;
1349     }
1350     
1351 
1352     
1353     function buyLand(bytes32 _name, 
1354             int256[] _plots_lat, int256[] _plots_lng,
1355             address _referrer
1356             )
1357                 validatePurchase(_plots_lat, _plots_lng) 
1358                 validateLand(_plots_lat, _plots_lng) 
1359                 updateUsersLastAccess()
1360                 public payable {
1361        require(_name.length > 4);
1362        
1363         // split payment
1364         uint256 _runningTotal = msg.value;
1365         
1366         _runningTotal = _runningTotal.sub(processReferer(_referrer));
1367         
1368         /*
1369         uint256 _referrerAmnt = 0;
1370         if(_referrer != msg.sender && _referrer != address(0)) {
1371             _referrerAmnt = m_refPercent.mul(msg.value);
1372             if(_referrer.send(_referrerAmnt)) {
1373                 emit referralPaid(_referrer, _referrer, _referrerAmnt, now);
1374                 _runningTotal = _runningTotal.sub(_referrerAmnt);
1375             }
1376         }
1377         */
1378         tax_fund = tax_fund.add(m_newPlot_taxPercent.mul(_runningTotal));
1379         
1380         
1381         processDevPayment(_runningTotal);
1382         /*
1383         if(!devBankAddress.send(m_newPlot_devPercent.mul(_runningTotal))){
1384             devHoldings = devHoldings.add(m_newPlot_devPercent.mul(_runningTotal));
1385         }
1386         */
1387         
1388         
1389 
1390         processPurchase(_name, _plots_lat, _plots_lng);
1391         
1392         calcPlayerDivs(m_newPlot_taxPercent.mul(_runningTotal));
1393         
1394         game_started = true;
1395         
1396         if(_plots_lat.length >= min_plots_purchase_for_token_reward
1397             && tokens_rewards_available > 0) {
1398                 
1399             uint256 _token_rewards = _plots_lat.length / plots_token_reward_divisor;
1400             if(_token_rewards > tokens_rewards_available)
1401                 _token_rewards = tokens_rewards_available;
1402                 
1403                 
1404             planetCryptoCoin_interface.transfer(msg.sender, _token_rewards);
1405                 
1406             emit issueCoinTokens(msg.sender, msg.sender, _token_rewards, now);
1407             tokens_rewards_allocated = tokens_rewards_allocated + _token_rewards;
1408             tokens_rewards_available = tokens_rewards_available - _token_rewards;
1409         }
1410     
1411     }
1412     
1413     function processReferer(address _referrer) internal returns(uint256) {
1414         uint256 _referrerAmnt = 0;
1415         if(_referrer != msg.sender && _referrer != address(0)) {
1416             _referrerAmnt = m_refPercent.mul(msg.value);
1417             if(_referrer.send(_referrerAmnt)) {
1418                 emit referralPaid(_referrer, _referrer, _referrerAmnt, now);
1419                 //_runningTotal = _runningTotal.sub(_referrerAmnt);
1420             }
1421         }
1422         return _referrerAmnt;
1423     }
1424     
1425     
1426     function processDevPayment(uint256 _runningTotal) internal {
1427         if(!devBankAddress.send(m_newPlot_devPercent.mul(_runningTotal))){
1428             devHoldings = devHoldings.add(m_newPlot_devPercent.mul(_runningTotal));
1429         }
1430     }
1431 
1432     function buyCard(uint256 _token_id, address _referrer) validateResale(_token_id) updateUsersLastAccess() public payable {
1433         
1434         
1435         // split payment
1436         uint256 _runningTotal = msg.value;
1437         _runningTotal = _runningTotal.sub(processReferer(_referrer));
1438         /*
1439         uint256 _referrerAmnt = 0;
1440         if(_referrer != msg.sender && _referrer != address(0)) {
1441             _referrerAmnt = m_refPercent.mul(msg.value);
1442             if(_referrer.send(_referrerAmnt)) {
1443                 emit referralPaid(_referrer, _referrer, _referrerAmnt, now);
1444                 _runningTotal = _runningTotal.sub(_referrerAmnt);
1445             }
1446         }
1447         */
1448         
1449         tax_fund = tax_fund.add(m_resalePlot_taxPercent.mul(_runningTotal));
1450         
1451         
1452         processDevPayment(_runningTotal);
1453         /*
1454         if(!devBankAddress.send(m_resalePlot_devPercent.mul(_runningTotal))){
1455             devHoldings = devHoldings.add(m_resalePlot_devPercent.mul(_runningTotal));
1456         }
1457         */
1458         
1459 
1460         address from = ownerOf(_token_id);
1461         
1462         if(!from.send(m_resalePlot_ownerPercent.mul(_runningTotal))) {
1463             playersFundsOwed[from] = playersFundsOwed[from].add(m_resalePlot_ownerPercent.mul(_runningTotal));
1464         }
1465         
1466         
1467 
1468         //our_transferFrom(from, msg.sender, _token_id);
1469         process_swap(from,msg.sender,_token_id);
1470         internal_transferFrom(from, msg.sender, _token_id);
1471         
1472 
1473         plotDetail memory _plotDetail = plotDetails[tokenIDplotdetailsIndexId[_token_id]];
1474         uint256 _empireScore = _plotDetail.empire_score; // apply bonus when card is bought through site
1475         uint256 _newEmpireScore = m_empireScoreMultiplier.mul(_empireScore);
1476         uint256 _origValue = _plotDetail.current_value;
1477         
1478         //uint256 _playerObject_idx = playerAddressToPlayerObjectID[msg.sender];
1479         
1480 
1481         all_playerObjects[playerAddressToPlayerObjectID[msg.sender]].totalEmpireScore
1482             = all_playerObjects[playerAddressToPlayerObjectID[msg.sender]].totalEmpireScore + (_newEmpireScore - _empireScore);
1483         
1484         
1485         plotDetails[tokenIDplotdetailsIndexId[_token_id]].empire_score = _newEmpireScore;
1486 
1487         total_empire_score = total_empire_score + (_newEmpireScore - _empireScore);
1488         
1489         plotDetails[tokenIDplotdetailsIndexId[_token_id]].current_value = 
1490             m_resaleMultipler.mul(plotDetails[tokenIDplotdetailsIndexId[_token_id]].current_value);
1491         
1492         total_trades = total_trades + 1;
1493         
1494         
1495         calcPlayerDivs(m_resalePlot_taxPercent.mul(_runningTotal));
1496         
1497         
1498         // emit event
1499         emit cardBought(_token_id, from, msg.sender,
1500                     _token_id, from, msg.sender, 
1501                     _plotDetail.name,
1502                     _origValue, 
1503                     msg.value,
1504                     _empireScore, _newEmpireScore, now);
1505     }
1506     
1507     function processPurchase(bytes32 _name, 
1508             int256[] _plots_lat, int256[] _plots_lng) internal {
1509     
1510         uint256 _token_id = totalSupply().add(1);
1511         _mint(msg.sender, _token_id);
1512         
1513 
1514         
1515 
1516        // uint256 _empireScore =
1517     //                current_plot_empire_score * _plots_lng.length;
1518             
1519             
1520         plotDetails.push(plotDetail(
1521             _name,
1522             current_plot_price * _plots_lat.length,
1523             current_plot_price * _plots_lat.length,
1524             current_plot_empire_score * _plots_lng.length,
1525             _plots_lat, _plots_lng, ''
1526         ));
1527         
1528         tokenIDplotdetailsIndexId[_token_id] = plotDetails.length-1;
1529         
1530         
1531         setupPlotOwnership(_token_id, _plots_lat, _plots_lng);
1532         
1533         
1534         
1535         uint256 _playerObject_idx = playerAddressToPlayerObjectID[msg.sender];
1536         all_playerObjects[_playerObject_idx].totalEmpireScore
1537             = all_playerObjects[playerAddressToPlayerObjectID[msg.sender]].totalEmpireScore + (current_plot_empire_score * _plots_lng.length);
1538             
1539         total_empire_score = total_empire_score + (current_plot_empire_score * _plots_lng.length);
1540             
1541         all_playerObjects[_playerObject_idx].totalLand
1542             = all_playerObjects[_playerObject_idx].totalLand + _plots_lat.length;
1543             
1544         
1545         emit landPurchased(
1546                 _token_id, msg.sender,
1547                 _token_id, msg.sender, _name, _plots_lat[0], _plots_lng[0], _plots_lat.length, current_plot_price, (current_plot_empire_score * _plots_lng.length), now);
1548 
1549 
1550         current_plot_price = current_plot_price + (price_update_amount * _plots_lat.length);
1551         total_land_sold = total_land_sold + _plots_lat.length;
1552         
1553     }
1554 
1555     function updateCardDetail(uint256 _token_id, uint256 _updateType, bytes32 _data) public payable {
1556         require(msg.sender == ownerOf(_token_id));
1557         if(_updateType == 1) {
1558             // CardImage
1559             require(msg.value == cardImageCost);
1560             
1561             plotDetails[
1562                     tokenIDplotdetailsIndexId[_token_id]
1563                         ].img = _data;
1564 
1565         }
1566         if(_updateType == 2) {
1567             // Name change
1568             require(_data.length > 4);
1569             require(msg.value == cardChangeNameCost);
1570             plotDetails[
1571                     tokenIDplotdetailsIndexId[_token_id]
1572                         ].name = _data;
1573         }
1574         
1575         
1576         processDevPayment(msg.value);
1577         /*
1578         if(!devBankAddress.send(msg.value)){
1579             devHoldings = devHoldings.add(msg.value);
1580         }
1581         */
1582         
1583         emit cardChange(
1584             _token_id,
1585             msg.sender, 
1586             _token_id, msg.sender, _updateType, _data, now);
1587             
1588     }
1589     
1590     
1591     
1592 
1593 
1594     
1595     
1596     function calcPlayerDivs(uint256 _value) internal {
1597         // total up amount split so we can emit it
1598         //if(totalSupply() > 1) {
1599         if(game_started) {
1600             uint256 _totalDivs = 0;
1601             uint256 _totalPlayers = 0;
1602             
1603             uint256 _taxToDivide = _value + tax_carried_forward;
1604             
1605             // ignore player 0
1606             for(uint256 c=1; c< all_playerObjects.length; c++) {
1607                 
1608                 // allow for 0.0001 % =  * 10000
1609                 
1610                 uint256 _playersPercent 
1611                     = (all_playerObjects[c].totalEmpireScore*10000000 / total_empire_score * 10000000) / 10000000;
1612                     
1613                 uint256 _playerShare = _taxToDivide / 10000000 * _playersPercent;
1614                 
1615 
1616                 
1617                 if(_playerShare > 0) {
1618                     
1619                     
1620                     playersFundsOwed[all_playerObjects[c].playerAddress] = playersFundsOwed[all_playerObjects[c].playerAddress].add(_playerShare);
1621                     tax_distributed = tax_distributed.add(_playerShare);
1622                     
1623                     _totalDivs = _totalDivs + _playerShare;
1624                     _totalPlayers = _totalPlayers + 1;
1625                 
1626                 }
1627             }
1628 
1629             tax_carried_forward = 0;
1630             emit taxDistributed(_totalDivs, _totalPlayers, now);
1631 
1632         } else {
1633             // first land purchase - no divs this time, carried forward
1634             tax_carried_forward = tax_carried_forward + _value;
1635         }
1636     }
1637     
1638 
1639     
1640     
1641     function setupPlotOwnership(uint256 _token_id, int256[] _plots_lat, int256[] _plots_lng) internal {
1642 
1643        for(uint256 c=0;c< _plots_lat.length;c++) {
1644          
1645             //mapping(int256 => mapping(int256 => uint256)) internal latlngTokenID_grids;
1646             latlngTokenID_grids[_plots_lat[c]]
1647                 [_plots_lng[c]] = _token_id;
1648                 
1649             //mapping(uint256 => plotBasic[]) internal tokenIDlatlngLookup;
1650             /*
1651             tokenIDlatlngLookup[_token_id].push(plotBasic(
1652                 _plots_lat[c], _plots_lng[c]
1653             ));
1654             */
1655             
1656         }
1657        
1658         
1659         //int256 _latInt = _plots_lat[0];
1660         //int256 _lngInt = _plots_lng[0];
1661 
1662 
1663         for(uint8 zoomC = 1; c < 5; c++) {
1664             setupZoomLvl(zoomC,_plots_lat[0], _plots_lng[0], _token_id); // correct rounding / 10 on way out    
1665         }
1666         /*
1667         setupZoomLvl(1,_plots_lat[0], _plots_lng[0], _token_id); // correct rounding / 10 on way out
1668         setupZoomLvl(2,_plots_lat[0], _plots_lng[0], _token_id); // correct rounding / 100
1669         setupZoomLvl(3,_plots_lat[0], _plots_lng[0], _token_id); // correct rounding / 1000
1670         setupZoomLvl(4,_plots_lat[0], _plots_lng[0], _token_id); // correct rounding / 10000
1671         */
1672 
1673       
1674     }
1675 
1676 
1677 
1678     // TO TEST
1679     function setupZoomLvl(uint8 zoom, int256 lat, int256 lng, uint256 _token_id) internal  {
1680         
1681         lat = planetCryptoUtils_interface.roundLatLngFull(zoom, lat);
1682         lng = planetCryptoUtils_interface.roundLatLngFull(zoom, lng);
1683         
1684         
1685         /*
1686         lat = planetCryptoUtils_interface.roundLatLng(zoom, lat);
1687         lng  = planetCryptoUtils_interface.roundLatLng(zoom, lng); 
1688         
1689         
1690         uint256 _remover = 5;
1691         if(zoom == 1)
1692             _remover = 5;
1693         if(zoom == 2)
1694             _remover = 4;
1695         if(zoom == 3)
1696             _remover = 3;
1697         if(zoom == 4)
1698             _remover = 2;
1699         
1700         string memory _latStr;  // = int2str(lat);
1701         string memory _lngStr; // = int2str(lng);
1702         
1703         
1704         bool _tIsNegative = false;
1705         
1706         if(lat < 0) {
1707             _tIsNegative = true;   
1708             lat = lat * -1;
1709         }
1710         _latStr = planetCryptoUtils_interface.int2str(lat);
1711         _latStr = planetCryptoUtils_interface.substring(_latStr,0,planetCryptoUtils_interface.utfStringLength(_latStr)-_remover); //_lat_len-_remover);
1712         lat = int256(planetCryptoUtils_interface.parseInt(_latStr,0));
1713         if(_tIsNegative)
1714             lat = lat * -1;
1715 
1716         
1717         if(lng < 0) {
1718             _tIsNegative = true;
1719             lng = lng * -1;
1720         } else {
1721             _tIsNegative = false;
1722         }
1723         _lngStr = planetCryptoUtils_interface.int2str(lng);
1724         _lngStr = planetCryptoUtils_interface.substring(_lngStr,0,planetCryptoUtils_interface.utfStringLength(_lngStr)-_remover);
1725         lng = int256(planetCryptoUtils_interface.parseInt(_lngStr,0));
1726         if(_tIsNegative)
1727             lng = lng * -1;
1728     
1729         */
1730         
1731         latlngTokenID_zoomAll[zoom][lat][lng] = _token_id;
1732         tokenIDlatlngLookup_zoomAll[zoom][_token_id].push(plotBasic(lat,lng));
1733  
1734         
1735         
1736     }
1737 
1738 
1739 
1740 
1741     
1742 
1743 
1744     function getAllPlayerObjectLen() public view returns(uint256){
1745         return all_playerObjects.length;
1746     }
1747     
1748 
1749     function queryMap(uint8 zoom, int256[] lat_rows, int256[] lng_columns) public view returns(string _outStr) {
1750         
1751         
1752         for(uint256 y=0; y< lat_rows.length; y++) {
1753 
1754             for(uint256 x=0; x< lng_columns.length; x++) {
1755                 
1756                 
1757                 
1758                 if(zoom == 0){
1759                     if(latlngTokenID_grids[lat_rows[y]][lng_columns[x]] > 0){
1760                         
1761                         
1762                       _outStr = planetCryptoUtils_interface.strConcat(
1763                             _outStr, '[', planetCryptoUtils_interface.int2str(lat_rows[y]) , ':', planetCryptoUtils_interface.int2str(lng_columns[x]) );
1764                       _outStr = planetCryptoUtils_interface.strConcat(_outStr, ':', 
1765                                     planetCryptoUtils_interface.uint2str(latlngTokenID_grids[lat_rows[y]][lng_columns[x]]), ']');
1766                     }
1767                     
1768                 } else {
1769                     //_out[c] = latlngTokenID_zoomAll[zoom][lat_rows[y]][lng_columns[x]];
1770                     if(latlngTokenID_zoomAll[zoom][lat_rows[y]][lng_columns[x]] > 0){
1771                       _outStr = planetCryptoUtils_interface.strConcat(_outStr, '[', planetCryptoUtils_interface.int2str(lat_rows[y]) , ':', planetCryptoUtils_interface.int2str(lng_columns[x]) );
1772                       _outStr = planetCryptoUtils_interface.strConcat(_outStr, ':', 
1773                                     planetCryptoUtils_interface.uint2str(latlngTokenID_zoomAll[zoom][lat_rows[y]][lng_columns[x]]), ']');
1774                     }
1775                     
1776                 }
1777                 //c = c+1;
1778                 
1779             }
1780         }
1781         
1782         //return _out;
1783     }
1784     // used in utils
1785     function queryPlotExists(uint8 zoom, int256[] lat_rows, int256[] lng_columns) public view returns(bool) {
1786         
1787         
1788         for(uint256 y=0; y< lat_rows.length; y++) {
1789 
1790             for(uint256 x=0; x< lng_columns.length; x++) {
1791                 
1792                 if(zoom == 0){
1793                     if(latlngTokenID_grids[lat_rows[y]][lng_columns[x]] > 0){
1794                         return true;
1795                     } 
1796                 } else {
1797                     if(latlngTokenID_zoomAll[zoom][lat_rows[y]][lng_columns[x]] > 0){
1798 
1799                         return true;
1800                         
1801                     }                     
1802                 }
1803            
1804                 
1805             }
1806         }
1807         
1808         return false;
1809     }
1810 
1811     
1812 
1813     
1814 
1815    
1816 
1817 
1818 
1819 
1820     // ERC721 overrides
1821     
1822     function safeTransferFrom(address from, address to, uint256 tokenId) public {
1823         safeTransferFrom(from, to, tokenId, "");
1824     }
1825     function safeTransferFrom(address from, address to, uint256 tokenId, bytes _data) public {
1826         transferFrom(from, to, tokenId);
1827         // solium-disable-next-line arg-overflow
1828         require(_checkOnERC721Received(from, to, tokenId, _data));
1829     }
1830     
1831 
1832 
1833     function transferFrom(address from, address to, uint256 tokenId) public {
1834         // check permission on the from address first
1835         require(_isApprovedOrOwner(msg.sender, tokenId));
1836         require(to != address(0));
1837         
1838         process_swap(from,to,tokenId);
1839         
1840         super.transferFrom(from, to, tokenId);
1841 
1842     }
1843     
1844     function process_swap(address from, address to, uint256 tokenId) internal {
1845 
1846         
1847         // remove the empire score & total land owned...
1848         uint256 _empireScore;
1849         uint256 _size;
1850         
1851         //plotDetail memory _plotDetail = plotDetails[tokenIDplotdetailsIndexId[tokenId]];
1852         _empireScore = plotDetails[tokenIDplotdetailsIndexId[tokenId]].empire_score;
1853         _size = plotDetails[tokenIDplotdetailsIndexId[tokenId]].plots_lat.length;
1854         
1855         uint256 _playerObject_idx = playerAddressToPlayerObjectID[from];
1856         
1857         all_playerObjects[_playerObject_idx].totalEmpireScore
1858             = all_playerObjects[_playerObject_idx].totalEmpireScore - _empireScore;
1859             
1860         all_playerObjects[_playerObject_idx].totalLand
1861             = all_playerObjects[_playerObject_idx].totalLand - _size;
1862             
1863         // and increment on the other side...
1864         _playerObject_idx = playerAddressToPlayerObjectID[to];
1865         
1866         // ensure the player is setup first...
1867         if(_playerObject_idx == 0){
1868             all_playerObjects.push(player(to,now,0,0));
1869             playerAddressToPlayerObjectID[to] = all_playerObjects.length-1;
1870             _playerObject_idx = all_playerObjects.length-1;
1871         }
1872         
1873         all_playerObjects[_playerObject_idx].totalEmpireScore
1874             = all_playerObjects[_playerObject_idx].totalEmpireScore + _empireScore;
1875             
1876         all_playerObjects[_playerObject_idx].totalLand
1877             = all_playerObjects[_playerObject_idx].totalLand + _size;
1878     }
1879 
1880 
1881    
1882 
1883 
1884     // PRIVATE METHODS
1885     function p_update_action(uint256 _type, address _address, uint256 _val, string _strVal) public onlyOwner {
1886         if(_type == 0){
1887             owner = _address;    
1888         }
1889         if(_type == 1){
1890             tokenBankAddress = _address;    
1891         }
1892         if(_type == 2) {
1893             devBankAddress = _address;
1894         }
1895         if(_type == 3) {
1896             cardChangeNameCost = _val;    
1897         }
1898         if(_type == 4) {
1899             cardImageCost = _val;    
1900         }
1901         if(_type == 5) {
1902             baseURI = _strVal;
1903         }
1904         if(_type == 6) {
1905             price_update_amount = _val;
1906         }
1907         if(_type == 7) {
1908             current_plot_empire_score = _val;    
1909         }
1910         if(_type == 8) {
1911             planetCryptoCoinAddress = _address;
1912             if(address(planetCryptoCoinAddress) != address(0)){ 
1913                 planetCryptoCoin_interface = PlanetCryptoCoin_I(planetCryptoCoinAddress);
1914             }
1915         }
1916         if(_type ==9) {
1917             planetCryptoUtilsAddress = _address;
1918             if(address(planetCryptoUtilsAddress) != address(0)){ 
1919                 planetCryptoUtils_interface = PlanetCryptoUtils_I(planetCryptoUtilsAddress);
1920             }            
1921         }
1922         if(_type == 10) {
1923             m_newPlot_devPercent = Percent.percent(_val,100);    
1924         }
1925         if(_type == 11) {
1926             m_newPlot_taxPercent = Percent.percent(_val,100);    
1927         }
1928         if(_type == 12) {
1929             m_resalePlot_devPercent = Percent.percent(_val,100);    
1930         }
1931         if(_type == 13) {
1932             m_resalePlot_taxPercent = Percent.percent(_val,100);    
1933         }
1934         if(_type == 14) {
1935             m_resalePlot_ownerPercent = Percent.percent(_val,100);    
1936         }
1937         if(_type == 15) {
1938             m_refPercent = Percent.percent(_val,100);    
1939         }
1940         if(_type == 16) {
1941             m_empireScoreMultiplier = Percent.percent(_val, 100);    
1942         }
1943         if(_type == 17) {
1944             m_resaleMultipler = Percent.percent(_val, 100);    
1945         }
1946         if(_type == 18) {
1947             tokens_rewards_available = _val;    
1948         }
1949         if(_type == 19) {
1950             tokens_rewards_allocated = _val;    
1951         }
1952         if(_type == 20) {
1953             // clear card image 
1954             plotDetails[
1955                     tokenIDplotdetailsIndexId[_val]
1956                         ].img = '';
1957                         
1958             emit cardChange(
1959                 _val,
1960                 msg.sender, 
1961                 _val, msg.sender, 1, '', now);
1962         }
1963         if(_type == 99) {
1964             // burnToken 
1965         
1966             address _token_owner = ownerOf(_val);
1967             processBurn(_token_owner, _val);
1968         
1969         }
1970     }
1971     
1972     function burn(uint256 _token_id) public {
1973         require(msg.sender == ownerOf(_token_id));
1974         
1975         uint256 _cardSize = plotDetails[tokenIDplotdetailsIndexId[_token_id]].plots_lat.length;
1976         
1977         processBurn(msg.sender, _token_id);
1978         
1979         // allocate PlanetCOIN tokens to user...
1980         planetCryptoCoin_interface.transfer(msg.sender, _cardSize);
1981         
1982         
1983         
1984     }
1985     
1986     function processBurn(address _token_owner, uint256 _val) internal {
1987         _burn(_token_owner, _val);
1988             
1989         // remove the empire score & total land owned...
1990         uint256 _empireScore;
1991         uint256 _size;
1992         
1993         //plotDetail memory _plotDetail = plotDetails[tokenIDplotdetailsIndexId[_val]];
1994         _empireScore = plotDetails[tokenIDplotdetailsIndexId[_val]].empire_score;
1995         _size = plotDetails[tokenIDplotdetailsIndexId[_val]].plots_lat.length;
1996         
1997         uint256 _playerObject_idx = playerAddressToPlayerObjectID[_token_owner];
1998         
1999         all_playerObjects[_playerObject_idx].totalEmpireScore
2000             = all_playerObjects[_playerObject_idx].totalEmpireScore - _empireScore;
2001             
2002         all_playerObjects[_playerObject_idx].totalLand
2003             = all_playerObjects[_playerObject_idx].totalLand - _size;
2004             
2005        
2006         /*
2007         for(uint256 c=0;c < tokenIDlatlngLookup[_tokenId].length; c++) {
2008             latlngTokenID_grids[
2009                     tokenIDlatlngLookup[_tokenId][c].lat
2010                 ][tokenIDlatlngLookup[_tokenId][c].lng] = 0;
2011         }
2012         delete tokenIDlatlngLookup[_tokenId];
2013         */
2014         
2015         
2016         
2017         //Same for tokenIDplotdetailsIndexId        
2018         // clear from plotDetails array... (Holds the detail of the card)
2019         uint256 oldIndex = tokenIDplotdetailsIndexId[_val];
2020         if(oldIndex != plotDetails.length-1) {
2021             plotDetails[oldIndex] = plotDetails[plotDetails.length-1];
2022         }
2023         plotDetails.length--;
2024         
2025 
2026         delete tokenIDplotdetailsIndexId[_val];
2027 
2028         for(uint8 zoom=1; zoom < 5; zoom++) {
2029             plotBasic[] storage _plotBasicList = tokenIDlatlngLookup_zoomAll[zoom][_val];
2030             for(uint256 _plotsC=0; _plotsC< _plotBasicList.length; _plotsC++) {
2031                 delete latlngTokenID_zoomAll[zoom][
2032                     _plotBasicList[_plotsC].lat
2033                     ][
2034                         _plotBasicList[_plotsC].lng
2035                         ];
2036                         
2037                 delete _plotBasicList[_plotsC];
2038             }
2039             
2040         }
2041     }
2042 
2043     function p_withdrawDevHoldings() public {
2044         require(msg.sender == devBankAddress);
2045         uint256 _t = devHoldings;
2046         devHoldings = 0;
2047         if(!devBankAddress.send(devHoldings)){
2048             devHoldings = _t;
2049         }
2050     }
2051 
2052 
2053 
2054 
2055     function m() public {
2056         
2057     }
2058     
2059 }