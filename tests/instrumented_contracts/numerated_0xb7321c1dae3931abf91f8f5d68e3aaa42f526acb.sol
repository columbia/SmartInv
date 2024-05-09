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
18 }
19 
20 contract OSSCardToken is ERC721 {
21 
22   /*** EVENTS ***/
23 
24   /// @dev The Birth event is fired whenever a new card comes into existence.
25   event Birth(uint256 tokenId, string slug, address owner);
26 
27   /// @dev The TokenSold event is fired whenever a token is sold.
28   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address owner, string slug);
29 
30   /// @dev Transfer event as defined in current draft of ERC721. 
31   ///  ownership is assigned, including births.
32   event Transfer(address from, address to, uint256 tokenId);
33 
34   /*** CONSTANTS ***/
35 
36   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
37   string public constant NAME = "CryptoGit.co"; // solhint-disable-line
38   string public constant SYMBOL = "OSSCARD"; // solhint-disable-line
39 
40   uint256 private startingPrice = 0.0001 ether;
41   uint256 private firstStepLimit =  0.053613 ether;
42   uint256 private secondStepLimit = 0.564957 ether;
43 
44   /*** STORAGE ***/
45 
46   /// @dev A mapping from card IDs to the address that owns them. All cards have
47   ///  some valid owner address.
48   mapping (uint256 => address) public cardIndexToOwner;
49 
50   // @dev A mapping from owner address to count of tokens that address owns.
51   //  Used internally inside balanceOf() to resolve ownership count.
52   mapping (address => uint256) private ownershipTokenCount;
53 
54   /// @dev A mapping from CardIDs to an address that has been approved to call
55   ///  transferFrom(). Each Card can only have one approved address for transfer
56   ///  at any time. A zero value means no approval is outstanding.
57   mapping (uint256 => address) public cardIndexToApproved;
58 
59   // @dev A mapping from CardIDs to the price of the token.
60   mapping (uint256 => uint256) private cardIndexToPrice;
61   
62   // To prevent similar slugs
63   mapping (string => bool) private slugs;
64 
65   // The addresses of the accounts (or contracts) that can execute actions within each roles.
66   address public ceoAddress;
67   address public cooAddress;
68 
69   /*** DATATYPES ***/
70   struct Card {
71     string slug;
72   }
73 
74   Card[] private cards;
75 
76   /*** ACCESS MODIFIERS ***/
77   /// @dev Access modifier for CEO-only functionality
78   modifier onlyCEO() {
79     require(msg.sender == ceoAddress);
80     _;
81   }
82 
83   /// @dev Access modifier for COO-only functionality
84   modifier onlyCOO() {
85     require(msg.sender == cooAddress);
86     _;
87   }
88 
89   /// Access modifier for contract owner only functionality
90   modifier onlyCLevel() {
91     require(
92       msg.sender == ceoAddress ||
93       msg.sender == cooAddress
94     );
95     _;
96   }
97 
98   /*** CONSTRUCTOR ***/
99   function OSSCardToken() public {
100     ceoAddress = msg.sender;
101     cooAddress = msg.sender;
102   }
103 
104   /*** PUBLIC FUNCTIONS ***/
105   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
106   /// @param _to The address to be granted transfer approval. Pass address(0) to
107   ///  clear all approvals.
108   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
109   /// @dev Required for ERC-721 compliance.
110   function approve(
111     address _to,
112     uint256 _tokenId
113   ) public {
114     // Caller must own token.
115     require(_owns(msg.sender, _tokenId));
116 
117     cardIndexToApproved[_tokenId] = _to;
118 
119     Approval(msg.sender, _to, _tokenId);
120   }
121 
122   /// For querying balance of a particular account
123   /// @param _owner The address for balance query
124   /// @dev Required for ERC-721 compliance.
125   function balanceOf(address _owner) public view returns (uint256 balance) {
126     return ownershipTokenCount[_owner];
127   }
128 
129   /// @dev Creates a new Card with the given slug.
130   function createCard(string _slug) public onlyCOO {
131     _createCard(_slug, address(this), startingPrice);
132   }
133 
134   /// @notice Returns all the relevant information about a specific card.
135   /// @param _tokenId The tokenId of the card.
136   function getCard(uint256 _tokenId) public view returns (
137     string slug,
138     uint256 price,
139     address owner
140   ) {
141     Card storage card = cards[_tokenId];
142     slug = card.slug;
143     price = cardIndexToPrice[_tokenId];
144     owner = cardIndexToOwner[_tokenId];
145   }
146 
147   function implementsERC721() public pure returns (bool) {
148     return true;
149   }
150 
151   /// @dev Required for ERC-721 compliance.
152   function name() public pure returns (string) {
153     return NAME;
154   }
155 
156   /// For querying owner of token
157   /// @param _tokenId The tokenID for owner inquiry
158   /// @dev Required for ERC-721 compliance.
159   function ownerOf(uint256 _tokenId)
160     public
161     view
162     returns (address owner)
163   {
164     owner = cardIndexToOwner[_tokenId];
165     require(owner != address(0));
166   }
167 
168   function payout(address _to) public onlyCLevel {
169     _payout(_to);
170   }
171 
172   // Allows someone to send ether and obtain the token
173   function purchase(uint256 _tokenId) public payable {
174     address oldOwner = cardIndexToOwner[_tokenId];
175     address newOwner = msg.sender;
176 
177     uint256 sellingPrice = cardIndexToPrice[_tokenId];
178 
179     // Making sure token owner is not sending to self
180     require(oldOwner != newOwner);
181 
182     // Safety check to prevent against an unexpected 0x0 default.
183     require(_addressNotNull(newOwner));
184 
185     // Making sure sent amount is greater than or equal to the sellingPrice
186     require(msg.value >= sellingPrice);
187 
188     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 92), 100));
189     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
190 
191     // Update prices
192     if (sellingPrice < firstStepLimit) {
193       // first stage
194       cardIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 92);
195     } else if (sellingPrice < secondStepLimit) {
196       // second stage
197       cardIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 92);
198     } else {
199       // third stage
200       cardIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 92);
201     }
202 
203     _transfer(oldOwner, newOwner, _tokenId);
204 
205     // Pay previous tokenOwner if owner is not contract
206     if (oldOwner != address(this)) {
207       oldOwner.transfer(payment); //(1-0.06)
208     }
209 
210     TokenSold(_tokenId, sellingPrice, cardIndexToPrice[_tokenId], oldOwner, newOwner, cards[_tokenId].slug);
211 
212     msg.sender.transfer(purchaseExcess);
213   }
214 
215   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
216     return cardIndexToPrice[_tokenId];
217   }
218 
219   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
220   /// @param _newCEO The address of the new CEO
221   function setCEO(address _newCEO) public onlyCEO {
222     require(_newCEO != address(0));
223 
224     ceoAddress = _newCEO;
225   }
226 
227   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
228   /// @param _newCOO The address of the new COO
229   function setCOO(address _newCOO) public onlyCEO {
230     require(_newCOO != address(0));
231 
232     cooAddress = _newCOO;
233   }
234 
235   /// @dev Required for ERC-721 compliance.
236   function symbol() public pure returns (string) {
237     return SYMBOL;
238   }
239 
240   /// @notice Allow pre-approved user to take ownership of a token
241   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
242   /// @dev Required for ERC-721 compliance.
243   function takeOwnership(uint256 _tokenId) public {
244     address newOwner = msg.sender;
245     address oldOwner = cardIndexToOwner[_tokenId];
246 
247     // Safety check to prevent against an unexpected 0x0 default.
248     require(_addressNotNull(newOwner));
249 
250     // Making sure transfer is approved
251     require(_approved(newOwner, _tokenId));
252 
253     _transfer(oldOwner, newOwner, _tokenId);
254   }
255 
256   /// @param _owner The owner whose celebrity tokens we are interested in.
257   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
258   ///  expensive (it walks the entire Cards array looking for cards belonging to owner),
259   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
260   ///  not contract-to-contract calls.
261   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
262     uint256 tokenCount = balanceOf(_owner);
263     if (tokenCount == 0) {
264         // Return an empty array
265       return new uint256[](0);
266     } else {
267       uint256[] memory result = new uint256[](tokenCount);
268       uint256 totalCards = totalSupply();
269       uint256 resultIndex = 0;
270 
271       uint256 cardId;
272       for (cardId = 0; cardId <= totalCards; cardId++) {
273         if (cardIndexToOwner[cardId] == _owner) {
274           result[resultIndex] = cardId;
275           resultIndex++;
276         }
277       }
278       return result;
279     }
280   }
281 
282   /// For querying totalSupply of token
283   /// @dev Required for ERC-721 compliance.
284   function totalSupply() public view returns (uint256 total) {
285     return cards.length;
286   }
287 
288   /// Owner initates the transfer of the token to another account
289   /// @param _to The address for the token to be transferred to.
290   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
291   /// @dev Required for ERC-721 compliance.
292   function transfer(
293     address _to,
294     uint256 _tokenId
295   ) public {
296     require(_owns(msg.sender, _tokenId));
297     require(_addressNotNull(_to));
298 
299     _transfer(msg.sender, _to, _tokenId);
300   }
301 
302   /// Third-party initiates transfer of token from address _from to address _to
303   /// @param _from The address for the token to be transferred from.
304   /// @param _to The address for the token to be transferred to.
305   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
306   /// @dev Required for ERC-721 compliance.
307   function transferFrom(
308     address _from,
309     address _to,
310     uint256 _tokenId
311   ) public {
312     require(_owns(_from, _tokenId));
313     require(_approved(_to, _tokenId));
314     require(_addressNotNull(_to));
315 
316     _transfer(_from, _to, _tokenId);
317   }
318 
319   /*** PRIVATE FUNCTIONS ***/
320   /// Safety check on _to address to prevent against an unexpected 0x0 default.
321   function _addressNotNull(address _to) private pure returns (bool) {
322     return _to != address(0);
323   }
324 
325   /// For checking approval of transfer for address _to
326   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
327     return cardIndexToApproved[_tokenId] == _to;
328   }
329 
330   /// For creating Card
331   function _createCard(string _slug, address _owner, uint256 _price) private {
332     require(!slugs[_slug]);
333       
334     Card memory _card = Card({
335       slug: _slug
336     });
337     uint256 newCardId = cards.push(_card) - 1;
338 
339     // It's probably never going to happen, 4 billion tokens are A LOT, but
340     // let's just be 100% sure we never let this happen.
341     require(newCardId == uint256(uint32(newCardId)));
342 
343     Birth(newCardId, _slug, _owner);
344 
345     cardIndexToPrice[newCardId] = _price;
346     
347     slugs[_slug] = true;
348 
349     // This will assign ownership, and also emit the Transfer event as
350     // per ERC721 draft
351     _transfer(address(0), _owner, newCardId);
352   }
353 
354   /// Check for token ownership
355   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
356     return claimant == cardIndexToOwner[_tokenId];
357   }
358 
359   /// For paying out balance on contract
360   function _payout(address _to) private {
361     if (_to == address(0)) {
362       ceoAddress.transfer(this.balance);
363     } else {
364       _to.transfer(this.balance);
365     }
366   }
367 
368   /// @dev Assigns ownership of a specific Card to an address.
369   function _transfer(address _from, address _to, uint256 _tokenId) private {
370     // Since the number of cards is capped to 2^32 we can't overflow this
371     ownershipTokenCount[_to]++;
372     //transfer ownership
373     cardIndexToOwner[_tokenId] = _to;
374 
375     // When creating new cards _from is 0x0, but we can't account that address.
376     if (_from != address(0)) {
377       ownershipTokenCount[_from]--;
378       // clear any previously approved ownership exchange
379       delete cardIndexToApproved[_tokenId];
380     }
381 
382     // Emit the transfer event.
383     Transfer(_from, _to, _tokenId);
384   }
385 }
386 library SafeMath {
387 
388   /**
389   * @dev Multiplies two numbers, throws on overflow.
390   */
391   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
392     if (a == 0) {
393       return 0;
394     }
395     uint256 c = a * b;
396     assert(c / a == b);
397     return c;
398   }
399 
400   /**
401   * @dev Integer division of two numbers, truncating the quotient.
402   */
403   function div(uint256 a, uint256 b) internal pure returns (uint256) {
404     // assert(b > 0); // Solidity automatically throws when dividing by 0
405     uint256 c = a / b;
406     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
407     return c;
408   }
409 
410   /**
411   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
412   */
413   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
414     assert(b <= a);
415     return a - b;
416   }
417 
418   /**
419   * @dev Adds two numbers, throws on overflow.
420   */
421   function add(uint256 a, uint256 b) internal pure returns (uint256) {
422     uint256 c = a + b;
423     assert(c >= a);
424     return c;
425   }
426 }