1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // 'Tokyo Exchanger Coin'
5 //
6 // NAME     : Tokyo Exchanger Coin
7 // Symbol   : TOKEX
8 // Total supply: 15,000,000
9 // Decimals    : 8
10 //
11 // (c) TOKEX TEAM 2018 
12 // -----------------------------------------------------------------------------
13 
14 library SafeMath {
15     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16         if (a == 0) {
17             return 0;
18         }
19         c = a * b;
20         assert(c / a == b);
21         return c;
22     }
23 
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         assert(b <= a);
33         return a - b;
34     }
35 
36     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
37         c = a + b;
38         assert(c >= a);
39         return c;
40     }
41 }
42 
43 contract ForeignToken {
44     function balanceOf(address _owner) constant public returns (uint256);
45     function transfer(address _to, uint256 _value) public returns (bool);
46 }
47 
48 contract ERC20Basic {
49     uint256 public totalSupply;
50     function balanceOf(address who) public constant returns (uint256);
51     function transfer(address to, uint256 value) public returns (bool);
52     event Transfer(address indexed from, address indexed to, uint256 value);
53 }
54 
55 contract ERC20 is ERC20Basic {
56     function allowance(address owner, address spender) public constant returns (uint256);
57     function transferFrom(address from, address to, uint256 value) public returns (bool);
58     function approve(address spender, uint256 value) public returns (bool);
59     event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 
62 contract TokyoExchangerCoin is ERC20 {
63     
64     using SafeMath for uint256;
65     address owner = msg.sender;
66 
67     mapping (address => uint256) balances;
68     mapping (address => mapping (address => uint256)) allowed;
69     mapping (address => bool) public Claimed; 
70 
71     string public constant name = "Tokyo Exchanger Coin";
72     string public constant symbol = "TOKEX";
73     uint public constant decimals = 8;
74     uint public deadline = now + 35 * 1 days;
75     uint public round2 = now + 35 * 1 days;
76     uint public round1 = now + 30 * 1 days;
77     
78     uint256 public totalSupply = 15000000e8;
79     uint256 public totalDistributed;
80     uint256 public constant requestMinimum = 1 ether / 20; // 0.05 Ether
81     uint256 public tokensPerEth = 10000e8;
82     
83     uint public target0drop = 50000;
84     uint public progress0drop = 0;
85     
86     address multisig = 0xCf7Ac628f8A0fa38059BF77b0134efaD8bF329A3;
87 
88 
89     event Transfer(address indexed _from, address indexed _to, uint256 _value);
90     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
91     
92     event Distr(address indexed to, uint256 amount);
93     event DistrFinished();
94     
95     event Airdrop(address indexed _owner, uint _amount, uint _balance);
96 
97     event TokensPerEthUpdated(uint _tokensPerEth);
98     
99     event Burn(address indexed burner, uint256 value);
100     
101     event Add(uint256 value);
102 
103     bool public distributionFinished = false;
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
115     constructor() public {
116         uint256 teamFund = 1000000e8;
117         owner = msg.sender;
118         distr(owner, teamFund);
119     }
120     
121     function transferOwnership(address newOwner) onlyOwner public {
122         if (newOwner != address(0)) {
123             owner = newOwner;
124         }
125     }
126 
127     function finishDistribution() onlyOwner canDistr public returns (bool) {
128         distributionFinished = true;
129         emit DistrFinished();
130         return true;
131     }
132     
133     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
134         totalDistributed = totalDistributed.add(_amount);        
135         balances[_to] = balances[_to].add(_amount);
136         emit Distr(_to, _amount);
137         emit Transfer(address(0), _to, _amount);
138 
139         return true;
140     }
141     
142     function Distribute(address _participant, uint _amount) onlyOwner internal {
143 
144         require( _amount > 0 );      
145         require( totalDistributed < totalSupply );
146         balances[_participant] = balances[_participant].add(_amount);
147         totalDistributed = totalDistributed.add(_amount);
148 
149         if (totalDistributed >= totalSupply) {
150             distributionFinished = true;
151         }
152         
153         emit Airdrop(_participant, _amount, balances[_participant]);
154         emit Transfer(address(0), _participant, _amount);
155     }
156     
157     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
158         Distribute(_participant, _amount);
159     }
160 
161     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
162         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
163     }
164 
165     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
166         tokensPerEth = _tokensPerEth;
167         emit TokensPerEthUpdated(_tokensPerEth);
168     }
169            
170     function () external payable {
171         getTokens();
172      }
173 
174     function getTokens() payable canDistr  public {
175         uint256 tokens = 0;
176         uint256 bonus = 0;
177         uint256 countbonus = 0;
178         uint256 bonusCond1 = 1 ether / 2;
179         uint256 bonusCond2 = 1 ether;
180         uint256 bonusCond3 = 3 ether;
181 
182         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
183         address investor = msg.sender;
184 
185         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
186             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
187                 countbonus = tokens * 0 / 100;
188             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
189                 countbonus = tokens * 25 / 100;
190             }else if(msg.value >= bonusCond3){
191                 countbonus = tokens * 50 / 100;
192             }
193         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
194             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
195                 countbonus = tokens * 25 / 100;
196             }else if(msg.value >= bonusCond3){
197                 countbonus = tokens * 50 / 100;
198             }
199         }else{
200             countbonus = 0;
201         }
202 
203         bonus = tokens + countbonus;
204         
205         if (tokens == 0) {
206             uint256 valdrop = 1e8;
207             if (Claimed[investor] == false && progress0drop <= target0drop ) {
208                 distr(investor, valdrop);
209                 Claimed[investor] = true;
210                 progress0drop++;
211             }else{
212                 require( msg.value >= requestMinimum );
213             }
214         }else if(tokens > 0 && msg.value >= requestMinimum){
215             if( now >= deadline && now >= round1 && now < round2){
216                 distr(investor, tokens);
217             }else{
218                 if(msg.value >= bonusCond1){
219                     distr(investor, bonus);
220                 }else{
221                     distr(investor, tokens);
222                 }   
223             }
224         }else{
225             require( msg.value >= requestMinimum );
226         }
227 
228         if (totalDistributed >= totalSupply) {
229             distributionFinished = true;
230         }
231         
232         multisig.transfer(msg.value);
233     }
234     
235     function balanceOf(address _owner) constant public returns (uint256) {
236         return balances[_owner];
237     }
238 
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
269         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
270         allowed[msg.sender][_spender] = _value;
271         emit Approval(msg.sender, _spender, _value);
272         return true;
273     }
274     
275     function allowance(address _owner, address _spender) constant public returns (uint256) {
276         return allowed[_owner][_spender];
277     }
278     
279     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
280         ForeignToken t = ForeignToken(tokenAddress);
281         uint bal = t.balanceOf(who);
282         return bal;
283     }
284     
285     function withdrawAll() onlyOwner public {
286         address myAddress = this;
287         uint256 etherBalance = myAddress.balance;
288         owner.transfer(etherBalance);
289     }
290 
291     function withdraw(uint256 _wdamount) onlyOwner public {
292         uint256 wantAmount = _wdamount;
293         owner.transfer(wantAmount);
294     }
295 
296     function burn(uint256 _value) onlyOwner public {
297         require(_value <= balances[msg.sender]);
298         address burner = msg.sender;
299         balances[burner] = balances[burner].sub(_value);
300         totalSupply = totalSupply.sub(_value);
301         totalDistributed = totalDistributed.sub(_value);
302         emit Burn(burner, _value);
303     }
304     
305     function add(uint256 _value) onlyOwner public {
306         uint256 counter = totalSupply.add(_value);
307         totalSupply = counter; 
308         emit Add(_value);
309     }
310     
311     
312     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
313         ForeignToken token = ForeignToken(_tokenContract);
314         uint256 amount = token.balanceOf(address(this));
315         return token.transfer(owner, amount);
316     }
317 }