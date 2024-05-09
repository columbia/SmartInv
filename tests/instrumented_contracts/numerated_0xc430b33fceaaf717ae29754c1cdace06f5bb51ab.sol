1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, reverts on overflow.
12   */
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
14     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     uint256 c = _a * _b;
22     require(c / _a == _b);
23 
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     require(_b > 0); // Solidity only automatically asserts when dividing by 0
32     uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34 
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
42     require(_b <= _a);
43     uint256 c = _a - _b;
44 
45     return c;
46   }
47 
48   /**
49   * @dev Adds two numbers, reverts on overflow.
50   */
51   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
52     uint256 c = _a + _b;
53     require(c >= _a);
54 
55     return c;
56   }
57 
58   /**
59   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60   * reverts when dividing by zero.
61   */
62   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b != 0);
64     return a % b;
65   }
66 }
67 
68 /**
69  * @title ERC20 interface
70  * @dev see https://github.com/ethereum/EIPs/issues/20
71  */
72 contract ERC20 {
73   function totalSupply() public view returns (uint256);
74 
75   function balanceOf(address _who) public view returns (uint256);
76 
77   function allowance(address _owner, address _spender)
78     public view returns (uint256);
79 
80   function transfer(address _to, uint256 _value) public returns (bool);
81 
82   function approve(address _spender, uint256 _value)
83     public returns (bool);
84 
85   function transferFrom(address _from, address _to, uint256 _value)
86     public returns (bool);
87 
88   event Transfer(
89     address indexed from,
90     address indexed to,
91     uint256 value
92   );
93 
94   event Approval(
95     address indexed owner,
96     address indexed spender,
97     uint256 value
98   );
99 }
100 
101 /**
102  * @title Ownable
103  * @dev The Ownable contract has an owner address, and provides basic authorization control
104  * functions, this simplifies the implementation of "user permissions".
105  */
106 contract Ownable {
107   address public owner;
108 
109 
110   event OwnershipRenounced(address indexed previousOwner);
111   event OwnershipTransferred(
112     address indexed previousOwner,
113     address indexed newOwner
114   );
115 
116 
117   /**
118    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
119    * account.
120    */
121   constructor() public {
122     owner = msg.sender;
123   }
124 
125   /**
126    * @dev Throws if called by any account other than the owner.
127    */
128   modifier onlyOwner() {
129     require(msg.sender == owner);
130     _;
131   }
132 
133   /**
134    * @dev Allows the current owner to relinquish control of the contract.
135    * @notice Renouncing to ownership will leave the contract without an owner.
136    * It will not be possible to call the functions with the `onlyOwner`
137    * modifier anymore.
138    */
139   function renounceOwnership() public onlyOwner {
140     emit OwnershipRenounced(owner);
141     owner = address(0);
142   }
143 
144   /**
145    * @dev Allows the current owner to transfer control of the contract to a newOwner.
146    * @param _newOwner The address to transfer ownership to.
147    */
148   function transferOwnership(address _newOwner) public onlyOwner {
149     _transferOwnership(_newOwner);
150   }
151 
152   /**
153    * @dev Transfers control of the contract to a newOwner.
154    * @param _newOwner The address to transfer ownership to.
155    */
156   function _transferOwnership(address _newOwner) internal {
157     require(_newOwner != address(0));
158     emit OwnershipTransferred(owner, _newOwner);
159     owner = _newOwner;
160   }
161 }
162 
163 /**
164  * @title Pausable
165  * @dev Base contract which allows children to implement an emergency stop mechanism.
166  */
167 contract Pausable is Ownable {
168   event Pause();
169   event Unpause();
170 
171   bool public paused = false;
172 
173 
174   /**
175    * @dev Modifier to make a function callable only when the contract is not paused.
176    */
177   modifier whenNotPaused() {
178     require(!paused);
179     _;
180   }
181 
182   /**
183    * @dev Modifier to make a function callable only when the contract is paused.
184    */
185   modifier whenPaused() {
186     require(paused);
187     _;
188   }
189 
190   /**
191    * @dev called by the owner to pause, triggers stopped state
192    */
193   function pause() public onlyOwner whenNotPaused {
194     paused = true;
195     emit Pause();
196   }
197 
198   /**
199    * @dev called by the owner to unpause, returns to normal state
200    */
201   function unpause() public onlyOwner whenPaused {
202     paused = false;
203     emit Unpause();
204   }
205 }
206 
207 /**
208  * @title Standard ERC20 token
209  *
210  * @dev Implementation of the basic standard token.
211  * https://github.com/ethereum/EIPs/issues/20
212  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
213  */
214 contract StandardToken is ERC20 {
215   using SafeMath for uint256;
216 
217   mapping(address => uint256) balances;
218 
219   mapping (address => mapping (address => uint256)) internal allowed;
220 
221   uint256 totalSupply_;
222 
223   /**
224   * @dev Total number of tokens in existence
225   */
226   function totalSupply() public view returns (uint256) {
227     return totalSupply_;
228   }
229 
230   /**
231   * @dev Gets the balance of the specified address.
232   * @param _owner The address to query the the balance of.
233   * @return An uint256 representing the amount owned by the passed address.
234   */
235   function balanceOf(address _owner) public view returns (uint256) {
236     return balances[_owner];
237   }
238 
239   /**
240    * @dev Function to check the amount of tokens that an owner allowed to a spender.
241    * @param _owner address The address which owns the funds.
242    * @param _spender address The address which will spend the funds.
243    * @return A uint256 specifying the amount of tokens still available for the spender.
244    */
245   function allowance(
246     address _owner,
247     address _spender
248    )
249     public
250     view
251     returns (uint256)
252   {
253     return allowed[_owner][_spender];
254   }
255 
256   /**
257   * @dev Transfer token for a specified address
258   * @param _to The address to transfer to.
259   * @param _value The amount to be transferred.
260   */
261   function transfer(address _to, uint256 _value) public returns (bool) {
262     require(_value <= balances[msg.sender]);
263     require(_to != address(0));
264 
265     balances[msg.sender] = balances[msg.sender].sub(_value);
266     balances[_to] = balances[_to].add(_value);
267     emit Transfer(msg.sender, _to, _value);
268     return true;
269   }
270 
271   /**
272    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
273    * Beware that changing an allowance with this method brings the risk that someone may use both the old
274    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
275    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
276    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
277    * @param _spender The address which will spend the funds.
278    * @param _value The amount of tokens to be spent.
279    */
280   function approve(address _spender, uint256 _value) public returns (bool) {
281     allowed[msg.sender][_spender] = _value;
282     emit Approval(msg.sender, _spender, _value);
283     return true;
284   }
285 
286   /**
287    * @dev Transfer tokens from one address to another
288    * @param _from address The address which you want to send tokens from
289    * @param _to address The address which you want to transfer to
290    * @param _value uint256 the amount of tokens to be transferred
291    */
292   function transferFrom(
293     address _from,
294     address _to,
295     uint256 _value
296   )
297     public
298     returns (bool)
299   {
300     require(_value <= balances[_from]);
301     require(_value <= allowed[_from][msg.sender]);
302     require(_to != address(0));
303 
304     balances[_from] = balances[_from].sub(_value);
305     balances[_to] = balances[_to].add(_value);
306     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
307     emit Transfer(_from, _to, _value);
308     return true;
309   }
310 
311   /**
312    * @dev Increase the amount of tokens that an owner allowed to a spender.
313    * approve should be called when allowed[_spender] == 0. To increment
314    * allowed value is better to use this function to avoid 2 calls (and wait until
315    * the first transaction is mined)
316    * From MonolithDAO Token.sol
317    * @param _spender The address which will spend the funds.
318    * @param _addedValue The amount of tokens to increase the allowance by.
319    */
320   function increaseApproval(
321     address _spender,
322     uint256 _addedValue
323   )
324     public
325     returns (bool)
326   {
327     allowed[msg.sender][_spender] = (
328       allowed[msg.sender][_spender].add(_addedValue));
329     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
330     return true;
331   }
332 
333   /**
334    * @dev Decrease the amount of tokens that an owner allowed to a spender.
335    * approve should be called when allowed[_spender] == 0. To decrement
336    * allowed value is better to use this function to avoid 2 calls (and wait until
337    * the first transaction is mined)
338    * From MonolithDAO Token.sol
339    * @param _spender The address which will spend the funds.
340    * @param _subtractedValue The amount of tokens to decrease the allowance by.
341    */
342   function decreaseApproval(
343     address _spender,
344     uint256 _subtractedValue
345   )
346     public
347     returns (bool)
348   {
349     uint256 oldValue = allowed[msg.sender][_spender];
350     if (_subtractedValue >= oldValue) {
351       allowed[msg.sender][_spender] = 0;
352     } else {
353       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
354     }
355     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
356     return true;
357   }
358 
359 }
360 
361 /**
362  * Pausable token
363  *
364  * Simple ERC20 Token example, with pausable token creation
365  **/
366 
367 contract PausableToken is StandardToken, Pausable {
368 
369   function transfer(address _to, uint256 _value) public whenNotPaused returns(bool) {
370     super.transfer(_to, _value);
371   }
372 
373   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns(bool) {
374     super.transferFrom(_from, _to, _value);
375   }
376 }
377 
378 
379 /**
380  * @title ACOCoin Contract
381  */
382 contract ACOCoin is PausableToken {
383 
384   using SafeMath for uint256;
385   string public constant name = "ACOCoin";
386   string public constant symbol = "ACO";
387   uint8 public constant decimals = 18;
388 
389   uint256 public constant initialSupply_ = 1000000000 * (10 ** uint256(decimals));
390   uint256 public tokensForPublicSale = 200000000 * (10 ** 18);
391   uint256 public pricePerToken = (10 ** 16); //1 Eth = 1 ACO 
392 
393   uint256 minETH = 0 * (10**18); // 0 ether
394   uint256 maxETH = 1000 * (10**18); // 10 ether
395   
396   //Crowdsale running
397   bool public isCrowdsaleOpen=false;
398   
399   /**
400    * @dev Constructor that gives msg.sender all of existing tokens.
401    */
402   constructor() public {
403     totalSupply_ = initialSupply_;
404     balances[msg.sender] = balances[msg.sender].add(initialSupply_);
405     emit Transfer(address(0), msg.sender, initialSupply_);
406   }
407   
408    function startCrowdSale() public onlyOwner {
409      isCrowdsaleOpen=true;
410   }
411 
412    function stopCrowdSale() public onlyOwner {
413      isCrowdsaleOpen=false;
414   }
415   
416   function sendToInvestor(address _to, uint256 _value) public onlyOwner {
417     transfer(_to, _value);
418   }
419 
420 //tokensForPublicSale should be less than the balance of the owner
421 //be careful with this function
422 //should be used only if params needto change other than the default settings
423   function setPublicSaleParams(uint256 _tokensForPublicSale, uint256 _min, uint256 _max, uint256 _pricePerToken ) public onlyOwner {
424     require(_tokensForPublicSale > 0);
425     require (_tokensForPublicSale <= totalSupply_);
426     require(_pricePerToken > 0);
427     require(_min >= 0);
428     require(_max > 0);
429     pricePerToken = 0; 
430     pricePerToken = pricePerToken.add(_pricePerToken);
431     tokensForPublicSale = 0;
432     tokensForPublicSale = tokensForPublicSale.add(_tokensForPublicSale);
433     minETH = 0;
434     minETH = minETH.add(_min);
435     maxETH = 0;
436     maxETH = maxETH.add(_max);
437  }
438 
439   
440   function buyTokens() public payable returns(uint tokenAmount) {
441 
442     uint256 _tokenAmount;
443     uint256 multiplier = (10 ** 18);
444     uint256 weiAmount = msg.value;
445 
446     require(isCrowdsaleOpen);
447 
448     require(weiAmount >= minETH);
449     require(weiAmount <= maxETH);
450 
451     _tokenAmount =  weiAmount.mul(multiplier).div(pricePerToken);
452 
453     require(_tokenAmount > 0);
454 
455     //safe sub will automatically handle overflows
456     tokensForPublicSale = tokensForPublicSale.sub(_tokenAmount);
457     //transfer tokens from owner to payee
458     require(_tokenAmount <= balances[owner]);
459     balances[owner] = balances[owner].sub(_tokenAmount);
460     balances[msg.sender] = balances[msg.sender].add(_tokenAmount);
461     emit Transfer(owner, msg.sender, _tokenAmount);
462     //send money to the owner
463     require(owner.send(weiAmount));
464 
465     return _tokenAmount;
466 
467   }
468 
469   // There is no need for vesting. It will be done manually by manually releasing tokens to certain addresses
470 
471   function() public payable {
472       buyTokens();
473   }
474 
475 }