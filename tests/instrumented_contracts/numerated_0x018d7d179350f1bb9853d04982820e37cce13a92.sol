1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  */
6 library SafeMath {
7 
8     /**
9     * Multiplies two numbers, throws on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         if (a == 0) {
13             return 0;
14         }
15         c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     /**
21     * Integer division of two numbers, truncating the quotient.
22     */
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         // assert(b > 0); // Solidity automatically throws when dividing by 0
25         // uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return a / b;
28     }
29 
30     /**
31     * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32     */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     /**
39     * Adds two numbers, throws on overflow.
40     */
41     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 contract AltcoinToken {
49     function balanceOf(address _owner) constant public returns (uint256);
50     function transfer(address _to, uint256 _value) public returns (bool);
51 }
52 
53 contract ERC20Basic {
54     uint256 public totalSupply;
55     function balanceOf(address who) public constant returns (uint256);
56     function transfer(address to, uint256 value) public returns (bool);
57     event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 
60 contract ERC20 is ERC20Basic {
61     function allowance(address owner, address spender) public constant returns (uint256);
62     function transferFrom(address from, address to, uint256 value) public returns (bool);
63     function approve(address spender, uint256 value) public returns (bool);
64     event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 contract INXToken is ERC20 {
68     
69     using SafeMath for uint256;
70     address owner = msg.sender;
71 
72     mapping (address => uint256) balances;
73     mapping (address => mapping (address => uint256)) allowed;    
74 
75     string public constant name = "INMAX";
76     string public constant symbol = "INX";
77     uint public constant decimals = 8;
78     
79     uint256 public totalSupply = 7000000e8;
80     uint256 public totalDistributed = 0;        
81     uint256 public tokensPerEth =  53220000;  
82     uint256 public tokensPer2Eth = 62220000;  
83     uint256 public tokensPer3Eth = 72220000;
84     uint256 public startPase = 1542646800;
85     uint public maxPhase1 = 1500000e8;
86     uint public maxPhase2 = 1000000e8;
87     uint public maxPhase3 = 500000e8;
88     uint public currentPhase = 0;
89     uint public soldPhase1 = 0;
90     uint public soldPhase2 = 0;
91     uint public soldPhase3 = 0;
92     uint256 public pase1 = startPase + 1 * 18 days;
93     uint256 public pase2 = pase1 + 1 * 18 days;
94     uint256 public pase3 = pase2 + 1 * 18 days;
95     uint256 public constant minContribution = 1 ether / 4;
96 
97     event Transfer(address indexed _from, address indexed _to, uint256 _value);
98     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
99     
100     event Distr(address indexed to, uint256 amount);
101     event DistrFinished();
102 
103     event Airdrop(address indexed _owner, uint _amount, uint _balance);
104 
105     event StartPaseUpdated(uint256 _time);
106     event TokensPerEthUpdated(uint _tokensPerEth);
107     event TokensPerEth2Updated(uint _tokensPerEth);
108     event TokensPerEth3Updated(uint _tokensPerEth);
109     event MaxPhase1Updated(uint _maxPhase1);
110     event MaxPhase2Updated(uint _maxPhase2);
111     event MaxPhase3Updated(uint _maxPhase3);
112      
113     event Burn(address indexed burner, uint256 value);
114 
115     bool public distributionFinished = false;
116     
117     modifier canDistr() {
118         require(!distributionFinished);
119         _;
120     }
121     
122     modifier onlyOwner() {
123         require(msg.sender == owner);
124         _;
125     }
126     
127     constructor() public {
128         owner = msg.sender;
129         uint256 devTokens = 3860000e8;
130         distr(owner, devTokens);
131     }
132     
133     // function I30Token () public {
134     //     owner = msg.sender;
135     //     uint256 devTokens = 3000000e8;
136     //     distr(owner, devTokens);
137     // }
138     
139     function transferOwnership(address newOwner) onlyOwner public {
140         if (newOwner != address(0)) {
141             owner = newOwner;
142         }
143     }
144     
145 
146     function finishDistribution() onlyOwner canDistr public returns (bool) {
147         distributionFinished = true;
148         emit DistrFinished();
149         return true;
150     }
151     
152     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
153         totalDistributed = totalDistributed.add(_amount);        
154         balances[_to] = balances[_to].add(_amount);
155         emit Distr(_to, _amount);
156         emit Transfer(address(0), _to, _amount);
157 
158         return true;
159     }
160 
161     function doAirdrop(address _participant, uint _amount) internal {
162 
163         require( _amount > 0 );      
164 
165         require( totalDistributed < totalSupply );
166         
167         balances[_participant] = balances[_participant].add(_amount);
168         totalDistributed = totalDistributed.add(_amount);
169 
170         if (totalDistributed >= totalSupply) {
171             distributionFinished = true;
172         }
173 
174         // log
175         emit Airdrop(_participant, _amount, balances[_participant]);
176         emit Transfer(address(0), _participant, _amount);
177     }
178 
179     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
180         doAirdrop(_participant, _amount);
181     }
182 
183     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
184         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
185     }
186     
187     function () external payable {
188         getTokens();
189      }
190     
191     function getTokens() payable canDistr  public {
192         uint256 tokens = 0;
193         uint256 sold = 0;
194         
195         require( msg.value >= minContribution );
196 
197         require( msg.value > 0 );
198         
199         require( now > startPase && now < pase3);
200         
201         if(now > startPase && now < pase1 && soldPhase1 <= maxPhase1 ){
202             tokens = msg.value / tokensPerEth;
203         }else if(now >= pase1 && now < pase2 && soldPhase2 <= maxPhase2 ){
204             tokens = msg.value / tokensPer2Eth;
205         }else if(now >= pase2 && now < pase3 && soldPhase3 <= maxPhase3 ){
206             tokens = msg.value / tokensPer3Eth;
207         }
208                 
209         address investor = msg.sender;
210         
211         if (tokens > 0) {
212             if(now > startPase && now <= pase1 && soldPhase1 <= maxPhase1 ){
213                 sold = soldPhase1 + tokens;
214                 require(sold + tokens <= maxPhase1);
215                 soldPhase1 += tokens;
216             }else if(now > pase1 && now <= pase2 && soldPhase2 <= maxPhase2 ){
217                 sold = soldPhase2 + tokens;
218                 require(sold + tokens <= maxPhase2);
219                 soldPhase2 += tokens;
220             }else if(now > pase2 && now <= pase3 && soldPhase3 <= maxPhase3 ){
221                 sold = soldPhase3 + tokens;
222                 require(sold + tokens <= maxPhase3);
223                 soldPhase3 += tokens;
224             }
225             
226             distr(investor, tokens);
227         }
228 
229         if (totalDistributed >= totalSupply) {
230             distributionFinished = true;
231         }
232     }
233 
234     function balanceOf(address _owner) constant public returns (uint256) {
235         return balances[_owner];
236     }
237 
238     // mitigates the ERC20 short address attack
239     modifier onlyPayloadSize(uint size) {
240         assert(msg.data.length >= size + 4);
241         _;
242     }
243     
244     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
245 
246         require(_to != address(0));
247         require(_amount <= balances[msg.sender]);
248         
249         balances[msg.sender] = balances[msg.sender].sub(_amount);
250         balances[_to] = balances[_to].add(_amount);
251         emit Transfer(msg.sender, _to, _amount);
252         return true;
253     }
254     
255     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
256 
257         require(_to != address(0));
258         require(_amount <= balances[_from]);
259         require(_amount <= allowed[_from][msg.sender]);
260         
261         balances[_from] = balances[_from].sub(_amount);
262         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
263         balances[_to] = balances[_to].add(_amount);
264         emit Transfer(_from, _to, _amount);
265         return true;
266     }
267     
268     function approve(address _spender, uint256 _value) public returns (bool success) {
269         // mitigates the ERC20 spend/approval race condition
270         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
271         allowed[msg.sender][_spender] = _value;
272         emit Approval(msg.sender, _spender, _value);
273         return true;
274     }
275     
276     function allowance(address _owner, address _spender) constant public returns (uint256) {
277         return allowed[_owner][_spender];
278     }
279     
280     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
281         AltcoinToken t = AltcoinToken(tokenAddress);
282         uint bal = t.balanceOf(who);
283         return bal;
284     }
285     
286     function withdraw() onlyOwner public {
287         address myAddress = this;
288         uint256 etherBalance = myAddress.balance;
289         owner.transfer(etherBalance);
290     }
291     
292     function burn(uint256 _value) onlyOwner public {
293         require(_value <= balances[msg.sender]);
294         
295         address burner = msg.sender;
296         balances[burner] = balances[burner].sub(_value);
297         totalSupply = totalSupply.sub(_value);
298         totalDistributed = totalDistributed.sub(_value);
299         emit Burn(burner, _value);
300     }
301     
302     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
303         AltcoinToken token = AltcoinToken(_tokenContract);
304         uint256 amount = token.balanceOf(address(this));
305         return token.transfer(owner, amount);
306     }
307     
308     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
309         tokensPerEth = _tokensPerEth;
310         emit TokensPerEthUpdated(_tokensPerEth);
311     }
312     function updateTokens2PerEth(uint _tokensPerEth) public onlyOwner {        
313         tokensPerEth = _tokensPerEth;
314         emit TokensPerEth2Updated(_tokensPerEth);
315     }
316     function updateTokens3PerEth(uint _tokensPerEth) public onlyOwner {        
317         tokensPerEth = _tokensPerEth;
318         emit TokensPerEth3Updated(_tokensPerEth);
319     }
320     
321     
322     function updateMaxPhase1(uint _maxPhase1) public onlyOwner {        
323         maxPhase1 = _maxPhase1;
324         emit MaxPhase1Updated(_maxPhase1);
325     }
326     function updateMaxPhase2(uint _maxPhase2) public onlyOwner {        
327         maxPhase2 = _maxPhase2;
328         emit MaxPhase2Updated(_maxPhase2);
329     }
330     function updateMaxPhase3(uint _maxPhase3) public onlyOwner {        
331         maxPhase3 = _maxPhase3;
332         emit MaxPhase3Updated(_maxPhase3);
333     }
334     function updateStartPhase(uint256 _time) public onlyOwner {        
335         startPase = _time;
336         pase1 = startPase + 1 * 18 days;
337         pase2 = pase1 + 1 * 18 days;
338         pase3 = pase2 + 1 * 18 days;
339         emit StartPaseUpdated(_time);
340     }
341 }