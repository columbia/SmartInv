1 pragma solidity ^0.4.4;
2 
3 
4 library SafeMath {
5 
6     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
7         if (a == 0) {
8             return 0;
9         }
10         c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         return a / b;
18     }
19 
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
28         c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 contract AltcoinToken {
35     function balanceOf(address _owner) constant public returns (uint256);
36     function transfer(address _to, uint256 _value) public returns (bool);
37 }
38 
39 contract ERC20Basic {
40     uint256 public totalSupply;
41     function totalSupply() public constant returns (uint);
42     function balanceOf(address who) public constant returns (uint256);
43     function transfer(address to, uint256 value) public returns (bool);
44     event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 contract ERC20 is ERC20Basic {
48     function allowance(address owner, address spender) public constant returns (uint256);
49     function transferFrom(address from, address to, uint256 value) public returns (bool);
50     function approve(address spender, uint256 value) public returns (bool);
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 
55 contract ERC20Interface {
56     function totalSupply() public constant returns (uint);
57     function balanceOf(address tokenOwner) public constant returns (uint balance);
58     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
59     function transfer(address to, uint tokens) public returns (bool success);
60     function approve(address spender, uint tokens) public returns (bool success);
61     function transferFrom(address from, address to, uint tokens) public returns (bool success);
62 
63     event Transfer(address indexed from, address indexed to, uint tokens);
64     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
65 }
66 
67 
68 
69 contract ApproveAndCallFallBack {
70     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
71 }
72 
73 
74 contract Owned {
75     address public owner;
76     address public newOwner;
77 
78     event OwnershipTransferred(address indexed _from, address indexed _to);
79 
80     constructor() public {
81         owner = msg.sender;
82     }
83 
84     modifier onlyOwner {
85         require(msg.sender == owner);
86         _;
87     }
88 
89     function transferOwnership(address _newOwner) public onlyOwner {
90         newOwner = _newOwner;
91     }
92     function acceptOwnership() public {
93         require(msg.sender == newOwner);
94         emit OwnershipTransferred(owner, newOwner);
95         owner = newOwner;
96         newOwner = address(0);
97     }
98 }
99 
100 contract SterlingSovereign is ERC20, Owned {
101     
102     using SafeMath for uint256;
103     address owner = msg.sender;
104 		
105     mapping (address => uint256) balances;
106     mapping (address => mapping (address => uint256)) allowed;    
107 
108     string public constant name = "SterlingSovereign";
109     string public constant symbol = "STSO";
110     uint public constant decimals = 8;
111     
112     uint256 public totalSupply =  5000000000000000000;
113     uint256 public totalDistributed = 0; 
114     uint256 public totalIcoDistributed = 0;
115     uint256 public constant minContribution = 1 ether / 100; // 0.01 Eth
116 	
117 	
118 	uint256 public tokensPerEth = 0;
119 	
120 	// ------------------------------
121     // Token Distribution and Address
122     // ------------------------------
123     
124     // saleable 70%
125     uint256 public constant totalIco = 3500000000000000000;
126     uint256 public totalIcoDist = 0;
127     address storageIco = owner;
128     
129     // airdrop 5%
130     uint256 public constant totalAirdrop = 250000000000000000;
131     address private storageAirdrop = 0x49448F6cB501c66211bbd7E927981489Cdd8B13f;
132     
133     // developer 10%
134     uint256 public constant totalDeveloper = 500000000000000000;
135     address private storageDeveloper = 0x054Eb74982E38cB57cD131a37dDaDA35ddE08032;
136     
137     // presale 10%
138     uint256 public constant totalPresale = 500000000000000000;
139     address private storagePresale = 0xcc2707BF0783B4e7aEe7A4524078ff1f7e5BB20F;
140     
141     // publicsale 60%
142     uint256 public constant totalPublicsale = 3000000000000000000;
143     address private storagePublicsale = 0xfA970dC7C48edf63c276DFf87E5E16c9D582A723;
144     
145     // team 10%
146     uint256 public constant totalTeam = 500000000000000000;
147     address private storageTeam = 0xf96c9bC74853349ffc0e2F96869Ff015323e0090;
148     
149     // partnership 5%
150     uint256 public constant totalPartnership = 250000000000000000;
151     address private storagePartnership = 0xe88fB5be324B7718f9f76F4E90584d64d280C20A;
152     
153    
154 
155     
156     // ---------------------
157     // sale start and price
158     // ---------------------
159     
160     // presale
161 	uint public presaleStartTime = 1537876800; // Tuesday, 01 January 2019 19:00:00 GMT+07:00
162     uint256 public presalePerEth = 2500000000000000;
163     uint256 public presaleBonusPerEth = 625000000000000;
164     
165     // ico
166     uint public icoStartTime = 1539190800; // Tuesday, 15 January 2019 00:00:00 GMT+07:00
167     uint256 public icoPerEth = 2500000000000000;
168     uint256 public icoBonusPerEth = 500000000000000;
169     
170     // ico1
171     uint public ico1StartTime = 1540573200; // Wednesday, 30 January 2019 00:00:00 GMT+07:00
172     uint256 public ico1PerEth = 2500000000000000;
173     uint256 public ico1BonusPerEth = 375000000000000;
174     
175     // ico2
176     uint public ico2StartTime = 1541955600; // Wednesday, 13 February 2019 00:00:00 GMT+07:00
177     uint256 public ico2PerEth = 2000000000000000;
178     uint256 public ico2BonusPerEth = 250000000000000;
179     
180     //ico start and end
181     uint public icoOpenTime = presaleStartTime;
182     uint public icoEndTime = 1543251600; // Thursday, 28 February 2019 00:00:00 GMT+07:00
183     
184 	// -----------------------
185 	// events
186 	// -----------------------
187 	
188     event Transfer(address indexed _from, address indexed _to, uint256 _value);
189     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
190     
191     event Distr(address indexed to, uint256 amount);
192     event DistrFinished();
193 
194     event Airdrop(address indexed _owner, uint _amount, uint _balance);
195 
196     event TokensPerEthUpdated(uint _tokensPerEth);
197     
198     event Burn(address indexed burner, uint256 value);
199 	
200 	event Sent(address from, address to, uint amount);
201 	
202 	
203 	// -------------------
204 	// STATE
205 	// ---------------------
206     bool public icoOpen = false; 
207     bool public icoFinished = false;
208     bool public distributionFinished = false;
209     
210     
211     // -----
212     // temp
213     // -----
214     uint256 public tTokenPerEth = 0;
215     uint256 public tAmount = 0;
216     uint i = 0;
217     bool private tIcoOpen = false;
218     
219     // ------------------------------------------------------------------------
220     // Constructor
221     // ------------------------------------------------------------------------
222     constructor() public {        
223         balances[owner] = totalIco;
224         balances[storageAirdrop] = totalAirdrop;
225         balances[storageDeveloper] = totalDeveloper;       
226     }
227     
228     // ------------------------------------------------------------------------
229     // Total supply
230     // ------------------------------------------------------------------------
231     function totalSupply() public constant returns (uint) {
232         return totalSupply  - balances[address(0)];
233     }
234 
235     modifier canDistr() {
236         require(!distributionFinished);
237         _;
238     }
239 	
240 	function startDistribution() onlyOwner canDistr public returns (bool) {
241         icoOpen = true;
242         presaleStartTime = now;
243         icoOpenTime = now;
244         return true;
245     }
246     
247     function finishDistribution() onlyOwner canDistr public returns (bool) {
248         distributionFinished = true;
249         icoFinished = true;
250         emit DistrFinished();
251         return true;
252     }
253     
254     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
255         totalDistributed = totalDistributed.add(_amount);        
256         balances[_to] = balances[_to].add(_amount);
257         balances[owner] = balances[owner].sub(_amount);
258         emit Distr(_to, _amount);
259         emit Transfer(address(0), _to, _amount);
260 
261         return true;
262     }
263 	
264 	function send(address receiver, uint amount) public {
265         if (balances[msg.sender] < amount) return;
266         balances[msg.sender] -= amount;
267         balances[receiver] += amount;
268         emit Sent(msg.sender, receiver, amount);
269     }
270     
271    
272     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
273         tokensPerEth = _tokensPerEth;
274         emit TokensPerEthUpdated(_tokensPerEth);
275     }
276            
277     function () external payable {
278 				
279 		//owner withdraw 
280 		if (msg.sender == owner && msg.value == 0){
281 			withdraw();
282 		}
283 		
284 		if(msg.sender != owner){
285 			if ( now < icoOpenTime ){
286 				revert('ICO does not open yet');
287 			}
288 			
289 			//is Open
290 			if ( ( now >= icoOpenTime ) && ( now <= icoEndTime ) ){
291 				icoOpen = true;
292 			}
293 			
294 			if ( now > icoEndTime ){
295 				icoOpen = false;
296 				icoFinished = true;
297 				distributionFinished = true;
298 			}
299 			
300 			if ( icoFinished == true ){
301 				revert('ICO has finished');
302 			}
303 			
304 			if ( distributionFinished == true ){
305 				revert('Token distribution has finished');
306 			}
307 			
308 			if ( icoOpen == true ){
309 				if ( now >= presaleStartTime && now < icoStartTime){ tTokenPerEth = presalePerEth; }
310 				if ( now >= icoStartTime && now < ico1StartTime){ tTokenPerEth = icoPerEth; }
311 				if ( now >= ico1StartTime && now < ico2StartTime){ tTokenPerEth = ico1PerEth; }
312 				if ( now >= ico2StartTime && now < icoEndTime){ tTokenPerEth = ico2PerEth; }
313 				
314 				tokensPerEth = tTokenPerEth;				
315 				getTokens();
316 				
317 			}
318 		}
319      }
320     
321     function getTokens() payable canDistr  public {
322         uint256 tokens = 0;
323 
324         require( msg.value >= minContribution );
325 
326         require( msg.value > 0 );
327         
328         tokens = tokensPerEth.mul(msg.value) / 1 ether;
329         address investor = msg.sender;
330         
331         
332         if ( icoFinished == true ){
333 			revert('ICO Has Finished');
334 		}
335         
336         if( balances[owner] < tokens ){
337 			revert('Insufficient Token Balance or Sold Out.');
338 		}
339         
340         if (tokens < 0){
341 			revert();
342 		}
343         
344         totalIcoDistributed += tokens;
345         
346         if (tokens > 0) {
347            distr(investor, tokens);           
348         }
349 
350         if (totalIcoDistributed >= totalIco) {
351             distributionFinished = true;
352         }
353     }
354 	
355 	
356     function balanceOf(address _owner) constant public returns (uint256) {
357         return balances[_owner];
358     }
359 
360     // mitigates the ERC20 short address attack
361     modifier onlyPayloadSize(uint size) {
362         assert(msg.data.length >= size + 4);
363         _;
364     }
365     
366     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
367 
368         require(_to != address(0));
369         require(_amount <= balances[msg.sender]);
370         
371         balances[msg.sender] = balances[msg.sender].sub(_amount);
372         balances[_to] = balances[_to].add(_amount);
373         emit Transfer(msg.sender, _to, _amount);
374         return true;
375     }
376     
377     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
378 
379         require(_to != address(0));
380         require(_amount <= balances[_from]);
381         require(_amount <= allowed[_from][msg.sender]);
382         
383         balances[_from] = balances[_from].sub(_amount);
384         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
385         balances[_to] = balances[_to].add(_amount);
386         emit Transfer(_from, _to, _amount);
387         return true;
388     }
389     
390     
391     function approve(address _spender, uint256 _value) public returns (bool success) {
392         // mitigates the ERC20 spend/approval race condition
393         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
394         allowed[msg.sender][_spender] = _value;
395         emit Approval(msg.sender, _spender, _value);
396         return true;
397     }
398     
399     function allowance(address _owner, address _spender) constant public returns (uint256) {
400         return allowed[_owner][_spender];
401     }
402     
403     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
404         AltcoinToken t = AltcoinToken(tokenAddress);
405         uint bal = t.balanceOf(who);
406         return bal;
407     }
408     
409     function withdraw() onlyOwner public {
410         address myAddress = this;
411         uint256 etherBalance = myAddress.balance;
412         owner.transfer(etherBalance);
413     }
414     
415     function burn(uint256 _amount) onlyOwner public {
416         balances[owner] = balances[owner].sub(_amount);
417         totalSupply = totalSupply.sub(_amount);
418         totalDistributed = totalDistributed.sub(_amount);
419         emit Burn(owner, _amount);
420     }
421     
422   
423     
424     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
425         AltcoinToken token = AltcoinToken(_tokenContract);
426         uint256 amount = token.balanceOf(address(this));
427         return token.transfer(owner, amount);
428     }
429     
430     function dist_privateSale(address _to, uint256 _amount) onlyOwner public {
431 		
432 		require(_amount <= balances[owner]);
433 		require(_amount > 0);
434 		
435 		totalDistributed = totalDistributed.add(_amount);        
436         balances[_to] = balances[_to].add(_amount);
437         balances[owner] = balances[owner].sub(_amount);
438         emit Distr(_to, _amount);
439         emit Transfer(address(0), _to, _amount);
440         tAmount = 0;
441 	}
442 	
443 	function dist_airdrop(address _to, uint256 _amount) onlyOwner public {		
444 		require(_amount <= balances[storageAirdrop]);
445 		require(_amount > 0);
446         balances[_to] = balances[_to].add(_amount);
447         balances[storageAirdrop] = balances[storageAirdrop].sub(_amount);
448         emit Airdrop(_to, _amount, balances[_to]);
449         emit Transfer(address(0), _to, _amount);
450 	}
451 	
452 	function dist_multiple_airdrop(address[] _participants, uint256 _amount) onlyOwner public {
453 		tAmount = 0;
454 		
455 		for ( i = 0; i < _participants.length; i++){
456 			tAmount = tAmount.add(_amount);
457 		}
458 		
459 		require(tAmount <= balances[storageAirdrop]);
460 		
461 		for ( i = 0; i < _participants.length; i++){
462 			dist_airdrop(_participants[i], _amount);
463 		}
464 		
465 		tAmount = 0;
466 	}    
467     
468     function dist_developer(address _to, uint256 _amount) onlyOwner public {
469 		require(_amount <= balances[storageDeveloper]);
470 		require(_amount > 0);
471 		balances[_to] = balances[_to].add(_amount);
472         balances[storageDeveloper] = balances[storageDeveloper].sub(_amount);
473         emit Distr(_to, _amount);
474         emit Transfer(address(0), _to, _amount);
475         tAmount = 0;
476 	}
477 	
478     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
479         return ERC20Interface(tokenAddress).transfer(owner, tokens);
480     }
481     
482     
483 }