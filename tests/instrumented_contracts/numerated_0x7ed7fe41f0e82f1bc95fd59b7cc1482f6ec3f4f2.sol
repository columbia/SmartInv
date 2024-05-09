1 /**
2  * @title GradusInvestmentPlatform
3 */
4 
5 
6 pragma solidity ^0.4.24;
7 
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12 */
13 library SafeMath {
14 
15     /**
16      * @dev Multiplies two numbers, throws on overflow.
17     */
18     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
19         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
20         // benefit is lost if 'b' is also tested.
21         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
22         if (a == 0) {
23             return 0;
24         }
25 
26         c = a * b;
27         assert(c / a == b);
28         return c;
29     }
30 
31     /**
32      * @dev Integer division of two numbers, truncating the quotient.
33     */
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         // assert(b > 0); // Solidity automatically throws when dividing by 0
36         // uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38         return a / b;
39     }
40 
41     /**
42      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
43     */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         assert(b <= a);
46         return a - b;
47     }
48 
49     /**
50      * @dev Adds two numbers, throws on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
53         c = a + b;
54         assert(c >= a);
55         return c;
56     }
57 }
58 
59 contract ERC20Basic {
60     function totalSupply() public view returns (uint256);
61     function balanceOf(address who) public view returns (uint256);
62     function transfer(address to, uint256 value) public returns (bool);
63     event Transfer(address indexed from, address indexed to, uint256 value);
64 }
65 
66 contract ERC20 is ERC20Basic {
67     function allowance(address owner, address spender)
68         public view returns (uint256);
69 
70     function transferFrom(address from, address to, uint256 value)
71         public returns (bool);
72 
73     function approve(address spender, uint256 value) public returns (bool);
74     event Approval(
75         address indexed owner,
76         address indexed spender,
77         uint256 value
78     );
79 }
80 
81 contract BasicToken is ERC20Basic {
82     using SafeMath for uint256;
83 
84     mapping(address => uint256) balances;
85 
86     uint256 totalSupply_;
87 
88     /**
89      * @dev Total number of tokens in existence
90     */
91     function totalSupply() public view returns (uint256) {
92         return totalSupply_;
93     }
94 
95     /**
96      * @dev Transfer token for a specified address
97      * @param _to The address to transfer to.
98      * @param _value The amount to be transferred.
99     */
100     function transfer(address _to, uint256 _value) public returns (bool) {
101         require(_to != address(0));
102         require(_value <= balances[msg.sender]);
103 
104         balances[msg.sender] = balances[msg.sender].sub(_value);
105         balances[_to] = balances[_to].add(_value);
106         emit Transfer(msg.sender, _to, _value);
107         return true;
108     }
109 
110     /**
111     * @dev Gets the balance of the specified address.
112     * @param _owner The address to query the the balance of.
113     * @return An uint256 representing the amount owned by the passed address.
114     */
115     function balanceOf(address _owner) public view returns (uint256) {
116         return balances[_owner];
117     }
118 
119 }
120 
121 
122 contract StandardToken is ERC20, BasicToken {
123 
124     mapping (address => mapping (address => uint256)) internal allowed;
125 
126 
127     /**
128     * @dev Transfer tokens from one address to another
129     * @param _from address The address which you want to send tokens from
130     * @param _to address The address which you want to transfer to
131     * @param _value uint256 the amount of tokens to be transferred
132     */
133     function transferFrom(
134         address _from,
135         address _to,
136         uint256 _value
137     )
138     public
139     returns (bool)
140     {
141         require(_to != address(0));
142         require(_value <= balances[_from]);
143         require(_value <= allowed[_from][msg.sender]);
144 
145         balances[_from] = balances[_from].sub(_value);
146         balances[_to] = balances[_to].add(_value);
147         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
148         emit Transfer(_from, _to, _value);
149         return true;
150     }
151 
152   /**
153    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
154    * Beware that changing an allowance with this method brings the risk that someone may use both the old
155    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
156    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
157    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158    * @param _spender The address which will spend the funds.
159    * @param _value The amount of tokens to be spent.
160    */
161     function approve(address _spender, uint256 _value) public returns (bool) {
162         allowed[msg.sender][_spender] = _value;
163         emit Approval(msg.sender, _spender, _value);
164         return true;
165     }
166 
167   /**
168    * @dev Function to check the amount of tokens that an owner allowed to a spender.
169    * @param _owner address The address which owns the funds.
170    * @param _spender address The address which will spend the funds.
171    * @return A uint256 specifying the amount of tokens still available for the spender.
172    */
173     function allowance(
174         address _owner,
175         address _spender
176     )
177         public
178         view
179         returns (uint256)
180     {
181         return allowed[_owner][_spender];
182     }
183 
184   /**
185    * @dev Increase the amount of tokens that an owner allowed to a spender.
186    * approve should be called when allowed[_spender] == 0. To increment
187    * allowed value is better to use this function to avoid 2 calls (and wait until
188    * the first transaction is mined)
189    * From MonolithDAO Token.sol
190    * @param _spender The address which will spend the funds.
191    * @param _addedValue The amount of tokens to increase the allowance by.
192    */
193     function increaseApproval(
194         address _spender,
195         uint256 _addedValue
196     )
197       public
198       returns (bool)
199     {
200         allowed[msg.sender][_spender] = (
201             allowed[msg.sender][_spender].add(_addedValue));
202         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
203         return true;
204     }
205 
206   /**
207    * @dev Decrease the amount of tokens that an owner allowed to a spender.
208    * approve should be called when allowed[_spender] == 0. To decrement
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _subtractedValue The amount of tokens to decrease the allowance by.
214    */
215     function decreaseApproval(
216         address _spender,
217         uint256 _subtractedValue
218     )
219         public
220         returns (bool)
221     {
222         uint256 oldValue = allowed[msg.sender][_spender];
223         if (_subtractedValue > oldValue) {
224             allowed[msg.sender][_spender] = 0;
225         } else {
226             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
227         }
228         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229         return true;
230     }
231 
232 }
233 
234 contract GRADtoken is StandardToken {
235     string public constant name = "Gradus";
236     string public constant symbol = "GRAD";
237     uint32 public constant decimals = 18;
238     uint256 public totalSupply;
239     uint256 public tokenBuyRate = 10000;
240     
241     mapping(address => bool   ) isInvestor;
242     address[] public arrInvestors;
243     
244     address public CrowdsaleAddress;
245     bool public lockTransfers = false;
246 
247     event Mint (address indexed to, uint256  amount);
248     event Burn(address indexed burner, uint256 value);
249     
250     constructor(address _CrowdsaleAddress) public {
251         CrowdsaleAddress = _CrowdsaleAddress;
252     }
253   
254     modifier onlyOwner() {
255         /**
256          * only Crowdsale contract can run it
257          */
258         require(msg.sender == CrowdsaleAddress);
259         _;
260     }   
261 
262     function setTokenBuyRate(uint256 _newValue) public onlyOwner {
263         tokenBuyRate = _newValue;
264     }
265 
266     function addInvestor(address _newInvestor) internal {
267         if (!isInvestor[_newInvestor]){
268             isInvestor[_newInvestor] = true;
269             arrInvestors.push(_newInvestor);
270         }  
271     }
272 
273     function getInvestorAddress(uint256 _num) public view returns(address) {
274         return arrInvestors[_num];
275     }
276 
277     function getInvestorsCount() public view returns(uint256) {
278         return arrInvestors.length;
279     }
280 
281      // Override
282     function transfer(address _to, uint256 _value) public returns(bool){
283         if (msg.sender != CrowdsaleAddress){
284             require(!lockTransfers, "Transfers are prohibited");
285         }
286         addInvestor(_to);
287         return super.transfer(_to,_value);
288     }
289 
290      // Override
291     function transferFrom(address _from, address _to, uint256 _value) public returns(bool){
292         if (msg.sender != CrowdsaleAddress){
293             require(!lockTransfers, "Transfers are prohibited");
294         }
295         addInvestor(_to);
296         return super.transferFrom(_from,_to,_value);
297     }
298      
299     function mint(address _to, uint256 _value) public onlyOwner returns (bool){
300         balances[_to] = balances[_to].add(_value);
301         totalSupply = totalSupply.add(_value);
302         addInvestor(_to);
303         emit Mint(_to, _value);
304         emit Transfer(address(0), _to, _value);
305         return true;
306     }
307     
308     function _burn(address _who, uint256 _value) internal {
309         require(_value <= balances[_who]);
310         balances[_who] = balances[_who].sub(_value);
311         totalSupply = totalSupply.sub(_value);
312         emit Burn(_who, _value);
313         emit Transfer(_who, address(0), _value);
314     }
315     
316     function lockTransfer(bool _lock) public onlyOwner {
317         lockTransfers = _lock;
318     }
319 
320     /**
321      * function buys tokens from investors and burn it
322      */
323     function ReturnToken(uint256 _amount) public payable {
324         require (_amount > 0);
325         require (msg.sender != address(0));
326         
327         uint256 weiAmount = _amount.div(tokenBuyRate);
328         require (weiAmount > 0, "Amount is less than the minimum value");
329         require (address(this).balance >= weiAmount, "Contract balance is empty");
330         _burn(msg.sender, _amount);
331         msg.sender.transfer(weiAmount);
332     }
333 
334     function() external payable {
335         // The token contract can receive ether for buy-back tokens
336     }  
337 
338 }
339 
340 contract Ownable {
341     address public owner;
342     address candidate;
343 
344     constructor() public {
345         owner = msg.sender;
346     }
347 
348     modifier onlyOwner() {
349         require(msg.sender == owner);
350         _;
351     }
352 
353 
354     function transferOwnership(address newOwner) public onlyOwner {
355         require(newOwner != address(0));
356         candidate = newOwner;
357     }
358 
359     function confirmOwnership() public {
360         require(candidate == msg.sender);
361         owner = candidate;
362         delete candidate;
363     }
364 
365 }
366 
367 contract Dividend {
368     /**
369      * @title Contract receive ether, calculate profit and distributed it to investors
370      */
371     using SafeMath for uint256;
372 
373     uint256 public receivedDividends;
374     address public crowdsaleAddress;
375     GRADtoken public token;
376     CrowdSale public crowdSaleContract;
377     mapping (address => uint256) public divmap;
378     event PayDividends(address indexed investor, uint256 amount);
379 
380     constructor(address _crowdsaleAddress, address _tokenAddress) public {
381         crowdsaleAddress = _crowdsaleAddress;
382         token = GRADtoken(_tokenAddress);
383         crowdSaleContract = CrowdSale(crowdsaleAddress);
384     }
385 
386     modifier onlyOwner() {
387         /**
388          * only Crowdsale contract can run it
389          */
390         require(msg.sender == crowdsaleAddress);
391         _;
392     }  
393 
394     /** 
395      * @dev function calculate dividends and store result in mapping divmap
396      * @dev stop all transfer before calculations
397      * k - coefficient
398      */    
399     function _CalcDiv() internal {
400         uint256 myAround = 1 ether;
401         uint256 i;
402         uint256 k;
403         address invAddress;
404         receivedDividends = receivedDividends.add(msg.value);
405 
406         if (receivedDividends >= crowdSaleContract.hardCapDividends()){
407             uint256 lengthArrInvesotrs = token.getInvestorsCount();
408             crowdSaleContract.lockTransfer(true); 
409             k = receivedDividends.mul(myAround).div(token.totalSupply());
410             uint256 myProfit;
411             
412             for (i = 0;  i < lengthArrInvesotrs; i++) {
413                 invAddress = token.getInvestorAddress(i);
414                 myProfit = token.balanceOf(invAddress).mul(k).div(myAround);
415                 divmap[invAddress] = divmap[invAddress].add(myProfit);
416             }
417             crowdSaleContract.lockTransfer(false); 
418             receivedDividends = 0;
419         }
420     }
421     
422     /**
423      * function pay dividends to investors
424      */
425     function Pay() public {
426         uint256 dividends = divmap[msg.sender];
427         require (dividends > 0);
428         require (dividends <= address(this).balance);
429         divmap[msg.sender] = 0;
430         msg.sender.transfer(dividends);
431         emit PayDividends(msg.sender, dividends);
432     } 
433     
434     function killContract(address _profitOwner) public onlyOwner {
435         selfdestruct(_profitOwner);
436     }
437 
438     /**
439      * fallback function can be used to receive funds and calculate dividends
440      */
441     function () external payable {
442         _CalcDiv();
443     }  
444 
445 }
446 
447 
448     /**
449      * @title CrowdSale contract for Gradus token
450      * https://github.com/chelbukhov/Gradus-smart-contract.git
451      */
452 contract CrowdSale is Ownable{
453     using SafeMath for uint256;
454 
455     // The token being sold
456     address myAddress = this;
457     
458     GRADtoken public token = new GRADtoken(myAddress);
459     Dividend public dividendContract = new Dividend(myAddress, address(token));
460     
461     // address where funds are collected
462     address public wallet = 0x0;
463 
464     //tokenSaleRate don't change
465     uint256 public tokenSaleRate; 
466 
467     // limit for activate function calcucate dividends
468     uint256 public hardCapDividends;
469     
470     /**
471      * Current funds during this period of sale
472      * and the upper limit for this period of sales
473      */
474     uint256 public currentFunds = 0;
475     uint256 public hardCapCrowdSale = 0;
476     bool private isSaleActive;
477 
478     /**
479     * event for token purchase logging
480     * @param _to who got the tokens
481     * @param value weis paid for purchase
482     * @param amount amount of tokens purchased
483     */
484     event TokenSale(address indexed _to, uint256 value, uint256 amount);
485 
486     constructor() public {
487         /**
488          * @dev tokenRate is rate tokens per 1 ether. don't change.
489          */
490         tokenSaleRate = 10000;
491 
492         /**
493          * @dev limits in ether for contracts CrowdSale and Dividends
494          */
495         hardCapCrowdSale = 10 * (1 ether);
496         hardCapDividends = 10 * (1 ether);
497 
498         /**
499          * @dev At start stage profit wallet is owner wallet. Must be changed after owner contract change
500          */
501         wallet = msg.sender;
502     }
503 
504 
505     modifier restricted(){
506         require(msg.sender == owner || msg.sender == address(dividendContract));
507         _;
508     }
509 
510     function setNewDividendContract(address _newContract) public onlyOwner {
511         dividendContract = Dividend(_newContract);
512     }
513 
514 
515     /**
516      * function set upper limit to receive funds
517      * value entered in whole ether. 10 = 10 ether
518     */
519     function setHardCapCrowdSale(uint256 _newValue) public onlyOwner {
520         hardCapCrowdSale = _newValue.mul(1 ether);
521         currentFunds = 0;
522     }
523 
524 
525     /**
526      * Enter Amount in whole ether. 1 = 1 ether
527      */
528     function setHardCapDividends(uint256 _newValue) public onlyOwner {
529         hardCapDividends = _newValue.mul(1 ether);
530     }
531     
532     function setTokenBuyRate(uint256 _newValue) public onlyOwner {
533         token.setTokenBuyRate(_newValue);
534     }
535 
536     function setProfitAddress(address _newWallet) public onlyOwner {
537         require(_newWallet != address(0),"Invalid address");
538         wallet = _newWallet;
539     }
540 
541     /**
542      * function sale token to investor
543     */
544     function _saleTokens() internal {
545         require(msg.value >= 10**16, "Minimum value is 0.01 ether");
546         require(hardCapCrowdSale >= currentFunds.add(msg.value), "Upper limit on fund raising exceeded");      
547         require(msg.sender != address(0), "Address sender is empty");
548         require(wallet != address(0),"Enter address profit wallet");
549         require(isSaleActive, "Set saleStatus in true");
550 
551         uint256 weiAmount = msg.value;
552 
553         // calculate token amount to be created
554         uint256 tokens = weiAmount.mul(tokenSaleRate);
555 
556         token.mint(msg.sender, tokens);
557         emit TokenSale(msg.sender, weiAmount, tokens);
558         currentFunds = currentFunds.add(msg.value);
559         wallet.transfer(msg.value);
560     }
561 
562   
563     function lockTransfer(bool _lock) public restricted {
564         /**
565          * @dev This function may be started from owner or dividendContract
566          */
567         token.lockTransfer(_lock);
568     }
569 
570   //disable if enabled
571     function disableSale() onlyOwner() public returns (bool) {
572         require(isSaleActive == true);
573         isSaleActive = false;
574         return true;
575     }
576 
577   // enable if diabled
578     function enableSale()  onlyOwner() public returns (bool) {
579         require(isSaleActive == false);
580         isSaleActive = true;
581         return true;
582     }
583 
584   // retruns true if sale is currently active
585     function saleStatus() public view returns (bool){
586         return isSaleActive;
587     }
588 
589     /**
590      * @dev  function kill Dividend contract and withdraw all funds to wallet
591      */
592     function killDividentContract(uint256 _kod) public onlyOwner {
593         require(_kod == 666);
594         dividendContract.killContract(wallet);
595     }
596 
597   // fallback function can be used to sale tokens
598     function () external payable {
599         _saleTokens();
600     }
601 
602 }