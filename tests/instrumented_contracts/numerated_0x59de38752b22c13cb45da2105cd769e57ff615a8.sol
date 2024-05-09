1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40 
41 
42   /**
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44    * account.
45    */
46   function Ownable() {
47     owner = msg.sender;
48   }
49 
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) onlyOwner {
65     if (newOwner != address(0)) {
66       owner = newOwner;
67     }
68   }
69 
70 }
71 
72 /**
73  * @title Pausable
74  * @dev Base contract which allows children to implement an emergency stop mechanism.
75  */
76 contract Pausable is Ownable {
77   event Pause();
78   event Unpause();
79 
80   bool public paused = true;
81 
82   /**
83    * @dev modifier to allow actions only when the contract IS NOT paused
84    */
85   modifier whenNotPaused() {
86     require(!paused);
87     _;
88   }
89 
90   /**
91    * @dev modifier to allow actions only when the contract IS paused
92    */
93   modifier whenPaused {
94     require(paused);
95     _;
96   }
97 
98   /**
99    * @dev called by the owner to pause, triggers stopped state
100    */
101   function pause() onlyOwner whenNotPaused returns (bool) {
102     paused = true;
103     Pause();
104     return true;
105   }
106 
107   /**
108    * @dev called by the owner to unpause, returns to normal state
109    */
110   function unpause() onlyOwner whenPaused returns (bool) {
111     paused = false;
112     Unpause();
113     return true;
114   }
115 }
116 
117 /**
118  * @title ERC20Basic
119  * @dev Simpler version of ERC20 interface
120  * @dev see https://github.com/ethereum/EIPs/issues/20
121  */
122 contract ERC20Basic {
123   uint256 public totalSupply;
124   function balanceOf(address who) constant returns (uint256);
125   function transfer(address to, uint256 value);
126   event Transfer(address indexed from, address indexed to, uint256 value);
127 }
128 
129 /**
130  * @title ERC20 interface
131  * @dev see https://github.com/ethereum/EIPs/issues/20
132  */
133 contract ERC20 is ERC20Basic {
134   function allowance(address owner, address spender) constant returns (uint256);
135   function transferFrom(address from, address to, uint256 value);
136   function approve(address spender, uint256 value);
137   event Approval(address indexed owner, address indexed spender, uint256 value);
138 }
139 
140 /**
141  * @title Basic token
142  * @dev Basic version of StandardToken, with no allowances.
143  */
144 contract BasicToken is ERC20Basic {
145   using SafeMath for uint256;
146 
147   mapping(address => uint256) balances;
148 
149   /**
150   * @dev transfer token for a specified address
151   * @param _to The address to transfer to.
152   * @param _value The amount to be transferred.
153   */
154   function transfer(address _to, uint256 _value) {
155     balances[msg.sender] = balances[msg.sender].sub(_value);
156     balances[_to] = balances[_to].add(_value);
157     Transfer(msg.sender, _to, _value);
158   }
159 
160   /**
161   * @dev Gets the balance of the specified address.
162   * @param _owner The address to query the the balance of.
163   * @return An uint256 representing the amount owned by the passed address.
164   */
165   function balanceOf(address _owner) constant returns (uint256 balance) {
166     return balances[_owner];
167   }
168 
169 }
170 
171 /**
172  * @title Standard ERC20 token
173  *
174  * @dev Implementation of the basic standard token.
175  * @dev https://github.com/ethereum/EIPs/issues/20
176  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
177  */
178 contract StandardToken is ERC20, BasicToken {
179 
180   mapping (address => mapping (address => uint256)) allowed;
181 
182 
183   /**
184    * @dev Transfer tokens from one address to another
185    * @param _from address The address which you want to send tokens from
186    * @param _to address The address which you want to transfer to
187    * @param _value uint256 the amout of tokens to be transfered
188    */
189   function transferFrom(address _from, address _to, uint256 _value) {
190     var _allowance = allowed[_from][msg.sender];
191 
192     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
193     // if (_value > _allowance) throw;
194 
195     balances[_to] = balances[_to].add(_value);
196     balances[_from] = balances[_from].sub(_value);
197     allowed[_from][msg.sender] = _allowance.sub(_value);
198     Transfer(_from, _to, _value);
199   }
200 
201   /**
202    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
203    * @param _spender The address which will spend the funds.
204    * @param _value The amount of tokens to be spent.
205    */
206   function approve(address _spender, uint256 _value) {
207 
208     // To change the approve amount you first have to reduce the addresses`
209     //  allowance to zero by calling `approve(_spender, 0)` if it is not
210     //  already 0 to mitigate the race condition described here:
211     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212     require((_value == 0) && (allowed[msg.sender][_spender] == 0));
213 
214     allowed[msg.sender][_spender] = _value;
215     Approval(msg.sender, _spender, _value);
216   }
217 
218   /**
219    * @dev Function to check the amount of tokens that an owner allowed to a spender.
220    * @param _owner address The address which owns the funds.
221    * @param _spender address The address which will spend the funds.
222    * @return A uint256 specifing the amount of tokens still avaible for the spender.
223    */
224   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
225     return allowed[_owner][_spender];
226   }
227 
228 }
229 
230 /**
231  * @title SimpleToken
232  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
233  * Note they can later distribute these tokens as they wish using `transfer` and other
234  * `StandardToken` functions.
235  */
236 contract AssetToken is Pausable, StandardToken {
237 
238   using SafeMath for uint256;
239 
240   address public treasurer = 0x0;
241 
242   uint256 public purchasableTokens = 0;
243 
244   string public name = "Asset Token";
245   string public symbol = "AST";
246   uint256 public decimals = 18;
247   uint256 public INITIAL_SUPPLY = 1000000000 * 10**18;
248 
249   uint256 public RATE = 200;
250 
251   /**
252    * @dev Contructor that gives msg.sender all of existing tokens.
253    */
254   function AssetToken() {
255     totalSupply = INITIAL_SUPPLY;
256     balances[msg.sender] = INITIAL_SUPPLY;
257   }
258 
259   /**
260    * @dev Allows the current owner to transfer control of the contract to a newOwner.
261    * @param newOwner The address to transfer ownership to.
262    */
263   function transferOwnership(address newOwner) onlyOwner {
264     address oldOwner = owner;
265     super.transferOwnership(newOwner);
266     balances[newOwner] = balances[oldOwner];
267     balances[oldOwner] = 0;
268   }
269 
270   /**
271    * @dev Allows the current owner to transfer treasurership of the contract to a newTreasurer.
272    * @param newTreasurer The address to transfer treasurership to.
273    */
274   function transferTreasurership(address newTreasurer) onlyOwner {
275     if (newTreasurer != address(0)) {
276       treasurer = newTreasurer;
277     }
278   }
279 
280   /**
281    * @dev Allows owner to release tokens for purchase
282    * @param amount The number of tokens to release
283    */
284   function setPurchasable(uint256 amount) onlyOwner {
285     require(amount > 0);
286     require(balances[owner] >= amount);
287     purchasableTokens = amount.mul(10**18);
288   }
289   
290   /**
291    * @dev Allows owner to change the rate Tokens per 1 Ether
292    * @param rate The number of tokens to release
293    */
294   function setRate(uint256 rate) onlyOwner {
295       RATE = rate;
296   }
297 
298   /**
299    * @dev fallback function
300    */
301   function () payable {
302     buyTokens(msg.sender);
303   }
304 
305   /**
306    * @dev function that sells available tokens
307    */
308   function buyTokens(address addr) payable whenNotPaused {
309     require(treasurer != 0x0); // Must have a treasurer
310 
311     // Calculate tokens to sell and check that they are purchasable
312     uint256 weiAmount = msg.value;
313     uint256 tokens = weiAmount.mul(RATE);
314     require(purchasableTokens >= tokens);
315 
316     // Send tokens to buyer
317     purchasableTokens = purchasableTokens.sub(tokens);
318     balances[owner] = balances[owner].sub(tokens);
319     balances[addr] = balances[addr].add(tokens);
320 
321     Transfer(owner, addr, tokens);
322 
323     // Send money to the treasurer
324     treasurer.transfer(msg.value);
325   }
326 }