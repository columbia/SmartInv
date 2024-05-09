1 /**
2  * Source Code first verified at https://etherscan.io on Thursday, March 14, 2019
3  (UTC) */
4 
5 pragma solidity ^0.4.24;
6 
7 /**
8  * @title ERC165
9  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
10  */
11 interface ERC165 {
12 
13   /**
14    * @notice Query if a contract implements an interface
15    * @param _interfaceId The interface identifier, as specified in ERC-165
16    * @dev Interface identification is specified in ERC-165. This function
17    * uses less than 30,000 gas.
18    */
19   function supportsInterface(bytes4 _interfaceId)
20     external
21     view
22     returns (bool);
23 }
24 
25 /**
26  * @title ERC721 Non-Fungible Token Standard basic interface
27  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
28  */
29 contract ERC721Basic is ERC165 {
30 
31   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
32   /*
33    * 0x80ac58cd ===
34    *   bytes4(keccak256('balanceOf(address)')) ^
35    *   bytes4(keccak256('ownerOf(uint256)')) ^
36    *   bytes4(keccak256('approve(address,uint256)')) ^
37    *   bytes4(keccak256('getApproved(uint256)')) ^
38    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
39    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
40    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
41    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
42    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
43    */
44 
45   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
46   /*
47    * 0x4f558e79 ===
48    *   bytes4(keccak256('exists(uint256)'))
49    */
50 
51   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
52   /**
53    * 0x780e9d63 ===
54    *   bytes4(keccak256('totalSupply()')) ^
55    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
56    *   bytes4(keccak256('tokenByIndex(uint256)'))
57    */
58 
59   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
60   /**
61    * 0x5b5e139f ===
62    *   bytes4(keccak256('name()')) ^
63    *   bytes4(keccak256('symbol()')) ^
64    *   bytes4(keccak256('tokenURI(uint256)'))
65    */
66 
67   event Transfer(
68     address indexed _from,
69     address indexed _to,
70     uint256 indexed _tokenId
71   );
72   event Approval(
73     address indexed _owner,
74     address indexed _approved,
75     uint256 indexed _tokenId
76   );
77   event ApprovalForAll(
78     address indexed _owner,
79     address indexed _operator,
80     bool _approved
81   );
82 
83   function balanceOf(address _owner) public view returns (uint256 _balance);
84   function ownerOf(uint256 _tokenId) public view returns (address _owner);
85   function exists(uint256 _tokenId) public view returns (bool _exists);
86 
87   function approve(address _to, uint256 _tokenId) public;
88   function getApproved(uint256 _tokenId)
89     public view returns (address _operator);
90 
91   function setApprovalForAll(address _operator, bool _approved) public;
92   function isApprovedForAll(address _owner, address _operator)
93     public view returns (bool);
94 
95   function transferFrom(address _from, address _to, uint256 _tokenId) public;
96   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
97     public;
98 
99   function safeTransferFrom(
100     address _from,
101     address _to,
102     uint256 _tokenId,
103     bytes _data
104   )
105     public;
106 }
107 
108 /**
109  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
110  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
111  */
112 contract ERC721Enumerable is ERC721Basic {
113   function totalSupply() public view returns (uint256);
114   function tokenOfOwnerByIndex(
115     address _owner,
116     uint256 _index
117   )
118     public
119     view
120     returns (uint256 _tokenId);
121 
122   function tokenByIndex(uint256 _index) public view returns (uint256);
123 }
124 
125 
126 /**
127  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
128  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
129  */
130 contract ERC721Metadata is ERC721Basic {
131   function name() external view returns (string _name);
132   function symbol() external view returns (string _symbol);
133   function tokenURI(uint256 _tokenId) public view returns (string);
134 }
135 
136 
137 /**
138  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
139  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
140  */
141 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
142 }
143 
144 /**
145  * @title ERC721 token receiver interface
146  * @dev Interface for any contract that wants to support safeTransfers
147  * from ERC721 asset contracts.
148  */
149 contract ERC721Receiver {
150   /**
151    * @dev Magic value to be returned upon successful reception of an NFT
152    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
153    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
154    */
155   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
156 
157   /**
158    * @notice Handle the receipt of an NFT
159    * @dev The ERC721 smart contract calls this function on the recipient
160    * after a `safetransfer`. This function MAY throw to revert and reject the
161    * transfer. Return of other than the magic value MUST result in the
162    * transaction being reverted.
163    * Note: the contract address is always the message sender.
164    * @param _operator The address which called `safeTransferFrom` function
165    * @param _from The address which previously owned the token
166    * @param _tokenId The NFT identifier which is being transferred
167    * @param _data Additional data with no specified format
168    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
169    */
170   function onERC721Received(
171     address _operator,
172     address _from,
173     uint256 _tokenId,
174     bytes _data
175   )
176     public
177     returns(bytes4);
178 }
179 
180 /**
181  * @title SafeMath
182  * @dev Math operations with safety checks that throw on error
183  */
184 library SafeMath {
185 
186   /**
187   * @dev Multiplies two numbers, throws on overflow.
188   */
189   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
190     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
191     // benefit is lost if 'b' is also tested.
192     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
193     if (_a == 0) {
194       return 0;
195     }
196 
197     c = _a * _b;
198     assert(c / _a == _b);
199     return c;
200   }
201 
202   /**
203   * @dev Integer division of two numbers, truncating the quotient.
204   */
205   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
206     // assert(_b > 0); // Solidity automatically throws when dividing by 0
207     // uint256 c = _a / _b;
208     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
209     return _a / _b;
210   }
211 
212   /**
213   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
214   */
215   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
216     assert(_b <= _a);
217     return _a - _b;
218   }
219 
220   /**
221   * @dev Adds two numbers, throws on overflow.
222   */
223   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
224     c = _a + _b;
225     assert(c >= _a);
226     return c;
227   }
228 }
229 
230 /**
231  * Utility library of inline functions on addresses
232  */
233 library AddressUtils {
234 
235   /**
236    * Returns whether the target address is a contract
237    * @dev This function will return false if invoked during the constructor of a contract,
238    * as the code is not actually created until after the constructor finishes.
239    * @param _addr address to check
240    * @return whether the target address is a contract
241    */
242   function isContract(address _addr) internal view returns (bool) {
243     uint256 size;
244     // XXX Currently there is no better way to check if there is a contract in an address
245     // than to check the size of the code at that address.
246     // See https://ethereum.stackexchange.com/a/14016/36603
247     // for more details about how this works.
248     // TODO Check this again before the Serenity release, because all addresses will be
249     // contracts then.
250     // solium-disable-next-line security/no-inline-assembly
251     assembly { size := extcodesize(_addr) }
252     return size > 0;
253   }
254 
255 }
256 
257 /**
258  * @title SupportsInterfaceWithLookup
259  * @author Matt Condon (@shrugs)
260  * @dev Implements ERC165 using a lookup table.
261  */
262 contract SupportsInterfaceWithLookup is ERC165 {
263 
264   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
265   /**
266    * 0x01ffc9a7 ===
267    *   bytes4(keccak256('supportsInterface(bytes4)'))
268    */
269 
270   /**
271    * @dev a mapping of interface id to whether or not it's supported
272    */
273   mapping(bytes4 => bool) internal supportedInterfaces;
274 
275   /**
276    * @dev A contract implementing SupportsInterfaceWithLookup
277    * implement ERC165 itself
278    */
279   constructor()
280     public
281   {
282     _registerInterface(InterfaceId_ERC165);
283   }
284 
285   /**
286    * @dev implement supportsInterface(bytes4) using a lookup table
287    */
288   function supportsInterface(bytes4 _interfaceId)
289     external
290     view
291     returns (bool)
292   {
293     return supportedInterfaces[_interfaceId];
294   }
295 
296   /**
297    * @dev private method for registering an interface
298    */
299   function _registerInterface(bytes4 _interfaceId)
300     internal
301   {
302     require(_interfaceId != 0xffffffff);
303     supportedInterfaces[_interfaceId] = true;
304   }
305 }
306 
307 /**
308  * @title ERC721 Non-Fungible Token Standard basic implementation
309  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
310  */
311 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
312 
313   using SafeMath for uint256;
314   using AddressUtils for address;
315 
316   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
317   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
318   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
319 
320   // Mapping from token ID to owner
321   mapping (uint256 => address) internal tokenOwner;
322 
323   // Mapping from token ID to approved address
324   mapping (uint256 => address) internal tokenApprovals;
325 
326   // Mapping from owner to number of owned token
327   mapping (address => uint256) internal ownedTokensCount;
328 
329   // Mapping from owner to operator approvals
330   mapping (address => mapping (address => bool)) internal operatorApprovals;
331 
332   constructor()
333     public
334   {
335     // register the supported interfaces to conform to ERC721 via ERC165
336     _registerInterface(InterfaceId_ERC721);
337     _registerInterface(InterfaceId_ERC721Exists);
338   }
339 
340   /**
341    * @dev Gets the balance of the specified address
342    * @param _owner address to query the balance of
343    * @return uint256 representing the amount owned by the passed address
344    */
345   function balanceOf(address _owner) public view returns (uint256) {
346     require(_owner != address(0));
347     return ownedTokensCount[_owner];
348   }
349 
350   /**
351    * @dev Gets the owner of the specified token ID
352    * @param _tokenId uint256 ID of the token to query the owner of
353    * @return owner address currently marked as the owner of the given token ID
354    */
355   function ownerOf(uint256 _tokenId) public view returns (address) {
356     address owner = tokenOwner[_tokenId];
357     require(owner != address(0));
358     return owner;
359   }
360 
361   /**
362    * @dev Returns whether the specified token exists
363    * @param _tokenId uint256 ID of the token to query the existence of
364    * @return whether the token exists
365    */
366   function exists(uint256 _tokenId) public view returns (bool) {
367     address owner = tokenOwner[_tokenId];
368     return owner != address(0);
369   }
370 
371   /**
372    * @dev Approves another address to transfer the given token ID
373    * The zero address indicates there is no approved address.
374    * There can only be one approved address per token at a given time.
375    * Can only be called by the token owner or an approved operator.
376    * @param _to address to be approved for the given token ID
377    * @param _tokenId uint256 ID of the token to be approved
378    */
379   function approve(address _to, uint256 _tokenId) public {
380     address owner = ownerOf(_tokenId);
381     require(_to != owner);
382     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
383 
384     tokenApprovals[_tokenId] = _to;
385     emit Approval(owner, _to, _tokenId);
386   }
387 
388   /**
389    * @dev Gets the approved address for a token ID, or zero if no address set
390    * @param _tokenId uint256 ID of the token to query the approval of
391    * @return address currently approved for the given token ID
392    */
393   function getApproved(uint256 _tokenId) public view returns (address) {
394     return tokenApprovals[_tokenId];
395   }
396 
397   /**
398    * @dev Sets or unsets the approval of a given operator
399    * An operator is allowed to transfer all tokens of the sender on their behalf
400    * @param _to operator address to set the approval
401    * @param _approved representing the status of the approval to be set
402    */
403   function setApprovalForAll(address _to, bool _approved) public {
404     require(_to != msg.sender);
405     operatorApprovals[msg.sender][_to] = _approved;
406     emit ApprovalForAll(msg.sender, _to, _approved);
407   }
408 
409   /**
410    * @dev Tells whether an operator is approved by a given owner
411    * @param _owner owner address which you want to query the approval of
412    * @param _operator operator address which you want to query the approval of
413    * @return bool whether the given operator is approved by the given owner
414    */
415   function isApprovedForAll(
416     address _owner,
417     address _operator
418   )
419     public
420     view
421     returns (bool)
422   {
423     return operatorApprovals[_owner][_operator];
424   }
425 
426   /**
427    * @dev Transfers the ownership of a given token ID to another address
428    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
429    * Requires the msg sender to be the owner, approved, or operator
430    * @param _from current owner of the token
431    * @param _to address to receive the ownership of the given token ID
432    * @param _tokenId uint256 ID of the token to be transferred
433   */
434   function transferFrom(
435     address _from,
436     address _to,
437     uint256 _tokenId
438   )
439     public
440   {
441     require(isApprovedOrOwner(msg.sender, _tokenId));
442     require(_from != address(0));
443     require(_to != address(0));
444 
445     clearApproval(_from, _tokenId);
446     removeTokenFrom(_from, _tokenId);
447     addTokenTo(_to, _tokenId);
448 
449     emit Transfer(_from, _to, _tokenId);
450   }
451 
452   /**
453    * @dev Safely transfers the ownership of a given token ID to another address
454    * If the target address is a contract, it must implement `onERC721Received`,
455    * which is called upon a safe transfer, and return the magic value
456    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
457    * the transfer is reverted.
458    *
459    * Requires the msg sender to be the owner, approved, or operator
460    * @param _from current owner of the token
461    * @param _to address to receive the ownership of the given token ID
462    * @param _tokenId uint256 ID of the token to be transferred
463   */
464   function safeTransferFrom(
465     address _from,
466     address _to,
467     uint256 _tokenId
468   )
469     public
470   {
471     // solium-disable-next-line arg-overflow
472     safeTransferFrom(_from, _to, _tokenId, "");
473   }
474 
475   /**
476    * @dev Safely transfers the ownership of a given token ID to another address
477    * If the target address is a contract, it must implement `onERC721Received`,
478    * which is called upon a safe transfer, and return the magic value
479    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
480    * the transfer is reverted.
481    * Requires the msg sender to be the owner, approved, or operator
482    * @param _from current owner of the token
483    * @param _to address to receive the ownership of the given token ID
484    * @param _tokenId uint256 ID of the token to be transferred
485    * @param _data bytes data to send along with a safe transfer check
486    */
487   function safeTransferFrom(
488     address _from,
489     address _to,
490     uint256 _tokenId,
491     bytes _data
492   )
493     public
494   {
495     transferFrom(_from, _to, _tokenId);
496     // solium-disable-next-line arg-overflow
497     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
498   }
499 
500   /**
501    * @dev Returns whether the given spender can transfer a given token ID
502    * @param _spender address of the spender to query
503    * @param _tokenId uint256 ID of the token to be transferred
504    * @return bool whether the msg.sender is approved for the given token ID,
505    *  is an operator of the owner, or is the owner of the token
506    */
507   function isApprovedOrOwner(
508     address _spender,
509     uint256 _tokenId
510   )
511     internal
512     view
513     returns (bool)
514   {
515     address owner = ownerOf(_tokenId);
516     // Disable solium check because of
517     // https://github.com/duaraghav8/Solium/issues/175
518     // solium-disable-next-line operator-whitespace
519     return (
520       _spender == owner ||
521       getApproved(_tokenId) == _spender ||
522       isApprovedForAll(owner, _spender)
523     );
524   }
525 
526   /**
527    * @dev Internal function to mint a new token
528    * Reverts if the given token ID already exists
529    * @param _to The address that will own the minted token
530    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
531    */
532   function _mint(address _to, uint256 _tokenId) internal {
533     require(_to != address(0));
534     addTokenTo(_to, _tokenId);
535     emit Transfer(address(0), _to, _tokenId);
536   }
537 
538   /**
539    * @dev Internal function to burn a specific token
540    * Reverts if the token does not exist
541    * @param _tokenId uint256 ID of the token being burned by the msg.sender
542    */
543   function _burn(address _owner, uint256 _tokenId) internal {
544     clearApproval(_owner, _tokenId);
545     removeTokenFrom(_owner, _tokenId);
546     emit Transfer(_owner, address(0), _tokenId);
547   }
548 
549   /**
550    * @dev Internal function to clear current approval of a given token ID
551    * Reverts if the given address is not indeed the owner of the token
552    * @param _owner owner of the token
553    * @param _tokenId uint256 ID of the token to be transferred
554    */
555   function clearApproval(address _owner, uint256 _tokenId) internal {
556     require(ownerOf(_tokenId) == _owner);
557     if (tokenApprovals[_tokenId] != address(0)) {
558       tokenApprovals[_tokenId] = address(0);
559     }
560   }
561 
562   /**
563    * @dev Internal function to add a token ID to the list of a given address
564    * @param _to address representing the new owner of the given token ID
565    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
566    */
567   function addTokenTo(address _to, uint256 _tokenId) internal {
568     require(tokenOwner[_tokenId] == address(0));
569     tokenOwner[_tokenId] = _to;
570     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
571   }
572 
573   /**
574    * @dev Internal function to remove a token ID from the list of a given address
575    * @param _from address representing the previous owner of the given token ID
576    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
577    */
578   function removeTokenFrom(address _from, uint256 _tokenId) internal {
579     require(ownerOf(_tokenId) == _from);
580     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
581     tokenOwner[_tokenId] = address(0);
582   }
583 
584   /**
585    * @dev Internal function to invoke `onERC721Received` on a target address
586    * The call is not executed if the target address is not a contract
587    * @param _from address representing the previous owner of the given token ID
588    * @param _to target address that will receive the tokens
589    * @param _tokenId uint256 ID of the token to be transferred
590    * @param _data bytes optional data to send along with the call
591    * @return whether the call correctly returned the expected magic value
592    */
593   function checkAndCallSafeTransfer(
594     address _from,
595     address _to,
596     uint256 _tokenId,
597     bytes _data
598   )
599     internal
600     returns (bool)
601   {
602     if (!_to.isContract()) {
603       return true;
604     }
605     bytes4 retval = ERC721Receiver(_to).onERC721Received(
606       msg.sender, _from, _tokenId, _data);
607     return (retval == ERC721_RECEIVED);
608   }
609 }
610 
611 /**
612  * @title Full ERC721 Token
613  * This implementation includes all the required and some optional functionality of the ERC721 standard
614  * Moreover, it includes approve all functionality using operator terminology
615  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
616  */
617 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
618 
619   // Token name
620   string internal name_;
621 
622   // Token symbol
623   string internal symbol_;
624 
625   // Mapping from owner to list of owned token IDs
626   mapping(address => uint256[]) internal ownedTokens;
627 
628   // Mapping from token ID to index of the owner tokens list
629   mapping(uint256 => uint256) internal ownedTokensIndex;
630 
631   // Array with all token ids, used for enumeration
632   uint256[] internal allTokens;
633 
634   // Mapping from token id to position in the allTokens array
635   mapping(uint256 => uint256) internal allTokensIndex;
636 
637   // Optional mapping for token URIs
638   mapping(uint256 => string) internal tokenURIs;
639 
640   /**
641    * @dev Constructor function
642    */
643   constructor(string _name, string _symbol) public {
644     name_ = _name;
645     symbol_ = _symbol;
646 
647     // register the supported interfaces to conform to ERC721 via ERC165
648     _registerInterface(InterfaceId_ERC721Enumerable);
649     _registerInterface(InterfaceId_ERC721Metadata);
650   }
651 
652   /**
653    * @dev Gets the token name
654    * @return string representing the token name
655    */
656   function name() external view returns (string) {
657     return name_;
658   }
659 
660   /**
661    * @dev Gets the token symbol
662    * @return string representing the token symbol
663    */
664   function symbol() external view returns (string) {
665     return symbol_;
666   }
667 
668   /**
669    * @dev Returns an URI for a given token ID
670    * Throws if the token ID does not exist. May return an empty string.
671    * @param _tokenId uint256 ID of the token to query
672    */
673   function tokenURI(uint256 _tokenId) public view returns (string) {
674     require(exists(_tokenId));
675     return tokenURIs[_tokenId];
676   }
677 
678   /**
679    * @dev Gets the token ID at a given index of the tokens list of the requested owner
680    * @param _owner address owning the tokens list to be accessed
681    * @param _index uint256 representing the index to be accessed of the requested tokens list
682    * @return uint256 token ID at the given index of the tokens list owned by the requested address
683    */
684   function tokenOfOwnerByIndex(
685     address _owner,
686     uint256 _index
687   )
688     public
689     view
690     returns (uint256)
691   {
692     require(_index < balanceOf(_owner));
693     return ownedTokens[_owner][_index];
694   }
695 
696   /**
697    * @dev Gets the total amount of tokens stored by the contract
698    * @return uint256 representing the total amount of tokens
699    */
700   function totalSupply() public view returns (uint256) {
701     return allTokens.length;
702   }
703 
704   /**
705    * @dev Gets the token ID at a given index of all the tokens in this contract
706    * Reverts if the index is greater or equal to the total number of tokens
707    * @param _index uint256 representing the index to be accessed of the tokens list
708    * @return uint256 token ID at the given index of the tokens list
709    */
710   function tokenByIndex(uint256 _index) public view returns (uint256) {
711     require(_index < totalSupply());
712     return allTokens[_index];
713   }
714 
715   /**
716    * @dev Internal function to set the token URI for a given token
717    * Reverts if the token ID does not exist
718    * @param _tokenId uint256 ID of the token to set its URI
719    * @param _uri string URI to assign
720    */
721   function _setTokenURI(uint256 _tokenId, string _uri) internal {
722     require(exists(_tokenId));
723     tokenURIs[_tokenId] = _uri;
724   }
725 
726   /**
727    * @dev Internal function to add a token ID to the list of a given address
728    * @param _to address representing the new owner of the given token ID
729    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
730    */
731   function addTokenTo(address _to, uint256 _tokenId) internal {
732     super.addTokenTo(_to, _tokenId);
733     uint256 length = ownedTokens[_to].length;
734     ownedTokens[_to].push(_tokenId);
735     ownedTokensIndex[_tokenId] = length;
736   }
737 
738   /**
739    * @dev Internal function to remove a token ID from the list of a given address
740    * @param _from address representing the previous owner of the given token ID
741    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
742    */
743   function removeTokenFrom(address _from, uint256 _tokenId) internal {
744     super.removeTokenFrom(_from, _tokenId);
745 
746     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
747     // then delete the last slot.
748     uint256 tokenIndex = ownedTokensIndex[_tokenId];
749     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
750     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
751 
752     ownedTokens[_from][tokenIndex] = lastToken;
753     // This also deletes the contents at the last position of the array
754     ownedTokens[_from].length--;
755 
756     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
757     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
758     // the lastToken to the first position, and then dropping the element placed in the last position of the list
759 
760     ownedTokensIndex[_tokenId] = 0;
761     ownedTokensIndex[lastToken] = tokenIndex;
762   }
763 
764   /**
765    * @dev Internal function to mint a new token
766    * Reverts if the given token ID already exists
767    * @param _to address the beneficiary that will own the minted token
768    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
769    */
770   function _mint(address _to, uint256 _tokenId) internal {
771     super._mint(_to, _tokenId);
772 
773     allTokensIndex[_tokenId] = allTokens.length;
774     allTokens.push(_tokenId);
775   }
776 
777   /**
778    * @dev Internal function to burn a specific token
779    * Reverts if the token does not exist
780    * @param _owner owner of the token to burn
781    * @param _tokenId uint256 ID of the token being burned by the msg.sender
782    */
783   function _burn(address _owner, uint256 _tokenId) internal {
784     super._burn(_owner, _tokenId);
785 
786     // Clear metadata (if any)
787     if (bytes(tokenURIs[_tokenId]).length != 0) {
788       delete tokenURIs[_tokenId];
789     }
790 
791     // Reorg all tokens array
792     uint256 tokenIndex = allTokensIndex[_tokenId];
793     uint256 lastTokenIndex = allTokens.length.sub(1);
794     uint256 lastToken = allTokens[lastTokenIndex];
795 
796     allTokens[tokenIndex] = lastToken;
797     allTokens[lastTokenIndex] = 0;
798 
799     allTokens.length--;
800     allTokensIndex[_tokenId] = 0;
801     allTokensIndex[lastToken] = tokenIndex;
802   }
803 
804 }
805 
806 contract AuctionityLiveToken is ERC721Token {
807 
808     address mintMaster;
809 
810     modifier mintMasterOnly() {
811         require (msg.sender == mintMaster, "You must be mint master");
812         _;
813     }
814 
815     event Claim(
816         address indexed _from,
817         uint256 indexed _tokenId
818     );
819 
820     constructor () public
821         ERC721Token("AuctionityLiveToken", "ALT")        
822     {
823         mintMaster = msg.sender;
824     }
825 
826     function mint(
827         address _to,
828         uint256 _tokenId
829     ) public mintMasterOnly
830     {
831         super._mint(_to, _tokenId);
832     }
833 
834     function mintAndDeposit(
835         address _to,
836         uint256 _tokenId,
837         address _ayDeposit
838     ) public mintMasterOnly
839     {
840         mint(_to, _tokenId);
841         transferFrom(_to, _ayDeposit, _tokenId);
842     }
843 
844     function updateMintMaster(
845         address _newMintMaster
846     ) public mintMasterOnly
847     {
848         mintMaster = _newMintMaster;
849     }
850 
851     function claim(
852         uint256 _tokenId
853     ) public
854     {
855         address _owner = ownerOf(_tokenId);
856         require(msg.sender == _owner, "You cannot claim someone else's token");
857 
858         transferFrom(_owner, address(0), _tokenId);
859 
860         emit Claim(_owner, _tokenId);
861     }
862 }