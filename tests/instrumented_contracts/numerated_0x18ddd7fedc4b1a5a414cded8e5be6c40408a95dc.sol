1 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
2 
3 pragma solidity ^0.4.24;
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
25 pragma solidity ^0.4.24;
26 
27 
28 /**
29  * @title ERC721 Non-Fungible Token Standard basic interface
30  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
31  */
32 contract IERC721 is IERC165 {
33 
34   event Transfer(
35     address indexed from,
36     address indexed to,
37     uint256 indexed tokenId
38   );
39   event Approval(
40     address indexed owner,
41     address indexed approved,
42     uint256 indexed tokenId
43   );
44   event ApprovalForAll(
45     address indexed owner,
46     address indexed operator,
47     bool approved
48   );
49 
50   function balanceOf(address owner) public view returns (uint256 balance);
51   function ownerOf(uint256 tokenId) public view returns (address owner);
52 
53   function approve(address to, uint256 tokenId) public;
54   function getApproved(uint256 tokenId)
55     public view returns (address operator);
56 
57   function setApprovalForAll(address operator, bool _approved) public;
58   function isApprovedForAll(address owner, address operator)
59     public view returns (bool);
60 
61   function transferFrom(address from, address to, uint256 tokenId) public;
62   function safeTransferFrom(address from, address to, uint256 tokenId)
63     public;
64 
65   function safeTransferFrom(
66     address from,
67     address to,
68     uint256 tokenId,
69     bytes data
70   )
71     public;
72 }
73 
74 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
75 
76 pragma solidity ^0.4.24;
77 
78 /**
79  * @title ERC721 token receiver interface
80  * @dev Interface for any contract that wants to support safeTransfers
81  * from ERC721 asset contracts.
82  */
83 contract IERC721Receiver {
84   /**
85    * @notice Handle the receipt of an NFT
86    * @dev The ERC721 smart contract calls this function on the recipient
87    * after a `safeTransfer`. This function MUST return the function selector,
88    * otherwise the caller will revert the transaction. The selector to be
89    * returned can be obtained as `this.onERC721Received.selector`. This
90    * function MAY throw to revert and reject the transfer.
91    * Note: the ERC721 contract address is always the message sender.
92    * @param operator The address which called `safeTransferFrom` function
93    * @param from The address which previously owned the token
94    * @param tokenId The NFT identifier which is being transferred
95    * @param data Additional data with no specified format
96    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
97    */
98   function onERC721Received(
99     address operator,
100     address from,
101     uint256 tokenId,
102     bytes data
103   )
104     public
105     returns(bytes4);
106 }
107 
108 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
109 
110 pragma solidity ^0.4.24;
111 
112 /**
113  * @title SafeMath
114  * @dev Math operations with safety checks that revert on error
115  */
116 library SafeMath {
117 
118   /**
119   * @dev Multiplies two numbers, reverts on overflow.
120   */
121   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
122     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
123     // benefit is lost if 'b' is also tested.
124     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
125     if (a == 0) {
126       return 0;
127     }
128 
129     uint256 c = a * b;
130     require(c / a == b);
131 
132     return c;
133   }
134 
135   /**
136   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
137   */
138   function div(uint256 a, uint256 b) internal pure returns (uint256) {
139     require(b > 0); // Solidity only automatically asserts when dividing by 0
140     uint256 c = a / b;
141     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
142 
143     return c;
144   }
145 
146   /**
147   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
148   */
149   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
150     require(b <= a);
151     uint256 c = a - b;
152 
153     return c;
154   }
155 
156   /**
157   * @dev Adds two numbers, reverts on overflow.
158   */
159   function add(uint256 a, uint256 b) internal pure returns (uint256) {
160     uint256 c = a + b;
161     require(c >= a);
162 
163     return c;
164   }
165 
166   /**
167   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
168   * reverts when dividing by zero.
169   */
170   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
171     require(b != 0);
172     return a % b;
173   }
174 }
175 
176 // File: openzeppelin-solidity/contracts/utils/Address.sol
177 
178 pragma solidity ^0.4.24;
179 
180 /**
181  * Utility library of inline functions on addresses
182  */
183 library Address {
184 
185   /**
186    * Returns whether the target address is a contract
187    * @dev This function will return false if invoked during the constructor of a contract,
188    * as the code is not actually created until after the constructor finishes.
189    * @param account address of the account to check
190    * @return whether the target address is a contract
191    */
192   function isContract(address account) internal view returns (bool) {
193     uint256 size;
194     // XXX Currently there is no better way to check if there is a contract in an address
195     // than to check the size of the code at that address.
196     // See https://ethereum.stackexchange.com/a/14016/36603
197     // for more details about how this works.
198     // TODO Check this again before the Serenity release, because all addresses will be
199     // contracts then.
200     // solium-disable-next-line security/no-inline-assembly
201     assembly { size := extcodesize(account) }
202     return size > 0;
203   }
204 
205 }
206 
207 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
208 
209 pragma solidity ^0.4.24;
210 
211 
212 /**
213  * @title ERC165
214  * @author Matt Condon (@shrugs)
215  * @dev Implements ERC165 using a lookup table.
216  */
217 contract ERC165 is IERC165 {
218 
219   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
220   /**
221    * 0x01ffc9a7 ===
222    *   bytes4(keccak256('supportsInterface(bytes4)'))
223    */
224 
225   /**
226    * @dev a mapping of interface id to whether or not it's supported
227    */
228   mapping(bytes4 => bool) private _supportedInterfaces;
229 
230   /**
231    * @dev A contract implementing SupportsInterfaceWithLookup
232    * implement ERC165 itself
233    */
234   constructor()
235     internal
236   {
237     _registerInterface(_InterfaceId_ERC165);
238   }
239 
240   /**
241    * @dev implement supportsInterface(bytes4) using a lookup table
242    */
243   function supportsInterface(bytes4 interfaceId)
244     external
245     view
246     returns (bool)
247   {
248     return _supportedInterfaces[interfaceId];
249   }
250 
251   /**
252    * @dev internal method for registering an interface
253    */
254   function _registerInterface(bytes4 interfaceId)
255     internal
256   {
257     require(interfaceId != 0xffffffff);
258     _supportedInterfaces[interfaceId] = true;
259   }
260 }
261 
262 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
263 
264 pragma solidity ^0.4.24;
265 
266 
267 
268 
269 
270 
271 /**
272  * @title ERC721 Non-Fungible Token Standard basic implementation
273  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
274  */
275 contract ERC721 is ERC165, IERC721 {
276 
277   using SafeMath for uint256;
278   using Address for address;
279 
280   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
281   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
282   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
283 
284   // Mapping from token ID to owner
285   mapping (uint256 => address) private _tokenOwner;
286 
287   // Mapping from token ID to approved address
288   mapping (uint256 => address) private _tokenApprovals;
289 
290   // Mapping from owner to number of owned token
291   mapping (address => uint256) private _ownedTokensCount;
292 
293   // Mapping from owner to operator approvals
294   mapping (address => mapping (address => bool)) private _operatorApprovals;
295 
296   bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
297   /*
298    * 0x80ac58cd ===
299    *   bytes4(keccak256('balanceOf(address)')) ^
300    *   bytes4(keccak256('ownerOf(uint256)')) ^
301    *   bytes4(keccak256('approve(address,uint256)')) ^
302    *   bytes4(keccak256('getApproved(uint256)')) ^
303    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
304    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
305    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
306    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
307    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
308    */
309 
310   constructor()
311     public
312   {
313     // register the supported interfaces to conform to ERC721 via ERC165
314     _registerInterface(_InterfaceId_ERC721);
315   }
316 
317   /**
318    * @dev Gets the balance of the specified address
319    * @param owner address to query the balance of
320    * @return uint256 representing the amount owned by the passed address
321    */
322   function balanceOf(address owner) public view returns (uint256) {
323     require(owner != address(0));
324     return _ownedTokensCount[owner];
325   }
326 
327   /**
328    * @dev Gets the owner of the specified token ID
329    * @param tokenId uint256 ID of the token to query the owner of
330    * @return owner address currently marked as the owner of the given token ID
331    */
332   function ownerOf(uint256 tokenId) public view returns (address) {
333     address owner = _tokenOwner[tokenId];
334     require(owner != address(0));
335     return owner;
336   }
337 
338   /**
339    * @dev Approves another address to transfer the given token ID
340    * The zero address indicates there is no approved address.
341    * There can only be one approved address per token at a given time.
342    * Can only be called by the token owner or an approved operator.
343    * @param to address to be approved for the given token ID
344    * @param tokenId uint256 ID of the token to be approved
345    */
346   function approve(address to, uint256 tokenId) public {
347     address owner = ownerOf(tokenId);
348     require(to != owner);
349     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
350 
351     _tokenApprovals[tokenId] = to;
352     emit Approval(owner, to, tokenId);
353   }
354 
355   /**
356    * @dev Gets the approved address for a token ID, or zero if no address set
357    * Reverts if the token ID does not exist.
358    * @param tokenId uint256 ID of the token to query the approval of
359    * @return address currently approved for the given token ID
360    */
361   function getApproved(uint256 tokenId) public view returns (address) {
362     require(_exists(tokenId));
363     return _tokenApprovals[tokenId];
364   }
365 
366   /**
367    * @dev Sets or unsets the approval of a given operator
368    * An operator is allowed to transfer all tokens of the sender on their behalf
369    * @param to operator address to set the approval
370    * @param approved representing the status of the approval to be set
371    */
372   function setApprovalForAll(address to, bool approved) public {
373     require(to != msg.sender);
374     _operatorApprovals[msg.sender][to] = approved;
375     emit ApprovalForAll(msg.sender, to, approved);
376   }
377 
378   /**
379    * @dev Tells whether an operator is approved by a given owner
380    * @param owner owner address which you want to query the approval of
381    * @param operator operator address which you want to query the approval of
382    * @return bool whether the given operator is approved by the given owner
383    */
384   function isApprovedForAll(
385     address owner,
386     address operator
387   )
388     public
389     view
390     returns (bool)
391   {
392     return _operatorApprovals[owner][operator];
393   }
394 
395   /**
396    * @dev Transfers the ownership of a given token ID to another address
397    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
398    * Requires the msg sender to be the owner, approved, or operator
399    * @param from current owner of the token
400    * @param to address to receive the ownership of the given token ID
401    * @param tokenId uint256 ID of the token to be transferred
402   */
403   function transferFrom(
404     address from,
405     address to,
406     uint256 tokenId
407   )
408     public
409   {
410     require(_isApprovedOrOwner(msg.sender, tokenId));
411     require(to != address(0));
412 
413     _clearApproval(from, tokenId);
414     _removeTokenFrom(from, tokenId);
415     _addTokenTo(to, tokenId);
416 
417     emit Transfer(from, to, tokenId);
418   }
419 
420   /**
421    * @dev Safely transfers the ownership of a given token ID to another address
422    * If the target address is a contract, it must implement `onERC721Received`,
423    * which is called upon a safe transfer, and return the magic value
424    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
425    * the transfer is reverted.
426    *
427    * Requires the msg sender to be the owner, approved, or operator
428    * @param from current owner of the token
429    * @param to address to receive the ownership of the given token ID
430    * @param tokenId uint256 ID of the token to be transferred
431   */
432   function safeTransferFrom(
433     address from,
434     address to,
435     uint256 tokenId
436   )
437     public
438   {
439     // solium-disable-next-line arg-overflow
440     safeTransferFrom(from, to, tokenId, "");
441   }
442 
443   /**
444    * @dev Safely transfers the ownership of a given token ID to another address
445    * If the target address is a contract, it must implement `onERC721Received`,
446    * which is called upon a safe transfer, and return the magic value
447    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
448    * the transfer is reverted.
449    * Requires the msg sender to be the owner, approved, or operator
450    * @param from current owner of the token
451    * @param to address to receive the ownership of the given token ID
452    * @param tokenId uint256 ID of the token to be transferred
453    * @param _data bytes data to send along with a safe transfer check
454    */
455   function safeTransferFrom(
456     address from,
457     address to,
458     uint256 tokenId,
459     bytes _data
460   )
461     public
462   {
463     transferFrom(from, to, tokenId);
464     // solium-disable-next-line arg-overflow
465     require(_checkOnERC721Received(from, to, tokenId, _data));
466   }
467 
468   /**
469    * @dev Returns whether the specified token exists
470    * @param tokenId uint256 ID of the token to query the existence of
471    * @return whether the token exists
472    */
473   function _exists(uint256 tokenId) internal view returns (bool) {
474     address owner = _tokenOwner[tokenId];
475     return owner != address(0);
476   }
477 
478   /**
479    * @dev Returns whether the given spender can transfer a given token ID
480    * @param spender address of the spender to query
481    * @param tokenId uint256 ID of the token to be transferred
482    * @return bool whether the msg.sender is approved for the given token ID,
483    *  is an operator of the owner, or is the owner of the token
484    */
485   function _isApprovedOrOwner(
486     address spender,
487     uint256 tokenId
488   )
489     internal
490     view
491     returns (bool)
492   {
493     address owner = ownerOf(tokenId);
494     // Disable solium check because of
495     // https://github.com/duaraghav8/Solium/issues/175
496     // solium-disable-next-line operator-whitespace
497     return (
498       spender == owner ||
499       getApproved(tokenId) == spender ||
500       isApprovedForAll(owner, spender)
501     );
502   }
503 
504   /**
505    * @dev Internal function to mint a new token
506    * Reverts if the given token ID already exists
507    * @param to The address that will own the minted token
508    * @param tokenId uint256 ID of the token to be minted by the msg.sender
509    */
510   function _mint(address to, uint256 tokenId) internal {
511     require(to != address(0));
512     _addTokenTo(to, tokenId);
513     emit Transfer(address(0), to, tokenId);
514   }
515 
516   /**
517    * @dev Internal function to burn a specific token
518    * Reverts if the token does not exist
519    * @param tokenId uint256 ID of the token being burned by the msg.sender
520    */
521   function _burn(address owner, uint256 tokenId) internal {
522     _clearApproval(owner, tokenId);
523     _removeTokenFrom(owner, tokenId);
524     emit Transfer(owner, address(0), tokenId);
525   }
526 
527   /**
528    * @dev Internal function to add a token ID to the list of a given address
529    * Note that this function is left internal to make ERC721Enumerable possible, but is not
530    * intended to be called by custom derived contracts: in particular, it emits no Transfer event.
531    * @param to address representing the new owner of the given token ID
532    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
533    */
534   function _addTokenTo(address to, uint256 tokenId) internal {
535     require(_tokenOwner[tokenId] == address(0));
536     _tokenOwner[tokenId] = to;
537     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
538   }
539 
540   /**
541    * @dev Internal function to remove a token ID from the list of a given address
542    * Note that this function is left internal to make ERC721Enumerable possible, but is not
543    * intended to be called by custom derived contracts: in particular, it emits no Transfer event,
544    * and doesn't clear approvals.
545    * @param from address representing the previous owner of the given token ID
546    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
547    */
548   function _removeTokenFrom(address from, uint256 tokenId) internal {
549     require(ownerOf(tokenId) == from);
550     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
551     _tokenOwner[tokenId] = address(0);
552   }
553 
554   /**
555    * @dev Internal function to invoke `onERC721Received` on a target address
556    * The call is not executed if the target address is not a contract
557    * @param from address representing the previous owner of the given token ID
558    * @param to target address that will receive the tokens
559    * @param tokenId uint256 ID of the token to be transferred
560    * @param _data bytes optional data to send along with the call
561    * @return whether the call correctly returned the expected magic value
562    */
563   function _checkOnERC721Received(
564     address from,
565     address to,
566     uint256 tokenId,
567     bytes _data
568   )
569     internal
570     returns (bool)
571   {
572     if (!to.isContract()) {
573       return true;
574     }
575     bytes4 retval = IERC721Receiver(to).onERC721Received(
576       msg.sender, from, tokenId, _data);
577     return (retval == _ERC721_RECEIVED);
578   }
579 
580   /**
581    * @dev Private function to clear current approval of a given token ID
582    * Reverts if the given address is not indeed the owner of the token
583    * @param owner owner of the token
584    * @param tokenId uint256 ID of the token to be transferred
585    */
586   function _clearApproval(address owner, uint256 tokenId) private {
587     require(ownerOf(tokenId) == owner);
588     if (_tokenApprovals[tokenId] != address(0)) {
589       _tokenApprovals[tokenId] = address(0);
590     }
591   }
592 }
593 
594 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
595 
596 pragma solidity ^0.4.24;
597 
598 
599 /**
600  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
601  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
602  */
603 contract IERC721Enumerable is IERC721 {
604   function totalSupply() public view returns (uint256);
605   function tokenOfOwnerByIndex(
606     address owner,
607     uint256 index
608   )
609     public
610     view
611     returns (uint256 tokenId);
612 
613   function tokenByIndex(uint256 index) public view returns (uint256);
614 }
615 
616 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol
617 
618 pragma solidity ^0.4.24;
619 
620 
621 
622 
623 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
624   // Mapping from owner to list of owned token IDs
625   mapping(address => uint256[]) private _ownedTokens;
626 
627   // Mapping from token ID to index of the owner tokens list
628   mapping(uint256 => uint256) private _ownedTokensIndex;
629 
630   // Array with all token ids, used for enumeration
631   uint256[] private _allTokens;
632 
633   // Mapping from token id to position in the allTokens array
634   mapping(uint256 => uint256) private _allTokensIndex;
635 
636   bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;
637   /**
638    * 0x780e9d63 ===
639    *   bytes4(keccak256('totalSupply()')) ^
640    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
641    *   bytes4(keccak256('tokenByIndex(uint256)'))
642    */
643 
644   /**
645    * @dev Constructor function
646    */
647   constructor() public {
648     // register the supported interface to conform to ERC721 via ERC165
649     _registerInterface(_InterfaceId_ERC721Enumerable);
650   }
651 
652   /**
653    * @dev Gets the token ID at a given index of the tokens list of the requested owner
654    * @param owner address owning the tokens list to be accessed
655    * @param index uint256 representing the index to be accessed of the requested tokens list
656    * @return uint256 token ID at the given index of the tokens list owned by the requested address
657    */
658   function tokenOfOwnerByIndex(
659     address owner,
660     uint256 index
661   )
662     public
663     view
664     returns (uint256)
665   {
666     require(index < balanceOf(owner));
667     return _ownedTokens[owner][index];
668   }
669 
670   /**
671    * @dev Gets the total amount of tokens stored by the contract
672    * @return uint256 representing the total amount of tokens
673    */
674   function totalSupply() public view returns (uint256) {
675     return _allTokens.length;
676   }
677 
678   /**
679    * @dev Gets the token ID at a given index of all the tokens in this contract
680    * Reverts if the index is greater or equal to the total number of tokens
681    * @param index uint256 representing the index to be accessed of the tokens list
682    * @return uint256 token ID at the given index of the tokens list
683    */
684   function tokenByIndex(uint256 index) public view returns (uint256) {
685     require(index < totalSupply());
686     return _allTokens[index];
687   }
688 
689   /**
690    * @dev Internal function to add a token ID to the list of a given address
691    * This function is internal due to language limitations, see the note in ERC721.sol.
692    * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event.
693    * @param to address representing the new owner of the given token ID
694    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
695    */
696   function _addTokenTo(address to, uint256 tokenId) internal {
697     super._addTokenTo(to, tokenId);
698     uint256 length = _ownedTokens[to].length;
699     _ownedTokens[to].push(tokenId);
700     _ownedTokensIndex[tokenId] = length;
701   }
702 
703   /**
704    * @dev Internal function to remove a token ID from the list of a given address
705    * This function is internal due to language limitations, see the note in ERC721.sol.
706    * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event,
707    * and doesn't clear approvals.
708    * @param from address representing the previous owner of the given token ID
709    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
710    */
711   function _removeTokenFrom(address from, uint256 tokenId) internal {
712     super._removeTokenFrom(from, tokenId);
713 
714     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
715     // then delete the last slot.
716     uint256 tokenIndex = _ownedTokensIndex[tokenId];
717     uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
718     uint256 lastToken = _ownedTokens[from][lastTokenIndex];
719 
720     _ownedTokens[from][tokenIndex] = lastToken;
721     // This also deletes the contents at the last position of the array
722     _ownedTokens[from].length--;
723 
724     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
725     // be zero. Then we can make sure that we will remove tokenId from the ownedTokens list since we are first swapping
726     // the lastToken to the first position, and then dropping the element placed in the last position of the list
727 
728     _ownedTokensIndex[tokenId] = 0;
729     _ownedTokensIndex[lastToken] = tokenIndex;
730   }
731 
732   /**
733    * @dev Internal function to mint a new token
734    * Reverts if the given token ID already exists
735    * @param to address the beneficiary that will own the minted token
736    * @param tokenId uint256 ID of the token to be minted by the msg.sender
737    */
738   function _mint(address to, uint256 tokenId) internal {
739     super._mint(to, tokenId);
740 
741     _allTokensIndex[tokenId] = _allTokens.length;
742     _allTokens.push(tokenId);
743   }
744 
745   /**
746    * @dev Internal function to burn a specific token
747    * Reverts if the token does not exist
748    * @param owner owner of the token to burn
749    * @param tokenId uint256 ID of the token being burned by the msg.sender
750    */
751   function _burn(address owner, uint256 tokenId) internal {
752     super._burn(owner, tokenId);
753 
754     // Reorg all tokens array
755     uint256 tokenIndex = _allTokensIndex[tokenId];
756     uint256 lastTokenIndex = _allTokens.length.sub(1);
757     uint256 lastToken = _allTokens[lastTokenIndex];
758 
759     _allTokens[tokenIndex] = lastToken;
760     _allTokens[lastTokenIndex] = 0;
761 
762     _allTokens.length--;
763     _allTokensIndex[tokenId] = 0;
764     _allTokensIndex[lastToken] = tokenIndex;
765   }
766 }
767 
768 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
769 
770 pragma solidity ^0.4.24;
771 
772 
773 /**
774  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
775  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
776  */
777 contract IERC721Metadata is IERC721 {
778   function name() external view returns (string);
779   function symbol() external view returns (string);
780   function tokenURI(uint256 tokenId) external view returns (string);
781 }
782 
783 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol
784 
785 pragma solidity ^0.4.24;
786 
787 
788 
789 
790 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
791   // Token name
792   string private _name;
793 
794   // Token symbol
795   string private _symbol;
796 
797   // Optional mapping for token URIs
798   mapping(uint256 => string) private _tokenURIs;
799 
800   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
801   /**
802    * 0x5b5e139f ===
803    *   bytes4(keccak256('name()')) ^
804    *   bytes4(keccak256('symbol()')) ^
805    *   bytes4(keccak256('tokenURI(uint256)'))
806    */
807 
808   /**
809    * @dev Constructor function
810    */
811   constructor(string name, string symbol) public {
812     _name = name;
813     _symbol = symbol;
814 
815     // register the supported interfaces to conform to ERC721 via ERC165
816     _registerInterface(InterfaceId_ERC721Metadata);
817   }
818 
819   /**
820    * @dev Gets the token name
821    * @return string representing the token name
822    */
823   function name() external view returns (string) {
824     return _name;
825   }
826 
827   /**
828    * @dev Gets the token symbol
829    * @return string representing the token symbol
830    */
831   function symbol() external view returns (string) {
832     return _symbol;
833   }
834 
835   /**
836    * @dev Returns an URI for a given token ID
837    * Throws if the token ID does not exist. May return an empty string.
838    * @param tokenId uint256 ID of the token to query
839    */
840   function tokenURI(uint256 tokenId) external view returns (string) {
841     require(_exists(tokenId));
842     return _tokenURIs[tokenId];
843   }
844 
845   /**
846    * @dev Internal function to set the token URI for a given token
847    * Reverts if the token ID does not exist
848    * @param tokenId uint256 ID of the token to set its URI
849    * @param uri string URI to assign
850    */
851   function _setTokenURI(uint256 tokenId, string uri) internal {
852     require(_exists(tokenId));
853     _tokenURIs[tokenId] = uri;
854   }
855 
856   /**
857    * @dev Internal function to burn a specific token
858    * Reverts if the token does not exist
859    * @param owner owner of the token to burn
860    * @param tokenId uint256 ID of the token being burned by the msg.sender
861    */
862   function _burn(address owner, uint256 tokenId) internal {
863     super._burn(owner, tokenId);
864 
865     // Clear metadata (if any)
866     if (bytes(_tokenURIs[tokenId]).length != 0) {
867       delete _tokenURIs[tokenId];
868     }
869   }
870 }
871 
872 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol
873 
874 pragma solidity ^0.4.24;
875 
876 
877 
878 
879 /**
880  * @title Full ERC721 Token
881  * This implementation includes all the required and some optional functionality of the ERC721 standard
882  * Moreover, it includes approve all functionality using operator terminology
883  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
884  */
885 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
886   constructor(string name, string symbol) ERC721Metadata(name, symbol)
887     public
888   {
889   }
890 }
891 
892 // File: contracts/Landemic.sol
893 
894 pragma solidity ^0.4.24;
895 
896 /* The latest stable Truffle is Truffle 4, which also uses Solidity 4. The highest OpenZeppelin that is compatible with Solidity 4 is 2.0.0. */
897 
898 
899 contract Landemic is ERC721Full("Landemic","LAND") {
900 
901     uint256 public _basePrice = 810000000000000; // $0.25 ETH/USD as of May 2019
902     uint8 public _bountyDivisor = 20; // 5% to each player
903     uint16 public _defaultMultiple = 100; // using 1 decimal point divisibility, max 1000
904     address public _owner = msg.sender;
905     string public _baseURL = "https://landemic.io/";
906 
907     struct Price {
908         uint240 lastPrice;
909         uint16 multiple;
910     }
911     mapping(uint256 => Price) public _prices;
912 
913     // When recepient cannot receive the bounty,
914     // it is stored here and can be pulled manually
915     mapping(address => uint256) public failedPayouts;
916     uint256 public failedPayoutsSum;
917 
918     /* Admin */
919 
920     modifier onlyContractOwner() {
921         require(msg.sender == _owner);
922         _;
923     }
924 
925     function _lastPrice(uint256 tokenId) public view returns (uint256) {
926         return uint256(_prices[tokenId].lastPrice);
927     }
928 
929     function _multiple(uint256 tokenId) public view returns (uint16) {
930         return _prices[tokenId].multiple;
931     }
932 
933     function setBasePrice(uint256 basePrice) onlyContractOwner public {
934         _basePrice = basePrice;
935     }
936 
937     function setBountyDivisor(uint8 bountyDivisor) onlyContractOwner public {
938         _bountyDivisor = bountyDivisor;
939     }
940 
941     function setBaseURL(string baseURL) public onlyContractOwner {
942         _baseURL = baseURL;
943     }
944 
945     function setOwner(address owner) onlyContractOwner public {
946         _owner = owner;
947     }
948 
949     // Allows the owner to withdraw profits and failed payouts.
950     // Owner should check failedPayoutsSum to not withdraw extra.
951     function withdraw(uint256 amount) onlyContractOwner public {
952         msg.sender.transfer(amount);
953     }
954 
955     function withdrawProfit() onlyContractOwner public {
956         msg.sender.transfer(address(this).balance.sub(failedPayoutsSum));
957     }
958 
959     /* Temp Functions Until Server-Side Component */
960 
961     function getAllOwned() public view returns (uint256[], address[]) {
962 
963         uint totalOwned = totalSupply();
964 
965         uint256[] memory ownedUint256 = new uint256[](totalOwned);
966         address[] memory ownersAddress = new address[](totalOwned);
967 
968         for (uint i = 0; i < totalOwned; i++) {
969             ownedUint256[i] = tokenByIndex(i);
970             ownersAddress[i] = ownerOf(ownedUint256[i]);
971         }
972 
973         return (ownedUint256, ownersAddress);
974 
975     }
976 
977     function metadataForToken(uint256 tokenId) public view returns (uint256, address, uint16, uint256) {
978         uint256 price = priceOf(tokenId);
979 
980         if (_exists(tokenId)) {
981             return (_lastPrice(tokenId), ownerOf(tokenId), multipleOf(tokenId), price);
982         }
983         return (_basePrice, 0, 10, price);
984     }
985 
986     function priceOf(uint256 tokenId) public view returns (uint256) {
987         if (_exists(tokenId)) {
988             return _lastPrice(tokenId).mul(uint256(multipleOf(tokenId))).div(10);
989         }
990         return _basePrice;
991     }
992 
993     function multipleOf(uint256 tokenId) public view returns (uint16) {
994         uint16 multiple = _multiple(tokenId);
995         if (multiple > 0) {
996             return multiple;
997         }
998         return _defaultMultiple;
999     }
1000 
1001     /* Adjust metadata */
1002 
1003     modifier onlyTokenOwner(uint256 tokenId) {
1004         require(msg.sender == ownerOf(tokenId));
1005         _;
1006     }
1007 
1008     function setMultiple(uint256 tokenId, uint16 multiple) public onlyTokenOwner(tokenId) {
1009         require(multiple >= 1 && multiple <= 1000);
1010         _prices[tokenId].multiple = multiple;
1011     }
1012 
1013     /* Buy & Sell */
1014 
1015     // TODO:
1016     // function grabCodes(uint256[] tokens) public payable {
1017     //     for (uint i = 0; i < tokens.length; i++) {
1018     //         _mint(msg.sender, tokens[i]);
1019     //     }
1020     // }
1021 
1022 
1023 
1024     function _pushOrDelayBounty(address to, uint256 amount) internal {
1025         bool success = to.send(amount);
1026         if (!success) {
1027             failedPayouts[to] = failedPayouts[to].add(amount);
1028             failedPayoutsSum = failedPayoutsSum.add(amount);
1029         }
1030     }
1031 
1032     function grabCode(uint256 tokenId) public payable {
1033         // uint256 tokenId = uint256(stringToBytes32(code));
1034 
1035         uint256 price = priceOf(tokenId);  // _lastPrice * 0.1  <=  price  <=  _lastPrice * 10
1036         require(msg.value >= price);
1037 
1038         _prices[tokenId] = Price(uint240(msg.value), uint16(0));
1039 
1040         if (!_exists(tokenId)) {
1041             _mint(msg.sender, tokenId);
1042             return;
1043         }
1044 
1045         address owner = ownerOf(tokenId);
1046         require(owner != msg.sender);
1047 
1048         _burn(owner, tokenId);
1049         _mint(msg.sender, tokenId);
1050 
1051         uint256 bounty = msg.value.div(_bountyDivisor);  // 5%
1052         uint256 bountiesCount = 1; // Landemic.
1053         uint256[4] memory neighbors = neighborsOfToken(tokenId);
1054         for (uint i = 0; i < 4; i++) {
1055             uint256 neighbor = neighbors[i];
1056             if (!_exists(neighbor)) {
1057                 continue;
1058             }
1059             _pushOrDelayBounty(ownerOf(neighbor), bounty);
1060             bountiesCount++;
1061         }
1062 
1063         _pushOrDelayBounty(owner, msg.value.sub(bounty.mul(bountiesCount)));  // 75%
1064     }
1065 
1066     function pullBounty(address to) public {
1067         uint256 bounty = failedPayouts[msg.sender];
1068         if (bounty == 0) {
1069             return;
1070         }
1071         failedPayouts[msg.sender] = 0;
1072         failedPayoutsSum = failedPayoutsSum.sub(bounty);
1073         to.transfer(bounty);
1074     }
1075 
1076 
1077     /* ERC721Metadata overrides */
1078 
1079     /**
1080     * @dev Returns an URI for a given token ID
1081     * @dev Throws if the token ID does not exist. May return an empty string.
1082     * @param _tokenId uint256 ID of the token to query
1083     */
1084     function tokenURI(uint256 _tokenId) external view returns (string) {
1085         require(_exists(_tokenId));
1086         return strConcat(strConcat(_baseURL, uint256ToString(_tokenId)),".json");
1087     }
1088 
1089     /* Utilities */
1090 
1091     // https://ethereum.stackexchange.com/a/9152/3847
1092     function uint256ToString(uint256 y) private pure returns (string) {
1093         bytes32 x = bytes32(y);
1094         bytes memory bytesString = new bytes(32);
1095         uint charCount = 0;
1096         for (uint j = 0; j < 32; j++) {
1097             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
1098             if (char != 0) {
1099                 bytesString[charCount] = char;
1100                 charCount++;
1101             }
1102         }
1103         bytes memory bytesStringTrimmed = new bytes(charCount);
1104         for (j = 0; j < charCount; j++) {
1105             bytesStringTrimmed[j] = bytesString[j];
1106         }
1107         return string(bytesStringTrimmed);
1108     }
1109 
1110     function stringToBytes32(string memory source) private pure returns (bytes32 result) {
1111         bytes memory testEmptyStringTest = bytes(source);
1112         if (testEmptyStringTest.length == 0) {
1113             return 0x0;
1114         }
1115 
1116         assembly {
1117             result := mload(add(source, 32))
1118         }
1119     }
1120 
1121     // https://ethereum.stackexchange.com/questions/729/how-to-concatenate-strings-in-solidity
1122     function strConcat(string _a, string _b) private pure returns (string) {
1123         bytes memory bytes_a = bytes(_a);
1124         bytes memory bytes_b = bytes(_b);
1125         string memory ab = new string (bytes_a.length + bytes_b.length);
1126         bytes memory bytes_ab = bytes(ab);
1127         uint k = 0;
1128         for (uint i = 0; i < bytes_a.length; i++) bytes_ab[k++] = bytes_a[i];
1129         for (i = 0; i < bytes_b.length; i++) bytes_ab[k++] = bytes_b[i];
1130         return string(bytes_ab);
1131     }
1132 
1133     // TODO: This should be a separate library: OLC.sol
1134 
1135     bytes20 constant DIGITS = bytes20('23456789CFGHJMPQRVWX');
1136     bytes20 constant STIGID = bytes20('XWVRQPMJHGFC98765432');
1137 
1138     function nextChar(byte c, bytes20 digits) private pure returns (byte) {
1139         for (uint i = 0; i < 20; i++)
1140             if (c == digits[i])
1141                 return (i == 19) ? digits[0] : digits[i+1];
1142 
1143     }
1144 
1145     function replaceChar(uint256 tokenId, uint pos, byte c) private pure returns (uint256) {
1146 
1147         uint shift = (8 - pos) * 8;
1148         uint256 insert = uint256(c) << shift;
1149         uint256 mask = ~(uint256(0xff) << shift);
1150 
1151         return tokenId & mask | insert;
1152     }
1153 
1154     function incrementChar(uint256 tokenId, int pos, bytes20 digits) private pure returns (uint256) {
1155 
1156         if (pos < 0)
1157             return tokenId;
1158 
1159         byte c = nextChar(bytes32(tokenId)[23 + uint(pos)], digits);
1160         uint256 updated = replaceChar(tokenId, uint(pos), c);
1161         if (c == digits[0]) {
1162             int nextPos = pos - 2;
1163             byte nextPosChar = bytes32(updated)[23 + uint(nextPos)];
1164             // Longitude has only 18 slices.
1165             if (nextPos == 1) {
1166                 if (digits == DIGITS && nextPosChar == 'V') {
1167                     return replaceChar(updated, uint(nextPos), '2');
1168                 }
1169                 if (digits == STIGID && nextPosChar == '2') {
1170                     return replaceChar(updated, uint(nextPos), 'V');
1171                 }
1172             }
1173             // Latitude has only 9 slices.
1174             if (nextPos == 0) {
1175                 if (digits == DIGITS && nextPosChar == 'C') {
1176                     return replaceChar(updated, uint(nextPos), '2');
1177                 }
1178                 if (digits == STIGID && nextPosChar == '2') {
1179                     return replaceChar(updated, uint(nextPos), 'C');
1180                 }
1181             }
1182             return incrementChar(updated, nextPos, digits);
1183         }
1184         return updated;
1185     }
1186 
1187     function northOfToken(uint256 tokenId) public pure returns (uint256) {
1188         return incrementChar(tokenId, 6, DIGITS);
1189     }
1190 
1191     function southOfToken(uint256 tokenId) public pure returns (uint256) {
1192         return incrementChar(tokenId, 6, STIGID);
1193     }
1194 
1195     function eastOfToken(uint256 tokenId) public pure returns (uint256) {
1196         return incrementChar(tokenId, 7, DIGITS);
1197     }
1198 
1199     function westOfToken(uint256 tokenId) public pure returns (uint256) {
1200         return incrementChar(tokenId, 7, STIGID);
1201     }
1202 
1203     function neighborsOfToken(uint256 tokenId) public pure returns (uint256[4]) {
1204         return [
1205             northOfToken(tokenId),
1206             eastOfToken(tokenId),
1207             southOfToken(tokenId),
1208             westOfToken(tokenId)
1209         ];
1210     }
1211 
1212 }