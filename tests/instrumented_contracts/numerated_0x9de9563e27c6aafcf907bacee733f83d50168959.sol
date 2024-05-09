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
109     address public operatorAddress;
110 
111     Auction[] public auctions;
112 
113     // Allowed withdrawals of previous bids
114     mapping(address => uint) public pendingReturns;
115     uint public totalReturns;
116 
117     event Bid(address indexed bidder, address indexed prevBider, uint256 value, uint256 addedValue, uint40 auction);
118     event Withdraw(address indexed bidder, uint256 value);
119 
120     function getAuctions(address bidder) public view returns (
121         uint40[5] _timeEnd,
122         uint40[5] _lastBidTime,
123         uint256[5] _highestBid,
124         address[5] _highestBidder,
125         uint16[5] _auctionIndex,
126         uint256 _pendingReturn)
127     {
128         _pendingReturn = pendingReturns[bidder];
129 
130         uint16 j = 0;
131         for (uint16 i = 0; i < auctions.length; i++)
132         {
133             if (isActive(i))
134             {
135                 _timeEnd[j] = auctions[i].timeEnd;
136                 _lastBidTime[j] = auctions[i].lastBidTime;
137                 _highestBid[j] = auctions[i].highestBid;
138                 _highestBidder[j] = auctions[i].highestBidder;
139                 _auctionIndex[j] = i;
140                 j++;
141                 if (j >= 5)
142                 {
143                     break;
144                 }
145             }
146         }
147     }
148 
149     /// Withdraw a bid that was overbid.
150     function withdraw() public {
151         uint amount = pendingReturns[msg.sender];
152         require (amount > 0);
153 
154         // It is important to set this to zero because the recipient
155         // can call this function again as part of the receiving call
156         // before `send` returns.
157 
158         totalReturns -= amount;
159         pendingReturns[msg.sender] -= amount;
160 
161         msg.sender.transfer(amount);
162         emit Withdraw(msg.sender, amount);
163     }
164 
165     function finish(uint16 auction) public onlyOperator
166     {
167         auctions[auction].timeEnd = 0;
168     }
169 
170     function addAuction(uint40 _startTime, uint40 _duration, uint128 _startPrice) public onlyOperator
171     {
172         auctions.push(Auction(_startPrice, address(0), _startTime + _duration, 0, _startTime));
173     }
174 
175     function isEnded(uint16 auction) public view returns (bool)
176     {
177         return auctions[auction].timeEnd < now;
178     }
179 
180     function isActive(uint16 auction) public view returns (bool)
181     {
182         return auctions[auction].timeStart <= now && now <= auctions[auction].timeEnd;
183     }
184 
185     function bid(uint16 auction, uint256 useFromPendingReturn) public payable whenNotPaused
186     {
187         address prevBidder = auctions[auction].highestBidder;
188         uint256 returnValue = auctions[auction].highestBid;
189 
190         require (useFromPendingReturn <= pendingReturns[msg.sender]);
191 
192         uint256 bank = useFromPendingReturn;
193         pendingReturns[msg.sender] -= bank;
194         totalReturns -= bank;
195 
196         uint256 currentBid = bank + msg.value;
197 
198         require(currentBid > auctions[auction].highestBid ||
199                 currentBid == auctions[auction].highestBid && prevBidder == address(0));
200         require(isActive(auction));
201 
202         auctions[auction].highestBid = uint128(currentBid);
203         auctions[auction].highestBidder = msg.sender;
204         auctions[auction].lastBidTime = uint40(now);
205 
206         emit Bid(msg.sender, prevBidder, currentBid, currentBid - returnValue, auction);
207 
208         if (prevBidder != address(0))
209         {
210             if (!isContract(prevBidder)) // do not allow auto withdraw for contracts
211             {
212                 if (prevBidder.send(returnValue))
213                 {
214                     return; // sent ok, no need to keep returned money on contract
215                 }
216             }
217 
218             pendingReturns[prevBidder] += returnValue;
219             totalReturns += returnValue;
220         }
221 
222     }
223 
224     function destroyContract() public onlyOwner {
225         require(address(this).balance == 0);
226         selfdestruct(msg.sender);
227     }
228 
229     function withdrawEthFromBalance() external onlyOwner
230     {
231         owner.transfer(address(this).balance - totalReturns);
232     }
233 
234     function setOperator(address _operator) public onlyOwner
235     {
236         operatorAddress = _operator;
237     }
238 
239     modifier onlyOperator() {
240         require(msg.sender == operatorAddress || msg.sender == owner);
241         _;
242     }
243 
244     function isContract(address addr) public view returns (bool) {
245         uint size;
246         assembly { size := extcodesize(addr) }
247         return size > 0;
248     }
249 }