1 pragma solidity 0.4.23;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * Utility library of inline functions on addresses
45  */
46 
47 library AddressUtils {
48 
49   /**
50    * Returns whether there is code in the target address
51    * @dev This function will return false if invoked during the constructor of a contract,
52    *  as the code is not actually created until after the constructor finishes.
53    * @param addr address address to check
54    * @return whether there is code in the target address
55    */
56   function isContract(address addr) internal view returns (bool) {
57     uint256 size;
58     assembly { size := extcodesize(addr) }
59     return size > 0;
60   }
61 
62 }
63 
64 /**
65  * @title SafeMath
66  * @dev Math operations with safety checks that throw on error
67  */
68 library SafeMath {
69 
70   /**
71   * @dev Multiplies two numbers, throws on overflow.
72   */
73   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74     if (a == 0) {
75       return 0;
76     }
77     uint256 c = a * b;
78     assert(c / a == b);
79     return c;
80   }
81 
82   /**
83   * @dev Integer division of two numbers, truncating the quotient.
84   */
85   function div(uint256 a, uint256 b) internal pure returns (uint256) {
86     // assert(b > 0); // Solidity automatically throws when dividing by 0
87     uint256 c = a / b;
88     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
89     return c;
90   }
91 
92   /**
93   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
94   */
95   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96     assert(b <= a);
97     return a - b;
98   }
99 
100   /**
101   * @dev Adds two numbers, throws on overflow.
102   */
103   function add(uint256 a, uint256 b) internal pure returns (uint256) {
104     uint256 c = a + b;
105     assert(c >= a);
106     return c;
107   }
108 }
109 
110 /**
111  * @title ERC721 Non-Fungible Token Standard basic interface
112  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
113  */
114 contract ERC721Basic {
115   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
116   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
117   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
118 
119   function balanceOf(address _owner) public view returns (uint256 _balance);
120   function ownerOf(uint256 _tokenId) public view returns (address _owner);
121   function exists(uint256 _tokenId) public view returns (bool _exists);
122 
123   function approve(address _to, uint256 _tokenId) public;
124   function getApproved(uint256 _tokenId) public view returns (address _operator);
125 
126   function setApprovalForAll(address _operator, bool _approved) public;
127   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
128 
129   function transferFrom(address _from, address _to, uint256 _tokenId) public;
130   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
131   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public;
132 }
133 
134 /**
135  * @title ERC721 token receiver interface
136  * @dev Interface for any contract that wants to support safeTransfers
137  *  from ERC721 asset contracts.
138  */
139 contract ERC721Receiver {
140   /**
141    * @dev Magic value to be returned upon successful reception of an NFT
142    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
143    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
144    */
145   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
146 
147   /**
148    * @notice Handle the receipt of an NFT
149    * @dev The ERC721 smart contract calls this function on the recipient
150    *  after a `safetransfer`. This function MAY throw to revert and reject the
151    *  transfer. This function MUST use 50,000 gas or less. Return of other
152    *  than the magic value MUST result in the transaction being reverted.
153    *  Note: the contract address is always the message sender.
154    * @param _from The sending address
155    * @param _tokenId The NFT identifier which is being transfered
156    * @param _data Additional data with no specified format
157    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
158    */
159   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
160 }
161 
162 /**
163  * @title ERC721 Non-Fungible Token Standard basic implementation
164  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
165  */
166 contract ERC721BasicToken is ERC721Basic {
167   using SafeMath for uint256;
168   using AddressUtils for address;
169 
170   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
171   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
172   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
173 
174   // Mapping from token ID to owner
175   mapping (uint256 => address) internal tokenOwner;
176 
177   // Mapping from token ID to approved address
178   mapping (uint256 => address) internal tokenApprovals;
179 
180   // Mapping from owner to number of owned token
181   mapping (address => uint256) internal ownedTokensCount;
182 
183   // Mapping from owner to operator approvals
184   mapping (address => mapping (address => bool)) internal operatorApprovals;
185 
186   /**
187   * @dev Guarantees msg.sender is owner of the given token
188   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
189   */
190   modifier onlyOwnerOf(uint256 _tokenId) {
191     require(ownerOf(_tokenId) == msg.sender);
192     _;
193   }
194 
195   /**
196   * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
197   * @param _tokenId uint256 ID of the token to validate
198   */
199   modifier canTransfer(uint256 _tokenId) {
200     require(isApprovedOrOwner(msg.sender, _tokenId));
201     _;
202   }
203 
204   /**
205   * @dev Gets the balance of the specified address
206   * @param _owner address to query the balance of
207   * @return uint256 representing the amount owned by the passed address
208   */
209   function balanceOf(address _owner) public view returns (uint256) {
210     require(_owner != address(0));
211     return ownedTokensCount[_owner];
212   }
213 
214   /**
215   * @dev Gets the owner of the specified token ID
216   * @param _tokenId uint256 ID of the token to query the owner of
217   * @return owner address currently marked as the owner of the given token ID
218   */
219   function ownerOf(uint256 _tokenId) public view returns (address) {
220     address owner = tokenOwner[_tokenId];
221     require(owner != address(0));
222     return owner;
223   }
224 
225   /**
226   * @dev Returns whether the specified token exists
227   * @param _tokenId uint256 ID of the token to query the existance of
228   * @return whether the token exists
229   */
230   function exists(uint256 _tokenId) public view returns (bool) {
231     address owner = tokenOwner[_tokenId];
232     return owner != address(0);
233   }
234 
235   /**
236   * @dev Approves another address to transfer the given token ID
237   * @dev The zero address indicates there is no approved address.
238   * @dev There can only be one approved address per token at a given time.
239   * @dev Can only be called by the token owner or an approved operator.
240   * @param _to address to be approved for the given token ID
241   * @param _tokenId uint256 ID of the token to be approved
242   */
243   function approve(address _to, uint256 _tokenId) public {
244     address owner = ownerOf(_tokenId);
245     require(_to != owner);
246     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
247 
248     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
249       tokenApprovals[_tokenId] = _to;
250       Approval(owner, _to, _tokenId);
251     }
252   }
253 
254   /**
255    * @dev Gets the approved address for a token ID, or zero if no address set
256    * @param _tokenId uint256 ID of the token to query the approval of
257    * @return address currently approved for a the given token ID
258    */
259   function getApproved(uint256 _tokenId) public view returns (address) {
260     return tokenApprovals[_tokenId];
261   }
262 
263 
264   /**
265   * @dev Sets or unsets the approval of a given operator
266   * @dev An operator is allowed to transfer all tokens of the sender on their behalf
267   * @param _to operator address to set the approval
268   * @param _approved representing the status of the approval to be set
269   */
270   function setApprovalForAll(address _to, bool _approved) public {
271     require(_to != msg.sender);
272     operatorApprovals[msg.sender][_to] = _approved;
273     ApprovalForAll(msg.sender, _to, _approved);
274   }
275 
276   /**
277    * @dev Tells whether an operator is approved by a given owner
278    * @param _owner owner address which you want to query the approval of
279    * @param _operator operator address which you want to query the approval of
280    * @return bool whether the given operator is approved by the given owner
281    */
282   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
283     return operatorApprovals[_owner][_operator];
284   }
285 
286   /**
287   * @dev Transfers the ownership of a given token ID to another address
288   * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
289   * @dev Requires the msg sender to be the owner, approved, or operator
290   * @param _from current owner of the token
291   * @param _to address to receive the ownership of the given token ID
292   * @param _tokenId uint256 ID of the token to be transferred
293   */
294   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
295     require(_from != address(0));
296     require(_to != address(0));
297 
298     clearApproval(_from, _tokenId);
299     removeTokenFrom(_from, _tokenId);
300     addTokenTo(_to, _tokenId);
301 
302     Transfer(_from, _to, _tokenId);
303   }
304 
305   /**
306   * @dev Safely transfers the ownership of a given token ID to another address
307   * @dev If the target address is a contract, it must implement `onERC721Received`,
308   *  which is called upon a safe transfer, and return the magic value
309   *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
310   *  the transfer is reverted.
311   * @dev Requires the msg sender to be the owner, approved, or operator
312   * @param _from current owner of the token
313   * @param _to address to receive the ownership of the given token ID
314   * @param _tokenId uint256 ID of the token to be transferred
315   */
316   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
317     safeTransferFrom(_from, _to, _tokenId, "");
318   }
319 
320   /**
321   * @dev Safely transfers the ownership of a given token ID to another address
322   * @dev If the target address is a contract, it must implement `onERC721Received`,
323   *  which is called upon a safe transfer, and return the magic value
324   *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
325   *  the transfer is reverted.
326   * @dev Requires the msg sender to be the owner, approved, or operator
327   * @param _from current owner of the token
328   * @param _to address to receive the ownership of the given token ID
329   * @param _tokenId uint256 ID of the token to be transferred
330   * @param _data bytes data to send along with a safe transfer check
331   */
332   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public canTransfer(_tokenId) {
333     transferFrom(_from, _to, _tokenId);
334     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
335   }
336 
337   /**
338    * @dev Returns whether the given spender can transfer a given token ID
339    * @param _spender address of the spender to query
340    * @param _tokenId uint256 ID of the token to be transferred
341    * @return bool whether the msg.sender is approved for the given token ID,
342    *  is an operator of the owner, or is the owner of the token
343    */
344   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
345     address owner = ownerOf(_tokenId);
346     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
347   }
348 
349   /**
350   * @dev Internal function to mint a new token
351   * @dev Reverts if the given token ID already exists
352   * @param _to The address that will own the minted token
353   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
354   */
355   function _mint(address _to, uint256 _tokenId) internal {
356     require(_to != address(0));
357     addTokenTo(_to, _tokenId);
358     Transfer(address(0), _to, _tokenId);
359   }
360 
361   /**
362   * @dev Internal function to burn a specific token
363   * @dev Reverts if the token does not exist
364   * @param _tokenId uint256 ID of the token being burned by the msg.sender
365   */
366   function _burn(address _owner, uint256 _tokenId) internal {
367     clearApproval(_owner, _tokenId);
368     removeTokenFrom(_owner, _tokenId);
369     Transfer(_owner, address(0), _tokenId);
370   }
371 
372   /**
373   * @dev Internal function to clear current approval of a given token ID
374   * @dev Reverts if the given address is not indeed the owner of the token
375   * @param _owner owner of the token
376   * @param _tokenId uint256 ID of the token to be transferred
377   */
378   function clearApproval(address _owner, uint256 _tokenId) internal {
379     require(ownerOf(_tokenId) == _owner);
380     if (tokenApprovals[_tokenId] != address(0)) {
381       tokenApprovals[_tokenId] = address(0);
382       Approval(_owner, address(0), _tokenId);
383     }
384   }
385 
386   /**
387   * @dev Internal function to add a token ID to the list of a given address
388   * @param _to address representing the new owner of the given token ID
389   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
390   */
391   function addTokenTo(address _to, uint256 _tokenId) internal {
392     require(tokenOwner[_tokenId] == address(0));
393     tokenOwner[_tokenId] = _to;
394     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
395   }
396 
397   /**
398   * @dev Internal function to remove a token ID from the list of a given address
399   * @param _from address representing the previous owner of the given token ID
400   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
401   */
402   function removeTokenFrom(address _from, uint256 _tokenId) internal {
403     require(ownerOf(_tokenId) == _from);
404     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
405     tokenOwner[_tokenId] = address(0);
406   }
407 
408   /**
409   * @dev Internal function to invoke `onERC721Received` on a target address
410   * @dev The call is not executed if the target address is not a contract
411   * @param _from address representing the previous owner of the given token ID
412   * @param _to target address that will receive the tokens
413   * @param _tokenId uint256 ID of the token to be transferred
414   * @param _data bytes optional data to send along with the call
415   * @return whether the call correctly returned the expected magic value
416   */
417   function checkAndCallSafeTransfer(address _from, address _to, uint256 _tokenId, bytes _data) internal returns (bool) {
418     if (!_to.isContract()) {
419       return true;
420     }
421     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
422     return (retval == ERC721_RECEIVED);
423   }
424 }
425 
426 
427 contract WikiFactory is Ownable, ERC721BasicToken {
428 
429   struct WikiPage {
430       string title;
431       string articleHash; // on roadmap is looking at history of these across blocks and creating a history for owners.
432       string imageHash;
433       uint price; // price in wei
434   }
435 
436   WikiPage[] public wikiPages;
437 
438   // Mapping from owner to list of owned token IDs
439   mapping (address => uint256[]) internal ownedTokens;
440   // Mapping from token ID to index of the owner tokens list
441   mapping(uint256 => uint256) internal ownedTokensIndex;
442 
443   uint costToCreate = 40000000000000000 wei;
444   function setCostToCreate(uint _fee) external onlyOwner {
445     costToCreate = _fee;
446   }
447   /* mapping (uint => address) public wikiToOwner;
448   mapping (address => uint) ownerWikiCount; */
449 
450   function createWikiPage(string _title, string _articleHash, string _imageHash, uint _price) public onlyOwner returns (uint) {
451     uint id = wikiPages.push(WikiPage(_title, _articleHash, _imageHash, _price)) - 1;
452     /* tokenOwner[id] = msg.sender;
453     ownedTokensCount[msg.sender]++; */
454     _ownMint(id);
455   }
456 
457   function paidCreateWikiPage(string _title, string _articleHash, string _imageHash, uint _price) public payable {
458     require(msg.value >= costToCreate);
459     uint id = wikiPages.push(WikiPage(_title, _articleHash, _imageHash, _price)) - 1;
460     /* tokenOwner[id] = msg.sender;
461     ownedTokensCount[msg.sender]++; */
462     _ownMint(id);
463   }
464 
465   function _ownMint(uint _id) internal {
466     uint256 length = ownedTokens[msg.sender].length;
467     ownedTokens[msg.sender].push(_id);
468     ownedTokensIndex[_id] = length;
469     _mint(msg.sender, _id);
470   }
471 
472   /* function createMultipleWikiPages(string[] _titles) public onlyOwner returns (uint) {
473     for (uint i = 0; i < _titles.length; i++) {
474       string storage _title = _titles[i];
475       uint id = wikiPages.push(WikiPage(_title, '', 10)) - 1;
476       tokenOwner[id] = msg.sender;
477       ownedTokensCount[msg.sender]++;
478       emit NewWikiPage(id, _title, '', 10);
479     }
480   } */
481 
482   function numberWikiPages() public view returns(uint) {
483     return wikiPages.length;
484   }
485 
486   /**
487    * @dev Internal function to add a token ID to the list of a given address
488    * @param _to address representing the new owner of the given token ID
489    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
490    */
491   function wikiAddTokenTo(address _to, uint256 _tokenId) internal {
492     addTokenTo(_to, _tokenId);
493     uint256 length = ownedTokens[_to].length;
494     ownedTokens[_to].push(_tokenId);
495     ownedTokensIndex[_tokenId] = length;
496   }
497 
498   /**
499    * @dev Internal function to remove a token ID from the list of a given address
500    * @param _from address representing the previous owner of the given token ID
501    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
502    */
503   function wikiRemoveTokenFrom(address _from, uint256 _tokenId) internal {
504     removeTokenFrom(_from, _tokenId);
505 
506     uint256 tokenIndex = ownedTokensIndex[_tokenId];
507     uint256 lastTokenIndex = ownedTokens[_from].length - 1;
508     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
509 
510     ownedTokens[_from][tokenIndex] = lastToken;
511     ownedTokens[_from][lastTokenIndex] = 0;
512     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
513     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
514     // the lastToken to the first position, and then dropping the element placed in the last position of the list
515 
516     ownedTokens[_from].length--;
517     ownedTokensIndex[_tokenId] = 0;
518     ownedTokensIndex[lastToken] = tokenIndex;
519   }
520 
521   /**
522    * @dev Gets the token ID at a given index of the tokens list of the requested owner
523    * @param _owner address owning the tokens list to be accessed
524    * @param _index uint256 representing the index to be accessed of the requested tokens list
525    * @return uint256 token ID at the given index of the tokens list owned by the requested address
526    */
527   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
528     require(_index < balanceOf(_owner));
529     return ownedTokens[_owner][_index];
530   }
531 }
532 
533 contract ManageWikiPage is WikiFactory {
534 
535 
536   event WikiPageChanged(uint id);
537 
538   mapping(uint => mapping(address => mapping(address => bool))) public collaborators;
539 
540   /**
541    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
542    * @param _tokenId uint256 ID of the token to validate
543    */
544   modifier canEdit(uint256 _tokenId) {
545     require(isCollaboratorOrOwner(msg.sender, _tokenId));
546     _;
547   }
548 
549   function isCollaboratorOrOwner(address _editor, uint256 _tokenId) internal view returns (bool) {
550     address owner = ownerOf(_tokenId);
551     bool isCollaborator = collaborators[_tokenId][owner][_editor];
552 
553     return _editor == owner || isCollaborator;
554   }
555 
556   // Dont think we actually want them to be able to change the article
557   /* function setTitle(uint _wikiId, string _title) public onlyOwnerOf(_wikiId) {
558     WikiPage storage wikiToChange = wikiPages[_wikiId];
559     wikiToChange.title = _title;
560     emit WikiPageChanged(_wikiId, _title, wikiToChange.articleHash, wikiToChange.price);
561   } */
562 
563   function addCollaborator(uint _tokenId, address collaborator) public onlyOwnerOf(_tokenId) {
564     address owner = ownerOf(_tokenId);
565     collaborators[_tokenId][owner][collaborator] = true;
566   }
567 
568   function removeCollaborator(uint _tokenId, address collaborator) public onlyOwnerOf(_tokenId) {
569     address owner = ownerOf(_tokenId);
570     collaborators[_tokenId][owner][collaborator] = false;
571   }
572 
573   function setArticleHash(uint _wikiId, string _articleHash) public canEdit(_wikiId) {
574     WikiPage storage wikiToChange = wikiPages[_wikiId];
575     wikiToChange.articleHash = _articleHash;
576     emit WikiPageChanged(_wikiId);
577   }
578 
579   function setImageHash(uint _wikiId, string _imageHash) public canEdit(_wikiId) {
580     WikiPage storage wikiToChange = wikiPages[_wikiId];
581     wikiToChange.imageHash = _imageHash;
582     emit WikiPageChanged(_wikiId);
583   }
584 
585   function doublePrice(uint _wikiId) internal {
586     WikiPage storage wikiToChange = wikiPages[_wikiId];
587     wikiToChange.price = wikiToChange.price * 2;
588     emit WikiPageChanged(_wikiId);
589   }
590 }
591 
592 contract Wikipediapp is ManageWikiPage {
593   string public name = "WikiToken";
594   string public symbol = "WT";
595 
596   function buyFromCurrentOwner(uint _tokenId) public payable {
597     require(_tokenId < wikiPages.length);
598     require(tokenOwner[_tokenId] != msg.sender);
599 
600     WikiPage storage wikiToChange = wikiPages[_tokenId];
601     require(msg.value >= wikiToChange.price);
602 
603     address previousOwner = tokenOwner[_tokenId];
604     if (previousOwner == address(0)) {
605       previousOwner = owner; // if for some reason the token is ownerless, avoid sending into 0x0
606     }
607 
608     wikiRemoveTokenFrom(previousOwner, _tokenId);
609     wikiAddTokenTo(msg.sender, _tokenId);
610 
611     previousOwner.transfer((wikiToChange.price * 95) / 100);
612 
613     doublePrice(_tokenId);
614   }
615 
616   function getContractBalance() constant returns (uint){
617     return this.balance;
618   }
619 
620   function sendBalance() public onlyOwner {
621     owner.transfer(address(this).balance);
622   }
623 }