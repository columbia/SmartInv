1 pragma solidity ^0.4.25;
2 
3 /*
4  * ETHCutter v2.0
5  * 
6  * - 6% per day for 20 days (120% total)
7  * - 6% referral program (1 level)
8  * - 0.1-100 ETH per deposit (unlimited deposits count)
9  * - Each deposit live for 20 days. Unlimited deposits for 1 adress.
10  * 
11  *  1. Send 0.1-100 ETH to contract address. Gas limit: 300000.
12  *  2. Send from 0 to 0.1 ETH and get your profit. You can get profit at any time (every minute, every hour, every day).
13  *
14  * 
15  */
16 
17 library SafeMath {
18     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
19         if (_a == 0) {
20             return 0;
21         }
22         c = _a * _b;
23         require(c / _a == _b);
24         return c;
25     }
26 
27     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
28         return _a / _b;
29     }
30 
31     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
32         require(_b <= _a);
33         return _a - _b;
34     }
35 
36     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
37         c = _a + _b;
38         require(c >= _a);
39         return c;
40     }
41 }
42 
43 library AddressUtils {
44     function isContract(address _addr) internal view returns (bool) {
45         uint256 size;
46         assembly {size := extcodesize(_addr)}
47         return size > 0;
48     }
49 }
50 
51 library Helpers {
52     function walletFromData(bytes data) internal pure returns (address wallet) {
53         assembly {
54             wallet := mload(add(data, 20))
55         }
56     }
57 }
58 
59 contract ETHCutter20 {
60     using SafeMath for uint256;
61     using AddressUtils for address;
62 
63     address internal adminWallet;
64 
65     uint256 constant internal DEPOSIT_MIN = 10 finney;
66     uint256 constant internal DEPOSIT_MAX = 10 ether;
67     uint256 constant internal DEPOSIT_PERIOD = 20 days;
68     uint256 constant internal TOTAL_PERCENT = 120;
69     uint256 constant internal UPLINE_PERCENT = 6;
70     uint256 constant internal EXPENSES_PERCENT = 15;
71 
72     uint256 public totalDeposited = 0;
73     uint256 public totalWithdrawn = 0;
74     uint256 public usersCount = 0;
75     uint256 public depositsCount = 0;
76     uint256 internal expenses = 0;
77 
78     mapping(address => User) public users;
79     mapping(uint256 => Deposit) public deposits;
80 
81     struct Deposit {
82         uint256 createdAt;
83         uint256 endAt;
84         uint256 amount;
85         uint256 accrued;
86         uint256 totalForAccrual;
87         bool active;
88     }
89 
90     struct User {
91         uint256 createdAt;
92         address upline;
93         uint256 totalDeposited;
94         uint256 totalWithdrawn;
95         uint256 depositsCount;
96         uint256[] deposits;
97     }
98 
99     modifier onlyAdmin() {
100         require(msg.sender == adminWallet);
101         _;
102     }
103 
104     constructor() public {
105         adminWallet = msg.sender;
106         createUser(msg.sender, address(0));
107     }
108 
109     function createUser(address wallet, address upline) internal {
110         users[wallet] = User({
111             createdAt : now,
112             upline : upline,
113             totalDeposited : 0,
114             totalWithdrawn : 0,
115             depositsCount : 0,
116             deposits : new uint256[](0)
117             });
118         usersCount++;
119     }
120 
121     function createDeposit(address wallet, uint256 amount) internal {
122         User storage user = users[wallet];
123 
124         Deposit memory deposit = Deposit({
125             createdAt : now,
126             endAt : now.add(DEPOSIT_PERIOD),
127             amount : amount,
128             accrued : 0,
129             totalForAccrual : amount.div(100).mul(TOTAL_PERCENT),
130             active : true
131         });
132 
133         deposits[depositsCount] = deposit;
134         user.deposits.push(depositsCount);
135 
136         user.totalDeposited = user.totalDeposited.add(amount);
137         totalDeposited = amount.add(totalDeposited);
138 
139         user.depositsCount++;
140         depositsCount++;
141         expenses = expenses.add(amount.div(100).mul(EXPENSES_PERCENT));
142 
143         uint256 referralFee = amount.div(100).mul(UPLINE_PERCENT);
144         transferReferralFee(user.upline, referralFee);
145     }
146 
147     function transferReferralFee(address to, uint256 amount) internal {
148         if (to != address(0)) {
149             to.transfer(amount);
150         }
151     }
152 
153     function getUpline() internal view returns (address){
154         address uplineWallet = Helpers.walletFromData(msg.data);
155         return users[uplineWallet].createdAt > 0 && msg.sender != uplineWallet
156         ? uplineWallet
157         : adminWallet;
158     }
159 
160     function() payable public {
161         address wallet = msg.sender;
162         uint256 amount = msg.value;
163 
164         require(wallet != address(0), 'Address incorrect');
165         require(!wallet.isContract(), 'Address is contract');
166         require(amount <= DEPOSIT_MAX, 'Amount too big');
167 
168         if (users[wallet].createdAt == 0) {
169             createUser(wallet, getUpline());
170         }
171 
172         if (amount >= DEPOSIT_MIN) {
173             createDeposit(wallet, amount);
174         } else {
175             accrualDeposits();
176         }
177     }
178 
179     function accrualDeposits() internal {
180         address wallet = msg.sender;
181         User storage user = users[wallet];
182 
183         for (uint i = 0; i < user.depositsCount; i++) {
184             if (deposits[user.deposits[i]].active) {
185                 accrual(user.deposits[i], wallet);
186             }
187         }
188     }
189 
190     function getAccrualAmount(Deposit deposit) internal view returns (uint256){
191         uint256 amount = deposit.totalForAccrual
192         .div(DEPOSIT_PERIOD)
193         .mul(
194             now.sub(deposit.createdAt)
195         )
196         .sub(deposit.accrued);
197 
198         if (amount.add(deposit.accrued) > deposit.totalForAccrual) {
199             amount = deposit.totalForAccrual.sub(deposit.accrued);
200         }
201 
202         return amount;
203     }
204 
205     function accrual(uint256 depositId, address wallet) internal {
206         uint256 amount = getAccrualAmount(deposits[depositId]);
207         Deposit storage deposit = deposits[depositId];
208 
209         withdraw(wallet, amount);
210 
211         deposits[depositId].accrued = deposit.accrued.add(amount);
212 
213         if (deposits[depositId].accrued >= deposit.totalForAccrual) {
214             deposits[depositId].active = false;
215         }
216     }
217 
218     function withdraw(address wallet, uint256 amount) internal {
219         wallet.transfer(amount);
220         totalWithdrawn = totalWithdrawn.add(amount);
221         users[wallet].totalWithdrawn = users[wallet].totalWithdrawn.add(amount);
222     }
223 
224     function withdrawExpenses() public onlyAdmin {
225         adminWallet.transfer(expenses);
226         expenses = 0;
227     }
228 
229     function getUserDeposits(address _address) public view returns (uint256[]){
230         return users[_address].deposits;
231     }
232 
233 }