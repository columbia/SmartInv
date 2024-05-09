1 pragma solidity ^0.4.11;
2 contract owned {
3 address public owner;
4 constructor () public {
5 owner = msg.sender;
6 }
7 modifier onlyOwner {
8 require(msg.sender == owner);
9 _;
10 }
11 function transferOwnership(address newOwner) onlyOwner public {
12 owner = newOwner;
13 }
14 }
15 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
16 contract TokenERC20 {
17 // Public variables of the token
18 string public name;
19 string public symbol;
20 uint8 public decimals = 8;
21 // 18 decimals is the strongly suggested default, avoid changing it
22 uint256 public totalSupply;
23 // This creates an array with all balances
24 mapping (address => uint256) public balanceOf;
25 mapping (address => mapping (address => uint256)) public allowance;
26 // This generates a public event on the blockchain that will notify clients
27 event Transfer(address indexed from, address indexed to, uint256 value);
28 // This generates a public event on the blockchain that will notify clients
29 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
30 // This notifies clients about the amount burnt
31 event Burn(address indexed from, uint256 value);
32 /**
33 * Constrctor function
34 *
35 * Initializes contract with initial supply tokens to the creator of the contract
36 */
37 constructor(
38 uint256 initialSupply,
39 string tokenName,
40 string tokenSymbol
41 ) public {
42 totalSupply = initialSupply * 10 ** uint256(decimals);
43 // Update total supply with the decimal amount
44 balanceOf[msg.sender] = totalSupply;
45 // Give the creator all initial tokens
46 name = tokenName;
47 // Set the name for display purposes
48 symbol = tokenSymbol;
49 // Set the symbol for display purposes
50 }
51 /**
52 * Internal transfer, only can be called by this contract
53 */
54 function _transfer(address _from, address _to, uint _value) internal {
55 // Prevent transfer to 0x0 address. Use burn() instead
56 require(_to != 0x0);
57 // Check if the sender has enough
58 require(balanceOf[_from] >= _value);
59 // Check for overflows
60 require(balanceOf[_to] + _value > balanceOf[_to]);
61 // Save this for an assertion in the future
62 uint previousBalances = balanceOf[_from] + balanceOf[_to];
63 // Subtract from the sender
64 balanceOf[_from] -= _value;
65 // Add the same to the recipient
66 balanceOf[_to] += _value;
67 emit Transfer(_from, _to, _value);
68 // Asserts are used to use static analysis to find bugs in your code. They should never fail
69 assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
70 }
71 /**
72 * Transfer tokens
73 *
74 * Send `_value` tokens to `_to` from your account
75 *
76 * @param _to The address of the recipient
77 * @param _value the amount to send
78 */
79 function transfer(address _to, uint256 _value) public returns (bool success) {
80 _transfer(msg.sender, _to, _value);
81 return true;
82 }
83 /**
84 * Transfer tokens from other address
85 *
86 * Send `_value` tokens to `_to` in behalf of `_from`
87 *
88 * @param _from The address of the sender
89 * @param _to The address of the recipient
90 * @param _value the amount to send
91 */
92 function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
93 require(_value <= allowance[_from][msg.sender]);
94 // Check allowance
95 allowance[_from][msg.sender] -= _value;
96 _transfer(_from, _to, _value);
97 return true;
98 }
99 /**
100 * Set allowance for other address
101 *
102 * Allows `_spender` to spend no more than `_value` tokens in your behalf
103 *
104 * @param _spender The address authorized to spend
105 * @param _value the max amount they can spend
106 */
107 function approve(address _spender, uint256 _value) public
108 returns (bool success) {
109 allowance[msg.sender][_spender] = _value;
110 emit Approval(msg.sender, _spender, _value);
111 return true;
112 }
113 /**
114 * Set allowance for other address and notify
115 *
116 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
117 *
118 * @param _spender The address authorized to spend
119 * @param _value the max amount they can spend
120 * @param _extraData some extra information to send to the approved contract
121 */
122 function approveAndCall(address _spender, uint256 _value, bytes _extraData)
123 public
124 returns (bool success) {
125 tokenRecipient spender = tokenRecipient(_spender);
126 if (approve(_spender, _value)) {
127 spender.receiveApproval(msg.sender, _value, this, _extraData);
128 return true;
129 }
130 }
131 /**
132 * Destroy tokens
133 *
134 * Remove `_value` tokens from the system irreversibly
135 *
136 * @param _value the amount of money to burn
137 */
138 function burn(uint256 _value) public returns (bool success) {
139 require(balanceOf[msg.sender] >= _value);
140 // Check if the sender has enough
141 balanceOf[msg.sender] -= _value;
142 // Subtract from the sender
143 totalSupply -= _value;
144 // Updates totalSupply
145 emit Burn(msg.sender, _value);
146 return true;
147 }
148 /**
149 * Destroy tokens from other account
150 *
151 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
152 *
153 * @param _from the address of the sender
154 * @param _value the amount of money to burn
155 */
156 function burnFrom(address _from, uint256 _value) public returns (bool success) {
157 require(balanceOf[_from] >= _value);
158 // Check if the targeted balance is enough
159 require(_value <= allowance[_from][msg.sender]);
160 // Check allowance
161 balanceOf[_from] -= _value;
162 // Subtract from the targeted balance
163 allowance[_from][msg.sender] -= _value;
164 // Subtract from the sender's allowance
165 totalSupply -= _value;
166 // Update totalSupply
167 emit Burn(_from, _value);
168 return true;
169 }
170 }
171 /******************************************/
172 /* PlatformTeamCoinVer01 TOKEN STARTS HERE       */
173 /******************************************/
174 contract PlatformTeamCoinVer01 is owned, TokenERC20 {
175 uint256 public sellPrice;
176 uint256 public buyPrice;
177 mapping (address => bool) public frozenAccount;
178 /* This generates a public event on the blockchain that will notify clients */
179 event FrozenFunds(address target, bool frozen);
180 /* Initializes contract with initial supply tokens to the creator of the contract */
181 constructor(
182 uint256 initialSupply,
183 string tokenName,
184 string tokenSymbol
185 ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
186 /* Internal transfer, only can be called by this contract */
187 function _transfer(address _from, address _to, uint _value) internal {
188 require (_to != 0x0);
189 // Prevent transfer to 0x0 address. Use burn() instead
190 require (balanceOf[_from] >= _value);
191 // Check if the sender has enough
192 require (balanceOf[_to] + _value >= balanceOf[_to]);
193 // Check for overflows
194 require(!frozenAccount[_from]);
195 // Check if sender is frozen
196 require(!frozenAccount[_to]);
197 // Check if recipient is frozen
198 balanceOf[_from] -= _value;
199 // Subtract from the sender
200 balanceOf[_to] += _value;
201 // Add the same to the recipient
202 emit Transfer(_from, _to, _value);
203 }
204 /// @notice Create `mintedAmount` tokens and send it to `target`
205 /// @param target Address to receive the tokens
206 /// @param mintedAmount the amount of tokens it will receive
207 function mintToken(address target, uint256 mintedAmount) onlyOwner public {
208 balanceOf[target] += mintedAmount;
209 totalSupply += mintedAmount;
210 emit Transfer(0, this, mintedAmount);
211 emit Transfer(this, target, mintedAmount);
212 }
213 /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
214 /// @param target Address to be frozen
215 /// @param freeze either to freeze it or not
216 function freezeAccount(address target, bool freeze) onlyOwner public {
217 frozenAccount[target] = freeze;
218 emit FrozenFunds(target, freeze);
219 }
220 /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
221 /// @param newSellPrice Price the users can sell to the contract
222 /// @param newBuyPrice Price users can buy from the contract
223 function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
224 sellPrice = newSellPrice;
225 buyPrice = newBuyPrice;
226 }
227 /// @notice Buy tokens from contract by sending ether
228 function buy() payable public {
229 uint amount = msg.value / buyPrice;
230 // calculates the amount
231 _transfer(this, msg.sender, amount);
232 // makes the transfers
233 }
234 /// @notice Sell `amount` tokens to contract
235 /// @param amount amount of tokens to be sold
236 function sell(uint256 amount) public {
237 address myAddress = this;
238 require(myAddress.balance >= amount * sellPrice);
239 // checks if the contract has enough ether to buy
240 _transfer(msg.sender, this, amount);
241 // makes the transfers
242 msg.sender.transfer(amount * sellPrice);
243 // sends ether to the seller. It's important to do this last to avoid recursion attacks
244 }
245 }