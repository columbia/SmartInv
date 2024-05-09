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
29 contract EtherWords is ERC721 {
30 
31   /*** EVENTS ***/
32 
33   /// @dev The Birth event is fired whenever a new Number comes into existence.
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
46   string public constant NAME = "EtherWords"; // solhint-disable-line
47   string public constant SYMBOL = "WordToken"; // solhint-disable-line
48 
49   uint256 private startingPrice = 0.001 ether;
50   uint256 private constant PROMO_CREATION_LIMIT = 10000;
51   uint256 private firstStepLimit =  0.053613 ether;
52   uint256 private secondStepLimit = 0.564957 ether;
53   uint256 private cooPrice = 50.0 ether;
54 
55   /*** STORAGE ***/
56 
57   /// @dev A mapping from person IDs to the address that owns them. All persons have
58   ///  some valid owner address.
59   mapping (uint256 => address) public personIndexToOwner;
60 
61   // @dev A mapping from owner address to count of tokens that address owns.
62   //  Used internally inside balanceOf() to resolve ownership count.
63   mapping (address => uint256) private ownershipTokenCount;
64 
65   /// @dev A mapping from PersonIDs to an address that has been approved to call
66   ///  transferFrom(). Each Person can only have one approved address for transfer
67   ///  at any time. A zero value means no approval is outstanding.
68   mapping (uint256 => address) public personIndexToApproved;
69 
70   // @dev A mapping from PersonIDs to the price of the token.
71   mapping (uint256 => uint256) private personIndexToPrice;
72 
73   // The addresses of the accounts (or contracts) that can execute actions within each roles.
74   address public ceoAddress;
75   address public cooAddress;
76 
77   uint256 public promoCreatedCount;
78 
79   /*** DATATYPES ***/
80   struct Number {
81     string name;
82   }
83 
84   Number[] private numbers;
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
109   function EtherWords() public {
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
127     personIndexToApproved[_tokenId] = _to;
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
139   /// @dev Creates a new promo Person with the given name, with given _price and assignes it to an address.
140   function createPromoNumber(address _owner, string _name, uint256 _price) public onlyCOO {
141     require(promoCreatedCount < PROMO_CREATION_LIMIT);
142 
143     address personOwner = _owner;
144     if (personOwner == address(0)) {
145       personOwner = cooAddress;
146     }
147 
148     if (_price <= 0) {
149       _price = startingPrice;
150     }
151 
152     promoCreatedCount++;
153     _createPerson(_name, personOwner, _price);
154   }
155 
156   /// @dev Creates a new Person with the given name.
157   function createContractNumber(string _name) public onlyCLevel {
158     _createPerson(_name, address(this), startingPrice);
159   }
160 
161   /// @notice Returns all the relevant information about a specific person.
162   /// @param _tokenId The tokenId of the person of interest.
163   function getNumber(uint256 _tokenId) public view returns (
164     string numberName,
165     uint256 sellingPrice,
166     address owner
167   ) {
168     Number storage number = numbers[_tokenId];
169     numberName = number.name;
170     sellingPrice = personIndexToPrice[_tokenId];
171     owner = personIndexToOwner[_tokenId];
172   }
173 
174   function implementsERC721() public pure returns (bool) {
175     return true;
176   }
177 
178   /// @dev Required for ERC-721 compliance.
179   function name() public pure returns (string) {
180     return NAME;
181   }
182 
183   /// For querying owner of token
184   /// @param _tokenId The tokenID for owner inquiry
185   /// @dev Required for ERC-721 compliance.
186   function ownerOf(uint256 _tokenId)
187     public
188     view
189     returns (address owner)
190   {
191     owner = personIndexToOwner[_tokenId];
192     require(owner != address(0));
193   }
194 
195   function payout(address _to) public onlyCLevel {
196     _payout(_to);
197   }
198 
199   // Allows someone to send ether and obtain the token
200   function purchase(uint256 _tokenId) public payable {
201     address oldOwner = personIndexToOwner[_tokenId];
202     address newOwner = msg.sender;
203 
204     // Making sure token owner is not sending to self
205     require(oldOwner != newOwner);
206 
207     uint256 sellingPrice = personIndexToPrice[_tokenId];
208 
209     // Safety check to prevent against an unexpected 0x0 default.
210     require(_addressNotNull(newOwner));
211 
212     // Making sure sent amount is greater than or equal to the sellingPrice
213     require(msg.value >= sellingPrice);
214 
215     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 92), 100));
216     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
217 
218     // Update prices
219     if (sellingPrice < firstStepLimit) {
220       // first stage
221       personIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 92);
222     } else if (sellingPrice < secondStepLimit) {
223       // second stage
224       personIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 92);
225     } else {
226       // third stage
227       personIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 92);
228     }
229 
230     _transfer(oldOwner, newOwner, _tokenId);
231 
232     // Pay previous tokenOwner if owner is not contract
233     if (oldOwner != address(this)) {
234       oldOwner.transfer(payment); //(1-0.08)
235     }
236 
237     TokenSold(_tokenId, sellingPrice, personIndexToPrice[_tokenId], oldOwner, newOwner, numbers[_tokenId].name);
238 
239     msg.sender.transfer(purchaseExcess);
240     
241     personIndexToPrice[0] = SafeMath.div(SafeMath.mul(personIndexToPrice[0], 101), 100);
242     
243     if (_tokenId == 0) {
244         cooAddress = msg.sender;
245         personIndexToPrice[0] = SafeMath.div(SafeMath.mul(personIndexToPrice[0], 110), 100);
246     }
247   }
248 
249   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
250     return personIndexToPrice[_tokenId];
251   }
252 
253   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
254   /// @param _newCEO The address of the new CEO
255   function setCEO(address _newCEO) public onlyCEO {
256     require(_newCEO != address(0));
257 
258     ceoAddress = _newCEO;
259   }
260 
261   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
262   /// @param _newCOO The address of the new COO
263   function setCOO(address _newCOO) public onlyCEO {
264     require(_newCOO != address(0));
265 
266     cooAddress = _newCOO;
267   }
268   
269   /// @dev creates the genesis word.
270   function genesisCreation() public onlyCEO {
271       if (numbers.length == 0) {
272         _createPerson("EtherWords", address(this), cooPrice);
273       }
274   }
275 
276   /// @dev Required for ERC-721 compliance.
277   function symbol() public pure returns (string) {
278     return SYMBOL;
279   }
280 
281   /// @notice Allow pre-approved user to take ownership of a token
282   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
283   /// @dev Required for ERC-721 compliance.
284   function takeOwnership(uint256 _tokenId) public {
285     address newOwner = msg.sender;
286     address oldOwner = personIndexToOwner[_tokenId];
287 
288     // Safety check to prevent against an unexpected 0x0 default.
289     require(_addressNotNull(newOwner));
290 
291     // Making sure transfer is approved
292     require(_approved(newOwner, _tokenId));
293 
294     _transfer(oldOwner, newOwner, _tokenId);
295   }
296 
297   /// @param _owner The owner whose celebrity tokens we are interested in.
298   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
299   ///  expensive (it walks the entire Persons array looking for persons belonging to owner),
300   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
301   ///  not contract-to-contract calls.
302   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
303     uint256 tokenCount = balanceOf(_owner);
304     if (tokenCount == 0) {
305         // Return an empty array
306       return new uint256[](0);
307     } else {
308       uint256[] memory result = new uint256[](tokenCount);
309       uint256 totalPersons = totalSupply();
310       uint256 resultIndex = 0;
311 
312       uint256 personId;
313       for (personId = 0; personId <= totalPersons; personId++) {
314         if (personIndexToOwner[personId] == _owner) {
315           result[resultIndex] = personId;
316           resultIndex++;
317         }
318       }
319       return result;
320     }
321   }
322 
323   /// For querying totalSupply of token
324   /// @dev Required for ERC-721 compliance.
325   function totalSupply() public view returns (uint256 total) {
326     return numbers.length;
327   }
328 
329   /// Owner initates the transfer of the token to another account
330   /// @param _to The address for the token to be transferred to.
331   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
332   /// @dev Required for ERC-721 compliance.
333   function transfer(
334     address _to,
335     uint256 _tokenId
336   ) public {
337     require(_owns(msg.sender, _tokenId));
338     require(_addressNotNull(_to));
339 
340     _transfer(msg.sender, _to, _tokenId);
341   }
342 
343   /// Third-party initiates transfer of token from address _from to address _to
344   /// @param _from The address for the token to be transferred from.
345   /// @param _to The address for the token to be transferred to.
346   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
347   /// @dev Required for ERC-721 compliance.
348   function transferFrom(
349     address _from,
350     address _to,
351     uint256 _tokenId
352   ) public {
353     require(_owns(_from, _tokenId));
354     require(_approved(_to, _tokenId));
355     require(_addressNotNull(_to));
356 
357     _transfer(_from, _to, _tokenId);
358   }
359 
360   /*** PRIVATE FUNCTIONS ***/
361   /// Safety check on _to address to prevent against an unexpected 0x0 default.
362   function _addressNotNull(address _to) private pure returns (bool) {
363     return _to != address(0);
364   }
365 
366   /// For checking approval of transfer for address _to
367   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
368     return personIndexToApproved[_tokenId] == _to;
369   }
370 
371   /// For creating Person
372   function _createPerson(string _name, address _owner, uint256 _price) private {
373     Number memory _number = Number({
374       name: _name
375     });
376     uint256 newPersonId = numbers.push(_number) - 1;
377 
378     // It's probably never going to happen, 4 billion tokens are A LOT, but
379     // let's just be 100% sure we never let this happen.
380     require(newPersonId == uint256(uint32(newPersonId)));
381 
382     Birth(newPersonId, _name, _owner);
383 
384     personIndexToPrice[newPersonId] = _price;
385 
386     // This will assign ownership, and also emit the Transfer event as
387     // per ERC721 draft
388     _transfer(address(0), _owner, newPersonId);
389   }
390 
391   /// Check for token ownership
392   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
393     return claimant == personIndexToOwner[_tokenId];
394   }
395 
396   /// For paying out balance on contract
397   function _payout(address _to) private {
398     if (_to == address(0)) {
399       ceoAddress.transfer(this.balance);
400     } else {
401       _to.transfer(this.balance);
402     }
403   }
404 
405   /// @dev Assigns ownership of a specific Person to an address.
406   function _transfer(address _from, address _to, uint256 _tokenId) private {
407     // Since the number of persons is capped to 2^32 we can't overflow this
408     ownershipTokenCount[_to]++;
409     //transfer ownership
410     personIndexToOwner[_tokenId] = _to;
411 
412     // When creating new persons _from is 0x0, but we can't account that address.
413     if (_from != address(0)) {
414       ownershipTokenCount[_from]--;
415       // clear any previously approved ownership exchange
416       delete personIndexToApproved[_tokenId];
417     }
418 
419     // Emit the transfer event.
420     Transfer(_from, _to, _tokenId);
421   }
422 }
423 library SafeMath {
424 
425   /**
426   * @dev Multiplies two numbers, throws on overflow.
427   */
428   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
429     if (a == 0) {
430       return 0;
431     }
432     uint256 c = a * b;
433     assert(c / a == b);
434     return c;
435   }
436 
437   /**
438   * @dev Integer division of two numbers, truncating the quotient.
439   */
440   function div(uint256 a, uint256 b) internal pure returns (uint256) {
441     // assert(b > 0); // Solidity automatically throws when dividing by 0
442     uint256 c = a / b;
443     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
444     return c;
445   }
446 
447   /**
448   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
449   */
450   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
451     assert(b <= a);
452     return a - b;
453   }
454 
455   /**
456   * @dev Adds two numbers, throws on overflow.
457   */
458   function add(uint256 a, uint256 b) internal pure returns (uint256) {
459     uint256 c = a + b;
460     assert(c >= a);
461     return c;
462   }
463 }