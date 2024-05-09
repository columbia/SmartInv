1 pragma solidity ^0.4.25;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData)  external ; }
4 
5 contract TokenERC20 {
6     string public name;//代币名字
7     string public symbol;//代币符号
8     uint8 public decimals = 9;  // decimals 可以有的小数点个数，最小的代币单位。18 是建议的默认值
9     uint256 public totalSupply;//总数量
10 
11     // 用mapping保存每个地址对应的余额
12     mapping (address => uint256) public balanceOf;
13     // 存储对账号的控制
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16     // 事件，用来通知客户端交易发生
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     // 事件，用来通知客户端代币被消费
20     event Burn(address indexed from, uint256 value);
21     //赋值,为了看得更清楚
22 
23 
24     /**
25      * 初始化构造
26      */
27     constructor (uint256 initialSupply, string tokenName, string tokenSymbol) public {
28         totalSupply = initialSupply * 10 ** uint256(decimals);  // 供应的份额，份额跟最小的代币单位有关，份额 = 币数 * 10 ** decimals。
29         balanceOf[msg.sender] = totalSupply;                // 创建者拥有所有的代币
30         name = tokenName;                                   // 代币名称
31         symbol = tokenSymbol;                               // 代币符号
32     }
33 
34     /**
35      * 代币交易转移的内部实现
36      */
37     function _transfer(address _from, address _to, uint _value) internal {
38         // 确保目标地址不为0x0，因为0x0地址代表销毁
39         require(_to != 0x0);
40         // 检查发送者余额
41         require(balanceOf[_from] >= _value);
42         // 确保转移为正数个
43         require(balanceOf[_to] + _value > balanceOf[_to]);
44 
45         // 以下用来检查交易，
46         uint previousBalances = balanceOf[_from] + balanceOf[_to];
47         // Subtract from the sender
48         balanceOf[_from] -= _value;
49         // Add the same to the recipient
50         balanceOf[_to] += _value;
51         emit Transfer(_from, _to, _value);
52 
53         // 用assert来检查代码逻辑。
54         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
55     }
56 
57     /**
58      * 代币交易转移
59      * 从自己（创建交易者）账号发送`_value`个代币到 `_to`账号
60      *
61      * @param _to 接收者地址
62      * @param _value 转移数额
63      */
64     function transfer(address _to, uint256 _value) public {
65         _transfer(msg.sender, _to, _value);
66     }
67 
68     /**
69      * 账号之间代币交易转移
70      * @param _from 发送者地址
71      * @param _to 接收者地址
72      * @param _value 转移数额
73      */
74     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
75         require(_value <= allowance[_from][msg.sender]);     // Check allowance
76         allowance[_from][msg.sender] -= _value;
77         _transfer(_from, _to, _value);
78         return true;
79     }
80 
81     /**
82      * 设置某个地址（合约）可以创建交易者名义花费的代币数。
83      *
84      * 允许发送者`_spender` 花费不多于 `_value` 个代币
85      *
86      * @param _spender The address authorized to spend
87      * @param _value the max amount they can spend
88      */
89     function approve(address _spender, uint256 _value) public
90         returns (bool success) {
91         allowance[msg.sender][_spender] = _value;
92         return true;
93     }
94 
95     /**
96      * 设置允许一个地址（合约）以我（创建交易者）的名义可最多花费的代币数。
97      *
98      * @param _spender 被授权的地址（合约）
99      * @param _value 最大可花费代币数
100      * @param _extraData 发送给合约的附加数据
101      */
102     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
103         public
104         returns (bool success) {
105         tokenRecipient spender = tokenRecipient(_spender);
106         if (approve(_spender, _value)) {
107             // 通知合约
108             spender.receiveApproval(msg.sender, _value, this, _extraData);
109             return true;
110         }
111     }
112 
113     /**
114      * 销毁（创建交易者）账户中指定个代币
115      */
116     function burn(uint256 _value) public returns (bool success) {
117         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
118         balanceOf[msg.sender] -= _value;            // Subtract from the sender
119         totalSupply -= _value;                      // Updates totalSupply
120         emit Burn(msg.sender, _value);
121         return true;
122     }
123 
124     /**
125      * 销毁用户账户中指定个代币
126      *
127      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
128      *
129      * @param _from the address of the sender
130      * @param _value the amount of money to burn
131      */
132     function burnFrom(address _from, uint256 _value) public returns (bool success) {
133         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
134         require(_value <= allowance[_from][msg.sender]);    // Check allowance
135         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
136         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
137         totalSupply -= _value;                              // Update totalSupply
138         emit Burn(_from, _value);
139         return true; 
140     }
141 }