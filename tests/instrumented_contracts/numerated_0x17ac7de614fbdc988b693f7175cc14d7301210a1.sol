1 pragma solidity ^0.4.24;
2 // Made By Yoondae - ydwinha@gmail.com - https://blog.naver.com/ydwinha
3 
4 library SafeMath
5 {
6     function mul(uint256 a, uint256 b) internal pure returns (uint256)
7     {
8         uint256 c = a * b;
9         assert(a == 0 || c / a == b);
10 
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256)
15     {
16         uint256 c = a / b;
17 
18         return c;  
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256)
22     {
23         assert(b <= a);
24 
25         return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256)
29     {
30         uint256 c = a + b;
31         assert(c >= a);
32 
33         return c;
34     }
35 }
36 
37 
38 contract OwnerHelper
39 {
40     address public owner;
41 
42     event OwnerTransferPropose(address indexed _from, address indexed _to);
43 
44     modifier onlyOwner
45     {
46         require(msg.sender == owner);
47         _;
48     }
49 
50     constructor() public
51     {
52         owner = msg.sender;
53     }
54 
55     function transferOwnership(address _to) onlyOwner public
56     {
57         require(_to != owner);
58         require(_to != address(0x0));
59         owner = _to;
60         emit OwnerTransferPropose(owner, _to);
61     }
62 
63 }
64 
65 contract ERC20Interface
66 {
67     event Transfer( address indexed _from, address indexed _to, uint _value);
68     event Approval( address indexed _owner, address indexed _spender, uint _value);
69     
70     function totalSupply() constant public returns (uint _supply);
71     function balanceOf( address _who ) public view returns (uint _value);
72     function transfer( address _to, uint _value) public returns (bool _success);
73     function approve( address _spender, uint _value ) public returns (bool _success);
74     function allowance( address _owner, address _spender ) public view returns (uint _allowance);
75     function transferFrom( address _from, address _to, uint _value) public returns (bool _success);
76 }
77 
78 contract GemmyCoin is ERC20Interface, OwnerHelper
79 {
80     using SafeMath for uint;
81     
82     string public name;
83     uint public decimals;
84     string public symbol;
85     address public wallet;
86 
87     uint public totalSupply;
88     
89     uint constant public saleSupply         =  3500000000 * E18;
90     uint constant public rewardPoolSupply   =  2200000000 * E18;
91     uint constant public foundationSupply   =   500000000 * E18;
92     uint constant public gemmyMusicSupply   =  1200000000 * E18;
93     uint constant public advisorSupply      =   700000000 * E18;
94     uint constant public mktSupply          =  1600000000 * E18;
95     uint constant public etcSupply          =   300000000 * E18;
96     uint constant public maxSupply          = 10000000000 * E18;
97     
98     uint public coinIssuedSale = 0;
99     uint public coinIssuedRewardPool = 0;
100     uint public coinIssuedFoundation = 0;
101     uint public coinIssuedGemmyMusic = 0;
102     uint public coinIssuedAdvisor = 0;
103     uint public coinIssuedMkt = 0;
104     uint public coinIssuedEtc = 0;
105     uint public coinIssuedTotal = 0;
106     uint public coinIssuedBurn = 0;
107     
108     uint public saleEtherReceived = 0;
109 
110     uint constant private E18 = 1000000000000000000;
111     
112     uint public firstPreSaleDate1 = 1529247600;        // 2018-06-18 00:00:00 
113     uint public firstPreSaleEndDate1 = 1530198000;     // 2018-06-29 00:00:00 
114     
115     uint public firstPreSaleDate2 = 1530457200;       // 2018-07-02 00:00:00 
116     uint public firstPreSaleEndDate2 = 1532617200;    // 2018-07-27 00:00:00 
117     
118     uint public secondPreSaleDate = 1532876400;      // 2018-07-30 00:00:00 
119     uint public secondPreSaleEndDate = 1534431600;   // 2018-08-17 00:00:00 
120     
121     uint public thirdPreSaleDate = 1534690800;     // 2018-08-20 00:00:00 
122     uint public thirdPreSaleEndDate = 1536246000;  // 2018-09-07 00:00:00 
123 
124     uint public mainSaleDate = 1536505200;    // 2018-09-10 00:00:00 
125     uint public mainSaleEndDate = 1540911600; // 2018-10-31 00:00:00 
126     
127     bool public totalCoinLock;
128     uint public gemmyMusicLockTime;
129     
130     uint public advisorFirstLockTime;
131     uint public advisorSecondLockTime;
132     
133     mapping (address => uint) internal balances;
134     mapping (address => mapping ( address => uint )) internal approvals;
135 
136     mapping (address => bool) internal personalLocks;
137     mapping (address => bool) internal gemmyMusicLocks;
138     
139     mapping (address => uint) internal advisorFirstLockBalances;
140     mapping (address => uint) internal advisorSecondLockBalances;
141     
142     mapping (address => uint) internal  icoEtherContributeds;
143     
144     event CoinIssuedSale(address indexed _who, uint _coins, uint _balances, uint _ether, uint _saleTime);
145     event RemoveTotalCoinLock();
146     event SetAdvisorLockTime(uint _first, uint _second);
147     event RemovePersonalLock(address _who);
148     event RemoveGemmyMusicLock(address _who);
149     event RemoveAdvisorFirstLock(address _who);
150     event RemoveAdvisorSecondLock(address _who);
151     event WithdrawRewardPool(address _who, uint _value);
152     event WithdrawFoundation(address _who, uint _value);
153     event WithdrawGemmyMusic(address _who, uint _value);
154     event WithdrawAdvisor(address _who, uint _value);
155     event WithdrawMkt(address _who, uint _value);
156     event WithdrawEtc(address _who, uint _value);
157     event ChangeWallet(address _who);
158     event BurnCoin(uint _value);
159     event RefundCoin(address _who, uint _value);
160 
161     constructor() public
162     {
163         name = "GemmyMusicCoin";
164         decimals = 18;
165         symbol = "GMC";
166         totalSupply = 0;
167         
168         owner = msg.sender;
169         wallet = msg.sender;
170         
171         require(maxSupply == saleSupply + rewardPoolSupply + foundationSupply + gemmyMusicSupply + advisorSupply + mktSupply + etcSupply);
172         
173         totalCoinLock = true;
174         gemmyMusicLockTime = firstPreSaleDate1 + (365 * 24 * 60 * 60);
175         advisorFirstLockTime = gemmyMusicLockTime;   // if tokenUnLock == timeChange
176         advisorSecondLockTime = gemmyMusicLockTime;  // if tokenUnLock == timeChange
177     }
178 
179     function atNow() public view returns (uint)
180     {
181         return now;
182     }
183     
184     function () payable public
185     {
186         require(saleSupply > coinIssuedSale);
187         buyCoin();
188     }
189     
190     function buyCoin() private
191     {
192         uint ethPerCoin = 0;
193         uint saleTime = 0; // 1 : firstPreSale1, 2 : firstPreSale2, 3 : secondPreSale, 4 : thirdPreSale, 5 : mainSale
194         uint coinBonus = 0;
195         
196         uint minEth = 0.1 ether;
197         uint maxEth = 100000 ether;
198         
199         uint nowTime = atNow();
200         
201         if( nowTime >= firstPreSaleDate1 && nowTime < firstPreSaleEndDate1 )
202         {
203             ethPerCoin = 50000;
204             saleTime = 1;
205             coinBonus = 20;
206         }
207         else if( nowTime >= firstPreSaleDate2 && nowTime < firstPreSaleEndDate2 )
208         {
209             ethPerCoin = 50000;
210             saleTime = 2;
211             coinBonus = 20;
212         }
213         else if( nowTime >= secondPreSaleDate && nowTime < secondPreSaleEndDate )
214         {
215             ethPerCoin = 26000;
216             saleTime = 3;
217             coinBonus = 15;
218         }
219         else if( nowTime >= thirdPreSaleDate && nowTime < thirdPreSaleEndDate )
220         {
221             ethPerCoin = 18000;
222             saleTime = 4;
223             coinBonus = 10;
224         }
225         else if( nowTime >= mainSaleDate && nowTime < mainSaleEndDate )
226         {
227             ethPerCoin = 12000;
228             saleTime = 5;
229             coinBonus = 0;
230         }
231         
232         require(saleTime >= 1 && saleTime <= 5);
233         require(msg.value >= minEth && icoEtherContributeds[msg.sender].add(msg.value) <= maxEth);
234 
235         uint coins = ethPerCoin.mul(msg.value);
236         coins = coins.mul(100 + coinBonus) / 100;
237         
238         require(saleSupply >= coinIssuedSale.add(coins));
239 
240         totalSupply = totalSupply.add(coins);
241         coinIssuedSale = coinIssuedSale.add(coins);
242         saleEtherReceived = saleEtherReceived.add(msg.value);
243 
244         balances[msg.sender] = balances[msg.sender].add(coins);
245         icoEtherContributeds[msg.sender] = icoEtherContributeds[msg.sender].add(msg.value);
246         personalLocks[msg.sender] = true;
247 
248         emit Transfer(0x0, msg.sender, coins);
249         emit CoinIssuedSale(msg.sender, coins, balances[msg.sender], msg.value, saleTime);
250 
251         wallet.transfer(address(this).balance);
252     }
253     
254     function isTransferLock(address _from, address _to) constant private returns (bool _success)
255     {
256         _success = false;
257 
258         if(totalCoinLock == true)
259         {
260             _success = true;
261         }
262         
263         if(personalLocks[_from] == true || personalLocks[_to] == true)
264         {
265             _success = true;
266         }
267         
268         if(gemmyMusicLocks[_from] == true || gemmyMusicLocks[_to] == true)
269         {
270             _success = true;
271         }
272         
273         return _success;
274     }
275     
276     function isPersonalLock(address _who) constant public returns (bool)
277     {
278         return personalLocks[_who];
279     }
280     
281     function removeTotalCoinLock() onlyOwner public
282     {
283         require(totalCoinLock == true);
284         
285         uint nowTime = atNow();
286         advisorFirstLockTime = nowTime + (2 * 30 * 24 * 60 * 60);
287         advisorSecondLockTime = nowTime + (4 * 30 * 24 * 60 * 60);
288     
289         totalCoinLock = false;
290         
291         emit RemoveTotalCoinLock();
292         emit SetAdvisorLockTime(advisorFirstLockTime, advisorSecondLockTime);
293     }
294     
295     function removePersonalLock(address _who) onlyOwner public
296     {
297         require(personalLocks[_who] == true);
298         
299         personalLocks[_who] = false;
300         
301         emit RemovePersonalLock(_who);
302     }
303     
304     function removePersonalLockMultiple(address[] _addresses) onlyOwner public
305     {
306         for(uint i = 0; i < _addresses.length; i++)
307         {
308         
309             require(personalLocks[_addresses[i]] == true);
310         
311             personalLocks[_addresses[i]] = false;
312         
313             emit RemovePersonalLock(_addresses[i]);
314         }
315     }
316     
317     function removeGemmyMusicLock(address _who) onlyOwner public
318     {
319         require(atNow() > gemmyMusicLockTime);
320         require(gemmyMusicLocks[_who] == true);
321         
322         gemmyMusicLocks[_who] = false;
323         
324         emit RemoveGemmyMusicLock(_who);
325     }
326     
327     function removeFirstAdvisorLock(address _who) onlyOwner public
328     {
329         require(atNow() > advisorFirstLockTime);
330         require(advisorFirstLockBalances[_who] > 0);
331         
332         balances[_who] = balances[_who].add(advisorFirstLockBalances[_who]);
333         advisorFirstLockBalances[_who] = 0;
334         
335         emit RemoveAdvisorFirstLock(_who);
336     }
337     
338     function removeSecondAdvisorLock(address _who) onlyOwner public
339     {
340         require(atNow() > advisorSecondLockTime);
341         require(advisorSecondLockBalances[_who] > 0);
342         
343         balances[_who] = balances[_who].add(advisorSecondLockBalances[_who]);
344         advisorSecondLockBalances[_who] = 0;
345         
346         emit RemoveAdvisorSecondLock(_who);
347     }
348     
349     function totalSupply() constant public returns (uint) 
350     {
351         return totalSupply;
352     }
353     
354     function balanceOf(address _who) public view returns (uint) 
355     {
356         return balances[_who];
357     }
358     
359     function transfer(address _to, uint _value) public returns (bool) 
360     {
361         require(balances[msg.sender] >= _value);
362         require(isTransferLock(msg.sender, _to) == false);
363         
364         balances[msg.sender] = balances[msg.sender].sub(_value);
365         balances[_to] = balances[_to].add(_value);
366         
367         emit Transfer(msg.sender, _to, _value);
368         
369         return true;
370     }
371     
372     function transferMultiple(address[] _addresses, uint[] _values) onlyOwner public returns (bool) 
373     {
374         require(_addresses.length == _values.length);
375         
376         uint value = 0;
377         
378         for(uint i = 0; i < _addresses.length; i++)
379         {
380             value = _values[i] * E18;
381             require(balances[msg.sender] >= value);
382             require(isTransferLock(msg.sender, _addresses[i]) == false);
383             
384             balances[msg.sender] = balances[msg.sender].sub(value);
385             balances[_addresses[i]] = balances[_addresses[i]].add(value);
386             
387             emit Transfer(msg.sender, _addresses[i], value);
388         }
389         return true;
390     }
391     
392     function approve(address _spender, uint _value) public returns (bool)
393     {
394         require(balances[msg.sender] >= _value);
395         require(isTransferLock(msg.sender, _spender) == false);
396         
397         approvals[msg.sender][_spender] = _value;
398         
399         emit Approval(msg.sender, _spender, _value);
400         
401         return true;
402     }
403     
404     function allowance(address _owner, address _spender) constant public returns (uint) 
405     {
406         return approvals[_owner][_spender];
407     }
408     
409     function transferFrom(address _from, address _to, uint _value) public returns (bool) 
410     {
411         require(balances[_from] >= _value);
412         require(approvals[_from][msg.sender] >= _value);
413         require(isTransferLock(msg.sender, _to) == false);
414         
415         approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);
416         balances[_from] = balances[_from].sub(_value);
417         balances[_to]  = balances[_to].add(_value);
418         
419         emit Transfer(_from, _to, _value);
420         
421         return true;
422     }
423     
424     function withdrawRewardPool(address _who, uint _value) onlyOwner public
425     {
426         uint coins = _value * E18;
427         
428         require(rewardPoolSupply >= coinIssuedRewardPool.add(coins));
429 
430         totalSupply = totalSupply.add(coins);
431         coinIssuedRewardPool = coinIssuedRewardPool.add(coins);
432         coinIssuedTotal = coinIssuedTotal.add(coins);
433 
434         balances[_who] = balances[_who].add(coins);
435         personalLocks[_who] = true;
436 
437         emit Transfer(0x0, msg.sender, coins);
438         emit WithdrawRewardPool(_who, coins);
439     }
440     
441     function withdrawFoundation(address _who, uint _value) onlyOwner public
442     {
443         uint coins = _value * E18;
444         
445         require(foundationSupply >= coinIssuedFoundation.add(coins));
446 
447         totalSupply = totalSupply.add(coins);
448         coinIssuedFoundation = coinIssuedFoundation.add(coins);
449         coinIssuedTotal = coinIssuedTotal.add(coins);
450 
451         balances[_who] = balances[_who].add(coins);
452         personalLocks[_who] = true;
453 
454         emit Transfer(0x0, msg.sender, coins);
455         emit WithdrawFoundation(_who, coins);
456     }
457     
458     function withdrawGemmyMusic(address _who, uint _value) onlyOwner public
459     {
460         uint coins = _value * E18;
461         
462         require(gemmyMusicSupply >= coinIssuedGemmyMusic.add(coins));
463 
464         totalSupply = totalSupply.add(coins);
465         coinIssuedGemmyMusic = coinIssuedGemmyMusic.add(coins);
466         coinIssuedTotal = coinIssuedTotal.add(coins);
467 
468         balances[_who] = balances[_who].add(coins);
469         gemmyMusicLocks[_who] = true;
470 
471         emit Transfer(0x0, msg.sender, coins);
472         emit WithdrawGemmyMusic(_who, coins);
473     }
474     
475     function withdrawAdvisor(address _who, uint _value) onlyOwner public
476     {
477         uint coins = _value * E18;
478         
479         require(advisorSupply >= coinIssuedAdvisor.add(coins));
480 
481         totalSupply = totalSupply.add(coins);
482         coinIssuedAdvisor = coinIssuedAdvisor.add(coins);
483         coinIssuedTotal = coinIssuedTotal.add(coins);
484 
485         balances[_who] = balances[_who].add(coins * 20 / 100);
486         advisorFirstLockBalances[_who] = advisorFirstLockBalances[_who].add(coins * 40 / 100);
487         advisorSecondLockBalances[_who] = advisorSecondLockBalances[_who].add(coins * 40 / 100);
488         personalLocks[_who] = true;
489 
490         emit Transfer(0x0, msg.sender, coins);
491         emit WithdrawAdvisor(_who, coins);
492     }
493     
494     function withdrawMkt(address _who, uint _value) onlyOwner public
495     {
496         uint coins = _value * E18;
497         
498         require(mktSupply >= coinIssuedMkt.add(coins));
499 
500         totalSupply = totalSupply.add(coins);
501         coinIssuedMkt = coinIssuedMkt.add(coins);
502         coinIssuedTotal = coinIssuedTotal.add(coins);
503 
504         balances[_who] = balances[_who].add(coins);
505         personalLocks[_who] = true;
506 
507         emit Transfer(0x0, msg.sender, coins);
508         emit WithdrawMkt(_who, coins);
509     }
510     
511     function withdrawEtc(address _who, uint _value) onlyOwner public
512     {
513         uint coins = _value * E18;
514         
515         require(etcSupply >= coinIssuedEtc.add(coins));
516 
517         totalSupply = totalSupply.add(coins);
518         coinIssuedEtc = coinIssuedEtc.add(coins);
519         coinIssuedTotal = coinIssuedTotal.add(coins);
520 
521         balances[_who] = balances[_who].add(coins);
522         personalLocks[_who] = true;
523 
524         emit Transfer(0x0, msg.sender, coins);
525         emit WithdrawEtc(_who, coins);
526     }
527     
528     function burnCoin() onlyOwner public
529     {
530         require(atNow() > mainSaleEndDate);
531         require(saleSupply - coinIssuedSale > 0);
532 
533         uint coins = saleSupply - coinIssuedSale;
534         
535         balances[0x0] = balances[0x0].add(coins);
536         coinIssuedSale = coinIssuedSale.add(coins);
537         coinIssuedBurn = coinIssuedBurn.add(coins);
538 
539         emit BurnCoin(coins);
540     }
541     
542     function changeWallet(address _who) onlyOwner public
543     {
544         require(_who != address(0x0));
545         require(_who != wallet);
546         
547         wallet = _who;
548         
549         emit ChangeWallet(_who);
550     }
551     
552     function refundCoin(address _who) onlyOwner public
553     {
554         require(totalCoinLock == true);
555         
556         uint coins = balances[_who];
557         
558         balances[_who] = balances[_who].sub(coins);
559         balances[wallet] = balances[wallet].add(coins);
560 
561         emit RefundCoin(_who, coins);
562     }
563 }