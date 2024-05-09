1 /**
2  *Submitted for verification at Etherscan.io on 2020-01-08
3 */
4 
5 pragma solidity ^0.4.19;
6  
7 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
8  
9 contract TokenERC20 {
10     string public name;
11     string public symbol;
12     uint8 public decimals = 18;  // decimals 可以有的小数点个数，最小的代币单位。18 是建议的默认值
13     uint256 public totalSupply;
14  
15     // 用mapping保存每个地址对应的余额
16     mapping (address => uint256) public balanceOf;
17     // 存储对账号的控制
18     mapping (address => mapping (address => uint256)) public allowance;
19  
20     // 事件，用来通知客户端交易发生
21     event Transfer(address indexed from, address indexed to, uint256 value);
22  
23     // 事件，用来通知客户端代币被消费
24     event Burn(address indexed from, uint256 value);
25  
26     /**
27      * 初始化构造
28      */
29     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
30         totalSupply = initialSupply * 10 ** uint256(decimals);  // 供应的份额，份额跟最小的代币单位有关，份额 = 币数 * 10 ** decimals。
31         balanceOf[msg.sender] = totalSupply;                // 创建者拥有所有的代币
32         name = tokenName;                                   // 代币名称
33         symbol = tokenSymbol;                               // 代币符号
34     }
35  
36     /**
37      * 代币交易转移的内部实现
38      */
39     function _transfer(address _from, address _to, uint _value) internal {
40         // 确保目标地址不为0x0，因为0x0地址代表销毁
41         //require(_to != 0x0);
42         // 检查发送者余额
43         require(balanceOf[_from] >= _value);
44         // 确保转移为正数个
45         require(balanceOf[_to] + _value > balanceOf[_to]);
46  
47         // 以下用来检查交易，
48         uint previousBalances = balanceOf[_from] + balanceOf[_to];
49         // Subtract from the sender
50         balanceOf[_from] -= _value;
51         // Add the same to the recipient
52         balanceOf[_to] += _value;
53         Transfer(_from, _to, _value);
54  
55         // 用assert来检查代码逻辑。
56         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
57     }
58  
59     /**
60      *  代币交易转移
61      * 从自己（创建交易者）账号发送`_value`个代币到 `_to`账号
62      *
63      * @param _to 接收者地址
64      * @param _value 转移数额
65      */
66     function transfer(address _to, uint256 _value) public {
67         _transfer(msg.sender, _to, _value);
68     }
69  
70     /**
71      * 账号之间代币交易转移
72      * @param _from 发送者地址
73      * @param _to 接收者地址
74      * @param _value 转移数额
75      */
76     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
77         require(_value <= allowance[_from][msg.sender]);     // Check allowance
78         allowance[_from][msg.sender] -= _value;
79         _transfer(_from, _to, _value);
80         return true;
81     }
82  
83     /**
84      * 设置某个地址（合约）可以创建交易者名义花费的代币数。
85      *
86      * 允许发送者`_spender` 花费不多于 `_value` 个代币
87      *
88      * @param _spender The address authorized to spend
89      * @param _value the max amount they can spend
90      */
91     function approve(address _spender, uint256 _value) public
92         returns (bool success) {
93         allowance[msg.sender][_spender] = _value;
94         return true;
95     }
96  
97     /**
98      * 设置允许一个地址（合约）以我（创建交易者）的名义可最多花费的代币数。
99      *
100      * @param _spender 被授权的地址（合约）
101      * @param _value 最大可花费代币数
102      * @param _extraData 发送给合约的附加数据
103      */
104     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
105         public
106         returns (bool success) {
107         tokenRecipient spender = tokenRecipient(_spender);
108         if (approve(_spender, _value)) {
109             // 通知合约
110             spender.receiveApproval(msg.sender, _value, this, _extraData);
111             return true;
112         }
113     }
114  
115     /**
116      * 销毁我（创建交易者）账户中指定个代币
117      */
118     function burn(uint256 _value) public returns (bool success) {
119         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
120         balanceOf[msg.sender] -= _value;            // Subtract from the sender
121         totalSupply -= _value;                      // Updates totalSupply
122         Burn(msg.sender, _value);
123         return true;
124     }
125  
126     /**
127      * 销毁用户账户中指定个代币
128      *
129      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
130      *
131      * @param _from the address of the sender
132      * @param _value the amount of money to burn
133      */
134     function burnFrom(address _from, uint256 _value) public returns (bool success) {
135         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
136         require(_value <= allowance[_from][msg.sender]);    // Check allowance
137         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
138         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
139         totalSupply -= _value;                              // Update totalSupply
140         Burn(_from, _value);
141         return true;
142     }
143 }