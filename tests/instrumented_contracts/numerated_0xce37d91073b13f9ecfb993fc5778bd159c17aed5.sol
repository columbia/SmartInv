1 pragma solidity ^0.4.18;
2 
3 
4 // /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
5 // /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
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
27 library SafeMath {
28  
29   /**
30   * @dev Multiplies two numbers, throws on overflow.
31   */
32   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33     if (a == 0) {
34       return 0;
35     }
36     uint256 c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40  
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return c;
49   }
50  
51   /**
52   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58  
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 a, uint256 b) internal pure returns (uint256) {
63     uint256 c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 contract SuperHeroeToken is ERC721 {
70  
71   /*** EVENTS ***/
72  
73   /// @dev The Birth event is fired whenever a new person comes into existence.
74   event Birth(uint256 tokenId, string name, address owner);
75  
76   /// @dev The TokenSold event is fired whenever a token is sold.
77   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
78  
79   /// @dev Transfer event as defined in current draft of ERC721.
80   ///  ownership is assigned, including births.
81   event Transfer(address from, address to, uint256 tokenId);
82  
83   /*** CONSTANTS ***/
84  
85   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
86   string public constant NAME = "EtherSuperHeroe"; // solhint-disable-line
87   string public constant SYMBOL = "SHT"; // solhint-disable-line
88  
89   uint256 private startingPrice = 0.05 ether;
90   uint256 private constant PROMO_CREATION_LIMIT = 100;
91   uint256 private firstStepLimit =  0.053613 ether;
92   uint256 private secondStepLimit = 0.564957 ether;
93  
94   /*** STORAGE ***/
95  
96   /// @dev A mapping from person IDs to the address that owns them. All persons have
97   ///  some valid owner address.
98   mapping (uint256 => address) public personIndexToOwner;
99  
100   // @dev A mapping from owner address to count of tokens that address owns.
101   //  Used internally inside balanceOf() to resolve ownership count.
102   mapping (address => uint256) private ownershipTokenCount;
103  
104   /// @dev A mapping from PersonIDs to an address that has been approved to call
105   ///  transferFrom(). Each Person can only have one approved address for transfer
106   ///  at any time. A zero value means no approval is outstanding.
107   mapping (uint256 => address) public personIndexToApproved;
108  
109   // @dev A mapping from PersonIDs to the price of the token.
110   mapping (uint256 => uint256) private personIndexToPrice;
111  
112   // The addresses of the accounts (or contracts) that can execute actions within each roles.
113   address public ceoAddress;
114   address public cooAddress;
115  
116   uint256 public promoCreatedCount;
117  
118   /*** DATATYPES ***/
119   struct Person {
120     string name;    
121   }
122  
123   Person[] private persons;
124  
125   /*** ACCESS MODIFIERS ***/
126   /// @dev Access modifier for CEO-only functionality
127   modifier onlyCEO() {
128     require(msg.sender == ceoAddress);
129     _;
130   }
131  
132   /// @dev Access modifier for COO-only functionality
133   modifier onlyCOO() {
134     require(msg.sender == cooAddress);
135     _;
136   }
137  
138   /// Access modifier for contract owner only functionality
139   modifier onlyCLevel() {
140     require(
141       msg.sender == ceoAddress ||
142       msg.sender == cooAddress
143     );
144     _;
145   }
146  
147   /*** CONSTRUCTOR ***/
148   function SuperHeroeToken() public {
149     ceoAddress = msg.sender;
150     cooAddress = msg.sender;
151   }
152  
153   /*** PUBLIC FUNCTIONS ***/
154   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
155   /// @param _to The address to be granted transfer approval. Pass address(0) to
156   ///  clear all approvals.
157   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
158   /// @dev Required for ERC-721 compliance.
159   function approve(
160     address _to,
161     uint256 _tokenId
162   ) public {
163     // Caller must own token.
164     require(_owns(msg.sender, _tokenId));
165  
166     personIndexToApproved[_tokenId] = _to;
167  
168     Approval(msg.sender, _to, _tokenId);
169   }
170  
171   /// For querying balance of a particular account
172   /// @param _owner The address for balance query
173   /// @dev Required for ERC-721 compliance.
174   function balanceOf(address _owner) public view returns (uint256 balance) {
175     return ownershipTokenCount[_owner];
176   }
177 
178   /// @dev Creates a new promo Person with the given name, with given _price and assignes it to an address.
179   function createPromoPerson(address _owner, string _name, uint256 _price) public onlyCOO {
180     require(promoCreatedCount < PROMO_CREATION_LIMIT);
181  
182     address personOwner = _owner;
183     if (personOwner == address(0)) {
184       personOwner = cooAddress;
185     }
186  
187     if (_price <= 0) {
188       _price = startingPrice;
189     }
190  
191     promoCreatedCount++;
192     _createPerson(_name, personOwner, _price);
193   }
194  
195   /// @dev Creates a new Person with the given name.
196   function createContractPerson(string _name, uint256 _price) public onlyCOO {
197     if (_price <= 0) {
198       _price = startingPrice;
199     }    
200     _createPerson(_name, address(this), _price);
201   }
202  
203   /// @notice Returns all the relevant information about a specific person.
204   /// @param _tokenId The tokenId of the person of interest.
205   function getPerson(uint256 _tokenId) public view returns (
206     string personName,
207     uint256 sellingPrice,
208     address owner
209   ) {
210     Person storage person = persons[_tokenId];
211     personName = person.name;
212     sellingPrice = personIndexToPrice[_tokenId];
213     owner = personIndexToOwner[_tokenId];
214   }
215  
216   function implementsERC721() public pure returns (bool) {
217     return true;
218   }
219  
220   /// @dev Required for ERC-721 compliance.
221   function name() public pure returns (string) {
222     return NAME;
223   }
224  
225   /// For querying owner of token
226   /// @param _tokenId The tokenID for owner inquiry
227   /// @dev Required for ERC-721 compliance.
228   function ownerOf(uint256 _tokenId)
229     public
230     view
231     returns (address owner)
232   {
233     owner = personIndexToOwner[_tokenId];
234     require(owner != address(0));
235   }
236  
237   function payout(address _to) public onlyCLevel {
238     _payout(_to);
239   }
240  
241   // Allows someone to send ether and obtain the token
242   function purchase(uint256 _tokenId) public payable {
243     address oldOwner = personIndexToOwner[_tokenId];
244     address newOwner = msg.sender;
245  
246     uint256 sellingPrice = personIndexToPrice[_tokenId];
247  
248     // Making sure token owner is not sending to self
249     require(oldOwner != newOwner);
250  
251     // Safety check to prevent against an unexpected 0x0 default.
252     require(_addressNotNull(newOwner));
253  
254     // Making sure sent amount is greater than or equal to the sellingPrice
255     require(msg.value >= sellingPrice);
256  
257     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 94), 100));
258     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
259  
260     // Update prices
261     if (sellingPrice < firstStepLimit) {
262       // first stage
263       personIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 94);
264     } else if (sellingPrice < secondStepLimit) {
265       // second stage
266       personIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 94);
267     } else {
268       // third stage
269       personIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 94);
270     }
271  
272     _transfer(oldOwner, newOwner, _tokenId);
273  
274     // Pay previous tokenOwner if owner is not contract
275     if (oldOwner != address(this)) {
276       oldOwner.transfer(payment); //(1-0.06)
277     }
278  
279     TokenSold(_tokenId, sellingPrice, personIndexToPrice[_tokenId], oldOwner, newOwner, persons[_tokenId].name);
280  
281     msg.sender.transfer(purchaseExcess);
282   }
283  
284   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
285     return personIndexToPrice[_tokenId];
286   }
287  
288   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
289   /// @param _newCEO The address of the new CEO
290   function setCEO(address _newCEO) public onlyCEO {
291     require(_newCEO != address(0));
292  
293     ceoAddress = _newCEO;
294   }
295  
296   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
297   /// @param _newCOO The address of the new COO
298   function setCOO(address _newCOO) public onlyCEO {
299     require(_newCOO != address(0));
300  
301     cooAddress = _newCOO;
302   }
303  
304   /// @dev Required for ERC-721 compliance.
305   function symbol() public pure returns (string) {
306     return SYMBOL;
307   }
308  
309   /// @notice Allow pre-approved user to take ownership of a token
310   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
311   /// @dev Required for ERC-721 compliance.
312   function takeOwnership(uint256 _tokenId) public {
313     address newOwner = msg.sender;
314     address oldOwner = personIndexToOwner[_tokenId];
315  
316     // Safety check to prevent against an unexpected 0x0 default.
317     require(_addressNotNull(newOwner));
318  
319     // Making sure transfer is approved
320     require(_approved(newOwner, _tokenId));
321  
322     _transfer(oldOwner, newOwner, _tokenId);
323   }
324  
325   /// @param _owner The owner whose space tokens we are interested in.
326   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
327   ///  expensive (it walks the entire Persons array looking for persons belonging to owner),
328   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
329   ///  not contract-to-contract calls.
330   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
331     uint256 tokenCount = balanceOf(_owner);
332     if (tokenCount == 0) {
333         // Return an empty array
334       return new uint256[](0);
335     } else {
336       uint256[] memory result = new uint256[](tokenCount);
337       uint256 totalPersons = totalSupply();
338       uint256 resultIndex = 0;
339  
340       uint256 personId;
341       for (personId = 0; personId <= totalPersons; personId++) {
342         if (personIndexToOwner[personId] == _owner) {
343           result[resultIndex] = personId;
344           resultIndex++;
345         }
346       }
347       return result;
348     }
349   }
350  
351   /// For querying totalSupply of token
352   /// @dev Required for ERC-721 compliance.
353   function totalSupply() public view returns (uint256 total) {
354     return persons.length;
355   }
356  
357   /// Owner initates the transfer of the token to another account
358   /// @param _to The address for the token to be transferred to.
359   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
360   /// @dev Required for ERC-721 compliance.
361   function transfer(
362     address _to,
363     uint256 _tokenId
364   ) public {
365     require(_owns(msg.sender, _tokenId));
366     require(_addressNotNull(_to));
367  
368     _transfer(msg.sender, _to, _tokenId);
369   }
370  
371   /// Third-party initiates transfer of token from address _from to address _to
372   /// @param _from The address for the token to be transferred from.
373   /// @param _to The address for the token to be transferred to.
374   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
375   /// @dev Required for ERC-721 compliance.
376   function transferFrom(
377     address _from,
378     address _to,
379     uint256 _tokenId
380   ) public {
381     require(_owns(_from, _tokenId));
382     require(_approved(_to, _tokenId));
383     require(_addressNotNull(_to));
384  
385     _transfer(_from, _to, _tokenId);
386   }
387  
388   /*** PRIVATE FUNCTIONS ***/
389   /// Safety check on _to address to prevent against an unexpected 0x0 default.
390   function _addressNotNull(address _to) private pure returns (bool) {
391     return _to != address(0);
392   }
393  
394   /// For checking approval of transfer for address _to
395   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
396     return personIndexToApproved[_tokenId] == _to;
397   }
398  
399   /// For creating Person
400   function _createPerson(string _name, address _owner, uint256 _price) private {
401     Person memory _person = Person({
402       name: _name
403     });
404     uint256 newPersonId = persons.push(_person) - 1;
405  
406     // It's probably never going to happen, 4 billion tokens are A LOT, but
407     // let's just be 100% sure we never let this happen.
408     require(newPersonId == uint256(uint32(newPersonId)));
409  
410     Birth(newPersonId, _name, _owner);
411  
412     personIndexToPrice[newPersonId] = _price;
413  
414     // This will assign ownership, and also emit the Transfer event as
415     // per ERC721 draft
416     _transfer(address(0), _owner, newPersonId);
417   }
418  
419   /// Check for token ownership
420   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
421     return claimant == personIndexToOwner[_tokenId];
422   }
423  
424   /// For paying out balance on contract
425   function _payout(address _to) private {
426     if (_to == address(0)) {
427       ceoAddress.transfer(this.balance);
428     } else {
429       _to.transfer(this.balance);
430     }
431   }
432  
433   /// @dev Assigns ownership of a specific Person to an address.
434   function _transfer(address _from, address _to, uint256 _tokenId) private {
435     // Since the number of persons is capped to 2^32 we can't overflow this
436     ownershipTokenCount[_to]++;
437     //transfer ownership
438     personIndexToOwner[_tokenId] = _to;
439  
440     // When creating new persons _from is 0x0, but we can't account that address.
441     if (_from != address(0)) {
442       ownershipTokenCount[_from]--;
443       // clear any previously approved ownership exchange
444       delete personIndexToApproved[_tokenId];
445     }
446  
447     // Emit the transfer event.
448     Transfer(_from, _to, _tokenId);
449   }
450 }