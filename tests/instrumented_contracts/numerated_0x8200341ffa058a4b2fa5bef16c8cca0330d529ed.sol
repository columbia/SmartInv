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
29 contract CryptocarToken is ERC721 {
30 
31   /*** EVENTS ***/
32 
33   /// @dev The Birth event is fired whenever a new car comes into existence.
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
46   string public constant NAME = "CryptoCars"; // solhint-disable-line
47   string public constant SYMBOL = "CryptocarToken"; // solhint-disable-line
48 
49   uint256 private startingPrice = 0.01 ether;
50   uint256 private constant PROMO_CREATION_LIMIT = 5000;
51   uint256 private firstStepLimit =  0.9999998 ether;
52   uint256 private secondStepLimit = 0.9999999 ether;
53 
54   /*** STORAGE ***/
55 
56   /// @dev A mapping from car IDs to the address that owns them. All cars have
57   ///  some valid owner address.
58   mapping (uint256 => address) public carIndexToOwner;
59 
60   // @dev A mapping from owner address to count of tokens that address owns.
61   //  Used internally inside balanceOf() to resolve ownership count.
62   mapping (address => uint256) private ownershipTokenCount;
63 
64   /// @dev A mapping from CarIDs to an address that has been approved to call
65   ///  transferFrom(). Each Car can only have one approved address for transfer
66   ///  at any time. A zero value means no approval is outstanding.
67   mapping (uint256 => address) public carIndexToApproved;
68 
69   // @dev A mapping from CarIDs to the price of the token.
70   mapping (uint256 => uint256) private carIndexToPrice;
71 
72   // The addresses of the accounts (or contracts) that can execute actions within each roles.
73   address public ceoAddress;
74   address public cooAddress;
75 
76   uint256 public promoCreatedCount;
77 
78   /*** DATATYPES ***/
79   struct Car {
80     string name;
81   }
82 
83   Car[] private cars;
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
108   function CryptocarToken() public {
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
126     carIndexToApproved[_tokenId] = _to;
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
138   /// @dev Creates a new promo Car with the given name, with given _price and assignes it to an address.
139   function createPromoCar(address _owner, string _name, uint256 _price) public onlyCOO {
140     require(promoCreatedCount < PROMO_CREATION_LIMIT);
141 
142     address carOwner = _owner;
143     if (carOwner == address(0)) {
144       carOwner = cooAddress;
145     }
146 
147     if (_price <= 0) {
148       _price = startingPrice;
149     }
150 
151     promoCreatedCount++;
152     _createCar(_name, carOwner, _price);
153   }
154 
155   /// @dev Creates a new Car with the given name.
156   function createContractCar(string _name) public onlyCOO {
157     _createCar(_name, address(this), startingPrice);
158   }
159 
160   /// @notice Returns all the relevant information about a specific car.
161   /// @param _tokenId The tokenId of the car of interest.
162   function getCar(uint256 _tokenId) public view returns (
163     string carName,
164     uint256 sellingPrice,
165     address owner
166   ) {
167     Car storage car = cars[_tokenId];
168     carName = car.name;
169     sellingPrice = carIndexToPrice[_tokenId];
170     owner = carIndexToOwner[_tokenId];
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
190     owner = carIndexToOwner[_tokenId];
191     require(owner != address(0));
192     return owner;
193   }
194 
195   function payout(address _to) public onlyCLevel {
196     _payout(_to);
197   }
198 
199   // Allows someone to send ether and obtain the token
200   function purchase(uint256 _tokenId) public payable {
201     address oldOwner = carIndexToOwner[_tokenId];
202     address newOwner = msg.sender;
203 
204     uint256 sellingPrice = carIndexToPrice[_tokenId];
205 
206     // Making sure token owner is not sending to self
207     require(oldOwner != newOwner);
208 
209     // Safety check to prevent against an unexpected 0x0 default.
210     require(_addressNotNull(newOwner));
211 
212     // Making sure sent amount is greater than or equal to the sellingPrice
213     require(msg.value >= sellingPrice);
214 
215     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 93), 100));
216     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
217 
218     // Update prices
219     if (sellingPrice < firstStepLimit) {
220       // first stage
221       carIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 93);
222     } else if (sellingPrice < secondStepLimit) {
223       // second stage
224       carIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 118), 93);
225     } else {
226       // third stage
227       carIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 118), 93);
228     }
229 
230     _transfer(oldOwner, newOwner, _tokenId);
231 
232     // Pay previous tokenOwner if owner is not contract
233     if (oldOwner != address(this)) {
234       oldOwner.transfer(payment); //(1-0.07)
235     }
236 
237     TokenSold(_tokenId, sellingPrice, carIndexToPrice[_tokenId], oldOwner, newOwner, cars[_tokenId].name);
238 
239     msg.sender.transfer(purchaseExcess);
240   }
241 
242   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
243     return carIndexToPrice[_tokenId];
244   }
245 
246   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
247   /// @param _newCEO The address of the new CEO
248   function setCEO(address _newCEO) public onlyCEO {
249     require(_newCEO != address(0));
250 
251     ceoAddress = _newCEO;
252   }
253 
254   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
255   /// @param _newCOO The address of the new COO
256   function setCOO(address _newCOO) public onlyCEO {
257     require(_newCOO != address(0));
258 
259     cooAddress = _newCOO;
260   }
261 
262   /// @dev Required for ERC-721 compliance.
263   function symbol() public pure returns (string) {
264     return SYMBOL;
265   }
266 
267   /// @notice Allow pre-approved user to take ownership of a token
268   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
269   /// @dev Required for ERC-721 compliance.
270   function takeOwnership(uint256 _tokenId) public {
271     address newOwner = msg.sender;
272     address oldOwner = carIndexToOwner[_tokenId];
273 
274     // Safety check to prevent against an unexpected 0x0 default.
275     require(_addressNotNull(newOwner));
276 
277     // Making sure transfer is approved
278     require(_approved(newOwner, _tokenId));
279 
280     _transfer(oldOwner, newOwner, _tokenId);
281   }
282 
283   /// @param _owner The owner whose supercar tokens we are interested in.
284   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
285   ///  expensive (it walks the entire Cars array looking for cars belonging to owner),
286   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
287   ///  not contract-to-contract calls.
288   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
289     uint256 tokenCount = balanceOf(_owner);
290     if (tokenCount == 0) {
291         // Return an empty array
292       return new uint256[](0);
293     } else {
294       uint256[] memory result = new uint256[](tokenCount);
295       uint256 totalCars = totalSupply();
296       uint256 resultIndex = 0;
297 
298       uint256 carId;
299       for (carId = 0; carId <= totalCars; carId++) {
300         if (carIndexToOwner[carId] == _owner) {
301           result[resultIndex] = carId;
302           resultIndex++;
303         }
304       }
305       return result;
306     }
307   }
308 
309   /// For querying totalSupply of token
310   /// @dev Required for ERC-721 compliance.
311   function totalSupply() public view returns (uint256 total) {
312     return cars.length;
313   }
314 
315   /// Owner initates the transfer of the token to another account
316   /// @param _to The address for the token to be transferred to.
317   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
318   /// @dev Required for ERC-721 compliance.
319   function transfer(
320     address _to,
321     uint256 _tokenId
322   ) public {
323     require(_owns(msg.sender, _tokenId));
324     require(_addressNotNull(_to));
325 
326     _transfer(msg.sender, _to, _tokenId);
327   }
328 
329   /// Third-party initiates transfer of token from address _from to address _to
330   /// @param _from The address for the token to be transferred from.
331   /// @param _to The address for the token to be transferred to.
332   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
333   /// @dev Required for ERC-721 compliance.
334   function transferFrom(
335     address _from,
336     address _to,
337     uint256 _tokenId
338   ) public {
339     require(_owns(_from, _tokenId));
340     require(_approved(_to, _tokenId));
341     require(_addressNotNull(_to));
342 
343     _transfer(_from, _to, _tokenId);
344   }
345 
346   /*** PRIVATE FUNCTIONS ***/
347   /// Safety check on _to address to prevent against an unexpected 0x0 default.
348   function _addressNotNull(address _to) private pure returns (bool) {
349     return _to != address(0);
350   }
351 
352   /// For checking approval of transfer for address _to
353   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
354     return carIndexToApproved[_tokenId] == _to;
355   }
356 
357   /// For creating Car
358   function _createCar(string _name, address _owner, uint256 _price) private {
359     Car memory _car = Car({
360       name: _name
361     });
362     uint256 newCarId = cars.push(_car) - 1;
363 
364     // It's probably never going to happen, 4 billion tokens are A LOT, but
365     // let's just be 100% sure we never let this happen.
366     require(newCarId == uint256(uint32(newCarId)));
367 
368     Birth(newCarId, _name, _owner);
369 
370     carIndexToPrice[newCarId] = _price;
371 
372     // This will assign ownership, and also emit the Transfer event as
373     // per ERC721 draft
374     _transfer(address(0), _owner, newCarId);
375   }
376 
377   /// Check for token ownership
378   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
379     return claimant == carIndexToOwner[_tokenId];
380   }
381 
382   /// For paying out balance on contract
383   function _payout(address _to) private {
384     if (_to == address(0)) {
385       ceoAddress.transfer(this.balance);
386     } else {
387       _to.transfer(this.balance);
388     }
389   }
390 
391   /// @dev Assigns ownership of a specific Car to an address.
392   function _transfer(address _from, address _to, uint256 _tokenId) private {
393     // Since the number of cars is capped to 2^32 we can't overflow this
394     ownershipTokenCount[_to]++;
395     //transfer ownership
396     carIndexToOwner[_tokenId] = _to;
397 
398     // When creating new cars _from is 0x0, but we can't account that address.
399     if (_from != address(0)) {
400       ownershipTokenCount[_from]--;
401       // clear any previously approved ownership exchange
402       delete carIndexToApproved[_tokenId];
403     }
404 
405     // Emit the transfer event.
406     Transfer(_from, _to, _tokenId);
407   }
408 }
409 library SafeMath {
410 
411   /**
412   * @dev Multiplies two numbers, throws on overflow.
413   */
414   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
415     if (a == 0) {
416       return 0;
417     }
418     uint256 c = a * b;
419     assert(c / a == b);
420     return c;
421   }
422 
423   /**
424   * @dev Integer division of two numbers, truncating the quotient.
425   */
426   function div(uint256 a, uint256 b) internal pure returns (uint256) {
427     // assert(b > 0); // Solidity automatically throws when dividing by 0
428     uint256 c = a / b;
429     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
430     return c;
431   }
432 
433   /**
434   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
435   */
436   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
437     assert(b <= a);
438     return a - b;
439   }
440 
441   /**
442   * @dev Adds two numbers, throws on overflow.
443   */
444   function add(uint256 a, uint256 b) internal pure returns (uint256) {
445     uint256 c = a + b;
446     assert(c >= a);
447     return c;
448   }
449 }