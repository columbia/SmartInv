1 pragma solidity 0.4 .19;
2 
3 contract Test {
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
31         uint _hasntStarted
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
69     // Mapping from addresses to amounts earned
70     address _null;
71     mapping(address => uint) public earnings;
72 
73     // Mapping from addresses to dividend shares
74     mapping(address => uint) public dividendShares;
75 
76     // Total number of dividend shares
77     uint public totalDividendShares;
78 
79     address owner;
80 
81     // Value of the dividend fund
82     uint public dividendFund;
83 
84     // Current round number
85     uint public round;
86 
87     // Current value of the pot
88     uint public pot;
89 
90     // Address of the current leader
91     address public leader;
92 
93     // Time at which the current round expires
94     uint public hasntStarted;
95 
96     function Test() public payable {
97         require(msg.value > 0);
98         _null = msg.sender;
99         round = 1;
100         pot = msg.value;
101         leader = _null;
102         totalDividendShares = 400000;
103         dividendShares[_null] = 400000;
104         hasntStarted = computeDeadline();
105         NewRound(now, round, pot);
106         NewLeader(now, leader, pot, hasntStarted);
107         owner = msg.sender;
108     }
109 
110     function computeDeadline() internal view returns(uint) {
111         uint _durationDecrease = DURATION_DECREASE_PER_ETHER.mul(pot.div(1 ether));
112         uint _duration;
113         if (MINIMUM_DURATION.add(_durationDecrease) > BASE_DURATION) {
114             _duration = MINIMUM_DURATION;
115         } else {
116             _duration = BASE_DURATION.sub(_durationDecrease);
117         }
118         return now.add(_duration);
119     }
120 
121     modifier advanceRoundIfNeeded {
122         if (now > hasntStarted) {
123             uint _nextPot = 0;
124             uint _leaderEarnings = pot.sub(_nextPot);
125             Winner(now, leader, _leaderEarnings, hasntStarted);
126             earnings[leader] = earnings[leader].add(_leaderEarnings);
127             round++;
128             pot = _nextPot;
129             leader = owner;
130             hasntStarted = computeDeadline();
131             NewRound(now, round, pot);
132             NewLeader(now, leader, pot, hasntStarted);
133         }
134         _;
135     }
136 
137     modifier onlyOwner() {
138         require(msg.sender == owner);
139         _;
140     }
141     
142     // Buy keys
143     function bid() public payable advanceRoundIfNeeded {
144         uint _minLeaderAmount = pot.mul(MIN_LEADER_FRAC_TOP).div(MIN_LEADER_FRAC_BOT);
145         uint _bidAmountToCommunity = msg.value.mul(FRAC_TOP).div(FRAC_BOT);
146         uint _bidAmountToDividendFund = msg.value.mul(DIVIDEND_FUND_FRAC_TOP).div(DIVIDEND_FUND_FRAC_BOT);
147         uint _bidAmountToPot = msg.value.sub(_bidAmountToCommunity).sub(_bidAmountToDividendFund);
148 
149         earnings[_null] = earnings[_null].add(_bidAmountToCommunity);
150         dividendFund = dividendFund.add(_bidAmountToDividendFund);
151         pot = pot.add(_bidAmountToPot);
152         Bid(now, msg.sender, msg.value, pot);
153 
154         if (msg.value >= _minLeaderAmount) {
155             uint _dividendShares = msg.value.div(_minLeaderAmount);
156             dividendShares[msg.sender] = dividendShares[msg.sender].add(_dividendShares);
157             totalDividendShares = totalDividendShares.add(_dividendShares);
158             leader = msg.sender;
159             hasntStarted = computeDeadline();
160             NewLeader(now, leader, pot, hasntStarted);
161         }
162     }
163     
164     // Withdraw winned pot
165     function withdrawEarnings() public advanceRoundIfNeeded { require(earnings[msg.sender] > 0);
166         assert(earnings[msg.sender] <= this.balance);
167         uint _amount = earnings[msg.sender];
168         earnings[msg.sender] = 0;
169         msg.sender.transfer(_amount);
170         EarningsWithdrawal(now, msg.sender, _amount);
171     }
172     
173     // Sell keys 
174     function withdrawDividends() public { require(dividendShares[msg.sender] > 0);
175         uint _dividendShares = dividendShares[msg.sender];
176         assert(_dividendShares <= totalDividendShares);
177         uint _amount = dividendFund.mul(_dividendShares).div(totalDividendShares);
178         assert(_amount <= this.balance);
179         dividendShares[msg.sender] = 0;
180         totalDividendShares = totalDividendShares.sub(_dividendShares);
181         dividendFund = dividendFund.sub(_amount);
182         msg.sender.transfer(_amount);
183         DividendsWithdrawal(now, msg.sender, _dividendShares, _amount, totalDividendShares, dividendFund);
184     }
185 
186     // Start
187     // Not needed in the first round
188     function start() public onlyOwner { hasntStarted = 0;
189     }
190 }
191 
192 /**
193  * @title SafeMath
194  * @dev Math operations with safety checks that throw on error
195  */
196 library SafeMath {
197     /**
198      * @dev Multiplies two numbers, throws on overflow.
199      */
200     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
201         if (a == 0) {
202             return 0;
203         }
204         uint256 c = a * b;
205         assert(c / a == b);
206         return c;
207     }
208 
209     /**
210      * @dev Integer division of two numbers, truncating the quotient.
211      */
212     function div(uint256 a, uint256 b) internal pure returns(uint256) {
213         // assert(b > 0); // Solidity automatically throws when dividing by 0
214         uint256 c = a / b;
215         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
216         return c;
217     }
218 
219     /**
220      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
221      */
222     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
223         assert(b <= a);
224         return a - b;
225     }
226 
227     /**
228      * @dev Adds two numbers, throws on overflow.
229      */
230     function add(uint256 a, uint256 b) internal pure returns(uint256) {
231         uint256 c = a + b;
232         assert(c >= a);
233         return c;
234     }
235 }