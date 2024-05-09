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
82 }
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90   uint256 public totalSupply;
91   function balanceOf(address who) constant public returns (uint256);
92   function transfer(address to, uint256 value) public returns (bool);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 /**
97  * @title Basic token
98  * @dev Basic version of StandardToken, with no allowances.
99  */
100 contract BasicToken is ERC20Basic {
101   using SafeMath for uint256;
102 
103   mapping(address => uint256) tokenBalances;
104 
105   /**
106   * @dev transfer token for a specified address
107   * @param _to The address to transfer to.
108   * @param _value The amount to be transferred.
109   */
110   function transfer(address _to, uint256 _value) public returns (bool) {
111     require(tokenBalances[msg.sender]>=_value);
112     tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(_value);
113     tokenBalances[_to] = tokenBalances[_to].add(_value);
114     Transfer(msg.sender, _to, _value);
115     return true;
116   }
117 
118   /**
119   * @dev Gets the balance of the specified address.
120   * @param _owner The address to query the the balance of.
121   * @return An uint256 representing the amount owned by the passed address.
122   */
123   function balanceOf(address _owner) constant public returns (uint256 balance) {
124     return tokenBalances[_owner];
125   }
126 
127 }
128 contract EtheeraToken is BasicToken,Ownable {
129 
130    using SafeMath for uint256;
131    
132    string public constant name = "ETHEERA";
133    string public constant symbol = "ETA";
134    uint256 public constant decimals = 18;
135 
136    uint256 public constant INITIAL_SUPPLY = 300000000;
137    event Debug(string message, address addr, uint256 number);
138    /**
139    * @dev Contructor that gives msg.sender all of existing tokens.
140    */
141     function EtheeraToken(address wallet) public {
142         owner = msg.sender;
143         totalSupply = INITIAL_SUPPLY * 10 ** 18;
144         tokenBalances[wallet] = totalSupply;   //Since we divided the token into 10^18 parts
145     }
146 
147     function mint(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {
148       require(tokenBalances[wallet] >= tokenAmount);               // checks if it has enough to sell
149       tokenBalances[buyer] = tokenBalances[buyer].add(tokenAmount);                  // adds the amount to buyer's balance
150       tokenBalances[wallet] = tokenBalances[wallet].sub(tokenAmount);                        // subtracts amount from seller's balance
151       Transfer(wallet, buyer, tokenAmount); 
152     }
153     
154     function showMyTokenBalance(address addr) public view onlyOwner returns (uint tokenBalance) {
155         tokenBalance = tokenBalances[addr];
156         return tokenBalance;
157     }
158     
159     function showMyEtherBalance(address addr) public view onlyOwner returns (uint etherBalance) {
160         etherBalance = addr.balance;
161     }
162 }
163 contract EtheeraCrowdsale {
164   using SafeMath for uint256;
165  
166   // The token being sold
167   EtheeraToken public token;
168 
169   // start and end timestamps where investments are allowed (both inclusive)
170   uint256 public startTime;
171   uint256 public endTime;
172 
173   // address where funds are collected
174   // address where tokens are deposited and from where we send tokens to buyers
175   address public wallet;
176 
177   // how many token units a buyer gets per wei
178   uint256 public ratePerWei = 2000;
179 
180   // amount of raised money in wei
181   uint256 public weiRaised;
182 
183   // flags to show whether soft cap / hard cap is reached
184   bool public isSoftCapReached = false;
185   bool public isHardCapReached = false;
186     
187   //this flag is set to true when ICO duration is over and soft cap is not reached  
188   bool public refundToBuyers = false;
189     
190   // Soft cap of the ICO in ethers  
191   uint256 public softCap = 6000;
192     
193   //Hard cap of the ICO in ethers
194   uint256 public hardCap = 105000;
195   
196   //total tokens that have been sold  
197   uint256 tokens_sold = 0;
198 
199   //total tokens that are to be sold - this is 70% of the total supply i.e. 300000000
200   uint maxTokensForSale = 210000000;
201   
202   //tokens that are reserved for the etheera team - this is 30% of the total supply  
203   uint256 public tokensForReservedFund = 0;
204   uint256 public tokensForAdvisors = 0;
205   uint256 public tokensForFoundersAndTeam = 0;
206   uint256 public tokensForMarketing = 0;
207   uint256 public tokensForTournament = 0;
208 
209   bool ethersSentForRefund = false;
210   
211   // whitelisted addresses are those that have registered on the website
212   mapping(address=>bool) whiteListedAddresses;
213 
214   // the buyers of tokens and the amount of ethers they sent in
215   mapping(address=>uint256) usersThatBoughtETA;
216  
217   address whiteLister; 
218   /**
219    * event for token purchase logging
220    * @param purchaser who paid for the tokens
221    * @param beneficiary who got the tokens
222    * @param value weis paid for purchase
223    * @param amount amount of tokens purchased
224    */
225   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
226 
227 
228   function EtheeraCrowdsale(uint256 _startTime, address _wallet, address _whiteLister) public {
229     
230     require(_startTime >= now);
231     startTime = _startTime;
232     endTime = startTime + 60 days;
233     
234     require(endTime >= startTime);
235     require(_wallet != 0x0);
236 
237     wallet = _wallet;
238     whiteLister = _whiteLister;
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
255     uint256 timeElapsedInDays = timeElapsed.div(1 days);
256     
257     if (timeElapsedInDays <=7)
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
290         else 
291         {
292             bonus = 0;
293         }
294     }
295     else if (timeElapsedInDays>7 && timeElapsedInDays <=49)
296     {
297         //sale
298         //from 7th day till 49th day (total 42 days or 6 weeks)
299         //30000+ TOKEN PURCHASE AMOUNT / 15% BONUS
300         if (tokens>30000 * 10 ** 18)
301         {
302             //15% bonus
303             bonus = tokens.mul(15);
304             bonus = bonus.div(100);
305         }
306         //10000+ TOKEN PURCHASE AMOUNT / 10% BONUS
307         else if (tokens>10000 *10 ** 18 && tokens<= 30000 * 10 ** 18)
308         {
309             //10% bonus
310             bonus = tokens.mul(10);
311             bonus = bonus.div(100);
312         }
313         //3000+ TOKEN PURCHASE AMOUNT / 5% BONUS
314         else if (tokens>3000 *10 ** 18 && tokens<= 10000 * 10 ** 18)
315         {
316             //5% bonus
317             bonus = tokens.mul(5);
318             bonus = bonus.div(100);
319         }
320         
321         //75+ TOKEN PURCHASE AMOUNT / 3% BONUS
322         else if (tokens>=75 *10 ** 18 && tokens<= 3000 * 10 ** 18)
323         {
324             //3% bonus
325             bonus = tokens.mul(3);
326             bonus = bonus.div(100);
327         }
328         else 
329         {
330             bonus = 0;
331         }
332     }
333     else
334     {
335         //no bonuses after 7th week i.e. 49 days
336         bonus = 0;
337     }
338   }
339 
340   // low level token purchase function
341   // Minimum purchase can be of 75 ETA tokens
342   
343   function buyTokens(address beneficiary) public payable {
344     
345   //tokens not to be sent to 0x0
346   require(beneficiary != 0x0);
347 
348   if(hasEnded() && !isHardCapReached)
349   {
350       if (!isSoftCapReached)
351         refundToBuyers = true;
352       burnRemainingTokens();
353       beneficiary.transfer(msg.value);
354   }
355   
356   else
357   {
358   
359     //the purchase should be within duration and non zero
360     require(validPurchase());
361     
362     require(whiteListedAddresses[beneficiary] == true);
363     // amount sent by the user
364     uint256 weiAmount = msg.value;
365     
366     // calculate token amount to be sold
367     uint256 tokens = weiAmount.mul(ratePerWei);
368   
369     require (tokens>=75 * 10 ** 18);
370     
371     //Determine bonus
372     uint bonus = determineBonus(tokens);
373     tokens = tokens.add(bonus);
374   
375     //can't sale tokens more than 21000000000
376     require(tokens_sold + tokens <= maxTokensForSale * 10 ** 18);
377   
378     //30% of the tokens being sold are being accumulated for the etheera team
379     updateTokensForEtheeraTeam(tokens);
380 
381     weiRaised = weiRaised.add(weiAmount);
382     
383     
384     if (weiRaised >= softCap * 10 ** 18 && !isSoftCapReached)
385     {
386       isSoftCapReached = true;
387     }
388   
389     if (weiRaised >= hardCap * 10 ** 18 && !isHardCapReached)
390       isHardCapReached = true;
391     
392     token.mint(wallet, beneficiary, tokens);
393     
394     uint olderAmount = usersThatBoughtETA[beneficiary];
395     usersThatBoughtETA[beneficiary] = weiAmount + olderAmount;
396     
397     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
398     
399     tokens_sold = tokens_sold.add(tokens);
400     
401     forwardFunds();
402   }
403  }
404 
405   // send ether to the fund collection wallet
406   function forwardFunds() internal {
407     wallet.transfer(msg.value);
408   }
409 
410   // @return true if the transaction can buy tokens
411   function validPurchase() internal constant returns (bool) {
412     bool withinPeriod = now >= startTime && now <= endTime;
413     bool nonZeroPurchase = msg.value != 0;
414     return withinPeriod && nonZeroPurchase;
415   }
416 
417   // @return true if crowdsale event has ended
418   function hasEnded() public constant returns (bool) {
419     return now > endTime;
420   }
421   
422    function showMyTokenBalance() public view returns (uint256 tokenBalance) {
423         tokenBalance = token.showMyTokenBalance(msg.sender);
424         return tokenBalance;
425     }
426     
427     function burnRemainingTokens() internal
428     {
429         //burn all the unsold tokens as soon as the ICO is ended
430         uint balance = token.showMyTokenBalance(wallet);
431         require(balance>0);
432         uint tokensForTeam = tokensForReservedFund + tokensForFoundersAndTeam + tokensForAdvisors +tokensForMarketing + tokensForTournament;
433         uint tokensToBurn = balance.sub(tokensForTeam);
434         require (balance >=tokensToBurn);
435         address burnAddress = 0x0;
436         token.mint(wallet,burnAddress,tokensToBurn);
437     }
438     
439     function addAddressToWhiteList(address whitelistaddress) public 
440     {
441         require(msg.sender == wallet || msg.sender == whiteLister);
442         whiteListedAddresses[whitelistaddress] = true;
443     }
444     
445     function checkIfAddressIsWhitelisted(address whitelistaddress) public constant returns (bool)
446     {
447         if (whiteListedAddresses[whitelistaddress] == true)
448             return true;
449         return false; 
450     }
451     
452     function getRefund() public 
453     {
454         require(ethersSentForRefund && usersThatBoughtETA[msg.sender]>0);
455         uint256 ethersSent = usersThatBoughtETA[msg.sender];
456         require (wallet.balance >= ethersSent);
457         msg.sender.transfer(ethersSent);
458         uint256 tokensIHave = token.showMyTokenBalance(msg.sender);
459         token.mint(msg.sender,0x0,tokensIHave);
460     }
461     
462     function debitAmountToRefund() public payable 
463     {
464         require(hasEnded() && msg.sender == wallet && !isSoftCapReached && !ethersSentForRefund);
465         require(msg.value >=weiRaised);
466         ethersSentForRefund = true;
467     }
468     
469     function updateTokensForEtheeraTeam(uint256 tokens) internal 
470     {
471         uint256 reservedFundTokens;
472         uint256 foundersAndTeamTokens;
473         uint256 advisorsTokens;
474         uint256 marketingTokens;
475         uint256 tournamentTokens;
476         
477         //10% of tokens for reserved fund
478         reservedFundTokens = tokens.mul(10);
479         reservedFundTokens = reservedFundTokens.div(100);
480         tokensForReservedFund = tokensForReservedFund.add(reservedFundTokens);
481     
482         //15% of tokens for founders and team    
483         foundersAndTeamTokens=tokens.mul(15);
484         foundersAndTeamTokens= foundersAndTeamTokens.div(100);
485         tokensForFoundersAndTeam = tokensForFoundersAndTeam.add(foundersAndTeamTokens);
486     
487         //3% of tokens for advisors
488         advisorsTokens=tokens.mul(3);
489         advisorsTokens= advisorsTokens.div(100);
490         tokensForAdvisors= tokensForAdvisors.add(advisorsTokens);
491     
492         //1% of tokens for marketing
493         marketingTokens = tokens.mul(1);
494         marketingTokens= marketingTokens.div(100);
495         tokensForMarketing= tokensForMarketing.add(marketingTokens);
496         
497         //1% of tokens for tournament 
498         tournamentTokens=tokens.mul(1);
499         tournamentTokens= tournamentTokens.div(100);
500         tokensForTournament= tokensForTournament.add(tournamentTokens);
501     }
502     
503     function withdrawTokensForEtheeraTeam(uint256 whoseTokensToWithdraw,address[] whereToSendTokens) public {
504         //1 reserved fund, 2 for founders and team, 3 for advisors, 4 for marketing, 5 for tournament
505         require(msg.sender == wallet && now>=endTime);
506         uint256 lockPeriod = 0;
507         uint256 timePassed = now - endTime;
508         uint256 tokensToSend = 0;
509         uint256 i = 0;
510         if (whoseTokensToWithdraw == 1)
511         {
512           //15 months lockup period
513           lockPeriod = 15 days * 30;
514           require(timePassed >= lockPeriod);
515           require (tokensForReservedFund >0);
516           //allow withdrawal
517           tokensToSend = tokensForReservedFund.div(whereToSendTokens.length);
518                 
519           for (i=0;i<whereToSendTokens.length;i++)
520           {
521             token.mint(wallet,whereToSendTokens[i],tokensToSend);
522           }
523           tokensForReservedFund = 0;
524         }
525         else if (whoseTokensToWithdraw == 2)
526         {
527           //10 months lockup period
528           lockPeriod = 10 days * 30;
529           require(timePassed >= lockPeriod);
530           require(tokensForFoundersAndTeam > 0);
531           //allow withdrawal
532           tokensToSend = tokensForFoundersAndTeam.div(whereToSendTokens.length);
533                 
534           for (i=0;i<whereToSendTokens.length;i++)
535           {
536             token.mint(wallet,whereToSendTokens[i],tokensToSend);
537           }            
538           tokensForFoundersAndTeam = 0;
539         }
540         else if (whoseTokensToWithdraw == 3)
541         {
542             require (tokensForAdvisors > 0);
543           //allow withdrawal
544           tokensToSend = tokensForAdvisors.div(whereToSendTokens.length);        
545           for (i=0;i<whereToSendTokens.length;i++)
546           {
547             token.mint(wallet,whereToSendTokens[i],tokensToSend);
548           }
549           tokensForAdvisors = 0;
550         }
551         else if (whoseTokensToWithdraw == 4)
552         {
553             require (tokensForMarketing > 0);
554           //allow withdrawal
555           tokensToSend = tokensForMarketing.div(whereToSendTokens.length);
556                 
557           for (i=0;i<whereToSendTokens.length;i++)
558           {
559             token.mint(wallet,whereToSendTokens[i],tokensToSend);
560           }
561           tokensForMarketing = 0;
562         }
563         else if (whoseTokensToWithdraw == 5)
564         {
565             require (tokensForTournament > 0);
566           //allow withdrawal
567           tokensToSend = tokensForTournament.div(whereToSendTokens.length);
568                 
569           for (i=0;i<whereToSendTokens.length;i++)
570           {
571             token.mint(wallet,whereToSendTokens[i],tokensToSend);
572           }
573           tokensForTournament = 0;
574         }
575         else 
576         {
577           //wrong input
578           require (1!=1);
579         }
580     }
581 }