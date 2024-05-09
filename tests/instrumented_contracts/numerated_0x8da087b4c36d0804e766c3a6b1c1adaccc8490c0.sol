1 /**
2  * CRYSTALCOIN Token
3  * Version 1.00
4  * TrueValue Holdings
5  * Interwave Global
6  * www.iw-global.com
7  **/
8  
9  
10 pragma solidity ^0.4.18;
11 
12 
13 contract owned {
14     address public owner;
15 
16     function owned() public {
17         owner = msg.sender;
18     }
19 
20     modifier onlyOwner {
21         require(msg.sender == owner);
22         _;
23     }
24 
25     function transferOwnership(address newOwner) onlyOwner public {
26         owner = newOwner;
27     }
28 }
29 
30 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
31 
32 contract TokenERC20 {
33     // Public variables of the token
34     string public name  ;
35     string public symbol  ;
36     uint8 public decimals = 18;
37     // 18 decimals is the strongly suggested default, avoid changing it
38     uint256 public totalSupply ;
39 
40     // This creates an array with all balances
41     mapping (address => uint256) public balanceOf;
42     mapping (address => mapping (address => uint256)) public allowance;
43 
44     // This generates a public event on the blockchain that will notify clients
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 
47     // This notifies clients about the amount burnt
48     event Burn(address indexed from, uint256 value);
49 
50     /**
51      * Constrctor function
52      *
53      * Initializes contract with initial supply tokens to the creator of the contract
54      */
55     function TokenERC20(
56         uint256 initialSupply,
57         string tokenName,
58         string tokenSymbol
59     ) public {
60         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
61         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
62         name = tokenName;                                   // Set the name for display purposes
63         symbol = tokenSymbol;                               // Set the symbol for display purposes
64     }
65 
66     /**
67      * Internal transfer, only can be called by this contract
68      */
69     function _transfer(address _from, address _to, uint _value) internal {
70         // Prevent transfer to 0x0 address. Use burn() instead
71         require(_to != 0x0);
72         // Check if the sender has enough
73         require(balanceOf[_from] >= _value);
74         // Check for overflows
75         require(balanceOf[_to] + _value > balanceOf[_to]);
76         // Save this for an assertion in the future
77         uint previousBalances = balanceOf[_from] + balanceOf[_to];
78         // Subtract from the sender
79         balanceOf[_from] -= _value;
80         // Add the same to the recipient
81         balanceOf[_to] += _value;
82         Transfer(_from, _to, _value);
83         // Asserts are used to use static analysis to find bugs in your code. They should never fail
84         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
85     }
86 
87     /**
88      * Transfer tokens
89      *
90      * Send `_value` tokens to `_to` from your account
91      *
92      * @param _to The address of the recipient
93      * @param _value the amount to send
94      */
95     function transfer(address _to, uint256 _value) public {
96         _transfer(msg.sender, _to, _value);
97     }
98 
99     /**
100      * Transfer tokens from other address
101      *
102      * Send `_value` tokens to `_to` in behalf of `_from`
103      *
104      * @param _from The address of the sender
105      * @param _to The address of the recipient
106      * @param _value the amount to send
107      */
108     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
109         require(_value <= allowance[_from][msg.sender]);     // Check allowance
110         allowance[_from][msg.sender] -= _value;
111         _transfer(_from, _to, _value);
112         return true;
113     }
114 
115     /**
116      * Set allowance for other address
117      *
118      * Allows `_spender` to spend no more than `_value` tokens in your behalf
119      *
120      * @param _spender The address authorized to spend
121      * @param _value the max amount they can spend
122      */
123     function approve(address _spender, uint256 _value) public
124         returns (bool success) {
125         allowance[msg.sender][_spender] = _value;
126         return true;
127     }
128 
129     /**
130      * Set allowance for other address and notify
131      *
132      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
133      *
134      * @param _spender The address authorized to spend
135      * @param _value the max amount they can spend
136      * @param _extraData some extra information to send to the approved contract
137      */
138     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
139         public
140         returns (bool success) {
141         tokenRecipient spender = tokenRecipient(_spender);
142         if (approve(_spender, _value)) {
143             spender.receiveApproval(msg.sender, _value, this, _extraData);
144             return true;
145         }
146     }
147 
148     /**
149      * Destroy tokens
150      *
151      * Remove `_value` tokens from the system irreversibly
152      *
153      * @param _value the amount of money to burn
154      */
155     function burn(uint256 _value) public returns (bool success) {
156         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
157         balanceOf[msg.sender] -= _value;            // Subtract from the sender
158         totalSupply -= _value;                      // Updates totalSupply
159         Burn(msg.sender, _value);
160         return true;
161     }
162 
163     /**
164      * Destroy tokens from other account
165      *
166      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
167      *
168      * @param _from the address of the sender
169      * @param _value the amount of money to burn
170      */
171     function burnFrom(address _from, uint256 _value) public returns (bool success) {
172         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
173         require(_value <= allowance[_from][msg.sender]);    // Check allowance
174         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
175         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
176         totalSupply -= _value;                              // Update totalSupply
177         Burn(_from, _value);
178         return true;
179     }
180 }
181 
182 /******************************************/
183 /*       ADVANCED TOKEN STARTS HERE       */
184 /******************************************/
185 
186 contract CRYSTALCOIN is owned, TokenERC20 {
187 
188     uint256 public sellPrice;
189     uint256 public buyPrice;
190 
191     mapping (address => bool) public frozenAccount;
192 
193     /* This generates a public event on the blockchain that will notify clients */
194     event FrozenFunds(address target, bool frozen);
195 
196     /* Initializes contract with initial supply tokens to the creator of the contract */
197     function CRYSTALCOIN(
198     ) 
199 
200     TokenERC20(1100000, "CrystalCoin", "CRYSTAL") public {}
201     
202     /* Internal transfer, only can be called by this contract */
203     function _transfer(address _from, address _to, uint _value) internal {
204         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
205         require (balanceOf[_from] > _value);                // Check if the sender has enough
206         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
207         require(!frozenAccount[_from]);                     // Check if sender is frozen
208         require(!frozenAccount[_to]);                       // Check if recipient is frozen
209         balanceOf[_from] -= _value;                         // Subtract from the sender
210         balanceOf[_to] += _value;                           // Add the same to the recipient
211         Transfer(_from, _to, _value);
212     }
213 
214     /// @notice Create `mintedAmount` tokens and send it to `target`
215     /// @param target Address to receive the tokens
216     /// @param mintedAmount the amount of tokens it will receive
217     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
218         balanceOf[target] += mintedAmount;
219         totalSupply += mintedAmount;
220         Transfer(0, this, mintedAmount);
221         Transfer(this, target, mintedAmount);
222     }
223 
224     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
225     /// @param target Address to be frozen
226     /// @param freeze either to freeze it or not
227     function freezeAccount(address target, bool freeze) onlyOwner public {
228         frozenAccount[target] = freeze;
229         FrozenFunds(target, freeze);
230     }
231 
232     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
233     /// @param newSellPrice Price the users can sell to the contract
234     /// @param newBuyPrice Price users can buy from the contract
235     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
236         sellPrice = newSellPrice;
237         buyPrice = newBuyPrice;
238     }
239 
240     /// @notice Buy tokens from contract by sending ether
241     function buy() payable public {
242         uint amount = msg.value / buyPrice;               // calculates the amount
243         _transfer(this, msg.sender, amount);              // makes the transfers
244     }
245 
246     /// @notice Sell `amount` tokens to contract
247     /// @param amount amount of tokens to be sold
248     function sell(uint256 amount) public {
249         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
250         _transfer(msg.sender, this, amount);              // makes the transfers
251         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
252     }
253 }