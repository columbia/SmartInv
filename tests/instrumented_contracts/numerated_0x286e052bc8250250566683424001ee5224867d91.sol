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
29 contract PornstarToken is ERC721 {
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
46   string public constant NAME = "CryptoPornstars"; // solhint-disable-line
47   string public constant SYMBOL = "PornstarToken"; // solhint-disable-line
48 
49   uint256 private startingPrice = 0.001 ether;
50   uint256 private constant PROMO_CREATION_LIMIT = 3000;
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
108   function PornstarToken() public {
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
198   // Allows someone to send ether and obtain the token
199   function purchase(uint256 _tokenId) public payable {
200     address oldOwner = personIndexToOwner[_tokenId];
201     address newOwner = msg.sender;
202 
203     uint256 sellingPrice = personIndexToPrice[_tokenId];
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
214     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 94), 100));
215     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
216 
217     // Update prices
218     if (sellingPrice < firstStepLimit) {
219       // first stage
220       personIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 94);
221     } else if (sellingPrice < secondStepLimit) {
222       // second stage
223       personIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 94);
224     } else {
225       // third stage
226       personIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 94);
227     }
228 
229     _transfer(oldOwner, newOwner, _tokenId);
230 
231     // Pay previous tokenOwner if owner is not contract
232     if (oldOwner != address(this)) {
233       oldOwner.transfer(payment); //(1-0.06)
234     }
235 
236     TokenSold(_tokenId, sellingPrice, personIndexToPrice[_tokenId], oldOwner, newOwner, persons[_tokenId].name);
237 
238     msg.sender.transfer(purchaseExcess);
239   }
240 
241   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
242     return personIndexToPrice[_tokenId];
243   }
244 
245   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
246   /// @param _newCEO The address of the new CEO
247   function setCEO(address _newCEO) public onlyCEO {
248     require(_newCEO != address(0));
249 
250     ceoAddress = _newCEO;
251   }
252 
253   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
254   /// @param _newCOO The address of the new COO
255   function setCOO(address _newCOO) public onlyCEO {
256     require(_newCOO != address(0));
257 
258     cooAddress = _newCOO;
259   }
260 
261   /// @dev Required for ERC-721 compliance.
262   function symbol() public pure returns (string) {
263     return SYMBOL;
264   }
265 
266   /// @notice Allow pre-approved user to take ownership of a token
267   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
268   /// @dev Required for ERC-721 compliance.
269   function takeOwnership(uint256 _tokenId) public {
270     address newOwner = msg.sender;
271     address oldOwner = personIndexToOwner[_tokenId];
272 
273     // Safety check to prevent against an unexpected 0x0 default.
274     require(_addressNotNull(newOwner));
275 
276     // Making sure transfer is approved
277     require(_approved(newOwner, _tokenId));
278 
279     _transfer(oldOwner, newOwner, _tokenId);
280   }
281 
282   /// @param _owner The owner whose celebrity tokens we are interested in.
283   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
284   ///  expensive (it walks the entire Persons array looking for persons belonging to owner),
285   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
286   ///  not contract-to-contract calls.
287   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
288     uint256 tokenCount = balanceOf(_owner);
289     if (tokenCount == 0) {
290         // Return an empty array
291       return new uint256[](0);
292     } else {
293       uint256[] memory result = new uint256[](tokenCount);
294       uint256 totalPersons = totalSupply();
295       uint256 resultIndex = 0;
296 
297       uint256 personId;
298       for (personId = 0; personId <= totalPersons; personId++) {
299         if (personIndexToOwner[personId] == _owner) {
300           result[resultIndex] = personId;
301           resultIndex++;
302         }
303       }
304       return result;
305     }
306   }
307 
308   /// For querying totalSupply of token
309   /// @dev Required for ERC-721 compliance.
310   function totalSupply() public view returns (uint256 total) {
311     return persons.length;
312   }
313 
314   /// Owner initates the transfer of the token to another account
315   /// @param _to The address for the token to be transferred to.
316   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
317   /// @dev Required for ERC-721 compliance.
318   function transfer(
319     address _to,
320     uint256 _tokenId
321   ) public {
322     require(_owns(msg.sender, _tokenId));
323     require(_addressNotNull(_to));
324 
325     _transfer(msg.sender, _to, _tokenId);
326   }
327 
328   /// Third-party initiates transfer of token from address _from to address _to
329   /// @param _from The address for the token to be transferred from.
330   /// @param _to The address for the token to be transferred to.
331   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
332   /// @dev Required for ERC-721 compliance.
333   function transferFrom(
334     address _from,
335     address _to,
336     uint256 _tokenId
337   ) public {
338     require(_owns(_from, _tokenId));
339     require(_approved(_to, _tokenId));
340     require(_addressNotNull(_to));
341 
342     _transfer(_from, _to, _tokenId);
343   }
344 
345   /*** PRIVATE FUNCTIONS ***/
346   /// Safety check on _to address to prevent against an unexpected 0x0 default.
347   function _addressNotNull(address _to) private pure returns (bool) {
348     return _to != address(0);
349   }
350 
351   /// For checking approval of transfer for address _to
352   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
353     return personIndexToApproved[_tokenId] == _to;
354   }
355 
356   /// For creating Person
357   function _createPerson(string _name, address _owner, uint256 _price) private {
358     Person memory _person = Person({
359       name: _name
360     });
361     uint256 newPersonId = persons.push(_person) - 1;
362 
363     // It's probably never going to happen, 4 billion tokens are A LOT, but
364     // let's just be 100% sure we never let this happen.
365     require(newPersonId == uint256(uint32(newPersonId)));
366 
367     Birth(newPersonId, _name, _owner);
368 
369     personIndexToPrice[newPersonId] = _price;
370 
371     // This will assign ownership, and also emit the Transfer event as
372     // per ERC721 draft
373     _transfer(address(0), _owner, newPersonId);
374   }
375 
376   /// Check for token ownership
377   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
378     return claimant == personIndexToOwner[_tokenId];
379   }
380 
381   /// For paying out balance on contract
382   function _payout(address _to) private {
383     if (_to == address(0)) {
384       ceoAddress.transfer(this.balance);
385     } else {
386       _to.transfer(this.balance);
387     }
388   }
389 
390   /// @dev Assigns ownership of a specific Person to an address.
391   function _transfer(address _from, address _to, uint256 _tokenId) private {
392     // Since the number of persons is capped to 2^32 we can't overflow this
393     ownershipTokenCount[_to]++;
394     //transfer ownership
395     personIndexToOwner[_tokenId] = _to;
396 
397     // When creating new persons _from is 0x0, but we can't account that address.
398     if (_from != address(0)) {
399       ownershipTokenCount[_from]--;
400       // clear any previously approved ownership exchange
401       delete personIndexToApproved[_tokenId];
402     }
403 
404     // Emit the transfer event.
405     Transfer(_from, _to, _tokenId);
406   }
407 }
408 library SafeMath {
409 
410   /**
411   * @dev Multiplies two numbers, throws on overflow.
412   */
413   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
414     if (a == 0) {
415       return 0;
416     }
417     uint256 c = a * b;
418     assert(c / a == b);
419     return c;
420   }
421 
422   /**
423   * @dev Integer division of two numbers, truncating the quotient.
424   */
425   function div(uint256 a, uint256 b) internal pure returns (uint256) {
426     // assert(b > 0); // Solidity automatically throws when dividing by 0
427     uint256 c = a / b;
428     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
429     return c;
430   }
431 
432   /**
433   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
434   */
435   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
436     assert(b <= a);
437     return a - b;
438   }
439 
440   /**
441   * @dev Adds two numbers, throws on overflow.
442   */
443   function add(uint256 a, uint256 b) internal pure returns (uint256) {
444     uint256 c = a + b;
445     assert(c >= a);
446     return c;
447   }
448 }