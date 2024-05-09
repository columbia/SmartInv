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
102         uint256 highestBid;
103         address highestBidder;
104         uint40 timeEnd;
105         uint40 lastBidTime;
106     }
107 
108     address public operatorAddress;
109 
110     struct Purchase
111     {
112         uint256 bid;
113         address winner;
114         uint16 auction;
115     }
116     Purchase[] public purchases;
117     Auction[] public auctions;
118 
119     // Allowed withdrawals of previous bids
120     mapping(address => uint) public pendingReturns;
121     uint public totalReturns;
122 
123     function getBiddingInfo(uint16 auction, address bidder) public view returns (
124         uint40 _timeEnd,
125         uint40 _lastBidTime,
126         uint256 _highestBid,
127         address _highestBidder,
128         bool _isEnded,
129         uint256 _pendingReturn)
130     {
131         _timeEnd = auctions[auction].timeEnd;
132         _lastBidTime = auctions[auction].lastBidTime;
133         _highestBid = auctions[auction].highestBid;
134         _highestBidder = auctions[auction].highestBidder;
135         _isEnded = isEnded(auction);
136         _pendingReturn = pendingReturns[bidder];
137     }
138 
139     function getAuctions(address bidder) public view returns (
140         uint40[5] _timeEnd,
141         uint40[5] _lastBidTime,
142         uint256[5] _highestBid,
143         address[5] _highestBidder,
144         uint16[5] _auctionIndex,
145         uint256 _pendingReturn)
146     {
147         _pendingReturn = pendingReturns[bidder];
148 
149         uint16 j = 0;
150         for (uint16 i = 0; i < auctions.length; i++)
151         {
152             if (!isEnded(i))
153             {
154                 _timeEnd[j] = auctions[i].timeEnd;
155                 _lastBidTime[j] = auctions[i].lastBidTime;
156                 _highestBid[j] = auctions[i].highestBid;
157                 _highestBidder[j] = auctions[i].highestBidder;
158                 _auctionIndex[j] = i;
159                 j++;
160                 if (j > 5)
161                 {
162                     break;
163                 }
164             }
165         }
166     }
167 
168     /// Withdraw a bid that was overbid.
169     function withdraw() public {
170         uint amount = pendingReturns[msg.sender];
171         require (amount > 0);
172 
173         // It is important to set this to zero because the recipient
174         // can call this function again as part of the receiving call
175         // before `send` returns.
176 
177         totalReturns -= amount;
178         pendingReturns[msg.sender] -= amount;
179 
180         msg.sender.transfer(amount);
181     }
182 
183     function finish(uint16 auction) public onlyOperator
184     {
185         if (auctions[auction].highestBidder != address(0))
186         {
187             purchases.push(Purchase(auctions[auction].highestBid, auctions[auction].highestBidder, auction)); // archive last winner
188         }
189         auctions[auction].timeEnd = 0;
190     }
191 
192     function addAuction(uint40 _duration, uint256 _startPrice) public onlyOperator
193     {
194         auctions.push(Auction(_startPrice, address(0), _duration + uint40(now), 0));
195     }
196 
197     function isEnded(uint16 auction) public view returns (bool)
198     {
199         return auctions[auction].timeEnd < now;
200     }
201 
202     function bid(uint16 auction, uint256 useFromPendingReturn) public payable whenNotPaused
203     {
204         if (auctions[auction].highestBidder != address(0))
205         {
206             pendingReturns[auctions[auction].highestBidder] += auctions[auction].highestBid;
207             totalReturns += auctions[auction].highestBid;
208         }
209 
210         require (useFromPendingReturn <= pendingReturns[msg.sender]);
211 
212         uint256 bank = useFromPendingReturn;
213         pendingReturns[msg.sender] -= bank;
214         totalReturns -= bank;
215 
216         uint256 currentBid = bank + msg.value;
217 
218         require(currentBid > auctions[auction].highestBid ||
219          currentBid == auctions[auction].highestBid && auctions[auction].highestBidder == address(0));
220         require(!isEnded(auction));
221 
222         auctions[auction].highestBid = currentBid;
223         auctions[auction].highestBidder = msg.sender;
224         auctions[auction].lastBidTime = uint40(now);
225     }
226 
227     function purchasesCount() public view returns (uint256)
228     {
229         return purchases.length;
230     }
231 
232     function destroyContract() public onlyOwner {
233         require(address(this).balance == 0);
234         selfdestruct(msg.sender);
235     }
236 
237     function withdrawEthFromBalance() external onlyOwner
238     {
239         owner.transfer(address(this).balance - totalReturns);
240     }
241 
242     function setOperator(address _operator) public onlyOwner
243     {
244         operatorAddress = _operator;
245     }
246 
247     modifier onlyOperator() {
248         require(msg.sender == operatorAddress || msg.sender == owner);
249         _;
250     }
251 }