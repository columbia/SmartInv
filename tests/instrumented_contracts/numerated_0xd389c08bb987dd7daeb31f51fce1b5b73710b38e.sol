1 pragma solidity ^0.4.13;
2 
3 
4 contract owned {
5     address public owner;
6 
7     function owned() {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) onlyOwner {
17         owner = newOwner;
18     }
19 }
20 
21 
22 contract tokenRecipient {function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);}
23 
24 
25 contract token {
26     /* Public variables of the token */
27     string public name;
28     string public symbol;
29     uint8 public decimals;
30     uint256 public totalSupply;
31 
32     /* This creates an array with all balances */
33     mapping (address => uint256) public balanceOf;
34 
35     mapping (address => mapping (address => uint256)) public allowance;
36 
37     /* This generates a public event on the blockchain that will notify clients */
38     event Transfer(address indexed from, address indexed to, uint256 value);
39 
40     /* This notifies clients about the amount burnt */
41     event Burn(address indexed from, uint256 value);
42 
43     /* Initializes contract with initial supply tokens to the creator of the contract */
44     function token(
45     uint256 initialSupply,
46     string tokenName,
47     uint8 decimalUnits,
48     string tokenSymbol
49     ) {
50         balanceOf[address(this)] = initialSupply; // Give the contract all initial tokens
51         totalSupply = initialSupply; // Update total supply
52         name = tokenName; // Set the name for display purposes
53         symbol = tokenSymbol; // Set the symbol for display purposes
54         decimals = decimalUnits; // Amount of decimals for display purposes
55     }
56 
57     /* Internal transfer, only can be called by this contract */
58     function _transfer(address _from, address _to, uint _value) internal {
59         require(_to != 0x0); // Prevent transfer to 0x0 address. Use burn() instead
60         require(balanceOf[_from] > _value); // Check if the sender has enough
61         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
62         balanceOf[_from] -= _value; // Subtract from the sender
63         balanceOf[_to] += _value; // Add the same to the recipient
64         Transfer(_from, _to, _value);
65     }
66 
67     /// @notice Send `_value` tokens to `_to` from your account
68     /// @param _to The address of the recipient
69     /// @param _value the amount to send
70     function transfer(address _to, uint256 _value) {
71         _transfer(msg.sender, _to, _value);
72     }
73 
74     /// @notice Send `_value` tokens to `_to` in behalf of `_from`
75     /// @param _from The address of the sender
76     /// @param _to The address of the recipient
77     /// @param _value the amount to send
78     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
79         require(_value < allowance[_from][msg.sender]); // Check allowance
80         allowance[_from][msg.sender] -= _value;
81         _transfer(_from, _to, _value);
82         return true;
83     }
84 
85     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
86     /// @param _spender The address authorized to spend
87     /// @param _value the max amount they can spend
88     function approve(address _spender, uint256 _value)
89     returns (bool success) {
90         allowance[msg.sender][_spender] = _value;
91         return true;
92     }
93 
94     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
95     /// @param _spender The address authorized to spend
96     /// @param _value the max amount they can spend
97     /// @param _extraData some extra information to send to the approved contract
98     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
99     returns (bool success) {
100         tokenRecipient spender = tokenRecipient(_spender);
101         if (approve(_spender, _value)) {
102             spender.receiveApproval(msg.sender, _value, this, _extraData);
103             return true;
104         }
105     }
106 
107     /// @notice Remove `_value` tokens from the system irreversibly
108     /// @param _value the amount of money to burn
109     function burn(uint256 _value) returns (bool success) {
110         require(balanceOf[msg.sender] > _value); // Check if the sender has enough
111         balanceOf[msg.sender] -= _value; // Subtract from the sender
112         totalSupply -= _value; // Updates totalSupply
113         Burn(msg.sender, _value);
114         return true;
115     }
116 
117     function burnFrom(address _from, uint256 _value) returns (bool success) {
118         require(balanceOf[_from] >= _value); // Check if the targeted balance is enough
119         require(_value <= allowance[_from][msg.sender]); // Check allowance
120         balanceOf[_from] -= _value; // Subtract from the targeted balance
121         allowance[_from][msg.sender] -= _value; // Subtract from the sender's allowance
122         totalSupply -= _value; // Update totalSupply
123         Burn(_from, _value);
124         return true;
125     }
126 }
127 
128 
129 contract MyAdvancedToken is owned, token {
130     uint256 public sellPrice;
131     uint256 public buyPrice;
132     mapping (address => bool) public frozenAccount;
133 
134     /* This generates a public event on the blockchain that will notify clients */
135     event FrozenFunds(address target, bool frozen);
136 
137     /* Initializes contract with initial supply tokens to the creator of the contract */
138     function MyAdvancedToken(
139     uint256 initialSupply,
140     string tokenName,
141     uint8 decimalUnits,
142     string tokenSymbol
143     ) token(initialSupply, tokenName, decimalUnits, tokenSymbol) {}
144 
145     /* Internal transfer, only can be called by this contract */
146     function _transfer(address _from, address _to, uint _value) internal {
147         require(_to != 0x0); // Prevent transfer to 0x0 address. Use burn() instead
148         require(balanceOf[_from] > _value); // Check if the sender has enough
149         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
150         require(!frozenAccount[_from]); // Check if sender is frozen
151         require(!frozenAccount[_to]); // Check if recipient is frozen
152         balanceOf[_from] -= _value; // Subtract from the sender
153         balanceOf[_to] += _value; // Add the same to the recipient
154         Transfer(_from, _to, _value);
155     }
156 
157     /// @notice Create `mintedAmount` tokens and send it to `target`
158     /// @param target Address to receive the tokens
159     /// @param mintedAmount the amount of tokens it will receive
160     function mintToken(address target, uint256 mintedAmount) onlyOwner {
161         balanceOf[target] += mintedAmount;
162         totalSupply += mintedAmount;
163         Transfer(0, this, mintedAmount);
164         Transfer(this, target, mintedAmount);
165     }
166 
167     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
168     /// @param target Address to be frozen
169     /// @param freeze either to freeze it or not
170     function freezeAccount(address target, bool freeze) onlyOwner {
171         frozenAccount[target] = freeze;
172         FrozenFunds(target, freeze);
173     }
174 
175     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
176     /// @param newSellPrice Price the users can sell to the contract
177     /// @param newBuyPrice Price users can buy from the contract
178     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
179         sellPrice = newSellPrice;
180         buyPrice = newBuyPrice;
181     }
182 
183     /// @notice Buy tokens from contract by sending ether
184     function () payable {
185         uint amount = msg.value / buyPrice; // calculates the amount
186         _transfer(this, msg.sender, amount); // makes the transfers
187     }
188 
189     /// @notice Sell `amount` tokens to contract
190     /// @param amount amount of tokens to be sold
191     function sell(uint256 amount) {
192         require(this.balance >= amount * sellPrice); // checks if the contract has enough ether to buy
193         _transfer(msg.sender, this, amount); // makes the transfers
194         msg.sender.transfer(amount * sellPrice); // sends ether to the seller. It's important to do this last to avoid recursion attacks
195     }
196 }
197 
198 contract NeuroToken is MyAdvancedToken {
199     /* Public variables of the token */
200     uint256 public frozenTokensSupply;
201 
202     /* Initializes contract with initial supply tokens to the creator of the contract */
203     function NeuroToken() MyAdvancedToken(17500000, "NeuroToken", 0, "NRT") {
204         freezeTokens(17437000);
205     }
206 
207     /// @notice Freeze `frozenAmount` tokens from being sold
208     /// @param frozenAmount amount of tokens to be frozen
209     function freezeTokens(uint256 frozenAmount) onlyOwner {
210         require(balanceOf[address(this)] >= frozenAmount); // Check if the contract has enough
211 
212         frozenTokensSupply += frozenAmount;
213         balanceOf[address(this)] -= frozenAmount;
214     }
215 
216     /// @notice Release `releasedAmount` tokens to contract
217     /// @param releasedAmount amount of tokens to be released
218     function releaseTokens(uint256 releasedAmount) onlyOwner {
219         require(frozenTokensSupply >= releasedAmount); // Check if the contract has enough released tokens
220 
221         frozenTokensSupply -= releasedAmount;
222         balanceOf[address(this)] += releasedAmount;
223     }
224 
225     // Withdraw the funds
226     function safeWithdrawal(address target, uint256 amount) onlyOwner {
227         require(this.balance >= amount); // checks if the contract has enough ether to withdraw
228         target.transfer(amount); // sends ether to the target. It's important to do this last to avoid recursion attacks
229     }
230 }