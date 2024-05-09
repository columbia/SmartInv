1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal pure returns (uint256) {
12         // assert(b > 0); // Solidity automatically throws when dividing by 0
13         uint256 c = a / b;
14         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
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
88 contract BasicToken is ERC20Basic, Blocked {
89 
90     using SafeMath for uint256;
91 
92     mapping (address => uint256) balances;
93 
94     // Fix for the ERC20 short address attack
95     modifier onlyPayloadSize(uint size) {
96         require(msg.data.length >= size + 4);
97         _;
98     }
99 
100     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) unblocked public returns (bool) {
101         balances[msg.sender] = balances[msg.sender].sub(_value);
102         balances[_to] = balances[_to].add(_value);
103         Transfer(msg.sender, _to, _value);
104         return true;
105     }
106 
107     function balanceOf(address _owner) constant public returns (uint256 balance) {
108         return balances[_owner];
109     }
110 
111 }
112 
113 contract StandardToken is ERC20, BasicToken {
114 
115     mapping (address => mapping (address => uint256)) allowed;
116 
117     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) unblocked public returns (bool) {
118         uint256 _allowance = allowed[_from][msg.sender];
119 
120         balances[_to] = balances[_to].add(_value);
121         balances[_from] = balances[_from].sub(_value);
122         allowed[_from][msg.sender] = _allowance.sub(_value);
123         Transfer(_from, _to, _value);
124         return true;
125     }
126 
127     function approve(address _spender, uint256 _value) onlyPayloadSize(2 * 32) unblocked public returns (bool) {
128 
129         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
130 
131         allowed[msg.sender][_spender] = _value;
132         Approval(msg.sender, _spender, _value);
133         return true;
134     }
135 
136     function allowance(address _owner, address _spender) onlyPayloadSize(2 * 32) unblocked constant public returns (uint256 remaining) {
137         return allowed[_owner][_spender];
138     }
139 
140 }
141 
142 contract BurnableToken is StandardToken {
143 
144     event Burn(address indexed burner, uint256 value);
145 
146     function burn(uint256 _value) unblocked public {
147         require(_value > 0);
148         require(_value <= balances[msg.sender]);
149         // no need to require value <= totalSupply, since that would imply the
150         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
151 
152         address burner = msg.sender;
153         balances[burner] = balances[burner].sub(_value);
154         totalSupply = totalSupply.sub(_value);
155         Burn(burner, _value);
156     }
157 }
158 
159 contract DEVCoin is BurnableToken, Owned {
160 
161     string public constant name = "Dev Coin";
162 
163     string public constant symbol = "DEVC";
164 
165     uint32 public constant decimals = 18;
166 
167     function DEVCoin(uint256 initialSupply, uint unblockTime) public {
168         totalSupply = initialSupply;
169         balances[owner] = initialSupply;
170         blockedUntil = unblockTime;
171     }
172 
173     function manualTransfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) onlyOwner public returns (bool) {
174         balances[msg.sender] = balances[msg.sender].sub(_value);
175         balances[_to] = balances[_to].add(_value);
176         Transfer(msg.sender, _to, _value);
177         return true;
178     }
179 }
180 
181 contract ManualSendingCrowdsale is Owned {
182     using SafeMath for uint256;
183 
184     struct AmountData {
185         bool exists;
186         uint256 value;
187     }
188 
189     mapping (uint => AmountData) public amountsByCurrency;
190 
191     function addCurrency(uint currency) external onlyOwner {
192         addCurrencyInternal(currency);
193     }
194 
195     function addCurrencyInternal(uint currency) internal {
196         AmountData storage amountData = amountsByCurrency[currency];
197         amountData.exists = true;
198     }
199 
200     function manualTransferTokensToInternal(address to, uint256 givenTokens, uint currency, uint256 amount) internal returns (uint256) {
201         AmountData memory tempAmountData = amountsByCurrency[currency];
202         require(tempAmountData.exists);
203         AmountData storage amountData = amountsByCurrency[currency];
204         amountData.value = amountData.value.add(amount);
205         return transferTokensTo(to, givenTokens);
206     }
207 
208     function transferTokensTo(address to, uint256 givenTokens) internal returns (uint256);
209 }
210 
211 contract Crowdsale is ManualSendingCrowdsale {
212 
213     using SafeMath for uint256;
214 
215     enum State { PRE_ICO, ICO }
216 
217     State public state = State.PRE_ICO;
218 
219     // Date of start pre-ICO and ICO.
220     uint public constant preICOstartTime =    1522454400; // start at Saturday, March 31, 2018 12:00:00 AM
221     uint public constant preICOendTime =      1523750400; // end at Sunday, April 15, 2018 12:00:00 AM
222     uint public constant ICOstartTime =    1524355200; // start at Tuesday, May 22, 2018 12:00:00 AM
223     uint public constant ICOendTime =      1527033600; // end at Wednesday, May 23, 2018 12:00:00 AM
224 
225     uint public constant bountyAvailabilityTime = ICOendTime + 90 days;
226 
227     uint256 public constant maxTokenAmount = 108e24; // max minting   (108, 000, 000 tokens)
228     uint256 public constant bountyTokens =   324e23; // bounty amount ( 32, 400, 000 tokens)
229 
230     uint256 public constant maxPreICOTokenAmount = 81e23; // max number of tokens on pre-ICO (8, 100, 000 tokens);
231 
232     DEVCoin public token;
233 
234     uint256 public leftTokens = 0;
235 
236     uint256 public totalAmount = 0;
237     uint public transactionCounter = 0;
238 
239     /** ------------------------------- */
240     /** Bonus part: */
241 
242     // Amount bonuses
243     uint private firstAmountBonus = 20;
244     uint256 private firstAmountBonusBarrier = 500 ether;
245     uint private secondAmountBonus = 15;
246     uint256 private secondAmountBonusBarrier = 100 ether;
247     uint private thirdAmountBonus = 10;
248     uint256 private thirdAmountBonusBarrier = 50 ether;
249     uint private fourthAmountBonus = 5;
250     uint256 private fourthAmountBonusBarrier = 20 ether;
251 
252     // pre-ICO bonuses by time
253     uint private firstPreICOTimeBarrier = preICOstartTime + 1 days;
254     uint private firstPreICOTimeBonus = 20;
255     uint private secondPreICOTimeBarrier = preICOstartTime + 7 days;
256     uint private secondPreICOTimeBonus = 10;
257     uint private thirdPreICOTimeBarrier = preICOstartTime + 14 days;
258     uint private thirdPreICOTimeBonus = 5;
259 
260     // ICO bonuses by time
261     uint private firstICOTimeBarrier = ICOstartTime + 1 days;
262     uint private firstICOTimeBonus = 15;
263     uint private secondICOTimeBarrier = ICOstartTime + 7 days;
264     uint private secondICOTimeBonus = 7;
265     uint private thirdICOTimeBarrier = ICOstartTime + 14 days;
266     uint private thirdICOTimeBonus = 4;
267 
268     /** ------------------------------- */
269 
270     bool public bonusesPayed = false;
271 
272     uint256 public constant rateToEther = 9000; // rate to ether, how much tokens gives to 1 ether
273 
274     uint256 public constant minAmountForDeal = 10**17;
275 
276     modifier canBuy() {
277         require(!isFinished());
278         require(isPreICO() || isICO());
279         _;
280     }
281 
282     modifier minPayment() {
283         require(msg.value >= minAmountForDeal);
284         _;
285     }
286 
287     function Crowdsale() public {
288         //require(currentTime() < preICOstartTime);
289         token = new DEVCoin(maxTokenAmount, ICOendTime);
290         leftTokens = maxPreICOTokenAmount;
291         addCurrencyInternal(0); // add BTC
292     }
293 
294     function isFinished() public constant returns (bool) {
295         return currentTime() > ICOendTime || (leftTokens == 0 && state == State.ICO);
296     }
297 
298     function isPreICO() public constant returns (bool) {
299         uint curTime = currentTime();
300         return curTime < preICOendTime && curTime > preICOstartTime;
301     }
302 
303     function isICO() public constant returns (bool) {
304         uint curTime = currentTime();
305         return curTime < ICOendTime && curTime > ICOstartTime;
306     }
307 
308     function() external canBuy minPayment payable {
309         uint256 amount = msg.value;
310         uint bonus = getBonus(amount);
311         uint256 givenTokens = amount.mul(rateToEther).div(100).mul(100 + bonus);
312         uint256 providedTokens = transferTokensTo(msg.sender, givenTokens);
313 
314         if (givenTokens > providedTokens) {
315             uint256 needAmount = providedTokens.mul(100).div(100 + bonus).div(rateToEther);
316             require(amount > needAmount);
317             require(msg.sender.call.gas(3000000).value(amount - needAmount)());
318             amount = needAmount;
319         }
320         totalAmount = totalAmount.add(amount);
321     }
322 
323     function manualTransferTokensToWithBonus(address to, uint256 givenTokens, uint currency, uint256 amount) external canBuy onlyOwner returns (uint256) {
324         uint bonus = getBonus(0);
325         uint256 transferedTokens = givenTokens.mul(100 + bonus).div(100);
326         return manualTransferTokensToInternal(to, transferedTokens, currency, amount);
327     }
328 
329     function manualTransferTokensTo(address to, uint256 givenTokens, uint currency, uint256 amount) external onlyOwner canBuy returns (uint256) {
330         return manualTransferTokensToInternal(to, givenTokens, currency, amount);
331     }
332 
333     function getBonus(uint256 amount) public constant returns (uint) {
334         uint bonus = 0;
335         if (isPreICO()) {
336             bonus = getPreICOBonus();
337         }
338 
339         if (isICO()) {
340             bonus = getICOBonus();
341         }
342         return bonus + getAmountBonus(amount);
343     }
344 
345     function getAmountBonus(uint256 amount) public constant returns (uint) {
346         if (amount >= firstAmountBonusBarrier) {
347             return firstAmountBonus;
348         }
349         if (amount >= secondAmountBonusBarrier) {
350             return secondAmountBonus;
351         }
352         if (amount >= thirdAmountBonusBarrier) {
353             return thirdAmountBonus;
354         }
355         if (amount >= fourthAmountBonusBarrier) {
356             return fourthAmountBonus;
357         }
358         return 0;
359     }
360 
361     function getPreICOBonus() public constant returns (uint) {
362         uint curTime = currentTime();
363         if (curTime < firstPreICOTimeBarrier) {
364             return firstPreICOTimeBonus;
365         }
366         if (curTime < secondPreICOTimeBarrier) {
367             return secondPreICOTimeBonus;
368         }
369         if (curTime < thirdPreICOTimeBarrier) {
370             return thirdPreICOTimeBonus;
371         }
372         return 0;
373     }
374 
375     function getICOBonus() public constant returns (uint) {
376         uint curTime = currentTime();
377         if (curTime < firstICOTimeBarrier) {
378             return firstICOTimeBonus;
379         }
380         if (curTime < secondICOTimeBarrier) {
381             return secondICOTimeBonus;
382         }
383         if (curTime < thirdICOTimeBarrier) {
384             return thirdICOTimeBonus;
385         }
386         return 0;
387     }
388 
389     function finishCrowdsale() external {
390         require(isFinished());
391         require(state == State.ICO);
392         if (leftTokens > 0) {
393             token.burn(leftTokens);
394             leftTokens = 0;
395         }
396     }
397 
398     function takeBounty() external onlyOwner {
399         require(isFinished());
400         require(state == State.ICO);
401         require(now > bountyAvailabilityTime);
402         require(!bonusesPayed);
403         bonusesPayed = true;
404         require(token.transfer(msg.sender, bountyTokens));
405     }
406 
407     function startICO() external {
408         require(currentTime() > preICOendTime);
409         require(state == State.PRE_ICO && leftTokens <= maxPreICOTokenAmount);
410         leftTokens = leftTokens.add(maxTokenAmount).sub(maxPreICOTokenAmount).sub(bountyTokens);
411         state = State.ICO;
412     }
413 
414     function transferTokensTo(address to, uint256 givenTokens) internal returns (uint256) {
415         uint256 providedTokens = givenTokens;
416         if (givenTokens > leftTokens) {
417             providedTokens = leftTokens;
418         }
419         leftTokens = leftTokens.sub(providedTokens);
420         require(token.manualTransfer(to, providedTokens));
421         transactionCounter = transactionCounter + 1;
422         return providedTokens;
423     }
424 
425     function withdraw() external onlyOwner {
426         require(msg.sender.call.gas(3000000).value(address(this).balance)());
427     }
428 
429     function withdrawAmount(uint256 amount) external onlyOwner {
430         uint256 givenAmount = amount;
431         if (address(this).balance < amount) {
432             givenAmount = address(this).balance;
433         }
434         require(msg.sender.call.gas(3000000).value(givenAmount)());
435     }
436 
437     function currentTime() internal constant returns (uint) {
438         return now;
439     }
440 }