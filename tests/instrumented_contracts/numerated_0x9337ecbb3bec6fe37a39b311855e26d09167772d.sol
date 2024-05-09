1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient {
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
5 }
6 
7 
8 /**
9  * @title 基础版的代币合约
10  */
11 contract xyjtoken {
12     /* 公共变量 */
13     string public standard = 'https://tlw.im';
14     string public name; //代币名称
15     string public symbol; //代币符号比如
16     uint8 public decimals = 18;  //代币单位，展示的小数点后面多少个0,和以太币一样后面是是18个0
17     uint256 public totalSupply; //代币总量
18 
19     /*记录所有余额的映射*/
20     mapping (address => uint256) public balanceOf;
21     mapping (address => mapping (address => uint256)) public allowance;
22 
23     /* 在区块链上创建一个事件，用以通知客户端*/
24     event Transfer(address indexed from, address indexed to, uint256 value);  //转帐通知事件
25     event Burn(address indexed from, uint256 value);  //减去用户余额事件
26 
27     /* 初始化合约，并且把初始的所有代币都给这合约的创建者
28      * @param initialSupply 代币的总数
29      * @param tokenName 代币名称
30      * @param tokenSymbol 代币符号
31      */
32     function xyjtoken(uint256 initialSupply, string tokenName, string tokenSymbol) {
33 
34         //初始化总量
35         totalSupply = initialSupply * 10 ** uint256(decimals);    //以太币是10^18，后面18个0，所以默认decimals是18
36 
37         //给指定帐户初始化代币总量，初始化用于奖励合约创建者
38         balanceOf[msg.sender] = totalSupply;
39 
40         name = tokenName;
41         symbol = tokenSymbol;
42     }
43 
44 
45     /**
46      * 私有方法从一个帐户发送给另一个帐户代币
47      * @param  _from address 发送代币的地址
48      * @param  _to address 接受代币的地址
49      * @param  _value uint256 接受代币的数量
50      */
51     function _transfer(address _from, address _to, uint256 _value) internal {
52 
53       //避免转帐的地址是0x0
54       require(_to != 0x0);
55 
56       //检查发送者是否拥有足够余额
57       require(balanceOf[_from] >= _value);
58 
59       //检查是否溢出
60       require(balanceOf[_to] + _value > balanceOf[_to]);
61 
62       //保存数据用于后面的判断
63       uint previousBalances = balanceOf[_from] + balanceOf[_to];
64 
65       //从发送者减掉发送额
66       balanceOf[_from] -= _value;
67 
68       //给接收者加上相同的量
69       balanceOf[_to] += _value;
70 
71       //通知任何监听该交易的客户端
72       Transfer(_from, _to, _value);
73 
74       //判断买、卖双方的数据是否和转换前一致
75       assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
76 
77     }
78 
79     /**
80      * 从主帐户合约调用者发送给别人代币
81      * @param  _to address 接受代币的地址
82      * @param  _value uint256 接受代币的数量
83      */
84     function transfer(address _to, uint256 _value) public {
85         _transfer(msg.sender, _to, _value);
86     }
87 
88     /**
89      * 从某个指定的帐户中，向另一个帐户发送代币
90      *
91      * 调用过程，会检查设置的允许最大交易额
92      *
93      * @param  _from address 发送者地址
94      * @param  _to address 接受者地址
95      * @param  _value uint256 要转移的代币数量
96      * @return success        是否交易成功
97      */
98     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
99         //检查发送者是否拥有足够余额
100         require(_value <= allowance[_from][msg.sender]);   // Check allowance
101 
102         allowance[_from][msg.sender] -= _value;
103 
104         _transfer(_from, _to, _value);
105 
106         return true;
107     }
108 
109     /**
110      * 设置帐户允许支付的最大金额
111      *
112      * 一般在智能合约的时候，避免支付过多，造成风险
113      *
114      * @param _spender 帐户地址
115      * @param _value 金额
116      */
117     function approve(address _spender, uint256 _value) public returns (bool success) {
118         allowance[msg.sender][_spender] = _value;
119         return true;
120     }
121 
122     /**
123      * 设置帐户允许支付的最大金额
124      *
125      * 一般在智能合约的时候，避免支付过多，造成风险，加入时间参数，可以在 tokenRecipient 中做其他操作
126      *
127      * @param _spender 帐户地址
128      * @param _value 金额
129      * @param _extraData 操作的时间
130      */
131     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
132         tokenRecipient spender = tokenRecipient(_spender);
133         if (approve(_spender, _value)) {
134             spender.receiveApproval(msg.sender, _value, this, _extraData);
135             return true;
136         }
137     }
138 
139     /**
140      * 减少代币调用者的余额
141      *
142      * 操作以后是不可逆的
143      *
144      * @param _value 要删除的数量
145      */
146     function burn(uint256 _value) public returns (bool success) {
147         //检查帐户余额是否大于要减去的值
148         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
149 
150         //给指定帐户减去余额
151         balanceOf[msg.sender] -= _value;
152 
153         //代币问题做相应扣除
154         totalSupply -= _value;
155 
156         Burn(msg.sender, _value);
157         return true;
158     }
159 
160     /**
161      * 删除帐户的余额（含其他帐户）
162      *
163      * 删除以后是不可逆的
164      *
165      * @param _from 要操作的帐户地址
166      * @param _value 要减去的数量
167      */
168     function burnFrom(address _from, uint256 _value) public returns (bool success) {
169 
170         //检查帐户余额是否大于要减去的值
171         require(balanceOf[_from] >= _value);
172 
173         //检查 其他帐户 的余额是否够使用
174         require(_value <= allowance[_from][msg.sender]);
175 
176         //减掉代币
177         balanceOf[_from] -= _value;
178         allowance[_from][msg.sender] -= _value;
179 
180         //更新总量
181         totalSupply -= _value;
182         Burn(_from, _value);
183         return true;
184     }
185 }