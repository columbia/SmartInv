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
76  * @title ERC20Standard
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Interface {
81      function totalSupply() public constant returns (uint);
82      function balanceOf(address tokenOwner) public constant returns (uint balance);
83      function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
84      function transfer(address to, uint tokens) public returns (bool success);
85      function approve(address spender, uint tokens) public returns (bool success);
86      function transferFrom(address from, address to, uint tokens) public returns (bool success);
87      event Transfer(address indexed from, address indexed to, uint tokens);
88      event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
89 }
90 contract EtheeraToken is ERC20Interface,Ownable {
91 
92     using SafeMath for uint256;
93    
94     mapping(address => uint256) tokenBalances;
95     mapping (address => mapping (address => uint256)) allowed;
96     uint256 public totalSupply;
97 
98     string public constant name = "ETHEERA";
99     string public constant symbol = "ETA";
100     uint256 public constant decimals = 18;
101 
102    uint256 public constant INITIAL_SUPPLY = 75000000000;
103 
104   /**
105   * @dev transfer token for a specified address
106   * @param _to The address to transfer to.
107   * @param _value The amount to be transferred.
108   */
109   function transfer(address _to, uint256 _value) public returns (bool) {
110     require(tokenBalances[msg.sender]>=_value);
111     tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(_value);
112     tokenBalances[_to] = tokenBalances[_to].add(_value);
113     Transfer(msg.sender, _to, _value);
114     return true;
115   }
116 
117   /**
118   * @dev Gets the balance of the specified address.
119   * @param _owner The address to query the the balance of.
120   * @return An uint256 representing the amount owned by the passed address.
121   */
122   function balanceOf(address _owner) constant public returns (uint256 balance) {
123     return tokenBalances[_owner];
124   }
125   
126   
127      /**
128    * @dev Transfer tokens from one address to another
129    * @param _from address The address which you want to send tokens from
130    * @param _to address The address which you want to transfer to
131    * @param _value uint256 the amount of tokens to be transferred
132    */
133   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
134     require(_to != address(0));
135     require(_value <= tokenBalances[_from]);
136     require(_value <= allowed[_from][msg.sender]);
137 
138     tokenBalances[_from] = tokenBalances[_from].sub(_value);
139     tokenBalances[_to] = tokenBalances[_to].add(_value);
140     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
141     Transfer(_from, _to, _value);
142     return true;
143   }
144   
145      /**
146    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
147    *
148    * Beware that changing an allowance with this method brings the risk that someone may use both the old
149    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
150    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
151    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152    * @param _spender The address which will spend the funds.
153    * @param _value The amount of tokens to be spent.
154    */
155   function approve(address _spender, uint256 _value) public returns (bool) {
156     allowed[msg.sender][_spender] = _value;
157     Approval(msg.sender, _spender, _value);
158     return true;
159   }
160 
161      // ------------------------------------------------------------------------
162      // Total supply
163      // ------------------------------------------------------------------------
164      function totalSupply() public constant returns (uint) {
165          return totalSupply  - tokenBalances[address(0)];
166      }
167      
168     
169      
170      // ------------------------------------------------------------------------
171      // Returns the amount of tokens approved by the owner that can be
172      // transferred to the spender's account
173      // ------------------------------------------------------------------------
174      function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
175          return allowed[tokenOwner][spender];
176      }
177      
178      /**
179    * @dev Increase the amount of tokens that an owner allowed to a spender.
180    *
181    * approve should be called when allowed[_spender] == 0. To increment
182    * allowed value is better to use this function to avoid 2 calls (and wait until
183    * the first transaction is mined)
184    * From MonolithDAO Token.sol
185    * @param _spender The address which will spend the funds.
186    * @param _addedValue The amount of tokens to increase the allowance by.
187    */
188   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
189     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
190     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191     return true;
192   }
193 
194   /**
195    * @dev Decrease the amount of tokens that an owner allowed to a spender.
196    *
197    * approve should be called when allowed[_spender] == 0. To decrement
198    * allowed value is better to use this function to avoid 2 calls (and wait until
199    * the first transaction is mined)
200    * From MonolithDAO Token.sol
201    * @param _spender The address which will spend the funds.
202    * @param _subtractedValue The amount of tokens to decrease the allowance by.
203    */
204   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
205     uint oldValue = allowed[msg.sender][_spender];
206     if (_subtractedValue > oldValue) {
207       allowed[msg.sender][_spender] = 0;
208     } else {
209       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
210     }
211     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212     return true;
213   }
214 
215      
216      // ------------------------------------------------------------------------
217      // Don't accept ETH
218      // ------------------------------------------------------------------------
219      function () public payable {
220          revert();
221      }   
222 
223 
224   
225    event Debug(string message, address addr, uint256 number);
226    /**
227    * @dev Contructor that gives msg.sender all of existing tokens.
228    */
229     function EtheeraToken(address wallet) public {
230         owner = msg.sender;
231         totalSupply = INITIAL_SUPPLY * 10 ** 18;
232         tokenBalances[wallet] = totalSupply;   //Since we divided the token into 10^18 parts
233     }
234 
235     function mint(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {
236       require(tokenBalances[wallet] >= tokenAmount);               // checks if it has enough to sell
237       tokenBalances[buyer] = tokenBalances[buyer].add(tokenAmount);                  // adds the amount to buyer's balance
238       tokenBalances[wallet] = tokenBalances[wallet].sub(tokenAmount);                        // subtracts amount from seller's balance
239       Transfer(wallet, buyer, tokenAmount); 
240       totalSupply = totalSupply.sub(tokenAmount); 
241     }
242     
243    
244 }
245 contract EtheeraCrowdsale {
246   using SafeMath for uint256;
247  
248   // The token being sold
249   EtheeraToken public token;
250 
251   // start and end timestamps where investments are allowed (both inclusive)
252   uint public startTime;
253   uint public endTime;
254 
255   // address where funds are collected
256   // address where tokens are deposited and from where we send tokens to buyers
257   address public wallet;
258 
259   // how many token units a buyer gets per wei
260   uint256 public ratePerWei = 500000;
261 
262   // amount of raised money in wei
263   uint256 public weiRaised;
264 
265   // flags to show whether soft cap / hard cap is reached
266   bool public isSoftCapReached = false;
267   bool public isHardCapReached = false;
268     
269   //this flag is set to true when ICO duration is over and soft cap is not reached  
270   bool public refundToBuyers = false;
271     
272   // Soft cap of the ICO in ethers  
273   uint256 public softCap = 6000;
274     
275   //Hard cap of the ICO in ethers
276   uint256 public hardCap = 105000;
277   
278   //total tokens that have been sold  
279   uint256 public tokens_sold = 0;
280 
281   //total tokens that are to be sold - this is 70% of the total supply i.e. 52500000000
282   uint maxTokensForSale = 52500000000;
283   
284   //tokens that are reserved for the etheera team - this is 30% of the total supply  
285   uint256 public tokensForReservedFund = 0;
286   uint256 public tokensForAdvisors = 0;
287   uint256 public tokensForFoundersAndTeam = 0;
288   uint256 public tokensForMarketing = 0;
289   uint256 public tokensForTournament = 0;
290 
291   bool ethersSentForRefund = false;
292 
293   // the buyers of tokens and the amount of ethers they sent in
294   mapping(address=>uint256) usersThatBoughtETA;
295  
296   /**
297    * event for token purchase logging
298    * @param purchaser who paid for the tokens
299    * @param beneficiary who got the tokens
300    * @param value weis paid for purchase
301    * @param amount amount of tokens purchased
302    */
303   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
304   event ICOStarted(uint256 startTime, uint256 endTime);
305   function EtheeraCrowdsale(uint256 _startTime, address _wallet) public {
306 
307     startTime = _startTime;
308     endTime = startTime.add(79 days);
309 
310     require(endTime >= startTime);
311     require(_wallet != 0x0);
312 
313     wallet = _wallet;
314     token = createTokenContract(wallet);
315     
316     ICOStarted(startTime,endTime);
317 
318   }
319 
320   function createTokenContract(address wall) internal returns (EtheeraToken) {
321     return new EtheeraToken(wall);
322   }
323 
324   // fallback function can be used to buy tokens
325   function () public payable {
326     buyTokens(msg.sender);
327   }
328 
329   //determine the bonus with respect to time elapsed
330   function determineBonus(uint tokens) internal view returns (uint256 bonus) {
331     
332     uint256 timeElapsed = now - startTime;
333     uint256 timeElapsedInDays = timeElapsed.div(1 days);
334      
335     if (timeElapsedInDays <=35)
336     {
337         //early sale
338         //valid for 10-02-2018 to 16-03-2018 i.e. 0 to 35th days
339         //40% BONUS
340         bonus = tokens.mul(40);
341         bonus = bonus.div(100);
342        
343     }
344     else if (timeElapsedInDays>35 && timeElapsedInDays <=50)
345     {
346         //sale
347         //from 17.03.2018 - 31.03.2018 i.e. 35th to 50th days
348        
349         //20% bonus
350         bonus = tokens.mul(20);
351         bonus = bonus.div(100);
352         
353        
354     }
355     else if (timeElapsedInDays>50 && timeElapsedInDays <=64)
356     {
357         //sale
358         //from 01.04.2018 - 14.04.2018  i.e. 50th to 64th days
359        
360         //10% bonus
361         bonus = tokens.mul(10);
362         bonus = bonus.div(100);
363         
364        
365     }
366     else
367     {
368         //no bonuses 15.04.2018 - 30.04.2018 
369         bonus = 0;
370     }
371    
372   }
373 
374   // low level token purchase function
375   // Minimum purchase can be of 75 ETA tokens
376   
377   function buyTokens(address beneficiary) public payable {
378     
379   //tokens not to be sent to 0x0
380   require(beneficiary != 0x0);
381 
382   if(hasEnded() && !isHardCapReached)
383   {
384       if (!isSoftCapReached)
385         refundToBuyers = true;
386       burnRemainingTokens();
387       beneficiary.transfer(msg.value);
388   }
389   
390   else
391   {
392     //the purchase should be within duration and non zero
393     require(validPurchase());
394     
395     // amount sent by the user
396     uint256 weiAmount = msg.value;
397     
398     // calculate token amount to be sold
399     uint256 tokens = weiAmount.mul(ratePerWei);
400   
401     require (tokens>=75 * 10 ** 18);
402     
403     //Determine bonus
404     uint bonus = determineBonus(tokens);
405     tokens = tokens.add(bonus);
406   
407     //can't sale tokens more than 52500000000 tokens
408     require(tokens_sold + tokens <= maxTokensForSale * 10 ** 18);
409   
410     //30% of the tokens being sold are being accumulated for the etheera team
411     updateTokensForEtheeraTeam(tokens);
412 
413     weiRaised = weiRaised.add(weiAmount);
414     
415     
416     if (weiRaised >= softCap * 10 ** 18 && !isSoftCapReached)
417     {
418       isSoftCapReached = true;
419     }
420   
421     if (weiRaised >= hardCap * 10 ** 18 && !isHardCapReached)
422       isHardCapReached = true;
423     
424     token.mint(wallet, beneficiary, tokens);
425     
426     uint olderAmount = usersThatBoughtETA[beneficiary];
427     usersThatBoughtETA[beneficiary] = weiAmount + olderAmount;
428     
429     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
430     
431     tokens_sold = tokens_sold.add(tokens);
432     forwardFunds();
433   }
434  }
435 
436   // send ether to the fund collection wallet
437   function forwardFunds() internal {
438     wallet.transfer(msg.value);
439   }
440 
441   // @return true if the transaction can buy tokens
442   function validPurchase() internal constant returns (bool) {
443     bool withinPeriod = now >= startTime && now <= endTime;
444     bool nonZeroPurchase = msg.value != 0;
445     return withinPeriod && nonZeroPurchase;
446   }
447 
448   // @return true if crowdsale event has ended
449   function hasEnded() public constant returns (bool) {
450     return now > endTime;
451   }
452     
453     function burnRemainingTokens() internal
454     {
455         //burn all the unsold tokens as soon as the ICO is ended
456         uint balance = token.balanceOf(wallet);
457         require(balance>0);
458         uint tokensForTeam = tokensForReservedFund + tokensForFoundersAndTeam + tokensForAdvisors +tokensForMarketing + tokensForTournament;
459         uint tokensToBurn = balance.sub(tokensForTeam);
460         require (balance >=tokensToBurn);
461         address burnAddress = 0x0;
462         token.mint(wallet,burnAddress,tokensToBurn);
463     }
464     
465     function getRefund() public 
466     {
467         require(ethersSentForRefund && usersThatBoughtETA[msg.sender]>0);
468         uint256 ethersSent = usersThatBoughtETA[msg.sender];
469         require (wallet.balance >= ethersSent);
470         msg.sender.transfer(ethersSent);
471         uint256 tokensIHave = token.balanceOf(msg.sender);
472         token.mint(msg.sender,0x0,tokensIHave);
473     }
474     
475     function debitAmountToRefund() public payable 
476     {
477         require(hasEnded() && msg.sender == wallet && !isSoftCapReached && !ethersSentForRefund);
478         require(msg.value >=weiRaised);
479         ethersSentForRefund = true;
480     }
481     
482     function updateTokensForEtheeraTeam(uint256 tokens) internal 
483     {
484         uint256 reservedFundTokens;
485         uint256 foundersAndTeamTokens;
486         uint256 advisorsTokens;
487         uint256 marketingTokens;
488         uint256 tournamentTokens;
489         
490         //10% of tokens for reserved fund
491         reservedFundTokens = tokens.mul(10);
492         reservedFundTokens = reservedFundTokens.div(100);
493         tokensForReservedFund = tokensForReservedFund.add(reservedFundTokens);
494     
495         //15% of tokens for founders and team    
496         foundersAndTeamTokens=tokens.mul(15);
497         foundersAndTeamTokens= foundersAndTeamTokens.div(100);
498         tokensForFoundersAndTeam = tokensForFoundersAndTeam.add(foundersAndTeamTokens);
499     
500         //3% of tokens for advisors
501         advisorsTokens=tokens.mul(3);
502         advisorsTokens= advisorsTokens.div(100);
503         tokensForAdvisors= tokensForAdvisors.add(advisorsTokens);
504     
505         //1% of tokens for marketing
506         marketingTokens = tokens.mul(1);
507         marketingTokens= marketingTokens.div(100);
508         tokensForMarketing= tokensForMarketing.add(marketingTokens);
509         
510         //1% of tokens for tournament 
511         tournamentTokens=tokens.mul(1);
512         tournamentTokens= tournamentTokens.div(100);
513         tokensForTournament= tokensForTournament.add(tournamentTokens);
514     }
515     
516     function withdrawTokensForEtheeraTeam(uint256 whoseTokensToWithdraw,address[] whereToSendTokens) public {
517         //1 reserved fund, 2 for founders and team, 3 for advisors, 4 for marketing, 5 for tournament
518         require(msg.sender == wallet && now>=endTime);
519         uint256 lockPeriod = 0;
520         uint256 timePassed = now - endTime;
521         uint256 tokensToSend = 0;
522         uint256 i = 0;
523         if (whoseTokensToWithdraw == 1)
524         {
525           //15 months lockup period
526           lockPeriod = 15 days * 30;
527           require(timePassed >= lockPeriod);
528           require (tokensForReservedFund >0);
529           //allow withdrawal
530           tokensToSend = tokensForReservedFund.div(whereToSendTokens.length);
531                 
532           for (i=0;i<whereToSendTokens.length;i++)
533           {
534             token.mint(wallet,whereToSendTokens[i],tokensToSend);
535           }
536           tokensForReservedFund = 0;
537         }
538         else if (whoseTokensToWithdraw == 2)
539         {
540           //10 months lockup period
541           lockPeriod = 10 days * 30;
542           require(timePassed >= lockPeriod);
543           require(tokensForFoundersAndTeam > 0);
544           //allow withdrawal
545           tokensToSend = tokensForFoundersAndTeam.div(whereToSendTokens.length);
546                 
547           for (i=0;i<whereToSendTokens.length;i++)
548           {
549             token.mint(wallet,whereToSendTokens[i],tokensToSend);
550           }            
551           tokensForFoundersAndTeam = 0;
552         }
553         else if (whoseTokensToWithdraw == 3)
554         {
555             require (tokensForAdvisors > 0);
556           //allow withdrawal
557           tokensToSend = tokensForAdvisors.div(whereToSendTokens.length);        
558           for (i=0;i<whereToSendTokens.length;i++)
559           {
560             token.mint(wallet,whereToSendTokens[i],tokensToSend);
561           }
562           tokensForAdvisors = 0;
563         }
564         else if (whoseTokensToWithdraw == 4)
565         {
566             require (tokensForMarketing > 0);
567           //allow withdrawal
568           tokensToSend = tokensForMarketing.div(whereToSendTokens.length);
569                 
570           for (i=0;i<whereToSendTokens.length;i++)
571           {
572             token.mint(wallet,whereToSendTokens[i],tokensToSend);
573           }
574           tokensForMarketing = 0;
575         }
576         else if (whoseTokensToWithdraw == 5)
577         {
578             require (tokensForTournament > 0);
579           //allow withdrawal
580           tokensToSend = tokensForTournament.div(whereToSendTokens.length);
581                 
582           for (i=0;i<whereToSendTokens.length;i++)
583           {
584             token.mint(wallet,whereToSendTokens[i],tokensToSend);
585           }
586           tokensForTournament = 0;
587         }
588         else 
589         {
590           //wrong input
591           require (1!=1);
592         }
593     }
594 }