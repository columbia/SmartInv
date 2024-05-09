1 pragma solidity ^0.4.13;
2 library SafeMath {    
3   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4     uint256 c = a * b;
5     assert(a == 0 || c / a == b);
6     return c;
7   }
8   function div(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a / b;
10     return c;
11   } 
12   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13     assert(b <= a);
14     return a - b;
15   } 
16   function add(uint256 a, uint256 b) internal pure returns (uint256) {
17     uint256 c = a + b;
18     assert(c >= a);
19     return c;
20   }  
21 }
22 
23 contract ERC20Basic {
24   uint256 public totalSupply;
25   function balanceOf(address who) public constant returns (uint256);
26   function transfer(address to, uint256 value) public returns (bool);
27   event Transfer(address indexed from, address indexed to, uint256 value);
28 }
29 
30 contract ERC20 is ERC20Basic {
31   function allowance(address owner, address spender) public constant returns (uint256);
32   function transferFrom(address from, address to, uint256 value) public returns (bool);
33   function approve(address spender, uint256 value) public returns (bool);
34   event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 contract BasicToken is ERC20Basic {
38   
39   using SafeMath for uint256;
40   bool public teamStakesFrozen = true;
41   mapping(address => uint256) balances;
42   address public owner;
43   
44   function BasicToken() public {
45     owner = msg.sender;
46   }
47   
48   modifier notFrozen() {
49     require(msg.sender != owner || (msg.sender == owner && !teamStakesFrozen));
50     _;
51   }
52 
53   /**
54   * @dev transfer token for a specified address
55   * @param _to The address to transfer to.
56   * @param _value The amount to be transferred.
57   */
58   function transfer(address _to, uint256 _value) public notFrozen returns (bool) {
59     require(_to != address(0));
60     require(_value <= balances[msg.sender]);
61     // SafeMath.sub will throw if there is not enough balance.
62     balances[msg.sender] = balances[msg.sender].sub(_value);
63     balances[_to] = balances[_to].add(_value);
64     Transfer(msg.sender, _to, _value);
65     return true;
66   }
67 
68   /**
69   * @dev Gets the balance of the specified address.
70   * @param _owner The address to query the the balance of.
71   * @return An uint256 representing the amount owned by the passed address.
72   */
73   function balanceOf(address _owner) public constant returns (uint256 balance) {
74     return balances[_owner];
75   }
76 }
77 
78 contract StandardToken is ERC20, BasicToken {
79   mapping (address => mapping (address => uint256)) internal allowed;
80   /**
81    * @dev Transfer tokens from one address to another
82    * @param _from address The address which you want to send tokens from
83    * @param _to address The address which you want to transfer to
84    * @param _value uint256 the amount of tokens to be transferred
85    */
86   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
87     require(_to != address(0));
88     require(_value <= balances[_from]);
89     require(_value <= allowed[_from][msg.sender]);
90     balances[_from] = balances[_from].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
93     Transfer(_from, _to, _value);
94     return true;
95   }
96 
97   /**
98    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
99    *
100    * Beware that changing an allowance with this method brings the risk that someone may use both the old
101    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
102    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
103    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
104    * @param _spender The address which will spend the funds.
105    * @param _value The amount of tokens to be spent.
106    */
107   function approve(address _spender, uint256 _value) public notFrozen returns (bool) {
108     allowed[msg.sender][_spender] = _value;
109     Approval(msg.sender, _spender, _value);
110     return true;
111   }
112 
113   /**
114    * @dev Function to check the amount of tokens that an owner allowed to a spender.
115    * @param _owner address The address which owns the funds.
116    * @param _spender address The address which will spend the funds.
117    * @return A uint256 specifying the amount of tokens still available for the spender.
118    */
119   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
120     return allowed[_owner][_spender];
121   }
122 
123   /**
124    * approve should be called when allowed[_spender] == 0. To increment
125    * allowed value is better to use this function to avoid 2 calls (and wait until
126    * the first transaction is mined)
127    * From MonolithDAO Token.sol
128    */
129   function increaseApproval (address _spender, uint _addedValue) public notFrozen returns (bool success) {
130     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
131     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
132     return true;
133   }
134 
135   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
136     uint oldValue = allowed[msg.sender][_spender];
137     if (_subtractedValue > oldValue) {
138       allowed[msg.sender][_spender] = 0;
139     } else {
140       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
141     }
142     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
143     return true;
144   }
145 }
146 
147 contract RI is StandardToken {
148   string public constant name = "Fundaria Stake";
149   string public constant symbol = "RI";
150   uint8 public constant decimals = 0;
151 }
152 
153 contract Sale is RI {
154 
155     using SafeMath for uint;
156 
157 /********** 
158  * Common *
159  **********/
160 
161     // THIS IS KEY VARIABLE AND DEFINED ACCORDING TO VALUE OF PLANNED COSTS ON THE PAGE https://business.fundaria.com
162     uint public poolCapUSD = 1002750;
163     // USD per 1 ether, added 10% aproximatelly to secure from wrong low price. We need add 10% of Stakes to supply to cover such price.
164     uint public usdPerEther = 360;
165     uint public supplyCap; // Current total supply cap according to lastStakePriceUSCents and poolCapUSD 
166     uint public businessPlannedPeriodDuration = 365 days; // total period planned for business activity
167     uint public businessPlannedPeriodEndTimestamp;
168     uint public teamCap; // team Stakes capacity
169     uint8 public teamShare = 45; // share for team
170     uint public distributedTeamStakes; // distributed Stakes to team   
171     uint public contractCreatedTimestamp; // when this contract was created  
172     address public pool = 0x335C415D7897B2cb2a2562079400Fb6eDf54a7ab; // initial pool wallet address    
173 
174 /********** 
175  * Bounty *
176  **********/
177  
178     uint public distributedBountyStakes; // bounty advisors Stakes distributed total    
179     uint public bountyCap; // bounty advisors Stakes capacity    
180     uint8 public bountyShare = 7; // share for bounty    
181     
182 /*********** 
183  * Sale *
184  ***********/
185     // data to store invested wei value & Stakes for Investor
186     struct saleData {
187       uint stakes; // how many Stakes where recieved by this Investor total
188       uint invested; // how much wei this Investor invested total
189       uint bonusStakes; // how many bonus Stakes where recieved by this Investor
190       uint guideReward; // Investment Guide reward amount
191       address guide; // address of Investment Guide
192     }
193     mapping (address=>saleData) public saleStat; // invested value + Stakes data for every Investor        
194     uint public saleStartTimestamp = 1511546400; // 1511546400 regular Stakes sale start date            
195     uint public saleEndTimestamp = 1513965600; // 1513965600
196     uint public distributedSaleStakes; // distributed stakes to all Investors
197     uint public totalInvested; //how many invested total
198     uint public totalWithdrawn; //how many withdrawn total
199     uint public saleCap; // regular sale Stakes capacity   
200     uint8 public saleShare = 45; // share for regular sale
201     uint public lastStakePriceUSCents; // Stake price in U.S. cents is determined according to current timestamp (the further - the higher price)    
202     uint[] public targetPrice;    
203     bool public priceIsFrozen = false; // stop increasing the price temporary (in case of low demand. Can be called only after saleEndTimestamp)       
204     
205 /************************************ 
206  * Bonus Stakes & Investment Guides *
207  ************************************/    
208     // data to store Investment Guide reward
209     struct guideData {
210       bool registered; // is this Investment Guide registered
211       uint accumulatedPotentialReward; // how many reward wei are potentially available
212       uint withdrawnReward; // how much reward wei where withdrawn by this Investment Guide already
213     }
214     mapping (address=>guideData) public guidesStat; // mapping of Investment Guides datas    
215     uint public bonusCap; // max amount of bonus Stakes availabe
216     uint public distributedBonusStakes; // how many bonus Stakes are already distributed
217     uint public bonusShare = 3; // share of bonus Stakes in supplyCap
218     uint8 public guideInvestmentAttractedShareToPay = 10; // reward for the Investment Guide
219 
220 /*
221   WANT TO EARN ON STAKES SALE ?
222   BECOME INVESTMENT GUIDE AND RECIEVE 10% OF ATTRACTED INVESTMENT !
223   INTRODUCE YOURSELF ON FUNDARIA.COM@GMAIL.COM & GIVE YOUR WALLET ADDRESS
224 */
225     
226 /************* 
227  * Promotion *
228  *************/
229     
230     uint public maxAmountForSalePromotion = 30 ether; // How many we can use for promotion of sale
231     uint public withdrawnAmountForSalePromotion;    
232 
233 /********************************************* 
234  * To Pool transfers & Investment withdrawal *
235  *********************************************/
236 
237     uint8 public financePeriodsCount = 12; // How many finance periods in planned period
238     uint[] public financePeriodsTimestamps; // Supportive array for searching current finance period
239     uint public transferedToPool; // how much wei transfered to pool already
240 
241 /* EVENTS */
242 
243     event StakesSale(address to, uint weiInvested, uint stakesRecieved, uint teamStakesRecieved, uint stake_price_us_cents);
244     event BountyDistributed(address to, uint bountyStakes);
245     event TransferedToPool(uint weiAmount, uint8 currentFinancialPeriodNo);
246     event InvestmentWithdrawn(address to, uint withdrawnWeiAmount, uint stakesBurned, uint8 remainedFullFinancialPeriods);
247     event UsdPerEtherChanged(uint oldUsdPerEther, uint newUsdPerEther);
248     event BonusDistributed(address to, uint bonusStakes, address guide, uint accumulatedPotentialReward);
249     event PoolCapChanged(uint oldCapUSD, uint newCapUSD);
250     event RegisterGuide(address investmentGuide);
251     event TargetPriceChanged(uint8 N, uint oldTargetPrice, uint newTargetPrice);
252     
253     modifier onlyOwner() {
254       require(msg.sender==owner);
255       _;
256     }
257   /**
258    * @dev Determine duration of finance period, fill array with finance periods timestamps,
259    *      set businessPlannedPeriodEndTimestamp and contractCreatedTimestamp,    
260    */      
261     function Sale() public {     
262       uint financePeriodDuration = businessPlannedPeriodDuration/financePeriodsCount; // quantity of seconds in chosen finance period
263       // making array with timestamps of every finance period end date
264       for(uint8 i=0; i<financePeriodsCount; i++) {
265         financePeriodsTimestamps.push(saleEndTimestamp+financePeriodDuration*(i+1));  
266       }
267       businessPlannedPeriodEndTimestamp = saleEndTimestamp+businessPlannedPeriodDuration; 
268       contractCreatedTimestamp = now;
269       targetPrice.push(1); // Initial Stake price mark in U.S. cents (1 cent = $0.01)  
270       targetPrice.push(10); // price mark at the sale period start timestamp      
271       targetPrice.push(100); // price mark at the sale period end timestamp       
272       targetPrice.push(1000); // price mark at hte end of business planned period          
273     }
274   /**
275    * @dev How many investment remained? Maximum investment is poolCapUSD
276    * @return remainingInvestment in wei   
277    */     
278     function remainingInvestment() public view returns(uint) {
279       return poolCapUSD.div(usdPerEther).mul(1 ether).sub(totalInvested);  
280     }
281   /**
282    * @dev Dynamically set caps
283    */       
284     function setCaps() internal {
285       // remaining Stakes are determined only from remainingInvestment
286       saleCap = distributedSaleStakes+stakeForWei(remainingInvestment()); // max available Stakes for sale including already distributed
287       supplyCap = saleCap.mul(100).div(saleShare); // max available Stakes for supplying
288       teamCap = supplyCap.mul(teamShare).div(100); // max available team Stakes
289       bonusCap = supplyCap.mul(bonusShare).div(100); // max available Stakes for bonus
290       bountyCap = supplyCap.sub(saleCap).sub(teamCap).sub(bonusCap); // max available Stakes for bounty        
291     }
292   /**
293    * @dev Dynamically set the price of Stake in USD cents, which depends on current timestamp (price grows with time)
294    */       
295     function setStakePriceUSCents() internal {
296         uint targetPriceFrom;
297         uint targetPriceTo;
298         uint startTimestamp;
299         uint endTimestamp;
300       // set price for pre sale period      
301       if(now < saleStartTimestamp) {
302         targetPriceFrom = targetPrice[0];
303         targetPriceTo = targetPrice[1];
304         startTimestamp = contractCreatedTimestamp;
305         endTimestamp = saleStartTimestamp;        
306       // set price for sale period
307       } else if(now >= saleStartTimestamp && now < saleEndTimestamp) {
308         targetPriceFrom = targetPrice[1];
309         targetPriceTo = targetPrice[2];
310         startTimestamp = saleStartTimestamp;
311         endTimestamp = saleEndTimestamp;    
312       // set price for post sale period
313       } else if(now >= saleEndTimestamp && now < businessPlannedPeriodEndTimestamp) {
314         targetPriceFrom = targetPrice[2];
315         targetPriceTo = targetPrice[3];
316         startTimestamp = saleEndTimestamp;
317         endTimestamp = businessPlannedPeriodEndTimestamp;    
318       }     
319       lastStakePriceUSCents = targetPriceFrom + ((now-startTimestamp)*(targetPriceTo-targetPriceFrom))/(endTimestamp-startTimestamp);       
320     }  
321   /**
322    * @dev Recieve wei and process Stakes sale
323    */    
324     function() payable public {
325       require(msg.sender != address(0));
326       require(msg.value > 0); // process only requests with wei
327       require(now < businessPlannedPeriodEndTimestamp); // no later then at the end of planned period
328       processSale();       
329     }
330   /**
331    * @dev Process Stakes sale
332    */       
333     function processSale() internal {
334       if(!priceIsFrozen) { // refresh price only if price is not frozen
335         setStakePriceUSCents();
336       }
337       setCaps();    
338 
339         uint teamStakes; // Stakes for the team according to teamShare
340         uint saleStakes; // Stakes for the Sale
341         uint weiInvested; // weiInvested now by this Investor
342         uint trySaleStakes = stakeForWei(msg.value); // try to get this quantity of Stakes
343 
344       if(trySaleStakes > 1) {
345         uint tryDistribute = distributedSaleStakes+trySaleStakes; // try to distribute this tryStakes        
346         if(tryDistribute <= saleCap) { // saleCap not reached
347           saleStakes = trySaleStakes; // all tryStakes can be sold
348           weiInvested = msg.value; // all current wei are accepted                    
349         } else {
350           saleStakes = saleCap-distributedSaleStakes; // only remnant of Stakes are available
351           weiInvested = weiForStake(saleStakes); // wei for available remnant of Stakes 
352         }
353         teamStakes = (saleStakes*teamShare).div(saleShare); // part of Stakes for a team        
354         if(saleStakes > 0) {          
355           balances[owner] += teamStakes; // rewarding team according to teamShare
356           totalSupply += teamStakes; // supplying team Stakes
357           distributedTeamStakes += teamStakes; // saving distributed team Stakes 
358           saleSupply(msg.sender, saleStakes, weiInvested, teamStakes); // process saleSupply
359           if(saleStat[msg.sender].guide != address(0)) { // we have Investment Guide to reward and distribute bonus Stakes
360             distributeBonusStakes(msg.sender, saleStakes, weiInvested);  
361           }          
362         }        
363         if(tryDistribute > saleCap) {
364           msg.sender.transfer(msg.value-weiInvested); // return remnant
365         }        
366       } else {
367         msg.sender.transfer(msg.value); // return incorrect wei
368       }
369     }
370   /**
371    * @dev Transfer Stakes from owner balance to buyer balance & saving data to saleStat storage
372    * @param _to is address of buyer 
373    * @param _stakes is quantity of Stakes transfered 
374    * @param _wei is value invested        
375    */ 
376     function saleSupply(address _to, uint _stakes, uint _wei, uint team_stakes) internal {
377       require(_stakes > 0);   
378       balances[_to] = balances[_to].add(_stakes); // to
379       totalSupply = totalSupply.add(_stakes);
380       distributedSaleStakes = distributedSaleStakes.add(_stakes);
381       totalInvested = totalInvested.add(_wei); // adding to total investment
382       // saving stat
383       saleStat[_to].stakes = saleStat[_to].stakes.add(_stakes); // stating Stakes bought       
384       saleStat[_to].invested = saleStat[_to].invested.add(_wei); // stating wei invested
385       StakesSale(_to, _wei, _stakes, team_stakes, lastStakePriceUSCents);
386     }      
387   /**
388    * @dev Set new owner
389    * @param new_owner new owner  
390    */    
391     function setNewOwner(address new_owner) public onlyOwner {
392       owner = new_owner; 
393     }
394   /**
395    * @dev Set new ether price in USD. Should be changed when price grow-fall 5%-10%
396    * @param new_usd_per_ether new price  
397    */    
398     function setUsdPerEther(uint new_usd_per_ether) public onlyOwner {
399       UsdPerEtherChanged(usdPerEther, new_usd_per_ether);
400       usdPerEther = new_usd_per_ether; 
401     }
402   /**
403    * @dev Set address of wallet where investment will be transfered for further using in business transactions
404    * @param _pool new address of the Pool   
405    */         
406     function setPoolAddress(address _pool) public onlyOwner {
407       pool = _pool;  
408     }
409   /**
410    * @dev Change Pool capacity in USD
411    * @param new_pool_cap_usd new Pool cap in $   
412    */    
413     function setPoolCapUSD(uint new_pool_cap_usd) public onlyOwner {
414       PoolCapChanged(poolCapUSD, new_pool_cap_usd);
415       poolCapUSD = new_pool_cap_usd; 
416     }
417   /**
418    * @dev Register Investment Guide
419    * @param investment_guide address of Investment Guide   
420    */     
421     function registerGuide(address investment_guide) public onlyOwner {
422       guidesStat[investment_guide].registered = true;
423       RegisterGuide(investment_guide);
424     }
425   /**
426    * @dev Stop increasing price dynamically. Set it as static temporary. 
427    */   
428     function freezePrice() public onlyOwner {
429       priceIsFrozen = true; 
430     }
431   /**
432    * @dev Continue increasing price dynamically (the standard, usual algorithm).
433    */       
434     function unfreezePrice() public onlyOwner {
435       priceIsFrozen = false; // this means that price is unfrozen  
436     }
437   /**
438    * @dev Ability to tune dynamic price changing with time.
439    */       
440     function setTargetPrice(uint8 n, uint stake_price_us_cents) public onlyOwner {
441       TargetPriceChanged(n, targetPrice[n], stake_price_us_cents);
442       targetPrice[n] = stake_price_us_cents;
443     }  
444   /**
445    * @dev Get and set address of Investment Guide and distribute bonus Stakes and Guide reward
446    * @param key address of Investment Guide   
447    */     
448     function getBonusStakesPermanently(address key) public {
449       require(guidesStat[key].registered);
450       require(saleStat[msg.sender].guide == address(0)); // Investment Guide is not applied yet for this Investor
451       saleStat[msg.sender].guide = key; // apply Guide 
452       if(saleStat[msg.sender].invested > 0) { // we have invested value, process distribution of bonus Stakes and rewarding a Guide     
453         distributeBonusStakes(msg.sender, saleStat[msg.sender].stakes, saleStat[msg.sender].invested);
454       }
455     }
456   /**
457    * @dev Distribute bonus Stakes to Investor according to bonusShare
458    * @param _to to which Investor to distribute
459    * @param added_stakes how many Stakes are added by this Investor    
460    * @param added_wei how much wei are invested by this Investor 
461    * @return wei quantity        
462    */       
463     function distributeBonusStakes(address _to, uint added_stakes, uint added_wei) internal {
464       uint added_bonus_stakes = (added_stakes*((bonusShare*100).div(saleShare)))/100; // how many bonus Stakes to add
465       require(distributedBonusStakes+added_bonus_stakes <= bonusCap); // check is bonus cap is not overflowed
466       uint added_potential_reward = (added_wei*guideInvestmentAttractedShareToPay)/100; // reward for the Guide
467       guidesStat[saleStat[_to].guide].accumulatedPotentialReward += added_potential_reward; // save reward for the Guide
468       saleStat[_to].guideReward += added_potential_reward; // add guideReward wei value for stat
469       saleStat[_to].bonusStakes += added_bonus_stakes; // add bonusStakes for stat    
470       balances[_to] += added_bonus_stakes; // transfer bonus Stakes
471       distributedBonusStakes += added_bonus_stakes; // save bonus Stakes distribution
472       totalSupply += added_bonus_stakes; // increase totalSupply
473       BonusDistributed(_to, added_bonus_stakes, saleStat[_to].guide, added_potential_reward);          
474     }
475   /**
476    * @dev Show how much wei can withdraw Investment Guide
477    * @param _guide address of registered guide 
478    * @return wei quantity        
479    */     
480     function guideRewardToWithdraw(address _guide) public view returns(uint) {
481       uint8 current_finance_period = 0;
482       for(uint8 i=0; i < financePeriodsCount; i++) {
483         current_finance_period = i+1;
484         if(now<financePeriodsTimestamps[i]) {          
485           break;
486         }
487       }
488       // reward to withdraw depends on current finance period and do not include potentially withdaw amount of investment
489       return (guidesStat[_guide].accumulatedPotentialReward*current_finance_period)/financePeriodsCount - guidesStat[_guide].withdrawnReward;  
490     }  
491   /**
492    * @dev Show share of Stakes on some address related to full supply capacity
493    * @param my_address my or someone address
494    * @return share of Stakes in % (floored to less number. If less then 1, null is showed)        
495    */      
496     function myStakesSharePercent(address my_address) public view returns(uint) {
497       return (balances[my_address]*100)/supplyCap;
498     }
499   
500   /*
501     weiForStake & stakeForWei functions sometimes show not correct translated value from dapp interface (view) 
502     because lastStakePriceUSCents sometimes temporary outdated (in view mode)
503     but it doesn't mean that execution itself is not correct  
504   */  
505   
506   /**
507    * @dev Translate wei to Stakes
508    * @param input_wei is wei to translate into stakes, 
509    * @return Stakes quantity        
510    */ 
511     function stakeForWei(uint input_wei) public view returns(uint) {
512       return ((input_wei*usdPerEther*100)/1 ether)/lastStakePriceUSCents;    
513     }  
514   /**
515    * @dev Translate Stakes to wei
516    * @param input_stake is stakes to translate into wei
517    * @return wei quantity        
518    */ 
519     function weiForStake(uint input_stake) public view returns(uint) {
520       return (input_stake*lastStakePriceUSCents*1 ether)/(usdPerEther*100);    
521     } 
522   /**
523    * @dev Transfer wei from this contract to pool wallet partially only, 
524    *      1) for funding promotion of Stakes sale   
525    *      2) according to share (finance_periods_last + current_finance_period) / business_planned_period
526    */    
527     function transferToPool() public onlyOwner {      
528       uint available; // available funds for transfering to pool    
529       uint amountToTransfer; // amount to transfer to pool
530       // promotional funds
531       if(now < saleEndTimestamp) {
532         require(withdrawnAmountForSalePromotion < maxAmountForSalePromotion); // withdrawn not maximum promotional funds
533         available = totalInvested/financePeriodsCount; // avaialbe only part of total value of total invested funds        
534         // current contract balance + witdrawn promo funds is less or equal to max promo funds
535         if(available+withdrawnAmountForSalePromotion <= maxAmountForSalePromotion) {
536           withdrawnAmountForSalePromotion += available;
537           transferedToPool += available;
538           amountToTransfer = available;         
539         } else {
540           // contract balance + witdrawn promo funds more then maximum promotional funds 
541           amountToTransfer = maxAmountForSalePromotion-withdrawnAmountForSalePromotion;
542           withdrawnAmountForSalePromotion = maxAmountForSalePromotion;
543           transferedToPool = maxAmountForSalePromotion;
544         }
545         pool.transfer(amountToTransfer);
546         TransferedToPool(amountToTransfer, 0);             
547       } else {
548         // search end timestamp of current financial period
549         for(uint8 i=0; i < financePeriodsCount; i++) {
550           // found end timestamp of current financial period OR now is later then business planned end date (transfer wei remnant)
551           if(now < financePeriodsTimestamps[i] || (i == financePeriodsCount-1 && now > financePeriodsTimestamps[i])) {   
552             available = ((i+1)*(totalInvested+totalWithdrawn))/financePeriodsCount; // avaialbe only part of total value of total invested funds
553             // not all available funds are transfered at the moment
554             if(available > transferedToPool) {
555               amountToTransfer = available-transferedToPool;
556               if(amountToTransfer > this.balance) {
557                 amountToTransfer = this.balance;  
558               }
559               transferedToPool += amountToTransfer;
560               pool.transfer(amountToTransfer);                           
561               TransferedToPool(amountToTransfer, i+1);
562             }
563             break;    
564           }
565         }
566       }      
567     }  
568   /**
569    * @dev Investor can withdraw part of his/her investment.
570    *      A size of this part depends on how many financial periods last and how many remained.
571    *      Investor gives back all stakes which he/she got for his/her investment.     
572    */       
573     function withdrawInvestment() public {
574       require(saleStat[msg.sender].stakes > 0);
575       require(balances[msg.sender] >= saleStat[msg.sender].stakes+saleStat[msg.sender].bonusStakes); // Investor has needed stakes to return
576       require(now > saleEndTimestamp); // do not able to withdraw investment before end of regular sale period
577       uint remained; // all investment which are available to withdraw by all Investors
578       uint to_withdraw; // available funds to withdraw for this particular Investor
579       for(uint8 i=0; i < financePeriodsCount-1; i++) {
580         if(now<financePeriodsTimestamps[i]) { // find end timestamp of current financial period          
581           remained = totalInvested - ((i+1)*totalInvested)/financePeriodsCount; // remained investment to withdraw by all Investors 
582           to_withdraw = (saleStat[msg.sender].invested*remained)/totalInvested; // investment to withdraw by this Investor
583           uint sale_stakes_to_burn = saleStat[msg.sender].stakes+saleStat[msg.sender].bonusStakes; // returning all Stakes saved in saleStat[msg.sender]
584           uint team_stakes_to_burn = (saleStat[msg.sender].stakes*teamShare)/saleShare; // team Stakes are also burned
585           balances[owner] = balances[owner].sub(team_stakes_to_burn); // burn appropriate team Stakes
586           distributedTeamStakes -= team_stakes_to_burn; // remove team Stakes from distribution         
587           balances[msg.sender] = balances[msg.sender].sub(sale_stakes_to_burn); // burn stakes got for invested wei
588           totalInvested = totalInvested.sub(to_withdraw); // decrease invested total value
589           totalSupply = totalSupply.sub(sale_stakes_to_burn).sub(team_stakes_to_burn); // totalSupply is decreased
590           distributedSaleStakes -= saleStat[msg.sender].stakes;
591           if(saleStat[msg.sender].guide != address(0)) { // we have Guide and bonusStakes
592             // potential reward for the Guide is decreased proportionally
593             guidesStat[saleStat[msg.sender].guide].accumulatedPotentialReward -= (saleStat[msg.sender].guideReward - ((i+1)*saleStat[msg.sender].guideReward)/financePeriodsCount); 
594             distributedBonusStakes -= saleStat[msg.sender].bonusStakes;
595             saleStat[msg.sender].bonusStakes = 0;
596             saleStat[msg.sender].guideReward = 0;          
597           }
598           saleStat[msg.sender].stakes = 0; // nullify Stakes recieved value          
599           saleStat[msg.sender].invested = 0; // nullify wei invested value
600           totalWithdrawn += to_withdraw;
601           msg.sender.transfer(to_withdraw); // witdraw investment
602           InvestmentWithdrawn(msg.sender, to_withdraw, sale_stakes_to_burn, financePeriodsCount-i-1);          
603           break;  
604         }
605       }      
606     }
607   /**
608    * @dev Distribute bounty rewards for bounty tasks
609    * @param _to is address of bounty hunter
610    * @param _stakes is quantity of Stakes transfered       
611    */     
612     function distributeBounty(address _to, uint _stakes) public onlyOwner {
613       require(distributedBountyStakes+_stakes <= bountyCap); // no more then maximum capacity can be distributed
614       balances[_to] = balances[_to].add(_stakes); // to
615       totalSupply += _stakes; 
616       distributedBountyStakes += _stakes; // adding to total bounty distributed
617       BountyDistributed(_to, _stakes);    
618     }  
619   /**
620    * @dev Unfreeze team Stakes. Only after excessed Stakes have burned.
621    */      
622     function unFreeze() public onlyOwner {
623       // only after planned period
624       if(now > businessPlannedPeriodEndTimestamp) {
625         teamStakesFrozen = false; // make team stakes available for transfering
626       }  
627     }
628 }