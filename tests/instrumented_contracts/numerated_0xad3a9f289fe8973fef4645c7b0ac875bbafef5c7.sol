1 pragma solidity ^0.4.16;
2 /* 创建一个父类， 账户管理员 */
3 contract owned {
4 
5     address public owner;
6 
7     function owned() public {
8     owner = msg.sender;
9     }
10 
11     /* modifier是修改标志 */
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     /* 修改管理员账户， onlyOwner代表只能是用户管理员来修改 */
18     function transferOwnership(address newOwner) onlyOwner public {
19         owner = newOwner;
20     }   
21 }
22 
23 /* receiveApproval服务合约指示代币合约将代币从发送者的账户转移到服务合约的账户（通过调用服务合约的 */
24 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
25 
26 contract TokenERC20 {
27     // 代币（token）的公共变量
28     string public name;             //代币名字
29     string public symbol;           //代币符号
30     uint8 public decimals = 18;     //代币小数点位数， 18是默认， 尽量不要更改
31 
32     uint256 public totalSupply;     //代币总量
33 
34     // 记录各个账户的代币数目
35     mapping (address => uint256) public balanceOf;
36 
37     // A账户存在B账户资金
38     mapping (address => mapping (address => uint256)) public allowance;
39 
40     // 转账通知事件
41     event Transfer(address indexed from, address indexed to, uint256 value);
42 
43     // 销毁金额通知事件
44     event Burn(address indexed from, uint256 value);
45 
46     /* 构造函数 */
47     function TokenERC20(
48         uint256 initialSupply,
49         string tokenName,
50         string tokenSymbol
51     ) public {
52         totalSupply = initialSupply * 10 ** uint256(decimals);  // 根据decimals计算代币的数量
53         balanceOf[msg.sender] = totalSupply;                    // 给生成者所有的代币数量
54         name = tokenName;                                       // 设置代币的名字
55         symbol = tokenSymbol;                                   // 设置代币的符号
56     }
57 
58     /* 私有的交易函数 */
59     function _transfer(address _from, address _to, uint _value) internal {
60         // 防止转移到0x0， 用burn代替这个功能
61         require(_to != 0x0);
62         // 检测发送者是否有足够的资金
63         require(balanceOf[_from] >= _value);
64         // 检查是否溢出（数据类型的溢出）
65         require(balanceOf[_to] + _value > balanceOf[_to]);
66         // 将此保存为将来的断言， 函数最后会有一个检验
67         uint previousBalances = balanceOf[_from] + balanceOf[_to];
68         // 减少发送者资产
69         balanceOf[_from] -= _value;
70         // 增加接收者的资产
71         balanceOf[_to] += _value;
72         Transfer(_from, _to, _value);
73         // 断言检测， 不应该为错
74         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
75     }
76 
77     /* 传递tokens */
78     function transfer(address _to, uint256 _value) public {
79         _transfer(msg.sender, _to, _value);
80     }
81 
82     /* 从其他账户转移资产 */
83     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
84         require(_value <= allowance[_from][msg.sender]);     // Check allowance
85         allowance[_from][msg.sender] -= _value;
86         _transfer(_from, _to, _value);
87         return true;
88     }
89 
90     /*  授权第三方从发送者账户转移代币，然后通过transferFrom()函数来执行第三方的转移操作 */
91     function approve(address _spender, uint256 _value) public
92         returns (bool success) {
93         allowance[msg.sender][_spender] = _value;
94         return true;
95     }
96 
97     /*
98     为其他地址设置津贴， 并通知
99     发送者通知代币合约, 代币合约通知服务合约receiveApproval, 服务合约指示代币合约将代币从发送者的账户转移到服务合约的账户（通过调用服务合约的transferFrom)
100     */
101 
102     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
103         public
104         returns (bool success) {
105         tokenRecipient spender = tokenRecipient(_spender);
106         if (approve(_spender, _value)) {
107             spender.receiveApproval(msg.sender, _value, this, _extraData);
108             return true;
109         }
110     }
111 
112     /**
113     * 销毁代币
114     */
115     function burn(uint256 _value) public returns (bool success) {
116         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
117         balanceOf[msg.sender] -= _value;            // Subtract from the sender
118         totalSupply -= _value;                      // Updates totalSupply
119         Burn(msg.sender, _value);
120         return true;
121     }
122 
123     /**
124     * 从其他账户销毁代币
125     */
126     function burnFrom(address _from, uint256 _value) public returns (bool success) {
127         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
128         require(_value <= allowance[_from][msg.sender]);    // Check allowance
129         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
130         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
131         totalSupply -= _value;                              // Update totalSupply
132         Burn(_from, _value);
133         return true;
134     }
135 }
136 
137 /******************************************/
138 /*       ADVANCED TOKEN STARTS HERE       */
139 /******************************************/
140 
141 contract BVTCcoin is owned, TokenERC20 {
142 
143     uint256 public sellPrice;
144     uint256 public buyPrice;
145 
146     /* 冻结账户 */
147     mapping (address => bool) public frozenAccount;
148 
149     /* This generates a public event on the blockchain that will notify clients */
150     event FrozenFunds(address target, bool frozen);
151 
152     /* 构造函数 */
153     function BVTCcoin(
154         uint256 initialSupply,
155         string tokenName,
156         string tokenSymbol
157     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
158 
159     /* 转账， 比父类加入了账户冻结 */
160     function _transfer(address _from, address _to, uint _value) internal {
161         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
162         require (balanceOf[_from] >= _value);               // Check if the sender has enough
163         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
164         require(!frozenAccount[_from]);                     // Check if sender is frozen
165         require(!frozenAccount[_to]);                       // Check if recipient is frozen
166         balanceOf[_from] -= _value;                         // Subtract from the sender
167         balanceOf[_to] += _value;                           // Add the same to the recipient
168         Transfer(_from, _to, _value);
169     }
170 
171 /// 向指定账户增发资金
172     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
173         balanceOf[target] += mintedAmount;
174         totalSupply += mintedAmount;
175         Transfer(0, this, mintedAmount);
176         Transfer(this, target, mintedAmount);
177 
178     }
179 
180 
181     /// 冻结 or 解冻账户
182     function freezeAccount(address target, bool freeze) onlyOwner public {
183         frozenAccount[target] = freeze;
184         FrozenFunds(target, freeze);
185     }
186 
187     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
188         sellPrice = newSellPrice;
189         buyPrice = newBuyPrice;
190     }
191 
192     /// @notice Buy tokens from contract by sending ether
193     function buy() payable public {
194         uint amount = msg.value / buyPrice;               // calculates the amount
195         _transfer(this, msg.sender, amount);              // makes the transfers
196     }
197 
198     function sell(uint256 amount) public {
199         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
200         _transfer(msg.sender, this, amount);              // makes the transfers
201         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
202     }
203 }