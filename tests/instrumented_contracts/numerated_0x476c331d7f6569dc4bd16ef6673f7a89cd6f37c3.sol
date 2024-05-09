1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
4 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
5 contract ERC721 {
6   // Required methods
7   function approve(address _to, uint256 _tokenId) public;
8   function balanceOf(address _owner) public view returns (uint256 balance);
9   function implementsERC721() public view returns (bool);
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
27 contract PoliticianToken is ERC721 {
28 
29   /*** EVENTS ***/
30 
31   /// @dev The Birth event is fired whenever a new politician comes into existence.
32   event Birth(uint256 tokenId, string name, address owner);
33 
34   /// @dev The TokenSold event is fired whenever a token is sold.
35   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address newOwner, string name);
36 
37   /// @dev Transfer event as defined in current draft of ERC721.
38   ///  ownership is assigned, including births.
39   event Transfer(address from, address to, uint256 tokenId);
40 
41   /// @dev Emitted when a bug is found int the contract and the contract is upgraded at a new address.
42   /// In the event this happens, the current contract is paused indefinitely
43   event ContractUpgrade(address newContract);
44 
45   /*** CONSTANTS ***/
46 
47   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
48   string public constant NAME = "CryptoPoliticians"; // solhint-disable-line
49   string public constant SYMBOL = "POLITICIAN"; // solhint-disable-line
50   bool private erc721Enabled = false;
51   uint256 private startingPrice = 0.001 ether;
52   uint256 private constant PROMO_CREATION_LIMIT = 5000;
53   uint256 private firstStepLimit =  0.05 ether;
54   uint256 private secondStepLimit = 0.5 ether;
55   uint256 private thirdStepLimit = 2.0 ether;
56 
57   /*** STORAGE ***/
58 
59   /// @dev A mapping from politician IDs to the address that owns them. All politicians have
60   ///  some valid owner address.
61   mapping (uint256 => address) public politicianIndexToOwner;
62 
63   // @dev A mapping from owner address to count of tokens that address owns.
64   //  Used internally inside balanceOf() to resolve ownership count.
65   mapping (address => uint256) private ownershipTokenCount;
66 
67   /// @dev A mapping from PoliticianIDs to an address that has been approved to call
68   ///  transferFrom(). Each Politician can only have one approved address for transfer
69   ///  at any time. A zero value means no approval is outstanding.
70   mapping (uint256 => address) public politicianIndexToApproved;
71 
72   // @dev A mapping from PoliticianIDs to the price of the token.
73   mapping (uint256 => uint256) private politicianIndexToPrice;
74 
75 
76   // The addresses of the accounts (or contracts) that can execute actions within each roles.
77   address public ceoAddress;
78   address public cooAddress;
79 
80   uint256 public promoCreatedCount;
81 
82   /*** DATATYPES ***/
83   struct Politician {
84 
85     //name of the politician
86     string name;
87 
88   }
89 
90   Politician[] private politicians;
91 
92   /*** ACCESS MODIFIERS ***/
93   /// @dev Access modifier for CEO-only functionality
94   modifier onlyCEO() {
95     require(msg.sender == ceoAddress);
96     _;
97   }
98 
99   /// @dev Access modifier for COO-only functionality
100   modifier onlyCOO() {
101     require(msg.sender == cooAddress);
102     _;
103   }
104 
105   modifier onlyERC721() {
106     require(erc721Enabled);
107     _;
108   }
109 
110   /// Access modifier for contract owner only functionality
111   modifier onlyCLevel() {
112     require(
113       msg.sender == ceoAddress ||
114       msg.sender == cooAddress
115     );
116     _;
117   }
118 
119   /*** CONSTRUCTOR ***/
120   function PoliticianToken() public {
121     ceoAddress = msg.sender;
122     cooAddress = msg.sender;
123   }
124 
125   /*** PUBLIC FUNCTIONS ***/
126   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
127   /// @param _to The address to be granted transfer approval. Pass address(0) to
128   ///  clear all approvals.
129   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
130   /// @dev Required for ERC-721 compliance.
131   function approve(
132     address _to,
133     uint256 _tokenId
134   ) public onlyERC721 {
135     // Caller must own token.
136     require(_owns(msg.sender, _tokenId));
137 
138     politicianIndexToApproved[_tokenId] = _to;
139 
140     Approval(msg.sender, _to, _tokenId);
141   }
142 
143   /// For querying balance of a particular account
144   /// @param _owner The address for balance query
145   /// @dev Required for ERC-721 compliance.
146   function balanceOf(address _owner) public view returns (uint256 balance) {
147     return ownershipTokenCount[_owner];
148   }
149 
150   /// @dev Creates a new promo Politician with the given name and _price and assignes it to an address.
151   function createPromoPolitician(address _owner, string _name, uint256 _price) public onlyCOO {
152     require(promoCreatedCount < PROMO_CREATION_LIMIT);
153 
154     address politicianOwner = _owner;
155 
156     if (politicianOwner == address(0)) {
157       politicianOwner = cooAddress;
158     }
159 
160     if (_price <= 0) {
161       _price = startingPrice;
162     }
163 
164     promoCreatedCount++;
165     _createPolitician(_name, politicianOwner, _price);
166   }
167 
168   /// @dev Creates a new Politician with the given name
169   function createContractPolitician(string _name) public onlyCOO {
170     _createPolitician(_name, address(this), startingPrice);
171   }
172 
173   /// @notice Returns all the relevant information about a specific politician.
174   /// @param _tokenId The tokenId of the politician of interest.
175   function getPolitician(uint256 _tokenId) public view returns (
176     string politicianName,
177     uint256 sellingPrice,
178     address owner
179   ) {
180     Politician storage politician = politicians[_tokenId];
181     politicianName = politician.name;
182     sellingPrice = politicianIndexToPrice[_tokenId];
183     owner = politicianIndexToOwner[_tokenId];
184   }
185 
186   function changePoliticianName(uint256 _tokenId, string _name) public onlyCOO {
187     require(_tokenId < politicians.length);
188     politicians[_tokenId].name = _name;
189   }
190 
191   /* ERC721 */
192   function implementsERC721() public view returns (bool _implements) {
193     return erc721Enabled;
194   }
195 
196   /// @dev Required for ERC-721 compliance.
197   function name() public pure returns (string) {
198     return NAME;
199   }
200 
201   /// @dev Required for ERC-721 compliance.
202   function symbol() public pure returns (string) {
203     return SYMBOL;
204   }
205 
206   /// For querying owner of token
207   /// @param _tokenId The tokenID for owner inquiry
208   /// @dev Required for ERC-721 compliance.
209   function ownerOf(uint256 _tokenId)
210     public
211     view
212     returns (address owner)
213   {
214     owner = politicianIndexToOwner[_tokenId];
215     require(owner != address(0));
216   }
217 
218   function payout(address _to) public onlyCLevel {
219     _payout(_to);
220   }
221 
222   function withdrawFunds(address _to, uint256 amount) public onlyCLevel {
223     _withdrawFunds(_to, amount);
224   }
225 
226   // Allows someone to send ether and obtain the token
227   function purchase(uint256 _tokenId) public payable {
228     address oldOwner = politicianIndexToOwner[_tokenId];
229     address newOwner = msg.sender;
230 
231     uint256 sellingPrice = politicianIndexToPrice[_tokenId];
232 
233     // Making sure token owner is not sending to self
234     require(oldOwner != newOwner);
235 
236     // Safety check to prevent against an unexpected 0x0 default.
237     require(_addressNotNull(newOwner));
238 
239     // Making sure sent amount is greater than or equal to the sellingPrice
240     require(msg.value >= sellingPrice);
241 
242     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 94), 100));
243     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
244 
245     // Update prices
246     if (sellingPrice < firstStepLimit) {
247       // first stage
248       politicianIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 94);
249     } else if (sellingPrice < secondStepLimit) {
250       // second stage
251       politicianIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 150), 94);
252     } else if (sellingPrice < thirdStepLimit) {
253       // second stage
254       politicianIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 125), 94);
255     } else {
256       // third stage
257       politicianIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 94);
258     }
259 
260     _transfer(oldOwner, newOwner, _tokenId);
261 
262     // Pay previous tokenOwner if owner is not contract
263     if (oldOwner != address(this)) {
264       oldOwner.transfer(payment); //(1-0.06)
265     }
266 
267     TokenSold(_tokenId, sellingPrice, politicianIndexToPrice[_tokenId], oldOwner, newOwner,
268       politicians[_tokenId].name);
269 
270     msg.sender.transfer(purchaseExcess);
271   }
272 
273   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
274     return politicianIndexToPrice[_tokenId];
275   }
276 
277   // Unlocks ERC721 behaviour, allowing for trading on third party platforms.
278   function enableERC721() public onlyCEO {
279     erc721Enabled = true;
280   }
281 
282   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
283   /// @param _newCEO The address of the new CEO
284   function setCEO(address _newCEO) public onlyCEO {
285     require(_newCEO != address(0));
286 
287     ceoAddress = _newCEO;
288   }
289 
290   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
291   /// @param _newCOO The address of the new COO
292   function setCOO(address _newCOO) public onlyCOO {
293     require(_newCOO != address(0));
294 
295     cooAddress = _newCOO;
296   }
297 
298   /// @notice Allow pre-approved user to take ownership of a token
299   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
300   /// @dev Required for ERC-721 compliance.
301   function takeOwnership(uint256 _tokenId) public {
302     address newOwner = msg.sender;
303     address oldOwner = politicianIndexToOwner[_tokenId];
304 
305     // Safety check to prevent against an unexpected 0x0 default.
306     require(_addressNotNull(newOwner));
307 
308     // Making sure transfer is approved
309     require(_approved(newOwner, _tokenId));
310 
311     _transfer(oldOwner, newOwner, _tokenId);
312   }
313 
314   /// @param _owner The owner whose politician tokens we are interested in.
315   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
316   ///  expensive (it walks the entire Politicians array looking for politicians belonging to owner),
317   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
318   ///  not contract-to-contract calls.
319   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
320     uint256 tokenCount = balanceOf(_owner);
321     if (tokenCount == 0) {
322         // Return an empty array
323       return new uint256[](0);
324     } else {
325       uint256[] memory result = new uint256[](tokenCount);
326       uint256 totalPoliticians = totalSupply();
327       uint256 resultIndex = 0;
328 
329       uint256 politicianId;
330       for (politicianId = 0; politicianId <= totalPoliticians; politicianId++) {
331         if (politicianIndexToOwner[politicianId] == _owner) {
332           result[resultIndex] = politicianId;
333           resultIndex++;
334         }
335       }
336       return result;
337     }
338   }
339 
340   /// For querying totalSupply of token
341   /// @dev Required for ERC-721 compliance.
342   function totalSupply() public view returns (uint256 total) {
343     return politicians.length;
344   }
345 
346   /// Owner initates the transfer of the token to another account
347   /// @param _to The address for the token to be transferred to.
348   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
349   /// @dev Required for ERC-721 compliance.
350   function transfer(
351     address _to,
352     uint256 _tokenId
353   ) public onlyERC721 {
354     require(_owns(msg.sender, _tokenId));
355     require(_addressNotNull(_to));
356 
357     _transfer(msg.sender, _to, _tokenId);
358   }
359 
360   /// Third-party initiates transfer of token from address _from to address _to
361   /// @param _from The address for the token to be transferred from.
362   /// @param _to The address for the token to be transferred to.
363   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
364   /// @dev Required for ERC-721 compliance.
365   function transferFrom(
366     address _from,
367     address _to,
368     uint256 _tokenId
369   ) public onlyERC721 {
370     require(_owns(_from, _tokenId));
371     require(_approved(_to, _tokenId));
372     require(_addressNotNull(_to));
373 
374     _transfer(_from, _to, _tokenId);
375   }
376 
377   /*** PRIVATE FUNCTIONS ***/
378   /// Safety check on _to address to prevent against an unexpected 0x0 default.
379   function _addressNotNull(address _to) private pure returns (bool) {
380     return _to != address(0);
381   }
382 
383   /// For checking approval of transfer for address _to
384   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
385     return politicianIndexToApproved[_tokenId] == _to;
386   }
387 
388   /// For creating Politician
389   function _createPolitician(string _name, address _owner, uint256 _price) private {
390     Politician memory _politician = Politician({
391       name: _name
392     });
393     uint256 newPoliticianId = politicians.push(_politician) - 1;
394 
395     // It's probably never going to happen, 4 billion tokens are A LOT, but
396     // let's just be 100% sure we never let this happen.
397     require(newPoliticianId == uint256(uint32(newPoliticianId)));
398 
399     Birth(newPoliticianId, _name, _owner);
400 
401     politicianIndexToPrice[newPoliticianId] = _price;
402 
403     // This will assign ownership, and also emit the Transfer event as
404     // per ERC721 draft
405     _transfer(address(0), _owner, newPoliticianId);
406   }
407 
408   /// Check for token ownership
409   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
410     return claimant == politicianIndexToOwner[_tokenId];
411   }
412 
413   /// For paying out balance on contract
414   function _payout(address _to) private {
415     if (_to == address(0)) {
416       ceoAddress.transfer(this.balance);
417     } else {
418       _to.transfer(this.balance);
419     }
420   }
421 
422   function _withdrawFunds(address _to, uint256 amount) private {
423     require(this.balance >= amount);
424     if (_to == address(0)) {
425       ceoAddress.transfer(amount);
426     } else {
427       _to.transfer(amount);
428     }
429   }
430 
431   /// @dev Assigns ownership of a specific Politician to an address.
432   function _transfer(address _from, address _to, uint256 _tokenId) private {
433     // Since the number of politicians is capped to 2^32 we can't overflow this
434     ownershipTokenCount[_to]++;
435     //transfer ownership
436     politicianIndexToOwner[_tokenId] = _to;
437 
438     // When creating new polticians _from is 0x0, but we can't account that address.
439     if (_from != address(0)) {
440       ownershipTokenCount[_from]--;
441       // clear any previously approved ownership exchange
442       delete politicianIndexToApproved[_tokenId];
443     }
444 
445     // Emit the transfer event.
446     Transfer(_from, _to, _tokenId);
447   }
448 
449 }
450 
451 library SafeMath {
452 
453   /**
454   * @dev Multiplies two numbers, throws on overflow.
455   */
456   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
457     if (a == 0) {
458       return 0;
459     }
460     uint256 c = a * b;
461     assert(c / a == b);
462     return c;
463   }
464 
465   /**
466   * @dev Integer division of two numbers, truncating the quotient.
467   */
468   function div(uint256 a, uint256 b) internal pure returns (uint256) {
469     // assert(b > 0); // Solidity automatically throws when dividing by 0
470     uint256 c = a / b;
471     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
472     return c;
473   }
474 
475   /**
476   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
477   */
478   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
479     assert(b <= a);
480     return a - b;
481   }
482 
483   /**
484   * @dev Adds two numbers, throws on overflow.
485   */
486   function add(uint256 a, uint256 b) internal pure returns (uint256) {
487     uint256 c = a + b;
488     assert(c >= a);
489     return c;
490   }
491 }