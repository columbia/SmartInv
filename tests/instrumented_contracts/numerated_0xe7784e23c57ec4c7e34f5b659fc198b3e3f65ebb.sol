1 /**
2  *Submitted for verification at Etherscan.io on 2019-08-06
3 */
4 
5 pragma solidity ^0.4.25;
6 /**
7  //This Contract Migration From SmokeCoin(you can Check OldContract https://etherscan.io/token/0x84ff1ecf963dbe51a91c7310edce3a4243da3370)
8 //SmokeCoin Lincense by SmokeCoin
9 //Website (https://www.SmokeCoin.xyz)
10 //
11 /**
12 
13 /**
14  * @title  Project
15  * SmokeCoinV_2
16  * this migration From SmokeCoin
17  */
18 library SafeMath {
19 
20     /**
21     * @dev Multiplies two numbers, throws on overflow.
22     */
23     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
24         if (a == 0) {
25             return 0;
26         }
27         c = a * b;
28         assert(c / a == b);
29         return c;
30     }
31 
32     /**
33     * @dev Integer division of two numbers, truncating the quotient.
34     */
35     function div(uint256 a, uint256 b) internal pure returns (uint256) {
36         // assert(b > 0); // Solidity automatically throws when dividing by 0
37         // uint256 c = a / b;
38         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39         return a / b;
40     }
41 
42     /**
43     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
44     */
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         assert(b <= a);
47         return a - b;
48     }
49 
50     /**
51     * @dev Adds two numbers, throws on overflow.
52     */
53     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
54         c = a + b;
55         assert(c >= a);
56         return c;
57     }
58 }
59 
60 contract ForeignToken {
61     function balanceOf(address _owner) constant public returns (uint256);
62     function transfer(address _to, uint256 _value) public returns (bool);
63 }
64 
65 contract ERC20Basic {
66     uint256 public totalSupply;
67     function balanceOf(address who) public constant returns (uint256);
68     function transfer(address to, uint256 value) public returns (bool);
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 }
71 
72 contract ERC20 is ERC20Basic {
73     function allowance(address owner, address spender) public constant returns (uint256);
74     function transferFrom(address from, address to, uint256 value) public returns (bool);
75     function approve(address spender, uint256 value) public returns (bool);
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 contract ILLUSION is ERC20 {
80     
81     using SafeMath for uint256;
82     address owner = msg.sender;
83 
84     mapping (address => uint256) balances;
85     mapping (address => mapping (address => uint256)) allowed;
86     mapping (address => bool) public Claimed; 
87 
88     string public constant name = "ILLUSION TOKEN";
89     string public constant symbol = "ILT";
90     uint public constant decimals = 8;
91     uint public deadline = now + 200 * 1 days;
92     uint public round2 = now + 50 * 1 days;
93     uint public round1 = now + 150 * 1 days;
94     
95     uint256 public totalSupply = 10000000e8;
96     uint256 public totalDistributed;
97     uint256 public constant requestMinimum = 1 ether / 1000; // 0.001 Ether
98     uint256 public tokensPerEth = 3000e8;
99     
100     uint public target0drop = 10000;
101     uint public progress0drop = 0;
102     
103     //here u will write your ether address
104     address multisig = 0x91C011bEc0990b1C972C3f8386D7d42745Dfdc88;
105 
106 
107     event Transfer(address indexed _from, address indexed _to, uint256 _value);
108     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
109     
110     event Distr(address indexed to, uint256 amount);
111     event DistrFinished();
112     
113     event Airdrop(address indexed _owner, uint _amount, uint _balance);
114 
115     event TokensPerEthUpdated(uint _tokensPerEth);
116     
117     event Burn(address indexed burner, uint256 value);
118     
119     event Add(uint256 value);
120 
121     bool public distributionFinished = false;
122     
123     modifier canDistr() {
124         require(!distributionFinished);
125         _;
126     }
127     
128     modifier onlyOwner() {
129         require(msg.sender == owner);
130         _;
131     }
132     
133     constructor() public {
134         uint256 teamFund = 3000000e8;
135         owner = msg.sender;
136         distr(owner, teamFund);
137     }
138     
139     function transferOwnership(address newOwner) onlyOwner public {
140         if (newOwner != address(0)) {
141             owner = newOwner;
142         }
143     }
144 
145     function finishDistribution() onlyOwner canDistr public returns (bool) {
146         distributionFinished = true;
147         emit DistrFinished();
148         return true;
149     }
150     
151     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
152         totalDistributed = totalDistributed.add(_amount);        
153         balances[_to] = balances[_to].add(_amount);
154         emit Distr(_to, _amount);
155         emit Transfer(address(0), _to, _amount);
156 
157         return true;
158     }
159     
160     function Distribute(address _participant, uint _amount) onlyOwner internal {
161 
162         require( _amount > 0 );      
163         require( totalDistributed < totalSupply );
164         balances[_participant] = balances[_participant].add(_amount);
165         totalDistributed = totalDistributed.add(_amount);
166 
167         if (totalDistributed >= totalSupply) {
168             distributionFinished = true;
169         }
170 
171         // log
172         emit Airdrop(_participant, _amount, balances[_participant]);
173         emit Transfer(address(0), _participant, _amount);
174     }
175     
176     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
177         Distribute(_participant, _amount);
178     }
179 
180     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
181         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
182     }
183 
184     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
185         tokensPerEth = _tokensPerEth;
186         emit TokensPerEthUpdated(_tokensPerEth);
187     }
188            
189     function () external payable {
190         getTokens();
191      }
192 
193     function getTokens() payable canDistr  public {
194         uint256 tokens = 0;
195         uint256 bonus = 0;
196         uint256 countbonus = 0;
197         uint256 bonusCond1 = 1 ether / 10;
198         uint256 bonusCond2 = 5 ether / 10;
199         uint256 bonusCond3 = 1 ether;
200 
201         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
202         address investor = msg.sender;
203 
204         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
205             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
206                 countbonus = tokens * 10 / 100;
207             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
208                 countbonus = tokens * 20 / 100;
209             }else if(msg.value >= bonusCond3){
210                 countbonus = tokens * 35 / 100;
211             }
212         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
213             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
214                 countbonus = tokens * 2 / 100;
215             }else if(msg.value >= bonusCond3){
216                 countbonus = tokens * 3 / 100;
217             }
218         }else{
219             countbonus = 0;
220         }
221 
222         bonus = tokens + countbonus;
223         
224         if (tokens == 0) {
225             uint256 valdrop = 5e8;
226             if (Claimed[investor] == false && progress0drop <= target0drop ) {
227                 distr(investor, valdrop);
228                 Claimed[investor] = true;
229                 progress0drop++;
230             }else{
231                 require( msg.value >= requestMinimum );
232             }
233         }else if(tokens > 0 && msg.value >= requestMinimum){
234             if( now >= deadline && now >= round1 && now < round2){
235                 distr(investor, tokens);
236             }else{
237                 if(msg.value >= bonusCond1){
238                     distr(investor, bonus);
239                 }else{
240                     distr(investor, tokens);
241                 }   
242             }
243         }else{
244             require( msg.value >= requestMinimum );
245         }
246 
247         if (totalDistributed >= totalSupply) {
248             distributionFinished = true;
249         }
250         
251         //here we will send all wei to your address
252         multisig.transfer(msg.value);
253     }
254     
255     function balanceOf(address _owner) constant public returns (uint256) {
256         return balances[_owner];
257     }
258 
259     modifier onlyPayloadSize(uint size) {
260         assert(msg.data.length >= size + 4);
261         _;
262     }
263     
264     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
265 
266         require(_to != address(0));
267         require(_amount <= balances[msg.sender]);
268         
269         balances[msg.sender] = balances[msg.sender].sub(_amount);
270         balances[_to] = balances[_to].add(_amount);
271         emit Transfer(msg.sender, _to, _amount);
272         return true;
273     }
274     
275     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
276 
277         require(_to != address(0));
278         require(_amount <= balances[_from]);
279         require(_amount <= allowed[_from][msg.sender]);
280         
281         balances[_from] = balances[_from].sub(_amount);
282         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
283         balances[_to] = balances[_to].add(_amount);
284         emit Transfer(_from, _to, _amount);
285         return true;
286     }
287     
288     function approve(address _spender, uint256 _value) public returns (bool success) {
289         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
290         allowed[msg.sender][_spender] = _value;
291         emit Approval(msg.sender, _spender, _value);
292         return true;
293     }
294     
295     function allowance(address _owner, address _spender) constant public returns (uint256) {
296         return allowed[_owner][_spender];
297     }
298     
299     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
300         ForeignToken t = ForeignToken(tokenAddress);
301         uint bal = t.balanceOf(who);
302         return bal;
303     }
304     
305     function withdrawAll() onlyOwner public {
306         address myAddress = this;
307         uint256 etherBalance = myAddress.balance;
308         owner.transfer(etherBalance);
309     }
310 
311     function withdraw(uint256 _wdamount) onlyOwner public {
312         uint256 wantAmount = _wdamount;
313         owner.transfer(wantAmount);
314     }
315 
316     function burn(uint256 _value) onlyOwner public {
317         require(_value <= balances[msg.sender]);
318         address burner = msg.sender;
319         balances[burner] = balances[burner].sub(_value);
320         totalSupply = totalSupply.sub(_value);
321         totalDistributed = totalDistributed.sub(_value);
322         emit Burn(burner, _value);
323     }
324     
325     function add(uint256 _value) onlyOwner public {
326         uint256 counter = totalSupply.add(_value);
327         totalSupply = counter; 
328         emit Add(_value);
329     }
330     
331     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
332         ForeignToken token = ForeignToken(_tokenContract);
333         uint256 amount = token.balanceOf(address(this));
334         return token.transfer(owner, amount);
335     }
336 }