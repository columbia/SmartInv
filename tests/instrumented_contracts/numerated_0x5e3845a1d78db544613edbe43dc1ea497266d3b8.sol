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
78 contract LNXProtocolToken is ERC20Interface, OwnerHelper
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
94     
95     // R&D                                           247,375,000 (10%)
96     uint constant public maxRnDSupply =              247375000 * E18;
97         
98     // EcoSystem                                     371,062,500 (15%)
99     uint constant public maxEcoSupply =              371062500 * E18;
100         
101     // Marketing                                     197,900,000 (8%)
102     uint constant public maxMktSupply =              197900000 * E18;
103         
104     // Reserve                                       296,850,000 (12%)
105     uint constant public maxReserveSupply =          296850000 * E18;
106         
107     // Advisor                                       123,687,500 (5%)
108     uint constant public maxAdvisorSupply =          123687500 * E18;
109     
110     // Sale Supply                                   989,500,000 (40%)
111     uint constant public maxSaleSupply =             989500000 * E18;
112     
113     uint constant public publicSaleSupply =          100000000 * E18;
114     uint constant public privateSaleSupply =         889500000 * E18;
115     
116     // Lock
117     uint constant public rndVestingSupply           = 9895000 * E18;
118     uint constant public rndVestingTime = 25;
119     
120     uint constant public teamVestingSupply          = 247375000 * E18;
121     uint constant public teamVestingLockDate        = 24 * month;
122 
123     uint constant public advisorVestingSupply          = 30921875 * E18;
124     uint constant public advisorVestingLockDate        = 3 * month;
125     uint constant public advisorVestingTime = 4;
126     
127     uint public totalTokenSupply;
128     uint public tokenIssuedTeam;
129     uint public tokenIssuedRnD;
130     uint public tokenIssuedEco;
131     uint public tokenIssuedMkt;
132     uint public tokenIssuedRsv;
133     uint public tokenIssuedAdv;
134     uint public tokenIssuedSale;
135     
136     uint public burnTokenSupply;
137     
138     mapping (address => uint) public balances;
139     mapping (address => mapping ( address => uint )) public approvals;
140     
141     uint public teamVestingTime;
142     
143     mapping (uint => uint) public rndVestingTimer;
144     mapping (uint => uint) public rndVestingBalances;
145     
146     mapping (uint => uint) public advVestingTimer;
147     mapping (uint => uint) public advVestingBalances;
148     
149     bool public tokenLock = true;
150     bool public saleTime = true;
151     uint public endSaleTime = 0;
152     
153     event TeamIssue(address indexed _to, uint _tokens);
154     event RnDIssue(address indexed _to, uint _tokens);
155     event EcoIssue(address indexed _to, uint _tokens);
156     event MktIssue(address indexed _to, uint _tokens);
157     event RsvIssue(address indexed _to, uint _tokens);
158     event AdvIssue(address indexed _to, uint _tokens);
159     event SaleIssue(address indexed _to, uint _tokens);
160     
161     event Burn(address indexed _from, uint _tokens);
162     
163     event TokenUnlock(address indexed _to, uint _tokens);
164     event EndSale(uint _date);
165     
166     constructor() public
167     {
168         name        = "LNX Protocol";
169         decimals    = 18;
170         symbol      = "LNX";
171         
172         totalTokenSupply    = 0;
173         
174         tokenIssuedTeam   = 0;
175         tokenIssuedRnD      = 0;
176         tokenIssuedEco     = 0;
177         tokenIssuedMkt      = 0;
178         tokenIssuedRsv    = 0;
179         tokenIssuedAdv    = 0;
180         tokenIssuedSale     = 0;
181 
182         burnTokenSupply     = 0;
183         
184         require(maxTeamSupply == teamVestingSupply);
185         require(maxRnDSupply == rndVestingSupply.mul(rndVestingTime));
186         require(maxAdvisorSupply == advisorVestingSupply.mul(advisorVestingTime));
187 
188         require(maxSaleSupply == publicSaleSupply + privateSaleSupply);
189         require(maxTotalSupply == maxTeamSupply + maxRnDSupply + maxEcoSupply + maxMktSupply + maxReserveSupply + maxAdvisorSupply + maxSaleSupply);
190     }
191     
192     // ERC - 20 Interface -----
193 
194     function totalSupply() view public returns (uint) 
195     {
196         return totalTokenSupply;
197     }
198     
199     function balanceOf(address _who) view public returns (uint) 
200     {
201         return balances[_who];
202     }
203     
204     function transfer(address _to, uint _value) public returns (bool) 
205     {
206         require(isTransferable() == true);
207         require(balances[msg.sender] >= _value);
208         
209         balances[msg.sender] = balances[msg.sender].sub(_value);
210         balances[_to] = balances[_to].add(_value);
211         
212         emit Transfer(msg.sender, _to, _value);
213         
214         return true;
215     }
216     
217     function approve(address _spender, uint _value) public returns (bool)
218     {
219         require(isTransferable() == true);
220         require(balances[msg.sender] >= _value);
221         
222         approvals[msg.sender][_spender] = _value;
223         
224         emit Approval(msg.sender, _spender, _value);
225         
226         return true; 
227     }
228     
229     function allowance(address _owner, address _spender) view public returns (uint) 
230     {
231         return approvals[_owner][_spender];
232     }
233 
234     function transferFrom(address _from, address _to, uint _value) public returns (bool) 
235     {
236         require(isTransferable() == true);
237         require(balances[_from] >= _value);
238         require(approvals[_from][msg.sender] >= _value);
239         
240         approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);
241         balances[_from] = balances[_from].sub(_value);
242         balances[_to]  = balances[_to].add(_value);
243         
244         emit Transfer(_from, _to, _value);
245         
246         return true;
247     }
248     
249     // -----
250     
251     // Vesting Function -----
252     
253     function teamIssue(address _to) onlyOwner public
254     {
255         require(saleTime == false);
256         
257         uint nowTime = now;
258         require(nowTime > teamVestingTime);
259         
260         uint tokens = teamVestingSupply;
261 
262         require(maxTeamSupply >= tokenIssuedTeam.add(tokens));
263         
264         balances[_to] = balances[_to].add(tokens);
265         
266         totalTokenSupply = totalTokenSupply.add(tokens);
267         tokenIssuedTeam = tokenIssuedTeam.add(tokens);
268         
269         emit TeamIssue(_to, tokens);
270     }
271     
272     // _time : 0 ~ 24
273     function rndIssue(address _to, uint _time) onlyOwner public
274     {
275         require(saleTime == false);
276         require(_time < rndVestingTime);
277         
278         uint nowTime = now;
279         require( nowTime > rndVestingTimer[_time] );
280         
281         uint tokens = rndVestingSupply;
282 
283         require(tokens == rndVestingBalances[_time]);
284         require(maxRnDSupply >= tokenIssuedRnD.add(tokens));
285         
286         balances[_to] = balances[_to].add(tokens);
287         rndVestingBalances[_time] = 0;
288         
289         totalTokenSupply = totalTokenSupply.add(tokens);
290         tokenIssuedRnD = tokenIssuedRnD.add(tokens);
291         
292         emit RnDIssue(_to, tokens);
293     }
294     
295     // _time : 0 ~ 3
296     function advisorIssue(address _to, uint _time) onlyOwner public
297     {
298         require(saleTime == false);
299         require( _time < advisorVestingTime);
300         
301         uint nowTime = now;
302         require( nowTime > advVestingTimer[_time] );
303         
304         uint tokens = advisorVestingSupply;
305 
306         require(tokens == advVestingBalances[_time]);
307         require(maxAdvisorSupply >= tokenIssuedAdv.add(tokens));
308         
309         balances[_to] = balances[_to].add(tokens);
310         advVestingBalances[_time] = 0;
311         
312         totalTokenSupply = totalTokenSupply.add(tokens);
313         tokenIssuedAdv = tokenIssuedAdv.add(tokens);
314         
315         emit AdvIssue(_to, tokens);
316     }
317     
318     function ecoIssue(address _to) onlyOwner public
319     {
320         require(saleTime == false);
321         require(tokenIssuedEco == 0);
322         
323         uint tokens = maxEcoSupply;
324         
325         balances[_to] = balances[_to].add(tokens);
326         
327         totalTokenSupply = totalTokenSupply.add(tokens);
328         tokenIssuedEco = tokenIssuedEco.add(tokens);
329         
330         emit EcoIssue(_to, tokens);
331     }
332     
333     function mktIssue(address _to) onlyOwner public
334     {
335         require(saleTime == false);
336         require(tokenIssuedMkt == 0);
337         
338         uint tokens = maxMktSupply;
339         
340         balances[_to] = balances[_to].add(tokens);
341         
342         totalTokenSupply = totalTokenSupply.add(tokens);
343         tokenIssuedMkt = tokenIssuedMkt.add(tokens);
344         
345         emit EcoIssue(_to, tokens);
346     }
347     
348     function rsvIssue(address _to) onlyOwner public
349     {
350         require(saleTime == false);
351         require(tokenIssuedRsv == 0);
352         
353         uint tokens = maxReserveSupply;
354         
355         balances[_to] = balances[_to].add(tokens);
356         
357         totalTokenSupply = totalTokenSupply.add(tokens);
358         tokenIssuedRsv = tokenIssuedRsv.add(tokens);
359         
360         emit EcoIssue(_to, tokens);
361     }
362     
363     function privateSaleIssue(address _to) onlyOwner public
364     {
365         require(tokenIssuedSale == 0);
366         
367         uint tokens = privateSaleSupply;
368         
369         balances[_to] = balances[_to].add(tokens);
370         
371         totalTokenSupply = totalTokenSupply.add(tokens);
372         tokenIssuedSale = tokenIssuedSale.add(tokens);
373         
374         emit SaleIssue(_to, tokens);
375     }
376     
377     function publicSaleIssue(address _to) onlyOwner public
378     {
379         require(tokenIssuedSale == privateSaleSupply);
380         
381         uint tokens = publicSaleSupply;
382         
383         balances[_to] = balances[_to].add(tokens);
384         
385         totalTokenSupply = totalTokenSupply.add(tokens);
386         tokenIssuedSale = tokenIssuedSale.add(tokens);
387         
388         emit SaleIssue(_to, tokens);
389     }
390     
391     // -----
392     
393     // Lock Function -----
394     
395     function isTransferable() private view returns (bool)
396     {
397         if(tokenLock == false)
398         {
399             return true;
400         }
401         else if(msg.sender == owner)
402         {
403             return true;
404         }
405         
406         return false;
407     }
408     
409     function setTokenUnlock() onlyOwner public
410     {
411         require(tokenLock == true);
412         require(saleTime == false);
413         
414         tokenLock = false;
415     }
416     
417     function setTokenLock() onlyOwner public
418     {
419         require(tokenLock == false);
420         
421         tokenLock = true;
422     }
423     
424     // -----
425     
426     // ETC / Burn Function -----
427     
428     function endSale() onlyOwner public
429     {
430         require(saleTime == true);
431         require(maxSaleSupply == tokenIssuedSale);
432         
433         saleTime = false;
434         
435         uint nowTime = now;
436         endSaleTime = nowTime;
437         
438         teamVestingTime = endSaleTime + teamVestingLockDate;
439         
440         for(uint i = 0; i < rndVestingTime; i++)
441         {
442             rndVestingTimer[i] =  endSaleTime + (month * i);
443             rndVestingBalances[i] = rndVestingSupply;
444         }
445         
446         for(uint i = 0; i < advisorVestingTime; i++)
447         {
448             advVestingTimer[i] = endSaleTime + (advisorVestingLockDate * i);
449             advVestingBalances[i] = advisorVestingSupply;
450         }
451         
452         emit EndSale(endSaleTime);
453     }
454     
455     function withdrawTokens(address _contract, uint _decimals, uint _value) onlyOwner public
456     {
457 
458         if(_contract == address(0x0))
459         {
460             uint eth = _value.mul(10 ** _decimals);
461             msg.sender.transfer(eth);
462         }
463         else
464         {
465             uint tokens = _value.mul(10 ** _decimals);
466             ERC20Interface(_contract).transfer(msg.sender, tokens);
467             
468             emit Transfer(address(0x0), msg.sender, tokens);
469         }
470     }
471     
472     function burnToken(uint _value) onlyOwner public
473     {
474         uint tokens = _value * E18;
475         
476         require(balances[msg.sender] >= tokens);
477         
478         balances[msg.sender] = balances[msg.sender].sub(tokens);
479         
480         burnTokenSupply = burnTokenSupply.add(tokens);
481         totalTokenSupply = totalTokenSupply.sub(tokens);
482         
483         emit Burn(msg.sender, tokens);
484     }
485     
486     function close() onlyOwner public
487     {
488         selfdestruct(msg.sender);
489     }
490     
491     // -----
492 }