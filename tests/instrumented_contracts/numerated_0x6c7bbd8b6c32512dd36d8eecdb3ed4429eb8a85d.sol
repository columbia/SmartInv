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
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58 
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   function Ownable() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     emit OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 /**
90  * @title Pausable
91  * @dev Base contract which allows children to implement an emergency stop mechanism.
92  */
93 contract Pausable is Ownable {
94   event Pause();
95   event Unpause();
96 
97   bool public paused = false;
98 
99 
100   /**
101    * @dev Modifier to make a function callable only when the contract is not paused.
102    */
103   modifier whenNotPaused() {
104     require(!paused);
105     _;
106   }
107 
108   /**
109    * @dev Modifier to make a function callable only when the contract is paused.
110    */
111   modifier whenPaused() {
112     require(paused);
113     _;
114   }
115 
116   /**
117    * @dev called by the owner to pause, triggers stopped state
118    */
119   function pause() onlyOwner whenNotPaused public {
120     paused = true;
121     emit Pause();
122   }
123 
124   /**
125    * @dev called by the owner to unpause, returns to normal state
126    */
127   function unpause() onlyOwner whenPaused public {
128     paused = false;
129     emit Unpause();
130   }
131 }
132 /**
133  * @title ERC20Basic
134  * @dev Simpler version of ERC20 interface
135  * @dev see https://github.com/ethereum/EIPs/issues/179
136  */
137 contract ERC20Basic {
138   function totalSupply() public view returns (uint256);
139   function balanceOf(address who) public view returns (uint256);
140   function transfer(address to, uint256 value) public returns (bool);
141   event Transfer(address indexed from, address indexed to, uint256 value);
142 }
143 
144 /**
145  * @title ERC20 interface
146  * @dev see https://github.com/ethereum/EIPs/issues/20
147  */
148 contract ERC20 is ERC20Basic {
149   function allowance(address owner, address spender) public view returns (uint256);
150   function transferFrom(address from, address to, uint256 value) public returns (bool);
151   function approve(address spender, uint256 value) public returns (bool);
152   event Approval(address indexed owner, address indexed spender, uint256 value);
153 }
154 
155 /**
156  * @title Basic token
157  * @dev Basic version of StandardToken, with no allowances.
158  */
159 contract BasicToken is ERC20Basic {
160   using SafeMath for uint256;
161 
162   mapping(address => uint256) balances;
163 
164   uint256 totalSupply_;
165 
166   /**
167   * @dev total number of tokens in existence
168   */
169   function totalSupply() public view returns (uint256) {
170     return totalSupply_;
171   }
172 
173   /**
174   * @dev transfer token for a specified address
175   * @param _to The address to transfer to.
176   * @param _value The amount to be transferred.
177   */
178   function transfer(address _to, uint256 _value) public returns (bool) {
179     require(_to != address(0));
180     require(_value <= balances[msg.sender]);
181 
182     // SafeMath.sub will throw if there is not enough balance.
183     balances[msg.sender] = balances[msg.sender].sub(_value);
184     balances[_to] = balances[_to].add(_value);
185     emit Transfer(msg.sender, _to, _value);
186     return true;
187   }
188 
189   /**
190   * @dev Gets the balance of the specified address.
191   * @param _owner The address to query the the balance of.
192   * @return An uint256 representing the amount owned by the passed address.
193   */
194   function balanceOf(address _owner) public view returns (uint256 balance) {
195     return balances[_owner];
196   }
197 
198 }
199 
200 /**
201  * @title Standard ERC20 token
202  *
203  * @dev Implementation of the basic standard token.
204  * @dev https://github.com/ethereum/EIPs/issues/20
205  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
206  */
207 contract StandardToken is ERC20, BasicToken {
208 
209   mapping (address => mapping (address => uint256)) internal allowed;
210 
211 
212   /**
213    * @dev Transfer tokens from one address to another
214    * @param _from address The address which you want to send tokens from
215    * @param _to address The address which you want to transfer to
216    * @param _value uint256 the amount of tokens to be transferred
217    */
218   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
219     require(_to != address(0));
220     require(_value <= balances[_from]);
221     require(_value <= allowed[_from][msg.sender]);
222 
223     balances[_from] = balances[_from].sub(_value);
224     balances[_to] = balances[_to].add(_value);
225     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
226     emit Transfer(_from, _to, _value);
227     return true;
228   }
229 
230   /**
231    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
232    *
233    * Beware that changing an allowance with this method brings the risk that someone may use both the old
234    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
235    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
236    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
237    * @param _spender The address which will spend the funds.
238    * @param _value The amount of tokens to be spent.
239    */
240   function approve(address _spender, uint256 _value) public returns (bool) {
241     allowed[msg.sender][_spender] = _value;
242     emit Approval(msg.sender, _spender, _value);
243     return true;
244   }
245 
246   /**
247    * @dev Function to check the amount of tokens that an owner allowed to a spender.
248    * @param _owner address The address which owns the funds.
249    * @param _spender address The address which will spend the funds.
250    * @return A uint256 specifying the amount of tokens still available for the spender.
251    */
252   function allowance(address _owner, address _spender) public view returns (uint256) {
253     return allowed[_owner][_spender];
254   }
255 
256   /**
257    * @dev Increase the amount of tokens that an owner allowed to a spender.
258    *
259    * approve should be called when allowed[_spender] == 0. To increment
260    * allowed value is better to use this function to avoid 2 calls (and wait until
261    * the first transaction is mined)
262    * From MonolithDAO Token.sol
263    * @param _spender The address which will spend the funds.
264    * @param _addedValue The amount of tokens to increase the allowance by.
265    */
266   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
267     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
268     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
269     return true;
270   }
271 
272   /**
273    * @dev Decrease the amount of tokens that an owner allowed to a spender.
274    *
275    * approve should be called when allowed[_spender] == 0. To decrement
276    * allowed value is better to use this function to avoid 2 calls (and wait until
277    * the first transaction is mined)
278    * From MonolithDAO Token.sol
279    * @param _spender The address which will spend the funds.
280    * @param _subtractedValue The amount of tokens to decrease the allowance by.
281    */
282   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
283     uint oldValue = allowed[msg.sender][_spender];
284     if (_subtractedValue > oldValue) {
285       allowed[msg.sender][_spender] = 0;
286     } else {
287       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
288     }
289     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
290     return true;
291   }
292 
293 }
294 
295 /**
296  * @title Gene Nuggets Token
297  *
298  * @dev Implementation of the Gene Nuggets Token.
299  */
300 contract GeneNuggetsToken is Pausable,StandardToken {
301   using SafeMath for uint256;
302   
303   string public name = "Gene Nuggets";
304   string public symbol = "GNUS";
305    
306   //constants
307   uint8 public decimals = 6;
308   uint256 public decimalFactor = 10 ** uint256(decimals);
309   uint public CAP = 30e8 * decimalFactor; //Maximal GNUG supply = 3 billion
310   
311   //contract state
312   uint256 public circulatingSupply;
313   uint256 public totalUsers;
314   uint256 public exchangeLimit = 10000*decimalFactor;
315   uint256 public exchangeThreshold = 2000*decimalFactor;
316   uint256 public exchangeInterval = 60;
317   uint256 public destroyThreshold = 100*decimalFactor;
318  
319   //managers address
320   address public CFO; //CFO address
321   mapping(address => uint256) public CustomerService; //customer service addresses
322   
323   //mining rules
324   uint[10] public MINING_LAYERS = [0,10e4,30e4,100e4,300e4,600e4,1000e4,2000e4,3000e4,2**256 - 1];
325   uint[9] public MINING_REWARDS = [1000*decimalFactor,600*decimalFactor,300*decimalFactor,200*decimalFactor,180*decimalFactor,160*decimalFactor,60*decimalFactor,39*decimalFactor,0];
326   
327   //events
328   event UpdateTotal(uint totalUser,uint totalSupply);
329   event Exchange(address indexed user,uint256 amount);
330   event Destory(address indexed user,uint256 amount);
331 
332   modifier onlyCFO() {
333     require(msg.sender == CFO);
334     _;
335   }
336 
337 
338   modifier onlyCustomerService() {
339     require(CustomerService[msg.sender] != 0);
340     _;
341   }
342 
343   /**
344   * @dev ccontract constructor
345   */  
346   function GeneNuggetsToken() public {}
347 
348   /**
349   * @dev fallback revert eth transfer
350   */   
351   function() public {
352     revert();
353   }
354   
355   /**
356    * @dev Allows the current owner to change token name.
357    * @param newName The name to change to.
358    */
359   function setName(string newName) external onlyOwner {
360     name = newName;
361   }
362   
363   /**
364    * @dev Allows the current owner to change token symbol.
365    * @param newSymbol The symbol to change to.
366    */
367   function setSymbol(string newSymbol) external onlyOwner {
368     symbol = newSymbol;
369   }
370   
371   /**
372    * @dev Allows the current owner to change CFO address.
373    * @param newCFO The address to change to.
374    */
375   function setCFO(address newCFO) external onlyOwner {
376     CFO = newCFO;
377   }
378   
379   /**
380    * @dev Allows owner to change exchangeInterval.
381    * @param newInterval The new interval to change to.
382    */
383   function setExchangeInterval(uint newInterval) external onlyCFO {
384     exchangeInterval = newInterval;
385   }
386 
387   /**
388    * @dev Allows owner to change exchangeLimit.
389    * @param newLimit The new limit to change to.
390    */
391   function setExchangeLimit(uint newLimit) external onlyCFO {
392     exchangeLimit = newLimit;
393   }
394 
395   /**
396    * @dev Allows owner to change exchangeThreshold.
397    * @param newThreshold The new threshold to change to.
398    */
399   function setExchangeThreshold(uint newThreshold) external onlyCFO {
400     exchangeThreshold = newThreshold;
401   }
402   
403   /**
404    * @dev Allows owner to change destroyThreshold.
405    * @param newThreshold The new threshold to change to.
406    */
407   function setDestroyThreshold(uint newThreshold) external onlyCFO {
408     destroyThreshold = newThreshold;
409   }
410   
411   /**
412    * @dev Allows CFO to add customer service address.
413    * @param cs The address to add.
414    */
415   function addCustomerService(address cs) onlyCFO external {
416     CustomerService[cs] = block.timestamp;
417   }
418   
419   /**
420    * @dev Allows CFO to remove customer service address.
421    * @param cs The address to remove.
422    */
423   function removeCustomerService(address cs) onlyCFO external {
424     CustomerService[cs] = 0;
425   }
426 
427   /**
428    * @dev Function to allow CFO update tokens amount according to user amount.Attention: newly mined token still outside contract until exchange on user's requirments.  
429    * @param _userAmount current gene nuggets user amount.
430    */
431   function updateTotal(uint256 _userAmount) onlyCFO external {
432     require(_userAmount>totalUsers);
433     uint newTotalSupply = calTotalSupply(_userAmount);
434     require(newTotalSupply<=CAP && newTotalSupply>totalSupply_);
435     
436     uint _amount = newTotalSupply.sub(totalSupply_);
437     totalSupply_ = newTotalSupply;
438     totalUsers = _userAmount;
439     emit UpdateTotal(_amount,totalSupply_); 
440   }
441 
442   /**
443    * @dev Uitl function to calculate total supply according to total user amount.
444    * @param _userAmount total user amount.
445    */  
446   function calTotalSupply(uint _userAmount) private view returns (uint ret) {
447     uint tokenAmount = 0;
448 	  for (uint8 i = 0; i < MINING_LAYERS.length ; i++ ) {
449 	    if(_userAmount < MINING_LAYERS[i+1]) {
450 	      tokenAmount = tokenAmount.add(MINING_REWARDS[i].mul(_userAmount.sub(MINING_LAYERS[i])));
451 	      break;
452 	    }else {
453         tokenAmount = tokenAmount.add(MINING_REWARDS[i].mul(MINING_LAYERS[i+1].sub(MINING_LAYERS[i])));
454 	    }
455 	  }
456 	  return tokenAmount;
457   }
458 
459   /**
460    * @dev Function for Customer Service exchange off-chain points to GNUG on user's behalf. That is to say exchange GNUG into this contract.
461    * @param user The user tokens distributed to.
462    * @param _amount The amount of tokens to exchange.
463    */
464   function exchange(address user,uint256 _amount) whenNotPaused onlyCustomerService external {
465   	
466   	require((block.timestamp-CustomerService[msg.sender])>exchangeInterval);
467 
468   	require(_amount <= exchangeLimit && _amount >= exchangeThreshold);
469 
470     circulatingSupply = circulatingSupply.add(_amount);
471     
472     balances[user] = balances[user].add(_amount);
473     
474     CustomerService[msg.sender] = block.timestamp;
475     
476     emit Exchange(user,_amount);
477     
478     emit Transfer(address(0),user,_amount);
479     
480   }
481   
482 
483   /**
484    * @dev Function for user can destory GNUG, exchange back to off-chain points.That is to say destroy GNUG out of this contract.
485    * @param _amount The amount of tokens to destory.
486    */
487   function destory(uint256 _amount) external {  
488     require(balances[msg.sender]>=_amount && _amount>destroyThreshold && circulatingSupply>=_amount);
489 
490     circulatingSupply = circulatingSupply.sub(_amount);
491     
492     balances[msg.sender] = balances[msg.sender].sub(_amount);
493     
494     emit Destory(msg.sender,_amount);
495     
496     emit Transfer(msg.sender,0x0,_amount);
497     
498   }
499 
500   function emergencyERC20Drain( ERC20 token, uint amount ) onlyOwner external {
501     // owner can drain tokens that are sent here by mistake
502     token.transfer( owner, amount );
503   }
504   
505 }