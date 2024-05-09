1 pragma solidity ^0.4.24;
2 
3 /*
4  * ETHCutter Contract
5  * 
6  * - 1% per hour for 5 days (120% total)
7  * - 6% referral program (1 level)
8  * - 0.1-100 ETH per deposit (unlimited deposits count)
9  * 
10  *  1. Set an address of you upline in DATA field (if exists), and send 0.1-100 ETH to contract address. Gas limit: 300000.
11  *  2. Send 0 or not more than 0.1 ETH and get your profit. You can get profit at any time (every minute, every hour, every day).
12  *
13  * EMAIL: ethcutter@gmail.com
14  * TELEGRAM SUPPORT 24/7: https://t.me/ethcutter_support or tg://resolve?domain=ethcutter_support
15  * TELEGRAM CHAT (RU): https://t.me/ethcutter_ru or tg://resolve?domain=ethcutter_ru
16  * TELEGRAM CHAT (EN): https://t.me/ethcutter_en or tg://resolve?domain=ethcutter_en
17  */
18 
19 library SafeMath {
20     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
21         if (_a == 0) {
22             return 0;
23         }
24         c = _a * _b;
25         require(c / _a == _b);
26         return c;
27     }
28 
29     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30         return _a / _b;
31     }
32 
33     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
34         require(_b <= _a);
35         return _a - _b;
36     }
37 
38     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
39         c = _a + _b;
40         require(c >= _a);
41         return c;
42     }
43 }
44 
45 library AddressUtils {
46     function isContract(address _addr) internal view returns (bool) {
47         uint256 size;
48         assembly {size := extcodesize(_addr)}
49         return size > 0;
50     }
51 }
52 
53 library Helpers {
54     function walletFromData(bytes data) internal pure returns (address wallet) {
55         assembly {
56             wallet := mload(add(data, 20))
57         }
58     }
59 }
60 
61 contract ETHCutter {
62     using SafeMath for uint256;
63     using AddressUtils for address;
64 
65     address public adminWallet;
66 
67     uint256 constant public DEPOSIT_MIN = 10 finney;
68     uint256 constant public DEPOSIT_MAX = 10 ether;
69     uint256 constant public DEPOSIT_PERIOD = 5 days;
70     uint256 constant public TOTAL_PERCENT = 120;
71     uint256 constant public UPLINE_PERCENT = 6;
72     uint256 constant public EXPENSES_PERCENT = 15;
73 
74     uint256 public totalDeposited = 0;
75     uint256 public totalWithdrawn = 0;
76     uint256 public usersCount = 0;
77     uint256 public depositsCount = 0;
78     uint256 public expenses = 0;
79 
80     mapping(address => User) public users;
81     mapping(uint256 => Deposit) public deposits;
82 
83     struct Deposit {
84         uint256 createdAt;
85         uint256 endAt;
86         uint256 amount;
87         uint256 accrued;
88         uint256 totalForAccrual;
89         bool active;
90     }
91 
92     struct User {
93         uint256 createdAt;
94         address upline;
95         uint256 totalDeposited;
96         uint256 totalWithdrawn;
97         uint256 depositsCount;
98         uint256[] deposits;
99     }
100 
101     modifier onlyAdmin() {
102         require(msg.sender == adminWallet);
103         _;
104     }
105 
106     constructor() public {
107         adminWallet = msg.sender;
108         createUser(msg.sender, address(0));
109     }
110 
111     function createUser(address wallet, address upline) internal {
112         users[wallet] = User({
113             createdAt : now,
114             upline : upline,
115             totalDeposited : 0,
116             totalWithdrawn : 0,
117             depositsCount : 0,
118             deposits : new uint256[](0)
119             });
120         usersCount++;
121     }
122 
123     function createDeposit(address wallet, uint256 amount) internal {
124         User storage user = users[wallet];
125 
126         Deposit memory deposit = Deposit({
127             createdAt : now,
128             endAt : now.add(DEPOSIT_PERIOD),
129             amount : amount,
130             accrued : 0,
131             totalForAccrual : amount.div(100).mul(TOTAL_PERCENT),
132             active : true
133         });
134 
135         deposits[depositsCount] = deposit;
136         user.deposits.push(depositsCount);
137 
138         user.totalDeposited = user.totalDeposited.add(amount);
139         totalDeposited = amount.add(totalDeposited);
140 
141         user.depositsCount++;
142         depositsCount++;
143         expenses = expenses.add(amount.div(100).mul(EXPENSES_PERCENT));
144 
145         uint256 referralFee = amount.div(100).mul(UPLINE_PERCENT);
146         transferReferralFee(user.upline, referralFee);
147     }
148 
149     function transferReferralFee(address to, uint256 amount) internal {
150         if (to != address(0)) {
151             to.transfer(amount);
152         }
153     }
154 
155     function getUpline() internal view returns (address){
156         address uplineWallet = Helpers.walletFromData(msg.data);
157         return users[uplineWallet].createdAt > 0 && msg.sender != uplineWallet
158         ? uplineWallet
159         : adminWallet;
160     }
161 
162     function() payable public {
163         address wallet = msg.sender;
164         uint256 amount = msg.value;
165 
166         require(wallet != address(0), 'Address incorrect');
167         require(!wallet.isContract(), 'Address is contract');
168         require(amount <= DEPOSIT_MAX, 'Amount too big');
169 
170         if (users[wallet].createdAt == 0) {
171             createUser(wallet, getUpline());
172         }
173 
174         if (amount >= DEPOSIT_MIN) {
175             createDeposit(wallet, amount);
176         } else {
177             accrualDeposits();
178         }
179     }
180 
181     function accrualDeposits() internal {
182         address wallet = msg.sender;
183         User storage user = users[wallet];
184 
185         for (uint i = 0; i < user.depositsCount; i++) {
186             if (deposits[user.deposits[i]].active) {
187                 accrual(user.deposits[i], wallet);
188             }
189         }
190     }
191 
192     function getAccrualAmount(Deposit deposit) internal view returns (uint256){
193         uint256 amount = deposit.totalForAccrual
194         .div(DEPOSIT_PERIOD)
195         .mul(
196             now.sub(deposit.createdAt)
197         )
198         .sub(deposit.accrued);
199 
200         if (amount.add(deposit.accrued) > deposit.totalForAccrual) {
201             amount = deposit.totalForAccrual.sub(deposit.accrued);
202         }
203 
204         return amount;
205     }
206 
207     function accrual(uint256 depositId, address wallet) internal {
208         uint256 amount = getAccrualAmount(deposits[depositId]);
209         Deposit storage deposit = deposits[depositId];
210 
211         withdraw(wallet, amount);
212 
213         deposits[depositId].accrued = deposit.accrued.add(amount);
214 
215         if (deposits[depositId].accrued >= deposit.totalForAccrual) {
216             deposits[depositId].active = false;
217         }
218     }
219 
220     function withdraw(address wallet, uint256 amount) internal {
221         wallet.transfer(amount);
222         totalWithdrawn = totalWithdrawn.add(amount);
223         users[wallet].totalWithdrawn = users[wallet].totalWithdrawn.add(amount);
224     }
225 
226     function withdrawExpenses() public onlyAdmin {
227         adminWallet.transfer(expenses);
228         expenses = 0;
229     }
230 
231     function getUserDeposits(address _address) public view returns (uint256[]){
232         return users[_address].deposits;
233     }
234 
235 }