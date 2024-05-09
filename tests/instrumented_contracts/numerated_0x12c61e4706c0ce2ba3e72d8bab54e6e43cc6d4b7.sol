1 pragma solidity ^0.4.16;
2 
3 contract owned {
4         address public owner;
5 
6         function owned() {
7             owner = msg.sender;
8         }
9 
10         modifier onlyOwner {
11             require(msg.sender == owner);
12             _;
13         }
14 
15         // 实现所有权转移
16         function transferOwnership(address newOwner) onlyOwner {
17             owner = newOwner;
18         }
19     }
20 
21 
22     interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
23 
24 contract TokenERC20 {
25     string public name;
26     string public symbol;
27     uint8 public decimals = 18;  // decimals 可以有的小数点个数，最小的代币单位。18 是建议的默认值
28     uint256 public totalSupply;
29 
30     // 用mapping保存每个地址对应的余额
31     mapping (address => uint256) public balanceOf;
32     // 存储对账号的控制
33     mapping (address => mapping (address => uint256)) public allowance;
34 
35     // 事件，用来通知客户端交易发生
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 
38     // 事件，用来通知客户端代币被消费
39     event Burn(address indexed from, uint256 value);
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
76      * 从自己（创建交易者）账号发送`_value`个代币到 `_to`账号
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
99      * 设置某个地址（合约）可以创建交易者名义花费的代币数。
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
113      * 设置允许一个地址（合约）以我（创建交易者）的名义可最多花费的代币数。
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
124             // 通知合约
125             spender.receiveApproval(msg.sender, _value, this, _extraData);
126             return true;
127         }
128     }
129 
130     /**
131      * 销毁我（创建交易者）账户中指定个代币
132      */
133     function burn(uint256 _value) public returns (bool success) {
134         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
135         balanceOf[msg.sender] -= _value;            // Subtract from the sender
136         totalSupply -= _value;                      // Updates totalSupply
137         Burn(msg.sender, _value);
138         return true;
139     }
140 
141     /**
142      * 销毁用户账户中指定个代币
143      *
144      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
145      *
146      * @param _from the address of the sender
147      * @param _value the amount of money to burn
148      */
149     function burnFrom(address _from, uint256 _value) public returns (bool success) {
150         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
151         require(_value <= allowance[_from][msg.sender]);    // Check allowance
152         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
153         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
154         totalSupply -= _value;                              // Update totalSupply
155         Burn(_from, _value);
156         return true;
157     }
158 }
159 
160 
161 
162 /******************************************/
163 /*       ADVANCED TOKEN STARTS HERE       */
164 /******************************************/
165 
166 contract CompetitionChainContract is owned, TokenERC20 {
167 
168     uint256 public sellPrice;
169     uint256 public buyPrice;
170 
171     mapping (address => uint256) public frozenBalance;
172 
173     /* This generates a public event on the blockchain that will notify clients */
174     event FrozenFunds(address target, uint256 frozenCount);
175 
176     /* Initializes contract with initial supply tokens to the creator of the contract */
177     function CompetitionChainContract(
178         uint256 initialSupply,
179         string tokenName,
180         string tokenSymbol
181     ) TokenERC20(initialSupply, tokenName, tokenSymbol) payable public {}
182 
183     /* Internal transfer, only can be called by this contract */
184     function _transfer(address _from, address _to, uint _value) internal {
185         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
186         require (balanceOf[_from] >= _value);               // Check if the sender has enough
187         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
188 
189         if(frozenBalance[_from] != 0)  // Check if sender is frozen
190         {
191             require(balanceOf[_from] - frozenBalance[_from] >= _value); 
192         }
193         // 以下用来检查交易，
194         uint previousBalances = balanceOf[_from] + balanceOf[_to];
195 
196         balanceOf[_from] -= _value;                         // Subtract from the sender
197         balanceOf[_to] += _value;                           // Add the same to the recipient
198         Transfer(_from, _to, _value);
199 
200         // 用assert来检查代码逻辑。
201         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
202     }
203 
204     /// @notice 锁仓功能
205     /// @param target Address to be frozen
206     /// @param freezeCount the count to be freezon 
207     function freezeAccount(address target, uint freezeCount) onlyOwner public {
208         frozenBalance[target] = freezeCount;
209         FrozenFunds(target, freezeCount);
210     }
211 
212 
213 }