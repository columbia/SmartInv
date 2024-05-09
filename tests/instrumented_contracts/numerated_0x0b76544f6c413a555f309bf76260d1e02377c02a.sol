1 pragma solidity ^0.4.13; contract owned { address public owner;
2   function owned() {
3       owner = msg.sender;
4   }
5 
6   modifier onlyOwner {
7       require(msg.sender == owner);
8       _;
9   }
10 
11   function transferOwnership(address newOwner) onlyOwner {
12       owner = newOwner;
13   }
14 }
15 contract tokenRecipient { function receiveApproval(address from, uint256 value, address token, bytes extraData); }
16 contract token { /*Public variables of the token*/ string public name; string public symbol; uint8 public decimals; uint256 public totalSupply;
17   /* This creates an array with all balances */
18   mapping (address => uint256) public balanceOf;
19   mapping (address => mapping (address => uint256)) public allowance;
20 
21   /* This generates a public event on the blockchain that will notify clients */
22   event Transfer(address indexed from, address indexed to, uint256 value);
23 
24   /* This notifies clients about the amount burnt */
25   event Burn(address indexed from, uint256 value);
26 
27   /* Initializes contract with initial supply tokens to the creator of the contract */
28   function token(
29       uint256 initialSupply,
30       string tokenName,
31       uint8 decimalUnits,
32       string tokenSymbol
33       ) {
34       balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
35       totalSupply = initialSupply;                        // Update total supply
36       name = tokenName;                                   // Set the name for display purposes
37       symbol = tokenSymbol;                               // Set the symbol for display purposes
38       decimals = decimalUnits;                            // Amount of decimals for display purposes
39   }
40 
41   /* Internal transfer, only can be called by this contract */
42   function _transfer(address _from, address _to, uint _value) internal {
43       require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
44       require (balanceOf[_from] > _value);                // Check if the sender has enough
45       require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
46       balanceOf[_from] -= _value;                         // Subtract from the sender
47       balanceOf[_to] += _value;                            // Add the same to the recipient
48       Transfer(_from, _to, _value);
49   }
50 
51   /// @notice Send `_value` tokens to `_to` from your account
52   /// @param _to The address of the recipient
53   /// @param _value the amount to send
54   function transfer(address _to, uint256 _value) {
55       _transfer(msg.sender, _to, _value);
56   }
57 
58   /// @notice Send `_value` tokens to `_to` in behalf of `_from`
59   /// @param _from The address of the sender
60   /// @param _to The address of the recipient
61   /// @param _value the amount to send
62   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
63       require (_value < allowance[_from][msg.sender]);     // Check allowance
64       allowance[_from][msg.sender] -= _value;
65       _transfer(_from, _to, _value);
66       return true;
67   }
68 
69   /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
70   /// @param _spender The address authorized to spend
71   /// @param _value the max amount they can spend
72   function approve(address _spender, uint256 _value)
73       returns (bool success) {
74       allowance[msg.sender][_spender] = _value;
75       return true;
76   }
77 
78   /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
79   /// @param _spender The address authorized to spend
80   /// @param _value the max amount they can spend
81   /// @param _extraData some extra information to send to the approved contract
82   function approveAndCall(address _spender, uint256 _value, bytes _extraData)
83       returns (bool success) {
84       tokenRecipient spender = tokenRecipient(_spender);
85       if (approve(_spender, _value)) {
86           spender.receiveApproval(msg.sender, _value, this, _extraData);
87           return true;
88       }
89   }        
90 
91   /// @notice Remove `_value` tokens from the system irreversibly
92   /// @param _value the amount of money to burn
93   function burn(uint256 _value) returns (bool success) {
94       require (balanceOf[msg.sender] > _value);            // Check if the sender has enough
95       balanceOf[msg.sender] -= _value;                      // Subtract from the sender
96       totalSupply -= _value;                                // Updates totalSupply
97       Burn(msg.sender, _value);
98       return true;
99   }
100 
101   function burnFrom(address _from, uint256 _value) returns (bool success) {
102       require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
103       require(_value <= allowance[_from][msg.sender]);    // Check allowance
104       balanceOf[_from] -= _value;                         // Subtract from the targeted balance
105       allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
106       totalSupply -= _value;                              // Update totalSupply
107       Burn(_from, _value);
108       return true;
109   }
110 }
111 contract INTToken is owned, token {
112   uint256 public sellPrice;
113   uint256 public buyPrice;
114 
115   mapping (address => bool) public frozenAccount;
116 
117   /* This generates a public event on the blockchain that will notify clients */
118   event FrozenFunds(address target, bool frozen);
119 
120   /* Initializes contract with initial supply tokens to the creator of the contract */
121   function INTToken(
122       uint256 initialSupply,
123       string tokenName,
124       uint8 decimalUnits,
125       string tokenSymbol
126   ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
127 
128   /* Internal transfer, only can be called by this contract */
129   function _transfer(address _from, address _to, uint _value) internal {
130       require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
131       require (balanceOf[_from] > _value);                // Check if the sender has enough
132       require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
133       require(!frozenAccount[_from]);                     // Check if sender is frozen
134       require(!frozenAccount[_to]);                       // Check if recipient is frozen
135       balanceOf[_from] -= _value;                         // Subtract from the sender
136       balanceOf[_to] += _value;                           // Add the same to the recipient
137       Transfer(_from, _to, _value);
138   }
139 
140   /// @notice Create `mintedAmount` tokens and send it to `target`
141   /// @param target Address to receive the tokens
142   /// @param mintedAmount the amount of tokens it will receive
143   function mintToken(address target, uint256 mintedAmount) onlyOwner {
144       balanceOf[target] += mintedAmount;
145       totalSupply += mintedAmount;
146       Transfer(0, this, mintedAmount);
147       Transfer(this, target, mintedAmount);
148   }
149 
150   /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
151   /// @param target Address to be frozen
152   /// @param freeze either to freeze it or not
153   function freezeAccount(address target, bool freeze) onlyOwner {
154       frozenAccount[target] = freeze;
155       FrozenFunds(target, freeze);
156   }
157 
158   /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
159   /// @param newSellPrice Price the users can sell to the contract
160   /// @param newBuyPrice Price users can buy from the contract
161   function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
162       sellPrice = newSellPrice;
163       buyPrice = newBuyPrice;
164   }
165 
166   /// @notice Buy tokens from contract by sending ether
167   function buy() payable {
168       uint amount = msg.value / buyPrice;               // calculates the amount
169       _transfer(this, msg.sender, amount);              // makes the transfers
170   }
171 
172   /// @notice Sell `amount` tokens to contract
173   /// @param amount amount of tokens to be sold
174   function sell(uint256 amount) {
175       require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
176       _transfer(msg.sender, this, amount);              // makes the transfers
177       msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
178   }
179 }
180 contract INT is INTToken(1000000000000000, "Internet Node Token", 6, "INT") {}