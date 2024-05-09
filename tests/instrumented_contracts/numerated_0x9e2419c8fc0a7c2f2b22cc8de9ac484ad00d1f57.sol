1 pragma solidity ^0.4.21;
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
53     uint256 unlockedTime;
54   }
55 
56   struct dividends {
57     uint256 diviReg;
58     uint256 diviBlocks;
59     uint256 diviPayout;
60     uint256 diviBalance;
61     uint256 _tier1Reg;
62     uint256 _tier2Reg;
63     uint256 _tier3Reg;
64     uint256 _tier4Reg;
65     uint256 _tier5Reg;
66     uint256 _tier1Payout;
67     uint256 _tier2Payout;
68     uint256 _tier3Payout;
69     uint256 _tier4Payout;
70     uint256 _tier5Payout;
71     uint256 _tier1Blocks;
72     uint256 _tier2Blocks;
73     uint256 _tier3Blocks;
74     uint256 _tier4Blocks;
75     uint256 _tier5Blocks;
76     uint256 _tierPayouts;
77     uint256 hodlPayout;
78     uint256 _hodlReg;
79     uint256 _hodlBlocks;
80     uint256 INRpayout;
81     uint256 INR_lastbal;
82     uint256 INRpaid;
83     uint256 INRtransfers;
84     uint256 INRbalance;
85     uint256 transDiff;
86     uint256 individualRewards;
87   }
88 
89     string public name;
90     bytes32 public symbol;
91     uint8 public decimals;
92     uint256 private dividendsPerBlockPerAddress;
93     uint256 private T1DividendsPerBlockPerAddress;
94     uint256 private T2DividendsPerBlockPerAddress;
95     uint256 private T3DividendsPerBlockPerAddress;
96     uint256 private T4DividendsPerBlockPerAddress;
97     uint256 private T5DividendsPerBlockPerAddress;
98     uint256 private hodlersDividendsPerBlockPerAddress;
99     uint256 private totalInitialAddresses;
100     uint256 private initialBlockCount;
101     uint256 private minedBlocks;
102     uint256 private iGniting;
103     uint256 private totalRewards;
104     uint256 private initialSupplyPerAddress;
105     uint256 private availableAmount;
106     uint256 private burnt;
107     uint256 private inrSessions;
108     uint256 private initialSupply;
109     uint256 public currentCost;
110     uint256 private blockStats;
111     uint256 private blockAverage;
112     uint256 private blockAvgDiff;
113     uint256 private divRewards;
114     uint256 private diviClaims;
115     uint256 private Tier1Amt;
116     uint256 private Tier2Amt;
117     uint256 private Tier3Amt;
118     uint256 private Tier4Amt;
119     uint256 private Tier5Amt;
120     uint256 private Tier1blocks;
121     uint256 private Tier2blocks;
122     uint256 private Tier3blocks;
123     uint256 private Tier4blocks;
124     uint256 private Tier5blocks;
125     uint256 private hodlBlocks;
126     uint256 private hodlersReward;
127     uint256 private hodlAmt;
128 
129     uint256 private _tier1Avg;
130     uint256 private _tier1AvgDiff;
131     uint256 private _tier1Rewards;
132     uint256 private _tier2Avg;
133     uint256 private _tier2AvgDiff;
134     uint256 private _tier2Rewards;
135     uint256 private _tier3Avg;
136     uint256 private _tier3AvgDiff;
137     uint256 private _tier3Rewards;
138     uint256 private _tier4Avg;
139     uint256 private _tier4AvgDiff;
140     uint256 private _tier4Rewards;
141     uint256 private _tier5Avg;
142     uint256 private _tier5AvgDiff;
143     uint256 private _tier5Rewards;
144     uint256 private _hodlAvg;
145 
146     uint256 private _hodlAvgDiff;
147     uint256 private _hodlRewards;
148 
149     bool private t1active;
150     bool private t2active;
151     bool private t3active;
152     bool private t4active;
153     bool private t5active;
154 
155     mapping(address => uint256) public balanceOf;
156     mapping(address => bool) public initialAddress;
157     mapping(address => bool) public dividendAddress;
158     mapping(address => bool) public qualifiedAddress;
159     mapping(address => bool) public TierStarterDividendAddress;
160     mapping(address => bool) public TierBasicDividendAddress;
161     mapping(address => bool) public TierClassicDividendAddress;
162     mapping(address => bool) public TierWildcatDividendAddress;
163     mapping(address => bool) public TierRainmakerDividendAddress;
164     mapping(address => bool) public HODLERAddress;
165     mapping(address => mapping (address => uint)) internal _allowances;
166     mapping(address => serPayment) inrPayments;
167     mapping(address => dividends) INRdividends;
168 
169     address private _Owner1;
170     address private _Owner2;
171     address private _Owner3;
172 
173     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
174     event Transfer(address indexed from, address indexed to, uint256 value);
175     event Burn(address indexed from, uint256 value);
176     event Approval(address indexed _owner, address indexed _spender, uint _value);
177 
178     modifier isOwner() {
179 
180       require(msg.sender == _Owner1 || msg.sender == _Owner2 || msg.sender == _Owner3);
181       _;
182     }
183 
184     function iGniter() {
185 
186         initialSupplyPerAddress = 10000000000; //10000 INR
187         initialBlockCount = 5150000;
188         dividendsPerBlockPerAddress = 7;
189         hodlersDividendsPerBlockPerAddress = 9000;
190         T1DividendsPerBlockPerAddress = 30;
191         T2DividendsPerBlockPerAddress = 360;
192         T3DividendsPerBlockPerAddress = 4200;
193         T4DividendsPerBlockPerAddress = 60000;
194         T5DividendsPerBlockPerAddress = 1200000;
195         totalInitialAddresses = 5000;
196         initialSupply = initialSupplyPerAddress * totalInitialAddresses;
197         minedBlocks = block.number - initialBlockCount;
198         availableAmount = dividendsPerBlockPerAddress * minedBlocks;
199         iGniting = availableAmount * totalInitialAddresses;
200         _Owner1 = 0x4804D96B17B03B2f5F65a4AaA4b5DB360e22909A;
201         _Owner2 = 0x16C890b06FE52e27ed514e7086378a355F1aB28a;
202         _Owner3 = 0xa4F78852c7F854b4585491a55FE1594913C2C05D;
203     }
204 
205     function currentBlock() constant returns (uint256 blockNumber)
206     {
207         return block.number;
208     }
209 
210     function blockDiff() constant returns (uint256 blockNumber)
211     {
212         return block.number - initialBlockCount;
213     }
214 
215     function assignInitialAddresses(address[] _address) isOwner public returns (bool success)
216     {
217         if (block.number < 10000000)
218         {
219           for (uint i = 0; i < _address.length; i++)
220           {
221             balanceOf[_address[i]] = balanceOf[_address[i]] + initialSupplyPerAddress;
222             initialAddress[_address[i]] = true;
223           }
224 
225           return true;
226         }
227         return false;
228     }
229 
230     function balanceOf(address _address) constant returns (uint256 Balance)
231     {
232         if((qualifiedAddress[_address]) == true || (initialAddress[_address]) == true)
233         {
234             if (minedBlocks > 105120000) return balanceOf[_address]; //app. 2058
235 
236             INRdividends[_address].INRpayout = dividendRewards(_address);
237 
238             if (INRdividends[_address].INRpayout < INRdividends[_address].INRtransfers)
239             {
240                 INRdividends[_address].INRpaid = 0;
241             }
242 
243             if (INRdividends[_address].INRpayout >= INRdividends[_address].INRtransfers)
244             {
245                 INRdividends[_address].transDiff = INRdividends[_address].INRpayout - INRdividends[_address].INRtransfers;
246                 INRdividends[_address].INRpaid = INRdividends[_address].transDiff;
247             }
248 
249             INRdividends[_address].INRbalance = balanceOf[_address] + INRdividends[_address].INRpaid;
250 
251             return INRdividends[_address].INRbalance;
252         }
253 
254         else {
255             return balanceOf[_address] + INRdividends[_address].INRpaid;
256         }
257     }
258 
259     function name() constant returns (string _name)
260     {
261         name = "iGniter";
262         return name;
263     }
264 
265     function symbol() constant returns (bytes32 _symbol)
266     {
267         symbol = "INR";
268         return symbol;
269     }
270 
271     function decimals() constant returns (uint8 _decimals)
272     {
273         decimals = 6;
274         return decimals;
275     }
276 
277     function totalSupply() constant returns (uint256 totalSupply)
278     {
279         if(t1active == true)
280         {
281           _tier1Avg = Tier1blocks/Tier1Amt;
282           _tier1AvgDiff = block.number - _tier1Avg;
283           _tier1Rewards = _tier1AvgDiff * T1DividendsPerBlockPerAddress * Tier1Amt;
284         }
285 
286         if(t2active == true)
287         {
288           _tier2Avg = Tier2blocks/Tier2Amt;
289           _tier2AvgDiff = block.number - _tier2Avg;
290           _tier2Rewards = _tier2AvgDiff * T2DividendsPerBlockPerAddress * Tier2Amt;
291         }
292 
293         if(t3active == true)
294         {
295           _tier3Avg = Tier3blocks/Tier3Amt;
296           _tier3AvgDiff = block.number - _tier3Avg;
297           _tier3Rewards = _tier3AvgDiff * T3DividendsPerBlockPerAddress * Tier3Amt;
298         }
299 
300         if(t4active == true)
301         {
302           _tier4Avg = Tier4blocks/Tier4Amt;
303           _tier4AvgDiff = block.number - _tier4Avg;
304           _tier4Rewards = _tier4AvgDiff * T4DividendsPerBlockPerAddress * Tier4Amt;
305         }
306 
307         if(t5active == true)
308         {
309           _tier5Avg = Tier5blocks/Tier5Amt;
310           _tier5AvgDiff = block.number - _tier5Avg;
311           _tier5Rewards = _tier5AvgDiff * T5DividendsPerBlockPerAddress * Tier5Amt;
312         }
313 
314         _hodlAvg = hodlBlocks/hodlAmt;
315         _hodlAvgDiff = block.number - _hodlAvg;
316         _hodlRewards = _hodlAvgDiff * hodlersDividendsPerBlockPerAddress * hodlAmt;
317 
318         blockAverage = blockStats/diviClaims;
319         blockAvgDiff = block.number - blockAverage;
320         divRewards = blockAvgDiff * dividendsPerBlockPerAddress * diviClaims;
321 
322         totalRewards = _tier1Rewards + _tier2Rewards + _tier3Rewards + _tier4Rewards + _tier5Rewards
323                        + _hodlRewards + divRewards;
324 
325         return initialSupply + iGniting + totalRewards - burnt;
326     }
327 
328     function burn(uint256 _value) public returns(bool success) {
329 
330         require(balanceOf[msg.sender] >= _value);
331         balanceOf[msg.sender] -= _value;
332         burnt += _value;
333         Burn(msg.sender, _value);
334         return true;
335     }
336 
337     function transfer(address _to, uint _value) public returns (bool) {
338         if (_value > 0 && _value <= balanceOf[msg.sender] && !isContract(_to)) {
339             balanceOf[msg.sender] -= _value;
340             balanceOf[_to] += _value;
341             INRdividends[msg.sender].INRtransfers += _value;
342             Transfer(msg.sender, _to, _value);
343             return true;
344         }
345         return false;
346     }
347 
348     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
349         if (_value > 0 && _value <= balanceOf[msg.sender] && isContract(_to)) {
350             balanceOf[msg.sender] -= _value;
351             balanceOf[_to] += _value;
352             INRdividends[msg.sender].INRtransfers += _value;
353             ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
354                 _contract.tokenFallback(msg.sender, _value, _data);
355             Transfer(msg.sender, _to, _value, _data);
356             return true;
357         }
358         return false;
359     }
360 
361     function isContract(address _addr) returns (bool) {
362         uint codeSize;
363         assembly {
364             codeSize := extcodesize(_addr)
365         }
366         return codeSize > 0;
367     }
368 
369     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
370         if (_allowances[_from][msg.sender] > 0 && _value > 0 && _allowances[_from][msg.sender] >= _value &&
371             balanceOf[_from] >= _value) {
372             balanceOf[_from] -= _value;
373             balanceOf[_to] += _value;
374             INRdividends[msg.sender].INRtransfers += _value;
375             _allowances[_from][msg.sender] -= _value;
376             Transfer(_from, _to, _value);
377             return true;
378         }
379         return false;
380     }
381 
382     function approve(address _spender, uint _value) public returns (bool) {
383         _allowances[msg.sender][_spender] = _value;
384         Approval(msg.sender, _spender, _value);
385         return true;
386     }
387 
388     function allowance(address _owner, address _spender) public constant returns (uint) {
389         return _allowances[_owner][_spender];
390     }
391 
392     function PaymentStatusBlockNum(address _address) constant returns (uint256 blockno) {
393 
394       return inrPayments[_address].unlockedBlockNumber;
395     }
396 
397     function PaymentStatusTimeStamp(address _address) constant returns (uint256 ut) {
398 
399       return inrPayments[_address].unlockedTime;
400     }
401 
402     function updateCost(uint256 _currCost) isOwner public {
403 
404       currentCost = _currCost;
405     }
406 
407     function servicePayment(uint _value) public {
408 
409       require(_value >= currentCost);
410       require(balanceOf[msg.sender] >= currentCost);
411 
412       inrPayments[msg.sender].unlockedBlockNumber = block.number;
413       inrSessions++;
414 
415       balanceOf[msg.sender] -= _value;
416       burnt += _value;
417       Burn(msg.sender, _value);
418     }
419 
420     function withdrawal(uint quantity) isOwner returns(bool) {
421 
422            require(quantity <= this.balance);
423 
424            if(msg.sender == _Owner1)
425            {
426              _Owner1.transfer(quantity);
427            }
428 
429            if(msg.sender == _Owner2)
430            {
431              _Owner2.transfer(quantity);
432            }
433 
434            if(msg.sender == _Owner3)
435            {
436              _Owner3.transfer(quantity);
437            }
438 
439            return true;
440    }
441 
442     function dividendRegistration() public {
443 
444       require (dividendAddress[msg.sender] == false);
445 
446       INRdividends[msg.sender].diviReg = block.number;
447       dividendAddress[msg.sender] = true;
448       qualifiedAddress[msg.sender] = true;
449       blockStats += block.number;
450       diviClaims++;
451     }
452 
453     function HODLRegistration() public {
454 
455       require (HODLERAddress[msg.sender] == false);
456 
457           INRdividends[msg.sender]._hodlReg = block.number;
458           HODLERAddress[msg.sender] = true;
459           qualifiedAddress[msg.sender] = true;
460           hodlBlocks += block.number;
461           hodlAmt++;
462     }
463 
464     function Tier_Starter_Registration() public payable {
465 
466       require(msg.value == 0.01 ether);
467 
468       INRdividends[msg.sender]._tier1Reg = block.number;
469       TierStarterDividendAddress[msg.sender] = true;
470       qualifiedAddress[msg.sender] = true;
471       Tier1blocks += block.number;
472       Tier1Amt++;
473       t1active = true;
474     }
475 
476     function Tier_Basic_Registration() public payable {
477 
478       require(msg.value >= 0.1 ether);
479 
480       INRdividends[msg.sender]._tier2Reg = block.number;
481       TierBasicDividendAddress[msg.sender] = true;
482       qualifiedAddress[msg.sender] = true;
483       Tier2blocks += block.number;
484       Tier2Amt++;
485       t2active = true;
486     }
487 
488     function Tier_Classic_Registration() public payable {
489 
490       require(msg.value >= 1 ether);
491 
492       INRdividends[msg.sender]._tier3Reg = block.number;
493       TierClassicDividendAddress[msg.sender] = true;
494       qualifiedAddress[msg.sender] = true;
495       Tier3blocks += block.number;
496       Tier3Amt++;
497       t3active = true;
498     }
499 
500     function Tier_Wildcat_Registration() public payable {
501 
502       require(msg.value >= 10 ether);
503 
504       INRdividends[msg.sender]._tier4Reg = block.number;
505       TierWildcatDividendAddress[msg.sender] = true;
506       qualifiedAddress[msg.sender] = true;
507       Tier4blocks += block.number;
508       Tier4Amt++;
509       t4active = true;
510     }
511 
512     function Tier_Rainmaker_Registration() public payable {
513 
514       require(msg.value >= 100 ether);
515 
516       INRdividends[msg.sender]._tier5Reg = block.number;
517       TierRainmakerDividendAddress[msg.sender] = true;
518       qualifiedAddress[msg.sender] = true;
519       Tier5blocks += block.number;
520       Tier5Amt++;
521       t5active = true;
522     }
523 
524     function claimINRDividends() public
525     {
526         INRdividends[msg.sender].INRpayout = dividendRewards(msg.sender);
527 
528         if (INRdividends[msg.sender].INRpayout < INRdividends[msg.sender].INRtransfers)
529         {
530             INRdividends[msg.sender].INRpaid = 0;
531         }
532 
533         if (INRdividends[msg.sender].INRpayout >= INRdividends[msg.sender].INRtransfers)
534         {
535             INRdividends[msg.sender].transDiff = INRdividends[msg.sender].INRpayout - INRdividends[msg.sender].INRtransfers;
536             INRdividends[msg.sender].INRpaid = INRdividends[msg.sender].transDiff;
537         }
538 
539         balanceOf[msg.sender] += INRdividends[msg.sender].INRpaid;
540     }
541 
542     function dividendRewards(address _address) constant returns (uint)
543     {
544         if(dividendAddress[_address] == true)
545         {
546           INRdividends[_address].diviBlocks = block.number - INRdividends[_address].diviReg;
547           INRdividends[_address].diviPayout = dividendsPerBlockPerAddress * INRdividends[_address].diviBlocks;
548         }
549 
550         if(TierStarterDividendAddress[_address] == true)
551         {
552           INRdividends[_address]._tier1Blocks = block.number - INRdividends[_address]._tier1Reg;
553           INRdividends[_address]._tier1Payout = T1DividendsPerBlockPerAddress * INRdividends[_address]._tier1Blocks;
554         }
555 
556         if(TierBasicDividendAddress[_address] == true)
557         {
558           INRdividends[_address]._tier2Blocks = block.number - INRdividends[_address]._tier2Reg;
559           INRdividends[_address]._tier2Payout = T2DividendsPerBlockPerAddress * INRdividends[_address]._tier2Blocks;
560         }
561 
562         if(TierClassicDividendAddress[_address] == true)
563         {
564           INRdividends[_address]._tier3Blocks = block.number - INRdividends[_address]._tier3Reg;
565           INRdividends[_address]._tier3Payout = T3DividendsPerBlockPerAddress * INRdividends[_address]._tier3Blocks;
566         }
567 
568         if(TierWildcatDividendAddress[_address] == true)
569         {
570           INRdividends[_address]._tier4Blocks = block.number - INRdividends[_address]._tier4Reg;
571           INRdividends[_address]._tier4Payout = T4DividendsPerBlockPerAddress * INRdividends[_address]._tier4Blocks;
572         }
573 
574         if(TierRainmakerDividendAddress[_address] == true)
575         {
576           INRdividends[_address]._tier5Blocks = block.number - INRdividends[_address]._tier5Reg;
577           INRdividends[_address]._tier5Payout = T5DividendsPerBlockPerAddress * INRdividends[_address]._tier5Blocks;
578         }
579 
580         if ((balanceOf[_address]) >= 100000000000 && (HODLERAddress[_address] == true)) { //100000INR
581           INRdividends[_address]._hodlBlocks = block.number - INRdividends[_address]._hodlReg;
582           INRdividends[_address].hodlPayout = hodlersDividendsPerBlockPerAddress * INRdividends[_address]._hodlBlocks;
583         }
584 
585         INRdividends[_address]._tierPayouts = INRdividends[_address]._tier1Payout + INRdividends[_address]._tier2Payout +
586                                               INRdividends[_address]._tier3Payout + INRdividends[_address]._tier4Payout +
587                                               INRdividends[_address]._tier5Payout + INRdividends[_address].hodlPayout +
588                                               INRdividends[_address].diviPayout;
589 
590         if ((initialAddress[_address]) == true)
591         {
592             INRdividends[_address].individualRewards = availableAmount + INRdividends[_address]._tierPayouts;
593 
594             return INRdividends[_address].individualRewards;
595         }
596 
597         if ((qualifiedAddress[_address]) == true)
598         {
599             INRdividends[_address].individualRewards = INRdividends[_address]._tierPayouts;
600 
601             return INRdividends[_address].individualRewards;
602         }
603     }
604 }