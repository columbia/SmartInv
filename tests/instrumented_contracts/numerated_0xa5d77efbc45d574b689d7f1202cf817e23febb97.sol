1 pragma solidity ^0.4.24;
2 
3 //创建一个基础合约，有些操作只有合约的创建者才能操作
4 contract owned {
5 	//声明一个变量来接收合约创建者的状态变量
6     address public owner;
7 
8 	//构造函数，当前合约的创建者赋予owner变量
9 	constructor() public {
10         owner = msg.sender;
11     }
12 
13 	//声明一个修改器，有些方法只有合约的创建者才能操作
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19 	//把合约拥有者转给别人
20     function transferOwnership(address newOwner) onlyOwner public {
21         owner = newOwner;
22     }
23 }
24 
25 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
26 
27 contract TokenERC20 {
28     // Public variables of the token
29     string public name; //代币名字
30     string public symbol; // 代币符号
31     uint8 public decimals = 18; //代币小数位
32     // 18 decimals is the strongly suggested default, avoid changing it
33     uint256 public totalSupply; //发行总量
34 
35     // This creates an array with all balances
36 	// 用一个映射类型的变量来记录所有账户代币的余额
37     mapping (address => uint256) public balanceOf;
38     mapping (address => mapping (address => uint256)) public allowance;
39 
40     // This generates a public event on the blockchain that will notify clients
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     
43     // This generates a public event on the blockchain that will notify clients
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 
46     // This notifies clients about the amount burnt
47     event Burn(address indexed from, uint256 value);
48 
49     /**
50      * Constrctor function
51      *
52      * Initializes contract with initial supply tokens to the creator of the contract
53      */
54     constructor(uint256 initialSupply,string tokenName,string tokenSymbol) public {
55         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
56         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
57         name = tokenName;                                   // Set the name for display purposes
58         symbol = tokenSymbol;                               // Set the symbol for display purposes
59     }
60 
61     /**
62      * Internal transfer, only can be called by this contract
63      */
64     function _transfer(address _from, address _to, uint _value) internal {
65         // Prevent transfer to 0x0 address. Use burn() instead
66         require(_to != 0x0);
67         // Check if the sender has enough
68         require(balanceOf[_from] >= _value);
69         // Check for overflows
70         require(balanceOf[_to] + _value > balanceOf[_to]);
71         // Save this for an assertion in the future
72         uint previousBalances = balanceOf[_from] + balanceOf[_to];
73         // Subtract from the sender
74         balanceOf[_from] -= _value;
75         // Add the same to the recipient
76         balanceOf[_to] += _value;
77         emit Transfer(_from, _to, _value);
78         // Asserts are used to use static analysis to find bugs in your code. They should never fail
79         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
80     }
81 
82     /**
83      * Transfer tokens
84      *
85      * Send `_value` tokens to `_to` from your account
86      *
87      * @param _to The address of the recipient
88      * @param _value the amount to send
89      */
90     function transfer(address _to, uint256 _value) public returns (bool success) {
91         _transfer(msg.sender, _to, _value);
92         return true;
93     }
94 
95     /**
96      * Transfer tokens from other address
97      *
98      * Send `_value` tokens to `_to` in behalf of `_from`
99      *
100      * @param _from The address of the sender
101      * @param _to The address of the recipient
102      * @param _value the amount to send
103      */
104     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
105         require(_value <= allowance[_from][msg.sender]);     // Check allowance
106         allowance[_from][msg.sender] -= _value;
107         _transfer(_from, _to, _value);
108         return true;
109     }
110 
111     /**
112      * Set allowance for other address
113      *
114      * Allows `_spender` to spend no more than `_value` tokens in your behalf
115      *
116      * @param _spender The address authorized to spend
117      * @param _value the max amount they can spend
118      */
119     function approve(address _spender, uint256 _value) public
120         returns (bool success) {
121         allowance[msg.sender][_spender] = _value;
122         emit Approval(msg.sender, _spender, _value);
123         return true;
124     }
125 
126     /**
127      * Set allowance for other address and notify
128      *
129      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
130      *
131      * @param _spender The address authorized to spend
132      * @param _value the max amount they can spend
133      * @param _extraData some extra information to send to the approved contract
134      */
135     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
136         tokenRecipient spender = tokenRecipient(_spender);
137         if (approve(_spender, _value)) {
138             spender.receiveApproval(msg.sender, _value, this, _extraData);
139             return true;
140         }
141     }
142 
143     /**
144      * Destroy tokens
145      *
146      * Remove `_value` tokens from the system irreversibly
147      *
148      * @param _value the amount of money to burn
149      */
150     function burn(uint256 _value) public returns (bool success) {
151         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
152         balanceOf[msg.sender] -= _value;            // Subtract from the sender
153         totalSupply -= _value;                      // Updates totalSupply
154         emit Burn(msg.sender, _value);
155         return true;
156     }
157 
158     /**
159      * Destroy tokens from other account
160      *
161      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
162      *
163      * @param _from the address of the sender
164      * @param _value the amount of money to burn
165      */
166     function burnFrom(address _from, uint256 _value) public returns (bool success) {
167         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
168         require(_value <= allowance[_from][msg.sender]);    // Check allowance
169         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
170         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
171         totalSupply -= _value;                              // Update totalSupply
172         emit Burn(_from, _value);
173         return true;
174     }
175 }
176 
177 /******************************************/
178 /*       ADVANCED TOKEN STARTS HERE       */
179 /******************************************/
180 
181 contract MyToken is owned, TokenERC20 {
182 
183     uint256 public sellPrice;
184     uint256 public buyPrice;
185 
186     mapping (address => bool) public frozenAccount;
187 
188     /* This generates a public event on the blockchain that will notify clients */
189     event FrozenFunds(address target, bool frozen);
190 
191     /* Initializes contract with initial supply tokens to the creator of the contract */
192     constructor(uint256 initialSupply,string tokenName,string tokenSymbol) 
193         TokenERC20(initialSupply, tokenName, tokenSymbol)   public {
194     }
195 
196     /* Internal transfer, only can be called by this contract */
197     // 转账
198     function _transfer(address _from, address _to, uint _value) internal {
199         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
200         require (balanceOf[_from] >= _value);               // Check if the sender has enough
201         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
202         require(!frozenAccount[_from]);                     // Check if sender is frozen
203         require(!frozenAccount[_to]);                       // Check if recipient is frozen
204         balanceOf[_from] -= _value;                         // Subtract from the sender
205         balanceOf[_to] += _value;                           // Add the same to the recipient
206         emit Transfer(_from, _to, _value);
207     }
208 
209     /// @notice Create `mintedAmount` tokens and send it to `target`
210     /// @param target Address to receive the tokens
211     /// @param mintedAmount the amount of tokens it will receive
212     // 代币增发
213     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
214         balanceOf[target] += mintedAmount;
215         totalSupply += mintedAmount;
216         emit Transfer(0, this, mintedAmount);
217         emit Transfer(this, target, mintedAmount);
218     }
219 
220     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
221     /// @param target Address to be frozen
222     /// @param freeze either to freeze it or not
223     // 资产冻结
224     function freezeAccount(address target, bool freeze) onlyOwner public {
225         frozenAccount[target] = freeze;
226         emit FrozenFunds(target, freeze);
227     }
228 
229     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
230     /// @param newSellPrice Price the users can sell to the contract
231     /// @param newBuyPrice Price users can buy from the contract
232     // 设置买卖价格
233     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
234         sellPrice = newSellPrice;
235         buyPrice = newBuyPrice;
236     }
237 
238     /// @notice Buy tokens from contract by sending ether
239     // 买操作
240     function buy() payable public {
241         uint amount = msg.value / buyPrice;               // calculates the amount
242         _transfer(this, msg.sender, amount);              // makes the transfers
243     }
244 
245     /// @notice Sell `amount` tokens to contract
246     /// @param amount amount of tokens to be sold
247     // 卖操作
248     function sell(uint256 amount) public {
249         address myAddress = this;
250         require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
251         _transfer(msg.sender, this, amount);              // makes the transfers
252         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
253     }
254 }