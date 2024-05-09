1 pragma solidity ^0.4.18;
2 
3 contract owned {
4     address public owner;
5 
6 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     function owned() public {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address newOwner) onlyOwner public {
18 		require(newOwner != address(0));
19 		owner = newOwner;
20 		OwnershipTransferred(owner, newOwner);
21     }
22 }
23 
24 contract mortal is owned {
25     function kill() public {
26         if (msg.sender == owner) selfdestruct(owner);
27     }
28 }
29 
30 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
31 
32 contract ThreadCore {
33     // Public variables of the token
34     string public version = "1.0.0";    
35     string public name;
36     string public symbol;
37     uint8 public decimals = 18;
38     // 18 decimals is the strongly suggested default, avoid changing it
39     uint256 public totalSupply;
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
56     function ThreadCore(
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
187 contract Thread is owned, mortal, ThreadCore {
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
198     function Thread(
199         uint256 initialSupply,
200         string tokenName,
201         string tokenSymbol
202     ) ThreadCore(initialSupply, tokenName, tokenSymbol) public {}
203 
204     /* Internal transfer, only can be called by this contract */
205     function _transfer(address _from, address _to, uint _value) internal {
206         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
207         require (balanceOf[_from] >= _value);               // Check if the sender has enough
208         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
209         require(!frozenAccount[_from]);                     // Check if sender is frozen
210         require(!frozenAccount[_to]);                       // Check if recipient is frozen
211         balanceOf[_from] -= _value;                         // Subtract from the sender
212         balanceOf[_to] += _value;                           // Add the same to the recipient
213         Transfer(_from, _to, _value);
214     }
215 
216     /// @notice Create `mintedAmount` tokens and send it to `target`
217     /// @param target Address to receive the tokens
218     /// @param mintedAmount the amount of tokens it will receive
219     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
220         balanceOf[target] += mintedAmount;
221         totalSupply += mintedAmount;
222         Transfer(0, this, mintedAmount);
223         Transfer(this, target, mintedAmount);
224     }
225 
226     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
227     /// @param target Address to be frozen
228     /// @param freeze either to freeze it or not
229     function freezeAccount(address target, bool freeze) onlyOwner public {
230         frozenAccount[target] = freeze;
231         FrozenFunds(target, freeze);
232     }
233 
234     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
235     /// @param newSellPrice Price the users can sell to the contract
236     /// @param newBuyPrice Price users can buy from the contract
237     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
238     	require(newSellPrice > newBuyPrice);
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
250     /// @param amount amount of tokens to be sold
251     function sell(uint256 amount) public {
252         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
253         _transfer(msg.sender, this, amount);              // makes the transfers
254         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
255     }
256 }