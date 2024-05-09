1 pragma solidity ^0.5.9;
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
38   	address public owner;
39 
40   	event ChangeOwner(address indexed _from, address indexed _to);
41 
42   	modifier onlyOwner
43 	{
44 		require(msg.sender == owner);
45 		_;
46   	}
47   	
48   	constructor() public
49 	{
50 		owner = msg.sender;
51   	}
52   	
53   	function transferOwnership(address _to) onlyOwner public
54   	{
55     	require(_to != owner);
56     	require(_to != address(0x0));
57 
58         address from = owner;
59       	owner = _to;
60   	    
61       	emit ChangeOwner(from, _to);
62   	}
63 }
64 
65 contract ERC20Interface
66 {
67     event Transfer( address indexed _from, address indexed _to, uint _value);
68     event Approval( address indexed _owner, address indexed _spender, uint _value);
69     
70     function totalSupply() view public returns (uint _supply);
71     function balanceOf( address _who ) public view returns (uint _value);
72     function transfer( address _to, uint _value) public returns (bool _success);
73     function approve( address _spender, uint _value ) public returns (bool _success);
74     function allowance( address _owner, address _spender ) public view returns (uint _allowance);
75     function transferFrom( address _from, address _to, uint _value) public returns (bool _success);
76 }
77 
78 contract AssembleToken is ERC20Interface, OwnerHelper
79 {
80     using SafeMath for uint;
81     
82     string public name;
83     uint public decimals;
84     string public symbol;
85     
86     uint constant private E18 = 1000000000000000000;
87     uint constant private month = 2592000;
88     
89     // Total                                        1,500,000,000
90     uint constant public maxTotalSupply =           1500000000 * E18;
91 
92     // Sale Supply                                   300,000,000 (20%)
93     uint constant public maxSaleSupply =             300000000 * E18;
94 
95     // Strategic Partners                            270,000,000 (18%)
96     uint constant public maxSPSupply =               270000000 * E18;
97 
98     // EcoSystem                                     240,000,000 (16%)
99     uint constant public maxEcoSupply =              240000000 * E18;
100 
101     // Marketing                                     210,000,000 (14%)
102     uint constant public maxMktSupply =              210000000 * E18;
103 
104     // Development                                   180,000,000 (12%)
105     uint constant public maxDevSupply =              180000000 * E18;
106 
107     // Reserve                                       150,000,000 (10%)
108     uint constant public maxReserveSupply =          150000000 * E18;
109 
110     // Team                                           75,000,000 (5%)
111     uint constant public maxTeamSupply =              75000000 * E18;
112         
113     // Advisor                                        75,000,000 (5%)
114     uint constant public maxAdvisorSupply =           75000000 * E18;
115     
116     uint constant public seedSaleSupply =             40000000 * E18;
117     uint constant public privateSaleSupply =         250000000 * E18;
118     uint constant public publicSaleSupply =           10000000 * E18;
119         
120     // Lock
121     uint constant public teamVestingSupply =           3125000 * E18;
122     uint constant public teamVestingLockDate =  6 * month;
123     uint constant public teamVestingTime = 24;
124 
125     uint constant public advisorVestingSupply =       18750000 * E18;
126     uint constant public advisorVestingLockDate = 12 * month;
127     uint constant public advisorVestingTime = 4;
128     
129     uint public totalTokenSupply;
130     uint public tokenIssuedSale;
131     uint public tokenIssuedSP;
132     uint public tokenIssuedEco;
133     uint public tokenIssuedMkt;
134     uint public tokenIssuedDev;
135     uint public tokenIssuedRsv;
136     uint public tokenIssuedTeam;
137     uint public tokenIssuedAdv;
138         
139     uint public burnTokenSupply;
140     
141     mapping (address => uint) public balances;
142     mapping (address => mapping ( address => uint )) public approvals;
143     
144     mapping (uint => uint) public tmVestingTimer;
145     mapping (uint => uint) public tmVestingBalances;
146     
147     mapping (uint => uint) public advVestingTimer;
148     mapping (uint => uint) public advVestingBalances;
149     
150     bool public tokenLock = true;
151     bool public saleTime = true;
152     uint public endSaleTime = 0;
153 
154     event SaleIssue(address indexed _to, uint _tokens);    
155     event SPIssue(address indexed _to, uint _tokens);
156     event EcoIssue(address indexed _to, uint _tokens);
157     event MktIssue(address indexed _to, uint _tokens);
158     event DevIssue(address indexed _to, uint _tokens);
159     event RsvIssue(address indexed _to, uint _tokens);
160     event TeamIssue(address indexed _to, uint _tokens);
161     event AdvIssue(address indexed _to, uint _tokens);
162     
163     event Burn(address indexed _from, uint _tokens);
164     
165     event TokenUnlock(address indexed _to, uint _tokens);
166     event EndSale(uint _date);
167     
168     constructor() public
169     {
170         name        = "ASSEMBLE";
171         decimals    = 18;
172         symbol      = "ASM";
173         
174         totalTokenSupply    = 0;
175         
176         tokenIssuedSale     = 0;
177         tokenIssuedSP     = 0;
178         tokenIssuedEco     = 0;
179         tokenIssuedMkt      = 0;
180         tokenIssuedDev      = 0;
181         tokenIssuedRsv    = 0;
182         tokenIssuedTeam   = 0;
183         tokenIssuedAdv    = 0;
184         
185 
186         burnTokenSupply     = 0;
187         
188         require(maxTeamSupply == teamVestingSupply.mul(teamVestingTime));
189         require(maxAdvisorSupply == advisorVestingSupply.mul(advisorVestingTime));
190 
191         require(maxSaleSupply == seedSaleSupply + privateSaleSupply + publicSaleSupply);
192         require(maxTotalSupply == maxSaleSupply + maxSPSupply +  maxEcoSupply + maxMktSupply + maxDevSupply + maxReserveSupply + maxTeamSupply + maxAdvisorSupply);
193     }
194 
195     function totalSupply() view public returns (uint) 
196     {
197         return totalTokenSupply;
198     }
199     
200     function balanceOf(address _who) view public returns (uint) 
201     {
202         return balances[_who];
203     }
204     
205     function transfer(address _to, uint _value) public returns (bool) 
206     {
207         require(isTransferable() == true);
208         require(balances[msg.sender] >= _value);
209         
210         balances[msg.sender] = balances[msg.sender].sub(_value);
211         balances[_to] = balances[_to].add(_value);
212         
213         emit Transfer(msg.sender, _to, _value);
214         
215         return true;
216     }
217     
218     function approve(address _spender, uint _value) public returns (bool)
219     {
220         require(isTransferable() == true);
221         require(balances[msg.sender] >= _value);
222         
223         approvals[msg.sender][_spender] = _value;
224         
225         emit Approval(msg.sender, _spender, _value);
226         
227         return true; 
228     }
229     
230     function allowance(address _owner, address _spender) view public returns (uint) 
231     {
232         return approvals[_owner][_spender];
233     }
234 
235     function transferFrom(address _from, address _to, uint _value) public returns (bool) 
236     {
237         require(isTransferable() == true);
238         require(balances[_from] >= _value);
239         require(approvals[_from][msg.sender] >= _value);
240         
241         approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);
242         balances[_from] = balances[_from].sub(_value);
243         balances[_to]  = balances[_to].add(_value);
244         
245         emit Transfer(_from, _to, _value);
246         
247         return true;
248     }
249     
250     function spIssue(address _to) onlyOwner public
251     {
252         require(saleTime == false);
253         require(tokenIssuedSP == 0);
254         
255         uint tokens = maxSPSupply;
256         
257         balances[_to] = balances[_to].add(tokens);
258         
259         totalTokenSupply = totalTokenSupply.add(tokens);
260         tokenIssuedSP = tokenIssuedSP.add(tokens);
261         
262         emit SPIssue(_to, tokens);
263     }
264 
265     function ecoIssue(address _to) onlyOwner public
266     {
267         require(saleTime == false);
268         require(tokenIssuedEco == 0);
269         
270         uint tokens = maxEcoSupply;
271         
272         balances[_to] = balances[_to].add(tokens);
273         
274         totalTokenSupply = totalTokenSupply.add(tokens);
275         tokenIssuedEco = tokenIssuedEco.add(tokens);
276         
277         emit EcoIssue(_to, tokens);
278     }
279 
280     function mktIssue(address _to) onlyOwner public
281     {
282         require(saleTime == false);
283         require(tokenIssuedMkt == 0);
284         
285         uint tokens = maxMktSupply;
286         
287         balances[_to] = balances[_to].add(tokens);
288         
289         totalTokenSupply = totalTokenSupply.add(tokens);
290         tokenIssuedMkt = tokenIssuedMkt.add(tokens);
291         
292         emit MktIssue(_to, tokens);
293     }
294 
295     function devIssue(address _to) onlyOwner public
296     {
297         require(saleTime == false);
298         require(tokenIssuedDev == 0);
299         
300         uint tokens = maxDevSupply;
301         
302         balances[_to] = balances[_to].add(tokens);
303         
304         totalTokenSupply = totalTokenSupply.add(tokens);
305         tokenIssuedDev = tokenIssuedDev.add(tokens);
306         
307         emit DevIssue(_to, tokens);
308     }
309 
310     function rsvIssue(address _to) onlyOwner public
311     {
312         require(saleTime == false);
313         require(tokenIssuedRsv == 0);
314         
315         uint tokens = maxReserveSupply;
316         
317         balances[_to] = balances[_to].add(tokens);
318         
319         totalTokenSupply = totalTokenSupply.add(tokens);
320         tokenIssuedRsv = tokenIssuedRsv.add(tokens);
321         
322         emit RsvIssue(_to, tokens);
323     }
324 
325     // _time : 0 ~ 24
326     function teamIssue(address _to, uint _time) onlyOwner public
327     {
328         require(saleTime == false);
329         require( _time < teamVestingTime);
330         
331         uint nowTime = now;
332         require( nowTime > tmVestingTimer[_time] );
333         
334         uint tokens = teamVestingSupply;
335 
336         require(tokens == tmVestingBalances[_time]);
337         require(maxTeamSupply >= tokenIssuedTeam.add(tokens));
338         
339         balances[_to] = balances[_to].add(tokens);
340         tmVestingBalances[_time] = 0;
341         
342         totalTokenSupply = totalTokenSupply.add(tokens);
343         tokenIssuedTeam = tokenIssuedTeam.add(tokens);
344         
345         emit TeamIssue(_to, tokens);
346     }
347     
348     // _time : 0 ~ 4
349     function advisorIssue(address _to, uint _time) onlyOwner public
350     {
351         require(saleTime == false);
352         require( _time < advisorVestingTime);
353         
354         uint nowTime = now;
355         require( nowTime > advVestingTimer[_time] );
356         
357         uint tokens = advisorVestingSupply;
358 
359         require(tokens == advVestingBalances[_time]);
360         require(maxAdvisorSupply >= tokenIssuedAdv.add(tokens));
361         
362         balances[_to] = balances[_to].add(tokens);
363         advVestingBalances[_time] = 0;
364         
365         totalTokenSupply = totalTokenSupply.add(tokens);
366         tokenIssuedAdv = tokenIssuedAdv.add(tokens);
367         
368         emit AdvIssue(_to, tokens);
369     }
370     
371     function seedSaleIssue(address _to) onlyOwner public
372     {
373         require(tokenIssuedSale == 0);
374         
375         uint tokens = seedSaleSupply;
376         
377         balances[_to] = balances[_to].add(tokens);
378         
379         totalTokenSupply = totalTokenSupply.add(tokens);
380         tokenIssuedSale = tokenIssuedSale.add(tokens);
381         
382         emit SaleIssue(_to, tokens);
383     }
384     
385     function privateSaleIssue(address _to) onlyOwner public
386     {
387         require(tokenIssuedSale == seedSaleSupply);
388         
389         uint tokens = privateSaleSupply;
390         
391         balances[_to] = balances[_to].add(tokens);
392         
393         totalTokenSupply = totalTokenSupply.add(tokens);
394         tokenIssuedSale = tokenIssuedSale.add(tokens);
395         
396         emit SaleIssue(_to, tokens);
397     }
398     
399     function publicSaleIssue(address _to) onlyOwner public
400     {
401         require(tokenIssuedSale == seedSaleSupply + privateSaleSupply);
402         
403         uint tokens = publicSaleSupply;
404         
405         balances[_to] = balances[_to].add(tokens);
406         
407         totalTokenSupply = totalTokenSupply.add(tokens);
408         tokenIssuedSale = tokenIssuedSale.add(tokens);
409         
410         emit SaleIssue(_to, tokens);
411     }
412     
413     function isTransferable() private view returns (bool)
414     {
415         if(tokenLock == false)
416         {
417             return true;
418         }
419         else if(msg.sender == owner)
420         {
421             return true;
422         }
423         
424         return false;
425     }
426     
427     function setTokenUnlock() onlyOwner public
428     {
429         require(tokenLock == true);
430         require(saleTime == false);
431         
432         tokenLock = false;
433     }
434     
435     function setTokenLock() onlyOwner public
436     {
437         require(tokenLock == false);
438         
439         tokenLock = true;
440     }
441     
442     function endSale() onlyOwner public
443     {
444         require(saleTime == true);
445         require(maxSaleSupply == tokenIssuedSale);
446         
447         saleTime = false;
448         
449         uint nowTime = now;
450         endSaleTime = nowTime;
451         
452         for(uint i = 0; i < teamVestingTime; i++)
453         {
454             tmVestingTimer[i] = endSaleTime + teamVestingLockDate + ((i+1) * month);
455             tmVestingBalances[i] = teamVestingSupply;
456         }
457         
458         for(uint i = 0; i < advisorVestingTime; i++)
459         {
460             advVestingTimer[i] = endSaleTime + advisorVestingLockDate + (3 * (i+1) * month);
461             advVestingBalances[i] = advisorVestingSupply;
462         }
463         
464         emit EndSale(endSaleTime);
465     }
466     
467     function withdrawTokens(address _contract, uint _decimals, uint _value) onlyOwner public
468     {
469 
470         if(_contract == address(0x0))
471         {
472             uint eth = _value.mul(10 ** _decimals);
473             msg.sender.transfer(eth);
474         }
475         else
476         {
477             uint tokens = _value.mul(10 ** _decimals);
478             ERC20Interface(_contract).transfer(msg.sender, tokens);
479             
480             emit Transfer(address(0x0), msg.sender, tokens);
481         }
482     }
483     
484     function burnToken(uint _value) onlyOwner public
485     {
486         uint tokens = _value * E18;
487         
488         require(balances[msg.sender] >= tokens);
489         
490         balances[msg.sender] = balances[msg.sender].sub(tokens);
491         
492         burnTokenSupply = burnTokenSupply.add(tokens);
493         totalTokenSupply = totalTokenSupply.sub(tokens);
494         
495         emit Burn(msg.sender, tokens);
496     }
497     
498     function close() onlyOwner public
499     {
500         selfdestruct(msg.sender);
501     }
502     
503 }