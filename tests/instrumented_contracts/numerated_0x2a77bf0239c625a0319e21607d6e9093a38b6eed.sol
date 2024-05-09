1 pragma solidity ^0.5.1;
2 
3 // Made By Tom - tom@devtooth.com
4 
5 library SafeMath
6 {
7   	function mul(uint256 a, uint256 b) internal pure returns (uint256)
8     {
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
40   	address public owner1;
41   	address public owner2;
42 
43   	event OwnerTransferPropose(address indexed _from, address indexed _to);
44 
45   	modifier onlyOwner
46 	{
47 		require(msg.sender == owner1 || msg.sender == owner2);
48 		_;
49   	}
50 
51   	constructor() public
52 	{
53 		owner1 = msg.sender;
54   	}
55 
56   	function transferOwner1(address _to) onlyOwner public
57 	{
58         require(_to != owner1);
59         require(_to != owner2);
60         require(_to != address(0x0));
61     	owner1 = _to;
62         
63     	emit OwnerTransferPropose(msg.sender, _to);
64   	}
65 
66   	function transferOwner2(address _to) onlyOwner public
67 	{
68         require(_to != owner1);
69         require(_to != owner2);
70         require(_to != address(0x0));
71     	owner2 = _to;
72         
73     	emit OwnerTransferPropose(msg.sender, _to);
74   	}
75 }
76 
77 contract ERC20Interface
78 {
79     event Transfer( address indexed _from, address indexed _to, uint _value);
80     event Approval( address indexed _owner, address indexed _spender, uint _value);
81     
82     function totalSupply() view public returns (uint _supply);
83     function balanceOf( address _who ) public view returns (uint _value);
84     function transfer( address _to, uint _value) public returns (bool _success);
85     function approve( address _spender, uint _value ) public returns (bool _success);
86     function allowance( address _owner, address _spender ) public view returns (uint _allowance);
87     function transferFrom( address _from, address _to, uint _value) public returns (bool _success);
88 }
89 
90 contract VantaToken is ERC20Interface, OwnerHelper
91 {
92     using SafeMath for uint;
93 
94     address private creator;
95     
96     string public name;
97     uint public decimals;
98     string public symbol;
99     
100     uint constant private E18 = 1000000000000000000;
101     uint private constant month = 2592000;
102     
103     uint constant public maxTotalSupply     = 56200000000 * E18;
104     uint constant public maxSaleSupply      = 19670000000 * E18;
105     uint constant public maxBdevSupply      =  8430000000 * E18;
106     uint constant public maxMktSupply       =  8430000000 * E18;
107     uint constant public maxRndSupply       =  8430000000 * E18;
108     uint constant public maxTeamSupply      =  5620000000 * E18;
109     uint constant public maxReserveSupply   =  2810000000 * E18;
110     uint constant public maxAdvisorSupply   =  2810000000 * E18;
111     
112     
113     uint public totalTokenSupply;
114     
115     uint public tokenIssuedSale;
116     uint public apIssuedSale;
117     uint public bpIssuedSale;
118     uint public pbIssuedSale;
119     uint public tokenIssuedBdev;
120     uint public tokenIssuedMkt;
121     uint public tokenIssuedRnd;
122     uint public tokenIssuedTeam;
123     uint public tokenIssuedReserve;
124     uint public tokenIssuedAdvisor;
125     
126     uint public burnTokenSupply;
127     
128     
129     mapping (address => uint) public balances;
130     mapping (address => mapping ( address => uint )) public approvals;
131     
132     
133     mapping (address => uint) public ap1;
134     uint public apLock_1 = 1514818800;
135     
136     mapping (address => uint) public ap2;
137     uint public apLock_2 = 1514818800;
138     
139     mapping (address => uint) public ap3;
140     uint public apLock_3 = 1514818800;
141 
142 
143     mapping (address => uint) public bp1;
144     uint public bpLock_1 = 1514818800;
145     
146     mapping (address => uint) public bp2;
147     uint public bpLock_2 = 1514818800;
148 
149     
150     bool public tokenLock = true;
151     bool public saleTime = true;
152     
153     event Burn(address indexed _from, uint _value);
154     
155     event SaleIssue(address indexed _to, uint _tokens);
156     event BdevIssue(address indexed _to, uint _tokens);
157     event MktIssue(address indexed _to, uint _tokens);
158     event RndIssue(address indexed _to, uint _tokens);
159     event TeamIssue(address indexed _to, uint _tokens);
160     event ReserveIssue(address indexed _to, uint _tokens);
161     event AdvisorIssue(address indexed _to, uint _tokens);
162     
163     event TokenUnLock(address indexed _to, uint _tokens);
164     
165     constructor() public
166     {
167         name        = "VANTA Token";
168         decimals    = 18;
169         symbol      = "VNT";
170         creator     = msg.sender;
171         
172         totalTokenSupply = 0;
173         
174         tokenIssuedSale     = 0;
175         tokenIssuedBdev     = 0;
176         tokenIssuedMkt      = 0;
177         tokenIssuedRnd      = 0;
178         tokenIssuedTeam     = 0;
179         tokenIssuedReserve  = 0;
180         tokenIssuedAdvisor  = 0;
181         
182         require(maxTotalSupply == maxSaleSupply + maxBdevSupply + maxMktSupply + maxRndSupply + maxTeamSupply + maxReserveSupply + maxAdvisorSupply);
183     }
184     
185     // ERC - 20 Interface -----
186 
187     function totalSupply() view public returns (uint) 
188     {
189         return totalTokenSupply;
190     }
191     
192     function balanceOf(address _who) view public returns (uint) 
193     {
194         uint balance = balances[_who];
195         balance = balance.add(ap1[_who] + ap2[_who] + ap3[_who]);
196         balance = balance.add(bp1[_who] + bp2[_who]);
197         
198         return balance;
199     }
200     
201     function transfer(address _to, uint _value) public returns (bool) 
202     {
203         require(isTransferable() == true);
204         require(balances[msg.sender] >= _value);
205         
206         balances[msg.sender] = balances[msg.sender].sub(_value);
207         balances[_to] = balances[_to].add(_value);
208         
209         emit Transfer(msg.sender, _to, _value);
210         
211         return true;
212     }
213     
214     function approve(address _spender, uint _value) public returns (bool)
215     {
216         require(isTransferable() == true);
217         require(balances[msg.sender] >= _value);
218         
219         approvals[msg.sender][_spender] = _value;
220         
221         emit Approval(msg.sender, _spender, _value);
222         
223         return true; 
224     }
225     
226     function allowance(address _owner, address _spender) view public returns (uint) 
227     {
228         return approvals[_owner][_spender];
229     }
230 
231     function transferFrom(address _from, address _to, uint _value) public returns (bool) 
232     {
233         require(isTransferable() == true);
234         require(balances[_from] >= _value);
235         require(approvals[_from][msg.sender] >= _value);
236         
237         approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);
238         balances[_from] = balances[_from].sub(_value);
239         balances[_to]  = balances[_to].add(_value);
240         
241         emit Transfer(_from, _to, _value);
242         
243         return true;
244     }
245     
246     // -----
247     
248     // Issue Function -----
249     
250     function apSaleIssue(address _to, uint _value) onlyOwner public
251     {
252         uint tokens = _value * E18;
253         require(maxSaleSupply >= tokenIssuedSale.add(tokens));
254         
255         balances[_to]   = balances[_to].add( tokens.mul(385)/1000 );
256         ap1[_to]        = ap1[_to].add( tokens.mul(385)/1000 );
257         ap2[_to]        = ap2[_to].add( tokens.mul(115)/1000 );
258         ap3[_to]        = ap3[_to].add( tokens.mul(115)/1000 );
259         
260         totalTokenSupply = totalTokenSupply.add(tokens);
261         tokenIssuedSale = tokenIssuedSale.add(tokens);
262         apIssuedSale = apIssuedSale.add(tokens);
263         
264         emit SaleIssue(_to, tokens);
265     }
266     
267     function bpSaleIssue(address _to, uint _value) onlyOwner public
268     {
269         uint tokens = _value * E18;
270         require(maxSaleSupply >= tokenIssuedSale.add(tokens));
271         
272         balances[_to]   = balances[_to].add( tokens.mul(435)/1000 );
273         bp1[_to]        = bp1[_to].add( tokens.mul(435)/1000 );
274         bp2[_to]        = bp2[_to].add( tokens.mul(130)/1000 );
275         
276         totalTokenSupply = totalTokenSupply.add(tokens);
277         tokenIssuedSale = tokenIssuedSale.add(tokens);
278         bpIssuedSale = bpIssuedSale.add(tokens);
279         
280         emit SaleIssue(_to, tokens);
281         
282     }
283     
284     function saleIssue(address _to, uint _value) onlyOwner public
285     {
286         uint tokens = _value * E18;
287         require(maxSaleSupply >= tokenIssuedSale.add(tokens));
288         
289         balances[_to] = balances[_to].add(tokens);
290         
291         totalTokenSupply = totalTokenSupply.add(tokens);
292         tokenIssuedSale = tokenIssuedSale.add(tokens);
293         pbIssuedSale = pbIssuedSale.add(tokens);
294         
295         emit SaleIssue(_to, tokens);
296     }
297     
298     function bdevIssue(address _to, uint _value) onlyOwner public
299     {
300         uint tokens = _value * E18;
301         require(maxBdevSupply >= tokenIssuedBdev.add(tokens));
302         
303         balances[_to] = balances[_to].add(tokens);
304         
305         totalTokenSupply = totalTokenSupply.add(tokens);
306         tokenIssuedBdev = tokenIssuedBdev.add(tokens);
307         
308         emit BdevIssue(_to, tokens);
309     }
310     
311     function mktIssue(address _to, uint _value) onlyOwner public
312     {
313         uint tokens = _value * E18;
314         require(maxMktSupply >= tokenIssuedMkt.add(tokens));
315         
316         balances[_to] = balances[_to].add(tokens);
317         
318         totalTokenSupply = totalTokenSupply.add(tokens);
319         tokenIssuedMkt = tokenIssuedMkt.add(tokens);
320         
321         emit MktIssue(_to, tokens);
322     }
323     
324     function rndIssue(address _to, uint _value) onlyOwner public
325     {
326         uint tokens = _value * E18;
327         require(maxRndSupply >= tokenIssuedRnd.add(tokens));
328         
329         balances[_to] = balances[_to].add(tokens);
330         
331         totalTokenSupply = totalTokenSupply.add(tokens);
332         tokenIssuedRnd = tokenIssuedRnd.add(tokens);
333         
334         emit RndIssue(_to, tokens);
335     }
336     
337     function reserveIssue(address _to, uint _value) onlyOwner public
338     {
339         uint tokens = _value * E18;
340         require(maxReserveSupply >= tokenIssuedReserve.add(tokens));
341         
342         balances[_to] = balances[_to].add(tokens);
343         
344         totalTokenSupply = totalTokenSupply.add(tokens);
345         tokenIssuedReserve = tokenIssuedReserve.add(tokens);
346         
347         emit ReserveIssue(_to, tokens);
348     }
349     
350     function teamIssue(address _to, uint _value) onlyOwner public
351     {
352         uint tokens = _value * E18;
353         require(maxTeamSupply >= tokenIssuedTeam.add(tokens));
354         
355         balances[_to] = balances[_to].add(tokens);
356         
357         totalTokenSupply = totalTokenSupply.add(tokens);
358         tokenIssuedTeam = tokenIssuedTeam.add(tokens);
359         
360         emit TeamIssue(_to, tokens);
361     }
362     
363     function advisorIssue(address _to, uint _value) onlyOwner public
364     {
365         uint tokens = _value * E18;
366         require(maxAdvisorSupply >= tokenIssuedAdvisor.add(tokens));
367         
368         balances[_to] = balances[_to].add(tokens);
369         
370         totalTokenSupply = totalTokenSupply.add(tokens);
371         tokenIssuedAdvisor = tokenIssuedAdvisor.add(tokens);
372         
373         emit AdvisorIssue(_to, tokens);
374     }
375     
376     // -----
377     
378     // Lock Function -----
379     
380     function isTransferable() private view returns (bool)
381     {
382         if(tokenLock == false)
383         {
384             return true;
385         }
386         else if(msg.sender == owner1 || msg.sender == owner2)
387         {
388             return true;
389         }
390         
391         return false;
392     }
393     
394     function setTokenLockUp() onlyOwner public
395     {
396         require(tokenLock == true);
397         
398         tokenLock = false;
399     }
400     
401     function setTokenLock() onlyOwner public
402     {
403         require(tokenLock == false);
404         
405         tokenLock = true;
406     }
407     
408     function apLockUp(address _to) onlyOwner public
409     {
410         require(tokenLock == false);
411         require(saleTime == false);
412         
413         uint time = now;
414         uint unlockTokens = 0;
415 
416         if( (time >= apLock_1) && (ap1[_to] > 0) )
417         {
418             balances[_to] = balances[_to].add(ap1[_to]);
419             unlockTokens = unlockTokens.add(ap1[_to]);
420             ap1[_to] = 0;
421         }
422         
423         if( (time >= apLock_2) && (ap2[_to] > 0) )
424         {
425             balances[_to] = balances[_to].add(ap2[_to]);
426             unlockTokens = unlockTokens.add(ap2[_to]);
427             ap2[_to] = 0;
428         }
429         
430         if( (time >= apLock_3) && (ap3[_to] > 0) )
431         {
432             balances[_to] = balances[_to].add(ap3[_to]);
433             unlockTokens = unlockTokens.add(ap3[_to]);
434             ap3[_to] = 0;
435         }
436         
437         emit TokenUnLock(_to, unlockTokens);
438     }
439     
440     function bpLockUp(address _to) onlyOwner public
441     {
442         require(tokenLock == false);
443         require(saleTime == false);
444         
445         uint time = now;
446         uint unlockTokens = 0;
447 
448         if( (time >= bpLock_1) && (bp1[_to] > 0) )
449         {
450             balances[_to] = balances[_to].add(bp1[_to]);
451             unlockTokens = unlockTokens.add(bp1[_to]);
452             bp1[_to] = 0;
453         }
454         
455         if( (time >= bpLock_2) && (bp2[_to] > 0) )
456         {
457             balances[_to] = balances[_to].add(bp2[_to]);
458             unlockTokens = unlockTokens.add(bp2[_to]);
459             bp2[_to] = 0;
460         }
461         
462         emit TokenUnLock(_to, unlockTokens);
463     }
464     
465     // -----
466     
467     // ETC / Burn Function -----
468     
469     function () payable external
470     {
471         revert();
472     }
473     
474     function endSale() onlyOwner public
475     {
476         require(saleTime == true);
477         
478         saleTime = false;
479     }
480     
481     function withdrawTokens(address _to, uint _value) onlyOwner public
482     {
483         uint tokens = _value * E18;
484         
485         balances[_to] = balances[_to].add(tokens);
486         totalTokenSupply = totalTokenSupply.add(tokens);
487         
488         emit Transfer(address(0x0), _to, tokens);
489     }
490     
491     function setApTime(uint _time) onlyOwner public
492     {
493         require(tokenLock == true);
494         require(saleTime == true);
495         apLock_1 = _time;
496         apLock_2 = _time.add(month);
497         apLock_3 = apLock_2.add(month);
498     }
499     
500     function setBpTime(uint _time) onlyOwner public
501     {
502         require(tokenLock == true);
503         require(saleTime == true);
504         bpLock_1 = _time;
505         bpLock_2 = _time.add(month);
506     }
507     
508     function burnToken(uint _value) onlyOwner public
509     {
510         uint tokens = _value * E18;
511         
512         require(balances[msg.sender] >= tokens);
513         
514         balances[msg.sender] = balances[msg.sender].sub(tokens);
515         
516         burnTokenSupply = burnTokenSupply.add(tokens);
517         totalTokenSupply = totalTokenSupply.sub(tokens);
518         
519         emit Burn(msg.sender, tokens);
520         emit Transfer( msg.sender, address(0x0), tokens);
521     }
522     
523     function close() public
524     {
525         require(msg.sender == creator);
526         selfdestruct(msg.sender);
527     }
528     
529     // -----
530 }