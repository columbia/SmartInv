1 pragma solidity ^0.4.24;
2 
3 interface ERC721 /* is ERC165 */ {
4     /// @dev This emits when ownership of any NFT changes by any mechanism.
5     ///  This event emits when NFTs are created (`from` == 0) and destroyed
6     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
7     ///  may be created and assigned without emitting Transfer. At the time of
8     ///  any transfer, the approved address for that NFT (if any) is reset to none.
9     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
10 
11     /// @dev This emits when the approved address for an NFT is changed or
12     ///  reaffirmed. The zero address indicates there is no approved address.
13     ///  When a Transfer event emits, this also indicates that the approved
14     ///  address for that NFT (if any) is reset to none.
15     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
16 
17     /// @dev This emits when an operator is enabled or disabled for an owner.
18     ///  The operator can manage all NFTs of the owner.
19     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
20 
21     /// @notice Count all NFTs assigned to an owner
22     /// @dev NFTs assigned to the zero address are considered invalid, and this
23     ///  function throws for queries about the zero address.
24     /// @param _owner An address for whom to query the balance
25     /// @return The number of NFTs owned by `_owner`, possibly zero
26     function balanceOf(address _owner) external view returns (uint256);
27 
28     /// @notice Find the owner of an NFT
29     /// @dev NFTs assigned to zero address are considered invalid, and queries
30     ///  about them do throw.
31     /// @param _tokenId The identifier for an NFT
32     /// @return The address of the owner of the NFT
33     function ownerOf(uint256 _tokenId) external view returns (address);
34 
35     /// @notice Transfers the ownership of an NFT from one address to another address
36     /// @dev Throws unless `msg.sender` is the current owner, an authorized
37     ///  operator, or the approved address for this NFT. Throws if `_from` is
38     ///  not the current owner. Throws if `_to` is the zero address. Throws if
39     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
40     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
41     ///  `onERC721Received` on `_to` and throws if the return value is not
42     ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
43     /// @param _from The current owner of the NFT
44     /// @param _to The new owner
45     /// @param _tokenId The NFT to transfer
46     /// @param data Additional data with no specified format, sent in call to `_to`
47     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external;
48 
49     /// @notice Transfers the ownership of an NFT from one address to another address
50     /// @dev This works identically to the other function with an extra data parameter,
51     ///  except this function just sets data to "".
52     /// @param _from The current owner of the NFT
53     /// @param _to The new owner
54     /// @param _tokenId The NFT to transfer
55     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
56 
57     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
58     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
59     ///  THEY MAY BE PERMANENTLY LOST
60     /// @dev Throws unless `msg.sender` is the current owner, an authorized
61     ///  operator, or the approved address for this NFT. Throws if `_from` is
62     ///  not the current owner. Throws if `_to` is the zero address. Throws if
63     ///  `_tokenId` is not a valid NFT.
64     /// @param _from The current owner of the NFT
65     /// @param _to The new owner
66     /// @param _tokenId The NFT to transfer
67     function transferFrom(address _from, address _to, uint256 _tokenId) external;
68 
69     /// @notice Change or reaffirm the approved address for an NFT
70     /// @dev The zero address indicates there is no approved address.
71     ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
72     ///  operator of the current owner.
73     /// @param _approved The new approved NFT controller
74     /// @param _tokenId The NFT to approve
75     function approve(address _approved, uint256 _tokenId) external;
76 
77     /// @notice Enable or disable approval for a third party ("operator") to manage
78     ///  all of `msg.sender`'s assets
79     /// @dev Emits the ApprovalForAll event. The contract MUST allow
80     ///  multiple operators per owner.
81     /// @param _operator Address to add to the set of authorized operators
82     /// @param _approved True if the operator is approved, false to revoke approval
83     function setApprovalForAll(address _operator, bool _approved) external;
84 
85     /// @notice Get the approved address for a single NFT
86     /// @dev Throws if `_tokenId` is not a valid NFT.
87     /// @param _tokenId The NFT to find the approved address for
88     /// @return The approved address for this NFT, or the zero address if there is none
89     function getApproved(uint256 _tokenId) external view returns (address);
90 
91     /// @notice Query if an address is an authorized operator for another address
92     /// @param _owner The address that owns the NFTs
93     /// @param _operator The address that acts on behalf of the owner
94     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
95     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
96 }
97 
98 /**
99  * @title Ownable
100  * @dev The Ownable contract has an owner address, and provides basic authorization control
101  * functions, this simplifies the implementation of "user permissions".
102  */
103 contract Ownable {
104   address public owner;
105 
106 
107   event OwnershipRenounced(address indexed previousOwner);
108   event OwnershipTransferred(
109     address indexed previousOwner,
110     address indexed newOwner
111   );
112 
113 
114   /**
115    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
116    * account.
117    */
118   constructor() public {
119     owner = msg.sender;
120   }
121 
122   /**
123    * @dev Throws if called by any account other than the owner.
124    */
125   modifier onlyOwner() {
126     require(msg.sender == owner);
127     _;
128   }
129 
130   /**
131    * @dev Allows the current owner to relinquish control of the contract.
132    * @notice Renouncing to ownership will leave the contract without an owner.
133    * It will not be possible to call the functions with the `onlyOwner`
134    * modifier anymore.
135    */
136   function renounceOwnership() public onlyOwner {
137     emit OwnershipRenounced(owner);
138     owner = address(0);
139   }
140 
141   /**
142    * @dev Allows the current owner to transfer control of the contract to a newOwner.
143    * @param _newOwner The address to transfer ownership to.
144    */
145   function transferOwnership(address _newOwner) public onlyOwner {
146     _transferOwnership(_newOwner);
147   }
148 
149   /**
150    * @dev Transfers control of the contract to a newOwner.
151    * @param _newOwner The address to transfer ownership to.
152    */
153   function _transferOwnership(address _newOwner) internal {
154     require(_newOwner != address(0));
155     emit OwnershipTransferred(owner, _newOwner);
156     owner = _newOwner;
157   }
158 }
159 
160 
161 /**
162  * @title Operator
163  * @dev Allow two roles: 'owner' or 'operator'
164  *      - owner: admin/superuser (e.g. with financial rights)
165  *      - operator: can update configurations
166  */
167 contract Operator is Ownable {
168     address[] public operators;
169 
170     uint public MAX_OPS = 20; // Default maximum number of operators allowed
171 
172     mapping(address => bool) public isOperator;
173 
174     event OperatorAdded(address operator);
175     event OperatorRemoved(address operator);
176 
177     // @dev Throws if called by any non-operator account. Owner has all ops rights.
178     modifier onlyOperator() {
179         require(
180             isOperator[msg.sender] || msg.sender == owner,
181             "Permission denied. Must be an operator or the owner."
182         );
183         _;
184     }
185 
186     /**
187      * @dev Allows the current owner or operators to add operators
188      * @param _newOperator New operator address
189      */
190     function addOperator(address _newOperator) public onlyOwner {
191         require(
192             _newOperator != address(0),
193             "Invalid new operator address."
194         );
195 
196         // Make sure no dups
197         require(
198             !isOperator[_newOperator],
199             "New operator exists."
200         );
201 
202         // Only allow so many ops
203         require(
204             operators.length < MAX_OPS,
205             "Overflow."
206         );
207 
208         operators.push(_newOperator);
209         isOperator[_newOperator] = true;
210 
211         emit OperatorAdded(_newOperator);
212     }
213 
214     /**
215      * @dev Allows the current owner or operators to remove operator
216      * @param _operator Address of the operator to be removed
217      */
218     function removeOperator(address _operator) public onlyOwner {
219         // Make sure operators array is not empty
220         require(
221             operators.length > 0,
222             "No operator."
223         );
224 
225         // Make sure the operator exists
226         require(
227             isOperator[_operator],
228             "Not an operator."
229         );
230 
231         // Manual array manipulation:
232         // - replace the _operator with last operator in array
233         // - remove the last item from array
234         address lastOperator = operators[operators.length - 1];
235         for (uint i = 0; i < operators.length; i++) {
236             if (operators[i] == _operator) {
237                 operators[i] = lastOperator;
238             }
239         }
240         operators.length -= 1; // remove the last element
241 
242         isOperator[_operator] = false;
243         emit OperatorRemoved(_operator);
244     }
245 
246     // @dev Remove ALL operators
247     function removeAllOps() public onlyOwner {
248         for (uint i = 0; i < operators.length; i++) {
249             isOperator[operators[i]] = false;
250         }
251         operators.length = 0;
252     }
253 }
254 
255 interface AvatarItemService {
256 
257   function getTransferTimes(uint256 _tokenId) external view returns(uint256);
258   function getOwnedItems(address _owner) external view returns(uint256[] _tokenIds);
259   
260   function getItemInfo(uint256 _tokenId)
261     external 
262     view 
263     returns(string, string, bool, uint256[4] _attr1, uint8[5] _attr2, uint16[2] _attr3);
264 
265   function isBurned(uint256 _tokenId) external view returns (bool); 
266   function isSameItem(uint256 _tokenId1, uint256 _tokenId2) external view returns (bool _isSame);
267   function getBurnedItemCount() external view returns (uint256);
268   function getBurnedItemByIndex(uint256 _index) external view returns (uint256);
269   function getSameItemCount(uint256 _tokenId) external view returns(uint256);
270   function getSameItemIdByIndex(uint256 _tokenId, uint256 _index) external view returns(uint256);
271   function getItemHash(uint256 _tokenId) external view returns (bytes8); 
272 
273   function burnItem(address _owner, uint256 _tokenId) external;
274   /**
275     @param _owner         owner of the token
276     @param _founder       founder type of the token 
277     @param _creator       creator type of the token
278     @param _isBitizenItem true is for bitizen or false
279     @param _attr1         _atrr1[0] => node   _atrr1[1] => listNumber _atrr1[2] => setNumber  _atrr1[3] => quality
280     @param _attr2         _atrr2[0] => rarity _atrr2[1] => socket     _atrr2[2] => gender     _atrr2[3] => energy  _atrr2[4] => ext 
281     @param _attr3         _atrr3[0] => miningTime  _atrr3[1] => magicFind     
282     @return               token id
283    */
284   function createItem( 
285     address _owner,
286     string _founder,
287     string _creator, 
288     bool _isBitizenItem, 
289     uint256[4] _attr1,
290     uint8[5] _attr2,
291     uint16[2] _attr3)
292     external  
293     returns(uint256 _tokenId);
294 
295   function updateItem(
296     uint256 _tokenId,
297     bool  _isBitizenItem,
298     uint16 _miningTime,
299     uint16 _magicFind,
300     uint256 _node,
301     uint256 _listNumber,
302     uint256 _setNumber,
303     uint256 _quality,
304     uint8 _rarity,
305     uint8 _socket,
306     uint8 _gender,
307     uint8 _energy,
308     uint8 _ext
309   ) 
310   external;
311 }
312 
313 contract AvatarItemOperator is Operator {
314 
315   enum ItemRarity{
316     RARITY_LIMITED,
317     RARITY_OTEHR
318   }
319 
320   event ItemCreated(address indexed _owner, uint256 _itemId, ItemRarity _type);
321  
322   event UpdateLimitedItemCount(bytes8 _hash, uint256 _maxCount);
323 
324   // item hash => max value 
325   mapping(bytes8 => uint256) internal itemLimitedCount;
326   // token id => position
327   mapping(uint256 => uint256) internal itemPosition;
328   // item hash => index
329   mapping(bytes8 => uint256) internal itemIndex;
330 
331   AvatarItemService internal itemService;
332   ERC721 internal ERC721Service;
333 
334   constructor() public {
335     _setDefaultLimitedItem();
336   }
337 
338   function injectItemService(AvatarItemService _itemService) external onlyOwner {
339     itemService = AvatarItemService(_itemService);
340     ERC721Service = ERC721(_itemService);
341   }
342 
343   function getOwnedItems() external view returns(uint256[] _itemIds) {
344     return itemService.getOwnedItems(msg.sender);
345   }
346 
347   function getItemInfo(uint256 _itemId)
348     external 
349     view 
350     returns(string, string, bool, uint256[4] _attr1, uint8[5] _attr2, uint16[2] _attr3) {
351     return itemService.getItemInfo(_itemId);
352   }
353 
354   function getSameItemCount(uint256 _itemId) external view returns(uint256){
355     return itemService.getSameItemCount(_itemId);
356   }
357 
358   function getSameItemIdByIndex(uint256 _itemId, uint256 _index) external view returns(uint256){
359     return itemService.getSameItemIdByIndex(_itemId, _index);
360   }
361 
362   function getItemHash(uint256 _itemId) external view  returns (bytes8) {
363     return itemService.getItemHash(_itemId);
364   }
365 
366   function isSameItem(uint256 _itemId1, uint256 _itemId2) external view returns (bool) {
367     return itemService.isSameItem(_itemId1,_itemId2);
368   }
369 
370   function getLimitedValue(uint256 _itemId) external view returns(uint256) {
371     return itemLimitedCount[itemService.getItemHash(_itemId)];
372   }
373   // return the item position when get it in all same items
374   function getItemPosition(uint256 _itemId) external view returns (uint256 _pos) {
375     require(ERC721Service.ownerOf(_itemId) != address(0), "token not exist");
376     _pos = itemPosition[_itemId];
377   }
378 
379   function updateLimitedItemCount(bytes8 _itemBytes8, uint256 _count) public onlyOperator {
380     itemLimitedCount[_itemBytes8] = _count;
381     emit UpdateLimitedItemCount(_itemBytes8, _count);
382   }
383   
384   function createItem( 
385     address _owner,
386     string _founder,
387     string _creator,
388     bool _isBitizenItem,
389     uint256[4] _attr1,
390     uint8[5] _attr2,
391     uint16[2] _attr3) 
392     external 
393     onlyOperator
394     returns(uint256 _itemId) {
395     require(_attr3[0] >= 0 && _attr3[0] <= 10000, "param must be range to 0 ~ 10000 ");
396     require(_attr3[1] >= 0 && _attr3[1] <= 10000, "param must be range to 0 ~ 10000 ");
397     _itemId = _mintItem(_owner, _founder, _creator, _isBitizenItem, _attr1, _attr2, _attr3);
398   }
399 
400   // add limited item check 
401   function _mintItem( 
402     address _owner,
403     string _founder,
404     string _creator,
405     bool _isBitizenItem,
406     uint256[4] _attr1,
407     uint8[5] _attr2,
408     uint16[2] _attr3) 
409     internal 
410     returns(uint256) {
411     uint256 tokenId = itemService.createItem(_owner, _founder, _creator, _isBitizenItem, _attr1, _attr2, _attr3);
412     bytes8 itemHash = itemService.getItemHash(tokenId);
413     _saveItemIndex(itemHash, tokenId);
414     if(itemLimitedCount[itemHash] > 0){
415       require(itemService.getSameItemCount(tokenId) <= itemLimitedCount[itemHash], "overflow");  // limited item
416       emit ItemCreated(_owner, tokenId, ItemRarity.RARITY_LIMITED);
417     } else {
418       emit ItemCreated(_owner, tokenId,  ItemRarity.RARITY_OTEHR);
419     }
420     return tokenId;
421   }
422 
423   function _saveItemIndex(bytes8 _itemHash, uint256 _itemId) private {
424     itemIndex[_itemHash]++;
425     itemPosition[_itemId] = itemIndex[_itemHash];
426   }
427 
428   function _setDefaultLimitedItem() private {
429     itemLimitedCount[0xc809275c18c405b7] = 3;     //  Pioneer‘s Compass
430     itemLimitedCount[0x7cb371a84bb16b98] = 100;   //  Pioneer of the Wild Hat
431     itemLimitedCount[0x26a27c8bf9dd554b] = 100;   //  Pioneer of the Wild Top 
432     itemLimitedCount[0xa8c29099f2421c0b] = 100;   //  Pioneer of the Wild Pant
433     itemLimitedCount[0x8060b7c58dce9548] = 100;   //  Pioneer of the Wild Shoes
434     itemLimitedCount[0x4f7d254af1d033cf] = 25;    //  Pioneer of the Skies Hat
435     itemLimitedCount[0x19b6d994c1491e27] = 25;    //  Pioneer of the Skies Top
436     itemLimitedCount[0x71e84d6ef1cf6c85] = 25;    //  Pioneer of the Skies Shoes
437     itemLimitedCount[0xff5f095a3a3b990f] = 25;    //  Pioneer of the Skies Pant
438     itemLimitedCount[0xa066c007ef8c352c] = 1;     //  Pioneer of the Cyberspace Hat
439     itemLimitedCount[0x1029368269e054d5] = 1;     //  Pioneer of the Cyberspace Top
440     itemLimitedCount[0xfd0e74b52734b343] = 1;     //  Pioneer of the Cyberspace Pant
441     itemLimitedCount[0xf5974771adaa3a6b] = 1;     //  Pioneer of the Cyberspace Shoes
442     itemLimitedCount[0x405b16d28c964f69] = 10;    //  Pioneer of the Seas Hat
443     itemLimitedCount[0x8335384d55547989] = 10;    //  Pioneer of the Seas Top
444     itemLimitedCount[0x679a5e1e0312d35a] = 10;    //  Pioneer of the Seas Pant
445     itemLimitedCount[0xe3d973cce112f782] = 10;    //  Pioneer of the Seas Shoes
446     itemLimitedCount[0xcde6284740e5fde9] = 50;    //  DAPP T-Shirt
447   }
448 
449   function () public {
450     revert();
451   }
452 }