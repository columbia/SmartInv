1 pragma solidity ^0.4.18;
2 
3  
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11  function div(uint256 a, uint256 b) internal pure returns (uint256) {
12     assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint256 c = a / b;
14     assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract Ownable {
31   address public owner;
32 
33 
34   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
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
53 
54 
55   /**
56    * @dev Allows the current owner to transfer control of the contract to a newOwner.
57    * @param newOwner The address to transfer ownership to.
58    */
59   function transferOwnership(address newOwner) onlyOwner public {
60     require(newOwner != address(0));
61     OwnershipTransferred(owner, newOwner);
62     owner = newOwner;
63   }
64 
65 }
66 
67 contract ERC20Interface {
68      function totalSupply() public constant returns (uint);
69      function balanceOf(address tokenOwner) public constant returns (uint balance);
70      function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
71      function transfer(address to, uint tokens) public returns (bool success);
72      function approve(address spender, uint tokens) public returns (bool success);
73      function transferFrom(address from, address to, uint tokens) public returns (bool success);
74      event Transfer(address indexed from, address indexed to, uint tokens);
75      event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
76 }
77 
78 contract HypeRideToken is ERC20Interface,Ownable {
79 
80    using SafeMath for uint256;
81    
82    string public name;
83    string public symbol;
84    uint256 public decimals;
85 
86    uint256 public _totalSupply;
87    mapping(address => uint256) tokenBalances;
88    address ownerWallet;
89    // Owner of account approves the transfer of an amount to another account
90    mapping (address => mapping (address => uint256)) allowed;
91    
92    /**
93    * @dev Contructor that gives msg.sender all of existing tokens.
94    */
95     function HypeRideToken(address wallet) public {
96         owner = msg.sender;
97         ownerWallet = wallet;
98         name  = "HYPERIDE";
99         symbol = "HYPE";
100         decimals = 18;
101         _totalSupply = 150000000 * 10 ** uint(decimals);
102         tokenBalances[wallet] = _totalSupply;   //Since we divided the token into 10^18 parts
103     }
104     
105      // Get the token balance for account `tokenOwner`
106      function balanceOf(address tokenOwner) public constant returns (uint balance) {
107          return tokenBalances[tokenOwner];
108      }
109   
110      // Transfer the balance from owner's account to another account
111      function transfer(address to, uint tokens) public returns (bool success) {
112          require(to != address(0));
113          require(tokens <= tokenBalances[msg.sender]);
114          tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(tokens);
115          tokenBalances[to] = tokenBalances[to].add(tokens);
116          Transfer(msg.sender, to, tokens);
117          return true;
118      }
119   
120      /**
121    * @dev Transfer tokens from one address to another
122    * @param _from address The address which you want to send tokens from
123    * @param _to address The address which you want to transfer to
124    * @param _value uint256 the amount of tokens to be transferred
125    */
126   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
127     require(_to != address(0));
128     require(_value <= tokenBalances[_from]);
129     require(_value <= allowed[_from][msg.sender]);
130 
131     tokenBalances[_from] = tokenBalances[_from].sub(_value);
132     tokenBalances[_to] = tokenBalances[_to].add(_value);
133     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
134     Transfer(_from, _to, _value);
135     return true;
136   }
137   
138      /**
139    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
140    *
141    * @param _spender The address which will spend the funds.
142    * @param _value The amount of tokens to be spent.
143    */
144   function approve(address _spender, uint256 _value) public returns (bool) {
145     allowed[msg.sender][_spender] = _value;
146     Approval(msg.sender, _spender, _value);
147     return true;
148   }
149 
150      // ------------------------------------------------------------------------
151      // Total supply
152      // ------------------------------------------------------------------------
153      function totalSupply() public constant returns (uint) {
154          return _totalSupply  - tokenBalances[address(0)];
155      }
156      
157     
158      
159      // ------------------------------------------------------------------------
160      // Returns the amount of tokens approved by the owner that can be
161      // transferred to the spender's account
162      // ------------------------------------------------------------------------
163      function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
164          return allowed[tokenOwner][spender];
165      }
166      
167      /**
168    * @dev Increase the amount of tokens that an owner allowed to a spender.
169    *
170    * @param _spender The address which will spend the funds.
171    * @param _addedValue The amount of tokens to increase the allowance by.
172    */
173   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
174     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
175     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
176     return true;
177   }
178 
179   /**
180    * @dev Decrease the amount of tokens that an owner allowed to a spender.
181    *
182    * @param _spender The address which will spend the funds.
183    * @param _subtractedValue The amount of tokens to decrease the allowance by.
184    */
185   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
186     uint oldValue = allowed[msg.sender][_spender];
187     if (_subtractedValue > oldValue) {
188       allowed[msg.sender][_spender] = 0;
189     } else {
190       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
191     }
192     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
193     return true;
194   }
195 
196      
197      // ------------------------------------------------------------------------
198      // Don't accept ETH
199      // ------------------------------------------------------------------------
200      function () public payable {
201          revert();
202      }
203  
204  
205      // ------------------------------------------------------------------------
206      // Owner can transfer out any accidentally sent ERC20 tokens
207      // ------------------------------------------------------------------------
208      function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
209          return ERC20Interface(tokenAddress).transfer(owner, tokens);
210      }
211      
212      //only to be used by the ICO
213      
214      function mint(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {
215       require(tokenBalances[wallet] >= tokenAmount);               // checks if it has enough to sell
216       tokenBalances[buyer] = tokenBalances[buyer].add(tokenAmount);                  // adds the amount to buyer's balance
217       tokenBalances[wallet] = tokenBalances[wallet].sub(tokenAmount);                        // subtracts amount from seller's balance
218       Transfer(wallet, buyer, tokenAmount); 
219       _totalSupply = _totalSupply.sub(tokenAmount);
220     }
221 }
222 contract HypeRideCrowdsale {
223   using SafeMath for uint256;
224  
225   // The token being sold
226   HypeRideToken public token;
227 
228   // start and end timestamps where investments are allowed (both inclusive)
229   uint256 public startTime;
230   uint256 public endTime;
231 
232   // address where funds are collected
233   // address where tokens are deposited and from where we send tokens to buyers
234   address public wallet;
235 
236   // how many token units a buyer gets per wei
237   uint256 public ratePerWei = 1000;
238 
239   // amount of raised money in wei
240   uint256 public weiRaised;
241 
242   uint256 TOKENS_SOLD;
243   uint256 maxTokensToSale = 150000000 * 10 ** 18;
244   uint256 maxTokensToSaleInPreICOPhase =  7500000 * 10 ** 18;
245   uint256 maxTokensToSaleInICOPhase1 = 14250000 * 10 ** 18;
246   uint256 maxTokensToSaleInICOPhase2 = 20250000 * 10 ** 18;
247   uint256 maxTokensToSaleInICOPhase3 = 25750000 * 10 ** 18;
248   
249   bool isCrowdsalePaused = false;
250 
251   /**
252    * event for token purchase logging
253    * @param purchaser who paid for the tokens
254    * @param beneficiary who got the tokens
255    * @param value weis paid for purchase
256    * @param amount amount of tokens purchased
257    */
258   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
259 
260 
261   function HypeRideCrowdsale(uint256 _startTime, address _wallet) public 
262   {
263     startTime = _startTime;
264     endTime = startTime + 120 days;
265     
266     require(startTime >=now);
267     require(endTime >= startTime);
268     require(_wallet != 0x0);
269 
270     wallet = _wallet;
271     token = createTokenContract(wallet);
272   }
273   
274    // creates the token to be sold.
275   function createTokenContract(address wall) internal returns (HypeRideToken) {
276     return new HypeRideToken(wall);
277   }
278   // fallback function can be used to buy tokens
279   function () public payable {
280     buyTokens(msg.sender);
281   }
282    
283   // low level token purchase function
284   // Minimum purchase can be of 1 ETH
285   function determineBonus(uint tokens) internal view returns (uint256 bonus) 
286     {
287         uint256 timeElapsed = now - startTime;
288         uint256 timeElapsedInDays = timeElapsed.div(1 days);
289         if (timeElapsedInDays <30)
290         {
291             if (TOKENS_SOLD <maxTokensToSaleInPreICOPhase)
292             {
293                 bonus = tokens.mul(50); //50% bonus
294                 bonus = bonus.div(100);
295                 require (TOKENS_SOLD + tokens + bonus <= maxTokensToSaleInPreICOPhase);
296             }
297             else if (TOKENS_SOLD >= maxTokensToSaleInPreICOPhase && TOKENS_SOLD < maxTokensToSaleInICOPhase1)
298             {
299                 bonus = tokens.mul(35); //35% bonus
300                 bonus = bonus.div(100);
301                 require (TOKENS_SOLD + tokens + bonus <= maxTokensToSaleInICOPhase1);
302             }
303              else if (TOKENS_SOLD >= maxTokensToSaleInICOPhase1 && TOKENS_SOLD < maxTokensToSaleInICOPhase2)
304             {
305                 bonus = tokens.mul(20); //20% bonus
306                 bonus = bonus.div(100);
307                 require (TOKENS_SOLD + tokens + bonus <= maxTokensToSaleInICOPhase2);
308             }
309              else if (TOKENS_SOLD >= maxTokensToSaleInICOPhase2 && TOKENS_SOLD < maxTokensToSaleInICOPhase3)
310             {
311                 bonus = tokens.mul(10); //10% bonus
312                 bonus = bonus.div(100);
313                 require (TOKENS_SOLD + tokens + bonus <= maxTokensToSaleInICOPhase3);
314             }
315             else 
316             {
317                 bonus = 0;
318             }
319         }
320         else if (timeElapsedInDays >= 30 && timeElapsedInDays<60)   //ICO phase 1, 2 weeks
321         {
322             if (TOKENS_SOLD < maxTokensToSaleInICOPhase1)
323             {
324                 bonus = tokens.mul(35); //35% bonus
325                 bonus = bonus.div(100);
326                 require (TOKENS_SOLD + tokens + bonus <= maxTokensToSaleInICOPhase1);
327             }
328              else if (TOKENS_SOLD >= maxTokensToSaleInICOPhase1 && TOKENS_SOLD < maxTokensToSaleInICOPhase2)
329             {
330                 bonus = tokens.mul(20); //20% bonus
331                 bonus = bonus.div(100);
332                 require (TOKENS_SOLD + tokens + bonus <= maxTokensToSaleInICOPhase2);
333             }
334              else if (TOKENS_SOLD >= maxTokensToSaleInICOPhase2 && TOKENS_SOLD < maxTokensToSaleInICOPhase3)
335             {
336                 bonus = tokens.mul(10); //10% bonus
337                 bonus = bonus.div(100);
338                 require (TOKENS_SOLD + tokens + bonus <= maxTokensToSaleInICOPhase3);
339             }
340             else
341             {
342                 bonus = 0;
343             }
344         }
345         else if (timeElapsedInDays >= 60 && timeElapsedInDays<90)   //ICO phase 2, 2 weeks
346         {
347             if (TOKENS_SOLD < maxTokensToSaleInICOPhase2)
348             {
349                 bonus = tokens.mul(20); //20% bonus
350                 bonus = bonus.div(100);
351                 require (TOKENS_SOLD + tokens + bonus <= maxTokensToSaleInICOPhase2);
352             }
353              else if (TOKENS_SOLD >= maxTokensToSaleInICOPhase2 && TOKENS_SOLD < maxTokensToSaleInICOPhase3)
354             {
355                 bonus = tokens.mul(10); //10% bonus
356                 bonus = bonus.div(100);
357                 require (TOKENS_SOLD + tokens + bonus <= maxTokensToSaleInICOPhase3);
358             }
359             else
360             {
361                 bonus = 0;
362             }
363         }
364         else if (timeElapsedInDays >= 90 && timeElapsedInDays<120)   //ICO phase 3, 2 weeks
365         {
366             if (TOKENS_SOLD < maxTokensToSaleInICOPhase3)
367             {
368                 bonus = tokens.mul(10); //10% bonus
369                 bonus = bonus.div(100);
370                 require (TOKENS_SOLD + tokens + bonus <= maxTokensToSaleInICOPhase3);
371             }
372             else
373             {
374                 bonus = 0;
375             }
376         }
377         else 
378         {
379             bonus = 0;
380         }
381     }
382 
383   function buyTokens(address beneficiary) public payable {
384       
385     uint256 weiAmount;
386     uint256 tokens;
387     if (now <= endTime)
388     {
389         require(beneficiary != 0x0);
390         require(isCrowdsalePaused == false);
391         require(validPurchase());
392         require(TOKENS_SOLD<maxTokensToSale);
393         weiAmount = msg.value;
394     
395         // calculate token amount to be created
396     
397         tokens = weiAmount.mul(ratePerWei);
398         uint256 bonus = determineBonus(tokens);
399         tokens = tokens.add(bonus);
400         require(TOKENS_SOLD+tokens<=maxTokensToSale);
401     
402         // update state
403         weiRaised = weiRaised.add(weiAmount);
404 
405         token.mint(wallet, beneficiary, tokens); 
406         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
407         TOKENS_SOLD = TOKENS_SOLD.add(tokens);
408         forwardFunds();
409     }
410     else if (now > endTime && now <= endTime + 365 days)
411     {
412         require(beneficiary != 0x0);
413         require(isCrowdsalePaused == false);
414         require(msg.value > 0);
415         require(TOKENS_SOLD<maxTokensToSale);
416         weiAmount = msg.value;
417     
418         // calculate token amount to be created
419     
420         tokens = weiAmount.mul(ratePerWei);
421         require(TOKENS_SOLD+tokens<=maxTokensToSale);
422     
423         // update state
424         weiRaised = weiRaised.add(weiAmount);
425 
426         token.mint(wallet, beneficiary, tokens); 
427         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
428         TOKENS_SOLD = TOKENS_SOLD.add(tokens);
429         forwardFunds();
430     }
431   }
432 
433   // send ether to the fund collection wallet
434   // override to create custom fund forwarding mechanisms
435   function forwardFunds() internal {
436     wallet.transfer(msg.value);
437   }
438 
439   // @return true if the transaction can buy tokens
440   function validPurchase() internal constant returns (bool) {
441     bool withinPeriod = now >= startTime && now <= endTime;
442     bool nonZeroPurchase = msg.value != 0;
443     return withinPeriod && nonZeroPurchase;
444   }
445 
446   // @return true if crowdsale event has ended
447   function hasEnded() public constant returns (bool) {
448     return now > endTime;
449   }
450   
451     /**
452      * function to change the end date & time
453      * can only be called from owner wallet
454      **/
455         
456     function changeEndDate(uint256 endTimeUnixTimestamp) public returns(bool) {
457         require (msg.sender == wallet);
458         endTime = endTimeUnixTimestamp;
459     }
460     
461     /**
462      * function to change the start date & time
463      * can only be called from owner wallet
464      **/
465      
466     function changeStartDate(uint256 startTimeUnixTimestamp) public returns(bool) {
467         require (msg.sender == wallet);
468         startTime = startTimeUnixTimestamp;
469     }
470     
471     /**
472      * function to change the price rate 
473      * can only be called from owner wallet
474      **/
475      
476     function setPriceRate(uint256 newPrice) public returns (bool) {
477         require (msg.sender == wallet);
478         ratePerWei = newPrice;
479     }
480     
481     /**
482      * function to enable token sales post ICO
483      * can only be called from owner wallet
484      **/
485      
486     function circulateTokensForSale(uint256 tokenAmount) public returns (bool) {
487         require (msg.sender == wallet);
488         tokenAmount = tokenAmount * 10 ** 18;
489         maxTokensToSale = maxTokensToSale + tokenAmount;
490     }
491     
492      /**
493      * function to pause the crowdsale 
494      * can only be called from owner wallet
495      **/
496      
497     function pauseCrowdsale() public returns(bool) {
498         require(msg.sender==wallet);
499         isCrowdsalePaused = true;
500     }
501 
502     /**
503      * function to resume the crowdsale if it is paused
504      * can only be called from owner wallet
505      * if the crowdsale has been stopped, this function would not resume it
506      **/ 
507     function resumeCrowdsale() public returns (bool) {
508         require(msg.sender==wallet);
509         isCrowdsalePaused = false;
510     }
511     
512      // ------------------------------------------------------------------------
513      // Remaining tokens for sale
514      // ------------------------------------------------------------------------
515      function remainingTokensForSale() public constant returns (uint) {
516          return maxTokensToSale - TOKENS_SOLD;
517      }
518      
519      function showMyTokenBalance() public constant returns (uint) {
520          return token.balanceOf(msg.sender);
521      }
522 }