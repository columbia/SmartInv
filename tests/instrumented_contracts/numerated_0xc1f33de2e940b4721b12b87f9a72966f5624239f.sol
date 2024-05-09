1 pragma solidity ^0.4.24;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/introspection/ERC165.sol
4 
5 /**
6  * @title ERC165
7  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
8  */
9 interface ERC165 {
10 
11   /**
12    * @notice Query if a contract implements an interface
13    * @param _interfaceId The interface identifier, as specified in ERC-165
14    * @dev Interface identification is specified in ERC-165. This function
15    * uses less than 30,000 gas.
16    */
17   function supportsInterface(bytes4 _interfaceId)
18     external
19     view
20     returns (bool);
21 }
22 
23 // File: node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
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
108 // File: node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
109 
110 /**
111  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
112  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
113  */
114 contract ERC721Enumerable is ERC721Basic {
115   function totalSupply() public view returns (uint256);
116   function tokenOfOwnerByIndex(
117     address _owner,
118     uint256 _index
119   )
120     public
121     view
122     returns (uint256 _tokenId);
123 
124   function tokenByIndex(uint256 _index) public view returns (uint256);
125 }
126 
127 
128 /**
129  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
130  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
131  */
132 contract ERC721Metadata is ERC721Basic {
133   function name() external view returns (string _name);
134   function symbol() external view returns (string _symbol);
135   function tokenURI(uint256 _tokenId) public view returns (string);
136 }
137 
138 
139 /**
140  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
141  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
142  */
143 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
144 }
145 
146 // File: node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
147 
148 /**
149  * @title ERC721 token receiver interface
150  * @dev Interface for any contract that wants to support safeTransfers
151  * from ERC721 asset contracts.
152  */
153 contract ERC721Receiver {
154   /**
155    * @dev Magic value to be returned upon successful reception of an NFT
156    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
157    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
158    */
159   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
160 
161   /**
162    * @notice Handle the receipt of an NFT
163    * @dev The ERC721 smart contract calls this function on the recipient
164    * after a `safetransfer`. This function MAY throw to revert and reject the
165    * transfer. Return of other than the magic value MUST result in the
166    * transaction being reverted.
167    * Note: the contract address is always the message sender.
168    * @param _operator The address which called `safeTransferFrom` function
169    * @param _from The address which previously owned the token
170    * @param _tokenId The NFT identifier which is being transferred
171    * @param _data Additional data with no specified format
172    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
173    */
174   function onERC721Received(
175     address _operator,
176     address _from,
177     uint256 _tokenId,
178     bytes _data
179   )
180     public
181     returns(bytes4);
182 }
183 
184 // File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
185 
186 /**
187  * @title SafeMath
188  * @dev Math operations with safety checks that throw on error
189  */
190 library SafeMath {
191 
192   /**
193   * @dev Multiplies two numbers, throws on overflow.
194   */
195   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
196     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
197     // benefit is lost if 'b' is also tested.
198     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
199     if (_a == 0) {
200       return 0;
201     }
202 
203     c = _a * _b;
204     assert(c / _a == _b);
205     return c;
206   }
207 
208   /**
209   * @dev Integer division of two numbers, truncating the quotient.
210   */
211   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
212     // assert(_b > 0); // Solidity automatically throws when dividing by 0
213     // uint256 c = _a / _b;
214     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
215     return _a / _b;
216   }
217 
218   /**
219   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
220   */
221   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
222     assert(_b <= _a);
223     return _a - _b;
224   }
225 
226   /**
227   * @dev Adds two numbers, throws on overflow.
228   */
229   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
230     c = _a + _b;
231     assert(c >= _a);
232     return c;
233   }
234 }
235 
236 // File: node_modules/openzeppelin-solidity/contracts/AddressUtils.sol
237 
238 /**
239  * Utility library of inline functions on addresses
240  */
241 library AddressUtils {
242 
243   /**
244    * Returns whether the target address is a contract
245    * @dev This function will return false if invoked during the constructor of a contract,
246    * as the code is not actually created until after the constructor finishes.
247    * @param _addr address to check
248    * @return whether the target address is a contract
249    */
250   function isContract(address _addr) internal view returns (bool) {
251     uint256 size;
252     // XXX Currently there is no better way to check if there is a contract in an address
253     // than to check the size of the code at that address.
254     // See https://ethereum.stackexchange.com/a/14016/36603
255     // for more details about how this works.
256     // TODO Check this again before the Serenity release, because all addresses will be
257     // contracts then.
258     // solium-disable-next-line security/no-inline-assembly
259     assembly { size := extcodesize(_addr) }
260     return size > 0;
261   }
262 
263 }
264 
265 // File: node_modules/openzeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol
266 
267 /**
268  * @title SupportsInterfaceWithLookup
269  * @author Matt Condon (@shrugs)
270  * @dev Implements ERC165 using a lookup table.
271  */
272 contract SupportsInterfaceWithLookup is ERC165 {
273 
274   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
275   /**
276    * 0x01ffc9a7 ===
277    *   bytes4(keccak256('supportsInterface(bytes4)'))
278    */
279 
280   /**
281    * @dev a mapping of interface id to whether or not it's supported
282    */
283   mapping(bytes4 => bool) internal supportedInterfaces;
284 
285   /**
286    * @dev A contract implementing SupportsInterfaceWithLookup
287    * implement ERC165 itself
288    */
289   constructor()
290     public
291   {
292     _registerInterface(InterfaceId_ERC165);
293   }
294 
295   /**
296    * @dev implement supportsInterface(bytes4) using a lookup table
297    */
298   function supportsInterface(bytes4 _interfaceId)
299     external
300     view
301     returns (bool)
302   {
303     return supportedInterfaces[_interfaceId];
304   }
305 
306   /**
307    * @dev private method for registering an interface
308    */
309   function _registerInterface(bytes4 _interfaceId)
310     internal
311   {
312     require(_interfaceId != 0xffffffff);
313     supportedInterfaces[_interfaceId] = true;
314   }
315 }
316 
317 // File: node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
318 
319 /**
320  * @title ERC721 Non-Fungible Token Standard basic implementation
321  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
322  */
323 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
324 
325   using SafeMath for uint256;
326   using AddressUtils for address;
327 
328   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
329   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
330   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
331 
332   // Mapping from token ID to owner
333   mapping (uint256 => address) internal tokenOwner;
334 
335   // Mapping from token ID to approved address
336   mapping (uint256 => address) internal tokenApprovals;
337 
338   // Mapping from owner to number of owned token
339   mapping (address => uint256) internal ownedTokensCount;
340 
341   // Mapping from owner to operator approvals
342   mapping (address => mapping (address => bool)) internal operatorApprovals;
343 
344   constructor()
345     public
346   {
347     // register the supported interfaces to conform to ERC721 via ERC165
348     _registerInterface(InterfaceId_ERC721);
349     _registerInterface(InterfaceId_ERC721Exists);
350   }
351 
352   /**
353    * @dev Gets the balance of the specified address
354    * @param _owner address to query the balance of
355    * @return uint256 representing the amount owned by the passed address
356    */
357   function balanceOf(address _owner) public view returns (uint256) {
358     require(_owner != address(0));
359     return ownedTokensCount[_owner];
360   }
361 
362   /**
363    * @dev Gets the owner of the specified token ID
364    * @param _tokenId uint256 ID of the token to query the owner of
365    * @return owner address currently marked as the owner of the given token ID
366    */
367   function ownerOf(uint256 _tokenId) public view returns (address) {
368     address owner = tokenOwner[_tokenId];
369     require(owner != address(0));
370     return owner;
371   }
372 
373   /**
374    * @dev Returns whether the specified token exists
375    * @param _tokenId uint256 ID of the token to query the existence of
376    * @return whether the token exists
377    */
378   function exists(uint256 _tokenId) public view returns (bool) {
379     address owner = tokenOwner[_tokenId];
380     return owner != address(0);
381   }
382 
383   /**
384    * @dev Approves another address to transfer the given token ID
385    * The zero address indicates there is no approved address.
386    * There can only be one approved address per token at a given time.
387    * Can only be called by the token owner or an approved operator.
388    * @param _to address to be approved for the given token ID
389    * @param _tokenId uint256 ID of the token to be approved
390    */
391   function approve(address _to, uint256 _tokenId) public {
392     address owner = ownerOf(_tokenId);
393     require(_to != owner);
394     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
395 
396     tokenApprovals[_tokenId] = _to;
397     emit Approval(owner, _to, _tokenId);
398   }
399 
400   /**
401    * @dev Gets the approved address for a token ID, or zero if no address set
402    * @param _tokenId uint256 ID of the token to query the approval of
403    * @return address currently approved for the given token ID
404    */
405   function getApproved(uint256 _tokenId) public view returns (address) {
406     return tokenApprovals[_tokenId];
407   }
408 
409   /**
410    * @dev Sets or unsets the approval of a given operator
411    * An operator is allowed to transfer all tokens of the sender on their behalf
412    * @param _to operator address to set the approval
413    * @param _approved representing the status of the approval to be set
414    */
415   function setApprovalForAll(address _to, bool _approved) public {
416     require(_to != msg.sender);
417     operatorApprovals[msg.sender][_to] = _approved;
418     emit ApprovalForAll(msg.sender, _to, _approved);
419   }
420 
421   /**
422    * @dev Tells whether an operator is approved by a given owner
423    * @param _owner owner address which you want to query the approval of
424    * @param _operator operator address which you want to query the approval of
425    * @return bool whether the given operator is approved by the given owner
426    */
427   function isApprovedForAll(
428     address _owner,
429     address _operator
430   )
431     public
432     view
433     returns (bool)
434   {
435     return operatorApprovals[_owner][_operator];
436   }
437 
438   /**
439    * @dev Transfers the ownership of a given token ID to another address
440    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
441    * Requires the msg sender to be the owner, approved, or operator
442    * @param _from current owner of the token
443    * @param _to address to receive the ownership of the given token ID
444    * @param _tokenId uint256 ID of the token to be transferred
445   */
446   function transferFrom(
447     address _from,
448     address _to,
449     uint256 _tokenId
450   )
451     public
452   {
453     require(isApprovedOrOwner(msg.sender, _tokenId));
454     require(_from != address(0));
455     require(_to != address(0));
456 
457     clearApproval(_from, _tokenId);
458     removeTokenFrom(_from, _tokenId);
459     addTokenTo(_to, _tokenId);
460 
461     emit Transfer(_from, _to, _tokenId);
462   }
463 
464   /**
465    * @dev Safely transfers the ownership of a given token ID to another address
466    * If the target address is a contract, it must implement `onERC721Received`,
467    * which is called upon a safe transfer, and return the magic value
468    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
469    * the transfer is reverted.
470    *
471    * Requires the msg sender to be the owner, approved, or operator
472    * @param _from current owner of the token
473    * @param _to address to receive the ownership of the given token ID
474    * @param _tokenId uint256 ID of the token to be transferred
475   */
476   function safeTransferFrom(
477     address _from,
478     address _to,
479     uint256 _tokenId
480   )
481     public
482   {
483     // solium-disable-next-line arg-overflow
484     safeTransferFrom(_from, _to, _tokenId, "");
485   }
486 
487   /**
488    * @dev Safely transfers the ownership of a given token ID to another address
489    * If the target address is a contract, it must implement `onERC721Received`,
490    * which is called upon a safe transfer, and return the magic value
491    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
492    * the transfer is reverted.
493    * Requires the msg sender to be the owner, approved, or operator
494    * @param _from current owner of the token
495    * @param _to address to receive the ownership of the given token ID
496    * @param _tokenId uint256 ID of the token to be transferred
497    * @param _data bytes data to send along with a safe transfer check
498    */
499   function safeTransferFrom(
500     address _from,
501     address _to,
502     uint256 _tokenId,
503     bytes _data
504   )
505     public
506   {
507     transferFrom(_from, _to, _tokenId);
508     // solium-disable-next-line arg-overflow
509     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
510   }
511 
512   /**
513    * @dev Returns whether the given spender can transfer a given token ID
514    * @param _spender address of the spender to query
515    * @param _tokenId uint256 ID of the token to be transferred
516    * @return bool whether the msg.sender is approved for the given token ID,
517    *  is an operator of the owner, or is the owner of the token
518    */
519   function isApprovedOrOwner(
520     address _spender,
521     uint256 _tokenId
522   )
523     internal
524     view
525     returns (bool)
526   {
527     address owner = ownerOf(_tokenId);
528     // Disable solium check because of
529     // https://github.com/duaraghav8/Solium/issues/175
530     // solium-disable-next-line operator-whitespace
531     return (
532       _spender == owner ||
533       getApproved(_tokenId) == _spender ||
534       isApprovedForAll(owner, _spender)
535     );
536   }
537 
538   /**
539    * @dev Internal function to mint a new token
540    * Reverts if the given token ID already exists
541    * @param _to The address that will own the minted token
542    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
543    */
544   function _mint(address _to, uint256 _tokenId) internal {
545     require(_to != address(0));
546     addTokenTo(_to, _tokenId);
547     emit Transfer(address(0), _to, _tokenId);
548   }
549 
550   /**
551    * @dev Internal function to burn a specific token
552    * Reverts if the token does not exist
553    * @param _tokenId uint256 ID of the token being burned by the msg.sender
554    */
555   function _burn(address _owner, uint256 _tokenId) internal {
556     clearApproval(_owner, _tokenId);
557     removeTokenFrom(_owner, _tokenId);
558     emit Transfer(_owner, address(0), _tokenId);
559   }
560 
561   /**
562    * @dev Internal function to clear current approval of a given token ID
563    * Reverts if the given address is not indeed the owner of the token
564    * @param _owner owner of the token
565    * @param _tokenId uint256 ID of the token to be transferred
566    */
567   function clearApproval(address _owner, uint256 _tokenId) internal {
568     require(ownerOf(_tokenId) == _owner);
569     if (tokenApprovals[_tokenId] != address(0)) {
570       tokenApprovals[_tokenId] = address(0);
571     }
572   }
573 
574   /**
575    * @dev Internal function to add a token ID to the list of a given address
576    * @param _to address representing the new owner of the given token ID
577    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
578    */
579   function addTokenTo(address _to, uint256 _tokenId) internal {
580     require(tokenOwner[_tokenId] == address(0));
581     tokenOwner[_tokenId] = _to;
582     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
583   }
584 
585   /**
586    * @dev Internal function to remove a token ID from the list of a given address
587    * @param _from address representing the previous owner of the given token ID
588    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
589    */
590   function removeTokenFrom(address _from, uint256 _tokenId) internal {
591     require(ownerOf(_tokenId) == _from);
592     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
593     tokenOwner[_tokenId] = address(0);
594   }
595 
596   /**
597    * @dev Internal function to invoke `onERC721Received` on a target address
598    * The call is not executed if the target address is not a contract
599    * @param _from address representing the previous owner of the given token ID
600    * @param _to target address that will receive the tokens
601    * @param _tokenId uint256 ID of the token to be transferred
602    * @param _data bytes optional data to send along with the call
603    * @return whether the call correctly returned the expected magic value
604    */
605   function checkAndCallSafeTransfer(
606     address _from,
607     address _to,
608     uint256 _tokenId,
609     bytes _data
610   )
611     internal
612     returns (bool)
613   {
614     if (!_to.isContract()) {
615       return true;
616     }
617     bytes4 retval = ERC721Receiver(_to).onERC721Received(
618       msg.sender, _from, _tokenId, _data);
619     return (retval == ERC721_RECEIVED);
620   }
621 }
622 
623 // File: node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
624 
625 /**
626  * @title Full ERC721 Token
627  * This implementation includes all the required and some optional functionality of the ERC721 standard
628  * Moreover, it includes approve all functionality using operator terminology
629  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
630  */
631 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
632 
633   // Token name
634   string internal name_;
635 
636   // Token symbol
637   string internal symbol_;
638 
639   // Mapping from owner to list of owned token IDs
640   mapping(address => uint256[]) internal ownedTokens;
641 
642   // Mapping from token ID to index of the owner tokens list
643   mapping(uint256 => uint256) internal ownedTokensIndex;
644 
645   // Array with all token ids, used for enumeration
646   uint256[] internal allTokens;
647 
648   // Mapping from token id to position in the allTokens array
649   mapping(uint256 => uint256) internal allTokensIndex;
650 
651   // Optional mapping for token URIs
652   mapping(uint256 => string) internal tokenURIs;
653 
654   /**
655    * @dev Constructor function
656    */
657   constructor(string _name, string _symbol) public {
658     name_ = _name;
659     symbol_ = _symbol;
660 
661     // register the supported interfaces to conform to ERC721 via ERC165
662     _registerInterface(InterfaceId_ERC721Enumerable);
663     _registerInterface(InterfaceId_ERC721Metadata);
664   }
665 
666   /**
667    * @dev Gets the token name
668    * @return string representing the token name
669    */
670   function name() external view returns (string) {
671     return name_;
672   }
673 
674   /**
675    * @dev Gets the token symbol
676    * @return string representing the token symbol
677    */
678   function symbol() external view returns (string) {
679     return symbol_;
680   }
681 
682   /**
683    * @dev Returns an URI for a given token ID
684    * Throws if the token ID does not exist. May return an empty string.
685    * @param _tokenId uint256 ID of the token to query
686    */
687   function tokenURI(uint256 _tokenId) public view returns (string) {
688     require(exists(_tokenId));
689     return tokenURIs[_tokenId];
690   }
691 
692   /**
693    * @dev Gets the token ID at a given index of the tokens list of the requested owner
694    * @param _owner address owning the tokens list to be accessed
695    * @param _index uint256 representing the index to be accessed of the requested tokens list
696    * @return uint256 token ID at the given index of the tokens list owned by the requested address
697    */
698   function tokenOfOwnerByIndex(
699     address _owner,
700     uint256 _index
701   )
702     public
703     view
704     returns (uint256)
705   {
706     require(_index < balanceOf(_owner));
707     return ownedTokens[_owner][_index];
708   }
709 
710   /**
711    * @dev Gets the total amount of tokens stored by the contract
712    * @return uint256 representing the total amount of tokens
713    */
714   function totalSupply() public view returns (uint256) {
715     return allTokens.length;
716   }
717 
718   /**
719    * @dev Gets the token ID at a given index of all the tokens in this contract
720    * Reverts if the index is greater or equal to the total number of tokens
721    * @param _index uint256 representing the index to be accessed of the tokens list
722    * @return uint256 token ID at the given index of the tokens list
723    */
724   function tokenByIndex(uint256 _index) public view returns (uint256) {
725     require(_index < totalSupply());
726     return allTokens[_index];
727   }
728 
729   /**
730    * @dev Internal function to set the token URI for a given token
731    * Reverts if the token ID does not exist
732    * @param _tokenId uint256 ID of the token to set its URI
733    * @param _uri string URI to assign
734    */
735   function _setTokenURI(uint256 _tokenId, string _uri) internal {
736     require(exists(_tokenId));
737     tokenURIs[_tokenId] = _uri;
738   }
739 
740   /**
741    * @dev Internal function to add a token ID to the list of a given address
742    * @param _to address representing the new owner of the given token ID
743    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
744    */
745   function addTokenTo(address _to, uint256 _tokenId) internal {
746     super.addTokenTo(_to, _tokenId);
747     uint256 length = ownedTokens[_to].length;
748     ownedTokens[_to].push(_tokenId);
749     ownedTokensIndex[_tokenId] = length;
750   }
751 
752   /**
753    * @dev Internal function to remove a token ID from the list of a given address
754    * @param _from address representing the previous owner of the given token ID
755    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
756    */
757   function removeTokenFrom(address _from, uint256 _tokenId) internal {
758     super.removeTokenFrom(_from, _tokenId);
759 
760     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
761     // then delete the last slot.
762     uint256 tokenIndex = ownedTokensIndex[_tokenId];
763     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
764     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
765 
766     ownedTokens[_from][tokenIndex] = lastToken;
767     // This also deletes the contents at the last position of the array
768     ownedTokens[_from].length--;
769 
770     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
771     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
772     // the lastToken to the first position, and then dropping the element placed in the last position of the list
773 
774     ownedTokensIndex[_tokenId] = 0;
775     ownedTokensIndex[lastToken] = tokenIndex;
776   }
777 
778   /**
779    * @dev Internal function to mint a new token
780    * Reverts if the given token ID already exists
781    * @param _to address the beneficiary that will own the minted token
782    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
783    */
784   function _mint(address _to, uint256 _tokenId) internal {
785     super._mint(_to, _tokenId);
786 
787     allTokensIndex[_tokenId] = allTokens.length;
788     allTokens.push(_tokenId);
789   }
790 
791   /**
792    * @dev Internal function to burn a specific token
793    * Reverts if the token does not exist
794    * @param _owner owner of the token to burn
795    * @param _tokenId uint256 ID of the token being burned by the msg.sender
796    */
797   function _burn(address _owner, uint256 _tokenId) internal {
798     super._burn(_owner, _tokenId);
799 
800     // Clear metadata (if any)
801     if (bytes(tokenURIs[_tokenId]).length != 0) {
802       delete tokenURIs[_tokenId];
803     }
804 
805     // Reorg all tokens array
806     uint256 tokenIndex = allTokensIndex[_tokenId];
807     uint256 lastTokenIndex = allTokens.length.sub(1);
808     uint256 lastToken = allTokens[lastTokenIndex];
809 
810     allTokens[tokenIndex] = lastToken;
811     allTokens[lastTokenIndex] = 0;
812 
813     allTokens.length--;
814     allTokensIndex[_tokenId] = 0;
815     allTokensIndex[lastToken] = tokenIndex;
816   }
817 
818 }
819 
820 // File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
821 
822 /**
823  * @title Ownable
824  * @dev The Ownable contract has an owner address, and provides basic authorization control
825  * functions, this simplifies the implementation of "user permissions".
826  */
827 contract Ownable {
828   address public owner;
829 
830 
831   event OwnershipRenounced(address indexed previousOwner);
832   event OwnershipTransferred(
833     address indexed previousOwner,
834     address indexed newOwner
835   );
836 
837 
838   /**
839    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
840    * account.
841    */
842   constructor() public {
843     owner = msg.sender;
844   }
845 
846   /**
847    * @dev Throws if called by any account other than the owner.
848    */
849   modifier onlyOwner() {
850     require(msg.sender == owner);
851     _;
852   }
853 
854   /**
855    * @dev Allows the current owner to relinquish control of the contract.
856    * @notice Renouncing to ownership will leave the contract without an owner.
857    * It will not be possible to call the functions with the `onlyOwner`
858    * modifier anymore.
859    */
860   function renounceOwnership() public onlyOwner {
861     emit OwnershipRenounced(owner);
862     owner = address(0);
863   }
864 
865   /**
866    * @dev Allows the current owner to transfer control of the contract to a newOwner.
867    * @param _newOwner The address to transfer ownership to.
868    */
869   function transferOwnership(address _newOwner) public onlyOwner {
870     _transferOwnership(_newOwner);
871   }
872 
873   /**
874    * @dev Transfers control of the contract to a newOwner.
875    * @param _newOwner The address to transfer ownership to.
876    */
877   function _transferOwnership(address _newOwner) internal {
878     require(_newOwner != address(0));
879     emit OwnershipTransferred(owner, _newOwner);
880     owner = _newOwner;
881   }
882 }
883 
884 // File: node_modules/openzeppelin-solidity/contracts/access/rbac/Roles.sol
885 
886 /**
887  * @title Roles
888  * @author Francisco Giordano (@frangio)
889  * @dev Library for managing addresses assigned to a Role.
890  * See RBAC.sol for example usage.
891  */
892 library Roles {
893   struct Role {
894     mapping (address => bool) bearer;
895   }
896 
897   /**
898    * @dev give an address access to this role
899    */
900   function add(Role storage _role, address _addr)
901     internal
902   {
903     _role.bearer[_addr] = true;
904   }
905 
906   /**
907    * @dev remove an address' access to this role
908    */
909   function remove(Role storage _role, address _addr)
910     internal
911   {
912     _role.bearer[_addr] = false;
913   }
914 
915   /**
916    * @dev check if an address has this role
917    * // reverts
918    */
919   function check(Role storage _role, address _addr)
920     internal
921     view
922   {
923     require(has(_role, _addr));
924   }
925 
926   /**
927    * @dev check if an address has this role
928    * @return bool
929    */
930   function has(Role storage _role, address _addr)
931     internal
932     view
933     returns (bool)
934   {
935     return _role.bearer[_addr];
936   }
937 }
938 
939 // File: node_modules/openzeppelin-solidity/contracts/access/rbac/RBAC.sol
940 
941 /**
942  * @title RBAC (Role-Based Access Control)
943  * @author Matt Condon (@Shrugs)
944  * @dev Stores and provides setters and getters for roles and addresses.
945  * Supports unlimited numbers of roles and addresses.
946  * See //contracts/mocks/RBACMock.sol for an example of usage.
947  * This RBAC method uses strings to key roles. It may be beneficial
948  * for you to write your own implementation of this interface using Enums or similar.
949  */
950 contract RBAC {
951   using Roles for Roles.Role;
952 
953   mapping (string => Roles.Role) private roles;
954 
955   event RoleAdded(address indexed operator, string role);
956   event RoleRemoved(address indexed operator, string role);
957 
958   /**
959    * @dev reverts if addr does not have role
960    * @param _operator address
961    * @param _role the name of the role
962    * // reverts
963    */
964   function checkRole(address _operator, string _role)
965     public
966     view
967   {
968     roles[_role].check(_operator);
969   }
970 
971   /**
972    * @dev determine if addr has role
973    * @param _operator address
974    * @param _role the name of the role
975    * @return bool
976    */
977   function hasRole(address _operator, string _role)
978     public
979     view
980     returns (bool)
981   {
982     return roles[_role].has(_operator);
983   }
984 
985   /**
986    * @dev add a role to an address
987    * @param _operator address
988    * @param _role the name of the role
989    */
990   function addRole(address _operator, string _role)
991     internal
992   {
993     roles[_role].add(_operator);
994     emit RoleAdded(_operator, _role);
995   }
996 
997   /**
998    * @dev remove a role from an address
999    * @param _operator address
1000    * @param _role the name of the role
1001    */
1002   function removeRole(address _operator, string _role)
1003     internal
1004   {
1005     roles[_role].remove(_operator);
1006     emit RoleRemoved(_operator, _role);
1007   }
1008 
1009   /**
1010    * @dev modifier to scope access to a single role (uses msg.sender as addr)
1011    * @param _role the name of the role
1012    * // reverts
1013    */
1014   modifier onlyRole(string _role)
1015   {
1016     checkRole(msg.sender, _role);
1017     _;
1018   }
1019 
1020   /**
1021    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
1022    * @param _roles the names of the roles to scope access to
1023    * // reverts
1024    *
1025    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
1026    *  see: https://github.com/ethereum/solidity/issues/2467
1027    */
1028   // modifier onlyRoles(string[] _roles) {
1029   //     bool hasAnyRole = false;
1030   //     for (uint8 i = 0; i < _roles.length; i++) {
1031   //         if (hasRole(msg.sender, _roles[i])) {
1032   //             hasAnyRole = true;
1033   //             break;
1034   //         }
1035   //     }
1036 
1037   //     require(hasAnyRole);
1038 
1039   //     _;
1040   // }
1041 }
1042 
1043 // File: node_modules/openzeppelin-solidity/contracts/access/Whitelist.sol
1044 
1045 /**
1046  * @title Whitelist
1047  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
1048  * This simplifies the implementation of "user permissions".
1049  */
1050 contract Whitelist is Ownable, RBAC {
1051   string public constant ROLE_WHITELISTED = "whitelist";
1052 
1053   /**
1054    * @dev Throws if operator is not whitelisted.
1055    * @param _operator address
1056    */
1057   modifier onlyIfWhitelisted(address _operator) {
1058     checkRole(_operator, ROLE_WHITELISTED);
1059     _;
1060   }
1061 
1062   /**
1063    * @dev add an address to the whitelist
1064    * @param _operator address
1065    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
1066    */
1067   function addAddressToWhitelist(address _operator)
1068     public
1069     onlyOwner
1070   {
1071     addRole(_operator, ROLE_WHITELISTED);
1072   }
1073 
1074   /**
1075    * @dev getter to determine if address is in whitelist
1076    */
1077   function whitelist(address _operator)
1078     public
1079     view
1080     returns (bool)
1081   {
1082     return hasRole(_operator, ROLE_WHITELISTED);
1083   }
1084 
1085   /**
1086    * @dev add addresses to the whitelist
1087    * @param _operators addresses
1088    * @return true if at least one address was added to the whitelist,
1089    * false if all addresses were already in the whitelist
1090    */
1091   function addAddressesToWhitelist(address[] _operators)
1092     public
1093     onlyOwner
1094   {
1095     for (uint256 i = 0; i < _operators.length; i++) {
1096       addAddressToWhitelist(_operators[i]);
1097     }
1098   }
1099 
1100   /**
1101    * @dev remove an address from the whitelist
1102    * @param _operator address
1103    * @return true if the address was removed from the whitelist,
1104    * false if the address wasn't in the whitelist in the first place
1105    */
1106   function removeAddressFromWhitelist(address _operator)
1107     public
1108     onlyOwner
1109   {
1110     removeRole(_operator, ROLE_WHITELISTED);
1111   }
1112 
1113   /**
1114    * @dev remove addresses from the whitelist
1115    * @param _operators addresses
1116    * @return true if at least one address was removed from the whitelist,
1117    * false if all addresses weren't in the whitelist in the first place
1118    */
1119   function removeAddressesFromWhitelist(address[] _operators)
1120     public
1121     onlyOwner
1122   {
1123     for (uint256 i = 0; i < _operators.length; i++) {
1124       removeAddressFromWhitelist(_operators[i]);
1125     }
1126   }
1127 
1128 }
1129 
1130 // File: contracts/helpers/strings.sol
1131 
1132 /*
1133  * @title String & slice utility library for Solidity contracts.
1134  * @author Nick Johnson <arachnid@notdot.net>
1135  *
1136  * @dev Functionality in this library is largely implemented using an
1137  *      abstraction called a 'slice'. A slice represents a part of a string -
1138  *      anything from the entire string to a single character, or even no
1139  *      characters at all (a 0-length slice). Since a slice only has to specify
1140  *      an offset and a length, copying and manipulating slices is a lot less
1141  *      expensive than copying and manipulating the strings they reference.
1142  *
1143  *      To further reduce gas costs, most functions on slice that need to return
1144  *      a slice modify the original one instead of allocating a new one; for
1145  *      instance, `s.split(".")` will return the text up to the first '.',
1146  *      modifying s to only contain the remainder of the string after the '.'.
1147  *      In situations where you do not want to modify the original slice, you
1148  *      can make a copy first with `.copy()`, for example:
1149  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
1150  *      Solidity has no memory management, it will result in allocating many
1151  *      short-lived slices that are later discarded.
1152  *
1153  *      Functions that return two slices come in two versions: a non-allocating
1154  *      version that takes the second slice as an argument, modifying it in
1155  *      place, and an allocating version that allocates and returns the second
1156  *      slice; see `nextRune` for example.
1157  *
1158  *      Functions that have to copy string data will return strings rather than
1159  *      slices; these can be cast back to slices for further processing if
1160  *      required.
1161  *
1162  *      For convenience, some functions are provided with non-modifying
1163  *      variants that create a new slice and return both; for instance,
1164  *      `s.splitNew('.')` leaves s unmodified, and returns two values
1165  *      corresponding to the left and right parts of the string.
1166  */
1167 
1168 pragma solidity ^0.4.14;
1169 
1170 library strings {
1171     struct slice {
1172         uint _len;
1173         uint _ptr;
1174     }
1175 
1176     function memcpy(uint dest, uint src, uint len) private {
1177         // Copy word-length chunks while possible
1178         for(; len >= 32; len -= 32) {
1179             assembly {
1180                 mstore(dest, mload(src))
1181             }
1182             dest += 32;
1183             src += 32;
1184         }
1185 
1186         // Copy remaining bytes
1187         uint mask = 256 ** (32 - len) - 1;
1188         assembly {
1189             let srcpart := and(mload(src), not(mask))
1190             let destpart := and(mload(dest), mask)
1191             mstore(dest, or(destpart, srcpart))
1192         }
1193     }
1194 
1195     /*
1196      * @dev Returns a slice containing the entire string.
1197      * @param self The string to make a slice from.
1198      * @return A newly allocated slice containing the entire string.
1199      */
1200     function toSlice(string self) internal returns (slice) {
1201         uint ptr;
1202         assembly {
1203             ptr := add(self, 0x20)
1204         }
1205         return slice(bytes(self).length, ptr);
1206     }
1207 
1208     /*
1209      * @dev Returns the length of a null-terminated bytes32 string.
1210      * @param self The value to find the length of.
1211      * @return The length of the string, from 0 to 32.
1212      */
1213     function len(bytes32 self) internal returns (uint) {
1214         uint ret;
1215         if (self == 0)
1216             return 0;
1217         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
1218             ret += 16;
1219             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
1220         }
1221         if (self & 0xffffffffffffffff == 0) {
1222             ret += 8;
1223             self = bytes32(uint(self) / 0x10000000000000000);
1224         }
1225         if (self & 0xffffffff == 0) {
1226             ret += 4;
1227             self = bytes32(uint(self) / 0x100000000);
1228         }
1229         if (self & 0xffff == 0) {
1230             ret += 2;
1231             self = bytes32(uint(self) / 0x10000);
1232         }
1233         if (self & 0xff == 0) {
1234             ret += 1;
1235         }
1236         return 32 - ret;
1237     }
1238 
1239     /*
1240      * @dev Returns a slice containing the entire bytes32, interpreted as a
1241      *      null-termintaed utf-8 string.
1242      * @param self The bytes32 value to convert to a slice.
1243      * @return A new slice containing the value of the input argument up to the
1244      *         first null.
1245      */
1246     function toSliceB32(bytes32 self) internal returns (slice ret) {
1247         // Allocate space for `self` in memory, copy it there, and point ret at it
1248         assembly {
1249             let ptr := mload(0x40)
1250             mstore(0x40, add(ptr, 0x20))
1251             mstore(ptr, self)
1252             mstore(add(ret, 0x20), ptr)
1253         }
1254         ret._len = len(self);
1255     }
1256 
1257     /*
1258      * @dev Returns a new slice containing the same data as the current slice.
1259      * @param self The slice to copy.
1260      * @return A new slice containing the same data as `self`.
1261      */
1262     function copy(slice self) internal returns (slice) {
1263         return slice(self._len, self._ptr);
1264     }
1265 
1266     /*
1267      * @dev Copies a slice to a new string.
1268      * @param self The slice to copy.
1269      * @return A newly allocated string containing the slice's text.
1270      */
1271     function toString(slice self) internal returns (string) {
1272         var ret = new string(self._len);
1273         uint retptr;
1274         assembly { retptr := add(ret, 32) }
1275 
1276         memcpy(retptr, self._ptr, self._len);
1277         return ret;
1278     }
1279 
1280     /*
1281      * @dev Returns the length in runes of the slice. Note that this operation
1282      *      takes time proportional to the length of the slice; avoid using it
1283      *      in loops, and call `slice.empty()` if you only need to know whether
1284      *      the slice is empty or not.
1285      * @param self The slice to operate on.
1286      * @return The length of the slice in runes.
1287      */
1288     function len(slice self) internal returns (uint l) {
1289         // Starting at ptr-31 means the LSB will be the byte we care about
1290         var ptr = self._ptr - 31;
1291         var end = ptr + self._len;
1292         for (l = 0; ptr < end; l++) {
1293             uint8 b;
1294             assembly { b := and(mload(ptr), 0xFF) }
1295             if (b < 0x80) {
1296                 ptr += 1;
1297             } else if(b < 0xE0) {
1298                 ptr += 2;
1299             } else if(b < 0xF0) {
1300                 ptr += 3;
1301             } else if(b < 0xF8) {
1302                 ptr += 4;
1303             } else if(b < 0xFC) {
1304                 ptr += 5;
1305             } else {
1306                 ptr += 6;
1307             }
1308         }
1309     }
1310 
1311     /*
1312      * @dev Returns true if the slice is empty (has a length of 0).
1313      * @param self The slice to operate on.
1314      * @return True if the slice is empty, False otherwise.
1315      */
1316     function empty(slice self) internal returns (bool) {
1317         return self._len == 0;
1318     }
1319 
1320     /*
1321      * @dev Returns a positive number if `other` comes lexicographically after
1322      *      `self`, a negative number if it comes before, or zero if the
1323      *      contents of the two slices are equal. Comparison is done per-rune,
1324      *      on unicode codepoints.
1325      * @param self The first slice to compare.
1326      * @param other The second slice to compare.
1327      * @return The result of the comparison.
1328      */
1329     function compare(slice self, slice other) internal returns (int) {
1330         uint shortest = self._len;
1331         if (other._len < self._len)
1332             shortest = other._len;
1333 
1334         var selfptr = self._ptr;
1335         var otherptr = other._ptr;
1336         for (uint idx = 0; idx < shortest; idx += 32) {
1337             uint a;
1338             uint b;
1339             assembly {
1340                 a := mload(selfptr)
1341                 b := mload(otherptr)
1342             }
1343             if (a != b) {
1344                 // Mask out irrelevant bytes and check again
1345                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
1346                 var diff = (a & mask) - (b & mask);
1347                 if (diff != 0)
1348                     return int(diff);
1349             }
1350             selfptr += 32;
1351             otherptr += 32;
1352         }
1353         return int(self._len) - int(other._len);
1354     }
1355 
1356     /*
1357      * @dev Returns true if the two slices contain the same text.
1358      * @param self The first slice to compare.
1359      * @param self The second slice to compare.
1360      * @return True if the slices are equal, false otherwise.
1361      */
1362     function equals(slice self, slice other) internal returns (bool) {
1363         return compare(self, other) == 0;
1364     }
1365 
1366     /*
1367      * @dev Extracts the first rune in the slice into `rune`, advancing the
1368      *      slice to point to the next rune and returning `self`.
1369      * @param self The slice to operate on.
1370      * @param rune The slice that will contain the first rune.
1371      * @return `rune`.
1372      */
1373     function nextRune(slice self, slice rune) internal returns (slice) {
1374         rune._ptr = self._ptr;
1375 
1376         if (self._len == 0) {
1377             rune._len = 0;
1378             return rune;
1379         }
1380 
1381         uint leng;
1382         uint b;
1383         // Load the first byte of the rune into the LSBs of b
1384         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
1385         if (b < 0x80) {
1386             leng = 1;
1387         } else if(b < 0xE0) {
1388             leng = 2;
1389         } else if(b < 0xF0) {
1390             leng = 3;
1391         } else {
1392             leng = 4;
1393         }
1394 
1395         // Check for truncated codepoints
1396         if (leng > self._len) {
1397             rune._len = self._len;
1398             self._ptr += self._len;
1399             self._len = 0;
1400             return rune;
1401         }
1402 
1403         self._ptr += leng;
1404         self._len -= leng;
1405         rune._len = leng;
1406         return rune;
1407     }
1408 
1409     /*
1410      * @dev Returns the first rune in the slice, advancing the slice to point
1411      *      to the next rune.
1412      * @param self The slice to operate on.
1413      * @return A slice containing only the first rune from `self`.
1414      */
1415     function nextRune(slice self) internal returns (slice ret) {
1416         nextRune(self, ret);
1417     }
1418 
1419     /*
1420      * @dev Returns the number of the first codepoint in the slice.
1421      * @param self The slice to operate on.
1422      * @return The number of the first codepoint in the slice.
1423      */
1424     function ord(slice self) internal returns (uint ret) {
1425         if (self._len == 0) {
1426             return 0;
1427         }
1428 
1429         uint word;
1430         uint length;
1431         uint divisor = 2 ** 248;
1432 
1433         // Load the rune into the MSBs of b
1434         assembly { word:= mload(mload(add(self, 32))) }
1435         var b = word / divisor;
1436         if (b < 0x80) {
1437             ret = b;
1438             length = 1;
1439         } else if(b < 0xE0) {
1440             ret = b & 0x1F;
1441             length = 2;
1442         } else if(b < 0xF0) {
1443             ret = b & 0x0F;
1444             length = 3;
1445         } else {
1446             ret = b & 0x07;
1447             length = 4;
1448         }
1449 
1450         // Check for truncated codepoints
1451         if (length > self._len) {
1452             return 0;
1453         }
1454 
1455         for (uint i = 1; i < length; i++) {
1456             divisor = divisor / 256;
1457             b = (word / divisor) & 0xFF;
1458             if (b & 0xC0 != 0x80) {
1459                 // Invalid UTF-8 sequence
1460                 return 0;
1461             }
1462             ret = (ret * 64) | (b & 0x3F);
1463         }
1464 
1465         return ret;
1466     }
1467 
1468     /*
1469      * @dev Returns the keccak-256 hash of the slice.
1470      * @param self The slice to hash.
1471      * @return The hash of the slice.
1472      */
1473     function keccak(slice self) internal returns (bytes32 ret) {
1474         assembly {
1475             ret := keccak256(mload(add(self, 32)), mload(self))
1476         }
1477     }
1478 
1479     /*
1480      * @dev Returns true if `self` starts with `needle`.
1481      * @param self The slice to operate on.
1482      * @param needle The slice to search for.
1483      * @return True if the slice starts with the provided text, false otherwise.
1484      */
1485     function startsWith(slice self, slice needle) internal returns (bool) {
1486         if (self._len < needle._len) {
1487             return false;
1488         }
1489 
1490         if (self._ptr == needle._ptr) {
1491             return true;
1492         }
1493 
1494         bool equal;
1495         assembly {
1496             let length := mload(needle)
1497             let selfptr := mload(add(self, 0x20))
1498             let needleptr := mload(add(needle, 0x20))
1499             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1500         }
1501         return equal;
1502     }
1503 
1504     /*
1505      * @dev If `self` starts with `needle`, `needle` is removed from the
1506      *      beginning of `self`. Otherwise, `self` is unmodified.
1507      * @param self The slice to operate on.
1508      * @param needle The slice to search for.
1509      * @return `self`
1510      */
1511     function beyond(slice self, slice needle) internal returns (slice) {
1512         if (self._len < needle._len) {
1513             return self;
1514         }
1515 
1516         bool equal = true;
1517         if (self._ptr != needle._ptr) {
1518             assembly {
1519                 let length := mload(needle)
1520                 let selfptr := mload(add(self, 0x20))
1521                 let needleptr := mload(add(needle, 0x20))
1522                 equal := eq(sha3(selfptr, length), sha3(needleptr, length))
1523             }
1524         }
1525 
1526         if (equal) {
1527             self._len -= needle._len;
1528             self._ptr += needle._len;
1529         }
1530 
1531         return self;
1532     }
1533 
1534     /*
1535      * @dev Returns true if the slice ends with `needle`.
1536      * @param self The slice to operate on.
1537      * @param needle The slice to search for.
1538      * @return True if the slice starts with the provided text, false otherwise.
1539      */
1540     function endsWith(slice self, slice needle) internal returns (bool) {
1541         if (self._len < needle._len) {
1542             return false;
1543         }
1544 
1545         var selfptr = self._ptr + self._len - needle._len;
1546 
1547         if (selfptr == needle._ptr) {
1548             return true;
1549         }
1550 
1551         bool equal;
1552         assembly {
1553             let length := mload(needle)
1554             let needleptr := mload(add(needle, 0x20))
1555             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1556         }
1557 
1558         return equal;
1559     }
1560 
1561     /*
1562      * @dev If `self` ends with `needle`, `needle` is removed from the
1563      *      end of `self`. Otherwise, `self` is unmodified.
1564      * @param self The slice to operate on.
1565      * @param needle The slice to search for.
1566      * @return `self`
1567      */
1568     function until(slice self, slice needle) internal returns (slice) {
1569         if (self._len < needle._len) {
1570             return self;
1571         }
1572 
1573         var selfptr = self._ptr + self._len - needle._len;
1574         bool equal = true;
1575         if (selfptr != needle._ptr) {
1576             assembly {
1577                 let length := mload(needle)
1578                 let needleptr := mload(add(needle, 0x20))
1579                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1580             }
1581         }
1582 
1583         if (equal) {
1584             self._len -= needle._len;
1585         }
1586 
1587         return self;
1588     }
1589 
1590     // Returns the memory address of the first byte of the first occurrence of
1591     // `needle` in `self`, or the first byte after `self` if not found.
1592     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1593         uint ptr;
1594         uint idx;
1595 
1596         if (needlelen <= selflen) {
1597             if (needlelen <= 32) {
1598                 // Optimized assembly for 68 gas per byte on short strings
1599                 assembly {
1600                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1601                     let needledata := and(mload(needleptr), mask)
1602                     let end := add(selfptr, sub(selflen, needlelen))
1603                     ptr := selfptr
1604                     loop:
1605                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
1606                     ptr := add(ptr, 1)
1607                     jumpi(loop, lt(sub(ptr, 1), end))
1608                     ptr := add(selfptr, selflen)
1609                     exit:
1610                 }
1611                 return ptr;
1612             } else {
1613                 // For long needles, use hashing
1614                 bytes32 hash;
1615                 assembly { hash := sha3(needleptr, needlelen) }
1616                 ptr = selfptr;
1617                 for (idx = 0; idx <= selflen - needlelen; idx++) {
1618                     bytes32 testHash;
1619                     assembly { testHash := sha3(ptr, needlelen) }
1620                     if (hash == testHash)
1621                         return ptr;
1622                     ptr += 1;
1623                 }
1624             }
1625         }
1626         return selfptr + selflen;
1627     }
1628 
1629     // Returns the memory address of the first byte after the last occurrence of
1630     // `needle` in `self`, or the address of `self` if not found.
1631     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1632         uint ptr;
1633 
1634         if (needlelen <= selflen) {
1635             if (needlelen <= 32) {
1636                 // Optimized assembly for 69 gas per byte on short strings
1637                 assembly {
1638                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1639                     let needledata := and(mload(needleptr), mask)
1640                     ptr := add(selfptr, sub(selflen, needlelen))
1641                     loop:
1642                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
1643                     ptr := sub(ptr, 1)
1644                     jumpi(loop, gt(add(ptr, 1), selfptr))
1645                     ptr := selfptr
1646                     jump(exit)
1647                     ret:
1648                     ptr := add(ptr, needlelen)
1649                     exit:
1650                 }
1651                 return ptr;
1652             } else {
1653                 // For long needles, use hashing
1654                 bytes32 hash;
1655                 assembly { hash := sha3(needleptr, needlelen) }
1656                 ptr = selfptr + (selflen - needlelen);
1657                 while (ptr >= selfptr) {
1658                     bytes32 testHash;
1659                     assembly { testHash := sha3(ptr, needlelen) }
1660                     if (hash == testHash)
1661                         return ptr + needlelen;
1662                     ptr -= 1;
1663                 }
1664             }
1665         }
1666         return selfptr;
1667     }
1668 
1669     /*
1670      * @dev Modifies `self` to contain everything from the first occurrence of
1671      *      `needle` to the end of the slice. `self` is set to the empty slice
1672      *      if `needle` is not found.
1673      * @param self The slice to search and modify.
1674      * @param needle The text to search for.
1675      * @return `self`.
1676      */
1677     function find(slice self, slice needle) internal returns (slice) {
1678         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1679         self._len -= ptr - self._ptr;
1680         self._ptr = ptr;
1681         return self;
1682     }
1683 
1684     /*
1685      * @dev Modifies `self` to contain the part of the string from the start of
1686      *      `self` to the end of the first occurrence of `needle`. If `needle`
1687      *      is not found, `self` is set to the empty slice.
1688      * @param self The slice to search and modify.
1689      * @param needle The text to search for.
1690      * @return `self`.
1691      */
1692     function rfind(slice self, slice needle) internal returns (slice) {
1693         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1694         self._len = ptr - self._ptr;
1695         return self;
1696     }
1697 
1698     /*
1699      * @dev Splits the slice, setting `self` to everything after the first
1700      *      occurrence of `needle`, and `token` to everything before it. If
1701      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1702      *      and `token` is set to the entirety of `self`.
1703      * @param self The slice to split.
1704      * @param needle The text to search for in `self`.
1705      * @param token An output parameter to which the first token is written.
1706      * @return `token`.
1707      */
1708     function split(slice self, slice needle, slice token) internal returns (slice) {
1709         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1710         token._ptr = self._ptr;
1711         token._len = ptr - self._ptr;
1712         if (ptr == self._ptr + self._len) {
1713             // Not found
1714             self._len = 0;
1715         } else {
1716             self._len -= token._len + needle._len;
1717             self._ptr = ptr + needle._len;
1718         }
1719         return token;
1720     }
1721 
1722     /*
1723      * @dev Splits the slice, setting `self` to everything after the first
1724      *      occurrence of `needle`, and returning everything before it. If
1725      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1726      *      and the entirety of `self` is returned.
1727      * @param self The slice to split.
1728      * @param needle The text to search for in `self`.
1729      * @return The part of `self` up to the first occurrence of `delim`.
1730      */
1731     function split(slice self, slice needle) internal returns (slice token) {
1732         split(self, needle, token);
1733     }
1734 
1735     /*
1736      * @dev Splits the slice, setting `self` to everything before the last
1737      *      occurrence of `needle`, and `token` to everything after it. If
1738      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1739      *      and `token` is set to the entirety of `self`.
1740      * @param self The slice to split.
1741      * @param needle The text to search for in `self`.
1742      * @param token An output parameter to which the first token is written.
1743      * @return `token`.
1744      */
1745     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
1746         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1747         token._ptr = ptr;
1748         token._len = self._len - (ptr - self._ptr);
1749         if (ptr == self._ptr) {
1750             // Not found
1751             self._len = 0;
1752         } else {
1753             self._len -= token._len + needle._len;
1754         }
1755         return token;
1756     }
1757 
1758     /*
1759      * @dev Splits the slice, setting `self` to everything before the last
1760      *      occurrence of `needle`, and returning everything after it. If
1761      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1762      *      and the entirety of `self` is returned.
1763      * @param self The slice to split.
1764      * @param needle The text to search for in `self`.
1765      * @return The part of `self` after the last occurrence of `delim`.
1766      */
1767     function rsplit(slice self, slice needle) internal returns (slice token) {
1768         rsplit(self, needle, token);
1769     }
1770 
1771     /*
1772      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1773      * @param self The slice to search.
1774      * @param needle The text to search for in `self`.
1775      * @return The number of occurrences of `needle` found in `self`.
1776      */
1777     function count(slice self, slice needle) internal returns (uint cnt) {
1778         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1779         while (ptr <= self._ptr + self._len) {
1780             cnt++;
1781             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1782         }
1783     }
1784 
1785     /*
1786      * @dev Returns True if `self` contains `needle`.
1787      * @param self The slice to search.
1788      * @param needle The text to search for in `self`.
1789      * @return True if `needle` is found in `self`, false otherwise.
1790      */
1791     function contains(slice self, slice needle) internal returns (bool) {
1792         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1793     }
1794 
1795     /*
1796      * @dev Returns a newly allocated string containing the concatenation of
1797      *      `self` and `other`.
1798      * @param self The first slice to concatenate.
1799      * @param other The second slice to concatenate.
1800      * @return The concatenation of the two strings.
1801      */
1802     function concat(slice self, slice other) internal returns (string) {
1803         var ret = new string(self._len + other._len);
1804         uint retptr;
1805         assembly { retptr := add(ret, 32) }
1806         memcpy(retptr, self._ptr, self._len);
1807         memcpy(retptr + self._len, other._ptr, other._len);
1808         return ret;
1809     }
1810 
1811     /*
1812      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1813      *      newly allocated string.
1814      * @param self The delimiter to use.
1815      * @param parts A list of slices to join.
1816      * @return A newly allocated string containing all the slices in `parts`,
1817      *         joined with `self`.
1818      */
1819     function join(slice self, slice[] parts) internal returns (string) {
1820         if (parts.length == 0)
1821             return "";
1822 
1823         uint length = self._len * (parts.length - 1);
1824         for(uint i = 0; i < parts.length; i++)
1825             length += parts[i]._len;
1826 
1827         var ret = new string(length);
1828         uint retptr;
1829         assembly { retptr := add(ret, 32) }
1830 
1831         for(i = 0; i < parts.length; i++) {
1832             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1833             retptr += parts[i]._len;
1834             if (i < parts.length - 1) {
1835                 memcpy(retptr, self._ptr, self._len);
1836                 retptr += self._len;
1837             }
1838         }
1839 
1840         return ret;
1841     }
1842 }
1843 
1844 // File: contracts/ASKey.sol
1845 
1846 contract ASKey is ERC721Token, Whitelist {
1847   using strings for *;
1848 
1849   constructor (string _name, string _symbol) public ERC721Token(_name, _symbol)
1850   {
1851     addAddressToWhitelist(msg.sender);
1852   }
1853 
1854 
1855   /**
1856   * Custom accessor to create multiple tokens in a single transaction
1857   */
1858   function batchMint (
1859     address[] _to
1860   ) public onlyIfWhitelisted(msg.sender) {
1861 
1862     uint256 tokenId = totalSupply();
1863 
1864     for(uint i = 0; i < _to.length; i++) {
1865 
1866       tokenId++;
1867 
1868       super._mint(_to[i], tokenId);
1869     }
1870   }
1871 
1872   /**
1873   * Custom accessor to create a unique token
1874   */
1875   function mint (
1876     address _to
1877   ) public onlyIfWhitelisted(msg.sender) {
1878     uint256 tokenId = totalSupply() + 1;
1879     super._mint(_to, tokenId);
1880 
1881   }
1882 
1883   function tokenURI(uint _tokenId) public view returns (string _infoUrl) {
1884       string memory base = "https://vault.amnesiascanner.net/keys/metadata/0x";
1885       string memory id = uint2hexstr(_tokenId);
1886 
1887       return base.toSlice().concat(id.toSlice());
1888   }
1889 
1890   function uint2hexstr(uint i) internal pure returns (string) {
1891       if (i == 0) return "0";
1892       uint j = i;
1893       uint length;
1894       while (j != 0) {
1895           length++;
1896           j = j >> 4;
1897       }
1898       uint mask = 15;
1899       bytes memory bstr = new bytes(length);
1900       uint k = length - 1;
1901       while (i != 0){
1902           uint curr = (i & mask);
1903           bstr[k--] = curr > 9 ? byte(55 + curr) : byte(48 + curr); // 55 = 65 - 10
1904           i = i >> 4;
1905       }
1906       return string(bstr);
1907   }
1908 }