1 pragma solidity ^0.5.9;
2 
3 // Made By Tom - tom@devtooth.com
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
40   	address public owner;
41 
42   	event ChangeOwner(address indexed _from, address indexed _to);
43 
44   	modifier onlyOwner
45 	{
46 		require(msg.sender == owner);
47 		_;
48   	}
49   	
50   	constructor() public
51 	{
52 		owner = msg.sender;
53   	}
54   	
55   	function transferOwnership(address _to) onlyOwner public
56   	{
57     	require(_to != owner);
58     	require(_to != address(0x0));
59 
60         address from = owner;
61       	owner = _to;
62   	    
63       	emit ChangeOwner(from, _to);
64   	}
65 }
66 
67 contract ERC20Interface
68 {
69     event Transfer( address indexed _from, address indexed _to, uint _value);
70     event Approval( address indexed _owner, address indexed _spender, uint _value);
71     
72     function totalSupply() view public returns (uint _supply);
73     function balanceOf( address _who ) public view returns (uint _value);
74     function transfer( address _to, uint _value) public returns (bool _success);
75     function approve( address _spender, uint _value ) public returns (bool _success);
76     function allowance( address _owner, address _spender ) public view returns (uint _allowance);
77     function transferFrom( address _from, address _to, uint _value) public returns (bool _success);
78 }
79 
80 contract LINIXToken is ERC20Interface, OwnerHelper
81 {
82     using SafeMath for uint;
83     
84     string public name;
85     uint public decimals;
86     string public symbol;
87     
88     uint constant private E18 = 1000000000000000000;
89     uint constant private month = 2592000;
90     
91     // Total                                        2,473,750,000
92     uint constant public maxTotalSupply =           2473750000 * E18;
93     
94     // Team                                          247,375,000 (10%)
95     uint constant public maxTeamSupply =             247375000 * E18;
96     // - 3 months after Vesting 24 times
97     
98     // R&D                                           247,375,000 (10%)
99     uint constant public maxRnDSupply =              247375000 * E18;
100     // - 2 months after Vesting 18 times
101     
102     // EcoSystem                                     371,062,500 (15%)
103     uint constant public maxEcoSupply =              371062500 * E18;
104     // - 3 months after Vesting 12 times
105     
106     // Marketing                                     197,900,000 (8%)
107     uint constant public maxMktSupply =              197900000 * E18;
108     // - 1 months after Vesting 1 time
109     
110     // Reserve                                       296,850,000 (12%)
111     uint constant public maxReserveSupply =          296850000 * E18;
112     // - Vesting 7 times
113     
114     // Advisor                                       123,687,500 (5%)
115     uint constant public maxAdvisorSupply =          123687500 * E18;
116     
117     // Sale Supply                                   989,500,000 (40%)
118     uint constant public maxSaleSupply =             989500000 * E18;
119     
120     uint constant public publicSaleSupply =          100000000 * E18;
121     uint constant public privateSaleSupply =         889500000 * E18;
122     
123     // Lock
124     uint constant public rndVestingSupply           = 9895000 * E18;
125     uint constant public rndVestingTime = 25;
126     
127     uint constant public teamVestingSupply          = 247375000 * E18;
128     uint constant public teamVestingLockDate        = 24 * month;
129 
130     uint constant public advisorVestingSupply          = 30921875 * E18;
131     uint constant public advisorVestingLockDate        = 3 * month;
132     uint constant public advisorVestingTime = 4;
133     
134     uint public totalTokenSupply;
135     uint public tokenIssuedTeam;
136     uint public tokenIssuedRnD;
137     uint public tokenIssuedEco;
138     uint public tokenIssuedMkt;
139     uint public tokenIssuedRsv;
140     uint public tokenIssuedAdv;
141     uint public tokenIssuedSale;
142     
143     uint public burnTokenSupply;
144     
145     mapping (address => uint) public balances;
146     mapping (address => mapping ( address => uint )) public approvals;
147     
148     uint public teamVestingTime;
149     
150     mapping (uint => uint) public rndVestingTimer;
151     mapping (uint => uint) public rndVestingBalances;
152     
153     mapping (uint => uint) public advVestingTimer;
154     mapping (uint => uint) public advVestingBalances;
155     
156     bool public tokenLock = true;
157     bool public saleTime = true;
158     uint public endSaleTime = 0;
159     
160     event TeamIssue(address indexed _to, uint _tokens);
161     event RnDIssue(address indexed _to, uint _tokens);
162     event EcoIssue(address indexed _to, uint _tokens);
163     event MktIssue(address indexed _to, uint _tokens);
164     event RsvIssue(address indexed _to, uint _tokens);
165     event AdvIssue(address indexed _to, uint _tokens);
166     event SaleIssue(address indexed _to, uint _tokens);
167     
168     event Burn(address indexed _from, uint _tokens);
169     
170     event TokenUnlock(address indexed _to, uint _tokens);
171     event EndSale(uint _date);
172     
173     constructor() public
174     {
175         name        = "LINIX Token";
176         decimals    = 18;
177         symbol      = "LNX";
178         
179         totalTokenSupply    = 0;
180         
181         tokenIssuedTeam   = 0;
182         tokenIssuedRnD      = 0;
183         tokenIssuedEco     = 0;
184         tokenIssuedMkt      = 0;
185         tokenIssuedRsv    = 0;
186         tokenIssuedAdv    = 0;
187         tokenIssuedSale     = 0;
188 
189         burnTokenSupply     = 0;
190         
191         require(maxTeamSupply == teamVestingSupply);
192         require(maxRnDSupply == rndVestingSupply.mul(rndVestingTime));
193         require(maxAdvisorSupply == advisorVestingSupply.mul(advisorVestingTime));
194 
195         require(maxSaleSupply == publicSaleSupply + privateSaleSupply);
196         require(maxTotalSupply == maxTeamSupply + maxRnDSupply + maxEcoSupply + maxMktSupply + maxReserveSupply + maxAdvisorSupply + maxSaleSupply);
197     }
198     
199     // ERC - 20 Interface -----
200 
201     function totalSupply() view public returns (uint) 
202     {
203         return totalTokenSupply;
204     }
205     
206     function balanceOf(address _who) view public returns (uint) 
207     {
208         return balances[_who];
209     }
210     
211     function transfer(address _to, uint _value) public returns (bool) 
212     {
213         require(isTransferable() == true);
214         require(balances[msg.sender] >= _value);
215         
216         balances[msg.sender] = balances[msg.sender].sub(_value);
217         balances[_to] = balances[_to].add(_value);
218         
219         emit Transfer(msg.sender, _to, _value);
220         
221         return true;
222     }
223     
224     function approve(address _spender, uint _value) public returns (bool)
225     {
226         require(isTransferable() == true);
227         require(balances[msg.sender] >= _value);
228         
229         approvals[msg.sender][_spender] = _value;
230         
231         emit Approval(msg.sender, _spender, _value);
232         
233         return true; 
234     }
235     
236     function allowance(address _owner, address _spender) view public returns (uint) 
237     {
238         return approvals[_owner][_spender];
239     }
240 
241     function transferFrom(address _from, address _to, uint _value) public returns (bool) 
242     {
243         require(isTransferable() == true);
244         require(balances[_from] >= _value);
245         require(approvals[_from][msg.sender] >= _value);
246         
247         approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);
248         balances[_from] = balances[_from].sub(_value);
249         balances[_to]  = balances[_to].add(_value);
250         
251         emit Transfer(_from, _to, _value);
252         
253         return true;
254     }
255     
256     // -----
257     
258     // Vesting Function -----
259     
260     function teamIssue(address _to) onlyOwner public
261     {
262         require(saleTime == false);
263         
264         uint nowTime = now;
265         require(nowTime > teamVestingTime);
266         
267         uint tokens = teamVestingSupply;
268 
269         require(maxTeamSupply >= tokenIssuedTeam.add(tokens));
270         
271         balances[_to] = balances[_to].add(tokens);
272         
273         totalTokenSupply = totalTokenSupply.add(tokens);
274         tokenIssuedTeam = tokenIssuedTeam.add(tokens);
275         
276         emit TeamIssue(_to, tokens);
277     }
278     
279     // _time : 0 ~ 24
280     function rndIssue(address _to, uint _time) onlyOwner public
281     {
282         require(saleTime == false);
283         require(_time < rndVestingTime);
284         
285         uint nowTime = now;
286         require( nowTime > rndVestingTimer[_time] );
287         
288         uint tokens = rndVestingSupply;
289 
290         require(tokens == rndVestingBalances[_time]);
291         require(maxRnDSupply >= tokenIssuedRnD.add(tokens));
292         
293         balances[_to] = balances[_to].add(tokens);
294         rndVestingBalances[_time] = 0;
295         
296         totalTokenSupply = totalTokenSupply.add(tokens);
297         tokenIssuedRnD = tokenIssuedRnD.add(tokens);
298         
299         emit RnDIssue(_to, tokens);
300     }
301     
302     // _time : 0 ~ 3
303     function advisorIssue(address _to, uint _time) onlyOwner public
304     {
305         require(saleTime == false);
306         require( _time < advisorVestingTime);
307         
308         uint nowTime = now;
309         require( nowTime > advVestingTimer[_time] );
310         
311         uint tokens = advisorVestingSupply;
312 
313         require(tokens == advVestingBalances[_time]);
314         require(maxAdvisorSupply >= tokenIssuedAdv.add(tokens));
315         
316         balances[_to] = balances[_to].add(tokens);
317         advVestingBalances[_time] = 0;
318         
319         totalTokenSupply = totalTokenSupply.add(tokens);
320         tokenIssuedAdv = tokenIssuedAdv.add(tokens);
321         
322         emit AdvIssue(_to, tokens);
323     }
324     
325     function ecoIssue(address _to) onlyOwner public
326     {
327         require(saleTime == false);
328         require(tokenIssuedEco == 0);
329         
330         uint tokens = maxEcoSupply;
331         
332         balances[_to] = balances[_to].add(tokens);
333         
334         totalTokenSupply = totalTokenSupply.add(tokens);
335         tokenIssuedEco = tokenIssuedEco.add(tokens);
336         
337         emit EcoIssue(_to, tokens);
338     }
339     
340     function mktIssue(address _to) onlyOwner public
341     {
342         require(saleTime == false);
343         require(tokenIssuedMkt == 0);
344         
345         uint tokens = maxMktSupply;
346         
347         balances[_to] = balances[_to].add(tokens);
348         
349         totalTokenSupply = totalTokenSupply.add(tokens);
350         tokenIssuedMkt = tokenIssuedMkt.add(tokens);
351         
352         emit EcoIssue(_to, tokens);
353     }
354     
355     function rsvIssue(address _to) onlyOwner public
356     {
357         require(saleTime == false);
358         require(tokenIssuedRsv == 0);
359         
360         uint tokens = maxReserveSupply;
361         
362         balances[_to] = balances[_to].add(tokens);
363         
364         totalTokenSupply = totalTokenSupply.add(tokens);
365         tokenIssuedRsv = tokenIssuedRsv.add(tokens);
366         
367         emit EcoIssue(_to, tokens);
368     }
369     
370     function privateSaleIssue(address _to) onlyOwner public
371     {
372         require(tokenIssuedSale == 0);
373         
374         uint tokens = privateSaleSupply;
375         
376         balances[_to] = balances[_to].add(tokens);
377         
378         totalTokenSupply = totalTokenSupply.add(tokens);
379         tokenIssuedSale = tokenIssuedSale.add(tokens);
380         
381         emit SaleIssue(_to, tokens);
382     }
383     
384     function publicSaleIssue(address _to) onlyOwner public
385     {
386         require(tokenIssuedSale == privateSaleSupply);
387         
388         uint tokens = publicSaleSupply;
389         
390         balances[_to] = balances[_to].add(tokens);
391         
392         totalTokenSupply = totalTokenSupply.add(tokens);
393         tokenIssuedSale = tokenIssuedSale.add(tokens);
394         
395         emit SaleIssue(_to, tokens);
396     }
397     
398     // -----
399     
400     // Lock Function -----
401     
402     function isTransferable() private view returns (bool)
403     {
404         if(tokenLock == false)
405         {
406             return true;
407         }
408         else if(msg.sender == owner)
409         {
410             return true;
411         }
412         
413         return false;
414     }
415     
416     function setTokenUnlock() onlyOwner public
417     {
418         require(tokenLock == true);
419         require(saleTime == false);
420         
421         tokenLock = false;
422     }
423     
424     function setTokenLock() onlyOwner public
425     {
426         require(tokenLock == false);
427         
428         tokenLock = true;
429     }
430     
431     // -----
432     
433     // ETC / Burn Function -----
434     
435     function endSale() onlyOwner public
436     {
437         require(saleTime == true);
438         require(maxSaleSupply == tokenIssuedSale);
439         
440         saleTime = false;
441         
442         uint nowTime = now;
443         endSaleTime = nowTime;
444         
445         teamVestingTime = endSaleTime + teamVestingLockDate;
446         
447         for(uint i = 0; i < rndVestingTime; i++)
448         {
449             rndVestingTimer[i] =  endSaleTime + (month * i);
450             rndVestingBalances[i] = rndVestingSupply;
451         }
452         
453         for(uint i = 0; i < advisorVestingTime; i++)
454         {
455             advVestingTimer[i] = endSaleTime + (advisorVestingLockDate * i);
456             advVestingBalances[i] = advisorVestingSupply;
457         }
458         
459         emit EndSale(endSaleTime);
460     }
461     
462     function withdrawTokens(address _contract, uint _decimals, uint _value) onlyOwner public
463     {
464 
465         if(_contract == address(0x0))
466         {
467             uint eth = _value.mul(10 ** _decimals);
468             msg.sender.transfer(eth);
469         }
470         else
471         {
472             uint tokens = _value.mul(10 ** _decimals);
473             ERC20Interface(_contract).transfer(msg.sender, tokens);
474             
475             emit Transfer(address(0x0), msg.sender, tokens);
476         }
477     }
478     
479     function burnToken(uint _value) onlyOwner public
480     {
481         uint tokens = _value * E18;
482         
483         require(balances[msg.sender] >= tokens);
484         
485         balances[msg.sender] = balances[msg.sender].sub(tokens);
486         
487         burnTokenSupply = burnTokenSupply.add(tokens);
488         totalTokenSupply = totalTokenSupply.sub(tokens);
489         
490         emit Burn(msg.sender, tokens);
491     }
492     
493     function close() onlyOwner public
494     {
495         selfdestruct(msg.sender);
496     }
497     
498     // -----
499 }