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
78 contract LINIXToken is ERC20Interface, OwnerHelper
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
89     // Total                                        2,473,750,000
90     uint constant public maxTotalSupply =           2473750000 * E18;
91     
92     // Team                                          247,375,000 (10%)
93     uint constant public maxTeamSupply =             247375000 * E18;
94     // - 3 months after Vesting 24 times
95     
96     // R&D                                           247,375,000 (10%)
97     uint constant public maxRnDSupply =              247375000 * E18;
98     // - 2 months after Vesting 18 times
99     
100     // EcoSystem                                     371,062,500 (15%)
101     uint constant public maxEcoSupply =              371062500 * E18;
102     // - 3 months after Vesting 12 times
103     
104     // Marketing                                     197,900,000 (8%)
105     uint constant public maxMktSupply =              197900000 * E18;
106     // - 1 months after Vesting 1 time
107     
108     // Reserve                                       296,850,000 (12%)
109     uint constant public maxReserveSupply =          296850000 * E18;
110     // - Vesting 7 times
111     
112     // Advisor                                       123,687,500 (5%)
113     uint constant public maxAdvisorSupply =          123687500 * E18;
114     
115     // Sale Supply                                   989,500,000 (40%)
116     uint constant public maxSaleSupply =             989500000 * E18;
117     
118     uint constant public publicSaleSupply =          100000000 * E18;
119     uint constant public privateSaleSupply =         889500000 * E18;
120     
121     // Lock
122     uint constant public rndVestingSupply           = 9895000 * E18;
123     uint constant public rndVestingTime = 25;
124     
125     uint constant public teamVestingSupply          = 247375000 * E18;
126     uint constant public teamVestingLockDate        = 24 * month;
127 
128     uint constant public advisorVestingSupply          = 30921875 * E18;
129     uint constant public advisorVestingLockDate        = 3 * month;
130     uint constant public advisorVestingTime = 4;
131     
132     uint public totalTokenSupply;
133     uint public tokenIssuedTeam;
134     uint public tokenIssuedRnD;
135     uint public tokenIssuedEco;
136     uint public tokenIssuedMkt;
137     uint public tokenIssuedRsv;
138     uint public tokenIssuedAdv;
139     uint public tokenIssuedSale;
140     
141     uint public burnTokenSupply;
142     
143     mapping (address => uint) public balances;
144     mapping (address => mapping ( address => uint )) public approvals;
145     
146     uint public teamVestingTime;
147     
148     mapping (uint => uint) public rndVestingTimer;
149     mapping (uint => uint) public rndVestingBalances;
150     
151     mapping (uint => uint) public advVestingTimer;
152     mapping (uint => uint) public advVestingBalances;
153     
154     bool public tokenLock = true;
155     bool public saleTime = true;
156     uint public endSaleTime = 0;
157     
158     event TeamIssue(address indexed _to, uint _tokens);
159     event RnDIssue(address indexed _to, uint _tokens);
160     event EcoIssue(address indexed _to, uint _tokens);
161     event MktIssue(address indexed _to, uint _tokens);
162     event RsvIssue(address indexed _to, uint _tokens);
163     event AdvIssue(address indexed _to, uint _tokens);
164     event SaleIssue(address indexed _to, uint _tokens);
165     
166     event Burn(address indexed _from, uint _tokens);
167     
168     event TokenUnlock(address indexed _to, uint _tokens);
169     event EndSale(uint _date);
170     
171     constructor() public
172     {
173         name        = "LNX Protocol";
174         decimals    = 18;
175         symbol      = "LNX";
176         
177         totalTokenSupply    = 0;
178         
179         tokenIssuedTeam   = 0;
180         tokenIssuedRnD      = 0;
181         tokenIssuedEco     = 0;
182         tokenIssuedMkt      = 0;
183         tokenIssuedRsv    = 0;
184         tokenIssuedAdv    = 0;
185         tokenIssuedSale     = 0;
186 
187         burnTokenSupply     = 0;
188         
189         require(maxTeamSupply == teamVestingSupply);
190         require(maxRnDSupply == rndVestingSupply.mul(rndVestingTime));
191         require(maxAdvisorSupply == advisorVestingSupply.mul(advisorVestingTime));
192 
193         require(maxSaleSupply == publicSaleSupply + privateSaleSupply);
194         require(maxTotalSupply == maxTeamSupply + maxRnDSupply + maxEcoSupply + maxMktSupply + maxReserveSupply + maxAdvisorSupply + maxSaleSupply);
195     }
196     
197     // ERC - 20 Interface -----
198 
199     function totalSupply() view public returns (uint) 
200     {
201         return totalTokenSupply;
202     }
203     
204     function balanceOf(address _who) view public returns (uint) 
205     {
206         return balances[_who];
207     }
208     
209     function transfer(address _to, uint _value) public returns (bool) 
210     {
211         require(isTransferable() == true);
212         require(balances[msg.sender] >= _value);
213         
214         balances[msg.sender] = balances[msg.sender].sub(_value);
215         balances[_to] = balances[_to].add(_value);
216         
217         emit Transfer(msg.sender, _to, _value);
218         
219         return true;
220     }
221     
222     function approve(address _spender, uint _value) public returns (bool)
223     {
224         require(isTransferable() == true);
225         require(balances[msg.sender] >= _value);
226         
227         approvals[msg.sender][_spender] = _value;
228         
229         emit Approval(msg.sender, _spender, _value);
230         
231         return true; 
232     }
233     
234     function allowance(address _owner, address _spender) view public returns (uint) 
235     {
236         return approvals[_owner][_spender];
237     }
238 
239     function transferFrom(address _from, address _to, uint _value) public returns (bool) 
240     {
241         require(isTransferable() == true);
242         require(balances[_from] >= _value);
243         require(approvals[_from][msg.sender] >= _value);
244         
245         approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);
246         balances[_from] = balances[_from].sub(_value);
247         balances[_to]  = balances[_to].add(_value);
248         
249         emit Transfer(_from, _to, _value);
250         
251         return true;
252     }
253     
254     // -----
255     
256     // Vesting Function -----
257     
258     function teamIssue(address _to) onlyOwner public
259     {
260         require(saleTime == false);
261         
262         uint nowTime = now;
263         require(nowTime > teamVestingTime);
264         
265         uint tokens = teamVestingSupply;
266 
267         require(maxTeamSupply >= tokenIssuedTeam.add(tokens));
268         
269         balances[_to] = balances[_to].add(tokens);
270         
271         totalTokenSupply = totalTokenSupply.add(tokens);
272         tokenIssuedTeam = tokenIssuedTeam.add(tokens);
273         
274         emit TeamIssue(_to, tokens);
275     }
276     
277     // _time : 0 ~ 24
278     function rndIssue(address _to, uint _time) onlyOwner public
279     {
280         require(saleTime == false);
281         require(_time < rndVestingTime);
282         
283         uint nowTime = now;
284         require( nowTime > rndVestingTimer[_time] );
285         
286         uint tokens = rndVestingSupply;
287 
288         require(tokens == rndVestingBalances[_time]);
289         require(maxRnDSupply >= tokenIssuedRnD.add(tokens));
290         
291         balances[_to] = balances[_to].add(tokens);
292         rndVestingBalances[_time] = 0;
293         
294         totalTokenSupply = totalTokenSupply.add(tokens);
295         tokenIssuedRnD = tokenIssuedRnD.add(tokens);
296         
297         emit RnDIssue(_to, tokens);
298     }
299     
300     // _time : 0 ~ 3
301     function advisorIssue(address _to, uint _time) onlyOwner public
302     {
303         require(saleTime == false);
304         require( _time < advisorVestingTime);
305         
306         uint nowTime = now;
307         require( nowTime > advVestingTimer[_time] );
308         
309         uint tokens = advisorVestingSupply;
310 
311         require(tokens == advVestingBalances[_time]);
312         require(maxAdvisorSupply >= tokenIssuedAdv.add(tokens));
313         
314         balances[_to] = balances[_to].add(tokens);
315         advVestingBalances[_time] = 0;
316         
317         totalTokenSupply = totalTokenSupply.add(tokens);
318         tokenIssuedAdv = tokenIssuedAdv.add(tokens);
319         
320         emit AdvIssue(_to, tokens);
321     }
322     
323     function ecoIssue(address _to) onlyOwner public
324     {
325         require(saleTime == false);
326         require(tokenIssuedEco == 0);
327         
328         uint tokens = maxEcoSupply;
329         
330         balances[_to] = balances[_to].add(tokens);
331         
332         totalTokenSupply = totalTokenSupply.add(tokens);
333         tokenIssuedEco = tokenIssuedEco.add(tokens);
334         
335         emit EcoIssue(_to, tokens);
336     }
337     
338     function mktIssue(address _to) onlyOwner public
339     {
340         require(saleTime == false);
341         require(tokenIssuedMkt == 0);
342         
343         uint tokens = maxMktSupply;
344         
345         balances[_to] = balances[_to].add(tokens);
346         
347         totalTokenSupply = totalTokenSupply.add(tokens);
348         tokenIssuedMkt = tokenIssuedMkt.add(tokens);
349         
350         emit EcoIssue(_to, tokens);
351     }
352     
353     function rsvIssue(address _to) onlyOwner public
354     {
355         require(saleTime == false);
356         require(tokenIssuedRsv == 0);
357         
358         uint tokens = maxReserveSupply;
359         
360         balances[_to] = balances[_to].add(tokens);
361         
362         totalTokenSupply = totalTokenSupply.add(tokens);
363         tokenIssuedRsv = tokenIssuedRsv.add(tokens);
364         
365         emit EcoIssue(_to, tokens);
366     }
367     
368     function privateSaleIssue(address _to) onlyOwner public
369     {
370         require(tokenIssuedSale == 0);
371         
372         uint tokens = privateSaleSupply;
373         
374         balances[_to] = balances[_to].add(tokens);
375         
376         totalTokenSupply = totalTokenSupply.add(tokens);
377         tokenIssuedSale = tokenIssuedSale.add(tokens);
378         
379         emit SaleIssue(_to, tokens);
380     }
381     
382     function publicSaleIssue(address _to) onlyOwner public
383     {
384         require(tokenIssuedSale == privateSaleSupply);
385         
386         uint tokens = publicSaleSupply;
387         
388         balances[_to] = balances[_to].add(tokens);
389         
390         totalTokenSupply = totalTokenSupply.add(tokens);
391         tokenIssuedSale = tokenIssuedSale.add(tokens);
392         
393         emit SaleIssue(_to, tokens);
394     }
395     
396     // -----
397     
398     // Lock Function -----
399     
400     function isTransferable() private view returns (bool)
401     {
402         if(tokenLock == false)
403         {
404             return true;
405         }
406         else if(msg.sender == owner)
407         {
408             return true;
409         }
410         
411         return false;
412     }
413     
414     function setTokenUnlock() onlyOwner public
415     {
416         require(tokenLock == true);
417         require(saleTime == false);
418         
419         tokenLock = false;
420     }
421     
422     function setTokenLock() onlyOwner public
423     {
424         require(tokenLock == false);
425         
426         tokenLock = true;
427     }
428     
429     // -----
430     
431     // ETC / Burn Function -----
432     
433     function endSale() onlyOwner public
434     {
435         require(saleTime == true);
436         require(maxSaleSupply == tokenIssuedSale);
437         
438         saleTime = false;
439         
440         uint nowTime = now;
441         endSaleTime = nowTime;
442         
443         teamVestingTime = endSaleTime + teamVestingLockDate;
444         
445         for(uint i = 0; i < rndVestingTime; i++)
446         {
447             rndVestingTimer[i] =  endSaleTime + (month * i);
448             rndVestingBalances[i] = rndVestingSupply;
449         }
450         
451         for(uint i = 0; i < advisorVestingTime; i++)
452         {
453             advVestingTimer[i] = endSaleTime + (advisorVestingLockDate * i);
454             advVestingBalances[i] = advisorVestingSupply;
455         }
456         
457         emit EndSale(endSaleTime);
458     }
459     
460     function withdrawTokens(address _contract, uint _decimals, uint _value) onlyOwner public
461     {
462 
463         if(_contract == address(0x0))
464         {
465             uint eth = _value.mul(10 ** _decimals);
466             msg.sender.transfer(eth);
467         }
468         else
469         {
470             uint tokens = _value.mul(10 ** _decimals);
471             ERC20Interface(_contract).transfer(msg.sender, tokens);
472             
473             emit Transfer(address(0x0), msg.sender, tokens);
474         }
475     }
476     
477     function burnToken(uint _value) onlyOwner public
478     {
479         uint tokens = _value * E18;
480         
481         require(balances[msg.sender] >= tokens);
482         
483         balances[msg.sender] = balances[msg.sender].sub(tokens);
484         
485         burnTokenSupply = burnTokenSupply.add(tokens);
486         totalTokenSupply = totalTokenSupply.sub(tokens);
487         
488         emit Burn(msg.sender, tokens);
489     }
490     
491     function close() onlyOwner public
492     {
493         selfdestruct(msg.sender);
494     }
495     
496     // -----
497 }