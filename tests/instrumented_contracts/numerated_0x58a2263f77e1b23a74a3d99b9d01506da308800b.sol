1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'Network Token Payment' token contract
5 //
6 // Deployed to : 0x1bD79815aDb76424F8E3c798B6DD85227c904a42
7 // Symbol      : NTP
8 // Name        : Network Token Payment
9 // Total supply: 100000000
10 // Decimals    : 8
11 //
12 // Enjoy.
13 //
14 // (c) by Neo with BlockchainCenter / Bok Consulting Sky Ltd 2015. The MIT Licence.
15 // ----------------------------------------------------------------------------
16 
17 ////* Road Map Network Token Payment *
18 
19 //1. Create Smart Contract <31/12/2018>
20 ////                      1. Airdrop Open <01/1/2019 - 15/02/2019> 
21 ////                   * > How to join airdrop Network Token Payment < *
22 ////*                     ( Send 0 Eth to Contract) you get 30 NTP 
23 ////*       > Send more 0 eth get big bonus> Price 10000 per ETH > End 12/12/2018 <
24 
25 //3. Added CoinMarketCap, CoinGecko, and Coinmarketdaddy
26 //4. Launch Website < Q2,2019 >
27 //5. List on more Exchange.
28 ////> Target NTP list on Exchange <
29   // > 1. Binance < 2. Poloniex > < 3. Mercatox > < 4. IDEX > < 5. Hotbit > < 6. Etherflyer >
30  //6. Target Price $1 per token 
31 
32 /**
33  * @title SafeMath
34  * @dev Math operations with safety checks that throw on error
35  */
36 library SafeMath {
37 
38     /**
39     * @dev Multiplies two numbers, throws on overflow.
40     */
41     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         if (a == 0) {
43             return 0;
44         }
45         c = a * b;
46         assert(c / a == b);
47         return c;
48     }
49 
50     /**
51     * @dev Integer division of two numbers, truncating the quotient.
52     */
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         // assert(b > 0); // Solidity automatically throws when dividing by 0
55         // uint256 c = a / b;
56         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
57         return a / b;
58     }
59 
60     /**
61     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
62     */
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         assert(b <= a);
65         return a - b;
66     }
67 
68     /**
69     * @dev Adds two numbers, throws on overflow.
70     */
71     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
72         c = a + b;
73         assert(c >= a);
74         return c;
75     }
76 }
77 
78 contract ForeignToken {
79     function balanceOf(address _owner) constant public returns (uint256);
80     function transfer(address _to, uint256 _value) public returns (bool);
81 }
82 
83 contract ERC20Basic {
84     uint256 public totalSupply;
85     function balanceOf(address who) public constant returns (uint256);
86     function transfer(address to, uint256 value) public returns (bool);
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 contract ERC20 is ERC20Basic {
91     function allowance(address owner, address spender) public constant returns (uint256);
92     function transferFrom(address from, address to, uint256 value) public returns (bool);
93     function approve(address spender, uint256 value) public returns (bool);
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 contract NetworkTokenPayment is ERC20 {
98     
99     using SafeMath for uint256;
100     address owner = msg.sender;
101 
102     mapping (address => uint256) balances;
103     mapping (address => mapping (address => uint256)) allowed;
104     mapping (address => bool) public Claimed; 
105 
106     string public constant name = "Network Token Payment";
107     string public constant symbol = "NTP";
108     uint public constant decimals = 8;
109     uint public deadline = now + 55 * 1 days;
110     uint public round2 = now + 50 * 1 days;
111     uint public round1 = now + 45 * 1 days;
112     
113     uint256 public totalSupply = 100000000e8;
114     uint256 public totalDistributed;
115     uint256 public constant requestMinimum = 1 ether / 1000; // 0.001 Ether
116     uint256 public tokensPerEth =10000e8;
117     
118     uint public target0drop = 10000;
119     uint public progress0drop = 0;
120 
121 
122     event Transfer(address indexed _from, address indexed _to, uint256 _value);
123     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
124     
125     event Distr(address indexed to, uint256 amount);
126     event DistrFinished();
127     
128     event Airdrop(address indexed _owner, uint _amount, uint _balance);
129 
130     event TokensPerEthUpdated(uint _tokensPerEth);
131     
132     event Burn(address indexed burner, uint256 value);
133     
134     event Add(uint256 value);
135 
136     bool public distributionFinished = false;
137     
138     modifier canDistr() {
139         require(!distributionFinished);
140         _;
141     }
142     
143     modifier onlyOwner() {
144         require(msg.sender == owner);
145         _;
146     }
147     
148     constructor() public {
149         uint256 teamFund = 35000000e8;
150         owner = msg.sender;
151         distr(owner, teamFund);
152     }
153     
154     function transferOwnership(address newOwner) onlyOwner public {
155         if (newOwner != address(0)) {
156             owner = newOwner;
157         }
158     }
159 
160     function finishDistribution() onlyOwner canDistr public returns (bool) {
161         distributionFinished = true;
162         emit DistrFinished();
163         return true;
164     }
165     
166     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
167         totalDistributed = totalDistributed.add(_amount);        
168         balances[_to] = balances[_to].add(_amount);
169         emit Distr(_to, _amount);
170         emit Transfer(address(0), _to, _amount);
171 
172         return true;
173     }
174     
175     function Distribute(address _participant, uint _amount) onlyOwner internal {
176 
177         require( _amount > 0 );      
178         require( totalDistributed < totalSupply );
179         balances[_participant] = balances[_participant].add(_amount);
180         totalDistributed = totalDistributed.add(_amount);
181 
182         if (totalDistributed >= totalSupply) {
183             distributionFinished = true;
184         }
185 
186         // log
187         emit Airdrop(_participant, _amount, balances[_participant]);
188         emit Transfer(address(0), _participant, _amount);
189     }
190     
191     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
192         Distribute(_participant, _amount);
193     }
194 
195     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
196         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
197     }
198 
199     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
200         tokensPerEth = _tokensPerEth;
201         emit TokensPerEthUpdated(_tokensPerEth);
202     }
203            
204     function () external payable {
205         getTokens();
206      }
207 
208     function getTokens() payable canDistr  public {
209         uint256 tokens = 0;
210         uint256 bonus = 0;
211         uint256 countbonus = 0;
212         uint256 bonusCond1 = 1 ether / 100;
213         uint256 bonusCond2 = 1 ether / 10;
214         uint256 bonusCond3 = 1 ether;
215 
216         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
217         address investor = msg.sender;
218 
219         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
220             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
221                 countbonus = tokens * 3 / 100;
222             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
223                 countbonus = tokens * 5 / 100;
224             }else if(msg.value >= bonusCond3){
225                 countbonus = tokens * 10 / 100;
226             }
227         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
228             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
229                 countbonus = tokens * 2 / 100;
230             }else if(msg.value >= bonusCond3){
231                 countbonus = tokens * 5 / 100;
232             }
233         }else{
234             countbonus = 0;
235         }
236 
237         bonus = tokens + countbonus;
238         
239         if (tokens == 0) {
240             uint256 valdrop = 30e8;
241             if (Claimed[investor] == false && progress0drop <= target0drop ) {
242                 distr(investor, valdrop);
243                 Claimed[investor] = true;
244                 progress0drop++;
245             }else{
246                 require( msg.value >= requestMinimum );
247             }
248         }else if(tokens > 0 && msg.value >= requestMinimum){
249             if( now >= deadline && now >= round1 && now < round2){
250                 distr(investor, tokens);
251             }else{
252                 if(msg.value >= bonusCond1){
253                     distr(investor, bonus);
254                 }else{
255                     distr(investor, tokens);
256                 }   
257             }
258         }else{
259             require( msg.value >= requestMinimum );
260         }
261 
262         if (totalDistributed >= totalSupply) {
263             distributionFinished = true;
264         }
265     }
266     
267     function balanceOf(address _owner) constant public returns (uint256) {
268         return balances[_owner];
269     }
270 
271     modifier onlyPayloadSize(uint size) {
272         assert(msg.data.length >= size + 4);
273         _;
274     }
275     
276     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
277 
278         require(_to != address(0));
279         require(_amount <= balances[msg.sender]);
280         
281         balances[msg.sender] = balances[msg.sender].sub(_amount);
282         balances[_to] = balances[_to].add(_amount);
283         emit Transfer(msg.sender, _to, _amount);
284         return true;
285     }
286     
287     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
288 
289         require(_to != address(0));
290         require(_amount <= balances[_from]);
291         require(_amount <= allowed[_from][msg.sender]);
292         
293         balances[_from] = balances[_from].sub(_amount);
294         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
295         balances[_to] = balances[_to].add(_amount);
296         emit Transfer(_from, _to, _amount);
297         return true;
298     }
299     
300     function approve(address _spender, uint256 _value) public returns (bool success) {
301         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
302         allowed[msg.sender][_spender] = _value;
303         emit Approval(msg.sender, _spender, _value);
304         return true;
305     }
306     
307     function allowance(address _owner, address _spender) constant public returns (uint256) {
308         return allowed[_owner][_spender];
309     }
310     
311     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
312         ForeignToken t = ForeignToken(tokenAddress);
313         uint bal = t.balanceOf(who);
314         return bal;
315     }
316     
317     function withdrawAll() onlyOwner public {
318         address myAddress = this;
319         uint256 etherBalance = myAddress.balance;
320         owner.transfer(etherBalance);
321     }
322 
323     function withdraw(uint256 _wdamount) onlyOwner public {
324         uint256 wantAmount = _wdamount;
325         owner.transfer(wantAmount);
326     }
327 
328     function burn(uint256 _value) onlyOwner public {
329         require(_value <= balances[msg.sender]);
330         address burner = msg.sender;
331         balances[burner] = balances[burner].sub(_value);
332         totalSupply = totalSupply.sub(_value);
333         totalDistributed = totalDistributed.sub(_value);
334         emit Burn(burner, _value);
335     }
336     
337     function add(uint256 _value) onlyOwner public {
338         uint256 counter = totalSupply.add(_value);
339         totalSupply = counter; 
340         emit Add(_value);
341     }
342     
343     
344     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
345         ForeignToken token = ForeignToken(_tokenContract);
346         uint256 amount = token.balanceOf(address(this));
347         return token.transfer(owner, amount);
348     }
349 }