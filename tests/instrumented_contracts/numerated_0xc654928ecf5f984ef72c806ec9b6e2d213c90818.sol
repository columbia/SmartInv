1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {
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
37     // This generates a public event on the blockchain that will notify clients
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 
40     // This notifies clients about the amount burnt
41     event Burn(address indexed from, uint256 value);
42 
43     /**
44      * Constrctor function
45      *
46      * Initializes contract with initial supply tokens to the creator of the contract
47      */
48     constructor(
49         uint256 initialSupply,
50         string tokenName,
51         string tokenSymbol
52     ) public {
53         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
54         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
55         name = tokenName;                                   // Set the name for display purposes
56         symbol = tokenSymbol;                               // Set the symbol for display purposes
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
75         emit Transfer(_from, _to, _value);
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
88     function transfer(address _to, uint256 _value) public returns (bool success) {
89         _transfer(msg.sender, _to, _value);
90         return true;
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
120         emit Approval(msg.sender, _spender, _value);
121         return true;
122     }
123 
124     /**
125      * Set allowance for other address and notify
126      *
127      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
128      *
129      * @param _spender The address authorized to spend
130      * @param _value the max amount they can spend
131      * @param _extraData some extra information to send to the approved contract
132      */
133     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
134         public
135         returns (bool success) {
136         tokenRecipient spender = tokenRecipient(_spender);
137         if (approve(_spender, _value)) {
138             spender.receiveApproval(msg.sender, _value, this, _extraData);
139             return true;
140         }
141     }
142 
143     /**
144      * Destroy tokens
145      *
146      * Remove `_value` tokens from the system irreversibly
147      *
148      * @param _value the amount of money to burn
149      */
150     function burn(uint256 _value) public returns (bool success) {
151         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
152         balanceOf[msg.sender] -= _value;            // Subtract from the sender
153         totalSupply -= _value;                      // Updates totalSupply
154         emit Burn(msg.sender, _value);
155         return true;
156     }
157 
158     /**
159      * Destroy tokens from other account
160      *
161      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
162      *
163      * @param _from the address of the sender
164      * @param _value the amount of money to burn
165      */
166     function burnFrom(address _from, uint256 _value) public returns (bool success) {
167         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
168         require(_value <= allowance[_from][msg.sender]);    // Check allowance
169         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
170         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
171         totalSupply -= _value;                              // Update totalSupply
172         emit Burn(_from, _value);
173         return true;
174     }
175 }
176 
177 contract EDGETVToken is owned, TokenERC20 {
178 
179     uint256 public sellPrice;
180     uint256 public buyPrice;
181 
182     mapping (address => bool) public frozenAccount;
183 
184     /* This generates a public event on the blockchain that will notify clients */
185     event FrozenFunds(address target, bool frozen);
186 
187     /* Initializes contract with initial supply tokens to the creator of the contract */
188     constructor(
189         uint256 initialSupply,
190         string tokenName,
191         string tokenSymbol
192     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
193 
194     /* Internal transfer, only can be called by this contract */
195     function _transfer(address _from, address _to, uint _value) internal {
196         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
197         require (balanceOf[_from] >= _value);               // Check if the sender has enough
198         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
199         require(!frozenAccount[_from]);                     // Check if sender is frozen
200         require(!frozenAccount[_to]);                       // Check if recipient is frozen
201         balanceOf[_from] -= _value;                         // Subtract from the sender
202         balanceOf[_to] += _value;                           // Add the same to the recipient
203         emit Transfer(_from, _to, _value);
204     }
205 
206     /// @notice Create `mintedAmount` tokens and send it to `target`
207     /// @param target Address to receive the tokens
208     /// @param mintedAmount the amount of tokens it will receive
209     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
210         balanceOf[target] += mintedAmount;
211         totalSupply += mintedAmount;
212         emit Transfer(0, this, mintedAmount);
213         emit Transfer(this, target, mintedAmount);
214     }
215 
216     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
217     /// @param target Address to be frozen
218     /// @param freeze either to freeze it or not
219     function freezeAccount(address target, bool freeze) onlyOwner public {
220         frozenAccount[target] = freeze;
221         emit FrozenFunds(target, freeze);
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
234         uint amount = msg.value / buyPrice;               // calculates the amount
235         _transfer(this, msg.sender, amount);              // makes the transfers
236     }
237 
238     /// @notice Sell `amount` tokens to contract
239     /// @param amount amount of tokens to be sold
240     function sell(uint256 amount) public {
241         address myAddress = this;
242         require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
243         _transfer(msg.sender, this, amount);              // makes the transfers
244         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
245     }
246 }