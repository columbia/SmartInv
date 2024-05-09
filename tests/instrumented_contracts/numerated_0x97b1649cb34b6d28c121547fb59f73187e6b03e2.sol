1 pragma solidity ^0.4.21;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 
6 contract token {
7     /* 公共变量 */
8     string public name; //代币名称
9     string public symbol; //代币符号
10     uint8 public decimals = 4;  //代币单位，展示的小数点后面多少个0
11     uint256 public totalSupply; //代币总量
12 
13     /*记录所有余额的映射*/
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17 
18     event Transfer(address indexed from, address indexed to, uint256 value);  //转帐通知事件
19     event Burn(address indexed from, uint256 value);  //减去用户余额事件
20 
21     /* 初始化合约，并且把初始的所有代币都给这合约的创建者
22      * @param initialSupply 代币的总数
23      * @param tokenName 代币名称
24      * @param tokenSymbol 代币符号
25      */
26     function token(uint256 initialSupply, string tokenName, string tokenSymbol) public {
27 
28         //初始化总量
29         totalSupply = initialSupply * 10 ** uint256(decimals);    
30 
31         //给指定帐户初始化代币总量，初始化用于奖励合约创建者
32         balanceOf[msg.sender] = totalSupply;
33 
34         name = tokenName;
35         symbol = tokenSymbol;
36 
37     }
38 
39 
40     /**
41      * 私有方法从一个帐户发送给另一个帐户代币
42      * @param  _from address 发送代币的地址
43      * @param  _to address 接受代币的地址
44      * @param  _value uint256 接受代币的数量
45      */
46     function _transfer(address _from, address _to, uint256 _value) internal {
47 
48       //避免转帐的地址是0x0
49       require(_to != 0x0);
50 
51       //检查发送者是否拥有足够余额
52       require(balanceOf[_from] >= _value);
53 
54       //检查是否溢出
55       require(balanceOf[_to] + _value > balanceOf[_to]);
56 
57       //保存数据用于后面的判断
58       uint previousBalances = balanceOf[_from] + balanceOf[_to];
59 
60       //从发送者减掉发送额
61       balanceOf[_from] -= _value;
62 
63       //给接收者加上相同的量
64       balanceOf[_to] += _value;
65 
66       //通知任何监听该交易的客户端
67       Transfer(_from, _to, _value);
68 
69       //判断买、卖双方的数据是否和转换前一致
70       assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
71 
72     }
73 
74     /**
75      * 从主帐户合约调用者发送给别人代币
76      * @param  _to address 接受代币的地址
77      * @param  _value uint256 接受代币的数量
78      */
79     function transfer(address _to, uint256 _value) public {
80         _transfer(msg.sender, _to, _value);
81     }
82 
83     /**
84      * 从某个指定的帐户中，向另一个帐户发送代币
85      *
86      * 调用过程，会检查设置的允许最大交易额
87      *
88      * @param  _from address 发送者地址
89      * @param  _to address 接受者地址
90      * @param  _value uint256 要转移的代币数量
91      * @return success        是否交易成功
92      */
93     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
94         //检查发送者是否拥有足够余额
95         require(_value <= allowance[_from][msg.sender]);   // Check allowance
96 
97         allowance[_from][msg.sender] -= _value;
98 
99         _transfer(_from, _to, _value);
100 
101         return true;
102     }
103 
104     /**
105      * 设置帐户允许支付的最大金额
106      *
107      * 一般在智能合约的时候，避免支付过多，造成风险
108      *
109      * @param _spender 帐户地址
110      * @param _value 金额
111      */
112     function approve(address _spender, uint256 _value) public returns (bool success) {
113         allowance[msg.sender][_spender] = _value;
114         return true;
115     }
116 
117     /**
118      * 设置帐户允许支付的最大金额
119      *
120      * 一般在智能合约的时候，避免支付过多，造成风险，加入时间参数，可以在 tokenRecipient 中做其他操作
121      *
122      * @param _spender 帐户地址
123      * @param _value 金额
124      * @param _extraData 操作的时间
125      */
126     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
127         tokenRecipient spender = tokenRecipient(_spender);
128         if (approve(_spender, _value)) {
129             spender.receiveApproval(msg.sender, _value, this, _extraData);
130             return true;
131         }
132     }
133 
134     /**
135      * 减少代币调用者的余额
136      *
137      * 操作以后是不可逆的
138      *
139      * @param _value 要删除的数量
140      */
141     function burn(uint256 _value) public returns (bool success) {
142         //检查帐户余额是否大于要减去的值
143         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
144 
145         //给指定帐户减去余额
146         balanceOf[msg.sender] -= _value;
147 
148         //代币问题做相应扣除
149         totalSupply -= _value;
150 
151         Burn(msg.sender, _value);
152         return true;
153     }
154 
155     /**
156      * 删除帐户的余额（含其他帐户）
157      *
158      * 删除以后是不可逆的
159      *
160      * @param _from 要操作的帐户地址
161      * @param _value 要减去的数量
162      */
163     function burnFrom(address _from, uint256 _value) public returns (bool success) {
164 
165         //检查帐户余额是否大于要减去的值
166         require(balanceOf[_from] >= _value);
167 
168         //检查 其他帐户 的余额是否够使用
169         require(_value <= allowance[_from][msg.sender]);
170 
171         //减掉代币
172         balanceOf[_from] -= _value;
173         allowance[_from][msg.sender] -= _value;
174 
175         //更新总量
176         totalSupply -= _value;
177         Burn(_from, _value);
178         return true;
179     }
180 }