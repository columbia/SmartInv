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
124    // saleable 70%
125     uint256 public constant totalIco = 3500000000000000000;
126     uint256 public totalIcoDist = 0;
127     address storageIco = owner;
128     
129     // airdrop 10%
130     uint256 public constant totalAirdrop = 500000000000000000;
131     address private storageAirdrop = 0x054Eb74982E38cB57cD131a37dDaDA35ddE08032;
132     
133     // developer 20%
134     uint256 public constant totalDeveloper = 1000000000000000000;
135     address private storageDeveloper = 0x49448F6cB501c66211bbd7E927981489Cdd8B13f;
136     
137     // ---------------------
138     // sale start and price
139     // ---------------------
140     
141     // presale
142 	uint public presaleStartTime = 1537876800; // Monday, 17 December 2018 17:20:00 GMT+05:30
143     uint256 public presalePerEth = 2500000000000000;
144     uint256 public presaleBonusPerEth = 625000000000000;
145     
146     // ico
147     uint public icoStartTime = 1539190800; // Tuesday, 15 January 2019 00:00:00 GMT+05:30
148     uint256 public icoPerEth = 2500000000000000;
149     uint256 public icoBonusPerEth = 500000000000000;
150     
151     // ico1
152     uint public ico1StartTime = 1540573200; // Wednesday, 30 January 2019 00:00:00 GMT+05:30
153     uint256 public ico1PerEth = 2500000000000000;
154     uint256 public ico1BonusPerEth = 375000000000000;
155     
156     // ico2
157     uint public ico2StartTime = 1541955600; // Wednesday, 13 February 2019 00:00:00 GMT+05:30
158     uint256 public ico2PerEth = 2000000000000000;
159     uint256 public ico2BonusPerEth = 250000000000000;
160     
161     //ico start and end
162     uint public icoOpenTime = presaleStartTime;
163     uint public icoEndTime = 1543251600; // Thursday, 28 February 2019 00:00:00 GMT+05:30
164     
165 	// -----------------------
166 	// events
167 	// -----------------------
168 	
169     event Transfer(address indexed _from, address indexed _to, uint256 _value);
170     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
171     
172     event Distr(address indexed to, uint256 amount);
173     event DistrFinished();
174 
175     event Airdrop(address indexed _owner, uint _amount, uint _balance);
176 
177     event TokensPerEthUpdated(uint _tokensPerEth);
178     
179     event Burn(address indexed burner, uint256 value);
180 	
181 	event Sent(address from, address to, uint amount);
182 	
183 	
184 	// -------------------
185 	// STATE
186 	// ---------------------
187     bool public icoOpen = false; 
188     bool public icoFinished = false;
189     bool public distributionFinished = false;
190     
191     
192     // -----
193     // temp
194     // -----
195     uint256 public tTokenPerEth = 0;
196     uint256 public tAmount = 0;
197     uint i = 0;
198     bool private tIcoOpen = false;
199     
200     // ------------------------------------------------------------------------
201     // Constructor
202     // ------------------------------------------------------------------------
203     constructor() public {        
204         balances[owner] = totalIco;
205         balances[storageAirdrop] = totalAirdrop;
206         balances[storageDeveloper] = totalDeveloper;       
207     }
208     
209     // ------------------------------------------------------------------------
210     // Total supply
211     // ------------------------------------------------------------------------
212     function totalSupply() public constant returns (uint) {
213         return totalSupply  - balances[address(0)];
214     }
215 
216     modifier canDistr() {
217         require(!distributionFinished);
218         _;
219     }
220 	
221 	function startDistribution() onlyOwner canDistr public returns (bool) {
222         icoOpen = true;
223         presaleStartTime = now;
224         icoOpenTime = now;
225         return true;
226     }
227     
228     function finishDistribution() onlyOwner canDistr public returns (bool) {
229         distributionFinished = true;
230         icoFinished = true;
231         emit DistrFinished();
232         return true;
233     }
234     
235     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
236         totalDistributed = totalDistributed.add(_amount);        
237         balances[_to] = balances[_to].add(_amount);
238         balances[owner] = balances[owner].sub(_amount);
239         emit Distr(_to, _amount);
240         emit Transfer(address(0), _to, _amount);
241 
242         return true;
243     }
244 	
245 	function send(address receiver, uint amount) public {
246         if (balances[msg.sender] < amount) return;
247         balances[msg.sender] -= amount;
248         balances[receiver] += amount;
249         emit Sent(msg.sender, receiver, amount);
250     }
251     
252    
253     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
254         tokensPerEth = _tokensPerEth;
255         emit TokensPerEthUpdated(_tokensPerEth);
256     }
257            
258     function () external payable {
259 				
260 		//owner withdraw 
261 		if (msg.sender == owner && msg.value == 0){
262 			withdraw();
263 		}
264 		
265 		if(msg.sender != owner){
266 			if ( now < icoOpenTime ){
267 				revert('ICO does not open yet');
268 			}
269 			
270 			//is Open
271 			if ( ( now >= icoOpenTime ) && ( now <= icoEndTime ) ){
272 				icoOpen = true;
273 			}
274 			
275 			if ( now > icoEndTime ){
276 				icoOpen = false;
277 				icoFinished = true;
278 				distributionFinished = true;
279 			}
280 			
281 			if ( icoFinished == true ){
282 				revert('ICO has finished');
283 			}
284 			
285 			if ( distributionFinished == true ){
286 				revert('Token distribution has finished');
287 			}
288 			
289 			if ( icoOpen == true ){
290 				if ( now >= presaleStartTime && now < icoStartTime){ tTokenPerEth = presalePerEth; }
291 				if ( now >= icoStartTime && now < ico1StartTime){ tTokenPerEth = icoPerEth; }
292 				if ( now >= ico1StartTime && now < ico2StartTime){ tTokenPerEth = ico1PerEth; }
293 				if ( now >= ico2StartTime && now < icoEndTime){ tTokenPerEth = ico2PerEth; }
294 				
295 				tokensPerEth = tTokenPerEth;				
296 				getTokens();
297 				
298 			}
299 		}
300      }
301     
302     function getTokens() payable canDistr  public {
303         uint256 tokens = 0;
304 
305         require( msg.value >= minContribution );
306 
307         require( msg.value > 0 );
308         
309         tokens = tokensPerEth.mul(msg.value) / 1 ether;
310         address investor = msg.sender;
311         
312         
313         if ( icoFinished == true ){
314 			revert('ICO Has Finished');
315 		}
316         
317         if( balances[owner] < tokens ){
318 			revert('Insufficient Token Balance or Sold Out.');
319 		}
320         
321         if (tokens < 0){
322 			revert();
323 		}
324         
325         totalIcoDistributed += tokens;
326         
327         if (tokens > 0) {
328            distr(investor, tokens);           
329         }
330 
331         if (totalIcoDistributed >= totalIco) {
332             distributionFinished = true;
333         }
334     }
335 	
336 	
337     function balanceOf(address _owner) constant public returns (uint256) {
338         return balances[_owner];
339     }
340 
341     // mitigates the ERC20 short address attack
342     modifier onlyPayloadSize(uint size) {
343         assert(msg.data.length >= size + 4);
344         _;
345     }
346     
347     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
348 
349         require(_to != address(0));
350         require(_amount <= balances[msg.sender]);
351         
352         balances[msg.sender] = balances[msg.sender].sub(_amount);
353         balances[_to] = balances[_to].add(_amount);
354         emit Transfer(msg.sender, _to, _amount);
355         return true;
356     }
357     
358     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
359 
360         require(_to != address(0));
361         require(_amount <= balances[_from]);
362         require(_amount <= allowed[_from][msg.sender]);
363         
364         balances[_from] = balances[_from].sub(_amount);
365         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
366         balances[_to] = balances[_to].add(_amount);
367         emit Transfer(_from, _to, _amount);
368         return true;
369     }
370     
371     
372     function approve(address _spender, uint256 _value) public returns (bool success) {
373         // mitigates the ERC20 spend/approval race condition
374         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
375         allowed[msg.sender][_spender] = _value;
376         emit Approval(msg.sender, _spender, _value);
377         return true;
378     }
379     
380     function allowance(address _owner, address _spender) constant public returns (uint256) {
381         return allowed[_owner][_spender];
382     }
383     
384     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
385         AltcoinToken t = AltcoinToken(tokenAddress);
386         uint bal = t.balanceOf(who);
387         return bal;
388     }
389     
390     function withdraw() onlyOwner public {
391         address myAddress = this;
392         uint256 etherBalance = myAddress.balance;
393         owner.transfer(etherBalance);
394     }
395     
396     function burn(uint256 _amount) onlyOwner public {
397         balances[owner] = balances[owner].sub(_amount);
398         totalSupply = totalSupply.sub(_amount);
399         totalDistributed = totalDistributed.sub(_amount);
400         emit Burn(owner, _amount);
401     }
402     
403   
404     
405     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
406         AltcoinToken token = AltcoinToken(_tokenContract);
407         uint256 amount = token.balanceOf(address(this));
408         return token.transfer(owner, amount);
409     }
410     
411     function dist_privateSale(address _to, uint256 _amount) onlyOwner public {
412 		
413 		require(_amount <= balances[owner]);
414 		require(_amount > 0);
415 		
416 		totalDistributed = totalDistributed.add(_amount);        
417         balances[_to] = balances[_to].add(_amount);
418         balances[owner] = balances[owner].sub(_amount);
419         emit Distr(_to, _amount);
420         emit Transfer(address(0), _to, _amount);
421         tAmount = 0;
422 	}
423 	
424 	function dist_airdrop(address _to, uint256 _amount) onlyOwner public {		
425 		require(_amount <= balances[storageAirdrop]);
426 		require(_amount > 0);
427         balances[_to] = balances[_to].add(_amount);
428         balances[storageAirdrop] = balances[storageAirdrop].sub(_amount);
429         emit Airdrop(_to, _amount, balances[_to]);
430         emit Transfer(address(0), _to, _amount);
431 	}
432 	
433 	function dist_multiple_airdrop(address[] _participants, uint256 _amount) onlyOwner public {
434 		tAmount = 0;
435 		
436 		for ( i = 0; i < _participants.length; i++){
437 			tAmount = tAmount.add(_amount);
438 		}
439 		
440 		require(tAmount <= balances[storageAirdrop]);
441 		
442 		for ( i = 0; i < _participants.length; i++){
443 			dist_airdrop(_participants[i], _amount);
444 		}
445 		
446 		tAmount = 0;
447 	}    
448     
449     function dist_developer(address _to, uint256 _amount) onlyOwner public {
450 		require(_amount <= balances[storageDeveloper]);
451 		require(_amount > 0);
452 		balances[_to] = balances[_to].add(_amount);
453         balances[storageDeveloper] = balances[storageDeveloper].sub(_amount);
454         emit Distr(_to, _amount);
455         emit Transfer(address(0), _to, _amount);
456         tAmount = 0;
457 	}
458 	
459     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
460         return ERC20Interface(tokenAddress).transfer(owner, tokens);
461     }
462     
463     
464 }