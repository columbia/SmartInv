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
151 contract CryptoAdrian is AccessControl, DetailedERC721 {
152     using SafeMath for uint256;
153 
154     /// @dev The TokenCreated event is fired whenever a new token is created.
155     event TokenCreated(uint256 tokenId, string name, uint32 buffness, uint256 price, address owner);
156 
157     /// @dev The TokenSold event is fired whenever a token is sold.
158     event TokenSold(uint256 indexed tokenId, string name, uint32 buffness, uint256 sellingPrice,
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
177     struct Adrian {
178         string name;
179         uint32 buffness;
180     }
181 
182     Adrian[] private adrians;
183 
184     uint256 private startingPrice = 0.001 ether;
185     bool private erc721Enabled = false;
186 
187     modifier onlyERC721() {
188         require(erc721Enabled);
189         _;
190     }
191 
192     /// @dev Creates a new token with the given name and _price and assignes it to an _owner.
193     function createToken(string _name, uint32 _buffness, address _owner, uint256 _price) public onlyCLevel {
194         require(_owner != address(0));
195         require(_price >= startingPrice);
196 
197         _createToken(_name, _buffness, _owner, _price);
198     }
199 
200     /// @dev Creates a new token with the given name.
201     function createToken(string _name, uint32 _buffness) public onlyCLevel {
202         _createToken(_name, _buffness, address(this), startingPrice);
203     }
204 
205     function _createToken(string _name, uint32 _buffness, address _owner, uint256 _price) private {
206         Adrian memory _adrian = Adrian({
207             name: _name,
208             buffness: _buffness
209         });
210         uint256 newTokenId = adrians.push(_adrian) - 1;
211         tokenIdToPrice[newTokenId] = _price;
212 
213         TokenCreated(newTokenId, _name, _buffness, _price, _owner);
214 
215         // This will assign ownership, and also emit the Transfer event as per ERC721 draft
216         _transfer(address(0), _owner, newTokenId);
217     }
218 
219     function getToken(uint256 _tokenId) public view returns (
220         string _tokenName,
221         uint32 _buffness,
222         uint256 _price,
223         uint256 _nextPrice,
224         address _owner
225     ) {
226         _tokenName = adrians[_tokenId].name;
227         _buffness = adrians[_tokenId].buffness;
228         _price = tokenIdToPrice[_tokenId];
229         _nextPrice = nextPriceOf(_tokenId);
230         _owner = tokenIdToOwner[_tokenId];
231     }
232 
233     function getAllTokens() public view returns (
234         uint256[],
235         uint256[],
236         address[]
237     ) {
238         uint256 total = totalSupply();
239         uint256[] memory prices = new uint256[](total);
240         uint256[] memory nextPrices = new uint256[](total);
241         address[] memory owners = new address[](total);
242 
243         for (uint256 i = 0; i < total; i++) {
244             prices[i] = tokenIdToPrice[i];
245             nextPrices[i] = nextPriceOf(i);
246             owners[i] = tokenIdToOwner[i];
247         }
248 
249         return (prices, nextPrices, owners);
250     }
251 
252     function tokensOf(address _owner) public view returns(uint256[]) {
253         uint256 tokenCount = balanceOf(_owner);
254         if (tokenCount == 0) {
255             // Return an empty array
256             return new uint256[](0);
257         } else {
258             uint256[] memory result = new uint256[](tokenCount);
259             uint256 total = totalSupply();
260             uint256 resultIndex = 0;
261 
262             for (uint256 i = 0; i < total; i++) {
263                 if (tokenIdToOwner[i] == _owner) {
264                     result[resultIndex] = i;
265                     resultIndex++;
266                 }
267             }
268             return result;
269         }
270     }
271 
272     /// @dev This function withdraws the contract owner's cut.
273     /// Any amount may be withdrawn as there is no user funds.
274     /// User funds are immediately sent to the old owner in `purchase`
275     function withdrawBalance(address _to, uint256 _amount) public onlyCEO {
276         require(_amount <= this.balance);
277 
278         if (_amount == 0) {
279             _amount = this.balance;
280         }
281 
282         if (_to == address(0)) {
283             ceoAddress.transfer(_amount);
284         } else {
285             _to.transfer(_amount);
286         }
287     }
288 
289     // Send ether and obtain the token
290     function purchase(uint256 _tokenId) public payable whenNotPaused {
291         address oldOwner = ownerOf(_tokenId);
292         address newOwner = msg.sender;
293         uint256 sellingPrice = priceOf(_tokenId);
294 
295         // active tokens
296         require(oldOwner != address(0));
297         // maybe one day newOwner's logic allows this to happen
298         require(newOwner != address(0));
299         // don't buy from yourself
300         require(oldOwner != newOwner);
301         // don't sell to contracts
302         // but even this doesn't prevent bad contracts to become an owner of a token
303         require(!_isContract(newOwner));
304         // another check to be sure that token is active
305         require(sellingPrice > 0);
306         // min required amount check
307         require(msg.value >= sellingPrice);
308 
309         // transfer to the new owner
310         _transfer(oldOwner, newOwner, _tokenId);
311         // update fields before emitting an event
312         tokenIdToPrice[_tokenId] = nextPriceOf(_tokenId);
313         // emit event
314         TokenSold(_tokenId, adrians[_tokenId].name, adrians[_tokenId].buffness, sellingPrice, priceOf(_tokenId), oldOwner, newOwner);
315 
316         // extra ether which should be returned back to buyer
317         uint256 excess = msg.value.sub(sellingPrice);
318         // contract owner's cut which is left in contract and accesed by withdrawBalance
319         uint256 contractCut = sellingPrice.mul(6).div(100); // 6%
320 
321         // no need to transfer if it's initial sell
322         if (oldOwner != address(this)) {
323             // transfer payment to seller minus the contract's cut
324             oldOwner.transfer(sellingPrice.sub(contractCut));
325         }
326 
327         // return extra ether
328         if (excess > 0) {
329             newOwner.transfer(excess);
330         }
331     }
332 
333     function priceOf(uint256 _tokenId) public view returns (uint256 _price) {
334         return tokenIdToPrice[_tokenId];
335     }
336 
337     uint256 private increaseLimit1 = 0.001 ether;
338     uint256 private increaseLimit2 = 0.05 ether;
339     uint256 private increaseLimit3 = 0.1 ether;
340     uint256 private increaseLimit4 = 1.0 ether;
341 
342     function nextPriceOf(uint256 _tokenId) public view returns (uint256 _nextPrice) {
343         uint256 _price = priceOf(_tokenId);
344         if (_price < increaseLimit1) {
345             return _price.mul(200).div(95);
346         } else if (_price < increaseLimit2) {
347             return _price.mul(135).div(96);
348         } else if (_price < increaseLimit3) {
349             return _price.mul(125).div(97);
350         } else if (_price < increaseLimit4) {
351             return _price.mul(117).div(97);
352         } else {
353             return _price.mul(115).div(98);
354         }
355     }
356 
357 
358     /*** ERC-721 ***/
359     // Unlocks ERC721 behaviour, allowing for trading on third party platforms.
360     function enableERC721() onlyCEO public {
361         erc721Enabled = true;
362     }
363 
364     function totalSupply() public view returns (uint256 _totalSupply) {
365         _totalSupply = adrians.length;
366     }
367 
368     function balanceOf(address _owner) public view returns (uint256 _balance) {
369         _balance = ownershipTokenCount[_owner];
370     }
371 
372     function ownerOf(uint256 _tokenId) public view returns (address _owner) {
373         _owner = tokenIdToOwner[_tokenId];
374         // require(_owner != address(0));
375     }
376 
377     function approve(address _to, uint256 _tokenId) public whenNotPaused onlyERC721 {
378         require(_owns(msg.sender, _tokenId));
379 
380         tokenIdToApproved[_tokenId] = _to;
381 
382         Approval(msg.sender, _to, _tokenId);
383     }
384 
385     function transferFrom(address _from, address _to, uint256 _tokenId) public whenNotPaused onlyERC721 {
386         require(_to != address(0));
387         require(_owns(_from, _tokenId));
388         require(_approved(msg.sender, _tokenId));
389 
390         _transfer(_from, _to, _tokenId);
391     }
392 
393     function transfer(address _to, uint256 _tokenId) public whenNotPaused onlyERC721 {
394         require(_to != address(0));
395         require(_owns(msg.sender, _tokenId));
396 
397         // Reassign ownership, clear pending approvals, emit Transfer event.
398         _transfer(msg.sender, _to, _tokenId);
399     }
400 
401     function implementsERC721() public view whenNotPaused returns (bool) {
402         return erc721Enabled;
403     }
404 
405     function takeOwnership(uint256 _tokenId) public whenNotPaused onlyERC721 {
406         require(_approved(msg.sender, _tokenId));
407 
408         _transfer(tokenIdToOwner[_tokenId], msg.sender, _tokenId);
409     }
410 
411     function name() public view returns (string _name) {
412         _name = "CryptoAdrian";
413     }
414 
415     function symbol() public view returns (string _symbol) {
416         _symbol = "CRPA";
417     }
418 
419     /*** PRIVATES ***/
420     /// @dev Check for token ownership.
421     function _owns(address _claimant, uint256 _tokenId) private view returns (bool) {
422         return tokenIdToOwner[_tokenId] == _claimant;
423     }
424 
425     /// @dev For checking approval of transfer for address _to.
426     function _approved(address _to, uint256 _tokenId) private view returns (bool) {
427         return tokenIdToApproved[_tokenId] == _to;
428     }
429 
430     /// @dev Assigns ownership of a specific token to an address.
431     function _transfer(address _from, address _to, uint256 _tokenId) private {
432         // Since the number of tokens is capped to 2^32 we can't overflow this
433         ownershipTokenCount[_to]++;
434         // Transfer ownership
435         tokenIdToOwner[_tokenId] = _to;
436 
437         // When creating new token _from is 0x0, but we can't account that address.
438         if (_from != address(0)) {
439             ownershipTokenCount[_from]--;
440             // clear any previously approved ownership exchange
441             delete tokenIdToApproved[_tokenId];
442         }
443 
444         // Emit the transfer event.
445         Transfer(_from, _to, _tokenId);
446     }
447 
448     /// @dev Checks if the address ia a contract or not
449     function _isContract(address addr) private view returns (bool) {
450         uint256 size;
451         assembly { size := extcodesize(addr) }
452         return size > 0;
453     }
454 }
455 
456 
457 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
458 // v1.6.0
459 
460 /**
461  * @title SafeMath
462  * @dev Math operations with safety checks that throw on error
463  */
464 library SafeMath {
465 
466     /**
467     * @dev Multiplies two numbers, throws on overflow.
468     */
469     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
470         if (a == 0) {
471         return 0;
472         }
473         uint256 c = a * b;
474         assert(c / a == b);
475         return c;
476     }
477 
478     /**
479     * @dev Integer division of two numbers, truncating the quotient.
480     */
481     function div(uint256 a, uint256 b) internal pure returns (uint256) {
482         // assert(b > 0); // Solidity automatically throws when dividing by 0
483         uint256 c = a / b;
484         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
485         return c;
486     }
487 
488     /**
489     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
490     */
491     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
492         assert(b <= a);
493         return a - b;
494     }
495 
496     /**
497     * @dev Adds two numbers, throws on overflow.
498     */
499     function add(uint256 a, uint256 b) internal pure returns (uint256) {
500         uint256 c = a + b;
501         assert(c >= a);
502         return c;
503     }
504 }