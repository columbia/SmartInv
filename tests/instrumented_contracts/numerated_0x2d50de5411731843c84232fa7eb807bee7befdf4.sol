1 pragma solidity 0.4.19;
2 
3 
4 
5 
6 
7 
8 /**
9  * @title ERC20Basic
10  * @dev Simpler version of ERC20 interface
11  * @dev see https://github.com/ethereum/EIPs/issues/179
12  */
13 contract ERC20Basic {
14   function totalSupply() public view returns (uint256);
15   function balanceOf(address who) public view returns (uint256);
16   function transfer(address to, uint256 value) public returns (bool);
17   event Transfer(address indexed from, address indexed to, uint256 value);
18 }
19 
20 /**
21  * @title SafeMath
22  * @dev Math operations with safety checks that throw on error
23  */
24 library SafeMath {
25   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
26     uint256 c = a * b;
27     assert(a == 0 || c / a == b);
28     return c;
29   }
30 
31   function div(uint256 a, uint256 b) internal constant returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37 
38   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   function add(uint256 a, uint256 b) internal constant returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title Basic token
53  * @dev Basic version of StandardToken, with no allowances.
54  */
55 contract BasicToken is ERC20Basic {
56   using SafeMath for uint256;
57 
58   mapping(address => uint256) balances;
59 
60   uint256 totalSupply_;
61 
62   /**
63   * @dev total number of tokens in existence
64   */
65   function totalSupply() public view returns (uint256) {
66     return totalSupply_;
67   }
68 
69   /**
70   * @dev transfer token for a specified address
71   * @param _to The address to transfer to.
72   * @param _value The amount to be transferred.
73   */
74   function transfer(address _to, uint256 _value) public returns (bool) {
75     require(_to != address(0));
76     require(_value <= balances[msg.sender]);
77 
78     // SafeMath.sub will throw if there is not enough balance.
79     balances[msg.sender] = balances[msg.sender].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     Transfer(msg.sender, _to, _value);
82     return true;
83   }
84 
85   /**
86   * @dev Gets the balance of the specified address.
87   * @param _owner The address to query the the balance of.
88   * @return An uint256 representing the amount owned by the passed address.
89   */
90   function balanceOf(address _owner) public view returns (uint256 balance) {
91     return balances[_owner];
92   }
93 
94 }
95 
96 
97 /**
98  * @title ERC20 interface
99  * @dev see https://github.com/ethereum/EIPs/issues/20
100  */
101 contract ERC20 is ERC20Basic {
102   function allowance(address owner, address spender) public view returns (uint256);
103   function transferFrom(address from, address to, uint256 value) public returns (bool);
104   function approve(address spender, uint256 value) public returns (bool);
105   event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 /**
109  * @title Standard ERC20 token
110  *
111  * @dev Implementation of the basic standard token.
112  * @dev https://github.com/ethereum/EIPs/issues/20
113  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
114  */
115 contract StandardToken is ERC20, BasicToken {
116 
117   mapping (address => mapping (address => uint256)) internal allowed;
118 
119 
120   /**
121    * @dev Transfer tokens from one address to another
122    * @param _from address The address which you want to send tokens from
123    * @param _to address The address which you want to transfer to
124    * @param _value uint256 the amount of tokens to be transferred
125    */
126   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
127     require(_to != address(0));
128     require(_value <= balances[_from]);
129     require(_value <= allowed[_from][msg.sender]);
130 
131     balances[_from] = balances[_from].sub(_value);
132     balances[_to] = balances[_to].add(_value);
133     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
134     Transfer(_from, _to, _value);
135     return true;
136   }
137 
138   /**
139    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
140    *
141    * Beware that changing an allowance with this method brings the risk that someone may use both the old
142    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
143    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
144    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145    * @param _spender The address which will spend the funds.
146    * @param _value The amount of tokens to be spent.
147    */
148   function approve(address _spender, uint256 _value) public returns (bool) {
149     allowed[msg.sender][_spender] = _value;
150     Approval(msg.sender, _spender, _value);
151     return true;
152   }
153 
154   /**
155    * @dev Function to check the amount of tokens that an owner allowed to a spender.
156    * @param _owner address The address which owns the funds.
157    * @param _spender address The address which will spend the funds.
158    * @return A uint256 specifying the amount of tokens still available for the spender.
159    */
160   function allowance(address _owner, address _spender) public view returns (uint256) {
161     return allowed[_owner][_spender];
162   }
163 
164   /**
165    * @dev Increase the amount of tokens that an owner allowed to a spender.
166    *
167    * approve should be called when allowed[_spender] == 0. To increment
168    * allowed value is better to use this function to avoid 2 calls (and wait until
169    * the first transaction is mined)
170    * From MonolithDAO Token.sol
171    * @param _spender The address which will spend the funds.
172    * @param _addedValue The amount of tokens to increase the allowance by.
173    */
174   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
175     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
176     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177     return true;
178   }
179 
180   /**
181    * @dev Decrease the amount of tokens that an owner allowed to a spender.
182    *
183    * approve should be called when allowed[_spender] == 0. To decrement
184    * allowed value is better to use this function to avoid 2 calls (and wait until
185    * the first transaction is mined)
186    * From MonolithDAO Token.sol
187    * @param _spender The address which will spend the funds.
188    * @param _subtractedValue The amount of tokens to decrease the allowance by.
189    */
190   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
191     uint oldValue = allowed[msg.sender][_spender];
192     if (_subtractedValue > oldValue) {
193       allowed[msg.sender][_spender] = 0;
194     } else {
195       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
196     }
197     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
198     return true;
199   }
200 
201 }
202 
203 
204 /**
205  * @title Ownable
206  * @dev The Ownable contract has an owner address, and provides basic authorization control
207  * functions, this simplifies the implementation of "user permissions".
208  */
209 contract Ownable {
210   address public owner;
211 
212 
213   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
214 
215 
216   /**
217    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
218    * account.
219    */
220   function Ownable() public {
221     owner = msg.sender;
222   }
223 
224   /**
225    * @dev Throws if called by any account other than the owner.
226    */
227   modifier onlyOwner() {
228     require(msg.sender == owner);
229     _;
230   }
231 
232   /**
233    * @dev Allows the current owner to transfer control of the contract to a newOwner.
234    * @param newOwner The address to transfer ownership to.
235    */
236   function transferOwnership(address newOwner) public onlyOwner {
237     require(newOwner != address(0));
238     OwnershipTransferred(owner, newOwner);
239     owner = newOwner;
240   }
241 
242 }
243 
244 /**
245  * @title Mintable token
246  * @dev Simple ERC20 Token example, with mintable token creation
247  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
248  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
249  */
250 contract MintableToken is StandardToken, Ownable {
251   event Mint(address indexed to, uint256 amount);
252   event MintFinished();
253 
254   bool public mintingFinished = false;
255 
256 
257   modifier canMint() {
258     require(!mintingFinished);
259     _;
260   }
261 
262   /**
263    * @dev Function to mint tokens
264    * @param _to The address that will receive the minted tokens.
265    * @param _amount The amount of tokens to mint.
266    * @return A boolean that indicates if the operation was successful.
267    */
268   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
269     totalSupply_ = totalSupply_.add(_amount);
270     balances[_to] = balances[_to].add(_amount);
271     Mint(_to, _amount);
272     Transfer(address(0), _to, _amount);
273     return true;
274   }
275 
276   /**
277    * @dev Function to stop minting new tokens.
278    * @return True if the operation was successful.
279    */
280   function finishMinting() onlyOwner canMint public returns (bool) {
281     mintingFinished = true;
282     MintFinished();
283     return true;
284   }
285 }
286 
287 
288 
289 
290 
291 /**
292  * @title Pausable
293  * @dev Base contract which allows children to implement an emergency stop mechanism.
294  */
295 contract Pausable is Ownable {
296   event Pause();
297   event Unpause();
298 
299   bool public paused = false;
300 
301 
302   /**
303    * @dev Modifier to make a function callable only when the contract is not paused.
304    */
305   modifier whenNotPaused() {
306     require(!paused);
307     _;
308   }
309 
310   /**
311    * @dev Modifier to make a function callable only when the contract is paused.
312    */
313   modifier whenPaused() {
314     require(paused);
315     _;
316   }
317 
318   /**
319    * @dev called by the owner to pause, triggers stopped state
320    */
321   function pause() onlyOwner whenNotPaused public {
322     paused = true;
323     Pause();
324   }
325 
326   /**
327    * @dev called by the owner to unpause, returns to normal state
328    */
329   function unpause() onlyOwner whenPaused public {
330     paused = false;
331     Unpause();
332   }
333 }
334 
335 /**
336  * @title Pausable token
337  * @dev StandardToken modified with pausable transfers.
338  **/
339 contract PausableToken is StandardToken, Pausable {
340 
341   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
342     return super.transfer(_to, _value);
343   }
344 
345   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
346     return super.transferFrom(_from, _to, _value);
347   }
348 
349   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
350     return super.approve(_spender, _value);
351   }
352 
353   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
354     return super.increaseApproval(_spender, _addedValue);
355   }
356 
357   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
358     return super.decreaseApproval(_spender, _subtractedValue);
359   }
360 }
361 
362 contract Token is MintableToken, PausableToken {
363     string public constant name = "MOAT";
364     string public constant symbol = "MOAT";
365     uint8 public constant decimals = 18;
366 }
367 
368 /* solhint-disable not-rely-on-time */
369 /**
370  * @title Crowdsale
371  * @dev Crowdsale is a base contract for managing a token crowdsale.
372  * Crowdsales have a start and end timestamps, where investors can make
373  * token purchases and the crowdsale will assign them tokens based
374  * on a token per ETH baseRate. Funds collected are forwarded to a wallet
375  * as they arrive.
376  */
377 contract ICO is Ownable {
378     using SafeMath for uint256;
379 
380     // The token being sold
381     Token public token;
382     uint public MINIMUMCONTIB =  0.01 ether;
383 
384     // start and end timestamps where investments are allowed (both inclusive) ICO
385     uint256 public startTimeIco;
386     uint256 public endTimeIco;
387 
388     // address where funds are collected
389     address public wallet;
390 
391     // how many token units a buyer gets per wei
392     uint256 public baseRate;
393 
394     // amount of raised money in wei
395     uint256 public weiRaised;
396 
397     // amount of tokens created
398     uint256 public tokensIssuedIco;
399 
400     // Total number of    tokens for the ICO
401     uint256 constant public TOTAL_TOKENS_ICO = 125 * (10**7) * (10**18); // 18 decmals
402 
403     /**
404       * event for token purchase logging
405       * @param purchaser who paid for the tokens
406       * @param beneficiary who got the tokens
407       * @param value weis paid for purchase
408       * @param amount amount of tokens purchased
409       */
410     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
411 
412     /**
413       * event for token claimed from Pre-ICO
414       * @param purchaser who claimed the tokens
415       * @param amount amount of tokens claimed
416       */
417     event TokenClaimed(address indexed purchaser, uint256 amount);
418 
419     /**
420       * event for wei contributed to Pre-ICO
421       * @param purchaser who paid for the tokens
422       * @param beneficiary who got the tokens
423       * @param value weis paid for purchase
424       * @param effectiveValue effective amount after discoutns
425       */
426     event WeiContributed(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 effectiveValue);
427 
428     function ICO(address _wallet, address _token) public {
429         require(_wallet != 0x0);
430         require(_token != 0x0);
431 
432         token = Token(_token);
433         startTimeIco = 0;
434         endTimeIco = 0;
435         wallet = _wallet;
436     }
437 
438     function setICOParams(uint256 _startTimeIco, uint256 _endTimeIco, uint256 _baseRate) public onlyOwner {
439         require(_startTimeIco!=0);
440         require(_endTimeIco!=0);
441         require(startTimeIco==0);
442         require(endTimeIco==0);
443         require(_endTimeIco>_startTimeIco);
444         startTimeIco = _startTimeIco;
445         endTimeIco = _endTimeIco;
446         baseRate = _baseRate;
447     }
448 
449     // fallback function can be used to buy tokens or participate in pre-ico
450     function () public payable {
451         require(msg.value >= MINIMUMCONTIB);
452         if (validPurchaseIco(msg.value)) {
453             buyTokensIco(msg.sender);
454         } else {
455             require(false);
456         }
457     }
458 
459     function setBaseRate(uint256 _baseRate) public onlyOwner {
460         require(now < startTimeIco);
461 
462         baseRate = _baseRate;
463     }
464 
465     function reclaimToken() external onlyOwner {
466        require(hasEndedIco() || startTimeIco == 0);
467        uint256 balance = token.balanceOf(this);
468        token.transfer(owner, balance);
469    }
470 
471     // function to get current rate for ICO purchases
472     function getRateIco() public constant returns (uint256) {
473         if(now > endTimeIco) 
474             return 0;
475         else {
476             return baseRate;    
477         }
478     }
479 
480     // low level token purchase function
481     function buyTokensIco(address _beneficiary) internal {
482         require(_beneficiary != 0x0);
483 
484         // calculate token amount to be created
485         uint256 rate = getRateIco();
486         uint256 tokens = msg.value.mul(10 ** 18).div(rate);
487 
488         // update state
489         weiRaised = weiRaised.add(msg.value);
490         tokensIssuedIco = tokensIssuedIco.add(tokens);
491         token.transfer(_beneficiary, tokens);
492 
493         // issue events
494         TokenPurchase(msg.sender, _beneficiary, msg.value, tokens);
495 
496         //forward eth
497         forwardFunds();
498     }
499 
500     // send ether to the fund collection wallet
501     function forwardFunds() internal {
502         wallet.transfer(msg.value);
503     }
504 
505     // @return true if the transaction can buy tokens from ICO
506     function validPurchaseIco(uint256 _amount) public constant returns (bool) {
507         bool withinPeriod = now >= startTimeIco && now <= endTimeIco;
508         bool nonZeroPurchase = _amount != 0;
509         return withinPeriod && nonZeroPurchase;
510     }
511 
512     // @return true if ICO event has ended
513     function hasEndedIco() internal constant returns (bool) {
514         return now > endTimeIco;
515     }
516 }