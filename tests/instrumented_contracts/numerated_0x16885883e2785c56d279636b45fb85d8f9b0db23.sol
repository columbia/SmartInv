1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function add(uint256 x, uint256 y) pure internal returns (uint256) {
9         uint256 z = x + y;
10         assert((z >= x) && (z >= y));
11         return z;
12     }
13 
14     function sub(uint256 x, uint256 y) pure internal returns (uint256) {
15         assert(x >= y);
16         uint256 z = x - y;
17         return z;
18     }
19 
20     function mul(uint256 x, uint256 y) pure internal returns (uint256) {
21         uint256 z = x * y;
22         assert((x == 0) || (z / x == y));
23         return z;
24     }
25 }
26 
27 
28 /**
29  * @title Ownable
30  * @dev The Ownable contract has an owner address, and provides basic authorization control
31  * functions, this simplifies the implementation of "user permissions".
32  */
33 contract Ownable {
34   address public owner;
35 
36 
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account.
40    */
41   function Ownable() public {
42     owner = msg.sender;
43   }
44 
45 
46   /**
47    * @dev Throws if called by any account other than the owner.
48    */
49   modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52   }
53 }
54 /*
55  * Haltable
56  *
57  * Abstract contract that allows children to implement an
58  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
59  *
60  *
61  * Originally envisioned in FirstBlood ICO contract.
62  */
63 contract Haltable is Ownable {
64   bool public halted;
65 
66   modifier stopInEmergency {
67     require (!halted);
68     _;
69   }
70 
71   modifier onlyInEmergency {
72     require (halted);
73     _;
74   }
75 
76   // called by the owner on emergency, triggers stopped state
77   function halt() external onlyOwner {
78     halted = true;
79   }
80 
81   // called by the owner on end of emergency, returns to normal state
82   function unhalt() external onlyOwner onlyInEmergency {
83     halted = false;
84   }
85 
86 }
87 
88 /**
89  * @title ERC20Basic
90  * @dev Simpler version of ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/179
92  */
93 contract ERC20Basic {
94   uint256 public totalSupply;
95   function balanceOf(address who) public constant returns (uint256);
96   function transfer(address to, uint256 value) public returns (bool);
97   event Transfer(address indexed from, address indexed to, uint256 value);
98 }
99 
100 
101 /**
102  * @title ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/20
104  */
105 contract ERC20 is ERC20Basic {
106   function allowance(address owner, address spender) public constant returns (uint256);
107   function transferFrom(address from, address to, uint256 value) public returns (bool);
108   function approve(address spender, uint256 value) public returns (bool);
109   event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 
113 
114 /**
115  * @title Basic token
116  * @dev Basic version of StandardToken, with no allowances. 
117  */
118 contract BasicToken is ERC20Basic {
119   using SafeMath for uint256;
120 
121   mapping(address => uint256) balances;
122 
123   /**
124   * @dev transfer token for a specified address
125   * @param _to The address to transfer to.
126   * @param _value The amount to be transferred.
127   */
128   function transfer(address _to, uint256 _value) public returns (bool) {
129     balances[msg.sender] = balances[msg.sender].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131     Transfer(msg.sender, _to, _value);
132     return true;
133   }
134 
135   /**
136   * @dev Gets the balance of the specified address.
137   * @param _owner The address to query the the balance of. 
138   * @return An uint256 representing the amount owned by the passed address.
139   */
140   function balanceOf(address _owner) public constant returns (uint256 balance) {
141     return balances[_owner];
142   }
143 
144 }
145 
146 /**
147  * @title Standard ERC20 token
148  *
149  * @dev Implementation of the basic standard token.
150  * @dev https://github.com/ethereum/EIPs/issues/20
151  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
152  */
153 contract StandardToken is ERC20, BasicToken {
154 
155   mapping (address => mapping (address => uint256)) allowed;
156 
157 
158   /**
159    * @dev Transfer tokens from one address to another
160    * @param _from address The address which you want to send tokens from
161    * @param _to address The address which you want to transfer to
162    * @param _value uint256 the amout of tokens to be transfered
163    */
164   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
165     var _allowance = allowed[_from][msg.sender];
166 
167     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
168     // require (_value <= _allowance);
169 
170     balances[_to] = balances[_to].add(_value);
171     balances[_from] = balances[_from].sub(_value);
172     allowed[_from][msg.sender] = _allowance.sub(_value);
173     Transfer(_from, _to, _value);
174     return true;
175   }
176 
177   /**
178    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
179    * @param _spender The address which will spend the funds.
180    * @param _value The amount of tokens to be spent.
181    */
182   function approve(address _spender, uint256 _value) public returns (bool) {
183 
184     // To change the approve amount you first have to reduce the addresses`
185     //  allowance to zero by calling `approve(_spender, 0)` if it is not
186     //  already 0 to mitigate the race condition described here:
187     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
188     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
189 
190     allowed[msg.sender][_spender] = _value;
191     Approval(msg.sender, _spender, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Function to check the amount of tokens that an owner allowed to a spender.
197    * @param _owner address The address which owns the funds.
198    * @param _spender address The address which will spend the funds.
199    * @return A uint256 specifing the amount of tokens still available for the spender.
200    */
201   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
202     return allowed[_owner][_spender];
203   }
204 
205 }
206 
207 
208 /**
209  * @title DogezerICOPublicCrowdSale public crowdsale contract
210  */
211 contract DogezerICOPublicCrowdSale is Haltable{
212     using SafeMath for uint;
213 
214     string public name = "Dogezer Public Sale ITO";
215 
216     address public beneficiary;
217 
218     uint public startTime = 1518699600;
219     uint public stopTime = 1520514000;
220 
221     uint public totalTokensAvailableForSale = 9800000000000000;
222     uint public preDGZTokensSold = 20699056632305;
223     uint public privateSalesTokensSold = 92644444444444;
224     uint public tokensAvailableForSale = 0;
225     uint public tokensSoldOnPublicRound = 0;
226 
227     StandardToken public tokenReward;
228     StandardToken public tokenRewardPreDGZ;
229         
230 
231     mapping(address => uint256) public balanceOf;
232     mapping(address => uint256) public nonWLBalanceOf;
233     mapping(address => uint256) public preBalanceOf;
234     mapping(address => bool) public whiteList;
235 
236     event DGZTokensWithdraw(address where, uint amount);
237     event DGZTokensSold(address where, uint amount);
238     event TokensWithdraw(address where, address token, uint amount);
239     event FundsWithdrawal(address where, uint amount);
240 
241     bool[] public yearlyTeamTokensPaid = [false, false, false];
242     uint public yearlyTeamAmount= 0;
243     bool public bountyPaid = false;
244     uint public bountyAmount = 0;
245 
246     bool public crowdsaleClosed = false;
247     uint public constant maxPurchaseNonWhiteListed = 10 * 1 ether;
248     uint public preDGZtoDGZExchangeRate = 914285714;
249 
250     uint public discountValue5 = 50.0 * 1 ether;
251     uint public discountValue10 = 100.0 * 1 ether;
252 
253     uint[] public price1stWeek = [ 5625000, 5343750, 5062500];
254     uint[] public price2ndWeek = [ 5940000, 5643000, 5346000];
255     uint[] public price3rdWeek = [ 6250000, 5937500, 5625000];
256 
257     
258     function DogezerICOPublicCrowdSale(
259         address addressOfPreDGZToken,
260         address addressOfDGZToken,
261         address addressOfBeneficiary
262     ) public
263     {
264         beneficiary = addressOfBeneficiary;
265         tokenRewardPreDGZ = StandardToken(addressOfPreDGZToken);
266         tokenReward = StandardToken(addressOfDGZToken);
267         tokensAvailableForSale = totalTokensAvailableForSale - preDGZTokensSold * preDGZtoDGZExchangeRate / 100000000 - privateSalesTokensSold;
268         tokensSoldOnPublicRound = 0;
269     }
270     
271     
272     modifier onlyAfterStart() {
273         require (now >= startTime);
274         _;
275     }
276 
277     modifier onlyBeforeEnd() {
278         require (now < stopTime);
279         _;
280     }
281 
282 
283     /**
284      * @notice Main Payable function.
285      * @dev In case if purchaser purchases on more than 10 ETH - only send tokens back if a person passed KYC (whitelisted) 
286      * in other case - funds are being frozen until whitelisting will be done. If price will change before 
287      * whitelisting is done for person, person will receive tokens basing on the new price, not old price.
288      */    
289     function () payable stopInEmergency onlyAfterStart onlyBeforeEnd public
290     {
291         require (crowdsaleClosed == false);
292         require (tokensAvailableForSale > tokensSoldOnPublicRound);
293         require (msg.value > 500000000000000);
294 
295         if ((balanceOf[msg.sender] + msg.value) > maxPurchaseNonWhiteListed && whiteList[msg.sender] == false) 
296         {
297             
298             // DGZ tokens are not being reserved for the purchasers who are not in a whitelist yet.
299             nonWLBalanceOf[msg.sender] += msg.value;
300         } 
301         else 
302         {
303             sendTokens(msg.sender, msg.value); 
304         }
305     }
306 
307 
308     /**     
309      * @notice Add multiple addresses to white list to allow purchase for more than 10 ETH. Owned.
310      * @dev Automatically send tokens to addresses being whitelisted if they have already send funds before
311      * the call of this function. It is recommended to check that addreses being added are VALID and not smartcontracts
312      * as problem somewhere in the middle of the loop may cause error which will make all gas to be lost.
313      * @param _addresses address[] Pass a bunch of etherium addresses as 
314      *        ["0xca35b7d915458ef540ade6068dfe2f44e8fa733c", "0x14723a09acff6d2a60dcdf7aa4aff308fddc160c"] to add to WhiteList
315      */        
316     function addListToWhiteList (address[] _addresses) public onlyOwner
317     {
318         for (uint i = 0; i < _addresses.length; i++)
319         {
320             if (nonWLBalanceOf[_addresses[i]] > 0)
321             {
322                 sendTokens(_addresses[i], nonWLBalanceOf[_addresses[i]]);
323                 nonWLBalanceOf[_addresses[i]] = 0;
324             }
325             whiteList[_addresses[i]] = true;
326         }
327     }
328     
329     
330     /**    
331      * @notice Add a single address to white list to allow purchase for more than 10 ETH. Owned.
332      * @param _address address An etherium addresses to add to WhiteList
333      */    
334     function addToWhiteList (address _address) public onlyOwner
335     {
336         if (nonWLBalanceOf[_address] > 0)
337         {
338             sendTokens(_address, nonWLBalanceOf[_address]);
339             nonWLBalanceOf[_address] = 0;
340         }
341         whiteList[_address] = true;
342     }    
343     
344     
345     /**
346      * @notice Finalize sales and sets bounty & yearly paid value. Owned.
347      */        
348     function finalizeSale () public onlyOwner
349     {
350         require (crowdsaleClosed == false);
351         crowdsaleClosed = true;
352         uint totalSold = tokensSoldOnPublicRound + preDGZTokensSold * preDGZtoDGZExchangeRate / 100000000 + privateSalesTokensSold;
353         bountyAmount = totalSold / 980 * 15;
354         yearlyTeamAmount= totalSold / 980 * 5 / 3;
355     }
356     
357 
358     /**
359      * @notice A function to burn unsold DGZ tokens. The ammount would be a parameter, not calculated value to ensure that all of the 
360      * last moment changes related to KYC processing, such as overdue of KYC documents or delay with confirming of KYC
361      * documents which caused purchaser to receive tokens using next period price, are handled. Owned.
362      * @param _amount uint Number of tokens to burn
363      */        
364     function tokenBurn (uint _amount) public onlyOwner
365     {
366         require (crowdsaleClosed == true);
367         tokenReward.transfer(address(0), _amount);
368     }
369 
370 
371     /**
372      * @notice A function to withdraw tokens for bounty campaign. Can be called only once. Owned.
373      */            
374     function bountyTokenWithdrawal () public onlyOwner
375     {
376         require (crowdsaleClosed == true);
377         require (bountyPaid == false);
378 
379         tokenReward.transfer(beneficiary, bountyAmount);
380         bountyPaid = true;
381     }
382 
383 
384     /**
385      * @notice A function to withdraw team tokens. Allow to withdraw one third of founders share in each yearly
386      * after the end of ICO. In total can be called at maximum 3 times. Owned.
387      */        
388     function yearlyOwnerTokenWithdrawal () public onlyOwner 
389     {
390         require (crowdsaleClosed == true);
391         require (
392             ((now > stopTime + 1 years) && (yearlyTeamTokensPaid[0] == false))
393             || ((now > stopTime + 2 years) && (yearlyTeamTokensPaid[1] == false))
394             || ((now > stopTime + 3 years) && (yearlyTeamTokensPaid[2] == false))
395         );
396 
397         tokenReward.transfer(beneficiary, yearlyTeamAmount);
398 
399         if (yearlyTeamTokensPaid[0] == false)
400             yearlyTeamTokensPaid[0] = true;
401         else if (yearlyTeamTokensPaid[1] == false)
402             yearlyTeamTokensPaid[1] = true;
403         else if (yearlyTeamTokensPaid[2] == false)
404             yearlyTeamTokensPaid[2] = true;
405     }
406 
407     
408     /**
409      * @notice A method to exchange preDGZ tokens to DGZ tokens. To use that method, a person first
410      * need to call approve method of preDGZ to define how many tokens to convert. Note that function
411      * doesn't end with the rest of crowdsale - it may be possible to exchange preDGZ after the end of crowdsale
412      * @dev Exchanged preDGZ tokens are automatically burned.
413      */        
414     function exchangePreDGZTokens() stopInEmergency onlyAfterStart public
415     {
416         uint tokenAmount = tokenRewardPreDGZ.allowance(msg.sender, this);
417         require(tokenAmount > 0);
418         require(tokenRewardPreDGZ.transferFrom(msg.sender, address(0), tokenAmount));
419         uint amountSendTokens = tokenAmount * preDGZtoDGZExchangeRate  / 100000000;
420         preBalanceOf[msg.sender] += tokenAmount;
421         tokenReward.transfer(msg.sender, amountSendTokens);
422     }
423     
424     
425     /**
426      * @notice This function is needed to handled unlikely case when person who owns preDGZ tokens
427      * makes a mistake and send them to smartcontract without setting the allowance in advance. In such case
428      * conversion of tokens by calling exchangePreDGZTokens is not possible. Ownable.
429      * @dev IMPORTANT! Should only be called is Dogezer team is in possesion of preDGZ tokens. 
430      * @dev Doesn't increment tokensSoldOnPublicRound as these tokens are already accounted as preDGZTokensSold
431      * @param _address address Etherium address where to send tokens as a result of conversion.
432      * @param preDGZAmount uint Number of preDGZ to convert.
433      */        
434     function manuallyExchangeContractPreDGZtoDGZ(address _address, uint preDGZAmount) public onlyOwner
435     {
436         require (_address != address(0));
437         require (preDGZAmount > 0);
438 
439         uint amountSendTokens = preDGZAmount * preDGZtoDGZExchangeRate  / 100000000;
440         preBalanceOf[_address] += preDGZAmount;
441         tokenReward.transfer(_address, amountSendTokens);
442     }
443 
444 
445     /**
446      * @notice Function to define prices for some particular week. Would be utilized if prices are changed. Owned.
447      * @dev It is important to apply this function for all of three weeks. The final week should be a week which is active now
448      * @param week uint Ordinal number of the week.
449      * @param price uint DGZ token price.
450      * @param price5 uint DGZ token price with 5% discount.
451      * @param price10 uint DGZ token price with 10% discount.
452      */        
453     function setTokenPrice (uint week, uint price, uint price5, uint price10) public onlyOwner
454     {
455         require (crowdsaleClosed == false);
456         require (week >= 1 && week <= 3);
457         if (week == 1)
458             price1stWeek = [price, price5, price10];
459         else if (week == 2)
460             price2ndWeek = [price, price5, price10];
461         else if (week == 3)
462             price3rdWeek = [price, price5, price10];
463     }
464 
465 
466     /**
467      * @notice In case if prices are changed due to some great change in ETH price,
468      * this function can be used to change conversion rate for preDGZ owners. Owned.
469      * @param rate uint Conversion rate.
470      */        
471     function setPreDGZtoDgzRate (uint rate) public onlyOwner
472     {
473         preDGZtoDGZExchangeRate = rate;
474         tokensAvailableForSale = totalTokensAvailableForSale - preDGZTokensSold * preDGZtoDGZExchangeRate / 100000000 - privateSalesTokensSold;
475     }
476 
477 
478     /**
479      * @notice Set number of tokens sold on private round. Required to correctly calcualte 
480      * total numbers of tokens sold at the end. Owned.
481      * @param tokens uint Number of tokens sold on private sale.
482      */            
483     function setPrivateSaleTokensSold (uint tokens) public onlyOwner
484     {
485         privateSalesTokensSold = tokens;
486         tokensAvailableForSale = totalTokensAvailableForSale - preDGZTokensSold * preDGZtoDGZExchangeRate / 100000000 - privateSalesTokensSold;
487     }
488 
489 
490     /**
491      * @notice Internal function which is responsible for sending tokens. Note that 
492      * discount is determined basing on accumulated sale, but only applied to the current
493      * request to send tokens.
494      * @param msg_sender address Address of PreDGZ holder who allowed it to exchange.
495      * @param msg_value uint Number of DGZ tokens to send.
496      */            
497     function sendTokens(address msg_sender, uint msg_value) internal
498     {
499         var prices = price1stWeek;
500 
501         if (now >= startTime + 2 weeks)
502             prices = price3rdWeek;
503         else if (now >= startTime + 1 weeks)
504             prices = price2ndWeek;
505 
506 
507         uint currentPrice = prices[0];
508 
509         if (balanceOf[msg_sender] + msg_value >= discountValue5)
510         {
511             currentPrice = prices[1];
512             if (balanceOf[msg_sender] + msg_value >= discountValue10)
513                 currentPrice = prices[2];
514         }
515 
516         uint amountSendTokens = msg_value / currentPrice;
517 
518         if (amountSendTokens > (tokensAvailableForSale - tokensSoldOnPublicRound))
519         {
520             uint tokensAvailable = tokensAvailableForSale - tokensSoldOnPublicRound;
521             uint refund = msg_value - (tokensAvailable * currentPrice);
522             amountSendTokens = tokensAvailable;
523             tokensSoldOnPublicRound += amountSendTokens;            
524             msg_sender.transfer(refund);
525             balanceOf[msg_sender] += (msg_value - refund);
526         }
527         else
528         {
529             tokensSoldOnPublicRound += amountSendTokens;            
530             balanceOf[msg_sender] += msg_value;
531         }
532 
533         tokenReward.transfer(msg_sender, amountSendTokens);
534         DGZTokensSold(msg_sender, amountSendTokens);
535     }
536 
537 
538     /**
539      * @notice Withdraw funds to beneficiary. Owned
540      * @param _amount uint Amount funds to withdraw.
541      */    
542     function fundWithdrawal (uint _amount) public onlyOwner
543     {
544         require (crowdsaleClosed == true);
545         beneficiary.transfer(_amount);
546         FundsWithdrawal(beneficiary, _amount);
547     }
548 
549 
550     /**
551      * @notice Function to process cases when person send more than 10 ETH to smartcontract
552      * but never provided KYC data and wants/needs to be refunded. Owned
553      * @param _address address Address of refunded person.
554      */        
555     function refundNonWhitelistedPerson (address _address) public onlyOwner
556     {
557         uint refundAmount = nonWLBalanceOf[_address];
558         nonWLBalanceOf[_address] = 0;
559         _address.transfer(refundAmount);
560     }
561 
562 
563     /**
564      * @notice Withdraws DGZ tokens to beneficiary. Would be used to process BTC payments. Owned.
565      * @dev increments tokensSoldOnPublicRound, so will cause higher burn rate if called.
566      * @param _amount uint Amount of DGZ tokens to withdraw.
567      */    
568     function tokenWithdrawal (uint _amount) public onlyOwner
569     {
570         require (crowdsaleClosed == false);
571         tokenReward.transfer(beneficiary, _amount);
572         tokensSoldOnPublicRound += _amount;
573         DGZTokensWithdraw(beneficiary, _amount);
574     }
575 
576 
577     /**
578      * @notice Withdraws tokens other than DGZ to beneficiary. Owned
579      * @dev Generally need this to handle cases when user just transfers preDGZ 
580      * to the contract by mistake and we need to manually burn then after calling
581      * manuallyExchangeContractPreDGZtoDGZ
582      * @param _address address Address of tokens to withdraw.
583      * @param _amount uint Amount of tokens to withdraw.
584      */        
585     function anyTokenWithdrawal (address _address, uint _amount) public onlyOwner
586     {
587         require(_address != address(tokenReward));
588 
589         StandardToken token = StandardToken(_address);
590         token.transfer(beneficiary, _amount);
591         TokensWithdraw(beneficiary, _address, _amount);
592     }
593 
594 
595     /**
596      * @notice Changes beneficiary address. Owned.
597      * @param _newBeneficiary address Address of new beneficiary.
598      */        
599     function changeBeneficiary(address _newBeneficiary) public onlyOwner
600     {
601         if (_newBeneficiary != address(0)) {
602             beneficiary = _newBeneficiary;
603         }
604     }
605 
606 
607     /**
608      * @notice Reopens closed sale to recalcualte total tokens sold if there are any late deals - such as
609      * delayed whitelist processing. Owned.
610      */    
611     function reopenSale () public onlyOwner
612     {
613         require (crowdsaleClosed == true);
614         crowdsaleClosed = false;
615     }
616 }