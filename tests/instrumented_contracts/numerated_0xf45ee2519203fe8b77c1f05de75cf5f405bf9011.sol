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
11 contract token {
12     /* 公共变量 */
13     string public standard = 'https://mshk.top';
14     string public name; //代币名称
15     string public symbol; //代币符号比如'$'
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
32     function token(uint256 initialSupply, string tokenName, string tokenSymbol) {
33 
34         //初始化总量
35         totalSupply = initialSupply * 10 ** uint256(decimals);    //以太币是10^18，后面18个0，所以默认decimals是18
36 
37         //给指定帐户初始化代币总量，初始化用于奖励合约创建者
38         balanceOf[msg.sender] = totalSupply;
39 
40         name = tokenName;
41         symbol = tokenSymbol;
42 
43     }
44 
45 
46     /**
47      * 私有方法从一个帐户发送给另一个帐户代币
48      * @param  _from address 发送代币的地址
49      * @param  _to address 接受代币的地址
50      * @param  _value uint256 接受代币的数量
51      */
52     function _transfer(address _from, address _to, uint256 _value) internal {
53 
54       //避免转帐的地址是0x0
55       require(_to != 0x0);
56 
57       //检查发送者是否拥有足够余额
58       require(balanceOf[_from] >= _value);
59 
60       //检查是否溢出
61       require(balanceOf[_to] + _value > balanceOf[_to]);
62 
63       //保存数据用于后面的判断
64       uint previousBalances = balanceOf[_from] + balanceOf[_to];
65 
66       //从发送者减掉发送额
67       balanceOf[_from] -= _value;
68 
69       //给接收者加上相同的量
70       balanceOf[_to] += _value;
71 
72       //通知任何监听该交易的客户端
73       Transfer(_from, _to, _value);
74 
75       //判断买、卖双方的数据是否和转换前一致
76       assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
77 
78     }
79 
80     /**
81      * 从主帐户合约调用者发送给别人代币
82      * @param  _to address 接受代币的地址
83      * @param  _value uint256 接受代币的数量
84      */
85     function transfer(address _to, uint256 _value) public {
86         _transfer(msg.sender, _to, _value);
87     }
88 
89     /**
90      * 从某个指定的帐户中，向另一个帐户发送代币
91      *
92      * 调用过程，会检查设置的允许最大交易额
93      *
94      * @param  _from address 发送者地址
95      * @param  _to address 接受者地址
96      * @param  _value uint256 要转移的代币数量
97      * @return success        是否交易成功
98      */
99     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
100         //检查发送者是否拥有足够余额
101         require(_value <= allowance[_from][msg.sender]);   // Check allowance
102 
103         allowance[_from][msg.sender] -= _value;
104 
105         _transfer(_from, _to, _value);
106 
107         return true;
108     }
109 
110     /**
111      * 设置帐户允许支付的最大金额
112      *
113      * 一般在智能合约的时候，避免支付过多，造成风险
114      *
115      * @param _spender 帐户地址
116      * @param _value 金额
117      */
118     function approve(address _spender, uint256 _value) public returns (bool success) {
119         allowance[msg.sender][_spender] = _value;
120         return true;
121     }
122 
123     /**
124      * 设置帐户允许支付的最大金额
125      *
126      * 一般在智能合约的时候，避免支付过多，造成风险，加入时间参数，可以在 tokenRecipient 中做其他操作
127      *
128      * @param _spender 帐户地址
129      * @param _value 金额
130      * @param _extraData 操作的时间
131      */
132     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
133         tokenRecipient spender = tokenRecipient(_spender);
134         if (approve(_spender, _value)) {
135             spender.receiveApproval(msg.sender, _value, this, _extraData);
136             return true;
137         }
138     }
139 
140     /**
141      * 减少代币调用者的余额
142      *
143      * 操作以后是不可逆的
144      *
145      * @param _value 要删除的数量
146      */
147     function burn(uint256 _value) public returns (bool success) {
148         //检查帐户余额是否大于要减去的值
149         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
150 
151         //给指定帐户减去余额
152         balanceOf[msg.sender] -= _value;
153 
154         //代币问题做相应扣除
155         totalSupply -= _value;
156 
157         Burn(msg.sender, _value);
158         return true;
159     }
160 
161     /**
162      * 删除帐户的余额（含其他帐户）
163      *
164      * 删除以后是不可逆的
165      *
166      * @param _from 要操作的帐户地址
167      * @param _value 要减去的数量
168      */
169     function burnFrom(address _from, uint256 _value) public returns (bool success) {
170 
171         //检查帐户余额是否大于要减去的值
172         require(balanceOf[_from] >= _value);
173 
174         //检查 其他帐户 的余额是否够使用
175         require(_value <= allowance[_from][msg.sender]);
176 
177         //减掉代币
178         balanceOf[_from] -= _value;
179         allowance[_from][msg.sender] -= _value;
180 
181         //更新总量
182         totalSupply -= _value;
183         Burn(_from, _value);
184         return true;
185     }
186 }