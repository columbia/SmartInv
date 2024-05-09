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
21 /**
22  * @title ERC721 Non-Fungible Token Standard basic interface
23  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
24  */
25 contract IERC721 is IERC165 {
26 
27   event Transfer(
28     address indexed from,
29     address indexed to,
30     uint256 indexed tokenId
31   );
32   event Approval(
33     address indexed owner,
34     address indexed approved,
35     uint256 indexed tokenId
36   );
37   event ApprovalForAll(
38     address indexed owner,
39     address indexed operator,
40     bool approved
41   );
42 
43   function balanceOf(address owner) public view returns (uint256 balance);
44   function ownerOf(uint256 tokenId) public view returns (address owner);
45 
46   function approve(address to, uint256 tokenId) public;
47   function getApproved(uint256 tokenId)
48     public view returns (address operator);
49 
50   function setApprovalForAll(address operator, bool _approved) public;
51   function isApprovedForAll(address owner, address operator)
52     public view returns (bool);
53 
54   function transferFrom(address from, address to, uint256 tokenId) public;
55   function safeTransferFrom(address from, address to, uint256 tokenId)
56     public;
57 
58   function safeTransferFrom(
59     address from,
60     address to,
61     uint256 tokenId,
62     bytes data
63   )
64     public;
65 }
66 
67 /**
68  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
69  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
70  */
71 contract IERC721Enumerable is IERC721 {
72   function totalSupply() public view returns (uint256);
73   function tokenOfOwnerByIndex(
74     address owner,
75     uint256 index
76   )
77     public
78     view
79     returns (uint256 tokenId);
80 
81   function tokenByIndex(uint256 index) public view returns (uint256);
82 }
83 
84 /**
85  * @title ERC721 token receiver interface
86  * @dev Interface for any contract that wants to support safeTransfers
87  * from ERC721 asset contracts.
88  */
89 contract IERC721Receiver {
90   /**
91    * @notice Handle the receipt of an NFT
92    * @dev The ERC721 smart contract calls this function on the recipient
93    * after a `safeTransfer`. This function MUST return the function selector,
94    * otherwise the caller will revert the transaction. The selector to be
95    * returned can be obtained as `this.onERC721Received.selector`. This
96    * function MAY throw to revert and reject the transfer.
97    * Note: the ERC721 contract address is always the message sender.
98    * @param operator The address which called `safeTransferFrom` function
99    * @param from The address which previously owned the token
100    * @param tokenId The NFT identifier which is being transferred
101    * @param data Additional data with no specified format
102    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
103    */
104   function onERC721Received(
105     address operator,
106     address from,
107     uint256 tokenId,
108     bytes data
109   )
110     public
111     returns(bytes4);
112 }
113 
114 /**
115  * @title SafeMath
116  * @dev Math operations with safety checks that throw on error
117  */
118 library SafeMath {
119 
120   /**
121   * @dev Multiplies two numbers, throws on overflow.
122   */
123   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
124     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
125     // benefit is lost if 'b' is also tested.
126     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
127     if (a == 0) {
128       return 0;
129     }
130 
131     c = a * b;
132     assert(c / a == b);
133     return c;
134   }
135 
136   /**
137   * @dev Integer division of two numbers, truncating the quotient.
138   */
139   function div(uint256 a, uint256 b) internal pure returns (uint256) {
140     // assert(b > 0); // Solidity automatically throws when dividing by 0
141     // uint256 c = a / b;
142     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
143     return a / b;
144   }
145 
146   /**
147   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
148   */
149   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
150     assert(b <= a);
151     return a - b;
152   }
153 
154   /**
155   * @dev Adds two numbers, throws on overflow.
156   */
157   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
158     c = a + b;
159     assert(c >= a);
160     return c;
161   }
162 }
163 
164 /**
165  * Utility library of inline functions on addresses
166  */
167 library Address {
168 
169   /**
170    * Returns whether the target address is a contract
171    * @dev This function will return false if invoked during the constructor of a contract,
172    *  as the code is not actually created until after the constructor finishes.
173    * @param addr address to check
174    * @return whether the target address is a contract
175    */
176   function isContract(address addr) internal view returns (bool) {
177     uint256 size;
178     // XXX Currently there is no better way to check if there is a contract in an address
179     // than to check the size of the code at that address.
180     // See https://ethereum.stackexchange.com/a/14016/36603
181     // for more details about how this works.
182     // TODO Check this again before the Serenity release, because all addresses will be
183     // contracts then.
184     // solium-disable-next-line security/no-inline-assembly
185     assembly { size := extcodesize(addr) }
186     return size > 0;
187   }
188 
189 }
190 
191 /**
192  * @title ERC165
193  * @author Matt Condon (@shrugs)
194  * @dev Implements ERC165 using a lookup table.
195  */
196 contract ERC165 is IERC165 {
197 
198   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
199   /**
200    * 0x01ffc9a7 ===
201    *   bytes4(keccak256('supportsInterface(bytes4)'))
202    */
203 
204   /**
205    * @dev a mapping of interface id to whether or not it's supported
206    */
207   mapping(bytes4 => bool) private _supportedInterfaces;
208 
209   /**
210    * @dev A contract implementing SupportsInterfaceWithLookup
211    * implement ERC165 itself
212    */
213   constructor()
214     internal
215   {
216     _registerInterface(_InterfaceId_ERC165);
217   }
218 
219   /**
220    * @dev implement supportsInterface(bytes4) using a lookup table
221    */
222   function supportsInterface(bytes4 interfaceId)
223     external
224     view
225     returns (bool)
226   {
227     return _supportedInterfaces[interfaceId];
228   }
229 
230   /**
231    * @dev internal method for registering an interface
232    */
233   function _registerInterface(bytes4 interfaceId)
234     internal
235   {
236     require(interfaceId != 0xffffffff);
237     _supportedInterfaces[interfaceId] = true;
238   }
239 }
240 
241 /**
242  * @title ERC721 Non-Fungible Token Standard basic implementation
243  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
244  */
245 contract ERC721 is ERC165, IERC721 {
246 
247   using SafeMath for uint256;
248   using Address for address;
249 
250   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
251   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
252   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
253 
254   // Mapping from token ID to owner
255   mapping (uint256 => address) private _tokenOwner;
256 
257   // Mapping from token ID to approved address
258   mapping (uint256 => address) private _tokenApprovals;
259 
260   // Mapping from owner to number of owned token
261   mapping (address => uint256) private _ownedTokensCount;
262 
263   // Mapping from owner to operator approvals
264   mapping (address => mapping (address => bool)) private _operatorApprovals;
265 
266   bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
267   /*
268    * 0x80ac58cd ===
269    *   bytes4(keccak256('balanceOf(address)')) ^
270    *   bytes4(keccak256('ownerOf(uint256)')) ^
271    *   bytes4(keccak256('approve(address,uint256)')) ^
272    *   bytes4(keccak256('getApproved(uint256)')) ^
273    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
274    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
275    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
276    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
277    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
278    */
279 
280   constructor()
281     public
282   {
283     // register the supported interfaces to conform to ERC721 via ERC165
284     _registerInterface(_InterfaceId_ERC721);
285   }
286 
287   /**
288    * @dev Gets the balance of the specified address
289    * @param owner address to query the balance of
290    * @return uint256 representing the amount owned by the passed address
291    */
292   function balanceOf(address owner) public view returns (uint256) {
293     require(owner != address(0));
294     return _ownedTokensCount[owner];
295   }
296 
297   /**
298    * @dev Gets the owner of the specified token ID
299    * @param tokenId uint256 ID of the token to query the owner of
300    * @return owner address currently marked as the owner of the given token ID
301    */
302   function ownerOf(uint256 tokenId) public view returns (address) {
303     address owner = _tokenOwner[tokenId];
304     require(owner != address(0));
305     return owner;
306   }
307 
308   /**
309    * @dev Approves another address to transfer the given token ID
310    * The zero address indicates there is no approved address.
311    * There can only be one approved address per token at a given time.
312    * Can only be called by the token owner or an approved operator.
313    * @param to address to be approved for the given token ID
314    * @param tokenId uint256 ID of the token to be approved
315    */
316   function approve(address to, uint256 tokenId) public {
317     address owner = ownerOf(tokenId);
318     require(to != owner);
319     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
320 
321     _tokenApprovals[tokenId] = to;
322     emit Approval(owner, to, tokenId);
323   }
324 
325   /**
326    * @dev Gets the approved address for a token ID, or zero if no address set
327    * Reverts if the token ID does not exist.
328    * @param tokenId uint256 ID of the token to query the approval of
329    * @return address currently approved for the given token ID
330    */
331   function getApproved(uint256 tokenId) public view returns (address) {
332     require(_exists(tokenId));
333     return _tokenApprovals[tokenId];
334   }
335 
336   /**
337    * @dev Sets or unsets the approval of a given operator
338    * An operator is allowed to transfer all tokens of the sender on their behalf
339    * @param to operator address to set the approval
340    * @param approved representing the status of the approval to be set
341    */
342   function setApprovalForAll(address to, bool approved) public {
343     require(to != msg.sender);
344     _operatorApprovals[msg.sender][to] = approved;
345     emit ApprovalForAll(msg.sender, to, approved);
346   }
347 
348   /**
349    * @dev Tells whether an operator is approved by a given owner
350    * @param owner owner address which you want to query the approval of
351    * @param operator operator address which you want to query the approval of
352    * @return bool whether the given operator is approved by the given owner
353    */
354   function isApprovedForAll(
355     address owner,
356     address operator
357   )
358     public
359     view
360     returns (bool)
361   {
362     return _operatorApprovals[owner][operator];
363   }
364 
365   /**
366    * @dev Transfers the ownership of a given token ID to another address
367    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
368    * Requires the msg sender to be the owner, approved, or operator
369    * @param from current owner of the token
370    * @param to address to receive the ownership of the given token ID
371    * @param tokenId uint256 ID of the token to be transferred
372   */
373   function transferFrom(
374     address from,
375     address to,
376     uint256 tokenId
377   )
378     public
379   {
380     require(_isApprovedOrOwner(msg.sender, tokenId));
381     require(to != address(0));
382 
383     _clearApproval(from, tokenId);
384     _removeTokenFrom(from, tokenId);
385     _addTokenTo(to, tokenId);
386 
387     emit Transfer(from, to, tokenId);
388   }
389 
390   /**
391    * @dev Safely transfers the ownership of a given token ID to another address
392    * If the target address is a contract, it must implement `onERC721Received`,
393    * which is called upon a safe transfer, and return the magic value
394    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
395    * the transfer is reverted.
396    *
397    * Requires the msg sender to be the owner, approved, or operator
398    * @param from current owner of the token
399    * @param to address to receive the ownership of the given token ID
400    * @param tokenId uint256 ID of the token to be transferred
401   */
402   function safeTransferFrom(
403     address from,
404     address to,
405     uint256 tokenId
406   )
407     public
408   {
409     // solium-disable-next-line arg-overflow
410     safeTransferFrom(from, to, tokenId, "");
411   }
412 
413   /**
414    * @dev Safely transfers the ownership of a given token ID to another address
415    * If the target address is a contract, it must implement `onERC721Received`,
416    * which is called upon a safe transfer, and return the magic value
417    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
418    * the transfer is reverted.
419    * Requires the msg sender to be the owner, approved, or operator
420    * @param from current owner of the token
421    * @param to address to receive the ownership of the given token ID
422    * @param tokenId uint256 ID of the token to be transferred
423    * @param _data bytes data to send along with a safe transfer check
424    */
425   function safeTransferFrom(
426     address from,
427     address to,
428     uint256 tokenId,
429     bytes _data
430   )
431     public
432   {
433     transferFrom(from, to, tokenId);
434     // solium-disable-next-line arg-overflow
435     require(_checkOnERC721Received(from, to, tokenId, _data));
436   }
437 
438   /**
439    * @dev Returns whether the specified token exists
440    * @param tokenId uint256 ID of the token to query the existence of
441    * @return whether the token exists
442    */
443   function _exists(uint256 tokenId) internal view returns (bool) {
444     address owner = _tokenOwner[tokenId];
445     return owner != address(0);
446   }
447 
448   /**
449    * @dev Returns whether the given spender can transfer a given token ID
450    * @param spender address of the spender to query
451    * @param tokenId uint256 ID of the token to be transferred
452    * @return bool whether the msg.sender is approved for the given token ID,
453    *  is an operator of the owner, or is the owner of the token
454    */
455   function _isApprovedOrOwner(
456     address spender,
457     uint256 tokenId
458   )
459     internal
460     view
461     returns (bool)
462   {
463     address owner = ownerOf(tokenId);
464     // Disable solium check because of
465     // https://github.com/duaraghav8/Solium/issues/175
466     // solium-disable-next-line operator-whitespace
467     return (
468       spender == owner ||
469       getApproved(tokenId) == spender ||
470       isApprovedForAll(owner, spender)
471     );
472   }
473 
474   /**
475    * @dev Internal function to mint a new token
476    * Reverts if the given token ID already exists
477    * @param to The address that will own the minted token
478    * @param tokenId uint256 ID of the token to be minted by the msg.sender
479    */
480   function _mint(address to, uint256 tokenId) internal {
481     require(to != address(0));
482   
483     _addTokenTo(to, tokenId);
484     emit Transfer(address(0), to, tokenId);
485   }
486 
487   /**
488    * @dev Internal function to burn a specific token
489    * Reverts if the token does not exist
490    * @param tokenId uint256 ID of the token being burned by the msg.sender
491    */
492   function _burn(address owner, uint256 tokenId) internal {
493     _clearApproval(owner, tokenId);
494     _removeTokenFrom(owner, tokenId);
495     emit Transfer(owner, address(0), tokenId);
496   }
497 
498   /**
499    * @dev Internal function to add a token ID to the list of a given address
500    * Note that this function is left internal to make ERC721Enumerable possible, but is not
501    * intended to be called by custom derived contracts: in particular, it emits no Transfer event.
502    * @param to address representing the new owner of the given token ID
503    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
504    */
505   function _addTokenTo(address to, uint256 tokenId) internal {
506     require(_tokenOwner[tokenId] == address(0));
507     _tokenOwner[tokenId] = to;
508     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
509   }
510 
511   /**
512    * @dev Internal function to remove a token ID from the list of a given address
513    * Note that this function is left internal to make ERC721Enumerable possible, but is not
514    * intended to be called by custom derived contracts: in particular, it emits no Transfer event,
515    * and doesn't clear approvals.
516    * @param from address representing the previous owner of the given token ID
517    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
518    */
519   function _removeTokenFrom(address from, uint256 tokenId) internal {
520     require(ownerOf(tokenId) == from);
521     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
522     _tokenOwner[tokenId] = address(0);
523   }
524 
525   /**
526    * @dev Internal function to invoke `onERC721Received` on a target address
527    * The call is not executed if the target address is not a contract
528    * @param from address representing the previous owner of the given token ID
529    * @param to target address that will receive the tokens
530    * @param tokenId uint256 ID of the token to be transferred
531    * @param _data bytes optional data to send along with the call
532    * @return whether the call correctly returned the expected magic value
533    */
534   function _checkOnERC721Received(
535     address from,
536     address to,
537     uint256 tokenId,
538     bytes _data
539   )
540     internal
541     returns (bool)
542   {
543     if (!to.isContract()) {
544       return true;
545     }
546     bytes4 retval = IERC721Receiver(to).onERC721Received(
547       msg.sender, from, tokenId, _data);
548     return (retval == _ERC721_RECEIVED);
549   }
550 
551   /**
552    * @dev Private function to clear current approval of a given token ID
553    * Reverts if the given address is not indeed the owner of the token
554    * @param owner owner of the token
555    * @param tokenId uint256 ID of the token to be transferred
556    */
557   function _clearApproval(address owner, uint256 tokenId) private {
558     require(ownerOf(tokenId) == owner);
559     if (_tokenApprovals[tokenId] != address(0)) {
560       _tokenApprovals[tokenId] = address(0);
561     }
562   }
563 }
564 
565 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
566   // Mapping from owner to list of owned token IDs
567   mapping(address => uint256[]) private _ownedTokens;
568 
569   // Mapping from token ID to index of the owner tokens list
570   mapping(uint256 => uint256) private _ownedTokensIndex;
571 
572   // Array with all token ids, used for enumeration
573   uint256[] private _allTokens;
574 
575   // Mapping from token id to position in the allTokens array
576   mapping(uint256 => uint256) private _allTokensIndex;
577 
578   bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;
579   /**
580    * 0x780e9d63 ===
581    *   bytes4(keccak256('totalSupply()')) ^
582    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
583    *   bytes4(keccak256('tokenByIndex(uint256)'))
584    */
585 
586   /**
587    * @dev Constructor function
588    */
589   constructor() public {
590     // register the supported interface to conform to ERC721 via ERC165
591     _registerInterface(_InterfaceId_ERC721Enumerable);
592   }
593 
594   /**
595    * @dev Gets the token ID at a given index of the tokens list of the requested owner
596    * @param owner address owning the tokens list to be accessed
597    * @param index uint256 representing the index to be accessed of the requested tokens list
598    * @return uint256 token ID at the given index of the tokens list owned by the requested address
599    */
600   function tokenOfOwnerByIndex(
601     address owner,
602     uint256 index
603   )
604     public
605     view
606     returns (uint256)
607   {
608     require(index < balanceOf(owner));
609     return _ownedTokens[owner][index];
610   }
611 
612   /**
613    * @dev Gets the total amount of tokens stored by the contract
614    * @return uint256 representing the total amount of tokens
615    */
616   function totalSupply() public view returns (uint256) {
617     return _allTokens.length;
618   }
619 
620   /**
621    * @dev Gets the token ID at a given index of all the tokens in this contract
622    * Reverts if the index is greater or equal to the total number of tokens
623    * @param index uint256 representing the index to be accessed of the tokens list
624    * @return uint256 token ID at the given index of the tokens list
625    */
626   function tokenByIndex(uint256 index) public view returns (uint256) {
627     require(index < totalSupply());
628     return _allTokens[index];
629   }
630 
631   /**
632    * @dev Internal function to add a token ID to the list of a given address
633    * This function is internal due to language limitations, see the note in ERC721.sol.
634    * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event.
635    * @param to address representing the new owner of the given token ID
636    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
637    */
638   function _addTokenTo(address to, uint256 tokenId) internal {
639     super._addTokenTo(to, tokenId);
640     uint256 length = _ownedTokens[to].length;
641     _ownedTokens[to].push(tokenId);
642     _ownedTokensIndex[tokenId] = length;
643   }
644 
645   /**
646    * @dev Internal function to remove a token ID from the list of a given address
647    * This function is internal due to language limitations, see the note in ERC721.sol.
648    * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event,
649    * and doesn't clear approvals.
650    * @param from address representing the previous owner of the given token ID
651    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
652    */
653   function _removeTokenFrom(address from, uint256 tokenId) internal {
654     super._removeTokenFrom(from, tokenId);
655 
656     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
657     // then delete the last slot.
658     uint256 tokenIndex = _ownedTokensIndex[tokenId];
659     uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
660     uint256 lastToken = _ownedTokens[from][lastTokenIndex];
661 
662     _ownedTokens[from][tokenIndex] = lastToken;
663     // This also deletes the contents at the last position of the array
664     _ownedTokens[from].length--;
665 
666     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
667     // be zero. Then we can make sure that we will remove tokenId from the ownedTokens list since we are first swapping
668     // the lastToken to the first position, and then dropping the element placed in the last position of the list
669 
670     _ownedTokensIndex[tokenId] = 0;
671     _ownedTokensIndex[lastToken] = tokenIndex;
672   }
673 
674   /**
675    * @dev Internal function to mint a new token
676    * Reverts if the given token ID already exists
677    * @param to address the beneficiary that will own the minted token
678    * @param tokenId uint256 ID of the token to be minted by the msg.sender
679    */
680   function _mint(address to, uint256 tokenId) internal {
681     super._mint(to, tokenId);
682 
683     _allTokensIndex[tokenId] = _allTokens.length;
684     _allTokens.push(tokenId);
685   }
686 
687   /**
688    * @dev Internal function to burn a specific token
689    * Reverts if the token does not exist
690    * @param owner owner of the token to burn
691    * @param tokenId uint256 ID of the token being burned by the msg.sender
692    */
693   function _burn(address owner, uint256 tokenId) internal {
694     super._burn(owner, tokenId);
695 
696     // Reorg all tokens array
697     uint256 tokenIndex = _allTokensIndex[tokenId];
698     uint256 lastTokenIndex = _allTokens.length.sub(1);
699     uint256 lastToken = _allTokens[lastTokenIndex];
700 
701     _allTokens[tokenIndex] = lastToken;
702     _allTokens[lastTokenIndex] = 0;
703 
704     _allTokens.length--;
705     _allTokensIndex[tokenId] = 0;
706     _allTokensIndex[lastToken] = tokenIndex;
707   }
708 }
709 
710 /**
711  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
712  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
713  */
714 contract IERC721Metadata is IERC721 {
715   function name() external view returns (string);
716   function symbol() external view returns (string);
717   function tokenURI(uint256 tokenId) external view returns (string);
718 }
719 
720 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
721   // Token name
722   string private _name;
723 
724   // Token symbol
725   string private _symbol;
726 
727   // Optional mapping for token URIs
728   mapping(uint256 => string) private _tokenURIs;
729 
730   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
731   /**
732    * 0x5b5e139f ===
733    *   bytes4(keccak256('name()')) ^
734    *   bytes4(keccak256('symbol()')) ^
735    *   bytes4(keccak256('tokenURI(uint256)'))
736    */
737 
738   /**
739    * @dev Constructor function
740    */
741   constructor(string name, string symbol) public {
742     _name = name;
743     _symbol = symbol;
744    
745     // register the supported interfaces to conform to ERC721 via ERC165
746     _registerInterface(InterfaceId_ERC721Metadata);
747   }
748 
749   /**
750    * @dev Gets the token name
751    * @return string representing the token name
752    */
753   function name() external view returns (string) {
754     return _name;
755   }
756 
757   /**
758    * @dev Gets the token symbol
759    * @return string representing the token symbol
760    */
761   function symbol() external view returns (string) {
762     return _symbol;
763   }
764 
765   /**
766    * @dev Returns an URI for a given token ID
767    * Throws if the token ID does not exist. May return an empty string.
768    * @param tokenId uint256 ID of the token to query
769    */
770   function tokenURI(uint256 tokenId) external view returns (string) {
771     require(_exists(tokenId));
772     return _tokenURIs[tokenId];
773   }
774 
775   /**
776    * @dev Internal function to set the token URI for a given token
777    * Reverts if the token ID does not exist
778    * @param tokenId uint256 ID of the token to set its URI
779    * @param uri string URI to assign
780    */
781   function _setTokenURI(uint256 tokenId, string uri) internal {
782     require(_exists(tokenId));
783     _tokenURIs[tokenId] = uri;
784   }
785 
786   /**
787    * @dev Internal function to burn a specific token
788    * Reverts if the token does not exist
789    * @param owner owner of the token to burn
790    * @param tokenId uint256 ID of the token being burned by the msg.sender
791    */
792   function _burn(address owner, uint256 tokenId) internal {
793     super._burn(owner, tokenId);
794 
795     // Clear metadata (if any)
796     if (bytes(_tokenURIs[tokenId]).length != 0) {
797       delete _tokenURIs[tokenId];
798     }
799   }
800 }
801 
802 /**
803  * @title Roles
804  * @dev Library for managing addresses assigned to a Role.
805  */
806 library Roles {
807   struct Role {
808     mapping (address => bool) bearer;
809   }
810 
811   /**
812    * @dev give an account access to this role
813    */
814   function add(Role storage role, address account) internal {
815     require(account != address(0));
816     require(!has(role, account));
817 
818     role.bearer[account] = true;
819   }
820 
821   /**
822    * @dev remove an account's access to this role
823    */
824   function remove(Role storage role, address account) internal {
825     require(account != address(0));
826     require(has(role, account));
827 
828     role.bearer[account] = false;
829   }
830 
831   /**
832    * @dev check if an account has this role
833    * @return bool
834    */
835   function has(Role storage role, address account)
836     internal
837     view
838     returns (bool)
839   {
840     require(account != address(0));
841     return role.bearer[account];
842   }
843 }
844 
845 contract MinterRole {
846   using Roles for Roles.Role;
847 
848   event MinterAdded(address indexed account);
849   event MinterRemoved(address indexed account);
850 
851   Roles.Role private minters;
852 
853   constructor() internal {
854     _addMinter(msg.sender);
855   }
856 
857   modifier onlyMinter() {
858     require(isMinter(msg.sender));
859     _;
860   }
861 
862   function isMinter(address account) public view returns (bool) {
863     return minters.has(account);
864   }
865 
866   function addMinter(address account) public onlyMinter {
867     _addMinter(account);
868   }
869 
870   function renounceMinter() public {
871     _removeMinter(msg.sender);
872   }
873 
874   function _addMinter(address account) internal {
875     minters.add(account);
876     emit MinterAdded(account);
877   }
878 
879   function _removeMinter(address account) internal {
880     minters.remove(account);
881     emit MinterRemoved(account);
882   }
883 }
884 
885 /**
886  * @title ERC721MetadataMintable
887  * @dev ERC721 minting logic with metadata
888  */
889 contract ERC721MetadataMintable is ERC721, ERC721Metadata, MinterRole {
890   /**
891    * @dev Function to mint tokens
892    * @param to The address that will receive the minted tokens.
893    * @param tokenId The token id to mint.
894    * @param tokenURI The token URI of the minted token.
895    * @return A boolean that indicates if the operation was successful.
896    */
897   function mintWithTokenURI(
898     address to,
899     uint256 tokenId,
900     string tokenURI
901   )
902     public
903     onlyMinter
904     returns (bool)
905   {
906     
907     _mint(to, tokenId);
908     _setTokenURI(tokenId, tokenURI);
909     return true;
910   }
911 }
912 
913 /**
914  * @title Full ERC721 Token
915  * This implementation includes all the required and some optional functionality of the ERC721 standard
916  * Moreover, it includes approve all functionality using operator terminology
917  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
918  */
919 contract ERC721FullBatchMint is ERC721Enumerable, ERC721MetadataMintable {
920 
921   string public constant version = "Mintable v0.5" ;
922   uint256 public MAX_MINT;
923 
924   constructor(string name, string symbol, string url, uint256 batchMint, address owner)
925     ERC721Metadata(name, symbol)
926     public
927   {
928     MAX_MINT = batchMint;
929     _mint(owner, 0);
930     _setTokenURI(0, url);
931   }
932 
933   function batchMint (string url, uint256 count)
934     public onlyMinter
935   returns (bool) {
936     if (count > MAX_MINT || count <= 0 || count < 0) {
937       count = MAX_MINT;
938     }
939     uint256 totalSupply = super.totalSupply();
940     for (uint256 i = 0; i < count; i++) {
941       mintWithTokenURI(msg.sender, totalSupply+i, url);
942     }
943     return true;
944   }
945 }