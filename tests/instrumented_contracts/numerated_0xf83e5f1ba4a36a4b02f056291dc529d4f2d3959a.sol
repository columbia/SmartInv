1 pragma solidity ^0.4.24;
2 /*
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  * Name : SUAPP (SUT)
6  * Decimals : 8
7  * TotalSupply : 1 Billion
8  */
9 
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22 
23   /**
24   * @dev Multiplies two numbers, throws on overflow.
25   */
26   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27     if (a == 0) {
28       return 0;
29     }
30     uint256 c = a * b;
31     assert(c / a == b);
32     return c;
33   }
34 
35   /**
36   * @dev Integer division of two numbers, truncating the quotient.
37   */
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   /**
46   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
47   */
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   /**
54   * @dev Adds two numbers, throws on overflow.
55   */
56   function add(uint256 a, uint256 b) internal pure returns (uint256) {
57     uint256 c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 /**
64  * @title Basic token
65  * @dev Basic version of StandardToken, with no allowances.
66  */
67 contract BasicToken is ERC20Basic {
68   using SafeMath for uint256;
69 
70   mapping(address => uint256) balances;
71 
72   uint256 totalSupply_;
73 
74   /**
75   * @dev total number of tokens in existence
76   */
77   function totalSupply() public view returns (uint256) {
78     return totalSupply_;
79   }
80 
81   /**
82   * @dev transfer token for a specified address
83   * @param _to The address to transfer to.
84   * @param _value The amount to be transferred.
85   */
86   function transfer(address _to, uint256 _value) public returns (bool) {
87     require(_to != address(0));
88     require(_value <= balances[msg.sender]);
89 
90     // SafeMath.sub will throw if there is not enough balance.
91     balances[msg.sender] = balances[msg.sender].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     Transfer(msg.sender, _to, _value);
94     return true;
95   }
96 
97   /**
98   * @dev Gets the balance of the specified address.
99   * @param _owner The address to query the the balance of.
100   * @return An uint256 representing the amount owned by the passed address.
101   */
102   function balanceOf(address _owner) public view returns (uint256 balance) {
103     return balances[_owner];
104   }
105 
106 }
107 
108 /**
109  * @title ERC20 interface
110  * @dev see https://github.com/ethereum/EIPs/issues/20
111  */
112 contract ERC20 is ERC20Basic {
113   function allowance(address owner, address spender) public view returns (uint256);
114   function transferFrom(address from, address to, uint256 value) public returns (bool);
115   function approve(address spender, uint256 value) public returns (bool);
116   event Approval(address indexed owner, address indexed spender, uint256 value);
117 }
118 
119 /**
120  * @title Standard ERC20 token
121  *
122  * @dev Implementation of the basic standard token.
123  * @dev https://github.com/ethereum/EIPs/issues/20
124  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
125  */
126 contract StandardToken is ERC20, BasicToken {
127 
128   mapping (address => mapping (address => uint256)) internal allowed;
129 
130 
131   /**
132    * @dev Transfer tokens from one address to another
133    * @param _from address The address which you want to send tokens from
134    * @param _to address The address which you want to transfer to
135    * @param _value uint256 the amount of tokens to be transferred
136    */
137   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
138     require(_to != address(0));
139     require(_value <= balances[_from]);
140     require(_value <= allowed[_from][msg.sender]);
141 
142     balances[_from] = balances[_from].sub(_value);
143     balances[_to] = balances[_to].add(_value);
144     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
145     Transfer(_from, _to, _value);
146     return true;
147   }
148 
149   /**
150    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
151    *
152    * Beware that changing an allowance with this method brings the risk that someone may use both the old
153    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
154    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
155    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156    * @param _spender The address which will spend the funds.
157    * @param _value The amount of tokens to be spent.
158    */
159   function approve(address _spender, uint256 _value) public returns (bool) {
160     allowed[msg.sender][_spender] = _value;
161     Approval(msg.sender, _spender, _value);
162     return true;
163   }
164 
165   /**
166   * @dev saveAprrove to fix the approve race condition
167   * @param _spender The address which will spend the funds.
168   * @param _currentValue The actual amount of tokens that the _spender can spend.
169   * @param _value The amount of tokens to be spent.
170   *
171   * There is not a simple and most important, a backwards compatible way to fix the race condition issue on the approve function.
172   * There is a large and unfinished discussion on the community https://github.com/ethereum/EIPs/issues/738
173   * about this issue and the "best" aproach is add a safeApprove function to validate the amount/value
174   * and leave the approve function as is to complind the ERC-20 standard
175   *
176   */
177   function safeApprove(address _spender, uint256 _currentValue, uint256 _value) public returns (bool success) {
178     if (allowed[msg.sender][_spender] == _currentValue) {
179       return approve(_spender, _value);
180     }
181 
182     return false;
183   }
184 
185   /**
186    * @dev Function to check the amount of tokens that an owner allowed to a spender.
187    * @param _owner address The address which owns the funds.
188    * @param _spender address The address which will spend the funds.
189    * @return A uint256 specifying the amount of tokens still available for the spender.
190    */
191   function allowance(address _owner, address _spender) public view returns (uint256) {
192     return allowed[_owner][_spender];
193   }
194 
195   /**
196    * @dev Increase the amount of tokens that an owner allowed to a spender.
197    *
198    * approve should be called when allowed[_spender] == 0. To increment
199    * allowed value is better to use this function to avoid 2 calls (and wait until
200    * the first transaction is mined)
201    * From MonolithDAO Token.sol
202    * @param _spender The address which will spend the funds.
203    * @param _addedValue The amount of tokens to increase the allowance by.
204    */
205   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
206     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
207     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208     return true;
209   }
210 
211   /**
212    * @dev Decrease the amount of tokens that an owner allowed to a spender.
213    *
214    * approve should be called when allowed[_spender] == 0. To decrement
215    * allowed value is better to use this function to avoid 2 calls (and wait until
216    * the first transaction is mined)
217    * From MonolithDAO Token.sol
218    * @param _spender The address which will spend the funds.
219    * @param _subtractedValue The amount of tokens to decrease the allowance by.
220    */
221   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
222     uint oldValue = allowed[msg.sender][_spender];
223     if (_subtractedValue > oldValue) {
224       allowed[msg.sender][_spender] = 0;
225     } else {
226       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
227     }
228     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229     return true;
230   }
231 
232 }
233 
234 /**
235  * @title Ownable
236  * @dev The Ownable contract has an owner address, and provides basic authorization control
237  * functions, this simplifies the implementation of "user permissions".
238  */
239 contract Ownable {
240   address public owner;
241 
242 
243   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
244 
245 
246   /**
247    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
248    * account.
249    */
250   function Ownable() public {
251     owner = msg.sender;
252   }
253 
254   /**
255    * @dev Throws if called by any account other than the owner.
256    */
257   modifier onlyOwner() {
258     require(msg.sender == owner);
259     _;
260   }
261 
262   /**
263    * @dev Allows the current owner to transfer control of the contract to a newOwner.
264    * @param newOwner The address to transfer ownership to.
265    */
266   function transferOwnership(address newOwner) public onlyOwner {
267     require(newOwner != address(0));
268     OwnershipTransferred(owner, newOwner);
269     owner = newOwner;
270   }
271 
272 }
273 
274 /**
275  * @title SafeERC20
276  * @dev Wrappers around ERC20 operations that throw on failure.
277  * To use this library you can add a ` ` statement to your contract,
278  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
279  */
280 library SafeERC20 {
281   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
282     assert(token.transfer(to, value));
283   }
284 
285   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
286     assert(token.transferFrom(from, to, value));
287   }
288 
289   function safeApprove(ERC20 token, address spender, uint256 value) internal {
290     assert(token.approve(spender, value));
291   }
292 }
293 
294 /**
295  * @title Contracts that should be able to recover tokens
296  * @author SylTi
297  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
298  * This will prevent any accidental loss of tokens.
299  */
300 contract CanReclaimToken is Ownable {
301   using SafeERC20 for ERC20Basic;
302 
303   /**
304    * @dev Reclaim all ERC20Basic compatible tokens
305    * @param token ERC20Basic The address of the token contract
306    */
307   function reclaimToken(ERC20Basic token) external onlyOwner {
308     uint256 balance = token.balanceOf(this);
309     token.safeTransfer(owner, balance);
310   }
311 
312 }
313 
314 contract SUAPPToken is StandardToken, Ownable, CanReclaimToken {
315 
316   string public name = "SUAPP";
317   string public symbol = "SUT";
318   uint8 public decimals = 8;
319   uint256 public INITIAL_SUPPLY = 1 * (10**9) * 10**8;
320 
321   /**
322    * @dev Initialize the contract with the INITIAL_SUPPLY value and it assigns the amount to the contract creator address
323    *
324    * Trigger an Transfer event on token creation
325    * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
326    */
327   function SUAPPToken() public {
328     totalSupply_ = INITIAL_SUPPLY;
329     balances[msg.sender] = INITIAL_SUPPLY;
330     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
331   }
332 
333 }