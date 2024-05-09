1 /**
2 --------------------------------------------------------------------------------
3 The NEW CHOICEMINING Token Smart Contract
4 
5 Choicemining (CMI)
6 
7 MIT Licence
8 --------------------------------------------------------------------------------
9 */
10 
11 pragma solidity ^0.4.24;
12 
13 /**
14  * @title SafeMath
15  * @dev Math operations with safety checks that throw on error
16  */
17 library SafeMath {
18 
19     /**
20     * @dev Multiplies two numbers, throws on overflow.
21     */
22     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
23         if (a == 0) {
24             return 0;
25         }
26         c = a * b;
27         assert(c / a == b);
28         return c;
29     }
30 
31     /**
32     * @dev Integer division of two numbers, truncating the quotient.
33     */
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         // assert(b > 0); // Solidity automatically throws when dividing by 0
36         // uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38         return a / b;
39     }
40 
41     /**
42     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
43     */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         assert(b <= a);
46         return a - b;
47     }
48 
49     /**
50     * @dev Adds two numbers, throws on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
53         c = a + b;
54         assert(c >= a);
55         return c;
56     }
57 }
58 
59 contract ForeignToken {
60     function balanceOf(address _owner) constant public returns (uint256);
61     function transfer(address _to, uint256 _value) public returns (bool);
62 }
63 
64 contract ERC20Basic {
65     uint256 public totalSupply;
66     function balanceOf(address who) public constant returns (uint256);
67     function transfer(address to, uint256 value) public returns (bool);
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 
71 contract ERC20 is ERC20Basic {
72     function allowance(address owner, address spender) public constant returns (uint256);
73     function transferFrom(address from, address to, uint256 value) public returns (bool);
74     function approve(address spender, uint256 value) public returns (bool);
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 contract Choicemining is ERC20 {
79     
80     using SafeMath for uint256;
81     address owner = msg.sender;
82 
83     mapping (address => uint256) balances;
84     mapping (address => mapping (address => uint256)) allowed;
85     mapping (address => bool) public Claimed; 
86 
87     string public constant name = "Choice Mining";
88     string public constant symbol = "CMI";
89     uint public constant decimals = 18;
90     uint public deadline = now + 25 * 1 days;
91     uint public round2 = now + 20 * 1 days;
92     uint public round1 = now + 15 * 1 days;
93     
94     uint256 public totalSupply = 11000000e18;
95     uint256 public totalDistributed;
96     uint256 public constant requestMinimum = 1 ether / 50; // 0.01 Ether
97     uint256 public tokensPerEth = 25000e18;
98     
99     uint public target0drop = 4500;
100     uint public progress0drop = 0;
101 
102 
103     event Transfer(address indexed _from, address indexed _to, uint256 _value);
104     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
105     
106     event Distr(address indexed to, uint256 amount);
107     event DistrFinished();
108     
109     event Airdrop(address indexed _owner, uint _amount, uint _balance);
110 
111     event TokensPerEthUpdated(uint _tokensPerEth);
112     
113     event Burn(address indexed burner, uint256 value);
114     
115     event Add(uint256 value);
116 
117     bool public distributionFinished = false;
118     
119     modifier canDistr() {
120         require(!distributionFinished);
121         _;
122     }
123     
124     modifier onlyOwner() {
125         require(msg.sender == owner);
126         _;
127     }
128     
129     constructor() public {
130         uint256 teamFund = 2000000e18;
131         owner = msg.sender;
132         distr(owner, teamFund);
133     }
134     
135     function transferOwnership(address newOwner) onlyOwner public {
136         if (newOwner != address(0)) {
137             owner = newOwner;
138         }
139     }
140 
141     function finishDistribution() onlyOwner canDistr public returns (bool) {
142         distributionFinished = true;
143         emit DistrFinished();
144         return true;
145     }
146     
147     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
148         totalDistributed = totalDistributed.add(_amount);        
149         balances[_to] = balances[_to].add(_amount);
150         emit Distr(_to, _amount);
151         emit Transfer(address(0), _to, _amount);
152 
153         return true;
154     }
155     
156     function Distribute(address _participant, uint _amount) onlyOwner internal {
157 
158         require( _amount > 0 );      
159         require( totalDistributed < totalSupply );
160         balances[_participant] = balances[_participant].add(_amount);
161         totalDistributed = totalDistributed.add(_amount);
162 
163         if (totalDistributed >= totalSupply) {
164             distributionFinished = true;
165         }
166 
167         // log
168         emit Airdrop(_participant, _amount, balances[_participant]);
169         emit Transfer(address(0), _participant, _amount);
170     }
171     
172     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
173         Distribute(_participant, _amount);
174     }
175 
176     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
177         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
178     }
179 
180     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
181         tokensPerEth = _tokensPerEth;
182         emit TokensPerEthUpdated(_tokensPerEth);
183     }
184            
185     function () external payable {
186         getTokens();
187      }
188 
189     function getTokens() payable canDistr  public {
190         uint256 tokens = 0;
191         uint256 bonus = 0;
192         uint256 countbonus = 0;
193         uint256 bonusCond1 = 1 ether / 10;
194         uint256 bonusCond2 = 1 ether / 2;
195         uint256 bonusCond3 = 1 ether;
196 
197         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
198         address investor = msg.sender;
199 
200 		if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
201             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
202                 countbonus = 0;
203             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
204                 countbonus = 0;
205             }else if(msg.value >= bonusCond3){
206                 countbonus = 0;
207             }
208         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
209             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
210                 countbonus = 0;
211             }else if(msg.value >= bonusCond3){
212                 countbonus = 0;
213             }
214         }else{
215             countbonus = 0;
216         }
217 
218         bonus = tokens + countbonus;
219         
220         if (tokens == 0) {
221             uint256 valdrop = 55e18;
222             if (Claimed[investor] == false && progress0drop <= target0drop ) {
223                 distr(investor, valdrop);
224                 Claimed[investor] = true;
225                 progress0drop++;
226             }else{
227                 require( msg.value >= requestMinimum );
228             }
229         }else if(tokens > 0 && msg.value >= requestMinimum){
230             if( now >= deadline && now >= round1 && now < round2){
231                 distr(investor, tokens);
232             }else{
233                 if(msg.value >= bonusCond1){
234                     distr(investor, bonus);
235                 }else{
236                     distr(investor, tokens);
237                 }   
238             }
239         }else{
240             require( msg.value >= requestMinimum );
241         }
242 
243         if (totalDistributed >= totalSupply) {
244             distributionFinished = true;
245         }
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