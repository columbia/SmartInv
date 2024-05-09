1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC721 Non-Fungible Token Standard basic interface
6  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
7  */
8 contract ERC721Basic {
9   event Transfer(
10     address indexed _from,
11     address indexed _to,
12     uint256 _tokenId
13   );
14   event Approval(
15     address indexed _owner,
16     address indexed _approved,
17     uint256 _tokenId
18   );
19   event ApprovalForAll(
20     address indexed _owner,
21     address indexed _operator,
22     bool _approved
23   );
24 
25   function balanceOf(address _owner) public view returns (uint256 _balance);
26   function ownerOf(uint256 _tokenId) public view returns (address _owner);
27   function exists(uint256 _tokenId) public view returns (bool _exists);
28 
29   function approve(address _to, uint256 _tokenId) public;
30   function getApproved(uint256 _tokenId)
31     public view returns (address _operator);
32 
33   function setApprovalForAll(address _operator, bool _approved) public;
34   function isApprovedForAll(address _owner, address _operator)
35     public view returns (bool);
36 
37   function transferFrom(address _from, address _to, uint256 _tokenId) public;
38   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
39     public;
40 
41   function safeTransferFrom(
42     address _from,
43     address _to,
44     uint256 _tokenId,
45     bytes _data
46   )
47     public;
48 }
49 
50 
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58   address public owner;
59 
60 
61   event OwnershipRenounced(address indexed previousOwner);
62   event OwnershipTransferred(
63     address indexed previousOwner,
64     address indexed newOwner
65   );
66 
67 
68   /**
69    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
70    * account.
71    */
72   constructor() public {
73     owner = msg.sender;
74   }
75 
76   /**
77    * @dev Throws if called by any account other than the owner.
78    */
79   modifier onlyOwner() {
80     require(msg.sender == owner);
81     _;
82   }
83 
84   /**
85    * @dev Allows the current owner to relinquish control of the contract.
86    */
87   function renounceOwnership() public onlyOwner {
88     emit OwnershipRenounced(owner);
89     owner = address(0);
90   }
91 
92   /**
93    * @dev Allows the current owner to transfer control of the contract to a newOwner.
94    * @param _newOwner The address to transfer ownership to.
95    */
96   function transferOwnership(address _newOwner) public onlyOwner {
97     _transferOwnership(_newOwner);
98   }
99 
100   /**
101    * @dev Transfers control of the contract to a newOwner.
102    * @param _newOwner The address to transfer ownership to.
103    */
104   function _transferOwnership(address _newOwner) internal {
105     require(_newOwner != address(0));
106     emit OwnershipTransferred(owner, _newOwner);
107     owner = _newOwner;
108   }
109 }
110 
111 
112 
113 
114 
115 
116 
117 
118 
119 
120 
121 
122 /**
123  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
124  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
125  */
126 contract ERC721Enumerable is ERC721Basic {
127   function totalSupply() public view returns (uint256);
128   function tokenOfOwnerByIndex(
129     address _owner,
130     uint256 _index
131   )
132     public
133     view
134     returns (uint256 _tokenId);
135 
136   function tokenByIndex(uint256 _index) public view returns (uint256);
137 }
138 
139 
140 /**
141  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
142  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
143  */
144 contract ERC721Metadata is ERC721Basic {
145   function name() public view returns (string _name);
146   function symbol() public view returns (string _symbol);
147   function tokenURI(uint256 _tokenId) public view returns (string);
148 }
149 
150 
151 /**
152  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
153  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
154  */
155 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
156 }
157 
158 
159 
160 
161 
162 
163 
164 /**
165  * @title ERC721 token receiver interface
166  * @dev Interface for any contract that wants to support safeTransfers
167  *  from ERC721 asset contracts.
168  */
169 contract ERC721Receiver {
170   /**
171    * @dev Magic value to be returned upon successful reception of an NFT
172    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
173    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
174    */
175   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
176 
177   /**
178    * @notice Handle the receipt of an NFT
179    * @dev The ERC721 smart contract calls this function on the recipient
180    *  after a `safetransfer`. This function MAY throw to revert and reject the
181    *  transfer. This function MUST use 50,000 gas or less. Return of other
182    *  than the magic value MUST result in the transaction being reverted.
183    *  Note: the contract address is always the message sender.
184    * @param _from The sending address
185    * @param _tokenId The NFT identifier which is being transfered
186    * @param _data Additional data with no specified format
187    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
188    */
189   function onERC721Received(
190     address _from,
191     uint256 _tokenId,
192     bytes _data
193   )
194     public
195     returns(bytes4);
196 }
197 
198 
199 
200 
201 /**
202  * @title SafeMath
203  * @dev Math operations with safety checks that throw on error
204  */
205 library SafeMath {
206 
207   /**
208   * @dev Multiplies two numbers, throws on overflow.
209   */
210   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
211     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
212     // benefit is lost if 'b' is also tested.
213     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
214     if (a == 0) {
215       return 0;
216     }
217 
218     c = a * b;
219     assert(c / a == b);
220     return c;
221   }
222 
223   /**
224   * @dev Integer division of two numbers, truncating the quotient.
225   */
226   function div(uint256 a, uint256 b) internal pure returns (uint256) {
227     // assert(b > 0); // Solidity automatically throws when dividing by 0
228     // uint256 c = a / b;
229     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
230     return a / b;
231   }
232 
233   /**
234   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
235   */
236   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
237     assert(b <= a);
238     return a - b;
239   }
240 
241   /**
242   * @dev Adds two numbers, throws on overflow.
243   */
244   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
245     c = a + b;
246     assert(c >= a);
247     return c;
248   }
249 }
250 
251 
252 
253 
254 /**
255  * Utility library of inline functions on addresses
256  */
257 library AddressUtils {
258 
259   /**
260    * Returns whether the target address is a contract
261    * @dev This function will return false if invoked during the constructor of a contract,
262    *  as the code is not actually created until after the constructor finishes.
263    * @param addr address to check
264    * @return whether the target address is a contract
265    */
266   function isContract(address addr) internal view returns (bool) {
267     uint256 size;
268     // XXX Currently there is no better way to check if there is a contract in an address
269     // than to check the size of the code at that address.
270     // See https://ethereum.stackexchange.com/a/14016/36603
271     // for more details about how this works.
272     // TODO Check this again before the Serenity release, because all addresses will be
273     // contracts then.
274     // solium-disable-next-line security/no-inline-assembly
275     assembly { size := extcodesize(addr) }
276     return size > 0;
277   }
278 
279 }
280 
281 
282 
283 /**
284  * @title ERC721 Non-Fungible Token Standard basic implementation
285  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
286  */
287 contract ERC721BasicToken is ERC721Basic {
288   using SafeMath for uint256;
289   using AddressUtils for address;
290 
291   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
292   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
293   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
294 
295   // Mapping from token ID to owner
296   mapping (uint256 => address) internal tokenOwner;
297 
298   // Mapping from token ID to approved address
299   mapping (uint256 => address) internal tokenApprovals;
300 
301   // Mapping from owner to number of owned token
302   mapping (address => uint256) internal ownedTokensCount;
303 
304   // Mapping from owner to operator approvals
305   mapping (address => mapping (address => bool)) internal operatorApprovals;
306 
307   /**
308    * @dev Guarantees msg.sender is owner of the given token
309    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
310    */
311   modifier onlyOwnerOf(uint256 _tokenId) {
312     require(ownerOf(_tokenId) == msg.sender);
313     _;
314   }
315 
316   /**
317    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
318    * @param _tokenId uint256 ID of the token to validate
319    */
320   modifier canTransfer(uint256 _tokenId) {
321     require(isApprovedOrOwner(msg.sender, _tokenId));
322     _;
323   }
324 
325   /**
326    * @dev Gets the balance of the specified address
327    * @param _owner address to query the balance of
328    * @return uint256 representing the amount owned by the passed address
329    */
330   function balanceOf(address _owner) public view returns (uint256) {
331     require(_owner != address(0));
332     return ownedTokensCount[_owner];
333   }
334 
335   /**
336    * @dev Gets the owner of the specified token ID
337    * @param _tokenId uint256 ID of the token to query the owner of
338    * @return owner address currently marked as the owner of the given token ID
339    */
340   function ownerOf(uint256 _tokenId) public view returns (address) {
341     address owner = tokenOwner[_tokenId];
342     require(owner != address(0));
343     return owner;
344   }
345 
346   /**
347    * @dev Returns whether the specified token exists
348    * @param _tokenId uint256 ID of the token to query the existence of
349    * @return whether the token exists
350    */
351   function exists(uint256 _tokenId) public view returns (bool) {
352     address owner = tokenOwner[_tokenId];
353     return owner != address(0);
354   }
355 
356   /**
357    * @dev Approves another address to transfer the given token ID
358    * @dev The zero address indicates there is no approved address.
359    * @dev There can only be one approved address per token at a given time.
360    * @dev Can only be called by the token owner or an approved operator.
361    * @param _to address to be approved for the given token ID
362    * @param _tokenId uint256 ID of the token to be approved
363    */
364   function approve(address _to, uint256 _tokenId) public {
365     address owner = ownerOf(_tokenId);
366     require(_to != owner);
367     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
368 
369     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
370       tokenApprovals[_tokenId] = _to;
371       emit Approval(owner, _to, _tokenId);
372     }
373   }
374 
375   /**
376    * @dev Gets the approved address for a token ID, or zero if no address set
377    * @param _tokenId uint256 ID of the token to query the approval of
378    * @return address currently approved for the given token ID
379    */
380   function getApproved(uint256 _tokenId) public view returns (address) {
381     return tokenApprovals[_tokenId];
382   }
383 
384   /**
385    * @dev Sets or unsets the approval of a given operator
386    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
387    * @param _to operator address to set the approval
388    * @param _approved representing the status of the approval to be set
389    */
390   function setApprovalForAll(address _to, bool _approved) public {
391     require(_to != msg.sender);
392     operatorApprovals[msg.sender][_to] = _approved;
393     emit ApprovalForAll(msg.sender, _to, _approved);
394   }
395 
396   /**
397    * @dev Tells whether an operator is approved by a given owner
398    * @param _owner owner address which you want to query the approval of
399    * @param _operator operator address which you want to query the approval of
400    * @return bool whether the given operator is approved by the given owner
401    */
402   function isApprovedForAll(
403     address _owner,
404     address _operator
405   )
406     public
407     view
408     returns (bool)
409   {
410     return operatorApprovals[_owner][_operator];
411   }
412 
413   /**
414    * @dev Transfers the ownership of a given token ID to another address
415    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
416    * @dev Requires the msg sender to be the owner, approved, or operator
417    * @param _from current owner of the token
418    * @param _to address to receive the ownership of the given token ID
419    * @param _tokenId uint256 ID of the token to be transferred
420   */
421   function transferFrom(
422     address _from,
423     address _to,
424     uint256 _tokenId
425   )
426     public
427     canTransfer(_tokenId)
428   {
429     require(_from != address(0));
430     require(_to != address(0));
431 
432     clearApproval(_from, _tokenId);
433     removeTokenFrom(_from, _tokenId);
434     addTokenTo(_to, _tokenId);
435 
436     emit Transfer(_from, _to, _tokenId);
437   }
438 
439   /**
440    * @dev Safely transfers the ownership of a given token ID to another address
441    * @dev If the target address is a contract, it must implement `onERC721Received`,
442    *  which is called upon a safe transfer, and return the magic value
443    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
444    *  the transfer is reverted.
445    * @dev Requires the msg sender to be the owner, approved, or operator
446    * @param _from current owner of the token
447    * @param _to address to receive the ownership of the given token ID
448    * @param _tokenId uint256 ID of the token to be transferred
449   */
450   function safeTransferFrom(
451     address _from,
452     address _to,
453     uint256 _tokenId
454   )
455     public
456     canTransfer(_tokenId)
457   {
458     // solium-disable-next-line arg-overflow
459     safeTransferFrom(_from, _to, _tokenId, "");
460   }
461 
462   /**
463    * @dev Safely transfers the ownership of a given token ID to another address
464    * @dev If the target address is a contract, it must implement `onERC721Received`,
465    *  which is called upon a safe transfer, and return the magic value
466    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
467    *  the transfer is reverted.
468    * @dev Requires the msg sender to be the owner, approved, or operator
469    * @param _from current owner of the token
470    * @param _to address to receive the ownership of the given token ID
471    * @param _tokenId uint256 ID of the token to be transferred
472    * @param _data bytes data to send along with a safe transfer check
473    */
474   function safeTransferFrom(
475     address _from,
476     address _to,
477     uint256 _tokenId,
478     bytes _data
479   )
480     public
481     canTransfer(_tokenId)
482   {
483     transferFrom(_from, _to, _tokenId);
484     // solium-disable-next-line arg-overflow
485     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
486   }
487 
488   /**
489    * @dev Returns whether the given spender can transfer a given token ID
490    * @param _spender address of the spender to query
491    * @param _tokenId uint256 ID of the token to be transferred
492    * @return bool whether the msg.sender is approved for the given token ID,
493    *  is an operator of the owner, or is the owner of the token
494    */
495   function isApprovedOrOwner(
496     address _spender,
497     uint256 _tokenId
498   )
499     internal
500     view
501     returns (bool)
502   {
503     address owner = ownerOf(_tokenId);
504     // Disable solium check because of
505     // https://github.com/duaraghav8/Solium/issues/175
506     // solium-disable-next-line operator-whitespace
507     return (
508       _spender == owner ||
509       getApproved(_tokenId) == _spender ||
510       isApprovedForAll(owner, _spender)
511     );
512   }
513 
514   /**
515    * @dev Internal function to mint a new token
516    * @dev Reverts if the given token ID already exists
517    * @param _to The address that will own the minted token
518    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
519    */
520   function _mint(address _to, uint256 _tokenId) internal {
521     require(_to != address(0));
522     addTokenTo(_to, _tokenId);
523     emit Transfer(address(0), _to, _tokenId);
524   }
525 
526   /**
527    * @dev Internal function to burn a specific token
528    * @dev Reverts if the token does not exist
529    * @param _tokenId uint256 ID of the token being burned by the msg.sender
530    */
531   function _burn(address _owner, uint256 _tokenId) internal {
532     clearApproval(_owner, _tokenId);
533     removeTokenFrom(_owner, _tokenId);
534     emit Transfer(_owner, address(0), _tokenId);
535   }
536 
537   /**
538    * @dev Internal function to clear current approval of a given token ID
539    * @dev Reverts if the given address is not indeed the owner of the token
540    * @param _owner owner of the token
541    * @param _tokenId uint256 ID of the token to be transferred
542    */
543   function clearApproval(address _owner, uint256 _tokenId) internal {
544     require(ownerOf(_tokenId) == _owner);
545     if (tokenApprovals[_tokenId] != address(0)) {
546       tokenApprovals[_tokenId] = address(0);
547       emit Approval(_owner, address(0), _tokenId);
548     }
549   }
550 
551   /**
552    * @dev Internal function to add a token ID to the list of a given address
553    * @param _to address representing the new owner of the given token ID
554    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
555    */
556   function addTokenTo(address _to, uint256 _tokenId) internal {
557     require(tokenOwner[_tokenId] == address(0));
558     tokenOwner[_tokenId] = _to;
559     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
560   }
561 
562   /**
563    * @dev Internal function to remove a token ID from the list of a given address
564    * @param _from address representing the previous owner of the given token ID
565    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
566    */
567   function removeTokenFrom(address _from, uint256 _tokenId) internal {
568     require(ownerOf(_tokenId) == _from);
569     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
570     tokenOwner[_tokenId] = address(0);
571   }
572 
573   /**
574    * @dev Internal function to invoke `onERC721Received` on a target address
575    * @dev The call is not executed if the target address is not a contract
576    * @param _from address representing the previous owner of the given token ID
577    * @param _to target address that will receive the tokens
578    * @param _tokenId uint256 ID of the token to be transferred
579    * @param _data bytes optional data to send along with the call
580    * @return whether the call correctly returned the expected magic value
581    */
582   function checkAndCallSafeTransfer(
583     address _from,
584     address _to,
585     uint256 _tokenId,
586     bytes _data
587   )
588     internal
589     returns (bool)
590   {
591     if (!_to.isContract()) {
592       return true;
593     }
594     bytes4 retval = ERC721Receiver(_to).onERC721Received(
595       _from, _tokenId, _data);
596     return (retval == ERC721_RECEIVED);
597   }
598 }
599 
600 
601 
602 /**
603  * @title Full ERC721 Token
604  * This implementation includes all the required and some optional functionality of the ERC721 standard
605  * Moreover, it includes approve all functionality using operator terminology
606  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
607  */
608 contract ERC721Token is ERC721, ERC721BasicToken {
609   // Token name
610   string internal name_;
611 
612   // Token symbol
613   string internal symbol_;
614 
615   // Mapping from owner to list of owned token IDs
616   mapping(address => uint256[]) internal ownedTokens;
617 
618   // Mapping from token ID to index of the owner tokens list
619   mapping(uint256 => uint256) internal ownedTokensIndex;
620 
621   // Array with all token ids, used for enumeration
622   uint256[] internal allTokens;
623 
624   // Mapping from token id to position in the allTokens array
625   mapping(uint256 => uint256) internal allTokensIndex;
626 
627   // Optional mapping for token URIs
628   mapping(uint256 => string) internal tokenURIs;
629 
630   /**
631    * @dev Constructor function
632    */
633   constructor(string _name, string _symbol) public {
634     name_ = _name;
635     symbol_ = _symbol;
636   }
637 
638   /**
639    * @dev Gets the token name
640    * @return string representing the token name
641    */
642   function name() public view returns (string) {
643     return name_;
644   }
645 
646   /**
647    * @dev Gets the token symbol
648    * @return string representing the token symbol
649    */
650   function symbol() public view returns (string) {
651     return symbol_;
652   }
653 
654   /**
655    * @dev Returns an URI for a given token ID
656    * @dev Throws if the token ID does not exist. May return an empty string.
657    * @param _tokenId uint256 ID of the token to query
658    */
659   function tokenURI(uint256 _tokenId) public view returns (string) {
660     require(exists(_tokenId));
661     return tokenURIs[_tokenId];
662   }
663 
664   /**
665    * @dev Gets the token ID at a given index of the tokens list of the requested owner
666    * @param _owner address owning the tokens list to be accessed
667    * @param _index uint256 representing the index to be accessed of the requested tokens list
668    * @return uint256 token ID at the given index of the tokens list owned by the requested address
669    */
670   function tokenOfOwnerByIndex(
671     address _owner,
672     uint256 _index
673   )
674     public
675     view
676     returns (uint256)
677   {
678     require(_index < balanceOf(_owner));
679     return ownedTokens[_owner][_index];
680   }
681 
682   /**
683    * @dev Gets the total amount of tokens stored by the contract
684    * @return uint256 representing the total amount of tokens
685    */
686   function totalSupply() public view returns (uint256) {
687     return allTokens.length;
688   }
689 
690   /**
691    * @dev Gets the token ID at a given index of all the tokens in this contract
692    * @dev Reverts if the index is greater or equal to the total number of tokens
693    * @param _index uint256 representing the index to be accessed of the tokens list
694    * @return uint256 token ID at the given index of the tokens list
695    */
696   function tokenByIndex(uint256 _index) public view returns (uint256) {
697     require(_index < totalSupply());
698     return allTokens[_index];
699   }
700 
701   /**
702    * @dev Internal function to set the token URI for a given token
703    * @dev Reverts if the token ID does not exist
704    * @param _tokenId uint256 ID of the token to set its URI
705    * @param _uri string URI to assign
706    */
707   function _setTokenURI(uint256 _tokenId, string _uri) internal {
708     require(exists(_tokenId));
709     tokenURIs[_tokenId] = _uri;
710   }
711 
712   /**
713    * @dev Internal function to add a token ID to the list of a given address
714    * @param _to address representing the new owner of the given token ID
715    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
716    */
717   function addTokenTo(address _to, uint256 _tokenId) internal {
718     super.addTokenTo(_to, _tokenId);
719     uint256 length = ownedTokens[_to].length;
720     ownedTokens[_to].push(_tokenId);
721     ownedTokensIndex[_tokenId] = length;
722   }
723 
724   /**
725    * @dev Internal function to remove a token ID from the list of a given address
726    * @param _from address representing the previous owner of the given token ID
727    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
728    */
729   function removeTokenFrom(address _from, uint256 _tokenId) internal {
730     super.removeTokenFrom(_from, _tokenId);
731 
732     uint256 tokenIndex = ownedTokensIndex[_tokenId];
733     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
734     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
735 
736     ownedTokens[_from][tokenIndex] = lastToken;
737     ownedTokens[_from][lastTokenIndex] = 0;
738     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
739     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
740     // the lastToken to the first position, and then dropping the element placed in the last position of the list
741 
742     ownedTokens[_from].length--;
743     ownedTokensIndex[_tokenId] = 0;
744     ownedTokensIndex[lastToken] = tokenIndex;
745   }
746 
747   /**
748    * @dev Internal function to mint a new token
749    * @dev Reverts if the given token ID already exists
750    * @param _to address the beneficiary that will own the minted token
751    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
752    */
753   function _mint(address _to, uint256 _tokenId) internal {
754     super._mint(_to, _tokenId);
755 
756     allTokensIndex[_tokenId] = allTokens.length;
757     allTokens.push(_tokenId);
758   }
759 
760   /**
761    * @dev Internal function to burn a specific token
762    * @dev Reverts if the token does not exist
763    * @param _owner owner of the token to burn
764    * @param _tokenId uint256 ID of the token being burned by the msg.sender
765    */
766   function _burn(address _owner, uint256 _tokenId) internal {
767     super._burn(_owner, _tokenId);
768 
769     // Clear metadata (if any)
770     if (bytes(tokenURIs[_tokenId]).length != 0) {
771       delete tokenURIs[_tokenId];
772     }
773 
774     // Reorg all tokens array
775     uint256 tokenIndex = allTokensIndex[_tokenId];
776     uint256 lastTokenIndex = allTokens.length.sub(1);
777     uint256 lastToken = allTokens[lastTokenIndex];
778 
779     allTokens[tokenIndex] = lastToken;
780     allTokens[lastTokenIndex] = 0;
781 
782     allTokens.length--;
783     allTokensIndex[_tokenId] = 0;
784     allTokensIndex[lastToken] = tokenIndex;
785   }
786 
787 }
788 
789 
790 
791 
792 
793 
794 
795 /// @title The contract that manages all the players that appear in our game.
796 /// @author The CryptoStrikers Team
797 contract StrikersPlayerList is Ownable {
798   // We only use playerIds in StrikersChecklist.sol (to
799   // indicate which player features on instances of a
800   // given ChecklistItem), and nowhere else in the app.
801   // While it's not explictly necessary for any of our
802   // contracts to know that playerId 0 corresponds to
803   // Lionel Messi, we think that it's nice to have
804   // a canonical source of truth for who the playerIds
805   // actually refer to. Storing strings (player names)
806   // is expensive, so we just use Events to prove that,
807   // at some point, we said a playerId represents a given person.
808 
809   /// @dev The event we fire when we add a player.
810   event PlayerAdded(uint8 indexed id, string name);
811 
812   /// @dev How many players we've added so far
813   ///   (max 255, though we don't plan on getting close)
814   uint8 public playerCount;
815 
816   /// @dev Here we add the players we are launching with on Day 1.
817   ///   Players are loosely ranked by things like FIFA ratings,
818   ///   number of Instagram followers, and opinions of CryptoStrikers
819   ///   team members. Feel free to yell at us on Twitter.
820   constructor() public {
821     addPlayer("Lionel Messi"); // 0
822     addPlayer("Cristiano Ronaldo"); // 1
823     addPlayer("Neymar"); // 2
824     addPlayer("Mohamed Salah"); // 3
825     addPlayer("Robert Lewandowski"); // 4
826     addPlayer("Kevin De Bruyne"); // 5
827     addPlayer("Luka Modrić"); // 6
828     addPlayer("Eden Hazard"); // 7
829     addPlayer("Sergio Ramos"); // 8
830     addPlayer("Toni Kroos"); // 9
831     addPlayer("Luis Suárez"); // 10
832     addPlayer("Harry Kane"); // 11
833     addPlayer("Sergio Agüero"); // 12
834     addPlayer("Kylian Mbappé"); // 13
835     addPlayer("Gonzalo Higuaín"); // 14
836     addPlayer("David de Gea"); // 15
837     addPlayer("Antoine Griezmann"); // 16
838     addPlayer("N'Golo Kanté"); // 17
839     addPlayer("Edinson Cavani"); // 18
840     addPlayer("Paul Pogba"); // 19
841     addPlayer("Isco"); // 20
842     addPlayer("Marcelo"); // 21
843     addPlayer("Manuel Neuer"); // 22
844     addPlayer("Dries Mertens"); // 23
845     addPlayer("James Rodríguez"); // 24
846     addPlayer("Paulo Dybala"); // 25
847     addPlayer("Christian Eriksen"); // 26
848     addPlayer("David Silva"); // 27
849     addPlayer("Gabriel Jesus"); // 28
850     addPlayer("Thiago"); // 29
851     addPlayer("Thibaut Courtois"); // 30
852     addPlayer("Philippe Coutinho"); // 31
853     addPlayer("Andrés Iniesta"); // 32
854     addPlayer("Casemiro"); // 33
855     addPlayer("Romelu Lukaku"); // 34
856     addPlayer("Gerard Piqué"); // 35
857     addPlayer("Mats Hummels"); // 36
858     addPlayer("Diego Godín"); // 37
859     addPlayer("Mesut Özil"); // 38
860     addPlayer("Son Heung-min"); // 39
861     addPlayer("Raheem Sterling"); // 40
862     addPlayer("Hugo Lloris"); // 41
863     addPlayer("Radamel Falcao"); // 42
864     addPlayer("Ivan Rakitić"); // 43
865     addPlayer("Leroy Sané"); // 44
866     addPlayer("Roberto Firmino"); // 45
867     addPlayer("Sadio Mané"); // 46
868     addPlayer("Thomas Müller"); // 47
869     addPlayer("Dele Alli"); // 48
870     addPlayer("Keylor Navas"); // 49
871     addPlayer("Thiago Silva"); // 50
872     addPlayer("Raphaël Varane"); // 51
873     addPlayer("Ángel Di María"); // 52
874     addPlayer("Jordi Alba"); // 53
875     addPlayer("Medhi Benatia"); // 54
876     addPlayer("Timo Werner"); // 55
877     addPlayer("Gylfi Sigurðsson"); // 56
878     addPlayer("Nemanja Matić"); // 57
879     addPlayer("Kalidou Koulibaly"); // 58
880     addPlayer("Bernardo Silva"); // 59
881     addPlayer("Vincent Kompany"); // 60
882     addPlayer("João Moutinho"); // 61
883     addPlayer("Toby Alderweireld"); // 62
884     addPlayer("Emil Forsberg"); // 63
885     addPlayer("Mario Mandžukić"); // 64
886     addPlayer("Sergej Milinković-Savić"); // 65
887     addPlayer("Shinji Kagawa"); // 66
888     addPlayer("Granit Xhaka"); // 67
889     addPlayer("Andreas Christensen"); // 68
890     addPlayer("Piotr Zieliński"); // 69
891     addPlayer("Fyodor Smolov"); // 70
892     addPlayer("Xherdan Shaqiri"); // 71
893     addPlayer("Marcus Rashford"); // 72
894     addPlayer("Javier Hernández"); // 73
895     addPlayer("Hirving Lozano"); // 74
896     addPlayer("Hakim Ziyech"); // 75
897     addPlayer("Victor Moses"); // 76
898     addPlayer("Jefferson Farfán"); // 77
899     addPlayer("Mohamed Elneny"); // 78
900     addPlayer("Marcus Berg"); // 79
901     addPlayer("Guillermo Ochoa"); // 80
902     addPlayer("Igor Akinfeev"); // 81
903     addPlayer("Sardar Azmoun"); // 82
904     addPlayer("Christian Cueva"); // 83
905     addPlayer("Wahbi Khazri"); // 84
906     addPlayer("Keisuke Honda"); // 85
907     addPlayer("Tim Cahill"); // 86
908     addPlayer("John Obi Mikel"); // 87
909     addPlayer("Ki Sung-yueng"); // 88
910     addPlayer("Bryan Ruiz"); // 89
911     addPlayer("Maya Yoshida"); // 90
912     addPlayer("Nawaf Al Abed"); // 91
913     addPlayer("Lee Chung-yong"); // 92
914     addPlayer("Gabriel Gómez"); // 93
915     addPlayer("Naïm Sliti"); // 94
916     addPlayer("Reza Ghoochannejhad"); // 95
917     addPlayer("Mile Jedinak"); // 96
918     addPlayer("Mohammad Al-Sahlawi"); // 97
919     addPlayer("Aron Gunnarsson"); // 98
920     addPlayer("Blas Pérez"); // 99
921     addPlayer("Dani Alves"); // 100
922     addPlayer("Zlatan Ibrahimović"); // 101
923   }
924 
925   /// @dev Fires an event, proving that we said a player corresponds to a given ID.
926   /// @param _name The name of the player we are adding.
927   function addPlayer(string _name) public onlyOwner {
928     require(playerCount < 255, "You've already added the maximum amount of players.");
929     emit PlayerAdded(playerCount, _name);
930     playerCount++;
931   }
932 }
933 
934 
935 /// @title The contract that manages checklist items, sets, and rarity tiers.
936 /// @author The CryptoStrikers Team
937 contract StrikersChecklist is StrikersPlayerList {
938   // High level overview of everything going on in this contract:
939   //
940   // ChecklistItem is the parent class to Card and has 3 properties:
941   //  - uint8 checklistId (000 to 255)
942   //  - uint8 playerId (see StrikersPlayerList.sol)
943   //  - RarityTier tier (more info below)
944   //
945   // Two things to note: the checklistId is not explicitly stored
946   // on the checklistItem struct, and it's composed of two parts.
947   // (For the following, assume it is left padded with zeros to reach
948   // three digits, such that checklistId 0 becomes 000)
949   //  - the first digit represents the setId
950   //      * 0 = Originals Set
951   //      * 1 = Iconics Set
952   //      * 2 = Unreleased Set
953   //  - the last two digits represent its index in the appropriate set arary
954   //
955   //  For example, checklist ID 100 would represent fhe first checklist item
956   //  in the iconicChecklistItems array (first digit = 1 = Iconics Set, last two
957   //  digits = 00 = first index of array)
958   //
959   // Because checklistId is represented as a uint8 throughout the app, the highest
960   // value it can take is 255, which means we can't add more than 56 items to our
961   // Unreleased Set's unreleasedChecklistItems array (setId 2). Also, once we've initialized
962   // this contract, it's impossible for us to add more checklist items to the Originals
963   // and Iconics set -- what you see here is what you get.
964   //
965   // Simple enough right?
966 
967   /// @dev We initialize this contract with so much data that we have
968   ///   to stage it in 4 different steps, ~33 checklist items at a time.
969   enum DeployStep {
970     WaitingForStepOne,
971     WaitingForStepTwo,
972     WaitingForStepThree,
973     WaitingForStepFour,
974     DoneInitialDeploy
975   }
976 
977   /// @dev Enum containing all our rarity tiers, just because
978   ///   it's cleaner dealing with these values than with uint8s.
979   enum RarityTier {
980     IconicReferral,
981     IconicInsert,
982     Diamond,
983     Gold,
984     Silver,
985     Bronze
986   }
987 
988   /// @dev A lookup table indicating how limited the cards
989   ///   in each tier are. If this value is 0, it means
990   ///   that cards of this rarity tier are unlimited,
991   ///   which is only the case for the 8 Iconics cards
992   ///   we give away as part of our referral program.
993   uint16[] public tierLimits = [
994     0,    // Iconic - Referral Bonus (uncapped)
995     100,  // Iconic Inserts ("Card of the Day")
996     1000, // Diamond
997     1664, // Gold
998     3328, // Silver
999     4352  // Bronze
1000   ];
1001 
1002   /// @dev ChecklistItem is essentially the parent class to Card.
1003   ///   It represents a given superclass of cards (eg Originals Messi),
1004   ///   and then each Card is an instance of this ChecklistItem, with
1005   ///   its own serial number, mint date, etc.
1006   struct ChecklistItem {
1007     uint8 playerId;
1008     RarityTier tier;
1009   }
1010 
1011   /// @dev The deploy step we're at. Defaults to WaitingForStepOne.
1012   DeployStep public deployStep;
1013 
1014   /// @dev Array containing all the Originals checklist items (000 - 099)
1015   ChecklistItem[] public originalChecklistItems;
1016 
1017   /// @dev Array containing all the Iconics checklist items (100 - 131)
1018   ChecklistItem[] public iconicChecklistItems;
1019 
1020   /// @dev Array containing all the unreleased checklist items (200 - 255 max)
1021   ChecklistItem[] public unreleasedChecklistItems;
1022 
1023   /// @dev Internal function to add a checklist item to the Originals set.
1024   /// @param _playerId The player represented by this checklist item. (see StrikersPlayerList.sol)
1025   /// @param _tier This checklist item's rarity tier. (see Rarity Tier enum and corresponding tierLimits)
1026   function _addOriginalChecklistItem(uint8 _playerId, RarityTier _tier) internal {
1027     originalChecklistItems.push(ChecklistItem({
1028       playerId: _playerId,
1029       tier: _tier
1030     }));
1031   }
1032 
1033   /// @dev Internal function to add a checklist item to the Iconics set.
1034   /// @param _playerId The player represented by this checklist item. (see StrikersPlayerList.sol)
1035   /// @param _tier This checklist item's rarity tier. (see Rarity Tier enum and corresponding tierLimits)
1036   function _addIconicChecklistItem(uint8 _playerId, RarityTier _tier) internal {
1037     iconicChecklistItems.push(ChecklistItem({
1038       playerId: _playerId,
1039       tier: _tier
1040     }));
1041   }
1042 
1043   /// @dev External function to add a checklist item to our mystery set.
1044   ///   Must have completed initial deploy, and can't add more than 56 items (because checklistId is a uint8).
1045   /// @param _playerId The player represented by this checklist item. (see StrikersPlayerList.sol)
1046   /// @param _tier This checklist item's rarity tier. (see Rarity Tier enum and corresponding tierLimits)
1047   function addUnreleasedChecklistItem(uint8 _playerId, RarityTier _tier) external onlyOwner {
1048     require(deployStep == DeployStep.DoneInitialDeploy, "Finish deploying the Originals and Iconics sets first.");
1049     require(unreleasedCount() < 56, "You can't add any more checklist items.");
1050     require(_playerId < playerCount, "This player doesn't exist in our player list.");
1051     unreleasedChecklistItems.push(ChecklistItem({
1052       playerId: _playerId,
1053       tier: _tier
1054     }));
1055   }
1056 
1057   /// @dev Returns how many Original checklist items we've added.
1058   function originalsCount() external view returns (uint256) {
1059     return originalChecklistItems.length;
1060   }
1061 
1062   /// @dev Returns how many Iconic checklist items we've added.
1063   function iconicsCount() public view returns (uint256) {
1064     return iconicChecklistItems.length;
1065   }
1066 
1067   /// @dev Returns how many Unreleased checklist items we've added.
1068   function unreleasedCount() public view returns (uint256) {
1069     return unreleasedChecklistItems.length;
1070   }
1071 
1072   // In the next four functions, we initialize this contract with our
1073   // 132 initial checklist items (100 Originals, 32 Iconics). Because
1074   // of how much data we need to store, it has to be broken up into
1075   // four different function calls, which need to be called in sequence.
1076   // The ordering of the checklist items we add determines their
1077   // checklist ID, which is left-padded in our frontend to be a
1078   // 3-digit identifier where the first digit is the setId and the last
1079   // 2 digits represents the checklist items index in the appropriate ___ChecklistItems array.
1080   // For example, Originals Messi is the first item for set ID 0, and this
1081   // is displayed as #000 throughout the app. Our Card struct declare its
1082   // checklistId property as uint8, so we have
1083   // to be mindful that we can only have 256 total checklist items.
1084 
1085   /// @dev Deploys Originals #000 through #032.
1086   function deployStepOne() external onlyOwner {
1087     require(deployStep == DeployStep.WaitingForStepOne, "You're not following the steps in order...");
1088 
1089     /* ORIGINALS - DIAMOND */
1090     _addOriginalChecklistItem(0, RarityTier.Diamond); // 000 Messi
1091     _addOriginalChecklistItem(1, RarityTier.Diamond); // 001 Ronaldo
1092     _addOriginalChecklistItem(2, RarityTier.Diamond); // 002 Neymar
1093     _addOriginalChecklistItem(3, RarityTier.Diamond); // 003 Salah
1094 
1095     /* ORIGINALS - GOLD */
1096     _addOriginalChecklistItem(4, RarityTier.Gold); // 004 Lewandowski
1097     _addOriginalChecklistItem(5, RarityTier.Gold); // 005 De Bruyne
1098     _addOriginalChecklistItem(6, RarityTier.Gold); // 006 Modrić
1099     _addOriginalChecklistItem(7, RarityTier.Gold); // 007 Hazard
1100     _addOriginalChecklistItem(8, RarityTier.Gold); // 008 Ramos
1101     _addOriginalChecklistItem(9, RarityTier.Gold); // 009 Kroos
1102     _addOriginalChecklistItem(10, RarityTier.Gold); // 010 Suárez
1103     _addOriginalChecklistItem(11, RarityTier.Gold); // 011 Kane
1104     _addOriginalChecklistItem(12, RarityTier.Gold); // 012 Agüero
1105     _addOriginalChecklistItem(13, RarityTier.Gold); // 013 Mbappé
1106     _addOriginalChecklistItem(14, RarityTier.Gold); // 014 Higuaín
1107     _addOriginalChecklistItem(15, RarityTier.Gold); // 015 de Gea
1108     _addOriginalChecklistItem(16, RarityTier.Gold); // 016 Griezmann
1109     _addOriginalChecklistItem(17, RarityTier.Gold); // 017 Kanté
1110     _addOriginalChecklistItem(18, RarityTier.Gold); // 018 Cavani
1111     _addOriginalChecklistItem(19, RarityTier.Gold); // 019 Pogba
1112 
1113     /* ORIGINALS - SILVER (020 to 032) */
1114     _addOriginalChecklistItem(20, RarityTier.Silver); // 020 Isco
1115     _addOriginalChecklistItem(21, RarityTier.Silver); // 021 Marcelo
1116     _addOriginalChecklistItem(22, RarityTier.Silver); // 022 Neuer
1117     _addOriginalChecklistItem(23, RarityTier.Silver); // 023 Mertens
1118     _addOriginalChecklistItem(24, RarityTier.Silver); // 024 James
1119     _addOriginalChecklistItem(25, RarityTier.Silver); // 025 Dybala
1120     _addOriginalChecklistItem(26, RarityTier.Silver); // 026 Eriksen
1121     _addOriginalChecklistItem(27, RarityTier.Silver); // 027 David Silva
1122     _addOriginalChecklistItem(28, RarityTier.Silver); // 028 Gabriel Jesus
1123     _addOriginalChecklistItem(29, RarityTier.Silver); // 029 Thiago
1124     _addOriginalChecklistItem(30, RarityTier.Silver); // 030 Courtois
1125     _addOriginalChecklistItem(31, RarityTier.Silver); // 031 Coutinho
1126     _addOriginalChecklistItem(32, RarityTier.Silver); // 032 Iniesta
1127 
1128     // Move to the next deploy step.
1129     deployStep = DeployStep.WaitingForStepTwo;
1130   }
1131 
1132   /// @dev Deploys Originals #033 through #065.
1133   function deployStepTwo() external onlyOwner {
1134     require(deployStep == DeployStep.WaitingForStepTwo, "You're not following the steps in order...");
1135 
1136     /* ORIGINALS - SILVER (033 to 049) */
1137     _addOriginalChecklistItem(33, RarityTier.Silver); // 033 Casemiro
1138     _addOriginalChecklistItem(34, RarityTier.Silver); // 034 Lukaku
1139     _addOriginalChecklistItem(35, RarityTier.Silver); // 035 Piqué
1140     _addOriginalChecklistItem(36, RarityTier.Silver); // 036 Hummels
1141     _addOriginalChecklistItem(37, RarityTier.Silver); // 037 Godín
1142     _addOriginalChecklistItem(38, RarityTier.Silver); // 038 Özil
1143     _addOriginalChecklistItem(39, RarityTier.Silver); // 039 Son
1144     _addOriginalChecklistItem(40, RarityTier.Silver); // 040 Sterling
1145     _addOriginalChecklistItem(41, RarityTier.Silver); // 041 Lloris
1146     _addOriginalChecklistItem(42, RarityTier.Silver); // 042 Falcao
1147     _addOriginalChecklistItem(43, RarityTier.Silver); // 043 Rakitić
1148     _addOriginalChecklistItem(44, RarityTier.Silver); // 044 Sané
1149     _addOriginalChecklistItem(45, RarityTier.Silver); // 045 Firmino
1150     _addOriginalChecklistItem(46, RarityTier.Silver); // 046 Mané
1151     _addOriginalChecklistItem(47, RarityTier.Silver); // 047 Müller
1152     _addOriginalChecklistItem(48, RarityTier.Silver); // 048 Alli
1153     _addOriginalChecklistItem(49, RarityTier.Silver); // 049 Navas
1154 
1155     /* ORIGINALS - BRONZE (050 to 065) */
1156     _addOriginalChecklistItem(50, RarityTier.Bronze); // 050 Thiago Silva
1157     _addOriginalChecklistItem(51, RarityTier.Bronze); // 051 Varane
1158     _addOriginalChecklistItem(52, RarityTier.Bronze); // 052 Di María
1159     _addOriginalChecklistItem(53, RarityTier.Bronze); // 053 Alba
1160     _addOriginalChecklistItem(54, RarityTier.Bronze); // 054 Benatia
1161     _addOriginalChecklistItem(55, RarityTier.Bronze); // 055 Werner
1162     _addOriginalChecklistItem(56, RarityTier.Bronze); // 056 Sigurðsson
1163     _addOriginalChecklistItem(57, RarityTier.Bronze); // 057 Matić
1164     _addOriginalChecklistItem(58, RarityTier.Bronze); // 058 Koulibaly
1165     _addOriginalChecklistItem(59, RarityTier.Bronze); // 059 Bernardo Silva
1166     _addOriginalChecklistItem(60, RarityTier.Bronze); // 060 Kompany
1167     _addOriginalChecklistItem(61, RarityTier.Bronze); // 061 Moutinho
1168     _addOriginalChecklistItem(62, RarityTier.Bronze); // 062 Alderweireld
1169     _addOriginalChecklistItem(63, RarityTier.Bronze); // 063 Forsberg
1170     _addOriginalChecklistItem(64, RarityTier.Bronze); // 064 Mandžukić
1171     _addOriginalChecklistItem(65, RarityTier.Bronze); // 065 Milinković-Savić
1172 
1173     // Move to the next deploy step.
1174     deployStep = DeployStep.WaitingForStepThree;
1175   }
1176 
1177   /// @dev Deploys Originals #066 through #099.
1178   function deployStepThree() external onlyOwner {
1179     require(deployStep == DeployStep.WaitingForStepThree, "You're not following the steps in order...");
1180 
1181     /* ORIGINALS - BRONZE (066 to 099) */
1182     _addOriginalChecklistItem(66, RarityTier.Bronze); // 066 Kagawa
1183     _addOriginalChecklistItem(67, RarityTier.Bronze); // 067 Xhaka
1184     _addOriginalChecklistItem(68, RarityTier.Bronze); // 068 Christensen
1185     _addOriginalChecklistItem(69, RarityTier.Bronze); // 069 Zieliński
1186     _addOriginalChecklistItem(70, RarityTier.Bronze); // 070 Smolov
1187     _addOriginalChecklistItem(71, RarityTier.Bronze); // 071 Shaqiri
1188     _addOriginalChecklistItem(72, RarityTier.Bronze); // 072 Rashford
1189     _addOriginalChecklistItem(73, RarityTier.Bronze); // 073 Hernández
1190     _addOriginalChecklistItem(74, RarityTier.Bronze); // 074 Lozano
1191     _addOriginalChecklistItem(75, RarityTier.Bronze); // 075 Ziyech
1192     _addOriginalChecklistItem(76, RarityTier.Bronze); // 076 Moses
1193     _addOriginalChecklistItem(77, RarityTier.Bronze); // 077 Farfán
1194     _addOriginalChecklistItem(78, RarityTier.Bronze); // 078 Elneny
1195     _addOriginalChecklistItem(79, RarityTier.Bronze); // 079 Berg
1196     _addOriginalChecklistItem(80, RarityTier.Bronze); // 080 Ochoa
1197     _addOriginalChecklistItem(81, RarityTier.Bronze); // 081 Akinfeev
1198     _addOriginalChecklistItem(82, RarityTier.Bronze); // 082 Azmoun
1199     _addOriginalChecklistItem(83, RarityTier.Bronze); // 083 Cueva
1200     _addOriginalChecklistItem(84, RarityTier.Bronze); // 084 Khazri
1201     _addOriginalChecklistItem(85, RarityTier.Bronze); // 085 Honda
1202     _addOriginalChecklistItem(86, RarityTier.Bronze); // 086 Cahill
1203     _addOriginalChecklistItem(87, RarityTier.Bronze); // 087 Mikel
1204     _addOriginalChecklistItem(88, RarityTier.Bronze); // 088 Sung-yueng
1205     _addOriginalChecklistItem(89, RarityTier.Bronze); // 089 Ruiz
1206     _addOriginalChecklistItem(90, RarityTier.Bronze); // 090 Yoshida
1207     _addOriginalChecklistItem(91, RarityTier.Bronze); // 091 Al Abed
1208     _addOriginalChecklistItem(92, RarityTier.Bronze); // 092 Chung-yong
1209     _addOriginalChecklistItem(93, RarityTier.Bronze); // 093 Gómez
1210     _addOriginalChecklistItem(94, RarityTier.Bronze); // 094 Sliti
1211     _addOriginalChecklistItem(95, RarityTier.Bronze); // 095 Ghoochannejhad
1212     _addOriginalChecklistItem(96, RarityTier.Bronze); // 096 Jedinak
1213     _addOriginalChecklistItem(97, RarityTier.Bronze); // 097 Al-Sahlawi
1214     _addOriginalChecklistItem(98, RarityTier.Bronze); // 098 Gunnarsson
1215     _addOriginalChecklistItem(99, RarityTier.Bronze); // 099 Pérez
1216 
1217     // Move to the next deploy step.
1218     deployStep = DeployStep.WaitingForStepFour;
1219   }
1220 
1221   /// @dev Deploys all Iconics and marks the deploy as complete!
1222   function deployStepFour() external onlyOwner {
1223     require(deployStep == DeployStep.WaitingForStepFour, "You're not following the steps in order...");
1224 
1225     /* ICONICS */
1226     _addIconicChecklistItem(0, RarityTier.IconicInsert); // 100 Messi
1227     _addIconicChecklistItem(1, RarityTier.IconicInsert); // 101 Ronaldo
1228     _addIconicChecklistItem(2, RarityTier.IconicInsert); // 102 Neymar
1229     _addIconicChecklistItem(3, RarityTier.IconicInsert); // 103 Salah
1230     _addIconicChecklistItem(4, RarityTier.IconicInsert); // 104 Lewandowski
1231     _addIconicChecklistItem(5, RarityTier.IconicInsert); // 105 De Bruyne
1232     _addIconicChecklistItem(6, RarityTier.IconicInsert); // 106 Modrić
1233     _addIconicChecklistItem(7, RarityTier.IconicInsert); // 107 Hazard
1234     _addIconicChecklistItem(8, RarityTier.IconicInsert); // 108 Ramos
1235     _addIconicChecklistItem(9, RarityTier.IconicInsert); // 109 Kroos
1236     _addIconicChecklistItem(10, RarityTier.IconicInsert); // 110 Suárez
1237     _addIconicChecklistItem(11, RarityTier.IconicInsert); // 111 Kane
1238     _addIconicChecklistItem(12, RarityTier.IconicInsert); // 112 Agüero
1239     _addIconicChecklistItem(15, RarityTier.IconicInsert); // 113 de Gea
1240     _addIconicChecklistItem(16, RarityTier.IconicInsert); // 114 Griezmann
1241     _addIconicChecklistItem(17, RarityTier.IconicReferral); // 115 Kanté
1242     _addIconicChecklistItem(18, RarityTier.IconicReferral); // 116 Cavani
1243     _addIconicChecklistItem(19, RarityTier.IconicInsert); // 117 Pogba
1244     _addIconicChecklistItem(21, RarityTier.IconicInsert); // 118 Marcelo
1245     _addIconicChecklistItem(24, RarityTier.IconicInsert); // 119 James
1246     _addIconicChecklistItem(26, RarityTier.IconicInsert); // 120 Eriksen
1247     _addIconicChecklistItem(29, RarityTier.IconicReferral); // 121 Thiago
1248     _addIconicChecklistItem(36, RarityTier.IconicReferral); // 122 Hummels
1249     _addIconicChecklistItem(38, RarityTier.IconicReferral); // 123 Özil
1250     _addIconicChecklistItem(39, RarityTier.IconicInsert); // 124 Son
1251     _addIconicChecklistItem(46, RarityTier.IconicInsert); // 125 Mané
1252     _addIconicChecklistItem(48, RarityTier.IconicInsert); // 126 Alli
1253     _addIconicChecklistItem(49, RarityTier.IconicReferral); // 127 Navas
1254     _addIconicChecklistItem(73, RarityTier.IconicInsert); // 128 Hernández
1255     _addIconicChecklistItem(85, RarityTier.IconicInsert); // 129 Honda
1256     _addIconicChecklistItem(100, RarityTier.IconicReferral); // 130 Alves
1257     _addIconicChecklistItem(101, RarityTier.IconicReferral); // 131 Zlatan
1258 
1259     // Mark the initial deploy as complete.
1260     deployStep = DeployStep.DoneInitialDeploy;
1261   }
1262 
1263   /// @dev Returns the mint limit for a given checklist item, based on its tier.
1264   /// @param _checklistId Which checklist item we need to get the limit for.
1265   /// @return How much of this checklist item we are allowed to mint.
1266   function limitForChecklistId(uint8 _checklistId) external view returns (uint16) {
1267     RarityTier rarityTier;
1268     uint8 index;
1269     if (_checklistId < 100) { // Originals = #000 to #099
1270       rarityTier = originalChecklistItems[_checklistId].tier;
1271     } else if (_checklistId < 200) { // Iconics = #100 to #131
1272       index = _checklistId - 100;
1273       require(index < iconicsCount(), "This Iconics checklist item doesn't exist.");
1274       rarityTier = iconicChecklistItems[index].tier;
1275     } else { // Unreleased = #200 to max #255
1276       index = _checklistId - 200;
1277       require(index < unreleasedCount(), "This Unreleased checklist item doesn't exist.");
1278       rarityTier = unreleasedChecklistItems[index].tier;
1279     }
1280     return tierLimits[uint8(rarityTier)];
1281   }
1282 }
1283 
1284 
1285 /// @title Base contract for CryptoStrikers. Defines what a card is and how to mint one.
1286 /// @author The CryptoStrikers Team
1287 contract StrikersBase is ERC721Token("CryptoStrikers", "STRK") {
1288 
1289   /// @dev Emit this event whenever we mint a new card (see _mintCard below)
1290   event CardMinted(uint256 cardId);
1291 
1292   /// @dev The struct representing the game's main object, a sports trading card.
1293   struct Card {
1294     // The timestamp at which this card was minted.
1295     // With uint32 we are good until 2106, by which point we will have not minted
1296     // a card in like, 88 years.
1297     uint32 mintTime;
1298 
1299     // The checklist item represented by this card. See StrikersChecklist.sol for more info.
1300     uint8 checklistId;
1301 
1302     // Cards for a given player have a serial number, which gets
1303     // incremented in sequence. For example, if we mint 1000 of a card,
1304     // the third one to be minted has serialNumber = 3 (out of 1000).
1305     uint16 serialNumber;
1306   }
1307 
1308   /*** STORAGE ***/
1309 
1310   /// @dev All the cards that have been minted, indexed by cardId.
1311   Card[] public cards;
1312 
1313   /// @dev Keeps track of how many cards we have minted for a given checklist item
1314   ///   to make sure we don't go over the limit for it.
1315   ///   NB: uint16 has a capacity of 65,535, but we are not minting more than
1316   ///   4,352 of any given checklist item.
1317   mapping (uint8 => uint16) public mintedCountForChecklistId;
1318 
1319   /// @dev A reference to our checklist contract, which contains all the minting limits.
1320   StrikersChecklist public strikersChecklist;
1321 
1322   /*** FUNCTIONS ***/
1323 
1324   /// @dev For a given owner, returns two arrays. The first contains the IDs of every card owned
1325   ///   by this address. The second returns the corresponding checklist ID for each of these cards.
1326   ///   There are a few places we need this info in the web app and short of being able to return an
1327   ///   actual array of Cards, this is the best solution we could come up with...
1328   function cardAndChecklistIdsForOwner(address _owner) external view returns (uint256[], uint8[]) {
1329     uint256[] memory cardIds = ownedTokens[_owner];
1330     uint256 cardCount = cardIds.length;
1331     uint8[] memory checklistIds = new uint8[](cardCount);
1332 
1333     for (uint256 i = 0; i < cardCount; i++) {
1334       uint256 cardId = cardIds[i];
1335       checklistIds[i] = cards[cardId].checklistId;
1336     }
1337 
1338     return (cardIds, checklistIds);
1339   }
1340 
1341   /// @dev An internal method that creates a new card and stores it.
1342   ///  Emits both a CardMinted and a Transfer event.
1343   /// @param _checklistId The ID of the checklistItem represented by the card (see Checklist.sol)
1344   /// @param _owner The card's first owner!
1345   function _mintCard(
1346     uint8 _checklistId,
1347     address _owner
1348   )
1349     internal
1350     returns (uint256)
1351   {
1352     uint16 mintLimit = strikersChecklist.limitForChecklistId(_checklistId);
1353     require(mintLimit == 0 || mintedCountForChecklistId[_checklistId] < mintLimit, "Can't mint any more of this card!");
1354     uint16 serialNumber = ++mintedCountForChecklistId[_checklistId];
1355     Card memory newCard = Card({
1356       mintTime: uint32(now),
1357       checklistId: _checklistId,
1358       serialNumber: serialNumber
1359     });
1360     uint256 newCardId = cards.push(newCard) - 1;
1361     emit CardMinted(newCardId);
1362     _mint(_owner, newCardId);
1363     return newCardId;
1364   }
1365 }
1366 
1367 
1368 contract StrikersUpdate is Ownable {
1369 
1370   event PickMade(address indexed user, uint8 indexed game, uint256 cardId);
1371   event CardUpgraded(address indexed user, uint8 indexed game, uint256 cardId);
1372 
1373   uint8 constant CHECKLIST_ITEM_COUNT = 132;
1374   uint8 constant GAME_COUNT = 8;
1375 
1376   mapping (uint256 => uint8) public starCountForCard;
1377   mapping (address => uint256[GAME_COUNT]) public picksForUser;
1378 
1379   struct Game {
1380     uint8[] acceptedChecklistIds;
1381     uint32 startTime;
1382     uint8 homeTeam;
1383     uint8 awayTeam;
1384   }
1385 
1386   Game[] public games;
1387 
1388   StrikersBase public strikersBaseContract;
1389 
1390   constructor(address _strikersBaseAddress) public {
1391     strikersBaseContract = StrikersBase(_strikersBaseAddress);
1392 
1393     /*** QUARTER-FINALS ***/
1394 
1395     // 57 - FRIDAY JULY 6 2018 10:00 AM ET (URUGUAY / FRANCE)
1396     Game memory game57;
1397     game57.startTime = 1530885600;
1398     game57.homeTeam = 31;
1399     game57.awayTeam = 10;
1400     games.push(game57);
1401     games[0].acceptedChecklistIds = [10, 13, 16, 17, 18, 19, 37, 41, 51];
1402 
1403     // 58 - FRIDAY JULY 6 2018 02:00 PM ET (BRAZIL / BELGIUM)
1404     Game memory game58;
1405     game58.startTime = 1530900000;
1406     game58.homeTeam = 3;
1407     game58.awayTeam = 2;
1408     games.push(game58);
1409     games[1].acceptedChecklistIds = [2, 5, 7, 21, 23, 28, 30, 31, 33, 34, 45, 50, 60, 62];
1410 
1411     // 60 - SATURDAY JULY 7 2018 10:00 AM ET (SWEDEN / ENGLAND)
1412     Game memory game60;
1413     game60.startTime = 1530972000;
1414     game60.homeTeam = 28;
1415     game60.awayTeam = 9;
1416     games.push(game60);
1417     games[2].acceptedChecklistIds = [11, 40, 48, 63, 72, 79];
1418 
1419     // 59 - SATURDAY JULY 7 2018 02:00 PM ET (RUSSIA / CROATIA)
1420     Game memory game59;
1421     game59.startTime = 1530986400;
1422     game59.homeTeam = 22;
1423     game59.awayTeam = 6;
1424     games.push(game59);
1425     games[3].acceptedChecklistIds = [6, 43, 64, 70, 81];
1426 
1427     /*** SEMI-FINALS ***/
1428 
1429     // 61 - TUESDAY JULY 10 2018 02:00 PM ET (W57 / W58)
1430     Game memory game61;
1431     game61.startTime = 1531245600;
1432     games.push(game61);
1433 
1434     // 62 - WEDNESDAY JULY 11 2018 02:00 PM ET (W59 / W60)
1435     Game memory game62;
1436     game62.startTime = 1531332000;
1437     games.push(game62);
1438 
1439     /*** THIRD PLACE ***/
1440 
1441     // 63 - SATURDAY JULY 14 2018 11:00 AM ET (L61 / L62)
1442     Game memory game63;
1443     game63.startTime = 1531580400;
1444     games.push(game63);
1445 
1446     /*** FINAL ***/
1447 
1448     // 64 - SUNDAY JULY 15 2018 11:00 AM ET (W61 / W62)
1449     Game memory game64;
1450     game64.startTime = 1531666800;
1451     games.push(game64);
1452   }
1453 
1454   function updateGame(uint8 _game, uint8[] _acceptedChecklistIds, uint32 _startTime, uint8 _homeTeam, uint8 _awayTeam) external onlyOwner {
1455     Game storage game = games[_game];
1456     game.acceptedChecklistIds = _acceptedChecklistIds;
1457     game.startTime = _startTime;
1458     game.homeTeam = _homeTeam;
1459     game.awayTeam = _awayTeam;
1460   }
1461 
1462   function getGame(uint8 _game)
1463     external
1464     view
1465     returns (
1466     uint8[] acceptedChecklistIds,
1467     uint32 startTime,
1468     uint8 homeTeam,
1469     uint8 awayTeam
1470   ) {
1471     Game memory game = games[_game];
1472     acceptedChecklistIds = game.acceptedChecklistIds;
1473     startTime = game.startTime;
1474     homeTeam = game.homeTeam;
1475     awayTeam = game.awayTeam;
1476   }
1477 
1478   function makePick(uint8 _game, uint256 _cardId) external {
1479     Game memory game = games[_game];
1480     require(now < game.startTime, "This game has already started.");
1481     require(strikersBaseContract.ownerOf(_cardId) == msg.sender, "You don't own this card.");
1482     uint8 checklistId;
1483     (,checklistId,) = strikersBaseContract.cards(_cardId);
1484     require(_arrayContains(game.acceptedChecklistIds, checklistId), "This card is invalid for this game.");
1485     picksForUser[msg.sender][_game] = _cardId;
1486     emit PickMade(msg.sender, _game, _cardId);
1487   }
1488 
1489   function _arrayContains(uint8[] _array, uint8 _element) internal pure returns (bool) {
1490     for (uint i = 0; i < _array.length; i++) {
1491       if (_array[i] == _element) {
1492         return true;
1493       }
1494     }
1495 
1496     return false;
1497   }
1498 
1499   function updateCards(uint8 _game, uint256[] _cardIds) external onlyOwner {
1500     for (uint256 i = 0; i < _cardIds.length; i++) {
1501       uint256 cardId = _cardIds[i];
1502       address owner = strikersBaseContract.ownerOf(cardId);
1503       if (picksForUser[owner][_game] == cardId) {
1504         starCountForCard[cardId]++;
1505         emit CardUpgraded(owner, _game, cardId);
1506       }
1507     }
1508   }
1509 
1510   function getPicksForUser(address _user) external view returns (uint256[GAME_COUNT]) {
1511     return picksForUser[_user];
1512   }
1513 
1514   function starCountsForOwner(address _owner) external view returns (uint8[]) {
1515     uint256[] memory cardIds;
1516     (cardIds,) = strikersBaseContract.cardAndChecklistIdsForOwner(_owner);
1517     uint256 cardCount = cardIds.length;
1518     uint8[] memory starCounts = new uint8[](cardCount);
1519 
1520     for (uint256 i = 0; i < cardCount; i++) {
1521       uint256 cardId = cardIds[i];
1522       starCounts[i] = starCountForCard[cardId];
1523     }
1524 
1525     return starCounts;
1526   }
1527 
1528   function getMintedCounts() external view returns (uint16[CHECKLIST_ITEM_COUNT]) {
1529     uint16[CHECKLIST_ITEM_COUNT] memory mintedCounts;
1530 
1531     for (uint8 i = 0; i < CHECKLIST_ITEM_COUNT; i++) {
1532       mintedCounts[i] = strikersBaseContract.mintedCountForChecklistId(i);
1533     }
1534 
1535     return mintedCounts;
1536   }
1537 }