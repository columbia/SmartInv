1 /**
2  * Source Code first verified at https://etherscan.io on Wednesday, June 6, 2018
3  (UTC) */
4 
5 pragma solidity ^0.4.16;
6 //pragma solidity ^0.5.1;
7 
8 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
9 
10 contract TokenERC20 {
11     // Public variables of the token
12     string public name;							/* name 代币名称 */
13     string public symbol;						/* symbol 代币图标 */
14     uint8  public decimals = 18;			/* decimals 代币小数点位数 */ 
15     uint256 public totalSupply;			//代币总量
16 
17     
18     /* 设置一个数组存储每个账户的代币信息，创建所有账户余额数组 */
19     mapping (address => uint256) public balanceOf;
20     mapping (address => mapping (address => uint256)) public allowance;
21 
22     // This generates a public event on the blockchain that will notify clients
23     /* event事件，它的作用是提醒客户端发生了这个事件，你会注意到钱包有时候会在右下角弹出信息 */
24     event Transfer(address indexed from, address indexed to, uint256 value);
25 
26     // This notifies clients about the amount burnt
27     event Burn(address indexed from, uint256 value);
28 
29     /**
30      * Constrctor function
31      *
32      * Initializes contract with initial supply tokens to the creator of the contract
33      */
34      /*初始化合约，将最初的令牌打入创建者的账户中*/
35     function TokenERC20(
36         uint256 initialSupply,
37         string tokenName,
38         string tokenSymbol
39     ) public {
40         totalSupply = initialSupply * 10 ** uint256(decimals);  //以太币是10^18，后面18个0，所以默认decimals是18,给令牌设置18位小数的长度
41         balanceOf[msg.sender] = totalSupply;                		// 给创建者所有初始令牌
42         name = tokenName;                                   		// 设置代币（token）名称
43         symbol = tokenSymbol;                               		// 设置代币（token）符号
44     }
45 
46     /**
47      * Internal transfer, only can be called by this contract
48      */
49      /**
50      * 私有方法从一个帐户发送给另一个帐户代币
51      * @param  _from address 发送代币的地址
52      * @param  _to address 接受代币的地址
53      * @param  _value uint256 接受代币的数量
54      */
55     function _transfer(address _from, address _to, uint _value) internal {
56     
57         // Prevent transfer to 0x0 address. Use burn() instead
58         //避免转帐的地址是0x0
59         require(_to != 0x0);
60         
61         // Check if the sender has enough
62         //检查发送者是否拥有足够余额
63         require(balanceOf[_from] >= _value);
64         
65         // Check for overflows
66         //检查是否溢出
67         require(balanceOf[_to] + _value > balanceOf[_to]);
68         
69         // Save this for an assertion in the future
70         //保存数据用于后面的判断
71         uint previousBalances = balanceOf[_from] + balanceOf[_to];
72         
73         // Subtract from the sender
74         //从发送者减掉发送额
75         balanceOf[_from] -= _value;
76         
77         // Add the same to the recipient
78         //给接收者加上相同的量
79         balanceOf[_to] += _value;
80         
81         //通知任何监听该交易的客户端
82         Transfer(_from, _to, _value);
83         
84         // Asserts are used to use static analysis to find bugs in your code. They should never fail
85         
86         //判断买、卖双方的数据是否和转换前一致
87         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
88     }
89 
90     
91      /**
92      * 从主帐户合约调用者发送给别人代币
93      * @param  _to address 接受代币的地址
94      * @param  _value uint256 接受代币的数量
95      */
96     function transfer(address _to, uint256 _value) public {
97         _transfer(msg.sender, _to, _value);
98     }
99 
100      /**
101      * 从某个指定的帐户中，向另一个帐户发送代币
102      *
103      * 调用过程，会检查设置的允许最大交易额
104      *
105      * @param  _from address 发送者地址
106      * @param  _to address 接受者地址
107      * @param  _value uint256 要转移的代币数量
108      * @return success        是否交易成功
109      */
110     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
111         require(_value <= allowance[_from][msg.sender]);     // Check allowance
112         allowance[_from][msg.sender] -= _value;
113         _transfer(_from, _to, _value);
114         return true;
115     }
116 
117  		/**
118      * 设置帐户允许支付的最大金额
119      * 一般在智能合约的时候，避免支付过多，造成风险
120      * @param _spender 帐户地址
121      * @param _value 金额
122      */
123     function approve(address _spender, uint256 _value) public
124         returns (bool success) {
125         allowance[msg.sender][_spender] = _value;
126         return true;
127     }
128 
129 		/**
130      * 设置帐户允许支付的最大金额
131      * 一般在智能合约的时候，避免支付过多，造成风险，加入时间参数，可以在 tokenRecipient 中做其他操作
132      * @param _spender 帐户地址
133      * @param _value 金额
134      * @param _extraData 操作的时间
135      */
136     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
137         public
138         returns (bool success) {
139         tokenRecipient spender = tokenRecipient(_spender);
140         if (approve(_spender, _value)) {
141             spender.receiveApproval(msg.sender, _value, this, _extraData);
142             return true;
143         }
144     }
145 
146     /**
147      * 减少代币调用者的余额
148      * 操作以后是不可逆的
149      * @param _value 要删除的数量
150      */
151     function burn(uint256 _value) public returns (bool success) {
152         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
153         balanceOf[msg.sender] -= _value;            // Subtract from the sender
154         totalSupply -= _value;                      // Updates totalSupply
155         Burn(msg.sender, _value);
156         return true;
157     }
158 
159     /**
160      * 删除帐户的余额（含其他帐户）
161      * 删除以后是不可逆的
162      * @param _from 要操作的帐户地址
163      * @param _value 要减去的数量
164      */
165     function burnFrom(address _from, uint256 _value) public returns (bool success) {
166         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
167         require(_value <= allowance[_from][msg.sender]);    // Check allowance
168         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
169         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
170         totalSupply -= _value;                              // Update totalSupply
171         Burn(_from, _value);
172         return true;
173     }
174 }