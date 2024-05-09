1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract TokenERC20 {
6 // Public variables of the token
7 string public name; /* name 代币名称 */
8 string public symbol; /* symbol 代币图标 */
9 uint8 public decimals = 8; /* decimals 代币小数点位数 */
10 uint256 public totalSupply; //代币总量
11 
12 
13 /* 设置一个数组存储每个账户的代币信息，创建所有账户余额数组 */
14 mapping (address => uint256) public balanceOf;
15 mapping (address => mapping (address => uint256)) public allowance;
16 
17 // This generates a public event on the blockchain that will notify clients
18 /* event事件，它的作用是提醒客户端发生了这个事件，你会注意到钱包有时候会在右下角弹出信息 */
19 event Transfer(address indexed from, address indexed to, uint256 value);
20 
21 event Approval(address indexed _owner, address indexed _spender, uint _value);
22 // This notifies clients about the amount burnt
23 event Burn(address indexed from, uint256 value);
24 
25 /**
26 * Constrctor function
27 *
28 * Initializes contract with initial supply tokens to the creator of the contract
29 */
30 /*初始化合约，将最初的令牌打入创建者的账户中*/
31 function TokenERC20(
32 uint256 initialSupply,
33 string tokenName,
34 string tokenSymbol
35 ) public {
36 totalSupply = initialSupply * 10 ** uint256(decimals); //以太币是10^18，后面18个0，所以默认decimals是18,给令牌设置18位小数的长度
37 balanceOf[msg.sender] = totalSupply; // 给创建者所有初始令牌
38 name = tokenName; // 设置代币（token）名称
39 symbol = tokenSymbol; // 设置代币（token）符号
40 }
41 
42 /**
43 * Internal transfer, only can be called by this contract
44 */
45 /**
46 * 私有方法从一个帐户发送给另一个帐户代币
47 * @param _from address 发送代币的地址
48 * @param _to address 接受代币的地址
49 * @param _value uint256 接受代币的数量
50 */
51 function _transfer(address _from, address _to, uint _value) internal {
52 
53 // Prevent transfer to 0x0 address. Use burn() instead
54 //避免转帐的地址是0x0
55 require(_to != 0x0);
56 
57 // Check if the sender has enough
58 //检查发送者是否拥有足够余额
59 require(balanceOf[_from] >= _value);
60 
61 // Check for overflows
62 //检查是否溢出
63 require(balanceOf[_to] + _value > balanceOf[_to]);
64 
65 // Save this for an assertion in the future
66 //保存数据用于后面的判断
67 uint previousBalances = balanceOf[_from] + balanceOf[_to];
68 
69 // Subtract from the sender
70 //从发送者减掉发送额
71 balanceOf[_from] -= _value;
72 
73 // Add the same to the recipient
74 //给接收者加上相同的量
75 balanceOf[_to] += _value;
76 
77 //通知任何监听该交易的客户端
78 Transfer(_from, _to, _value);
79 
80 // Asserts are used to use static analysis to find bugs in your code. They should never fail
81 
82 //判断买、卖双方的数据是否和转换前一致
83 assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
84 }
85 
86 
87 /**
88 * 从主帐户合约调用者发送给别人代币
89 * @param _to address 接受代币的地址
90 * @param _value uint256 接受代币的数量
91 */
92 function transfer(address _to, uint256 _value) public returns (bool success) {
93 if (balanceOf[msg.sender] >= _value
94 && _value > 0
95 && balanceOf[_to] + _value > balanceOf[_to]) {
96 balanceOf[msg.sender] -= _value;
97 balanceOf[_to] += _value;
98 //触发Transfer事件
99 _transfer(msg.sender, _to, _value);
100 return true;
101 } else {
102 return false;
103 }
104 }
105 
106 /**
107 * 从某个指定的帐户中，向另一个帐户发送代币
108 *
109 * 调用过程，会检查设置的允许最大交易额
110 *
111 * @param _from address 发送者地址
112 * @param _to address 接受者地址
113 * @param _value uint256 要转移的代币数量
114 * @return success 是否交易成功
115 */
116 function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
117 require(_value <= allowance[_from][msg.sender]); // Check allowance
118 allowance[_from][msg.sender] -= _value;
119 _transfer(_from, _to, _value);
120 return true;
121 }
122 //////////////////////////////////////以下//////////////////////////////////////////
123 /**
124 * 设置帐户允许支付的最大金额
125 * 一般在智能合约的时候，避免支付过多，造成风险
126 * @param _spender 帐户地址
127 * @param _value 金额
128 */
129 function approve(address _spender, uint256 _value) public returns (bool success) {
130 allowance[msg.sender][_spender] = _value;
131 //当授权时触发Approval事件
132 Approval(msg.sender, _spender, _value);
133 return true;
134 }
135 
136 /**
137 * 设置帐户允许支付的最大金额
138 * 一般在智能合约的时候，避免支付过多，造成风险，加入时间参数，可以在 tokenRecipient 中做其他操作
139 * @param _spender 帐户地址
140 * @param _value 金额
141 * @param _extraData 操作的时间
142 */
143 function approveAndCall(address _spender, uint256 _value, bytes _extraData) public
144 returns (bool success) {
145 tokenRecipient spender = tokenRecipient(_spender);
146 if (approve(_spender, _value)) {
147 spender.receiveApproval(msg.sender, _value, this, _extraData);
148 return true;
149 }
150 }
151 //////////////////////////////////以上/////////////////////////////////////////////
152 /**
153 * 减少代币调用者的余额
154 * 操作以后是不可逆的
155 * @param _value 要删除的数量
156 */
157 function burn(uint256 _value) public returns (bool success) {
158 require(balanceOf[msg.sender] >= _value); // Check if the sender has enough
159 balanceOf[msg.sender] -= _value; // Subtract from the sender
160 totalSupply -= _value; // Updates totalSupply
161 Burn(msg.sender, _value);
162 return true;
163 }
164 
165 /**
166 * 删除帐户的余额（含其他帐户）
167 * 删除以后是不可逆的
168 * @param _from 要操作的帐户地址
169 * @param _value 要减去的数量
170 */
171 function burnFrom(address _from, uint256 _value) public returns (bool success) {
172 require(balanceOf[_from] >= _value); // Check if the targeted balance is enough
173 require(_value <= allowance[_from][msg.sender]); // Check allowance
174 balanceOf[_from] -= _value; // Subtract from the targeted balance
175 allowance[_from][msg.sender] -= _value; // Subtract from the sender's allowance
176 totalSupply -= _value; // Update totalSupply
177 Burn(_from, _value);
178 return true;
179 }
180 }