1 pragma solidity ^0.4.16;
2 
3 contract owned {
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
22 contract PiToken {
23     // Public variables of the token
24     string public name = "PiToken";
25     string public symbol = "PIT";
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
45     
46     function PiToken (
47         uint256 initialSupply,
48         string  tokenName,
49         string  tokenSymbol
50         
51     ) 
52 public {
53         totalSupply = initialSupply * 3141592653589793238 ** uint256(decimals);  // Update total supply with the decimal amount
54         balanceOf[msg.sender] = totalSupply = 3141592653589793238;                // Give the creator all initial tokens
55         tokenName = "PiToken";                                   // Set the name for display purposes
56         tokenSymbol = "PIT";                               // Set the symbol for display purposes
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
179 contract WilliamJones is owned, PiToken {
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
190     function WilliamJones(
191         uint256 initialSupply,
192         string tokenName,
193         string tokenSymbol
194     ) PiToken(initialSupply, tokenName, tokenSymbol) public {}
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
208     /// @notice Create `mintedAmount` tokens and send it to `target`
209     /// @param target Address to receive the tokens
210     /// @param mintedAmount the amount of tokens it will receive
211     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
212         balanceOf[target] += mintedAmount;
213         totalSupply += mintedAmount;
214         Transfer(0, this, mintedAmount);
215         Transfer(this, target, mintedAmount);
216     }
217 
218     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
219     /// @param target Address to be frozen
220     /// @param freeze either to freeze it or not
221     function freezeAccount(address target, bool freeze) onlyOwner public {
222         frozenAccount[target] = freeze;
223         FrozenFunds(target, freeze);
224     }
225 
226     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
227     /// @param newSellPrice Price the users can sell to the contract
228     /// @param newBuyPrice Price users can buy from the contract
229     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
230         sellPrice = newSellPrice;
231         buyPrice = newBuyPrice;
232     }
233 
234     /// @notice Buy tokens from contract by sending ether
235     function buy() payable public {
236         uint amount = msg.value / buyPrice;               // calculates the amount
237         _transfer(this, msg.sender, amount);              // makes the transfers
238     }
239 
240     /// @notice Sell `amount` tokens to contract
241     /// @param amount amount of tokens to be sold
242     function sell(uint256 amount) public {
243         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
244         _transfer(msg.sender, this, amount);              // makes the transfers
245         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
246     }
247 }