1 contract owned {
2     address public owner;
3 
4     constructor() public {
5         owner = msg.sender;
6     }
7 
8     modifier onlyOwner {
9         require(msg.sender == owner);
10         _;
11     }
12 
13     function transferOwnership(address newOwner) onlyOwner public {
14         owner = newOwner;
15     }
16 }
17 
18 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
19 
20 contract TokenERC20 {
21     // Public variables of the token
22     string public name;
23     string public symbol;
24     uint8 public decimals = 18;
25     // 18 decimals is the strongly suggested default, avoid changing it
26     uint256 public totalSupply;
27 
28     // This creates an array with all balances
29     mapping (address => uint256) public balanceOf;
30     mapping (address => mapping (address => uint256)) public allowance;
31 
32     // This generates a public event on the blockchain that will notify clients
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 
35     // This notifies clients about the amount burnt
36     event Burn(address indexed from, uint256 value);
37 
38     /**
39      * Constrctor function
40      *
41      * Initializes contract with initial supply tokens to the creator of the contract
42      */
43     function TokenERC20(
44         uint256 initialSupply,
45         string tokenName,
46         string tokenSymbol
47     ) public {
48         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
49         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
50         name = tokenName;                                   // Set the name for display purposes
51         symbol = tokenSymbol;                               // Set the symbol for display purposes
52     }
53 
54     /**
55      * Internal transfer, only can be called by this contract
56      */
57     function _transfer(address _from, address _to, uint _value) internal {
58         // Prevent transfer to 0x0 address. Use burn() instead
59         require(_to != 0x0);
60         // Check if the sender has enough
61         require(balanceOf[_from] >= _value);
62         // Check for overflows
63         require(balanceOf[_to] + _value > balanceOf[_to]);
64         // Save this for an assertion in the future
65         uint previousBalances = balanceOf[_from] + balanceOf[_to];
66         // Subtract from the sender
67         balanceOf[_from] -= _value;
68         // Add the same to the recipient
69         balanceOf[_to] += _value;
70         emit Transfer(_from, _to, _value);
71         // Asserts are used to use static analysis to find bugs in your code. They should never fail
72         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
73     }
74 
75     /**
76      * Transfer tokens
77      *
78      * Send `_value` tokens to `_to` from your account
79      *
80      * @param _to The address of the recipient
81      * @param _value the amount to send
82      */
83     function transfer(address _to, uint256 _value) public {
84         _transfer(msg.sender, _to, _value);
85     }
86 
87     /**
88      * Transfer tokens from other address
89      *
90      * Send `_value` tokens to `_to` in behalf of `_from`
91      *
92      * @param _from The address of the sender
93      * @param _to The address of the recipient
94      * @param _value the amount to send
95      */
96     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
97         require(_value <= allowance[_from][msg.sender]);     // Check allowance
98         allowance[_from][msg.sender] -= _value;
99         _transfer(_from, _to, _value);
100         return true;
101     }
102 
103     /**
104      * Set allowance for other address
105      *
106      * Allows `_spender` to spend no more than `_value` tokens in your behalf
107      *
108      * @param _spender The address authorized to spend
109      * @param _value the max amount they can spend
110      */
111     function approve(address _spender, uint256 _value) public
112         returns (bool success) {
113         allowance[msg.sender][_spender] = _value;
114         return true;
115     }
116 
117     /**
118      * Set allowance for other address and notify
119      *
120      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
121      *
122      * @param _spender The address authorized to spend
123      * @param _value the max amount they can spend
124      * @param _extraData some extra information to send to the approved contract
125      */
126     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
127         public
128         returns (bool success) {
129         tokenRecipient spender = tokenRecipient(_spender);
130         if (approve(_spender, _value)) {
131             spender.receiveApproval(msg.sender, _value, this, _extraData);
132             return true;
133         }
134     }
135 
136     /**
137      * Destroy tokens
138      *
139      * Remove `_value` tokens from the system irreversibly
140      *
141      * @param _value the amount of money to burn
142      */
143     function burn(uint256 _value) public returns (bool success) {
144         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
145         balanceOf[msg.sender] -= _value;            // Subtract from the sender
146         totalSupply -= _value;                      // Updates totalSupply
147         emit Burn(msg.sender, _value);
148         return true;
149     }
150 
151     /**
152      * Destroy tokens from other ccount
153      *
154      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
155      *
156      * @param _from the address of the sender
157      * @param _value the amount of money to burn
158      */
159     function burnFrom(address _from, uint256 _value) public returns (bool success) {
160         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
161         require(_value <= allowance[_from][msg.sender]);    // Check allowance
162         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
163         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
164         totalSupply -= _value;                              // Update totalSupply
165         emit Burn(_from, _value);
166         return true;
167     }
168 }
169 
170 /******************************************/
171 /*       ADVANCED TOKEN STARTS HERE       */
172 /******************************************/
173 
174 contract CryptosisToken is owned, TokenERC20 {
175 
176     uint256 public sellPrice;
177     uint256 public buyPrice;
178 
179     mapping (address => bool) public frozenAccount;
180 
181     /* This generates a public event on the blockchain that will notify clients */
182     event FrozenFunds(address target, bool frozen);
183 
184     /* Initializes contract with initial supply tokens to the creator of the contract */
185     function CryptosisToken(
186         uint256 initialSupply,
187         string tokenName,
188         string tokenSymbol
189     ) TokenERC20(42000000, "Cryptosis", "CRY") public {} 
190     /*TokenERC20(initialSupply, tokenName, tokenSymbol) public {}*/
191 
192     /* Internal transfer, only can be called by this contract */
193     function _transfer(address _from, address _to, uint _value) internal {
194         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
195         require (balanceOf[_from] > _value);                // Check if the sender has enough
196         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
197         require(!frozenAccount[_from]);                     // Check if sender is frozen
198         require(!frozenAccount[_to]);                       // Check if recipient is frozen
199         balanceOf[_from] -= _value;                         // Subtract from the sender
200         balanceOf[_to] += _value;                           // Add the same to the recipient
201         emit Transfer(_from, _to, _value);
202     }
203 
204     /// @notice Create `mintedAmount` tokens and send it to `target`
205     /// @param target Address to receive the tokens
206     /// @param mintedAmount the amount of tokens it will receive
207     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
208         balanceOf[target] += mintedAmount;
209         totalSupply += mintedAmount;
210         emit Transfer(0, this, mintedAmount);
211         emit Transfer(this, target, mintedAmount);
212     }
213 
214     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
215     /// @param target Address to be frozen
216     /// @param freeze either to freeze it or not
217     function freezeAccount(address target, bool freeze) onlyOwner public {
218         frozenAccount[target] = freeze;
219         emit FrozenFunds(target, freeze);
220     }
221 
222     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
223     /// @param newSellPrice Price the users can sell to the contract
224     /// @param newBuyPrice Price users can buy from the contract
225     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
226         sellPrice = newSellPrice;
227         buyPrice = newBuyPrice;
228     }
229 
230     /// @notice Buy tokens from contract by sending ether
231     function buy() payable public {
232         uint amount = msg.value / buyPrice;               // calculates the amount
233         _transfer(this, msg.sender, amount);              // makes the transfers
234     }
235 
236     /// @notice Sell `amount` tokens to contract
237     /// @param amount amount of tokens to be sold
238     function sell(uint256 amount) public {
239         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
240         _transfer(msg.sender, this, amount);              // makes the transfers
241         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
242     }
243 }