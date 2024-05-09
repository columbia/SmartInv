1 pragma solidity ^0.4.18;
2 
3 
4 // inspired by
5 // https://github.com/axiomzen/cryptokitties-bounty/blob/master/contracts/KittyAccessControl.sol
6 contract AccessControl {
7     /// @dev The addresses of the accounts (or contracts) that can execute actions within each roles
8     address public ceoAddress;
9     address public cooAddress;
10 
11     /// @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
12     bool public paused = false;
13 
14     /// @dev The AccessControl constructor sets the original C roles of the contract to the sender account
15     function AccessControl() public {
16         ceoAddress = msg.sender;
17         cooAddress = msg.sender;
18     }
19 
20     /// @dev Access modifier for CEO-only functionality
21     modifier onlyCEO() {
22         require(msg.sender == ceoAddress);
23         _;
24     }
25 
26     /// @dev Access modifier for COO-only functionality
27     modifier onlyCOO() {
28         require(msg.sender == cooAddress);
29         _;
30     }
31 
32     /// @dev Access modifier for any CLevel functionality
33     modifier onlyCLevel() {
34         require(msg.sender == ceoAddress || msg.sender == cooAddress);
35         _;
36     }
37 
38     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO
39     /// @param _newCEO The address of the new CEO
40     function setCEO(address _newCEO) public onlyCEO {
41         require(_newCEO != address(0));
42         ceoAddress = _newCEO;
43     }
44 
45     /// @dev Assigns a new address to act as the COO. Only available to the current CEO
46     /// @param _newCOO The address of the new COO
47     function setCOO(address _newCOO) public onlyCEO {
48         require(_newCOO != address(0));
49         cooAddress = _newCOO;
50     }
51 
52     /// @dev Modifier to allow actions only when the contract IS NOT paused
53     modifier whenNotPaused() {
54         require(!paused);
55         _;
56     }
57 
58     /// @dev Modifier to allow actions only when the contract IS paused
59     modifier whenPaused {
60         require(paused);
61         _;
62     }
63 
64     /// @dev Pause the smart contract. Only can be called by the CEO
65     function pause() public onlyCEO whenNotPaused {
66         paused = true;
67     }
68 
69     /// @dev Unpauses the smart contract. Only can be called by the CEO
70     function unpause() public onlyCEO whenPaused {
71         paused = false;
72     }
73 }
74 
75 
76 // https://github.com/dharmaprotocol/NonFungibleToken/blob/master/contracts/ERC721.sol
77 // https://github.com/dharmaprotocol/NonFungibleToken/blob/master/contracts/DetailedERC721.sol
78 
79 /**
80  * Interface for required functionality in the ERC721 standard
81  * for non-fungible tokens.
82  *
83  * Author: Nadav Hollander (nadav at dharma.io)
84  */
85 contract ERC721 {
86     // Events
87     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
88     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
89 
90     /// For querying totalSupply of token.
91     function totalSupply() public view returns (uint256 _totalSupply);
92 
93     /// For querying balance of a particular account.
94     /// @param _owner The address for balance query.
95     /// @dev Required for ERC-721 compliance.
96     function balanceOf(address _owner) public view returns (uint256 _balance);
97 
98     /// For querying owner of token.
99     /// @param _tokenId The tokenID for owner inquiry.
100     /// @dev Required for ERC-721 compliance.
101     function ownerOf(uint256 _tokenId) public view returns (address _owner);
102 
103     /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom()
104     /// @param _to The address to be granted transfer approval. Pass address(0) to
105     ///  clear all approvals.
106     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
107     /// @dev Required for ERC-721 compliance.
108     function approve(address _to, uint256 _tokenId) public;
109 
110     // NOT IMPLEMENTED
111     // function getApproved(uint256 _tokenId) public view returns (address _approved);
112 
113     /// Third-party initiates transfer of token from address _from to address _to.
114     /// @param _from The address for the token to be transferred from.
115     /// @param _to The address for the token to be transferred to.
116     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
117     /// @dev Required for ERC-721 compliance.
118     function transferFrom(address _from, address _to, uint256 _tokenId) public;
119 
120     /// Owner initates the transfer of the token to another account.
121     /// @param _to The address of the recipient, can be a user or contract.
122     /// @param _tokenId The ID of the token to transfer.
123     /// @dev Required for ERC-721 compliance.
124     function transfer(address _to, uint256 _tokenId) public;
125 
126     ///
127     function implementsERC721() public view returns (bool _implementsERC721);
128 
129     // EXTRA
130     /// @notice Allow pre-approved user to take ownership of a token.
131     /// @param _tokenId The ID of the token that can be transferred if this call succeeds.
132     /// @dev Required for ERC-721 compliance.
133     function takeOwnership(uint256 _tokenId) public;
134 }
135 
136 
137 /**
138  * Interface for optional functionality in the ERC721 standard
139  * for non-fungible tokens.
140  *
141  * Author: Nadav Hollander (nadav at dharma.io)
142  */
143 contract DetailedERC721 is ERC721 {
144     function name() public view returns (string _name);
145     function symbol() public view returns (string _symbol);
146     // function tokenMetadata(uint256 _tokenId) public view returns (string _infoUrl);
147     // function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
148 }
149 
150 
151 contract CryptoKittenToken is AccessControl, DetailedERC721 {
152     using SafeMath for uint256;
153 
154     /// @dev The TokenCreated event is fired whenever a new token is created.
155     event TokenCreated(uint256 tokenId, string name, uint256 price, address owner);
156 
157     /// @dev The TokenSold event is fired whenever a token is sold.
158     event TokenSold(uint256 indexed tokenId, string name, uint256 sellingPrice,
159     uint256 newPrice, address indexed oldOwner, address indexed newOwner);
160 
161     /// @dev A mapping from tokenIds to the address that owns them. All tokens have
162     ///  some valid owner address.
163     mapping (uint256 => address) private tokenIdToOwner;
164 
165     /// @dev A mapping from TokenIds to the price of the token.
166     mapping (uint256 => uint256) private tokenIdToPrice;
167 
168     /// @dev A mapping from owner address to count of tokens that address owns.
169     ///  Used internally inside balanceOf() to resolve ownership count.
170     mapping (address => uint256) private ownershipTokenCount;
171 
172     /// @dev A mapping from TokenIds to an address that has been approved to call
173     ///  transferFrom(). Each Token can only have one approved address for transfer
174     ///  at any time. A zero value means no approval is outstanding
175     mapping (uint256 => address) public tokenIdToApproved;
176 
177     struct Kittens {
178         string name;
179     }
180 
181     Kittens[] private kittens;
182 
183     uint256 private startingPrice = 0.01 ether;
184     bool private erc721Enabled = false;
185 
186     modifier onlyERC721() {
187         require(erc721Enabled);
188         _;
189     }
190 
191     /// @dev Creates a new token with the given name and _price and assignes it to an _owner.
192     function createToken(string _name, address _owner, uint256 _price) public onlyCLevel {
193         require(_owner != address(0));
194         require(_price >= startingPrice);
195 
196         _createToken(_name, _owner, _price);
197     }
198 
199     /// @dev Creates a new token with the given name.
200     function createToken(string _name) public onlyCLevel {
201         _createToken(_name, address(this), startingPrice);
202     }
203 
204     function _createToken(string _name, address _owner, uint256 _price) private {
205         Kittens memory _kitten = Kittens({
206             name: _name
207         });
208         uint256 newTokenId = kittens.push(_kitten) - 1;
209         tokenIdToPrice[newTokenId] = _price;
210 
211         TokenCreated(newTokenId, _name, _price, _owner);
212 
213         // This will assign ownership, and also emit the Transfer event as per ERC721 draft
214         _transfer(address(0), _owner, newTokenId);
215     }
216 
217     function getToken(uint256 _tokenId) public view returns (
218         string _tokenName,
219         uint256 _price,
220         uint256 _nextPrice,
221         address _owner
222     ) {
223         _tokenName = kittens[_tokenId].name;
224         _price = tokenIdToPrice[_tokenId];
225         _nextPrice = nextPriceOf(_tokenId);
226         _owner = tokenIdToOwner[_tokenId];
227     }
228 
229     function getAllTokens() public view returns (
230         uint256[],
231         uint256[],
232         address[]
233     ) {
234         uint256 total = totalSupply();
235         uint256[] memory prices = new uint256[](total);
236         uint256[] memory nextPrices = new uint256[](total);
237         address[] memory owners = new address[](total);
238 
239         for (uint256 i = 0; i < total; i++) {
240             prices[i] = tokenIdToPrice[i];
241             nextPrices[i] = nextPriceOf(i);
242             owners[i] = tokenIdToOwner[i];
243         }
244 
245         return (prices, nextPrices, owners);
246     }
247 
248     function tokensOf(address _owner) public view returns(uint256[]) {
249         uint256 tokenCount = balanceOf(_owner);
250         if (tokenCount == 0) {
251             // Return an empty array
252             return new uint256[](0);
253         } else {
254             uint256[] memory result = new uint256[](tokenCount);
255             uint256 total = totalSupply();
256             uint256 resultIndex = 0;
257 
258             for (uint256 i = 0; i < total; i++) {
259                 if (tokenIdToOwner[i] == _owner) {
260                     result[resultIndex] = i;
261                     resultIndex++;
262                 }
263             }
264             return result;
265         }
266     }
267 
268     /// @dev This function withdraws the contract owner's cut.
269     /// Any amount may be withdrawn as there is no user funds.
270     /// User funds are immediately sent to the old owner in `purchase`
271     function withdrawBalance(address _to, uint256 _amount) public onlyCEO {
272         require(_amount <= this.balance);
273 
274         if (_amount == 0) {
275             _amount = this.balance;
276         }
277 
278         if (_to == address(0)) {
279             ceoAddress.transfer(_amount);
280         } else {
281             _to.transfer(_amount);
282         }
283     }
284 
285     // Send ether and obtain the token
286     function purchase(uint256 _tokenId) public payable whenNotPaused {
287         address oldOwner = ownerOf(_tokenId);
288         address newOwner = msg.sender;
289         uint256 sellingPrice = priceOf(_tokenId);
290 
291         // active tokens
292         require(oldOwner != address(0));
293         // maybe one day newOwner's logic allows this to happen
294         require(newOwner != address(0));
295         // don't buy from yourself
296         require(oldOwner != newOwner);
297         // don't sell to contracts
298         // but even this doesn't prevent bad contracts to become an owner of a token
299         require(!_isContract(newOwner));
300         // another check to be sure that token is active
301         require(sellingPrice > 0);
302         // min required amount check
303         require(msg.value >= sellingPrice);
304 
305         // transfer to the new owner
306         _transfer(oldOwner, newOwner, _tokenId);
307         // update fields before emitting an event
308         tokenIdToPrice[_tokenId] = nextPriceOf(_tokenId);
309         // emit event
310         TokenSold(_tokenId, kittens[_tokenId].name, sellingPrice, priceOf(_tokenId), oldOwner, newOwner);
311 
312         // extra ether which should be returned back to buyer
313         uint256 excess = msg.value.sub(sellingPrice);
314         // contract owner's cut which is left in contract and accesed by withdrawBalance
315         uint256 contractCut = sellingPrice.mul(6).div(100); // 6%
316 
317         // no need to transfer if it's initial sell
318         if (oldOwner != address(this)) {
319             // transfer payment to seller minus the contract's cut
320             oldOwner.transfer(sellingPrice.sub(contractCut));
321         }
322 
323         // return extra ether
324         if (excess > 0) {
325             newOwner.transfer(excess);
326         }
327     }
328 
329     function priceOf(uint256 _tokenId) public view returns (uint256 _price) {
330         return tokenIdToPrice[_tokenId];
331     }
332 
333     uint256 private increaseLimit1 = 0.02 ether;
334     uint256 private increaseLimit2 = 0.5 ether;
335     uint256 private increaseLimit3 = 2.0 ether;
336     uint256 private increaseLimit4 = 5.0 ether;
337 
338     function nextPriceOf(uint256 _tokenId) public view returns (uint256 _nextPrice) {
339         uint256 _price = priceOf(_tokenId);
340         if (_price < increaseLimit1) {
341             return _price.mul(200).div(95);
342         } else if (_price < increaseLimit2) {
343             return _price.mul(135).div(96);
344         } else if (_price < increaseLimit3) {
345             return _price.mul(125).div(97);
346         } else if (_price < increaseLimit4) {
347             return _price.mul(117).div(97);
348         } else {
349             return _price.mul(115).div(98);
350         }
351     }
352 
353 
354     /*** ERC-721 ***/
355     // Unlocks ERC721 behaviour, allowing for trading on third party platforms.
356     function enableERC721() onlyCEO public {
357         erc721Enabled = true;
358     }
359 
360     function totalSupply() public view returns (uint256 _totalSupply) {
361         _totalSupply = kittens.length;
362     }
363 
364     function balanceOf(address _owner) public view returns (uint256 _balance) {
365         _balance = ownershipTokenCount[_owner];
366     }
367 
368     function ownerOf(uint256 _tokenId) public view returns (address _owner) {
369         _owner = tokenIdToOwner[_tokenId];
370         // require(_owner != address(0));
371     }
372 
373     function approve(address _to, uint256 _tokenId) public whenNotPaused onlyERC721 {
374         require(_owns(msg.sender, _tokenId));
375 
376         tokenIdToApproved[_tokenId] = _to;
377 
378         Approval(msg.sender, _to, _tokenId);
379     }
380 
381     function transferFrom(address _from, address _to, uint256 _tokenId) public whenNotPaused onlyERC721 {
382         require(_to != address(0));
383         require(_owns(_from, _tokenId));
384         require(_approved(msg.sender, _tokenId));
385 
386         _transfer(_from, _to, _tokenId);
387     }
388 
389     function transfer(address _to, uint256 _tokenId) public whenNotPaused onlyERC721 {
390         require(_to != address(0));
391         require(_owns(msg.sender, _tokenId));
392 
393         // Reassign ownership, clear pending approvals, emit Transfer event.
394         _transfer(msg.sender, _to, _tokenId);
395     }
396 
397     function implementsERC721() public view whenNotPaused returns (bool) {
398         return erc721Enabled;
399     }
400 
401     function takeOwnership(uint256 _tokenId) public whenNotPaused onlyERC721 {
402         require(_approved(msg.sender, _tokenId));
403 
404         _transfer(tokenIdToOwner[_tokenId], msg.sender, _tokenId);
405     }
406 
407     function name() public view returns (string _name) {
408         _name = "CryptoKittens";
409     }
410 
411     function symbol() public view returns (string _symbol) {
412         _symbol = "CKTN";
413     }
414 
415     /*** PRIVATES ***/
416     /// @dev Check for token ownership.
417     function _owns(address _claimant, uint256 _tokenId) private view returns (bool) {
418         return tokenIdToOwner[_tokenId] == _claimant;
419     }
420 
421     /// @dev For checking approval of transfer for address _to.
422     function _approved(address _to, uint256 _tokenId) private view returns (bool) {
423         return tokenIdToApproved[_tokenId] == _to;
424     }
425 
426     /// @dev Assigns ownership of a specific token to an address.
427     function _transfer(address _from, address _to, uint256 _tokenId) private {
428         // Since the number of tokens is capped to 2^32 we can't overflow this
429         ownershipTokenCount[_to]++;
430         // Transfer ownership
431         tokenIdToOwner[_tokenId] = _to;
432 
433         // When creating new token _from is 0x0, but we can't account that address.
434         if (_from != address(0)) {
435             ownershipTokenCount[_from]--;
436             // clear any previously approved ownership exchange
437             delete tokenIdToApproved[_tokenId];
438         }
439 
440         // Emit the transfer event.
441         Transfer(_from, _to, _tokenId);
442     }
443 
444     /// @dev Checks if the address ia a contract or not
445     function _isContract(address addr) private view returns (bool) {
446         uint256 size;
447         assembly { size := extcodesize(addr) }
448         return size > 0;
449     }
450 }
451 
452 
453 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
454 // v1.6.0
455 
456 /**
457  * @title SafeMath
458  * @dev Math operations with safety checks that throw on error
459  */
460 library SafeMath {
461 
462     /**
463     * @dev Multiplies two numbers, throws on overflow.
464     */
465     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
466         if (a == 0) {
467         return 0;
468         }
469         uint256 c = a * b;
470         assert(c / a == b);
471         return c;
472     }
473 
474     /**
475     * @dev Integer division of two numbers, truncating the quotient.
476     */
477     function div(uint256 a, uint256 b) internal pure returns (uint256) {
478         // assert(b > 0); // Solidity automatically throws when dividing by 0
479         uint256 c = a / b;
480         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
481         return c;
482     }
483 
484     /**
485     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
486     */
487     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
488         assert(b <= a);
489         return a - b;
490     }
491 
492     /**
493     * @dev Adds two numbers, throws on overflow.
494     */
495     function add(uint256 a, uint256 b) internal pure returns (uint256) {
496         uint256 c = a + b;
497         assert(c >= a);
498         return c;
499     }
500 }