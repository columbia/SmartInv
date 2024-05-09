1 pragma solidity ^0.4.16;
2 
3 /**
4  * iMMCoin extended ERC20 token contract created on November the 13th, 2017 by INTERDAY MARKETS MANAGEMENT in the Philippines 
5  *
6  *
7  */
8 contract owned {
9     address public owner;
10 
11     function owned() public {
12         owner = msg.sender;
13     }
14 
15     modifier onlyOwner {
16         require(msg.sender == owner);
17         _;
18     }
19 
20     function transferOwnership(address newOwner) onlyOwner public {
21         owner = newOwner;
22     }
23 }
24 
25 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
26 
27 contract Token {
28     // Public variables of the token
29     string public name;
30     string public symbol;
31     uint8 public decimals = 18;
32     // 18 decimals is the strongly suggested default, avoid changing it
33     uint256 public totalSupply;
34 
35     // This creates an array with all balances
36     mapping (address => uint256) public balanceOf;
37     mapping (address => mapping (address => uint256)) public allowance;
38 
39     // This generates a public event on the blockchain that will notify clients
40     event Transfer(address indexed from, address indexed to, uint256 value);
41 
42     // This notifies clients about the amount burnt
43     event Burn(address indexed from, uint256 value);
44 
45     /**
46      * Constrctor function
47      *
48      * Initializes contract with initial supply tokens to the creator of the contract
49      */
50     function Token(
51         uint256 initialSupply,
52         string tokenName,
53         string tokenSymbol
54     ) public {
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
77         Transfer(_from, _to, _value);
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
90     function transfer(address _to, uint256 _value) public {
91         _transfer(msg.sender, _to, _value);
92     }
93 
94     /**
95      * Transfer tokens from other address
96      *
97      * Send `_value` tokens to `_to` in behalf of `_from`
98      *
99      * @param _from The address of the sender
100      * @param _to The address of the recipient
101      * @param _value the amount to send
102      */
103     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
104         require(_value <= allowance[_from][msg.sender]);     // Check allowance
105         allowance[_from][msg.sender] -= _value;
106         _transfer(_from, _to, _value);
107         return true;
108     }
109 
110     /**
111      * Set allowance for other address
112      *
113      * Allows `_spender` to spend no more than `_value` tokens in your behalf
114      *
115      * @param _spender The address authorized to spend
116      * @param _value the max amount they can spend
117      */
118     function approve(address _spender, uint256 _value) public
119         returns (bool success) {
120         allowance[msg.sender][_spender] = _value;
121         return true;
122     }
123 
124     /**
125      * Set allowance for other address and notify
126      *
127      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
128      *
129      * @param _spender The address authorized to spend
130      * @param _value the max amount they can spend
131      * @param _extraData some extra information to send to the approved contract
132      */
133     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
134         public
135         returns (bool success) {
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
154         Burn(msg.sender, _value);
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
172         Burn(_from, _value);
173         return true;
174     }
175 }
176 
177 /******************************************/
178 /*       IMMCoin       */
179 /******************************************/
180 
181 contract IMMCoin is owned, Token {
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
192     function IMMCoin(
193         uint256 initialSupply,
194         string tokenName,
195         string tokenSymbol
196     ) Token(initialSupply, tokenName, tokenSymbol) public {}
197 
198     /* Internal transfer, only can be called by this contract */
199     function _transfer(address _from, address _to, uint _value) internal {
200         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
201         require (balanceOf[_from] > _value);                // Check if the sender has enough
202         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
203         require(!frozenAccount[_from]);                     // Check if sender is frozen
204         require(!frozenAccount[_to]);                       // Check if recipient is frozen
205         balanceOf[_from] -= _value;                         // Subtract from the sender
206         balanceOf[_to] += _value;                           // Add the same to the recipient
207         Transfer(_from, _to, _value);
208     }
209 
210     /// @notice Create `mintedAmount` tokens and send it to `target`
211     /// @param target Address to receive the tokens
212     /// @param mintedAmount the amount of tokens it will receive
213     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
214         balanceOf[target] += mintedAmount;
215         totalSupply += mintedAmount;
216         Transfer(0, this, mintedAmount);
217         Transfer(this, target, mintedAmount);
218     }
219 
220     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
221     /// @param target Address to be frozen
222     /// @param freeze either to freeze it or not
223     function freezeAccount(address target, bool freeze) onlyOwner public {
224         frozenAccount[target] = freeze;
225         FrozenFunds(target, freeze);
226     }
227 
228     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
229     /// @param newSellPrice Price the users can sell to the contract
230     /// @param newBuyPrice Price users can buy from the contract
231     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
232         sellPrice = newSellPrice;
233         buyPrice = newBuyPrice;
234     }
235 
236     /// @notice Buy tokens from contract by sending ether
237     function buy() payable public {
238         uint amount = msg.value / buyPrice;               // calculates the amount
239         _transfer(this, msg.sender, amount);              // makes the transfers
240     }
241 
242     /// @notice Sell `amount` tokens to contract
243     /// @param amount amount of tokens to be sold
244     function sell(uint256 amount) public {
245         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
246         _transfer(msg.sender, this, amount);              // makes the transfers
247         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
248     }
249     
250     
251 }