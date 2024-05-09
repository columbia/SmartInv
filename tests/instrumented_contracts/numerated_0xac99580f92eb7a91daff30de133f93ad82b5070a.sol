1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, reverts on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         uint256 c = a * b;
21         require(c / a == b);
22 
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28     */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         require(b > 0); // Solidity only automatically asserts when dividing by 0
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two numbers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 }
57 
58 contract SmartHash {
59     using SafeMath for uint256;
60 
61     uint256 constant public DEPOSIT_MINIMUM_AMOUNT = 10 finney;
62     uint256 constant public MAXIMUM_DEPOSITS_PER_USER = 50;
63 
64     uint256 constant public MINIMUM_DAILY_PERCENT = 20;
65     uint256 constant public REFERRAL_PERCENT = 50;
66     uint256 constant public MARKETING_PERCENT = 50;
67     uint256 constant public MAXIMUM_RETURN_PERCENT = 1500;
68     uint256 constant public PERCENTS_DIVIDER = 1000;
69 
70     uint256 constant public BALANCE_STEP = 100 ether;
71     uint256 constant public TIME_STEP = 1 days;
72     uint256 constant public STEP_MULTIPLIER = 2;
73 
74     address constant public MARKETING_ADDRESS = 0xd0396aAEcb5547776852aB8682Ba72E1209b536d;
75 
76     uint256 public usersCount = 0;
77     uint256 public depositsCount = 0;
78     uint256 public totalDeposited = 0;
79     uint256 public totalWithdrawn = 0;
80 
81     struct User {
82         uint256 deposited;
83         uint256 withdrawn;
84         uint256 timestamp;
85         uint256 depositsCount;
86         uint256[] deposits;
87     }
88 
89     struct Deposit {
90         uint256 amount;
91         uint256 payed;
92         uint256 timestamp;
93     }
94 
95     mapping (address => User) public users;
96     mapping (uint256 => Deposit) public deposits;
97 
98     function() public payable {
99         if (msg.value >= DEPOSIT_MINIMUM_AMOUNT) {
100             makeDeposit();
101         } else {
102             payDividends();
103         }
104     }
105 
106     function createUser() private {
107         users[msg.sender] = User({
108             deposited : 0,
109             withdrawn : 0,
110             timestamp : now,
111             depositsCount : 0,
112             deposits : new uint256[](0)
113         });
114 
115         usersCount++;
116     }
117 
118     function makeDeposit() private {
119         if (users[msg.sender].deposited == 0) {
120             createUser();
121         }
122 
123         User storage user = users[msg.sender];
124 
125         require(user.depositsCount < MAXIMUM_DEPOSITS_PER_USER);
126 
127         Deposit memory deposit = Deposit({
128             amount : msg.value,
129             payed : 0,
130             timestamp : now
131         });
132 
133         deposits[depositsCount] = deposit;
134         user.deposits.push(depositsCount);
135 
136         user.deposited = user.deposited.add(msg.value);
137         totalDeposited = totalDeposited.add(msg.value);
138 
139         user.depositsCount++;
140         depositsCount++;
141 
142         uint256 marketingAmount = msg.value.mul(MARKETING_PERCENT).div(PERCENTS_DIVIDER);
143         MARKETING_ADDRESS.send(marketingAmount);
144 
145         address refAddress = bytesToAddress(msg.data);
146         if (refAddress != address(0) && refAddress != msg.sender) {
147             uint256 refAmount = msg.value.mul(REFERRAL_PERCENT).div(PERCENTS_DIVIDER);
148             refAddress.send(refAmount);
149         }
150     }
151 
152     function payDividends() private {
153         User storage user = users[msg.sender];
154 
155         uint256 userMaximumReturn = user.deposited.mul(MAXIMUM_RETURN_PERCENT).div(PERCENTS_DIVIDER);
156 
157         require(user.deposited > 0 && user.withdrawn < userMaximumReturn);
158 
159         uint256 userDividends = 0;
160 
161         for (uint256 i = 0; i < user.depositsCount; i++) {
162             if (deposits[user.deposits[i]].payed < deposits[user.deposits[i]].amount.mul(MAXIMUM_RETURN_PERCENT).div(PERCENTS_DIVIDER)) {
163                 uint256 depositId = user.deposits[i];
164 
165                 Deposit storage deposit = deposits[depositId];
166 
167                 uint256 depositDividends = getDepositDividends(depositId, msg.sender);
168                 userDividends = userDividends.add(depositDividends);
169 
170                 deposits[depositId].payed = deposit.payed.add(depositDividends);
171                 deposits[depositId].timestamp = now;
172             }
173         }
174 
175         msg.sender.transfer(userDividends.add(msg.value));
176 
177         users[msg.sender].timestamp = now;
178 
179         users[msg.sender].withdrawn = user.withdrawn.add(userDividends);
180         totalWithdrawn = totalWithdrawn.add(userDividends);
181     }
182 
183     function getDepositDividends(uint256 depositId, address userAddress) private view returns (uint256) {
184         uint256 userActualPercent = getUserActualPercent(userAddress);
185 
186         Deposit storage deposit = deposits[depositId];
187 
188         uint256 timeDiff = now.sub(deposit.timestamp);
189         uint256 depositDividends = deposit.amount.mul(userActualPercent).div(PERCENTS_DIVIDER).mul(timeDiff).div(TIME_STEP);
190 
191         uint256 depositMaximumReturn = deposit.amount.mul(MAXIMUM_RETURN_PERCENT).div(PERCENTS_DIVIDER);
192 
193         if (depositDividends.add(deposit.payed) > depositMaximumReturn) {
194             depositDividends = depositMaximumReturn.sub(deposit.payed);
195         }
196 
197         return depositDividends;
198     }
199 
200     function getContractActualPercent() public view returns (uint256) {
201         uint256 contractBalance = address(this).balance;
202         uint256 balanceAddPercent = contractBalance.div(BALANCE_STEP).mul(STEP_MULTIPLIER);
203 
204         return MINIMUM_DAILY_PERCENT.add(balanceAddPercent);
205     }
206 
207     function getUserActualPercent(address userAddress) public view returns (uint256) {
208         uint256 contractActualPercent = getContractActualPercent();
209 
210         User storage user = users[userAddress];
211 
212         uint256 userMaximumReturn = user.deposited.mul(MAXIMUM_RETURN_PERCENT).div(PERCENTS_DIVIDER);
213 
214         if (user.deposited > 0 && user.withdrawn < userMaximumReturn) {
215             uint256 timeDiff = now.sub(user.timestamp);
216             uint256 userAddPercent = timeDiff.div(TIME_STEP).mul(STEP_MULTIPLIER);
217         }
218 
219         return contractActualPercent.add(userAddPercent);
220     }
221 
222     function getUserDividends(address userAddress) public view returns (uint256) {
223         User storage user = users[userAddress];
224 
225         uint256 userDividends = 0;
226 
227         for (uint256 i = 0; i < user.depositsCount; i++) {
228             if (deposits[user.deposits[i]].payed < deposits[user.deposits[i]].amount.mul(MAXIMUM_RETURN_PERCENT).div(PERCENTS_DIVIDER)) {
229                 userDividends = userDividends.add(getDepositDividends(user.deposits[i], userAddress));
230             }
231         }
232 
233         return userDividends;
234     }
235 
236     function getUserDeposits(address userAddress) public view returns (uint256[]){
237         return users[userAddress].deposits;
238     }
239 
240     function bytesToAddress(bytes data) private pure returns (address addr) {
241         assembly {
242             addr := mload(add(data, 20))
243         }
244     }
245 }