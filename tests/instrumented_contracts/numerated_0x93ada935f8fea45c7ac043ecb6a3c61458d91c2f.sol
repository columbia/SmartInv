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
28   event Burn(address indexed burner, uint256 value);
29 }
30 
31 contract ERC20 is ERC20Basic {
32   function allowance(address owner, address spender) public constant returns (uint256);
33   function transferFrom(address from, address to, uint256 value) public returns (bool);
34   function approve(address spender, uint256 value) public returns (bool);
35   event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 contract BasicToken is ERC20Basic {
39   
40   using SafeMath for uint256;
41   bool public teamStakesFrozen = true;
42   bool public fundariaStakesFrozen = true;
43   mapping(address => uint256) balances;
44   address public owner;
45   address public fundaria = 0x1882464533072e9fCd8C6D3c5c5b588548B95296; // initial Fundaria pool address  
46   
47   function BasicToken() public {
48     owner = msg.sender;
49   }
50   
51   modifier notFrozen() {
52     require(msg.sender != owner || (msg.sender == owner && !teamStakesFrozen) || (msg.sender == fundaria && !fundariaStakesFrozen));
53     _;
54   }
55 
56   /**
57   * @dev transfer token for a specified address
58   * @param _to The address to transfer to.
59   * @param _value The amount to be transferred.
60   */
61   function transfer(address _to, uint256 _value) public notFrozen returns (bool) {
62     require(_to != address(0));
63     require(_value <= balances[msg.sender]);
64     // SafeMath.sub will throw if there is not enough balance.
65     balances[msg.sender] = balances[msg.sender].sub(_value);
66     balances[_to] = balances[_to].add(_value);
67     Transfer(msg.sender, _to, _value);
68     return true;
69   }
70 
71   /**
72   * @dev Gets the balance of the specified address.
73   * @param _owner The address to query the the balance of.
74   * @return An uint256 representing the amount owned by the passed address.
75   */
76   function balanceOf(address _owner) public constant returns (uint256 balance) {
77     return balances[_owner];
78   }
79 }
80 
81 contract StandardToken is ERC20, BasicToken {
82   mapping (address => mapping (address => uint256)) internal allowed;
83   /**
84    * @dev Transfer tokens from one address to another
85    * @param _from address The address which you want to send tokens from
86    * @param _to address The address which you want to transfer to
87    * @param _value uint256 the amount of tokens to be transferred
88    */
89   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[_from]);
92     require(_value <= allowed[_from][msg.sender]);
93     balances[_from] = balances[_from].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
96     Transfer(_from, _to, _value);
97     return true;
98   }
99 
100   /**
101    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
102    *
103    * Beware that changing an allowance with this method brings the risk that someone may use both the old
104    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
105    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
106    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
107    * @param _spender The address which will spend the funds.
108    * @param _value The amount of tokens to be spent.
109    */
110   function approve(address _spender, uint256 _value) public notFrozen returns (bool) {
111     allowed[msg.sender][_spender] = _value;
112     Approval(msg.sender, _spender, _value);
113     return true;
114   }
115 
116   /**
117    * @dev Function to check the amount of tokens that an owner allowed to a spender.
118    * @param _owner address The address which owns the funds.
119    * @param _spender address The address which will spend the funds.
120    * @return A uint256 specifying the amount of tokens still available for the spender.
121    */
122   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
123     return allowed[_owner][_spender];
124   }
125 
126   /**
127    * approve should be called when allowed[_spender] == 0. To increment
128    * allowed value is better to use this function to avoid 2 calls (and wait until
129    * the first transaction is mined)
130    * From MonolithDAO Token.sol
131    */
132   function increaseApproval (address _spender, uint _addedValue) public notFrozen returns (bool success) {
133     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
134     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
135     return true;
136   }
137 
138   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
139     uint oldValue = allowed[msg.sender][_spender];
140     if (_subtractedValue > oldValue) {
141       allowed[msg.sender][_spender] = 0;
142     } else {
143       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
144     }
145     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
146     return true;
147   }
148 }
149 
150 contract SAUR is StandardToken {
151   string public constant name = "Cardosaur Stake";
152   string public constant symbol = "SAUR";
153   uint8 public constant decimals = 0;
154 }
155 
156 contract Sale is SAUR {
157 
158     using SafeMath for uint;
159 
160 /********** 
161  * Common *
162  **********/
163 
164     // THIS IS KEY VARIABLE AND DEFINED ACCORDING TO VALUE OF PLANNED COSTS ON THE PAGE https://business.fundaria.com
165     uint public poolCapUSD = 70000; // 70000 initially
166     // USD per 1 ether, added 10% aproximatelly to secure from wrong low price. We need add 10% of Stakes to supply to cover such price.
167     uint public usdPerEther = 800;
168     uint public supplyCap; // Current total supply cap according to lastStakePriceUSCents and poolCapUSD 
169     uint public businessPlannedPeriodDuration = 183 days; // total period planned for business activity 365 days
170     uint public businessPlannedPeriodEndTimestamp;
171     uint public teamCap; // team Stakes capacity
172     uint8 public teamShare = 55; // share for team
173     uint public distributedTeamStakes; // distributed Stakes to team    
174     uint public fundariaCap; // Fundaria Stakes capacity
175     uint8 public fundariaShare = 20; // share for Fundaria
176     uint public distributedFundariaStakes; // distributed Stakes to Fundaria
177     uint public contractCreatedTimestamp; // when this contract was created
178     address public pool = 0x28C19cEb598fdb171048C624DB8b91C56Af29aA2; // initial pool wallet address  
179     mapping (address=>bool) public rejectedInvestmentWithdrawals;
180     uint public allowedAmountToTransferToPool; // this amount is increased when investor rejects to withdraw his/her investment
181     uint public allowedAmountTransferedToPoolTotal; // sum of all allowedAmountToTransferToPool used 
182     uint public investmentGuidesRewardsWithdrawn; // total amount of rewards wei withdrawn by Guides  
183 
184 /********** 
185  * Bounty *
186  **********/
187  
188     uint public distributedBountyStakes; // bounty advisors Stakes distributed total    
189     uint public bountyCap; // bounty advisors Stakes capacity    
190     uint8 public bountyShare = 4; // share for bounty    
191     
192 /*********** 
193  * Sale *
194  ***********/
195     address supplier = 0x0000000000000000000000000000000000000000; // address of Stakes initial supplier (abstract)
196     // data to store invested wei value & Stakes for Investor
197     struct saleData {
198       uint stakes; // how many Stakes where recieved by this Investor total
199       uint invested; // how much wei this Investor invested total
200       uint bonusStakes; // how many bonus Stakes where recieved by this Investor
201       uint guideReward; // Investment Guide reward amount
202       address guide; // address of Investment Guide
203     }
204     mapping (address=>saleData) public saleStat; // invested value + Stakes data for every Investor        
205     uint public saleStartTimestamp = 1524852000; // regular Stakes sale start date            
206     uint public saleEndTimestamp = 1527444000; 
207     uint public distributedSaleStakes; // distributed stakes to all Investors
208     uint public totalInvested; //how many invested total
209     uint public totalWithdrawn; //how many withdrawn total
210     uint public saleCap; // regular sale Stakes capacity   
211     uint8 public saleShare = 20; // share for regular sale
212     uint public lastStakePriceUSCents; // Stake price in U.S. cents is determined according to current timestamp (the further - the higher price)    
213     uint[] public targetPrice;    
214     bool public priceIsFrozen = false; // stop increasing the price temporary (in case of low demand. Can be called only after saleEndTimestamp)       
215     
216 /************************************ 
217  * Bonus Stakes & Investment Guides *
218  ************************************/    
219     // data to store Investment Guide reward
220     struct guideData {
221       bool registered; // is this Investment Guide registered
222       uint accumulatedPotentialReward; // how many reward wei are potentially available
223       uint rewardToWithdraw; // availabe reward to withdraw now
224       uint periodicallyWithdrawnReward; // how much reward wei where withdrawn by this Investment Guide already
225     }
226     mapping (address=>guideData) public guidesStat; // mapping of Investment Guides datas    
227     uint public bonusCap; // max amount of bonus Stakes availabe
228     uint public distributedBonusStakes; // how many bonus Stakes are already distributed
229     uint public bonusShare = 1; // share of bonus Stakes in supplyCap
230     uint8 public guideInvestmentAttractedShareToPay = 10; // reward for the Investment Guide
231 
232 /*
233   WANT TO EARN ON STAKES SALE ?
234   BECOME INVESTMENT GUIDE AND RECIEVE 10% OF ATTRACTED INVESTMENT !
235   INTRODUCE YOURSELF ON FUNDARIA.COM@GMAIL.COM & GIVE YOUR WALLET ADDRESS
236 */    
237 
238 /********************************************* 
239  * To Pool transfers & Investment withdrawal *
240  *********************************************/
241 
242     uint8 public financePeriodsCount = 6; // How many finance periods in planned period
243     uint[] public financePeriodsTimestamps; // Supportive array for searching current finance period
244     uint public transferedToPool; // how much wei transfered to pool already
245 
246 /* EVENTS */
247 
248     event StakesSale(address to, uint weiInvested, uint stakesRecieved, uint teamStakesRecieved, uint stake_price_us_cents);
249     event BountyDistributed(address to, uint bountyStakes);
250     event TransferedToPool(uint weiAmount, uint8 currentFinancialPeriodNo);
251     event InvestmentWithdrawn(address to, uint withdrawnWeiAmount, uint stakesBurned, uint8 remainedFullFinancialPeriods);
252     event UsdPerEtherChanged(uint oldUsdPerEther, uint newUsdPerEther);
253     event BonusDistributed(address to, uint bonusStakes, address guide, uint accumulatedPotentialReward);
254     event PoolCapChanged(uint oldCapUSD, uint newCapUSD);
255     event RegisterGuide(address investmentGuide);
256     event TargetPriceChanged(uint8 N, uint oldTargetPrice, uint newTargetPrice);
257     event InvestmentGuideWithdrawReward(address investmentGuide, uint withdrawnRewardWei);
258     
259     modifier onlyOwner() {
260       require(msg.sender==owner);
261       _;
262     }
263   /**
264    * @dev Determine duration of finance period, fill array with finance periods timestamps,
265    *      set businessPlannedPeriodEndTimestamp and contractCreatedTimestamp,    
266    */      
267     function Sale() public {     
268       uint financePeriodDuration = businessPlannedPeriodDuration/financePeriodsCount; // quantity of seconds in chosen finance period
269       // making array with timestamps of every finance period end date
270       financePeriodsTimestamps.push(saleEndTimestamp); // first finance period is whole sale period
271       for(uint8 i=1; i<=financePeriodsCount; i++) {
272         financePeriodsTimestamps.push(saleEndTimestamp+financePeriodDuration*i);  
273       }
274       businessPlannedPeriodEndTimestamp = saleEndTimestamp+businessPlannedPeriodDuration; 
275       contractCreatedTimestamp = now;
276       targetPrice.push(1); // Initial Stake price mark in U.S. cents (1 cent = $0.01)  
277       targetPrice.push(10); // price mark at the sale period start timestamp      
278       targetPrice.push(100); // price mark at the sale period end timestamp       
279       targetPrice.push(1000); // price mark at the end of business planned period
280       balances[supplier] = 0; // nullify Stakes formal supplier balance         
281     }
282   /**
283    * @dev How many investment remained? Maximum investment is poolCapUSD
284    * @return remainingInvestment in wei   
285    */     
286     function remainingInvestment() public view returns(uint) {
287       return poolCapUSD.div(usdPerEther).mul(1 ether).sub(totalInvested);  
288     }
289   /**
290    * @dev Dynamically set caps
291    */       
292     function setCaps() internal {
293       // remaining Stakes are determined only from remainingInvestment
294       saleCap = distributedSaleStakes+stakeForWei(remainingInvestment()); // max available Stakes for sale including already distributed
295       supplyCap = saleCap.mul(100).div(saleShare); // max available Stakes for supplying
296       teamCap = supplyCap.mul(teamShare).div(100); // max available team Stakes
297       fundariaCap = supplyCap.mul(fundariaShare).div(100); // max available team Stakes
298       bonusCap = supplyCap.mul(bonusShare).div(100); // max available Stakes for bonus
299       bountyCap = supplyCap.sub(saleCap).sub(teamCap).sub(bonusCap); // max available Stakes for bounty        
300     }
301   /**
302    * @dev Dynamically set the price of Stake in USD cents, which depends on current timestamp (price grows with time)
303    */       
304     function setStakePriceUSCents() internal {
305         uint targetPriceFrom;
306         uint targetPriceTo;
307         uint startTimestamp;
308         uint endTimestamp;
309       // set price for pre sale period      
310       if(now < saleStartTimestamp) {
311         targetPriceFrom = targetPrice[0];
312         targetPriceTo = targetPrice[1];
313         startTimestamp = contractCreatedTimestamp;
314         endTimestamp = saleStartTimestamp;        
315       // set price for sale period
316       } else if(now >= saleStartTimestamp && now < saleEndTimestamp) {
317         targetPriceFrom = targetPrice[1];
318         targetPriceTo = targetPrice[2];
319         startTimestamp = saleStartTimestamp;
320         endTimestamp = saleEndTimestamp;    
321       // set price for post sale period
322       } else if(now >= saleEndTimestamp && now < businessPlannedPeriodEndTimestamp) {
323         targetPriceFrom = targetPrice[2];
324         targetPriceTo = targetPrice[3];
325         startTimestamp = saleEndTimestamp;
326         endTimestamp = businessPlannedPeriodEndTimestamp;    
327       }     
328       lastStakePriceUSCents = targetPriceFrom + ((now-startTimestamp)*(targetPriceTo-targetPriceFrom))/(endTimestamp-startTimestamp);       
329     }  
330   /**
331    * @dev Recieve wei and process Stakes sale
332    */    
333     function() payable public {
334       require(msg.sender != address(0));
335       require(msg.value > 0); // process only requests with wei
336       require(now < businessPlannedPeriodEndTimestamp); // no later then at the end of planned period
337       processSale();       
338     }
339   /**
340    * @dev Process Stakes sale
341    */       
342     function processSale() internal {
343       if(!priceIsFrozen) { // refresh price only if price is not frozen
344         setStakePriceUSCents();
345       }
346       setCaps();    
347 
348         uint teamStakes; // Stakes for the team according to teamShare
349         uint fundariaStakes; // Stakes for the Fundaria according to teamShare
350         uint saleStakes; // Stakes for the Sale
351         uint weiInvested; // weiInvested now by this Investor
352         uint trySaleStakes = stakeForWei(msg.value); // try to get this quantity of Stakes
353 
354       if(trySaleStakes > 1) {
355         uint tryDistribute = distributedSaleStakes+trySaleStakes; // try to distribute this tryStakes        
356         if(tryDistribute <= saleCap) { // saleCap not reached
357           saleStakes = trySaleStakes; // all tryStakes can be sold
358           weiInvested = msg.value; // all current wei are accepted                    
359         } else {
360           saleStakes = saleCap-distributedSaleStakes; // only remnant of Stakes are available
361           weiInvested = weiForStake(saleStakes); // wei for available remnant of Stakes 
362         }
363         teamStakes = (saleStakes*teamShare).div(saleShare); // part of Stakes for a team
364         fundariaStakes = (saleStakes*fundariaShare).div(saleShare); // part of Stakes for a team        
365         if(saleStakes > 0) {          
366           balances[owner] += teamStakes; // rewarding team according to teamShare
367           totalSupply += teamStakes; // supplying team Stakes
368           distributedTeamStakes += teamStakes; // saving distributed team Stakes
369           Transfer(supplier, owner, teamStakes);         
370           balances[fundaria] += fundariaStakes; // rewarding team according to fundariaShare
371           totalSupply += fundariaStakes; // supplying Fundaria Stakes
372           distributedFundariaStakes += fundariaStakes; // saving distributed team Stakes
373           Transfer(supplier, fundaria, fundariaStakes);                     
374           saleSupply(msg.sender, saleStakes, weiInvested); // process saleSupply
375           if(saleStat[msg.sender].guide != address(0)) { // we have Investment Guide to reward and distribute bonus Stakes
376             distributeBonusStakes(msg.sender, saleStakes, weiInvested);  
377           }          
378         }        
379         if(tryDistribute > saleCap) {
380           msg.sender.transfer(msg.value-weiInvested); // return remnant
381         }        
382       } else {
383         msg.sender.transfer(msg.value); // return incorrect wei
384       }
385     }
386   /**
387    * @dev Transfer Stakes from owner balance to buyer balance & saving data to saleStat storage
388    * @param _to is address of buyer 
389    * @param _stakes is quantity of Stakes transfered 
390    * @param _wei is value invested        
391    */ 
392     function saleSupply(address _to, uint _stakes, uint _wei) internal {
393       require(_stakes > 0);  
394       balances[_to] += _stakes; // supply sold Stakes directly to buyer
395       totalSupply += _stakes;
396       distributedSaleStakes += _stakes;
397       totalInvested = totalInvested.add(_wei); // adding to total investment
398       // saving stat
399       saleStat[_to].stakes += _stakes; // stating Stakes bought       
400       saleStat[_to].invested = saleStat[_to].invested.add(_wei); // stating wei invested
401       Transfer(supplier, _to, _stakes);
402     }      
403   /**
404    * @dev Set new owner
405    * @param new_owner new owner  
406    */    
407     function setNewOwner(address new_owner) public onlyOwner {
408       owner = new_owner; 
409     }
410   /**
411    * @dev Set new Fundaria address
412    * @param new_fundaria new fundaria  
413    */    
414     function setNewFundaria(address new_fundaria) public onlyOwner {
415       fundaria = new_fundaria; 
416     }    
417   /**
418    * @dev Set new ether price in USD. Should be changed when price grow-fall 5%-10%
419    * @param new_usd_per_ether new price  
420    */    
421     function setUsdPerEther(uint new_usd_per_ether) public onlyOwner {
422       UsdPerEtherChanged(usdPerEther, new_usd_per_ether);
423       usdPerEther = new_usd_per_ether; 
424     }
425   /**
426    * @dev Set address of wallet where investment will be transfered for further using in business transactions
427    * @param _pool new address of the Pool   
428    */         
429     function setPoolAddress(address _pool) public onlyOwner {
430       pool = _pool;  
431     }
432   /**
433    * @dev Change Pool capacity in USD
434    * @param new_pool_cap_usd new Pool cap in $   
435    */    
436     function setPoolCapUSD(uint new_pool_cap_usd) public onlyOwner {
437       PoolCapChanged(poolCapUSD, new_pool_cap_usd);
438       poolCapUSD = new_pool_cap_usd; 
439     }
440   /**
441    * @dev Register Investment Guide
442    * @param investment_guide address of Investment Guide   
443    */     
444     function registerGuide(address investment_guide) public onlyOwner {
445       guidesStat[investment_guide].registered = true;
446       RegisterGuide(investment_guide);
447     }
448   /**
449    * @dev Stop increasing price dynamically. Set it as static temporary. 
450    */   
451     function freezePrice() public onlyOwner {
452       priceIsFrozen = true; 
453     }
454   /**
455    * @dev Continue increasing price dynamically (the standard, usual algorithm).
456    */       
457     function unfreezePrice() public onlyOwner {
458       priceIsFrozen = false; // this means that price is unfrozen  
459     }
460   /**
461    * @dev Ability to tune dynamic price changing with time.
462    */       
463     function setTargetPrice(uint8 n, uint stake_price_us_cents) public onlyOwner {
464       TargetPriceChanged(n, targetPrice[n], stake_price_us_cents);
465       targetPrice[n] = stake_price_us_cents;
466     }  
467   /**
468    * @dev Get and set address of Investment Guide and distribute bonus Stakes and Guide reward
469    * @param key address of Investment Guide   
470    */     
471     function getBonusStakesPermanently(address key) public {
472       require(guidesStat[key].registered);
473       require(saleStat[msg.sender].guide == address(0)); // Investment Guide is not applied yet for this Investor
474       saleStat[msg.sender].guide = key; // apply Inv. Guide 
475       if(saleStat[msg.sender].invested > 0) { // we have invested value, process distribution of bonus Stakes and rewarding a Guide     
476         distributeBonusStakes(msg.sender, saleStat[msg.sender].stakes, saleStat[msg.sender].invested);
477       }
478     }
479   /**
480    * @dev Distribute bonus Stakes to Investor according to bonusShare
481    * @param _to to which Investor to distribute
482    * @param added_stakes how many Stakes are added by this Investor    
483    * @param added_wei how much wei are invested by this Investor 
484    * @return wei quantity        
485    */       
486     function distributeBonusStakes(address _to, uint added_stakes, uint added_wei) internal {
487       uint added_bonus_stakes = (added_stakes*((bonusShare*100).div(saleShare)))/100; // how many bonus Stakes to add
488       require(distributedBonusStakes+added_bonus_stakes <= bonusCap); // check is bonus cap is not overflowed
489       uint added_potential_reward = (added_wei*guideInvestmentAttractedShareToPay)/100; // reward for the Guide
490       if(!rejectedInvestmentWithdrawals[_to]) {
491         guidesStat[saleStat[_to].guide].accumulatedPotentialReward += added_potential_reward; // save potential reward for the Guide
492       } else {
493         guidesStat[saleStat[_to].guide].rewardToWithdraw += added_potential_reward; // let linked Investment Guide to withdraw all this reward   
494       }      
495       saleStat[_to].guideReward += added_potential_reward; // add guideReward wei value for stat
496       saleStat[_to].bonusStakes += added_bonus_stakes; // add bonusStakes for stat    
497       balances[_to] += added_bonus_stakes; // transfer bonus Stakes
498       distributedBonusStakes += added_bonus_stakes; // save bonus Stakes distribution
499       totalSupply += added_bonus_stakes; // increase totalSupply
500       BonusDistributed(_to, added_bonus_stakes, saleStat[_to].guide, added_potential_reward);
501       Transfer(supplier, _to, added_bonus_stakes);          
502     }
503   
504   /*
505     weiForStake & stakeForWei functions sometimes show not correct translated value from dapp interface (view) 
506     because lastStakePriceUSCents sometimes temporary outdated (in view mode)
507     but it doesn't mean that execution itself is not correct  
508   */  
509   
510   /**
511    * @dev Translate wei to Stakes
512    * @param input_wei is wei to translate into stakes, 
513    * @return Stakes quantity        
514    */ 
515     function stakeForWei(uint input_wei) public view returns(uint) {
516       return ((input_wei*usdPerEther*100)/1 ether)/lastStakePriceUSCents;    
517     }  
518   /**
519    * @dev Translate Stakes to wei
520    * @param input_stake is stakes to translate into wei
521    * @return wei quantity        
522    */ 
523     function weiForStake(uint input_stake) public view returns(uint) {
524       return (input_stake*lastStakePriceUSCents*1 ether)/(usdPerEther*100);    
525     } 
526   /**
527    * @dev Transfer wei from this contract to pool wallet partially only, 
528    *      1) for funding promotion of Stakes sale   
529    *      2) according to share (finance_periods_last + current_finance_period) / business_planned_period
530    */    
531     function transferToPool() public onlyOwner {      
532       uint max_available; // max_available funds for transfering to pool    
533       uint amountToTransfer; // amount to transfer to pool
534         // search end timestamp of current financial period
535         for(uint8 i=0; i <= financePeriodsCount; i++) {
536           // found end timestamp of current financial period OR now is later then business planned end date (transfer wei remnant)
537           if(now < financePeriodsTimestamps[i] || (i == financePeriodsCount && now > financePeriodsTimestamps[i])) {   
538             // avaialbe only part of total value of total invested funds with substracted total allowed amount transfered
539             max_available = ((i+1)*(totalInvested+totalWithdrawn-allowedAmountTransferedToPoolTotal))/(financePeriodsCount+1); 
540             // not all max_available funds are transfered at the moment OR we have allowed amount to transfer
541             if(max_available > transferedToPool-allowedAmountTransferedToPoolTotal || allowedAmountToTransferToPool > 0) {
542               if(allowedAmountToTransferToPool > 0) { // we have allowed by Investor (rejected to withdraw) amount
543                 amountToTransfer = allowedAmountToTransferToPool; // to transfer this allowed amount 
544                 allowedAmountTransferedToPoolTotal += allowedAmountToTransferToPool; // add allowed amount to total allowed amount
545                 allowedAmountToTransferToPool = 0;                  
546               } else {
547                 amountToTransfer = max_available-transferedToPool; // only remained amount is available to transfer
548               }
549               if(amountToTransfer > this.balance || now > financePeriodsTimestamps[i]) { // remained amount to transfer more then current balance
550                 amountToTransfer = this.balance; // correct amount to transfer  
551               }
552               transferedToPool += amountToTransfer; // increase transfered to pool amount               
553               pool.transfer(amountToTransfer);                        
554               TransferedToPool(amountToTransfer, i+1);
555             }
556             allowedAmountToTransferToPool=0;
557             break;    
558           }
559         }     
560     }  
561   /**
562    * @dev Investor can withdraw part of his/her investment.
563    *      A size of this part depends on how many financial periods last and how many remained.
564    *      Investor gives back all stakes which he/she got for his/her investment.     
565    */       
566     function withdrawInvestment() public {
567       require(!rejectedInvestmentWithdrawals[msg.sender]); // this Investor not rejected to withdraw their investment
568       require(saleStat[msg.sender].stakes > 0);
569       require(balances[msg.sender] >= saleStat[msg.sender].stakes+saleStat[msg.sender].bonusStakes); // Investor has needed stakes to return
570       uint remained; // all investment which are available to withdraw by all Investors
571       uint to_withdraw; // available funds to withdraw for this particular Investor
572       for(uint8 i=0; i < financePeriodsCount; i++) { // last fin. period is not available
573         if(now<financePeriodsTimestamps[i]) { // find end timestamp of current financial period          
574           remained = totalInvested - ((i+1)*totalInvested)/(financePeriodsCount+1); // remained investment to withdraw by all Investors 
575           to_withdraw = (saleStat[msg.sender].invested*remained)/totalInvested; // investment to withdraw by this Investor
576           uint sale_stakes_to_burn = saleStat[msg.sender].stakes+saleStat[msg.sender].bonusStakes; // returning all Stakes saved in saleStat[msg.sender]
577           uint team_stakes_to_burn = (saleStat[msg.sender].stakes*teamShare)/saleShare; // appropriate issued team Stakes are also burned
578           uint fundaria_stakes_to_burn = (saleStat[msg.sender].stakes*fundariaShare)/saleShare; // appropriate issued Fundaria Stakes are also burned
579           balances[owner] = balances[owner].sub(team_stakes_to_burn); // burn appropriate team Stakes
580           balances[fundaria] = balances[fundaria].sub(fundaria_stakes_to_burn); // burn appropriate Fundaria Stakes
581           Burn(owner,team_stakes_to_burn);
582           Burn(fundaria,fundaria_stakes_to_burn);
583           distributedTeamStakes -= team_stakes_to_burn; // remove team Stakes from distribution
584           distributedFundariaStakes -= fundaria_stakes_to_burn; // remove Fundaria Stakes from distribution         
585           balances[msg.sender] = balances[msg.sender].sub(sale_stakes_to_burn); // burn stakes got for invested wei
586           distributedSaleStakes -= saleStat[msg.sender].stakes; // remove these sale Stakes from distribution          
587           Burn(msg.sender,sale_stakes_to_burn);
588           totalInvested = totalInvested.sub(to_withdraw); // decrease invested total value
589           totalSupply = totalSupply.sub(sale_stakes_to_burn).sub(team_stakes_to_burn).sub(fundaria_stakes_to_burn); // totalSupply is decreased
590           if(saleStat[msg.sender].guide != address(0)) { // we have Guide and bonusStakes
591             // potential reward for the Guide is decreased proportionally
592             guidesStat[saleStat[msg.sender].guide].accumulatedPotentialReward -= (saleStat[msg.sender].guideReward - ((i+1)*saleStat[msg.sender].guideReward)/(financePeriodsCount+1)); 
593             distributedBonusStakes -= saleStat[msg.sender].bonusStakes;
594             saleStat[msg.sender].bonusStakes = 0;
595             saleStat[msg.sender].guideReward = 0;          
596           }
597           saleStat[msg.sender].stakes = 0; // nullify Stakes recieved value          
598           saleStat[msg.sender].invested = 0; // nullify wei invested value
599           totalWithdrawn += to_withdraw;
600           msg.sender.transfer(to_withdraw); // witdraw investment
601           InvestmentWithdrawn(msg.sender, to_withdraw, sale_stakes_to_burn, financePeriodsCount-i);          
602           break;  
603         }
604       }      
605     }
606   /**
607    * @dev Investor rejects withdraw investment. This lets Investment Guide withdraw all his/her reward related to this Investor   
608    */     
609     function rejectInvestmentWithdrawal() public {
610       rejectedInvestmentWithdrawals[msg.sender] = true;
611       address guide = saleStat[msg.sender].guide;
612       if(guide != address(0)) { // Inv. Guide exists
613         if(saleStat[msg.sender].guideReward >= guidesStat[guide].periodicallyWithdrawnReward) { // already withdrawed less then to withdraw for this Investor
614           uint remainedRewardToWithdraw = saleStat[msg.sender].guideReward-guidesStat[guide].periodicallyWithdrawnReward;
615           guidesStat[guide].periodicallyWithdrawnReward = 0; // withdrawn reward is counted as withdrawn of this Investor reward 
616           if(guidesStat[guide].accumulatedPotentialReward >= remainedRewardToWithdraw) { // we have enough potential reward
617             guidesStat[guide].accumulatedPotentialReward -= remainedRewardToWithdraw; // decrease potential reward
618             guidesStat[guide].rewardToWithdraw += remainedRewardToWithdraw;  // increase total amount to withdraw right now
619           } else {
620             guidesStat[guide].accumulatedPotentialReward = 0; // something wrong so nullify
621           }
622         } else {
623           // substract current Investor's reward from periodically withdrawn reward to remove it from withdrawned
624           guidesStat[guide].periodicallyWithdrawnReward -= saleStat[msg.sender].guideReward;
625           // we have enough potential reward - all ok 
626           if(guidesStat[guide].accumulatedPotentialReward >= saleStat[msg.sender].guideReward) {
627             // we do not count this Investor guideReward in potential reward
628             guidesStat[guide].accumulatedPotentialReward -= saleStat[msg.sender].guideReward;
629             guidesStat[guide].rewardToWithdraw += saleStat[msg.sender].guideReward;  // increase total amount to withdraw right now  
630           } else {
631             guidesStat[guide].accumulatedPotentialReward = 0; // something wrong so nullify  
632           }   
633         }
634       }
635       allowedAmountToTransferToPool += saleStat[msg.sender].invested;
636     }
637   
638   /**
639    * @dev Distribute bounty rewards for bounty tasks
640    * @param _to is address of bounty hunter
641    * @param _stakes is quantity of Stakes transfered       
642    */     
643     function distributeBounty(address _to, uint _stakes) public onlyOwner {
644       require(distributedBountyStakes+_stakes <= bountyCap); // no more then maximum capacity can be distributed
645       balances[_to] = balances[_to].add(_stakes); // to
646       totalSupply += _stakes; 
647       distributedBountyStakes += _stakes; // adding to total bounty distributed
648       BountyDistributed(_to, _stakes);
649       Transfer(supplier, _to, _stakes);    
650     } 
651   /**
652    * @dev Unfreeze team & Fundaria Stakes.
653    */      
654     function unFreeze() public onlyOwner {
655       // only after planned period
656       if(now > businessPlannedPeriodEndTimestamp) {
657         teamStakesFrozen = false; // make team stakes available for transfering
658         fundariaStakesFrozen = false; // make Fundaria stakes available for transfering
659       }  
660     }     
661 }