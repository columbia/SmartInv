1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 
45 
46 /**
47  * @title Pausable
48  * @dev Base contract which allows children to implement an emergency stop mechanism.
49  */
50 contract Pausable is Ownable {
51   event Pause();
52   event Unpause();
53 
54   bool public paused = false;
55 
56 
57   /**
58    * @dev Modifier to make a function callable only when the contract is not paused.
59    */
60   modifier whenNotPaused() {
61     require(!paused);
62     _;
63   }
64 
65   /**
66    * @dev Modifier to make a function callable only when the contract is paused.
67    */
68   modifier whenPaused() {
69     require(paused);
70     _;
71   }
72 
73   /**
74    * @dev called by the owner to pause, triggers stopped state
75    */
76   function pause() onlyOwner whenNotPaused public {
77     paused = true;
78     emit Pause();
79   }
80 
81   /**
82    * @dev called by the owner to unpause, returns to normal state
83    */
84   function unpause() onlyOwner whenPaused public {
85     paused = false;
86     emit Unpause();
87   }
88 }
89 
90 
91 /// @title BlockchainCuties bidding auction
92 /// @author https://BlockChainArchitect.io
93 contract BiddingBase is Pausable
94 {
95     uint40 public minTime = 60*10;
96     uint public minBid = 50 finney - 1 szabo;
97 
98     address public operatorAddress;
99 
100     // Allowed withdrawals of previous bids
101     mapping(address => uint) public pendingReturns;
102     uint public totalReturns;
103 
104     event Withdraw(address indexed bidder, uint256 value);
105 
106     /// Withdraw a bid that was overbid.
107     function withdraw() public {
108         uint amount = pendingReturns[msg.sender];
109         require (amount > 0);
110 
111         // It is important to set this to zero because the recipient
112         // can call this function again as part of the receiving call
113         // before `send` returns.
114 
115         totalReturns -= amount;
116         pendingReturns[msg.sender] -= amount;
117 
118         msg.sender.transfer(amount);
119         emit Withdraw(msg.sender, amount);
120     }
121 
122     function destroyContract() public onlyOwner {
123 //        require(address(this).balance == 0);
124         selfdestruct(msg.sender);
125     }
126 
127     function withdrawEthFromBalance() external onlyOwner
128     {
129         owner.transfer(address(this).balance - totalReturns);
130     }
131 
132     function setOperator(address _operator) public onlyOwner
133     {
134         operatorAddress = _operator;
135     }
136 
137     function setMinBid(uint _minBid) public onlyOwner
138     {
139         minBid = _minBid;
140     }
141 
142     function setMinTime(uint40 _minTime) public onlyOwner
143     {
144         minTime = _minTime;
145     }
146 
147     modifier onlyOperator() {
148         require(msg.sender == operatorAddress || msg.sender == owner);
149         _;
150     }
151 
152     function isContract(address addr) public view returns (bool) {
153         uint size;
154         assembly { size := extcodesize(addr) }
155         return size > 0;
156     }
157 }
158 
159 
160 /// @title BlockchainCuties bidding auction
161 /// @author https://BlockChainArchitect.io
162 contract BiddingCustom is BiddingBase
163 {
164     struct Auction
165     {
166         uint128 highestBid;
167         address highestBidder;
168         uint40 timeEnd;
169         uint40 lastBidTime;
170         uint40 timeStart;
171     }
172 
173     Auction[] public auctions;
174 
175     event Bid(address indexed bidder, address indexed prevBider, uint256 value, uint256 addedValue, uint40 auction);
176 
177     function getAuctions(address bidder) public view returns (
178         uint40[5] _timeEnd,
179         uint40[5] _lastBidTime,
180         uint256[5] _highestBid,
181         address[5] _highestBidder,
182         uint16[5] _auctionIndex,
183         uint256 _pendingReturn)
184     {
185         _pendingReturn = pendingReturns[bidder];
186 
187         uint16 j = 0;
188         for (uint16 i = 0; i < auctions.length; i++)
189         {
190             if (isActive(i))
191             {
192                 _timeEnd[j] = auctions[i].timeEnd;
193                 _lastBidTime[j] = auctions[i].lastBidTime;
194                 _highestBid[j] = auctions[i].highestBid;
195                 _highestBidder[j] = auctions[i].highestBidder;
196                 _auctionIndex[j] = i;
197                 j++;
198                 if (j >= 5)
199                 {
200                     break;
201                 }
202             }
203         }
204     }
205 
206     function finish(uint16 auction) public onlyOperator
207     {
208         auctions[auction].timeEnd = 1;
209     }
210 
211     function abort(uint16 auctionIndex) public onlyOperator
212     {
213         Auction storage auction = auctions[auctionIndex];
214 
215         address prevBidder = auction.highestBidder;
216         uint256 returnValue = auction.highestBid;
217 
218         auction.highestBid = 0;
219         auction.highestBidder = address(0);
220         auction.timeEnd = 1;
221 
222         if (prevBidder != address(0))
223         {
224             if (!isContract(prevBidder)) // do not allow auto withdraw for contracts
225             {
226                 if (prevBidder.send(returnValue))
227                 {
228                     return; // sent ok, no need to keep returned money on contract
229                 }
230             }
231 
232             pendingReturns[prevBidder] += returnValue;
233             totalReturns += returnValue;
234         }
235     }
236 
237     function addAuction(uint40 _startTime, uint40 _duration, uint128 _startPrice) public onlyOperator
238     {
239         auctions.push(Auction(_startPrice, address(0), _startTime + _duration, 0, _startTime));
240     }
241 
242     function isEnded(uint16 auction) public view returns (bool)
243     {
244         return
245             auctions[auction].timeEnd < now &&
246             auctions[auction].highestBidder != address(0);
247     }
248 
249     function isActive(uint16 auctionIndex) public view returns (bool)
250     {
251         Auction storage auction = auctions[auctionIndex];
252         return
253             auction.timeStart <= now &&
254             (now < auction.timeEnd || auction.timeEnd != 0 && auction.highestBidder == address(0));
255     }
256 
257     function bid(uint16 auctionIndex, uint256 useFromPendingReturn) public payable whenNotPaused
258     {
259         Auction storage auction = auctions[auctionIndex];
260         address prevBidder = auction.highestBidder;
261         uint256 returnValue = auction.highestBid;
262 
263         require (useFromPendingReturn <= pendingReturns[msg.sender]);
264 
265         uint256 bank = useFromPendingReturn;
266         pendingReturns[msg.sender] -= bank;
267         totalReturns -= bank;
268 
269         uint256 currentBid = bank + msg.value;
270 
271         require(currentBid >= auction.highestBid + minBid ||
272                 currentBid >= auction.highestBid && prevBidder == address(0));
273         require(isActive(auctionIndex));
274 
275         auction.highestBid = uint128(currentBid);
276         auction.highestBidder = msg.sender;
277         auction.lastBidTime = uint40(now);
278 
279         for (uint16 i = 0; i < auctions.length; i++)
280         {
281             if (isActive(i) &&  auctions[i].timeEnd < now + minTime)
282             {
283                 auctions[i].timeEnd = uint40(now) + minTime;
284             }
285         }
286 
287         emit Bid(msg.sender, prevBidder, currentBid, currentBid - returnValue, auctionIndex);
288 
289         if (prevBidder != address(0))
290         {
291             if (!isContract(prevBidder)) // do not allow auto withdraw for contracts
292             {
293                 if (prevBidder.send(returnValue))
294                 {
295                     return; // sent ok, no need to keep returned money on contract
296                 }
297             }
298 
299             pendingReturns[prevBidder] += returnValue;
300             totalReturns += returnValue;
301         }
302     }
303 }