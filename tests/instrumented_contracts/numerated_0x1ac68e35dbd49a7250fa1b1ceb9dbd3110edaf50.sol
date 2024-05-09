1 pragma solidity ^0.4.18;
2 
3 // VikkyToken
4 // Token name: VikkyToken
5 // Symbol: VIK
6 // Decimals: 18
7 // Telegram community: https://t.me/vikkyglobal
8 
9 
10 
11 library SafeMath {
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a * b;
14     assert(a == 0 || c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     uint256 c = a / b;
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 contract ForeignToken {
36     function balanceOf(address _owner) constant public returns (uint256);
37     function transfer(address _to, uint256 _value) public returns (bool);
38 }
39 
40 contract ERC20Basic {
41     uint256 public totalSupply;
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
54 interface Token { 
55     function distr(address _to, uint256 _value) external returns (bool);
56     function totalSupply() constant external returns (uint256 supply);
57     function balanceOf(address _owner) constant external returns (uint256 balance);
58 }
59 
60 contract VikkyToken is ERC20 {
61     
62     using SafeMath for uint256;
63     address owner = msg.sender;
64 
65     mapping (address => uint256) balances;
66     mapping (address => mapping (address => uint256)) allowed; 
67 
68     mapping (address => bool) public airdropClaimed;
69     mapping (address => bool) public refundClaimed;
70     mapping (address => bool) public locked;
71 
72     /* Keep track of Ether contributed and tokens received during Crowdsale */
73   
74     mapping(address => uint) public icoEtherContributed;
75     mapping(address => uint) public icoTokensReceived;
76 
77     string public constant name = "VikkyToken";
78     string public constant symbol = "VIK";
79     uint public constant decimals = 18;
80     
81     uint constant E18 = 10**18;
82     uint constant E6 = 10**6;
83     
84     uint public totalSupply = 1000 * E6 * E18;
85     uint public totalDistributed = 220 * E6 * E18;   //For team + Founder
86     uint public totalRemaining = totalSupply.sub(totalDistributed); //For ICO    
87     uint public tokensPerEth = 20000 * E18; 
88     
89     uint public tokensAirdrop = 266 * E18;
90     uint public tokensClaimedAirdrop = 0;
91     uint public totalDistributedAirdrop = 20 * E6 * E18;   //Airdrop
92 
93     uint public constant MIN_CONTRIBUTION = 1 ether / 100; // 0.01 Ether
94     uint public constant MIN_CONTRIBUTION_PRESALE = 1 ether;
95     uint public constant MAX_CONTRIBUTION = 100 ether;
96     uint public constant MIN_FUNDING_GOAL =  5000 ether; // 5000 ETH
97     /* ICO dates */
98 
99     uint public constant DATE_PRESALE_START = 1523862000; // 04/16/2018 @ 7:00am (UTC)
100     uint public constant DATE_PRESALE_END   = 1524466800; // 04/23/2018 @ 7:00am (UTC)
101 
102     uint public constant DATE_ICO_START = 1524466860; // 04/23/2018 @ 7:01am (UTC)
103     uint public constant DATE_ICO_END   = 1530342000; // 06/30/2018 @ 7:00am (UTC)
104 
105     uint public constant BONUS_PRESALE      = 30;
106     uint public constant BONUS_ICO_ROUND1   = 20;
107     uint public constant BONUS_ICO_ROUND2   = 10;
108     uint public constant BONUS_ICO_ROUND3   = 5;
109     
110     event TokensPerEthUpdated(uint _tokensPerEth);    
111     event Transfer(address indexed _from, address indexed _to, uint256 _value);
112     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
113     event Refund(address indexed _owner, uint _amount, uint _tokens);
114     event Distr(address indexed to, uint256 amount);
115     event DistrFinished();
116     event Airdrop(address indexed _owner, uint _amount, uint _balance);
117     event Burn(address indexed burner, uint256 value);
118     event LockRemoved(address indexed _participant);
119 
120     bool public distributionFinished = false;
121     
122     modifier canDistr() {
123         require(!distributionFinished);
124         _;
125     }
126     
127     modifier onlyOwner() {
128         require(msg.sender == owner);
129         _;
130     }
131     
132     
133     function VikkyToken () public {
134         owner = msg.sender;
135         distr(owner, totalDistributed); //Distribute for owner
136     }
137 
138     // Information functions ------------
139   
140     /* What time is it? */
141   
142     function atNow() public constant returns (uint) {
143         return now;
144     }
145   
146      /* Has the minimum threshold been reached? */
147   
148     function icoThresholdReached() public constant returns (bool thresholdReached) {
149         address myAddress = this;
150         uint256 etherBalance = myAddress.balance;
151         if (etherBalance < MIN_FUNDING_GOAL) return false;
152         return true;
153     }  
154     
155     function transferOwnership(address newOwner) onlyOwner public {
156         if (newOwner != address(0)) {
157             owner = newOwner;
158         }
159     }
160 
161 
162     function finishDistribution() onlyOwner canDistr public returns (bool) {
163         distributionFinished = true;
164         emit DistrFinished();
165         return true;
166     }
167     
168     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
169         totalDistributed = totalDistributed.add(_amount);
170         totalRemaining = totalRemaining.sub(_amount);
171         balances[_to] = balances[_to].add(_amount);
172 
173         icoTokensReceived[msg.sender] = icoTokensReceived[msg.sender].add(_amount);
174             
175         // register Ether            
176         icoEtherContributed[msg.sender] = icoEtherContributed[msg.sender].add(msg.value);
177     
178         // locked
179         locked[msg.sender] = true;
180 
181         emit Distr(_to, _amount);
182         emit Transfer(address(0), _to, _amount);        
183         
184         return true;     
185     }
186     
187     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
188                 
189         require(amount <= totalRemaining);
190         
191         for (uint i = 0; i < addresses.length; i++) {
192             require(amount <= totalRemaining);
193             distr(addresses[i], amount);
194         }
195     
196         if (totalDistributed >= totalSupply) {
197             distributionFinished = true;
198         }
199     }
200     
201     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
202         
203         require(addresses.length == amounts.length);
204         
205         for (uint8 i = 0; i < addresses.length; i++) {
206             require(amounts[i] <= totalRemaining);
207             distr(addresses[i], amounts[i]);
208             
209             if (totalDistributed >= totalSupply) {
210                 distributionFinished = true;
211             }
212         }
213     }
214 
215     function doAirdrop(address _participant, uint airdrop) internal {
216         
217         require( airdrop > 0 );
218         require(tokensClaimedAirdrop < totalDistributedAirdrop);
219 
220         // update balances and token issue volume
221         airdropClaimed[_participant] = true;
222         balances[_participant] = balances[_participant].add(airdrop);
223         totalDistributed = totalDistributed.add(airdrop);
224         totalRemaining = totalRemaining.sub(airdrop);
225         tokensClaimedAirdrop   = tokensClaimedAirdrop.add(airdrop);
226     
227         // log
228         emit Airdrop(_participant, airdrop, balances[_participant]);
229         emit Transfer(address(0), _participant, airdrop);
230     }
231 
232     function adminClaimAirdrop(address _participant, uint airdrop) external {        
233         doAirdrop(_participant, airdrop);
234     }
235 
236     function adminClaimAirdropMultiple(address[] _addresses, uint airdrop) external {        
237         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], airdrop);
238     }
239 
240     function systemClaimAirdropMultiple(address[] _addresses) external {
241         uint airdrop = tokensAirdrop;
242         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], airdrop);
243     }
244 
245  
246     /* Change tokensPerEth before ICO start */
247   
248     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {
249         require( atNow() < DATE_PRESALE_START );
250         tokensPerEth = _tokensPerEth;
251         emit TokensPerEthUpdated(_tokensPerEth);
252     }
253     
254     function () external payable {
255         buyTokens();
256      }
257     
258     function buyTokens() payable canDistr public {
259         uint ts = atNow();
260         bool isPresale = false;
261         bool isIco = false;
262         uint tokens = 0;
263 
264         // minimum contribution
265         require( msg.value >= MIN_CONTRIBUTION );
266 
267         // one address transfer hard cap
268         require( icoEtherContributed[msg.sender].add(msg.value) <= MAX_CONTRIBUTION );
269 
270         // check dates for presale or ICO
271         if (ts > DATE_PRESALE_START && ts < DATE_PRESALE_END) isPresale = true;  
272         if (ts > DATE_ICO_START && ts < DATE_ICO_END) isIco = true;
273         require( isPresale || isIco );
274 
275         // presale cap in Ether
276         if (isPresale) require( msg.value >= MIN_CONTRIBUTION_PRESALE);
277                 
278         address investor = msg.sender;
279         
280         // get baseline number of tokens
281         tokens = tokensPerEth.mul(msg.value) / 1 ether;
282 
283         // apply bonuses (none for last week)
284         if (isPresale) {
285             tokens = tokens.mul(100 + BONUS_PRESALE) / 100;
286         } else if (ts < DATE_ICO_START + 7 days) {
287             // round 1 bonus
288             tokens = tokens.mul(100 + BONUS_ICO_ROUND1) / 100;
289         } else if (ts < DATE_ICO_START + 14 days) {
290             // round 2 bonus
291             tokens = tokens.mul(100 + BONUS_ICO_ROUND2) / 100;
292         } else if (ts < DATE_ICO_START + 21 days) {
293             // round 3 bonus
294             tokens = tokens.mul(100 + BONUS_ICO_ROUND3) / 100;
295         }
296 
297         // ICO token volume cap
298         require( totalDistributed.add(tokens) <= totalRemaining );
299         
300         if (tokens > 0) {
301             distr(investor, tokens);
302         }
303         
304 
305         if (totalDistributed >= totalSupply) {
306             distributionFinished = true;
307         }                
308     }
309 
310     function balanceOf(address _owner) constant public returns (uint256) {
311         return balances[_owner];
312     }
313 
314     // mitigates the ERC20 short address attack
315     modifier onlyPayloadSize(uint size) {
316         assert(msg.data.length >= size + 4);
317         _;
318     }
319 
320     // Lock functions -------------------
321 
322     /* Manage locked */
323 
324     function removeLock(address _participant) public {        
325         locked[_participant] = false;
326         emit LockRemoved(_participant);
327     }
328 
329     function removeLockMultiple(address[] _participants) public {        
330         for (uint i = 0; i < _participants.length; i++) {
331             removeLock(_participants[i]);
332         }
333     }
334     
335     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
336 
337         require(_to != address(0));
338         require(_amount <= balances[msg.sender]);
339         require( locked[msg.sender] == false );
340         require( locked[_to] == false );
341         
342         balances[msg.sender] = balances[msg.sender].sub(_amount);
343         balances[_to] = balances[_to].add(_amount);
344         emit Transfer(msg.sender, _to, _amount);
345         return true;
346     }
347     
348     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
349 
350         require(_to != address(0));
351         require(_amount <= balances[_from]);
352         require(_amount <= allowed[_from][msg.sender]);
353         require( locked[msg.sender] == false );
354         require( locked[_to] == false );
355         
356         balances[_from] = balances[_from].sub(_amount);
357         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
358         balances[_to] = balances[_to].add(_amount);
359         emit Transfer(_from, _to, _amount);
360         return true;
361     }
362     
363     function approve(address _spender, uint256 _value) public returns (bool success) {
364         // mitigates the ERC20 spend/approval race condition
365         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
366         allowed[msg.sender][_spender] = _value;
367         emit Approval(msg.sender, _spender, _value);
368         return true;
369     }
370     
371     function allowance(address _owner, address _spender) constant public returns (uint256) {
372         return allowed[_owner][_spender];
373     }
374     
375     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
376         ForeignToken t = ForeignToken(tokenAddress);
377         uint bal = t.balanceOf(who);
378         return bal;
379     }
380     
381     function withdraw() onlyOwner public {
382         address myAddress = this;
383         uint256 etherBalance = myAddress.balance;
384         owner.transfer(etherBalance);
385     }
386     
387     function burn(uint256 _value) onlyOwner public {
388         require(_value <= balances[msg.sender]);
389         // no need to require value <= totalSupply, since that would imply the
390         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
391 
392         address burner = msg.sender;
393         balances[burner] = balances[burner].sub(_value);
394         totalSupply = totalSupply.sub(_value);
395         totalDistributed = totalDistributed.sub(_value);
396         emit Burn(burner, _value);
397     }
398     
399     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
400         ForeignToken token = ForeignToken(_tokenContract);
401         uint256 amount = token.balanceOf(address(this));
402         return token.transfer(owner, amount);
403     }
404 
405     // External functions ---------------
406 
407     /* Reclaiming of funds by contributors in case of a failed crowdsale */
408     /* (it will fail if account is empty after ownerClawback) */
409 
410     function reclaimFund(address _participant) public {
411         uint tokens; // tokens to destroy
412         uint amount; // refund amount
413 
414         // ico is finished and was not successful
415         require( atNow() > DATE_ICO_END && !icoThresholdReached() );
416 
417         // check if refund has already been claimed
418         require( !refundClaimed[_participant] );
419 
420         // check if there is anything to refund
421         require( icoEtherContributed[_participant] > 0 );
422 
423         // update variables affected by refund
424         tokens = icoTokensReceived[_participant];
425         amount = icoEtherContributed[_participant];
426 
427         balances[_participant] = balances[_participant].sub(tokens);
428         totalDistributed    = totalDistributed.sub(tokens);
429     
430         refundClaimed[_participant] = true;
431 
432         _participant.transfer(amount);
433 
434         // log
435         emit Transfer(_participant, 0x0, tokens);
436         emit Refund(_participant, amount, tokens);
437     }
438 
439     function reclaimFundMultiple(address[] _participants) public {        
440         for (uint i = 0; i < _participants.length; i++) {
441             reclaimFund(_participants[i]);
442         }
443     }
444 }