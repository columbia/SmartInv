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
52      * @param initialSupplyHM 初始总量（单位百万）
53      * @param tokenName Token 名称
54      * @param tokenSymbol Token 符号
55      * @param tokenDecimals Token 小数位
56      */
57     constructor(uint256 initialSupplyHM, string tokenName, string tokenSymbol, uint8 tokenDecimals) public {
58         name = tokenName;
59         symbol = tokenSymbol;
60         decimals = tokenDecimals;
61         totalSupply = initialSupplyHM * 100 * 10000 * 10 ** uint256(decimals);
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
81 		uint256 tm = _supplyTM * 1000 * 10000 * 10 ** uint256(decimals);
82         totalSupply += tm;
83         balanceOf[msg.sender] += tm;
84         emit Offer(_supplyTM);
85         return true;
86     }
87 
88     /**
89      * 转移合约所有者
90      * @param _newOwner 新合约所有者地址
91      */
92     function transferOwnership(address _newOwner) onlyOwner public returns (bool success){
93         require(owner != _newOwner, "无效合约新所有者");
94         newOwner = _newOwner;
95         return true;
96     }
97     
98     /**
99      * 接受并成为新的合约所有者
100      */
101     function acceptOwnership() public returns (bool success){
102         require(msg.sender == newOwner && newOwner != 0x0, "无效合约新所有者");
103         address oldOwner = owner;
104         owner = newOwner;
105         newOwner = 0x0;
106         emit OwnerChanged(oldOwner, owner);
107         return true;
108     }
109 
110     /**
111      * 设定合约锁定状态
112      * @param _lockAll 状态
113      */
114     function setLockAll(bool _lockAll) onlyOwner public returns (bool success){
115         lockAll = _lockAll;
116         return true;
117     }
118 
119     /**
120      * 设定账户冻结状态
121      * @param _target 冻结目标
122      * @param _freeze 冻结状态
123      */
124     function setFreezeAddress(address _target, bool _freeze) onlyOwner public returns (bool success){
125         frozens[_target] = _freeze;
126         emit FreezeAddress(_target, _freeze);
127         return true;
128     }
129 
130     /**
131      * 从持有方转移指定数量的 Token 给接收方
132      * @param _from 持有方
133      * @param _to 接收方
134      * @param _value 数量
135      */
136     function _transfer(address _from, address _to, uint256 _value) internal {
137         //- 锁定校验
138         require(!lockAll, "合约处于锁定状态");
139         //- 地址有效验证
140         require(_to != 0x0, "无效接收地址");
141         //- 余额验证
142         require(balanceOf[_from] >= _value, "持有方转移数量不足");
143         //- 持有方冻结校验
144         require(!frozens[_from], "持有方处于冻结状态"); 
145         //- 接收方冻结校验
146         //require(!frozenAccount[_to]); 
147 
148         //- 保存预校验总量
149         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
150         //- 持有方减少代币
151         balanceOf[_from] -= _value;
152         //- 接收方增加代币
153         balanceOf[_to] += _value;
154         //- 触发转账事件
155 		emit Transfer(_from, _to, _value);
156 
157         //- 确保交易过后，持有方和接收方持有总量不变
158         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
159     }
160 
161     /**
162      * 转移转指定数量的 Token 给接收方
163      *
164      * @param _to 接收方地址
165      * @param _value 数量
166      */
167     function transfer(address _to, uint256 _value) public returns (bool success) {
168         _transfer(msg.sender, _to, _value);
169         return true;
170     }
171 	
172     /**
173      * 转移转指定数量的 Token 给接收方，并包括扩展数据（该方法将会触发两个事件）
174      *
175      * @param _to 接收方地址
176      * @param _value 数量
177      * @param _extraData 扩展数据
178      */
179     function transferExtra(address _to, uint256 _value, bytes _extraData) public returns (bool success) {
180         _transfer(msg.sender, _to, _value);
181 		emit TransferExtra(msg.sender, _to, _value, _extraData);
182         return true;
183     }
184 
185     /**
186      * 从持有方转移指定数量的 Token 给接收方
187      *
188      * @param _from 持有方
189      * @param _to 接收方
190      * @param _value 数量
191      */
192     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
193         //- 授权额度校验
194         require(_value <= allowance[_from][msg.sender], "授权额度不足");
195 
196         allowance[_from][msg.sender] -= _value;
197         _transfer(_from, _to, _value);
198         return true;
199     }
200 
201     /**
202      * 授权指定地址的转移额度
203      *
204      * @param _spender 代理方
205      * @param _value 授权额度
206      */
207     function approve(address _spender, uint256 _value) public returns (bool success) {
208         allowance[msg.sender][_spender] = _value;
209         emit Approval(msg.sender, _spender, _value);
210         return true;
211     }
212 
213     /**
214      * 授权指定地址的转移额度，并通知代理方合约
215      *
216      * @param _spender 代理方
217      * @param _value 转账最高额度
218      * @param _extraData 扩展数据（传递给代理方合约）
219      */
220     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
221         tokenRecipient spender = tokenRecipient(_spender);//- 代理方合约
222         if (approve(_spender, _value)) {
223             spender.receiveApproval(msg.sender, _value, this, _extraData);
224             return true;
225         }
226     }
227 
228     function _burn(address _from, uint256 _value) internal {
229         //- 锁定校验
230         require(!lockAll, "合约处于锁定状态");
231         //- 余额验证
232         require(balanceOf[_from] >= _value, "持有方余额不足");
233         //- 冻结校验
234         require(!frozens[_from], "持有方处于冻结状态"); 
235 
236         //- 消耗 Token
237         balanceOf[_from] -= _value;
238         //- 总量下调
239         totalSupply -= _value;
240 
241         emit Burn(_from, _value);
242     }
243 
244     /**
245      * 消耗指定数量的 Token
246      *
247      * @param _value 消耗数量
248      */
249     function burn(uint256 _value) public returns (bool success) {
250 
251         _burn(msg.sender, _value);
252         return true;
253     }
254 
255     /**
256      * 消耗持有方授权额度内指定数量的 Token
257      *
258      * @param _from 持有方
259      * @param _value 消耗数量
260      */
261     function burnFrom(address _from, uint256 _value) public returns (bool success) {
262         //- 授权额度校验
263         require(_value <= allowance[_from][msg.sender], "授权额度不足");
264       
265         allowance[_from][msg.sender] -= _value;
266 
267         _burn(_from, _value);
268         return true;
269     }
270 
271     function() payable public{
272     }
273 }