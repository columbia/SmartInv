1 pragma solidity ^0.4.13; 
2 contract owned { 
3   address public owner;
4 
5   function owned() {
6       owner = msg.sender;
7   }
8 
9   modifier onlyOwner {
10       require(msg.sender == owner);
11       _;
12   }
13 
14   function transferOwnership(address newOwner) onlyOwner {
15       owner = newOwner;
16   }
17 
18 }
19 
20 contract tokenRecipient { function receiveApproval(address from, uint256 value, address token, bytes extraData); }
21 
22 contract token { 
23     // Public variables of the token / 
24     string public name = 'Application'; 
25     string public symbol;
26     uint8 public decimals; 
27     uint256 public totalSupply;
28 
29   /* This creates an array with all balances */
30   mapping (address => uint256) public balanceOf;
31   mapping (address => mapping (address => uint256)) public allowance;
32 
33   /* This generates a public event on the blockchain that will notify clients */
34   event Transfer(address indexed from, address indexed to, uint256 value);
35 
36   /* This notifies clients about the amount burnt */
37   event Burn(address indexed from, uint256 value);
38 
39   /* Initializes contract with initial supply tokens to the creator of the contract */
40   function token(
41       uint256 initialSupply,
42       string tokenName,
43       uint8 decimalUnits,
44       string tokenSymbol
45       ) {
46       balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
47       totalSupply = initialSupply;                        // Update total supply
48       name = tokenName;                                   // Set the name for display purposes
49       symbol = tokenSymbol;                               // Set the symbol for display purposes
50       decimals = decimalUnits;                            // Amount of decimals for display purposes
51   }
52 
53   /* Internal transfer, only can be called by this contract */
54   function _transfer(address _from, address _to, uint _value) internal {
55       require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
56       require (balanceOf[_from] > _value);                // Check if the sender has enough
57       require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
58       balanceOf[_from] -= _value;                         // Subtract from the sender
59       balanceOf[_to] += _value;                            // Add the same to the recipient
60       Transfer(_from, _to, _value);
61   }
62 
63   /// @notice Send `_value` tokens to `_to` from your account
64   /// @param _to The address of the recipient
65   /// @param _value the amount to send
66   function transfer(address _to, uint256 _value) {
67       _transfer(msg.sender, _to, _value);
68   }
69 
70   /// @notice Send `_value` tokens to `_to` in behalf of `_from`
71   /// @param _from The address of the sender
72   /// @param _to The address of the recipient
73   /// @param _value the amount to send
74   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
75       require (_value < allowance[_from][msg.sender]);     // Check allowance
76       allowance[_from][msg.sender] -= _value;
77       _transfer(_from, _to, _value);
78       return true;
79   }
80 
81   /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
82   /// @param _spender The address authorized to spend
83   /// @param _value the max amount they can spend
84   function approve(address _spender, uint256 _value)
85       returns (bool success) {
86       allowance[msg.sender][_spender] = _value;
87       return true;
88   }
89 
90   /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
91   /// @param _spender The address authorized to spend
92   /// @param _value the max amount they can spend
93   /// @param _extraData some extra information to send to the approved contract
94   function approveAndCall(address _spender, uint256 _value, bytes _extraData)
95       returns (bool success) {
96       tokenRecipient spender = tokenRecipient(_spender);
97       if (approve(_spender, _value)) {
98           spender.receiveApproval(msg.sender, _value, this, _extraData);
99           return true;
100       }
101   }        
102 
103   /// @notice Remove `_value` tokens from the system irreversibly
104   /// @param _value the amount of money to burn
105   function burn(uint256 _value) returns (bool success) {
106       require (balanceOf[msg.sender] > _value);            // Check if the sender has enough
107       balanceOf[msg.sender] -= _value;                      // Subtract from the sender
108       totalSupply -= _value;                                // Updates totalSupply
109       Burn(msg.sender, _value);
110       return true;
111   }
112 
113   function burnFrom(address _from, uint256 _value) returns (bool success) {
114       require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
115       require(_value <= allowance[_from][msg.sender]);    // Check allowance
116       balanceOf[_from] -= _value;                         // Subtract from the targeted balance
117       allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
118       totalSupply -= _value;                              // Update totalSupply
119       Burn(_from, _value);
120       return true;
121   }
122 
123 }
124 
125 contract APP is owned, token {
126 
127   uint256 public sellPrice;
128   uint256 public buyPrice;
129 
130   mapping (address => bool) public frozenAccount;
131 
132   /* This generates a public event on the blockchain that will notify clients */
133   event FrozenFunds(address target, bool frozen);
134 
135   /* Initializes contract with initial supply tokens to the creator of the contract */
136   function APP(
137       uint256 initialSupply,
138       string tokenName,
139       uint8 decimalUnits,
140       string tokenSymbol
141   ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
142 
143   /* Internal transfer, only can be called by this contract */
144   function _transfer(address _from, address _to, uint _value) internal {
145       require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
146       require (balanceOf[_from] > _value);                // Check if the sender has enough
147       require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
148       require(!frozenAccount[_from]);                     // Check if sender is frozen
149       require(!frozenAccount[_to]);                       // Check if recipient is frozen
150       balanceOf[_from] -= _value;                         // Subtract from the sender
151       balanceOf[_to] += _value;                           // Add the same to the recipient
152       Transfer(_from, _to, _value);
153   }
154 
155   /// @notice Create `mintedAmount` tokens and send it to `target`
156   /// @param target Address to receive the tokens
157   /// @param mintedAmount the amount of tokens it will receive
158   function mintToken(address target, uint256 mintedAmount) onlyOwner {
159       balanceOf[target] += mintedAmount;
160       totalSupply += mintedAmount;
161       Transfer(0, this, mintedAmount);
162       Transfer(this, target, mintedAmount);
163   }
164 
165   /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
166   /// @param target Address to be frozen
167   /// @param freeze either to freeze it or not
168   function freezeAccount(address target, bool freeze) onlyOwner {
169       frozenAccount[target] = freeze;
170       FrozenFunds(target, freeze);
171   }
172 
173   /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
174   /// @param newSellPrice Price the users can sell to the contract
175   /// @param newBuyPrice Price users can buy from the contract
176   function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
177       sellPrice = newSellPrice;
178       buyPrice = newBuyPrice;
179   }
180 
181   /// @notice Buy tokens from contract by sending ether
182   function buy() payable {
183       uint amount = msg.value / buyPrice;               // calculates the amount
184       _transfer(this, msg.sender, amount);              // makes the transfers
185   }
186 
187   /// @notice Sell `amount` tokens to contract
188   /// @param amount amount of tokens to be sold
189   function sell(uint256 amount) {
190       require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
191       _transfer(msg.sender, this, amount);              // makes the transfers
192       msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
193   }
194 
195 }