1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Math
6  * @dev Assorted math operations
7  */
8 library Math {
9   /**
10   * @dev Returns the largest of two numbers.
11   */
12   function max(uint256 a, uint256 b) internal pure returns (uint256) {
13     return a >= b ? a : b;
14   }
15 
16   /**
17   * @dev Returns the smallest of two numbers.
18   */
19   function min(uint256 a, uint256 b) internal pure returns (uint256) {
20     return a < b ? a : b;
21   }
22 
23   /**
24   * @dev Calculates the average of two numbers. Since these are integers,
25   * averages of an even and odd number cannot be represented, and will be
26   * rounded down.
27   */
28   function average(uint256 a, uint256 b) internal pure returns (uint256) {
29     // (a + b) / 2 can overflow, so we distribute
30     return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
31   }
32 }
33 
34 /**
35  * @title SafeMath
36  * @dev Math operations with safety checks that revert on error
37  */
38 library SafeMath {
39 
40   /**
41   * @dev Multiplies two numbers, reverts on overflow.
42   */
43   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
45     // benefit is lost if 'b' is also tested.
46     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
47     if (a == 0) {
48       return 0;
49     }
50 
51     uint256 c = a * b;
52     require(c / a == b);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
59   */
60   function div(uint256 a, uint256 b) internal pure returns (uint256) {
61     require(b > 0); // Solidity only automatically asserts when dividing by 0
62     uint256 c = a / b;
63     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
64 
65     return c;
66   }
67 
68   /**
69   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
70   */
71   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72     require(b <= a);
73     uint256 c = a - b;
74 
75     return c;
76   }
77 
78   /**
79   * @dev Adds two numbers, reverts on overflow.
80   */
81   function add(uint256 a, uint256 b) internal pure returns (uint256) {
82     uint256 c = a + b;
83     require(c >= a);
84 
85     return c;
86   }
87 
88   /**
89   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
90   * reverts when dividing by zero.
91   */
92   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
93     require(b != 0);
94     return a % b;
95   }
96 }
97 
98 library AddressUtils {
99     function isContract(address _addr) internal view returns (bool) {
100         uint256 size;
101         assembly {size := extcodesize(_addr)}
102         return size > 0;
103     }
104 }
105 
106 library Helpers {
107     function walletFromData(bytes data) internal pure returns (address wallet) {
108         assembly {
109             wallet := mload(add(data, 20))
110         }
111     }
112 }
113 
114 contract Riveth {
115     using SafeMath for uint256;
116     using AddressUtils for address;
117 
118     address public adminWallet;
119 
120     uint256 constant public DEPOSIT_MIN = 10 finney;
121     uint256 constant public DEPOSIT_MAX = 50 ether;
122     uint256 constant public DEPOSIT_PERIOD = 60 days;
123     uint256 constant public DEPOSIT_COUNT_LIMIT = 5;
124     uint256 constant public TOTAL_BASE_PERCENT = 120;
125     uint256 constant public UPLINE_BASE_PERCENT = 5;
126     uint256 constant public UPLINE_MIN_DEPOSIT = 10 finney;
127     uint256 constant public EXPENSES_PERCENT = 10;
128 
129     uint256 public totalDeposited = 0;
130     uint256 public totalWithdrawn = 0;
131     uint256 public usersCount = 0;
132     uint256 public depositsCount = 0;
133 
134     mapping(address => User) public users;
135     mapping(uint256 => Deposit) public deposits;
136 
137     struct Deposit {
138         uint256 createdAt;
139         uint256 endAt;
140         uint256 amount;
141         uint256 accrued;
142         bool active;
143     }
144 
145     struct User {
146         uint256 createdAt;
147         address upline;
148         uint256 totalDeposited;
149         uint256 totalWithdrawn;
150         uint256 activeDepositsCount;
151         uint256 activeDepositsAmount;
152         uint256[] deposits;
153     }
154 
155     modifier onlyAdmin() {
156         require(msg.sender == adminWallet);
157         _;
158     }
159 
160     constructor() public {
161         adminWallet = msg.sender;
162         createUser(msg.sender, address(0));
163     }
164 
165     function createUser(address wallet, address upline) internal {
166         users[wallet] = User({
167             createdAt : now,
168             upline : upline,
169             totalDeposited : 0,
170             totalWithdrawn : 0,
171             activeDepositsCount : 0,
172             activeDepositsAmount : 0,
173             deposits : new uint256[](0)
174             });
175         usersCount++;
176     }
177 
178     function createDeposit(address wallet, uint256 amount) internal {
179         User storage user = users[wallet];
180 
181         Deposit memory deposit = Deposit({
182             createdAt : now,
183             endAt : now.add(DEPOSIT_PERIOD),
184             amount : amount,
185             accrued : 0,
186             active : true
187         });
188 
189         deposits[depositsCount] = deposit;
190         user.deposits.push(depositsCount);
191 
192         user.totalDeposited = user.totalDeposited.add(amount);
193         totalDeposited = amount.add(totalDeposited);
194 
195         depositsCount++;
196         user.activeDepositsCount++;
197         user.activeDepositsAmount = user.activeDepositsAmount.add(amount);
198 
199         adminWallet.transfer(amount.mul(EXPENSES_PERCENT).div(100));
200 
201         uint256 uplineFee = amount.mul(UPLINE_BASE_PERCENT).div(100);
202         transferUplineFee(uplineFee);
203     }
204 
205     function transferUplineFee(uint256 amount) internal {
206         if (users[msg.sender].upline != address(0)) {
207             users[msg.sender].upline.transfer(amount);
208         }
209     }
210 
211     function getUpline() internal view returns (address){
212         address uplineWallet = Helpers.walletFromData(msg.data);
213         return users[uplineWallet].createdAt > 0 
214         && users[uplineWallet].totalDeposited >= UPLINE_MIN_DEPOSIT 
215         && msg.sender != uplineWallet
216         ? uplineWallet
217         : adminWallet;
218     }
219 
220     function() payable public {
221         require(msg.sender != address(0), 'Address incorrect');
222         require(!msg.sender.isContract(), 'Address is contract');
223         require(msg.value <= DEPOSIT_MAX, 'Amount too big');
224 
225         if (users[msg.sender].createdAt == 0) {
226             createUser(msg.sender, getUpline());
227         }
228 
229         if (msg.value >= DEPOSIT_MIN) {
230             require(users[msg.sender].activeDepositsCount < DEPOSIT_COUNT_LIMIT, 'Active deposits count limit');
231             createDeposit(msg.sender, msg.value);
232         } else {
233             accrueDeposits();
234         }
235     }
236 
237     function accrueDeposits() internal {
238         User storage user = users[msg.sender];
239 
240         for (uint i = 0; i < user.deposits.length; i++) {
241             if(deposits[user.deposits[i]].active){
242                 accrueDeposits(user.deposits[i]);
243             }
244         }
245     }
246 
247     function accrueDeposits(uint256 depositId) internal {
248         uint256 amount = getAccrualAmount(depositId);
249         Deposit storage deposit = deposits[depositId];
250 
251         withdraw(msg.sender, amount);
252 
253         deposits[depositId].accrued = deposit.accrued.add(amount);
254 
255         if (deposits[depositId].endAt >= now) {
256             deposits[depositId].active = false;
257             users[msg.sender].activeDepositsCount--;
258             users[msg.sender].activeDepositsAmount = users[msg.sender].activeDepositsAmount.sub(deposits[depositId].amount);
259         }
260     }
261 
262     function getAccrualAmount(uint256 depositId) internal view returns (uint256){
263         Deposit storage deposit = deposits[depositId];
264         uint256 totalProfit = totalForAccrual(msg.sender, depositId);
265         uint256 amount = totalProfit
266         .mul(
267             now.sub(deposit.createdAt)
268         )
269         .div(DEPOSIT_PERIOD)
270         .sub(deposit.accrued);
271 
272         if (amount.add(deposit.accrued) > totalProfit) {
273             amount = totalProfit.sub(deposit.accrued);
274         }
275         return amount;
276     }
277 
278 
279     function withdraw(address wallet, uint256 amount) internal {
280         wallet.transfer(amount);
281         totalWithdrawn = totalWithdrawn.add(amount);
282         users[wallet].totalWithdrawn = users[wallet].totalWithdrawn.add(amount);
283     }
284 
285     function getUserDeposits(address _address) public view returns (uint256[]){
286         return users[_address].deposits;
287     }
288 
289     function getGlobalPercent() public view returns (uint256){
290         uint256 balance = address(this).balance;
291         if(balance >= 5000 ether){
292             //5.5% daily
293             return 330;
294         }
295         if(balance >= 3000 ether){
296             //5% daily
297             return 300;
298         }
299         if(balance >= 1000 ether){
300             //4.5% daily
301             return 270;
302         }
303         if(balance >= 500 ether){
304             //4% daily
305             return 240;
306         }
307         if(balance >= 200 ether){
308             //3.5% daily
309             return 210;
310         }
311         if(balance >= 100 ether){
312             //3% daily
313             return 180;
314         }
315         if(balance >= 50 ether){
316             //2.5% daily
317             return 150;
318         }
319         return TOTAL_BASE_PERCENT;
320     }
321 
322     function getLocalPercent() public view returns (uint256){
323         return getLocalPercent(msg.sender);
324     }
325 
326     function getLocalPercent(address user) public view returns (uint256){
327         uint256 activeDepositsAmount = users[user].activeDepositsAmount;
328         if(activeDepositsAmount >= 250 ether){
329             //5.5% daily
330             return 330;
331         }
332         if(activeDepositsAmount >= 150 ether){
333             //5% daily
334             return 300;
335         }
336         if(activeDepositsAmount >= 50 ether){
337             //4.5% daily
338             return 270;
339         }
340         if(activeDepositsAmount >= 25 ether){
341             //4% daily
342             return 240;
343         }
344         if(activeDepositsAmount >= 10 ether){
345             //3.5% daily
346             return 210;
347         }
348         if(activeDepositsAmount >= 5 ether){
349             //3% daily
350             return 180;
351         }
352         if(activeDepositsAmount >= 3 ether){
353             //2.5% daily
354             return 150;
355         }
356 
357         return TOTAL_BASE_PERCENT;
358     }
359 
360     function getIndividualPercent() public view returns (uint256){
361         return getIndividualPercent(msg.sender);
362     }
363 
364     function getIndividualPercent(address user) public view returns (uint256){
365         return Math.max(getGlobalPercent(), getLocalPercent(user));
366     }
367     
368     function totalForAccrual(address user, uint256 depositId) public view returns (uint256){
369         return deposits[depositId].amount.mul(getIndividualPercent(user)).div(100);
370     }
371 }