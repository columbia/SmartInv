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
100 contract COBA2 is ERC20, Owned {
101     
102     using SafeMath for uint256;
103     address owner = msg.sender;
104 		
105     mapping (address => uint256) balances;
106     mapping (address => mapping (address => uint256)) allowed;    
107 
108     string public constant name = "COBA2";
109     string public constant symbol = "CB2";
110     uint public constant decimals = 8;
111     
112     uint256 public totalSupply =  2000000000000000000;
113     uint256 public totalDistributed = 0; 
114     uint256 public totalIcoDistributed = 0;
115     uint256 public constant minContribution = 1 ether / 100; // 0.01 Eth
116 	
117 	uint256 public tokensPerEth = 0;
118 	
119 	// ------------------------------
120     // Token Distribution and Address
121     // ------------------------------
122     
123     // saleable 75%
124     uint256 public constant totalIco = 1500000000000000000;
125     uint256 public totalIcoDist = 0;
126     address storageIco = owner;
127     
128     // airdrop 5%
129     uint256 public constant totalAirdrop = 100000000000000000;
130     address storageAirdrop = 0xd06EA246FDb6Eb08C61bc0fe5Ba3865792c02202;
131     
132     // developer 20%
133     uint256 public constant totalDeveloper = 400000000000000000;
134     address storageDev = 0x341a7EF6CccE6302Da31b186597ae4144575f102;
135     
136     
137     // ---------------------
138     // sale start and price
139     // ---------------------
140     
141     // presale
142 	uint public presaleStartTime = 1536853800; // 20.30.00
143     uint256 public presalePerEth = 1400000000000000;
144     
145     // ico
146     uint public icoStartTime = 1536854400;
147     uint256 public icoPerEth = 1300000000000000;
148     
149     // ico1
150     uint public ico1StartTime = 1536855000;
151     uint256 public ico1PerEth = 1200000000000000;
152     
153     // ico2
154     uint public ico2StartTime = 1536855600;
155     uint256 public ico2PerEth = 1100000000000000;
156     
157     //ico start and end
158     uint public icoOpenTime = presaleStartTime;
159     uint public icoEndTime = 1536856200;
160     
161 	// -----------------------
162 	// events
163 	// -----------------------
164 	
165     event Transfer(address indexed _from, address indexed _to, uint256 _value);
166     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
167     
168     event Distr(address indexed to, uint256 amount);
169     event DistrFinished();
170 
171     event Airdrop(address indexed _owner, uint _amount, uint _balance);
172 
173     event TokensPerEthUpdated(uint _tokensPerEth);
174     
175     event Burn(address indexed burner, uint256 value);
176 	
177 	event Sent(address from, address to, uint amount);
178 	
179 	
180 	// -------------------
181 	// STATE
182 	// ---------------------
183     bool public icoOpen = false; // allow to buy
184     bool public icoFinished = false; // stop buy
185     bool public distributionFinished = false;
186     
187     
188     // -----
189     // temp
190     // -----
191     uint256 public tTokenPerEth = 0;
192     bool public tIcoOpen = false;
193     
194     // ------------------------------------------------------------------------
195     // Constructor
196     // ------------------------------------------------------------------------
197     constructor() public {        
198         balances[owner] = totalSupply;
199         Transfer(address(0), owner, totalSupply);        
200     }
201     
202     // ------------------------------------------------------------------------
203     // Total supply
204     // ------------------------------------------------------------------------
205     function totalSupply() public constant returns (uint) {
206         return totalSupply  - balances[address(0)];
207     }
208 
209     modifier canDistr() {
210         require(!distributionFinished);
211         _;
212     }
213 
214     function finishDistribution() onlyOwner canDistr public returns (bool) {
215         distributionFinished = true;
216         emit DistrFinished();
217         return true;
218     }
219     
220     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
221         totalDistributed = totalDistributed.add(_amount);        
222         balances[_to] = balances[_to].add(_amount);
223         balances[owner] = balances[owner].sub(_amount);
224         emit Distr(_to, _amount);
225         emit Transfer(address(0), _to, _amount);
226 
227         return true;
228     }
229 	
230 	function send(address receiver, uint amount) public {
231         if (balances[msg.sender] < amount) return;
232         balances[msg.sender] -= amount;
233         balances[receiver] += amount;
234         emit Sent(msg.sender, receiver, amount);
235     }
236     
237     function doAirdrop(address _participant, uint _amount) internal {
238 
239         require( _amount > 0 );      
240 
241         require( totalDistributed < totalSupply );
242         
243         balances[_participant] = balances[_participant].add(_amount);
244         totalDistributed = totalDistributed.add(_amount);
245 
246         if (totalDistributed >= totalSupply) {
247             distributionFinished = true;
248         }
249 
250         // log
251         emit Airdrop(_participant, _amount, balances[_participant]);
252         emit Transfer(address(0), _participant, _amount);
253     }
254 
255     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
256         doAirdrop(_participant, _amount);
257     }
258 
259     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
260         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
261     }
262 
263     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
264         tokensPerEth = _tokensPerEth;
265         emit TokensPerEthUpdated(_tokensPerEth);
266     }
267            
268     function () external payable {
269 				
270 		//owner withdraw 
271 		if (msg.sender == owner && msg.value == 0){
272 			withdraw();
273 		}
274 		
275 		if(msg.sender != owner){
276 			if ( now < icoOpenTime ){
277 				revert('ICO does not open yet');
278 			}
279 			
280 			//is Open
281 			if ( ( now >= icoOpenTime ) && ( now <= icoEndTime ) ){
282 				icoOpen = true;
283 			}
284 			
285 			if ( now > icoEndTime ){
286 				icoOpen = false;
287 				icoFinished = true;
288 				distributionFinished = true;
289 			}
290 			
291 			if ( icoFinished == true ){
292 				revert('ICO has finished');
293 			}
294 			
295 			if ( distributionFinished == true ){
296 				revert('Token distribution has finished');
297 			}
298 			
299 			if ( icoOpen == true ){
300 				if ( now >= presaleStartTime && now < icoStartTime){ tTokenPerEth = presalePerEth; }
301 				if ( now >= icoStartTime && now < ico1StartTime){ tTokenPerEth = icoPerEth; }
302 				if ( now >= ico1StartTime && now < ico2StartTime){ tTokenPerEth = ico1PerEth; }
303 				if ( now >= ico2StartTime && now < icoEndTime){ tTokenPerEth = ico2PerEth; }
304 				
305 				tokensPerEth = tTokenPerEth;				
306 				getTokens();
307 				
308 			}
309 		}
310      }
311     
312     function getTokens() payable canDistr  public {
313         uint256 tokens = 0;
314 
315         require( msg.value >= minContribution );
316 
317         require( msg.value > 0 );
318         
319         tokens = tokensPerEth.mul(msg.value) / 1 ether;
320         address investor = msg.sender;
321         
322         
323         if ( icoFinished == true ){
324 			revert('ICO Has Finished');
325 		}
326         
327         if( balances[owner] < tokens ){
328 			revert('Insufficient Token Balance or Sold Out.');
329 		}
330         
331         if (tokens < 0){
332 			revert();
333 		}
334         
335         totalIcoDistributed += tokens;
336         
337         if (tokens > 0) {
338            distr(investor, tokens);           
339         }
340 
341         if (totalIcoDistributed >= totalIco) {
342             distributionFinished = true;
343         }
344     }
345 	
346 	
347     function balanceOf(address _owner) constant public returns (uint256) {
348         return balances[_owner];
349     }
350 
351     // mitigates the ERC20 short address attack
352     modifier onlyPayloadSize(uint size) {
353         assert(msg.data.length >= size + 4);
354         _;
355     }
356     
357     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
358 
359         require(_to != address(0));
360         require(_amount <= balances[msg.sender]);
361         
362         balances[msg.sender] = balances[msg.sender].sub(_amount);
363         balances[_to] = balances[_to].add(_amount);
364         emit Transfer(msg.sender, _to, _amount);
365         return true;
366     }
367     
368     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
369 
370         require(_to != address(0));
371         require(_amount <= balances[_from]);
372         require(_amount <= allowed[_from][msg.sender]);
373         
374         balances[_from] = balances[_from].sub(_amount);
375         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
376         balances[_to] = balances[_to].add(_amount);
377         emit Transfer(_from, _to, _amount);
378         return true;
379     }
380     
381     
382     function approve(address _spender, uint256 _value) public returns (bool success) {
383         // mitigates the ERC20 spend/approval race condition
384         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
385         allowed[msg.sender][_spender] = _value;
386         emit Approval(msg.sender, _spender, _value);
387         return true;
388     }
389     
390     function allowance(address _owner, address _spender) constant public returns (uint256) {
391         return allowed[_owner][_spender];
392     }
393     
394     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
395         AltcoinToken t = AltcoinToken(tokenAddress);
396         uint bal = t.balanceOf(who);
397         return bal;
398     }
399     
400     function withdraw() onlyOwner public {
401         address myAddress = this;
402         uint256 etherBalance = myAddress.balance;
403         owner.transfer(etherBalance);
404     }
405     
406     function burn(uint256 _value) onlyOwner public {
407         require(_value <= balances[msg.sender]);
408         
409         address burner = msg.sender;
410         balances[burner] = balances[burner].sub(_value);
411         totalSupply = totalSupply.sub(_value);
412         totalDistributed = totalDistributed.sub(_value);
413         emit Burn(burner, _value);
414     }
415     
416     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
417         AltcoinToken token = AltcoinToken(_tokenContract);
418         uint256 amount = token.balanceOf(address(this));
419         return token.transfer(owner, amount);
420     }
421     
422     
423     
424     // ------------------------------------------------------------------------
425     // Owner can transfer out any accidentally sent ERC20 tokens
426     // ------------------------------------------------------------------------
427     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
428         return ERC20Interface(tokenAddress).transfer(owner, tokens);
429     }
430     
431     
432 }