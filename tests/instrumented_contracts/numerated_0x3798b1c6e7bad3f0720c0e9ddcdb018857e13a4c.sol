1 pragma solidity ^0.4.18;
2 /* ==================================================================== */
3 /* Copyright (c) 2018 The MagicAcademy Project.  All rights reserved.
4 /* 
5 /* https://www.magicacademy.io One of the world's first idle strategy games of blockchain 
6 /*  
7 /* authors rainy@livestar.com/Jonny.Fu@livestar.com
8 /*                 
9 /* ==================================================================== */
10 /**
11  * @title Ownable
12  * @dev The Ownable contract has an owner address, and provides basic authorization control
13  * functions, this simplifies the implementation of "user permissions".
14  */
15 contract Ownable {
16   address public owner;
17 
18   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20   /*
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   function Ownable() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to transfer control of the contract to a newOwner.
38    * @param newOwner The address to transfer ownership to.
39    */
40   function transferOwnership(address newOwner) public onlyOwner {
41     require(newOwner != address(0));
42     OwnershipTransferred(owner, newOwner);
43     owner = newOwner;
44   }
45 }
46 
47 contract AccessAdmin is Ownable {
48 
49   /// @dev Admin Address
50   mapping (address => bool) adminContracts;
51 
52   /// @dev Trust contract
53   mapping (address => bool) actionContracts;
54 
55   function setAdminContract(address _addr, bool _useful) public onlyOwner {
56     require(_addr != address(0));
57     adminContracts[_addr] = _useful;
58   }
59 
60   modifier onlyAdmin {
61     require(adminContracts[msg.sender]); 
62     _;
63   }
64 
65   function setActionContract(address _actionAddr, bool _useful) public onlyAdmin {
66     actionContracts[_actionAddr] = _useful;
67   }
68 
69   modifier onlyAccess() {
70     require(actionContracts[msg.sender]);
71     _;
72   }
73 }
74 
75 /// @title ERC-721 Non-Fungible Token Standard
76 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
77 ///  Note: the ERC-165 identifier for this interface is 0x80ac58cd
78 contract ERC721 /* is ERC165 */ {
79   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
80   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
81   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
82   
83   function balanceOf(address _owner) external view returns (uint256);
84   function ownerOf(uint256 _tokenId) external view returns (address);
85   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable;
86   function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
87   function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
88   function approve(address _approved, uint256 _tokenId) external payable;
89   function setApprovalForAll(address _operator, bool _approved) external;
90   function getApproved(uint256 _tokenId) external view returns (address);
91   function isApprovedForAll(address _owner, address _operator) external view returns (bool);
92 }
93 
94 interface ERC165 {
95   function supportsInterface(bytes4 interfaceID) external view returns (bool);
96 }
97 
98 /// @title ERC-721 Non-Fungible Token Standard
99 interface ERC721TokenReceiver {
100   function onERC721Received(address _from, uint256 _tokenId, bytes data) external returns(bytes4);
101 }
102 
103 /// @title ERC-721 Non-Fungible Token Standard, optional metadata extension
104 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
105 ///  Note: the ERC-165 identifier for this interface is 0x5b5e139f
106 /*interface ERC721Metadata is ERC721{
107   function name() external view returns (string _name);
108   function symbol() external view returns (string _symbol);
109   function tokenURI(uint256 _tokenId) external view returns (string);
110 }*/
111 
112 /// @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
113 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
114 ///  Note: the ERC-165 identifier for this interface is 0x780e9d63
115 interface ERC721Enumerable /* is ERC721 */ {
116   function totalSupply() external view returns (uint256);
117   function tokenByIndex(uint256 _index) external view returns (uint256);
118   function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
119 }
120 
121 contract RareCards is AccessAdmin, ERC721 {
122   using SafeMath for SafeMath;
123   // event
124   event eCreateRare(uint256 tokenId, uint256 price, address owner);
125 
126   // ERC721
127   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
128   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
129   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
130 
131   struct RareCard {
132     uint256 rareId;     // rare item id
133     uint256 rareClass;  // upgrade level of rare item
134     uint256 cardId;     // related to basic card ID 
135     uint256 rareValue;  // upgrade value of rare item
136   }
137 
138   RareCard[] public rareArray; // dynamic Array
139 
140   function RareCards() public {
141     rareArray.length += 1;
142     setAdminContract(msg.sender,true);
143     setActionContract(msg.sender,true);
144   }
145 
146   /*** CONSTRUCTOR ***/
147   uint256 private constant PROMO_CREATION_LIMIT = 20;
148   uint256 private constant startPrice = 0.5 ether;
149 
150   address thisAddress = this;
151   uint256 PLATPrice = 65000;
152   /**mapping**/
153   /// @dev map tokenId to owner (tokenId -> address)
154   mapping (uint256 => address) public IndexToOwner;
155   /// @dev search rare item index in owner's array (tokenId -> index)
156   mapping (uint256 => uint256) indexOfOwnedToken;
157   /// @dev list of owned rare items by owner
158   mapping (address => uint256[]) ownerToRareArray;
159   /// @dev search token price by tokenId
160   mapping (uint256 => uint256) IndexToPrice;
161   /// @dev get the authorized address for each rare item
162   mapping (uint256 => address) public IndexToApproved;
163   /// @dev get the authorized operators for each rare item
164   mapping (address => mapping(address => bool)) operatorToApprovals;
165 
166   /** Modifier **/
167   /// @dev Check if token ID is valid
168   modifier isValidToken(uint256 _tokenId) {
169     require(_tokenId >= 1 && _tokenId <= rareArray.length);
170     require(IndexToOwner[_tokenId] != address(0)); 
171     _;
172   }
173   /// @dev check the ownership of token
174   modifier onlyOwnerOf(uint _tokenId) {
175     require(msg.sender == IndexToOwner[_tokenId] || msg.sender == IndexToApproved[_tokenId]);
176     _;
177   }
178 
179   /// @dev create a new rare item
180   function createRareCard(uint256 _rareClass, uint256 _cardId, uint256 _rareValue) public onlyOwner {
181     require(rareArray.length < PROMO_CREATION_LIMIT); 
182     _createRareCard(thisAddress, startPrice, _rareClass, _cardId, _rareValue);
183   }
184 
185 
186   /// steps to create rare item 
187   function _createRareCard(address _owner, uint256 _price, uint256 _rareClass, uint256 _cardId, uint256 _rareValue) internal returns(uint) {
188     uint256 newTokenId = rareArray.length;
189     RareCard memory _rarecard = RareCard({
190       rareId: newTokenId,
191       rareClass: _rareClass,
192       cardId: _cardId,
193       rareValue: _rareValue
194     });
195     rareArray.push(_rarecard);
196     //event
197     eCreateRare(newTokenId, _price, _owner);
198 
199     IndexToPrice[newTokenId] = _price;
200     // This will assign ownership, and also emit the Transfer event as
201     // per ERC721 draft
202     _transfer(address(0), _owner, newTokenId);
203 
204   } 
205 
206   /// @dev transfer the ownership of tokenId
207   /// @param _from The old owner of rare item(If created: 0x0)
208   /// @param _to The new owner of rare item
209   /// @param _tokenId The tokenId of rare item
210   function _transfer(address _from, address _to, uint256 _tokenId) internal {
211     if (_from != address(0)) {
212       uint256 indexFrom = indexOfOwnedToken[_tokenId];
213       uint256[] storage rareArrayOfOwner = ownerToRareArray[_from];
214       require(rareArrayOfOwner[indexFrom] == _tokenId);
215 
216       // Switch the positions of selected item and last item
217       if (indexFrom != rareArrayOfOwner.length - 1) {
218         uint256 lastTokenId = rareArrayOfOwner[rareArrayOfOwner.length - 1];
219         rareArrayOfOwner[indexFrom] = lastTokenId;
220         indexOfOwnedToken[lastTokenId] = indexFrom;
221       }
222       rareArrayOfOwner.length -= 1;
223 
224       // clear any previously approved ownership exchange
225       if (IndexToApproved[_tokenId] != address(0)) {
226         delete IndexToApproved[_tokenId];
227       } 
228     }
229     //transfer ownership
230     IndexToOwner[_tokenId] = _to;
231     ownerToRareArray[_to].push(_tokenId);
232     indexOfOwnedToken[_tokenId] = ownerToRareArray[_to].length - 1;
233     // Emit the transfer event.
234     Transfer(_from != address(0) ? _from : this, _to, _tokenId);
235   }
236 
237   /// @notice Returns all the relevant information about a specific tokenId.
238   /// @param _tokenId The tokenId of the rarecard.
239   function getRareInfo(uint256 _tokenId) external view returns (
240       uint256 sellingPrice,
241       address owner,
242       uint256 nextPrice,
243       uint256 rareClass,
244       uint256 cardId,
245       uint256 rareValue
246   ) {
247     RareCard storage rarecard = rareArray[_tokenId];
248     sellingPrice = IndexToPrice[_tokenId];
249     owner = IndexToOwner[_tokenId];
250     nextPrice = SafeMath.div(SafeMath.mul(sellingPrice,125),100);
251     rareClass = rarecard.rareClass;
252     cardId = rarecard.cardId;
253     rareValue = rarecard.rareValue;
254   }
255 
256   /// @notice Returns all the relevant information about a specific tokenId.
257   /// @param _tokenId The tokenId of the rarecard.
258   function getRarePLATInfo(uint256 _tokenId) external view returns (
259     uint256 sellingPrice,
260     address owner,
261     uint256 nextPrice,
262     uint256 rareClass,
263     uint256 cardId,
264     uint256 rareValue
265   ) {
266     RareCard storage rarecard = rareArray[_tokenId];
267     sellingPrice = SafeMath.mul(IndexToPrice[_tokenId],PLATPrice);
268     owner = IndexToOwner[_tokenId];
269     nextPrice = SafeMath.div(SafeMath.mul(sellingPrice,125),100);
270     rareClass = rarecard.rareClass;
271     cardId = rarecard.cardId;
272     rareValue = rarecard.rareValue;
273   }
274 
275 
276   function getRareItemsOwner(uint256 rareId) external view returns (address) {
277     return IndexToOwner[rareId];
278   }
279 
280   function getRareItemsPrice(uint256 rareId) external view returns (uint256) {
281     return IndexToPrice[rareId];
282   }
283 
284   function getRareItemsPLATPrice(uint256 rareId) external view returns (uint256) {
285     return SafeMath.mul(IndexToPrice[rareId],PLATPrice);
286   }
287 
288   function setRarePrice(uint256 _rareId, uint256 _price) external onlyAccess {
289     IndexToPrice[_rareId] = _price;
290   }
291 
292   function rareStartPrice() external pure returns (uint256) {
293     return startPrice;
294   }
295 
296   /// ERC721
297   /// @notice Count all the rare items assigned to an owner
298   function balanceOf(address _owner) external view returns (uint256) {
299     require(_owner != address(0));
300     return ownerToRareArray[_owner].length;
301   }
302 
303   /// @notice Find the owner of a rare item
304   function ownerOf(uint256 _tokenId) external view returns (address _owner) {
305     return IndexToOwner[_tokenId];
306   }
307 
308   /// @notice Transfers the ownership of a rare item from one address to another address
309   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable {
310     _safeTransferFrom(_from, _to, _tokenId, data);
311   }
312 
313   function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable {
314     _safeTransferFrom(_from, _to, _tokenId, "");
315   }
316 
317   /// @dev steps to implement the safeTransferFrom
318   function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
319     internal
320     isValidToken(_tokenId)
321     onlyOwnerOf(_tokenId) 
322   {
323     address owner = IndexToOwner[_tokenId];
324     require(owner != address(0) && owner == _from);
325     require(_to != address(0));
326             
327     _transfer(_from, _to, _tokenId);
328 
329     // Do the callback after everything is done to avoid reentrancy attack
330     /*uint256 codeSize;
331     assembly { codeSize := extcodesize(_to) }
332     if (codeSize == 0) {
333         return;
334     }*/
335     bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, data);
336     // bytes4(keccak256("onERC721Received(address,uint256,bytes)")) = 0xf0b9e5ba;
337     require(retval == 0xf0b9e5ba);
338   }
339 
340   // function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
341   //   _transfer(msg.sender, _to, _tokenId);
342   // }
343 
344   /// @notice Transfers the ownership of a rare item from one address to another address
345   /// @dev Transfer ownership of a rare item, '_to' must be a vaild address, or the card will lost
346   /// @param _from The current owner of rare item
347   /// @param _to The new owner
348   /// @param _tokenId The rare item to transfer
349   function transferFrom(address _from, address _to, uint256 _tokenId) 
350     external 
351     isValidToken(_tokenId)
352     onlyOwnerOf(_tokenId) 
353     payable 
354   {
355     address owner = IndexToOwner[_tokenId];
356     // require(_owns(_from, _tokenId));
357     // require(_approved(_to, _tokenId));
358     require(owner != address(0) && owner == _from);
359     require(_to != address(0));
360     _transfer(_from, _to, _tokenId);
361   }
362 
363   //   /// For checking approval of transfer for address _to
364   //   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
365   //     return IndexToApproved[_tokenId] == _to;
366   //   }
367   //  /// Check for token ownership
368   //   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
369   //     return claimant == IndexToOwner[_tokenId];
370   //   }
371 
372   /// @dev Set or reaffirm the approved address for a rare item
373   /// @param _approved The new approved rare item controller
374   /// @param _tokenId The rare item to approve
375   function approve(address _approved, uint256 _tokenId) 
376     external 
377     isValidToken(_tokenId)
378     onlyOwnerOf(_tokenId) 
379     payable 
380   {
381     address owner = IndexToOwner[_tokenId];
382     require(operatorToApprovals[owner][msg.sender]);
383     IndexToApproved[_tokenId] = _approved;
384     Approval(owner, _approved, _tokenId);
385   }
386 
387 
388   /// @dev Enable or disable approval for a third party ("operator") to manage all your asset.
389   /// @param _operator Address to add to the set of authorized operators.
390   /// @param _approved True if the operators is approved, false to revoke approval
391   function setApprovalForAll(address _operator, bool _approved) 
392     external 
393   {
394     operatorToApprovals[msg.sender][_operator] = _approved;
395     ApprovalForAll(msg.sender, _operator, _approved);
396   }
397 
398   /// @dev Get the approved address for a single rare item
399   /// @param _tokenId The rare item to find the approved address for
400   /// @return The approved address for this rare item, or the zero address if there is none
401   function getApproved(uint256 _tokenId) external view isValidToken(_tokenId) returns (address) {
402     return IndexToApproved[_tokenId];
403   }
404 
405   /// @dev Query if an address is an authorized operator for another address
406   /// @param _owner The address that owns the rare item
407   /// @param _operator The address that acts on behalf of the owner
408   /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
409   function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
410     return operatorToApprovals[_owner][_operator];
411   }
412 
413   /// @notice Count rare items tracked by this contract
414   /// @return A count of valid rare items tracked by this contract, where each one of
415   ///  them has an assigned and queryable owner not equal to the zero address
416   function totalSupply() external view returns (uint256) {
417     return rareArray.length -1;
418   }
419 
420   /// @notice Enumerate valid rare items
421   /// @dev Throws if `_index` >= `totalSupply()`.
422   /// @param _index A counter less than `totalSupply()`
423   /// @return The token identifier for the `_index`the rare item,
424   ///  (sort order not specified)
425   function tokenByIndex(uint256 _index) external view returns (uint256) {
426     require(_index <= (rareArray.length - 1));
427     return _index;
428   }
429 
430   /// @notice Enumerate rare items assigned to an owner
431   /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
432   ///  `_owner` is the zero address, representing invalid rare items.
433   /// @param _owner An address where we are interested in rare items owned by them
434   /// @param _index A counter less than `balanceOf(_owner)`
435   /// @return The token identifier for the `_index`the rare item assigned to `_owner`,
436   ///   (sort order not specified)
437   function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {
438     require(_index < ownerToRareArray[_owner].length);
439     if (_owner != address(0)) {
440       uint256 tokenId = ownerToRareArray[_owner][_index];
441       return tokenId;
442     }
443   }
444 
445   /// @param _owner The owner whose celebrity tokens we are interested in.
446   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
447   ///  expensive (it walks the entire Persons array looking for persons belonging to owner),
448   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
449   ///  not contract-to-contract calls.
450   function tokensOfOwner(address _owner) external view returns(uint256[]) {
451     uint256 tokenCount = ownerToRareArray[_owner].length;
452     if (tokenCount == 0) {
453       // Return an empty array
454       return new uint256[](0);
455     } else {
456       uint256[] memory result = new uint256[](tokenCount);
457       uint256 totalRare = rareArray.length - 1;
458       uint256 resultIndex = 0;
459 
460       uint256 tokenId;
461       for (tokenId = 0; tokenId <= totalRare; tokenId++) {
462         if (IndexToOwner[tokenId] == _owner) {
463           result[resultIndex] = tokenId;
464           resultIndex++;
465         }
466       }
467       return result;
468     }
469   }
470 
471   //transfer token 
472   function transferToken(address _from, address _to, uint256 _tokenId) external onlyAccess {
473     _transfer(_from,  _to, _tokenId);
474   }
475 
476   // transfer token in contract-- for raffle
477   function transferTokenByContract(uint256 _tokenId,address _to) external onlyAccess {
478     _transfer(thisAddress,  _to, _tokenId);
479   }
480 
481   // owner & price list 
482   function getRareItemInfo() external view returns (address[], uint256[], uint256[]) {
483     address[] memory itemOwners = new address[](rareArray.length-1);
484     uint256[] memory itemPrices = new uint256[](rareArray.length-1);
485     uint256[] memory itemPlatPrices = new uint256[](rareArray.length-1);
486         
487     uint256 startId = 1;
488     uint256 endId = rareArray.length-1;
489         
490     uint256 i;
491     while (startId <= endId) {
492       itemOwners[i] = IndexToOwner[startId];
493       itemPrices[i] = IndexToPrice[startId];
494       itemPlatPrices[i] = SafeMath.mul(IndexToPrice[startId],PLATPrice);
495       i++;
496       startId++;
497     }   
498     return (itemOwners, itemPrices, itemPlatPrices);
499   }
500 } 
501 
502 library SafeMath {
503 
504   /**
505   * @dev Multiplies two numbers, throws on overflow.
506   */
507   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
508     if (a == 0) {
509       return 0;
510     }
511     uint256 c = a * b;
512     assert(c / a == b);
513     return c;
514   }
515 
516   /**
517   * @dev Integer division of two numbers, truncating the quotient.
518   */
519   function div(uint256 a, uint256 b) internal pure returns (uint256) {
520     // assert(b > 0); // Solidity automatically throws when dividing by 0
521     uint256 c = a / b;
522     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
523     return c;
524   }
525 
526   /**
527   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
528   */
529   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
530     assert(b <= a);
531     return a - b;
532   }
533 
534   /**
535   * @dev Adds two numbers, throws on overflow.
536   */
537   function add(uint256 a, uint256 b) internal pure returns (uint256) {
538     uint256 c = a + b;
539     assert(c >= a);
540     return c;
541   }
542 }