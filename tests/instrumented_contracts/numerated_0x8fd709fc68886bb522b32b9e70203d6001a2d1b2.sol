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
100 contract ComeAndPay is ERC20, Owned {
101     
102     using SafeMath for uint256;
103     address owner = msg.sender;
104 		
105     mapping (address => uint256) balances;
106     mapping (address => mapping (address => uint256)) allowed;    
107 
108     string public constant name = "ComeAndPay";
109     string public constant symbol = "CNA";
110     uint public constant decimals = 18;
111     
112     uint256 public totalSupply =  100000000000000000000000000000;
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
124    // saleable 60%
125     uint256 public constant totalIco = 60000000000000000000000000000;
126     uint256 public totalIcoDist = 0;
127     address storageIco = owner;
128     
129     // airdrop 20%
130     uint256 public constant totalAirdrop = 20000000000000000000000000000;
131     address private storageAirdrop = 0xa66f406d1803AC6b88E98DdbdcD6Cf43a428be67;
132     
133     // developer 20%
134     uint256 public constant totalDeveloper = 20000000000000000000000000000;
135     address private storageDeveloper = 0x1d7242d6dA0Fca12D2F256462d59F16C38B9c672;
136     
137     // ---------------------
138     // sale start  price and bonus
139     // ---------------------
140     
141     // presale
142 	uint public presaleStartTime = 1544979600; // Monday, 17 December 2018 00:00:00 GMT+07:00
143     uint256 public presalePerEth = 1250000000000000000000;
144     
145     // ico
146     uint public icoStartTime = 1547398800; // Tuesday, 30 January 2019 00:00:00 GMT+07:00
147     uint256 public icoPerEth = 1250000000000000000000;
148     
149     // ico1
150     uint public ico1StartTime = 1547398800; // Wednesday, 30 January 2019 00:00:00 GMT+07:00
151     uint256 public ico1PerEth = 1250000000000000000000;
152     
153     
154     // ico2
155     uint public ico2StartTime = 1548608400; // Wednesday, 13 February 2019 00:00:00 GMT+07:00
156     uint256 public ico2PerEth = 1250000000000000000000;
157     
158     
159     //ico start and end
160     uint public icoOpenTime = presaleStartTime;
161     uint public icoEndTime = 1562950800; // Tuesday, 30 July 2019 00:00:00 GMT+07:00
162     
163 	// -----------------------
164 	// events
165 	// -----------------------
166 	
167     event Transfer(address indexed _from, address indexed _to, uint256 _value);
168     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
169     
170     event Distr(address indexed to, uint256 amount);
171     event DistrFinished();
172 
173     event Airdrop(address indexed _owner, uint _amount, uint _balance);
174 
175     event TokensPerEthUpdated(uint _tokensPerEth);
176     
177     event Burn(address indexed burner, uint256 value);
178 	
179 	event Sent(address from, address to, uint amount);
180 	
181 	
182 	// -------------------
183 	// STATE
184 	// ---------------------
185     bool public icoOpen = false; 
186     bool public icoFinished = false;
187     bool public distributionFinished = false;
188     
189     
190     // -----
191     // temp
192     // -----
193     uint256 public tTokenPerEth = 0;
194     uint256 public tAmount = 0;
195     uint i = 0;
196     bool private tIcoOpen = false;
197     
198     // ------------------------------------------------------------------------
199     // Constructor
200     // ------------------------------------------------------------------------
201     constructor() public {        
202         balances[owner] = totalIco;
203         balances[storageAirdrop] = totalAirdrop;
204         balances[storageDeveloper] = totalDeveloper;       
205     }
206     
207     // ------------------------------------------------------------------------
208     // Total supply
209     // ------------------------------------------------------------------------
210     function totalSupply() public constant returns (uint) {
211         return totalSupply  - balances[address(0)];
212     }
213 
214     modifier canDistr() {
215         require(!distributionFinished);
216         _;
217     }
218 	
219 	function startDistribution() onlyOwner canDistr public returns (bool) {
220         icoOpen = true;
221         presaleStartTime = now;
222         icoOpenTime = now;
223         return true;
224     }
225     
226     function finishDistribution() onlyOwner canDistr public returns (bool) {
227         distributionFinished = true;
228         icoFinished = true;
229         emit DistrFinished();
230         return true;
231     }
232     
233     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
234         totalDistributed = totalDistributed.add(_amount);        
235         balances[_to] = balances[_to].add(_amount);
236         balances[owner] = balances[owner].sub(_amount);
237         emit Distr(_to, _amount);
238         emit Transfer(address(0), _to, _amount);
239 
240         return true;
241     }
242 	
243 	function send(address receiver, uint amount) public {
244         if (balances[msg.sender] < amount) return;
245         balances[msg.sender] -= amount;
246         balances[receiver] += amount;
247         emit Sent(msg.sender, receiver, amount);
248     }
249     
250    
251     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
252         tokensPerEth = _tokensPerEth;
253         emit TokensPerEthUpdated(_tokensPerEth);
254     }
255            
256     function () external payable {
257 				
258 		//owner withdraw 
259 		if (msg.sender == owner && msg.value == 0){
260 			withdraw();
261 		}
262 		
263 		if(msg.sender != owner){
264 			if ( now < icoOpenTime ){
265 				revert('ICO does not open yet');
266 			}
267 			
268 			//is Open
269 			if ( ( now >= icoOpenTime ) && ( now <= icoEndTime ) ){
270 				icoOpen = true;
271 			}
272 			
273 			if ( now > icoEndTime ){
274 				icoOpen = false;
275 				icoFinished = true;
276 				distributionFinished = true;
277 			}
278 			
279 			if ( icoFinished == true ){
280 				revert('ICO has finished');
281 			}
282 			
283 			if ( distributionFinished == true ){
284 				revert('Token distribution has finished');
285 			}
286 			
287 			if ( icoOpen == true ){
288 				if ( now >= presaleStartTime && now < icoStartTime){ tTokenPerEth = presalePerEth; }
289 				if ( now >= icoStartTime && now < ico1StartTime){ tTokenPerEth = icoPerEth; }
290 				if ( now >= ico1StartTime && now < ico2StartTime){ tTokenPerEth = ico1PerEth; }
291 				if ( now >= ico2StartTime && now < icoEndTime){ tTokenPerEth = ico2PerEth; }
292 				
293 				tokensPerEth = tTokenPerEth;				
294 				getTokens();
295 				
296 			}
297 		}
298      }
299     
300     function getTokens() payable canDistr  public {
301         uint256 tokens = 0;
302 
303         require( msg.value >= minContribution );
304 
305         require( msg.value > 0 );
306         
307         tokens = tokensPerEth.mul(msg.value) / 1 ether;
308         address investor = msg.sender;
309         
310         
311         if ( icoFinished == true ){
312 			revert('ICO Has Finished');
313 		}
314         
315         if( balances[owner] < tokens ){
316 			revert('Insufficient Token Balance or Sold Out.');
317 		}
318         
319         if (tokens < 0){
320 			revert();
321 		}
322         
323         totalIcoDistributed += tokens;
324         
325         if (tokens > 0) {
326            distr(investor, tokens);           
327         }
328 
329         if (totalIcoDistributed >= totalIco) {
330             distributionFinished = true;
331         }
332     }
333 	
334 	
335     function balanceOf(address _owner) constant public returns (uint256) {
336         return balances[_owner];
337     }
338 
339     // mitigates the ERC20 short address attack
340     modifier onlyPayloadSize(uint size) {
341         assert(msg.data.length >= size + 4);
342         _;
343     }
344     
345     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
346 
347         require(_to != address(0));
348         require(_amount <= balances[msg.sender]);
349         
350         balances[msg.sender] = balances[msg.sender].sub(_amount);
351         balances[_to] = balances[_to].add(_amount);
352         emit Transfer(msg.sender, _to, _amount);
353         return true;
354     }
355     
356     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
357 
358         require(_to != address(0));
359         require(_amount <= balances[_from]);
360         require(_amount <= allowed[_from][msg.sender]);
361         
362         balances[_from] = balances[_from].sub(_amount);
363         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
364         balances[_to] = balances[_to].add(_amount);
365         emit Transfer(_from, _to, _amount);
366         return true;
367     }
368     
369     
370     function approve(address _spender, uint256 _value) public returns (bool success) {
371         // mitigates the ERC20 spend/approval race condition
372         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
373         allowed[msg.sender][_spender] = _value;
374         emit Approval(msg.sender, _spender, _value);
375         return true;
376     }
377     
378     function allowance(address _owner, address _spender) constant public returns (uint256) {
379         return allowed[_owner][_spender];
380     }
381     
382     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
383         AltcoinToken t = AltcoinToken(tokenAddress);
384         uint bal = t.balanceOf(who);
385         return bal;
386     }
387     
388     function withdraw() onlyOwner public {
389         address myAddress = this;
390         uint256 etherBalance = myAddress.balance;
391         owner.transfer(etherBalance);
392     }
393     
394     function burn(uint256 _amount) onlyOwner public {
395         balances[owner] = balances[owner].sub(_amount);
396         totalSupply = totalSupply.sub(_amount);
397         totalDistributed = totalDistributed.sub(_amount);
398         emit Burn(owner, _amount);
399     }
400     
401   
402     
403     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
404         AltcoinToken token = AltcoinToken(_tokenContract);
405         uint256 amount = token.balanceOf(address(this));
406         return token.transfer(owner, amount);
407     }
408     
409     function dist_privateSale(address _to, uint256 _amount) onlyOwner public {
410 		
411 		require(_amount <= balances[owner]);
412 		require(_amount > 0);
413 		
414 		totalDistributed = totalDistributed.add(_amount);        
415         balances[_to] = balances[_to].add(_amount);
416         balances[owner] = balances[owner].sub(_amount);
417         emit Distr(_to, _amount);
418         emit Transfer(address(0), _to, _amount);
419         tAmount = 0;
420 	}
421 	
422 	function dist_airdrop(address _to, uint256 _amount) onlyOwner public {		
423 		require(_amount <= balances[storageAirdrop]);
424 		require(_amount > 0);
425         balances[_to] = balances[_to].add(_amount);
426         balances[storageAirdrop] = balances[storageAirdrop].sub(_amount);
427         emit Airdrop(_to, _amount, balances[_to]);
428         emit Transfer(address(0), _to, _amount);
429 	}
430 	
431 	function dist_multiple_airdrop(address[] _participants, uint256 _amount) onlyOwner public {
432 		tAmount = 0;
433 		
434 		for ( i = 0; i < _participants.length; i++){
435 			tAmount = tAmount.add(_amount);
436 		}
437 		
438 		require(tAmount <= balances[storageAirdrop]);
439 		
440 		for ( i = 0; i < _participants.length; i++){
441 			dist_airdrop(_participants[i], _amount);
442 		}
443 		
444 		tAmount = 0;
445 	}    
446     
447     function dist_developer(address _to, uint256 _amount) onlyOwner public {
448 		require(_amount <= balances[storageDeveloper]);
449 		require(_amount > 0);
450 		balances[_to] = balances[_to].add(_amount);
451         balances[storageDeveloper] = balances[storageDeveloper].sub(_amount);
452         emit Distr(_to, _amount);
453         emit Transfer(address(0), _to, _amount);
454         tAmount = 0;
455 	}
456 	
457     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
458         return ERC20Interface(tokenAddress).transfer(owner, tokens);
459     }
460     
461     
462 }