1 pragma solidity ^0.6.1;
2 
3 
4 /**
5 
6  * @dev IPCM锁仓解锁合约 Author: AlanYan99@outlook.com, Date:2020/04
7 
8  */
9 
10 contract IPCMToken {
11     using SafeMath for uint256;
12 
13     string public constant name = "InterPlanetary Continuous Media"; //  token name
14     string public constant symbol = "IPCM"; //  token symbol
15     uint256 public decimals = 18; //  token digit
16 
17     uint256 public totalSupply_; // 已经发行总量
18     uint256 public _maxSupply = 100000000 * 10**uint256(decimals); //最大发行总量
19 
20     address owner = address(0); //合约所有者
21 
22     event Transfer(address indexed from, address indexed to, uint256 value); // 交易事件
23 
24     /**
25 
26   * @dev 接受解锁转账的账户地址
27 
28   */
29   
30     uint256 public unit_first = 1 days;
31     uint256 public unit_second = 365 days;
32 
33     address public addr_pool = 0x44a16F5Ec33c845AB10343F8Cae4093b6c028ccB; //矿池挖矿
34     address public addr_private = 0x970603FaD5d239070593D33772451A533d2c3C5E; //私募
35     address public addr_fund = 0xf4c0ee2707Da59bf57effE9Ee3034Bed18718EF5; //基金会
36     address public addr_promotion = 0x2D6b8F56E40296c251A88509f7Be00E97bCE27e7; //推广运营
37     address public addr_team = 0x27e57a6dFCF442f1cAC135285A7434E8de364cA5; //原始团队
38     
39 
40     mapping(address => uint256) balances; // 余额
41 
42     /** Reserve allocations */
43     mapping(address => uint256) public allocations; // 每个地址对应锁仓金额的映射表
44 
45     /** When timeLocks are over (UNIX Timestamp) */
46     mapping(address => uint256) public timeLocks; // 每个地址对应锁仓时间的映射表
47 
48     /** How many tokens each reserve wallet has claimed */
49     mapping(address => uint256) public claimed; // 每个地址对应锁仓后已经解锁的金额的映射表
50 
51     /** When token was locked (UNIX Timestamp)*/
52     uint256 public lockedAt = 0;
53 
54     /** Allocated reserve tokens */
55     event Allocated(address wallet, uint256 value);
56 
57     /** Distributed reserved tokens */
58     event Distributed(address wallet, uint256 value);
59 
60     /** Tokens have been locked */
61     event Locked(uint256 lockTime);
62 
63     modifier isOwner {
64         assert(owner == msg.sender);
65         _;
66     }
67 
68     // 合约调用者的地址为接受解锁转账的账户地址的其中之一
69     modifier onlyReserveWallets {
70         require(
71             msg.sender == addr_pool ||
72                 msg.sender == addr_private ||
73                 msg.sender == addr_fund ||
74                 msg.sender == addr_promotion ||
75                 msg.sender == addr_team
76         );
77         require(allocations[msg.sender] > 0);
78 
79         _;
80     }
81 
82     constructor() public {
83         owner = msg.sender;
84         allocate();
85     }
86 
87     /**
88 
89  * @dev total number of tokens in existence
90 
91  */
92 
93     function totalSupply() public view returns (uint256) {
94         return totalSupply_;
95     }
96 
97     /**
98 
99  * @dev Gets the balance of the specified address.
100 
101  * @param _owner The address to query the the balance of.
102 
103  * @return An uint256 representing the amount owned by the passed address.
104 
105  */
106 
107     function balanceOf(address _owner) public view returns (uint256) {
108         require(_owner != address(0));
109 
110         //账户余额
111         return balances[_owner];
112     }
113 
114     function maxSupply() public view returns (uint256) {
115         return _maxSupply;
116     }
117 
118     //私有方法从一个帐户发送给另一个帐户代币
119     function _transfer(address _from, address _to, uint256 _value) internal {
120         require(_value > 0);
121 
122         //避免转帐的地址是0x0
123         require(_to != address(0));
124 
125         //检查发送者是否拥有足够余额
126         require(balances[_from].sub(_value) >= 0);
127 
128         //检查是否溢出
129         require(balances[_to].add(_value) > balances[_to]);
130 
131         //从发送者减掉发送额
132         balances[_from] = balances[_from].sub(_value);
133 
134         //给接收者加上相同的量
135         balances[_to] = balances[_to].add(_value);
136 
137         emit Transfer(_from, _to, _value);
138     }
139 
140     function transfer(address _to, uint256 _value)
141         public
142         returns (bool success)
143     {
144         _transfer(msg.sender, _to, _value);
145         return true;
146     }
147 
148     //设定各个账号的token初始分配量和锁仓量
149     function allocate() internal {
150         balances[addr_private] = 1500000 * 10**uint256(decimals);
151         balances[addr_fund] = 1500000 * 10**uint256(decimals);
152         totalSupply_ = totalSupply_.add(balances[addr_private]);
153         totalSupply_ = totalSupply_.add(balances[addr_fund]);
154 
155         emit Transfer(address(0), addr_private, balances[addr_private]);
156         emit Transfer(address(0), addr_fund, balances[addr_fund]);
157 
158         allocations[addr_pool] = 50000000 * 10**uint256(decimals);
159         allocations[addr_private] = 13500000 * 10**uint256(decimals);
160         allocations[addr_fund] = 13500000 * 10**uint256(decimals);
161         allocations[addr_promotion] = 10000000 * 10**uint256(decimals);
162         allocations[addr_team] = 10000000 * 10**uint256(decimals);
163 
164         emit Allocated(addr_pool, allocations[addr_pool]);
165         emit Allocated(addr_private, allocations[addr_private]);
166         emit Allocated(addr_fund, allocations[addr_fund]);
167         emit Allocated(addr_promotion, allocations[addr_promotion]);
168         emit Allocated(addr_team, allocations[addr_team]);
169 
170         lock();
171     }
172 
173     //设定各个账号的锁仓时间截止期限
174     function lock() internal {
175         lockedAt = block.timestamp; // 区块当前时间
176 
177         uint256 next_year = ((lockedAt / (unit_second)) + 1) * (unit_second);
178         uint256 third_year = ((lockedAt / (unit_second)) + 2) * (unit_second);
179 
180         timeLocks[addr_pool] = lockedAt;
181         timeLocks[addr_private] = next_year;
182         timeLocks[addr_promotion] = lockedAt;
183         timeLocks[addr_fund] = next_year;
184         timeLocks[addr_team] = third_year;
185 
186         emit Locked(lockedAt);
187     }
188 
189     // Number of tokens that are still locked
190     function getLockedBalance()
191         public
192         view
193         onlyReserveWallets
194         returns (uint256 tokensLocked)
195     {
196         return allocations[msg.sender].sub(claimed[msg.sender]);
197     }
198 
199     //释放矿池挖矿收益
200     function claimToken() public onlyReserveWallets {
201         if (msg.sender == addr_pool) claimToken_Pool();
202         else if (msg.sender == addr_private) claimToken_Private();
203         else if (msg.sender == addr_fund) claimToken_Fund();
204         else if (msg.sender == addr_promotion) claimToken_Promotion();
205         else if (msg.sender == addr_team) claimToken_Team();
206     }
207 
208     //释放矿池挖矿收益，50%50,000,000，第一年每天解锁50,000，第二年每天解锁25,000，每年减半以此类推
209     function claimToken_Pool() public {
210         address addr_claim = addr_pool;
211         uint256 time_now = block.timestamp;
212 
213         require(addr_claim == msg.sender);
214 
215         //是否已过锁仓时间期限
216         require(time_now > timeLocks[addr_claim]);
217         //已经释放的总量是否小于总的计划分配数量
218         require(claimed[addr_claim] < allocations[addr_claim]);
219 
220         uint256 amnt_unit = 50000* 10**uint256(decimals);
221         uint256 span_years = (time_now / (unit_second)) -
222             (timeLocks[addr_claim] / (unit_second));
223         uint256 claim_cnt = 0;
224         
225 
226         //计算到目前为止所有应该释放token总量
227         for (uint256 i = 0; i <= span_years; i++) {
228             uint256 amnt_day = amnt_unit / (2**i);
229 
230             if (i == 0) //开始年份
231             {
232                 uint256 span_days;
233 
234                 if(span_years<1)
235                     span_days = ((time_now - timeLocks[addr_claim]) /
236             (unit_first)) + 1;
237                 else
238                     span_days = (unit_second/unit_first) -
239                     (timeLocks[addr_claim] % (unit_second)) /
240                     (unit_first);
241 
242                 claim_cnt = claim_cnt.add(amnt_day * span_days);
243 
244             } else if (i < span_years) //中间年份
245             {
246                 claim_cnt = claim_cnt.add(amnt_day * (unit_second/unit_first));
247             } else if (i == span_years) {
248                 //当前年份
249                 uint256 span_days = (time_now % (unit_second)) / (unit_first) + 1;
250                 claim_cnt = claim_cnt.add(amnt_day * span_days);
251             }
252         }
253        
254         if(claim_cnt > allocations[addr_claim])
255             claim_cnt = allocations[addr_claim];
256 
257         if (
258             claimed[addr_claim] < claim_cnt
259         ) //将前面所有应该释放但还未释放的token全部解锁发放
260         {
261             uint256 amount = claim_cnt.sub(claimed[addr_claim]);
262             balances[addr_claim] = balances[addr_claim].add(amount);
263             claimed[addr_claim] = claim_cnt;
264             totalSupply_ = totalSupply_.add(amount);
265 
266             emit Transfer(address(0), addr_claim, amount);
267             emit Distributed(addr_claim, amount);
268         }
269     }
270 
271     //释放私募收益，15%15,000,000；1,500,000立即释放，次年起剩余13,500,000每天释放10,000
272     function claimToken_Private() public {
273         address addr_claim = addr_private;
274         uint256 time_now = block.timestamp;
275 
276         require(addr_claim == msg.sender);
277 
278         //是否已过锁仓时间期限
279         require(time_now > timeLocks[addr_claim]);
280 
281         //已经释放的总量是否小于总的计划分配数量
282         require(claimed[addr_claim] < allocations[addr_claim]);
283         uint256 amnt_unit = 10000* 10**uint256(decimals);
284         uint256 span_days = ((time_now - timeLocks[addr_claim]) / (unit_first)) + 1;
285         uint256 claim_cnt = span_days.mul(amnt_unit);
286 
287         if(claim_cnt > allocations[addr_claim])
288             claim_cnt = allocations[addr_claim];
289 
290         if (
291             claimed[addr_claim] < claim_cnt
292         ) //将前面所有应该释放但还未释放的token全部解锁发放
293         {
294             uint256 amount = claim_cnt.sub(claimed[addr_claim]);
295             balances[addr_claim] = balances[addr_claim].add(amount);
296             claimed[addr_claim] = claim_cnt;
297             totalSupply_ = totalSupply_.add(amount);
298 
299             emit Transfer(address(0), addr_claim, amount);
300             emit Distributed(addr_claim, amount);
301         }
302     }
303 
304     //释放基金会收益，15%15,000,000；1,500,000立即释放，次年起剩余13,500,000每天释放10,000
305     function claimToken_Fund() public {
306         address addr_claim = addr_fund;
307         uint256 time_now = block.timestamp;
308 
309         require(addr_claim == msg.sender);
310 
311         //是否已过锁仓时间期限
312         require(time_now > timeLocks[addr_claim]);
313 
314         //已经释放的总量是否小于总的计划分配数量
315         require(claimed[addr_claim] < allocations[addr_claim]);
316 
317         uint256 amnt_unit = 10000* 10**uint256(decimals);
318         uint256 span_days = ((time_now - timeLocks[addr_claim]) / (unit_first)) + 1;
319         uint256 claim_cnt = span_days.mul(amnt_unit);
320 
321         if(claim_cnt > allocations[addr_claim])
322             claim_cnt = allocations[addr_claim];
323 
324         if (
325             claimed[addr_claim] < claim_cnt
326         ) //将前面所有应该释放但还未释放的token全部解锁发放
327         {
328             uint256 amount = claim_cnt.sub(claimed[addr_claim]);
329             balances[addr_claim] = balances[addr_claim].add(amount);
330             claimed[addr_claim] = claim_cnt;
331             totalSupply_ = totalSupply_.add(amount);
332 
333             emit Transfer(address(0), addr_claim, amount);
334             emit Distributed(addr_claim, amount);
335         }
336     }
337 
338     //释放推广运营收益，10%10,000,000 每天解锁20,000
339     function claimToken_Promotion() public {
340         address addr_claim = addr_promotion;
341         uint256 time_now = block.timestamp;
342 
343         require(addr_claim == msg.sender);
344 
345         //是否已过锁仓时间期限
346         require(time_now > timeLocks[addr_claim]);
347 
348         //已经释放的总量是否小于总的计划分配数量
349         require(claimed[addr_claim] < allocations[addr_claim]);
350 
351         uint256 amnt_unit = 20000* 10**uint256(decimals);
352         uint256 span_days = ((time_now - timeLocks[addr_claim]) / (unit_first)) + 1;
353         uint256 claim_cnt = span_days.mul(amnt_unit);
354 
355         if(claim_cnt > allocations[addr_claim])
356             claim_cnt = allocations[addr_claim];
357 
358         if (
359             claimed[addr_claim] < claim_cnt
360         ) //将前面所有应该释放但还未释放的token全部解锁发放
361         {
362             uint256 amount = claim_cnt.sub(claimed[addr_claim]);
363             balances[addr_claim] = balances[addr_claim].add(amount);
364             claimed[addr_claim] = claim_cnt;
365             totalSupply_ = totalSupply_.add(amount);
366 
367             emit Transfer(address(0), addr_claim, amount);
368             emit Distributed(addr_claim, amount);
369         }
370     }
371 
372     //释放原始团队收益，10%10,000,000锁仓两年，第三年开始每天释放20,000
373     function claimToken_Team() public {
374         address addr_claim = addr_team;
375         uint256 time_now = block.timestamp;
376 
377         require(addr_claim == msg.sender);
378 
379         //是否已过锁仓时间期限
380         require(time_now > timeLocks[addr_claim]);
381 
382         //已经释放的总量是否小于总的计划分配数量
383         require(claimed[addr_claim] < allocations[addr_claim]);
384 
385         uint256 amnt_unit = 20000* 10**uint256(decimals);
386         uint256 span_days = ((time_now - timeLocks[addr_claim]) / (unit_first)) + 1;
387         uint256 claim_cnt = span_days.mul(amnt_unit);
388 
389         if(claim_cnt > allocations[addr_claim])
390             claim_cnt = allocations[addr_claim];
391 
392         if (
393             claimed[addr_claim] < claim_cnt
394         ) //将前面所有应该释放但还未释放的token全部解锁发放
395         {
396             uint256 amount = claim_cnt.sub(claimed[addr_claim]);
397             balances[addr_claim] = balances[addr_claim].add(amount);
398             claimed[addr_claim] = claim_cnt;
399             totalSupply_ = totalSupply_.add(amount);
400 
401             emit Transfer(address(0), addr_claim, amount);
402             emit Distributed(addr_claim, amount);
403         }
404     }
405 }
406 
407 
408 library SafeMath {
409     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
410         if (a == 0) {
411             return 0;
412         }
413         uint256 c = a * b;
414         assert(c / a == b);
415         return c;
416     }
417 
418     function div(uint256 a, uint256 b) internal pure returns (uint256) {
419         uint256 c = a / b;
420         return c;
421     }
422 
423     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
424         assert(b <= a);
425         return a - b;
426     }
427 
428     function add(uint256 a, uint256 b) internal pure returns (uint256) {
429         uint256 c = a + b;
430         assert(c >= a);
431         return c;
432     }
433 }