1 pragma solidity ^0.4.24;
2 
3 // File: zeppelin-solidity/contracts/introspection/ERC165.sol
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
23 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
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
108 // File: zeppelin-solidity/contracts/token/ERC721/ERC721.sol
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
146 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
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
184 // File: zeppelin-solidity/contracts/math/SafeMath.sol
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
236 // File: zeppelin-solidity/contracts/AddressUtils.sol
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
265 // File: zeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol
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
317 // File: zeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
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
623 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
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
820 // File: @ensdomains/ens/contracts/Deed.sol
821 
822 /**
823  * @title Deed to hold ether in exchange for ownership of a node
824  * @dev The deed can be controlled only by the registrar and can only send ether back to the owner.
825  */
826 contract Deed {
827 
828     address constant burn = 0xdead;
829 
830     address public registrar;
831     address public owner;
832     address public previousOwner;
833 
834     uint public creationDate;
835     uint public value;
836 
837     bool active;
838 
839     event OwnerChanged(address newOwner);
840     event DeedClosed();
841 
842     modifier onlyRegistrar {
843         require(msg.sender == registrar);
844         _;
845     }
846 
847     modifier onlyActive {
848         require(active);
849         _;
850     }
851 
852     function Deed(address _owner) public payable {
853         owner = _owner;
854         registrar = msg.sender;
855         creationDate = now;
856         active = true;
857         value = msg.value;
858     }
859 
860     function setOwner(address newOwner) public onlyRegistrar {
861         require(newOwner != 0);
862         previousOwner = owner;  // This allows contracts to check who sent them the ownership
863         owner = newOwner;
864         OwnerChanged(newOwner);
865     }
866 
867     function setRegistrar(address newRegistrar) public onlyRegistrar {
868         registrar = newRegistrar;
869     }
870 
871     function setBalance(uint newValue, bool throwOnFailure) public onlyRegistrar onlyActive {
872         // Check if it has enough balance to set the value
873         require(value >= newValue);
874         value = newValue;
875         // Send the difference to the owner
876         require(owner.send(this.balance - newValue) || !throwOnFailure);
877     }
878 
879     /**
880      * @dev Close a deed and refund a specified fraction of the bid value
881      *
882      * @param refundRatio The amount*1/1000 to refund
883      */
884     function closeDeed(uint refundRatio) public onlyRegistrar onlyActive {
885         active = false;
886         require(burn.send(((1000 - refundRatio) * this.balance)/1000));
887         DeedClosed();
888         destroyDeed();
889     }
890 
891     /**
892      * @dev Close a deed and refund a specified fraction of the bid value
893      */
894     function destroyDeed() public {
895         require(!active);
896 
897         // Instead of selfdestruct(owner), invoke owner fallback function to allow
898         // owner to log an event if desired; but owner should also be aware that
899         // its fallback function can also be invoked by setBalance
900         if (owner.send(this.balance)) {
901             selfdestruct(burn);
902         }
903     }
904 }
905 
906 // File: @ensdomains/ens/contracts/ENS.sol
907 
908 interface ENS {
909 
910     // Logged when the owner of a node assigns a new owner to a subnode.
911     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
912 
913     // Logged when the owner of a node transfers ownership to a new account.
914     event Transfer(bytes32 indexed node, address owner);
915 
916     // Logged when the resolver for a node changes.
917     event NewResolver(bytes32 indexed node, address resolver);
918 
919     // Logged when the TTL of a node changes
920     event NewTTL(bytes32 indexed node, uint64 ttl);
921 
922 
923     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) public;
924     function setResolver(bytes32 node, address resolver) public;
925     function setOwner(bytes32 node, address owner) public;
926     function setTTL(bytes32 node, uint64 ttl) public;
927     function owner(bytes32 node) public view returns (address);
928     function resolver(bytes32 node) public view returns (address);
929     function ttl(bytes32 node) public view returns (uint64);
930 
931 }
932 
933 // File: @ensdomains/ens/contracts/HashRegistrarSimplified.sol
934 
935 /*
936 
937 Temporary Hash Registrar
938 ========================
939 
940 This is a simplified version of a hash registrar. It is purporsefully limited:
941 names cannot be six letters or shorter, new auctions will stop after 4 years.
942 
943 The plan is to test the basic features and then move to a new contract in at most
944 2 years, when some sort of renewal mechanism will be enabled.
945 */
946 
947 
948 
949 /**
950  * @title Registrar
951  * @dev The registrar handles the auction process for each subnode of the node it owns.
952  */
953 contract Registrar {
954     ENS public ens;
955     bytes32 public rootNode;
956 
957     mapping (bytes32 => Entry) _entries;
958     mapping (address => mapping (bytes32 => Deed)) public sealedBids;
959     
960     enum Mode { Open, Auction, Owned, Forbidden, Reveal, NotYetAvailable }
961 
962     uint32 constant totalAuctionLength = 5 days;
963     uint32 constant revealPeriod = 48 hours;
964     uint32 public constant launchLength = 8 weeks;
965 
966     uint constant minPrice = 0.01 ether;
967     uint public registryStarted;
968 
969     event AuctionStarted(bytes32 indexed hash, uint registrationDate);
970     event NewBid(bytes32 indexed hash, address indexed bidder, uint deposit);
971     event BidRevealed(bytes32 indexed hash, address indexed owner, uint value, uint8 status);
972     event HashRegistered(bytes32 indexed hash, address indexed owner, uint value, uint registrationDate);
973     event HashReleased(bytes32 indexed hash, uint value);
974     event HashInvalidated(bytes32 indexed hash, string indexed name, uint value, uint registrationDate);
975 
976     struct Entry {
977         Deed deed;
978         uint registrationDate;
979         uint value;
980         uint highestBid;
981     }
982 
983     modifier inState(bytes32 _hash, Mode _state) {
984         require(state(_hash) == _state);
985         _;
986     }
987 
988     modifier onlyOwner(bytes32 _hash) {
989         require(state(_hash) == Mode.Owned && msg.sender == _entries[_hash].deed.owner());
990         _;
991     }
992 
993     modifier registryOpen() {
994         require(now >= registryStarted && now <= registryStarted + 4 years && ens.owner(rootNode) == address(this));
995         _;
996     }
997 
998     /**
999      * @dev Constructs a new Registrar, with the provided address as the owner of the root node.
1000      *
1001      * @param _ens The address of the ENS
1002      * @param _rootNode The hash of the rootnode.
1003      */
1004     function Registrar(ENS _ens, bytes32 _rootNode, uint _startDate) public {
1005         ens = _ens;
1006         rootNode = _rootNode;
1007         registryStarted = _startDate > 0 ? _startDate : now;
1008     }
1009 
1010     /**
1011      * @dev Start an auction for an available hash
1012      *
1013      * @param _hash The hash to start an auction on
1014      */
1015     function startAuction(bytes32 _hash) public registryOpen() {
1016         Mode mode = state(_hash);
1017         if (mode == Mode.Auction) return;
1018         require(mode == Mode.Open);
1019 
1020         Entry storage newAuction = _entries[_hash];
1021         newAuction.registrationDate = now + totalAuctionLength;
1022         newAuction.value = 0;
1023         newAuction.highestBid = 0;
1024         AuctionStarted(_hash, newAuction.registrationDate);
1025     }
1026 
1027     /**
1028      * @dev Start multiple auctions for better anonymity
1029      *
1030      * Anyone can start an auction by sending an array of hashes that they want to bid for.
1031      * Arrays are sent so that someone can open up an auction for X dummy hashes when they
1032      * are only really interested in bidding for one. This will increase the cost for an
1033      * attacker to simply bid blindly on all new auctions. Dummy auctions that are
1034      * open but not bid on are closed after a week.
1035      *
1036      * @param _hashes An array of hashes, at least one of which you presumably want to bid on
1037      */
1038     function startAuctions(bytes32[] _hashes) public {
1039         for (uint i = 0; i < _hashes.length; i ++) {
1040             startAuction(_hashes[i]);
1041         }
1042     }
1043 
1044     /**
1045      * @dev Submit a new sealed bid on a desired hash in a blind auction
1046      *
1047      * Bids are sent by sending a message to the main contract with a hash and an amount. The hash
1048      * contains information about the bid, including the bidded hash, the bid amount, and a random
1049      * salt. Bids are not tied to any one auction until they are revealed. The value of the bid
1050      * itself can be masqueraded by sending more than the value of your actual bid. This is
1051      * followed by a 48h reveal period. Bids revealed after this period will be burned and the ether unrecoverable.
1052      * Since this is an auction, it is expected that most public hashes, like known domains and common dictionary
1053      * words, will have multiple bidders pushing the price up.
1054      *
1055      * @param sealedBid A sealedBid, created by the shaBid function
1056      */
1057     function newBid(bytes32 sealedBid) public payable {
1058         require(address(sealedBids[msg.sender][sealedBid]) == 0x0);
1059         require(msg.value >= minPrice);
1060 
1061         // Creates a new hash contract with the owner
1062         Deed newBid = (new Deed).value(msg.value)(msg.sender);
1063         sealedBids[msg.sender][sealedBid] = newBid;
1064         NewBid(sealedBid, msg.sender, msg.value);
1065     }
1066 
1067     /**
1068      * @dev Start a set of auctions and bid on one of them
1069      *
1070      * This method functions identically to calling `startAuctions` followed by `newBid`,
1071      * but all in one transaction.
1072      *
1073      * @param hashes A list of hashes to start auctions on.
1074      * @param sealedBid A sealed bid for one of the auctions.
1075      */
1076     function startAuctionsAndBid(bytes32[] hashes, bytes32 sealedBid) public payable {
1077         startAuctions(hashes);
1078         newBid(sealedBid);
1079     }
1080 
1081     /**
1082      * @dev Submit the properties of a bid to reveal them
1083      *
1084      * @param _hash The node in the sealedBid
1085      * @param _value The bid amount in the sealedBid
1086      * @param _salt The sale in the sealedBid
1087      */
1088     function unsealBid(bytes32 _hash, uint _value, bytes32 _salt) public {
1089         bytes32 seal = shaBid(_hash, msg.sender, _value, _salt);
1090         Deed bid = sealedBids[msg.sender][seal];
1091         require(address(bid) != 0);
1092 
1093         sealedBids[msg.sender][seal] = Deed(0);
1094         Entry storage h = _entries[_hash];
1095         uint value = min(_value, bid.value());
1096         bid.setBalance(value, true);
1097 
1098         var auctionState = state(_hash);
1099         if (auctionState == Mode.Owned) {
1100             // Too late! Bidder loses their bid. Gets 0.5% back.
1101             bid.closeDeed(5);
1102             BidRevealed(_hash, msg.sender, value, 1);
1103         } else if (auctionState != Mode.Reveal) {
1104             // Invalid phase
1105             revert();
1106         } else if (value < minPrice || bid.creationDate() > h.registrationDate - revealPeriod) {
1107             // Bid too low or too late, refund 99.5%
1108             bid.closeDeed(995);
1109             BidRevealed(_hash, msg.sender, value, 0);
1110         } else if (value > h.highestBid) {
1111             // New winner
1112             // Cancel the other bid, refund 99.5%
1113             if (address(h.deed) != 0) {
1114                 Deed previousWinner = h.deed;
1115                 previousWinner.closeDeed(995);
1116             }
1117 
1118             // Set new winner
1119             // Per the rules of a vickery auction, the value becomes the previous highestBid
1120             h.value = h.highestBid;  // will be zero if there's only 1 bidder
1121             h.highestBid = value;
1122             h.deed = bid;
1123             BidRevealed(_hash, msg.sender, value, 2);
1124         } else if (value > h.value) {
1125             // Not winner, but affects second place
1126             h.value = value;
1127             bid.closeDeed(995);
1128             BidRevealed(_hash, msg.sender, value, 3);
1129         } else {
1130             // Bid doesn't affect auction
1131             bid.closeDeed(995);
1132             BidRevealed(_hash, msg.sender, value, 4);
1133         }
1134     }
1135 
1136     /**
1137      * @dev Cancel a bid
1138      *
1139      * @param seal The value returned by the shaBid function
1140      */
1141     function cancelBid(address bidder, bytes32 seal) public {
1142         Deed bid = sealedBids[bidder][seal];
1143         
1144         // If a sole bidder does not `unsealBid` in time, they have a few more days
1145         // where they can call `startAuction` (again) and then `unsealBid` during
1146         // the revealPeriod to get back their bid value.
1147         // For simplicity, they should call `startAuction` within
1148         // 9 days (2 weeks - totalAuctionLength), otherwise their bid will be
1149         // cancellable by anyone.
1150         require(address(bid) != 0 && now >= bid.creationDate() + totalAuctionLength + 2 weeks);
1151 
1152         // Send the canceller 0.5% of the bid, and burn the rest.
1153         bid.setOwner(msg.sender);
1154         bid.closeDeed(5);
1155         sealedBids[bidder][seal] = Deed(0);
1156         BidRevealed(seal, bidder, 0, 5);
1157     }
1158 
1159     /**
1160      * @dev Finalize an auction after the registration date has passed
1161      *
1162      * @param _hash The hash of the name the auction is for
1163      */
1164     function finalizeAuction(bytes32 _hash) public onlyOwner(_hash) {
1165         Entry storage h = _entries[_hash];
1166         
1167         // Handles the case when there's only a single bidder (h.value is zero)
1168         h.value =  max(h.value, minPrice);
1169         h.deed.setBalance(h.value, true);
1170 
1171         trySetSubnodeOwner(_hash, h.deed.owner());
1172         HashRegistered(_hash, h.deed.owner(), h.value, h.registrationDate);
1173     }
1174 
1175     /**
1176      * @dev The owner of a domain may transfer it to someone else at any time.
1177      *
1178      * @param _hash The node to transfer
1179      * @param newOwner The address to transfer ownership to
1180      */
1181     function transfer(bytes32 _hash, address newOwner) public onlyOwner(_hash) {
1182         require(newOwner != 0);
1183 
1184         Entry storage h = _entries[_hash];
1185         h.deed.setOwner(newOwner);
1186         trySetSubnodeOwner(_hash, newOwner);
1187     }
1188 
1189     /**
1190      * @dev After some time, or if we're no longer the registrar, the owner can release
1191      *      the name and get their ether back.
1192      *
1193      * @param _hash The node to release
1194      */
1195     function releaseDeed(bytes32 _hash) public onlyOwner(_hash) {
1196         Entry storage h = _entries[_hash];
1197         Deed deedContract = h.deed;
1198 
1199         require(now >= h.registrationDate + 1 years || ens.owner(rootNode) != address(this));
1200 
1201         h.value = 0;
1202         h.highestBid = 0;
1203         h.deed = Deed(0);
1204 
1205         _tryEraseSingleNode(_hash);
1206         deedContract.closeDeed(1000);
1207         HashReleased(_hash, h.value);        
1208     }
1209 
1210     /**
1211      * @dev Submit a name 6 characters long or less. If it has been registered,
1212      *      the submitter will earn 50% of the deed value. 
1213      * 
1214      * We are purposefully handicapping the simplified registrar as a way 
1215      * to force it into being restructured in a few years.
1216      *
1217      * @param unhashedName An invalid name to search for in the registry.
1218      */
1219     function invalidateName(string unhashedName) public inState(keccak256(unhashedName), Mode.Owned) {
1220         require(strlen(unhashedName) <= 6);
1221         bytes32 hash = keccak256(unhashedName);
1222 
1223         Entry storage h = _entries[hash];
1224 
1225         _tryEraseSingleNode(hash);
1226 
1227         if (address(h.deed) != 0) {
1228             // Reward the discoverer with 50% of the deed
1229             // The previous owner gets 50%
1230             h.value = max(h.value, minPrice);
1231             h.deed.setBalance(h.value/2, false);
1232             h.deed.setOwner(msg.sender);
1233             h.deed.closeDeed(1000);
1234         }
1235 
1236         HashInvalidated(hash, unhashedName, h.value, h.registrationDate);
1237 
1238         h.value = 0;
1239         h.highestBid = 0;
1240         h.deed = Deed(0);
1241     }
1242 
1243     /**
1244      * @dev Allows anyone to delete the owner and resolver records for a (subdomain of) a
1245      *      name that is not currently owned in the registrar. If passing, eg, 'foo.bar.eth',
1246      *      the owner and resolver fields on 'foo.bar.eth' and 'bar.eth' will all be cleared.
1247      *
1248      * @param labels A series of label hashes identifying the name to zero out, rooted at the
1249      *        registrar's root. Must contain at least one element. For instance, to zero 
1250      *        'foo.bar.eth' on a registrar that owns '.eth', pass an array containing
1251      *        [keccak256('foo'), keccak256('bar')].
1252      */
1253     function eraseNode(bytes32[] labels) public {
1254         require(labels.length != 0);
1255         require(state(labels[labels.length - 1]) != Mode.Owned);
1256 
1257         _eraseNodeHierarchy(labels.length - 1, labels, rootNode);
1258     }
1259 
1260     /**
1261      * @dev Transfers the deed to the current registrar, if different from this one.
1262      *
1263      * Used during the upgrade process to a permanent registrar.
1264      *
1265      * @param _hash The name hash to transfer.
1266      */
1267     function transferRegistrars(bytes32 _hash) public onlyOwner(_hash) {
1268         address registrar = ens.owner(rootNode);
1269         require(registrar != address(this));
1270 
1271         // Migrate the deed
1272         Entry storage h = _entries[_hash];
1273         h.deed.setRegistrar(registrar);
1274 
1275         // Call the new registrar to accept the transfer
1276         Registrar(registrar).acceptRegistrarTransfer(_hash, h.deed, h.registrationDate);
1277 
1278         // Zero out the Entry
1279         h.deed = Deed(0);
1280         h.registrationDate = 0;
1281         h.value = 0;
1282         h.highestBid = 0;
1283     }
1284 
1285     /**
1286      * @dev Accepts a transfer from a previous registrar; stubbed out here since there
1287      *      is no previous registrar implementing this interface.
1288      *
1289      * @param hash The sha3 hash of the label to transfer.
1290      * @param deed The Deed object for the name being transferred in.
1291      * @param registrationDate The date at which the name was originally registered.
1292      */
1293     function acceptRegistrarTransfer(bytes32 hash, Deed deed, uint registrationDate) public {
1294         hash; deed; registrationDate; // Don't warn about unused variables
1295     }
1296 
1297     // State transitions for names:
1298     //   Open -> Auction (startAuction)
1299     //   Auction -> Reveal
1300     //   Reveal -> Owned
1301     //   Reveal -> Open (if nobody bid)
1302     //   Owned -> Open (releaseDeed or invalidateName)
1303     function state(bytes32 _hash) public view returns (Mode) {
1304         Entry storage entry = _entries[_hash];
1305 
1306         if (!isAllowed(_hash, now)) {
1307             return Mode.NotYetAvailable;
1308         } else if (now < entry.registrationDate) {
1309             if (now < entry.registrationDate - revealPeriod) {
1310                 return Mode.Auction;
1311             } else {
1312                 return Mode.Reveal;
1313             }
1314         } else {
1315             if (entry.highestBid == 0) {
1316                 return Mode.Open;
1317             } else {
1318                 return Mode.Owned;
1319             }
1320         }
1321     }
1322 
1323     function entries(bytes32 _hash) public view returns (Mode, address, uint, uint, uint) {
1324         Entry storage h = _entries[_hash];
1325         return (state(_hash), h.deed, h.registrationDate, h.value, h.highestBid);
1326     }
1327 
1328     /**
1329      * @dev Determines if a name is available for registration yet
1330      *
1331      * Each name will be assigned a random date in which its auction
1332      * can be started, from 0 to 8 weeks
1333      *
1334      * @param _hash The hash to start an auction on
1335      * @param _timestamp The timestamp to query about
1336      */
1337     function isAllowed(bytes32 _hash, uint _timestamp) public view returns (bool allowed) {
1338         return _timestamp > getAllowedTime(_hash);
1339     }
1340 
1341     /**
1342      * @dev Returns available date for hash
1343      *
1344      * The available time from the `registryStarted` for a hash is proportional
1345      * to its numeric value.
1346      *
1347      * @param _hash The hash to start an auction on
1348      */
1349     function getAllowedTime(bytes32 _hash) public view returns (uint) {
1350         return registryStarted + ((launchLength * (uint(_hash) >> 128)) >> 128);
1351         // Right shift operator: a >> b == a / 2**b
1352     }
1353 
1354     /**
1355      * @dev Hash the values required for a secret bid
1356      *
1357      * @param hash The node corresponding to the desired namehash
1358      * @param value The bid amount
1359      * @param salt A random value to ensure secrecy of the bid
1360      * @return The hash of the bid values
1361      */
1362     function shaBid(bytes32 hash, address owner, uint value, bytes32 salt) public pure returns (bytes32) {
1363         return keccak256(hash, owner, value, salt);
1364     }
1365 
1366     function _tryEraseSingleNode(bytes32 label) internal {
1367         if (ens.owner(rootNode) == address(this)) {
1368             ens.setSubnodeOwner(rootNode, label, address(this));
1369             bytes32 node = keccak256(rootNode, label);
1370             ens.setResolver(node, 0);
1371             ens.setOwner(node, 0);
1372         }
1373     }
1374 
1375     function _eraseNodeHierarchy(uint idx, bytes32[] labels, bytes32 node) internal {
1376         // Take ownership of the node
1377         ens.setSubnodeOwner(node, labels[idx], address(this));
1378         node = keccak256(node, labels[idx]);
1379 
1380         // Recurse if there are more labels
1381         if (idx > 0) {
1382             _eraseNodeHierarchy(idx - 1, labels, node);
1383         }
1384 
1385         // Erase the resolver and owner records
1386         ens.setResolver(node, 0);
1387         ens.setOwner(node, 0);
1388     }
1389 
1390     /**
1391      * @dev Assign the owner in ENS, if we're still the registrar
1392      *
1393      * @param _hash hash to change owner
1394      * @param _newOwner new owner to transfer to
1395      */
1396     function trySetSubnodeOwner(bytes32 _hash, address _newOwner) internal {
1397         if (ens.owner(rootNode) == address(this))
1398             ens.setSubnodeOwner(rootNode, _hash, _newOwner);
1399     }
1400 
1401     /**
1402      * @dev Returns the maximum of two unsigned integers
1403      *
1404      * @param a A number to compare
1405      * @param b A number to compare
1406      * @return The maximum of two unsigned integers
1407      */
1408     function max(uint a, uint b) internal pure returns (uint) {
1409         if (a > b)
1410             return a;
1411         else
1412             return b;
1413     }
1414 
1415     /**
1416      * @dev Returns the minimum of two unsigned integers
1417      *
1418      * @param a A number to compare
1419      * @param b A number to compare
1420      * @return The minimum of two unsigned integers
1421      */
1422     function min(uint a, uint b) internal pure returns (uint) {
1423         if (a < b)
1424             return a;
1425         else
1426             return b;
1427     }
1428 
1429     /**
1430      * @dev Returns the length of a given string
1431      *
1432      * @param s The string to measure the length of
1433      * @return The length of the input string
1434      */
1435     function strlen(string s) internal pure returns (uint) {
1436         s; // Don't warn about unused variables
1437         // Starting here means the LSB will be the byte we care about
1438         uint ptr;
1439         uint end;
1440         assembly {
1441             ptr := add(s, 1)
1442             end := add(mload(s), ptr)
1443         }
1444         for (uint len = 0; ptr < end; len++) {
1445             uint8 b;
1446             assembly { b := and(mload(ptr), 0xFF) }
1447             if (b < 0x80) {
1448                 ptr += 1;
1449             } else if (b < 0xE0) {
1450                 ptr += 2;
1451             } else if (b < 0xF0) {
1452                 ptr += 3;
1453             } else if (b < 0xF8) {
1454                 ptr += 4;
1455             } else if (b < 0xFC) {
1456                 ptr += 5;
1457             } else {
1458                 ptr += 6;
1459             }
1460         }
1461         return len;
1462     }
1463 
1464 }
1465 
1466 // File: contracts/ENSNFT.sol
1467 
1468 contract ENSNFT is ERC721Token {
1469     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
1470     Registrar registrar;
1471     constructor (string _name, string _symbol, address _registrar) public
1472         ERC721Token(_name, _symbol) {
1473         registrar = Registrar(_registrar);
1474     }
1475     function mint(bytes32 _hash) public {
1476         address deedAddress;
1477         (, deedAddress, , , ) = registrar.entries(_hash);
1478         Deed deed = Deed(deedAddress);
1479         require(deed.owner() == address(this));
1480         require(deed.previousOwner() == msg.sender);
1481         uint256 tokenId = uint256(_hash); // dont do math on this
1482         _mint(deed.previousOwner(), tokenId);
1483     }
1484     function burn(uint256 tokenId) {
1485         require(ownerOf(tokenId) == msg.sender);
1486         _burn(msg.sender, tokenId);
1487         registrar.transfer(bytes32(tokenId), msg.sender);
1488     }
1489 }