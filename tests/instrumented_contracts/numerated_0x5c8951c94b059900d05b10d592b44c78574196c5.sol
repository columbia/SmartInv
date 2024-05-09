1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
4 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
5 contract ERC721 {
6   // Required methods
7   function approve(address _to, uint256 _tokenId) public;
8   function balanceOf(address _owner) public view returns (uint256 balance);
9   function implementsERC721() public pure returns (bool);
10   function ownerOf(uint256 _tokenId) public view returns (address addr);
11   function takeOwnership(uint256 _tokenId) public;
12   function totalSupply() public view returns (uint256 total);
13   function transferFrom(address _from, address _to, uint256 _tokenId) public;
14   function transfer(address _to, uint256 _tokenId) public;
15 
16   event Transfer(address indexed from, address indexed to, uint256 tokenId);
17   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
18 
19   // Optional
20   // function name() public view returns (string name);
21   // function symbol() public view returns (string symbol);
22   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
23   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
24 }
25 
26 
27 contract EtherCityToken is ERC721 {
28 
29   /*** EVENTS ***/
30 
31   /// @dev The CityCreated event is fired whenever a new city comes into existence.
32   event CityCreated(uint256 tokenId, string name, string country, address owner);
33 
34   /// @dev The TokenSold event is fired whenever a token is sold.
35   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name, string country);
36 
37   /// @dev Transfer event as defined in current draft of ERC721.
38   ///  ownership is assigned, including create event.
39   event Transfer(address from, address to, uint256 tokenId);
40 
41   /*** CONSTANTS ***/
42 
43   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
44   string public constant NAME = "EtherCities"; // solhint-disable-line
45   string public constant SYMBOL = "EtherCityToken"; // solhint-disable-line
46 
47   uint256 private startingPrice = 0.001 ether;
48   uint256 private constant PROMO_CREATION_LIMIT = 5000;
49   uint256 private firstStepLimit =  0.005 ether;
50   uint256 private secondStepLimit = 0.055 ether;
51   uint256 private thirdStepLimit = 0.5 ether;
52   uint256 private fourthStepLimit = 10.0 ether;
53 
54   /*** STORAGE ***/
55 
56   /// @dev A mapping from city IDs to the address that owns them. All cities have
57   ///  some valid owner address.
58   mapping (uint256 => address) public cityIndexToOwner;
59 
60   // @dev A mapping from owner address to count of tokens that address owns.
61   //  Used internally inside balanceOf() to resolve ownership count.
62   mapping (address => uint256) private ownershipTokenCount;
63 
64   /// @dev A mapping from CityIDs to an address that has been approved to call
65   ///  transferFrom(). Each City can only have one approved address for transfer
66   ///  at any time. A zero value means no approval is outstanding.
67   mapping (uint256 => address) public cityIndexToApproved;
68 
69   // @dev A mapping from CityIDs to the price of the token.
70   mapping (uint256 => uint256) private cityIndexToPrice;
71 
72   // The addresses of the accounts (or contracts) that can execute actions within each roles.
73   address public ceoAddress;
74   address public cooAddress;
75 
76   uint256 public promoCreatedCount;
77 
78   /*** DATATYPES ***/
79   struct City {
80     string name;
81     string country;
82   }
83 
84   City[] private cities;
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
109   function EtherCityToken() public {
110     ceoAddress = msg.sender;
111     cooAddress = msg.sender;
112   }
113 
114   /*** PUBLIC FUNCTIONS ***/
115   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
116   /// @param _to The address to be granted transfer approval. Pass address(0) to
117   ///  clear all approvals.
118   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
119   /// @dev Required for ERC-721 compliance.
120   function approve(
121     address _to,
122     uint256 _tokenId
123   ) public {
124     // Caller must own token.
125     require(_owns(msg.sender, _tokenId));
126 
127     cityIndexToApproved[_tokenId] = _to;
128 
129     Approval(msg.sender, _to, _tokenId);
130   }
131 
132   /// For querying balance of a particular account
133   /// @param _owner The address for balance query
134   /// @dev Required for ERC-721 compliance.
135   function balanceOf(address _owner) public view returns (uint256 balance) {
136     return ownershipTokenCount[_owner];
137   }
138 
139   /// @dev Creates a new promo City with the given name, country and price and assignes it to an address.
140   function createPromoCity(address _owner, string _name, string _country, uint256 _price) public onlyCOO {
141     require(promoCreatedCount < PROMO_CREATION_LIMIT);
142 
143     address cityOwner = _owner;
144     if (cityOwner == address(0)) {
145       cityOwner = cooAddress;
146     }
147 
148     if (_price <= 0) {
149       _price = startingPrice;
150     }
151 
152     promoCreatedCount++;
153     _createCity(_name, _country, cityOwner, _price);
154   }
155 
156   /// @dev Creates a new City with the given name and country.
157   function createContractCity(string _name, string _country) public onlyCOO {
158     _createCity(_name, _country, address(this), startingPrice);
159   }
160 
161   /// @notice Returns all the relevant information about a specific city.
162   /// @param _tokenId The tokenId of the city of interest.
163   function getCity(uint256 _tokenId) public view returns (
164     string cityName,
165     string country,
166     uint256 sellingPrice,
167     address owner
168   ) {
169     City storage city = cities[_tokenId];
170     cityName = city.name;
171     country = city.country;
172     sellingPrice = cityIndexToPrice[_tokenId];
173     owner = cityIndexToOwner[_tokenId];
174   }
175 
176   function implementsERC721() public pure returns (bool) {
177     return true;
178   }
179 
180   /// @dev Required for ERC-721 compliance.
181   function name() public pure returns (string) {
182     return NAME;
183   }
184 
185   /// For querying owner of token
186   /// @param _tokenId The tokenID for owner inquiry
187   /// @dev Required for ERC-721 compliance.
188   function ownerOf(uint256 _tokenId)
189     public
190     view
191     returns (address owner)
192   {
193     owner = cityIndexToOwner[_tokenId];
194     require(owner != address(0));
195   }
196 
197   function payout(address _to) public onlyCLevel {
198     _payout(_to);
199   }
200 
201   // Allows someone to send ether and obtain the token
202   function purchase(uint256 _tokenId) public payable {
203     address oldOwner = cityIndexToOwner[_tokenId];
204     address newOwner = msg.sender;
205 
206     uint256 sellingPrice = cityIndexToPrice[_tokenId];
207 
208     // Making sure token owner is not sending to self
209     require(oldOwner != newOwner);
210 
211     // Safety check to prevent against an unexpected 0x0 default.
212     require(_addressNotNull(newOwner));
213 
214     // Making sure sent amount is greater than or equal to the sellingPrice
215     require(msg.value >= sellingPrice);
216 
217     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 95), 100));
218     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
219 
220     // Update prices
221     if (sellingPrice < firstStepLimit) {
222       // first stage
223       cityIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 95);
224     } else if (sellingPrice < secondStepLimit) {
225       // second stage
226       cityIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 135), 95);
227     } else if (sellingPrice < thirdStepLimit) {
228       // third stage
229       cityIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 125), 95);
230     } else if (sellingPrice < fourthStepLimit) {
231       // fourth stage
232       cityIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 118), 95);
233     } else {
234       // final stage
235       cityIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 113), 95);
236     }
237 
238     _transfer(oldOwner, newOwner, _tokenId);
239 
240     // Pay previous tokenOwner if owner is not contract
241     if (oldOwner != address(this)) {
242       oldOwner.transfer(payment); //(1-0.05)
243     }
244 
245     TokenSold(_tokenId, sellingPrice, cityIndexToPrice[_tokenId], oldOwner, newOwner, cities[_tokenId].name, cities[_tokenId].country);
246 
247     msg.sender.transfer(purchaseExcess);
248   }
249 
250   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
251     return cityIndexToPrice[_tokenId];
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
280     address oldOwner = cityIndexToOwner[_tokenId];
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
291   /// @param _owner The owner whose city tokens we are interested in.
292   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
293   ///  expensive (it walks the entire Cities array looking for cities belonging to owner),
294   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
295   ///  not contract-to-contract calls.
296   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
297     uint256 tokenCount = balanceOf(_owner);
298     if (tokenCount == 0) {
299         // Return an empty array
300       return new uint256[](0);
301     } else {
302       uint256[] memory result = new uint256[](tokenCount);
303       uint256 totalCities = totalSupply();
304       uint256 resultIndex = 0;
305 
306       uint256 cityId;
307       for (cityId = 0; cityId <= totalCities; cityId++) {
308         if (cityIndexToOwner[cityId] == _owner) {
309           result[resultIndex] = cityId;
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
320     return cities.length;
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
362     return cityIndexToApproved[_tokenId] == _to;
363   }
364 
365   /// For creating City
366   function _createCity(string _name, string _country, address _owner, uint256 _price) private {
367     City memory _city = City({
368       name: _name,
369       country: _country
370     });
371     uint256 newCityId = cities.push(_city) - 1;
372 
373     // It's probably never going to happen, 4 billion tokens are A LOT, but
374     // let's just be 100% sure we never let this happen.
375     require(newCityId == uint256(uint32(newCityId)));
376 
377     CityCreated(newCityId, _name, _country, _owner);
378 
379     cityIndexToPrice[newCityId] = _price;
380 
381     // This will assign ownership, and also emit the Transfer event as
382     // per ERC721 draft
383     _transfer(address(0), _owner, newCityId);
384   }
385 
386   /// Check for token ownership
387   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
388     return claimant == cityIndexToOwner[_tokenId];
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
400   function _withdrawFunds(address _to, uint256 amount) private {
401     require(this.balance >= amount);
402     if (_to == address(0)) {
403       ceoAddress.transfer(amount);
404     } else {
405       _to.transfer(amount);
406     }
407   }
408 
409   /// @dev Assigns ownership of a specific City to an address.
410   function _transfer(address _from, address _to, uint256 _tokenId) private {
411     // Since the number of cities is capped to 2^32 we can't overflow this
412     ownershipTokenCount[_to]++;
413     //transfer ownership
414     cityIndexToOwner[_tokenId] = _to;
415 
416     // When creating new cities _from is 0x0, but we can't account that address.
417     if (_from != address(0)) {
418       ownershipTokenCount[_from]--;
419       // clear any previously approved ownership exchange
420       delete cityIndexToApproved[_tokenId];
421     }
422 
423     // Emit the transfer event.
424     Transfer(_from, _to, _tokenId);
425   }
426 }
427 library SafeMath {
428 
429   /**
430   * @dev Multiplies two numbers, throws on overflow.
431   */
432   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
433     if (a == 0) {
434       return 0;
435     }
436     uint256 c = a * b;
437     assert(c / a == b);
438     return c;
439   }
440 
441   /**
442   * @dev Integer division of two numbers, truncating the quotient.
443   */
444   function div(uint256 a, uint256 b) internal pure returns (uint256) {
445     // assert(b > 0); // Solidity automatically throws when dividing by 0
446     uint256 c = a / b;
447     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
448     return c;
449   }
450 
451   /**
452   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
453   */
454   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
455     assert(b <= a);
456     return a - b;
457   }
458 
459   /**
460   * @dev Adds two numbers, throws on overflow.
461   */
462   function add(uint256 a, uint256 b) internal pure returns (uint256) {
463     uint256 c = a + b;
464     assert(c >= a);
465     return c;
466   }
467 }