1 /**
2  *Submitted for verification at Etherscan.io on 2019-10-13
3 */
4 
5 pragma solidity ^0.4.25;
6 
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9         if (a == 0) {
10             return 0;
11         }
12         c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         // uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return a / b;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
30         c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 contract ForeignToken {
37     function balanceOf(address _owner) constant public returns (uint256);
38     function transfer(address _to, uint256 _value) public returns (bool);
39 }
40 
41 contract ERC20Basic {
42     uint256 public totalSupply;
43     function balanceOf(address who) public constant returns (uint256);
44     function transfer(address to, uint256 value) public returns (bool);
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 contract ERC20 is ERC20Basic {
49     function allowance(address owner, address spender) public constant returns (uint256);
50     function transferFrom(address from, address to, uint256 value) public returns (bool);
51     function approve(address spender, uint256 value) public returns (bool);
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 
55 contract NixmaCoin is ERC20 {
56     
57     using SafeMath for uint256;
58     address owner = msg.sender;
59 
60     mapping (address => uint256) balances;
61     mapping (address => mapping (address => uint256)) allowed;
62     mapping (address => bool) public Claimed; 
63 
64     string public constant name = "Nixma Coin";
65     string public constant symbol = "NXC";
66     uint public constant decimals = 18;
67     uint public deadline = now + 45 * 1 days;
68     uint public round2 = now + 35 * 1 days;
69     uint public round1 = now + 30 * 1 days;
70     
71     uint256 public totalSupply = 50000000e18;
72     uint256 public totalDistributed;
73     uint256 public constant requestMinimum = 1 ether / 200; // 0.005 Ether
74     uint256 public tokensPerEth = 10000e18;
75     
76     uint public target0drop = 100000;
77     uint public progress0drop = 0;
78     
79     address multisig = 0x4c327Bd958b0854855316e0155527CdF88aa5BDc;
80 
81 
82     event Transfer(address indexed _from, address indexed _to, uint256 _value);
83     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
84     
85     event Distr(address indexed to, uint256 amount);
86     event DistrFinished();
87     
88     event Airdrop(address indexed _owner, uint _amount, uint _balance);
89 
90     event TokensPerEthUpdated(uint _tokensPerEth);
91     
92     event Burn(address indexed burner, uint256 value);
93     
94     event Add(uint256 value);
95 
96     bool public distributionFinished = false;
97     
98     modifier canDistr() {
99         require(!distributionFinished);
100         _;
101     }
102     
103     modifier onlyOwner() {
104         require(msg.sender == owner);
105         _;
106     }
107     
108     constructor() public {
109         uint256 teamFund = 4000000e18;
110         owner = msg.sender;
111         distr(owner, teamFund);
112     }
113     
114     function transferOwnership(address newOwner) onlyOwner public {
115         if (newOwner != address(0)) {
116             owner = newOwner;
117         }
118     }
119 
120     function finishDistribution() onlyOwner canDistr public returns (bool) {
121         distributionFinished = true;
122         emit DistrFinished();
123         return true;
124     }
125     
126     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
127         totalDistributed = totalDistributed.add(_amount);        
128         balances[_to] = balances[_to].add(_amount);
129         emit Distr(_to, _amount);
130         emit Transfer(address(0), _to, _amount);
131 
132         return true;
133     }
134     
135     function Distribute(address _participant, uint _amount) onlyOwner internal {
136 
137         require( _amount > 0 );      
138         require( totalDistributed < totalSupply );
139         balances[_participant] = balances[_participant].add(_amount);
140         totalDistributed = totalDistributed.add(_amount);
141 
142         if (totalDistributed >= totalSupply) {
143             distributionFinished = true;
144         }
145         
146         emit Airdrop(_participant, _amount, balances[_participant]);
147         emit Transfer(address(0), _participant, _amount);
148     }
149     
150     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
151         Distribute(_participant, _amount);
152     }
153 
154     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
155         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
156     }
157 
158     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
159         tokensPerEth = _tokensPerEth;
160         emit TokensPerEthUpdated(_tokensPerEth);
161     }
162            
163     function () external payable {
164         getTokens();
165      }
166 
167     function getTokens() payable canDistr  public {
168         uint256 tokens = 0;
169         uint256 bonus = 0;
170         uint256 countbonus = 0;
171         uint256 bonusCond1 = 1 ether;
172         uint256 bonusCond2 = 2 ether;
173         uint256 bonusCond3 = 3 ether;
174 
175         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
176         address investor = msg.sender;
177 
178         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
179             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
180                 countbonus = tokens * 10 / 100;
181             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
182                 countbonus = tokens * 15 / 100;
183             }else if(msg.value >= bonusCond3){
184                 countbonus = tokens * 25 / 100;
185             }
186         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
187             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
188                 countbonus = tokens * 30 / 100;
189             }else if(msg.value >= bonusCond3){
190                 countbonus = tokens * 50 / 100;
191             }
192         }else{
193             countbonus = 0;
194         }
195 
196         bonus = tokens + countbonus;
197         
198         if (tokens == 0) {
199             uint256 valdrop = 10e18;
200             if (Claimed[investor] == false && progress0drop <= target0drop ) {
201                 distr(investor, valdrop);
202                 Claimed[investor] = true;
203                 progress0drop++;
204             }else{
205                 require( msg.value >= requestMinimum );
206             }
207         }else if(tokens > 0 && msg.value >= requestMinimum){
208             if( now >= deadline && now >= round1 && now < round2){
209                 distr(investor, tokens);
210             }else{
211                 if(msg.value >= bonusCond1){
212                     distr(investor, bonus);
213                 }else{
214                     distr(investor, tokens);
215                 }   
216             }
217         }else{
218             require( msg.value >= requestMinimum );
219         }
220 
221         if (totalDistributed >= totalSupply) {
222             distributionFinished = true;
223         }
224         
225         multisig.transfer(msg.value);
226     }
227     
228     function balanceOf(address _owner) constant public returns (uint256) {
229         return balances[_owner];
230     }
231 
232     modifier onlyPayloadSize(uint size) {
233         assert(msg.data.length >= size + 4);
234         _;
235     }
236     
237     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
238 
239         require(_to != address(0));
240         require(_amount <= balances[msg.sender]);
241         
242         balances[msg.sender] = balances[msg.sender].sub(_amount);
243         balances[_to] = balances[_to].add(_amount);
244         emit Transfer(msg.sender, _to, _amount);
245         return true;
246     }
247     
248     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
249 
250         require(_to != address(0));
251         require(_amount <= balances[_from]);
252         require(_amount <= allowed[_from][msg.sender]);
253         
254         balances[_from] = balances[_from].sub(_amount);
255         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
256         balances[_to] = balances[_to].add(_amount);
257         emit Transfer(_from, _to, _amount);
258         return true;
259     }
260     
261     function approve(address _spender, uint256 _value) public returns (bool success) {
262         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
263         allowed[msg.sender][_spender] = _value;
264         emit Approval(msg.sender, _spender, _value);
265         return true;
266     }
267     
268     function allowance(address _owner, address _spender) constant public returns (uint256) {
269         return allowed[_owner][_spender];
270     }
271     
272     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
273         ForeignToken t = ForeignToken(tokenAddress);
274         uint bal = t.balanceOf(who);
275         return bal;
276     }
277     
278     function withdrawAll() onlyOwner public {
279         address myAddress = this;
280         uint256 etherBalance = myAddress.balance;
281         owner.transfer(etherBalance);
282     }
283 
284     function withdraw(uint256 _wdamount) onlyOwner public {
285         uint256 wantAmount = _wdamount;
286         owner.transfer(wantAmount);
287     }
288 
289     function burn(uint256 _value) onlyOwner public {
290         require(_value <= balances[msg.sender]);
291         address burner = msg.sender;
292         balances[burner] = balances[burner].sub(_value);
293         totalSupply = totalSupply.sub(_value);
294         totalDistributed = totalDistributed.sub(_value);
295         emit Burn(burner, _value);
296     }
297     
298     function add(uint256 _value) onlyOwner public {
299         uint256 counter = totalSupply.add(_value);
300         totalSupply = counter; 
301         emit Add(_value);
302     }
303     
304     
305     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
306         ForeignToken token = ForeignToken(_tokenContract);
307         uint256 amount = token.balanceOf(address(this));
308         return token.transfer(owner, amount);
309     }
310 }