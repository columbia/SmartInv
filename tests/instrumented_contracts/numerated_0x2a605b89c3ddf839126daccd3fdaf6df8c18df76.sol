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
28 contract CryptoSocialMediaToken is ERC721 {
29 
30   // Modified CryptoCelebs contract
31   // Note: "Item" refers to a SocialMedia asset.
32   
33   /*** EVENTS ***/
34 
35   /// @dev The Birth event is fired whenever a new item comes into existence.
36   event Birth(uint256 tokenId, string name, address owner, bytes32 message);
37 
38   /// @dev The TokenSold event is fired whenever a token is sold.
39   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
40 
41   /// @dev Transfer event as defined in current draft of ERC721. 
42   ///  ownership is assigned, including births.
43   event Transfer(address from, address to, uint256 tokenId);
44 
45   /*** CONSTANTS ***/
46 
47   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
48   string public constant NAME = "CryptoSocialMedia"; // solhint-disable-line
49   string public constant SYMBOL = "CryptoSocialMediaToken"; // solhint-disable-line
50 
51   uint256 private startingPrice = 0.001 ether;
52   uint256 private constant PROMO_CREATION_LIMIT = 5000;
53   uint256 private firstStepLimit =  0.053613 ether;
54   uint256 private secondStepLimit = 0.564957 ether;
55 
56   /*** STORAGE ***/
57 
58   /// @dev A mapping from item IDs to the address that owns them. All items have
59   ///  some valid owner address.
60   mapping (uint256 => address) public itemIndexToOwner;
61 
62   // @dev A mapping from owner address to count of tokens that address owns.
63   //  Used internally inside balanceOf() to resolve ownership count.
64   mapping (address => uint256) private ownershipTokenCount;
65 
66   /// @dev A mapping from ItemIDs to an address that has been approved to call
67   ///  transferFrom(). Each item can only have one approved address for transfer
68   ///  at any time. A zero value means no approval is outstanding.
69   mapping (uint256 => address) public itemIndexToApproved;
70 
71   // @dev A mapping from ItemIDs to the price of the token.
72   mapping (uint256 => uint256) private itemIndexToPrice;
73 
74   // The addresses of the accounts (or contracts) that can execute actions within each roles.
75   address public ceoAddress;
76   address public cooAddress;
77 
78   /*** DATATYPES ***/
79   struct Item {
80     string name;
81 	bytes32 message;
82   }
83 
84   Item[] private items;
85 
86   /*** ACCESS MODIFIERS ***/
87   /// @dev Access modifier for CEO-only functionality
88   modifier onlyCEO() {
89     require(msg.sender == ceoAddress);
90     _;
91   }
92 
93   /// @dev Access modifier for COO-only functionality
94   modifier onlyCOO() {
95     require(msg.sender == cooAddress);
96     _;
97   }
98 
99   /// Access modifier for contract owner only functionality
100   modifier onlyCLevel() {
101     require(
102       msg.sender == ceoAddress ||
103       msg.sender == cooAddress
104     );
105     _;
106   }
107 
108   /*** CONSTRUCTOR ***/
109   function CryptoSocialMediaToken() public {
110     ceoAddress = msg.sender;
111     cooAddress = msg.sender;
112 	
113 	createContractItem("4chan", "");
114 	createContractItem("9gag", "");
115 	createContractItem("Discord", "");
116 	createContractItem("Facebook", "");
117 	createContractItem("Google Plus", "");
118 	createContractItem("Instagram", "");
119 	createContractItem("Medium", "");
120 	createContractItem("Periscope", "");
121 	createContractItem("Pinterest", "");
122 	createContractItem("Reddit", "");
123 	createContractItem("Skype", "");
124 	createContractItem("Snapchat", "");
125 	createContractItem("Tumblr", "");
126 	createContractItem("Twitch", "");
127 	createContractItem("Twitter", "");
128 	createContractItem("Wechat", "");
129 	createContractItem("Whatsapp", "");
130 	createContractItem("Youtube", "");
131 	
132   }
133 
134   /*** PUBLIC FUNCTIONS ***/
135   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
136   /// @param _to The address to be granted transfer approval. Pass address(0) to
137   ///  clear all approvals.
138   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
139   /// @dev Required for ERC-721 compliance.
140   function approve(
141     address _to,
142     uint256 _tokenId
143   ) public {
144     // Caller must own token.
145     require(_owns(msg.sender, _tokenId));
146 
147     itemIndexToApproved[_tokenId] = _to;
148 
149     Approval(msg.sender, _to, _tokenId);
150   }
151 
152   /// For querying balance of a particular account
153   /// @param _owner The address for balance query
154   /// @dev Required for ERC-721 compliance.
155   function balanceOf(address _owner) public view returns (uint256 balance) {
156     return ownershipTokenCount[_owner];
157   }
158 
159   /// @dev Creates a new Item with the given name.
160   function createContractItem(string _name, bytes32 _message) public onlyCOO {
161     _createItem(_name, address(this), startingPrice, _message);
162   }
163 
164   /// @notice Returns all the relevant information about a specific item.
165   /// @param _tokenId The tokenId of the item of interest.
166   function getItem(uint256 _tokenId) public view returns (
167     string itemName,
168     uint256 sellingPrice,
169     address owner,
170 	bytes32 itemMessage
171   ) {
172     Item storage item = items[_tokenId];
173     itemName = item.name;
174 	itemMessage = item.message;
175     sellingPrice = itemIndexToPrice[_tokenId];
176     owner = itemIndexToOwner[_tokenId];
177   }
178 
179   function implementsERC721() public pure returns (bool) {
180     return true;
181   }
182 
183   /// @dev Required for ERC-721 compliance.
184   function name() public pure returns (string) {
185     return NAME;
186   }
187 
188   /// For querying owner of token
189   /// @param _tokenId The tokenID for owner inquiry
190   /// @dev Required for ERC-721 compliance.
191   function ownerOf(uint256 _tokenId)
192     public
193     view
194     returns (address owner)
195   {
196     owner = itemIndexToOwner[_tokenId];
197     require(owner != address(0));
198   }
199 
200   function payout(address _to) public onlyCLevel {
201     _payout(_to);
202   }
203 
204   // Allows someone to send ether and obtain the token
205   function purchase(uint256 _tokenId, bytes32 _message) public payable {
206     address oldOwner = itemIndexToOwner[_tokenId];
207     address newOwner = msg.sender;
208 
209     uint256 sellingPrice = itemIndexToPrice[_tokenId];
210 
211     // Making sure token owner is not sending to self
212     require(oldOwner != newOwner);
213 
214     // Safety check to prevent against an unexpected 0x0 default.
215     require(_addressNotNull(newOwner));
216 
217     // Making sure sent amount is greater than or equal to the sellingPrice
218     require(msg.value >= sellingPrice);
219 
220     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 94), 100));
221     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
222 
223     // Update prices
224     if (sellingPrice < firstStepLimit) {
225       // first stage
226       itemIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 94);
227     } else if (sellingPrice < secondStepLimit) {
228       // second stage
229       itemIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 94);
230     } else {
231       // third stage
232       itemIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 94);
233     }
234 
235     _transfer(oldOwner, newOwner, _tokenId);
236 	
237     // Pay previous tokenOwner if owner is not contract
238     if (oldOwner != address(this)) {
239       oldOwner.transfer(payment); //(1-0.06)
240     }
241 
242     TokenSold(_tokenId, sellingPrice, itemIndexToPrice[_tokenId], oldOwner, newOwner, items[_tokenId].name);
243 
244     msg.sender.transfer(purchaseExcess);
245 	
246 	// Update the message of the item 
247 	items[_tokenId].message = _message;
248   }
249 
250   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
251     return itemIndexToPrice[_tokenId];
252   }
253 
254   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
255   /// @param _newCEO The address of the new CEO
256   function setCEO(address _newCEO) public onlyCEO {
257     require(_newCEO != address(0));
258 
259     ceoAddress = _newCEO;
260   }
261 
262   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
263   /// @param _newCOO The address of the new COO
264   function setCOO(address _newCOO) public onlyCEO {
265     require(_newCOO != address(0));
266 
267     cooAddress = _newCOO;
268   }
269 
270   /// @dev Required for ERC-721 compliance.
271   function symbol() public pure returns (string) {
272     return SYMBOL;
273   }
274 
275   /// @notice Allow pre-approved user to take ownership of a token
276   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
277   /// @dev Required for ERC-721 compliance.
278   function takeOwnership(uint256 _tokenId) public {
279     address newOwner = msg.sender;
280     address oldOwner = itemIndexToOwner[_tokenId];
281 
282     // Safety check to prevent against an unexpected 0x0 default.
283     require(_addressNotNull(newOwner));
284 
285     // Making sure transfer is approved
286     require(_approved(newOwner, _tokenId));
287 
288     _transfer(oldOwner, newOwner, _tokenId);
289   }
290 
291   /// @param _owner The owner whose social media tokens we are interested in.
292   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
293   ///  expensive (it walks the entire Items array looking for items belonging to owner),
294   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
295   ///  not contract-to-contract calls.
296   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
297     uint256 tokenCount = balanceOf(_owner);
298     if (tokenCount == 0) {
299         // Return an empty array
300       return new uint256[](0);
301     } else {
302       uint256[] memory result = new uint256[](tokenCount);
303       uint256 totalItems = totalSupply();
304       uint256 resultIndex = 0;
305 
306       uint256 itemId;
307       for (itemId = 0; itemId <= totalItems; itemId++) {
308         if (itemIndexToOwner[itemId] == _owner) {
309           result[resultIndex] = itemId;
310           resultIndex++;
311         }
312       }
313       return result;
314     }
315   }
316 
317   /// For querying totalSupply of token
318   /// @dev Required for ERC-721 compliance.
319   function totalSupply() public view returns (uint256 total) {
320     return items.length;
321   }
322 
323   /// Owner initates the transfer of the token to another account
324   /// @param _to The address for the token to be transferred to.
325   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
326   /// @dev Required for ERC-721 compliance.
327   function transfer(
328     address _to,
329     uint256 _tokenId
330   ) public {
331     require(_owns(msg.sender, _tokenId));
332     require(_addressNotNull(_to));
333 
334     _transfer(msg.sender, _to, _tokenId);
335   }
336 
337   /// Third-party initiates transfer of token from address _from to address _to
338   /// @param _from The address for the token to be transferred from.
339   /// @param _to The address for the token to be transferred to.
340   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
341   /// @dev Required for ERC-721 compliance.
342   function transferFrom(
343     address _from,
344     address _to,
345     uint256 _tokenId
346   ) public {
347     require(_owns(_from, _tokenId));
348     require(_approved(_to, _tokenId));
349     require(_addressNotNull(_to));
350 
351     _transfer(_from, _to, _tokenId);
352   }
353 
354   /*** PRIVATE FUNCTIONS ***/
355   /// Safety check on _to address to prevent against an unexpected 0x0 default.
356   function _addressNotNull(address _to) private pure returns (bool) {
357     return _to != address(0);
358   }
359 
360   /// For checking approval of transfer for address _to
361   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
362     return itemIndexToApproved[_tokenId] == _to;
363   }
364 
365   /// For creating Item
366   function _createItem(string _name, address _owner, uint256 _price, bytes32 _message) private {
367     Item memory _item = Item({
368       name: _name,
369 	  message: _message
370     });
371     uint256 newItemId = items.push(_item) - 1;
372 
373     // It's probably never going to happen, 4 billion tokens are A LOT, but
374     // let's just be 100% sure we never let this happen.
375     require(newItemId == uint256(uint32(newItemId)));
376 
377     Birth(newItemId, _name, _owner, _message);
378 
379     itemIndexToPrice[newItemId] = _price;
380 
381     // This will assign ownership, and also emit the Transfer event as
382     // per ERC721 draft
383     _transfer(address(0), _owner, newItemId);
384   }
385 
386   /// Check for token ownership
387   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
388     return claimant == itemIndexToOwner[_tokenId];
389   }
390 
391   /// For paying out balance on contract
392   function _payout(address _to) private {
393     if (_to == address(0)) {
394       ceoAddress.transfer(this.balance);
395     } else {
396       _to.transfer(this.balance);
397     }
398   }
399 
400   /// @dev Assigns ownership of a specific Item to an address.
401   function _transfer(address _from, address _to, uint256 _tokenId) private {
402     // Since the number of items is capped to 2^32 we can't overflow this
403     ownershipTokenCount[_to]++;
404     //transfer ownership
405     itemIndexToOwner[_tokenId] = _to;
406 
407     // When creating new items _from is 0x0, but we can't account that address.
408     if (_from != address(0)) {
409       ownershipTokenCount[_from]--;
410       // clear any previously approved ownership exchange
411       delete itemIndexToApproved[_tokenId];
412     }
413 
414     // Emit the transfer event.
415     Transfer(_from, _to, _tokenId);
416   }
417 }
418 library SafeMath {
419 
420   /**
421   * @dev Multiplies two numbers, throws on overflow.
422   */
423   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
424     if (a == 0) {
425       return 0;
426     }
427     uint256 c = a * b;
428     assert(c / a == b);
429     return c;
430   }
431 
432   /**
433   * @dev Integer division of two numbers, truncating the quotient.
434   */
435   function div(uint256 a, uint256 b) internal pure returns (uint256) {
436     // assert(b > 0); // Solidity automatically throws when dividing by 0
437     uint256 c = a / b;
438     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
439     return c;
440   }
441 
442   /**
443   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
444   */
445   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
446     assert(b <= a);
447     return a - b;
448   }
449 
450   /**
451   * @dev Adds two numbers, throws on overflow.
452   */
453   function add(uint256 a, uint256 b) internal pure returns (uint256) {
454     uint256 c = a + b;
455     assert(c >= a);
456     return c;
457   }
458 }