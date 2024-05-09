1 pragma solidity 0.4.24;
2 
3 /**
4  * @title ERC721 token receiver interface
5  * @dev Interface for any contract that wants to support safeTransfers
6  * from ERC721 asset contracts.
7  */
8 interface ERC721Receiver {
9   /**
10    * @dev Magic value to be returned upon successful reception of an NFT
11    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint,bytes)"))`,
12    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
13    */
14   ///bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
15 
16   /**
17    * @notice Handle the receipt of an NFT
18    * @dev The ERC721 smart contract calls this function on the recipient
19    * after a `safetransfer`. This function MAY throw to revert and reject the
20    * transfer. Return of other than the magic value MUST result in the 
21    * transaction being reverted.
22    * Note: the contract address is always the message sender.
23    * @param _operator The address which called `safeTransferFrom` function
24    * @param _from The address which previously owned the token
25    * @param _tokenId The NFT identifier which is being transfered
26    * @param _data Additional data with no specified format
27    * @return `bytes4(keccak256("onERC721Received(address,address,uint,bytes)"))`
28    */
29   function onERC721Received(
30     address _operator,
31     address _from,
32     uint _tokenId,
33     bytes _data
34   )
35     public
36     returns(bytes4);
37 }
38 
39 /**
40  * @title ERC165
41  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
42  */
43 interface ERC165 {
44 
45   /**
46    * @notice Query if a contract implements an interface
47    * @param _interfaceId The interface identifier, as specified in ERC-165
48    * @dev Interface identification is specified in ERC-165. This function
49    * uses less than 30,000 gas.
50    */
51   function supportsInterface(bytes4 _interfaceId)
52     external
53     view
54     returns (bool);
55 }
56 
57 /**
58  * @title SupportsInterfaceWithLookup
59  * @author Matt Condon (@shrugs)
60  * @dev Implements ERC165 using a lookup table.
61  */
62 contract SupportsInterfaceWithLookup is ERC165 {
63   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
64   /**
65    * 0x01ffc9a7 ===
66    *   bytes4(keccak256('supportsInterface(bytes4)'))
67    */
68 
69   /**
70    * @dev a mapping of interface id to whether or not it's supported
71    */
72   mapping(bytes4 => bool) internal supportedInterfaces;
73 
74   /**
75    * @dev A contract implementing SupportsInterfaceWithLookup
76    * implement ERC165 itself
77    */
78   constructor()
79     public
80   {
81     _registerInterface(InterfaceId_ERC165);
82   }
83 
84   /**
85    * @dev implement supportsInterface(bytes4) using a lookup table
86    */
87   function supportsInterface(bytes4 _interfaceId)
88     external
89     view
90     returns (bool)
91   {
92     return supportedInterfaces[_interfaceId];
93   }
94 
95   /**
96    * @dev private method for registering an interface
97    */
98   function _registerInterface(bytes4 _interfaceId)
99     internal
100   {
101     require(_interfaceId != 0xffffffff);
102     supportedInterfaces[_interfaceId] = true;
103   }
104 }
105 
106 contract MyCryptoChampCore{
107     struct Champ {
108         uint id;
109         uint attackPower;
110         uint defencePower;
111         uint cooldownTime; 
112         uint readyTime;
113         uint winCount;
114         uint lossCount;
115         uint position; 
116         uint price; 
117         uint withdrawCooldown; 
118         uint eq_sword; 
119         uint eq_shield; 
120         uint eq_helmet; 
121         bool forSale; 
122     }
123     
124     struct AddressInfo {
125         uint withdrawal;
126         uint champsCount;
127         uint itemsCount;
128         string name;
129     }
130 
131     struct Item {
132         uint id;
133         uint8 itemType; 
134         uint8 itemRarity; 
135         uint attackPower;
136         uint defencePower;
137         uint cooldownReduction;
138         uint price;
139         uint onChampId; 
140         bool onChamp; 
141         bool forSale;
142     }
143     
144     Champ[] public champs;
145     Item[] public items;
146     mapping (uint => uint) public leaderboard;
147     mapping (address => AddressInfo) public addressInfo;
148     mapping (bool => mapping(address => mapping (address => bool))) public tokenOperatorApprovals;
149     mapping (bool => mapping(uint => address)) public tokenApprovals;
150     mapping (bool => mapping(uint => address)) public tokenToOwner;
151     mapping (uint => string) public champToName;
152     mapping (bool => uint) public tokensForSaleCount;
153     uint public pendingWithdrawal = 0;
154 
155     function addWithdrawal(address _address, uint _amount) public;
156     function clearTokenApproval(address _from, uint _tokenId, bool _isTokenChamp) public;
157     function setChampsName(uint _champId, string _name) public;
158     function setLeaderboard(uint _x, uint _value) public;
159     function setTokenApproval(uint _id, address _to, bool _isTokenChamp) public;
160     function setTokenOperatorApprovals(address _from, address _to, bool _approved, bool _isTokenChamp) public;
161     function setTokenToOwner(uint _id, address _owner, bool _isTokenChamp) public;
162     function setTokensForSaleCount(uint _value, bool _isTokenChamp) public;
163     function transferToken(address _from, address _to, uint _id, bool _isTokenChamp) public;
164     function newChamp(uint _attackPower,uint _defencePower,uint _cooldownTime,uint _winCount,uint _lossCount,uint _position,uint _price,uint _eq_sword, uint _eq_shield, uint _eq_helmet, bool _forSale,address _owner) public returns (uint);
165     function newItem(uint8 _itemType,uint8 _itemRarity,uint _attackPower,uint _defencePower,uint _cooldownReduction,uint _price,uint _onChampId,bool _onChamp,bool _forSale,address _owner) public returns (uint);
166     function updateAddressInfo(address _address, uint _withdrawal, bool _updatePendingWithdrawal, uint _champsCount, bool _updateChampsCount, uint _itemsCount, bool _updateItemsCount, string _name, bool _updateName) public;
167     function updateChamp(uint _champId, uint _attackPower,uint _defencePower,uint _cooldownTime,uint _readyTime,uint _winCount,uint _lossCount,uint _position,uint _price,uint _withdrawCooldown,uint _eq_sword, uint _eq_shield, uint _eq_helmet, bool _forSale) public;
168     function updateItem(uint _id,uint8 _itemType,uint8 _itemRarity,uint _attackPower,uint _defencePower,uint _cooldownReduction,uint _price,uint _onChampId,bool _onChamp,bool _forSale) public;
169 
170     function getChampStats(uint256 _champId) public view returns(uint256,uint256,uint256);
171     function getChampsByOwner(address _owner) external view returns(uint256[]);
172     function getTokensForSale(bool _isTokenChamp) view external returns(uint256[]);
173     function getItemsByOwner(address _owner) external view returns(uint256[]);
174     function getTokenCount(bool _isTokenChamp) external view returns(uint);
175     function getTokenURIs(uint _tokenId, bool _isTokenChamp) public view returns(string);
176     function onlyApprovedOrOwnerOfToken(uint _id, address _msgsender, bool _isTokenChamp) external view returns(bool);
177     
178 }
179 
180 /**
181  * @title Ownable
182  * @dev The Ownable contract has an owner address, and provides basic authorization control
183  * functions, this simplifies the implementation of "user permissions".
184  */
185 contract Ownable {
186   address internal contractOwner;
187 
188   constructor () internal {
189     if(contractOwner == address(0)){
190       contractOwner = msg.sender;
191     }
192   }
193 
194   /**
195    * @dev Throws if called by any account other than the owner.
196    */
197   modifier onlyOwner() {
198     require(msg.sender == contractOwner);
199     _;
200   }
201   
202 
203   /**
204    * @dev Allows the current owner to transfer control of the contract to a newOwner.
205    * @param newOwner The address to transfer ownership to.
206    */
207   function transferOwnership(address newOwner) public onlyOwner {
208     require(newOwner != address(0));
209     contractOwner = newOwner;
210   }
211 
212 }
213 
214 /**
215  * Utility library of inline functions on addresses
216  */
217 library AddressUtils {
218 
219   /**
220    * Returns whether the target address is a contract
221    * @dev This function will return false if invoked during the constructor of a contract,
222    * as the code is not actually created until after the constructor finishes.
223    * @param addr address to check
224    * @return whether the target address is a contract
225    */
226   function isContract(address addr) internal view returns (bool) {
227     uint256 size;
228     // XXX Currently there is no better way to check if there is a contract in an address
229     // than to check the size of the code at that address.
230     // See https://ethereum.stackexchange.com/a/14016/36603
231     // for more details about how this works.
232     // TODO Check this again before the Serenity release, because all addresses will be
233     // contracts then.
234     // solium-disable-next-line security/no-inline-assembly
235     assembly { size := extcodesize(addr) }
236     return size > 0;
237   }
238 
239 }
240 
241 
242 contract ERC721 is Ownable, SupportsInterfaceWithLookup {
243 
244   using AddressUtils for address;
245 
246   string private _ERC721name = "Champ";
247   string private _ERC721symbol = "MXC";
248   bool private tokenIsChamp = true;
249   address private controllerAddress;
250   MyCryptoChampCore core;
251 
252   function setCore(address newCoreAddress) public onlyOwner {
253     core = MyCryptoChampCore(newCoreAddress);
254   }
255 
256   function setController(address _address) external onlyOwner {
257     controllerAddress = _address;
258   }
259 
260   function emitTransfer(address _from, address _to, uint _tokenId) external {
261     require(msg.sender == controllerAddress);
262     emit Transfer(_from, _to, _tokenId);
263   }
264 
265   //ERC721 START
266   event Transfer(address indexed _from, address indexed _to, uint indexed _tokenId);
267   event Approval(address indexed _owner, address indexed _approved, uint indexed _tokenId);
268   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
269 
270   bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
271   /**
272    * 0x80ac58cd ===
273    *   bytes4(keccak256('balanceOf(address)')) ^
274    *   bytes4(keccak256('ownerOf(uint256)')) ^
275    *   bytes4(keccak256('approve(address,uint256)')) ^
276    *   bytes4(keccak256('getApproved(uint256)')) ^
277    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
278    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
279    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
280    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
281    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
282    */
283 
284   bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
285   /**
286    * 0x4f558e79 ===
287    *   bytes4(keccak256('exists(uint256)'))
288    */
289 
290    /**
291    * @dev Magic value to be returned upon successful reception of an NFT
292    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint,bytes)"))`,
293    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
294    */
295   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
296   
297   bytes4 constant InterfaceId_ERC721Enumerable = 0x780e9d63;
298   /**
299       bytes4(keccak256('totalSupply()')) ^
300       bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
301       bytes4(keccak256('tokenByIndex(uint256)'));
302   */
303 
304   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
305   /**
306      * 0x5b5e139f ===
307      *   bytes4(keccak256('name()')) ^
308      *   bytes4(keccak256('symbol()')) ^
309      *   bytes4(keccak256('tokenURI(uint256)'))
310   */
311 
312    constructor()
313     public
314   {
315     // register the supported interfaces to conform to ERC721 via ERC165
316     _registerInterface(InterfaceId_ERC721);
317     _registerInterface(InterfaceId_ERC721Exists);
318     _registerInterface(InterfaceId_ERC721Enumerable);
319     _registerInterface(InterfaceId_ERC721Metadata);
320   }
321 
322 
323   /**
324  * @dev Guarantees msg.sender is owner of the given token
325  * @param _tokenId uint ID of the token to validate its ownership belongs to msg.sender
326  */
327   modifier onlyOwnerOf(uint _tokenId) {
328     require(ownerOf(_tokenId) == msg.sender);
329     _;
330   }
331 
332   /**
333  * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
334  * @param _tokenId uint ID of the token to validate
335  */
336   modifier canTransfer(uint _tokenId) {
337     require(isApprovedOrOwner(msg.sender, _tokenId));
338     _;
339 }
340 
341   /**
342  * @dev Gets the balance of the specified address
343  * @param _owner address to query the balance of
344  * @return uint representing the amount owned by the passed address
345  */
346   function balanceOf(address _owner) public view returns (uint) {
347     require(_owner != address(0));
348     uint balance;
349     if(tokenIsChamp){
350       (,balance,,) = core.addressInfo(_owner);
351     }else{
352       (,,balance,) = core.addressInfo(_owner);
353     }
354     return balance;
355 }
356 
357   /**
358  * @dev Gets the owner of the specified token ID
359  * @param _tokenId uint ID of the token to query the owner of
360  * @return owner address currently marked as the owner of the given token ID
361  */
362 function ownerOf(uint _tokenId) public view returns (address) {
363     address owner = core.tokenToOwner(tokenIsChamp,_tokenId);
364     require(owner != address(0));
365     return owner;
366 }
367 
368 
369 /**
370  * @dev Returns whether the specified token exists
371  * @param _tokenId uint ID of the token to query the existence of
372  * @return whether the token exists
373  */
374 function exists(uint _tokenId) public view returns (bool) {
375     address owner = core.tokenToOwner(tokenIsChamp,_tokenId);
376     return owner != address(0);
377 }
378 
379 /**
380  * @dev Approves another address to transfer the given token ID
381  * The zero address indicates there is no approved address.
382  * There can only be one approved address per token at a given time.
383  * Can only be called by the token owner or an approved operator.
384  * @param _to address to be approved for the given token ID
385  * @param _tokenId uint ID of the token to be approved
386  */
387 function approve(address _to, uint _tokenId) public {
388     address owner = ownerOf(_tokenId);
389     require(_to != owner);
390     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
391 
392     core.setTokenApproval(_tokenId, _to,tokenIsChamp);
393     emit Approval(owner, _to, _tokenId);
394  }
395 
396 /**
397  * @dev Gets the approved address for a token ID, or zero if no address set
398  * @param _tokenId uint ID of the token to query the approval of
399  * @return address currently approved for the given token ID
400  */
401   function getApproved(uint _tokenId) public view returns (address) {
402     return core.tokenApprovals(tokenIsChamp,_tokenId);
403   }
404 
405 /**
406  * @dev Sets or unsets the approval of a given operator
407  * An operator is allowed to transfer all tokens of the sender on their behalf
408  * @param _to operator address to set the approval
409  * @param _approved representing the status of the approval to be set
410  */
411   function setApprovalForAll(address _to, bool _approved) public {
412     require(_to != msg.sender);
413     core.setTokenOperatorApprovals(msg.sender,_to,_approved,tokenIsChamp);
414     emit ApprovalForAll(msg.sender, _to, _approved);
415   }
416 
417 /**
418  * @dev Tells whether an operator is approved by a given owner
419  * @param _owner owner address which you want to query the approval of
420  * @param _operator operator address which you want to query the approval of
421  * @return bool whether the given operator is approved by the given owner
422  */
423   function isApprovedForAll(
424     address _owner,
425     address _operator
426   )
427     public
428     view
429     returns (bool)
430   {
431     return core.tokenOperatorApprovals(tokenIsChamp, _owner,_operator);
432 }
433 
434 /**
435  * @dev Returns whether the given spender can transfer a given token ID
436  * @param _spender address of the spender to query
437  * @param _tokenId uint ID of the token to be transferred
438  * @return bool whether the msg.sender is approved for the given token ID,
439  *  is an operator of the owner, or is the owner of the token
440  */
441 function isApprovedOrOwner(
442     address _spender,
443     uint _tokenId
444   )
445     internal
446     view
447     returns (bool)
448   {
449     address owner = ownerOf(_tokenId);
450     // Disable solium check because of
451     // https://github.com/duaraghav8/Solium/issues/175
452     // solium-disable-next-line operator-whitespace
453     return (
454       _spender == owner ||
455       getApproved(_tokenId) == _spender ||
456       isApprovedForAll(owner, _spender)
457     );
458 }
459 
460 /**
461  * @dev Transfers the ownership of a given token ID to another address
462  * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
463  * Requires the msg sender to be the owner, approved, or operator
464  * @param _from current owner of the token
465  * @param _to address to receive the ownership of the given token ID
466  * @param _tokenId uint ID of the token to be transferred
467 */
468 function transferFrom(
469     address _from,
470     address _to,
471     uint _tokenId
472   )
473     public
474     canTransfer(_tokenId)
475   {
476     require(_from != address(0));
477     require(_to != address(0));
478 
479     core.clearTokenApproval(_from, _tokenId, tokenIsChamp);
480     core.transferToken(_from, _to, _tokenId, tokenIsChamp);
481 
482     emit Transfer(_from, _to, _tokenId);
483 }
484 
485 /**
486  * @dev Safely transfers the ownership of a given token ID to another address
487  * If the target address is a contract, it must implement `onERC721Received`,
488  * which is called upon a safe transfer, and return the magic value
489  * `bytes4(keccak256("onERC721Received(address,address,uint,bytes)"))`; otherwise,
490  * the transfer is reverted.
491  *
492  * Requires the msg sender to be the owner, approved, or operator
493  * @param _from current owner of the token
494  * @param _to address to receive the ownership of the given token ID
495  * @param _tokenId uint ID of the token to be transferred
496 */
497 function safeTransferFrom(
498     address _from,
499     address _to,
500     uint _tokenId
501   )
502     public
503     canTransfer(_tokenId)
504   {
505     // solium-disable-next-line arg-overflow
506     safeTransferFrom(_from, _to, _tokenId, "");
507 }
508 
509   /**
510    * @dev Safely transfers the ownership of a given token ID to another address
511    * If the target address is a contract, it must implement `onERC721Received`,
512    * which is called upon a safe transfer, and return the magic value
513    * `bytes4(keccak256("onERC721Received(address,address,uint,bytes)"))`; otherwise,
514    * the transfer is reverted.
515    * Requires the msg sender to be the owner, approved, or operator
516    * @param _from current owner of the token
517    * @param _to address to receive the ownership of the given token ID
518    * @param _tokenId uint ID of the token to be transferred
519    * @param _data bytes data to send along with a safe transfer check
520    */
521 function safeTransferFrom(
522     address _from,
523     address _to,
524     uint _tokenId,
525     bytes _data
526   )
527     public
528     canTransfer(_tokenId)
529   {
530     transferFrom(_from, _to, _tokenId);
531     // solium-disable-next-line arg-overflow
532     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
533 }
534 
535 /**
536  * @dev Internal function to invoke `onERC721Received` on a target address
537  * The call is not executed if the target address is not a contract
538  * @param _from address representing the previous owner of the given token ID
539  * @param _to target address that will receive the tokens
540  * @param _tokenId uint ID of the token to be transferred
541  * @param _data bytes optional data to send along with the call
542  * @return whether the call correctly returned the expected magic value
543  */
544 function checkAndCallSafeTransfer(
545     address _from,
546     address _to,
547     uint _tokenId,
548     bytes _data
549   )
550     internal
551     returns (bool)
552   {
553     if (!_to.isContract()) {
554       return true;
555     }
556     bytes4 retval = ERC721Receiver(_to).onERC721Received(
557       msg.sender, _from, _tokenId, _data);
558     return (retval == ERC721_RECEIVED);
559 }
560 
561   ///
562   /// ERC721Enumerable
563   ///
564   /// @notice Count NFTs tracked by this contract
565   /// @return A count of valid NFTs tracked by this contract, where each one of
566   ///  them has an assigned and queryable owner not equal to the zero address
567   function totalSupply() external view returns (uint){
568     return core.getTokenCount(tokenIsChamp);
569   }
570 
571   /// @notice Enumerate valid NFTs
572   /// @dev Throws if `_index` >= `totalSupply()`.
573   /// @param _index A counter less than `totalSupply()`
574   /// @return The token identifier for the `_index`th NFT,
575   ///  (sort order not specified)
576   function tokenByIndex(uint _index) external view returns (uint){
577     uint tokenIndexesLength = this.totalSupply();
578     require(_index < tokenIndexesLength);
579     return _index;
580   }
581 
582   
583   /// @notice Enumerate NFTs assigned to an owner
584   /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
585   ///  `_owner` is the zero address, representing invalid NFTs.
586   /// @param _owner An address where we are interested in NFTs owned by them
587   /// @param _index A counter less than `balanceOf(_owner)`
588   /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
589   ///   (sort order not specified)
590   function tokenOfOwnerByIndex(address _owner, uint _index) external view returns (uint){
591       require(_index >= balanceOf(_owner));
592       require(_owner!=address(0));
593       
594       uint[] memory tokens;
595       uint tokenId;
596       
597       if(tokenIsChamp){
598           tokens = core.getChampsByOwner(_owner);
599       }else{
600           tokens = core.getItemsByOwner(_owner);
601       }
602       
603       for(uint i = 0; i < tokens.length; i++){
604           if(i + 1 == _index){
605               tokenId = tokens[i];
606               break;
607           }
608       }
609       
610       return tokenId;
611   }
612   
613   
614   ///
615   /// ERC721Metadata
616   ///
617   /// @notice A descriptive name for a collection of NFTs in this contract
618   function name() external view returns (string _name){
619     return _ERC721name;
620   }
621 
622   /// @notice An abbreviated name for NFTs in this contract
623   function symbol() external view returns (string _symbol){
624     return _ERC721symbol;
625   }
626 
627   /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
628   /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
629   ///  3986. The URI may point to a JSON file that conforms to the "ERC721
630   ///  Metadata JSON Schema".
631   function tokenURI(uint _tokenId) external view returns (string){
632     require(exists(_tokenId));
633     return core.getTokenURIs(_tokenId,tokenIsChamp);
634   }
635 
636 }