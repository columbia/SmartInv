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
22 contract TokenERC20 {
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
37 	event Approval(address indexed owner, address indexed spender, uint256 value);
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
74         Transfer(_from, _to, _value);
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
115     function approve(address _spender, uint256 _value) public
116         returns (bool success) {
117         allowance[msg.sender][_spender] = _value;
118         return true;
119     }
120 
121     /**
122      * Set allowance for other address and notify
123      *
124      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
125      *
126      * @param _spender The address authorized to spend
127      * @param _value the max amount they can spend
128      * @param _extraData some extra information to send to the approved contract
129      */
130     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
131         public
132         returns (bool success) {
133         tokenRecipient spender = tokenRecipient(_spender);
134         if (approve(_spender, _value)) {
135             spender.receiveApproval(msg.sender, _value, this, _extraData);
136             return true;
137         }
138     }
139 
140     /**
141      * Destroy tokens
142      *
143      * Remove `_value` tokens from the system irreversibly
144      *
145      * @param _value the amount of money to burn
146      */
147     function burn(uint256 _value) public returns (bool success) {
148         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
149         balanceOf[msg.sender] -= _value;            // Subtract from the sender
150         totalSupply -= _value;                      // Updates totalSupply
151         Burn(msg.sender, _value);
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
169         Burn(_from, _value);
170         return true;
171     }
172 }
173 
174 /******************************************/
175 /*       ADVANCED TOKEN STARTS HERE       */
176 /******************************************/
177 
178 contract MyAdvancedToken is owned, TokenERC20 {
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
189     function MyAdvancedToken() TokenERC20(0, "HighBitcoinToken", "HBT") public {
190         sellPrice = (uint256(10) ** decimals) / 1000;/*that is 100000*100000*100000, and then 1 ether for 1000 tokens*/
191         buyPrice  = (uint256(10) ** decimals) / 1000;/*that is 100000*100000*100000, and then 1 ether for 1000 tokens*/
192     }
193 
194     /* Internal transfer, only can be called by this contract */
195     function _transfer(address _from, address _to, uint _value) internal {
196         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
197         require (balanceOf[_from] >= _value);               // Check if the sender has enough
198         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
199         require(!frozenAccount[_from]);                     // Check if sender is frozen
200         require(!frozenAccount[_to]);                       // Check if recipient is frozen
201         balanceOf[_from] -= _value;                         // Subtract from the sender
202         balanceOf[_to] += _value;                           // Add the same to the recipient
203         Transfer(_from, _to, _value);
204     }
205 
206     /// @notice Create `mintedAmount` tokens and send it to `target`
207     /// @param target Address to receive the tokens
208     /// @param mintedAmount the amount of tokens it will receive
209     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
210         balanceOf[target] += mintedAmount;
211         totalSupply += mintedAmount;
212         Transfer(0, this, mintedAmount);
213         Transfer(this, target, mintedAmount);
214     }
215 
216     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
217     /// @param target Address to be frozen
218     /// @param freeze either to freeze it or not
219     function freezeAccount(address target, bool freeze) onlyOwner public {
220         frozenAccount[target] = freeze;
221         FrozenFunds(target, freeze);
222     }
223 
224     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
225     /// @param newSellPrice Price the users can sell to the contract
226     /// @param newBuyPrice Price users can buy from the contract
227     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
228         sellPrice = newSellPrice;
229         buyPrice = newBuyPrice;
230     }
231 
232     /// @notice Buy tokens from contract by sending ether
233     function buy() payable public {
234         uint amount = msg.value * (uint256(10) ** decimals) / buyPrice;               // calculates the amount
235         _transfer(this, msg.sender, amount);              // makes the transfers
236     }
237 
238     /// @notice Sell `amount` tokens to contract
239     /// @param amount amount of tokens to be sold
240     function sell(uint256 amount) public {
241         require(this.balance >= amount * sellPrice / (uint256(10) ** decimals));      // checks if the contract has enough ether to buy
242         _transfer(msg.sender, this, amount);              // makes the transfers
243         msg.sender.transfer(amount * sellPrice / (uint256(10) ** decimals));          // sends ether to the seller. It's important to do this last to avoid recursion attacks
244     }
245 }