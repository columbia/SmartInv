1 pragma solidity ^0.4.19;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract TC {
6     string public name;
7     string public symbol;
8     uint8 public decimals = 18;  // decimals 可以有的小数点个数，最小的代币单位。18 是建议的默认值
9     uint256 public totalSupply;
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
21 
22     /**
23      * 初始化构造
24      */
25     function TC(uint256 initialSupply, string tokenName, string tokenSymbol) public {
26         totalSupply = initialSupply * 10 ** uint256(decimals);  // 供应的份额，份额跟最小的代币单位有关，份额 = 币数 * 10 ** decimals。
27         balanceOf[msg.sender] = totalSupply;                // 创建者拥有所有的代币
28         name = tokenName;                                   // 代币名称
29         symbol = tokenSymbol;                               // 代币符号
30     }
31 
32     /**
33      * 代币交易转移的内部实现
34      */
35     function _transfer(address _from, address _to, uint _value) internal {
36         // 确保目标地址不为0x0，因为0x0地址代表销毁
37         require(_to != 0x0);
38         // 检查发送者余额
39         require(balanceOf[_from] >= _value);
40         // 确保转移为正数个
41         require(balanceOf[_to] + _value > balanceOf[_to]);
42 
43         // 以下用来检查交易，
44         uint previousBalances = balanceOf[_from] + balanceOf[_to];
45         // Subtract from the sender
46         balanceOf[_from] -= _value;
47         // Add the same to the recipient
48         balanceOf[_to] += _value;
49         Transfer(_from, _to, _value);
50 
51         // 用assert来检查代码逻辑。
52         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
53     }
54 
55     /**
56      *  代币交易转移
57      * 从自己（创建交易者）账号发送`_value`个代币到 `_to`账号
58      *
59      * @param _to 接收者地址
60      * @param _value 转移数额
61      */
62     function transfer(address _to, uint256 _value) public {
63         _transfer(msg.sender, _to, _value);
64     }
65 
66     /**
67      * 账号之间代币交易转移
68      * @param _from 发送者地址
69      * @param _to 接收者地址
70      * @param _value 转移数额
71      */
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
73         require(_value <= allowance[_from][msg.sender]);     // Check allowance
74         allowance[_from][msg.sender] -= _value;
75         _transfer(_from, _to, _value);
76         return true;
77     }
78 
79     /**
80      * 设置某个地址（合约）可以创建交易者名义花费的代币数。
81      *
82      * 允许发送者`_spender` 花费不多于 `_value` 个代币
83      *
84      * @param _spender The address authorized to spend
85      * @param _value the max amount they can spend
86      */
87     function approve(address _spender, uint256 _value) public
88         returns (bool success) {
89         allowance[msg.sender][_spender] = _value;
90         return true;
91     }
92 
93     /**
94      * 设置允许一个地址（合约）以我（创建交易者）的名义可最多花费的代币数。
95      *
96      * @param _spender 被授权的地址（合约）
97      * @param _value 最大可花费代币数
98      * @param _extraData 发送给合约的附加数据
99      */
100     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
101         public
102         returns (bool success) {
103         tokenRecipient spender = tokenRecipient(_spender);
104         if (approve(_spender, _value)) {
105             // 通知合约
106             spender.receiveApproval(msg.sender, _value, this, _extraData);
107             return true;
108         }
109     }
110 
111     /**
112      * 销毁我（创建交易者）账户中指定个代币
113      */
114     function burn(uint256 _value) public returns (bool success) {
115         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
116         balanceOf[msg.sender] -= _value;            // Subtract from the sender
117         totalSupply -= _value;                      // Updates totalSupply
118         Burn(msg.sender, _value);
119         return true;
120     }
121 
122     /**
123      * 销毁用户账户中指定个代币
124      *
125      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
126      *
127      * @param _from the address of the sender
128      * @param _value the amount of money to burn
129      */
130     function burnFrom(address _from, uint256 _value) public returns (bool success) {
131         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
132         require(_value <= allowance[_from][msg.sender]);    // Check allowance
133         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
134         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
135         totalSupply -= _value;                              // Update totalSupply
136         Burn(_from, _value);
137         return true;
138     }
139 }