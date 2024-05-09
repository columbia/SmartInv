1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9         if (a == 0) {
10             return 0;
11         }
12         c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     /**
18     * @dev Integer division of two numbers, truncating the quotient.
19     */
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         // uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return a / b;
25     }
26 
27     /**
28     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36     * @dev Adds two numbers, throws on overflow.
37     */
38     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39         c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 contract ForeignToken {
46     function balanceOf(address _owner) constant public returns (uint256);
47     function transfer(address _to, uint256 _value) public returns (bool);
48 }
49 
50 contract ERC20Basic {
51     uint256 public totalSupply;
52     function balanceOf(address who) public constant returns (uint256);
53     function transfer(address to, uint256 value) public returns (bool);
54     event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 contract ERC20 is ERC20Basic {
58     function allowance(address owner, address spender) public constant returns (uint256);
59     function transferFrom(address from, address to, uint256 value) public returns (bool);
60     function approve(address spender, uint256 value) public returns (bool);
61     event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 contract GOMO_NETWORK is ERC20 {
65     
66     using SafeMath for uint256;
67     address owner = msg.sender;
68 
69     mapping (address => uint256) balances;
70     mapping (address => mapping (address => uint256)) allowed;
71     mapping (address => bool) public Claimed; 
72 
73     string public constant name = "GOMO Network";
74     string public constant symbol = "GOMO";
75     uint public constant decimals = 18;
76     uint public deadline = now + 50 * 1 days;
77     uint public round2 = now + 50 * 1 days;
78     uint public round1 = now + 40 * 1 days;
79     
80     uint256 public totalSupply = 35000000e18;
81     uint256 public totalDistributed;
82     uint256 public constant requestMinimum = 1 ether / 1000; // 0.01 Ether
83     uint256 public tokensPerEth = 500000e18;
84     
85     uint public target0drop = 100000;
86     uint public progress0drop = 0;
87     
88     //here u will write your ether address
89     address multisig = 0x09E69EF1029F9870225942E153D25B12E263394C;
90 
91 
92     event Transfer(address indexed _from, address indexed _to, uint256 _value);
93     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
94     
95     event Distr(address indexed to, uint256 amount);
96     event DistrFinished();
97     
98     event Airdrop(address indexed _owner, uint _amount, uint _balance);
99 
100     event TokensPerEthUpdated(uint _tokensPerEth);
101     
102     event Burn(address indexed burner, uint256 value);
103     
104     event Add(uint256 value);
105 
106     bool public distributionFinished = false;
107     
108     modifier canDistr() {
109         require(!distributionFinished);
110         _;
111     }
112     
113     modifier onlyOwner() {
114         require(msg.sender == owner);
115         _;
116     }
117     
118     constructor() public {
119         uint256 teamFund = 5000000e18;
120         owner = msg.sender;
121         distr(owner, teamFund);
122     }
123     
124     function transferOwnership(address newOwner) onlyOwner public {
125         if (newOwner != address(0)) {
126             owner = newOwner;
127         }
128     }
129 
130     function finishDistribution() onlyOwner canDistr public returns (bool) {
131         distributionFinished = true;
132         emit DistrFinished();
133         return true;
134     }
135     
136     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
137         totalDistributed = totalDistributed.add(_amount);        
138         balances[_to] = balances[_to].add(_amount);
139         emit Distr(_to, _amount);
140         emit Transfer(address(0), _to, _amount);
141 
142         return true;
143     }
144     
145     function Distribute(address _participant, uint _amount) onlyOwner internal {
146 
147         require( _amount > 0 );      
148         require( totalDistributed < totalSupply );
149         balances[_participant] = balances[_participant].add(_amount);
150         totalDistributed = totalDistributed.add(_amount);
151 
152         if (totalDistributed >= totalSupply) {
153             distributionFinished = true;
154         }
155 
156         // log
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
182         uint256 bonusCond1 = 1 ether / 10;
183         uint256 bonusCond2 = 5 ether / 10;
184         uint256 bonusCond3 = 1 ether;
185 
186         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
187         address investor = msg.sender;
188 
189         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
190             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
191                 countbonus = tokens * 10 / 100;
192             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
193                 countbonus = tokens * 20 / 100;
194             }else if(msg.value >= bonusCond3){
195                 countbonus = tokens * 35 / 100;
196             }
197         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
198             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
199                 countbonus = tokens * 2 / 100;
200             }else if(msg.value >= bonusCond3){
201                 countbonus = tokens * 3 / 100;
202             }
203         }else{
204             countbonus = 0;
205         }
206 
207         bonus = tokens + countbonus;
208         
209         if (tokens == 0) {
210             uint256 valdrop = 50e18;
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
236         //here we will send all wei to your address
237         multisig.transfer(msg.value);
238     }
239     
240     function balanceOf(address _owner) constant public returns (uint256) {
241         return balances[_owner];
242     }
243 
244     modifier onlyPayloadSize(uint size) {
245         assert(msg.data.length >= size + 4);
246         _;
247     }
248     
249     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
250 
251         require(_to != address(0));
252         require(_amount <= balances[msg.sender]);
253         
254         balances[msg.sender] = balances[msg.sender].sub(_amount);
255         balances[_to] = balances[_to].add(_amount);
256         emit Transfer(msg.sender, _to, _amount);
257         return true;
258     }
259     
260     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
261 
262         require(_to != address(0));
263         require(_amount <= balances[_from]);
264         require(_amount <= allowed[_from][msg.sender]);
265         
266         balances[_from] = balances[_from].sub(_amount);
267         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
268         balances[_to] = balances[_to].add(_amount);
269         emit Transfer(_from, _to, _amount);
270         return true;
271     }
272     
273     function approve(address _spender, uint256 _value) public returns (bool success) {
274         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
275         allowed[msg.sender][_spender] = _value;
276         emit Approval(msg.sender, _spender, _value);
277         return true;
278     }
279     
280     function allowance(address _owner, address _spender) constant public returns (uint256) {
281         return allowed[_owner][_spender];
282     }
283     
284     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
285         ForeignToken t = ForeignToken(tokenAddress);
286         uint bal = t.balanceOf(who);
287         return bal;
288     }
289     
290     function withdrawAll() onlyOwner public {
291         address myAddress = this;
292         uint256 etherBalance = myAddress.balance;
293         owner.transfer(etherBalance);
294     }
295 
296     function withdraw(uint256 _wdamount) onlyOwner public {
297         uint256 wantAmount = _wdamount;
298         owner.transfer(wantAmount);
299     }
300 
301     function burn(uint256 _value) onlyOwner public {
302         require(_value <= balances[msg.sender]);
303         address burner = msg.sender;
304         balances[burner] = balances[burner].sub(_value);
305         totalSupply = totalSupply.sub(_value);
306         totalDistributed = totalDistributed.sub(_value);
307         emit Burn(burner, _value);
308     }
309     
310     function add(uint256 _value) onlyOwner public {
311         uint256 counter = totalSupply.add(_value);
312         totalSupply = counter; 
313         emit Add(_value);
314     }
315     
316     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
317         ForeignToken token = ForeignToken(_tokenContract);
318         uint256 amount = token.balanceOf(address(this));
319         return token.transfer(owner, amount);
320     }
321 }