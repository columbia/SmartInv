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
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
21 
22 contract TokenERC20 {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     uint256 public totalSupply;
28 
29     
30     mapping (address => uint256) public balanceOf;
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     
36    
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 
39     event Burn(address indexed from, uint256 value);
40 
41     /**
42      * Constrctor function
43      *
44      * Initializes contract with initial supply tokens to the creator of the contract
45      */
46     function TokenERC20(
47         uint256 initialSupply,
48         string tokenName,
49         string tokenSymbol
50     ) public {
51         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
52         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
53         name = tokenName;                                   // Set the name for display purposes
54         symbol = tokenSymbol;                               // Set the symbol for display purposes
55     }
56 
57     /**
58      * Internal transfer, only can be called by this contract
59      */
60     function _transfer(address _from, address _to, uint _value) internal {
61         // Prevent transfer to 0x0 address. Use burn() instead
62         require(_to != 0x0);
63         // Check if the sender has enough
64         require(balanceOf[_from] >= _value);
65         // Check for overflows
66         require(balanceOf[_to] + _value > balanceOf[_to]);
67         // Save this for an assertion in the future
68         uint previousBalances = balanceOf[_from] + balanceOf[_to];
69         // Subtract from the sender
70         balanceOf[_from] -= _value;
71         // Add the same to the recipient
72         balanceOf[_to] += _value;
73         emit Transfer(_from, _to, _value);
74         // Asserts are used to use static analysis to find bugs in your code. They should never fail
75         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
76     }
77 
78     /**
79      * Transfer tokens
80      *
81      * Send `_value` tokens to `_to` from your account
82      *
83      * @param _to The address of the recipient
84      * @param _value the amount to send
85      */
86     function transfer(address _to, uint256 _value) public returns (bool success) {
87         _transfer(msg.sender, _to, _value);
88         return true;
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
118         emit Approval(msg.sender, _spender, _value);
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
152         emit Burn(msg.sender, _value);
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
170         emit Burn(_from, _value);
171         return true;
172     }
173 }
174 
175 /******************************************/
176 /*       ADVANCED TOKEN STARTS HERE       */
177 /******************************************/
178 
179 contract MyAdvancedToken is owned, TokenERC20 {
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
190     function MyAdvancedToken(
191         uint256 initialSupply,
192         string tokenName,
193         string tokenSymbol
194     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
195 
196     /* Internal transfer, only can be called by this contract */
197     function _transfer(address _from, address _to, uint _value) internal {
198         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
199         require (balanceOf[_from] >= _value);               // Check if the sender has enough
200         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
201         require(!frozenAccount[_from]);                     // Check if sender is frozen
202         require(!frozenAccount[_to]);                       // Check if recipient is frozen
203         balanceOf[_from] -= _value;                         // Subtract from the sender
204         balanceOf[_to] += _value;                           // Add the same to the recipient
205         emit Transfer(_from, _to, _value);
206     }
207 
208     /// @notice Create `mintedAmount` tokens and send it to `target`
209     /// @param target Address to receive the tokens
210     /// @param mintedAmount the amount of tokens it will receive
211     
212   
213     
214     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
215         balanceOf[target] += mintedAmount;
216         totalSupply += mintedAmount;
217         emit Transfer(0, this, mintedAmount);
218         emit Transfer(this, target, mintedAmount);
219     }
220     
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