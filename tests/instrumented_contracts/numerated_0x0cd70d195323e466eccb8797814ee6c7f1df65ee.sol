1 pragma solidity ^0.4.16;
2 
3 //ChanChuCoin 
4 //ChanChu Coin Feng Shui
5 //The code is charged for luck, wealth and successful crypto trade. 
6 
7 contract owned {
8     address public owner;
9 
10     function owned() public {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     function transferOwnership(address newOwner) onlyOwner public {
20         owner = newOwner;
21     }
22 }
23 
24 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
25 
26 contract TokenERC20 {
27     // Public variables of the token
28     string public name;
29     string public symbol;
30     uint8 public decimals = 8;
31     // 18 decimals is the strongly suggested default, avoid changing it
32     uint256 public totalSupply;
33 
34     // This creates an array with all balances
35     mapping (address => uint256) public balanceOf;
36     mapping (address => mapping (address => uint256)) public allowance;
37 
38     // This generates a public event on the blockchain that will notify clients
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 
41     // This notifies clients about the amount burnt
42     event Burn(address indexed from, uint256 value);
43 
44     /**
45      * Constrctor function
46      *
47      * Initializes contract with initial supply tokens to the creator of the contract
48      */
49     function TokenERC20(
50         uint256 initialSupply,
51         string tokenName,
52         string tokenSymbol
53     ) public {
54         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
55         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
56         name = tokenName;                                   // Set the name for display purposes
57         symbol = tokenSymbol;                               // Set the symbol for display purposes
58     }
59 
60     /**
61      * Internal transfer, only can be called by this contract
62      */
63     function _transfer(address _from, address _to, uint _value) internal {
64         // Prevent transfer to 0x0 address. Use burn() instead
65         require(_to != 0x0);
66         // Check if the sender has enough
67         require(balanceOf[_from] >= _value);
68         // Check for overflows
69         require(balanceOf[_to] + _value > balanceOf[_to]);
70         // Save this for an assertion in the future
71         uint previousBalances = balanceOf[_from] + balanceOf[_to];
72         // Subtract from the sender
73         balanceOf[_from] -= _value;
74         // Add the same to the recipient
75         balanceOf[_to] += _value;
76         Transfer(_from, _to, _value);
77         // Asserts are used to use static analysis to find bugs in your code. They should never fail
78         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
79     }
80 
81     /**
82      * Transfer tokens
83      *
84      * Send `_value` tokens to `_to` from your account
85      *
86      * @param _to The address of the recipient
87      * @param _value the amount to send
88      */
89     function transfer(address _to, uint256 _value) public {
90         _transfer(msg.sender, _to, _value);
91     }
92 
93     /**
94      * Transfer tokens from other address
95      *
96      * Send `_value` tokens to `_to` in behalf of `_from`
97      *
98      * @param _from The address of the sender
99      * @param _to The address of the recipient
100      * @param _value the amount to send
101      */
102     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
103         require(_value <= allowance[_from][msg.sender]);     // Check allowance
104         allowance[_from][msg.sender] -= _value;
105         _transfer(_from, _to, _value);
106         return true;
107     }
108 
109     /**
110      * Set allowance for other address
111      *
112      * Allows `_spender` to spend no more than `_value` tokens in your behalf
113      *
114      * @param _spender The address authorized to spend
115      * @param _value the max amount they can spend
116      */
117     function approve(address _spender, uint256 _value) public
118         returns (bool success) {
119         allowance[msg.sender][_spender] = _value;
120         return true;
121     }
122 
123     /**
124      * Set allowance for other address and notify
125      *
126      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
127      *
128      * @param _spender The address authorized to spend
129      * @param _value the max amount they can spend
130      * @param _extraData some extra information to send to the approved contract
131      */
132     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
133         public
134         returns (bool success) {
135         tokenRecipient spender = tokenRecipient(_spender);
136         if (approve(_spender, _value)) {
137             spender.receiveApproval(msg.sender, _value, this, _extraData);
138             return true;
139         }
140     }
141 
142     /**
143      * Destroy tokens
144      *
145      * Remove `_value` tokens from the system irreversibly
146      *
147      * @param _value the amount of money to burn
148      */
149     function burn(uint256 _value) public returns (bool success) {
150         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
151         balanceOf[msg.sender] -= _value;            // Subtract from the sender
152         totalSupply -= _value;                      // Updates totalSupply
153         Burn(msg.sender, _value);
154         return true;
155     }
156 
157     /**
158      * Destroy tokens from other account
159      *
160      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
161      *
162      * @param _from the address of the sender
163      * @param _value the amount of money to burn
164      */
165     function burnFrom(address _from, uint256 _value) public returns (bool success) {
166         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
167         require(_value <= allowance[_from][msg.sender]);    // Check allowance
168         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
169         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
170         totalSupply -= _value;                              // Update totalSupply
171         Burn(_from, _value);
172         return true;
173     }
174 }
175 
176 /******************************************/
177 /*       ADVANCED TOKEN STARTS HERE       */
178 /******************************************/
179 
180 contract MyAdvancedToken is owned, TokenERC20 {
181 
182     uint256 public sellPrice;
183     uint256 public buyPrice;
184 
185     mapping (address => bool) public frozenAccount;
186 
187     /* This generates a public event on the blockchain that will notify clients */
188     event FrozenFunds(address target, bool frozen);
189 
190     /* Initializes contract with initial supply tokens to the creator of the contract */
191     function MyAdvancedToken(
192         uint256 initialSupply,
193         string tokenName,
194         string tokenSymbol
195     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
196 
197     /* Internal transfer, only can be called by this contract */
198     function _transfer(address _from, address _to, uint _value) internal {
199         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
200         require (balanceOf[_from] >= _value);               // Check if the sender has enough
201         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
202         require(!frozenAccount[_from]);                     // Check if sender is frozen
203         require(!frozenAccount[_to]);                       // Check if recipient is frozen
204         balanceOf[_from] -= _value;                         // Subtract from the sender
205         balanceOf[_to] += _value;                           // Add the same to the recipient
206         Transfer(_from, _to, _value);
207     }
208 
209     /// @notice Create `mintedAmount` tokens and send it to `target`
210     /// @param target Address to receive the tokens
211     /// @param mintedAmount the amount of tokens it will receive
212     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
213         balanceOf[target] += mintedAmount;
214         totalSupply += mintedAmount;
215         Transfer(0, this, mintedAmount);
216         Transfer(this, target, mintedAmount);
217     }
218 
219     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
220     /// @param target Address to be frozen
221     /// @param freeze either to freeze it or not
222     function freezeAccount(address target, bool freeze) onlyOwner public {
223         frozenAccount[target] = freeze;
224         FrozenFunds(target, freeze);
225     }
226 
227     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
228     /// @param newSellPrice Price the users can sell to the contract
229     /// @param newBuyPrice Price users can buy from the contract
230     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
231         sellPrice = newSellPrice;
232         buyPrice = newBuyPrice;
233     }
234 
235     /// @notice Buy tokens from contract by sending ether
236     function buy() payable public {
237         uint amount = msg.value / buyPrice;               // calculates the amount
238         _transfer(this, msg.sender, amount);              // makes the transfers
239     }
240 
241     /// @notice Sell `amount` tokens to contract
242     /// @param amount amount of tokens to be sold
243     function sell(uint256 amount) public {
244         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
245         _transfer(msg.sender, this, amount);              // makes the transfers
246         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
247     }
248 }