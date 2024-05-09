1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42 
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   constructor() public {
52     owner = msg.sender;
53   }
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) public onlyOwner {
68     require(newOwner != address(0));
69     emit OwnershipTransferred(owner, newOwner);
70     owner = newOwner;
71   }
72 
73 }
74 
75 interface TokenInterface {
76      function totalSupply() external constant returns (uint);
77      function balanceOf(address tokenOwner) external constant returns (uint balance);
78      function allowance(address tokenOwner, address spender) external constant returns (uint remaining);
79      function transfer(address to, uint tokens) external returns (bool success);
80      function approve(address spender, uint tokens) external returns (bool success);
81      function transferFrom(address from, address to, uint tokens) external returns (bool success);
82      function burn(uint256 _value) external; 
83      event Transfer(address indexed from, address indexed to, uint tokens);
84      event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
85      event Burn(address indexed burner, uint256 value);
86 }
87 
88  contract URUNCrowdsale is Ownable{
89   using SafeMath for uint256;
90  
91   // The token being sold
92   TokenInterface public token;
93 
94   // start and end timestamps where investments are allowed (both inclusive)
95   uint256 public startTime;
96   uint256 public endTime;
97 
98 
99   // how many token units a buyer gets per wei
100   uint256 public ratePerWei = 800;
101 
102   // amount of raised money in wei
103   uint256 public weiRaised;
104 
105   uint256 public TOKENS_SOLD;
106   uint256 public TOKENS_BOUGHT;
107   
108   uint256 public minimumContributionPhase1;
109   uint256 public minimumContributionPhase2;
110   uint256 public minimumContributionPhase3;
111   uint256 public minimumContributionPhase4;
112   uint256 public minimumContributionPhase5;
113   uint256 public minimumContributionPhase6;
114   
115   uint256 public maxTokensToSaleInClosedPreSale;
116   
117   uint256 public bonusInPhase1;
118   uint256 public bonusInPhase2;
119   uint256 public bonusInPhase3;
120   uint256 public bonusInPhase4;
121   uint256 public bonusInPhase5;
122   uint256 public bonusInPhase6;
123   
124   
125   bool public isCrowdsalePaused = false;
126   
127   uint256 public totalDurationInDays = 123 days;
128   
129   
130   struct userInformation {
131       address userAddress;
132       uint tokensToBeSent;
133       uint ethersToBeSent;
134       bool isKYCApproved;
135       bool recurringBuyer;
136   }
137   
138   event usersAwaitingTokens(address[] users);
139   mapping(address=>userInformation) usersBuyingInformation;
140   address[] allUsers;
141   address[] u;
142   userInformation info;
143   /**
144    * event for token purchase logging
145    * @param purchaser who paid for the tokens
146    * @param beneficiary who got the tokens
147    * @param value weis paid for purchase
148    * @param amount amount of tokens purchased
149    */
150    
151   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
152 
153   constructor(uint256 _startTime, address _wallet, address _tokenAddress) public 
154   {
155     require(_wallet != 0x0);
156     require(_startTime >=now);
157     startTime = _startTime;  
158     endTime = startTime + totalDurationInDays;
159     require(endTime >= startTime);
160    
161     owner = _wallet;
162     
163     bonusInPhase1 = 30;
164     bonusInPhase2 = 20;
165     bonusInPhase3 = 15;
166     bonusInPhase4 = 10;
167     bonusInPhase5 = 75;
168     bonusInPhase6 = 5;
169     
170     minimumContributionPhase1 = uint(3).mul(10 ** 17); //0.3 eth is the minimum contribution in presale phase 1
171     minimumContributionPhase2 = uint(5).mul(10 ** 16); //0.05 eth is the minimum contribution in presale phase 2
172     minimumContributionPhase3 = uint(5).mul(10 ** 16); //0.05 eth is the minimum contribution in presale phase 3
173     minimumContributionPhase4 = uint(5).mul(10 ** 16); //0.05 eth is the minimum contribution in presale phase 4
174     minimumContributionPhase5 = uint(5).mul(10 ** 16); //0.05 eth is the minimum contribution in presale phase 5
175     minimumContributionPhase6 = uint(5).mul(10 ** 16); //0.05 eth is the minimum contribution in presale phase 6
176     
177     token = TokenInterface(_tokenAddress);
178   }
179   
180   
181    // fallback function can be used to buy tokens
182    function () public  payable {
183      buyTokens(msg.sender);
184     }
185     
186     function determineBonus(uint tokens, uint ethersSent) internal view returns (uint256 bonus) 
187     {
188         uint256 timeElapsed = now - startTime;
189         uint256 timeElapsedInDays = timeElapsed.div(1 days);
190         
191         //phase 1 (16 days)
192         if (timeElapsedInDays <16)
193         {
194             require(ethersSent>=minimumContributionPhase1);
195             bonus = tokens.mul(bonusInPhase1); 
196             bonus = bonus.div(100);
197         }
198         //phase 2 (31 days)
199         else if (timeElapsedInDays >=16 && timeElapsedInDays <47)
200         {
201             require(ethersSent>=minimumContributionPhase2);
202             bonus = tokens.mul(bonusInPhase2); 
203             bonus = bonus.div(100);
204         }
205          //phase 3 (15 days)
206         else if (timeElapsedInDays >=47 && timeElapsedInDays <62)
207         {
208             require(ethersSent>=minimumContributionPhase3);
209             bonus = tokens.mul(bonusInPhase3); 
210             bonus = bonus.div(100);
211         }
212         //(16 days) -- break
213         else if (timeElapsedInDays >=62 && timeElapsedInDays <78)
214         {
215            revert();
216         }
217         //phase 5 (15 days) 
218         else if (timeElapsedInDays >=78 && timeElapsedInDays <93)
219         {
220             require(ethersSent>=minimumContributionPhase4);
221             bonus = tokens.mul(bonusInPhase4); 
222             bonus = bonus.div(100);
223         }
224         //phase 6 (15 days)
225         else if (timeElapsedInDays >=93 && timeElapsedInDays <108)
226         {
227             require(ethersSent>=minimumContributionPhase5);
228             bonus = tokens.mul(bonusInPhase5); 
229             bonus = bonus.div(10);  //to cater for the 7.5 figure
230             bonus = bonus.div(100);
231         }
232          //phase 7 (15 days) 
233         else if (timeElapsedInDays >=108 && timeElapsedInDays <123)
234         {
235             require(ethersSent>=minimumContributionPhase6);
236             bonus = tokens.mul(bonusInPhase6); 
237             bonus = bonus.div(100);
238         }
239         else 
240         {
241             bonus = 0;
242         }
243     }
244 
245   // low level token purchase function
246   
247   function buyTokens(address beneficiary) public payable {
248     require(beneficiary != 0x0);
249     require(isCrowdsalePaused == false);
250     require(validPurchase());
251     uint256 weiAmount = msg.value;
252     
253     // calculate token amount to be created
254     uint256 tokens = weiAmount.mul(ratePerWei);
255     uint256 bonus = determineBonus(tokens,weiAmount);
256     tokens = tokens.add(bonus);
257     
258     //if the user is first time buyer, add his entries
259     if (usersBuyingInformation[beneficiary].recurringBuyer == false)
260     {
261         info = userInformation ({ userAddress: beneficiary, tokensToBeSent:tokens, ethersToBeSent:weiAmount, isKYCApproved:false,
262                                 recurringBuyer:true});
263         usersBuyingInformation[beneficiary] = info;
264         allUsers.push(beneficiary);
265     }
266     //if the user is has bought with the same address before too, update his entries
267     else 
268     {
269         info = usersBuyingInformation[beneficiary];
270         info.tokensToBeSent = info.tokensToBeSent.add(tokens);
271         info.ethersToBeSent = info.ethersToBeSent.add(weiAmount);
272         usersBuyingInformation[beneficiary] = info;
273     }
274     TOKENS_BOUGHT = TOKENS_BOUGHT.add(tokens);
275     emit TokenPurchase(owner, beneficiary, weiAmount, tokens);
276     
277   }
278 
279   // @return true if the transaction can buy tokens
280   function validPurchase() internal constant returns (bool) {
281     bool withinPeriod = now >= startTime && now <= endTime;
282     bool nonZeroPurchase = msg.value != 0;
283     return withinPeriod && nonZeroPurchase;
284   }
285 
286   // @return true if crowdsale event has ended
287   function hasEnded() public constant returns (bool) {
288     return now > endTime;
289   }
290   
291     /**
292     * function to change the end time and start time of the ICO
293     * can only be called by owner wallet
294     **/
295     function changeStartAndEndDate (uint256 startTimeUnixTimestamp, uint256 endTimeUnixTimestamp) public onlyOwner
296     {
297         require (startTimeUnixTimestamp!=0 && endTimeUnixTimestamp!=0);
298         require(endTimeUnixTimestamp>startTimeUnixTimestamp);
299         require(endTimeUnixTimestamp.sub(startTimeUnixTimestamp) >=totalDurationInDays);
300         startTime = startTimeUnixTimestamp;
301         endTime = endTimeUnixTimestamp;
302     }
303     
304     /**
305     * function to change the rate of tokens
306     * can only be called by owner wallet
307     **/
308     function setPriceRate(uint256 newPrice) public onlyOwner {
309         ratePerWei = newPrice;
310     }
311     
312     /**
313      * function to pause the crowdsale 
314      * can only be called from owner wallet
315      **/
316     function pauseCrowdsale() public onlyOwner {
317         isCrowdsalePaused = true;
318     }
319 
320     /**
321      * function to resume the crowdsale if it is paused
322      * can only be called from owner wallet
323      **/ 
324     function resumeCrowdsale() public onlyOwner {
325         isCrowdsalePaused = false;
326     }
327     
328    
329      /**
330       * function through which owner can take back the tokens from the contract
331       **/ 
332      function takeTokensBack() public onlyOwner
333      {
334          uint remainingTokensInTheContract = token.balanceOf(address(this));
335          token.transfer(owner,remainingTokensInTheContract);
336      }
337      
338      /**
339       * function through which owner can transfer the tokens to any address
340       * use this which to properly display the tokens that have been sold via ether or other payments
341       **/ 
342      function manualTokenTransfer(address receiver, uint value) public onlyOwner
343      {
344          token.transfer(receiver,value);
345          TOKENS_SOLD = TOKENS_SOLD.add(value);
346          TOKENS_BOUGHT = TOKENS_BOUGHT.add(value);
347      }
348      
349      /**
350       * function to approve a single user which means the user has passed all KYC checks
351       * can only be called by the owner
352       **/ 
353      function approveSingleUser(address user) public onlyOwner {
354         usersBuyingInformation[user].isKYCApproved = true;    
355      }
356      
357      /**
358       * function to disapprove a single user which means the user has failed the KYC checks
359       * can only be called by the owner
360       **/
361      function disapproveSingleUser(address user) public onlyOwner {
362          usersBuyingInformation[user].isKYCApproved = false;  
363      }
364      
365      /**
366       * function to approve multiple users at once 
367       * can only be called by the owner
368       **/
369      function approveMultipleUsers(address[] users) public onlyOwner {
370          
371          for (uint i=0;i<users.length;i++)
372          {
373             usersBuyingInformation[users[i]].isKYCApproved = true;    
374          }
375      }
376      
377      /**
378       * function to distribute the tokens to approved users
379       * can only be called by the owner
380       **/
381      function distributeTokensToApprovedUsers() public onlyOwner {
382         for(uint i=0;i<allUsers.length;i++)
383         {
384             if (usersBuyingInformation[allUsers[i]].isKYCApproved == true && usersBuyingInformation[allUsers[i]].tokensToBeSent>0)
385             {
386                 address to = allUsers[i];
387                 uint tokens = usersBuyingInformation[to].tokensToBeSent;
388                 token.transfer(to,tokens);
389                 if (usersBuyingInformation[allUsers[i]].ethersToBeSent>0)
390                     owner.transfer(usersBuyingInformation[allUsers[i]].ethersToBeSent);
391                 TOKENS_SOLD = TOKENS_SOLD.add(usersBuyingInformation[allUsers[i]].tokensToBeSent);
392                 weiRaised = weiRaised.add(usersBuyingInformation[allUsers[i]].ethersToBeSent);
393                 usersBuyingInformation[allUsers[i]].tokensToBeSent = 0;
394                 usersBuyingInformation[allUsers[i]].ethersToBeSent = 0;
395             }
396         }
397      }
398      
399       /**
400       * function to distribute the tokens to all users whether approved or unapproved
401       * can only be called by the owner
402       **/
403      function distributeTokensToAllUsers() public onlyOwner {
404         for(uint i=0;i<allUsers.length;i++)
405         {
406             if (usersBuyingInformation[allUsers[i]].tokensToBeSent>0)
407             {
408                 address to = allUsers[i];
409                 uint tokens = usersBuyingInformation[to].tokensToBeSent;
410                 token.transfer(to,tokens);
411                 if (usersBuyingInformation[allUsers[i]].ethersToBeSent>0)
412                     owner.transfer(usersBuyingInformation[allUsers[i]].ethersToBeSent);
413                 TOKENS_SOLD = TOKENS_SOLD.add(usersBuyingInformation[allUsers[i]].tokensToBeSent);
414                 weiRaised = weiRaised.add(usersBuyingInformation[allUsers[i]].ethersToBeSent);
415                 usersBuyingInformation[allUsers[i]].tokensToBeSent = 0;
416                 usersBuyingInformation[allUsers[i]].ethersToBeSent = 0;
417             }
418         }
419      }
420      
421      /**
422       * function to refund a single user in case he hasnt passed the KYC checks
423       * can only be called by the owner
424       **/
425      function refundSingleUser(address user) public onlyOwner {
426          require(usersBuyingInformation[user].ethersToBeSent > 0 );
427          user.transfer(usersBuyingInformation[user].ethersToBeSent);
428          usersBuyingInformation[user].tokensToBeSent = 0;
429          usersBuyingInformation[user].ethersToBeSent = 0;
430      }
431      
432      /**
433       * function to refund to multiple users in case they havent passed the KYC checks
434       * can only be called by the owner
435       **/
436      function refundMultipleUsers(address[] users) public onlyOwner {
437          for (uint i=0;i<users.length;i++)
438          {
439             require(usersBuyingInformation[users[i]].ethersToBeSent >0);
440             users[i].transfer(usersBuyingInformation[users[i]].ethersToBeSent);
441             usersBuyingInformation[users[i]].tokensToBeSent = 0;
442             usersBuyingInformation[users[i]].ethersToBeSent = 0;
443          }
444      }
445      /**
446       * function to transfer out all ethers present in the contract
447       * after calling this function all refunds would need to be done manually
448       * would use this function as a last resort
449       * can only be called by owner wallet
450       **/ 
451      function transferOutAllEthers() public onlyOwner {
452          owner.transfer(address(this).balance);
453      }
454      
455      /**
456       * function to get the top 150 users who are awaiting the transfer of tokens
457       * can only be called by the owner
458       * this function would work in read mode
459       **/ 
460      function getUsersAwaitingForTokensTop150(bool fetch) public constant returns (address[150])  {
461           address[150] memory awaiting;
462          uint k = 0;
463          for (uint i=0;i<allUsers.length;i++)
464          {
465              if (usersBuyingInformation[allUsers[i]].isKYCApproved == true && usersBuyingInformation[allUsers[i]].tokensToBeSent>0)
466              {
467                  awaiting[k] = allUsers[i];
468                  k = k.add(1);
469                  if (k==150)
470                     return awaiting;
471              }
472          }
473          return awaiting;
474      }
475      
476      /**
477       * function to get the users who are awaiting the transfer of tokens
478       * can only be called by the owner
479       * this function would work in write mode
480       **/ 
481      function getUsersAwaitingForTokens() public onlyOwner returns (address[])  {
482          delete u;
483          for (uint i=0;i<allUsers.length;i++)
484          {
485              if (usersBuyingInformation[allUsers[i]].isKYCApproved == true && usersBuyingInformation[allUsers[i]].tokensToBeSent>0)
486              {
487                  u.push(allUsers[i]);
488              }
489          }
490          emit usersAwaitingTokens(u);
491          return u;
492      }
493      
494      /**
495       * function to return the information of a single user
496       **/ 
497      function getUserInfo(address userAddress) public constant returns(uint _ethers, uint _tokens, bool _isApproved)
498      {
499          _ethers = usersBuyingInformation[userAddress].ethersToBeSent;
500          _tokens = usersBuyingInformation[userAddress].tokensToBeSent;
501          _isApproved = usersBuyingInformation[userAddress].isKYCApproved;
502          return(_ethers,_tokens,_isApproved);
503          
504      }
505      
506      /**
507       * function to clear all payables/receivables of a user
508       * can only be called by owner 
509       **/
510       function closeUser(address userAddress) public onlyOwner 
511       {
512           //instead of deleting the user from the system we are just clearing the payables/receivables
513           //if this user buys again, his entry would be updated
514           uint ethersByTheUser =  usersBuyingInformation[userAddress].ethersToBeSent;
515           usersBuyingInformation[userAddress].isKYCApproved = false;
516           usersBuyingInformation[userAddress].ethersToBeSent = 0;
517           usersBuyingInformation[userAddress].tokensToBeSent = 0;
518           usersBuyingInformation[userAddress].recurringBuyer = true;
519           owner.transfer(ethersByTheUser);
520       } 
521       
522      /**
523       * function to get a list of top 150 users that are unapproved
524       * can only be called by owner
525       * this function would work in read mode
526       **/
527       function getUnapprovedUsersTop150(bool fetch) public constant returns (address[150]) 
528       {
529          address[150] memory unapprove;
530          uint k = 0;
531          for (uint i=0;i<allUsers.length;i++)
532          {
533              if (usersBuyingInformation[allUsers[i]].isKYCApproved == false)
534              {
535                  unapprove[k] = allUsers[i];
536                  k = k.add(1);
537                  if (k==150)
538                     return unapprove;
539              }
540          }
541          return unapprove;
542       } 
543       
544        /**
545       * function to get a list of all users that are unapproved
546       * can only be called by owner
547       * this function would work in write mode
548       **/
549       function getUnapprovedUsers() public onlyOwner returns (address[]) 
550       {
551          delete u;
552          for (uint i=0;i<allUsers.length;i++)
553          {
554              if (usersBuyingInformation[allUsers[i]].isKYCApproved == false)
555              {
556                  u.push(allUsers[i]);
557              }
558          }
559          emit usersAwaitingTokens(u);
560          return u;
561       } 
562       
563       /**
564       * function to return all the users
565       **/
566       function getAllUsers(bool fetch) public constant returns (address[]) 
567       {
568           return allUsers;
569       } 
570       
571       /**
572        * function to change the address of a user
573        * this function would be used in situations where user made the transaction from one wallet
574        * but wants to receive tokens in another wallet
575        * so owner should be able to update the address
576        **/ 
577       function changeUserEthAddress(address oldEthAddress, address newEthAddress) public onlyOwner 
578       {
579           usersBuyingInformation[newEthAddress] = usersBuyingInformation[oldEthAddress];
580           for (uint i=0;i<allUsers.length;i++)
581           {
582               if (allUsers[i] == oldEthAddress)
583                 allUsers[i] = newEthAddress;
584           }
585           delete usersBuyingInformation[oldEthAddress];
586       }
587       
588       /**
589        * Add a user that has paid with BTC or other payment methods
590        **/ 
591       function addUser(address userAddr, uint tokens) public onlyOwner 
592       {
593             // if first time buyer, add his details in the mapping
594             if (usersBuyingInformation[userAddr].recurringBuyer == false)
595             {
596                 info = userInformation ({ userAddress: userAddr, tokensToBeSent:tokens, ethersToBeSent:0, isKYCApproved:false,
597                                 recurringBuyer:true});
598                 usersBuyingInformation[userAddr] = info;
599                 allUsers.push(userAddr);
600             }
601             //if recurring buyer, update his mappings
602             else 
603             {
604                 info = usersBuyingInformation[userAddr];
605                 info.tokensToBeSent = info.tokensToBeSent.add(tokens);
606                 usersBuyingInformation[userAddr] = info;
607             }
608             TOKENS_BOUGHT = TOKENS_BOUGHT.add(tokens);
609       }
610       
611       /**
612        * Set the tokens bought
613        **/ 
614       function setTokensBought(uint tokensBought) public onlyOwner 
615       {
616           TOKENS_BOUGHT = tokensBought;
617       }
618       
619       /**
620        * Returns the number of tokens who have been sold  
621        **/ 
622       function getTokensBought() public constant returns(uint) 
623       {
624           return TOKENS_BOUGHT;
625       }
626       
627 }