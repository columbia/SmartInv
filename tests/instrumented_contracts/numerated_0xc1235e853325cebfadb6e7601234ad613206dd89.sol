1 pragma solidity ^0.5.0;
2 
3 
4 library SafeMath{
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
36 contract Ownable
37 {
38   	address public Owner_master;
39   	address public Owner_creator;
40   	address public Owner_manager;
41 
42   	event ChangeOwner_master(address indexed _from, address indexed _to);
43   	event ChangeOwner_creator(address indexed _from, address indexed _to);
44   	event ChangeOwner_manager(address indexed _from, address indexed _to);
45 
46   	modifier onlyOwner_master{ 
47           require(msg.sender == Owner_master);	_; 	}
48   	modifier onlyOwner_creator{ 
49           require(msg.sender == Owner_creator); _; }
50   	modifier onlyOwner_manager{ 
51           require(msg.sender == Owner_manager); _; }
52   	constructor() public { 
53           Owner_master = msg.sender; }
54   	
55     
56     
57     
58     
59     
60     function transferOwnership_master(address _to) onlyOwner_master public{
61         	require(_to != Owner_master);
62         	require(_to != Owner_creator);
63         	require(_to != Owner_manager);
64         	require(_to != address(0x0));
65 
66 		address from = Owner_master;
67   	    	Owner_master = _to;
68   	    
69   	    	emit ChangeOwner_master(from, _to);}
70 
71   	function transferOwner_creator(address _to) onlyOwner_master public{
72 	        require(_to != Owner_master);
73         	require(_to != Owner_creator);
74         	require(_to != Owner_manager);
75 	        require(_to != address(0x0));
76 
77 		address from = Owner_creator;        
78 	    	Owner_creator = _to;
79         
80     		emit ChangeOwner_creator(from, _to);}
81 
82   	function transferOwner_manager(address _to) onlyOwner_master public{
83 	        require(_to != Owner_master);
84 	        require(_to != Owner_creator);
85         	require(_to != Owner_manager);
86 	        require(_to != address(0x0));
87         	
88 		address from = Owner_manager;
89     		Owner_manager = _to;
90         
91 	    	emit ChangeOwner_manager(from, _to);}
92 }
93 
94 contract Helper
95 {
96     event Transfer( address indexed _from, address indexed _to, uint _value);
97     event Approval( address indexed _owner, address indexed _spender, uint _value);
98     
99     function totalSupply() view public returns (uint _supply);
100     function balanceOf( address _who ) public view returns (uint _value);
101     function transfer( address _to, uint _value) public returns (bool _success);
102     function approve( address _spender, uint _value ) public returns (bool _success);
103     function allowance( address _owner, address _spender ) public view returns (uint _allowance);
104     function transferFrom( address _from, address _to, uint _value) public returns (bool _success);
105 }
106 
107 contract LINIX is Helper, Ownable
108 {
109     using SafeMath for uint;
110     
111     string public name;
112     string public symbol;
113     uint public decimals;
114     
115     uint constant private zeroAfterDecimal = 10**18;
116     uint constant private monInSec = 2592000;
117     
118     uint constant public maxSupply             = 2473750000 * zeroAfterDecimal;
119     
120     uint constant public maxSupply_Public      =   100000000 * zeroAfterDecimal;
121     uint constant public maxSupply_Private     =   889500000 * zeroAfterDecimal;
122     uint constant public maxSupply_Advisor     =   123687500 * zeroAfterDecimal;
123     uint constant public maxSupply_Reserve     =   296850000 * zeroAfterDecimal;
124     uint constant public maxSupply_Marketing   =   197900000 * zeroAfterDecimal;
125     uint constant public maxSupply_Ecosystem   =   371062500 * zeroAfterDecimal;
126     uint constant public maxSupply_RND         =   247375000 * zeroAfterDecimal;
127     uint constant public maxSupply_Team        =   247375000 * zeroAfterDecimal;
128   
129     uint constant public vestingAmountPerRound_RND          = 9895000 * zeroAfterDecimal;
130     uint constant public vestingReleaseTime_RND             = 1 * monInSec;
131     uint constant public vestingReleaseRound_RND            = 25;
132 
133     uint constant public vestingAmountPerRound_Advisor      = 30921875 * zeroAfterDecimal;
134     uint constant public vestingReleaseTime_Advisor         = 3 * monInSec;
135     uint constant public vestingReleaseRound_Advisor        = 4;
136 
137     uint constant public vestingAmountPerRound_Team        = 247375000 * zeroAfterDecimal;
138     uint constant public vestingReleaseTime_Team           = 24 * monInSec;
139     uint constant public vestingReleaseRound_Team          = 1;
140     
141     uint public issueToken_Total;
142     
143     uint public issueToken_Private;
144     uint public issueToken_Public;
145     uint public issueToken_Ecosystem;
146     uint public issueToken_Marketing;
147     uint public issueToken_RND;
148     uint public issueToken_Team;
149     uint public issueToken_Reserve;
150     uint public issueToken_Advisor;
151     
152     uint public burnTokenAmount;
153     
154     mapping (address => uint) public balances;
155     mapping (address => mapping ( address => uint )) public approvals;
156 
157     mapping (uint => uint) public vestingRelease_RND;
158     mapping (uint => uint) public vestingRelease_Advisor;
159     mapping (uint => uint) public vestingRelease_Team;
160     
161     bool public tokenLock = true;
162     bool public saleTime = true;
163     uint public endSaleTime = 0;
164     
165     event Burn(address indexed _from, uint _value);
166     
167     event Issue_private(address indexed _to, uint _tokens);
168     event Issue_public(address indexed _to, uint _tokens);
169     event Issue_ecosystem(address indexed _to, uint _tokens);
170     event Issue_marketing(address indexed _to, uint _tokens);
171     event Issue_RND(address indexed _to, uint _tokens);
172     event Issue_team(address indexed _to, uint _tokens);
173     event Issue_reserve(address indexed _to, uint _tokens);
174     event Issue_advisor(address indexed _to, uint _tokens);
175     
176     event TokenUnLock(address indexed _to, uint _tokens);
177 
178     
179     constructor() public
180     {
181         name        = "LINIX";
182         decimals    = 18;
183         symbol      = "LNX";
184         
185         issueToken_Total      = 0;
186         
187         issueToken_Public     = 0;
188         issueToken_Private    = 0;
189         issueToken_Ecosystem  = 0;
190         issueToken_Marketing  = 0;
191         issueToken_RND        = 0;
192         issueToken_Team       = 0;
193         issueToken_Reserve    = 0;
194         issueToken_Advisor    = 0;
195         
196         require(maxSupply == maxSupply_Public + maxSupply_Private + maxSupply_Ecosystem + maxSupply_Marketing + maxSupply_RND + maxSupply_Team + maxSupply_Reserve + maxSupply_Advisor);
197         require(maxSupply_RND == vestingAmountPerRound_RND * vestingReleaseRound_RND);
198         require(maxSupply_Team == vestingAmountPerRound_Team * vestingReleaseRound_Team);
199         require(maxSupply_Advisor == vestingAmountPerRound_Advisor * vestingReleaseRound_Advisor);
200     }
201     
202     // ERC - 20 Interface -----
203 
204     function totalSupply() view public returns (uint) {
205         return issueToken_Total;}
206     
207     function balanceOf(address _who) view public returns (uint) {
208         uint balance = balances[_who];
209         
210         return balance;}
211     
212     function transfer(address _to, uint _value) public returns (bool) {
213         require(isTransferable() == true);
214         require(balances[msg.sender] >= _value);
215         
216         balances[msg.sender] = balances[msg.sender].sub(_value);
217         balances[_to] = balances[_to].add(_value);
218         
219         emit Transfer(msg.sender, _to, _value);
220         
221         return true;}
222     
223     function approve(address _spender, uint _value) public returns (bool){
224         require(isTransferable() == true);
225         require(balances[msg.sender] >= _value);
226         
227         approvals[msg.sender][_spender] = _value;
228         
229         emit Approval(msg.sender, _spender, _value);
230         
231         return true; }
232     
233     function allowance(address _owner, address _spender) view public returns (uint) {
234         return approvals[_owner][_spender];}
235 
236     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
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
247         return true;}
248     
249     // -----
250     
251     // Issue Function -----
252     function issue_noVesting_Private(address _to, uint _value) onlyOwner_creator public
253     {
254         uint tokens = _value * zeroAfterDecimal;
255         require(maxSupply_Private >= issueToken_Private.add(tokens));
256         
257         balances[_to] = balances[_to].add(tokens);
258         
259         issueToken_Total = issueToken_Total.add(tokens);
260         issueToken_Private = issueToken_Private.add(tokens);
261         
262         emit Issue_private(_to, tokens);
263     }
264 
265     function issue_noVesting_Public(address _to, uint _value) onlyOwner_creator public
266     {
267         uint tokens = _value * zeroAfterDecimal;
268         require(maxSupply_Public >= issueToken_Public.add(tokens));
269         
270         balances[_to] = balances[_to].add(tokens);
271         
272         issueToken_Total = issueToken_Total.add(tokens);
273         issueToken_Public = issueToken_Public.add(tokens);
274         
275         emit Issue_public(_to, tokens);
276     }    
277     
278     function issue_noVesting_Marketing(address _to, uint _value) onlyOwner_creator public
279     {
280         uint tokens = _value * zeroAfterDecimal;
281         require(maxSupply_Marketing >= issueToken_Marketing.add(tokens));
282         
283         balances[_to] = balances[_to].add(tokens);
284         
285         issueToken_Total = issueToken_Total.add(tokens);
286         issueToken_Marketing = issueToken_Marketing.add(tokens);
287         
288         emit Issue_marketing(_to, tokens);
289     }
290 
291     function issue_noVesting_Ecosystem(address _to, uint _value) onlyOwner_creator public
292     {
293         uint tokens = _value * zeroAfterDecimal;
294         require(maxSupply_Ecosystem >= issueToken_Ecosystem.add(tokens));
295         
296         balances[_to] = balances[_to].add(tokens);
297         
298         issueToken_Total = issueToken_Total.add(tokens);
299         issueToken_Ecosystem = issueToken_Ecosystem.add(tokens);
300         
301         emit Issue_ecosystem(_to, tokens);
302     }
303     
304     function issue_noVesting_Reserve(address _to, uint _value) onlyOwner_creator public
305     {
306         uint tokens = _value * zeroAfterDecimal;
307         require(maxSupply_Reserve >= issueToken_Reserve.add(tokens));
308         
309         balances[_to] = balances[_to].add(tokens);
310         
311         issueToken_Total = issueToken_Total.add(tokens);
312         issueToken_Reserve = issueToken_Reserve.add(tokens);
313         
314         emit Issue_reserve(_to, tokens);
315     }
316     // Vesting Issue Function -----
317     
318     function issue_Vesting_RND(address _to, uint _time) onlyOwner_creator public
319     {
320         require(saleTime == false);
321         require(vestingReleaseRound_RND >= _time);
322         
323         uint time = now;
324         require( ( ( endSaleTime + (_time * vestingReleaseTime_RND) ) < time ) && ( vestingRelease_RND[_time] > 0 ) );
325         
326         uint tokens = vestingRelease_RND[_time];
327 
328         require(maxSupply_RND >= issueToken_RND.add(tokens));
329         
330         balances[_to] = balances[_to].add(tokens);
331         vestingRelease_RND[_time] = 0;
332         
333         issueToken_Total = issueToken_Total.add(tokens);
334         issueToken_RND = issueToken_RND.add(tokens);
335         
336         emit Issue_RND(_to, tokens);
337     }
338     
339     function issue_Vesting_Advisor(address _to, uint _time) onlyOwner_creator public
340     {
341         require(saleTime == false);
342         require(vestingReleaseRound_Advisor >= _time);
343         
344         uint time = now;
345         require( ( ( endSaleTime + (_time * vestingReleaseTime_Advisor) ) < time ) && ( vestingRelease_Advisor[_time] > 0 ) );
346         
347         uint tokens = vestingRelease_Advisor[_time];
348         
349         require(maxSupply_Advisor >= issueToken_Advisor.add(tokens));
350         
351         balances[_to] = balances[_to].add(tokens);
352         vestingRelease_Advisor[_time] = 0;
353         
354         issueToken_Total = issueToken_Total.add(tokens);
355         issueToken_Advisor = issueToken_Advisor.add(tokens);
356         
357         emit Issue_advisor(_to, tokens);
358     }
359 
360     function issue_Vesting_Team(address _to, uint _time) onlyOwner_creator public
361     {
362         require(saleTime == false);
363         require(vestingReleaseRound_Team >= _time);
364         
365         uint time = now;
366         require( ( ( endSaleTime + (_time * vestingReleaseTime_Team) ) < time ) && ( vestingRelease_Team[_time] > 0 ) );
367         
368         uint tokens = vestingRelease_Team[_time];
369         
370         require(maxSupply_Team >= issueToken_Team.add(tokens));
371         
372         balances[_to] = balances[_to].add(tokens);
373         vestingRelease_Team[_time] = 0;
374         
375         issueToken_Total = issueToken_Total.add(tokens);
376         issueToken_Team = issueToken_Team.add(tokens);
377         
378         emit Issue_team(_to, tokens);
379     }
380 
381 
382     
383     // -----
384     
385     // Lock Function -----
386     
387     function isTransferable() private view returns (bool)
388     {
389         if(tokenLock == false)
390         {
391             return true;
392         }
393         else if(msg.sender == Owner_manager)
394         {
395             return true;
396         }
397         
398         return false;
399     }
400     
401     function setTokenUnlock() onlyOwner_manager public
402     {
403         require(tokenLock == true);
404         require(saleTime == false);
405         
406         tokenLock = false;
407     }
408     
409     function setTokenLock() onlyOwner_manager public
410     {
411         require(tokenLock == false);
412         
413         tokenLock = true;
414     }
415     
416     // -----
417     
418     // ETC / Burn Function -----
419     
420     function () payable external
421     {
422         revert();
423     }
424     
425     function endSale() onlyOwner_manager public
426     {
427         require(saleTime == true);
428         
429         saleTime = false;
430         
431         uint time = now;
432         
433         endSaleTime = time;
434         
435         for(uint i = 1; i <= vestingReleaseRound_RND; i++)
436         {
437             vestingRelease_RND[i] = vestingRelease_RND[i].add(vestingAmountPerRound_RND);
438         }
439         
440         for(uint i = 1; i <= vestingReleaseRound_Advisor; i++)
441         {
442             vestingRelease_Advisor[i] = vestingRelease_Advisor[i].add(vestingAmountPerRound_Advisor);
443         }
444 
445             for(uint i = 1; i <= vestingReleaseRound_Team; i++)
446         {
447             vestingRelease_Team[i] = vestingRelease_Team[i].add(vestingAmountPerRound_Team);
448         }
449     }
450     
451     function withdrawTokens(address _contract, uint _decimals, uint _value) onlyOwner_manager public
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
462             Helper(_contract).transfer(msg.sender, tokens);
463             
464             emit Transfer(address(0x0), msg.sender, tokens);
465         }
466     }
467     
468     function burnToken(uint _value) onlyOwner_manager public
469     {
470         uint tokens = _value * zeroAfterDecimal;
471         
472         require(balances[msg.sender] >= tokens);
473         
474         balances[msg.sender] = balances[msg.sender].sub(tokens);
475         
476         burnTokenAmount = burnTokenAmount.add(tokens);
477         issueToken_Total = issueToken_Total.sub(tokens);
478         
479         emit Burn(msg.sender, tokens);
480     }
481     
482     function close() onlyOwner_master public
483     {
484         selfdestruct(msg.sender);
485     }
486     
487     // -----
488 }