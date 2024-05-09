1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
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
23 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
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
71 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
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
103 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
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
169 // File: openzeppelin-solidity/contracts/utils/Address.sol
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
198 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
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
216   mapping(bytes4 => bool) private _supportedInterfaces;
217 
218   /**
219    * @dev A contract implementing SupportsInterfaceWithLookup
220    * implement ERC165 itself
221    */
222   constructor()
223     internal
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
240    * @dev internal method for registering an interface
241    */
242   function _registerInterface(bytes4 interfaceId)
243     internal
244   {
245     require(interfaceId != 0xffffffff);
246     _supportedInterfaces[interfaceId] = true;
247   }
248 }
249 
250 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
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
446     require(_checkOnERC721Received(from, to, tokenId, _data));
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
509    * @dev Internal function to add a token ID to the list of a given address
510    * Note that this function is left internal to make ERC721Enumerable possible, but is not
511    * intended to be called by custom derived contracts: in particular, it emits no Transfer event.
512    * @param to address representing the new owner of the given token ID
513    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
514    */
515   function _addTokenTo(address to, uint256 tokenId) internal {
516     require(_tokenOwner[tokenId] == address(0));
517     _tokenOwner[tokenId] = to;
518     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
519   }
520 
521   /**
522    * @dev Internal function to remove a token ID from the list of a given address
523    * Note that this function is left internal to make ERC721Enumerable possible, but is not
524    * intended to be called by custom derived contracts: in particular, it emits no Transfer event,
525    * and doesn't clear approvals.
526    * @param from address representing the previous owner of the given token ID
527    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
528    */
529   function _removeTokenFrom(address from, uint256 tokenId) internal {
530     require(ownerOf(tokenId) == from);
531     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
532     _tokenOwner[tokenId] = address(0);
533   }
534 
535   /**
536    * @dev Internal function to invoke `onERC721Received` on a target address
537    * The call is not executed if the target address is not a contract
538    * @param from address representing the previous owner of the given token ID
539    * @param to target address that will receive the tokens
540    * @param tokenId uint256 ID of the token to be transferred
541    * @param _data bytes optional data to send along with the call
542    * @return whether the call correctly returned the expected magic value
543    */
544   function _checkOnERC721Received(
545     address from,
546     address to,
547     uint256 tokenId,
548     bytes _data
549   )
550     internal
551     returns (bool)
552   {
553     if (!to.isContract()) {
554       return true;
555     }
556     bytes4 retval = IERC721Receiver(to).onERC721Received(
557       msg.sender, from, tokenId, _data);
558     return (retval == _ERC721_RECEIVED);
559   }
560 
561   /**
562    * @dev Private function to clear current approval of a given token ID
563    * Reverts if the given address is not indeed the owner of the token
564    * @param owner owner of the token
565    * @param tokenId uint256 ID of the token to be transferred
566    */
567   function _clearApproval(address owner, uint256 tokenId) private {
568     require(ownerOf(tokenId) == owner);
569     if (_tokenApprovals[tokenId] != address(0)) {
570       _tokenApprovals[tokenId] = address(0);
571     }
572   }
573 }
574 
575 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
576 
577 /**
578  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
579  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
580  */
581 contract IERC721Enumerable is IERC721 {
582   function totalSupply() public view returns (uint256);
583   function tokenOfOwnerByIndex(
584     address owner,
585     uint256 index
586   )
587     public
588     view
589     returns (uint256 tokenId);
590 
591   function tokenByIndex(uint256 index) public view returns (uint256);
592 }
593 
594 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol
595 
596 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
597   // Mapping from owner to list of owned token IDs
598   mapping(address => uint256[]) private _ownedTokens;
599 
600   // Mapping from token ID to index of the owner tokens list
601   mapping(uint256 => uint256) private _ownedTokensIndex;
602 
603   // Array with all token ids, used for enumeration
604   uint256[] private _allTokens;
605 
606   // Mapping from token id to position in the allTokens array
607   mapping(uint256 => uint256) private _allTokensIndex;
608 
609   bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;
610   /**
611    * 0x780e9d63 ===
612    *   bytes4(keccak256('totalSupply()')) ^
613    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
614    *   bytes4(keccak256('tokenByIndex(uint256)'))
615    */
616 
617   /**
618    * @dev Constructor function
619    */
620   constructor() public {
621     // register the supported interface to conform to ERC721 via ERC165
622     _registerInterface(_InterfaceId_ERC721Enumerable);
623   }
624 
625   /**
626    * @dev Gets the token ID at a given index of the tokens list of the requested owner
627    * @param owner address owning the tokens list to be accessed
628    * @param index uint256 representing the index to be accessed of the requested tokens list
629    * @return uint256 token ID at the given index of the tokens list owned by the requested address
630    */
631   function tokenOfOwnerByIndex(
632     address owner,
633     uint256 index
634   )
635     public
636     view
637     returns (uint256)
638   {
639     require(index < balanceOf(owner));
640     return _ownedTokens[owner][index];
641   }
642 
643   /**
644    * @dev Gets the total amount of tokens stored by the contract
645    * @return uint256 representing the total amount of tokens
646    */
647   function totalSupply() public view returns (uint256) {
648     return _allTokens.length;
649   }
650 
651   /**
652    * @dev Gets the token ID at a given index of all the tokens in this contract
653    * Reverts if the index is greater or equal to the total number of tokens
654    * @param index uint256 representing the index to be accessed of the tokens list
655    * @return uint256 token ID at the given index of the tokens list
656    */
657   function tokenByIndex(uint256 index) public view returns (uint256) {
658     require(index < totalSupply());
659     return _allTokens[index];
660   }
661 
662   /**
663    * @dev Internal function to add a token ID to the list of a given address
664    * This function is internal due to language limitations, see the note in ERC721.sol.
665    * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event.
666    * @param to address representing the new owner of the given token ID
667    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
668    */
669   function _addTokenTo(address to, uint256 tokenId) internal {
670     super._addTokenTo(to, tokenId);
671     uint256 length = _ownedTokens[to].length;
672     _ownedTokens[to].push(tokenId);
673     _ownedTokensIndex[tokenId] = length;
674   }
675 
676   /**
677    * @dev Internal function to remove a token ID from the list of a given address
678    * This function is internal due to language limitations, see the note in ERC721.sol.
679    * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event,
680    * and doesn't clear approvals.
681    * @param from address representing the previous owner of the given token ID
682    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
683    */
684   function _removeTokenFrom(address from, uint256 tokenId) internal {
685     super._removeTokenFrom(from, tokenId);
686 
687     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
688     // then delete the last slot.
689     uint256 tokenIndex = _ownedTokensIndex[tokenId];
690     uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
691     uint256 lastToken = _ownedTokens[from][lastTokenIndex];
692 
693     _ownedTokens[from][tokenIndex] = lastToken;
694     // This also deletes the contents at the last position of the array
695     _ownedTokens[from].length--;
696 
697     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
698     // be zero. Then we can make sure that we will remove tokenId from the ownedTokens list since we are first swapping
699     // the lastToken to the first position, and then dropping the element placed in the last position of the list
700 
701     _ownedTokensIndex[tokenId] = 0;
702     _ownedTokensIndex[lastToken] = tokenIndex;
703   }
704 
705   /**
706    * @dev Internal function to mint a new token
707    * Reverts if the given token ID already exists
708    * @param to address the beneficiary that will own the minted token
709    * @param tokenId uint256 ID of the token to be minted by the msg.sender
710    */
711   function _mint(address to, uint256 tokenId) internal {
712     super._mint(to, tokenId);
713 
714     _allTokensIndex[tokenId] = _allTokens.length;
715     _allTokens.push(tokenId);
716   }
717 
718   /**
719    * @dev Internal function to burn a specific token
720    * Reverts if the token does not exist
721    * @param owner owner of the token to burn
722    * @param tokenId uint256 ID of the token being burned by the msg.sender
723    */
724   function _burn(address owner, uint256 tokenId) internal {
725     super._burn(owner, tokenId);
726 
727     // Reorg all tokens array
728     uint256 tokenIndex = _allTokensIndex[tokenId];
729     uint256 lastTokenIndex = _allTokens.length.sub(1);
730     uint256 lastToken = _allTokens[lastTokenIndex];
731 
732     _allTokens[tokenIndex] = lastToken;
733     _allTokens[lastTokenIndex] = 0;
734 
735     _allTokens.length--;
736     _allTokensIndex[tokenId] = 0;
737     _allTokensIndex[lastToken] = tokenIndex;
738   }
739 }
740 
741 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
742 
743 /**
744  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
745  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
746  */
747 contract IERC721Metadata is IERC721 {
748   function name() external view returns (string);
749   function symbol() external view returns (string);
750   function tokenURI(uint256 tokenId) external view returns (string);
751 }
752 
753 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol
754 
755 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
756   // Token name
757   string private _name;
758 
759   // Token symbol
760   string private _symbol;
761 
762   // Optional mapping for token URIs
763   mapping(uint256 => string) private _tokenURIs;
764 
765   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
766   /**
767    * 0x5b5e139f ===
768    *   bytes4(keccak256('name()')) ^
769    *   bytes4(keccak256('symbol()')) ^
770    *   bytes4(keccak256('tokenURI(uint256)'))
771    */
772 
773   /**
774    * @dev Constructor function
775    */
776   constructor(string name, string symbol) public {
777     _name = name;
778     _symbol = symbol;
779 
780     // register the supported interfaces to conform to ERC721 via ERC165
781     _registerInterface(InterfaceId_ERC721Metadata);
782   }
783 
784   /**
785    * @dev Gets the token name
786    * @return string representing the token name
787    */
788   function name() external view returns (string) {
789     return _name;
790   }
791 
792   /**
793    * @dev Gets the token symbol
794    * @return string representing the token symbol
795    */
796   function symbol() external view returns (string) {
797     return _symbol;
798   }
799 
800   /**
801    * @dev Returns an URI for a given token ID
802    * Throws if the token ID does not exist. May return an empty string.
803    * @param tokenId uint256 ID of the token to query
804    */
805   function tokenURI(uint256 tokenId) external view returns (string) {
806     require(_exists(tokenId));
807     return _tokenURIs[tokenId];
808   }
809 
810   /**
811    * @dev Internal function to set the token URI for a given token
812    * Reverts if the token ID does not exist
813    * @param tokenId uint256 ID of the token to set its URI
814    * @param uri string URI to assign
815    */
816   function _setTokenURI(uint256 tokenId, string uri) internal {
817     require(_exists(tokenId));
818     _tokenURIs[tokenId] = uri;
819   }
820 
821   /**
822    * @dev Internal function to burn a specific token
823    * Reverts if the token does not exist
824    * @param owner owner of the token to burn
825    * @param tokenId uint256 ID of the token being burned by the msg.sender
826    */
827   function _burn(address owner, uint256 tokenId) internal {
828     super._burn(owner, tokenId);
829 
830     // Clear metadata (if any)
831     if (bytes(_tokenURIs[tokenId]).length != 0) {
832       delete _tokenURIs[tokenId];
833     }
834   }
835 }
836 
837 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol
838 
839 /**
840  * @title Full ERC721 Token
841  * This implementation includes all the required and some optional functionality of the ERC721 standard
842  * Moreover, it includes approve all functionality using operator terminology
843  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
844  */
845 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
846   constructor(string name, string symbol) ERC721Metadata(name, symbol)
847     public
848   {
849   }
850 }
851 
852 // File: openzeppelin-solidity/contracts/access/Roles.sol
853 
854 /**
855  * @title Roles
856  * @dev Library for managing addresses assigned to a Role.
857  */
858 library Roles {
859   struct Role {
860     mapping (address => bool) bearer;
861   }
862 
863   /**
864    * @dev give an account access to this role
865    */
866   function add(Role storage role, address account) internal {
867     require(account != address(0));
868     require(!has(role, account));
869 
870     role.bearer[account] = true;
871   }
872 
873   /**
874    * @dev remove an account's access to this role
875    */
876   function remove(Role storage role, address account) internal {
877     require(account != address(0));
878     require(has(role, account));
879 
880     role.bearer[account] = false;
881   }
882 
883   /**
884    * @dev check if an account has this role
885    * @return bool
886    */
887   function has(Role storage role, address account)
888     internal
889     view
890     returns (bool)
891   {
892     require(account != address(0));
893     return role.bearer[account];
894   }
895 }
896 
897 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
898 
899 contract MinterRole {
900   using Roles for Roles.Role;
901 
902   event MinterAdded(address indexed account);
903   event MinterRemoved(address indexed account);
904 
905   Roles.Role private minters;
906 
907   constructor() internal {
908     _addMinter(msg.sender);
909   }
910 
911   modifier onlyMinter() {
912     require(isMinter(msg.sender));
913     _;
914   }
915 
916   function isMinter(address account) public view returns (bool) {
917     return minters.has(account);
918   }
919 
920   function addMinter(address account) public onlyMinter {
921     _addMinter(account);
922   }
923 
924   function renounceMinter() public {
925     _removeMinter(msg.sender);
926   }
927 
928   function _addMinter(address account) internal {
929     minters.add(account);
930     emit MinterAdded(account);
931   }
932 
933   function _removeMinter(address account) internal {
934     minters.remove(account);
935     emit MinterRemoved(account);
936   }
937 }
938 
939 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol
940 
941 /**
942  * @title ERC721Mintable
943  * @dev ERC721 minting logic
944  */
945 contract ERC721Mintable is ERC721, MinterRole {
946   /**
947    * @dev Function to mint tokens
948    * @param to The address that will receive the minted tokens.
949    * @param tokenId The token id to mint.
950    * @return A boolean that indicates if the operation was successful.
951    */
952   function mint(
953     address to,
954     uint256 tokenId
955   )
956     public
957     onlyMinter
958     returns (bool)
959   {
960     _mint(to, tokenId);
961     return true;
962   }
963 }
964 
965 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721MetadataMintable.sol
966 
967 /**
968  * @title ERC721MetadataMintable
969  * @dev ERC721 minting logic with metadata
970  */
971 contract ERC721MetadataMintable is ERC721, ERC721Metadata, MinterRole {
972   /**
973    * @dev Function to mint tokens
974    * @param to The address that will receive the minted tokens.
975    * @param tokenId The token id to mint.
976    * @param tokenURI The token URI of the minted token.
977    * @return A boolean that indicates if the operation was successful.
978    */
979   function mintWithTokenURI(
980     address to,
981     uint256 tokenId,
982     string tokenURI
983   )
984     public
985     onlyMinter
986     returns (bool)
987   {
988     _mint(to, tokenId);
989     _setTokenURI(tokenId, tokenURI);
990     return true;
991   }
992 }
993 
994 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
995 
996 /**
997  * @title Ownable
998  * @dev The Ownable contract has an owner address, and provides basic authorization control
999  * functions, this simplifies the implementation of "user permissions".
1000  */
1001 contract Ownable {
1002   address private _owner;
1003 
1004   event OwnershipTransferred(
1005     address indexed previousOwner,
1006     address indexed newOwner
1007   );
1008 
1009   /**
1010    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1011    * account.
1012    */
1013   constructor() internal {
1014     _owner = msg.sender;
1015     emit OwnershipTransferred(address(0), _owner);
1016   }
1017 
1018   /**
1019    * @return the address of the owner.
1020    */
1021   function owner() public view returns(address) {
1022     return _owner;
1023   }
1024 
1025   /**
1026    * @dev Throws if called by any account other than the owner.
1027    */
1028   modifier onlyOwner() {
1029     require(isOwner());
1030     _;
1031   }
1032 
1033   /**
1034    * @return true if `msg.sender` is the owner of the contract.
1035    */
1036   function isOwner() public view returns(bool) {
1037     return msg.sender == _owner;
1038   }
1039 
1040   /**
1041    * @dev Allows the current owner to relinquish control of the contract.
1042    * @notice Renouncing to ownership will leave the contract without an owner.
1043    * It will not be possible to call the functions with the `onlyOwner`
1044    * modifier anymore.
1045    */
1046   function renounceOwnership() public onlyOwner {
1047     emit OwnershipTransferred(_owner, address(0));
1048     _owner = address(0);
1049   }
1050 
1051   /**
1052    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1053    * @param newOwner The address to transfer ownership to.
1054    */
1055   function transferOwnership(address newOwner) public onlyOwner {
1056     _transferOwnership(newOwner);
1057   }
1058 
1059   /**
1060    * @dev Transfers control of the contract to a newOwner.
1061    * @param newOwner The address to transfer ownership to.
1062    */
1063   function _transferOwnership(address newOwner) internal {
1064     require(newOwner != address(0));
1065     emit OwnershipTransferred(_owner, newOwner);
1066     _owner = newOwner;
1067   }
1068 }
1069 
1070 // File: contracts/CryptoMus.sol
1071 
1072 contract CryptoMus is ERC721Full, ERC721Mintable, ERC721MetadataMintable, Ownable {
1073 
1074     event MintManyToken(
1075       address indexed to,
1076       uint256 howMany,
1077       uint256 tokenIdFrom,
1078       uint256 tokenIdTo
1079     );
1080 
1081     constructor()
1082       ERC721Mintable()
1083       ERC721Full("Cryptomus.io", "CM")
1084       public
1085     {
1086 
1087     }
1088 
1089     function mintManyWithTokenUri(
1090         address to,
1091         uint256 howMany,
1092         string tokenURI
1093     )
1094       public
1095       onlyMinter
1096       returns (bool)
1097     {
1098         uint256 totalNum = totalSupply();
1099 
1100         for (uint tokenId = totalNum + 1; tokenId <= (howMany + totalNum); tokenId++) {
1101           _mint(to, tokenId);
1102           _setTokenURI(tokenId, concat(tokenURI, uint2str(tokenId)));
1103         }
1104 
1105         emit MintManyToken(to, howMany, totalNum, tokenId);
1106 
1107         return true;
1108     }
1109 
1110     function concat(string _a, string _b) constant returns (string){
1111       bytes memory bytes_a = bytes(_a);
1112       bytes memory bytes_b = bytes(_b);
1113       string memory length_ab = new string(bytes_a.length + bytes_b.length);
1114       bytes memory bytes_c = bytes(length_ab);
1115       uint k = 0;
1116       for (uint i = 0; i < bytes_a.length; i++) bytes_c[k++] = bytes_a[i];
1117       for (i = 0; i < bytes_b.length; i++) bytes_c[k++] = bytes_b[i];
1118       return string(bytes_c);
1119     }
1120 
1121     function uint2str(uint i) public pure returns (string){
1122       if (i == 0) return "0";
1123       uint j = i;
1124       uint length;
1125       while (j != 0){
1126           length++;
1127           j /= 10;
1128       }
1129       bytes memory bstr = new bytes(length);
1130       uint k = length - 1;
1131       while (i != 0){
1132           bstr[k--] = byte(48 + i % 10);
1133           i /= 10;
1134       }
1135       return string(bstr);
1136     }
1137 
1138     function transferByOwner(address _from, address _to, uint256 _tokenId) public onlyOwner returns (bool) {
1139         require(_to != address(0));
1140 
1141         _removeTokenFrom(_from, _tokenId);
1142         _addTokenTo(_to, _tokenId);
1143 
1144         emit Transfer(_from, _to, _tokenId);
1145     }
1146 
1147     function setTokenURI(uint256 tokenId, string uri)
1148       public
1149       onlyMinter
1150       returns (bool)
1151     {
1152       _setTokenURI(tokenId, uri);
1153 
1154       return true;
1155     }
1156 }