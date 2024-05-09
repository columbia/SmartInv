1 pragma solidity ^0.4.18; 
2 
3 
4 
5 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
6 contract ERC721 {
7   // Required methods
8   function approve(address _to, uint256 _tokenId) public;
9   function balanceOf(address _owner) public view returns (uint256 balance);
10   function implementsERC721() public pure returns (bool);
11   function ownerOf(uint256 _tokenId) public view returns (address addr);
12   function takeOwnership(uint256 _tokenId) public;
13   function totalSupply() public view returns (uint256 total);
14   function transferFrom(address _from, address _to, uint256 _tokenId) public;
15   function transfer(address _to, uint256 _tokenId) public;
16 
17   event Transfer(address indexed from, address indexed to, uint256 tokenId);
18   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
19 
20   // Optional
21   // function name() public view returns (string name);
22   // function symbol() public view returns (string symbol);
23   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
24   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
25 }
26 
27 
28 contract CryptoPepeMarketToken is ERC721 {
29 
30   // Modified CryptoCelebs contract
31   // Note: "Item" refers to a SocialMedia asset.
32   
33   /*** EVENTS ***/
34 
35   /// @dev The Birth event is fired whenever a new item comes into existence.
36   event Birth(uint256 tokenId, string name, address owner);
37 
38   /// @dev The TokenSold event is fired whenever a token is sold.
39   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner);
40 
41   /// @dev Transfer event as defined in current draft of ERC721. 
42   ///  ownership is assigned, including births.
43   event Transfer(address from, address to, uint256 tokenId);
44 
45   /*** CONSTANTS ***/
46 
47   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
48   string public constant NAME = "CryptoSocialMedia"; // solhint-disable-line
49   string public constant SYMBOL = "CryptoPepeMarketToken"; // solhint-disable-line
50 
51   uint256 private startingPrice = 0.001 ether;
52   uint256 private constant PROMO_CREATION_LIMIT = 5000;
53   uint256 private firstStepLimit =  0.053613 ether;
54   uint256 private secondStepLimit = 0.564957 ether;
55 
56   mapping (uint256 => TopOwner) private topOwner;
57   mapping (uint256 => address) public lastBuyer;
58 
59   /*** STORAGE ***/
60 
61   /// @dev A mapping from item IDs to the address that owns them. All items have
62   ///  some valid owner address.
63   mapping (uint256 => address) public itemIndexToOwner;
64 
65   // @dev A mapping from owner address to count of tokens that address owns.
66   //  Used internally inside balanceOf() to resolve ownership count.
67   mapping (address => uint256) private ownershipTokenCount;
68 
69   /// @dev A mapping from ItemIDs to an address that has been approved to call
70   ///  transferFrom(). Each item can only have one approved address for transfer
71   ///  at any time. A zero value means no approval is outstanding.
72   mapping (uint256 => address) public itemIndexToApproved;
73 
74   // @dev A mapping from ItemIDs to the price of the token.
75   mapping (uint256 => uint256) private itemIndexToPrice;
76 
77   // The addresses of the accounts (or contracts) that can execute actions within each roles.
78   address public ceoAddress;
79   address public cooAddress;
80 
81   struct TopOwner {
82     address addr;
83     uint256 price;
84   }
85 
86   /*** DATATYPES ***/
87   struct Item {
88     string name;
89 	bytes32 message;
90 	address creatoraddress;		// Creators get the dev fee for item sales.
91   }
92 
93   Item[] private items;
94 
95   /*** ACCESS MODIFIERS ***/
96   /// @dev Access modifier for CEO-only functionality
97   modifier onlyCEO() {
98     require(msg.sender == ceoAddress);
99     _;
100   }
101 
102   /// @dev Access modifier for COO-only functionality
103   modifier onlyCOO() {
104     require(msg.sender == cooAddress);
105     _;
106   }
107 
108   /// Access modifier for contract owner only functionality
109   modifier onlyCLevel() {
110     require(
111       msg.sender == ceoAddress ||
112       msg.sender == cooAddress
113     );
114     _;
115   }
116 
117   /*** CONSTRUCTOR ***/
118   function CryptoPepeMarketToken() public {
119     ceoAddress = msg.sender;
120     cooAddress = msg.sender;
121 
122 	// Restored bag holders
123 	 _createItem("Feelsgood", 0x7d9450A4E85136f46BA3F519e20Fea52f5BEd063,359808729788989630,"",address(this));
124 	_createItem("Ree",0x2C3756c4cB4Ff488F666a3856516ba981197f3f3,184801761494400960,"",address(this));
125 	_createItem("TwoGender",0xb16948C62425ed389454186139cC94178D0eFbAF,359808729788989630,"",address(this));
126 	_createItem("Gains",0xA69E065734f57B73F17b38436f8a6259cCD090Fd,359808729788989630,"",address(this));
127 	_createItem("Trump",0xBcce2CE773bE0250bdDDD4487d927aCCd748414F,94916238056430340,"",address(this));
128 	_createItem("Brain",0xBcce2CE773bE0250bdDDD4487d927aCCd748414F,94916238056430340,"",address(this));
129 	_createItem("Illuminati",0xbd6A9D2C44b571F33Ee2192BD2d46aBA2866405a,94916238056430340,"",address(this));
130 	_createItem("Hang",0x2C659bf56012deeEc69Aea6e87b6587664B99550,94916238056430340,"",address(this));
131 	_createItem("Pepesaur",0x7d9450A4E85136f46BA3F519e20Fea52f5BEd063,184801761494400960,"",address(this));
132 	_createItem("BlockChain",0x2C3756c4cB4Ff488F666a3856516ba981197f3f3,184801761494400960,"",address(this));
133 	_createItem("Wanderer",0xBcce2CE773bE0250bdDDD4487d927aCCd748414F,184801761494400960,"",address(this));
134 	_createItem("Link",0xBcce2CE773bE0250bdDDD4487d927aCCd748414F,184801761494400960,"",address(this));
135 
136 	// Set top owners.
137 	topOwner[1] = TopOwner(0x7d9450A4E85136f46BA3F519e20Fea52f5BEd063,350000000000000000); 
138     topOwner[2] = TopOwner(0xb16948C62425ed389454186139cC94178D0eFbAF, 350000000000000000); 
139     topOwner[3] = TopOwner(0xA69E065734f57B73F17b38436f8a6259cCD090Fd, 350000000000000000); 
140 	lastBuyer[1] = ceoAddress;
141   }
142 
143   /*** PUBLIC FUNCTIONS ***/
144   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
145   /// @param _to The address to be granted transfer approval. Pass address(0) to
146   ///  clear all approvals.
147   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
148   /// @dev Required for ERC-721 compliance.
149   function approve(
150     address _to,
151     uint256 _tokenId
152   ) public {
153     // Caller must own token.
154     require(_owns(msg.sender, _tokenId));
155 
156     itemIndexToApproved[_tokenId] = _to;
157 
158     Approval(msg.sender, _to, _tokenId);
159   }
160 
161   /// For querying balance of a particular account
162   /// @param _owner The address for balance query
163   /// @dev Required for ERC-721 compliance.
164   function balanceOf(address _owner) public view returns (uint256 balance) {
165     return ownershipTokenCount[_owner];
166   }
167 
168   /// @dev Creates a new Item with the given name.
169   function createContractItem(string _name, bytes32 _message, address _creatoraddress) public onlyCOO {
170     _createItem(_name, address(this), startingPrice, _message, _creatoraddress);
171   }
172 
173   /// @notice Returns all the relevant information about a specific item.
174   /// @param _tokenId The tokenId of the item of interest.
175   function getItem(uint256 _tokenId) public view returns (
176     string itemName,
177     uint256 sellingPrice,
178     address owner,
179 	bytes32 itemMessage,
180 	address creator
181   ) {
182     Item storage item = items[_tokenId];
183 
184     itemName = item.name;
185 	itemMessage = item.message;
186     sellingPrice = itemIndexToPrice[_tokenId];
187     owner = itemIndexToOwner[_tokenId];
188 	creator = item.creatoraddress;
189   }
190 
191   function implementsERC721() public pure returns (bool) {
192     return true;
193   }
194 
195   /// @dev Required for ERC-721 compliance.
196   function name() public pure returns (string) {
197     return NAME;
198   }
199 
200   /// For querying owner of token
201   /// @param _tokenId The tokenID for owner inquiry
202   /// @dev Required for ERC-721 compliance.
203   function ownerOf(uint256 _tokenId)
204     public
205     view
206     returns (address owner)
207   {
208     owner = itemIndexToOwner[_tokenId];
209     require(owner != address(0));
210   }
211 
212   function payout(address _to) public onlyCLevel {
213     _payout(_to);
214   }
215 
216   // Allows someone to send ether and obtain the token
217   function purchase(uint256 _tokenId, bytes32 _message) public payable {
218     address oldOwner = itemIndexToOwner[_tokenId];
219     address newOwner = msg.sender;
220 
221     uint256 sellingPrice = itemIndexToPrice[_tokenId];
222 
223     // Making sure token owner is not sending to self
224     require(oldOwner != newOwner);
225 
226     // Safety check to prevent against an unexpected 0x0 default.
227     require(_addressNotNull(newOwner));
228 
229     // Making sure sent amount is greater than or equal to the sellingPrice
230     uint256 msgPrice = msg.value;
231     require(msgPrice >= sellingPrice);
232 
233 	// Onwer of the item gets 86%
234     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 86), 100));
235 
236 	// Top 3 owners get 6% (2% each)
237 	uint256 twoPercentFee = uint256(SafeMath.mul(SafeMath.div(sellingPrice, 100), 2));
238 	topOwner[1].addr.transfer(twoPercentFee); 
239     topOwner[2].addr.transfer(twoPercentFee); 
240     topOwner[3].addr.transfer(twoPercentFee);
241 
242 	uint256 fourPercentFee = uint256(SafeMath.mul(SafeMath.div(sellingPrice, 100), 4));
243 
244 	// Transfer 4% to the last buyer
245 	lastBuyer[1].transfer(fourPercentFee);
246 
247 	// Transfer 4% to the item creator. (Don't transfer if creator is the contract owner)
248 	if(items[_tokenId].creatoraddress != address(this)){
249 		items[_tokenId].creatoraddress.transfer(fourPercentFee);
250 	}
251 
252 
253     // Update prices
254     if (sellingPrice < firstStepLimit) {
255       // first stage
256       itemIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 86);
257     } else if (sellingPrice < secondStepLimit) {
258       // second stage
259       itemIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 86);
260     } else {
261       // third stage
262       itemIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 86);
263     }
264 
265     _transfer(oldOwner, newOwner, _tokenId);
266 	
267     // ## Pay previous tokenOwner if owner is not contract
268     if (oldOwner != address(this)) {
269       oldOwner.transfer(payment);
270     }
271 
272 	// Update the message of the item 
273 	items[_tokenId].message = _message;
274 
275     TokenSold(_tokenId, sellingPrice, itemIndexToPrice[_tokenId], oldOwner, newOwner);
276 
277 	// Set last buyer
278 	lastBuyer[1] = msg.sender;
279 
280 	// Set next top owner (If applicable)
281 	if(sellingPrice > topOwner[3].price){
282         for(uint8 i = 3; i >= 1; i--){
283             if(sellingPrice > topOwner[i].price){
284                 if(i <= 2){ topOwner[3] = topOwner[2]; }
285                 if(i <= 1){ topOwner[2] = topOwner[1]; }
286                 topOwner[i] = TopOwner(msg.sender, sellingPrice);
287                 break;
288             }
289         }
290     }
291 
292 	// refund any excess eth to buyer
293 	uint256 excess = SafeMath.sub(msg.value, sellingPrice);
294 	msg.sender.transfer(excess);
295   }
296 
297   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
298     return itemIndexToPrice[_tokenId];
299   }
300 
301   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
302   /// @param _newCEO The address of the new CEO
303   function setCEO(address _newCEO) public onlyCEO {
304     require(_newCEO != address(0));
305 
306     ceoAddress = _newCEO;
307   }
308 
309   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
310   /// @param _newCOO The address of the new COO
311   function setCOO(address _newCOO) public onlyCEO {
312     require(_newCOO != address(0));
313 
314     cooAddress = _newCOO;
315   }
316 
317   /// @dev Required for ERC-721 compliance.
318   function symbol() public pure returns (string) {
319     return SYMBOL;
320   }
321 
322   /// @notice Allow pre-approved user to take ownership of a token
323   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
324   /// @dev Required for ERC-721 compliance.
325   function takeOwnership(uint256 _tokenId) public {
326     address newOwner = msg.sender;
327     address oldOwner = itemIndexToOwner[_tokenId];
328 
329     // Safety check to prevent against an unexpected 0x0 default.
330     require(_addressNotNull(newOwner));
331 
332     // Making sure transfer is approved
333     require(_approved(newOwner, _tokenId));
334 
335     _transfer(oldOwner, newOwner, _tokenId);
336   }
337 
338   /// @param _owner The owner whose social media tokens we are interested in.
339   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
340   ///  expensive (it walks the entire Items array looking for items belonging to owner),
341   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
342   ///  not contract-to-contract calls.
343   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
344     uint256 tokenCount = balanceOf(_owner);
345     if (tokenCount == 0) {
346         // Return an empty array
347       return new uint256[](0);
348     } else {
349       uint256[] memory result = new uint256[](tokenCount);
350       uint256 totalItems = totalSupply();
351       uint256 resultIndex = 0;
352 
353       uint256 itemId;
354       for (itemId = 0; itemId <= totalItems; itemId++) {
355         if (itemIndexToOwner[itemId] == _owner) {
356           result[resultIndex] = itemId;
357           resultIndex++;
358         }
359       }
360       return result;
361     }
362   }
363 
364   /// For querying totalSupply of token
365   /// @dev Required for ERC-721 compliance.
366   function totalSupply() public view returns (uint256 total) {
367     return items.length;
368   }
369 
370   /// Owner initates the transfer of the token to another account
371   /// @param _to The address for the token to be transferred to.
372   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
373   /// @dev Required for ERC-721 compliance.
374   function transfer(
375     address _to,
376     uint256 _tokenId
377   ) public {
378     require(_owns(msg.sender, _tokenId));
379     require(_addressNotNull(_to));
380 
381     _transfer(msg.sender, _to, _tokenId);
382   }
383 
384   /// Third-party initiates transfer of token from address _from to address _to
385   /// @param _from The address for the token to be transferred from.
386   /// @param _to The address for the token to be transferred to.
387   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
388   /// @dev Required for ERC-721 compliance.
389   function transferFrom(
390     address _from,
391     address _to,
392     uint256 _tokenId
393   ) public {
394     require(_owns(_from, _tokenId));
395     require(_approved(_to, _tokenId));
396     require(_addressNotNull(_to));
397 
398     _transfer(_from, _to, _tokenId);
399   }
400 
401   /*** PRIVATE FUNCTIONS ***/
402   /// Safety check on _to address to prevent against an unexpected 0x0 default.
403   function _addressNotNull(address _to) private pure returns (bool) {
404     return _to != address(0);
405   }
406 
407   /// For checking approval of transfer for address _to
408   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
409     return itemIndexToApproved[_tokenId] == _to;
410   }
411 
412   /// For creating Item
413   function _createItem(string _name, address _owner, uint256 _price, bytes32 _message, address _creatoraddress) private {
414     Item memory _item = Item({
415       name: _name,
416 	  message: _message,
417 	  creatoraddress: _creatoraddress
418     });
419     uint256 newItemId = items.push(_item) - 1;
420 
421     // It's probably never going to happen, 4 billion tokens are A LOT, but
422     // let's just be 100% sure we never let this happen.
423     require(newItemId == uint256(uint32(newItemId)));
424 
425     Birth(newItemId, _name, _owner);
426 
427     itemIndexToPrice[newItemId] = _price;
428 
429     // This will assign ownership, and also emit the Transfer event as
430     // per ERC721 draft
431     _transfer(address(0), _owner, newItemId);
432   }
433 
434   /// Check for token ownership
435   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
436     return claimant == itemIndexToOwner[_tokenId];
437   }
438 
439   /// For paying out balance on contract
440   function _payout(address _to) private {
441     if (_to == address(0)) {
442       ceoAddress.transfer(this.balance);
443     } else {
444       _to.transfer(this.balance);
445     }
446   }
447 
448   /// @dev Assigns ownership of a specific Item to an address.
449   function _transfer(address _from, address _to, uint256 _tokenId) private {
450     // Since the number of items is capped to 2^32 we can't overflow this
451     ownershipTokenCount[_to]++;
452     //transfer ownership
453     itemIndexToOwner[_tokenId] = _to;
454 
455     // When creating new items _from is 0x0, but we can't account that address.
456     if (_from != address(0)) {
457       ownershipTokenCount[_from]--;
458       // clear any previously approved ownership exchange
459       delete itemIndexToApproved[_tokenId];
460     }
461 
462     // Emit the transfer event.
463     Transfer(_from, _to, _tokenId);
464   }
465 }
466 library SafeMath {
467 
468   /**
469   * @dev Multiplies two numbers, throws on overflow.
470   */
471   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
472     if (a == 0) {
473       return 0;
474     }
475     uint256 c = a * b;
476     assert(c / a == b);
477     return c;
478   }
479 
480   /**
481   * @dev Integer division of two numbers, truncating the quotient.
482   */
483   function div(uint256 a, uint256 b) internal pure returns (uint256) {
484     // assert(b > 0); // Solidity automatically throws when dividing by 0
485     uint256 c = a / b;
486     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
487     return c;
488   }
489 
490   /**
491   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
492   */
493   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
494     assert(b <= a);
495     return a - b;
496   }
497 
498   /**
499   * @dev Adds two numbers, throws on overflow.
500   */
501   function add(uint256 a, uint256 b) internal pure returns (uint256) {
502     uint256 c = a + b;
503     assert(c >= a);
504     return c;
505   }
506 }