1 /**
2  *Submitted for verification at Etherscan.io on 2018-08-09
3 */
4 
5 pragma solidity 0.4.24;
6 
7 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
8 
9 
10 /**
11  * @title YOACOIN代币合约
12  */
13 contract YOACOIN {
14     /* 公共变量 */
15     string public name; //代币名称
16     string public symbol; //代币符号比如'$'
17     uint8 public decimals = 18;  //代币单位，展示的小数点后面多少个0,和以太币一样后面是是18个0
18     uint256 public totalSupply; //代币总量
19 
20     /*记录所有余额的映射*/
21     mapping (address => uint256) public balanceOf;
22     mapping (address => mapping (address => uint256)) public allowance;
23 
24     /* 在区块链上创建一个事件，用以通知客户端*/
25     event Transfer(address indexed from, address indexed to, uint256 value);  //转帐通知事件
26     event Burn(address indexed from, uint256 value);  //减去用户余额事件
27 
28     /* 初始化合约，并且把初始的所有代币都给这合约的创建者
29      * @param initialSupply 代币的总数
30      * @param tokenName 代币名称
31      * @param tokenSymbol 代币符号
32      */
33     function YOACOIN(uint256 initialSupply, string tokenName, string tokenSymbol) public {
34 
35         //初始化总量
36         totalSupply = initialSupply * 10 ** uint256(decimals);    //以太币是10^18，后面18个0，所以默认decimals是18
37 
38         //给指定帐户初始化代币总量，初始化用于奖励合约创建者
39         balanceOf[msg.sender] = totalSupply;
40 
41         name = tokenName;
42         symbol = tokenSymbol;
43 
44     }
45 
46 
47     /**
48      * 私有方法从一个帐户发送给另一个帐户代币
49      * @param  _from address 发送代币的地址
50      * @param  _to address 接受代币的地址
51      * @param  _value uint256 接受代币的数量
52      */
53     function _transfer(address _from, address _to, uint256 _value) internal {
54 
55       //避免转帐的地址是0x0
56       require(_to != 0x0);
57 
58       //检查发送者是否拥有足够余额
59       require(balanceOf[_from] >= _value);
60 
61       //检查是否溢出
62       require(balanceOf[_to] + _value > balanceOf[_to]);
63 
64       //保存数据用于后面的判断
65       uint previousBalances = balanceOf[_from] + balanceOf[_to];
66 
67       //从发送者减掉发送额
68       balanceOf[_from] -= _value;
69 
70       //给接收者加上相同的量
71       balanceOf[_to] += _value;
72 
73       //通知任何监听该交易的客户端
74       Transfer(_from, _to, _value);
75 
76       //判断买、卖双方的数据是否和转换前一致
77       assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
78 
79     }
80 
81     /**
82      * 从主帐户合约调用者发送给别人代币
83      * @param  _to address 接受代币的地址
84      * @param  _value uint256 接受代币的数量
85      */
86     function transfer(address _to, uint256 _value) public {
87         _transfer(msg.sender, _to, _value);
88     }
89 
90     /**
91      * 从某个指定的帐户中，向另一个帐户发送代币
92      *
93      * 调用过程，会检查设置的允许最大交易额
94      *
95      * @param  _from address 发送者地址
96      * @param  _to address 接受者地址
97      * @param  _value uint256 要转移的代币数量
98      * @return success        是否交易成功
99      */
100     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
101         //检查发送者是否拥有足够余额
102         require(_value <= allowance[_from][msg.sender]);   // Check allowance
103 
104         allowance[_from][msg.sender] -= _value;
105 
106         _transfer(_from, _to, _value);
107 
108         return true;
109     }
110 
111     /**
112      * 设置帐户允许支付的最大金额
113      *
114      * 一般在智能合约的时候，避免支付过多，造成风险
115      *
116      * @param _spender 帐户地址
117      * @param _value 金额
118      */
119     function approve(address _spender, uint256 _value) public returns (bool success) {
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
158         Burn(msg.sender, _value);
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
184         Burn(_from, _value);
185         return true;
186     }
187 }