1 pragma solidity ^0.4.24;
2 /*
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  * Name : SUAPP (SUP)
6  * Decimals : 8
7  * TotalSupply : 100000000000
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
108 contract BurnableToken is BasicToken {
109 
110   event Burn(address indexed burner, uint256 value);
111 
112   /**
113    * @dev Burns a specific amount of tokens.
114    * @param _value The amount of token to be burned.
115    */
116   function burn(uint256 _value) public {
117     require(_value <= balances[msg.sender]);
118     // no need to require value <= totalSupply, since that would imply the
119     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
120 
121     address burner = msg.sender;
122     balances[burner] = balances[burner].sub(_value);
123     totalSupply_ = totalSupply_.sub(_value);
124     emit Burn(burner, _value);
125     emit Transfer(burner, address(0), _value);
126   }
127 }
128 
129 /**
130  * @title ERC20 interface
131  * @dev see https://github.com/ethereum/EIPs/issues/20
132  */
133 contract ERC20 is ERC20Basic {
134   function allowance(address owner, address spender) public view returns (uint256);
135   function transferFrom(address from, address to, uint256 value) public returns (bool);
136   function approve(address spender, uint256 value) public returns (bool);
137   event Approval(address indexed owner, address indexed spender, uint256 value);
138 }
139 
140 /**
141  * @title Standard ERC20 token
142  *
143  * @dev Implementation of the basic standard token.
144  * @dev https://github.com/ethereum/EIPs/issues/20
145  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
146  */
147 contract StandardToken is ERC20, BasicToken {
148 
149   mapping (address => mapping (address => uint256)) internal allowed;
150 
151 
152   /**
153    * @dev Transfer tokens from one address to another
154    * @param _from address The address which you want to send tokens from
155    * @param _to address The address which you want to transfer to
156    * @param _value uint256 the amount of tokens to be transferred
157    */
158   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
159     require(_to != address(0));
160     require(_value <= balances[_from]);
161     require(_value <= allowed[_from][msg.sender]);
162 
163     balances[_from] = balances[_from].sub(_value);
164     balances[_to] = balances[_to].add(_value);
165     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
166     Transfer(_from, _to, _value);
167     return true;
168   }
169 
170   /**
171    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
172    *
173    * Beware that changing an allowance with this method brings the risk that someone may use both the old
174    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
175    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
176    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177    * @param _spender The address which will spend the funds.
178    * @param _value The amount of tokens to be spent.
179    */
180   function approve(address _spender, uint256 _value) public returns (bool) {
181     allowed[msg.sender][_spender] = _value;
182     Approval(msg.sender, _spender, _value);
183     return true;
184   }
185 
186   /**
187   * @dev saveAprrove to fix the approve race condition
188   * @param _spender The address which will spend the funds.
189   * @param _currentValue The actual amount of tokens that the _spender can spend.
190   * @param _value The amount of tokens to be spent.
191   *
192   * There is not a simple and most important, a backwards compatible way to fix the race condition issue on the approve function.
193   * There is a large and unfinished discussion on the community https://github.com/ethereum/EIPs/issues/738
194   * about this issue and the "best" aproach is add a safeApprove function to validate the amount/value
195   * and leave the approve function as is to complind the ERC-20 standard
196   *
197   */
198   function safeApprove(address _spender, uint256 _currentValue, uint256 _value) public returns (bool success) {
199     if (allowed[msg.sender][_spender] == _currentValue) {
200       return approve(_spender, _value);
201     }
202 
203     return false;
204   }
205 
206   /**
207    * @dev Function to check the amount of tokens that an owner allowed to a spender.
208    * @param _owner address The address which owns the funds.
209    * @param _spender address The address which will spend the funds.
210    * @return A uint256 specifying the amount of tokens still available for the spender.
211    */
212   function allowance(address _owner, address _spender) public view returns (uint256) {
213     return allowed[_owner][_spender];
214   }
215 
216   /**
217    * @dev Increase the amount of tokens that an owner allowed to a spender.
218    *
219    * approve should be called when allowed[_spender] == 0. To increment
220    * allowed value is better to use this function to avoid 2 calls (and wait until
221    * the first transaction is mined)
222    * From MonolithDAO Token.sol
223    * @param _spender The address which will spend the funds.
224    * @param _addedValue The amount of tokens to increase the allowance by.
225    */
226   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
227     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
228     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229     return true;
230   }
231 
232   /**
233    * @dev Decrease the amount of tokens that an owner allowed to a spender.
234    *
235    * approve should be called when allowed[_spender] == 0. To decrement
236    * allowed value is better to use this function to avoid 2 calls (and wait until
237    * the first transaction is mined)
238    * From MonolithDAO Token.sol
239    * @param _spender The address which will spend the funds.
240    * @param _subtractedValue The amount of tokens to decrease the allowance by.
241    */
242   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
243     uint oldValue = allowed[msg.sender][_spender];
244     if (_subtractedValue > oldValue) {
245       allowed[msg.sender][_spender] = 0;
246     } else {
247       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
248     }
249     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250     return true;
251   }
252 
253 }
254 
255 /**
256  * @title Ownable
257  * @dev The Ownable contract has an owner address, and provides basic authorization control
258  * functions, this simplifies the implementation of "user permissions".
259  */
260 contract Ownable {
261   address public owner;
262 
263 
264   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
265 
266 
267   /**
268    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
269    * account.
270    */
271   function Ownable() public {
272     owner = msg.sender;
273   }
274 
275   /**
276    * @dev Throws if called by any account other than the owner.
277    */
278   modifier onlyOwner() {
279     require(msg.sender == owner);
280     _;
281   }
282 
283   /**
284    * @dev Allows the current owner to transfer control of the contract to a newOwner.
285    * @param newOwner The address to transfer ownership to.
286    */
287   function transferOwnership(address newOwner) public onlyOwner {
288     require(newOwner != address(0));
289     OwnershipTransferred(owner, newOwner);
290     owner = newOwner;
291   }
292 
293 }
294 
295 /**
296  * @title SafeERC20
297  * @dev Wrappers around ERC20 operations that throw on failure.
298  * To use this library you can add a ` ` statement to your contract,
299  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
300  */
301 library SafeERC20 {
302   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
303     assert(token.transfer(to, value));
304   }
305 
306   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
307     assert(token.transferFrom(from, to, value));
308   }
309 
310   function safeApprove(ERC20 token, address spender, uint256 value) internal {
311     assert(token.approve(spender, value));
312   }
313 }
314 
315 /**
316  * @title Contracts that should be able to recover tokens
317  * @author SylTi
318  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
319  * This will prevent any accidental loss of tokens.
320  */
321 contract CanReclaimToken is Ownable {
322   using SafeERC20 for ERC20Basic;
323 
324   /**
325    * @dev Reclaim all ERC20Basic compatible tokens
326    * @param token ERC20Basic The address of the token contract
327    */
328   function reclaimToken(ERC20Basic token) external onlyOwner {
329     uint256 balance = token.balanceOf(this);
330     token.safeTransfer(owner, balance);
331   }
332 
333 }
334 
335 contract SUAPPToken is StandardToken, Ownable, CanReclaimToken {
336 
337   string public name = "SUAPP";
338   string public symbol = "SUP";
339   uint8 public decimals = 8;
340   uint256 public INITIAL_SUPPLY = 100 * (10**9) * 10**8;
341 
342   /**
343    * @dev Initialize the contract with the INITIAL_SUPPLY value and it assigns the amount to the contract creator address
344    *
345    * Trigger an Transfer event on token creation
346    * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
347    */
348   function SUAPPToken() public {
349     totalSupply_ = INITIAL_SUPPLY;
350     balances[msg.sender] = INITIAL_SUPPLY;
351     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
352   }
353 
354 }