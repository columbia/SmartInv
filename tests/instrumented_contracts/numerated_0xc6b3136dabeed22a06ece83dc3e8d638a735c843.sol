1 pragma solidity ^0.4.19;
2 
3 contract EtherJackpot {
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
49     uint public constant BASE_DURATION = 100 minutes;
50 
51     // Amount by which the countdown duration decreases per ether in the pot
52     uint public constant DURATION_DECREASE_PER_ETHER = 2 minutes;
53 
54     // Minimum countdown duration
55     uint public constant MINIMUM_DURATION = 10 minutes;
56 
57     // Fraction of the previous pot used to seed the next pot
58     uint public constant NEXT_POT_FRAC_TOP = 3;
59     uint public constant NEXT_POT_FRAC_BOT = 10;
60 
61     // Minimum fraction of the pot required by a bidder to become the new leader
62     uint public constant MIN_LEADER_FRAC_TOP = 1;
63     uint public constant MIN_LEADER_FRAC_BOT = 1000;
64 
65     // Fraction of each bid put into the dividend fund
66     uint public constant DIVIDEND_FUND_FRAC_TOP = 25;
67     uint public constant DIVIDEND_FUND_FRAC_BOT = 100;
68 
69     // Fraction of each bid taken for the developer fee
70     uint public constant DEVELOPER_FEE_FRAC_TOP = 1;
71     uint public constant DEVELOPER_FEE_FRAC_BOT = 100;
72 
73     // Owner of the contract
74     address owner;
75 
76     // Mapping from addresses to amounts earned
77     mapping(address => uint) public earnings;
78 
79     // Mapping from addresses to dividend shares
80     mapping(address => uint) public dividendShares;
81 
82     // Total number of dividend shares
83     uint public totalDividendShares;
84 
85     // Value of the dividend fund
86     uint public dividendFund;
87 
88     // Current round number
89     uint public round;
90 
91     // Current value of the pot
92     uint public pot;
93 
94     // Address of the current leader
95     address public leader;
96 
97     // Time at which the current round expires
98     uint public deadline;
99 
100     function EtherJackpot() public payable {
101         require(msg.value > 0);
102         owner = msg.sender;
103         round = 1;
104         pot = msg.value;
105         leader = owner;
106         deadline = computeDeadline();
107         NewRound(now, round, pot);
108         NewLeader(now, leader, pot, deadline);
109     }
110 
111     function computeDeadline() internal view returns (uint) {
112         uint _durationDecrease = DURATION_DECREASE_PER_ETHER.mul(pot.div(1 ether));
113         uint _duration;
114         if (MINIMUM_DURATION.add(_durationDecrease) > BASE_DURATION) {
115             _duration = MINIMUM_DURATION;
116         } else {
117             _duration = BASE_DURATION.sub(_durationDecrease);
118         }
119         return now.add(_duration);
120     }
121 
122     modifier advanceRoundIfNeeded {
123         if (now > deadline) {
124             uint _nextPot = pot.mul(NEXT_POT_FRAC_TOP).div(NEXT_POT_FRAC_BOT);
125             uint _leaderEarnings = pot.sub(_nextPot);
126             Winner(now, leader, _leaderEarnings, deadline);
127             earnings[leader] = earnings[leader].add(_leaderEarnings);
128             round++;
129             pot = _nextPot;
130             leader = owner;
131             deadline = computeDeadline();
132             NewRound(now, round, pot);
133             NewLeader(now, leader, pot, deadline);
134         }
135         _;
136     }
137 
138     function bid() public payable advanceRoundIfNeeded {
139         uint _minLeaderAmount = pot.mul(MIN_LEADER_FRAC_TOP).div(MIN_LEADER_FRAC_BOT);
140         uint _bidAmountToDeveloper = msg.value.mul(DEVELOPER_FEE_FRAC_TOP).div(DEVELOPER_FEE_FRAC_BOT);
141         uint _bidAmountToDividendFund = msg.value.mul(DIVIDEND_FUND_FRAC_TOP).div(DIVIDEND_FUND_FRAC_BOT);
142         uint _bidAmountToPot = msg.value.sub(_bidAmountToDeveloper).sub(_bidAmountToDividendFund);
143 
144         earnings[owner] = earnings[owner].add(_bidAmountToDeveloper);
145         dividendFund = dividendFund.add(_bidAmountToDividendFund);
146         pot = pot.add(_bidAmountToPot);
147         Bid(now, msg.sender, msg.value, pot);
148 
149         if (msg.value >= _minLeaderAmount) {
150             uint _dividendShares = msg.value.div(_minLeaderAmount);
151             dividendShares[msg.sender] = dividendShares[msg.sender].add(_dividendShares);
152             totalDividendShares = totalDividendShares.add(_dividendShares);
153             leader = msg.sender;
154             deadline = computeDeadline();
155             NewLeader(now, leader, pot, deadline);
156         }
157     }
158 
159     function withdrawEarnings() public advanceRoundIfNeeded {
160         require(earnings[msg.sender] > 0);
161         assert(earnings[msg.sender] <= this.balance);
162         uint _amount = earnings[msg.sender];
163         earnings[msg.sender] = 0;
164         msg.sender.transfer(_amount);
165         EarningsWithdrawal(now, msg.sender, _amount);
166     }
167 
168     function withdrawDividends() public {
169         require(dividendShares[msg.sender] > 0);
170         uint _dividendShares = dividendShares[msg.sender];
171         assert(_dividendShares <= totalDividendShares);
172         uint _amount = dividendFund.mul(_dividendShares).div(totalDividendShares);
173         assert(_amount <= this.balance);
174         dividendShares[msg.sender] = 0;
175         totalDividendShares = totalDividendShares.sub(_dividendShares);
176         dividendFund = dividendFund.sub(_amount);
177         msg.sender.transfer(_amount);
178         DividendsWithdrawal(now, msg.sender, _dividendShares, _amount, totalDividendShares, dividendFund);
179     }
180 }
181 
182 /**
183  * @title SafeMath
184  * @dev Math operations with safety checks that throw on error
185  */
186 library SafeMath {
187     /**
188     * @dev Multiplies two numbers, throws on overflow.
189     */
190     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
191         if (a == 0) {
192             return 0;
193         }
194         uint256 c = a * b;
195         assert(c / a == b);
196         return c;
197     }
198 
199     /**
200     * @dev Integer division of two numbers, truncating the quotient.
201     */
202     function div(uint256 a, uint256 b) internal pure returns (uint256) {
203         // assert(b > 0); // Solidity automatically throws when dividing by 0
204         uint256 c = a / b;
205         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
206         return c;
207     }
208 
209     /**
210     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
211     */
212     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
213         assert(b <= a);
214         return a - b;
215     }
216 
217     /**
218     * @dev Adds two numbers, throws on overflow.
219     */
220     function add(uint256 a, uint256 b) internal pure returns (uint256) {
221         uint256 c = a + b;
222         assert(c >= a);
223         return c;
224     }
225 }