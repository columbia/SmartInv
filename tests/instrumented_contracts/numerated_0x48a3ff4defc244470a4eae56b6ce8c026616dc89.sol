1 pragma solidity ^0.4.21;
2 
3 // File: C:/Users/cry888biz/project/wpc/node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 /**
46  * @title Pausable
47  * @dev Base contract which allows children to implement an emergency stop mechanism.
48  */
49 contract Pausable is Ownable {
50   event Pause();
51   event Unpause();
52 
53   bool public paused = false;
54 
55 
56   /**
57    * @dev Modifier to make a function callable only when the contract is not paused.
58    */
59   modifier whenNotPaused() {
60     require(!paused);
61     _;
62   }
63 
64   /**
65    * @dev Modifier to make a function callable only when the contract is paused.
66    */
67   modifier whenPaused() {
68     require(paused);
69     _;
70   }
71 
72   /**
73    * @dev called by the owner to pause, triggers stopped state
74    */
75   function pause() onlyOwner whenNotPaused public {
76     paused = true;
77     emit Pause();
78   }
79 
80   /**
81    * @dev called by the owner to unpause, returns to normal state
82    */
83   function unpause() onlyOwner whenPaused public {
84     paused = false;
85     emit Unpause();
86   }
87 }
88 
89 /**
90  * @title ERC20Basic
91  * @dev Simpler version of ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/179
93  */
94 contract ERC20Basic {
95   function totalSupply() public view returns (uint256);
96   function balanceOf(address who) public view returns (uint256);
97   function transfer(address to, uint256 value) public returns (bool);
98   event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 // File: C:/Users/cry888biz/project/wpc/node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
102 
103 /**
104  * @title SafeMath
105  * @dev Math operations with safety checks that throw on error
106  */
107 library SafeMath {
108 
109   /**
110   * @dev Multiplies two numbers, throws on overflow.
111   */
112   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
113     if (a == 0) {
114       return 0;
115     }
116     c = a * b;
117     assert(c / a == b);
118     return c;
119   }
120 
121   /**
122   * @dev Integer division of two numbers, truncating the quotient.
123   */
124   function div(uint256 a, uint256 b) internal pure returns (uint256) {
125     // assert(b > 0); // Solidity automatically throws when dividing by 0
126     // uint256 c = a / b;
127     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
128     return a / b;
129   }
130 
131   /**
132   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
133   */
134   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135     assert(b <= a);
136     return a - b;
137   }
138 
139   /**
140   * @dev Adds two numbers, throws on overflow.
141   */
142   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
143     c = a + b;
144     assert(c >= a);
145     return c;
146   }
147 }
148 
149 // File: C:/Users/cry888biz/project/wpc/node_modules/zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
150 
151 /**
152  * @title Basic token
153  * @dev Basic version of StandardToken, with no allowances.
154  */
155 contract BasicToken is ERC20Basic {
156   using SafeMath for uint256;
157 
158   mapping(address => uint256) balances;
159 
160   uint256 totalSupply_;
161 
162   /**
163   * @dev total number of tokens in existence
164   */
165   function totalSupply() public view returns (uint256) {
166     return totalSupply_;
167   }
168 
169   /**
170   * @dev transfer token for a specified address
171   * @param _to The address to transfer to.
172   * @param _value The amount to be transferred.
173   */
174   function transfer(address _to, uint256 _value) public returns (bool) {
175     require(_to != address(0));
176     require(_value <= balances[msg.sender]);
177 
178     balances[msg.sender] = balances[msg.sender].sub(_value);
179     balances[_to] = balances[_to].add(_value);
180     emit Transfer(msg.sender, _to, _value);
181     return true;
182   }
183 
184   /**
185   * @dev Gets the balance of the specified address.
186   * @param _owner The address to query the the balance of.
187   * @return An uint256 representing the amount owned by the passed address.
188   */
189   function balanceOf(address _owner) public view returns (uint256) {
190     return balances[_owner];
191   }
192 
193 }
194 
195 /**
196  * @title Burnable Token
197  * @dev Token that can be irreversibly burned (destroyed).
198  */
199 contract BurnableToken is BasicToken {
200 
201   event Burn(address indexed burner, uint256 value);
202 
203   /**
204    * @dev Burns a specific amount of tokens.
205    * @param _value The amount of token to be burned.
206    */
207   function burn(uint256 _value) public {
208     _burn(msg.sender, _value);
209   }
210 
211   function _burn(address _who, uint256 _value) internal {
212     require(_value <= balances[_who]);
213     // no need to require value <= totalSupply, since that would imply the
214     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
215 
216     balances[_who] = balances[_who].sub(_value);
217     totalSupply_ = totalSupply_.sub(_value);
218     emit Burn(_who, _value);
219     emit Transfer(_who, address(0), _value);
220   }
221 }
222 
223 // File: C:/Users/cry888biz/project/wpc/node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20.sol
224 
225 /**
226  * @title ERC20 interface
227  * @dev see https://github.com/ethereum/EIPs/issues/20
228  */
229 contract ERC20 is ERC20Basic {
230   function allowance(address owner, address spender) public view returns (uint256);
231   function transferFrom(address from, address to, uint256 value) public returns (bool);
232   function approve(address spender, uint256 value) public returns (bool);
233   event Approval(address indexed owner, address indexed spender, uint256 value);
234 }
235 
236 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
237 
238 /**
239  * @title Standard ERC20 token
240  *
241  * @dev Implementation of the basic standard token.
242  * @dev https://github.com/ethereum/EIPs/issues/20
243  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
244  */
245 contract StandardToken is ERC20, BasicToken {
246 
247   mapping (address => mapping (address => uint256)) internal allowed;
248 
249 
250   /**
251    * @dev Transfer tokens from one address to another
252    * @param _from address The address which you want to send tokens from
253    * @param _to address The address which you want to transfer to
254    * @param _value uint256 the amount of tokens to be transferred
255    */
256   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
257     require(_to != address(0));
258     require(_value <= balances[_from]);
259     require(_value <= allowed[_from][msg.sender]);
260 
261     balances[_from] = balances[_from].sub(_value);
262     balances[_to] = balances[_to].add(_value);
263     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
264     emit Transfer(_from, _to, _value);
265     return true;
266   }
267 
268   /**
269    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
270    *
271    * Beware that changing an allowance with this method brings the risk that someone may use both the old
272    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
273    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
274    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
275    * @param _spender The address which will spend the funds.
276    * @param _value The amount of tokens to be spent.
277    */
278   function approve(address _spender, uint256 _value) public returns (bool) {
279     allowed[msg.sender][_spender] = _value;
280     emit Approval(msg.sender, _spender, _value);
281     return true;
282   }
283 
284   /**
285    * @dev Function to check the amount of tokens that an owner allowed to a spender.
286    * @param _owner address The address which owns the funds.
287    * @param _spender address The address which will spend the funds.
288    * @return A uint256 specifying the amount of tokens still available for the spender.
289    */
290   function allowance(address _owner, address _spender) public view returns (uint256) {
291     return allowed[_owner][_spender];
292   }
293 
294   /**
295    * @dev Increase the amount of tokens that an owner allowed to a spender.
296    *
297    * approve should be called when allowed[_spender] == 0. To increment
298    * allowed value is better to use this function to avoid 2 calls (and wait until
299    * the first transaction is mined)
300    * From MonolithDAO Token.sol
301    * @param _spender The address which will spend the funds.
302    * @param _addedValue The amount of tokens to increase the allowance by.
303    */
304   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
305     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
306     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
307     return true;
308   }
309 
310   /**
311    * @dev Decrease the amount of tokens that an owner allowed to a spender.
312    *
313    * approve should be called when allowed[_spender] == 0. To decrement
314    * allowed value is better to use this function to avoid 2 calls (and wait until
315    * the first transaction is mined)
316    * From MonolithDAO Token.sol
317    * @param _spender The address which will spend the funds.
318    * @param _subtractedValue The amount of tokens to decrease the allowance by.
319    */
320   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
321     uint oldValue = allowed[msg.sender][_spender];
322     if (_subtractedValue > oldValue) {
323       allowed[msg.sender][_spender] = 0;
324     } else {
325       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
326     }
327     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
328     return true;
329   }
330 
331 }
332 
333 /**
334  * @title Mintable token
335  * @dev Simple ERC20 Token example, with mintable token creation
336  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
337  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
338  */
339 contract MintableToken is StandardToken, Ownable {
340   event Mint(address indexed to, uint256 amount);
341   event MintFinished();
342 
343   bool public mintingFinished = false;
344 
345 
346   modifier canMint() {
347     require(!mintingFinished);
348     _;
349   }
350 
351   /**
352    * @dev Function to mint tokens
353    * @param _to The address that will receive the minted tokens.
354    * @param _amount The amount of tokens to mint.
355    * @return A boolean that indicates if the operation was successful.
356    */
357   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
358     totalSupply_ = totalSupply_.add(_amount);
359     balances[_to] = balances[_to].add(_amount);
360     emit Mint(_to, _amount);
361     emit Transfer(address(0), _to, _amount);
362     return true;
363   }
364 
365   /**
366    * @dev Function to stop minting new tokens.
367    * @return True if the operation was successful.
368    */
369   function finishMinting() onlyOwner canMint public returns (bool) {
370     mintingFinished = true;
371     emit MintFinished();
372     return true;
373   }
374 }
375 
376 // File: contracts\WpcToken.sol
377 
378 contract WpcToken is StandardToken {
379   string public name = "World Peace Coin";
380   string public symbol = "WPC";
381   uint public decimals = 18;
382 
383   function WpcToken(uint initialSupply) public {
384     totalSupply_ = initialSupply;
385     balances[msg.sender] = initialSupply;
386   }
387 }