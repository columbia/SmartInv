1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract TokenERC20 {
23     string public name;
24     string public symbol;
25     uint8 public decimals = 18;  // decimals 可以有的小数点个数，最小的代币单位。18 是建议的默认值
26     uint256 public totalSupply;
27 
28     // 用mapping保存每个地址对应的余额
29     mapping (address => uint256) public balanceOf;
30     // 存储对账号的控制
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     // 事件，用来通知客户端交易发生
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     // 事件，用来通知客户端代币被消费
37     event Burn(address indexed from, uint256 value);
38 
39     /**
40      * 初始化构造
41      */
42     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
43         totalSupply = initialSupply * 10 ** uint256(decimals);  // 供应的份额，份额跟最小的代币单位有关，份额 = 币数 * 10 ** decimals。
44         balanceOf[msg.sender] = totalSupply;                // 创建者拥有所有的代币
45         name = tokenName;                                   // 代币名称
46         symbol = tokenSymbol;                               // 代币符号
47     }
48 
49     /**
50      * 代币交易转移的内部实现
51      */
52     function _transfer(address _from, address _to, uint _value) internal {
53         // 确保目标地址不为0x0，因为0x0地址代表销毁
54         require(_to != 0x0);
55         // 检查发送者余额
56         require(balanceOf[_from] >= _value);
57         // 确保转移为正数个
58         require(balanceOf[_to] + _value > balanceOf[_to]);
59 
60         // 以下用来检查交易，
61         uint previousBalances = balanceOf[_from] + balanceOf[_to];
62         // Subtract from the sender
63         balanceOf[_from] -= _value;
64         // Add the same to the recipient
65         balanceOf[_to] += _value;
66         Transfer(_from, _to, _value);
67 
68         // 用assert来检查代码逻辑。
69         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
70     }
71 
72     /**
73      *  代币交易转移
74      * 从创建交易者账号发送`_value`个代币到 `_to`账号
75      *
76      * @param _to 接收者地址
77      * @param _value 转移数额
78      */
79     function transfer(address _to, uint256 _value) public {
80         _transfer(msg.sender, _to, _value);
81     }
82 
83     /**
84      * 账号之间代币交易转移
85      * @param _from 发送者地址
86      * @param _to 接收者地址
87      * @param _value 转移数额
88      */
89     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
90         require(_value <= allowance[_from][msg.sender]);     // Check allowance
91         allowance[_from][msg.sender] -= _value;
92         _transfer(_from, _to, _value);
93         return true;
94     }
95 
96     /**
97      * 设置某个地址（合约）可以交易者名义花费的代币数。
98      *
99      * 允许发送者`_spender` 花费不多于 `_value` 个代币
100      *
101      * @param _spender The address authorized to spend
102      * @param _value the max amount they can spend
103      */
104     function approve(address _spender, uint256 _value) public
105         returns (bool success) {
106         allowance[msg.sender][_spender] = _value;
107         return true;
108     }
109 
110     /**
111      * 设置允许一个地址（合约）以交易者名义可最多花费的代币数。
112      *
113      * @param _spender 被授权的地址（合约）
114      * @param _value 最大可花费代币数
115      * @param _extraData 发送给合约的附加数据
116      */
117     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
118         public
119         returns (bool success) {
120         tokenRecipient spender = tokenRecipient(_spender);
121         if (approve(_spender, _value)) {
122             spender.receiveApproval(msg.sender, _value, this, _extraData);
123             return true;
124         }
125     }
126 
127     /**
128      * 销毁创建者账户中指定个代币
129      */
130     function burn(uint256 _value) public returns (bool success) {
131         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
132         balanceOf[msg.sender] -= _value;            // Subtract from the sender
133         totalSupply -= _value;                      // Updates totalSupply
134         Burn(msg.sender, _value);
135         return true;
136     }
137 
138     /**
139      * 销毁用户账户中指定个代币
140      *
141      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
142      *
143      * @param _from the address of the sender
144      * @param _value the amount of money to burn
145      */
146     function burnFrom(address _from, uint256 _value) public returns (bool success) {
147         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
148         require(_value <= allowance[_from][msg.sender]);    // Check allowance
149         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
150         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
151         totalSupply -= _value;                              // Update totalSupply
152         Burn(_from, _value);
153         return true;
154     }
155 }
156 
157 /******************************************/
158 /*       ADVANCED TOKEN STARTS HERE       */
159 /******************************************/
160 
161 contract MyAdvancedToken is owned, TokenERC20 {
162 
163     uint256 public sellPrice;
164     uint256 public buyPrice;
165 
166     mapping (address => bool) public frozenAccount;
167 
168     /* This generates a public event on the blockchain that will notify clients */
169     event FrozenFunds(address target, bool frozen);
170 
171     /* Initializes contract with initial supply tokens to the creator of the contract */
172     function MyAdvancedToken(
173         uint256 initialSupply,
174         string tokenName,
175         string tokenSymbol
176     ) TokenERC20(initialSupply, tokenName, tokenSymbol) payable public {}
177 
178     /* Internal transfer, only can be called by this contract */
179     function _transfer(address _from, address _to, uint _value) internal {
180         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
181         require (balanceOf[_from] >= _value);               // Check if the sender has enough
182         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
183         require(!frozenAccount[_from]);                     // Check if sender is frozen
184         require(!frozenAccount[_to]);                       // Check if recipient is frozen
185         balanceOf[_from] -= _value;                         // Subtract from the sender
186         balanceOf[_to] += _value;                           // Add the same to the recipient
187         Transfer(_from, _to, _value);
188     }
189 
190     /// @notice Create `mintedAmount` tokens and send it to `target`
191     /// @param target Address to receive the tokens
192     /// @param mintedAmount the amount of tokens it will receive
193     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
194         balanceOf[target] += mintedAmount;
195         totalSupply += mintedAmount;
196         Transfer(0, this, mintedAmount);
197         Transfer(this, target, mintedAmount);
198     }
199 
200     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
201     /// @param target Address to be frozen
202     /// @param freeze either to freeze it or not
203     function freezeAccount(address target, bool freeze) onlyOwner public {
204         frozenAccount[target] = freeze;
205         FrozenFunds(target, freeze);
206     }
207 
208     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
209     /// @param newSellPrice Price the users can sell to the contract
210     /// @param newBuyPrice Price users can buy from the contract
211     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
212         sellPrice = newSellPrice;
213         buyPrice = newBuyPrice;
214     }
215 
216     /// @notice Buy tokens from contract by sending ether
217     function buy() payable public {
218         uint amount = msg.value / buyPrice;               // calculates the amount
219         _transfer(this, msg.sender, amount);              // makes the transfers
220     }
221 
222     /// @notice Sell `amount` tokens to contract
223     /// @param amount amount of tokens to be sold
224     function sell(uint256 amount) public {
225         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
226         _transfer(msg.sender, this, amount);              // makes the transfers
227         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
228     }
229 }