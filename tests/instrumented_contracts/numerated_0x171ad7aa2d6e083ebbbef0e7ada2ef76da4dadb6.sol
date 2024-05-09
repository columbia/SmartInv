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
26 contract EtherNumbers is ERC721 {
27 
28   /*** EVENTS ***/
29 
30   /// @dev The Birth event is fired whenever a new Gem comes into existence.
31   event Birth(uint256 tokenId, string name, address owner);
32 
33   /// @dev The TokenSold event is fired whenever a token is sold.
34   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
35 
36   /// @dev Transfer event as defined in current draft of ERC721.
37   ///  ownership is assigned, including births.
38   event Transfer(address from, address to, uint256 tokenId);
39 
40   /*** CONSTANTS ***/
41 
42   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
43   string public constant NAME = "EtherNumbers"; // solhint-disable-line
44   string public constant SYMBOL = "NumberToken"; // solhint-disable-line
45 
46   uint256 private startingPrice = 0.001 ether;
47   uint256 private constant PROMO_CREATION_LIMIT = 10000;
48   uint256 private firstStepLimit =  0.053613 ether;
49   uint256 private secondStepLimit = 0.564957 ether;
50 
51   /*** STORAGE ***/
52 
53   /// @dev A mapping from gem IDs to the address that owns them. All gems have
54   ///  some valid owner address.
55   mapping (uint256 => address) public gemIndexToOwner;
56 
57   // @dev A mapping from owner address to count of tokens that address owns.
58   //  Used internally inside balanceOf() to resolve ownership count.
59   mapping (address => uint256) private ownershipTokenCount;
60 
61   /// @dev A mapping from GemIDs to an address that has been approved to call
62   ///  transferFrom(). Each Gem can only have one approved address for transfer
63   ///  at any time. A zero value means no approval is outstanding.
64   mapping (uint256 => address) public gemIndexToApproved;
65 
66   // @dev A mapping from GemIDs to the price of the token.
67   mapping (uint256 => uint256) private gemIndexToPrice;
68 
69   // The addresses of the accounts (or contracts) that can execute actions within each roles.
70   address public ceoAddress;
71   address public cooAddress;
72 
73   uint256 public promoCreatedCount;
74 
75   /*** DATATYPES ***/
76   struct Gem {
77     string name;
78   }
79 
80   Gem[] private gems;
81 
82   /*** ACCESS MODIFIERS ***/
83   /// @dev Access modifier for CEO-only functionality
84   modifier onlyCEO() {
85     require(msg.sender == ceoAddress);
86     _;
87   }
88 
89   /// @dev Access modifier for COO-only functionality
90   modifier onlyCOO() {
91     require(msg.sender == cooAddress);
92     _;
93   }
94 
95   /// Access modifier for contract owner only functionality
96   modifier onlyCLevel() {
97     require(
98       msg.sender == ceoAddress ||
99       msg.sender == cooAddress
100     );
101     _;
102   }
103 
104   /*** CONSTRUCTOR ***/
105   function EtherNumbers() public {
106     ceoAddress = msg.sender;
107     cooAddress = msg.sender;
108   }
109 
110   /*** PUBLIC FUNCTIONS ***/
111   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
112   /// @param _to The address to be granted transfer approval. Pass address(0) to
113   ///  clear all approvals.
114   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
115   /// @dev Required for ERC-721 compliance.
116   function approve(
117     address _to,
118     uint256 _tokenId
119   ) public {
120     // Caller must own token.
121     require(_owns(msg.sender, _tokenId));
122 
123     gemIndexToApproved[_tokenId] = _to;
124 
125     Approval(msg.sender, _to, _tokenId);
126   }
127 
128   /// For querying balance of a particular account
129   /// @param _owner The address for balance query
130   /// @dev Required for ERC-721 compliance.
131   function balanceOf(address _owner) public view returns (uint256 balance) {
132     return ownershipTokenCount[_owner];
133   }
134 
135   /// @dev Creates a new promo Person with the given name, with given _price and assignes it to an address.
136   function createPromoNumber(address _owner, string _name, uint256 _price) public onlyCOO {
137     require(promoCreatedCount < PROMO_CREATION_LIMIT);
138 
139     address personOwner = _owner;
140     if (personOwner == address(0)) {
141       personOwner = cooAddress;
142     }
143 
144     if (_price <= 0) {
145       _price = startingPrice;
146     }
147 
148     promoCreatedCount++;
149     _createGem(_name, personOwner, _price);
150   }
151 
152 
153   /// @dev Creates a new Gem with the given name.
154   function createContractGem(string _name) public onlyCLevel {
155     _createGem(_name, address(this), startingPrice);
156   }
157 
158   /// @notice Returns all the relevant information about a specific gem.
159   /// @param _tokenId The tokenId of the gem of interest.
160   function getGem(uint256 _tokenId) public view returns (
161     string gemName,
162     uint256 sellingPrice,
163     address owner
164   ) {
165     Gem storage gem = gems[_tokenId];
166     gemName = gem.name;
167     sellingPrice = gemIndexToPrice[_tokenId];
168     owner = gemIndexToOwner[_tokenId];
169   }
170 
171   function implementsERC721() public pure returns (bool) {
172     return true;
173   }
174 
175   /// @dev Required for ERC-721 compliance.
176   function name() public pure returns (string) {
177     return NAME;
178   }
179 
180   /// For querying owner of token
181   /// @param _tokenId The tokenID for owner inquiry
182   /// @dev Required for ERC-721 compliance.
183   function ownerOf(uint256 _tokenId)
184     public
185     view
186     returns (address owner)
187   {
188     owner = gemIndexToOwner[_tokenId];
189     require(owner != address(0));
190   }
191 
192   function payout(address _to) public onlyCLevel {
193     _payout(_to);
194   }
195 
196   // Allows someone to send ether and obtain the token
197   function purchase(uint256 _tokenId) public payable {
198     address oldOwner = gemIndexToOwner[_tokenId];
199     address newOwner = msg.sender;
200 
201     uint256 sellingPrice = gemIndexToPrice[_tokenId];
202 
203     // Making sure token owner is not sending to self
204     require(oldOwner != newOwner);
205 
206     // Safety check to prevent against an unexpected 0x0 default.
207     require(_addressNotNull(newOwner));
208 
209     // Making sure sent amount is greater than or equal to the sellingPrice
210     require(msg.value >= sellingPrice);
211 
212     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 92), 100));
213     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
214 
215     // Update prices
216     if (sellingPrice < firstStepLimit) {
217       // first stage
218       gemIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 92);
219     } else if (sellingPrice < secondStepLimit) {
220       // second stage
221       gemIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 92);
222     } else {
223       // third stage
224       gemIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 92);
225     }
226 
227     _transfer(oldOwner, newOwner, _tokenId);
228 
229     // Pay previous tokenOwner if owner is not contract
230     if (oldOwner != address(this)) {
231       oldOwner.transfer(payment); //(1-0.08)
232     }
233 
234     TokenSold(_tokenId, sellingPrice, gemIndexToPrice[_tokenId], oldOwner, newOwner, gems[_tokenId].name);
235 
236     msg.sender.transfer(purchaseExcess);
237   }
238 
239 
240   function changePrice(uint256 _tokenId) public  {
241     require(_owns(msg.sender, _tokenId));
242 
243     uint256 currentPrice = gemIndexToPrice[_tokenId];
244     uint256 onePercent = SafeMath.div(currentPrice, 100);
245     uint256 newPrice = SafeMath.mul(onePercent,95);
246     gemIndexToPrice[_tokenId] = newPrice;
247 
248   }
249 
250   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
251     return gemIndexToPrice[_tokenId];
252   }
253 
254   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
255   /// @param _newCEO The address of the new CEO
256   function setCEO(address _newCEO) public onlyCEO {
257     require(_newCEO != address(0));
258 
259     ceoAddress = _newCEO;
260   }
261 
262   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
263   /// @param _newCOO The address of the new COO
264   function setCOO(address _newCOO) public onlyCEO {
265     require(_newCOO != address(0));
266 
267     cooAddress = _newCOO;
268   }
269 
270   /// @dev Required for ERC-721 compliance.
271   function symbol() public pure returns (string) {
272     return SYMBOL;
273   }
274 
275   /// @notice Allow pre-approved user to take ownership of a token
276   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
277   /// @dev Required for ERC-721 compliance.
278   function takeOwnership(uint256 _tokenId) public {
279     address newOwner = msg.sender;
280     address oldOwner = gemIndexToOwner[_tokenId];
281 
282     // Safety check to prevent against an unexpected 0x0 default.
283     require(_addressNotNull(newOwner));
284 
285     // Making sure transfer is approved
286     require(_approved(newOwner, _tokenId));
287 
288     _transfer(oldOwner, newOwner, _tokenId);
289   }
290 
291   /// @param _owner The owner whose celebrity tokens we are interested in.
292   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
293   ///  expensive (it walks the entire Gems array looking for gems belonging to owner),
294   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
295   ///  not contract-to-contract calls.
296   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
297     uint256 tokenCount = balanceOf(_owner);
298     if (tokenCount == 0) {
299         // Return an empty array
300       return new uint256[](0);
301     } else {
302       uint256[] memory result = new uint256[](tokenCount);
303       uint256 totalGems = totalSupply();
304       uint256 resultIndex = 0;
305 
306       uint256 gemId;
307       for (gemId = 0; gemId <= totalGems; gemId++) {
308         if (gemIndexToOwner[gemId] == _owner) {
309           result[resultIndex] = gemId;
310           resultIndex++;
311         }
312       }
313       return result;
314     }
315   }
316 
317   /// For querying totalSupply of token
318   /// @dev Required for ERC-721 compliance.
319   function totalSupply() public view returns (uint256 total) {
320     return gems.length;
321   }
322 
323   /// Owner initates the transfer of the token to another account
324   /// @param _to The address for the token to be transferred to.
325   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
326   /// @dev Required for ERC-721 compliance.
327   function transfer(
328     address _to,
329     uint256 _tokenId
330   ) public {
331     require(_owns(msg.sender, _tokenId));
332     require(_addressNotNull(_to));
333 
334     _transfer(msg.sender, _to, _tokenId);
335   }
336 
337   /// Third-party initiates transfer of token from address _from to address _to
338   /// @param _from The address for the token to be transferred from.
339   /// @param _to The address for the token to be transferred to.
340   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
341   /// @dev Required for ERC-721 compliance.
342   function transferFrom(
343     address _from,
344     address _to,
345     uint256 _tokenId
346   ) public {
347     require(_owns(_from, _tokenId));
348     require(_approved(_to, _tokenId));
349     require(_addressNotNull(_to));
350 
351     _transfer(_from, _to, _tokenId);
352   }
353 
354   /*** PRIVATE FUNCTIONS ***/
355   /// Safety check on _to address to prevent against an unexpected 0x0 default.
356   function _addressNotNull(address _to) private pure returns (bool) {
357     return _to != address(0);
358   }
359 
360   /// For checking approval of transfer for address _to
361   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
362     return gemIndexToApproved[_tokenId] == _to;
363   }
364 
365   /// For creating Gem
366   function _createGem(string _name, address _owner, uint256 _price) private {
367     Gem memory _gem = Gem({
368       name: _name
369     });
370     uint256 newGemId = gems.push(_gem) - 1;
371 
372     // It's probably never going to happen, 4 billion tokens are A LOT, but
373     // let's just be 100% sure we never let this happen.
374     require(newGemId == uint256(uint32(newGemId)));
375 
376     Birth(newGemId, _name, _owner);
377 
378     gemIndexToPrice[newGemId] = _price;
379 
380     // This will assign ownership, and also emit the Transfer event as
381     // per ERC721 draft
382     _transfer(address(0), _owner, newGemId);
383   }
384 
385   /// Check for token ownership
386   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
387     return claimant == gemIndexToOwner[_tokenId];
388   }
389 
390   /// For paying out balance on contract
391   function _payout(address _to) private {
392     if (_to == address(0)) {
393       ceoAddress.transfer(this.balance);
394     } else {
395       _to.transfer(this.balance);
396     }
397   }
398 
399   /// @dev Assigns ownership of a specific Gem to an address.
400   function _transfer(address _from, address _to, uint256 _tokenId) private {
401     // Since the number of gems is capped to 2^32 we can't overflow this
402     ownershipTokenCount[_to]++;
403     //transfer ownership
404     gemIndexToOwner[_tokenId] = _to;
405 
406     // When creating new gems _from is 0x0, but we can't account that address.
407     if (_from != address(0)) {
408       ownershipTokenCount[_from]--;
409       // clear any previously approved ownership exchange
410       delete gemIndexToApproved[_tokenId];
411     }
412 
413     // Emit the transfer event.
414     Transfer(_from, _to, _tokenId);
415   }
416 }
417 library SafeMath {
418 
419   /**
420   * @dev Multiplies two numbers, throws on overflow.
421   */
422   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
423     if (a == 0) {
424       return 0;
425     }
426     uint256 c = a * b;
427     assert(c / a == b);
428     return c;
429   }
430 
431   /**
432   * @dev Integer division of two numbers, truncating the quotient.
433   */
434   function div(uint256 a, uint256 b) internal pure returns (uint256) {
435     // assert(b > 0); // Solidity automatically throws when dividing by 0
436     uint256 c = a / b;
437     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
438     return c;
439   }
440 
441   /**
442   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
443   */
444   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
445     assert(b <= a);
446     return a - b;
447   }
448 
449   /**
450   * @dev Adds two numbers, throws on overflow.
451   */
452   function add(uint256 a, uint256 b) internal pure returns (uint256) {
453     uint256 c = a + b;
454     assert(c >= a);
455     return c;
456   }
457 }