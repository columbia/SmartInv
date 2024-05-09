1 pragma solidity ^0.4.24;
2 
3 // File: ..\openzeppelin-solidity\contracts\ownership\Ownable.sol
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
38    * @dev Allows the current owner to transfer control of the contract to a newOwner.
39    * @param newOwner The address to transfer ownership to.
40    */
41   function transferOwnership(address newOwner) public onlyOwner {
42     require(newOwner != address(0));
43     emit OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 
47   /**
48    * @dev Allows the current owner to relinquish control of the contract.
49    */
50   function renounceOwnership() public onlyOwner {
51     emit OwnershipRenounced(owner);
52     owner = address(0);
53   }
54 }
55 
56 // File: ..\openzeppelin-solidity\contracts\token\ERC721\ERC721Basic.sol
57 
58 /**
59  * @title ERC721 Non-Fungible Token Standard basic interface
60  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
61  */
62 contract ERC721Basic {
63   event Transfer(
64     address indexed _from,
65     address indexed _to,
66     uint256 _tokenId
67   );
68   event Approval(
69     address indexed _owner,
70     address indexed _approved,
71     uint256 _tokenId
72   );
73   event ApprovalForAll(
74     address indexed _owner,
75     address indexed _operator,
76     bool _approved
77   );
78 
79   function balanceOf(address _owner) public view returns (uint256 _balance);
80   function ownerOf(uint256 _tokenId) public view returns (address _owner);
81   function exists(uint256 _tokenId) public view returns (bool _exists);
82 
83   function approve(address _to, uint256 _tokenId) public;
84   function getApproved(uint256 _tokenId)
85     public view returns (address _operator);
86 
87   function setApprovalForAll(address _operator, bool _approved) public;
88   function isApprovedForAll(address _owner, address _operator)
89     public view returns (bool);
90 
91   function transferFrom(address _from, address _to, uint256 _tokenId) public;
92   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
93     public;
94 
95   function safeTransferFrom(
96     address _from,
97     address _to,
98     uint256 _tokenId,
99     bytes _data
100   )
101     public;
102 }
103 
104 // File: ..\openzeppelin-solidity\contracts\token\ERC721\ERC721.sol
105 
106 /**
107  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
108  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
109  */
110 contract ERC721Enumerable is ERC721Basic {
111   function totalSupply() public view returns (uint256);
112   function tokenOfOwnerByIndex(
113     address _owner,
114     uint256 _index
115   )
116     public
117     view
118     returns (uint256 _tokenId);
119 
120   function tokenByIndex(uint256 _index) public view returns (uint256);
121 }
122 
123 
124 /**
125  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
126  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
127  */
128 contract ERC721Metadata is ERC721Basic {
129   function name() public view returns (string _name);
130   function symbol() public view returns (string _symbol);
131   function tokenURI(uint256 _tokenId) public view returns (string);
132 }
133 
134 
135 /**
136  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
137  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
138  */
139 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
140 }
141 
142 // File: ..\openzeppelin-solidity\contracts\AddressUtils.sol
143 
144 /**
145  * Utility library of inline functions on addresses
146  */
147 library AddressUtils {
148 
149   /**
150    * Returns whether the target address is a contract
151    * @dev This function will return false if invoked during the constructor of a contract,
152    *  as the code is not actually created until after the constructor finishes.
153    * @param addr address to check
154    * @return whether the target address is a contract
155    */
156   function isContract(address addr) internal view returns (bool) {
157     uint256 size;
158     // XXX Currently there is no better way to check if there is a contract in an address
159     // than to check the size of the code at that address.
160     // See https://ethereum.stackexchange.com/a/14016/36603
161     // for more details about how this works.
162     // TODO Check this again before the Serenity release, because all addresses will be
163     // contracts then.
164     // solium-disable-next-line security/no-inline-assembly
165     assembly { size := extcodesize(addr) }
166     return size > 0;
167   }
168 
169 }
170 
171 // File: ..\openzeppelin-solidity\contracts\math\SafeMath.sol
172 
173 /**
174  * @title SafeMath
175  * @dev Math operations with safety checks that throw on error
176  */
177 library SafeMath {
178 
179   /**
180   * @dev Multiplies two numbers, throws on overflow.
181   */
182   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
183     if (a == 0) {
184       return 0;
185     }
186     c = a * b;
187     assert(c / a == b);
188     return c;
189   }
190 
191   /**
192   * @dev Integer division of two numbers, truncating the quotient.
193   */
194   function div(uint256 a, uint256 b) internal pure returns (uint256) {
195     // assert(b > 0); // Solidity automatically throws when dividing by 0
196     // uint256 c = a / b;
197     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
198     return a / b;
199   }
200 
201   /**
202   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
203   */
204   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
205     assert(b <= a);
206     return a - b;
207   }
208 
209   /**
210   * @dev Adds two numbers, throws on overflow.
211   */
212   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
213     c = a + b;
214     assert(c >= a);
215     return c;
216   }
217 }
218 
219 // File: ..\openzeppelin-solidity\contracts\token\ERC721\ERC721Receiver.sol
220 
221 /**
222  * @title ERC721 token receiver interface
223  * @dev Interface for any contract that wants to support safeTransfers
224  *  from ERC721 asset contracts.
225  */
226 contract ERC721Receiver {
227   /**
228    * @dev Magic value to be returned upon successful reception of an NFT
229    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
230    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
231    */
232   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
233 
234   /**
235    * @notice Handle the receipt of an NFT
236    * @dev The ERC721 smart contract calls this function on the recipient
237    *  after a `safetransfer`. This function MAY throw to revert and reject the
238    *  transfer. This function MUST use 50,000 gas or less. Return of other
239    *  than the magic value MUST result in the transaction being reverted.
240    *  Note: the contract address is always the message sender.
241    * @param _from The sending address
242    * @param _tokenId The NFT identifier which is being transfered
243    * @param _data Additional data with no specified format
244    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
245    */
246   function onERC721Received(
247     address _from,
248     uint256 _tokenId,
249     bytes _data
250   )
251     public
252     returns(bytes4);
253 }
254 
255 // File: ..\openzeppelin-solidity\contracts\token\ERC721\ERC721BasicToken.sol
256 
257 /**
258  * @title ERC721 Non-Fungible Token Standard basic implementation
259  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
260  */
261 contract ERC721BasicToken is ERC721Basic {
262   using SafeMath for uint256;
263   using AddressUtils for address;
264 
265   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
266   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
267   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
268 
269   // Mapping from token ID to owner
270   mapping (uint256 => address) internal tokenOwner;
271 
272   // Mapping from token ID to approved address
273   mapping (uint256 => address) internal tokenApprovals;
274 
275   // Mapping from owner to number of owned token
276   mapping (address => uint256) internal ownedTokensCount;
277 
278   // Mapping from owner to operator approvals
279   mapping (address => mapping (address => bool)) internal operatorApprovals;
280 
281   /**
282    * @dev Guarantees msg.sender is owner of the given token
283    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
284    */
285   modifier onlyOwnerOf(uint256 _tokenId) {
286     require(ownerOf(_tokenId) == msg.sender);
287     _;
288   }
289 
290   /**
291    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
292    * @param _tokenId uint256 ID of the token to validate
293    */
294   modifier canTransfer(uint256 _tokenId) {
295     require(isApprovedOrOwner(msg.sender, _tokenId));
296     _;
297   }
298 
299   /**
300    * @dev Gets the balance of the specified address
301    * @param _owner address to query the balance of
302    * @return uint256 representing the amount owned by the passed address
303    */
304   function balanceOf(address _owner) public view returns (uint256) {
305     require(_owner != address(0));
306     return ownedTokensCount[_owner];
307   }
308 
309   /**
310    * @dev Gets the owner of the specified token ID
311    * @param _tokenId uint256 ID of the token to query the owner of
312    * @return owner address currently marked as the owner of the given token ID
313    */
314   function ownerOf(uint256 _tokenId) public view returns (address) {
315     address owner = tokenOwner[_tokenId];
316     require(owner != address(0));
317     return owner;
318   }
319 
320   /**
321    * @dev Returns whether the specified token exists
322    * @param _tokenId uint256 ID of the token to query the existence of
323    * @return whether the token exists
324    */
325   function exists(uint256 _tokenId) public view returns (bool) {
326     address owner = tokenOwner[_tokenId];
327     return owner != address(0);
328   }
329 
330   /**
331    * @dev Approves another address to transfer the given token ID
332    * @dev The zero address indicates there is no approved address.
333    * @dev There can only be one approved address per token at a given time.
334    * @dev Can only be called by the token owner or an approved operator.
335    * @param _to address to be approved for the given token ID
336    * @param _tokenId uint256 ID of the token to be approved
337    */
338   function approve(address _to, uint256 _tokenId) public {
339     address owner = ownerOf(_tokenId);
340     require(_to != owner);
341     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
342 
343     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
344       tokenApprovals[_tokenId] = _to;
345       emit Approval(owner, _to, _tokenId);
346     }
347   }
348 
349   /**
350    * @dev Gets the approved address for a token ID, or zero if no address set
351    * @param _tokenId uint256 ID of the token to query the approval of
352    * @return address currently approved for the given token ID
353    */
354   function getApproved(uint256 _tokenId) public view returns (address) {
355     return tokenApprovals[_tokenId];
356   }
357 
358   /**
359    * @dev Sets or unsets the approval of a given operator
360    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
361    * @param _to operator address to set the approval
362    * @param _approved representing the status of the approval to be set
363    */
364   function setApprovalForAll(address _to, bool _approved) public {
365     require(_to != msg.sender);
366     operatorApprovals[msg.sender][_to] = _approved;
367     emit ApprovalForAll(msg.sender, _to, _approved);
368   }
369 
370   /**
371    * @dev Tells whether an operator is approved by a given owner
372    * @param _owner owner address which you want to query the approval of
373    * @param _operator operator address which you want to query the approval of
374    * @return bool whether the given operator is approved by the given owner
375    */
376   function isApprovedForAll(
377     address _owner,
378     address _operator
379   )
380     public
381     view
382     returns (bool)
383   {
384     return operatorApprovals[_owner][_operator];
385   }
386 
387   /**
388    * @dev Transfers the ownership of a given token ID to another address
389    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
390    * @dev Requires the msg sender to be the owner, approved, or operator
391    * @param _from current owner of the token
392    * @param _to address to receive the ownership of the given token ID
393    * @param _tokenId uint256 ID of the token to be transferred
394   */
395   function transferFrom(
396     address _from,
397     address _to,
398     uint256 _tokenId
399   )
400     public
401     canTransfer(_tokenId)
402   {
403     require(_from != address(0));
404     require(_to != address(0));
405 
406     clearApproval(_from, _tokenId);
407     removeTokenFrom(_from, _tokenId);
408     addTokenTo(_to, _tokenId);
409 
410     emit Transfer(_from, _to, _tokenId);
411   }
412 
413   /**
414    * @dev Safely transfers the ownership of a given token ID to another address
415    * @dev If the target address is a contract, it must implement `onERC721Received`,
416    *  which is called upon a safe transfer, and return the magic value
417    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
418    *  the transfer is reverted.
419    * @dev Requires the msg sender to be the owner, approved, or operator
420    * @param _from current owner of the token
421    * @param _to address to receive the ownership of the given token ID
422    * @param _tokenId uint256 ID of the token to be transferred
423   */
424   function safeTransferFrom(
425     address _from,
426     address _to,
427     uint256 _tokenId
428   )
429     public
430     canTransfer(_tokenId)
431   {
432     // solium-disable-next-line arg-overflow
433     safeTransferFrom(_from, _to, _tokenId, "");
434   }
435 
436   /**
437    * @dev Safely transfers the ownership of a given token ID to another address
438    * @dev If the target address is a contract, it must implement `onERC721Received`,
439    *  which is called upon a safe transfer, and return the magic value
440    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
441    *  the transfer is reverted.
442    * @dev Requires the msg sender to be the owner, approved, or operator
443    * @param _from current owner of the token
444    * @param _to address to receive the ownership of the given token ID
445    * @param _tokenId uint256 ID of the token to be transferred
446    * @param _data bytes data to send along with a safe transfer check
447    */
448   function safeTransferFrom(
449     address _from,
450     address _to,
451     uint256 _tokenId,
452     bytes _data
453   )
454     public
455     canTransfer(_tokenId)
456   {
457     transferFrom(_from, _to, _tokenId);
458     // solium-disable-next-line arg-overflow
459     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
460   }
461 
462   /**
463    * @dev Returns whether the given spender can transfer a given token ID
464    * @param _spender address of the spender to query
465    * @param _tokenId uint256 ID of the token to be transferred
466    * @return bool whether the msg.sender is approved for the given token ID,
467    *  is an operator of the owner, or is the owner of the token
468    */
469   function isApprovedOrOwner(
470     address _spender,
471     uint256 _tokenId
472   )
473     internal
474     view
475     returns (bool)
476   {
477     address owner = ownerOf(_tokenId);
478     // Disable solium check because of
479     // https://github.com/duaraghav8/Solium/issues/175
480     // solium-disable-next-line operator-whitespace
481     return (
482       _spender == owner ||
483       getApproved(_tokenId) == _spender ||
484       isApprovedForAll(owner, _spender)
485     );
486   }
487 
488   /**
489    * @dev Internal function to mint a new token
490    * @dev Reverts if the given token ID already exists
491    * @param _to The address that will own the minted token
492    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
493    */
494   function _mint(address _to, uint256 _tokenId) internal {
495     require(_to != address(0));
496     addTokenTo(_to, _tokenId);
497     emit Transfer(address(0), _to, _tokenId);
498   }
499 
500   /**
501    * @dev Internal function to burn a specific token
502    * @dev Reverts if the token does not exist
503    * @param _tokenId uint256 ID of the token being burned by the msg.sender
504    */
505   function _burn(address _owner, uint256 _tokenId) internal {
506     clearApproval(_owner, _tokenId);
507     removeTokenFrom(_owner, _tokenId);
508     emit Transfer(_owner, address(0), _tokenId);
509   }
510 
511   /**
512    * @dev Internal function to clear current approval of a given token ID
513    * @dev Reverts if the given address is not indeed the owner of the token
514    * @param _owner owner of the token
515    * @param _tokenId uint256 ID of the token to be transferred
516    */
517   function clearApproval(address _owner, uint256 _tokenId) internal {
518     require(ownerOf(_tokenId) == _owner);
519     if (tokenApprovals[_tokenId] != address(0)) {
520       tokenApprovals[_tokenId] = address(0);
521       emit Approval(_owner, address(0), _tokenId);
522     }
523   }
524 
525   /**
526    * @dev Internal function to add a token ID to the list of a given address
527    * @param _to address representing the new owner of the given token ID
528    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
529    */
530   function addTokenTo(address _to, uint256 _tokenId) internal {
531     require(tokenOwner[_tokenId] == address(0));
532     tokenOwner[_tokenId] = _to;
533     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
534   }
535 
536   /**
537    * @dev Internal function to remove a token ID from the list of a given address
538    * @param _from address representing the previous owner of the given token ID
539    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
540    */
541   function removeTokenFrom(address _from, uint256 _tokenId) internal {
542     require(ownerOf(_tokenId) == _from);
543     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
544     tokenOwner[_tokenId] = address(0);
545   }
546 
547   /**
548    * @dev Internal function to invoke `onERC721Received` on a target address
549    * @dev The call is not executed if the target address is not a contract
550    * @param _from address representing the previous owner of the given token ID
551    * @param _to target address that will receive the tokens
552    * @param _tokenId uint256 ID of the token to be transferred
553    * @param _data bytes optional data to send along with the call
554    * @return whether the call correctly returned the expected magic value
555    */
556   function checkAndCallSafeTransfer(
557     address _from,
558     address _to,
559     uint256 _tokenId,
560     bytes _data
561   )
562     internal
563     returns (bool)
564   {
565     if (!_to.isContract()) {
566       return true;
567     }
568     bytes4 retval = ERC721Receiver(_to).onERC721Received(
569       _from, _tokenId, _data);
570     return (retval == ERC721_RECEIVED);
571   }
572 }
573 
574 // File: ..\openzeppelin-solidity\contracts\token\ERC721\ERC721Token.sol
575 
576 /**
577  * @title Full ERC721 Token
578  * This implementation includes all the required and some optional functionality of the ERC721 standard
579  * Moreover, it includes approve all functionality using operator terminology
580  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
581  */
582 contract ERC721Token is ERC721, ERC721BasicToken {
583   // Token name
584   string internal name_;
585 
586   // Token symbol
587   string internal symbol_;
588 
589   // Mapping from owner to list of owned token IDs
590   mapping(address => uint256[]) internal ownedTokens;
591 
592   // Mapping from token ID to index of the owner tokens list
593   mapping(uint256 => uint256) internal ownedTokensIndex;
594 
595   // Array with all token ids, used for enumeration
596   uint256[] internal allTokens;
597 
598   // Mapping from token id to position in the allTokens array
599   mapping(uint256 => uint256) internal allTokensIndex;
600 
601   // Optional mapping for token URIs
602   mapping(uint256 => string) internal tokenURIs;
603 
604   /**
605    * @dev Constructor function
606    */
607   constructor(string _name, string _symbol) public {
608     name_ = _name;
609     symbol_ = _symbol;
610   }
611 
612   /**
613    * @dev Gets the token name
614    * @return string representing the token name
615    */
616   function name() public view returns (string) {
617     return name_;
618   }
619 
620   /**
621    * @dev Gets the token symbol
622    * @return string representing the token symbol
623    */
624   function symbol() public view returns (string) {
625     return symbol_;
626   }
627 
628   /**
629    * @dev Returns an URI for a given token ID
630    * @dev Throws if the token ID does not exist. May return an empty string.
631    * @param _tokenId uint256 ID of the token to query
632    */
633   function tokenURI(uint256 _tokenId) public view returns (string) {
634     require(exists(_tokenId));
635     return tokenURIs[_tokenId];
636   }
637 
638   /**
639    * @dev Gets the token ID at a given index of the tokens list of the requested owner
640    * @param _owner address owning the tokens list to be accessed
641    * @param _index uint256 representing the index to be accessed of the requested tokens list
642    * @return uint256 token ID at the given index of the tokens list owned by the requested address
643    */
644   function tokenOfOwnerByIndex(
645     address _owner,
646     uint256 _index
647   )
648     public
649     view
650     returns (uint256)
651   {
652     require(_index < balanceOf(_owner));
653     return ownedTokens[_owner][_index];
654   }
655 
656   /**
657    * @dev Gets the total amount of tokens stored by the contract
658    * @return uint256 representing the total amount of tokens
659    */
660   function totalSupply() public view returns (uint256) {
661     return allTokens.length;
662   }
663 
664   /**
665    * @dev Gets the token ID at a given index of all the tokens in this contract
666    * @dev Reverts if the index is greater or equal to the total number of tokens
667    * @param _index uint256 representing the index to be accessed of the tokens list
668    * @return uint256 token ID at the given index of the tokens list
669    */
670   function tokenByIndex(uint256 _index) public view returns (uint256) {
671     require(_index < totalSupply());
672     return allTokens[_index];
673   }
674 
675   /**
676    * @dev Internal function to set the token URI for a given token
677    * @dev Reverts if the token ID does not exist
678    * @param _tokenId uint256 ID of the token to set its URI
679    * @param _uri string URI to assign
680    */
681   function _setTokenURI(uint256 _tokenId, string _uri) internal {
682     require(exists(_tokenId));
683     tokenURIs[_tokenId] = _uri;
684   }
685 
686   /**
687    * @dev Internal function to add a token ID to the list of a given address
688    * @param _to address representing the new owner of the given token ID
689    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
690    */
691   function addTokenTo(address _to, uint256 _tokenId) internal {
692     super.addTokenTo(_to, _tokenId);
693     uint256 length = ownedTokens[_to].length;
694     ownedTokens[_to].push(_tokenId);
695     ownedTokensIndex[_tokenId] = length;
696   }
697 
698   /**
699    * @dev Internal function to remove a token ID from the list of a given address
700    * @param _from address representing the previous owner of the given token ID
701    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
702    */
703   function removeTokenFrom(address _from, uint256 _tokenId) internal {
704     super.removeTokenFrom(_from, _tokenId);
705 
706     uint256 tokenIndex = ownedTokensIndex[_tokenId];
707     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
708     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
709 
710     ownedTokens[_from][tokenIndex] = lastToken;
711     ownedTokens[_from][lastTokenIndex] = 0;
712     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
713     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
714     // the lastToken to the first position, and then dropping the element placed in the last position of the list
715 
716     ownedTokens[_from].length--;
717     ownedTokensIndex[_tokenId] = 0;
718     ownedTokensIndex[lastToken] = tokenIndex;
719   }
720 
721   /**
722    * @dev Internal function to mint a new token
723    * @dev Reverts if the given token ID already exists
724    * @param _to address the beneficiary that will own the minted token
725    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
726    */
727   function _mint(address _to, uint256 _tokenId) internal {
728     super._mint(_to, _tokenId);
729 
730     allTokensIndex[_tokenId] = allTokens.length;
731     allTokens.push(_tokenId);
732   }
733 
734   /**
735    * @dev Internal function to burn a specific token
736    * @dev Reverts if the token does not exist
737    * @param _owner owner of the token to burn
738    * @param _tokenId uint256 ID of the token being burned by the msg.sender
739    */
740   function _burn(address _owner, uint256 _tokenId) internal {
741     super._burn(_owner, _tokenId);
742 
743     // Clear metadata (if any)
744     if (bytes(tokenURIs[_tokenId]).length != 0) {
745       delete tokenURIs[_tokenId];
746     }
747 
748     // Reorg all tokens array
749     uint256 tokenIndex = allTokensIndex[_tokenId];
750     uint256 lastTokenIndex = allTokens.length.sub(1);
751     uint256 lastToken = allTokens[lastTokenIndex];
752 
753     allTokens[tokenIndex] = lastToken;
754     allTokens[lastTokenIndex] = 0;
755 
756     allTokens.length--;
757     allTokensIndex[_tokenId] = 0;
758     allTokensIndex[lastToken] = tokenIndex;
759   }
760 
761 }
762 
763 // File: contracts\RoyalStables.sol
764 
765 /**
766     @title RoyalStables Holding HRSY token
767 */
768 contract RoyalStables is Ownable,ERC721Token {
769     /**
770         @dev Structure to hold Horsey collectible information
771         @dev should be as small as possible but since its already greater than 256
772         @dev lets keep it <= 512
773     */
774     struct Horsey {
775         address race;       /// @dev Stores the original race address this horsey was claimed from
776         bytes32 dna;        /// @dev Stores the horsey dna
777         uint8 feedingCounter;   /// @dev Boils down to how many times has this horsey been fed
778         uint8 tier;         /// @dev Used internaly to assess chances of a rare trait developing while feeding
779     }
780 
781     /// @dev Maps all token ids to a unique Horsey
782     mapping(uint256 => Horsey) public horseys;
783 
784     /// @dev Maps addresses to the amount of carrots they own
785     mapping(address => uint32) public carrot_credits;
786 
787     /// @dev Maps a horsey token id to the horsey name
788     mapping(uint256 => string) public names;
789 
790     /// @dev Master is the current Horsey contract using this library
791     address public master;
792 
793     /**
794         @dev Contracts constructor
795     */
796     constructor() public
797     Ownable()
798     ERC721Token("HORSEY","HRSY") {
799     }
800 
801     /**
802         @dev Allows to change the address of the current Horsey contract
803         @param newMaster Address of the current Horsey contract
804     */
805     function changeMaster(address newMaster) public
806     validAddress(newMaster)
807     onlyOwner() {
808         master = newMaster;
809     }
810 
811     /**
812         @dev Gets the complete list of token ids which belongs to an address
813         @param eth_address The address you want to lookup owned tokens from
814         @return List of all owned by eth_address tokenIds
815     */
816     function getOwnedTokens(address eth_address) public view returns (uint256[]) {
817         return ownedTokens[eth_address];
818     }
819 
820     /**
821         @dev Stores a horsey name
822         @param tokenId Horsey token id
823         @param newName New horsey name
824     */
825     function storeName(uint256 tokenId, string newName) public
826     onlyMaster() {
827         require(exists(tokenId),"token not found");
828         names[tokenId] = newName;
829     }
830 
831     /**
832         @dev Stores carrot credits on the clients account
833         @param client Client we need to update the balance of
834         @param amount Amount of carrots to store
835     */
836     function storeCarrotsCredit(address client, uint32 amount) public
837     onlyMaster()
838     validAddress(client) {
839         carrot_credits[client] = amount;
840     }
841 
842     function storeHorsey(address client, uint256 tokenId, address race, bytes32 dna, uint8 feedingCounter, uint8 tier) public
843     onlyMaster()
844     validAddress(client) {
845         //_mint checks if the token exists before minting already, so we dont have to here
846         _mint(client,tokenId);
847         modifyHorsey(tokenId,race,dna,feedingCounter,tier);
848     }
849 
850     function modifyHorsey(uint256 tokenId, address race, bytes32 dna, uint8 feedingCounter, uint8 tier) public
851     onlyMaster() {
852         require(exists(tokenId),"token not found");
853         Horsey storage hrsy = horseys[tokenId];
854         hrsy.race = race;
855         hrsy.dna = dna;
856         hrsy.feedingCounter = feedingCounter;
857         hrsy.tier = tier;
858     }
859 
860     function modifyHorseyDna(uint256 tokenId, bytes32 dna) public
861     onlyMaster() {
862         require(exists(tokenId),"token not found");
863         horseys[tokenId].dna = dna;
864     }
865 
866     function modifyHorseyFeedingCounter(uint256 tokenId, uint8 feedingCounter) public
867     onlyMaster() {
868         require(exists(tokenId),"token not found");
869         horseys[tokenId].feedingCounter = feedingCounter;
870     }
871 
872     function modifyHorseyTier(uint256 tokenId, uint8 tier) public
873     onlyMaster() {
874         require(exists(tokenId),"token not found");
875         horseys[tokenId].tier = tier;
876     }
877 
878     function unstoreHorsey(uint256 tokenId) public
879     onlyMaster()
880     {
881         require(exists(tokenId),"token not found");
882         _burn(ownerOf(tokenId),tokenId);
883         delete horseys[tokenId];
884         delete names[tokenId];
885     }
886 
887     /// @dev requires the address to be non null
888     modifier validAddress(address addr) {
889         require(addr != address(0),"Address must be non zero");
890         _;
891     }
892 
893      /// @dev requires the caller to be the master
894     modifier onlyMaster() {
895         require(master == msg.sender,"Address must be non zero");
896         _;
897     }
898 }