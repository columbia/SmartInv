1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 
4 
5 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
6 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
7 contract ERC721 {
8   // Required methods
9   function approve(address _to, uint256 _tokenId) public;
10   function balanceOf(address _owner) public view returns (uint256 balance);
11   function implementsERC721() public pure returns (bool);
12   function ownerOf(uint256 _tokenId) public view returns (address addr);
13   function takeOwnership(uint256 _tokenId) public;
14   function totalSupply() public view returns (uint256 total);
15   function transferFrom(address _from, address _to, uint256 _tokenId) public;
16   function transfer(address _to, uint256 _tokenId) public;
17 
18   event Transfer(address indexed from, address indexed to, uint256 tokenId);
19   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
20 
21   // Optional
22   // function name() public view returns (string name);
23   // function symbol() public view returns (string symbol);
24   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
25   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
26 }
27 
28 
29 contract WhaleToken is ERC721 {
30 
31   /*** EVENTS ***/
32 
33   /// @dev The Birth event is fired whenever a new whale comes into existence.
34   event Birth(uint256 tokenId, string name, address owner);
35 
36   /// @dev The TokenSold event is fired whenever a token is sold.
37   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
38 
39   /// @dev Transfer event as defined in current draft of ERC721. 
40   ///  ownership is assigned, including births.
41   event Transfer(address from, address to, uint256 tokenId);
42 
43   /*** CONSTANTS ***/
44 
45   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
46   string public constant NAME = "CryptoWhale"; // solhint-disable-line
47   string public constant SYMBOL = "WhaleToken"; // solhint-disable-line
48 
49   uint256 private startingPrice = 0.001 ether;
50   uint256 private constant PROMO_CREATION_LIMIT = 5000;
51   uint256 private firstStepLimit =  0.05 ether;
52   uint256 private secondStepLimit = 0.5 ether;
53 
54   /*** STORAGE ***/
55 
56   /// @dev A mapping from whale IDs to the address that owns them. All whales have
57   ///  some valid owner address.
58   mapping (uint256 => address) public whaleIndexToOwner;
59 
60   // @dev A mapping from owner address to count of tokens that address owns.
61   //  Used internally inside balanceOf() to resolve ownership count.
62   mapping (address => uint256) private ownershipTokenCount;
63 
64   /// @dev A mapping from WhaleIDs to an address that has been approved to call
65   ///  transferFrom(). Each Whale can only have one approved address for transfer
66   ///  at any time. A zero value means no approval is outstanding.
67   mapping (uint256 => address) public whaleIndexToApproved;
68 
69   // @dev A mapping from WhaleIDs to the price of the token.
70   mapping (uint256 => uint256) private whaleIndexToPrice;
71 
72   // The addresses of the accounts (or contracts) that can execute actions within each roles.
73   address public ceoAddress;
74   address public cooAddress;
75 
76   uint256 public promoCreatedCount;
77 
78   /*** DATATYPES ***/
79   struct Whale {
80     string name;
81   }
82 
83   Whale[] private whales;
84 
85   /*** ACCESS MODIFIERS ***/
86   /// @dev Access modifier for CEO-only functionality
87   modifier onlyCEO() {
88     require(msg.sender == ceoAddress);
89     _;
90   }
91 
92   /// @dev Access modifier for COO-only functionality
93   modifier onlyCOO() {
94     require(msg.sender == cooAddress);
95     _;
96   }
97 
98   /// Access modifier for contract owner only functionality
99   modifier onlyCLevel() {
100     require(
101       msg.sender == ceoAddress ||
102       msg.sender == cooAddress
103     );
104     _;
105   }
106 
107   /*** CONSTRUCTOR ***/
108   function WhaleToken() public {
109     ceoAddress = msg.sender;
110     cooAddress = msg.sender;
111   }
112 
113   /*** PUBLIC FUNCTIONS ***/
114   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
115   /// @param _to The address to be granted transfer approval. Pass address(0) to
116   ///  clear all approvals.
117   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
118   /// @dev Required for ERC-721 compliance.
119   function approve(
120     address _to,
121     uint256 _tokenId
122   ) public {
123     // Caller must own token.
124     require(_owns(msg.sender, _tokenId));
125 
126     whaleIndexToApproved[_tokenId] = _to;
127 
128     Approval(msg.sender, _to, _tokenId);
129   }
130 
131   /// For querying balance of a particular account
132   /// @param _owner The address for balance query
133   /// @dev Required for ERC-721 compliance.
134   function balanceOf(address _owner) public view returns (uint256 balance) {
135     return ownershipTokenCount[_owner];
136   }
137 
138   /// @dev Creates a new promo Whale with the given name, with given _price and assignes it to an address.
139   function createPromoWhale(address _owner, string _name, uint256 _price) public onlyCOO {
140     require(promoCreatedCount < PROMO_CREATION_LIMIT);
141 
142     address whaleOwner = _owner;
143     if (whaleOwner == address(0)) {
144       whaleOwner = cooAddress;
145     }
146 
147     if (_price <= 0) {
148       _price = startingPrice;
149     }
150 
151     promoCreatedCount++;
152     _createWhale(_name, whaleOwner, _price);
153   }
154 
155   /// @dev Creates a new Whale with the given name.
156   function createContractWhale(string _name) public onlyCOO {
157     _createWhale(_name, address(this), startingPrice);
158   }
159 
160   /// @notice Returns all the relevant information about a specific whale.
161   /// @param _tokenId The tokenId of the whale of interest.
162   function getWhale(uint256 _tokenId) public view returns (
163     uint256 Id,
164     string whaleName,
165     uint256 sellingPrice,
166     address owner
167   ) {
168     Whale storage whale = whales[_tokenId];
169     Id = _tokenId;
170     whaleName = whale.name;
171     sellingPrice = whaleIndexToPrice[_tokenId];
172     owner = whaleIndexToOwner[_tokenId];
173   }
174 
175   function implementsERC721() public pure returns (bool) {
176     return true;
177   }
178 
179   /// @dev Required for ERC-721 compliance.
180   function name() public pure returns (string) {
181     return NAME;
182   }
183 
184   /// For querying owner of token
185   /// @param _tokenId The tokenID for owner inquiry
186   /// @dev Required for ERC-721 compliance.
187   function ownerOf(uint256 _tokenId)
188     public
189     view
190     returns (address owner)
191   {
192     owner = whaleIndexToOwner[_tokenId];
193     require(owner != address(0));
194   }
195 
196   function payout(address _to) public onlyCLevel {
197     _payout(_to);
198   }
199 
200   // Allows someone to send ether and obtain the token
201   function purchase(uint256 _tokenId) public payable {
202     address oldOwner = whaleIndexToOwner[_tokenId];
203     address newOwner = msg.sender;
204 
205     uint256 sellingPrice = whaleIndexToPrice[_tokenId];
206 
207     // Making sure token owner is not sending to self
208     require(oldOwner != newOwner);
209 
210     // Safety check to prevent against an unexpected 0x0 default.
211     require(_addressNotNull(newOwner));
212 
213     // Making sure sent amount is greater than or equal to the sellingPrice
214     require(msg.value >= sellingPrice);
215 
216     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 94), 100));
217     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
218 
219     // Update prices
220     if (sellingPrice < firstStepLimit) {
221       // first stage
222       whaleIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 94);
223     } else if (sellingPrice < secondStepLimit) {
224       // second stage
225       whaleIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 94);
226     } else {
227       // third stage
228       whaleIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 94);
229     }
230 
231     _transfer(oldOwner, newOwner, _tokenId);
232 
233     // Pay previous tokenOwner if owner is not contract
234     if (oldOwner != address(this)) {
235       oldOwner.transfer(payment); //(1-0.06)
236     }
237 
238     TokenSold(_tokenId, sellingPrice, whaleIndexToPrice[_tokenId], oldOwner, newOwner, whales[_tokenId].name);
239 
240     msg.sender.transfer(purchaseExcess);
241   }
242 
243   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
244     return whaleIndexToPrice[_tokenId];
245   }
246 
247   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
248   /// @param _newCEO The address of the new CEO
249   function setCEO(address _newCEO) public onlyCEO {
250     require(_newCEO != address(0));
251 
252     ceoAddress = _newCEO;
253   }
254 
255   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
256   /// @param _newCOO The address of the new COO
257   function setCOO(address _newCOO) public onlyCEO {
258     require(_newCOO != address(0));
259 
260     cooAddress = _newCOO;
261   }
262 
263   /// @dev Required for ERC-721 compliance.
264   function symbol() public pure returns (string) {
265     return SYMBOL;
266   }
267 
268   /// @notice Allow pre-approved user to take ownership of a token
269   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
270   /// @dev Required for ERC-721 compliance.
271   function takeOwnership(uint256 _tokenId) public {
272     address newOwner = msg.sender;
273     address oldOwner = whaleIndexToOwner[_tokenId];
274 
275     // Safety check to prevent against an unexpected 0x0 default.
276     require(_addressNotNull(newOwner));
277 
278     // Making sure transfer is approved
279     require(_approved(newOwner, _tokenId));
280 
281     _transfer(oldOwner, newOwner, _tokenId);
282   }
283 
284   /// @param _owner The owner whose whale tokens we are interested in.
285   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
286   ///  expensive (it walks the entire whales array looking for whales belonging to owner),
287   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
288   ///  not contract-to-contract calls.
289   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
290     uint256 tokenCount = balanceOf(_owner);
291     if (tokenCount == 0) {
292         // Return an empty array
293       return new uint256[](0);
294     } else {
295       uint256[] memory result = new uint256[](tokenCount);
296       uint256 totalWhales = totalSupply();
297       uint256 resultIndex = 0;
298 
299       uint256 whaleId;
300       for (whaleId = 0; whaleId <= totalWhales; whaleId++) {
301         if (whaleIndexToOwner[whaleId] == _owner) {
302           result[resultIndex] = whaleId;
303           resultIndex++;
304         }
305       }
306       return result;
307     }
308   }
309 
310   /// For querying totalSupply of token
311   /// @dev Required for ERC-721 compliance.
312   function totalSupply() public view returns (uint256 total) {
313     return whales.length;
314   }
315 
316   /// Owner initates the transfer of the token to another account
317   /// @param _to The address for the token to be transferred to.
318   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
319   /// @dev Required for ERC-721 compliance.
320   function transfer(
321     address _to,
322     uint256 _tokenId
323   ) public {
324     require(_owns(msg.sender, _tokenId));
325     require(_addressNotNull(_to));
326 
327     _transfer(msg.sender, _to, _tokenId);
328   }
329 
330   /// Third-party initiates transfer of token from address _from to address _to
331   /// @param _from The address for the token to be transferred from.
332   /// @param _to The address for the token to be transferred to.
333   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
334   /// @dev Required for ERC-721 compliance.
335   function transferFrom(
336     address _from,
337     address _to,
338     uint256 _tokenId
339   ) public {
340     require(_owns(_from, _tokenId));
341     require(_approved(_to, _tokenId));
342     require(_addressNotNull(_to));
343 
344     _transfer(_from, _to, _tokenId);
345   }
346 
347   /*** PRIVATE FUNCTIONS ***/
348   /// Safety check on _to address to prevent against an unexpected 0x0 default.
349   function _addressNotNull(address _to) private pure returns (bool) {
350     return _to != address(0);
351   }
352 
353   /// For checking approval of transfer for address _to
354   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
355     return whaleIndexToApproved[_tokenId] == _to;
356   }
357 
358   /// For creating whale
359   function _createWhale(string _name, address _owner, uint256 _price) private {
360     Whale memory _whale = Whale({
361       name: _name
362     });
363     uint256 newWhaleId = whales.push(_whale) - 1;
364 
365     // It's probably never going to happen, 4 billion tokens are A LOT, but
366     // let's just be 100% sure we never let this happen.
367     require(newWhaleId == uint256(uint32(newWhaleId)));
368 
369     Birth(newWhaleId, _name, _owner);
370 
371     whaleIndexToPrice[newWhaleId] = _price;
372 
373     // This will assign ownership, and also emit the Transfer event as
374     // per ERC721 draft
375     _transfer(address(0), _owner, newWhaleId);
376   }
377 
378   /// Check for token ownership
379   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
380     return claimant == whaleIndexToOwner[_tokenId];
381   }
382 
383   /// For paying out balance on contract
384   function _payout(address _to) private {
385     if (_to == address(0)) {
386       ceoAddress.transfer(this.balance);
387     } else {
388       _to.transfer(this.balance);
389     }
390   }
391 
392   /// @dev Assigns ownership of a specific whale to an address.
393   function _transfer(address _from, address _to, uint256 _tokenId) private {
394     // Since the number of whales is capped to 2^32 we can't overflow this
395     ownershipTokenCount[_to]++;
396     //transfer ownership
397     whaleIndexToOwner[_tokenId] = _to;
398 
399     // When creating new whales _from is 0x0, but we can't account that address.
400     if (_from != address(0)) {
401       ownershipTokenCount[_from]--;
402       // clear any previously approved ownership exchange
403       delete whaleIndexToApproved[_tokenId];
404     }
405 
406     // Emit the transfer event.
407     Transfer(_from, _to, _tokenId);
408   }
409 
410 }
411 library SafeMath {
412 
413   /**
414   * @dev Multiplies two numbers, throws on overflow.
415   */
416   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
417     if (a == 0) {
418       return 0;
419     }
420     uint256 c = a * b;
421     assert(c / a == b);
422     return c;
423   }
424 
425   /**
426   * @dev Integer division of two numbers, truncating the quotient.
427   */
428   function div(uint256 a, uint256 b) internal pure returns (uint256) {
429     // assert(b > 0); // Solidity automatically throws when dividing by 0
430     uint256 c = a / b;
431     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
432     return c;
433   }
434 
435   /**
436   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
437   */
438   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
439     assert(b <= a);
440     return a - b;
441   }
442 
443   /**
444   * @dev Adds two numbers, throws on overflow.
445   */
446   function add(uint256 a, uint256 b) internal pure returns (uint256) {
447     uint256 c = a + b;
448     assert(c >= a);
449     return c;
450   }
451 }