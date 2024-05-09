1 // based on Bryn Bellomy code
2 // https://medium.com/@bryn.bellomy/solidity-tutorial-building-a-simple-auction-contract-fcc918b0878a
3 //
4 // updated to 0.4.21 standard, replaced blocks with time, converted to hot potato style by Chibi Fighters
5 // added custom start command for owner so they don't take off immidiately
6 //
7 
8 pragma solidity ^0.4.21;
9 
10 /**
11 * @title SafeMath
12 * @dev Math operations with safety checks that throw on error
13 */
14 library SafeMath {
15 
16     /**
17     * @dev Multiplies two numbers, throws on overflow.
18     */
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         if (a == 0) {
21             return 0;
22         }
23         uint256 c = a * b;
24         assert(c / a == b);
25         return c;
26     }
27 
28     /**
29     * @dev Integer division of two numbers, truncating the quotient.
30     */
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         // assert(b > 0); // Solidity automatically throws when dividing by 0
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35         return c;
36     }
37 
38     /**
39     * @dev Substracts two numbers, returns 0 if it would go into minus range.
40     */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         if (b >= a) {
43             return 0;
44         }
45         return a - b;
46     }
47 
48     /**
49     * @dev Adds two numbers, throws on overflow.
50     */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         assert(c >= a);
54         return c;
55     }
56 }
57 
58 contract AuctionPotato {
59     using SafeMath for uint256; 
60     // static
61     address public owner;
62     uint public bidIncrement;
63     uint public startTime;
64     uint public endTime;
65     string public infoUrl;
66     string name;
67     
68     // start auction manually at given time
69     bool started;
70 
71     // pototo
72     uint public potato;
73     
74     // state
75     bool public canceled;
76     
77     uint public highestBindingBid;
78     address public highestBidder;
79     
80     mapping(address => uint256) public fundsByBidder;
81     bool ownerHasWithdrawn;
82 
83     event LogBid(address bidder, uint bid, address highestBidder, uint highestBindingBid);
84     event LogWithdrawal(address withdrawer, address withdrawalAccount, uint amount);
85     event LogCanceled();
86     
87     
88     // initial settings on contract creation
89     constructor() public {
90 
91         owner = msg.sender;
92         // 0.01 ETH
93         bidIncrement = 10000000000000000;
94         
95         started = false;
96         
97         name = "Lizard People";
98         infoUrl = "https://chibifighters.io";
99         
100     }
101 
102     function getHighestBid() internal
103         constant
104         returns (uint)
105     {
106         return fundsByBidder[highestBidder];
107     }
108     
109     function timeLeft() public view returns (uint time) {
110         if (now >= endTime) return 0;
111         return endTime - now;
112     }
113     
114     function auctionName() public view returns (string _name) {
115         return name;
116     }
117     
118     function nextBid() public view returns (uint _nextBid) {
119         return bidIncrement.add(highestBindingBid).add(potato);
120     }
121     
122     function startAuction(string _name, uint _duration_secs) public onlyOwner returns (bool success){
123         require(started == false);
124         
125         started = true;
126         startTime = now;
127         endTime = now + _duration_secs;
128         name = _name;
129         
130         return true;
131         
132     }
133     
134     function isStarted() public view returns (bool success) {
135         return started;
136     }
137 
138     function placeBid() public
139         payable
140         onlyAfterStart
141         onlyBeforeEnd
142         onlyNotCanceled
143         onlyNotOwner
144         returns (bool success)
145     {   
146         // we are only allowing to increase in bidIncrements to make for true hot potato style
147         require(msg.value == highestBindingBid.add(bidIncrement).add(potato));
148         require(msg.sender != highestBidder);
149         require(started == true);
150         
151         // calculate the user's total bid based on the current amount they've sent to the contract
152         // plus whatever has been sent with this transaction
153         uint newBid = highestBindingBid.add(bidIncrement);
154 
155         fundsByBidder[msg.sender] = fundsByBidder[msg.sender].add(newBid);
156         
157         fundsByBidder[highestBidder] = fundsByBidder[highestBidder].add(potato);
158         
159         // set new highest bidder
160         highestBidder = msg.sender;
161         highestBindingBid = newBid;
162         
163         // set new increment size
164         bidIncrement = bidIncrement.mul(5).div(4);
165         
166         // 10% potato
167         potato = highestBindingBid.div(100).mul(20);
168         
169         emit LogBid(msg.sender, newBid, highestBidder, highestBindingBid);
170         return true;
171     }
172 
173     function cancelAuction() public
174         onlyOwner
175         onlyBeforeEnd
176         onlyNotCanceled
177         returns (bool success)
178     {
179         canceled = true;
180         emit LogCanceled();
181         return true;
182     }
183 
184     function withdraw() public
185     // can withdraw once overbid
186         returns (bool success)
187     {
188         address withdrawalAccount;
189         uint withdrawalAmount;
190 
191         if (canceled) {
192             // if the auction was canceled, everyone should simply be allowed to withdraw their funds
193             withdrawalAccount = msg.sender;
194             withdrawalAmount = fundsByBidder[withdrawalAccount];
195             // set funds to 0
196             fundsByBidder[withdrawalAccount] = 0;
197         }
198         
199         // owner can withdraw once auction is cancelled or ended
200         //if (ownerHasWithdrawn == false && msg.sender == owner && (canceled == true || now > endTime)) {
201         if (msg.sender == owner) {
202             withdrawalAccount = owner;
203             withdrawalAmount = highestBindingBid;
204             ownerHasWithdrawn = true;
205             
206             // set funds to 0
207             fundsByBidder[withdrawalAccount] = 0;
208         }
209         
210         // overbid people can withdraw their bid + profit
211         // exclude owner because he is set above
212         if (!canceled && (msg.sender != highestBidder && msg.sender != owner)) {
213             withdrawalAccount = msg.sender;
214             withdrawalAmount = fundsByBidder[withdrawalAccount];
215             fundsByBidder[withdrawalAccount] = 0;
216         }
217 
218         // highest bidder can withdraw leftovers if he didn't before
219         if (msg.sender == highestBidder && msg.sender != owner) {
220             withdrawalAccount = msg.sender;
221             withdrawalAmount = fundsByBidder[withdrawalAccount].sub(highestBindingBid);
222             fundsByBidder[withdrawalAccount] = fundsByBidder[withdrawalAccount].sub(withdrawalAmount);
223         }
224 
225         if (withdrawalAmount == 0) revert();
226     
227         // send the funds
228         if (!msg.sender.send(withdrawalAmount)) revert();
229 
230         emit LogWithdrawal(msg.sender, withdrawalAccount, withdrawalAmount);
231 
232         return true;
233     }
234     
235     // just in case the contract is bust and can't pay
236     function fuelContract() public onlyOwner payable {
237         
238     }
239     
240     function balance() public view returns (uint _balance) {
241         return address(this).balance;
242     }
243 
244     modifier onlyOwner {
245         if (msg.sender != owner) revert();
246         _;
247     }
248 
249     modifier onlyNotOwner {
250         if (msg.sender == owner) revert();
251         _;
252     }
253 
254     modifier onlyAfterStart {
255         if (now < startTime) revert();
256         _;
257     }
258 
259     modifier onlyBeforeEnd {
260         if (now > endTime) revert();
261         _;
262     }
263 
264     modifier onlyNotCanceled {
265         if (canceled) revert();
266         _;
267     }
268 }