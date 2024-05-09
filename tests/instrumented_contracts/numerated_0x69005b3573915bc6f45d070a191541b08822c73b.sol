1 pragma solidity ^0.4.25;
2 // Https://smarthashfast.online  site progect
3 contract SmartHashFast {
4     using SafeMath for uint256;
5 
6     uint256 constant public DEPOSIT_MINIMUM_AMOUNT = 100 finney;
7     uint256 constant public MAXIMUM_DEPOSITS_PER_USER = 50;
8 
9     uint256 constant public MINIMUM_DAILY_PERCENT = 50;
10     uint256 constant public REFERRAL_PERCENT = 50;
11     uint256 constant public MARKETING_PERCENT = 100;
12     uint256 constant public BonusContract_PERCENT = 50;
13     uint256 constant public MAXIMUM_RETURN_PERCENT = 2000;
14     uint256 constant public PERCENTS_DIVIDER = 1000;
15 
16     uint256 constant public BALANCE_STEP = 300 ether;
17     uint256 constant public TIME_STEP = 1 days;
18     uint256 constant public STEP_MULTIPLIER = 10;
19 
20     address constant public MARKETING_ADDRESS = 0xa5a3A84Cf9FD3f9dE1A6160C7242bA97b4b64065;
21     address constant public bonus_ADDRESS = 0xe4661f1D737993824Ef3da64166525ffc3702487;
22    
23     uint256 public usersCount = 0;
24     uint256 public depositsCount = 0;
25     uint256 public totalDeposited = 0;
26     uint256 public totalWithdrawn = 0;
27     event Invest( address indexed investor, uint256 amount);
28     
29    
30     struct User {
31         uint256 deposited;
32         uint256 withdrawn;
33         uint256 timestamp;
34         uint256 depositsCount;
35         uint256[] deposits;
36     }
37 
38     struct Deposit {
39         uint256 amount;
40         uint256 payed;
41         uint256 timestamp;
42     }
43 
44     mapping (address => User) public users;
45     mapping (uint256 => Deposit) public deposits;
46 
47     function() public payable {
48         if (msg.value >= DEPOSIT_MINIMUM_AMOUNT) {
49             makeDeposit();
50         } else {
51             payDividends();
52         }
53     }
54 
55     function createUser() private {
56         users[msg.sender] = User({
57             deposited : 0,
58             withdrawn : 0,
59             timestamp : now,
60             depositsCount : 0,
61             deposits : new uint256[](0)
62         });
63 
64         usersCount++;
65     }
66 
67     function makeDeposit() private {
68         if (users[msg.sender].deposited == 0) {
69             createUser();
70         }
71 
72         User storage user = users[msg.sender];
73 
74         require(user.depositsCount < MAXIMUM_DEPOSITS_PER_USER);
75 
76         Deposit memory deposit = Deposit({
77             amount : msg.value,
78             payed : 0,
79             timestamp : now
80         });
81 
82         deposits[depositsCount] = deposit;
83         user.deposits.push(depositsCount);
84 
85         user.deposited = user.deposited.add(msg.value);
86         totalDeposited = totalDeposited.add(msg.value);
87         emit Invest(msg.sender, msg.value);
88         user.depositsCount++;
89         depositsCount++;
90 
91         uint256 marketingAmount = msg.value.mul(MARKETING_PERCENT).div(PERCENTS_DIVIDER);
92         MARKETING_ADDRESS.send(marketingAmount);
93         uint256 bonusAmount = msg.value.mul(BonusContract_PERCENT).div(PERCENTS_DIVIDER);
94         bonus_ADDRESS.send(bonusAmount);
95         
96         address refAddress = bytesToAddress(msg.data);
97         if (refAddress != address(0) && refAddress != msg.sender) {
98             uint256 refAmount = msg.value.mul(REFERRAL_PERCENT).div(PERCENTS_DIVIDER);
99             refAddress.send(refAmount);
100         }
101     }
102 
103     function payDividends() private {
104         User storage user = users[msg.sender];
105 
106         uint256 userMaximumReturn = user.deposited.mul(MAXIMUM_RETURN_PERCENT).div(PERCENTS_DIVIDER);
107 
108         require(user.deposited > 0 && user.withdrawn < userMaximumReturn);
109 
110         uint256 userDividends = 0;
111 
112         for (uint256 i = 0; i < user.depositsCount; i++) {
113             if (deposits[user.deposits[i]].payed < deposits[user.deposits[i]].amount.mul(MAXIMUM_RETURN_PERCENT).div(PERCENTS_DIVIDER)) {
114                 uint256 depositId = user.deposits[i];
115 
116                 Deposit storage deposit = deposits[depositId];
117 
118                 uint256 depositDividends = getDepositDividends(depositId, msg.sender);
119                 userDividends = userDividends.add(depositDividends);
120 
121                 deposits[depositId].payed = deposit.payed.add(depositDividends);
122                 deposits[depositId].timestamp = now;
123             }
124         }
125 
126         msg.sender.transfer(userDividends.add(msg.value));
127 
128         users[msg.sender].timestamp = now;
129 
130         users[msg.sender].withdrawn = user.withdrawn.add(userDividends);
131         totalWithdrawn = totalWithdrawn.add(userDividends);
132     }
133 
134     function getDepositDividends(uint256 depositId, address userAddress) private view returns (uint256) {
135         uint256 userActualPercent = getUserActualPercent(userAddress);
136 
137         Deposit storage deposit = deposits[depositId];
138 
139         uint256 timeDiff = now.sub(deposit.timestamp);
140         uint256 depositDividends = deposit.amount.mul(userActualPercent).div(PERCENTS_DIVIDER).mul(timeDiff).div(TIME_STEP);
141 
142         uint256 depositMaximumReturn = deposit.amount.mul(MAXIMUM_RETURN_PERCENT).div(PERCENTS_DIVIDER);
143 
144         if (depositDividends.add(deposit.payed) > depositMaximumReturn) {
145             depositDividends = depositMaximumReturn.sub(deposit.payed);
146         }
147 
148         return depositDividends;
149     }
150 
151     function getContractActualPercent() public view returns (uint256) {
152         uint256 contractBalance = address(this).balance;
153         uint256 balanceAddPercent = contractBalance.div(BALANCE_STEP).mul(STEP_MULTIPLIER);
154 
155         return MINIMUM_DAILY_PERCENT.add(balanceAddPercent);
156     }
157 
158     function getUserActualPercent(address userAddress) public view returns (uint256) {
159         uint256 contractActualPercent = getContractActualPercent();
160 
161         User storage user = users[userAddress];
162 
163         uint256 userMaximumReturn = user.deposited.mul(MAXIMUM_RETURN_PERCENT).div(PERCENTS_DIVIDER);
164 
165         if (user.deposited > 0 && user.withdrawn < userMaximumReturn) {
166             uint256 timeDiff = now.sub(user.timestamp);
167             uint256 userAddPercent = timeDiff.div(TIME_STEP).mul(STEP_MULTIPLIER);
168         }
169 
170         return contractActualPercent.add(userAddPercent);
171     }
172 
173     function getUserDividends(address userAddress) public view returns (uint256) {
174         User storage user = users[userAddress];
175 
176         uint256 userDividends = 0;
177 
178         for (uint256 i = 0; i < user.depositsCount; i++) {
179             if (deposits[user.deposits[i]].payed < deposits[user.deposits[i]].amount.mul(MAXIMUM_RETURN_PERCENT).div(PERCENTS_DIVIDER)) {
180                 userDividends = userDividends.add(getDepositDividends(user.deposits[i], userAddress));
181             }
182         }
183 
184         return userDividends;
185     }
186 
187     function getUserDeposits(address userAddress) public view returns (uint256[]){
188         return users[userAddress].deposits;
189     }
190 
191     function bytesToAddress(bytes data) private pure returns (address addr) {
192         assembly {
193             addr := mload(add(data, 20))
194         }
195     }
196 }
197 /**
198  * @title SafeMath
199  * @dev Math operations with safety checks that revert on error
200  */
201  library SafeMath {
202 
203     /**
204     * @dev Multiplies two numbers, reverts on overflow.
205     */
206     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
207         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
208         // benefit is lost if 'b' is also tested.
209         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
210         if (a == 0) {
211             return 0;
212         }
213 
214         uint256 c = a * b;
215         require(c / a == b);
216 
217         return c;
218     }
219 
220     /**
221     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
222     */
223     function div(uint256 a, uint256 b) internal pure returns (uint256) {
224         require(b > 0); // Solidity only automatically asserts when dividing by 0
225         uint256 c = a / b;
226         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
227 
228         return c;
229     }
230 
231     /**
232     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
233     */
234     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
235         require(b <= a);
236         uint256 c = a - b;
237 
238         return c;
239     }
240 
241     /**
242     * @dev Adds two numbers, reverts on overflow.
243     */
244     function add(uint256 a, uint256 b) internal pure returns (uint256) {
245         uint256 c = a + b;
246         require(c >= a);
247 
248         return c;
249     }
250 }