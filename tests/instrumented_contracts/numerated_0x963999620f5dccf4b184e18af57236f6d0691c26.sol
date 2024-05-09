1 /**
2  * Source Code first verified at https://etherscan.io on Monday, September 24, 2018
3  (UTC) */
4 
5 pragma solidity ^0.4.24;
6 
7 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
8 
9 /**
10  * @title IERC165
11  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
12  */
13 interface IERC165 {
14 
15   /**
16    * @notice Query if a contract implements an interface
17    * @param interfaceId The interface identifier, as specified in ERC-165
18    * @dev Interface identification is specified in ERC-165. This function
19    * uses less than 30,000 gas.
20    */
21   function supportsInterface(bytes4 interfaceId)
22     external
23     view
24     returns (bool);
25 }
26 
27 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
28 
29 /**
30  * @title ERC721 Non-Fungible Token Standard basic interface
31  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
32  */
33 contract IERC721 is IERC165 {
34 
35   event Transfer(
36     address indexed from,
37     address indexed to,
38     uint256 indexed tokenId
39   );
40   event Approval(
41     address indexed owner,
42     address indexed approved,
43     uint256 indexed tokenId
44   );
45   event ApprovalForAll(
46     address indexed owner,
47     address indexed operator,
48     bool approved
49   );
50 
51   function balanceOf(address owner) public view returns (uint256 balance);
52   function ownerOf(uint256 tokenId) public view returns (address owner);
53 
54   function approve(address to, uint256 tokenId) public;
55   function getApproved(uint256 tokenId)
56     public view returns (address operator);
57 
58   function setApprovalForAll(address operator, bool _approved) public;
59   function isApprovedForAll(address owner, address operator)
60     public view returns (bool);
61 
62   function transferFrom(address from, address to, uint256 tokenId) public;
63   function safeTransferFrom(address from, address to, uint256 tokenId)
64     public;
65 
66   function safeTransferFrom(
67     address from,
68     address to,
69     uint256 tokenId,
70     bytes data
71   )
72     public;
73 }
74 
75 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
76 
77 /**
78  * @title ERC721 token receiver interface
79  * @dev Interface for any contract that wants to support safeTransfers
80  * from ERC721 asset contracts.
81  */
82 contract IERC721Receiver {
83   /**
84    * @notice Handle the receipt of an NFT
85    * @dev The ERC721 smart contract calls this function on the recipient
86    * after a `safeTransfer`. This function MUST return the function selector,
87    * otherwise the caller will revert the transaction. The selector to be
88    * returned can be obtained as `this.onERC721Received.selector`. This
89    * function MAY throw to revert and reject the transfer.
90    * Note: the ERC721 contract address is always the message sender.
91    * @param operator The address which called `safeTransferFrom` function
92    * @param from The address which previously owned the token
93    * @param tokenId The NFT identifier which is being transferred
94    * @param data Additional data with no specified format
95    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
96    */
97   function onERC721Received(
98     address operator,
99     address from,
100     uint256 tokenId,
101     bytes data
102   )
103     public
104     returns(bytes4);
105 }
106 
107 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
108 
109 /**
110  * @title SafeMath
111  * @dev Math operations with safety checks that revert on error
112  */
113 library SafeMath {
114 
115   /**
116   * @dev Multiplies two numbers, reverts on overflow.
117   */
118   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
120     // benefit is lost if 'b' is also tested.
121     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
122     if (a == 0) {
123       return 0;
124     }
125 
126     uint256 c = a * b;
127     require(c / a == b);
128 
129     return c;
130   }
131 
132   /**
133   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
134   */
135   function div(uint256 a, uint256 b) internal pure returns (uint256) {
136     require(b > 0); // Solidity only automatically asserts when dividing by 0
137     uint256 c = a / b;
138     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
139 
140     return c;
141   }
142 
143   /**
144   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
145   */
146   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147     require(b <= a);
148     uint256 c = a - b;
149 
150     return c;
151   }
152 
153   /**
154   * @dev Adds two numbers, reverts on overflow.
155   */
156   function add(uint256 a, uint256 b) internal pure returns (uint256) {
157     uint256 c = a + b;
158     require(c >= a);
159 
160     return c;
161   }
162 
163   /**
164   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
165   * reverts when dividing by zero.
166   */
167   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
168     require(b != 0);
169     return a % b;
170   }
171 }
172 
173 // File: openzeppelin-solidity/contracts/utils/Address.sol
174 
175 /**
176  * Utility library of inline functions on addresses
177  */
178 library Address {
179 
180   /**
181    * Returns whether the target address is a contract
182    * @dev This function will return false if invoked during the constructor of a contract,
183    * as the code is not actually created until after the constructor finishes.
184    * @param account address of the account to check
185    * @return whether the target address is a contract
186    */
187   function isContract(address account) internal view returns (bool) {
188     uint256 size;
189     // XXX Currently there is no better way to check if there is a contract in an address
190     // than to check the size of the code at that address.
191     // See https://ethereum.stackexchange.com/a/14016/36603
192     // for more details about how this works.
193     // TODO Check this again before the Serenity release, because all addresses will be
194     // contracts then.
195     // solium-disable-next-line security/no-inline-assembly
196     assembly { size := extcodesize(account) }
197     return size > 0;
198   }
199 
200 }
201 
202 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
203 
204 /**
205  * @title ERC165
206  * @author Matt Condon (@shrugs)
207  * @dev Implements ERC165 using a lookup table.
208  */
209 contract ERC165 is IERC165 {
210 
211   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
212   /**
213    * 0x01ffc9a7 ===
214    *   bytes4(keccak256('supportsInterface(bytes4)'))
215    */
216 
217   /**
218    * @dev a mapping of interface id to whether or not it's supported
219    */
220   mapping(bytes4 => bool) internal _supportedInterfaces;
221 
222   /**
223    * @dev A contract implementing SupportsInterfaceWithLookup
224    * implement ERC165 itself
225    */
226   constructor()
227     public
228   {
229     _registerInterface(_InterfaceId_ERC165);
230   }
231 
232   /**
233    * @dev implement supportsInterface(bytes4) using a lookup table
234    */
235   function supportsInterface(bytes4 interfaceId)
236     external
237     view
238     returns (bool)
239   {
240     return _supportedInterfaces[interfaceId];
241   }
242 
243   /**
244    * @dev private method for registering an interface
245    */
246   function _registerInterface(bytes4 interfaceId)
247     internal
248   {
249     require(interfaceId != 0xffffffff);
250     _supportedInterfaces[interfaceId] = true;
251   }
252 }
253 
254 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
255 
256 /**
257  * @title ERC721 Non-Fungible Token Standard basic implementation
258  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
259  */
260 contract ERC721 is ERC165, IERC721 {
261 
262   using SafeMath for uint256;
263   using Address for address;
264 
265   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
266   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
267   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
268 
269   // Mapping from token ID to owner
270   mapping (uint256 => address) private _tokenOwner;
271 
272   // Mapping from token ID to approved address
273   mapping (uint256 => address) private _tokenApprovals;
274 
275   // Mapping from owner to number of owned token
276   mapping (address => uint256) private _ownedTokensCount;
277 
278   // Mapping from owner to operator approvals
279   mapping (address => mapping (address => bool)) private _operatorApprovals;
280 
281   bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
282   /*
283    * 0x80ac58cd ===
284    *   bytes4(keccak256('balanceOf(address)')) ^
285    *   bytes4(keccak256('ownerOf(uint256)')) ^
286    *   bytes4(keccak256('approve(address,uint256)')) ^
287    *   bytes4(keccak256('getApproved(uint256)')) ^
288    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
289    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
290    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
291    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
292    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
293    */
294 
295   constructor()
296     public
297   {
298     // register the supported interfaces to conform to ERC721 via ERC165
299     _registerInterface(_InterfaceId_ERC721);
300   }
301 
302   /**
303    * @dev Gets the balance of the specified address
304    * @param owner address to query the balance of
305    * @return uint256 representing the amount owned by the passed address
306    */
307   function balanceOf(address owner) public view returns (uint256) {
308     require(owner != address(0));
309     return _ownedTokensCount[owner];
310   }
311 
312   /**
313    * @dev Gets the owner of the specified token ID
314    * @param tokenId uint256 ID of the token to query the owner of
315    * @return owner address currently marked as the owner of the given token ID
316    */
317   function ownerOf(uint256 tokenId) public view returns (address) {
318     address owner = _tokenOwner[tokenId];
319     require(owner != address(0));
320     return owner;
321   }
322 
323   /**
324    * @dev Approves another address to transfer the given token ID
325    * The zero address indicates there is no approved address.
326    * There can only be one approved address per token at a given time.
327    * Can only be called by the token owner or an approved operator.
328    * @param to address to be approved for the given token ID
329    * @param tokenId uint256 ID of the token to be approved
330    */
331   function approve(address to, uint256 tokenId) public {
332     address owner = ownerOf(tokenId);
333     require(to != owner);
334     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
335 
336     _tokenApprovals[tokenId] = to;
337     emit Approval(owner, to, tokenId);
338   }
339 
340   /**
341    * @dev Gets the approved address for a token ID, or zero if no address set
342    * Reverts if the token ID does not exist.
343    * @param tokenId uint256 ID of the token to query the approval of
344    * @return address currently approved for the given token ID
345    */
346   function getApproved(uint256 tokenId) public view returns (address) {
347     require(_exists(tokenId));
348     return _tokenApprovals[tokenId];
349   }
350 
351   /**
352    * @dev Sets or unsets the approval of a given operator
353    * An operator is allowed to transfer all tokens of the sender on their behalf
354    * @param to operator address to set the approval
355    * @param approved representing the status of the approval to be set
356    */
357   function setApprovalForAll(address to, bool approved) public {
358     require(to != msg.sender);
359     _operatorApprovals[msg.sender][to] = approved;
360     emit ApprovalForAll(msg.sender, to, approved);
361   }
362 
363   /**
364    * @dev Tells whether an operator is approved by a given owner
365    * @param owner owner address which you want to query the approval of
366    * @param operator operator address which you want to query the approval of
367    * @return bool whether the given operator is approved by the given owner
368    */
369   function isApprovedForAll(
370     address owner,
371     address operator
372   )
373     public
374     view
375     returns (bool)
376   {
377     return _operatorApprovals[owner][operator];
378   }
379 
380   /**
381    * @dev Transfers the ownership of a given token ID to another address
382    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
383    * Requires the msg sender to be the owner, approved, or operator
384    * @param from current owner of the token
385    * @param to address to receive the ownership of the given token ID
386    * @param tokenId uint256 ID of the token to be transferred
387   */
388   function transferFrom(
389     address from,
390     address to,
391     uint256 tokenId
392   )
393     public
394   {
395     require(_isApprovedOrOwner(msg.sender, tokenId));
396     require(to != address(0));
397 
398     _clearApproval(from, tokenId);
399     _removeTokenFrom(from, tokenId);
400     _addTokenTo(to, tokenId);
401 
402     emit Transfer(from, to, tokenId);
403   }
404 
405   /**
406    * @dev Safely transfers the ownership of a given token ID to another address
407    * If the target address is a contract, it must implement `onERC721Received`,
408    * which is called upon a safe transfer, and return the magic value
409    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
410    * the transfer is reverted.
411    *
412    * Requires the msg sender to be the owner, approved, or operator
413    * @param from current owner of the token
414    * @param to address to receive the ownership of the given token ID
415    * @param tokenId uint256 ID of the token to be transferred
416   */
417   function safeTransferFrom(
418     address from,
419     address to,
420     uint256 tokenId
421   )
422     public
423   {
424     // solium-disable-next-line arg-overflow
425     safeTransferFrom(from, to, tokenId, "");
426   }
427 
428   /**
429    * @dev Safely transfers the ownership of a given token ID to another address
430    * If the target address is a contract, it must implement `onERC721Received`,
431    * which is called upon a safe transfer, and return the magic value
432    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
433    * the transfer is reverted.
434    * Requires the msg sender to be the owner, approved, or operator
435    * @param from current owner of the token
436    * @param to address to receive the ownership of the given token ID
437    * @param tokenId uint256 ID of the token to be transferred
438    * @param _data bytes data to send along with a safe transfer check
439    */
440   function safeTransferFrom(
441     address from,
442     address to,
443     uint256 tokenId,
444     bytes _data
445   )
446     public
447   {
448     transferFrom(from, to, tokenId);
449     // solium-disable-next-line arg-overflow
450     require(_checkAndCallSafeTransfer(from, to, tokenId, _data));
451   }
452 
453   /**
454    * @dev Returns whether the specified token exists
455    * @param tokenId uint256 ID of the token to query the existence of
456    * @return whether the token exists
457    */
458   function _exists(uint256 tokenId) internal view returns (bool) {
459     address owner = _tokenOwner[tokenId];
460     return owner != address(0);
461   }
462 
463   /**
464    * @dev Returns whether the given spender can transfer a given token ID
465    * @param spender address of the spender to query
466    * @param tokenId uint256 ID of the token to be transferred
467    * @return bool whether the msg.sender is approved for the given token ID,
468    *  is an operator of the owner, or is the owner of the token
469    */
470   function _isApprovedOrOwner(
471     address spender,
472     uint256 tokenId
473   )
474     internal
475     view
476     returns (bool)
477   {
478     address owner = ownerOf(tokenId);
479     // Disable solium check because of
480     // https://github.com/duaraghav8/Solium/issues/175
481     // solium-disable-next-line operator-whitespace
482     return (
483       spender == owner ||
484       getApproved(tokenId) == spender ||
485       isApprovedForAll(owner, spender)
486     );
487   }
488 
489   /**
490    * @dev Internal function to mint a new token
491    * Reverts if the given token ID already exists
492    * @param to The address that will own the minted token
493    * @param tokenId uint256 ID of the token to be minted by the msg.sender
494    */
495   function _mint(address to, uint256 tokenId) internal {
496     require(to != address(0));
497     _addTokenTo(to, tokenId);
498     emit Transfer(address(0), to, tokenId);
499   }
500 
501   /**
502    * @dev Internal function to burn a specific token
503    * Reverts if the token does not exist
504    * @param tokenId uint256 ID of the token being burned by the msg.sender
505    */
506   function _burn(address owner, uint256 tokenId) internal {
507     _clearApproval(owner, tokenId);
508     _removeTokenFrom(owner, tokenId);
509     emit Transfer(owner, address(0), tokenId);
510   }
511 
512   /**
513    * @dev Internal function to clear current approval of a given token ID
514    * Reverts if the given address is not indeed the owner of the token
515    * @param owner owner of the token
516    * @param tokenId uint256 ID of the token to be transferred
517    */
518   function _clearApproval(address owner, uint256 tokenId) internal {
519     require(ownerOf(tokenId) == owner);
520     if (_tokenApprovals[tokenId] != address(0)) {
521       _tokenApprovals[tokenId] = address(0);
522     }
523   }
524 
525   /**
526    * @dev Internal function to add a token ID to the list of a given address
527    * @param to address representing the new owner of the given token ID
528    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
529    */
530   function _addTokenTo(address to, uint256 tokenId) internal {
531     require(_tokenOwner[tokenId] == address(0));
532     _tokenOwner[tokenId] = to;
533     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
534   }
535 
536   /**
537    * @dev Internal function to remove a token ID from the list of a given address
538    * @param from address representing the previous owner of the given token ID
539    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
540    */
541   function _removeTokenFrom(address from, uint256 tokenId) internal {
542     require(ownerOf(tokenId) == from);
543     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
544     _tokenOwner[tokenId] = address(0);
545   }
546 
547   /**
548    * @dev Internal function to invoke `onERC721Received` on a target address
549    * The call is not executed if the target address is not a contract
550    * @param from address representing the previous owner of the given token ID
551    * @param to target address that will receive the tokens
552    * @param tokenId uint256 ID of the token to be transferred
553    * @param _data bytes optional data to send along with the call
554    * @return whether the call correctly returned the expected magic value
555    */
556   function _checkAndCallSafeTransfer(
557     address from,
558     address to,
559     uint256 tokenId,
560     bytes _data
561   )
562     internal
563     returns (bool)
564   {
565     if (!to.isContract()) {
566       return true;
567     }
568     bytes4 retval = IERC721Receiver(to).onERC721Received(
569       msg.sender, from, tokenId, _data);
570     return (retval == _ERC721_RECEIVED);
571   }
572 }
573 
574 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
575 
576 /**
577  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
578  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
579  */
580 contract IERC721Enumerable is IERC721 {
581   function totalSupply() public view returns (uint256);
582   function tokenOfOwnerByIndex(
583     address owner,
584     uint256 index
585   )
586     public
587     view
588     returns (uint256 tokenId);
589 
590   function tokenByIndex(uint256 index) public view returns (uint256);
591 }
592 
593 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol
594 
595 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
596   // Mapping from owner to list of owned token IDs
597   mapping(address => uint256[]) private _ownedTokens;
598 
599   // Mapping from token ID to index of the owner tokens list
600   mapping(uint256 => uint256) private _ownedTokensIndex;
601 
602   // Array with all token ids, used for enumeration
603   uint256[] private _allTokens;
604 
605   // Mapping from token id to position in the allTokens array
606   mapping(uint256 => uint256) private _allTokensIndex;
607 
608   bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;
609   /**
610    * 0x780e9d63 ===
611    *   bytes4(keccak256('totalSupply()')) ^
612    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
613    *   bytes4(keccak256('tokenByIndex(uint256)'))
614    */
615 
616   /**
617    * @dev Constructor function
618    */
619   constructor() public {
620     // register the supported interface to conform to ERC721 via ERC165
621     _registerInterface(_InterfaceId_ERC721Enumerable);
622   }
623 
624   /**
625    * @dev Gets the token ID at a given index of the tokens list of the requested owner
626    * @param owner address owning the tokens list to be accessed
627    * @param index uint256 representing the index to be accessed of the requested tokens list
628    * @return uint256 token ID at the given index of the tokens list owned by the requested address
629    */
630   function tokenOfOwnerByIndex(
631     address owner,
632     uint256 index
633   )
634     public
635     view
636     returns (uint256)
637   {
638     require(index < balanceOf(owner));
639     return _ownedTokens[owner][index];
640   }
641 
642   /**
643    * @dev Gets the total amount of tokens stored by the contract
644    * @return uint256 representing the total amount of tokens
645    */
646   function totalSupply() public view returns (uint256) {
647     return _allTokens.length;
648   }
649 
650   /**
651    * @dev Gets the token ID at a given index of all the tokens in this contract
652    * Reverts if the index is greater or equal to the total number of tokens
653    * @param index uint256 representing the index to be accessed of the tokens list
654    * @return uint256 token ID at the given index of the tokens list
655    */
656   function tokenByIndex(uint256 index) public view returns (uint256) {
657     require(index < totalSupply());
658     return _allTokens[index];
659   }
660 
661   /**
662    * @dev Internal function to add a token ID to the list of a given address
663    * @param to address representing the new owner of the given token ID
664    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
665    */
666   function _addTokenTo(address to, uint256 tokenId) internal {
667     super._addTokenTo(to, tokenId);
668     uint256 length = _ownedTokens[to].length;
669     _ownedTokens[to].push(tokenId);
670     _ownedTokensIndex[tokenId] = length;
671   }
672 
673   /**
674    * @dev Internal function to remove a token ID from the list of a given address
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
735 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
736 
737 /**
738  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
739  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
740  */
741 contract IERC721Metadata is IERC721 {
742   function name() external view returns (string);
743   function symbol() external view returns (string);
744   function tokenURI(uint256 tokenId) public view returns (string);
745 }
746 
747 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol
748 
749 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
750   // Token name
751   string internal _name;
752 
753   // Token symbol
754   string internal _symbol;
755 
756   // Optional mapping for token URIs
757   mapping(uint256 => string) private _tokenURIs;
758 
759   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
760   /**
761    * 0x5b5e139f ===
762    *   bytes4(keccak256('name()')) ^
763    *   bytes4(keccak256('symbol()')) ^
764    *   bytes4(keccak256('tokenURI(uint256)'))
765    */
766 
767   /**
768    * @dev Constructor function
769    */
770   constructor(string name, string symbol) public {
771     _name = name;
772     _symbol = symbol;
773 
774     // register the supported interfaces to conform to ERC721 via ERC165
775     _registerInterface(InterfaceId_ERC721Metadata);
776   }
777 
778   /**
779    * @dev Gets the token name
780    * @return string representing the token name
781    */
782   function name() external view returns (string) {
783     return _name;
784   }
785 
786   /**
787    * @dev Gets the token symbol
788    * @return string representing the token symbol
789    */
790   function symbol() external view returns (string) {
791     return _symbol;
792   }
793 
794   /**
795    * @dev Returns an URI for a given token ID
796    * Throws if the token ID does not exist. May return an empty string.
797    * @param tokenId uint256 ID of the token to query
798    */
799   function tokenURI(uint256 tokenId) public view returns (string) {
800     require(_exists(tokenId));
801     return _tokenURIs[tokenId];
802   }
803 
804   /**
805    * @dev Internal function to set the token URI for a given token
806    * Reverts if the token ID does not exist
807    * @param tokenId uint256 ID of the token to set its URI
808    * @param uri string URI to assign
809    */
810   function _setTokenURI(uint256 tokenId, string uri) internal {
811     require(_exists(tokenId));
812     _tokenURIs[tokenId] = uri;
813   }
814 
815   /**
816    * @dev Internal function to burn a specific token
817    * Reverts if the token does not exist
818    * @param owner owner of the token to burn
819    * @param tokenId uint256 ID of the token being burned by the msg.sender
820    */
821   function _burn(address owner, uint256 tokenId) internal {
822     super._burn(owner, tokenId);
823 
824     // Clear metadata (if any)
825     if (bytes(_tokenURIs[tokenId]).length != 0) {
826       delete _tokenURIs[tokenId];
827     }
828   }
829 }
830 
831 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol
832 
833 /**
834  * @title Full ERC721 Token
835  * This implementation includes all the required and some optional functionality of the ERC721 standard
836  * Moreover, it includes approve all functionality using operator terminology
837  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
838  */
839 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
840   constructor(string name, string symbol) ERC721Metadata(name, symbol)
841     public
842   {
843   }
844 }
845 
846 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Burnable.sol
847 
848 contract ERC721Burnable is ERC721 {
849   function burn(uint256 tokenId)
850     public
851   {
852     require(_isApprovedOrOwner(msg.sender, tokenId));
853     _burn(ownerOf(tokenId), tokenId);
854   }
855 }
856 
857 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Holder.sol
858 
859 contract ERC721Holder is IERC721Receiver {
860   function onERC721Received(
861     address,
862     address,
863     uint256,
864     bytes
865   )
866     public
867     returns(bytes4)
868   {
869     return this.onERC721Received.selector;
870   }
871 }
872 
873 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
874 
875 /**
876  * @title Ownable
877  * @dev The Ownable contract has an owner address, and provides basic authorization control
878  * functions, this simplifies the implementation of "user permissions".
879  */
880 contract Ownable {
881   address private _owner;
882 
883 
884   event OwnershipRenounced(address indexed previousOwner);
885   event OwnershipTransferred(
886     address indexed previousOwner,
887     address indexed newOwner
888   );
889 
890 
891   /**
892    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
893    * account.
894    */
895   constructor() public {
896     _owner = msg.sender;
897   }
898 
899   /**
900    * @return the address of the owner.
901    */
902   function owner() public view returns(address) {
903     return _owner;
904   }
905 
906   /**
907    * @dev Throws if called by any account other than the owner.
908    */
909   modifier onlyOwner() {
910     require(isOwner());
911     _;
912   }
913 
914   /**
915    * @return true if `msg.sender` is the owner of the contract.
916    */
917   function isOwner() public view returns(bool) {
918     return msg.sender == _owner;
919   }
920 
921   /**
922    * @dev Allows the current owner to relinquish control of the contract.
923    * @notice Renouncing to ownership will leave the contract without an owner.
924    * It will not be possible to call the functions with the `onlyOwner`
925    * modifier anymore.
926    */
927   function renounceOwnership() public onlyOwner {
928     emit OwnershipRenounced(_owner);
929     _owner = address(0);
930   }
931 
932   /**
933    * @dev Allows the current owner to transfer control of the contract to a newOwner.
934    * @param newOwner The address to transfer ownership to.
935    */
936   function transferOwnership(address newOwner) public onlyOwner {
937     _transferOwnership(newOwner);
938   }
939 
940   /**
941    * @dev Transfers control of the contract to a newOwner.
942    * @param newOwner The address to transfer ownership to.
943    */
944   function _transferOwnership(address newOwner) internal {
945     require(newOwner != address(0));
946     emit OwnershipTransferred(_owner, newOwner);
947     _owner = newOwner;
948   }
949 }
950 
951 // File: contracts/KumexToken.sol
952 
953 contract KumexToken is ERC721Full, ERC721Burnable, ERC721Holder, Ownable {
954   constructor() public
955     ERC721Full("KumexToken", "MEX")
956   {
957   }
958 
959   struct Paper {
960     string ipfsHash;
961     address publisher;
962   }
963 
964   Paper[] public papers;
965   mapping (string => uint256) ipfsHashToTokenId;
966 
967   uint128 private paperFee = 0 ether;
968 
969   function mintPaper (
970     string _ipfsHash,
971     string _tokenURI
972   )
973     external
974     payable
975     returns (bool)
976   {
977     require(msg.value == paperFee);
978     require(msg.sender != address(0));
979     require(ipfsHashToTokenId[_ipfsHash] == 0);
980 
981     Paper memory _paper = Paper({ipfsHash: _ipfsHash, publisher: msg.sender});
982     uint256 tokenId = papers.push(_paper) - 1;
983     ipfsHashToTokenId[_ipfsHash] = tokenId;
984     _mint(msg.sender, tokenId);
985     _setTokenURI(tokenId, _tokenURI);
986     return true;
987   }
988 
989   function setPaperFee(uint128 _fee) external onlyOwner {
990     paperFee = _fee;
991   }
992 
993   function getPaperFee() external view returns (uint128) {
994     return paperFee;
995   }
996 
997   function getBalanceContract() external constant returns(uint){
998     return address(this).balance;
999   }
1000 
1001   function withdraw(uint256 _amount) external onlyOwner {
1002     require(_amount <= address(this).balance);
1003 
1004     msg.sender.transfer(_amount);
1005   }
1006 }