1 /*
2 
3 Copyright (c) 2017 Esperite Ltd. <legal@esperite.co.nz>
4 
5 THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
6 WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
7 MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
8 ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
9 WHATSOEVER RESULTING FROM LOSS OF USE, PROCUREMENT OF SUBSTITUTE GOODS OR
10 SERVICES, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE
11 OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
12 PERFORMANCE OF THIS SOFTWARE.
13 
14 */
15 
16 pragma solidity ^0.4.13;
17 
18 library SafeMath {
19   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
20     uint256 c = a * b;
21     assert(a == 0 || c / a == b);
22     return c;
23   }
24 
25   function div(uint256 a, uint256 b) internal constant returns (uint256) {
26     uint256 c = a / b;
27     return c;
28   }
29 
30   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint256 a, uint256 b) internal constant returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40 }
41 
42 contract ERC223ReceivingContract {
43     function tokenFallback(address _from, uint256 _value, bytes _data) public;
44 }
45 
46 contract ERC20ERC223 {
47   uint256 public totalSupply;
48   function balanceOf(address _owner) public constant returns (uint256);
49   function transfer(address _to, uint256 _value) public returns (bool);
50   function transfer(address _to, uint256 _value, bytes _data) public returns (bool);
51   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
52   function approve(address _spender, uint256 _value) public returns (bool success);
53   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
54   
55   event Transfer(address indexed _from, address indexed _to, uint256 indexed _value);
56   event Transfer(address indexed _from, address indexed _to, uint256 indexed _value, bytes _data);
57   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
58 }
59 
60 contract Deco is ERC20ERC223 {
61 
62   using SafeMath for uint256;
63 
64   string public constant name = "Deco";
65   string public constant symbol = "DEC";
66   uint8 public constant decimals = 18;
67   
68   uint256 public constant totalSupply = 6*10**26; // 600,000,000. 000,000,000,000,000,000 units
69     
70   // Accounts
71   
72   mapping(address => Account) private accounts;
73   
74   struct Account {
75     uint256 balance;
76     mapping(address => uint256) allowed;
77     mapping(address => bool) isAllowanceAuthorized;
78   }  
79   
80   // Fix for the ERC20 short address attack.
81   // http://vessenes.com/the-erc20-short-address-attack-explained/
82   modifier onlyPayloadSize(uint256 size) {
83     require(msg.data.length >= size + 4);
84      _;
85   }
86 
87   // Initialization
88 
89   function Deco() {
90     accounts[msg.sender].balance = totalSupply;
91     Transfer(this, msg.sender, totalSupply);
92   }
93 
94   // Balance
95 
96   function balanceOf(address _owner) constant returns (uint256) {
97     return accounts[_owner].balance;
98   }
99 
100   // Transfers
101 
102   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {
103     performTransfer(msg.sender, _to, _value, "");
104     Transfer(msg.sender, _to, _value);
105     return true;
106   }
107 
108   function transfer(address _to, uint256 _value, bytes _data) onlyPayloadSize(2 * 32) returns (bool) {
109     performTransfer(msg.sender, _to, _value, _data);
110     Transfer(msg.sender, _to, _value, _data);
111     return true;
112   }
113 
114   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool) {
115     require(hasApproval(_from, msg.sender));
116     uint256 _allowed = accounts[_from].allowed[msg.sender];    
117     performTransfer(_from, _to, _value, "");    
118     accounts[_from].allowed[msg.sender] = _allowed.sub(_value);
119     Transfer(_from, _to, _value);
120     return true;
121   }
122 
123   function performTransfer(address _from, address _to, uint256 _value, bytes _data) private returns (bool) {
124     require(_to != 0x0);
125     accounts[_from].balance = accounts[_from].balance.sub(_value);    
126     accounts[_to].balance = accounts[_to].balance.add(_value);
127     if (isContract(_to)) {
128       ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
129       receiver.tokenFallback(_from, _value, _data);
130     }    
131     return true;
132   }
133 
134   function isContract(address _to) private constant returns (bool) {
135     uint256 codeLength;
136     assembly {
137       codeLength := extcodesize(_to)
138     }
139     return codeLength > 0;
140   }
141 
142   // Approval & Allowance
143   
144   function approve(address _spender, uint256 _value) returns (bool) {
145     require(msg.sender != _spender);
146     // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147     if ((_value != 0) && (accounts[msg.sender].allowed[_spender] != 0)) {
148       revert();
149       return false;
150     }
151     accounts[msg.sender].allowed[_spender] = _value;
152     accounts[msg.sender].isAllowanceAuthorized[_spender] = true;
153     Approval(msg.sender, _spender, _value);
154     return true;
155   }
156 
157   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
158     return accounts[_owner].allowed[_spender];
159   }
160 
161   function hasApproval(address _owner, address _spender) constant returns (bool) {        
162     return accounts[_owner].isAllowanceAuthorized[_spender];
163   }
164 
165   function removeApproval(address _spender) {    
166     delete(accounts[msg.sender].allowed[_spender]);
167     accounts[msg.sender].isAllowanceAuthorized[_spender] = false;
168   }
169 
170 }
171 
172 contract DecoBank {
173   
174   using SafeMath for uint256;
175 
176   Deco public token;  
177   
178   address private crowdsaleWallet;
179   address private decoReserveWallet;
180   uint256 public weiRaised;
181 
182   uint256 public constant totalSupplyUnits = 6*10**26;
183   uint256 private constant MINIMUM_WEI = 10**16;
184   uint256 private constant BASE = 10**18;
185   uint256 public originalRate = 3000;
186 
187   uint256 public crowdsaleDistributedUnits = 0;
188   uint256 public issuerDistributedUnits = 0;
189 
190   // Presale
191   uint256 public presaleStartTime;
192   uint256 public presaleEndTime;
193   uint256 private presaleDiscount = 50;
194   uint256 private presalePercentage = 5;
195 
196   uint256 public issuerReservedMaximumPercentage = 5;
197 
198   // Sale
199   uint256 public saleStartTime;
200   uint256 public saleEndTime;
201   uint256 private saleDiscount = 25;
202 
203   // Rewards
204   uint256 public rewardDistributionStart;
205   uint256 public rewardDistributedUnits = 0;  
206 
207   // Contributors
208   mapping(address => Contributor) private contributors;
209 
210   struct Contributor {    
211     uint256 contributedWei;
212     uint256 decoUnits;
213     uint256 rewardDistributedDecoUnits;
214   }
215 
216   uint256 public contributorsCount = 0;
217 
218   // Events
219   event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
220   event RewardDistributed(address indexed beneficiary, uint256 amount);
221   event RemainingRewardOwnershipChanged(address indexed from, address indexed to);  
222 
223   address private contractCreator = msg.sender;
224 
225   function DecoBank() {
226     token = new Deco();
227 
228     presaleStartTime = 1506816000; // Sunday, October 1, 2017 12:00:00 AM
229     presaleEndTime = presaleStartTime + 30 days;
230 
231     saleStartTime = presaleEndTime + 1 days;
232     saleEndTime = saleStartTime + 180 days;
233 
234     rewardDistributionStart = saleEndTime + 1 days;
235 
236     crowdsaleWallet = 0xEaC4ff9Aa8342d8B5c59370Ac04a55367A788B30;
237     decoReserveWallet = 0xDA01fDeEF573b5cC51D0Ddc2600F476aaC71A600;
238   }
239 
240   // Sale events
241 
242   modifier validPurchase() {
243     require(isValidPurchase());
244     _;
245   }
246   
247   function isValidPurchase() private returns (bool) {
248     bool minimumContribution = msg.value >= MINIMUM_WEI;
249     return minimumContribution && (presaleActive() || saleActive());
250   }  
251 
252   function() payable validPurchase {
253     require(msg.sender != 0x0);
254     buyTokens(msg.sender);
255   }
256 
257   function buyTokens(address beneficiary) private {    
258     uint256 weiAmount = msg.value;    
259     uint256 tokens = weiAmount.mul(currentRate());
260     uint256 issuerReserveTokens = unitsForIssuerReserve(tokens);
261     
262     require(crowdsaleDistributedUnits.add(tokens).add(issuerReserveTokens) <= totalSupplyUnits);
263 
264     incrementContributorsCount(beneficiary);
265 
266     contributors[beneficiary].decoUnits = contributors[beneficiary].decoUnits.add(tokens);
267     contributors[beneficiary].contributedWei = contributors[beneficiary].contributedWei.add(weiAmount);
268 
269     issuerDistributedUnits = issuerDistributedUnits.add(issuerReserveTokens);
270     crowdsaleDistributedUnits = crowdsaleDistributedUnits.add(tokens).add(issuerReserveTokens);
271     weiRaised = weiRaised.add(weiAmount);
272             
273     TokenPurchase(beneficiary, weiAmount, tokens);
274     
275     crowdsaleWallet.transfer(weiAmount);
276     token.transfer(beneficiary, tokens);
277     if (issuerReserveTokens != 0) {
278       token.transfer(decoReserveWallet, issuerReserveTokens);
279     }            
280   }
281 
282   function incrementContributorsCount(address _address) private {
283     if (contributors[_address].contributedWei == 0) {
284       contributorsCount = contributorsCount.add(1);
285     }
286   }
287 
288   function contributedWei(address _address) constant public returns (uint256) {
289     return contributors[_address].contributedWei;
290   }
291 
292   function distibutedDecoUnits(address _address) constant public returns (uint256) {
293     return contributors[_address].decoUnits;
294   }
295 
296   function circulatingSupply() constant public returns (uint256) {
297     return crowdsaleDistributedUnits.add(rewardDistributedUnits);
298   }
299 
300   function currentDiscountPercentage() public constant returns (uint256) {
301     if (presaleStartTime > now) { return presaleDiscount; }
302     if (presaleActive()) { return presaleDiscount; }
303     uint256 discountSub = saleStage().mul(5);
304     uint256 discount = saleDiscount.sub(discountSub);
305     return discount;
306   }
307 
308   function currentRate() public constant returns (uint256) {
309     uint256 x = (BASE.mul(100).sub(currentDiscountPercentage().mul(BASE))).div(100);
310     return originalRate.mul(BASE).div(x);
311   }
312 
313   // Presale
314 
315   function presaleLimitUnits() public constant returns (uint256) {
316     return totalSupplyUnits.div(100).mul(presalePercentage);
317   }
318 
319   function shouldEndPresale() private constant returns (bool) {
320     if ((crowdsaleDistributedUnits.sub(issuerDistributedUnits) >= presaleLimitUnits()) || (now >= presaleEndTime)) {
321       return true;
322     } else {
323       return false;
324     }
325   }
326 
327   function presaleActive() public constant returns (bool) {
328     bool inRange = now >= presaleStartTime && now < presaleEndTime;
329     return inRange && shouldEndPresale() == false;
330   }
331 
332   // Sale
333 
334   function unitsLimitForCurrentSaleStage() public constant returns (uint256) {
335     return totalSupplyUnits.div(100).mul(currentMaximumSalePercentage());
336   }
337 
338   function maximumSaleLimitUnits() public constant returns (uint256) {
339     return totalSupplyUnits.div(100).mul(50);
340   }
341 
342   function currentMaximumSalePercentage() public constant returns (uint256) {
343     return saleStage().mul(8).add(10);
344   }
345 
346   function saleLimitReachedForCurrentStage() public constant returns (bool) {
347     return (crowdsaleDistributedUnits.sub(issuerDistributedUnits) >= unitsLimitForCurrentSaleStage());
348   }
349 
350   function currentSaleStage() constant public returns (uint256) {
351     return saleStage().add(1);
352   }
353 
354   function saleStage() private returns (uint256) {
355     uint256 delta = saleEndTime.sub(saleStartTime);
356     uint256 stageStep = delta.div(6);
357     int256 stageDelta = int256(now - saleStartTime);
358     if ((stageDelta <= 0) || (stageStep == 0)) {
359       return 0;
360     } else {
361       uint256 reminder = uint256(stageDelta) % stageStep;
362       uint256 dividableDelta = uint256(stageDelta).sub(reminder);
363       uint256 stage = dividableDelta.div(stageStep);
364       if (stage <= 5) {
365         return stage;
366       } else {
367         return 5;
368       }
369     }
370   }
371 
372   function saleActive() public constant returns (bool) {
373     bool inRange = now >= saleStartTime && now < saleEndTime;        
374     return inRange && saleLimitReachedForCurrentStage() == false;
375   }
376 
377   // Issuer Reserve
378 
379   function unitsForIssuerReserve(uint256 _tokensForDistribution) private returns (uint256) {
380     uint256 residue = maximumIssuerReservedUnits().sub(issuerDistributedUnits);
381     uint256 toIssuer = _tokensForDistribution.div(100).mul(10);
382     if (residue > toIssuer) {
383       return toIssuer;
384     } else {
385       return residue;
386     }
387   }
388 
389   function maximumIssuerReservedUnits() public constant returns (uint256) {
390     return totalSupplyUnits.div(100).mul(issuerReservedMaximumPercentage);
391   }
392 
393   // Reward distribution
394 
395   modifier afterSale() {
396     require(rewardDistributionStarted());
397     _;
398   }
399 
400   function rewardDistributionStarted() public constant returns (bool) {
401     return now >= rewardDistributionStart;
402   }
403 
404   function requestReward() afterSale external {
405     if ((msg.sender == contractCreator) && (rewardDistributionEnded())) {
406       sendNotDistributedUnits();
407     } else {
408       rewardDistribution(msg.sender);
409     }    
410   }
411 
412   function rewardDistribution(address _address) private {
413     require(contributors[_address].contributedWei > 0);    
414     uint256 reward = payableReward(_address);
415     require(reward > 0);
416     sendReward(_address, reward);
417   }
418 
419   function sendNotDistributedUnits() private {
420     require(msg.sender == contractCreator);
421     uint256 balance = token.balanceOf(this);
422     RewardDistributed(contractCreator, balance);
423     sendReward(contractCreator, balance);
424   }
425 
426   function payableReward(address _address) afterSale constant public returns (uint256) {
427     uint256 unitsLeft = totalUnitsLeft();
428     if (unitsLeft < 10**4) {
429       return unitsLeft;
430     }
431     uint256 totalReward = contributorTotalReward(_address);
432     uint256 paidBonus = contributors[_address].rewardDistributedDecoUnits;
433     uint256 totalRewardLeft = totalReward.sub(paidBonus);
434     uint256 bonusPerDay = totalReward.div(rewardDays());
435     if ((totalRewardLeft > 0) && ((bonusPerDay == 0) || (rewardDaysLeft() == 0))) {
436       return totalRewardLeft;
437     }
438     uint256 totalPayable = rewardPayableDays().mul(bonusPerDay);
439     uint256 reward = totalPayable.sub(paidBonus);
440     return reward;
441   }
442 
443   function sendReward(address _address, uint256 _value) private {
444     contributors[_address].rewardDistributedDecoUnits = contributors[_address].rewardDistributedDecoUnits.add(_value);
445     rewardDistributedUnits = rewardDistributedUnits.add(_value); 
446     RewardDistributed(_address, _value);
447     token.transfer(_address, _value);
448   }
449 
450   function rewardPayableDays() constant public returns (uint256) {
451     uint256 payableDays = rewardDays().sub(rewardDaysLeft());
452     if (payableDays == 0) {
453       payableDays = 1;
454     }
455     if (payableDays > rewardDays()) {
456       payableDays = rewardDays();
457     }
458     return payableDays;
459   }
460 
461   function rewardDays() constant public returns (uint256) {
462     uint256 rate = rewardUnitsRatePerYear();
463     if (rate == 0) {
464       return 80 * 365; // Initial assumption
465     }
466     uint256 daysToComplete = (totalSupplyUnits.sub(crowdsaleDistributedUnits)).mul(365).div(rate);
467     return daysToComplete;
468   }
469 
470   function rewardUnitsRatePerYear() constant public returns (uint256) {
471     return crowdsaleDistributedUnits.div(100);
472   }
473 
474   function currentRewardReleasePercentageRatePerYear() afterSale constant external returns (uint256) {
475     return rewardUnitsRatePerYear().mul(10**18).div(circulatingSupply()).mul(100); // Divide by 10**18 to get the actual decimal % value
476   }
477 
478   function rewardDistributionEnd() constant public returns (uint256) {
479     uint256 secondsToComplete = rewardDays().mul(1 days);
480     return rewardDistributionStart.add(secondsToComplete);
481   }
482 
483   function changeRemainingDecoRewardOwner(address _newOwner, string _confirmation) afterSale external {
484     require(_newOwner != 0x0);
485     require(sha3(_confirmation) == sha3("CONFIRM"));
486     require(_newOwner != address(this));
487     require(_newOwner != address(token));    
488     require(contributors[_newOwner].decoUnits == 0);
489     require(contributors[msg.sender].decoUnits > 0);
490     require(token.balanceOf(_newOwner) > 0); // The new owner must have some number of DECO tokens. It proofs that _newOwner address is real.
491     contributors[_newOwner] = contributors[msg.sender];
492     delete(contributors[msg.sender]);
493     RemainingRewardOwnershipChanged(msg.sender, _newOwner);
494   }  
495 
496   function totalUnitsLeft() constant public returns (uint256) {
497     int256 units = int256(totalSupplyUnits) - int256((rewardDistributedUnits.add(crowdsaleDistributedUnits))); 
498     if (units < 0) {
499       return token.balanceOf(this);
500     }
501     return uint256(units);
502   }
503 
504   function rewardDaysLeft() constant public returns (uint256) {
505     if (now < rewardDistributionStart) {
506       return rewardDays();
507     }
508     int256 left = (int256(rewardDistributionEnd()) - int256(now)) / 1 days;
509     if (left < 0) {
510       left = 0;
511     }
512     return uint256(left);
513   }
514 
515   function contributorTotalReward(address _address) constant public returns (uint256) {
516     uint256 proportion = contributors[_address].decoUnits.mul(10**32).div(crowdsaleDistributedUnits.sub(issuerDistributedUnits));
517     uint256 leftForBonuses = totalSupplyUnits.sub(crowdsaleDistributedUnits);
518     uint256 reward = leftForBonuses.mul(proportion).div(10**32);
519     uint256 totalLeft = totalSupplyUnits - (rewardDistributedUnits.add(reward).add(crowdsaleDistributedUnits));
520     if (totalLeft < 10**4) {
521       reward = reward.add(totalLeft);
522     }    
523     return reward;
524   }
525 
526   function contributorDistributedReward(address _address) constant public returns (uint256) {
527     return contributors[_address].rewardDistributedDecoUnits;
528   }  
529 
530   function rewardDistributionEnded() public constant returns (bool) {
531     return now > rewardDistributionEnd();
532   }
533 
534 }