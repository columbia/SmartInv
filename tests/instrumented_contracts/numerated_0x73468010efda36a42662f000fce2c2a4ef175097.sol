1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
5 }
6 
7 contract TokenERC20 {
8     //令牌的公共变量
9     // Public variables of the token
10     string public name;
11     string public symbol;
12     uint8 public decimals = 18;
13     //十八位是强烈建议的默认值，避免更改它
14     // 18 decimals is the strongly suggested default, avoid changing it
15     uint256 public totalSupply;
16 
17     //这将创建一个包含所有余额的数组
18     // This creates an array with all balances
19     mapping (address => uint256) public balanceOf;
20     mapping (address => mapping (address => uint256)) public allowance;
21     
22     //这将在区块链上生成一个公共事件，该事件将通知客户端
23     // This generates a public event on the blockchain that will notify clients
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     
26     //这将在区块链上生成一个公共事件，该事件将通知客户端
27     // This generates a public event on the blockchain that will notify clients
28     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
29     
30     //这将通知客户烧毁的数量
31     // This notifies clients about the amount burnt
32     event Burn(address indexed from, uint256 value);
33     /**
34      * 构造函数
35      * Constructor function
36      *
37      * 使用初始供应令牌初始化契约，以向契约的创建者提供令牌
38      * Initializes contract with initial supply tokens to the creator of the contract
39      */
40     constructor(
41         uint256 initialSupply,
42         string memory tokenName,
43         string memory tokenSymbol
44     ) 
45     
46     public {
47         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
48         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
49         name = tokenName;                                   // Set the name for display purposes
50         symbol = tokenSymbol;                               // Set the symbol for display purposes
51     }
52 
53     /**
54      * 内部转账，只能按本合同调用
55      * Internal transfer, only can be called by this contract
56      */
57     function _transfer(address _from, address _to, uint _value) internal {
58         //防止传输到0x0地址。使用燃烧()
59         // Prevent transfer to 0x0 address. Use burn() instead
60         require(_to != address(0x0));
61         //检查寄件人是否有足够的钱
62         // Check if the sender has enough
63         require(balanceOf[_from] >= _value);
64         //检查溢出
65         // Check for overflows
66         require(balanceOf[_to] + _value >= balanceOf[_to]);
67         //将其保存为将来的断言
68         // Save this for an assertion in the future
69         uint previousBalances = balanceOf[_from] + balanceOf[_to];
70         //减去发送者
71         // Subtract from the sender
72         balanceOf[_from] -= _value;
73         //向收件人添加相同的内容
74         // Add the same to the recipient
75         balanceOf[_to] += _value;
76         emit Transfer(_from, _to, _value);
77         //断言用于使用静态分析来发现代码中的bug。他们不应该失败
78         // Asserts are used to use static analysis to find bugs in your code. They should never fail
79         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
80     }
81 
82     /**
83      * 传递令牌
84      * Transfer tokens
85      *
86      * 将“_value”令牌从您的帐户发送到“_to”
87      * Send `_value` tokens to `_to` from your account
88      *
89      * _to收件人的地址
90      * @param _to The address of the recipient
91      * 
92      * _value发送的数量
93      * @param _value the amount to send
94      */
95     function transfer(address _to, uint256 _value) public returns (bool success) {
96         _transfer(msg.sender, _to, _value);
97         return true;
98     }
99 
100     /**
101      * 从其他地址转移令牌
102      * Transfer tokens from other address
103      *
104      * 代表“_from”向“_to”发送“_value”令牌
105      * Send `_value` tokens to `_to` on behalf of `_from`
106      *
107      *  _from发件人地址
108      * @param _from The address of the sender
109      * 
110      *  _to收件人的地址
111      * @param _to The address of the recipient
112      * 
113      *  _value发送的数量
114      * @param _value the amount to send
115      */
116     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
117         require(_value <= allowance[_from][msg.sender]);     // Check allowance
118         allowance[_from][msg.sender] -= _value;
119         _transfer(_from, _to, _value);
120         return true;
121     }
122 
123     /**
124      * 预留其他地址
125      * Set allowance for other address
126      * 
127      * 允许“_spender”代表您花费不超过“_value”令牌
128      * Allows `_spender` to spend no more than `_value` tokens on your behalf
129      *
130      * _spender授权使用的地址
131      * @param _spender The address authorized to spend
132      * 
133      * _value他们可以花费的最大金额
134      * @param _value the max amount they can spend
135      */
136     function approve(address _spender, uint256 _value) public
137         returns (bool success) {
138         allowance[msg.sender][_spender] = _value;
139         emit Approval(msg.sender, _spender, _value);
140         return true;
141     }
142 
143     /**
144      * 预留其他地址及通知
145      * Set allowance for other address and notify 
146      * 
147      *允许“_spender”代表您花费不超过“_value”令牌，然后ping关于它的契约
148      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it 
149      * 
150      *_spender授权使用的地址
151      * @param _spender The address authorized to spend
152      * 
153      * _value他们可以花费的最大金额
154      * @param _value the max amount they can spend
155      * 
156      * _ata向批准的合同发送一些额外的信息
157      * @param _extraData some extra information to send to the approved contract
158      */
159     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
160         public
161         returns (bool success) {
162         tokenRecipient spender = tokenRecipient(_spender);
163         if (approve(_spender, _value)) {
164             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
165             return true;
166         }
167     }
168 
169     /**
170      * 摧毁令牌
171      * Destroy tokens
172      *
173      * 不可逆地从系统中删除' _value '令牌
174      * Remove `_value` tokens from the system irreversibly
175      *
176      *  _value要烧的钱的数量
177      * @param _value the amount of money to burn
178      */
179     function burn(uint256 _value) public returns (bool success) {
180         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
181         balanceOf[msg.sender] -= _value;            // Subtract from the sender
182         totalSupply -= _value;                      // Updates totalSupply
183         emit Burn(msg.sender, _value);
184         return true;
185     }
186 
187     /**
188      * 销毁来自其他帐户的令牌
189      * Destroy tokens from other account
190      *
191      *代表“_from”不可逆地从系统中删除“_value”令牌。
192      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
193      *
194      *  _from发件人地址
195      * @param _from the address of the sender
196      * 
197      * _value要烧的钱的数量
198      * @param _value the amount of money to burn
199      */
200     function burnFrom(address _from, uint256 _value) public returns (bool success) {
201         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
202         require(_value <= allowance[_from][msg.sender]);    // Check allowance
203         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
204         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
205         totalSupply -= _value;                              // Update totalSupply
206         emit Burn(_from, _value);
207         return true;
208     }
209 }