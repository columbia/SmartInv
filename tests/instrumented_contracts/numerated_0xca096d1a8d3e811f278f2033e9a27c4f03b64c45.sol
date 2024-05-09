1 pragma solidity ^0.4.13; contract owned { address public owner;
2 
3   function owned() {
4       owner = msg.sender;
5   }
6 
7   modifier onlyOwner {
8       require(msg.sender == owner);
9       _;
10   }
11 
12   function transferOwnership(address newOwner) onlyOwner {
13       owner = newOwner;
14   }
15 
16 }
17 
18 contract tokenRecipient { function receiveApproval(address from, uint256 value, address token, bytes extraData); }
19 
20 contract token { /* Public variables of the token */ string public name; string public symbol; uint8 public decimals; uint256 public totalSupply;
21 
22 /* This creates an array with all balances */
23   mapping (address => uint256) public balanceOf;
24   mapping (address => mapping (address => uint256)) public allowance;
25 
26   /* This generates a public event on the blockchain that will notify clients */
27   event Transfer(address indexed from, address indexed to, uint256 value);
28 
29   /* This notifies clients about the amount burnt */
30   event Burn(address indexed from, uint256 value);
31 
32   /* Initializes contract with initial supply tokens to the creator of the contract */
33   function token(
34       uint256 initialSupply,
35       string tokenName,
36       uint8 decimalUnits,
37       string tokenSymbol
38       ) {
39       balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
40       totalSupply = initialSupply;                        // Update total supply
41       name = tokenName;                                   // Set the name for display purposes
42       symbol = tokenSymbol;                               // Set the symbol for display purposes
43       decimals = decimalUnits;                            // Amount of decimals for display purposes
44   }
45 
46   /* Internal transfer, only can be called by this contract */
47   function _transfer(address _from, address _to, uint _value) internal {
48       require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
49       require (balanceOf[_from] > _value);                // Check if the sender has enough
50       require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
51       balanceOf[_from] -= _value;                         // Subtract from the sender
52       balanceOf[_to] += _value;                            // Add the same to the recipient
53       Transfer(_from, _to, _value);
54   }
55 
56   /// @notice Send `_value` tokens to `_to` from your account
57   /// @param _to The address of the recipient
58   /// @param _value the amount to send
59   function transfer(address _to, uint256 _value) {
60       _transfer(msg.sender, _to, _value);
61   }
62 
63   /// @notice Send `_value` tokens to `_to` in behalf of `_from`
64   /// @param _from The address of the sender
65   /// @param _to The address of the recipient
66   /// @param _value the amount to send
67   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
68       require (_value < allowance[_from][msg.sender]);     // Check allowance
69       allowance[_from][msg.sender] -= _value;
70       _transfer(_from, _to, _value);
71       return true;
72   }
73 
74   /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
75   /// @param _spender The address authorized to spend
76   /// @param _value the max amount they can spend
77   function approve(address _spender, uint256 _value)
78       returns (bool success) {
79       allowance[msg.sender][_spender] = _value;
80       return true;
81   }
82 
83   /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
84   /// @param _spender The address authorized to spend
85   /// @param _value the max amount they can spend
86   /// @param _extraData some extra information to send to the approved contract
87   function approveAndCall(address _spender, uint256 _value, bytes _extraData)
88       returns (bool success) {
89       tokenRecipient spender = tokenRecipient(_spender);
90       if (approve(_spender, _value)) {
91           spender.receiveApproval(msg.sender, _value, this, _extraData);
92           return true;
93       }
94   }        
95 
96   /// @notice Remove `_value` tokens from the system irreversibly
97   /// @param _value the amount of money to burn
98   function burn(uint256 _value) returns (bool success) {
99       require (balanceOf[msg.sender] > _value);            // Check if the sender has enough
100       balanceOf[msg.sender] -= _value;                      // Subtract from the sender
101       totalSupply -= _value;                                // Updates totalSupply
102       Burn(msg.sender, _value);
103       return true;
104   }
105 
106   function burnFrom(address _from, uint256 _value) returns (bool success) {
107       require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
108       require(_value <= allowance[_from][msg.sender]);    // Check allowance
109       balanceOf[_from] -= _value;                         // Subtract from the targeted balance
110       allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
111       totalSupply -= _value;                              // Update totalSupply
112       Burn(_from, _value);
113       return true;
114   }
115 
116 }
117 
118 contract MyAdvancedToken is owned, token {
119 
120   uint256 public sellPrice;
121   uint256 public buyPrice;
122 
123   mapping (address => bool) public frozenAccount;
124 
125   /* This generates a public event on the blockchain that will notify clients */
126   event FrozenFunds(address target, bool frozen);
127 
128   /* Initializes contract with initial supply tokens to the creator of the contract */
129   function MyAdvancedToken(
130       uint256 initialSupply,
131       string tokenName,
132       uint8 decimalUnits,
133       string tokenSymbol
134   ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
135 
136   /* Internal transfer, only can be called by this contract */
137   function _transfer(address _from, address _to, uint _value) internal {
138       require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
139       require (balanceOf[_from] > _value);                // Check if the sender has enough
140       require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
141       require(!frozenAccount[_from]);                     // Check if sender is frozen
142       require(!frozenAccount[_to]);                       // Check if recipient is frozen
143       balanceOf[_from] -= _value;                         // Subtract from the sender
144       balanceOf[_to] += _value;                           // Add the same to the recipient
145       Transfer(_from, _to, _value);
146   }
147 
148   /// @notice Create `mintedAmount` tokens and send it to `target`
149   /// @param target Address to receive the tokens
150   /// @param mintedAmount the amount of tokens it will receive
151   function mintToken(address target, uint256 mintedAmount) onlyOwner {
152       balanceOf[target] += mintedAmount;
153       totalSupply += mintedAmount;
154       Transfer(0, this, mintedAmount);
155       Transfer(this, target, mintedAmount);
156   }
157 
158   /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
159   /// @param target Address to be frozen
160   /// @param freeze either to freeze it or not
161   function freezeAccount(address target, bool freeze) onlyOwner {
162       frozenAccount[target] = freeze;
163       FrozenFunds(target, freeze);
164   }
165 
166   /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
167   /// @param newSellPrice Price the users can sell to the contract
168   /// @param newBuyPrice Price users can buy from the contract
169   function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
170       sellPrice = newSellPrice;
171       buyPrice = newBuyPrice;
172   }
173 
174   /// @notice Buy tokens from contract by sending ether
175   function buy() payable {
176       uint amount = msg.value / buyPrice;               // calculates the amount
177       _transfer(this, msg.sender, amount);              // makes the transfers
178   }
179 
180   /// @notice Sell `amount` tokens to contract
181   /// @param amount amount of tokens to be sold
182   function sell(uint256 amount) {
183       require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
184       _transfer(msg.sender, this, amount);              // makes the transfers
185       msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
186   }
187 
188 }