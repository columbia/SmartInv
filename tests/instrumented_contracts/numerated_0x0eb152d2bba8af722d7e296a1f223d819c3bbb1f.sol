1 /** 官方高級token */
2 
3 
4 pragma solidity ^0.4.18;
5 
6 contract owned {
7     address public owner;
8 
9     function owned() public {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     function transferOwnership(address newOwner) onlyOwner public {
19         owner = newOwner;
20     }
21 
22     function destruct() public onlyOwner {
23         selfdestruct(owner);
24     }
25 }
26 
27 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
28 
29 contract TokenERC20 {
30     // Public variables of the token
31     string public name;
32     string public symbol;
33     uint8 public decimals = 18;
34     // 18 decimals is the strongly suggested default, avoid changing it
35     uint256 public totalSupply;
36 
37     // This creates an array with all balances
38     mapping (address => uint256) public balanceOf;
39     mapping (address => mapping (address => uint256)) public allowance;
40 
41     // This generates a public event on the blockchain that will notify clients
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 
44     // This notifies clients about the amount burnt
45     event Burn(address indexed from, uint256 value);
46 
47     /**
48      * Constrctor function
49      *
50      * Initializes contract with initial supply tokens to the creator of the contract
51      */
52     function TokenERC20() public {
53         totalSupply = 500000000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
54         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
55         name = "Carbon Exchange Coin Token";                                   // Set the name for display purposes
56         symbol = "CEC";                               // Set the symbol for display purposes
57     }
58 
59     /**
60      * Internal transfer, only can be called by this contract
61      */
62     function _transfer(address _from, address _to, uint _value) internal {
63         // Prevent transfer to 0x0 address. Use burn() instead
64         require(_to != 0x0);
65         // Check if the sender has enough
66         require(balanceOf[_from] >= _value);
67         // Check for overflows
68         require(balanceOf[_to] + _value > balanceOf[_to]);
69         // Save this for an assertion in the future
70         uint previousBalances = balanceOf[_from] + balanceOf[_to];
71         // Subtract from the sender
72         balanceOf[_from] -= _value;
73         // Add the same to the recipient
74         balanceOf[_to] += _value;
75         Transfer(_from, _to, _value);
76         // Asserts are used to use static analysis to find bugs in your code. They should never fail
77         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
78     }
79 
80     /**
81      * Transfer tokens
82      *
83      * Send `_value` tokens to `_to` from your account
84      *
85      * @param _to The address of the recipient
86      * @param _value the amount to send
87      */
88     function transfer(address _to, uint256 _value) public {
89         _transfer(msg.sender, _to, _value);
90     }
91 
92     /**
93      * Transfer tokens from other address
94      *
95      * Send `_value` tokens to `_to` in behalf of `_from`
96      *
97      * @param _from The address of the sender
98      * @param _to The address of the recipient
99      * @param _value the amount to send
100      */
101     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
102         require(_value <= allowance[_from][msg.sender]);     // Check allowance
103         allowance[_from][msg.sender] -= _value;
104         _transfer(_from, _to, _value);
105         return true;
106     }
107 
108     /**
109      * Set allowance for other address
110      *
111      * Allows `_spender` to spend no more than `_value` tokens in your behalf
112      *
113      * @param _spender The address authorized to spend
114      * @param _value the max amount they can spend
115      */
116     function approve(address _spender, uint256 _value) public
117         returns (bool success) {
118         allowance[msg.sender][_spender] = _value;
119         return true;
120     }
121 
122     /**
123      * Set allowance for other address and notify
124      *
125      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
126      *
127      * @param _spender The address authorized to spend
128      * @param _value the max amount they can spend
129      * @param _extraData some extra information to send to the approved contract
130      */
131     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
132         public
133         returns (bool success) {
134         tokenRecipient spender = tokenRecipient(_spender);
135         if (approve(_spender, _value)) {
136             spender.receiveApproval(msg.sender, _value, this, _extraData);
137             return true;
138         }
139     }
140 
141     /**
142      * Destroy tokens
143      *
144      * Remove `_value` tokens from the system irreversibly
145      *
146      * @param _value the amount of money to burn
147      */
148     function burn(uint256 _value) public returns (bool success) {
149         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
150         balanceOf[msg.sender] -= _value;            // Subtract from the sender
151         totalSupply -= _value;                      // Updates totalSupply
152         Burn(msg.sender, _value);
153         return true;
154     }
155 
156     /**
157      * Destroy tokens from other account
158      *
159      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
160      *
161      * @param _from the address of the sender
162      * @param _value the amount of money to burn
163      */
164     function burnFrom(address _from, uint256 _value) public returns (bool success) {
165         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
166         require(_value <= allowance[_from][msg.sender]);    // Check allowance
167         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
168         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
169         totalSupply -= _value;                              // Update totalSupply
170         Burn(_from, _value);
171         return true;
172     }
173 }
174 
175 /******************************************/
176 /*       ADVANCED TOKEN STARTS HERE       */
177 /******************************************/
178 
179 contract CarbonExchangeCoinToken is owned, TokenERC20 {
180 
181     uint256 public sellPrice;
182     uint256 public buyPrice;
183 	uint256 public decimals = 18;
184 	string  public tokenName;
185 	string  public tokenSymbol;
186 	uint minBalanceForAccounts ;                                         //threshold amount
187 
188     mapping (address => bool) public frozenAccount;
189 
190     /* This generates a public event on the blockchain that will notify clients */
191     event FrozenFunds(address target, bool frozen);
192 
193     /* Initializes contract with initial supply tokens to the creator of the contract */
194 
195 	
196 	function CarbonExchangeCoinToken() public {
197 		owner = msg.sender;
198 		totalSupply = 50000000000000000000000000000;
199 		balanceOf[owner]=totalSupply;
200 		tokenName="Carbon Exchange Coin Token";
201 		tokenSymbol="CEC";
202 	}
203 
204 
205     /* Internal transfer, only can be called by this contract */
206     function _transfer(address _from, address _to, uint _value) internal {
207         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
208         require (balanceOf[_from] >= _value);               // Check if the sender has enough
209         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
210         require(!frozenAccount[_from]);                     // Check if sender is frozen
211         require(!frozenAccount[_to]);                       // Check if recipient is frozen
212         balanceOf[_from] -= _value;                         // Subtract from the sender
213         balanceOf[_to] += _value;                           // Add the same to the recipient
214         Transfer(_from, _to, _value);
215     }
216 
217     /// @notice Create `mintedAmount` tokens and send it to `target`
218     /// @param target Address to receive the tokens
219     /// @param mintedAmount the amount of tokens it will receive
220     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
221         balanceOf[target] += mintedAmount;
222         totalSupply += mintedAmount;
223         Transfer(0, this, mintedAmount);
224         Transfer(this, target, mintedAmount);
225     }
226 
227     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
228     /// @param target Address to be frozen
229     /// @param freeze either to freeze it or not
230     function freezeAccount(address target, bool freeze) onlyOwner public {
231         frozenAccount[target] = freeze;
232         FrozenFunds(target, freeze);
233     }
234 
235     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
236     /// @param newSellPrice Price the users can sell to the contract
237     /// @param newBuyPrice Price users can buy from the contract
238     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
239         sellPrice = newSellPrice;
240         buyPrice = newBuyPrice;
241     }
242 
243     /// @notice Buy tokens from contract by sending ether
244     function buy() payable public {
245         uint amount = msg.value / buyPrice;               // calculates the amount
246         _transfer(this, msg.sender, amount);              // makes the transfers
247     }
248 
249     /// @notice Sell `amount` tokens to contract
250     ///@param amount amount of tokens to be sold
251     function sell(uint256 amount) public {
252         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
253         _transfer(msg.sender, this, amount);              // makes the transfers
254         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
255     }
256 
257 
258 	/* 设置自动补充gas的阈值信息 201803202232  james */ 
259 	function setMinBalance(uint minimumBalanceInFinney) public onlyOwner {
260 		minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
261 	}
262 
263 	/* 设置tokenname */
264 	function setTokenName(string newTokenName) public onlyOwner{
265 		tokenName = newTokenName;		
266 	}
267 	/* 设置tokenSymbol */
268 	function setTokenSymbol(string newTokenSymbol) public onlyOwner{
269 		tokenSymbol = newTokenSymbol;
270 	}
271 }