1 pragma solidity ^0.4.25;
2 
3 // 'Electronic Music'
4 //
5 // NAME     : Electronic Music
6 // Symbol   : EMT
7 // Total supply: 10,999,999,000
8 // Decimals    : 18
9 
10 library SafeMath {
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         if (a == 0) {
13             return 0;
14         }
15         c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         // uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return a / b;
25     }
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         assert(b <= a);
29         return a - b;
30     }
31 
32     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
33         c = a + b;
34         assert(c >= a);
35         return c;
36     }
37 }
38 
39 contract ForeignToken {
40     function balanceOf(address _owner) constant public returns (uint256);
41     function transfer(address _to, uint256 _value) public returns (bool);
42 }
43 
44 contract ERC20Basic {
45     uint256 public totalSupply;
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
58 contract ElectronicMusic is ERC20 {
59     
60     using SafeMath for uint256;
61     address owner = msg.sender;
62 
63     mapping (address => uint256) balances;
64     mapping (address => mapping (address => uint256)) allowed;
65     mapping (address => bool) public Claimed; 
66 
67     string public constant name = "ElectronicMusic";
68     string public constant symbol = "EMT";
69     uint public constant decimals = 18;
70     uint public deadline = now + 35 * 1 days;
71     uint public round2 = now + 30 * 1 days;
72     uint public round1 = now + 20 * 1 days;
73     
74     uint256 public totalSupply = 10999999000e18;
75     uint256 public totalDistributed;
76     uint256 public constant requestMinimum = 1 ether / 100; // 0.01 Ether
77     uint256 public tokensPerEth = 20000000e18;
78     
79     uint public target0drop = 30000;
80     uint public progress0drop = 0;
81     
82     address multisig = 0x86c7B103c057ff7d3A55E06af777B7bE33E8A900;
83 
84 
85     event Transfer(address indexed _from, address indexed _to, uint256 _value);
86     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
87     
88     event Distr(address indexed to, uint256 amount);
89     event DistrFinished();
90     
91     event Airdrop(address indexed _owner, uint _amount, uint _balance);
92 
93     event TokensPerEthUpdated(uint _tokensPerEth);
94     
95     event Burn(address indexed burner, uint256 value);
96     
97     event Add(uint256 value);
98 
99     bool public distributionFinished = false;
100     
101     modifier canDistr() {
102         require(!distributionFinished);
103         _;
104     }
105     
106     modifier onlyOwner() {
107         require(msg.sender == owner);
108         _;
109     }
110     
111     constructor() public {
112         uint256 teamFund = 3000000000e18;
113         owner = msg.sender;
114         distr(owner, teamFund);
115     }
116     
117     function transferOwnership(address newOwner) onlyOwner public {
118         if (newOwner != address(0)) {
119             owner = newOwner;
120         }
121     }
122 
123     function finishDistribution() onlyOwner canDistr public returns (bool) {
124         distributionFinished = true;
125         emit DistrFinished();
126         return true;
127     }
128     
129     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
130         totalDistributed = totalDistributed.add(_amount);        
131         balances[_to] = balances[_to].add(_amount);
132         emit Distr(_to, _amount);
133         emit Transfer(address(0), _to, _amount);
134 
135         return true;
136     }
137     
138     function Distribute(address _participant, uint _amount) onlyOwner internal {
139 
140         require( _amount > 0 );      
141         require( totalDistributed < totalSupply );
142         balances[_participant] = balances[_participant].add(_amount);
143         totalDistributed = totalDistributed.add(_amount);
144 
145         if (totalDistributed >= totalSupply) {
146             distributionFinished = true;
147         }
148         
149         emit Airdrop(_participant, _amount, balances[_participant]);
150         emit Transfer(address(0), _participant, _amount);
151     }
152     
153     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
154         Distribute(_participant, _amount);
155     }
156 
157     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
158         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
159     }
160 
161     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
162         tokensPerEth = _tokensPerEth;
163         emit TokensPerEthUpdated(_tokensPerEth);
164     }
165            
166     function () external payable {
167         getTokens();
168      }
169 
170     function getTokens() payable canDistr  public {
171         uint256 tokens = 0;
172         uint256 bonus = 0;
173         uint256 countbonus = 0;
174         uint256 bonusCond1 = 1 ether / 2;
175         uint256 bonusCond2 = 1 ether;
176         uint256 bonusCond3 = 3 ether;
177 
178         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
179         address investor = msg.sender;
180 
181         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
182             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
183                 countbonus = tokens * 5 / 100;
184             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
185                 countbonus = tokens * 10 / 100;
186             }else if(msg.value >= bonusCond3){
187                 countbonus = tokens * 15 / 100;
188             }
189         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
190             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
191                 countbonus = tokens * 10 / 100;
192             }else if(msg.value >= bonusCond3){
193                 countbonus = tokens * 15 / 100;
194             }
195         }else{
196             countbonus = 0;
197         }
198 
199         bonus = tokens + countbonus;
200         
201         if (tokens == 0) {
202             uint256 valdrop = 5000e8;
203             if (Claimed[investor] == false && progress0drop <= target0drop ) {
204                 distr(investor, valdrop);
205                 Claimed[investor] = true;
206                 progress0drop++;
207             }else{
208                 require( msg.value >= requestMinimum );
209             }
210         }else if(tokens > 0 && msg.value >= requestMinimum){
211             if( now >= deadline && now >= round1 && now < round2){
212                 distr(investor, tokens);
213             }else{
214                 if(msg.value >= bonusCond1){
215                     distr(investor, bonus);
216                 }else{
217                     distr(investor, tokens);
218                 }   
219             }
220         }else{
221             require( msg.value >= requestMinimum );
222         }
223 
224         if (totalDistributed >= totalSupply) {
225             distributionFinished = true;
226         }
227         
228         multisig.transfer(msg.value);
229     }
230     
231     function balanceOf(address _owner) constant public returns (uint256) {
232         return balances[_owner];
233     }
234 
235     modifier onlyPayloadSize(uint size) {
236         assert(msg.data.length >= size + 4);
237         _;
238     }
239     
240     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
241 
242         require(_to != address(0));
243         require(_amount <= balances[msg.sender]);
244         
245         balances[msg.sender] = balances[msg.sender].sub(_amount);
246         balances[_to] = balances[_to].add(_amount);
247         emit Transfer(msg.sender, _to, _amount);
248         return true;
249     }
250     
251     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
252 
253         require(_to != address(0));
254         require(_amount <= balances[_from]);
255         require(_amount <= allowed[_from][msg.sender]);
256         
257         balances[_from] = balances[_from].sub(_amount);
258         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
259         balances[_to] = balances[_to].add(_amount);
260         emit Transfer(_from, _to, _amount);
261         return true;
262     }
263     
264     function approve(address _spender, uint256 _value) public returns (bool success) {
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
276         ForeignToken t = ForeignToken(tokenAddress);
277         uint bal = t.balanceOf(who);
278         return bal;
279     }
280     
281     function withdrawAll() onlyOwner public {
282         address myAddress = this;
283         uint256 etherBalance = myAddress.balance;
284         owner.transfer(etherBalance);
285     }
286 
287     function withdraw(uint256 _wdamount) onlyOwner public {
288         uint256 wantAmount = _wdamount;
289         owner.transfer(wantAmount);
290     }
291 
292     function burn(uint256 _value) onlyOwner public {
293         require(_value <= balances[msg.sender]);
294         address burner = msg.sender;
295         balances[burner] = balances[burner].sub(_value);
296         totalSupply = totalSupply.sub(_value);
297         totalDistributed = totalDistributed.sub(_value);
298         emit Burn(burner, _value);
299     }
300     
301     function add(uint256 _value) onlyOwner public {
302         uint256 counter = totalSupply.add(_value);
303         totalSupply = counter; 
304         emit Add(_value);
305     }
306     
307     
308     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
309         ForeignToken token = ForeignToken(_tokenContract);
310         uint256 amount = token.balanceOf(address(this));
311         return token.transfer(owner, amount);
312     }
313 }