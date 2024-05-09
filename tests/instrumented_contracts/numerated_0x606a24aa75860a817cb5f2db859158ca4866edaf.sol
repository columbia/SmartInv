1 pragma solidity ^0.4.19; // solhint-disable-line
2 
3 
4 contract ERC721 {
5   // Required methods
6   function approve(address _to, uint256 _tokenId) public;
7   function balanceOf(address _owner) public view returns (uint256 balance);
8   function implementsERC721() public pure returns (bool);
9   function ownerOf(uint256 _tokenId) public view returns (address addr);
10   function takeOwnership(uint256 _tokenId) public;
11   function totalSupply() public view returns (uint256 total);
12   function transferFrom(address _from, address _to, uint256 _tokenId) public;
13   function transfer(address _to, uint256 _tokenId) public;
14 
15   event Transfer(address indexed from, address indexed to, uint256 tokenId);
16   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
17 }
18 
19 contract CryptoTwitch is ERC721 {
20 
21   /*** EVENTS ***/
22 
23   /// @dev The Birth event is fired whenever a new item comes into existence.
24   event Birth(uint256 tokenId, string name, address owner);
25 
26   /// @dev The TokenSold event is fired whenever a token is sold.
27   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
28 
29   /// @dev Transfer event as defined in current draft of ERC721. 
30   ///  ownership is assigned, including births.
31   event Transfer(address from, address to, uint256 tokenId);
32 
33   /*** CONSTANTS ***/
34 
35   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
36   string public constant NAME = "CryptoTwitch"; // solhint-disable-line
37   string public constant SYMBOL = "Twitch"; // solhint-disable-line
38 
39   uint256 private startingPrice = 0.001 ether;
40   uint256 private constant PROMO_CREATION_LIMIT = 5000;
41   uint256 private firstStepLimit =  0.053613 ether;
42   uint256 private secondStepLimit = 0.564957 ether;
43 
44   /*** STORAGE ***/
45 
46   /// @dev A mapping from item IDs to the address that owns them. All items have
47   ///  some valid owner address.
48   mapping (uint256 => address) public itemIndexToOwner;
49 
50   // @dev A mapping from owner address to count of tokens that address owns.
51   //  Used internally inside balanceOf() to resolve ownership count.
52   mapping (address => uint256) private ownershipTokenCount;
53 
54   /// @dev A mapping from itemIDs to an address that has been approved to call
55   ///  transferFrom(). Each item can only have one approved address for transfer
56   ///  at any time. A zero value means no approval is outstanding.
57   mapping (uint256 => address) public itemIndexToApproved;
58 
59   // @dev A mapping from itemIDs to the price of the token.
60   mapping (uint256 => uint256) private itemIndexToPrice;
61 
62   // The addresses of the accounts (or contracts) that can execute actions within each roles.
63   address public ceoAddress;
64   address public cooAddress;
65 
66   uint256 public promoCreatedCount;
67 
68   /*** DATATYPES ***/
69   struct Item {
70     string name;
71   }
72 
73   Item[] private items;
74 
75   /*** ACCESS MODIFIERS ***/
76   /// @dev Access modifier for CEO-only functionality
77   modifier onlyCEO() {
78     require(msg.sender == ceoAddress);
79     _;
80   }
81 
82   /// @dev Access modifier for COO-only functionality
83   modifier onlyCOO() {
84     require(msg.sender == cooAddress);
85     _;
86   }
87 
88   /// Access modifier for contract owner only functionality
89   modifier onlyCLevel() {
90     require(
91       msg.sender == ceoAddress ||
92       msg.sender == cooAddress
93     );
94     _;
95   }
96 
97   /*** CONSTRUCTOR ***/
98   function CryptoTwitch() public {
99     ceoAddress = msg.sender;
100     cooAddress = msg.sender;
101   }
102 
103   /*** PUBLIC FUNCTIONS ***/
104   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
105   /// @param _to The address to be granted transfer approval. Pass address(0) to
106   ///  clear all approvals.
107   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
108   /// @dev Required for ERC-721 compliance.
109   function approve(
110     address _to,
111     uint256 _tokenId
112   ) public {
113     // Caller must own token.
114     require(_owns(msg.sender, _tokenId));
115 
116     itemIndexToApproved[_tokenId] = _to;
117 
118     Approval(msg.sender, _to, _tokenId);
119   }
120 
121   /// For querying balance of a particular account
122   /// @param _owner The address for balance query
123   /// @dev Required for ERC-721 compliance.
124   function balanceOf(address _owner) public view returns (uint256 balance) {
125     return ownershipTokenCount[_owner];
126   }
127 
128   /// @dev Creates a new promo item with the given name, with given _price and assignes it to an address.
129   function createPromoItem(address _owner, string _name, uint256 _price) public onlyCOO {
130     require(promoCreatedCount < PROMO_CREATION_LIMIT);
131 
132     address itemOwner = _owner;
133     if (itemOwner == address(0)) {
134       itemOwner = cooAddress;
135     }
136 
137     if (_price <= 0) {
138       _price = startingPrice;
139     }
140 
141     promoCreatedCount++;
142     _createItem(_name, itemOwner, _price);
143   }
144 
145   /// @dev Creates a new item with the given name.
146   function createContractItem(string _name) public onlyCOO {
147     _createItem(_name, address(this), startingPrice);
148   }
149 
150   /// @notice Returns all the relevant information about a specific item.
151   /// @param _tokenId The tokenId of the item of interest.
152   function getItem(uint256 _tokenId) public view returns (
153     string itemName,
154     uint256 sellingPrice,
155     address owner
156   ) {
157     Item storage item = items[_tokenId];
158     itemName = item.name;
159     sellingPrice = itemIndexToPrice[_tokenId];
160     owner = itemIndexToOwner[_tokenId];
161   }
162 
163   function implementsERC721() public pure returns (bool) {
164     return true;
165   }
166 
167   /// @dev For ERC-721 compliance.
168   function name() public pure returns (string) {
169     return NAME;
170   }
171 
172   /// For querying owner of token
173   /// @param _tokenId The tokenID for owner inquiry
174   /// @dev Required for ERC-721 compliance.
175   function ownerOf(uint256 _tokenId)
176     public
177     view
178     returns (address owner)
179   {
180     owner = itemIndexToOwner[_tokenId];
181     require(owner != address(0));
182   }
183 
184   function payout(address _to) public onlyCLevel {
185     _payout(_to);
186   }
187 
188   // Allows someone to send ether and obtain the token
189   function purchase(uint256 _tokenId) public payable {
190     address oldOwner = itemIndexToOwner[_tokenId];
191     address newOwner = msg.sender;
192 
193     uint256 sellingPrice = itemIndexToPrice[_tokenId];
194 
195     // Making sure token owner is not sending to self
196     require(oldOwner != newOwner);
197 
198     // Safety check to prevent against an unexpected 0x0 default.
199     require(_addressNotNull(newOwner));
200 
201     // Making sure sent amount is greater than or equal to the sellingPrice
202     require(msg.value >= sellingPrice);
203 
204     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 94), 100));
205     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
206 
207     // Update prices
208     if (sellingPrice < firstStepLimit) {
209       // first stage
210       itemIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 94);
211     } else if (sellingPrice < secondStepLimit) {
212       // second stage
213       itemIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 94);
214     } else {
215       // third stage
216       itemIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 94);
217     }
218 
219     _transfer(oldOwner, newOwner, _tokenId);
220 
221     // Pay previous tokenOwner if owner is not contract
222     if (oldOwner != address(this)) {
223       oldOwner.transfer(payment);
224     }
225 
226     TokenSold(_tokenId, sellingPrice, itemIndexToPrice[_tokenId], oldOwner, newOwner, items[_tokenId].name);
227 
228     msg.sender.transfer(purchaseExcess);
229   }
230 
231   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
232     return itemIndexToPrice[_tokenId];
233   }
234 
235   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
236   /// @param _newCEO The address of the new CEO
237   function setCEO(address _newCEO) public onlyCEO {
238     require(_newCEO != address(0));
239 
240     ceoAddress = _newCEO;
241   }
242 
243   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
244   /// @param _newCOO The address of the new COO
245   function setCOO(address _newCOO) public onlyCEO {
246     require(_newCOO != address(0));
247 
248     cooAddress = _newCOO;
249   }
250 
251   /// @dev For ERC-721 compliance.
252   function symbol() public pure returns (string) {
253     return SYMBOL;
254   }
255 
256   /// @notice Allow pre-approved user to take ownership of a token
257   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
258   /// @dev Required for ERC-721 compliance.
259   function takeOwnership(uint256 _tokenId) public {
260     address newOwner = msg.sender;
261     address oldOwner = itemIndexToOwner[_tokenId];
262 
263     // Safety check to prevent against an unexpected 0x0 default.
264     require(_addressNotNull(newOwner));
265 
266     // Making sure transfer is approved
267     require(_approved(newOwner, _tokenId));
268 
269     _transfer(oldOwner, newOwner, _tokenId);
270   }
271 
272   /// @param _owner The owner whose tokens we are interested in.
273   /// @dev This method MUST NEVER be called by smart contract code. Expensive; walks the entire items array looking for items belonging to owner). Also returns a dynamic array, only supported for web3 calls, not contract-to-contract calls.
274   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
275     uint256 tokenCount = balanceOf(_owner);
276     if (tokenCount == 0) {
277         // Return an empty array
278       return new uint256[](0);
279     } else {
280       uint256[] memory result = new uint256[](tokenCount);
281       uint256 totalitems = totalSupply();
282       uint256 resultIndex = 0;
283 
284       uint256 itemId;
285       for (itemId = 0; itemId <= totalitems; itemId++) {
286         if (itemIndexToOwner[itemId] == _owner) {
287           result[resultIndex] = itemId;
288           resultIndex++;
289         }
290       }
291       return result;
292     }
293   }
294 
295   /// For querying totalSupply of token
296   /// @dev Required for ERC-721 compliance.
297   function totalSupply() public view returns (uint256 total) {
298     return items.length;
299   }
300 
301   /// Owner initates the transfer of the token to another account
302   /// @param _to The address for the token to be transferred to.
303   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
304   /// @dev Required for ERC-721 compliance.
305   function transfer(
306     address _to,
307     uint256 _tokenId
308   ) public {
309     require(_owns(msg.sender, _tokenId));
310     require(_addressNotNull(_to));
311 
312     _transfer(msg.sender, _to, _tokenId);
313   }
314 
315   /// Third-party initiates transfer of token from address _from to address _to
316   /// @param _from The address for the token to be transferred from.
317   /// @param _to The address for the token to be transferred to.
318   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
319   /// @dev Required for ERC-721 compliance.
320   function transferFrom(
321     address _from,
322     address _to,
323     uint256 _tokenId
324   ) public {
325     require(_owns(_from, _tokenId));
326     require(_approved(_to, _tokenId));
327     require(_addressNotNull(_to));
328 
329     _transfer(_from, _to, _tokenId);
330   }
331 
332   /*** PRIVATE FUNCTIONS ***/
333   /// Safety check on _to address to prevent against an unexpected 0x0 default.
334   function _addressNotNull(address _to) private pure returns (bool) {
335     return _to != address(0);
336   }
337 
338   /// For checking approval of transfer for address _to
339   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
340     return itemIndexToApproved[_tokenId] == _to;
341   }
342 
343   /// For creating item
344   function _createItem(string _name, address _owner, uint256 _price) private {
345     Item memory _item = Item({
346       name: _name
347     });
348     uint256 newItemId = items.push(_item) - 1;
349 
350     // It's probably never going to happen, 4 billion tokens are A LOT, but
351     // let's just be 100% sure we never let this happen.
352     require(newItemId == uint256(uint32(newItemId)));
353 
354     Birth(newItemId, _name, _owner);
355 
356     itemIndexToPrice[newItemId] = _price;
357 
358     // This will assign ownership, and also emit the Transfer event as
359     // per ERC721 draft
360     _transfer(address(0), _owner, newItemId);
361   }
362 
363   /// Check for token ownership
364   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
365     return claimant == itemIndexToOwner[_tokenId];
366   }
367 
368   /// For paying out balance on contract
369   function _payout(address _to) private {
370     if (_to == address(0)) {
371       ceoAddress.transfer(this.balance);
372     } else {
373       _to.transfer(this.balance);
374     }
375   }
376 
377   /// @dev Assigns ownership of a specific item to an address.
378   function _transfer(address _from, address _to, uint256 _tokenId) private {
379     // Since the number of items is capped to 2^32 we can't overflow this
380     ownershipTokenCount[_to]++;
381     //transfer ownership
382     itemIndexToOwner[_tokenId] = _to;
383 
384     // When creating new items _from is 0x0, but we can't account that address.
385     if (_from != address(0)) {
386       ownershipTokenCount[_from]--;
387       // clear any previously approved ownership exchange
388       delete itemIndexToApproved[_tokenId];
389     }
390 
391     // Emit the transfer event.
392     Transfer(_from, _to, _tokenId);
393   }
394 }
395 library SafeMath {
396 
397   /**
398   * @dev Multiplies two numbers, throws on overflow.
399   */
400   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
401     if (a == 0) {
402       return 0;
403     }
404     uint256 c = a * b;
405     assert(c / a == b);
406     return c;
407   }
408 
409   /**
410   * @dev Integer division of two numbers, truncating the quotient.
411   */
412   function div(uint256 a, uint256 b) internal pure returns (uint256) {
413     uint256 c = a / b;
414     return c;
415   }
416 
417   /**
418   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
419   */
420   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
421     assert(b <= a);
422     return a - b;
423   }
424 
425   /**
426   * @dev Adds two numbers, throws on overflow.
427   */
428   function add(uint256 a, uint256 b) internal pure returns (uint256) {
429     uint256 c = a + b;
430     assert(c >= a);
431     return c;
432   }
433 }