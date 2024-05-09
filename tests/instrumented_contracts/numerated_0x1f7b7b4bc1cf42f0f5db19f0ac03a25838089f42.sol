1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient {
4     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
5 }
6 
7 contract WakerCoin {
8     //token的公共变量
9     string public name;
10     string public symbol;
11     uint8 public decimals = 18;  
12     // decimals 可以有的小数点个数，最小的代币单位。18 是建议的默认值
13     uint256 public totalSupply;
14 
15     // 用mapping保存每个地址对应的余额
16     mapping (address => uint256) public balanceOf;
17     // 存储对账号的控制
18     mapping (address => mapping (address => uint256)) public allowance;
19 
20     // 在区块链上触发一个公共事件，用来通知客户端交易发生
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     
23     // 在区块链上触发一个公共事件，用来通知客户端确认
24     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
25 
26     // 事件，用来通知客户端代币被销毁
27     event Burn(address indexed from, uint256 value);
28 
29     /**
30      * 初始化构造
31      * 利用合约创建者的初始化token供给数初始化合约
32      */
33     constructor(
34         uint256 initialSupply, 
35         string memory tokenName, 
36         string memory tokenSymbol
37     ) public {
38         totalSupply = initialSupply * 10 ** uint256(decimals);  // 供应的份额，份额跟最小的代币单位有关，份额 = 币数 * 10 ** decimals。
39         balanceOf[msg.sender] = totalSupply;                // 创建者拥有所有的代币
40         name = tokenName;                                   // 代币名称
41         symbol = tokenSymbol;                               // 代币符号
42     }
43 
44     /**
45      * 代币交易转移的内部实现
46      */
47     function _transfer(address _from, address _to, uint _value) internal {
48         // 确保目标地址不为0x0，因为0x0地址代表销毁
49         require(_to != address(0x0));
50         // 检查发送者余额
51         require(balanceOf[_from] >= _value);
52         // 检查溢出
53         require(balanceOf[_to] + _value > balanceOf[_to]);
54 
55         // 保存原先值后面使用
56         uint previousBalances = balanceOf[_from] + balanceOf[_to];
57         // 减发送者余额
58         balanceOf[_from] -= _value;
59         // 加接收者余额
60         balanceOf[_to] += _value;
61         emit Transfer(_from, _to, _value);
62 
63         // 用assert来检查代码逻辑。
64         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
65     }
66 
67     /**
68      *  代币交易转移
69      * 从自己（创建交易者）账号发送`_value`个代币到 `_to`账号
70      *
71      * @param _to 接收者地址
72      * @param _value 转移数额
73      */
74     function transfer(address _to, uint256 _value) public returns (bool success) {
75         _transfer(msg.sender, _to, _value);
76         return true;
77     }
78 
79     /**
80      * 账号之间代币交易转移
81      * @param _from 发送者地址
82      * @param _to 接收者地址
83      * @param _value 转移数额
84      */
85     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
86         require(_value <= allowance[_from][msg.sender]);     // Check allowance
87         allowance[_from][msg.sender] -= _value;
88         _transfer(_from, _to, _value);
89         return true;
90     }
91 
92     /**
93      * 设置某个地址（合约）可以创建交易者名义花费的代币数。
94      *
95      * 允许发送者`_spender` 花费不多于 `_value` 个代币
96      *
97      * @param _spender The address authorized to spend
98      * @param _value the max amount they can spend
99      */
100     function approve(address _spender, uint256 _value) public
101         returns (bool success) {
102         allowance[msg.sender][_spender] = _value;
103         emit Approval(msg.sender, _spender, _value);
104         return true;
105     }
106 
107     /**
108      * 设置允许一个地址（合约）以我（创建交易者）的名义可最多花费的代币数。
109      *
110      * @param _spender 被授权的地址（合约）
111      * @param _value 最大可花费代币数
112      * @param _extraData 发送给合约的附加数据
113      */
114     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
115         public
116         returns (bool success) {
117         tokenRecipient spender = tokenRecipient(_spender);
118         if (approve(_spender, _value)) {
119             // 通知合约
120             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
121             return true;
122         }
123     }
124 
125     /**
126      * 销毁我（创建交易者）账户中指定个代币
127      */
128     function burn(uint256 _value) public returns (bool success) {
129         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
130         balanceOf[msg.sender] -= _value;            // Subtract from the sender
131         totalSupply -= _value;                      // Updates totalSupply
132         emit Burn(msg.sender, _value);
133         return true;
134     }
135 
136     /**
137      * 销毁用户账户中指定个代币
138      *
139      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
140      *
141      * @param _from the address of the sender
142      * @param _value the amount of money to burn
143      */
144     function burnFrom(address _from, uint256 _value) public returns (bool success) {
145         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
146         require(_value <= allowance[_from][msg.sender]);    // Check allowance
147         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
148         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
149         totalSupply -= _value;                              // Update totalSupply
150         emit Burn(_from, _value);
151         return true;
152     }
153 }