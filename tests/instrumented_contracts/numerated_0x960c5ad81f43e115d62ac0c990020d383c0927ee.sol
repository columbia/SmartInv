1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         if (a == 0) {
6             return 0;
7         }
8         c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         // uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return a / b;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
26         c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 contract ForeignToken {
33     function balanceOf(address _owner) constant public returns (uint256);
34     function transfer(address _to, uint256 _value) public returns (bool);
35 }
36 
37 contract ERC20Basic {
38     uint256 public totalSupply;
39     function balanceOf(address who) public constant returns (uint256);
40     function transfer(address to, uint256 value) public returns (bool);
41     event Transfer(address indexed from, address indexed to, uint256 value);
42 }
43 
44 contract ERC20 is ERC20Basic {
45     function allowance(address owner, address spender) public constant returns (uint256);
46     function transferFrom(address from, address to, uint256 value) public returns (bool);
47     function approve(address spender, uint256 value) public returns (bool);
48     event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 contract ExtensiveTrust is ERC20 {
52     
53     using SafeMath for uint256;
54     address owner = msg.sender;
55 
56     mapping (address => uint256) balances;
57     mapping (address => mapping (address => uint256)) allowed;
58     mapping (address => bool) public Claimed; 
59 
60     string public constant name = "Extensive Trust";
61     string public constant symbol = "ET";
62     uint public constant decimals = 8;
63     uint public deadline = now + 50 * 1 days;
64     uint public round1 = now + 20 * 1 days;
65     uint public round2 = now + 40 * 1 days;
66     
67     uint256 public totalSupply = 16000000000e8;
68     uint256 public totalDistributed;
69     uint256 public constant requestMinimum = 1 ether / 1000; // 0.001 Ether
70     uint256 public tokensPerEth = 50000000e8;
71     
72     uint public target0drop = 50000;
73     uint public progress0drop = 0;
74     
75     address multisig = 0x98FbB7D9c667F0217192c401786Ba02e027f2023;
76 
77 
78     event Transfer(address indexed _from, address indexed _to, uint256 _value);
79     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
80     
81     event Distr(address indexed to, uint256 amount);
82     event DistrFinished();
83     
84     event Airdrop(address indexed _owner, uint _amount, uint _balance);
85 
86     event TokensPerEthUpdated(uint _tokensPerEth);
87     
88     event Burn(address indexed burner, uint256 value);
89     
90     event Add(uint256 value);
91 
92     bool public distributionFinished = false;
93     
94     modifier canDistr() {
95         require(!distributionFinished);
96         _;
97     }
98     
99     modifier onlyOwner() {
100         require(msg.sender == owner);
101         _;
102     }
103     
104     constructor() public {
105         uint256 teamFund = 2000000000e8;
106         owner = msg.sender;
107         distr(owner, teamFund);
108     }
109     
110     function transferOwnership(address newOwner) onlyOwner public {
111         if (newOwner != address(0)) {
112             owner = newOwner;
113         }
114     }
115 
116     function finishDistribution() onlyOwner canDistr public returns (bool) {
117         distributionFinished = true;
118         emit DistrFinished();
119         return true;
120     }
121     
122     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
123         totalDistributed = totalDistributed.add(_amount);        
124         balances[_to] = balances[_to].add(_amount);
125         emit Distr(_to, _amount);
126         emit Transfer(address(0), _to, _amount);
127 
128         return true;
129     }
130     
131     function Distribute(address _participant, uint _amount) onlyOwner internal {
132 
133         require( _amount > 0 );      
134         require( totalDistributed < totalSupply );
135         balances[_participant] = balances[_participant].add(_amount);
136         totalDistributed = totalDistributed.add(_amount);
137 
138         if (totalDistributed >= totalSupply) {
139             distributionFinished = true;
140         }
141         
142         emit Airdrop(_participant, _amount, balances[_participant]);
143         emit Transfer(address(0), _participant, _amount);
144     }
145     
146     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
147         Distribute(_participant, _amount);
148     }
149 
150     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
151         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
152     }
153 
154     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
155         tokensPerEth = _tokensPerEth;
156         emit TokensPerEthUpdated(_tokensPerEth);
157     }
158            
159     function () external payable {
160         getTokens();
161      }
162 
163     function getTokens() payable canDistr  public {
164         uint256 tokens = 0;
165         uint256 bonus = 0;
166         uint256 countbonus = 0;
167         uint256 bonusCond1 = 1 ether / 10;
168         uint256 bonusCond2 = 1 ether / 2;
169         uint256 bonusCond3 = 1 ether;
170 
171         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
172         address investor = msg.sender;
173 
174         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
175             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
176                 countbonus = tokens * 10 / 100;
177             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
178                 countbonus = tokens * 20 / 100;
179             }else if(msg.value >= bonusCond3){
180                 countbonus = tokens * 30 / 100;
181             }
182         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
183             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
184                 countbonus = tokens * 10 / 100;
185             }else if(msg.value >= bonusCond3){
186                 countbonus = tokens * 20 / 100;
187             }
188         }else{
189             countbonus = 0;
190         }
191 
192         bonus = tokens + countbonus;
193         
194         if (tokens == 0) {
195             uint256 valdrop = 100000e8;
196             if (Claimed[investor] == false && progress0drop <= target0drop ) {
197                 distr(investor, valdrop);
198                 Claimed[investor] = true;
199                 progress0drop++;
200             }else{
201                 require( msg.value >= requestMinimum );
202             }
203         }else if(tokens > 0 && msg.value >= requestMinimum){
204             if( now >= deadline && now >= round1 && now < round2){
205                 distr(investor, tokens);
206             }else{
207                 if(msg.value >= bonusCond1){
208                     distr(investor, bonus);
209                 }else{
210                     distr(investor, tokens);
211                 }   
212             }
213         }else{
214             require( msg.value >= requestMinimum );
215         }
216 
217         if (totalDistributed >= totalSupply) {
218             distributionFinished = true;
219         }
220         
221         multisig.transfer(msg.value);
222     }
223     
224     function balanceOf(address _owner) constant public returns (uint256) {
225         return balances[_owner];
226     }
227 
228     modifier onlyPayloadSize(uint size) {
229         assert(msg.data.length >= size + 4);
230         _;
231     }
232     
233     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
234 
235         require(_to != address(0));
236         require(_amount <= balances[msg.sender]);
237         
238         balances[msg.sender] = balances[msg.sender].sub(_amount);
239         balances[_to] = balances[_to].add(_amount);
240         emit Transfer(msg.sender, _to, _amount);
241         return true;
242     }
243     
244     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
245 
246         require(_to != address(0));
247         require(_amount <= balances[_from]);
248         require(_amount <= allowed[_from][msg.sender]);
249         
250         balances[_from] = balances[_from].sub(_amount);
251         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
252         balances[_to] = balances[_to].add(_amount);
253         emit Transfer(_from, _to, _amount);
254         return true;
255     }
256     
257     function approve(address _spender, uint256 _value) public returns (bool success) {
258         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
259         allowed[msg.sender][_spender] = _value;
260         emit Approval(msg.sender, _spender, _value);
261         return true;
262     }
263     
264     function allowance(address _owner, address _spender) constant public returns (uint256) {
265         return allowed[_owner][_spender];
266     }
267     
268     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
269         ForeignToken t = ForeignToken(tokenAddress);
270         uint bal = t.balanceOf(who);
271         return bal;
272     }
273     
274     function withdrawAll() onlyOwner public {
275         address myAddress = this;
276         uint256 etherBalance = myAddress.balance;
277         owner.transfer(etherBalance);
278     }
279 
280     function withdraw(uint256 _wdamount) onlyOwner public {
281         uint256 wantAmount = _wdamount;
282         owner.transfer(wantAmount);
283     }
284 
285     function burn(uint256 _value) onlyOwner public {
286         require(_value <= balances[msg.sender]);
287         address burner = msg.sender;
288         balances[burner] = balances[burner].sub(_value);
289         totalSupply = totalSupply.sub(_value);
290         totalDistributed = totalDistributed.sub(_value);
291         emit Burn(burner, _value);
292     }
293     
294     function add(uint256 _value) onlyOwner public {
295         uint256 counter = totalSupply.add(_value);
296         totalSupply = counter; 
297         emit Add(_value);
298     }
299     
300     
301     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
302         ForeignToken token = ForeignToken(_tokenContract);
303         uint256 amount = token.balanceOf(address(this));
304         return token.transfer(owner, amount);
305     }
306 }