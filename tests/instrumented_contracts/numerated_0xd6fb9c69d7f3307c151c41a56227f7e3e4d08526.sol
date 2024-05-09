1 pragma solidity 0.4.24;
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
100 contract COBABURN is ERC20, Owned {
101     
102     using SafeMath for uint256;
103     address owner = msg.sender;
104 		
105     mapping (address => uint256) balances;
106     mapping (address => mapping (address => uint256)) allowed;    
107 
108     string public constant name = "COBABURN";
109     string public constant symbol = "CBB";
110     uint public constant decimals = 8;
111     
112     uint256 public totalSupply =  2000000000000000000;
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
124     // saleable 75%
125     uint256 public constant totalIco = 1500000000000000000;
126     uint256 public totalIcoDist = 0;
127     address storageIco = owner;
128     
129     // airdrop 5%
130     uint256 public constant totalAirdrop = 100000000000000000;
131     address private storageAirdrop = 0x74a67ad9b5d4bfdc6813b90250613c1687c89c28;
132     
133     // developer 20%
134     uint256 public constant totalDeveloper = 400000000000000000;
135     address private storageDeveloper = 0x2e05395c947689203ba3cf9f2b0d274a5bb1e5d1;
136     
137     
138     // ---------------------
139     // sale start and price
140     // ---------------------
141     
142     // presale
143 	uint public presaleStartTime = 1536916800; 
144     uint256 public presalePerEth = 1400000000000000;
145     
146     // ico
147     uint public icoStartTime = 1536917400;
148     uint256 public icoPerEth = 1300000000000000;
149     
150     // ico1
151     uint public ico1StartTime = 1536918000;
152     uint256 public ico1PerEth = 1200000000000000;
153     
154     // ico2
155     uint public ico2StartTime = 1536918600;
156     uint256 public ico2PerEth = 1100000000000000;
157     
158     //ico start and end
159     uint public icoOpenTime = presaleStartTime;
160     uint public icoEndTime = 1536919200;
161     
162 	// -----------------------
163 	// events
164 	// -----------------------
165 	
166     event Transfer(address indexed _from, address indexed _to, uint256 _value);
167     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
168     
169     event Distr(address indexed to, uint256 amount);
170     event DistrFinished();
171 
172     event Airdrop(address indexed _owner, uint _amount, uint _balance);
173 
174     event TokensPerEthUpdated(uint _tokensPerEth);
175     
176     event Burn(address indexed burner, uint256 value);
177 	
178 	event Sent(address from, address to, uint amount);
179 	
180 	
181 	// -------------------
182 	// STATE
183 	// ---------------------
184     bool public icoOpen = false; 
185     bool public icoFinished = false;
186     bool public distributionFinished = false;
187     
188     
189     // -----
190     // temp
191     // -----
192     uint256 public tTokenPerEth = 0;
193     uint256 public tAmount = 0;
194     uint i = 0;
195     bool private tIcoOpen = false;
196     
197     // ------------------------------------------------------------------------
198     // Constructor
199     // ------------------------------------------------------------------------
200     constructor() public {        
201         balances[owner] = totalIco;
202         balances[storageAirdrop] = totalAirdrop;
203         balances[storageDeveloper] = totalDeveloper;       
204     }
205     
206     // ------------------------------------------------------------------------
207     // Total supply
208     // ------------------------------------------------------------------------
209     function totalSupply() public constant returns (uint) {
210         return totalSupply  - balances[address(0)];
211     }
212 
213     modifier canDistr() {
214         require(!distributionFinished);
215         _;
216     }
217 	
218 	function startDistribution() onlyOwner canDistr public returns (bool) {
219         icoOpen = true;
220         presaleStartTime = now;
221         icoOpenTime = now;
222         return true;
223     }
224     
225     function finishDistribution() onlyOwner canDistr public returns (bool) {
226         distributionFinished = true;
227         icoFinished = true;
228         emit DistrFinished();
229         return true;
230     }
231     
232     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
233         totalDistributed = totalDistributed.add(_amount);        
234         balances[_to] = balances[_to].add(_amount);
235         balances[owner] = balances[owner].sub(_amount);
236         emit Distr(_to, _amount);
237         emit Transfer(address(0), _to, _amount);
238 
239         return true;
240     }
241 	
242 	function send(address receiver, uint amount) public {
243         if (balances[msg.sender] < amount) return;
244         balances[msg.sender] -= amount;
245         balances[receiver] += amount;
246         emit Sent(msg.sender, receiver, amount);
247     }
248     
249    
250     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
251         tokensPerEth = _tokensPerEth;
252         emit TokensPerEthUpdated(_tokensPerEth);
253     }
254            
255     function () external payable {
256 				
257 		//owner withdraw 
258 		if (msg.sender == owner && msg.value == 0){
259 			withdraw();
260 		}
261 		
262 		if(msg.sender != owner){
263 			if ( now < icoOpenTime ){
264 				revert('ICO does not open yet');
265 			}
266 			
267 			//is Open
268 			if ( ( now >= icoOpenTime ) && ( now <= icoEndTime ) ){
269 				icoOpen = true;
270 			}
271 			
272 			if ( now > icoEndTime ){
273 				icoOpen = false;
274 				icoFinished = true;
275 				distributionFinished = true;
276 			}
277 			
278 			if ( icoFinished == true ){
279 				revert('ICO has finished');
280 			}
281 			
282 			if ( distributionFinished == true ){
283 				revert('Token distribution has finished');
284 			}
285 			
286 			if ( icoOpen == true ){
287 				if ( now >= presaleStartTime && now < icoStartTime){ tTokenPerEth = presalePerEth; }
288 				if ( now >= icoStartTime && now < ico1StartTime){ tTokenPerEth = icoPerEth; }
289 				if ( now >= ico1StartTime && now < ico2StartTime){ tTokenPerEth = ico1PerEth; }
290 				if ( now >= ico2StartTime && now < icoEndTime){ tTokenPerEth = ico2PerEth; }
291 				
292 				tokensPerEth = tTokenPerEth;				
293 				getTokens();
294 				
295 			}
296 		}
297      }
298     
299     function getTokens() payable canDistr  public {
300         uint256 tokens = 0;
301 
302         require( msg.value >= minContribution );
303 
304         require( msg.value > 0 );
305         
306         tokens = tokensPerEth.mul(msg.value) / 1 ether;
307         address investor = msg.sender;
308         
309         
310         if ( icoFinished == true ){
311 			revert('ICO Has Finished');
312 		}
313         
314         if( balances[owner] < tokens ){
315 			revert('Insufficient Token Balance or Sold Out.');
316 		}
317         
318         if (tokens < 0){
319 			revert();
320 		}
321         
322         totalIcoDistributed += tokens;
323         
324         if (tokens > 0) {
325            distr(investor, tokens);           
326         }
327 
328         if (totalIcoDistributed >= totalIco) {
329             distributionFinished = true;
330         }
331     }
332 	
333 	
334     function balanceOf(address _owner) constant public returns (uint256) {
335         return balances[_owner];
336     }
337 
338     // mitigates the ERC20 short address attack
339     modifier onlyPayloadSize(uint size) {
340         assert(msg.data.length >= size + 4);
341         _;
342     }
343     
344     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
345 
346         require(_to != address(0));
347         require(_amount <= balances[msg.sender]);
348         
349         balances[msg.sender] = balances[msg.sender].sub(_amount);
350         balances[_to] = balances[_to].add(_amount);
351         emit Transfer(msg.sender, _to, _amount);
352         return true;
353     }
354     
355     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
356 
357         require(_to != address(0));
358         require(_amount <= balances[_from]);
359         require(_amount <= allowed[_from][msg.sender]);
360         
361         balances[_from] = balances[_from].sub(_amount);
362         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
363         balances[_to] = balances[_to].add(_amount);
364         emit Transfer(_from, _to, _amount);
365         return true;
366     }
367     
368     
369     function approve(address _spender, uint256 _value) public returns (bool success) {
370         // mitigates the ERC20 spend/approval race condition
371         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
372         allowed[msg.sender][_spender] = _value;
373         emit Approval(msg.sender, _spender, _value);
374         return true;
375     }
376     
377     function allowance(address _owner, address _spender) constant public returns (uint256) {
378         return allowed[_owner][_spender];
379     }
380     
381     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
382         AltcoinToken t = AltcoinToken(tokenAddress);
383         uint bal = t.balanceOf(who);
384         return bal;
385     }
386     
387     function withdraw() onlyOwner public {
388         address myAddress = this;
389         uint256 etherBalance = myAddress.balance;
390         owner.transfer(etherBalance);
391     }
392     
393     function burn(uint256 _value) onlyOwner public {
394         require(_value <= balances[owner]);
395         
396         address burner = msg.sender;
397         balances[burner] = balances[burner].sub(_value);
398 		balances[owner] = balances[owner].sub(_value);
399         totalSupply = totalSupply.sub(_value);
400         totalDistributed = totalDistributed.sub(_value);
401         emit Burn(burner, _value);
402     }
403     
404     function burn_all_unsold() onlyOwner public {
405 		burn(balances[owner]);
406     } 
407     
408     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
409         AltcoinToken token = AltcoinToken(_tokenContract);
410         uint256 amount = token.balanceOf(address(this));
411         return token.transfer(owner, amount);
412     }
413     
414     function dist_privateSale(address _to, uint256 _amount) onlyOwner public {
415 		
416 		require(_amount <= balances[owner]);
417 		require(_amount > 0);
418 		
419 		totalDistributed = totalDistributed.add(_amount);        
420         balances[_to] = balances[_to].add(_amount);
421         balances[owner] = balances[owner].sub(_amount);
422         emit Distr(_to, _amount);
423         emit Transfer(address(0), _to, _amount);
424         tAmount = 0;
425 	}
426 	
427 	function dist_airdrop(address _to, uint256 _amount) onlyOwner public {		
428 		require(_amount <= balances[storageAirdrop]);
429 		require(_amount > 0);
430         balances[_to] = balances[_to].add(_amount);
431         balances[storageAirdrop] = balances[storageAirdrop].sub(_amount);
432         emit Airdrop(_to, _amount, balances[_to]);
433         emit Transfer(address(0), _to, _amount);
434 	}
435 	
436 	function dist_multiple_airdrop(address[] _participants, uint256 _amount) onlyOwner public {
437 		tAmount = 0;
438 		
439 		for ( i = 0; i < _participants.length; i++){
440 			tAmount = tAmount.add(_amount);
441 		}
442 		
443 		require(tAmount <= balances[storageAirdrop]);
444 		
445 		for ( i = 0; i < _participants.length; i++){
446 			dist_airdrop(_participants[i], _amount);
447 		}
448 		
449 		tAmount = 0;
450 	}    
451     
452     function dist_developer(address _to, uint256 _amount) onlyOwner public {
453 		require(_amount <= balances[storageDeveloper]);
454 		require(_amount > 0);
455 		balances[_to] = balances[_to].add(_amount);
456         balances[storageDeveloper] = balances[storageDeveloper].sub(_amount);
457         emit Distr(_to, _amount);
458         emit Transfer(address(0), _to, _amount);
459         tAmount = 0;
460 	}
461 	
462     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
463         return ERC20Interface(tokenAddress).transfer(owner, tokens);
464     }
465     
466     
467 }