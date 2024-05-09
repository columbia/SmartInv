1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title FIESTA   Project
5  */
6 library SafeMath {
7 
8     /**
9     * @dev Multiplies two numbers, throws on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         if (a == 0) {
13             return 0;
14         }
15         c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     /**
21     * @dev Integer division of two numbers, truncating the quotient.
22     */
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         // assert(b > 0); // Solidity automatically throws when dividing by 0
25         // uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return a / b;
28     }
29 
30     /**
31     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32     */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     /**
39     * @dev Adds two numbers, throws on overflow.
40     */
41     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 contract ForeignToken {
49     function balanceOf(address _owner) constant public returns (uint256);
50     function transfer(address _to, uint256 _value) public returns (bool);
51 }
52 
53 contract ERC20Basic {
54     uint256 public totalSupply;
55     function balanceOf(address who) public constant returns (uint256);
56     function transfer(address to, uint256 value) public returns (bool);
57     event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 
60 contract ERC20 is ERC20Basic {
61     function allowance(address owner, address spender) public constant returns (uint256);
62     function transferFrom(address from, address to, uint256 value) public returns (bool);
63     function approve(address spender, uint256 value) public returns (bool);
64     event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 contract FIESTA is ERC20 {
68     
69     using SafeMath for uint256;
70     address owner = msg.sender;
71 
72     mapping (address => uint256) balances;
73     mapping (address => mapping (address => uint256)) allowed;
74     mapping (address => bool) public Claimed; 
75 
76     string public constant name = "FIESTA";
77     string public constant symbol = "FIST";
78     uint public constant decimals = 8;
79     uint public deadline = now + 37 * 1 days;
80     uint public round2 = now + 32 * 1 days;
81     uint public round1 = now + 22 * 1 days;
82     
83     uint256 public totalSupply = 2000000000e8;
84     uint256 public totalDistributed;
85     uint256 public constant requestMinimum = 5 ether / 1000; // 0.005 Ether
86     uint256 public tokensPerEth = 25000000e8;
87     
88     uint public target0drop = 1200;
89     uint public progress0drop = 0;
90     
91     //here u will write your ether address
92     address multisig = 0xA503C3111bf5Cf00E2bB913662AA98f7a6cd65a2 ;
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
121         uint256 teamFund = 1000000000e8;
122         owner = msg.sender;
123         distr(owner, teamFund);
124     }
125     
126     function transferOwnership(address newOwner) onlyOwner public {
127         if (newOwner != address(0)) {
128             owner = newOwner;
129         }
130     }
131 
132     function finishDistribution() onlyOwner canDistr public returns (bool) {
133         distributionFinished = true;
134         emit DistrFinished();
135         return true;
136     }
137     
138     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
139         totalDistributed = totalDistributed.add(_amount);        
140         balances[_to] = balances[_to].add(_amount);
141         emit Distr(_to, _amount);
142         emit Transfer(address(0), _to, _amount);
143 
144         return true;
145     }
146     
147     function Distribute(address _participant, uint _amount) onlyOwner internal {
148 
149         require( _amount > 0 );      
150         require( totalDistributed < totalSupply );
151         balances[_participant] = balances[_participant].add(_amount);
152         totalDistributed = totalDistributed.add(_amount);
153 
154         if (totalDistributed >= totalSupply) {
155             distributionFinished = true;
156         }
157 
158         // log
159         emit Airdrop(_participant, _amount, balances[_participant]);
160         emit Transfer(address(0), _participant, _amount);
161     }
162     
163     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
164         Distribute(_participant, _amount);
165     }
166 
167     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
168         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
169     }
170 
171     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
172         tokensPerEth = _tokensPerEth;
173         emit TokensPerEthUpdated(_tokensPerEth);
174     }
175            
176     function () external payable {
177         getTokens();
178      }
179 
180     function getTokens() payable canDistr  public {
181         uint256 tokens = 0;
182         uint256 bonus = 0;
183         uint256 countbonus = 0;
184         uint256 bonusCond1 = 1 ether / 10;
185         uint256 bonusCond2 = 1 ether;
186         uint256 bonusCond3 = 5 ether;
187 
188         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
189         address investor = msg.sender;
190 
191         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
192             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
193                 countbonus = tokens * 5 / 100;
194             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
195                 countbonus = tokens * 10 / 100;
196             }else if(msg.value >= bonusCond3){
197                 countbonus = tokens * 15 / 100;
198             }
199         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
200             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
201                 countbonus = tokens * 5 / 100;
202             }else if(msg.value >= bonusCond3){
203                 countbonus = tokens * 10 / 100;
204             }
205         }else{
206             countbonus = 0;
207         }
208 
209         bonus = tokens + countbonus;
210         
211         if (tokens == 0) {
212             uint256 valdrop = 5000e8;
213             if (Claimed[investor] == false && progress0drop <= target0drop ) {
214                 distr(investor, valdrop);
215                 Claimed[investor] = true;
216                 progress0drop++;
217             }else{
218                 require( msg.value >= requestMinimum );
219             }
220         }else if(tokens > 0 && msg.value >= requestMinimum){
221             if( now >= deadline && now >= round1 && now < round2){
222                 distr(investor, tokens);
223             }else{
224                 if(msg.value >= bonusCond1){
225                     distr(investor, bonus);
226                 }else{
227                     distr(investor, tokens);
228                 }   
229             }
230         }else{
231             require( msg.value >= requestMinimum );
232         }
233 
234         if (totalDistributed >= totalSupply) {
235             distributionFinished = true;
236         }
237         
238         //here we will send all wei to your address
239         multisig.transfer(msg.value);
240     }
241     
242     function balanceOf(address _owner) constant public returns (uint256) {
243         return balances[_owner];
244     }
245 
246     modifier onlyPayloadSize(uint size) {
247         assert(msg.data.length >= size + 4);
248         _;
249     }
250     
251     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
252 
253         require(_to != address(0));
254         require(_amount <= balances[msg.sender]);
255         
256         balances[msg.sender] = balances[msg.sender].sub(_amount);
257         balances[_to] = balances[_to].add(_amount);
258         emit Transfer(msg.sender, _to, _amount);
259         return true;
260     }
261     
262     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
263 
264         require(_to != address(0));
265         require(_amount <= balances[_from]);
266         require(_amount <= allowed[_from][msg.sender]);
267         
268         balances[_from] = balances[_from].sub(_amount);
269         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
270         balances[_to] = balances[_to].add(_amount);
271         emit Transfer(_from, _to, _amount);
272         return true;
273     }
274     
275     function approve(address _spender, uint256 _value) public returns (bool success) {
276         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
277         allowed[msg.sender][_spender] = _value;
278         emit Approval(msg.sender, _spender, _value);
279         return true;
280     }
281     
282     function allowance(address _owner, address _spender) constant public returns (uint256) {
283         return allowed[_owner][_spender];
284     }
285     
286     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
287         ForeignToken t = ForeignToken(tokenAddress);
288         uint bal = t.balanceOf(who);
289         return bal;
290     }
291     
292     function withdrawAll() onlyOwner public {
293         address myAddress = this;
294         uint256 etherBalance = myAddress.balance;
295         owner.transfer(etherBalance);
296     }
297 
298     function withdraw(uint256 _wdamount) onlyOwner public {
299         uint256 wantAmount = _wdamount;
300         owner.transfer(wantAmount);
301     }
302 
303     function burn(uint256 _value) onlyOwner public {
304         require(_value <= balances[msg.sender]);
305         address burner = msg.sender;
306         balances[burner] = balances[burner].sub(_value);
307         totalSupply = totalSupply.sub(_value);
308         totalDistributed = totalDistributed.sub(_value);
309         emit Burn(burner, _value);
310     }
311     
312     function add(uint256 _value) onlyOwner public {
313         uint256 counter = totalSupply.add(_value);
314         totalSupply = counter; 
315         emit Add(_value);
316     }
317     
318     
319     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
320         ForeignToken token = ForeignToken(_tokenContract);
321         uint256 amount = token.balanceOf(address(this));
322         return token.transfer(owner, amount);
323     }
324 }