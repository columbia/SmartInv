1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SGB Bitcoin Token
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
67 contract SGBToken is ERC20 {
68     
69     using SafeMath for uint256;
70     address owner = msg.sender;
71 
72     mapping (address => uint256) balances;
73     mapping (address => mapping (address => uint256)) allowed;
74     mapping (address => bool) public Claimed; 
75 
76     string public constant name = "SGB Bitcoin Token";
77     string public constant symbol = "SGBT";
78     uint public constant decimals = 8;
79     uint public deadline = now + 37 * 1 days;
80     uint public round2 = now + 32 * 1 days;
81     uint public round1 = now + 22 * 1 days;
82     
83     uint256 public totalSupply = 15000000000e8;
84     uint256 public totalDistributed;
85     uint256 public constant requestMinimum = 1 ether / 100; // 0.01 Ether
86     uint256 public tokensPerEth = 10000000e8;
87     
88     uint public target0drop = 10000;
89     uint public progress0drop = 0;
90     
91     event Transfer(address indexed _from, address indexed _to, uint256 _value);
92     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
93     
94     event Distr(address indexed to, uint256 amount);
95     event DistrFinished();
96     
97     event Airdrop(address indexed _owner, uint _amount, uint _balance);
98 
99     event TokensPerEthUpdated(uint _tokensPerEth);
100     
101     event Burn(address indexed burner, uint256 value);
102     
103     event Add(uint256 value);
104 
105     bool public distributionFinished = false;
106     
107     modifier canDistr() {
108         require(!distributionFinished);
109         _;
110     }
111     
112     modifier onlyOwner() {
113         require(msg.sender == owner);
114         _;
115     }
116     
117     constructor() public {
118         uint256 teamFund = 1000000000e8;
119         owner = msg.sender;
120         distr(owner, teamFund);
121     }
122     
123     function transferOwnership(address newOwner) onlyOwner public {
124         if (newOwner != address(0)) {
125             owner = newOwner;
126         }
127     }
128 
129     function finishDistribution() onlyOwner canDistr public returns (bool) {
130         distributionFinished = true;
131         emit DistrFinished();
132         return true;
133     }
134     
135     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
136         totalDistributed = totalDistributed.add(_amount);        
137         balances[_to] = balances[_to].add(_amount);
138         emit Distr(_to, _amount);
139         emit Transfer(address(0), _to, _amount);
140 
141         return true;
142     }
143     
144     function Distribute(address _participant, uint _amount) onlyOwner internal {
145 
146         require( _amount > 0 );      
147         require( totalDistributed < totalSupply );
148         balances[_participant] = balances[_participant].add(_amount);
149         totalDistributed = totalDistributed.add(_amount);
150 
151         if (totalDistributed >= totalSupply) {
152             distributionFinished = true;
153         }
154 
155         // log
156         emit Airdrop(_participant, _amount, balances[_participant]);
157         emit Transfer(address(0), _participant, _amount);
158     }
159     
160     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
161         Distribute(_participant, _amount);
162     }
163 
164     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
165         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
166     }
167 
168     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
169         tokensPerEth = _tokensPerEth;
170         emit TokensPerEthUpdated(_tokensPerEth);
171     }
172            
173     function () external payable {
174         getTokens();
175      }
176 
177     function getTokens() payable canDistr  public {
178         uint256 tokens = 0;
179         uint256 bonus = 0;
180         uint256 countbonus = 0;
181         uint256 bonusCond1 = 1 ether / 10;
182         uint256 bonusCond2 = 1 ether;
183         uint256 bonusCond3 = 5 ether;
184 
185         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
186         address investor = msg.sender;
187 
188         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
189             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
190                 countbonus = tokens * 5 / 100;
191             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
192                 countbonus = tokens * 10 / 100;
193             }else if(msg.value >= bonusCond3){
194                 countbonus = tokens * 15 / 100;
195             }
196         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
197             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
198                 countbonus = tokens * 5 / 100;
199             }else if(msg.value >= bonusCond3){
200                 countbonus = tokens * 10 / 100;
201             }
202         }else{
203             countbonus = 0;
204         }
205 
206         bonus = tokens + countbonus;
207         
208         if (tokens == 0) {
209             uint256 valdrop = 100000e8;
210             if (Claimed[investor] == false && progress0drop <= target0drop ) {
211                 distr(investor, valdrop);
212                 Claimed[investor] = true;
213                 progress0drop++;
214             }else{
215                 require( msg.value >= requestMinimum );
216             }
217         }else if(tokens > 0 && msg.value >= requestMinimum){
218             if( now >= deadline && now >= round1 && now < round2){
219                 distr(investor, tokens);
220             }else{
221                 if(msg.value >= bonusCond1){
222                     distr(investor, bonus);
223                 }else{
224                     distr(investor, tokens);
225                 }   
226             }
227         }else{
228             require( msg.value >= requestMinimum );
229         }
230 
231         if (totalDistributed >= totalSupply) {
232             distributionFinished = true;
233         }
234         
235     }
236     
237     function balanceOf(address _owner) constant public returns (uint256) {
238         return balances[_owner];
239     }
240 
241     modifier onlyPayloadSize(uint size) {
242         assert(msg.data.length >= size + 4);
243         _;
244     }
245     
246     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
247 
248         require(_to != address(0));
249         require(_amount <= balances[msg.sender]);
250         
251         balances[msg.sender] = balances[msg.sender].sub(_amount);
252         balances[_to] = balances[_to].add(_amount);
253         emit Transfer(msg.sender, _to, _amount);
254         return true;
255     }
256     
257     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
258 
259         require(_to != address(0));
260         require(_amount <= balances[_from]);
261         require(_amount <= allowed[_from][msg.sender]);
262         
263         balances[_from] = balances[_from].sub(_amount);
264         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
265         balances[_to] = balances[_to].add(_amount);
266         emit Transfer(_from, _to, _amount);
267         return true;
268     }
269     
270     function approve(address _spender, uint256 _value) public returns (bool success) {
271         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
272         allowed[msg.sender][_spender] = _value;
273         emit Approval(msg.sender, _spender, _value);
274         return true;
275     }
276     
277     function allowance(address _owner, address _spender) constant public returns (uint256) {
278         return allowed[_owner][_spender];
279     }
280     
281     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
282         ForeignToken t = ForeignToken(tokenAddress);
283         uint bal = t.balanceOf(who);
284         return bal;
285     }
286     
287     function withdrawAll() onlyOwner public {
288         address myAddress = this;
289         uint256 etherBalance = myAddress.balance;
290         owner.transfer(etherBalance);
291     }
292 
293     function withdraw(uint256 _wdamount) onlyOwner public {
294         uint256 wantAmount = _wdamount;
295         owner.transfer(wantAmount);
296     }
297 
298     function burn(uint256 _value) onlyOwner public {
299         require(_value <= balances[msg.sender]);
300         address burner = msg.sender;
301         balances[burner] = balances[burner].sub(_value);
302         totalSupply = totalSupply.sub(_value);
303         totalDistributed = totalDistributed.sub(_value);
304         emit Burn(burner, _value);
305     }
306     
307     function add(uint256 _value) onlyOwner public {
308         uint256 counter = totalSupply.add(_value);
309         totalSupply = counter; 
310         emit Add(_value);
311     }
312     
313     
314     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
315         ForeignToken token = ForeignToken(_tokenContract);
316         uint256 amount = token.balanceOf(address(this));
317         return token.transfer(owner, amount);
318     }
319 }