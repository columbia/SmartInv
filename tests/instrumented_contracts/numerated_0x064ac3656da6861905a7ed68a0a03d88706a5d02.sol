1 pragma solidity ^0.4.24;
2 
3 
4 library Roles {
5   struct Role {
6     mapping (address => bool) bearer;
7   }
8 
9   /**
10    * @dev give an account access to this role
11    */
12   function add(Role storage role, address account) internal {
13     require(account != address(0));
14     require(!has(role, account));
15 
16     role.bearer[account] = true;
17   }
18 
19   /**
20    * @dev remove an account's access to this role
21    */
22   function remove(Role storage role, address account) internal {
23     require(account != address(0));
24     require(has(role, account));
25 
26     role.bearer[account] = false;
27   }
28 
29   /**
30    * @dev check if an account has this role
31    * @return bool
32    */
33   function has(Role storage role, address account)
34     internal
35     view
36     returns (bool)
37   {
38     require(account != address(0));
39     return role.bearer[account];
40   }
41 }
42 /**
43  * @title ERC721 token receiver interface
44  * @dev Interface for any contract that wants to support safeTransfers
45  * from ERC721 asset contracts.
46  */
47 
48  /**
49   * Utility library of inline functions on addresses
50   */
51  library Address {
52 
53    /**
54     * Returns whether the target address is a contract
55     * @dev This function will return false if invoked during the constructor of a contract,
56     * as the code is not actually created until after the constructor finishes.
57     * @param account address of the account to check
58     * @return whether the target address is a contract
59     */
60    function isContract(address account) internal view returns (bool) {
61      uint256 size;
62      // XXX Currently there is no better way to check if there is a contract in an address
63      // than to check the size of the code at that address.
64      // See https://ethereum.stackexchange.com/a/14016/36603
65      // for more details about how this works.
66      // TODO Check this again before the Serenity release, because all addresses will be
67      // contracts then.
68      // solium-disable-next-line security/no-inline-assembly
69      assembly { size := extcodesize(account) }
70      return size > 0;
71    }
72 
73  }
74 
75  library SafeMath {
76 
77    /**
78    * @dev Multiplies two numbers, reverts on overflow.
79    */
80    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
81      // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
82      // benefit is lost if 'b' is also tested.
83      // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
84      if (a == 0) {
85        return 0;
86      }
87 
88      uint256 c = a * b;
89      require(c / a == b);
90 
91      return c;
92    }
93 
94    /**
95    * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
96    */
97    function div(uint256 a, uint256 b) internal pure returns (uint256) {
98      require(b > 0); // Solidity only automatically asserts when dividing by 0
99      uint256 c = a / b;
100      // assert(a == b * c + a % b); // There is no case in which this doesn't hold
101 
102      return c;
103    }
104 
105    /**
106    * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
107    */
108    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109      require(b <= a);
110      uint256 c = a - b;
111 
112      return c;
113    }
114 
115    /**
116    * @dev Adds two numbers, reverts on overflow.
117    */
118    function add(uint256 a, uint256 b) internal pure returns (uint256) {
119      uint256 c = a + b;
120      require(c >= a);
121 
122      return c;
123    }
124 
125    /**
126    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
127    * reverts when dividing by zero.
128    */
129    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
130      require(b != 0);
131      return a % b;
132    }
133  }
134 
135  interface IERC165 {
136 
137    /**
138     * @notice Query if a contract implements an interface
139     * @param interfaceId The interface identifier, as specified in ERC-165
140     * @dev Interface identification is specified in ERC-165. This function
141     * uses less than 30,000 gas.
142     */
143    function supportsInterface(bytes4 interfaceId)
144      external
145      view
146      returns (bool);
147  }
148 
149 contract IERC721Receiver {
150   /**
151    * @notice Handle the receipt of an NFT
152    * @dev The ERC721 smart contract calls this function on the recipient
153    * after a `safeTransfer`. This function MUST return the function selector,
154    * otherwise the caller will revert the transaction. The selector to be
155    * returned can be obtained as `this.onERC721Received.selector`. This
156    * function MAY throw to revert and reject the transfer.
157    * Note: the ERC721 contract address is always the message sender.
158    * @param operator The address which called `safeTransferFrom` function
159    * @param from The address which previously owned the token
160    * @param tokenId The NFT identifier which is being transferred
161    * @param data Additional data with no specified format
162    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
163    */
164   function onERC721Received(
165     address operator,
166     address from,
167     uint256 tokenId,
168     bytes data
169   )
170     public
171     returns(bytes4);
172 }
173 
174 /**
175  * @title ERC721 Non-Fungible Token Standard basic implementation
176  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
177  */
178 contract ERC721Pumpkin is IERC165 {
179 
180   using SafeMath for uint256;
181   using Address for address;
182 
183   // Token name
184   string private _name;
185 
186   // Token symbol
187   string private _symbol;
188 
189   // Optional mapping for token URIs
190   mapping(uint256 => string) private _tokenURIs;
191 
192   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
193 
194   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
195   /**
196    * 0x01ffc9a7 ===
197    *   bytes4(keccak256('supportsInterface(bytes4)'))
198    */
199 
200   /**
201    * @dev a mapping of interface id to whether or not it's supported
202    */
203   mapping(bytes4 => bool) private _supportedInterfaces;
204 
205 
206   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
207   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
208   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
209 
210   // Mapping from token ID to owner
211   mapping (uint256 => address) private _tokenOwner;
212 
213   // Mapping from token ID to approved address
214   mapping (uint256 => address) private _tokenApprovals;
215 
216   // Mapping from owner to number of owned token
217   mapping (address => uint256) private _ownedTokensCount;
218 
219   // Mapping from owner to operator approvals
220   mapping (address => mapping (address => bool)) private _operatorApprovals;
221 
222   bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
223   /*
224    * 0x80ac58cd ===
225    *   bytes4(keccak256('balanceOf(address)')) ^
226    *   bytes4(keccak256('ownerOf(uint256)')) ^
227    *   bytes4(keccak256('approve(address,uint256)')) ^
228    *   bytes4(keccak256('getApproved(uint256)')) ^
229    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
230    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
231    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
232    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
233    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
234    */
235 
236      // Mapping from owner to list of owned token IDs
237    mapping(address => uint256[]) private _ownedTokens;
238 
239    // Mapping from token ID to index of the owner tokens list
240    mapping(uint256 => uint256) private _ownedTokensIndex;
241 
242    // Array with all token ids, used for enumeration
243    uint256[] private _allTokens;
244 
245    // Mapping from token id to position in the allTokens array
246    mapping(uint256 => uint256) private _allTokensIndex;
247 
248    bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;
249 
250    using Roles for Roles.Role;
251 
252    event MinterAdded(address indexed account);
253    event MinterRemoved(address indexed account);
254 
255    Roles.Role private minters;
256 
257   constructor(string name, string symbol)
258     public
259   {
260     // register the supported interfaces to conform to ERC721 via ERC165
261     _name = name;
262     _symbol = symbol;
263     _registerInterface(_InterfaceId_ERC721);
264     _registerInterface(_InterfaceId_ERC165);
265     _registerInterface(InterfaceId_ERC721Metadata);
266     _registerInterface(_InterfaceId_ERC721Enumerable);
267     _addMinter(msg.sender);
268   }
269 
270   modifier onlyMinter() {
271     require(isMinter(msg.sender));
272     _;
273   }
274 
275   /**
276    * @dev Gets the token ID at a given index of the tokens list of the requested owner
277    * @param owner address owning the tokens list to be accessed
278    * @param index uint256 representing the index to be accessed of the requested tokens list
279    * @return uint256 token ID at the given index of the tokens list owned by the requested address
280    */
281   function tokenOfOwnerByIndex(
282     address owner,
283     uint256 index
284   )
285     public
286     view
287     returns (uint256)
288   {
289     require(index < balanceOf(owner));
290     return _ownedTokens[owner][index];
291   }
292 
293   /**
294    * @dev Gets the total amount of tokens stored by the contract
295    * @return uint256 representing the total amount of tokens
296    */
297   function totalSupply() public view returns (uint256) {
298     return _allTokens.length;
299   }
300 
301   /**
302    * @dev Gets the token ID at a given index of all the tokens in this contract
303    * Reverts if the index is greater or equal to the total number of tokens
304    * @param index uint256 representing the index to be accessed of the tokens list
305    * @return uint256 token ID at the given index of the tokens list
306    */
307   function tokenByIndex(uint256 index) public view returns (uint256) {
308     require(index < totalSupply());
309     return _allTokens[index];
310   }
311 
312 
313   function isMinter(address account) public view returns (bool) {
314     return minters.has(account);
315   }
316 
317   function addMinter(address account) public onlyMinter {
318     _addMinter(account);
319   }
320 
321   function renounceMinter() public {
322     _removeMinter(msg.sender);
323   }
324 
325   function _addMinter(address account) internal {
326     minters.add(account);
327     emit MinterAdded(account);
328   }
329 
330   function _removeMinter(address account) internal {
331     minters.remove(account);
332     emit MinterRemoved(account);
333   }
334 
335   /**
336    * @dev implement supportsInterface(bytes4) using a lookup table
337    */
338   function supportsInterface(bytes4 interfaceId)
339     external
340     view
341     returns (bool)
342   {
343     return _supportedInterfaces[interfaceId];
344   }
345 
346   /**
347    * @dev internal method for registering an interface
348    */
349   function _registerInterface(bytes4 interfaceId)
350     internal
351   {
352     require(interfaceId != 0xffffffff);
353     _supportedInterfaces[interfaceId] = true;
354   }
355 
356   /**
357    * @dev Gets the balance of the specified address
358    * @param owner address to query the balance of
359    * @return uint256 representing the amount owned by the passed address
360    */
361   function balanceOf(address owner) public view returns (uint256) {
362     require(owner != address(0));
363     return _ownedTokensCount[owner];
364   }
365 
366   /**
367    * @dev Gets the owner of the specified token ID
368    * @param tokenId uint256 ID of the token to query the owner of
369    * @return owner address currently marked as the owner of the given token ID
370    */
371   function ownerOf(uint256 tokenId) public view returns (address) {
372     address owner = _tokenOwner[tokenId];
373     require(owner != address(0));
374     return owner;
375   }
376 
377   /**
378    * @dev Approves another address to transfer the given token ID
379    * The zero address indicates there is no approved address.
380    * There can only be one approved address per token at a given time.
381    * Can only be called by the token owner or an approved operator.
382    * @param to address to be approved for the given token ID
383    * @param tokenId uint256 ID of the token to be approved
384    */
385   function approve(address to, uint256 tokenId) public {
386     address owner = ownerOf(tokenId);
387     require(to != owner);
388     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
389 
390     _tokenApprovals[tokenId] = to;
391     emit Approval(owner, to, tokenId);
392   }
393 
394   /**
395    * @dev Gets the approved address for a token ID, or zero if no address set
396    * Reverts if the token ID does not exist.
397    * @param tokenId uint256 ID of the token to query the approval of
398    * @return address currently approved for the given token ID
399    */
400   function getApproved(uint256 tokenId) public view returns (address) {
401     require(_exists(tokenId));
402     return _tokenApprovals[tokenId];
403   }
404 
405   /**
406    * @dev Sets or unsets the approval of a given operator
407    * An operator is allowed to transfer all tokens of the sender on their behalf
408    * @param to operator address to set the approval
409    * @param approved representing the status of the approval to be set
410    */
411   function setApprovalForAll(address to, bool approved) public {
412     require(to != msg.sender);
413     _operatorApprovals[msg.sender][to] = approved;
414     emit ApprovalForAll(msg.sender, to, approved);
415   }
416 
417   /**
418    * @dev Tells whether an operator is approved by a given owner
419    * @param owner owner address which you want to query the approval of
420    * @param operator operator address which you want to query the approval of
421    * @return bool whether the given operator is approved by the given owner
422    */
423   function isApprovedForAll(
424     address owner,
425     address operator
426   )
427     public
428     view
429     returns (bool)
430   {
431     return _operatorApprovals[owner][operator];
432   }
433 
434   /**
435    * @dev Transfers the ownership of a given token ID to another address
436    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
437    * Requires the msg sender to be the owner, approved, or operator
438    * @param from current owner of the token
439    * @param to address to receive the ownership of the given token ID
440    * @param tokenId uint256 ID of the token to be transferred
441   */
442   function transferFrom(
443     address from,
444     address to,
445     uint256 tokenId
446   )
447     public
448   {
449     require(_isApprovedOrOwner(msg.sender, tokenId));
450     require(to != address(0));
451 
452     _clearApproval(from, tokenId);
453     _removeTokenFrom(from, tokenId);
454     _addTokenTo(to, tokenId);
455 
456     emit Transfer(from, to, tokenId);
457   }
458 
459 
460   /**
461    * @dev Safely transfers the ownership of a given token ID to another address
462    * If the target address is a contract, it must implement `onERC721Received`,
463    * which is called upon a safe transfer, and return the magic value
464    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
465    * the transfer is reverted.
466    * Requires the msg sender to be the owner, approved, or operator
467    * @param from current owner of the token
468    * @param to address to receive the ownership of the given token ID
469    * @param tokenId uint256 ID of the token to be transferred
470    * @param _data bytes data to send along with a safe transfer check
471    */
472   function safeTransferFrom(
473     address from,
474     address to,
475     uint256 tokenId,
476     bytes _data
477   )
478     public
479   {
480     transferFrom(from, to, tokenId);
481     // solium-disable-next-line arg-overflow
482     require(_checkOnERC721Received(from, to, tokenId, _data));
483   }
484 
485   /**
486    * @dev Returns whether the specified token exists
487    * @param tokenId uint256 ID of the token to query the existence of
488    * @return whether the token exists
489    */
490   function _exists(uint256 tokenId) internal view returns (bool) {
491     address owner = _tokenOwner[tokenId];
492     return owner != address(0);
493   }
494 
495   /**
496    * @dev Returns whether the given spender can transfer a given token ID
497    * @param spender address of the spender to query
498    * @param tokenId uint256 ID of the token to be transferred
499    * @return bool whether the msg.sender is approved for the given token ID,
500    *  is an operator of the owner, or is the owner of the token
501    */
502   function _isApprovedOrOwner(
503     address spender,
504     uint256 tokenId
505   )
506     internal
507     view
508     returns (bool)
509   {
510     address owner = ownerOf(tokenId);
511     // Disable solium check because of
512     // https://github.com/duaraghav8/Solium/issues/175
513     // solium-disable-next-line operator-whitespace
514     return (
515       spender == owner ||
516       getApproved(tokenId) == spender ||
517       isApprovedForAll(owner, spender)
518     );
519   }
520 
521   /**
522    * @dev Internal function to mint a new token
523    * Reverts if the given token ID already exists
524    * @param to The address that will own the minted token
525    * @param tokenId uint256 ID of the token to be minted by the msg.sender
526    */
527   function _mint(address to, uint256 tokenId) internal {
528     require(to != address(0));
529     _addTokenTo(to, tokenId);
530     emit Transfer(address(0), to, tokenId);
531     _allTokensIndex[tokenId] = _allTokens.length;
532     _allTokens.push(tokenId);
533   }
534 
535   /**
536    * @dev Internal function to add a token ID to the list of a given address
537    * Note that this function is left internal to make ERC721Enumerable possible, but is not
538    * intended to be called by custom derived contracts: in particular, it emits no Transfer event.
539    * @param to address representing the new owner of the given token ID
540    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
541    */
542   function _addTokenTo(address to, uint256 tokenId) internal {
543     require(_tokenOwner[tokenId] == address(0));
544     _tokenOwner[tokenId] = to;
545     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
546     uint256 length = _ownedTokens[to].length;
547     _ownedTokens[to].push(tokenId);
548     _ownedTokensIndex[tokenId] = length;
549   }
550 
551   /**
552    * @dev Internal function to remove a token ID from the list of a given address
553    * Note that this function is left internal to make ERC721Enumerable possible, but is not
554    * intended to be called by custom derived contracts: in particular, it emits no Transfer event,
555    * and doesn't clear approvals.
556    * @param from address representing the previous owner of the given token ID
557    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
558    */
559   function _removeTokenFrom(address from, uint256 tokenId) internal {
560     require(ownerOf(tokenId) == from);
561     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
562     _tokenOwner[tokenId] = address(0);
563     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
564     // then delete the last slot.
565     uint256 tokenIndex = _ownedTokensIndex[tokenId];
566     uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
567     uint256 lastToken = _ownedTokens[from][lastTokenIndex];
568 
569     _ownedTokens[from][tokenIndex] = lastToken;
570     // This also deletes the contents at the last position of the array
571     _ownedTokens[from].length--;
572 
573     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
574     // be zero. Then we can make sure that we will remove tokenId from the ownedTokens list since we are first swapping
575     // the lastToken to the first position, and then dropping the element placed in the last position of the list
576 
577     _ownedTokensIndex[tokenId] = 0;
578     _ownedTokensIndex[lastToken] = tokenIndex;
579   }
580 
581   /**
582    * @dev Internal function to invoke `onERC721Received` on a target address
583    * The call is not executed if the target address is not a contract
584    * @param from address representing the previous owner of the given token ID
585    * @param to target address that will receive the tokens
586    * @param tokenId uint256 ID of the token to be transferred
587    * @param _data bytes optional data to send along with the call
588    * @return whether the call correctly returned the expected magic value
589    */
590   function _checkOnERC721Received(
591     address from,
592     address to,
593     uint256 tokenId,
594     bytes _data
595   )
596     internal
597     returns (bool)
598   {
599     if (!to.isContract()) {
600       return true;
601     }
602     bytes4 retval = IERC721Receiver(to).onERC721Received(
603       msg.sender, from, tokenId, _data);
604     return (retval == _ERC721_RECEIVED);
605   }
606 
607   /**
608    * @dev Private function to clear current approval of a given token ID
609    * Reverts if the given address is not indeed the owner of the token
610    * @param owner owner of the token
611    * @param tokenId uint256 ID of the token to be transferred
612    */
613   function _clearApproval(address owner, uint256 tokenId) private {
614     require(ownerOf(tokenId) == owner);
615     if (_tokenApprovals[tokenId] != address(0)) {
616       _tokenApprovals[tokenId] = address(0);
617     }
618   }
619 
620   /**
621    * @dev Gets the token name
622    * @return string representing the token name
623    */
624   function name() external view returns (string) {
625     return _name;
626   }
627 
628   /**
629    * @dev Gets the token symbol
630    * @return string representing the token symbol
631    */
632   function symbol() external view returns (string) {
633     return _symbol;
634   }
635 
636   /**
637    * @dev Returns an URI for a given token ID
638    * Throws if the token ID does not exist. May return an empty string.
639    * @param tokenId uint256 ID of the token to query
640    */
641   function tokenURI(uint256 tokenId) external view returns (string) {
642     require(_exists(tokenId));
643     return _tokenURIs[tokenId];
644   }
645 
646   /**
647    * @dev Internal function to set the token URI for a given token
648    * Reverts if the token ID does not exist
649    * @param tokenId uint256 ID of the token to set its URI
650    * @param uri string URI to assign
651    */
652   function _setTokenURI(uint256 tokenId, string uri) internal {
653     require(_exists(tokenId));
654     _tokenURIs[tokenId] = uri;
655   }
656 
657   /**
658    * @dev Internal function to burn a specific token
659    * Reverts if the token does not exist
660    * @param owner owner of the token to burn
661    * @param tokenId uint256 ID of the token being burned by the msg.sender
662    */
663   function _burn(address owner, uint256 tokenId) internal {
664     _clearApproval(owner, tokenId);
665     _removeTokenFrom(owner, tokenId);
666     emit Transfer(owner, address(0), tokenId);
667 
668     // Clear metadata (if any)
669     if (bytes(_tokenURIs[tokenId]).length != 0) {
670       delete _tokenURIs[tokenId];
671     }
672     // Reorg all tokens array
673     uint256 tokenIndex = _allTokensIndex[tokenId];
674     uint256 lastTokenIndex = _allTokens.length.sub(1);
675     uint256 lastToken = _allTokens[lastTokenIndex];
676 
677     _allTokens[tokenIndex] = lastToken;
678     _allTokens[lastTokenIndex] = 0;
679 
680     _allTokens.length--;
681     _allTokensIndex[tokenId] = 0;
682     _allTokensIndex[lastToken] = tokenIndex;
683   }
684 
685   function mintWithTokenURI(
686     address to,
687     uint256 tokenId,
688     string tokenUri
689   )
690     public
691     onlyMinter
692     returns (bool)
693   {
694     _mint(to, tokenId);
695     _setTokenURI(tokenId, tokenUri);
696     return true;
697   }
698 
699   event Transfer(
700     address indexed from,
701     address indexed to,
702     uint256 indexed tokenId
703   );
704   event Approval(
705     address indexed owner,
706     address indexed approved,
707     uint256 indexed tokenId
708   );
709   event ApprovalForAll(
710     address indexed owner,
711     address indexed operator,
712     bool approved
713   );
714 }