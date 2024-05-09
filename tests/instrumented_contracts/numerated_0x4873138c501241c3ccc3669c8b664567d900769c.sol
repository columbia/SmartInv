1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
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
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender) public view returns (uint256);
68   function transferFrom(address from, address to, uint256 value) public returns (bool);
69   function approve(address spender, uint256 value) public returns (bool);
70   event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 
74 /**
75  * @title Basic token
76  * @dev Basic version of StandardToken, with no allowances.
77  */
78 contract BasicToken is ERC20Basic {
79   using SafeMath for uint256;
80 
81   mapping(address => uint256) balances;
82 
83   uint256 totalSupply_;
84 
85   /**
86   * @dev total number of tokens in existence
87   */
88   function totalSupply() public view returns (uint256) {
89     return totalSupply_;
90   }
91 
92   /**
93   * @dev transfer token for a specified address
94   * @param _to The address to transfer to.
95   * @param _value The amount to be transferred.
96   */
97   function transfer(address _to, uint256 _value) public returns (bool) {
98     require(_to != address(0));
99     require(_value <= balances[msg.sender]);
100 
101     balances[msg.sender] = balances[msg.sender].sub(_value);
102     balances[_to] = balances[_to].add(_value);
103     emit Transfer(msg.sender, _to, _value);
104     return true;
105   }
106 
107   /**
108   * @dev Gets the balance of the specified address.
109   * @param _owner The address to query the the balance of.
110   * @return An uint256 representing the amount owned by the passed address.
111   */
112   function balanceOf(address _owner) public view returns (uint256) {
113     return balances[_owner];
114   }
115 
116 }
117 
118 
119 /**
120  * @title Ownable
121  * @dev The Ownable contract has an owner address, and provides basic authorization control
122  * functions, this simplifies the implementation of "user permissions".
123  */
124 contract Ownable {
125   address public owner;
126 
127 
128   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
129 
130 
131   /**
132    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
133    * account.
134    */
135   constructor() public {
136     owner = msg.sender;
137   }
138 
139   /**
140    * @dev Throws if called by any account other than the owner.
141    */
142   modifier onlyOwner() {
143     require(msg.sender == owner);
144     _;
145   }
146 
147   /**
148    * @dev Allows the current owner to transfer control of the contract to a newOwner.
149    * @param newOwner The address to transfer ownership to.
150    */
151   function transferOwnership(address newOwner) public onlyOwner {
152     require(newOwner != address(0));
153     emit OwnershipTransferred(owner, newOwner);
154     owner = newOwner;
155   }
156 
157 }
158 
159 
160 /**
161  * @title Standard ERC20 token
162  *
163  * @dev Implementation of the basic standard token.
164  * @dev https://github.com/ethereum/EIPs/issues/20
165  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
166  */
167 contract StandardToken is ERC20, BasicToken {
168 
169   mapping (address => mapping (address => uint256)) internal allowed;
170 
171 
172   /**
173    * @dev Transfer tokens from one address to another
174    * @param _from address The address which you want to send tokens from
175    * @param _to address The address which you want to transfer to
176    * @param _value uint256 the amount of tokens to be transferred
177    */
178   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
179     require(_to != address(0));
180     require(_value <= balances[_from]);
181     require(_value <= allowed[_from][msg.sender]);
182 
183     balances[_from] = balances[_from].sub(_value);
184     balances[_to] = balances[_to].add(_value);
185     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
186     emit Transfer(_from, _to, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
192    *
193    * Beware that changing an allowance with this method brings the risk that someone may use both the old
194    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
195    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
196    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
197    * @param _spender The address which will spend the funds.
198    * @param _value The amount of tokens to be spent.
199    */
200   function approve(address _spender, uint256 _value) public returns (bool) {
201     allowed[msg.sender][_spender] = _value;
202     emit Approval(msg.sender, _spender, _value);
203     return true;
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
228     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
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
249     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250     return true;
251   }
252 
253 }
254 
255 /**
256  * @title Mintable token
257  * @dev Simple ERC20 Token example, with mintable token creation
258  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
259  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
260  */
261 contract MintableToken is StandardToken, Ownable {
262   event Mint(address indexed to, uint256 amount);
263   event MintFinished();
264 
265   bool public mintingFinished = false;
266 
267 
268   modifier canMint() {
269     require(!mintingFinished);
270     _;
271   }
272 
273   /**
274    * @dev Function to mint tokens
275    * @param _to The address that will receive the minted tokens.
276    * @param _amount The amount of tokens to mint.
277    * @return A boolean that indicates if the operation was successful.
278    */
279   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
280     totalSupply_ = totalSupply_.add(_amount);
281     balances[_to] = balances[_to].add(_amount);
282     emit Mint(_to, _amount);
283     emit Transfer(address(0), _to, _amount);
284     return true;
285   }
286 
287   /**
288    * @dev Function to stop minting new tokens.
289    * @return True if the operation was successful.
290    */
291   function finishMinting() onlyOwner canMint public returns (bool) {
292     mintingFinished = true;
293     emit MintFinished();
294     return true;
295   }
296 }
297 
298 /**
299  * @title Pausable
300  * @dev Base contract which allows children to implement an emergency stop mechanism.
301  */
302 contract Pausable is Ownable {
303   event Pause();
304   event Unpause();
305 
306   bool public paused = false;
307 
308 
309   /**
310    * @dev Modifier to make a function callable only when the contract is not paused.
311    */
312   modifier whenNotPaused() {
313     require(!paused);
314     _;
315   }
316 
317   /**
318    * @dev Modifier to make a function callable only when the contract is paused.
319    */
320   modifier whenPaused() {
321     require(paused);
322     _;
323   }
324 
325   /**
326    * @dev called by the owner to pause, triggers stopped state
327    */
328   function pause() onlyOwner whenNotPaused public {
329     paused = true;
330     emit Pause();
331   }
332 
333   /**
334    * @dev called by the owner to unpause, returns to normal state
335    */
336   function unpause() onlyOwner whenPaused public {
337     paused = false;
338     emit Unpause();
339   }
340 }
341 
342 
343 /**
344  * @title Pausable token
345  * @dev StandardToken modified with pausable transfers.
346  **/
347 contract PausableToken is StandardToken, Pausable {
348 
349   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
350     return super.transfer(_to, _value);
351   }
352 
353   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
354     return super.transferFrom(_from, _to, _value);
355   }
356 
357   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
358     return super.approve(_spender, _value);
359   }
360 
361   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
362     return super.increaseApproval(_spender, _addedValue);
363   }
364 
365   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
366     return super.decreaseApproval(_spender, _subtractedValue);
367   }
368 }
369 
370 
371 contract Token is MintableToken, PausableToken {
372   string public constant name = "Tachain";
373   string public constant symbol = "TCHN";
374   uint8 public constant decimals = 18;
375   string public constant version = "H0.1"; //human 0.1 standard. Just an arbitrary versioning scheme.
376 }
377 
378 contract Crowdsale is Ownable {
379 
380   using SafeMath for uint256;
381 
382   // address of erc20 token contract
383   MintableToken public token;
384 
385   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 amount);
386 
387   constructor() public {
388     token = createTokenContract();
389   }
390 
391   // creates the token to be sold.
392   // override this method to have crowdsale of a specific mintable token.
393   function createTokenContract() internal returns (MintableToken) {
394     return new Token();
395   }
396 
397   // owner can mint tokens during crowdsale withing defined caps
398   function mintTokens(address beneficiary, uint256 tokens) external onlyOwner returns (bool) {
399     require(beneficiary != 0x0);
400     require(tokens != 0);
401     token.mint(beneficiary, tokens);
402     emit TokenPurchase(msg.sender, beneficiary, tokens);
403   }
404 
405   // set token on pause
406   function pauseToken() external onlyOwner {
407     Token(token).pause();
408   }
409 
410   // unset token's pause
411   function unpauseToken() external onlyOwner {
412     Token(token).unpause();
413   }
414 
415     // set token Ownership
416   function transferTokenOwnership(address newOwner) external onlyOwner {
417     Token(token).transferOwnership(newOwner);
418   }
419 
420 
421 }