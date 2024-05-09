1 pragma solidity 0.4.24;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 
6 
7 contract SIMAT {
8     /* 公共变量 */
9     string public name; //代币名称
10     string public symbol; //代币符号比如'$'
11     uint8 public decimals = 18;  //代币单位，展示的小数点后面多少个0,和以太币一样后面是是18个0
12     uint256 public totalSupply; //代币总量
13 
14     /*记录所有余额的映射*/
15     mapping (address => uint256) public balanceOf;
16     mapping (address => mapping (address => uint256)) public allowance;
17 
18     /* 在区块链上创建一个事件，用以通知客户端*/
19     event Transfer(address indexed from, address indexed to, uint256 value);  //转帐通知事件
20     event Burn(address indexed from, uint256 value);  //减去用户余额事件
21 
22     /* 初始化合约，并且把初始的所有代币都给这合约的创建者
23      * @param initialSupply 代币的总数
24      * @param tokenName 代币名称
25      * @param tokenSymbol 代币符号
26      */
27     function SIMAT(uint256 initialSupply, string tokenName, string tokenSymbol) public {
28 
29         //初始化总量
30         totalSupply = initialSupply * 10 ** uint256(decimals);    //以太币是10^18，后面18个0，所以默认decimals是18
31 
32         //给指定帐户初始化代币总量，初始化用于奖励合约创建者
33         balanceOf[msg.sender] = totalSupply;
34 
35         name = tokenName;
36         symbol = tokenSymbol;
37 
38     }
39 
40 
41     /**
42      * 私有方法从一个帐户发送给另一个帐户代币
43      * @param  _from address 发送代币的地址
44      * @param  _to address 接受代币的地址
45      * @param  _value uint256 接受代币的数量
46      */
47     function _transfer(address _from, address _to, uint256 _value) internal {
48 
49       //避免转帐的地址是0x0
50       require(_to != 0x0);
51 
52       //检查发送者是否拥有足够余额
53       require(balanceOf[_from] >= _value);
54 
55       //检查是否溢出
56       require(balanceOf[_to] + _value > balanceOf[_to]);
57 
58       //保存数据用于后面的判断
59       uint previousBalances = balanceOf[_from] + balanceOf[_to];
60 
61       //从发送者减掉发送额
62       balanceOf[_from] -= _value;
63 
64       //给接收者加上相同的量
65       balanceOf[_to] += _value;
66 
67       //通知任何监听该交易的客户端
68       Transfer(_from, _to, _value);
69 
70       //判断买、卖双方的数据是否和转换前一致
71       assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
72 
73     }
74 
75     /**
76      * 从主帐户合约调用者发送给别人代币
77      * @param  _to address 接受代币的地址
78      * @param  _value uint256 接受代币的数量
79      */
80     function transfer(address _to, uint256 _value) public {
81         _transfer(msg.sender, _to, _value);
82     }
83 
84     /**
85      * 从某个指定的帐户中，向另一个帐户发送代币
86      *
87      * 调用过程，会检查设置的允许最大交易额
88      *
89      * @param  _from address 发送者地址
90      * @param  _to address 接受者地址
91      * @param  _value uint256 要转移的代币数量
92      * @return success        是否交易成功
93      */
94     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
95         //检查发送者是否拥有足够余额
96         require(_value <= allowance[_from][msg.sender]);   // Check allowance
97 
98         allowance[_from][msg.sender] -= _value;
99 
100         _transfer(_from, _to, _value);
101 
102         return true;
103     }
104 
105     /**
106      * 设置帐户允许支付的最大金额
107      *
108      * 一般在智能合约的时候，避免支付过多，造成风险
109      *
110      * @param _spender 帐户地址
111      * @param _value 金额
112      */
113     function approve(address _spender, uint256 _value) public returns (bool success) {
114         allowance[msg.sender][_spender] = _value;
115         return true;
116     }
117 
118     /**
119      * 设置帐户允许支付的最大金额
120      *
121      * 一般在智能合约的时候，避免支付过多，造成风险，加入时间参数，可以在 tokenRecipient 中做其他操作
122      *
123      * @param _spender 帐户地址
124      * @param _value 金额
125      * @param _extraData 操作的时间
126      */
127     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
128         tokenRecipient spender = tokenRecipient(_spender);
129         if (approve(_spender, _value)) {
130             spender.receiveApproval(msg.sender, _value, this, _extraData);
131             return true;
132         }
133     }
134 
135     /**
136      * 减少代币调用者的余额
137      *
138      * 操作以后是不可逆的
139      *
140      * @param _value 要删除的数量
141      */
142     function burn(uint256 _value) public returns (bool success) {
143         //检查帐户余额是否大于要减去的值
144         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
145 
146         //给指定帐户减去余额
147         balanceOf[msg.sender] -= _value;
148 
149         //代币问题做相应扣除
150         totalSupply -= _value;
151 
152         Burn(msg.sender, _value);
153         return true;
154     }
155 
156     /**
157      * 删除帐户的余额（含其他帐户）
158      *
159      * 删除以后是不可逆的
160      *
161      * @param _from 要操作的帐户地址
162      * @param _value 要减去的数量
163      */
164     function burnFrom(address _from, uint256 _value) public returns (bool success) {
165 
166         //检查帐户余额是否大于要减去的值
167         require(balanceOf[_from] >= _value);
168 
169         //检查 其他帐户 的余额是否够使用
170         require(_value <= allowance[_from][msg.sender]);
171 
172         //减掉代币
173         balanceOf[_from] -= _value;
174         allowance[_from][msg.sender] -= _value;
175 
176         //更新总量
177         totalSupply -= _value;
178         Burn(_from, _value);
179         return true;
180     }
181 }