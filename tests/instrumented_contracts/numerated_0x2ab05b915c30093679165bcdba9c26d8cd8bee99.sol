1 pragma solidity 0.4.24;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 
6 /**
7  * @title LMC代币合约
8  */
9 contract BCHC {
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
24 
25  /* 初始化合约，并且把初始的所有代币都给这合约的创建者
26      * @param initialSupply 代币的总数
27      * @param tokenName 代币名称
28      * @param tokenSymbol 代币符号
29      */
30     constructor(
31        uint256 initialSupply, string tokenName, string tokenSymbol
32     ) public {
33          //初始化总量
34         totalSupply = initialSupply * 10 ** uint256(decimals);    //以太币是10^18，后面18个0，所以默认decimals是18
35 
36         //给指定帐户初始化代币总量，初始化用于奖励合约创建者
37         balanceOf[msg.sender] = totalSupply;
38 
39         name = tokenName;
40         symbol = tokenSymbol;
41     }
42 
43 
44     // function LMC(uint256 initialSupply, string tokenName, string tokenSymbol) public {
45 
46     //     //初始化总量
47     //     totalSupply = initialSupply * 10 ** uint256(decimals);    //以太币是10^18，后面18个0，所以默认decimals是18
48 
49     //     //给指定帐户初始化代币总量，初始化用于奖励合约创建者
50     //     balanceOf[msg.sender] = totalSupply;
51 
52     //     name = tokenName;
53     //     symbol = tokenSymbol;
54 
55     // }
56 
57 
58     /**
59      * 私有方法从一个帐户发送给另一个帐户代币
60      * @param  _from address 发送代币的地址
61      * @param  _to address 接受代币的地址
62      * @param  _value uint256 接受代币的数量
63      */
64     function _transfer(address _from, address _to, uint256 _value) internal {
65 
66       //避免转帐的地址是0x0
67       require(_to != 0x0);
68 
69       //检查发送者是否拥有足够余额
70       require(balanceOf[_from] >= _value);
71 
72       //检查是否溢出
73       require(balanceOf[_to] + _value > balanceOf[_to]);
74 
75       //保存数据用于后面的判断
76       uint previousBalances = balanceOf[_from] + balanceOf[_to];
77 
78       //从发送者减掉发送额
79       balanceOf[_from] -= _value;
80 
81       //给接收者加上相同的量
82       balanceOf[_to] += _value;
83 
84       //通知任何监听该交易的客户端
85       emit  Transfer(_from, _to, _value);
86 
87       //判断买、卖双方的数据是否和转换前一致
88       assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
89 
90     }
91 
92     /**
93      * 从主帐户合约调用者发送给别人代币
94      * @param  _to address 接受代币的地址
95      * @param  _value uint256 接受代币的数量
96      */
97     function transfer(address _to, uint256 _value) public {
98         _transfer(msg.sender, _to, _value);
99     }
100 
101     /**
102      * 从某个指定的帐户中，向另一个帐户发送代币
103      *
104      * 调用过程，会检查设置的允许最大交易额
105      *
106      * @param  _from address 发送者地址
107      * @param  _to address 接受者地址
108      * @param  _value uint256 要转移的代币数量
109      * @return success        是否交易成功
110      */
111     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
112         //检查发送者是否拥有足够余额
113         require(_value <= allowance[_from][msg.sender]);   // Check allowance
114 
115         allowance[_from][msg.sender] -= _value;
116 
117         _transfer(_from, _to, _value);
118 
119         return true;
120     }
121 
122     /**
123      * 设置帐户允许支付的最大金额
124      *
125      * 一般在智能合约的时候，避免支付过多，造成风险
126      *
127      * @param _spender 帐户地址
128      * @param _value 金额
129      */
130     function approve(address _spender, uint256 _value) public returns (bool success) {
131         allowance[msg.sender][_spender] = _value;
132         return true;
133     }
134 
135     /**
136      * 设置帐户允许支付的最大金额
137      *
138      * 一般在智能合约的时候，避免支付过多，造成风险，加入时间参数，可以在 tokenRecipient 中做其他操作
139      *
140      * @param _spender 帐户地址
141      * @param _value 金额
142      * @param _extraData 操作的时间
143      */
144     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
145         tokenRecipient spender = tokenRecipient(_spender);
146         if (approve(_spender, _value)) {
147             spender.receiveApproval(msg.sender, _value, this, _extraData);
148             return true;
149         }
150     }
151 
152     /**
153      * 减少代币调用者的余额
154      *
155      * 操作以后是不可逆的
156      *
157      * @param _value 要删除的数量
158      */
159     function burn(uint256 _value) public returns (bool success) {
160         //检查帐户余额是否大于要减去的值
161         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
162 
163         //给指定帐户减去余额
164         balanceOf[msg.sender] -= _value;
165 
166         //代币问题做相应扣除
167         totalSupply -= _value;
168 
169         emit  Burn(msg.sender, _value);
170         return true;
171     }
172 
173     /**
174      * 删除帐户的余额（含其他帐户）
175      *
176      * 删除以后是不可逆的
177      *
178      * @param _from 要操作的帐户地址
179      * @param _value 要减去的数量
180      */
181     function burnFrom(address _from, uint256 _value) public returns (bool success) {
182 
183         //检查帐户余额是否大于要减去的值
184         require(balanceOf[_from] >= _value);
185 
186         //检查 其他帐户 的余额是否够使用
187         require(_value <= allowance[_from][msg.sender]);
188 
189         //减掉代币
190         balanceOf[_from] -= _value;
191         allowance[_from][msg.sender] -= _value;
192 
193         //更新总量
194         totalSupply -= _value;
195         emit Burn(_from, _value);
196         return true;
197     }
198 }