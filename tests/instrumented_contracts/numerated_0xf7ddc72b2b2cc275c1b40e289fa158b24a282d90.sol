1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/token/ERC721/ERC721.sol
46 
47 /**
48  * @title ERC721 interface
49  * @dev see https://github.com/ethereum/eips/issues/721
50  */
51 contract ERC721 {
52   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
53   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
54 
55   function balanceOf(address _owner) public view returns (uint256 _balance);
56   function ownerOf(uint256 _tokenId) public view returns (address _owner);
57   function transfer(address _to, uint256 _tokenId) public;
58   function approve(address _to, uint256 _tokenId) public;
59   function takeOwnership(uint256 _tokenId) public;
60 }
61 
62 // File: contracts/Marketplace.sol
63 
64 contract Marketplace is Ownable {
65     ERC721 public nft;
66 
67     mapping (uint256 => Listing) public listings;
68 
69     uint256 public minListingSeconds;
70     uint256 public maxListingSeconds;
71 
72     struct Listing {
73         address seller;
74         uint256 startingPrice;
75         uint256 minimumPrice;
76         uint256 createdAt;
77         uint256 durationSeconds;
78     }
79 
80     event TokenListed(uint256 indexed _tokenId, uint256 _startingPrice, uint256 _minimumPrice, uint256 _durationSeconds, address _seller);
81     event TokenUnlisted(uint256 indexed _tokenId, address _unlister);
82     event TokenSold(uint256 indexed _tokenId, uint256 _price, uint256 _paidAmount, address indexed _seller, address _buyer);
83 
84     modifier nftOnly() {
85         require(msg.sender == address(nft));
86         _;
87     }
88 
89     function Marketplace(ERC721 _nft, uint256 _minListingSeconds, uint256 _maxListingSeconds) public {
90         nft = _nft;
91         minListingSeconds = _minListingSeconds;
92         maxListingSeconds = _maxListingSeconds;
93     }
94 
95     function list(address _tokenSeller, uint256 _tokenId, uint256 _startingPrice, uint256 _minimumPrice, uint256 _durationSeconds) public nftOnly {
96         require(_durationSeconds >= minListingSeconds && _durationSeconds <= maxListingSeconds);
97         require(_startingPrice >= _minimumPrice);
98         require(! listingActive(_tokenId));
99         listings[_tokenId] = Listing(_tokenSeller, _startingPrice, _minimumPrice, now, _durationSeconds);
100         nft.takeOwnership(_tokenId);
101         TokenListed(_tokenId, _startingPrice, _minimumPrice, _durationSeconds, _tokenSeller);
102     }
103 
104     function unlist(address _caller, uint256 _tokenId) public nftOnly {
105         address _seller = listings[_tokenId].seller;
106         // Allow owner to unlist (via nft) for when it's time to shut this down
107         require(_seller == _caller || address(owner) == _caller);
108         nft.transfer(_seller, _tokenId);
109         delete listings[_tokenId];
110         TokenUnlisted(_tokenId, _caller);
111     }
112 
113     function purchase(address _caller, uint256 _tokenId, uint256 _totalPaid) public payable nftOnly {
114         Listing memory _listing = listings[_tokenId];
115         address _seller = _listing.seller;
116 
117         require(_caller != _seller); // Doesn't make sense for someone to buy/sell their own token.
118         require(listingActive(_tokenId));
119 
120         uint256 _price = currentPrice(_tokenId);
121         require(_totalPaid >= _price);
122 
123         delete listings[_tokenId];
124 
125         nft.transfer(_caller, _tokenId);
126         _seller.transfer(msg.value);
127         TokenSold(_tokenId, _price, _totalPaid, _seller, _caller);
128     }
129 
130     function currentPrice(uint256 _tokenId) public view returns (uint256) {
131         Listing memory listing = listings[_tokenId];
132         require(now >= listing.createdAt);
133 
134         uint256 _deadline = listing.createdAt + listing.durationSeconds;
135         require(now <= _deadline);
136 
137         uint256 _elapsedTime = now - listing.createdAt;
138         uint256 _progress = (_elapsedTime * 100) / listing.durationSeconds;
139         uint256 _delta = listing.startingPrice - listing.minimumPrice;
140         return listing.startingPrice - ((_delta * _progress) / 100);
141     }
142 
143     function listingActive(uint256 _tokenId) internal view returns (bool) {
144         Listing memory listing = listings[_tokenId];
145         return listing.createdAt + listing.durationSeconds >= now && now >= listing.createdAt;
146     }
147 }
148 
149 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
150 
151 /**
152  * @title Pausable
153  * @dev Base contract which allows children to implement an emergency stop mechanism.
154  */
155 contract Pausable is Ownable {
156   event Pause();
157   event Unpause();
158 
159   bool public paused = false;
160 
161 
162   /**
163    * @dev Modifier to make a function callable only when the contract is not paused.
164    */
165   modifier whenNotPaused() {
166     require(!paused);
167     _;
168   }
169 
170   /**
171    * @dev Modifier to make a function callable only when the contract is paused.
172    */
173   modifier whenPaused() {
174     require(paused);
175     _;
176   }
177 
178   /**
179    * @dev called by the owner to pause, triggers stopped state
180    */
181   function pause() onlyOwner whenNotPaused public {
182     paused = true;
183     Pause();
184   }
185 
186   /**
187    * @dev called by the owner to unpause, returns to normal state
188    */
189   function unpause() onlyOwner whenPaused public {
190     paused = false;
191     Unpause();
192   }
193 }
194 
195 // File: zeppelin-solidity/contracts/math/SafeMath.sol
196 
197 /**
198  * @title SafeMath
199  * @dev Math operations with safety checks that throw on error
200  */
201 library SafeMath {
202 
203   /**
204   * @dev Multiplies two numbers, throws on overflow.
205   */
206   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
207     if (a == 0) {
208       return 0;
209     }
210     uint256 c = a * b;
211     assert(c / a == b);
212     return c;
213   }
214 
215   /**
216   * @dev Integer division of two numbers, truncating the quotient.
217   */
218   function div(uint256 a, uint256 b) internal pure returns (uint256) {
219     // assert(b > 0); // Solidity automatically throws when dividing by 0
220     uint256 c = a / b;
221     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222     return c;
223   }
224 
225   /**
226   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
227   */
228   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
229     assert(b <= a);
230     return a - b;
231   }
232 
233   /**
234   * @dev Adds two numbers, throws on overflow.
235   */
236   function add(uint256 a, uint256 b) internal pure returns (uint256) {
237     uint256 c = a + b;
238     assert(c >= a);
239     return c;
240   }
241 }
242 
243 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
244 
245 /**
246  * @title ERC721Token
247  * Generic implementation for the required functionality of the ERC721 standard
248  */
249 contract ERC721Token is ERC721 {
250   using SafeMath for uint256;
251 
252   // Total amount of tokens
253   uint256 private totalTokens;
254 
255   // Mapping from token ID to owner
256   mapping (uint256 => address) private tokenOwner;
257 
258   // Mapping from token ID to approved address
259   mapping (uint256 => address) private tokenApprovals;
260 
261   // Mapping from owner to list of owned token IDs
262   mapping (address => uint256[]) private ownedTokens;
263 
264   // Mapping from token ID to index of the owner tokens list
265   mapping(uint256 => uint256) private ownedTokensIndex;
266 
267   /**
268   * @dev Guarantees msg.sender is owner of the given token
269   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
270   */
271   modifier onlyOwnerOf(uint256 _tokenId) {
272     require(ownerOf(_tokenId) == msg.sender);
273     _;
274   }
275 
276   /**
277   * @dev Gets the total amount of tokens stored by the contract
278   * @return uint256 representing the total amount of tokens
279   */
280   function totalSupply() public view returns (uint256) {
281     return totalTokens;
282   }
283 
284   /**
285   * @dev Gets the balance of the specified address
286   * @param _owner address to query the balance of
287   * @return uint256 representing the amount owned by the passed address
288   */
289   function balanceOf(address _owner) public view returns (uint256) {
290     return ownedTokens[_owner].length;
291   }
292 
293   /**
294   * @dev Gets the list of tokens owned by a given address
295   * @param _owner address to query the tokens of
296   * @return uint256[] representing the list of tokens owned by the passed address
297   */
298   function tokensOf(address _owner) public view returns (uint256[]) {
299     return ownedTokens[_owner];
300   }
301 
302   /**
303   * @dev Gets the owner of the specified token ID
304   * @param _tokenId uint256 ID of the token to query the owner of
305   * @return owner address currently marked as the owner of the given token ID
306   */
307   function ownerOf(uint256 _tokenId) public view returns (address) {
308     address owner = tokenOwner[_tokenId];
309     require(owner != address(0));
310     return owner;
311   }
312 
313   /**
314    * @dev Gets the approved address to take ownership of a given token ID
315    * @param _tokenId uint256 ID of the token to query the approval of
316    * @return address currently approved to take ownership of the given token ID
317    */
318   function approvedFor(uint256 _tokenId) public view returns (address) {
319     return tokenApprovals[_tokenId];
320   }
321 
322   /**
323   * @dev Transfers the ownership of a given token ID to another address
324   * @param _to address to receive the ownership of the given token ID
325   * @param _tokenId uint256 ID of the token to be transferred
326   */
327   function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
328     clearApprovalAndTransfer(msg.sender, _to, _tokenId);
329   }
330 
331   /**
332   * @dev Approves another address to claim for the ownership of the given token ID
333   * @param _to address to be approved for the given token ID
334   * @param _tokenId uint256 ID of the token to be approved
335   */
336   function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
337     address owner = ownerOf(_tokenId);
338     require(_to != owner);
339     if (approvedFor(_tokenId) != 0 || _to != 0) {
340       tokenApprovals[_tokenId] = _to;
341       Approval(owner, _to, _tokenId);
342     }
343   }
344 
345   /**
346   * @dev Claims the ownership of a given token ID
347   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
348   */
349   function takeOwnership(uint256 _tokenId) public {
350     require(isApprovedFor(msg.sender, _tokenId));
351     clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
352   }
353 
354   /**
355   * @dev Mint token function
356   * @param _to The address that will own the minted token
357   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
358   */
359   function _mint(address _to, uint256 _tokenId) internal {
360     require(_to != address(0));
361     addToken(_to, _tokenId);
362     Transfer(0x0, _to, _tokenId);
363   }
364 
365   /**
366   * @dev Burns a specific token
367   * @param _tokenId uint256 ID of the token being burned by the msg.sender
368   */
369   function _burn(uint256 _tokenId) onlyOwnerOf(_tokenId) internal {
370     if (approvedFor(_tokenId) != 0) {
371       clearApproval(msg.sender, _tokenId);
372     }
373     removeToken(msg.sender, _tokenId);
374     Transfer(msg.sender, 0x0, _tokenId);
375   }
376 
377   /**
378    * @dev Tells whether the msg.sender is approved for the given token ID or not
379    * This function is not private so it can be extended in further implementations like the operatable ERC721
380    * @param _owner address of the owner to query the approval of
381    * @param _tokenId uint256 ID of the token to query the approval of
382    * @return bool whether the msg.sender is approved for the given token ID or not
383    */
384   function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
385     return approvedFor(_tokenId) == _owner;
386   }
387 
388   /**
389   * @dev Internal function to clear current approval and transfer the ownership of a given token ID
390   * @param _from address which you want to send tokens from
391   * @param _to address which you want to transfer the token to
392   * @param _tokenId uint256 ID of the token to be transferred
393   */
394   function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
395     require(_to != address(0));
396     require(_to != ownerOf(_tokenId));
397     require(ownerOf(_tokenId) == _from);
398 
399     clearApproval(_from, _tokenId);
400     removeToken(_from, _tokenId);
401     addToken(_to, _tokenId);
402     Transfer(_from, _to, _tokenId);
403   }
404 
405   /**
406   * @dev Internal function to clear current approval of a given token ID
407   * @param _tokenId uint256 ID of the token to be transferred
408   */
409   function clearApproval(address _owner, uint256 _tokenId) private {
410     require(ownerOf(_tokenId) == _owner);
411     tokenApprovals[_tokenId] = 0;
412     Approval(_owner, 0, _tokenId);
413   }
414 
415   /**
416   * @dev Internal function to add a token ID to the list of a given address
417   * @param _to address representing the new owner of the given token ID
418   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
419   */
420   function addToken(address _to, uint256 _tokenId) private {
421     require(tokenOwner[_tokenId] == address(0));
422     tokenOwner[_tokenId] = _to;
423     uint256 length = balanceOf(_to);
424     ownedTokens[_to].push(_tokenId);
425     ownedTokensIndex[_tokenId] = length;
426     totalTokens = totalTokens.add(1);
427   }
428 
429   /**
430   * @dev Internal function to remove a token ID from the list of a given address
431   * @param _from address representing the previous owner of the given token ID
432   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
433   */
434   function removeToken(address _from, uint256 _tokenId) private {
435     require(ownerOf(_tokenId) == _from);
436 
437     uint256 tokenIndex = ownedTokensIndex[_tokenId];
438     uint256 lastTokenIndex = balanceOf(_from).sub(1);
439     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
440 
441     tokenOwner[_tokenId] = 0;
442     ownedTokens[_from][tokenIndex] = lastToken;
443     ownedTokens[_from][lastTokenIndex] = 0;
444     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
445     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
446     // the lastToken to the first position, and then dropping the element placed in the last position of the list
447 
448     ownedTokens[_from].length--;
449     ownedTokensIndex[_tokenId] = 0;
450     ownedTokensIndex[lastToken] = tokenIndex;
451     totalTokens = totalTokens.sub(1);
452   }
453 }
454 
455 // File: contracts/PineappleArcadeTrophy.sol
456 
457 contract PineappleArcadeTrophy is ERC721Token, Pausable {
458     /// @notice Name and Symbol are part of the ERC721 standard
459     string public constant name = "PineappleArcadeTrophy";
460     string public constant symbol = "DEGEN";
461 
462     Marketplace public marketplace;
463     uint256 public maxTrophies;
464 
465     /// @dev trophyId to trophyName
466     mapping (uint256 => bytes32) public trophies;
467 
468     function PineappleArcadeTrophy(uint256 _maxTrophies) public {
469         maxTrophies = _maxTrophies;
470         pause();
471     }
472 
473     function setMarketplace(Marketplace _marketplace) external onlyOwner {
474         marketplace = _marketplace;
475     }
476 
477     function grantTrophy(address _initialOwner, bytes32 _trophyName) external onlyOwner {
478         require(totalSupply() < maxTrophies);
479         require(_trophyName != 0x0);
480         trophies[nextId()] = _trophyName;
481         _mint(_initialOwner, nextId());
482     }
483 
484     function listTrophy(uint256 _trophyId, uint256 _startingPriceWei, uint256 _minimumPriceWei, uint256 _durationSeconds) external whenNotPaused {
485         address _trophySeller = ownerOf(_trophyId);
486         require(_trophySeller == msg.sender);
487         approve(marketplace, _trophyId);
488         marketplace.list(_trophySeller, _trophyId, _startingPriceWei, _minimumPriceWei, _durationSeconds);
489     }
490 
491     function unlistTrophy(uint256 _trophyId) external {
492         marketplace.unlist(msg.sender, _trophyId);
493     }
494 
495     function currentPrice(uint256 _trophyId) public view returns(uint256) {
496         return marketplace.currentPrice(_trophyId);
497     }
498 
499     function purchaseTrophy(uint256 _trophyId) external payable whenNotPaused {
500         // Blockade collects 3.75% of each market transaction, paid by the seller.
501         uint256 _blockadeFee = (msg.value * 375) / 10000; // Note: small values prevent Blockade from earning anything
502         uint256 _sellerTake = msg.value - _blockadeFee;
503         marketplace.purchase.value(_sellerTake)(msg.sender, _trophyId, msg.value);
504     }
505 
506     /// @notice With each call to purchaseTrophy, fees will build up in this contract's balance.
507     /// This method allows the contract owner to transfer that balance to their account.
508     function withdrawBalance() external onlyOwner {
509         owner.transfer(this.balance);
510     }
511 
512     function nextId() internal view returns (uint256) {
513         return totalSupply() + 1;
514     }
515 }