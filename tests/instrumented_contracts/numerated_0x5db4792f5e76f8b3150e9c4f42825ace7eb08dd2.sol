1 pragma solidity ^0.4.18;
2 
3 // File: contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: contracts/Dividends.sol
52 
53 contract DividendContract {
54   using SafeMath for uint256;
55   event Dividends(uint256 round, uint256 value);
56   event ClaimDividends(address investor, uint256 value);
57 
58   uint256 totalDividendsAmount = 0;
59   uint256 totalDividendsRounds = 0;
60   uint256 totalUnPayedDividendsAmount = 0;
61   mapping(address => uint256) payedDividends;
62 
63 
64   function getTotalDividendsAmount() public constant returns (uint256) {
65     return totalDividendsAmount;
66   }
67 
68   function getTotalDividendsRounds() public constant returns (uint256) {
69     return totalDividendsRounds;
70   }
71 
72   function getTotalUnPayedDividendsAmount() public constant returns (uint256) {
73     return totalUnPayedDividendsAmount;
74   }
75 
76   function dividendsAmount(address investor) public constant returns (uint256);
77   function claimDividends() payable public;
78 
79   function payDividends() payable public {
80     require(msg.value > 0);
81     totalDividendsAmount = totalDividendsAmount.add(msg.value);
82     totalUnPayedDividendsAmount = totalUnPayedDividendsAmount.add(msg.value);
83     totalDividendsRounds += 1;
84     Dividends(totalDividendsRounds, msg.value);
85   }
86 }
87 
88 // File: contracts/token/ERC20/ERC20Basic.sol
89 
90 /**
91  * @title ERC20Basic
92  * @dev Simpler version of ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/179
94  */
95 contract ERC20Basic {
96   function totalSupply() public view returns (uint256);
97   function balanceOf(address who) public view returns (uint256);
98   function transfer(address to, uint256 value) public returns (bool);
99   event Transfer(address indexed from, address indexed to, uint256 value);
100 }
101 
102 // File: contracts/token/ERC20/ERC20.sol
103 
104 /**
105  * @title ERC20 interface
106  * @dev see https://github.com/ethereum/EIPs/issues/20
107  */
108 contract ERC20 is ERC20Basic {
109   function allowance(address owner, address spender) public view returns (uint256);
110   function transferFrom(address from, address to, uint256 value) public returns (bool);
111   function approve(address spender, uint256 value) public returns (bool);
112   event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114 
115 // File: contracts/ESlotsICOToken.sol
116 
117 contract ESlotsICOToken is ERC20, DividendContract {
118 
119     string public constant name = "Ethereum Slot Machine Token";
120     string public constant symbol = "EST";
121     uint8 public constant decimals = 18;
122 
123     function maxTokensToSale() public view returns (uint256);
124     function availableTokens() public view returns (uint256);
125     function completeICO() public;
126     function connectCrowdsaleContract(address crowdsaleContract) public;
127 }
128 
129 // File: contracts/ownership/Ownable.sol
130 
131 /**
132  * @title Ownable
133  * @dev The Ownable contract has an owner address, and provides basic authorization control
134  * functions, this simplifies the implementation of "user permissions".
135  */
136 contract Ownable {
137   address public owner;
138 
139 
140   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
141 
142 
143   /**
144    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
145    * account.
146    */
147   function Ownable() public {
148     owner = msg.sender;
149   }
150 
151   /**
152    * @dev Throws if called by any account other than the owner.
153    */
154   modifier onlyOwner() {
155     require(msg.sender == owner);
156     _;
157   }
158 
159   /**
160    * @dev Allows the current owner to transfer control of the contract to a newOwner.
161    * @param newOwner The address to transfer ownership to.
162    */
163   function transferOwnership(address newOwner) public onlyOwner {
164     require(newOwner != address(0));
165     OwnershipTransferred(owner, newOwner);
166     owner = newOwner;
167   }
168 
169 }
170 
171 // File: contracts/token/ERC20/BasicToken.sol
172 
173 /**
174  * @title Basic token
175  * @dev Basic version of StandardToken, with no allowances.
176  */
177 contract BasicToken is ERC20Basic {
178   using SafeMath for uint256;
179 
180   mapping(address => uint256) balances;
181 
182   uint256 totalSupply_;
183 
184   /**
185   * @dev total number of tokens in existence
186   */
187   function totalSupply() public view returns (uint256) {
188     return totalSupply_;
189   }
190 
191   /**
192   * @dev transfer token for a specified address
193   * @param _to The address to transfer to.
194   * @param _value The amount to be transferred.
195   */
196   function transfer(address _to, uint256 _value) public returns (bool) {
197     require(_to != address(0));
198     require(_value <= balances[msg.sender]);
199 
200     // SafeMath.sub will throw if there is not enough balance.
201     balances[msg.sender] = balances[msg.sender].sub(_value);
202     balances[_to] = balances[_to].add(_value);
203     Transfer(msg.sender, _to, _value);
204     return true;
205   }
206 
207   /**
208   * @dev Gets the balance of the specified address.
209   * @param _owner The address to query the the balance of.
210   * @return An uint256 representing the amount owned by the passed address.
211   */
212   function balanceOf(address _owner) public view returns (uint256 balance) {
213     return balances[_owner];
214   }
215 
216 }
217 
218 // File: contracts/token/ERC20/BurnableToken.sol
219 
220 /**
221  * @title Burnable Token
222  * @dev Token that can be irreversibly burned (destroyed).
223  */
224 contract BurnableToken is BasicToken {
225 
226   event Burn(address indexed burner, uint256 value);
227 
228   /**
229    * @dev Burns a specific amount of tokens.
230    * @param _value The amount of token to be burned.
231    */
232   function burn(uint256 _value) public {
233     require(_value <= balances[msg.sender]);
234     // no need to require value <= totalSupply, since that would imply the
235     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
236 
237     address burner = msg.sender;
238     balances[burner] = balances[burner].sub(_value);
239     totalSupply_ = totalSupply_.sub(_value);
240     Burn(burner, _value);
241   }
242 }
243 
244 // File: contracts/token/ERC20/StandardToken.sol
245 
246 /**
247  * @title Standard ERC20 token
248  *
249  * @dev Implementation of the basic standard token.
250  * @dev https://github.com/ethereum/EIPs/issues/20
251  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
252  */
253 contract StandardToken is ERC20, BasicToken {
254 
255   mapping (address => mapping (address => uint256)) internal allowed;
256 
257 
258   /**
259    * @dev Transfer tokens from one address to another
260    * @param _from address The address which you want to send tokens from
261    * @param _to address The address which you want to transfer to
262    * @param _value uint256 the amount of tokens to be transferred
263    */
264   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
265     require(_to != address(0));
266     require(_value <= balances[_from]);
267     require(_value <= allowed[_from][msg.sender]);
268 
269     balances[_from] = balances[_from].sub(_value);
270     balances[_to] = balances[_to].add(_value);
271     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
272     Transfer(_from, _to, _value);
273     return true;
274   }
275 
276   /**
277    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
278    *
279    * Beware that changing an allowance with this method brings the risk that someone may use both the old
280    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
281    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
282    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
283    * @param _spender The address which will spend the funds.
284    * @param _value The amount of tokens to be spent.
285    */
286   function approve(address _spender, uint256 _value) public returns (bool) {
287     allowed[msg.sender][_spender] = _value;
288     Approval(msg.sender, _spender, _value);
289     return true;
290   }
291 
292   /**
293    * @dev Function to check the amount of tokens that an owner allowed to a spender.
294    * @param _owner address The address which owns the funds.
295    * @param _spender address The address which will spend the funds.
296    * @return A uint256 specifying the amount of tokens still available for the spender.
297    */
298   function allowance(address _owner, address _spender) public view returns (uint256) {
299     return allowed[_owner][_spender];
300   }
301 
302   /**
303    * @dev Increase the amount of tokens that an owner allowed to a spender.
304    *
305    * approve should be called when allowed[_spender] == 0. To increment
306    * allowed value is better to use this function to avoid 2 calls (and wait until
307    * the first transaction is mined)
308    * From MonolithDAO Token.sol
309    * @param _spender The address which will spend the funds.
310    * @param _addedValue The amount of tokens to increase the allowance by.
311    */
312   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
313     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
314     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
315     return true;
316   }
317 
318   /**
319    * @dev Decrease the amount of tokens that an owner allowed to a spender.
320    *
321    * approve should be called when allowed[_spender] == 0. To decrement
322    * allowed value is better to use this function to avoid 2 calls (and wait until
323    * the first transaction is mined)
324    * From MonolithDAO Token.sol
325    * @param _spender The address which will spend the funds.
326    * @param _subtractedValue The amount of tokens to decrease the allowance by.
327    */
328   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
329     uint oldValue = allowed[msg.sender][_spender];
330     if (_subtractedValue > oldValue) {
331       allowed[msg.sender][_spender] = 0;
332     } else {
333       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
334     }
335     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
336     return true;
337   }
338 
339 }
340 
341 // File: contracts/ESlotsToken.sol
342 
343 /**
344  * @title eSlotsToken
345  * @dev See more info https://eslots.io
346  */
347 contract ESlotsToken is Ownable, StandardToken, ESlotsICOToken {
348 
349   event Burn(address indexed burner, uint256 value);
350 
351   enum State { ActiveICO, CompletedICO }
352   State public state;
353 
354   uint256 public constant INITIAL_SUPPLY = 50000000 * (10 ** uint256(decimals));
355 
356   address founders = 0x7b97B31E12f7d029769c53cB91c83d29611A4F7A;
357   uint256 public constant foundersStake = 10; //10% to founders
358   uint256 public constant dividendRoundsBeforeFoundersStakeUnlock = 4;
359   uint256 maxFoundersTokens;
360   uint256 tokensToSale;
361 
362   uint256 transferGASUsage;
363 
364   /**
365    * @dev Constructor that gives msg.sender all of existing tokens.
366    */
367   function ESlotsToken() public {
368     totalSupply_ = INITIAL_SUPPLY;
369     maxFoundersTokens = INITIAL_SUPPLY.mul(foundersStake).div(100);
370     tokensToSale = INITIAL_SUPPLY - maxFoundersTokens;
371     balances[msg.sender] = tokensToSale;
372     Transfer(0x0, msg.sender, balances[msg.sender]);
373     state = State.ActiveICO;
374     transferGASUsage = 21000;
375   }
376 
377   function maxTokensToSale() public view returns (uint256) {
378     return tokensToSale;
379   }
380 
381   function availableTokens() public view returns (uint256) {
382     return balances[owner];
383   }
384 
385   function setGasUsage(uint256 newGasUsage) public onlyOwner {
386     transferGASUsage = newGasUsage;
387   }
388 
389   //run it after ESlotsCrowdsale contract is deployed to approve token spending
390   function connectCrowdsaleContract(address crowdsaleContract) public onlyOwner {
391     approve(crowdsaleContract, balances[owner]);
392   }
393 
394   //burn unsold tokens
395   function completeICO() public onlyOwner {
396     require(state == State.ActiveICO);
397     state = State.CompletedICO;
398     uint256 soldTokens = tokensToSale.sub(balances[owner]);
399     uint256 foundersTokens = soldTokens.mul(foundersStake).div(100);
400     if(foundersTokens > maxFoundersTokens) {
401       //normally we never reach this point
402       foundersTokens = maxFoundersTokens;
403     }
404     BasicToken.transfer(founders, foundersTokens);
405     totalSupply_ = soldTokens.add(foundersTokens);
406     balances[owner] = 0;
407     Burn(msg.sender, INITIAL_SUPPLY.sub(totalSupply_));
408   }
409 
410 
411   //handle dividends
412   function transfer(address _to, uint256 _value) public returns (bool) {
413     if(msg.sender == founders) {
414       //lock operation with tokens for founders
415       require(totalDividendsAmount > 0 && totalDividendsRounds > dividendRoundsBeforeFoundersStakeUnlock);
416     }
417     //transfer is allowed only then all dividends are claimed
418     require(payedDividends[msg.sender] == totalDividendsAmount);
419     require(balances[_to] == 0 || payedDividends[_to] == totalDividendsAmount);
420     bool res =  BasicToken.transfer(_to, _value);
421     if(res && payedDividends[_to] != totalDividendsAmount) {
422       payedDividends[_to] = totalDividendsAmount;
423     }
424     return res;
425   }
426 
427   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
428     if(msg.sender == founders) {
429       //lock operation with tokens for founders
430       require(totalDividendsAmount > 0 && totalDividendsRounds > dividendRoundsBeforeFoundersStakeUnlock);
431     }
432     //transfer is allowed only then all dividends are claimed
433     require(payedDividends[_from] == totalDividendsAmount);
434     require(balances[_to] == 0 || payedDividends[_to] == totalDividendsAmount);
435     bool res = StandardToken.transferFrom(_from, _to, _value);
436     if(res && payedDividends[_to] != totalDividendsAmount) {
437       payedDividends[_to] = totalDividendsAmount;
438     }
439     return res;
440   }
441 
442   //Dividends
443 
444   modifier onlyThenCompletedICO {
445     require(state == State.CompletedICO);
446     _;
447   }
448 
449   function dividendsAmount(address investor) public onlyThenCompletedICO constant returns (uint256)  {
450     if(totalSupply_ == 0) {return 0;}
451     if(balances[investor] == 0) {return 0;}
452     if(payedDividends[investor] >= totalDividendsAmount) {return 0;}
453     return (totalDividendsAmount - payedDividends[investor]).mul(balances[investor]).div(totalSupply_);
454   }
455 
456   function claimDividends() payable public onlyThenCompletedICO {
457     //gasUsage = 0 because a caller pays for that
458     sendDividends(msg.sender, 0);
459 
460   }
461 
462   //force dividend payments if they hasn't been claimed by token holder before
463   function pushDividends(address investor) payable public onlyThenCompletedICO {
464     //because we pay for gas
465     sendDividends(investor, transferGASUsage.mul(tx.gasprice));
466   }
467 
468   function sendDividends(address investor, uint256 gasUsage) internal {
469     uint256 value = dividendsAmount(investor);
470     require(value > gasUsage);
471     payedDividends[investor] = totalDividendsAmount;
472     totalUnPayedDividendsAmount = totalUnPayedDividendsAmount.sub(value);
473     investor.transfer(value.sub(gasUsage));
474     ClaimDividends(investor, value);
475   }
476 
477   function payDividends() payable public onlyThenCompletedICO {
478     DividendContract.payDividends();
479   }
480 }