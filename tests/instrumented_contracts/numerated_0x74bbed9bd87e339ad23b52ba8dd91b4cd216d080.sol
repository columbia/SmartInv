1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
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
23 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
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
108 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
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
146 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
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
184 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
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
236 // File: openzeppelin-solidity/contracts/AddressUtils.sol
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
265 // File: openzeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol
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
317 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
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
623 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
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
820 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
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
884 // File: contracts/HarbergerTaxable.sol
885 
886 contract HarbergerTaxable is Ownable {
887   using SafeMath for uint256;
888 
889   uint256 public taxPercentage;
890   address public taxCollector;
891   address public ethFoundation;
892   uint256 public currentFoundationContribution;
893   uint256 public ethFoundationPercentage;
894   uint256 public taxCollectorPercentage;
895 
896   event UpdateCollector(address indexed newCollector);
897   event UpdateTaxPercentages(uint256 indexed newEFPercentage, uint256 indexed newTaxCollectorPercentage);
898 
899   constructor(uint256 _taxPercentage, address _taxCollector) public {
900     taxPercentage = _taxPercentage;
901     taxCollector = _taxCollector;
902     ethFoundation = 0xfB6916095ca1df60bB79Ce92cE3Ea74c37c5d359;
903     ethFoundationPercentage = 20;
904     taxCollectorPercentage = 80;
905   }
906 
907   // The total self-assessed value of user's assets
908   mapping(address => uint256) public valueHeld;
909 
910   // Timestamp for the last time taxes were deducted from a user's account
911   mapping(address => uint256) public lastPaidTaxes;
912 
913   // The amount of ETH a user can withdraw at the last time taxes were deducted from their account
914   mapping(address => uint256) public userBalanceAtLastPaid;
915 
916   /**
917    * Modifiers
918    */
919 
920   modifier hasPositveBalance(address user) {
921     require(userHasPositveBalance(user) == true, "User has a negative balance");
922     _;
923   }
924 
925   /**
926    * Public functions
927    */
928 
929   function updateCollector(address _newCollector)
930     public
931     onlyOwner
932   {
933     require(_newCollector != address(0));
934     taxCollector == _newCollector;
935     emit UpdateCollector(_newCollector);
936   }
937 
938   function updateTaxPercentages(uint256 _newEFPercentage, uint256 _newTaxCollectorPercentage)
939     public
940     onlyOwner
941   {
942     require(_newEFPercentage < 100);
943     require(_newTaxCollectorPercentage < 100);
944     require(_newEFPercentage.add(_newTaxCollectorPercentage) == 100);
945 
946     ethFoundationPercentage = _newEFPercentage;
947     taxCollectorPercentage = _newTaxCollectorPercentage;
948     emit UpdateTaxPercentages(_newEFPercentage, _newTaxCollectorPercentage);
949   }
950 
951   function addFunds()
952     public
953     payable
954   {
955     userBalanceAtLastPaid[msg.sender] = userBalanceAtLastPaid[msg.sender].add(msg.value);
956   }
957 
958   function withdraw(uint256 value) public onlyOwner {
959     // Settle latest taxes
960     require(transferTaxes(msg.sender, false), "User has a negative balance");
961 
962     // Subtract the withdrawn value from the user's account
963     userBalanceAtLastPaid[msg.sender] = userBalanceAtLastPaid[msg.sender].sub(value);
964 
965     // Transfer remaining balance to msg.sender
966     msg.sender.transfer(value);
967   }
968 
969   function userHasPositveBalance(address user) public view returns (bool) {
970     return userBalanceAtLastPaid[user] >= _taxesDue(user);
971   }
972 
973   function userBalance(address user) public view returns (uint256) {
974     return userBalanceAtLastPaid[user].sub(_taxesDue(user));
975   }
976 
977   // Transfers the taxes a user owes from their account to the taxCollector and resets lastPaidTaxes to now
978   function transferTaxes(address user, bool isInAuction) public returns (bool) {
979 
980     if (isInAuction) {
981       return true;
982     }
983 
984     uint256 taxesDue = _taxesDue(user);
985 
986     // Make sure the user has enough funds to pay the taxesDue
987     if (userBalanceAtLastPaid[user] < taxesDue) {
988         return false;
989     }
990 
991     // Transfer taxes due from this contract to the tax collector
992     _payoutTaxes(taxesDue);
993     // Update the user's lastPaidTaxes
994     lastPaidTaxes[user] = now;
995     // subtract the taxes paid from the user's balance
996     userBalanceAtLastPaid[user] = userBalanceAtLastPaid[user].sub(taxesDue);
997 
998     return true;
999   }
1000 
1001   function payoutEF()
1002     public
1003   {
1004     uint256 uincornsRequirement = 2.014 ether;
1005     require(currentFoundationContribution >= uincornsRequirement);
1006 
1007     currentFoundationContribution = currentFoundationContribution.sub(uincornsRequirement);
1008     ethFoundation.transfer(uincornsRequirement);
1009   }
1010 
1011   /**
1012    * Internal functions
1013    */
1014 
1015   function _payoutTaxes(uint256 _taxesDue)
1016     internal
1017   {
1018     uint256 foundationContribution = _taxesDue.mul(ethFoundationPercentage).div(100);
1019     uint256 taxCollectorContribution = _taxesDue.mul(taxCollectorPercentage).div(100);
1020 
1021     currentFoundationContribution += foundationContribution;
1022 
1023     taxCollector.transfer(taxCollectorContribution);
1024   }
1025 
1026   // Calculate taxes due since the last time they had taxes deducted
1027   // from their account or since they bought their first token.
1028   function _taxesDue(address user) internal view returns (uint256) {
1029     // Make sure user owns tokens
1030     if (lastPaidTaxes[user] == 0) {
1031       return 0;
1032     }
1033 
1034     uint256 timeElapsed = now.sub(lastPaidTaxes[user]);
1035     return (valueHeld[user].mul(timeElapsed).div(365 days)).mul(taxPercentage).div(100);
1036   }
1037 
1038   function _addToValueHeld(address user, uint256 value) internal {
1039     require(transferTaxes(user, false), "User has a negative balance");
1040     require(userBalanceAtLastPaid[user] > 0);
1041     valueHeld[user] = valueHeld[user].add(value);
1042   }
1043 
1044   function _subFromValueHeld(address user, uint256 value, bool isInAuction) internal {
1045     require(transferTaxes(user, isInAuction), "User has a negative balance");
1046     valueHeld[user] = valueHeld[user].sub(value);
1047   }
1048 }
1049 
1050 // File: contracts/RadicalPixels.sol
1051 
1052 /**
1053  * @title RadicalPixels
1054  */
1055 contract RadicalPixels is HarbergerTaxable, ERC721Token {
1056   using SafeMath for uint256;
1057 
1058   uint256 public   xMax;
1059   uint256 public   yMax;
1060   uint256 constant clearLow = 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000;
1061   uint256 constant clearHigh = 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff;
1062   uint256 constant factor = 0x100000000000000000000000000000000;
1063 
1064   struct Pixel {
1065     // Id of the pixel block
1066     bytes32 id;
1067     // Owner of the pixel block
1068     address seller;
1069     // Pixel block x coordinate
1070     uint256 x;
1071     // Pixel block y coordinate
1072     uint256 y;
1073     // Pixel block price
1074     uint256 price;
1075     // Auction Id
1076     bytes32 auctionId;
1077     // Content data
1078     bytes32 contentData;
1079   }
1080 
1081   struct Auction {
1082     // Id of the auction
1083     bytes32 auctionId;
1084     // Id of the pixel block
1085     bytes32 blockId;
1086     // Pixel block x coordinate
1087     uint256 x;
1088     // Pixel block y coordinate
1089     uint256 y;
1090     // Current price
1091     uint256 currentPrice;
1092     // Current Leader
1093     address currentLeader;
1094     // End Time
1095     uint256 endTime;
1096   }
1097 
1098   mapping(uint256 => mapping(uint256 => Pixel)) public pixelByCoordinate;
1099   mapping(bytes32 => Auction) public auctionById;
1100 
1101   /**
1102    * Modifiers
1103    */
1104    modifier validRange(uint256 _x, uint256 _y)
1105   {
1106     require(_x < xMax, "X coordinate is out of range");
1107     require(_y < yMax, "Y coordinate is out of range");
1108     _;
1109   }
1110 
1111   modifier auctionNotOngoing(uint256 _x, uint256 _y)
1112   {
1113     Pixel memory pixel = pixelByCoordinate[_x][_y];
1114     require(pixel.auctionId == 0);
1115     _;
1116   }
1117 
1118   /**
1119    * Events
1120    */
1121 
1122   event BuyPixel(
1123     bytes32 indexed id,
1124     address indexed seller,
1125     address indexed buyer,
1126     uint256 x,
1127     uint256 y,
1128     uint256 price,
1129     bytes32 contentData
1130   );
1131 
1132   event SetPixelPrice(
1133     bytes32 indexed id,
1134     address indexed seller,
1135     uint256 x,
1136     uint256 y,
1137     uint256 price
1138   );
1139 
1140   event BeginDutchAuction(
1141     bytes32 indexed pixelId,
1142     uint256 indexed tokenId,
1143     bytes32 indexed auctionId,
1144     address initiator,
1145     uint256 x,
1146     uint256 y,
1147     uint256 startTime,
1148     uint256 endTime
1149   );
1150 
1151   event UpdateAuctionBid(
1152     bytes32 indexed pixelId,
1153     uint256 indexed tokenId,
1154     bytes32 indexed auctionId,
1155     address bidder,
1156     uint256 amountBet,
1157     uint256 timeBet
1158   );
1159 
1160   event EndDutchAuction(
1161     bytes32 indexed pixelId,
1162     uint256 indexed tokenId,
1163     address indexed claimer,
1164     uint256 x,
1165     uint256 y
1166   );
1167 
1168   event UpdateContentData(
1169     bytes32 indexed pixelId,
1170     address indexed owner,
1171     uint256 x,
1172     uint256 y,
1173     bytes32 newContentData
1174   );
1175 
1176   constructor(uint256 _xMax, uint256 _yMax, uint256 _taxPercentage, address _taxCollector)
1177     public
1178     ERC721Token("Radical Pixels", "RPX")
1179     HarbergerTaxable(_taxPercentage, _taxCollector)
1180   {
1181     require(_xMax > 0, "xMax must be a valid number");
1182     require(_yMax > 0, "yMax must be a valid number");
1183 
1184     xMax = _xMax;
1185     yMax = _yMax;
1186   }
1187 
1188   /**
1189    * Public Functions
1190    */
1191 
1192   /**
1193    * @dev Overwrite ERC721 transferFrom with our specific needs
1194    * @notice This transfer has to be approved and then triggered by the _to
1195    * address in order to avoid sending unwanted pixels
1196    * @param _from Address sending token
1197    * @param _to Address receiving token
1198    * @param _tokenId ID of the transacting token
1199    * @param _price Price of the token being transfered
1200    * @param _x X coordinate of the desired block
1201    * @param _y Y coordinate of the desired block
1202    */
1203   function transferFrom(address _from, address _to, uint256 _tokenId, uint256 _price, uint256 _x, uint256 _y)
1204     public
1205     auctionNotOngoing(_x, _y)
1206   {
1207     _subFromValueHeld(msg.sender, _price, false);
1208     _addToValueHeld(_to, _price);
1209     require(_to == msg.sender);
1210     Pixel memory pixel = pixelByCoordinate[_x][_y];
1211 
1212     super.transferFrom(_from, _to, _tokenId);
1213   }
1214 
1215    /**
1216    * @dev Buys pixel block
1217    * @param _x X coordinate of the desired block
1218    * @param _y Y coordinate of the desired block
1219    * @param _price New price of the pixel block
1220    * @param _contentData Data for the pixel
1221    */
1222    function buyUninitializedPixelBlock(uint256 _x, uint256 _y, uint256 _price, bytes32 _contentData)
1223      public
1224    {
1225      require(_price > 0);
1226      _buyUninitializedPixelBlock(_x, _y, _price, _contentData);
1227    }
1228 
1229   /**
1230   * @dev Buys pixel blocks
1231   * @param _x X coordinates of the desired blocks
1232   * @param _y Y coordinates of the desired blocks
1233   * @param _price New prices of the pixel blocks
1234   * @param _contentData Data for the pixel
1235   */
1236   function buyUninitializedPixelBlocks(uint256[] _x, uint256[] _y, uint256[] _price, bytes32[] _contentData)
1237     public
1238   {
1239     require(_x.length == _y.length && _x.length == _price.length && _x.length == _contentData.length);
1240     for (uint i = 0; i < _x.length; i++) {
1241       require(_price[i] > 0);
1242       _buyUninitializedPixelBlock(_x[i], _y[i], _price[i], _contentData[i]);
1243     }
1244   }
1245 
1246   /**
1247   * @dev Buys pixel block
1248   * @param _x X coordinate of the desired block
1249   * @param _y Y coordinate of the desired block
1250   * @param _price New price of the pixel block
1251   * @param _contentData Data for the pixel
1252   */
1253   function buyPixelBlock(uint256 _x, uint256 _y, uint256 _price, bytes32 _contentData)
1254     public
1255     payable
1256   {
1257     require(_price > 0);
1258     uint256 _ = _buyPixelBlock(_x, _y, _price, msg.value, _contentData);
1259   }
1260 
1261   /**
1262   * @dev Buys pixel block
1263   * @param _x X coordinates of the desired blocks
1264   * @param _y Y coordinates of the desired blocks
1265   * @param _price New prices of the pixel blocks
1266   * @param _contentData Data for the pixel
1267   */
1268   function buyPixelBlocks(uint256[] _x, uint256[] _y, uint256[] _price, bytes32[] _contentData)
1269     public
1270     payable
1271   {
1272     require(_x.length == _y.length && _x.length == _price.length && _x.length == _contentData.length);
1273     uint256 currentValue = msg.value;
1274     for (uint i = 0; i < _x.length; i++) {
1275       require(_price[i] > 0);
1276       currentValue = _buyPixelBlock(_x[i], _y[i], _price[i], currentValue, _contentData[i]);
1277     }
1278   }
1279 
1280   /**
1281   * @dev Set prices for specific blocks
1282   * @param _x X coordinate of the desired block
1283   * @param _y Y coordinate of the desired block
1284   * @param _price New price of the pixel block
1285   */
1286   function setPixelBlockPrice(uint256 _x, uint256 _y, uint256 _price)
1287     public
1288     payable
1289   {
1290     require(_price > 0);
1291     _setPixelBlockPrice(_x, _y, _price);
1292   }
1293 
1294   /**
1295   * @dev Set prices for specific blocks
1296   * @param _x X coordinates of the desired blocks
1297   * @param _y Y coordinates of the desired blocks
1298   * @param _price New prices of the pixel blocks
1299   */
1300   function setPixelBlockPrices(uint256[] _x, uint256[] _y, uint256[] _price)
1301     public
1302     payable
1303   {
1304     require(_x.length == _y.length && _x.length == _price.length);
1305     for (uint i = 0; i < _x.length; i++) {
1306       require(_price[i] > 0);
1307       _setPixelBlockPrice(_x[i], _y[i], _price[i]);
1308     }
1309   }
1310 
1311   /**
1312    * Trigger a dutch auction
1313    * @param _x X coordinate of the desired block
1314    * @param _y Y coordinate of the desired block
1315    */
1316   function beginDutchAuction(uint256 _x, uint256 _y)
1317     public
1318     auctionNotOngoing(_x, _y)
1319     validRange(_x, _y)
1320   {
1321     Pixel storage pixel = pixelByCoordinate[_x][_y];
1322 
1323     require(!userHasPositveBalance(pixel.seller));
1324     require(pixel.auctionId == 0);
1325 
1326     // Start a dutch auction
1327     pixel.auctionId = _generateDutchAuction(_x, _y);
1328     uint256 tokenId = _encodeTokenId(_x, _y);
1329 
1330     _updatePixelMapping(pixel.seller, _x, _y, pixel.price, pixel.auctionId, "");
1331 
1332     emit BeginDutchAuction(
1333       pixel.id,
1334       tokenId,
1335       pixel.auctionId,
1336       msg.sender,
1337       _x,
1338       _y,
1339       block.timestamp,
1340       block.timestamp.add(1 days)
1341     );
1342   }
1343 
1344   /**
1345    * @dev Allow a user to bid in an auction
1346    * @param _x X coordinate of the desired block
1347    * @param _y Y coordinate of the desired block
1348    * @param _bid Desired bid of the user
1349    */
1350   function bidInAuction(uint256 _x, uint256 _y, uint256 _bid)
1351     public
1352     validRange(_x, _y)
1353   {
1354     Pixel memory pixel = pixelByCoordinate[_x][_y];
1355     Auction storage auction = auctionById[pixel.auctionId];
1356 
1357     uint256 _tokenId = _encodeTokenId(_x, _y);
1358     require(pixel.auctionId != 0);
1359     require(auction.currentPrice < _bid);
1360     require(block.timestamp < auction.endTime);
1361 
1362     auction.currentPrice = _bid;
1363     auction.currentLeader = msg.sender;
1364 
1365     emit UpdateAuctionBid(
1366       pixel.id,
1367       _tokenId,
1368       auction.auctionId,
1369       msg.sender,
1370       _bid,
1371       block.timestamp
1372     );
1373   }
1374 
1375   /**
1376    * End the auction
1377    * @param _x X coordinate of the desired block
1378    * @param _y Y coordinate of the desired block
1379    */
1380   function endDutchAuction(uint256 _x, uint256 _y)
1381     public
1382     validRange(_x, _y)
1383   {
1384     Pixel memory pixel = pixelByCoordinate[_x][_y];
1385     Auction memory auction = auctionById[pixel.auctionId];
1386 
1387     require(pixel.auctionId != 0);
1388     require(auction.endTime < block.timestamp);
1389 
1390     // End dutch auction
1391     address winner = _endDutchAuction(_x, _y);
1392     _updatePixelMapping(winner, _x, _y, auction.currentPrice, 0, "");
1393 
1394     // Update user values
1395     _subFromValueHeld(pixel.seller, pixel.price, true);
1396     _addToValueHeld(winner, auction.currentPrice);
1397 
1398     uint256 tokenId = _encodeTokenId(_x, _y);
1399     removeTokenFrom(pixel.seller, tokenId);
1400     addTokenTo(winner, tokenId);
1401     emit Transfer(pixel.seller, winner, tokenId);
1402 
1403     emit EndDutchAuction(
1404       pixel.id,
1405       tokenId,
1406       winner,
1407       _x,
1408       _y
1409     );
1410   }
1411 
1412   /**
1413   * @dev Change content data of a pixel
1414   * @param _x X coordinates of the desired blocks
1415   * @param _y Y coordinates of the desired blocks
1416   * @param _contentData Data for the pixel
1417   */
1418   function changeContentData(uint256 _x, uint256 _y, bytes32 _contentData)
1419     public
1420   {
1421     Pixel storage pixel = pixelByCoordinate[_x][_y];
1422 
1423     require(msg.sender == pixel.seller);
1424 
1425     pixel.contentData = _contentData;
1426 
1427     emit UpdateContentData(
1428       pixel.id,
1429       pixel.seller,
1430       _x,
1431       _y,
1432       _contentData
1433   );
1434 
1435   }
1436 
1437   /**
1438    * Encode a token ID for transferability
1439    * @param _x X coordinate of the desired block
1440    * @param _y Y coordinate of the desired block
1441    */
1442   function encodeTokenId(uint256 _x, uint256 _y)
1443     public
1444     view
1445     validRange(_x, _y)
1446     returns (uint256)
1447   {
1448     return _encodeTokenId(_x, _y);
1449   }
1450 
1451   /**
1452    * Internal Functions
1453    */
1454 
1455   /**
1456   * @dev Buys an uninitialized pixel block for 0 ETH
1457   * @param _x X coordinate of the desired block
1458   * @param _y Y coordinate of the desired block
1459   * @param _price New price for the pixel
1460   * @param _contentData Data for the pixel
1461   */
1462   function _buyUninitializedPixelBlock(uint256 _x, uint256 _y, uint256 _price, bytes32 _contentData)
1463     internal
1464     validRange(_x, _y)
1465     hasPositveBalance(msg.sender)
1466   {
1467     Pixel memory pixel = pixelByCoordinate[_x][_y];
1468 
1469     require(pixel.seller == address(0), "Pixel must not be initialized");
1470 
1471     uint256 tokenId = _encodeTokenId(_x, _y);
1472     bytes32 pixelId = _updatePixelMapping(msg.sender, _x, _y, _price, 0, _contentData);
1473 
1474     _addToValueHeld(msg.sender, _price);
1475     _mint(msg.sender, tokenId);
1476 
1477     emit BuyPixel(
1478       pixelId,
1479       address(0),
1480       msg.sender,
1481       _x,
1482       _y,
1483       _price,
1484       _contentData
1485     );
1486   }
1487 
1488   /**
1489    * @dev Buys a pixel block
1490    * @param _x X coordinate of the desired block
1491    * @param _y Y coordinate of the desired block
1492    * @param _price New price of the pixel block
1493    * @param _currentValue Current value of the transaction
1494    * @param _contentData Data for the pixel
1495    */
1496   function _buyPixelBlock(uint256 _x, uint256 _y, uint256 _price, uint256 _currentValue, bytes32 _contentData)
1497     internal
1498     validRange(_x, _y)
1499     hasPositveBalance(msg.sender)
1500     returns (uint256)
1501   {
1502     Pixel memory pixel = pixelByCoordinate[_x][_y];
1503     require(pixel.auctionId == 0);  // Stack to deep if this is a modifier
1504     uint256 _taxOnPrice = _calculateTax(_price);
1505 
1506     require(pixel.seller != address(0), "Pixel must be initialized");
1507     require(userBalanceAtLastPaid[msg.sender] >= _taxOnPrice);
1508     require(pixel.price <= _currentValue, "Must have sent sufficient funds");
1509 
1510     uint256 tokenId = _encodeTokenId(_x, _y);
1511 
1512     removeTokenFrom(pixel.seller, tokenId);
1513     addTokenTo(msg.sender, tokenId);
1514     emit Transfer(pixel.seller, msg.sender, tokenId);
1515 
1516     _addToValueHeld(msg.sender, _price);
1517     _subFromValueHeld(pixel.seller, pixel.price, false);
1518 
1519     _updatePixelMapping(msg.sender, _x, _y, _price, 0, _contentData);
1520     pixel.seller.transfer(pixel.price);
1521 
1522     emit BuyPixel(
1523       pixel.id,
1524       pixel.seller,
1525       msg.sender,
1526       _x,
1527       _y,
1528       pixel.price,
1529       _contentData
1530     );
1531 
1532     return _currentValue.sub(pixel.price);
1533   }
1534 
1535   /**
1536   * @dev Set prices for a specific block
1537   * @param _x X coordinate of the desired block
1538   * @param _y Y coordinate of the desired block
1539   * @param _price New price of the pixel block
1540   */
1541   function _setPixelBlockPrice(uint256 _x, uint256 _y, uint256 _price)
1542     internal
1543     auctionNotOngoing(_x, _y)
1544     validRange(_x, _y)
1545   {
1546     Pixel memory pixel = pixelByCoordinate[_x][_y];
1547 
1548     require(pixel.seller == msg.sender, "Sender must own the block");
1549     _addToValueHeld(msg.sender, _price);
1550 
1551     delete pixelByCoordinate[_x][_y];
1552 
1553     bytes32 pixelId = _updatePixelMapping(msg.sender, _x, _y, _price, 0, "");
1554 
1555     emit SetPixelPrice(
1556       pixelId,
1557       pixel.seller,
1558       _x,
1559       _y,
1560       pixel.price
1561     );
1562   }
1563 
1564   /**
1565    * Generate a dutch auction
1566    * @param _x X coordinate of the desired block
1567    * @param _y Y coordinate of the desired block
1568    */
1569   function _generateDutchAuction(uint256 _x, uint256 _y)
1570     internal
1571     returns (bytes32)
1572   {
1573     Pixel memory pixel = pixelByCoordinate[_x][_y];
1574 
1575     bytes32 _auctionId = keccak256(
1576       abi.encodePacked(
1577         block.timestamp,
1578         _x,
1579         _y
1580       )
1581     );
1582 
1583     auctionById[_auctionId] = Auction({
1584       auctionId: _auctionId,
1585       blockId: pixel.id,
1586       x: _x,
1587       y: _y,
1588       currentPrice: 0,
1589       currentLeader: msg.sender,
1590       endTime: block.timestamp.add(1 days)
1591     });
1592 
1593     return _auctionId;
1594   }
1595 
1596   /**
1597    * End a finished dutch auction
1598    * @param _x X coordinate of the desired block
1599    * @param _y Y coordinate of the desired block
1600    */
1601   function _endDutchAuction(uint256 _x, uint256 _y)
1602     internal
1603     returns (address)
1604   {
1605     Pixel memory pixel = pixelByCoordinate[_x][_y];
1606     Auction memory auction = auctionById[pixel.auctionId];
1607 
1608     address _winner = auction.currentLeader;
1609 
1610     delete auctionById[auction.auctionId];
1611 
1612     return _winner;
1613   }
1614   /**
1615     * @dev Update pixel mapping every time it is purchase or the price is
1616     * changed
1617     * @param _seller Seller of the pixel block
1618     * @param _x X coordinate of the desired block
1619     * @param _y Y coordinate of the desired block
1620     * @param _price Price of the pixel block
1621     * @param _contentData Data for the pixel
1622     */
1623   function _updatePixelMapping
1624   (
1625     address _seller,
1626     uint256 _x,
1627     uint256 _y,
1628     uint256 _price,
1629     bytes32 _auctionId,
1630     bytes32 _contentData
1631   )
1632     internal
1633     returns (bytes32)
1634   {
1635     bytes32 pixelId = keccak256(
1636       abi.encodePacked(
1637         _x,
1638         _y
1639       )
1640     );
1641 
1642     pixelByCoordinate[_x][_y] = Pixel({
1643       id: pixelId,
1644       seller: _seller,
1645       x: _x,
1646       y: _y,
1647       price: _price,
1648       auctionId: _auctionId,
1649       contentData: _contentData
1650     });
1651 
1652     return pixelId;
1653   }
1654 
1655   function _calculateTax(uint256 _price)
1656     internal
1657     view
1658     returns (uint256)
1659   {
1660     return _price.mul(taxPercentage).div(100);
1661   }
1662   /**
1663    * Encode token ID
1664    * @param _x X coordinate of the desired block
1665    * @param _y Y coordinate of the desired block
1666    */
1667   function _encodeTokenId(uint256 _x, uint256 _y)
1668     internal
1669     pure
1670     returns (uint256 result)
1671   {
1672     return ((_x * factor) & clearLow) | (_y & clearHigh);
1673   }
1674 }