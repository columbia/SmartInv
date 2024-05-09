1 pragma solidity ^0.4.23;
2 
3 contract CoinMmc // @eachvar
4 {
5     // ======== 初始化代币相关逻辑 ==============
6     // 地址信息
7     address public admin_address = 0x64b33dB1Cc804e7CA51D9c21F132567923D7BA00; // @eachvar
8     address public account_address = 0x64b33dB1Cc804e7CA51D9c21F132567923D7BA00; // @eachvar 初始化后转入代币的地址
9     
10     // 定义账户余额
11     mapping(address => uint256) balances;
12     
13     // solidity 会自动为 public 变量添加方法，有了下边这些变量，就能获得代币的基本信息了
14     string public name = "MaiMiChain"; // @eachvar
15     string public symbol = "MMC"; // @eachvar
16     uint8 public decimals = 2; // @eachvar
17     uint256 initSupply = 1000000000000; // @eachvar
18     uint256 public totalSupply = 0; // @eachvar
19 
20     // 生成代币，并转入到 account_address 地址
21     constructor() 
22     payable 
23     public
24     {
25         totalSupply = mul(initSupply, 10**uint256(decimals));
26         balances[account_address] = totalSupply;
27 
28         // @lock
29         // 锁仓相关信息 
30         _add_lock_account(0x6efB62605A66E32582c37b835F81Bc91A6a8fb2e, mul(80000000000,10**uint256(decimals)), 1596815160);
31         _add_lock_account(0x0ba46c0fC6a5C206855cEf215222e347E1559eDf, mul(120000000000,10**uint256(decimals)), 1596815160);
32         _add_lock_account(0xE269695D497387DfEAFE12b0b3B54441683F63C8, mul(100000000000,10**uint256(decimals)), 1628351160);
33         
34         
35     }
36 
37     function balanceOf( address _addr ) public view returns ( uint )
38     {
39         return balances[_addr];
40     }
41 
42     // ========== 转账相关逻辑 ====================
43     event Transfer(
44         address indexed from, 
45         address indexed to, 
46         uint256 value
47     ); 
48 
49     function transfer(
50         address _to, 
51         uint256 _value
52     ) 
53     public 
54     returns (bool) 
55     {
56         require(_to != address(0));
57         require(_value <= balances[msg.sender]);
58 
59         balances[msg.sender] = sub(balances[msg.sender],_value);
60 
61         // @lock
62         // 添加锁仓相关检查
63         // solium-disable-next-line security/no-block-members
64         if(lockInfo[msg.sender].amount > 0 && block.timestamp < lockInfo[msg.sender].release_time)
65             require(balances[msg.sender] >= lockInfo[msg.sender].amount);
66 
67             
68 
69         balances[_to] = add(balances[_to], _value);
70         emit Transfer(msg.sender, _to, _value);
71         return true;
72     }
73 
74     // ========= 授权转账相关逻辑 =============
75     
76     mapping (address => mapping (address => uint256)) internal allowed;
77     event Approval(
78         address indexed owner,
79         address indexed spender,
80         uint256 value
81     );
82 
83     function transferFrom(
84         address _from,
85         address _to,
86         uint256 _value
87     )
88     public
89     returns (bool)
90     {
91         require(_to != address(0));
92         require(_value <= balances[_from]);
93         require(_value <= allowed[_from][msg.sender]);
94 
95         balances[_from] = sub(balances[_from], _value);
96         
97         // @lock
98         // 添加锁仓相关检查 
99         // solium-disable-next-line security/no-block-members
100         if(lockInfo[_from].amount > 0 && block.timestamp < lockInfo[_from].release_time)
101             require(balances[_from] >= lockInfo[_from].amount);
102         
103         
104         balances[_to] = add(balances[_to], _value);
105         allowed[_from][msg.sender] = sub(allowed[_from][msg.sender], _value);
106         emit Transfer(_from, _to, _value);
107         return true;
108     }
109 
110     function approve(
111         address _spender, 
112         uint256 _value
113     ) 
114     public 
115     returns (bool) 
116     {
117         allowed[msg.sender][_spender] = _value;
118         emit Approval(msg.sender, _spender, _value);
119         return true;
120     }
121 
122     function allowance(
123         address _owner,
124         address _spender
125     )
126     public
127     view
128     returns (uint256)
129     {
130         return allowed[_owner][_spender];
131     }
132 
133     function increaseApproval(
134         address _spender,
135         uint256 _addedValue
136     )
137     public
138     returns (bool)
139     {
140         allowed[msg.sender][_spender] = add(allowed[msg.sender][_spender], _addedValue);
141         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
142         return true;
143     }
144 
145     function decreaseApproval(
146         address _spender,
147         uint256 _subtractedValue
148     )
149     public
150     returns (bool)
151     {
152         uint256 oldValue = allowed[msg.sender][_spender];
153 
154         if (_subtractedValue > oldValue) {
155             allowed[msg.sender][_spender] = 0;
156         } 
157         else 
158         {
159             allowed[msg.sender][_spender] = sub(oldValue, _subtractedValue);
160         }
161         
162         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163         return true;
164     }
165 
166     
167     // ========= 直投相关逻辑 ===============
168     bool public direct_drop_switch = true; // 是否开启直投 @eachvar
169     uint256 public direct_drop_rate = 200000000; // 兑换比例，注意这里是eth为单位，需要换算到wei @eachvar
170     address public direct_drop_address = 0xBe60a6e39Bd058198C8E56e6c708A9C70190f83b; // 用于发放直投代币的账户 @eachvar
171     address public direct_drop_withdraw_address = 0x64b33dB1Cc804e7CA51D9c21F132567923D7BA00; // 直投提现地址 @eachvar
172 
173     bool public direct_drop_range = true; // 是否启用直投有效期 @eachvar
174     uint256 public direct_drop_range_start = 1562921160; // 有效期开始 @eachvar
175     uint256 public direct_drop_range_end = 3803445960; // 有效期结束 @eachvar
176 
177     event TokenPurchase
178     (
179         address indexed purchaser,
180         address indexed beneficiary,
181         uint256 value,
182         uint256 amount
183     );
184 
185     // 支持为别人购买
186     function buyTokens( address _beneficiary ) 
187     public 
188     payable // 接收支付
189     returns (bool)
190     {
191         require(direct_drop_switch);
192         require(_beneficiary != address(0));
193 
194         // 检查有效期开关
195         if( direct_drop_range )
196         {
197             // 当前时间必须在有效期内
198             // solium-disable-next-line security/no-block-members
199             require(block.timestamp >= direct_drop_range_start && block.timestamp <= direct_drop_range_end);
200 
201         }
202         
203         // 计算根据兑换比例，应该转移的代币数量
204         // uint256 tokenAmount = mul(div(msg.value, 10**18), direct_drop_rate);
205         
206         uint256 tokenAmount = div(mul(msg.value,direct_drop_rate ), 10**18); //此处用 18次方，这是 wei to  ether 的换算，不是代币的，所以不用 decimals,先乘后除，否则可能为零
207         uint256 decimalsAmount = mul( 10**uint256(decimals), tokenAmount);
208         
209         // 首先检查代币发放账户余额
210         require
211         (
212             balances[direct_drop_address] >= decimalsAmount
213         );
214 
215         assert
216         (
217             decimalsAmount > 0
218         );
219 
220         
221         // 然后开始转账
222         uint256 all = add(balances[direct_drop_address], balances[_beneficiary]);
223 
224         balances[direct_drop_address] = sub(balances[direct_drop_address], decimalsAmount);
225 
226         // @lock
227         // 添加锁仓相关检查 
228         // solium-disable-next-line security/no-block-members
229         if(lockInfo[direct_drop_address].amount > 0 && block.timestamp < lockInfo[direct_drop_address].release_time)
230             require(balances[direct_drop_address] >= lockInfo[direct_drop_address].amount);
231 
232             
233 
234         balances[_beneficiary] = add(balances[_beneficiary], decimalsAmount);
235         
236         assert
237         (
238             all == add(balances[direct_drop_address], balances[_beneficiary])
239         );
240 
241         // 发送事件
242         emit TokenPurchase
243         (
244             msg.sender,
245             _beneficiary,
246             msg.value,
247             tokenAmount
248         );
249 
250         return true;
251 
252     } 
253     
254 
255      // ========= 空投相关逻辑 ===============
256     bool public air_drop_switch = true; // 是否开启空投 @eachvar
257     uint256 public air_drop_rate = 88888; // 赠送的代币枚数，这个其实不是rate，直接是数量 @eachvar
258     address public air_drop_address = 0xeCA9eEea4B0542514e35833Df15830dC0108Ea20; // 用于发放空投代币的账户 @eachvar
259     uint256 public air_drop_count = 0; // 每个账户可以参加的次数 @eachvar
260 
261     mapping(address => uint256) airdrop_times; // 用于记录参加次数的mapping
262 
263     bool public air_drop_range = true; // 是否启用空投有效期 @eachvar
264     uint256 public air_drop_range_start = 1562921160; // 有效期开始 @eachvar
265     uint256 public air_drop_range_end = 3803445960; // 有效期结束 @eachvar
266 
267     event TokenGiven
268     (
269         address indexed sender,
270         address indexed beneficiary,
271         uint256 value,
272         uint256 amount
273     );
274 
275     // 也可以帮别人领取
276     function airDrop( address _beneficiary ) 
277     public 
278     payable // 接收支付
279     returns (bool)
280     {
281         require(air_drop_switch);
282         require(_beneficiary != address(0));
283         // 检查有效期开关
284         if( air_drop_range )
285         {
286             // 当前时间必须在有效期内
287             // solium-disable-next-line security/no-block-members
288             require(block.timestamp >= air_drop_range_start && block.timestamp <= air_drop_range_end);
289 
290         }
291 
292         // 检查受益账户参与空投的次数
293         if( air_drop_count > 0 )
294         {
295             require
296             ( 
297                 airdrop_times[_beneficiary] <= air_drop_count 
298             );
299         }
300         
301         // 计算根据兑换比例，应该转移的代币数量
302         uint256 tokenAmount = air_drop_rate;
303         uint256 decimalsAmount = mul(10**uint256(decimals), tokenAmount);// 转移代币时还要乘以小数位
304         
305         // 首先检查代币发放账户余额
306         require
307         (
308             balances[air_drop_address] >= decimalsAmount
309         );
310 
311         assert
312         (
313             decimalsAmount > 0
314         );
315 
316         
317         
318         // 然后开始转账
319         uint256 all = add(balances[air_drop_address], balances[_beneficiary]);
320 
321         balances[air_drop_address] = sub(balances[air_drop_address], decimalsAmount);
322 
323         // @lock
324         // 添加锁仓相关检查 
325         // solium-disable-next-line security/no-block-members
326         if(lockInfo[air_drop_address].amount > 0 && block.timestamp < lockInfo[air_drop_address].release_time)
327             require(balances[air_drop_address] >= lockInfo[air_drop_address].amount);
328         
329         balances[_beneficiary] = add(balances[_beneficiary], decimalsAmount);
330         
331         assert
332         (
333             all == add(balances[air_drop_address], balances[_beneficiary])
334         );
335 
336         // 发送事件
337         emit TokenGiven
338         (
339             msg.sender,
340             _beneficiary,
341             msg.value,
342             tokenAmount
343         );
344 
345         return true;
346 
347     }
348     
349     // ========== 代码销毁相关逻辑 ================
350     event Burn(address indexed burner, uint256 value);
351 
352     function burn(uint256 _value) public 
353     {
354         _burn(msg.sender, _value);
355     }
356 
357     function _burn(address _who, uint256 _value) internal 
358     {
359         require(_value <= balances[_who]);
360         
361         balances[_who] = sub(balances[_who], _value);
362 
363         //@lock
364         // 添加锁仓相关检查 
365         // solium-disable-next-line security/no-block-members
366         if(lockInfo[_who].amount > 0 && block.timestamp < lockInfo[_who].release_time)
367             require(balances[_who] >= lockInfo[_who].amount);
368             
369 
370         totalSupply = sub(totalSupply, _value);
371         emit Burn(_who, _value);
372         emit Transfer(_who, address(0), _value);
373     }
374     
375     //@lock
376     // ========== 锁仓相关逻辑 ================
377     // 定义锁仓信息
378     struct LockAccount 
379     {
380         // address account ; // 锁仓地址
381         uint256 amount ; // 锁定数额
382         uint256 release_time ; // 释放时间
383     }
384 
385     mapping(address => LockAccount) public lockInfo;
386 
387     // 这是一个内部函数，供构造函数添加锁仓账户用
388     function _add_lock_account(address _lock_address, uint256 _amount, uint256 _release_time) internal
389     {
390         // 添加锁仓账户
391         // 只在该地址的锁定额度为0时进行添加，确保锁仓地址不能被修改（即使是管理员也不能）
392         if( lockInfo[_lock_address].amount == 0 )
393             lockInfo[_lock_address] = LockAccount( _amount , _release_time);
394     }
395     
396     // ============== admin 相关函数 ==================
397     modifier admin_only()
398     {
399         require(msg.sender==admin_address);
400         _;
401     }
402 
403     function setAdmin( address new_admin_address ) 
404     public 
405     admin_only 
406     returns (bool)
407     {
408         require(new_admin_address != address(0));
409         admin_address = new_admin_address;
410         return true;
411     }
412 
413     // 空投管理
414     function setAirDrop( bool status )
415     public
416     admin_only
417     returns (bool)
418     {
419         air_drop_switch = status;
420         return true;
421     }
422     
423     // 直投管理
424     function setDirectDrop( bool status )
425     public
426     admin_only
427     returns (bool)
428     {
429         direct_drop_switch = status;
430         return true;
431     }
432     
433     // ETH提现
434     function withDraw()
435     public
436     {
437         // 管理员和之前设定的提现账号可以发起提现，但钱一定是进提现账号
438         require(msg.sender == admin_address || msg.sender == direct_drop_withdraw_address);
439         require(address(this).balance > 0);
440         // 全部转到直投提现中
441         direct_drop_withdraw_address.transfer(address(this).balance);
442     }
443         // ======================================
444     /// 默认函数
445     function () external payable
446     {
447                         if( msg.value > 0 )
448             buyTokens(msg.sender);
449         else
450             airDrop(msg.sender); 
451         
452         
453         
454            
455     }
456 
457     // ========== 公用函数 ===============
458     // 主要就是 safemath
459     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) 
460     {
461         if (a == 0) 
462         {
463             return 0;
464         }
465 
466         c = a * b;
467         assert(c / a == b);
468         return c;
469     }
470 
471     function div(uint256 a, uint256 b) internal pure returns (uint256) 
472     {
473         return a / b;
474     }
475 
476     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
477     {
478         assert(b <= a);
479         return a - b;
480     }
481 
482     function add(uint256 a, uint256 b) internal pure returns (uint256 c) 
483     {
484         c = a + b;
485         assert(c >= a);
486         return c;
487     }
488 
489 }