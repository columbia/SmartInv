1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract CryptoColors {
46   using SafeMath for uint256;
47 
48   /*** EVENTS ***/
49 
50   /// @dev The Birth event is fired whenever a new token comes into existence.
51   event Birth(uint256 tokenId, string name, address owner);
52 
53   /// @dev The TokenSold event is fired whenever a token is sold.
54   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
55 
56   /// @dev Referrer payout completed
57   event Payout(address referrer, uint256 balance);
58 
59   /// @dev Referrer registered
60   event ReferrerRegistered(address referrer, address referral);
61 
62   /// @dev Transfer event as defined in current draft of ERC721.
63   ///  ownership is assigned, including births.
64   event Transfer(address from, address to, uint256 tokenId);
65 
66   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
67 
68   /*** CONSTANTS ***/
69 
70   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
71   string public constant NAME = "CryptoColors"; // solhint-disable-line
72   string public constant SYMBOL = "CLRS"; // solhint-disable-line
73 
74   uint256 private startingPrice = 0.001 ether;
75   uint256 private firstStepLimit =  0.02 ether;
76   uint256 private secondStepLimit = 0.5 ether;
77   uint256 private thirdStepLimit = 2 ether;
78   uint256 private forthStepLimit = 5 ether;
79 
80   /*** STORAGE ***/
81 
82   /// @dev A mapping from token IDs to the address that owns them. All tokens have
83   ///  some valid owner address.
84   mapping (uint256 => address) public tokenIndexToOwner;
85 
86   /// @dev A mapping from owner address to count of tokens that address owns.
87   /// Used internally inside balanceOf() to resolve ownership count.
88   mapping (address => uint256) private ownershipTokenCount;
89 
90   /// @dev A mapping from TokenIDs to an address that has been approved to call
91   /// transferFrom(). Each Token can only have one approved address for transfer
92   ///  at any time. A zero value means no approval is outstanding.
93   mapping (uint256 => address) public tokenIndexToApproved;
94 
95   /// @dev A mapping from TokenIDs to the price of the token.
96   mapping (uint256 => uint256) private tokenIndexToPrice;
97 
98   /// @dev Current referrer balance
99   mapping (address => uint256) private referrerBalance;
100 
101   /// @dev A mapping from a token buyer to their referrer
102   mapping (address => address) private referralToRefferer;
103 
104   /// The addresses of the accounts (or contracts) that can execute actions within each roles.
105   address public ceoAddress;
106   address public cooAddress;
107 
108   /*** DATATYPES ***/
109   struct Token {
110     string name;
111   }
112 
113   Token[] private tokens;
114 
115   /*** ACCESS MODIFIERS ***/
116   /// @dev Access modifier for CEO-only functionality
117   modifier onlyCEO() {
118     require(msg.sender == ceoAddress);
119     _;
120   }
121 
122   /// @dev Access modifier for COO-only functionality
123   modifier onlyCOO() {
124     require(msg.sender == cooAddress);
125     _;
126   }
127 
128   /// Access modifier for contract owner only functionality
129   modifier onlyCLevel() {
130     require(
131       msg.sender == ceoAddress ||
132       msg.sender == cooAddress
133     );
134     _;
135   }
136 
137   /*** CONSTRUCTOR ***/
138   function CryptoColors() public {
139     ceoAddress = msg.sender;
140     cooAddress = msg.sender;
141   }
142 
143   /*** PUBLIC FUNCTIONS ***/
144   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
145   /// @param _to The address to be granted transfer approval. Pass address(0) to
146   ///  clear all approvals.
147   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
148   /// @dev Required for ERC-721 compliance.
149   function approve(
150     address _to,
151     uint256 _tokenId
152   )
153   public
154   {
155     // Caller must own token.
156     require(_owns(msg.sender, _tokenId));
157 
158     tokenIndexToApproved[_tokenId] = _to;
159 
160     Approval(msg.sender, _to, _tokenId);
161   }
162 
163   /// For querying balance of a particular account
164   /// @param _owner The address for balance query
165   /// @dev Required for ERC-721 compliance.
166   function balanceOf(address _owner) public view returns (uint256 balance) {
167     return ownershipTokenCount[_owner];
168   }
169 
170   /// @dev Returns next token price
171   function _calculateNextPrice(uint256 _sellingPrice) private view returns (uint256 price) {
172     if (_sellingPrice < firstStepLimit) {
173       // first stage
174       return _sellingPrice.mul(200).div(100);
175     } else if (_sellingPrice < secondStepLimit) {
176       // second stage
177      return _sellingPrice.mul(135).div(100);
178     } else if (_sellingPrice < thirdStepLimit) {
179       // third stage
180       return _sellingPrice.mul(125).div(100);
181     } else if (_sellingPrice < forthStepLimit) {
182       // forth stage
183       return _sellingPrice.mul(120).div(100);
184     } else {
185       // fifth stage
186       return _sellingPrice.mul(115).div(100);
187     }
188   }
189 
190   /// @dev Creates a new Token with the given name.
191   function createContractToken(string _name) public onlyCLevel {
192     _createToken(_name, address(this), startingPrice);
193   }
194 
195   /// @notice Returns all the relevant information about a specific token.
196   /// @param _tokenId The tokenId of the token of interest.
197   function getToken(uint256 _tokenId) public view returns (
198     string tokenName,
199     uint256 sellingPrice,
200     address owner
201   ) {
202     Token storage token = tokens[_tokenId];
203     tokenName = token.name;
204     sellingPrice = tokenIndexToPrice[_tokenId];
205     owner = tokenIndexToOwner[_tokenId];
206   }
207 
208   /// @dev Get buyer referrer.
209   function getReferrer(address _address) public view returns (address referrerAddress) {
210     return referralToRefferer[_address];
211   }
212 
213   /// @dev Get referrer balance.
214   function getReferrerBalance(address _address) public view returns (uint256 totalAmount) {
215     return referrerBalance[_address];
216   }
217   
218 
219   function implementsERC721() public pure returns (bool) {
220     return true;
221   }
222 
223   /// @dev Required for ERC-721 compliance.
224   function name() public pure returns (string) {
225     return NAME;
226   }
227 
228   /// For querying owner of token
229   /// @param _tokenId The tokenID for owner inquiry
230   /// @dev Required for ERC-721 compliance.
231   function ownerOf(uint256 _tokenId)
232     public
233     view
234     returns (address owner)
235   {
236     owner = tokenIndexToOwner[_tokenId];
237     require(owner != address(0));
238   }
239 
240   function payout(address _to) public onlyCLevel {
241     _payout(_to);
242   }
243 
244   function payoutToReferrer() public payable {
245     address referrer = msg.sender;
246     uint256 totalAmount = referrerBalance[referrer];
247     if (totalAmount > 0) {
248       msg.sender.transfer(totalAmount);
249       referrerBalance[referrer] = 0;
250       Payout(referrer, totalAmount);
251     }
252   }
253 
254   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
255     return tokenIndexToPrice[_tokenId];
256   }
257 
258     // Purchase token and increse referrer payout
259   function purchase(uint256 _tokenId, address _referrer) public payable {
260     address newOwner = msg.sender;
261     address oldOwner = tokenIndexToOwner[_tokenId];
262     uint256 sellingPrice = tokenIndexToPrice[_tokenId];
263 
264     // Making sure token owner is not sending to self
265     require(oldOwner != newOwner);
266     // Safety check to prevent against an unexpected 0x0 default.
267     require(_addressNotNull(newOwner));
268     // Making sure sent amount is greater than or equal to the sellingPrice
269     require(msg.value >= sellingPrice);
270 
271     uint256 payment = sellingPrice.mul(95).div(100);
272     uint256 purchaseExcess = msg.value.sub(sellingPrice);
273     // Calculate 15% ref bonus
274     uint256 referrerPayout = sellingPrice.sub(payment).mul(15).div(100);   
275     address storedReferrer = getReferrer(newOwner);
276 
277     // If a referrer is registered
278     if (_addressNotNull(storedReferrer)) {
279       // Increase referrer balance
280       referrerBalance[storedReferrer] += referrerPayout;
281     } else if (_addressNotNull(_referrer)) {
282       // Associate a referral with the referrer
283       referralToRefferer[newOwner] = _referrer;
284       // Notify subscribers about new referrer
285       ReferrerRegistered(_referrer, newOwner);
286       referrerBalance[_referrer] += referrerPayout;      
287     } 
288 
289     // Update prices
290     tokenIndexToPrice[_tokenId] = _calculateNextPrice(sellingPrice);
291 
292     _transfer(oldOwner, newOwner, _tokenId);
293 
294     // Pay previous tokenOwner if owner is not contract
295     if (oldOwner != address(this)) {
296       oldOwner.transfer(payment);
297     }
298 
299     TokenSold(_tokenId, sellingPrice, tokenIndexToPrice[_tokenId], oldOwner, newOwner, tokens[_tokenId].name);
300 
301     // Transfer excess back to owner
302     if (purchaseExcess > 0) {
303       msg.sender.transfer(purchaseExcess);
304     }
305   }
306 
307   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
308   /// @param _newCEO The address of the new CEO
309   function setCEO(address _newCEO) public onlyCEO {
310     require(_newCEO != address(0));
311 
312     ceoAddress = _newCEO;
313   }
314 
315   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
316   /// @param _newCOO The address of the new COO
317   function setCOO(address _newCOO) public onlyCEO {
318     require(_newCOO != address(0));
319 
320     cooAddress = _newCOO;
321   }
322 
323   /// @dev Required for ERC-721 compliance.
324   function symbol() public pure returns (string) {
325     return SYMBOL;
326   }
327 
328   /// @notice Allow pre-approved user to take ownership of a token
329   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
330   /// @dev Required for ERC-721 compliance.
331   function takeOwnership(uint256 _tokenId) public {
332     address newOwner = msg.sender;
333     address oldOwner = tokenIndexToOwner[_tokenId];
334 
335     // Safety check to prevent against an unexpected 0x0 default.
336     require(_addressNotNull(newOwner));
337 
338     // Making sure transfer is approved
339     require(_approved(newOwner, _tokenId));
340 
341     _transfer(oldOwner, newOwner, _tokenId);
342   }
343 
344   /// @param _owner The owner whose tokens we are interested in.
345   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
346   ///  expensive (it walks the entire Tokens array looking for tokens belonging to owner),
347   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
348   ///  not contract-to-contract calls.
349   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
350     uint256 tokenCount = balanceOf(_owner);
351     if (tokenCount == 0) {
352         // Return an empty array
353       return new uint256[](0);
354     } else {
355       uint256[] memory result = new uint256[](tokenCount);
356       uint256 totalTokens = totalSupply();
357       uint256 resultIndex = 0;
358 
359       uint256 tokenId;
360       for (tokenId = 0; tokenId <= totalTokens; tokenId++) {
361         if (tokenIndexToOwner[tokenId] == _owner) {
362           result[resultIndex] = tokenId;
363           resultIndex++;
364         }
365       }
366       return result;
367     }
368   }
369 
370   /// For querying totalSupply of token
371   /// @dev Required for ERC-721 compliance.
372   function totalSupply() public view returns (uint256 total) {
373     return tokens.length;
374   }
375 
376   /// Owner initates the transfer of the token to another account
377   /// @param _to The address for the token to be transferred to.
378   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
379   /// @dev Required for ERC-721 compliance.
380   function transfer(
381     address _to,
382     uint256 _tokenId
383   )
384   public
385   {
386     require(_owns(msg.sender, _tokenId));
387     require(_addressNotNull(_to));
388 
389     _transfer(msg.sender, _to, _tokenId);
390   }
391 
392   /// Third-party initiates transfer of token from address _from to address _to
393   /// @param _from The address for the token to be transferred from.
394   /// @param _to The address for the token to be transferred to.
395   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
396   /// @dev Required for ERC-721 compliance.
397   function transferFrom(
398     address _from,
399     address _to,
400     uint256 _tokenId
401   )
402   public
403   {
404     require(_owns(_from, _tokenId));
405     require(_approved(_to, _tokenId));
406     require(_addressNotNull(_to));
407 
408     _transfer(_from, _to, _tokenId);
409   }
410 
411   /*** PRIVATE FUNCTIONS ***/
412   /// Safety check on _to address to prevent against an unexpected 0x0 default.
413   function _addressNotNull(address _to) private pure returns (bool) {
414     return _to != address(0);
415   }
416 
417   /// For checking approval of transfer for address _to
418   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
419     return tokenIndexToApproved[_tokenId] == _to;
420   }
421 
422   /// For creating Token
423   function _createToken(string _name, address _owner, uint256 _price) private {
424     Token memory _token = Token({
425       name: _name
426     });
427     uint256 newTokenId = tokens.push(_token) - 1;
428 
429     // It's probably never going to happen, 4 billion tokens are A LOT, but
430     // let's just be 100% sure we never let this happen.
431     require(newTokenId == uint256(uint32(newTokenId)));
432 
433     Birth(newTokenId, _name, _owner);
434 
435     tokenIndexToPrice[newTokenId] = _price;
436 
437     // This will assign ownership, and also emit the Transfer event as
438     // per ERC721 draft
439     _transfer(address(0), _owner, newTokenId);
440   }
441 
442   /// Check for token ownership
443   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
444     return claimant == tokenIndexToOwner[_tokenId];
445   }
446 
447   /// For paying out balance on contract
448   function _payout(address _to) private {
449     if (_to == address(0)) {
450       ceoAddress.transfer(this.balance);
451     } else {
452       _to.transfer(this.balance);
453     }
454   }
455 
456   /// @dev Assigns ownership of a specific Token to an address.
457   function _transfer(address _from, address _to, uint256 _tokenId) private {
458     // Since the number of tokens is capped to 2^32 we can't overflow this
459     ownershipTokenCount[_to]++;
460     //transfer ownership
461     tokenIndexToOwner[_tokenId] = _to;
462 
463     // When creating new tokens _from is 0x0, but we can't account that address.
464     if (_from != address(0)) {
465       ownershipTokenCount[_from]--;
466       // clear any previously approved ownership exchange
467       delete tokenIndexToApproved[_tokenId];
468     }
469 
470     // Emit the transfer event.
471     Transfer(_from, _to, _tokenId);
472   }
473 }