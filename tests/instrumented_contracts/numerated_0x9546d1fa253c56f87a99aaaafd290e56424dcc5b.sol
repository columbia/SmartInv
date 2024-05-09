1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title Crowdsale
5  * @dev Crowdsale is a base contract for managing a token crowdsale.
6  * Crowdsales have a start and end timestamps, where investors can make
7  * token purchases and the crowdsale will assign them tokens based
8  * on a token per ETH rate. Funds collected are forwarded to a wallet
9  * as they arrive.
10  */
11  
12  
13 library SafeMath {
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a * b;
16     assert(a == 0 || c / a == b);
17     return c;
18   }
19 
20  function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() public {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 }
74 
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81   uint256 public totalSupply;
82   function balanceOf(address who) constant public returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 /**
88  * @title Basic token
89  * @dev Basic version of StandardToken, with no allowances.
90  */
91 contract BasicToken is ERC20Basic {
92   using SafeMath for uint256;
93 
94   mapping(address => uint256) tokenBalances;
95 
96   /**
97   * @dev transfer token for a specified address
98   * @param _to The address to transfer to.
99   * @param _value The amount to be transferred.
100   */
101   function transfer(address _to, uint256 _value) public returns (bool) {
102     require(tokenBalances[msg.sender]>=_value);
103     tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(_value);
104     tokenBalances[_to] = tokenBalances[_to].add(_value);
105     Transfer(msg.sender, _to, _value);
106     return true;
107   }
108 
109   /**
110   * @dev Gets the balance of the specified address.
111   * @param _owner The address to query the the balance of.
112   * @return An uint256 representing the amount owned by the passed address.
113   */
114   function balanceOf(address _owner) constant public returns (uint256 balance) {
115     return tokenBalances[_owner];
116   }
117 
118 }
119 contract EtheeraToken is BasicToken,Ownable {
120 
121    using SafeMath for uint256;
122    
123    string public constant name = "ETHEERA";
124    string public constant symbol = "ETA";
125    uint256 public constant decimals = 18;
126 
127    uint256 public constant INITIAL_SUPPLY = 300000000;
128    event Debug(string message, address addr, uint256 number);
129    /**
130    * @dev Contructor that gives msg.sender all of existing tokens.
131    */
132     function EtheeraToken(address wallet) public {
133         owner = msg.sender;
134         totalSupply = INITIAL_SUPPLY * 10 ** 18;
135         tokenBalances[wallet] = totalSupply;   //Since we divided the token into 10^18 parts
136     }
137 
138     function mint(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {
139       require(tokenBalances[wallet] >= tokenAmount);               // checks if it has enough to sell
140       tokenBalances[buyer] = tokenBalances[buyer].add(tokenAmount);                  // adds the amount to buyer's balance
141       tokenBalances[wallet] = tokenBalances[wallet].sub(tokenAmount);                        // subtracts amount from seller's balance
142       Transfer(wallet, buyer, tokenAmount);
143       totalSupply = totalSupply.sub(tokenAmount);
144     }
145     
146     function showMyTokenBalance(address addr) public view onlyOwner returns (uint tokenBalance) {
147         tokenBalance = tokenBalances[addr];
148         return tokenBalance;
149     }
150     
151 }
152 contract EtheeraCrowdsale {
153   using SafeMath for uint256;
154  
155   // The token being sold
156   EtheeraToken public token;
157 
158   // start and end timestamps where investments are allowed (both inclusive)
159   uint256 public startTime;
160   uint256 public endTime;
161 
162   // address where funds are collected
163   // address where tokens are deposited and from where we send tokens to buyers
164   address public wallet;
165 
166   // how many token units a buyer gets per wei
167   uint256 public ratePerWei = 2000;
168 
169   // amount of raised money in wei
170   uint256 public weiRaised;
171 
172   // flags to show whether soft cap / hard cap is reached
173   bool public isSoftCapReached = false;
174   bool public isHardCapReached = false;
175     
176   //this flag is set to true when ICO duration is over and soft cap is not reached  
177   bool public refundToBuyers = false;
178     
179   // Soft cap of the ICO in ethers  
180   uint256 public softCap = 6000;
181     
182   //Hard cap of the ICO in ethers
183   uint256 public hardCap = 105000;
184   
185   //total tokens that have been sold  
186   uint256 public tokens_sold = 0;
187 
188   //total tokens that are to be sold - this is 70% of the total supply i.e. 300000000
189   uint maxTokensForSale = 210000000;
190   
191   //tokens that are reserved for the etheera team - this is 30% of the total supply  
192   uint256 public tokensForReservedFund = 0;
193   uint256 public tokensForAdvisors = 0;
194   uint256 public tokensForFoundersAndTeam = 0;
195   uint256 public tokensForMarketing = 0;
196   uint256 public tokensForTournament = 0;
197 
198   bool ethersSentForRefund = false;
199 
200   // the buyers of tokens and the amount of ethers they sent in
201   mapping(address=>uint256) usersThatBoughtETA;
202  
203   /**
204    * event for token purchase logging
205    * @param purchaser who paid for the tokens
206    * @param beneficiary who got the tokens
207    * @param value weis paid for purchase
208    * @param amount amount of tokens purchased
209    */
210   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
211 
212   function EtheeraCrowdsale(uint256 _startTime, address _wallet) public {
213 
214     startTime = _startTime;
215     endTime = startTime + 60 days;
216     
217     require(endTime >= startTime);
218     require(_wallet != 0x0);
219 
220     wallet = _wallet;
221     token = createTokenContract(wallet);
222   }
223 
224   function createTokenContract(address wall) internal returns (EtheeraToken) {
225     return new EtheeraToken(wall);
226   }
227 
228   // fallback function can be used to buy tokens
229   function () public payable {
230     buyTokens(msg.sender);
231   }
232 
233   //determine the bonus with respect to time elapsed
234   function determineBonus(uint tokens) internal view returns (uint256 bonus) {
235     
236     uint256 timeElapsed = now - startTime;
237     uint256 timeElapsedInDays = timeElapsed.div(1 days);
238     
239     if (timeElapsedInDays <=29)
240     {
241         //early sale
242         //valid for 7 days (1st week)
243         //30000+ TOKEN PURCHASE AMOUNT / 33% BONUS
244         if (tokens>30000 * 10 ** 18)
245         {
246             //33% bonus
247             bonus = tokens.mul(33);
248             bonus = bonus.div(100);
249         }
250         //10000+ TOKEN PURCHASE AMOUNT / 26% BONUS
251         else if (tokens>10000 *10 ** 18 && tokens<= 30000 * 10 ** 18)
252         {
253             //26% bonus
254             bonus = tokens.mul(26);
255             bonus = bonus.div(100);
256         }
257         //3000+ TOKEN PURCHASE AMOUNT / 23% BONUS
258         else if (tokens>3000 *10 ** 18 && tokens<= 10000 * 10 ** 18)
259         {
260             //23% bonus
261             bonus = tokens.mul(23);
262             bonus = bonus.div(100);
263         }
264         
265         //75+ TOKEN PURCHASE AMOUNT / 20% BONUS
266         else if (tokens>=75 *10 ** 18 && tokens<= 3000 * 10 ** 18)
267         {
268             //20% bonus
269             bonus = tokens.mul(20);
270             bonus = bonus.div(100);
271         }
272         else 
273         {
274             bonus = 0;
275         }
276     }
277     else if (timeElapsedInDays>29 && timeElapsedInDays <=49)
278     {
279         //sale
280         //from 7th day till 49th day (total 42 days or 6 weeks)
281         //30000+ TOKEN PURCHASE AMOUNT / 15% BONUS
282         if (tokens>30000 * 10 ** 18)
283         {
284             //15% bonus
285             bonus = tokens.mul(15);
286             bonus = bonus.div(100);
287         }
288         //10000+ TOKEN PURCHASE AMOUNT / 10% BONUS
289         else if (tokens>10000 *10 ** 18 && tokens<= 30000 * 10 ** 18)
290         {
291             //10% bonus
292             bonus = tokens.mul(10);
293             bonus = bonus.div(100);
294         }
295         //3000+ TOKEN PURCHASE AMOUNT / 5% BONUS
296         else if (tokens>3000 *10 ** 18 && tokens<= 10000 * 10 ** 18)
297         {
298             //5% bonus
299             bonus = tokens.mul(5);
300             bonus = bonus.div(100);
301         }
302         
303         //75+ TOKEN PURCHASE AMOUNT / 3% BONUS
304         else if (tokens>=75 *10 ** 18 && tokens<= 3000 * 10 ** 18)
305         {
306             //3% bonus
307             bonus = tokens.mul(3);
308             bonus = bonus.div(100);
309         }
310         else 
311         {
312             bonus = 0;
313         }
314     }
315     else
316     {
317         //no bonuses after 7th week i.e. 49 days
318         bonus = 0;
319     }
320   }
321 
322   // low level token purchase function
323   // Minimum purchase can be of 75 ETA tokens
324   
325   function buyTokens(address beneficiary) public payable {
326     
327   //tokens not to be sent to 0x0
328   require(beneficiary != 0x0);
329 
330   if(hasEnded() && !isHardCapReached)
331   {
332       if (!isSoftCapReached)
333         refundToBuyers = true;
334       burnRemainingTokens();
335       beneficiary.transfer(msg.value);
336   }
337   
338   else
339   {
340     //the purchase should be within duration and non zero
341     require(validPurchase());
342     
343     // amount sent by the user
344     uint256 weiAmount = msg.value;
345     
346     // calculate token amount to be sold
347     uint256 tokens = weiAmount.mul(ratePerWei);
348   
349     require (tokens>=75 * 10 ** 18);
350     
351     //Determine bonus
352     uint bonus = determineBonus(tokens);
353     tokens = tokens.add(bonus);
354   
355     //can't sale tokens more than 21000000000
356     require(tokens_sold + tokens <= maxTokensForSale * 10 ** 18);
357   
358     //30% of the tokens being sold are being accumulated for the etheera team
359     updateTokensForEtheeraTeam(tokens);
360 
361     weiRaised = weiRaised.add(weiAmount);
362     
363     
364     if (weiRaised >= softCap * 10 ** 18 && !isSoftCapReached)
365     {
366       isSoftCapReached = true;
367     }
368   
369     if (weiRaised >= hardCap * 10 ** 18 && !isHardCapReached)
370       isHardCapReached = true;
371     
372     token.mint(wallet, beneficiary, tokens);
373     
374     uint olderAmount = usersThatBoughtETA[beneficiary];
375     usersThatBoughtETA[beneficiary] = weiAmount + olderAmount;
376     
377     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
378     
379     tokens_sold = tokens_sold.add(tokens);
380     forwardFunds();
381   }
382  }
383 
384   // send ether to the fund collection wallet
385   function forwardFunds() internal {
386     wallet.transfer(msg.value);
387   }
388 
389   // @return true if the transaction can buy tokens
390   function validPurchase() internal constant returns (bool) {
391     bool withinPeriod = now >= startTime && now <= endTime;
392     bool nonZeroPurchase = msg.value != 0;
393     return withinPeriod && nonZeroPurchase;
394   }
395 
396   // @return true if crowdsale event has ended
397   function hasEnded() public constant returns (bool) {
398     return now > endTime;
399   }
400     
401     function burnRemainingTokens() internal
402     {
403         //burn all the unsold tokens as soon as the ICO is ended
404         uint balance = token.showMyTokenBalance(wallet);
405         require(balance>0);
406         uint tokensForTeam = tokensForReservedFund + tokensForFoundersAndTeam + tokensForAdvisors +tokensForMarketing + tokensForTournament;
407         uint tokensToBurn = balance.sub(tokensForTeam);
408         require (balance >=tokensToBurn);
409         address burnAddress = 0x0;
410         token.mint(wallet,burnAddress,tokensToBurn);
411     }
412     
413     function getRefund() public 
414     {
415         require(ethersSentForRefund && usersThatBoughtETA[msg.sender]>0);
416         uint256 ethersSent = usersThatBoughtETA[msg.sender];
417         require (wallet.balance >= ethersSent);
418         msg.sender.transfer(ethersSent);
419         uint256 tokensIHave = token.showMyTokenBalance(msg.sender);
420         token.mint(msg.sender,0x0,tokensIHave);
421     }
422     
423     function debitAmountToRefund() public payable 
424     {
425         require(hasEnded() && msg.sender == wallet && !isSoftCapReached && !ethersSentForRefund);
426         require(msg.value >=weiRaised);
427         ethersSentForRefund = true;
428     }
429     
430     function updateTokensForEtheeraTeam(uint256 tokens) internal 
431     {
432         uint256 reservedFundTokens;
433         uint256 foundersAndTeamTokens;
434         uint256 advisorsTokens;
435         uint256 marketingTokens;
436         uint256 tournamentTokens;
437         
438         //10% of tokens for reserved fund
439         reservedFundTokens = tokens.mul(10);
440         reservedFundTokens = reservedFundTokens.div(100);
441         tokensForReservedFund = tokensForReservedFund.add(reservedFundTokens);
442     
443         //15% of tokens for founders and team    
444         foundersAndTeamTokens=tokens.mul(15);
445         foundersAndTeamTokens= foundersAndTeamTokens.div(100);
446         tokensForFoundersAndTeam = tokensForFoundersAndTeam.add(foundersAndTeamTokens);
447     
448         //3% of tokens for advisors
449         advisorsTokens=tokens.mul(3);
450         advisorsTokens= advisorsTokens.div(100);
451         tokensForAdvisors= tokensForAdvisors.add(advisorsTokens);
452     
453         //1% of tokens for marketing
454         marketingTokens = tokens.mul(1);
455         marketingTokens= marketingTokens.div(100);
456         tokensForMarketing= tokensForMarketing.add(marketingTokens);
457         
458         //1% of tokens for tournament 
459         tournamentTokens=tokens.mul(1);
460         tournamentTokens= tournamentTokens.div(100);
461         tokensForTournament= tokensForTournament.add(tournamentTokens);
462     }
463     
464     function withdrawTokensForEtheeraTeam(uint256 whoseTokensToWithdraw,address[] whereToSendTokens) public {
465         //1 reserved fund, 2 for founders and team, 3 for advisors, 4 for marketing, 5 for tournament
466         require(msg.sender == wallet && now>=endTime);
467         uint256 lockPeriod = 0;
468         uint256 timePassed = now - endTime;
469         uint256 tokensToSend = 0;
470         uint256 i = 0;
471         if (whoseTokensToWithdraw == 1)
472         {
473           //15 months lockup period
474           lockPeriod = 15 days * 30;
475           require(timePassed >= lockPeriod);
476           require (tokensForReservedFund >0);
477           //allow withdrawal
478           tokensToSend = tokensForReservedFund.div(whereToSendTokens.length);
479                 
480           for (i=0;i<whereToSendTokens.length;i++)
481           {
482             token.mint(wallet,whereToSendTokens[i],tokensToSend);
483           }
484           tokensForReservedFund = 0;
485         }
486         else if (whoseTokensToWithdraw == 2)
487         {
488           //10 months lockup period
489           lockPeriod = 10 days * 30;
490           require(timePassed >= lockPeriod);
491           require(tokensForFoundersAndTeam > 0);
492           //allow withdrawal
493           tokensToSend = tokensForFoundersAndTeam.div(whereToSendTokens.length);
494                 
495           for (i=0;i<whereToSendTokens.length;i++)
496           {
497             token.mint(wallet,whereToSendTokens[i],tokensToSend);
498           }            
499           tokensForFoundersAndTeam = 0;
500         }
501         else if (whoseTokensToWithdraw == 3)
502         {
503             require (tokensForAdvisors > 0);
504           //allow withdrawal
505           tokensToSend = tokensForAdvisors.div(whereToSendTokens.length);        
506           for (i=0;i<whereToSendTokens.length;i++)
507           {
508             token.mint(wallet,whereToSendTokens[i],tokensToSend);
509           }
510           tokensForAdvisors = 0;
511         }
512         else if (whoseTokensToWithdraw == 4)
513         {
514             require (tokensForMarketing > 0);
515           //allow withdrawal
516           tokensToSend = tokensForMarketing.div(whereToSendTokens.length);
517                 
518           for (i=0;i<whereToSendTokens.length;i++)
519           {
520             token.mint(wallet,whereToSendTokens[i],tokensToSend);
521           }
522           tokensForMarketing = 0;
523         }
524         else if (whoseTokensToWithdraw == 5)
525         {
526             require (tokensForTournament > 0);
527           //allow withdrawal
528           tokensToSend = tokensForTournament.div(whereToSendTokens.length);
529                 
530           for (i=0;i<whereToSendTokens.length;i++)
531           {
532             token.mint(wallet,whereToSendTokens[i],tokensToSend);
533           }
534           tokensForTournament = 0;
535         }
536         else 
537         {
538           //wrong input
539           require (1!=1);
540         }
541     }
542 }