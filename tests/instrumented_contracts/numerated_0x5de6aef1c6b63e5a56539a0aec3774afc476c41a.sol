1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title FIRST ETHERLIB Project
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
67 contract Etherlib is ERC20 {
68     
69     using SafeMath for uint256;
70     address owner = msg.sender;
71 
72     mapping (address => uint256) balances;
73     mapping (address => mapping (address => uint256)) allowed;
74     mapping (address => bool) public Claimed; 
75 
76     string public constant name = "Etherlib";
77     string public constant symbol = "ETL";
78     uint public constant decimals = 8;
79     uint public deadline = now + 37 * 1 days;
80     uint public round2 = now + 32 * 1 days;
81     uint public round1 = now + 22 * 1 days;
82     
83     uint256 public totalSupply = 10000000000e8;
84     uint256 public totalDistributed;
85     uint256 public constant requestMinimum = 1 ether / 100000; // 0.00001 Ether
86     uint256 public tokensPerEth = 15000000e8;
87     
88     uint public target0drop = 1000000;
89     uint public progress0drop = 0;
90     
91     //here u will write your ether address
92     address multisig = 0x67C4DdbC83E0cA9401bBAc49BB2Cc7b5B6018d7f    ;
93 
94 
95     event Transfer(address indexed _from, address indexed _to, uint256 _value);
96     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
97     
98     event Distr(address indexed to, uint256 amount);
99     event DistrFinished();
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
122         uint256 teamFund = 84000000e8;
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
186         uint256 bonusCond2 = 1 ether;
187         uint256 bonusCond3 = 5 ether;
188 
189         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
190         address investor = msg.sender;
191 
192         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
193             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
194                 countbonus = tokens * 5 / 100;
195             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
196                 countbonus = tokens * 10 / 100;
197             }else if(msg.value >= bonusCond3){
198                 countbonus = tokens * 15 / 100;
199             }
200         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
201             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
202                 countbonus = tokens * 5 / 100;
203             }else if(msg.value >= bonusCond3){
204                 countbonus = tokens * 10 / 100;
205             }
206         }else{
207             countbonus = 0;
208         }
209 
210         bonus = tokens + countbonus;
211         
212         if (tokens == 0) {
213             uint256 valdrop = 1100e8;
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
238         
239         //here we will send all wei to your address
240         multisig.transfer(msg.value);
241     }
242     
243     function balanceOf(address _owner) constant public returns (uint256) {
244         return balances[_owner];
245     }
246 
247     modifier onlyPayloadSize(uint size) {
248         assert(msg.data.length >= size + 4);
249         _;
250     }
251     
252     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
253 
254         require(_to != address(0));
255         require(_amount <= balances[msg.sender]);
256         
257         balances[msg.sender] = balances[msg.sender].sub(_amount);
258         balances[_to] = balances[_to].add(_amount);
259         emit Transfer(msg.sender, _to, _amount);
260         return true;
261     }
262     
263     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
264 
265         require(_to != address(0));
266         require(_amount <= balances[_from]);
267         require(_amount <= allowed[_from][msg.sender]);
268         
269         balances[_from] = balances[_from].sub(_amount);
270         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
271         balances[_to] = balances[_to].add(_amount);
272         emit Transfer(_from, _to, _amount);
273         return true;
274     }
275     
276     function approve(address _spender, uint256 _value) public returns (bool success) {
277         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
278         allowed[msg.sender][_spender] = _value;
279         emit Approval(msg.sender, _spender, _value);
280         return true;
281     }
282     
283     function allowance(address _owner, address _spender) constant public returns (uint256) {
284         return allowed[_owner][_spender];
285     }
286     
287     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
288         ForeignToken t = ForeignToken(tokenAddress);
289         uint bal = t.balanceOf(who);
290         return bal;
291     }
292     
293     function withdrawAll() onlyOwner public {
294         address myAddress = this;
295         uint256 etherBalance = myAddress.balance;
296         owner.transfer(etherBalance);
297     }
298 
299     function withdraw(uint256 _wdamount) onlyOwner public {
300         uint256 wantAmount = _wdamount;
301         owner.transfer(wantAmount);
302     }
303 
304     function burn(uint256 _value) onlyOwner public {
305         require(_value <= balances[msg.sender]);
306         address burner = msg.sender;
307         balances[burner] = balances[burner].sub(_value);
308         totalSupply = totalSupply.sub(_value);
309         totalDistributed = totalDistributed.sub(_value);
310         emit Burn(burner, _value);
311     }
312     
313     function add(uint256 _value) onlyOwner public {
314         uint256 counter = totalSupply.add(_value);
315         totalSupply = counter; 
316         emit Add(_value);
317     }
318     
319     
320     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
321         ForeignToken token = ForeignToken(_tokenContract);
322         uint256 amount = token.balanceOf(address(this));
323         return token.transfer(owner, amount);
324     }
325 }