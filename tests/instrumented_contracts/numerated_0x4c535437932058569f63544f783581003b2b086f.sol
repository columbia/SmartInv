1 pragma solidity 0.4.24;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 
6 /**
7  * @title GBT代币合约
8  */
9 contract GBT {
10     /* 公共变量 */
11     string public name; //代币名称
12     string public symbol; //代币符号比如'$'
13     uint8 public decimals = 4;  //代币单位，展示的小数点后面多少个0,后面是是4个0
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
24 
25     /* 初始化合约，并且把初始的所有代币都给这合约的创建者
26      * @param initialSupply 代币的总数
27      * @param tokenName 代币名称
28      * @param tokenSymbol 代币符号
29      */
30     constructor(
31        uint256 initialSupply, string tokenName, string tokenSymbol
32     ) public {
33          //初始化总量
34         totalSupply = initialSupply * 10 ** uint256(decimals);    //带着小数的精度
35 
36         //给指定帐户初始化代币总量，初始化用于奖励合约创建者
37         balanceOf[msg.sender] = totalSupply;
38 
39         name = tokenName;
40         symbol = tokenSymbol;
41     }
42 
43 
44     /**
45      * 私有方法从一个帐户发送给另一个帐户代币
46      * @param  _from address 发送代币的地址
47      * @param  _to address 接受代币的地址
48      * @param  _value uint256 接受代币的数量
49      */
50     function _transfer(address _from, address _to, uint256 _value) internal {
51 
52       //避免转帐的地址是0x0
53       require(_to != 0x0);
54 
55       //检查发送者是否拥有足够余额
56       require(balanceOf[_from] >= _value);
57 
58       //检查是否溢出
59       require(balanceOf[_to] + _value > balanceOf[_to]);
60 
61       //保存数据用于后面的判断
62       uint previousBalances = balanceOf[_from] + balanceOf[_to];
63 
64       //从发送者减掉发送额
65       balanceOf[_from] -= _value;
66 
67       //给接收者加上相同的量
68       balanceOf[_to] += _value;
69 
70       //通知任何监听该交易的客户端
71       emit  Transfer(_from, _to, _value);
72 
73       //判断买、卖双方的数据是否和转换前一致
74       assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
75 
76     }
77 
78     /**
79      * 从主帐户合约调用者发送给别人代币
80      * @param  _to address 接受代币的地址
81      * @param  _value uint256 接受代币的数量
82      */
83     function transfer(address _to, uint256 _value) public {
84         _transfer(msg.sender, _to, _value);
85     }
86 
87     /**
88      * 从某个指定的帐户中，向另一个帐户发送代币
89      *
90      * 调用过程，会检查设置的允许最大交易额
91      *
92      * @param  _from address 发送者地址
93      * @param  _to address 接受者地址
94      * @param  _value uint256 要转移的代币数量
95      * @return success        是否交易成功
96      */
97     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
98         //检查发送者是否拥有足够余额
99         require(_value <= allowance[_from][msg.sender]);   // Check allowance
100 
101         allowance[_from][msg.sender] -= _value;
102 
103         _transfer(_from, _to, _value);
104 
105         return true;
106     }
107 
108     /**
109      * 设置帐户允许支付的最大金额
110      *
111      * 一般在智能合约的时候，避免支付过多，造成风险
112      *
113      * @param _spender 帐户地址
114      * @param _value 金额
115      */
116     function approve(address _spender, uint256 _value) public returns (bool success) {
117         //防止事务顺序依赖
118         require((_value == 0) || (allowance[msg.sender][_spender] == 0));
119 
120         allowance[msg.sender][_spender] = _value;
121         return true;
122     }
123 
124     /**
125      * 设置帐户允许支付的最大金额
126      *
127      * 一般在智能合约的时候，避免支付过多，造成风险，加入时间参数，可以在 tokenRecipient 中做其他操作
128      *
129      * @param _spender 帐户地址
130      * @param _value 金额
131      * @param _extraData 操作的时间
132      */
133     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
134         tokenRecipient spender = tokenRecipient(_spender);
135         if (approve(_spender, _value)) {
136             spender.receiveApproval(msg.sender, _value, this, _extraData);
137             return true;
138         }
139     }
140 
141     /**
142      * 减少代币调用者的余额
143      *
144      * 操作以后是不可逆的
145      *
146      * @param _value 要删除的数量
147      */
148     function burn(uint256 _value) public returns (bool success) {
149         //检查帐户余额是否大于要减去的值
150         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
151 
152         //给指定帐户减去余额
153         balanceOf[msg.sender] -= _value;
154 
155         //代币问题做相应扣除
156         totalSupply -= _value;
157 
158         emit  Burn(msg.sender, _value);
159         return true;
160     }
161 
162     /**
163      * 删除帐户的余额（含其他帐户）
164      *
165      * 删除以后是不可逆的
166      *
167      * @param _from 要操作的帐户地址
168      * @param _value 要减去的数量
169      */
170     function burnFrom(address _from, uint256 _value) public returns (bool success) {
171 
172         //检查帐户余额是否大于要减去的值
173         require(balanceOf[_from] >= _value);
174 
175         //检查 其他帐户 的余额是否够使用
176         require(_value <= allowance[_from][msg.sender]);
177 
178         //减掉代币
179         balanceOf[_from] -= _value;
180         allowance[_from][msg.sender] -= _value;
181 
182         //更新总量
183         totalSupply -= _value;
184         emit Burn(_from, _value);
185         return true;
186     }
187 }