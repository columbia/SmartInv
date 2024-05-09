1 pragma solidity ^0.4.19; // solhint-disable-line
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
18 }
19 
20 contract LandGrabToken is ERC721 {
21 
22   /*** EVENTS ***/
23 
24   /// @dev The Birth event is fired whenever a new city comes into existence.
25   event Birth(uint256 tokenId, string name, address owner);
26 
27   /// @dev The TokenSold event is fired whenever a token is sold.
28   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
29 
30   /// @dev Transfer event as defined in current draft of ERC721. 
31   ///  ownership is assigned, including births.
32   event Transfer(address from, address to, uint256 tokenId);
33 
34   /*** CONSTANTS ***/
35 
36   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
37   string public constant NAME = "LandGrab"; // solhint-disable-line
38   string public constant SYMBOL = "KING"; // solhint-disable-line
39 
40   uint256 private startingPrice = 0.001 ether;
41   uint256 private constant PROMO_CREATION_LIMIT = 5000;
42   uint256 private firstStepLimit =  0.053613 ether;
43   uint256 private secondStepLimit = 0.564957 ether;
44 
45   /*** STORAGE ***/
46 
47   /// @dev A mapping from city IDs to the address that owns them. All citys have
48   ///  some valid owner address.
49   mapping (uint256 => address) public cityIndexToOwner;
50 
51   // @dev A mapping from owner address to count of tokens that address owns.
52   //  Used internally inside balanceOf() to resolve ownership count.
53   mapping (address => uint256) private ownershipTokenCount;
54 
55   /// @dev A mapping from cityIDs to an address that has been approved to call
56   ///  transferFrom(). Each city can only have one approved address for transfer
57   ///  at any time. A zero value means no approval is outstanding.
58   mapping (uint256 => address) public cityIndexToApproved;
59 
60   // @dev A mapping from cityIDs to the price of the token.
61   mapping (uint256 => uint256) private cityIndexToPrice;
62 
63   // The addresses of the accounts (or contracts) that can execute actions within each roles.
64   address public ceoAddress;
65   address public cooAddress;
66 
67   uint256 public promoCreatedCount;
68 
69   /*** DATATYPES ***/
70   struct City {
71     string name;
72   }
73 
74   City[] private citys;
75 
76   /*** ACCESS MODIFIERS ***/
77   /// @dev Access modifier for CEO-only functionality
78   modifier onlyCEO() {
79     require(msg.sender == ceoAddress);
80     _;
81   }
82 
83   /// @dev Access modifier for COO-only functionality
84   modifier onlyCOO() {
85     require(msg.sender == cooAddress);
86     _;
87   }
88 
89   /// Access modifier for contract owner only functionality
90   modifier onlyCLevel() {
91     require(
92       msg.sender == ceoAddress ||
93       msg.sender == cooAddress
94     );
95     _;
96   }
97 
98   /*** CONSTRUCTOR ***/
99   function LandGrabToken() public {
100     ceoAddress = msg.sender;
101     cooAddress = msg.sender;
102   }
103 
104   /*** PUBLIC FUNCTIONS ***/
105   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
106   /// @param _to The address to be granted transfer approval. Pass address(0) to
107   ///  clear all approvals.
108   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
109   /// @dev Required for ERC-721 compliance.
110   function approve(
111     address _to,
112     uint256 _tokenId
113   ) public {
114     // Caller must own token.
115     require(_owns(msg.sender, _tokenId));
116 
117     cityIndexToApproved[_tokenId] = _to;
118 
119     Approval(msg.sender, _to, _tokenId);
120   }
121 
122   /// For querying balance of a particular account
123   /// @param _owner The address for balance query
124   /// @dev Required for ERC-721 compliance.
125   function balanceOf(address _owner) public view returns (uint256 balance) {
126     return ownershipTokenCount[_owner];
127   }
128 
129   /// @dev Creates a new promo city with the given name, with given _price and assignes it to an address.
130   function createPromoCity(address _owner, string _name, uint256 _price) public onlyCOO {
131     require(promoCreatedCount < PROMO_CREATION_LIMIT);
132 
133     address cityOwner = _owner;
134     if (cityOwner == address(0)) {
135       cityOwner = cooAddress;
136     }
137 
138     if (_price <= 0) {
139       _price = startingPrice;
140     }
141 
142     promoCreatedCount++;
143     _createCity(_name, cityOwner, _price);
144   }
145 
146   /// @dev Creates a new city with the given name.
147   function createContractCity(string _name) public onlyCOO {
148     _createCity(_name, address(this), startingPrice);
149   }
150 
151   /// @notice Returns all the relevant information about a specific city.
152   /// @param _tokenId The tokenId of the city of interest.
153   function getCity(uint256 _tokenId) public view returns (
154     string cityName,
155     uint256 sellingPrice,
156     address owner
157   ) {
158     City storage city = citys[_tokenId];
159     cityName = city.name;
160     sellingPrice = cityIndexToPrice[_tokenId];
161     owner = cityIndexToOwner[_tokenId];
162   }
163 
164   function implementsERC721() public pure returns (bool) {
165     return true;
166   }
167 
168   /// @dev For ERC-721 compliance.
169   function name() public pure returns (string) {
170     return NAME;
171   }
172 
173   /// For querying owner of token
174   /// @param _tokenId The tokenID for owner inquiry
175   /// @dev Required for ERC-721 compliance.
176   function ownerOf(uint256 _tokenId)
177     public
178     view
179     returns (address owner)
180   {
181     owner = cityIndexToOwner[_tokenId];
182     require(owner != address(0));
183   }
184 
185   function payout(address _to) public onlyCLevel {
186     _payout(_to);
187   }
188 
189   // Allows someone to send ether and obtain the token
190   function purchase(uint256 _tokenId) public payable {
191     address oldOwner = cityIndexToOwner[_tokenId];
192     address newOwner = msg.sender;
193 
194     uint256 sellingPrice = cityIndexToPrice[_tokenId];
195 
196     // Making sure token owner is not sending to self
197     require(oldOwner != newOwner);
198 
199     // Safety check to prevent against an unexpected 0x0 default.
200     require(_addressNotNull(newOwner));
201 
202     // Making sure sent amount is greater than or equal to the sellingPrice
203     require(msg.value >= sellingPrice);
204 
205     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 94), 100));
206     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
207 
208     // Update prices
209     if (sellingPrice < firstStepLimit) {
210       // first stage
211       cityIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 94);
212     } else if (sellingPrice < secondStepLimit) {
213       // second stage
214       cityIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 94);
215     } else {
216       // third stage
217       cityIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 94);
218     }
219 
220     _transfer(oldOwner, newOwner, _tokenId);
221 
222     // Pay previous tokenOwner if owner is not contract
223     if (oldOwner != address(this)) {
224       oldOwner.transfer(payment);
225     }
226 
227     TokenSold(_tokenId, sellingPrice, cityIndexToPrice[_tokenId], oldOwner, newOwner, citys[_tokenId].name);
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
252   /// @dev For ERC-721 compliance.
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
273   /// @param _owner The owner whose KING tokens we are interested in.
274   /// @dev This method MUST NEVER be called by smart contract code. Expensive; walks the entire citys array looking for citys belonging to owner). Also returns a dynamic array, only supported for web3 calls, not contract-to-contract calls.
275   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
276     uint256 tokenCount = balanceOf(_owner);
277     if (tokenCount == 0) {
278         // Return an empty array
279       return new uint256[](0);
280     } else {
281       uint256[] memory result = new uint256[](tokenCount);
282       uint256 totalcitys = totalSupply();
283       uint256 resultIndex = 0;
284 
285       uint256 cityId;
286       for (cityId = 0; cityId <= totalcitys; cityId++) {
287         if (cityIndexToOwner[cityId] == _owner) {
288           result[resultIndex] = cityId;
289           resultIndex++;
290         }
291       }
292       return result;
293     }
294   }
295 
296   /// For querying totalSupply of token
297   /// @dev Required for ERC-721 compliance.
298   function totalSupply() public view returns (uint256 total) {
299     return citys.length;
300   }
301 
302   /// Owner initates the transfer of the token to another account
303   /// @param _to The address for the token to be transferred to.
304   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
305   /// @dev Required for ERC-721 compliance.
306   function transfer(
307     address _to,
308     uint256 _tokenId
309   ) public {
310     require(_owns(msg.sender, _tokenId));
311     require(_addressNotNull(_to));
312 
313     _transfer(msg.sender, _to, _tokenId);
314   }
315 
316   /// Third-party initiates transfer of token from address _from to address _to
317   /// @param _from The address for the token to be transferred from.
318   /// @param _to The address for the token to be transferred to.
319   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
320   /// @dev Required for ERC-721 compliance.
321   function transferFrom(
322     address _from,
323     address _to,
324     uint256 _tokenId
325   ) public {
326     require(_owns(_from, _tokenId));
327     require(_approved(_to, _tokenId));
328     require(_addressNotNull(_to));
329 
330     _transfer(_from, _to, _tokenId);
331   }
332 
333   /*** PRIVATE FUNCTIONS ***/
334   /// Safety check on _to address to prevent against an unexpected 0x0 default.
335   function _addressNotNull(address _to) private pure returns (bool) {
336     return _to != address(0);
337   }
338 
339   /// For checking approval of transfer for address _to
340   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
341     return cityIndexToApproved[_tokenId] == _to;
342   }
343 
344   /// For creating city
345   function _createCity(string _name, address _owner, uint256 _price) private {
346     City memory _city = City({
347       name: _name
348     });
349     uint256 newCityId = citys.push(_city) - 1;
350 
351     // It's probably never going to happen, 4 billion tokens are A LOT, but
352     // let's just be 100% sure we never let this happen.
353     require(newCityId == uint256(uint32(newCityId)));
354 
355     Birth(newCityId, _name, _owner);
356 
357     cityIndexToPrice[newCityId] = _price;
358 
359     // This will assign ownership, and also emit the Transfer event as
360     // per ERC721 draft
361     _transfer(address(0), _owner, newCityId);
362   }
363 
364   /// Check for token ownership
365   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
366     return claimant == cityIndexToOwner[_tokenId];
367   }
368 
369   /// For paying out balance on contract
370   function _payout(address _to) private {
371     if (_to == address(0)) {
372       ceoAddress.transfer(this.balance);
373     } else {
374       _to.transfer(this.balance);
375     }
376   }
377 
378   /// @dev Assigns ownership of a specific city to an address.
379   function _transfer(address _from, address _to, uint256 _tokenId) private {
380     // Since the number of citys is capped to 2^32 we can't overflow this
381     ownershipTokenCount[_to]++;
382     //transfer ownership
383     cityIndexToOwner[_tokenId] = _to;
384 
385     // When creating new citys _from is 0x0, but we can't account that address.
386     if (_from != address(0)) {
387       ownershipTokenCount[_from]--;
388       // clear any previously approved ownership exchange
389       delete cityIndexToApproved[_tokenId];
390     }
391 
392     // Emit the transfer event.
393     Transfer(_from, _to, _tokenId);
394   }
395 }
396 library SafeMath {
397 
398   /**
399   * @dev Multiplies two numbers, throws on overflow.
400   */
401   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
402     if (a == 0) {
403       return 0;
404     }
405     uint256 c = a * b;
406     assert(c / a == b);
407     return c;
408   }
409 
410   /**
411   * @dev Integer division of two numbers, truncating the quotient.
412   */
413   function div(uint256 a, uint256 b) internal pure returns (uint256) {
414     uint256 c = a / b;
415     return c;
416   }
417 
418   /**
419   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
420   */
421   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
422     assert(b <= a);
423     return a - b;
424   }
425 
426   /**
427   * @dev Adds two numbers, throws on overflow.
428   */
429   function add(uint256 a, uint256 b) internal pure returns (uint256) {
430     uint256 c = a + b;
431     assert(c >= a);
432     return c;
433   }
434 }