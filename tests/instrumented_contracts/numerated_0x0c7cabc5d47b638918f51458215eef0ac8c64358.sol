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
30     require(b > 0);
31     // Solidity only automatically asserts when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     require(b <= a);
43     uint256 c = a - b;
44 
45     return c;
46   }
47 
48   /**
49   * @dev Adds two numbers, reverts on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     require(c >= a);
54 
55     return c;
56   }
57 
58   /**
59   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60   * reverts when dividing by zero.
61   */
62   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b != 0);
64     return a % b;
65   }
66 }
67 
68 /**
69  * Utility library of inline functions on addresses
70  */
71 library Address {
72 
73   /**
74    * Returns whether the target address is a contract
75    * @dev This function will return false if invoked during the constructor of a contract,
76    * as the code is not actually created until after the constructor finishes.
77    * @param account address of the account to check
78    * @return whether the target address is a contract
79    */
80   function isContract(address account) internal view returns (bool) {
81     uint256 size;
82     // XXX Currently there is no better way to check if there is a contract in an address
83     // than to check the size of the code at that address.
84     // See https://ethereum.stackexchange.com/a/14016/36603
85     // for more details about how this works.
86     // TODO Check this again before the Serenity release, because all addresses will be
87     // contracts then.
88     // solium-disable-next-line security/no-inline-assembly
89     assembly {size := extcodesize(account)}
90     return size > 0;
91   }
92 
93 }
94 
95 
96 /**
97  * @title IERC165
98  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
99  */
100 interface IERC165 {
101 
102   /**
103    * @notice Query if a contract implements an interface
104    * @param interfaceId The interface identifier, as specified in ERC-165
105    * @dev Interface identification is specified in ERC-165. This function
106    * uses less than 30,000 gas.
107    */
108   function supportsInterface(bytes4 interfaceId)
109   external
110   view
111   returns (bool);
112 }
113 
114 
115 /**
116  * @title ERC165
117  * @author Matt Condon (@shrugs)
118  * @dev Implements ERC165 using a lookup table.
119  */
120 contract ERC165 is IERC165 {
121 
122   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
123   /**
124    * 0x01ffc9a7 ===
125    *   bytes4(keccak256('supportsInterface(bytes4)'))
126    */
127 
128   /**
129    * @dev a mapping of interface id to whether or not it's supported
130    */
131   mapping(bytes4 => bool) private _supportedInterfaces;
132 
133   /**
134    * @dev A contract implementing SupportsInterfaceWithLookup
135    * implement ERC165 itself
136    */
137   constructor()
138   internal
139   {
140     _registerInterface(_InterfaceId_ERC165);
141   }
142 
143   /**
144    * @dev implement supportsInterface(bytes4) using a lookup table
145    */
146   function supportsInterface(bytes4 interfaceId)
147   external
148   view
149   returns (bool)
150   {
151     return _supportedInterfaces[interfaceId];
152   }
153 
154   /**
155    * @dev internal method for registering an interface
156    */
157   function _registerInterface(bytes4 interfaceId)
158   internal
159   {
160     require(interfaceId != 0xffffffff);
161     _supportedInterfaces[interfaceId] = true;
162   }
163 }
164 
165 
166 
167 /**
168  * @title ERC721 Non-Fungible Token Standard basic interface
169  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
170  */
171 contract IERC721 is IERC165 {
172 
173   event Transfer(
174     address indexed from,
175     address indexed to,
176     uint256 indexed tokenId
177   );
178   event Approval(
179     address indexed owner,
180     address indexed approved,
181     uint256 indexed tokenId
182   );
183   event ApprovalForAll(
184     address indexed owner,
185     address indexed operator,
186     bool approved
187   );
188 
189   function balanceOf(address owner) public view returns (uint256 balance);
190 
191   function ownerOf(uint256 tokenId) public view returns (address owner);
192 
193   function approve(address to, uint256 tokenId) public;
194 
195   function getApproved(uint256 tokenId)
196   public view returns (address operator);
197 
198   function setApprovalForAll(address operator, bool _approved) public;
199 
200   function isApprovedForAll(address owner, address operator)
201   public view returns (bool);
202 
203   function transferFrom(address from, address to, uint256 tokenId) public;
204 
205   function safeTransferFrom(address from, address to, uint256 tokenId)
206   public;
207 
208   function safeTransferFrom(
209     address from,
210     address to,
211     uint256 tokenId,
212     bytes data
213   )
214   public;
215 }
216 
217 
218 /**
219  * @title ERC721 token receiver interface
220  * @dev Interface for any contract that wants to support safeTransfers
221  * from ERC721 asset contracts.
222  */
223 contract IERC721Receiver {
224   /**
225    * @notice Handle the receipt of an NFT
226    * @dev The ERC721 smart contract calls this function on the recipient
227    * after a `safeTransfer`. This function MUST return the function selector,
228    * otherwise the caller will revert the transaction. The selector to be
229    * returned can be obtained as `this.onERC721Received.selector`. This
230    * function MAY throw to revert and reject the transfer.
231    * Note: the ERC721 contract address is always the message sender.
232    * @param operator The address which called `safeTransferFrom` function
233    * @param from The address which previously owned the token
234    * @param tokenId The NFT identifier which is being transferred
235    * @param data Additional data with no specified format
236    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
237    */
238   function onERC721Received(
239     address operator,
240     address from,
241     uint256 tokenId,
242     bytes data
243   )
244   public
245   returns (bytes4);
246 }
247 
248 
249 /**
250  * @title ERC721 Non-Fungible Token Standard basic implementation
251  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
252  */
253 contract ERC721 is ERC165, IERC721 {
254 
255   using SafeMath for uint256;
256   using Address for address;
257 
258   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
259   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
260   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
261 
262   // Mapping from token ID to owner
263   mapping(uint256 => address) private _tokenOwner;
264 
265   // Mapping from token ID to approved address
266   mapping(uint256 => address) private _tokenApprovals;
267 
268   // Mapping from owner to number of owned token
269   mapping(address => uint256) private _ownedTokensCount;
270 
271   // Mapping from owner to operator approvals
272   mapping(address => mapping(address => bool)) private _operatorApprovals;
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
289   public
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
366   public
367   view
368   returns (bool)
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
386   public
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
398   /**
399    * @dev Safely transfers the ownership of a given token ID to another address
400    * If the target address is a contract, it must implement `onERC721Received`,
401    * which is called upon a safe transfer, and return the magic value
402    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
403    * the transfer is reverted.
404    *
405    * Requires the msg sender to be the owner, approved, or operator
406    * @param from current owner of the token
407    * @param to address to receive the ownership of the given token ID
408    * @param tokenId uint256 ID of the token to be transferred
409   */
410   function safeTransferFrom(
411     address from,
412     address to,
413     uint256 tokenId
414   )
415   public
416   {
417     // solium-disable-next-line arg-overflow
418     safeTransferFrom(from, to, tokenId, "");
419   }
420 
421   /**
422    * @dev Safely transfers the ownership of a given token ID to another address
423    * If the target address is a contract, it must implement `onERC721Received`,
424    * which is called upon a safe transfer, and return the magic value
425    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
426    * the transfer is reverted.
427    * Requires the msg sender to be the owner, approved, or operator
428    * @param from current owner of the token
429    * @param to address to receive the ownership of the given token ID
430    * @param tokenId uint256 ID of the token to be transferred
431    * @param _data bytes data to send along with a safe transfer check
432    */
433   function safeTransferFrom(
434     address from,
435     address to,
436     uint256 tokenId,
437     bytes _data
438   )
439   public
440   {
441     transferFrom(from, to, tokenId);
442     // solium-disable-next-line arg-overflow
443     require(_checkOnERC721Received(from, to, tokenId, _data));
444   }
445 
446   /**
447    * @dev Returns whether the specified token exists
448    * @param tokenId uint256 ID of the token to query the existence of
449    * @return whether the token exists
450    */
451   function _exists(uint256 tokenId) internal view returns (bool) {
452     address owner = _tokenOwner[tokenId];
453     return owner != address(0);
454   }
455 
456   /**
457    * @dev Returns whether the given spender can transfer a given token ID
458    * @param spender address of the spender to query
459    * @param tokenId uint256 ID of the token to be transferred
460    * @return bool whether the msg.sender is approved for the given token ID,
461    *  is an operator of the owner, or is the owner of the token
462    */
463   function _isApprovedOrOwner(
464     address spender,
465     uint256 tokenId
466   )
467   internal
468   view
469   returns (bool)
470   {
471     address owner = ownerOf(tokenId);
472     // Disable solium check because of
473     // https://github.com/duaraghav8/Solium/issues/175
474     // solium-disable-next-line operator-whitespace
475     return (
476     spender == owner ||
477     getApproved(tokenId) == spender ||
478     isApprovedForAll(owner, spender)
479     );
480   }
481 
482   /**
483    * @dev Internal function to mint a new token
484    * Reverts if the given token ID already exists
485    * @param to The address that will own the minted token
486    * @param tokenId uint256 ID of the token to be minted by the msg.sender
487    */
488   function _mint(address to, uint256 tokenId) internal {
489     require(to != address(0));
490     _addTokenTo(to, tokenId);
491     emit Transfer(address(0), to, tokenId);
492   }
493 
494   /**
495    * @dev Internal function to burn a specific token
496    * Reverts if the token does not exist
497    * @param tokenId uint256 ID of the token being burned by the msg.sender
498    */
499   function _burn(address owner, uint256 tokenId) internal {
500     _clearApproval(owner, tokenId);
501     _removeTokenFrom(owner, tokenId);
502     emit Transfer(owner, address(0), tokenId);
503   }
504 
505   /**
506    * @dev Internal function to add a token ID to the list of a given address
507    * Note that this function is left internal to make ERC721Enumerable possible, but is not
508    * intended to be called by custom derived contracts: in particular, it emits no Transfer event.
509    * @param to address representing the new owner of the given token ID
510    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
511    */
512   function _addTokenTo(address to, uint256 tokenId) internal {
513     require(_tokenOwner[tokenId] == address(0));
514     _tokenOwner[tokenId] = to;
515     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
516   }
517 
518   /**
519    * @dev Internal function to remove a token ID from the list of a given address
520    * Note that this function is left internal to make ERC721Enumerable possible, but is not
521    * intended to be called by custom derived contracts: in particular, it emits no Transfer event,
522    * and doesn't clear approvals.
523    * @param from address representing the previous owner of the given token ID
524    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
525    */
526   function _removeTokenFrom(address from, uint256 tokenId) internal {
527     require(ownerOf(tokenId) == from);
528     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
529     _tokenOwner[tokenId] = address(0);
530   }
531 
532   /**
533    * @dev Internal function to invoke `onERC721Received` on a target address
534    * The call is not executed if the target address is not a contract
535    * @param from address representing the previous owner of the given token ID
536    * @param to target address that will receive the tokens
537    * @param tokenId uint256 ID of the token to be transferred
538    * @param _data bytes optional data to send along with the call
539    * @return whether the call correctly returned the expected magic value
540    */
541   function _checkOnERC721Received(
542     address from,
543     address to,
544     uint256 tokenId,
545     bytes _data
546   )
547   internal
548   returns (bool)
549   {
550     if (!to.isContract()) {
551       return true;
552     }
553     bytes4 retval = IERC721Receiver(to).onERC721Received(
554       msg.sender, from, tokenId, _data);
555     return (retval == _ERC721_RECEIVED);
556   }
557 
558   /**
559    * @dev Private function to clear current approval of a given token ID
560    * Reverts if the given address is not indeed the owner of the token
561    * @param owner owner of the token
562    * @param tokenId uint256 ID of the token to be transferred
563    */
564   function _clearApproval(address owner, uint256 tokenId) private {
565     require(ownerOf(tokenId) == owner);
566     if (_tokenApprovals[tokenId] != address(0)) {
567       _tokenApprovals[tokenId] = address(0);
568     }
569   }
570 }
571 
572 /**
573  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
574  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
575  */
576 contract IERC721Enumerable is IERC721 {
577   function totalSupply() public view returns (uint256);
578 
579   function tokenOfOwnerByIndex(
580     address owner,
581     uint256 index
582   )
583   public
584   view
585   returns (uint256 tokenId);
586 
587   function tokenByIndex(uint256 index) public view returns (uint256);
588 }
589 
590 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
591   // Mapping from owner to list of owned token IDs
592   mapping(address => uint256[]) private _ownedTokens;
593 
594   // Mapping from token ID to index of the owner tokens list
595   mapping(uint256 => uint256) private _ownedTokensIndex;
596 
597   // Array with all token ids, used for enumeration
598   uint256[] private _allTokens;
599 
600   // Mapping from token id to position in the allTokens array
601   mapping(uint256 => uint256) private _allTokensIndex;
602 
603   bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;
604   /**
605    * 0x780e9d63 ===
606    *   bytes4(keccak256('totalSupply()')) ^
607    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
608    *   bytes4(keccak256('tokenByIndex(uint256)'))
609    */
610 
611   /**
612    * @dev Constructor function
613    */
614   constructor() public {
615     // register the supported interface to conform to ERC721 via ERC165
616     _registerInterface(_InterfaceId_ERC721Enumerable);
617   }
618 
619   /**
620    * @dev Gets the token ID at a given index of the tokens list of the requested owner
621    * @param owner address owning the tokens list to be accessed
622    * @param index uint256 representing the index to be accessed of the requested tokens list
623    * @return uint256 token ID at the given index of the tokens list owned by the requested address
624    */
625   function tokenOfOwnerByIndex(
626     address owner,
627     uint256 index
628   )
629   public
630   view
631   returns (uint256)
632   {
633     require(index < balanceOf(owner));
634     return _ownedTokens[owner][index];
635   }
636 
637   /**
638    * @dev Gets the total amount of tokens stored by the contract
639    * @return uint256 representing the total amount of tokens
640    */
641   function totalSupply() public view returns (uint256) {
642     return _allTokens.length;
643   }
644 
645   /**
646    * @dev Gets the token ID at a given index of all the tokens in this contract
647    * Reverts if the index is greater or equal to the total number of tokens
648    * @param index uint256 representing the index to be accessed of the tokens list
649    * @return uint256 token ID at the given index of the tokens list
650    */
651   function tokenByIndex(uint256 index) public view returns (uint256) {
652     require(index < totalSupply());
653     return _allTokens[index];
654   }
655 
656   /**
657    * @dev Internal function to add a token ID to the list of a given address
658    * This function is internal due to language limitations, see the note in ERC721.sol.
659    * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event.
660    * @param to address representing the new owner of the given token ID
661    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
662    */
663   function _addTokenTo(address to, uint256 tokenId) internal {
664     super._addTokenTo(to, tokenId);
665     uint256 length = _ownedTokens[to].length;
666     _ownedTokens[to].push(tokenId);
667     _ownedTokensIndex[tokenId] = length;
668   }
669 
670   /**
671    * @dev Internal function to remove a token ID from the list of a given address
672    * This function is internal due to language limitations, see the note in ERC721.sol.
673    * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event,
674    * and doesn't clear approvals.
675    * @param from address representing the previous owner of the given token ID
676    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
677    */
678   function _removeTokenFrom(address from, uint256 tokenId) internal {
679     super._removeTokenFrom(from, tokenId);
680 
681     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
682     // then delete the last slot.
683     uint256 tokenIndex = _ownedTokensIndex[tokenId];
684     uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
685     uint256 lastToken = _ownedTokens[from][lastTokenIndex];
686 
687     _ownedTokens[from][tokenIndex] = lastToken;
688     // This also deletes the contents at the last position of the array
689     _ownedTokens[from].length--;
690 
691     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
692     // be zero. Then we can make sure that we will remove tokenId from the ownedTokens list since we are first swapping
693     // the lastToken to the first position, and then dropping the element placed in the last position of the list
694 
695     _ownedTokensIndex[tokenId] = 0;
696     _ownedTokensIndex[lastToken] = tokenIndex;
697   }
698 
699   /**
700    * @dev Internal function to mint a new token
701    * Reverts if the given token ID already exists
702    * @param to address the beneficiary that will own the minted token
703    * @param tokenId uint256 ID of the token to be minted by the msg.sender
704    */
705   function _mint(address to, uint256 tokenId) internal {
706     super._mint(to, tokenId);
707 
708     _allTokensIndex[tokenId] = _allTokens.length;
709     _allTokens.push(tokenId);
710   }
711 
712   /**
713    * @dev Internal function to burn a specific token
714    * Reverts if the token does not exist
715    * @param owner owner of the token to burn
716    * @param tokenId uint256 ID of the token being burned by the msg.sender
717    */
718   function _burn(address owner, uint256 tokenId) internal {
719     super._burn(owner, tokenId);
720 
721     // Reorg all tokens array
722     uint256 tokenIndex = _allTokensIndex[tokenId];
723     uint256 lastTokenIndex = _allTokens.length.sub(1);
724     uint256 lastToken = _allTokens[lastTokenIndex];
725 
726     _allTokens[tokenIndex] = lastToken;
727     _allTokens[lastTokenIndex] = 0;
728 
729     _allTokens.length--;
730     _allTokensIndex[tokenId] = 0;
731     _allTokensIndex[lastToken] = tokenIndex;
732   }
733 }
734 
735 
736 
737 
738 /**
739  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
740  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
741  */
742 contract IERC721Metadata is IERC721 {
743   function name() external view returns (string);
744 
745   function symbol() external view returns (string);
746 
747   function tokenURI(uint256 tokenId) external view returns (string);
748 }
749 
750 
751 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
752   // Token name
753   string private _name;
754 
755   // Token symbol
756   string private _symbol;
757 
758   // Optional mapping for token URIs
759   mapping(uint256 => string) private _tokenURIs;
760 
761   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
762   /**
763    * 0x5b5e139f ===
764    *   bytes4(keccak256('name()')) ^
765    *   bytes4(keccak256('symbol()')) ^
766    *   bytes4(keccak256('tokenURI(uint256)'))
767    */
768 
769   /**
770    * @dev Constructor function
771    */
772   constructor(string name, string symbol) public {
773     _name = name;
774     _symbol = symbol;
775 
776     // register the supported interfaces to conform to ERC721 via ERC165
777     _registerInterface(InterfaceId_ERC721Metadata);
778   }
779 
780   /**
781    * @dev Gets the token name
782    * @return string representing the token name
783    */
784   function name() external view returns (string) {
785     return _name;
786   }
787 
788   /**
789    * @dev Gets the token symbol
790    * @return string representing the token symbol
791    */
792   function symbol() external view returns (string) {
793     return _symbol;
794   }
795 
796   /**
797    * @dev Returns an URI for a given token ID
798    * Throws if the token ID does not exist. May return an empty string.
799    * @param tokenId uint256 ID of the token to query
800    */
801   function tokenURI(uint256 tokenId) external view returns (string) {
802     require(_exists(tokenId));
803     return _tokenURIs[tokenId];
804   }
805 
806   /**
807    * @dev Internal function to set the token URI for a given token
808    * Reverts if the token ID does not exist
809    * @param tokenId uint256 ID of the token to set its URI
810    * @param uri string URI to assign
811    */
812   function _setTokenURI(uint256 tokenId, string uri) internal {
813     require(_exists(tokenId));
814     _tokenURIs[tokenId] = uri;
815   }
816 
817   /**
818    * @dev Internal function to burn a specific token
819    * Reverts if the token does not exist
820    * @param owner owner of the token to burn
821    * @param tokenId uint256 ID of the token being burned by the msg.sender
822    */
823   function _burn(address owner, uint256 tokenId) internal {
824     super._burn(owner, tokenId);
825 
826     // Clear metadata (if any)
827     if (bytes(_tokenURIs[tokenId]).length != 0) {
828       delete _tokenURIs[tokenId];
829     }
830   }
831 }
832 
833 /**
834  * @title Full ERC721 Token
835  * This implementation includes all the required and some optional functionality of the ERC721 standard
836  * Moreover, it includes approve all functionality using operator terminology
837  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
838  */
839 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
840   constructor(string name, string symbol) ERC721Metadata(name, symbol)
841   public
842   {
843   }
844 }
845 
846 /**
847  * @title Roles
848  * @dev Library for managing addresses assigned to a Role.
849  */
850 library Roles {
851   struct Role {
852     mapping(address => bool) bearer;
853   }
854 
855   /**
856    * @dev give an account access to this role
857    */
858   function add(Role storage role, address account) internal {
859     require(account != address(0));
860     require(!has(role, account));
861 
862     role.bearer[account] = true;
863   }
864 
865   /**
866    * @dev remove an account's access to this role
867    */
868   function remove(Role storage role, address account) internal {
869     require(account != address(0));
870     require(has(role, account));
871 
872     role.bearer[account] = false;
873   }
874 
875   /**
876    * @dev check if an account has this role
877    * @return bool
878    */
879   function has(Role storage role, address account)
880   internal
881   view
882   returns (bool)
883   {
884     require(account != address(0));
885     return role.bearer[account];
886   }
887 }
888 
889 
890 contract MinterRole {
891   using Roles for Roles.Role;
892 
893   event MinterAdded(address indexed account);
894   event MinterRemoved(address indexed account);
895 
896   Roles.Role private minters;
897 
898   constructor() internal {
899     _addMinter(msg.sender);
900   }
901 
902   modifier onlyMinter() {
903     require(isMinter(msg.sender));
904     _;
905   }
906 
907   function isMinter(address account) public view returns (bool) {
908     return minters.has(account);
909   }
910 
911   function addMinter(address account) public onlyMinter {
912     _addMinter(account);
913   }
914 
915   function renounceMinter() public {
916     _removeMinter(msg.sender);
917   }
918 
919   function _addMinter(address account) internal {
920     minters.add(account);
921     emit MinterAdded(account);
922   }
923 
924   function _removeMinter(address account) internal {
925     minters.remove(account);
926     emit MinterRemoved(account);
927   }
928 }
929 
930 
931 
932 /**
933  * @title ERC721Mintable
934  * @dev ERC721 minting logic
935  */
936 contract ERC721Mintable is ERC721, MinterRole {
937   /**
938    * @dev Function to mint tokens
939    * @param to The address that will receive the minted tokens.
940    * @param tokenId The token id to mint.
941    * @return A boolean that indicates if the operation was successful.
942    */
943   function mint(
944     address to,
945     uint256 tokenId
946   )
947   public
948   onlyMinter
949   returns (bool)
950   {
951     _mint(to, tokenId);
952     return true;
953   }
954 }
955 
956 
957 /**
958  * @title ERC721MetadataMintable
959  * @dev ERC721 minting logic with metadata
960  */
961 contract ERC721MetadataMintable is ERC721, ERC721Metadata, MinterRole {
962   /**
963    * @dev Function to mint tokens
964    * @param to The address that will receive the minted tokens.
965    * @param tokenId The token id to mint.
966    * @param tokenURI The token URI of the minted token.
967    * @return A boolean that indicates if the operation was successful.
968    */
969   function mintWithTokenURI(
970     address to,
971     uint256 tokenId,
972     string tokenURI
973   )
974   public
975   onlyMinter
976   returns (bool)
977   {
978     _mint(to, tokenId);
979     _setTokenURI(tokenId, tokenURI);
980     return true;
981   }
982 
983 }
984 
985 
986 contract ERC721Burnable is ERC721 {
987   function burn(uint256 tokenId)
988   public
989   {
990     require(_isApprovedOrOwner(msg.sender, tokenId));
991     _burn(ownerOf(tokenId), tokenId);
992   }
993 }
994 
995 
996 
997 /**
998  * @title Ownable
999  * @dev The Ownable contract has an owner address, and provides basic authorization control
1000  * functions, this simplifies the implementation of "user permissions".
1001  */
1002 contract Ownable {
1003   address private _owner;
1004 
1005   event OwnershipRenounced(address indexed previousOwner);
1006   event OwnershipTransferred(
1007     address indexed previousOwner,
1008     address indexed newOwner
1009   );
1010 
1011   /**
1012    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1013    * account.
1014    */
1015   constructor() public {
1016     _owner = msg.sender;
1017   }
1018 
1019   /**
1020    * @return the address of the owner.
1021    */
1022   function owner() public view returns(address) {
1023     return _owner;
1024   }
1025 
1026   /**
1027    * @dev Throws if called by any account other than the owner.
1028    */
1029   modifier onlyOwner() {
1030     require(isOwner());
1031     _;
1032   }
1033 
1034   /**
1035    * @return true if `msg.sender` is the owner of the contract.
1036    */
1037   function isOwner() public view returns(bool) {
1038     return msg.sender == _owner;
1039   }
1040 
1041   /**
1042    * @dev Allows the current owner to relinquish control of the contract.
1043    * @notice Renouncing to ownership will leave the contract without an owner.
1044    * It will not be possible to call the functions with the `onlyOwner`
1045    * modifier anymore.
1046    */
1047   function renounceOwnership() public onlyOwner {
1048     emit OwnershipRenounced(_owner);
1049     _owner = address(0);
1050   }
1051 
1052   /**
1053    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1054    * @param newOwner The address to transfer ownership to.
1055    */
1056   function transferOwnership(address newOwner) public onlyOwner {
1057     _transferOwnership(newOwner);
1058   }
1059 
1060   /**
1061    * @dev Transfers control of the contract to a newOwner.
1062    * @param newOwner The address to transfer ownership to.
1063    */
1064   function _transferOwnership(address newOwner) internal {
1065     require(newOwner != address(0));
1066     emit OwnershipTransferred(_owner, newOwner);
1067     _owner = newOwner;
1068   }
1069 }
1070 
1071 
1072 
1073 contract CryptoLand
1074 is ERC721Full, ERC721Mintable, ERC721MetadataMintable, ERC721Burnable, Ownable {
1075 
1076 
1077   event MintManyToken(
1078     address indexed to,
1079     uint256 howMany,
1080     uint256 tokenIdFrom,
1081     uint256 tokenIdTo
1082   );
1083 
1084   constructor()
1085   ERC721Mintable()
1086   ERC721Full("CryptoLand.gg", "CLGG")
1087   public
1088   {
1089 
1090 
1091   }
1092 
1093 
1094   function mintManyWithTokenUri(
1095     address to,
1096     uint256 howMany,
1097     string tokenURI
1098   )
1099   public
1100   onlyMinter
1101   returns (bool)
1102   {
1103     uint256 totalNum = totalSupply();
1104 
1105     for (uint tokenId = totalNum; tokenId < (howMany + totalNum); tokenId++) {
1106       _mint(to, tokenId);
1107       _setTokenURI(tokenId, tokenURI);
1108     }
1109 
1110     emit MintManyToken(to, howMany, totalNum, tokenId);
1111 
1112     return true;
1113   }
1114 
1115   function setTokenURI(uint256 tokenId, string uri) public
1116   onlyMinter
1117   returns (bool) {
1118     _setTokenURI(tokenId, uri);
1119 
1120     return true;
1121   }
1122 
1123 }