1 pragma solidity 0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56   function totalSupply() public view returns (uint256);
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 
63 
64 /**
65  * @title ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/20
67  */
68 contract ERC20 is ERC20Basic {
69   function allowance(address owner, address spender) public view returns (uint256);
70   function transferFrom(address from, address to, uint256 value) public returns (bool);
71   function approve(address spender, uint256 value) public returns (bool);
72   event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 
76 /**
77  * @title Basic token
78  * @dev Basic version of StandardToken, with no allowances.
79  */
80 contract BasicToken is ERC20Basic {
81   using SafeMath for uint256;
82 
83   mapping(address => uint256) balances;
84 
85   uint256 totalSupply_;
86 
87   /**
88   * @dev total number of tokens in existence
89   */
90   function totalSupply() public view returns (uint256) {
91     return totalSupply_;
92   }
93 
94   /**
95   * @dev transfer token for a specified address
96   * @param _to The address to transfer to.
97   * @param _value The amount to be transferred.
98   */
99   function transfer(address _to, uint256 _value) public returns (bool) {
100     require(_to != address(0));
101     require(_value <= balances[msg.sender]);
102 
103     balances[msg.sender] = balances[msg.sender].sub(_value);
104     balances[_to] = balances[_to].add(_value);
105     emit Transfer(msg.sender, _to, _value);
106     return true;
107   }
108 
109   /**
110   * @dev Gets the balance of the specified address.
111   * @param _owner The address to query the the balance of.
112   * @return An uint256 representing the amount owned by the passed address.
113   */
114   function balanceOf(address _owner) public view returns (uint256) {
115     return balances[_owner];
116   }
117 
118 }
119 
120 
121 /**
122  * @title Burnable Token
123  * @dev Token that can be irreversibly burned (destroyed).
124  */
125 contract BurnableToken is BasicToken {
126 
127   event Burn(address indexed burner, uint256 value);
128 
129   /**
130    * @dev Burns a specific amount of tokens.
131    * @param _value The amount of token to be burned.
132    */
133   function burn(uint256 _value) public {
134     _burn(msg.sender, _value);
135   }
136 
137   function _burn(address _who, uint256 _value) internal {
138     require(_value <= balances[_who]);
139     // no need to require value <= totalSupply, since that would imply the
140     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
141 
142     balances[_who] = balances[_who].sub(_value);
143     totalSupply_ = totalSupply_.sub(_value);
144     emit Burn(_who, _value);
145     emit Transfer(_who, address(0), _value);
146   }
147 }
148 
149 
150 /**
151  * @title Standard ERC20 token
152  *
153  * @dev Implementation of the basic standard token.
154  * @dev https://github.com/ethereum/EIPs/issues/20
155  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
156  */
157 contract StandardToken is ERC20, BasicToken {
158 
159   mapping (address => mapping (address => uint256)) internal allowed;
160 
161 
162   /**
163    * @dev Transfer tokens from one address to another
164    * @param _from address The address which you want to send tokens from
165    * @param _to address The address which you want to transfer to
166    * @param _value uint256 the amount of tokens to be transferred
167    */
168   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
169     require(_to != address(0));
170     require(_value <= balances[_from]);
171     require(_value <= allowed[_from][msg.sender]);
172 
173     balances[_from] = balances[_from].sub(_value);
174     balances[_to] = balances[_to].add(_value);
175     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
176     emit Transfer(_from, _to, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
182    *
183    * Beware that changing an allowance with this method brings the risk that someone may use both the old
184    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
185    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
186    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
187    * @param _spender The address which will spend the funds.
188    * @param _value The amount of tokens to be spent.
189    */
190   function approve(address _spender, uint256 _value) public returns (bool) {
191     allowed[msg.sender][_spender] = _value;
192     emit Approval(msg.sender, _spender, _value);
193     return true;
194   }
195 
196   /**
197    * @dev Function to check the amount of tokens that an owner allowed to a spender.
198    * @param _owner address The address which owns the funds.
199    * @param _spender address The address which will spend the funds.
200    * @return A uint256 specifying the amount of tokens still available for the spender.
201    */
202   function allowance(address _owner, address _spender) public view returns (uint256) {
203     return allowed[_owner][_spender];
204   }
205 
206   /**
207    * @dev Increase the amount of tokens that an owner allowed to a spender.
208    *
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
217     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
218     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
219     return true;
220   }
221 
222   /**
223    * @dev Decrease the amount of tokens that an owner allowed to a spender.
224    *
225    * approve should be called when allowed[_spender] == 0. To decrement
226    * allowed value is better to use this function to avoid 2 calls (and wait until
227    * the first transaction is mined)
228    * From MonolithDAO Token.sol
229    * @param _spender The address which will spend the funds.
230    * @param _subtractedValue The amount of tokens to decrease the allowance by.
231    */
232   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
233     uint oldValue = allowed[msg.sender][_spender];
234     if (_subtractedValue > oldValue) {
235       allowed[msg.sender][_spender] = 0;
236     } else {
237       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
238     }
239     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
240     return true;
241   }
242 
243 }
244 
245 
246 /**
247  * @title Ownable
248  * @dev The Ownable contract has an owner address, and provides basic authorization control
249  * functions, this simplifies the implementation of "user permissions".
250  */
251 contract Ownable {
252   address public owner;
253 
254 
255   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
256 
257 
258   /**
259    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
260    * account.
261    */
262   constructor() public {
263     owner = msg.sender;
264   }
265 
266   /**
267    * @dev Throws if called by any account other than the owner.
268    */
269   modifier onlyOwner() {
270     require(msg.sender == owner);
271     _;
272   }
273 
274   /**
275    * @dev Allows the current owner to transfer control of the contract to a newOwner.
276    * @param newOwner The address to transfer ownership to.
277    */
278   function transferOwnership(address newOwner) public onlyOwner {
279     require(newOwner != address(0));
280     emit OwnershipTransferred(owner, newOwner);
281     owner = newOwner;
282   }
283 
284 }
285 
286 
287 /**
288  * @title Claimable
289  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
290  * This allows the new owner to accept the transfer.
291  */
292 contract Claimable is Ownable {
293   address public pendingOwner;
294 
295   /**
296    * @dev Modifier throws if called by any account other than the pendingOwner.
297    */
298   modifier onlyPendingOwner() {
299     require(msg.sender == pendingOwner);
300     _;
301   }
302 
303   /**
304    * @dev Allows the current owner to set the pendingOwner address.
305    * @param newOwner The address to transfer ownership to.
306    */
307   function transferOwnership(address newOwner) onlyOwner public {
308     pendingOwner = newOwner;
309   }
310 
311   /**
312    * @dev Allows the pendingOwner address to finalize the transfer.
313    */
314   function claimOwnership() onlyPendingOwner public {
315     emit OwnershipTransferred(owner, pendingOwner);
316     owner = pendingOwner;
317     pendingOwner = address(0);
318   }
319 }
320 
321 
322 
323 /**
324  * @title Pausable
325  * @dev Base contract which allows children to implement an emergency stop mechanism.
326  */
327 contract Pausable is Ownable {
328   event Pause();
329   event Unpause();
330 
331   bool public paused = false;
332 
333 
334   /**
335    * @dev Modifier to make a function callable only when the contract is not paused.
336    */
337   modifier whenNotPaused() {
338     require(!paused);
339     _;
340   }
341 
342   /**
343    * @dev Modifier to make a function callable only when the contract is paused.
344    */
345   modifier whenPaused() {
346     require(paused);
347     _;
348   }
349 
350   /**
351    * @dev called by the owner to pause, triggers stopped state
352    */
353   function pause() onlyOwner whenNotPaused public {
354     paused = true;
355     emit Pause();
356   }
357 
358   /**
359    * @dev called by the owner to unpause, returns to normal state
360    */
361   function unpause() onlyOwner whenPaused public {
362     paused = false;
363     emit Unpause();
364   }
365 }
366 
367 
368 contract PausableToken is StandardToken, BurnableToken, Claimable, Pausable {
369     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
370     	return super.transfer(_to, _value);
371     }
372 
373     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
374     	return super.transferFrom(_from, _to, _value);
375     }
376 
377     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
378     	return super.approve(_spender, _value);
379     }
380 
381     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
382       return super.increaseApproval(_spender, _addedValue);
383     }
384 
385     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
386       return super.decreaseApproval(_spender, _subtractedValue);
387     }
388 }
389 
390 
391 contract YBToken is PausableToken {
392 	string public name    = "YBToken";
393 	string public symbol  = "YBT";
394 	uint8 public decimals = 8;
395 
396 	// 1.0 billion in initial supply
397 	uint256 public constant INITIAL_SUPPLY = 1000000000;
398 
399 	constructor() public {
400 		totalSupply_ = INITIAL_SUPPLY * (10 ** uint256(decimals));
401 		balances[msg.sender] = totalSupply_;
402 	}
403 
404 }