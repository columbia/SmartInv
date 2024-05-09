1 pragma solidity ^0.4.18;
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
57         Transfer(msg.sender, _to, _value);
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
90         var _allowance = allowed[_from][msg.sender];
91 
92         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
93         // require (_value <= _allowance);
94 
95         balances[_to] = balances[_to].add(_value);
96         balances[_from] = balances[_from].sub(_value);
97         allowed[_from][msg.sender] = _allowance.sub(_value);
98         Transfer(_from, _to, _value);
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
116         Approval(msg.sender, _spender, _value);
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
292         Transfer(toSaleWallet, beneficiary, qty);
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
375         require(_startTime >= now);
376         require(_endTime >= _startTime);
377         require(_tokensLimit > 0);
378         require(_multisigWallet != address(0));
379 
380         saleInited = true;
381 
382         token = _token;
383         startTime = _startTime;
384         endTime = _endTime;
385         tokensLimit = _tokensLimit;
386         multisigWallet = _multisigWallet;
387         minimalPrice = _minimalPrice;
388         bonusPreset = _bonusPreset;
389 
390         initBonuses(bonusPreset);
391     }
392 
393     function activate() public onlyConfigurerOrOwner {
394         require(!activated);
395         require(!closed);
396         activated = true;
397     }
398 
399     function close() public onlyConfigurerOrOwner {
400         activated = true;
401         closed = true;
402     }
403 
404     function setMultisigWallet(address _multisigWallet) public onlyConfigurerOrOwner {
405         multisigWallet = _multisigWallet;
406     }
407 
408     function () external payable {
409         buyTokens(msg.sender);
410     }
411 
412     function buyTokens(address beneficiary) public payable {
413         require(beneficiary != address(0));
414         require(validPurchase());
415 
416         uint256 amount = msg.value;
417         uint256 tokens = calculateTokensQtyByEther({
418                 amount: amount
419             });
420 
421         require(tokensTransferred.add(tokens) < tokensLimit);
422 
423         tokensTransferred = tokensTransferred.add(tokens);
424         collected = collected.add(amount);
425 
426         token.purchase(beneficiary, tokens);
427         TokenPurchase(msg.sender, beneficiary, amount, tokens);
428 
429         forwardFunds();
430     }
431 
432     function forwardFunds() internal {
433         multisigWallet.transfer(msg.value);
434     }
435 
436     function validPurchase() internal constant returns (bool) {
437         bool withinPeriod = now >= startTime && now <= endTime;
438         bool nonZeroPurchase = msg.value != 0;
439         bool minimalPriceChecked = msg.value >= minimalPrice;
440         return withinPeriod && nonZeroPurchase && minimalPriceChecked && activated && !closed;
441     }
442 
443     function isEnded() public constant returns (bool) {
444         return now > endTime;
445     }
446 }
447 
448 
449 contract DoubleLandICO_TEST is Ownable {
450     using SafeMath for uint256;
451 
452     DLCToken public token;
453 
454     Sale[] public sales;
455 
456     uint256 public softCap;
457     uint256 public hardCap;
458 
459     uint public activatedSalesTotalCount = 0;
460     uint public maxActivatedSalesTotalCount;
461 
462     address public multisigWallet;
463 
464     bool public isDeployed = false;
465 
466     function createSale(string _bonusPreset, uint256 _startTime, uint256 _endTime,  uint256 _tokensLimit, uint256 _minimalPrice) public onlyOwner{
467         require(activatedSalesTotalCount < maxActivatedSalesTotalCount);
468         require(getTotalCollected() < hardCap );
469         require(token.getRestTokenBalance() >= _tokensLimit);
470         require(sales.length == 0 || sales[sales.length - 1].activated());
471         Sale newSale = new Sale();
472 
473         newSale.init({
474             _bonusPreset: _bonusPreset,
475             _startTime: _startTime,
476             _endTime: _endTime,
477             _tokensLimit: _tokensLimit,
478             _minimalPrice: _minimalPrice,
479             _token: token,
480             _multisigWallet: multisigWallet
481             });
482         newSale.transferOwnership(owner);
483 
484         sales.push(newSale);
485     }
486 
487     function activateLastSale() public onlyOwner {
488         require(activatedSalesTotalCount < maxActivatedSalesTotalCount);
489         require(!sales[sales.length - 1].activated());
490         activatedSalesTotalCount ++;
491         sales[sales.length - 1].activate();
492         token.setSaleAgent(sales[sales.length - 1]);
493     }
494 
495     function removeLastSaleOnlyNotActivated() public onlyOwner {
496         require(!sales[sales.length - 1].activated());
497         delete sales[sales.length - 1];
498     }
499 
500     function closeAllSales() public onlyOwner {
501         for (uint i = 0; i < sales.length; i++) {
502             sales[i].close();
503         }
504     }
505 
506     function setGlobalMultisigWallet(address _multisigWallet) public onlyOwner {
507         multisigWallet = _multisigWallet;
508         for (uint i = 0; i < sales.length; i++) {
509             if (!sales[i].closed()) {
510                 sales[i].setMultisigWallet(multisigWallet);
511             }
512         }
513     }
514 
515     function getTotalCollected() public constant returns(uint256) {
516         uint256 _totalCollected = 0;
517         for (uint i = 0; i < sales.length; i++) {
518             _totalCollected = _totalCollected + sales[i].collected();
519         }
520         return _totalCollected;
521     }
522 
523     function getCurrentSale() public constant returns(address) {
524         return token.saleAgent();
525     }
526 
527     function deploy() public onlyOwner {
528         require(!isDeployed);
529         isDeployed = true;
530 
531         softCap = 6000 ether;
532         hardCap = 25000 ether;
533         maxActivatedSalesTotalCount = 5;
534 
535         setGlobalMultisigWallet(0xcC6E23E740FBc50e242B6B90f0BcaF64b83BF813);
536 
537         token = new DLCToken();
538         token.setTotalSupply(1000000000 * 1 ether);
539         token.setFoundersTokensPercent(15);
540         token.setBountyTokensPercent(1);
541         token.setDevelopmentAuditPromotionTokensPercent(10);
542         token.setPriceOfToken(0.00013749 * 1 ether);
543         token.setToSaleWallet(0xf9D1398a6e2c856fab73B5baaD13D125EDe30006);
544         token.setBountyWallet(0xFc6248b06e65686C9aDC5f4F758bBd716BaE80e1);
545         token.setFoundersWallet(0xf54315F87480f87Bfa2fCe97aCA036fd90223516);
546         token.setDevelopmentAuditPromotionWallet(0x34EEA5f12DeF816Bd86F682eDc6010500dd51976);
547         token.transferOwnership(owner);
548         token.init();
549 
550         createSale({
551             _bonusPreset: 'privatesale',
552             _startTime: 1522342800, // 29.03.2018
553            // _startTime: 1523318400, // 2018-04-10
554             _endTime:   1524614400, // 2018-04-25
555             _tokensLimit: 80000000 * 1 ether,
556             _minimalPrice: 1 ether
557             });
558         activateLastSale();
559 
560         createSale({
561             _bonusPreset: 'presale',
562             _startTime: 1525910400, // 2018-05-10
563             _endTime:   1527206400, // 2018-05-25
564             _tokensLimit: 75000000 * 1 ether,
565             _minimalPrice: 0.03 ether
566             });
567     }
568 }