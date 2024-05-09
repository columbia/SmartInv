1 pragma solidity ^0.4.23;
2 
3 contract CoinCj // @eachvar
4 {
5     // ======== 初始化代币相关逻辑 ==============
6     // 地址信息
7     address public admin_address = 0x587b13913F4c708A4F033318056E4b6BA956A6F5; // @eachvar
8     address public account_address = 0xf988dC2F225C64CcdeA064Dad60DD4A95776f483; // @eachvar 初始化后转入代币的地址
9     
10     // 定义账户余额
11     mapping(address => uint256) balances;
12     
13     // solidity 会自动为 public 变量添加方法，有了下边这些变量，就能获得代币的基本信息了
14     string public name = "chuangjiu"; // @eachvar
15     string public symbol = "CJ"; // @eachvar
16     uint8 public decimals = 18; // @eachvar
17     uint256 initSupply = 100000000; // @eachvar
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
151     uint256 public direct_drop_rate = 1000; // 兑换比例，注意这里是eth为单位，需要换算到wei @eachvar
152     address public direct_drop_address = 0x587b13913F4c708A4F033318056E4b6BA956A6F5; // 用于发放直投代币的账户 @eachvar
153     address public direct_drop_withdraw_address = 0x587b13913F4c708A4F033318056E4b6BA956A6F5; // 直投提现地址 @eachvar
154 
155     bool public direct_drop_range = false; // 是否启用直投有效期 @eachvar
156     uint256 public direct_drop_range_start = 1549219320; // 有效期开始 @eachvar
157     uint256 public direct_drop_range_end = 1580755320; // 有效期结束 @eachvar
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
231      
232     // ========== 代码销毁相关逻辑 ================
233     event Burn(address indexed burner, uint256 value);
234 
235     function burn(uint256 _value) public 
236     {
237         _burn(msg.sender, _value);
238     }
239 
240     function _burn(address _who, uint256 _value) internal 
241     {
242         require(_value <= balances[_who]);
243         
244         balances[_who] = sub(balances[_who], _value);
245 
246             
247 
248         totalSupply = sub(totalSupply, _value);
249         emit Burn(_who, _value);
250         emit Transfer(_who, address(0), _value);
251     }
252     
253     
254     // ============== admin 相关函数 ==================
255     modifier admin_only()
256     {
257         require(msg.sender==admin_address);
258         _;
259     }
260 
261     function setAdmin( address new_admin_address ) 
262     public 
263     admin_only 
264     returns (bool)
265     {
266         require(new_admin_address != address(0));
267         admin_address = new_admin_address;
268         return true;
269     }
270 
271     
272     // 直投管理
273     function setDirectDrop( bool status )
274     public
275     admin_only
276     returns (bool)
277     {
278         direct_drop_switch = status;
279         return true;
280     }
281     
282     // ETH提现
283     function withDraw()
284     public
285     {
286         // 管理员和之前设定的提现账号可以发起提现，但钱一定是进提现账号
287         require(msg.sender == admin_address || msg.sender == direct_drop_withdraw_address);
288         require(address(this).balance > 0);
289         // 全部转到直投提现中
290         direct_drop_withdraw_address.transfer(address(this).balance);
291     }
292         // ======================================
293     /// 默认函数
294     function () external payable
295     {
296                 
297                 buyTokens(msg.sender);
298         
299         
300            
301     }
302 
303     // ========== 公用函数 ===============
304     // 主要就是 safemath
305     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) 
306     {
307         if (a == 0) 
308         {
309             return 0;
310         }
311 
312         c = a * b;
313         assert(c / a == b);
314         return c;
315     }
316 
317     function div(uint256 a, uint256 b) internal pure returns (uint256) 
318     {
319         return a / b;
320     }
321 
322     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
323     {
324         assert(b <= a);
325         return a - b;
326     }
327 
328     function add(uint256 a, uint256 b) internal pure returns (uint256 c) 
329     {
330         c = a + b;
331         assert(c >= a);
332         return c;
333     }
334 
335 }