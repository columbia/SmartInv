1 pragma solidity ^0.4.13; 
2 contract owned { 
3   address public owner;
4   function owned() {
5       owner = msg.sender;
6   }
7 
8   modifier onlyOwner {
9       require(msg.sender == owner);
10       _;
11   }
12 
13   function transferOwnership(address newOwner) onlyOwner {
14       owner = newOwner;
15   }
16 }
17 contract tokenRecipient { function receiveApproval(address from, uint256 value, address token, bytes extraData); }
18 contract token { 
19 /*Public variables of the token */ 
20 string public name; string public symbol; uint8 public decimals; uint256 public totalSupply;
21   /* This creates an array with all balances */
22   mapping (address => uint256) public balanceOf;
23   mapping (address => mapping (address => uint256)) public allowance;
24 
25   /* This generates a public event on the blockchain that will notify clients */
26   event Transfer(address indexed from, address indexed to, uint256 value);
27 
28   /* This notifies clients about the amount burnt */
29   event Burn(address indexed from, uint256 value);
30 
31   /* Initializes contract with initial supply tokens to the creator of the contract */
32   function token(
33       uint256 initialSupply,
34       string tokenName,
35       uint8 decimalUnits,
36       string tokenSymbol
37       ) {
38       balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
39       totalSupply = initialSupply;                        // Update total supply
40       name = tokenName;                                   // Set the name for display purposes
41       symbol = tokenSymbol;                               // Set the symbol for display purposes
42       decimals = decimalUnits;                            // Amount of decimals for display purposes
43   }
44 
45   /* Internal transfer, only can be called by this contract */
46   function _transfer(address _from, address _to, uint _value) internal {
47       require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
48       require (balanceOf[_from] > _value);                // Check if the sender has enough
49       require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
50       balanceOf[_from] -= _value;                         // Subtract from the sender
51       balanceOf[_to] += _value;                            // Add the same to the recipient
52       Transfer(_from, _to, _value);
53   }
54 
55   /// @notice Send `_value` tokens to `_to` from your account
56   /// @param _to The address of the recipient
57   /// @param _value the amount to send
58   function transfer(address _to, uint256 _value) {
59       _transfer(msg.sender, _to, _value);
60   }
61 
62   /// @notice Send `_value` tokens to `_to` in behalf of `_from`
63   /// @param _from The address of the sender
64   /// @param _to The address of the recipient
65   /// @param _value the amount to send
66   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
67       require (_value < allowance[_from][msg.sender]);     // Check allowance
68       allowance[_from][msg.sender] -= _value;
69       _transfer(_from, _to, _value);
70       return true;
71   }
72 
73   /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
74   /// @param _spender The address authorized to spend
75   /// @param _value the max amount they can spend
76   function approve(address _spender, uint256 _value)
77       returns (bool success) {
78       allowance[msg.sender][_spender] = _value;
79       return true;
80   }
81 
82   /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
83   /// @param _spender The address authorized to spend
84   /// @param _value the max amount they can spend
85   /// @param _extraData some extra information to send to the approved contract
86   function approveAndCall(address _spender, uint256 _value, bytes _extraData)
87       returns (bool success) {
88       tokenRecipient spender = tokenRecipient(_spender);
89       if (approve(_spender, _value)) {
90           spender.receiveApproval(msg.sender, _value, this, _extraData);
91           return true;
92       }
93   }        
94 
95   /// @notice Remove `_value` tokens from the system irreversibly
96   /// @param _value the amount of money to burn
97   function burn(uint256 _value) returns (bool success) {
98       require (balanceOf[msg.sender] > _value);            // Check if the sender has enough
99       balanceOf[msg.sender] -= _value;                      // Subtract from the sender
100       totalSupply -= _value;                                // Updates totalSupply
101       Burn(msg.sender, _value);
102       return true;
103   }
104 
105   function burnFrom(address _from, uint256 _value) returns (bool success) {
106       require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
107       require(_value <= allowance[_from][msg.sender]);    // Check allowance
108       balanceOf[_from] -= _value;                         // Subtract from the targeted balance
109       allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
110       totalSupply -= _value;                              // Update totalSupply
111       Burn(_from, _value);
112       return true;
113   }
114 }
115 contract INTToken is owned, token {
116   uint256 public sellPrice;
117   uint256 public buyPrice;
118 
119   mapping (address => bool) public frozenAccount;
120 
121   /* This generates a public event on the blockchain that will notify clients */
122   event FrozenFunds(address target, bool frozen);
123 
124   /* Initializes contract with initial supply tokens to the creator of the contract */
125   function INTToken(
126       uint256 initialSupply,
127       string tokenName,
128       uint8 decimalUnits,
129       string tokenSymbol
130   ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
131 
132   /* Internal transfer, only can be called by this contract */
133   function _transfer(address _from, address _to, uint _value) internal {
134       require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
135       require (balanceOf[_from] > _value);                // Check if the sender has enough
136       require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
137       require(!frozenAccount[_from]);                     // Check if sender is frozen
138       require(!frozenAccount[_to]);                       // Check if recipient is frozen
139       balanceOf[_from] -= _value;                         // Subtract from the sender
140       balanceOf[_to] += _value;                           // Add the same to the recipient
141       Transfer(_from, _to, _value);
142   }
143 
144   /// @notice Create `mintedAmount` tokens and send it to `target`
145   /// @param target Address to receive the tokens
146   /// @param mintedAmount the amount of tokens it will receive
147   function mintToken(address target, uint256 mintedAmount) onlyOwner {
148       balanceOf[target] += mintedAmount;
149       totalSupply += mintedAmount;
150       Transfer(0, this, mintedAmount);
151       Transfer(this, target, mintedAmount);
152   }
153 
154   /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
155   /// @param target Address to be frozen
156   /// @param freeze either to freeze it or not
157   function freezeAccount(address target, bool freeze) onlyOwner {
158       frozenAccount[target] = freeze;
159       FrozenFunds(target, freeze);
160   }
161 
162   /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
163   /// @param newSellPrice Price the users can sell to the contract
164   /// @param newBuyPrice Price users can buy from the contract
165   function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
166       sellPrice = newSellPrice;
167       buyPrice = newBuyPrice;
168   }
169 
170   /// @notice Buy tokens from contract by sending ether
171   function buy() payable {
172       uint amount = msg.value / buyPrice;               // calculates the amount
173       _transfer(this, msg.sender, amount);              // makes the transfers
174   }
175 
176   /// @notice Sell `amount` tokens to contract
177   /// @param amount amount of tokens to be sold
178   function sell(uint256 amount) {
179       require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
180       _transfer(msg.sender, this, amount);              // makes the transfers
181       msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
182   }
183 }
184 contract INT is INTToken(1000000000000000, "my test 09token", 6, "TEST09") {}