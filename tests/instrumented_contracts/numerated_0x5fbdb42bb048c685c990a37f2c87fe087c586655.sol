1 /**
2  *Submitted for verification at Etherscan.io on 2019-01-04
3 */
4 
5 pragma solidity 0.4.24;
6 
7 
8 library SafeMath {
9 
10     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11         if (a == 0) {
12             return 0;
13         }
14         c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18 
19 
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         return a / b;
22     }
23 
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
32         c = a + b;
33         assert(c >= a);
34         return c;
35     }
36 }
37 
38 contract AltcoinToken {
39     function balanceOf(address _owner) constant public returns (uint256);
40     function transfer(address _to, uint256 _value) public returns (bool);
41 }
42 
43 contract ERC20Basic {
44     uint256 public totalSupply;
45     function totalSupply() public constant returns (uint);
46     function balanceOf(address who) public constant returns (uint256);
47     function transfer(address to, uint256 value) public returns (bool);
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 
51 contract ERC20 is ERC20Basic {
52     function allowance(address owner, address spender) public constant returns (uint256);
53     function transferFrom(address from, address to, uint256 value) public returns (bool);
54     function approve(address spender, uint256 value) public returns (bool);
55     event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 
59 contract ERC20Interface {
60     function totalSupply() public constant returns (uint);
61     function balanceOf(address tokenOwner) public constant returns (uint balance);
62     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
63     function transfer(address to, uint tokens) public returns (bool success);
64     function approve(address spender, uint tokens) public returns (bool success);
65     function transferFrom(address from, address to, uint tokens) public returns (bool success);
66 
67     event Transfer(address indexed from, address indexed to, uint tokens);
68     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
69 }
70 
71 
72 
73 contract ApproveAndCallFallBack {
74     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
75 }
76 
77 
78 contract Owned {
79     address public owner;
80     address public newOwner;
81 
82     event OwnershipTransferred(address indexed _from, address indexed _to);
83 
84     constructor() public {
85         owner = msg.sender;
86     }
87 
88     modifier onlyOwner {
89         require(msg.sender == owner);
90         _;
91     }
92 
93     function transferOwnership(address _newOwner) public onlyOwner {
94         newOwner = _newOwner;
95     }
96     function acceptOwnership() public {
97         require(msg.sender == newOwner);
98         emit OwnershipTransferred(owner, newOwner);
99         owner = newOwner;
100         newOwner = address(0);
101     }
102 }
103 
104 contract XENON is ERC20, Owned {
105     
106     using SafeMath for uint256;
107     address owner = msg.sender;
108 		
109     mapping (address => uint256) balances;
110     mapping (address => mapping (address => uint256)) allowed;    
111 
112     string public constant name = "XENON";
113     string public constant symbol = "XEN";
114     uint public constant decimals = 8;
115     
116     uint256 public totalSupply =  1000000000000000000;
117     uint256 public totalDistributed = 0; 
118     uint256 public totalIcoDistributed = 0;
119     uint256 public constant minContribution = 1 ether / 125000; // 0.002 USD
120 	
121 	
122 	uint256 public tokensPerEth = 125000;
123 	
124 	// ------------------------------
125     // Token Distribution and Address
126     // ------------------------------
127     
128    // saleable 40%
129     uint256 public constant totalIco = 600000000000000000;
130     uint256 public totalIcoDist = 0;
131     address storageIco = owner;
132     
133     // Airdrop (Foundation) 20%
134     uint256 public constant totalAirdrop = 200000000000000000;
135     address private storageAirdrop = 0xA8173eF0F163aF69Fa4f6AF7a02F0A35A9fbe82c;
136     
137     // Developer (Team)   20%
138    uint256 public constant totalDeveloper = 200000000000000000;
139     address private storageDeveloper = 0xB28bf4fe36df8e2C798Da4599c2374BD31016a0F;
140     
141     // Markating 8%
142    /** uint256 public constant totalAirdrop = 80000000000000000;
143     address private storageAirdrop = 0x3055cB0aC5c06d270F0cEF9a42AfDa7Abe59060A;*/
144     
145     // Advisors   5%
146    /** uint256 public constant totalDeveloper = 50000000000000000;
147     address private storageDeveloper = 0x3183C451C0E4D8bEba13F5FE94b5d146c20C50Ca;*/
148     
149     // Eco System 5%
150    /** uint256 public constant totalAirdrop = 50000000000000000;
151     address private storageAirdrop = 0x817fd7253129Fd9474E8374574EB77C4bc0B494c;*/
152     
153     // Community   2%
154    /** uint256 public constant totalDeveloper = 20000000000000000;
155     address private storageDeveloper = 0x6D8853Cf85055ACEC9805CE8e35D5c816498B5C0;*/
156     
157     // ---------------------
158     // sale start  price and bonus
159     // ---------------------
160     
161     // presale
162 	uint public presaleStartTime = 1544979600; // Monday, 17 December 2018 00:00:00 GMT+07:00
163     uint256 public presalePerEth = 12500000000000;
164     
165     // ico
166     uint public icoStartTime = 1564938000; // Monday, 5 August 2019 00:00:00 GMT+07:00
167     uint256 public icoPerEth = 8500000000000;
168    
169     
170     //ico start and end
171     uint public icoOpenTime = presaleStartTime;
172     uint public icoEndTime = 1567184400; // Saturday, 31 August 2019 00:00:00 GMT+07:00
173     
174 	// -----------------------
175 	// events
176 	// -----------------------
177 	
178     event Transfer(address indexed _from, address indexed _to, uint256 _value);
179     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
180     
181     event Distr(address indexed to, uint256 amount);
182     event DistrFinished();
183 
184     event Airdrop(address indexed _owner, uint _amount, uint _balance);
185 
186     event TokensPerEthUpdated(uint _tokensPerEth);
187     
188     event Burn(address indexed burner, uint256 value);
189 	
190 	event Sent(address from, address to, uint amount);
191 	
192 	
193 	// -------------------
194 	// STATE
195 	// ---------------------
196     bool public icoOpen = false; 
197     bool public icoFinished = false;
198     bool public distributionFinished = false;
199     
200     
201     // -----
202     // temp
203     // -----
204     uint256 public tTokenPerEth = 0;
205     uint256 public tAmount = 0;
206     uint i = 0;
207     bool private tIcoOpen = false;
208     
209     // ------------------------------------------------------------------------
210     // Constructor
211     // ------------------------------------------------------------------------
212     constructor() public {        
213         balances[owner] = totalIco;
214         balances[storageAirdrop] = totalAirdrop;
215         balances[storageDeveloper] = totalDeveloper;       
216     }
217     
218     // ------------------------------------------------------------------------
219     // Total supply
220     // ------------------------------------------------------------------------
221     function totalSupply() public constant returns (uint) {
222         return totalSupply  - balances[address(0)];
223     }
224 
225     modifier canDistr() {
226         require(!distributionFinished);
227         _;
228     }
229 	
230 	function startDistribution() onlyOwner canDistr public returns (bool) {
231         icoOpen = true;
232         presaleStartTime = now;
233         icoOpenTime = now;
234         return true;
235     }
236     
237     function finishDistribution() onlyOwner canDistr public returns (bool) {
238         distributionFinished = true;
239         icoFinished = true;
240         emit DistrFinished();
241         return true;
242     }
243     
244     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
245         totalDistributed = totalDistributed.add(_amount);        
246         balances[_to] = balances[_to].add(_amount);
247         balances[owner] = balances[owner].sub(_amount);
248         emit Distr(_to, _amount);
249         emit Transfer(address(0), _to, _amount);
250 
251         return true;
252     }
253 	
254 	function send(address receiver, uint amount) public {
255         if (balances[msg.sender] < amount) return;
256         balances[msg.sender] -= amount;
257         balances[receiver] += amount;
258         emit Sent(msg.sender, receiver, amount);
259     }
260     
261    
262     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
263         tokensPerEth = _tokensPerEth;
264         emit TokensPerEthUpdated(_tokensPerEth);
265     }
266            
267     function () external payable {
268 				
269 		//owner withdraw 
270 		if (msg.sender == owner && msg.value == 0){
271 			withdraw();
272 		}
273 		
274 		if(msg.sender != owner){
275 			if ( now < icoOpenTime ){
276 				revert('ICO does not open yet');
277 			}
278 			
279 			//is Open
280 			if ( ( now >= icoOpenTime ) && ( now <= icoEndTime ) ){
281 				icoOpen = true;
282 			}
283 			
284 			if ( now > icoEndTime ){
285 				icoOpen = false;
286 				icoFinished = true;
287 				distributionFinished = true;
288 			}
289 			
290 			if ( icoFinished == true ){
291 				revert('ICO has finished');
292 			}
293 			
294 			if ( distributionFinished == true ){
295 				revert('Token distribution has finished');
296 			}
297 			
298 			if ( icoOpen == true ){
299 				if ( now >= presaleStartTime && now < icoStartTime){ tTokenPerEth = presalePerEth; }
300 			
301 				
302 				tokensPerEth = tTokenPerEth;				
303 				getTokens();
304 				
305 			}
306 		}
307      }
308     
309     function getTokens() payable canDistr  public {
310         uint256 tokens = 0;
311 
312         require( msg.value >= minContribution );
313 
314         require( msg.value > 0 );
315         
316         tokens = tokensPerEth.mul(msg.value) / 1 ether;
317         address investor = msg.sender;
318         
319         
320         if ( icoFinished == true ){
321 			revert('ICO Has Finished');
322 		}
323         
324         if( balances[owner] < tokens ){
325 			revert('Insufficient Token Balance or Sold Out.');
326 		}
327         
328         if (tokens < 0){
329 			revert();
330 		}
331         
332         totalIcoDistributed += tokens;
333         
334         if (tokens > 0) {
335            distr(investor, tokens);           
336         }
337 
338         if (totalIcoDistributed >= totalIco) {
339             distributionFinished = true;
340         }
341     }
342 	
343 	
344     function balanceOf(address _owner) constant public returns (uint256) {
345         return balances[_owner];
346     }
347 
348     // mitigates the ERC20 short address attack
349     modifier onlyPayloadSize(uint size) {
350         assert(msg.data.length >= size + 4);
351         _;
352     }
353     
354     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
355 
356         require(_to != address(0));
357         require(_amount <= balances[msg.sender]);
358         
359         balances[msg.sender] = balances[msg.sender].sub(_amount);
360         balances[_to] = balances[_to].add(_amount);
361         emit Transfer(msg.sender, _to, _amount);
362         return true;
363     }
364     
365     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
366 
367         require(_to != address(0));
368         require(_amount <= balances[_from]);
369         require(_amount <= allowed[_from][msg.sender]);
370         
371         balances[_from] = balances[_from].sub(_amount);
372         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
373         balances[_to] = balances[_to].add(_amount);
374         emit Transfer(_from, _to, _amount);
375         return true;
376     }
377     
378     
379     function approve(address _spender, uint256 _value) public returns (bool success) {
380         // mitigates the ERC20 spend/approval race condition
381         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
382         allowed[msg.sender][_spender] = _value;
383         emit Approval(msg.sender, _spender, _value);
384         return true;
385     }
386     
387     function allowance(address _owner, address _spender) constant public returns (uint256) {
388         return allowed[_owner][_spender];
389     }
390     
391     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
392         AltcoinToken t = AltcoinToken(tokenAddress);
393         uint bal = t.balanceOf(who);
394         return bal;
395     }
396     
397     function withdraw() onlyOwner public {
398         address myAddress = this;
399         uint256 etherBalance = myAddress.balance;
400         owner.transfer(etherBalance);
401     }
402     
403     function burn(uint256 _amount) onlyOwner public {
404         balances[owner] = balances[owner].sub(_amount);
405         totalSupply = totalSupply.sub(_amount);
406         totalDistributed = totalDistributed.sub(_amount);
407         emit Burn(owner, _amount);
408     }
409     
410   
411     
412     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
413         AltcoinToken token = AltcoinToken(_tokenContract);
414         uint256 amount = token.balanceOf(address(this));
415         return token.transfer(owner, amount);
416     }
417     
418     function dist_privateSale(address _to, uint256 _amount) onlyOwner public {
419 		
420 		require(_amount <= balances[owner]);
421 		require(_amount > 0);
422 		
423 		totalDistributed = totalDistributed.add(_amount);        
424         balances[_to] = balances[_to].add(_amount);
425         balances[owner] = balances[owner].sub(_amount);
426         emit Distr(_to, _amount);
427         emit Transfer(address(0), _to, _amount);
428         tAmount = 0;
429 	}
430 	
431 	function dist_airdrop(address _to, uint256 _amount) onlyOwner public {		
432 		require(_amount <= balances[storageAirdrop]);
433 		require(_amount > 0);
434         balances[_to] = balances[_to].add(_amount);
435         balances[storageAirdrop] = balances[storageAirdrop].sub(_amount);
436         emit Airdrop(_to, _amount, balances[_to]);
437         emit Transfer(address(0), _to, _amount);
438 	}
439 	
440 	function dist_multiple_airdrop(address[] _participants, uint256 _amount) onlyOwner public {
441 		tAmount = 0;
442 		
443 		for ( i = 0; i < _participants.length; i++){
444 			tAmount = tAmount.add(_amount);
445 		}
446 		
447 		require(tAmount <= balances[storageAirdrop]);
448 		
449 		for ( i = 0; i < _participants.length; i++){
450 			dist_airdrop(_participants[i], _amount);
451 		}
452 		
453 		tAmount = 0;
454 	}    
455     
456     function dist_developer(address _to, uint256 _amount) onlyOwner public {
457 		require(_amount <= balances[storageDeveloper]);
458 		require(_amount > 0);
459 		balances[_to] = balances[_to].add(_amount);
460         balances[storageDeveloper] = balances[storageDeveloper].sub(_amount);
461         emit Distr(_to, _amount);
462         emit Transfer(address(0), _to, _amount);
463         tAmount = 0;
464 	}
465 	
466     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
467         return ERC20Interface(tokenAddress).transfer(owner, tokens);
468     }
469     
470     
471 }