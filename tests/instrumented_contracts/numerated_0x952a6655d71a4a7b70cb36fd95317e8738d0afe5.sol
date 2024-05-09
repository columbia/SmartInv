1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a && c >= b);
26     return c;
27   }
28 
29   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
30     return a >= b ? a : b;
31   }
32 
33   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
34     return a < b ? a : b;
35   }
36 
37   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
38     return a >= b ? a : b;
39   }
40 
41   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
42     return a < b ? a : b;
43   }
44 
45 
46 }
47 
48 
49 
50 
51 
52 contract owned { //Contract used to only allow the owner to call some functions
53   address public owner;
54 
55   function owned() public {
56   owner = msg.sender;
57   }
58 
59   modifier onlyOwner {
60   require(msg.sender == owner);
61   _;
62   }
63 
64   function transferOwnership(address newOwner) onlyOwner public {
65   owner = newOwner;
66   }
67 }
68 
69 
70 contract TokenERC20 {
71 
72 using SafeMath for uint256;
73 // Public variables of the token
74 string public name;
75 string public symbol;
76 uint8 public decimals = 18;
77 //
78 uint256 public totalSupply;
79 
80 
81 // This creates an array with all balances
82 mapping (address => uint256) public balanceOf;
83 mapping (address => mapping (address => uint256)) public allowance;
84 
85 // This generates a public event on the blockchain that will notify clients
86 event Transfer(address indexed from, address indexed to, uint256 value);
87 
88 // This notifies clients about the amount burnt
89 event Burn(address indexed from, uint256 value);
90 
91 /**
92 * Constrctor function
93 *
94 * Initializes contract with initial supply tokens to the creator of the contract
95 */
96 function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
97   totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
98   balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
99   name = tokenName;                                   // Set the name for display purposes
100   symbol = tokenSymbol;                               // Set the symbol for display purposes
101 }
102 
103 /**
104 * Internal transfer, only can be called by this contract
105 */
106 function _transfer(address _from, address _to, uint _value) internal {
107   // Prevent transfer to 0x0 address. Use burn() instead
108   require(_to != 0x0);
109   // Check for overflows
110   // Subtract from the sender
111   balanceOf[_from] = balanceOf[_from].sub(_value);
112   // Add the same to the recipient
113   balanceOf[_to] = balanceOf[_to].add(_value);
114   emit Transfer(_from, _to, _value);
115 }
116 
117 /**
118 * Function to Transfer tokens
119 *
120 * Send `_value` tokens to `_to` from your account
121 *
122 * @param _to The address of the recipient
123 * @param _value the amount to send
124 */
125 function transfer(address _to, uint256 _value) public {
126   _transfer(msg.sender, _to, _value);
127 }
128 
129 /**
130 * function to Transfer tokens from other address
131 *
132 * Send `_value` tokens to `_to` in behalf of `_from`
133 *
134 * @param _from The address of the sender
135 * @param _to The address of the recipient
136 * @param _value the amount to send
137 */
138 function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
139   allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
140   _transfer(_from, _to, _value);
141   return true;
142 }
143 
144 /**
145 * function Set allowance for other address
146 *
147 * Allows `_spender` to spend no more than `_value` tokens in your behalf
148 *
149 * @param _spender The address authorized to spend
150 * @param _value the max amount they can spend
151 */
152 function approve(address _spender, uint256 _value) public returns (bool success) {
153   allowance[msg.sender][_spender] = _value;
154   return true;
155 }
156 
157 
158 /**
159 *Function to Destroy tokens
160 *
161 * Remove `_value` tokens from the system irreversibly
162 *
163 * @param _value the amount of money to burn
164 */
165 function burn(uint256 _value) public returns (bool success) {
166   balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
167   totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
168   emit Burn(msg.sender, _value);
169   return true;
170 }
171 
172 
173 
174 /**
175 * Destroy tokens from other ccount
176 *
177 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
178 *
179 * @param _from the address of the sender
180 * @param _value the amount of money to burn
181 */
182 function burnFrom(address _from, uint256 _value) public returns (bool success) {
183   balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
184   allowance[_from][msg.sender] =allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
185   totalSupply = totalSupply.sub(_value);                              // Update totalSupply
186   emit Burn(_from, _value);
187   return true;
188 }
189 
190 
191 }
192 
193 /******************************************/
194 /*       Accommodation Coin STARTS HERE       */
195 /******************************************/
196 
197 contract AccommodationCoin is owned, TokenERC20  {
198 
199   //Modify these variables
200   uint256 _initialSupply=100000000; 
201   string _tokenName="Accommodation Coin";  
202   string _tokenSymbol="ACC";
203 
204   mapping (address => bool) public frozenAccount;
205 
206   /* This generates a public event on the blockchain that will notify clients */
207   event FrozenFunds(address target, bool frozen);
208 
209   /* Initializes contract with initial supply tokens to the creator of the contract */
210   function AccommodationCoin( ) TokenERC20(_initialSupply, _tokenName, _tokenSymbol) public {}
211 
212   /* Internal transfer, only can be called by this contract. */
213   function _transfer(address _from, address _to, uint _value) internal {
214     require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
215     require(!frozenAccount[_from]);                     // Check if sender is frozen
216     require(!frozenAccount[_to]);                       // Check if recipient is frozen
217     balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
218     balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
219     emit Transfer(_from, _to, _value);
220   }
221 
222   /// function to create more coins and send it to `target`
223   /// @param target Address to receive the tokens
224   /// @param mintedAmount the amount of tokens it will receive
225   function mintToken(address target, uint256 mintedAmount) onlyOwner public {
226     balanceOf[target] = balanceOf[target].add(mintedAmount);
227     totalSupply = totalSupply.add(mintedAmount);
228     emit Transfer(0, this, mintedAmount);
229     emit Transfer(this, target, mintedAmount);
230   }
231 
232   function freezeAccount(address target, bool freeze) onlyOwner public {
233     frozenAccount[target] = freeze;
234     emit FrozenFunds(target, freeze);
235   }
236 
237 
238 
239 }