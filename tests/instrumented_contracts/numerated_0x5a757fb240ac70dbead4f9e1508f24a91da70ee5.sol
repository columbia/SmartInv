1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 contract ForeignToken {
50     function balanceOf(address _owner) constant public returns (uint256);
51     function transfer(address _to, uint256 _value) public returns (bool);
52 }
53 
54 contract ERC20Basic {
55     uint256 public totalSupply;
56     function balanceOf(address who) public constant returns (uint256);
57     function transfer(address to, uint256 value) public returns (bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 contract ERC20 is ERC20Basic {
62     function allowance(address owner, address spender) public constant returns (uint256);
63     function transferFrom(address from, address to, uint256 value) public returns (bool);
64     function approve(address spender, uint256 value) public returns (bool);
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 contract SilentToken is ERC20 {
69     
70     using SafeMath for uint256;
71     address owner = msg.sender;
72 
73     mapping (address => uint256) balances;
74     mapping (address => mapping (address => uint256)) allowed;
75     mapping (address => bool) public Claimed; 
76 
77     string public constant name = "Silent Token";
78     string public constant symbol = "ST";
79     uint public constant decimals = 8;
80     uint public deadline = now + 35 * 1 days;
81     uint public round2 = now + 30 * 1 days;
82     uint public round1 = now + 20 * 1 days;
83     
84     uint256 public totalSupply = 10000000000e8;
85     uint256 public totalDistributed;
86     uint256 public constant requestMinimum = 1 ether / 100; // 0.01 Ether
87     uint256 public tokensPerEth = 10000000e8;
88     
89     uint public target0drop = 2500;
90     uint public progress0drop = 0;
91 
92 
93     event Transfer(address indexed _from, address indexed _to, uint256 _value);
94     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
95     
96     event Distr(address indexed to, uint256 amount);
97     event DistrFinished();
98     
99     event DistrRestarted();
100     
101     event Airdrop(address indexed _owner, uint _amount, uint _balance);
102 
103     event TokensPerEthUpdated(uint _tokensPerEth);
104     
105     event Burn(address indexed burner, uint256 value);
106     
107     event Add(uint256 value);
108 
109     bool public distributionFinished = false;
110     
111     modifier canDistr() {
112         require(!distributionFinished);
113         _;
114     }
115     
116     modifier onlyOwner() {
117         require(msg.sender == owner);
118         _;
119     }
120     
121     constructor() public {
122         uint256 teamFund = 1000000000e8;
123         owner = msg.sender;
124         distr(owner, teamFund);
125     }
126     
127     function transferOwnership(address newOwner) onlyOwner public {
128         if (newOwner != address(0)) {
129             owner = newOwner;
130         }
131     }
132 
133     function finishDistribution() onlyOwner canDistr public returns (bool) {
134         distributionFinished = true;
135         emit DistrFinished();
136         return true;
137     }
138     
139     function reDistribution() onlyOwner canDistr public returns (bool) {
140         distributionFinished = false;
141         emit DistrRestarted();
142         return true;
143     }
144     
145     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
146         totalDistributed = totalDistributed.add(_amount);        
147         balances[_to] = balances[_to].add(_amount);
148         emit Distr(_to, _amount);
149         emit Transfer(address(0), _to, _amount);
150 
151         return true;
152     }
153     
154     function Distribute(address _participant, uint _amount) onlyOwner internal {
155 
156         require( _amount > 0 );      
157         require( totalDistributed < totalSupply );
158         balances[_participant] = balances[_participant].add(_amount);
159         totalDistributed = totalDistributed.add(_amount);
160 
161         if (totalDistributed >= totalSupply) {
162             distributionFinished = true;
163         }
164 
165         // log
166         emit Airdrop(_participant, _amount, balances[_participant]);
167         emit Transfer(address(0), _participant, _amount);
168     }
169     
170     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
171         Distribute(_participant, _amount);
172     }
173 
174     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
175         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
176     }
177 
178     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
179         tokensPerEth = _tokensPerEth;
180         emit TokensPerEthUpdated(_tokensPerEth);
181     }
182            
183     function () external payable {
184         getTokens();
185      }
186 
187     function getTokens() payable canDistr  public {
188         uint256 tokens = 0;
189         uint256 bonus = 0;
190         uint256 countbonus = 0;
191         uint256 bonusCond1 = 1 ether / 100;
192         uint256 bonusCond2 = 1 ether / 10;
193         uint256 bonusCond3 = 1 ether;
194 
195         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
196         address investor = msg.sender;
197 
198         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
199             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
200                 countbonus = tokens * 10 / 100;
201             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
202                 countbonus = tokens * 20 / 100;
203             }else if(msg.value >= bonusCond3){
204                 countbonus = tokens * 30 / 100;
205             }
206         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
207             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
208                 countbonus = tokens * 10 / 100;
209             }else if(msg.value >= bonusCond3){
210                 countbonus = tokens * 20 / 100;
211             }
212         }else{
213             countbonus = 0;
214         }
215 
216         bonus = tokens + countbonus;
217         
218         if (tokens == 0) {
219             uint256 valdrop = 10000e8;
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
244     }
245     
246     function balanceOf(address _owner) constant public returns (uint256) {
247         return balances[_owner];
248     }
249 
250     modifier onlyPayloadSize(uint size) {
251         assert(msg.data.length >= size + 4);
252         _;
253     }
254     
255     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
256 
257         require(_to != address(0));
258         require(_amount <= balances[msg.sender]);
259         
260         balances[msg.sender] = balances[msg.sender].sub(_amount);
261         balances[_to] = balances[_to].add(_amount);
262         emit Transfer(msg.sender, _to, _amount);
263         return true;
264     }
265     
266     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
267 
268         require(_to != address(0));
269         require(_amount <= balances[_from]);
270         require(_amount <= allowed[_from][msg.sender]);
271         
272         balances[_from] = balances[_from].sub(_amount);
273         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
274         balances[_to] = balances[_to].add(_amount);
275         emit Transfer(_from, _to, _amount);
276         return true;
277     }
278     
279     function approve(address _spender, uint256 _value) public returns (bool success) {
280         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
281         allowed[msg.sender][_spender] = _value;
282         emit Approval(msg.sender, _spender, _value);
283         return true;
284     }
285     
286     function allowance(address _owner, address _spender) constant public returns (uint256) {
287         return allowed[_owner][_spender];
288     }
289     
290     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
291         ForeignToken t = ForeignToken(tokenAddress);
292         uint bal = t.balanceOf(who);
293         return bal;
294     }
295     
296     function withdrawAll() onlyOwner public {
297         address myAddress = this;
298         uint256 etherBalance = myAddress.balance;
299         owner.transfer(etherBalance);
300     }
301 
302     function withdraw(uint256 _wdamount) onlyOwner public {
303         uint256 wantAmount = _wdamount;
304         owner.transfer(wantAmount);
305     }
306 
307     function burn(uint256 _value) onlyOwner public {
308         require(_value <= balances[msg.sender]);
309         address burner = msg.sender;
310         balances[burner] = balances[burner].sub(_value);
311         totalSupply = totalSupply.sub(_value);
312         totalDistributed = totalDistributed.sub(_value);
313         emit Burn(burner, _value);
314     }
315     
316     function add(uint256 _value) onlyOwner public {
317         uint256 counter = totalSupply.add(_value);
318         totalSupply = counter; 
319         emit Add(_value);
320     }
321     
322     
323     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
324         ForeignToken token = ForeignToken(_tokenContract);
325         uint256 amount = token.balanceOf(address(this));
326         return token.transfer(owner, amount);
327     }
328 }