1 pragma solidity ^0.4.13; 
2 contract owned { address public owner;
3   function owned() {
4       owner = msg.sender;
5   }
6   modifier onlyOwner {
7       require(msg.sender == owner);
8       _;
9   }
10   function transferOwnership(address newOwner) onlyOwner {
11       owner = newOwner;
12   }
13 }
14 
15 contract tokenRecipient { function receiveApproval(address from, uint256 value, address token, bytes extraData); }
16 
17 contract token is owned { 
18 /*Public variables of the token */ 
19 string public name; 
20 string public symbol; 
21 uint8 public decimals; 
22 uint256 public totalSupply;
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
54       balanceOf[_to] += _value;                           // Add the same to the recipient
55       Transfer(_from, _to, _value);
56   }
57 
58   function _transferWithFee(address _from, address _to, uint _value, uint _fee) internal {
59       require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
60       require (balanceOf[_from] > _value + _fee);                // Check if the sender has enough
61       require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
62       balanceOf[_from] -= _value + _fee;                         // Subtract from the sender value + fee
63       balanceOf[_to] += _value;                            // Add the same to the recipient
64       balanceOf[msg.sender] += _fee;
65       Transfer(_from, _to, _value);
66   }
67   function transferFromWithFee(address _from, address _to, uint256 _value, uint256 _fee) onlyOwner returns (bool success) {
68       _transferWithFee(_from, _to, _value, _fee);
69       return true;
70   }
71 
72   /// @notice Send `_value` tokens to `_to` from your account
73   /// @param _to The address of the recipient
74   /// @param _value the amount to send
75   function transfer(address _to, uint256 _value) {
76       _transfer(msg.sender, _to, _value);
77   }
78 
79   /// @notice Send `_value` tokens to `_to` in behalf of `_from`
80   /// @param _from The address of the sender
81   /// @param _to The address of the recipient
82   /// @param _value the amount to send
83   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
84       require (_value < allowance[_from][msg.sender]);     // Check allowance
85       allowance[_from][msg.sender] -= _value;
86       _transfer(_from, _to, _value);
87       return true;
88   }
89 
90   /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
91   /// @param _spender The address authorized to spend
92   /// @param _value the max amount they can spend
93   function approve(address _spender, uint256 _value)
94       returns (bool success) {
95       allowance[msg.sender][_spender] = _value;
96       return true;
97   }
98 
99   /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
100   /// @param _spender The address authorized to spend
101   /// @param _value the max amount they can spend
102   /// @param _extraData some extra information to send to the approved contract
103   function approveAndCall(address _spender, uint256 _value, bytes _extraData)
104       returns (bool success) {
105       tokenRecipient spender = tokenRecipient(_spender);
106       if (approve(_spender, _value)) {
107           spender.receiveApproval(msg.sender, _value, this, _extraData);
108           return true;
109       }
110   }        
111 
112   /// @notice Remove `_value` tokens from the system irreversibly
113   /// @param _value the amount of money to burn
114   function burn(uint256 _value) returns (bool success) {
115       require (balanceOf[msg.sender] > _value);            // Check if the sender has enough
116       balanceOf[msg.sender] -= _value;                      // Subtract from the sender
117       totalSupply -= _value;                                // Updates totalSupply
118       Burn(msg.sender, _value);
119       return true;
120   }
121 
122   function burnFrom(address _from, uint256 _value) returns (bool success) {
123       require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
124       require(_value <= allowance[_from][msg.sender]);    // Check allowance
125       balanceOf[_from] -= _value;                         // Subtract from the targeted balance
126       allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
127       totalSupply -= _value;                              // Update totalSupply
128       Burn(_from, _value);
129       return true;
130   }
131 
132 }
133 
134 contract MyAdvancedToken is token {
135 
136   uint256 public sellPrice;
137   uint256 public buyPrice;
138 
139   mapping (address => bool) public frozenAccount;
140 
141   /* This generates a public event on the blockchain that will notify clients */
142   event FrozenFunds(address target, bool frozen);
143 
144   /* Initializes contract with initial supply tokens to the creator of the contract */
145   function MyAdvancedToken(
146       uint256 initialSupply,
147       string tokenName,
148       uint8 decimalUnits,
149       string tokenSymbol
150   ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
151 
152   /* Internal transfer, only can be called by this contract */
153   function _transfer(address _from, address _to, uint _value) internal {
154       require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
155       require (balanceOf[_from] > _value);                // Check if the sender has enough
156       require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
157       require(!frozenAccount[_from]);                     // Check if sender is frozen
158       require(!frozenAccount[_to]);                       // Check if recipient is frozen
159       balanceOf[_from] -= _value;                         // Subtract from the sender
160       balanceOf[_to] += _value;                           // Add the same to the recipient
161       Transfer(_from, _to, _value);
162   }
163 
164   /// @notice Create `mintedAmount` tokens and send it to `target`
165   /// @param target Address to receive the tokens
166   /// @param mintedAmount the amount of tokens it will receive
167   function mintToken(address target, uint256 mintedAmount) onlyOwner {
168       balanceOf[target] += mintedAmount;
169       totalSupply += mintedAmount;
170       Transfer(0, this, mintedAmount);
171       Transfer(this, target, mintedAmount);
172   }
173 
174   /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
175   /// @param target Address to be frozen
176   /// @param freeze either to freeze it or not
177   function freezeAccount(address target, bool freeze) onlyOwner {
178       frozenAccount[target] = freeze;
179       FrozenFunds(target, freeze);
180   }
181 
182   /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
183   /// @param newSellPrice Price the users can sell to the contract
184   /// @param newBuyPrice Price users can buy from the contract
185   function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
186       sellPrice = newSellPrice;
187       buyPrice = newBuyPrice;
188   }
189 
190   /// @notice Buy tokens from contract by sending ether
191   function buy() payable {
192       uint amount = msg.value / buyPrice;               // calculates the amount
193       _transfer(this, msg.sender, amount);              // makes the transfers
194   }
195 
196   /// @notice Sell `amount` tokens to contract
197   /// @param amount amount of tokens to be sold
198   function sell(uint256 amount) {
199       require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
200       _transfer(msg.sender, this, amount);              // makes the transfers
201       msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
202   }
203 }