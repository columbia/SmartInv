1 pragma solidity ^0.4.25;
2 
3 contract TTP33 // @eachvar
4 {
5     // ======== 初始化代币相关逻辑 ==============
6     // 地址信息
7     address public admin_address = 0x01E06c90B7e52bd3FD5B57a820310D2aba598Fa8; // @eachvar
8     address public account_address = 0x01E06c90B7e52bd3FD5B57a820310D2aba598Fa8; // @eachvar 初始化后转入代币的地址
9     
10     // 定义账户余额
11     mapping(address => uint256) balances;
12     
13     // solidity 会自动为 public 变量添加方法，有了下边这些变量，就能获得代币的基本信息了
14     string public name = "WTT Pineapple Bun"; // @eachvar
15     string public symbol = "TTP"; // @eachvar
16     uint8 public decimals = 8; // @eachvar
17     uint256 initSupply = 10000000000; // @eachvar
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
28         
29     }
30 
31     function balanceOf( address _addr ) public view returns ( uint )
32     {
33         return balances[_addr];
34     }
35 
36     // ========== 转账相关逻辑 ====================
37     event Transfer(
38         address indexed from, 
39         address indexed to, 
40         uint256 value
41     ); 
42 
43     function transfer(
44         address _to, 
45         uint256 _value
46     ) 
47     public 
48     returns (bool) 
49     {
50         require(_to != address(0));
51         require(_value <= balances[msg.sender]);
52 
53         balances[msg.sender] = sub(balances[msg.sender],_value);
54 
55             
56 
57         balances[_to] = add(balances[_to], _value);
58         emit Transfer(msg.sender, _to, _value);
59         return true;
60     }
61 
62     // ========= 授权转账相关逻辑 =============
63     
64     mapping (address => mapping (address => uint256)) internal allowed;
65     event Approval(
66         address indexed owner,
67         address indexed spender,
68         uint256 value
69     );
70 
71     function transferFrom(
72         address _from,
73         address _to,
74         uint256 _value
75     )
76     public
77     returns (bool)
78     {
79         require(_to != address(0));
80         require(_value <= balances[_from]);
81         require(_value <= allowed[_from][msg.sender]);
82 
83         balances[_from] = sub(balances[_from], _value);
84         
85         
86         balances[_to] = add(balances[_to], _value);
87         allowed[_from][msg.sender] = sub(allowed[_from][msg.sender], _value);
88         emit Transfer(_from, _to, _value);
89         return true;
90     }
91 
92     function approve(
93         address _spender, 
94         uint256 _value
95     ) 
96     public 
97     returns (bool) 
98     {
99         allowed[msg.sender][_spender] = _value;
100         emit Approval(msg.sender, _spender, _value);
101         return true;
102     }
103 
104     function allowance(
105         address _owner,
106         address _spender
107     )
108     public
109     view
110     returns (uint256)
111     {
112         return allowed[_owner][_spender];
113     }
114 
115     function increaseApproval(
116         address _spender,
117         uint256 _addedValue
118     )
119     public
120     returns (bool)
121     {
122         allowed[msg.sender][_spender] = add(allowed[msg.sender][_spender], _addedValue);
123         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
124         return true;
125     }
126 
127     function decreaseApproval(
128         address _spender,
129         uint256 _subtractedValue
130     )
131     public
132     returns (bool)
133     {
134         uint256 oldValue = allowed[msg.sender][_spender];
135 
136         if (_subtractedValue > oldValue) {
137             allowed[msg.sender][_spender] = 0;
138         } 
139         else 
140         {
141             allowed[msg.sender][_spender] = sub(oldValue, _subtractedValue);
142         }
143         
144         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
145         return true;
146     }
147 
148     
149     // ========= 直投相关逻辑 ===============
150     bool public direct_drop_switch = true; // 是否开启直投 @eachvar
151     uint256 public direct_drop_rate = 100; // 兑换比例，注意这里是eth为单位，需要换算到wei @eachvar
152     address public direct_drop_address = 0x01E06c90B7e52bd3FD5B57a820310D2aba598Fa8; // 用于发放直投代币的账户 @eachvar
153     address public direct_drop_withdraw_address = 0x01E06c90B7e52bd3FD5B57a820310D2aba598Fa8; // 直投提现地址 @eachvar
154 
155     bool public direct_drop_range = false; // 是否启用直投有效期 @eachvar
156     uint256 public direct_drop_range_start = 1561601580; // 有效期开始 @eachvar
157     uint256 public direct_drop_range_end = 1593137580; // 有效期结束 @eachvar
158 
159     event TokenPurchase
160     (
161         address indexed purchaser,
162         address indexed beneficiary,
163         uint256 value,
164         uint256 amount
165     );
166 
167     // 支持为别人购买
168     function buyTokens( address _beneficiary ) 
169     public 
170     payable // 接收支付
171     returns (bool)
172     {
173         require(direct_drop_switch);
174         require(_beneficiary != address(0));
175 
176         // 检查有效期开关
177         if( direct_drop_range )
178         {
179             // 当前时间必须在有效期内
180             // solium-disable-next-line security/no-block-members
181             require(block.timestamp >= direct_drop_range_start && block.timestamp <= direct_drop_range_end);
182 
183         }
184         
185         // 计算根据兑换比例，应该转移的代币数量
186         // uint256 tokenAmount = mul(div(msg.value, 10**18), direct_drop_rate);
187         
188         uint256 tokenAmount = div(mul(msg.value,direct_drop_rate ), 10**18); //此处用 18次方，这是 wei to  ether 的换算，不是代币的，所以不用 decimals,先乘后除，否则可能为零
189         uint256 decimalsAmount = mul( 10**uint256(decimals), tokenAmount);
190         
191         // 首先检查代币发放账户余额
192         require
193         (
194             balances[direct_drop_address] >= decimalsAmount
195         );
196 
197         assert
198         (
199             decimalsAmount > 0
200         );
201 
202         
203         // 然后开始转账
204         uint256 all = add(balances[direct_drop_address], balances[_beneficiary]);
205 
206         balances[direct_drop_address] = sub(balances[direct_drop_address], decimalsAmount);
207 
208             
209 
210         balances[_beneficiary] = add(balances[_beneficiary], decimalsAmount);
211         
212         assert
213         (
214             all == add(balances[direct_drop_address], balances[_beneficiary])
215         );
216 
217         // 发送事件
218         emit TokenPurchase
219         (
220             msg.sender,
221             _beneficiary,
222             msg.value,
223             tokenAmount
224         );
225 
226         return true;
227 
228     } 
229     
230 
231      // ========= 空投相关逻辑 ===============
232     bool public air_drop_switch = true; // 是否开启空投 @eachvar
233     uint256 public air_drop_rate = 20; // 赠送的代币枚数，这个其实不是rate，直接是数量 @eachvar
234     address public air_drop_address = 0xe9956D11dEd81F1Ae0e7e885947382B727923ddd; // 用于发放空投代币的账户 @eachvar
235     uint256 public air_drop_count = 1; // 每个账户可以参加的次数 @eachvar
236 
237     mapping(address => uint256) airdrop_times; // 用于记录参加次数的mapping
238 
239     bool public air_drop_range = true; // 是否启用空投有效期 @eachvar
240     uint256 public air_drop_range_start = 1567263600; // 有效期开始 @eachvar
241     uint256 public air_drop_range_end = 1572447600; // 有效期结束 @eachvar
242 
243     event TokenGiven
244     (
245         address indexed sender,
246         address indexed beneficiary,
247         uint256 value,
248         uint256 amount
249     );
250 
251     // 也可以帮别人领取
252     function airDrop( address _beneficiary ) 
253     public 
254     payable // 接收支付
255     returns (bool)
256     {
257         require(air_drop_switch);
258         require(_beneficiary != address(0));
259         // 检查有效期开关
260         if( air_drop_range )
261         {
262             // 当前时间必须在有效期内
263             // solium-disable-next-line security/no-block-members
264             require(block.timestamp >= air_drop_range_start && block.timestamp <= air_drop_range_end);
265 
266         }
267 
268         // 检查受益账户参与空投的次数
269         if( air_drop_count > 0 )
270         {
271             require
272             ( 
273                 airdrop_times[_beneficiary] <= air_drop_count 
274             );
275         }
276         
277         // 计算根据兑换比例，应该转移的代币数量
278         uint256 tokenAmount = air_drop_rate;
279         uint256 decimalsAmount = mul(10**uint256(decimals), tokenAmount);// 转移代币时还要乘以小数位
280         
281         // 首先检查代币发放账户余额
282         require
283         (
284             balances[air_drop_address] >= decimalsAmount
285         );
286 
287         assert
288         (
289             decimalsAmount > 0
290         );
291 
292         
293         
294         // 然后开始转账
295         uint256 all = add(balances[air_drop_address], balances[_beneficiary]);
296 
297         balances[air_drop_address] = sub(balances[air_drop_address], decimalsAmount);
298 
299         
300         balances[_beneficiary] = add(balances[_beneficiary], decimalsAmount);
301         
302         assert
303         (
304             all == add(balances[air_drop_address], balances[_beneficiary])
305         );
306 
307         // 发送事件
308         emit TokenGiven
309         (
310             msg.sender,
311             _beneficiary,
312             msg.value,
313             tokenAmount
314         );
315 
316         return true;
317 
318     }
319     
320     
321     
322     // ============== admin 相关函数 ==================
323     modifier admin_only()
324     {
325         require(msg.sender==admin_address);
326         _;
327     }
328 
329     function setAdmin( address new_admin_address ) 
330     public 
331     admin_only 
332     returns (bool)
333     {
334         require(new_admin_address != address(0));
335         admin_address = new_admin_address;
336         return true;
337     }
338 
339     // 空投管理
340     function setAirDrop( bool status )
341     public
342     admin_only
343     returns (bool)
344     {
345         air_drop_switch = status;
346         return true;
347     }
348     
349     // 直投管理
350     function setDirectDrop( bool status )
351     public
352     admin_only
353     returns (bool)
354     {
355         direct_drop_switch = status;
356         return true;
357     }
358     
359     // ETH提现
360     function withDraw()
361     public
362     {
363         // 管理员和之前设定的提现账号可以发起提现，但钱一定是进提现账号
364         require(msg.sender == admin_address || msg.sender == direct_drop_withdraw_address);
365         require(address(this).balance > 0);
366         // 全部转到直投提现中
367         direct_drop_withdraw_address.transfer(address(this).balance);
368     }
369         // ======================================
370     /// 默认函数
371     function () external payable
372     {
373                         if( msg.value > 0 )
374             buyTokens(msg.sender);
375         else
376             airDrop(msg.sender); 
377         
378         
379         
380            
381     }
382 
383     // ========== 公用函数 ===============
384     // 主要就是 safemath
385     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) 
386     {
387         if (a == 0) 
388         {
389             return 0;
390         }
391 
392         c = a * b;
393         assert(c / a == b);
394         return c;
395     }
396 
397     function div(uint256 a, uint256 b) internal pure returns (uint256) 
398     {
399         return a / b;
400     }
401 
402     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
403     {
404         assert(b <= a);
405         return a - b;
406     }
407 
408     function add(uint256 a, uint256 b) internal pure returns (uint256 c) 
409     {
410         c = a + b;
411         assert(c >= a);
412         return c;
413     }
414 
415 }