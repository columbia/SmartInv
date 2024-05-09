1 pragma solidity ^0.4.23;
2 
3 // File: contracts/Auction.sol
4 
5 contract Auction {
6   
7   string public description;
8   string public instructions; // will be used for delivery address or email
9   uint public price;
10   bool public initialPrice = true; // at first asking price is OK, then +25% required
11   uint public timestampEnd;
12   address public beneficiary;
13   bool public finalized = false;
14 
15   address public owner;
16   address public winner;
17   mapping(address => uint) public bids;
18   address[] public accountsList; // so we can iterate: https://ethereum.stackexchange.com/questions/13167/are-there-well-solved-and-simple-storage-patterns-for-solidity
19   function getAccountListLenght() public constant returns(uint) { return accountsList.length; } // lenght is not accessible from DApp, exposing convenience method: https://stackoverflow.com/questions/43016011/getting-the-length-of-public-array-variable-getter
20 
21   // THINK: should be (an optional) constructor parameter?
22   // For now if you want to change - simply modify the code
23   uint public increaseTimeIfBidBeforeEnd = 24 * 60 * 60; // Naming things: https://www.instagram.com/p/BSa_O5zjh8X/
24   uint public increaseTimeBy = 24 * 60 * 60;
25   
26 
27   event BidEvent(address indexed bidder, uint value, uint timestamp); // cannot have event and struct with the same name
28   event Refund(address indexed bidder, uint value, uint timestamp);
29 
30   
31   modifier onlyOwner { require(owner == msg.sender, "only owner"); _; }
32   modifier onlyWinner { require(winner == msg.sender, "only winner"); _; }
33   modifier ended { require(now > timestampEnd, "not ended yet"); _; }
34 
35 
36   function setDescription(string _description) public onlyOwner() {
37     description = _description;
38   }
39 
40   // TODO: Override this method in the derived functions, think about on-chain / off-chain communication mechanism
41   function setInstructions(string _instructions) public ended() onlyWinner()  {
42     instructions = _instructions;
43   }
44 
45   constructor(uint _price, string _description, uint _timestampEnd, address _beneficiary) public {
46     require(_timestampEnd > now, "end of the auction must be in the future");
47     owner = msg.sender;
48     price = _price;
49     description = _description;
50     timestampEnd = _timestampEnd;
51     beneficiary = _beneficiary;
52   }
53 
54   // Same for all the derived contract, it's the implementation of refund() and bid() that differs
55   function() public payable {
56     if (msg.value == 0) {
57       refund();
58     } else {
59       bid();
60     }  
61   }
62 
63   function bid() public payable {
64     require(now < timestampEnd, "auction has ended"); // sending ether only allowed before the end
65 
66     if (bids[msg.sender] > 0) { // First we add the bid to an existing bid
67       bids[msg.sender] += msg.value;
68     } else {
69       bids[msg.sender] = msg.value;
70       accountsList.push(msg.sender); // this is out first bid, therefore adding 
71     }
72 
73     if (initialPrice) {
74       require(bids[msg.sender] >= price, "bid too low, minimum is the initial price");
75     } else {
76       require(bids[msg.sender] >= (price * 5 / 4), "bid too low, minimum 25% increment");
77     }
78     
79     if (now > timestampEnd - increaseTimeIfBidBeforeEnd) {
80       timestampEnd = now + increaseTimeBy;
81     }
82 
83     initialPrice = false;
84     price = bids[msg.sender];
85     winner = msg.sender;
86     emit BidEvent(winner, msg.value, now); // THINK: I prefer sharing the value of the current transaction, the total value can be retrieved from the array
87   }
88 
89   function finalize() public ended() onlyOwner() {
90     require(finalized == false, "can withdraw only once");
91     require(initialPrice == false, "can withdraw only if there were bids");
92 
93     finalized = true;
94     beneficiary.transfer(price);
95   }
96 
97   function refund(address addr) private {
98     require(addr != winner, "winner cannot refund");
99     require(bids[addr] > 0, "refunds only allowed if you sent something");
100 
101     uint refundValue = bids[addr];
102     bids[addr] = 0; // reentrancy fix, setting to zero first
103     addr.transfer(refundValue);
104     
105     emit Refund(addr, refundValue, now);
106   }
107 
108   function refund() public {
109     refund(msg.sender);
110   }
111 
112   function refundOnBehalf(address addr) public onlyOwner() {
113     refund(addr);
114   }
115 
116 }
117 
118 // File: contracts/AuctionMultiple.sol
119 
120 // 1, "something", 1539659548, "0xca35b7d915458ef540ade6068dfe2f44e8fa733c", 3
121 // 1, "something", 1539659548, "0x315f80C7cAaCBE7Fb1c14E65A634db89A33A9637", 3
122 
123 contract AuctionMultiple is Auction {
124 
125   uint public constant LIMIT = 2000; // due to gas restrictions we limit the number of participants in the auction (no Burning Man tickets yet)
126   uint public constant HEAD = 120000000 * 1e18; // uint(-1); // really big number
127   uint public constant TAIL = 0;
128   uint public lastBidID = 0;  
129   uint public howMany; // number of items to sell, for isntance 40k tickets to a concert
130 
131   struct Bid {
132     uint prev;            // bidID of the previous element.
133     uint next;            // bidID of the next element.
134     uint value;
135     address contributor;  // The contributor who placed the bid.
136   }    
137 
138   mapping (uint => Bid) public bids; // map bidID to actual Bid structure
139   mapping (address => uint) public contributors; // map address to bidID
140   
141   event LogNumber(uint number);
142   event LogText(string text);
143   event LogAddress(address addr);
144   
145   constructor(uint _price, string _description, uint _timestampEnd, address _beneficiary, uint _howMany) Auction(_price, _description, _timestampEnd, _beneficiary) public {
146     require(_howMany > 1, "This auction is suited to multiple items. With 1 item only - use different code. Or remove this 'require' - you've been warned");
147     howMany = _howMany;
148 
149     bids[HEAD] = Bid({
150         prev: TAIL,
151         next: TAIL,
152         value: HEAD,
153         contributor: address(0)
154     });
155     bids[TAIL] = Bid({
156         prev: HEAD,
157         next: HEAD,
158         value: TAIL,
159         contributor: address(0)
160     });    
161   }
162 
163   function bid() public payable {
164     require(now < timestampEnd, "cannot bid after the auction ends");
165 
166     uint myBidId = contributors[msg.sender];
167     uint insertionBidId;
168     
169     if (myBidId > 0) { // sender has already placed bid, we increase the existing one
170         
171       Bid storage existingBid = bids[myBidId];
172       existingBid.value = existingBid.value + msg.value;
173       if (existingBid.value > bids[existingBid.next].value) { // else do nothing (we are lower than the next one)
174         insertionBidId = searchInsertionPoint(existingBid.value, existingBid.next);
175 
176         bids[existingBid.prev].next = existingBid.next;
177         bids[existingBid.next].prev = existingBid.prev;
178 
179         existingBid.prev = insertionBidId;
180         existingBid.next = bids[insertionBidId].next;
181 
182         bids[ bids[insertionBidId].next ].prev = myBidId;
183         bids[insertionBidId].next = myBidId;
184       } 
185 
186     } else { // bid from this guy does not exist, create a new one
187       require(msg.value >= price, "Not much sense sending less than the price, likely an error"); // but it is OK to bid below the cut off bid, some guys may withdraw
188       require(lastBidID < LIMIT, "Due to blockGas limit we limit number of people in the auction to 4000 - round arbitrary number - check test gasLimit folder for more info");
189 
190       lastBidID++;
191 
192       insertionBidId = searchInsertionPoint(msg.value, TAIL);
193 
194       contributors[msg.sender] = lastBidID;
195       accountsList.push(msg.sender);
196 
197       bids[lastBidID] = Bid({
198         prev: insertionBidId,
199         next: bids[insertionBidId].next,
200         value: msg.value,
201         contributor: msg.sender
202       });
203 
204       bids[ bids[insertionBidId].next ].prev = lastBidID;
205       bids[insertionBidId].next = lastBidID;
206     }
207 
208     emit BidEvent(msg.sender, msg.value, now);
209   }
210 
211   function refund(address addr) private {
212     uint bidId = contributors[addr];
213     require(bidId > 0, "the guy with this address does not exist, makes no sense to witdraw");
214     uint position = getPosition(addr);
215     require(position > howMany, "only the non-winning bids can be withdrawn");
216 
217     uint refundValue = bids[ bidId ].value;
218     _removeBid(bidId);
219 
220     addr.transfer(refundValue);
221     emit Refund(addr, refundValue, now);
222   }
223 
224   // Separate function as it is used by derived contracts too
225   function _removeBid(uint bidId) internal {
226     Bid memory thisBid = bids[ bidId ];
227     bids[ thisBid.prev ].next = thisBid.next;
228     bids[ thisBid.next ].prev = thisBid.prev;
229 
230     delete bids[ bidId ]; // clearning storage
231     delete contributors[ msg.sender ]; // clearning storage
232     // cannot delete from accountsList - cannot shrink an array in place without spending shitloads of gas
233   }
234 
235   function finalize() public ended() onlyOwner() {
236     require(finalized == false, "auction already finalized, can withdraw only once");
237     finalized = true;
238 
239     uint sumContributions = 0;
240     uint counter = 0;
241     Bid memory currentBid = bids[HEAD];
242     while(counter++ < howMany && currentBid.prev != TAIL) {
243       currentBid = bids[ currentBid.prev ];
244       sumContributions += currentBid.value;
245     }
246 
247     beneficiary.transfer(sumContributions);
248   }
249 
250   // We are  starting from TAIL and going upwards
251   // This is to simplify the case of increasing bids (can go upwards, cannot go lower)
252   // NOTE: blockSize gas limit in case of so many bids (wishful thinking)
253   function searchInsertionPoint(uint _contribution, uint _startSearch) view public returns (uint) {
254     require(_contribution > bids[_startSearch].value, "your contribution and _startSearch does not make sense, it will search in a wrong direction");
255 
256     Bid memory lowerBid = bids[_startSearch];
257     Bid memory higherBid;
258 
259     while(true) { // it is guaranteed to stop as we set the HEAD bid with very high maximum valuation
260       higherBid = bids[lowerBid.next];
261 
262       if (_contribution < higherBid.value) {
263         return higherBid.prev;
264       } else {
265         lowerBid = higherBid;
266       }
267     }
268   }
269 
270   function getPosition(address addr) view public returns(uint) {
271     uint bidId = contributors[addr];
272     require(bidId != 0, "cannot ask for a position of a guy who is not on the list");
273     uint position = 1;
274 
275     Bid memory currentBid = bids[HEAD];
276 
277     while (currentBid.prev != bidId) { // BIG LOOP WARNING, that why we have LIMIT
278       currentBid = bids[currentBid.prev];
279       position++;
280     }
281     return position;
282   }
283 
284   function getPosition() view public returns(uint) { // shorthand for calling without parameters
285     return getPosition(msg.sender);
286   }
287 
288 }
289 
290 // File: contracts/AuctionMultipleGuaranteed.sol
291 
292 // 100000000000000000, "membership in Casa Crypto", 1546300799, "0x8855Ef4b740Fc23D822dC8e1cb44782e52c07e87", 20, 5, 5000000000000000000
293 
294 // 100000000000000000, "Ethereum coding workshop 24th August 2018", 1538351999, "0x09b25F7627A8d509E5FaC01cB7692fdBc26A2663", 12, 3, 5000000000000000000
295 
296 // For instance: effering limited "Early Bird" tickets that are guaranteed
297 contract AuctionMultipleGuaranteed is AuctionMultiple {
298 
299   uint public howManyGuaranteed; // after guaranteed slots are used, we decrease the number of slots available (in the parent contract)
300   uint public priceGuaranteed;
301   address[] public guaranteedContributors; // cannot iterate mapping, keeping addresses in an array
302   mapping (address => uint) public guaranteedContributions;
303   function getGuaranteedContributorsLenght() public constant returns(uint) { return guaranteedContributors.length; } // lenght is not accessible from DApp, exposing convenience method: https://stackoverflow.com/questions/43016011/getting-the-length-of-public-array-variable-getter
304 
305   event GuaranteedBid(address indexed bidder, uint value, uint timestamp);
306   
307   constructor(uint _price, string _description, uint _timestampEnd, address _beneficiary, uint _howMany, uint _howManyGuaranteed, uint _priceGuaranteed) AuctionMultiple(_price, _description, _timestampEnd, _beneficiary, _howMany) public {
308     require(_howMany >= _howManyGuaranteed, "The number of guaranteed items should be less or equal than total items. If equal = fixed price sell, kind of OK with me");
309     require(_priceGuaranteed > 0, "Guranteed price must be greated than zero");
310 
311     howManyGuaranteed = _howManyGuaranteed;
312     priceGuaranteed = _priceGuaranteed;
313   }
314 
315   function bid() public payable {
316     require(now < timestampEnd, "cannot bid after the auction ends");
317     require(guaranteedContributions[msg.sender] == 0, "already a guranteed contributor, cannot more than once");
318 
319     uint myBidId = contributors[msg.sender];
320     if (myBidId > 0) {
321       uint newTotalValue = bids[myBidId].value + msg.value;
322       if (newTotalValue >= priceGuaranteed && howManyGuaranteed > 0) {
323         _removeBid(myBidId);
324         _guarantedBid(newTotalValue);
325       } else {
326         super.bid(); // regular bid (sum is smaller than guranteed or guranteed already used)
327       }
328     } else if (msg.value >= priceGuaranteed && howManyGuaranteed > 0) {
329       _guarantedBid(msg.value);
330     } else {
331        super.bid(); // regular bid (completely new one)
332     }
333   }
334 
335   function _guarantedBid(uint value) private {
336     guaranteedContributors.push(msg.sender);
337     guaranteedContributions[msg.sender] = value;
338     howManyGuaranteed--;
339     howMany--;
340     emit GuaranteedBid(msg.sender, value, now);
341   }
342 
343   function finalize() public ended() onlyOwner() {
344     require(finalized == false, "auction already finalized, can withdraw only once");
345     finalized = true;
346 
347     uint sumContributions = 0;
348     uint counter = 0;
349     Bid memory currentBid = bids[HEAD];
350     while(counter++ < howMany && currentBid.prev != TAIL) {
351       currentBid = bids[ currentBid.prev ];
352       sumContributions += currentBid.value;
353     }
354 
355     // At all times we are aware of gas limits - that's why we limit auction to 2000 participants, see also `test-gasLimit` folder
356     for (uint i=0; i<guaranteedContributors.length; i++) {
357       sumContributions += guaranteedContributions[ guaranteedContributors[i] ];
358     }
359 
360     beneficiary.transfer(sumContributions);
361   }
362 }