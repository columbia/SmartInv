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
107 contract LNXtest is Helper, Ownable
108 {
109     using SafeMath for uint;
110     
111     string public name;
112     string public symbol;
113     uint public decimals;
114     
115     uint constant private zeroAfterDecimal = 10**18;
116     uint constant private monInSec = 10;//2592000
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
129     uint constant public vestingAmountPerRound_RND          = 4947500 * zeroAfterDecimal;
130     uint constant public vestingReleaseTime_RND             = 1 * monInSec;
131     uint constant public vestingReleaseRound_RND            = 50;
132 
133     uint constant public vestingAmountPerRound_Advisor      = 30921875 * zeroAfterDecimal;
134     uint constant public vestingReleaseTime_Advisor         = 3 * monInSec;
135     uint constant public vestingReleaseRound_Advisor        = 4;
136 
137     uint constant public vestingAmountPerRound_Team        = 247375000 * zeroAfterDecimal;
138     uint constant public vestingReleaseTime_Team           = 48 * monInSec;
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
178     constructor() public
179     {
180         name        = "LNXtest Token2";
181         decimals    = 18;
182         symbol      = "LMT";
183         
184         issueToken_Total      = 0;
185         
186         issueToken_Public     = 0;
187         issueToken_Private    = 0;
188         issueToken_Ecosystem  = 0;
189         issueToken_Marketing  = 0;
190         issueToken_RND        = 0;
191         issueToken_Team       = 0;
192         issueToken_Reserve    = 0;
193         issueToken_Advisor    = 0;
194         
195         require(maxSupply == maxSupply_Public + maxSupply_Private + maxSupply_Ecosystem + maxSupply_Marketing + maxSupply_RND + maxSupply_Team + maxSupply_Reserve + maxSupply_Advisor);
196         require(maxSupply_RND == vestingAmountPerRound_RND * vestingReleaseRound_RND);
197         require(maxSupply_Team == vestingAmountPerRound_Team * vestingReleaseRound_Team);
198         require(maxSupply_Advisor == vestingAmountPerRound_Advisor * vestingReleaseRound_Advisor);
199     }
200     
201     // ERC - 20 Interface -----
202 
203     function totalSupply() view public returns (uint) {
204         return issueToken_Total;}
205     
206     function balanceOf(address _who) view public returns (uint) {
207         uint balance = balances[_who];
208         
209         return balance;}
210     
211     function transfer(address _to, uint _value) public returns (bool) {
212         require(isTransferable() == true);
213         require(balances[msg.sender] >= _value);
214         
215         balances[msg.sender] = balances[msg.sender].sub(_value);
216         balances[_to] = balances[_to].add(_value);
217         
218         emit Transfer(msg.sender, _to, _value);
219         
220         return true;}
221     
222     function approve(address _spender, uint _value) public returns (bool){
223         require(isTransferable() == true);
224         require(balances[msg.sender] >= _value);
225         
226         approvals[msg.sender][_spender] = _value;
227         
228         emit Approval(msg.sender, _spender, _value);
229         
230         return true; }
231     
232     function allowance(address _owner, address _spender) view public returns (uint) {
233         return approvals[_owner][_spender];}
234 
235     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
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
246         return true;}
247     
248     // -----
249     
250     // Issue Function -----
251     function issue_noVesting_Private(address _to, uint _value) onlyOwner_creator public
252     {
253         uint tokens = _value * zeroAfterDecimal;
254         require(maxSupply_Private >= issueToken_Private.add(tokens));
255         
256         balances[_to] = balances[_to].add(tokens);
257         
258         issueToken_Total = issueToken_Total.add(tokens);
259         issueToken_Private = issueToken_Private.add(tokens);
260         
261         emit Issue_private(_to, tokens);
262     }
263 
264     function issue_noVesting_Public(address _to, uint _value) onlyOwner_creator public
265     {
266         uint tokens = _value * zeroAfterDecimal;
267         require(maxSupply_Public >= issueToken_Public.add(tokens));
268         
269         balances[_to] = balances[_to].add(tokens);
270         
271         issueToken_Total = issueToken_Total.add(tokens);
272         issueToken_Public = issueToken_Public.add(tokens);
273         
274         emit Issue_public(_to, tokens);
275     }    
276     
277     function issue_noVesting_Marketing(address _to, uint _value) onlyOwner_creator public
278     {
279         uint tokens = _value * zeroAfterDecimal;
280         require(maxSupply_Marketing >= issueToken_Marketing.add(tokens));
281         
282         balances[_to] = balances[_to].add(tokens);
283         
284         issueToken_Total = issueToken_Total.add(tokens);
285         issueToken_Marketing = issueToken_Marketing.add(tokens);
286         
287         emit Issue_marketing(_to, tokens);
288     }
289 
290     function issue_noVesting_Ecosystem(address _to, uint _value) onlyOwner_creator public
291     {
292         uint tokens = _value * zeroAfterDecimal;
293         require(maxSupply_Ecosystem >= issueToken_Ecosystem.add(tokens));
294         
295         balances[_to] = balances[_to].add(tokens);
296         
297         issueToken_Total = issueToken_Total.add(tokens);
298         issueToken_Ecosystem = issueToken_Ecosystem.add(tokens);
299         
300         emit Issue_ecosystem(_to, tokens);
301     }
302     
303     function issue_noVesting_Reserve(address _to, uint _value) onlyOwner_creator public
304     {
305         uint tokens = _value * zeroAfterDecimal;
306         require(maxSupply_Reserve >= issueToken_Reserve.add(tokens));
307         
308         balances[_to] = balances[_to].add(tokens);
309         
310         issueToken_Total = issueToken_Total.add(tokens);
311         issueToken_Reserve = issueToken_Reserve.add(tokens);
312         
313         emit Issue_reserve(_to, tokens);
314     }
315     // Vesting Issue Function -----
316     
317     function issue_vesting_RND(address _to, uint _time) onlyOwner_creator public
318     {
319         require(saleTime == false);
320         require(vestingReleaseRound_RND >= _time);
321         
322         uint time = now;
323         require( ( ( endSaleTime + (_time * vestingReleaseTime_RND) ) < time ) && ( vestingRelease_RND[_time] > 0 ) );
324         
325         uint tokens = vestingRelease_RND[_time];
326 
327         require(maxSupply_RND >= issueToken_RND.add(tokens));
328         
329         balances[_to] = balances[_to].add(tokens);
330         vestingRelease_RND[_time] = 0;
331         
332         issueToken_Total = issueToken_Total.add(tokens);
333         issueToken_RND = issueToken_RND.add(tokens);
334         
335         emit Issue_RND(_to, tokens);
336     }
337     
338     function issue_vesting_Advisor(address _to, uint _time) onlyOwner_creator public
339     {
340         require(saleTime == false);
341         require(vestingReleaseRound_Advisor >= _time);
342         
343         uint time = now;
344         require( ( ( endSaleTime + (_time * vestingReleaseTime_Advisor) ) < time ) && ( vestingRelease_Advisor[_time] > 0 ) );
345         
346         uint tokens = vestingRelease_Advisor[_time];
347         
348         require(maxSupply_Advisor >= issueToken_Advisor.add(tokens));
349         
350         balances[_to] = balances[_to].add(tokens);
351         vestingRelease_Advisor[_time] = 0;
352         
353         issueToken_Total = issueToken_Total.add(tokens);
354         issueToken_Advisor = issueToken_Advisor.add(tokens);
355         
356         emit Issue_advisor(_to, tokens);
357     }
358 
359     function issueTokenWithVesting_Team(address _to, uint _time) onlyOwner_creator public
360     {
361         require(saleTime == false);
362         require(vestingReleaseRound_Team >= _time);
363         
364         uint time = now;
365         require( ( ( endSaleTime + (_time * vestingReleaseTime_Team) ) < time ) && ( vestingRelease_Team[_time] > 0 ) );
366         
367         uint tokens = vestingRelease_Team[_time];
368         
369         require(maxSupply_Team >= issueToken_Team.add(tokens));
370         
371         balances[_to] = balances[_to].add(tokens);
372         vestingRelease_Team[_time] = 0;
373         
374         issueToken_Total = issueToken_Total.add(tokens);
375         issueToken_Team = issueToken_Team.add(tokens);
376         
377         emit Issue_team(_to, tokens);
378     }
379 
380 
381     
382     // -----
383     
384     // Lock Function -----
385     
386     function isTransferable() private view returns (bool)
387     {
388         if(tokenLock == false)
389         {
390             return true;
391         }
392         else if(msg.sender == Owner_manager)
393         {
394             return true;
395         }
396         
397         return false;
398     }
399     
400     function setTokenUnlock() onlyOwner_manager public
401     {
402         require(tokenLock == true);
403         require(saleTime == false);
404         
405         tokenLock = false;
406     }
407     
408     function setTokenLock() onlyOwner_manager public
409     {
410         require(tokenLock == false);
411         
412         tokenLock = true;
413     }
414     
415     // -----
416     
417     // ETC / Burn Function -----
418     
419     function () payable external
420     {
421         revert();
422     }
423     
424     function endSale() onlyOwner_manager public
425     {
426         require(saleTime == true);
427         
428         saleTime = false;
429         
430         uint time = now;
431         
432         endSaleTime = time;
433         
434         for(uint i = 1; i <= vestingReleaseRound_RND; i++)
435         {
436             vestingRelease_RND[i] = vestingRelease_RND[i].add(vestingAmountPerRound_RND);
437         }
438         
439         for(uint i = 1; i <= vestingReleaseRound_Advisor; i++)
440         {
441             vestingRelease_Advisor[i] = vestingRelease_Advisor[i].add(vestingAmountPerRound_Advisor);
442         }
443 
444             for(uint i = 1; i <= vestingReleaseRound_Team; i++)
445         {
446             vestingRelease_Team[i] = vestingRelease_Team[i].add(vestingAmountPerRound_Team);
447         }
448     }
449     
450     function withdrawTokens(address _contract, uint _decimals, uint _value) onlyOwner_manager public
451     {
452 
453         if(_contract == address(0x0))
454         {
455             uint eth = _value.mul(10 ** _decimals);
456             msg.sender.transfer(eth);
457         }
458         else
459         {
460             uint tokens = _value.mul(10 ** _decimals);
461             Helper(_contract).transfer(msg.sender, tokens);
462             
463             emit Transfer(address(0x0), msg.sender, tokens);
464         }
465     }
466     
467     function burnToken(uint _value) onlyOwner_manager public
468     {
469         uint tokens = _value * zeroAfterDecimal;
470         
471         require(balances[msg.sender] >= tokens);
472         
473         balances[msg.sender] = balances[msg.sender].sub(tokens);
474         
475         burnTokenAmount = burnTokenAmount.add(tokens);
476         issueToken_Total = issueToken_Total.sub(tokens);
477         
478         emit Burn(msg.sender, tokens);
479     }
480     
481     function close() onlyOwner_master public
482     {
483         selfdestruct(msg.sender);
484     }
485     
486     // -----
487 }