1 pragma solidity ^0.4.25;
2 contract o2 {
3     using SafeMath for uint256;
4 
5     uint256 constant public DEPOSIT_MINIMUM_AMOUNT = 100 wei;
6     uint256 constant public MAXIMUM_DEPOSITS_PER_USER = 50;
7 
8     uint256 constant public MINIMUM_DAILY_PERCENT = 40;
9     uint256 constant public REFERRAL_PERCENT = 50;
10     uint256 constant public MARKETING_PERCENT = 100;
11     uint256 constant public BonusContract_PERCENT = 50;
12     uint256 constant public MAXIMUM_RETURN_PERCENT = 1500;
13     uint256 constant public PERCENTS_DIVIDER = 1000;
14 
15     uint256 constant public BALANCE_STEP = 300 ether;
16     uint256 constant public TIME_STEP = 1 days;
17     uint256 constant public STEP_MULTIPLIER = 10;
18 
19     address constant public MARKETING_ADDRESS = 0xc9f78aa0A1BD3EAB43F30F0D960e423DE7784C48;
20     address constant public BonusContract_ADDRESS = 0xfE6ea4625b57B6503677a1083ad9920BC9021B18;
21    
22     uint256 public usersCount = 0;
23     uint256 public depositsCount = 0;
24     uint256 public totalDeposited = 0;
25     uint256 public totalWithdrawn = 0;
26     event Invest( address indexed investor, uint256 amount);
27     event Withdraw( address indexed investor, uint256 amount);
28    
29     struct User {
30         uint256 deposited;
31         uint256 withdrawn;
32         uint256 timestamp;
33         uint256 depositsCount;
34         uint256[] deposits;
35     }
36 
37     struct Deposit {
38         uint256 amount;
39         uint256 payed;
40         uint256 timestamp;
41     }
42 
43     mapping (address => User) public users;
44     mapping (uint256 => Deposit) public deposits;
45 
46     function() public payable {
47         if (msg.value >= DEPOSIT_MINIMUM_AMOUNT) {
48             makeDeposit();
49         } else {
50             payDividends();
51         }
52     }
53 
54     function createUser() private {
55         users[msg.sender] = User({
56             deposited : 0,
57             withdrawn : 0,
58             timestamp : now,
59             depositsCount : 0,
60             deposits : new uint256[](0)
61         });
62 
63         usersCount++;
64     }
65 
66     function makeDeposit() private {
67         if (users[msg.sender].deposited == 0) {
68             createUser();
69         }
70 
71         User storage user = users[msg.sender];
72 
73         require(user.depositsCount < MAXIMUM_DEPOSITS_PER_USER);
74 
75         Deposit memory deposit = Deposit({
76             amount : msg.value,
77             payed : 0,
78             timestamp : now
79         });
80 
81         deposits[depositsCount] = deposit;
82         user.deposits.push(depositsCount);
83 
84         user.deposited = user.deposited.add(msg.value);
85         totalDeposited = totalDeposited.add(msg.value);
86 
87         user.depositsCount++;
88         depositsCount++;
89 
90         uint256 marketingAmount = msg.value.mul(MARKETING_PERCENT).div(PERCENTS_DIVIDER);
91         MARKETING_ADDRESS.transfer(marketingAmount);
92        
93         uint256 BonusAmount = msg.value.mul(BonusContract_PERCENT).div(PERCENTS_DIVIDER);
94         BonusContract_ADDRESS.transfer(BonusAmount);
95 
96         address refAddress = bytesToAddress(msg.data);
97         if (refAddress != address(0) && refAddress != msg.sender) {
98             uint256 refAmount = msg.value.mul(REFERRAL_PERCENT).div(PERCENTS_DIVIDER);
99             refAddress.transfer(refAmount);
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