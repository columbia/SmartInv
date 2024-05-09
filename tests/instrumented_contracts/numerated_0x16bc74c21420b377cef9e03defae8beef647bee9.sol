1 /**
2 dev_team.gutalik
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 /**
8 * @title SafeMath
9 * @dev Math operations with safety checks that revert on error
10 */
11 library SafeMath {
12 
13 /**
14 * @dev Multiplies two numbers, reverts on overflow.
15 */
16 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17 if (a == 0) {
18 return 0;
19 }
20 
21 uint256 c = a * b;
22 require(c / a == b);
23 
24 return c;
25 }
26 function div(uint256 a, uint256 b) internal pure returns (uint256) {
27 require(b > 0); 
28 uint256 c = a / b;
29 
30 return c;
31 }
32 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33 require(b <= a);
34 uint256 c = a - b;
35 
36 return c;
37 }
38 
39 function add(uint256 a, uint256 b) internal pure returns (uint256) {
40 uint256 c = a + b;
41 require(c >= a);
42 
43 return c;
44 }
45 function mod(uint256 a, uint256 b) internal pure returns (uint256) {
46 require(b != 0);
47 return a % b;
48 }
49 }
50 
51 contract owned {
52 address public owner;
53 
54 constructor() public {
55 owner = msg.sender;
56 }
57 
58 modifier onlyOwner {
59 require(msg.sender == owner);
60 _;
61 }
62 
63 function transferOwnership(address newOwner) onlyOwner public {
64 owner = newOwner;
65 }
66 }
67 
68 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
69 
70 contract TokenERC20 is owned{
71 using SafeMath for uint256;
72 
73 // Public variables of the token
74 string public name = "security prime";
75 string public symbol = 'SNP';
76 uint8 public decimals = 18;
77 // 18 decimals is the strongly suggested default, avoid changing it
78 uint256 public totalSupply = 1000000000000000000000000000000;
79 bool public released = true;
80 
81 // This creates an array with all balances
82 mapping (address => uint256) public balanceOf;
83 mapping (address => mapping (address => uint256)) public allowance;
84 
85 // This generates a public event on the blockchain that will notify clients
86 event Transfer(address indexed from, address indexed to, uint256 value);
87 
88 // This generates a public event on the blockchain that will notify clients
89 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
90 
91 // This notifies clients about the amount burnt
92 event Burn(address indexed from, uint256 value);
93 
94 
95 constructor(
96 uint256 initialSupply,
97 string tokenName,
98 string tokenSymbol
99 ) public {
100 totalSupply = initialSupply * 10 ** uint256(decimals); // Update total supply with the decimal amount
101 balanceOf[msg.sender] = 0; // Give the creator all initial tokens
102 name = "security prime"; // Set the name for display purposes
103 symbol = "SNP"; // Set the symbol for display purposes
104 }
105 
106 function release() public onlyOwner{
107 require (owner == msg.sender);
108 released = !released;
109 }
110 
111 modifier onlyReleased() {
112 require(released);
113 _;
114 }
115 
116 function _transfer(address _from, address _to, uint _value) internal onlyReleased {
117 // Prevent transfer to 0x0 address. Use burn() instead
118 require(_to != 0x0);
119 // Check if the sender has enough
120 require(balanceOf[_from] >= _value);
121 // Check for overflows
122 require(balanceOf[_to] + _value > balanceOf[_to]);
123 // Save this for an assertion in the future
124 uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
125 // Subtract from the sender
126 balanceOf[_from] = balanceOf[_from].sub(_value);
127 // Add the same to the recipient
128 balanceOf[_to] = balanceOf[_to].add(_value);
129 emit Transfer(_from, _to, _value);
130 // Asserts are used to use static analysis to find bugs in your code. They should never fail
131 assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
132 }
133 
134 /**
135 * Transfer tokens
136 *
137 * Send `_value` tokens to `_to` from your account
138 *
139 * @param _to The address of the recipient
140 * @param _value the amount to send
141 */
142 function transfer(address _to, uint256 _value) public onlyReleased returns (bool success) {
143 _transfer(msg.sender, _to, _value);
144 return true;
145 }
146 
147 /**
148 * Transfer tokens from other address
149 *
150 * Send `_value` tokens to `_to` in behalf of `_from`
151 *
152 * @param _from The address of the sender
153 * @param _to The address of the recipient
154 * @param _value the amount to send
155 */
156 function transferFrom(address _from, address _to, uint256 _value) public onlyReleased returns (bool success) {
157 require(_value <= allowance[_from][msg.sender]); // Check allowance
158 
159 allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
160 _transfer(_from, _to, _value);
161 return true;
162 }
163 
164 /**
165 * Set allowance for other address
166 *
167 * Allows `_spender` to spend no more than `_value` tokens in your behalf
168 *
169 * @param _spender The address authorized to spend
170 * @param _value the max amount they can spend
171 */
172 function approve(address _spender, uint256 _value) public onlyReleased
173 returns (bool success) {
174 require(_spender != address(0));
175 
176 allowance[msg.sender][_spender] = _value;
177 emit Approval(msg.sender, _spender, _value);
178 return true;
179 }
180 
181 function approveAndCall(address _spender, uint256 _value, bytes _extraData)
182 public onlyReleased
183 returns (bool success) {
184 tokenRecipient spender = tokenRecipient(_spender);
185 if (approve(_spender, _value)) {
186 spender.receiveApproval(msg.sender, _value, this, _extraData);
187 return true;
188 }
189 }
190 
191 /**
192 * Destroy tokens
193 *
194 * Remove `_value` tokens from the system irreversibly
195 *
196 * @param _value the amount of money to burn
197 */
198 function burn(uint256 _value) public onlyReleased returns (bool success) {
199 require(balanceOf[msg.sender] >= _value); // Check if the sender has enough
200 balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value); // Subtract from the sender
201 totalSupply = totalSupply.sub(_value); // Updates totalSupply
202 emit Burn(msg.sender, _value);
203 return true;
204 }
205 
206 /**
207 * Destroy tokens from other account
208 *
209 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
210 *
211 * @param _from the address of the sender
212 * @param _value the amount of money to burn
213 */
214 function burnFrom(address _from, uint256 _value) public onlyReleased returns (bool success) {
215 require(balanceOf[_from] >= _value); // Check if the targeted balance is enough
216 require(_value <= allowance[_from][msg.sender]); // Check allowance
217 balanceOf[_from] = balanceOf[_from].sub(_value); // Subtract from the targeted balance
218 allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value); // Subtract from the sender's allowance
219 totalSupply = totalSupply.sub(_value); // Update totalSupply
220 emit Burn(_from, _value);
221 return true;
222 }
223 }
224 
225 contract SNP is owned, TokenERC20 {
226 
227 mapping (address => bool) public frozenAccount;
228 
229 /* This generates a public event on the blockchain that will notify clients */
230 event FrozenFunds(address target, bool frozen);
231 
232 /* Initializes contract with initial supply tokens to the creator of the contract */
233 constructor(
234 uint256 initialSupply,
235 string tokenName,
236 string tokenSymbol
237 ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {
238 }
239 
240 /* Internal transfer, only can be called by this contract */
241 function _transfer(address _from, address _to, uint _value) internal onlyReleased {
242 require (_to != 0x0); // Prevent transfer to 0x0 address. Use burn() instead
243 require (balanceOf[_from] >= _value); // Check if the sender has enough
244 require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
245 require(!frozenAccount[_from]); // Check if sender is frozen
246 require(!frozenAccount[_to]); // Check if recipient is frozen
247 balanceOf[_from] = balanceOf[_from].sub(_value); // Subtract from the sender
248 balanceOf[_to] = balanceOf[_to].add(_value); // Add the same to the recipient
249 emit Transfer(_from, _to, _value);
250 }
251 
252 /// @notice Create `mintedAmount` tokens and send it to `target`
253 /// @param target Address to receive the tokens
254 /// @param mintedAmount the amount of tokens it will receive
255 /// mintedAmount 1000000000000000000 = 1.000000000000000000
256 function mintToken(address target, uint256 mintedAmount) onlyOwner public {
257 require (mintedAmount > 0);
258 totalSupply = totalSupply.add(mintedAmount);
259 balanceOf[target] = balanceOf[target].add(mintedAmount);
260 emit Transfer(0, this, mintedAmount);
261 emit Transfer(this, target, mintedAmount);
262 }
263 
264 /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
265 /// @param target Address to be frozen
266 /// @param freeze either to freeze it or not
267 function freezeAccount(address target, bool freeze) onlyOwner public {
268 frozenAccount[target] = freeze;
269 emit FrozenFunds(target, freeze);
270 }
271 
272 }