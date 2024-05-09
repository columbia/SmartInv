1 pragma solidity ^0.4.18;
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
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
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
91     emit Transfer(msg.sender, _to, _value);
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
106 contract BurnableToken is BasicToken {
107 
108   event Burn(address indexed burner, uint256 value);
109 
110   /**
111    * @dev Burns a specific amount of tokens.
112    * @param _value The amount of token to be burned.
113    */
114   function burn(uint256 _value) public {
115     require(_value <= balances[msg.sender]);
116     // no need to require value <= totalSupply, since that would imply the
117     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
118 
119     address burner = msg.sender;
120     balances[burner] = balances[burner].sub(_value);
121     totalSupply_ = totalSupply_.sub(_value);
122     emit Burn(burner, _value);
123     emit Transfer(burner, address(0), _value);
124   }
125 }
126 
127 /**
128  * @title ERC20 interface
129  * @dev see https://github.com/ethereum/EIPs/issues/20
130  */
131 contract ERC20 is ERC20Basic {
132   function allowance(address owner, address spender) public view returns (uint256);
133   function transferFrom(address from, address to, uint256 value) public returns (bool);
134   function approve(address spender, uint256 value) public returns (bool);
135   event Approval(address indexed owner, address indexed spender, uint256 value);
136 }
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * @dev https://github.com/ethereum/EIPs/issues/20
143  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
157     require(_to != address(0));
158     require(_value <= balances[_from]);
159     require(_value <= allowed[_from][msg.sender]);
160 
161     balances[_from] = balances[_from].sub(_value);
162     balances[_to] = balances[_to].add(_value);
163     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
164     emit Transfer(_from, _to, _value);
165     return true;
166   }
167 
168   /**
169    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
170    *
171    * Beware that changing an allowance with this method brings the risk that someone may use both the old
172    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
173    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
174    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175    * @param _spender The address which will spend the funds.
176    * @param _value The amount of tokens to be spent.
177    */
178   function approve(address _spender, uint256 _value) public returns (bool) {
179     allowed[msg.sender][_spender] = _value;
180     emit Approval(msg.sender, _spender, _value);
181     return true;
182   }
183 
184   /**
185    * @dev Function to check the amount of tokens that an owner allowed to a spender.
186    * @param _owner address The address which owns the funds.
187    * @param _spender address The address which will spend the funds.
188    * @return A uint256 specifying the amount of tokens still available for the spender.
189    */
190   function allowance(address _owner, address _spender) public view returns (uint256) {
191     return allowed[_owner][_spender];
192   }
193 
194   /**
195    * @dev Increase the amount of tokens that an owner allowed to a spender.
196    *
197    * approve should be called when allowed[_spender] == 0. To increment
198    * allowed value is better to use this function to avoid 2 calls (and wait until
199    * the first transaction is mined)
200    * From MonolithDAO Token.sol
201    * @param _spender The address which will spend the funds.
202    * @param _addedValue The amount of tokens to increase the allowance by.
203    */
204   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
205     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
206     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207     return true;
208   }
209 
210   /**
211    * @dev Decrease the amount of tokens that an owner allowed to a spender.
212    *
213    * approve should be called when allowed[_spender] == 0. To decrement
214    * allowed value is better to use this function to avoid 2 calls (and wait until
215    * the first transaction is mined)
216    * From MonolithDAO Token.sol
217    * @param _spender The address which will spend the funds.
218    * @param _subtractedValue The amount of tokens to decrease the allowance by.
219    */
220   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
221     uint oldValue = allowed[msg.sender][_spender];
222     if (_subtractedValue > oldValue) {
223       allowed[msg.sender][_spender] = 0;
224     } else {
225       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
226     }
227     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228     return true;
229   }
230 
231 }
232 
233 /**
234  * @title Ownable
235  * @dev The Ownable contract has an owner address, and provides basic authorization control
236  * functions, this simplifies the implementation of "user permissions".
237  */
238 contract Ownable {
239   address public owner;
240 
241 
242   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
243 
244 
245   /**
246    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
247    * account.
248    */
249   function Ownable() public {
250     owner = msg.sender;
251   }
252 
253   /**
254    * @dev Throws if called by any account other than the owner.
255    */
256   modifier onlyOwner() {
257     require(msg.sender == owner);
258     _;
259   }
260 
261   /**
262    * @dev Allows the current owner to transfer control of the contract to a newOwner.
263    * @param newOwner The address to transfer ownership to.
264    */
265   function transferOwnership(address newOwner) public onlyOwner {
266     require(newOwner != address(0));
267     emit OwnershipTransferred(owner, newOwner);
268     owner = newOwner;
269   }
270 
271 }
272 
273 /**
274  * @title Mintable token
275  * @dev Simple ERC20 Token example, with mintable token creation
276  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
277  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
278  */
279 contract MintableToken is StandardToken, Ownable {
280   event Mint(address indexed to, uint256 amount);
281   event MintFinished();
282   event MintResumed();
283 
284   bool public mintingFinished = false;
285 
286   uint256 public maxSupply;
287 
288   function MintableToken(uint256 _maxSupply) public {
289     require(_maxSupply > 0);
290 
291     maxSupply = _maxSupply;
292   }
293 
294 
295   modifier canMint() {
296     require(!mintingFinished);
297     _;
298   }
299 
300   modifier isWithinLimit(uint256 amount) {
301     require((totalSupply_.add(amount)) <= maxSupply);
302     _;
303   }
304 
305   modifier canNotMint() {
306     require(mintingFinished);
307     _;
308   }
309 
310   /**
311    * @dev Function to mint tokens
312    * @param _to The address that will receive the minted tokens.
313    * @param _amount The amount of tokens to mint.
314    * @return A boolean that indicates if the operation was successful.
315    */
316   function mint(address _to, uint256 _amount) onlyOwner canMint isWithinLimit(_amount) public returns (bool) {
317     totalSupply_ = totalSupply_.add(_amount);
318     balances[_to] = balances[_to].add(_amount);
319     emit Mint(_to, _amount);
320     emit Transfer(address(0), _to, _amount);
321     return true;
322   }
323 
324   /**
325    * @dev Function to stop minting new tokens.
326    * @return True if the operation was successful.
327    */
328   function finishMinting() onlyOwner canMint public returns (bool) {
329     mintingFinished = true;
330     emit MintFinished();
331     return true;
332   }
333 
334   /**
335    * @dev Function to resume minting new tokens.
336    * @return True if the operation was successful.
337    */
338   function resumeMinting() onlyOwner canNotMint public returns (bool) {
339     mintingFinished = false;
340     emit MintResumed();
341     return true;
342   }
343 }
344 
345 /**
346  * @title Pausable
347  * @dev Base contract which allows children to implement an emergency stop mechanism.
348  */
349 contract Pausable is Ownable {
350   event Pause();
351   event Unpause();
352 
353   bool public paused = true;
354 
355 
356   /**
357    * @dev Modifier to make a function callable only when the contract is not paused.
358    */
359   modifier whenNotPaused() {
360     require(!paused);
361     _;
362   }
363 
364   /**
365    * @dev Modifier to make a function callable only when the contract is paused.
366    */
367   modifier whenPaused() {
368     require(paused);
369     _;
370   }
371 
372   /**
373    * @dev called by the owner to pause, triggers stopped state
374    */
375   function pause() onlyOwner whenNotPaused public {
376     paused = true;
377     emit Pause();
378   }
379 
380   /**
381    * @dev called by the owner to unpause, returns to normal state
382    */
383   function unpause() onlyOwner whenPaused public {
384     paused = false;
385     emit Unpause();
386   }
387 }
388 
389 /**
390  * @title Pausable token
391  * @dev StandardToken modified with pausable transfers.
392  **/
393 contract PausableToken is StandardToken, Pausable {
394 
395   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
396     return super.transfer(_to, _value);
397   }
398 
399   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
400     return super.transferFrom(_from, _to, _value);
401   }
402 
403   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
404     return super.approve(_spender, _value);
405   }
406 
407   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
408     return super.increaseApproval(_spender, _addedValue);
409   }
410 
411   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
412     return super.decreaseApproval(_spender, _subtractedValue);
413   }
414 }
415 
416 /**
417  * @title INCXToken
418  * @dev This is a standard ERC20 token
419  */
420 contract INCXToken is BurnableToken, PausableToken, MintableToken {
421   string public constant name = "INCX Coin";
422   string public constant symbol = "INCX";
423   uint64 public constant decimals = 18;
424   uint256 public constant maxLimit = 1000000000 * 10**uint(decimals);
425 
426   function INCXToken()
427     public
428     MintableToken(maxLimit)
429   {
430   }
431 }