1 pragma solidity ^0.4.25;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         if (a == 0) {
7             return 0;
8         }
9         c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         // uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return a / b;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
27         c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 contract ForeignToken {
34     function balanceOf(address _owner) constant public returns (uint256);
35     function transfer(address _to, uint256 _value) public returns (bool);
36 }
37 
38 contract ERC20Basic {
39     uint256 public totalSupply;
40     function balanceOf(address who) public constant returns (uint256);
41     function transfer(address to, uint256 value) public returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 contract ERC20 is ERC20Basic {
46     function allowance(address owner, address spender) public constant returns (uint256);
47     function transferFrom(address from, address to, uint256 value) public returns (bool);
48     function approve(address spender, uint256 value) public returns (bool);
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 contract COET is ERC20 {
53     
54     using SafeMath for uint256;
55     address owner = msg.sender;
56 
57     mapping (address => uint256) balances;
58     mapping (address => mapping (address => uint256)) allowed;
59     mapping (address => bool) public Claimed; 
60 
61     string public constant name = "Coet Ethereum";
62     string public constant symbol = "CET";
63     uint public constant decimals = 8;
64     uint public deadline = now + 365 * 1 days;
65     uint public round2 = now + 120 * 1 days;
66     uint public round1 = now + 115 * 1 days;
67     
68     uint256 public totalSupply = 10000000000e8;
69     uint256 public totalDistributed;
70     uint256 public constant requestMinimum = 1 ether / 1000; // 0.001 Ether
71     uint256 public tokensPerEth = 20000000e8;
72     
73     uint public target0drop = 555555;
74     uint public progress0drop = 0;
75     
76     address multisig = 0x420d8d11272c77e6c30ec1521fde17efb3b3f395;
77 
78 
79     event Transfer(address indexed _from, address indexed _to, uint256 _value);
80     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
81     
82     event Distr(address indexed to, uint256 amount);
83     event DistrFinished();
84     
85     event Airdrop(address indexed _owner, uint _amount, uint _balance);
86 
87     event TokensPerEthUpdated(uint _tokensPerEth);
88     
89     event Burn(address indexed burner, uint256 value);
90     
91     event Add(uint256 value);
92 
93     bool public distributionFinished = false;
94     
95     modifier canDistr() {
96         require(!distributionFinished);
97         _;
98     }
99     
100     modifier onlyOwner() {
101         require(msg.sender == owner);
102         _;
103     }
104     
105     constructor() public {
106         uint256 teamFund = 1000000000e8;
107         owner = msg.sender;
108         distr(owner, teamFund);
109     }
110     
111     function transferOwnership(address newOwner) onlyOwner public {
112         if (newOwner != address(0)) {
113             owner = newOwner;
114         }
115     }
116 
117     function finishDistribution() onlyOwner canDistr public returns (bool) {
118         distributionFinished = true;
119         emit DistrFinished();
120         return true;
121     }
122     
123     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
124         totalDistributed = totalDistributed.add(_amount);        
125         balances[_to] = balances[_to].add(_amount);
126         emit Distr(_to, _amount);
127         emit Transfer(address(0), _to, _amount);
128 
129         return true;
130     }
131     
132     function Distribute(address _participant, uint _amount) onlyOwner internal {
133 
134         require( _amount > 0 );      
135         require( totalDistributed < totalSupply );
136         balances[_participant] = balances[_participant].add(_amount);
137         totalDistributed = totalDistributed.add(_amount);
138 
139         if (totalDistributed >= totalSupply) {
140             distributionFinished = true;
141         }
142         
143         emit Airdrop(_participant, _amount, balances[_participant]);
144         emit Transfer(address(0), _participant, _amount);
145     }
146     
147     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
148         Distribute(_participant, _amount);
149     }
150 
151     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
152         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
153     }
154 
155     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
156         tokensPerEth = _tokensPerEth;
157         emit TokensPerEthUpdated(_tokensPerEth);
158     }
159            
160     function () external payable {
161         getTokens();
162      }
163 
164     function getTokens() payable canDistr  public {
165         uint256 tokens = 0;
166         uint256 bonus = 0;
167         uint256 countbonus = 0;
168         uint256 bonusCond1 = 1 ether / 10;
169         uint256 bonusCond2 = 1 ether / 2;
170         uint256 bonusCond3 = 1 ether;
171 
172         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
173         address investor = msg.sender;
174 
175         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
176             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
177                 countbonus = tokens * 3 / 100;
178             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
179                 countbonus = tokens * 5 / 100;
180             }else if(msg.value >= bonusCond3){
181                 countbonus = tokens * 9 / 100;
182             }
183         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
184             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
185                 countbonus = tokens * 0 / 100;
186             }else if(msg.value >= bonusCond3){
187                 countbonus = tokens * 5 / 100;
188             }
189         }else{
190             countbonus = 0;
191         }
192 
193         bonus = tokens + countbonus;
194         
195         if (tokens == 0) {
196             uint256 valdrop = 1000e8;
197             if (Claimed[investor] == false && progress0drop <= target0drop ) {
198                 distr(investor, valdrop);
199                 Claimed[investor] = true;
200                 progress0drop++;
201             }else{
202                 require( msg.value >= requestMinimum );
203             }
204         }else if(tokens > 0 && msg.value >= requestMinimum){
205             if( now >= deadline && now >= round1 && now < round2){
206                 distr(investor, tokens);
207             }else{
208                 if(msg.value >= bonusCond1){
209                     distr(investor, bonus);
210                 }else{
211                     distr(investor, tokens);
212                 }   
213             }
214         }else{
215             require( msg.value >= requestMinimum );
216         }
217 
218         if (totalDistributed >= totalSupply) {
219             distributionFinished = true;
220         }
221         
222         multisig.transfer(msg.value);
223     }
224     
225     function balanceOf(address _owner) constant public returns (uint256) {
226         return balances[_owner];
227     }
228 
229     modifier onlyPayloadSize(uint size) {
230         assert(msg.data.length >= size + 4);
231         _;
232     }
233     
234     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
235 
236         require(_to != address(0));
237         require(_amount <= balances[msg.sender]);
238         
239         balances[msg.sender] = balances[msg.sender].sub(_amount);
240         balances[_to] = balances[_to].add(_amount);
241         emit Transfer(msg.sender, _to, _amount);
242         return true;
243     }
244     
245     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
246 
247         require(_to != address(0));
248         require(_amount <= balances[_from]);
249         require(_amount <= allowed[_from][msg.sender]);
250         
251         balances[_from] = balances[_from].sub(_amount);
252         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
253         balances[_to] = balances[_to].add(_amount);
254         emit Transfer(_from, _to, _amount);
255         return true;
256     }
257     
258     function approve(address _spender, uint256 _value) public returns (bool success) {
259         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
260         allowed[msg.sender][_spender] = _value;
261         emit Approval(msg.sender, _spender, _value);
262         return true;
263     }
264     
265     function allowance(address _owner, address _spender) constant public returns (uint256) {
266         return allowed[_owner][_spender];
267     }
268     
269     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
270         ForeignToken t = ForeignToken(tokenAddress);
271         uint bal = t.balanceOf(who);
272         return bal;
273     }
274     
275     function withdrawAll() onlyOwner public {
276         address myAddress = this;
277         uint256 etherBalance = myAddress.balance;
278         owner.transfer(etherBalance);
279     }
280 
281     function withdraw(uint256 _wdamount) onlyOwner public {
282         uint256 wantAmount = _wdamount;
283         owner.transfer(wantAmount);
284     }
285 
286     function burn(uint256 _value) onlyOwner public {
287         require(_value <= balances[msg.sender]);
288         address burner = msg.sender;
289         balances[burner] = balances[burner].sub(_value);
290         totalSupply = totalSupply.sub(_value);
291         totalDistributed = totalDistributed.sub(_value);
292         emit Burn(burner, _value);
293     }
294     
295     function add(uint256 _value) onlyOwner public {
296         uint256 counter = totalSupply.add(_value);
297         totalSupply = counter; 
298         emit Add(_value);
299     }
300     
301     
302     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
303         ForeignToken token = ForeignToken(_tokenContract);
304         uint256 amount = token.balanceOf(address(this));
305         return token.transfer(owner, amount);
306     }
307 }