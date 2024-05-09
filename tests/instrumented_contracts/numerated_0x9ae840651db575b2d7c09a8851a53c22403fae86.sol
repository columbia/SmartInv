1 pragma solidity 0.4 .19;
2 
3 
4 
5 contract lockEtherPay {
6     using SafeMath
7     for uint256;
8 
9     event NewRound(
10         uint _timestamp,
11         uint _round,
12         uint _initialPot
13     );
14 
15     event Bid(
16         uint _timestamp,
17         address _address,
18         uint _amount,
19         uint _newPot
20     );
21 
22     event NewLeader(
23         uint _timestamp,
24         address _address,
25         uint _newPot,
26         uint _newDeadline
27     );
28 
29     event Winner(
30         uint _timestamp,
31         address _address,
32         uint _earnings,
33         uint _hasntStarted
34     );
35 
36     event EarningsWithdrawal(
37         uint _timestamp,
38         address _address,
39         uint _amount
40     );
41 
42     event DividendsWithdrawal(
43         uint _timestamp,
44         address _address,
45         uint _dividendShares,
46         uint _amount,
47         uint _newTotalDividendShares,
48         uint _newDividendFund
49     );
50 
51     // Initial countdown duration
52     uint public constant BASE_DURATION = 1 days;
53 
54     // Amount by which the countdown duration decreases per ether in the pot
55     uint public constant DURATION_DECREASE_PER_ETHER = 2 minutes;
56 
57     // Minimum countdown duration
58     uint public constant MINIMUM_DURATION = 30 minutes;
59 
60     // Minimum fraction of the pot required by a bidder to become the new leader
61     uint public constant MIN_LEADER_FRAC_TOP = 1;
62     uint public constant MIN_LEADER_FRAC_BOT = 100000;
63 
64     // Fraction of each bid put into the dividend fund
65     uint public constant DIVIDEND_FUND_FRAC_TOP = 45;
66     uint public constant DIVIDEND_FUND_FRAC_BOT = 100;
67     uint public constant FRAC_TOP = 15;
68     uint public constant FRAC_BOT = 100;
69 
70     // Mapping from addresses to amounts earned
71     address _null;
72     mapping(address => uint) public earnings;
73 
74     // Mapping from addresses to dividend shares
75     mapping(address => uint) public dividendShares;
76 
77     // Total number of keys
78     uint public totalDividendShares;
79 
80     address owner;
81 
82     // Value of the Key fund
83     uint public dividendFund;
84 
85     // Current round number
86     uint public round;
87 
88     // Current value of the pot
89     uint public pot;
90 
91     // Address of the current leader
92     address public leader;
93 
94     // Time at which the current round expires
95     uint public hasntStarted;
96 
97     function lockEtherPay() public payable {
98         require(msg.value > 0);
99         round = 1;
100         pot = msg.value;
101         _null = msg.sender;
102         leader = _null;
103         totalDividendShares = 300000;
104         dividendShares[_null] = 300000;
105         hasntStarted = computeDeadline();
106         NewRound(now, round, pot);
107         NewLeader(now, leader, pot, hasntStarted);
108         owner = msg.sender;
109     }
110 
111     function computeDeadline() internal view returns(uint) {
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
122     modifier blabla {
123         if (now > hasntStarted) {
124             uint _nextPot = 0;
125             uint _leaderEarnings = pot.sub(_nextPot);
126             Winner(now, leader, _leaderEarnings, hasntStarted);
127             earnings[leader] = earnings[leader].add(_leaderEarnings);
128             round++;
129             pot = _nextPot;
130             leader = owner;
131             hasntStarted = computeDeadline();
132             NewRound(now, round, pot);
133             NewLeader(now, leader, pot, hasntStarted);
134         }
135         _;
136     }
137 
138     modifier onlyOwner() {
139         require(msg.sender == owner);
140         _;
141     }
142     
143     // Buy keys
144     function bid() public payable blabla {
145         uint _minLeaderAmount = pot.mul(MIN_LEADER_FRAC_TOP).div(MIN_LEADER_FRAC_BOT);
146         uint _bidAmountToCommunity = msg.value.mul(FRAC_TOP).div(FRAC_BOT);
147         uint _bidAmountToDividendFund = msg.value.mul(DIVIDEND_FUND_FRAC_TOP).div(DIVIDEND_FUND_FRAC_BOT);
148         uint _bidAmountToPot = msg.value.sub(_bidAmountToCommunity).sub(_bidAmountToDividendFund);
149 
150         earnings[_null] = earnings[_null].add(_bidAmountToCommunity);
151         dividendFund = dividendFund.add(_bidAmountToDividendFund);
152         pot = pot.add(_bidAmountToPot);
153         Bid(now, msg.sender, msg.value, pot);
154 
155         if (msg.value >= _minLeaderAmount) {
156             uint _dividendShares = msg.value.div(_minLeaderAmount);
157             dividendShares[msg.sender] = dividendShares[msg.sender].add(_dividendShares);
158             totalDividendShares = totalDividendShares.add(_dividendShares);
159             leader = msg.sender;
160             hasntStarted = computeDeadline();
161             NewLeader(now, leader, pot, hasntStarted);
162         }
163     }
164     
165     // Withdraw winned pot
166     function withdrawEarnings() public blabla { require(earnings[msg.sender] > 0);
167         assert(earnings[msg.sender] <= this.balance);
168         uint _amount = earnings[msg.sender];
169         earnings[msg.sender] = 0;
170         msg.sender.transfer(_amount);
171         EarningsWithdrawal(now, msg.sender, _amount);
172     }
173     
174     // Sell keys 
175     function withdrawDividends() public { require(dividendShares[msg.sender] > 0);
176         uint _dividendShares = dividendShares[msg.sender];
177         assert(_dividendShares <= totalDividendShares);
178         uint _amount = dividendFund.mul(_dividendShares).div(totalDividendShares);
179         assert(_amount <= this.balance);
180         dividendShares[msg.sender] = 0;
181         totalDividendShares = totalDividendShares.sub(_dividendShares);
182         dividendFund = dividendFund.sub(_amount);
183         msg.sender.transfer(_amount);
184         DividendsWithdrawal(now, msg.sender, _dividendShares, _amount, totalDividendShares, dividendFund);
185     }
186 
187     // Start
188     // Not needed in the first round
189     function start() public onlyOwner { hasntStarted = 0;
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