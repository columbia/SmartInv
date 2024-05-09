1 pragma solidity ^0.4.18;
2 
3 contract SafeMath {
4     uint256 constant public MAX_UINT256 =
5     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
6 
7     function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {
8         if (x > MAX_UINT256 - y) throw;
9         return x + y;
10     }
11 
12     function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {
13         if (x < y) throw;
14         return x - y;
15     }
16 
17     function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {
18         if (y == 0) return 0;
19         if (x > MAX_UINT256 / y) throw;
20         return x * y;
21     }
22 
23     function safeDiv(uint256 x, uint256 y) constant internal returns (uint256 z) {
24         uint256 f = x / y;
25         return f;
26       }
27     }
28 
29 contract ERC223ReceivingContract {
30 
31     struct inr {
32         address sender;
33         uint value;
34         bytes data;
35         bytes4 sig;
36     }
37 
38       function tokenFallback(address _from, uint _value, bytes _data){
39       inr memory igniter;
40       igniter.sender = _from;
41       igniter.value = _value;
42       igniter.data = _data;
43       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
44       igniter.sig = bytes4(u);
45 
46     }
47   }
48 
49 contract iGniter is SafeMath {
50 
51   struct serPayment {
52     uint256 unlockedBlockNumber;
53   }
54 
55   struct dividends {
56     uint256 diviReg;
57     uint256 diviBlocks;
58     uint256 diviPayout;
59     uint256 diviBalance;
60     uint256 _tier1Reg;
61     uint256 _tier2Reg;
62     uint256 _tier3Reg;
63     uint256 _tier4Reg;
64     uint256 _tier5Reg;
65     uint256 _tier1Payout;
66     uint256 _tier2Payout;
67     uint256 _tier3Payout;
68     uint256 _tier4Payout;
69     uint256 _tier5Payout;
70     uint256 _tier1Blocks;
71     uint256 _tier2Blocks;
72     uint256 _tier3Blocks;
73     uint256 _tier4Blocks;
74     uint256 _tier5Blocks;
75     uint256 _tierPayouts;
76     uint256 hodlPayout;
77     uint256 _hodlReg;
78     uint256 _hodlBlocks;
79   }
80 
81     string public name;
82     bytes32 public symbol;
83     uint8 public decimals;
84     uint256 private dividendsPerBlockPerAddress;
85     uint256 private T1DividendsPerBlockPerAddress;
86     uint256 private T2DividendsPerBlockPerAddress;
87     uint256 private T3DividendsPerBlockPerAddress;
88     uint256 private T4DividendsPerBlockPerAddress;
89     uint256 private T5DividendsPerBlockPerAddress;
90     uint256 private hodlersDividendsPerBlockPerAddress;
91     uint256 private totalInitialAddresses;
92     uint256 private initialBlockCount;
93     uint256 private minedBlocks;
94     uint256 private iGniting;
95     uint256 private totalRewards;
96     uint256 private initialSupplyPerAddress;
97     uint256 private availableAmount;
98     uint256 private burnt;
99     uint256 private inrSessions;
100     uint256 private availableBalance;
101     uint256 private initialSupply;
102     uint256 public currentCost;
103     uint256 private startBounty;
104     uint256 private finishBounty;
105     uint256 private blockStats;
106     uint256 private blockAverage;
107     uint256 private blockAvgDiff;
108     uint256 private divRewards;
109     uint256 private diviClaims;
110     uint256 private Tier1Amt;
111     uint256 private Tier2Amt;
112     uint256 private Tier3Amt;
113     uint256 private Tier4Amt;
114     uint256 private Tier5Amt;
115     uint256 private Tier1blocks;
116     uint256 private Tier2blocks;
117     uint256 private Tier3blocks;
118     uint256 private Tier4blocks;
119     uint256 private Tier5blocks;
120     uint256 private hodlBlocks;
121     uint256 private hodlersReward;
122     uint256 private hodlAmt;
123 
124     uint256 private _tier1Avg;
125     uint256 private _tier1AvgDiff;
126     uint256 private _tier1Rewards;
127     uint256 private _tier2Avg;
128     uint256 private _tier2AvgDiff;
129     uint256 private _tier2Rewards;
130     uint256 private _tier3Avg;
131     uint256 private _tier3AvgDiff;
132     uint256 private _tier3Rewards;
133     uint256 private _tier4Avg;
134     uint256 private _tier4AvgDiff;
135     uint256 private _tier4Rewards;
136     uint256 private _tier5Avg;
137     uint256 private _tier5AvgDiff;
138     uint256 private _tier5Rewards;
139     uint256 private _hodlAvg;
140     uint256 private _hodlAvgDiff;
141     uint256 private _hodlRewards;
142 
143     bool private t1active;
144     bool private t2active;
145     bool private t3active;
146     bool private t4active;
147     bool private t5active;
148 
149     mapping(address => uint256) public balanceOf;
150     mapping(address => bool) public initialAddress;
151     mapping(address => bool) public dividendAddress;
152     mapping(address => bool) public qualifiedAddress;
153     mapping(address => bool) public TierStarterDividendAddress;
154     mapping(address => bool) public TierBasicDividendAddress;
155     mapping(address => bool) public TierClassicDividendAddress;
156     mapping(address => bool) public TierWildcatDividendAddress;
157     mapping(address => bool) public TierRainmakerDividendAddress;
158     mapping(address => bool) public HODLERAddress;
159     mapping(address => mapping (address => uint)) internal _allowances;
160     mapping(address => serPayment) inrPayments;
161     mapping(address => dividends) INRdividends;
162 
163     address private _Owner;
164 
165     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
166     event Transfer(address indexed from, address indexed to, uint256 value);
167     event Burn(address indexed from, uint256 value);
168     event Approval(address indexed _owner, address indexed _spender, uint _value);
169 
170     modifier isOwner() {
171 
172       require(msg.sender == _Owner);
173       _;
174     }
175 
176     function iGniter() {
177 
178         initialSupplyPerAddress = 10000000000; //10000 INR
179         initialBlockCount = 5100000;
180         dividendsPerBlockPerAddress = 7;
181         hodlersDividendsPerBlockPerAddress = 9000;
182         T1DividendsPerBlockPerAddress = 70;
183         T2DividendsPerBlockPerAddress = 300;
184         T3DividendsPerBlockPerAddress = 3500;
185         T4DividendsPerBlockPerAddress = 40000;
186         T5DividendsPerBlockPerAddress = 500000;
187         totalInitialAddresses = 5000;
188         initialSupply = initialSupplyPerAddress * totalInitialAddresses;
189         _Owner = msg.sender;
190     }
191 
192     function currentBlock() constant returns (uint256 blockNumber)
193     {
194         return block.number;
195     }
196 
197     function blockDiff() constant returns (uint256 blockNumber)
198     {
199         return block.number - initialBlockCount;
200     }
201 
202     function assignInitialAddresses(address[] _address) isOwner public returns (bool success)
203     {
204         if (block.number < 10000000)
205         {
206           for (uint i = 0; i < _address.length; i++)
207           {
208             balanceOf[_address[i]] = initialSupplyPerAddress;
209             initialAddress[_address[i]] = true;
210           }
211 
212           return true;
213         }
214         return false;
215     }
216 
217     function assignBountyAddresses(address[] _address) isOwner public returns (bool success)
218     {
219       startBounty = 2500000000;
220 
221         if (block.number < 10000000)
222         {
223           for (uint i = 0; i < _address.length; i++)
224           {
225             balanceOf[_address[i]] = startBounty;
226             initialAddress[_address[i]] = true;
227           }
228 
229           return true;
230         }
231         return false;
232     }
233 
234     function completeBountyAddresses(address[] _address) isOwner public returns (bool success)
235     {
236       finishBounty = 7500000000;
237 
238         if (block.number < 10000000)
239         {
240           for (uint i = 0; i < _address.length; i++)
241           {
242             balanceOf[_address[i]] = balanceOf[_address[i]] + finishBounty;
243             initialAddress[_address[i]] = true;
244           }
245 
246           return true;
247         }
248         return false;
249     }
250 
251     function balanceOf(address _address) constant returns (uint256 Balance)
252     {
253 
254         if(dividendAddress[_address] == true)
255         {
256           INRdividends[_address].diviBlocks = block.number - INRdividends[_address].diviReg;
257           INRdividends[_address].diviPayout = dividendsPerBlockPerAddress * INRdividends[_address].diviBlocks;
258         }
259 
260         if(TierStarterDividendAddress[_address] == true)
261         {
262           INRdividends[_address]._tier1Blocks = block.number - INRdividends[_address]._tier1Reg;
263           INRdividends[_address]._tier1Payout = T1DividendsPerBlockPerAddress * INRdividends[_address]._tier1Blocks;
264         }
265 
266         if(TierBasicDividendAddress[_address] == true)
267         {
268           INRdividends[_address]._tier2Blocks = block.number - INRdividends[_address]._tier2Reg;
269           INRdividends[_address]._tier2Payout = T2DividendsPerBlockPerAddress * INRdividends[_address]._tier2Blocks;
270         }
271 
272         if(TierClassicDividendAddress[_address] == true)
273         {
274           INRdividends[_address]._tier3Blocks = block.number - INRdividends[_address]._tier3Reg;
275           INRdividends[_address]._tier3Payout = T3DividendsPerBlockPerAddress * INRdividends[_address]._tier3Blocks;
276         }
277 
278         if(TierWildcatDividendAddress[_address] == true)
279         {
280           INRdividends[_address]._tier4Blocks = block.number - INRdividends[_address]._tier4Reg;
281           INRdividends[_address]._tier4Payout = T4DividendsPerBlockPerAddress * INRdividends[_address]._tier4Blocks;
282         }
283 
284         if(TierRainmakerDividendAddress[_address] == true)
285         {
286           INRdividends[_address]._tier5Blocks = block.number - INRdividends[_address]._tier5Reg;
287           INRdividends[_address]._tier5Payout = T5DividendsPerBlockPerAddress * INRdividends[_address]._tier5Blocks;
288         }
289 
290         if ((balanceOf[_address]) >= 100000000000 && (HODLERAddress[_address] == true)) { //100000INR
291           INRdividends[_address]._hodlBlocks = block.number - INRdividends[_address]._hodlReg;
292           INRdividends[_address].hodlPayout = hodlersDividendsPerBlockPerAddress * INRdividends[_address]._hodlBlocks;
293         }
294 
295         minedBlocks = block.number - initialBlockCount;
296         INRdividends[_address]._tierPayouts = INRdividends[_address]._tier1Payout + INRdividends[_address]._tier2Payout +
297                                               INRdividends[_address]._tier3Payout + INRdividends[_address]._tier4Payout
298                                               + INRdividends[_address]._tier5Payout;
299 
300         if ((initialAddress[_address]) == true) {
301 
302             if (minedBlocks > 105120000) return balanceOf[_address]; //app. 2058
303 
304             availableAmount = dividendsPerBlockPerAddress * minedBlocks;
305             availableBalance = balanceOf[_address] + availableAmount + INRdividends[_address]._tierPayouts + INRdividends[_address].diviPayout + INRdividends[_address].hodlPayout;
306 
307             return availableBalance;
308         }
309 
310         if ((qualifiedAddress[_address]) == true){
311 
312           if (minedBlocks > 105120000) return balanceOf[_address]; //app. 2058
313 
314            availableBalance = balanceOf[_address] + INRdividends[_address]._tierPayouts + INRdividends[_address].diviPayout + INRdividends[_address].hodlPayout;
315             return availableBalance;
316           }
317 
318         else {
319             return balanceOf[_address];
320           }
321     }
322 
323     function name() constant returns (string _name)
324     {
325         name = "iGniter";
326         return name;
327     }
328 
329     function symbol() constant returns (bytes32 _symbol)
330     {
331         symbol = "INR";
332         return symbol;
333     }
334 
335     function decimals() constant returns (uint8 _decimals)
336     {
337         decimals = 6;
338         return decimals;
339     }
340 
341     function totalSupply() constant returns (uint256 totalSupply)
342     {
343         minedBlocks = block.number - initialBlockCount;
344         availableAmount = dividendsPerBlockPerAddress * minedBlocks;
345         iGniting = availableAmount * totalInitialAddresses;
346 
347         if(t1active == true)
348         {
349           _tier1Avg = Tier1blocks/Tier1Amt;
350           _tier1AvgDiff = block.number - _tier1Avg;
351           _tier1Rewards = _tier1AvgDiff * T1DividendsPerBlockPerAddress * Tier1Amt;
352         }
353 
354         if(t2active == true)
355         {
356           _tier2Avg = Tier2blocks/Tier2Amt;
357           _tier2AvgDiff = block.number - _tier2Avg;
358           _tier2Rewards = _tier2AvgDiff * T2DividendsPerBlockPerAddress * Tier2Amt;
359         }
360 
361         if(t3active == true)
362         {
363           _tier3Avg = Tier3blocks/Tier3Amt;
364           _tier3AvgDiff = block.number - _tier3Avg;
365           _tier3Rewards = _tier3AvgDiff * T3DividendsPerBlockPerAddress * Tier3Amt;
366         }
367 
368         if(t4active == true)
369         {
370           _tier4Avg = Tier4blocks/Tier4Amt;
371           _tier4AvgDiff = block.number - _tier4Avg;
372           _tier4Rewards = _tier4AvgDiff * T4DividendsPerBlockPerAddress * Tier4Amt;
373         }
374 
375         if(t5active == true)
376         {
377           _tier5Avg = Tier5blocks/Tier5Amt;
378           _tier5AvgDiff = block.number - _tier5Avg;
379           _tier5Rewards = _tier5AvgDiff * T5DividendsPerBlockPerAddress * Tier5Amt;
380         }
381 
382         _hodlAvg = hodlBlocks/hodlAmt;
383         _hodlAvgDiff = block.number - _hodlAvg;
384         _hodlRewards = _hodlAvgDiff * hodlersDividendsPerBlockPerAddress * hodlAmt;
385 
386         blockAverage = blockStats/diviClaims;
387         blockAvgDiff = block.number - blockAverage;
388         divRewards = blockAvgDiff * dividendsPerBlockPerAddress * diviClaims;
389 
390         totalRewards = _tier1Rewards + _tier2Rewards + _tier3Rewards + _tier4Rewards + _tier5Rewards + _hodlRewards + divRewards;
391 
392         return initialSupply + iGniting + totalRewards - burnt;
393     }
394 
395     function burn(uint256 _value) public returns(bool success) {
396 
397         require(balanceOf[msg.sender] >= _value);
398         balanceOf[msg.sender] -= _value;
399         burnt += _value;
400         Burn(msg.sender, _value);
401         return true;
402     }
403 
404     function transfer(address _to, uint _value) public returns (bool) {
405         if (_value > 0 && _value <= balanceOf[msg.sender] && !isContract(_to)) {
406             balanceOf[msg.sender] -= _value;
407             balanceOf[_to] += _value;
408             Transfer(msg.sender, _to, _value);
409             return true;
410         }
411         return false;
412     }
413 
414     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
415         if (_value > 0 && _value <= balanceOf[msg.sender] && isContract(_to)) {
416             balanceOf[msg.sender] -= _value;
417             balanceOf[_to] += _value;
418             ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
419                 _contract.tokenFallback(msg.sender, _value, _data);
420             Transfer(msg.sender, _to, _value, _data);
421             return true;
422         }
423         return false;
424     }
425 
426     function isContract(address _addr) returns (bool) {
427         uint codeSize;
428         assembly {
429             codeSize := extcodesize(_addr)
430         }
431         return codeSize > 0;
432     }
433 
434     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
435         if (_allowances[_from][msg.sender] > 0 && _value > 0 && _allowances[_from][msg.sender] >= _value &&
436             balanceOf[_from] >= _value) {
437             balanceOf[_from] -= _value;
438             balanceOf[_to] += _value;
439             _allowances[_from][msg.sender] -= _value;
440             Transfer(_from, _to, _value);
441             return true;
442         }
443         return false;
444     }
445 
446     function approve(address _spender, uint _value) public returns (bool) {
447         _allowances[msg.sender][_spender] = _value;
448         Approval(msg.sender, _spender, _value);
449         return true;
450     }
451 
452     function allowance(address _owner, address _spender) public constant returns (uint) {
453         return _allowances[_owner][_spender];
454     }
455 
456     function PaymentStatusBlockNum(address _address) constant returns (uint256 blockno) {
457 
458       return inrPayments[_address].unlockedBlockNumber;
459     }
460 
461     function updateCost(uint256 _currCost) isOwner public {
462 
463       currentCost = _currCost;
464     }
465 
466     function servicePayment(uint _value) public {
467 
468       require(_value >= currentCost);
469       require(balanceOf[msg.sender] >= currentCost);
470 
471       inrPayments[msg.sender].unlockedBlockNumber = block.number;
472       inrSessions++;
473 
474       balanceOf[msg.sender] -= _value;
475       burnt += _value;
476       Burn(msg.sender, _value);
477     }
478 
479     function withdrawal(uint quantity) isOwner returns(bool) {
480 
481            require(quantity <= this.balance);
482            _Owner.transfer(quantity);
483 
484            return true;
485        }
486 
487     function claimDividends() public {
488 
489       if (dividendAddress[msg.sender] == false)
490       {
491         INRdividends[msg.sender].diviReg = block.number;
492         dividendAddress[msg.sender] = true;
493         qualifiedAddress[msg.sender] = true;
494         blockStats += block.number;
495         diviClaims++;
496       }
497     }
498 
499     function HODLRegistration() public {
500 
501           INRdividends[msg.sender]._hodlReg = block.number;
502           HODLERAddress[msg.sender] = true;
503           qualifiedAddress[msg.sender] = true;
504           hodlBlocks += block.number;
505           hodlAmt++;
506     }
507 
508     function Tier_Starter() public payable {
509 
510       require(msg.value == 0.02 ether);
511 
512       INRdividends[msg.sender]._tier1Reg = block.number;
513       TierStarterDividendAddress[msg.sender] = true;
514       qualifiedAddress[msg.sender] = true;
515       Tier1blocks += block.number;
516       Tier1Amt++;
517       t1active = true;
518     }
519 
520     function Tier_Basic() public payable {
521 
522       require(msg.value == 0.05 ether);
523 
524       INRdividends[msg.sender]._tier2Reg = block.number;
525       TierBasicDividendAddress[msg.sender] = true;
526       qualifiedAddress[msg.sender] = true;
527       Tier2blocks += block.number;
528       Tier2Amt++;
529       t2active = true;
530     }
531 
532     function Tier_Classic() public payable {
533 
534       require(msg.value == 0.5 ether);
535 
536       INRdividends[msg.sender]._tier3Reg = block.number;
537       TierClassicDividendAddress[msg.sender] = true;
538       qualifiedAddress[msg.sender] = true;
539       Tier3blocks += block.number;
540       Tier3Amt++;
541       t3active = true;
542     }
543 
544     function Tier_Wildcat() public payable {
545 
546       require(msg.value == 5 ether);
547 
548       INRdividends[msg.sender]._tier4Reg = block.number;
549       TierWildcatDividendAddress[msg.sender] = true;
550       qualifiedAddress[msg.sender] = true;
551       Tier4blocks += block.number;
552       Tier4Amt++;
553       t4active = true;
554     }
555 
556     function Tier_Rainmaker() public payable {
557 
558       require(msg.value == 50 ether);
559 
560       INRdividends[msg.sender]._tier5Reg = block.number;
561       TierRainmakerDividendAddress[msg.sender] = true;
562       qualifiedAddress[msg.sender] = true;
563       Tier5blocks += block.number;
564       Tier5Amt++;
565       t5active = true;
566     }
567 }