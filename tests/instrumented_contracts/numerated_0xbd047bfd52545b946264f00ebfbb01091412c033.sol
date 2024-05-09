1 pragma solidity ^0.4.21;
2 
3 
4 
5 
6 
7 
8 
9 /**
10  * @title Ownable
11  * @dev The Ownable contract has an owner address, and provides basic authorization control
12  * functions, this simplifies the implementation of "user permissions".
13  */
14 contract Ownable {
15   address public owner;
16 
17 
18   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   function Ownable() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to transfer control of the contract to a newOwner.
39    * @param newOwner The address to transfer ownership to.
40    */
41   function transferOwnership(address newOwner) public onlyOwner {
42     require(newOwner != address(0));
43     emit OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 
47 }
48 
49 
50 
51 /**
52  * @title Pausable
53  * @dev Base contract which allows children to implement an emergency stop mechanism.
54  */
55 contract Pausable is Ownable {
56   event Pause();
57   event Unpause();
58 
59   bool public paused = false;
60 
61 
62   /**
63    * @dev Modifier to make a function callable only when the contract is not paused.
64    */
65   modifier whenNotPaused() {
66     require(!paused);
67     _;
68   }
69 
70   /**
71    * @dev Modifier to make a function callable only when the contract is paused.
72    */
73   modifier whenPaused() {
74     require(paused);
75     _;
76   }
77 
78   /**
79    * @dev called by the owner to pause, triggers stopped state
80    */
81   function pause() onlyOwner whenNotPaused public {
82     paused = true;
83     emit Pause();
84   }
85 
86   /**
87    * @dev called by the owner to unpause, returns to normal state
88    */
89   function unpause() onlyOwner whenPaused public {
90     paused = false;
91     emit Unpause();
92   }
93 }
94 
95 
96 /// @title BlockchainCuties bidding auction
97 /// @author https://BlockChainArchitect.io
98 contract Bidding is Pausable
99 {
100     struct Auction
101     {
102         uint128 highestBid;
103         address highestBidder;
104         uint40 timeEnd;
105         uint40 lastBidTime;
106         uint40 timeStart;
107     }
108 
109     uint40 public minTime = 60*10;
110     uint public minBid = 50 finney;
111 
112     address public operatorAddress;
113 
114     Auction[] public auctions;
115 
116     // Allowed withdrawals of previous bids
117     mapping(address => uint) public pendingReturns;
118     uint public totalReturns;
119 
120     event Bid(address indexed bidder, address indexed prevBider, uint256 value, uint256 addedValue, uint40 auction);
121     event Withdraw(address indexed bidder, uint256 value);
122 
123     function getAuctions(address bidder) public view returns (
124         uint40[5] _timeEnd,
125         uint40[5] _lastBidTime,
126         uint256[5] _highestBid,
127         address[5] _highestBidder,
128         uint16[5] _auctionIndex,
129         uint256 _pendingReturn)
130     {
131         _pendingReturn = pendingReturns[bidder];
132 
133         uint16 j = 0;
134         for (uint16 i = 0; i < auctions.length; i++)
135         {
136             if (isActive(i))
137             {
138                 _timeEnd[j] = auctions[i].timeEnd;
139                 _lastBidTime[j] = auctions[i].lastBidTime;
140                 _highestBid[j] = auctions[i].highestBid;
141                 _highestBidder[j] = auctions[i].highestBidder;
142                 _auctionIndex[j] = i;
143                 j++;
144                 if (j >= 5)
145                 {
146                     break;
147                 }
148             }
149         }
150     }
151 
152     /// Withdraw a bid that was overbid.
153     function withdraw() public {
154         uint amount = pendingReturns[msg.sender];
155         require (amount > 0);
156 
157         // It is important to set this to zero because the recipient
158         // can call this function again as part of the receiving call
159         // before `send` returns.
160 
161         totalReturns -= amount;
162         pendingReturns[msg.sender] -= amount;
163 
164         msg.sender.transfer(amount);
165         emit Withdraw(msg.sender, amount);
166     }
167 
168     function finish(uint16 auction) public onlyOperator
169     {
170         auctions[auction].timeEnd = 0;
171     }
172 
173     function addAuction(uint40 _startTime, uint40 _duration, uint128 _startPrice) public onlyOperator
174     {
175         auctions.push(Auction(_startPrice, address(0), _startTime + _duration, 0, _startTime));
176     }
177 
178     function isEnded(uint16 auction) public view returns (bool)
179     {
180         return auctions[auction].timeEnd < now;
181     }
182 
183     function isActive(uint16 auction) public view returns (bool)
184     {
185         return auctions[auction].timeStart <= now && now <= auctions[auction].timeEnd;
186     }
187 
188     function bid(uint16 auctionIndex, uint256 useFromPendingReturn) public payable whenNotPaused
189     {
190         Auction storage auction = auctions[auctionIndex];
191         address prevBidder = auction.highestBidder;
192         uint256 returnValue = auction.highestBid;
193 
194         require (useFromPendingReturn <= pendingReturns[msg.sender]);
195 
196         uint256 bank = useFromPendingReturn;
197         pendingReturns[msg.sender] -= bank;
198         totalReturns -= bank;
199 
200         uint256 currentBid = bank + msg.value;
201 
202         require(currentBid >= auction.highestBid + minBid ||
203                 currentBid >= auction.highestBid && prevBidder == address(0));
204         require(isActive(auctionIndex));
205 
206         auction.highestBid = uint128(currentBid);
207         auction.highestBidder = msg.sender;
208         auction.lastBidTime = uint40(now);
209 
210         for (uint16 i = 0; i < auctions.length; i++)
211         {
212             if (isActive(i) &&  auctions[i].timeEnd < now + minTime)
213             {
214                 auctions[i].timeEnd = uint40(now) + minTime;
215             }
216         }
217 
218         emit Bid(msg.sender, prevBidder, currentBid, currentBid - returnValue, auctionIndex);
219 
220         if (prevBidder != address(0))
221         {
222             if (!isContract(prevBidder)) // do not allow auto withdraw for contracts
223             {
224                 if (prevBidder.send(returnValue))
225                 {
226                     return; // sent ok, no need to keep returned money on contract
227                 }
228             }
229 
230             pendingReturns[prevBidder] += returnValue;
231             totalReturns += returnValue;
232         }
233     }
234 
235     function destroyContract() public onlyOwner {
236 //        require(address(this).balance == 0);
237         selfdestruct(msg.sender);
238     }
239 
240     function withdrawEthFromBalance() external onlyOwner
241     {
242         owner.transfer(address(this).balance - totalReturns);
243     }
244 
245     function setOperator(address _operator) public onlyOwner
246     {
247         operatorAddress = _operator;
248     }
249 
250     function setMinBid(uint _minBid) public onlyOwner
251     {
252         minBid = _minBid;
253     }
254 
255     function setMinTime(uint40 _minTime) public onlyOwner
256     {
257         minTime = _minTime;
258     }
259 
260     modifier onlyOperator() {
261         require(msg.sender == operatorAddress || msg.sender == owner);
262         _;
263     }
264 
265     function isContract(address addr) public view returns (bool) {
266         uint size;
267         assembly { size := extcodesize(addr) }
268         return size > 0;
269     }
270 }