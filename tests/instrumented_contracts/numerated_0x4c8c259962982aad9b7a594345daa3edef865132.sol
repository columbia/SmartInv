1 pragma solidity ^0.5.16;
2 pragma experimental ABIEncoderV2;
3 
4 
5 // Math operations with safety checks that throw on error
6 library SafeMath {
7     
8     function add(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a + b;
10         require(c >= a);
11         return c;
12     }
13   
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15         require(b <= a);
16         return a - b;
17     }
18     
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         if (a == 0) {
21             return 0;
22         }
23         uint256 c = a * b;
24         require(c / a == b);
25         return c;
26     }
27   
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a / b;
30         return c;
31     }
32     
33 }
34 
35 // Abstract contract for the full ERC 20 Token standard
36 contract ERC20 {
37     
38     function balanceOf(address _address) public view returns (uint256 balance);
39     
40     function transfer(address _to, uint256 _value) public returns (bool success);
41     
42     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
43     
44     function approve(address _spender, uint256 _value) public returns (bool success);
45     
46     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
47 
48     event Transfer(address indexed _from, address indexed _to, uint256 _value);
49     
50     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51     
52 }
53 
54 contract UniSwap {
55     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
56 }
57 
58 // Token contract
59 contract BHT is ERC20, UniSwap {
60     
61     string public name = "Bounty Hunter Token";
62     string public symbol = "BHT";
63     uint8 public decimals = 18;
64     // 总发行量1万个
65     uint256 public totalSupply = 10000 * 10**18;
66     mapping (address => uint256) public balances;
67     mapping (address => mapping (address => uint256)) public allowed;
68     // 合约管理者
69     address public owner;
70     
71     /*****************uniswapp配对合约地址************/
72     // uniswapp配对合约地址
73     address public pairAddress;
74     
75     /*********************投资这一块*******************/
76     // BHC合约的地址
77     address public BHCAddress;
78     // BHC授权交易
79     bytes4 private constant SELECTOR = bytes4(
80         keccak256(bytes("transfer(address,uint256)"))
81     );
82     // 上次提币的时间
83     uint256 public lastTime = 0;
84     // 30天只能转出一次; 24个小时乘以30天;
85     uint256 public monthTime;
86     // 提取投资的时间; 24个小时乘以投资的类型的天数;
87     uint256 public dayTime;
88     // 用户每隔7天可以提现奖励一次;
89     uint256 public wTime;
90     // 一个只能转出的数量, 一千个
91     uint256 tokenNumber = 1000 * 10**18;
92     // 地址的投资信息
93     struct invest {
94         // 投资的类型 30,90,180,3600
95         uint256 genre;
96         // 开始的时间
97         uint256 time;
98         // 可提现的时间
99         uint256 withdrawTime;
100         // 投资的金额BHT
101         uint256 money;
102         // 赚取的BHC数量; (投资的加赚取的, 但是没有扣除书续费)
103         uint256 earnBHC;
104         // 可以提现的BHC数量; (扣除手续费之后的数量)
105         uint256 withdrawBHC;
106         // 是否已经提现
107         bool withdraw;
108     }
109     // 用户的所有投资
110     mapping(address => invest[]) public invests;
111     // 用户的上级和推广收益, 以及下级数量
112     struct inf {
113         // 是否注册; ture已注册, false未注册
114         bool register;
115         // 上级, 也就是推荐人
116         address super1;
117         // 上上级
118         address super2;
119         // 下级数量
120         uint256 juniors;
121         // 推广的奖励; 也是BHC
122         uint256 award;
123         // 下级投资了多少钱
124         uint256 group;
125         // 下次可以提现奖励的时间; (每隔7天可以提现一次推荐奖励)
126         uint256 time;
127     }
128     mapping(address => inf) public info;
129     // 提现推广奖励的记录
130     struct record {
131         // 提现的时间
132         uint256 time;
133         // 提现的金额
134         uint256 money;
135     }
136     mapping(address => record[]) public records;
137     
138     /*********************投资这一块*******************/
139     
140     // 构造函数;
141     // 主网使用BHC地址, 时间是86400秒(也就是一天);
142     // 测试网使用代币地址(0x...); 时间自定义(60) 
143     constructor(address _BHCAddress, uint256 _day) public {
144         balances[address(this)] = totalSupply;
145         owner = msg.sender;
146         // BHC代币合约地址
147         BHCAddress = _BHCAddress;
148         // 管理员一个月只能转出一次BHT;
149         monthTime = _day * 30;
150         // 提取投资的时间; 24个小时乘以投资的类型的天数;
151         dayTime = _day;
152         // 用户提现的间隔时间;
153         wTime = _day * 7;
154     }
155     
156     // 管理员修饰符
157     modifier onlyOwner { 
158         require(msg.sender == owner, "You are not owner");
159         _;
160     }
161     
162     function balanceOf(address _address) public view returns (uint256 balance) {
163         return balances[_address];
164     }
165     
166     function transfer(address _to, uint256 _value) public returns (bool success) {
167         require(_to != address(0));
168         require(balances[msg.sender] >= _value && _value > 0, "Insufficient balance or zero amount");
169         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
170         balances[_to] = SafeMath.add(balances[_to], _value);
171         emit Transfer(msg.sender, _to, _value);
172         return true;
173     }
174     
175     function approve(address _spender, uint256 _amount) public returns (bool success) {
176         require(_spender != address(0));
177         require((allowed[msg.sender][_spender] == 0) || (_amount == 0));
178         allowed[msg.sender][_spender] = _amount;
179         emit Approval(msg.sender, _spender, _amount);
180         return true;
181     }
182     
183     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
184         require(_from != address(0) && _to != address(0));
185         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0, "Insufficient balance or zero amount");
186         balances[_from] = SafeMath.sub(balances[_from], _value);
187         balances[_to] = SafeMath.add(balances[_to], _value);
188         allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
189         emit Transfer(_from, _to, _value);
190         return true;
191     }
192     
193     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
194         return allowed[_owner][_spender];
195     }
196     
197     // 更换管理员
198     function setOwner(address _owner) public onlyOwner returns (bool success) {
199         require(_owner != address(0));
200         owner= _owner;
201         return true;
202     }
203     
204     /************************************投资这一块***********************************/
205     // 已注册修饰符
206     modifier onlyRegistered {
207         require(info[msg.sender].register, "You have not registered");
208         _;
209     }
210     // 已投资的修饰符
211     modifier onlyInvest {
212         require(invests[msg.sender].length > 0, "You have not Invest");
213         _;
214     }
215     
216     // 注册事件
217     event RegisterInvest(address indexed _super1, address indexed _address);
218     // 锁仓投资事件
219     event LockedInvest(address indexed _address, uint256 _value, uint256 _genre);
220     // 提现锁仓投资事件
221     event WithdrawInvest(address indexed _address, uint256 _value);
222     // 提现推广奖励事件
223     event WithdrawAward(address indexed _address, uint256 _value);
224     
225     
226     // 管理员取出BHT; 每30天只能提币一次, 一次必须是1000个;
227     function fetchBHT(address _address) public onlyOwner returns (bool success) {
228         // 不能是0地址
229         require(_address != address(0));
230         require(balances[address(this)] >= tokenNumber, "Contract insufficient balance");
231         if(lastTime == 0) {
232             // 如果上次提币时间是0, 说明这是第一次提币;
233             lastTime = block.timestamp;
234         }else {
235             // 如果不是0, 说明不是第一次提币; 需要判断时间有没有过30天;
236             require(lastTime + monthTime < block.timestamp, "Time is not");
237             lastTime += monthTime;
238         }
239         balances[_address] = SafeMath.add(balances[_address], tokenNumber);
240         balances[address(this)] = SafeMath.sub(balances[address(this)], tokenNumber);
241         emit Transfer(address(this), _address, tokenNumber);
242         success = true;
243     }
244     
245     // 管理员取出BHC
246     function fetchBHC(address _to, uint256 _value) public onlyOwner returns (bool success2) {
247         // 不能是0地址
248         require(_to != address(0));
249         (bool success, ) = BHCAddress.call(
250             abi.encodeWithSelector(SELECTOR, _to, _value)
251         );
252         if(!success) {
253             revert("transfer fail");
254         }
255         success2 = true;
256     }
257     
258     // 管理员设置配对合约地址
259     function setPairAddress(address _address) public onlyOwner returns (bool success) {
260          // 不能是0地址
261         require(_address != address(0));
262         pairAddress = _address;
263         success = true;
264     }
265     
266     // 注册; 投资之前需要先进行一个注册操作, 梳理下上级身份;
267     function registerInvest(address _super1) public returns (bool success) {
268         // 注册人必须没有注册过;
269         require(!(info[msg.sender].register), "You have been registered");
270         // 如果推荐人是0地址; 就相当于是没有推荐人, 前端默认的0地址
271         if(_super1 == address(0)) {
272             // 已注册; 结束
273             info[msg.sender].register = true;
274             return true;
275         }
276         // 上级(也就是推荐人)必须是已经注册的地址;
277         require(info[_super1].register, "The referee is not registered");
278         // 修改注册人信息; 已注册, 赋值上级
279         info[msg.sender].register = true;
280         info[msg.sender].super1 = _super1;
281         // 梳理上下级身份, 最多有二级;
282         // 先处理上级; 下级数量加1;
283         info[_super1].juniors += 1;
284         // 判断有没有上上级;
285         address super2 = info[_super1].super1;
286         if(super2 != address(0)) {
287             // 说明有上上级; 注册人添加上上级, 上上级的下级人数加1
288             info[msg.sender].super2 = super2;
289             info[super2].juniors += 1;
290         }
291         // 触发注册事件
292         emit RegisterInvest(_super1, msg.sender);
293         success = true;
294     }
295     
296     // 锁仓投资;
297     function lockedInvest(uint256 _value, uint256 _genre) public onlyRegistered returns (bool success) {
298         // 锁仓类型只有四种; 30天平均月化8%, 90天平均月化9%, 180天平均月化10%, 360天平均月化12%;
299         require(_genre == 30 || _genre == 90 || _genre == 180 || _genre == 360, "locked position type inexistence");
300         // 判断BHT余额是否足够; 并且投资金额必须大于0;
301         require(balances[msg.sender] >= _value && _value > 0, "Insufficient balance or zero amount");
302         // 把用户投资的币放到合约里
303         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
304         balances[address(this)] = SafeMath.add(balances[address(this)], _value);
305         emit Transfer(msg.sender, address(this), _value);
306         
307         // 计算投资的值对应的BHC数量;
308         uint256 _value2 = getPro(_value);
309         
310         // 可提现时间
311         uint256 wt = block.timestamp + dayTime * _genre;
312         // 赚取金额BHC数量; (投资+收益, 但没有扣除手续费)
313         uint256 eb;
314         // 应该给到推广奖励的数量;
315         uint256 award1;
316         uint256 award2;
317         if(_genre == 30) {
318             // 计算投资赚取BHC的收益
319             eb = _value2 + _value2 * 8/100;
320             // 计算上级的推荐奖励
321             award1 = _value2 * 8/100 * 20/100;
322             award2 = _value2 * 8/100 * 10/100;
323         }
324         if(_genre == 90) {
325             eb = _value2 + _value2 * 9/100 * 3;
326             award1 = _value2 * 9/100 * 20/100 * 3;
327             award2 = _value2 * 9/100 * 10/100 * 3;
328         }
329         if(_genre == 180) {
330             eb = _value2 + _value2 * 10/100 * 6;
331             award1 = _value2 * 10/100 * 20/100 * 6;
332             award2 = _value2 * 10/100 * 10/100 * 6;
333         }
334         if(_genre == 360) {
335             eb = _value2 + _value2 * 12/100 * 12;
336             award1 = _value2 * 12/100 * 20/100 * 12;
337             award2 = _value2 * 12/100 * 10/100 * 12;
338         }
339         // 可提现的金额BHC数量;
340         uint256 wb = eb - (eb * 3/100);
341         // 保存用户的投资信息; 类型,时间,可提现时间,投资金额BHT,赚取金额BHC,可以提现的金额BHC,未提现
342         invest memory i = invest(_genre, block.timestamp, wt, _value, eb, wb, false);
343         invests[msg.sender].push(i);
344         
345         // 给上级增加奖励;
346         address super1 = info[msg.sender].super1;
347         address super2 = info[msg.sender].super2;
348         if(super1 != address(0)) {
349            info[super1].award += award1;
350            info[super1].group += _value;
351         }
352         if(super2 != address(0)) {
353           info[super2].award += award2;
354           info[super2].group += _value;
355         }
356         
357         // 触发锁仓事件
358         emit LockedInvest(msg.sender, _value, _genre);
359         success = true;
360     }
361     
362     // 提现锁仓投资; 通过索引进行提现, 提现的币是BHC, 收取的手续费也是BHC, 销毁的BHT
363     function withdrawInvest(uint256 _index) public onlyInvest returns (bool success2) {
364         // 索引必须小于投资数组的长度
365         require(invests[msg.sender].length > _index, "invest is not");
366         // 先获取索引对应的投资订单;
367         invest memory i = invests[msg.sender][_index];
368         // 提现时间, 是否提现, 销毁的BHT数量, 用户提现BHC的数量;
369         uint256 wt = i.withdrawTime;
370         bool w = i.withdraw;
371         uint256 m = i.money;
372         uint256 wb = i.withdrawBHC;
373         // 判断这笔订单是否到达可提现时间
374         require(block.timestamp > wt, "Time is not");
375         // 判断这笔订单是否已经提现
376         require(!w, "already withdraw");
377         
378         // 销毁投资的BHT;
379         balances[address(this)] = SafeMath.sub(balances[address(this)], m);
380         balances[address(0)] = SafeMath.add(balances[address(0)], m);
381         emit Transfer(address(this), address(0), m);
382         // 用户提现BHC
383         (bool success, ) = BHCAddress.call(
384             abi.encodeWithSelector(SELECTOR, msg.sender, wb)
385         );
386         if(!success) {
387             revert("transfer fail");
388         }
389         
390         // 修改状态; 已经提现
391         invests[msg.sender][_index].withdraw = true;
392         // 触发提现锁仓事件
393         emit WithdrawInvest(msg.sender, wb);
394         success2 = true;
395          // 确认; 防止攻击者控制gas
396         assert(invests[msg.sender][_index].withdraw);
397     }
398     
399     // 提现推广奖励; 通过金额进行提取
400     function withdrawAward(uint256 _money) public onlyInvest returns (bool success2) {
401         // 可提现奖励的金额, 可提现的时间
402         uint256 m = info[msg.sender].award;
403         uint256 t = info[msg.sender].time;
404         // 金额判断;
405         require(m >= _money, "The amount is not enough");
406         // 时间判断
407         require(t < block.timestamp, "Time is not");
408         
409         // 实际转账的值; 扣除3%的手续费
410         uint256 v = _money - (_money * 3/100);
411         // 转账
412        (bool success, ) = BHCAddress.call(
413             abi.encodeWithSelector(SELECTOR, msg.sender, v)
414         );
415         if(!success) {
416             revert("transfer fail");
417         }
418         // 修改数据
419         info[msg.sender].award -= _money;
420         // 触发提现推广奖励事件
421         emit WithdrawAward(msg.sender, _money);
422         // 重新修改可提现时间
423         info[msg.sender].time = block.timestamp + wTime;
424         // 保存提现记录
425         record memory r = record(block.timestamp, _money);
426         records[msg.sender].push(r);
427         success2 = true;
428     }
429     
430     // 查询用户所有的投资
431     function getInvests(address _address) public view returns (invest[] memory r) {
432         // 获取所有投资的数量
433         uint256 l = invests[_address].length;
434         // 创建定长数组对象
435         r = new invest[](l);
436         for(uint256 i = 0; i < l; i++) {
437             r[i] = invests[_address][i];
438         }
439     }
440     
441     // 查询用户所有的提现记录
442     function getRecords(address _address) public view returns (record[] memory r) {
443         // 获取所有投资的数量
444         uint256 l = records[_address].length;
445         r = new record[](l);
446         for(uint256 i = 0; i < l; i++) {
447             r[i] = records[_address][i];
448         }
449     }
450     
451     // 查询用户的信息
452     function getInfo(address _address) public view returns (inf memory r) {
453         r = info[_address];
454     }
455     
456     /* ----------------uniswap配对合约的交互----------------- */
457     // 重写这个函数
458     function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {
459         UniSwap uniswap = UniSwap(pairAddress);
460         // 返回的值, 地址小的在前面, 大的在后面
461         (_reserve0, _reserve1, _blockTimestampLast) = uniswap.getReserves();
462     }
463     
464     // 根据当时的比例, 给出BHT计算出BHC;
465     function getPro(uint256 _value) public view returns (uint256 v) {
466         // 显示转换
467         (uint256 _reserve0, uint256 _reserve1, ) = getReserves();
468         require(address(this) != BHCAddress, "two address identical");
469         if(address(this) < BHCAddress) {
470             // 说明_reserve0对应的BHT, _reserve1对应BHC;
471             v = _value * _reserve1 / _reserve0;
472         }else {
473             v = _value * _reserve0 / _reserve1;
474         }
475     }
476     
477   
478     
479 }