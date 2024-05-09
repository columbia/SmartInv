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
53         totalSupply = initialSupply * 10 ** uint256(decimals);  	// Update total supply with the decimal amount
54         balanceOf[msg.sender] = totalSupply;                		// Give the creator all initial tokens
55         name = tokenName;                                   		// Set the name for display purposes
56         symbol = tokenSymbol;                               		// Set the symbol for display purposes
57 		emit Transfer(address(0), msg.sender, initialSupply);		// Emit initial transfer to contract creator
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
76         emit Transfer(_from, _to, _value);
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
89     function transfer(address _to, uint256 _value) public returns (bool success) {
90         _transfer(msg.sender, _to, _value);
91         return true;
92     }
93 
94     /**
95      * Transfer tokens from other address
96      *
97      * Send `_value` tokens to `_to` in behalf of `_from`
98      *
99      * @param _from The address of the sender
100      * @param _to The address of the recipient
101      * @param _value the amount to send
102      */
103     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
104         require(_value <= allowance[_from][msg.sender]);     // Check allowance
105         allowance[_from][msg.sender] -= _value;
106         _transfer(_from, _to, _value);
107         return true;
108     }
109 
110     /**
111      * Set allowance for other address
112      *
113      * Allows `_spender` to spend no more than `_value` tokens in your behalf
114      *
115      * @param _spender The address authorized to spend
116      * @param _value the max amount they can spend
117      */
118     function approve(address _spender, uint256 _value) public
119         returns (bool success) {
120         allowance[msg.sender][_spender] = _value;
121         emit Approval(msg.sender, _spender, _value);
122         return true;
123     }
124 
125     /**
126      * Set allowance for other address and notify
127      *
128      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
129      *
130      * @param _spender The address authorized to spend
131      * @param _value the max amount they can spend
132      * @param _extraData some extra information to send to the approved contract
133      */
134     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
135         public
136         returns (bool success) {
137         tokenRecipient spender = tokenRecipient(_spender);
138         if (approve(_spender, _value)) {
139             spender.receiveApproval(msg.sender, _value, this, _extraData);
140             return true;
141         }
142     }
143 
144     /**
145      * Destroy tokens
146      *
147      * Remove `_value` tokens from the system irreversibly
148      *
149      * @param _value the amount of money to burn
150      */
151     function burn(uint256 _value) public returns (bool success) {
152         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
153         balanceOf[msg.sender] -= _value;            // Subtract from the sender
154         totalSupply -= _value;                      // Updates totalSupply
155         emit Burn(msg.sender, _value);
156         return true;
157     }
158 
159     /**
160      * Destroy tokens from other account
161      *
162      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
163      *
164      * @param _from the address of the sender
165      * @param _value the amount of money to burn
166      */
167     function burnFrom(address _from, uint256 _value) public returns (bool success) {
168         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
169         require(_value <= allowance[_from][msg.sender]);    // Check allowance
170         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
171         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
172         totalSupply -= _value;                              // Update totalSupply
173         emit Burn(_from, _value);
174         return true;
175     }
176 }
177 
178 /******************************************/
179 /*       ADVANCED TOKEN STARTS HERE       */
180 /******************************************/
181 
182 contract HashberryToken is owned, TokenERC20 {
183 
184     uint256 public sellPrice;
185     uint256 public buyPrice;
186 
187     mapping (address => bool) public frozenAccount;
188 
189     /* This generates a public event on the blockchain that will notify clients */
190     event FrozenFunds(address target, bool frozen);
191 
192     /* Initializes contract with initial supply tokens to the creator of the contract */
193     constructor(
194         uint256 initialSupply,
195         string tokenName,
196         string tokenSymbol
197     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
198 
199     /* Internal transfer, only can be called by this contract */
200     function _transfer(address _from, address _to, uint _value) internal {
201         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
202         require (balanceOf[_from] >= _value);               // Check if the sender has enough
203         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
204         require(!frozenAccount[_from]);                     // Check if sender is frozen
205         require(!frozenAccount[_to]);                       // Check if recipient is frozen
206         balanceOf[_from] -= _value;                         // Subtract from the sender
207         balanceOf[_to] += _value;                           // Add the same to the recipient
208         emit Transfer(_from, _to, _value);
209     }
210 
211     /// @notice Create `mintedAmount` tokens and send it to `target`
212     /// @param target Address to receive the tokens
213     /// @param mintedAmount the amount of tokens it will receive
214     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
215         balanceOf[target] += mintedAmount;
216         totalSupply += mintedAmount;
217         emit Transfer(0, this, mintedAmount);
218         emit Transfer(this, target, mintedAmount);
219     }
220 
221     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
222     /// @param target Address to be frozen
223     /// @param freeze either to freeze it or not
224     function freezeAccount(address target, bool freeze) onlyOwner public {
225         frozenAccount[target] = freeze;
226         emit FrozenFunds(target, freeze);
227     }
228 
229     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
230     /// @param newSellPrice Price the users can sell to the contract
231     /// @param newBuyPrice Price users can buy from the contract
232     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
233         sellPrice = newSellPrice;
234         buyPrice = newBuyPrice;
235     }
236 
237     /// @notice Buy tokens from contract by sending ether
238     function buy() payable public {
239         uint amount = msg.value / buyPrice;               // calculates the amount
240         _transfer(this, msg.sender, amount);              // makes the transfers
241     }
242 
243     /// @notice Sell `amount` tokens to contract
244     /// @param amount amount of tokens to be sold
245     function sell(uint256 amount) public {
246         address myAddress = this;
247         require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
248         _transfer(msg.sender, this, amount);              // makes the transfers
249         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
250     }
251 }