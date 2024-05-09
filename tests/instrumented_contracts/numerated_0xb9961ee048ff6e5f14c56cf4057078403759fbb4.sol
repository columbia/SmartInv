1 /**
2  *Submitted for verification at Etherscan.io on 2020
3 */
4 
5 pragma solidity ^0.4.25;
6 
7 // ----------------------------------------------------------------------------
8 // 'Bitcoin GEN'
9 //
10 // NAME     : Bitcoin GEN
11 // Symbol   : BTCG
12 // Total supply: 21,000,000
13 // Decimals    : 8
14 //
15 // (c) Bitcoin GEN 2020 
16 // -----------------------------------------------------------------------------
17 
18 library SafeMath {
19     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         if (a == 0) {
21             return 0;
22         }
23         c = a * b;
24         assert(c / a == b);
25         return c;
26     }
27 
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
41         c = a + b;
42         assert(c >= a);
43         return c;
44     }
45 }
46 
47 contract ForeignToken {
48     function balanceOf(address _owner) constant public returns (uint256);
49     function transfer(address _to, uint256 _value) public returns (bool);
50 }
51 
52 contract ERC20Basic {
53     uint256 public totalSupply;
54     function balanceOf(address who) public constant returns (uint256);
55     function transfer(address to, uint256 value) public returns (bool);
56     event Transfer(address indexed from, address indexed to, uint256 value);
57 }
58 
59 contract ERC20 is ERC20Basic {
60     function allowance(address owner, address spender) public constant returns (uint256);
61     function transferFrom(address from, address to, uint256 value) public returns (bool);
62     function approve(address spender, uint256 value) public returns (bool);
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 contract BitcoinGEN is ERC20 {
67     
68     using SafeMath for uint256;
69     address owner = msg.sender;
70 
71     mapping (address => uint256) balances;
72     mapping (address => mapping (address => uint256)) allowed;
73     mapping (address => bool) public Claimed; 
74 
75     string public constant name = "Bitcoin GEN";
76     string public constant symbol = "BTCG";
77     uint public constant decimals = 8;
78     uint public deadline = now + 35 * 1 days;
79     uint public round2 = now + 35 * 1 days;
80     uint public round1 = now + 30 * 1 days;
81     
82     uint256 public totalSupply = 21000000e8;
83     uint256 public totalDistributed;
84     uint256 public constant requestMinimum = 1 ether / 50; // 0.02 Ether
85     uint256 public tokensPerEth = 2500e8;
86     
87     uint public target0drop = 50000;
88     uint public progress0drop = 0;
89     
90     address multisig = 0xB4A5a3c9929BB600C949780c5A5382AB51A6D70c;
91 
92 
93     event Transfer(address indexed _from, address indexed _to, uint256 _value);
94     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
95     
96     event Distr(address indexed to, uint256 amount);
97     event DistrFinished();
98     
99     event Airdrop(address indexed _owner, uint _amount, uint _balance);
100 
101     event TokensPerEthUpdated(uint _tokensPerEth);
102     
103     event Burn(address indexed burner, uint256 value);
104     
105     event Add(uint256 value);
106 
107     bool public distributionFinished = false;
108     
109     modifier canDistr() {
110         require(!distributionFinished);
111         _;
112     }
113     
114     modifier onlyOwner() {
115         require(msg.sender == owner);
116         _;
117     }
118     
119     constructor() public {
120         uint256 teamFund = 0e8;
121         owner = msg.sender;
122         distr(owner, teamFund);
123     }
124     
125     function transferOwnership(address newOwner) onlyOwner public {
126         if (newOwner != address(0)) {
127             owner = newOwner;
128         }
129     }
130 
131     function finishDistribution() onlyOwner canDistr public returns (bool) {
132         distributionFinished = true;
133         emit DistrFinished();
134         return true;
135     }
136     
137     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
138         totalDistributed = totalDistributed.add(_amount);        
139         balances[_to] = balances[_to].add(_amount);
140         emit Distr(_to, _amount);
141         emit Transfer(address(0), _to, _amount);
142 
143         return true;
144     }
145     
146     function Distribute(address _participant, uint _amount) onlyOwner internal {
147 
148         require( _amount > 0 );      
149         require( totalDistributed < totalSupply );
150         balances[_participant] = balances[_participant].add(_amount);
151         totalDistributed = totalDistributed.add(_amount);
152 
153         if (totalDistributed >= totalSupply) {
154             distributionFinished = true;
155         }
156         
157         emit Airdrop(_participant, _amount, balances[_participant]);
158         emit Transfer(address(0), _participant, _amount);
159     }
160     
161     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
162         Distribute(_participant, _amount);
163     }
164 
165     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
166         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
167     }
168 
169     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
170         tokensPerEth = _tokensPerEth;
171         emit TokensPerEthUpdated(_tokensPerEth);
172     }
173            
174     function () external payable {
175         getTokens();
176      }
177 
178     function getTokens() payable canDistr  public {
179         uint256 tokens = 0;
180         uint256 bonus = 0;
181         uint256 countbonus = 0;
182         uint256 bonusCond1 = 1 ether / 2;
183         uint256 bonusCond2 = 1 ether;
184         uint256 bonusCond3 = 3 ether;
185 
186         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
187         address investor = msg.sender;
188 
189         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
190             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
191                 countbonus = tokens * 10 / 100;
192             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
193                 countbonus = tokens * 50 / 100;
194             }else if(msg.value >= bonusCond3){
195                 countbonus = tokens * 75 / 100;
196             }
197         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
198             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
199                 countbonus = tokens * 25 / 100;
200             }else if(msg.value >= bonusCond3){
201                 countbonus = tokens * 50 / 100;
202             }
203         }else{
204             countbonus = 0;
205         }
206 
207         bonus = tokens + countbonus;
208         
209         if (tokens == 0) {
210             uint256 valdrop = 10e8;
211             if (Claimed[investor] == false && progress0drop <= target0drop ) {
212                 distr(investor, valdrop);
213                 Claimed[investor] = true;
214                 progress0drop++;
215             }else{
216                 require( msg.value >= requestMinimum );
217             }
218         }else if(tokens > 0 && msg.value >= requestMinimum){
219             if( now >= deadline && now >= round1 && now < round2){
220                 distr(investor, tokens);
221             }else{
222                 if(msg.value >= bonusCond1){
223                     distr(investor, bonus);
224                 }else{
225                     distr(investor, tokens);
226                 }   
227             }
228         }else{
229             require( msg.value >= requestMinimum );
230         }
231 
232         if (totalDistributed >= totalSupply) {
233             distributionFinished = true;
234         }
235         
236         multisig.transfer(msg.value);
237     }
238     
239     function balanceOf(address _owner) constant public returns (uint256) {
240         return balances[_owner];
241     }
242 
243     modifier onlyPayloadSize(uint size) {
244         assert(msg.data.length >= size + 4);
245         _;
246     }
247     
248     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
249 
250         require(_to != address(0));
251         require(_amount <= balances[msg.sender]);
252         
253         balances[msg.sender] = balances[msg.sender].sub(_amount);
254         balances[_to] = balances[_to].add(_amount);
255         emit Transfer(msg.sender, _to, _amount);
256         return true;
257     }
258     
259     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
260 
261         require(_to != address(0));
262         require(_amount <= balances[_from]);
263         require(_amount <= allowed[_from][msg.sender]);
264         
265         balances[_from] = balances[_from].sub(_amount);
266         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
267         balances[_to] = balances[_to].add(_amount);
268         emit Transfer(_from, _to, _amount);
269         return true;
270     }
271     
272     function approve(address _spender, uint256 _value) public returns (bool success) {
273         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
274         allowed[msg.sender][_spender] = _value;
275         emit Approval(msg.sender, _spender, _value);
276         return true;
277     }
278     
279     function allowance(address _owner, address _spender) constant public returns (uint256) {
280         return allowed[_owner][_spender];
281     }
282     
283     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
284         ForeignToken t = ForeignToken(tokenAddress);
285         uint bal = t.balanceOf(who);
286         return bal;
287     }
288     
289     function withdrawAll() onlyOwner public {
290         address myAddress = this;
291         uint256 etherBalance = myAddress.balance;
292         owner.transfer(etherBalance);
293     }
294 
295     function withdraw(uint256 _wdamount) onlyOwner public {
296         uint256 wantAmount = _wdamount;
297         owner.transfer(wantAmount);
298     }
299 
300     function burn(uint256 _value) onlyOwner public {
301         require(_value <= balances[msg.sender]);
302         address burner = msg.sender;
303         balances[burner] = balances[burner].sub(_value);
304         totalSupply = totalSupply.sub(_value);
305         totalDistributed = totalDistributed.sub(_value);
306         emit Burn(burner, _value);
307     }
308     
309     function add(uint256 _value) onlyOwner public {
310         uint256 counter = totalSupply.add(_value);
311         totalSupply = counter; 
312         emit Add(_value);
313     }
314     
315     
316     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
317         ForeignToken token = ForeignToken(_tokenContract);
318         uint256 amount = token.balanceOf(address(this));
319         return token.transfer(owner, amount);
320     }
321 }