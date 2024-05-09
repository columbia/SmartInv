1 /**
2 --------------------------------------------------------------------------------
3 The VCG Token Smart Contract
4 
5 Credit:
6 VeChain Gold
7 
8 ERC20: https://github.com/ethereum/EIPs/issues/20
9 ERC223: https://github.com/ethereum/EIPs/issues/223
10 
11 MIT Licence
12 --------------------------------------------------------------------------------
13 */
14 
15 /*
16 * Contract that is working with ERC20 tokens
17 */
18 
19 pragma solidity ^0.4.24;
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26 
27     /**
28     * @dev Multiplies two numbers, throws on overflow.
29     */
30     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
31         if (a == 0) {
32             return 0;
33         }
34         c = a * b;
35         assert(c / a == b);
36         return c;
37     }
38 
39     /**
40     * @dev Integer division of two numbers, truncating the quotient.
41     */
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         // assert(b > 0); // Solidity automatically throws when dividing by 0
44         // uint256 c = a / b;
45         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46         return a / b;
47     }
48 
49     /**
50     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51     */
52     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53         assert(b <= a);
54         return a - b;
55     }
56 
57     /**
58     * @dev Adds two numbers, throws on overflow.
59     */
60     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
61         c = a + b;
62         assert(c >= a);
63         return c;
64     }
65 }
66 
67 contract ForeignToken {
68     function balanceOf(address _owner) constant public returns (uint256);
69     function transfer(address _to, uint256 _value) public returns (bool);
70 }
71 
72 contract ERC20Basic {
73     uint256 public totalSupply;
74     function balanceOf(address who) public constant returns (uint256);
75     function transfer(address to, uint256 value) public returns (bool);
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 }
78 
79 contract ERC20 is ERC20Basic {
80     function allowance(address owner, address spender) public constant returns (uint256);
81     function transferFrom(address from, address to, uint256 value) public returns (bool);
82     function approve(address spender, uint256 value) public returns (bool);
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 contract VechainGold is ERC20 {
87     
88     using SafeMath for uint256;
89     address owner = msg.sender;
90 
91     mapping (address => uint256) balances;
92     mapping (address => mapping (address => uint256)) allowed;
93     mapping (address => bool) public Claimed; 
94 
95     string public constant name = "VeChain Gold";
96     string public constant symbol = "VCG";
97     uint public constant decimals = 18;
98     uint public deadline = now + 30 * 1 days;
99     uint public round2 = now + 28 * 1 days;
100     uint public round1 = now + 20 * 1 days;
101     
102     uint256 public totalSupply = 75000000e18;
103     uint256 public totalDistributed;
104     uint256 public constant requestMinimum = 1 ether / 50; // 0.02 Ether
105     uint256 public tokensPerEth = 10000e18;
106     
107     uint public target0drop = 0;
108     uint public progress0drop = 0;
109 
110 
111     event Transfer(address indexed _from, address indexed _to, uint256 _value);
112     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
113     
114     event Distr(address indexed to, uint256 amount);
115     event DistrFinished();
116     
117     event Airdrop(address indexed _owner, uint _amount, uint _balance);
118 
119     event TokensPerEthUpdated(uint _tokensPerEth);
120     
121     event Burn(address indexed burner, uint256 value);
122     
123     event Add(uint256 value);
124 
125     bool public distributionFinished = false;
126     
127     modifier canDistr() {
128         require(!distributionFinished);
129         _;
130     }
131     
132     modifier onlyOwner() {
133         require(msg.sender == owner);
134         _;
135     }
136     
137     constructor() public {
138         uint256 teamFund = 5000000e18;
139         owner = msg.sender;
140         distr(owner, teamFund);
141     }
142     
143     function transferOwnership(address newOwner) onlyOwner public {
144         if (newOwner != address(0)) {
145             owner = newOwner;
146         }
147     }
148 
149     function finishDistribution() onlyOwner canDistr public returns (bool) {
150         distributionFinished = true;
151         emit DistrFinished();
152         return true;
153     }
154     
155     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
156         totalDistributed = totalDistributed.add(_amount);        
157         balances[_to] = balances[_to].add(_amount);
158         emit Distr(_to, _amount);
159         emit Transfer(address(0), _to, _amount);
160 
161         return true;
162     }
163     
164     function Distribute(address _participant, uint _amount) onlyOwner internal {
165 
166         require( _amount > 0 );      
167         require( totalDistributed < totalSupply );
168         balances[_participant] = balances[_participant].add(_amount);
169         totalDistributed = totalDistributed.add(_amount);
170 
171         if (totalDistributed >= totalSupply) {
172             distributionFinished = true;
173         }
174 
175         // log
176         emit Airdrop(_participant, _amount, balances[_participant]);
177         emit Transfer(address(0), _participant, _amount);
178     }
179     
180     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
181         Distribute(_participant, _amount);
182     }
183 
184     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
185         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
186     }
187 
188     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
189         tokensPerEth = _tokensPerEth;
190         emit TokensPerEthUpdated(_tokensPerEth);
191     }
192            
193     function () external payable {
194         getTokens();
195      }
196 
197     function getTokens() payable canDistr  public {
198         uint256 tokens = 0;
199         uint256 bonus = 0;
200         uint256 countbonus = 0;
201         uint256 bonusCond1 = 1 ether / 10;
202         uint256 bonusCond2 = 1 ether / 2;
203         uint256 bonusCond3 = 1 ether;
204 
205         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
206         address investor = msg.sender;
207 
208         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
209             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
210                 countbonus = 0;
211             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
212                 countbonus = 0;
213             }else if(msg.value >= bonusCond3){
214                 countbonus = 0;
215             }
216         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
217             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
218                 countbonus = 0;
219             }else if(msg.value >= bonusCond3){
220                 countbonus = 0;
221             }
222         }else{
223             countbonus = 0;
224         }
225 
226         bonus = tokens + countbonus;
227         
228         if (tokens == 0) {
229             uint256 valdrop = 0;
230             if (Claimed[investor] == false && progress0drop <= target0drop ) {
231                 distr(investor, valdrop);
232                 Claimed[investor] = true;
233                 progress0drop++;
234             }else{
235                 require( msg.value >= requestMinimum );
236             }
237         }else if(tokens > 0 && msg.value >= requestMinimum){
238             if( now >= deadline && now >= round1 && now < round2){
239                 distr(investor, tokens);
240             }else{
241                 if(msg.value >= bonusCond1){
242                     distr(investor, bonus);
243                 }else{
244                     distr(investor, tokens);
245                 }   
246             }
247         }else{
248             require( msg.value >= requestMinimum );
249         }
250 
251         if (totalDistributed >= totalSupply) {
252             distributionFinished = true;
253         }
254     }
255     
256     function balanceOf(address _owner) constant public returns (uint256) {
257         return balances[_owner];
258     }
259 
260     modifier onlyPayloadSize(uint size) {
261         assert(msg.data.length >= size + 4);
262         _;
263     }
264     
265     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
266 
267         require(_to != address(0));
268         require(_amount <= balances[msg.sender]);
269         
270         balances[msg.sender] = balances[msg.sender].sub(_amount);
271         balances[_to] = balances[_to].add(_amount);
272         emit Transfer(msg.sender, _to, _amount);
273         return true;
274     }
275     
276     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
277 
278         require(_to != address(0));
279         require(_amount <= balances[_from]);
280         require(_amount <= allowed[_from][msg.sender]);
281         
282         balances[_from] = balances[_from].sub(_amount);
283         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
284         balances[_to] = balances[_to].add(_amount);
285         emit Transfer(_from, _to, _amount);
286         return true;
287     }
288     
289     function approve(address _spender, uint256 _value) public returns (bool success) {
290         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
291         allowed[msg.sender][_spender] = _value;
292         emit Approval(msg.sender, _spender, _value);
293         return true;
294     }
295     
296     function allowance(address _owner, address _spender) constant public returns (uint256) {
297         return allowed[_owner][_spender];
298     }
299     
300     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
301         ForeignToken t = ForeignToken(tokenAddress);
302         uint bal = t.balanceOf(who);
303         return bal;
304     }
305     
306     function withdrawAll() onlyOwner public {
307         address myAddress = this;
308         uint256 etherBalance = myAddress.balance;
309         owner.transfer(etherBalance);
310     }
311 
312     function withdraw(uint256 _wdamount) onlyOwner public {
313         uint256 wantAmount = _wdamount;
314         owner.transfer(wantAmount);
315     }
316 
317     function burn(uint256 _value) onlyOwner public {
318         require(_value <= balances[msg.sender]);
319         address burner = msg.sender;
320         balances[burner] = balances[burner].sub(_value);
321         totalSupply = totalSupply.sub(_value);
322         totalDistributed = totalDistributed.sub(_value);
323         emit Burn(burner, _value);
324     }
325     
326     function add(uint256 _value) onlyOwner public {
327         uint256 counter = totalSupply.add(_value);
328         totalSupply = counter; 
329         emit Add(_value);
330     }
331     
332     
333     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
334         ForeignToken token = ForeignToken(_tokenContract);
335         uint256 amount = token.balanceOf(address(this));
336         return token.transfer(owner, amount);
337     }
338 }