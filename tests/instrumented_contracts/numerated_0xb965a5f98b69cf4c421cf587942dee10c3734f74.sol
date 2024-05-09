1 /**
2  * Developer Team: 
3  * Hira Siddiqui
4  * connect on: https://www.linkedin.com/in/hira-siddiqui-96b60a74/
5  * 
6  * Mujtaba Idrees
7  * connect on: https://www.linkedin.com/in/mujtabaidrees94/
8  **/
9 
10 pragma solidity ^0.4.11;
11 
12 /**
13  * @title Crowdsale
14  * @dev Crowdsale is a base contract for managing a token crowdsale.
15  * Crowdsales have a start and end timestamps, where investors can make
16  * token purchases and the crowdsale will assign them tokens based
17  * on a token per ETH rate. Funds collected are forwarded to a wallet
18  * as they arrive.
19  */
20  
21  
22 library SafeMath {
23   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a * b;
25     assert(a == 0 || c / a == b);
26     return c;
27   }
28 
29  function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 contract Ownable {
49   address public owner;
50 
51 
52   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54 
55   /**
56    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
57    * account.
58    */
59   function Ownable() public {
60     owner = msg.sender;
61   }
62 
63 
64   /**
65    * @dev Throws if called by any account other than the owner.
66    */
67   modifier onlyOwner() {
68     require(msg.sender == owner);
69     _;
70   }
71 
72 
73   /**
74    * @dev Allows the current owner to transfer control of the contract to a newOwner.
75    * @param newOwner The address to transfer ownership to.
76    */
77   function transferOwnership(address newOwner) onlyOwner public {
78     require(newOwner != address(0));
79     OwnershipTransferred(owner, newOwner);
80     owner = newOwner;
81   }
82 
83 }
84 
85 /**
86  * @title ERC20Basic
87  * @dev Simpler version of ERC20 interface
88  * @dev see https://github.com/ethereum/EIPs/issues/179
89  */
90 contract ERC20Basic {
91   uint256 public totalSupply;
92   function balanceOf(address who) constant internal returns (uint256);
93   function transfer(address to, uint256 value) internal returns (bool);
94   event Transfer(address indexed from, address indexed to, uint256 value);
95 }
96 
97 /**
98  * @title Basic token
99  * @dev Basic version of StandardToken, with no allowances.
100  */
101 contract BasicToken is ERC20Basic {
102   using SafeMath for uint256;
103 
104   mapping(address => uint256) tokenBalances;
105 
106   /**
107   * @dev transfer token for a specified address
108   * @param _to The address to transfer to.
109   * @param _value The amount to be transferred.
110   */
111   function transfer(address _to, uint256 _value) internal returns (bool) {
112     require(tokenBalances[msg.sender]>=_value);
113     tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(_value);
114     tokenBalances[_to] = tokenBalances[_to].add(_value);
115     Transfer(msg.sender, _to, _value);
116     return true;
117   }
118 
119   /**
120   * @dev Gets the balance of the specified address.
121   * @param _owner The address to query the the balance of.
122   * @return An uint256 representing the amount owned by the passed address.
123   */
124   function balanceOf(address _owner) constant internal returns (uint256 balance) {
125     return tokenBalances[_owner];
126   }
127 
128 }
129 contract EtheeraToken is BasicToken,Ownable {
130 
131    using SafeMath for uint256;
132    
133    //TODO: Change the name and the symbol
134    string public constant name = "ETHEERA";
135    string public constant symbol = "ETA";
136    uint256 public constant decimals = 18;
137 
138    uint256 public constant INITIAL_SUPPLY = 300000000;
139    event Debug(string message, address addr, uint256 number);
140    /**
141    * @dev Contructor that gives msg.sender all of existing tokens.
142    */
143     function EtheeraToken(address wallet) public {
144         owner = msg.sender;
145         totalSupply = INITIAL_SUPPLY;
146         tokenBalances[wallet] = INITIAL_SUPPLY * 10 ** 18;   //Since we divided the token into 10^18 parts
147     }
148 
149     function mint(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {
150       require(tokenBalances[wallet] >= tokenAmount);               // checks if it has enough to sell
151       tokenBalances[buyer] = tokenBalances[buyer].add(tokenAmount);                  // adds the amount to buyer's balance
152       tokenBalances[wallet] = tokenBalances[wallet].sub(tokenAmount);                        // subtracts amount from seller's balance
153       Transfer(wallet, buyer, tokenAmount); 
154     }
155     
156     function showMyTokenBalance(address addr) public view onlyOwner returns (uint tokenBalance) {
157         tokenBalance = tokenBalances[addr];
158         return tokenBalance;
159     }
160     
161     function showMyEtherBalance(address addr) public view onlyOwner returns (uint etherBalance) {
162         etherBalance = addr.balance;
163     }
164 }
165 contract Crowdsale {
166   using SafeMath for uint256;
167  
168   // The token being sold
169   EtheeraToken public token;
170 
171   // start and end timestamps where investments are allowed (both inclusive)
172   uint256 public startTime;
173   uint256 public endTime;
174 
175   // address where funds are collected
176   // address where tokens are deposited and from where we send tokens to buyers
177   address public wallet;
178 
179   // how many token units a buyer gets per wei
180   uint256 public ratePerWei = 2000;
181 
182   // amount of raised money in wei
183   uint256 public weiRaised;
184 
185   // flags to show whether soft cap / hard cap is reached
186   bool public isSoftCapReached = false;
187   bool public isHardCapReached = false;
188     
189   //this flag is set to true when ICO duration is over and soft cap is not reached  
190   bool public refundToBuyers = false;
191     
192   // Soft cap of the ICO in ethers  
193   uint256 public softCap = 6000;
194     
195   //Hard cap of the ICO in ethers
196   uint256 public hardCap = 100000;
197   
198   //total tokens that have been sold  
199   uint256 tokens_sold = 0;
200 
201   //total tokens that are to be sold - this is 70% of the total supply i.e. 300000000
202   uint maxTokensForSale = 210000000;
203   
204   //tokens that are reserved for the etheera team - this is 30% of the total supply  
205   uint256 tokensForReservedFund = 0;
206   uint256 tokensForAdvisors = 0;
207   uint256 tokensForFoundersAndTeam = 0;
208   uint256 tokensForMarketing = 0;
209   uint256 tokensForTournament = 0;
210 
211   bool ethersSentForRefund = false;
212   uint256 public amountForRefundIfSoftCapNotReached = 0;
213   // whitelisted addresses are those that have registered on the website
214   mapping(address=>bool) whiteListedAddresses;
215 
216   // the buyers of tokens and the amount of ethers they sent in
217   mapping(address=>uint) usersThatBoughtETA;
218  
219   /**
220    * event for token purchase logging
221    * @param purchaser who paid for the tokens
222    * @param beneficiary who got the tokens
223    * @param value weis paid for purchase
224    * @param amount amount of tokens purchased
225    */
226   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
227 
228 
229   function Crowdsale(uint256 _startTime, address _wallet) public {
230     
231     require(_startTime >= now);
232     startTime = _startTime;
233     endTime = startTime + 60 days;
234     
235     require(endTime >= startTime);
236     require(_wallet != 0x0);
237 
238     wallet = _wallet;
239     token = createTokenContract(wallet);
240   }
241 
242   function createTokenContract(address wall) internal returns (EtheeraToken) {
243     return new EtheeraToken(wall);
244   }
245 
246   // fallback function can be used to buy tokens
247   function () public payable {
248     buyTokens(msg.sender);
249   }
250 
251   //determine the bonus with respect to time elapsed
252   function determineBonus(uint tokens) internal view returns (uint256 bonus) {
253     
254     uint256 timeElapsed = now - startTime;
255     uint256 timeElapsedInWeeks = timeElapsed.div(7 days);
256     
257     if (timeElapsedInWeeks <=1)
258     {
259         //early sale
260         //valid for 7 days (1st week)
261         //30000+ TOKEN PURCHASE AMOUNT / 33% BONUS
262         if (tokens>30000 * 10 ** 18)
263         {
264             //33% bonus
265             bonus = tokens.mul(33);
266             bonus = bonus.div(100);
267         }
268         //10000+ TOKEN PURCHASE AMOUNT / 26% BONUS
269         else if (tokens>10000 *10 ** 18 && tokens<= 30000 * 10 ** 18)
270         {
271             //26% bonus
272             bonus = tokens.mul(26);
273             bonus = bonus.div(100);
274         }
275         //3000+ TOKEN PURCHASE AMOUNT / 23% BONUS
276         else if (tokens>3000 *10 ** 18 && tokens<= 10000 * 10 ** 18)
277         {
278             //23% bonus
279             bonus = tokens.mul(23);
280             bonus = bonus.div(100);
281         }
282         
283         //75+ TOKEN PURCHASE AMOUNT / 20% BONUS
284         else if (tokens>=75 *10 ** 18 && tokens<= 3000 * 10 ** 18)
285         {
286             //20% bonus
287             bonus = tokens.mul(20);
288             bonus = bonus.div(100);
289         }
290     }
291     else if (timeElapsedInWeeks>1 && timeElapsedInWeeks <=6)
292     {
293         //sale
294         //from 7th day till 49th day (total 42 days or 6 weeks)
295         //30000+ TOKEN PURCHASE AMOUNT / 15% BONUS
296         if (tokens>30000 * 10 ** 18)
297         {
298             //15% bonus
299             bonus = tokens.mul(15);
300             bonus = bonus.div(100);
301         }
302         //10000+ TOKEN PURCHASE AMOUNT / 10% BONUS
303         else if (tokens>10000 *10 ** 18 && tokens<= 30000 * 10 ** 18)
304         {
305             //10% bonus
306             bonus = tokens.mul(10);
307             bonus = bonus.div(100);
308         }
309         //3000+ TOKEN PURCHASE AMOUNT / 5% BONUS
310         else if (tokens>3000 *10 ** 18 && tokens<= 10000 * 10 ** 18)
311         {
312             //5% bonus
313             bonus = tokens.mul(5);
314             bonus = bonus.div(100);
315         }
316         
317         //75+ TOKEN PURCHASE AMOUNT / 3% BONUS
318         else if (tokens>=75 *10 ** 18 && tokens<= 3000 * 10 ** 18)
319         {
320             //3% bonus
321             bonus = tokens.mul(3);
322             bonus = bonus.div(100);
323         }
324     }
325     else if (timeElapsedInWeeks>6)
326     {
327         //no bonuses after 7th week i.e. 49 days
328         bonus = 0;
329     }
330   }
331 
332   // low level token purchase function
333   // Minimum purchase can be of 1 ETH
334   
335   function buyTokens(address beneficiary) public payable {
336     
337   //tokens not to be sent to 0x0
338   require(beneficiary != 0x0);
339   
340   bool hasICOended = hasEnded();
341   
342   if(hasICOended && weiRaised < softCap * 10 ** 18)
343       refundToBuyers = true;
344         
345   if(hasICOended && weiRaised < hardCap * 10 ** 18)
346   {
347       burnRemainingTokens();
348       beneficiary.transfer(msg.value);
349   }
350   else
351   {
352   
353     //the purchase should be within duration and non zero
354     require(validPurchase());
355   
356     //the ICO is over if hard cap has been reached even if time is still left
357     require(isHardCapReached == false);
358     
359     // amount sent by the user
360     uint256 weiAmount = msg.value;
361     
362     // calculate token amount to be sold
363     uint256 tokens = weiAmount.mul(ratePerWei);
364   
365     //Determine bonus
366     uint bonus = determineBonus(tokens);
367     tokens = tokens.add(bonus);
368 
369     require (tokens>=75 * 10 ** 18);
370   
371     //can't sale tokens more than 21000000000
372     require(tokens_sold + tokens <= maxTokensForSale * 10 ** 18);
373   
374     //30% of the tokens being sold are being accumulated for the etheera team
375     updateTokensForEtheeraTeam(tokens);
376   
377     // update state
378     require(weiRaised.add(weiAmount) <= hardCap * 10 ** 18);
379 
380     weiRaised = weiRaised.add(weiAmount);
381     amountForRefundIfSoftCapNotReached = amountForRefundIfSoftCapNotReached.add(weiAmount);
382     
383     if (weiRaised >= softCap * 10 ** 18)
384     {
385       isSoftCapReached = true;
386       amountForRefundIfSoftCapNotReached = 0;
387     }
388   
389     if (weiRaised == hardCap * 10 ** 18)
390       isHardCapReached = true;
391     
392     token.mint(wallet, beneficiary, tokens); 
393     usersThatBoughtETA[beneficiary] = weiAmount;
394     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
395     
396     tokens_sold = tokens_sold.add(tokens);
397     
398     forwardFunds();
399   }
400  }
401 
402   // send ether to the fund collection wallet
403   // override to create custom fund forwarding mechanisms
404   function forwardFunds() internal {
405     wallet.transfer(msg.value);
406   }
407 
408   // @return true if the transaction can buy tokens
409   function validPurchase() internal returns (bool) {
410     bool withinPeriod = now >= startTime && now <= endTime;
411     bool nonZeroPurchase = msg.value != 0;
412     return withinPeriod && nonZeroPurchase;
413   }
414 
415   // @return true if crowdsale event has ended
416   function hasEnded() public constant returns (bool) {
417     return now > endTime;
418   }
419   
420    function showMyTokenBalance() public constant returns (uint256 tokenBalance) {
421         tokenBalance = token.showMyTokenBalance(msg.sender);
422     }
423     
424     function showMyEtherBalance() public constant returns (uint256 etherBalance) {
425         etherBalance = token.showMyEtherBalance(msg.sender);
426     }
427     
428     function burnRemainingTokens() internal
429     {
430         //burn all the unsold tokens as soon as the ICO is ended
431         uint balance = token.showMyTokenBalance(wallet);
432         uint tokensIssued = tokensForReservedFund + tokensForFoundersAndTeam + tokensForAdvisors +tokensForMarketing + tokensForTournament;
433         uint tokensToBurn = balance.sub(tokensIssued);
434         require (balance >=tokensToBurn);
435         address burnAddress = 0x0;
436         token.mint(wallet,burnAddress,tokensToBurn);
437     }
438     
439     function addAddressToWhiteList(address whitelistaddress) public 
440     {
441         require(msg.sender == wallet);
442         whiteListedAddresses[whitelistaddress] = true;
443     } 
444     
445     function getRefund() public 
446     {
447         require(refundToBuyers == true && ethersSentForRefund == true);
448         require(usersThatBoughtETA[msg.sender]>0);
449         uint256 ethersSent = usersThatBoughtETA[msg.sender];
450         require (wallet.balance >= ethersSent);
451         msg.sender.transfer(ethersSent);
452     }
453     
454     function debitAmountToRefund() public payable {
455         require(hasEnded()==true);
456         require(msg.sender == wallet);
457         require(msg.value >=amountForRefundIfSoftCapNotReached);
458         ethersSentForRefund = true;
459     }
460     
461     function updateTokensForEtheeraTeam(uint256 tokens) internal {
462         
463         uint256 reservedFundTokens;
464         uint256 foundersAndTeamTokens;
465         uint256 advisorsTokens;
466         uint256 marketingTokens;
467         uint256 tournamentTokens;
468         
469         //10% of tokens for reserved fund
470         reservedFundTokens = tokens.mul(10);
471         reservedFundTokens = reservedFundTokens.div(100);
472         tokensForReservedFund = tokensForReservedFund.add(reservedFundTokens);
473     
474         //15% of tokens for founders and team    
475         foundersAndTeamTokens=tokens.mul(15);
476         foundersAndTeamTokens= foundersAndTeamTokens.div(100);
477         tokensForFoundersAndTeam = tokensForFoundersAndTeam.add(foundersAndTeamTokens);
478     
479         //3% of tokens for advisors
480         advisorsTokens=tokens.mul(3);
481         advisorsTokens= advisorsTokens.div(100);
482         tokensForAdvisors= tokensForAdvisors.add(advisorsTokens);
483     
484         //1% of tokens for marketing
485         marketingTokens = tokens.mul(1);
486         marketingTokens= marketingTokens.div(100);
487         tokensForMarketing= tokensForMarketing.add(marketingTokens);
488         
489         //1% of tokens for tournament 
490         tournamentTokens=tokens.mul(1);
491         tournamentTokens= tournamentTokens.div(100);
492         tokensForTournament= tokensForTournament.add(tournamentTokens);
493     }
494     
495     function withdrawTokensForEtheeraTeam(uint256 whoseTokensToWithdraw,address[] whereToSendTokens) public {
496         //1 reserved fund, 2 for founders and team, 3 for advisors, 4 for marketing, 5 for tournament
497         require(msg.sender == wallet);
498         require(now>=endTime);
499         uint256 lockPeriod = 0;
500         uint256 timePassed = now - endTime;
501         uint256 tokensToSend = 0;
502         uint256 i = 0;
503         if (whoseTokensToWithdraw == 1)
504         {
505           //15 months lockup period
506           lockPeriod = 15 days * 30;
507           require(timePassed >= lockPeriod);
508           //allow withdrawal
509           tokensToSend = tokensForReservedFund.div(whereToSendTokens.length);
510                 
511           for (i=0;i<whereToSendTokens.length;i++)
512           {
513             token.mint(wallet,whereToSendTokens[i],tokensToSend);
514           }
515           tokensForReservedFund = 0;
516         }
517         else if (whoseTokensToWithdraw == 2)
518         {
519           //10 months lockup period
520           lockPeriod = 10 days * 30;
521           require(timePassed >= lockPeriod);
522           //allow withdrawal
523           tokensToSend = tokensForFoundersAndTeam.div(whereToSendTokens.length);
524                 
525           for (i=0;i<whereToSendTokens.length;i++)
526           {
527             token.mint(wallet,whereToSendTokens[i],tokensToSend);
528           }            
529           tokensForFoundersAndTeam = 0;
530         }
531         else if (whoseTokensToWithdraw == 3)
532         {
533           //allow withdrawal
534           tokensToSend = tokensForAdvisors.div(whereToSendTokens.length);        
535           for (i=0;i<whereToSendTokens.length;i++)
536           {
537             token.mint(wallet,whereToSendTokens[i],tokensToSend);
538           }
539           tokensForAdvisors = 0;
540         }
541         else if (whoseTokensToWithdraw == 4)
542         {
543           //allow withdrawal
544           tokensToSend = tokensForMarketing.div(whereToSendTokens.length);
545                 
546           for (i=0;i<whereToSendTokens.length;i++)
547           {
548             token.mint(wallet,whereToSendTokens[i],tokensToSend);
549           }
550           tokensForMarketing = 0;
551         }
552         else if (whoseTokensToWithdraw == 5)
553         {
554           //allow withdrawal
555           tokensToSend = tokensForTournament.div(whereToSendTokens.length);
556                 
557           for (i=0;i<whereToSendTokens.length;i++)
558           {
559             token.mint(wallet,whereToSendTokens[i],tokensToSend);
560           }
561           tokensForTournament = 0;
562         }
563         else 
564         {
565           //wrong input
566           require (1!=1);
567         }
568     }
569     
570     /**
571      * function to set the new price 
572      * can only be called from owner wallet
573      **/ 
574     function setPriceRate(uint256 newPrice) public returns (bool) {
575         ratePerWei = newPrice;
576     }
577 }