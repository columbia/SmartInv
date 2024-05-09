1 pragma solidity ^0.4.18;
2 
3 // File: contracts/ERC721.sol
4 
5 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
6 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
7 contract ERC721 {
8     // Required methods
9     function totalSupply() public view returns (uint256 total);
10     function balanceOf(address _owner) public view returns (uint256 balance);
11     function ownerOf(uint256 _tokenId) external view returns (address owner);
12     function approve(address _to, uint256 _tokenId) external;
13     function transfer(address _to, uint256 _tokenId) external;
14     function transferFrom(address _from, address _to, uint256 _tokenId) external;
15 
16     // Events
17     event Transfer(address from, address to, uint256 tokenId);
18     event Approval(address owner, address approved, uint256 tokenId);
19 }
20 
21 // File: contracts/TulipsSaleInterface.sol
22 
23 /*
24 * @title Crypto Tulips Initial Sale Interface
25 * @dev This interface sets the standard for initial sale
26 * contract. All future sale contracts should follow this.
27 */
28 interface TulipsSaleInterface {
29     function putOnInitialSale(uint256 tulipId) external;
30 
31     function createAuction(
32         uint256 _tulipId,
33         uint256 _startingPrice,
34         uint256 _endingPrice,
35         uint256 _duration,
36         address _transferFrom
37     )external;
38 }
39 
40 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
41 
42 /**
43  * @title Ownable
44  * @dev The Ownable contract has an owner address, and provides basic authorization control
45  * functions, this simplifies the implementation of "user permissions".
46  */
47 contract Ownable {
48   address public owner;
49 
50 
51   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53 
54   /**
55    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
56    * account.
57    */
58   function Ownable() public {
59     owner = msg.sender;
60   }
61 
62 
63   /**
64    * @dev Throws if called by any account other than the owner.
65    */
66   modifier onlyOwner() {
67     require(msg.sender == owner);
68     _;
69   }
70 
71 
72   /**
73    * @dev Allows the current owner to transfer control of the contract to a newOwner.
74    * @param newOwner The address to transfer ownership to.
75    */
76   function transferOwnership(address newOwner) public onlyOwner {
77     require(newOwner != address(0));
78     OwnershipTransferred(owner, newOwner);
79     owner = newOwner;
80   }
81 
82 }
83 
84 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
85 
86 /**
87  * @title Pausable
88  * @dev Base contract which allows children to implement an emergency stop mechanism.
89  */
90 contract Pausable is Ownable {
91   event Pause();
92   event Unpause();
93 
94   bool public paused = false;
95 
96 
97   /**
98    * @dev Modifier to make a function callable only when the contract is not paused.
99    */
100   modifier whenNotPaused() {
101     require(!paused);
102     _;
103   }
104 
105   /**
106    * @dev Modifier to make a function callable only when the contract is paused.
107    */
108   modifier whenPaused() {
109     require(paused);
110     _;
111   }
112 
113   /**
114    * @dev called by the owner to pause, triggers stopped state
115    */
116   function pause() onlyOwner whenNotPaused public {
117     paused = true;
118     Pause();
119   }
120 
121   /**
122    * @dev called by the owner to unpause, returns to normal state
123    */
124   function unpause() onlyOwner whenPaused public {
125     paused = false;
126     Unpause();
127   }
128 }
129 
130 // File: contracts/TulipsRoles.sol
131 
132 /*
133 * @title Crypto Tulips SaleAuction
134 * @dev .
135 */
136 contract TulipsRoles is Pausable {
137 
138     modifier onlyFinancial() {
139         require(msg.sender == address(financialAccount));
140         _;
141     }
142 
143     modifier onlyOperations() {
144         require(msg.sender == address(operationsAccount));
145         _;
146     }
147 
148     function TulipsRoles() Ownable() public {
149         financialAccount = msg.sender;
150         operationsAccount = msg.sender;
151     }
152 
153     address public financialAccount;
154     address public operationsAccount;
155 
156     function transferFinancial(address newFinancial) public onlyOwner {
157         require(newFinancial != address(0));
158         financialAccount = newFinancial;
159     }
160 
161     function transferOperations(address newOperations) public onlyOwner {
162         require(newOperations != address(0));
163         operationsAccount = newOperations;
164     }
165 
166 }
167 
168 // File: contracts/TulipsSaleAuction.sol
169 
170 /*
171 * @title Crypto Tulips SaleAuction
172 * @dev .
173 */
174 contract TulipsSaleAuction is TulipsRoles, TulipsSaleInterface {
175 
176     modifier onlyCoreContract() {
177         require(msg.sender == address(coreContract));
178         _;
179     }
180 
181     struct Auction {
182         address seller;
183         uint128 startingPrice;
184         uint128 endingPrice;
185         uint64 duration;
186         uint64 startedAt;
187     }
188 
189     // @dev core contract cannot change due to security reasons
190     ERC721 public coreContract;
191 
192     // Commission cut
193     uint256 public ownerCut;
194 
195     uint256 public initialStartPrice;
196     uint256 public initialEndPrice;
197     uint256 public initialSaleDuration = 1 days;
198 
199     // Map from token ID to their corresponding auction.
200     mapping (uint256 => Auction) public tokenIdToAuction;
201 
202     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
203     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
204     event AuctionCancelled(uint256 tokenId);
205 
206     /*
207     * @dev Constructor initialized with the reference to core Tulips contract
208     * @param _tulipsCoreContract - core contract adress should be fixed
209     * @param _cut - core contract adress should be fixed
210     */
211     function TulipsSaleAuction(address _tulipsCoreContract, uint256 _cut) TulipsRoles() public {
212         require(_cut <= 10000); // cut as percentage between 0.00-100.00%
213         ownerCut = _cut;
214 
215         coreContract = ERC721(_tulipsCoreContract);
216     }
217      /*
218     * @dev These are auction prices for initial tulip sales.
219     */
220     function setDefaultAuctionPrices(uint256 _startPrice, uint256 _endPrice) external onlyFinancial {
221         initialStartPrice = _startPrice;
222         initialEndPrice = _endPrice;
223     }
224 
225     function recievePayout(uint payoutAmount, address payoutAddress) external onlyFinancial {
226         require(payoutAddress != 0);
227         payoutAddress.transfer(payoutAmount);
228     }
229 
230     /*
231     * @dev This function is called from core Contract to put tulip on initial sale.
232     * This is a privilaged version that, recieves request from corecontract.
233     * Core contract ensures that this contract already is the ownerof this tulip
234     */
235     function putOnInitialSale(uint256 _tulipId) external onlyCoreContract {
236         // !! Core contract must ensure the ownership
237         _createAuction(_tulipId, initialStartPrice, initialEndPrice, initialSaleDuration, this);
238     }
239 
240     function createAuction(
241         uint256 _tulipId,
242         uint256 _startingPrice,
243         uint256 _endingPrice,
244         uint256 _duration,
245         address _transferFrom
246     )external
247     {
248         // Avoid input overflowing struct memory sizes
249         require(_startingPrice == uint256(uint128(_startingPrice)));
250         require(_endingPrice == uint256(uint128(_endingPrice)));
251         require(_duration == uint256(uint64(_duration)));
252 
253         // Make sure we have at least a minute for this auction
254         require(_duration >= 1 minutes);
255 
256         require(coreContract.ownerOf(_tulipId) == _transferFrom);
257 
258         // Transfer from checks whether the owner approved this transfer so
259         // we can't transfer tulips without permission
260         coreContract.transferFrom(_transferFrom, this, _tulipId);
261 
262         _createAuction(_tulipId, _startingPrice, _endingPrice, _duration, _transferFrom);
263     }
264 
265 
266 
267     /// @param _tulipId - Id of the tulip to auction.
268     /// @param _startingPrice - Starting price in wei.
269     /// @param _endingPrice - Ending price in wei.
270     /// @param _duration - Duration in seconds.
271     /// @param _seller - Seller address
272     function _createAuction(
273         uint256 _tulipId,
274         uint256 _startingPrice,
275         uint256 _endingPrice,
276         uint256 _duration,
277         address _seller
278     )
279         internal
280     {
281 
282         Auction memory auction = Auction(
283             _seller,
284             uint128(_startingPrice),
285             uint128(_endingPrice),
286             uint64(_duration),
287             uint64(now)
288         );
289 
290         tokenIdToAuction[_tulipId] = auction;
291 
292         AuctionCreated(
293             uint256(_tulipId),
294             uint256(auction.startingPrice),
295             uint256(auction.endingPrice),
296             uint256(auction.duration)
297         );
298     }
299 
300 
301     /*
302     * @dev Cancel auction and return tulip to original owner.
303     * @param _tulipId - ID of the tulip on auction
304     */
305     function cancelAuction(uint256 _tulipId)
306         external
307     {
308         Auction storage auction = tokenIdToAuction[_tulipId];
309         require(auction.startedAt > 0);
310 
311         // Only seller can call this function
312         address seller = auction.seller;
313         require(msg.sender == seller);
314 
315         // Return the tulip to the owner
316         coreContract.transfer(seller, _tulipId);
317 
318         // Remove auction from storage
319         delete tokenIdToAuction[_tulipId];
320 
321         AuctionCancelled(_tulipId);
322     }
323 
324     function buy(uint256 _tulipId)
325         external
326         payable
327         whenNotPaused
328     {
329         Auction storage auction = tokenIdToAuction[_tulipId];
330 
331         require(auction.startedAt > 0);
332 
333         uint256 price = _currentPrice(auction);
334         require(msg.value >= price);
335 
336         address seller = auction.seller;
337 
338         delete tokenIdToAuction[_tulipId];
339 
340         // We don't calculate auctioneers if the seller is us.
341         if (price > 0 && seller != address(this)) {
342             // Calculate the auctioneer's cut.
343             uint256 auctioneerCut = _computeCut(price);
344             uint256 sellerGains = price - auctioneerCut;
345 
346             seller.transfer(sellerGains);
347         }
348 
349         uint256 bidExcess = msg.value - price;
350 
351         msg.sender.transfer(bidExcess);
352 
353         coreContract.transfer(msg.sender, _tulipId);
354 
355         AuctionSuccessful(_tulipId, price, msg.sender);
356     }
357 
358     function secondsPassed(uint256 _tulipId )external view
359        returns (uint256)
360     {
361         Auction storage auction = tokenIdToAuction[_tulipId];
362 
363         uint256 secondsPassed = 0;
364 
365         if (now > auction.startedAt) {
366             secondsPassed = now - auction.startedAt;
367         }
368 
369         return secondsPassed;
370     }
371 
372     function currentPrice(uint256 _tulipId) external view
373         returns (uint256)
374     {
375         Auction storage auction = tokenIdToAuction[_tulipId];
376 
377         require(auction.startedAt > 0);
378 
379         return _currentPrice(auction);
380     }
381 
382     function _currentPrice(Auction storage _auction)
383         internal
384         view
385         returns (uint256)
386     {
387         uint256 secondsPassed = 0;
388 
389         if (now > _auction.startedAt) {
390             secondsPassed = now - _auction.startedAt;
391         }
392 
393         return _computeCurrentPrice(
394             _auction.startingPrice,
395             _auction.endingPrice,
396             _auction.duration,
397             secondsPassed
398         );
399     }
400 
401     function _computeCurrentPrice(
402         uint256 _startingPrice,
403         uint256 _endingPrice,
404         uint256 _duration,
405         uint256 _secondsPassed
406     )
407         internal
408         pure
409         returns (uint256)
410     {
411         if (_secondsPassed >= _duration) {
412             return _endingPrice;
413         } else {
414             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
415 
416             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
417 
418             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
419 
420             return uint256(currentPrice);
421         }
422     }
423 
424     function _computeCut(uint256 _price) internal view returns (uint256) {
425         return _price * ownerCut / 10000;
426     }
427 
428 }