1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 library SafeMath {
6 
7 /**
8 * @dev Multiplies two numbers, throws on overflow.
9 */
10 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11 if (a == 0) {
12 return 0;
13 }
14 uint256 c = a * b;
15 assert(c / a == b);
16 return c;
17 }
18 
19 /**
20 * @dev Integer division of two numbers, truncating the quotient.
21 */
22 function div(uint256 a, uint256 b) internal pure returns (uint256) {
23 // assert(b > 0); // Solidity automatically throws when dividing by 0
24 uint256 c = a / b;
25 // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26 return c;
27 }
28 
29 /**
30 * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31 */
32 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33 assert(b <= a);
34 return a - b;
35 }
36 
37 /**
38 * @dev Adds two numbers, throws on overflow.
39 */
40 function add(uint256 a, uint256 b) internal pure returns (uint256) {
41 uint256 c = a + b;
42 assert(c >= a);
43 return c;
44 }
45 }
46 contract GGG {
47 // Public variables of the token
48 
49 using SafeMath for uint256;
50 
51 mapping (address => bool) private admins;
52 string public name;
53 string public symbol;
54 uint8 public decimals = 18;
55 uint256 public remainRewards;
56 address public distributeA;
57 // 18 decimals is the strongly suggested default, avoid changing it
58 uint256 public totalSupply;
59 
60 address contractCreator;
61 // This creates an array with all balances
62 mapping (address => uint256) public balanceOf;
63 mapping (address => mapping (address => uint256)) public allowance;
64 
65 // This generates a public event on the blockchain that will notify clients
66 event Transfer(address indexed from, address indexed to, uint256 value);
67 
68 // This notifies clients about the amount burnt
69 event Burn(address indexed from, uint256 value);
70 
71 /**
72 * Constructor function
73 *
74 * Initializes contract with initial supply tokens to the creator of the contract
75 */
76 function GGG() public {
77 totalSupply = 100000000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
78 balanceOf[msg.sender] = totalSupply.div(4);                // Give the creator all initial tokens
79 remainRewards = totalSupply - balanceOf[msg.sender];
80 name = "Goyougame";                                   // Set the name for display purposes
81 symbol = "GGG";                               // Set the symbol for display purposes
82 
83 contractCreator = msg.sender;
84 admins[contractCreator] = true;
85 }
86 
87 //modifiers
88 modifier onlyContractCreator() {
89 require (msg.sender == contractCreator);
90 _;
91 }
92 modifier onlyAdmins() {
93 require(admins[msg.sender]);
94 _;
95 }
96 
97 //Owners and admins
98 
99 /* Owner */
100 function setOwner (address _owner) onlyContractCreator() public {
101 contractCreator = _owner;
102 }
103 
104 function addAdmin (address _admin) onlyContractCreator() public {
105 admins[_admin] = true;
106 }
107 
108 function removeAdmin (address _admin) onlyContractCreator() public {
109 delete admins[_admin];
110 }
111 
112 function getDsitribute(address _who, uint _amount) public onlyAdmins{
113 
114 remainRewards = remainRewards - _amount;
115 balanceOf[_who] =  balanceOf[_who] + _amount;
116 Transfer(distributeA, _who, _amount * 10 ** uint256(decimals));
117 
118 
119 }
120 
121 function getDsitributeMulti(address[] _who, uint[] _amount) public onlyAdmins{
122 require(_who.length == _amount.length);
123 for(uint i=0; i <= _who.length; i++){
124 remainRewards = remainRewards - _amount[i];
125 balanceOf[_who[i]] =  balanceOf[_who[i]] + _amount[i];
126 Transfer(distributeA, _who[i], _amount[i] * 10 ** uint256(decimals));
127 
128 }
129 }
130 /**
131 * Internal transfer, only can be called by this contract
132 */
133 function _transfer(address _from, address _to, uint _value) internal {
134 // Prevent transfer to 0x0 address. Use burn() instead
135 require(_to != 0x0);
136 // Check if the sender has enough
137 require(balanceOf[_from] >= _value);
138 // Check for overflows
139 require(balanceOf[_to] + _value > balanceOf[_to]);
140 // Save this for an assertion in the future
141 uint previousBalances = balanceOf[_from] + balanceOf[_to];
142 // Subtract from the sender
143 balanceOf[_from] -= _value;
144 // Add the same to the recipient
145 balanceOf[_to] += _value;
146 Transfer(_from, _to, _value);
147 // Asserts are used to use static analysis to find bugs in your code. They should never fail
148 assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
149 }
150 
151 /**
152 * Transfer tokens
153 *
154 * Send `_value` tokens to `_to` from your account
155 *
156 * @param _to The address of the recipient
157 * @param _value the amount to send
158 */
159 function transfer(address _to, uint256 _value) public {
160 _transfer(msg.sender, _to, _value);
161 }
162 
163 function setaddress(address _dis) public onlyAdmins{
164 distributeA = _dis;
165 
166 }
167 /**
168 * Transfer tokens from other address
169 *
170 * Send `_value` tokens to `_to` on behalf of `_from`
171 *
172 * @param _from The address of the sender
173 * @param _to The address of the recipient
174 * @param _value the amount to send
175 */
176 function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
177 require(_value <= allowance[_from][msg.sender]);     // Check allowance
178 allowance[_from][msg.sender] -= _value;
179 _transfer(_from, _to, _value);
180 return true;
181 }
182 
183 /**
184 * Set allowance for other address
185 *
186 * Allows `_spender` to spend no more than `_value` tokens on your behalf
187 *
188 * @param _spender The address authorized to spend
189 * @param _value the max amount they can spend
190 */
191 function approve(address _spender, uint256 _value) public
192 returns (bool success) {
193 allowance[msg.sender][_spender] = _value;
194 return true;
195 }
196 
197 /**
198 * Set allowance for other address and notify
199 *
200 * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
201 *
202 * @param _spender The address authorized to spend
203 * @param _value the max amount they can spend
204 * @param _extraData some extra information to send to the approved contract
205 */
206 function approveAndCall(address _spender, uint256 _value, bytes _extraData)
207 public
208 returns (bool success) {
209 tokenRecipient spender = tokenRecipient(_spender);
210 if (approve(_spender, _value)) {
211 spender.receiveApproval(msg.sender, _value, this, _extraData);
212 return true;
213 }
214 }
215 
216 /**
217 * Destroy tokens
218 *
219 * Remove `_value` tokens from the system irreversibly
220 *
221 * @param _value the amount of money to burn
222 */
223 function burn(uint256 _value) public returns (bool success) {
224 require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
225 balanceOf[msg.sender] -= _value;            // Subtract from the sender
226 totalSupply -= _value;                      // Updates totalSupply
227 Burn(msg.sender, _value);
228 return true;
229 }
230 
231 /**
232 * Destroy tokens from other account
233 *
234 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
235 *
236 * @param _from the address of the sender
237 * @param _value the amount of money to burn
238 */
239 function burnFrom(address _from, uint256 _value) public returns (bool success) {
240 require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
241 require(_value <= allowance[_from][msg.sender]);    // Check allowance
242 balanceOf[_from] -= _value;                         // Subtract from the targeted balance
243 allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
244 totalSupply -= _value;                              // Update totalSupply
245 Burn(_from, _value);
246 return true;
247 }
248 }