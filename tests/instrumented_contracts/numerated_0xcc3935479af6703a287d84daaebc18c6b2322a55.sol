1 pragma solidity ^0.4.20;
2 
3 contract EtherHellHydrant {
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
49     // Minimum bid as a fraction of the pot
50     uint public constant MIN_BID_FRAC_TOP = 1;
51     uint public constant MIN_BID_FRAC_BOT = 1000;
52 
53     // Maximum bid as a fraction of the pot
54     uint public constant MAX_BID_FRAC_TOP = 1;
55     uint public constant MAX_BID_FRAC_BOT = 100;
56 
57     // Fraction of each bid put into the dividend fund
58     uint public constant DIVIDEND_FUND_FRAC_TOP = 1;
59     uint public constant DIVIDEND_FUND_FRAC_BOT = 2;
60 
61     // Owner of the contract
62     address owner;
63 
64     // Mapping from addresses to amounts earned
65     mapping(address => uint) public earnings;
66 
67     // Mapping from addresses to dividend shares
68     mapping(address => uint) public dividendShares;
69 
70     // Total number of dividend shares
71     uint public totalDividendShares;
72 
73     // Value of the dividend fund
74     uint public dividendFund;
75 
76     // Current round number
77     uint public round;
78 
79     // Value of the pot
80     uint public pot;
81 
82     // Address of the current leader
83     address public leader;
84 
85     // Time at which the most recent bid was placed
86     uint public leaderTimestamp;
87 
88     // Amount of the most recent bid, capped at the maximum bid
89     uint public leaderBid;
90 
91     function EtherHellHydrant() public payable {
92         require(msg.value > 0);
93         owner = msg.sender;
94         totalDividendShares = 0;
95         dividendFund = 0;
96         round = 0;
97         pot = msg.value;
98         leader = owner;
99         leaderTimestamp = now;
100         leaderBid = 0;
101         Bid(now, msg.sender, 0, 0, round, pot);
102     }
103 
104     function bid() public payable {
105         uint _maxPayout = pot.mul(MAX_PAYOUT_FRAC_TOP).div(MAX_PAYOUT_FRAC_BOT);
106         uint _numPayoutIntervals = now.sub(leaderTimestamp).div(PAYOUT_TIME);
107         uint _totalPayout = _numPayoutIntervals.mul(leaderBid).mul(PAYOUT_FRAC_TOP).div(PAYOUT_FRAC_BOT);
108         if (_totalPayout > _maxPayout) {
109             _totalPayout = _maxPayout;
110         }
111 
112         uint _bidAmountToDividendFund = msg.value.mul(DIVIDEND_FUND_FRAC_TOP).div(DIVIDEND_FUND_FRAC_BOT);
113         uint _bidAmountToPot = msg.value.sub(_bidAmountToDividendFund);
114 
115         uint _minBidForNewPot = pot.sub(_totalPayout).mul(MIN_BID_FRAC_TOP).div(MIN_BID_FRAC_BOT);
116 
117         if (msg.value < _minBidForNewPot) {
118             dividendFund = dividendFund.add(_bidAmountToDividendFund);
119             pot = pot.add(_bidAmountToPot);
120         } else {
121             earnings[leader] = earnings[leader].add(_totalPayout);
122             pot = pot.sub(_totalPayout);
123 
124             Winner(now, leader, _totalPayout, round, leaderTimestamp);
125 
126             uint _maxBid = pot.mul(MAX_BID_FRAC_TOP).div(MAX_BID_FRAC_BOT);
127 
128             uint _dividendSharePrice;
129             if (totalDividendShares == 0) {
130                 _dividendSharePrice = _maxBid.mul(DIVIDEND_FUND_FRAC_TOP).div(DIVIDEND_FUND_FRAC_BOT);
131             } else {
132                 _dividendSharePrice = dividendFund.div(totalDividendShares);
133             }
134 
135             dividendFund = dividendFund.add(_bidAmountToDividendFund);
136             pot = pot.add(_bidAmountToPot);
137 
138             if (msg.value > _maxBid) {
139                 uint _investment = msg.value.sub(_maxBid).mul(DIVIDEND_FUND_FRAC_TOP).div(DIVIDEND_FUND_FRAC_BOT);
140                 uint _dividendShares = _investment.div(_dividendSharePrice);
141                 dividendShares[msg.sender] = dividendShares[msg.sender].add(_dividendShares);
142                 totalDividendShares = totalDividendShares.add(_dividendShares);
143             }
144 
145             round++;
146             leader = msg.sender;
147             leaderTimestamp = now;
148             leaderBid = msg.value;
149             if (leaderBid > _maxBid) {
150                 leaderBid = _maxBid;
151             }
152 
153             Bid(now, msg.sender, msg.value, leaderBid, round, pot);
154         }
155     }
156 
157     function withdrawEarnings() public {
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