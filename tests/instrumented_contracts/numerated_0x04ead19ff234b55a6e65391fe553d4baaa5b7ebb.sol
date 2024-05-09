1 pragma solidity ^0.5.8;
2 
3 library SafeMath
4 {
5   	function mul(uint256 a, uint256 b) internal pure returns (uint256)
6     	{
7 		uint256 c = a * b;
8 		assert(a == 0 || c / a == b);
9 
10 		return c;
11   	}
12 
13   	function div(uint256 a, uint256 b) internal pure returns (uint256)
14 	{
15 		uint256 c = a / b;
16 
17 		return c;
18   	}
19 
20   	function sub(uint256 a, uint256 b) internal pure returns (uint256)
21 	{
22 		assert(b <= a);
23 
24 		return a - b;
25   	}
26 
27   	function add(uint256 a, uint256 b) internal pure returns (uint256)
28 	{
29 		uint256 c = a + b;
30 		assert(c >= a);
31 
32 		return c;
33   	}
34 }
35 
36 contract OwnerHelper
37 {
38   	address public master;
39   	address public owner1;
40   	address public owner2;
41   	
42   	address public targetAddress;
43   	uint public targetOwner;
44     mapping (address => bool) public targetTransferOwnership;
45 
46   	event ChangeOwnerSuggest(address indexed _from, address indexed _to, uint indexed _num);
47 
48   	modifier onlyOwner
49 	{
50 		require(msg.sender == owner1 ||msg.sender == owner2);
51 		_;
52   	}
53   	
54   	modifier onlyMaster
55   	{
56   	    require(msg.sender == master);
57   	    _;
58   	}
59   	
60   	constructor() public
61 	{
62 		master = msg.sender;
63   	}
64   	
65   	function changeOwnership1(address _to) onlyMaster public
66   	{
67   	    require(_to != address(0x0));
68 
69   	    owner1 = _to;
70   	}
71   	
72   	function changeOwnership2(address _to) onlyMaster public
73   	{
74   	    require(_to != address(0x0));
75   	    
76   	    owner2 = _to;
77   	}
78 }
79 
80 contract ERC20Interface
81 {
82     event Transfer( address indexed _from, address indexed _to, uint _value);
83     event Approval( address indexed _owner, address indexed _spender, uint _value);
84     
85     function totalSupply() view public returns (uint _supply);
86     function balanceOf( address _who ) public view returns (uint _value);
87     function transfer( address _to, uint _value) public returns (bool _success);
88     function approve( address _spender, uint _value ) public returns (bool _success);
89     function allowance( address _owner, address _spender ) public view returns (uint _allowance);
90     function transferFrom( address _from, address _to, uint _value) public returns (bool _success);
91 }
92 
93 contract ITAMToken is ERC20Interface, OwnerHelper
94 {
95     using SafeMath for uint;
96     
97     string public name;
98     uint public decimals;
99     string public symbol;
100     
101     uint constant private E18 = 1000000000000000000;
102     uint constant private month = 2592000;
103     
104     // Total                                        2,500,000,000
105     uint constant public maxTotalSupply =           2500000000 * E18;
106     
107     // Advisor & Early Supporters                   125,000,000 (5%)
108     // - Vesting 3 month 2 times
109     uint constant public maxAdvSptSupply =          125000000 * E18;
110     
111     // Team & Founder                               250,000,000 (10%)
112     // - Vesting 6 month 3 times
113     uint constant public maxTeamSupply =            250000000 * E18;
114     
115     // Marketing                                    375,000,000 (15%)
116     // - Vesting 6 month 1 time
117     uint constant public maxMktSupply =             375000000 * E18;
118     
119     // ITAM Ecosystem                               750,000,000 (30%)
120     // - Vesting 3 month 1 time
121     uint constant public maxEcoSupply =             750000000 * E18;
122     
123     // Sale Supply                                  1,000,000,000 (40%)
124     uint constant public maxSaleSupply =            1000000000 * E18;
125     
126     // * Sale Details
127     // Friends and Family                           130,000,000 (5.2%)
128     // - Lock Monthly 20% 20% 20% 20% 20% 
129     uint constant public maxFnFSaleSupply =         130000000 * E18;
130     
131     // Private Sale                                 345,000,000 (13.8%)
132     // - Lock Monthly 20% 20% 20% 20% 10% 10%
133     uint constant public maxPrivateSaleSupply =     345000000 * E18;
134     
135     // Public Sale                                  525,000,000 (19%)
136     uint constant public maxPublicSaleSupply =      525000000 * E18;
137     // *
138     
139     uint constant public advSptVestingSupplyPerTime = 25000000 * E18;
140     uint constant public advSptVestingDate = 2 * month;
141     uint constant public advSptVestingTime = 5;
142     
143     uint constant public teamVestingSupplyPerTime   = 12500000 * E18;
144     uint constant public teamVestingDelayDate = 6 * month;
145     uint constant public teamVestingDate = 1 * month;
146     uint constant public teamVestingTime = 20;
147     
148     uint constant public mktVestingSupplyFirst      = 125000000 * E18;
149     uint constant public mktVestingSupplyPerTime    =  25000000 * E18;
150     uint constant public mktVestingDate = 1 * month;
151     uint constant public mktVestingTime = 11;
152     
153     uint constant public ecoVestingSupplyFirst      = 250000000 * E18;
154     uint constant public ecoVestingSupplyPerTime    =  50000000 * E18;
155     uint constant public ecoVestingDate = 1 * month;
156     uint constant public ecoVestingTime = 11;
157     
158     uint constant public fnfSaleLockDate = 1 * month;
159     uint constant public fnfSaleLockTime = 5;
160     
161     uint constant public privateSaleLockDate = 1 * month;
162     uint constant public privateSaleLockTime = 6;
163     
164     uint public totalTokenSupply;
165     
166     uint public tokenIssuedAdvSpt;
167     uint public tokenIssuedTeam;
168     uint public tokenIssuedMkt;
169     uint public tokenIssuedEco;
170     
171     uint public tokenIssuedSale;
172     uint public fnfIssuedSale;
173     uint public privateIssuedSale;
174     uint public publicIssuedSale;
175     
176     uint public burnTokenSupply;
177     
178     mapping (address => uint) public balances;
179     mapping (address => mapping ( address => uint )) public approvals;
180     mapping (address => bool) public blackLists;
181     
182     mapping (uint => uint) public advSptVestingTimer;
183     mapping (uint => uint) public advSptVestingBalances;
184     
185     mapping (uint => uint) public teamVestingTimer;
186     mapping (uint => uint) public teamVestingBalances;
187     
188     mapping (uint => uint) public mktVestingTimer;
189     mapping (uint => uint) public mktVestingBalances;
190     
191     mapping (uint => uint) public ecoVestingTimer;
192     mapping (uint => uint) public ecoVestingBalances;
193     
194     mapping (uint => uint) public fnfLockTimer;
195     mapping (address => mapping ( uint => uint )) public fnfLockWallet;
196     
197     mapping (uint => uint) public privateLockTimer;
198     mapping (address => mapping ( uint => uint )) public privateLockWallet;
199     
200     bool public tokenLock = true;
201     bool public saleTime = true;
202     uint public endSaleTime = 0;
203     
204     event AdvSptIssue(address indexed _to, uint _tokens);
205     event TeamIssue(address indexed _to, uint _tokens);
206     event MktIssue(address indexed _to, uint _tokens);
207     event EcoIssue(address indexed _to, uint _tokens);
208     event SaleIssue(address indexed _to, uint _tokens);
209     
210     event Burn(address indexed _from, uint _value);
211     
212     event TokenUnlock(address indexed _to, uint _tokens);
213     event EndSale(uint _date);
214     
215     constructor() public
216     {
217         name        = "ITAM";
218         decimals    = 18;
219         symbol      = "ITAM";
220         
221         totalTokenSupply    = 0;
222         
223         tokenIssuedAdvSpt   = 0;
224         tokenIssuedTeam     = 0;
225         tokenIssuedMkt      = 0;
226         tokenIssuedEco      = 0;
227         tokenIssuedSale     = 0;
228         
229         fnfIssuedSale       = 0;
230         privateIssuedSale   = 0;
231         publicIssuedSale    = 0;
232 
233         burnTokenSupply     = 0;
234         
235         require(maxAdvSptSupply == advSptVestingSupplyPerTime * advSptVestingTime, "Invalid AdvSpt Supply");
236         require(maxTeamSupply == teamVestingSupplyPerTime * teamVestingTime, "Invalid Team Supply");
237         require(maxMktSupply == mktVestingSupplyFirst + ( mktVestingSupplyPerTime * ( mktVestingTime - 1 ) ) , "Invalid Mkt Supply");
238         require(maxEcoSupply == ecoVestingSupplyFirst + ( ecoVestingSupplyPerTime * ( ecoVestingTime - 1 ) ) , "Invalid Eco Supply");
239         
240         uint fnfPercent = 0;
241         for(uint i = 0; i < fnfSaleLockTime; i++)
242         {
243             fnfPercent = fnfPercent.add(20);
244         }
245         require(100 == fnfPercent, "Invalid FnF Percent");
246         
247         uint privatePercent = 0;
248         for(uint i = 0; i < privateSaleLockTime; i++)
249         {
250             if(i <= 3)
251             {
252                 privatePercent = privatePercent.add(20);
253             }
254             else
255             {
256                 privatePercent = privatePercent.add(10);
257             }
258         }
259         require(100 == privatePercent, "Invalid Private Percent");
260         
261         require(maxTotalSupply == maxAdvSptSupply + maxTeamSupply + maxMktSupply + maxEcoSupply + maxSaleSupply, "Invalid Total Supply");
262         require(maxSaleSupply == maxFnFSaleSupply + maxPrivateSaleSupply + maxPublicSaleSupply, "Invalid Sale Supply");
263     }
264     
265     // ERC - 20 Interface -----
266 
267     function totalSupply() view public returns (uint) 
268     {
269         return totalTokenSupply;
270     }
271     
272     function balanceOf(address _who) view public returns (uint) 
273     {
274         return balances[_who];
275     }
276     
277     function balanceOfAll(address _who) view public returns (uint)
278     {
279         uint balance = balances[_who];
280         uint fnfBalances = (fnfLockWallet[_who][0] + fnfLockWallet[_who][1] + fnfLockWallet[_who][2] + fnfLockWallet[_who][3] + fnfLockWallet[_who][4]);
281         uint privateBalances = (privateLockWallet[_who][0] + privateLockWallet[_who][1] + privateLockWallet[_who][2] + privateLockWallet[_who][3] + privateLockWallet[_who][4] + privateLockWallet[_who][5]);
282         balance = balance.add(fnfBalances);
283         balance = balance.add(privateBalances);
284         
285         return balance;
286     }
287     
288     function transfer(address _to, uint _value) public returns (bool) 
289     {
290         require(isTransferable(msg.sender) == true);
291         require(isTransferable(_to) == true);
292         require(balances[msg.sender] >= _value);
293         
294         balances[msg.sender] = balances[msg.sender].sub(_value);
295         balances[_to] = balances[_to].add(_value);
296         
297         emit Transfer(msg.sender, _to, _value);
298         
299         return true;
300     }
301     
302     function approve(address _spender, uint _value) public returns (bool)
303     {
304         require(isTransferable(msg.sender) == true);
305         require(balances[msg.sender] >= _value);
306         
307         approvals[msg.sender][_spender] = _value;
308         
309         emit Approval(msg.sender, _spender, _value);
310         
311         return true; 
312     }
313     
314     function allowance(address _owner, address _spender) view public returns (uint) 
315     {
316         return approvals[_owner][_spender];
317     }
318 
319     function transferFrom(address _from, address _to, uint _value) public returns (bool) 
320     {
321         require(isTransferable(_from) == true);
322         require(isTransferable(_to) == true);
323         require(balances[_from] >= _value);
324         require(approvals[_from][msg.sender] >= _value);
325         
326         approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);
327         balances[_from] = balances[_from].sub(_value);
328         balances[_to]  = balances[_to].add(_value);
329         
330         emit Transfer(_from, _to, _value);
331         
332         return true;
333     }
334     
335     // -----
336     
337     // Vesting Function -----
338     
339     // _time : 0 ~ 4
340     function advSptIssue(address _to, uint _time) onlyOwner public
341     {
342         require(saleTime == false);
343         require( _time < advSptVestingTime);
344         
345         uint nowTime = now;
346         require( nowTime > advSptVestingTimer[_time] );
347         
348         uint tokens = advSptVestingSupplyPerTime;
349 
350         require(tokens <= advSptVestingBalances[_time]);
351         require(tokens > 0);
352         require(maxAdvSptSupply >= tokenIssuedAdvSpt.add(tokens));
353         
354         balances[_to] = balances[_to].add(tokens);
355         advSptVestingBalances[_time] = 0;
356         
357         totalTokenSupply = totalTokenSupply.add(tokens);
358         tokenIssuedAdvSpt = tokenIssuedAdvSpt.add(tokens);
359         
360         emit AdvSptIssue(_to, tokens);
361     }
362     
363     // _time : 0 ~ 19
364     function teamIssue(address _to, uint _time) onlyOwner public
365     {
366         require(saleTime == false);
367         require( _time < teamVestingTime);
368         
369         uint nowTime = now;
370         require( nowTime > teamVestingTimer[_time] );
371         
372         uint tokens = teamVestingSupplyPerTime;
373 
374         require(tokens <= teamVestingBalances[_time]);
375         require(tokens > 0);
376         require(maxTeamSupply >= tokenIssuedTeam.add(tokens));
377         
378         balances[_to] = balances[_to].add(tokens);
379         teamVestingBalances[_time] = 0;
380         
381         totalTokenSupply = totalTokenSupply.add(tokens);
382         tokenIssuedTeam = tokenIssuedTeam.add(tokens);
383         
384         emit TeamIssue(_to, tokens);
385     }
386     
387     // _time : 0 ~ 10
388     function mktIssue(address _to, uint _time, uint _value) onlyOwner public
389     {
390         require(saleTime == false);
391         require( _time < mktVestingTime);
392         
393         uint nowTime = now;
394         require( nowTime > mktVestingTimer[_time] );
395         
396         uint tokens = _value * E18;
397 
398         require(tokens <= mktVestingBalances[_time]);
399         require(tokens > 0);
400         require(maxMktSupply >= tokenIssuedMkt.add(tokens));
401         
402         balances[_to] = balances[_to].add(tokens);
403         mktVestingBalances[_time] = mktVestingBalances[_time].sub(tokens);
404         
405         totalTokenSupply = totalTokenSupply.add(tokens);
406         tokenIssuedMkt = tokenIssuedMkt.add(tokens);
407         
408         emit MktIssue(_to, tokens);
409     }
410     
411     // _time : 0 ~ 10
412     function ecoIssue(address _to, uint _time, uint _value) onlyOwner public
413     {
414         require(saleTime == false);
415         require( _time < ecoVestingTime);
416         
417         uint nowTime = now;
418         require( nowTime > ecoVestingTimer[_time] );
419         
420         uint tokens = _value * E18;
421 
422         require(tokens <= ecoVestingBalances[_time]);
423         require(tokens > 0);
424         require(maxEcoSupply >= tokenIssuedEco.add(tokens));
425         
426         balances[_to] = balances[_to].add(tokens);
427         ecoVestingBalances[_time] = ecoVestingBalances[_time].sub(tokens);
428         
429         totalTokenSupply = totalTokenSupply.add(tokens);
430         tokenIssuedEco = tokenIssuedEco.add(tokens);
431         
432         emit EcoIssue(_to, tokens);
433     }
434     
435     // Sale Function -----
436     
437     function fnfSaleIssue(address _to, uint _value) onlyOwner public
438     {
439         uint tokens = _value * E18;
440         require(maxSaleSupply >= tokenIssuedSale.add(tokens));
441         require(maxFnFSaleSupply >= fnfIssuedSale.add(tokens));
442         require(tokens > 0);
443         
444         for(uint i = 0; i < fnfSaleLockTime; i++)
445         {
446             uint lockTokens = tokens.mul(20) / 100;
447             fnfLockWallet[_to][i] = lockTokens;
448         }
449         
450         balances[_to] = balances[_to].add(fnfLockWallet[_to][0]);
451         fnfLockWallet[_to][0] = 0;
452         
453         totalTokenSupply = totalTokenSupply.add(tokens);
454         tokenIssuedSale = tokenIssuedSale.add(tokens);
455         fnfIssuedSale = fnfIssuedSale.add(tokens);
456         
457         emit SaleIssue(_to, tokens);
458     }
459     
460     // _time : 1 ~ 4
461     function fnfSaleUnlock(address _to, uint _time) onlyOwner public
462     {
463         require(saleTime == false);
464         require( _time < fnfSaleLockTime);
465         
466         uint nowTime = now;
467         require( nowTime > fnfLockTimer[_time] );
468         
469         uint tokens = fnfLockWallet[_to][_time];
470         require(tokens > 0);
471         
472         balances[_to] = balances[_to].add(tokens);
473         fnfLockWallet[_to][_time] = 0;
474         
475         emit TokenUnlock(_to, tokens);
476     }
477     
478     function privateSaleIssue(address _to, uint _value) onlyOwner public
479     {
480         uint tokens = _value * E18;
481         require(maxSaleSupply >= tokenIssuedSale.add(tokens));
482         require(maxPrivateSaleSupply >= privateIssuedSale.add(tokens));
483         require(tokens > 0);
484         
485         for(uint i = 0; i < privateSaleLockTime; i++)
486         {
487             uint lockPer = 20;
488             if(i >= 4)
489             {
490                 lockPer = 10;
491             }
492             uint lockTokens = tokens.mul(lockPer) / 100;
493             privateLockWallet[_to][i] = lockTokens;
494         }
495         
496         balances[_to] = balances[_to].add(privateLockWallet[_to][0]);
497         privateLockWallet[_to][0] = 0;
498         
499         totalTokenSupply = totalTokenSupply.add(tokens);
500         tokenIssuedSale = tokenIssuedSale.add(tokens);
501         privateIssuedSale = privateIssuedSale.add(tokens);
502         
503         emit SaleIssue(_to, tokens);
504     }
505     
506     // _time : 1 ~ 5
507     function privateSaleUnlock(address _to, uint _time) onlyOwner public
508     {
509         require(saleTime == false);
510         require( _time < privateSaleLockTime);
511         
512         uint nowTime = now;
513         require( nowTime > privateLockTimer[_time] );
514         
515         uint tokens = privateLockWallet[_to][_time];
516         require(tokens > 0);
517         
518         balances[_to] = balances[_to].add(tokens);
519         privateLockWallet[_to][_time] = 0;
520         
521         emit TokenUnlock(_to, tokens);
522     }
523     
524     function publicSaleIssue(address _to, uint _value) onlyOwner public
525     {
526         uint tokens = _value * E18;
527         require(maxSaleSupply >= tokenIssuedSale.add(tokens));
528         
529         balances[_to] = balances[_to].add(tokens);
530         
531         totalTokenSupply = totalTokenSupply.add(tokens);
532         tokenIssuedSale = tokenIssuedSale.add(tokens);
533         publicIssuedSale = publicIssuedSale.add(tokens);
534         
535         emit SaleIssue(_to, tokens);
536     }
537     
538     // -----
539     
540     // Lock Function -----
541     
542     function isTransferable(address _who) private view returns (bool)
543     {
544         if(blackLists[_who] == true)
545         {
546             return false;
547         }
548         if(tokenLock == false)
549         {
550             return true;
551         }
552         else if(msg.sender == owner1 || msg.sender == owner2)
553         {
554             return true;
555         }
556         
557         return false;
558     }
559     
560     function setTokenUnlock() onlyOwner public
561     {
562         require(tokenLock == true);
563         require(saleTime == false);
564         
565         tokenLock = false;
566     }
567     
568     function setTokenLock() onlyOwner public
569     {
570         require(tokenLock == false);
571         
572         tokenLock = true;
573     }
574     
575     // -----
576     
577     // ETC / Burn Function -----
578     
579     function () payable external
580     {
581         revert();
582     }
583     
584     function endSale() onlyOwner public
585     {
586         require(saleTime == true);
587         require(maxSaleSupply == tokenIssuedSale);
588         
589         saleTime = false;
590         
591         uint nowTime = now;
592         
593         endSaleTime = nowTime;
594         
595         for(uint i = 0; i < advSptVestingTime; i++)
596         {
597             uint lockTime = endSaleTime + (advSptVestingDate * i);
598             advSptVestingTimer[i] = lockTime;
599             advSptVestingBalances[i] = advSptVestingBalances[i].add(advSptVestingSupplyPerTime);
600         }
601         
602         for(uint i = 0; i < teamVestingTime; i++)
603         {
604             uint lockTime = endSaleTime + teamVestingDelayDate + (teamVestingDate * i);
605             teamVestingTimer[i] = lockTime;
606             teamVestingBalances[i] = teamVestingBalances[i].add(teamVestingSupplyPerTime);
607         }
608         
609         for(uint i = 0; i < mktVestingTime; i++)
610         {
611             uint lockTime = endSaleTime + (mktVestingDate * i);
612             mktVestingTimer[i] = lockTime;
613             if(i == 0)
614             {
615                 mktVestingBalances[i] = mktVestingBalances[i].add(mktVestingSupplyFirst);
616             }
617             else
618             {
619                 mktVestingBalances[i] = mktVestingBalances[i].add(mktVestingSupplyPerTime);
620             }
621         }
622         
623         for(uint i = 0; i < ecoVestingTime; i++)
624         {
625             uint lockTime = endSaleTime + (ecoVestingDate * i);
626             ecoVestingTimer[i] = lockTime;
627             if(i == 0)
628             {
629                 ecoVestingBalances[i] = ecoVestingBalances[i].add(ecoVestingSupplyFirst);
630             }
631             else
632             {
633                 ecoVestingBalances[i] = ecoVestingBalances[i].add(ecoVestingSupplyPerTime);
634             }
635         }
636         
637         for(uint i = 0; i < fnfSaleLockTime; i++)
638         {
639             uint lockTime = endSaleTime + (fnfSaleLockDate * i);
640             fnfLockTimer[i] = lockTime;
641         }
642         
643         for(uint i = 0; i < privateSaleLockTime; i++)
644         {
645             uint lockTime = endSaleTime + (privateSaleLockDate * i);
646             privateLockTimer[i] = lockTime;
647         }
648         
649         emit EndSale(endSaleTime);
650     }
651     
652     function withdrawTokens(address _contract, uint _decimals, uint _value) onlyOwner public
653     {
654 
655         if(_contract == address(0x0))
656         {
657             uint eth = _value.mul(10 ** _decimals);
658             msg.sender.transfer(eth);
659         }
660         else
661         {
662             uint tokens = _value.mul(10 ** _decimals);
663             ERC20Interface(_contract).transfer(msg.sender, tokens);
664             
665             emit Transfer(address(0x0), msg.sender, tokens);
666         }
667     }
668     
669     function burnToken(uint _value) onlyOwner public
670     {
671         uint tokens = _value * E18;
672         
673         require(balances[msg.sender] >= tokens);
674         
675         balances[msg.sender] = balances[msg.sender].sub(tokens);
676         
677         burnTokenSupply = burnTokenSupply.add(tokens);
678         totalTokenSupply = totalTokenSupply.sub(tokens);
679         
680         emit Burn(msg.sender, tokens);
681     }
682     
683     function close() onlyOwner public
684     {
685         selfdestruct(msg.sender);
686     }
687     
688     // -----
689     
690     // BlackList function
691     
692     function addBlackList(address _to) onlyOwner public
693     {
694         require(blackLists[_to] == false);
695         
696         blackLists[_to] = true;
697     }
698     
699     function delBlackList(address _to) onlyOwner public
700     {
701         require(blackLists[_to] == true);
702         
703         blackLists[_to] = false;
704     }
705     
706     // -----
707 }