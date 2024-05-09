1 pragma solidity ^0.4.16;
2 
3 contract SusanTokenERC20 {
4     string public name;
5     string public symbol;
6     uint8 public decimals = 4;  // decimals 可以有的小数点个数，最小的代币单位。18 是建议的默认值
7     uint256 public totalSupply;
8 
9     // 用mapping保存每个地址对应的余额
10     mapping (address => uint256) public balanceOf;
11     // 存储对账号的控制
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     // 事件，用来通知客户端交易发生
15     event Transfer(address indexed from, address indexed to, uint256 value);
16 
17     // 事件，用来通知客户端代币被消费
18     event Burn(address indexed from, uint256 value);
19 
20     /**
21      * 初始化构造
22      */
23     function SusanTokenERC20() public {
24         totalSupply = 100000000 * 10 ** uint256(decimals);  // 供应的份额，份额跟最小的代币单位有关，份额 = 币数 * 10 ** decimals。
25         balanceOf[msg.sender] = totalSupply;                // 创建者拥有所有的代币
26         name = "SusanToken";                                   // 代币名称
27         symbol = "SUTK";                               // 代币符号
28     }
29 
30     /**
31      * 代币交易转移的内部实现
32      */
33     function _transfer(address _from, address _to, uint _value) internal {
34         // 确保目标地址不为0x0，因为0x0地址代表销毁
35         require(_to != 0x0);
36         // 检查发送者余额
37         require(balanceOf[_from] >= _value);
38         // 确保转移为正数个
39         require(balanceOf[_to] + _value > balanceOf[_to]);
40 
41         // 以下用来检查交易，
42         uint previousBalances = balanceOf[_from] + balanceOf[_to];
43         // Subtract from the sender
44         balanceOf[_from] -= _value;
45         // Add the same to the recipient
46         balanceOf[_to] += _value;
47         Transfer(_from, _to, _value);
48 
49         // 用assert来检查代码逻辑。
50         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
51     }
52 
53     /**
54      *  代币交易转移
55      * 从自己（创建交易者）账号发送`_value`个代币到 `_to`账号
56      *
57      * @param _to 接收者地址
58      * @param _value 转移数额
59      */
60     function transfer(address _to, uint256 _value) public {
61         _transfer(msg.sender, _to, _value);
62     }
63 
64     /**
65      * 账号之间代币交易转移
66      * @param _from 发送者地址
67      * @param _to 接收者地址
68      * @param _value 转移数额
69      */
70     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
71         require(_value <= allowance[_from][msg.sender]);     // Check allowance
72         allowance[_from][msg.sender] -= _value;
73         _transfer(_from, _to, _value);
74         return true;
75     }
76 
77     /**
78      * 设置某个地址（合约）可以创建交易者名义花费的代币数。
79      *
80      * 允许发送者`_spender` 花费不多于 `_value` 个代币
81      *
82      * @param _spender The address authorized to spend
83      * @param _value the max amount they can spend
84      */
85     function approve(address _spender, uint256 _value) public
86         returns (bool success) {
87         allowance[msg.sender][_spender] = _value;
88         return true;
89     }
90 
91     
92     /**
93      * 销毁我（创建交易者）账户中指定个代币
94      */
95     function burn(uint256 _value) public returns (bool success) {
96         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
97         balanceOf[msg.sender] -= _value;            // Subtract from the sender
98         totalSupply -= _value;                      // Updates totalSupply
99         Burn(msg.sender, _value);
100         return true;
101     }
102 
103     /**
104      * 销毁用户账户中指定个代币
105      *
106      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
107      *
108      * @param _from the address of the sender
109      * @param _value the amount of money to burn
110      */
111     function burnFrom(address _from, uint256 _value) public returns (bool success) {
112         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
113         require(_value <= allowance[_from][msg.sender]);    // Check allowance
114         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
115         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
116         totalSupply -= _value;                              // Update totalSupply
117         Burn(_from, _value);
118         return true;
119     }
120 
121 
122    function mintToken(address target, uint256 initialSupply) public{
123         balanceOf[target] += initialSupply;
124         totalSupply += initialSupply;
125         Transfer(0, msg.sender, initialSupply);
126         Transfer(msg.sender, target,initialSupply);
127 
128     }
129 
130 
131 
132 }