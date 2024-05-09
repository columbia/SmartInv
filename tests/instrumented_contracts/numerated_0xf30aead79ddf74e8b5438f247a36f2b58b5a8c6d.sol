1 pragma solidity ^0.4.23;
2 // Made By PinkCherry - insanityskan@gmail.com - https://blog.naver.com/soolmini
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
89     uint constant public saleSupply = 4000000000 * E18;
90     uint constant public rewardPoolSupply = 2500000000 * E18;
91     uint constant public foundationSupply = 500000000 * E18;
92     uint constant public gemmyMusicSupply = 1500000000 * E18;
93     uint constant public advisorSupply = 700000000 * E18;
94     uint constant public mktSupply = 800000000 * E18;
95     uint constant public maxSupply = 10000000000 * E18;
96     
97     uint public coinIssuedSale = 0;
98     uint public coinIssuedRewardPool = 0;
99     uint public coinIssuedFoundation = 0;
100     uint public coinIssuedGemmyMusic = 0;
101     uint public coinIssuedAdvisor = 0;
102     uint public coinIssuedMkt = 0;
103     uint public coinIssuedTotal = 0;
104     uint public coinIssuedBurn = 0;
105     
106     uint public saleEtherReceived = 0;
107 
108     uint constant private E18 = 1000000000000000000;
109     uint constant private ethPerCoin = 35000;
110     
111     uint private UTC9 = 9 * 60 * 60;
112     uint public privateSaleDate = 1526223600 + UTC9;        // 2018-05-14 00:00:00 (UTC + 9)
113     uint public privateSaleEndDate = 1527951600 + UTC9;     // 2018-06-03 00:00:00 (UTC + 9)
114     
115     uint public firstPreSaleDate = 1528038000 + UTC9;       // 2018-06-04 00:00:00 (UTC + 9)
116     uint public firstPreSaleEndDate = 1528988400 + UTC9;    // 2018-06-15 00:00:00 (UTC + 9)
117     
118     uint public secondPreSaleDate = 1529852400 + UTC9;      // 2018-06-25 00:00:00 (UTC + 9)
119     uint public secondPreSaleEndDate = 1530802800 + UTC9;   // 2018-07-06 00:00:00 (UTC + 9)
120     
121     uint public firstCrowdSaleDate = 1531062000 + UTC9;     // 2018-07-09 00:00:00 (UTC + 9)
122     uint public firstCrowdSaleEndDate = 1532012400 + UTC9;  // 2018-07-20 00:00:00 (UTC + 9)
123 
124     uint public secondCrowdSaleDate = 1532271600 + UTC9;    // 2018-07-23 00:00:00 (UTC + 9)
125     uint public secondCrowdSaleEndDate = 1532962800 + UTC9; // 2018-07-31 00:00:00 (UTC + 9)
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
144     event CoinIssuedSale(address indexed _who, uint _coins, uint _balances, uint _ether);
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
156     event ChangeWallet(address _who);
157     event BurnCoin(uint _value);
158     event RefundCoin(address _who, uint _value);
159 
160     constructor() public
161     {
162         name = "GemmyMusicCoin";
163         decimals = 18;
164         symbol = "GMM";
165         totalSupply = 0;
166         
167         owner = msg.sender;
168         wallet = msg.sender;
169         
170         require(maxSupply == saleSupply + rewardPoolSupply + foundationSupply + gemmyMusicSupply + advisorSupply + mktSupply);
171         
172         totalCoinLock = true;
173         gemmyMusicLockTime = privateSaleDate + (365 * 24 * 60 * 60);
174         advisorFirstLockTime = gemmyMusicLockTime;   // if tokenUnLock == timeChange
175         advisorSecondLockTime = gemmyMusicLockTime;  // if tokenUnLock == timeChange
176     }
177 
178     function atNow() public view returns (uint)
179     {
180         return now;
181     }
182     
183     function () payable public
184     {
185         require(saleSupply > coinIssuedSale);
186         buyCoin();
187     }
188     
189     function buyCoin() private
190     {
191         uint saleTime = 0; // 1 : privateSale, 2 : firstPreSale, 3 : secondPreSale, 4 : firstCrowdSale, 5 : secondCrowdSale
192         uint coinBonus = 0;
193         
194         uint minEth = 0.1 ether;
195         uint maxEth = 100000 ether;
196         
197         uint nowTime = atNow();
198         
199         if( nowTime >= privateSaleDate && nowTime < privateSaleEndDate )
200         {
201             saleTime = 1;
202             coinBonus = 40;
203         }
204         else if( nowTime >= firstPreSaleDate && nowTime < firstPreSaleEndDate )
205         {
206             saleTime = 2;
207             coinBonus = 20;
208         }
209         else if( nowTime >= secondPreSaleDate && nowTime < secondPreSaleEndDate )
210         {
211             saleTime = 3;
212             coinBonus = 15;
213         }
214         else if( nowTime >= firstCrowdSaleDate && nowTime < firstCrowdSaleEndDate )
215         {
216             saleTime = 4;
217             coinBonus = 5;
218         }
219         else if( nowTime >= secondCrowdSaleDate && nowTime < secondCrowdSaleEndDate )
220         {
221             saleTime = 5;
222             coinBonus = 0;
223         }
224         
225         require(saleTime >= 1 && saleTime <= 5);
226         require(msg.value >= minEth && icoEtherContributeds[msg.sender].add(msg.value) <= maxEth);
227 
228         uint coins = ethPerCoin.mul(msg.value);
229         coins = coins.mul(100 + coinBonus) / 100;
230         
231         require(saleSupply >= coinIssuedSale.add(coins));
232 
233         totalSupply = totalSupply.add(coins);
234         coinIssuedSale = coinIssuedSale.add(coins);
235         saleEtherReceived = saleEtherReceived.add(msg.value);
236 
237         balances[msg.sender] = balances[msg.sender].add(coins);
238         icoEtherContributeds[msg.sender] = icoEtherContributeds[msg.sender].add(msg.value);
239         personalLocks[msg.sender] = true;
240 
241         emit Transfer(0x0, msg.sender, coins);
242         emit CoinIssuedSale(msg.sender, coins, balances[msg.sender], msg.value);
243 
244         wallet.transfer(address(this).balance);
245     }
246     
247     function isTransferLock(address _from, address _to) constant private returns (bool _success)
248     {
249         _success = false;
250 
251         if(totalCoinLock == true)
252         {
253             _success = true;
254         }
255         
256         if(personalLocks[_from] == true || personalLocks[_to] == true)
257         {
258             _success = true;
259         }
260         
261         if(gemmyMusicLocks[_from] == true || gemmyMusicLocks[_to] == true)
262         {
263             _success = true;
264         }
265         
266         return _success;
267     }
268     
269     function isPersonalLock(address _who) constant public returns (bool)
270     {
271         return personalLocks[_who];
272     }
273     
274     function removeTotalCoinLock() onlyOwner public
275     {
276         require(totalCoinLock == true);
277         
278         uint nowTime = atNow();
279         advisorFirstLockTime = nowTime + (2 * 30 * 24 * 60 * 60);
280         advisorSecondLockTime = nowTime + (4 * 30 * 24 * 60 * 60);
281     
282         totalCoinLock = false;
283         
284         emit RemoveTotalCoinLock();
285         emit SetAdvisorLockTime(advisorFirstLockTime, advisorSecondLockTime);
286     }
287     
288     function removePersonalLock(address _who) onlyOwner public
289     {
290         require(personalLocks[_who] == true);
291         
292         personalLocks[_who] = false;
293         
294         emit RemovePersonalLock(_who);
295     }
296     
297     function removePersonalLockMultiple(address[] _addresses) onlyOwner public
298     {
299         for(uint i = 0; i < _addresses.length; i++)
300         {
301         
302             require(personalLocks[_addresses[i]] == true);
303         
304             personalLocks[_addresses[i]] = false;
305         
306             emit RemovePersonalLock(_addresses[i]);
307         }
308     }
309     
310     function removeGemmyMusicLock(address _who) onlyOwner public
311     {
312         require(atNow() > gemmyMusicLockTime);
313         require(gemmyMusicLocks[_who] == true);
314         
315         gemmyMusicLocks[_who] = false;
316         
317         emit RemoveGemmyMusicLock(_who);
318     }
319     
320     function removeFirstAdvisorLock(address _who) onlyOwner public
321     {
322         require(atNow() > advisorFirstLockTime);
323         require(advisorFirstLockBalances[_who] > 0);
324         require(personalLocks[_who] == true);
325         
326         balances[_who] = balances[_who].add(advisorFirstLockBalances[_who]);
327         advisorFirstLockBalances[_who] = 0;
328         
329         emit RemoveAdvisorFirstLock(_who);
330     }
331     
332     function removeSecondAdvisorLock(address _who) onlyOwner public
333     {
334         require(atNow() > advisorSecondLockTime);
335         require(advisorFirstLockBalances[_who] > 0);
336         require(personalLocks[_who] == true);
337         
338         balances[_who] = balances[_who].add(advisorFirstLockBalances[_who]);
339         advisorFirstLockBalances[_who] = 0;
340         
341         emit RemoveAdvisorFirstLock(_who);
342     }
343     
344     function totalSupply() constant public returns (uint) 
345     {
346         return totalSupply;
347     }
348     
349     function balanceOf(address _who) public view returns (uint) 
350     {
351         return balances[_who].add(advisorFirstLockBalances[_who].add(advisorSecondLockBalances[_who]));
352     }
353     
354     function transfer(address _to, uint _value) public returns (bool) 
355     {
356         require(balances[msg.sender] >= _value);
357         require(isTransferLock(msg.sender, _to) == false);
358         
359         balances[msg.sender] = balances[msg.sender].sub(_value);
360         balances[_to] = balances[_to].add(_value);
361         
362         emit Transfer(msg.sender, _to, _value);
363         
364         return true;
365     }
366     
367     function transferMultiple(address[] _addresses, uint[] _values) onlyOwner public returns (bool) 
368     {
369         require(_addresses.length == _values.length);
370         
371         for(uint i = 0; i < _addresses.length; i++)
372         {
373             require(balances[msg.sender] >= _values[i]);
374             require(isTransferLock(msg.sender, _addresses[i]) == false);
375             
376             balances[msg.sender] = balances[msg.sender].sub(_values[i]);
377             balances[_addresses[i]] = balances[_addresses[i]].add(_values[i]);
378             
379             emit Transfer(msg.sender, _addresses[i], _values[i]);
380         }
381         return true;
382     }
383     
384     function approve(address _spender, uint _value) public returns (bool)
385     {
386         require(balances[msg.sender] >= _value);
387         require(isTransferLock(msg.sender, _spender) == false);
388         
389         approvals[msg.sender][_spender] = _value;
390         
391         emit Approval(msg.sender, _spender, _value);
392         
393         return true;
394     }
395     
396     function allowance(address _owner, address _spender) constant public returns (uint) 
397     {
398         return approvals[_owner][_spender];
399     }
400     
401     function transferFrom(address _from, address _to, uint _value) public returns (bool) 
402     {
403         require(balances[_from] >= _value);
404         require(approvals[_from][msg.sender] >= _value);
405         require(isTransferLock(msg.sender, _to) == false);
406         
407         approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);
408         balances[_from] = balances[_from].sub(_value);
409         balances[_to]  = balances[_to].add(_value);
410         
411         emit Transfer(_from, _to, _value);
412         
413         return true;
414     }
415     
416     function withdrawRewardPool(address _who, uint _value) onlyOwner public
417     {
418         uint coins = _value * E18;
419         
420         require(rewardPoolSupply >= coinIssuedRewardPool.add(coins));
421 
422         totalSupply = totalSupply.add(coins);
423         coinIssuedRewardPool = coinIssuedRewardPool.add(coins);
424         coinIssuedTotal = coinIssuedTotal.add(coins);
425 
426         balances[_who] = balances[_who].add(coins);
427         personalLocks[_who] = true;
428 
429         emit Transfer(0x0, msg.sender, coins);
430         emit WithdrawRewardPool(_who, coins);
431     }
432     
433     function withdrawFoundation(address _who, uint _value) onlyOwner public
434     {
435         uint coins = _value * E18;
436         
437         require(foundationSupply >= coinIssuedFoundation.add(coins));
438 
439         totalSupply = totalSupply.add(coins);
440         coinIssuedFoundation = coinIssuedFoundation.add(coins);
441         coinIssuedTotal = coinIssuedTotal.add(coins);
442 
443         balances[_who] = balances[_who].add(coins);
444         personalLocks[_who] = true;
445 
446         emit Transfer(0x0, msg.sender, coins);
447         emit WithdrawFoundation(_who, coins);
448     }
449     
450     function withdrawGemmyMusic(address _who, uint _value) onlyOwner public
451     {
452         uint coins = _value * E18;
453         
454         require(gemmyMusicSupply >= coinIssuedGemmyMusic.add(coins));
455 
456         totalSupply = totalSupply.add(coins);
457         coinIssuedGemmyMusic = coinIssuedGemmyMusic.add(coins);
458         coinIssuedTotal = coinIssuedTotal.add(coins);
459 
460         balances[_who] = balances[_who].add(coins);
461         gemmyMusicLocks[_who] = true;
462 
463         emit Transfer(0x0, msg.sender, coins);
464         emit WithdrawGemmyMusic(_who, coins);
465     }
466     
467     function withdrawAdvisor(address _who, uint _value) onlyOwner public
468     {
469         uint coins = _value * E18;
470         
471         require(advisorSupply >= coinIssuedAdvisor.add(coins));
472 
473         totalSupply = totalSupply.add(coins);
474         coinIssuedAdvisor = coinIssuedAdvisor.add(coins);
475         coinIssuedTotal = coinIssuedTotal.add(coins);
476 
477         balances[_who] = balances[_who].add(coins * 20 / 100);
478         advisorFirstLockBalances[_who] = advisorFirstLockBalances[_who].add(coins * 40 / 100);
479         advisorSecondLockBalances[_who] = advisorSecondLockBalances[_who].add(coins * 40 / 100);
480         personalLocks[_who] = true;
481 
482         emit Transfer(0x0, msg.sender, coins);
483         emit WithdrawAdvisor(_who, coins);
484     }
485     
486     function withdrawMkt(address _who, uint _value) onlyOwner public
487     {
488         uint coins = _value * E18;
489         
490         require(mktSupply >= coinIssuedMkt.add(coins));
491 
492         totalSupply = totalSupply.add(coins);
493         coinIssuedMkt = coinIssuedMkt.add(coins);
494         coinIssuedTotal = coinIssuedTotal.add(coins);
495 
496         balances[_who] = balances[_who].add(coins);
497         personalLocks[_who] = true;
498 
499         emit Transfer(0x0, msg.sender, coins);
500         emit WithdrawMkt(_who, coins);
501     }
502     
503     function burnCoin() onlyOwner public
504     {
505         require(atNow() > secondCrowdSaleEndDate);
506         require(saleSupply - coinIssuedSale > 0);
507 
508         uint coins = saleSupply - coinIssuedSale;
509         
510         balances[0x0] = balances[0x0].add(coins);
511         coinIssuedSale = coinIssuedSale.add(coins);
512         coinIssuedBurn = coinIssuedBurn.add(coins);
513 
514         emit BurnCoin(coins);
515     }
516     
517     function changeWallet(address _who) onlyOwner public
518     {
519         require(_who != address(0x0));
520         require(_who != wallet);
521         
522         wallet = _who;
523         
524         emit ChangeWallet(_who);
525     }
526     
527     function refundCoin(address _who) onlyOwner public
528     {
529         require(totalCoinLock == true);
530         
531         uint coins = balances[_who];
532         
533         balances[wallet] = balances[wallet].add(coins);
534 
535         emit RefundCoin(_who, coins);
536     }
537 }