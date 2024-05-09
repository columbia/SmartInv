1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5 
6     /**
7     * @dev Multiplies two numbers, reverts on overflow.
8     */
9     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
10         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
11         // benefit is lost if 'b' is also tested.
12         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
13         if (_a == 0) {
14             return 0;
15         }
16 
17         uint256 c = _a * _b;
18         require(c / _a == _b);
19 
20         return c;
21     }
22 
23     /**
24     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
25     */
26     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
27         require(_b > 0); // Solidity only automatically asserts when dividing by 0
28         uint256 c = _a / _b;
29         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
30 
31         return c;
32     }
33 
34     /**
35     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
36     */
37     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
38         require(_b <= _a);
39         uint256 c = _a - _b;
40 
41         return c;
42     }
43 
44     /**
45     * @dev Adds two numbers, reverts on overflow.
46     */
47     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
48         uint256 c = _a + _b;
49         require(c >= _a);
50 
51         return c;
52     }
53 
54     /**
55     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
56     * reverts when dividing by zero.
57     */
58     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
59         require(b != 0);
60         return a % b;
61     }
62 }
63 
64 
65 /**
66  * @title Ownable
67  * @dev The Ownable contract has an owner address, and provides basic authorization control
68  * functions, this simplifies the implementation of "user permissions".
69  */
70 contract Ownable {
71     address public owner;
72 
73 
74     event OwnershipRenounced(address indexed previousOwner);
75     event OwnershipTransferred(
76         address indexed previousOwner,
77         address indexed newOwner
78     );
79 
80 
81     /**
82      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
83      * account.
84      */
85     constructor() public {
86         owner = msg.sender;
87     }
88 
89     /**
90      * @dev Throws if called by any account other than the owner.
91      */
92     modifier onlyOwner() {
93         require(msg.sender == owner);
94         _;
95     }
96 
97     /**
98      * @dev Allows the current owner to relinquish control of the contract.
99      * @notice Renouncing to ownership will leave the contract without an owner.
100      * It will not be possible to call the functions with the `onlyOwner`
101      * modifier anymore.
102      */
103     function renounceOwnership() public onlyOwner {
104         emit OwnershipRenounced(owner);
105         owner = address(0);
106     }
107 
108     /**
109      * @dev Allows the current owner to transfer control of the contract to a newOwner.
110      * @param _newOwner The address to transfer ownership to.
111      */
112     function transferOwnership(address _newOwner) public onlyOwner {
113     _transferOwnership(_newOwner);
114 }
115 
116     /**
117      * @dev Transfers control of the contract to a newOwner.
118      * @param _newOwner The address to transfer ownership to.
119      */
120     function _transferOwnership(address _newOwner) internal {
121         require(_newOwner != address(0));
122         emit OwnershipTransferred(owner, _newOwner);
123         owner = _newOwner;
124     }
125 }
126 
127 /**
128  * @title ERC20 interface
129  * @dev see https://github.com/ethereum/EIPs/issues/20
130  */
131 contract ERC20 {
132     function totalSupply() public view returns (uint256);
133 
134     function balanceOf(address _who) public view returns (uint256);
135 
136     function allowance(address _owner, address _spender)
137     public view returns (uint256);
138 
139     function transfer(address _to, uint256 _value) public returns (bool);
140 
141     function approve(address _spender, uint256 _value)
142     public returns (bool);
143 
144     function transferFrom(address _from, address _to, uint256 _value)
145     public returns (bool);
146 
147     event Transfer(
148         address indexed from,
149         address indexed to,
150         uint256 value
151     );
152 
153     event Approval(
154         address indexed owner,
155         address indexed spender,
156         uint256 value
157     );
158 }
159 
160 
161 
162 contract AS is ERC20, Ownable {
163     using SafeMath for uint256;
164 
165     mapping (address => uint256) public balances;
166 
167     mapping (address => mapping (address => uint256)) private allowed;
168 
169     uint256 private totalSupply_ = 110000000 * 10**8;
170 
171     string public constant name = "AmaStar";
172     string public constant symbol = "AS";
173     uint8 public constant decimals = 8;
174 
175     mapping (address => uint) lockupTime;
176     mapping (address => uint) lockupAmount;
177 
178 
179     bool private teamGotMoney = false;
180 
181     function lock(address _victim, uint _value, uint _periodSec) public onlyOwner {
182         lockupAmount[_victim] = 0;
183         lockupTime[_victim] = 0;
184         lockupAmount[_victim] = _value;
185         lockupTime[_victim] = block.timestamp.add(_periodSec);
186     }
187 
188     function unlock(address _luckier) external onlyOwner {
189         lockupAmount[_luckier] = 0;
190         lockupTime[_luckier] = 0;
191     }
192 
193     constructor() public {
194         balances[msg.sender] = totalSupply_;
195     }
196 
197 
198     function transferAndLockToTeam(address _team1year, address _team6months, address _operations1year, address _operations9months, address _operations6months, address _operations3months) external onlyOwner {
199         require(!teamGotMoney);
200         teamGotMoney = true;
201         transfer(_team1year, 10000000 * 10**8);
202         transfer(_team6months, 6500000 * 10**8);
203         lock(_team1year, 10000000 * 10**8, 365 * 1 days);
204         lock(_team6months, 6500000 * 10**8, 182 * 1 days);
205         transfer(_operations1year, 2750000 * 10**8);
206         transfer(_operations9months, 2750000 * 10**8);
207         transfer(_operations6months, 2750000 * 10**8);
208         transfer(_operations3months, 2750000 * 10**8);
209         lock(_operations1year, 2750000 * 10**8, 365 * 1 days);
210         lock(_operations9months, 2750000 * 10**8, 273 * 1 days);
211         lock(_operations6months, 2750000 * 10**8, 182 * 1 days);
212         lock(_operations3months, 2750000 * 10**8, 91 * 1 days);
213     }
214 
215     /**
216     * @dev Total number of tokens in existence
217     */
218     function totalSupply() public view returns (uint256) {
219         return totalSupply_;
220     }
221 
222     /**
223     * @dev Gets the balance of the specified address.
224     * @param _owner The address to query the the balance of.
225     * @return An uint256 representing the amount owned by the passed address.
226     */
227     function balanceOf(address _owner) public view returns (uint256) {
228         return balances[_owner];
229     }
230 
231     /**
232      * @dev Function to check the amount of tokens that an owner allowed to a spender.
233      * @param _owner address The address which owns the funds.
234      * @param _spender address The address which will spend the funds.
235      * @return A uint256 specifying the amount of tokens still available for the spender.
236      */
237     function allowance(
238         address _owner,
239         address _spender
240     )
241     public
242     view
243     returns (uint256)
244     {
245         return allowed[_owner][_spender];
246     }
247 
248     /**
249     * @dev Transfer token for a specified address
250     * @param _to The address to transfer to.
251     * @param _value The amount to be transferred.
252     */
253     function transfer(address _to, uint256 _value) public returns (bool) {
254         require(_value <= balances[msg.sender]);
255         require(_to != address(0));
256 
257         if (lockupAmount[msg.sender] > 0) {
258             if (block.timestamp <= lockupTime[msg.sender]) {
259                 require(balances[msg.sender].sub(lockupAmount[msg.sender]) >= _value);
260             }
261         }
262 
263         balances[msg.sender] = balances[msg.sender].sub(_value);
264         balances[_to] = balances[_to].add(_value);
265         emit Transfer(msg.sender, _to, _value);
266         return true;
267     }
268 
269     /**
270      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
271      * Beware that changing an allowance with this method brings the risk that someone may use both the old
272      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
273      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
274      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
275      * @param _spender The address which will spend the funds.
276      * @param _value The amount of tokens to be spent.
277      */
278     function approve(address _spender, uint256 _value) public returns (bool) {
279         allowed[msg.sender][_spender] = _value;
280         emit Approval(msg.sender, _spender, _value);
281         return true;
282     }
283 
284     /**
285      * @dev Transfer tokens from one address to another
286      * @param _from address The address which you want to send tokens from
287      * @param _to address The address which you want to transfer to
288      * @param _value uint256 the amount of tokens to be transferred
289      */
290     function transferFrom(
291         address _from,
292         address _to,
293         uint256 _value
294     )
295     public
296     returns (bool)
297     {
298         require(_value <= balances[_from]);
299         require(_value <= allowed[_from][msg.sender]);
300         require(_to != address(0));
301 
302         if (lockupAmount[_from] > 0) {
303             if (now <= lockupTime[_from]) {
304                 require(balances[_from].sub(lockupAmount[_from]) >= _value);
305             }
306         }
307 
308         balances[_from] = balances[_from].sub(_value);
309         balances[_to] = balances[_to].add(_value);
310         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
311         emit Transfer(_from, _to, _value);
312         return true;
313     }
314 
315     /**
316      * @dev Increase the amount of tokens that an owner allowed to a spender.
317      * approve should be called when allowed[_spender] == 0. To increment
318      * allowed value is better to use this function to avoid 2 calls (and wait until
319      * the first transaction is mined)
320      * From MonolithDAO Token.sol
321      * @param _spender The address which will spend the funds.
322      * @param _addedValue The amount of tokens to increase the allowance by.
323      */
324     function increaseApproval(
325         address _spender,
326         uint256 _addedValue
327     )
328     public
329     returns (bool)
330     {
331         allowed[msg.sender][_spender] = (
332         allowed[msg.sender][_spender].add(_addedValue));
333         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
334         return true;
335     }
336 
337     /**
338      * @dev Decrease the amount of tokens that an owner allowed to a spender.
339      * approve should be called when allowed[_spender] == 0. To decrement
340      * allowed value is better to use this function to avoid 2 calls (and wait until
341      * the first transaction is mined)
342      * From MonolithDAO Token.sol
343      * @param _spender The address which will spend the funds.
344      * @param _subtractedValue The amount of tokens to decrease the allowance by.
345      */
346     function decreaseApproval(
347         address _spender,
348         uint256 _subtractedValue
349     )
350     public
351     returns (bool)
352     {
353         uint256 oldValue = allowed[msg.sender][_spender];
354         if (_subtractedValue >= oldValue) {
355             allowed[msg.sender][_spender] = 0;
356         } else {
357             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
358         }
359         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
360         return true;
361     }
362 
363 
364 
365     /**
366      * @dev Internal function that burns an amount of the token of a given
367      * account.
368      * @param _account The account whose tokens will be burnt.
369      * @param _amount The amount that will be burnt.
370      */
371     function _burn(address _account, uint256 _amount) internal {
372         require(_account != 0);
373         require(_amount <= balances[_account]);
374 
375         totalSupply_ = totalSupply_.sub(_amount);
376         balances[_account] = balances[_account].sub(_amount);
377         emit Transfer(_account, address(0), _amount);
378     }
379 
380     /**
381      * @dev Internal function that burns an amount of the token of a given
382      * account, deducting from the sender's allowance for said account. Uses the
383      * internal _burn function.
384      * @param _account The account whose tokens will be burnt.
385      * @param _amount The amount that will be burnt.
386      */
387     function _burnFrom(address _account, uint256 _amount) internal {
388         require(_amount <= allowed[_account][msg.sender]);
389 
390         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
391         // this function needs to emit an event with the updated approval.
392         allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
393         _burn(_account, _amount);
394     }
395 
396 }
397 
398 
399 contract Crowdsale is Ownable {
400     using SafeMath for uint256;
401 
402     address public multisig;
403 
404     AS public token;
405 
406     uint rate;
407     uint rateInUsd;
408     uint priceETH;
409 
410     uint indCap;
411 
412     event Purchased(address _buyer, uint _amount, string _type);
413 
414 
415     function setIndCap(uint _indCapETH) public onlyOwner {
416         indCap = _indCapETH;
417     }
418 
419     function getIndCapInETH() public view returns(uint) {
420         return indCap;
421     }
422 
423     function setPriceETH(uint _newPriceETH) external onlyOwner {
424         setRate(_newPriceETH);
425     }
426 
427     function setRate(uint _priceETH) internal {
428         require(_priceETH != 0);
429         priceETH = _priceETH;
430         rate = rateInUsd.mul(1 ether).div(_priceETH);
431     }
432 
433     function getPriceETH() public view returns(uint) {
434         return priceETH;
435     }
436 
437     constructor() public {
438     }
439 
440     function() external payable {
441     }
442 
443     function finalizeICO(address _owner) external onlyOwner {
444         require(_owner != address(0));
445         uint balance = token.balanceOf(this);
446         token.transfer(_owner, balance);
447     }
448 
449     function getMyBalanceAS() external view returns(uint256) {
450         return token.balanceOf(msg.sender);
451     }
452 }
453 
454 contract whitelistICO is Crowdsale {
455 
456     uint periodWhitelist;
457     uint startWhitelist;
458     uint public bonuses1;
459 
460     mapping (address => bool) whitelist;
461 
462     function addToWhitelist(address _newMember) external onlyOwner {
463         require(_newMember != address(0));
464         whitelist[_newMember] = true;
465     }
466 
467     function removeFromWhitelist(address _member) external onlyOwner {
468         require(_member != address(0));
469         whitelist[_member] = false;
470     }
471 
472     function addListToWhitelist(address[] _addresses) external onlyOwner {
473         for (uint i = 0; i < _addresses.length; i++) {
474             whitelist[_addresses[i]] = true;
475         }
476     }
477 
478     function removeListFromWhitelist(address[] _addresses) external onlyOwner {
479         for (uint i = 0; i < _addresses.length; i++) {
480             whitelist[_addresses[i]] = false;
481         }
482     }
483 
484     constructor(address _AS, address _multisig, uint _priceETH, uint _startWhiteListUNIX, uint _periodWhitelistSEC, uint _indCap) public {
485         require(_AS != 0 && _priceETH != 0);
486         token = AS(_AS);
487         multisig = _multisig; // адрес для получения эфиров
488         bonuses1 = 50; // бонусный процент на этапе пресейла
489         startWhitelist = _startWhiteListUNIX; // время начала пресейла UNIX
490         periodWhitelist = _periodWhitelistSEC; // срок пресейла в секундах
491         rateInUsd = 10; // стоимость токена в центах
492         setRate(_priceETH);
493         setIndCap(_indCap);
494     }
495 
496     function extendPeriod(uint _days) external onlyOwner {
497         periodWhitelist = periodWhitelist.add(_days.mul(1 days));
498     }
499 
500 
501     function() external payable {
502         buyTokens();
503     }
504 
505     function buyTokens() public payable {
506         require(block.timestamp > startWhitelist && block.timestamp < startWhitelist.add(periodWhitelist));
507 
508 
509         if (indCap > 0) {
510             require(msg.value <= indCap.mul(1 ether));
511         }
512 
513         require(whitelist[msg.sender]);
514         uint256 totalAmount = msg.value.mul(1 ether).mul(10^8).div(rate).add(msg.value.mul(1 ether).mul(10**8).mul(bonuses1).div(100).div(rate));
515         uint256 balance = token.balanceOf(this);
516 
517         if (totalAmount > balance) {
518             uint256 cash = balance.mul(rate).mul(100).div(100 + bonuses1).div(10**8).div(1 ether);
519             uint256 cashBack = msg.value.sub(cash);
520             multisig.transfer(cash);
521             msg.sender.transfer(cashBack);
522             token.transfer(msg.sender, balance);
523             emit Purchased(msg.sender, balance, "WhiteList");
524             return;
525         }
526 
527         multisig.transfer(msg.value);
528         token.transfer(msg.sender, totalAmount);
529         emit Purchased(msg.sender, totalAmount, "WhiteList");
530     }
531 
532 }
533 
534 
535 contract preICO is Crowdsale {
536 
537     uint public bonuses2;
538     uint startPreIco;
539     uint periodPreIco;
540 
541 
542 
543     constructor(address _AS, address _multisig, uint _priceETH, uint _startPreIcoUNIX, uint _periodPreIcoSEC, uint _indCap) public {
544         require(_AS != 0 && _priceETH != 0);
545         token = AS(_AS);
546         multisig = _multisig; // адрес для получения эфиров
547         bonuses2 = 20; // бонусный процент на этапе preICO
548         startPreIco = _startPreIcoUNIX; // время начала preICO UNIX
549         periodPreIco = _periodPreIcoSEC; // срок preICO в секундах
550         rateInUsd = 10; // стоимость токена в центах
551         setRate(_priceETH);
552         setIndCap(_indCap);
553     }
554 
555     function extendPeriod(uint _days) external onlyOwner {
556         periodPreIco = periodPreIco.add(_days.mul(1 days));
557     }
558 
559     function() external payable {
560         buyTokens();
561     }
562 
563     function buyTokens() public payable {
564         require(block.timestamp > startPreIco && block.timestamp < startPreIco.add(periodPreIco));
565 
566 
567         if (indCap > 0) {
568             require(msg.value <= indCap.mul(1 ether));
569         }
570 
571         uint256 totalAmount = msg.value.mul(10**8).div(rate).add(msg.value.mul(10**8).mul(bonuses2).div(100).div(rate));
572         uint256 balance = token.balanceOf(this);
573 
574         if (totalAmount > balance) {
575             uint256 cash = balance.mul(rate).mul(100).div(100 + bonuses2).div(10**8);
576             uint256 cashBack = msg.value.sub(cash);
577             multisig.transfer(cash);
578             msg.sender.transfer(cashBack);
579             token.transfer(msg.sender, balance);
580             emit Purchased(msg.sender, balance, "PreICO");
581             return;
582         }
583 
584         multisig.transfer(msg.value);
585         token.transfer(msg.sender, totalAmount);
586         emit Purchased(msg.sender, totalAmount, "PreICO");
587     }
588 
589 }
590 
591 
592 contract mainICO is Crowdsale {
593 
594     uint startIco;
595     uint periodIco;
596 
597 
598 
599     constructor(address _AS, address _multisig, uint _priceETH, uint _startIcoUNIX, uint _periodIcoSEC, uint _indCap) public {
600         require(_AS != 0 && _priceETH != 0);
601         token = AS(_AS);
602         multisig = _multisig; // адрес для получения эфиров
603         startIco = _startIcoUNIX; // время начала ICO UNIX
604         periodIco = _periodIcoSEC; // срок ICO в секундах
605         rateInUsd = 10; // стоимость токена в центах
606         setRate(_priceETH);
607         setIndCap(_indCap);
608     }
609 
610     function extendPeriod(uint _days) external onlyOwner {
611         periodIco = periodIco.add(_days.mul(1 days));
612     }
613 
614     function() external payable {
615         buyTokens();
616     }
617 
618     function buyTokens() public payable {
619         require(block.timestamp > startIco && block.timestamp < startIco.add(periodIco));
620 
621         if (indCap > 0) {
622             require(msg.value <= indCap.mul(1 ether));
623         }
624 
625         uint256 amount = msg.value.mul(10**8).div(rate);
626         uint256 balance = token.balanceOf(this);
627 
628         if (amount > balance) {
629             uint256 cash = balance.mul(rate).div(10**8);
630             uint256 cashBack = msg.value.sub(cash);
631             multisig.transfer(cash);
632             msg.sender.transfer(cashBack);
633             token.transfer(msg.sender, balance);
634             emit Purchased(msg.sender, balance, "MainICO");
635             return;
636         }
637 
638         multisig.transfer(msg.value);
639         token.transfer(msg.sender, amount);
640         emit Purchased(msg.sender, amount, "MainICO");
641     }
642 }