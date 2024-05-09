1 pragma solidity 0.4.24;
2 
3 // File: contracts/lib/openzeppelin-solidity/contracts/introspection/IERC165.sol
4 
5 /**
6  * @title IERC165
7  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
8  */
9 interface IERC165 {
10 
11   /**
12    * @notice Query if a contract implements an interface
13    * @param interfaceId The interface identifier, as specified in ERC-165
14    * @dev Interface identification is specified in ERC-165. This function
15    * uses less than 30,000 gas.
16    */
17   function supportsInterface(bytes4 interfaceId)
18     external
19     view
20     returns (bool);
21 }
22 
23 // File: contracts/lib/openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
24 
25 /**
26  * @title ERC721 Non-Fungible Token Standard basic interface
27  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
28  */
29 contract IERC721 is IERC165 {
30 
31   event Transfer(
32     address indexed from,
33     address indexed to,
34     uint256 indexed tokenId
35   );
36   event Approval(
37     address indexed owner,
38     address indexed approved,
39     uint256 indexed tokenId
40   );
41   event ApprovalForAll(
42     address indexed owner,
43     address indexed operator,
44     bool approved
45   );
46 
47   function balanceOf(address owner) public view returns (uint256 balance);
48   function ownerOf(uint256 tokenId) public view returns (address owner);
49 
50   function approve(address to, uint256 tokenId) public;
51   function getApproved(uint256 tokenId)
52     public view returns (address operator);
53 
54   function setApprovalForAll(address operator, bool _approved) public;
55   function isApprovedForAll(address owner, address operator)
56     public view returns (bool);
57 
58   function transferFrom(address from, address to, uint256 tokenId) public;
59   function safeTransferFrom(address from, address to, uint256 tokenId)
60     public;
61 
62   function safeTransferFrom(
63     address from,
64     address to,
65     uint256 tokenId,
66     bytes data
67   )
68     public;
69 }
70 
71 // File: contracts/lib/openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
72 
73 /**
74  * @title ERC721 token receiver interface
75  * @dev Interface for any contract that wants to support safeTransfers
76  * from ERC721 asset contracts.
77  */
78 contract IERC721Receiver {
79   /**
80    * @notice Handle the receipt of an NFT
81    * @dev The ERC721 smart contract calls this function on the recipient
82    * after a `safeTransfer`. This function MUST return the function selector,
83    * otherwise the caller will revert the transaction. The selector to be
84    * returned can be obtained as `this.onERC721Received.selector`. This
85    * function MAY throw to revert and reject the transfer.
86    * Note: the ERC721 contract address is always the message sender.
87    * @param operator The address which called `safeTransferFrom` function
88    * @param from The address which previously owned the token
89    * @param tokenId The NFT identifier which is being transferred
90    * @param data Additional data with no specified format
91    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
92    */
93   function onERC721Received(
94     address operator,
95     address from,
96     uint256 tokenId,
97     bytes data
98   )
99     public
100     returns(bytes4);
101 }
102 
103 // File: contracts/lib/openzeppelin-solidity/contracts/math/SafeMath.sol
104 
105 /**
106  * @title SafeMath
107  * @dev Math operations with safety checks that revert on error
108  */
109 library SafeMath {
110 
111   /**
112   * @dev Multiplies two numbers, reverts on overflow.
113   */
114   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
115     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
116     // benefit is lost if 'b' is also tested.
117     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
118     if (a == 0) {
119       return 0;
120     }
121 
122     uint256 c = a * b;
123     require(c / a == b);
124 
125     return c;
126   }
127 
128   /**
129   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
130   */
131   function div(uint256 a, uint256 b) internal pure returns (uint256) {
132     require(b > 0); // Solidity only automatically asserts when dividing by 0
133     uint256 c = a / b;
134     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
135 
136     return c;
137   }
138 
139   /**
140   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
141   */
142   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
143     require(b <= a);
144     uint256 c = a - b;
145 
146     return c;
147   }
148 
149   /**
150   * @dev Adds two numbers, reverts on overflow.
151   */
152   function add(uint256 a, uint256 b) internal pure returns (uint256) {
153     uint256 c = a + b;
154     require(c >= a);
155 
156     return c;
157   }
158 
159   /**
160   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
161   * reverts when dividing by zero.
162   */
163   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
164     require(b != 0);
165     return a % b;
166   }
167 }
168 
169 // File: contracts/lib/openzeppelin-solidity/contracts/utils/Address.sol
170 
171 /**
172  * Utility library of inline functions on addresses
173  */
174 library Address {
175 
176   /**
177    * Returns whether the target address is a contract
178    * @dev This function will return false if invoked during the constructor of a contract,
179    * as the code is not actually created until after the constructor finishes.
180    * @param account address of the account to check
181    * @return whether the target address is a contract
182    */
183   function isContract(address account) internal view returns (bool) {
184     uint256 size;
185     // XXX Currently there is no better way to check if there is a contract in an address
186     // than to check the size of the code at that address.
187     // See https://ethereum.stackexchange.com/a/14016/36603
188     // for more details about how this works.
189     // TODO Check this again before the Serenity release, because all addresses will be
190     // contracts then.
191     // solium-disable-next-line security/no-inline-assembly
192     assembly { size := extcodesize(account) }
193     return size > 0;
194   }
195 
196 }
197 
198 // File: contracts/lib/openzeppelin-solidity/contracts/introspection/ERC165.sol
199 
200 /**
201  * @title ERC165
202  * @author Matt Condon (@shrugs)
203  * @dev Implements ERC165 using a lookup table.
204  */
205 contract ERC165 is IERC165 {
206 
207   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
208   /**
209    * 0x01ffc9a7 ===
210    *   bytes4(keccak256('supportsInterface(bytes4)'))
211    */
212 
213   /**
214    * @dev a mapping of interface id to whether or not it's supported
215    */
216   mapping(bytes4 => bool) internal _supportedInterfaces;
217 
218   /**
219    * @dev A contract implementing SupportsInterfaceWithLookup
220    * implement ERC165 itself
221    */
222   constructor()
223     public
224   {
225     _registerInterface(_InterfaceId_ERC165);
226   }
227 
228   /**
229    * @dev implement supportsInterface(bytes4) using a lookup table
230    */
231   function supportsInterface(bytes4 interfaceId)
232     external
233     view
234     returns (bool)
235   {
236     return _supportedInterfaces[interfaceId];
237   }
238 
239   /**
240    * @dev private method for registering an interface
241    */
242   function _registerInterface(bytes4 interfaceId)
243     internal
244   {
245     require(interfaceId != 0xffffffff);
246     _supportedInterfaces[interfaceId] = true;
247   }
248 }
249 
250 // File: contracts/lib/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
251 
252 /**
253  * @title ERC721 Non-Fungible Token Standard basic implementation
254  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
255  */
256 contract ERC721 is ERC165, IERC721 {
257 
258   using SafeMath for uint256;
259   using Address for address;
260 
261   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
262   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
263   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
264 
265   // Mapping from token ID to owner
266   mapping (uint256 => address) private _tokenOwner;
267 
268   // Mapping from token ID to approved address
269   mapping (uint256 => address) private _tokenApprovals;
270 
271   // Mapping from owner to number of owned token
272   mapping (address => uint256) private _ownedTokensCount;
273 
274   // Mapping from owner to operator approvals
275   mapping (address => mapping (address => bool)) private _operatorApprovals;
276 
277   bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
278   /*
279    * 0x80ac58cd ===
280    *   bytes4(keccak256('balanceOf(address)')) ^
281    *   bytes4(keccak256('ownerOf(uint256)')) ^
282    *   bytes4(keccak256('approve(address,uint256)')) ^
283    *   bytes4(keccak256('getApproved(uint256)')) ^
284    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
285    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
286    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
287    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
288    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
289    */
290 
291   constructor()
292     public
293   {
294     // register the supported interfaces to conform to ERC721 via ERC165
295     _registerInterface(_InterfaceId_ERC721);
296   }
297 
298   /**
299    * @dev Gets the balance of the specified address
300    * @param owner address to query the balance of
301    * @return uint256 representing the amount owned by the passed address
302    */
303   function balanceOf(address owner) public view returns (uint256) {
304     require(owner != address(0));
305     return _ownedTokensCount[owner];
306   }
307 
308   /**
309    * @dev Gets the owner of the specified token ID
310    * @param tokenId uint256 ID of the token to query the owner of
311    * @return owner address currently marked as the owner of the given token ID
312    */
313   function ownerOf(uint256 tokenId) public view returns (address) {
314     address owner = _tokenOwner[tokenId];
315     require(owner != address(0));
316     return owner;
317   }
318 
319   /**
320    * @dev Approves another address to transfer the given token ID
321    * The zero address indicates there is no approved address.
322    * There can only be one approved address per token at a given time.
323    * Can only be called by the token owner or an approved operator.
324    * @param to address to be approved for the given token ID
325    * @param tokenId uint256 ID of the token to be approved
326    */
327   function approve(address to, uint256 tokenId) public {
328     address owner = ownerOf(tokenId);
329     require(to != owner);
330     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
331 
332     _tokenApprovals[tokenId] = to;
333     emit Approval(owner, to, tokenId);
334   }
335 
336   /**
337    * @dev Gets the approved address for a token ID, or zero if no address set
338    * Reverts if the token ID does not exist.
339    * @param tokenId uint256 ID of the token to query the approval of
340    * @return address currently approved for the given token ID
341    */
342   function getApproved(uint256 tokenId) public view returns (address) {
343     require(_exists(tokenId));
344     return _tokenApprovals[tokenId];
345   }
346 
347   /**
348    * @dev Sets or unsets the approval of a given operator
349    * An operator is allowed to transfer all tokens of the sender on their behalf
350    * @param to operator address to set the approval
351    * @param approved representing the status of the approval to be set
352    */
353   function setApprovalForAll(address to, bool approved) public {
354     require(to != msg.sender);
355     _operatorApprovals[msg.sender][to] = approved;
356     emit ApprovalForAll(msg.sender, to, approved);
357   }
358 
359   /**
360    * @dev Tells whether an operator is approved by a given owner
361    * @param owner owner address which you want to query the approval of
362    * @param operator operator address which you want to query the approval of
363    * @return bool whether the given operator is approved by the given owner
364    */
365   function isApprovedForAll(
366     address owner,
367     address operator
368   )
369     public
370     view
371     returns (bool)
372   {
373     return _operatorApprovals[owner][operator];
374   }
375 
376   /**
377    * @dev Transfers the ownership of a given token ID to another address
378    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
379    * Requires the msg sender to be the owner, approved, or operator
380    * @param from current owner of the token
381    * @param to address to receive the ownership of the given token ID
382    * @param tokenId uint256 ID of the token to be transferred
383   */
384   function transferFrom(
385     address from,
386     address to,
387     uint256 tokenId
388   )
389     public
390   {
391     require(_isApprovedOrOwner(msg.sender, tokenId));
392     require(to != address(0));
393 
394     _clearApproval(from, tokenId);
395     _removeTokenFrom(from, tokenId);
396     _addTokenTo(to, tokenId);
397 
398     emit Transfer(from, to, tokenId);
399   }
400 
401   /**
402    * @dev Safely transfers the ownership of a given token ID to another address
403    * If the target address is a contract, it must implement `onERC721Received`,
404    * which is called upon a safe transfer, and return the magic value
405    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
406    * the transfer is reverted.
407    *
408    * Requires the msg sender to be the owner, approved, or operator
409    * @param from current owner of the token
410    * @param to address to receive the ownership of the given token ID
411    * @param tokenId uint256 ID of the token to be transferred
412   */
413   function safeTransferFrom(
414     address from,
415     address to,
416     uint256 tokenId
417   )
418     public
419   {
420     // solium-disable-next-line arg-overflow
421     safeTransferFrom(from, to, tokenId, "");
422   }
423 
424   /**
425    * @dev Safely transfers the ownership of a given token ID to another address
426    * If the target address is a contract, it must implement `onERC721Received`,
427    * which is called upon a safe transfer, and return the magic value
428    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
429    * the transfer is reverted.
430    * Requires the msg sender to be the owner, approved, or operator
431    * @param from current owner of the token
432    * @param to address to receive the ownership of the given token ID
433    * @param tokenId uint256 ID of the token to be transferred
434    * @param _data bytes data to send along with a safe transfer check
435    */
436   function safeTransferFrom(
437     address from,
438     address to,
439     uint256 tokenId,
440     bytes _data
441   )
442     public
443   {
444     transferFrom(from, to, tokenId);
445     // solium-disable-next-line arg-overflow
446     require(_checkAndCallSafeTransfer(from, to, tokenId, _data));
447   }
448 
449   /**
450    * @dev Returns whether the specified token exists
451    * @param tokenId uint256 ID of the token to query the existence of
452    * @return whether the token exists
453    */
454   function _exists(uint256 tokenId) internal view returns (bool) {
455     address owner = _tokenOwner[tokenId];
456     return owner != address(0);
457   }
458 
459   /**
460    * @dev Returns whether the given spender can transfer a given token ID
461    * @param spender address of the spender to query
462    * @param tokenId uint256 ID of the token to be transferred
463    * @return bool whether the msg.sender is approved for the given token ID,
464    *  is an operator of the owner, or is the owner of the token
465    */
466   function _isApprovedOrOwner(
467     address spender,
468     uint256 tokenId
469   )
470     internal
471     view
472     returns (bool)
473   {
474     address owner = ownerOf(tokenId);
475     // Disable solium check because of
476     // https://github.com/duaraghav8/Solium/issues/175
477     // solium-disable-next-line operator-whitespace
478     return (
479       spender == owner ||
480       getApproved(tokenId) == spender ||
481       isApprovedForAll(owner, spender)
482     );
483   }
484 
485   /**
486    * @dev Internal function to mint a new token
487    * Reverts if the given token ID already exists
488    * @param to The address that will own the minted token
489    * @param tokenId uint256 ID of the token to be minted by the msg.sender
490    */
491   function _mint(address to, uint256 tokenId) internal {
492     require(to != address(0));
493     _addTokenTo(to, tokenId);
494     emit Transfer(address(0), to, tokenId);
495   }
496 
497   /**
498    * @dev Internal function to burn a specific token
499    * Reverts if the token does not exist
500    * @param tokenId uint256 ID of the token being burned by the msg.sender
501    */
502   function _burn(address owner, uint256 tokenId) internal {
503     _clearApproval(owner, tokenId);
504     _removeTokenFrom(owner, tokenId);
505     emit Transfer(owner, address(0), tokenId);
506   }
507 
508   /**
509    * @dev Internal function to clear current approval of a given token ID
510    * Reverts if the given address is not indeed the owner of the token
511    * @param owner owner of the token
512    * @param tokenId uint256 ID of the token to be transferred
513    */
514   function _clearApproval(address owner, uint256 tokenId) internal {
515     require(ownerOf(tokenId) == owner);
516     if (_tokenApprovals[tokenId] != address(0)) {
517       _tokenApprovals[tokenId] = address(0);
518     }
519   }
520 
521   /**
522    * @dev Internal function to add a token ID to the list of a given address
523    * @param to address representing the new owner of the given token ID
524    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
525    */
526   function _addTokenTo(address to, uint256 tokenId) internal {
527     require(_tokenOwner[tokenId] == address(0));
528     _tokenOwner[tokenId] = to;
529     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
530   }
531 
532   /**
533    * @dev Internal function to remove a token ID from the list of a given address
534    * @param from address representing the previous owner of the given token ID
535    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
536    */
537   function _removeTokenFrom(address from, uint256 tokenId) internal {
538     require(ownerOf(tokenId) == from);
539     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
540     _tokenOwner[tokenId] = address(0);
541   }
542 
543   /**
544    * @dev Internal function to invoke `onERC721Received` on a target address
545    * The call is not executed if the target address is not a contract
546    * @param from address representing the previous owner of the given token ID
547    * @param to target address that will receive the tokens
548    * @param tokenId uint256 ID of the token to be transferred
549    * @param _data bytes optional data to send along with the call
550    * @return whether the call correctly returned the expected magic value
551    */
552   function _checkAndCallSafeTransfer(
553     address from,
554     address to,
555     uint256 tokenId,
556     bytes _data
557   )
558     internal
559     returns (bool)
560   {
561     if (!to.isContract()) {
562       return true;
563     }
564     bytes4 retval = IERC721Receiver(to).onERC721Received(
565       msg.sender, from, tokenId, _data);
566     return (retval == _ERC721_RECEIVED);
567   }
568 }
569 
570 // File: contracts/lib/openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
571 
572 /**
573  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
574  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
575  */
576 contract IERC721Enumerable is IERC721 {
577   function totalSupply() public view returns (uint256);
578   function tokenOfOwnerByIndex(
579     address owner,
580     uint256 index
581   )
582     public
583     view
584     returns (uint256 tokenId);
585 
586   function tokenByIndex(uint256 index) public view returns (uint256);
587 }
588 
589 // File: contracts/lib/openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol
590 
591 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
592   // Mapping from owner to list of owned token IDs
593   mapping(address => uint256[]) private _ownedTokens;
594 
595   // Mapping from token ID to index of the owner tokens list
596   mapping(uint256 => uint256) private _ownedTokensIndex;
597 
598   // Array with all token ids, used for enumeration
599   uint256[] private _allTokens;
600 
601   // Mapping from token id to position in the allTokens array
602   mapping(uint256 => uint256) private _allTokensIndex;
603 
604   bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;
605   /**
606    * 0x780e9d63 ===
607    *   bytes4(keccak256('totalSupply()')) ^
608    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
609    *   bytes4(keccak256('tokenByIndex(uint256)'))
610    */
611 
612   /**
613    * @dev Constructor function
614    */
615   constructor() public {
616     // register the supported interface to conform to ERC721 via ERC165
617     _registerInterface(_InterfaceId_ERC721Enumerable);
618   }
619 
620   /**
621    * @dev Gets the token ID at a given index of the tokens list of the requested owner
622    * @param owner address owning the tokens list to be accessed
623    * @param index uint256 representing the index to be accessed of the requested tokens list
624    * @return uint256 token ID at the given index of the tokens list owned by the requested address
625    */
626   function tokenOfOwnerByIndex(
627     address owner,
628     uint256 index
629   )
630     public
631     view
632     returns (uint256)
633   {
634     require(index < balanceOf(owner));
635     return _ownedTokens[owner][index];
636   }
637 
638   /**
639    * @dev Gets the total amount of tokens stored by the contract
640    * @return uint256 representing the total amount of tokens
641    */
642   function totalSupply() public view returns (uint256) {
643     return _allTokens.length;
644   }
645 
646   /**
647    * @dev Gets the token ID at a given index of all the tokens in this contract
648    * Reverts if the index is greater or equal to the total number of tokens
649    * @param index uint256 representing the index to be accessed of the tokens list
650    * @return uint256 token ID at the given index of the tokens list
651    */
652   function tokenByIndex(uint256 index) public view returns (uint256) {
653     require(index < totalSupply());
654     return _allTokens[index];
655   }
656 
657   /**
658    * @dev Internal function to add a token ID to the list of a given address
659    * @param to address representing the new owner of the given token ID
660    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
661    */
662   function _addTokenTo(address to, uint256 tokenId) internal {
663     super._addTokenTo(to, tokenId);
664     uint256 length = _ownedTokens[to].length;
665     _ownedTokens[to].push(tokenId);
666     _ownedTokensIndex[tokenId] = length;
667   }
668 
669   /**
670    * @dev Internal function to remove a token ID from the list of a given address
671    * @param from address representing the previous owner of the given token ID
672    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
673    */
674   function _removeTokenFrom(address from, uint256 tokenId) internal {
675     super._removeTokenFrom(from, tokenId);
676 
677     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
678     // then delete the last slot.
679     uint256 tokenIndex = _ownedTokensIndex[tokenId];
680     uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
681     uint256 lastToken = _ownedTokens[from][lastTokenIndex];
682 
683     _ownedTokens[from][tokenIndex] = lastToken;
684     // This also deletes the contents at the last position of the array
685     _ownedTokens[from].length--;
686 
687     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
688     // be zero. Then we can make sure that we will remove tokenId from the ownedTokens list since we are first swapping
689     // the lastToken to the first position, and then dropping the element placed in the last position of the list
690 
691     _ownedTokensIndex[tokenId] = 0;
692     _ownedTokensIndex[lastToken] = tokenIndex;
693   }
694 
695   /**
696    * @dev Internal function to mint a new token
697    * Reverts if the given token ID already exists
698    * @param to address the beneficiary that will own the minted token
699    * @param tokenId uint256 ID of the token to be minted by the msg.sender
700    */
701   function _mint(address to, uint256 tokenId) internal {
702     super._mint(to, tokenId);
703 
704     _allTokensIndex[tokenId] = _allTokens.length;
705     _allTokens.push(tokenId);
706   }
707 
708   /**
709    * @dev Internal function to burn a specific token
710    * Reverts if the token does not exist
711    * @param owner owner of the token to burn
712    * @param tokenId uint256 ID of the token being burned by the msg.sender
713    */
714   function _burn(address owner, uint256 tokenId) internal {
715     super._burn(owner, tokenId);
716 
717     // Reorg all tokens array
718     uint256 tokenIndex = _allTokensIndex[tokenId];
719     uint256 lastTokenIndex = _allTokens.length.sub(1);
720     uint256 lastToken = _allTokens[lastTokenIndex];
721 
722     _allTokens[tokenIndex] = lastToken;
723     _allTokens[lastTokenIndex] = 0;
724 
725     _allTokens.length--;
726     _allTokensIndex[tokenId] = 0;
727     _allTokensIndex[lastToken] = tokenIndex;
728   }
729 }
730 
731 // File: contracts/lib/openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
732 
733 /**
734  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
735  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
736  */
737 contract IERC721Metadata is IERC721 {
738   function name() external view returns (string);
739   function symbol() external view returns (string);
740   function tokenURI(uint256 tokenId) public view returns (string);
741 }
742 
743 // File: contracts/lib/openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol
744 
745 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
746   // Token name
747   string internal _name;
748 
749   // Token symbol
750   string internal _symbol;
751 
752   // Optional mapping for token URIs
753   mapping(uint256 => string) private _tokenURIs;
754 
755   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
756   /**
757    * 0x5b5e139f ===
758    *   bytes4(keccak256('name()')) ^
759    *   bytes4(keccak256('symbol()')) ^
760    *   bytes4(keccak256('tokenURI(uint256)'))
761    */
762 
763   /**
764    * @dev Constructor function
765    */
766   constructor(string name, string symbol) public {
767     _name = name;
768     _symbol = symbol;
769 
770     // register the supported interfaces to conform to ERC721 via ERC165
771     _registerInterface(InterfaceId_ERC721Metadata);
772   }
773 
774   /**
775    * @dev Gets the token name
776    * @return string representing the token name
777    */
778   function name() external view returns (string) {
779     return _name;
780   }
781 
782   /**
783    * @dev Gets the token symbol
784    * @return string representing the token symbol
785    */
786   function symbol() external view returns (string) {
787     return _symbol;
788   }
789 
790   /**
791    * @dev Returns an URI for a given token ID
792    * Throws if the token ID does not exist. May return an empty string.
793    * @param tokenId uint256 ID of the token to query
794    */
795   function tokenURI(uint256 tokenId) public view returns (string) {
796     require(_exists(tokenId));
797     return _tokenURIs[tokenId];
798   }
799 
800   /**
801    * @dev Internal function to set the token URI for a given token
802    * Reverts if the token ID does not exist
803    * @param tokenId uint256 ID of the token to set its URI
804    * @param uri string URI to assign
805    */
806   function _setTokenURI(uint256 tokenId, string uri) internal {
807     require(_exists(tokenId));
808     _tokenURIs[tokenId] = uri;
809   }
810 
811   /**
812    * @dev Internal function to burn a specific token
813    * Reverts if the token does not exist
814    * @param owner owner of the token to burn
815    * @param tokenId uint256 ID of the token being burned by the msg.sender
816    */
817   function _burn(address owner, uint256 tokenId) internal {
818     super._burn(owner, tokenId);
819 
820     // Clear metadata (if any)
821     if (bytes(_tokenURIs[tokenId]).length != 0) {
822       delete _tokenURIs[tokenId];
823     }
824   }
825 }
826 
827 // File: contracts/lib/openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol
828 
829 /**
830  * @title Full ERC721 Token
831  * This implementation includes all the required and some optional functionality of the ERC721 standard
832  * Moreover, it includes approve all functionality using operator terminology
833  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
834  */
835 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
836   constructor(string name, string symbol) ERC721Metadata(name, symbol)
837     public
838   {
839   }
840 }
841 
842 // File: contracts/lib/openzeppelin-solidity/contracts/access/Roles.sol
843 
844 /**
845  * @title Roles
846  * @dev Library for managing addresses assigned to a Role.
847  */
848 library Roles {
849   struct Role {
850     mapping (address => bool) bearer;
851   }
852 
853   /**
854    * @dev give an account access to this role
855    */
856   function add(Role storage role, address account) internal {
857     require(account != address(0));
858     role.bearer[account] = true;
859   }
860 
861   /**
862    * @dev remove an account's access to this role
863    */
864   function remove(Role storage role, address account) internal {
865     require(account != address(0));
866     role.bearer[account] = false;
867   }
868 
869   /**
870    * @dev check if an account has this role
871    * @return bool
872    */
873   function has(Role storage role, address account)
874     internal
875     view
876     returns (bool)
877   {
878     require(account != address(0));
879     return role.bearer[account];
880   }
881 }
882 
883 // File: contracts/lib/openzeppelin-solidity/contracts/access/roles/MinterRole.sol
884 
885 contract MinterRole {
886   using Roles for Roles.Role;
887 
888   event MinterAdded(address indexed account);
889   event MinterRemoved(address indexed account);
890 
891   Roles.Role private minters;
892 
893   constructor() public {
894     minters.add(msg.sender);
895   }
896 
897   modifier onlyMinter() {
898     require(isMinter(msg.sender));
899     _;
900   }
901 
902   function isMinter(address account) public view returns (bool) {
903     return minters.has(account);
904   }
905 
906   function addMinter(address account) public onlyMinter {
907     minters.add(account);
908     emit MinterAdded(account);
909   }
910 
911   function renounceMinter() public {
912     minters.remove(msg.sender);
913   }
914 
915   function _removeMinter(address account) internal {
916     minters.remove(account);
917     emit MinterRemoved(account);
918   }
919 }
920 
921 // File: contracts/lib/openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol
922 
923 /**
924  * @title ERC721Mintable
925  * @dev ERC721 minting logic
926  */
927 contract ERC721Mintable is ERC721Full, MinterRole {
928   event MintingFinished();
929 
930   bool private _mintingFinished = false;
931 
932   modifier onlyBeforeMintingFinished() {
933     require(!_mintingFinished);
934     _;
935   }
936 
937   /**
938    * @return true if the minting is finished.
939    */
940   function mintingFinished() public view returns(bool) {
941     return _mintingFinished;
942   }
943 
944   /**
945    * @dev Function to mint tokens
946    * @param to The address that will receive the minted tokens.
947    * @param tokenId The token id to mint.
948    * @return A boolean that indicates if the operation was successful.
949    */
950   function mint(
951     address to,
952     uint256 tokenId
953   )
954     public
955     onlyMinter
956     onlyBeforeMintingFinished
957     returns (bool)
958   {
959     _mint(to, tokenId);
960     return true;
961   }
962 
963   function mintWithTokenURI(
964     address to,
965     uint256 tokenId,
966     string tokenURI
967   )
968     public
969     onlyMinter
970     onlyBeforeMintingFinished
971     returns (bool)
972   {
973     mint(to, tokenId);
974     _setTokenURI(tokenId, tokenURI);
975     return true;
976   }
977 
978   /**
979    * @dev Function to stop minting new tokens.
980    * @return True if the operation was successful.
981    */
982   function finishMinting()
983     public
984     onlyMinter
985     onlyBeforeMintingFinished
986     returns (bool)
987   {
988     _mintingFinished = true;
989     emit MintingFinished();
990     return true;
991   }
992 }
993 
994 // File: contracts/lib/openzeppelin-solidity/contracts/access/roles/PauserRole.sol
995 
996 contract PauserRole {
997   using Roles for Roles.Role;
998 
999   event PauserAdded(address indexed account);
1000   event PauserRemoved(address indexed account);
1001 
1002   Roles.Role private pausers;
1003 
1004   constructor() public {
1005     pausers.add(msg.sender);
1006   }
1007 
1008   modifier onlyPauser() {
1009     require(isPauser(msg.sender));
1010     _;
1011   }
1012 
1013   function isPauser(address account) public view returns (bool) {
1014     return pausers.has(account);
1015   }
1016 
1017   function addPauser(address account) public onlyPauser {
1018     pausers.add(account);
1019     emit PauserAdded(account);
1020   }
1021 
1022   function renouncePauser() public {
1023     pausers.remove(msg.sender);
1024   }
1025 
1026   function _removePauser(address account) internal {
1027     pausers.remove(account);
1028     emit PauserRemoved(account);
1029   }
1030 }
1031 
1032 // File: contracts/lib/openzeppelin-solidity/contracts/lifecycle/Pausable.sol
1033 
1034 /**
1035  * @title Pausable
1036  * @dev Base contract which allows children to implement an emergency stop mechanism.
1037  */
1038 contract Pausable is PauserRole {
1039   event Paused();
1040   event Unpaused();
1041 
1042   bool private _paused = false;
1043 
1044 
1045   /**
1046    * @return true if the contract is paused, false otherwise.
1047    */
1048   function paused() public view returns(bool) {
1049     return _paused;
1050   }
1051 
1052   /**
1053    * @dev Modifier to make a function callable only when the contract is not paused.
1054    */
1055   modifier whenNotPaused() {
1056     require(!_paused);
1057     _;
1058   }
1059 
1060   /**
1061    * @dev Modifier to make a function callable only when the contract is paused.
1062    */
1063   modifier whenPaused() {
1064     require(_paused);
1065     _;
1066   }
1067 
1068   /**
1069    * @dev called by the owner to pause, triggers stopped state
1070    */
1071   function pause() public onlyPauser whenNotPaused {
1072     _paused = true;
1073     emit Paused();
1074   }
1075 
1076   /**
1077    * @dev called by the owner to unpause, returns to normal state
1078    */
1079   function unpause() public onlyPauser whenPaused {
1080     _paused = false;
1081     emit Unpaused();
1082   }
1083 }
1084 
1085 // File: contracts/lib/openzeppelin-solidity/contracts/token/ERC721/ERC721Pausable.sol
1086 
1087 /**
1088  * @title ERC721 Non-Fungible Pausable token
1089  * @dev ERC721 modified with pausable transfers.
1090  **/
1091 contract ERC721Pausable is ERC721, Pausable {
1092   function approve(
1093     address to,
1094     uint256 tokenId
1095   )
1096     public
1097     whenNotPaused
1098   {
1099     super.approve(to, tokenId);
1100   }
1101 
1102   function setApprovalForAll(
1103     address to,
1104     bool approved
1105   )
1106     public
1107     whenNotPaused
1108   {
1109     super.setApprovalForAll(to, approved);
1110   }
1111 
1112   function transferFrom(
1113     address from,
1114     address to,
1115     uint256 tokenId
1116   )
1117     public
1118     whenNotPaused
1119   {
1120     super.transferFrom(from, to, tokenId);
1121   }
1122 }
1123 
1124 // File: contracts/HeroAsset.sol
1125 
1126 contract HeroAsset is ERC721Mintable, ERC721Pausable {
1127 
1128     uint16 public constant HERO_TYPE_OFFSET = 10000;
1129 
1130     string public tokenURIPrefix = "https://www.mycryptoheroes.net/metadata/hero/";
1131     mapping(uint16 => uint16) private heroTypeToSupplyLimit;
1132 
1133     constructor() public ERC721Full("MyCryptoHeroes:Hero", "MCHH") {}
1134 
1135     function setSupplyLimit(uint16 _heroType, uint16 _supplyLimit) external onlyMinter {
1136         require(heroTypeToSupplyLimit[_heroType] == 0 || _supplyLimit < heroTypeToSupplyLimit[_heroType],
1137             "_supplyLimit is bigger");
1138         heroTypeToSupplyLimit[_heroType] = _supplyLimit;
1139     }
1140 
1141     function setTokenURIPrefix(string _tokenURIPrefix) external onlyMinter {
1142         tokenURIPrefix = _tokenURIPrefix;
1143     }
1144 
1145     function getSupplyLimit(uint16 _heroType) public view returns (uint16) {
1146         return heroTypeToSupplyLimit[_heroType];
1147     }
1148 
1149     function mintHeroAsset(address _owner, uint256 _tokenId) public onlyMinter {
1150         uint16 _heroType = uint16(_tokenId / HERO_TYPE_OFFSET);
1151         uint16 _heroTypeIndex = uint16(_tokenId % HERO_TYPE_OFFSET) - 1;
1152         require(_heroTypeIndex < heroTypeToSupplyLimit[_heroType], "supply over");
1153         _mint(_owner, _tokenId);
1154     }
1155 
1156     function tokenURI(uint256 tokenId) public view returns (string) {
1157         bytes32 tokenIdBytes;
1158         if (tokenId == 0) {
1159             tokenIdBytes = "0";
1160         } else {
1161             uint256 value = tokenId;
1162             while (value > 0) {
1163                 tokenIdBytes = bytes32(uint256(tokenIdBytes) / (2 ** 8));
1164                 tokenIdBytes |= bytes32(((value % 10) + 48) * 2 ** (8 * 31));
1165                 value /= 10;
1166             }
1167         }
1168 
1169         bytes memory prefixBytes = bytes(tokenURIPrefix);
1170         bytes memory tokenURIBytes = new bytes(prefixBytes.length + tokenIdBytes.length);
1171 
1172         uint8 i;
1173         uint8 index = 0;
1174         
1175         for (i = 0; i < prefixBytes.length; i++) {
1176             tokenURIBytes[index] = prefixBytes[i];
1177             index++;
1178         }
1179         
1180         for (i = 0; i < tokenIdBytes.length; i++) {
1181             tokenURIBytes[index] = tokenIdBytes[i];
1182             index++;
1183         }
1184         
1185         return string(tokenURIBytes);
1186     }
1187 
1188 }
1189 
1190 // File: contracts/lib/openzeppelin-solidity/contracts/ownership/Ownable.sol
1191 
1192 /**
1193  * @title Ownable
1194  * @dev The Ownable contract has an owner address, and provides basic authorization control
1195  * functions, this simplifies the implementation of "user permissions".
1196  */
1197 contract Ownable {
1198   address private _owner;
1199 
1200 
1201   event OwnershipRenounced(address indexed previousOwner);
1202   event OwnershipTransferred(
1203     address indexed previousOwner,
1204     address indexed newOwner
1205   );
1206 
1207 
1208   /**
1209    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1210    * account.
1211    */
1212   constructor() public {
1213     _owner = msg.sender;
1214   }
1215 
1216   /**
1217    * @return the address of the owner.
1218    */
1219   function owner() public view returns(address) {
1220     return _owner;
1221   }
1222 
1223   /**
1224    * @dev Throws if called by any account other than the owner.
1225    */
1226   modifier onlyOwner() {
1227     require(isOwner());
1228     _;
1229   }
1230 
1231   /**
1232    * @return true if `msg.sender` is the owner of the contract.
1233    */
1234   function isOwner() public view returns(bool) {
1235     return msg.sender == _owner;
1236   }
1237 
1238   /**
1239    * @dev Allows the current owner to relinquish control of the contract.
1240    * @notice Renouncing to ownership will leave the contract without an owner.
1241    * It will not be possible to call the functions with the `onlyOwner`
1242    * modifier anymore.
1243    */
1244   function renounceOwnership() public onlyOwner {
1245     emit OwnershipRenounced(_owner);
1246     _owner = address(0);
1247   }
1248 
1249   /**
1250    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1251    * @param newOwner The address to transfer ownership to.
1252    */
1253   function transferOwnership(address newOwner) public onlyOwner {
1254     _transferOwnership(newOwner);
1255   }
1256 
1257   /**
1258    * @dev Transfers control of the contract to a newOwner.
1259    * @param newOwner The address to transfer ownership to.
1260    */
1261   function _transferOwnership(address newOwner) internal {
1262     require(newOwner != address(0));
1263     emit OwnershipTransferred(_owner, newOwner);
1264     _owner = newOwner;
1265   }
1266 }
1267 
1268 // File: contracts/access/roles/ReferrerRole.sol
1269 
1270 contract ReferrerRole is Ownable {
1271     using Roles for Roles.Role;
1272 
1273     event ReferrerAdded(address indexed account);
1274     event ReferrerRemoved(address indexed account);
1275 
1276     Roles.Role private referrers;
1277 
1278     constructor() public {
1279         referrers.add(msg.sender);
1280     }
1281 
1282     modifier onlyReferrer() {
1283         require(isReferrer(msg.sender));
1284         _;
1285     }
1286     
1287     function isReferrer(address account) public view returns (bool) {
1288         return referrers.has(account);
1289     }
1290 
1291     function addReferrer(address account) public onlyOwner() {
1292         referrers.add(account);
1293         emit ReferrerAdded(account);
1294     }
1295 
1296     function removeReferrer(address account) public onlyOwner() {
1297         referrers.remove(account);
1298         emit ReferrerRemoved(account);
1299     }
1300 
1301 }
1302 
1303 // File: contracts/lib/openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
1304 
1305 /**
1306  * @title Helps contracts guard against reentrancy attacks.
1307  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
1308  * @dev If you mark a function `nonReentrant`, you should also
1309  * mark it `external`.
1310  */
1311 contract ReentrancyGuard {
1312 
1313   /// @dev counter to allow mutex lock with only one SSTORE operation
1314   uint256 private _guardCounter = 1;
1315 
1316   /**
1317    * @dev Prevents a contract from calling itself, directly or indirectly.
1318    * If you mark a function `nonReentrant`, you should also
1319    * mark it `external`. Calling one `nonReentrant` function from
1320    * another is not supported. Instead, you can implement a
1321    * `private` function doing the actual work, and an `external`
1322    * wrapper marked as `nonReentrant`.
1323    */
1324   modifier nonReentrant() {
1325     _guardCounter += 1;
1326     uint256 localCounter = _guardCounter;
1327     _;
1328     require(localCounter == _guardCounter);
1329   }
1330 
1331 }
1332 
1333 // File: contracts/HeroCrowdsale.sol
1334 
1335 contract HeroCrowdsale is ReferrerRole, Pausable, ReentrancyGuard {
1336     using SafeMath for uint256;
1337 
1338     struct HeroSale {
1339         uint128 highestPrice;
1340         uint128 previousPrice;
1341         uint128 priceIncreaseTo;
1342         uint64  since;
1343         uint64  until;
1344         uint64  previousSaleAt;
1345         uint16  lowestPriceRate;
1346         uint16  decreaseRate;
1347         uint16  supplyLimit;
1348         uint16  suppliedCounts;
1349         uint8   currency;
1350         bool    exists;
1351     }
1352     
1353     mapping(uint16 => HeroSale) public heroTypeToHeroSales;
1354     mapping(uint16 => uint256[]) public heroTypeIds;
1355     mapping(uint16 => mapping(address => bool)) public hasAirDropHero;
1356 
1357     HeroAsset public heroAsset;
1358     uint16 constant internal SUPPLY_LIMIT_MAX = 10000;
1359     uint256 internal ethBackRate;
1360 
1361     event AddSalesEvent(
1362         uint16 indexed heroType,
1363         uint128 startPrice,
1364         uint256 lowestPrice,
1365         uint256 becomeLowestAt
1366     );
1367 
1368     event SoldHeroEvent(
1369         uint16 indexed heroType,
1370         uint256 soldPrice,
1371         uint64  soldAt,
1372         uint256 priceIncreaseTo,
1373         uint256 lowestPrice,
1374         uint256 becomeLowestAt,
1375         address purchasedBy,
1376         address indexed referrer,
1377         uint8   currency
1378     );
1379 
1380     constructor() public {
1381         ethBackRate = 20;
1382     }
1383 
1384     function setHeroAssetAddress(address _heroAssetAddress) external onlyOwner() {
1385         heroAsset = HeroAsset(_heroAssetAddress);
1386     }
1387 
1388     function changeEthBackRate(uint256 _newEthBackRate) external onlyOwner() {
1389         ethBackRate = _newEthBackRate;
1390     }
1391 
1392     function withdrawEther() external onlyOwner() {
1393         owner().transfer(address(this).balance);
1394     }
1395 
1396     function addSales(
1397         uint16 _heroType,
1398         uint128 _startPrice,
1399         uint16 _lowestPriceRate,
1400         uint16 _decreaseRate,
1401         uint64 _since,
1402         uint64 _until,
1403         uint16 _supplyLimit,
1404         uint8  _currency
1405     ) external onlyOwner() {
1406         require(!heroTypeToHeroSales[_heroType].exists, "this heroType is already added sales");
1407         require(0 <= _lowestPriceRate && _lowestPriceRate <= 100, "lowestPriceRate should be between 0 and 100");
1408         require(1 <= _decreaseRate && _decreaseRate <= 100, "decreaseRate should be should be between 1 and 100");
1409         require(_until > _since, "until should be later than since");
1410 
1411         HeroSale memory _herosale = HeroSale({
1412             highestPrice: _startPrice,
1413             previousPrice: _startPrice,
1414             priceIncreaseTo: _startPrice,
1415             since:_since,
1416             until:_until,
1417             previousSaleAt: _since,
1418             lowestPriceRate: _lowestPriceRate,
1419             decreaseRate: _decreaseRate,
1420             supplyLimit:_supplyLimit,
1421             suppliedCounts: 0,
1422             currency: _currency,
1423             exists: true
1424         });
1425 
1426         heroTypeToHeroSales[_heroType] = _herosale;
1427         heroAsset.setSupplyLimit(_heroType, _supplyLimit);
1428 
1429         uint256 _lowestPrice = uint256(_startPrice).mul(_lowestPriceRate).div(100);
1430         uint256 _becomeLowestAt = uint256(86400).mul(uint256(100).sub(_lowestPriceRate)).div(_decreaseRate).add(_since);
1431 
1432         emit AddSalesEvent(
1433             _heroType,
1434             _startPrice,
1435             _lowestPrice,
1436             _becomeLowestAt
1437         );
1438     }
1439 
1440     function purchase(uint16 _heroType, address _referrer) external whenNotPaused() nonReentrant() payable {
1441     // solium-disable-next-line security/no-block-members
1442         return purchaseImpl(_heroType, uint64(block.timestamp), _referrer);
1443     }
1444 
1445     function airDrop(uint16 _heroType, address _referrer) external whenNotPaused() {
1446         HeroSale storage heroSales = heroTypeToHeroSales[_heroType];
1447         require(airDropHero(_heroType), "currency is not 2 (airdrop)");
1448         require(!hasAirDropHero[_heroType][msg.sender]);
1449         uint64 _at = uint64(block.timestamp);
1450         require(isOnSale(_heroType, _at), "out of sales period");
1451 
1452         createHero(_heroType, msg.sender);
1453         hasAirDropHero[_heroType][msg.sender] = true;
1454         heroSales.suppliedCounts++;
1455         heroSales.previousSaleAt = _at;
1456         address referrer;
1457         if (_referrer == msg.sender){
1458             referrer = address(0x0);
1459         } else {
1460             referrer = _referrer;
1461         }
1462 
1463         emit SoldHeroEvent(
1464             _heroType,
1465             1,
1466             _at,
1467             1,
1468             1,
1469             1,
1470             msg.sender,
1471             referrer,
1472             2
1473         );
1474     }
1475 
1476     function computeCurrentPrice(uint16 _heroType) external view returns (uint8, uint256){
1477         // solium-disable-next-line security/no-block-members
1478         return computeCurrentPriceImpl(_heroType, uint64(block.timestamp));
1479     }
1480 
1481     function canBePurchasedByETH(uint16 _heroType) internal view returns (bool){
1482         return (heroTypeToHeroSales[_heroType].currency == 0);
1483     }
1484 
1485     function airDropHero(uint16 _heroType) internal view returns (bool){
1486         return (heroTypeToHeroSales[_heroType].currency == 2);
1487     }
1488 
1489     function isOnSale(uint16 _heroType, uint64 _now) internal view returns (bool){
1490         HeroSale storage heroSales = heroTypeToHeroSales[_heroType];
1491         require(heroSales.exists, "not exist sales of this heroType");
1492 
1493         if (heroSales.since <= _now && _now <= heroSales.until) {
1494             return true;
1495         } else {
1496             return false;
1497         }
1498     }
1499 
1500     function computeCurrentPriceImpl(uint16 _heroType, uint64 _at) internal view returns (uint8, uint256) {
1501         HeroSale storage heroSales = heroTypeToHeroSales[_heroType];
1502         require(heroSales.exists, "not exist sales of this heroType");
1503         require(heroSales.previousSaleAt <= _at, "current timestamp should not be faster than previousSaleAt");
1504 
1505         uint256 _lowestPrice = uint256(heroSales.highestPrice).mul(heroSales.lowestPriceRate).div(100);
1506         uint256 _secondsPassed = uint256(_at).sub(heroSales.previousSaleAt);
1507         uint256 _decreasedPrice = uint256(heroSales.priceIncreaseTo).mul(_secondsPassed).mul(heroSales.decreaseRate).div(100).div(86400);
1508         uint256 currentPrice;
1509 
1510         if (uint256(heroSales.priceIncreaseTo).sub(_lowestPrice) > _decreasedPrice){
1511             currentPrice = uint256(heroSales.priceIncreaseTo).sub(_decreasedPrice);
1512         } else {
1513             currentPrice = _lowestPrice;
1514         }
1515 
1516         return (1, currentPrice);
1517     }
1518 
1519     function purchaseImpl(uint16 _heroType, uint64 _at, address _referrer)
1520         internal
1521     {
1522         HeroSale storage heroSales = heroTypeToHeroSales[_heroType];
1523         require(canBePurchasedByETH(_heroType), "currency is not 0 (eth)");
1524         require(isOnSale(_heroType, _at), "out of sales period");
1525         (, uint256 _price) = computeCurrentPriceImpl(_heroType, _at);
1526         require(msg.value >= _price, "value is less than the price");
1527 
1528         createHero(_heroType, msg.sender);
1529         if (msg.value > _price){
1530             msg.sender.transfer(msg.value.sub(_price));
1531         }
1532         address referrer;
1533         if (_referrer == msg.sender){
1534             referrer = address(0x0);
1535         } else {
1536             referrer = _referrer;
1537         }
1538         if ((referrer != address(0x0)) && isReferrer(referrer)) {
1539             referrer.transfer(_price.mul(ethBackRate).div(100));
1540         }
1541         heroSales.previousPrice = uint128(_price);
1542         heroSales.suppliedCounts++;
1543         heroSales.previousSaleAt = _at;
1544         if (heroSales.previousPrice > heroSales.highestPrice){
1545             heroSales.highestPrice = heroSales.previousPrice;
1546         }
1547         uint256 _priceIncreaseTo;
1548         uint256 _lowestPrice;
1549         uint256 _becomeLowestAt;
1550         if (heroSales.supplyLimit > heroSales.suppliedCounts){
1551             _priceIncreaseTo = SafeMath.add(_price, _price.div((uint256(heroSales.supplyLimit).sub(heroSales.suppliedCounts))));
1552             heroSales.priceIncreaseTo = uint128(_priceIncreaseTo);
1553             _lowestPrice = uint256(heroSales.lowestPriceRate).mul(heroSales.highestPrice).div(100);
1554             _becomeLowestAt = uint256(86400).mul(100).mul((_priceIncreaseTo.sub(_lowestPrice))).div(_priceIncreaseTo).div(heroSales.decreaseRate).add(_at);
1555         } else {
1556             _priceIncreaseTo = heroSales.previousPrice;
1557             heroSales.priceIncreaseTo = uint128(_priceIncreaseTo);
1558             _lowestPrice = heroSales.previousPrice;
1559             _becomeLowestAt = _at;
1560         }
1561         emit SoldHeroEvent(
1562             _heroType,
1563             _price,
1564             _at,
1565             _priceIncreaseTo,
1566             _lowestPrice,
1567             _becomeLowestAt,
1568             msg.sender,
1569             referrer,
1570             0
1571         );
1572     }
1573 
1574     function createHero(uint16 _heroType, address _owner) internal {
1575         require(heroTypeToHeroSales[_heroType].exists, "not exist sales of this heroType");
1576         require(heroTypeIds[_heroType].length < heroTypeToHeroSales[_heroType].supplyLimit, "Heroes cant be created more than supplyLimit");
1577 
1578         uint256 _heroId = uint256(_heroType).mul(SUPPLY_LIMIT_MAX).add(heroTypeIds[_heroType].length).add(1);
1579         heroTypeIds[_heroType].push(_heroId);
1580         heroAsset.mintHeroAsset(_owner, _heroId);
1581     }
1582 }