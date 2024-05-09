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
62   // The addresses of the accounts (or contracts) that can execute actions within each roles.
63   address public ceoAddress;
64   address public cooAddress;
65 
66   /*** DATATYPES ***/
67   struct Card {
68     string slug;
69   }
70 
71   Card[] private cards;
72 
73   /*** ACCESS MODIFIERS ***/
74   /// @dev Access modifier for CEO-only functionality
75   modifier onlyCEO() {
76     require(msg.sender == ceoAddress);
77     _;
78   }
79 
80   /// @dev Access modifier for COO-only functionality
81   modifier onlyCOO() {
82     require(msg.sender == cooAddress);
83     _;
84   }
85 
86   /// Access modifier for contract owner only functionality
87   modifier onlyCLevel() {
88     require(
89       msg.sender == ceoAddress ||
90       msg.sender == cooAddress
91     );
92     _;
93   }
94 
95   /*** CONSTRUCTOR ***/
96   function OSSCardToken() public {
97     ceoAddress = msg.sender;
98     cooAddress = msg.sender;
99   }
100 
101   /*** PUBLIC FUNCTIONS ***/
102   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
103   /// @param _to The address to be granted transfer approval. Pass address(0) to
104   ///  clear all approvals.
105   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
106   /// @dev Required for ERC-721 compliance.
107   function approve(
108     address _to,
109     uint256 _tokenId
110   ) public {
111     // Caller must own token.
112     require(_owns(msg.sender, _tokenId));
113 
114     cardIndexToApproved[_tokenId] = _to;
115 
116     Approval(msg.sender, _to, _tokenId);
117   }
118 
119   /// For querying balance of a particular account
120   /// @param _owner The address for balance query
121   /// @dev Required for ERC-721 compliance.
122   function balanceOf(address _owner) public view returns (uint256 balance) {
123     return ownershipTokenCount[_owner];
124   }
125 
126   /// @dev Creates a new Card with the given slug.
127   function createCard(string _slug) public onlyCOO {
128     _createCard(_slug, address(this), startingPrice);
129   }
130 
131   /// @notice Returns all the relevant information about a specific card.
132   /// @param _tokenId The tokenId of the card.
133   function getCard(uint256 _tokenId) public view returns (
134     string slug,
135     uint256 price,
136     address owner
137   ) {
138     Card storage card = cards[_tokenId];
139     slug = card.slug;
140     price = cardIndexToPrice[_tokenId];
141     owner = cardIndexToOwner[_tokenId];
142   }
143 
144   function implementsERC721() public pure returns (bool) {
145     return true;
146   }
147 
148   /// @dev Required for ERC-721 compliance.
149   function name() public pure returns (string) {
150     return NAME;
151   }
152 
153   /// For querying owner of token
154   /// @param _tokenId The tokenID for owner inquiry
155   /// @dev Required for ERC-721 compliance.
156   function ownerOf(uint256 _tokenId)
157     public
158     view
159     returns (address owner)
160   {
161     owner = cardIndexToOwner[_tokenId];
162     require(owner != address(0));
163   }
164 
165   function payout(address _to) public onlyCLevel {
166     _payout(_to);
167   }
168 
169   // Allows someone to send ether and obtain the token
170   function purchase(uint256 _tokenId) public payable {
171     address oldOwner = cardIndexToOwner[_tokenId];
172     address newOwner = msg.sender;
173 
174     uint256 sellingPrice = cardIndexToPrice[_tokenId];
175 
176     // Making sure token owner is not sending to self
177     require(oldOwner != newOwner);
178 
179     // Safety check to prevent against an unexpected 0x0 default.
180     require(_addressNotNull(newOwner));
181 
182     // Making sure sent amount is greater than or equal to the sellingPrice
183     require(msg.value >= sellingPrice);
184 
185     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 92), 100));
186     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
187 
188     // Update prices
189     if (sellingPrice < firstStepLimit) {
190       // first stage
191       cardIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 92);
192     } else if (sellingPrice < secondStepLimit) {
193       // second stage
194       cardIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 92);
195     } else {
196       // third stage
197       cardIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 92);
198     }
199 
200     _transfer(oldOwner, newOwner, _tokenId);
201 
202     // Pay previous tokenOwner if owner is not contract
203     if (oldOwner != address(this)) {
204       oldOwner.transfer(payment); //(1-0.06)
205     }
206 
207     TokenSold(_tokenId, sellingPrice, cardIndexToPrice[_tokenId], oldOwner, newOwner, cards[_tokenId].slug);
208 
209     msg.sender.transfer(purchaseExcess);
210   }
211 
212   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
213     return cardIndexToPrice[_tokenId];
214   }
215 
216   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
217   /// @param _newCEO The address of the new CEO
218   function setCEO(address _newCEO) public onlyCEO {
219     require(_newCEO != address(0));
220 
221     ceoAddress = _newCEO;
222   }
223 
224   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
225   /// @param _newCOO The address of the new COO
226   function setCOO(address _newCOO) public onlyCEO {
227     require(_newCOO != address(0));
228 
229     cooAddress = _newCOO;
230   }
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
242     address oldOwner = cardIndexToOwner[_tokenId];
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
253   /// @param _owner The owner whose celebrity tokens we are interested in.
254   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
255   ///  expensive (it walks the entire Cards array looking for cards belonging to owner),
256   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
257   ///  not contract-to-contract calls.
258   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
259     uint256 tokenCount = balanceOf(_owner);
260     if (tokenCount == 0) {
261         // Return an empty array
262       return new uint256[](0);
263     } else {
264       uint256[] memory result = new uint256[](tokenCount);
265       uint256 totalCards = totalSupply();
266       uint256 resultIndex = 0;
267 
268       uint256 cardId;
269       for (cardId = 0; cardId <= totalCards; cardId++) {
270         if (cardIndexToOwner[cardId] == _owner) {
271           result[resultIndex] = cardId;
272           resultIndex++;
273         }
274       }
275       return result;
276     }
277   }
278 
279   /// For querying totalSupply of token
280   /// @dev Required for ERC-721 compliance.
281   function totalSupply() public view returns (uint256 total) {
282     return cards.length;
283   }
284 
285   /// Owner initates the transfer of the token to another account
286   /// @param _to The address for the token to be transferred to.
287   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
288   /// @dev Required for ERC-721 compliance.
289   function transfer(
290     address _to,
291     uint256 _tokenId
292   ) public {
293     require(_owns(msg.sender, _tokenId));
294     require(_addressNotNull(_to));
295 
296     _transfer(msg.sender, _to, _tokenId);
297   }
298 
299   /// Third-party initiates transfer of token from address _from to address _to
300   /// @param _from The address for the token to be transferred from.
301   /// @param _to The address for the token to be transferred to.
302   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
303   /// @dev Required for ERC-721 compliance.
304   function transferFrom(
305     address _from,
306     address _to,
307     uint256 _tokenId
308   ) public {
309     require(_owns(_from, _tokenId));
310     require(_approved(_to, _tokenId));
311     require(_addressNotNull(_to));
312 
313     _transfer(_from, _to, _tokenId);
314   }
315 
316   /*** PRIVATE FUNCTIONS ***/
317   /// Safety check on _to address to prevent against an unexpected 0x0 default.
318   function _addressNotNull(address _to) private pure returns (bool) {
319     return _to != address(0);
320   }
321 
322   /// For checking approval of transfer for address _to
323   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
324     return cardIndexToApproved[_tokenId] == _to;
325   }
326 
327   /// For creating Card
328   function _createCard(string _slug, address _owner, uint256 _price) private {
329     Card memory _card = Card({
330       slug: _slug
331     });
332     uint256 newCardId = cards.push(_card) - 1;
333 
334     // It's probably never going to happen, 4 billion tokens are A LOT, but
335     // let's just be 100% sure we never let this happen.
336     require(newCardId == uint256(uint32(newCardId)));
337 
338     Birth(newCardId, _slug, _owner);
339 
340     cardIndexToPrice[newCardId] = _price;
341 
342     // This will assign ownership, and also emit the Transfer event as
343     // per ERC721 draft
344     _transfer(address(0), _owner, newCardId);
345   }
346 
347   /// Check for token ownership
348   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
349     return claimant == cardIndexToOwner[_tokenId];
350   }
351 
352   /// For paying out balance on contract
353   function _payout(address _to) private {
354     if (_to == address(0)) {
355       ceoAddress.transfer(this.balance);
356     } else {
357       _to.transfer(this.balance);
358     }
359   }
360 
361   /// @dev Assigns ownership of a specific Card to an address.
362   function _transfer(address _from, address _to, uint256 _tokenId) private {
363     // Since the number of cards is capped to 2^32 we can't overflow this
364     ownershipTokenCount[_to]++;
365     //transfer ownership
366     cardIndexToOwner[_tokenId] = _to;
367 
368     // When creating new cards _from is 0x0, but we can't account that address.
369     if (_from != address(0)) {
370       ownershipTokenCount[_from]--;
371       // clear any previously approved ownership exchange
372       delete cardIndexToApproved[_tokenId];
373     }
374 
375     // Emit the transfer event.
376     Transfer(_from, _to, _tokenId);
377   }
378 }
379 library SafeMath {
380 
381   /**
382   * @dev Multiplies two numbers, throws on overflow.
383   */
384   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
385     if (a == 0) {
386       return 0;
387     }
388     uint256 c = a * b;
389     assert(c / a == b);
390     return c;
391   }
392 
393   /**
394   * @dev Integer division of two numbers, truncating the quotient.
395   */
396   function div(uint256 a, uint256 b) internal pure returns (uint256) {
397     // assert(b > 0); // Solidity automatically throws when dividing by 0
398     uint256 c = a / b;
399     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
400     return c;
401   }
402 
403   /**
404   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
405   */
406   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
407     assert(b <= a);
408     return a - b;
409   }
410 
411   /**
412   * @dev Adds two numbers, throws on overflow.
413   */
414   function add(uint256 a, uint256 b) internal pure returns (uint256) {
415     uint256 c = a + b;
416     assert(c >= a);
417     return c;
418   }
419 }