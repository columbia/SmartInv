1 contract owned {
2     address public owner;
3 
4     function owned() {
5         owner = msg.sender;
6     }
7 
8     modifier onlyOwner {
9         if (msg.sender != owner) throw;
10         _;
11     }
12 
13     function transferOwnership(address newOwner) onlyOwner {
14         owner = newOwner;
15     }
16 }
17 
18 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
19 
20 contract token {
21     /* 令牌的公开变量 */
22     string public standard = 'Token 0.1';
23     string public name;
24     string public symbol;
25     uint8 public decimals;
26     uint256 public totalSupply;
27 
28     /* 所有账本的数组 */
29     mapping (address => uint256) public balanceOf;
30     mapping (address => mapping (address => uint256)) public allowance;
31 
32     /* 定义一个事件，当交易发生时，通知客户端 */
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 
35     /* 初始化合约 */
36     function token(
37         uint256 initialSupply,
38         string tokenName,
39         uint8 decimalUnits,
40         string tokenSymbol
41         ) {
42         balanceOf[msg.sender] = initialSupply;              // 合约的创建者拥有这合约所有的初始令牌
43         totalSupply = initialSupply;                        // 更新令牌供给总数
44         name = tokenName;                                   // 设置令牌的名字
45         symbol = tokenSymbol;                               // 设置令牌的符号
46         decimals = decimalUnits;                            // 设置令牌的小数位
47     }
48 
49     /* 发送令牌 */
50     function transfer(address _to, uint256 _value) {
51         if (balanceOf[msg.sender] < _value) throw;           // 检查这发送者是否有足够多的令牌
52         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // 检查溢出
53         balanceOf[msg.sender] -= _value;                     // 从发送者账户减去相应的额度
54         balanceOf[_to] += _value;                            // 从接收者账户增加相应的额度
55         Transfer(msg.sender, _to, _value);                   // 事件。通知所有正在监听这个合约的用户
56     }
57 
58     /* Allow another contract to spend some tokens in your behalf */
59     function approve(address _spender, uint256 _value)
60         returns (bool success) {
61         allowance[msg.sender][_spender] = _value;
62         return true;
63     }
64 
65     /* Approve and then communicate the approved contract in a single tx */
66     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
67         returns (bool success) {    
68         tokenRecipient spender = tokenRecipient(_spender);
69         if (approve(_spender, _value)) {
70             spender.receiveApproval(msg.sender, _value, this, _extraData);
71             return true;
72         }
73     }
74 
75     /* A contract attempts to get the coins */
76     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
77         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
78         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
79         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
80         balanceOf[_from] -= _value;                          // Subtract from the sender
81         balanceOf[_to] += _value;                            // Add the same to the recipient
82         allowance[_from][msg.sender] -= _value;
83         Transfer(_from, _to, _value);
84         return true;
85     }
86 
87     /* 匿名方法，预防有人向这合约发送以太币 */
88     function () {
89         throw;     
90     }
91 }
92 
93 contract TlzsToken is owned, token {
94 
95 
96     mapping (address => bool) public frozenAccount;
97 
98     /* 定义一个事件，当有资产被冻结的时候，通知正在监听事件的客户端 */
99     event FrozenFunds(address target, bool frozen);
100 
101     /* 初始化合约 */
102     function TlzsToken(
103         uint256 initialSupply,
104         string tokenName,
105         uint8 decimalUnits,
106         string tokenSymbol
107     ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
108 
109     /* 发送令牌 */
110     function transfer(address _to, uint256 _value) {
111         if (balanceOf[msg.sender] < _value) throw;           // 检查发送者是否有足够多的令牌
112         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // 检查溢出
113         if (frozenAccount[msg.sender]) throw;                // 检查冻结状态
114         balanceOf[msg.sender] -= _value;                     // 从发送者的账户上减去相应的数额
115         balanceOf[_to] += _value;                            // 从接收者的账户上增加相应的数额
116         Transfer(msg.sender, _to, _value);                   // 事件通知
117     }
118 
119 
120     /* A contract attempts to get the coins */
121     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
122         if (frozenAccount[_from]) throw;                        // Check if frozen            
123         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
124         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
125         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
126         balanceOf[_from] -= _value;                          // Subtract from the sender
127         balanceOf[_to] += _value;                            // Add the same to the recipient
128         allowance[_from][msg.sender] -= _value;
129         Transfer(_from, _to, _value);
130         return true;
131     }
132 
133     function freezeAccount(address target, bool freeze) onlyOwner {
134         frozenAccount[target] = freeze;
135         FrozenFunds(target, freeze);
136     }
137 }