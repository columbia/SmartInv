1 pragma solidity ^0.4.11;
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
21 contract token { 
22     string public name; string public symbol; uint8 public decimals; uint256 public totalSupply;
23 
24   /* This creates an array with all balances */
25   mapping (address => uint256) public balanceOf;
26   mapping (address => mapping (address => uint256)) public allowance;
27 
28   /* This generates a public event on the blockchain that will notify clients */
29   event Transfer(address indexed from, address indexed to, uint256 value);
30 
31   /* This notifies clients about the amount burnt */
32   event Burn(address indexed from, uint256 value);
33 
34   /* Initializes contract with initial supply tokens to the creator of the contract */
35   function token(
36       uint256 initialSupply,
37       string tokenName,
38       uint8 decimalUnits,
39       string tokenSymbol
40       ) {
41       balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
42       totalSupply = initialSupply;                        // Update total supply
43       name = tokenName;                                   // Set the name for display purposes
44       symbol = tokenSymbol;                               // Set the symbol for display purposes
45       decimals = decimalUnits;                            // Amount of decimals for display purposes
46   }
47 
48   /* Internal transfer, only can be called by this contract */
49   function _transfer(address _from, address _to, uint _value) internal {
50       require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
51       require (balanceOf[_from] > _value);                // Check if the sender has enough
52       require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
53       balanceOf[_from] -= _value;                         // Subtract from the sender
54       balanceOf[_to] += _value;                            // Add the same to the recipient
55       Transfer(_from, _to, _value);
56   }
57 
58   /// @notice Send `_value` tokens to `_to` from your account
59   /// @param _to The address of the recipient
60   /// @param _value the amount to send
61   function transfer(address _to, uint256 _value) {
62       _transfer(msg.sender, _to, _value);
63   }
64 
65   /// @notice Send `_value` tokens to `_to` in behalf of `_from`
66   /// @param _from The address of the sender
67   /// @param _to The address of the recipient
68   /// @param _value the amount to send
69   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
70       require (_value < allowance[_from][msg.sender]);     // Check allowance
71       allowance[_from][msg.sender] -= _value;
72       _transfer(_from, _to, _value);
73       return true;
74   }
75 
76   /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
77   /// @param _spender The address authorized to spend
78   /// @param _value the max amount they can spend
79   function approve(address _spender, uint256 _value)
80       returns (bool success) {
81       allowance[msg.sender][_spender] = _value;
82       return true;
83   }
84 
85   /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
86   /// @param _spender The address authorized to spend
87   /// @param _value the max amount they can spend
88   /// @param _extraData some extra information to send to the approved contract
89   function approveAndCall(address _spender, uint256 _value, bytes _extraData)
90       returns (bool success) {
91       tokenRecipient spender = tokenRecipient(_spender);
92       if (approve(_spender, _value)) {
93           spender.receiveApproval(msg.sender, _value, this, _extraData);
94           return true;
95       }
96   }        
97 
98   /// @notice Remove `_value` tokens from the system irreversibly
99   /// @param _value the amount of money to burn
100   function burn(uint256 _value) returns (bool success) {
101       require (balanceOf[msg.sender] > _value);            // Check if the sender has enough
102       balanceOf[msg.sender] -= _value;                      // Subtract from the sender
103       totalSupply -= _value;                                // Updates totalSupply
104       Burn(msg.sender, _value);
105       return true;
106   }
107 
108   function burnFrom(address _from, uint256 _value) returns (bool success) {
109       require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
110       require(_value <= allowance[_from][msg.sender]);    // Check allowance
111       balanceOf[_from] -= _value;                         // Subtract from the targeted balance
112       allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
113       totalSupply -= _value;                              // Update totalSupply
114       Burn(_from, _value);
115       return true;
116   }
117 }
118 
119 contract NetkingToken is owned, token {
120 
121   uint256 public sellPrice;
122   uint256 public buyPrice;
123 
124   mapping (address => bool) public frozenAccount;
125 
126   /* This generates a public event on the blockchain that will notify clients */
127   event FrozenFunds(address target, bool frozen);
128 
129   /* Initializes contract with initial supply tokens to the creator of the contract */
130   function NetkingToken(
131       uint256 initialSupply,
132       string tokenName,
133       uint8 decimalUnits,
134       string tokenSymbol
135   ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
136 
137   /* Internal transfer, only can be called by this contract */
138   function _transfer(address _from, address _to, uint _value) internal {
139       require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
140       require (balanceOf[_from] > _value);                // Check if the sender has enough
141       require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
142       require(!frozenAccount[_from]);                     // Check if sender is frozen
143       require(!frozenAccount[_to]);                       // Check if recipient is frozen
144       balanceOf[_from] -= _value;                         // Subtract from the sender
145       balanceOf[_to] += _value;                           // Add the same to the recipient
146       Transfer(_from, _to, _value);
147   }
148 
149   /// @notice Create `mintedAmount` tokens and send it to `target`
150   /// @param target Address to receive the tokens
151   /// @param mintedAmount the amount of tokens it will receive
152   function mintToken(address target, uint256 mintedAmount) onlyOwner {
153       balanceOf[target] += mintedAmount;
154       totalSupply += mintedAmount;
155       Transfer(0, this, mintedAmount);
156       Transfer(this, target, mintedAmount);
157   }
158 
159   /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
160   /// @param target Address to be frozen
161   /// @param freeze either to freeze it or not
162   function freezeAccount(address target, bool freeze) onlyOwner {
163       frozenAccount[target] = freeze;
164       FrozenFunds(target, freeze);
165   }
166 
167   /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
168   /// @param newSellPrice Price the users can sell to the contract
169   /// @param newBuyPrice Price users can buy from the contract
170   function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
171       sellPrice = newSellPrice;
172       buyPrice = newBuyPrice;
173   }
174 
175   /// @notice Buy tokens from contract by sending ether
176   function buy() payable {
177       uint amount = msg.value / buyPrice;               // calculates the amount
178       _transfer(this, msg.sender, amount);              // makes the transfers
179   }
180 
181   /// @notice Sell `amount` tokens to contract
182   /// @param amount amount of tokens to be sold
183   function sell(uint256 amount) {
184       require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
185       _transfer(msg.sender, this, amount);              // makes the transfers
186       msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
187   }
188 }