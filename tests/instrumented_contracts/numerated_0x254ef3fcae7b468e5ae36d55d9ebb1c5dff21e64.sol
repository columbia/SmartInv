1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 /**
6  * 标准 ERC-20-2 合约
7  */
8 contract ERC_20_2 {
9     //- Token 名称
10     string public name; 
11     //- Token 符号
12     string public symbol;
13     //- Token 小数位
14     uint8 public decimals;
15     //- Token 总发行量
16     uint256 public totalSupply;
17     //- 合约锁定状态
18     bool public lockAll = false;
19     //- 合约创造者
20     address public creator;
21     //- 合约所有者
22     address public owner;
23     //- 合约新所有者
24     address internal newOwner = 0x0;
25 
26     //- 地址映射关系
27     mapping (address => uint256) public balanceOf;
28     //- 地址对应 Token
29     mapping (address => mapping (address => uint256)) public allowance;
30     //- 冻结列表
31     mapping (address => bool) public frozens;
32 
33     //- Token 交易通知事件
34     event Transfer(address indexed _from, address indexed _to, uint256 _value);
35     //- Token 交易扩展通知事件
36     event TransferExtra(address indexed _from, address indexed _to, uint256 _value, bytes _extraData);
37     //- Token 批准通知事件
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39     //- Token 消耗通知事件
40     event Burn(address indexed _from, uint256 _value);
41     //- Token 增量通知事件
42     event Offer(uint256 _supplyTM);
43     //- 合约所有者变更通知
44     event OwnerChanged(address _oldOwner, address _newOwner);
45     //- 地址冻结通知
46     event FreezeAddress(address indexed _target, bool _frozen);
47 
48     /**
49      * 构造函数
50      *
51      * 初始化一个合约
52      * @param initialSupplyHM 初始总量（单位亿）
53      * @param tokenName Token 名称
54      * @param tokenSymbol Token 符号
55      * @param tokenDecimals Token 小数位
56      */
57     constructor(uint256 initialSupplyHM, string tokenName, string tokenSymbol, uint8 tokenDecimals) public {
58         name = tokenName;
59         symbol = tokenSymbol;
60         decimals = tokenDecimals;
61         totalSupply = initialSupplyHM * 10000 * 10000 * 10 ** uint256(decimals);
62         
63         balanceOf[msg.sender] = totalSupply;
64         owner = msg.sender;
65         creator = msg.sender;
66     }
67 
68     /**
69      * 所有者修饰符
70      */
71     modifier onlyOwner {
72         require(msg.sender == owner, "非法合约执行者");
73         _;
74     }
75 	
76     /**
77      * 增加发行量
78      * @param _supplyTM 增量（单位千万）
79      */
80     function offer(uint256 _supplyTM) onlyOwner public returns (bool success){
81         //- 非负数验证
82         require(_supplyTM > 0, "无效数量");
83 		uint256 tm = _supplyTM * 1000 * 10000 * 10 ** uint256(decimals);
84         totalSupply += tm;
85         balanceOf[msg.sender] += tm;
86         emit Offer(_supplyTM);
87         return true;
88     }
89 
90     /**
91      * 转移合约所有者
92      * @param _newOwner 新合约所有者地址
93      */
94     function transferOwnership(address _newOwner) onlyOwner public returns (bool success){
95         require(owner != _newOwner, "无效合约新所有者");
96         newOwner = _newOwner;
97         return true;
98     }
99     
100     /**
101      * 接受并成为新的合约所有者
102      */
103     function acceptOwnership() public returns (bool success){
104         require(msg.sender == newOwner && newOwner != 0x0, "无效合约新所有者");
105         address oldOwner = owner;
106         owner = newOwner;
107         newOwner = 0x0;
108         emit OwnerChanged(oldOwner, owner);
109         return true;
110     }
111 
112     /**
113      * 设定合约锁定状态
114      * @param _lockAll 状态
115      */
116     function setLockAll(bool _lockAll) onlyOwner public returns (bool success){
117         lockAll = _lockAll;
118         return true;
119     }
120 
121     /**
122      * 设定账户冻结状态
123      * @param _target 冻结目标
124      * @param _freeze 冻结状态
125      */
126     function setFreezeAddress(address _target, bool _freeze) onlyOwner public returns (bool success){
127         frozens[_target] = _freeze;
128         emit FreezeAddress(_target, _freeze);
129         return true;
130     }
131 
132     /**
133      * 从持有方转移指定数量的 Token 给接收方
134      * @param _from 持有方
135      * @param _to 接收方
136      * @param _value 数量
137      */
138     function _transfer(address _from, address _to, uint256 _value) internal {
139         //- 锁定校验
140         require(!lockAll, "合约处于锁定状态");
141         //- 地址有效验证
142         require(_to != 0x0, "无效接收地址");
143         //- 非负数验证
144         require(_value > 0, "无效数量");
145         //- 余额验证
146         require(balanceOf[_from] >= _value, "持有方转移数量不足");
147         //- 持有方冻结校验
148         require(!frozens[_from], "持有方处于冻结状态"); 
149         //- 接收方冻结校验
150         //require(!frozenAccount[_to]); 
151 
152         //- 保存预校验总量
153         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
154         //- 持有方减少代币
155         balanceOf[_from] -= _value;
156         //- 接收方增加代币
157         balanceOf[_to] += _value;
158         //- 触发转账事件
159 		emit Transfer(_from, _to, _value);
160 
161         //- 确保交易过后，持有方和接收方持有总量不变
162         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
163     }
164 
165     /**
166      * 转移转指定数量的 Token 给接收方
167      *
168      * @param _to 接收方地址
169      * @param _value 数量
170      */
171     function transfer(address _to, uint256 _value) public returns (bool success) {
172         _transfer(msg.sender, _to, _value);
173         return true;
174     }
175 	
176     /**
177      * 转移转指定数量的 Token 给接收方，并包括扩展数据（该方法将会触发两个事件）
178      *
179      * @param _to 接收方地址
180      * @param _value 数量
181      * @param _extraData 扩展数据
182      */
183     function transferExtra(address _to, uint256 _value, bytes _extraData) public returns (bool success) {
184         _transfer(msg.sender, _to, _value);
185 		emit TransferExtra(msg.sender, _to, _value, _extraData);
186         return true;
187     }
188 
189     /**
190      * 从持有方转移指定数量的 Token 给接收方
191      *
192      * @param _from 持有方
193      * @param _to 接收方
194      * @param _value 数量
195      */
196     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
197         //- 授权额度校验
198         require(_value <= allowance[_from][msg.sender], "授权额度不足");
199 
200         allowance[_from][msg.sender] -= _value;
201         _transfer(_from, _to, _value);
202         return true;
203     }
204 
205     /**
206      * 授权指定地址的转移额度
207      *
208      * @param _spender 代理方
209      * @param _value 授权额度
210      */
211     function approve(address _spender, uint256 _value) public returns (bool success) {
212         allowance[msg.sender][_spender] = _value;
213         emit Approval(msg.sender, _spender, _value);
214         return true;
215     }
216 
217     /**
218      * 授权指定地址的转移额度，并通知代理方合约
219      *
220      * @param _spender 代理方
221      * @param _value 转账最高额度
222      * @param _extraData 扩展数据（传递给代理方合约）
223      */
224     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
225         tokenRecipient spender = tokenRecipient(_spender);//- 代理方合约
226         if (approve(_spender, _value)) {
227             spender.receiveApproval(msg.sender, _value, this, _extraData);
228             return true;
229         }
230     }
231 
232     function _burn(address _from, uint256 _value) internal {
233         //- 锁定校验
234         require(!lockAll, "合约处于锁定状态");
235         //- 余额验证
236         require(balanceOf[_from] >= _value, "持有方余额不足");
237         //- 冻结校验
238         require(!frozens[_from], "持有方处于冻结状态"); 
239 
240         //- 消耗 Token
241         balanceOf[_from] -= _value;
242         //- 总量下调
243         totalSupply -= _value;
244 
245         emit Burn(_from, _value);
246     }
247 
248     /**
249      * 消耗指定数量的 Token
250      *
251      * @param _value 消耗数量
252      */
253     function burn(uint256 _value) public returns (bool success) {
254         //- 非负数验证
255         require(_value > 0, "无效数量");
256 
257         _burn(msg.sender, _value);
258         return true;
259     }
260 
261     /**
262      * 消耗持有方授权额度内指定数量的 Token
263      *
264      * @param _from 持有方
265      * @param _value 消耗数量
266      */
267     function burnFrom(address _from, uint256 _value) public returns (bool success) {
268         //- 授权额度校验
269         require(_value <= allowance[_from][msg.sender], "授权额度不足");
270         //- 非负数验证
271         require(_value > 0, "无效数量");
272       
273         allowance[_from][msg.sender] -= _value;
274 
275         _burn(_from, _value);
276         return true;
277     }
278 
279     function() payable public{
280     }
281 }