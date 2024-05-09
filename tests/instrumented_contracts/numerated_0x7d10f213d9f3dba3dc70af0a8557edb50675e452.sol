1 pragma solidity ^0.4.21;
2 
3 contract Timebomb {
4     using SafeMath for uint256;
5 
6     event Deposit(address user, uint amount);
7     event Withdraw(address user, uint amount);
8     event Claim(address user, uint dividends);
9     event Reinvest(address user, uint dividends);
10     event Leader(address user, uint amount);
11     event Win(address user, uint amount);
12 
13     uint constant depositTaxDivisor = 3;
14     uint constant withdrawalTaxDivisor = 3;
15     uint constant duration = 1 hours;
16     uint constant intervals = 12;
17     uint constant minimumPerInterval = 100 finney;
18 
19     address owner;
20     mapping(address => bool) preauthorized;
21     bool gameStarted;
22 
23     address public leader;
24     uint public deadline;
25     bool public prizeClaimed;
26 
27     mapping(address => uint) public investment;
28     uint public totalInvestment;
29 
30     mapping(address => uint) public stake;
31     uint public totalStake;
32     uint stakeValue;
33 
34     mapping(address => uint) dividendCredit;
35     mapping(address => uint) dividendDebit;
36 
37     function Timebomb() public {
38         owner = msg.sender;
39         preauthorized[owner] = true;
40         leader = msg.sender;
41         deadline = now + duration;
42     }
43 
44     function preauthorize(address _user) public {
45         require(msg.sender == owner);
46         preauthorized[_user] = true;
47     }
48 
49     function startGame() public {
50         require(msg.sender == owner);
51         gameStarted = true;
52     }
53 
54     function threshold() public view returns (uint) {
55         if (now < deadline) {
56             uint _lastTimestamp = deadline.sub(duration);
57             uint _elapsed = now.sub(_lastTimestamp);
58             uint _interval = intervals.mul(_elapsed).div(duration).add(1);
59             return _interval.mul(minimumPerInterval);
60         } else {
61             return intervals.mul(minimumPerInterval);
62         }
63     }
64 
65     function checkForNewLeader(uint _amount) private {
66         if (_amount >= threshold()) {
67             leader = msg.sender;
68             deadline = now + duration;
69             emit Leader(msg.sender, _amount);
70         }
71     }
72 
73     function depositHelper(uint _amount) private {
74         checkForNewLeader(_amount);
75         uint _tax = _amount.div(depositTaxDivisor);
76         uint _amountAfterTax = _amount.sub(_tax);
77         if (totalStake > 0)
78             stakeValue = stakeValue.add(_tax.div(totalStake));
79         uint _stakeIncrement = sqrt(totalStake.mul(totalStake).add(_amountAfterTax)).sub(totalStake);
80         investment[msg.sender] = investment[msg.sender].add(_amountAfterTax);
81         totalInvestment = totalInvestment.add(_amountAfterTax);
82         stake[msg.sender] = stake[msg.sender].add(_stakeIncrement);
83         totalStake = totalStake.add(_stakeIncrement);
84         dividendDebit[msg.sender] = dividendDebit[msg.sender].add(_stakeIncrement.mul(stakeValue));
85     }
86 
87     function deposit() public payable {
88         require(preauthorized[msg.sender] || gameStarted);
89         require(now < deadline);
90         depositHelper(msg.value);
91         emit Deposit(msg.sender, msg.value);
92     }
93 
94     function withdraw(uint _amount) public {
95         require(now < deadline);
96         require(_amount > 0);
97         require(_amount <= investment[msg.sender]);
98         checkForNewLeader(_amount);
99         uint _tax = _amount.div(withdrawalTaxDivisor);
100         uint _amountAfterTax = _amount.sub(_tax);
101         uint _stakeDecrement = stake[msg.sender].mul(_amount).div(investment[msg.sender]);
102         uint _dividendCredit = _stakeDecrement.mul(stakeValue);
103         investment[msg.sender] = investment[msg.sender].sub(_amount);
104         totalInvestment = totalInvestment.sub(_amount);
105         stake[msg.sender] = stake[msg.sender].sub(_stakeDecrement);
106         totalStake = totalStake.sub(_stakeDecrement);
107         if (totalStake > 0)
108             stakeValue = stakeValue.add(_tax.div(totalStake));
109         dividendCredit[msg.sender] = dividendCredit[msg.sender].add(_dividendCredit);
110         uint _creditDebitCancellation = min(dividendCredit[msg.sender], dividendDebit[msg.sender]);
111         dividendCredit[msg.sender] = dividendCredit[msg.sender].sub(_creditDebitCancellation);
112         dividendDebit[msg.sender] = dividendDebit[msg.sender].sub(_creditDebitCancellation);
113         msg.sender.transfer(_amountAfterTax);
114         emit Withdraw(msg.sender, _amount);
115     }
116 
117     function claimHelper() private returns(uint) {
118         uint _dividendsForStake = stake[msg.sender].mul(stakeValue);
119         uint _dividends = _dividendsForStake.add(dividendCredit[msg.sender]).sub(dividendDebit[msg.sender]);
120         dividendCredit[msg.sender] = 0;
121         dividendDebit[msg.sender] = _dividendsForStake;
122         return _dividends;
123     }
124 
125     function claim() public {
126         uint _dividends = claimHelper();
127         msg.sender.transfer(_dividends);
128         emit Claim(msg.sender, _dividends);
129     }
130 
131     function reinvest() public {
132         require(now < deadline);
133         uint _dividends = claimHelper();
134         depositHelper(_dividends);
135         emit Reinvest(msg.sender, _dividends);
136     }
137 
138     function win() public {
139         require(now >= deadline);
140         require(msg.sender == leader);
141         require(!prizeClaimed);
142         uint _amount = totalInvestment;
143         uint _tax = _amount.div(withdrawalTaxDivisor);
144         uint _amountAfterTax = _amount.sub(_tax);
145         if (totalStake > 0)
146             stakeValue = stakeValue.add(_tax.div(totalStake));
147         prizeClaimed = true;
148         msg.sender.transfer(_amountAfterTax);
149         emit Win(msg.sender, _amount);
150     }
151 
152     function dividendsForUser(address _user) public view returns (uint) {
153         return stake[_user].mul(stakeValue).add(dividendCredit[_user]).sub(dividendDebit[_user]);
154     }
155 
156     function min(uint x, uint y) private pure returns (uint) {
157         return x <= y ? x : y;
158     }
159 
160     function sqrt(uint x) private pure returns (uint y) {
161         uint z = (x + 1) / 2;
162         y = x;
163         while (z < y) {
164             y = z;
165             z = (x / z + z) / 2;
166         }
167     }
168 }
169 
170 /**
171  * @title SafeMath
172  * @dev Math operations with safety checks that throw on error
173  */
174 library SafeMath {
175 
176     /**
177     * @dev Multiplies two numbers, throws on overflow.
178     */
179     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
180         if (a == 0) {
181             return 0;
182         }
183         uint256 c = a * b;
184         assert(c / a == b);
185         return c;
186     }
187 
188     /**
189     * @dev Integer division of two numbers, truncating the quotient.
190     */
191     function div(uint256 a, uint256 b) internal pure returns (uint256) {
192         // assert(b > 0); // Solidity automatically throws when dividing by 0
193         // uint256 c = a / b;
194         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
195         return a / b;
196     }
197 
198     /**
199     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
200     */
201     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
202         assert(b <= a);
203         return a - b;
204     }
205 
206     /**
207     * @dev Adds two numbers, throws on overflow.
208     */
209     function add(uint256 a, uint256 b) internal pure returns (uint256) {
210         uint256 c = a + b;
211         assert(c >= a);
212         return c;
213     }
214 }