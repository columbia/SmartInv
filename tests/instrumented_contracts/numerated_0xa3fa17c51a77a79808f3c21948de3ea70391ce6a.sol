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
21 }
22 
23 contract CryptoAllStars is ERC721 {
24 
25   /*** EVENTS ***/
26 
27   /// @dev The Birth event is fired whenever a new person comes into existence.
28   event Birth(uint256 tokenId, string name, address owner);
29 
30   /// @dev The TokenSold event is fired whenever a token is sold.
31   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
32 
33   /// @dev Transfer event as defined in current draft of ERC721. 
34   ///  ownership is assigned, including births.
35   event Transfer(address from, address to, uint256 tokenId);
36 
37   /*** CONSTANTS ***/
38 
39   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
40   string public constant NAME = "CryptoAllStars"; // solhint-disable-line
41   string public constant SYMBOL = "AllStarToken"; // solhint-disable-line
42 
43   uint256 private startingPrice = 0.001 ether;
44   uint256 private constant PROMO_CREATION_LIMIT = 5000;
45   uint256 private firstStepLimit =  0.053613 ether;
46   uint256 private secondStepLimit = 0.564957 ether;
47 
48   /*** STORAGE ***/
49 
50   /// @dev A mapping from person IDs to the address that owns them. All persons have
51   ///  some valid owner address.
52   mapping (uint256 => address) public personIndexToOwner;
53 
54   // @dev A mapping from owner address to count of tokens that address owns.
55   //  Used internally inside balanceOf() to resolve ownership count.
56   mapping (address => uint256) private ownershipTokenCount;
57 
58   /// @dev A mapping from PersonIDs to an address that has been approved to call
59   ///  transferFrom(). Each Person can only have one approved address for transfer
60   ///  at any time. A zero value means no approval is outstanding.
61   mapping (uint256 => address) public personIndexToApproved;
62 
63   // @dev A mapping from PersonIDs to the price of the token.
64   mapping (uint256 => uint256) private personIndexToPrice;
65 
66   // The addresses of the accounts (or contracts) that can execute actions within each roles.
67   address public ceo = 0x047F606fD5b2BaA5f5C6c4aB8958E45CB6B054B7;
68 
69   uint256 public promoCreatedCount;
70 
71   /*** DATATYPES ***/
72   struct Person {
73     string name;
74   }
75 
76   Person[] private persons;
77 
78   /*** ACCESS MODIFIERS ***/
79   /// @dev Access modifier for owner only functionality
80   modifier onlyCeo() {
81     require(msg.sender == ceo);
82     _;
83   }
84 
85  
86   /*** CONSTRUCTOR ***/
87   // function CryptoAllStars() public {
88   //   owner = msg.sender;
89   // }
90 
91   /*** PUBLIC FUNCTIONS ***/
92   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
93   /// @param _to The address to be granted transfer approval. Pass address(0) to
94   ///  clear all approvals.
95   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
96   /// @dev Required for ERC-721 compliance.
97   function approve(
98     address _to,
99     uint256 _tokenId
100   ) public {
101     // Caller must own token.
102     require(_owns(msg.sender, _tokenId));
103 
104     personIndexToApproved[_tokenId] = _to;
105 
106     Approval(msg.sender, _to, _tokenId);
107   }
108 
109   /// For querying balance of a particular account
110   /// @param _owner The address for balance query
111   /// @dev Required for ERC-721 compliance.
112   function balanceOf(address _owner) public view returns (uint256 balance) {
113     return ownershipTokenCount[_owner];
114   }
115 
116   /// @dev Creates a new promo Person with the given name, with given _price and assignes it to an address.
117   function createPromoPerson(address _owner, string _name, uint256 _price) public onlyCeo {
118     require(promoCreatedCount < PROMO_CREATION_LIMIT);
119 
120     address personOwner = _owner;
121     if (personOwner == address(0)) {
122       personOwner = ceo;
123     }
124 
125     if (_price <= 0) {
126       _price = startingPrice;
127     }
128 
129     promoCreatedCount++;
130     _createPerson(_name, personOwner, _price);
131   }
132 
133   /// @dev Creates a new Person with the given name.
134   function createContractPerson(string _name) public onlyCeo {
135     _createPerson(_name, address(this), startingPrice);
136   }
137 
138   /// @notice Returns all the relevant information about a specific person.
139   /// @param _tokenId The tokenId of the person of interest.
140   function getPerson(uint256 _tokenId) public view returns (
141     string personName,
142     uint256 sellingPrice,
143     address owner
144   ) {
145     Person storage person = persons[_tokenId];
146     personName = person.name;
147     sellingPrice = personIndexToPrice[_tokenId];
148     owner = personIndexToOwner[_tokenId];
149   }
150 
151   function implementsERC721() public pure returns (bool) {
152     return true;
153   }
154 
155   /// @dev Required for ERC-721 compliance.
156   function name() public pure returns (string) {
157     return NAME;
158   }
159 
160   /// For querying owner of token
161   /// @param _tokenId The tokenID for owner inquiry
162   /// @dev Required for ERC-721 compliance.
163   function ownerOf(uint256 _tokenId)
164     public
165     view
166     returns (address owner)
167   {
168     owner = personIndexToOwner[_tokenId];
169     require(owner != address(0));
170   }
171 
172   function payout(address _to) public onlyCeo {
173     _payout(_to);
174   }
175 
176   // Allows someone to send ether and obtain the token
177   function purchase(uint256 _tokenId) public payable {
178     address oldOwner = personIndexToOwner[_tokenId];
179     address newOwner = msg.sender;
180 
181     uint256 sellingPrice = personIndexToPrice[_tokenId];
182 
183     // Making sure token owner is not sending to self
184     require(oldOwner != newOwner);
185 
186     // Safety check to prevent against an unexpected 0x0 default.
187     require(_addressNotNull(newOwner));
188 
189     // Making sure sent amount is greater than or equal to the sellingPrice
190     require(msg.value >= sellingPrice);
191 
192     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 94), 100));
193     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
194 
195     // Update prices
196     if (sellingPrice < firstStepLimit) {
197       // first stage
198       personIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 94);
199     } else if (sellingPrice < secondStepLimit) {
200       // second stage
201       personIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 94);
202     } else {
203       // third stage
204       personIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 94);
205     }
206 
207     _transfer(oldOwner, newOwner, _tokenId);
208 
209     // Pay previous tokenOwner if owner is not contract
210     if (oldOwner != address(this)) {
211       oldOwner.transfer(payment); //(1-0.06)
212     }
213 
214     TokenSold(_tokenId, sellingPrice, personIndexToPrice[_tokenId], oldOwner, newOwner, persons[_tokenId].name);
215 
216     msg.sender.transfer(purchaseExcess);
217   }
218 
219   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
220     return personIndexToPrice[_tokenId];
221   }
222 
223   /// @dev Assigns a new address to act as the owner. Only available to the current owner.
224   /// @param _newOwner The address of the new owner
225   function setOwner(address _newOwner) public onlyCeo {
226     require(_newOwner != address(0));
227 
228     ceo = _newOwner;
229   }
230 
231 
232   /// @dev Required for ERC-721 compliance.
233   function symbol() public pure returns (string) {
234     return SYMBOL;
235   }
236 
237   /// @notice Allow pre-approved user to take ownership of a token
238   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
239   /// @dev Required for ERC-721 compliance.
240   function takeOwnership(uint256 _tokenId) public {
241     address newOwner = msg.sender;
242     address oldOwner = personIndexToOwner[_tokenId];
243 
244     // Safety check to prevent against an unexpected 0x0 default.
245     require(_addressNotNull(newOwner));
246 
247     // Making sure transfer is approved
248     require(_approved(newOwner, _tokenId));
249 
250     _transfer(oldOwner, newOwner, _tokenId);
251   }
252 
253 
254   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
255     uint256 tokenCount = balanceOf(_owner);
256     if (tokenCount == 0) {
257         // Return an empty array
258       return new uint256[](0);
259     } else {
260       uint256[] memory result = new uint256[](tokenCount);
261       uint256 totalPersons = totalSupply();
262       uint256 resultIndex = 0;
263 
264       uint256 personId;
265       for (personId = 0; personId <= totalPersons; personId++) {
266         if (personIndexToOwner[personId] == _owner) {
267           result[resultIndex] = personId;
268           resultIndex++;
269         }
270       }
271       return result;
272     }
273   }
274 
275   /// For querying totalSupply of token
276   /// @dev Required for ERC-721 compliance.
277   function totalSupply() public view returns (uint256 total) {
278     return persons.length;
279   }
280 
281   /// Owner initates the transfer of the token to another account
282   /// @param _to The address for the token to be transferred to.
283   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
284   /// @dev Required for ERC-721 compliance.
285   function transfer(
286     address _to,
287     uint256 _tokenId
288   ) public {
289     require(_owns(msg.sender, _tokenId));
290     require(_addressNotNull(_to));
291 
292     _transfer(msg.sender, _to, _tokenId);
293   }
294 
295   /// Third-party initiates transfer of token from address _from to address _to
296   /// @param _from The address for the token to be transferred from.
297   /// @param _to The address for the token to be transferred to.
298   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
299   /// @dev Required for ERC-721 compliance.
300   function transferFrom(
301     address _from,
302     address _to,
303     uint256 _tokenId
304   ) public {
305     require(_owns(_from, _tokenId));
306     require(_approved(_to, _tokenId));
307     require(_addressNotNull(_to));
308 
309     _transfer(_from, _to, _tokenId);
310   }
311 
312   /*** PRIVATE FUNCTIONS ***/
313   /// Safety check on _to address to prevent against an unexpected 0x0 default.
314   function _addressNotNull(address _to) private pure returns (bool) {
315     return _to != address(0);
316   }
317 
318   /// For checking approval of transfer for address _to
319   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
320     return personIndexToApproved[_tokenId] == _to;
321   }
322 
323   /// For creating Person
324   function _createPerson(string _name, address _owner, uint256 _price) private {
325     Person memory _person = Person({
326       name: _name
327     });
328     uint256 newPersonId = persons.push(_person) - 1;
329 
330     // It's probably never going to happen, 4 billion tokens are A LOT, but
331     // let's just be 100% sure we never let this happen.
332     require(newPersonId == uint256(uint32(newPersonId)));
333 
334     Birth(newPersonId, _name, _owner);
335 
336     personIndexToPrice[newPersonId] = _price;
337 
338     // This will assign ownership, and also emit the Transfer event as
339     // per ERC721 draft
340     _transfer(address(0), _owner, newPersonId);
341   }
342 
343   /// Check for token ownership
344   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
345     return claimant == personIndexToOwner[_tokenId];
346   }
347 
348   /// For paying out balance on contract
349   function _payout(address _to) private {
350     if (_to == address(0)) {
351       ceo.transfer(this.balance);
352     } else {
353       _to.transfer(this.balance);
354     }
355   }
356 
357   /// @dev Assigns ownership of a specific Person to an address.
358   function _transfer(address _from, address _to, uint256 _tokenId) private {
359     // Since the number of persons is capped to 2^32 we can't overflow this
360     ownershipTokenCount[_to]++;
361     //transfer ownership
362     personIndexToOwner[_tokenId] = _to;
363 
364     // When creating new persons _from is 0x0, but we can't account that address.
365     if (_from != address(0)) {
366       ownershipTokenCount[_from]--;
367       // clear any previously approved ownership exchange
368       delete personIndexToApproved[_tokenId];
369     }
370 
371     // Emit the transfer event.
372     Transfer(_from, _to, _tokenId);
373   }
374 }
375 library SafeMath {
376 
377   /**
378   * @dev Multiplies two numbers, throws on overflow.
379   */
380   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
381     if (a == 0) {
382       return 0;
383     }
384     uint256 c = a * b;
385     assert(c / a == b);
386     return c;
387   }
388 
389   /**
390   * @dev Integer division of two numbers, truncating the quotient.
391   */
392   function div(uint256 a, uint256 b) internal pure returns (uint256) {
393     // assert(b > 0); // Solidity automatically throws when dividing by 0
394     uint256 c = a / b;
395     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
396     return c;
397   }
398 
399   /**
400   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
401   */
402   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
403     assert(b <= a);
404     return a - b;
405   }
406 
407   /**
408   * @dev Adds two numbers, throws on overflow.
409   */
410   function add(uint256 a, uint256 b) internal pure returns (uint256) {
411     uint256 c = a + b;
412     assert(c >= a);
413     return c;
414   }
415 }