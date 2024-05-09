1 pragma solidity ^0.4.18;
2 // inspired by
3 // https://github.com/axiomzen/cryptokitties-bounty/blob/master/contracts/KittyAccessControl.sol
4 
5 contract AccessControl {
6   /// @dev The addresses of the accounts (or contracts) that can execute actions within each roles
7   address public ceoAddress;
8   address public cooAddress;
9 
10   /// @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
11   bool public paused = false;
12 
13   /// @dev The AccessControl constructor sets the original C roles of the contract to the sender account
14   function AccessControl() public {
15     ceoAddress = msg.sender;
16     cooAddress = msg.sender;
17   }
18 
19   /// @dev Access modifier for CEO-only functionality
20   modifier onlyCEO() {
21     require(msg.sender == ceoAddress);
22     _;
23   }
24 
25   /// @dev Access modifier for COO-only functionality
26   modifier onlyCOO() {
27     require(msg.sender == cooAddress);
28     _;
29   }
30 
31   /// @dev Access modifier for any CLevel functionality
32   modifier onlyCLevel() {
33     require(msg.sender == ceoAddress || msg.sender == cooAddress);
34     _;
35   }
36 
37   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO
38   /// @param _newCEO The address of the new CEO
39   function setCEO(address _newCEO) public onlyCEO {
40     require(_newCEO != address(0));
41     ceoAddress = _newCEO;
42   }
43 
44   /// @dev Assigns a new address to act as the COO. Only available to the current CEO
45   /// @param _newCOO The address of the new COO
46   function setCOO(address _newCOO) public onlyCEO {
47     require(_newCOO != address(0));
48     cooAddress = _newCOO;
49   }
50 
51   /// @dev Modifier to allow actions only when the contract IS NOT paused
52   modifier whenNotPaused() {
53     require(!paused);
54     _;
55   }
56 
57   /// @dev Modifier to allow actions only when the contract IS paused
58   modifier whenPaused {
59     require(paused);
60     _;
61   }
62 
63   /// @dev Pause the smart contract. Only can be called by the CEO
64   function pause() public onlyCEO whenNotPaused {
65      paused = true;
66   }
67 
68   /// @dev Unpauses the smart contract. Only can be called by the CEO
69   function unpause() public onlyCEO whenPaused {
70     paused = false;
71   }
72 }
73 
74 
75 // https://github.com/dharmaprotocol/NonFungibleToken/blob/master/contracts/ERC721.sol
76 // https://github.com/dharmaprotocol/NonFungibleToken/blob/master/contracts/DetailedERC721.sol
77 
78 /**
79  * Interface for required functionality in the ERC721 standard
80  * for non-fungible tokens.
81  *
82  * Author: Nadav Hollander (nadav at dharma.io)
83  */
84 contract ERC721 {
85     // Events
86     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
87     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
88 
89     /// For querying totalSupply of token.
90     function totalSupply() public view returns (uint256 _totalSupply);
91 
92     /// For querying balance of a particular account.
93     /// @param _owner The address for balance query.
94     /// @dev Required for ERC-721 compliance.
95     function balanceOf(address _owner) public view returns (uint256 _balance);
96 
97     /// For querying owner of token.
98     /// @param _tokenId The tokenID for owner inquiry.
99     /// @dev Required for ERC-721 compliance.
100     function ownerOf(uint256 _tokenId) public view returns (address _owner);
101 
102     /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom()
103     /// @param _to The address to be granted transfer approval. Pass address(0) to
104     ///  clear all approvals.
105     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
106     /// @dev Required for ERC-721 compliance.
107     function approve(address _to, uint256 _tokenId) public;
108 
109     // NOT IMPLEMENTED
110     // function getApproved(uint256 _tokenId) public view returns (address _approved);
111 
112     /// Third-party initiates transfer of token from address _from to address _to.
113     /// @param _from The address for the token to be transferred from.
114     /// @param _to The address for the token to be transferred to.
115     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
116     /// @dev Required for ERC-721 compliance.
117     function transferFrom(address _from, address _to, uint256 _tokenId) public;
118 
119     /// Owner initates the transfer of the token to another account.
120     /// @param _to The address of the recipient, can be a user or contract.
121     /// @param _tokenId The ID of the token to transfer.
122     /// @dev Required for ERC-721 compliance.
123     function transfer(address _to, uint256 _tokenId) public;
124 
125     ///
126     function implementsERC721() public view returns (bool _implementsERC721);
127 
128     // EXTRA
129     /// @notice Allow pre-approved user to take ownership of a token.
130     /// @param _tokenId The ID of the token that can be transferred if this call succeeds.
131     /// @dev Required for ERC-721 compliance.
132     function takeOwnership(uint256 _tokenId) public;
133 }
134 
135 /**
136  * Interface for optional functionality in the ERC721 standard
137  * for non-fungible tokens.
138  *
139  * Author: Nadav Hollander (nadav at dharma.io)
140  */
141 contract DetailedERC721 is ERC721 {
142     function name() public view returns (string _name);
143     function symbol() public view returns (string _symbol);
144     // function tokenMetadata(uint256 _tokenId) public view returns (string _infoUrl);
145     // function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
146 }
147 
148 
149 contract CryptoArtsToken is AccessControl, DetailedERC721 {
150   using SafeMath for uint256;
151 
152   /// @dev The TokenCreated event is fired whenever a new token is created.
153   event TokenCreated(uint256 tokenId, string name, uint256 price, address owner);
154 
155   /// @dev The TokenSold event is fired whenever a token is sold.
156   event TokenSold(uint256 indexed tokenId, string name, uint256 sellingPrice,
157    uint256 newPrice, address indexed oldOwner, address indexed newOwner);
158 
159 
160   /// @dev A mapping from tokenIds to the address that owns them. All tokens have
161   ///  some valid owner address.
162   mapping (uint256 => address) private tokenIdToOwner;
163 
164   /// @dev A mapping from TokenIds to the price of the token.
165   mapping (uint256 => uint256) private tokenIdToPrice;
166 
167   /// @dev A mapping from owner address to count of tokens that address owns.
168   ///  Used internally inside balanceOf() to resolve ownership count.
169   mapping (address => uint256) private ownershipTokenCount;
170 
171   /// @dev A mapping from TokenIds to an address that has been approved to call
172   ///  transferFrom(). Each Token can only have one approved address for transfer
173   ///  at any time. A zero value means no approval is outstanding
174   mapping (uint256 => address) public tokenIdToApproved;
175 
176 
177   struct Art {
178     string name;
179   }
180   Art[] private arts;
181 
182   uint256 private startingPrice = 0.01 ether;
183   bool private erc721Enabled = false;
184 
185   modifier onlyERC721() {
186     require(erc721Enabled);
187     _;
188   }
189 
190   /// @dev Creates a new token with the given name and _price and assignes it to an _owner.
191   function createToken(string _name, address _owner, uint256 _price) public onlyCLevel {
192     require(_owner != address(0));
193     require(_price >= startingPrice);
194 
195     _createToken(_name, _owner, _price);
196   }
197 
198   /// @dev Creates a new token with the given name.
199   function createToken(string _name) public onlyCLevel {
200     _createToken(_name, address(this), startingPrice);
201   }
202 
203   function _createToken(string _name, address _owner, uint256 _price) private {
204     Art memory _art = Art({
205       name: _name
206     });
207     uint256 newTokenId = arts.push(_art) - 1;
208     tokenIdToPrice[newTokenId] = _price;
209 
210     TokenCreated(newTokenId, _name, _price, _owner);
211 
212     // This will assign ownership, and also emit the Transfer event as per ERC721 draft
213     _transfer(address(0), _owner, newTokenId);
214   }
215 
216   function getToken(uint256 _tokenId) public view returns (
217     string _tokenName,
218     uint256 _price,
219     uint256 _nextPrice,
220     address _owner
221   ) {
222     _tokenName = arts[_tokenId].name;
223     _price = tokenIdToPrice[_tokenId];
224     _nextPrice = nextPriceOf(_tokenId);
225     _owner = tokenIdToOwner[_tokenId];
226   }
227 
228   function getAllTokens() public view returns (
229       uint256[],
230       uint256[],
231       address[]
232   ) {
233       uint256 total = totalSupply();
234       uint256[] memory prices = new uint256[](total);
235       uint256[] memory nextPrices = new uint256[](total);
236       address[] memory owners = new address[](total);
237 
238       for (uint256 i = 0; i < total; i++) {
239           prices[i] = tokenIdToPrice[i];
240           nextPrices[i] = nextPriceOf(i);
241           owners[i] = tokenIdToOwner[i];
242       }
243 
244       return (prices, nextPrices, owners);
245   }
246 
247   function tokensOf(address _owner) public view returns(uint256[]) {
248     uint256 tokenCount = balanceOf(_owner);
249     if (tokenCount == 0) {
250         // Return an empty array
251       return new uint256[](0);
252     } else {
253       uint256[] memory result = new uint256[](tokenCount);
254       uint256 total = totalSupply();
255       uint256 resultIndex = 0;
256 
257       for (uint256 i = 0; i < total; i++) {
258         if (tokenIdToOwner[i] == _owner) {
259           result[resultIndex] = i;
260           resultIndex++;
261         }
262       }
263       return result;
264     }
265   }
266 
267   /// @dev This function withdraws the contract owner's cut.
268   /// Any amount may be withdrawn as there is no user funds.
269   /// User funds are immediately sent to the old owner in `purchase`
270   function withdrawBalance(address _to, uint256 _amount) public onlyCEO {
271     require(_amount <= this.balance);
272 
273     if (_amount == 0) {
274       _amount = this.balance;
275     }
276 
277     if (_to == address(0)) {
278       ceoAddress.transfer(_amount);
279     } else {
280       _to.transfer(_amount);
281     }
282   }
283 
284   // Send ether and obtain the token
285   function purchase(uint256 _tokenId) public payable whenNotPaused {
286     address oldOwner = ownerOf(_tokenId);
287     address newOwner = msg.sender;
288     uint256 sellingPrice = priceOf(_tokenId);
289 
290     // active tokens
291     require(oldOwner != address(0));
292     // maybe one day newOwner's logic allows this to happen
293     require(newOwner != address(0));
294     // don't buy from yourself
295     require(oldOwner != newOwner);
296     // don't sell to contracts
297     // but even this doesn't prevent bad contracts to become an owner of a token
298     require(!_isContract(newOwner));
299     // another check to be sure that token is active
300     require(sellingPrice > 0);
301     // min required amount check
302     require(msg.value >= sellingPrice);
303 
304     // transfer to the new owner
305     _transfer(oldOwner, newOwner, _tokenId);
306     // update fields before emitting an event
307     tokenIdToPrice[_tokenId] = nextPriceOf(_tokenId);
308     // emit event
309     TokenSold(_tokenId, arts[_tokenId].name, sellingPrice, priceOf(_tokenId), oldOwner, newOwner);
310 
311     // extra ether which should be returned back to buyer
312     uint256 excess = msg.value.sub(sellingPrice);
313     // contract owner's cut which is left in contract and accesed by withdrawBalance
314     uint256 contractCut = sellingPrice.mul(6).div(100); // 6%
315 
316     // no need to transfer if it's initial sell
317     if (oldOwner != address(this)) {
318       // transfer payment to seller minus the contract's cut
319       oldOwner.transfer(sellingPrice.sub(contractCut));
320     }
321 
322     // return extra ether
323     if (excess > 0) {
324       newOwner.transfer(excess);
325     }
326   }
327 
328   function priceOf(uint256 _tokenId) public view returns (uint256 _price) {
329     return tokenIdToPrice[_tokenId];
330   }
331 
332   uint256 private increaseLimit1 = 0.05 ether;
333   uint256 private increaseLimit2 = 0.5 ether;
334   uint256 private increaseLimit3 = 5 ether;
335 
336   function nextPriceOf(uint256 _tokenId) public view returns (uint256 _nextPrice) {
337     uint256 price = priceOf(_tokenId);
338     if (price < increaseLimit1) {
339       return price.mul(135).div(94);
340     } else if (price < increaseLimit2) {
341       return price.mul(120).div(94);
342     } else if (price < increaseLimit3) {
343       return price.mul(118).div(94);
344     } else {
345       return price.mul(116).div(94);
346     }
347   }
348 
349 
350   /*** ERC-721 ***/
351   // Unlocks ERC721 behaviour, allowing for trading on third party platforms.
352   function enableERC721() onlyCEO public {
353     erc721Enabled = true;
354   }
355 
356   function totalSupply() public view returns (uint256 _totalSupply) {
357     _totalSupply = arts.length;
358   }
359 
360   function balanceOf(address _owner) public view returns (uint256 _balance) {
361     _balance = ownershipTokenCount[_owner];
362   }
363 
364   function ownerOf(uint256 _tokenId) public view returns (address _owner) {
365     _owner = tokenIdToOwner[_tokenId];
366     // require(_owner != address(0));
367   }
368 
369   function approve(address _to, uint256 _tokenId) public whenNotPaused onlyERC721 {
370     require(_owns(msg.sender, _tokenId));
371 
372     tokenIdToApproved[_tokenId] = _to;
373 
374     Approval(msg.sender, _to, _tokenId);
375   }
376 
377   function transferFrom(address _from, address _to, uint256 _tokenId) public whenNotPaused onlyERC721 {
378     require(_to != address(0));
379     require(_owns(_from, _tokenId));
380     require(_approved(msg.sender, _tokenId));
381 
382     _transfer(_from, _to, _tokenId);
383   }
384 
385   function transfer(address _to, uint256 _tokenId) public whenNotPaused onlyERC721 {
386       require(_to != address(0));
387       require(_owns(msg.sender, _tokenId));
388 
389       // Reassign ownership, clear pending approvals, emit Transfer event.
390       _transfer(msg.sender, _to, _tokenId);
391   }
392 
393   function implementsERC721() public view whenNotPaused returns (bool) {
394     return erc721Enabled;
395   }
396 
397   function takeOwnership(uint256 _tokenId) public whenNotPaused onlyERC721 {
398     require(_approved(msg.sender, _tokenId));
399 
400     _transfer(tokenIdToOwner[_tokenId], msg.sender, _tokenId);
401   }
402 
403   function name() public view returns (string _name) {
404     _name = "CryptoArts";
405   }
406 
407   function symbol() public view returns (string _symbol) {
408     _symbol = "XART";
409   }
410 
411 
412   /*** PRIVATES ***/
413   /// @dev Check for token ownership.
414   function _owns(address _claimant, uint256 _tokenId) private view returns (bool) {
415       return tokenIdToOwner[_tokenId] == _claimant;
416   }
417 
418   /// @dev For checking approval of transfer for address _to.
419   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
420     return tokenIdToApproved[_tokenId] == _to;
421   }
422 
423   /// @dev Assigns ownership of a specific token to an address.
424   function _transfer(address _from, address _to, uint256 _tokenId) private {
425     // Since the number of tokens is capped to 2^32 we can't overflow this
426     ownershipTokenCount[_to]++;
427     // Transfer ownership
428     tokenIdToOwner[_tokenId] = _to;
429 
430     // When creating new token _from is 0x0, but we can't account that address.
431     if (_from != address(0)) {
432       ownershipTokenCount[_from]--;
433       // clear any previously approved ownership exchange
434       delete tokenIdToApproved[_tokenId];
435     }
436 
437     // Emit the transfer event.
438     Transfer(_from, _to, _tokenId);
439   }
440 
441   /// @dev Checks if the address ia a contract or not
442   function _isContract(address addr) private view returns (bool) {
443     uint256 size;
444     assembly { size := extcodesize(addr) }
445     return size > 0;
446   }
447 }
448 
449 
450 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
451 // v1.6.0
452 
453 /**
454  * @title SafeMath
455  * @dev Math operations with safety checks that throw on error
456  */
457 library SafeMath {
458 
459   /**
460   * @dev Multiplies two numbers, throws on overflow.
461   */
462   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
463     if (a == 0) {
464       return 0;
465     }
466     uint256 c = a * b;
467     assert(c / a == b);
468     return c;
469   }
470 
471   /**
472   * @dev Integer division of two numbers, truncating the quotient.
473   */
474   function div(uint256 a, uint256 b) internal pure returns (uint256) {
475     // assert(b > 0); // Solidity automatically throws when dividing by 0
476     uint256 c = a / b;
477     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
478     return c;
479   }
480 
481   /**
482   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
483   */
484   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
485     assert(b <= a);
486     return a - b;
487   }
488 
489   /**
490   * @dev Adds two numbers, throws on overflow.
491   */
492   function add(uint256 a, uint256 b) internal pure returns (uint256) {
493     uint256 c = a + b;
494     assert(c >= a);
495     return c;
496   }
497 }