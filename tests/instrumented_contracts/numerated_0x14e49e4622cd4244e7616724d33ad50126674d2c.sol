1 pragma solidity ^0.4.13; 
2 
3 contract owned { address public owner;
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
17 }
18 
19 contract tokenRecipient { function receiveApproval(address from, uint256 value, address token, bytes extraData); }
20 
21 contract token { /* Public variables of the token */ string public name; string public symbol; uint8 public decimals; uint256 public totalSupply;
22 
23   /* This creates an array with all balances */
24   mapping (address => uint256) public balanceOf;
25   mapping (address => mapping (address => uint256)) public allowance;
26 
27   /* This generates a public event on the blockchain that will notify clients */
28   event Transfer(address indexed from, address indexed to, uint256 value);
29 
30   /* This notifies clients about the amount burnt */
31   event Burn(address indexed from, uint256 value);
32 
33   /* Initializes contract with initial supply tokens to the creator of the contract */
34   function token(
35       uint256 initialSupply,
36       string tokenName,
37       uint8 decimalUnits,
38       string tokenSymbol
39       ) {
40       balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
41       totalSupply = initialSupply;                        // Update total supply
42       name = tokenName;                                   // Set the name for display purposes
43       symbol = tokenSymbol;                               // Set the symbol for display purposes
44       decimals = decimalUnits;                            // Amount of decimals for display purposes
45   }
46 
47   /* Internal transfer, only can be called by this contract */
48   function _transfer(address _from, address _to, uint _value) internal {
49       require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
50       require (balanceOf[_from] > _value);                // Check if the sender has enough
51       require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
52       balanceOf[_from] -= _value;                         // Subtract from the sender
53       balanceOf[_to] += _value;                            // Add the same to the recipient
54       Transfer(_from, _to, _value);
55   }
56 
57   /// @notice Send `_value` tokens to `_to` from your account
58   /// @param _to The address of the recipient
59   /// @param _value the amount to send
60   function transfer(address _to, uint256 _value) {
61       _transfer(msg.sender, _to, _value);
62   }
63 
64   /// @notice Send `_value` tokens to `_to` in behalf of `_from`
65   /// @param _from The address of the sender
66   /// @param _to The address of the recipient
67   /// @param _value the amount to send
68   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
69       require (_value < allowance[_from][msg.sender]);     // Check allowance
70       allowance[_from][msg.sender] -= _value;
71       _transfer(_from, _to, _value);
72       return true;
73   }
74 
75   /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
76   /// @param _spender The address authorized to spend
77   /// @param _value the max amount they can spend
78   function approve(address _spender, uint256 _value)
79       returns (bool success) {
80       allowance[msg.sender][_spender] = _value;
81       return true;
82   }
83 
84   /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
85   /// @param _spender The address authorized to spend
86   /// @param _value the max amount they can spend
87   /// @param _extraData some extra information to send to the approved contract
88   function approveAndCall(address _spender, uint256 _value, bytes _extraData)
89       returns (bool success) {
90       tokenRecipient spender = tokenRecipient(_spender);
91       if (approve(_spender, _value)) {
92           spender.receiveApproval(msg.sender, _value, this, _extraData);
93           return true;
94       }
95   }        
96 
97   /// @notice Remove `_value` tokens from the system irreversibly
98   /// @param _value the amount of money to burn
99   function burn(uint256 _value) returns (bool success) {
100       require (balanceOf[msg.sender] > _value);            // Check if the sender has enough
101       balanceOf[msg.sender] -= _value;                      // Subtract from the sender
102       totalSupply -= _value;                                // Updates totalSupply
103       Burn(msg.sender, _value);
104       return true;
105   }
106 
107   function burnFrom(address _from, uint256 _value) returns (bool success) {
108       require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
109       require(_value <= allowance[_from][msg.sender]);    // Check allowance
110       balanceOf[_from] -= _value;                         // Subtract from the targeted balance
111       allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
112       totalSupply -= _value;                              // Update totalSupply
113       Burn(_from, _value);
114       return true;
115   }
116 }
117 
118 contract GoramCoin is owned, token {
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
129   function GoramCoin(
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
180   /// @notice Gets current buy price without ether
181   function getBuy() returns (uint256){
182       return buyPrice;          // returns the buying price
183   }
184   
185   /// @notice Get current sell price without ether
186   function getSell() returns (uint256){
187       return sellPrice;          // returns the buying price
188   }
189 
190   /// @notice Sell `amount` tokens to contract
191   /// @param amount amount of tokens to be sold
192   function sell(uint256 amount) {
193       require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
194       _transfer(msg.sender, this, amount);              // makes the transfers
195       msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
196   }
197 }