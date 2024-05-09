1 pragma solidity ^0.4.23;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    */
40   function renounceOwnership() public onlyOwner {
41     emit OwnershipRenounced(owner);
42     owner = address(0);
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param _newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address _newOwner) public onlyOwner {
50     _transferOwnership(_newOwner);
51   }
52 
53   /**
54    * @dev Transfers control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function _transferOwnership(address _newOwner) internal {
58     require(_newOwner != address(0));
59     emit OwnershipTransferred(owner, _newOwner);
60     owner = _newOwner;
61   }
62 }
63 
64 // File: contracts/Adminable.sol
65 
66 /**
67  * @title Adminable
68  * @dev The adminable contract has an admin address, and provides basic authorization control
69  * functions, this simplifies the implementation of "user permissions".
70  */
71 contract Adminable is Ownable {
72     address public admin;
73 
74     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
75 
76     /**
77      * @dev The Mintable constructor sets the original `minter` of the contract to the sender
78      * account.
79      */
80     constructor() public {
81         admin = msg.sender;
82     }
83 
84     /**
85      * @dev Throws if called by any account other than the admin.
86      */
87     modifier onlyAdmin() {
88         require(msg.sender == admin, "Only admin is allowed to execute this method.");
89         _;
90     }
91 
92     /**
93      * @dev Allows the current owner to transfer control of the admin to newAdmin
94      */
95     function transferAdmin(address newAdmin) public onlyOwner {
96         require(newAdmin != address(0));
97         emit AdminTransferred(admin, newAdmin);
98         admin = newAdmin;
99     }
100 }
101 
102 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
103 
104 /**
105  * @title ERC721 Non-Fungible Token Standard basic interface
106  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
107  */
108 contract ERC721Basic {
109   event Transfer(
110     address indexed _from,
111     address indexed _to,
112     uint256 _tokenId
113   );
114   event Approval(
115     address indexed _owner,
116     address indexed _approved,
117     uint256 _tokenId
118   );
119   event ApprovalForAll(
120     address indexed _owner,
121     address indexed _operator,
122     bool _approved
123   );
124 
125   function balanceOf(address _owner) public view returns (uint256 _balance);
126   function ownerOf(uint256 _tokenId) public view returns (address _owner);
127   function exists(uint256 _tokenId) public view returns (bool _exists);
128 
129   function approve(address _to, uint256 _tokenId) public;
130   function getApproved(uint256 _tokenId)
131     public view returns (address _operator);
132 
133   function setApprovalForAll(address _operator, bool _approved) public;
134   function isApprovedForAll(address _owner, address _operator)
135     public view returns (bool);
136 
137   function transferFrom(address _from, address _to, uint256 _tokenId) public;
138   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
139     public;
140 
141   function safeTransferFrom(
142     address _from,
143     address _to,
144     uint256 _tokenId,
145     bytes _data
146   )
147     public;
148 }
149 
150 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
151 
152 /**
153  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
154  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
155  */
156 contract ERC721Enumerable is ERC721Basic {
157   function totalSupply() public view returns (uint256);
158   function tokenOfOwnerByIndex(
159     address _owner,
160     uint256 _index
161   )
162     public
163     view
164     returns (uint256 _tokenId);
165 
166   function tokenByIndex(uint256 _index) public view returns (uint256);
167 }
168 
169 
170 /**
171  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
172  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
173  */
174 contract ERC721Metadata is ERC721Basic {
175   function name() public view returns (string _name);
176   function symbol() public view returns (string _symbol);
177   function tokenURI(uint256 _tokenId) public view returns (string);
178 }
179 
180 
181 /**
182  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
183  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
184  */
185 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
186 }
187 
188 // File: openzeppelin-solidity/contracts/AddressUtils.sol
189 
190 /**
191  * Utility library of inline functions on addresses
192  */
193 library AddressUtils {
194 
195   /**
196    * Returns whether the target address is a contract
197    * @dev This function will return false if invoked during the constructor of a contract,
198    *  as the code is not actually created until after the constructor finishes.
199    * @param addr address to check
200    * @return whether the target address is a contract
201    */
202   function isContract(address addr) internal view returns (bool) {
203     uint256 size;
204     // XXX Currently there is no better way to check if there is a contract in an address
205     // than to check the size of the code at that address.
206     // See https://ethereum.stackexchange.com/a/14016/36603
207     // for more details about how this works.
208     // TODO Check this again before the Serenity release, because all addresses will be
209     // contracts then.
210     // solium-disable-next-line security/no-inline-assembly
211     assembly { size := extcodesize(addr) }
212     return size > 0;
213   }
214 
215 }
216 
217 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
218 
219 /**
220  * @title SafeMath
221  * @dev Math operations with safety checks that throw on error
222  */
223 library SafeMath {
224 
225   /**
226   * @dev Multiplies two numbers, throws on overflow.
227   */
228   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
229     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
230     // benefit is lost if 'b' is also tested.
231     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
232     if (a == 0) {
233       return 0;
234     }
235 
236     c = a * b;
237     assert(c / a == b);
238     return c;
239   }
240 
241   /**
242   * @dev Integer division of two numbers, truncating the quotient.
243   */
244   function div(uint256 a, uint256 b) internal pure returns (uint256) {
245     // assert(b > 0); // Solidity automatically throws when dividing by 0
246     // uint256 c = a / b;
247     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
248     return a / b;
249   }
250 
251   /**
252   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
253   */
254   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
255     assert(b <= a);
256     return a - b;
257   }
258 
259   /**
260   * @dev Adds two numbers, throws on overflow.
261   */
262   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
263     c = a + b;
264     assert(c >= a);
265     return c;
266   }
267 }
268 
269 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
270 
271 /**
272  * @title ERC721 token receiver interface
273  * @dev Interface for any contract that wants to support safeTransfers
274  *  from ERC721 asset contracts.
275  */
276 contract ERC721Receiver {
277   /**
278    * @dev Magic value to be returned upon successful reception of an NFT
279    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
280    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
281    */
282   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
283 
284   /**
285    * @notice Handle the receipt of an NFT
286    * @dev The ERC721 smart contract calls this function on the recipient
287    *  after a `safetransfer`. This function MAY throw to revert and reject the
288    *  transfer. This function MUST use 50,000 gas or less. Return of other
289    *  than the magic value MUST result in the transaction being reverted.
290    *  Note: the contract address is always the message sender.
291    * @param _from The sending address
292    * @param _tokenId The NFT identifier which is being transfered
293    * @param _data Additional data with no specified format
294    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
295    */
296   function onERC721Received(
297     address _from,
298     uint256 _tokenId,
299     bytes _data
300   )
301     public
302     returns(bytes4);
303 }
304 
305 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
306 
307 /**
308  * @title ERC721 Non-Fungible Token Standard basic implementation
309  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
310  */
311 contract ERC721BasicToken is ERC721Basic {
312   using SafeMath for uint256;
313   using AddressUtils for address;
314 
315   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
316   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
317   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
318 
319   // Mapping from token ID to owner
320   mapping (uint256 => address) internal tokenOwner;
321 
322   // Mapping from token ID to approved address
323   mapping (uint256 => address) internal tokenApprovals;
324 
325   // Mapping from owner to number of owned token
326   mapping (address => uint256) internal ownedTokensCount;
327 
328   // Mapping from owner to operator approvals
329   mapping (address => mapping (address => bool)) internal operatorApprovals;
330 
331   /**
332    * @dev Guarantees msg.sender is owner of the given token
333    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
334    */
335   modifier onlyOwnerOf(uint256 _tokenId) {
336     require(ownerOf(_tokenId) == msg.sender);
337     _;
338   }
339 
340   /**
341    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
342    * @param _tokenId uint256 ID of the token to validate
343    */
344   modifier canTransfer(uint256 _tokenId) {
345     require(isApprovedOrOwner(msg.sender, _tokenId));
346     _;
347   }
348 
349   /**
350    * @dev Gets the balance of the specified address
351    * @param _owner address to query the balance of
352    * @return uint256 representing the amount owned by the passed address
353    */
354   function balanceOf(address _owner) public view returns (uint256) {
355     require(_owner != address(0));
356     return ownedTokensCount[_owner];
357   }
358 
359   /**
360    * @dev Gets the owner of the specified token ID
361    * @param _tokenId uint256 ID of the token to query the owner of
362    * @return owner address currently marked as the owner of the given token ID
363    */
364   function ownerOf(uint256 _tokenId) public view returns (address) {
365     address owner = tokenOwner[_tokenId];
366     require(owner != address(0));
367     return owner;
368   }
369 
370   /**
371    * @dev Returns whether the specified token exists
372    * @param _tokenId uint256 ID of the token to query the existence of
373    * @return whether the token exists
374    */
375   function exists(uint256 _tokenId) public view returns (bool) {
376     address owner = tokenOwner[_tokenId];
377     return owner != address(0);
378   }
379 
380   /**
381    * @dev Approves another address to transfer the given token ID
382    * @dev The zero address indicates there is no approved address.
383    * @dev There can only be one approved address per token at a given time.
384    * @dev Can only be called by the token owner or an approved operator.
385    * @param _to address to be approved for the given token ID
386    * @param _tokenId uint256 ID of the token to be approved
387    */
388   function approve(address _to, uint256 _tokenId) public {
389     address owner = ownerOf(_tokenId);
390     require(_to != owner);
391     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
392 
393     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
394       tokenApprovals[_tokenId] = _to;
395       emit Approval(owner, _to, _tokenId);
396     }
397   }
398 
399   /**
400    * @dev Gets the approved address for a token ID, or zero if no address set
401    * @param _tokenId uint256 ID of the token to query the approval of
402    * @return address currently approved for the given token ID
403    */
404   function getApproved(uint256 _tokenId) public view returns (address) {
405     return tokenApprovals[_tokenId];
406   }
407 
408   /**
409    * @dev Sets or unsets the approval of a given operator
410    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
411    * @param _to operator address to set the approval
412    * @param _approved representing the status of the approval to be set
413    */
414   function setApprovalForAll(address _to, bool _approved) public {
415     require(_to != msg.sender);
416     operatorApprovals[msg.sender][_to] = _approved;
417     emit ApprovalForAll(msg.sender, _to, _approved);
418   }
419 
420   /**
421    * @dev Tells whether an operator is approved by a given owner
422    * @param _owner owner address which you want to query the approval of
423    * @param _operator operator address which you want to query the approval of
424    * @return bool whether the given operator is approved by the given owner
425    */
426   function isApprovedForAll(
427     address _owner,
428     address _operator
429   )
430     public
431     view
432     returns (bool)
433   {
434     return operatorApprovals[_owner][_operator];
435   }
436 
437   /**
438    * @dev Transfers the ownership of a given token ID to another address
439    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
440    * @dev Requires the msg sender to be the owner, approved, or operator
441    * @param _from current owner of the token
442    * @param _to address to receive the ownership of the given token ID
443    * @param _tokenId uint256 ID of the token to be transferred
444   */
445   function transferFrom(
446     address _from,
447     address _to,
448     uint256 _tokenId
449   )
450     public
451     canTransfer(_tokenId)
452   {
453     require(_from != address(0));
454     require(_to != address(0));
455 
456     clearApproval(_from, _tokenId);
457     removeTokenFrom(_from, _tokenId);
458     addTokenTo(_to, _tokenId);
459 
460     emit Transfer(_from, _to, _tokenId);
461   }
462 
463   /**
464    * @dev Safely transfers the ownership of a given token ID to another address
465    * @dev If the target address is a contract, it must implement `onERC721Received`,
466    *  which is called upon a safe transfer, and return the magic value
467    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
468    *  the transfer is reverted.
469    * @dev Requires the msg sender to be the owner, approved, or operator
470    * @param _from current owner of the token
471    * @param _to address to receive the ownership of the given token ID
472    * @param _tokenId uint256 ID of the token to be transferred
473   */
474   function safeTransferFrom(
475     address _from,
476     address _to,
477     uint256 _tokenId
478   )
479     public
480     canTransfer(_tokenId)
481   {
482     // solium-disable-next-line arg-overflow
483     safeTransferFrom(_from, _to, _tokenId, "");
484   }
485 
486   /**
487    * @dev Safely transfers the ownership of a given token ID to another address
488    * @dev If the target address is a contract, it must implement `onERC721Received`,
489    *  which is called upon a safe transfer, and return the magic value
490    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
491    *  the transfer is reverted.
492    * @dev Requires the msg sender to be the owner, approved, or operator
493    * @param _from current owner of the token
494    * @param _to address to receive the ownership of the given token ID
495    * @param _tokenId uint256 ID of the token to be transferred
496    * @param _data bytes data to send along with a safe transfer check
497    */
498   function safeTransferFrom(
499     address _from,
500     address _to,
501     uint256 _tokenId,
502     bytes _data
503   )
504     public
505     canTransfer(_tokenId)
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
540    * @dev Reverts if the given token ID already exists
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
552    * @dev Reverts if the token does not exist
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
563    * @dev Reverts if the given address is not indeed the owner of the token
564    * @param _owner owner of the token
565    * @param _tokenId uint256 ID of the token to be transferred
566    */
567   function clearApproval(address _owner, uint256 _tokenId) internal {
568     require(ownerOf(_tokenId) == _owner);
569     if (tokenApprovals[_tokenId] != address(0)) {
570       tokenApprovals[_tokenId] = address(0);
571       emit Approval(_owner, address(0), _tokenId);
572     }
573   }
574 
575   /**
576    * @dev Internal function to add a token ID to the list of a given address
577    * @param _to address representing the new owner of the given token ID
578    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
579    */
580   function addTokenTo(address _to, uint256 _tokenId) internal {
581     require(tokenOwner[_tokenId] == address(0));
582     tokenOwner[_tokenId] = _to;
583     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
584   }
585 
586   /**
587    * @dev Internal function to remove a token ID from the list of a given address
588    * @param _from address representing the previous owner of the given token ID
589    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
590    */
591   function removeTokenFrom(address _from, uint256 _tokenId) internal {
592     require(ownerOf(_tokenId) == _from);
593     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
594     tokenOwner[_tokenId] = address(0);
595   }
596 
597   /**
598    * @dev Internal function to invoke `onERC721Received` on a target address
599    * @dev The call is not executed if the target address is not a contract
600    * @param _from address representing the previous owner of the given token ID
601    * @param _to target address that will receive the tokens
602    * @param _tokenId uint256 ID of the token to be transferred
603    * @param _data bytes optional data to send along with the call
604    * @return whether the call correctly returned the expected magic value
605    */
606   function checkAndCallSafeTransfer(
607     address _from,
608     address _to,
609     uint256 _tokenId,
610     bytes _data
611   )
612     internal
613     returns (bool)
614   {
615     if (!_to.isContract()) {
616       return true;
617     }
618     bytes4 retval = ERC721Receiver(_to).onERC721Received(
619       _from, _tokenId, _data);
620     return (retval == ERC721_RECEIVED);
621   }
622 }
623 
624 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
625 
626 /**
627  * @title Full ERC721 Token
628  * This implementation includes all the required and some optional functionality of the ERC721 standard
629  * Moreover, it includes approve all functionality using operator terminology
630  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
631  */
632 contract ERC721Token is ERC721, ERC721BasicToken {
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
660   }
661 
662   /**
663    * @dev Gets the token name
664    * @return string representing the token name
665    */
666   function name() public view returns (string) {
667     return name_;
668   }
669 
670   /**
671    * @dev Gets the token symbol
672    * @return string representing the token symbol
673    */
674   function symbol() public view returns (string) {
675     return symbol_;
676   }
677 
678   /**
679    * @dev Returns an URI for a given token ID
680    * @dev Throws if the token ID does not exist. May return an empty string.
681    * @param _tokenId uint256 ID of the token to query
682    */
683   function tokenURI(uint256 _tokenId) public view returns (string) {
684     require(exists(_tokenId));
685     return tokenURIs[_tokenId];
686   }
687 
688   /**
689    * @dev Gets the token ID at a given index of the tokens list of the requested owner
690    * @param _owner address owning the tokens list to be accessed
691    * @param _index uint256 representing the index to be accessed of the requested tokens list
692    * @return uint256 token ID at the given index of the tokens list owned by the requested address
693    */
694   function tokenOfOwnerByIndex(
695     address _owner,
696     uint256 _index
697   )
698     public
699     view
700     returns (uint256)
701   {
702     require(_index < balanceOf(_owner));
703     return ownedTokens[_owner][_index];
704   }
705 
706   /**
707    * @dev Gets the total amount of tokens stored by the contract
708    * @return uint256 representing the total amount of tokens
709    */
710   function totalSupply() public view returns (uint256) {
711     return allTokens.length;
712   }
713 
714   /**
715    * @dev Gets the token ID at a given index of all the tokens in this contract
716    * @dev Reverts if the index is greater or equal to the total number of tokens
717    * @param _index uint256 representing the index to be accessed of the tokens list
718    * @return uint256 token ID at the given index of the tokens list
719    */
720   function tokenByIndex(uint256 _index) public view returns (uint256) {
721     require(_index < totalSupply());
722     return allTokens[_index];
723   }
724 
725   /**
726    * @dev Internal function to set the token URI for a given token
727    * @dev Reverts if the token ID does not exist
728    * @param _tokenId uint256 ID of the token to set its URI
729    * @param _uri string URI to assign
730    */
731   function _setTokenURI(uint256 _tokenId, string _uri) internal {
732     require(exists(_tokenId));
733     tokenURIs[_tokenId] = _uri;
734   }
735 
736   /**
737    * @dev Internal function to add a token ID to the list of a given address
738    * @param _to address representing the new owner of the given token ID
739    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
740    */
741   function addTokenTo(address _to, uint256 _tokenId) internal {
742     super.addTokenTo(_to, _tokenId);
743     uint256 length = ownedTokens[_to].length;
744     ownedTokens[_to].push(_tokenId);
745     ownedTokensIndex[_tokenId] = length;
746   }
747 
748   /**
749    * @dev Internal function to remove a token ID from the list of a given address
750    * @param _from address representing the previous owner of the given token ID
751    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
752    */
753   function removeTokenFrom(address _from, uint256 _tokenId) internal {
754     super.removeTokenFrom(_from, _tokenId);
755 
756     uint256 tokenIndex = ownedTokensIndex[_tokenId];
757     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
758     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
759 
760     ownedTokens[_from][tokenIndex] = lastToken;
761     ownedTokens[_from][lastTokenIndex] = 0;
762     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
763     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
764     // the lastToken to the first position, and then dropping the element placed in the last position of the list
765 
766     ownedTokens[_from].length--;
767     ownedTokensIndex[_tokenId] = 0;
768     ownedTokensIndex[lastToken] = tokenIndex;
769   }
770 
771   /**
772    * @dev Internal function to mint a new token
773    * @dev Reverts if the given token ID already exists
774    * @param _to address the beneficiary that will own the minted token
775    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
776    */
777   function _mint(address _to, uint256 _tokenId) internal {
778     super._mint(_to, _tokenId);
779 
780     allTokensIndex[_tokenId] = allTokens.length;
781     allTokens.push(_tokenId);
782   }
783 
784   /**
785    * @dev Internal function to burn a specific token
786    * @dev Reverts if the token does not exist
787    * @param _owner owner of the token to burn
788    * @param _tokenId uint256 ID of the token being burned by the msg.sender
789    */
790   function _burn(address _owner, uint256 _tokenId) internal {
791     super._burn(_owner, _tokenId);
792 
793     // Clear metadata (if any)
794     if (bytes(tokenURIs[_tokenId]).length != 0) {
795       delete tokenURIs[_tokenId];
796     }
797 
798     // Reorg all tokens array
799     uint256 tokenIndex = allTokensIndex[_tokenId];
800     uint256 lastTokenIndex = allTokens.length.sub(1);
801     uint256 lastToken = allTokens[lastTokenIndex];
802 
803     allTokens[tokenIndex] = lastToken;
804     allTokens[lastTokenIndex] = 0;
805 
806     allTokens.length--;
807     allTokensIndex[_tokenId] = 0;
808     allTokensIndex[lastToken] = tokenIndex;
809   }
810 
811 }
812 
813 // File: contracts/EpicsToken.sol
814 
815 contract EpicsToken is ERC721Token("Epics.gg Token", "EPICS TOKEN"), Ownable, Adminable {
816     event TokenLock(string uuid);    // Single token trade locked
817     event TokenUnlock(string uuid);  // Single token trade unlocked
818     event UserVerified(string userToken, address userAddress);  // User sends this to verify their eth account
819     event TokenCreated(string uuid, address to);
820     event TokenDestroyed(string uuid);
821     event TokenOwnerSet(address from, address to, string uuid);
822 
823     event TradingLock();          // Globally locked
824     event TradingUnlock();        // Globally unlocked
825 
826     struct Token {
827         string uuid;
828         string properties;
829     }
830 
831     mapping (string => uint256) private uuidToTokenId;  // Maps UUID to token id
832     mapping (string => bool) private uuidExists;        // Checking if UUID exists
833     mapping (uint256 => bool) private lockedTokens;     // Prevent certain tokens from being traded
834     bool public tradingLocked;                          // Prevent all trading?
835     Token[] tokens;                                     // Keeps track of our array of Token structs
836 
837     /**
838     * @dev Gets the owner of the specified token UUID
839     */
840     function ownerOfUUID(string _uuid) public view returns (address) {
841         require(uuidExists[_uuid] == true, "UUID does not exist."); // Enable these when Truffle updates solc to 0.4.23
842         uint256 _tokenId = uuidToTokenId[_uuid];
843         return ownerOf(_tokenId);
844     }
845 
846     /**
847     * @dev Gets the token id for the specified UUID
848     */
849     function tokenIdOfUUID(string _uuid) public view returns (uint256) {
850         require(uuidExists[_uuid] == true, "UUID does not exist.");
851         return uuidToTokenId[_uuid];
852     }
853 
854     /**
855     *  Returns the token data associated with a token id
856     */
857     function getToken(uint256 _tokenId) public view returns (string uuid, string properties) {
858         require(exists(_tokenId), "Token does not exist.");
859         Token memory token = tokens[_tokenId];
860         uuid = token.uuid;
861         properties = token.properties;
862     }
863 
864     function isTokenLocked(uint256 _tokenId) public view returns (bool) {
865         require(exists(_tokenId), "Token does not exist.");
866         return lockedTokens[_tokenId];
867     }
868 
869     function verifyUser(string userToken) public returns (bool) {
870         emit UserVerified(userToken, msg.sender);
871         return true;
872     }
873 
874     function tokensByOwner(address _owner) public view returns (uint256[]) {
875         return ownedTokens[_owner];
876     }
877 
878     // ------------------------------------------------------------------------------------------------------
879     // Only Owner functionality below here
880 
881     /**
882     * @dev Lock all trading of tokens.
883     */
884     function lockTrading() public onlyAdmin {
885         require(tradingLocked == false, "Trading already locked.");
886         tradingLocked = true;
887         emit TradingLock();
888     }
889 
890     /**
891     * @dev Unlock trading. If there were some tokens individually locked, this will not unlock them.
892     */
893     function unlockTrading() public onlyAdmin {
894         require(tradingLocked == true, "Trading already unlocked.");
895         tradingLocked = false;
896         emit TradingUnlock();
897     }
898 
899     // ------------------------------------------------------------------------------------------------------
900     // Only Admin functionality below here
901 
902     /**
903     * @dev Create a token and give to address.
904     */
905     function createToken(string _uuid, string _properties, address _to) public onlyAdmin {
906         require(uuidExists[_uuid] == false, "UUID already exists.");
907         Token memory _token = Token({uuid: _uuid, properties: _properties});
908         uint256 _tokenId = tokens.push(_token) - 1;
909         uuidToTokenId[_uuid] = _tokenId;
910         uuidExists[_uuid] = true;
911         lockedTokens[_tokenId] = true;
912         _mint(_to, _tokenId);
913         emit TokenCreated(_uuid, _to);
914     }
915 
916     /**
917     * Update a token (such as it's treatment or designation or skin)
918     */
919     function updateToken(string _uuid, string _properties) public onlyAdmin {
920         require(uuidExists[_uuid] == true, "UUID does not exist.");
921         uint256 _tokenId = uuidToTokenId[_uuid];
922         Token memory _token = Token({uuid: _uuid, properties: _properties});
923         tokens[_tokenId] = _token;
924     }
925 
926     function destroyToken(uint256 _tokenId) public onlyAdmin {
927         require(exists(_tokenId), "Token does not exist.");
928         require(lockedTokens[_tokenId] == true, "Token must be locked before being destroyed.");
929         Token memory _token = tokens[_tokenId];
930         delete uuidExists[_token.uuid];
931         delete uuidToTokenId[_token.uuid];
932         delete lockedTokens[_tokenId];
933         _burn(ownerOf(_tokenId), _tokenId);
934         emit TokenDestroyed(_token.uuid);
935     }
936 
937     /**
938     * @dev Lock a token to prevent it from being traded.
939     */
940     function lockToken(address _owner, uint256 _tokenId) public onlyAdmin {
941         require(exists(_tokenId), "Token does not exist.");
942         require(lockedTokens[_tokenId] == false, "Token is already locked.");
943         require(ownerOf(_tokenId) == _owner, "The owner has changed since it was suppose to be locked.");
944         lockedTokens[_tokenId] = true;
945         Token memory _token = tokens[_tokenId];
946         emit TokenLock(_token.uuid);
947     }
948 
949     /**
950     * @dev Unlock a token so it can be traded.
951     */
952     function unlockToken(address _owner, uint256 _tokenId) public onlyAdmin {
953         require(exists(_tokenId), "Token does not exist.");
954         require(lockedTokens[_tokenId] == true, "Token is already unlocked.");
955         require(ownerOf(_tokenId) == _owner, "The owner has changed since it was suppose to be locked.");
956         lockedTokens[_tokenId] = false;
957         Token memory _token = tokens[_tokenId];
958         emit TokenUnlock(_token.uuid);
959     }
960 
961     /**
962     * @dev When cards are moved around in the app, this will update their ownership on the block chain.
963     * Tokens must be locked by admin for this.
964     */
965     function setOwner(address _to, uint256 _tokenId) public onlyAdmin {
966         require(exists(_tokenId), "Token does not exist.");
967         require(lockedTokens[_tokenId] == true || tradingLocked == true, "Token must be locked before owner is changed.");
968         address _owner = ownerOf(_tokenId);
969         clearApproval(_owner, _tokenId);
970         removeTokenFrom(_owner, _tokenId);
971         addTokenTo(_to, _tokenId);
972         Token memory _token = tokens[_tokenId];
973         emit TokenOwnerSet(_owner, _to, _token.uuid);
974         emit Transfer(_owner, _to, _tokenId);
975     }
976 
977     // ------------------------------------------------------------------------------------------------------
978     // These are wrapper functions to enable locked tokens, locked trading
979 
980     function transferFrom(address _from, address _to, uint256 _tokenId) public {
981         require(tradingLocked == false && lockedTokens[_tokenId] == false, "Token must be unlocked to be transferred.");
982         super.transferFrom(_from, _to, _tokenId);
983     }
984 
985     function approve(address _to, uint256 _tokenId) public {
986         require(tradingLocked == false && lockedTokens[_tokenId] == false, "Token must be unlocked to be approved.");
987         super.approve(_to, _tokenId);
988     }
989 
990     function setApprovalForAll(address _operator, bool _approved) public {
991         require(tradingLocked == false, "Token must be unlocked to be approved for all.");
992         super.setApprovalForAll(_operator, _approved);
993     }
994 }