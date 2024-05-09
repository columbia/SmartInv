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
78 contract MEDIBEUToken is ERC20Interface, OwnerHelper
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
89     // Total Supply                                 1,300,000,000 (100%)
90     uint constant public maxTotalSupply =           1300000000 * E18;
91     
92     // Token Sale Supply                                  340,000,000 (26.15%)
93     uint constant public maxSaleSupply =             340000000 * E18;
94     
95     uint constant public PublicSaleSupply =          10000000 * E18;
96     uint constant public PrivateSaleSupply =         330000000 * E18;
97 
98     // Marketing & Business Development    245,000,000 (18.85%)
99     uint constant public maxMKTBDSupply =          245000000 * E18;
100 
101     // Partnership                                   130,000,000 (10%)
102     uint constant public maxPartnerSupply =          130000000 * E18;
103 
104     // Tech Development                          195,000,000 (15%)
105     uint constant public maxTechSupply =          195000000 * E18;
106 
107     // Team & Foundation                         195,000,000 (15%)
108     uint constant public maxTeamSupply =          195000000 * E18;
109 
110     // Reserve                                        130,000,000 (10%)
111     uint constant public maxRsvSupply =          130000000 * E18;
112 
113     // Advisor                                         65,000,000 (5%)
114     uint constant public maxAdvSupply =          65000000 * E18;
115        
116     
117     // Vesting & Lock up
118     uint constant public TechVestingSupply           = 16250000 * E18;
119     uint constant public TechVestingTime = 12;
120     
121     uint constant public TeamVestingSupply          = 195000000 * E18;
122     uint constant public TeamVestingLockDate       = 24 * month;
123 
124     uint constant public RsvVestingSupply       = 130000000 * E18;
125     uint constant public RsvVestingLockDate    = 12 * month;
126     
127     uint constant public AdvVestingSupply       = 65000000 * E18;
128     uint constant public AdvVestingLockDate    = 6 * month;
129     
130     uint public totalTokenSupply;
131     uint public tokenIssuedSale;
132     uint public tokenIssuedMKTBD;
133     uint public tokenIssuedPartner;
134     uint public tokenIssuedTech;
135     uint public tokenIssuedTeam;
136     uint public tokenIssuedRsv;
137     uint public tokenIssuedAdv;
138     
139     uint public burnTokenSupply;
140     
141     mapping (address => uint) public balances;
142     mapping (address => mapping ( address => uint )) public approvals;
143     
144     uint public TeamVestingTime;
145     uint public RsvVestingTime;
146     uint public AdvVestingTime;
147     
148     mapping (uint => uint) public TechVestingTimer;
149     mapping (uint => uint) public TechVestingBalances;
150     
151     bool public tokenLock = true;
152     bool public saleTime = true;
153     uint public endSaleTime = 0;
154     
155     event SaleIssue(address indexed _to, uint _tokens);
156     event MKTBDIssue(address indexed _to, uint _tokens);
157     event PartnerIssue(address indexed _to, uint _tokens);
158     event TechIssue(address indexed _to, uint _tokens);
159     event TeamIssue(address indexed _to, uint _tokens);
160     event RsvIssue(address indexed _to, uint _tokens);
161     event AdvIssue(address indexed _to, uint _tokens);
162     
163     event Burn(address indexed _from, uint _tokens);
164     
165     event TokenUnlock(address indexed _to, uint _tokens);
166     event EndSale(uint _date);
167     
168     constructor() public
169     {
170         name        = "Medibeu";
171         decimals    = 18;
172         symbol      = "MDB";
173         
174         totalTokenSupply    = 0;
175         
176         tokenIssuedSale   = 0;
177         tokenIssuedMKTBD   = 0;
178         tokenIssuedPartner   = 0;
179         tokenIssuedTech   = 0;
180         tokenIssuedTeam    = 0;
181         tokenIssuedRsv    = 0;
182         tokenIssuedAdv     = 0;
183 
184         burnTokenSupply     = 0;
185         
186         require(maxTechSupply == TechVestingSupply.mul(TechVestingTime));
187         require(maxTeamSupply == TeamVestingSupply);
188         require(maxRsvSupply == RsvVestingSupply);
189         require(maxAdvSupply == AdvVestingSupply);
190 
191         require(maxSaleSupply == PublicSaleSupply + PrivateSaleSupply);
192         require(maxTotalSupply == maxSaleSupply + maxMKTBDSupply + maxPartnerSupply + maxTechSupply + maxTeamSupply + maxRsvSupply + maxAdvSupply);
193     }
194     
195     // ERC 20 Interface 
196 
197     function totalSupply() view public returns (uint) 
198     {
199         return totalTokenSupply;
200     }
201     
202     function balanceOf(address _who) view public returns (uint) 
203     {
204         return balances[_who];
205     }
206     
207     function transfer(address _to, uint _value) public returns (bool) 
208     {
209         require(isTransferable() == true);
210         require(balances[msg.sender] >= _value);
211         
212         balances[msg.sender] = balances[msg.sender].sub(_value);
213         balances[_to] = balances[_to].add(_value);
214         
215         emit Transfer(msg.sender, _to, _value);
216         
217         return true;
218     }
219     
220     function approve(address _spender, uint _value) public returns (bool)
221     {
222         require(isTransferable() == true);
223         require(balances[msg.sender] >= _value);
224         
225         approvals[msg.sender][_spender] = _value;
226         
227         emit Approval(msg.sender, _spender, _value);
228         
229         return true; 
230     }
231     
232     function allowance(address _owner, address _spender) view public returns (uint) 
233     {
234         return approvals[_owner][_spender];
235     }
236 
237     function transferFrom(address _from, address _to, uint _value) public returns (bool) 
238     {
239         require(isTransferable() == true);
240         require(balances[_from] >= _value);
241         require(approvals[_from][msg.sender] >= _value);
242         
243         approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);
244         balances[_from] = balances[_from].sub(_value);
245         balances[_to]  = balances[_to].add(_value);
246         
247         emit Transfer(_from, _to, _value);
248         
249         return true;
250     }
251     
252        
253     // Vesting & Lock Function 
254     
255     function teamIssue(address _to) onlyOwner public
256     {
257         require(saleTime == false);
258         
259         uint nowTime = now;
260         require(nowTime > TeamVestingTime);
261         
262         uint tokens = TeamVestingSupply;
263 
264         require(maxTeamSupply >= tokenIssuedTeam.add(tokens));
265         
266         balances[_to] = balances[_to].add(tokens);
267         
268         totalTokenSupply = totalTokenSupply.add(tokens);
269         tokenIssuedTeam = tokenIssuedTeam.add(tokens);
270         
271         emit TeamIssue(_to, tokens);
272     }
273 
274     function rsvIssue(address _to) onlyOwner public
275     {
276         require(saleTime == false);
277         
278         uint nowTime = now;
279         require(nowTime > RsvVestingTime);
280         
281         uint tokens = RsvVestingSupply;
282 
283         require(maxRsvSupply >= tokenIssuedRsv.add(tokens));
284         
285         balances[_to] = balances[_to].add(tokens);
286         
287         totalTokenSupply = totalTokenSupply.add(tokens);
288         tokenIssuedRsv = tokenIssuedRsv.add(tokens);
289         
290         emit RsvIssue(_to, tokens);
291     }
292 
293     function advIssue(address _to) onlyOwner public
294     {
295         require(saleTime == false);
296         
297         uint nowTime = now;
298         require(nowTime > AdvVestingTime);
299         
300         uint tokens = AdvVestingSupply;
301 
302         require(maxAdvSupply >= tokenIssuedAdv.add(tokens));
303         
304         balances[_to] = balances[_to].add(tokens);
305         
306         totalTokenSupply = totalTokenSupply.add(tokens);
307         tokenIssuedAdv = tokenIssuedAdv.add(tokens);
308         
309         emit AdvIssue(_to, tokens);
310     }
311     
312     // _time : 0 ~ 11
313     function techIssue(address _to, uint _time) onlyOwner public
314     {
315         require(saleTime == false);
316         require(_time < TechVestingTime);
317         
318         uint nowTime = now;
319         require( nowTime > TechVestingTimer[_time] );
320         
321         uint tokens = TechVestingSupply;
322 
323         require(tokens == TechVestingBalances[_time]);
324         require(maxTechSupply >= tokenIssuedTech.add(tokens));
325         
326         balances[_to] = balances[_to].add(tokens);
327         TechVestingBalances[_time] = 0;
328         
329         totalTokenSupply = totalTokenSupply.add(tokens);
330         tokenIssuedTech = tokenIssuedTech.add(tokens);
331         
332         emit TechIssue(_to, tokens);
333     }
334         
335     // No lock 
336 
337     function mktbdIssue(address _to) onlyOwner public
338     {
339         require(saleTime == false);
340         require(tokenIssuedMKTBD == 0);
341         
342         uint tokens = maxMKTBDSupply;
343         
344         balances[_to] = balances[_to].add(tokens);
345         
346         totalTokenSupply = totalTokenSupply.add(tokens);
347         tokenIssuedMKTBD = tokenIssuedMKTBD.add(tokens);
348         
349         emit MKTBDIssue(_to, tokens);
350     }
351     
352     function partnerIssue(address _to) onlyOwner public
353     {
354         require(saleTime == false);
355         require(tokenIssuedPartner == 0);
356         
357         uint tokens = maxPartnerSupply;
358         
359         balances[_to] = balances[_to].add(tokens);
360         
361         totalTokenSupply = totalTokenSupply.add(tokens);
362         tokenIssuedPartner = tokenIssuedPartner.add(tokens);
363         
364         emit PartnerIssue(_to, tokens);
365     }
366        
367     function PrivateSaleIssue(address _to) onlyOwner public
368     {
369         require(tokenIssuedSale == 0);
370         
371         uint tokens = PrivateSaleSupply;
372         
373         balances[_to] = balances[_to].add(tokens);
374         
375         totalTokenSupply = totalTokenSupply.add(tokens);
376         tokenIssuedSale = tokenIssuedSale.add(tokens);
377         
378         emit SaleIssue(_to, tokens);
379     }
380     
381     function PublicSaleIssue(address _to) onlyOwner public
382     {
383         require(tokenIssuedSale == PrivateSaleSupply);
384         
385         uint tokens = PublicSaleSupply;
386         
387         balances[_to] = balances[_to].add(tokens);
388         
389         totalTokenSupply = totalTokenSupply.add(tokens);
390         tokenIssuedSale = tokenIssuedSale.add(tokens);
391         
392         emit SaleIssue(_to, tokens);
393     }
394         
395     // Lock Function 
396     
397     function isTransferable() private view returns (bool)
398     {
399         if(tokenLock == false)
400         {
401             return true;
402         }
403         else if(msg.sender == owner)
404         {
405             return true;
406         }
407         
408         return false;
409     }
410     
411     function setTokenUnlock() onlyOwner public
412     {
413         require(tokenLock == true);
414         require(saleTime == false);
415         
416         tokenLock = false;
417     }
418     
419     function setTokenLock() onlyOwner public
420     {
421         require(tokenLock == false);
422         
423         tokenLock = true;
424     }
425     
426     // ETC / Burn Function
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
438         TeamVestingTime = endSaleTime + TeamVestingLockDate;
439         RsvVestingTime = endSaleTime + RsvVestingLockDate;
440         AdvVestingTime = endSaleTime + AdvVestingLockDate;        
441 
442         for(uint i = 0; i < TechVestingTime; i++)
443         {
444             TechVestingTimer[i] =  endSaleTime + (month * i);
445             TechVestingBalances[i] = TechVestingSupply;
446         }
447                 
448         emit EndSale(endSaleTime);
449     }
450     
451     function withdrawTokens(address _contract, uint _decimals, uint _value) onlyOwner public
452     {
453 
454         if(_contract == address(0x0))
455         {
456             uint eth = _value.mul(10 ** _decimals);
457             msg.sender.transfer(eth);
458         }
459         else
460         {
461             uint tokens = _value.mul(10 ** _decimals);
462             ERC20Interface(_contract).transfer(msg.sender, tokens);
463             
464             emit Transfer(address(0x0), msg.sender, tokens);
465         }
466     }
467     
468     function burnToken(uint _value) onlyOwner public
469     {
470         uint tokens = _value * E18;
471         
472         require(balances[msg.sender] >= tokens);
473         
474         balances[msg.sender] = balances[msg.sender].sub(tokens);
475         
476         burnTokenSupply = burnTokenSupply.add(tokens);
477         totalTokenSupply = totalTokenSupply.sub(tokens);
478         
479         emit Burn(msg.sender, tokens);
480     }
481     
482     function close() onlyOwner public
483     {
484         selfdestruct(msg.sender);
485     }
486     
487     // -----
488 }