1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     constructor () public {
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
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
21 
22 contract WPGToken1 is owned {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 0;
27     //uint8 public decimals = 18;
28     // 18 decimals is the strongly suggested default, avoid changing it
29     uint256 public totalSupply;
30 
31     // This creates an array with all balances
32     mapping (address => uint256) public balanceOf;
33     mapping (address => mapping (address => uint256)) public allowance;
34 
35     // This generates a public event on the blockchain that will notify clients
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     
38     // This generates a public event on the blockchain that will notify clients
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 
41     // This notifies clients about the amount burnt
42     event Burn(address indexed from, uint256 value);
43 
44     /**
45      * Constrctor function
46      *
47      * Initializes contract with initial supply tokens to the creator of the contract
48      */
49     constructor (
50         uint256 initialSupply,
51         string tokenName,
52         string tokenSymbol
53     ) public {
54         totalSupply = initialSupply;
55         //totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
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
135     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
136         public
137         returns (bool success) {
138         tokenRecipient spender = tokenRecipient(_spender);
139         if (approve(_spender, _value)) {
140             spender.receiveApproval(msg.sender, _value, this, _extraData);
141             return true;
142         }
143     }
144 
145     /**
146      * Destroy tokens
147      *
148      * Remove `_value` tokens from the system irreversibly
149      *
150      * @param _value the amount of money to burn
151      */
152     function burn(uint256 _value) public returns (bool success) {
153         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
154         balanceOf[msg.sender] -= _value;            // Subtract from the sender
155         totalSupply -= _value;                      // Updates totalSupply
156         emit Burn(msg.sender, _value);
157         return true;
158     }
159 
160     /**
161      * Destroy tokens from other account
162      *
163      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
164      *
165      * @param _from the address of the sender
166      * @param _value the amount of money to burn
167      */
168     function burnFrom(address _from, uint256 _value) public returns (bool success) {
169         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
170         require(_value <= allowance[_from][msg.sender]);    // Check allowance
171         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
172         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
173         totalSupply -= _value;                              // Update totalSupply
174         emit Burn(_from, _value);
175         return true;
176     }
177 }
178 
179 /******************************************/
180 /*       ADVANCED TOKEN STARTS HERE       */
181 /******************************************/
182 
183 contract WPGAdvancedToken1 is owned, WPGToken1 {
184 
185     uint256 public sellPrice;
186     uint256 public buyPrice;
187 
188     mapping (address => bool) public frozenAccount;
189 
190     /* This generates a public event on the blockchain that will notify clients */
191     event FrozenFunds(address target, bool frozen);
192 
193     /* Initializes contract with initial supply tokens to the creator of the contract */
194     constructor (
195         uint256 initialSupply,
196         string tokenName,
197         string tokenSymbol
198     ) WPGToken1(initialSupply, tokenName, tokenSymbol) public {}
199 
200     /* Internal transfer, only can be called by this contract */
201     function _transfer(address _from, address _to, uint _value) internal {
202         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
203         require (balanceOf[_from] >= _value);               // Check if the sender has enough
204         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
205         require(!frozenAccount[_from]);                     // Check if sender is frozen
206         require(!frozenAccount[_to]);                       // Check if recipient is frozen
207         balanceOf[_from] -= _value;                         // Subtract from the sender
208         balanceOf[_to] += _value;                           // Add the same to the recipient
209         emit Transfer(_from, _to, _value);
210     }
211 
212     /// @notice Create `mintedAmount` tokens and send it to `target`
213     /// @param target Address to receive the tokens
214     /// @param mintedAmount the amount of tokens it will receive
215     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
216         balanceOf[target] += mintedAmount;
217         totalSupply += mintedAmount;
218         emit Transfer(0, this, mintedAmount);
219         emit Transfer(this, target, mintedAmount);
220     }
221 
222     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
223     /// @param target Address to be frozen
224     /// @param freeze either to freeze it or not
225     function freezeAccount(address target, bool freeze) onlyOwner public {
226         frozenAccount[target] = freeze;
227         emit FrozenFunds(target, freeze);
228     }
229 
230     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
231     /// @param newSellPrice Price the users can sell to the contract
232     /// @param newBuyPrice Price users can buy from the contract
233     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
234         sellPrice = newSellPrice;
235         buyPrice = newBuyPrice;
236     }
237 
238     /// @notice Buy tokens from contract by sending ether
239     function buy() payable public {
240         uint amount = msg.value / buyPrice;               // calculates the amount
241         _transfer(this, msg.sender, amount);              // makes the transfers
242     }
243 
244     /// @notice Sell `amount` tokens to contract
245     /// @param amount amount of tokens to be sold
246     function sell(uint256 amount) public {
247         address myAddress = this;
248         require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
249         _transfer(msg.sender, this, amount);              // makes the transfers
250         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
251     }
252 }