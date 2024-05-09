1 pragma solidity ^0.4.25;
2 //----------------------------------------------------------------------
3 // 'Rubik Protocol' contract                                     |           
4 // Symbol      : RUB                                             |
5 // Name        : Rubik Protocol                                  |
6 // Total supply: 10,000,000,000                                  |
7 // Decimals    : 8                                               |
8 // Website     : https://rubprotocol.com                         |
9 // Copyright (c) 2018 Rubik Protocol                             |
10 //----------------------------------------------------------------------
11 
12 library SafeMath {
13     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         if (a == 0) {
15             return 0;
16         }
17         c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     function div(uint256 a, uint256 b) internal pure returns (uint256) {
23         // assert(b > 0); // Solidity automatically throws when dividing by 0
24         // uint256 c = a / b;
25         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26         return a / b;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         assert(b <= a);
31         return a - b;
32     }
33 
34     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
35         c = a + b;
36         assert(c >= a);
37         return c;
38     }
39 }
40 
41 contract ForeignToken {
42     function balanceOf(address _owner) constant public returns (uint256);
43     function transfer(address _to, uint256 _value) public returns (bool);
44 }
45 
46 contract ERC20Basic {
47     uint256 public totalSupply;
48     function balanceOf(address who) public constant returns (uint256);
49     function transfer(address to, uint256 value) public returns (bool);
50     event Transfer(address indexed from, address indexed to, uint256 value);
51 }
52 
53 contract ERC20 is ERC20Basic {
54     function allowance(address owner, address spender) public constant returns (uint256);
55     function transferFrom(address from, address to, uint256 value) public returns (bool);
56     function approve(address spender, uint256 value) public returns (bool);
57     event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 contract RubikProtocol is ERC20 {
61     
62     using SafeMath for uint256;
63     address owner = msg.sender;
64 
65     mapping (address => uint256) balances;
66     mapping (address => mapping (address => uint256)) allowed;
67     mapping (address => bool) public Claimed; 
68 
69     string public constant name = "Rubik Protocol";
70     string public constant symbol = "RUB";
71     uint public constant decimals = 8;
72     uint public deadline = now + 40 * 1 days;
73     uint public round2 = now + 20 * 1 days;
74     uint public round1 = now + 15 * 1 days;
75     
76     uint256 public totalSupply = 10000000000e8;
77     uint256 public totalDistributed;
78     uint256 public constant requestMinimum = 1 ether / 100; // 0.01 Ether
79     uint256 public tokensPerEth = 10000000e8;
80     
81     uint public target0drop = 40000;
82     uint public progress0drop = 0;
83     
84     address multisig = 0x460BE721deB36B617DE80Fe116938662d10ac7aA;
85 
86 
87     event Transfer(address indexed _from, address indexed _to, uint256 _value);
88     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
89     
90     event Distr(address indexed to, uint256 amount);
91     event DistrFinished();
92     
93     event Airdrop(address indexed _owner, uint _amount, uint _balance);
94 
95     event TokensPerEthUpdated(uint _tokensPerEth);
96     
97     event Burn(address indexed burner, uint256 value);
98     
99     event Add(uint256 value);
100 
101     bool public distributionFinished = false;
102     
103     modifier canDistr() {
104         require(!distributionFinished);
105         _;
106     }
107     
108     modifier onlyOwner() {
109         require(msg.sender == owner);
110         _;
111     }
112     
113     constructor() public {
114         uint256 teamFund = 3500000000e8;
115         owner = msg.sender;
116         distr(owner, teamFund);
117     }
118     
119     function transferOwnership(address newOwner) onlyOwner public {
120         if (newOwner != address(0)) {
121             owner = newOwner;
122         }
123     }
124 
125     function finishDistribution() onlyOwner canDistr public returns (bool) {
126         distributionFinished = true;
127         emit DistrFinished();
128         return true;
129     }
130     
131     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
132         totalDistributed = totalDistributed.add(_amount);        
133         balances[_to] = balances[_to].add(_amount);
134         emit Distr(_to, _amount);
135         emit Transfer(address(0), _to, _amount);
136 
137         return true;
138     }
139     
140     function Distribute(address _participant, uint _amount) onlyOwner internal {
141 
142         require( _amount > 0 );      
143         require( totalDistributed < totalSupply );
144         balances[_participant] = balances[_participant].add(_amount);
145         totalDistributed = totalDistributed.add(_amount);
146 
147         if (totalDistributed >= totalSupply) {
148             distributionFinished = true;
149         }
150         
151         emit Airdrop(_participant, _amount, balances[_participant]);
152         emit Transfer(address(0), _participant, _amount);
153     }
154     
155     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
156         Distribute(_participant, _amount);
157     }
158 
159     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
160         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
161     }
162 
163     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
164         tokensPerEth = _tokensPerEth;
165         emit TokensPerEthUpdated(_tokensPerEth);
166     }
167            
168     function () external payable {
169         getTokens();
170      }
171 
172     function getTokens() payable canDistr  public {
173         uint256 tokens = 0;
174         uint256 bonus = 0;
175         uint256 countbonus = 0;
176         uint256 bonusPha1 = 1 ether / 2;
177         uint256 bonusPha2 = 1 ether;
178         uint256 bonusPha3 = 3 ether;
179 
180         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
181         address investor = msg.sender;
182 
183         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
184             if(msg.value >= bonusPha1 && msg.value < bonusPha2){
185                 countbonus = tokens * 5 / 100;
186             }else if(msg.value >= bonusPha2 && msg.value < bonusPha3){
187                 countbonus = tokens * 10 / 100;
188             }else if(msg.value >= bonusPha3){
189                 countbonus = tokens * 15 / 100;
190             }
191         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
192             if(msg.value >= bonusPha2 && msg.value < bonusPha3){
193                 countbonus = tokens * 0 / 100;
194             }else if(msg.value >= bonusPha3){
195                 countbonus = tokens * 5 / 100;
196             }
197         }else{
198             countbonus = 0;
199         }
200 
201         bonus = tokens + countbonus;
202         
203         if (tokens == 0) {
204             uint256 valdrop = 3000e8;
205             if (Claimed[investor] == false && progress0drop <= target0drop ) {
206                 distr(investor, valdrop);
207                 Claimed[investor] = true;
208                 progress0drop++;
209             }else{
210                 require( msg.value >= requestMinimum );
211             }
212         }else if(tokens > 0 && msg.value >= requestMinimum){
213             if( now >= deadline && now >= round1 && now < round2){
214                 distr(investor, tokens);
215             }else{
216                 if(msg.value >= bonusPha1){
217                     distr(investor, bonus);
218                 }else{
219                     distr(investor, tokens);
220                 }   
221             }
222         }else{
223             require( msg.value >= requestMinimum );
224         }
225 
226         if (totalDistributed >= totalSupply) {
227             distributionFinished = true;
228         }
229         
230         multisig.transfer(msg.value);
231     }
232     
233     function balanceOf(address _owner) constant public returns (uint256) {
234         return balances[_owner];
235     }
236 
237     modifier onlyPayloadSize(uint size) {
238         assert(msg.data.length >= size + 4);
239         _;
240     }
241     
242     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
243 
244         require(_to != address(0));
245         require(_amount <= balances[msg.sender]);
246         
247         balances[msg.sender] = balances[msg.sender].sub(_amount);
248         balances[_to] = balances[_to].add(_amount);
249         emit Transfer(msg.sender, _to, _amount);
250         return true;
251     }
252     
253     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
254 
255         require(_to != address(0));
256         require(_amount <= balances[_from]);
257         require(_amount <= allowed[_from][msg.sender]);
258         
259         balances[_from] = balances[_from].sub(_amount);
260         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
261         balances[_to] = balances[_to].add(_amount);
262         emit Transfer(_from, _to, _amount);
263         return true;
264     }
265     
266     function approve(address _spender, uint256 _value) public returns (bool success) {
267         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
268         allowed[msg.sender][_spender] = _value;
269         emit Approval(msg.sender, _spender, _value);
270         return true;
271     }
272     
273     function allowance(address _owner, address _spender) constant public returns (uint256) {
274         return allowed[_owner][_spender];
275     }
276     
277     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
278         ForeignToken t = ForeignToken(tokenAddress);
279         uint bal = t.balanceOf(who);
280         return bal;
281     }
282     
283     function withdrawAll() onlyOwner public {
284         address myAddress = this;
285         uint256 etherBalance = myAddress.balance;
286         owner.transfer(etherBalance);
287     }
288 
289     function withdraw(uint256 _wdamount) onlyOwner public {
290         uint256 wantAmount = _wdamount;
291         owner.transfer(wantAmount);
292     }
293 
294     function burn(uint256 _value) onlyOwner public {
295         require(_value <= balances[msg.sender]);
296         address burner = msg.sender;
297         balances[burner] = balances[burner].sub(_value);
298         totalSupply = totalSupply.sub(_value);
299         totalDistributed = totalDistributed.sub(_value);
300         emit Burn(burner, _value);
301     }
302     
303     function add(uint256 _value) onlyOwner public {
304         uint256 counter = totalSupply.add(_value);
305         totalSupply = counter; 
306         emit Add(_value);
307     }
308     
309     
310     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
311         ForeignToken token = ForeignToken(_tokenContract);
312         uint256 amount = token.balanceOf(address(this));
313         return token.transfer(owner, amount);
314     }
315 }