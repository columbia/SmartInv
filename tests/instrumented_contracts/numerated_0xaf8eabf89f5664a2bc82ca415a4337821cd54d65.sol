1 pragma solidity ^0.4.23;
2 
3 // File: contracts/Ownable.sol
4 
5 contract Ownable {
6     address public owner;
7     
8     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9 
10     constructor() public {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner() {
15         require((msg.sender == owner) || (tx.origin == owner));
16         _;
17     }
18 
19     function transferOwnership(address newOwner) public onlyOwner {
20         require(newOwner != address(0));
21         emit OwnershipTransferred(owner, newOwner);
22         owner = newOwner;
23     }
24 }
25 
26 // File: contracts/SafeMath.sol
27 
28 /**
29  * @title SafeMath
30  * @dev Math operations with safety checks that throw on error
31  */
32 library SafeMath {
33 
34     /**
35     * @dev Multiplies two numbers, throws on overflow.
36     */
37     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
38         if (a == 0) {
39             return 0;
40         }
41         c = a * b;
42         assert(c / a == b);
43         return c;
44     }
45 
46     /**
47     * @dev Integer division of two numbers, truncating the quotient.
48     */
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         // assert(b > 0); // Solidity automatically throws when dividing by 0
51         // uint256 c = a / b;
52         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53         return a / b;
54     }
55 
56     /**
57     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
58     */
59     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60         assert(b <= a);
61         return a - b;
62     }
63 
64     /**
65     * @dev Adds two numbers, throws on overflow.
66     */
67     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
68         c = a + b;
69         assert(c >= a);
70         return c;
71     }
72 }
73 
74 // File: contracts/Bonus.sol
75 
76 contract Bonus is Ownable {
77     using SafeMath for uint256;
78     mapping(address => uint256) public buyerBonus;
79     mapping(address => bool) hasBought;
80     address[] public buyerList;
81     
82     function _addBonus(address _beneficiary, uint256 _bonus) internal {
83         if(hasBought[_beneficiary]){
84             buyerBonus[_beneficiary] = buyerBonus[_beneficiary].add(_bonus);
85         } else {
86             hasBought[_beneficiary] = true;
87             buyerList.push(_beneficiary);
88             buyerBonus[_beneficiary] = _bonus;
89         }
90     }
91 }
92 
93 // File: contracts/ERC20Basic.sol
94 
95 contract ERC20Basic {
96     function totalSupply() public view returns (uint256);
97     function balanceOf(address who) public view returns (uint256);
98     function transfer(address to, uint256 value) public returns (bool);
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 }
101 
102 // File: contracts/ERC20.sol
103 
104 contract ERC20 is ERC20Basic {
105     function allowance(address owner, address spender) public view returns (uint256);
106     function transferFrom(address from, address to, uint256 value) public returns (bool);
107     function approve(address spender, uint256 value) public returns (bool);
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 // File: contracts/CrowdSale.sol
112 
113 contract Crowdsale is Bonus {
114     using SafeMath for uint256;
115 
116     // The token being sold
117     ERC20 public token;
118 
119     // Address where funds are collected
120     address public wallet;
121 
122     // ICO exchange rate
123     uint256 public rate;
124 
125     // ICO Time
126     uint256 public openingTimePeriodOne;
127     uint256 public closingTimePeriodOne;
128     uint256 public openingTimePeriodTwo;
129     uint256 public closingTimePeriodTwo;
130     uint256 public bonusDeliverTime;
131 
132     // Diff bonus rate decided by time
133     uint256 public bonusRatePrivateSale;
134     uint256 public bonusRatePeriodOne;
135     uint256 public bonusRatePeriodTwo;
136 
137     // Token decimal
138     uint256 decimals;
139     uint256 public tokenUnsold;
140     uint256 public bonusUnsold;
141     uint256 public constant minPurchaseAmount = 0.1 ether;
142 
143     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
144     event TokenBonus(address indexed purchaser, address indexed beneficiary, uint256 bonus);
145 
146     modifier onlyWhileOpen {
147         require(block.timestamp <= closingTimePeriodTwo);
148         _;
149     }
150 
151     constructor (uint256 _openingTimePeriodOne, uint256 _closingTimePeriodOne, uint256 _openingTimePeriodTwo, uint256 _closingTimePeriodTwo, uint256 _bonusDeliverTime,
152         uint256 _rate, uint256 _bonusRatePrivateSale, uint256 _bonusRatePeriodOne, uint256 _bonusRatePeriodTwo, 
153         address _wallet, ERC20 _token, uint256 _decimals, uint256 _tokenUnsold, uint256 _bonusUnsold) public {
154         require(_wallet != address(0));
155         require(_token != address(0));
156         require(_openingTimePeriodOne >= block.timestamp);
157         require(_closingTimePeriodOne >= _openingTimePeriodOne);
158         require(_openingTimePeriodTwo >= _closingTimePeriodOne);
159         require(_closingTimePeriodTwo >= _openingTimePeriodTwo);
160 
161         wallet = _wallet;
162         token = _token;
163         openingTimePeriodOne = _openingTimePeriodOne;
164         closingTimePeriodOne = _closingTimePeriodOne;
165         openingTimePeriodTwo = _openingTimePeriodTwo;
166         closingTimePeriodTwo = _closingTimePeriodTwo;
167         bonusDeliverTime = _bonusDeliverTime;
168         rate = _rate;
169         bonusRatePrivateSale = _bonusRatePrivateSale;
170         bonusRatePeriodOne = _bonusRatePeriodOne;
171         bonusRatePeriodTwo = _bonusRatePeriodTwo;
172         tokenUnsold = _tokenUnsold;
173         bonusUnsold = _bonusUnsold;
174         decimals = _decimals;
175     }
176 
177     function () external payable {
178         buyTokens(msg.sender);
179     }
180 
181     function buyTokens(address _beneficiary) public payable {
182         uint256 weiAmount = msg.value;
183         _preValidatePurchase(_beneficiary, weiAmount);
184 
185         // calculate token amount to be sent
186         uint256 tokens = _getTokenAmount(weiAmount);
187         _processPurchase(_beneficiary, tokens);
188         emit TokenPurchase(
189             msg.sender,
190             _beneficiary,
191             weiAmount,
192             tokens
193         );
194 
195         // calculate bonus amount to be sent
196         uint256 bonus = _getTokenBonus(weiAmount);
197         _addBonus(_beneficiary, bonus);
198         bonusUnsold = bonusUnsold.sub(bonus);
199         emit TokenBonus(
200             msg.sender,
201             _beneficiary,
202             bonus
203         );
204         _forwardFunds();
205     }
206 	
207     function isClosed() public view returns (bool) {
208         return block.timestamp > closingTimePeriodTwo;
209     }
210 
211     function isOpened() public view returns (bool) {
212         return (block.timestamp < closingTimePeriodOne && block.timestamp > openingTimePeriodOne) || (block.timestamp < closingTimePeriodTwo && block.timestamp > openingTimePeriodTwo);
213     }
214 
215     function privateCrowdsale(address _beneficiary, uint256 _ethAmount) external onlyOwner{
216         _preValidatePurchase(_beneficiary, _ethAmount);
217 
218         // calculate token amount to be sent
219         uint256 tokens = _getTokenAmount(_ethAmount);
220         _processPurchase(_beneficiary, tokens);
221         emit TokenPurchase(
222             msg.sender,
223             _beneficiary,
224             _ethAmount,
225             tokens
226         );
227 
228         // calculate bonus amount to be sent
229         uint256 bonus = _ethAmount.mul(10 ** uint256(decimals)).div(1 ether).mul(bonusRatePrivateSale);
230         _addBonus(_beneficiary, bonus);
231         bonusUnsold = bonusUnsold.sub(bonus);
232         emit TokenBonus(
233             msg.sender,
234             _beneficiary,
235             bonus
236         );
237     }
238     
239     function returnToken() external onlyOwner{
240         require(block.timestamp > closingTimePeriodTwo);
241         require(tokenUnsold > 0);
242         token.transfer(wallet,tokenUnsold);
243         tokenUnsold = tokenUnsold.sub(tokenUnsold);
244     }
245 
246     /**
247      * WARNING: Make sure that user who owns bonus is still in whitelist!!!
248      */
249     function deliverBonus() public onlyOwner {
250         require(bonusDeliverTime <= block.timestamp);
251         for (uint i = 0; i<buyerList.length; i++){
252             uint256 amount = buyerBonus[buyerList[i]];
253             token.transfer(buyerList[i], amount);
254             buyerBonus[buyerList[i]] = 0;
255         }
256     }
257 
258     function returnBonus() external onlyOwner{
259         require(block.timestamp > bonusDeliverTime);
260         require(bonusUnsold > 0);
261         token.transfer(wallet, bonusUnsold);
262         bonusUnsold = bonusUnsold.sub(bonusUnsold);
263     }
264 
265     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view onlyWhileOpen
266     {
267         require(_beneficiary != address(0));
268         require(_weiAmount >= minPurchaseAmount);
269     }
270 
271     function _validateMaxSellAmount(uint256 _tokenAmount) internal view onlyWhileOpen {
272         require(tokenUnsold >= _tokenAmount);
273     }
274 
275     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
276         token.transfer(_beneficiary, _tokenAmount);
277         tokenUnsold = tokenUnsold.sub(_tokenAmount);
278     }
279 
280     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
281         _validateMaxSellAmount(_tokenAmount);
282         _deliverTokens(_beneficiary, _tokenAmount);
283     }
284 
285     function _getTokenAmount( uint256 _weiAmount) internal view returns (uint256) {
286         return _weiAmount.mul(10 ** uint256(decimals)).div(1 ether).mul(rate);
287     }
288 
289     function _getTokenBonus(uint256 _weiAmount) internal view returns (uint256) {
290         uint256 bonusRate = 0;
291         if(block.timestamp > openingTimePeriodOne && block.timestamp < closingTimePeriodOne){
292             bonusRate = bonusRatePeriodOne;
293         } else if(block.timestamp > openingTimePeriodTwo && block.timestamp < closingTimePeriodTwo){
294             bonusRate = bonusRatePeriodTwo;
295         }
296         return _weiAmount.mul(10 ** uint256(decimals)).div(1 ether).mul(bonusRate);
297     }
298 
299     function _forwardFunds() internal {
300         wallet.transfer(msg.value);
301     }
302 }
303 
304 // File: contracts/StandardToken.sol
305 
306 contract StandardToken is ERC20, Ownable {
307     using SafeMath for uint256;
308     mapping(address => uint256) balances;
309     mapping (address => mapping (address => uint256)) internal allowed;
310     uint256 totalSupply_;
311     bool public transferOpen = true;
312 
313     modifier onlyWhileTransferOpen {
314         require(transferOpen);
315         _;
316     }
317 
318     function setTransfer(bool _open) external onlyOwner{
319         transferOpen = _open;
320     }
321 
322     function totalSupply() public view returns (uint256) {
323         return totalSupply_;
324     }
325 
326     function transfer(address _to, uint256 _value) public onlyWhileTransferOpen returns (bool) {
327         require(_to != address(0));
328         require(_value <= balances[msg.sender]);
329 
330         balances[msg.sender] = balances[msg.sender].sub(_value);
331         balances[_to] = balances[_to].add(_value);
332         emit Transfer(msg.sender, _to, _value);
333         return true;
334     }
335 
336     function transferFrom(address _from, address _to, uint256 _value) public onlyWhileTransferOpen returns (bool) {
337         require(_to != address(0));
338         require(_value <= balances[_from]);
339         require(_value <= allowed[_from][msg.sender]);
340 
341         balances[_from] = balances[_from].sub(_value);
342         balances[_to] = balances[_to].add(_value);
343         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
344         emit Transfer(_from, _to, _value);
345         return true;
346     }
347 
348     function balanceOf(address _owner) public view returns (uint256) {
349         return balances[_owner];
350     }
351 
352     function approve(address _spender, uint256 _value) public returns (bool) {
353         allowed[msg.sender][_spender] = _value;
354         emit Approval(msg.sender, _spender, _value);
355         return true;
356     }
357 
358     function allowance(address _owner, address _spender) public view returns (uint256) {
359         return allowed[_owner][_spender];
360     }
361 
362     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
363         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
364         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
365         return true;
366     }
367 
368     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
369         uint oldValue = allowed[msg.sender][_spender];
370         if (_subtractedValue > oldValue) {
371             allowed[msg.sender][_spender] = 0;
372         } else {
373             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
374         }
375         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
376         return true;
377     }
378 }
379 
380 // File: contracts/Whitelist.sol
381 
382 contract Whitelist is Ownable {
383 
384     using SafeMath for uint256;
385     mapping(address => bool) public whitelist;
386     mapping(address => uint256) whitelistIndexMap;
387     address[] public whitelistArray;
388     uint256 public whitelistLength = 0;
389 
390     modifier isWhitelisted(address _beneficiary) {
391         require(whitelist[_beneficiary]);
392         _;
393     }
394 
395     function addToWhitelist(address _beneficiary) external onlyOwner {
396         whitelist[_beneficiary] = true;
397         if (whitelistIndexMap[_beneficiary] == 0){
398             if (whitelistArray.length <= whitelistLength){
399                 whitelistArray.push(_beneficiary);
400             } else {
401                 whitelistArray[whitelistLength] = _beneficiary;
402             }
403             whitelistLength = whitelistLength.add(1);
404             whitelistIndexMap[_beneficiary] = whitelistLength;
405         }
406     }
407 
408     function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
409         for (uint256 i = 0; i < _beneficiaries.length; i++) {
410             whitelist[_beneficiaries[i]] = true;
411         }
412     }
413 
414     function removeFromWhitelist(address _beneficiary) external onlyOwner {
415         whitelist[_beneficiary] = false;
416         if (whitelistIndexMap[_beneficiary] > 0){
417             uint index = whitelistIndexMap[_beneficiary]-1;
418             whitelistArray[index] = whitelistArray[whitelistLength-1];
419             whitelistArray[whitelistLength-1] = 0;
420             whitelistIndexMap[_beneficiary] = 0;
421             whitelistLength = whitelistLength.sub(1);
422         }
423     }
424 }
425 
426 // File: contracts/AFIToken.sol
427 
428 contract AFIToken is StandardToken, Crowdsale, Whitelist {
429     using SafeMath for uint256;
430     string public constant name = "AlchemyCoin";
431     string public constant symbol = "AFI";
432     uint8 public constant decimals = 8;
433     uint256 constant INITIAL_SUPPLY = 125000000 * (10 ** uint256(decimals));
434     uint256 constant ICO_SUPPLY = 50000000 * (10 ** uint256(decimals));
435     uint256 constant ICO_BONUS = 12500000 * (10 ** uint256(decimals));
436     uint256 public minRevenueToDeliver = 0;
437     address public assignRevenueContract;
438     uint256 public snapshotBlockHeight;
439     mapping(address => uint256) public snapshotBalance;
440     // Custom Setting values ---------------------------------
441     uint256 constant _openingTimePeriodOne = 1531713600;
442     uint256 constant _closingTimePeriodOne = 1534132800;
443     uint256 constant _openingTimePeriodTwo = 1535342400;
444     uint256 constant _closingTimePeriodTwo = 1536552000;
445     uint256 constant _bonusDeliverTime = 1552276800;
446     address _wallet = 0x2Dc02F830072eB33A12Da0852053eAF896185910;
447     address _afiWallet = 0x991E2130f5bF113E2282A5F58E626467D2221599;
448     // -------------------------------------------------------
449     uint256 constant _rate = 1000;
450     uint256 constant _bonusRatePrivateSale = 250;
451     uint256 constant _bonusRatePeriodOne = 150;
452     uint256 constant _bonusRatePeriodTwo = 50;
453     
454 
455     constructor() public 
456     Crowdsale(_openingTimePeriodOne, _closingTimePeriodOne, _openingTimePeriodTwo, _closingTimePeriodTwo, _bonusDeliverTime,
457         _rate, _bonusRatePrivateSale, _bonusRatePeriodOne, _bonusRatePeriodTwo, 
458         _wallet, this, decimals, ICO_SUPPLY, ICO_BONUS)
459     {
460         totalSupply_ = INITIAL_SUPPLY;
461         emit Transfer(0x0, _afiWallet, INITIAL_SUPPLY - ICO_SUPPLY - ICO_BONUS);
462         emit Transfer(0x0, this, ICO_SUPPLY);
463         balances[_afiWallet] = INITIAL_SUPPLY - ICO_SUPPLY - ICO_BONUS;
464         
465         // add admin
466         whitelist[_afiWallet] = true;
467         whitelistArray.push(_afiWallet);
468         whitelistLength = whitelistLength.add(1);
469         whitelistIndexMap[_afiWallet] = whitelistLength;
470         
471         // add contract
472         whitelist[this] = true;
473         whitelistArray.push(this);
474         whitelistLength = whitelistLength.add(1);
475         whitelistIndexMap[this] = whitelistLength;
476         balances[this] = ICO_SUPPLY + ICO_BONUS;
477     }
478 
479     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view isWhitelisted(_beneficiary){
480         super._preValidatePurchase(_beneficiary, _weiAmount);
481     }
482 
483     function transfer(address _to, uint256 _value) public isWhitelisted(_to) isWhitelisted(msg.sender) returns (bool) {
484         super.transfer(_to, _value);
485     }
486 
487     function transferFrom(address _from, address _to, uint256 _value) public isWhitelisted(_to) isWhitelisted(_from)  returns (bool){
488         super.transferFrom(_from, _to, _value);
489     }
490 
491     function setRevenueContract(address _contract) external onlyOwner{
492         assignRevenueContract = _contract;
493     }
494 
495     function createBalanceSnapshot() external onlyOwner {
496         snapshotBlockHeight = block.number;
497         for(uint256 i = 0; i < whitelistLength; i++) {
498             snapshotBalance[whitelistArray[i]] = balances[whitelistArray[i]];
499         }
500     }
501 
502     function setMinRevenue(uint256 _minRevenue) external onlyOwner {
503         minRevenueToDeliver = _minRevenue;
504     }
505 
506     function assignRevenue(uint256 _totalRevenue) external onlyOwner{
507         address contractAddress = assignRevenueContract;
508 
509         for (uint256 i = 0; i<whitelistLength; i++){
510             if(whitelistArray[i] == address(this)){
511                 continue;
512             }
513             uint256 amount = _totalRevenue.mul(snapshotBalance[whitelistArray[i]]).div(INITIAL_SUPPLY);
514             if(amount > minRevenueToDeliver){
515                 bool done = contractAddress.call(bytes4(keccak256("transferRevenue(address,uint256)")),whitelistArray[i],amount);
516                 require(done == true);
517             }
518         }
519     }
520 }