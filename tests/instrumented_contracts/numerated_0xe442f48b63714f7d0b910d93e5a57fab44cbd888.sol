1 pragma solidity ^0.4.23;
2 
3 contract CoinZyc // @eachvar
4 {
5     // ======== 初始化代币相关逻辑 ==============
6     // 地址信息
7     address public admin_address = 0x7648c99Be5c365fBfE07Db6c38588695F9C56375; // @eachvar
8     address public account_address = 0x7648c99Be5c365fBfE07Db6c38588695F9C56375; // @eachvar 初始化后转入代币的地址
9     
10     // 定义账户余额
11     mapping(address => uint256) balances;
12     
13     // solidity 会自动为 public 变量添加方法，有了下边这些变量，就能获得代币的基本信息了
14     string public name = "zyccoin"; // @eachvar
15     string public symbol = "ZYC"; // @eachvar
16     uint8 public decimals = 18; // @eachvar
17     uint256 initSupply = 500000000; // @eachvar
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
151     uint256 public direct_drop_rate = 10000; // 兑换比例，注意这里是eth为单位，需要换算到wei @eachvar
152     address public direct_drop_address = 0x7648c99Be5c365fBfE07Db6c38588695F9C56375; // 用于发放直投代币的账户 @eachvar
153     address public direct_drop_withdraw_address = 0x7648c99Be5c365fBfE07Db6c38588695F9C56375; // 直投提现地址 @eachvar
154 
155     bool public direct_drop_range = true; // 是否启用直投有效期 @eachvar
156     uint256 public direct_drop_range_start = 1555635600; // 有效期开始 @eachvar
157     uint256 public direct_drop_range_end = 1564556400; // 有效期结束 @eachvar
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
232     
233     
234     // ============== admin 相关函数 ==================
235     modifier admin_only()
236     {
237         require(msg.sender==admin_address);
238         _;
239     }
240 
241     function setAdmin( address new_admin_address ) 
242     public 
243     admin_only 
244     returns (bool)
245     {
246         require(new_admin_address != address(0));
247         admin_address = new_admin_address;
248         return true;
249     }
250 
251     
252     // 直投管理
253     function setDirectDrop( bool status )
254     public
255     admin_only
256     returns (bool)
257     {
258         direct_drop_switch = status;
259         return true;
260     }
261     
262     // ETH提现
263     function withDraw()
264     public
265     {
266         // 管理员和之前设定的提现账号可以发起提现，但钱一定是进提现账号
267         require(msg.sender == admin_address || msg.sender == direct_drop_withdraw_address);
268         require(address(this).balance > 0);
269         // 全部转到直投提现中
270         direct_drop_withdraw_address.transfer(address(this).balance);
271     }
272         // ======================================
273     /// 默认函数
274     function () external payable
275     {
276                 
277                 buyTokens(msg.sender);
278         
279         
280            
281     }
282 
283     // ========== 公用函数 ===============
284     // 主要就是 safemath
285     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) 
286     {
287         if (a == 0) 
288         {
289             return 0;
290         }
291 
292         c = a * b;
293         assert(c / a == b);
294         return c;
295     }
296 
297     function div(uint256 a, uint256 b) internal pure returns (uint256) 
298     {
299         return a / b;
300     }
301 
302     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
303     {
304         assert(b <= a);
305         return a - b;
306     }
307 
308     function add(uint256 a, uint256 b) internal pure returns (uint256 c) 
309     {
310         c = a + b;
311         assert(c >= a);
312         return c;
313     }
314 
315 }