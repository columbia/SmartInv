1 pragma solidity ^0.4.21;
2 
3 contract ERC20Basic {
4     uint256 public totalSupply;
5     function balanceOf(address who) public constant returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11     function allowance(address owner, address spender) public constant returns (uint256);
12     function transferFrom(address from, address to, uint256 value) public returns (bool);
13     function approve(address spender, uint256 value) public returns (bool);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 library SafeMath {
18 
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a * b;
21         assert(a == 0 || c / a == b);
22         return c;
23     }
24 
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a / b;
27         return c;
28     }
29 
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     function add(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a + b;
37         assert(c >= a);
38         return c;
39     }
40 
41 }
42 
43 contract BasicToken is ERC20Basic {
44 
45     using SafeMath for uint256;
46 
47     mapping(address => uint256) balances;
48 
49     /**
50     * @dev transfer token for a specified address
51     * @param _to The address to transfer to.
52     * @param _value The amount to be transferred.
53     */
54     function transfer(address _to, uint256 _value) public returns (bool) {
55         balances[msg.sender] = balances[msg.sender].sub(_value);
56         balances[_to] = balances[_to].add(_value);
57         emit Transfer(msg.sender, _to, _value);
58         return true;
59     }
60 
61     /**
62     * @dev Gets the balance of the specified address.
63     * @param _owner The address to query the the balance of.
64     * @return An uint256 representing the amount owned by the passed address.
65     */
66     function balanceOf(address _owner) public constant returns (uint256 balance) {
67         return balances[_owner];
68     }
69 
70 }
71 
72 /**
73  * @title Standard ERC20 token
74  *
75  * @dev Implementation of the basic standard token.
76  * @dev https://github.com/ethereum/EIPs/issues/20
77  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
78  */
79 contract StandardToken is ERC20, BasicToken {
80 
81     mapping (address => mapping (address => uint256)) allowed;
82 
83     /**
84      * @dev Transfer tokens from one address to another
85      * @param _from address The address which you want to send tokens from
86      * @param _to address The address which you want to transfer to
87      * @param _value uint256 the amout of tokens to be transfered
88      */
89     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
90         uint256 _allowance = allowed[_from][msg.sender];
91 
92         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
93         // require (_value <= _allowance);
94 
95         balances[_to] = balances[_to].add(_value);
96         balances[_from] = balances[_from].sub(_value);
97         allowed[_from][msg.sender] = _allowance.sub(_value);
98         emit Transfer(_from, _to, _value);
99         return true;
100     }
101 
102     /**
103      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
104      * @param _spender The address which will spend the funds.
105      * @param _value The amount of tokens to be spent.
106      */
107     function approve(address _spender, uint256 _value) public returns (bool) {
108 
109         // To change the approve amount you first have to reduce the addresses`
110         //  allowance to zero by calling `approve(_spender, 0)` if it is not
111         //  already 0 to mitigate the race condition described here:
112         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
113         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
114 
115         allowed[msg.sender][_spender] = _value;
116         emit Approval(msg.sender, _spender, _value);
117         return true;
118     }
119 
120     /**
121      * @dev Function to check the amount of tokens that an owner allowed to a spender.
122      * @param _owner address The address which owns the funds.
123      * @param _spender address The address which will spend the funds.
124      * @return A uint256 specifing the amount of tokens still available for the spender.
125      */
126     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
127         return allowed[_owner][_spender];
128     }
129 
130 }
131 
132 /**
133  * @title Ownable
134  * @dev The Ownable contract has an owner address, and provides basic authorization control
135  * functions, this simplifies the implementation of "user permissions".
136  */
137 contract Ownable {
138 
139     address public owner;
140 
141     /**
142      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
143      * account.
144      */
145     function Ownable() public {
146         owner = msg.sender;
147     }
148 
149     /**
150      * @dev Throws if called by any account other than the owner.
151      */
152     modifier onlyOwner() {
153         require(msg.sender == owner);
154         _;
155     }
156 
157     /**
158      * @dev Allows the current owner to transfer control of the contract to a newOwner.
159      * @param newOwner The address to transfer ownership to.
160      */
161     function transferOwnership(address newOwner) public onlyOwner {
162         require(newOwner != address(0));
163         owner = newOwner;
164     }
165 
166     event OwnerLog(address a);
167 
168 }
169 
170 contract Configurable is Ownable {
171 
172     address public configurer;
173 
174     function Configurable() public {
175         configurer = msg.sender;
176     }
177 
178     modifier onlyConfigurerOrOwner() {
179         require(msg.sender == configurer || msg.sender == owner);
180         _;
181     }
182 
183     modifier onlyConfigurer() {
184         require(msg.sender == configurer);
185         _;
186     }
187 }
188 
189 contract DLCToken is StandardToken, Configurable {
190 
191     string public constant name = "DoubleLand Coin";
192     string public constant symbol = "DLC";
193     uint32 public constant decimals = 18;
194 
195     uint256 public priceOfToken;
196 
197     bool tokenBeenInit = false;
198 
199     uint public constant percentRate = 100;
200     uint public investorsTokensPercent;
201     uint public foundersTokensPercent;
202     uint public bountyTokensPercent;
203     uint public developmentAuditPromotionTokensPercent;
204 
205     address public toSaleWallet;
206     address public bountyWallet;
207     address public foundersWallet;
208     address public developmentAuditPromotionWallet;
209 
210     address public saleAgent;
211 
212 
213     function DLCToken() public {
214     }
215 
216     modifier notInit() {
217         require(!tokenBeenInit);
218         _;
219     }
220 
221     function setSaleAgent(address newSaleAgent) public onlyConfigurerOrOwner{
222         saleAgent = newSaleAgent;
223     }
224 
225     function setPriceOfToken(uint256 newPriceOfToken) public onlyConfigurerOrOwner{
226         priceOfToken = newPriceOfToken;
227     }
228 
229     function setTotalSupply(uint256 _totalSupply) public notInit onlyConfigurer{
230         totalSupply = _totalSupply;
231     }
232 
233     function setFoundersTokensPercent(uint _foundersTokensPercent) public notInit onlyConfigurer{
234         foundersTokensPercent = _foundersTokensPercent;
235     }
236 
237     function setBountyTokensPercent(uint _bountyTokensPercent) public notInit onlyConfigurer{
238         bountyTokensPercent = _bountyTokensPercent;
239     }
240 
241     function setDevelopmentAuditPromotionTokensPercent(uint _developmentAuditPromotionTokensPercent) public notInit onlyConfigurer{
242         developmentAuditPromotionTokensPercent = _developmentAuditPromotionTokensPercent;
243     }
244 
245     function setBountyWallet(address _bountyWallet) public notInit onlyConfigurer{
246         bountyWallet = _bountyWallet;
247     }
248 
249     function setToSaleWallet(address _toSaleWallet) public notInit onlyConfigurer{
250         toSaleWallet = _toSaleWallet;
251     }
252 
253     function setFoundersWallet(address _foundersWallet) public notInit onlyConfigurer{
254         foundersWallet = _foundersWallet;
255     }
256 
257     function setDevelopmentAuditPromotionWallet(address _developmentAuditPromotionWallet) public notInit onlyConfigurer {
258         developmentAuditPromotionWallet = _developmentAuditPromotionWallet;
259     }
260 
261     function init() public notInit onlyConfigurer{
262         require(totalSupply > 0);
263         require(foundersTokensPercent > 0);
264         require(bountyTokensPercent > 0);
265         require(developmentAuditPromotionTokensPercent > 0);
266         require(foundersWallet != address(0));
267         require(bountyWallet != address(0));
268         require(developmentAuditPromotionWallet != address(0));
269         tokenBeenInit = true;
270 
271         investorsTokensPercent = percentRate - (foundersTokensPercent + bountyTokensPercent + developmentAuditPromotionTokensPercent);
272 
273         balances[toSaleWallet] = totalSupply.mul(investorsTokensPercent).div(percentRate);
274         balances[foundersWallet] = totalSupply.mul(foundersTokensPercent).div(percentRate);
275         balances[bountyWallet] = totalSupply.mul(bountyTokensPercent).div(percentRate);
276         balances[developmentAuditPromotionWallet] = totalSupply.mul(developmentAuditPromotionTokensPercent).div(percentRate);
277     }
278 
279     function getRestTokenBalance() public constant returns (uint256) {
280         return balances[toSaleWallet];
281     }
282 
283     function purchase(address beneficiary, uint256 qty) public {
284         require(msg.sender == saleAgent || msg.sender == owner);
285         require(beneficiary != address(0));
286         require(qty > 0);
287         require((getRestTokenBalance().sub(qty)) > 0);
288 
289         balances[beneficiary] = balances[beneficiary].add(qty);
290         balances[toSaleWallet] = balances[toSaleWallet].sub(qty);
291 
292         emit Transfer(toSaleWallet, beneficiary, qty);
293     }
294 
295     function () public payable {
296         revert();
297     }
298 }
299 
300 contract Bonuses {
301     using SafeMath for uint256;
302 
303     DLCToken public token;
304 
305     uint256 public startTime;
306     uint256 public endTime;
307 
308     mapping(uint => uint256) public bonusOfDay;
309 
310     bool public bonusInited = false;
311 
312     function initBonuses (string _preset) public {
313         require(!bonusInited);
314         bonusInited = true;
315         bytes32 preset = keccak256(_preset);
316 
317         if(preset == keccak256('privatesale')){
318             bonusOfDay[0] = 313;
319         } else
320         if(preset == keccak256('presale')){
321             bonusOfDay[0] = 210;
322         } else
323         if(preset == keccak256('generalsale')){
324             bonusOfDay[0] = 60;
325             bonusOfDay[7] = 38;
326             bonusOfDay[14] = 10;
327         }
328     }
329 
330     function calculateTokensQtyByEther(uint256 amount) public constant returns(uint256) {
331         int dayOfStart = int(now.sub(startTime).div(86400).add(1));
332         uint currentBonus = 0;
333         int i;
334 
335         for (i = dayOfStart; i >= 0; i--) {
336             if (bonusOfDay[uint(i)] > 0) {
337                 currentBonus = bonusOfDay[uint(i)];
338                 break;
339             }
340         }
341 
342         return amount.div(token.priceOfToken()).mul(currentBonus + 100).div(100).mul(1 ether);
343     }
344 }
345 
346 contract Sale is Configurable, Bonuses{
347     using SafeMath for uint256;
348 
349     address public multisigWallet;
350     uint256 public tokensLimit;
351     uint256 public minimalPrice;
352     uint256 public tokensTransferred = 0;
353 
354     string public bonusPreset;
355 
356     uint256 public collected = 0;
357 
358     bool public activated = false;
359     bool public closed = false;
360     bool public saleInited = false;
361 
362 
363     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
364 
365     function init(
366         string _bonusPreset,
367         uint256 _startTime,
368         uint256 _endTime,
369         uint256 _tokensLimit,
370         uint256 _minimalPrice,
371         DLCToken _token,
372         address _multisigWallet
373     ) public onlyConfigurer {
374         require(!saleInited);
375         require(_endTime >= _startTime);
376         require(_tokensLimit > 0);
377         require(_multisigWallet != address(0));
378 
379         saleInited = true;
380 
381         token = _token;
382         startTime = _startTime;
383         endTime = _endTime;
384         tokensLimit = _tokensLimit;
385         multisigWallet = _multisigWallet;
386         minimalPrice = _minimalPrice;
387         bonusPreset = _bonusPreset;
388 
389         initBonuses(bonusPreset);
390     }
391 
392     function activate() public onlyConfigurerOrOwner {
393         require(!activated);
394         require(!closed);
395         activated = true;
396     }
397 
398     function close() public onlyConfigurerOrOwner {
399         activated = true;
400         closed = true;
401     }
402 
403     function setMultisigWallet(address _multisigWallet) public onlyConfigurerOrOwner {
404         multisigWallet = _multisigWallet;
405     }
406 
407     function () external payable {
408         buyTokens(msg.sender);
409     }
410 
411     function buyTokens(address beneficiary) public payable {
412         require(beneficiary != address(0));
413         require(validPurchase());
414 
415         uint256 amount = msg.value;
416         uint256 tokens = calculateTokensQtyByEther({
417             amount: amount
418             });
419 
420         require(tokensTransferred.add(tokens) < tokensLimit);
421 
422         tokensTransferred = tokensTransferred.add(tokens);
423         collected = collected.add(amount);
424 
425         token.purchase(beneficiary, tokens);
426         emit TokenPurchase(msg.sender, beneficiary, amount, tokens);
427 
428         forwardFunds();
429     }
430 
431     function forwardFunds() internal {
432         multisigWallet.transfer(msg.value);
433     }
434 
435     function validPurchase() internal constant returns (bool) {
436         bool withinPeriod = now >= startTime && now <= endTime;
437         bool nonZeroPurchase = msg.value != 0;
438         bool minimalPriceChecked = msg.value >= minimalPrice;
439         return withinPeriod && nonZeroPurchase && minimalPriceChecked && activated && !closed;
440     }
441 
442     function isStarted() public constant returns (bool) {
443         return now > startTime;
444     }
445 
446     function isEnded() public constant returns (bool) {
447         return now > endTime;
448     }
449 }
450 
451 
452 contract DoubleLandICO is Ownable {
453     using SafeMath for uint256;
454 
455     DLCToken public token;
456 
457     Sale[] public sales;
458 
459     uint256 public softCap;
460     uint256 public hardCap;
461 
462     uint public activatedSalesTotalCount = 0;
463     uint public maxActivatedSalesTotalCount;
464 
465     address public multisigWallet;
466 
467     bool public isDeployed = false;
468 
469     function createSale(string _bonusPreset, uint256 _startTime, uint256 _endTime,  uint256 _tokensLimit, uint256 _minimalPrice) public onlyOwner{
470         require(activatedSalesTotalCount < maxActivatedSalesTotalCount);
471         require(getTotalCollected() < hardCap );
472         require(token.getRestTokenBalance() >= _tokensLimit);
473         require(sales.length == 0 || sales[sales.length - 1].activated());
474         Sale newSale = new Sale();
475 
476         newSale.init({
477             _bonusPreset: _bonusPreset,
478             _startTime: _startTime,
479             _endTime: _endTime,
480             _tokensLimit: _tokensLimit,
481             _minimalPrice: _minimalPrice,
482             _token: token,
483             _multisigWallet: multisigWallet
484             });
485         newSale.transferOwnership(owner);
486 
487         sales.push(newSale);
488     }
489 
490     function activateLastSale() public onlyOwner {
491         require(activatedSalesTotalCount < maxActivatedSalesTotalCount);
492         require(!sales[sales.length - 1].activated());
493         activatedSalesTotalCount ++;
494         sales[sales.length - 1].activate();
495         token.setSaleAgent(sales[sales.length - 1]);
496     }
497 
498     function removeLastSaleOnlyNotActivated() public onlyOwner {
499         require(!sales[sales.length - 1].activated());
500         delete sales[sales.length - 1];
501     }
502 
503     function closeAllSales() public onlyOwner {
504         for (uint i = 0; i < sales.length; i++) {
505             sales[i].close();
506         }
507     }
508 
509     function setGlobalMultisigWallet(address _multisigWallet) public onlyOwner {
510         multisigWallet = _multisigWallet;
511         for (uint i = 0; i < sales.length; i++) {
512             if (!sales[i].closed()) {
513                 sales[i].setMultisigWallet(multisigWallet);
514             }
515         }
516     }
517 
518     function getTotalCollected() public constant returns(uint256) {
519         uint256 _totalCollected = 0;
520         for (uint i = 0; i < sales.length; i++) {
521             _totalCollected = _totalCollected + sales[i].collected();
522         }
523         return _totalCollected;
524     }
525 
526     function getCurrentSale() public constant returns(address) {
527         return token.saleAgent();
528     }
529 
530     function deploy() public onlyOwner {
531         require(!isDeployed);
532         isDeployed = true;
533 
534         softCap = 8000 ether;
535         hardCap = 50000 ether;
536         maxActivatedSalesTotalCount = 5;
537 
538         setGlobalMultisigWallet(0x7649EFf762E46a63225297949e932e9c6e53A5D5);
539 
540         token = new DLCToken();
541         token.setTotalSupply(1000000000 * 1 ether);
542         token.setFoundersTokensPercent(15);
543         token.setBountyTokensPercent(1);
544         token.setDevelopmentAuditPromotionTokensPercent(10);
545         token.setPriceOfToken(0.000183 * 1 ether);
546         token.setToSaleWallet(0xd16b70A9170038085EBee1BD2a3035b142f62a0D);
547         token.setBountyWallet(0xaD88Ff7240E66F8a0f626F95c7D2aF7cA21265AA);
548         token.setFoundersWallet(0xdF1F7EB40Fe2646CDCC5d189BA0aBae0b0166465);
549         token.setDevelopmentAuditPromotionWallet(0x1028D60104Cd17F98409706e7c7B188B07ab679e);
550         token.transferOwnership(owner);
551         token.init();
552 
553         createSale({
554             _bonusPreset: 'privatesale',
555             _startTime: 1523739600, // 15.04.2018 00:00:00
556             _endTime:   1525035600, // 30.04.2018 00:00:00
557             _tokensLimit: 80000000 * 1 ether,
558             _minimalPrice: 1 ether
559             });
560         activateLastSale();
561 
562         createSale({
563             _bonusPreset: 'presale',
564             _startTime: 1526331600, // 15.05.2018 00:00:00
565             _endTime:   1527714000, // 31.05.2018 00:00:00
566             _tokensLimit: 75000000 * 1 ether,
567             _minimalPrice: 0.03 ether
568             });
569     }
570 }