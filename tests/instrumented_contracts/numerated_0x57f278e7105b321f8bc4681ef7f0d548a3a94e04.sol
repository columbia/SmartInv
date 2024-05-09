1 pragma solidity 0.4.24;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 
6 /**
7  * @title TT代币合约
8  */
9 contract TrustTokenERC20 {
10     /* 公共变量 */
11     string public name; //代币名称
12     string public symbol; //代币符号比如'$'
13     uint8 public decimals = 18;  //代币单位，展示的小数点后面多少个0,和以太币一样后面是是18个0
14     uint256 public totalSupply; //代币总量
15 
16     /*记录所有余额的映射*/
17     mapping (address => uint256) public balanceOf;
18     mapping (address => mapping (address => uint256)) public allowance;
19 
20     /* 在区块链上创建一个事件，用以通知客户端*/
21     event Transfer(address indexed from, address indexed to, uint256 value);  //转帐通知事件
22     event Burn(address indexed from, uint256 value);  //减去用户余额事件
23 
24     /* 初始化合约，并且把初始的所有代币都给这合约的创建者
25      * @param initialSupply 代币的总数
26      * @param tokenName 代币名称
27      * @param tokenSymbol 代币符号
28      */
29     function TrustTokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
30 
31         //初始化总量
32         totalSupply = initialSupply * 10 ** uint256(decimals);    //以太币是10^18，后面18个0，所以默认decimals是18
33 
34         //给指定帐户初始化代币总量，初始化用于奖励合约创建者
35         balanceOf[msg.sender] = totalSupply;
36 
37         name = tokenName;
38         symbol = tokenSymbol;
39 
40     }
41 
42 
43     /**
44      * 私有方法从一个帐户发送给另一个帐户代币
45      * @param  _from address 发送代币的地址
46      * @param  _to address 接受代币的地址
47      * @param  _value uint256 接受代币的数量
48      */
49     function _transfer(address _from, address _to, uint256 _value) internal {
50 
51       //避免转帐的地址是0x0
52       require(_to != 0x0);
53 
54       //检查发送者是否拥有足够余额
55       require(balanceOf[_from] >= _value);
56 
57       //检查是否溢出
58       require(balanceOf[_to] + _value > balanceOf[_to]);
59 
60       //保存数据用于后面的判断
61       uint previousBalances = balanceOf[_from] + balanceOf[_to];
62 
63       //从发送者减掉发送额
64       balanceOf[_from] -= _value;
65 
66       //给接收者加上相同的量
67       balanceOf[_to] += _value;
68 
69       //通知任何监听该交易的客户端
70       Transfer(_from, _to, _value);
71 
72       //判断买、卖双方的数据是否和转换前一致
73       assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
74 
75     }
76 
77     /**
78      * 从主帐户合约调用者发送给别人代币
79      * @param  _to address 接受代币的地址
80      * @param  _value uint256 接受代币的数量
81      */
82     function transfer(address _to, uint256 _value) public {
83         _transfer(msg.sender, _to, _value);
84     }
85 
86     /**
87      * 从某个指定的帐户中，向另一个帐户发送代币
88      *
89      * 调用过程，会检查设置的允许最大交易额
90      *
91      * @param  _from address 发送者地址
92      * @param  _to address 接受者地址
93      * @param  _value uint256 要转移的代币数量
94      * @return success        是否交易成功
95      */
96     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
97         //检查发送者是否拥有足够余额
98         require(_value <= allowance[_from][msg.sender]);   // Check allowance
99 
100         allowance[_from][msg.sender] -= _value;
101 
102         _transfer(_from, _to, _value);
103 
104         return true;
105     }
106 
107     /**
108      * 设置帐户允许支付的最大金额
109      *
110      * 一般在智能合约的时候，避免支付过多，造成风险
111      *
112      * @param _spender 帐户地址
113      * @param _value 金额
114      */
115     function approve(address _spender, uint256 _value) public returns (bool success) {
116         allowance[msg.sender][_spender] = _value;
117         return true;
118     }
119 
120     /**
121      * 设置帐户允许支付的最大金额
122      *
123      * 一般在智能合约的时候，避免支付过多，造成风险，加入时间参数，可以在 tokenRecipient 中做其他操作
124      *
125      * @param _spender 帐户地址
126      * @param _value 金额
127      * @param _extraData 操作的时间
128      */
129     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
130         tokenRecipient spender = tokenRecipient(_spender);
131         if (approve(_spender, _value)) {
132             spender.receiveApproval(msg.sender, _value, this, _extraData);
133             return true;
134         }
135     }
136 
137     /**
138      * 减少代币调用者的余额
139      *
140      * 操作以后是不可逆的
141      *
142      * @param _value 要删除的数量
143      */
144     function burn(uint256 _value) public returns (bool success) {
145         //检查帐户余额是否大于要减去的值
146         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
147 
148         //给指定帐户减去余额
149         balanceOf[msg.sender] -= _value;
150 
151         //代币问题做相应扣除
152         totalSupply -= _value;
153 
154         Burn(msg.sender, _value);
155         return true;
156     }
157 
158     /**
159      * 删除帐户的余额（含其他帐户）
160      *
161      * 删除以后是不可逆的
162      *
163      * @param _from 要操作的帐户地址
164      * @param _value 要减去的数量
165      */
166     function burnFrom(address _from, uint256 _value) public returns (bool success) {
167 
168         //检查帐户余额是否大于要减去的值
169         require(balanceOf[_from] >= _value);
170 
171         //检查 其他帐户 的余额是否够使用
172         require(_value <= allowance[_from][msg.sender]);
173 
174         //减掉代币
175         balanceOf[_from] -= _value;
176         allowance[_from][msg.sender] -= _value;
177 
178         //更新总量
179         totalSupply -= _value;
180         Burn(_from, _value);
181         return true;
182     }
183 }