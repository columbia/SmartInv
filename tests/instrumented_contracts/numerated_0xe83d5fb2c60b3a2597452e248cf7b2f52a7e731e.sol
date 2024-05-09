1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 contract OwnerHelper
6 {
7     address public owner;
8     address public manager;
9 
10     event ChangeOwner(address indexed _from, address indexed _to);
11     event ChangeManager(address indexed _from, address indexed _to);
12 
13     modifier onlyOwner
14     {
15         require(msg.sender == owner, "ERROR: Not owner");
16         _;
17     }
18 
19     modifier onlyManagerAndOwner
20     {
21         require(msg.sender == manager || msg.sender == owner, "ERROR: Not manager and owner");
22         _;
23     }
24 
25     constructor()
26     {
27         owner = msg.sender;
28     }
29 
30     function transferOwnership(address _to) onlyOwner public
31     {
32         require(_to != owner);
33         require(_to != manager);
34         require(_to != address(0x0));
35 
36         address from = owner;
37         owner = _to;
38 
39         emit ChangeOwner(from, _to);
40     }
41 
42     function transferManager(address _to) onlyOwner public
43     {
44         require(_to != owner);
45         require(_to != manager);
46         require(_to != address(0x0));
47 
48         address from = manager;
49         manager = _to;
50 
51         emit ChangeManager(from, _to);
52     }
53 }
54 
55 abstract contract ERC20Interface
56 {
57     event Transfer( address indexed _from, address indexed _to, uint _value);
58     event Approval( address indexed _owner, address indexed _spender, uint _value);
59 
60     function totalSupply() view virtual public returns (uint _supply);
61     function balanceOf( address _who ) virtual public view returns (uint _value);
62     function transfer( address _to, uint _value) virtual public returns (bool _success);
63     function approve( address _spender, uint _value ) virtual public returns (bool _success);
64     function allowance( address _owner, address _spender ) virtual public view returns (uint _allowance);
65     function transferFrom( address _from, address _to, uint _value) virtual public returns (bool _success);
66 }
67 
68 contract ARTIC is ERC20Interface, OwnerHelper
69 {
70     string public name;
71     uint public decimals;
72     string public symbol;
73 
74     uint constant private E18 = 1000000000000000000;
75     uint constant private month = 2592000;
76 
77     // Total                                         100,000,000
78     uint constant public maxTotalSupply           = 100000000 * E18;
79     // Sale                                         10,000,000 (10%)
80     uint constant public maxSaleSupply            = 10000000 * E18;
81     // Marketing                                    25,000,000 (25%)
82     uint constant public maxMktSupply             = 25000000 * E18;
83     // Development                                  22,000,000 (22%)
84     uint constant public maxDevSupply             = 22000000 * E18;
85     // EcoSystem                                    20,000,000 (20%)
86     uint constant public maxEcoSupply             = 20000000 * E18;
87     // Legal & Compliance                           5,000,000 (5%)
88     uint constant public maxLegalComplianceSupply = 5000000 * E18;
89     // Team                                         5,000,000 (5%)
90     uint constant public maxTeamSupply            = 5000000 * E18;
91     // Advisors                                     3,000,000 (3%)
92     uint constant public maxAdvisorSupply         = 3000000 * E18;
93     // Reserve                                      10,000,000 (10%)
94     uint constant public maxReserveSupply         = 10000000 * E18;
95 
96     // Lock
97     uint constant public teamVestingSupply = 500000 * E18;
98     uint constant public teamVestingLockDate =  12 * month;
99     uint constant public teamVestingTime = 10;
100 
101     uint constant public advisorVestingSupply = 750000 * E18;
102     uint constant public advisorVestingTime = 4;
103 
104     uint public totalTokenSupply;
105     uint public tokenIssuedSale;
106     uint public tokenIssuedMkt;
107     uint public tokenIssuedDev;
108     uint public tokenIssuedEco;
109     uint public tokenIssuedLegalCompliance;
110     uint public tokenIssuedTeam;
111     uint public tokenIssuedAdv;
112     uint public tokenIssuedRsv;
113 
114     uint public burnTokenSupply;
115 
116     mapping (address => uint) public balances;
117     mapping (address => mapping ( address => uint )) public approvals;
118 
119     mapping (uint => uint) public tmVestingTimer;
120     mapping (uint => uint) public tmVestingBalances;
121     mapping (uint => uint) public advVestingTimer;
122     mapping (uint => uint) public advVestingBalances;
123 
124     bool public tokenLock = true;
125     bool public saleTime = true;
126     uint public endSaleTime = 0;
127 
128     event SaleIssue(address indexed _to, uint _tokens);
129     event DevIssue(address indexed _to, uint _tokens);
130     event EcoIssue(address indexed _to, uint _tokens);
131     event LegalComplianceIssue(address indexed _to, uint _tokens);
132     event MktIssue(address indexed _to, uint _tokens);
133     event RsvIssue(address indexed _to, uint _tokens);
134     event TeamIssue(address indexed _to, uint _tokens);
135     event AdvIssue(address indexed _to, uint _tokens);
136 
137     event Burn(address indexed _from, uint _tokens);
138 
139     event TokenUnlock(address indexed _to, uint _tokens);
140     event EndSale(uint _date);
141 
142     constructor()
143     {
144         name        = "ARTIC";
145         decimals    = 18;
146         symbol      = "ARTIC";
147 
148         totalTokenSupply = maxTotalSupply;
149         balances[owner] = totalTokenSupply;
150 
151         tokenIssuedSale     = 0;
152         tokenIssuedDev      = 0;
153         tokenIssuedEco      = 0;
154         tokenIssuedLegalCompliance = 0;
155         tokenIssuedMkt      = 0;
156         tokenIssuedRsv      = 0;
157         tokenIssuedTeam     = 0;
158         tokenIssuedAdv      = 0;
159 
160         burnTokenSupply     = 0;
161 
162         require(maxTeamSupply == teamVestingSupply * teamVestingTime, "ERROR: MaxTeamSupply");
163         require(maxAdvisorSupply == advisorVestingSupply * advisorVestingTime, "ERROR: MaxAdvisorSupply");
164         require(maxTotalSupply == maxSaleSupply + maxDevSupply + maxEcoSupply + maxMktSupply + maxReserveSupply + maxTeamSupply + maxAdvisorSupply + maxLegalComplianceSupply, "ERROR: MaxTotalSupply");
165     }
166 
167     function totalSupply() view override public returns (uint)
168     {
169         return totalTokenSupply;
170     }
171 
172     function balanceOf(address _who) view override public returns (uint)
173     {
174         return balances[_who];
175     }
176 
177     function transfer(address _to, uint _value) override public returns (bool)
178     {
179         require(isTransferable() == true);
180         require(balances[msg.sender] >= _value);
181 
182         balances[msg.sender] = balances[msg.sender] - _value;
183         balances[_to] = balances[_to] + _value;
184 
185         emit Transfer(msg.sender, _to, _value);
186 
187         return true;
188     }
189 
190     function approve(address _spender, uint _value) override public returns (bool)
191     {
192         require(isTransferable() == true);
193         require(balances[msg.sender] >= _value);
194 
195         approvals[msg.sender][_spender] = _value;
196 
197         emit Approval(msg.sender, _spender, _value);
198 
199         return true;
200     }
201 
202     function allowance(address _owner, address _spender) view override public returns (uint)
203     {
204         return approvals[_owner][_spender];
205     }
206 
207     function transferFrom(address _from, address _to, uint _value) override public returns (bool)
208     {
209         require(isTransferable() == true);
210         require(balances[_from] >= _value);
211         require(approvals[_from][msg.sender] >= _value);
212 
213         approvals[_from][msg.sender] = approvals[_from][msg.sender] - _value;
214         balances[_from] = balances[_from] - _value;
215         balances[_to]  = balances[_to] + _value;
216 
217         emit Transfer(_from, _to, _value);
218 
219         return true;
220     }
221 
222     function saleIssue(address _to) onlyOwner public
223     {
224         require(tokenIssuedSale == 0);
225         uint tokens = maxSaleSupply;
226 
227         balances[msg.sender] = balances[msg.sender] - tokens;
228 
229         balances[_to] = balances[_to] + tokens;
230 
231         tokenIssuedSale = tokenIssuedSale + tokens;
232 
233         emit SaleIssue(_to, tokens);
234     }
235 
236     function devIssue(address _to) onlyOwner public
237     {
238         require(saleTime == false);
239         require(tokenIssuedDev == 0);
240 
241         uint tokens = maxDevSupply;
242 
243         balances[msg.sender] = balances[msg.sender] - tokens;
244 
245         balances[_to] = balances[_to] + tokens;
246 
247         tokenIssuedDev = tokenIssuedDev + tokens;
248 
249         emit DevIssue(_to, tokens);
250     }
251 
252     function ecoIssue(address _to) onlyOwner public
253     {
254         require(saleTime == false);
255         require(tokenIssuedEco == 0);
256 
257         uint tokens = maxEcoSupply;
258 
259         balances[msg.sender] = balances[msg.sender] - tokens;
260 
261         balances[_to] = balances[_to] + tokens;
262 
263         tokenIssuedEco = tokenIssuedEco + tokens;
264 
265         emit EcoIssue(_to, tokens);
266     }
267 
268     function mktIssue(address _to) onlyOwner public
269     {
270         require(saleTime == false);
271         require(tokenIssuedMkt == 0);
272 
273         uint tokens = maxMktSupply;
274 
275         balances[msg.sender] = balances[msg.sender] - tokens;
276 
277         balances[_to] = balances[_to] + tokens;
278 
279         tokenIssuedMkt = tokenIssuedMkt + tokens;
280 
281         emit MktIssue(_to, tokens);
282     }
283 
284     function legalComplianceIssue(address _to) onlyOwner public
285     {
286         require(saleTime == false);
287         require(tokenIssuedLegalCompliance == 0);
288 
289         uint tokens = maxLegalComplianceSupply;
290 
291         balances[msg.sender] = balances[msg.sender] - tokens;
292 
293         balances[_to] = balances[_to] + tokens;
294 
295         tokenIssuedLegalCompliance = tokenIssuedLegalCompliance + tokens;
296 
297         emit LegalComplianceIssue(_to, tokens);
298     }
299 
300     function rsvIssue(address _to) onlyOwner public
301     {
302         require(saleTime == false);
303         require(tokenIssuedRsv == 0);
304 
305         uint tokens = maxReserveSupply;
306 
307         balances[msg.sender] = balances[msg.sender] - tokens;
308 
309         balances[_to] = balances[_to] + tokens;
310 
311         tokenIssuedRsv = tokenIssuedRsv + tokens;
312 
313         emit RsvIssue(_to, tokens);
314     }
315 
316     function teamIssue(address _to, uint _time /* 몇 번째 지급인지 */) onlyOwner public
317     {
318         require(saleTime == false);
319         require( _time < teamVestingTime);
320 
321         uint nowTime = block.timestamp;
322         require( nowTime > tmVestingTimer[_time] );
323 
324         uint tokens = teamVestingSupply;
325 
326         require(tokens == tmVestingBalances[_time]);
327         require(maxTeamSupply >= tokenIssuedTeam + tokens);
328 
329         balances[msg.sender] = balances[msg.sender] - tokens;
330 
331         balances[_to] = balances[_to] + tokens;
332         tmVestingBalances[_time] = 0;
333 
334         tokenIssuedTeam = tokenIssuedTeam + tokens;
335 
336         emit TeamIssue(_to, tokens);
337     }
338 
339     function advisorIssue(address _to, uint _time) onlyOwner public
340     {
341         require(saleTime == false);
342         require( _time < advisorVestingTime);
343 
344         uint nowTime = block.timestamp;
345         require( nowTime > advVestingTimer[_time] );
346 
347         uint tokens = advisorVestingSupply;
348 
349         require(tokens == advVestingBalances[_time]);
350         require(maxAdvisorSupply >= tokenIssuedAdv + tokens);
351 
352         balances[msg.sender] = balances[msg.sender] - tokens;
353 
354         balances[_to] = balances[_to] + tokens;
355         advVestingBalances[_time] = 0;
356 
357         tokenIssuedAdv = tokenIssuedAdv + tokens;
358 
359         emit AdvIssue(_to, tokens);
360     }
361 
362     function isTransferable() private view returns (bool)
363     {
364         if(tokenLock == false)
365         {
366             return true;
367         }
368         else if(msg.sender == owner)
369         {
370             return true;
371         }
372 
373         return false;
374     }
375 
376     function setTokenUnlock() onlyManagerAndOwner public
377     {
378         require(tokenLock == true);
379         require(saleTime == false);
380 
381         tokenLock = false;
382     }
383 
384     function setTokenLock() onlyManagerAndOwner public
385     {
386         require(tokenLock == false);
387         tokenLock = true;
388     }
389 
390     function endSale() onlyOwner public
391     {
392         require(saleTime == true);
393         require(maxSaleSupply == tokenIssuedSale);
394 
395         saleTime = false;
396 
397         uint nowTime = block.timestamp;
398         endSaleTime = nowTime;
399 
400         for(uint i = 0; i < teamVestingTime; i++)
401         {
402             tmVestingTimer[i] = endSaleTime + teamVestingLockDate + (i * month);
403             tmVestingBalances[i] = teamVestingSupply;
404         }
405 
406         for(uint i = 0; i < advisorVestingTime; i++)
407         {
408             advVestingTimer[i] = endSaleTime + (3 * i * month);
409             advVestingBalances[i] = advisorVestingSupply;
410         }
411 
412         emit EndSale(endSaleTime);
413     }
414 
415     function burnToken(uint _value) onlyManagerAndOwner public
416     {
417         uint tokens = _value * E18;
418 
419         require(balances[msg.sender] >= tokens);
420 
421         balances[msg.sender] = balances[msg.sender] - tokens;
422 
423         burnTokenSupply = burnTokenSupply + tokens;
424         totalTokenSupply = totalTokenSupply - tokens;
425 
426         emit Burn(msg.sender, tokens);
427     }
428 
429     function close() onlyOwner public
430     {
431         selfdestruct(payable(msg.sender));
432     }
433 }