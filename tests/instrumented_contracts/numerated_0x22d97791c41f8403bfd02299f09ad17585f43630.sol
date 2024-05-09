1 pragma solidity ^0.4.18;
2 
3 
4 contract SafeMath {
5 //internals
6 
7 function safeMul(uint a, uint b) internal returns(uint) {
8 uint c = a * b;
9 assert(a == 0 || c / a == b);
10 return c;
11 }
12 
13 function safeSub(uint a, uint b) internal returns(uint) {
14 assert(b <= a);
15 return a - b;
16 }
17 
18 function safeAdd(uint a, uint b) internal returns(uint) {
19 uint c = a + b;
20 assert(c >= a && c >= b);
21 return c;
22 }
23 }
24 
25 
26 
27 
28 contract owned {
29 address public owner;
30 
31 function owned() public {
32 owner = msg.sender;
33 }
34 
35 modifier onlyOwner {
36 require(msg.sender == owner);
37 _;
38 }
39 
40 function transferOwnership(address newOwner) onlyOwner public {
41 owner = newOwner;
42 }
43 }
44 
45 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
46 
47 contract TokenERC20 is SafeMath {
48 // Public variables of the token
49 string public name;
50 string public symbol;
51 uint8 public decimals = 8;
52 //
53 uint256 public totalSupply;
54 
55 
56 // This creates an array with all balances
57 mapping (address => uint256) public balanceOf;
58 mapping (address => mapping (address => uint256)) public allowance;
59 
60 // This generates a public event on the blockchain that will notify clients
61 event Transfer(address indexed from, address indexed to, uint256 value);
62 
63 // This notifies clients about the amount burnt
64 event Burn(address indexed from, uint256 value);
65 
66 /**
67 * Constrctor function
68 *
69 * Initializes contract with initial supply tokens to the creator of the contract
70 */
71 function TokenERC20(
72 uint256 initialSupply,
73 string tokenName,
74 string tokenSymbol
75 ) public {
76 totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
77 balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
78 name = tokenName;                                   // Set the name for display purposes
79 symbol = tokenSymbol;                               // Set the symbol for display purposes
80 }
81 
82 /**
83 * Internal transfer, only can be called by this contract
84 */
85 function _transfer(address _from, address _to, uint _value) internal {
86 // Prevent transfer to 0x0 address. Use burn() instead
87 require(_to != 0x0);
88 // Check if the sender has enough
89 require(balanceOf[_from] >= _value);
90 // Check for overflows
91 require(safeAdd(balanceOf[_to], _value) > balanceOf[_to]);
92 // Save this for an assertion in the future
93 uint previousBalances = safeAdd(balanceOf[_from], balanceOf[_to]);
94 // Subtract from the sender
95 balanceOf[_from] = safeSub(balanceOf[_from], _value);
96 // Add the same to the recipient
97 balanceOf[_to] = safeAdd(balanceOf[_to], _value);
98 Transfer(_from, _to, _value);
99 // Asserts are used to use static analysis to find bugs in your code. They should never fail
100 assert(safeAdd(balanceOf[_from], balanceOf[_to]) == previousBalances);
101 }
102 
103 /**
104 * Transfer tokens
105 *
106 * Send `_value` tokens to `_to` from your account
107 *
108 * @param _to The address of the recipient
109 * @param _value the amount to send
110 */
111 function transfer(address _to, uint256 _value) public {
112 _transfer(msg.sender, _to, _value);
113 }
114 
115 /**
116 * Transfer tokens from other address
117 *
118 * Send `_value` tokens to `_to` in behalf of `_from`
119 *
120 * @param _from The address of the sender
121 * @param _to The address of the recipient
122 * @param _value the amount to send
123 */
124 function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
125 require(_value <= allowance[_from][msg.sender]);     // Check allowance
126 allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
127 _transfer(_from, _to, _value);
128 return true;
129 }
130 
131 /**
132 * Set allowance for other address
133 *
134 * Allows `_spender` to spend no more than `_value` tokens in your behalf
135 *
136 * @param _spender The address authorized to spend
137 * @param _value the max amount they can spend
138 */
139 function approve(address _spender, uint256 _value) public
140 returns (bool success) {
141 allowance[msg.sender][_spender] = _value;
142 return true;
143 }
144 
145 /**
146 * Set allowance for other address and notify
147 *
148 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
149 *
150 * @param _spender The address authorized to spend
151 * @param _value the max amount they can spend
152 * @param _extraData some extra information to send to the approved contract
153 */
154 function approveAndCall(address _spender, uint256 _value, bytes _extraData)
155 public
156 returns (bool success) {
157 tokenRecipient spender = tokenRecipient(_spender);
158 if (approve(_spender, _value)) {
159 spender.receiveApproval(msg.sender, _value, this, _extraData);
160 return true;
161 }
162 }
163 
164 
165 
166 /**
167 * Destroy tokens
168 *
169 * Remove `_value` tokens from the system irreversibly
170 *
171 * @param _value the amount of money to burn
172 */
173 function burn(uint256 _value) public returns (bool success) {
174 require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
175 balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);            // Subtract from the sender
176 totalSupply = safeSub(totalSupply,_value);                      // Updates totalSupply
177 Burn(msg.sender, _value);
178 return true;
179 }
180 
181 
182 
183 /**
184 * Destroy tokens from other ccount
185 *
186 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
187 *
188 * @param _from the address of the sender
189 * @param _value the amount of money to burn
190 */
191 function burnFrom(address _from, uint256 _value) public returns (bool success) {
192 require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
193 require(_value <= allowance[_from][msg.sender]);    // Check allowance
194 balanceOf[_from] = safeSub(balanceOf[_from], _value);                         // Subtract from the targeted balance
195 allowance[_from][msg.sender] =safeSub(allowance[_from][msg.sender],_value);             // Subtract from the sender's allowance
196 totalSupply =safeSub(totalSupply,_value);                              // Update totalSupply
197 Burn(_from, _value);
198 return true;
199 }
200 }
201 
202 /******************************************/
203 /*       ADVANCED TOKEN STARTS HERE       */
204 /******************************************/
205 
206 contract BTC2x is owned, TokenERC20  {
207 
208 address public ico;
209 
210 mapping (address => bool) public frozenAccount;
211 
212 /* This generates a public event on the blockchain that will notify clients */
213 event FrozenFunds(address target, bool frozen);
214 
215 /* Initializes contract with initial supply tokens to the creator of the contract */
216 function BTC2x( ) TokenERC20(21000000, "Bitcoin SegWit2x", "BTC2x") public {}
217 
218 /* Internal transfer, only can be called by this contract */
219 function _transfer(address _from, address _to, uint _value) internal {
220 require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
221 require (balanceOf[_from] >= _value);                // Check if the sender has enough
222 require (safeAdd(balanceOf[_to], _value) > balanceOf[_to]); // Check for overflows
223 require(!frozenAccount[_from]);                     // Check if sender is frozen
224 require(!frozenAccount[_to]);                       // Check if recipient is frozen
225 balanceOf[_from] =safeSub(balanceOf[_from],_value);                         // Subtract from the sender
226 balanceOf[_to] =safeAdd(balanceOf[_to],_value);                           // Add the same to the recipient
227 Transfer(_from, _to, _value);
228 }
229 
230 /// @notice Create `mintedAmount` tokens and send it to `target`
231 /// @param target Address to receive the tokens
232 /// @param mintedAmount the amount of tokens it will receive
233 function mintToken(address target, uint256 mintedAmount) onlyOwner public {
234 balanceOf[target] =safeAdd(balanceOf[target],mintedAmount);
235 totalSupply =safeAdd(totalSupply,mintedAmount);
236 Transfer(0, this, mintedAmount);
237 Transfer(this, target, mintedAmount);
238 }
239 
240 /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
241 /// @param target Address to be frozen
242 /// @param freeze either to freeze it or not
243 function freezeAccount(address target, bool freeze) onlyOwner public {
244 frozenAccount[target] = freeze;
245 FrozenFunds(target, freeze);
246 }
247 
248 
249 
250 }