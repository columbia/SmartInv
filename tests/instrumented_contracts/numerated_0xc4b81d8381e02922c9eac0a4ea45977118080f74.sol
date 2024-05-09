1 /*
2 BQAS.IO
3 */
4 pragma solidity ^0.4.11;
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
21 }
22 
23 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
24 
25 contract TokenERC20 {
26     // Public variables of the token
27     string public name = 'Quantitative Analysis System Token';
28     string public symbol = 'QAS';
29     uint8 public decimals = 8;
30     // 8 decimals is the strongly suggested default, avoid changing it
31     uint256 public totalSupply = 100000000000;
32 
33     // This creates an array with all balances
34     mapping (address => uint256) public balanceOf;
35     mapping (address => mapping (address => uint256)) public allowance;
36 
37     // This generates a public event on the blockchain that will notify clients
38     event Transfer(address indexed from, address indexed to, uint256 value);
39 
40     // This notifies clients about the amount burnt
41     event Burn(address indexed from, uint256 value);
42 
43     /**
44      * Constrctor function
45      *
46      * Initializes contract with initial supply tokens to the creator of the contract
47      */
48     function TokenERC20(
49         uint256 initialSupply,
50         string tokenName,
51         string tokenSymbol
52     ) public {
53         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
54         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
55         name = tokenName;                                   // Set the name for display purposes
56         symbol = tokenSymbol;                               // Set the symbol for display purposes
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
179 contract MyAdvancedToken is owned, TokenERC20 {
180 
181     uint256 public sellPrice;
182     uint256 public buyPrice;
183 
184     mapping (address => bool) public frozenAccount;
185 
186     /* This generates a public event on the blockchain that will notify clients */
187     event FrozenFunds(address target, bool frozen);
188 
189     /* Initializes contract with initial supply tokens to the creator of the contract */
190     function MyAdvancedToken(
191         uint256 initialSupply,
192         string tokenName,
193         string tokenSymbol
194     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
195 
196     /* Internal transfer, only can be called by this contract */
197     function _transfer(address _from, address _to, uint _value) internal {
198         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
199         require (balanceOf[_from] >= _value);               // Check if the sender has enough
200         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
201         require(!frozenAccount[_from]);                     // Check if sender is frozen
202         require(!frozenAccount[_to]);                       // Check if recipient is frozen
203         balanceOf[_from] -= _value;                         // Subtract from the sender
204         balanceOf[_to] += _value;                           // Add the same to the recipient
205         Transfer(_from, _to, _value);
206     }
207 	
208 	    /**
209      * Destroy tokens
210      *
211      * Remove `_value` tokens from the system irreversibly
212      *
213      * @param _value the amount of money to burn
214      */
215     function burnThis(uint256 _value) internal returns (bool success) {
216         require(balanceOf[this] >= _value);   // Check if the sender has enough
217         balanceOf[this] -= _value;            // Subtract from the sender
218         totalSupply -= _value;                      // Updates totalSupply
219         Burn(this, _value);
220         return true;
221     }
222 
223     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
224     /// @param target Address to be frozen
225     /// @param freeze either to freeze it or not
226     function freezeAccount(address target, bool freeze) onlyOwner public {
227         frozenAccount[target] = freeze;
228         FrozenFunds(target, freeze);
229     }
230 
231     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
232     /// @param newSellPrice Price the users can sell to the contract
233     /// @param newBuyPrice Price users can buy from the contract
234     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
235         sellPrice = newSellPrice;
236         buyPrice = newBuyPrice;
237     }
238 
239     /// @notice Buy tokens from contract by sending ether
240     function buy() payable public {
241         uint amount = msg.value * (10 ** uint256(decimals)) / buyPrice;               // calculates the amount
242 		require(balanceOf[this] >= amount);					// checks if the contract has enough token to sell
243         _transfer(this, msg.sender, amount);              // makes the transfers
244     }
245 
246     /// @notice Sell `amount` tokens to contract
247     /// @param amount amount of tokens to be sold
248     function sell(uint256 amount) public {
249         require(this.balance >= amount * sellPrice/( 10 ** uint256(decimals)));      // checks if the contract has enough ether to buy
250         _transfer(msg.sender, this, amount);              // makes the transfers
251         msg.sender.transfer(amount * sellPrice/( 10 ** uint256(decimals)));          // sends ether to the seller. It's important to do this last to avoid recursion attacks
252 	}
253 	
254 	/// @notice withdrawal `amount` eth from contract
255     /// @param amount amount of eth to be withdrawal
256     function withdrawalEth(uint256 amount) onlyOwner public {
257         require(this.balance >= amount);      // checks if the contract has enough ether to withdrawal
258         msg.sender.transfer(amount);          // sends ether for withdrawal. 
259     }
260 	
261 	/// @notice withdrawal `amount` tokens from contract
262     /// @param amount amount of tokens to be withdrawal
263     function withdrawalToken(uint256 amount) onlyOwner public {
264 		require(balanceOf[this] >= amount);
265         _transfer(this, msg.sender, amount);              // makes the transfers
266     }
267 }