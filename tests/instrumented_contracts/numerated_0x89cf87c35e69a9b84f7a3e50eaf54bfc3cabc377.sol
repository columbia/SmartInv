1 pragma solidity ^0.4.22;
2 
3 // GetPaid Token Project Updated
4 
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a / b;
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract ForeignToken {
30     function balanceOf(address _owner) constant public returns (uint256);
31     function transfer(address _to, uint256 _value) public returns (bool);
32 }
33 
34 contract ERC20Basic {
35     uint256 public totalSupply;
36     function balanceOf(address who) public constant returns (uint256);
37     function transfer(address to, uint256 value) public returns (bool);
38     event Transfer(address indexed from, address indexed to, uint256 value);
39 }
40 
41 contract ERC20 is ERC20Basic {
42     function allowance(address owner, address spender) public constant returns (uint256);
43     function transferFrom(address from, address to, uint256 value) public returns (bool);
44     function approve(address spender, uint256 value) public returns (bool);
45     event Approval(address indexed owner, address indexed spender, uint256 value);
46 }
47 
48 interface Token { 
49     function distr(address _to, uint256 _value) external returns (bool);
50     function totalSupply() constant external returns (uint256 supply);
51     function balanceOf(address _owner) constant external returns (uint256 balance);
52 }
53 
54 contract GetPaidToken is ERC20 {
55 
56   
57     using SafeMath for uint256;
58     address owner = msg.sender;
59 
60     mapping (address => uint256) balances;
61     mapping (address => mapping (address => uint256)) allowed;
62     mapping (address => bool) public blacklist;
63 
64     string public constant name = "GetPaid";
65     string public constant symbol = "GPaid";
66     uint public constant decimals = 18;
67     
68     uint256 public totalSupply = 30000000000e18;
69     
70     uint256 public totalDistributed = 0;
71 
72     uint256 public totalValue = 0;
73     
74     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
75     
76     uint256 public value = 200000e18;
77 
78     uint256 public tokensPerEth = 20000000e18;
79 
80     uint256 public constant minContribution = 1 ether / 100; // 0.01 Eth
81 
82     uint256 public constant maxTotalValue = 15000000000e18;
83 
84 
85 
86     event Transfer(address indexed _from, address indexed _to, uint256 _value);
87     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
88     
89     event Distr(address indexed to, uint256 amount);
90     event Distr0(address indexed to, uint256 amount);
91     event DistrFinished();
92     event ZeroEthFinished();
93 
94     event Airdrop(address indexed _owner, uint _amount, uint _balance);
95 
96     event TokensPerEthUpdated(uint _tokensPerEth);
97     
98     event Burn(address indexed burner, uint256 value);
99 
100     bool public distributionFinished = false;
101 
102     bool public zeroDistrFinished = false;
103     
104 
105     modifier canDistr() {
106         require(!distributionFinished);
107         _;
108     }
109     
110     modifier onlyOwner() {
111         require(msg.sender == owner);
112         _;
113     }
114     
115     modifier onlyWhitelist() {
116         require(blacklist[msg.sender] == false);
117         _;
118     }
119     
120     
121     function transferOwnership(address newOwner) onlyOwner public {
122         if (newOwner != address(0)) {
123             owner = newOwner;
124         }
125     }
126     
127     function finishZeroDistribution() onlyOwner canDistr public returns (bool) {
128         zeroDistrFinished = true;
129         emit ZeroEthFinished();
130         return true;
131     }
132 
133     function finishDistribution() onlyOwner canDistr public returns (bool) {
134         distributionFinished = true;
135         emit DistrFinished();
136         return true;
137     }
138 
139     function distr0(address _to, uint256 _amount) canDistr private returns (bool) {
140         require( totalValue < maxTotalValue );
141         totalDistributed = totalDistributed.add(_amount);
142         totalValue = totalValue.add(_amount);
143         totalRemaining = totalRemaining.sub(_amount);
144         balances[_to] = balances[_to].add(_amount);
145         emit Distr(_to, _amount);
146         emit Transfer(address(0), _to, _amount);
147         return true;
148         
149         if (totalValue >= maxTotalValue) {
150             zeroDistrFinished = true;
151         }
152     }
153     
154     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
155         totalDistributed = totalDistributed.add(_amount);
156         totalRemaining = totalRemaining.sub(_amount);
157         balances[_to] = balances[_to].add(_amount);
158         emit Distr(_to, _amount);
159         emit Transfer(address(0), _to, _amount);
160         return true;
161 
162         if (totalDistributed >= totalSupply) {
163             distributionFinished = true;
164         }
165     }
166 
167     function () external payable {
168         getTokens();
169      }
170 
171     function getTokens() payable canDistr public {
172         
173         address investor = msg.sender;
174         uint256 toGive = value;
175         uint256 tokens = 0;
176         tokens = tokensPerEth.mul(msg.value) / 1 ether;
177         uint256 bonusFourth = 0;
178         uint256 bonusHalf = 0;
179         uint256 bonusTwentyFive = 0;
180         uint256 bonusFifty = 0;
181         uint256 bonusOneHundred = 0;
182         bonusFourth = tokens / 4;
183         bonusHalf = tokens / 2;
184         bonusTwentyFive = tokens.add(bonusFourth);
185         bonusFifty = tokens.add(bonusHalf);
186         bonusOneHundred = tokens.add(tokens);
187         
188 
189         if (msg.value == 0 ether) {
190             require( blacklist[investor] == false );
191             require( totalValue <= maxTotalValue );
192             distr0(investor, toGive);
193             blacklist[investor] = true;
194 
195             if (totalValue >= maxTotalValue) {
196                 zeroDistrFinished = true;
197             }
198         } 
199         
200         if (msg.value > 0 ether && msg.value < 0.1 ether ) {
201             blacklist[investor] = false;
202             require( msg.value >= minContribution );
203             require( msg.value > 0 );
204             distr(investor, tokens);
205 
206             if (totalDistributed >= totalSupply) {
207                 distributionFinished = true;
208             }
209         }
210 
211         if (msg.value == 0.1 ether ) {
212             blacklist[investor] = false;
213             require( msg.value >= minContribution );
214             require( msg.value > 0 );
215             distr(investor, bonusTwentyFive);
216 
217             if (totalDistributed >= totalSupply) {
218                 distributionFinished = true;
219             }
220         }
221 
222         if (msg.value > 0.1 ether && msg.value < 0.5 ether ) {
223             blacklist[investor] = false;
224             require( msg.value >= minContribution );
225             require( msg.value > 0 );
226             distr(investor, bonusTwentyFive);
227     
228             if (totalDistributed >= totalSupply) {
229                 distributionFinished = true;
230             }
231         }
232 
233         if (msg.value == 0.5 ether ) {
234             blacklist[investor] = false;
235             require( msg.value >= minContribution );
236             require( msg.value > 0 );
237             distr(investor, bonusFifty);
238 
239             if (totalDistributed >= totalSupply) {
240                 distributionFinished = true;
241             }
242         }
243 
244         if (msg.value > 0.5 ether && msg.value < 1 ether ) {
245             blacklist[investor] = false;
246             require( msg.value >= minContribution );
247             require( msg.value > 0 );
248             distr(investor, bonusFifty);
249     
250             if (totalDistributed >= totalSupply) {
251                 distributionFinished = true;
252             }
253         }
254 
255         if (msg.value == 1 ether) {
256             blacklist[investor] = false;
257             require( msg.value >= minContribution );
258             require( msg.value > 0 );
259             distr(investor, bonusOneHundred);
260 
261             if (totalDistributed >= totalSupply) {
262                 distributionFinished = true;
263             }
264         }
265 
266         if (msg.value > 1 ether) {
267             blacklist[investor] = false;
268             require( msg.value >= minContribution );
269             require( msg.value > 0 );
270             distr(investor, bonusOneHundred);
271 
272             if (totalDistributed >= totalSupply) {
273                 distributionFinished = true;
274             }
275         }
276     }
277 
278     function doAirdrop(address _participant, uint _amount) internal {
279 
280         require( _amount > 0 );      
281 
282         require( totalDistributed < totalSupply );
283         
284         balances[_participant] = balances[_participant].add(_amount);
285         totalDistributed = totalDistributed.add(_amount);
286 
287         if (totalDistributed >= totalSupply) {
288             distributionFinished = true;
289         }
290 
291         //log
292         emit Airdrop(_participant, _amount, balances[_participant]);
293         emit Transfer(address(0), _participant, _amount);
294     }
295 
296     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
297         doAirdrop(_participant, _amount);
298     }
299 
300     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
301         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
302     }
303 
304     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
305         tokensPerEth = _tokensPerEth;
306         emit TokensPerEthUpdated(_tokensPerEth);
307     }
308 
309     function balanceOf(address _owner) constant public returns (uint256) {
310         return balances[_owner];
311     }
312 
313     modifier onlyPayloadSize(uint size) {
314         assert(msg.data.length >= size + 4);
315         _;
316     }
317     
318     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
319         require(_to != address(0));
320         require(_amount <= balances[msg.sender]);
321         
322         balances[msg.sender] = balances[msg.sender].sub(_amount);
323         balances[_to] = balances[_to].add(_amount);
324         emit Transfer(msg.sender, _to, _amount);
325         return true;
326     }
327     
328     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
329         require(_to != address(0));
330         require(_amount <= balances[_from]);
331         require(_amount <= allowed[_from][msg.sender]);
332         
333         balances[_from] = balances[_from].sub(_amount);
334         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
335         balances[_to] = balances[_to].add(_amount);
336         emit Transfer(_from, _to, _amount);
337         return true;
338     }
339     
340     function approve(address _spender, uint256 _value) public returns (bool success) {
341         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
342         allowed[msg.sender][_spender] = _value;
343         emit Approval(msg.sender, _spender, _value);
344         return true;
345     }
346     
347     function allowance(address _owner, address _spender) constant public returns (uint256) {
348         return allowed[_owner][_spender];
349     }
350     
351     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
352         ForeignToken t = ForeignToken(tokenAddress);
353         uint bal = t.balanceOf(who);
354         return bal;
355     }
356     
357     function withdraw() onlyOwner public {
358         address myAddress = this;
359         uint256 etherBalance = myAddress.balance;
360         owner.transfer(etherBalance);
361     }
362     
363     function burn(uint256 _value) onlyOwner public {
364         require(_value <= balances[msg.sender]);
365 
366         address burner = msg.sender;
367         balances[burner] = balances[burner].sub(_value);
368         totalSupply = totalSupply.sub(_value);
369         totalDistributed = totalDistributed.sub(_value);
370         emit Burn(burner, _value);
371     }
372     
373     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
374         ForeignToken token = ForeignToken(_tokenContract);
375         uint256 amount = token.balanceOf(address(this));
376         return token.transfer(owner, amount);
377     }
378 }