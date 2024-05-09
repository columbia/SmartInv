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
100     uint40 public timeEnd;
101     uint40 public lastBidTime;
102     uint256 public highestBid;
103     address public highestBidder;
104 
105     address public operatorAddress;
106 
107     struct Purchase
108     {
109         address winner;
110         uint256 bid;
111     }
112     Purchase[] public purchases;
113 
114     // Allowed withdrawals of previous bids
115     mapping(address => uint) public pendingReturns;
116     uint public totalReturns;
117 
118     function getBiddingInfo(address bidder) public view returns (
119         uint40 _timeEnd,
120         uint40 _lastBidTime,
121         uint256 _highestBid,
122         address _highestBidder,
123         bool _isEnded,
124         uint256 _pendingReturn)
125     {
126         _timeEnd = timeEnd;
127         _lastBidTime = lastBidTime;
128         _highestBid = highestBid;
129         _highestBidder = highestBidder;
130         _isEnded = isEnded();
131         _pendingReturn = pendingReturns[bidder];
132     }
133 
134     /// Withdraw a bid that was overbid.
135     function withdraw() public {
136         uint amount = pendingReturns[msg.sender];
137         require (amount > 0);
138         
139         // It is important to set this to zero because the recipient
140         // can call this function again as part of the receiving call
141         // before `send` returns.
142 
143         totalReturns -= amount;
144         pendingReturns[msg.sender] -= amount;
145 
146         msg.sender.transfer(amount);
147     }
148 
149     function finish() public onlyOperator
150     {
151         if (highestBidder != address(0))
152         {
153             purchases.push(Purchase(highestBidder, highestBid)); // archive last winner
154             highestBidder = address(0);
155         }
156         timeEnd = 0;
157     }
158 
159     function setBidding(uint40 _duration, uint256 _startPrice) public onlyOperator
160     {
161         finish();
162 
163         timeEnd = _duration + uint40(now);
164         highestBid = _startPrice;
165     }
166 
167     function isEnded() public view returns (bool)
168     {
169         return timeEnd < now;
170     }
171 
172     function bid() public payable whenNotPaused
173     {
174         if (highestBidder != address(0))
175         {
176             pendingReturns[highestBidder] += highestBid;
177             totalReturns += highestBid;
178         }
179 
180         uint256 bank = pendingReturns[msg.sender];
181         pendingReturns[msg.sender] = 0;
182         totalReturns -= bank;
183 
184         uint256 currentBid = bank + msg.value;
185 
186         require(currentBid > highestBid);
187         require(!isEnded());
188 
189 
190         highestBid = currentBid;
191         highestBidder = msg.sender;
192         lastBidTime = uint40(now);
193     }
194 
195     function purchasesCount() public view returns (uint256)
196     {
197         return purchases.length;
198     }
199 
200     function destroyContract() public onlyOwner {
201         require(isEnded());
202         require(address(this).balance == 0);
203         selfdestruct(msg.sender);
204     }
205 
206     function() external payable {
207         bid();
208     }
209 
210     function withdrawEthFromBalance() external onlyOwner
211     {
212         require(isEnded());
213         owner.transfer(address(this).balance - totalReturns);
214     }
215 
216     function setOperator(address _operator) public onlyOwner
217     {
218         operatorAddress = _operator;
219     }
220 
221     modifier onlyOperator() {
222         require(msg.sender == operatorAddress || msg.sender == owner);
223         _;
224     }
225 }