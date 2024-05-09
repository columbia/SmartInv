1 pragma solidity ^0.4.16;
2 
3 
4 contract owned {
5     address public owner;
6 
7     function owned() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) onlyOwner public {
17         owner = newOwner;
18     }
19 }
20 
21 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
22 
23 contract TokenERC20 {
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;  // decimals 可以有的小数点个数，最小的代币单位。18 是建议的默认值
27     uint256 public totalSupply;
28 
29     // 用mapping保存每个地址对应的余额
30     mapping (address => uint256) public balanceOf;
31     // 存储对账号的控制
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     // 事件，用来通知客户端交易发生
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     // 事件，用来通知客户端代币被消费
38     event Burn(address indexed from, uint256 value);
39 
40     /**
41      * 初始化构造
42      */
43     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
44         totalSupply = initialSupply * 10 ** uint256(decimals);  // 供应的份额，份额跟最小的代币单位有关，份额 = 币数 * 10 ** decimals。
45         balanceOf[msg.sender] = totalSupply;                // 创建者拥有所有的代币
46         name = tokenName;                                   // 代币名称
47         symbol = tokenSymbol;                               // 代币符号
48     }
49 
50     /**
51      * 代币交易转移的内部实现
52      */
53     function _transfer(address _from, address _to, uint _value) internal {
54         // 确保目标地址不为0x0，因为0x0地址代表销毁
55         require(_to != 0x0);
56         // 检查发送者余额
57         require(balanceOf[_from] >= _value);
58         // 确保转移为正数个
59         require(balanceOf[_to] + _value > balanceOf[_to]);
60 
61         // 以下用来检查交易，
62         uint previousBalances = balanceOf[_from] + balanceOf[_to];
63         // Subtract from the sender
64         balanceOf[_from] -= _value;
65         // Add the same to the recipient
66         balanceOf[_to] += _value;
67         Transfer(_from, _to, _value);
68 
69         // 用assert来检查代码逻辑。
70         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
71     }
72 
73     /**
74      *  代币交易转移
75      * 从创建交易者账号发送`_value`个代币到 `_to`账号
76      *
77      * @param _to 接收者地址
78      * @param _value 转移数额
79      */
80     function transfer(address _to, uint256 _value) public {
81         _transfer(msg.sender, _to, _value);
82     }
83 
84     /**
85      * 账号之间代币交易转移
86      * @param _from 发送者地址
87      * @param _to 接收者地址
88      * @param _value 转移数额
89      */
90     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
91         require(_value <= allowance[_from][msg.sender]);     // Check allowance
92         allowance[_from][msg.sender] -= _value;
93         _transfer(_from, _to, _value);
94         return true;
95     }
96 
97     /**
98      * 设置某个地址（合约）可以交易者名义花费的代币数。
99      *
100      * 允许发送者`_spender` 花费不多于 `_value` 个代币
101      *
102      * @param _spender The address authorized to spend
103      * @param _value the max amount they can spend
104      */
105     function approve(address _spender, uint256 _value) public
106         returns (bool success) {
107         allowance[msg.sender][_spender] = _value;
108         return true;
109     }
110 
111     /**
112      * 设置允许一个地址（合约）以交易者名义可最多花费的代币数。
113      *
114      * @param _spender 被授权的地址（合约）
115      * @param _value 最大可花费代币数
116      * @param _extraData 发送给合约的附加数据
117      */
118     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
119         public
120         returns (bool success) {
121         tokenRecipient spender = tokenRecipient(_spender);
122         if (approve(_spender, _value)) {
123             spender.receiveApproval(msg.sender, _value, this, _extraData);
124             return true;
125         }
126     }
127 
128     /**
129      * 销毁创建者账户中指定个代币
130      */
131     function burn(uint256 _value) public returns (bool success) {
132         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
133         balanceOf[msg.sender] -= _value;            // Subtract from the sender
134         totalSupply -= _value;                      // Updates totalSupply
135         Burn(msg.sender, _value);
136         return true;
137     }
138 
139     /**
140      * 销毁用户账户中指定个代币
141      *
142      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
143      *
144      * @param _from the address of the sender
145      * @param _value the amount of money to burn
146      */
147     function burnFrom(address _from, uint256 _value) public returns (bool success) {
148         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
149         require(_value <= allowance[_from][msg.sender]);    // Check allowance
150         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
151         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
152         totalSupply -= _value;                              // Update totalSupply
153         Burn(_from, _value);
154         return true;
155     }
156 }
157 
158 /******************************************/
159 /*       ADVANCED TOKEN STARTS HERE       */
160 /******************************************/
161 
162 contract MyAdvancedToken is owned, TokenERC20 {
163 
164     mapping (address => bool) public frozenAccount;
165 
166     /* This generates a public event on the blockchain that will notify clients */
167     event FrozenFunds(address target, bool frozen);
168 
169     /* Initializes contract with initial supply tokens to the creator of the contract */
170     function MyAdvancedToken(
171         uint256 initialSupply,
172         string tokenName,
173         string tokenSymbol
174     ) TokenERC20(initialSupply, tokenName, tokenSymbol) payable public {}
175 
176     /* Internal transfer, only can be called by this contract */
177     function _transfer(address _from, address _to, uint _value) internal {
178         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
179         require (balanceOf[_from] >= _value);               // Check if the sender has enough
180         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
181         require(!frozenAccount[_from]);                     // Check if sender is frozen
182         require(!frozenAccount[_to]);                       // Check if recipient is frozen
183         balanceOf[_from] -= _value;                         // Subtract from the sender
184         balanceOf[_to] += _value;                           // Add the same to the recipient
185         Transfer(_from, _to, _value);
186     }
187 
188     /// @notice Create `mintedAmount` tokens and send it to `target`
189     /// @param target Address to receive the tokens
190     /// @param mintedAmount the amount of tokens it will receive
191     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
192         balanceOf[target] += mintedAmount;
193         totalSupply += mintedAmount;
194         Transfer(0, this, mintedAmount);
195         Transfer(this, target, mintedAmount);
196     }
197 
198     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
199     /// @param target Address to be frozen
200     /// @param freeze either to freeze it or not
201     function freezeAccount(address target, bool freeze) onlyOwner public {
202         frozenAccount[target] = freeze;
203         FrozenFunds(target, freeze);
204     }
205 }