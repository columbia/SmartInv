1 pragma solidity ^0.4.20;
2 
3 contract EtherHellFaucet {
4     using SafeMath for uint256;
5 
6     event Bid(
7         uint _timestamp,
8         address _address,
9         uint _amount,
10         uint _cappedAmount,
11         uint _newRound,
12         uint _newPot
13     );
14 
15     event Winner(
16         uint _timestamp,
17         address _address,
18         uint _totalPayout,
19         uint _round,
20         uint _leaderTimestamp
21     );
22 
23     event EarningsWithdrawal(
24         uint _timestamp,
25         address _address,
26         uint _amount
27     );
28 
29     event DividendsWithdrawal(
30         uint _timestamp,
31         address _address,
32         uint _dividendShares,
33         uint _amount,
34         uint _newTotalDividendShares,
35         uint _newDividendFund
36     );
37 
38     // Amount of money distributed per payout as a fraction of the current bid
39     uint public constant PAYOUT_FRAC_TOP = 10;
40     uint public constant PAYOUT_FRAC_BOT = 100;
41 
42     // Amount of time between payouts
43     uint public constant PAYOUT_TIME = 5 minutes;
44 
45     // Maximum fraction of the pot that can be won in one round
46     uint public constant MAX_PAYOUT_FRAC_TOP = 1;
47     uint public constant MAX_PAYOUT_FRAC_BOT = 10;
48 
49     // Maximum bid as a fraction of the pot
50     uint public constant MAX_BID_FRAC_TOP = 1;
51     uint public constant MAX_BID_FRAC_BOT = 100;
52 
53     // Fraction of each bid put into the dividend fund
54     uint public constant DIVIDEND_FUND_FRAC_TOP = 1;
55     uint public constant DIVIDEND_FUND_FRAC_BOT = 2;
56 
57     // Owner of the contract
58     address owner;
59 
60     // Mapping from addresses to amounts earned
61     mapping(address => uint) public earnings;
62 
63     // Mapping from addresses to dividend shares
64     mapping(address => uint) public dividendShares;
65 
66     // Total number of dividend shares
67     uint public totalDividendShares;
68 
69     // Value of the dividend fund
70     uint public dividendFund;
71 
72     // Current round number
73     uint public round;
74 
75     // Value of the pot
76     uint public pot;
77 
78     // Address of the current leader
79     address public leader;
80 
81     // Time at which the most recent bid was placed
82     uint public leaderTimestamp;
83 
84     // Amount of the most recent bid, capped at the maximum bid
85     uint public leaderBid;
86 
87     function EtherHellFaucet() public payable {
88         require(msg.value > 0);
89         owner = msg.sender;
90         totalDividendShares = 0;
91         dividendFund = 0;
92         round = 0;
93         pot = msg.value;
94         leader = owner;
95         leaderTimestamp = now;
96         leaderBid = 0;
97         Bid(now, msg.sender, 0, 0, round, pot);
98     }
99 
100     function bid() public payable {
101         uint _maxPayout = pot.mul(MAX_PAYOUT_FRAC_TOP).div(MAX_PAYOUT_FRAC_BOT);
102         uint _numPayoutIntervals = now.sub(leaderTimestamp).div(PAYOUT_TIME);
103         uint _totalPayout = _numPayoutIntervals.mul(leaderBid).mul(PAYOUT_FRAC_TOP).div(PAYOUT_FRAC_BOT);
104         if (_totalPayout > _maxPayout) {
105             _totalPayout = _maxPayout;
106         }
107         earnings[leader] = earnings[leader].add(_totalPayout);
108         pot = pot.sub(_totalPayout);
109 
110         Winner(now, leader, _totalPayout, round, leaderTimestamp);
111 
112         uint _maxBid = pot.mul(MAX_BID_FRAC_TOP).div(MAX_BID_FRAC_BOT);
113         uint _bidAmountToDividendFund = msg.value.mul(DIVIDEND_FUND_FRAC_TOP).div(DIVIDEND_FUND_FRAC_BOT);
114         uint _bidAmountToPot = msg.value.sub(_bidAmountToDividendFund);
115 
116         uint _dividendSharePrice;
117         if (totalDividendShares == 0) {
118             _dividendSharePrice = _maxBid.mul(DIVIDEND_FUND_FRAC_TOP).div(DIVIDEND_FUND_FRAC_BOT);
119         } else {
120             _dividendSharePrice = dividendFund.div(totalDividendShares);
121         }
122 
123         dividendFund = dividendFund.add(_bidAmountToDividendFund);
124         pot = pot.add(_bidAmountToPot);
125 
126         if (msg.value > _maxBid) {
127             uint _investment = msg.value.sub(_maxBid).mul(DIVIDEND_FUND_FRAC_TOP).div(DIVIDEND_FUND_FRAC_BOT);
128             uint _dividendShares = _investment.div(_dividendSharePrice);
129             dividendShares[msg.sender] = dividendShares[msg.sender].add(_dividendShares);
130             totalDividendShares = totalDividendShares.add(_dividendShares);
131         }
132 
133         round++;
134         leader = msg.sender;
135         leaderTimestamp = now;
136         leaderBid = msg.value;
137         if (leaderBid > _maxBid) {
138             leaderBid = _maxBid;
139         }
140 
141         Bid(now, msg.sender, msg.value, leaderBid, round, pot);
142     }
143 
144     function withdrawEarnings() public {
145         require(earnings[msg.sender] > 0);
146         assert(earnings[msg.sender] <= this.balance);
147         uint _amount = earnings[msg.sender];
148         earnings[msg.sender] = 0;
149         msg.sender.transfer(_amount);
150         EarningsWithdrawal(now, msg.sender, _amount);
151     }
152 
153     function withdrawDividends() public {
154         require(dividendShares[msg.sender] > 0);
155         uint _dividendShares = dividendShares[msg.sender];
156         assert(_dividendShares <= totalDividendShares);
157         uint _amount = dividendFund.mul(_dividendShares).div(totalDividendShares);
158         assert(_amount <= this.balance);
159         dividendShares[msg.sender] = 0;
160         totalDividendShares = totalDividendShares.sub(_dividendShares);
161         dividendFund = dividendFund.sub(_amount);
162         msg.sender.transfer(_amount);
163         DividendsWithdrawal(now, msg.sender, _dividendShares, _amount, totalDividendShares, dividendFund);
164     }
165 }
166 
167 /**
168  * @title SafeMath
169  * @dev Math operations with safety checks that throw on error
170  */
171 library SafeMath {
172     /**
173     * @dev Multiplies two numbers, throws on overflow.
174     */
175     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
176         if (a == 0) {
177             return 0;
178         }
179         uint256 c = a * b;
180         assert(c / a == b);
181         return c;
182     }
183 
184     /**
185     * @dev Integer division of two numbers, truncating the quotient.
186     */
187     function div(uint256 a, uint256 b) internal pure returns (uint256) {
188         // assert(b > 0); // Solidity automatically throws when dividing by 0
189         uint256 c = a / b;
190         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
191         return c;
192     }
193 
194     /**
195     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
196     */
197     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
198         assert(b <= a);
199         return a - b;
200     }
201 
202     /**
203     * @dev Adds two numbers, throws on overflow.
204     */
205     function add(uint256 a, uint256 b) internal pure returns (uint256) {
206         uint256 c = a + b;
207         assert(c >= a);
208         return c;
209     }
210 }