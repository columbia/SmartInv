1 pragma solidity ^0.4.18;
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
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) onlyOwner {
35     if (newOwner != address(0)) {
36       owner = newOwner;
37     }
38   }
39 
40 }
41 
42 /*
43  * Haltable
44  *
45  * Abstract contract that allows children to implement an
46  * emergency stop mechanism. Differs from Pausable by requiring a state.
47  *
48  *
49  * Originally envisioned in FirstBlood ICO contract.
50  */
51 contract Haltable is Ownable {
52   bool public halted = false;
53 
54   modifier inNormalState {
55     require(!halted);
56     _;
57   }
58 
59   modifier inEmergencyState {
60     require(halted);
61     _;
62   }
63 
64   // called by the owner on emergency, triggers stopped state
65   function halt() external onlyOwner inNormalState {
66     halted = true;
67   }
68 
69   // called by the owner on end of emergency, returns to normal state
70   function unhalt() external onlyOwner inEmergencyState {
71     halted = false;
72   }
73 }
74 
75 /**
76  * @title SafeMath
77  * @dev Math operations with safety checks that throw on error
78  */
79 library SafeMath {
80   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
81     uint256 c = a * b;
82     assert(a == 0 || c / a == b);
83     return c;
84   }
85 
86   function div(uint256 a, uint256 b) internal constant returns (uint256) {
87     // assert(b > 0); // Solidity automatically throws when dividing by 0
88     uint256 c = a / b;
89     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90     return c;
91   }
92 
93   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
94     assert(b <= a);
95     return a - b;
96   }
97 
98   function add(uint256 a, uint256 b) internal constant returns (uint256) {
99     uint256 c = a + b;
100     assert(c >= a);
101     return c;
102   }
103 }
104 
105 /**
106  * @title ERC20Basic
107  * @dev Simpler version of ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/179
109  */
110 contract ERC20Basic {
111   uint256 public totalSupply;
112   function balanceOf(address who) constant returns (uint256);
113   function transfer(address to, uint256 value) returns (bool);
114   event Transfer(address indexed from, address indexed to, uint256 value);
115 }
116 
117 /**
118  * @title Basic token
119  * @dev Basic version of StandardToken, with no allowances. 
120  */
121 contract BasicToken is ERC20Basic {
122   using SafeMath for uint256;
123 
124   mapping(address => uint256) balances;
125 
126   /**
127   * @dev transfer token for a specified address
128   * @param _to The address to transfer to.
129   * @param _value The amount to be transferred.
130   */
131   function transfer(address _to, uint256 _value) returns (bool) {
132     balances[msg.sender] = balances[msg.sender].sub(_value);
133     balances[_to] = balances[_to].add(_value);
134     Transfer(msg.sender, _to, _value);
135     return true;
136   }
137 
138   /**
139   * @dev Gets the balance of the specified address.
140   * @param _owner The address to query the the balance of. 
141   * @return An uint256 representing the amount owned by the passed address.
142   */
143   function balanceOf(address _owner) constant returns (uint256 balance) {
144     return balances[_owner];
145   }
146 
147 }
148 
149 /**
150  * @title ERC20 interface
151  * @dev see https://github.com/ethereum/EIPs/issues/20
152  */
153 contract ERC20 is ERC20Basic {
154   function allowance(address owner, address spender) constant returns (uint256);
155   function transferFrom(address from, address to, uint256 value) returns (bool);
156   function approve(address spender, uint256 value) returns (bool);
157   event Approval(address indexed owner, address indexed spender, uint256 value);
158 }
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
169   mapping (address => mapping (address => uint256)) allowed;
170 
171 
172   /**
173    * @dev Transfer tokens from one address to another
174    * @param _from address The address which you want to send tokens from
175    * @param _to address The address which you want to transfer to
176    * @param _value uint256 the amout of tokens to be transfered
177    */
178   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
179     var _allowance = allowed[_from][msg.sender];
180 
181     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
182     // require (_value <= _allowance);
183 
184     balances[_to] = balances[_to].add(_value);
185     balances[_from] = balances[_from].sub(_value);
186     allowed[_from][msg.sender] = _allowance.sub(_value);
187     Transfer(_from, _to, _value);
188     return true;
189   }
190 
191   /**
192    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
193    * @param _spender The address which will spend the funds.
194    * @param _value The amount of tokens to be spent.
195    */
196   function approve(address _spender, uint256 _value) returns (bool) {
197 
198     // To change the approve amount you first have to reduce the addresses`
199     //  allowance to zero by calling `approve(_spender, 0)` if it is not
200     //  already 0 to mitigate the race condition described here:
201     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
203 
204     allowed[msg.sender][_spender] = _value;
205     Approval(msg.sender, _spender, _value);
206     return true;
207   }
208 
209   /**
210    * @dev Function to check the amount of tokens that an owner allowed to a spender.
211    * @param _owner address The address which owns the funds.
212    * @param _spender address The address which will spend the funds.
213    * @return A uint256 specifing the amount of tokens still avaible for the spender.
214    */
215   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
216     return allowed[_owner][_spender];
217   }
218 
219 }
220 
221 /**
222  * @title Burnable
223  *
224  * @dev Standard ERC20 token
225  */
226 contract Burnable is StandardToken {
227   using SafeMath for uint;
228 
229   /* This notifies clients about the amount burnt */
230   event Burn(address indexed from, uint value);
231 
232   function burn(uint _value) returns (bool success) {
233     require(_value > 0 && balances[msg.sender] >= _value);
234     balances[msg.sender] = balances[msg.sender].sub(_value);
235     totalSupply = totalSupply.sub(_value);
236     Burn(msg.sender, _value);
237     return true;
238   }
239 
240   function burnFrom(address _from, uint _value) returns (bool success) {
241     require(_from != 0x0 && _value > 0 && balances[_from] >= _value);
242     require(_value <= allowed[_from][msg.sender]);
243     balances[_from] = balances[_from].sub(_value);
244     totalSupply = totalSupply.sub(_value);
245     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
246     Burn(_from, _value);
247     return true;
248   }
249 
250   function transfer(address _to, uint _value) returns (bool success) {
251     require(_to != 0x0); //use burn
252 
253     return super.transfer(_to, _value);
254   }
255 
256   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
257     require(_to != 0x0); //use burn
258 
259     return super.transferFrom(_from, _to, _value);
260   }
261 }
262 
263 /**
264  * @title QuantorToken
265  *
266  * @dev Burnable Ownable ERC20 token
267  */
268 contract QuantorToken is Burnable, Ownable {
269 
270   string public constant name = "Quant";
271   string public constant symbol = "QNT";
272   uint8 public constant decimals = 18;
273   uint public constant INITIAL_SUPPLY = 2000000000 * 1 ether;
274 
275   /* The finalizer contract that allows unlift the transfer limits on this token */
276   address public releaseAgent;
277 
278   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
279   bool public released = false;
280 
281   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
282   mapping (address => bool) public transferAgents;
283 
284   /**
285    * Limit token transfer until the crowdsale is over.
286    *
287    */
288   modifier canTransfer(address _sender) {
289     require(released || transferAgents[_sender]);
290     _;
291   }
292 
293   /** The function can be called only before or after the tokens have been released */
294   modifier inReleaseState(bool releaseState) {
295     require(releaseState == released);
296     _;
297   }
298 
299   /** The function can be called only by a whitelisted release agent. */
300   modifier onlyReleaseAgent() {
301     require(msg.sender == releaseAgent);
302     _;
303   }
304 
305 
306   /**
307    * @dev Constructor that gives msg.sender all of existing tokens.
308    */
309   function QuantorToken() {
310     totalSupply = INITIAL_SUPPLY;
311     balances[msg.sender] = INITIAL_SUPPLY;
312     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
313   }
314 
315 
316   /**
317    * Set the contract that can call release and make the token transferable.
318    *
319    * Design choice. Allow reset the release agent to fix fat finger mistakes.
320    */
321   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
322     require(addr != 0x0);
323 
324     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
325     releaseAgent = addr;
326   }
327 
328   function release() onlyReleaseAgent inReleaseState(false) public {
329     released = true;
330   }
331 
332   /**
333    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
334    */
335   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
336     require(addr != 0x0);
337     transferAgents[addr] = state;
338   }
339 
340   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
341     // Call Burnable.transfer()
342     return super.transfer(_to, _value);
343   }
344 
345   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
346     // Call Burnable.transferForm()
347     return super.transferFrom(_from, _to, _value);
348   }
349 
350   function burn(uint _value) onlyOwner returns (bool success) {
351     return super.burn(_value);
352   }
353 
354   function burnFrom(address _from, uint _value) onlyOwner returns (bool success) {
355     return super.burnFrom(_from, _value);
356   }
357 }
358 
359 contract InvestorWhiteList is Ownable {
360   mapping (address => bool) public investorWhiteList;
361 
362   mapping (address => address) public referralList;
363 
364   function InvestorWhiteList() {
365 
366   }
367 
368   function addInvestorToWhiteList(address investor) external onlyOwner {
369     require(investor != 0x0 && !investorWhiteList[investor]);
370     investorWhiteList[investor] = true;
371   }
372 
373   function removeInvestorFromWhiteList(address investor) external onlyOwner {
374     require(investor != 0x0 && investorWhiteList[investor]);
375     investorWhiteList[investor] = false;
376   }
377 
378   //when new user will contribute ICO contract will automatically send bonus to referral
379   function addReferralOf(address investor, address referral) external onlyOwner {
380     require(investor != 0x0 && referral != 0x0 && referralList[investor] == 0x0 && investor != referral);
381     referralList[investor] = referral;
382   }
383 
384   function isAllowed(address investor) constant external returns (bool result) {
385     return investorWhiteList[investor];
386   }
387 
388   function getReferralOf(address investor) constant external returns (address result) {
389     return referralList[investor];
390   }
391 }
392 
393 contract PriceReceiver {
394 
395   address public ethPriceProvider;
396 
397   modifier onlyEthPriceProvider() {
398     require(msg.sender == ethPriceProvider);
399     _;
400   }
401 
402   function receiveEthPrice(uint ethUsdPrice) external;
403 
404   function setEthPriceProvider(address provider) external;
405 }
406 
407 contract QuantorPreSale is Haltable, PriceReceiver {
408 
409   using SafeMath for uint;
410 
411   string public constant name = "Quantor Token ICO";
412 
413   QuantorToken public token;
414 
415   address public beneficiary;
416 
417   InvestorWhiteList public investorWhiteList;
418 
419   uint public constant QNTUsdRate = 1; //0.01 cents fot one token
420 
421   uint public ethUsdRate;
422 
423   uint public btcUsdRate;
424 
425   uint public hardCap;
426 
427   uint public softCap;
428 
429   uint public collected = 0;
430 
431   uint public tokensSold = 0;
432 
433   uint public weiRefunded = 0;
434 
435   uint public startTime;
436 
437   uint public endTime;
438 
439   bool public softCapReached = false;
440 
441   bool public crowdsaleFinished = false;
442 
443   mapping (address => uint) public deposited;
444 
445   uint public constant PRICE_BEFORE_SOFTCAP = 65; // in cents * 100
446   uint public constant PRICE_AFTER_SOFTCAP = 80; // in cents * 100
447 
448   event SoftCapReached(uint softCap);
449 
450   event NewContribution(address indexed holder, uint tokenAmount, uint etherAmount);
451 
452   event NewReferralTransfer(address indexed investor, address indexed referral, uint tokenAmount);
453 
454   event Refunded(address indexed holder, uint amount);
455 
456   modifier icoActive() {
457     require(now >= startTime && now < endTime);
458     _;
459   }
460 
461   modifier icoEnded() {
462     require(now >= endTime);
463     _;
464   }
465 
466   modifier minInvestment() {
467     require(msg.value.mul(ethUsdRate).div(QNTUsdRate) >= 50000 * 1 ether);
468     _;
469   }
470 
471   modifier inWhiteList() {
472     require(investorWhiteList.isAllowed(msg.sender));
473     _;
474   }
475 
476   function QuantorPreSale(
477     uint _hardCapQNT,
478     uint _softCapQNT,
479     address _token,
480     address _beneficiary,
481     address _investorWhiteList,
482     uint _baseEthUsdPrice,
483 
484     uint _startTime,
485     uint _endTime
486   ) {
487     hardCap = _hardCapQNT.mul(1 ether);
488     softCap = _softCapQNT.mul(1 ether);
489 
490     token = QuantorToken(_token);
491     beneficiary = _beneficiary;
492     investorWhiteList = InvestorWhiteList(_investorWhiteList);
493 
494     startTime = _startTime;
495     endTime = _endTime;
496 
497     ethUsdRate = _baseEthUsdPrice;
498   }
499 
500   function() payable minInvestment inWhiteList {
501     doPurchase();
502   }
503 
504   function refund() external icoEnded {
505     require(softCapReached == false);
506     require(deposited[msg.sender] > 0);
507 
508     uint refund = deposited[msg.sender];
509 
510     deposited[msg.sender] = 0;
511     msg.sender.transfer(refund);
512 
513     weiRefunded = weiRefunded.add(refund);
514     Refunded(msg.sender, refund);
515   }
516 
517   function withdraw() external icoEnded onlyOwner {
518     require(softCapReached);
519     beneficiary.transfer(collected);
520     token.transfer(beneficiary, token.balanceOf(this));
521     crowdsaleFinished = true;
522   }
523 
524   function calculateTokens(uint ethReceived) internal view returns (uint) {
525     if (!softCapReached) {
526       uint tokens = ethReceived.mul(ethUsdRate.mul(100)).div(PRICE_BEFORE_SOFTCAP);
527       if (softCap >= tokensSold.add(tokens)) return tokens;
528       uint firstPart = softCap.sub(tokensSold);
529       uint  firstPartInWei = firstPart.mul(PRICE_BEFORE_SOFTCAP).div(ethUsdRate.mul(100));
530       uint secondPartInWei = ethReceived.sub(firstPart.mul(PRICE_BEFORE_SOFTCAP).div(ethUsdRate.mul(100)));
531       return firstPart.add(secondPartInWei.mul(ethUsdRate.mul(100)).div(PRICE_AFTER_SOFTCAP));
532     }
533     return ethReceived.mul(ethUsdRate.mul(100)).div(PRICE_AFTER_SOFTCAP);
534   }
535 
536   function receiveEthPrice(uint ethUsdPrice) external onlyEthPriceProvider {
537     require(ethUsdPrice > 0);
538     ethUsdRate = ethUsdPrice;
539   }
540 
541   function setEthPriceProvider(address provider) external onlyOwner {
542     require(provider != 0x0);
543     ethPriceProvider = provider;
544   }
545 
546   function setNewWhiteList(address newWhiteList) external onlyOwner {
547     require(newWhiteList != 0x0);
548     investorWhiteList = InvestorWhiteList(newWhiteList);
549   }
550 
551   function doPurchase() private icoActive inNormalState {
552     require(!crowdsaleFinished);
553 
554     uint tokens = calculateTokens(msg.value);
555 
556     uint newTokensSold = tokensSold.add(tokens);
557 
558     require(newTokensSold <= hardCap);
559 
560     if (!softCapReached && newTokensSold >= softCap) {
561       softCapReached = true;
562       SoftCapReached(softCap);
563     }
564 
565     collected = collected.add(msg.value);
566 
567     tokensSold = newTokensSold;
568 
569     deposited[msg.sender] = deposited[msg.sender].add(msg.value);
570 
571     token.transfer(msg.sender, tokens);
572     NewContribution(msg.sender, tokens, msg.value);
573   }
574 
575   function transferOwnership(address newOwner) onlyOwner icoEnded {
576     super.transferOwnership(newOwner);
577   }
578 }