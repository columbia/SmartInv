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
67 contract IDCToken is ERC20 {
68     
69     using SafeMath for uint256;
70     address owner = msg.sender;
71 
72     mapping (address => uint256) balances;
73     mapping (address => mapping (address => uint256)) allowed;    
74 
75     string public constant name = "INDOCHAIN";
76     string public constant symbol = "IDC";
77     uint public constant decimals = 8;
78     
79     uint256 public totalSupply = 9000000000e8;
80     uint256 public totalDistributed = 0;        
81     uint256 public tokensPerEth =  30000;  
82     uint256 public tokensPer2Eth = 35000;  
83     uint256 public tokensPer3Eth = 40000;
84     uint256 public startPase = 1541548800;
85     uint public maxPhase1 = 875000000e8;
86     uint public maxPhase2 = 1750000000e8;
87     uint public maxPhase3 = 2685000000e8;
88     uint public currentPhase = 0;
89     uint public soldPhase1 = 0;
90     uint public soldPhase2 = 0;
91     uint public soldPhase3 = 0;
92     uint256 public pase1 = startPase + 1 * 30 days;
93     uint256 public pase2 = pase1 + 1 * 30 days;
94     uint256 public pase3 = pase2 + 1 * 30 days;
95     uint256 public constant minContribution = 1 ether / 1000;
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
129         uint256 devTokens = 3510000000e8;
130         distr(owner, devTokens);
131     }
132      
133     
134     function transferOwnership(address newOwner) onlyOwner public {
135         if (newOwner != address(0)) {
136             owner = newOwner;
137         }
138     }
139     
140 
141     function finishDistribution() onlyOwner canDistr public returns (bool) {
142         distributionFinished = true;
143         emit DistrFinished();
144         return true;
145     }
146     
147     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
148         totalDistributed = totalDistributed.add(_amount);        
149         balances[_to] = balances[_to].add(_amount);
150         emit Distr(_to, _amount);
151         emit Transfer(address(0), _to, _amount);
152 
153         return true;
154     }
155 
156     function doAirdrop(address _participant, uint _amount) internal {
157 
158         require( _amount > 0 );      
159 
160         require( totalDistributed < totalSupply );
161         
162         balances[_participant] = balances[_participant].add(_amount);
163         totalDistributed = totalDistributed.add(_amount);
164 
165         if (totalDistributed >= totalSupply) {
166             distributionFinished = true;
167         }
168 
169         // log
170         emit Airdrop(_participant, _amount, balances[_participant]);
171         emit Transfer(address(0), _participant, _amount);
172     }
173 
174     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
175         doAirdrop(_participant, _amount);
176     }
177 
178     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
179         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
180     }
181     
182     function () external payable {
183         getTokens();
184      }
185     
186     function getTokens() payable canDistr  public {
187         uint256 tokens = 0;
188         uint256 sold = 0;
189         
190         require( msg.value >= minContribution );
191 
192         require( msg.value > 0 );
193         
194         require( now > startPase && now < pase3);
195         
196         if(now > startPase && now < pase1 && soldPhase1 <= maxPhase1 ){
197             tokens = msg.value / tokensPerEth;
198         }else if(now >= pase1 && now < pase2 && soldPhase2 <= maxPhase2 ){
199             tokens = msg.value / tokensPer2Eth;
200         }else if(now >= pase2 && now < pase3 && soldPhase3 <= maxPhase3 ){
201             tokens = msg.value / tokensPer3Eth;
202         }
203                 
204         address investor = msg.sender;
205         
206         if (tokens > 0) {
207             if(now > startPase && now <= pase1 && soldPhase1 <= maxPhase1 ){
208                 sold = soldPhase1 + tokens;
209                 require(sold + tokens <= maxPhase1);
210                 soldPhase1 += tokens;
211             }else if(now > pase1 && now <= pase2 && soldPhase2 <= maxPhase2 ){
212                 sold = soldPhase2 + tokens;
213                 require(sold + tokens <= maxPhase2);
214                 soldPhase2 += tokens;
215             }else if(now > pase2 && now <= pase3 && soldPhase3 <= maxPhase3 ){
216                 sold = soldPhase3 + tokens;
217                 require(sold + tokens <= maxPhase3);
218                 soldPhase3 += tokens;
219             }
220             
221             distr(investor, tokens);
222         }
223 
224         if (totalDistributed >= totalSupply) {
225             distributionFinished = true;
226         }
227     }
228 
229     function balanceOf(address _owner) constant public returns (uint256) {
230         return balances[_owner];
231     }
232 
233     // mitigates the ERC20 short address attack
234     modifier onlyPayloadSize(uint size) {
235         assert(msg.data.length >= size + 4);
236         _;
237     }
238     
239     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
240 
241         require(_to != address(0));
242         require(_amount <= balances[msg.sender]);
243         
244         balances[msg.sender] = balances[msg.sender].sub(_amount);
245         balances[_to] = balances[_to].add(_amount);
246         emit Transfer(msg.sender, _to, _amount);
247         return true;
248     }
249     
250     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
251 
252         require(_to != address(0));
253         require(_amount <= balances[_from]);
254         require(_amount <= allowed[_from][msg.sender]);
255         
256         balances[_from] = balances[_from].sub(_amount);
257         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
258         balances[_to] = balances[_to].add(_amount);
259         emit Transfer(_from, _to, _amount);
260         return true;
261     }
262     
263     function approve(address _spender, uint256 _value) public returns (bool success) {
264         // mitigates the ERC20 spend/approval race condition
265         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
266         allowed[msg.sender][_spender] = _value;
267         emit Approval(msg.sender, _spender, _value);
268         return true;
269     }
270     
271     function allowance(address _owner, address _spender) constant public returns (uint256) {
272         return allowed[_owner][_spender];
273     }
274     
275     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
276         AltcoinToken t = AltcoinToken(tokenAddress);
277         uint bal = t.balanceOf(who);
278         return bal;
279     }
280     
281     function withdraw() onlyOwner public {
282         address myAddress = this;
283         uint256 etherBalance = myAddress.balance;
284         owner.transfer(etherBalance);
285     }
286     
287     function burn(uint256 _value) onlyOwner public {
288         require(_value <= balances[msg.sender]);
289         
290         address burner = msg.sender;
291         balances[burner] = balances[burner].sub(_value);
292         totalSupply = totalSupply.sub(_value);
293         totalDistributed = totalDistributed.sub(_value);
294         emit Burn(burner, _value);
295     }
296     
297     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
298         AltcoinToken token = AltcoinToken(_tokenContract);
299         uint256 amount = token.balanceOf(address(this));
300         return token.transfer(owner, amount);
301     }
302     
303     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
304         tokensPerEth = _tokensPerEth;
305         emit TokensPerEthUpdated(_tokensPerEth);
306     }
307     function updateTokens2PerEth(uint _tokensPerEth) public onlyOwner {        
308         tokensPer2Eth = _tokensPerEth;
309         emit TokensPerEth2Updated(_tokensPerEth);
310     }
311     function updateTokens3PerEth(uint _tokensPerEth) public onlyOwner {        
312         tokensPer3Eth = _tokensPerEth;
313         emit TokensPerEth3Updated(_tokensPerEth);
314     }
315     
316     
317     function updateMaxPhase1(uint _maxPhase1) public onlyOwner {        
318         maxPhase1 = _maxPhase1;
319         emit MaxPhase1Updated(_maxPhase1);
320     }
321     function updateMaxPhase2(uint _maxPhase2) public onlyOwner {        
322         maxPhase2 = _maxPhase2;
323         emit MaxPhase2Updated(_maxPhase2);
324     }
325     function updateMaxPhase3(uint _maxPhase3) public onlyOwner {        
326         maxPhase3 = _maxPhase3;
327         emit MaxPhase3Updated(_maxPhase3);
328     }
329     function updateStartPhase(uint256 _time) public onlyOwner {        
330         startPase = _time;
331         pase1 = startPase + 1 * 30 days;
332         pase2 = pase1 + 1 * 30 days;
333         pase3 = pase2 + 1 * 30 days;
334         emit StartPaseUpdated(_time);
335     }
336 }