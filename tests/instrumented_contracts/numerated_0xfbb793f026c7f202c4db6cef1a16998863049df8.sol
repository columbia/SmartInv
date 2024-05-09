1 /**
2  *Submitted for verification at Etherscan.io on 2020-01-08
3 */
4 
5 pragma solidity ^0.4.19;
6  
7 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
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
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27     
28     /**
29      * 初始化构造
30      */
31     constructor(uint256 initialSupply, string tokenName, string tokenSymbol) public{
32         totalSupply = initialSupply * 10 ** uint256(decimals);  // 供应的份额，份额跟最小的代币单位有关，份额 = 币数 * 10 ** decimals。
33         balanceOf[msg.sender] = totalSupply;                // 创建者拥有所有的代币
34         name = tokenName;                                   // 代币名称
35         symbol = tokenSymbol;                               // 代币符号
36     }
37  
38     /**
39      * 代币交易转移的内部实现
40      */
41     function _transfer(address _from, address _to, uint _value) internal {
42         // 确保目标地址不为0x0，因为0x0地址代表销毁
43         require(_to != 0x0);
44         // 检查发送者余额
45         require(balanceOf[_from] >= _value);
46         // 确保转移为正数个
47         require(balanceOf[_to] + _value > balanceOf[_to]);
48  
49         // 以下用来检查交易，
50         uint previousBalances = balanceOf[_from] + balanceOf[_to];
51         // Subtract from the sender
52         balanceOf[_from] -= _value;
53         // Add the same to the recipient
54         balanceOf[_to] += _value;
55         emit Transfer(_from, _to, _value);
56  
57         // 用assert来检查代码逻辑。
58         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
59     }
60  
61     /**
62      *  代币交易转移
63      * 从自己（创建交易者）账号发送`_value`个代币到 `_to`账号
64      *
65      * @param _to 接收者地址
66      * @param _value 转移数额
67      */
68     function transfer(address _to, uint256 _value) public returns (bool success) {
69         _transfer(msg.sender, _to, _value);
70         return true;
71     }
72  
73     /**
74      * 账号之间代币交易转移
75      * @param _from 发送者地址
76      * @param _to 接收者地址
77      * @param _value 转移数额
78      */
79     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
80         require(_value <= allowance[_from][msg.sender]);     // Check allowance
81         allowance[_from][msg.sender] -= _value;
82         _transfer(_from, _to, _value);
83         return true;
84     }
85  
86     /**
87      * 设置某个地址（合约）可以创建交易者名义花费的代币数。
88      *
89      * 允许发送者`_spender` 花费不多于 `_value` 个代币
90      *
91      * @param _spender The address authorized to spend
92      * @param _value the max amount they can spend
93      */
94     function approve(address _spender, uint256 _value) public
95         returns (bool success) {
96         allowance[msg.sender][_spender] = _value;
97         emit Approval(msg.sender,_spender,_value);
98         return true;
99     }
100  
101     /**
102      * 设置允许一个地址（合约）以我（创建交易者）的名义可最多花费的代币数。
103      *
104      * @param _spender 被授权的地址（合约）
105      * @param _value 最大可花费代币数
106      * @param _extraData 发送给合约的附加数据
107      */
108     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
109         public
110         returns (bool success) {
111         tokenRecipient spender = tokenRecipient(_spender);
112         if (approve(_spender, _value)) {
113             // 通知合约
114             spender.receiveApproval(msg.sender, _value, this, _extraData);
115             return true;
116         }
117     }
118  
119     /**
120      * 销毁我（创建交易者）账户中指定个代币
121      */
122     function burn(uint256 _value) public returns (bool success) {
123         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
124         balanceOf[msg.sender] -= _value;            // Subtract from the sender
125         totalSupply -= _value;                      // Updates totalSupply
126         emit Burn(msg.sender, _value);
127         return true;
128     }
129  
130     /**
131      * 销毁用户账户中指定个代币
132      *
133      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
134      *
135      * @param _from the address of the sender
136      * @param _value the amount of money to burn
137      */
138     function burnFrom(address _from, uint256 _value) public returns (bool success) {
139         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
140         require(_value <= allowance[_from][msg.sender]);    // Check allowance
141         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
142         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
143         totalSupply -= _value;                              // Update totalSupply
144         emit Burn(_from, _value);
145         return true;
146     }
147 }