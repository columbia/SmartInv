1 pragma solidity ^0.5.9;
2 
3 library SafeMath
4 {
5 
6   function mul(uint256 a, uint256 b) internal pure returns (uint256)
7     	{
8 		uint256 c = a * b;
9 		assert(a == 0 || c / a == b);
10 
11 		return c;
12   	}
13 
14   	function div(uint256 a, uint256 b) internal pure returns (uint256)
15 	{
16 		uint256 c = a / b;
17 
18 		return c;
19   	}
20 
21   	function sub(uint256 a, uint256 b) internal pure returns (uint256)
22 	{
23 		assert(b <= a);
24 
25 		return a - b;
26   	}
27 
28   	function add(uint256 a, uint256 b) internal pure returns (uint256)
29 	{
30 		uint256 c = a + b;
31 		assert(c >= a);
32 
33 		return c;
34   	}
35 }
36 
37 contract OwnerHelper
38 {
39   	address public owner;
40     address public manager;
41 
42   	event ChangeOwner(address indexed _from, address indexed _to);
43     event ChangeManager(address indexed _from, address indexed _to);
44 
45   	modifier onlyOwner
46 	{
47 		require(msg.sender == owner);
48 		_;
49   	}
50   	
51     modifier onlyManager
52     {
53         require(msg.sender == manager);
54         _;
55     }
56 
57   	constructor() public
58 	{
59 		owner = msg.sender;
60   	}
61   	
62   	function transferOwnership(address _to) onlyOwner public
63   	{
64     	require(_to != owner);
65         require(_to != manager);
66     	require(_to != address(0x0));
67 
68         address from = owner;
69       	owner = _to;
70   	    
71       	emit ChangeOwner(from, _to);
72   	}
73 
74     function transferManager(address _to) onlyOwner public
75     {
76         require(_to != owner);
77         require(_to != manager);
78         require(_to != address(0x0));
79         
80         address from = manager;
81         manager = _to;
82         
83         emit ChangeManager(from, _to);
84     }
85 }
86 
87 contract ERC20Interface
88 {
89     event Transfer( address indexed _from, address indexed _to, uint _value);
90     event Approval( address indexed _owner, address indexed _spender, uint _value);
91     
92     function totalSupply() view public returns (uint _supply);
93     function balanceOf( address _who ) public view returns (uint _value);
94     function transfer( address _to, uint _value) public returns (bool _success);
95     function approve( address _spender, uint _value ) public returns (bool _success);
96     function allowance( address _owner, address _spender ) public view returns (uint _allowance);
97     function transferFrom( address _from, address _to, uint _value) public returns (bool _success);
98 }
99 
100 contract MOTIVProtocol is ERC20Interface, OwnerHelper
101 {
102     using SafeMath for uint;
103     
104     string public name;
105     uint public decimals;
106     string public symbol;
107     
108     uint constant private E18 = 1000000000000000000;
109     
110     // Total                                  500,000,000
111     uint constant public maxTotalSupply     = 500000000 * E18;
112 
113     // Sale Supply                            100,000,000 (20%)
114     uint constant public maxSaleSupply      = 100000000 * E18;
115 
116     // Marketing                              90,000,000 (18%)
117     uint constant public maxMktSupply       = 90000000 * E18;
118 
119     // EcoSystem                              90,000,000 (18%)
120     uint constant public maxEcoSupply       = 90000000 * E18;
121 
122     // Business Development                   70,000,000 (14%)
123     uint constant public maxDevSupply       = 70000000 * E18;
124 
125     // Reserve                                50,000,000 (10%)
126     uint constant public maxReserveSupply   = 50000000 * E18;
127 
128     // Team & Founders                        50,000,000 (10%)
129     uint constant public maxTeamSupply      = 50000000 * E18;
130 
131     // Advisors / Early Supporters            25,000,000 (5%)
132     uint constant public maxAdvisorSupply   = 25000000 * E18;
133 
134     // Legal & Compliance                     25,000,000 (5%)
135     uint constant public maxLegalSupply     = 25000000 * E18;
136     
137     // privateSale                            95,000,000
138     uint constant public privateSaleSupply  = 95000000 * E18;
139     // publicSale                             5,000,000
140     uint constant public publicSaleSupply   = 5000000 * E18;
141         
142 
143     uint public totalTokenSupply;
144     uint public tokenIssuedSale;
145     uint public tokenIssuedMkt;
146     uint public tokenIssuedEco;
147     uint public tokenIssuedDev;
148     uint public tokenIssuedRsv;
149     uint public tokenIssuedTeam;
150     uint public tokenIssuedAdv;
151     uint public tokenIssuedLegal;
152         
153     uint public burnTokenSupply;
154     
155     mapping (address => uint) public balances;
156     mapping (address => mapping ( address => uint )) public approvals;
157       
158     bool public tokenLock = true;
159     bool public saleTime = true;
160     uint public endSaleTime = 0;
161 
162     event SaleIssue(address indexed _to, uint _tokens);
163     event MktIssue(address indexed _to, uint _tokens);
164     event EcoIssue(address indexed _to, uint _tokens);
165     event DevIssue(address indexed _to, uint _tokens);
166     event RsvIssue(address indexed _to, uint _tokens);
167     event TeamIssue(address indexed _to, uint _tokens);
168     event AdvIssue(address indexed _to, uint _tokens);
169     event Legalssue(address indexed _to, uint _tokens);
170 
171     event Burn(address indexed _from, uint _tokens);
172     event TokenUnlock(address indexed _to, uint _tokens);
173 
174     event EndSale(uint _date);
175     
176     constructor() public
177     {
178         name        = "MOTIV Protocol";
179         decimals    = 18;
180         symbol      = "MOV";
181         
182         totalTokenSupply = 500000000 * E18;
183         balances[owner] = totalTokenSupply;
184 
185         tokenIssuedSale     = 0;
186         tokenIssuedMkt      = 0;
187         tokenIssuedEco      = 0;
188         tokenIssuedDev      = 0;
189         tokenIssuedRsv      = 0;
190         tokenIssuedTeam     = 0;
191         tokenIssuedAdv      = 0;
192         tokenIssuedLegal    = 0;
193         
194 
195         burnTokenSupply     = 0;
196         
197         require(maxTotalSupply == maxSaleSupply + maxMktSupply + maxEcoSupply + maxDevSupply + maxReserveSupply + maxTeamSupply + maxAdvisorSupply + maxLegalSupply);
198         require(maxSaleSupply == privateSaleSupply + publicSaleSupply);
199     }
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
256     function mktIssue(address _to) onlyOwner public
257     {
258         require(saleTime == false);
259         require(tokenIssuedMkt == 0);
260         
261         uint tokens = maxMktSupply;
262         
263         balances[msg.sender] = balances[msg.sender].sub(tokens);
264 
265         balances[_to] = balances[_to].add(tokens);
266         
267         tokenIssuedMkt = tokenIssuedMkt.add(tokens);
268         
269         emit MktIssue(_to, tokens);
270     }
271 
272     function ecoIssue(address _to) onlyOwner public
273     {
274         require(saleTime == false);
275         require(tokenIssuedEco == 0);
276         
277         uint tokens = maxEcoSupply;
278         
279         balances[msg.sender] = balances[msg.sender].sub(tokens);
280 
281         balances[_to] = balances[_to].add(tokens);
282         
283         tokenIssuedEco = tokenIssuedEco.add(tokens);
284         
285         emit EcoIssue(_to, tokens);
286     }
287 
288     
289 
290     function devIssue(address _to) onlyOwner public
291     {
292         require(saleTime == false);
293         require(tokenIssuedDev == 0);
294         
295         uint tokens = maxDevSupply;
296         
297         balances[msg.sender] = balances[msg.sender].sub(tokens);
298 
299         balances[_to] = balances[_to].add(tokens);
300         
301         tokenIssuedDev = tokenIssuedDev.add(tokens);
302         
303         emit DevIssue(_to, tokens);
304     }
305 
306     function rsvIssue(address _to) onlyOwner public
307     {
308         require(saleTime == false);
309         require(tokenIssuedRsv == 0);
310         
311         uint tokens = maxReserveSupply;
312         
313         balances[msg.sender] = balances[msg.sender].sub(tokens);
314 
315         balances[_to] = balances[_to].add(tokens);
316         
317         tokenIssuedRsv = tokenIssuedRsv.add(tokens);
318         
319         emit RsvIssue(_to, tokens);
320     }
321 
322     function teamIssue(address _to) onlyOwner public
323     {
324         require(saleTime == false);
325         require(tokenIssuedTeam == 0);
326         
327         uint tokens = maxTeamSupply;
328         
329         balances[msg.sender] = balances[msg.sender].sub(tokens);
330 
331         balances[_to] = balances[_to].add(tokens);
332         
333         tokenIssuedTeam = tokenIssuedTeam.add(tokens);
334         
335         emit TeamIssue(_to, tokens);
336     }
337 
338     function advisorIssue(address _to) onlyOwner public
339     {
340         require(saleTime == false);
341         require(tokenIssuedAdv == 0);
342         
343         uint tokens = maxAdvisorSupply;
344         
345         balances[msg.sender] = balances[msg.sender].sub(tokens);
346 
347         balances[_to] = balances[_to].add(tokens);
348         
349         tokenIssuedAdv = tokenIssuedAdv.add(tokens);
350         
351         emit AdvIssue(_to, tokens);
352     }
353 
354     function legalIssue(address _to) onlyOwner public
355     {
356         require(saleTime == false);
357         require(tokenIssuedLegal == 0);
358         
359         uint tokens = maxLegalSupply;
360         
361         balances[msg.sender] = balances[msg.sender].sub(tokens);
362 
363         balances[_to] = balances[_to].add(tokens);
364         
365         tokenIssuedLegal = tokenIssuedLegal.add(tokens);
366         
367         emit Legalssue(_to, tokens);
368     }
369     
370     function privateSaleIssue(address _to) onlyOwner public
371     {
372         require(tokenIssuedSale == 0);
373         
374         uint tokens = privateSaleSupply;
375         
376         balances[msg.sender] = balances[msg.sender].sub(tokens);
377 
378         balances[_to] = balances[_to].add(tokens);
379         
380         tokenIssuedSale = tokenIssuedSale.add(tokens);
381         
382         emit SaleIssue(_to, tokens);
383     }
384     
385     function publicSaleIssue(address _to) onlyOwner public
386     {
387         require(tokenIssuedSale == privateSaleSupply);
388         
389         uint tokens = publicSaleSupply;
390         
391         balances[msg.sender] = balances[msg.sender].sub(tokens);
392 
393         balances[_to] = balances[_to].add(tokens);
394         
395         tokenIssuedSale = tokenIssuedSale.add(tokens);
396         
397         emit SaleIssue(_to, tokens);
398     }
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
414     function setTokenUnlock() onlyManager public
415     {
416         require(tokenLock == true);
417         require(saleTime == false);
418         
419         tokenLock = false;
420     }
421     
422     function setTokenLock() onlyManager public
423     {
424         require(tokenLock == false);
425         
426         tokenLock = true;
427     }
428     
429     function endSale() onlyManager public
430     {
431         require(saleTime == true);
432         require(maxSaleSupply == tokenIssuedSale);
433         
434         saleTime = false;
435         
436         uint nowTime = now;
437         endSaleTime = nowTime;
438                
439         emit EndSale(endSaleTime);
440     }
441     
442     function transferAnyERC20Token(address tokenAddress, uint tokens) onlyOwner public returns (bool success)
443     {
444         return ERC20Interface(tokenAddress).transfer(manager, tokens);
445     }
446     
447     function burnToken(uint _value) onlyManager public
448     {
449         uint tokens = _value * E18;
450         
451         require(balances[msg.sender] >= tokens);
452         
453         balances[msg.sender] = balances[msg.sender].sub(tokens);
454         
455         burnTokenSupply = burnTokenSupply.add(tokens);
456         totalTokenSupply = totalTokenSupply.sub(tokens);
457         
458         emit Burn(msg.sender, tokens);
459     }
460     
461     function close() onlyOwner public
462     {
463         selfdestruct(msg.sender);
464     }
465     
466 }