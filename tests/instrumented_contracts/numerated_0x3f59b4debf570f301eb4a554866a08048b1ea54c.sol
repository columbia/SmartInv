1 pragma solidity ^0.4.18; // solhint-disable-line
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
28 contract StarzToken is ERC721 {
29 
30   /*** EVENTS ***/
31 
32   /// @dev The Birth event is fired whenever a new person comes into existence.
33   event Birth(uint256 tokenId, string name, address owner);
34 
35   /// @dev The TokenSold event is fired whenever a token is sold.
36   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
37 
38   /// @dev Transfer event as defined in current draft of ERC721. 
39   ///  ownership is assigned, including births.
40   event Transfer(address from, address to, uint256 tokenId);
41 
42   /*** CONSTANTS ***/
43 
44   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
45   string public constant NAME = "CryptoStarz"; // solhint-disable-line
46   string public constant SYMBOL = "StarzToken"; // solhint-disable-line
47 
48   uint256 private startingPrice = 0.01 ether;
49   uint256 private constant PROMO_CREATION_LIMIT = 5000;
50   uint256 private firstStepLimit =  0.99999 ether;
51   uint256 private secondStepLimit = 1.0 ether;
52 
53   /*** STORAGE ***/
54 
55   /// @dev A mapping from person IDs to the address that owns them. All persons have
56   ///  some valid owner address.
57   mapping (uint256 => address) public personIndexToOwner;
58 
59   // @dev A mapping from owner address to count of tokens that address owns.
60   //  Used internally inside balanceOf() to resolve ownership count.
61   mapping (address => uint256) private ownershipTokenCount;
62 
63   /// @dev A mapping from PersonIDs to an address that has been approved to call
64   ///  transferFrom(). Each Person can only have one approved address for transfer
65   ///  at any time. A zero value means no approval is outstanding.
66   mapping (uint256 => address) public personIndexToApproved;
67 
68   // @dev A mapping from PersonIDs to the price of the token.
69   mapping (uint256 => uint256) private personIndexToPrice;
70 
71   // The addresses of the accounts (or contracts) that can execute actions within each roles.
72   address public ceoAddress;
73   address public cooAddress;
74 
75   uint256 public promoCreatedCount;
76 
77   /*** DATATYPES ***/
78   struct Person {
79     string name;
80   }
81 
82   Person[] private persons;
83 
84   /*** ACCESS MODIFIERS ***/
85   /// @dev Access modifier for CEO-only functionality
86   modifier onlyCEO() {
87     require(msg.sender == ceoAddress);
88     _;
89   }
90 
91   /// @dev Access modifier for COO-only functionality
92   modifier onlyCOO() {
93     require(msg.sender == cooAddress);
94     _;
95   }
96 
97   /// Access modifier for contract owner only functionality
98   modifier onlyCLevel() {
99     require(
100       msg.sender == ceoAddress ||
101       msg.sender == cooAddress
102     );
103     _;
104   }
105 
106   /*** CONSTRUCTOR ***/
107   function StarzToken() public {
108     ceoAddress = msg.sender;
109     cooAddress = msg.sender;
110   }
111 
112   /*** PUBLIC FUNCTIONS ***/
113   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
114   /// @param _to The address to be granted transfer approval. Pass address(0) to
115   ///  clear all approvals.
116   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
117   /// @dev Required for ERC-721 compliance.
118   function approve(
119     address _to,
120     uint256 _tokenId
121   ) public {
122     // Caller must own token.
123     require(_owns(msg.sender, _tokenId));
124 
125     personIndexToApproved[_tokenId] = _to;
126 
127     Approval(msg.sender, _to, _tokenId);
128   }
129 
130   /// For querying balance of a particular account
131   /// @param _owner The address for balance query
132   /// @dev Required for ERC-721 compliance.
133   function balanceOf(address _owner) public view returns (uint256 balance) {
134     return ownershipTokenCount[_owner];
135   }
136 
137   /// @dev Creates a new promo Person with the given name, with given _price and assignes it to an address.
138   function createPromoPerson(address _owner, string _name, uint256 _price) public onlyCOO {
139     require(promoCreatedCount < PROMO_CREATION_LIMIT);
140 
141     address personOwner = _owner;
142     if (personOwner == address(0)) {
143       personOwner = cooAddress;
144     }
145 
146     if (_price <= 0) {
147       _price = startingPrice;
148     }
149 
150     promoCreatedCount++;
151     _createPerson(_name, personOwner, _price);
152   }
153 
154   /// @dev Creates a new Person with the given name.
155   function createContractPerson(string _name) public onlyCOO {
156     _createPerson(_name, address(this), startingPrice);
157   }
158 
159   /// @notice Returns all the relevant information about a specific person.
160   /// @param _tokenId The tokenId of the person of interest.
161   function getPerson(uint256 _tokenId) public view returns (
162     string personName,
163     uint256 sellingPrice,
164     address owner
165   ) {
166     Person storage person = persons[_tokenId];
167     personName = person.name;
168     sellingPrice = personIndexToPrice[_tokenId];
169     owner = personIndexToOwner[_tokenId];
170   }
171 
172   function implementsERC721() public pure returns (bool) {
173     return true;
174   }
175 
176   /// @dev Required for ERC-721 compliance.
177   function name() public pure returns (string) {
178     return NAME;
179   }
180 
181   /// For querying owner of token
182   /// @param _tokenId The tokenID for owner inquiry
183   /// @dev Required for ERC-721 compliance.
184   function ownerOf(uint256 _tokenId)
185     public
186     view
187     returns (address owner)
188   {
189     owner = personIndexToOwner[_tokenId];
190     require(owner != address(0));
191   }
192 
193   function payout(address _to) public onlyCLevel {
194     _payout(_to);
195   }
196 
197   // Allows someone to send ether and obtain the token
198   function purchase(uint256 _tokenId) public payable {
199     address oldOwner = personIndexToOwner[_tokenId];
200     address newOwner = msg.sender;
201 
202     uint256 sellingPrice = personIndexToPrice[_tokenId];
203 
204     // Making sure token owner is not sending to self
205     require(oldOwner != newOwner);
206 
207     // Safety check to prevent against an unexpected 0x0 default.
208     require(_addressNotNull(newOwner));
209 
210     // Making sure sent amount is greater than or equal to the sellingPrice
211     require(msg.value >= sellingPrice);
212 
213     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 88), 100));
214     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
215 
216     // Update prices
217     if (sellingPrice < firstStepLimit) {
218       // first stage
219       personIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 88);
220     } else if (sellingPrice < secondStepLimit) {
221       // second stage
222       personIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 118), 88);
223     } else {
224       // third stage
225       personIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 118), 88);
226     }
227 
228     _transfer(oldOwner, newOwner, _tokenId);
229 
230     // Pay previous tokenOwner if owner is not contract
231     if (oldOwner != address(this)) {
232       oldOwner.transfer(payment); //(1-0.06)
233     }
234 
235     TokenSold(_tokenId, sellingPrice, personIndexToPrice[_tokenId], oldOwner, newOwner, persons[_tokenId].name);
236 
237     msg.sender.transfer(purchaseExcess);
238   }
239 
240   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
241     return personIndexToPrice[_tokenId];
242   }
243 
244   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
245   /// @param _newCEO The address of the new CEO
246   function setCEO(address _newCEO) public onlyCEO {
247     require(_newCEO != address(0));
248 
249     ceoAddress = _newCEO;
250   }
251 
252   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
253   /// @param _newCOO The address of the new COO
254   function setCOO(address _newCOO) public onlyCEO {
255     require(_newCOO != address(0));
256 
257     cooAddress = _newCOO;
258   }
259 
260   /// @dev Required for ERC-721 compliance.
261   function symbol() public pure returns (string) {
262     return SYMBOL;
263   }
264 
265   /// @notice Allow pre-approved user to take ownership of a token
266   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
267   /// @dev Required for ERC-721 compliance.
268   function takeOwnership(uint256 _tokenId) public {
269     address newOwner = msg.sender;
270     address oldOwner = personIndexToOwner[_tokenId];
271 
272     // Safety check to prevent against an unexpected 0x0 default.
273     require(_addressNotNull(newOwner));
274 
275     // Making sure transfer is approved
276     require(_approved(newOwner, _tokenId));
277 
278     _transfer(oldOwner, newOwner, _tokenId);
279   }
280 
281   /// @param _owner The owner whose celebrity tokens we are interested in.
282   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
283   ///  expensive (it walks the entire Persons array looking for persons belonging to owner),
284   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
285   ///  not contract-to-contract calls.
286   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
287     uint256 tokenCount = balanceOf(_owner);
288     if (tokenCount == 0) {
289         // Return an empty array
290       return new uint256[](0);
291     } else {
292       uint256[] memory result = new uint256[](tokenCount);
293       uint256 totalPersons = totalSupply();
294       uint256 resultIndex = 0;
295 
296       uint256 personId;
297       for (personId = 0; personId <= totalPersons; personId++) {
298         if (personIndexToOwner[personId] == _owner) {
299           result[resultIndex] = personId;
300           resultIndex++;
301         }
302       }
303       return result;
304     }
305   }
306 
307   /// For querying totalSupply of token
308   /// @dev Required for ERC-721 compliance.
309   function totalSupply() public view returns (uint256 total) {
310     return persons.length;
311   }
312 
313   /// Owner initates the transfer of the token to another account
314   /// @param _to The address for the token to be transferred to.
315   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
316   /// @dev Required for ERC-721 compliance.
317   function transfer(
318     address _to,
319     uint256 _tokenId
320   ) public {
321     require(_owns(msg.sender, _tokenId));
322     require(_addressNotNull(_to));
323 
324     _transfer(msg.sender, _to, _tokenId);
325   }
326 
327   /// Third-party initiates transfer of token from address _from to address _to
328   /// @param _from The address for the token to be transferred from.
329   /// @param _to The address for the token to be transferred to.
330   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
331   /// @dev Required for ERC-721 compliance.
332   function transferFrom(
333     address _from,
334     address _to,
335     uint256 _tokenId
336   ) public {
337     require(_owns(_from, _tokenId));
338     require(_approved(_to, _tokenId));
339     require(_addressNotNull(_to));
340 
341     _transfer(_from, _to, _tokenId);
342   }
343 
344   /*** PRIVATE FUNCTIONS ***/
345   /// Safety check on _to address to prevent against an unexpected 0x0 default.
346   function _addressNotNull(address _to) private pure returns (bool) {
347     return _to != address(0);
348   }
349 
350   /// For checking approval of transfer for address _to
351   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
352     return personIndexToApproved[_tokenId] == _to;
353   }
354 
355   /// For creating Person
356   function _createPerson(string _name, address _owner, uint256 _price) private {
357     Person memory _person = Person({
358       name: _name
359     });
360     uint256 newPersonId = persons.push(_person) - 1;
361 
362     // It's probably never going to happen, 4 billion tokens are A LOT, but
363     // let's just be 100% sure we never let this happen.
364     require(newPersonId == uint256(uint32(newPersonId)));
365 
366     Birth(newPersonId, _name, _owner);
367 
368     personIndexToPrice[newPersonId] = _price;
369 
370     // This will assign ownership, and also emit the Transfer event as
371     // per ERC721 draft
372     _transfer(address(0), _owner, newPersonId);
373   }
374 
375   /// Check for token ownership
376   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
377     return claimant == personIndexToOwner[_tokenId];
378   }
379 
380   /// For paying out balance on contract
381   function _payout(address _to) private {
382     if (_to == address(0)) {
383       ceoAddress.transfer(this.balance);
384     } else {
385       _to.transfer(this.balance);
386     }
387   }
388 
389   /// @dev Assigns ownership of a specific Person to an address.
390   function _transfer(address _from, address _to, uint256 _tokenId) private {
391     // Since the number of persons is capped to 2^32 we can't overflow this
392     ownershipTokenCount[_to]++;
393     //transfer ownership
394     personIndexToOwner[_tokenId] = _to;
395 
396     // When creating new persons _from is 0x0, but we can't account that address.
397     if (_from != address(0)) {
398       ownershipTokenCount[_from]--;
399       // clear any previously approved ownership exchange
400       delete personIndexToApproved[_tokenId];
401     }
402 
403     // Emit the transfer event.
404     Transfer(_from, _to, _tokenId);
405   }
406 }
407 library SafeMath {
408 
409   /**
410   * @dev Multiplies two numbers, throws on overflow.
411   */
412   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
413     if (a == 0) {
414       return 0;
415     }
416     uint256 c = a * b;
417     assert(c / a == b);
418     return c;
419   }
420 
421   /**
422   * @dev Integer division of two numbers, truncating the quotient.
423   */
424   function div(uint256 a, uint256 b) internal pure returns (uint256) {
425     // assert(b > 0); // Solidity automatically throws when dividing by 0
426     uint256 c = a / b;
427     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
428     return c;
429   }
430 
431   /**
432   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
433   */
434   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
435     assert(b <= a);
436     return a - b;
437   }
438 
439   /**
440   * @dev Adds two numbers, throws on overflow.
441   */
442   function add(uint256 a, uint256 b) internal pure returns (uint256) {
443     uint256 c = a + b;
444     assert(c >= a);
445     return c;
446   }
447 }