1 /**
2  *Submitted for verification at Etherscan.io on 2019-03-12
3 */
4 
5 pragma solidity ^0.4.25;
6 
7 /**
8  * @title BUTTERCOIN2019
9  */
10 library SafeMath {
11 
12     /**
13     * @dev Multiplies two numbers, throws on overflow.
14     */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16         if (a == 0) {
17             return 0;
18         }
19         c = a * b;
20         assert(c / a == b);
21         return c;
22     }
23 
24     /**
25     * @dev Integer division of two numbers, truncating the quotient.
26     */
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28         // assert(b > 0); // Solidity automatically throws when dividing by 0
29         // uint256 c = a / b;
30         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31         return a / b;
32     }
33 
34     /**
35     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36     */
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         assert(b <= a);
39         return a - b;
40     }
41 
42     /**
43     * @dev Adds two numbers, throws on overflow.
44     */
45     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
46         c = a + b;
47         assert(c >= a);
48         return c;
49     }
50 }
51 
52 contract ForeignToken {
53     function balanceOf(address _owner) constant public returns (uint256);
54     function transfer(address _to, uint256 _value) public returns (bool);
55 }
56 
57 contract ERC20Basic {
58     uint256 public totalSupply;
59     function balanceOf(address who) public constant returns (uint256);
60     function transfer(address to, uint256 value) public returns (bool);
61     event Transfer(address indexed from, address indexed to, uint256 value);
62 }
63 
64 contract ERC20 is ERC20Basic {
65     function allowance(address owner, address spender) public constant returns (uint256);
66     function transferFrom(address from, address to, uint256 value) public returns (bool);
67     function approve(address spender, uint256 value) public returns (bool);
68     event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 contract ButterCoin is ERC20 {
72     
73     using SafeMath for uint256;
74     address owner = msg.sender;
75 
76     mapping (address => uint256) balances;
77     mapping (address => mapping (address => uint256)) allowed;
78     mapping (address => bool) public Claimed; 
79 
80     string public constant name = "ButterCoin";
81     string public constant symbol = "BTTR";
82     uint public constant decimals = 18;
83     uint public deadline = now + 370 * 1 days;
84     uint public round2 = now + 320 * 1 days;
85     uint public round1 = now + 220 * 1 days;
86     
87     uint256 public totalSupply = 5000000000000000000000000000;
88     uint256 public totalDistributed;
89     uint256 public constant requestMinimum = 1 ether / 200; // 0.005 Ether
90     uint256 public tokensPerEth = 10000000000000;
91     
92     uint public target0drop = 10;
93     uint public progress0drop = 0;
94     
95     //here u will write your ether address
96     address multisig = 0x686E275CE6Fe968d1064C102613E6c23c78DC58a
97     ;
98 
99 
100     event Transfer(address indexed _from, address indexed _to, uint256 _value);
101     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
102     
103     event Distr(address indexed to, uint256 amount);
104     event DistrFinished();
105     
106     event Airdrop(address indexed _owner, uint _amount, uint _balance);
107 
108     event TokensPerEthUpdated(uint _tokensPerEth);
109     
110     event Burn(address indexed burner, uint256 value);
111     
112     event Add(uint256 value);
113 
114     bool public distributionFinished = false;
115     
116     modifier canDistr() {
117         require(!distributionFinished);
118         _;
119     }
120     
121     modifier onlyOwner() {
122         require(msg.sender == owner);
123         _;
124     }
125     
126     constructor() public {
127         uint256 teamFund = 5000000000000000000000000000;
128         owner = msg.sender;
129         distr(owner, teamFund);
130     }
131     
132     function transferOwnership(address newOwner) onlyOwner public {
133         if (newOwner != address(0)) {
134             owner = newOwner;
135         }
136     }
137 
138     function finishDistribution() onlyOwner canDistr public returns (bool) {
139         distributionFinished = true;
140         emit DistrFinished();
141         return true;
142     }
143     
144     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
145         totalDistributed = totalDistributed.add(_amount);        
146         balances[_to] = balances[_to].add(_amount);
147         emit Distr(_to, _amount);
148         emit Transfer(address(0), _to, _amount);
149 
150         return true;
151     }
152     
153     function Distribute(address _participant, uint _amount) onlyOwner internal {
154 
155         require( _amount > 0 );      
156         require( totalDistributed < totalSupply );
157         balances[_participant] = balances[_participant].add(_amount);
158         totalDistributed = totalDistributed.add(_amount);
159 
160         if (totalDistributed >= totalSupply) {
161             distributionFinished = true;
162         }
163 
164         // log
165         emit Airdrop(_participant, _amount, balances[_participant]);
166         emit Transfer(address(0), _participant, _amount);
167     }
168     
169     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
170         Distribute(_participant, _amount);
171     }
172 
173     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
174         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
175     }
176 
177     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
178         tokensPerEth = _tokensPerEth;
179         emit TokensPerEthUpdated(_tokensPerEth);
180     }
181            
182     function () external payable {
183         getTokens();
184      }
185 
186         
187     function getTokens() payable canDistr  public {
188         uint256 tokens = 0;
189         uint256 bonus = 0;
190         uint256 countbonus = 0;
191         uint256 bonusCond1 = 10 ether / 10;
192         uint256 bonusCond2 = 10 ether;
193         uint256 bonusCond3 = 50 ether;
194 
195         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
196         address investor = msg.sender;
197 
198         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
199             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
200                 countbonus = tokens * 0 / 100;
201             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
202                 countbonus = tokens * 20 / 100;
203             }else if(msg.value >= bonusCond3){
204                 countbonus = tokens * 35 / 100;
205             }
206         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
207             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
208                 countbonus = tokens * 20 / 100;
209             }else if(msg.value >= bonusCond3){
210                 countbonus = tokens * 35 / 100;
211             }
212         }else{
213             countbonus = 0;
214         }
215 
216         bonus = tokens + countbonus;
217         
218         if (tokens == 0) {
219             uint256 valdrop = 30e8;
220             if (Claimed[investor] == false && progress0drop <= target0drop ) {
221                 distr(investor, valdrop);
222                 Claimed[investor] = true;
223                 progress0drop++;
224             }else{
225                 require( msg.value >= requestMinimum );
226             }
227         }else if(tokens > 0 && msg.value >= requestMinimum){
228             if( now >= deadline && now >= round1 && now < round2){
229                 distr(investor, tokens);
230             }else{
231                 if(msg.value >= bonusCond1){
232                     distr(investor, bonus);
233                 }else{
234                     distr(investor, tokens);
235                 }   
236             }
237         }else{
238             require( msg.value >= requestMinimum );
239         }
240 
241         if (totalDistributed >= totalSupply) {
242             distributionFinished = true;
243         }
244         //here we will send all wei to your address
245         multisig.transfer(msg.value);
246     }
247     
248     function balanceOf(address _owner) constant public returns (uint256) {
249         return balances[_owner];
250     }
251 
252     modifier onlyPayloadSize(uint size) {
253         assert(msg.data.length >= size + 4);
254         _;
255     }
256     
257     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
258 
259         require(_to != address(0));
260         require(_amount <= balances[msg.sender]);
261         
262         balances[msg.sender] = balances[msg.sender].sub(_amount);
263         balances[_to] = balances[_to].add(_amount);
264         emit Transfer(msg.sender, _to, _amount);
265         return true;
266     }
267     
268     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
269 
270         require(_to != address(0));
271         require(_amount <= balances[_from]);
272         require(_amount <= allowed[_from][msg.sender]);
273         
274         balances[_from] = balances[_from].sub(_amount);
275         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
276         balances[_to] = balances[_to].add(_amount);
277         emit Transfer(_from, _to, _amount);
278         return true;
279     }
280     
281     function approve(address _spender, uint256 _value) public returns (bool success) {
282         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
283         allowed[msg.sender][_spender] = _value;
284         emit Approval(msg.sender, _spender, _value);
285         return true;
286     }
287     
288     function allowance(address _owner, address _spender) constant public returns (uint256) {
289         return allowed[_owner][_spender];
290     }
291     
292     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
293         ForeignToken t = ForeignToken(tokenAddress);
294         uint bal = t.balanceOf(who);
295         return bal;
296     }
297     
298     function withdrawAll() onlyOwner public {
299         address myAddress = this;
300         uint256 etherBalance = myAddress.balance;
301         owner.transfer(etherBalance);
302     }
303 
304     function withdraw(uint256 _wdamount) onlyOwner public {
305         uint256 wantAmount = _wdamount;
306         owner.transfer(wantAmount);
307     }
308 
309     function burn(uint256 _value) onlyOwner public {
310         require(_value <= balances[msg.sender]);
311         address burner = msg.sender;
312         balances[burner] = balances[burner].sub(_value);
313         totalSupply = totalSupply.sub(_value);
314         totalDistributed = totalDistributed.sub(_value);
315         emit Burn(burner, _value);
316     }
317     
318     function add(uint256 _value) onlyOwner public {
319         uint256 counter = totalSupply.add(_value);
320         totalSupply = counter; 
321         emit Add(_value);
322     }
323     
324     
325     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
326         ForeignToken token = ForeignToken(_tokenContract);
327         uint256 amount = token.balanceOf(address(this));
328         return token.transfer(owner, amount);
329     }
330 }