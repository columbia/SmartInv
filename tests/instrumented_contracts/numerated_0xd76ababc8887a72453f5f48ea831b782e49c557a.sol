1 pragma solidity ^0.4.16;
2 contract owned {
3     address public owner;
4 constructor() public {
5         owner = msg.sender;
6     }
7 modifier onlyOwner {
8         require(msg.sender == owner);
9         _;
10     }
11 function transferOwnership(address newOwner) onlyOwner public {
12         owner = newOwner;
13     }
14 }
15 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
16 contract TokenERC20 {
17     // Public variables of the token
18     string public name;
19     string public symbol;
20     uint8 public decimals = 18;
21     // 18 decimals is the strongly suggested default, avoid changing it
22     uint256 public totalSupply;
23 // This creates an array with all balances
24     mapping (address => uint256) public balanceOf;
25     mapping (address => mapping (address => uint256)) public allowance;
26 // This generates a public event on the blockchain that will notify clients
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     
29     // This generates a public event on the blockchain that will notify clients
30     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
31 // This notifies clients about the amount burnt
32     event Burn(address indexed from, uint256 value);
33 /**
34      * Constrctor function
35      *
36      * Initializes contract with initial supply tokens to the creator of the contract
37      */
38     constructor(
39         uint256 initialSupply,
40         string tokenName,
41         string tokenSymbol
42     ) public {
43         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
44         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
45         name = tokenName;                                   // Set the name for display purposes
46         symbol = tokenSymbol;                               // Set the symbol for display purposes
47     }
48 /**
49      * Internal transfer, only can be called by this contract
50      */
51     function _transfer(address _from, address _to, uint _value) internal {
52         // Prevent transfer to 0x0 address. Use burn() instead
53         require(_to != 0x0);
54         // Check if the sender has enough
55         require(balanceOf[_from] >= _value);
56         // Check for overflows
57         require(balanceOf[_to] + _value > balanceOf[_to]);
58         // Save this for an assertion in the future
59         uint previousBalances = balanceOf[_from] + balanceOf[_to];
60         // Subtract from the sender
61         balanceOf[_from] -= _value;
62         // Add the same to the recipient
63         balanceOf[_to] += _value;
64         emit Transfer(_from, _to, _value);
65         // Asserts are used to use static analysis to find bugs in your code. They should never fail
66         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
67     }
68 /**
69      * Transfer tokens
70      *
71      * Send `_value` tokens to `_to` from your account
72      *
73      * @param _to The address of the recipient
74      * @param _value the amount to send
75      */
76     function transfer(address _to, uint256 _value) public returns (bool success) {
77         _transfer(msg.sender, _to, _value);
78         return true;
79     }
80 /**
81      * Transfer tokens from other address
82      *
83      * Send `_value` tokens to `_to` in behalf of `_from`
84      *
85      * @param _from The address of the sender
86      * @param _to The address of the recipient
87      * @param _value the amount to send
88      */
89     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
90         require(_value <= allowance[_from][msg.sender]);     // Check allowance
91         allowance[_from][msg.sender] -= _value;
92         _transfer(_from, _to, _value);
93         return true;
94     }
95 /**
96      * Set allowance for other address
97      *
98      * Allows `_spender` to spend no more than `_value` tokens in your behalf
99      *
100      * @param _spender The address authorized to spend
101      * @param _value the max amount they can spend
102      */
103     function approve(address _spender, uint256 _value) public
104         returns (bool success) {
105         allowance[msg.sender][_spender] = _value;
106         emit Approval(msg.sender, _spender, _value);
107         return true;
108     }
109 /**
110      * Set allowance for other address and notify
111      *
112      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
113      *
114      * @param _spender The address authorized to spend
115      * @param _value the max amount they can spend
116      * @param _extraData some extra information to send to the approved contract
117      */
118     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
119         public
120         returns (bool success) {
121         tokenRecipient spender = tokenRecipient(_spender);
122         if (approve(_spender, _value)) {
123             spender.receiveApproval(msg.sender, _value, this, _extraData);
124             return true;
125         }
126     }
127 /**
128      * Destroy tokens
129      *
130      * Remove `_value` tokens from the system irreversibly
131      *
132      * @param _value the amount of money to burn
133      */
134     function burn(uint256 _value) public returns (bool success) {
135         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
136         balanceOf[msg.sender] -= _value;            // Subtract from the sender
137         totalSupply -= _value;                      // Updates totalSupply
138         emit Burn(msg.sender, _value);
139         return true;
140     }
141 /**
142      * Destroy tokens from other account
143      *
144      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
145      *
146      * @param _from the address of the sender
147      * @param _value the amount of money to burn
148      */
149     function burnFrom(address _from, uint256 _value) public returns (bool success) {
150         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
151         require(_value <= allowance[_from][msg.sender]);    // Check allowance
152         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
153         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
154         totalSupply -= _value;                              // Update totalSupply
155         emit Burn(_from, _value);
156         return true;
157     }
158 }
159 /******************************************/
160 /*       Change the name of the contract from Kahawanu to your own    token name
161 */
162 /******************************************/
163 contract PizzaCoin is owned, TokenERC20 {
164 uint256 public sellPrice;
165     uint256 public buyPrice;
166 mapping (address => bool) public frozenAccount;
167 /* This generates a public event on the blockchain that will notify clients */
168     event FrozenFunds(address target, bool frozen);
169 /* Initializes contract with initial supply tokens to the creator of the contract */
170     constructor(
171         uint256 initialSupply,
172         string tokenName,
173         string tokenSymbol
174     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
175 /* Internal transfer, only can be called by this contract */
176     function _transfer(address _from, address _to, uint _value) internal {
177         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
178         require (balanceOf[_from] >= _value);               // Check if the sender has enough
179         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
180         require(!frozenAccount[_from]);                     // Check if sender is frozen
181         require(!frozenAccount[_to]);                       // Check if recipient is frozen
182         balanceOf[_from] -= _value;                         // Subtract from the sender
183         balanceOf[_to] += _value;                           // Add the same to the recipient
184         emit Transfer(_from, _to, _value);
185     }
186 /// @notice Create `mintedAmount` tokens and send it to `target`
187     /// @param target Address to receive the tokens
188     /// @param mintedAmount the amount of tokens it will receive
189     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
190         balanceOf[target] += mintedAmount;
191         totalSupply += mintedAmount;
192         emit Transfer(0, this, mintedAmount);
193         emit Transfer(this, target, mintedAmount);
194     }
195 /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
196     /// @param target Address to be frozen
197     /// @param freeze either to freeze it or not
198     function freezeAccount(address target, bool freeze) onlyOwner public {
199         frozenAccount[target] = freeze;
200         emit FrozenFunds(target, freeze);
201     }
202 /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
203     /// @param newSellPrice Price the users can sell to the contract
204     /// @param newBuyPrice Price users can buy from the contract
205     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
206         sellPrice = newSellPrice;
207         buyPrice = newBuyPrice;
208     }
209 /// @notice Buy tokens from contract by sending ether
210     function buy() payable public {
211         uint amount = msg.value / buyPrice;               // calculates the amount
212         _transfer(this, msg.sender, amount);              // makes the transfers
213     }
214 /// @notice Sell `amount` tokens to contract
215     /// @param amount amount of tokens to be sold
216     function sell(uint256 amount) public {
217         address myAddress = this;
218         require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
219         _transfer(msg.sender, this, amount);              // makes the transfers
220         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
221     }
222 }