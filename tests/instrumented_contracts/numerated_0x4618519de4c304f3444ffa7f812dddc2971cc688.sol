1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25     if (a == 0) {
26       return 0;
27     }
28     uint256 c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return c;
41   }
42 
43   /**
44   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45   */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   /**
52   * @dev Adds two numbers, throws on overflow.
53   */
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances.
64  */
65 contract BasicToken is ERC20Basic {
66   using SafeMath for uint256;
67 
68   mapping(address => uint256) balances;
69 
70   uint256 totalSupply_;
71 
72   /**
73   * @dev total number of tokens in existence
74   */
75   function totalSupply() public view returns (uint256) {
76     return totalSupply_;
77   }
78 
79   /**
80   * @dev transfer token for a specified address
81   * @param _to The address to transfer to.
82   * @param _value The amount to be transferred.
83   */
84   function transfer(address _to, uint256 _value) public returns (bool) {
85     require(_to != address(0));
86     require(_value <= balances[msg.sender]);
87 
88     // SafeMath.sub will throw if there is not enough balance.
89     balances[msg.sender] = balances[msg.sender].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     Transfer(msg.sender, _to, _value);
92     return true;
93   }
94 
95   /**
96   * @dev Gets the balance of the specified address.
97   * @param _owner The address to query the the balance of.
98   * @return An uint256 representing the amount owned by the passed address.
99   */
100   function balanceOf(address _owner) public view returns (uint256 balance) {
101     return balances[_owner];
102   }
103 
104 }
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111   function allowance(address owner, address spender) public view returns (uint256);
112   function transferFrom(address from, address to, uint256 value) public returns (bool);
113   function approve(address spender, uint256 value) public returns (bool);
114   event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * @dev https://github.com/ethereum/EIPs/issues/20
122  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
123  */
124 contract StandardToken is ERC20, BasicToken {
125 
126   mapping (address => mapping (address => uint256)) internal allowed;
127 
128 
129   /**
130    * @dev Transfer tokens from one address to another
131    * @param _from address The address which you want to send tokens from
132    * @param _to address The address which you want to transfer to
133    * @param _value uint256 the amount of tokens to be transferred
134    */
135   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
136     require(_to != address(0));
137     require(_value <= balances[_from]);
138     require(_value <= allowed[_from][msg.sender]);
139 
140     balances[_from] = balances[_from].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143     Transfer(_from, _to, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149    *
150    * Beware that changing an allowance with this method brings the risk that someone may use both the old
151    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
152    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
153    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154    * @param _spender The address which will spend the funds.
155    * @param _value The amount of tokens to be spent.
156    */
157   function approve(address _spender, uint256 _value) public returns (bool) {
158     allowed[msg.sender][_spender] = _value;
159     Approval(msg.sender, _spender, _value);
160     return true;
161   }
162 
163   /**
164   * @dev saveAprrove to fix the approve race condition
165   * @param _spender The address which will spend the funds.
166   * @param _currentValue The actual amount of tokens that the _spender can spend.
167   * @param _value The amount of tokens to be spent.
168   *
169   * There is not a simple and most important, a backwards compatible way to fix the race condition issue on the approve function.
170   * There is a large and unfinished discussion on the community https://github.com/ethereum/EIPs/issues/738
171   * about this issue and the "best" aproach is add a safeApprove function to validate the amount/value
172   * and leave the approve function as is to complind the ERC-20 standard
173   *
174   */
175   function safeApprove(address _spender, uint256 _currentValue, uint256 _value) public returns (bool success) {
176     if (allowed[msg.sender][_spender] == _currentValue) {
177       return approve(_spender, _value);
178     }
179 
180     return false;
181   }
182 
183   /**
184    * @dev Function to check the amount of tokens that an owner allowed to a spender.
185    * @param _owner address The address which owns the funds.
186    * @param _spender address The address which will spend the funds.
187    * @return A uint256 specifying the amount of tokens still available for the spender.
188    */
189   function allowance(address _owner, address _spender) public view returns (uint256) {
190     return allowed[_owner][_spender];
191   }
192 
193   /**
194    * @dev Increase the amount of tokens that an owner allowed to a spender.
195    *
196    * approve should be called when allowed[_spender] == 0. To increment
197    * allowed value is better to use this function to avoid 2 calls (and wait until
198    * the first transaction is mined)
199    * From MonolithDAO Token.sol
200    * @param _spender The address which will spend the funds.
201    * @param _addedValue The amount of tokens to increase the allowance by.
202    */
203   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
204     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
205     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206     return true;
207   }
208 
209   /**
210    * @dev Decrease the amount of tokens that an owner allowed to a spender.
211    *
212    * approve should be called when allowed[_spender] == 0. To decrement
213    * allowed value is better to use this function to avoid 2 calls (and wait until
214    * the first transaction is mined)
215    * From MonolithDAO Token.sol
216    * @param _spender The address which will spend the funds.
217    * @param _subtractedValue The amount of tokens to decrease the allowance by.
218    */
219   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
220     uint oldValue = allowed[msg.sender][_spender];
221     if (_subtractedValue > oldValue) {
222       allowed[msg.sender][_spender] = 0;
223     } else {
224       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
225     }
226     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227     return true;
228   }
229 
230 }
231 
232 /**
233  * @title Ownable
234  * @dev The Ownable contract has an owner address, and provides basic authorization control
235  * functions, this simplifies the implementation of "user permissions".
236  */
237 contract Ownable {
238   address public owner;
239 
240 
241   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
242 
243 
244   /**
245    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
246    * account.
247    */
248   function Ownable() public {
249     owner = msg.sender;
250   }
251 
252   /**
253    * @dev Throws if called by any account other than the owner.
254    */
255   modifier onlyOwner() {
256     require(msg.sender == owner);
257     _;
258   }
259 
260   /**
261    * @dev Allows the current owner to transfer control of the contract to a newOwner.
262    * @param newOwner The address to transfer ownership to.
263    */
264   function transferOwnership(address newOwner) public onlyOwner {
265     require(newOwner != address(0));
266     OwnershipTransferred(owner, newOwner);
267     owner = newOwner;
268   }
269 
270 }
271 
272 /**
273  * @title SafeERC20
274  * @dev Wrappers around ERC20 operations that throw on failure.
275  * To use this library you can add a ` ` statement to your contract,
276  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
277  */
278 library SafeERC20 {
279   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
280     assert(token.transfer(to, value));
281   }
282 
283   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
284     assert(token.transferFrom(from, to, value));
285   }
286 
287   function safeApprove(ERC20 token, address spender, uint256 value) internal {
288     assert(token.approve(spender, value));
289   }
290 }
291 
292 /**
293  * @title Contracts that should be able to recover tokens
294  * @author SylTi
295  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
296  * This will prevent any accidental loss of tokens.
297  */
298 contract CanReclaimToken is Ownable {
299   using SafeERC20 for ERC20Basic;
300 
301   /**
302    * @dev Reclaim all ERC20Basic compatible tokens
303    * @param token ERC20Basic The address of the token contract
304    */
305   function reclaimToken(ERC20Basic token) external onlyOwner {
306     uint256 balance = token.balanceOf(this);
307     token.safeTransfer(owner, balance);
308   }
309 
310 }
311 
312 /**
313 * @title Kind Ads Token
314 * @dev ERC20 Kind Ads Token (KIND)
315 *
316 * KIND are displayed using 8 decimal places of precision
317 *
318 * 1 KIND is equal to:
319 *   -----------------------------
320 *   | Units               |KIND |
321 *   -----------------------------
322 *   | 100000000           |  1  |
323 *   | 1 * 10**8           |  1  |
324 *   | 1e8                 |  1  |
325 *   | 1e9                 | 10  |
326 *   -----------------------------
327 *
328 * All the initial KIND Tokens are assigned to the creator of this contract
329 *
330 */
331 
332 
333 contract KindAdsToken is StandardToken, Ownable, CanReclaimToken {
334 
335   string public name = "Kind Ads Token";
336   string public symbol = "KIND";
337   uint8 public decimals = 8;
338   uint256 public INITIAL_SUPPLY = 61 * (10**6) * 10**8;
339 
340   /**
341    * @dev Initialize the contract with the INITIAL_SUPPLY value and it assigns the amount to the contract creator address
342    *
343    * Trigger an Transfer event on token creation
344    * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
345    */
346   function KindAdsToken() public {
347     totalSupply_ = INITIAL_SUPPLY;
348     balances[msg.sender] = INITIAL_SUPPLY;
349     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
350   }
351 
352 }