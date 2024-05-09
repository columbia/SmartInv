1 /*
2 
3 NAMETAG TOKEN
4 
5 V1.0.0
6 
7 An ERC721 non-fungible token with the hash of your unique lowercased Alias imprinted upon it.
8 
9 Register your handle by minting a new token with that handle.
10 Then, others can send Ethereum Assets directly to you handle (not your address) by sending it to the account which holds that token!
11 
12 ________
13 
14 For example, one could register the handle @bob and then alice can use wallet services to send payments to @bob.
15 The wallet will ask this contract which account the @bob token resides in and will send the payment to that address.
16 
17 */
18 
19 // File: contracts/util/IERC165.sol
20 
21 pragma solidity 0.5.0;
22 
23 /**
24  * @title IERC165
25  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
26  */
27 interface IERC165 {
28 
29   /**
30    * @notice Query if a contract implements an interface
31    * @param interfaceId The interface identifier, as specified in ERC-165
32    * @dev Interface identification is specified in ERC-165. This function
33    * uses less than 30,000 gas.
34    */
35   function supportsInterface(bytes4 interfaceId)
36     external
37     view
38     returns (bool);
39 }
40 
41 // File: contracts/ERC721/IERC721.sol
42 
43 pragma solidity 0.5.0;
44 
45 
46 /**
47  * @title ERC721 Non-Fungible Token Standard basic interface
48  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
49  */
50 contract IERC721 is IERC165 {
51 
52   event Transfer(
53     address indexed from,
54     address indexed to,
55     uint256 indexed tokenId
56   );
57   event Approval(
58     address indexed owner,
59     address indexed approved,
60     uint256 indexed tokenId
61   );
62   event ApprovalForAll(
63     address indexed owner,
64     address indexed operator,
65     bool approved
66   );
67 
68   function balanceOf(address owner) public view returns (uint256 balance);
69   function ownerOf(uint256 tokenId) public view returns (address owner);
70 
71   function approve(address to, uint256 tokenId) public;
72   function getApproved(uint256 tokenId)
73     public view returns (address operator);
74 
75   function setApprovalForAll(address operator, bool _approved) public;
76   function isApprovedForAll(address owner, address operator)
77     public view returns (bool);
78 
79   function transferFrom(address from, address to, uint256 tokenId) public;
80   function safeTransferFrom(address from, address to, uint256 tokenId)
81     public;
82 
83   function safeTransferFrom(
84     address from,
85     address to,
86     uint256 tokenId,
87     bytes memory data
88   )
89     public;
90 }
91 
92 // File: contracts/ERC721/IERC721Enumerable.sol
93 
94 pragma solidity 0.5.0;
95 
96 
97 /**
98  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
99  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
100  */
101 contract IERC721Enumerable is IERC721 {
102   function totalSupply() public view returns (uint256);
103   function tokenOfOwnerByIndex(
104     address owner,
105     uint256 index
106   )
107     public
108     view
109     returns (uint256 tokenId);
110 
111   function tokenByIndex(uint256 index) public view returns (uint256);
112 }
113 
114 // File: contracts/ERC721/IERC721Receiver.sol
115 
116 pragma solidity 0.5.0;
117 
118 /**
119  * @title ERC721 token receiver interface
120  * @dev Interface for any contract that wants to support safeTransfers
121  * from ERC721 asset contracts.
122  */
123 contract IERC721Receiver {
124   /**
125    * @notice Handle the receipt of an NFT
126    * @dev The ERC721 smart contract calls this function on the recipient
127    * after a `safeTransfer`. This function MUST return the function selector,
128    * otherwise the caller will revert the transaction. The selector to be
129    * returned can be obtained as `this.onERC721Received.selector`. This
130    * function MAY throw to revert and reject the transfer.
131    * Note: the ERC721 contract address is always the message sender.
132    * @param operator The address which called `safeTransferFrom` function
133    * @param from The address which previously owned the token
134    * @param tokenId The NFT identifier which is being transferred
135    * @param data Additional data with no specified format
136    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
137    */
138   function onERC721Received(
139     address operator,
140     address from,
141     uint256 tokenId,
142     bytes memory data
143   )
144     public
145     returns(bytes4);
146 }
147 
148 // File: contracts/util/SafeMath.sol
149 
150 pragma solidity 0.5.0;
151 
152 
153 /**
154  * @title SafeMath
155  * @dev Math operations with safety checks that throw on error
156  */
157 library SafeMath {
158 
159   /**
160   * @dev Multiplies two numbers, throws on overflow.
161   */
162   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
163     if (a == 0) {
164       return 0;
165     }
166     uint256 c = a * b;
167     assert(c / a == b);
168     return c;
169   }
170 
171   /**
172   * @dev Integer division of two numbers, truncating the quotient.
173   */
174   function div(uint256 a, uint256 b) internal pure returns (uint256) {
175     // assert(b > 0); // Solidity automatically throws when dividing by 0
176     uint256 c = a / b;
177     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
178     return c;
179   }
180 
181   /**
182   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
183   */
184   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
185     assert(b <= a);
186     return a - b;
187   }
188 
189   /**
190   * @dev Adds two numbers, throws on overflow.
191   */
192   function add(uint256 a, uint256 b) internal pure returns (uint256) {
193     uint256 c = a + b;
194     assert(c >= a);
195     return c;
196   }
197 }
198 
199 // File: contracts/util/Address.sol
200 
201 pragma solidity 0.5.0;
202 
203 /**
204  * Utility library of inline functions on addresses
205  */
206 library Address {
207 
208   /**
209    * Returns whether the target address is a contract
210    * @dev This function will return false if invoked during the constructor of a contract,
211    * as the code is not actually created until after the constructor finishes.
212    * @param account address of the account to check
213    * @return whether the target address is a contract
214    */
215   function isContract(address account) internal view returns (bool) {
216     uint256 size;
217     // XXX Currently there is no better way to check if there is a contract in an address
218     // than to check the size of the code at that address.
219     // See https://ethereum.stackexchange.com/a/14016/36603
220     // for more details about how this works.
221     // TODO Check this again before the Serenity release, because all addresses will be
222     // contracts then.
223     // solium-disable-next-line security/no-inline-assembly
224     assembly { size := extcodesize(account) }
225     return size > 0;
226   }
227 
228 }
229 
230 // File: contracts/util/ERC165.sol
231 
232 pragma solidity 0.5.0;
233 
234 
235 /**
236  * @title ERC165
237  * @author Matt Condon (@shrugs)
238  * @dev Implements ERC165 using a lookup table.
239  */
240 contract ERC165 is IERC165 {
241 
242   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
243   /**
244    * 0x01ffc9a7 ===
245    *   bytes4(keccak256('supportsInterface(bytes4)'))
246    */
247 
248   /**
249    * @dev a mapping of interface id to whether or not it's supported
250    */
251   mapping(bytes4 => bool) internal _supportedInterfaces;
252 
253   /**
254    * @dev A contract implementing SupportsInterfaceWithLookup
255    * implement ERC165 itself
256    */
257   constructor()
258     public
259   {
260     _registerInterface(_InterfaceId_ERC165);
261   }
262 
263   /**
264    * @dev implement supportsInterface(bytes4) using a lookup table
265    */
266   function supportsInterface(bytes4 interfaceId)
267     external
268     view
269     returns (bool)
270   {
271     return _supportedInterfaces[interfaceId];
272   }
273 
274   /**
275    * @dev private method for registering an interface
276    */
277   function _registerInterface(bytes4 interfaceId)
278     internal
279   {
280     require(interfaceId != 0xffffffff);
281     _supportedInterfaces[interfaceId] = true;
282   }
283 }
284 
285 // File: contracts/ERC721/ERC721.sol
286 
287 pragma solidity 0.5.0;
288 
289 
290  
291 
292 
293 
294 /**
295  * @title ERC721 Non-Fungible Token Standard basic implementation
296  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
297  */
298 contract ERC721 is ERC165, IERC721 {
299 
300   using SafeMath for uint256;
301   using Address for address;
302 
303   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
304   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
305   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
306 
307   // Mapping from token ID to owner
308   mapping (uint256 => address) private _tokenOwner;
309 
310   // Mapping from token ID to approved address
311   mapping (uint256 => address) private _tokenApprovals;
312 
313   // Mapping from owner to number of owned token
314   mapping (address => uint256) private _ownedTokensCount;
315 
316   // Mapping from owner to operator approvals
317   mapping (address => mapping (address => bool)) private _operatorApprovals;
318 
319   bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
320   /*
321    * 0x80ac58cd ===
322    *   bytes4(keccak256('balanceOf(address)')) ^
323    *   bytes4(keccak256('ownerOf(uint256)')) ^
324    *   bytes4(keccak256('approve(address,uint256)')) ^
325    *   bytes4(keccak256('getApproved(uint256)')) ^
326    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
327    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
328    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
329    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
330    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
331    */
332 
333   constructor()
334     public
335   {
336     // register the supported interfaces to conform to ERC721 via ERC165
337     _registerInterface(_InterfaceId_ERC721);
338   }
339 
340   /**
341    * @dev Gets the balance of the specified address
342    * @param owner address to query the balance of
343    * @return uint256 representing the amount owned by the passed address
344    */
345   function balanceOf(address owner) public view returns (uint256) {
346     require(owner != address(0));
347     return _ownedTokensCount[owner];
348   }
349 
350   /**
351    * @dev Gets the owner of the specified token ID
352    * @param tokenId uint256 ID of the token to query the owner of
353    * @return owner address currently marked as the owner of the given token ID
354    */
355   function ownerOf(uint256 tokenId) public view returns (address) {
356     address owner = _tokenOwner[tokenId];
357     require(owner != address(0));
358     return owner;
359   }
360 
361   /**
362    * @dev Approves another address to transfer the given token ID
363    * The zero address indicates there is no approved address.
364    * There can only be one approved address per token at a given time.
365    * Can only be called by the token owner or an approved operator.
366    * @param to address to be approved for the given token ID
367    * @param tokenId uint256 ID of the token to be approved
368    */
369   function approve(address to, uint256 tokenId) public {
370     address owner = ownerOf(tokenId);
371     require(to != owner);
372     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
373 
374     _tokenApprovals[tokenId] = to;
375     emit Approval(owner, to, tokenId);
376   }
377 
378   /**
379    * @dev Gets the approved address for a token ID, or zero if no address set
380    * Reverts if the token ID does not exist.
381    * @param tokenId uint256 ID of the token to query the approval of
382    * @return address currently approved for the given token ID
383    */
384   function getApproved(uint256 tokenId) public view returns (address) {
385     require(_exists(tokenId));
386     return _tokenApprovals[tokenId];
387   }
388 
389   /**
390    * @dev Sets or unsets the approval of a given operator
391    * An operator is allowed to transfer all tokens of the sender on their behalf
392    * @param to operator address to set the approval
393    * @param approved representing the status of the approval to be set
394    */
395   function setApprovalForAll(address to, bool approved) public {
396     require(to != msg.sender);
397     _operatorApprovals[msg.sender][to] = approved;
398     emit ApprovalForAll(msg.sender, to, approved);
399   }
400 
401   /**
402    * @dev Tells whether an operator is approved by a given owner
403    * @param owner owner address which you want to query the approval of
404    * @param operator operator address which you want to query the approval of
405    * @return bool whether the given operator is approved by the given owner
406    */
407   function isApprovedForAll(
408     address owner,
409     address operator
410   )
411     public
412     view
413     returns (bool)
414   {
415     return _operatorApprovals[owner][operator];
416   }
417 
418   /**
419    * @dev Transfers the ownership of a given token ID to another address
420    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
421    * Requires the msg sender to be the owner, approved, or operator
422    * @param from current owner of the token
423    * @param to address to receive the ownership of the given token ID
424    * @param tokenId uint256 ID of the token to be transferred
425   */
426   function transferFrom(
427     address from,
428     address to,
429     uint256 tokenId
430   )
431     public
432   {
433     require(_isApprovedOrOwner(msg.sender, tokenId));
434     require(to != address(0));
435 
436     _clearApproval(from, tokenId);
437     _removeTokenFrom(from, tokenId);
438     _addTokenTo(to, tokenId);
439 
440     emit Transfer(from, to, tokenId);
441   }
442 
443   /**
444    * @dev Safely transfers the ownership of a given token ID to another address
445    * If the target address is a contract, it must implement `onERC721Received`,
446    * which is called upon a safe transfer, and return the magic value
447    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
448    * the transfer is reverted.
449    *
450    * Requires the msg sender to be the owner, approved, or operator
451    * @param from current owner of the token
452    * @param to address to receive the ownership of the given token ID
453    * @param tokenId uint256 ID of the token to be transferred
454   */
455   function safeTransferFrom(
456     address from,
457     address to,
458     uint256 tokenId
459   )
460     public
461   {
462     // solium-disable-next-line arg-overflow
463     safeTransferFrom(from, to, tokenId, "");
464   }
465 
466   /**
467    * @dev Safely transfers the ownership of a given token ID to another address
468    * If the target address is a contract, it must implement `onERC721Received`,
469    * which is called upon a safe transfer, and return the magic value
470    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
471    * the transfer is reverted.
472    * Requires the msg sender to be the owner, approved, or operator
473    * @param from current owner of the token
474    * @param to address to receive the ownership of the given token ID
475    * @param tokenId uint256 ID of the token to be transferred
476    * @param _data bytes data to send along with a safe transfer check
477    */
478   function safeTransferFrom(
479     address from,
480     address to,
481     uint256 tokenId,
482     bytes memory _data
483   )
484     public
485   {
486     transferFrom(from, to, tokenId);
487     // solium-disable-next-line arg-overflow
488     require(_checkAndCallSafeTransfer(from, to, tokenId, _data));
489   }
490 
491   /**
492    * @dev Returns whether the specified token exists
493    * @param tokenId uint256 ID of the token to query the existence of
494    * @return whether the token exists
495    */
496   function _exists(uint256 tokenId) internal view returns (bool) {
497     address owner = _tokenOwner[tokenId];
498     return owner != address(0);
499   }
500 
501   /**
502    * @dev Returns whether the given spender can transfer a given token ID
503    * @param spender address of the spender to query
504    * @param tokenId uint256 ID of the token to be transferred
505    * @return bool whether the msg.sender is approved for the given token ID,
506    *  is an operator of the owner, or is the owner of the token
507    */
508   function _isApprovedOrOwner(
509     address spender,
510     uint256 tokenId
511   )
512     internal
513     view
514     returns (bool)
515   {
516     address owner = ownerOf(tokenId);
517     // Disable solium check because of
518     // https://github.com/duaraghav8/Solium/issues/175
519     // solium-disable-next-line operator-whitespace
520     return (
521       spender == owner ||
522       getApproved(tokenId) == spender ||
523       isApprovedForAll(owner, spender)
524     );
525   }
526 
527   /**
528    * @dev Internal function to mint a new token
529    * Reverts if the given token ID already exists
530    * @param to The address that will own the minted token
531    * @param tokenId uint256 ID of the token to be minted by the msg.sender
532    */
533   function _mint(address to, uint256 tokenId) internal {
534     require(to != address(0));
535     _addTokenTo(to, tokenId);
536     emit Transfer(address(0), to, tokenId);
537   }
538 
539   /**
540    * @dev Internal function to burn a specific token
541    * Reverts if the token does not exist
542    * @param tokenId uint256 ID of the token being burned by the msg.sender
543    */
544   function _burn(address owner, uint256 tokenId) internal {
545     _clearApproval(owner, tokenId);
546     _removeTokenFrom(owner, tokenId);
547     emit Transfer(owner, address(0), tokenId);
548   }
549 
550   /**
551    * @dev Internal function to clear current approval of a given token ID
552    * Reverts if the given address is not indeed the owner of the token
553    * @param owner owner of the token
554    * @param tokenId uint256 ID of the token to be transferred
555    */
556   function _clearApproval(address owner, uint256 tokenId) internal {
557     require(ownerOf(tokenId) == owner);
558     if (_tokenApprovals[tokenId] != address(0)) {
559       _tokenApprovals[tokenId] = address(0);
560     }
561   }
562 
563   /**
564    * @dev Internal function to add a token ID to the list of a given address
565    * @param to address representing the new owner of the given token ID
566    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
567    */
568   function _addTokenTo(address to, uint256 tokenId) internal {
569     require(_tokenOwner[tokenId] == address(0));
570     _tokenOwner[tokenId] = to;
571     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
572   }
573 
574   /**
575    * @dev Internal function to remove a token ID from the list of a given address
576    * @param from address representing the previous owner of the given token ID
577    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
578    */
579   function _removeTokenFrom(address from, uint256 tokenId) internal {
580     require(ownerOf(tokenId) == from);
581     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
582     _tokenOwner[tokenId] = address(0);
583   }
584 
585   /**
586    * @dev Internal function to invoke `onERC721Received` on a target address
587    * The call is not executed if the target address is not a contract
588    * @param from address representing the previous owner of the given token ID
589    * @param to target address that will receive the tokens
590    * @param tokenId uint256 ID of the token to be transferred
591    * @param _data bytes optional data to send along with the call
592    * @return whether the call correctly returned the expected magic value
593    */
594   function _checkAndCallSafeTransfer(
595     address from,
596     address to,
597     uint256 tokenId,
598     bytes memory _data
599   )
600     internal
601     returns (bool)
602   {
603     if (!to.isContract()) {
604       return true;
605     }
606     bytes4 retval = IERC721Receiver(to).onERC721Received(
607       msg.sender, from, tokenId, _data);
608     return (retval == _ERC721_RECEIVED);
609   }
610 }
611 
612 // File: contracts/ERC721/ERC721Enumerable.sol
613 
614 pragma solidity 0.5.0;
615 
616 
617 
618 
619 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
620   // Mapping from owner to list of owned token IDs
621   mapping(address => uint256[]) private _ownedTokens;
622 
623   // Mapping from token ID to index of the owner tokens list
624   mapping(uint256 => uint256) private _ownedTokensIndex;
625 
626   // Array with all token ids, used for enumeration
627   uint256[] private _allTokens;
628 
629   // Mapping from token id to position in the allTokens array
630   mapping(uint256 => uint256) private _allTokensIndex;
631 
632   bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;
633   /**
634    * 0x780e9d63 ===
635    *   bytes4(keccak256('totalSupply()')) ^
636    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
637    *   bytes4(keccak256('tokenByIndex(uint256)'))
638    */
639 
640   /**
641    * @dev Constructor function
642    */
643   constructor() public {
644     // register the supported interface to conform to ERC721 via ERC165
645     _registerInterface(_InterfaceId_ERC721Enumerable);
646   }
647 
648   /**
649    * @dev Gets the token ID at a given index of the tokens list of the requested owner
650    * @param owner address owning the tokens list to be accessed
651    * @param index uint256 representing the index to be accessed of the requested tokens list
652    * @return uint256 token ID at the given index of the tokens list owned by the requested address
653    */
654   function tokenOfOwnerByIndex(
655     address owner,
656     uint256 index
657   )
658     public
659     view
660     returns (uint256)
661   {
662     require(index < balanceOf(owner));
663     return _ownedTokens[owner][index];
664   }
665 
666   /**
667    * @dev Gets the total amount of tokens stored by the contract
668    * @return uint256 representing the total amount of tokens
669    */
670   function totalSupply() public view returns (uint256) {
671     return _allTokens.length;
672   }
673 
674   /**
675    * @dev Gets the token ID at a given index of all the tokens in this contract
676    * Reverts if the index is greater or equal to the total number of tokens
677    * @param index uint256 representing the index to be accessed of the tokens list
678    * @return uint256 token ID at the given index of the tokens list
679    */
680   function tokenByIndex(uint256 index) public view returns (uint256) {
681     require(index < totalSupply());
682     return _allTokens[index];
683   }
684 
685   /**
686    * @dev Internal function to add a token ID to the list of a given address
687    * @param to address representing the new owner of the given token ID
688    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
689    */
690   function _addTokenTo(address to, uint256 tokenId) internal {
691     super._addTokenTo(to, tokenId);
692     uint256 length = _ownedTokens[to].length;
693     _ownedTokens[to].push(tokenId);
694     _ownedTokensIndex[tokenId] = length;
695   }
696 
697   /**
698    * @dev Internal function to remove a token ID from the list of a given address
699    * @param from address representing the previous owner of the given token ID
700    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
701    */
702   function _removeTokenFrom(address from, uint256 tokenId) internal {
703     super._removeTokenFrom(from, tokenId);
704 
705     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
706     // then delete the last slot.
707     uint256 tokenIndex = _ownedTokensIndex[tokenId];
708     uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
709     uint256 lastToken = _ownedTokens[from][lastTokenIndex];
710 
711     _ownedTokens[from][tokenIndex] = lastToken;
712     // This also deletes the contents at the last position of the array
713     _ownedTokens[from].length--;
714 
715     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
716     // be zero. Then we can make sure that we will remove tokenId from the ownedTokens list since we are first swapping
717     // the lastToken to the first position, and then dropping the element placed in the last position of the list
718 
719     _ownedTokensIndex[tokenId] = 0;
720     _ownedTokensIndex[lastToken] = tokenIndex;
721   }
722 
723   /**
724    * @dev Internal function to mint a new token
725    * Reverts if the given token ID already exists
726    * @param to address the beneficiary that will own the minted token
727    * @param tokenId uint256 ID of the token to be minted by the msg.sender
728    */
729   function _mint(address to, uint256 tokenId) internal {
730     super._mint(to, tokenId);
731 
732     _allTokensIndex[tokenId] = _allTokens.length;
733     _allTokens.push(tokenId);
734   }
735 
736   /**
737    * @dev Internal function to burn a specific token
738    * Reverts if the token does not exist
739    * @param owner owner of the token to burn
740    * @param tokenId uint256 ID of the token being burned by the msg.sender
741    */
742   function _burn(address owner, uint256 tokenId) internal {
743     super._burn(owner, tokenId);
744 
745     // Reorg all tokens array
746     uint256 tokenIndex = _allTokensIndex[tokenId];
747     uint256 lastTokenIndex = _allTokens.length.sub(1);
748     uint256 lastToken = _allTokens[lastTokenIndex];
749 
750     _allTokens[tokenIndex] = lastToken;
751     _allTokens[lastTokenIndex] = 0;
752 
753     _allTokens.length--;
754     _allTokensIndex[tokenId] = 0;
755     _allTokensIndex[lastToken] = tokenIndex;
756   }
757 }
758 
759 // File: contracts/ERC721/IERC721Metadata.sol
760 
761 pragma solidity 0.5.0;
762 
763 
764 /**
765  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
766  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
767  */
768 contract IERC721Metadata is IERC721 {
769   function name() external view returns (string memory name);
770   function symbol() external view returns (string memory symbol);
771   function tokenURI(uint256 tokenId) public view returns (string memory uri);
772 }
773 
774 // File: contracts/NametagToken.sol
775 
776 pragma solidity 0.5.0;
777 
778 
779 
780 
781 
782 /*
783 
784 NAMETAG TOKEN
785 
786 An ERC721 non-fungible token with the hash of your unique lowercased Alias imprinted upon it.
787 
788 Register your handle by minting a new token with that handle.
789 Then, others can send Ethereum Assets directly to you handle (not your address) by sending it to the account which holds that token!
790 
791 ________
792 
793 For example, one could register the handle @bob and then alice can use wallet services to send payments to @bob.
794 The wallet will be ask this contract which account the @bob token resides in and will send the payment there!
795 
796 */
797 
798 
799 
800 contract NametagToken  is ERC721Enumerable, IERC721Metadata {
801   // Token name
802   string internal _name = 'NametagToken';
803 
804   // Token symbol
805   string internal _symbol = 'NTT';
806 
807   // Optional mapping for token URIs
808   mapping(uint256 => string) private _tokenURIs;
809   mapping(uint256 => address) private reservedTokenId;
810 
811 
812     bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
813     /**
814      * 0x5b5e139f ===
815      *   bytes4(keccak256('name()')) ^
816      *   bytes4(keccak256('symbol()')) ^
817      *   bytes4(keccak256('tokenURI(uint256)'))
818      */
819 
820     /**
821      * @dev Constructor function
822      */
823     constructor( ) public {
824 
825       // register the supported interfaces to conform to ERC721 via ERC165
826       _registerInterface(InterfaceId_ERC721Metadata);
827     }
828 
829 
830   function reserveToken( address to, uint256 tokenId ) public  returns (bool)
831   {
832       reservedTokenId[tokenId] = to;
833       return true;
834   }
835 
836 
837   function claimToken( address to,  string memory name  ) public  returns (bool)
838   {
839     require(containsOnlyLower(name));
840  
841     uint256 tokenId = (uint256) (keccak256(abi.encodePacked(name)));
842 
843     require( reservedTokenId[tokenId] == address(0x0) || reservedTokenId[tokenId] == to  );
844 
845     _mint(to, tokenId);
846     _setTokenURI(tokenId, name);
847     return true;
848   }
849 
850 
851   function nameToTokenId(string memory name) public view returns (uint256) {
852 
853     string memory lowerName = _toLower(name);
854 
855     return  (uint256) (keccak256(abi.encodePacked(lowerName)));
856   }
857 
858   function containsOnlyAlphaNumerics(string memory str) public view returns (bool) {
859       bytes memory bStr = bytes(str);
860 
861       for (uint i = 0; i < bStr.length; i++) {
862           bytes1  char = bStr[i];
863 
864           if ( !( ((char >= 0x30) && (char <= 0x39))
865                 || ((char >= 0x41) && (char <= 0x5A))
866                   || ((char >= 0x61) && (char <= 0x7A)) )   ) {
867           return false;
868         }
869       }
870 
871       return true;
872 
873     }
874 
875     function containsOnlyLower(string memory str) public view returns (bool) {
876         bytes memory bStr = bytes(str);
877 
878         for (uint i = 0; i < bStr.length; i++) {
879             bytes1   char = bStr[i];
880 
881             if ( !((char >= 0x61) && (char <= 0x7A))   ) {
882             return false;
883           }
884         }
885 
886         return true;
887 
888       }
889 
890     /**
891         * Lower
892         *
893         * Converts all the values of a string to their corresponding lower case
894         * value.
895         *
896         * @param _base When being used for a data type this is the extended object
897         *              otherwise this is the string base to convert to lower case
898         * @return string
899         */
900        function _toLower(string memory  _base)
901            internal
902            pure
903            returns (string memory str) {
904            bytes memory _baseBytes = bytes(_base);
905            for (uint i = 0; i < _baseBytes.length; i++) {
906                _baseBytes[i] = _lower(_baseBytes[i]);
907            }
908            return string(_baseBytes);
909        }
910 
911 
912     /**
913     * Lower
914     *
915     * Convert an alphabetic character to lower case and return the original
916     * value when not alphabetic
917     *
918     * @param _b1 The byte to be converted to lower case
919     * @return bytes1 The converted value if the passed value was alphabetic
920     *                and in a upper case otherwise returns the original value
921     */
922    function _lower(bytes1 _b1)
923        private
924        pure
925        returns (bytes1) {
926 
927        if (_b1 >= 0x41 && _b1 <= 0x5A) {
928            return bytes1(uint8(_b1)+32);
929        }
930 
931        return _b1;
932    }
933 
934 
935 
936   /**
937    * @dev Gets the token name
938    * @return string representing the token name
939    */
940   function name() external view returns (string memory name) {
941     return _name;
942   }
943 
944   /**
945    * @dev Gets the token symbol
946    * @return string representing the token symbol
947    */
948    function symbol() external view returns (string memory symbol) {
949       return _symbol;
950    }
951 
952 
953 
954 
955   /**
956    * @dev Returns an URI for a given token ID
957    * Throws if the token ID does not exist. May return an empty string.
958    * @param tokenId uint256 ID of the token to query
959    */
960   function tokenURI(uint256 tokenId) public view returns (string memory uti) {
961     require(_exists(tokenId));
962     return _tokenURIs[tokenId];
963   }
964 
965 
966   /**
967    * @dev Internal function to set the token URI for a given token
968    * Reverts if the token ID does not exist
969    * @param tokenId uint256 ID of the token to set its URI
970    * @param uri string URI to assign
971    */
972   function _setTokenURI(uint256 tokenId, string memory uri) internal {
973     require(_exists(tokenId));
974     _tokenURIs[tokenId] = uri;
975   }
976 
977   /**
978    * @dev Internal function to burn a specific token
979    * Reverts if the token does not exist
980    * @param owner owner of the token to burn
981    * @param tokenId uint256 ID of the token being burned by the msg.sender
982    */
983   function _burn(address owner, uint256 tokenId) internal {
984     super._burn(owner, tokenId);
985 
986     // Clear metadata (if any)
987     if (bytes(_tokenURIs[tokenId]).length != 0) {
988       delete _tokenURIs[tokenId];
989     }
990   }
991 
992 
993 }