1 /**
2  * @title SafeMath
3  * Decimals : 18
4  * TotalSupply : 21,000,000
5  * Source Code first verified at https://etherscan.io on August, 2019.
6  **/
7  
8 pragma solidity ^0.4.24;
9 
10 /**
11  * @title SafeMath
12  * @dev Math operations with safety checks that throw on error
13  */
14 library SafeMath {
15 
16     /**
17     * @dev Multiplies two numbers, throws on overflow.
18     */
19     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         if (a == 0) {
21             return 0;
22         }
23         c = a * b;
24         assert(c / a == b);
25         return c;
26     }
27 
28     /**
29     * @dev Integer division of two numbers, truncating the quotient.
30     */
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         // assert(b > 0); // Solidity automatically throws when dividing by 0
33         // uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35         return a / b;
36     }
37 
38     /**
39     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40     */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         assert(b <= a);
43         return a - b;
44     }
45 
46     /**
47     * @dev Adds two numbers, throws on overflow.
48     */
49     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
50         c = a + b;
51         assert(c >= a);
52         return c;
53     }
54 }
55 
56 contract ForeignToken {
57     function balanceOf(address _owner) constant public returns (uint256);
58     function transfer(address _to, uint256 _value) public returns (bool);
59 }
60 
61 contract ERC20Basic {
62     uint256 public totalSupply;
63     function balanceOf(address who) public constant returns (uint256);
64     function transfer(address to, uint256 value) public returns (bool);
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 contract ERC20 is ERC20Basic {
69     function allowance(address owner, address spender) public constant returns (uint256);
70     function transferFrom(address from, address to, uint256 value) public returns (bool);
71     function approve(address spender, uint256 value) public returns (bool);
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 contract ZeroFeeXchange is ERC20 {
76     
77     using SafeMath for uint256;
78     address owner = msg.sender;
79 
80     mapping (address => uint256) balances;
81     mapping (address => mapping (address => uint256)) allowed;
82     mapping (address => bool) public Claimed; 
83 
84     string public constant name = "ZeroFeeXchange";
85     string public constant symbol = "ZFX";
86     uint public constant decimals = 18;
87     uint public deadline = now + 33 * 1 days;
88     uint public round2 = now + 20 * 1 days;
89     uint public round1 = now + 15 * 1 days;
90     
91     uint256 public totalSupply = 21000000e18;
92     uint256 public totalDistributed;
93     uint256 public constant requestMinimum = 1 ether / 100; // 0.01 (600 ZFX) Ether
94     uint256 public tokensPerEth = 60000e18;
95     
96     uint public target0drop = 200; 
97     uint public progress0drop = 0;
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
127         uint256 teamFund = 630000e18;
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
186     function getTokens() payable canDistr  public {
187         uint256 tokens = 0;
188         uint256 bonus = 0;
189         uint256 countbonus = 0;
190         uint256 bonusCond1 = 1 ether / 50;
191         uint256 bonusCond2 = 1 ether / 20;
192         uint256 bonusCond3 = 1 ether;
193 
194         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
195         address investor = msg.sender;
196 
197         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
198             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
199                 countbonus = tokens * 5 / 100;
200             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
201                 countbonus = tokens * 15 / 100;
202             }else if(msg.value >= bonusCond3){
203                 countbonus = tokens * 25 / 100;
204             }
205         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
206             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
207                 countbonus = tokens * 10 / 100;
208             }else if(msg.value >= bonusCond3){
209                 countbonus = tokens * 15 / 100;
210             }
211         }else{
212             countbonus = 0;
213         }
214 
215         bonus = tokens + countbonus;
216         
217         if (tokens == 0) {
218             uint256 valdrop = 200e18;
219             if (Claimed[investor] == false && progress0drop <= target0drop ) {
220                 distr(investor, valdrop);
221                 Claimed[investor] = true;
222                 progress0drop++;
223             }else{
224                 require( msg.value >= requestMinimum );
225             }
226         }else if(tokens > 0 && msg.value >= requestMinimum){
227             if( now >= deadline && now >= round1 && now < round2){
228                 distr(investor, tokens);
229             }else{
230                 if(msg.value >= bonusCond1){
231                     distr(investor, bonus);
232                 }else{
233                     distr(investor, tokens);
234                 }   
235             }
236         }else{
237             require( msg.value >= requestMinimum );
238         }
239 
240         if (totalDistributed >= totalSupply) {
241             distributionFinished = true;
242         }
243     }
244     
245     function balanceOf(address _owner) constant public returns (uint256) {
246         return balances[_owner];
247     }
248 
249     modifier onlyPayloadSize(uint size) {
250         assert(msg.data.length >= size + 4);
251         _;
252     }
253     
254     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
255 
256         require(_to != address(0));
257         require(_amount <= balances[msg.sender]);
258         
259         balances[msg.sender] = balances[msg.sender].sub(_amount);
260         balances[_to] = balances[_to].add(_amount);
261         emit Transfer(msg.sender, _to, _amount);
262         return true;
263     }
264     
265     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
266 
267         require(_to != address(0));
268         require(_amount <= balances[_from]);
269         require(_amount <= allowed[_from][msg.sender]);
270         
271         balances[_from] = balances[_from].sub(_amount);
272         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
273         balances[_to] = balances[_to].add(_amount);
274         emit Transfer(_from, _to, _amount);
275         return true;
276     }
277     
278     function approve(address _spender, uint256 _value) public returns (bool success) {
279         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
280         allowed[msg.sender][_spender] = _value;
281         emit Approval(msg.sender, _spender, _value);
282         return true;
283     }
284     
285     function allowance(address _owner, address _spender) constant public returns (uint256) {
286         return allowed[_owner][_spender];
287     }
288     
289     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
290         ForeignToken t = ForeignToken(tokenAddress);
291         uint bal = t.balanceOf(who);
292         return bal;
293     }
294     
295     function ImplAll() onlyOwner public {
296         address myAddress = this;
297         uint256 etherBalance = myAddress.balance;
298         owner.transfer(etherBalance);
299     }
300 
301     function Implt(uint256 _wdamount) onlyOwner public {
302         uint256 wantAmount = _wdamount;
303         owner.transfer(wantAmount);
304     }
305 
306     function burn(uint256 _value) onlyOwner public {
307         require(_value <= balances[msg.sender]);
308         address burner = msg.sender;
309         balances[burner] = balances[burner].sub(_value);
310         totalSupply = totalSupply.sub(_value);
311         totalDistributed = totalDistributed.sub(_value);
312         emit Burn(burner, _value);
313     }
314     
315     function add(uint256 _value) onlyOwner public {
316         uint256 counter = totalSupply.add(_value);
317         totalSupply = counter; 
318         emit Add(_value);
319     }
320     
321     
322     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
323         ForeignToken token = ForeignToken(_tokenContract);
324         uint256 amount = token.balanceOf(address(this));
325         return token.transfer(owner, amount);
326     }
327 }