1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract TokenERC20 {
6     // Public variables of the token
7     string public name;							/* name 代币名称 */
8     string public symbol;						/* symbol 代币图标 */
9     uint8  public decimals = 18;			/* decimals 代币小数点位数 */ 
10     uint256 public totalSupply;			//代币总量
11 
12     
13     /* 设置一个数组存储每个账户的代币信息，创建所有账户余额数组 */
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     // This generates a public event on the blockchain that will notify clients
18     /* event事件，它的作用是提醒客户端发生了这个事件，你会注意到钱包有时候会在右下角弹出信息 */
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     // This notifies clients about the amount burnt
22     event Burn(address indexed from, uint256 value);
23 
24     /**
25      * Constrctor function
26      *
27      * Initializes contract with initial supply tokens to the creator of the contract
28      */
29      /*初始化合约，将最初的令牌打入创建者的账户中*/
30     function TokenERC20(
31         uint256 initialSupply,
32         string tokenName,
33         string tokenSymbol
34     ) public {
35         totalSupply = initialSupply * 10 ** uint256(decimals);  //以太币是10^18，后面18个0，所以默认decimals是18,给令牌设置18位小数的长度
36         balanceOf[msg.sender] = totalSupply;                		// 给创建者所有初始令牌
37         name = tokenName;                                   		// 设置代币（token）名称
38         symbol = tokenSymbol;                               		// 设置代币（token）符号
39     }
40 
41     /**
42      * Internal transfer, only can be called by this contract
43      */
44      /**
45      * 私有方法从一个帐户发送给另一个帐户代币
46      * @param  _from address 发送代币的地址
47      * @param  _to address 接受代币的地址
48      * @param  _value uint256 接受代币的数量
49      */
50     function _transfer(address _from, address _to, uint _value) internal {
51     
52         // Prevent transfer to 0x0 address. Use burn() instead
53         //避免转帐的地址是0x0
54         require(_to != 0x0);
55         
56         // Check if the sender has enough
57         //检查发送者是否拥有足够余额
58         require(balanceOf[_from] >= _value);
59         
60         // Check for overflows
61         //检查是否溢出
62         require(balanceOf[_to] + _value > balanceOf[_to]);
63         
64         // Save this for an assertion in the future
65         //保存数据用于后面的判断
66         uint previousBalances = balanceOf[_from] + balanceOf[_to];
67         
68         // Subtract from the sender
69         //从发送者减掉发送额
70         balanceOf[_from] -= _value;
71         
72         // Add the same to the recipient
73         //给接收者加上相同的量
74         balanceOf[_to] += _value;
75         
76         //通知任何监听该交易的客户端
77         Transfer(_from, _to, _value);
78         
79         // Asserts are used to use static analysis to find bugs in your code. They should never fail
80         
81         //判断买、卖双方的数据是否和转换前一致
82         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
83     }
84 
85     
86      /**
87      * 从主帐户合约调用者发送给别人代币
88      * @param  _to address 接受代币的地址
89      * @param  _value uint256 接受代币的数量
90      */
91     function transfer(address _to, uint256 _value) public {
92         _transfer(msg.sender, _to, _value);
93     }
94 
95      /**
96      * 从某个指定的帐户中，向另一个帐户发送代币
97      *
98      * 调用过程，会检查设置的允许最大交易额
99      *
100      * @param  _from address 发送者地址
101      * @param  _to address 接受者地址
102      * @param  _value uint256 要转移的代币数量
103      * @return success        是否交易成功
104      */
105     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
106         require(_value <= allowance[_from][msg.sender]);     // Check allowance
107         allowance[_from][msg.sender] -= _value;
108         _transfer(_from, _to, _value);
109         return true;
110     }
111 
112  		/**
113      * 设置帐户允许支付的最大金额
114      * 一般在智能合约的时候，避免支付过多，造成风险
115      * @param _spender 帐户地址
116      * @param _value 金额
117      */
118     function approve(address _spender, uint256 _value) public
119         returns (bool success) {
120         allowance[msg.sender][_spender] = _value;
121         return true;
122     }
123 
124 		/**
125      * 设置帐户允许支付的最大金额
126      * 一般在智能合约的时候，避免支付过多，造成风险，加入时间参数，可以在 tokenRecipient 中做其他操作
127      * @param _spender 帐户地址
128      * @param _value 金额
129      * @param _extraData 操作的时间
130      */
131     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
132         public
133         returns (bool success) {
134         tokenRecipient spender = tokenRecipient(_spender);
135         if (approve(_spender, _value)) {
136             spender.receiveApproval(msg.sender, _value, this, _extraData);
137             return true;
138         }
139     }
140 
141     /**
142      * 减少代币调用者的余额
143      * 操作以后是不可逆的
144      * @param _value 要删除的数量
145      */
146     function burn(uint256 _value) public returns (bool success) {
147         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
148         balanceOf[msg.sender] -= _value;            // Subtract from the sender
149         totalSupply -= _value;                      // Updates totalSupply
150         Burn(msg.sender, _value);
151         return true;
152     }
153 
154     /**
155      * 删除帐户的余额（含其他帐户）
156      * 删除以后是不可逆的
157      * @param _from 要操作的帐户地址
158      * @param _value 要减去的数量
159      */
160     function burnFrom(address _from, uint256 _value) public returns (bool success) {
161         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
162         require(_value <= allowance[_from][msg.sender]);    // Check allowance
163         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
164         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
165         totalSupply -= _value;                              // Update totalSupply
166         Burn(_from, _value);
167         return true;
168     }
169 }