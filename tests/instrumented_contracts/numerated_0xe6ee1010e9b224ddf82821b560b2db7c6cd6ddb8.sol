1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     emit OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45   /**
46    * @dev Allows the current owner to relinquish control of the contract.
47    */
48   function renounceOwnership() public onlyOwner {
49     emit OwnershipRenounced(owner);
50     owner = address(0);
51   }
52 }
53 
54 /**
55  * @title SafeMath
56  * @dev Math operations with safety checks that throw on error
57  */
58 library SafeMath {
59 
60   /**
61   * @dev Multiplies two numbers, throws on overflow.
62   */
63   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
64     if (a == 0) {
65       return 0;
66     }
67     c = a * b;
68     assert(c / a == b);
69     return c;
70   }
71 
72   /**
73   * @dev Integer division of two numbers, truncating the quotient.
74   */
75   function div(uint256 a, uint256 b) internal pure returns (uint256) {
76     // assert(b > 0); // Solidity automatically throws when dividing by 0
77     // uint256 c = a / b;
78     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
79     return a / b;
80   }
81 
82   /**
83   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
84   */
85   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86     assert(b <= a);
87     return a - b;
88   }
89 
90   /**
91   * @dev Adds two numbers, throws on overflow.
92   */
93   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
94     c = a + b;
95     assert(c >= a);
96     return c;
97   }
98 }
99 
100 /**
101  * @title ERC20Basic
102  * @dev Simpler version of ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/179
104  */
105 contract ERC20Basic {
106   function totalSupply() public view returns (uint256);
107   function balanceOf(address who) public view returns (uint256);
108   function transfer(address to, uint256 value) public returns (bool);
109   event Transfer(address indexed from, address indexed to, uint256 value);
110 }
111 
112 /**
113  * @title ERC20 interface
114  * @dev see https://github.com/ethereum/EIPs/issues/20
115  */
116 contract ERC20 is ERC20Basic {
117   function allowance(address owner, address spender) public view returns (uint256);
118   function transferFrom(address from, address to, uint256 value) public returns (bool);
119   function approve(address spender, uint256 value) public returns (bool);
120   event Approval(address indexed owner, address indexed spender, uint256 value);
121 }
122 
123 contract BasicToken is ERC20Basic {
124   using SafeMath for uint256;
125 
126   mapping(address => uint256) balances;
127 
128   uint256 totalSupply_;
129 
130   /**
131   * @dev total number of tokens in existence
132   */
133   function totalSupply() public view returns (uint256) {
134     return totalSupply_;
135   }
136 
137   /**
138   * @dev transfer token for a specified address
139   * @param _to The address to transfer to.
140   * @param _value The amount to be transferred.
141   */
142   function transfer(address _to, uint256 _value) public returns (bool) {
143     require(_to != address(0));
144     require(_value <= balances[msg.sender]);
145 
146     balances[msg.sender] = balances[msg.sender].sub(_value);
147     balances[_to] = balances[_to].add(_value);
148     emit Transfer(msg.sender, _to, _value);
149     return true;
150   }
151 
152   /**
153   * @dev Gets the balance of the specified address.
154   * @param _owner The address to query the the balance of.
155   * @return An uint256 representing the amount owned by the passed address.
156   */
157   function balanceOf(address _owner) public view returns (uint256) {
158     return balances[_owner];
159   }
160 
161 }
162 /**
163  * @title Standard ERC20 token
164  *
165  * @dev Implementation of the basic standard token.
166  * @dev https://github.com/ethereum/EIPs/issues/20
167  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
168  */
169 contract StandardToken is ERC20, BasicToken {
170 
171   mapping (address => mapping (address => uint256)) internal allowed;
172 
173 
174   /**
175    * @dev Transfer tokens from one address to another
176    * @param _from address The address which you want to send tokens from
177    * @param _to address The address which you want to transfer to
178    * @param _value uint256 the amount of tokens to be transferred
179    */
180   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
181     require(_to != address(0));
182     require(_value <= balances[_from]);
183     require(_value <= allowed[_from][msg.sender]);
184 
185     balances[_from] = balances[_from].sub(_value);
186     balances[_to] = balances[_to].add(_value);
187     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
188     emit Transfer(_from, _to, _value);
189     return true;
190   }
191 
192   /**
193    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
194    *
195    * Beware that changing an allowance with this method brings the risk that someone may use both the old
196    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
197    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
198    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199    * @param _spender The address which will spend the funds.
200    * @param _value The amount of tokens to be spent.
201    */
202   function approve(address _spender, uint256 _value) public returns (bool) {
203     allowed[msg.sender][_spender] = _value;
204     emit Approval(msg.sender, _spender, _value);
205     return true;
206   }
207 
208   /**
209    * @dev Function to check the amount of tokens that an owner allowed to a spender.
210    * @param _owner address The address which owns the funds.
211    * @param _spender address The address which will spend the funds.
212    * @return A uint256 specifying the amount of tokens still available for the spender.
213    */
214   function allowance(address _owner, address _spender) public view returns (uint256) {
215     return allowed[_owner][_spender];
216   }
217 
218   /**
219    * @dev Increase the amount of tokens that an owner allowed to a spender.
220    *
221    * approve should be called when allowed[_spender] == 0. To increment
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _addedValue The amount of tokens to increase the allowance by.
227    */
228   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
229     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
230     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
231     return true;
232   }
233 
234   /**
235    * @dev Decrease the amount of tokens that an owner allowed to a spender.
236    *
237    * approve should be called when allowed[_spender] == 0. To decrement
238    * allowed value is better to use this function to avoid 2 calls (and wait until
239    * the first transaction is mined)
240    * From MonolithDAO Token.sol
241    * @param _spender The address which will spend the funds.
242    * @param _subtractedValue The amount of tokens to decrease the allowance by.
243    */
244   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
245     uint oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue > oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 contract MintableToken is StandardToken, Ownable {
258   event Mint(address indexed to, uint256 amount);
259   event MintFinished();
260 
261   bool public mintingFinished = false;
262 
263 
264   modifier canMint() {
265     require(!mintingFinished);
266     _;
267   }
268 
269   /**
270    * @dev Function to mint tokens
271    * @param _to The address that will receive the minted tokens.
272    * @param _amount The amount of tokens to mint.
273    * @return A boolean that indicates if the operation was successful.
274    */
275   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
276     totalSupply_ = totalSupply_.add(_amount);
277     balances[_to] = balances[_to].add(_amount);
278     emit Mint(_to, _amount);
279     emit Transfer(address(0), _to, _amount);
280     return true;
281   }
282 
283   /**
284    * @dev Function to stop minting new tokens.
285    * @return True if the operation was successful.
286    */
287   function finishMinting() onlyOwner canMint public returns (bool) {
288     mintingFinished = true;
289     emit MintFinished();
290     return true;
291   }
292 }
293 
294 
295 contract CappedToken is MintableToken {
296 
297   uint256 public cap;
298 
299   constructor(uint256 _cap) public {
300     require(_cap > 0);
301     cap = _cap;
302   }
303 
304   /**
305    * @dev Function to mint tokens
306    * @param _to The address that will receive the minted tokens.
307    * @param _amount The amount of tokens to mint.
308    * @return A boolean that indicates if the operation was successful.
309    */
310   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
311     require(totalSupply_.add(_amount) <= cap);
312 
313     return super.mint(_to, _amount);
314   }
315 
316 }
317 
318 contract Pausable is Ownable {
319   event Pause();
320   event Unpause();
321 
322   bool public paused = false;
323 
324 
325   /**
326    * @dev Modifier to make a function callable only when the contract is not paused.
327    */
328   modifier whenNotPaused() {
329     require(!paused);
330     _;
331   }
332 
333   /**
334    * @dev Modifier to make a function callable only when the contract is paused.
335    */
336   modifier whenPaused() {
337     require(paused);
338     _;
339   }
340 
341   /**
342    * @dev called by the owner to pause, triggers stopped state
343    */
344   function pause() onlyOwner whenNotPaused public {
345     paused = true;
346     emit Pause();
347   }
348 
349   /**
350    * @dev called by the owner to unpause, returns to normal state
351    */
352   function unpause() onlyOwner whenPaused public {
353     paused = false;
354     emit Unpause();
355   }
356 }
357 
358 contract PausableToken is StandardToken, Pausable {
359 
360   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
361     return super.transfer(_to, _value);
362   }
363 
364   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
365     return super.transferFrom(_from, _to, _value);
366   }
367 
368   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
369     return super.approve(_spender, _value);
370   }
371 
372   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
373     return super.increaseApproval(_spender, _addedValue);
374   }
375 
376   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
377     return super.decreaseApproval(_spender, _subtractedValue);
378   }
379 }
380 
381 contract FInsurToken is CappedToken, PausableToken {
382     string public constant name = "FInsur Token (Released)"; // solium-disable-line uppercase
383     string public constant symbol = "FI"; // solium-disable-line uppercase
384     uint8 public constant decimals = 18; // solium-disable-line uppercase
385 
386     uint256 public constant INITIAL_SUPPLY = 0;
387     uint256 public constant MAX_SUPPLY = 20 * 10000 * 10000 * (10 ** uint256(decimals));
388 
389     /**
390     * @dev Constructor that gives msg.sender all of existing tokens.
391     */
392     constructor() CappedToken(MAX_SUPPLY) public {
393         totalSupply_ = INITIAL_SUPPLY;
394         balances[msg.sender] = INITIAL_SUPPLY;
395         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
396     }
397 
398     /**
399     * @dev Function to mint tokens
400     * @param _to The address that will receive the minted tokens.
401     * @param _amount The amount of tokens to mint.
402     * @return A boolean that indicates if the operation was successful.
403     */
404     function mint(address _to, uint256 _amount) onlyOwner canMint whenNotPaused public returns (bool) {
405         return super.mint(_to, _amount);
406     }
407 
408     /**
409     * @dev Function to stop minting new tokens.
410     * @return True if the operation was successful.
411     */
412     function finishMinting() onlyOwner canMint whenNotPaused public returns (bool) {
413         return super.finishMinting();
414     }
415 
416     /**
417     * @dev Allows the current owner to transfer control of the contract to a newOwner.
418     * @param newOwner The address to transfer ownership to.
419     */
420     function transferOwnership(address newOwner) onlyOwner whenNotPaused public {
421         super.transferOwnership(newOwner);
422     }
423 
424     /**
425     * The fallback function.
426     */
427     function() payable public {
428         revert();
429     }
430 }