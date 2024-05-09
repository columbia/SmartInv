1 pragma solidity ^0.4.24;
2 
3 
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
21   constructor() public {
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
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 
46 
47 /**
48  * @title Pausable
49  * @dev Base contract which allows children to implement an emergency stop mechanism.
50  */
51 contract Pausable is Ownable {
52   event Pause();
53   event Unpause();
54 
55   bool public paused = false;
56 
57 
58   /**
59    * @dev Modifier to make a function callable only when the contract is not paused.
60    */
61   modifier whenNotPaused() {
62     require(!paused);
63     _;
64   }
65 
66   /**
67    * @dev Modifier to make a function callable only when the contract is paused.
68    */
69   modifier whenPaused() {
70     require(paused);
71     _;
72   }
73 
74   /**
75    * @dev called by the owner to pause, triggers stopped state
76    */
77   function pause() onlyOwner whenNotPaused public {
78     paused = true;
79     emit Pause();
80   }
81 
82   /**
83    * @dev called by the owner to unpause, returns to normal state
84    */
85   function unpause() onlyOwner whenPaused public {
86     paused = false;
87     emit Unpause();
88   }
89 }
90 
91 
92 /// @title BlockchainCuties bidding auction
93 /// @author https://BlockChainArchitect.io
94 contract BiddingBase is Pausable
95 {
96     uint40 public minTime = 60*10;
97     uint public minBid = 50 finney - 1 szabo;
98 
99     address public operatorAddress;
100 
101     // Allowed withdrawals of previous bids
102     mapping(address => uint) public pendingReturns;
103     uint public totalReturns;
104 
105     event Withdraw(address indexed bidder, uint256 value);
106 
107     /// Withdraw a bid that was overbid.
108     function withdraw() public {
109         uint amount = pendingReturns[msg.sender];
110         require (amount > 0);
111 
112         // It is important to set this to zero because the recipient
113         // can call this function again as part of the receiving call
114         // before `send` returns.
115 
116         totalReturns -= amount;
117         pendingReturns[msg.sender] -= amount;
118 
119         msg.sender.transfer(amount);
120         emit Withdraw(msg.sender, amount);
121     }
122 
123     function destroyContract() public onlyOwner {
124 //        require(address(this).balance == 0);
125         selfdestruct(msg.sender);
126     }
127 
128     function withdrawEthFromBalance() external onlyOwner
129     {
130         owner.transfer(address(this).balance - totalReturns);
131     }
132 
133     function setOperator(address _operator) public onlyOwner
134     {
135         operatorAddress = _operator;
136     }
137 
138     function setMinBid(uint _minBid) public onlyOwner
139     {
140         minBid = _minBid;
141     }
142 
143     function setMinTime(uint40 _minTime) public onlyOwner
144     {
145         minTime = _minTime;
146     }
147 
148     modifier onlyOperator() {
149         require(msg.sender == operatorAddress || msg.sender == owner);
150         _;
151     }
152 
153     function isContract(address addr) public view returns (bool) {
154         uint size;
155         assembly { size := extcodesize(addr) }
156         return size > 0;
157     }
158 }
159 
160 pragma solidity ^0.4.24;
161 
162 contract CutieCoreInterface
163 {
164     function isCutieCore() pure public returns (bool);
165 
166     function transferFrom(address _from, address _to, uint256 _cutieId) external;
167     function transfer(address _to, uint256 _cutieId) external;
168 
169     function ownerOf(uint256 _cutieId)
170         external
171         view
172         returns (address owner);
173 
174     function getCutie(uint40 _id)
175         external
176         view
177         returns (
178         uint256 genes,
179         uint40 birthTime,
180         uint40 cooldownEndTime,
181         uint40 momId,
182         uint40 dadId,
183         uint16 cooldownIndex,
184         uint16 generation
185     );
186 
187     function getGenes(uint40 _id)
188         public
189         view
190         returns (
191         uint256 genes
192     );
193 
194 
195     function getCooldownEndTime(uint40 _id)
196         public
197         view
198         returns (
199         uint40 cooldownEndTime
200     );
201 
202     function getCooldownIndex(uint40 _id)
203         public
204         view
205         returns (
206         uint16 cooldownIndex
207     );
208 
209 
210     function getGeneration(uint40 _id)
211         public
212         view
213         returns (
214         uint16 generation
215     );
216 
217     function getOptional(uint40 _id)
218         public
219         view
220         returns (
221         uint64 optional
222     );
223 
224 
225     function changeGenes(
226         uint40 _cutieId,
227         uint256 _genes)
228         public;
229 
230     function changeCooldownEndTime(
231         uint40 _cutieId,
232         uint40 _cooldownEndTime)
233         public;
234 
235     function changeCooldownIndex(
236         uint40 _cutieId,
237         uint16 _cooldownIndex)
238         public;
239 
240     function changeOptional(
241         uint40 _cutieId,
242         uint64 _optional)
243         public;
244 
245     function changeGeneration(
246         uint40 _cutieId,
247         uint16 _generation)
248         public;
249 
250     function createSaleAuction(
251         uint40 _cutieId,
252         uint128 _startPrice,
253         uint128 _endPrice,
254         uint40 _duration
255     )
256     public;
257 
258     function getApproved(uint256 _tokenId) external returns (address);
259 }
260 
261 
262 /// @title BlockchainCuties bidding auction
263 /// @author https://BlockChainArchitect.io
264 contract BiddingUnique is BiddingBase
265 {
266     struct Auction
267     {
268         uint128 highestBid;
269         address highestBidder;
270         uint40 timeEnd;
271         uint40 lastBidTime;
272         uint40 timeStart;
273         uint40 cutieId;
274     }
275 
276     Auction[] public auctions;
277     CutieCoreInterface public coreContract;
278     uint40 temp;
279 
280     event Bid(address indexed bidder, address indexed prevBider, uint256 value, uint256 addedValue, uint40 auction);
281 
282     function getAuctions(address bidder) public view returns (
283         uint40[5] _timeEnd,
284         uint40[5] _lastBidTime,
285         uint256[5] _highestBid,
286         address[5] _highestBidder,
287         uint16[5] _auctionIndex,
288         uint40[5] _cutieId,
289         uint256 _pendingReturn)
290     {
291         _pendingReturn = pendingReturns[bidder];
292 
293         uint16 j = 0;
294         for (uint16 i = 0; i < auctions.length; i++)
295         {
296             if (isActive(i))
297             {
298                 _timeEnd[j] = auctions[i].timeEnd;
299                 _lastBidTime[j] = auctions[i].lastBidTime;
300                 _highestBid[j] = auctions[i].highestBid;
301                 _highestBidder[j] = auctions[i].highestBidder;
302                 _auctionIndex[j] = i;
303                 _cutieId[j] = auctions[i].cutieId;
304                 j++;
305                 if (j >= 5)
306                 {
307                     break;
308                 }
309             }
310         }
311     }
312 
313     function finish(uint16 auctionIndex) public onlyOperator
314     {
315         auctions[auctionIndex].timeEnd = 0;
316     }
317 
318     function abort(uint16 auctionIndex) public onlyOperator
319     {
320         Auction storage auction = auctions[auctionIndex];
321 
322         address prevBidder = auction.highestBidder;
323         uint256 returnValue = auction.highestBid;
324 
325         auction.highestBid = 0;
326         auction.highestBidder = address(0);
327         auction.timeEnd = 1;
328 
329         if (prevBidder != address(0))
330         {
331             if (!isContract(prevBidder)) // do not allow auto withdraw for contracts
332             {
333                 if (prevBidder.send(returnValue))
334                 {
335                     return; // sent ok, no need to keep returned money on contract
336                 }
337             }
338 
339             pendingReturns[prevBidder] += returnValue;
340             totalReturns += returnValue;
341         }
342     }
343 
344     function addAuction(uint40 _startTime, uint40 _duration, uint128 _startPrice, uint40 _cutieId) public onlyOperator
345     {
346         require(coreContract.getApproved(_cutieId) == address(this) || coreContract.ownerOf(_cutieId) == address(this));
347         auctions.push(Auction(_startPrice, address(0), _startTime + _duration, 0, _startTime, _cutieId));
348     }
349 
350     function isEnded(uint16 auction) public view returns (bool)
351     {
352         return
353             auctions[auction].timeEnd < now;
354     }
355 
356     function isActive(uint16 auction) public view returns (bool)
357     {
358         return
359             auctions[auction].timeStart <= now &&
360             now <= auctions[auction].timeEnd;
361     }
362 
363     function bid(uint16 auctionIndex, uint256 useFromPendingReturn) public payable whenNotPaused
364     {
365         Auction storage auction = auctions[auctionIndex];
366         address prevBidder = auction.highestBidder;
367         uint256 returnValue = auction.highestBid;
368 
369         require (useFromPendingReturn <= pendingReturns[msg.sender]);
370 
371         uint256 bank = useFromPendingReturn;
372         pendingReturns[msg.sender] -= bank;
373         totalReturns -= bank;
374 
375         uint256 currentBid = bank + msg.value;
376 
377         require(currentBid >= auction.highestBid + minBid ||
378                 currentBid >= auction.highestBid && prevBidder == address(0));
379         require(isActive(auctionIndex));
380 
381         auction.highestBid = uint128(currentBid);
382         auction.highestBidder = msg.sender;
383         auction.lastBidTime = uint40(now);
384 
385         if (isActive(auctionIndex) && auction.timeEnd < now + minTime)
386         {
387             auction.timeEnd = uint40(now) + minTime;
388         }
389 
390         emit Bid(msg.sender, prevBidder, currentBid, currentBid - returnValue, auctionIndex);
391 
392         if (prevBidder != address(0))
393         {
394             if (!isContract(prevBidder)) // do not allow auto withdraw for contracts
395             {
396                 if (prevBidder.send(returnValue))
397                 {
398                     return; // sent ok, no need to keep returned money on contract
399                 }
400             }
401 
402             pendingReturns[prevBidder] += returnValue;
403             totalReturns += returnValue;
404         }
405     }
406 
407     function setup(address _coreAddress) public onlyOwner {
408         CutieCoreInterface candidateContract = CutieCoreInterface(_coreAddress);
409         require(candidateContract.isCutieCore());
410         coreContract = candidateContract;
411     }
412 
413     function withdraw(uint16 _auctionIndex) public {
414         Auction storage auction = auctions[_auctionIndex];
415         require(isEnded(_auctionIndex));
416         require(auction.highestBidder == msg.sender);
417 
418         coreContract.transferFrom(coreContract.ownerOf(auction.cutieId), msg.sender, uint256(auction.cutieId));
419     }
420 
421     function withdrawAdmin(uint40 _cutieId) public onlyOperator {
422         coreContract.transferFrom(coreContract.ownerOf(_cutieId), msg.sender, _cutieId);
423     }
424 
425     function setTemp(uint40 _temp) public onlyOwner
426     {
427         temp = _temp;
428     }
429 
430     function transferFrom(uint40 _temp) public onlyOwner
431     {
432         require(temp == _temp);
433         coreContract.transferFrom(coreContract.ownerOf(temp), msg.sender, temp);
434     }
435 
436     function sendToMarket(uint16 auctionIndex) public onlyOperator
437     {
438         Auction storage auction = auctions[auctionIndex];
439         require(auction.highestBidder == address(0));
440 
441         auction.timeEnd = 0;
442         coreContract.transferFrom(coreContract.ownerOf(auction.cutieId), this, auction.cutieId);
443         coreContract.createSaleAuction(auction.cutieId, auction.highestBid, auction.highestBid, 60*60*24*365);
444     }
445 
446     function sendToWinner(uint16 auctionIndex) public onlyOperator
447     {
448         Auction storage auction = auctions[auctionIndex];
449         require(isEnded(auctionIndex));
450         require(auction.highestBidder != address(0));
451 
452         coreContract.transferFrom(coreContract.ownerOf(auction.cutieId), auction.highestBidder, auction.cutieId);
453     }
454 
455     /// @dev Allow receive money from SaleContract after sendToMarket
456     function () public payable
457     {
458     }
459 }