1 pragma solidity ^0.4.16;
2 
3  contract owned {
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
22  contract TokenERC20 {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply;
29 
30     // This creates an array with all balances
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     // This generates a public event on the blockchain that will notify clients
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     // This notifies clients about the amount burnt
38     event Burn(address indexed from, uint256 value);
39 
40     /**
41      * Constrctor function
42      *
43      * Initializes contract with initial supply tokens to the creator of the contract
44      */
45     function TokenERC20() public {
46         totalSupply = 30000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
47         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
48         name = "AkkiTestCoin";                                   // Set the name for display purposes
49         symbol = "AkkiTestCoin";                               // Set the symbol for display purposes
50     }
51 
52     /**
53      * Internal transfer, only can be called by this contract
54      */
55     function _transfer(address _from, address _to, uint _value) internal {
56         // Prevent transfer to 0x0 address. Use burn() instead
57         require(_to != 0x0);
58         // Check if the sender has enough
59         require(balanceOf[_from] >= _value);
60         // Check for overflows
61         require(balanceOf[_to] + _value > balanceOf[_to]);
62         // Save this for an assertion in the future
63         uint previousBalances = balanceOf[_from] + balanceOf[_to];
64         // Subtract from the sender
65         balanceOf[_from] -= _value;
66         // Add the same to the recipient
67         balanceOf[_to] += _value;
68         Transfer(_from, _to, _value);
69         // Asserts are used to use static analysis to find bugs in your code. They should never fail
70         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
71     }
72 
73     /**
74      * Transfer tokens
75      *
76      * Send `_value` tokens to `_to` from your account
77      *
78      * @param _to The address of the recipient
79      * @param _value the amount to send
80      */
81     function transfer(address _to, uint256 _value) public {
82         _transfer(msg.sender, _to, _value);
83     }
84 
85     /**
86      * Transfer tokens from other address
87      *
88      * Send `_value` tokens to `_to` in behalf of `_from`
89      *
90      * @param _from The address of the sender
91      * @param _to The address of the recipient
92      * @param _value the amount to send
93      */
94     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
95         require(_value <= allowance[_from][msg.sender]);     // Check allowance
96         allowance[_from][msg.sender] -= _value;
97         _transfer(_from, _to, _value);
98         return true;
99     }
100 
101     /**
102      * Set allowance for other address
103      *
104      * Allows `_spender` to spend no more than `_value` tokens in your behalf
105      *
106      * @param _spender The address authorized to spend
107      * @param _value the max amount they can spend
108      */
109     function approve(address _spender, uint256 _value) public
110         returns (bool success) {
111         allowance[msg.sender][_spender] = _value;
112         return true;
113     }
114 
115     /**
116      * Set allowance for other address and notify
117      *
118      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
119      *
120      * @param _spender The address authorized to spend
121      * @param _value the max amount they can spend
122      * @param _extraData some extra information to send to the approved contract
123      */
124     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
125         public
126         returns (bool success) {
127         tokenRecipient spender = tokenRecipient(_spender);
128         if (approve(_spender, _value)) {
129             spender.receiveApproval(msg.sender, _value, this, _extraData);
130             return true;
131         }
132     }
133 
134     /**
135      * Destroy tokens
136      *
137      * Remove `_value` tokens from the system irreversibly
138      *
139      * @param _value the amount of money to burn
140      */
141     function burn(uint256 _value) public returns (bool success) {
142         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
143         balanceOf[msg.sender] -= _value;            // Subtract from the sender
144         totalSupply -= _value;                      // Updates totalSupply
145         Burn(msg.sender, _value);
146         return true;
147     }
148 
149     /**
150      * Destroy tokens from other account
151      *
152      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
153      *
154      * @param _from the address of the sender
155      * @param _value the amount of money to burn
156      */
157     function burnFrom(address _from, uint256 _value) public returns (bool success) {
158         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
159         require(_value <= allowance[_from][msg.sender]);    // Check allowance
160         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
161         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
162         totalSupply -= _value;                              // Update totalSupply
163         Burn(_from, _value);
164         return true;
165     }
166 }
167 
168 /******************************************/
169 /*       ADVANCED TOKEN STARTS HERE       */
170 /******************************************/
171 
172 contract testcoin is owned, TokenERC20 {
173 
174     uint256 public sellPrice;
175     uint256 public buyPrice;
176 
177     mapping (address => bool) public frozenAccount;
178 
179     /* This generates a public event on the blockchain that will notify clients */
180     event FrozenFunds(address target, bool frozen);
181 
182     /* Initializes contract with initial supply tokens to the creator of the contract */
183     function testcoin() TokenERC20() public {}
184 
185     /* Internal transfer, only can be called by this contract */
186     function _transfer(address _from, address _to, uint _value) internal {
187         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
188         require (balanceOf[_from] > _value);                // Check if the sender has enough
189         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
190         require(!frozenAccount[_from]);                     // Check if sender is frozen
191         require(!frozenAccount[_to]);                       // Check if recipient is frozen
192         balanceOf[_from] -= _value;                         // Subtract from the sender
193         balanceOf[_to] += _value;                           // Add the same to the recipient
194         Transfer(_from, _to, _value);
195     }
196 
197     /// @notice Create `mintedAmount` tokens and send it to `target`
198     /// @param target Address to receive the tokens
199     /// @param mintedAmount the amount of tokens it will receive
200     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
201         balanceOf[target] += mintedAmount;
202         totalSupply += mintedAmount;
203         Transfer(0, this, mintedAmount);
204         Transfer(this, target, mintedAmount);
205     }
206 
207     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
208     /// @param target Address to be frozen
209     /// @param freeze either to freeze it or not
210     function freezeAccount(address target, bool freeze) onlyOwner public {
211         frozenAccount[target] = freeze;
212         FrozenFunds(target, freeze);
213     }
214 
215     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
216     /// @param newSellPrice Price the users can sell to the contract
217     /// @param newBuyPrice Price users can buy from the contract
218     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
219         sellPrice = newSellPrice;
220         buyPrice = newBuyPrice;
221     }
222 
223     /// @notice Buy tokens from contract by sending ether
224     function buy() payable public {
225         uint amount = msg.value / buyPrice;               // calculates the amount
226         _transfer(this, msg.sender, amount);              // makes the transfers
227     }
228 
229     /// @notice Sell `amount` tokens to contract
230     /// @param amount amount of tokens to be sold
231     function sell(uint256 amount) public {
232         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
233         _transfer(msg.sender, this, amount);              // makes the transfers
234         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
235     }
236 }