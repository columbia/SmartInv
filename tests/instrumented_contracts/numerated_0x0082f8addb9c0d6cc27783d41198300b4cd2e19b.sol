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
26 contract CryptoCelebrity is ERC721 {
27 
28   /*** EVENTS ***/
29 
30   /// @dev The Birth event is fired whenever a new person comes into existence.
31   event Birth(uint256 tokenId, string name, address owner);
32 
33   /// @dev The TokenSold event is fired whenever a token is sold.
34   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
35 
36   // @dev The PriceChange event is fired whenever a token's price has change.
37   event PriceChange(uint256 tokenId, uint256 oldPrice, uint256 newPrice, string name);
38   
39   /// @dev Transfer event as defined in current draft of ERC721. 
40   ///  ownership is assigned, including births.
41   event Transfer(address from, address to, uint256 tokenId);
42 
43   /*** CONSTANTS ***/
44 
45   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
46   string public constant NAME = "CryptoCelebrity"; // solhint-disable-line
47   string public constant SYMBOL = "CCT"; // solhint-disable-line
48 
49   uint256 private startingPrice = 0.001 ether;
50   uint256 private constant PROMO_CREATION_LIMIT = 100000;
51   uint256 private firstStepLimit =  0.053613 ether;
52   uint256 private secondStepLimit = 0.564957 ether;
53 
54   /*** STORAGE ***/
55 
56   /// @dev A mapping from person IDs to the address that owns them. All persons have
57   ///  some valid owner address.
58   mapping (uint256 => address) public personIndexToOwner;
59 
60   // @dev A mapping from owner address to count of tokens that address owns.
61   //  Used internally inside balanceOf() to resolve ownership count.
62   mapping (address => uint256) private ownershipTokenCount;
63 
64   /// @dev A mapping from PersonIDs to an address that has been approved to call
65   ///  transferFrom(). Each Person can only have one approved address for transfer
66   ///  at any time. A zero value means no approval is outstanding.
67   mapping (uint256 => address) public personIndexToApproved;
68 
69   // @dev A mapping from PersonIDs to the price of the token.
70   mapping (uint256 => uint256) private personIndexToPrice;
71 
72   // The addresses of the accounts (or contracts) that can execute actions within each roles.
73   address public ceoAddress;
74   address public cooAddress;
75 
76   uint256 public promoCreatedCount;
77 
78   /*** DATATYPES ***/
79   struct Person {
80     string name;
81   }
82 
83   Person[] private persons;
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
108   function CryptoCelebrity() public {
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
126     personIndexToApproved[_tokenId] = _to;
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
138   /// @dev Creates a new promo Person with the given name, with given _price and assignes it to an address.
139   function createPromoPerson(address _owner, string _name, uint256 _price) public onlyCOO {
140     require(promoCreatedCount < PROMO_CREATION_LIMIT);
141 
142     address personOwner = _owner;
143     if (personOwner == address(0)) {
144       personOwner = cooAddress;
145     }
146 
147     if (_price <= 0) {
148       _price = startingPrice;
149     }
150 
151     promoCreatedCount++;
152     _createPerson(_name, personOwner, _price);
153   }
154 
155   /// @dev Creates a new Person with the given name.
156   function createContractPerson(string _name) public onlyCOO {
157     _createPerson(_name, address(this), startingPrice);
158   }
159 
160   /// @notice Returns all the relevant information about a specific person.
161   /// @param _tokenId The tokenId of the person of interest.
162   function getPerson(uint256 _tokenId) public view returns (
163     string personName,
164     uint256 sellingPrice,
165     address owner
166   ) {
167     Person storage person = persons[_tokenId];
168     personName = person.name;
169     sellingPrice = personIndexToPrice[_tokenId];
170     owner = personIndexToOwner[_tokenId];
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
190     owner = personIndexToOwner[_tokenId];
191     require(owner != address(0));
192   }
193 
194   function payout(address _to) public onlyCLevel {
195     _payout(_to);
196   }
197 
198   function withdrawAmountTo (uint256 _amount, address _to) public onlyCLevel {
199     _to.transfer(_amount);
200   }
201 
202   // Allows someone to send ether and obtain the token
203   function purchase(uint256 _tokenId) public payable {
204     address oldOwner = personIndexToOwner[_tokenId];
205     address newOwner = msg.sender;
206 
207     uint256 sellingPrice = personIndexToPrice[_tokenId];
208 
209     // Making sure token owner is not sending to self
210     require(oldOwner != newOwner);
211 
212     // Safety check to prevent against an unexpected 0x0 default.
213     require(_addressNotNull(newOwner));
214 
215     // Making sure sent amount is greater than or equal to the sellingPrice
216     require(msg.value >= sellingPrice);
217 
218     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 90), 100));
219     uint256 fee = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 99), 1000));
220     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
221 
222     // Update prices
223     if (sellingPrice < firstStepLimit) {
224       // first stage
225       personIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 94);
226     } else if (sellingPrice < secondStepLimit) {
227       // second stage
228       personIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 94);
229     } else {
230       // third stage
231       personIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 94);
232     }
233 
234     _transfer(oldOwner, newOwner, _tokenId);
235 
236     // Pay previous tokenOwner if owner is not contract
237     if (oldOwner != address(this)) {
238       oldOwner.transfer(payment); //(1-0.10)
239       ceoAddress.transfer(fee); //0.099
240     }
241 
242     TokenSold(_tokenId, sellingPrice, personIndexToPrice[_tokenId], oldOwner, newOwner, persons[_tokenId].name);
243 
244     msg.sender.transfer(purchaseExcess);
245   }
246 
247   /// @notice Allow the owner of the token change the price of the person.
248   /// @param _tokenId The ID of the Token.
249   /// @param newPrice New price of the token
250   function changePrice(uint256 _tokenId, uint256 newPrice) public {
251     require(_owns(msg.sender, _tokenId));
252     uint256 oldPrice = personIndexToPrice[_tokenId];
253     uint256 maxPrice = uint256(SafeMath.mul(oldPrice, 5));
254     uint256 minPrice = startingPrice;
255     require (minPrice < newPrice && newPrice < maxPrice);
256     // Update prices
257     personIndexToPrice[_tokenId] = newPrice;
258     PriceChange(_tokenId, oldPrice, newPrice, persons[_tokenId].name);
259   }
260 
261   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
262     return personIndexToPrice[_tokenId];
263   }
264 
265   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
266   /// @param _newCEO The address of the new CEO
267   function setCEO(address _newCEO) public onlyCEO {
268     require(_newCEO != address(0));
269 
270     ceoAddress = _newCEO;
271   }
272 
273   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
274   /// @param _newCOO The address of the new COO
275   function setCOO(address _newCOO) public onlyCEO {
276     require(_newCOO != address(0));
277 
278     cooAddress = _newCOO;
279   }
280 
281   /// @dev Required for ERC-721 compliance.
282   function symbol() public pure returns (string) {
283     return SYMBOL;
284   }
285 
286   /// @notice Allow pre-approved user to take ownership of a token
287   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
288   /// @dev Required for ERC-721 compliance.
289   function takeOwnership(uint256 _tokenId) public {
290     address newOwner = msg.sender;
291     address oldOwner = personIndexToOwner[_tokenId];
292 
293     // Safety check to prevent against an unexpected 0x0 default.
294     require(_addressNotNull(newOwner));
295 
296     // Making sure transfer is approved
297     require(_approved(newOwner, _tokenId));
298 
299     _transfer(oldOwner, newOwner, _tokenId);
300   }
301 
302   /// @param _owner The owner whose celebrity tokens we are interested in.
303   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
304   ///  expensive (it walks the entire Persons array looking for persons belonging to owner),
305   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
306   ///  not contract-to-contract calls.
307   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
308     uint256 tokenCount = balanceOf(_owner);
309     if (tokenCount == 0) {
310         // Return an empty array
311       return new uint256[](0);
312     } else {
313       uint256[] memory result = new uint256[](tokenCount);
314       uint256 totalPersons = totalSupply();
315       uint256 resultIndex = 0;
316 
317       uint256 personId;
318       for (personId = 0; personId <= totalPersons; personId++) {
319         if (personIndexToOwner[personId] == _owner) {
320           result[resultIndex] = personId;
321           resultIndex++;
322         }
323       }
324       return result;
325     }
326   }
327 
328   /// For querying totalSupply of token
329   /// @dev Required for ERC-721 compliance.
330   function totalSupply() public view returns (uint256 total) {
331     return persons.length;
332   }
333 
334   /// Owner initates the transfer of the token to another account
335   /// @param _to The address for the token to be transferred to.
336   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
337   /// @dev Required for ERC-721 compliance.
338   function transfer(
339     address _to,
340     uint256 _tokenId
341   ) public {
342     require(_owns(msg.sender, _tokenId));
343     require(_addressNotNull(_to));
344 
345     _transfer(msg.sender, _to, _tokenId);
346   }
347 
348   /// Third-party initiates transfer of token from address _from to address _to
349   /// @param _from The address for the token to be transferred from.
350   /// @param _to The address for the token to be transferred to.
351   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
352   /// @dev Required for ERC-721 compliance.
353   function transferFrom(
354     address _from,
355     address _to,
356     uint256 _tokenId
357   ) public {
358     require(_owns(_from, _tokenId));
359     require(_approved(_to, _tokenId));
360     require(_addressNotNull(_to));
361 
362     _transfer(_from, _to, _tokenId);
363   }
364 
365   /*** PRIVATE FUNCTIONS ***/
366   /// Safety check on _to address to prevent against an unexpected 0x0 default.
367   function _addressNotNull(address _to) private pure returns (bool) {
368     return _to != address(0);
369   }
370 
371   /// For checking approval of transfer for address _to
372   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
373     return personIndexToApproved[_tokenId] == _to;
374   }
375 
376   /// For creating Person
377   function _createPerson(string _name, address _owner, uint256 _price) private {
378     Person memory _person = Person({
379       name: _name
380     });
381     uint256 newPersonId = persons.push(_person) - 1;
382 
383     // It's probably never going to happen, 4 billion tokens are A LOT, but
384     // let's just be 100% sure we never let this happen.
385     require(newPersonId == uint256(uint32(newPersonId)));
386 
387     Birth(newPersonId, _name, _owner);
388 
389     personIndexToPrice[newPersonId] = _price;
390 
391     // This will assign ownership, and also emit the Transfer event as
392     // per ERC721 draft
393     _transfer(address(0), _owner, newPersonId);
394   }
395 
396   /// Check for token ownership
397   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
398     return claimant == personIndexToOwner[_tokenId];
399   }
400 
401   /// For paying out balance on contract
402   function _payout(address _to) private {
403     if (_to == address(0)) {
404       ceoAddress.transfer(this.balance);
405     } else {
406       _to.transfer(this.balance);
407     }
408   }
409 
410   /// @dev Assigns ownership of a specific Person to an address.
411   function _transfer(address _from, address _to, uint256 _tokenId) private {
412     // Since the number of persons is capped to 2^32 we can't overflow this
413     ownershipTokenCount[_to]++;
414     //transfer ownership
415     personIndexToOwner[_tokenId] = _to;
416 
417     // When creating new persons _from is 0x0, but we can't account that address.
418     if (_from != address(0)) {
419       ownershipTokenCount[_from]--;
420       // clear any previously approved ownership exchange
421       delete personIndexToApproved[_tokenId];
422     }
423 
424     // Emit the transfer event.
425     Transfer(_from, _to, _tokenId);
426   }
427 }
428 library SafeMath {
429 
430   /**
431   * @dev Multiplies two numbers, throws on overflow.
432   */
433   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
434     if (a == 0) {
435       return 0;
436     }
437     uint256 c = a * b;
438     assert(c / a == b);
439     return c;
440   }
441 
442   /**
443   * @dev Integer division of two numbers, truncating the quotient.
444   */
445   function div(uint256 a, uint256 b) internal pure returns (uint256) {
446     // assert(b > 0); // Solidity automatically throws when dividing by 0
447     uint256 c = a / b;
448     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
449     return c;
450   }
451 
452   /**
453   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
454   */
455   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
456     assert(b <= a);
457     return a - b;
458   }
459 
460   /**
461   * @dev Adds two numbers, throws on overflow.
462   */
463   function add(uint256 a, uint256 b) internal pure returns (uint256) {
464     uint256 c = a + b;
465     assert(c >= a);
466     return c;
467   }
468 }