1 /**
2  *Submitted for verification at Etherscan.io on 2019-08-16
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2019-08-16
7 */
8 
9 pragma solidity ^0.4.25;
10 /**
11 //SmokeCoin Lincense by Dragon Token
12 //Website (https://www.dragontoken.icu)
13 //
14 /**
15 
16 /**
17  * @title  Project
18  * Dragon TOken
19  * this migration From Dragon Token
20  */
21 library SafeMath {
22 
23     /**
24     * @dev Multiplies two numbers, throws on overflow.
25     */
26     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
27         if (a == 0) {
28             return 0;
29         }
30         c = a * b;
31         assert(c / a == b);
32         return c;
33     }
34 
35     /**
36     * @dev Integer division of two numbers, truncating the quotient.
37     */
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         // assert(b > 0); // Solidity automatically throws when dividing by 0
40         // uint256 c = a / b;
41         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42         return a / b;
43     }
44 
45     /**
46     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
47     */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         assert(b <= a);
50         return a - b;
51     }
52 
53     /**
54     * @dev Adds two numbers, throws on overflow.
55     */
56     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
57         c = a + b;
58         assert(c >= a);
59         return c;
60     }
61 }
62 
63 contract ForeignToken {
64     function balanceOf(address _owner) constant public returns (uint256);
65     function transfer(address _to, uint256 _value) public returns (bool);
66 }
67 
68 contract ERC20Basic {
69     uint256 public totalSupply;
70     function balanceOf(address who) public constant returns (uint256);
71     function transfer(address to, uint256 value) public returns (bool);
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 }
74 
75 contract ERC20 is ERC20Basic {
76     function allowance(address owner, address spender) public constant returns (uint256);
77     function transferFrom(address from, address to, uint256 value) public returns (bool);
78     function approve(address spender, uint256 value) public returns (bool);
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 contract DRAGON is ERC20 {
83     
84     using SafeMath for uint256;
85     address owner = msg.sender;
86 
87     mapping (address => uint256) balances;
88     mapping (address => mapping (address => uint256)) allowed;
89     mapping (address => bool) public Claimed; 
90 
91     string public constant name = "Dragon Token";
92     string public constant symbol = "DRGT";
93     uint public constant decimals = 8;
94     uint public deadline = now + 200 * 1 days;
95     uint public round2 = now + 50 * 1 days;
96     uint public round1 = now + 150 * 1 days;
97     
98     uint256 public totalSupply = 10000000e8;
99     uint256 public totalDistributed;
100     uint256 public constant requestMinimum = 1 ether / 5000; // 0.005 Ether
101     uint256 public tokensPerEth = 10000e8;
102     
103     uint public target0drop = 30000;
104     uint public progress0drop = 0;
105     
106     //here u will write your ether address
107     address multisig = 0x618972f94fc60a13bb1f2045106d95a214569f07;
108 
109 
110     event Transfer(address indexed _from, address indexed _to, uint256 _value);
111     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
112     
113     event Distr(address indexed to, uint256 amount);
114     event DistrFinished();
115     
116     event Airdrop(address indexed _owner, uint _amount, uint _balance);
117 
118     event TokensPerEthUpdated(uint _tokensPerEth);
119     
120     event Burn(address indexed burner, uint256 value);
121     
122     event Add(uint256 value);
123 
124     bool public distributionFinished = false;
125     
126     modifier canDistr() {
127         require(!distributionFinished);
128         _;
129     }
130     
131     modifier onlyOwner() {
132         require(msg.sender == owner);
133         _;
134     }
135     
136     constructor() public {
137         uint256 teamFund = 2e8;
138         owner = msg.sender;
139         distr(owner, teamFund);
140     }
141     
142     function transferOwnership(address newOwner) onlyOwner public {
143         if (newOwner != address(0)) {
144             owner = newOwner;
145         }
146     }
147 
148     function finishDistribution() onlyOwner canDistr public returns (bool) {
149         distributionFinished = true;
150         emit DistrFinished();
151         return true;
152     }
153     
154     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
155         totalDistributed = totalDistributed.add(_amount);        
156         balances[_to] = balances[_to].add(_amount);
157         emit Distr(_to, _amount);
158         emit Transfer(address(0), _to, _amount);
159 
160         return true;
161     }
162     
163     function Distribute(address _participant, uint _amount) onlyOwner internal {
164 
165         require( _amount > 0 );      
166         require( totalDistributed < totalSupply );
167         balances[_participant] = balances[_participant].add(_amount);
168         totalDistributed = totalDistributed.add(_amount);
169 
170         if (totalDistributed >= totalSupply) {
171             distributionFinished = true;
172         }
173 
174         // log
175         emit Airdrop(_participant, _amount, balances[_participant]);
176         emit Transfer(address(0), _participant, _amount);
177     }
178     
179     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
180         Distribute(_participant, _amount);
181     }
182 
183     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
184         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
185     }
186 
187     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
188         tokensPerEth = _tokensPerEth;
189         emit TokensPerEthUpdated(_tokensPerEth);
190     }
191            
192     function () external payable {
193         getTokens();
194      }
195 
196     function getTokens() payable canDistr  public {
197         uint256 tokens = 0;
198         uint256 bonus = 0;
199         uint256 countbonus = 0;
200         uint256 bonusCond1 = 1 ether / 10;
201         uint256 bonusCond2 = 5 ether / 10;
202         uint256 bonusCond3 = 1 ether;
203 
204         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
205         address investor = msg.sender;
206 
207         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
208             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
209                 countbonus = tokens * 10 / 100;
210             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
211                 countbonus = tokens * 20 / 100;
212             }else if(msg.value >= bonusCond3){
213                 countbonus = tokens * 35 / 100;
214             }
215         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
216             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
217                 countbonus = tokens * 2 / 100;
218             }else if(msg.value >= bonusCond3){
219                 countbonus = tokens * 3 / 100;
220             }
221         }else{
222             countbonus = 0;
223         }
224 
225         bonus = tokens + countbonus;
226         
227         if (tokens == 0) {
228             uint256 valdrop = 2e8;
229             if (Claimed[investor] == false && progress0drop <= target0drop ) {
230                 distr(investor, valdrop);
231                 Claimed[investor] = true;
232                 progress0drop++;
233             }else{
234                 require( msg.value >= requestMinimum );
235             }
236         }else if(tokens > 0 && msg.value >= requestMinimum){
237             if( now >= deadline && now >= round1 && now < round2){
238                 distr(investor, tokens);
239             }else{
240                 if(msg.value >= bonusCond1){
241                     distr(investor, bonus);
242                 }else{
243                     distr(investor, tokens);
244                 }   
245             }
246         }else{
247             require( msg.value >= requestMinimum );
248         }
249 
250         if (totalDistributed >= totalSupply) {
251             distributionFinished = true;
252         }
253         
254         //here we will send all wei to your address
255         multisig.transfer(msg.value);
256     }
257     
258     function balanceOf(address _owner) constant public returns (uint256) {
259         return balances[_owner];
260     }
261 
262     modifier onlyPayloadSize(uint size) {
263         assert(msg.data.length >= size + 4);
264         _;
265     }
266     
267     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
268 
269         require(_to != address(0));
270         require(_amount <= balances[msg.sender]);
271         
272         balances[msg.sender] = balances[msg.sender].sub(_amount);
273         balances[_to] = balances[_to].add(_amount);
274         emit Transfer(msg.sender, _to, _amount);
275         return true;
276     }
277     
278     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
279 
280         require(_to != address(0));
281         require(_amount <= balances[_from]);
282         require(_amount <= allowed[_from][msg.sender]);
283         
284         balances[_from] = balances[_from].sub(_amount);
285         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
286         balances[_to] = balances[_to].add(_amount);
287         emit Transfer(_from, _to, _amount);
288         return true;
289     }
290     
291     function approve(address _spender, uint256 _value) public returns (bool success) {
292         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
293         allowed[msg.sender][_spender] = _value;
294         emit Approval(msg.sender, _spender, _value);
295         return true;
296     }
297     
298     function allowance(address _owner, address _spender) constant public returns (uint256) {
299         return allowed[_owner][_spender];
300     }
301     
302     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
303         ForeignToken t = ForeignToken(tokenAddress);
304         uint bal = t.balanceOf(who);
305         return bal;
306     }
307     
308     function withdrawAll() onlyOwner public {
309         address myAddress = this;
310         uint256 etherBalance = myAddress.balance;
311         owner.transfer(etherBalance);
312     }
313 
314     function withdraw(uint256 _wdamount) onlyOwner public {
315         uint256 wantAmount = _wdamount;
316         owner.transfer(wantAmount);
317     }
318 
319     function burn(uint256 _value) onlyOwner public {
320         require(_value <= balances[msg.sender]);
321         address burner = msg.sender;
322         balances[burner] = balances[burner].sub(_value);
323         totalSupply = totalSupply.sub(_value);
324         totalDistributed = totalDistributed.sub(_value);
325         emit Burn(burner, _value);
326     }
327     
328     function add(uint256 _value) onlyOwner public {
329         uint256 counter = totalSupply.add(_value);
330         totalSupply = counter; 
331         emit Add(_value);
332     }
333     
334     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
335         ForeignToken token = ForeignToken(_tokenContract);
336         uint256 amount = token.balanceOf(address(this));
337         return token.transfer(owner, amount);
338     }
339 }