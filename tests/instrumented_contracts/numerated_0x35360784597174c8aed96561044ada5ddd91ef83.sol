1 pragma solidity ^0.4.20;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract OREOtoken {
6     string public name = "OREO";
7     string public symbol = "OREO";
8     uint8 public decimals = 18;  // decimals 可以有的小数点个数，最小的代币单位。18 是建议的默认值
9     uint256 public totalSupply = 1000000000000000000000000000;
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
25     constructor() public {
26         balanceOf[msg.sender] = totalSupply;                // 创建者拥有所有的代币
27     }
28 
29     /**
30      * 代币交易转移的内部实现
31      */
32     function _transfer(address _from, address _to, uint _value) internal {
33         // 确保目标地址不为0x0，因为0x0地址代表销毁
34         require(_to != 0x0);
35         // 检查发送者余额
36         require(balanceOf[_from] >= _value);
37         // 确保转移为正数个
38         require(balanceOf[_to] + _value > balanceOf[_to]);
39 
40         // 以下用来检查交易，
41         uint previousBalances = balanceOf[_from] + balanceOf[_to];
42         // Subtract from the sender
43         balanceOf[_from] -= _value;
44         // Add the same to the recipient
45         balanceOf[_to] += _value;
46         emit Transfer(_from, _to, _value);
47 
48         // 用assert来检查代码逻辑。
49         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
50     }
51 
52     /**
53      *  代币交易转移
54      * 从创建交易者账号发送`_value`个代币到 `_to`账号
55      *
56      * @param _to 接收者地址
57      * @param _value 转移数额
58      */
59     function transfer(address _to, uint256 _value) public {
60         _transfer(msg.sender, _to, _value);
61     }
62 
63     /**
64      * 账号之间代币交易转移
65      * @param _from 发送者地址
66      * @param _to 接收者地址
67      * @param _value 转移数额
68      */
69     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
70         require(_value <= allowance[_from][msg.sender]);     // Check allowance
71         allowance[_from][msg.sender] -= _value;
72         _transfer(_from, _to, _value);
73         return true;
74     }
75 
76     /**
77      * 设置某个地址（合约）可以交易者名义花费的代币数。
78      *
79      * 允许发送者`_spender` 花费不多于 `_value` 个代币
80      *
81      * @param _spender The address authorized to spend
82      * @param _value the max amount they can spend
83      */
84     function approve(address _spender, uint256 _value) public
85         returns (bool success) {
86         allowance[msg.sender][_spender] = _value;
87         return true;
88     }
89 
90     /**
91      * 设置允许一个地址（合约）以交易者名义可最多花费的代币数。
92      *
93      * @param _spender 被授权的地址（合约）
94      * @param _value 最大可花费代币数
95      * @param _extraData 发送给合约的附加数据
96      */
97     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
98         public
99         returns (bool success) {
100         tokenRecipient spender = tokenRecipient(_spender);
101         if (approve(_spender, _value)) {
102             spender.receiveApproval(msg.sender, _value, this, _extraData);
103             return true;
104         }
105     }
106 
107     /**
108      * 销毁创建者账户中指定个代币
109      */
110     function burn(uint256 _value) public returns (bool success) {
111         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
112         balanceOf[msg.sender] -= _value;            // Subtract from the sender
113         totalSupply -= _value;                      // Updates totalSupply
114         emit Burn(msg.sender, _value);
115         return true;
116     }
117 
118     /**
119      * 销毁用户账户中指定个代币
120      *
121      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
122      *
123      * @param _from the address of the sender
124      * @param _value the amount of money to burn
125      */
126     function burnFrom(address _from, uint256 _value) public returns (bool success) {
127         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
128         require(_value <= allowance[_from][msg.sender]);    // Check allowance
129         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
130         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
131         totalSupply -= _value;                              // Update totalSupply
132         emit Burn(_from, _value);
133         return true;
134     }
135 }