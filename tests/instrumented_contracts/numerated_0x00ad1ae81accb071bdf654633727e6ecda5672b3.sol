1 pragma solidity 0.4.19;
2 
3 contract FOMO3DLite {
4     using SafeMath for uint256;
5 
6     event NewRound(
7         uint _timestamp,
8         uint _round,
9         uint _initialPot
10     );
11 
12     event Bid(
13         uint _timestamp,
14         address _address,
15         uint _amount,
16         uint _newPot
17     );
18 
19     event NewLeader(
20         uint _timestamp,
21         address _address,
22         uint _newPot,
23         uint _newDeadline
24     );
25 
26     event Winner(
27         uint _timestamp,
28         address _address,
29         uint _earnings,
30         uint _deadline
31     );
32 
33     event EarningsWithdrawal(
34         uint _timestamp,
35         address _address,
36         uint _amount
37     );
38 
39     event DividendsWithdrawal(
40         uint _timestamp,
41         address _address,
42         uint _dividendShares,
43         uint _amount,
44         uint _newTotalDividendShares,
45         uint _newDividendFund
46     );
47 
48     // Initial countdown duration at the start of each round
49     uint public constant BASE_DURATION = 1 days;
50 
51     // Amount by which the countdown duration decreases per ether in the pot
52     uint public constant DURATION_DECREASE_PER_ETHER = 1 minutes;
53 
54     // Minimum countdown duration
55     uint public constant MINIMUM_DURATION = 30 minutes;
56 
57 
58 
59     // Minimum fraction of the pot required by a bidder to become the new leader
60     uint public constant MIN_LEADER_FRAC_TOP = 1;
61     uint public constant MIN_LEADER_FRAC_BOT = 1000000;
62 
63     // Fraction of each bid put into the dividend fund
64     uint public constant DIVIDEND_FUND_FRAC_TOP = 40;
65     uint public constant DIVIDEND_FUND_FRAC_BOT = 100;
66 
67     // Fraction of each bid taken for the developer fee
68     uint public constant DEVELOPER_FEE_FRAC_TOP = 15;
69     uint public constant DEVELOPER_FEE_FRAC_BOT = 100;
70 
71     // Owner of the contract
72     address owner;
73 
74     // Mapping from addresses to amounts earned
75     mapping(address => uint) public earnings;
76 
77     // Mapping from addresses to dividend shares
78     mapping(address => uint) public dividendShares;
79 
80     // Total number of dividend shares
81     uint public totalDividendShares;
82 
83     // Value of the dividend fund
84     uint public dividendFund;
85 
86     // Current round number
87     uint public round;
88 
89     // Current value of the pot
90     uint public pot;
91 
92     // Address of the current leader
93     address public leader;
94 
95     // Time at which the current round expires
96     uint public deadline;
97 
98     function FOMO3DLite() public payable {
99         require(msg.value > 0);
100         owner = msg.sender;
101         round = 1;
102         pot = msg.value;
103         leader = owner;
104         deadline = computeDeadline();
105         NewRound(now, round, pot);
106         NewLeader(now, leader, pot, deadline);
107     }
108 
109     function computeDeadline() internal view returns (uint) {
110         uint _durationDecrease = DURATION_DECREASE_PER_ETHER.mul(pot.div(1 ether));
111         uint _duration;
112         if (MINIMUM_DURATION.add(_durationDecrease) > BASE_DURATION) {
113             _duration = MINIMUM_DURATION;
114         } else {
115             _duration = BASE_DURATION.sub(_durationDecrease);
116         }
117         return now.add(_duration);
118     }
119 
120     modifier advanceRoundIfNeeded {
121         if (now > deadline) {
122             uint _nextPot = 0;
123             uint _leaderEarnings = pot.sub(_nextPot);
124             Winner(now, leader, _leaderEarnings, deadline);
125             earnings[leader] = earnings[leader].add(_leaderEarnings);
126             round++;
127             pot = _nextPot;
128             leader = owner;
129             deadline = computeDeadline();
130             NewRound(now, round, pot);
131             NewLeader(now, leader, pot, deadline);
132         }
133         _;
134     }
135 
136     function bid() public payable advanceRoundIfNeeded {
137         uint _minLeaderAmount = pot.mul(MIN_LEADER_FRAC_TOP).div(MIN_LEADER_FRAC_BOT);
138         uint _bidAmountToDeveloper = msg.value.mul(DEVELOPER_FEE_FRAC_TOP).div(DEVELOPER_FEE_FRAC_BOT);
139         uint _bidAmountToDividendFund = msg.value.mul(DIVIDEND_FUND_FRAC_TOP).div(DIVIDEND_FUND_FRAC_BOT);
140         uint _bidAmountToPot = msg.value.sub(_bidAmountToDeveloper).sub(_bidAmountToDividendFund);
141 
142         earnings[owner] = earnings[owner].add(_bidAmountToDeveloper);
143         dividendFund = dividendFund.add(_bidAmountToDividendFund);
144         pot = pot.add(_bidAmountToPot);
145         Bid(now, msg.sender, msg.value, pot);
146 
147         if (msg.value >= _minLeaderAmount) {
148             uint _dividendShares = msg.value.div(_minLeaderAmount);
149             dividendShares[msg.sender] = dividendShares[msg.sender].add(_dividendShares);
150             totalDividendShares = totalDividendShares.add(_dividendShares);
151             leader = msg.sender;
152             deadline = computeDeadline();
153             NewLeader(now, leader, pot, deadline);
154         }
155     }
156 
157     function withdrawEarnings() public advanceRoundIfNeeded {
158         require(earnings[msg.sender] > 0);
159         assert(earnings[msg.sender] <= this.balance);
160         uint _amount = earnings[msg.sender];
161         earnings[msg.sender] = 0;
162         msg.sender.transfer(_amount);
163         EarningsWithdrawal(now, msg.sender, _amount);
164     }
165 
166     function withdrawDividends() public {
167         require(dividendShares[msg.sender] > 0);
168         uint _dividendShares = dividendShares[msg.sender];
169         assert(_dividendShares <= totalDividendShares);
170         uint _amount = dividendFund.mul(_dividendShares).div(totalDividendShares);
171         assert(_amount <= this.balance);
172         dividendShares[msg.sender] = 0;
173         totalDividendShares = totalDividendShares.sub(_dividendShares);
174         dividendFund = dividendFund.sub(_amount);
175         msg.sender.transfer(_amount);
176         DividendsWithdrawal(now, msg.sender, _dividendShares, _amount, totalDividendShares, dividendFund);
177     }
178 }
179 
180 /**
181  * @title SafeMath
182  * @dev Math operations with safety checks that throw on error
183  */
184 library SafeMath {
185     /**
186     * @dev Multiplies two numbers, throws on overflow.
187     */
188     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
189         if (a == 0) {
190             return 0;
191         }
192         uint256 c = a * b;
193         assert(c / a == b);
194         return c;
195     }
196 
197     /**
198     * @dev Integer division of two numbers, truncating the quotient.
199     */
200     function div(uint256 a, uint256 b) internal pure returns (uint256) {
201         // assert(b > 0); // Solidity automatically throws when dividing by 0
202         uint256 c = a / b;
203         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
204         return c;
205     }
206 
207     /**
208     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
209     */
210     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
211         assert(b <= a);
212         return a - b;
213     }
214 
215     /**
216     * @dev Adds two numbers, throws on overflow.
217     */
218     function add(uint256 a, uint256 b) internal pure returns (uint256) {
219         uint256 c = a + b;
220         assert(c >= a);
221         return c;
222     }
223 }