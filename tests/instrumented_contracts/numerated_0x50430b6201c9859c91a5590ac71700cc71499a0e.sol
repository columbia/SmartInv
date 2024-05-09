1 pragma solidity ^0.4.22;
2 
3 // GetPaid Project
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
54 contract GetPaid is ERC20 {
55 
56   
57     using SafeMath for uint256;
58     address owner = msg.sender;
59 
60     mapping (address => uint256) balances;
61     mapping (address => mapping (address => uint256)) allowed;
62     mapping (address => bool) public blacklist;
63 
64     string public constant name = "GetPaid Token";
65     string public constant symbol = "GPaid";
66     uint public constant decimals = 2;
67     
68     uint256 public totalSupply = 30000000000e2;
69     
70     uint256 public totalDistributed = 0;
71 
72     uint256 public totalValue = 0;
73     
74     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
75     
76     uint256 public value = 100000e2;
77 
78     uint256 public tokensPerEth = 10000000e2;
79 
80     uint256 public constant minContribution = 1 ether / 100; // 0.01 Eth
81 
82     uint256 public constant maxTotalValue = 15000000000e2;
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
120     function GPaid () public {
121         owner = msg.sender;
122         balances[owner] = totalDistributed;
123     }
124     
125     function transferOwnership(address newOwner) onlyOwner public {
126         if (newOwner != address(0)) {
127             owner = newOwner;
128         }
129     }
130     
131     function finishZeroDistribution() onlyOwner canDistr public returns (bool) {
132         zeroDistrFinished = true;
133         emit ZeroEthFinished();
134         return true;
135     }
136 
137     function finishDistribution() onlyOwner canDistr public returns (bool) {
138         distributionFinished = true;
139         emit DistrFinished();
140         return true;
141     }
142 
143     function distr0(address _to, uint256 _amount) canDistr private returns (bool) {
144         require( totalValue < maxTotalValue );
145         totalDistributed = totalDistributed.add(_amount);
146         totalValue = totalValue.add(_amount);
147         totalRemaining = totalRemaining.sub(_amount);
148         balances[_to] = balances[_to].add(_amount);
149         emit Distr(_to, _amount);
150         emit Transfer(address(0), _to, _amount);
151         return true;
152         
153         if (totalValue >= maxTotalValue) {
154             zeroDistrFinished = true;
155         }
156     }
157     
158     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
159         totalDistributed = totalDistributed.add(_amount);
160         totalRemaining = totalRemaining.sub(_amount);
161         balances[_to] = balances[_to].add(_amount);
162         emit Distr(_to, _amount);
163         emit Transfer(address(0), _to, _amount);
164         return true;
165 
166         if (totalDistributed >= totalSupply) {
167             distributionFinished = true;
168         }
169     }
170 
171     function () external payable {
172         getTokens();
173      }
174 
175     function getTokens() payable canDistr public {
176         
177         address investor = msg.sender;
178         uint256 toGive = value;
179         uint256 tokens = 0;
180         tokens = tokensPerEth.mul(msg.value) / 1 ether;
181         uint256 bonusHalf = 0;
182         uint256 bonusOne = 0;
183         uint256 bonusTwo = 0;
184         bonusHalf = tokens / 2;
185         bonusOne = tokens.add(bonusHalf);
186         bonusTwo = tokens.add(tokens);
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
200         if (msg.value > 0 ether && msg.value < 0.5 ether ) {
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
211         if (msg.value == 0.5 ether ) {
212             blacklist[investor] = false;
213             require( msg.value >= minContribution );
214             require( msg.value > 0 );
215             distr(investor, bonusOne);
216 
217             if (totalDistributed >= totalSupply) {
218                 distributionFinished = true;
219             }
220         }
221 
222         if (msg.value > 0.5 ether && msg.value < 1 ether ) {
223             blacklist[investor] = false;
224             require( msg.value >= minContribution );
225             require( msg.value > 0 );
226             distr(investor, bonusOne);
227     
228             if (totalDistributed >= totalSupply) {
229                 distributionFinished = true;
230             }
231         }
232 
233         if (msg.value == 1 ether) {
234             blacklist[investor] = false;
235             require( msg.value >= minContribution );
236             require( msg.value > 0 );
237             distr(investor, bonusTwo);
238 
239             if (totalDistributed >= totalSupply) {
240                 distributionFinished = true;
241             }
242         }
243 
244         if (msg.value > 1 ether) {
245             blacklist[investor] = false;
246             require( msg.value >= minContribution );
247             require( msg.value > 0 );
248             distr(investor, bonusTwo);
249 
250             if (totalDistributed >= totalSupply) {
251                 distributionFinished = true;
252             }
253         }
254     }
255 
256     function doAirdrop(address _participant, uint _amount) internal {
257 
258         require( _amount > 0 );      
259 
260         require( totalDistributed < totalSupply );
261         
262         balances[_participant] = balances[_participant].add(_amount);
263         totalDistributed = totalDistributed.add(_amount);
264 
265         if (totalDistributed >= totalSupply) {
266             distributionFinished = true;
267         }
268 
269         //log
270         emit Airdrop(_participant, _amount, balances[_participant]);
271         emit Transfer(address(0), _participant, _amount);
272     }
273 
274     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
275         doAirdrop(_participant, _amount);
276     }
277 
278     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
279         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
280     }
281 
282     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
283         tokensPerEth = _tokensPerEth;
284         emit TokensPerEthUpdated(_tokensPerEth);
285     }
286 
287     function balanceOf(address _owner) constant public returns (uint256) {
288         return balances[_owner];
289     }
290 
291     modifier onlyPayloadSize(uint size) {
292         assert(msg.data.length >= size + 4);
293         _;
294     }
295     
296     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
297         require(_to != address(0));
298         require(_amount <= balances[msg.sender]);
299         
300         balances[msg.sender] = balances[msg.sender].sub(_amount);
301         balances[_to] = balances[_to].add(_amount);
302         emit Transfer(msg.sender, _to, _amount);
303         return true;
304     }
305     
306     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
307         require(_to != address(0));
308         require(_amount <= balances[_from]);
309         require(_amount <= allowed[_from][msg.sender]);
310         
311         balances[_from] = balances[_from].sub(_amount);
312         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
313         balances[_to] = balances[_to].add(_amount);
314         emit Transfer(_from, _to, _amount);
315         return true;
316     }
317     
318     function approve(address _spender, uint256 _value) public returns (bool success) {
319         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
320         allowed[msg.sender][_spender] = _value;
321         emit Approval(msg.sender, _spender, _value);
322         return true;
323     }
324     
325     function allowance(address _owner, address _spender) constant public returns (uint256) {
326         return allowed[_owner][_spender];
327     }
328     
329     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
330         ForeignToken t = ForeignToken(tokenAddress);
331         uint bal = t.balanceOf(who);
332         return bal;
333     }
334     
335     function withdraw() onlyOwner public {
336         address myAddress = this;
337         uint256 etherBalance = myAddress.balance;
338         owner.transfer(etherBalance);
339     }
340     
341     function burn(uint256 _value) onlyOwner public {
342         require(_value <= balances[msg.sender]);
343 
344         address burner = msg.sender;
345         balances[burner] = balances[burner].sub(_value);
346         totalSupply = totalSupply.sub(_value);
347         totalDistributed = totalDistributed.sub(_value);
348         emit Burn(burner, _value);
349     }
350     
351     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
352         ForeignToken token = ForeignToken(_tokenContract);
353         uint256 amount = token.balanceOf(address(this));
354         return token.transfer(owner, amount);
355     }
356 }