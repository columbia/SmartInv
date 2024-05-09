1 /* MVG合约 */
2 pragma solidity ^0.4.16;
3 /* 创建一个父类， 账户管理员 */
4 contract owned {
5 
6     address public owner;
7 
8     function owned() public {
9     owner = msg.sender;
10     }
11 
12     /* modifier是修改标志 */
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     /* 修改管理员账户， onlyOwner代表只能是用户管理员来修改 */
19     function transferOwnership(address newOwner) onlyOwner public {
20         owner = newOwner;
21     }   
22 }
23 
24 /* receiveApproval服务合约指示代币合约将代币从发送者的账户转移到服务合约的账户（通过调用服务合约的 */
25 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
26 
27 contract TokenERC20 {
28     // 代币（token）的公共变量
29     string public name;             //代币名字
30     string public symbol;           //代币符号
31     uint8 public decimals = 18;     //代币小数点位数， 18是默认， 尽量不要更改
32 
33     uint256 public totalSupply;     //代币总量
34 
35     // 记录各个账户的代币数目
36     mapping (address => uint256) public balanceOf;
37 
38     // A账户存在B账户资金
39     mapping (address => mapping (address => uint256)) public allowance;
40 
41     // 转账通知事件
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 
44     // 销毁金额通知事件
45     event Burn(address indexed from, uint256 value);
46 
47     /* 构造函数 */
48     function TokenERC20(
49         uint256 initialSupply,
50         string tokenName,
51         string tokenSymbol
52     ) public {
53         totalSupply = initialSupply * 10 ** uint256(decimals);  // 根据decimals计算代币的数量
54         balanceOf[msg.sender] = totalSupply;                    // 给生成者所有的代币数量
55         name = tokenName;                                       // 设置代币的名字
56         symbol = tokenSymbol;                                   // 设置代币的符号
57     }
58 
59     /* 私有的交易函数 */
60     function _transfer(address _from, address _to, uint _value) internal {
61         // 防止转移到0x0， 用burn代替这个功能
62         require(_to != 0x0);
63         // 检测发送者是否有足够的资金
64         require(balanceOf[_from] >= _value);
65         // 检查是否溢出（数据类型的溢出）
66         require(balanceOf[_to] + _value > balanceOf[_to]);
67         // 将此保存为将来的断言， 函数最后会有一个检验
68         uint previousBalances = balanceOf[_from] + balanceOf[_to];
69         // 减少发送者资产
70         balanceOf[_from] -= _value;
71         // 增加接收者的资产
72         balanceOf[_to] += _value;
73         Transfer(_from, _to, _value);
74         // 断言检测， 不应该为错
75         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
76     }
77 
78     /* 传递tokens */
79     function transfer(address _to, uint256 _value) public {
80         _transfer(msg.sender, _to, _value);
81     }
82 
83     /* 从其他账户转移资产 */
84     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
85         require(_value <= allowance[_from][msg.sender]);     // Check allowance
86         allowance[_from][msg.sender] -= _value;
87         _transfer(_from, _to, _value);
88         return true;
89     }
90 
91     /*  授权第三方从发送者账户转移代币，然后通过transferFrom()函数来执行第三方的转移操作 */
92     function approve(address _spender, uint256 _value) public
93         returns (bool success) {
94         allowance[msg.sender][_spender] = _value;
95         return true;
96     }
97 
98     /*
99     为其他地址设置津贴， 并通知
100     发送者通知代币合约, 代币合约通知服务合约receiveApproval, 服务合约指示代币合约将代币从发送者的账户转移到服务合约的账户（通过调用服务合约的transferFrom)
101     */
102 
103     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
104         public
105         returns (bool success) {
106         tokenRecipient spender = tokenRecipient(_spender);
107         if (approve(_spender, _value)) {
108             spender.receiveApproval(msg.sender, _value, this, _extraData);
109             return true;
110         }
111     }
112 
113     /**
114     * 销毁代币
115     */
116     function burn(uint256 _value) public returns (bool success) {
117         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
118         balanceOf[msg.sender] -= _value;            // Subtract from the sender
119         totalSupply -= _value;                      // Updates totalSupply
120         Burn(msg.sender, _value);
121         return true;
122     }
123 
124     /**
125     * 从其他账户销毁代币
126     */
127     function burnFrom(address _from, uint256 _value) public returns (bool success) {
128         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
129         require(_value <= allowance[_from][msg.sender]);    // Check allowance
130         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
131         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
132         totalSupply -= _value;                              // Update totalSupply
133         Burn(_from, _value);
134         return true;
135     }
136 }
137 
138 /******************************************/
139 /*       ADVANCED TOKEN STARTS HERE       */
140 /******************************************/
141 
142 contract MVGcoin is owned, TokenERC20 {
143 
144     uint256 public sellPrice;
145     uint256 public buyPrice;
146 
147     /* 冻结账户 */
148     mapping (address => bool) public frozenAccount;
149 
150     /* This generates a public event on the blockchain that will notify clients */
151     event FrozenFunds(address target, bool frozen);
152 
153     /* 构造函数 */
154     function MVGcoin(
155         uint256 initialSupply,
156         string tokenName,
157         string tokenSymbol
158     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
159 
160     /* 转账， 比父类加入了账户冻结 */
161     function _transfer(address _from, address _to, uint _value) internal {
162         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
163         require (balanceOf[_from] >= _value);               // Check if the sender has enough
164         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
165         require(!frozenAccount[_from]);                     // Check if sender is frozen
166         require(!frozenAccount[_to]);                       // Check if recipient is frozen
167         balanceOf[_from] -= _value;                         // Subtract from the sender
168         balanceOf[_to] += _value;                           // Add the same to the recipient
169         Transfer(_from, _to, _value);
170     }
171 
172 /// 向指定账户增发资金
173     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
174         balanceOf[target] += mintedAmount;
175         totalSupply += mintedAmount;
176         Transfer(0, this, mintedAmount);
177         Transfer(this, target, mintedAmount);
178 
179     }
180 
181 
182     /// 冻结 or 解冻账户
183     function freezeAccount(address target, bool freeze) onlyOwner public {
184         frozenAccount[target] = freeze;
185         FrozenFunds(target, freeze);
186     }
187 
188     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
189         sellPrice = newSellPrice;
190         buyPrice = newBuyPrice;
191     }
192 
193     /// @notice Buy tokens from contract by sending ether
194     function buy() payable public {
195         uint amount = msg.value / buyPrice;               // calculates the amount
196         _transfer(this, msg.sender, amount);              // makes the transfers
197     }
198 
199     function sell(uint256 amount) public {
200         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
201         _transfer(msg.sender, this, amount);              // makes the transfers
202         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
203     }
204 }