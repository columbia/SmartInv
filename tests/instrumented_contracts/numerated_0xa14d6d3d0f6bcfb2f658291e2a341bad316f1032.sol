1 pragma solidity ^0.4.11;
2 
3 // zeppelin-solidity: 1.8.0
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
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 /**
46  * @title ERC20Basic
47  * @dev Simpler version of ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/179
49  */
50 contract ERC20Basic {
51   function totalSupply() public view returns (uint256);
52   function balanceOf(address who) public view returns (uint256);
53   function transfer(address to, uint256 value) public returns (bool);
54   event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 /**
58  * @title ERC20 interface
59  * @dev see https://github.com/ethereum/EIPs/issues/20
60  */
61 contract ERC20 is ERC20Basic {
62   function allowance(address owner, address spender) public view returns (uint256);
63   function transferFrom(address from, address to, uint256 value) public returns (bool);
64   function approve(address spender, uint256 value) public returns (bool);
65   event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 /**
69  * @title Basic token
70  * @dev Basic version of StandardToken, with no allowances.
71  */
72 contract BasicToken is ERC20Basic {
73   using SafeMath for uint256;
74 
75   mapping(address => uint256) balances;
76 
77   uint256 totalSupply_;
78 
79   /**
80   * @dev total number of tokens in existence
81   */
82   function totalSupply() public view returns (uint256) {
83     return totalSupply_;
84   }
85 
86   /**
87   * @dev transfer token for a specified address
88   * @param _to The address to transfer to.
89   * @param _value The amount to be transferred.
90   */
91   function transfer(address _to, uint256 _value) public returns (bool) {
92     require(_to != address(0));
93     require(_value <= balances[msg.sender]);
94 
95     // SafeMath.sub will throw if there is not enough balance.
96     balances[msg.sender] = balances[msg.sender].sub(_value);
97     balances[_to] = balances[_to].add(_value);
98     Transfer(msg.sender, _to, _value);
99     return true;
100   }
101 
102   /**
103   * @dev Gets the balance of the specified address.
104   * @param _owner The address to query the the balance of.
105   * @return An uint256 representing the amount owned by the passed address.
106   */
107   function balanceOf(address _owner) public view returns (uint256 balance) {
108     return balances[_owner];
109   }
110 
111 }
112 
113 /**
114  * @title Standard ERC20 token
115  *
116  * @dev Implementation of the basic standard token.
117  * @dev https://github.com/ethereum/EIPs/issues/20
118  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
119  */
120 contract StandardToken is ERC20, BasicToken {
121 
122   mapping (address => mapping (address => uint256)) internal allowed;
123 
124 
125   /**
126    * @dev Transfer tokens from one address to another
127    * @param _from address The address which you want to send tokens from
128    * @param _to address The address which you want to transfer to
129    * @param _value uint256 the amount of tokens to be transferred
130    */
131   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
132     require(_to != address(0));
133     require(_value <= balances[_from]);
134     require(_value <= allowed[_from][msg.sender]);
135 
136     balances[_from] = balances[_from].sub(_value);
137     balances[_to] = balances[_to].add(_value);
138     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
139     Transfer(_from, _to, _value);
140     return true;
141   }
142 
143   /**
144    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
145    *
146    * Beware that changing an allowance with this method brings the risk that someone may use both the old
147    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
148    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
149    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150    * @param _spender The address which will spend the funds.
151    * @param _value The amount of tokens to be spent.
152    */
153   function approve(address _spender, uint256 _value) public returns (bool) {
154     allowed[msg.sender][_spender] = _value;
155     Approval(msg.sender, _spender, _value);
156     return true;
157   }
158 
159   /**
160    * @dev Function to check the amount of tokens that an owner allowed to a spender.
161    * @param _owner address The address which owns the funds.
162    * @param _spender address The address which will spend the funds.
163    * @return A uint256 specifying the amount of tokens still available for the spender.
164    */
165   function allowance(address _owner, address _spender) public view returns (uint256) {
166     return allowed[_owner][_spender];
167   }
168 
169   /**
170    * @dev Increase the amount of tokens that an owner allowed to a spender.
171    *
172    * approve should be called when allowed[_spender] == 0. To increment
173    * allowed value is better to use this function to avoid 2 calls (and wait until
174    * the first transaction is mined)
175    * From MonolithDAO Token.sol
176    * @param _spender The address which will spend the funds.
177    * @param _addedValue The amount of tokens to increase the allowance by.
178    */
179   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
180     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
181     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182     return true;
183   }
184 
185   /**
186    * @dev Decrease the amount of tokens that an owner allowed to a spender.
187    *
188    * approve should be called when allowed[_spender] == 0. To decrement
189    * allowed value is better to use this function to avoid 2 calls (and wait until
190    * the first transaction is mined)
191    * From MonolithDAO Token.sol
192    * @param _spender The address which will spend the funds.
193    * @param _subtractedValue The amount of tokens to decrease the allowance by.
194    */
195   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
196     uint oldValue = allowed[msg.sender][_spender];
197     if (_subtractedValue > oldValue) {
198       allowed[msg.sender][_spender] = 0;
199     } else {
200       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
201     }
202     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
203     return true;
204   }
205 
206 }
207 
208 /**
209  * @title Mintable token
210  * @dev Simple ERC20 Token example, with mintable token creation
211  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
212  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
213  */
214 contract MintableToken is StandardToken, Ownable {
215   event Mint(address indexed to, uint256 amount);
216   event MintFinished();
217 
218   bool public mintingFinished = false;
219 
220 
221   modifier canMint() {
222     require(!mintingFinished);
223     _;
224   }
225 
226   /**
227    * @dev Function to mint tokens
228    * @param _to The address that will receive the minted tokens.
229    * @param _amount The amount of tokens to mint.
230    * @return A boolean that indicates if the operation was successful.
231    */
232   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
233     totalSupply_ = totalSupply_.add(_amount);
234     balances[_to] = balances[_to].add(_amount);
235     Mint(_to, _amount);
236     Transfer(address(0), _to, _amount);
237     return true;
238   }
239 
240   /**
241    * @dev Function to stop minting new tokens.
242    * @return True if the operation was successful.
243    */
244   function finishMinting() onlyOwner canMint public returns (bool) {
245     mintingFinished = true;
246     MintFinished();
247     return true;
248   }
249 }
250 
251 /**
252  * @title Capped token
253  * @dev Mintable token with a token cap.
254  */
255 contract CappedToken is MintableToken {
256 
257   uint256 public cap;
258 
259   function CappedToken(uint256 _cap) public {
260     require(_cap > 0);
261     cap = _cap;
262   }
263 
264   /**
265    * @dev Function to mint tokens
266    * @param _to The address that will receive the minted tokens.
267    * @param _amount The amount of tokens to mint.
268    * @return A boolean that indicates if the operation was successful.
269    */
270   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
271     require(totalSupply_.add(_amount) <= cap);
272 
273     return super.mint(_to, _amount);
274   }
275 
276 }
277 
278 /**
279  * @title SafeMath
280  * @dev Math operations with safety checks that throw on error
281  */
282 library SafeMath {
283 
284   /**
285   * @dev Multiplies two numbers, throws on overflow.
286   */
287   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
288     if (a == 0) {
289       return 0;
290     }
291     uint256 c = a * b;
292     assert(c / a == b);
293     return c;
294   }
295 
296   /**
297   * @dev Integer division of two numbers, truncating the quotient.
298   */
299   function div(uint256 a, uint256 b) internal pure returns (uint256) {
300     // assert(b > 0); // Solidity automatically throws when dividing by 0
301     uint256 c = a / b;
302     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
303     return c;
304   }
305 
306   /**
307   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
308   */
309   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
310     assert(b <= a);
311     return a - b;
312   }
313 
314   /**
315   * @dev Adds two numbers, throws on overflow.
316   */
317   function add(uint256 a, uint256 b) internal pure returns (uint256) {
318     uint256 c = a + b;
319     assert(c >= a);
320     return c;
321   }
322 }
323 
324 /**
325  * @title Pausable
326  * @dev Base contract which allows children to implement an emergency stop mechanism.
327  */
328 contract Pausable is Ownable {
329   event Pause();
330   event Unpause();
331 
332   bool public paused = false;
333 
334 
335   /**
336    * @dev Modifier to make a function callable only when the contract is not paused.
337    */
338   modifier whenNotPaused() {
339     require(!paused);
340     _;
341   }
342 
343   /**
344    * @dev Modifier to make a function callable only when the contract is paused.
345    */
346   modifier whenPaused() {
347     require(paused);
348     _;
349   }
350 
351   /**
352    * @dev called by the owner to pause, triggers stopped state
353    */
354   function pause() onlyOwner whenNotPaused public {
355     paused = true;
356     Pause();
357   }
358 
359   /**
360    * @dev called by the owner to unpause, returns to normal state
361    */
362   function unpause() onlyOwner whenPaused public {
363     paused = false;
364     Unpause();
365   }
366 }
367 
368 /**
369  * @title Pausable token
370  * @dev StandardToken modified with pausable transfers.
371  **/
372 contract PausableToken is StandardToken, Pausable {
373 
374   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
375     return super.transfer(_to, _value);
376   }
377 
378   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
379     return super.transferFrom(_from, _to, _value);
380   }
381 
382   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
383     return super.approve(_spender, _value);
384   }
385 
386   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
387     return super.increaseApproval(_spender, _addedValue);
388   }
389 
390   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
391     return super.decreaseApproval(_spender, _subtractedValue);
392   }
393 }
394 
395 /**
396  * @title Claimable
397  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
398  * This allows the new owner to accept the transfer.
399  */
400 contract Claimable is Ownable {
401   address public pendingOwner;
402 
403   /**
404    * @dev Modifier throws if called by any account other than the pendingOwner.
405    */
406   modifier onlyPendingOwner() {
407     require(msg.sender == pendingOwner);
408     _;
409   }
410 
411   /**
412    * @dev Allows the current owner to set the pendingOwner address.
413    * @param newOwner The address to transfer ownership to.
414    */
415   function transferOwnership(address newOwner) onlyOwner public {
416     pendingOwner = newOwner;
417   }
418 
419   /**
420    * @dev Allows the pendingOwner address to finalize the transfer.
421    */
422   function claimOwnership() onlyPendingOwner public {
423     OwnershipTransferred(owner, pendingOwner);
424     owner = pendingOwner;
425     pendingOwner = address(0);
426   }
427 }
428 
429 /**
430  * @title Iagon Token
431  *
432 */
433 
434 contract IagonToken is Ownable, Claimable, PausableToken, CappedToken {
435     string public constant name = "Iagon Presale";
436     string public constant symbol = "IAGT";
437     uint8 public constant decimals = 18;
438 
439     event Fused();
440 
441     bool public fused = false;
442 
443    /**
444      * @dev Constructor 
445      */
446     function IagonToken() public CappedToken(1) PausableToken() {
447         cap = 200000001 * (10 ** uint256(decimals)); // hardcoding cap
448     }
449 
450     /** 
451     * @dev function to allow the owner to withdraw any ETH balance associated with this contract address
452     * onlyOwner can call this, so it's safe to initiate a transfer 
453     */
454     function withdraw() onlyOwner public {
455         msg.sender.transfer(this.balance);
456     }
457 
458  	/**
459  	 * @dev Modifier to make a function callable only when the contract is not fused.
460  	 */
461     modifier whenNotFused() {
462         require(!fused);
463         _;
464     }
465 
466     function pause() whenNotFused public {
467         return super.pause();
468     }
469 
470  	 /** 
471  	 * @dev Function to set the value of the fuse internal variable.  Note that there is 
472  	 * no "unfuse" functionality, by design.
473  	 */
474     function fuse() whenNotFused onlyOwner public {
475         fused = true;
476 
477         Fused();
478     }
479 }