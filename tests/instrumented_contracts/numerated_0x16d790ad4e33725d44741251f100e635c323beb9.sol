1 // OwnTheDay-Token Source code
2 // copyright 2018 xeroblood <https://owntheday.io>
3 
4 pragma solidity 0.4.19;
5 
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13     /**
14     * @dev Multiplies two numbers, throws on overflow.
15     */
16     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17         if (a == 0) {
18             return 0;
19         }
20         uint256 c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return c;
33     }
34 
35     /**
36     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44     * @dev Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 
54 /**
55 * @title Ownable
56 * @dev The Ownable contract has an owner address, and provides basic authorization control
57 * functions, this simplifies the implementation of "user permissions".
58 */
59 contract Ownable {
60     address public owner;
61 
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     /**
65     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
66     * account.
67     */
68     function Ownable() public {
69         owner = msg.sender;
70     }
71 
72     /**
73     * @dev Throws if called by any account other than the owner.
74     */
75     modifier onlyOwner() {
76         require(msg.sender == owner);
77         _;
78     }
79 
80     /**
81     * @dev Allows the current owner to transfer control of the contract to a newOwner.
82     * @param newOwner The address to transfer ownership to.
83     */
84     function transferOwnership(address newOwner) public onlyOwner {
85         require(newOwner != address(0));
86         OwnershipTransferred(owner, newOwner);
87         owner = newOwner;
88     }
89 
90     /* Withdraw */
91     /*
92     NOTICE: These functions withdraw the developer's cut which is left
93     in the contract. User funds are immediately sent to the old
94     owner in `claimDay`, no user funds are left in the contract.
95     */
96     function withdrawAll() public onlyOwner {
97         owner.transfer(this.balance);
98     }
99 
100     function withdrawAmount(uint256 _amount) public onlyOwner {
101         require(_amount <= this.balance);
102         owner.transfer(_amount);
103     }
104 
105     function contractBalance() public view returns (uint256) {
106         return this.balance;
107     }
108 }
109 
110 
111 /**
112 * @title Pausable
113 * @dev Base contract which allows children to implement an emergency stop mechanism.
114 */
115 contract Pausable is Ownable {
116     event Pause();
117     event Unpause();
118 
119     bool public paused = false;
120 
121     /**
122     * @dev Modifier to make a function callable only when the contract is not paused.
123     */
124     modifier whenNotPaused() {
125         require(!paused);
126         _;
127     }
128 
129     /**
130     * @dev Modifier to make a function callable only when the contract is paused.
131     */
132     modifier whenPaused() {
133         require(paused);
134         _;
135     }
136 
137     /**
138     * @dev called by the owner to pause, triggers stopped state
139     */
140     function pause() public onlyOwner whenNotPaused {
141         paused = true;
142         Pause();
143     }
144 
145     /**
146     * @dev called by the owner to unpause, returns to normal state
147     */
148     function unpause() public onlyOwner whenPaused {
149         paused = false;
150         Unpause();
151     }
152 }
153 
154 
155 /**
156 * @title Helps contracts guard agains reentrancy attacks.
157 * @author Remco Bloemen <remco@2π.com>
158 * @notice If you mark a function `nonReentrant`, you should also
159 * mark it `external`.
160 */
161 contract ReentrancyGuard {
162 
163     /**
164     * @dev We use a single lock for the whole contract.
165     */
166     bool private reentrancyLock = false;
167 
168     /**
169     * @dev Prevents a contract from calling itself, directly or indirectly.
170     * @notice If you mark a function `nonReentrant`, you should also
171     * mark it `external`. Calling one nonReentrant function from
172     * another is not supported. Instead, you can implement a
173     * `private` function doing the actual work, and a `external`
174     * wrapper marked as `nonReentrant`.
175     */
176     modifier nonReentrant() {
177         require(!reentrancyLock);
178         reentrancyLock = true;
179         _;
180         reentrancyLock = false;
181     }
182 
183 }
184 
185 
186 /**
187 * @title ERC721 interface
188 * @dev see https://github.com/ethereum/eips/issues/721
189 */
190 contract ERC721 {
191     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
192     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
193 
194     function balanceOf(address _owner) public view returns (uint256 _balance);
195     function ownerOf(uint256 _tokenId) public view returns (address _owner);
196     function transfer(address _to, uint256 _tokenId) public;
197     function approve(address _to, uint256 _tokenId) public;
198     function takeOwnership(uint256 _tokenId) public;
199 }
200 
201 
202 /// @title Own the Day!
203 /// @author xeroblood (https://owntheday.io)
204 contract OwnTheDayContract is ERC721, Pausable, ReentrancyGuard {
205     using SafeMath for uint256;
206 
207     event Bought (uint256 indexed _dayIndex, address indexed _owner, uint256 _price);
208     event Sold (uint256 indexed _dayIndex, address indexed _owner, uint256 _price);
209 
210     // Total amount of tokens
211     uint256 private totalTokens;
212     bool private migrationFinished = false;
213 
214     // Mapping from token ID to owner
215     mapping (uint256 => address) public tokenOwner;
216 
217     // Mapping from token ID to approved address
218     mapping (uint256 => address) public tokenApprovals;
219 
220     // Mapping from owner to list of owned token IDs
221     mapping (address => uint256[]) public ownedTokens;
222 
223     // Mapping from token ID to index of the owner tokens list
224     mapping(uint256 => uint256) public ownedTokensIndex;
225 
226     /// @dev A mapping from Day Index to Current Price.
227     ///  Initial Price set at 1 finney (1/1000th of an ether).
228     mapping (uint256 => uint256) public dayIndexToPrice;
229 
230     /// @dev A mapping from Day Index to the address owner. Days with
231     ///  no valid owner address are assigned to contract owner.
232     //mapping (uint256 => address) public dayIndexToOwner;      // <---  redundant with tokenOwner
233 
234     /// @dev A mapping from Account Address to Nickname.
235     mapping (address => string) public ownerAddressToName;
236 
237     /**
238     * @dev Guarantees msg.sender is owner of the given token
239     * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
240     */
241     modifier onlyOwnerOf(uint256 _tokenId) {
242         require(ownerOf(_tokenId) == msg.sender);
243         _;
244     }
245 
246     modifier onlyDuringMigration() {
247         require(!migrationFinished);
248         _;
249     }
250 
251     function name() public pure returns (string _name) {
252         return "OwnTheDay.io Days";
253     }
254 
255     function symbol() public pure returns (string _symbol) {
256         return "DAYS";
257     }
258 
259     /// @dev Assigns initial days to owners during minting period.
260     /// This is only used during migration from old contract to new contract (this one).
261     function assignInitialDays(address _to, uint256 _tokenId, uint256 _price) public onlyOwner onlyDuringMigration {
262         require(msg.sender != address(0));
263         require(_to != address(0));
264         require(_tokenId >= 0 && _tokenId < 366);
265         require(_price >= 1 finney);
266         dayIndexToPrice[_tokenId] = _price;
267         _mint(_to, _tokenId);
268     }
269 
270     function finishMigration() public onlyOwner {
271         require(!migrationFinished);
272         migrationFinished = true;
273     }
274 
275     function isMigrationFinished() public view returns (bool) {
276         return migrationFinished;
277     }
278 
279     /**
280     * @dev Gets the total amount of tokens stored by the contract
281     * @return uint256 representing the total amount of tokens
282     */
283     function totalSupply() public view returns (uint256) {
284         return totalTokens;
285     }
286 
287     /**
288     * @dev Gets the balance of the specified address
289     * @param _owner address to query the balance of
290     * @return uint256 representing the amount owned by the passed address
291     */
292     function balanceOf(address _owner) public view returns (uint256) {
293         return ownedTokens[_owner].length;
294     }
295 
296     /**
297     * @dev Gets the list of tokens owned by a given address
298     * @param _owner address to query the tokens of
299     * @return uint256[] representing the list of tokens owned by the passed address
300     */
301     function tokensOf(address _owner) public view returns (uint256[]) {
302         return ownedTokens[_owner];
303     }
304 
305     /**
306     * @dev Gets the owner of the specified token ID
307     * @param _tokenId uint256 ID of the token to query the owner of
308     * @return owner address currently marked as the owner of the given token ID
309     */
310     function ownerOf(uint256 _tokenId) public view returns (address) {
311         address owner = tokenOwner[_tokenId];
312         return owner;
313     }
314 
315     /**
316     * @dev Gets the approved address to take ownership of a given token ID
317     * @param _tokenId uint256 ID of the token to query the approval of
318     * @return address currently approved to take ownership of the given token ID
319     */
320     function approvedFor(uint256 _tokenId) public view returns (address) {
321         return tokenApprovals[_tokenId];
322     }
323 
324     /**
325     * @dev Transfers the ownership of a given token ID to another address
326     * @param _to address to receive the ownership of the given token ID
327     * @param _tokenId uint256 ID of the token to be transferred
328     */
329     function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
330         clearApprovalAndTransfer(msg.sender, _to, _tokenId);
331     }
332 
333     /**
334     * @dev Approves another address to claim for the ownership of the given token ID
335     * @param _to address to be approved for the given token ID
336     * @param _tokenId uint256 ID of the token to be approved
337     */
338     function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
339         address owner = ownerOf(_tokenId);
340         require(_to != owner);
341         if (approvedFor(_tokenId) != 0 || _to != 0) {
342             tokenApprovals[_tokenId] = _to;
343             Approval(owner, _to, _tokenId);
344         }
345     }
346 
347     /**
348     * @dev Claims the ownership of a given token ID
349     * @param _tokenId uint256 ID of the token being claimed by the msg.sender
350     */
351     function takeOwnership(uint256 _tokenId) public {
352         require(isApprovedFor(msg.sender, _tokenId));
353         clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
354     }
355 
356     /// @dev Calculate the Final Sale Price after the Owner-Cut has been calculated
357     function calculateOwnerCut(uint256 _price) public pure returns (uint256) {
358         if (_price > 5000 finney) {
359             return _price.mul(2).div(100);
360         } else if (_price > 500 finney) {
361             return _price.mul(3).div(100);
362         } else if (_price > 250 finney) {
363             return _price.mul(4).div(100);
364         }
365         return _price.mul(5).div(100);
366     }
367 
368     /// @dev Calculate the Price Increase based on the current Purchase Price
369     function calculatePriceIncrease(uint256 _price) public pure returns (uint256) {
370         if (_price > 5000 finney) {
371             return _price.mul(15).div(100);
372         } else if (_price > 2500 finney) {
373             return _price.mul(18).div(100);
374         } else if (_price > 500 finney) {
375             return _price.mul(26).div(100);
376         } else if (_price > 250 finney) {
377             return _price.mul(36).div(100);
378         }
379         return _price; // 100% increase
380     }
381 
382     /// @dev Gets the Current (or Default) Price of a Day
383     function getPriceByDayIndex(uint256 _dayIndex) public view returns (uint256) {
384         require(_dayIndex >= 0 && _dayIndex < 366);
385         uint256 price = dayIndexToPrice[_dayIndex];
386         if (price == 0) { price = 1 finney; }
387         return price;
388     }
389 
390     /// @dev Sets the Nickname for an Account Address
391     function setAccountNickname(string _nickname) public whenNotPaused {
392         require(msg.sender != address(0));
393         require(bytes(_nickname).length > 0);
394         ownerAddressToName[msg.sender] = _nickname;
395     }
396 
397     /// @dev Claim a Day for Your Very Own!
398     /// The Purchase Price is Paid to the Previous Owner
399     function claimDay(uint256 _dayIndex) public nonReentrant whenNotPaused payable {
400         require(msg.sender != address(0));
401         require(_dayIndex >= 0 && _dayIndex < 366);
402 
403         address buyer = msg.sender;
404         address seller = tokenOwner[_dayIndex];
405         require(msg.sender != seller); // Prevent buying from self
406 
407         uint256 amountPaid = msg.value;
408         uint256 purchasePrice = dayIndexToPrice[_dayIndex];
409         if (purchasePrice == 0) {
410             purchasePrice = 1 finney; // == 0.001 ether or 1000000000000000 wei
411         }
412         require(amountPaid >= purchasePrice);
413 
414         // If too much was paid, track the change to be returned
415         uint256 changeToReturn = 0;
416         if (amountPaid > purchasePrice) {
417             changeToReturn = amountPaid.sub(purchasePrice);
418             amountPaid -= changeToReturn;
419         }
420 
421         // Calculate New Purchase Price and update storage
422         uint256 priceIncrease = calculatePriceIncrease(purchasePrice);
423         uint256 newPurchasePrice = purchasePrice.add(priceIncrease);
424         dayIndexToPrice[_dayIndex] = newPurchasePrice;
425 
426         // Calculate Sale Price after Dev-Cut
427         //  - Dev-Cut is left in the contract
428         //  - Sale Price is transfered to seller immediately
429         uint256 ownerCut = calculateOwnerCut(amountPaid);
430         uint256 salePrice = amountPaid.sub(ownerCut);
431 
432         // Fire Claim Events
433         Bought(_dayIndex, buyer, purchasePrice);
434         Sold(_dayIndex, seller, purchasePrice);
435 
436         // Transfer token
437         if (seller == address(0)) {
438             _mint(buyer, _dayIndex);
439         } else {
440             clearApprovalAndTransfer(seller, buyer, _dayIndex);
441         }
442 
443         // Transfer Funds
444         if (seller != address(0)) {
445             seller.transfer(salePrice);
446         }
447         if (changeToReturn > 0) {
448             buyer.transfer(changeToReturn);
449         }
450     }
451 
452     /**
453     * @dev Mint token function
454     * @param _to The address that will own the minted token
455     * @param _tokenId uint256 ID of the token to be minted by the msg.sender
456     */
457     function _mint(address _to, uint256 _tokenId) internal {
458         require(_to != address(0));
459         addToken(_to, _tokenId);
460         Transfer(0x0, _to, _tokenId);
461     }
462 
463     /**
464     * @dev Tells whether the msg.sender is approved for the given token ID or not
465     * This function is not private so it can be extended in further implementations like the operatable ERC721
466     * @param _owner address of the owner to query the approval of
467     * @param _tokenId uint256 ID of the token to query the approval of
468     * @return bool whether the msg.sender is approved for the given token ID or not
469     */
470     function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
471         return approvedFor(_tokenId) == _owner;
472     }
473 
474     /**
475     * @dev Internal function to clear current approval and transfer the ownership of a given token ID
476     * @param _from address which you want to send tokens from
477     * @param _to address which you want to transfer the token to
478     * @param _tokenId uint256 ID of the token to be transferred
479     */
480     function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
481         require(_to != address(0));
482         require(_to != ownerOf(_tokenId));
483         require(ownerOf(_tokenId) == _from);
484 
485         clearApproval(_from, _tokenId);
486         removeToken(_from, _tokenId);
487         addToken(_to, _tokenId);
488         Transfer(_from, _to, _tokenId);
489     }
490 
491     /**
492     * @dev Internal function to clear current approval of a given token ID
493     * @param _tokenId uint256 ID of the token to be transferred
494     */
495     function clearApproval(address _owner, uint256 _tokenId) private {
496         require(ownerOf(_tokenId) == _owner);
497         tokenApprovals[_tokenId] = 0;
498         Approval(_owner, 0, _tokenId);
499     }
500 
501     /**
502     * @dev Internal function to add a token ID to the list of a given address
503     * @param _to address representing the new owner of the given token ID
504     * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
505     */
506     function addToken(address _to, uint256 _tokenId) private {
507         require(tokenOwner[_tokenId] == address(0));
508         tokenOwner[_tokenId] = _to;
509         uint256 length = balanceOf(_to);
510         ownedTokens[_to].push(_tokenId);
511         ownedTokensIndex[_tokenId] = length;
512         totalTokens = totalTokens.add(1);
513     }
514 
515     /**
516     * @dev Internal function to remove a token ID from the list of a given address
517     * @param _from address representing the previous owner of the given token ID
518     * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
519     */
520     function removeToken(address _from, uint256 _tokenId) private {
521         require(ownerOf(_tokenId) == _from);
522 
523         uint256 tokenIndex = ownedTokensIndex[_tokenId];
524         uint256 lastTokenIndex = balanceOf(_from).sub(1);
525         uint256 lastToken = ownedTokens[_from][lastTokenIndex];
526 
527         tokenOwner[_tokenId] = 0;
528         ownedTokens[_from][tokenIndex] = lastToken;
529         ownedTokens[_from][lastTokenIndex] = 0;
530         // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are
531         // going to be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we
532         // are first swapping the lastToken to the first position, and then dropping the element placed in the last
533         // position of the list
534 
535         ownedTokens[_from].length--;
536         ownedTokensIndex[_tokenId] = 0;
537         ownedTokensIndex[lastToken] = tokenIndex;
538         totalTokens = totalTokens.sub(1);
539     }
540 }