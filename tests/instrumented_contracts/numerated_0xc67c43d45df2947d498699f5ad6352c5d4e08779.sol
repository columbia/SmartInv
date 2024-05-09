1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, reverts on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     uint256 c = a * b;
23     require(c / a == b);
24 
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     require(b > 0); // Solidity only automatically asserts when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36     return c;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     require(b <= a);
44     uint256 c = a - b;
45 
46     return c;
47   }
48 
49   /**
50   * @dev Adds two numbers, reverts on overflow.
51   */
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     require(c >= a);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61   * reverts when dividing by zero.
62   */
63   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64     require(b != 0);
65     return a % b;
66   }
67 }
68 
69 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
70 
71 /**
72  * @title IERC165
73  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
74  */
75 interface IERC165 {
76 
77   /**
78    * @notice Query if a contract implements an interface
79    * @param interfaceId The interface identifier, as specified in ERC-165
80    * @dev Interface identification is specified in ERC-165. This function
81    * uses less than 30,000 gas.
82    */
83   function supportsInterface(bytes4 interfaceId)
84     external
85     view
86     returns (bool);
87 }
88 
89 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
90 
91 /**
92  * @title ERC721 Non-Fungible Token Standard basic interface
93  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
94  */
95 contract IERC721 is IERC165 {
96 
97   event Transfer(
98     address indexed from,
99     address indexed to,
100     uint256 indexed tokenId
101   );
102   event Approval(
103     address indexed owner,
104     address indexed approved,
105     uint256 indexed tokenId
106   );
107   event ApprovalForAll(
108     address indexed owner,
109     address indexed operator,
110     bool approved
111   );
112 
113   function balanceOf(address owner) public view returns (uint256 balance);
114   function ownerOf(uint256 tokenId) public view returns (address owner);
115 
116   function approve(address to, uint256 tokenId) public;
117   function getApproved(uint256 tokenId)
118     public view returns (address operator);
119 
120   function setApprovalForAll(address operator, bool _approved) public;
121   function isApprovedForAll(address owner, address operator)
122     public view returns (bool);
123 
124   function transferFrom(address from, address to, uint256 tokenId) public;
125   function safeTransferFrom(address from, address to, uint256 tokenId)
126     public;
127 
128   function safeTransferFrom(
129     address from,
130     address to,
131     uint256 tokenId,
132     bytes data
133   )
134     public;
135 }
136 
137 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
138 
139 /**
140  * @title ERC721 token receiver interface
141  * @dev Interface for any contract that wants to support safeTransfers
142  * from ERC721 asset contracts.
143  */
144 contract IERC721Receiver {
145   /**
146    * @notice Handle the receipt of an NFT
147    * @dev The ERC721 smart contract calls this function on the recipient
148    * after a `safeTransfer`. This function MUST return the function selector,
149    * otherwise the caller will revert the transaction. The selector to be
150    * returned can be obtained as `this.onERC721Received.selector`. This
151    * function MAY throw to revert and reject the transfer.
152    * Note: the ERC721 contract address is always the message sender.
153    * @param operator The address which called `safeTransferFrom` function
154    * @param from The address which previously owned the token
155    * @param tokenId The NFT identifier which is being transferred
156    * @param data Additional data with no specified format
157    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
158    */
159   function onERC721Received(
160     address operator,
161     address from,
162     uint256 tokenId,
163     bytes data
164   )
165     public
166     returns(bytes4);
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
939 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
940 
941 /**
942  * @title ERC20 interface
943  * @dev see https://github.com/ethereum/EIPs/issues/20
944  */
945 interface IERC20 {
946   function totalSupply() external view returns (uint256);
947 
948   function balanceOf(address who) external view returns (uint256);
949 
950   function allowance(address owner, address spender)
951     external view returns (uint256);
952 
953   function transfer(address to, uint256 value) external returns (bool);
954 
955   function approve(address spender, uint256 value)
956     external returns (bool);
957 
958   function transferFrom(address from, address to, uint256 value)
959     external returns (bool);
960 
961   event Transfer(
962     address indexed from,
963     address indexed to,
964     uint256 value
965   );
966 
967   event Approval(
968     address indexed owner,
969     address indexed spender,
970     uint256 value
971   );
972 }
973 
974 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
975 
976 /**
977  * @title Ownable
978  * @dev The Ownable contract has an owner address, and provides basic authorization control
979  * functions, this simplifies the implementation of "user permissions".
980  */
981 contract Ownable {
982   address private _owner;
983 
984   event OwnershipTransferred(
985     address indexed previousOwner,
986     address indexed newOwner
987   );
988 
989   /**
990    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
991    * account.
992    */
993   constructor() internal {
994     _owner = msg.sender;
995     emit OwnershipTransferred(address(0), _owner);
996   }
997 
998   /**
999    * @return the address of the owner.
1000    */
1001   function owner() public view returns(address) {
1002     return _owner;
1003   }
1004 
1005   /**
1006    * @dev Throws if called by any account other than the owner.
1007    */
1008   modifier onlyOwner() {
1009     require(isOwner());
1010     _;
1011   }
1012 
1013   /**
1014    * @return true if `msg.sender` is the owner of the contract.
1015    */
1016   function isOwner() public view returns(bool) {
1017     return msg.sender == _owner;
1018   }
1019 
1020   /**
1021    * @dev Allows the current owner to relinquish control of the contract.
1022    * @notice Renouncing to ownership will leave the contract without an owner.
1023    * It will not be possible to call the functions with the `onlyOwner`
1024    * modifier anymore.
1025    */
1026   function renounceOwnership() public onlyOwner {
1027     emit OwnershipTransferred(_owner, address(0));
1028     _owner = address(0);
1029   }
1030 
1031   /**
1032    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1033    * @param newOwner The address to transfer ownership to.
1034    */
1035   function transferOwnership(address newOwner) public onlyOwner {
1036     _transferOwnership(newOwner);
1037   }
1038 
1039   /**
1040    * @dev Transfers control of the contract to a newOwner.
1041    * @param newOwner The address to transfer ownership to.
1042    */
1043   function _transferOwnership(address newOwner) internal {
1044     require(newOwner != address(0));
1045     emit OwnershipTransferred(_owner, newOwner);
1046     _owner = newOwner;
1047   }
1048 }
1049 
1050 // File: eth-token-recover/contracts/TokenRecover.sol
1051 
1052 /**
1053  * @title TokenRecover
1054  * @author Vittorio Minacori (https://github.com/vittominacori)
1055  * @dev Allow to recover any ERC20 sent into the contract for error
1056  */
1057 contract TokenRecover is Ownable {
1058 
1059   /**
1060    * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1061    * @param tokenAddress The token contract address
1062    * @param tokenAmount Number of tokens to be sent
1063    */
1064   function recoverERC20(
1065     address tokenAddress,
1066     uint256 tokenAmount
1067   )
1068     public
1069     onlyOwner
1070   {
1071     IERC20(tokenAddress).transfer(owner(), tokenAmount);
1072   }
1073 }
1074 
1075 // File: contracts/token/CryptoGiftToken.sol
1076 
1077 /**
1078  * @title CryptoGiftToken
1079  * @author Vittorio Minacori (https://github.com/vittominacori)
1080  * @dev It is an ERC721Full with minter role and a struct that identify the gift
1081  */
1082 contract CryptoGiftToken is ERC721Full, MinterRole, TokenRecover {
1083 
1084   // structure that defines a gift
1085   struct GiftStructure {
1086     uint256 amount;
1087     address purchaser;
1088     string content;
1089     uint256 date;
1090     uint256 style;
1091   }
1092 
1093   // number of available gift styles
1094   uint256 private _styles;
1095 
1096   // a progressive id
1097   uint256 private _progressiveId;
1098 
1099   // max available number of gift
1100   uint256 private _maxSupply;
1101 
1102   // Mapping from token ID to the structures
1103   mapping(uint256 => GiftStructure) private _structureIndex;
1104 
1105   // checks if we can generate tokens
1106   modifier canGenerate() {
1107     require(
1108       _progressiveId < _maxSupply,
1109       "Max token supply reached"
1110     );
1111     _;
1112   }
1113 
1114   constructor(
1115     string name,
1116     string symbol,
1117     uint256 maxSupply
1118   )
1119     public
1120     ERC721Full(name, symbol)
1121   {
1122     _maxSupply = maxSupply;
1123   }
1124 
1125   function styles() external view returns (uint256) {
1126     return _styles;
1127   }
1128 
1129   function progressiveId() external view returns (uint256) {
1130     return _progressiveId;
1131   }
1132 
1133   function maxSupply() external view returns (uint256) {
1134     return _maxSupply;
1135   }
1136 
1137   /**
1138    * @dev Generate a new gift and the gift structure.
1139    */
1140   function newGift(
1141     uint256 amount,
1142     address purchaser,
1143     address beneficiary,
1144     string content,
1145     uint256 date,
1146     uint256 style
1147   )
1148     external
1149     canGenerate
1150     onlyMinter
1151     returns (uint256)
1152   {
1153     require(
1154       date > 0,
1155       "Date must be greater than zero"
1156     );
1157     require(
1158       style <= _styles,
1159       "Style is not available"
1160     );
1161     uint256 tokenId = _progressiveId.add(1);
1162     _mint(beneficiary, tokenId);
1163     _structureIndex[tokenId] = GiftStructure(
1164       amount,
1165       purchaser,
1166       content,
1167       date,
1168       style
1169     );
1170     _progressiveId = tokenId;
1171     return tokenId;
1172   }
1173 
1174   /**
1175    * @dev Checks if token is visible.
1176    */
1177   function isVisible (
1178     uint256 tokenId
1179   )
1180     external
1181     view
1182     returns (bool visible, uint256 date)
1183   {
1184     if (_exists(tokenId)) {
1185       GiftStructure storage gift = _structureIndex[tokenId];
1186 
1187       // solium-disable-next-line security/no-block-members
1188       visible = block.timestamp >= gift.date;
1189       date = gift.date;
1190     } else {
1191       visible = false;
1192       date = 0;
1193     }
1194   }
1195 
1196   /**
1197    * @dev Returns the gift structure.
1198    */
1199   function getGift (uint256 tokenId)
1200     external
1201     view
1202     returns (
1203       uint256 amount,
1204       address purchaser,
1205       address beneficiary,
1206       string content,
1207       uint256 date,
1208       uint256 style
1209     )
1210   {
1211     require(
1212       _exists(tokenId),
1213       "Token must exists"
1214     );
1215 
1216     GiftStructure storage gift = _structureIndex[tokenId];
1217 
1218     require(
1219       block.timestamp >= gift.date, // solium-disable-line security/no-block-members
1220       "Now should be greater than gift date"
1221     );
1222 
1223     amount = gift.amount;
1224     purchaser = gift.purchaser;
1225     beneficiary = ownerOf(tokenId);
1226     content = gift.content;
1227     date = gift.date;
1228     style = gift.style;
1229   }
1230 
1231   /**
1232    * @dev Only contract owner or token owner can burn
1233    */
1234   function burn(uint256 tokenId) external {
1235     address tokenOwner = isOwner() ? ownerOf(tokenId) : msg.sender;
1236     super._burn(tokenOwner, tokenId);
1237     delete _structureIndex[tokenId];
1238   }
1239 
1240   /**
1241    * @dev Set the max amount of styles available
1242    */
1243   function setStyles(uint256 newStyles) external onlyMinter {
1244     require(
1245       newStyles > _styles,
1246       "Styles cannot be decreased"
1247     );
1248     _styles = newStyles;
1249   }
1250 }
1251 
1252 // File: contracts/marketplace/CryptoGiftMarketplace.sol
1253 
1254 /**
1255  * @title CryptoGiftMarketplace
1256  * @author Vittorio Minacori (https://github.com/vittominacori)
1257  * @dev It is Crowdsale contract to sell CryptoGift
1258  */
1259 contract CryptoGiftMarketplace is TokenRecover {
1260   using SafeMath for uint256;
1261 
1262   // The token being sold
1263   CryptoGiftToken private _token;
1264 
1265   // Address where funds are collected
1266   address private _wallet;
1267 
1268   // The price for a token
1269   uint256 private _price;
1270 
1271   /**
1272    * Event for token purchase logging
1273    * @param purchaser who paid for the tokens
1274    * @param beneficiary who got the tokens
1275    * @param value weis paid for purchase
1276    * @param tokenId the token id purchased
1277    */
1278   event TokenPurchase(
1279     address indexed purchaser,
1280     address indexed beneficiary,
1281     uint256 value,
1282     uint256 tokenId
1283   );
1284 
1285   /**
1286    * @param price The price for a token in wei
1287    * @param wallet Address where collected funds will be forwarded to
1288    * @param token Address of the token being sold
1289    */
1290   constructor(uint256 price, address wallet, address token) public {
1291     require(
1292       wallet != address(0),
1293       "Wallet can't be the zero address"
1294     );
1295     require(
1296       token != address(0),
1297       "Token can't be the zero address"
1298     );
1299 
1300     _price = price;
1301     _wallet = wallet;
1302     _token = CryptoGiftToken(token);
1303   }
1304 
1305   /**
1306    * @dev low level token purchase ***DO NOT OVERRIDE***
1307    * @param beneficiary Address performing the token purchase
1308    */
1309   function buyToken(
1310     address beneficiary,
1311     string content,
1312     uint256 date,
1313     uint256 style
1314   )
1315     external
1316     payable
1317   {
1318     uint256 weiAmount = msg.value;
1319     _preValidatePurchase(beneficiary, weiAmount);
1320 
1321     uint256 giftValue = msg.value.sub(_price);
1322 
1323     uint256 lastTokenId = _processPurchase(
1324       giftValue,
1325       beneficiary,
1326       content,
1327       date,
1328       style
1329     );
1330 
1331     emit TokenPurchase(
1332       msg.sender,
1333       beneficiary,
1334       giftValue,
1335       lastTokenId
1336     );
1337 
1338     _forwardFunds(giftValue, beneficiary);
1339   }
1340 
1341   function token() external view returns (CryptoGiftToken) {
1342     return _token;
1343   }
1344 
1345   function wallet() external view returns (address) {
1346     return _wallet;
1347   }
1348 
1349   function price() external view returns (uint256) {
1350     return _price;
1351   }
1352 
1353   /**
1354    * @dev Set the price of a gift
1355    * @param newPrice Value of the gift
1356    */
1357   function setPrice(uint256 newPrice) external onlyOwner {
1358     _price = newPrice;
1359   }
1360 
1361   /**
1362    * @dev Change the destination wallet
1363    * @param newWallet Address of the wallet
1364    */
1365   function setWallet(address newWallet) external onlyOwner {
1366     require(
1367       newWallet != address(0),
1368       "Wallet can't be the zero address"
1369     );
1370 
1371     _wallet = newWallet;
1372   }
1373 
1374   /**
1375    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
1376    * @param beneficiary Address performing the token purchase
1377    * @param weiAmount Value in wei involved in the purchase
1378    */
1379   function _preValidatePurchase(
1380     address beneficiary,
1381     uint256 weiAmount
1382   )
1383     internal
1384     view
1385   {
1386     require(
1387       beneficiary != address(0),
1388       "Beneficiary can't be the zero address"
1389     );
1390     require(
1391       weiAmount >= _price,
1392       "Sent ETH must be greater than or equal to token price"
1393     );
1394   }
1395 
1396   /**
1397    * @dev Executed when a purchase has been validated and is ready to be executed.
1398    */
1399   function _processPurchase(
1400     uint256 amount,
1401     address beneficiary,
1402     string content,
1403     uint256 date,
1404     uint256 style
1405   )
1406     internal
1407     returns (uint256)
1408   {
1409     return _token.newGift(
1410       amount,
1411       msg.sender,
1412       beneficiary,
1413       content,
1414       date,
1415       style
1416     );
1417   }
1418 
1419   /**
1420    * @dev Determines how ETH is stored/forwarded on purchases.
1421    */
1422   function _forwardFunds(uint256 giftValue, address beneficiary) internal {
1423     if (_price > 0) {
1424       _wallet.transfer(_price);
1425     }
1426 
1427     if (giftValue > 0) {
1428       beneficiary.transfer(giftValue);
1429     }
1430   }
1431 }