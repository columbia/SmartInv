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
820 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
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
884 // File: contracts/SpiderStore2018Contributions.sol
885 
886 contract SpiderStore2018Contributions is ERC721Token, Ownable {
887     constructor (string _name, string _symbol) public ERC721Token(_name, _symbol)
888     {
889         super._mint(msg.sender, 1);
890         super._setTokenURI(1, 'https://ipfs.io/ipfs/QmfDJCNDZiMqpSizWK5GoBThFHinhq68nicu9ntNMawEBb');
891 
892         super._mint(msg.sender, 2);
893         super._setTokenURI(2, 'https://ipfs.io/ipfs/QmNqfRD2SZn4EeTzuZ7wpqxcj3ikN32NXfdSQu8RViUkyZ');
894     }
895 
896     function mint(
897         address _to,
898         uint256 _tokenId,
899         string _tokenURI
900     ) public onlyOwner
901     {
902         super._mint(_to, _tokenId);
903         super._setTokenURI(_tokenId, _tokenURI);
904     }
905 }