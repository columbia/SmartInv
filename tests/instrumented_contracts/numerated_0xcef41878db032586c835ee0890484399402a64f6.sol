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
884 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
885 
886 /**
887  * @title Pausable
888  * @dev Base contract which allows children to implement an emergency stop mechanism.
889  */
890 contract Pausable is Ownable {
891   event Pause();
892   event Unpause();
893 
894   bool public paused = false;
895 
896 
897   /**
898    * @dev Modifier to make a function callable only when the contract is not paused.
899    */
900   modifier whenNotPaused() {
901     require(!paused);
902     _;
903   }
904 
905   /**
906    * @dev Modifier to make a function callable only when the contract is paused.
907    */
908   modifier whenPaused() {
909     require(paused);
910     _;
911   }
912 
913   /**
914    * @dev called by the owner to pause, triggers stopped state
915    */
916   function pause() public onlyOwner whenNotPaused {
917     paused = true;
918     emit Pause();
919   }
920 
921   /**
922    * @dev called by the owner to unpause, returns to normal state
923    */
924   function unpause() public onlyOwner whenPaused {
925     paused = false;
926     emit Unpause();
927   }
928 }
929 
930 // File: contracts/MEHAccessControl.sol
931 
932 contract MarketInerface {
933     function buyBlocks(address, uint16[]) external returns (uint) {}
934     function sellBlocks(address, uint, uint16[]) external returns (uint) {}
935     function isMarket() public view returns (bool) {}
936     function isOnSale(uint16) public view returns (bool) {}
937     function areaPrice(uint16[]) public view returns (uint) {}
938     function importOldMEBlock(uint8, uint8) external returns (uint, address) {}
939 }
940 
941 contract RentalsInterface {
942     function rentOutBlocks(address, uint, uint16[]) external returns (uint) {}
943     function rentBlocks(address, uint, uint16[]) external returns (uint) {}
944     function blocksRentPrice(uint, uint16[]) external view returns (uint) {}
945     function isRentals() public view returns (bool) {}
946     function isRented(uint16) public view returns (bool) {}
947     function renterOf(uint16) public view returns (address) {}
948 }
949 
950 contract AdsInterface {
951     function advertiseOnBlocks(address, uint16[], string, string, string) external returns (uint) {}
952     function canAdvertiseOnBlocks(address, uint16[]) public view returns (bool) {}
953     function isAds() public view returns (bool) {}
954 }
955 
956 /// @title MEHAccessControl: Part of MEH contract responsible for communication with external modules:
957 ///  Market, Rentals, Ads contracts. Provides authorization and upgradability methods.
958 contract MEHAccessControl is Pausable {
959 
960     // Allows a module being plugged in to verify it is MEH contract. 
961     bool public isMEH = true;
962 
963     // Modules
964     MarketInerface public market;
965     RentalsInterface public rentals;
966     AdsInterface public ads;
967 
968     // Emitted when a module is plugged.
969     event LogModuleUpgrade(address newAddress, string moduleName);
970     
971 // GUARDS
972     
973     /// @dev Functions allowed to market module only. 
974     modifier onlyMarket() {
975         require(msg.sender == address(market));
976         _;
977     }
978 
979     /// @dev Functions allowed to balance operators only (market and rentals contracts are the 
980     ///  only balance operators)
981     modifier onlyBalanceOperators() {
982         require(msg.sender == address(market) || msg.sender == address(rentals));
983         _;
984     }
985 
986 // ** Admin set Access ** //
987     /// @dev Allows admin to plug a new Market contract in.
988     // credits to cryptokittes! - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
989     // NOTE: verify that a contract is what we expect
990     function adminSetMarket(address _address) external onlyOwner {
991         MarketInerface candidateContract = MarketInerface(_address);
992         require(candidateContract.isMarket());
993         market = candidateContract;
994         emit LogModuleUpgrade(_address, "Market");
995     }
996 
997     /// @dev Allows admin to plug a new Rentals contract in.
998     function adminSetRentals(address _address) external onlyOwner {
999         RentalsInterface candidateContract = RentalsInterface(_address);
1000         require(candidateContract.isRentals());
1001         rentals = candidateContract;
1002         emit LogModuleUpgrade(_address, "Rentals");
1003     }
1004 
1005     /// @dev Allows admin to plug a new Ads contract in.
1006     function adminSetAds(address _address) external onlyOwner {
1007         AdsInterface candidateContract = AdsInterface(_address);
1008         require(candidateContract.isAds());
1009         ads = candidateContract;
1010         emit LogModuleUpgrade(_address, "Ads");
1011     }
1012 }
1013 
1014 // File: contracts/MehERC721.sol
1015 
1016 // ERC721 
1017 
1018 
1019 
1020 /// @title MehERC721: Part of MEH contract responsible for ERC721 token management. Openzeppelin's
1021 ///  ERC721 implementation modified for the Million Ether Homepage. 
1022 contract MehERC721 is ERC721Token("MillionEtherHomePage","MEH"), MEHAccessControl {
1023 
1024     /// @dev Checks rights to transfer block ownership. Locks tokens on sale.
1025     ///  Overrides OpenZEppelin's isApprovedOrOwner function - so that tokens marked for sale can 
1026     ///  be transferred by Market contract only.
1027     function isApprovedOrOwner(
1028         address _spender,
1029         uint256 _tokenId
1030     )
1031         internal
1032         view
1033         returns (bool)
1034     {   
1035         bool onSale = market.isOnSale(uint16(_tokenId));
1036 
1037         address owner = ownerOf(_tokenId);
1038         bool spenderIsApprovedOrOwner =
1039             _spender == owner ||
1040             getApproved(_tokenId) == _spender ||
1041             isApprovedForAll(owner, _spender);
1042 
1043         return (
1044             (onSale && _spender == address(market)) ||
1045             (!(onSale) && spenderIsApprovedOrOwner)
1046         );
1047     }
1048 
1049     /// @dev mints a new block.
1050     ///  overrides _mint function to add pause/unpause functionality, onlyMarket access,
1051     ///  restricts totalSupply of blocks to 10000 (as there is only a 100x100 blocks field).
1052     function _mintCrowdsaleBlock(address _to, uint16 _blockId) external onlyMarket whenNotPaused {
1053         if (totalSupply() <= 9999) {
1054         _mint(_to, uint256(_blockId));
1055         }
1056     }
1057 
1058     /// @dev overrides approve function to add pause/unpause functionality
1059     function approve(address _to, uint256 _tokenId) public whenNotPaused {
1060         super.approve(_to, _tokenId);
1061     }
1062  
1063     /// @dev overrides setApprovalForAll function to add pause/unpause functionality
1064     function setApprovalForAll(address _to, bool _approved) public whenNotPaused {
1065         super.setApprovalForAll(_to, _approved);
1066     }    
1067 
1068     /// @dev overrides transferFrom function to add pause/unpause functionality
1069     ///  affects safeTransferFrom functions as well
1070     function transferFrom(
1071         address _from,
1072         address _to,
1073         uint256 _tokenId
1074     )
1075         public
1076         whenNotPaused
1077     {
1078         super.transferFrom(_from, _to, _tokenId);
1079     }
1080 }
1081 
1082 // File: contracts/Accounting.sol
1083 
1084 // import "../installed_contracts/math.sol";
1085 
1086 
1087 
1088 // @title Accounting: Part of MEH contract responsible for eth accounting.
1089 contract Accounting is MEHAccessControl {
1090     using SafeMath for uint256;
1091 
1092     // Balances of users, admin, charity
1093     mapping(address => uint256) public balances;
1094 
1095     // Emitted when a user deposits or withdraws funds from the contract
1096     event LogContractBalance(address payerOrPayee, int balanceChange);
1097 
1098 // ** PAYMENT PROCESSING ** //
1099     
1100     /// @dev Withdraws users available balance.
1101     function withdraw() external whenNotPaused {
1102         address payee = msg.sender;
1103         uint256 payment = balances[payee];
1104 
1105         require(payment != 0);
1106         assert(address(this).balance >= payment);
1107 
1108         balances[payee] = 0;
1109 
1110         // reentrancy safe
1111         payee.transfer(payment);
1112         emit LogContractBalance(payee, int256(-payment));
1113     }
1114 
1115     /// @dev Lets external authorized contract (operators) to transfer balances within MEH contract.
1116     ///  MEH contract doesn't transfer funds on its own. Instead Market and Rentals contracts
1117     ///  are granted operator access.
1118     function operatorTransferFunds(
1119         address _payer, 
1120         address _recipient, 
1121         uint _amount) 
1122     external 
1123     onlyBalanceOperators
1124     whenNotPaused
1125     {
1126         require(balances[_payer] >= _amount);
1127         _deductFrom(_payer, _amount);
1128         _depositTo(_recipient, _amount);
1129     }
1130 
1131     /// @dev Deposits eth to msg.sender balance.
1132     function depositFunds() internal whenNotPaused {
1133         _depositTo(msg.sender, msg.value);
1134         emit LogContractBalance(msg.sender, int256(msg.value));
1135     }
1136 
1137     /// @dev Increases recipients internal balance.
1138     function _depositTo(address _recipient, uint _amount) internal {
1139         balances[_recipient] = balances[_recipient].add(_amount);
1140     }
1141 
1142     /// @dev Increases payers internal balance.
1143     function _deductFrom(address _payer, uint _amount) internal {
1144         balances[_payer] = balances[_payer].sub(_amount);
1145     }
1146 
1147 // ** ADMIN ** //
1148 
1149     /// @notice Allows admin to withdraw contract balance in emergency. And distribute manualy
1150     ///  aftrewards.
1151     /// @dev As the contract is not designed to keep users funds (users can withdraw
1152     ///  at anytime) it should be relatively easy to manualy transfer unclaimed funds to 
1153     ///  their owners. This is an alternatinve to selfdestruct allowing blocks ledger (ERC721 tokens)
1154     ///  to be immutable.
1155     function adminRescueFunds() external onlyOwner whenPaused {
1156         address payee = owner;
1157         uint256 payment = address(this).balance;
1158         payee.transfer(payment);
1159     }
1160 
1161     /// @dev Checks if a msg.sender has enough balance to pay the price _needed.
1162     function canPay(uint _needed) internal view returns (bool) {
1163         return (msg.value.add(balances[msg.sender]) >= _needed);
1164     }
1165 }
1166 
1167 // File: contracts/MEH.sol
1168 
1169 /*
1170 MillionEther smart contract - decentralized advertising platform.
1171 
1172 This program is free software: you can redistribute it and/or modifromY
1173 it under the terms of the GNU General Public License as published by
1174 the Free Software Foundation, either version 3 of the License, or
1175 (at your option) any later version.
1176 
1177 This program is distributed in the hope that it will be useful,
1178 but WITHOUT ANY WARRANTY; without even the implied warranty of
1179 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1180 GNU General Public License for more details.
1181 
1182 You should have received a copy of the GNU General Public License
1183 along with this program.  If not, see <http://www.gnu.org/licenses/>.
1184 */
1185 
1186 /*
1187 * A 1000x1000 pixel field is displayed at TheMillionEtherHomepage.com. 
1188 * This smart contract lets anyone buy 10x10 pixel blocks and place ads there.
1189 * It also allows to sell blocks and rent them out to other advertisers. 
1190 *
1191 * 10x10 pixels blocks are addressed by xy coordinates. So 1000x1000 pixel field is 100 by 100 blocks.
1192 * Making up 10 000 blocks in total. Each block is an ERC721 (non fungible token) token. 
1193 *
1194 * At the initial sale the price for each block is $1 (price is feeded by an oracle). After
1195 * every 1000 blocks sold (every 10%) the price doubles. Owners can sell and rent out blocks at any
1196 * price they want. Owners and renters can place and replace ads to their blocks as many times they 
1197 * want.
1198 *
1199 * All heavy logic is delegated to external upgradable contracts. There are 4 main modules (contracts):
1200 *     - MEH: Million Ether Homepage (MEH) contract. Provides user interface and accounting 
1201 *         functionality. It is immutable and it keeps Non fungible ERC721 tokens (10x10 pixel blocks) 
1202 *         ledger and eth balances. 
1203 *     - Market: Plugable. Provides methods for buy-sell functionality, keeps buy-sell ledger, 
1204 *         querries oracle for a ETH-USD price, 
1205 *     - Rentals: Plugable. Provides methods for rentout-rent functionality, keeps rentout-rent ledger.
1206 *     - Ads: Plugable. Provides methods for image placement functionality.
1207 * 
1208 */
1209 
1210 /// @title MEH: Million Ether Homepage. Buy, sell, rent out pixels and place ads.
1211 /// @author Peter Porobov (https://keybase.io/peterporobov)
1212 /// @notice The main contract, accounting and user interface. Immutable.
1213 contract MEH is MehERC721, Accounting {
1214 
1215     /// @notice emited when an area blocks is bought
1216     event LogBuys(
1217         uint ID,
1218         uint8 fromX,
1219         uint8 fromY,
1220         uint8 toX,
1221         uint8 toY,
1222         address newLandlord
1223     );
1224 
1225     /// @notice emited when an area blocks is marked for sale
1226     event LogSells(
1227         uint ID,
1228         uint8 fromX,
1229         uint8 fromY,
1230         uint8 toX,
1231         uint8 toY,
1232         uint sellPrice
1233     );
1234 
1235     /// @notice emited when an area blocks is marked for rent
1236     event LogRentsOut(
1237         uint ID,
1238         uint8 fromX,
1239         uint8 fromY,
1240         uint8 toX,
1241         uint8 toY,
1242         uint rentPricePerPeriodWei
1243     );
1244 
1245     /// @notice emited when an area blocks is rented
1246     event LogRents(
1247         uint ID,
1248         uint8 fromX,
1249         uint8 fromY,
1250         uint8 toX,
1251         uint8 toY,
1252         uint numberOfPeriods,
1253         uint rentedFrom
1254     );
1255 
1256     /// @notice emited when an ad is placed to an area
1257     event LogAds(uint ID, 
1258         uint8 fromX,
1259         uint8 fromY,
1260         uint8 toX,
1261         uint8 toY,
1262         string imageSourceUrl,
1263         string adUrl,
1264         string adText,
1265         address indexed advertiser);
1266 
1267 // ** BUY AND SELL BLOCKS ** //
1268     
1269     /// @notice lets a message sender to buy blocks within area
1270     /// @dev if using a contract to buy an area make sure to implement ERC721 functionality 
1271     ///  as tokens are transfered using "transferFrom" function and not "safeTransferFrom"
1272     ///  in order to avoid external calls.
1273     function buyArea(uint8 fromX, uint8 fromY, uint8 toX, uint8 toY) 
1274         external
1275         whenNotPaused
1276         payable
1277     {   
1278         // check input parameters and eth deposited
1279         require(isLegalCoordinates(fromX, fromY, toX, toY));
1280         require(canPay(areaPrice(fromX, fromY, toX, toY)));
1281         depositFunds();
1282 
1283         // try to buy blocks through market contract
1284         // will get an id of buy-sell operation if succeeds (if all blocks available)
1285         uint id = market.buyBlocks(msg.sender, blocksList(fromX, fromY, toX, toY));
1286         emit LogBuys(id, fromX, fromY, toX, toY, msg.sender);
1287     }
1288 
1289     /// @notice lets a message sender to mark blocks for sale at price set for each block in wei
1290     /// @dev (priceForEachBlockCents = 0 - not for sale)
1291     function sellArea(uint8 fromX, uint8 fromY, uint8 toX, uint8 toY, uint priceForEachBlockWei)
1292         external 
1293         whenNotPaused
1294     {   
1295         // check input parameters
1296         require(isLegalCoordinates(fromX, fromY, toX, toY));
1297 
1298         // try to mark blocks for sale through market contract
1299         // will get an id of buy-sell operation if succeeds (if owns all blocks)
1300         uint id = market.sellBlocks(
1301             msg.sender, 
1302             priceForEachBlockWei, 
1303             blocksList(fromX, fromY, toX, toY)
1304         );
1305         emit LogSells(id, fromX, fromY, toX, toY, priceForEachBlockWei);
1306     }
1307 
1308     /// @notice get area price in wei
1309     function areaPrice(uint8 fromX, uint8 fromY, uint8 toX, uint8 toY) 
1310         public 
1311         view 
1312         returns (uint) 
1313     {   
1314         // check input
1315         require(isLegalCoordinates(fromX, fromY, toX, toY));
1316 
1317         // querry areaPrice in wei at market contract
1318         return market.areaPrice(blocksList(fromX, fromY, toX, toY));
1319     }
1320 
1321 // ** RENT OUT AND RENT BLOCKS ** //
1322         
1323     /// @notice Rent out an area of blocks at coordinates [fromX, fromY, toX, toY] at a price for 
1324     ///  each block in wei
1325     /// @dev if rentPricePerPeriodWei = 0 then makes area not available for rent
1326     function rentOutArea(uint8 fromX, uint8 fromY, uint8 toX, uint8 toY, uint rentPricePerPeriodWei)
1327         external
1328         whenNotPaused
1329     {   
1330         // check input
1331         require(isLegalCoordinates(fromX, fromY, toX, toY));
1332 
1333         // try to mark blocks as rented out through rentals contract
1334         // will get an id of rent-rentout operation if succeeds (if message sender owns blocks)
1335         uint id = rentals.rentOutBlocks(
1336             msg.sender, 
1337             rentPricePerPeriodWei, 
1338             blocksList(fromX, fromY, toX, toY)
1339         );
1340         emit LogRentsOut(id, fromX, fromY, toX, toY, rentPricePerPeriodWei);
1341     }
1342     
1343     /// @notice Rent an area of blocks at coordinates [fromX, fromY, toX, toY] for a number of 
1344     ///  periods specified
1345     ///  (period length is specified in rentals contract)
1346     function rentArea(uint8 fromX, uint8 fromY, uint8 toX, uint8 toY, uint numberOfPeriods)
1347         external
1348         payable
1349         whenNotPaused
1350     {   
1351         // check input parameters and eth deposited
1352         // checks number of periods > 0 in rentals contract
1353         require(isLegalCoordinates(fromX, fromY, toX, toY));
1354         require(canPay(areaRentPrice(fromX, fromY, toX, toY, numberOfPeriods)));
1355         depositFunds();
1356 
1357         // try to rent blocks through rentals contract
1358         // will get an id of rent-rentout operation if succeeds (if all blocks available for rent)
1359         uint id = rentals.rentBlocks(
1360             msg.sender, 
1361             numberOfPeriods, 
1362             blocksList(fromX, fromY, toX, toY)
1363         );
1364         emit LogRents(id, fromX, fromY, toX, toY, numberOfPeriods, 0);
1365     }
1366 
1367     /// @notice get area rent price in wei for number of periods specified 
1368     ///  (period length is specified in rentals contract) 
1369     function areaRentPrice(uint8 fromX, uint8 fromY, uint8 toX, uint8 toY, uint numberOfPeriods)
1370         public 
1371         view 
1372         returns (uint) 
1373     {   
1374         // check input 
1375         require(isLegalCoordinates(fromX, fromY, toX, toY));
1376 
1377         // querry areaPrice in wei at rentals contract
1378         return rentals.blocksRentPrice (numberOfPeriods, blocksList(fromX, fromY, toX, toY));
1379     }
1380 
1381 // ** PLACE ADS ** //
1382     
1383     /// @notice places ads (image, caption and link to a website) into desired coordinates
1384     /// @dev nothing is stored in any of the contracts except an image id. All other data is 
1385     ///  only emitted in event. Basicaly this function just verifies if an event is allowed 
1386     ///  to be emitted.
1387     function placeAds( 
1388         uint8 fromX, 
1389         uint8 fromY, 
1390         uint8 toX, 
1391         uint8 toY, 
1392         string imageSource, 
1393         string link, 
1394         string text
1395     ) 
1396         external
1397         whenNotPaused
1398     {   
1399         // check input
1400         require(isLegalCoordinates(fromX, fromY, toX, toY));
1401 
1402         // try to place ads through ads contract
1403         // will get an image id if succeeds (if advertiser owns or rents all blocks within area)
1404         uint AdsId = ads.advertiseOnBlocks(
1405             msg.sender, 
1406             blocksList(fromX, fromY, toX, toY), 
1407             imageSource, 
1408             link, 
1409             text
1410         );
1411         emit LogAds(AdsId, fromX, fromY, toX, toY, imageSource, link, text, msg.sender);
1412     }
1413 
1414     /// @notice check if an advertiser is allowed to put ads within area (i.e. owns or rents all 
1415     ///  blocks)
1416     function canAdvertise(
1417         address advertiser,
1418         uint8 fromX, 
1419         uint8 fromY, 
1420         uint8 toX, 
1421         uint8 toY
1422     ) 
1423         external
1424         view
1425         returns (bool)
1426     {   
1427         // check user input
1428         require(isLegalCoordinates(fromX, fromY, toX, toY));
1429 
1430         // querry permission at ads contract
1431         return ads.canAdvertiseOnBlocks(advertiser, blocksList(fromX, fromY, toX, toY));
1432     }
1433 
1434 // ** IMPORT BLOCKS ** //
1435 
1436     /// @notice import blocks from previous version Million Ether Homepage
1437     function adminImportOldMEBlock(uint8 x, uint8 y) external onlyOwner {
1438         (uint id, address newLandlord) = market.importOldMEBlock(x, y);
1439         emit LogBuys(id, x, y, x, y, newLandlord);
1440     }
1441 
1442 // ** INFO GETTERS ** //
1443     
1444     /// @notice get an owner(address) of block at a specified coordinates
1445     function getBlockOwner(uint8 x, uint8 y) external view returns (address) {
1446         return ownerOf(blockID(x, y));
1447     }
1448 
1449 // ** UTILS ** //
1450     
1451     /// @notice get ERC721 token id corresponding to xy coordinates
1452     function blockID(uint8 x, uint8 y) public pure returns (uint16) {
1453         return (uint16(y) - 1) * 100 + uint16(x);
1454     }
1455 
1456     /// @notice get a number of blocks within area
1457     function countBlocks(
1458         uint8 fromX, 
1459         uint8 fromY, 
1460         uint8 toX, 
1461         uint8 toY
1462     ) 
1463         internal 
1464         pure 
1465         returns (uint16)
1466     {
1467         return (toX - fromX + 1) * (toY - fromY + 1);
1468     }
1469 
1470     /// @notice get an array of all block ids (i.e. ERC721 token ids) within area
1471     function blocksList(
1472         uint8 fromX, 
1473         uint8 fromY, 
1474         uint8 toX, 
1475         uint8 toY
1476     ) 
1477         internal 
1478         pure 
1479         returns (uint16[] memory r) 
1480     {
1481         uint i = 0;
1482         r = new uint16[](countBlocks(fromX, fromY, toX, toY));
1483         for (uint8 ix=fromX; ix<=toX; ix++) {
1484             for (uint8 iy=fromY; iy<=toY; iy++) {
1485                 r[i] = blockID(ix, iy);
1486                 i++;
1487             }
1488         }
1489     }
1490     
1491     /// @notice insures that area coordinates are within 100x100 field and 
1492     ///  from-coordinates >= to-coordinates
1493     /// @dev function is used instead of modifier as modifier 
1494     ///  required too much stack for placeImage and rentBlocks
1495     function isLegalCoordinates(
1496         uint8 _fromX, 
1497         uint8 _fromY, 
1498         uint8 _toX, 
1499         uint8 _toY
1500     )    
1501         private 
1502         pure 
1503         returns (bool) 
1504     {
1505         return ((_fromX >= 1) && (_fromY >=1)  && (_toX <= 100) && (_toY <= 100) 
1506             && (_fromX <= _toX) && (_fromY <= _toY));
1507     }
1508 }