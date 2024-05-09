1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 /**
6  * 一个标准合约
7  */
8 contract StandardTokenERC20 {
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
35     //- Token 批准通知事件
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37     //- Token 消耗通知事件
38     event Burn(address indexed _from, uint256 _value);
39     //- 合约所有者变更通知
40     event OwnerChanged(address _oldOwner, address _newOwner);
41     //- 地址冻结通知
42     event FreezeAddress(address _target, bool _frozen);
43 
44     /**
45      * 构造函数
46      *
47      * 初始化一个合约
48      * @param initialSupplyHM 初始总量（单位亿）
49      * @param tokenName Token 名称
50      * @param tokenSymbol Token 符号
51      * @param tokenDecimals Token 小数位
52      * @param lockAllStatus Token 初始锁定状态
53      * @param defaultBalanceOwner Token 初始拥有者
54      */
55     constructor(uint256 initialSupplyHM, string tokenName, string tokenSymbol, uint8 tokenDecimals, bool lockAllStatus, address defaultBalanceOwner) public {
56         name = tokenName;
57         symbol = tokenSymbol;
58         decimals = tokenDecimals;
59         totalSupply = initialSupplyHM * 10000 * 10000 * 10 ** uint256(decimals);
60         if(defaultBalanceOwner == address(0)){
61             defaultBalanceOwner = msg.sender;
62         }
63         balanceOf[defaultBalanceOwner] = totalSupply;
64         owner = msg.sender;
65         creator = msg.sender;
66         lockAll = lockAllStatus;
67     }
68 
69     /**
70      * 所有者修饰符
71      */
72     modifier onlyOwner {
73         require(msg.sender == owner);
74         _;
75     }
76 
77     /**
78      * 转移合约所有者
79      * @param _newOwner 新合约所有者地址
80      */
81     function transferOwnership(address _newOwner) onlyOwner public {
82         require(owner != _newOwner);
83         newOwner = _newOwner;
84     }
85     
86     /**
87      * 接受并成为新的合约所有者
88      */
89     function acceptOwnership() public {
90         require(msg.sender == newOwner && newOwner != 0x0);
91         address oldOwner = owner;
92         owner = newOwner;
93         newOwner = 0x0;
94         emit OwnerChanged(oldOwner, owner);
95     }
96 
97     /**
98      * 设定合约锁定状态
99      * @param _lockAll 状态
100      */
101     function setLockAll(bool _lockAll) onlyOwner public {
102         lockAll = _lockAll;
103     }
104 
105     /**
106      * 设定账户冻结状态
107      * @param _target 冻结目标
108      * @param _freeze 冻结状态
109      */
110     function setFreezeAddress(address _target, bool _freeze) onlyOwner public {
111         frozens[_target] = _freeze;
112         emit FreezeAddress(_target, _freeze);
113     }
114 
115     /**
116      * 从持有方转移指定数量的 Token 给接收方
117      * @param _from 持有方
118      * @param _to 接收方
119      * @param _value 数量
120      */
121     function _transfer(address _from, address _to, uint256 _value) internal {
122         //- 锁定校验
123         require(!lockAll);
124         //- 地址有效验证
125         require(_to != 0x0);
126         //- 余额验证
127         require(balanceOf[_from] >= _value);
128         //- 非负数验证
129         require(balanceOf[_to] + _value >= balanceOf[_to]);
130         //- 持有方冻结校验
131         require(!frozens[_from]); 
132         //- 接收方冻结校验
133         //require(!frozenAccount[_to]); 
134 
135         //- 保存预校验总量
136         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
137         //- 持有方减少代币
138         balanceOf[_from] -= _value;
139         //- 接收方增加代币
140         balanceOf[_to] += _value;
141         //- 触发转账事件
142         emit Transfer(_from, _to, _value);
143         //- 确保交易过后，持有方和接收方持有总量不变
144         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
145     }
146 
147     /**
148      * 转移转指定数量的 Token 给接收方
149      *
150      * @param _to 接收方地址
151      * @param _value 数量
152      */
153     function transfer(address _to, uint256 _value) public returns (bool success) {
154         _transfer(msg.sender, _to, _value);
155         return true;
156     }
157 
158     /**
159      * 从持有方转移指定数量的 Token 给接收方
160      *
161      * @param _from 持有方
162      * @param _to 接收方
163      * @param _value 数量
164      */
165     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
166         //- 授权额度校验
167         require(_value <= allowance[_from][msg.sender]);
168 
169         allowance[_from][msg.sender] -= _value;
170         _transfer(_from, _to, _value);
171         return true;
172     }
173 
174     /**
175      * 授权指定地址的转移额度
176      *
177      * @param _spender 代理方
178      * @param _value 授权额度
179      */
180     function approve(address _spender, uint256 _value) public returns (bool success) {
181         allowance[msg.sender][_spender] = _value;
182         emit Approval(msg.sender, _spender, _value);
183         return true;
184     }
185 
186     /**
187      * 授权指定地址的转移额度，并通知代理方合约
188      *
189      * @param _spender 代理方
190      * @param _value 转账最高额度
191      * @param _extraData 扩展数据（传递给代理方合约）
192      */
193     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
194         tokenRecipient spender = tokenRecipient(_spender);//- 代理方合约
195         if (approve(_spender, _value)) {
196             spender.receiveApproval(msg.sender, _value, this, _extraData);
197             return true;
198         }
199     }
200 
201     function _burn(address _from, uint256 _value) internal {
202         //- 锁定校验
203         require(!lockAll);
204         //- 余额验证
205         require(balanceOf[_from] >= _value);
206         //- 冻结校验
207         require(!frozens[_from]); 
208 
209         //- 消耗 Token
210         balanceOf[_from] -= _value;
211         //- 总量下调
212         totalSupply -= _value;
213 
214         emit Burn(_from, _value);
215     }
216 
217     /**
218      * 消耗指定数量的 Token
219      *
220      * @param _value 消耗数量
221      */
222     function burn(uint256 _value) public returns (bool success) {
223         _burn(msg.sender, _value);
224         return true;
225     }
226 
227     /**
228      * 消耗持有方授权额度内指定数量的 Token
229      *
230      * @param _from 持有方
231      * @param _value 消耗数量
232      */
233     function burnFrom(address _from, uint256 _value) public returns (bool success) {
234         //- 授权额度校验
235         require(_value <= allowance[_from][msg.sender]);
236       
237         allowance[_from][msg.sender] -= _value;
238 
239         _burn(_from, _value);
240         return true;
241     }
242     
243     function() payable public{
244     }
245 }