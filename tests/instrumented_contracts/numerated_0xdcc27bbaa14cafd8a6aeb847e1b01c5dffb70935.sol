1 pragma solidity ^0.5.1;
2 
3 // Made By Tom Jung
4 
5 library SafeMath
6 {
7   	function mul(uint256 a, uint256 b) internal pure returns (uint256)
8     	{
9 		uint256 c = a * b;
10 		assert(a == 0 || c / a == b);
11 
12 		return c;
13   	}
14 
15   	function div(uint256 a, uint256 b) internal pure returns (uint256)
16 	{
17 		uint256 c = a / b;
18 
19 		return c;
20   	}
21 
22   	function sub(uint256 a, uint256 b) internal pure returns (uint256)
23 	{
24 		assert(b <= a);
25 
26 		return a - b;
27   	}
28 
29   	function add(uint256 a, uint256 b) internal pure returns (uint256)
30 	{
31 		uint256 c = a + b;
32 		assert(c >= a);
33 
34 		return c;
35   	}
36 }
37 
38 contract OwnerHelper
39 {
40   	address public master;
41   	address public issuer;
42   	address public manager;
43 
44   	event ChangeMaster(address indexed _from, address indexed _to);
45   	event ChangeIssuer(address indexed _from, address indexed _to);
46   	event ChangeManager(address indexed _from, address indexed _to);
47 
48   	modifier onlyMaster
49 	{
50 		require(msg.sender == master);
51 		_;
52   	}
53   	
54   	modifier onlyIssuer
55 	{
56 		require(msg.sender == issuer);
57 		_;
58   	}
59   	
60   	modifier onlyManager
61 	{
62 		require(msg.sender == manager);
63 		_;
64   	}
65 
66   	constructor() public
67 	{
68 		master = msg.sender;
69   	}
70   	
71   	function transferMastership(address _to) onlyMaster public
72   	{
73         	require(_to != master);
74         	require(_to != issuer);
75         	require(_to != manager);
76         	require(_to != address(0x0));
77 
78 		address from = master;
79   	    	master = _to;
80   	    
81   	    	emit ChangeMaster(from, _to);
82   	}
83 
84   	function transferIssuer(address _to) onlyMaster public
85 	{
86 	        require(_to != master);
87         	require(_to != issuer);
88         	require(_to != manager);
89 	        require(_to != address(0x0));
90 
91 		address from = issuer;        
92 	    	issuer = _to;
93         
94     		emit ChangeIssuer(from, _to);
95   	}
96 
97   	function transferManager(address _to) onlyMaster public
98 	{
99 	        require(_to != master);
100 	        require(_to != issuer);
101         	require(_to != manager);
102 	        require(_to != address(0x0));
103         	
104 		address from = manager;
105     		manager = _to;
106         
107 	    	emit ChangeManager(from, _to);
108   	}
109 }
110 
111 contract ERC20Interface
112 {
113     event Transfer( address indexed _from, address indexed _to, uint _value);
114     event Approval( address indexed _owner, address indexed _spender, uint _value);
115     
116     function totalSupply() view public returns (uint _supply);
117     function balanceOf( address _who ) public view returns (uint _value);
118     function transfer( address _to, uint _value) public returns (bool _success);
119     function approve( address _spender, uint _value ) public returns (bool _success);
120     function allowance( address _owner, address _spender ) public view returns (uint _allowance);
121     function transferFrom( address _from, address _to, uint _value) public returns (bool _success);
122 }
123 
124 contract VantaToken is ERC20Interface, OwnerHelper
125 {
126     using SafeMath for uint;
127     
128     string public name;
129     uint public decimals;
130     string public symbol;
131     
132     uint constant private E18 = 1000000000000000000;
133     uint constant private month = 2592000;
134     
135     uint constant public maxTotalSupply     = 56200000000 * E18;
136     
137     uint constant public maxSaleSupply      = 19670000000 * E18;
138     uint constant public maxBdevSupply      =  8430000000 * E18;
139     uint constant public maxMktSupply       =  8430000000 * E18;
140     uint constant public maxRndSupply       =  8430000000 * E18;
141     uint constant public maxTeamSupply      =  5620000000 * E18;
142     uint constant public maxReserveSupply   =  2810000000 * E18;
143     uint constant public maxAdvisorSupply   =  2810000000 * E18;
144     
145     uint constant public teamVestingSupplyPerTime       = 351250000 * E18;
146     uint constant public advisorVestingSupplyPerTime    = 702500000 * E18;
147     uint constant public teamVestingDate                = 2 * month;
148     uint constant public teamVestingTime                = 16;
149     uint constant public advisorVestingDate             = 3 * month;
150     uint constant public advisorVestingTime             = 4;
151     
152     uint public totalTokenSupply;
153     
154     uint public tokenIssuedSale;
155     uint public privateIssuedSale;
156     uint public publicIssuedSale;
157     uint public tokenIssuedBdev;
158     uint public tokenIssuedMkt;
159     uint public tokenIssuedRnd;
160     uint public tokenIssuedTeam;
161     uint public tokenIssuedReserve;
162     uint public tokenIssuedAdvisor;
163     
164     uint public burnTokenSupply;
165     
166     mapping (address => uint) public balances;
167     mapping (address => mapping ( address => uint )) public approvals;
168     
169     mapping (address => uint) public privateFirstWallet;
170     
171     mapping (address => uint) public privateSecondWallet;
172     
173     mapping (uint => uint) public teamVestingTimeAtSupply;
174     mapping (uint => uint) public advisorVestingTimeAtSupply;
175     
176     bool public tokenLock = true;
177     bool public saleTime = true;
178     uint public endSaleTime = 0;
179     
180     event Burn(address indexed _from, uint _value);
181     
182     event SaleIssue(address indexed _to, uint _tokens);
183     event BdevIssue(address indexed _to, uint _tokens);
184     event MktIssue(address indexed _to, uint _tokens);
185     event RndIssue(address indexed _to, uint _tokens);
186     event TeamIssue(address indexed _to, uint _tokens);
187     event ReserveIssue(address indexed _to, uint _tokens);
188     event AdvisorIssue(address indexed _to, uint _tokens);
189     
190     event TokenUnLock(address indexed _to, uint _tokens);
191     
192     constructor() public
193     {
194         name        = "VANTA Token";
195         decimals    = 18;
196         symbol      = "VNT";
197         
198         totalTokenSupply = 0;
199         
200         tokenIssuedSale     = 0;
201         tokenIssuedBdev     = 0;
202         tokenIssuedMkt      = 0;
203         tokenIssuedRnd      = 0;
204         tokenIssuedTeam     = 0;
205         tokenIssuedReserve  = 0;
206         tokenIssuedAdvisor  = 0;
207         
208         require(maxTotalSupply == maxSaleSupply + maxBdevSupply + maxMktSupply + maxRndSupply + maxTeamSupply + maxReserveSupply + maxAdvisorSupply);
209         
210         require(maxTeamSupply == teamVestingSupplyPerTime * teamVestingTime);
211         require(maxAdvisorSupply == advisorVestingSupplyPerTime * advisorVestingTime);
212     }
213     
214     // ERC - 20 Interface -----
215 
216     function totalSupply() view public returns (uint) 
217     {
218         return totalTokenSupply;
219     }
220     
221     function balanceOf(address _who) view public returns (uint) 
222     {
223         uint balance = balances[_who];
224         balance = balance.add(privateFirstWallet[_who] + privateSecondWallet[_who]);
225         
226         return balance;
227     }
228     
229     function transfer(address _to, uint _value) public returns (bool) 
230     {
231         require(isTransferable() == true);
232         require(balances[msg.sender] >= _value);
233         
234         balances[msg.sender] = balances[msg.sender].sub(_value);
235         balances[_to] = balances[_to].add(_value);
236         
237         emit Transfer(msg.sender, _to, _value);
238         
239         return true;
240     }
241     
242     function approve(address _spender, uint _value) public returns (bool)
243     {
244         require(isTransferable() == true);
245         require(balances[msg.sender] >= _value);
246         
247         approvals[msg.sender][_spender] = _value;
248         
249         emit Approval(msg.sender, _spender, _value);
250         
251         return true; 
252     }
253     
254     function allowance(address _owner, address _spender) view public returns (uint) 
255     {
256         return approvals[_owner][_spender];
257     }
258 
259     function transferFrom(address _from, address _to, uint _value) public returns (bool) 
260     {
261         require(isTransferable() == true);
262         require(balances[_from] >= _value);
263         require(approvals[_from][msg.sender] >= _value);
264         
265         approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);
266         balances[_from] = balances[_from].sub(_value);
267         balances[_to]  = balances[_to].add(_value);
268         
269         emit Transfer(_from, _to, _value);
270         
271         return true;
272     }
273     
274     // -----
275     
276     // Issue Function -----
277     
278     function privateIssue(address _to, uint _value) onlyIssuer public
279     {
280         uint tokens = _value * E18;
281         require(maxSaleSupply >= tokenIssuedSale.add(tokens));
282         
283         balances[_to]                   = balances[_to].add( tokens.mul(435)/1000 );
284         privateFirstWallet[_to]         = privateFirstWallet[_to].add( tokens.mul(435)/1000 );
285         privateSecondWallet[_to]        = privateSecondWallet[_to].add( tokens.mul(130)/1000 );
286         
287         totalTokenSupply = totalTokenSupply.add(tokens);
288         tokenIssuedSale = tokenIssuedSale.add(tokens);
289         privateIssuedSale = privateIssuedSale.add(tokens);
290         
291         emit SaleIssue(_to, tokens);
292     }
293     
294     function publicIssue(address _to, uint _value) onlyIssuer public
295     {
296         uint tokens = _value * E18;
297         require(maxSaleSupply >= tokenIssuedSale.add(tokens));
298         
299         balances[_to] = balances[_to].add(tokens);
300         
301         totalTokenSupply = totalTokenSupply.add(tokens);
302         tokenIssuedSale = tokenIssuedSale.add(tokens);
303         publicIssuedSale = publicIssuedSale.add(tokens);
304         
305         emit SaleIssue(_to, tokens);
306     }
307     
308     function bdevIssue(address _to, uint _value) onlyIssuer public
309     {
310         uint tokens = _value * E18;
311         require(maxBdevSupply >= tokenIssuedBdev.add(tokens));
312         
313         balances[_to] = balances[_to].add(tokens);
314         
315         totalTokenSupply = totalTokenSupply.add(tokens);
316         tokenIssuedBdev = tokenIssuedBdev.add(tokens);
317         
318         emit BdevIssue(_to, tokens);
319     }
320     
321     function mktIssue(address _to, uint _value) onlyIssuer public
322     {
323         uint tokens = _value * E18;
324         require(maxMktSupply >= tokenIssuedMkt.add(tokens));
325         
326         balances[_to] = balances[_to].add(tokens);
327         
328         totalTokenSupply = totalTokenSupply.add(tokens);
329         tokenIssuedMkt = tokenIssuedMkt.add(tokens);
330         
331         emit MktIssue(_to, tokens);
332     }
333     
334     function rndIssue(address _to, uint _value) onlyIssuer public
335     {
336         uint tokens = _value * E18;
337         require(maxRndSupply >= tokenIssuedRnd.add(tokens));
338         
339         balances[_to] = balances[_to].add(tokens);
340         
341         totalTokenSupply = totalTokenSupply.add(tokens);
342         tokenIssuedRnd = tokenIssuedRnd.add(tokens);
343         
344         emit RndIssue(_to, tokens);
345     }
346     
347     function reserveIssue(address _to, uint _value) onlyIssuer public
348     {
349         uint tokens = _value * E18;
350         require(maxReserveSupply >= tokenIssuedReserve.add(tokens));
351         
352         balances[_to] = balances[_to].add(tokens);
353         
354         totalTokenSupply = totalTokenSupply.add(tokens);
355         tokenIssuedReserve = tokenIssuedReserve.add(tokens);
356         
357         emit ReserveIssue(_to, tokens);
358     }
359     
360     // ----
361     
362     // Vesting Issue Function -----
363     
364     function teamIssueVesting(address _to, uint _time) onlyIssuer public
365     {
366         require(saleTime == false);
367         require(teamVestingTime >= _time);
368         
369         uint time = now;
370         require( ( ( endSaleTime + (_time * teamVestingDate) ) < time ) && ( teamVestingTimeAtSupply[_time] > 0 ) );
371         
372         uint tokens = teamVestingTimeAtSupply[_time];
373 
374         require(maxTeamSupply >= tokenIssuedTeam.add(tokens));
375         
376         balances[_to] = balances[_to].add(tokens);
377         teamVestingTimeAtSupply[_time] = 0;
378         
379         totalTokenSupply = totalTokenSupply.add(tokens);
380         tokenIssuedTeam = tokenIssuedTeam.add(tokens);
381         
382         emit TeamIssue(_to, tokens);
383     }
384     
385     function advisorIssueVesting(address _to, uint _time) onlyIssuer public
386     {
387         require(saleTime == false);
388         require(advisorVestingTime >= _time);
389         
390         uint time = now;
391         require( ( ( endSaleTime + (_time * advisorVestingDate) ) < time ) && ( advisorVestingTimeAtSupply[_time] > 0 ) );
392         
393         uint tokens = advisorVestingTimeAtSupply[_time];
394         
395         require(maxAdvisorSupply >= tokenIssuedAdvisor.add(tokens));
396         
397         balances[_to] = balances[_to].add(tokens);
398         advisorVestingTimeAtSupply[_time] = 0;
399         
400         totalTokenSupply = totalTokenSupply.add(tokens);
401         tokenIssuedAdvisor = tokenIssuedAdvisor.add(tokens);
402         
403         emit AdvisorIssue(_to, tokens);
404     }
405     
406     // -----
407     
408     // Lock Function -----
409     
410     function isTransferable() private view returns (bool)
411     {
412         if(tokenLock == false)
413         {
414             return true;
415         }
416         else if(msg.sender == manager)
417         {
418             return true;
419         }
420         
421         return false;
422     }
423     
424     function setTokenUnlock() onlyManager public
425     {
426         require(tokenLock == true);
427         require(saleTime == false);
428         
429         tokenLock = false;
430     }
431     
432     function setTokenLock() onlyManager public
433     {
434         require(tokenLock == false);
435         
436         tokenLock = true;
437     }
438     
439     function privateUnlock(address _to) onlyManager public
440     {
441         require(tokenLock == false);
442         require(saleTime == false);
443         
444         uint time = now;
445         uint unlockTokens = 0;
446 
447         if( (time >= endSaleTime.add(month)) && (privateFirstWallet[_to] > 0) )
448         {
449             balances[_to] = balances[_to].add(privateFirstWallet[_to]);
450             unlockTokens = unlockTokens.add(privateFirstWallet[_to]);
451             privateFirstWallet[_to] = 0;
452         }
453         
454         if( (time >= endSaleTime.add(month * 2)) && (privateSecondWallet[_to] > 0) )
455         {
456             balances[_to] = balances[_to].add(privateSecondWallet[_to]);
457             unlockTokens = unlockTokens.add(privateSecondWallet[_to]);
458             privateSecondWallet[_to] = 0;
459         }
460         
461         emit TokenUnLock(_to, unlockTokens);
462     }
463     
464     // -----
465     
466     // ETC / Burn Function -----
467     
468     function () payable external
469     {
470         revert();
471     }
472     
473     function endSale() onlyManager public
474     {
475         require(saleTime == true);
476         
477         saleTime = false;
478         
479         uint time = now;
480         
481         endSaleTime = time;
482         
483         for(uint i = 1; i <= teamVestingTime; i++)
484         {
485             teamVestingTimeAtSupply[i] = teamVestingTimeAtSupply[i].add(teamVestingSupplyPerTime);
486         }
487         
488         for(uint i = 1; i <= advisorVestingTime; i++)
489         {
490             advisorVestingTimeAtSupply[i] = advisorVestingTimeAtSupply[i].add(advisorVestingSupplyPerTime);
491         }
492     }
493     
494     function withdrawTokens(address _contract, uint _decimals, uint _value) onlyManager public
495     {
496 
497         if(_contract == address(0x0))
498         {
499             uint eth = _value.mul(10 ** _decimals);
500             msg.sender.transfer(eth);
501         }
502         else
503         {
504             uint tokens = _value.mul(10 ** _decimals);
505             ERC20Interface(_contract).transfer(msg.sender, tokens);
506             
507             emit Transfer(address(0x0), msg.sender, tokens);
508         }
509     }
510     
511     function burnToken(uint _value) onlyManager public
512     {
513         uint tokens = _value * E18;
514         
515         require(balances[msg.sender] >= tokens);
516         
517         balances[msg.sender] = balances[msg.sender].sub(tokens);
518         
519         burnTokenSupply = burnTokenSupply.add(tokens);
520         totalTokenSupply = totalTokenSupply.sub(tokens);
521         
522         emit Burn(msg.sender, tokens);
523     }
524     
525     function close() onlyMaster public
526     {
527         selfdestruct(msg.sender);
528     }
529     
530     // -----
531 }