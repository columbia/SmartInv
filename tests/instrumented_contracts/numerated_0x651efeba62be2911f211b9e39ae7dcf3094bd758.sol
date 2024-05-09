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
162     uint public poolCapUSD = 1002750; // 1002750 initially
163     // USD per 1 ether, added 10% aproximatelly to secure from wrong low price. We need add 10% of Stakes to supply to cover such price.
164     uint public usdPerEther = 350;
165     uint public supplyCap; // Current total supply cap according to lastStakePriceUSCents and poolCapUSD 
166     uint public businessPlannedPeriodDuration = 365 days; // total period planned for business activity 365 days
167     uint public businessPlannedPeriodEndTimestamp;
168     uint public teamCap; // team Stakes capacity
169     uint8 public teamShare = 45; // share for team
170     uint public distributedTeamStakes; // distributed Stakes to team   
171     uint public contractCreatedTimestamp; // when this contract was created  
172     address public pool = 0x1882464533072e9fCd8C6D3c5c5b588548B95296; // initial pool wallet address  
173     mapping (address=>bool) public rejectedInvestmentWithdrawals;
174     uint public allowedAmountToTransferToPool; // this amount is increased when investor rejects to withdraw his/her investment
175     uint public allowedAmountTransferedToPoolTotal; // sum of all allowedAmountToTransferToPool used 
176     uint public investmentGuidesRewardsWithdrawn; // total amount of rewards wei withdrawn by Guides  
177 
178 /********** 
179  * Bounty *
180  **********/
181  
182     uint public distributedBountyStakes; // bounty advisors Stakes distributed total    
183     uint public bountyCap; // bounty advisors Stakes capacity    
184     uint8 public bountyShare = 7; // share for bounty    
185     
186 /*********** 
187  * Sale *
188  ***********/
189     address supplier = 0x0000000000000000000000000000000000000000; // address of Stakes initial supplier (abstract)
190     // data to store invested wei value & Stakes for Investor
191     struct saleData {
192       uint stakes; // how many Stakes where recieved by this Investor total
193       uint invested; // how much wei this Investor invested total
194       uint bonusStakes; // how many bonus Stakes where recieved by this Investor
195       uint guideReward; // Investment Guide reward amount
196       address guide; // address of Investment Guide
197     }
198     mapping (address=>saleData) public saleStat; // invested value + Stakes data for every Investor        
199     uint public saleStartTimestamp = 1511373600; // regular Stakes sale start date            
200     uint public saleEndTimestamp = 1513965600; 
201     uint public distributedSaleStakes; // distributed stakes to all Investors
202     uint public totalInvested; //how many invested total
203     uint public totalWithdrawn; //how many withdrawn total
204     uint public saleCap; // regular sale Stakes capacity   
205     uint8 public saleShare = 45; // share for regular sale
206     uint public lastStakePriceUSCents; // Stake price in U.S. cents is determined according to current timestamp (the further - the higher price)    
207     uint[] public targetPrice;    
208     bool public priceIsFrozen = false; // stop increasing the price temporary (in case of low demand. Can be called only after saleEndTimestamp)       
209     
210 /************************************ 
211  * Bonus Stakes & Investment Guides *
212  ************************************/    
213     // data to store Investment Guide reward
214     struct guideData {
215       bool registered; // is this Investment Guide registered
216       uint accumulatedPotentialReward; // how many reward wei are potentially available
217       uint rewardToWithdraw; // availabe reward to withdraw now
218       uint periodicallyWithdrawnReward; // how much reward wei where withdrawn by this Investment Guide already
219     }
220     mapping (address=>guideData) public guidesStat; // mapping of Investment Guides datas    
221     uint public bonusCap; // max amount of bonus Stakes availabe
222     uint public distributedBonusStakes; // how many bonus Stakes are already distributed
223     uint public bonusShare = 3; // share of bonus Stakes in supplyCap
224     uint8 public guideInvestmentAttractedShareToPay = 10; // reward for the Investment Guide
225 
226 /*
227   WANT TO EARN ON STAKES SALE ?
228   BECOME INVESTMENT GUIDE AND RECIEVE 10% OF ATTRACTED INVESTMENT !
229   INTRODUCE YOURSELF ON FUNDARIA.COM@GMAIL.COM & GIVE YOUR WALLET ADDRESS
230 */    
231 
232 /********************************************* 
233  * To Pool transfers & Investment withdrawal *
234  *********************************************/
235 
236     uint8 public financePeriodsCount = 12; // How many finance periods in planned period
237     uint[] public financePeriodsTimestamps; // Supportive array for searching current finance period
238     uint public transferedToPool; // how much wei transfered to pool already
239 
240 /* EVENTS */
241 
242     event StakesSale(address to, uint weiInvested, uint stakesRecieved, uint teamStakesRecieved, uint stake_price_us_cents);
243     event BountyDistributed(address to, uint bountyStakes);
244     event TransferedToPool(uint weiAmount, uint8 currentFinancialPeriodNo);
245     event InvestmentWithdrawn(address to, uint withdrawnWeiAmount, uint stakesBurned, uint8 remainedFullFinancialPeriods);
246     event UsdPerEtherChanged(uint oldUsdPerEther, uint newUsdPerEther);
247     event BonusDistributed(address to, uint bonusStakes, address guide, uint accumulatedPotentialReward);
248     event PoolCapChanged(uint oldCapUSD, uint newCapUSD);
249     event RegisterGuide(address investmentGuide);
250     event TargetPriceChanged(uint8 N, uint oldTargetPrice, uint newTargetPrice);
251     event InvestmentGuideWithdrawReward(address investmentGuide, uint withdrawnRewardWei);
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
264       financePeriodsTimestamps.push(saleEndTimestamp); // first finance period is whole sale period
265       for(uint8 i=1; i<=financePeriodsCount; i++) {
266         financePeriodsTimestamps.push(saleEndTimestamp+financePeriodDuration*i);  
267       }
268       businessPlannedPeriodEndTimestamp = saleEndTimestamp+businessPlannedPeriodDuration; 
269       contractCreatedTimestamp = now;
270       targetPrice.push(1); // Initial Stake price mark in U.S. cents (1 cent = $0.01)  
271       targetPrice.push(10); // price mark at the sale period start timestamp      
272       targetPrice.push(100); // price mark at the sale period end timestamp       
273       targetPrice.push(1000); // price mark at hte end of business planned period
274       balances[supplier] = 0; // nullify Stakes formal supplier balance         
275     }
276   /**
277    * @dev How many investment remained? Maximum investment is poolCapUSD
278    * @return remainingInvestment in wei   
279    */     
280     function remainingInvestment() public view returns(uint) {
281       return poolCapUSD.div(usdPerEther).mul(1 ether).sub(totalInvested);  
282     }
283   /**
284    * @dev Dynamically set caps
285    */       
286     function setCaps() internal {
287       // remaining Stakes are determined only from remainingInvestment
288       saleCap = distributedSaleStakes+stakeForWei(remainingInvestment()); // max available Stakes for sale including already distributed
289       supplyCap = saleCap.mul(100).div(saleShare); // max available Stakes for supplying
290       teamCap = supplyCap.mul(teamShare).div(100); // max available team Stakes
291       bonusCap = supplyCap.mul(bonusShare).div(100); // max available Stakes for bonus
292       bountyCap = supplyCap.sub(saleCap).sub(teamCap).sub(bonusCap); // max available Stakes for bounty        
293     }
294   /**
295    * @dev Dynamically set the price of Stake in USD cents, which depends on current timestamp (price grows with time)
296    */       
297     function setStakePriceUSCents() internal {
298         uint targetPriceFrom;
299         uint targetPriceTo;
300         uint startTimestamp;
301         uint endTimestamp;
302       // set price for pre sale period      
303       if(now < saleStartTimestamp) {
304         targetPriceFrom = targetPrice[0];
305         targetPriceTo = targetPrice[1];
306         startTimestamp = contractCreatedTimestamp;
307         endTimestamp = saleStartTimestamp;        
308       // set price for sale period
309       } else if(now >= saleStartTimestamp && now < saleEndTimestamp) {
310         targetPriceFrom = targetPrice[1];
311         targetPriceTo = targetPrice[2];
312         startTimestamp = saleStartTimestamp;
313         endTimestamp = saleEndTimestamp;    
314       // set price for post sale period
315       } else if(now >= saleEndTimestamp && now < businessPlannedPeriodEndTimestamp) {
316         targetPriceFrom = targetPrice[2];
317         targetPriceTo = targetPrice[3];
318         startTimestamp = saleEndTimestamp;
319         endTimestamp = businessPlannedPeriodEndTimestamp;    
320       }     
321       lastStakePriceUSCents = targetPriceFrom + ((now-startTimestamp)*(targetPriceTo-targetPriceFrom))/(endTimestamp-startTimestamp);       
322     }  
323   /**
324    * @dev Recieve wei and process Stakes sale
325    */    
326     function() payable public {
327       require(msg.sender != address(0));
328       require(msg.value > 0); // process only requests with wei
329       require(now < businessPlannedPeriodEndTimestamp); // no later then at the end of planned period
330       processSale();       
331     }
332   /**
333    * @dev Process Stakes sale
334    */       
335     function processSale() internal {
336       if(!priceIsFrozen) { // refresh price only if price is not frozen
337         setStakePriceUSCents();
338       }
339       setCaps();    
340 
341         uint teamStakes; // Stakes for the team according to teamShare
342         uint saleStakes; // Stakes for the Sale
343         uint weiInvested; // weiInvested now by this Investor
344         uint trySaleStakes = stakeForWei(msg.value); // try to get this quantity of Stakes
345 
346       if(trySaleStakes > 1) {
347         uint tryDistribute = distributedSaleStakes+trySaleStakes; // try to distribute this tryStakes        
348         if(tryDistribute <= saleCap) { // saleCap not reached
349           saleStakes = trySaleStakes; // all tryStakes can be sold
350           weiInvested = msg.value; // all current wei are accepted                    
351         } else {
352           saleStakes = saleCap-distributedSaleStakes; // only remnant of Stakes are available
353           weiInvested = weiForStake(saleStakes); // wei for available remnant of Stakes 
354         }
355         teamStakes = (saleStakes*teamShare).div(saleShare); // part of Stakes for a team        
356         if(saleStakes > 0) {          
357           balances[owner] += teamStakes; // rewarding team according to teamShare
358           totalSupply += teamStakes; // supplying team Stakes
359           distributedTeamStakes += teamStakes; // saving distributed team Stakes 
360           saleSupply(msg.sender, saleStakes, weiInvested); // process saleSupply
361           if(saleStat[msg.sender].guide != address(0)) { // we have Investment Guide to reward and distribute bonus Stakes
362             distributeBonusStakes(msg.sender, saleStakes, weiInvested);  
363           }          
364         }        
365         if(tryDistribute > saleCap) {
366           msg.sender.transfer(msg.value-weiInvested); // return remnant
367         }        
368       } else {
369         msg.sender.transfer(msg.value); // return incorrect wei
370       }
371     }
372   /**
373    * @dev Transfer Stakes from owner balance to buyer balance & saving data to saleStat storage
374    * @param _to is address of buyer 
375    * @param _stakes is quantity of Stakes transfered 
376    * @param _wei is value invested        
377    */ 
378     function saleSupply(address _to, uint _stakes, uint _wei) internal {
379       require(_stakes > 0);  
380       balances[_to] += _stakes; // supply sold Stakes directly to buyer
381       totalSupply += _stakes;
382       distributedSaleStakes += _stakes;
383       totalInvested = totalInvested.add(_wei); // adding to total investment
384       // saving stat
385       saleStat[_to].stakes += _stakes; // stating Stakes bought       
386       saleStat[_to].invested = saleStat[_to].invested.add(_wei); // stating wei invested
387       Transfer(supplier, _to, _stakes);
388     }      
389   /**
390    * @dev Set new owner
391    * @param new_owner new owner  
392    */    
393     function setNewOwner(address new_owner) public onlyOwner {
394       owner = new_owner; 
395     }
396   /**
397    * @dev Set new ether price in USD. Should be changed when price grow-fall 5%-10%
398    * @param new_usd_per_ether new price  
399    */    
400     function setUsdPerEther(uint new_usd_per_ether) public onlyOwner {
401       UsdPerEtherChanged(usdPerEther, new_usd_per_ether);
402       usdPerEther = new_usd_per_ether; 
403     }
404   /**
405    * @dev Set address of wallet where investment will be transfered for further using in business transactions
406    * @param _pool new address of the Pool   
407    */         
408     function setPoolAddress(address _pool) public onlyOwner {
409       pool = _pool;  
410     }
411   /**
412    * @dev Change Pool capacity in USD
413    * @param new_pool_cap_usd new Pool cap in $   
414    */    
415     function setPoolCapUSD(uint new_pool_cap_usd) public onlyOwner {
416       PoolCapChanged(poolCapUSD, new_pool_cap_usd);
417       poolCapUSD = new_pool_cap_usd; 
418     }
419   /**
420    * @dev Register Investment Guide
421    * @param investment_guide address of Investment Guide   
422    */     
423     function registerGuide(address investment_guide) public onlyOwner {
424       guidesStat[investment_guide].registered = true;
425       RegisterGuide(investment_guide);
426     }
427   /**
428    * @dev Stop increasing price dynamically. Set it as static temporary. 
429    */   
430     function freezePrice() public onlyOwner {
431       priceIsFrozen = true; 
432     }
433   /**
434    * @dev Continue increasing price dynamically (the standard, usual algorithm).
435    */       
436     function unfreezePrice() public onlyOwner {
437       priceIsFrozen = false; // this means that price is unfrozen  
438     }
439   /**
440    * @dev Ability to tune dynamic price changing with time.
441    */       
442     function setTargetPrice(uint8 n, uint stake_price_us_cents) public onlyOwner {
443       TargetPriceChanged(n, targetPrice[n], stake_price_us_cents);
444       targetPrice[n] = stake_price_us_cents;
445     }  
446   /**
447    * @dev Get and set address of Investment Guide and distribute bonus Stakes and Guide reward
448    * @param key address of Investment Guide   
449    */     
450     function getBonusStakesPermanently(address key) public {
451       require(guidesStat[key].registered);
452       require(saleStat[msg.sender].guide == address(0)); // Investment Guide is not applied yet for this Investor
453       saleStat[msg.sender].guide = key; // apply Inv. Guide 
454       if(saleStat[msg.sender].invested > 0) { // we have invested value, process distribution of bonus Stakes and rewarding a Guide     
455         distributeBonusStakes(msg.sender, saleStat[msg.sender].stakes, saleStat[msg.sender].invested);
456       }
457     }
458   /**
459    * @dev Distribute bonus Stakes to Investor according to bonusShare
460    * @param _to to which Investor to distribute
461    * @param added_stakes how many Stakes are added by this Investor    
462    * @param added_wei how much wei are invested by this Investor 
463    * @return wei quantity        
464    */       
465     function distributeBonusStakes(address _to, uint added_stakes, uint added_wei) internal {
466       uint added_bonus_stakes = (added_stakes*((bonusShare*100).div(saleShare)))/100; // how many bonus Stakes to add
467       require(distributedBonusStakes+added_bonus_stakes <= bonusCap); // check is bonus cap is not overflowed
468       uint added_potential_reward = (added_wei*guideInvestmentAttractedShareToPay)/100; // reward for the Guide
469       if(!rejectedInvestmentWithdrawals[_to]) {
470         guidesStat[saleStat[_to].guide].accumulatedPotentialReward += added_potential_reward; // save potential reward for the Guide
471       } else {
472         guidesStat[saleStat[_to].guide].rewardToWithdraw += added_potential_reward; // let linked Investment Guide to withdraw all this reward   
473       }      
474       saleStat[_to].guideReward += added_potential_reward; // add guideReward wei value for stat
475       saleStat[_to].bonusStakes += added_bonus_stakes; // add bonusStakes for stat    
476       balances[_to] += added_bonus_stakes; // transfer bonus Stakes
477       distributedBonusStakes += added_bonus_stakes; // save bonus Stakes distribution
478       totalSupply += added_bonus_stakes; // increase totalSupply
479       BonusDistributed(_to, added_bonus_stakes, saleStat[_to].guide, added_potential_reward);          
480     }
481   /**
482    * @dev Get current finance period number
483    * @return current finance period number        
484    */    
485     function currentFinancePeriod() internal view returns(uint8) {
486       uint8 current_finance_period = 0;
487       for(uint8 i=0; i <= financePeriodsCount; i++) {
488         current_finance_period = i;
489         if(now<financePeriodsTimestamps[i]) {          
490           break;
491         }
492       }
493       return current_finance_period;      
494     }
495   /**
496    * @dev Show how much wei can withdraw Investment Guide
497    * @param _guide address of registered guide 
498    * @return wei quantity        
499    */     
500     function guideRewardToWithdraw(address _guide) public view returns(uint) {
501       // reward to withdraw depends on current finance period and do not include potentially withdraw amount of investment
502       return (guidesStat[_guide].accumulatedPotentialReward*(currentFinancePeriod()+1))/(financePeriodsCount+1) + guidesStat[_guide].rewardToWithdraw - guidesStat[_guide].periodicallyWithdrawnReward;  
503     }  
504   
505   /*
506     weiForStake & stakeForWei functions sometimes show not correct translated value from dapp interface (view) 
507     because lastStakePriceUSCents sometimes temporary outdated (in view mode)
508     but it doesn't mean that execution itself is not correct  
509   */  
510   
511   /**
512    * @dev Translate wei to Stakes
513    * @param input_wei is wei to translate into stakes, 
514    * @return Stakes quantity        
515    */ 
516     function stakeForWei(uint input_wei) public view returns(uint) {
517       return ((input_wei*usdPerEther*100)/1 ether)/lastStakePriceUSCents;    
518     }  
519   /**
520    * @dev Translate Stakes to wei
521    * @param input_stake is stakes to translate into wei
522    * @return wei quantity        
523    */ 
524     function weiForStake(uint input_stake) public view returns(uint) {
525       return (input_stake*lastStakePriceUSCents*1 ether)/(usdPerEther*100);    
526     } 
527   /**
528    * @dev Transfer wei from this contract to pool wallet partially only, 
529    *      1) for funding promotion of Stakes sale   
530    *      2) according to share (finance_periods_last + current_finance_period) / business_planned_period
531    */    
532     function transferToPool() public onlyOwner {      
533       uint max_available; // max_available funds for transfering to pool    
534       uint amountToTransfer; // amount to transfer to pool
535         // search end timestamp of current financial period
536         for(uint8 i=0; i <= financePeriodsCount; i++) {
537           // found end timestamp of current financial period OR now is later then business planned end date (transfer wei remnant)
538           if(now < financePeriodsTimestamps[i] || (i == financePeriodsCount && now > financePeriodsTimestamps[i])) {   
539             // avaialbe only part of total value of total invested funds with substracted total allowed amount transfered
540             max_available = ((i+1)*(totalInvested+totalWithdrawn-allowedAmountTransferedToPoolTotal))/(financePeriodsCount+1); 
541             // not all max_available funds are transfered at the moment OR we have allowed amount to transfer
542             if(max_available > transferedToPool-allowedAmountTransferedToPoolTotal || allowedAmountToTransferToPool > 0) {
543               if(allowedAmountToTransferToPool > 0) { // we have allowed by Investor (rejected to withdraw) amount
544                 amountToTransfer = allowedAmountToTransferToPool; // to transfer this allowed amount 
545                 allowedAmountTransferedToPoolTotal += allowedAmountToTransferToPool; // add allowed amount to total allowed amount
546                 allowedAmountToTransferToPool = 0;                  
547               } else {
548                 amountToTransfer = max_available-transferedToPool; // only remained amount is available to transfer
549               }
550               if(amountToTransfer > this.balance) { // remained amount to transfer more then current balance
551                 amountToTransfer = this.balance; // correct amount to transfer  
552               }
553               transferedToPool += amountToTransfer; // increase transfered to pool amount               
554               pool.transfer(amountToTransfer);                        
555               TransferedToPool(amountToTransfer, i+1);
556             }
557             allowedAmountToTransferToPool=0;
558             break;    
559           }
560         }     
561     }  
562   /**
563    * @dev Investor can withdraw part of his/her investment.
564    *      A size of this part depends on how many financial periods last and how many remained.
565    *      Investor gives back all stakes which he/she got for his/her investment.     
566    */       
567     function withdrawInvestment() public {
568       require(!rejectedInvestmentWithdrawals[msg.sender]); // this Investor not rejected to withdraw their investment
569       require(saleStat[msg.sender].stakes > 0);
570       require(balances[msg.sender] >= saleStat[msg.sender].stakes+saleStat[msg.sender].bonusStakes); // Investor has needed stakes to return
571       uint remained; // all investment which are available to withdraw by all Investors
572       uint to_withdraw; // available funds to withdraw for this particular Investor
573       for(uint8 i=0; i < financePeriodsCount; i++) { // last fin. period is not available
574         if(now<financePeriodsTimestamps[i]) { // find end timestamp of current financial period          
575           remained = totalInvested - ((i+1)*totalInvested)/(financePeriodsCount+1); // remained investment to withdraw by all Investors 
576           to_withdraw = (saleStat[msg.sender].invested*remained)/totalInvested; // investment to withdraw by this Investor
577           uint sale_stakes_to_burn = saleStat[msg.sender].stakes+saleStat[msg.sender].bonusStakes; // returning all Stakes saved in saleStat[msg.sender]
578           uint team_stakes_to_burn = (saleStat[msg.sender].stakes*teamShare)/saleShare; // appropriate issued team Stakes are also burned
579           balances[owner] = balances[owner].sub(team_stakes_to_burn); // burn appropriate team Stakes
580           distributedTeamStakes -= team_stakes_to_burn; // remove team Stakes from distribution         
581           balances[msg.sender] = balances[msg.sender].sub(sale_stakes_to_burn); // burn stakes got for invested wei
582           totalInvested = totalInvested.sub(to_withdraw); // decrease invested total value
583           totalSupply = totalSupply.sub(sale_stakes_to_burn).sub(team_stakes_to_burn); // totalSupply is decreased
584           distributedSaleStakes -= saleStat[msg.sender].stakes;
585           if(saleStat[msg.sender].guide != address(0)) { // we have Guide and bonusStakes
586             // potential reward for the Guide is decreased proportionally
587             guidesStat[saleStat[msg.sender].guide].accumulatedPotentialReward -= (saleStat[msg.sender].guideReward - ((i+1)*saleStat[msg.sender].guideReward)/(financePeriodsCount+1)); 
588             distributedBonusStakes -= saleStat[msg.sender].bonusStakes;
589             saleStat[msg.sender].bonusStakes = 0;
590             saleStat[msg.sender].guideReward = 0;          
591           }
592           saleStat[msg.sender].stakes = 0; // nullify Stakes recieved value          
593           saleStat[msg.sender].invested = 0; // nullify wei invested value
594           totalWithdrawn += to_withdraw;
595           msg.sender.transfer(to_withdraw); // witdraw investment
596           InvestmentWithdrawn(msg.sender, to_withdraw, sale_stakes_to_burn, financePeriodsCount-i);          
597           break;  
598         }
599       }      
600     }
601   /**
602    * @dev Investor rejects withdraw investment. This lets Investment Guide withdraw all his/her reward related to this Investor   
603    */     
604     function rejectInvestmentWithdrawal() public {
605       rejectedInvestmentWithdrawals[msg.sender] = true;
606       address guide = saleStat[msg.sender].guide;
607       if(guide != address(0)) { // Inv. Guide exists
608         if(saleStat[msg.sender].guideReward >= guidesStat[guide].periodicallyWithdrawnReward) { // already withdrawed less then to withdraw for this Investor
609           uint remainedRewardToWithdraw = saleStat[msg.sender].guideReward-guidesStat[guide].periodicallyWithdrawnReward;
610           guidesStat[guide].periodicallyWithdrawnReward = 0; // withdrawn reward is counted as withdrawn of this Investor reward 
611           if(guidesStat[guide].accumulatedPotentialReward >= remainedRewardToWithdraw) { // we have enough potential reward
612             guidesStat[guide].accumulatedPotentialReward -= remainedRewardToWithdraw; // decrease potential reward
613             guidesStat[guide].rewardToWithdraw += remainedRewardToWithdraw;  // increase total amount to withdraw right now
614           } else {
615             guidesStat[guide].accumulatedPotentialReward = 0; // something wrong so nullify
616           }
617         } else {
618           // substract current Investor's reward from periodically withdrawn reward to remove it from withdrawned
619           guidesStat[guide].periodicallyWithdrawnReward -= saleStat[msg.sender].guideReward;
620           // we have enough potential reward - all ok 
621           if(guidesStat[guide].accumulatedPotentialReward >= saleStat[msg.sender].guideReward) {
622             // we do not count this Investor guideReward in potential reward
623             guidesStat[guide].accumulatedPotentialReward -= saleStat[msg.sender].guideReward;
624             guidesStat[guide].rewardToWithdraw += saleStat[msg.sender].guideReward;  // increase total amount to withdraw right now  
625           } else {
626             guidesStat[guide].accumulatedPotentialReward = 0; // something wrong so nullify  
627           }   
628         }
629       }
630       allowedAmountToTransferToPool += saleStat[msg.sender].invested;
631     }
632   
633   /**
634    * @dev Distribute bounty rewards for bounty tasks
635    * @param _to is address of bounty hunter
636    * @param _stakes is quantity of Stakes transfered       
637    */     
638     function distributeBounty(address _to, uint _stakes) public onlyOwner {
639       require(distributedBountyStakes+_stakes <= bountyCap); // no more then maximum capacity can be distributed
640       balances[_to] = balances[_to].add(_stakes); // to
641       totalSupply += _stakes; 
642       distributedBountyStakes += _stakes; // adding to total bounty distributed
643       BountyDistributed(_to, _stakes);    
644     }  
645   /**
646    * @dev Unfreeze team Stakes. Only after excessed Stakes have burned.
647    */      
648     function unFreeze() public onlyOwner {
649       // only after planned period
650       if(now > businessPlannedPeriodEndTimestamp) {
651         teamStakesFrozen = false; // make team stakes available for transfering
652       }  
653     }
654 }