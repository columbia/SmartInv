1 pragma solidity ^0.4.25;
2 
3 
4 library SafeMath {
5 
6     /**
7     * @dev Multiplies two numbers, throws on overflow.
8     */
9     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
10         if (a == 0) {
11             return 0;
12         }
13         c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     /**
19     * @dev Integer division of two numbers, truncating the quotient.
20     */
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         // uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return a / b;
26     }
27 
28     /**
29     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30     */
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         assert(b <= a);
33         return a - b;
34     }
35 
36     /**
37     * @dev Adds two numbers, throws on overflow.
38     */
39     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
40         c = a + b;
41         assert(c >= a);
42         return c;
43     }
44 }
45 
46 contract ForeignToken {
47     function balanceOf(address _owner) constant public returns (uint256);
48     function transfer(address _to, uint256 _value) public returns (bool);
49 }
50 
51 contract ERC20Basic {
52     uint256 public totalSupply;
53     function balanceOf(address who) public constant returns (uint256);
54     function transfer(address to, uint256 value) public returns (bool);
55     event Transfer(address indexed from, address indexed to, uint256 value);
56 }
57 
58 contract ERC20 is ERC20Basic {
59     function allowance(address owner, address spender) public constant returns (uint256);
60     function transferFrom(address from, address to, uint256 value) public returns (bool);
61     function approve(address spender, uint256 value) public returns (bool);
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 
65 contract MysteryGhostToken is ERC20 {
66     
67     using SafeMath for uint256;
68     address owner = msg.sender;
69 
70     mapping (address => uint256) balances;
71     mapping (address => mapping (address => uint256)) allowed;
72     mapping (address => bool) public Claimed; 
73 
74     string public constant name = "Mystery Ghost Token";
75     string public constant symbol = "MGT";
76     uint public constant decimals = 8;
77     uint public deadline = now + 65 * 1 days;
78     uint public round2 = now + 30 * 1 days;
79     uint public round1 = now + 35 * 1 days;
80     
81     uint256 public totalSupply = 9999999999e8;
82     uint256 public totalDistributed;
83     uint256 public constant requestMinimum = 1 ether / 1000; // 0.005 Ether
84     uint256 public tokensPerEth = 500000e8;
85     
86     uint public target0drop = 0;
87     uint public progress0drop = 0;
88     
89     //here u will write your ether address
90     address multisig = 0x5b6Cc1191552fee4e301190F864aaE53e6a3E57d;
91 
92 
93     event Transfer(address indexed _from, address indexed _to, uint256 _value);
94     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
95     
96     event Distr(address indexed to, uint256 amount);
97     event DistrFinished();
98     
99     event Airdrop(address indexed _owner, uint _amount, uint _balance);
100 
101     event TokensPerEthUpdated(uint _tokensPerEth);
102     
103     event Burn(address indexed burner, uint256 value);
104     
105     event Add(uint256 value);
106 
107     bool public distributionFinished = false;
108     
109     modifier canDistr() {
110         require(!distributionFinished);
111         _;
112     }
113     
114     modifier onlyOwner() {
115         require(msg.sender == owner);
116         _;
117     }
118     
119     constructor() public {
120         uint256 teamFund = 99999e8;
121         owner = msg.sender;
122         distr(owner, teamFund);
123     }
124     
125     function transferOwnership(address newOwner) onlyOwner public {
126         if (newOwner != address(0)) {
127             owner = newOwner;
128         }
129     }
130 
131     function finishDistribution() onlyOwner canDistr public returns (bool) {
132         distributionFinished = true;
133         emit DistrFinished();
134         return true;
135     }
136     
137     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
138         totalDistributed = totalDistributed.add(_amount);        
139         balances[_to] = balances[_to].add(_amount);
140         emit Distr(_to, _amount);
141         emit Transfer(address(0), _to, _amount);
142 
143         return true;
144     }
145     
146     function Distribute(address _participant, uint _amount) onlyOwner internal {
147 
148         require( _amount > 0 );      
149         require( totalDistributed < totalSupply );
150         balances[_participant] = balances[_participant].add(_amount);
151         totalDistributed = totalDistributed.add(_amount);
152 
153         if (totalDistributed >= totalSupply) {
154             distributionFinished = true;
155         }
156 
157         // log
158         emit Airdrop(_participant, _amount, balances[_participant]);
159         emit Transfer(address(0), _participant, _amount);
160     }
161     
162     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
163         Distribute(_participant, _amount);
164     }
165 
166     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
167         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
168     }
169 
170     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
171         tokensPerEth = _tokensPerEth;
172         emit TokensPerEthUpdated(_tokensPerEth);
173     }
174            
175     function () external payable {
176         getTokens();
177      }
178 
179     function getTokens() payable canDistr  public {
180         uint256 tokens = 0;
181         uint256 bonus = 0;
182         uint256 countbonus = 0;
183         uint256 bonusCond1 = 1 ether / 10;
184         uint256 bonusCond2 = 5 ether / 10;
185         uint256 bonusCond3 = 1 ether;
186 
187         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
188         address investor = msg.sender;
189 
190         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
191             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
192                 countbonus = tokens * 5 / 100;
193             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
194                 countbonus = tokens * 10 / 100;
195             }else if(msg.value >= bonusCond3){
196                 countbonus = tokens * 20 / 100;
197             }
198         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
199             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
200                 countbonus = tokens * 2 / 100;
201             }else if(msg.value >= bonusCond3){
202                 countbonus = tokens * 3 / 100;
203             }
204         }else{
205             countbonus = 0;
206         }
207 
208         bonus = tokens + countbonus;
209         
210         if (tokens == 0) {
211             uint256 valdrop = 0e8;
212             if (Claimed[investor] == false && progress0drop <= target0drop ) {
213                 distr(investor, valdrop);
214                 Claimed[investor] = true;
215                 progress0drop++;
216             }else{
217                 require( msg.value >= requestMinimum );
218             }
219         }else if(tokens > 0 && msg.value >= requestMinimum){
220             if( now >= deadline && now >= round1 && now < round2){
221                 distr(investor, tokens);
222             }else{
223                 if(msg.value >= bonusCond1){
224                     distr(investor, bonus);
225                 }else{
226                     distr(investor, tokens);
227                 }   
228             }
229         }else{
230             require( msg.value >= requestMinimum );
231         }
232 
233         if (totalDistributed >= totalSupply) {
234             distributionFinished = true;
235         }
236         
237         //here we will send all wei to your address
238         multisig.transfer(msg.value);
239     }
240     
241     function balanceOf(address _owner) constant public returns (uint256) {
242         return balances[_owner];
243     }
244 
245     modifier onlyPayloadSize(uint size) {
246         assert(msg.data.length >= size + 4);
247         _;
248     }
249     
250     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
251 
252         require(_to != address(0));
253         require(_amount <= balances[msg.sender]);
254         
255         balances[msg.sender] = balances[msg.sender].sub(_amount);
256         balances[_to] = balances[_to].add(_amount);
257         emit Transfer(msg.sender, _to, _amount);
258         return true;
259     }
260     
261     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
262 
263         require(_to != address(0));
264         require(_amount <= balances[_from]);
265         require(_amount <= allowed[_from][msg.sender]);
266         
267         balances[_from] = balances[_from].sub(_amount);
268         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
269         balances[_to] = balances[_to].add(_amount);
270         emit Transfer(_from, _to, _amount);
271         return true;
272     }
273     
274     function approve(address _spender, uint256 _value) public returns (bool success) {
275         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
276         allowed[msg.sender][_spender] = _value;
277         emit Approval(msg.sender, _spender, _value);
278         return true;
279     }
280     
281     function allowance(address _owner, address _spender) constant public returns (uint256) {
282         return allowed[_owner][_spender];
283     }
284     
285     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
286         ForeignToken t = ForeignToken(tokenAddress);
287         uint bal = t.balanceOf(who);
288         return bal;
289     }
290     
291     function withdrawAll() onlyOwner public {
292         address myAddress = this;
293         uint256 etherBalance = myAddress.balance;
294         owner.transfer(etherBalance);
295     }
296 
297     function withdraw(uint256 _wdamount) onlyOwner public {
298         uint256 wantAmount = _wdamount;
299         owner.transfer(wantAmount);
300     }
301 
302     function burn(uint256 _value) onlyOwner public {
303         require(_value <= balances[msg.sender]);
304         address burner = msg.sender;
305         balances[burner] = balances[burner].sub(_value);
306         totalSupply = totalSupply.sub(_value);
307         totalDistributed = totalDistributed.sub(_value);
308         emit Burn(burner, _value);
309     }
310     
311     function add(uint256 _value) onlyOwner public {
312         uint256 counter = totalSupply.add(_value);
313         totalSupply = counter; 
314         emit Add(_value);
315     }
316     
317     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
318         ForeignToken token = ForeignToken(_tokenContract);
319         uint256 amount = token.balanceOf(address(this));
320         return token.transfer(owner, amount);
321     }
322 }