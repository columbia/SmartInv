1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title  Project
5  * Energi Plus
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
68 contract EnergiPlus is ERC20 {
69     
70     using SafeMath for uint256;
71     address owner = msg.sender;
72 
73     mapping (address => uint256) balances;
74     mapping (address => mapping (address => uint256)) allowed;
75     mapping (address => bool) public Claimed; 
76 
77     string public constant name = "Energi Plus";
78     string public constant symbol = "EPC";
79     uint public constant decimals = 8;
80     uint public deadline = now + 150 * 1 days;
81     uint public round2 = now + 50 * 1 days;
82     uint public round1 = now + 100 * 1 days;
83     
84     uint256 public totalSupply = 100000000e8;
85     uint256 public totalDistributed;
86     uint256 public constant requestMinimum = 1 ether / 100; // 0.01 Ether
87     uint256 public tokensPerEth = 35000e8;
88     
89     uint public target0drop = 5000;
90     uint public progress0drop = 0;
91     
92     //here u will write your ether address
93     address multisig = 0x4e0134dB37A5c67E1572BE270C1E34C5f67cdBc0;
94 
95 
96     event Transfer(address indexed _from, address indexed _to, uint256 _value);
97     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
98     
99     event Distr(address indexed to, uint256 amount);
100     event DistrFinished();
101     
102     event Airdrop(address indexed _owner, uint _amount, uint _balance);
103 
104     event TokensPerEthUpdated(uint _tokensPerEth);
105     
106     event Burn(address indexed burner, uint256 value);
107     
108     event Add(uint256 value);
109 
110     bool public distributionFinished = false;
111     
112     modifier canDistr() {
113         require(!distributionFinished);
114         _;
115     }
116     
117     modifier onlyOwner() {
118         require(msg.sender == owner);
119         _;
120     }
121     
122     constructor() public {
123         uint256 teamFund = 15000000e8;
124         owner = msg.sender;
125         distr(owner, teamFund);
126     }
127     
128     function transferOwnership(address newOwner) onlyOwner public {
129         if (newOwner != address(0)) {
130             owner = newOwner;
131         }
132     }
133 
134     function finishDistribution() onlyOwner canDistr public returns (bool) {
135         distributionFinished = true;
136         emit DistrFinished();
137         return true;
138     }
139     
140     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
141         totalDistributed = totalDistributed.add(_amount);        
142         balances[_to] = balances[_to].add(_amount);
143         emit Distr(_to, _amount);
144         emit Transfer(address(0), _to, _amount);
145 
146         return true;
147     }
148     
149     function Distribute(address _participant, uint _amount) onlyOwner internal {
150 
151         require( _amount > 0 );      
152         require( totalDistributed < totalSupply );
153         balances[_participant] = balances[_participant].add(_amount);
154         totalDistributed = totalDistributed.add(_amount);
155 
156         if (totalDistributed >= totalSupply) {
157             distributionFinished = true;
158         }
159 
160         // log
161         emit Airdrop(_participant, _amount, balances[_participant]);
162         emit Transfer(address(0), _participant, _amount);
163     }
164     
165     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
166         Distribute(_participant, _amount);
167     }
168 
169     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
170         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
171     }
172 
173     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
174         tokensPerEth = _tokensPerEth;
175         emit TokensPerEthUpdated(_tokensPerEth);
176     }
177            
178     function () external payable {
179         getTokens();
180      }
181 
182     function getTokens() payable canDistr  public {
183         uint256 tokens = 0;
184         uint256 bonus = 0;
185         uint256 countbonus = 0;
186         uint256 bonusCond1 = 1 ether / 10;
187         uint256 bonusCond2 = 5 ether / 10;
188         uint256 bonusCond3 = 1 ether;
189 
190         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
191         address investor = msg.sender;
192 
193         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
194             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
195                 countbonus = tokens * 10 / 100;
196             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
197                 countbonus = tokens * 15 / 100;
198             }else if(msg.value >= bonusCond3){
199                 countbonus = tokens * 35 / 100;
200             }
201         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
202             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
203                 countbonus = tokens * 2 / 100;
204             }else if(msg.value >= bonusCond3){
205                 countbonus = tokens * 3 / 100;
206             }
207         }else{
208             countbonus = 0;
209         }
210 
211         bonus = tokens + countbonus;
212         
213         if (tokens == 0) {
214             uint256 valdrop = 5e8;
215             if (Claimed[investor] == false && progress0drop <= target0drop ) {
216                 distr(investor, valdrop);
217                 Claimed[investor] = true;
218                 progress0drop++;
219             }else{
220                 require( msg.value >= requestMinimum );
221             }
222         }else if(tokens > 0 && msg.value >= requestMinimum){
223             if( now >= deadline && now >= round1 && now < round2){
224                 distr(investor, tokens);
225             }else{
226                 if(msg.value >= bonusCond1){
227                     distr(investor, bonus);
228                 }else{
229                     distr(investor, tokens);
230                 }   
231             }
232         }else{
233             require( msg.value >= requestMinimum );
234         }
235 
236         if (totalDistributed >= totalSupply) {
237             distributionFinished = true;
238         }
239         
240         //here we will send all wei to your address
241         multisig.transfer(msg.value);
242     }
243     
244     function balanceOf(address _owner) constant public returns (uint256) {
245         return balances[_owner];
246     }
247 
248     modifier onlyPayloadSize(uint size) {
249         assert(msg.data.length >= size + 4);
250         _;
251     }
252     
253     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
254 
255         require(_to != address(0));
256         require(_amount <= balances[msg.sender]);
257         
258         balances[msg.sender] = balances[msg.sender].sub(_amount);
259         balances[_to] = balances[_to].add(_amount);
260         emit Transfer(msg.sender, _to, _amount);
261         return true;
262     }
263     
264     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
265 
266         require(_to != address(0));
267         require(_amount <= balances[_from]);
268         require(_amount <= allowed[_from][msg.sender]);
269         
270         balances[_from] = balances[_from].sub(_amount);
271         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
272         balances[_to] = balances[_to].add(_amount);
273         emit Transfer(_from, _to, _amount);
274         return true;
275     }
276     
277     function approve(address _spender, uint256 _value) public returns (bool success) {
278         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
279         allowed[msg.sender][_spender] = _value;
280         emit Approval(msg.sender, _spender, _value);
281         return true;
282     }
283     
284     function allowance(address _owner, address _spender) constant public returns (uint256) {
285         return allowed[_owner][_spender];
286     }
287     
288     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
289         ForeignToken t = ForeignToken(tokenAddress);
290         uint bal = t.balanceOf(who);
291         return bal;
292     }
293     
294     function withdrawAll() onlyOwner public {
295         address myAddress = this;
296         uint256 etherBalance = myAddress.balance;
297         owner.transfer(etherBalance);
298     }
299 
300     function withdraw(uint256 _wdamount) onlyOwner public {
301         uint256 wantAmount = _wdamount;
302         owner.transfer(wantAmount);
303     }
304 
305     function burn(uint256 _value) onlyOwner public {
306         require(_value <= balances[msg.sender]);
307         address burner = msg.sender;
308         balances[burner] = balances[burner].sub(_value);
309         totalSupply = totalSupply.sub(_value);
310         totalDistributed = totalDistributed.sub(_value);
311         emit Burn(burner, _value);
312     }
313     
314     function add(uint256 _value) onlyOwner public {
315         uint256 counter = totalSupply.add(_value);
316         totalSupply = counter; 
317         emit Add(_value);
318     }
319     
320     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
321         ForeignToken token = ForeignToken(_tokenContract);
322         uint256 amount = token.balanceOf(address(this));
323         return token.transfer(owner, amount);
324     }
325 }