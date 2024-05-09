1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal constant returns (uint256) {
12         // assert(b > 0); // Solidity automatically throws when dividing by 0
13         uint256 c = a / b;
14         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal constant returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 
29 }
30 
31 contract ERC20Basic {
32     uint256 public totalSupply;
33 
34     function balanceOf(address who) constant public returns (uint256);
35 
36     function transfer(address to, uint256 value) public returns (bool);
37 
38     event Transfer(address indexed from, address indexed to, uint256 value);
39 }
40 
41 contract ERC20 is ERC20Basic {
42     function allowance(address owner, address spender) constant public returns (uint256);
43 
44     function transferFrom(address from, address to, uint256 value) public returns (bool);
45 
46     function approve(address spender, uint256 value) public returns (bool);
47 
48     event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 contract Owned {
52 
53     address public owner;
54 
55     address public newOwner;
56 
57     function Owned() public payable {
58         owner = msg.sender;
59     }
60 
61     modifier onlyOwner {
62         require(owner == msg.sender);
63         _;
64     }
65 
66     function changeOwner(address _owner) onlyOwner public {
67         require(_owner != 0);
68         newOwner = _owner;
69     }
70 
71     function confirmOwner() public {
72         require(newOwner == msg.sender);
73         owner = newOwner;
74         delete newOwner;
75     }
76 }
77 
78 contract Blocked {
79 
80     uint public blockedUntil;
81 
82     modifier unblocked {
83         require(now > blockedUntil);
84         _;
85     }
86 }
87 
88 contract BalancingToken is ERC20 {
89     mapping (address => uint256) public balances;      //!< array of all balances
90 
91     function balanceOf(address _owner) public constant returns (uint256 balance) {
92         return balances[_owner];
93     }
94 }
95 
96 contract DividendToken is BalancingToken, Blocked, Owned {
97 
98     using SafeMath for uint256;
99 
100     event DividendReceived(address indexed dividendReceiver, uint256 dividendValue);
101 
102     mapping (address => mapping (address => uint256)) public allowed;
103 
104     uint public totalReward;
105     uint public lastDivideRewardTime;
106 
107     // Fix for the ERC20 short address attack
108     modifier onlyPayloadSize(uint size) {
109         require(msg.data.length >= size + 4);
110         _;
111     }
112 
113     // Fix for the ERC20 short address attack
114     modifier rewardTimePast() {
115         require(now > lastDivideRewardTime + rewardDays);
116         _;
117     }
118 
119     struct TokenHolder {
120         uint256 balance;
121         uint    balanceUpdateTime;
122         uint    rewardWithdrawTime;
123     }
124 
125     mapping(address => TokenHolder) holders;
126 
127     uint public rewardDays = 0;
128 
129     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) unblocked public returns (bool) {
130         return transferSimple(_to, _value);
131     }
132 
133     function transferSimple(address _to, uint256 _value) internal returns (bool) {
134         beforeBalanceChanges(msg.sender);
135         beforeBalanceChanges(_to);
136         balances[msg.sender] = balances[msg.sender].sub(_value);
137         balances[_to] = balances[_to].add(_value);
138         Transfer(msg.sender, _to, _value);
139         return true;
140     }
141 
142     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) unblocked public returns (bool) {
143         beforeBalanceChanges(_from);
144         beforeBalanceChanges(_to);
145         var _allowance = allowed[_from][msg.sender];
146         balances[_to] = balances[_to].add(_value);
147         balances[_from] = balances[_from].sub(_value);
148         allowed[_from][msg.sender] = _allowance.sub(_value);
149         Transfer(_from, _to, _value);
150         return true;
151     }
152 
153     function approve(address _spender, uint256 _value) onlyPayloadSize(2 * 32) unblocked public returns (bool) {
154         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
155         allowed[msg.sender][_spender] = _value;
156         Approval(msg.sender, _spender, _value);
157         return true;
158     }
159 
160     function allowance(address _owner, address _spender) onlyPayloadSize(2 * 32) unblocked constant public returns (uint256 remaining) {
161         return allowed[_owner][_spender];
162     }
163 
164     function reward() constant public returns (uint256) {
165         if (holders[msg.sender].rewardWithdrawTime >= lastDivideRewardTime) {
166             return 0;
167         }
168         uint256 balance;
169         if (holders[msg.sender].balanceUpdateTime <= lastDivideRewardTime) {
170             balance = balances[msg.sender];
171         } else {
172             balance = holders[msg.sender].balance;
173         }
174         return totalReward.mul(balance).div(totalSupply);
175     }
176 
177     function withdrawReward() public returns (uint256) {
178         uint256 rewardValue = reward();
179         if (rewardValue == 0) {
180             return 0;
181         }
182         if (balances[msg.sender] == 0) {
183             // garbage collector
184             delete holders[msg.sender];
185         } else {
186             holders[msg.sender].rewardWithdrawTime = now;
187         }
188         require(msg.sender.call.gas(3000000).value(rewardValue)());
189         DividendReceived(msg.sender, rewardValue);
190         return rewardValue;
191     }
192 
193     // Divide up reward and make it accesible for withdraw
194     function divideUpReward(uint inDays) rewardTimePast onlyOwner external payable {
195         require(inDays >= 15 && inDays <= 45);
196         lastDivideRewardTime = now;
197         rewardDays = inDays;
198         totalReward = this.balance;
199     }
200 
201     function withdrawLeft() rewardTimePast onlyOwner external {
202         require(msg.sender.call.gas(3000000).value(this.balance)());
203     }
204 
205     function beforeBalanceChanges(address _who) public {
206         if (holders[_who].balanceUpdateTime <= lastDivideRewardTime) {
207             holders[_who].balanceUpdateTime = now;
208             holders[_who].balance = balances[_who];
209         }
210     }
211 }
212 
213 contract RENTCoin is DividendToken {
214 
215     string public constant name = "RentAway Coin";
216 
217     string public constant symbol = "RTW";
218 
219     uint32 public constant decimals = 18;
220 
221     function RENTCoin(uint256 initialSupply, uint unblockTime) public {
222         totalSupply = initialSupply;
223         balances[owner] = initialSupply;
224         blockedUntil = unblockTime;
225     }
226 
227     function manualTransfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) onlyOwner public returns (bool) {
228         return transferSimple(_to, _value);
229     }
230 }
231 
232 contract TimingCrowdsale {
233 
234     // Date of start pre-ICO and ICO.
235     uint public constant preICOstartTime = 1517461200; // start at Thursday, February 1, 2018 5:00:00 AM
236     uint public constant ICOstartTime =    1518670800; // start at Thursday, February 15, 2018 5:00:00 AM
237     uint public constant ICOendTime =      1521090000; // end at Thursday, March 15, 2018 5:00:00 AM
238 
239     function currentTime() internal view returns (uint) {
240         return now;
241     }
242 
243     function isPreICO() public view returns (bool) {
244         var curTime = currentTime();
245         return curTime < ICOstartTime && curTime >= preICOstartTime;
246     }
247 
248     function isICO() public view returns (bool) {
249         var curTime = currentTime();
250         return curTime < ICOendTime && curTime >= ICOstartTime;
251     }
252 
253     function isPreICOFinished() public view returns (bool) {
254         return currentTime() > ICOstartTime;
255     }
256 
257     function isICOFinished() public view returns (bool) {
258         return currentTime() > ICOendTime;
259     }
260 }
261 
262 contract BonusCrowdsale is TimingCrowdsale {
263 
264     function getBonus(uint256 amount) public view returns (uint) {
265         uint bonus = getAmountBonus(amount);
266         if (isPreICO()) {
267             bonus += 25;
268         }
269         return bonus;
270     }
271 
272     function getAmountBonus(uint256 amount) public view returns (uint) {
273         if (amount >= 25 ether) {
274             return 15;
275         }
276         if (amount >= 10 ether) {
277             return 5;
278         }
279         return 0;
280     }
281 }
282 
283 contract ManualSendingCrowdsale is BonusCrowdsale, Owned {
284     using SafeMath for uint256;
285 
286     struct AmountData {
287         bool exists;
288         uint256 value;
289     }
290 
291     mapping (uint => AmountData) public amountsByCurrency;
292 
293     function addCurrency(uint currency) external onlyOwner {
294         addCurrencyInternal(currency);
295     }
296 
297     function addCurrencyInternal(uint currency) internal {
298         AmountData storage amountData = amountsByCurrency[currency];
299         amountData.exists = true;
300     }
301 
302     function manualTransferTokensToInternal(address to, uint256 givenTokens, uint currency, uint256 amount) internal returns (uint256) {
303         AmountData memory tempAmountData = amountsByCurrency[currency];
304         require(tempAmountData.exists);
305         AmountData storage amountData = amountsByCurrency[currency];
306         amountData.value = amountData.value.add(amount);
307         return transferTokensTo(to, givenTokens);
308     }
309 
310     function transferTokensTo(address to, uint256 givenTokens) internal returns (uint256);
311 }
312 
313 contract WithdrawCrowdsale is ManualSendingCrowdsale {
314 
315     function isWithdrawAllowed() public view returns (bool);
316 
317     modifier canWithdraw() {
318         require(isWithdrawAllowed());
319         _;
320     }
321 
322     function withdraw() external onlyOwner canWithdraw {
323         require(msg.sender.call.gas(3000000).value(this.balance)());
324     }
325 
326     function withdrawAmount(uint256 amount) external onlyOwner canWithdraw {
327         uint256 givenAmount = amount;
328         if (this.balance < amount) {
329             givenAmount = this.balance;
330         }
331         require(msg.sender.call.gas(3000000).value(givenAmount)());
332     }
333 }
334 
335 contract RefundableCrowdsale is WithdrawCrowdsale {
336 
337     event Refunded(address indexed beneficiary, uint256 weiAmount);
338 
339     mapping (address => uint256) public deposited;
340 
341     function refund(address investor) external {
342         require(isRefundAllowed());
343         uint256 depositedValue = deposited[investor];
344         deposited[investor] = 0;
345         require(investor.call.gas(3000000).value(depositedValue)());
346         Refunded(investor, depositedValue);
347     }
348 
349     function isRefundAllowed() internal view returns (bool);
350 }
351 
352 contract Crowdsale is RefundableCrowdsale {
353 
354     using SafeMath for uint256;
355 
356     enum State { ICO, REFUND, DONE }
357     State public state = State.ICO;
358 
359     uint256 public constant maxTokenAmount = 75000000 * 10**18; // max minting
360     uint256 public constant bountyTokens =   15000000 * 10**18; // bounty amount
361     uint256 public constant softCapTokens =  6000000 * 10**18; // soft cap
362 
363     uint public constant unblockTokenTime = 1519880400; // end at Thursday, March 1, 2018 5:00:00 AM
364 
365     RENTCoin public token;
366 
367     uint256 public leftTokens = 0;
368 
369     uint256 public totalAmount = 0;
370     uint public transactionCounter = 0;
371 
372     bool public bonusesPayed = false;
373 
374     uint256 public constant rateToEther = 1000; // rate to ether, how much tokens gives to 1 ether
375 
376     uint256 public constant minAmountForDeal = 10**16; // 0.01 ETH
377 
378     uint256 public soldTokens = 0;
379 
380     modifier canBuy() {
381         require(!isFinished());
382         require(isPreICO() || isICO());
383         _;
384     }
385 
386     modifier minPayment() {
387         require(msg.value >= minAmountForDeal);
388         _;
389     }
390 
391     function Crowdsale() public {
392         token = new RENTCoin(maxTokenAmount, unblockTokenTime);
393         leftTokens = maxTokenAmount - bountyTokens;
394         addCurrencyInternal(0); // add BTC
395     }
396 
397     function isFinished() public view returns (bool) {
398         return isICOFinished() || (leftTokens == 0 && (state == State.ICO || state == State.DONE));
399     }
400 
401     function isWithdrawAllowed() public view returns (bool) {
402         return soldTokens >= softCapTokens;
403     }
404 
405     function isRefundAllowed() internal view returns (bool) {
406         return state == State.REFUND;
407     }
408 
409     function() external canBuy minPayment payable {
410         address investor = msg.sender;
411         uint256 amount = msg.value;
412         uint bonus = getBonus(amount);
413         uint256 givenTokens = amount.mul(rateToEther).div(100).mul(100 + bonus);
414         uint256 providedTokens = transferTokensTo(investor, givenTokens);
415 
416         if (givenTokens > providedTokens) {
417             uint256 needAmount = providedTokens.mul(100).div(100 + bonus).div(rateToEther);
418             require(amount > needAmount);
419             require(investor.call.gas(3000000).value(amount - needAmount)());
420             amount = needAmount;
421         }
422         totalAmount = totalAmount.add(amount);
423         if (!isWithdrawAllowed()) {
424             deposited[investor] = deposited[investor].add(msg.value);
425         }
426     }
427 
428     function manualTransferTokensTo(address to, uint256 givenTokens, uint currency, uint256 amount) external onlyOwner canBuy returns (uint256) {
429         return manualTransferTokensToInternal(to, givenTokens, currency, amount);
430     }
431 
432     function finishCrowdsale() external {
433         require(isFinished());
434         require(state == State.ICO);
435         if (!isWithdrawAllowed())  {
436             state = State.REFUND;
437             bonusesPayed = true;
438         } else {
439             state = State.DONE;
440         }
441     }
442 
443     function takeBounty() external onlyOwner {
444         require(state == State.DONE);
445         require(now > ICOendTime);
446         require(!bonusesPayed);
447         token.changeOwner(msg.sender);
448         bonusesPayed = true;
449         require(token.transfer(msg.sender, token.balanceOf(this)));
450     }
451 
452     function addToSoldTokens(uint256 providedTokens) internal {
453         soldTokens = soldTokens.add(providedTokens);
454     }
455 
456     function transferTokensTo(address to, uint256 givenTokens) internal returns (uint256) {
457         var providedTokens = givenTokens;
458         if (givenTokens > leftTokens) {
459             providedTokens = leftTokens;
460         }
461         leftTokens = leftTokens.sub(providedTokens);
462         addToSoldTokens(providedTokens);
463         require(token.manualTransfer(to, providedTokens));
464         transactionCounter = transactionCounter + 1;
465         return providedTokens;
466     }
467 }