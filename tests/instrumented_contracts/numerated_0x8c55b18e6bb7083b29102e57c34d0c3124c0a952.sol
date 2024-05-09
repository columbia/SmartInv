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
73 // current address: 0x499E33164116002329Bf4bB8f7B2dfc97A31F223
74 
75 
76 
77 
78 
79 
80 
81 
82 
83 
84 
85 
86 /**
87  * @title ERC721 Non-Fungible Token Standard basic interface
88  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
89  */
90 contract IERC721 is IERC165 {
91 
92   event Transfer(
93     address indexed from,
94     address indexed to,
95     uint256 indexed tokenId
96   );
97   event Approval(
98     address indexed owner,
99     address indexed approved,
100     uint256 indexed tokenId
101   );
102   event ApprovalForAll(
103     address indexed owner,
104     address indexed operator,
105     bool approved
106   );
107 
108   function balanceOf(address owner) public view returns (uint256 balance);
109   function ownerOf(uint256 tokenId) public view returns (address owner);
110 
111   function approve(address to, uint256 tokenId) public;
112   function getApproved(uint256 tokenId)
113     public view returns (address operator);
114 
115   function setApprovalForAll(address operator, bool _approved) public;
116   function isApprovedForAll(address owner, address operator)
117     public view returns (bool);
118 
119   function transferFrom(address from, address to, uint256 tokenId) public;
120   function safeTransferFrom(address from, address to, uint256 tokenId)
121     public;
122 
123   function safeTransferFrom(
124     address from,
125     address to,
126     uint256 tokenId,
127     bytes data
128   )
129     public;
130 }
131 
132 
133 /**
134  * @title ERC721 token receiver interface
135  * @dev Interface for any contract that wants to support safeTransfers
136  * from ERC721 asset contracts.
137  */
138 contract IERC721Receiver {
139   /**
140    * @notice Handle the receipt of an NFT
141    * @dev The ERC721 smart contract calls this function on the recipient
142    * after a `safeTransfer`. This function MUST return the function selector,
143    * otherwise the caller will revert the transaction. The selector to be
144    * returned can be obtained as `this.onERC721Received.selector`. This
145    * function MAY throw to revert and reject the transfer.
146    * Note: the ERC721 contract address is always the message sender.
147    * @param operator The address which called `safeTransferFrom` function
148    * @param from The address which previously owned the token
149    * @param tokenId The NFT identifier which is being transferred
150    * @param data Additional data with no specified format
151    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
152    */
153   function onERC721Received(
154     address operator,
155     address from,
156     uint256 tokenId,
157     bytes data
158   )
159     public
160     returns(bytes4);
161 }
162 
163 
164 /**
165  * @title SafeMath
166  * @dev Math operations with safety checks that revert on error
167  */
168 library SafeMath {
169 
170   /**
171   * @dev Multiplies two numbers, reverts on overflow.
172   */
173   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
174     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
175     // benefit is lost if 'b' is also tested.
176     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
177     if (a == 0) {
178       return 0;
179     }
180 
181     uint256 c = a * b;
182     require(c / a == b);
183 
184     return c;
185   }
186 
187   /**
188   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
189   */
190   function div(uint256 a, uint256 b) internal pure returns (uint256) {
191     require(b > 0); // Solidity only automatically asserts when dividing by 0
192     uint256 c = a / b;
193     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
194 
195     return c;
196   }
197 
198   /**
199   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
200   */
201   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
202     require(b <= a);
203     uint256 c = a - b;
204 
205     return c;
206   }
207 
208   /**
209   * @dev Adds two numbers, reverts on overflow.
210   */
211   function add(uint256 a, uint256 b) internal pure returns (uint256) {
212     uint256 c = a + b;
213     require(c >= a);
214 
215     return c;
216   }
217 
218   /**
219   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
220   * reverts when dividing by zero.
221   */
222   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
223     require(b != 0);
224     return a % b;
225   }
226 }
227 
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
256 
257 /**
258  * @title ERC721 Non-Fungible Token Standard basic implementation
259  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
260  */
261 contract ERC721_custom is ERC165, IERC721 {
262 
263   using SafeMath for uint256;
264   using Address for address;
265 
266   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
267   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
268   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
269 
270   // Mapping from token ID to owner
271   mapping (uint256 => address) private _tokenOwner;
272 
273   // Mapping from token ID to approved address
274   mapping (uint256 => address) private _tokenApprovals;
275 
276   // Mapping from owner to number of owned token
277   mapping (address => uint256) private _ownedTokensCount;
278 
279   // Mapping from owner to operator approvals
280   mapping (address => mapping (address => bool)) private _operatorApprovals;
281 
282   bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
283   /*
284    * 0x80ac58cd ===
285    *   bytes4(keccak256('balanceOf(address)')) ^
286    *   bytes4(keccak256('ownerOf(uint256)')) ^
287    *   bytes4(keccak256('approve(address,uint256)')) ^
288    *   bytes4(keccak256('getApproved(uint256)')) ^
289    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
290    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
291    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
292    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
293    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
294    */
295 
296   constructor()
297     public
298   {
299     // register the supported interfaces to conform to ERC721 via ERC165
300     _registerInterface(_InterfaceId_ERC721);
301   }
302 
303   /**
304    * @dev Gets the balance of the specified address
305    * @param owner address to query the balance of
306    * @return uint256 representing the amount owned by the passed address
307    */
308   function balanceOf(address owner) public view returns (uint256) {
309     require(owner != address(0));
310     return _ownedTokensCount[owner];
311   }
312 
313   /**
314    * @dev Gets the owner of the specified token ID
315    * @param tokenId uint256 ID of the token to query the owner of
316    * @return owner address currently marked as the owner of the given token ID
317    */
318   function ownerOf(uint256 tokenId) public view returns (address) {
319     address owner = _tokenOwner[tokenId];
320     require(owner != address(0));
321     return owner;
322   }
323 
324   /**
325    * @dev Approves another address to transfer the given token ID
326    * The zero address indicates there is no approved address.
327    * There can only be one approved address per token at a given time.
328    * Can only be called by the token owner or an approved operator.
329    * @param to address to be approved for the given token ID
330    * @param tokenId uint256 ID of the token to be approved
331    */
332   function approve(address to, uint256 tokenId) public {
333     address owner = ownerOf(tokenId);
334     require(to != owner);
335     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
336 
337     _tokenApprovals[tokenId] = to;
338     emit Approval(owner, to, tokenId);
339   }
340 
341   /**
342    * @dev Gets the approved address for a token ID, or zero if no address set
343    * Reverts if the token ID does not exist.
344    * @param tokenId uint256 ID of the token to query the approval of
345    * @return address currently approved for the given token ID
346    */
347   function getApproved(uint256 tokenId) public view returns (address) {
348     require(_exists(tokenId));
349     return _tokenApprovals[tokenId];
350   }
351 
352   /**
353    * @dev Sets or unsets the approval of a given operator
354    * An operator is allowed to transfer all tokens of the sender on their behalf
355    * @param to operator address to set the approval
356    * @param approved representing the status of the approval to be set
357    */
358   function setApprovalForAll(address to, bool approved) public {
359     require(to != msg.sender);
360     _operatorApprovals[msg.sender][to] = approved;
361     emit ApprovalForAll(msg.sender, to, approved);
362   }
363 
364   /**
365    * @dev Tells whether an operator is approved by a given owner
366    * @param owner owner address which you want to query the approval of
367    * @param operator operator address which you want to query the approval of
368    * @return bool whether the given operator is approved by the given owner
369    */
370   function isApprovedForAll(
371     address owner,
372     address operator
373   )
374     public
375     view
376     returns (bool)
377   {
378     return _operatorApprovals[owner][operator];
379   }
380 
381   /**
382    * @dev Transfers the ownership of a given token ID to another address
383    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
384    * Requires the msg sender to be the owner, approved, or operator
385    * @param from current owner of the token
386    * @param to address to receive the ownership of the given token ID
387    * @param tokenId uint256 ID of the token to be transferred
388   */
389   function transferFrom(
390     address from,
391     address to,
392     uint256 tokenId
393   )
394     public
395   {
396     require(_isApprovedOrOwner(msg.sender, tokenId));
397     require(to != address(0));
398 
399     _clearApproval(from, tokenId);
400     _removeTokenFrom(from, tokenId);
401     _addTokenTo(to, tokenId);
402 
403     emit Transfer(from, to, tokenId);
404   }
405   
406   
407   
408   
409     function internal_transferFrom(
410         address _from,
411         address to,
412         uint256 tokenId
413     )
414     internal
415   {
416     // permissions already checked on price basis
417     
418     require(to != address(0));
419 
420     if (_tokenApprovals[tokenId] != address(0)) {
421       _tokenApprovals[tokenId] = address(0);
422     }
423     
424     //_removeTokenFrom(from, tokenId);
425     if(_ownedTokensCount[_from] > 1) {
426     _ownedTokensCount[_from] = _ownedTokensCount[_from] -1; //.sub(1); // error here
427     // works without .sub()????
428     
429     }
430     _tokenOwner[tokenId] = address(0); 
431     
432     _addTokenTo(to, tokenId); // error here?
433 
434     emit Transfer(_from, to, tokenId);
435     
436   }
437 
438   /**
439    * @dev Safely transfers the ownership of a given token ID to another address
440    * If the target address is a contract, it must implement `onERC721Received`,
441    * which is called upon a safe transfer, and return the magic value
442    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
443    * the transfer is reverted.
444    *
445    * Requires the msg sender to be the owner, approved, or operator
446    * @param from current owner of the token
447    * @param to address to receive the ownership of the given token ID
448    * @param tokenId uint256 ID of the token to be transferred
449   */
450   function safeTransferFrom(
451     address from,
452     address to,
453     uint256 tokenId
454   )
455     public
456   {
457     // solium-disable-next-line arg-overflow
458     safeTransferFrom(from, to, tokenId, "");
459   }
460 
461   /**
462    * @dev Safely transfers the ownership of a given token ID to another address
463    * If the target address is a contract, it must implement `onERC721Received`,
464    * which is called upon a safe transfer, and return the magic value
465    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
466    * the transfer is reverted.
467    * Requires the msg sender to be the owner, approved, or operator
468    * @param from current owner of the token
469    * @param to address to receive the ownership of the given token ID
470    * @param tokenId uint256 ID of the token to be transferred
471    * @param _data bytes data to send along with a safe transfer check
472    */
473   function safeTransferFrom(
474     address from,
475     address to,
476     uint256 tokenId,
477     bytes _data
478   )
479     public
480   {
481     transferFrom(from, to, tokenId);
482     // solium-disable-next-line arg-overflow
483     require(_checkOnERC721Received(from, to, tokenId, _data));
484   }
485 
486   /**
487    * @dev Returns whether the specified token exists
488    * @param tokenId uint256 ID of the token to query the existence of
489    * @return whether the token exists
490    */
491   function _exists(uint256 tokenId) internal view returns (bool) {
492     address owner = _tokenOwner[tokenId];
493     return owner != address(0);
494   }
495 
496   /**
497    * @dev Returns whether the given spender can transfer a given token ID
498    * @param spender address of the spender to query
499    * @param tokenId uint256 ID of the token to be transferred
500    * @return bool whether the msg.sender is approved for the given token ID,
501    *  is an operator of the owner, or is the owner of the token
502    */
503   function _isApprovedOrOwner(
504     address spender,
505     uint256 tokenId
506   )
507     internal
508     view
509     returns (bool)
510   {
511     address owner = ownerOf(tokenId);
512     // Disable solium check because of
513     // https://github.com/duaraghav8/Solium/issues/175
514     // solium-disable-next-line operator-whitespace
515     return (
516       spender == owner ||
517       getApproved(tokenId) == spender ||
518       isApprovedForAll(owner, spender)
519     );
520   }
521 
522   /**
523    * @dev Internal function to mint a new token
524    * Reverts if the given token ID already exists
525    * @param to The address that will own the minted token
526    * @param tokenId uint256 ID of the token to be minted by the msg.sender
527    */
528   function _mint(address to, uint256 tokenId) internal {
529     require(to != address(0));
530     _addTokenTo(to, tokenId);
531     emit Transfer(address(0), to, tokenId);
532   }
533 
534   /**
535    * @dev Internal function to burn a specific token
536    * Reverts if the token does not exist
537    * @param tokenId uint256 ID of the token being burned by the msg.sender
538    */
539   function _burn(address owner, uint256 tokenId) internal {
540     _clearApproval(owner, tokenId);
541     _removeTokenFrom(owner, tokenId);
542     emit Transfer(owner, address(0), tokenId);
543   }
544 
545   /**
546    * @dev Internal function to add a token ID to the list of a given address
547    * Note that this function is left internal to make ERC721Enumerable possible, but is not
548    * intended to be called by custom derived contracts: in particular, it emits no Transfer event.
549    * @param to address representing the new owner of the given token ID
550    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
551    */
552   function _addTokenTo(address to, uint256 tokenId) internal {
553     require(_tokenOwner[tokenId] == address(0));
554     _tokenOwner[tokenId] = to;
555     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
556   }
557 
558   /**
559    * @dev Internal function to remove a token ID from the list of a given address
560    * Note that this function is left internal to make ERC721Enumerable possible, but is not
561    * intended to be called by custom derived contracts: in particular, it emits no Transfer event,
562    * and doesn't clear approvals.
563    * @param from address representing the previous owner of the given token ID
564    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
565    */
566   function _removeTokenFrom(address from, uint256 tokenId) internal {
567     require(ownerOf(tokenId) == from);
568     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
569     _tokenOwner[tokenId] = address(0);
570   }
571   
572   
573 
574   /**
575    * @dev Internal function to invoke `onERC721Received` on a target address
576    * The call is not executed if the target address is not a contract
577    * @param from address representing the previous owner of the given token ID
578    * @param to target address that will receive the tokens
579    * @param tokenId uint256 ID of the token to be transferred
580    * @param _data bytes optional data to send along with the call
581    * @return whether the call correctly returned the expected magic value
582    */
583   function _checkOnERC721Received(
584     address from,
585     address to,
586     uint256 tokenId,
587     bytes _data
588   )
589     internal
590     returns (bool)
591   {
592     if (!to.isContract()) {
593       return true;
594     }
595     bytes4 retval = IERC721Receiver(to).onERC721Received(
596       msg.sender, from, tokenId, _data);
597     return (retval == _ERC721_RECEIVED);
598   }
599 
600   /**
601    * @dev Private function to clear current approval of a given token ID
602    * Reverts if the given address is not indeed the owner of the token
603    * @param owner owner of the token
604    * @param tokenId uint256 ID of the token to be transferred
605    */
606   function _clearApproval(address owner, uint256 tokenId) private {
607     require(ownerOf(tokenId) == owner);
608     if (_tokenApprovals[tokenId] != address(0)) {
609       _tokenApprovals[tokenId] = address(0);
610     }
611   }
612 }
613 
614 
615 
616 
617 
618 
619 /**
620  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
621  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
622  */
623 contract IERC721Enumerable is IERC721 {
624   function totalSupply() public view returns (uint256);
625   function tokenOfOwnerByIndex(
626     address owner,
627     uint256 index
628   )
629     public
630     view
631     returns (uint256 tokenId);
632 
633   function tokenByIndex(uint256 index) public view returns (uint256);
634 }
635 
636 
637 
638 /**
639  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
640  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
641  */
642 contract ERC721Enumerable_custom is ERC165, ERC721_custom, IERC721Enumerable {
643   // Mapping from owner to list of owned token IDs
644   mapping(address => uint256[]) private _ownedTokens;
645 
646   // Mapping from token ID to index of the owner tokens list
647   mapping(uint256 => uint256) private _ownedTokensIndex;
648 
649   // Array with all token ids, used for enumeration
650   uint256[] private _allTokens;
651 
652   // Mapping from token id to position in the allTokens array
653   mapping(uint256 => uint256) private _allTokensIndex;
654 
655   bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;
656   /**
657    * 0x780e9d63 ===
658    *   bytes4(keccak256('totalSupply()')) ^
659    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
660    *   bytes4(keccak256('tokenByIndex(uint256)'))
661    */
662 
663   /**
664    * @dev Constructor function
665    */
666   constructor() public {
667     // register the supported interface to conform to ERC721 via ERC165
668     _registerInterface(_InterfaceId_ERC721Enumerable);
669   }
670 
671   /**
672    * @dev Gets the token ID at a given index of the tokens list of the requested owner
673    * @param owner address owning the tokens list to be accessed
674    * @param index uint256 representing the index to be accessed of the requested tokens list
675    * @return uint256 token ID at the given index of the tokens list owned by the requested address
676    */
677   function tokenOfOwnerByIndex(
678     address owner,
679     uint256 index
680   )
681     public
682     view
683     returns (uint256)
684   {
685     require(index < balanceOf(owner));
686     return _ownedTokens[owner][index];
687   }
688 
689   /**
690    * @dev Gets the total amount of tokens stored by the contract
691    * @return uint256 representing the total amount of tokens
692    */
693   function totalSupply() public view returns (uint256) {
694     return _allTokens.length;
695   }
696 
697   /**
698    * @dev Gets the token ID at a given index of all the tokens in this contract
699    * Reverts if the index is greater or equal to the total number of tokens
700    * @param index uint256 representing the index to be accessed of the tokens list
701    * @return uint256 token ID at the given index of the tokens list
702    */
703   function tokenByIndex(uint256 index) public view returns (uint256) {
704     require(index < totalSupply());
705     return _allTokens[index];
706   }
707 
708   /**
709    * @dev Internal function to add a token ID to the list of a given address
710    * This function is internal due to language limitations, see the note in ERC721.sol.
711    * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event.
712    * @param to address representing the new owner of the given token ID
713    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
714    */
715   function _addTokenTo(address to, uint256 tokenId) internal {
716     super._addTokenTo(to, tokenId);
717     uint256 length = _ownedTokens[to].length;
718     _ownedTokens[to].push(tokenId);
719     _ownedTokensIndex[tokenId] = length;
720   }
721 
722   /**
723    * @dev Internal function to remove a token ID from the list of a given address
724    * This function is internal due to language limitations, see the note in ERC721.sol.
725    * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event,
726    * and doesn't clear approvals.
727    * @param from address representing the previous owner of the given token ID
728    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
729    */
730   function _removeTokenFrom(address from, uint256 tokenId) internal {
731     super._removeTokenFrom(from, tokenId);
732 
733     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
734     // then delete the last slot.
735     uint256 tokenIndex = _ownedTokensIndex[tokenId];
736     uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
737     uint256 lastToken = _ownedTokens[from][lastTokenIndex];
738 
739     _ownedTokens[from][tokenIndex] = lastToken;
740     // This also deletes the contents at the last position of the array
741     _ownedTokens[from].length--;
742 
743     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
744     // be zero. Then we can make sure that we will remove tokenId from the ownedTokens list since we are first swapping
745     // the lastToken to the first position, and then dropping the element placed in the last position of the list
746 
747     _ownedTokensIndex[tokenId] = 0;
748     _ownedTokensIndex[lastToken] = tokenIndex;
749   }
750 
751   /**
752    * @dev Internal function to mint a new token
753    * Reverts if the given token ID already exists
754    * @param to address the beneficiary that will own the minted token
755    * @param tokenId uint256 ID of the token to be minted by the msg.sender
756    */
757   function _mint(address to, uint256 tokenId) internal {
758     super._mint(to, tokenId);
759 
760     _allTokensIndex[tokenId] = _allTokens.length;
761     _allTokens.push(tokenId);
762   }
763 
764   /**
765    * @dev Internal function to burn a specific token
766    * Reverts if the token does not exist
767    * @param owner owner of the token to burn
768    * @param tokenId uint256 ID of the token being burned by the msg.sender
769    */
770   function _burn(address owner, uint256 tokenId) internal {
771     super._burn(owner, tokenId);
772 
773     // Reorg all tokens array
774     uint256 tokenIndex = _allTokensIndex[tokenId];
775     uint256 lastTokenIndex = _allTokens.length.sub(1);
776     uint256 lastToken = _allTokens[lastTokenIndex];
777 
778     _allTokens[tokenIndex] = lastToken;
779     _allTokens[lastTokenIndex] = 0;
780 
781     _allTokens.length--;
782     _allTokensIndex[tokenId] = 0;
783     _allTokensIndex[lastToken] = tokenIndex;
784   }
785 }
786 
787 
788 
789 
790 
791 
792 
793 
794 contract IERC721Metadata is IERC721 {
795   function name() external view returns (string);
796   function symbol() external view returns (string);
797   function tokenURI(uint256 tokenId) external view returns (string);
798 }
799 
800 
801 contract ERC721Metadata_custom is ERC165, ERC721_custom, IERC721Metadata {
802   // Token name
803   string private _name;
804 
805   // Token symbol
806   string private _symbol;
807 
808   // Optional mapping for token URIs
809   mapping(uint256 => string) private _tokenURIs;
810 
811   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
812   /**
813    * 0x5b5e139f ===
814    *   bytes4(keccak256('name()')) ^
815    *   bytes4(keccak256('symbol()')) ^
816    *   bytes4(keccak256('tokenURI(uint256)'))
817    */
818 
819   /**
820    * @dev Constructor function
821    */
822   constructor(string name, string symbol) public {
823     _name = name;
824     _symbol = symbol;
825 
826     // register the supported interfaces to conform to ERC721 via ERC165
827     _registerInterface(InterfaceId_ERC721Metadata);
828   }
829 
830   function name() external view returns (string) {
831     return _name;
832   }
833 
834   
835   function symbol() external view returns (string) {
836     return _symbol;
837   }
838 
839   
840   function tokenURI(uint256 tokenId) external view returns (string) {
841     require(_exists(tokenId));
842     return _tokenURIs[tokenId];
843   }
844 
845   
846   function _setTokenURI(uint256 tokenId, string uri) internal {
847     require(_exists(tokenId));
848     _tokenURIs[tokenId] = uri;
849   }
850 
851   
852   function _burn(address owner, uint256 tokenId) internal {
853     super._burn(owner, tokenId);
854 
855     // Clear metadata (if any)
856     if (bytes(_tokenURIs[tokenId]).length != 0) {
857       delete _tokenURIs[tokenId];
858     }
859   }
860 }
861 
862 
863 contract ERC721Full_custom is ERC721_custom, ERC721Enumerable_custom, ERC721Metadata_custom {
864   constructor(string name, string symbol) ERC721Metadata_custom(name, symbol)
865     public
866   {
867   }
868 }
869 
870 
871 interface PlanetCryptoCoin_I {
872     function balanceOf(address owner) external returns(uint256);
873     function transfer(address to, uint256 value) external returns (bool);
874     function transferFrom(address from, address to, uint256 value) external returns(bool);
875 }
876 
877 interface PlanetCryptoUtils_I {
878     function validateLand(address _sender, int256[] plots_lat, int256[] plots_lng) external returns(bool);
879     function validatePurchase(address _sender, uint256 _value, int256[] plots_lat, int256[] plots_lng) external returns(bool);
880     function validateTokenPurchase(address _sender, int256[] plots_lat, int256[] plots_lng) external returns(bool);
881     function validateResale(address _sender, uint256 _value, uint256 _token_id) external returns(bool);
882 
883     //UTILS
884     function strConcat(string _a, string _b, string _c, string _d, string _e, string _f) external view returns (string);
885     function strConcat(string _a, string _b, string _c, string _d, string _e) external view returns (string);
886     function strConcat(string _a, string _b, string _c, string _d) external view returns (string);
887     function strConcat(string _a, string _b, string _c) external view returns (string);
888     function strConcat(string _a, string _b) external view returns (string);
889     function int2str(int i) external view returns (string);
890     function uint2str(uint i) external view returns (string);
891     function substring(string str, uint startIndex, uint endIndex) external view returns (string);
892     function utfStringLength(string str) external view returns (uint length);
893     function ceil1(int256 a, int256 m) external view returns (int256 );
894     function parseInt(string _a, uint _b) external view returns (uint);
895 }
896 
897 library Percent {
898 
899   struct percent {
900     uint num;
901     uint den;
902   }
903   function mul(percent storage p, uint a) internal view returns (uint) {
904     if (a == 0) {
905       return 0;
906     }
907     return a*p.num/p.den;
908   }
909 
910   function div(percent storage p, uint a) internal view returns (uint) {
911     return a/p.num*p.den;
912   }
913 
914   function sub(percent storage p, uint a) internal view returns (uint) {
915     uint b = mul(p, a);
916     if (b >= a) return 0;
917     return a - b;
918   }
919 
920   function add(percent storage p, uint a) internal view returns (uint) {
921     return a + mul(p, a);
922   }
923 }
924 
925 
926 
927 contract PlanetCryptoToken is ERC721Full_custom{
928     
929     using Percent for Percent.percent;
930     
931     
932     // EVENTS
933         
934     event referralPaid(address indexed search_to,
935                     address to, uint256 amnt, uint256 timestamp);
936     
937     event issueCoinTokens(address indexed searched_to, 
938                     address to, uint256 amnt, uint256 timestamp);
939     
940     event landPurchased(uint256 indexed search_token_id, address indexed search_buyer, 
941             uint256 token_id, address buyer, bytes32 name, int256 center_lat, int256 center_lng, uint256 size, uint256 bought_at, uint256 empire_score, uint256 timestamp);
942     
943     event taxDistributed(uint256 amnt, uint256 total_players, uint256 timestamp);
944     
945     event cardBought(
946                     uint256 indexed search_token_id, address indexed search_from, address indexed search_to,
947                     uint256 token_id, address from, address to, 
948                     bytes32 name,
949                     uint256 orig_value, 
950                     uint256 new_value,
951                     uint256 empireScore, uint256 newEmpireScore, uint256 now);
952 
953     // CONTRACT MANAGERS
954     address owner;
955     address devBankAddress; // where marketing funds are sent
956     address tokenBankAddress; 
957 
958     // MODIFIERS
959     modifier onlyOwner() {
960         require(msg.sender == owner);
961         _;
962     }
963     
964     modifier validateLand(int256[] plots_lat, int256[] plots_lng) {
965         
966         require(planetCryptoUtils_interface.validateLand(msg.sender, plots_lat, plots_lng) == true, "Some of this land already owned!");
967 
968         
969         _;
970     }
971     
972     modifier validatePurchase(int256[] plots_lat, int256[] plots_lng) {
973 
974         require(planetCryptoUtils_interface.validatePurchase(msg.sender, msg.value, plots_lat, plots_lng) == true, "Not enough ETH!");
975         _;
976     }
977     
978     
979     modifier validateTokenPurchase(int256[] plots_lat, int256[] plots_lng) {
980 
981         require(planetCryptoUtils_interface.validateTokenPurchase(msg.sender, plots_lat, plots_lng) == true, "Not enough COINS to buy these plots!");
982         
983 
984         
985 
986         require(planetCryptoCoin_interface.transferFrom(msg.sender, tokenBankAddress, plots_lat.length) == true, "Token transfer failed");
987         
988         
989         _;
990     }
991     
992     
993     modifier validateResale(uint256 _token_id) {
994         require(planetCryptoUtils_interface.validateResale(msg.sender, msg.value, _token_id) == true, "Not enough ETH to buy this card!");
995         _;
996     }
997     
998     
999     modifier updateUsersLastAccess() {
1000         
1001         uint256 allPlyersIdx = playerAddressToPlayerObjectID[msg.sender];
1002         if(allPlyersIdx == 0){
1003 
1004             all_playerObjects.push(player(msg.sender,now,0,0));
1005             playerAddressToPlayerObjectID[msg.sender] = all_playerObjects.length-1;
1006         } else {
1007             all_playerObjects[allPlyersIdx].lastAccess = now;
1008         }
1009         
1010         _;
1011     }
1012     
1013     // STRUCTS
1014     struct plotDetail {
1015         bytes32 name;
1016         uint256 orig_value;
1017         uint256 current_value;
1018         uint256 empire_score;
1019         int256[] plots_lat;
1020         int256[] plots_lng;
1021     }
1022     
1023     struct plotBasic {
1024         int256 lat;
1025         int256 lng;
1026     }
1027     
1028     struct player {
1029         address playerAddress;
1030         uint256 lastAccess;
1031         uint256 totalEmpireScore;
1032         uint256 totalLand;
1033         
1034         
1035     }
1036     
1037 
1038     // INTERFACES
1039     address planetCryptoCoinAddress = 0xa1c8031ef18272d8bfed22e1b61319d6d9d2881b;
1040     PlanetCryptoCoin_I internal planetCryptoCoin_interface;
1041     
1042 
1043     address planetCryptoUtilsAddress = 0x19BfDF25542F1380790B6880ad85D6D5B02fee32;
1044     PlanetCryptoUtils_I internal planetCryptoUtils_interface;
1045     
1046     
1047     // settings
1048     Percent.percent private m_newPlot_devPercent = Percent.percent(75,100); //75/100*100% = 75%
1049     Percent.percent private m_newPlot_taxPercent = Percent.percent(25,100); //25%
1050     
1051     Percent.percent private m_resalePlot_devPercent = Percent.percent(10,100); // 10%
1052     Percent.percent private m_resalePlot_taxPercent = Percent.percent(10,100); // 10%
1053     Percent.percent private m_resalePlot_ownerPercent = Percent.percent(80,100); // 80%
1054     
1055     Percent.percent private m_refPercent = Percent.percent(5,100); // 5% referral 
1056     
1057     Percent.percent private m_empireScoreMultiplier = Percent.percent(150,100); // 150%
1058     Percent.percent private m_resaleMultipler = Percent.percent(200,100); // 200%;
1059 
1060     
1061     
1062     
1063     uint256 public devHoldings = 0; // holds dev funds in cases where the instant transfer fails
1064 
1065 
1066     mapping(address => uint256) internal playersFundsOwed; // can sit within all_playerObjects
1067 
1068 
1069 
1070 
1071     // add in limit of land plots before tokens stop being distributed
1072     uint256 public tokens_rewards_available;
1073     uint256 public tokens_rewards_allocated;
1074     
1075     // add in spend amount required to earn tokens
1076     uint256 public min_plots_purchase_for_token_reward = 10;
1077     uint256 public plots_token_reward_divisor = 10;
1078     
1079     
1080     // GAME SETTINGS
1081     uint256 public current_plot_price = 20000000000000000;
1082     uint256 public price_update_amount = 2000000000000;
1083 
1084     uint256 public current_plot_empire_score = 100;
1085 
1086     
1087     
1088     uint256 public tax_fund = 0;
1089     uint256 public tax_distributed = 0;
1090 
1091 
1092     // GAME STATS
1093     uint256 public total_land_sold = 0;
1094     uint256 public total_trades = 0;
1095 
1096     
1097     uint256 public total_empire_score; 
1098     player[] public all_playerObjects;
1099     mapping(address => uint256) internal playerAddressToPlayerObjectID;
1100     
1101     
1102     
1103     
1104     plotDetail[] plotDetails;
1105     mapping(uint256 => uint256) internal tokenIDplotdetailsIndexId; // e.g. tokenIDplotdetailsIndexId shows us the index of the detail obj for each token
1106 
1107 
1108 
1109     
1110     mapping(int256 => mapping(int256 => uint256)) internal latlngTokenID_grids;
1111     mapping(uint256 => plotBasic[]) internal tokenIDlatlngLookup;
1112     
1113     
1114     
1115     mapping(uint8 => mapping(int256 => mapping(int256 => uint256))) internal latlngTokenID_zoomAll;
1116 
1117     mapping(uint8 => mapping(uint256 => plotBasic[])) internal tokenIDlatlngLookup_zoomAll;
1118 
1119 
1120    
1121     
1122     constructor() ERC721Full_custom("PlanetCrypto", "PTC") public {
1123         owner = msg.sender;
1124         tokenBankAddress = owner;
1125         devBankAddress = owner;
1126         planetCryptoCoin_interface = PlanetCryptoCoin_I(planetCryptoCoinAddress);
1127         planetCryptoUtils_interface = PlanetCryptoUtils_I(planetCryptoUtilsAddress);
1128         
1129         // empty playerAddressToPlayerObjectID player to allow easy checks...
1130 
1131         all_playerObjects.push(player(address(0x0),0,0,0));
1132         playerAddressToPlayerObjectID[address(0x0)] = 0;
1133     }
1134 
1135     
1136 
1137     
1138 
1139     function getToken(uint256 _tokenId, bool isBasic) public view returns(
1140         address token_owner,
1141         bytes32  name,
1142         uint256 orig_value,
1143         uint256 current_value,
1144         uint256 empire_score,
1145         int256[] plots_lat,
1146         int256[] plots_lng
1147         ) {
1148         token_owner = ownerOf(_tokenId);
1149         plotDetail memory _plotDetail = plotDetails[tokenIDplotdetailsIndexId[_tokenId]];
1150         name = _plotDetail.name;
1151         empire_score = _plotDetail.empire_score;
1152         orig_value = _plotDetail.orig_value;
1153         current_value = _plotDetail.current_value;
1154         if(!isBasic){
1155             plots_lat = _plotDetail.plots_lat;
1156             plots_lng = _plotDetail.plots_lng;
1157         } else {
1158         }
1159     }
1160     
1161     
1162 
1163     function taxEarningsAvailable() public view returns(uint256) {
1164         return playersFundsOwed[msg.sender];
1165     }
1166 
1167     function withdrawTaxEarning() public {
1168         uint256 taxEarnings = playersFundsOwed[msg.sender];
1169         playersFundsOwed[msg.sender] = 0;
1170         tax_fund = tax_fund.sub(taxEarnings);
1171         
1172         if(!msg.sender.send(taxEarnings)) {
1173             playersFundsOwed[msg.sender] = playersFundsOwed[msg.sender] + taxEarnings;
1174             tax_fund = tax_fund.add(taxEarnings);
1175         }
1176     }
1177 
1178     function buyLandWithTokens(bytes32 _name, int256[] _plots_lat, int256[] _plots_lng)
1179      validateTokenPurchase(_plots_lat, _plots_lng) validateLand(_plots_lat, _plots_lng) updateUsersLastAccess() public {
1180         require(_name.length > 4);
1181         
1182 
1183         processPurchase(_name, _plots_lat, _plots_lng); 
1184     }
1185     
1186 
1187     
1188     function buyLand(bytes32 _name, 
1189             int256[] _plots_lat, int256[] _plots_lng,
1190             address _referrer
1191             )
1192                 validatePurchase(_plots_lat, _plots_lng) 
1193                 validateLand(_plots_lat, _plots_lng) 
1194                 updateUsersLastAccess()
1195                 public payable {
1196        require(_name.length > 4);
1197        
1198         // split payment
1199         uint256 _runningTotal = msg.value;
1200         uint256 _referrerAmnt = 0;
1201         if(_referrer != msg.sender && _referrer != address(0)) {
1202             _referrerAmnt = m_refPercent.mul(msg.value);
1203             if(_referrer.send(_referrerAmnt)) {
1204                 emit referralPaid(_referrer, _referrer, _referrerAmnt, now);
1205                 _runningTotal = _runningTotal.sub(_referrerAmnt);
1206             }
1207         }
1208         
1209         tax_fund = tax_fund.add(m_newPlot_taxPercent.mul(_runningTotal));
1210         
1211         
1212         
1213         if(!devBankAddress.send(m_newPlot_devPercent.mul(_runningTotal))){
1214             devHoldings = devHoldings.add(m_newPlot_devPercent.mul(_runningTotal));
1215         }
1216         
1217         
1218         
1219 
1220         processPurchase(_name, _plots_lat, _plots_lng);
1221         
1222         calcPlayerDivs(m_newPlot_taxPercent.mul(_runningTotal));
1223         
1224         if(_plots_lat.length >= min_plots_purchase_for_token_reward
1225             && tokens_rewards_available > 0) {
1226                 
1227             uint256 _token_rewards = _plots_lat.length / plots_token_reward_divisor;
1228             if(_token_rewards > tokens_rewards_available)
1229                 _token_rewards = tokens_rewards_available;
1230                 
1231                 
1232             planetCryptoCoin_interface.transfer(msg.sender, _token_rewards);
1233                 
1234             emit issueCoinTokens(msg.sender, msg.sender, _token_rewards, now);
1235             tokens_rewards_allocated = tokens_rewards_allocated + _token_rewards;
1236             tokens_rewards_available = tokens_rewards_available - _token_rewards;
1237         }
1238     
1239     }
1240     
1241     
1242 
1243     function buyCard(uint256 _token_id, address _referrer) validateResale(_token_id) updateUsersLastAccess() public payable {
1244         
1245         
1246         // split payment
1247         uint256 _runningTotal = msg.value;
1248         uint256 _referrerAmnt = 0;
1249         if(_referrer != msg.sender && _referrer != address(0)) {
1250             _referrerAmnt = m_refPercent.mul(msg.value);
1251             if(_referrer.send(_referrerAmnt)) {
1252                 emit referralPaid(_referrer, _referrer, _referrerAmnt, now);
1253                 _runningTotal = _runningTotal.sub(_referrerAmnt);
1254             }
1255         }
1256         
1257         
1258         tax_fund = tax_fund.add(m_resalePlot_taxPercent.mul(_runningTotal));
1259         
1260         
1261         
1262         if(!devBankAddress.send(m_resalePlot_devPercent.mul(_runningTotal))){
1263             devHoldings = devHoldings.add(m_resalePlot_devPercent.mul(_runningTotal));
1264         }
1265         
1266         
1267 
1268         address from = ownerOf(_token_id);
1269         
1270         if(!from.send(m_resalePlot_ownerPercent.mul(_runningTotal))) {
1271             playersFundsOwed[from] = playersFundsOwed[from].add(m_resalePlot_ownerPercent.mul(_runningTotal));
1272         }
1273         
1274         
1275 
1276         our_transferFrom(from, msg.sender, _token_id);
1277         
1278 
1279         plotDetail memory _plotDetail = plotDetails[tokenIDplotdetailsIndexId[_token_id]];
1280         uint256 _empireScore = _plotDetail.empire_score;
1281         uint256 _newEmpireScore = m_empireScoreMultiplier.mul(_empireScore);
1282         uint256 _origValue = _plotDetail.current_value;
1283         
1284         uint256 _playerObject_idx = playerAddressToPlayerObjectID[msg.sender];
1285         
1286 
1287         all_playerObjects[_playerObject_idx].totalEmpireScore
1288             = all_playerObjects[_playerObject_idx].totalEmpireScore + (_newEmpireScore - _empireScore);
1289         
1290         
1291         plotDetails[tokenIDplotdetailsIndexId[_token_id]].empire_score = _newEmpireScore;
1292 
1293         total_empire_score = total_empire_score + (_newEmpireScore - _empireScore);
1294         
1295         plotDetails[tokenIDplotdetailsIndexId[_token_id]].current_value = 
1296             m_resaleMultipler.mul(plotDetails[tokenIDplotdetailsIndexId[_token_id]].current_value);
1297         
1298         total_trades = total_trades + 1;
1299         
1300         
1301         calcPlayerDivs(m_resalePlot_taxPercent.mul(_runningTotal));
1302         
1303         
1304         // emit event
1305         emit cardBought(_token_id, from, msg.sender,
1306                     _token_id, from, msg.sender, 
1307                     _plotDetail.name,
1308                     _origValue, 
1309                     msg.value,
1310                     _empireScore, _newEmpireScore, now);
1311     }
1312     
1313     function processPurchase(bytes32 _name, 
1314             int256[] _plots_lat, int256[] _plots_lng) internal {
1315     
1316         uint256 _token_id = totalSupply().add(1);
1317         _mint(msg.sender, _token_id);
1318         
1319 
1320         
1321 
1322         uint256 _empireScore =
1323                     current_plot_empire_score * _plots_lng.length;
1324             
1325             
1326         plotDetails.push(plotDetail(
1327             _name,
1328             current_plot_price * _plots_lat.length,
1329             current_plot_price * _plots_lat.length,
1330             _empireScore,
1331             _plots_lat, _plots_lng
1332         ));
1333         
1334         tokenIDplotdetailsIndexId[_token_id] = plotDetails.length-1;
1335         
1336         
1337         setupPlotOwnership(_token_id, _plots_lat, _plots_lng);
1338         
1339         
1340         
1341         uint256 _playerObject_idx = playerAddressToPlayerObjectID[msg.sender];
1342         all_playerObjects[_playerObject_idx].totalEmpireScore
1343             = all_playerObjects[_playerObject_idx].totalEmpireScore + _empireScore;
1344             
1345         total_empire_score = total_empire_score + _empireScore;
1346             
1347         all_playerObjects[_playerObject_idx].totalLand
1348             = all_playerObjects[_playerObject_idx].totalLand + _plots_lat.length;
1349             
1350         
1351         emit landPurchased(
1352                 _token_id, msg.sender,
1353                 _token_id, msg.sender, _name, _plots_lat[0], _plots_lng[0], _plots_lat.length, current_plot_price, _empireScore, now);
1354 
1355 
1356         current_plot_price = current_plot_price + (price_update_amount * _plots_lat.length);
1357         total_land_sold = total_land_sold + _plots_lat.length;
1358         
1359     }
1360 
1361 
1362 
1363 
1364     uint256 internal tax_carried_forward = 0;
1365     
1366     function calcPlayerDivs(uint256 _value) internal {
1367         // total up amount split so we can emit it
1368         if(totalSupply() > 1) {
1369             uint256 _totalDivs = 0;
1370             uint256 _totalPlayers = 0;
1371             
1372             uint256 _taxToDivide = _value + tax_carried_forward;
1373             
1374             // ignore player 0
1375             for(uint256 c=1; c< all_playerObjects.length; c++) {
1376                 
1377                 // allow for 0.0001 % =  * 10000
1378                 
1379                 uint256 _playersPercent 
1380                     = (all_playerObjects[c].totalEmpireScore*10000000 / total_empire_score * 10000000) / 10000000;
1381                 uint256 _playerShare = _taxToDivide / 10000000 * _playersPercent;
1382                 
1383                 //uint256 _playerShare =  _taxToDivide * (all_playerObjects[c].totalEmpireScore / total_empire_score);
1384                 //_playerShare = _playerShare / 10000;
1385                 
1386                 if(_playerShare > 0) {
1387                     
1388                     incPlayerOwed(all_playerObjects[c].playerAddress,_playerShare);
1389                     _totalDivs = _totalDivs + _playerShare;
1390                     _totalPlayers = _totalPlayers + 1;
1391                 
1392                 }
1393             }
1394 
1395             tax_carried_forward = 0;
1396             emit taxDistributed(_totalDivs, _totalPlayers, now);
1397 
1398         } else {
1399             // first land purchase - no divs this time, carried forward
1400             tax_carried_forward = tax_carried_forward + _value;
1401         }
1402     }
1403     
1404     
1405     function incPlayerOwed(address _playerAddr, uint256 _amnt) internal {
1406         playersFundsOwed[_playerAddr] = playersFundsOwed[_playerAddr].add(_amnt);
1407         tax_distributed = tax_distributed.add(_amnt);
1408     }
1409     
1410     
1411     function setupPlotOwnership(uint256 _token_id, int256[] _plots_lat, int256[] _plots_lng) internal {
1412 
1413        for(uint256 c=0;c< _plots_lat.length;c++) {
1414          
1415             //mapping(int256 => mapping(int256 => uint256)) internal latlngTokenID_grids;
1416             latlngTokenID_grids[_plots_lat[c]]
1417                 [_plots_lng[c]] = _token_id;
1418                 
1419             //mapping(uint256 => plotBasic[]) internal tokenIDlatlngLookup;
1420             tokenIDlatlngLookup[_token_id].push(plotBasic(
1421                 _plots_lat[c], _plots_lng[c]
1422             ));
1423             
1424         }
1425        
1426         
1427         int256 _latInt = _plots_lat[0];
1428         int256 _lngInt = _plots_lng[0];
1429 
1430 
1431 
1432         setupZoomLvl(1,_latInt, _lngInt, _token_id); // correct rounding / 10 on way out
1433         setupZoomLvl(2,_latInt, _lngInt, _token_id); // correct rounding / 100
1434         setupZoomLvl(3,_latInt, _lngInt, _token_id); // correct rounding / 1000
1435         setupZoomLvl(4,_latInt, _lngInt, _token_id); // correct rounding / 10000
1436 
1437       
1438     }
1439 
1440     function setupZoomLvl(uint8 zoom, int256 lat, int256 lng, uint256 _token_id) internal  {
1441         
1442         lat = roundLatLng(zoom, lat);
1443         lng  = roundLatLng(zoom, lng); 
1444         
1445         
1446         uint256 _remover = 5;
1447         if(zoom == 1)
1448             _remover = 5;
1449         if(zoom == 2)
1450             _remover = 4;
1451         if(zoom == 3)
1452             _remover = 3;
1453         if(zoom == 4)
1454             _remover = 2;
1455         
1456         string memory _latStr;  // = int2str(lat);
1457         string memory _lngStr; // = int2str(lng);
1458 
1459         
1460         
1461         bool _tIsNegative = false;
1462         
1463         if(lat < 0) {
1464             _tIsNegative = true;   
1465             lat = lat * -1;
1466         }
1467         _latStr = planetCryptoUtils_interface.int2str(lat);
1468         _latStr = planetCryptoUtils_interface.substring(_latStr,0,planetCryptoUtils_interface.utfStringLength(_latStr)-_remover); //_lat_len-_remover);
1469         lat = int256(planetCryptoUtils_interface.parseInt(_latStr,0));
1470         if(_tIsNegative)
1471             lat = lat * -1;
1472         
1473         
1474         //emit debugInt("ZOOM LNG1", lng); // 1.1579208923731619542...
1475         
1476         if(lng < 0) {
1477             _tIsNegative = true;
1478             lng = lng * -1;
1479         } else {
1480             _tIsNegative = false;
1481         }
1482             
1483         //emit debugInt("ZOOM LNG2", lng); // 100000
1484             
1485         _lngStr = planetCryptoUtils_interface.int2str(lng);
1486         
1487         _lngStr = planetCryptoUtils_interface.substring(_lngStr,0,planetCryptoUtils_interface.utfStringLength(_lngStr)-_remover);
1488         
1489         lng = int256(planetCryptoUtils_interface.parseInt(_lngStr,0));
1490         
1491         if(_tIsNegative)
1492             lng = lng * -1;
1493     
1494         
1495         latlngTokenID_zoomAll[zoom][lat][lng] = _token_id;
1496         tokenIDlatlngLookup_zoomAll[zoom][_token_id].push(plotBasic(lat,lng));
1497         
1498       
1499    
1500         
1501         
1502     }
1503 
1504 
1505 
1506 
1507     
1508 
1509 
1510     function getAllPlayerObjectLen() public view returns(uint256){
1511         return all_playerObjects.length;
1512     }
1513     
1514 
1515     function queryMap(uint8 zoom, int256[] lat_rows, int256[] lng_columns) public view returns(string _outStr) {
1516         
1517         
1518         for(uint256 y=0; y< lat_rows.length; y++) {
1519 
1520             for(uint256 x=0; x< lng_columns.length; x++) {
1521                 
1522                 
1523                 
1524                 if(zoom == 0){
1525                     if(latlngTokenID_grids[lat_rows[y]][lng_columns[x]] > 0){
1526                         
1527                         
1528                       _outStr = planetCryptoUtils_interface.strConcat(
1529                             _outStr, '[', planetCryptoUtils_interface.int2str(lat_rows[y]) , ':', planetCryptoUtils_interface.int2str(lng_columns[x]) );
1530                       _outStr = planetCryptoUtils_interface.strConcat(_outStr, ':', 
1531                                     planetCryptoUtils_interface.uint2str(latlngTokenID_grids[lat_rows[y]][lng_columns[x]]), ']');
1532                     }
1533                     
1534                 } else {
1535                     //_out[c] = latlngTokenID_zoomAll[zoom][lat_rows[y]][lng_columns[x]];
1536                     if(latlngTokenID_zoomAll[zoom][lat_rows[y]][lng_columns[x]] > 0){
1537                       _outStr = planetCryptoUtils_interface.strConcat(_outStr, '[', planetCryptoUtils_interface.int2str(lat_rows[y]) , ':', planetCryptoUtils_interface.int2str(lng_columns[x]) );
1538                       _outStr = planetCryptoUtils_interface.strConcat(_outStr, ':', 
1539                                     planetCryptoUtils_interface.uint2str(latlngTokenID_zoomAll[zoom][lat_rows[y]][lng_columns[x]]), ']');
1540                     }
1541                     
1542                 }
1543                 //c = c+1;
1544                 
1545             }
1546         }
1547         
1548         //return _out;
1549     }
1550 
1551     function queryPlotExists(uint8 zoom, int256[] lat_rows, int256[] lng_columns) public view returns(bool) {
1552         
1553         
1554         for(uint256 y=0; y< lat_rows.length; y++) {
1555 
1556             for(uint256 x=0; x< lng_columns.length; x++) {
1557                 
1558                 if(zoom == 0){
1559                     if(latlngTokenID_grids[lat_rows[y]][lng_columns[x]] > 0){
1560                         return true;
1561                     } 
1562                 } else {
1563                     if(latlngTokenID_zoomAll[zoom][lat_rows[y]][lng_columns[x]] > 0){
1564 
1565                         return true;
1566                         
1567                     }                     
1568                 }
1569            
1570                 
1571             }
1572         }
1573         
1574         return false;
1575     }
1576 
1577     
1578     function roundLatLng(uint8 _zoomLvl, int256 _in) internal view returns(int256) {
1579         int256 multipler = 100000;
1580         if(_zoomLvl == 1)
1581             multipler = 100000;
1582         if(_zoomLvl == 2)
1583             multipler = 10000;
1584         if(_zoomLvl == 3)
1585             multipler = 1000;
1586         if(_zoomLvl == 4)
1587             multipler = 100;
1588         if(_zoomLvl == 5)
1589             multipler = 10;
1590         
1591         if(_in > 0){
1592             // round it
1593             _in = planetCryptoUtils_interface.ceil1(_in, multipler);
1594         } else {
1595             _in = _in * -1;
1596             _in = planetCryptoUtils_interface.ceil1(_in, multipler);
1597             _in = _in * -1;
1598         }
1599         
1600         return (_in);
1601         
1602     }
1603     
1604 
1605    
1606 
1607 
1608 
1609 
1610     // ERC721 overrides
1611     
1612     function safeTransferFrom(address from, address to, uint256 tokenId) public {
1613         safeTransferFrom(from, to, tokenId, "");
1614     }
1615     function safeTransferFrom(address from, address to, uint256 tokenId, bytes _data) public {
1616         transferFrom(from, to, tokenId);
1617         // solium-disable-next-line arg-overflow
1618         require(_checkOnERC721Received(from, to, tokenId, _data));
1619     }
1620     
1621     function our_transferFrom(address from, address to, uint256 tokenId) internal {
1622         // permissions already checked on buycard
1623         process_swap(from,to,tokenId);
1624         
1625         internal_transferFrom(from, to, tokenId);
1626     }
1627 
1628 
1629     function transferFrom(address from, address to, uint256 tokenId) public {
1630         // check permission on the from address first
1631         require(_isApprovedOrOwner(msg.sender, tokenId));
1632         require(to != address(0));
1633         
1634         process_swap(from,to,tokenId);
1635         
1636         super.transferFrom(from, to, tokenId);
1637 
1638     }
1639     
1640     function process_swap(address from, address to, uint256 tokenId) internal {
1641 
1642         
1643         // remove the empire score & total land owned...
1644         uint256 _empireScore;
1645         uint256 _size;
1646         
1647         plotDetail memory _plotDetail = plotDetails[tokenIDplotdetailsIndexId[tokenId]];
1648         _empireScore = _plotDetail.empire_score;
1649         _size = _plotDetail.plots_lat.length;
1650         
1651         uint256 _playerObject_idx = playerAddressToPlayerObjectID[from];
1652         
1653         all_playerObjects[_playerObject_idx].totalEmpireScore
1654             = all_playerObjects[_playerObject_idx].totalEmpireScore - _empireScore;
1655             
1656         all_playerObjects[_playerObject_idx].totalLand
1657             = all_playerObjects[_playerObject_idx].totalLand - _size;
1658             
1659         // and increment on the other side...
1660         
1661         _playerObject_idx = playerAddressToPlayerObjectID[to];
1662         
1663         all_playerObjects[_playerObject_idx].totalEmpireScore
1664             = all_playerObjects[_playerObject_idx].totalEmpireScore + _empireScore;
1665             
1666         all_playerObjects[_playerObject_idx].totalLand
1667             = all_playerObjects[_playerObject_idx].totalLand + _size;
1668     }
1669 
1670 
1671     function burnToken(uint256 _tokenId) external onlyOwner {
1672         address _token_owner = ownerOf(_tokenId);
1673         _burn(_token_owner, _tokenId);
1674         
1675         
1676         // remove the empire score & total land owned...
1677         uint256 _empireScore;
1678         uint256 _size;
1679         
1680         plotDetail memory _plotDetail = plotDetails[tokenIDplotdetailsIndexId[_tokenId]];
1681         _empireScore = _plotDetail.empire_score;
1682         _size = _plotDetail.plots_lat.length;
1683         
1684         uint256 _playerObject_idx = playerAddressToPlayerObjectID[_token_owner];
1685         
1686         all_playerObjects[_playerObject_idx].totalEmpireScore
1687             = all_playerObjects[_playerObject_idx].totalEmpireScore - _empireScore;
1688             
1689         all_playerObjects[_playerObject_idx].totalLand
1690             = all_playerObjects[_playerObject_idx].totalLand - _size;
1691             
1692        
1693         
1694         for(uint256 c=0;c < tokenIDlatlngLookup[_tokenId].length; c++) {
1695             latlngTokenID_grids[
1696                     tokenIDlatlngLookup[_tokenId][c].lat
1697                 ][tokenIDlatlngLookup[_tokenId][c].lng] = 0;
1698         }
1699         delete tokenIDlatlngLookup[_tokenId];
1700         
1701         
1702         
1703         //Same for tokenIDplotdetailsIndexId        
1704         // clear from plotDetails array... (Holds the detail of the card)
1705         uint256 oldIndex = tokenIDplotdetailsIndexId[_tokenId];
1706         if(oldIndex != plotDetails.length-1) {
1707             plotDetails[oldIndex] = plotDetails[plotDetails.length-1];
1708         }
1709         plotDetails.length--;
1710         
1711 
1712         delete tokenIDplotdetailsIndexId[_tokenId];
1713 
1714 
1715 
1716         for(uint8 zoom=1; zoom < 5; zoom++) {
1717             plotBasic[] storage _plotBasicList = tokenIDlatlngLookup_zoomAll[zoom][_tokenId];
1718             for(uint256 _plotsC=0; c< _plotBasicList.length; _plotsC++) {
1719                 delete latlngTokenID_zoomAll[zoom][
1720                     _plotBasicList[_plotsC].lat
1721                     ][
1722                         _plotBasicList[_plotsC].lng
1723                         ];
1724                         
1725                 delete _plotBasicList[_plotsC];
1726             }
1727             
1728         }
1729     
1730     
1731 
1732 
1733 
1734     }    
1735 
1736 
1737 
1738     // PRIVATE METHODS
1739     function p_update_action(uint256 _type, address _address) public onlyOwner {
1740         if(_type == 0){
1741             owner = _address;    
1742         }
1743         if(_type == 1){
1744             tokenBankAddress = _address;    
1745         }
1746         if(_type == 2) {
1747             devBankAddress = _address;
1748         }
1749     }
1750 
1751 
1752     function p_update_priceUpdateAmount(uint256 _price_update_amount) public onlyOwner {
1753         price_update_amount = _price_update_amount;
1754     }
1755     function p_update_currentPlotEmpireScore(uint256 _current_plot_empire_score) public onlyOwner {
1756         current_plot_empire_score = _current_plot_empire_score;
1757     }
1758     function p_update_planetCryptoCoinAddress(address _planetCryptoCoinAddress) public onlyOwner {
1759         planetCryptoCoinAddress = _planetCryptoCoinAddress;
1760         if(address(planetCryptoCoinAddress) != address(0)){ 
1761             planetCryptoCoin_interface = PlanetCryptoCoin_I(planetCryptoCoinAddress);
1762         }
1763     }
1764     function p_update_planetCryptoUtilsAddress(address _planetCryptoUtilsAddress) public onlyOwner {
1765         planetCryptoUtilsAddress = _planetCryptoUtilsAddress;
1766         if(address(planetCryptoUtilsAddress) != address(0)){ 
1767             planetCryptoUtils_interface = PlanetCryptoUtils_I(planetCryptoUtilsAddress);
1768         }
1769     }
1770     function p_update_mNewPlotDevPercent(uint256 _newPercent) onlyOwner public {
1771         m_newPlot_devPercent = Percent.percent(_newPercent,100);
1772     }
1773     function p_update_mNewPlotTaxPercent(uint256 _newPercent) onlyOwner public {
1774         m_newPlot_taxPercent = Percent.percent(_newPercent,100);
1775     }
1776     function p_update_mResalePlotDevPercent(uint256 _newPercent) onlyOwner public {
1777         m_resalePlot_devPercent = Percent.percent(_newPercent,100);
1778     }
1779     function p_update_mResalePlotTaxPercent(uint256 _newPercent) onlyOwner public {
1780         m_resalePlot_taxPercent = Percent.percent(_newPercent,100);
1781     }
1782     function p_update_mResalePlotOwnerPercent(uint256 _newPercent) onlyOwner public {
1783         m_resalePlot_ownerPercent = Percent.percent(_newPercent,100);
1784     }
1785     function p_update_mRefPercent(uint256 _newPercent) onlyOwner public {
1786         m_refPercent = Percent.percent(_newPercent,100);
1787     }
1788     function p_update_mEmpireScoreMultiplier(uint256 _newPercent) onlyOwner public {
1789         m_empireScoreMultiplier = Percent.percent(_newPercent, 100);
1790     }
1791     function p_update_mResaleMultipler(uint256 _newPercent) onlyOwner public {
1792         m_resaleMultipler = Percent.percent(_newPercent, 100);
1793     }
1794     function p_update_tokensRewardsAvailable(uint256 _tokens_rewards_available) onlyOwner public {
1795         tokens_rewards_available = _tokens_rewards_available;
1796     }
1797     function p_update_tokensRewardsAllocated(uint256 _tokens_rewards_allocated) onlyOwner public {
1798         tokens_rewards_allocated = _tokens_rewards_allocated;
1799     }
1800     function p_withdrawDevHoldings() public {
1801         require(msg.sender == devBankAddress);
1802         uint256 _t = devHoldings;
1803         devHoldings = 0;
1804         if(!devBankAddress.send(devHoldings)){
1805             devHoldings = _t;
1806         }
1807     }
1808 
1809 
1810     function stringToBytes32(string memory source) internal returns (bytes32 result) {
1811         bytes memory tempEmptyStringTest = bytes(source);
1812         if (tempEmptyStringTest.length == 0) {
1813             return 0x0;
1814         }
1815     
1816         assembly {
1817             result := mload(add(source, 32))
1818         }
1819     }
1820 
1821     function m() public {
1822         
1823     }
1824     
1825 }