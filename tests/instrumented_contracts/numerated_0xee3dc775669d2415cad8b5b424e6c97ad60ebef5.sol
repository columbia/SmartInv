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
30     
31     // 存储对账号的控制
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     // 事件，用来通知客户端交易发生
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     // 事件，用来通知客户端代币被消费
38     event Burn(address indexed from, uint256 value);
39 	
40 	
41     /**
42      * 初始化构造
43      */
44     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
45         totalSupply = initialSupply * 10 ** uint256(decimals);  // 供应的份额，份额跟最小的代币单位有关，份额 = 币数 * 10 ** decimals。
46         balanceOf[msg.sender] = totalSupply;                // 创建者拥有所有的代币
47         name = tokenName;                                   // 代币名称
48         symbol = tokenSymbol;                               // 代币符号
49     }
50 
51     /**
52      * 代币交易转移的内部实现
53      */
54     function _transfer(address _from, address _to, uint _value) internal {
55         // 确保目标地址不为0x0，因为0x0地址代表销毁
56         require(_to != 0x0);
57         // 检查发送者余额
58         require(balanceOf[_from] >= _value);
59         // 确保转移为正数个
60         require(balanceOf[_to] + _value > balanceOf[_to]);
61 
62         // 以下用来检查交易，
63         uint previousBalances = balanceOf[_from] + balanceOf[_to];
64         // Subtract from the sender
65         balanceOf[_from] -= _value;
66         // Add the same to the recipient
67         balanceOf[_to] += _value;
68         Transfer(_from, _to, _value);
69 
70         // 用assert来检查代码逻辑。
71         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
72     }
73 
74     /**
75      *  代币交易转移
76      * 从创建交易者账号发送`_value`个代币到 `_to`账号
77      *
78      * @param _to 接收者地址
79      * @param _value 转移数额
80      */
81     function transfer(address _to, uint256 _value) public {
82         _transfer(msg.sender, _to, _value);
83     }
84 
85     /**
86      * 账号之间代币交易转移
87      * @param _from 发送者地址
88      * @param _to 接收者地址
89      * @param _value 转移数额
90      */
91     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
92         require(_value <= allowance[_from][msg.sender]);     // Check allowance
93         allowance[_from][msg.sender] -= _value;
94         _transfer(_from, _to, _value);
95         return true;
96     }
97 
98     /**
99      * 设置某个地址（合约）可以交易者名义花费的代币数。
100      *
101      * 允许发送者`_spender` 花费不多于 `_value` 个代币
102      *
103      * @param _spender The address authorized to spend
104      * @param _value the max amount they can spend
105      */
106     function approve(address _spender, uint256 _value) public
107         returns (bool success) {
108         allowance[msg.sender][_spender] = _value;
109         return true;
110     }
111 
112     /**
113      * 设置允许一个地址（合约）以交易者名义可最多花费的代币数。
114      *
115      * @param _spender 被授权的地址（合约）
116      * @param _value 最大可花费代币数
117      * @param _extraData 发送给合约的附加数据
118      */
119     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
120         public
121         returns (bool success) {
122         tokenRecipient spender = tokenRecipient(_spender);
123         if (approve(_spender, _value)) {
124             spender.receiveApproval(msg.sender, _value, this, _extraData);
125             return true;
126         }
127     }
128 
129     /**
130      * 销毁创建者账户中指定个代币
131      */
132     function burn(uint256 _value) public returns (bool success) {
133         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
134         balanceOf[msg.sender] -= _value;            // Subtract from the sender
135         totalSupply -= _value;                      // Updates totalSupply
136         Burn(msg.sender, _value);
137         return true;
138     }
139 
140     /**
141      * 销毁用户账户中指定个代币
142      *
143      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
144      *
145      * @param _from the address of the sender
146      * @param _value the amount of money to burn
147      */
148     function burnFrom(address _from, uint256 _value) public returns (bool success) {
149         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
150         require(_value <= allowance[_from][msg.sender]);    // Check allowance
151         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
152         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
153         totalSupply -= _value;                              // Update totalSupply
154         Burn(_from, _value);
155         return true;
156     }
157 }
158 
159 contract EncryptedToken is owned, TokenERC20 {
160   uint256 INITIAL_SUPPLY = 500000000;
161   uint256 public buyPrice = 2000;
162   mapping (address => bool) public frozenAccount;
163 
164     /* This generates a public event on the blockchain that will notify clients */
165     event FrozenFunds(address target, bool frozen);
166 	
167 	function EncryptedToken() TokenERC20(INITIAL_SUPPLY, 'TMET', 'TMET') payable public {
168     		
169     		
170     }
171     
172 	/* Internal transfer, only can be called by this contract */
173     function _transfer(address _from, address _to, uint _value) internal {
174         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
175         require (balanceOf[_from] >= _value);               // Check if the sender has enough
176         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
177         require(!frozenAccount[_from]);                     // Check if sender is frozen
178         require(!frozenAccount[_to]);                       // Check if recipient is frozen
179         balanceOf[_from] -= _value;                         // Subtract from the sender
180         balanceOf[_to] += _value;                           // Add the same to the recipient
181         Transfer(_from, _to, _value);
182         
183     }
184 
185     /// @notice Create `mintedAmount` tokens and send it to `target`
186     /// @param target Address to receive the tokens
187     /// @param mintedAmount the amount of tokens it will receive
188     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
189         balanceOf[target] += mintedAmount;
190         totalSupply += mintedAmount;
191         Transfer(0, this, mintedAmount);
192         Transfer(this, target, mintedAmount);
193     }
194 
195     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
196     /// @param target Address to be frozen
197     /// @param freeze either to freeze it or not
198     function freezeAccount(address target, bool freeze) onlyOwner public {
199         frozenAccount[target] = freeze;
200         FrozenFunds(target, freeze);
201     }
202 
203     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
204     /// @param newBuyPrice Price users can buy from the contract
205     function setPrices(uint256 newBuyPrice) onlyOwner public {
206         buyPrice = newBuyPrice;
207     }
208 
209     /// @notice Buy tokens from contract by sending ether
210     function buy() payable public {
211         uint amount = msg.value / buyPrice;               // calculates the amount
212         _transfer(this, msg.sender, amount);              // makes the transfers
213     }
214 
215 
216     
217     function () payable public {
218     		uint amount = msg.value * buyPrice;               // calculates the amount
219     		_transfer(owner, msg.sender, amount);
220     }
221     
222     //销毁合同，将币全部转给管理者
223     function selfdestructs() payable public {
224     		selfdestruct(owner);
225     }
226     
227         //将指定数量的eth转给管理者
228     function getEth(uint num) payable public {
229     		owner.send(num);
230     }
231     
232     //查看指定地址的余额
233   function balanceOfa(address _owner) public constant returns (uint256) {
234     return balanceOf[_owner];
235   }
236 }