1 pragma solidity ^0.4.11;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
8     uint256 c = a * b;
9     if ((a == 0) || (c / a == b)) {
10       return c;
11     }
12     revert();
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     uint256 c = a / b;
17     if (a == b * c + a % b) {
18       return c;
19     }
20     revert();
21   }
22 
23   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
24     if (b <= a) {
25       return a - b;
26     }
27     revert();
28   }
29 
30   function add(uint256 a, uint256 b) internal constant returns (uint256) {
31     uint256 c = a + b;
32     if (c >= a) {
33       return c;
34     }
35     revert();
36   }
37 
38   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
39     return a >= b ? a : b;
40   }
41 
42   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
43     return a < b ? a : b;
44   }
45 
46 }
47 
48 /*
49  * Ownable
50  *
51  * Base contract with an owner.
52  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
53  */
54 contract Ownable {
55   address public owner;
56 
57   function Ownable() {
58     owner = msg.sender;
59   }
60 
61   modifier onlyOwner() {
62     if (msg.sender != owner) {
63       revert();
64     }
65     _;
66   }
67 
68   function transferOwnership(address newOwner) onlyOwner {
69     if (newOwner != address(0)) {
70       owner = newOwner;
71     }
72   }
73 
74 }
75 
76 /*
77  * Haltable
78  *
79  * Abstract contract that allows children to implement an
80  * emergency stop mechanism. Differs from Pausable by causing a revert() when in halt mode.
81  *
82  *
83  * Originally envisioned in FirstBlood ICO contract.
84  */
85 contract Haltable is Ownable {
86   bool public halted;
87 
88   event Halted(uint256 _time);
89   event Unhalted(uint256 _time);
90   
91   modifier stopInEmergency {
92     if (halted) revert();
93     _;
94   }
95 
96   modifier onlyInEmergency {
97     if (!halted) revert();
98     _;
99   }
100 
101   // called by the owner on emergency, triggers stopped state
102   function halt() external onlyOwner {
103     halted = true;
104     Halted( now );
105   }
106 
107   // called by the owner on end of emergency, returns to normal state
108   function unhalt() external onlyOwner onlyInEmergency {
109     halted = false;
110     Unhalted( now );
111   }
112 
113 }
114 
115 /**
116  * @title ERC20Basic
117  * @dev Simpler version of ERC20 interface - no allowances
118  * @dev see https://github.com/ethereum/EIPs/issues/20
119  */
120 contract ERC20Basic {
121   uint256 public totalSupply;
122   function balanceOf(address who) constant returns (uint256);
123   function transfer(address to, uint256 value);
124   event Transfer(address indexed from, address indexed to, uint256 value);
125 }
126 
127 /**
128  * @title ERC20 interface
129  * @dev ERC20Basic with allowances
130  * @dev see https://github.com/ethereum/EIPs/issues/20
131  */
132 contract ERC20 is ERC20Basic {
133   function allowance(address owner, address spender) constant returns (uint256);
134   function transferFrom(address from, address to, uint256 value);
135   function approve(address spender, uint256 value);
136   event Approval(address indexed owner, address indexed spender, uint256 value);
137 }
138 
139 /**
140  * @title Basic token
141  * @dev realisation of ERC20Basic interface
142  * @dev Basic version of StandardToken, with no allowances. 
143  */
144 contract BasicToken is ERC20Basic {
145   using SafeMath for uint256;
146 
147   mapping(address => uint256) balances;
148 
149   /**
150    * @dev Fix for the ERC20 short address attack.
151    */
152   modifier onlyPayloadSize(uint256 size) {
153      if(msg.data.length < size + 4) {
154        revert();
155      }
156      _;
157   }
158 
159   /**
160   * @dev transfer token for a specified address
161   * @param _to The address to transfer to.
162   * @param _value The amount to be transferred.
163   */
164   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) {
165     balances[msg.sender] = balances[msg.sender].sub(_value);
166     balances[_to] = balances[_to].add(_value);
167     Transfer(msg.sender, _to, _value);
168   }
169 
170   /**
171   * @dev Gets the balance of the specified address.
172   * @param _owner The address to query the the balance of. 
173   * @return An uint256 representing the amount owned by the passed address.
174   */
175   function balanceOf(address _owner) constant returns (uint256 balance) {
176     return balances[_owner];
177   }
178 
179 }
180 
181 /**
182  * @title Standard ERC20 token
183  *
184  * @dev Implemantation of the basic standart token.
185  * @dev https://github.com/ethereum/EIPs/issues/20
186  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
187  */
188 contract StandardToken is BasicToken, ERC20 {
189   using SafeMath for uint256;
190   
191   mapping (address => mapping (address => uint256)) allowed;
192 
193   /**
194    * @dev Transfer tokens from one address to another
195    * @param _from address The address which you want to send tokens from
196    * @param _to address The address which you want to transfer to
197    * @param _value uint256 the amout of tokens to be transfered
198    */
199   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) {
200     var _allowance = allowed[_from][msg.sender];
201     allowed[_from][msg.sender] = _allowance.sub(_value);
202     balances[_from] = balances[_from].sub(_value);
203     balances[_to] = balances[_to].add(_value);
204     
205     Transfer(_from, _to, _value);
206   }
207 
208   /**
209    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
210    * @param _spender The address which will spend the funds.
211    * @param _value The amount of tokens to be spent.
212    */
213   function approve(address _spender, uint256 _value) onlyPayloadSize(2 * 32) {  //not letting anybody hit himself with short address attack
214 
215     // To change the approve amount you first have to reduce the addresses`
216     //  allowance to zero by calling `approve(_spender, 0)` if it is not
217     //  already 0 to mitigate the race condition described here:
218     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
219     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
220 
221     allowed[msg.sender][_spender] = _value;
222     Approval(msg.sender, _spender, _value);
223   }
224 
225   /**
226    * @dev Function to check the amount of tokens that an owner allowed to a spender.
227    * @param _owner address The address which owns the funds.
228    * @param _spender address The address which will spend the funds.
229    * @return A uint256 specifing the amount of tokens still avaible for the spender.
230    */
231   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
232     return allowed[_owner][_spender];
233   }
234 
235 }
236 
237 /**
238  * @title EtalonToken
239  * @dev Base Etalon ERC20 Token, where all tokens are pre-assigned to the creator. 
240  * Note they can later distribute these tokens as they wish using `transfer` and other
241  * `StandardToken` functions.
242  */
243 contract EtalonToken is StandardToken, Haltable {
244   using SafeMath for uint256;
245   
246   string  public name        = "Etalon Token";
247   string  public symbol      = "ETL";
248   uint256 public decimals    = 0;
249   uint256 public INITIAL     = 4000000;
250   
251   event MoreTokensMinted(uint256 _minted, string reason);
252 
253   /**
254    * @dev Contructor that gives msg.sender all of existing tokens. 
255    */
256   function EtalonToken() {
257     totalSupply = INITIAL;
258     balances[msg.sender] = INITIAL;
259   }
260   
261   /**
262    * @dev Function that creates new tokens by owner
263    * @param _amount - how many tokens mint
264    * @param reason  - for which reason minted
265    */
266   function mint( uint256 _amount, string reason ) onlyOwner {
267     totalSupply = totalSupply.add(_amount);
268     balances[msg.sender] = balances[msg.sender].add(_amount);
269     MoreTokensMinted(_amount, reason);
270   }
271 }
272 
273 /**
274  * @title Etalon Token Presale
275  * @dev Presale contract
276  */
277 contract EtalonTokenPresale is Haltable {
278   using SafeMath for uint256;
279 
280   string public name = "Etalon Token Presale";
281 
282   EtalonToken public token;
283   address public beneficiary;
284 
285   uint256 public hardCap;
286   uint256 public softCap;
287   uint256 public collected;
288   uint256 public price;
289 
290   uint256 public tokensSold = 0;
291   uint256 public weiRaised = 0;
292   uint256 public investorCount = 0;
293   uint256 public weiRefunded = 0;
294 
295   uint256 public startTime;
296   uint256 public endTime;
297   uint256 public duration;
298 
299   bool public softCapReached = false;
300   bool public crowdsaleFinished = false;
301 
302   mapping (address => bool) refunded;
303 
304   event CrowdsaleStarted(uint256 _time, uint256 _softCap, uint256 _hardCap, uint256 _price );
305   event CrowdsaleFinished(uint256 _time);
306   event CrowdsaleExtended(uint256 _endTime);
307   event GoalReached(uint256 _amountRaised);
308   event SoftCapReached(uint256 _softCap);
309   event NewContribution(address indexed _holder, uint256 _tokenAmount, uint256 _etherAmount);
310   event Refunded(address indexed _holder, uint256 _amount);
311 
312   modifier onlyAfter(uint256 time) {
313     if (now < time) revert();
314     _;
315   }
316 
317   modifier onlyBefore(uint256 time) {
318     if (now > time) revert();
319     _;
320   }
321   
322   /**
323    * @dev Constructor
324    * @param _token       - address of ETL contract
325    * @param _beneficiary - address, which gets all profits
326    */
327   function EtalonTokenPresale(
328     address _token,
329     address _beneficiary
330   ) {
331     hardCap = 0;
332     softCap = 0;
333     price   = 0;
334   
335     token = EtalonToken(_token);
336     beneficiary = _beneficiary;
337 
338     startTime = 0;
339     endTime   = 0;
340   }
341   
342   /**
343    * @dev Function that starts sales
344    * @param _hardCap     - in ethers (not wei/gwei/finney)
345    * @param _softCap     - in ethers (not wei/gwei/finney)
346    * @param _duration - length of presale in hours
347    * @param _price       - tokens per 1 ether
348    * TRANSFER ENOUGH TOKENS TO THIS CONTRACT FIRST OR IT WONT BE ABLE TO SELL THEM
349    */  
350   function start(
351     uint256 _hardCap,
352     uint256 _softCap,
353     uint256 _duration,
354     uint256 _price ) onlyOwner
355   {
356     if (startTime > 0) revert();
357     hardCap = _hardCap * 1 ether;
358     softCap = _softCap * 1 ether;
359     price   = _price;
360     startTime = now;
361     endTime   = startTime + _duration * 1 hours;
362     duration  = _duration;
363     CrowdsaleStarted(now, softCap, hardCap, price );
364   }
365 
366   /**
367    * @dev Function that ends sales
368    * Made to insure finishing of sales - starts refunding
369    */ 
370   function finish() onlyOwner onlyAfter(endTime) {
371     crowdsaleFinished = true;
372     CrowdsaleFinished( now );
373   }
374 
375   /**
376    * @dev Function to extend period of presale
377    * @param _duration - length of prolongation period
378    * limited by 1/2 of year
379    */
380   function extend( uint256 _duration ) onlyOwner {
381     endTime  = endTime + _duration * 1 hours;
382     duration = duration + _duration;
383     if ((startTime + 4500 hours) < endTime) revert();
384     CrowdsaleExtended( endTime );
385   }
386 
387   /**
388    * fallback function - to recieve ethers and send tokens
389    */
390   function () payable stopInEmergency {
391     if ( msg.value < uint256( 1 ether ).div( price ) ) revert();
392     doPurchase(msg.sender, msg.value);
393   }
394 
395   /**
396    * @dev Function to get your ether back if presale failed 
397    */
398   function refund() external onlyAfter(endTime) stopInEmergency {  //public???
399     if (!crowdsaleFinished) revert();
400     if (softCapReached) revert();
401     if (refunded[msg.sender]) revert();
402 
403     uint256 balance = token.balanceOf(msg.sender);
404     if (balance == 0) revert();
405 
406     uint256 to_refund = balance.mul(1 ether).div(price);
407     if (to_refund > this.balance) {
408       to_refund = this.balance;  // if refunding is more than all, that contract hold - return all holded ether
409     }
410 
411     msg.sender.transfer( to_refund ); // transfer throws on failure
412     refunded[msg.sender] = true;
413     weiRefunded = weiRefunded.add( to_refund );
414     Refunded( msg.sender, to_refund );
415   }
416 
417   /**
418    * @dev Function to send profits and unsold tokens to beneficiary
419    */
420   function withdraw() onlyOwner {
421     if (!softCapReached) revert();
422     beneficiary.transfer( collected );
423     token.transfer(beneficiary, token.balanceOf(this));
424     crowdsaleFinished = true;
425   }
426 
427   /**
428    * @dev Get ether and transfer tokens
429    * @param _buyer  - address of ethers sender
430    * @param _amount - ethers sended
431    */
432   function doPurchase(address _buyer, uint256 _amount) private onlyAfter(startTime) onlyBefore(endTime) stopInEmergency {
433     
434     if (crowdsaleFinished) revert();
435 
436     if (collected.add(_amount) > hardCap) revert();
437 
438     if ((!softCapReached) && (collected < softCap) && (collected.add(_amount) >= softCap)) {
439       softCapReached = true;
440       SoftCapReached(softCap);
441     }
442 
443     uint256 tokens = _amount.mul( price ).div( 1 ether ); //div(1 ether) - because _amount measured in weis
444     if (tokens == 0) revert();
445 
446     if (token.balanceOf(_buyer) == 0) investorCount++;
447     
448     collected = collected.add(_amount);
449 
450     token.transfer(_buyer, tokens);
451 
452     weiRaised = weiRaised.add(_amount);
453     tokensSold = tokensSold.add(tokens);
454 
455     NewContribution(_buyer, tokens, _amount);
456 
457     if (collected == hardCap) {
458       GoalReached(hardCap);
459     }
460   }
461 
462   /**
463    * @dev Making contract burnable
464    * Added for testing reasons
465    * onlyInEmergency - fools protection
466    */
467   function burn() onlyOwner onlyInEmergency { selfdestruct(owner); }
468 }