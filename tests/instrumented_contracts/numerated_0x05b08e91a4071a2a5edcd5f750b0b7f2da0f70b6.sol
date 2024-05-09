1 pragma solidity ^0.5.2;
2 
3 // File: contracts/token/ERC20Basic.sol
4 
5 contract ERC20Basic {
6   uint256 public totalSupply;
7   function balanceOf(address who) public view returns (uint256);
8   function transfer(address to, uint256 value) public returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10 }
11 
12 // File: contracts/math/SafeMath.sol
13 
14 library SafeMath {
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a / b;
25     return c;
26   }
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 // File: contracts/token/BasicToken.sol
39 
40 contract BasicToken is ERC20Basic {
41   using SafeMath for uint256;
42   mapping(address => uint256) balances;
43   function transfer(address _to, uint256 _value) public returns (bool) {
44     require(_to != address(0));
45     balances[msg.sender] = balances[msg.sender].sub(_value);
46     balances[_to] = balances[_to].add(_value);
47     emit Transfer(msg.sender, _to, _value);
48     return true;
49   }
50   function balanceOf(address _owner) public view returns (uint256 balance) {
51     return balances[_owner];
52   }
53 }
54 
55 // File: contracts/token/ERC20.sol
56 
57 contract ERC20 is ERC20Basic {
58   function allowance(address owner, address spender) public view returns (uint256);
59   function transferFrom(address from, address to, uint256 value) public returns (bool);
60   function approve(address spender, uint256 value) public returns (bool);
61   event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 // File: contracts/token/StandardToken.sol
65 
66 contract StandardToken is ERC20, BasicToken {
67   mapping (address => mapping (address => uint256)) allowed;
68   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
69     require(_to != address(0));
70     uint256 _allowance = allowed[_from][msg.sender];
71     balances[_from] = balances[_from].sub(_value);
72     balances[_to] = balances[_to].add(_value);
73     allowed[_from][msg.sender] = _allowance.sub(_value);
74     emit Transfer(_from, _to, _value);
75     return true;
76   }
77   function approve(address _spender, uint256 _value) public returns (bool) {
78     allowed[msg.sender][_spender] = _value;
79     emit Approval(msg.sender, _spender, _value);
80     return true;
81   }
82   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
83     return allowed[_owner][_spender];
84   }
85   function increaseApproval (address _spender, uint _addedValue) external
86     returns (bool success) {
87     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
88     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
89     return true;
90   }
91   function decreaseApproval (address _spender, uint _subtractedValue) external
92     returns (bool success) {
93     uint oldValue = allowed[msg.sender][_spender];
94     if (_subtractedValue > oldValue) {
95       allowed[msg.sender][_spender] = 0;
96     } else {
97       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
98     }
99     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
100     return true;
101   }
102 }
103 
104 // File: contracts/ownership/Ownable.sol
105 
106 contract Ownable {
107   address public owner;
108   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
109   constructor() public {
110     owner = msg.sender;
111   }
112   modifier onlyOwner() {
113     require(msg.sender == owner);
114     _;
115   }
116   function transferOwnership(address newOwner) onlyOwner public {
117     require(newOwner != address(0));
118     emit OwnershipTransferred(owner, newOwner);
119     owner = newOwner;
120   }
121 }
122 
123 // File: contracts/token/MintableToken.sol
124 
125 contract MintableToken is StandardToken, Ownable {
126   event Mint(address indexed to, uint256 amount);
127   event MintFinished();
128   bool public mintingFinished = false;
129   modifier canMint() {
130     require(!mintingFinished);
131     _;
132   }
133   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
134     totalSupply = totalSupply.add(_amount);
135     balances[_to] = balances[_to].add(_amount);
136     emit Mint(_to, _amount);
137     emit Transfer(address(0), _to, _amount);
138     return true;
139   }
140   function finishMinting() onlyOwner public returns (bool) {
141     mintingFinished = true;
142     emit MintFinished();
143     return true;
144   }
145   function burnTokens(uint256 _unsoldTokens) onlyOwner public returns (bool) {
146     totalSupply = totalSupply.sub(_unsoldTokens);
147   }
148 }
149 
150 // File: contracts/lifecycle/Pausable.sol
151 
152 contract Pausable is Ownable {
153   event Pause();
154   event Unpause();
155   bool public paused = false;
156   modifier whenNotPaused() {
157     require(!paused);
158     _;
159   }
160   modifier whenPaused() {
161     require(paused);
162     _;
163   }
164   function pause() onlyOwner whenNotPaused public {
165     paused = true;
166     emit Pause();
167   }
168   function unpause() onlyOwner whenPaused public {
169     paused = false;
170     emit Unpause();
171   }
172 }
173 
174 // File: contracts/whitelist/Whitelist.sol
175 
176 library Whitelist {
177   struct List {
178     mapping(address => bool) registry;
179   }
180   function add(List storage list, address beneficiary) internal {
181     list.registry[beneficiary] = true;
182   }
183   function remove(List storage list, address beneficiary) internal {
184     list.registry[beneficiary] = false;
185   }
186   function check(List storage list, address beneficiary) view internal returns (bool) {
187     return list.registry[beneficiary];
188   }
189 }
190 
191 // File: contracts/whitelist/whitelisted.sol
192 
193 contract Whitelisted is Ownable {
194   Whitelist.List private _list;
195   modifier onlyWhitelisted() {
196     require(Whitelist.check(_list, msg.sender) == true);
197     _;
198   }
199   event AddressAdded(address[] beneficiary);
200   event AddressRemoved(address[] beneficiary);
201 
202   constructor() public {
203     Whitelist.add(_list, msg.sender);
204   }
205   function enable(address[] calldata _beneficiary) external onlyOwner {
206     for (uint256 i = 0; i < _beneficiary.length; i++) {
207       Whitelist.add(_list, _beneficiary[i]);
208     }
209     emit AddressAdded(_beneficiary);
210   }
211   function disable(address[] calldata _beneficiary) external onlyOwner {
212     for (uint256 i = 0; i < _beneficiary.length; i++) {
213       Whitelist.remove(_list, _beneficiary[i]);
214     }
215     emit AddressRemoved(_beneficiary);
216   }
217   function isListed(address _beneficiary) external view returns (bool){
218     return Whitelist.check(_list, _beneficiary);
219   }
220 }
221 
222 // File: contracts/crowdsale/RefundVault.sol
223 
224 contract RefundVault is Ownable {
225   using SafeMath for uint256;
226   enum State { Active, Refunding, Closed }
227   mapping (address => uint256) public deposited;
228   State public state;
229   event Closed();
230   event RefundsEnabled();
231 
232   event Refunded(address indexed beneficiary, uint256 weiAmount);
233   constructor() public {
234     state = State.Active;
235   }
236   function deposit(address _beneficiary) onlyOwner external payable {
237     require(state == State.Active);
238     deposited[_beneficiary] = deposited[_beneficiary].add(msg.value);
239   }
240   function close() onlyOwner external {
241     require(state == State.Active);
242     state = State.Closed;
243     emit Closed();
244   }
245   function withdrawFunds(uint256 _amount) onlyOwner external {
246      require(state == State.Closed);
247      msg.sender.transfer(_amount);
248   }
249   function enableRefunds() onlyOwner external {
250     require(state == State.Active);
251     state = State.Refunding;
252     emit RefundsEnabled();
253   }
254   function refund(address _beneficiary) external {
255     require(state == State.Refunding);
256     uint256 depositedValue = deposited[_beneficiary];
257     deposited[_beneficiary] = 0;
258     emit Refunded(_beneficiary, depositedValue);
259     msg.sender.transfer(depositedValue);
260   }
261 }
262 
263 // File: contracts/crowdsale/Crowdsale.sol
264 
265 contract Crowdsale is Ownable, Pausable, Whitelisted {
266   using SafeMath for uint256;
267   MintableToken public token;
268   uint256 public minPurchase;
269   uint256 public maxPurchase;
270   uint256 public investorStartTime;
271   uint256 public investorEndTime;
272   uint256 public preStartTime;
273   uint256 public preEndTime;
274   uint256 public ICOstartTime;
275   uint256 public ICOEndTime;
276   uint256 public preICOBonus;
277   uint256 public firstWeekBonus;
278   uint256 public secondWeekBonus;
279   uint256 public thirdWeekBonus;
280   uint256 public forthWeekBonus;
281   uint256 public flashSaleStartTime;
282   uint256 public flashSaleEndTime;
283   uint256 public flashSaleBonus;
284   uint256 public rate;
285   uint256 public weiRaised;
286   uint256 public weekOne;
287   uint256 public weekTwo;
288   uint256 public weekThree;
289   uint256 public weekForth;
290   uint256 public totalSupply = 2500000000E18;
291   uint256 public preicoSupply = totalSupply.div(100).mul(30);
292   uint256 public icoSupply = totalSupply.div(100).mul(30);
293   uint256 public bountySupply = totalSupply.div(100).mul(5);
294   uint256 public teamSupply = totalSupply.div(100).mul(20);
295   uint256 public reserveSupply = totalSupply.div(100).mul(5);
296   uint256 public partnershipsSupply = totalSupply.div(100).mul(10);
297   uint256 public publicSupply = preicoSupply.add(icoSupply);
298   uint256 public teamTimeLock;
299   uint256 public partnershipsTimeLock;
300   uint256 public reserveTimeLock;
301   uint256 public cap;
302   bool public checkBurnTokens;
303   bool public upgradeICOSupply;
304 
305   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
306   RefundVault public vault;
307   constructor(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap) public {
308     require(_startTime >= now);
309     require(_endTime >= _startTime);
310     require(_rate > 0);
311     require(_cap > 0);
312     cap = _cap;
313     token = createTokenContract();
314     investorStartTime = 0;
315     investorEndTime = 0;
316     preStartTime = _startTime;
317     preEndTime = preStartTime + 10 days;
318     ICOstartTime = preEndTime + 5 minutes;
319     ICOEndTime = _endTime;
320     rate = _rate;
321     preICOBonus = rate.mul(35).div(100);
322     firstWeekBonus = rate.mul(18).div(100);
323     secondWeekBonus = rate.mul(15).div(100);
324     thirdWeekBonus = rate.mul(10).div(100);
325     forthWeekBonus = rate.mul(5).div(100);
326     weekOne = ICOstartTime.add(6 days);
327     weekTwo = weekOne.add(6 days);
328     weekThree = weekTwo.add(6 days);
329     weekForth = weekThree.add(6 days);
330     teamTimeLock = ICOEndTime.add(180 days);
331     reserveTimeLock = ICOEndTime.add(180 days);
332     partnershipsTimeLock = preStartTime.add(3 minutes);
333     flashSaleStartTime = 0;
334     flashSaleEndTime = 0;
335     flashSaleBonus = 0;
336     checkBurnTokens = false;
337     upgradeICOSupply = false;
338     minPurchase = 1 ether;
339     maxPurchase = 50 ether;
340     vault = new RefundVault();
341   }
342   function createTokenContract() internal returns (MintableToken) {
343     return new MintableToken();
344   }
345   function () external payable {
346     buyTokens(msg.sender);
347   }
348   function buyTokens(address beneficiary) whenNotPaused onlyWhitelisted public payable {
349     require(beneficiary != address(0));
350     require(validPurchase());
351     uint256 weiAmount = msg.value;
352     uint256 accessTime = now;
353     uint256 tokens = 0;
354 
355     if((accessTime >= flashSaleStartTime) && (accessTime < flashSaleEndTime))
356     {
357       tokens = tokens.add(weiAmount.mul(flashSaleBonus));
358       tokens = tokens.add(weiAmount.mul(rate));
359       icoSupply = icoSupply.sub(tokens);
360       publicSupply = publicSupply.sub(tokens);
361     }
362     else if((accessTime >= investorStartTime) && (accessTime < investorEndTime) && (accessTime < preStartTime))
363     {
364       tokens = tokens.add(weiAmount.mul(rate));
365       icoSupply = icoSupply.sub(tokens);
366       publicSupply = publicSupply.sub(tokens);
367     }
368     else if ((accessTime >= preStartTime) && (accessTime < preEndTime))
369     {
370       require(preicoSupply > 0);
371       tokens = tokens.add(weiAmount.mul(preICOBonus));
372       tokens = tokens.add(weiAmount.mul(rate));
373       require(preicoSupply >= tokens);
374       preicoSupply = preicoSupply.sub(tokens);
375       publicSupply = publicSupply.sub(tokens);
376     }
377     else if ((accessTime >= ICOstartTime) && (accessTime <= ICOEndTime))
378     {
379       if (!upgradeICOSupply)
380       {
381         icoSupply = icoSupply.add(preicoSupply);
382         upgradeICOSupply = true;
383       }
384       if (accessTime <= weekOne)
385       {
386         tokens = tokens.add(weiAmount.mul(firstWeekBonus));
387       }
388       else if (( accessTime <= weekTwo ) && (accessTime > weekOne))
389       {
390         tokens = tokens.add(weiAmount.mul(secondWeekBonus));
391       }
392       else if (( accessTime <= weekThree ) && (accessTime > weekTwo))
393       {
394         tokens = tokens.add(weiAmount.mul(thirdWeekBonus));
395       }
396       else if (( accessTime <= weekForth ) && (accessTime > weekThree))
397       {
398         tokens = tokens.add(weiAmount.mul(forthWeekBonus));
399       }
400       tokens = tokens.add(weiAmount.mul(rate));
401       icoSupply = icoSupply.sub(tokens);
402       publicSupply = publicSupply.sub(tokens);
403     }
404     else {
405       revert();
406     }
407     weiRaised = weiRaised.add(weiAmount);
408     vault.deposit.value(weiAmount)(beneficiary);
409     token.mint(beneficiary, tokens);
410     emit TokenPurchase(beneficiary, beneficiary, weiAmount, tokens);
411   }
412   function validPurchase() internal returns (bool) {
413     require(withinCap(msg.value));
414     require(withinRange(msg.value));
415     return true;
416   }
417   function withinRange(uint256 weiAmount) internal view returns (bool) {
418     require(weiAmount >= minPurchase);
419     require(weiAmount <= maxPurchase);
420     return true;
421   }
422   function withinCap(uint256 weiAmount) internal view returns (bool) {
423     require(weiRaised.add(weiAmount) <= cap);
424     return true;
425   }
426   function hasEnded() public view returns (bool) {
427     return now > ICOEndTime;
428   }
429   function hardCapReached() public view returns (bool) {
430     return weiRaised >= cap;
431   }
432   function burnToken() onlyOwner external returns (bool) {
433     require(hasEnded());
434     require(!checkBurnTokens);
435     token.burnTokens(icoSupply);
436     totalSupply = totalSupply.sub(publicSupply);
437     preicoSupply = 0;
438     icoSupply = 0;
439     publicSupply = 0;
440     checkBurnTokens = true;
441     return true;
442   }
443   function updateDates(uint256 _preStartTime,uint256 _preEndTime,uint256 _ICOstartTime,uint256 _ICOEndTime) onlyOwner external {
444     require(_preEndTime > _preStartTime);
445     require(_ICOstartTime > _preEndTime);
446     require(_ICOEndTime > _ICOstartTime);
447     preEndTime = _preEndTime;
448     preStartTime = _preStartTime;
449     ICOstartTime = _ICOstartTime;
450     ICOEndTime = _ICOEndTime;
451     weekOne = ICOstartTime.add(6 days);
452     weekTwo = weekOne.add(6 days);
453     weekThree = weekTwo.add(6 days);
454     weekForth = weekThree.add(6 days);
455     teamTimeLock = ICOEndTime.add(180 days);
456     reserveTimeLock = ICOEndTime.add(180 days);
457     partnershipsTimeLock = preStartTime.add(3 minutes);
458   }
459   function flashSale(uint256 _flashSaleStartTime, uint256 _flashSaleEndTime, uint256 _flashSaleBonus) onlyOwner external {
460     flashSaleStartTime = _flashSaleStartTime;
461     flashSaleEndTime = _flashSaleEndTime;
462     flashSaleBonus = _flashSaleBonus;
463   }
464   function updateInvestorDates(uint256 _investorStartTime, uint256 _investorEndTime) onlyOwner external {
465     investorStartTime = _investorStartTime;
466     investorEndTime = _investorEndTime;
467   }
468   function updateMinMaxInvestment(uint256 _minPurchase, uint256 _maxPurchase) onlyOwner external {
469     require(_maxPurchase > _minPurchase);
470     require(_minPurchase > 0);
471     minPurchase = _minPurchase;
472     maxPurchase = _maxPurchase;
473   }
474   function transferFunds(address[] calldata recipients, uint256[] calldata values) onlyOwner external {
475     require(!checkBurnTokens);
476     for (uint256 i = 0; i < recipients.length; i++) {
477       if (publicSupply >= values[i]) {
478         publicSupply = publicSupply.sub(values[i]);
479         token.mint(recipients[i], values[i]);
480       }
481     }
482   }
483   function acceptEther() onlyOwner external payable {
484     weiRaised = weiRaised.add(msg.value.div(rate));
485   }
486   function bountyFunds(address[] calldata recipients, uint256[] calldata values) onlyOwner external {
487     require(!checkBurnTokens);
488     for (uint256 i = 0; i < recipients.length; i++) {
489       if (bountySupply >= values[i]) {
490         bountySupply = bountySupply.sub(values[i]);
491         token.mint(recipients[i], values[i]);
492       }
493     }
494   }
495   function transferPartnershipsTokens(address[] calldata recipients, uint256[] calldata values) onlyOwner external {
496     require(!checkBurnTokens);
497     require((reserveTimeLock < now));
498     for (uint256 i = 0; i < recipients.length; i++) {
499       if (partnershipsSupply >= values[i]) {
500         partnershipsSupply = partnershipsSupply.sub(values[i]);
501         token.mint(recipients[i], values[i]);
502       }
503     }
504   }
505   function transferReserveTokens(address[] calldata recipients, uint256[] calldata values) onlyOwner external {
506     require(!checkBurnTokens);
507     require((reserveTimeLock < now));
508     for (uint256 i = 0; i < recipients.length; i++) {
509       if (reserveSupply >= values[i]) {
510         reserveSupply = reserveSupply.sub(values[i]);
511         token.mint(recipients[i], values[i]);
512       }
513     }
514   }
515   function transferTeamTokens(address[] calldata recipients, uint256[] calldata values) onlyOwner external {
516     require(!checkBurnTokens);
517     require((now > teamTimeLock));
518     for (uint256 i = 0; i < recipients.length; i++) {
519       if (teamSupply >= values[i]) {
520         teamSupply = teamSupply.sub(values[i]);
521         token.mint(recipients[i], values[i]);
522       }
523     }
524   }
525   function getTokenAddress() onlyOwner external view returns (address) {
526     return address(token);
527   }
528 }
529 
530 // File: contracts/crowdsale/RefundableCrowdsale.sol
531 
532 contract RefundableCrowdsale is Crowdsale {
533   uint256 public goal;
534   bool public isFinalized;
535   event Finalized();
536 
537   function finalizeCrowdsale() onlyOwner external {
538     require(!isFinalized);
539 
540     if (goalReached()) {  
541       vault.close();
542     } else {
543       vault.enableRefunds();
544     }
545 
546     isFinalized = true;
547     emit Finalized();
548   }
549 
550   constructor(uint256 _goal) public {
551     require(_goal > 0);
552     isFinalized = false;
553     goal = _goal;
554   }
555 
556   function openVaultForWithdrawal() onlyOwner external {
557     require(isFinalized);
558     require(goalReached());
559     vault.transferOwnership(msg.sender);
560   }
561   function claimRefund(address _beneficiary) public {
562     require(isFinalized);
563     require(!goalReached());
564     vault.refund(_beneficiary);
565   }
566   function goalReached() public view returns (bool) {
567     return weiRaised >= goal;
568   }
569   function getVaultAddress() onlyOwner external view returns (RefundVault) {
570     return vault;
571   }
572 }
573 
574 // File: contracts/Dayta.sol
575 
576 contract Dayta is MintableToken {
577   string public constant name = "DAYTA";
578   string public constant symbol = "DAYTA";
579   uint8 public constant decimals = 18;
580   uint256 public _totalSupply = 2500000000E18;
581   constructor() public {
582     totalSupply = _totalSupply;
583   }
584 }
585 
586 // File: contracts\DaytaCrowdsale.sol
587 
588 contract DaytaCrowdsale is Crowdsale, RefundableCrowdsale {
589     constructor(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, uint256 _goal) public
590     RefundableCrowdsale(_goal)
591     Crowdsale(_startTime, _endTime, _rate, _cap)
592     {
593     }
594     function createTokenContract() internal returns (MintableToken) {
595         return new Dayta();
596     }
597 }