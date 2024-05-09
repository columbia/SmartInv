1 pragma solidity ^0.4.24;
2 
3 
4 
5 
6 /*
7 
8 NAMETAG TOKEN
9 
10 An ERC721 non-fungible token with the hash of your unique Alias imprinted upon it.
11 
12 Register your handle by minting a new token with that handle.
13 Then, others can send Ethereum Assets directly to you handle (not your address) by sending it to the account which holds that token!
14 
15 ________
16 
17 For example, one could register the handle @bob and then alice can use wallet services to send payments to @bob.
18 The wallet will be ask this contract which account the @bob token resides in and will send the payment there!
19 
20 */
21 
22 
23 
24 // File: contracts/util/IERC165.sol
25 
26 /**
27  * @title IERC165
28  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
29  */
30 interface IERC165 {
31 
32   /**
33    * @notice Query if a contract implements an interface
34    * @param interfaceId The interface identifier, as specified in ERC-165
35    * @dev Interface identification is specified in ERC-165. This function
36    * uses less than 30,000 gas.
37    */
38   function supportsInterface(bytes4 interfaceId)
39     external
40     view
41     returns (bool);
42 }
43 
44 // File: contracts/ERC721/IERC721.sol
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
87     bytes data
88   )
89     public;
90 }
91 
92 // File: contracts/ERC721/IERC721Receiver.sol
93 
94 /**
95  * @title ERC721 token receiver interface
96  * @dev Interface for any contract that wants to support safeTransfers
97  * from ERC721 asset contracts.
98  */
99 contract IERC721Receiver {
100   /**
101    * @notice Handle the receipt of an NFT
102    * @dev The ERC721 smart contract calls this function on the recipient
103    * after a `safeTransfer`. This function MUST return the function selector,
104    * otherwise the caller will revert the transaction. The selector to be
105    * returned can be obtained as `this.onERC721Received.selector`. This
106    * function MAY throw to revert and reject the transfer.
107    * Note: the ERC721 contract address is always the message sender.
108    * @param operator The address which called `safeTransferFrom` function
109    * @param from The address which previously owned the token
110    * @param tokenId The NFT identifier which is being transferred
111    * @param data Additional data with no specified format
112    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
113    */
114   function onERC721Received(
115     address operator,
116     address from,
117     uint256 tokenId,
118     bytes data
119   )
120     public
121     returns(bytes4);
122 }
123 
124 // File: contracts/util/SafeMath.sol
125 
126 /**
127  * @title SafeMath
128  * @dev Math operations with safety checks that throw on error
129  */
130 library SafeMath {
131 
132   /**
133   * @dev Multiplies two numbers, throws on overflow.
134   */
135   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
136     if (a == 0) {
137       return 0;
138     }
139     uint256 c = a * b;
140     assert(c / a == b);
141     return c;
142   }
143 
144   /**
145   * @dev Integer division of two numbers, truncating the quotient.
146   */
147   function div(uint256 a, uint256 b) internal pure returns (uint256) {
148     // assert(b > 0); // Solidity automatically throws when dividing by 0
149     uint256 c = a / b;
150     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
151     return c;
152   }
153 
154   /**
155   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
156   */
157   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
158     assert(b <= a);
159     return a - b;
160   }
161 
162   /**
163   * @dev Adds two numbers, throws on overflow.
164   */
165   function add(uint256 a, uint256 b) internal pure returns (uint256) {
166     uint256 c = a + b;
167     assert(c >= a);
168     return c;
169   }
170 }
171 
172 // File: contracts/util/Address.sol
173 
174 /**
175  * Utility library of inline functions on addresses
176  */
177 library Address {
178 
179   /**
180    * Returns whether the target address is a contract
181    * @dev This function will return false if invoked during the constructor of a contract,
182    * as the code is not actually created until after the constructor finishes.
183    * @param account address of the account to check
184    * @return whether the target address is a contract
185    */
186   function isContract(address account) internal view returns (bool) {
187     uint256 size;
188     // XXX Currently there is no better way to check if there is a contract in an address
189     // than to check the size of the code at that address.
190     // See https://ethereum.stackexchange.com/a/14016/36603
191     // for more details about how this works.
192     // TODO Check this again before the Serenity release, because all addresses will be
193     // contracts then.
194     // solium-disable-next-line security/no-inline-assembly
195     assembly { size := extcodesize(account) }
196     return size > 0;
197   }
198 
199 }
200 
201 // File: contracts/util/ERC165.sol
202 
203 /**
204  * @title ERC165
205  * @author Matt Condon (@shrugs)
206  * @dev Implements ERC165 using a lookup table.
207  */
208 contract ERC165 is IERC165 {
209 
210   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
211   /**
212    * 0x01ffc9a7 ===
213    *   bytes4(keccak256('supportsInterface(bytes4)'))
214    */
215 
216   /**
217    * @dev a mapping of interface id to whether or not it's supported
218    */
219   mapping(bytes4 => bool) internal _supportedInterfaces;
220 
221   /**
222    * @dev A contract implementing SupportsInterfaceWithLookup
223    * implement ERC165 itself
224    */
225   constructor()
226     public
227   {
228     _registerInterface(_InterfaceId_ERC165);
229   }
230 
231   /**
232    * @dev implement supportsInterface(bytes4) using a lookup table
233    */
234   function supportsInterface(bytes4 interfaceId)
235     external
236     view
237     returns (bool)
238   {
239     return _supportedInterfaces[interfaceId];
240   }
241 
242   /**
243    * @dev private method for registering an interface
244    */
245   function _registerInterface(bytes4 interfaceId)
246     internal
247   {
248     require(interfaceId != 0xffffffff);
249     _supportedInterfaces[interfaceId] = true;
250   }
251 }
252 
253 // File: contracts/ERC721/ERC721.sol
254 
255 /**
256  * @title ERC721 Non-Fungible Token Standard basic implementation
257  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
258  */
259 contract ERC721 is ERC165, IERC721 {
260 
261   using SafeMath for uint256;
262   using Address for address;
263 
264   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
265   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
266   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
267 
268   // Mapping from token ID to owner
269   mapping (uint256 => address) private _tokenOwner;
270 
271   // Mapping from token ID to approved address
272   mapping (uint256 => address) private _tokenApprovals;
273 
274   // Mapping from owner to number of owned token
275   mapping (address => uint256) private _ownedTokensCount;
276 
277   // Mapping from owner to operator approvals
278   mapping (address => mapping (address => bool)) private _operatorApprovals;
279 
280   bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
281   /*
282    * 0x80ac58cd ===
283    *   bytes4(keccak256('balanceOf(address)')) ^
284    *   bytes4(keccak256('ownerOf(uint256)')) ^
285    *   bytes4(keccak256('approve(address,uint256)')) ^
286    *   bytes4(keccak256('getApproved(uint256)')) ^
287    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
288    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
289    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
290    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
291    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
292    */
293 
294   constructor()
295     public
296   {
297     // register the supported interfaces to conform to ERC721 via ERC165
298     _registerInterface(_InterfaceId_ERC721);
299   }
300 
301   /**
302    * @dev Gets the balance of the specified address
303    * @param owner address to query the balance of
304    * @return uint256 representing the amount owned by the passed address
305    */
306   function balanceOf(address owner) public view returns (uint256) {
307     require(owner != address(0));
308     return _ownedTokensCount[owner];
309   }
310 
311   /**
312    * @dev Gets the owner of the specified token ID
313    * @param tokenId uint256 ID of the token to query the owner of
314    * @return owner address currently marked as the owner of the given token ID
315    */
316   function ownerOf(uint256 tokenId) public view returns (address) {
317     address owner = _tokenOwner[tokenId];
318     require(owner != address(0));
319     return owner;
320   }
321 
322   /**
323    * @dev Approves another address to transfer the given token ID
324    * The zero address indicates there is no approved address.
325    * There can only be one approved address per token at a given time.
326    * Can only be called by the token owner or an approved operator.
327    * @param to address to be approved for the given token ID
328    * @param tokenId uint256 ID of the token to be approved
329    */
330   function approve(address to, uint256 tokenId) public {
331     address owner = ownerOf(tokenId);
332     require(to != owner);
333     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
334 
335     _tokenApprovals[tokenId] = to;
336     emit Approval(owner, to, tokenId);
337   }
338 
339   /**
340    * @dev Gets the approved address for a token ID, or zero if no address set
341    * Reverts if the token ID does not exist.
342    * @param tokenId uint256 ID of the token to query the approval of
343    * @return address currently approved for the given token ID
344    */
345   function getApproved(uint256 tokenId) public view returns (address) {
346     require(_exists(tokenId));
347     return _tokenApprovals[tokenId];
348   }
349 
350   /**
351    * @dev Sets or unsets the approval of a given operator
352    * An operator is allowed to transfer all tokens of the sender on their behalf
353    * @param to operator address to set the approval
354    * @param approved representing the status of the approval to be set
355    */
356   function setApprovalForAll(address to, bool approved) public {
357     require(to != msg.sender);
358     _operatorApprovals[msg.sender][to] = approved;
359     emit ApprovalForAll(msg.sender, to, approved);
360   }
361 
362   /**
363    * @dev Tells whether an operator is approved by a given owner
364    * @param owner owner address which you want to query the approval of
365    * @param operator operator address which you want to query the approval of
366    * @return bool whether the given operator is approved by the given owner
367    */
368   function isApprovedForAll(
369     address owner,
370     address operator
371   )
372     public
373     view
374     returns (bool)
375   {
376     return _operatorApprovals[owner][operator];
377   }
378 
379   /**
380    * @dev Transfers the ownership of a given token ID to another address
381    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
382    * Requires the msg sender to be the owner, approved, or operator
383    * @param from current owner of the token
384    * @param to address to receive the ownership of the given token ID
385    * @param tokenId uint256 ID of the token to be transferred
386   */
387   function transferFrom(
388     address from,
389     address to,
390     uint256 tokenId
391   )
392     public
393   {
394     require(_isApprovedOrOwner(msg.sender, tokenId));
395     require(to != address(0));
396 
397     _clearApproval(from, tokenId);
398     _removeTokenFrom(from, tokenId);
399     _addTokenTo(to, tokenId);
400 
401     emit Transfer(from, to, tokenId);
402   }
403 
404   /**
405    * @dev Safely transfers the ownership of a given token ID to another address
406    * If the target address is a contract, it must implement `onERC721Received`,
407    * which is called upon a safe transfer, and return the magic value
408    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
409    * the transfer is reverted.
410    *
411    * Requires the msg sender to be the owner, approved, or operator
412    * @param from current owner of the token
413    * @param to address to receive the ownership of the given token ID
414    * @param tokenId uint256 ID of the token to be transferred
415   */
416   function safeTransferFrom(
417     address from,
418     address to,
419     uint256 tokenId
420   )
421     public
422   {
423     // solium-disable-next-line arg-overflow
424     safeTransferFrom(from, to, tokenId, "");
425   }
426 
427   /**
428    * @dev Safely transfers the ownership of a given token ID to another address
429    * If the target address is a contract, it must implement `onERC721Received`,
430    * which is called upon a safe transfer, and return the magic value
431    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
432    * the transfer is reverted.
433    * Requires the msg sender to be the owner, approved, or operator
434    * @param from current owner of the token
435    * @param to address to receive the ownership of the given token ID
436    * @param tokenId uint256 ID of the token to be transferred
437    * @param _data bytes data to send along with a safe transfer check
438    */
439   function safeTransferFrom(
440     address from,
441     address to,
442     uint256 tokenId,
443     bytes _data
444   )
445     public
446   {
447     transferFrom(from, to, tokenId);
448     // solium-disable-next-line arg-overflow
449     require(_checkAndCallSafeTransfer(from, to, tokenId, _data));
450   }
451 
452   /**
453    * @dev Returns whether the specified token exists
454    * @param tokenId uint256 ID of the token to query the existence of
455    * @return whether the token exists
456    */
457   function _exists(uint256 tokenId) internal view returns (bool) {
458     address owner = _tokenOwner[tokenId];
459     return owner != address(0);
460   }
461 
462   /**
463    * @dev Returns whether the given spender can transfer a given token ID
464    * @param spender address of the spender to query
465    * @param tokenId uint256 ID of the token to be transferred
466    * @return bool whether the msg.sender is approved for the given token ID,
467    *  is an operator of the owner, or is the owner of the token
468    */
469   function _isApprovedOrOwner(
470     address spender,
471     uint256 tokenId
472   )
473     internal
474     view
475     returns (bool)
476   {
477     address owner = ownerOf(tokenId);
478     // Disable solium check because of
479     // https://github.com/duaraghav8/Solium/issues/175
480     // solium-disable-next-line operator-whitespace
481     return (
482       spender == owner ||
483       getApproved(tokenId) == spender ||
484       isApprovedForAll(owner, spender)
485     );
486   }
487 
488   /**
489    * @dev Internal function to mint a new token
490    * Reverts if the given token ID already exists
491    * @param to The address that will own the minted token
492    * @param tokenId uint256 ID of the token to be minted by the msg.sender
493    */
494   function _mint(address to, uint256 tokenId) internal {
495     require(to != address(0));
496     _addTokenTo(to, tokenId);
497     emit Transfer(address(0), to, tokenId);
498   }
499 
500   /**
501    * @dev Internal function to burn a specific token
502    * Reverts if the token does not exist
503    * @param tokenId uint256 ID of the token being burned by the msg.sender
504    */
505   function _burn(address owner, uint256 tokenId) internal {
506     _clearApproval(owner, tokenId);
507     _removeTokenFrom(owner, tokenId);
508     emit Transfer(owner, address(0), tokenId);
509   }
510 
511   /**
512    * @dev Internal function to clear current approval of a given token ID
513    * Reverts if the given address is not indeed the owner of the token
514    * @param owner owner of the token
515    * @param tokenId uint256 ID of the token to be transferred
516    */
517   function _clearApproval(address owner, uint256 tokenId) internal {
518     require(ownerOf(tokenId) == owner);
519     if (_tokenApprovals[tokenId] != address(0)) {
520       _tokenApprovals[tokenId] = address(0);
521     }
522   }
523 
524   /**
525    * @dev Internal function to add a token ID to the list of a given address
526    * @param to address representing the new owner of the given token ID
527    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
528    */
529   function _addTokenTo(address to, uint256 tokenId) internal {
530     require(_tokenOwner[tokenId] == address(0));
531     _tokenOwner[tokenId] = to;
532     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
533   }
534 
535   /**
536    * @dev Internal function to remove a token ID from the list of a given address
537    * @param from address representing the previous owner of the given token ID
538    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
539    */
540   function _removeTokenFrom(address from, uint256 tokenId) internal {
541     require(ownerOf(tokenId) == from);
542     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
543     _tokenOwner[tokenId] = address(0);
544   }
545 
546   /**
547    * @dev Internal function to invoke `onERC721Received` on a target address
548    * The call is not executed if the target address is not a contract
549    * @param from address representing the previous owner of the given token ID
550    * @param to target address that will receive the tokens
551    * @param tokenId uint256 ID of the token to be transferred
552    * @param _data bytes optional data to send along with the call
553    * @return whether the call correctly returned the expected magic value
554    */
555   function _checkAndCallSafeTransfer(
556     address from,
557     address to,
558     uint256 tokenId,
559     bytes _data
560   )
561     internal
562     returns (bool)
563   {
564     if (!to.isContract()) {
565       return true;
566     }
567     bytes4 retval = IERC721Receiver(to).onERC721Received(
568       msg.sender, from, tokenId, _data);
569     return (retval == _ERC721_RECEIVED);
570   }
571 }
572 
573 // File: contracts/ERC721/IERC721Metadata.sol
574 
575 /**
576  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
577  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
578  */
579 contract IERC721Metadata is IERC721 {
580   function name() external view returns (string);
581   function symbol() external view returns (string);
582   function tokenURI(uint256 tokenId) public view returns (string);
583 }
584 
585 // File: contracts/NametagToken.sol
586 
587 
588 
589 
590 contract NametagToken  is ERC165, ERC721, IERC721Metadata {
591   // Token name
592   string internal _name;
593 
594   // Token symbol
595   string internal _symbol;
596 
597   // Optional mapping for token URIs
598   mapping(uint256 => string) private _tokenURIs;
599 
600 
601 
602     bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
603     /**
604      * 0x5b5e139f ===
605      *   bytes4(keccak256('name()')) ^
606      *   bytes4(keccak256('symbol()')) ^
607      *   bytes4(keccak256('tokenURI(uint256)'))
608      */
609 
610     /**
611      * @dev Constructor function
612      */
613     constructor(string name, string symbol) public {
614       _name = name;
615       _symbol = symbol;
616 
617       // register the supported interfaces to conform to ERC721 via ERC165
618       _registerInterface(InterfaceId_ERC721Metadata);
619     }
620 
621 
622 
623 
624 
625   function claimNametagToken(
626     address to,
627     bytes32 name
628   )
629     public
630     returns (bool)
631   {
632 
633     uint256 tokenId = (uint256) (keccak256(name));
634     string memory metadata = bytes32ToString(name);
635 
636     _mint(to, tokenId);
637     _setTokenURI(tokenId, metadata);
638     return true;
639   }
640 
641 
642   function bytes32ToTokenId(bytes32 x) public constant returns (uint256) {
643     return  (uint256) (keccak256(x));
644   }
645 
646   function bytes32ToString(bytes32 x) public constant returns (string) {
647     bytes memory bytesString = new bytes(32);
648     uint charCount = 0;
649     for (uint j = 0; j < 32; j++) {
650         byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
651         if (char != 0) {
652             bytesString[charCount] = char;
653             charCount++;
654         }
655     }
656     bytes memory bytesStringTrimmed = new bytes(charCount);
657     for (j = 0; j < charCount; j++) {
658         bytesStringTrimmed[j] = bytesString[j];
659     }
660       return string(bytesStringTrimmed);
661   }
662 
663 
664 
665   /**
666    * @dev Gets the token name
667    * @return string representing the token name
668    */
669   function name() external view returns (string) {
670     return _name;
671   }
672 
673   /**
674    * @dev Gets the token symbol
675    * @return string representing the token symbol
676    */
677   function symbol() external view returns (string) {
678     return _symbol;
679   }
680 
681 
682 
683 
684   /**
685    * @dev Returns an URI for a given token ID
686    * Throws if the token ID does not exist. May return an empty string.
687    * @param tokenId uint256 ID of the token to query
688    */
689   function tokenURI(uint256 tokenId) public view returns (string) {
690     require(_exists(tokenId));
691     return _tokenURIs[tokenId];
692   }
693 
694 
695   /**
696    * @dev Internal function to set the token URI for a given token
697    * Reverts if the token ID does not exist
698    * @param tokenId uint256 ID of the token to set its URI
699    * @param uri string URI to assign
700    */
701   function _setTokenURI(uint256 tokenId, string uri) internal {
702     require(_exists(tokenId));
703     _tokenURIs[tokenId] = uri;
704   }
705 
706   /**
707    * @dev Internal function to burn a specific token
708    * Reverts if the token does not exist
709    * @param owner owner of the token to burn
710    * @param tokenId uint256 ID of the token being burned by the msg.sender
711    */
712   function _burn(address owner, uint256 tokenId) internal {
713     super._burn(owner, tokenId);
714 
715     // Clear metadata (if any)
716     if (bytes(_tokenURIs[tokenId]).length != 0) {
717       delete _tokenURIs[tokenId];
718     }
719   }
720 
721 
722 }