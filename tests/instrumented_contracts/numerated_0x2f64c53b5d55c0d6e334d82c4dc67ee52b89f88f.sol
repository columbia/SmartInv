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
27 contract CityToken is ERC721 {
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
44   string public constant NAME = "CryptoCities"; // solhint-disable-line
45   string public constant SYMBOL = "CityToken"; // solhint-disable-line
46 
47   uint256 private startingPrice = 0.5 ether;
48 
49   uint256 private constant PROMO_CREATION_LIMIT = 5000;
50 
51   /*** STORAGE ***/
52 
53   /// @dev A mapping from city IDs to the address that owns them. All cities have
54   ///  some valid owner address.
55   mapping (uint256 => address) public cityIndexToOwner;
56 
57   // @dev A mapping from owner address to count of tokens that address owns.
58   //  Used internally inside balanceOf() to resolve ownership count.
59   mapping (address => uint256) private ownershipTokenCount;
60 
61   /// @dev A mapping from CityIDs to an address that has been approved to call
62   ///  transferFrom(). Each City can only have one approved address for transfer
63   ///  at any time. A zero value means no approval is outstanding.
64   mapping (uint256 => address) public cityIndexToApproved;
65 
66   // @dev A mapping from CityIDs to the price of the token.
67   mapping (uint256 => uint256) private cityIndexToPrice;
68 
69   // The addresses of the accounts (or contracts) that can execute actions within each roles.
70   address public ceoAddress;
71   address public cooAddress;
72 
73   uint256 public promoCreatedCount;
74 
75   /*** DATATYPES ***/
76   struct City {
77     string name;
78     string country;
79   }
80 
81   City[] private cities;
82 
83   /*** ACCESS MODIFIERS ***/
84   /// @dev Access modifier for CEO-only functionality
85   modifier onlyCEO() {
86     require(msg.sender == ceoAddress);
87     _;
88   }
89 
90   /// @dev Access modifier for COO-only functionality
91   modifier onlyCOO() {
92     require(msg.sender == cooAddress);
93     _;
94   }
95 
96   /// Access modifier for contract owner only functionality
97   modifier onlyCLevel() {
98     require(
99       msg.sender == ceoAddress ||
100       msg.sender == cooAddress
101     );
102     _;
103   }
104 
105   /*** CONSTRUCTOR ***/
106   function CityToken() public {
107     ceoAddress = msg.sender;
108     cooAddress = msg.sender;
109   }
110 
111   /*** PUBLIC FUNCTIONS ***/
112   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
113   /// @param _to The address to be granted transfer approval. Pass address(0) to
114   ///  clear all approvals.
115   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
116   /// @dev Required for ERC-721 compliance.
117   function approve(
118     address _to,
119     uint256 _tokenId
120   ) public {
121     // Caller must own token.
122     require(_owns(msg.sender, _tokenId));
123 
124     cityIndexToApproved[_tokenId] = _to;
125 
126     Approval(msg.sender, _to, _tokenId);
127   }
128 
129   /// For querying balance of a particular account
130   /// @param _owner The address for balance query
131   /// @dev Required for ERC-721 compliance.
132   function balanceOf(address _owner) public view returns (uint256 balance) {
133     return ownershipTokenCount[_owner];
134   }
135 
136   /// @dev Creates a new promo City with the given name, country and price and assignes it to an address.
137   function createPromoCity(address _owner, string _name, string _country, uint256 _price) public onlyCOO {
138     require(promoCreatedCount < PROMO_CREATION_LIMIT);
139 
140     address cityOwner = _owner;
141     if (cityOwner == address(0)) {
142       cityOwner = cooAddress;
143     }
144     
145     if (_price <= 0) {
146       _price = startingPrice;
147     }
148 
149     promoCreatedCount++;
150     _createCity(_name, _country, cityOwner, _price);
151   }
152 
153   /// @dev Creates a new City with the given name and country.
154   function createContractCity(string _name, string _country) public onlyCOO {
155     _createCity(_name, _country, address(this), startingPrice);
156   }
157 
158   /// @notice Returns all the relevant information about a specific city.
159   /// @param _tokenId The tokenId of the city of interest.
160   function getCity(uint256 _tokenId) public view returns (
161     string cityName,
162     string country,
163     uint256 sellingPrice,
164     address owner
165   ) {
166     City storage city = cities[_tokenId];
167     cityName = city.name;
168     country = city.country;
169     sellingPrice = cityIndexToPrice[_tokenId];
170     owner = cityIndexToOwner[_tokenId];
171   }
172 
173   function implementsERC721() public pure returns (bool) {
174     return true;
175   }
176 
177   /// @dev Required for ERC-721 compliance.
178   function name() public pure returns (string) {
179     return NAME;
180   }
181 
182   /// For querying owner of token
183   /// @param _tokenId The tokenID for owner inquiry
184   /// @dev Required for ERC-721 compliance.
185   function ownerOf(uint256 _tokenId)
186     public
187     view
188     returns (address owner)
189   {
190     owner = cityIndexToOwner[_tokenId];
191     require(owner != address(0));
192   }
193 
194   function payout(address _to) public onlyCLevel {
195     _payout(_to);
196   }
197 
198   // Allows someone to send ether and obtain the token
199   function purchase(uint256 _tokenId) public payable {
200     address oldOwner = cityIndexToOwner[_tokenId];
201     address newOwner = msg.sender;
202 
203     uint256 sellingPrice = cityIndexToPrice[_tokenId];
204 
205     // Making sure token owner is not sending to self
206     require(oldOwner != newOwner);
207 
208     // Safety check to prevent against an unexpected 0x0 default.
209     require(_addressNotNull(newOwner));
210 
211     // Making sure sent amount is greater than or equal to the sellingPrice
212     require(msg.value >= sellingPrice);
213 
214     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 90), 100));
215     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
216 
217     // Update price (25% increase)
218     cityIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 125), 90);
219     
220     _transfer(oldOwner, newOwner, _tokenId);
221 
222     // Pay previous tokenOwner if owner is not contract
223     if (oldOwner != address(this)) {
224       oldOwner.transfer(payment); //(1-0.10)
225     }
226 
227     TokenSold(_tokenId, sellingPrice, cityIndexToPrice[_tokenId], oldOwner, newOwner, cities[_tokenId].name, cities[_tokenId].country);
228 
229     msg.sender.transfer(purchaseExcess);
230   }
231 
232   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
233     return cityIndexToPrice[_tokenId];
234   }
235 
236   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
237   /// @param _newCEO The address of the new CEO
238   function setCEO(address _newCEO) public onlyCEO {
239     require(_newCEO != address(0));
240 
241     ceoAddress = _newCEO;
242   }
243 
244   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
245   /// @param _newCOO The address of the new COO
246   function setCOO(address _newCOO) public onlyCEO {
247     require(_newCOO != address(0));
248 
249     cooAddress = _newCOO;
250   }
251 
252   /// @dev Required for ERC-721 compliance.
253   function symbol() public pure returns (string) {
254     return SYMBOL;
255   }
256 
257   /// @notice Allow pre-approved user to take ownership of a token
258   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
259   /// @dev Required for ERC-721 compliance.
260   function takeOwnership(uint256 _tokenId) public {
261     address newOwner = msg.sender;
262     address oldOwner = cityIndexToOwner[_tokenId];
263 
264     // Safety check to prevent against an unexpected 0x0 default.
265     require(_addressNotNull(newOwner));
266 
267     // Making sure transfer is approved
268     require(_approved(newOwner, _tokenId));
269 
270     _transfer(oldOwner, newOwner, _tokenId);
271   }
272 
273   /// @param _owner The owner whose city tokens we are interested in.
274   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
275   ///  expensive (it walks the entire Cities array looking for cities belonging to owner),
276   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
277   ///  not contract-to-contract calls.
278   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
279     uint256 tokenCount = balanceOf(_owner);
280     if (tokenCount == 0) {
281         // Return an empty array
282       return new uint256[](0);
283     } else {
284       uint256[] memory result = new uint256[](tokenCount);
285       uint256 totalCities = totalSupply();
286       uint256 resultIndex = 0;
287 
288       uint256 cityId;
289       for (cityId = 0; cityId <= totalCities; cityId++) {
290         if (cityIndexToOwner[cityId] == _owner) {
291           result[resultIndex] = cityId;
292           resultIndex++;
293         }
294       }
295       return result;
296     }
297   }
298 
299   /// For querying totalSupply of token
300   /// @dev Required for ERC-721 compliance.
301   function totalSupply() public view returns (uint256 total) {
302     return cities.length;
303   }
304 
305   /// Owner initates the transfer of the token to another account
306   /// @param _to The address for the token to be transferred to.
307   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
308   /// @dev Required for ERC-721 compliance.
309   function transfer(
310     address _to,
311     uint256 _tokenId
312   ) public {
313     require(_owns(msg.sender, _tokenId));
314     require(_addressNotNull(_to));
315 
316     _transfer(msg.sender, _to, _tokenId);
317   }
318 
319   /// Third-party initiates transfer of token from address _from to address _to
320   /// @param _from The address for the token to be transferred from.
321   /// @param _to The address for the token to be transferred to.
322   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
323   /// @dev Required for ERC-721 compliance.
324   function transferFrom(
325     address _from,
326     address _to,
327     uint256 _tokenId
328   ) public {
329     require(_owns(_from, _tokenId));
330     require(_approved(_to, _tokenId));
331     require(_addressNotNull(_to));
332 
333     _transfer(_from, _to, _tokenId);
334   }
335 
336   /*** PRIVATE FUNCTIONS ***/
337   /// Safety check on _to address to prevent against an unexpected 0x0 default.
338   function _addressNotNull(address _to) private pure returns (bool) {
339     return _to != address(0);
340   }
341 
342   /// For checking approval of transfer for address _to
343   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
344     return cityIndexToApproved[_tokenId] == _to;
345   }
346 
347   /// For creating City
348   function _createCity(string _name, string _country, address _owner, uint256 _price) private {
349     City memory _city = City({
350       name: _name,
351       country: _country
352     });
353     uint256 newCityId = cities.push(_city) - 1;
354 
355     // It's probably never going to happen, 4 billion tokens are A LOT, but
356     // let's just be 100% sure we never let this happen.
357     require(newCityId == uint256(uint32(newCityId)));
358 
359     CityCreated(newCityId, _name, _country, _owner);
360 
361     cityIndexToPrice[newCityId] = _price;
362 
363     // This will assign ownership, and also emit the Transfer event as
364     // per ERC721 draft
365     _transfer(address(0), _owner, newCityId);
366   }
367 
368   /// Check for token ownership
369   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
370     return claimant == cityIndexToOwner[_tokenId];
371   }
372 
373   /// For paying out balance on contract
374   function _payout(address _to) private {
375     if (_to == address(0)) {
376       ceoAddress.transfer(this.balance);
377     } else {
378       _to.transfer(this.balance);
379     }
380   }
381 
382   /// @dev Assigns ownership of a specific City to an address.
383   function _transfer(address _from, address _to, uint256 _tokenId) private {
384     // Since the number of cities is capped to 2^32 we can't overflow this
385     ownershipTokenCount[_to]++;
386     //transfer ownership
387     cityIndexToOwner[_tokenId] = _to;
388 
389     // When creating new cities _from is 0x0, but we can't account that address.
390     if (_from != address(0)) {
391       ownershipTokenCount[_from]--;
392       // clear any previously approved ownership exchange
393       delete cityIndexToApproved[_tokenId];
394     }
395 
396     // Emit the transfer event.
397     Transfer(_from, _to, _tokenId);
398   }
399 }
400 library SafeMath {
401 
402   /**
403   * @dev Multiplies two numbers, throws on overflow.
404   */
405   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
406     if (a == 0) {
407       return 0;
408     }
409     uint256 c = a * b;
410     assert(c / a == b);
411     return c;
412   }
413 
414   /**
415   * @dev Integer division of two numbers, truncating the quotient.
416   */
417   function div(uint256 a, uint256 b) internal pure returns (uint256) {
418     // assert(b > 0); // Solidity automatically throws when dividing by 0
419     uint256 c = a / b;
420     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
421     return c;
422   }
423 
424   /**
425   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
426   */
427   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
428     assert(b <= a);
429     return a - b;
430   }
431 
432   /**
433   * @dev Adds two numbers, throws on overflow.
434   */
435   function add(uint256 a, uint256 b) internal pure returns (uint256) {
436     uint256 c = a + b;
437     assert(c >= a);
438     return c;
439   }
440 }