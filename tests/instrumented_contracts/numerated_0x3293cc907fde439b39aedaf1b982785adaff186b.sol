1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7  library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /*
34 file:   ReentryProtection.sol
35 ver:    0.3.0
36 updated:6-April-2016
37 author: Darryl Morris
38 email:  o0ragman0o AT gmail.com
39 
40 Mutex based reentry protection protect.
41 
42 This software is distributed in the hope that it will be useful,
43 but WITHOUT ANY WARRANTY; without even the implied warranty of
44 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
45 GNU lesser General Public License for more details.
46 <http://www.gnu.org/licenses/>.
47 */
48 
49 contract ReentryProtected
50 {
51   // The reentry protection state mutex.
52   bool __reMutex;
53 
54   // This modifier can be used on functions with external calls to
55   // prevent reentry attacks.
56   // Constraints:
57   //   Protected functions must have only one point of exit.
58   //   Protected functions cannot use the `return` keyword
59   //   Protected functions return values must be through return parameters.
60   modifier preventReentry() {
61     require(!__reMutex);
62     __reMutex = true;
63     _;
64     delete __reMutex;
65     return;
66   }
67 
68   // This modifier can be applied to public access state mutation functions
69   // to protect against reentry if a `preventReentry` function has already
70   // set the mutex. This prevents the contract from being reenter under a
71   // different memory context which can break state variable integrity.
72   modifier noReentry() {
73     require(!__reMutex);
74     _;
75   }
76 }
77 
78 /*
79 file:   ERC20.sol
80 ver:    0.4.4-o0ragman0o
81 updated:26-July-2017
82 author: Darryl Morris
83 email:  o0ragman0o AT gmail.com
84 
85 An ERC20 compliant token with reentry protection and safe math.
86 
87 This software is distributed in the hope that it will be useful,
88 but WITHOUT ANY WARRANTY; without even the implied warranty of
89 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
90 See MIT Licence for further details.
91 <https://opensource.org/licenses/MIT>.
92 
93 Release Notes
94 -------------
95 0.4.4-o0ragman0o
96 * removed state from interface
97 * added abstract functions of public state to interface.
98 * included state into contract implimentation
99 */
100 
101 
102 // ERC20 Standard Token Interface with safe maths and reentry protection
103 contract ERC20Interface
104 {
105   /* Structs */
106 
107   /* State Valiables */
108 
109   /* Events */
110   // Triggered when tokens are transferred.
111   event Transfer(
112     address indexed _from,
113     address indexed _to,
114     uint256 _value);
115 
116   // Triggered whenever approve(address _spender, uint256 _value) is called.
117   event Approval(
118     address indexed _owner,
119     address indexed _spender,
120     uint256 _value);
121 
122   /* Modifiers */
123 
124   /* Function Abstracts */
125 
126   /// @return The total supply of tokens
127   function totalSupply() public constant returns (uint256);
128 
129   /// @param _addr The address of a token holder
130   /// @return The amount of tokens held by `_addr`
131   function balanceOf(address _addr) public constant returns (uint256);
132 
133   /// @param _owner The address of a token holder
134   /// @param _spender the address of a third-party
135   /// @return The amount of tokens the `_spender` is allowed to transfer
136   function allowance(address _owner, address _spender) public constant
137   returns (uint256);
138 
139   /// @notice Send `_amount` of tokens from `msg.sender` to `_to`
140   /// @param _to The address of the recipient
141   /// @param _amount The amount of tokens to transfer
142   function transfer(address _to, uint256 _amount) public returns (bool);
143 
144   /// @notice Send `_amount` of tokens from `_from` to `_to` on the condition
145   /// it is approved by `_from`
146   /// @param _from The address of the sender
147   /// @param _to The address of the recipient
148   /// @param _amount The amount of tokens to transfer
149   function transferFrom(address _from, address _to, uint256 _amount)
150   public returns (bool);
151 
152   /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
153   /// its behalf
154   /// @param _spender The address of the approved spender
155   /// @param _amount The amount of tokens to transfer
156   function approve(address _spender, uint256 _amount) public returns (bool);
157 }
158 
159 contract ERC20Token is ReentryProtected, ERC20Interface
160 {
161 
162   using SafeMath for uint256;
163 
164   /* State */
165   // The Total supply of tokens
166   uint256 totSupply;
167 
168   
169   // Token ownership mapping
170   mapping (address => uint256) balance;
171 
172   // Allowances mapping
173   mapping (address => mapping (address => uint256)) allowed;
174 
175   /* Funtions Public */
176 
177   function ERC20Token()
178   {
179     // Supply limited to 2^128 rather than 2^256 to prevent potential 
180     // multiplication overflow
181     
182     totSupply = 0;
183     balance[msg.sender] = totSupply;
184   }
185 
186   // Using an explicit getter allows for function overloading    
187   function totalSupply()
188   public
189   constant
190   returns (uint256)
191   {
192     return totSupply;
193   }
194 
195 
196   // Using an explicit getter allows for function overloading    
197   function balanceOf(address _addr)
198   public
199   constant
200   returns (uint256)
201   {
202     return balance[_addr];
203   }
204 
205   // Using an explicit getter allows for function overloading    
206   function allowance(address _owner, address _spender)
207   public
208   constant
209   returns (uint256 remaining_)
210   {
211     return allowed[_owner][_spender];
212   }
213 
214 
215   // Send _value amount of tokens to address _to
216   // Reentry protection prevents attacks upon the state
217   function transfer(address _to, uint256 _value)
218   public
219   noReentry
220   returns (bool)
221   {
222     return xfer(msg.sender, _to, _value);
223   }
224 
225   // Send _value amount of tokens from address _from to address _to
226   // Reentry protection prevents attacks upon the state
227   function transferFrom(address _from, address _to, uint256 _value)
228   public
229   noReentry
230   returns (bool)
231   {
232     require(_value <= allowed[_from][msg.sender]);
233     allowed[_from][msg.sender] -= _value;
234     return xfer(_from, _to, _value);
235   }
236 
237   // Process a transfer internally.
238   function xfer(address _from, address _to, uint256 _value)
239   internal
240   returns (bool)
241   {
242     require(_value > 0 && _value <= balance[_from]);
243     balance[_from] -= _value;
244     balance[_to] += _value;
245     Transfer(_from, _to, _value);
246     return true;
247   }
248 
249   // Approves a third-party spender
250   // Reentry protection prevents attacks upon the state
251   function approve(address _spender, uint256 _value)
252   public
253   noReentry
254   returns (bool)
255   {
256     require(balance[msg.sender] != 0);
257     allowed[msg.sender][_spender] = _value;
258     Approval(msg.sender, _spender, _value);
259     return true;
260   }
261 }
262 
263   /**
264  * @title Ownable
265  * @dev The Ownable contract has an owner address, and provides basic authorization control
266  * functions, this simplifies the implementation of "user permissions".
267  */
268  contract Ownable {
269   address public owner;
270 
271 
272   /**
273    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
274    * account.
275    */
276    function Ownable() {
277     owner = msg.sender;
278   }
279 
280 
281   /**
282    * @dev Throws if called by any account other than the owner.
283    */
284    modifier onlyOwner() {
285     require(msg.sender == owner);
286     _;
287   }
288 
289 
290   /**
291    * @dev Allows the current owner to transfer control of the contract to a newOwner.
292    * @param newOwner The address to transfer ownership to.
293    */
294    function transferOwnership(address newOwner) onlyOwner {
295     require(newOwner != address(0));      
296     owner = newOwner;
297   }
298 
299 }
300 
301 
302 /**
303  * @title Mintable token
304  * @dev Simple ERC20 Token example, with mintable token creation
305  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
306  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
307  */
308 
309  contract MintableToken is ERC20Token, Ownable {
310   using SafeMath for uint256;
311   event Mint(address indexed to, uint256 amount);
312   event MintFinished();
313 
314   bool public mintingFinished = false;
315 
316 
317   modifier canMint() {
318     require(!mintingFinished);
319     _;
320   }
321 
322   /**
323    * @dev Function to mint tokens
324    * @param _to The address that will recieve the minted tokens.
325    * @param _amount The amount of tokens to mint.
326    * @return A boolean that indicates if the operation was successful.
327    */
328    function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
329     totSupply = totSupply.add(_amount);
330     balance[_to] = balance[_to].add(_amount);
331     Mint(_to, _amount);
332     Transfer(0x0, _to, _amount);
333     return true;
334   }
335 
336     /**
337    * @dev Function to stop minting new tokens.
338    * @return True if the operation was successful.
339    */
340    function finishMinting() onlyOwner returns (bool) {
341     mintingFinished = true;
342     MintFinished();
343     return true;
344   }
345 }
346 /**
347  * @title SimpleToken
348  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator. 
349  * Note they can later distribute these tokens as they wish using `transfer` and other
350  * `StandardToken` functions.
351  */
352  contract TriaToken_v2 is MintableToken {
353 
354   string public constant name = "TriaToken";
355   string public constant symbol = "TRIA";
356   uint256 public constant decimals = 10;
357 }