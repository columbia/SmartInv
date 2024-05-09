1 pragma solidity ^0.4.25;
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
68 contract XI is ERC20 {
69     
70     using SafeMath for uint256;
71     address owner = msg.sender;
72 
73     mapping (address => uint256) balances;
74     mapping (address => mapping (address => uint256)) allowed;
75     mapping (address => bool) public Claimed; 
76 
77     string public constant name = "XI Network";
78     string public constant symbol = "XI";
79     uint public constant decimals = 8;
80     uint public deadline = now + 42 * 1 days;
81     uint public round2 = now + 32 * 1 days;
82     uint public round1 = now + 22 * 1 days;
83     
84     uint256 public totalSupply = 22222222222e8;
85     uint256 public totalDistributed;
86     uint256 public constant requestMinimum = 1 ether / 100; // 0.01 Ether
87     uint256 public tokensPerEth = 222222222e8;
88                                   
89     
90     uint public target0drop = 2222;
91     uint public progress0drop = 0;
92 
93 
94     event Transfer(address indexed _from, address indexed _to, uint256 _value);
95     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
96     
97     event Distr(address indexed to, uint256 amount);
98     event DistrFinished();
99     
100     event Airdrop(address indexed _owner, uint _amount, uint _balance);
101 
102     event TokensPerEthUpdated(uint _tokensPerEth);
103     
104     event Burn(address indexed burner, uint256 value);
105     
106     event Add(uint256 value);
107 
108     bool public distributionFinished = false;
109     
110     modifier canDistr() {
111         require(!distributionFinished);
112         _;
113     }
114     
115     modifier onlyOwner() {
116         require(msg.sender == owner);
117         _;
118     }
119     
120     constructor() public {
121         uint256 teamFund = 2222222222e8;
122                            
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
139     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
140         totalDistributed = totalDistributed.add(_amount);        
141         balances[_to] = balances[_to].add(_amount);
142         emit Distr(_to, _amount);
143         emit Transfer(address(0), _to, _amount);
144 
145         return true;
146     }
147     
148     function Distribute(address _participant, uint _amount) onlyOwner internal {
149 
150         require( _amount > 0 );      
151         require( totalDistributed < totalSupply );
152         balances[_participant] = balances[_participant].add(_amount);
153         totalDistributed = totalDistributed.add(_amount);
154 
155         if (totalDistributed >= totalSupply) {
156             distributionFinished = true;
157         }
158 
159         // log
160         emit Airdrop(_participant, _amount, balances[_participant]);
161         emit Transfer(address(0), _participant, _amount);
162     }
163     
164     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
165         Distribute(_participant, _amount);
166     }
167 
168     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
169         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
170     }
171 
172     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
173         tokensPerEth = _tokensPerEth;
174         emit TokensPerEthUpdated(_tokensPerEth);
175     }
176            
177     function () external payable {
178         getTokens();
179      }
180 
181     function getTokens() payable canDistr  public {
182         uint256 tokens = 0;
183         uint256 bonus = 0;
184         uint256 countbonus = 0;
185         uint256 bonusCond1 = 1 ether / 10;
186         uint256 bonusCond2 = 1 ether / 2;
187         uint256 bonusCond3 = 1 ether;
188 
189         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
190         address investor = msg.sender;
191 
192         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
193             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
194                 countbonus = tokens * 10 / 100;
195             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
196                 countbonus = tokens * 25 / 100;
197             }else if(msg.value >= bonusCond3){
198                 countbonus = tokens * 50 / 100;
199             }
200         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
201             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
202                 countbonus = tokens * 15 / 100;
203             }else if(msg.value >= bonusCond3){
204                 countbonus = tokens * 35 / 100;
205             }
206         }else{
207             countbonus = 0;
208         }
209 
210         bonus = tokens + countbonus;
211         
212         if (tokens == 0) {
213             uint256 valdrop = 22222e8;
214             if (Claimed[investor] == false && progress0drop <= target0drop ) {
215                 distr(investor, valdrop);
216                 Claimed[investor] = true;
217                 progress0drop++;
218             }else{
219                 require( msg.value >= requestMinimum );
220             }
221         }else if(tokens > 0 && msg.value >= requestMinimum){
222             if( now >= deadline && now >= round1 && now < round2){
223                 distr(investor, tokens);
224             }else{
225                 if(msg.value >= bonusCond1){
226                     distr(investor, bonus);
227                 }else{
228                     distr(investor, tokens);
229                 }   
230             }
231         }else{
232             require( msg.value >= requestMinimum );
233         }
234 
235         if (totalDistributed >= totalSupply) {
236             distributionFinished = true;
237         }
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
316     
317     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
318         ForeignToken token = ForeignToken(_tokenContract);
319         uint256 amount = token.balanceOf(address(this));
320         return token.transfer(owner, amount);
321     }
322 }