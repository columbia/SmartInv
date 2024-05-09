1 pragma solidity ^0.4.21;
2 
3 
4 
5 
6 
7 
8 
9 /**
10  * @title ERC20Basic
11  * @dev Simpler version of ERC20 interface
12  * @dev see https://github.com/ethereum/EIPs/issues/179
13  */
14 contract ERC20Basic {
15   function totalSupply() public view returns (uint256);
16   function balanceOf(address who) public view returns (uint256);
17   function transfer(address to, uint256 value) public returns (bool);
18   event Transfer(address indexed from, address indexed to, uint256 value);
19 }
20 
21 
22 /**
23  * @title SafeMath
24  * @dev Math operations with safety checks that throw on error
25  */
26 library SafeMath {
27 
28   /**
29   * @dev Multiplies two numbers, throws on overflow.
30   */
31   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32     if (a == 0) {
33       return 0;
34     }
35     uint256 c = a * b;
36     assert(c / a == b);
37     return c;
38   }
39 
40   /**
41   * @dev Integer division of two numbers, truncating the quotient.
42   */
43   function div(uint256 a, uint256 b) internal pure returns (uint256) {
44     // assert(b > 0); // Solidity automatically throws when dividing by 0
45     uint256 c = a / b;
46     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47     return c;
48   }
49 
50   /**
51   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
52   */
53   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54     assert(b <= a);
55     return a - b;
56   }
57 
58   /**
59   * @dev Adds two numbers, throws on overflow.
60   */
61   function add(uint256 a, uint256 b) internal pure returns (uint256) {
62     uint256 c = a + b;
63     assert(c >= a);
64     return c;
65   }
66 }
67 
68 
69 /**
70  * @title Basic token
71  * @dev Basic version of StandardToken, with no allowances.
72  */
73 contract BasicToken is ERC20Basic {
74   using SafeMath for uint256;
75 
76   mapping(address => uint256) balances;
77 
78   uint256 totalSupply_;
79 
80   /**
81   * @dev total number of tokens in existence
82   */
83   function totalSupply() public view returns (uint256) {
84     return totalSupply_;
85   }
86 
87   /**
88   * @dev transfer token for a specified address
89   * @param _to The address to transfer to.
90   * @param _value The amount to be transferred.
91   */
92   function transfer(address _to, uint256 _value) public returns (bool) {
93     require(_to != address(0));
94     require(_value <= balances[msg.sender]);
95 
96     // SafeMath.sub will throw if there is not enough balance.
97     balances[msg.sender] = balances[msg.sender].sub(_value);
98     balances[_to] = balances[_to].add(_value);
99     Transfer(msg.sender, _to, _value);
100     return true;
101   }
102 
103   /**
104   * @dev Gets the balance of the specified address.
105   * @param _owner The address to query the the balance of.
106   * @return An uint256 representing the amount owned by the passed address.
107   */
108   function balanceOf(address _owner) public view returns (uint256 balance) {
109     return balances[_owner];
110   }
111 
112 }
113 
114 
115 
116 /**
117  * @title ERC20 interface
118  * @dev see https://github.com/ethereum/EIPs/issues/20
119  */
120 contract ERC20 is ERC20Basic {
121   function allowance(address owner, address spender) public view returns (uint256);
122   function transferFrom(address from, address to, uint256 value) public returns (bool);
123   function approve(address spender, uint256 value) public returns (bool);
124   event Approval(address indexed owner, address indexed spender, uint256 value);
125 }
126 
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * @dev https://github.com/ethereum/EIPs/issues/20
133  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
147     require(_to != address(0));
148     require(_value <= balances[_from]);
149     require(_value <= allowed[_from][msg.sender]);
150 
151     balances[_from] = balances[_from].sub(_value);
152     balances[_to] = balances[_to].add(_value);
153     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
154     Transfer(_from, _to, _value);
155     return true;
156   }
157 
158   /**
159    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160    *
161    * Beware that changing an allowance with this method brings the risk that someone may use both the old
162    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
163    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
164    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165    * @param _spender The address which will spend the funds.
166    * @param _value The amount of tokens to be spent.
167    */
168   function approve(address _spender, uint256 _value) public returns (bool) {
169     allowed[msg.sender][_spender] = _value;
170     Approval(msg.sender, _spender, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens that an owner allowed to a spender.
176    * @param _owner address The address which owns the funds.
177    * @param _spender address The address which will spend the funds.
178    * @return A uint256 specifying the amount of tokens still available for the spender.
179    */
180   function allowance(address _owner, address _spender) public view returns (uint256) {
181     return allowed[_owner][_spender];
182   }
183 
184   /**
185    * @dev Increase the amount of tokens that an owner allowed to a spender.
186    *
187    * approve should be called when allowed[_spender] == 0. To increment
188    * allowed value is better to use this function to avoid 2 calls (and wait until
189    * the first transaction is mined)
190    * From MonolithDAO Token.sol
191    * @param _spender The address which will spend the funds.
192    * @param _addedValue The amount of tokens to increase the allowance by.
193    */
194   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
195     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
196     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197     return true;
198   }
199 
200   /**
201    * @dev Decrease the amount of tokens that an owner allowed to a spender.
202    *
203    * approve should be called when allowed[_spender] == 0. To decrement
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    * @param _spender The address which will spend the funds.
208    * @param _subtractedValue The amount of tokens to decrease the allowance by.
209    */
210   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
211     uint oldValue = allowed[msg.sender][_spender];
212     if (_subtractedValue > oldValue) {
213       allowed[msg.sender][_spender] = 0;
214     } else {
215       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
216     }
217     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221 }
222 
223 
224 
225 
226 /**
227  * @title Ownable
228  * @dev The Ownable contract has an owner address, and provides basic authorization control
229  * functions, this simplifies the implementation of "user permissions".
230  */
231 contract Ownable {
232   address public owner;
233 
234 
235   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
236 
237 
238   /**
239    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
240    * account.
241    */
242   function Ownable() public {
243     owner = msg.sender;
244   }
245 
246   /**
247    * @dev Throws if called by any account other than the owner.
248    */
249   modifier onlyOwner() {
250     require(msg.sender == owner);
251     _;
252   }
253 
254   /**
255    * @dev Allows the current owner to transfer control of the contract to a newOwner.
256    * @param newOwner The address to transfer ownership to.
257    */
258   function transferOwnership(address newOwner) public onlyOwner {
259     require(newOwner != address(0));
260     OwnershipTransferred(owner, newOwner);
261     owner = newOwner;
262   }
263 
264 }
265 
266 
267 /**
268  * @title Pausable
269  * @dev Base contract which allows children to implement an emergency stop mechanism.
270  */
271 contract Pausable is Ownable {
272   event Pause();
273   event Unpause();
274 
275   bool public paused = false;
276 
277 
278   /**
279    * @dev Modifier to make a function callable only when the contract is not paused.
280    */
281   modifier whenNotPaused() {
282     require(!paused);
283     _;
284   }
285 
286   /**
287    * @dev Modifier to make a function callable only when the contract is paused.
288    */
289   modifier whenPaused() {
290     require(paused);
291     _;
292   }
293 
294   /**
295    * @dev called by the owner to pause, triggers stopped state
296    */
297   function pause() onlyOwner whenNotPaused public {
298     paused = true;
299     Pause();
300   }
301 
302   /**
303    * @dev called by the owner to unpause, returns to normal state
304    */
305   function unpause() onlyOwner whenPaused public {
306     paused = false;
307     Unpause();
308   }
309 }
310 
311 
312 /**
313  * @title Pausable token
314  * @dev StandardToken modified with pausable transfers.
315  **/
316 contract PausableToken is StandardToken, Pausable {
317 
318   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
319     return super.transfer(_to, _value);
320   }
321 
322   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
323     return super.transferFrom(_from, _to, _value);
324   }
325 
326   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
327     return super.approve(_spender, _value);
328   }
329 
330   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
331     return super.increaseApproval(_spender, _addedValue);
332   }
333 
334   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
335     return super.decreaseApproval(_spender, _subtractedValue);
336   }
337 }
338 
339 
340 
341 
342 
343 /**
344    @title ERC827 interface, an extension of ERC20 token standard
345 
346    Interface of a ERC827 token, following the ERC20 standard with extra
347    methods to transfer value and data and execute calls in transfers and
348    approvals.
349  */
350 contract ERC827 is ERC20 {
351 
352   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
353   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
354   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
355 
356 }
357 
358 /**
359    @title ERC827, an extension of ERC20 token standard
360 
361    Implementation the ERC827, following the ERC20 standard with extra
362    methods to transfer value and data and execute calls in transfers and
363    approvals.
364    Uses OpenZeppelin StandardToken.
365  */
366 contract ERC827Token is ERC827, StandardToken {
367 
368   /**
369      @dev Addition to ERC20 token methods. It allows to
370      approve the transfer of value and execute a call with the sent data.
371 
372      Beware that changing an allowance with this method brings the risk that
373      someone may use both the old and the new allowance by unfortunate
374      transaction ordering. One possible solution to mitigate this race condition
375      is to first reduce the spender's allowance to 0 and set the desired value
376      afterwards:
377      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
378 
379      @param _spender The address that will spend the funds.
380      @param _value The amount of tokens to be spent.
381      @param _data ABI-encoded contract call to call `_to` address.
382 
383      @return true if the call function was executed successfully
384    */
385   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
386     require(_spender != address(this));
387 
388     super.approve(_spender, _value);
389 
390     require(_spender.call(_data));
391 
392     return true;
393   }
394 
395   /**
396      @dev Addition to ERC20 token methods. Transfer tokens to a specified
397      address and execute a call with the sent data on the same transaction
398 
399      @param _to address The address which you want to transfer to
400      @param _value uint256 the amout of tokens to be transfered
401      @param _data ABI-encoded contract call to call `_to` address.
402 
403      @return true if the call function was executed successfully
404    */
405   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
406     require(_to != address(this));
407 
408     super.transfer(_to, _value);
409 
410     require(_to.call(_data));
411     return true;
412   }
413 
414   /**
415      @dev Addition to ERC20 token methods. Transfer tokens from one address to
416      another and make a contract call on the same transaction
417 
418      @param _from The address which you want to send tokens from
419      @param _to The address which you want to transfer to
420      @param _value The amout of tokens to be transferred
421      @param _data ABI-encoded contract call to call `_to` address.
422 
423      @return true if the call function was executed successfully
424    */
425   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
426     require(_to != address(this));
427 
428     super.transferFrom(_from, _to, _value);
429 
430     require(_to.call(_data));
431     return true;
432   }
433 
434   /**
435    * @dev Addition to StandardToken methods. Increase the amount of tokens that
436    * an owner allowed to a spender and execute a call with the sent data.
437    *
438    * approve should be called when allowed[_spender] == 0. To increment
439    * allowed value is better to use this function to avoid 2 calls (and wait until
440    * the first transaction is mined)
441    * From MonolithDAO Token.sol
442    * @param _spender The address which will spend the funds.
443    * @param _addedValue The amount of tokens to increase the allowance by.
444    * @param _data ABI-encoded contract call to call `_spender` address.
445    */
446   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
447     require(_spender != address(this));
448 
449     super.increaseApproval(_spender, _addedValue);
450 
451     require(_spender.call(_data));
452 
453     return true;
454   }
455 
456   /**
457    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
458    * an owner allowed to a spender and execute a call with the sent data.
459    *
460    * approve should be called when allowed[_spender] == 0. To decrement
461    * allowed value is better to use this function to avoid 2 calls (and wait until
462    * the first transaction is mined)
463    * From MonolithDAO Token.sol
464    * @param _spender The address which will spend the funds.
465    * @param _subtractedValue The amount of tokens to decrease the allowance by.
466    * @param _data ABI-encoded contract call to call `_spender` address.
467    */
468   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
469     require(_spender != address(this));
470 
471     super.decreaseApproval(_spender, _subtractedValue);
472 
473     require(_spender.call(_data));
474 
475     return true;
476   }
477 
478 }
479 
480 
481 contract TraxionToken is ERC827Token, PausableToken {
482   
483     string public constant name = "Traxion Token";
484     string public constant symbol = "TXN";
485     uint8 public constant decimals = 18;
486     uint256 public constant INITIAL_SUPPLY = 5e8 * 10**uint256(decimals);
487 
488     constructor()  public {
489         totalSupply_ = INITIAL_SUPPLY;
490         transferOwnership(0xC889dFBDc9C1D0FC3E77e46c3b82A3903b2D919c);
491         balances[0xC889dFBDc9C1D0FC3E77e46c3b82A3903b2D919c] = INITIAL_SUPPLY;
492         emit Transfer(0x0, 0xC889dFBDc9C1D0FC3E77e46c3b82A3903b2D919c, INITIAL_SUPPLY);
493     }
494     /** @dev erc827 extension will be used by the TraxionWallet system which spawns a dynamic "Traxion Contract" in ethereum blockchain
495              through Hyperledger Fabric SDK. This bridge the communication with the hyperledger fabric API from ethereum network and vice versa. 
496              Traxion Token will be used in our system  wherein the ABI will be written for its specific transaction through out Traxion Wallet App.
497     **/
498     function approve(address spender, uint256 value, bytes data) public whenNotPaused returns (bool) {
499         return super.approve(spender, value, data);
500     }
501 
502     function transfer(address to, uint256 value, bytes data) public whenNotPaused returns (bool) {
503         return super.transfer(to, value, data);
504     }
505 
506     function increaseApproval(address spender, uint256 addedValue, bytes data) public whenNotPaused returns (bool) {
507         return super.increaseApproval(spender, addedValue, data);
508     }
509     
510     function decreaseApproval(address spender, uint256 subtractedValue, bytes data) public whenNotPaused returns (bool) {
511         return super.decreaseApproval(spender, subtractedValue, data);
512     }
513 
514     function transferFrom(address from, address to, uint256 value, bytes data) public whenNotPaused returns (bool) {
515         return super.transferFrom(from, to, value, data);
516     }
517 }