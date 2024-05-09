1 pragma solidity ^0.4.13;
2 
3 library AddressUtils {
4 
5   /**
6    * Returns whether the target address is a contract
7    * @dev This function will return false if invoked during the constructor of a contract,
8    *  as the code is not actually created until after the constructor finishes.
9    * @param addr address to check
10    * @return whether the target address is a contract
11    */
12   function isContract(address addr) internal view returns (bool) {
13     uint256 size;
14     // XXX Currently there is no better way to check if there is a contract in an address
15     // than to check the size of the code at that address.
16     // See https://ethereum.stackexchange.com/a/14016/36603
17     // for more details about how this works.
18     // TODO Check this again before the Serenity release, because all addresses will be
19     // contracts then.
20     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
21     return size > 0;
22   }
23 
24 }
25 
26 library SafeMath {
27 
28   /**
29   * @dev Multiplies two numbers, throws on overflow.
30   */
31   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
32     if (a == 0) {
33       return 0;
34     }
35     c = a * b;
36     assert(c / a == b);
37     return c;
38   }
39 
40   /**
41   * @dev Integer division of two numbers, truncating the quotient.
42   */
43   function div(uint256 a, uint256 b) internal pure returns (uint256) {
44     // assert(b > 0); // Solidity automatically throws when dividing by 0
45     // uint256 c = a / b;
46     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47     return a / b;
48   }
49 
50   /**
51   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
52   */
53   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54     assert(b <= a);
55     return a - b;
56   }
57 
58   /**
59   * @dev Adds two numbers, throws on overflow.
60   */
61   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
62     c = a + b;
63     assert(c >= a);
64     return c;
65   }
66 }
67 
68 contract ERC721Basic {
69   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
70   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
71   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
72 
73   function balanceOf(address _owner) public view returns (uint256 _balance);
74   function ownerOf(uint256 _tokenId) public view returns (address _owner);
75   function exists(uint256 _tokenId) public view returns (bool _exists);
76 
77   function approve(address _to, uint256 _tokenId) public;
78   function getApproved(uint256 _tokenId) public view returns (address _operator);
79 
80   function setApprovalForAll(address _operator, bool _approved) public;
81   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
82 
83   function transferFrom(address _from, address _to, uint256 _tokenId) public;
84   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
85   function safeTransferFrom(
86     address _from,
87     address _to,
88     uint256 _tokenId,
89     bytes _data
90   )
91     public;
92 }
93 
94 contract ERC721Enumerable is ERC721Basic {
95   function totalSupply() public view returns (uint256);
96   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
97   function tokenByIndex(uint256 _index) public view returns (uint256);
98 }
99 
100 contract ERC721Metadata is ERC721Basic {
101   function name() public view returns (string _name);
102   function symbol() public view returns (string _symbol);
103   function tokenURI(uint256 _tokenId) public view returns (string);
104 }
105 
106 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
107 }
108 
109 contract ERC721BasicToken is ERC721Basic {
110   using SafeMath for uint256;
111   using AddressUtils for address;
112 
113   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
114   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
115   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
116 
117   // Mapping from token ID to owner
118   mapping (uint256 => address) internal tokenOwner;
119 
120   // Mapping from token ID to approved address
121   mapping (uint256 => address) internal tokenApprovals;
122 
123   // Mapping from owner to number of owned token
124   mapping (address => uint256) internal ownedTokensCount;
125 
126   // Mapping from owner to operator approvals
127   mapping (address => mapping (address => bool)) internal operatorApprovals;
128 
129   /**
130    * @dev Guarantees msg.sender is owner of the given token
131    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
132    */
133   modifier onlyOwnerOf(uint256 _tokenId) {
134     require(ownerOf(_tokenId) == msg.sender);
135     _;
136   }
137 
138   /**
139    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
140    * @param _tokenId uint256 ID of the token to validate
141    */
142   modifier canTransfer(uint256 _tokenId) {
143     require(isApprovedOrOwner(msg.sender, _tokenId));
144     _;
145   }
146 
147   /**
148    * @dev Gets the balance of the specified address
149    * @param _owner address to query the balance of
150    * @return uint256 representing the amount owned by the passed address
151    */
152   function balanceOf(address _owner) public view returns (uint256) {
153     require(_owner != address(0));
154     return ownedTokensCount[_owner];
155   }
156 
157   /**
158    * @dev Gets the owner of the specified token ID
159    * @param _tokenId uint256 ID of the token to query the owner of
160    * @return owner address currently marked as the owner of the given token ID
161    */
162   function ownerOf(uint256 _tokenId) public view returns (address) {
163     address owner = tokenOwner[_tokenId];
164     require(owner != address(0));
165     return owner;
166   }
167 
168   /**
169    * @dev Returns whether the specified token exists
170    * @param _tokenId uint256 ID of the token to query the existance of
171    * @return whether the token exists
172    */
173   function exists(uint256 _tokenId) public view returns (bool) {
174     address owner = tokenOwner[_tokenId];
175     return owner != address(0);
176   }
177 
178   /**
179    * @dev Approves another address to transfer the given token ID
180    * @dev The zero address indicates there is no approved address.
181    * @dev There can only be one approved address per token at a given time.
182    * @dev Can only be called by the token owner or an approved operator.
183    * @param _to address to be approved for the given token ID
184    * @param _tokenId uint256 ID of the token to be approved
185    */
186   function approve(address _to, uint256 _tokenId) public {
187     address owner = ownerOf(_tokenId);
188     require(_to != owner);
189     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
190 
191     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
192       tokenApprovals[_tokenId] = _to;
193       emit Approval(owner, _to, _tokenId);
194     }
195   }
196 
197   /**
198    * @dev Gets the approved address for a token ID, or zero if no address set
199    * @param _tokenId uint256 ID of the token to query the approval of
200    * @return address currently approved for a the given token ID
201    */
202   function getApproved(uint256 _tokenId) public view returns (address) {
203     return tokenApprovals[_tokenId];
204   }
205 
206   /**
207    * @dev Sets or unsets the approval of a given operator
208    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
209    * @param _to operator address to set the approval
210    * @param _approved representing the status of the approval to be set
211    */
212   function setApprovalForAll(address _to, bool _approved) public {
213     require(_to != msg.sender);
214     operatorApprovals[msg.sender][_to] = _approved;
215     emit ApprovalForAll(msg.sender, _to, _approved);
216   }
217 
218   /**
219    * @dev Tells whether an operator is approved by a given owner
220    * @param _owner owner address which you want to query the approval of
221    * @param _operator operator address which you want to query the approval of
222    * @return bool whether the given operator is approved by the given owner
223    */
224   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
225     return operatorApprovals[_owner][_operator];
226   }
227 
228   /**
229    * @dev Transfers the ownership of a given token ID to another address
230    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
231    * @dev Requires the msg sender to be the owner, approved, or operator
232    * @param _from current owner of the token
233    * @param _to address to receive the ownership of the given token ID
234    * @param _tokenId uint256 ID of the token to be transferred
235   */
236   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
237     require(_from != address(0));
238     require(_to != address(0));
239 
240     clearApproval(_from, _tokenId);
241     removeTokenFrom(_from, _tokenId);
242     addTokenTo(_to, _tokenId);
243 
244     emit Transfer(_from, _to, _tokenId);
245   }
246 
247   /**
248    * @dev Safely transfers the ownership of a given token ID to another address
249    * @dev If the target address is a contract, it must implement `onERC721Received`,
250    *  which is called upon a safe transfer, and return the magic value
251    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
252    *  the transfer is reverted.
253    * @dev Requires the msg sender to be the owner, approved, or operator
254    * @param _from current owner of the token
255    * @param _to address to receive the ownership of the given token ID
256    * @param _tokenId uint256 ID of the token to be transferred
257   */
258   function safeTransferFrom(
259     address _from,
260     address _to,
261     uint256 _tokenId
262   )
263     public
264     canTransfer(_tokenId)
265   {
266     // solium-disable-next-line arg-overflow
267     safeTransferFrom(_from, _to, _tokenId, "");
268   }
269 
270   /**
271    * @dev Safely transfers the ownership of a given token ID to another address
272    * @dev If the target address is a contract, it must implement `onERC721Received`,
273    *  which is called upon a safe transfer, and return the magic value
274    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
275    *  the transfer is reverted.
276    * @dev Requires the msg sender to be the owner, approved, or operator
277    * @param _from current owner of the token
278    * @param _to address to receive the ownership of the given token ID
279    * @param _tokenId uint256 ID of the token to be transferred
280    * @param _data bytes data to send along with a safe transfer check
281    */
282   function safeTransferFrom(
283     address _from,
284     address _to,
285     uint256 _tokenId,
286     bytes _data
287   )
288     public
289     canTransfer(_tokenId)
290   {
291     transferFrom(_from, _to, _tokenId);
292     // solium-disable-next-line arg-overflow
293     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
294   }
295 
296   /**
297    * @dev Returns whether the given spender can transfer a given token ID
298    * @param _spender address of the spender to query
299    * @param _tokenId uint256 ID of the token to be transferred
300    * @return bool whether the msg.sender is approved for the given token ID,
301    *  is an operator of the owner, or is the owner of the token
302    */
303   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
304     address owner = ownerOf(_tokenId);
305     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
306   }
307 
308   /**
309    * @dev Internal function to mint a new token
310    * @dev Reverts if the given token ID already exists
311    * @param _to The address that will own the minted token
312    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
313    */
314   function _mint(address _to, uint256 _tokenId) internal {
315     require(_to != address(0));
316     addTokenTo(_to, _tokenId);
317     emit Transfer(address(0), _to, _tokenId);
318   }
319 
320   /**
321    * @dev Internal function to burn a specific token
322    * @dev Reverts if the token does not exist
323    * @param _tokenId uint256 ID of the token being burned by the msg.sender
324    */
325   function _burn(address _owner, uint256 _tokenId) internal {
326     clearApproval(_owner, _tokenId);
327     removeTokenFrom(_owner, _tokenId);
328     emit Transfer(_owner, address(0), _tokenId);
329   }
330 
331   /**
332    * @dev Internal function to clear current approval of a given token ID
333    * @dev Reverts if the given address is not indeed the owner of the token
334    * @param _owner owner of the token
335    * @param _tokenId uint256 ID of the token to be transferred
336    */
337   function clearApproval(address _owner, uint256 _tokenId) internal {
338     require(ownerOf(_tokenId) == _owner);
339     if (tokenApprovals[_tokenId] != address(0)) {
340       tokenApprovals[_tokenId] = address(0);
341       emit Approval(_owner, address(0), _tokenId);
342     }
343   }
344 
345   /**
346    * @dev Internal function to add a token ID to the list of a given address
347    * @param _to address representing the new owner of the given token ID
348    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
349    */
350   function addTokenTo(address _to, uint256 _tokenId) internal {
351     require(tokenOwner[_tokenId] == address(0));
352     tokenOwner[_tokenId] = _to;
353     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
354   }
355 
356   /**
357    * @dev Internal function to remove a token ID from the list of a given address
358    * @param _from address representing the previous owner of the given token ID
359    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
360    */
361   function removeTokenFrom(address _from, uint256 _tokenId) internal {
362     require(ownerOf(_tokenId) == _from);
363     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
364     tokenOwner[_tokenId] = address(0);
365   }
366 
367   /**
368    * @dev Internal function to invoke `onERC721Received` on a target address
369    * @dev The call is not executed if the target address is not a contract
370    * @param _from address representing the previous owner of the given token ID
371    * @param _to target address that will receive the tokens
372    * @param _tokenId uint256 ID of the token to be transferred
373    * @param _data bytes optional data to send along with the call
374    * @return whether the call correctly returned the expected magic value
375    */
376   function checkAndCallSafeTransfer(
377     address _from,
378     address _to,
379     uint256 _tokenId,
380     bytes _data
381   )
382     internal
383     returns (bool)
384   {
385     if (!_to.isContract()) {
386       return true;
387     }
388     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
389     return (retval == ERC721_RECEIVED);
390   }
391 }
392 
393 contract ERC721Receiver {
394   /**
395    * @dev Magic value to be returned upon successful reception of an NFT
396    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
397    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
398    */
399   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
400 
401   /**
402    * @notice Handle the receipt of an NFT
403    * @dev The ERC721 smart contract calls this function on the recipient
404    *  after a `safetransfer`. This function MAY throw to revert and reject the
405    *  transfer. This function MUST use 50,000 gas or less. Return of other
406    *  than the magic value MUST result in the transaction being reverted.
407    *  Note: the contract address is always the message sender.
408    * @param _from The sending address
409    * @param _tokenId The NFT identifier which is being transfered
410    * @param _data Additional data with no specified format
411    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
412    */
413   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
414 }
415 
416 contract ERC721Token is ERC721, ERC721BasicToken {
417   // Token name
418   string internal name_;
419 
420   // Token symbol
421   string internal symbol_;
422 
423   // Mapping from owner to list of owned token IDs
424   mapping (address => uint256[]) internal ownedTokens;
425 
426   // Mapping from token ID to index of the owner tokens list
427   mapping(uint256 => uint256) internal ownedTokensIndex;
428 
429   // Array with all token ids, used for enumeration
430   uint256[] internal allTokens;
431 
432   // Mapping from token id to position in the allTokens array
433   mapping(uint256 => uint256) internal allTokensIndex;
434 
435   // Optional mapping for token URIs
436   mapping(uint256 => string) internal tokenURIs;
437 
438   /**
439    * @dev Constructor function
440    */
441   function ERC721Token(string _name, string _symbol) public {
442     name_ = _name;
443     symbol_ = _symbol;
444   }
445 
446   /**
447    * @dev Gets the token name
448    * @return string representing the token name
449    */
450   function name() public view returns (string) {
451     return name_;
452   }
453 
454   /**
455    * @dev Gets the token symbol
456    * @return string representing the token symbol
457    */
458   function symbol() public view returns (string) {
459     return symbol_;
460   }
461 
462   /**
463    * @dev Returns an URI for a given token ID
464    * @dev Throws if the token ID does not exist. May return an empty string.
465    * @param _tokenId uint256 ID of the token to query
466    */
467   function tokenURI(uint256 _tokenId) public view returns (string) {
468     require(exists(_tokenId));
469     return tokenURIs[_tokenId];
470   }
471 
472   /**
473    * @dev Gets the token ID at a given index of the tokens list of the requested owner
474    * @param _owner address owning the tokens list to be accessed
475    * @param _index uint256 representing the index to be accessed of the requested tokens list
476    * @return uint256 token ID at the given index of the tokens list owned by the requested address
477    */
478   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
479     require(_index < balanceOf(_owner));
480     return ownedTokens[_owner][_index];
481   }
482 
483   /**
484    * @dev Gets the total amount of tokens stored by the contract
485    * @return uint256 representing the total amount of tokens
486    */
487   function totalSupply() public view returns (uint256) {
488     return allTokens.length;
489   }
490 
491   /**
492    * @dev Gets the token ID at a given index of all the tokens in this contract
493    * @dev Reverts if the index is greater or equal to the total number of tokens
494    * @param _index uint256 representing the index to be accessed of the tokens list
495    * @return uint256 token ID at the given index of the tokens list
496    */
497   function tokenByIndex(uint256 _index) public view returns (uint256) {
498     require(_index < totalSupply());
499     return allTokens[_index];
500   }
501 
502   /**
503    * @dev Internal function to set the token URI for a given token
504    * @dev Reverts if the token ID does not exist
505    * @param _tokenId uint256 ID of the token to set its URI
506    * @param _uri string URI to assign
507    */
508   function _setTokenURI(uint256 _tokenId, string _uri) internal {
509     require(exists(_tokenId));
510     tokenURIs[_tokenId] = _uri;
511   }
512 
513   /**
514    * @dev Internal function to add a token ID to the list of a given address
515    * @param _to address representing the new owner of the given token ID
516    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
517    */
518   function addTokenTo(address _to, uint256 _tokenId) internal {
519     super.addTokenTo(_to, _tokenId);
520     uint256 length = ownedTokens[_to].length;
521     ownedTokens[_to].push(_tokenId);
522     ownedTokensIndex[_tokenId] = length;
523   }
524 
525   /**
526    * @dev Internal function to remove a token ID from the list of a given address
527    * @param _from address representing the previous owner of the given token ID
528    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
529    */
530   function removeTokenFrom(address _from, uint256 _tokenId) internal {
531     super.removeTokenFrom(_from, _tokenId);
532 
533     uint256 tokenIndex = ownedTokensIndex[_tokenId];
534     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
535     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
536 
537     ownedTokens[_from][tokenIndex] = lastToken;
538     ownedTokens[_from][lastTokenIndex] = 0;
539     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
540     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
541     // the lastToken to the first position, and then dropping the element placed in the last position of the list
542 
543     ownedTokens[_from].length--;
544     ownedTokensIndex[_tokenId] = 0;
545     ownedTokensIndex[lastToken] = tokenIndex;
546   }
547 
548   /**
549    * @dev Internal function to mint a new token
550    * @dev Reverts if the given token ID already exists
551    * @param _to address the beneficiary that will own the minted token
552    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
553    */
554   function _mint(address _to, uint256 _tokenId) internal {
555     super._mint(_to, _tokenId);
556 
557     allTokensIndex[_tokenId] = allTokens.length;
558     allTokens.push(_tokenId);
559   }
560 
561   /**
562    * @dev Internal function to burn a specific token
563    * @dev Reverts if the token does not exist
564    * @param _owner owner of the token to burn
565    * @param _tokenId uint256 ID of the token being burned by the msg.sender
566    */
567   function _burn(address _owner, uint256 _tokenId) internal {
568     super._burn(_owner, _tokenId);
569 
570     // Clear metadata (if any)
571     if (bytes(tokenURIs[_tokenId]).length != 0) {
572       delete tokenURIs[_tokenId];
573     }
574 
575     // Reorg all tokens array
576     uint256 tokenIndex = allTokensIndex[_tokenId];
577     uint256 lastTokenIndex = allTokens.length.sub(1);
578     uint256 lastToken = allTokens[lastTokenIndex];
579 
580     allTokens[tokenIndex] = lastToken;
581     allTokens[lastTokenIndex] = 0;
582 
583     allTokens.length--;
584     allTokensIndex[_tokenId] = 0;
585     allTokensIndex[lastToken] = tokenIndex;
586   }
587 
588 }
589 
590 contract TokenAccessControl {
591     // This facet controls access to Intent Coin. There are four roles managed here:
592     //
593     //     - The CEO: The CEO can reassign other roles and change the addresses of our dependent smart
594     //         contracts. It is also the only role that can unpause the smart contract. It is initially
595     //         set to the address that created the smart contract in the TokenCore constructor.
596     //
597     //     - The CFO: The CFO can withdraw funds from TokenCore and its auction contracts.
598     //
599     //     - The COO: The COO can release tokens to auction, and mint new tokens.
600     //
601     // It should be noted that these roles are distinct without overlap in their access abilities, the
602     // abilities listed for each role above are exhaustive. In particular, while the CEO can assign any
603     // address to any role, the CEO address itself doesn't have the ability to act in those roles. This
604     // restriction is intentional so that we aren't tempted to use the CEO address frequently out of
605     // convenience. The less we use an address, the less likely it is that we somehow compromise the
606     // account.
607 
608     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
609     event ContractUpgrade(address newContract);
610 
611     // The addresses of the accounts (or contracts) that can execute actions within each roles.
612     address public ceoAddress;
613     address public cfoAddress;
614     address public cooAddress;
615 
616     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
617     bool public paused = false;
618 
619     /// @dev Access modifier for CEO-only functionality
620     modifier onlyCEO() {
621         require(msg.sender == ceoAddress);
622         _;
623     }
624 
625     /// @dev Access modifier for CFO-only functionality
626     modifier onlyCFO() {
627         require(msg.sender == cfoAddress);
628         _;
629     }
630 
631     /// @dev Access modifier for COO-only functionality
632     modifier onlyCOO() {
633         require(msg.sender == cooAddress);
634         _;
635     }
636 
637     modifier onlyCLevel() {
638         require(
639             msg.sender == cooAddress ||
640             msg.sender == ceoAddress ||
641             msg.sender == cfoAddress
642         );
643         _;
644     }
645 
646     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
647     /// @param _newCEO The address of the new CEO
648     function setCEO(address _newCEO) external onlyCEO {
649         require(_newCEO != address(0));
650 
651         ceoAddress = _newCEO;
652     }
653 
654     /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
655     /// @param _newCFO The address of the new CFO
656     function setCFO(address _newCFO) external onlyCEO {
657         require(_newCFO != address(0));
658 
659         cfoAddress = _newCFO;
660     }
661 
662     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
663     /// @param _newCOO The address of the new COO
664     function setCOO(address _newCOO) external onlyCEO {
665         require(_newCOO != address(0));
666 
667         cooAddress = _newCOO;
668     }
669 
670     /*** Pausable functionality adapted from OpenZeppelin ***/
671 
672     /// @dev Modifier to allow actions only when the contract IS NOT paused
673     modifier whenNotPaused() {
674         require(!paused);
675         _;
676     }
677 
678     /// @dev Modifier to allow actions only when the contract IS paused
679     modifier whenPaused {
680         require(paused);
681         _;
682     }
683 
684     /// @dev Called by any "C-level" role to pause the contract. Used only when
685     ///  a bug or exploit is detected and we need to limit damage.
686     function pause() external onlyCLevel whenNotPaused {
687         paused = true;
688     }
689 
690     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
691     ///  one reason we may pause the contract is when CFO or COO accounts are
692     ///  compromised.
693     /// @notice This is public rather than external so it can be called by
694     ///  derived contracts.
695     function unpause() public onlyCEO whenPaused {
696         // can't unpause if contract was upgraded
697         paused = false;
698     }
699 }
700 
701 contract IntentToken is ERC721Token, TokenAccessControl {
702 
703     /// @dev Emitted whenever price changes.
704     event PriceChanged(uint price);
705 
706     /// @dev Emitted whenever a new intention is created.
707     event IntentionCreated(address owner, uint256 tokenId);
708 
709     /// @dev Emitted whenever intention is updated.
710     event IntentionUpdated(uint256 tokenId);
711 
712     /// @dev Emitted whenever a intention achievedDate is updated.
713     event IntentionAchieved(uint256 _tokenId, uint64 _achievedDate, uint64 _verifiedDate);
714 
715     /// @dev The main Intention struct. 
716     /// Note: element order matters
717     struct Token {
718         uint64 createdDate;
719         uint64 updatedDate;
720         uint64 achievedDate;
721         uint64 verifiedDate;
722         string uid;
723         string intention;
724     }
725 
726     mapping (uint256 => Token) tokens;
727 
728     // Set in case the core contract is broken and an upgrade is required
729     address public newContractAddress;
730 
731     string _name = "Intent Token";
732     string _symbol = "INTENT";
733     uint256 numTokens;
734     uint price;
735 
736     /// @notice Creates the main IntentCoin smart contract instance.
737     constructor(uint _price) ERC721Token(_name, _symbol) public {
738         price = _price;
739 
740         // Starts paused.
741         paused = false;
742 
743         // the creator of the contract is the initial CEO
744         ceoAddress = msg.sender;
745 
746         // the creator of the contract is also the initial COO
747         cooAddress = msg.sender;
748 
749         // the creator of the contract is also the initial CFO
750         cfoAddress = msg.sender;
751     }
752 
753     function getPrice() public view whenNotPaused returns (uint _price) {
754         return price;
755     }
756 
757     function setPrice(uint _price) external onlyCFO {
758         price = _price;
759         emit PriceChanged(_price);
760     }
761 
762     function createIntention(address _owner) public onlyCOO whenNotPaused {
763         _createIntention(_owner);
764     }
765 
766     function _createIntention(address _owner) private {
767         uint256 _tokenId = numTokens++;
768 
769         tokens[_tokenId] = Token({
770             createdDate: uint64(now),
771             updatedDate: uint64(now),
772             achievedDate: uint64(0),
773             verifiedDate: uint64(0),
774             uid: "",
775             intention: ""
776         });
777 
778         _mint(_owner, _tokenId);
779 
780         emit IntentionCreated(_owner, _tokenId);
781     }
782 
783     function updateIntention(uint256 _tokenId, string _uid, string _uri, string _intention) external onlyCOO whenNotPaused {
784         require (_tokenId >= 0 && _tokenId < numTokens);
785 
786         Token storage _token = tokens[_tokenId];
787 
788         if (bytes(_intention).length != 0) {
789             _token.intention = _intention;
790         }
791 
792         if (bytes(_uid).length != 0) {
793             _token.uid = _uid;
794         }
795 
796         if (bytes(_uri).length != 0) {
797             _setTokenURI(_tokenId, _uri);
798         }
799 
800         emit IntentionUpdated(_tokenId);
801     }
802 
803     function setAchievedDate(uint256 _tokenId, uint64 _achievedDate, uint64 _verifiedDate) external onlyCOO whenNotPaused {
804         require (_tokenId >= 0 && _tokenId < numTokens);
805 
806         Token storage _token = tokens[_tokenId];
807 
808         _token.achievedDate = _achievedDate;
809         _token.verifiedDate = _verifiedDate;
810         _token.updatedDate = uint64(now);
811 
812         emit IntentionAchieved(_tokenId, _achievedDate, _verifiedDate);
813     }
814 
815     function getIntention(uint256 _tokenId) external view whenNotPaused 
816         returns(string _uri, string _uid, string _intention, uint64 _createdDate, uint64 _updatedDate, uint64 achievedDate, uint verifiedDate) {
817         return (
818             tokenURI(_tokenId),
819             tokens[_tokenId].uid,
820             tokens[_tokenId].intention,
821             tokens[_tokenId].createdDate,
822             tokens[_tokenId].updatedDate,
823             tokens[_tokenId].achievedDate,
824             tokens[_tokenId].verifiedDate
825         );
826     }
827 
828     
829     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
830     ///  breaking bug. This method does nothing but keep track of the new contract and
831     ///  emit a message indicating that the new address is set. It's up to clients of this
832     ///  contract to update to the new contract address in that case. (This contract will
833     ///  be paused indefinitely if such an upgrade takes place.)
834     /// @param _versionAddress new address
835     function setNewContractAddress(address _versionAddress) external onlyCEO whenPaused {
836         newContractAddress = _versionAddress;
837         emit ContractUpgrade(_versionAddress);
838     }
839 
840 
841     /// @dev Override unpause so it requires all external contract addresses
842     ///  to be set before contract can be unpaused. Also, we can't have
843     ///  newContractAddress set either, because then the contract was upgraded.
844     /// @notice This is public rather than external so we can call super.unpause
845     ///  without using an expensive CALL.
846     function unpause() public onlyCEO whenPaused {
847         require(newContractAddress == address(0));
848 
849         // Actually unpause the contract.
850         super.unpause();
851     }
852 
853     // @dev Allows the CFO to capture the balance available to the contract.
854     function withdrawBalance() external onlyCFO {
855         uint256 balance = address(this).balance;
856         require (balance > 0);
857         cfoAddress.transfer(balance);
858     }
859 
860 
861     function() external whenNotPaused payable {
862         require (msg.value >= price);
863         _createIntention(msg.sender);
864     }
865 }