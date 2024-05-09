1 /**
2  * WHOIS Token
3  * Version 1.00
4  * TrueValue Holdings
5  * Interwave Global
6  * www.iw-global.com
7  * www.ethWhois.com
8  **/
9  
10  
11 pragma solidity ^0.4.18;
12 
13 
14 contract owned {
15     address public owner;
16 
17     function owned() public {
18         owner = msg.sender;
19     }
20 
21     modifier onlyOwner {
22         require(msg.sender == owner);
23         _;
24     }
25 
26     function transferOwnership(address newOwner) onlyOwner public {
27         owner = newOwner;
28     }
29 }
30 
31 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
32 
33 contract TokenERC20 {
34     // Public variables of the token
35     string public name  ;
36     string public symbol  ;
37     uint8 public decimals = 18;
38     // 18 decimals is the strongly suggested default, avoid changing it
39     uint256 public totalSupply ;
40 
41     // This creates an array with all balances
42     mapping (address => uint256) public balanceOf;
43     mapping (address => mapping (address => uint256)) public allowance;
44 
45     // This generates a public event on the blockchain that will notify clients
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 
48     // This notifies clients about the amount burnt
49     event Burn(address indexed from, uint256 value);
50 
51     /**
52      * Constrctor function
53      *
54      * Initializes contract with initial supply tokens to the creator of the contract
55      */
56     function TokenERC20(
57         uint256 initialSupply,
58         string tokenName,
59         string tokenSymbol
60     ) public {
61         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
62         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
63         name = tokenName;                                   // Set the name for display purposes
64         symbol = tokenSymbol;                               // Set the symbol for display purposes
65     }
66 
67     /**
68      * Internal transfer, only can be called by this contract
69      */
70     function _transfer(address _from, address _to, uint _value) internal {
71         // Prevent transfer to 0x0 address. Use burn() instead
72         require(_to != 0x0);
73         // Check if the sender has enough
74         require(balanceOf[_from] >= _value);
75         // Check for overflows
76         require(balanceOf[_to] + _value > balanceOf[_to]);
77         // Save this for an assertion in the future
78         uint previousBalances = balanceOf[_from] + balanceOf[_to];
79         // Subtract from the sender
80         balanceOf[_from] -= _value;
81         // Add the same to the recipient
82         balanceOf[_to] += _value;
83         Transfer(_from, _to, _value);
84         // Asserts are used to use static analysis to find bugs in your code. They should never fail
85         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
86     }
87 
88     /**
89      * Transfer tokens
90      *
91      * Send `_value` tokens to `_to` from your account
92      *
93      * @param _to The address of the recipient
94      * @param _value the amount to send
95      */
96     function transfer(address _to, uint256 _value) public {
97         _transfer(msg.sender, _to, _value);
98     }
99 
100     /**
101      * Transfer tokens from other address
102      *
103      * Send `_value` tokens to `_to` in behalf of `_from`
104      *
105      * @param _from The address of the sender
106      * @param _to The address of the recipient
107      * @param _value the amount to send
108      */
109     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
110         require(_value <= allowance[_from][msg.sender]);     // Check allowance
111         allowance[_from][msg.sender] -= _value;
112         _transfer(_from, _to, _value);
113         return true;
114     }
115 
116     /**
117      * Set allowance for other address
118      *
119      * Allows `_spender` to spend no more than `_value` tokens in your behalf
120      *
121      * @param _spender The address authorized to spend
122      * @param _value the max amount they can spend
123      */
124     function approve(address _spender, uint256 _value) public
125         returns (bool success) {
126         allowance[msg.sender][_spender] = _value;
127         return true;
128     }
129 
130     /**
131      * Set allowance for other address and notify
132      *
133      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
134      *
135      * @param _spender The address authorized to spend
136      * @param _value the max amount they can spend
137      * @param _extraData some extra information to send to the approved contract
138      */
139     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
140         public
141         returns (bool success) {
142         tokenRecipient spender = tokenRecipient(_spender);
143         if (approve(_spender, _value)) {
144             spender.receiveApproval(msg.sender, _value, this, _extraData);
145             return true;
146         }
147     }
148 
149     /**
150      * Destroy tokens
151      *
152      * Remove `_value` tokens from the system irreversibly
153      *
154      * @param _value the amount of money to burn
155      */
156     function burn(uint256 _value) public returns (bool success) {
157         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
158         balanceOf[msg.sender] -= _value;            // Subtract from the sender
159         totalSupply -= _value;                      // Updates totalSupply
160         Burn(msg.sender, _value);
161         return true;
162     }
163 
164     /**
165      * Destroy tokens from other account
166      *
167      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
168      *
169      * @param _from the address of the sender
170      * @param _value the amount of money to burn
171      */
172     function burnFrom(address _from, uint256 _value) public returns (bool success) {
173         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
174         require(_value <= allowance[_from][msg.sender]);    // Check allowance
175         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
176         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
177         totalSupply -= _value;                              // Update totalSupply
178         Burn(_from, _value);
179         return true;
180     }
181 }
182 
183 /******************************************/
184 /*       ADVANCED TOKEN STARTS HERE       */
185 /******************************************/
186 
187 contract WHOIS is owned, TokenERC20 {
188 
189     uint256 public sellPrice;
190     uint256 public buyPrice;
191 
192     mapping (address => bool) public frozenAccount;
193 
194     /* This generates a public event on the blockchain that will notify clients */
195     event FrozenFunds(address target, bool frozen);
196 
197     /* Initializes contract with initial supply tokens to the creator of the contract */
198     function WHOIS(
199     ) 
200 
201     TokenERC20(100000000, "WHOIS", "ethWHOIS") public {}
202     
203     /* Internal transfer, only can be called by this contract */
204     function _transfer(address _from, address _to, uint _value) internal {
205         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
206         require (balanceOf[_from] > _value);                // Check if the sender has enough
207         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
208         require(!frozenAccount[_from]);                     // Check if sender is frozen
209         require(!frozenAccount[_to]);                       // Check if recipient is frozen
210         balanceOf[_from] -= _value;                         // Subtract from the sender
211         balanceOf[_to] += _value;                           // Add the same to the recipient
212         Transfer(_from, _to, _value);
213     }
214 
215     /// @notice Create `mintedAmount` tokens and send it to `target`
216     /// @param target Address to receive the tokens
217     /// @param mintedAmount the amount of tokens it will receive
218     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
219         balanceOf[target] += mintedAmount;
220         totalSupply += mintedAmount;
221         Transfer(0, this, mintedAmount);
222         Transfer(this, target, mintedAmount);
223     }
224 
225     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
226     /// @param target Address to be frozen
227     /// @param freeze either to freeze it or not
228     function freezeAccount(address target, bool freeze) onlyOwner public {
229         frozenAccount[target] = freeze;
230         FrozenFunds(target, freeze);
231     }
232 
233     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
234     /// @param newSellPrice Price the users can sell to the contract
235     /// @param newBuyPrice Price users can buy from the contract
236     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
237         sellPrice = newSellPrice;
238         buyPrice = newBuyPrice;
239     }
240 
241     /// @notice Buy tokens from contract by sending ether
242     function buy() payable public {
243         uint amount = msg.value / buyPrice;               // calculates the amount
244         _transfer(this, msg.sender, amount);              // makes the transfers
245     }
246 
247     /// @notice Sell `amount` tokens to contract
248     /// @param amount amount of tokens to be sold
249     function sell(uint256 amount) public {
250         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
251         _transfer(msg.sender, this, amount);              // makes the transfers
252         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
253     }
254 }