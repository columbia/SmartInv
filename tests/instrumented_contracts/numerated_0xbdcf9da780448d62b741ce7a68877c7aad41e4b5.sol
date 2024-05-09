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
29 contract ECToken is ERC721 {
30 
31   /*** EVENTS ***/
32 
33   /// @dev The Birth event is fired whenever a new person comes into existence.
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
46   string public constant NAME = "EthericCelebrites"; // solhint-disable-line
47   string public constant SYMBOL = "ECToken"; // solhint-disable-line
48 
49   uint256 private startingPrice = 0.001 ether;
50   uint256 private constant PROMO_CREATION_LIMIT = 5000;
51   uint256 private firstStepLimit =  0.05 ether;
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
71   mapping (uint256 => address[]) public personOwnerHistory;
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
108   function ECToken() public {
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
194   function ownerHistoryOf(uint256 _tokenId)
195     public
196     view
197     returns (address[] owner)
198   {
199     return personOwnerHistory[_tokenId];
200   }
201 
202   function payout(address _to) public onlyCLevel {
203     _payout(_to);
204   }
205 
206   // Allows someone to send ether and obtain the token
207   function purchase(uint256 _tokenId) public payable {
208     address oldOwner = personIndexToOwner[_tokenId];
209     address newOwner = msg.sender;
210 
211     uint256 sellingPrice = personIndexToPrice[_tokenId];
212 
213     // Making sure token owner is not sending to self
214     require(oldOwner != newOwner);
215 
216     // Safety check to prevent against an unexpected 0x0 default.
217     require(_addressNotNull(newOwner));
218 
219     // Making sure sent amount is greater than or equal to the sellingPrice
220     require(msg.value >= sellingPrice);
221 
222     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 94), 100));
223     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
224 
225     // Update prices
226     if (sellingPrice < firstStepLimit) {
227       // first stage
228       personIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 94);
229     } else {
230       // second stage
231       personIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 94);
232     }
233 
234     _transfer(oldOwner, newOwner, _tokenId);
235 
236     // Pay previous tokenOwner if owner is not contract
237     if (oldOwner != address(this)) {
238       oldOwner.transfer(payment); //(1-0.06)
239     }
240 
241     TokenSold(_tokenId, sellingPrice, personIndexToPrice[_tokenId], oldOwner, newOwner, persons[_tokenId].name);
242 
243     msg.sender.transfer(purchaseExcess);
244   }
245 
246   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
247     return personIndexToPrice[_tokenId];
248   }
249 
250   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
251   /// @param _newCEO The address of the new CEO
252   function setCEO(address _newCEO) public onlyCEO {
253     require(_newCEO != address(0));
254 
255     ceoAddress = _newCEO;
256   }
257 
258   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
259   /// @param _newCOO The address of the new COO
260   function setCOO(address _newCOO) public onlyCEO {
261     require(_newCOO != address(0));
262 
263     cooAddress = _newCOO;
264   }
265 
266   /// @dev Required for ERC-721 compliance.
267   function symbol() public pure returns (string) {
268     return SYMBOL;
269   }
270 
271   /// @notice Allow pre-approved user to take ownership of a token
272   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
273   /// @dev Required for ERC-721 compliance.
274   function takeOwnership(uint256 _tokenId) public {
275     address newOwner = msg.sender;
276     address oldOwner = personIndexToOwner[_tokenId];
277 
278     // Safety check to prevent against an unexpected 0x0 default.
279     require(_addressNotNull(newOwner));
280 
281     // Making sure transfer is approved
282     require(_approved(newOwner, _tokenId));
283 
284     _transfer(oldOwner, newOwner, _tokenId);
285   }
286 
287   /// @param _owner The owner whose celebrity tokens we are interested in.
288   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
289   ///  expensive (it walks the entire Persons array looking for persons belonging to owner),
290   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
291   ///  not contract-to-contract calls.
292   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
293     uint256 tokenCount = balanceOf(_owner);
294     if (tokenCount == 0) {
295         // Return an empty array
296       return new uint256[](0);
297     } else {
298       uint256[] memory result = new uint256[](tokenCount);
299       uint256 totalPersons = totalSupply();
300       uint256 resultIndex = 0;
301 
302       uint256 personId;
303       for (personId = 0; personId <= totalPersons; personId++) {
304         if (personIndexToOwner[personId] == _owner) {
305           result[resultIndex] = personId;
306           resultIndex++;
307         }
308       }
309       return result;
310     }
311   }
312 
313   /// For querying totalSupply of token
314   /// @dev Required for ERC-721 compliance.
315   function totalSupply() public view returns (uint256 total) {
316     return persons.length;
317   }
318 
319   /// Owner initates the transfer of the token to another account
320   /// @param _to The address for the token to be transferred to.
321   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
322   /// @dev Required for ERC-721 compliance.
323   function transfer(
324     address _to,
325     uint256 _tokenId
326   ) public {
327     require(_owns(msg.sender, _tokenId));
328     require(_addressNotNull(_to));
329 
330     _transfer(msg.sender, _to, _tokenId);
331   }
332 
333   /// Third-party initiates transfer of token from address _from to address _to
334   /// @param _from The address for the token to be transferred from.
335   /// @param _to The address for the token to be transferred to.
336   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
337   /// @dev Required for ERC-721 compliance.
338   function transferFrom(
339     address _from,
340     address _to,
341     uint256 _tokenId
342   ) public {
343     require(_owns(_from, _tokenId));
344     require(_approved(_to, _tokenId));
345     require(_addressNotNull(_to));
346 
347     _transfer(_from, _to, _tokenId);
348   }
349 
350   /*** PRIVATE FUNCTIONS ***/
351   /// Safety check on _to address to prevent against an unexpected 0x0 default.
352   function _addressNotNull(address _to) private pure returns (bool) {
353     return _to != address(0);
354   }
355 
356   /// For checking approval of transfer for address _to
357   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
358     return personIndexToApproved[_tokenId] == _to;
359   }
360 
361   /// For creating Person
362   function _createPerson(string _name, address _owner, uint256 _price) private {
363     Person memory _person = Person({
364       name: _name
365     });
366     uint256 newPersonId = persons.push(_person) - 1;
367 
368     // It's probably never going to happen, 4 billion tokens are A LOT, but
369     // let's just be 100% sure we never let this happen.
370     require(newPersonId == uint256(uint32(newPersonId)));
371 
372     Birth(newPersonId, _name, _owner);
373 
374     personIndexToPrice[newPersonId] = _price;
375 
376     // This will assign ownership, and also emit the Transfer event as
377     // per ERC721 draft
378     _transfer(address(0), _owner, newPersonId);
379   }
380 
381   /// Check for token ownership
382   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
383     return claimant == personIndexToOwner[_tokenId];
384   }
385 
386   /// For paying out balance on contract
387   function _payout(address _to) private {
388     if (_to == address(0)) {
389       ceoAddress.transfer(this.balance);
390     } else {
391       _to.transfer(this.balance);
392     }
393   }
394 
395   /// @dev Assigns ownership of a specific Person to an address.
396   function _transfer(address _from, address _to, uint256 _tokenId) private {
397     // Since the number of persons is capped to 2^32 we can't overflow this
398     ownershipTokenCount[_to]++;
399     //transfer ownership
400     personIndexToOwner[_tokenId] = _to;
401     personOwnerHistory[_tokenId].push(_to);
402 
403     // When creating new persons _from is 0x0, but we can't account that address.
404     if (_from != address(0)) {
405       ownershipTokenCount[_from]--;
406       // clear any previously approved ownership exchange
407       delete personIndexToApproved[_tokenId];
408     }
409 
410     // Emit the transfer event.
411     Transfer(_from, _to, _tokenId);
412   }
413 }
414 library SafeMath {
415 
416   /**
417   * @dev Multiplies two numbers, throws on overflow.
418   */
419   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
420     if (a == 0) {
421       return 0;
422     }
423     uint256 c = a * b;
424     assert(c / a == b);
425     return c;
426   }
427 
428   /**
429   * @dev Integer division of two numbers, truncating the quotient.
430   */
431   function div(uint256 a, uint256 b) internal pure returns (uint256) {
432     // assert(b > 0); // Solidity automatically throws when dividing by 0
433     uint256 c = a / b;
434     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
435     return c;
436   }
437 
438   /**
439   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
440   */
441   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
442     assert(b <= a);
443     return a - b;
444   }
445 
446   /**
447   * @dev Adds two numbers, throws on overflow.
448   */
449   function add(uint256 a, uint256 b) internal pure returns (uint256) {
450     uint256 c = a + b;
451     assert(c >= a);
452     return c;
453   }
454 }