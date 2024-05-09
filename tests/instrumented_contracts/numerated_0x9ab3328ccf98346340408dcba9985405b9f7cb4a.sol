1 pragma solidity ^0.4.21;
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
20 interface tokenRecipient {
21     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
22 }
23 
24 contract TokenERC20 {
25     // Public variables of the token
26     string public name;
27     string public symbol;
28     uint8 public decimals = 18;
29     // 18 decimals is the strongly suggested default, avoid changing it
30     uint256 public totalSupply;
31 
32     // This creates an array with all balances
33     mapping (address => uint256) public balanceOf;
34     mapping (address => mapping (address => uint256)) public allowance;
35 
36     // This generates a public event on the blockchain that will notify clients
37     event Transfer(address indexed from, address indexed to, uint256 value);
38 
39     // This notifies clients about the amount burnt
40     event Burn(address indexed from, uint256 value);
41 
42     /**
43      * Constrctor function
44      *
45      * Initializes contract with initial supply tokens to the creator of the contract
46      */
47     function TokenERC20(
48         uint256 initialSupply,
49         string tokenName,
50         string tokenSymbol
51     ) public {
52         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
53         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
54         name = tokenName;                                   // Set the name for display purposes
55         symbol = tokenSymbol;                               // Set the symbol for display purposes
56     }
57 
58     /**
59      * Internal transfer, only can be called by this contract
60      */
61     function _transfer(address _from, address _to, uint _value) internal {
62         // Prevent transfer to 0x0 address. Use burn() instead
63         require(_to != 0x0);
64         // Check if the sender has enough
65         require(balanceOf[_from] >= _value);
66         // Check for overflows
67         require(balanceOf[_to] + _value > balanceOf[_to]);
68         // Save this for an assertion in the future
69         uint previousBalances = balanceOf[_from] + balanceOf[_to];
70         // Subtract from the sender
71         balanceOf[_from] -= _value;
72         // Add the same to the recipient
73         balanceOf[_to] += _value;
74         emit Transfer(_from, _to, _value);
75         // Asserts are used to use static analysis to find bugs in your code. They should never fail
76         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
77     }
78 
79     /**
80      * Transfer tokens
81      *
82      * Send `_value` tokens to `_to` from your account
83      *
84      * @param _to The address of the recipient
85      * @param _value the amount to send
86      */
87     function transfer(address _to, uint256 _value) public {
88         _transfer(msg.sender, _to, _value);
89     }
90 
91     /**
92      * Transfer tokens from other address
93      *
94      * Send `_value` tokens to `_to` in behalf of `_from`
95      *
96      * @param _from The address of the sender
97      * @param _to The address of the recipient
98      * @param _value the amount to send
99      */
100     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
101         require(_value <= allowance[_from][msg.sender]);     // Check allowance
102         allowance[_from][msg.sender] -= _value;
103         _transfer(_from, _to, _value);
104         return true;
105     }
106 
107     /**
108      * Set allowance for other address
109      *
110      * Allows `_spender` to spend no more than `_value` tokens in your behalf
111      *
112      * @param _spender The address authorized to spend
113      * @param _value the max amount they can spend
114      */
115     function approve(address _spender, uint256 _value) public returns (bool success) {
116         allowance[msg.sender][_spender] = _value;
117         return true;
118     }
119 
120     /**
121      * Set allowance for other address and notify
122      *
123      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
124      *
125      * @param _spender The address authorized to spend
126      * @param _value the max amount they can spend
127      * @param _extraData some extra information to send to the approved contract
128      */
129     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
130         tokenRecipient spender = tokenRecipient(_spender);
131         if (approve(_spender, _value)) {
132             spender.receiveApproval(msg.sender, _value, this, _extraData);
133             return true;
134         }
135     }
136 
137     /**
138      * Destroy tokens
139      *
140      * Remove `_value` tokens from the system irreversibly
141      *
142      * @param _value the amount of money to burn
143      */
144     function burn(uint256 _value) public returns (bool success) {
145         // Check if the sender has enough
146         require(balanceOf[msg.sender] >= _value);
147         // Subtract from the sender
148         balanceOf[msg.sender] -= _value;
149         // Updates totalSupply
150         totalSupply -= _value;
151         emit Burn(msg.sender, _value);
152         return true;
153     }
154 
155     /**
156      * Destroy tokens from other account
157      *
158      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
159      *
160      * @param _from the address of the sender
161      * @param _value the amount of money to burn
162      */
163     function burnFrom(address _from, uint256 _value) public returns (bool success) {
164         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
165         require(_value <= allowance[_from][msg.sender]);    // Check allowance
166         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
167         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
168         totalSupply -= _value;                              // Update totalSupply
169         emit Burn(_from, _value);
170         return true;
171     }
172 }
173 
174 /******************************************/
175 /*       ADVANCED TOKEN STARTS HERE       */
176 /******************************************/
177 
178 contract MyToken is owned, TokenERC20 {
179 
180     uint256 public sellPrice;
181     uint256 public buyPrice;
182 
183     mapping (address => bool) public frozenAccount;
184 
185     /* This generates a public event on the blockchain that will notify clients */
186     event FrozenFunds(address target, bool frozen);
187 
188     /* Initializes contract with initial supply tokens to the creator of the contract */
189     function MyToken(
190         uint256 initialSupply,
191         string tokenName,
192         string tokenSymbol
193     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
194 
195     /* Internal transfer, only can be called by this contract */
196     function _transfer(address _from, address _to, uint _value) internal {
197         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
198         require (balanceOf[_from] >= _value);               // Check if the sender has enough
199         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
200         require(!frozenAccount[_from]);                     // Check if sender is frozen
201         require(!frozenAccount[_to]);                       // Check if recipient is frozen
202         balanceOf[_from] -= _value;                         // Subtract from the sender
203         balanceOf[_to] += _value;                           // Add the same to the recipient
204         emit Transfer(_from, _to, _value);
205     }
206 
207     /// @notice Create `mintedAmount` tokens and send it to `target`
208     /// @param target Address to receive the tokens
209     /// @param mintedAmount the amount of tokens it will receive
210     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
211         balanceOf[target] += mintedAmount;
212         totalSupply += mintedAmount;
213         emit Transfer(0, this, mintedAmount);
214         emit Transfer(this, target, mintedAmount);
215     }
216 
217     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
218     /// @param target Address to be frozen
219     /// @param freeze either to freeze it or not
220     function freezeAccount(address target, bool freeze) onlyOwner public {
221         frozenAccount[target] = freeze;
222         emit FrozenFunds(target, freeze);
223     }
224 
225     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
226     /// @param newSellPrice Price the users can sell to the contract
227     /// @param newBuyPrice Price users can buy from the contract
228     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
229         sellPrice = newSellPrice;
230         buyPrice = newBuyPrice;
231     }
232 
233     /// @notice Buy tokens from contract by sending ether
234     function buy() payable public {
235         // calculates the amount
236         uint amount = msg.value / buyPrice;
237         // makes the transfers
238         _transfer(this, msg.sender, amount);
239     }
240 
241     /// @notice Sell `amount` tokens to contract
242     /// @param amount amount of tokens to be sold
243     function sell(uint256 amount) public {
244         address myAddress = this;
245         require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
246         _transfer(msg.sender, this, amount);              // makes the transfers
247         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
248     }
249 }